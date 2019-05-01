###############################################################################
# kshrc
# _.kshrc_ for Apple Mac OS X Version 10.5.8 `Leopard'
#
# 1744 Wednesday, 10 February 2016 (16841) --
#   2017 Saturday, 13 February 2016 (16844)
#
# Modified at:
#   1926 Tuesday, 16 February 2016 (16847)
#   1855 Thursday, 25 February 2016 (16856)
#   1129 Saturday, 27 February 2016 (16858)
#   1643 Thursday, 3 March 2016 (16863)
#   0937 Sunday, 6 March 2016 (EST) [16866]
#   1936 Tuesday, 10 May 2016 (EDT) [16931]
#   1222 Saturday, 14 May 2016 (EDT) [16935]
#   0120 Sunday, 15 May 2016 (EDT) [16936]
#
# Modified for Apple macOS Version 10.13.6 `High Sierra' at:
#   2130 Monday, 11 February 2019 (EST) [17938]
#   2238 Wednesday, 13 February 2019 (EST) [17940]
#   2147 Wednesday, 20 February 2019 (EST) [17947]
#   1804 Saturday, 23 February 2019 (EST) [17950]
#   2036 Sunday, 24 February 2019 (EST) [17951]
#   2202 Sunday, 3 March 2019 (EST) [17958]
#   0132 Sunday, 10 March 2019 (EST) [17965]
#   1403 Sunday, 10 March 2019 (EDT) [17965]
#   2104 Monday, 25 March 2019 (EDT) [17980]
#   2047 Tuesday, 2 April 2019 (EDT) [17988]
#   1158 Saturday, 8 Nisan 5779 (13 April 2019) [EDT] {17999}
#   1247 Saturday, 15 Nisan 5779 (20 April 2019) [EDT] {18006}
#   2134 Monday, 24 Nisan 5779 (29 April 2019) [EDT] {18015}
#   2347 Tuesday, 25 Nisan 5779 (30 April 2019) [EDT] {18016}
#   0014 Wednesday, 26 Nisan 5779 (1 May 2019) [EDT] {18017}
#
# Austin Kim
###############################################################################

echo '# This is .kshrc'

# Set the correct value of USER.
if [[ $USER != "${HOME##*/}" ]]
   then echo -n "USER=$USER"
        export USER="${HOME##*/}"
        echo " -> USER=$USER"
fi

# Set PATH to the default system PATH, suffixed with MacVim, Google Chrome, and
#   $HOME/bin.
APPATH='/Applications/MacVim.app/Contents/bin'
APPATH="$APPATH:/Applications/Google Chrome.app/Contents/MacOS"
APPATH="$APPATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
if [[ "${PATH%%:/Users/*}" != "$PATH" ]]
   then echo "PATH=$PATH ->"
        export PATH="${PATH%%:/Users/*}:$APPATH:$HOME/bin"
        echo PATH=$PATH
elif [[ "${PATH%%:/var/root*}" != "$PATH" ]]
   then echo "PATH=$PATH ->"
        export PATH="${PATH%%:/var/root*}:$APPATH:$HOME/bin"
        echo PATH=$PATH
   else export PATH="$PATH:$APPATH:$HOME/bin"
fi

# Set MANPATH to include your manual pages.
if [[ "${MANPATH%%:$HOME*}" == "$MANPATH" ]]
   then export MANPATH="$MANPATH:$HOME/man"
fi

# Set _vi_-like command-line editing, and disable the _multiline_ option.
set -o vi -o multiline

# Set _emacs_-like command-line editing
# set +o vi
# set -o emacs

# Make `emacs' invoke GUI version of Emacs
alias emacs='/Applications/Emacs.app/Contents/MacOS/Emacs'

# Colorize directory listings.
alias ls='ls -GFla'

# Alias to clean node_modules, package-lock.json, and package.json recursively
CLEANALIAS='find . \( -name node_modules -prune -o -name package-lock.json'
alias clean="$CLEANALIAS -o -name package.json \) -exec rm -rv {} +"
unset CLEANALIAS

# Set your custom shell prompt.
HOSTNAME=`hostname`
# Shorten hostname by removing highest-level domain.
HOSTNAME=${HOSTNAME%.*}
cd ~
PHYSHOME=`pwd`
cd - >/dev/null
cdfn ( ) {
  if [[ -z "$1" ]]
     then pwd
     else cd "$@"
          PHYSPWD=`pwd`
          if [[ "$PHYSPWD" == "$PHYSHOME" ]]
             then PHYSPWD='~'
          elif [[ "${PHYSPWD#$PHYSHOME/}" != "$PHYSPWD" ]]
             then PHYSPWD="~${PHYSPWD#$PHYSHOME}"
          fi
          PS1="$USER@$HOSTNAME:$PHYSPWD"
          echo -e \\033]0\;$PS1\\07 |tr -d \\n
          if [[ $USER == root ]]
             then PS1="$PS1# "
             else PS1="$PS1$ "
          fi
  fi
  return
  }
