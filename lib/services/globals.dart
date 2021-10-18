library globals;

// TO DO: zmienic na zmienne zapamietywane gdzies w pamieci urzadzenia(teraz po refreshu znikaja, na telu pewnie po restarcie apki tez)
String url = "http://localhost:5000";
List<int> tunerIds = [];
int? selectedTunerId;
String? username, password; // zamiast tego moze byc jakis token? (chodzi o przekazywanie tego pozniej do serwera przy zapytaniach zeby zweryfikowac uzytkownika)
