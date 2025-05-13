@isTest
private class TesteEnderecoQueueable {

    class MockViaCepResponse implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"cep":"01001-000","logradouro":"Praça da Sé","localidade":"São Paulo","uf":"SP"}');
            res.setStatusCode(200);
            return res;
        }
    }

    @isTest
    static void testQueueableJobAtualizaConta() {
        Account conta = new Account(Name='Teste');
        insert conta;

        Test.setMock(HttpCalloutMock.class, new MockViaCepResponse());

        Test.startTest();
        AtualizarEnderecoContaJob job = new AtualizarEnderecoContaJob('01001000', conta.Id);
        System.enqueueJob(job);
        Test.stopTest();

        Account atualizada = [SELECT BillingStreet, BillingCity, BillingState FROM Account WHERE Id = :conta.Id];
        System.assertEquals('Praça da Sé', atualizada.BillingStreet);
        System.assertEquals('São Paulo', atualizada.BillingCity);
        System.assertEquals('SP', atualizada.BillingState);
    }

    @isTest
    static void testMetodoAuraIniciarAtualizacaoEndereco() {
        Account conta = new Account(Name='Teste Aura');
        insert conta;

        Test.setMock(HttpCalloutMock.class, new MockViaCepResponse());

        Test.startTest();
        IniciarAtualizacaoEndereco.salvarEnderecoNaConta(conta.Id, '01001000');
        Test.stopTest();
    }
}
