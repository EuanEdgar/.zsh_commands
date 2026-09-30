source "$COMMANDS_PATH/apps/wrappers/_shared.sh"

function curse {
  local curses=(
    "A hush will fall when you speak of home, and even the gulls will turn inland."
    "Keep the door latched; the wind has learned your footsteps."
    "The sea keeps accounts; it has not forgotten your debt of salt."
    "When the third lamp gutters, tread no shadow that knows you."
    "Do not answer if the old well calls; it knows only thirst."
    "Your true name will taste of ash to a faithless tongue."
    "On the night without a moon, your shadow will walk before you."
    "Where you plant your feet, the fern will not grow for a year and a day."
    "A fishbone will lodge beneath the law you swear."
    "What you bargain for at dusk will cost you at dawn."
    "The island dreams you; wake gently or be unmade."
    "The tide will lay out your path and swallow your return."
    "If the cliff answers, do not listen twice."
    "You will find your reflection mending nets that are not yours."
    "A gull will drop a shell at your step; take warning or be broken likewise."
    "Names will come to you like knives wrapped in linen."
    "The oars will remember when your hands do not."
    "A red thread will measure you from crown to heel."
    "When the fog learns your house, guests will not find it again."
    "Your boat will know the shoals that were not there yesterday."
    "A hearth laid cold is a door; do not step through."
    "Between word and wind, you will owe the silence."
    "Salt will not keep what you are set to lose."
    "The gull that circles thrice will count your days."
    "Iron will grow light in your palm when promises turn heavy."
    "The shore will move while you sleep; wake where you did not lie."
    "Your shadow will learn to swim before you do."
    "Do not follow the cat that knows your middle name."
  )

  # zsh arrays are 1-indexed; choose a random element accordingly
  local idx=$(( (RANDOM % ${#curses[@]}) + 1 ))
  local omen="${curses[$idx]}"
  local italic_start=$'\e[3m'
  local italic_end=$'\e[0m'
  local omen_italic="${italic_start}${omen}${italic_end}"

  run_wrapper "cursor" "$omen_italic" "" ".curse" -n "$@"
}
