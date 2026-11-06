library(fredr)
library(dplyr)
library(lubridate)

# Scaricamento delle serie
data1 <- fredr(
  series_id = "NAEXKP06ITQ661S",
  observation_start = as.Date("1995-01-01"),
  observation_end = as.Date("2025-12-31")
)

data2 <- fredr(
  series_id = "ITASLRTTO01IXEBSAQ",
  observation_start = as.Date("1995-01-01"),
  observation_end = as.Date("2025-12-31")
)

data3 <- fredr(
  series_id = "ITAPROINDQISMEI",
  observation_start = as.Date("1995-01-01"),
  observation_end = as.Date("2025-12-31")
)

# Selezione delle variabili e rinomina
d1 <- data1 %>% select(date, esportazioni = value)
d2 <- data2 %>% select(date, vendite = value)
d3 <- data3 %>% select(date, prod_industriale = value)

# Intersezione delle date e costruzione del dataframe
data <- d1 %>%
  inner_join(d2, by = "date") %>%
  inner_join(d3, by = "date") %>%
  arrange(date) %>%
  mutate(period = paste0(year(date), "Q", quarter(date))) %>%
  select(period, esportazioni, vendite, prod_industriale)

head(data)
tail(data)

write.csv(data, "../Dati/serie_sistemate_progetto_b.csv")
