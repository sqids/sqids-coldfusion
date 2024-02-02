component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		// setup the entire test bundle here
		var sqidsOptions = new Sqids.SqidsOptions();
		variables.SqidsEncoder = new Sqids.SqidsEncoder(sqidsOptions);
		variables.MaxNumber = createObject("java", "java.lang.Integer").MAX_VALUE;
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
		describe( "Encoding", function() {

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
			it( "just one", function() {
				var numbers = [1];
				var id = 'Uk';

					expect(variables.SqidsEncoder.encode(numbers)).toBe(id);
					expect(variables.SqidsEncoder.decode(id)).toBe(numbers);
			} );

			it( "simple", function() {
				var numbers = [1, 2, 3];
				var id = '86Rf07';

				expect(variables.SqidsEncoder.encode(numbers)).toBe(id);
				expect(variables.SqidsEncoder.decode(id)).toBe(numbers);
			} );

			it( "different inputs", function() {
				var numbers = [0, 0, 0, 1, 2, 3, 100, 1000, 100000, 1000000, variables.MaxNumber];

				expect(variables.SqidsEncoder.decode(variables.SqidsEncoder.encode(numbers))).toBe(numbers);
			} );

			it( "incremental numbers", function() {
				var ids = [
					"bM": [0],
					"Uk": [1],
					"gb": [2],
					"Ef": [3],
					"Vq": [4],
					"uw": [5],
					"OI": [6],
					"AX": [7],
					"p6": [8],
					"nJ": [9]
				];

				ids.each(function(required string id, required array numbers) {
					expect(variables.SqidsEncoder.encode(arguments.numbers)).toBe(arguments.id);
					expect(variables.SqidsEncoder.decode(arguments.id)).toBe(arguments.numbers);
				} );
			} );

			it( "incremental numbers, same index 0", function() {
				var ids = [
					"SvIz": [0, 0],
					"n3qa": [0, 1],
					"tryF": [0, 2],
					"eg6q": [0, 3],
					"rSCF": [0, 4],
					"sR8x": [0, 5],
					"uY2M": [0, 6],
					"74dI": [0, 7],
					"30WX": [0, 8],
					"moxr": [0, 9]
				];

				ids.each(function(required string id, required array numbers) {
					expect(variables.SqidsEncoder.encode(arguments.numbers)).toBe(arguments.id);
					expect(variables.SqidsEncoder.decode(arguments.id)).toBe(arguments.numbers);
				} );
			} );

			it( "incremental numbers, same index 1", function() {
				var ids = [
					"SvIz": [0, 0],
					"nWqP": [1, 0],
					"tSyw": [2, 0],
					"eX68": [3, 0],
					"rxCY": [4, 0],
					"sV8a": [5, 0],
					"uf2K": [6, 0],
					"7Cdk": [7, 0],
					"3aWP": [8, 0],
					"m2xn": [9, 0]
				];

				ids.each(function(required string id, required array numbers) {
					expect(variables.SqidsEncoder.encode(arguments.numbers)).toBe(arguments.id);
					expect(variables.SqidsEncoder.decode(arguments.id)).toBe(arguments.numbers);
				} );
			} );

			it( "multi input", function() {
				var numbers = [
					0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25,
					26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
					50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73,
					74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92, 93, 94, 95, 96, 97,
					98, 99
				];

				var output = variables.SqidsEncoder.decode(variables.SqidsEncoder.encode(numbers));
				expect(output).toBe(numbers);
			} );

			it( "encoding no numbers", function() {
				expect(variables.SqidsEncoder.encode([])).toBe("");
			} );

			it( "decoding empty string", function() {
				expect(variables.SqidsEncoder.decode("")).toBe([]);
			} );

			it( "decoding an ID with an invalid character", function() {
				expect(variables.SqidsEncoder.decode("*")).toBe([]);
			} );

			it( "encode out-of-range numbers", function() {
				expect(function() { variables.SqidsEncoder.encode([-1]); }).toThrow();
				expect(function() { variables.SqidsEncoder.encode(variables.MaxNumber + 1); }).toThrow();
			} );
		} );
	}
}
