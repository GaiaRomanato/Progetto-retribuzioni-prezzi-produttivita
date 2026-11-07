library(dplyr)
library(lubridate)

data1 <- read.csv("../Dati/NAEXKP06ITQ661S.csv")
data1 <- data1 %>%
  mutate(observation_date = as.Date(observation_date)) %>%
  filter(between(observation_date, as.Date("1989-12-31"), as.Date("2023-07-02"))) %>%
  rename(date = observation_date, esportazioni = NAEXKP06ITQ661S)

data2 <- read.csv("../Dati/ITASLRTTO01IXEBSAQ.csv")
data2 <- data2 %>%
  mutate(observation_date = as.Date(observation_date)) %>%
  filter(between(observation_date, as.Date("1989-12-31"), as.Date("2023-07-02"))) %>%
  rename(date = observation_date, vendite = ITASLRTTO01IXEBSAQ)

data3 <- read.csv("../Dati/ITAPROINDQISMEI.csv")
data3 <- data3 %>%
  mutate(observation_date = as.Date(observation_date)) %>%
  filter(between(observation_date, as.Date("1989-12-31"), as.Date("2023-07-02")))%>%
  rename(date = observation_date, prod_industriale = ITAPROINDQISMEI)

# Intersezione delle date e costruzione del dataframe
data <- data1 %>%
  inner_join(data2, by = "date") %>%
  inner_join(data3, by = "date") %>%
  arrange(date) %>%
  mutate(trimestre = paste0(year(date), " Q", quarter(date))) %>%
  dplyr::select(trimestre, esportazioni, vendite, prod_industriale)

head(data)
tail(data)

write.csv(data, "../Dati/dataset_progetto_b.csv")
