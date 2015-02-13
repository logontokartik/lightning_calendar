/* Copyright 2015 Kartik Viswanadha
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

 /**
 * Controller class for Calendar Aura Component
 * @author Kartik Viswanadha
 */

global class CalendarController {

    /**
	* Method that returns the Events as Custom Type based on the inputs provided
	* @return List<CalendarEvent> records for Map to display
	*/
    @AuraEnabled
    global static List<CalendarEvent> getCalendarEvents(String calendarInputJSON, String filterClause) {

        // Load the input into the custom type
        CalendarInput cInput = (CalendarInput)JSON.deserialize(calendarInputJSON,CalendarInput.class);

        List<CalendarEvent> events = new List<CalendarEvent>();

        try {
                // Build the query
                String query = 'Select Id, ' ;

                query += cInput.startDateField + ',';

                if (!String.isBlank(cInput.endDateField))
                  query += cInput.endDateField + ',';

                if (!String.isBlank(cInput.titleField))
                  query += cInput.titleField + ',';

                if (!String.isBlank(cInput.fieldsToDisplayCSV)) {
                    cInput.fieldsToDisplayCSV = cInput.fieldsToDisplayCSV.replace(cInput.startDateField,'');

                    if (!String.isBlank(cInput.endDateField))
                      cInput.fieldsToDisplayCSV = cInput.fieldsToDisplayCSV.replace(cInput.endDateField,'');

                    query += cInput.fieldsToDisplayCSV;
                }

                query = query.removeEnd(',');

                String whrClause = '';

                query = query + ' from ' + cInput.objectName;

                if (!String.isBlank(filterClause))
                      query += ' where ' + filterClause;

                String color = cInput.color;

                // Query for the records
                List<SObject> records = Database.query(query);

                // Iterate over each record to build calendarEvent
                for (SObject obj : records) {

                    Boolean isValidEvent = true;

                    CalendarEvent cEvent = new CalendarEvent();

                    if (!String.isBlank(cInput.startDateField) && obj.get(cInput.startDateField) != null) {
                      if (cInput.recurringYearly != null && cInput.recurringYearly) {
                        Date startDate = Date.valueof(obj.get(cInput.startDateField));
                        cEvent.start = String.valueof(startDate).replace(String.valueof(startDate.year()),String.valueof(Date.today().year())).replace(' ','T');
                      } else
                        cEvent.start = String.valueof(obj.get(cInput.startDateField)).replace(' ','T');
                    } else {
                        isValidEvent = false;
                    }

                    if (!String.isBlank(cInput.titleField)) {
                        cEvent.title = String.valueof(obj.get(cInput.titleField));
                    }

                    if (!String.isBlank(cInput.endDateField) && obj.get(cInput.endDateField) != null) {

                      if (cInput.recurringYearly != null && cInput.recurringYearly) {
                        Date endDate = Date.valueof(obj.get(cInput.endDateField));
                        cEvent.endDate = String.valueof(endDate).replace(String.valueof(endDate.year()),String.valueof(Date.today().year())).replace(' ','T');
                      } else
                        cEvent.endDate = String.valueof(obj.get(cInput.endDateField)).replace(' ','T');

                    } else if (obj.get(cInput.startDateField) != null) {
                        cEvent.endDate = cEvent.start;
                    }

                    if (cInput.fieldsToDisplayCSV != null) {
                        cEvent.description = '';
                        for (String s : cInput.fieldsToDisplayCSV.split(',')) {
                            cEvent.description += String.valueof(obj.get(s.trim())) + ' ';
                        }
                    }

                    cEvent.color = color;
                    cEvent.textColor = '#000000'; //TODO. Does this need to be configurable?

                    if (isValidEvent) {
                        events.add(cEvent);
                    }
                }

        } catch (QueryException e) {
            throw new CalendarException ('Error when retrieving events ' + e.getMessage());
        } catch (Exception e) {
            throw new CalendarException ('Error when retrieving events ' + e.getMessage() + e.getStackTraceString());
        }

        return events;
    }

  /**
	* Method that generates a random color
	* @return String value for a random color
	*/
 	global static String getRandomColor() {
      List<String> letters = '0123456789ABCDEF'.split('');
      String color = '#';
      for (Integer i = 0; i < 6; i++ ) {
          color += letters[Integer.valueof(Math.floor(Math.random() * 16))];
      }
      return color;
    }


   //Class to hold calendar event data --> Very specific to the Calendar Component
    global class CalendarEvent {

        @AuraEnabled
        global String title {get;set;}
        @AuraEnabled
        global Boolean allDay {get;set;}
        @AuraEnabled
        global String start {get;set;}
        @AuraEnabled
        global String endDate {get;set;}
        @AuraEnabled
        global String url {get;set;}
        @AuraEnabled
        global String borderColor {get;set;}
        @AuraEnabled
        global String color {get;set;}
        @AuraEnabled
        global String textColor {get;set;}
        @AuraEnabled
        public String description {get;set;}
    }

    // Input class type for Calendar Input, specific to calendar.cmp
    global class CalendarInput {

      @AuraEnabled
      public String objectName {get;set;}
      @AuraEnabled
      public String titleField {get;set;}
      @AuraEnabled
      public String startDateField {get;set;}
      @AuraEnabled
      public String endDateField {get;set;}
      @AuraEnabled
      public String color {get;set;}
      @AuraEnabled
      public String fieldsToDisplayCSV {get;set;}
      @AuraEnabled
      public boolean recurringYearly {get;set;}

    }

    global class CalendarException extends Exception {}

}