alias cd='cdfn'
cd .

###############################################################################
# Functions
#   c:        `cd' to the mirror of the current directory
#   d:        `diff -r' between the current directory and the mirror directory
#   dq:       `diff -qr' between the current directory and the mirror directory
#   dqr:      `diff -qr' between all pairs of primary and mirror directories
#   e:        `emacs $FILE'
#   l:        `bibtex $FILE' + `latex $FILE' + `dvips $FILE -o' + `gs $FILE'
#   m:        `m' with automatic filename extension
#   n:        `node $NODEFILE'
#   pur:      Purge backup files
#   s:        Compute recursive checksum
#   sq:       Compute recursive checksum quietly
#   sf:       `sftp' $FILE to $HOST
#   sftp:     `sftp $HOST'
#   ssh:      `ssh $HOST'
#   swap:     Swap FILE and FILF (and optionally set FILE)
#   syn:      Check synchronization of primary and mirror (backup) directories
#   timedate: Print our standard time+date stamp
#   v:        `vi $FILE'
#   vim:      `mvim $FILE'
#   x:        `xed $FILE'
#   z:        Back up $FILE and $FILF into the mirror directory
###############################################################################

# Extensions supported by all functions supporting automatic filename extension
EXTENSIONS='1 f08 h c css csv js sql tex txt'
export EXTENSIONS="$EXTENSIONS html xhtml xhtml.ru xhtml.he xhtml.ar xhtml.en"

