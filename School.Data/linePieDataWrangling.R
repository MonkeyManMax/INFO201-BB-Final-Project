library(tidyverse)

setwd("/Users/maxkinsel/Desktop/School\ 20-21/INFO\ 201/A7/INFO201-BB-Final-Project/R/")

statesData <- read.delim("data/states_all.csv", sep = ",")
pieData <- read.delim("data/sat_act_participation.csv", sep = ",")
countyConversion <- read.delim("data/fips_to_coords.csv", sep = ",")
sat_act_participation <- read.delim("data/sat_act_participation.csv", sep = ",")

countyConversionPie <- countyConversion %>%
  group_by(region) %>%
  slice(1) %>%
  ungroup() %>%
  select(region, fips) %>%
  add_row(region = "alaska", fips = 2) %>%
  add_row(region = "hawaii", fips = 15) %>%
  filter(fips == 3)

state <- countyConversionPie [[1,1]]

pieData <- sat_act_participation %>%
  filter(year == 2011, fips == 1)%>%
  group_by(sex)%>%
  summarise(total_participation = sum(total_participation)) %>%
  ungroup() %>%
  mutate(percent = round(total_participation * 100 / sum(total_participation), 2))

cost <- statesData %>%
  filter(State == "Alabama", YEAR > 1991, YEAR < 2017) %>%
  select(INSTRUCTION_EXPENDITURE, SUPPORT_SERVICES_EXPENDITURE, OTHER_EXPENDITURE, CAPITAL_OUTLAY_EXPENDITURE, YEAR) %>%
  gather(key = "variable", value = "value", -YEAR)

plot <- ggplot(cost, aes(x = YEAR, y = value)) + 
  geom_line(aes(color = variable), size = 1) + 
  labs(title = paste("Expenditure Breakdown for ","Alabama", " from ", "1992", " to ", "2016", sep = ""),
       y = "Expenditure (USD)", x = "Year", color = "Type of Expenditure") + 
  scale_x_continuous(minor_breaks = seq(1992, 2016, 1))

print(plot)


install.packages("ggrepel")
