function check-cert
    set -l url "$argv"

    set -l host (echo "$url" | sed -e "s|https://||" | sed -e "s|/.*||")


    echo "" | openssl s_client -showcerts -servername "$host" -connect "$host:443"
end