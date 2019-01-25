public with sharing class Level_3_LastFinallyTaskController {
/** select for Objects**/
    public Map <String, Schema.SObjectType> schemaMap;// = Schema.getGlobalDescribe();

    public List<SObject> sObjects { get; set; }// = new List<SObject>();

    public List<SObject> sObjectsPagination { get; set; }

    public String selectedObject { get; set; }

    public List<String> selectedField { get; set; }
/** SOQL**/
    public String createDynamicObjectFieldParts {
        get {
            String dynamicQuery = '';
            for (Integer i = 0; i < selectedField.size(); i++) {
                if (i == (selectedField.size() - 1)) {
                    dynamicQuery += ' ' + selectedField[i] + ' FROM ' + selectedObject + ' ';
                } else {
                    dynamicQuery += ' ' + selectedField[i] + ',';
                }
            }
            return dynamicQuery;
        }
        set;
    }

    public Boolean addView { get; set; }

    public List<String> createDynamicWhereList { get; set; }

    public List<String> createDynamicWhere {
        get {
            List<String> createDynamic = new List<String>();
            String item;
            for (Integer i = 0; i < createDynamicWhereList.size(); i++) {
                String str;
                if (item == null && createDynamicWhereList[i] == 'OR ') {
                    item = createDynamicWhereList[i];
                    createDynamic[i - 1] = '( ' + createDynamicWhereList[i - 1];
                    str = createDynamicWhereList[i];
                } else if (createDynamicWhereList[i] == 'AND ' && item == 'OR ') {
                    createDynamic[i - 1] = createDynamicWhereList[i - 1] + ') ';
                    str = createDynamicWhereList[i];
                    item = null;
                } else if ((createDynamicWhereList.size() - 1) == i && item == 'OR ' && createDynamicWhereList[i] != 'OR ') {
                    str = createDynamicWhereList[i] + ') ';
                } else {
                    str = createDynamicWhereList[i];
                }
                createDynamic.add(str);
            }
            return createDynamic;

        }
        set;
    }

    public String createDynamicWherePart {
        get {
            String dynamicQuery = '';
            for (String str : createDynamicWhere) {
                if (dynamicQuery == '') {
                    dynamicQuery += 'WHERE ';
                }
                dynamicQuery += str;
            }
            return dynamicQuery;
        }
        set;
    }

    public String createDynamicSortPart {
        get {
            String dynamicQuery = '';
            if (selectSortFields != 'None') {
                dynamicQuery += 'ORDER BY ' + selectSortFields + ' ' + selectSort + ' ' + selectSortNull + ' ';
            } else {
                selectSort = 'ASC';
                selectSortNull = 'NULLS FIRST';
            }
            return dynamicQuery;
        }
        set;
    }

    public String createDynamicLimitPart {
        get {
            String dynamicQuery = '';
            if (selectLimit != '') {
                dynamicQuery += 'LIMIT ' + selectLimit;
            }
            return dynamicQuery;
        }
        set;
    }

    public String createDynamicOffsetPart {
        get {
            String dynamicQuery = '';
            if (selectOffset != '') {
                dynamicQuery += ' OFFSET ' + selectOffset;
            }
            return dynamicQuery;
        }
        set;
    }

    public String DynamicSQL {
        get {
            String queryStr = '';
            if (!selectedField.isEmpty()) {
                queryStr = 'SELECT' + createDynamicObjectFieldParts + createDynamicWherePart + createDynamicSortPart + createDynamicLimitPart + createDynamicOffsetPart;
            }
            return queryStr;
        }
        set;
    }
/** sort SOQL query**/
    public String parFiled { get; set; }

    public String positionArrow { get; set; }
/** **/
    public List<SelectOption> objectFields {
        get {
            List<SelectOption> fieldNames = new List<SelectOption>();
            if (selectedObject != 'None') {
                Schema.SObjectType ObjectSchema = schemaMap.get(selectedObject);
                Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();

                for (Schema.SObjectField fieldName : fieldMap.values()) {
                    if (fieldName.getDescribe().isAccessible()) {
                        fieldNames.add(new SelectOption(String.valueOf(fieldName), String.valueOf(fieldName)));
                    }
                }
            }
            return fieldNames;
        }
        set;
    }

    public List<SelectOption> objectFieldForSqlBuild {
        get {
            List<SelectOption> fieldNames = new List<SelectOption>();
            if (selectedObject != 'None') {
                fieldNames.add(new SelectOption('None', '-None-'));
                Schema.SObjectType ObjectSchema = schemaMap.get(selectedObject);
                Map<String, Schema.SObjectField> fieldMap = ObjectSchema.getDescribe().fields.getMap();

                for (Schema.SObjectField fieldName : fieldMap.values()) {
                    if (fieldName.getDescribe().isAccessible()) {
                        fieldNames.add(new SelectOption(String.valueOf(fieldName), String.valueOf(fieldName)));
                    }
                }
            }
            return fieldNames;
        }
        set;
    }

    public List<SelectOption> querySortNull {
        get {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('NULLS FIRST', 'Nulls First'));
            options.add(new SelectOption('NULLS LAST', 'Nulls Last'));

            return options;
        }
        set;
    }

    public List<SelectOption> querySort {
        get {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('ASC', 'A to Z'));
            options.add(new SelectOption('DESC', 'Z to A'));

            return options;
        }
        set;
    }

    public List<SelectOption> listExpressions {
        get {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('=', '='));
            options.add(new SelectOption('!=', '≠'));
            options.add(new SelectOption('<', '<'));
            options.add(new SelectOption('<=', '≤'));
            options.add(new SelectOption('>', '>'));
            options.add(new SelectOption('>=', '≥'));
            options.add(new SelectOption('LIKE_S', 'starts with'));
            options.add(new SelectOption('LIKE_E', 'end with'));
            options.add(new SelectOption('LIKE', 'contains'));
            options.add(new SelectOption('IN', 'in'));
            options.add(new SelectOption('NOT IN', 'not in'));
            options.add(new SelectOption('INCLUDES', 'includes'));
            options.add(new SelectOption('EXCLUDES', 'excludes'));

            return options;
        }
        set;
    }

    public List<SelectOption> objectNames {
        get {
            List<SelectOption> objNames = new List<SelectOption>();
            List<String> entities = new List<String>();
            objNames.add(new SelectOption('None', '-None-'));

            for (Schema.SObjectType obj : Schema.getGlobalDescribe().Values()) {
                if (obj.getDescribe().isAccessible() == true &&
                        obj.getDescribe().isCreateable() == true &&
                        (obj.getDescribe().isDeletable() == true || obj.getDescribe().isDeletable() == false) &&
                        (obj.getDescribe().isCustomSetting() == false || obj.getDescribe().isCustomSetting() == true) &&
                        obj.getDescribe().isDeprecatedAndHidden() == false &&
                        (obj.getDescribe().isFeedEnabled() == true || obj.getDescribe().isFeedEnabled() == false) &&
                        (obj.getDescribe().isMergeable() == true || obj.getDescribe().isMergeable() == false) &&
                        (obj.getDescribe().isMruEnabled() == true || obj.getDescribe().isMruEnabled() == false) &&
                        obj.getDescribe().isQueryable() == true &&
                        obj.getDescribe().isSearchable() == true &&
                        (obj.getDescribe().isUndeletable() == true || obj.getDescribe().isUndeletable() == false) &&
                        obj.getDescribe().isUpdateable() == true) {
                    entities.add(obj.getDescribe().getName());
                }
            }
            entities.sort();

            for (String name : entities) {
                objNames.add(new SelectOption(name, name));
            }
            return objNames;
        }
        set;
    }//имена объектов
