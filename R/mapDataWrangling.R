library(tidyverse)
library(maps)

setwd("/Users/maxkinsel/Desktop/School\ 20-21/INFO\ 201/A7/INFO201-BB-Final-Project/R/")
disciplineRaw <- read.delim("data/Discipline.csv", sep = ",")
enrollmentRaw <- read.delim("data/Enrollment.csv", sep = ",")

disciplineFinal <- disciplineRaw %>%
  filter(fips != 3, fips != 7, fips != 14, fips != 43, fips != 52, fips != 2, fips != 15, fips < 57, fips > 0) %>%
  filter(sex < 3, sex > 0) %>%
  filter(race < 8, race > 0) %>%
  mutate(students_susp_in_sch = replace(students_susp_in_sch, students_susp_in_sch < 0, 0)) %>%
  mutate(students_susp_out_sch_single = replace(students_susp_out_sch_single, students_susp_out_sch_single < 0, 0)) %>%
  mutate(students_susp_out_sch_multiple = replace(students_susp_out_sch_multiple, students_susp_out_sch_multiple < 0, 0)) %>%
  mutate(Total_Suspensions = students_susp_in_sch + students_susp_out_sch_single + students_susp_out_sch_multiple) %>%
  select(fips, race, sex, Total_Suspensions) %>%
  group_by(fips, race, sex) %>%
  summarize(TotalSuspensions = sum(Total_Suspensions))

enrollmentFinal <- enrollmentRaw %>%
  filter(fips != 3, fips != 7, fips != 14, fips != 43, fips != 52, fips != 2, fips != 15, fips < 57, fips > 0) %>%
  filter(sex < 3, sex > 0) %>%
  filter(race < 8, race > 0) %>%
  mutate(Total_Enrollment = replace(enrollment_crdc, enrollment_crdc < 0, 0)) %>%
  select(fips, race, sex, Total_Enrollment) %>%
  group_by(fips, race, sex) %>%
  summarize(TotalEnrollment = sum(Total_Enrollment)) %>%
  ungroup() %>%
  select(TotalEnrollment)

disciplineRates <- bind_cols(disciplineFinal, enrollmentFinal) %>%
  mutate(Suspension_Rates = TotalSuspensions / TotalEnrollment)

countyShapes <- map_data("state")
codeToState <- read.delim("data/State_To_Code.csv", sep = " ,")

conversionFinal <- codeToState %>%
  filter(Code != 2, Code != 15) %>%
  mutate(region = str_trim(str_to_lower(State))) %>%
  select(Code, region)

countyConversion <- countyShapes %>%
  full_join(conversionFinal, by = "region") %>%
  mutate(fips = Code) %>%
  select(-Code)

write.csv(countyConversion, "data/fips_to_coords.csv", row.names = FALSE)
write.csv(disciplineRates, "data/discipline_rates.csv", row.names = FALSE)

getDisciplineData <- function(countyConversion, disciplineRates, therace, thesex) {
  disciplineRates <- disciplineRates %>%
    filter(race == therace, sex == thesex) %>%
    full_join(countyConversion, by = "fips")
  
  return(disciplineRates)
}

countyConversion <- read.delim("data/fips_to_coords.csv", sep = ",")
disciplineRates <- read.delim("data/discipline_rates.csv", sep = ",")

test <- getDisciplineData(countyConversion, disciplineRates, 1, 1)

test_map <- ggplot(test, aes(long, lat, group = group)) + geom_polygon(aes(group=group, fill=Suspension_Rates)) +
  coord_quickmap() +
  theme(panel.grid = element_blank(),
        axis.title = element_blank(),
        axis.text = element_blank(),
        axis.ticks = element_blank(),
        panel.background = element_blank())

print(test_map)
