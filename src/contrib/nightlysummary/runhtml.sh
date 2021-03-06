#!/bin/bash


if test $# -lt 2 ; then
  echo "Usage: $> runhtml.sh BRANCH LOGDIR OUTFILE";
  echo " BRANCH  ... Branch log files to be processed";
  echo " LOGDIR  ... Directory where to find the log files";
  echo " OUTFILE ... The output file where the HTML code will be written to";
  exit 0
fi

BRANCH=$1
LOGDIR=$2
OUTFILE=$3

## Write HTML header

echo "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">" > $OUTFILE
echo "<html>" >> $OUTFILE
echo "<head><title>PETSc Test Summary</title>" >> $OUTFILE

## CSS beautification begin ##

echo "<style type=\"text/css\">" >> $OUTFILE
echo "div.main {" >> $OUTFILE
echo "  max-width: 800px;" >> $OUTFILE
echo "  background: white;" >> $OUTFILE
echo "  margin-left: auto;" >> $OUTFILE
echo "  margin-right: auto;" >> $OUTFILE
echo "  padding: 20px;" >> $OUTFILE
echo "  border: 5px solid #CCCCCC;" >> $OUTFILE
echo "  border-radius: 10px;" >> $OUTFILE
echo "  background: #FBFBFB;" >> $OUTFILE
echo "}" >> $OUTFILE

echo "table {" >> $OUTFILE
echo "  /*border: 1px solid black;" >> $OUTFILE
echo "  border-radius: 10px;*/" >> $OUTFILE
echo "  padding: 3px;" >> $OUTFILE
echo "}" >> $OUTFILE

echo "td a:link, td a:visited, td a:focus, td a:active {" >> $OUTFILE
echo "  font-weight: bold;" >> $OUTFILE
echo "  text-decoration: underline;" >> $OUTFILE
echo "  color: black;" >> $OUTFILE
echo "}" >> $OUTFILE

echo "td a:hover {" >> $OUTFILE
echo "  font-weight: bold;" >> $OUTFILE
echo "  text-decoration: underline;" >> $OUTFILE
echo "  color: black;" >> $OUTFILE
echo "}" >> $OUTFILE

echo "th {" >> $OUTFILE
echo "  padding: 10px;" >> $OUTFILE
echo "  font-size: 1.1em;" >> $OUTFILE
echo "  font-weight: bold;" >> $OUTFILE
echo "  text-align: center;" >> $OUTFILE
echo "}" >> $OUTFILE

echo "td.desc {" >> $OUTFILE
echo "  max-width: 650px;" >> $OUTFILE
echo "  padding: 2px;" >> $OUTFILE
echo "  font-size: 0.9em;" >> $OUTFILE
echo "}" >> $OUTFILE

echo "td.green {" >> $OUTFILE
echo "  text-align: center;" >> $OUTFILE
echo "  vertical-align: middle;" >> $OUTFILE
echo "  padding: 2px;" >> $OUTFILE
echo "  background: #01DF01;" >> $OUTFILE
echo "  min-width: 50px;" >> $OUTFILE
echo "}" >> $OUTFILE

echo "td.yellow {" >> $OUTFILE
echo "  text-align: center;" >> $OUTFILE
echo "  vertical-align: middle;" >> $OUTFILE
echo "  padding: 2px;" >> $OUTFILE
echo "  background: #F4FA58;" >> $OUTFILE
echo "  min-width: 50px;" >> $OUTFILE
echo "}" >> $OUTFILE

echo "td.red {" >> $OUTFILE
echo "  text-align: center;" >> $OUTFILE
echo "  vertical-align: middle;" >> $OUTFILE
echo "  padding: 2px;" >> $OUTFILE
echo "  background: #FE2E2E;" >> $OUTFILE
echo "  min-width: 50px;" >> $OUTFILE
echo "}" >> $OUTFILE
echo "</style>" >> $OUTFILE

## CSS beautification end ##

echo "</head>" >> $OUTFILE
echo "<body><div class=\"main\">" >> $OUTFILE
echo "<center>Last update: " >> $OUTFILE
date >> $OUTFILE
echo "</center>" >> $OUTFILE
echo "<h1>PETSc Test Summary</h1>" >> $OUTFILE
echo "<p>This page is an automated summary of the output generated by the Nightly logs. It provides a quick overview of the test results rather than trying to be a full-fledged testing solution.</p>" >> $OUTFILE