/** select for visibility blocks**/
    public Boolean viewFieldsBlock {
        get {
            Boolean view;
            if (selectedObject != 'None') {
                view = true;
            } else {
                view = false;
                selectedField.clear();
            }
            return view;
        }
        set;
    }//блок филдов

    public Boolean viewConditionBlock {
        get {
            Boolean view;
            if (!selectedField.isEmpty()) {
                view = true;
            } else {
                view = false;
            }
            return view;
        }
        set;
    }//блок условия

    public Boolean viewSortBlock {
        get {
            Boolean view;
            if (selectConditionFields == 'None' || selectedField.isEmpty()) {
                selectSortFields = 'None';
                selectSort = 'ASC';
                selectSortNull = 'NULLS FIRST';
                selectLimit = '';
                selectOffset = '';
                view = false;
            } else {
                view = true;
            }
            return view;
        }
        set;
    }//блок сортировки и лимита

    public Boolean viewTextArea {
        get {
            Boolean view;
            if (selectedObject == 'None' || selectedField.isEmpty()) {
                view = false;
            } else if (!selectedField.isEmpty()) {
                view = true;
            }
            return view;
        }
        set;
    }//блок поле текста

    public Boolean viewTableBlock { get; set; }
/** select for disable fields**/
    public Boolean disableSoqlBlock {
        get {
            Boolean disable;
            if (selectSortFields == 'None') {
                disable = true;
                selectSort = 'ASC';
                selectSortNull = 'NULLS FIRST';

            } else {
                disable = false;
            }
            return disable;
        }
        set;
    }

    public Boolean disableConditionBlock {
        get {
            Boolean disable;
            if (selectConditionFields == 'None' || selectedField.isEmpty()) {
                disable = true;

            } else {
                disable = false;
            }
            return disable;
        }
        set;
    }

    public Boolean disableSoqlButton {
        get {
            Boolean disable;
            if (selectedField.isEmpty()) {
                disable = true;
            } else {
                disable = false;
            }
            return disable;
        }
        set;
    }
