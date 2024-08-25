#!/usr/bin/env bash

echo > tournament.pgn

RESULTS=$(realpath tournament.pgn)
FASTCHESS="/home/szajna/pr/fastchess/fastchess"
TIMECONTROL="10+0"
ROUNDS=1

declare -A engines
engines=(
	["kopyto_v0"]="cmd=/home/szajna/pr/kopyto/kopyto_v0 args=uci"
	["kopyto_v1"]="cmd=/home/szajna/pr/kopyto/kopyto_v1 args=uci"
	["kopyto_v2"]="cmd=/home/szajna/pr/kopyto/kopyto_v2 args=uci"
	["kopyto_v3"]="cmd=/home/szajna/pr/kopyto/kopyto_v3 args=uci"
	["kopyto_dev"]="cmd=/home/szajna/pr/kopyto/target/release/kopyto args=uci"
	["stockfish"]="cmd=/home/szajna/pr/Stockfish/src/stockfish"
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
		-pgnout file=${RESULTS} \
		-engine ${cmd1} name=${engine1} tc=${TIMECONTROL} \
		-engine ${cmd2} name=${engine2} tc=${TIMECONTROL}
done
