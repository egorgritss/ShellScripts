
#!/bin/bash

killer () {


if [[ -f ./process.txt ]] ;then
  rm process.txt
fi

if [[ -f ./processawk.txt ]] ;then
  rm processawk.txt
fi

if [[ -f PIDS.txt ]] ;then
  rm PIDS.txt
fi

PROCESS=.process.txt
PIDS=.PIDS.txt


echo ""
echo -n "Enter the name of the process please: "
read process

n=$(ps -a | grep -i "$process$" |tee ./"$PROCESS" | wc -l)                            # $n = number of PIDs


if [ $n -ne 0 ] ;                                                  # If such a process exists
  then {
    awk -F" " '{ print $1 }' ./"$PROCESS" > "$PIDS"                # Write it's PIDs to PIDS.txt
    p=$(cat $PIDS)                                                 # $p = PIDs

      if [ $n -eq 1 ] ;                                            # If number of processes = 1
       then {

        echo -e "\nFound 1 process with a name $process:"
        cat $PROCESS
        echo -e "\nWould you like to kill it?\n"

         while true ;
          do
           echo -n "[y/n]: "
           read answer0

            case "$answer0" in

             [Yy])
               kill -9 $p 2>/dev/null
               echo -e "\n*DONE*\n"
               rm "$PROCESS" 2> /dev/null
               rm "$PIDS" 2> /dev/null
               exit 0
               ;;

             [Nn])
               echo -e "\n*CANCELED*\n"
               rm "$PROCESS" 2> /dev/null
               rm "$PIDS" 2> /dev/null
               exit 0

               ;;

             *)
              echo -e "\n!! Error: Invalid input. Try again. !!\n"
            esac
           done
       }

      fi

      if [ $n -gt 1 ]                                          #If number of processes > 1
       then {

        echo -e "\n              ######################################\n"
        echo -e "!! You have $n processes with a name '$process' or including '$process'. !!\n"
        echo ""
        cat ./"$PROCESS"
        echo -e "\nPlease enter the 'PID' of the process you would like to kill."
        echo "Or you can press 'a' to kill them all."
        echo -e "Enter 'c' to exit.\n"

          while true;
           do
            echo "(c) / Enter 'PID' or 'a' to kill all: "
            echo -n "['PID'/c/a]: "
            read answer1

              if grep "^$answer1$" ./"$PIDS" 2> /dev/null
               then {
                if ! [ "$answer1" = a -o "$answer1" = c ] ;
                 then {
                  kill -9 $answer1 2> /dev/null
                   echo ""
                   echo -e "\n*DONE*\n"
                   echo ""
                   rm "$PROCESS" 2> /dev/null
                   rm "$PIDS" 2> /dev/null
                   exit 0
                 }

                 else {
                  echo -e "\n              ######################################\n"
                  echo -e "!! Error: PID doesn't exist. !!\n"
                  echo -e "Try again\n"
                  cat ./"$PROCESS"
                  echo ""
                 }
                fi
               }

                else {
                 case "$answer1" in

                  [Aa])
                    echo ""
                    echo -e "\n!WARNING! Some of those processes could be SYSTEM IMPORTANT. "
                    echo -e "Killing them may cause SYSTEM PROBLEMS. Enter \"YES\" if you still want to continue. \"n\" if not.\n"
                    echo -n "[n/YES]: "
                    read answer3

                     case "$answer3" in

                      [Nn])
                       echo "Try again"
                      ;;

                      [Yy][Ee][Ss])
                       kill -9 $p 2>/dev/null
                       echo -e "\n*DONE*\n"
                       rm "$PROCESS" 2> /dev/null
                       rm "$PIDS" 2> /dev/null
                       exit 0

                     esac
                  ;;

                  [Cc])
                    echo -e "\n*CANCELED*\n"
                    rm "$PROCESS" 2> /dev/null
                    rm "$PIDS" 2> /dev/null
                    exit 0
                 esac

                }
               fi

           done
       }
      fi
  }

  else {                                                      #If process not found
    echo ""
    echo -e "              ######################################"
    echo -e "!! Error: Process not found. !!"

       echo -e "Would you like to try again?"

        while true;

         do
          echo  -n "[y/n]: "
          read answer2

           case "$answer2" in

            [Yy])
              return 99
              ;;

            [Nn])
              echo ""
              echo -e "*CANCELED*"
              exit 0
              ;;

            *)
              echo ""
              echo -e "              ######################################"
              echo -e "!! Error: Invalid input. Try again. !! "

           esac

         done
  }
fi

rm "$PIDS" 2> /dev/null

rm "$PROCESS" 2> /dev/null

}

###############################################################################################

killer

if [ $? -eq 99 ] ;
 then {
  killer
 }
fi
