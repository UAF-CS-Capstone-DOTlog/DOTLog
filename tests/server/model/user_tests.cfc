component userTest extends = "mxunit.framework.TestCase" {
	username = "tester";
    firstName = "Bob";
    lastName = "Dylan";
    airportCode = "AUK";
    permissions = "1";
    enabled = "1";
    emailAddr = "test";

	public void function setUp()
	{
		testUser = new dotlog.model.beans.user(username,
                                              firstName,
                                              lastName,
                                              airportCode,
                                              permissions,
                                              enabled,
                                              emailAddr);
	}

	public void function getUsername()
	{
		expected = username;
		actual = testUser.getUsername();
		assertEquals(expected, actual);
	}

    public void function getFullName() 
    {
    	expected = firstName & " " & lastName;
    	actual = testUser.getFullName();
    	assertEquals(expected, actual);
    }

    public void function getAirportCode()
    {
		expected = airportCode;
		actual = testUser.getAirportCode();
		assertEquals(expected, actual);
    }

    public void function getInitials()
    {
    	expected = Left(firstName, 1) & "." & Left(lastName, 1) & ".";
    	actual = testUser.getInitials();
    	assertEquals(expected, actual);
    }

    public void function getPermissions()
    {
            expected = permissions;
            actual = testUser.getPermissions();
            assertEquals(expected, actual);
    }

    public void function getEmailAddress()
    {
        expected = emailAddr;
        actual = testUser.getEmailAddr();
        assertEquals(expected, actual);
    }

    public void function isEnabled()
    {
        assert(testUser.isEnabled());
    }
}