/** select Condition for SOQL builder**/
    public String selectConditionFields { get; set; }

    public String selectFieldsExpressions { get; set; }

    public String selectFilterResult { get; set; }

    public String logicValue { get; set; }

    public List<SelectOption> selectOrAnd {
        get {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('None', '-None-'));
            options.add(new SelectOption('AND', 'AND'));
            options.add(new SelectOption('OR', 'OR'));
            return options;
        }
        set;
    }

/** select for SOQL builder**/
    public String selectSortFields { get; set; }

    public String selectSort { get; set; }

    public String selectSortNull { get; set; }

    public String selectLimit { get; set; }

    public String selectOffset { get; set; }
/** View DateDynamic SOQL in Textarea**/
    public String querySoql;// { get; set; }
/** Table components: pagination **/
    public Integer selectPaginationValue { get; set; }

    public Integer pageNumber { get; set; }
/** disabled pagination button**/
    public Boolean viewFirstSect { get; set; }

    public Boolean startPageBtm {
        get {
            Boolean disabled;
            if (pageNumber <= 1) {
                disabled = true;
            } else {
                disabled = false;
            }
            return disabled;
        }
        set;
    }
    public Boolean prevBtm { get; set; }

    public Boolean nextBtm { get; set; }

    public Boolean endPageBtm {
        get {
            Boolean disabled;
            if (pageNumber >= (Decimal.valueOf(sObjects.size()) / Decimal.valueOf(selectPaginationValue)).round(System.RoundingMode.CEILING)) {
                disabled = true;
            } else {
                disabled = false;
            }
            return disabled;
        }
        set;
    }

    public List<SelectOption> paginationValueList {
        get {
            List<SelectOption> options = new List<SelectOption>();
            options.add(new SelectOption('5', '5'));
            options.add(new SelectOption('10', '10'));
            options.add(new SelectOption('15', '15'));
            options.add(new SelectOption('20', '20'));
            return options;
        }
        set;
    }

    Public level_3_LastFinallyTaskController() {
        schemaMap = Schema.getGlobalDescribe();
        selectedObject = 'None';
        selectSortFields = 'None';
        selectConditionFields = 'None';
        logicValue = 'None';
        selectSort = 'ASC';
        selectSortNull = 'NULLS FIRST';
        selectLimit = '';
        selectOffset = '';
        selectFieldsExpressions = '=';
        pageNumber = 1;
        selectPaginationValue = 5;
        positionArrow = 'ASC';
        selectedField = new List<String>();
        viewTextArea = false;
        viewSortBlock = false;
        sObjectsPagination = new List<SObject>();
        viewFirstSect = true;
        createDynamicWhereList = new List<String>();
        createDynamicWhere = new List<String>();
        parFiled = '';
        sObjects = new List<SObject>();
        addView = false;
    }
