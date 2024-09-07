#!/usr/bin/env bash

echo > tournament.pgn
echo > tournament.log

RESULTS=$(realpath tournament.pgn)
LOGS=$(realpath tournament.log)
BOOK=$(realpath noob_3moves.epd)
FASTCHESS="/home/szajna/pr/fastchess/fastchess"
TIMECONTROL="45+1"
ROUNDS=8

declare -A engines
engines=(
#   ["kopyto_v0"]="cmd=/home/szajna/pr/kopyto/kopyto_v0 args=uci"
#   ["kopyto_v1"]="cmd=/home/szajna/pr/kopyto/kopyto_v1 args=uci"
#   ["kopyto_v2"]="cmd=/home/szajna/pr/kopyto/kopyto_v2 args=uci"
#   ["kopyto_v7"]="cmd=/home/szajna/pr/kopyto/kopyto_v7"
#        ["kopyto_v8"]="cmd=/home/szajna/pr/kopyto/kopyto_v8"
    ["kopyto_old"]="cmd=/home/szajna/pr/kopyto2/target/release/kopyto"
    ["kopyto_dev"]="cmd=/home/szajna/pr/kopyto/target/release/kopyto"
#   ["stockfish"]="cmd=/home/szajna/pr/Stockfish/src/stockfish"
)

pairs=()

for engine1 in "${!engines[@]}"; do
    for engine2 in "${!engines[@]}"; do
        if [[ ! "${engine2}" > "${engine1}" ]]; then
            if [[ "${engine1}" != "${engine2}" ]]; then
                pairs+=("${engine1}:${engine2}")
            fi
        fi
    done
done

echo "Pairings:"
for pair in "${pairs[@]}"; do
    engine1=${pair%%:*}
    engine2=${pair#*:}
    echo "- ${engine1} vs ${engine2}"
done

for pair in "${pairs[@]}"; do
    engine1=${pair%%:*}
    engine2=${pair#*:}

    cmd1=${engines[${engine1}]}
    cmd2=${engines[${engine2}]}

    announcement="${engine1} vs ${engine2}"
    decoration=$(echo "${announcement}" | sed 's/./=/g')

    echo
    echo "${decoration}"
    echo "${announcement}"
    echo "${decoration}"
    echo

    ${FASTCHESS} \
        -event "Kopytournament" \
        -concurrency $(nproc) \
        -rounds ${ROUNDS} \
        -log file=${LOGS} level=info \
        -pgnout file=${RESULTS} nodes=true nps=true \
        -openings file=${BOOK} format=epd order=random \
        -engine ${cmd1} name=${engine1} tc=${TIMECONTROL} \
        -engine ${cmd2} name=${engine2} tc=${TIMECONTROL}
done
