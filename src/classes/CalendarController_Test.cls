/**
* Apex Test class for CalendarController
* @author Kartik Viswanadha
*/

@isTest
private class CalendarController_Test {

	@isTest static void calendarController_ut1() {
		// Insert test contacts and test campaigns
		List<Campaign> testCampaigns = new List<Campaign>();
		testCampaigns.add(new Campaign(Name='Test Campaign 1',Description='Test Campaign 1',
					StartDate=Date.today(),EndDate=Date.today().addDays(10),Status='Planned',Type='Conference'));
		testCampaigns.add(new Campaign(Name='Test Campaign 2',Description='Test Campaign 2',
					StartDate=Date.today().addDays(-5),EndDate=Date.today().addDays(10),Status='Planned',Type='Meeting'));
		testCampaigns.add(new Campaign(Name='Test Campaign 3',Description='Test Campaign 3',
					StartDate=Date.today().addDays(1),EndDate=Date.today().addDays(10),Status='Completed',Type='Conference'));
		testCampaigns.add(new Campaign(Name='Test Campaign 4',Description='Test Campaign 4',
					StartDate=Date.today().addDays(-10),EndDate=Date.today().addDays(10),Status='Planned',Type='Conference'));
		testCampaigns.add(new Campaign(Name='Test Campaign 5',Description='Test Campaign 5',
					StartDate=Date.today().addDays(-20),EndDate=Date.today(),Status='Completed',Type='Conference'));

		insert testCampaigns;

		List<Contact> contacts = new List<Contact>();
		contacts.add(new Contact(FirstName='Test1',LastName='Last1',BirthDate=Date.today().addMonths(-4),Email='test@t1.com'));
		contacts.add(new Contact(FirstName='Test2',LastName='Last2',BirthDate=Date.today().addMonths(-2),Email='test@t2.com'));
		contacts.add(new Contact(FirstName='Test3',LastName='Last3',BirthDate=Date.today().addMonths(-3),Email='test@t3.com'));
		contacts.add(new Contact(FirstName='Test4',LastName='Last4',BirthDate=Date.today().addMonths(-7),Email='test@t4.com'));
		contacts.add(new Contact(FirstName='Test5',LastName='Last5',BirthDate=Date.today().addMonths(-11),Email='test@t5.com'));

		insert contacts;

		testCampaigns = [Select Id, Name, Description, StartDate, EndDate, Status, Type from Campaign];
		System.assertEquals(5,testCampaigns.size());

		contacts = [Select Id, Name, FirstName, LastName, Email, BirthDate from Contact];
		System.assertEquals(5,contacts.size());

		// Begin the tests
		Test.startTest();

			// Build the CalendarInput
			CalendarController.CalendarInput cInput = new CalendarController.CalendarInput();
			cInput.objectName = 'Campaign';
			cInput.titleField = 'Name';
			cInput.startDateField = 'StartDate';
			cInput.endDateField = 'EndDate';
			cInput.recurringYearly = false;
			cInput.fieldsToDisplayCSV = 'Description,Status';
			cInput.color = 'gray';

			// Call the static method using JSON String
			List<CalendarController.CalendarEvent> events = CalendarController.getCalendarEvents(JSON.serialize(cInput),null);
			System.assertEquals(5,events.size());

			// Use case - 2
			cInput = new CalendarController.CalendarInput();
			cInput.objectName = 'Contact';
			cInput.titleField = 'Name';
			cInput.startDateField = 'BirthDate';
			cInput.recurringYearly = true;
			cInput.fieldsToDisplayCSV = 'LastName,Phone';
			cInput.color = 'green';
			String filter = ' CreatedDate = TODAY';
			events = CalendarController.getCalendarEvents(JSON.serialize(cInput),filter);
			System.assertEquals(5,events.size());

			String randomColor = CalendarController.getRandomColor();
			System.assertNotEquals(null,randomColor);

		Test.stopTest();

	}

}