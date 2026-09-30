pnpm audit --json | jq -r '
def bt($s): "`\($s)`";

def rows_from_vulns:
  .vulnerabilities
  | to_entries[]
  | .value as $v
  | ($v.via[]? | select(type=="object")) as $a
  | [
      ($a.severity // ""),
      ($v.name // $a.name // ""),
      bt($a.range // ""),
      bt(
        if ($a.fixAvailable|type)=="object" then "\($a.fixAvailable.name)@\($a.fixAvailable.version)"
        elif ($a.fixAvailable|type)=="boolean" then (if $a.fixAvailable then "available" else "" end)
        else "" end
      )
    ];

def rows_from_advisories:
  .advisories
  | to_entries[]
  | .value
  | [
      (.severity // ""),
      (.module_name // .name // ""),
      bt(.vulnerable_versions // ""),
      bt(.patched_versions // "")
    ];

["Severity","Package","Vulnerable versions","Patched versions"],
["---","---","---","---"],
(
  if has("vulnerabilities") then [rows_from_vulns]
  elif has("advisories") then [rows_from_advisories]
  else []
  end
)[] | "| " + (map(tostring) | join(" | ")) + " |"
' | pbcopy