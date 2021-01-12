using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text.RegularExpressions;
using System.Text;

namespace CustomAssembler
{
    public enum ErrorType
    {
        None,
        CouldNotParse,
        UnknownOpcode,
        UnknownSymbol
    }

    class Program
    {

        public static Regex instruction = new Regex(@"[a-zA-Z]+(( )+(\*)?((?<a>[0-9]+|[0-9a-zA-Z_]{3,})|[a-zA-Z]{1,2}))?(,( )*(\*)?((?<b>[0-9]+|[0-9a-zA-Z_]{3,})|[a-zA-Z]{1,2}))?$");
        public static Regex memoryLoc = new Regex(@"<(?<a>[0-9]+)>");



        static void Main(string[] args)
        {
            Instruction.LoadInstructionSet("instructions.txt");
            Assembly a = new Assembly();
            a.Assemble(File.ReadAllLines(args[0]));
            a.Print();
            a.WriteToFile("assembly.bin");

        }


    }

    class Assembly
    {
        public ushort[] memory = new ushort[1 << 16];
        public int curMemIndex = 0;
        public Dictionary<string, Label> labels = new Dictionary<string, Label>();

        private int highestWrittenAddr;

        public void Assemble(string[] lines)
        {

            int i = 0;
            foreach (string line in lines)
            {
                string prep = Preprocess(line);
                if (string.IsNullOrEmpty(prep)) { i++; continue; }

                ErrorType errorType = ErrorType.None;
                bool parsed = false;
                parsed = Instruction.Parse(this, prep, out errorType);
                if (!parsed) parsed = MemoryAddress.Parse(this, prep, out errorType);
                if (!parsed) parsed = LabelParser.Parse(this, prep, out errorType);
                if (!parsed) parsed = DataParser.Parse(this, prep, out errorType);
                if (!parsed) parsed = DefineParser.Parse(this, prep, out errorType);


                if (!parsed) errorType = ErrorType.CouldNotParse;

                if (errorType != ErrorType.None)
                {
                    Console.WriteLine(errorType.ToString());
                    Console.WriteLine("Error at line {0}: {1}", i, line);
                    Console.WriteLine();
                }
                i++;
            }

            foreach (var l in labels)
            {
                if (l.Value.defined) continue;

                Console.WriteLine("Undefined Label: {0}", l.Key);
            }

            ;
        }



        public void Add(ushort value)
        {
            memory[curMemIndex++] = value;
            if (curMemIndex > highestWrittenAddr) highestWrittenAddr = curMemIndex;
        }

        public void AddRange(IEnumerable<ushort> values)
        {
            foreach (ushort value in values)
                memory[curMemIndex++] = value;

            if (curMemIndex > highestWrittenAddr) highestWrittenAddr = curMemIndex;
        }

        public void WriteToFile(string path, bool complete = false)
        {
            if (File.Exists(path)) File.Delete(path);

            FileStream fs = new FileStream(path, FileMode.CreateNew);

            for (int i = 0; i < (complete ? memory.Length : highestWrittenAddr); i++)
                fs.Write(BitConverter.GetBytes(memory[i]), 0, 2);

            fs.Close();
        }

        public void Print()
        {


            for (int i = 0; i < highestWrittenAddr; i++)
            {
                Console.Write(Convert.ToString(i, 2));
                Console.Write(" : ");
                Console.WriteLine(Convert.ToString(memory[i], 2));
            }

        }


        static string Preprocess(string line)
        {
            int index = line.IndexOf(';');

            int temp = line.IndexOf("//");
            if (temp != -1)
                index = Math.Min(index, temp);

            temp = line.IndexOf('#');
            if (temp != -1)
                index = Math.Min(index, temp);

            if (index != -1)
                line = line.Remove(index);

            line = line.Trim();

            return line;
        }
    }


    static class Instruction
    {
        static readonly Regex regex = new Regex(@"^[a-zA-Z]+(( )+(\*)?((?<a>[0-9]+|[0-9a-zA-Z_]{3,})|[a-zA-Z0-9]{1,2}))?(,( )*(\*)?((?<b>[0-9]+|[0-9a-zA-Z_]{3,})|[a-zA-Z0-9]{1,2}))?$");
        static readonly string[] groups = { "a", "b" };

