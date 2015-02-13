({
    initHandlers: function(component) {
        // Make sure that libraries are loaded.
        var ready = component.get("v.ready");
        if (ready === false) {
            return;
        }
		
        // This will get the element to build the calendar
        var ctx = component.getElement();
		
        // Build the calendar
        $j('#calendarComp',ctx).fullCalendar({
          events: function(start, end, timezone, callback) {
            var calendarInput = new Object();
            calendarInput.objectName = component.get("v.objectName");
            calendarInput.startDateField = component.get("v.startDateField");
            calendarInput.endDateField = component.get("v.endDateField");
            calendarInput.titleField = component.get("v.titleField");
            calendarInput.fieldsToDisplayCSV = component.get("v.fieldsToDisplayCSV");
            calendarInput.color = component.get("v.color");
            calendarInput.recurringYearly = component.get("v.recurringYearly");
			var filterClause = component.get("v.filterCondition");  
            var events = [];

            // Call the @AuraEnabled method from controller
            var action = component.get("c.getCalendarEvents");
                action.setParams({
                    "calendarInputJSON":JSON.stringify(calendarInput),
                    "filterClause":filterClause
                });
                action.setCallback(this,function(r){
                    var events = [];
                    var sfevents = r.getReturnValue();
                    // Iterate over each record, to push to events on calendar
                    sfevents.forEach(function(eve){

                        if (eve.start == eve.endDate)
                          eve.allDay = true;
                        else
                          eve.allDay = false;

                        events.push({
                          title: eve.title,
                          start: eve.start,
                          end: eve.endDate,
                          description: eve.description,
                          textColor:eve.textColor,
                          color:eve.color,
                          borderColor:eve.borderColor,
                          allDay:eve.allDay,
                          url:eve.url
                        });
                    });
                    callback(events);
                });
				// run the function, (async)
                $A.run(function() {
                    $A.enqueueAction(action);
                });
        },
        eventClick:  function(event, jsEvent, view) {
            $j('#modalTitle').html(event.title);
            $j('#modalBody').html(event.description);
            $j('#eventUrl').attr('href',event.url);
            $j('#calendarModal').modal();
        },loading: function(bool) {
            if (bool)
              $j('#loading').show();
            else
              $j('#loading').hide();
        },
        header: {
            left: 'prev,next today',
            center: 'title',
            right: 'month,agendaWeek,agendaDay'
        },
        themeButtonIcons: false,
        editable: false,
        eventLimit: false, // allow "more" link when too many events
        theme: true
      });
    }
})