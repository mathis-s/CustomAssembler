import serial
import numpy as np
import websockets
import asyncio
import struct
from _image_viewer import ImageViewer
import cv2
import keyboard

image = np.zeros([16, 32], np.uint8)
viewer = ImageViewer(
                    caption="pong",
                    height=256,
                    width=512,
                    )   


with serial.Serial('COM5', 500000, timeout=10) as s:
    
    leftPressed = False
    rightPressed = False

    leftPaddlec = 0
    rightPaddlec = 0
    while True:
        
        viewer.show(cv2.cvtColor(cv2.resize(image, (512,256), interpolation=cv2.INTER_NEAREST), cv2.COLOR_GRAY2RGB))
        line = s.readline()

        try:
            row = int(line.decode('ascii')[:-2]) 
        except ValueError:
            continue
        
        for y in range(0, 16):
            for x in range(0, 32):
                image[y, x] = 0

        print (row)
        x = row >> 11
        y = (row >> 7) & 0b1111
        image[y, x] = 255

        leftPaddle = (row & 0b1111)
        rightPaddle = (row & 0b1110000) >> 3

        image[leftPaddle, 0] = 255
        image[leftPaddle+1, 0] = 255
        image[leftPaddle+2, 0] = 255
        image[leftPaddle+3, 0] = 255

        image[rightPaddle, 31] = 255
        image[rightPaddle+1, 31] = 255
        image[rightPaddle+2, 31] = 255
        image[rightPaddle+3, 31] = 255


        if keyboard.is_pressed('q'):
            leftPaddlec = leftPaddlec - 1
            leftPaddlec = 0 if leftPaddlec < 0 else leftPaddlec
        elif keyboard.is_pressed('a'):
            leftPaddlec = leftPaddlec + 1
            leftPaddlec = 12 if leftPaddlec > 12 else leftPaddlec

        if keyboard.is_pressed('o'):
            rightPaddlec = rightPaddlec - 1
            rightPaddlec = 0 if rightPaddlec < 0 else rightPaddlec
        elif keyboard.is_pressed('l'):
            rightPaddlec = rightPaddlec + 1
            rightPaddlec = 12 if rightPaddlec > 12 else rightPaddlec

        output = (leftPaddlec << 4) | rightPaddlec

        #if keyboard.is_pressed('q') or keyboard.is_pressed('a') or keyboard.is_pressed('o') or keyboard.is_pressed('l'):
        s.write(struct.pack('H',output))
        #print("output", output)
        

        