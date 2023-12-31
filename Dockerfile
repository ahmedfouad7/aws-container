FROM python:3.9
 


RUN mkdir -p /home/app

COPY . /home/app

WORKDIR /home/app

RUN apt-get update



# RUN apt-get install libxslt-dev libxml2-dev libpam-dev libedit-dev
# RUN aptitude install -t squeeze-backports postgresql-server-dev-9.1

#RUN  apt-get install libpq-dev


# RUN pip install setuptools
# RUN pip install Cmake
# RUN pip install numpy
# RUN pip install --no-cache-dir -r requirements.txt
RUN pip install streamlit 

#RUN pip install psycopg2-binary
# RUN pip install boto3
 

RUN apt-get update

# RUN curl -fsSLO https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz \
#   && tar xzvf docker-17.04.0-ce.tgz \
#   && mv docker/docker /usr/local/bin \
#   && rm -r docker docker-17.04.0-ce.tgz


RUN apt-get update; \
apt-get install -y wget; \
wget https://download.docker.com/linux/static/stable/x86_64/docker-20.10.9.tgz; \
tar zxvf docker-20.10.9.tgz; \
cp -f docker/docker /usr/local/bin; \
rm -fr docker-20.10.0.tgz docker; \
apt-get purge -y wget

# CMD ["python","app.py"]
CMD ["streamlit","run","app.py"]