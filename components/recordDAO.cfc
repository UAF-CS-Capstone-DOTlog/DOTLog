component RecordDAO extends="CoreUtils"
{
	variables.instance = {
		datasource = '',
		queryHandler = ''
	};

	public RecordDAO function init(required datasource datasource)
	{
		variables.instance.datasource = arguments.datasource;
		variables.instance.queryHandler = new queryHandler();
		return this;
	} 

	public boolean function saveRecord(required record record)
	{
		if ( record.getRecordID() ) {
			if ( recordExists(record) ) {
				return updateRecord(record);	
			}
			return createRecord(arguments.Record);
		} else { 
			return false;	
		} 
	}

	public record function getRecordByID(numeric recordID)
	{
		var queryHandler = new query();

		sqlString = "SELECT record_id, record_text, username, faa_code, event_time, record_time, in_weekly_report, category_title "
				& "FROM DL_RECORDS "
				& "WHERE record_id = :record_id";

		queryHandler.setName("fetchRecordByID");
		queryHandler.setDataSource(variables.instance.datasource.getDSName());
		queryHandler.setUsername(variables.instance.datasource.getUsername());
		queryHandler.setPassword(variables.instance.datasource.getPassword());
		queryHandler.addParam(name = "record_id", value = arguments.recordID, cfsqltype = "cf_sql_number");

		queryResult = variables.instance.queryHandler.executeQuery(queryHandler, sqlString);
		result = queryResult.getResult();
		fetchedRecord = new Record(recordText = result["record_text"][1],
									username = result["username"][1],
									faaCode = result["faa_code"][1],
									eventTime = result["event_time"][1],
									recordTime = result["record_time"][1],
									inWeeklyReport = result["in_weekly_report"][1],
									categoryTitle = result["category_title"][1],
									recordID = result["record_id"][1]);
		return fetchedRecord;

	}

	public numeric function getRecordID(record record)
	{
		var queryHandler = getQueryHandler("updateRecord", arguments.record);

		// Need to make sure that this is uniquely IDing
		sqlString = "SELECT record_id "
				& "FROM DL_RECORDS "
				& "WHERE username = :username "
				& "AND record_text = :record_text "
				& "AND record_time = :record_time";

		queryResult = variables.instance.queryHandler.executeQuery(queryHandler, sqlString);
		
		result = queryResult.getResult();

		if (result.recordCount) {
			return result["record_id"][1];
		} else {
			return -1;
		}
	}

	private boolean function createRecord(required record record)
	{
		var queryHandler = getQueryHandler("createRecord", arguments.record);

		sqlString = "INSERT INTO DL_RECORDS "
					& "(record_text, username, faa_code, event_time, record_time, in_weekly_report, category_title) "
					& "VALUES (:record_text, :username, :faa_code, :event_time, :record_time, :in_weekly_report, :category_title)";
		queryResult = variables.instance.queryHandler.executeQuery(queryHandler, sqlString);
		return len(queryResult.getPrefix().rowID); //returns a number - need to fix?
	}

	private boolean function updateRecord(required record record)
	{
		var queryHandler = getQueryHandler("updateRecord", arguments.record);
		sqlString = "UPDATE DL_RECORDS SET "
					& "record_text = :record_text, faa_code = :faa_code, event_time = :event_time, in_weekly_report = :in_weekly_report, category_title = :category_title "
					& "WHERE record_id = :record_id";
		queryResult = variables.instance.queryHandler.executeQuery(queryHandler, sqlString);
		return len(queryResult.getPrefix().recordCount);
	}	

	private boolean function recordExists(required record record)
	{		
		var queryHandler = getQueryHandler("doesRecordExist", arguments.record);
		sqlString = "SELECT record_id "
					& "FROM DL_RECORDS "
					& "WHERE record_id = :record_id";
		queryResult = variables.instance.queryHandler.executeQuery(queryHandler, sqlString);		
		return queryResult.getResult().recordCount;
	}

	private base function getQueryHandler(required string queryName, required record record)
	{
		var queryService = new query();

		queryService.setName(arguments.queryName);
		queryService.setDataSource(variables.instance.datasource.getDSName());
		queryService.setUsername(variables.instance.datasource.getUsername());
		queryService.setPassword(variables.instance.datasource.getPassword());

		if ( record.getRecordID() ) {
			queryService.addParam(name = "record_id", value = arguments.record.getRecordID(), cfsqltype = "cf_sql_number");
		}
		queryService.addParam(name = "record_text", value = arguments.record.getRecordText(), cfsqltype = "cf_sql_varchar");
		queryService.addParam(name = "username", value = arguments.record.getUsername(), cfsqltype = "cf_sql_varchar");
		queryService.addParam(name = "faa_code", value = arguments.record.getAirportFAACode(), cfsqltype = "cf_sql_varchar");
		queryService.addParam(name = "event_time", value = arguments.record.getEventTime(), cfsqltype = "cf_sql_timestamp");
		queryService.addParam(name = "record_time", value = arguments.record.getRecordTime(), cfsqltype = "cf_sql_timestamp");
		queryService.addParam(name = "in_weekly_report", value = arguments.record.isInWeeklyReport(), cfsqltype = "cf_sql_number");
		queryService.addParam(name = "category_title", value = arguments.record.getCategory(), cfsqltype = "cf_sql_varchar");

		return queryService;
	}
}