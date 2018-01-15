FROM sflyr/sqlplus

MAINTAINER hettling

RUN apt-get update
RUN apt-get -y install cron r-base wget

# Install shiny server
RUN wget https://download3.rstudio.org/ubuntu-12.04/x86_64/shiny-server-1.5.5.872-amd64.deb
RUN dpkg -i shiny-server-1.5.5.872-amd64.deb
 
# Add shiny application 	
ADD shiny/* /srv/shiny-server/harvest-monitor/

# Add script to run SQL query in cron job
# and to set environment
ADD run.sh /
ADD set-env.sh /
	
# Add SQL query script
ADD script-txt.sql /

# Add other scripts
ADD analyse-harvest-errors.R /
	
# Add crontab file in the cron directory
ADD crontab /etc/cron.d/my-crontab

# Give execution rights on the cron job
RUN chmod 0644 /etc/cron.d/my-crontab

# install R dependencies
RUN R -e "install.packages(c('shiny', 'DT'), repos='http://cran.rstudio.com/')"	
## RUN R -e 'for (p in c("shiny", "DT")) if (!require(p, character.only=TRUE)) install.packages(p, repos="http://cran.us.r-project.org")'
	
RUN touch /var/log/cron.log

EXPOSE 3840

# Environment variables: User, password and database server
ENV USER ""
ENV PASS ""
ENV SERVER ""
	
## RUN service cron start

## CMD /bin/bash
					
# XXX The tail -f is needed to not exit the shell!
CMD sh /set-env.sh && service cron start && shiny-server && tail -f /var/log/cron.log