        static Dictionary<string, ushort> instructionSet = new Dictionary<string, ushort>();

        public static bool Parse(Assembly a, string line, out ErrorType error)
        {
            error = ErrorType.None;
            ushort directLiteral = 0x0; //opcode length is 10bits, but instruction register can store 16bits. The last 6 bits can be used to encode an immediate literal. The very last bit is connected to bus15, the sign bit.
            var q = regex.Match(line);
            int indexOffset = 0;
            if (q.Success)
            {
                string instr = line;
                List<ushort> param = new List<ushort>();
                for (int j = 0; j < groups.Length; j++)
                {
                    var g = q.Groups[groups[j]];

                    if (g.Success)
                    {
                        ushort par;
                        if (!ushort.TryParse(g.Value, out par) || (g.Value.StartsWith("0x") && !ushort.TryParse(g.Value.Substring(2), System.Globalization.NumberStyles.HexNumber, System.Globalization.CultureInfo.CurrentCulture, out par)))
                        {
                            var label = Label.GetLabel(g.Value, a);

                            instr = instr.Remove(g.Index - indexOffset, g.Length);
                            var instrO = instr.Insert(g.Index - indexOffset, "#");

                            if (j == 0 && q.Groups[groups[1]].Success)
                                instrO = instrO.Replace(q.Groups[groups[1]].Value, "$");

                            if (!label.defined || label.value > 31 || !instructionSet.ContainsKey(instrO))
                            {
                                label.AddOccurence((ushort)(a.curMemIndex + param.Count + 1));
                                par = a.memory[a.curMemIndex + param.Count + 1];
                                instr = instr.Insert(g.Index - indexOffset, "$");
                            }
                            else
                            {
                                label.AddOccurence((ushort)(a.curMemIndex + param.Count), true);
                                par = label.value;
                                instr = instr.Insert(g.Index - indexOffset, "#");
                                indexOffset += g.Length - 1;
                                directLiteral = (ushort)(par << 10);
                                continue;
                            }


                        }
                        else
                        {
                            instr = instr.Remove(g.Index - indexOffset, g.Length);
                            if (par < 32)
                            {
                                var directAddrO = instr.Insert(g.Index - indexOffset, "#");
                                var directAddr = directAddrO;

                                if (j == 0 && q.Groups[groups[1]].Success)
                                    directAddr = directAddrO.Replace(q.Groups[groups[1]].Value, "$");


                                if (instructionSet.ContainsKey(directAddr))
                                {
                                    instr = directAddrO;
                                    indexOffset += g.Length - 1;
                                    directLiteral = (ushort)(par << 10);
                                    continue;
                                }
                            }
                            instr = instr.Insert(g.Index - indexOffset, "$");
                        }

                        
                        indexOffset += g.Length - 1;
                        param.Add(par);




                    }
                }

                ushort opcode;
                if (!instructionSet.TryGetValue(instr, out opcode))
                    error = ErrorType.UnknownOpcode;

                opcode = (ushort)(opcode | directLiteral);

                a.Add(opcode);
                a.AddRange(param);

                return true;
            }

            return false;
        }

        public static void LoadInstructionSet(string path)
        {
            string[] lines = File.ReadAllLines(path);

            for (int i = 0; i < lines.Length; i++)
            {
                instructionSet.Add(lines[i], (ushort)i);
            }
        }
    }


    static class MemoryAddress
    {
        static readonly Regex regex = new Regex(@"^<(?<a>[a-zA-Z0-9_]+)>$");
        static readonly string group = "a";

