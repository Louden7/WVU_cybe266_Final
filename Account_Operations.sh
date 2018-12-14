#!/bin/bash

STR="Please enter a option.\n1. Add Accounts And Passwords.\n2. Delete Accounts\n3. Lock Accounts.\n4. Unlock Accounts.\n5. Create A Group.\n6. Delete A Group.\n7. Add Users To A Group.\n8. Remove Users From Group.\n9. End Program."
echo -e $STR
read -p ":>> " option

while(($option != 9)); do

  if (($option == '1')); then
    echo -e "Please enter the file to read."
    read -p ":>> " file
    echo -e "Creating Accounts With Given Passwords..."
    while IFS=: read f1 f2; do
      useradd $f1 -m -s /bin/bash
      echo $f1:$f2 | chpasswd
    done < $file
    echo -e "Done.\n"

  elif (($option == '2')); then
    echo -e "Would you like to delete the users home directory? (y/n)"
    read -p ":>> " answer
    echo -e "Please enter the file to read."
    read -p ":>> " file
    echo -e "Deleting Accounts..."
    if(($answer == 'y'));then
      while IFS=: read f1 f2; do
        userdel -r $f1 >& /dev/null
      done < $file
    else
      while IFS=: read f1 f2; do
        userdel $f1 >& /dev/null
      done < $file
    fi
    echo -e "Done.\n"

  elif (($option == '3')); then
    echo -e "Please enter the file to read."
    read -p ":>> " file
    echo -e "Locking Accounts..."
    while IFS=: read f1 f2; do
      passwd -l -q $f1
    done < $file
    echo -e "Done.\n"

  elif (($option == '4')); then
    echo -e "Please enter the file to read."
    read -p ":>> " file
    echo -e "Unlocking Accounts..."
    while IFS=: read f1 f2; do
      passwd -u -q $f1
    done < $file
    echo -e "Done.\n"

  elif (($option == '5')); then
    echo -e "Please Enter The Group To Add."
    read -p ":>> " group
    echo -e "Adding Group..."
    groupadd $group
    echo -e "Done.\n"

  elif (($option == '6')); then
    echo -e "Please Enter The Group To Delete."
    read -p ":>> " group
    echo -e "Deleting Group..."
    groupdel $group
    echo -e "Done.\n"

  elif (($option == '7')); then
    echo -e "Please Enter The Group The Users Will Be Added To."
    read -p ":>> " group
    if [$(getent group $group)]; then
      echo -e "Adding Users To The Group..."
      while IFS=: read f1 f2; do
        adduser --quiet $f1 $group
      done < $file
    else
      echo -e "Creating Group..."
      groupadd $group
      echo -e "Adding Users To The Group..."
      while IFS=: read f1 f2; do
        adduser --quiet $f1 $group
      done < $file
    fi
    echo -e "Done.\n"

  elif (($option == '8')); then
    echo -e "Please Enter The Group The Users Will Be Deleted From."
    read -p ":>> " group
    echo -d "Deleting Users From The Group..."
    while IFS=: read f1 f2; do
      deluser -q $f1 $group
    done < $file
    echo -e "Done.\n"

  else
    echo -e "Invalid Input.\n"
  fi

  echo -e $STR
  read -p ":>> " option
done
echo -e "Ending Program..."
