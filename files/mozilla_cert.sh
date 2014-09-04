certificateFile=$2
certificateName=$1
for certDB in $(find /home -name "cert8.db"| grep "/\.")
do
  certDir=$(dirname ${certDB});
  echo "Installing mozilla certificate ${certificateName} in ${certDir}..."
  certutil -A -n "${certificateName}" -t "TCu,Cuw,Tuw" -i ${certificateFile} -d ${certDir}
  if [ $? ]; then
	echo "Mozilla certificate ${certificateName} installed succesfully in ${certDir}."	
  fi 	
done
echo "Finished."
      
