public with sharing class CreateNumberForUser_Controller_lvl_3 {
    public List<User> allUsers { get; set; }
    public List<City_of_the_region__mdt> regionsCity;
    public List<LicenseName__c> customSt;
/*******************/
    public List<String> numberHistory;
/*******************/

    public User currentUser {
        get {
            User logUser;
            for (User user : allUsers) {
                if (user.id == UserInfo.getUserId()) {
                    logUser = user;
                    break;
                }
            }
            return logUser;
        }
        set;
    }

    public Boolean checkEmptyUsers;

    public Boolean disabledNotNullNumber {
        get {
            List<User> listNullNumberUsers = new List<User>();
            for (User user : allUsers) {
                if (user.Random_Number__c == null) {
                    listNullNumberUsers.add(user);
                }
            }
            if (listNullNumberUsers.isEmpty()) {
                return true;
            } else {
                return false;
            }

        }
        set;
    }

    public Boolean disabledNullCity {
        get {
            if (userName.City == null || userName.Random_Number__c != null) {
                return true;
            } else {
                return false;
            }
        }
        set;
    }

    public User userName {
        get {
            if (checkEmptyUsers == false) {
                userName = currentUser;
            } else {
                for (User user : allUsers) {
                    if (user.Random_Number__c == null && user.City != null) {
                        userName = user;
                        break;
                    }
                }
            }
            return userName;
        }
        set;
    }

    /*public String generatorNumbers {
        get {
            String numberRandom = '';
            if (userName.Random_Number__c == null && userName.City == null) {
                //messageError = 'You don\'t have City';
                numberRandom = 'You don\'t have City';
            } else if (userName.Random_Number__c == null && userName.City != null) {
//                messageError = 'You don\'t have number';
                numberRandom = 'You don\'t have number';
            } else {
                String abbreviation;
                Integer region;
                for (City_of_the_region__mdt cityRegion : regionsCity) {
                    if (userName.City == cityRegion.DeveloperName) {
                        region = Integer.valueOf(cityRegion.Region__r.Region_Number__c);
                        break;
                    }
                }
                for (LicenseName__c licenseName : customSt) {
                    if (userName.Profile.Id == licenseName.SetupOwnerId) {
                        abbreviation = licenseName.Abbreviation__c;
                        break;
                    }
                }

                if (abbreviation == null) {
                    List<Integer> integers = new List<Integer>();
                    While (integers.size() < 2) {
                        Integer numb = Integer.valueOf(Math.random() * 100);
                        if (64 < numb && numb < 91) {
                            integers.add(numb);
                        }
                    }
                    abbreviation = String.fromCharArray(integers);
                }

                numberRandom = numbers + '-' + abbreviation + '-' + region;
                //putNumberUser();
            }
            return numberRandom;
        }
        set;
    }*/
/************/
/*  public String messageError {
        get {
            return messageError;
        }
        set;
    }
*/
    public String generatorNumbers {
        get {
            String generatorNumbers;
            if (userName.Random_Number__c == null && userName.City == null) {
                generatorNumbers = 'You don\'t have City';
            } else if (userName.Random_Number__c == null && userName.City != null) {
                generatorNumbers = 'You don\'t have number';
            } else {
                generatorNumbers = numbers + '-' + abbreviation + '-' + region;
                for(User user : allUsers){
                    if(user.Random_Number__c == generatorNumbers){
                        //getRandomNumbers();
                        break;
                    }
                }
            }
            return generatorNumbers;
        }
        set;
    }

    public Integer region {//region
        get {
            Integer region;
            for (City_of_the_region__mdt cityRegion : regionsCity) {
                if (userName.City == cityRegion.DeveloperName) {
                    region = Integer.valueOf(cityRegion.Region__r.Region_Number__c);
                    break;
                }
            }
            return region;
        }
        set;
    }

    public String abbreviation {//abbreviation
        get {
            String abbreviation;
            for (LicenseName__c licenseName : customSt) {
                if (userName.Profile.Id == licenseName.SetupOwnerId) {
                    abbreviation = licenseName.Abbreviation__c;
                    break;
                }
            }

            if (abbreviation == null) {
                List<Integer> integers = new List<Integer>();
                While (integers.size() < 2) {
                    Integer numb = Integer.valueOf(Math.random() * 100);
                    if (64 < numb && numb < 91) {
                        integers.add(numb);
                    }
                }
                abbreviation = String.fromCharArray(integers);
            }
            return abbreviation;
        }
        set;
    }

    public String numbers { get; set; }
/************/
    public CreateNumberForUser_Controller_lvl_3() {
        checkEmptyUsers = false;
        numbers = '';
        allUsers = [
                SELECT Id, Name, Profile.UserLicense.Name, City, Random_Number__c, Profile.Name, Profile.UserType
                FROM User
                WHERE City NOT IN : NULL
        ];
        regionsCity = [
                SELECT Label, DeveloperName, Region__r.DeveloperName, Region__r.Region_Number__c, Region__r.Label
                FROM City_of_the_region__mdt
        ];
        customSt = [
                SELECT Abbreviation__c, SetupOwnerId
                FROM LicenseName__c
        ];

        for(User user : allUsers) {
            if(user.Random_Number__c != null) {
                numberHistory.add(user.Random_Number__c);
            }
        }
    }








    public void putNumberUser() {
        userName.Random_Number__c = generatorNumbers;
    }

    public void getRandomNumbers() {
        numbers = String.valueOf(Math.random()).substring(2, 6);

        userName.Random_Number__c = generatorNumbers;
        generatorNumbers ='';
        userName.Random_Number__c = generatorNumbers;
    }

    public void getFirstEmptyUser() {
        checkEmptyUsers = true;
    }

    public void saveNumber() {
        //update userName;
    }
}