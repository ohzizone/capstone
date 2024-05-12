import cv2
import numpy as np
import subprocess
import pyfirmata
import time

port = 'COM5'
board = pyfirmata.Arduino('/dev/ttyUSB0')
LED = board.get_pin('d:13:o')

process = subprocess.Popen(['libcamera-vid', '--codec', 'mjpeg', '--width', '640', '--height', '480', '-t', '0', '-o', '-'],
                            stdout=subprocess.PIPE, bufsize=10**8)

face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')

buffer = b''

try:
    while True:
        chunk = process.stdout.read(4096)
        buffer += chunk

        a = buffer.find(b'\xff\xd8')
        b = buffer.find(b'\xff\xd9')

        if a != -1 and b != -1:
            jpg = buffer[a:b+2]
            buffer = buffer[b+2:]

            image = cv2.imdecode(np.frombuffer(jpg, dtype=np.uint8), cv2.IMREAD_COLOR)

            gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)

            faces = face_cascade.detectMultiScale(gray, scaleFactor=1.1, minNeighbors=5, minSize=(30, 30))

            for (x, y, w, h) in faces:
                cv2.rectangle(image, (x, y), (x+w, y+h), (0, 255, 0), 2)
                LED.write(1)
                time.sleep(1)
                LED.write(0)

            cv2.imshow('Face Detection', image)

            if cv2.waitKey(1) & 0xff == ord('q'):
                break

finally:
    process.kill()
    cv2.destroyAllWindows()