use context essentials2021
include shared-gdrive(
"dcic-2021",
"1wyQZj_L0qqV9Ekgr9au6RX2iqt2Ga8Ep")

include gdrive-sheets
include data-source
ssid = "1RYN0i4Zx_UETVuYacgaGfnFcv4l9zd9toQTTdkQkj7g"
kWh-wealthy-consumer-data =
load-table: komponent, energi
source: load-spreadsheet(ssid).sheet-by-name("kWh", true)
    sanitize energi using string-sanitizer
  end 

print(kWh-wealthy-consumer-data)

fun energi_til_tall(str :: String) -> Number:
  cases(Option) string-to-number(str):
    | some(a) => a
    | none => 0
  end

  where:
  energi_til_tall("") is 0
  energi_til_tall("48") is 48
end

transformed-table = transform-column(kWh-wealthy-consumer-data, "energi", energi_til_tall)
print(transformed-table)

fun bil_energi_per_dag(distance-travelled-per-day, distance-per-unit-of-fuel):
  energy-per-unit-of-fuel = 15
  ( distance-travelled-per-day /
    distance-per-unit-of-fuel ) *
  energy-per-unit-of-fuel
  
where:
  bil_energi_per_dag(15, 15) is 15
end


distance-per-day = 14
distance-per-liter = 18
total-energy-per-day = sum(transformed-table, "energi") + bil_energi_per_dag(distance-per-day, distance-per-liter)

print(total-energy-per-day)
bar-chart(transformed-table, "komponent", "energi")

fun energi_til_nummer_med_bil(str :: String) -> Number:
  cases(Option) string-to-number(str):
    | some(a) => a
    | none => bil_energi_per_dag(15, 15)
  end
where:
  energi_til_tall("") is 0
  energi_til_tall("48") is 48
end

transformed-table-with-car = transform-column(kWh-wealthy-consumer-data, "energi", energi_til_nummer_med_bil)
print(transformed-table-with-car)
bar-chart(transformed-table-with-car, "komponent", "energi")