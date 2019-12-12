FROM python
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
EXPOSE 6002
CMD python ./kafkaconsumer.py
