import { LightningElement, api, wire } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';

import getBestTransporteurMoinsCher from '@salesforce/apex/TransporteurController.getBestTransporteurMoinsCher';
import getBestTransporteurPlusRapide from '@salesforce/apex/TransporteurController.getBestTransporteurPlusRapide';
import getAllTransporteurs from '@salesforce/apex/TransporteurController.getAllTransporteurs';
import updateOrderTransporteur from '@salesforce/apex/TransporteurController.updateOrderTransporteur';

import PAYS_FIELD from '@salesforce/schema/Order.Pays_Livraison__c';


export default class OrderTransporter extends LightningElement {

    @api recordId;

    selectedCritere;
    transporteur;
    transporteurs = [];
    selectedTransporteur;
    validatedTransporteur;

    errorMessage;
    isLoading = false;

    columns = [
        { label: 'Nom', fieldName: 'transporteurName' },
        { label: 'Pays', fieldName: 'Pays__c' },
        { label: 'Prix', fieldName: 'Tarifs__c', type: 'number' },
        { label: 'Délai', fieldName: 'D_lai_de_Livraison_jours__c', type: 'number' }
    ];

    deliveryOptions = [
        { label: 'Moins cher', value: 'Prix' },
        { label: 'Plus rapide', value: 'Delai' },
        { label: 'Tous les transporteurs', value: 'Tous' }
    ];

    @wire(getRecord, { recordId: '$recordId', fields: [PAYS_FIELD] })
    order;

    get pays() {
        return this.order.data ? getFieldValue(this.order.data, PAYS_FIELD) : null;
    }

    get isConfirmDisabled() {
        return this.isLoading || !this.selectedCritere;
    }

    get isValidateDisabled() {
        return !this.selectedTransporteur;
    }

    get hasTransporteurs() {
        return this.transporteurs && this.transporteurs.length > 0;
    }

    handleChange(event) {
        this.selectedCritere = event.detail.value;
        this.transporteur = null;
        this.transporteurs = [];
        this.selectedTransporteur = null;
        this.errorMessage = null;

        this.handleConfirm();
    }

       handleConfirm() {

        console.log('CONFIRM CLICK');

        this.errorMessage = null;
        this.transporteur = null;
        this.transporteurs = [];
        this.selectedTransporteur = null;

        if (!this.pays) {
            this.errorMessage = "Pays manquant sur la commande";
            return;
        }

        this.isLoading = true;

        if (this.selectedCritere === 'Prix') {
            this.handlerGetBestTransporteurMoinsCher();
        } 
        else if (this.selectedCritere === 'Delai') {
            this.handlerGetBestTransporteurPlusRapide();
        } 
        else if (this.selectedCritere === 'Tous') {
            this.handlerGetAllTransporteurs();
        }
    }
   
    handlerGetBestTransporteurMoinsCher() {
        getBestTransporteurMoinsCher({ pays: this.pays, orderId: this.recordId })
            .then(result => {
                this.transporteur = result;
            })
            .catch(error => {
                this.errorMessage = error.body?.message;
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    handlerGetBestTransporteurPlusRapide() {
        getBestTransporteurPlusRapide({ pays: this.pays, orderId: this.recordId })
            .then(result => {
                this.transporteur = result;
            })
            .catch(error => {
                this.errorMessage = error.body?.message;
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    handlerGetAllTransporteurs() {
        getAllTransporteurs({ pays: this.pays, orderId: this.recordId })
            .then(result => {

                this.transporteurs = result.map(t => ({
                    ...t,
                    transporteurName: t.Transporteur__r.Name
                }));

            })
            .catch(error => {
                this.errorMessage = error.body?.message;
            })
            .finally(() => {
                this.isLoading = false;
            });
    }

    handleRowSelection(event) {
        const rows = event.detail.selectedRows;

        if (rows.length > 0) {
            this.selectedTransporteur = rows[0];
            this.transporteur=rows[0];
            console.log('SELECTED:', this.selectedTransporteur);
        }
    }

    handleValidateTransporteur() {

    if (!this.selectedTransporteur) {
        this.errorMessage = "Veuillez sélectionner un transporteur";
        return;
    }

    this.isLoading = true;

    updateOrderTransporteur({
        orderId: this.recordId,
        transporteurName: this.selectedTransporteur.transporteurName
    })
    .then(() => {
        this.errorMessage = null;

              this.validatedTransporteur = this.selectedTransporteur;

               this.transporteurs = [];
                this.transporteur = null;

    })
    .catch(error => {
        this.errorMessage = error.body?.message || 'Erreur';
    })
    .finally(() => {
        this.isLoading = false;
    });
}
    handleEdit() {
    this.validatedTransporteur = null;
    this.selectedTransporteur = null;
}
}