# c:  Function to `cd' to the mirror of the current directory.
c ( ) {
  PHYSPWD=`pwd -P`
  if [[ "$PHYSPWD" != "$PHYSHOME" ]]
     then if [[ "${PHYSPWD#$PHYSHOME}" != "$PHYSPWD" ]]
             then if [[ -d "$PHYSHOME/.${PHYSPWD#$PHYSHOME/}" ]]
                     then if [[ `uname` == Darwin ]]
                          # Work around bug in Apple macOS High Sierra v10.13.6
                             then echo cd "~/.${PHYSPWD#$PHYSHOME/}"
                                       cd ~/".${PHYSPWD#$PHYSHOME/}"
                          # Otherwise use algorithm analogous to that below
                             else Y=..
                                  Z=${PHYSPWD%/*}
                                  while [[ "$Z" != "$PHYSHOME" ]]
                                        do Y=$Y/..
                                           Z=${Z%/*}
                                  done
                                  echo cd "$Y/.${PHYSPWD#$PHYSHOME/}"
                                       cd "$Y/.${PHYSPWD#$PHYSHOME/}"
                          fi
                  elif [[ -d "$PHYSHOME/${PHYSPWD#$PHYSHOME/.}" ]]
                     then Y=..
                          Z=${PHYSPWD%/*}
                          while [[ "$Z" != "$PHYSHOME" ]]
                                do Y=$Y/..
                                   Z=${Z%/*}
                          done
                          echo cd "$Y/${PHYSPWD#$PHYSHOME/.}"
                               cd "$Y/${PHYSPWD#$PHYSHOME/.}"
                  fi
          fi
  fi
  unset PHYSPWD Y Z
  return
  }

# d:  Function to `diff -r' between the current directory and the mirror direc.
d ( ) {
  PHYSPWD=`pwd -P`
  if [[ "$PHYSPWD" == "$PHYSHOME" ]]
     then echo 'd:  Must be in a subdirectory under $HOME.'
  elif [[ "${PHYSPWD#$PHYSHOME}" == "$PHYSPWD" ]]
     then echo 'd:  Must be under $HOME.'
     else if [[ -d "$PHYSHOME/.${PHYSPWD#$PHYSHOME/}" ]]
             then Y=..
                  Z=${PHYSPWD%/*}
                  while [[ "$Z" != "$PHYSHOME" ]]
                        do Y=$Y/..
                           Z=${Z%/*}
                  done
                  Y=$Y/.${PHYSPWD#$PHYSHOME/}
          elif [[ -d "$PHYSHOME/${PHYSPWD#$PHYSHOME/.}" ]]
             then Y=..
                  Z=${PHYSPWD%/*}
                  while [[ "$Z" != "$PHYSHOME" ]]
                        do Y=$Y/..
                           Z=${Z%/*}
                  done
                  Y=$Y/${PHYSPWD#$PHYSHOME/.}
             else unset Y
          fi
          if [[ "$Y" ]]
             then Z="$@"
                  if [[ "$Z" ]]
                     then if [[ "${Z#/}" == "$Z" ]]
                             then if [[ -d "$Z" ]]
                                     then echo diff -r "$Z" "$Y/$Z"
                                               diff -r "$Z" "$Y/$Z"
                                     else echo diff "$Z" "$Y"
                                               diff "$Z" "$Y"
                                  fi
                             else echo 'd:  Argument must be a relative path.'
                          fi
                     else echo diff -r . "$Y"
                               diff -r . "$Y"
                  fi
             else echo 'd:  No mirror directory wherewith to compare.'
          fi
  fi
  unset PHYSPWD Y Z
  return
  }

# dq:  Function to `diff -qr' between the current directory and the mirror dir.
dq ( ) {
  PHYSPWD=`pwd -P`
  if [[ "$PHYSPWD" == "$PHYSHOME" ]]
     then echo 'dq:  Must be in a subdirectory under $HOME.'
  elif [[ "${PHYSPWD#$PHYSHOME}" == "$PHYSPWD" ]]
     then echo 'dq:  Must be under $HOME.'
     else if [[ -d "$PHYSHOME/.${PHYSPWD#$PHYSHOME/}" ]]
             then Y=..
                  Z=${PHYSPWD%/*}
                  while [[ "$Z" != "$PHYSHOME" ]]
                        do Y=$Y/..
                           Z=${Z%/*}
                  done
                  Y=$Y/.${PHYSPWD#$PHYSHOME/}
          elif [[ -d "$PHYSHOME/${PHYSPWD#$PHYSHOME/.}" ]]
             then Y=..
                  Z=${PHYSPWD%/*}
                  while [[ "$Z" != "$PHYSHOME" ]]
                        do Y=$Y/..
                           Z=${Z%/*}
                  done
                  Y=$Y/${PHYSPWD#$PHYSHOME/.}
             else unset Y
          fi
          if [[ "$Y" ]]
             then Z="$@"
                  if [[ "$Z" ]]
                     then if [[ "${Z#/}" == "$Z" ]]
                             then if [[ -d "$Z" ]]
                                     then echo diff -qr "$Z" "$Y/$Z"
                                               diff -qr "$Z" "$Y/$Z"
                                     else echo diff -q "$Z" "$Y"
                                               diff -q "$Z" "$Y"
                                  fi
                             else echo 'dq:  Argument must be a relative path.'
                          fi
                     else echo diff -qr . "$Y"
                               diff -qr . "$Y"
                  fi
             else echo 'dq:  No mirror directory wherewith to compare.'
          fi
  fi
  unset PHYSPWD Y Z
  return
  }

# dqr:  `diff -qr' between all pairs of primary and mirror directories.
dqr ( ) {
  for i in *
      do if [[ -d ".$i" ]]
            then echo diff -qr $i .$i
                      diff -qr "$i" ".$i"
         fi
  done
  return
  }

# e:  Function to run _emacs_ on $FILE.
e ( ) {
  PHYSPWD=`pwd -P`
  if [[ "${PHYSPWD#$PHYSHOME/.}" == "$PHYSPWD" ]]
     then if [[ "$1" ]]
             then FILE="$1"
          elif [[ -f "$FILE" ]]
             then echo emacs "$FILE"
          elif [[ -z "$FILE" ]]
             then read FILE?'emacs '
          fi
          if [[ ! -f "$FILE" ]]
             then for i in $EXTENSIONS
                      do if [[ -z "$STOP" && -w "$FILE.$i" ]]
                            then FILE=$FILE.$i
                                 STOP=1
                         fi
                  done
                  if [[ $STOP ]]
                     then echo emacs "$FILE"
                  fi
          fi
          export FILE
          if [[ $EDITOR ]]
             then $EDITOR "$FILE"
             else M=`which emacs`
                  if [[ "$M" ]]
                     then emacs "$FILE"
                     else echo 'emacs:  Command not found.'
                  fi
                  unset M
          fi
    else echo "e:  Only works in non-mirror directories.  (Maybe use \`emacs'?)"
  fi
  unset PHYSPWD i STOP
  return
  }

# l:  `bibtex $FILE' + `latex $FILE' + `dvips $FILE -o' + `gs $FILE.'
l ( ) {
  PHYSPWD=`pwd -P`
  if [[ "${PHYSPWD#$PHYSHOME/.}" == "$PHYSPWD" ]]
     then if [[ -z "$FILE" ]]
             then read FILE?'File:  '
          fi
          if [[ "${FILE%.1}" != "$FILE" || "${FILE%.f08}" != "$FILE" ||
               "${FILE%.h}" != "$FILE" || "${FILE%.c}" != "$FILE" ||
               "${FILE%.txt}" != "$FILE" || "${FILE%.xhtml}" != "$FILE" ||
               "${FILE%.xhtml.??}" != "$FILE" ]]
            then echo "l:  _l_ only works on \`.tex' files."
            else if [[ "${FILE%.tex}" == "$FILE" ]]
                  then FILE=$FILE.tex
                fi
                if [[ -r "$FILE" ]]
                  then export FILE
                      if [[ -r "${FILE%tex}bib" && -r "${FILE%tex}aux" ]] &&
                           ! bibtex "${FILE%.tex}"
                        then ERROR=1
                      fi
                      if [[ -z $ERROR ]]
                        then if latex "${FILE%.tex}" && dvips "${FILE%.tex}" -o
                                then gs -dNOPAUSE -dBATCH -sDEVICE=pdfwrite \
                                  -sOutputFile="${FILE%tex}pdf" "${FILE%tex}ps"
                                     chmod -v go= "${FILE%tex}"*
                             fi
                      fi
                  else echo "l:  \`$FILE' is unreadable."
                      unset FILE
               fi
          fi
     else echo "l:  First \`cd' to the primary (non-mirror) directory."
  fi
  unset PHYSPWD ERROR
  return
  }

# m:  Function to run _m_ with automatic filename extension.
m ( ) {
  M=`which m`
  if [[ "$M" ]]
     then if [[ "$1" ]]
             then if ! "$M" "$1"
                     then TEMP="$1"
                          for i in $EXTENSIONS
                              do if [[ -z "$STOP" && -r "$TEMP.$i" ]]
                                    then TEMP=$TEMP.$i
                                         STOP=1
                                 fi
                          done
                          if [[ $STOP ]]
                             then echo m "$TEMP"
                                  "$M" "$TEMP"
                          fi
                  fi
          elif [[ "$FILE" ]]
             then if ! "$M"
                     then TEMP=$FILE
                          for i in $EXTENSIONS
                              do if [[ -z "$STOP" && -r "$TEMP.$i" ]]
                                    then TEMP=$TEMP.$i
                                         STOP=1
                                 fi
                          done
                          if [[ $STOP ]]
                             then echo m "$TEMP"
                                  "$M" "$TEMP"
                          fi
                  fi
             else "$M"
          fi
     else echo 'm:  Command not found.'
  fi
  unset M TEMP i STOP
  return
  }

# n:  `node [nodefile] [args]'
n ( ) {
  if [[ "${1%.js}" != "$1" && -f "$1" ]]    # `node nodefile.js args'
     then export NODEFILE="$1"
          shift
          node "$NODEFILE" "$@"
  elif [[ -f "$1.js" ]]                     # `node nodefile args'
     then export NODEFILE="$1.js"
          shift
          node "$NODEFILE" "$@"
     else node "$NODEFILE" "$@"             # `node args'
  fi
  return
  }

# pur:  Function to purge backup files.
#   Call once to remove backup files; call again to remove ancillary TeX files.
pur ( ) {
  PHYSPWD=`pwd -P`
  if [[ "$1" ]]
     then FILE="$1"
  fi
  if ! (ls *:[1-9][0-9] >/dev/null 2>/dev/null && rm -v *:[1-9][0-9]) &&
     ! (ls     *:0[0-9] >/dev/null 2>/dev/null && rm -v     *:0[0-9]) &&
     ! (ls           *~ >/dev/null 2>/dev/null && rm -v           *~)
     then if [[ ! -f "$FILE" ]]
             then for i in $EXTENSIONS
                      do if [[ -z "$STOP" && -w "$FILE.$i" ]]
                            then FILE=$FILE.$i
                                 STOP=1
                         fi
                  done
          fi
          if [[ -f "$FILE" ]]
             then if [[ "${FILE%.tex}" != "$FILE" ]]
                     then if [[ -w "$FILE" ]]
                             then for i in aux cot dvi log pdf ps toc
                                      do if [[ -f "${FILE%tex}$i" ]]
                                            then rm -v "${FILE%tex}$i"
                                         fi
                                  done
                             else if [[ -d "$PHYSHOME/.${PHYSPWD#$PHYSHOME/}" ]]
                                     then Y=..
                                          Z=${PHYSPWD%/*}
                                          while [[ "$Z" != "$PHYSHOME" ]]
                                                do Y=$Y/..
                                                   Z=${Z%/*}
                                          done
                                          Z=$Y/.${PHYSPWD#$PHYSHOME/}
                                          chmod -v a-w "$Z/$FILE"
                                  fi
                                  if [[ -f "${FILE%tex}cot" ]]
                                     then chmod -v a-w "${FILE%tex}cot"
                                          if [[ "$Z" ]]
                                             then cp -pv "${FILE%tex}cot" "$Z"
                                          fi
                                  fi
                                  chmod -v a-w,ug+r "${FILE%tex}ps"
                                  chmod -v a-w,ug+r "${FILE%tex}pdf"
                                  if [[ "$Z" ]]
                                     then cp -pv "${FILE%tex}ps" "$Z"
                                          cp -pv "${FILE%tex}pdf" "$Z"
                                  fi
                                  if [[ -f "${FILE%tex}toc" ]]
                                     then chmod -v a-w "${FILE%tex}toc"
                                          if [[ "$Z" ]]
                                             then cp -pv "${FILE%tex}toc" "$Z"
                                          fi
                                  fi
                                  rm -v "${FILE%tex}aux" "${FILE%tex}dvi"
                                  rm -v "${FILE%tex}log"
                          fi
                  fi
          elif [[ "$FILE" ]]
             then echo "pur:  \`$FILE' not found."
          fi
  fi
  unset PHYSPWD i STOP Y Z
  return
  }

# s:  Function to compute recursive checksum.
s ( ) {
  if [[ -d "$1" ]]
     then DIR=$1
     else DIR=.
  fi
# if [[ `uname` == FreeBSD ]]
#    then find -s "$DIR" -type f -or -type l |tr \\n \\0 |xargs -0 md5 |
#              sed s/MD5\ \(\\\(.*\\\)\)\ =\ \\\(.*\\\)/\\2\ \\1/ |tee /tmp/dgst
#         md5 </tmp/dgst
#    else find "$DIR" -type f -or -type l |tr / \\a |sort |tr \\a\\n /\\0 |
#              xargs -0 openssl dgst |
#              sed s/MD5\(\\\(.*\\\)\)=\ \\\(.*\\\)/\\2\ \\1/ |tee /tmp/dgst
#         openssl dgst </tmp/dgst
# fi
  find -s "$DIR" -type f -or -type l |tr \\n \\0 |xargs -0 md5 |
       sed s/MD5\ \(\\\(.*\\\)\)\ =\ \\\(.*\\\)/\\2\ \\1/ |tee /tmp/dgst
  cksum /tmp/dgst |dectohex
  unset DIR
  return
  }

# sq:  Function to compute recursive checksum quietly.
sq ( ) {
  if [[ -d "$1" ]]
     then DIR=$1
     else DIR=.
  fi
# if [[ `uname` == FreeBSD ]]
#    then find -s "$DIR" -type f -or -type l |tr \\n \\0 |xargs -0 md5 |
#              sed s/MD5\ \(\\\(.*\\\)\)\ =\ \\\(.*\\\)/\\2\ \\1/ |md5
#    else find "$DIR" -type f -or -type l |tr / \\a |sort |tr \\a\\n /\\0 |
#              xargs -0 openssl dgst |
#              sed s/MD5\(\\\(.*\\\)\)=\ \\\(.*\\\)/\\2\ \\1/ |openssl dgst
# fi
  find -s "$DIR" -type f -or -type l |tr \\n \\0 |xargs -0 md5 |
       sed s/MD5\ \(\\\(.*\\\)\)\ =\ \\\(.*\\\)/\\2\ \\1/ |cksum |dectohex
  unset DIR
  return
  }

# sf:  Function to _sftp_ $FILE to $HOST.
sf ( ) {
  PHYSPWD=`pwd -P`
  if [[ "${PHYSPWD#$PHYSHOME}" == "$PHYSPWD" ]]
    then echo 'sf:  Must be under $HOME.'
    else if [[ ! -r "$FILE" ]]
          then read FILE?'File:  '
        fi
        if [[ -r "$FILE" ]]
          then export FILE
              if [[ -z $HOST ]]
                then read HOST?'Host:  '
              fi
              if [[ "${PHYSPWD#$PHYSHOME/?}" != "$PHYSPWD" ]]
                then DIR0=${PHYSPWD#$PHYSHOME/}
                   if [[ -d "$PHYSHOME/.$DIR0" && -r "$PHYSHOME/.$DIR0/$FILE" ]]
                       then TEMP=/$DIR0
                            until [[ -z "$TEMP" ]]
                                  do DIR1=../$DIR1
                                     TEMP=${TEMP%/*}
                            done
                            DIR1=$DIR1.$DIR0
                    fi
              fi
              TEMP=~/sftp$$.bat
              if echo progress >$TEMP
                then if [[ "$DIR0" ]]
                    then echo cd  `echo "$DIR0" |sed s/\ /\\\\\\\\\ /g` >>$TEMP
                  fi
                  echo rm  `echo "$FILE" |sed s/\ /\\\\\\\\\ /g` >>$TEMP
                  echo put `echo "$FILE" |sed s/\ /\\\\\\\\\ /g` >>$TEMP
                  if [[ "$DIR1" ]]
                    then echo lcd `echo "$DIR1" |sed s/\ /\\\\\\\\\ /g` >>$TEMP
                         echo cd  `echo "$DIR1" |sed s/\ /\\\\\\\\\ /g` >>$TEMP
                         echo rm  `echo "$FILE" |sed s/\ /\\\\\\\\\ /g` >>$TEMP
                         echo put `echo "$FILE" |sed s/\ /\\\\\\\\\ /g` >>$TEMP
                  fi
                  echo quit >>$TEMP
                  if sftp -b $TEMP $HOST
                    then export HOST
                  fi
                  rm $TEMP
                else echo "sf:  Cannot create \`$TEMP.'"
              fi
          else echo "sf:  Cannot read \`$FILE'."
        fi
  fi
  unset PHYSPWD DIR0 DIR1 TEMP
  return
  }

# sftp:  Function to run `sftp $HOST' if no command-line arguments specified.
sftp ( ) {
  SFTP=`which sftp`
  if [[ $SFTP ]]
     then if [[ "$*" ]]
             then $SFTP "$@"
             else if [[ -z $HOST ]]
                     then read HOST?'Host:  '
                  fi
                  if $SFTP $HOST
                     then export HOST
                  fi
          fi
          return $?
  fi
  echo 'sftp:  Not found.'
  unset SFTP
  return 127
  }

# ssh:  Function to run `ssh $HOST' if no command-line arguments specified.
ssh ( ) {
  SSH=`which ssh`
  if [[ $SSH ]]
     then if [[ "$*" ]]
             then $SSH "$@"
             else if [[ -z $HOST ]]
                     then read HOST?'Host:  '
                  fi
                  if $SSH $HOST
                     then export HOST
                  fi
          fi
          return $?
  fi
  echo 'ssh:  Not found.'
  unset SSH
  return 127
  }

# swap:  Function to swap FILE and FILF (and optionally to set FILE).
swap ( ) {
  if [[ "$1" ]]
     then TEMP=$1
     else TEMP=$FILF
  fi
  export FILF=$FILE
  export FILE=$TEMP
  echo FILE=$FILE
  echo FILF=$FILF
  unset TEMP
  return
  }

# syn:  Function to check synchronization of primary and mirror (backup)
#   directories prior to doing your weekly backup.
syn ( ) {
  cd ~
  date && for i in *
    do if [[ -d .$i ]]
          then echo diff -r {,.}$i
               if diff -r {,.}$i
                  then chmod -Rv a-w {,.}$i
               fi
       fi
    done
  date
  return
  }

# timedate:  Function to print our standard time+date stamp.
timedate ( ) {
  TIMEWKDY=`date +'%H%M %A,'`
  DYOFMNTH=`date +%e`
  MNTHYR=`date +'%B %Y'`
  TZ=`date +%Z`
  S=`date +%s`
  if [[ $TZ == EST ]]
     then S=$((S - 18000))
  elif [[ $TZ == EDT ]]
     then S=$((S - 14400))
  fi
  echo -e \\t\\t\\t\\t$TIMEWKDY ${DYOFMNTH# } $MNTHYR \($TZ\) [$((S / 86400))]
  unset TIMEWKDY DYOFMNTH MNTHYR TZ
  return
  }

# v:  Function to run _vi_ on $FILE.
v ( ) {
  PHYSPWD=`pwd -P`
  if [[ "${PHYSPWD#$PHYSHOME/.}" == "$PHYSPWD" ]]
     then if [[ "$1" ]]
             then FILE="$1"
          elif [[ -f "$FILE" ]]
             then echo vi "$FILE"
          elif [[ -z "$FILE" ]]
             then read FILE?'vi '
          fi
          if [[ ! -f "$FILE" ]]
             then for i in $EXTENSIONS
                      do if [[ -z "$STOP" && -w "$FILE.$i" ]]
                            then FILE=$FILE.$i
                                 STOP=1
                         fi
                  done
                  if [[ $STOP ]]
                     then echo vi "$FILE"
                  fi
          fi
          export FILE
# If you want to use Bram Moolenaar's Vim instead of /usr/bin/vi, export
#   EDITOR.
          if [[ $EDITOR ]]
             then $EDITOR "$FILE"
             else vi "$FILE"
          fi
     else echo "v:  Only works in non-mirror directories.  (Maybe use \`vi'?)"
  fi
  unset PHYSPWD i STOP
  return
  }

# vim:  Function to run _mvim_ on $FILE.
vim ( ) {
  PHYSPWD=`pwd -P`
  if [[ "${PHYSPWD#$PHYSHOME/.}" == "$PHYSPWD" ]]
     then if [[ "$1" ]]
             then FILE="$1"
          elif [[ -f "$FILE" ]]
             then echo mvim "$FILE"
          elif [[ -z "$FILE" ]]
             then read FILE?'mvim '
          fi
          if [[ ! -f "$FILE" ]]
             then for i in $EXTENSIONS
                      do if [[ -z "$STOP" && -w "$FILE.$i" ]]
                            then FILE=$FILE.$i
                                 STOP=1
                         fi
                  done
                  if [[ $STOP ]]
                     then echo mvim "$FILE"
                  fi
          fi
          export FILE
# If you want to use Bram Moolenaar's Vim instead of _mvim_, export _EDITOR_.
          if [[ $EDITOR ]]
             then $EDITOR "$FILE"
             else M=`which mvim`
                  if [[ "$M" ]]
                     then mvim "$FILE"
                     else echo 'mvim:  Command not found.'
                  fi
                  unset M
          fi
   else echo "vim:  Only works in non-mirror directories.  (Maybe use \`mvim'?)"
  fi
  unset PHYSPWD i STOP
  return
  }

# x:  Function to run _xed_ on $FILE.
x ( ) {
  PHYSPWD=`pwd -P`
  if [[ "${PHYSPWD#$PHYSHOME/.}" == "$PHYSPWD" ]]
     then if [[ "$1" ]]
             then FILE="$1"
             elif [[ -f "$FILE" ]]
                  then echo xed "$FILE"
             elif [[ -z "$FILE" ]]
                  then read FILE?'xed '
          fi
          if [[ ! -f "$FILE" ]]
             then for i in $EXTENSIONS
                      do if [[ -z "$STOP" && -w "$FILE.$i" ]]
                            then FILE=$FILE.$i
                                 STOP=1
                         fi
                  done
                  if [[ $STOP ]]
                     then echo xed "$FILE"
                  fi
          fi
          export FILE
          if [[ $EDITOR ]]
             then $EDITOR "$FILE"
             else X=`which xed`
                  if [[ "$X" ]]
                     then xed "$FILE"
                     else echo 'xed:  Command not found.'
                  fi
                  unset X
          fi
     else echo "x:  Only works in non-mirror directories.  (Maybe use \`xed'?)"
  fi
  unset PHYSPWD i STOP
  return
  }

# z:  Function to back up $FILE and $FILF into the mirror directory.
z ( ) {
  PHYSPWD=`pwd -P`
  LINES=`stty -a |head -n 1 |awk '{print $4}'`
  if [[ -z "$FILE" ]]
     then read FILE?'File:  '
  fi
  if [[ ! -f "$FILE" ]]
     then for i in $EXTENSIONS
              do if [[ -z "$STOP" && -w "$FILE.$i" ]]
                    then FILE=$FILE.$i
                         STOP=1
                 fi
          done
  fi
  if [[ -w "$FILE" ]]
     then export FILE
          if [[ -d "$PHYSHOME/.${PHYSPWD#$PHYSHOME/}" ]]
             then Y=..
                  Z=${PHYSPWD%/*}
                  while [[ "$Z" != "$PHYSHOME" ]]
                        do Y=$Y/..
                           Z=${Z%/*}
                  done
                  Z=$Y/.${PHYSPWD#$PHYSHOME/}
                  if [[ ! -f "$Z/$FILE" ]] || ! diff "$FILE" "$Z" >/dev/null
                     then cp -pv "$FILE" "$Z"
                          FILELS=1
                  fi
          fi
          if [[ -r "$FILE:01" ]]
#            then if ! diff "$FILE" "$FILE:01" >/dev/null
             then if ! diff "$FILE" "$FILE:01"
                     then i=1
                          j=2
                          FILEJ=$FILE:02
                          while [[ -w "$FILEJ" ]]
                                do if [[ $j == 99 ]]
                                      then rm -v "$FILEJ"
                                      else i=$j
                                           j=$((j + 1))
                                           if [[ ${j#?} ]]
                                              then FILEJ=$FILE:$j
                                              else FILEJ=$FILE:0$j
                                           fi
                                   fi
                          done
                          until [[ $i == 1 ]]
                                do if [[ ${i#?} ]]
                                      then FILEI=$FILE:$i
                                      else FILEI=$FILE:0$i
                                   fi
                                   mv -v "$FILEI" "$FILEJ"
                                   j=$i
                                   i=$((i - 1))
                                   FILEJ=$FILEI
                          done
                          if diff "$FILE~" "$FILE:01" >/dev/null 2>/dev/null
                             then mv -v "$FILE~" "$FILE:02"
                                  rm -v "$FILE:01"
                             else if [[ -r "$FILE~" ]]
                              then echo "z:  \`$FILE~' and \`$FILE:01' differ."
                                  fi
                                  mv -v "$FILE:01" "$FILE:02"
                          fi
                          cp -pv "$FILE" "$FILE:01"
                          FILELS=1
                  fi
             else if [[ -f "$FILE~" ]]
                     then mv -v "$FILE~" "$FILE:02"
                  fi
                  cp -pv "$FILE" "$FILE:01"
                  FILELS=1
          fi
          if [[ $FILELS ]]
#            then ls "$FILE"* |head -n $((LINES - 1))
             then ls "$FILE"* |head -n $((LINES / 2))
          fi
     else echo "z:  \`$FILE' is not writable."
          unset FILE
  fi
  unset STOP
  if [[ "$FILF" && ! -f "$FILF" ]]
     then for i in $EXTENSIONS
              do if [[ -z "$STOP" && -w "$FILF.$i" ]]
                    then FILF=$FILF.$i
                         STOP=1
                 fi
          done
  fi
  if [[ -w "$FILF" ]]
     then export FILF
          if [[ -d "$PHYSHOME/.${PHYSPWD#$PHYSHOME/}" ]]
             then Y=..
                  Z=${PHYSPWD%/*}
                  while [[ "$Z" != "$PHYSHOME" ]]
                        do Y=$Y/..
                           Z=${Z%/*}
                  done
                  Z=$Y/.${PHYSPWD#$PHYSHOME/}
                  if [[ ! -f "$Z/$FILF" ]] || ! diff "$FILF" "$Z" >/dev/null
                     then cp -pv "$FILF" "$Z"
                          FILFLS=1
                  fi
          fi
          if [[ -r "$FILF:01" ]]
             then if ! diff "$FILF" "$FILF:01" >/dev/null
                     then i=1
                          j=2
                          FILFJ=$FILF:02
                          while [[ -w "$FILFJ" ]]
                                do if [[ $j == 99 ]]
                                      then rm -v "$FILFJ"
                                      else i=$j
                                           j=$((j + 1))
                                           if [[ ${j#?} ]]
                                              then FILFJ=$FILF:$j
                                              else FILFJ=$FILF:0$j
                                           fi
                                   fi
                          done
                          until [[ $i == 1 ]]
                                do if [[ ${i#?} ]]
                                      then FILFI=$FILF:$i
                                      else FILFI=$FILF:0$i
                                   fi
                                   mv -v "$FILFI" "$FILFJ"
                                   j=$i
                                   i=$((i - 1))
                                   FILFJ=$FILFI
                          done
                          if diff "$FILF~" "$FILF:01" >/dev/null 2>/dev/null
                             then mv -v "$FILF~" "$FILF:02"
                                  rm -v "$FILF:01"
                             else if [[ -r "$FILF~" ]]
                              then echo "z:  \`$FILF~' and \`$FILF:01' differ."
                                  fi
                                  mv -v "$FILF:01" "$FILF:02"
                          fi
                          cp -pv "$FILF" "$FILF:01"
                          FILFLS=1
                  fi
             else if [[ -f "$FILF~" ]]
                     then mv -v "$FILF~" "$FILF:02"
                  fi
                  cp -pv "$FILF" "$FILF:01"
                  FILFLS=1
          fi
          if [[ $FILFLS ]]
#            then ls "$FILF"* |head -n $((LINES - 1))
             then ls "$FILF"* |head -n $((LINES / 2))
          fi
     elif [[ "$FILF" ]]
          then echo "z:  \`$FILF' is not writable."
  fi
  unset PHYSPWD i j STOP Y Z FILELS FILEI FILEJ FILFLS FILFI FILFJ
  return
  }

# PROGRAM ALIASES
alias cc='cc -march=native -Ofast'
alias chrome='Google\ Chrome'

# STARTUP COMMANDS

# Print machine's IP address.
IP=`ifconfig |grep broadcast`
echo ${IP%netmask*}

# Delete _~/.DS_Store_.
if [[ -f ~/.DS_Store ]]
   then echo rm -v ~/.DS_Store
             rm -v ~/.DS_Store
fi
