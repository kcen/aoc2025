FROM debian:forky AS aoc2025

WORKDIR /repo

COPY . .

CMD ["bash"]
