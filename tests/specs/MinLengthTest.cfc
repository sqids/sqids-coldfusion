component extends="testbox.system.BaseSpec" {

	/*********************************** LIFE CYCLE Methods ***********************************/

	function beforeAll(){
		// setup the entire test bundle here
        var sqidsOptions = new Sqids.SqidsOptions();
        variables.defaultAlphabetLength = sqidsOptions.getAlphabet().len();
        variables.maxNumber = createObject("java", "java.lang.Integer").MAX_VALUE;
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
			it( "simple", function() {
                var sqidsOptions = new Sqids.SqidsOptions(minLength=variables.defaultAlphabetLength);
                var sqidsEncoder = new Sqids.SqidsEncoder(sqidsOptions);

                var numbers = [1, 2, 3];
                var id = '86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTM';

                expect(sqidsEncoder.encode(numbers)).toBe(id);
                expect(sqidsEncoder.decode(id)).toBe(numbers);
			} );

			it( "incremental", function() {
                var numbers = [1, 2, 3];

                var map = [
                    6: "86Rf07",
                    7: "86Rf07x",
                    8: "86Rf07xd",
                    9: "86Rf07xd4",
                    10: "86Rf07xd4z",
                    11: "86Rf07xd4zB",
                    12: "86Rf07xd4zBm",
                    13: "86Rf07xd4zBmi",
                    variables.defaultAlphabetLength + 0:
                        "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTM",
                    variables.defaultAlphabetLength + 1:
                        "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTMy",
                    variables.defaultAlphabetLength + 2:
                        "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTMyf",
                    variables.defaultAlphabetLength + 3:
                        "86Rf07xd4zBmiJXQG6otHEbew02c3PWsUOLZxADhCpKj7aVFv9I8RquYrNlSTMyf1"
                ];

                map.each(function (required numeric minLength, required string id) {
                    var sqidsOptions = new Sqids.SqidsOptions(minLength = arguments.minLength);
                    var sqidsEncoder = new Sqids.SqidsEncoder(sqidsOptions);

                    expect(sqidsEncoder.encode(numbers)).toBe(arguments.id);
                    expect(sqidsEncoder.encode(numbers).len()).toBe(arguments.minLength);
                    expect(sqidsEncoder.decode(arguments.id)).toBe(numbers);
                });

			} );

			it( "incremental numbers", function() {
                var sqidsOptions = new Sqids.SqidsOptions(minLength = variables.defaultAlphabetLength);
                var sqidsEncoder = new Sqids.SqidsEncoder(sqidsOptions);

                var ids = [
                    "SvIzsqYMyQwI3GWgJAe17URxX8V924Co0DaTZLtFjHriEn5bPhcSkfmvOslpBu": [0, 0],
                    "n3qafPOLKdfHpuNw3M61r95svbeJGk7aAEgYn4WlSjXURmF8IDqZBy0CT2VxQc": [0, 1],
                    "tryFJbWcFMiYPg8sASm51uIV93GXTnvRzyfLleh06CpodJD42B7OraKtkQNxUZ": [0, 2],
                    "eg6ql0A3XmvPoCzMlB6DraNGcWSIy5VR8iYup2Qk4tjZFKe1hbwfgHdUTsnLqE": [0, 3],
                    "rSCFlp0rB2inEljaRdxKt7FkIbODSf8wYgTsZM1HL9JzN35cyoqueUvVWCm4hX": [0, 4],
                    "sR8xjC8WQkOwo74PnglH1YFdTI0eaf56RGVSitzbjuZ3shNUXBrqLxEJyAmKv2": [0, 5],
                    "uY2MYFqCLpgx5XQcjdtZK286AwWV7IBGEfuS9yTmbJvkzoUPeYRHr4iDs3naN0": [0, 6],
                    "74dID7X28VLQhBlnGmjZrec5wTA1fqpWtK4YkaoEIM9SRNiC3gUJH0OFvsPDdy": [0, 7],
                    "30WXpesPhgKiEI5RHTY7xbB1GnytJvXOl2p0AcUjdF6waZDo9Qk8VLzMuWrqCS": [0, 8],
                    "moxr3HqLAK0GsTND6jowfZz3SUx7cQ8aC54Pl1RbIvFXmEJuBMYVeW9yrdOtin": [0, 9]
                ];

                ids.each(function (required string id, required array numbers) {
                    expect(sqidsEncoder.encode(arguments.numbers)).toBe(arguments.id);
                    expect(sqidsEncoder.decode(arguments.id)).toBe(arguments.numbers);
                });
			} );

			it( "min lengths", function() {
                for (var minLength in [0, 1, 5, 10, variables.defaultAlphabetLength]) {
                    for (var numbers in [
                        [0],
                        [0, 0, 0, 0, 0],
                        [1, 2, 3, 4, 5, 6, 7, 8, 9, 10],
                        [100, 200, 300],
                        [1000, 2000, 3000],
                        [1000000],
                        [variables.maxNumber]
                    ]) {
                        var sqidsEncoder = new Sqids.SqidsEncoder(new Sqids.SqidsOptions(minLength=minLength));
                        var id = sqidsEncoder.encode(numbers);
                        expect(id.len()).toBeGTE(minLength);
                        expect(sqidsEncoder.decode(id)).toBe(numbers);
                    }
                }
			} );
		} );
	}
}
