@isTest
public class ExamplesControllerTest {

    
    @TestSetup
    static void loadData(){
        Example_A__c example_A = new Example_A__c();
        insert example_A;
        
		List<Example_B__c> ltExample_B = new List<Example_B__c>();
		for(integer i = 0; i < 10; i++){
            Example_B__c example_B = new Example_B__c();
            example_B.Example_A__c = example_A.id;
            ltExample_B.add(example_B);
        }
        insert ltExample_B;
        
        List<Example_C__c> ltExample_c = new List<Example_C__c>();
        for(Example_B__c example_B: ltExample_B){
            Example_C__c example_C = new Example_C__c();
            example_C.Example_B__c = example_B.Id;
            ltExample_c.add(example_C);
        }
        
        insert ltExample_c;
        
    }
        
    @isTest
    static void success(){
        Example_A__c example_A = [SELECT ID FROM Example_A__c];
        
        Test.startTest();
        List<ExamplesController.wrappExample> fetchExamples = ExamplesController.fetchExamples(example_A.id);
        Test.stopTest();
        
		System.assertEquals(10, fetchExamples.size());

    }
    
	 @isTest
    static void error(){
        Example_A__c example_A = [SELECT ID FROM Example_A__c];
        
        Try{
        Test.startTest();
            List<ExamplesController.wrappExample> fetchExamples = ExamplesController.fetchExamples(null);
        Test.stopTest();
			System.assertEquals(0, fetchExamples.size());        
        }Catch(Exception e){
			System.assertEquals('Error', e.getMessage());
		}
    }



}