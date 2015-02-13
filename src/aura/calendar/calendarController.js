({

    init: function(component, event, helper) {       
        if (typeof jQuery !== "undefined" && typeof $j === "undefined") {
            $j = jQuery.noConflict(true);;
        }        

        component.set("v.ready", true);
        console.log('Inside the Component Controller',component.get("v.ready"));
        helper.initHandlers(component);
    }

})