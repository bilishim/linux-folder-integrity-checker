#!/bin/bash

###
#Çalıştırmak için: ./calcsum.sh klasor_adi
#Bu script hedef klasördeki tüm dosyaların ve alt dizinlerdeki dosyaların özyinelemeli olarak .md5 formatında hash değerini hesaplayarak bunları /opt/checksum/ klasörü altında toplamaktadır.
#Yazan: Bilishim ARGE
###

rm -rf /opt/checksum/

cd $1

find . -print0 | while IFS= read -r -d '' file
do 
if [ ! -d "${file}" ] ; then
	echo "$file"
	if ! test -n "`echo $file | grep '\.md5$'`"; then
		md5sum -b -- $file >$file.md5
		mv $file.md5 ../checksum/$file.md5
	fi
else
	path=checksum$file
	path=${path//'.'/''}

	echo $path

	mkdir '/opt/'$path

fi
done


