function tracesbc
    ssh "$argv" -p 2024 "tshark -i any -f 'port 5060' -w -" | wireshark -ki -
end