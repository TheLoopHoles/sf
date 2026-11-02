import { LightningElement } from 'lwc';

export default class AccountLookupEditor extends LightningElement {
    selectedAccountId;

    handleAccountSelect(event){
        this.selectedAccountId = event.detail.recordId;

        console.log('Selected Account ID: ', this.selectedAccountId);
    }
}