FROM ubuntu:20.04

LABEL AUTHOR="yushi.hu <huyushi@keenon.com>"

RUN apt-get -y update && apt-get -y upgrade && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone && \
    apt-get -y install htop git net-tools vim curl wget
RUN apt-get -y install python3-pip

VOLUME "/app"

# Copy whole project
ADD . /app
WORKDIR /app
EXPOSE 8000

RUN apt-get -y update && apt-get -y upgrade && apt-get install -y gettext python3-dev libmysqlclient-dev
RUN pip3 install -r requirements.txt -i https://pypi.tuna.tsinghua.edu.cn/simple

CMD [ "python3", "manage.py", "runserver", "0.0.0.0:8000" ]