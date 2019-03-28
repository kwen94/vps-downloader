from flask import Flask, abort, Response, request
import os
import requests

app = Flask(__name__)
app.config["DEBUG"]  = False

file_obj = None

def generate(file_obj):
    while True:
        content = file_obj.raw.read(102400)
        if content:
            yield content
        else:
            break

@app.route('/kwen/download', methods=['GET'])
def download_file():
    try:
        url = request.args.get('url')
        filename = os.path.basename(url)
        file_obj = requests.get(url, stream=True)
        headers = file_obj.headers

        s = Response(generate(file_obj), content_type=headers.get('Content-Type'))

        for k, v in headers.items():
            s.headers[k] = v
        s.headers['Content-Disposition'] = "attachment; filename={}".format(filename)
        return s

    except Exception as e:
        if file_obj is not None:
            file_obj.close()
        Response.close()
        abort(404)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=8000)