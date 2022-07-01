({
	 getInfoExamples: function(component, event, helper) {
        var action = component.get("c.fetchExamples");
        action.setParams({
            'recordId': component.get('v.recordId')
        });
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS" && response.getReturnValue() != null) {
                var storeResponse = response.getReturnValue();
                component.set('v.filteredData', storeResponse);
                helper.preparePagination(component, storeResponse);
            }else if(state === "SUCCESS" && response.getReturnValue() == null){
                this.showToast(component, event, helper, "System error. Please contact the administrator", "error", response.getError()[0].message);
                $A.get("e.force:closeQuickAction").fire();
            } else {
                this.showToast(component, event, helper, "System error. Please contact the administrator", "error", response.getError()[0].message);
                $A.get("e.force:closeQuickAction").fire();
            }
        });
        $A.enqueueAction(action);
    },
	 
   showToast: function(component, event, helper, title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type": type,
            "message": message
        });
        toastEvent.fire();
    },

	preparePagination: function(component, exampleRecords) {
        let countTotalPage = Math.ceil(exampleRecords.length / component.get("v.pageSize"));
        let totalPage = countTotalPage > 0 ? countTotalPage : 1;
        component.set("v.totalPages", totalPage);
        component.set("v.currentPageNumber", 1);
        this.setPageDataAsPerPagination(component);
    },

    setPageDataAsPerPagination: function(component) {
        let data = [];
        let pageNumber = component.get("v.currentPageNumber");
        let pageSize = component.get("v.pageSize");
        let filteredData = component.get('v.filteredData');
        let x = (pageNumber - 1) * pageSize;
        for (; x < (pageNumber) * pageSize; x++) {
            if (filteredData[x]) {
                data.push(filteredData[x]);
            }
        }

        component.set('v.examples', data);
        console.log(component.get('v.examples'));
    },




})