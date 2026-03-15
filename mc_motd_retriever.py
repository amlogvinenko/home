import socket
import struct


def get_minecraft_motd(ip, port=25565, timeout=5):
    try:
        sock = socket.create_connection((ip, port), timeout)
        sock.settimeout(timeout)

        # Handshake (47 — 1.8)
        host = ip.encode('utf-8')
        packet = b""
        packet += b"\x00"  # Packet ID = 0 (Handshake)
        packet += b"\x04"  # Protocol version (47 for 1.8)
        packet += struct.pack("B", len(host)) + host
        packet += struct.pack(">H", port)
        packet += b"\x01"  # Next state: status

        def write_varint(value):
            out = b""
            while True:
                temp = value & 0x7F
                value >>= 7
                if value:
                    temp |= 0x80
                out += struct.pack("B", temp)
                if not value:
                    break
            return out

        sock.sendall(write_varint(len(packet)) + packet)

        sock.sendall(b"\x01\x00")

        def read_varint(sock):
            num = 0
            for i in range(5):
                byte = ord(sock.recv(1))
                num |= (byte & 0x7F) << (7 * i)
                if not byte & 0x80:
                    break
            return num

        read_varint(sock)
        _ = ord(sock.recv(1))
        length = read_varint(sock)
        data = sock.recv(length).decode('utf-8')

        import json
        motd = json.loads(data)["description"]
        if isinstance(motd, dict):
            return motd.get("text", "")
        return motd

    except Exception as e:
        return f"Error: {e}"


print(get_minecraft_motd("localhost", 25565))
print(get_minecraft_motd("localhost", 25570))
