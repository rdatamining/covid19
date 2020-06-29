library(openxlsx)
library(lubridate)
library(tidyverse)
library(ggplot2)
library(lemon)
library(scales)
library(magrittr)
library(tidyverse)
library(readxl)
# library(scales)
library(knitr)
library(gganimate)
library(gifski)
library(plotly)
library(RODBC)



## Animated Charts


p <- df %>% mutate(type=factor(type, levels=rev(levels(type)))) %>% 
  ggplot(aes(x=type, y=number, fill=type)) + 
  geom_bar(stat='identity') +
  facet_rep_wrap(~category, ncol=2, scales='free', repeat.tick.labels='bottom') +
  labs(title='title') +
  theme(legend.position='none',
        legend.key.size=unit(0.4, 'cm'),
        legend.text=element_text(size=7),
        axis.title.x=element_blank(),
        axis.title.y=element_blank(),
        axis.text.y=element_text(size=10)
        # axis.text.x=element_text(angle=90, hjust=1, size=7)
  ) +
  coord_flip() +
  transition_time(date) +
  labs(title="Date: {frame_time}")


animate(p, duration=5, fps=20, width=800, height=1200, renderer=gifski_renderer())
anim_save(file.path(path.output, filename))




# animate-timeline

p <- df %>% plot_ly(x=~category, y=~number, color=~type, type='bar')
fig.title <- 'title'
fig.title <- list(yref='paper', xref="paper", x=0, y=1.05, text=fig.title, showarrow=F)
p %>% layout(xaxis=list(title=''),
             yaxis=list(title="Number"),
             title=fig.title#,
             # annotations=legend.title #,
             # legend=list(x=0.7, y=1, title='Type')
) %>%
  layout(yaxis=list(type="log"))



## timeline
p <- df %>% mutate(date=as.character(date)) %>%
  plot_ly(x=~category, y=~number, color=~type,
          type ='bar', frame=~date)
fig.title <- list(yref='paper', xref="paper", x=0, y=1.05, text=fig.title, showarrow=F)
p %>% layout(xaxis=list(title=''),
             yaxis=list(title="Number"),
             title=fig.title,
             legend=list(x=0.7, y=1)
             # showlegend=F
) %>%
  animation_slider(currentvalue=list(prefix='Date: ', font=list(color='black'))) %>%
  animation_opts(frame=100, transition=0) ## time between frames (in milliseconds)
