import serial
import numpy as np
import websockets
import asyncio
import struct
from _image_viewer import ImageViewer
import cv2

WIDTH = 64
HEIGHT = 32

image = np.zeros([HEIGHT, WIDTH, 3], np.uint8)
viewer = ImageViewer(
                    caption="pong",
                    height=256,
                    width=512,
                    )   


with serial.Serial('COM5', 500000, timeout=10) as s:
    currentX = WIDTH-1
    currentY = HEIGHT-1
    while True:
        
        #print (image)
        #print(np.squeeze(np.stack((img,) * 3, -1)))
        viewer.show(cv2.resize(image, (512,256), interpolation=cv2.INTER_NEAREST))
        line = s.readline()
        #row, success = intTryParse(line)
        try:
            row = int(line.decode('ascii')[:-2]) #struct.unpack('H', line) #
        except ValueError:
            continue

        print (row)
        b = row & 0b11111
        g = (row >> 5) & 0b111111
        r = (row >> 11)

        image[currentY, currentX, 0] = r * 8
        image[currentY, currentX, 1] = g * 4
        image[currentY, currentX, 2] = b * 8

        currentX = currentX - 1
        if currentX < 0:
            currentX = WIDTH-1
            currentY = currentY - 1
            if currentY < 0:
                currentY = HEIGHT-1
        