/**
 * Created by User on 22.01.2019.
 */

global with sharing class LightningAppBuilder_CustomApex_4_lvl {
    @AuraEnabled
    global static String getUserInfo(String userId) {
        User userInfo = [
                SELECT Name, CommunityNickname, UserRoleId, CompanyName
                FROM User
                WHERE Id = :userId
        ];
        return JSON.serialize(userInfo);
    }
}