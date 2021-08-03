function traceep
    command ssh "$argv[1]" "/usr/sbin/tshark -i any -f 'port 5060' -w -" | wireshark -ki -
end
