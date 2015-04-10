component  
{
	this.Name =  "DOTLog";
	this.ApplicationTimeout = CreateTimeSpan( 0, 0, 0, 0 );
	this.SessionManagement = true;
	this.rootDir = getDirectoryFromPath( getCurrentTemplatePath() );
	this.mappings[ "/dotlog" ] = this.rootDir;

	function onApplicationStart()
	{
		var datasource = new dotlog.components.datasource(DSName = "DOTlogDB", username = "", password = "");
		
		Application.categoryService = new dotlog.components.categoryService(datasource);
		Application.recordService = new dotlog.components.recordService(datasource);
		Application.userService = new dotlog.components.userService(datasource);
		Application.airportService = new dotlog.components.airportService(datasource);
	}

	function onRequestStart()
	{

	}	
}
