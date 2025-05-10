public with sharing class IniciarAtualizacaoEndereco {
    
    @AuraEnabled
    public static void salvarEnderecoNaConta(String contaId, String cep) {
        System.enqueueJob(new AtualizarEnderecoContaJob(cep, contaId));
    }
}
