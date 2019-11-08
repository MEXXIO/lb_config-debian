#!/bin/sh
# Generate an error report for python3 scripts

pycheck()
{
    local FILE="$1"
    REPORT=$(echo "$FILE" | sed 's|.py||')_report.txt
    echo "*** File: $FILE ***\n" > "$REPORT"
    for CHECK in pylint3 pycodestyle pydocstyle black
    do
        case "$CHECK" in
            pylint3|pycodestyle|pydocstyle)
                OPTS="-v"
                ;;
            black)
                OPTS="-q --diff"
                ;;
            *)
                ;;
        esac
        echo "Results from $CHECK $OPTS:" >> "$REPORT"
        sh -c "$CHECK $OPTS $FILE" >> "$REPORT"
        echo "==========================================" >> "$REPORT"
    done
}

if [ "$#" -eq 0 ]
then
    FILES="*.py"
else
    FILES="$@"
fi

for FILE in $FILES
do
    pycheck "$FILE"
done
