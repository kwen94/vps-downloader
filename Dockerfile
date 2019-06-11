FROM elice/python-nginx:3.6

ADD entrypoint.sh /bin/entrypoint.sh
ADD vps_transfer_download.py /bin/app.py

RUN pip install --no-cache-dir requests flask \
    && nginx -t \
    && chmod u+x /bin/entrypoint.sh

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["python", "/bin/app.py"]

ENTRYPOINT ["/bin/entrypoint.sh"]