print_timestamp()
{
    # Parse start and end time stamps from log file and convert to seconds since begin of that day
    starttime_sec=`grep "^Build on\|^Starting on\|^Starting Configure" $f | sed 's/.* \([0-9]*[0-9]\):\([0-9][0-9]\):\([0-9][0-9]\).*/\3/'`
    starttime_min=`grep "^Build on\|^Starting on\|^Starting Configure" $f | sed 's/.* \([0-9]*[0-9]\):\([0-9][0-9]\):\([0-9][0-9]\).*/\2/'`
    starttime_hour=`grep "^Build on\|^Starting on\|^Starting Configure" $f | sed 's/.* \([0-9]*[0-9]\):\([0-9][0-9]\):\([0-9][0-9]\).*/\1/'`
    starttime=$(($((10#$starttime_sec))+$((10#$starttime_min))*60+$((10#$starttime_hour))*3600))

    endtime_sec=`grep "Finished Build on\|^Finishing at\|^Finishing Configure" $f | tail -1 | sed 's/.* \([0-9]*[0-9]\):\([0-9][0-9]\):\([0-9][0-9]\).*/\3/'`
    endtime_min=`grep "Finished Build on\|^Finishing at\|^Finishing Configure" $f | tail -1 | sed 's/.* \([0-9]*[0-9]\):\([0-9][0-9]\):\([0-9][0-9]\).*/\2/'`
    endtime_hour=`grep "Finished Build on\|^Finishing at\|^Finishing Configure" $f | tail -1 | sed 's/.* \([0-9]*[0-9]\):\([0-9][0-9]\):\([0-9][0-9]\).*/\1/'`
    endtime=$(($((10#$endtime_sec))+$((10#$endtime_min))*60+$((10#$endtime_hour))*3600))

    # Take into account that test might run over midnight or noon
    if [ $((starttime)) -gt $((endtime)) ]
    then
      if [ $starttime_hour -lt 13 ]   # check for 12 or 24 hour format
      then
        endtime=$((endtime+12*3600))
      else
        endtime=$((endtime+24*3600))
      fi
    fi

    # Compute time taken and print output of the form HH:MM:SS
    timetaken=$((endtime - starttime))
    timetaken_hour=`printf '%02d' $((10#$timetaken / 3600))`
    timetaken_min=`printf '%02d' $(((10#$timetaken - 10#$timetaken_hour * 3600) / 60))`
    timetaken_sec=`printf '%02d' $((10#$timetaken - 10#$timetaken_hour * 3600 - 10#$timetaken_min * 60))`

    if [ $timetaken -gt 1800 ]  #Consider everything longer than 30 minutes to be a lengthy test
    then
      echo "</td><td class=\"yellow\">$timetaken_hour:$timetaken_min:$timetaken_sec</td></tr>" >> $OUTFILE
    else
      echo "</td><td class=\"green\">$timetaken_hour:$timetaken_min:$timetaken_sec</td></tr>" >> $OUTFILE
    fi
}



# Writes a full result table
# inputs:
#  $1 ... Table Title
#  $2 ... File prefix for log files
#  $3 ... Filter result (0: no, 1: yes)
#
generate_section()
{
  echo "<h3>$1</h3>" >> $OUTFILE
  echo "<center><table>" >> $OUTFILE
  if [ $3 -gt "0" ]
  then
    echo "<tr><th>Test</th><th>Warnings</th><th>Errors</th><th>Exec Time</th></tr>" >> $OUTFILE
  else
    echo "<tr><th>Test</th><th>Possible Problems</th><th>Exec Time</th></tr>" >> $OUTFILE
  fi

  for f in `ls $LOGDIR/${2}_${BRANCH}*.log`
  do
    echo "Processing file $f..."
    echo "<tr><td class=\"desc\">" >> $OUTFILE
    if [ $3 -gt "0" ]  # Link to filtered log file as well
    then
      echo "<a href=\"filtered-${f#$LOGDIR/}\">${f#$LOGDIR/}</a> <a href=\"${f#$LOGDIR/}\" style=\"font-size: 0.8em;\">(full output)</a>" >> $OUTFILE
    else
      echo "<a href=\"${f#$LOGDIR/}\">${f#$LOGDIR/}</a>" >> $OUTFILE
    fi

    # Grep warnings
    filtered_warnings=`grep "[Ww]arning[: ]" $f \
        | grep -v 'unrecognized #pragma' \
        | grep -v "warning: ‘SSL" \
        | grep -v "warning: ‘BIO_" \
        | grep -v "warning: treating 'c' input as 'c++' when in C++ mode" \
        | grep -v 'warning: statement not reached' \
        | grep -v 'warning: loop not entered at top' \
        | grep -v 'warning: no debug symbols in executable (-arch x86_64)' \
        | grep -v 'cusp/complex.h' | grep -v 'cusp/detail/device/generalized_spmv/coo_flat.h' \
        | grep -v 'thrust/detail/vector_base.inl' | grep -v 'thrust/detail/tuple_transform.h' | grep -v 'detail/tuple.inl' | grep -v 'detail/launch_closure.inl'`
    filtered_warnings_num="0"
    if [ "$filtered_warnings" != "" ]; then
      filtered_warnings_num=`echo "$filtered_warnings" | wc -l`
    fi

    # Grep errors (with context)
    filtered_errors=`grep -B 2 -A 5 " [Kk]illed\| [Ff]atal[: ]\| [Ee][Rr][Rr][Oo][Rr][: ]" $f`
    filtered_errors_num=`grep " [Kk]illed\| [Ff]atal[: ]\| [Ee][Rr][Rr][Oo][Rr][: ]" $f | wc -l`

    # Write filtered log file if needed
    if [ $3 -gt "0" ]
    then
      echo -e "---- WARNINGS ----\n"  > $LOGDIR/filtered-${f#$LOGDIR/}
      echo "$filtered_warnings"      >> $LOGDIR/filtered-${f#$LOGDIR/}
      echo -e "\n---- ERRORS ----\n" >> $LOGDIR/filtered-${f#$LOGDIR/}
      echo "$filtered_errors"        >> $LOGDIR/filtered-${f#$LOGDIR/}
    fi

    if [ $3 -gt "0" ]
    then
      # Write number of warnings:
      if [ "$filtered_warnings_num" -gt "0" ]
      then
	    echo "</td><td class=\"yellow\">$filtered_warnings_num</td>" >> $OUTFILE
      else
	    echo "</td><td class=\"green\">$filtered_warnings_num</td>" >> $OUTFILE
      fi

      # Write number of errors:
      if [ "$filtered_errors_num" -gt "0" ]
      then
	    echo "</td><td class=\"red\">$filtered_errors_num</td>" >> $OUTFILE
      else
	    echo "</td><td class=\"green\">$filtered_errors_num</td>" >> $OUTFILE
      fi
    else # do not count warnings and errors separately, only report possible problems:
      possible_problems=`grep -i "Possible problem" $f | wc -l`
      if [ "$possible_problems" -gt "0" ]
      then
	    echo "</td><td class=\"yellow\">$possible_problems</td>" >> $OUTFILE
      else
	    echo "</td><td class=\"green\">$possible_problems</td>" >> $OUTFILE
      fi
    fi

    print_timestamp

  done
  echo "</table></center>" >> $OUTFILE
}

generate_configure_section()
{
  echo "<h3>Configure</h3>" >> $OUTFILE
  echo "<center><table>" >> $OUTFILE
  echo "<tr><th>Configuration</th><th>Status</th><th>Exec Time</th></tr>" >> $OUTFILE

  for f in `ls $LOGDIR/configure_${BRANCH}*.log`
  do
    echo "Processing file $f..."
    echo "<tr><td class=\"desc\">" >> $OUTFILE
    echo "<a href=\"${f#$LOGDIR/}\">${f#$LOGDIR/}</a>" >> $OUTFILE

    # Check for "Configure stage complete" string
    stagecomplete=`grep "Configure stage complete" $f | wc -l`
    if [ "$stagecomplete" -gt "0" ]
    then
	  echo "</td><td class=\"green\">Success</td>" >> $OUTFILE
      print_timestamp
    else
	  echo "</td><td class=\"red\">Fail</td><td class=\"red\">Fail</td></tr>" >> $OUTFILE
    fi

  done
  echo "</table></center>" >> $OUTFILE

}

############ Part 1: Build ####################
#generate_section Build     build     1  # Considered duplicative by Barry
generate_section Make      make      1
generate_section Examples  examples  0
generate_configure_section


echo "</div></body></html>" >> $OUTFILE

