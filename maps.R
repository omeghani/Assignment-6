library(ggmap)
library(tidyverse)
library(magick)


gc <- geocode("Bude")
waterbude <- get_map(gc, maptype = "watercolor", zoom = 13)
roadbude <- get_map(gc, maptype = "roadmap", zoom = 13)
ggmap(waterbude)
ggmap(roadbude)

# getting geocodes for my locations
cbeach <- geocode("Crooklets Beach, Bude")
sbeach <- geocode("Summerleaze Beach, Bude")
pub <- geocode("Crooklets Inn, Bude")
cricket <- geocode("Bude North Cornwall Cricket Club, Bude")

# row bind geocodes so they can be marked as points/pathway on maps
mappoints <- rbind(cbeach,sbeach,cricket)%>% 
  mutate(location = c('Crooklets Beach','Summerleaze Beach','Bude North Cornwall Cricket Club'),values=30)
pathway <- rbind(cricket,pub)%>% 
  mutate(location = c('Bude North Cornwall Cricket Club','Crooklets Inn'))

# watermpa of bude
watermap <- ggmap(waterbude) +
  geom_point(
    aes(x = lon, y = lat ),
    data = mappoints, color = "green", size =2 ) 

watermap

# roadmap of bude
roadmap <- ggmap(roadbude) +
  geom_point(
    aes(x = lon, y = lat ),
    data = mappoints, color = "green", size = 2)+
  geom_path(
    aes(x = lon, y = lat), colour = "red", size = 1.5,
    data = pathway, lineend = "round")

roadmap

# images of beaches/cricket ground
crooklets <- image_scale(image_read('https://www.thebeachguide.co.uk/public/geophotos/1450635.jpg'), geometry_area(400,000))
summerleaze <- image_scale(image_read('https://www.natureflip.com/sites/default/files/photo//bude-summerleaze-beach-summerleaze-beach-at-bude-cornwall.jpg'), geometry_area(400,000))
cricketpic <- image_scale(image_read('http://c7.alamy.com/comp/EWN017/action-at-bude-north-cornwall-cricket-club-beside-the-atlantic-ocean-EWN017.jpg'), geometry_area(400,000))

# saving maps and images 
saveRDS(watermap, "watermap.RDS")
saveRDS(roadmap, "roadmap.RDS")
image_write(crooklets, "crooklets.jpg", format = "jpg")
image_write(summerleaze, "summerleaze.jpg", format = "jpg")
image_write(cricketpic, "cricketpic.jpg", format = "jpg")
