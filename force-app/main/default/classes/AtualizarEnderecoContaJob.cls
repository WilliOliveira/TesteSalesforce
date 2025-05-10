public class AtualizarEnderecoContaJob implements Queueable, Database.AllowsCallouts {
    private String cep;
    private Id contaId;

    public AtualizarEnderecoContaJob(String cep, Id contaId) {
        this.cep = cep;
        this.contaId = contaId;
    }

    public void execute(QueueableContext context) {
        // Realiza o callout e recebe JSON bruto
        String json = ViaCepService.buscarEnderecoPorCep(cep);
        Map<String, Object> endereco = (Map<String, Object>) System.JSON.deserializeUntyped(json);

        Account conta = [SELECT Id FROM Account WHERE Id = :contaId LIMIT 1];
        conta.BillingPostalCode = (String) endereco.get('cep');
        conta.BillingStreet     = (String) endereco.get('logradouro');
        conta.BillingCity       = (String) endereco.get('localidade');
        conta.BillingState      = (String) endereco.get('uf');
        conta.BillingCountry    = 'Brasil';

        update conta;
    }
}
