{
  writeShellApplication,
  ripgrep,
  gawkInteractive,
  ...
}:
writeShellApplication {
  name = "QS-sysinfo";
  runtimeInputs = [
    ripgrep
    gawkInteractive
  ];
  text = ''
 Pad CPU, MEM, DISK to 2 chars (right-aligned)
cpu=$(awk '/^cpu /{printf("%.0f", ($2+$4)*100/($2+$4+$5))}' /proc/stat)
cpu=$(printf "%2s" "$cpu")

mem=$(free | awk '/Mem:/ {printf("%.0f",$3/$2*100)}')
mem=$(printf "%2s" "$mem")

disk=$(df / | awk 'NR==2 {gsub("%",""); print $5}')
disk=$(printf "%2s" "$disk")

# Pad POWER to 5 chars (XX.XX)
power=$(upower -b | awk -F: '/energy-rate/ {gsub(/^[ \t]+/, "", $2); split($2,a," "); printf("%.2f", a[1])}')
power=$(printf "%5s" "$power")

# Output JSON
echo "{\"cpu\":\"$cpu\",\"mem\":\"$mem\",\"disk\":\"$disk\",\"power\":\"$power\"}"
  '';
}
