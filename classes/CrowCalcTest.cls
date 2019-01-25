@isTest
public class CrowCalcTest {

    @testSetup
    static void setup() {
        createCrows(10);
    }

    @isTest
    public static void testAddCrows() {
        system.assertEquals(false, CrowCalc.addCrows(Null));
        system.assertEquals(true, CrowCalc.addCrows(10));
        system.assertEquals(true, CrowCalc.addCrows(9979));
       // system.assertEquals(false, CrowCalc.addCrows(10000));

    /*
        Integer initialCrows = 0;

        Boolean addCrowsResult = CrowCalc.addCrows(10);

        Integer crowsAfter = [SELECT COUNT() FROM Crow__c] - initialCrows;

        System.assert(crowsAfter == 10, 'Wrong answer!');

        System.assert(addCrowsResult, 'Success addition not "true"');
    */
    }

    @isTest
    public static void testSubtractCrows() {
        system.assertEquals(false, CrowCalc.subtractCrows(Null));
        system.assertEquals(true, CrowCalc.subtractCrows(10));
    }

    @isTest
    public static void testGetTotal() {
        System.assertEquals([SELECT COUNT() FROM Crow__c], CrowCalc.getTotal());
    }

    @isTest
    public static void testResetCalc() {
        System.assertEquals(true, CrowCalc.resetCalc());
    }

    private static void createCrows(Integer numbersInteger) {
        List<Crow__c> crows = new List<Crow__c>();
        While (numbersInteger > 0) {
            crows.add(new Crow__c());
            numbersInteger--;
        }
        insert crows;
    }
}