/** select Condition for SOQL builder**/
    public void clearListFields() {
        createDynamicWhereList.clear();
        selectedField.clear();
        viewTableBlock = false;
        selectConditionFields = 'None';
        selectLimit = '';
        selectOffset = '';
        createDynamicWherePart = '';
        selectFieldsExpressions = '=';
        createDynamicWhereList.clear();
        addView = false;
        selectFilterResult = '';
    }

    public void clearQuerySoql() {
        viewTableBlock = false;
    }

    public void clearCondition() {
        if (selectConditionFields == 'None') {
            createDynamicWhereList.clear();
            selectFieldsExpressions = '=';
            selectFilterResult = '';
            logicValue = ' ';
        }
    }
/** create dynamic SOQL query**/
    public void button() {
        viewTableBlock = true;
        try {
            sObjects = Database.query(DynamicSQL);
            paginationView();
            viewTableBlock = true;
        } catch (Exception ex) {
            viewTableBlock = false;
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }

    public void save() {
        List<SObject> oldSObjects = Database.query('SELECT' + createDynamicObjectFieldParts + ' WHERE Id IN : sObjects');
        List<SObject> updateSObjects = new List<SObject>();
        for (SObject sObj : sObjects) {
            if (!oldSObjects.contains(sObj)) {
                updateSObjects.add(sObj);
            }
        }
        update updateSObjects;
    }

    public void cancel() {
        sortDynamicSoql();
    }

    public void getPaginationObject() {
        sObjectsPagination.clear();
        for (Integer i = (pageNumber - 1) * selectPaginationValue; i < pageNumber * selectPaginationValue; i++) {
            if (sObjects.size() > i) {
                sObjectsPagination.add(sObjects[i]);
            }
        }
    }

    public void paginationView() {
        pageNumber = 1;
        getPaginationObject();
    }
/** pagination button **/
    public void firstPage() {
        pageNumber = 1;
        getPaginationObject();
    }

    public void prevPage() {
        pageNumber--;
        getPaginationObject();
    }

    public void nextPage() {
        pageNumber++;
        getPaginationObject();
    }

    public void lastPage() {
        pageNumber = Integer.valueOf((Decimal.valueOf(sObjects.size()) / Decimal.valueOf(selectPaginationValue)).round(System.RoundingMode.CEILING));
        getPaginationObject();
    }

    public void paramHeaderName() {
        String nameField = ApexPages.currentPage().getParameters().get('field');
        for (String str : selectedField) {
            if (nameField == str) {
                parFiled = str;
                break;
            }
        }

        if (nameField == parFiled) {
            if (positionArrow == 'ASC') {
                positionArrow = 'DESC';
                sortDynamicSoql();
            } else {
                positionArrow = 'ASC';
                sortDynamicSoql();
            }
        } else {
            positionArrow = 'ASC';
            sortDynamicSoql();
        }
    }

    public void sortDynamicSoql() {
        try {
            if (parFiled == '') {
                sObjects = Database.query(DynamicSQL);
            } else {
                List<SObject> newSObjects = Database.query('SELECT' + createDynamicObjectFieldParts + ' WHERE Id IN : sObjects' + ' ORDER BY ' + parFiled + ' ' + positionArrow);
                sObjects = newSObjects;
                getPaginationObject();
            }
        } catch (Exception ex) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR, ex.getMessage()));
        }
    }
    /** View first section**/
    public void viewFirstSection() {
        viewFirstSect = !viewFirstSect;
    }

    public void addDynamicWhere() {
        String typeField = String.valueOf(Schema.getGlobalDescribe().get(selectedObject).getDescribe().fields.getMap().get(selectConditionFields).getDescribe().getType());
        String querySelected = '';
        if (typeField == 'CURRENCY' || typeField == 'DATETIME' || typeField == 'DATE' ||
                typeField == 'BOOLEAN' || typeField == 'INTEGER' || (typeField == 'PHONE' && selectFilterResult == 'Null')/* && selectConditionFields != 'None' && selectFilterResult != null*/) {
            if (selectFieldsExpressions == '=' || selectFieldsExpressions == '!=' || selectFieldsExpressions == '<' || selectFieldsExpressions == '<=' || selectFieldsExpressions == '>' || selectFieldsExpressions == '>=') {
                querySelected = selectConditionFields + ' ' + selectFieldsExpressions + ' ' + selectFilterResult + ' ';
            } else if (selectFieldsExpressions == 'LIKE_S') {
                querySelected = selectConditionFields + ' LIKE ' + selectFilterResult + '%' + ' ';
            } else if (selectFieldsExpressions == 'LIKE_E') {
                querySelected = selectConditionFields + ' LIKE ' + '%' + selectFilterResult + ' ';
            } else if (selectFieldsExpressions == 'LIKE') {
                querySelected = selectConditionFields + ' LIKE ' + '%' + selectFilterResult + '% ';
            } else {
                querySelected = selectConditionFields + ' ' + selectFieldsExpressions + ' ' + '(' + selectFilterResult + ')' + ' ';
            }
            createDynamicWhereList.add(querySelected);
        } else {
            if (selectFieldsExpressions == '=' || selectFieldsExpressions == '!=' || selectFieldsExpressions == '<' || selectFieldsExpressions == '<=' || selectFieldsExpressions == '>' || selectFieldsExpressions == '>=') {
                querySelected = selectConditionFields + ' ' + selectFieldsExpressions + ' ' + '\'' + selectFilterResult + '\' ' + ' ';
            } else if (selectFieldsExpressions == 'LIKE_S') {
                querySelected = selectConditionFields + ' ' + 'LIKE ' + '\'' + selectFilterResult + '%' + '\'' + ' ';
            } else if (selectFieldsExpressions == 'LIKE_E') {
                querySelected = selectConditionFields + ' ' + 'LIKE ' + '\'' + '%' + selectFilterResult + '\'' + ' ';
            } else if (selectFieldsExpressions == 'LIKE') {
                querySelected = selectConditionFields + ' ' + 'LIKE ' + '\'' + '%' + selectFilterResult + '%' + '\'' + ' ';
            } else {
                querySelected = selectConditionFields + ' ' + selectFieldsExpressions + ' ' + '(' + selectFilterResult + ')' + ' ';
            }
            createDynamicWhereList.add(querySelected);
            if (logicValue != 'None') {
                createDynamicWhereList.add(logicValue + ' ');
                addView = false;
                logicValue = 'None';
            } else {
                addView = true;
                logicValue = 'None';
            }
        }
    }

    public void deleteDynamicWhere() {
        if (createDynamicWhereList.size() > 0) {
            createDynamicWhereList.remove(createDynamicWhereList.size() - 1);
            addView = false;
            logicValue = 'None';
        }
    }

    public void clearDynamicWhere() {
        createDynamicWhereList.clear();
        addView = false;
        logicValue = 'None';
    }

}