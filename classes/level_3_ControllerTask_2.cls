global with sharing class level_3_ControllerTask_2 {

    public String massageText { get; set; }
    public String nameApi { get; set; }
    public static List<SObject> sObj { get; set; }
    public String params {get;set;}
    public Boolean firstBlock { get; set; }
    public Boolean secondBlock { get; set; }
    public Boolean thirdBlock { get; set; }

    public level_3_ControllerTask_2() {
        firstBlock = true;
        secondBlock = true;
        thirdBlock = true;
    }

    public PageReference apexReference() {
        String str = ApexPages.currentPage().getParameters().get('val');
        massageText = str;
        return null;
    }

    @RemoteAction
    global static List<SObject> getObjects(String nameApi) {
        sObj = Database.query('SELECT Id, Name, CreatedDate FROM ' + nameApi + ' ORDER BY Id LIMIT 5');
        return sObj;
    }

    public PageReference pageRef() {
        String paramPage = ApexPages.currentPage().getParameters().get('pageName');
        PageReference pageR;

        system.debug(paramPage);
        if (paramPage == 'firstPage') {
            pageR = Page.PracticeCuctomControllerTest1;
        } else if (paramPage == 'secondPage') {
            pageR = Page.CinemaPageContactAllMovies;
        } else if (paramPage == 'thirdPage') {
            pageR = Page.CinemaPageStudioAllMovies;
        } else if (paramPage == 'google') {
            pageR = new PageReference('https://www.google.com/');
        } else if (paramPage == 'yandex') {
            pageR = new PageReference('https://yandex.by/');
        } else if (paramPage == 'tut') {
            pageR = new PageReference('https://www.tut.by/');
        } else {
            pageR = Page.level_3_VisualPageTask_2;
        }
        pageR.setRedirect(true);
        return pageR;
    }

    public PageReference paramForUrl() {
        PageReference pageRef = Page.level_3_VisualPageTask_2;
        pageRef.getParameters().put('param',params);
        pageRef.setRedirect(true);
        return pageRef;
    }

    public void toggle() {
        String paramStr = ApexPages.currentPage().getParameters().get('check');

        if (paramStr == 'firstBlock') {
            firstBlock = !firstBlock;
        }
        if (paramStr == 'secondBlock') {
            secondBlock = !secondBlock;
        }
        if (paramStr == 'thirdBlock') {
            thirdBlock = !thirdBlock;
        }
    }
}