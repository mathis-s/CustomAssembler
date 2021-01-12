import serial
import numpy as np
import websockets
import asyncio
import struct
from _image_viewer import ImageViewer
import cv2

image = np.zeros([16, 32], np.uint8)
viewer = ImageViewer(
                    caption="pong",
                    height=256,
                    width=512,
                    )   


with serial.Serial('COM5', 500000, timeout=10) as s:
    current = 0
    while True:
        

        viewer.show(cv2.cvtColor(cv2.resize(image, (512,256), interpolation=cv2.INTER_NEAREST), cv2.COLOR_GRAY2RGB))
        line = s.readline()

        try:
            row = int(line.decode('ascii')[:-2])
        except ValueError:
            continue

        print (current, row)

        for i in range(0, 16):
            image[i, current] = 255 if (row & (1 << i)) != 0 else 0

        current = current + 1
        if current > 31:
            current = 0