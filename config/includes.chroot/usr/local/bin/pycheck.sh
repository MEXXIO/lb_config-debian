#!/bin/sh
# Generate an error report for all python3 scripts in the current directory

for FILE in *.py
do
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
done
