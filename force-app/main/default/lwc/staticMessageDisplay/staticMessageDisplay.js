import { LightningElement, track } from 'lwc';

export default class StaticMessageDisplay extends LightningElement {
    @track inputText = '';
    @track _highlight = false;

    get hasMessage() {
        return this.inputText.trim().length > 0;
    }

    get displayMessage() {
        return `Hello, ${this.inputText}!`;
    }

    get messageBoxClass() {
        return this._highlight ? 'message-box flash-active' : 'message-box';
    }

    handleInputChange(event) {
        this.inputText = event.detail.value;
        if (this.hasMessage) {
            this._highlight = true;
        }
    }

    handleTransitionEnd() {
        if (this._highlight) {
            this._highlight = false;
        }
    }
}