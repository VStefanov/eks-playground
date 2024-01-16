declare -A counter
for key in ${!counter[@]}
do

    if [ ${counter[$key]} -eq 1 ]
    then
        echo $key
    fi
done
