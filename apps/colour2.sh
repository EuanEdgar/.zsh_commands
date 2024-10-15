colour(){
  printHelp() {
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

  processHex(){
    hexToDec(){
      getDigit(){
        digit=$1
        case $digit in
          A|a) digit=10 ;;
          B|b) digit=11 ;;
          C|c) digit=12 ;;
          D|d) digit=13 ;;
          E|e) digit=14 ;;
          F|f) digit=15 ;;
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
    fi

    red=${hex:1:2}
    green=${hex:3:2}
    blue=${hex:5:2}

    setColour $(hexToDec $red) $(hexToDec $green) $(hexToDec $blue)
  }

  processConcat() {
    r=$(echo $1 | cut -d ' ' -f1)
    g=$(echo $1 | cut -d ' ' -f2)
    b=$(echo $1 | cut -d ' ' -f3)

    setColour $r $g $b
  }

  doPreset() {
    case $1 in
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
      prev)
        colour $OLD_COLOUR
        ;;
      *)
        printHelp
        ;;
    esac
  }

  setColour() {
    red=$1
    green=$2
    blue=$3

    oldColour=$CURRENT_COLOUR
    export OLD_COLOUR=$oldColour

    newColour="$1 $2 $3"
    export CURRENT_COLOUR=$newColour

    echo -ne "\033]6;1;bg;red;brightness;$red\a"
    echo -ne "\033]6;1;bg;green;brightness;$green\a"
    echo -ne "\033]6;1;bg;blue;brightness;$blue\a"
  }

  isHex() {
    [[ $1 =~ ^#\[0-9a-fA-F]{6}$ ]]
  }

  isTrio() {
    isNumber() {
      [ -n $1 ] && [[ $1 =~ ^[0-9]{1,3}$ ]]
    }
    isNumber $1 && isNumber $2 && isNumber $3
  }

  isConcat() {
    [ -n $1 ] && [[ $1 =~ "([0-9]{1,3}) ([0-9]{1,3}) ([0-9]){1,3}" ]]
  }

  isNumber() {
    [ -n $1 ] && [[ $1 =~ ^[0-9]{1,3}$ ]]
  }

  if [ -n $1 ] && ([ $1 = '-h' ] || [ $1 = '--help' ]); then
    printHelp
  elif isHex $@; then
    processHex $@
  elif isConcat $@; then
    processConcat $@
  elif isTrio $@; then
    setColour $@
  else
    doPreset $@
  fi
}
