FROM rocker/geospatial:4.1.3

COPY shinyproxy_0.0.1.tar.gz /root/

RUN R CMD INSTALL /root/shinyproxy_0.0.1.tar.gz \
    && rm /root/shinyproxy_0.0.1.tar.gz \
    && rm /etc/rstudio/rserver.conf \
    && cp /etc/rstudio/disable_auth_rserver.conf /etc/rstudio/rserver.conf \
    && echo "USER=rstudio" >> /etc/environment \
    && rm /usr/local/lib/R/etc/Rprofile.site

COPY Rprofile.site /usr/local/lib/R/etc/
