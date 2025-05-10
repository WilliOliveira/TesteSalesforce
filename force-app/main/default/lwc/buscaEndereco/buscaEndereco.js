import { LightningElement, track, api } from 'lwc';
import buscarEnderecoPorCep from '@salesforce/apex/ViaCepService.buscarEnderecoPorCep';
import salvarEnderecoNaConta from '@salesforce/apex/IniciarAtualizacaoEndereco.salvarEnderecoNaConta';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class BuscaEndereco extends LightningElement {
    @api recordId;
    cep;
    @track endereco;
    erro;

    handleCepChange(event) {
        this.cep = event.target.value;
    }

    async buscarEndereco() {
        console.log('🟡 Clicado');
        this.endereco = null;
        this.erro = null;
        try {
            const resultadoBruto = await buscarEnderecoPorCep({ cep: this.cep });
            console.log('🟢 Resultado ViaCEP:', resultadoBruto);

            const resultado = JSON.parse(resultadoBruto);
            console.log('✅ Endereco atribuído:', resultado);
            this.endereco = resultado;
        } catch (e) {
            console.error(e);
            this.erro = 'Erro ao buscar endereço. Verifique o CEP.';
        }
    }

    async salvarNaConta() {
        try {
            await salvarEnderecoNaConta({ contaId: this.recordId, cep: this.cep });
            this.dispatchEvent(new ShowToastEvent({
                title: 'Sucesso',
                message: 'Endereço salvo na conta!',
                variant: 'success'
            }));
        } catch (e) {
            this.dispatchEvent(new ShowToastEvent({
                title: 'Erro',
                message: 'Erro ao salvar endereço.',
                variant: 'error'
            }));
        }
    }
}
