FROM python:2.7

# create honeybee folder
WORKDIR /usr/local/hb_docker
RUN chown $USER:$USER /usr/local/hb_docker
RUN chmod -R +wxr /usr/local/hb_docker

# install python dependencies
COPY requirements.txt requirements.txt
RUN pip install -r requirements.txt

# copy radiance libraries
RUN mkdir -p /usr/local/radiance
COPY ./radiance/bin /usr/local/radiance/bin
COPY ./radiance/lib /usr/local/radiance/lib/ray
RUN chown $USER:$USER /usr/local/radiance
RUN chmod -R +wxr /usr/local/radiance
ENV RAYPATH=/usr/local/radiance/lib/ray

# create jobs folder as place holder
COPY ./jobs /jobs

# this didn't solve the permission issues for celery.
# for now running everything as root.
# RUN chown nobody: /jobs && chmod u+rwX /jobs

# copy ladybug and honeybee libraries.
COPY ./ladybug ./ladybug
COPY ./honeybee ./honeybee

# copy all the python files for the app
COPY ./*.py ./

EXPOSE 5000
