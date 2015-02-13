<aura:application access="global">
    <div class="container-fluid">
        <div class="header">
          <h1 class="text-center">Calendar Component Sample Application</h1>
        </div>
        <div class="row">
            <div class="col-md-6">
            	<div class="row">
                	<div class="col-md-2"></div>
                    <div class="col-md-8">
                    <stech:calendar objectName="Contact" 
                                    startDateField="BirthDate" 
                                    titleField="Name"
                                    color="yellow"
                                    recurringYearly="true"
                                    pageTitle="Contact Birthday"
                                    fieldsToDisplayCSV="LastName,Email"/>
                    </div>    
                    <div class="col-md-2"></div>
                </div>	
            </div>
            <div class="col-md-6">
            	<div class="row">
                	<div class="col-md-2"></div>
                    <div class="col-md-8">
                    <stech:calendar objectName="Campaign" 
                                    startDateField="StartDate"
                                    endDateField="EndDate"
                                    titleField="Name"
                                    color="gray"
                                    pageTitle="Campaign Events"
                                    fieldsToDisplayCSV="Description,Status"/>
                    </div>    
                    <div class="col-md-2"></div>
                </div>	
            </div>
            
        </div>
    </div>
</aura:application>