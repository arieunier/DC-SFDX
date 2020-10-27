import { LightningElement, wire , api} from 'lwc';
import getServiceAttributes from '@salesforce/apex/ServiceAttributeControler.getServiceAttributes';
import {FlowAttributeChangeEvent, FlowNavigationNextEvent} from 'lightning/flowSupport';

export default class LoadServiceAttributes extends LightningElement {
    @api ServiceDefinitionId;
    @api AttributeContent;

    // Get data from the apex sergice
    @wire (getServiceAttributes, { 
            serviceId: '$ServiceDefinitionId'
        }
        ) 
        serviceAttributes;
    // check if a content is null
    checkIsEmpty(inputparam){
        return (inputparam == null || inputparam == '');
    }

    // generates the json structure
    generateServiceAttribute(event){
        this.AttributeContent = "";
        var AttributeContentDict={};

        var inputs=this.template.querySelectorAll(".inp");
        console.log(inputs);
        inputs.forEach(function(element)
        {
            console.log("Entering for each function");
            console.log(element.name);
            AttributeContentDict[element.name]=element.value;
            /*
            if (this.AttributeContent == "{")
                this.AttributeContent  = "{'" + element.name + "': '" + element.value + "'" ;
            else
                this.AttributeContent  = ", '" + element.name + "': '" + element.value + "'" ;
            */
        }, this);
        this.AttributeContent = JSON.stringify(AttributeContentDict);
        console.log("Generated Structure => " + this.AttributeContent);
        const attributeChangeEvent = new FlowAttributeChangeEvent('AttributeContent', this.AttributeContent);
        this.dispatchEvent(attributeChangeEvent);  
    }

    @api 
    //Go to Next screen of Flow
    handleNext(event){ 
    console.log("Requested to go to the next page");
    const nextNavigationEvent = new FlowNavigationNextEvent();
    this.dispatchEvent(nextNavigationEvent); 
    } 
}