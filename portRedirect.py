import serial

def main():
    # COM port configuration
    port1_name = 'COM5'
    port2_name = 'COM6'
    baud_rate = 9600  # Change according to your device configuration

    try:
        # Open serial connections for port1 and port2
        port1 = serial.Serial(port1_name, baud_rate)
        port2 = serial.Serial(port2_name, baud_rate)

        print(f"Connected to {port1_name} and {port2_name}")

        # Continuously read from one COM port and write to the other
        while True:
            if port1.in_waiting:
                data = port1.read(port1.in_waiting)
                port2.write(data)

            if port2.in_waiting:
                data = port2.read(port2.in_waiting)
                port1.write(data)

    except serial.SerialException as e:
        print("Serial connection error:", e)
    finally:
        # Close serial connections
        if port1.is_open:
            port1.close()
        if port2.is_open:
            port2.close()

if __name__ == "__main__":
    main()
