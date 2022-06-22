#!/bin/bash

if [ ! -e evasao/evasao-2014-18.csv ]
then
for i in {4..8};
do
	cat evasao/evasao-201$i.csv | tail -n +2 >> evasao/evasao-2014-18.csv
done
fi

echo
echo [ITEM 3]
echo
	cat evasao/evasao-2014-18.csv | cut -d "," -f 1 | sort -u | while read line 
do
        echo "$line.  $(cat evasao/evasao-2014-18.csv | grep -c "$line")" >> evasao/evasao.txt
	
done
cat evasao/evasao.txt | sort -t . -k2 -nr | tr -d .
rm evasao/evasao.txt

echo	 

echo [ITEM 4]
echo
echo 'ALUNOS  ANOS'
echo 
for i in {4..8};
do
cat evasao/evasao-201$i.csv | tail -n +2 | cut -d "," -f 4 | sort -nr | while read line
do
        echo "$(expr 201$i - $line)" >> evasao/evasao_tempo.txt
done
done
cat evasao/evasao_tempo.txt | sort -nu | while read line
do
        if [ $(cat evasao/evasao_tempo.txt | sort -n | grep -c "$line") -lt 10 ]
        then
                echo "$(cat evasao/evasao_tempo.txt | sort -n | grep -c "$line")        $line"
        elif [ $(cat evasao/evasao_tempo.txt | sort -n | grep -c "$line") -gt 100 ]
        then
                echo "$(cat evasao/evasao_tempo.txt | sort -n | grep -c "$line")      $line"
        else
                echo "$(cat evasao/evasao_tempo.txt | sort -n | grep -c "$line")       $line"
        fi


done
rm evasao/evasao_tempo.txt

echo
echo [ITEM 5]
echo
for i in {4..8};
do
	first=$(cat evasao/evasao-201$i.csv | grep -c "1o");
	second=$(cat evasao/evasao-201$i.csv | grep -c "2o");
	if [ $first -gt $second ]
	then
		pct=$(bc -l <<<"scale=2; ($first*100)/($first+$second)");
		maior=1;
	else
		pct=$(bc -l <<<"scale=2; ($second*100)/($first+$second)")
		maior=2;
	fi
	echo "201$i   semestre $maior - $pct%"
done
echo
echo [ITEM 6]
echo 
	M=$(cat evasao/evasao-2014-18.csv | grep -c ",M");
	F=$(cat evasao/evasao-2014-18.csv | grep -c ",F");
	echo 'SEXO   MÉDIA EVASÕES(5 anos)'
	echo "F      $[($F*100)/($M+$F)+1]%" 
 	echo "M      $[($M*100)/($M+$F)]%"
echo 

#[ITEM 7]

for i in {4..8};
do
        echo "201$i $(cat evasao/evasao-201$i.csv | tail -n +2 | wc -l)" >> evasao/evasoes_anuais.dat
done
gnuplot <<< "set terminal png size 800,600
      set output 'evasao/evasoes-ano.png'
      set title '[ITEM 7]'
      set xlabel 'Ano'
      set ylabel 'Total Evasões'
      set xtic 1
      plot 'evasao/evasoes_anuais.dat' u 1:2 w lines title 'Evasões' "
rm evasao/evasoes_anuais.dat

#[ITEM 8]

cat evasao/evasao-2014-18.csv | cut -d , -f 3 | sort -du >> evasao/evasao-ingresso.txt
for i in {4..8};
do
        echo -n "201$i   " >> evasao/evasao-ingresso.dat;
        cat evasao/evasao-ingresso.txt | while read line
        do
                echo -n "$(cat evasao/evasao-201$i.csv | grep -c "$line")   " >> evasao/evasao-ingresso.dat
        done
        echo " " >> evasao/evasao-ingresso.dat
done

gnuplot <<< "set terminal png size 800,600
        set output 'evasao/evasoes-forma.png'
        set style data histogram
        set style histogram cluster gap 1
        set style fill solid
        set boxwidth 0.9
        set xtics format ''
        set ytic 10
       	set title '[ITEM 8]'
        set key font ',7'
        plot 'evasao/evasao-ingresso.dat' u 2:xtic(1) title 'Aluno Intercâmbio', '' u 3 title 'Aproveitamento Curso Superior', '' u 4 title 'Convênio AUGM', '' u 5 title 'Convênio Pec-G', '' u 6 title 'Mobilidade Acadêmica', '' u 7 title 'Processo Seletivo/ENEM', '' u 8 title 'Reopção', '' u 9 title 'Transferência Ex-Ofício', '' u 10 title 'Transferência Provar' linecolor rgb 'gray', '' u 11 title 'Vestibular' linecolor rgb 'pink' "

rm evasao/evasao-ingresso.txt
rm evasao/evasao-ingresso.dat

