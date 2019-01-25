/**
 * Created by User on 24.12.2018.
 */
@isTest
private class ApexCalloutsPracticeController_lvl_4Test {
    @isTest
    public static void testPutStringJSON() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('AmountResource');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);

        String dateTest = '12-01-2019';
        String result = ApexCalloutsPracticeController_lvl_4.putStringJSON(dateTest);
        System.assertNotEquals(null, result, 'The callout returned a null response.');
    }

    @isTest
    public static void test1PutStringJSON() {
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('AmountResource');
        mock.setStatusCode(404);
        mock.setHeader('Content-Type', 'application/json;charset=UTF-8');
        Test.setMock(HttpCalloutMock.class, mock);

        String dateTest = '12-01-2019';
        System.assertEquals(null,
                ApexCalloutsPracticeController_lvl_4.putStringJSON(dateTest));
    }
}