        public static bool Parse(Assembly a, string line, out ErrorType error)
        {
            error = ErrorType.None;

            var q = regex.Match(line);
            if (q.Success)
            {
                var g = q.Groups[group];

                if (g.Success)
                {
                    ushort add;

                    if (!ushort.TryParse(g.Value, out add) && (g.Value.StartsWith("0x") && !ushort.TryParse(g.Value.Substring(2), System.Globalization.NumberStyles.HexNumber, System.Globalization.CultureInfo.CurrentCulture, out add)))
                        Label.GetLabel(g.Value, a).AddOccurence((ushort)a.curMemIndex);
                    //error = ErrorType.UnknownSymbol;


                    a.curMemIndex = add;
                }

                return true;
            }
            return false;
        }
    }

    static class LabelParser
    {
        static readonly Regex regex = new Regex(@"^(?<a>[a-zA-Z0-9_]{3,}):$");
        static readonly string group = "a";

        public static bool Parse(Assembly a, string line, out ErrorType error)
        {
            error = ErrorType.None;

            var q = regex.Match(line);
            if (q.Success)
            {
                var g = q.Groups[group];

                if (g.Success)
                {
                    Label.GetLabel(g.Value, a).Define((ushort)a.curMemIndex);
                }

                return true;
            }
            return false;
        }
    }

    static class DataParser
    {
        static readonly Regex regex = new Regex(@"^(?<a>0x[a-fA-F0-9]+|[0-9]+)$");
        static readonly string group = "a";

        public static bool Parse(Assembly a, string line, out ErrorType error)
        {
            error = ErrorType.None;

            var q = regex.Match(line);
            if (q.Success)
            {
                var g = q.Groups[group];

                if (g.Success)
                {
                    ushort value;

                    if (!ushort.TryParse(g.Value, out value) && (g.Value.StartsWith("0x") && !ushort.TryParse(g.Value.Substring(2), System.Globalization.NumberStyles.HexNumber, System.Globalization.CultureInfo.CurrentCulture, out value)))
                        error = ErrorType.UnknownSymbol;

                    a.Add(value);
                }

                return true;
            }
            return false;
        }
    }

    static class DefineParser
    {
        static readonly Regex regex = new Regex(@"^(?<a>[a-zA-Z_][a-zA-Z0-9_]{2,}) *= *(?<b>0x[a-fA-F0-9]+|[0-9]+)$");


        public static bool Parse(Assembly a, string line, out ErrorType error)
        {
            error = ErrorType.None;

            var q = regex.Match(line);
            if (q.Success)
            {
                var gA = q.Groups["a"];
                var gB = q.Groups["b"];

                if (gA.Success && gB.Success)
                {
                    Label l = Label.GetLabel(gA.Value, a);

                    ushort value;

                    if (!ushort.TryParse(gB.Value, out value) && (gB.Value.StartsWith("0x") && !ushort.TryParse(gB.Value.Substring(2), System.Globalization.NumberStyles.HexNumber, System.Globalization.CultureInfo.CurrentCulture, out value)))
                        error = ErrorType.UnknownSymbol;

                    l.Define(value);
                }

                return true;
            }
            return false;
        }
    }

    class Label
    {
        public string name;
        public bool defined;
        public ushort value;
        public List<ushort> occurences = new List<ushort>();
        public List<bool> isDirect = new List<bool>();
        private Assembly assembly;

        public void AddOccurence(ushort addr, bool direct = false)
        {
            occurences.Add(addr);
            isDirect.Add(direct);
            if (defined)
            {
                if (!direct)
                    assembly.memory[addr] = value;
                else
                    assembly.memory[addr] |= (ushort)(value << 10);
            }
        }

        public void Define(ushort val)
        {
            defined = true;
            value = val;
            for (int i = 0; i < occurences.Count; i++)
            {
                if (!isDirect[i])
                    assembly.memory[occurences[i]] = value;
                else
                    assembly.memory[occurences[i]] |= (ushort)(value << 10);
            }
        }

        private Label(string name, Assembly assembly)
        {
            this.name = name;
            this.assembly = assembly;
        }

        public static Label GetLabel(string name, Assembly assembly)
        {
            if (assembly.labels.ContainsKey(name)) return assembly.labels[name];

            var l = new Label(name, assembly);
            assembly.labels.Add(name, l);
            return l;
        }
    }






}
