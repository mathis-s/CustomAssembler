import serial
import numpy as np
import websockets
import asyncio
import struct
from _image_viewer import ImageViewer
import cv2
import time


with serial.Serial('COM5', 500000, timeout=10) as s:
    current = 0
    last_time = time.perf_counter()
    while True:
        current = current + 1
        s.read(2)
        if current == 128:
            print(128 / (time.perf_counter() - last_time))
            current = 0
            last_time = time.perf_counter()

