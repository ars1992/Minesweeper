!#/bin/bash

function anzahlFragezeichen {
    local IFS=$'\n'
    grep -c "${1}" <<< ${minenfeld[*]}
}

function sindUmliegendeFelderImSpielfeld {
    if [ "${1}" -lt 0 \
        -o "${1}" -ge "${weite}" \
        -o "${2}" -lt 0 \
        -o "${2}" -ge "${hoehe}" \
        ]; then
            echo "-"
        else
            echo "${minenfeld[$((${2}*${weite}+${1}))]}"
    fi
}

function zaehleMinen {
    local x y e=""
    local IFS=$'\n'
    for ((x=${1}-1; ${x}<=${1}+1; x++)) do
        for ((y=${2}-1; ${y}<=${2}+1;y++)) do
            e+=$(sindUmliegendeFelderImSpielfeld ${x} ${y})$'\n'
        done
    done
    grep -c "*" <<< ${e}
}

function minenVerdecken {
    local x y e
    for ((y=0; ${y}<${hoehe}; y++)) do
        echo -n  "| "
        for ((x=0; ${x}<${weite}; x++)) do
            e="${minenfeld[$((${y}*${weite}+${x}))]}"
            echo -n "${e/${1}/${2}}"
        done
        echo
    done
}


weite=${1}
hoehe=${2}
anzahlMinen=${3}

declare -a minenfeld

for ((i=0; ${i}<${weite}*${hoehe}; i++)) do
    minenfeld[${i}]="?"
done

for i in $(shuf -i 0-$((${weite}*${hoehe}-1)) -n ${anzahlMinen}); do
    minenfeld[$i]="*"
done

while true; do
    clear
    
    if [ $(anzahlFragezeichen '?' ) == 0 ]; then
        echo "Winner"
        break
    fi
    
    echo "y x ---------------->"
    minenVerdecken '\*' '?'
    echo
    echo -n "x y?"
    read x y
    if [ "${x}" -ge 0 -a "${y}" -ge 0 \
        -a "${y}" -lt "${hoehe}" \
        -a "${x}" -lt "${weite}" \
        ]; then
            case "${minenfeld[$((${y}*${weite}+${x}))]}" in \
            '?') minenfeld[$((${y}*${weite}+${x}))]=$(zaehleMinen ${x} ${y});;
            '*') echo "Boom!" 
                break;;
        esac
    fi
done
minenVerdecken

