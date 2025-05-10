public with sharing class ViaCepService {
    @AuraEnabled(cacheable=false)
    public static String buscarEnderecoPorCep(String cep) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint('https://viacep.com.br/ws/' + cep + '/json/');
        request.setMethod('GET');
        request.setTimeout(5000);

        HttpResponse response = http.send(request);

        if (response.getStatusCode() == 200 && !String.isBlank(response.getBody())) {
            System.debug('🔍 JSON viaString: ' + response.getBody());
            return response.getBody(); // retorna o JSON bruto
        } else {
            throw new AuraHandledException('Erro ao consultar o ViaCEP: Status ' + response.getStatus());
        }
    }
}
