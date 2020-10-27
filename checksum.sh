#!/bin/bash

###
#Çalıştırmak için: ./checksum.sh klasor_adi
#Bu script /opt/checksum klasörü altındaki tüm .md5 dosyalarını hedef klasör ile karşılaştırarak değişme ya da yeni dosya eklenme durumunda alarm üretmektedir. Bir cron göreviyle çalıştırılacağı öngörülmektedir.
#Yazan: Bilishim ARGE
###

cd $1

checkSum() {
	find . -print0 | while IFS= read -r -d '' file
	do 
	if [ ! -d "${file}" ] ; then
		file=${file//'./'/''}
		#echo "$file"
		md5sum -c -- '/opt/checksum/'$file'.md5'
	fi
	done
}

checkSum

alert_changed=$(checkSum | grep BAŞARISIZ)

echo 'ALARM DEGISEN DOSYA: '$alert_changed
###Buraya e-mail ya da SMS kodu konulacak ($alert_changed parametresiyle)


alert_new=$(checkSum 2>&1 | grep md5sum)

echo 'ALARM FARKLI DOSYA: '$alert_new
###Buraya e-mail ya da SMS kodu konulacak ($alert_new parametresiyle)



cd ../

original_files=`find $1 -type f | wc -l`
echo 'Kaynak Dosya Sayisi: '$original_files


check_files=`find 'checksum' -type f | wc -l`
echo 'Kontrol Dosya Sayisi: '$check_files

if [ "$original_files" != "$check_files" ]; then
	echo "ALARM!!! EKLENEN YA DA SILINEN DOSYA!!!"
	###Buraya e-mail ya da SMS kodu konulacak (bildirim olarak)
fi
