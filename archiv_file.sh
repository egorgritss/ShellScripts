
#!/usr/bin/env bash

b=0
pwd=$(pwd)


if [ ! -d "$1" ] ;
 then {
  echo "ERROR: $1 doesn't exist"
  exit 1
 }
fi


echo "Do you want to create an archive here or to the own path?"
echo -n "here/own: "
read path

case $path in

 [Hh][Ee][Rr][Ee])

 while true ;
  do
   echo "Enter the name of directory, where you want to create an archive"
   echo -n "$pwd/"
   read DIR

   AR_DIR=$pwd/$DIR

    if [ -d "$AR_DIR" ] ;
     then {
      echo "Directory "$AR_DIR" already exists. Do you want to overwrite it? "
      echo -n "y/n: "
      read a1

      case $a1 in

       [Yy])
        rm -rf $AR_DIR
        mkdir $AR_DIR
        break
       ;;

       [Nn])
        break
       ;;

       *)
        echo ""
        echo "ERROR: Invalid input. Try again"
        echo ""


       esac
     }
     else {
      break
     }
    fi
   done


  mkdir $AR_DIR 2>/dev/null
  ;;

 [Oo][Ww][Nn])
  echo "Enter the path, where you want to create an archive"
  echo -n "/"
  read OWN

  AR_DIR=$OWN

  mkdir $AR_DIR 2>/dev/null

esac

cd "$1"


#p=$(ls -l | tail -n +2 | wc -l)

#ls -l | tail -n +2 | nl >./list


 for S in * ;
  do
   if [ -f "$S" ] ;
    then {

     echo -n "Do you want to archive file $S? y/n/a : "
     read answer1

     case $answer1 in

      [Yy])
       cp "$S" "$AR_DIR"
      ;;

      [Nn])
       mkdir .tempa 2>/dev/null
       mv "$S" ./.tempa
      ;;

      [Aa])
       for A in * ;
        do
         if [ -f "$A" ] ;
          then {
           if [ ! -f "$AR_DIR/$A" ] ;
            then {
             cp "$A" "$AR_DIR"
             echo "$A" copied to "$AR_DIR"
            }
           fi
          }
         fi
       done
       break
      ;;

      *)
       echo ""
       echo "ERROR: Invalid input."
       echo ""

      esac
    }
   fi
  done

  echo "   ####     "
  echo "$AR_DIR.tar"
  echo "$DIR"
  echo "$1"/.tempa
  echo "   ####     "

cd "$AR_DIR"
cd ..
tar cvf "$DIR.tar" "$DIR"
gzip "$DIR.tar"

cd "$1"/.tempa/ 2>/dev/null
mv * .. 2>/dev/null
rm -rf ../.tempa 2>/dev/null
rm -rf "$AR_DIR"

