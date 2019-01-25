public with sharing class RandomAutoNumberForUser_lvl_3 {
    public List<User> allUsers { get; set; }

    private List<City_of_the_region__mdt> regionsCity;

    private List<LicenseName__c> customSt;

    private List<String> numberHistory;

    private User userName;

    public User currentUser {
        get {
            System.debug('hi');
            for (User user : allUsers) {
                if (user.id == UserInfo.getUserId()) {
                    currentUser = user;
                    break;
                }
            }
            return currentUser;
        }
        set;
    }

    public Boolean disabledView { get; set; }

    public Boolean disabledRandom { get; set; }

    public Boolean massageError { get; set; }

    public String generatorNumbers {
        get {
            if (massageError) {
                generatorNumbers = 'Please enter Get Number';
            } else if (currentUser.Random_Number__c == null && currentUser.City == null) {

                generatorNumbers = 'You don\'t have City';
                getDisabledView();
            } else if (currentUser.Random_Number__c == null && currentUser.City != null) {
                generatorNumbers = 'You don\'t have number';
                getDisabledView();
            } else {
                generatorNumbers = currentUser.Random_Number__c;
            }
            return generatorNumbers;
        }
        set;
    }

    private Integer region {
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

    private String abbreviation {
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

    private String numbers {
        get {
            return String.valueOf(Math.random()).substring(2, 6);
        }
        set;
    }

    private User mainUserInformation;

    public RandomAutoNumberForUser_lvl_3() {
        numberHistory = new List<String>();
        userName = new User();
        allUsers = [
                SELECT Id, Name, Profile.UserLicense.Name, City, Random_Number__c, Profile.Name, Profile.UserType
                FROM User
                WHERE City NOT IN :NULL
        ];
        regionsCity = [
                SELECT Label, DeveloperName, Region__r.DeveloperName, Region__r.Region_Number__c, Region__r.Label
                FROM City_of_the_region__mdt
        ];
        customSt = [
                SELECT Abbreviation__c, SetupOwnerId
                FROM LicenseName__c
        ];
        getDisabledView();
        massageError = false;
        disabledView = false;
    }

    private Boolean getDisabledView() {
        User nawUser = [SELECT Random_Number__c FROM User WHERE Id = :UserInfo.getUserId()];
        if (nawUser.Random_Number__c == null) {
            disabledRandom = false;
            return false;
        } else {
            disabledRandom = true;
            return true;
        }
    }

    private void allNumber() {
        numberHistory.clear();
        for (User user : allUsers) {
            if (user.Random_Number__c != null) {
                numberHistory.add(user.Random_Number__c);
            }
        }
    }

    private void randomAutoNumber(List<User> users) {
        for (User user : users) {
            allNumber();
            userName = user;
            String autoNumber = numbers + '-' + abbreviation + '-' + region;
            While (numberHistory.contains(autoNumber)) {
                autoNumber = numbers + '-' + abbreviation + '-' + region;
            }
            user.Random_Number__c = autoNumber;
        }
    }

    public void randomNumberButton() {
        List<User> users = new List<User>();
        User nawUser = [SELECT Random_Number__c FROM User WHERE Id = :UserInfo.getUserId()];
        //if (null == mainUserInformation.Random_Number__c) {
        if (!getDisabledView()) {
            users.add(currentUser);
            randomAutoNumber(users);
            massageError = false;
        }
    }

    public void randomNumbersForUsers() {
        List<User> users = new List<User>();
        for (User user : allUsers) {
            if (user.Id != currentUser.Id && user.Random_Number__c == Null) {
                for (City_of_the_region__mdt cityRegion : regionsCity) {
                    if (user.City == cityRegion.DeveloperName) {
                        users.add(user);
                        break;
                    }
                }
            }
        }
        randomAutoNumber(users);
        saveListUsers(users);
        disabledView = true;
    }

    public void saveNumberButton() {
        if (userName.id != null) {
            massageError = false;
            update userName;
            getDisabledView();
        } else {
            massageError = true;
        }
    }

    private void saveListUsers(List<User> users) {
        update users;
    }
}