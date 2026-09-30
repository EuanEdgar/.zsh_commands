current_date() {
  date -u +%Y-%m-%d $@
}

date_iso() {
  date -u +%Y-%m-%dT%H:%M:%SZ $@
}

date_ms() {
  date +%s $@
}
