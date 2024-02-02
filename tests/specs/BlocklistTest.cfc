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
			it( "if no custom blocklist param, use the default blocklist", function() {
                var sqidsOptions = new Sqids.SqidsOptions();
                var sqidsEncoder = new Sqids.SqidsEncoder(sqidsOptions);

                expect(sqidsEncoder.decode('aho1e')).toBe([4572721]);
	            expect(sqidsEncoder.encode([4572721])).toBe('JExTR');
			} );

			it( "if an empty blocklist param passed, don't use any blocklist", function() {
                var sqidsOptions = new Sqids.SqidsOptions();
                var sqidsEncoder = new Sqids.SqidsEncoder(sqidsOptions);

                expect(sqidsEncoder.decode('aho1e')).toBe([4572721]);
	            expect(sqidsEncoder.encode([4572721])).toBe('aho1e');
			} );

            it( "if a non-empty blocklist param passed, use only that", function() {
                var sqidsOptions = new Sqids.SqidsOptions(blocklist=["ArUO"]); // originally encoded [100000]
                var sqidsEncoder = new Sqids.SqidsEncoder(sqidsOptions);

                // make sure we don't use the default blocklist
                expect(sqidsEncoder.decode('aho1e')).toBe([4572721]);
                expect(sqidsEncoder.encode([4572721])).toBe('aho1e');

                // make sure we are using the passed blocklist
                expect(sqidsEncoder.decode('ArUO')).toBe([100000]);
                expect(sqidsEncoder.encode([100000])).toBe('QyG4');
                expect(sqidsEncoder.decode('QyG4')).toBe([100000]);
			} );

            it( "blocklist", function() {
                var sqidsOptions = new Sqids.SqidsOptions(blocklist = [
                    "JSwXFaosAN", // normal result of 1st encoding, let's block that word on purpose
                    "OCjV9JK64o", // result of 2nd encoding
                    "rBHf", // result of 3rd encoding is `4rBHfOiqd3`, let's block a substring
                    "79SM", // result of 4th encoding is `dyhgw479SM`, let's block the postfix
                    "7tE6" // result of 4th encoding is `7tE6jdAHLe`, let's block the prefix
                ]);
                var sqidsEncoder = new Sqids.SqidsEncoder(sqidsOptions);

                expect(sqidsEncoder.encode([1000000, 2000000])).toBe('1aYeB7bRUt');
                expect(sqidsEncoder.decode('1aYeB7bRUt')).toBe([1000000, 2000000]);
			} );

            it( "decoding blocklist words should still work", function() {
                var sqidsOptions = new Sqids.SqidsOptions(blocklist=["86Rf07", "se8ojk", "ARsz1p", "Q8AI49", "5sQRZO"]);
                var sqidsEncoder = new Sqids.SqidsEncoder(sqidsOptions);

                expect(sqidsEncoder.decode('86Rf07')).toBe([1, 2, 3]);
                expect(sqidsEncoder.decode('se8ojk')).toBe([1, 2, 3]);
                expect(sqidsEncoder.decode('ARsz1p')).toBe([1, 2, 3]);
                expect(sqidsEncoder.decode('Q8AI49')).toBe([1, 2, 3]);
                expect(sqidsEncoder.decode('5sQRZO')).toBe([1, 2, 3]);
			} );

            it( "match against a short blocklist word", function() {
                var sqidsOptions = new Sqids.SqidsOptions(blocklist=["pnd"]);
                var sqidsEncoder = new Sqids.SqidsEncoder(sqidsOptions);

                expect(sqidsEncoder.decode(sqidsEncoder.encode([1000]))).toBe([1000]);
			} );


            it( "blocklist filtering in constructor", function() {
                var sqidsEncoder = new Sqids.SqidsEncoder(new Sqids.SqidsOptions(
                    alphabet="ABCDEFGHIJKLMNOPQRSTUVWXYZ",
                    blocklist=["sxnzkl"] // lowercase blocklist in only-uppercase alphabet
                ));

                var id = sqidsEncoder.encode([1, 2, 3]);
                var numbers = sqidsEncoder.decode(id);

                expect(id).toBe('IBSHOZ'); // without blocklist, would've been "SXNZKL"
                expect(numbers).toBe([1, 2, 3]);
			} );


            it( "max encoding attempt", function() {
                var sqidsOptions = new Sqids.SqidsOptions(alphabet="abc", minLength=3, blocklist=["cab", "abc", "bca"]);
                var sqidsEncoder = new Sqids.SqidsEncoder(sqidsOptions);

                writeDump(var=sqidsOptions, format="html", output="c:\temp\#gettickcount()#-sqidsOptions.html");
                expect(sqidsOptions.getAlphabet().len()).toBe(sqidsOptions.getMinLength());
                expect(sqidsOptions.getBlocklist().len()).toBe(sqidsOptions.getMinLength());

                expect(function() { var id = sqidsEncoder.encode([0]); }).toThrow();
            } );

		} );
	}
}
