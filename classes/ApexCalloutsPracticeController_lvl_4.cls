/**
 * Created by User on 19.12.2018.
 */

public with sharing class ApexCalloutsPracticeController_lvl_4 {
    publick String methodA(){
	return 'Hi!'; 
    }
	
    @RemoteAction
    public static String putStringJSON(String dateSelect) {
        String stringJson;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('http://www.nbrb.by/API/ExRates/Rates?onDate=' + dateSelect + '&Periodicity=0');
        request.setMethod('GET');
        HttpResponse response = http.send(request);
// If the request is successful, parse the JSON response.
        if (response.getStatusCode() == 200) {
            stringJson = response.getBody();
        } 
        return stringJson;
    }
}