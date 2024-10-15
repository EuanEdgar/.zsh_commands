#!/bin/bash

usage() {
  echo "Colour:
  Sets the colour of the current terminal tab.
  This only functions in iTerm2.
  Usage: colour [colour preset]
  Usage: colour [red: 0-255] [green: 0-255] [blue: 0-255]
  Usage: colour #[hex colour string]
  Presets:
    - black
    - red
    - orange
    - yellow
    - green
    - blue
    - purple
    - magenta
    - cyan
    - white"
}

exit_missing_args=1
exit_bad_hex=2

this=$0

colour(){
  $this $@
  exit 0
}

getHex(){
  hexToDec(){
    getDigit(){
      digit=$1
      case $digit in
        a) digit=10 ;;
        b) digit=11 ;;
        c) digit=12 ;;
        d) digit=13 ;;
        e) digit=14 ;;
        f) digit=15 ;;
        A) digit=10 ;;
        B) digit=11 ;;
        C) digit=12 ;;
        D) digit=13 ;;
        E) digit=14 ;;
        F) digit=15 ;;
      esac
      echo $digit
    }

    number=$1
    digit1=${number:0:1}
    digit2=${number:1:1}

    digit1=$(getDigit $digit1)
    digit2=$(getDigit $digit2)

    expr $digit1 \* 16 + $digit2
  }

  hex=$1

  if [[ ! ${hex:1:6} =~ ^[0-9a-fA-F]{6} ]]; then
    echo "Colour: Hex strings must be in the format #[red:Hh][green:Hh][blue:Hh]"
    echo "  Example: #00c5B5"
    exit $exit_bad_hex
  fi

  red=${hex:1:2}
  green=${hex:3:2}
  blue=${hex:5:2}

  colour $(hexToDec $red) $(hexToDec $green) $(hexToDec $blue)
  exit 0
}

if [[ $(echo $1 | head -c 1) = '#' ]]; then
  getHex $1
fi

preset=$1

case $preset in
  -h)
    usage
    exit 0
    ;;
  --help)
    usage
    exit 0
    ;;
  black)
    colour 120 120 120
    ;;
  red)
    colour 255 109 103
    ;;
  orange)
    colour 252 172 84
    ;;
  yellow)
    colour 243 220 95
    ;;
  green)
    colour 179 215 88
    ;;
  blue)
    colour 101 149 197
    ;;
  purple)
    colour 196 142 214
    ;;
  magenta)
    colour 255 118 255
    ;;
  cyan)
    colour 95 253 255
    ;;
  white)
    colour 255 255 255
    ;;
esac

unset preset

red=$1
green=$2
blue=$3

missing_args() {
  usage
  exit $exit_missing_args
}

if [ -z $red ] ; then
  missing_args
fi

if [ -z $green ] ; then
  missing_args
fi

if [ -z $blue ] ; then
  missing_args
fi

# Echo iTerm-specific escape sequences to change colour
# -n to remove newline char, -e to enable proper escaping of \codes
echo -ne "\033]6;1;bg;red;brightness;$red\a"
echo -ne "\033]6;1;bg;green;brightness;$green\a"
echo -ne "\033]6;1;bg;blue;brightness;$blue\a"

exit 0
