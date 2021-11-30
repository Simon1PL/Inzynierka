# Remotely-managed DVB-T Tuner - frontend
### Run:
1. Run raspberry or other device with the TV antenna and DVB-T tuner connected. (This device should be on all the time, backend app is recomended to be run there)
2. Install tvheadend on the device from last point
3. Run server app, run post method(serverUrl/generate/example) to generate example database
4. Run backend app, set properties:
  - tvheadened.username=yourUsername (default for raspberry: pi)
  - tvheadened.password=yourPassword (default for raspberry: raspberry)
  - tvheadened.url=raspberryUrl:9981 (example: http://192.168.0.112:9981)
  - server.url=serverUrl
#### Development:
1. install flutter sdk(and add it to path)
2. run from console(on web browser): "flutter run -d edge" or "flutter run -d chrome"
3. if sth goes wrong type: "flutter doctor" or "flutter doctor -v"
4. run on mobile device emulator: install android studio
#### Production:

### Links:
- [backend](https://github.com/pawel00100/Tuner) - application on device with tuner
- [server](https://github.com/what-ewer/Remotely-Managed-DVB-T-Tuner-backend), [server on heroku](https://github.com/Simon1PL/inzynierka_server) - middleware between backend and frontend
- [frontend](https://github.com/Simon1PL/Inzynierka) - mobile app
- [flutter documentation](https://flutter.dev/docs)
