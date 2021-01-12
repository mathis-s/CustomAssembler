import math

xi = 0
yi = 0

x = 0.0
y = 0.0

while yi < 64:
    xi = 0
    while xi < 128:
        x = xi / 128.0
        y = yi / 128.0

        print (round(256.0 / math.sqrt(x*x + y*y + 1), 0))
        
        xi = xi + 1
    yi = yi + 1
input()