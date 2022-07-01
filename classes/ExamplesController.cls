public class ExamplesController {

    @AuraEnabled
    public static List<wrappExample> fetchExamples(String recordId){
        Try{
   
			Map<String,WrappExample> mapWrappExample = new Map<String,WrappExample>();
            for(Example_B__c example_B : [SELECT Id,Name, Example_A__c FROM Example_B__c WHERE Example_A__c =: recordId ORDER BY Name]){
                WrappExample wrappExample = new WrappExample();
                wrappExample.idExample = example_B.id;
                wrappExample.nameExample = example_B.Name;
                wrappExample.Examples = new List<Object>();
				mapWrappExample.put(wrappExample.idExample,wrappExample);
             
            }
            
            if(!mapWrappExample.isEmpty()){
                for(Example_C__c example_C : [SELECT Id,Name, Example_B__c, Example_B__r.Name FROM Example_C__c WHERE Example_B__c =: mapWrappExample.keyset() ORDER BY Name]){
                    if(mapWrappExample.containsKey(example_C.Example_B__c)){ 
                      mapWrappExample.get(example_C.Example_B__c).Examples.add(example_C);    
                    }
                }
            }

            return mapWrappExample.values();
        }Catch(Exception e){
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
    public class WrappExample {
        @AuraEnabled public String idExample {get; set;}
        @AuraEnabled public String nameExample {get; set;}
        @AuraEnabled public List<Object> Examples {get; set;}
        
    }
    
}