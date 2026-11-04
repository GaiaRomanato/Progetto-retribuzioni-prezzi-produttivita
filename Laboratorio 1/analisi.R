library(fredr)
library(readr)
fredr_set_key("3726b1e53701c00cdd0eb1184ee0f7c3")

data1 = fredr(
    series_id = "ITACPIALLQINMEI",
    observation_start = as.Date("1995-01-01"),
    observation_end = as.Date("2025-12-31")
)

data2 <- read_csv("ECB Data Portal_20261103124508.csv")
data3 <- read_csv("ECB Data Portal_20261103124429.csv")

names(data1)   # CPI
names(data2)   # Labour productivity
names(data3)   # Labour compensation

data <- as.data.frame(cbind(data2$`TIME PERIOD`[1:121], data1$value,
                            data2$`Labour Productivity (per hours worked), index (MNA.Q.Y.IT.W0.S1.S1._Z.LPR_HW._Z._T._Z.IX.LR.N)`[1:121],
                            data3$`Hourly compensation, index (MNA.Q.Y.IT.W2.S1.S1._Z.COM_HW._Z._T._Z.IX.V.N)`[1:121]))
colnames(data) = c("period", "cpi", "labour.productivity", "labour.compensation")
head(data)

write.csv(data, "dati economici.csv")
