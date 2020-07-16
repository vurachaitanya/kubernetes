
# Docker file 

- `# cat Dockerfile` for creaing webapp with python API
```

FROM python:alpine

ADD ./requirements.txt /opt/webapp/

WORKDIR /opt/webapp

RUN pip install -r requirements.txt

ADD . /opt/webapp

EXPOSE 8080

CMD python /opt/webapp/app.py
```

```
cat requirments.txt
Flask
```
```
/opt/webapp/templates # cat hello.html
<!doctype html>
<title>Hello from Flask</title>
<body style="background: {{ color }};"></body>
<div style="color: #e4e4e4;
    text-align:  center;
    height: 90px;
    vertical-align:  middle;">
{% if name %}
  <h1>Hello from {{ name }}!</h1>
{% else %}
  <h1>Hello, World!</h1>
{% endif %}

  {% if contents %}
  <textarea rows="10" cols="50">
    {{ contents }}
  </textarea>
  {% endif %}

</div>
```
