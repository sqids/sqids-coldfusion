component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		// setup the entire test bundle here
	}

	function afterAll(){
		// do cleanup here
	}

	/*********************************** BDD SUITES ***********************************/

	function run(){
		/**
		 * describe() starts a suite group of spec tests. It is the main BDD construct.
		 * You can also use the aliases: story(), feature(), scenario(), given(), when()
		 * to create fluent chains of human-readable expressions.
		 *
		 * Arguments:
		 *
		 * @title    Required: The title of the suite, Usually how you want to name the desired behavior
		 * @body     Required: A closure that will resemble the tests to execute.
		 * @labels   The list or array of labels this suite group belongs to
		 * @asyncAll If you want to parallelize the execution of the defined specs in this suite group.
		 * @skip     A flag that tells TestBox to skip this suite group from testing if true
		 * @focused A flag that tells TestBox to only run this suite and no other
		 */
		describe( "Alphabet", function() {

			/**
			 * --------------------------------------------------------------------------
			 * Runs before each spec in THIS suite group or nested groups
			 * --------------------------------------------------------------------------
			 */
			beforeEach( function() {
			} );

			/**
			 * --------------------------------------------------------------------------
			 * Runs after each spec in THIS suite group or nested groups
			 * --------------------------------------------------------------------------
			 */
			afterEach( function() {
			} );

			/**
			 * it() describes a spec to test. Usually the title is prefixed with the suite name to create an expression.
			 * You can also use the aliases: then() to create fluent chains of human-readable expressions.
			 *
			 * Arguments:
			 *
			 * @title  The title of this spec
			 * @body   The closure that represents the test
			 * @labels The list or array of labels this spec belongs to
			 * @skip   A flag or a closure that tells TestBox to skip this spec test from testing if true. If this is a closure it must return boolean.
			 * @data   A struct of data you would like to bind into the spec so it can be later passed into the executing body function
			 * @focused A flag that tells TestBox to only run this spec and no other
			 */
			it( "simpel", function() {
                var sqidsOptions = new Sqids.SqidsOptions(alphabet="0123456789abcdef");
                var sqidsEncoder = new Sqids.SqidsEncoder(sqidsOptions);

                var numbers = [1, 2, 3];
                var id = '489158';

                expect(sqidsEncoder.encode(numbers)).toBe(id);
                expect(sqidsEncoder.decode(id)).toBe(numbers);
			} );

			it( "short alphabet", function() {
                var sqidsOptions = new Sqids.SqidsOptions(alphabet="abc");
                var sqidsEncoder = new Sqids.SqidsEncoder(sqidsOptions);

                var numbers = [1, 2, 3];

				expect(sqidsEncoder.decode(sqidsEncoder.encode(numbers))).toBe(numbers);
			} );

			it( "long alphabet", function() {
				var sqidsOptions = new Sqids.SqidsOptions(alphabet="abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789!@##$%^&*()-_+|{}[];:\'""/?.>,<`~");
                var sqidsEncoder = new Sqids.SqidsEncoder(sqidsOptions);

                var numbers = [1, 2, 3];

				expect(sqidsEncoder.decode(sqidsEncoder.encode(numbers))).toBe(numbers);
			} );

			it( "multibyte characters", function() {
				var sqidsOptions = new Sqids.SqidsOptions(alphabet="ë1092");

				expect(function() { var sqids = new Sqids.SqidsEncoder(sqidsOptions); }).toThrow();
			} );

			it( "repeating alphabet characters", function() {
				var sqidsOptions = new Sqids.SqidsOptions(alphabet="aabcdefg");

				expect(function() { var sqids = new Sqids.SqidsEncoder(sqidsOptions); }).toThrow();
			} );

			it( "too short of an alphabet", function() {
				var sqidsOptions = new Sqids.SqidsOptions(alphabet="ab");

				expect(function() { var sqids = new Sqids.SqidsEncoder(sqidsOptions); }).toThrow();
			} );

		} );
	}
}
