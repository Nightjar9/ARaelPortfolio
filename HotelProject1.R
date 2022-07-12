install.packages("tidyverse")
install.packages("skimr")
install.packages("janitor")
#Open
library(tidyverse)
library(skimr)
library(janitor)

bookings_df <- read_csv("hotel_bookings.csv")

glimpse(bookings_df)
colnames(bookings_df)
skim_without_charts(bookings_df)

#Trim
trimmed_df <- bookings_df %>% 
  select(hotel, is_canceled, lead_time)
trimmed_df %>% 
  select(hotel, is_canceled, lead_time) %>% 
  rename(hotel_type = hotel)
#Select/mutate
example_df <- bookings_df %>%
  select(arrival_date_year, arrival_date_month) %>% 
  unite(arrival_month_year, c("arrival_date_month", "arrival_date_year"), sep = " ")

example_df <- bookings_df %>%
  mutate(guests = adults + children + babies)

example_df <- bookings_df %>%
  summarize(number_canceled = sum(is_canceled),
            average_lead_time = mean(lead_time))

head(example_df)

select(bookings_df=is_canceled)

#Part 2
library(tidyverse)
library(skimr)
library(janitor)
hotel_bookings <- read_csv("hotel_bookings.csv")
head(hotel_bookings)
glimpse(hotel_bookings)
class("arrival_date_month")
arrange(hotel_bookings, lead_time)
hotel_bookings_v2 <-
  arrange(hotel_bookings, desc(lead_time))

max(hotel_bookings$lead_time)
min(hotel_bookings$lead_time)
mean(hotel_bookings$lead_time)
mean(hotel_bookings_v2$lead_time)

hotel_bookings_city <- 
  filter(hotel_bookings, hotel_bookings$hotel=="City Hotel")
head(hotel_bookings_city)
mean(hotel_bookings_city$lead_time)
hotel_summary <- 
  hotel_bookings %>%
  group_by(hotel) %>%
  summarise(average_lead_time=mean(lead_time),
            min_lead_time=min(lead_time),
            max_lead_time=max(lead_time))