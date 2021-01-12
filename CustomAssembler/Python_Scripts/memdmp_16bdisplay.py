import numpy as np
import websockets
import asyncio
import struct
from _image_viewer import ImageViewer
import cv2
import io

WIDTH = 63
HEIGHT = 31

image = np.zeros([HEIGHT+1, WIDTH+1, 3], np.uint8)
viewer = ImageViewer(
                    caption="pong",
                    height=512,
                    width=1024,
                    )   


with open("memory.bin", "rb") as fs:
    currentX = WIDTH
    currentY = HEIGHT
    fs.seek(0x10000)
    run = True
    while run:
        
        #print (image)
        #print(np.squeeze(np.stack((img,) * 3, -1)))
        viewer.show(cv2.resize(image, (1024,512), interpolation=cv2.INTER_NEAREST))
        #row, success = intTryParse(line)
        row, = struct.unpack('H', fs.read(2))#int.from_bytes(fs.read(2), byteorder='little')

        b = row & 0b11111
        g = (row >> 5) & 0b111111
        r = (row >> 11)

        image[currentY, currentX, 0] = r * 8
        image[currentY, currentX, 1] = g * 4
        image[currentY, currentX, 2] = b * 8

        currentX = currentX - 1
        if currentX < 0:
            currentX = WIDTH
            currentY = currentY - 1
            if currentY < 0:
                currentY = HEIGHT
                run = False

input()
        
