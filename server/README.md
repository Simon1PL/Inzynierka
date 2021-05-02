# Inżynierka - server - zdalnie zarządzany tuner telewizji cyfrowej

## Prerequisites
Python 3 and pip3 are required for running the project locally.

## Local development
Create virtual environment and activate it:
```
python3 -m venv venv
. venv/bin/activate (linux)
venv\Scripts\activate (windows)
```

Install dependencies:
```
pip3 install -r requirements.txt
```

Run the project:
```
FLASK_APP=router.py flask run (linux)
$env:FLASK_APP = "router.py" (windows)
$env:FLASK_DEBUG = "1" (windows)
flask run (windows)
```

To autoreload the application upon code change:
```
FLASK_APP=router.py FLASK_DEBUG=1 flask run
```
