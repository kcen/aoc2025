FROM nimlang/nim:2.2.4-alpine-slim AS aoc2025

WORKDIR /repo

COPY . .

CMD ["sh"]
