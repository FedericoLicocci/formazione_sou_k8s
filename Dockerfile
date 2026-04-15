FROM python:3.13.13-alpine

ENV APP_PATH=/usr/local/app

WORKDIR $APP_PATH

RUN pip3 install -r flask

COPY app.py $APP_PATH

ENTRYPOINT ["python3"]
CMD ["app.py"]
