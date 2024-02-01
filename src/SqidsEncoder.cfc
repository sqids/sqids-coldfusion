component namespace="Sqids"
{
    public SqidsEncoder function init(SqidsOptions options) {
        variables.MaxMinLength = 255;
        variables.MinAlphabetLength = 3;
        variables.MaxNumber = createObject("java", "java.lang.Long").MAX_VALUE;

        // Initialize properties based on provided options or use defaults
        var alphabet = arguments.options.getAlphabet();
        var minLength = arguments.options.getMinLength();
        var blocklist = arguments.options.getBlocklist();

        // alphabet cannot contain multibyte characters
		if (len(charsetDecode(alphabet, "UTF-8")) != len(alphabet)) {
			throw(type="custom", message="Alphabet cannot contain multibyte characters");
		}

		// check the length of the alphabet
		if (alphabet.len() < MinAlphabetLength) {
			throw(type="custom", message="Alphabet length must be at least 3");
		}

		// check that the alphabet has only unique characters
		if (len(ListRemoveDuplicates(alphabet, "")) != alphabet.len()) {
			throw(type="custom", message="Alphabet must contain unique characters");
		}

        if (minLength < 0 || minLength > variables.MaxMinLength) {
			throw(type="custom", message = "The minimum length must be between 0 and #variables.MaxMinLength#.");
		}

        variables.alphabet = shuffle(listToArray(alphabet, ""));
        variables.minLength = minLength;
        //variables.blocklist = filteredBlocklist;

        return this;
    }

	/**
	 * Encodes an array of unsigned integers into an ID
	 *
	 * These are the cases where encoding might fail:
	 * - One of the numbers passed is smaller than 0 or greater than `maxValue()`
	 * - An n-number of attempts has been made to re-generated the ID, where n is alphabet length + 1
	 *
	 * @param {array.<number>} numbers Non-negative integers to encode into an ID
	 * @returns {string} Generated ID
	 */
	public string function encode(required array numbers) {
		// if no numbers passed, return an empty string
		if (arrayLen(numbers) == 0) {
			return "";
		}

		// don"t allow out-of-range numbers [might be lang-specific]
		var inRangeNumbers = numbers.filter(function (n) {
            return n >= 0 && n <= variables.MaxNumber;
        });

		if (inRangeNumbers.len() != numbers.len()) {
			throw(type="custom", message="Encoding supports numbers between 0 and #variables.MaxNumber#");
		}

		return this.encodeNumbers(numbers);
	}

	/**
	 * Internal function that encodes an array of unsigned integers into an ID
	 *
	 * @param {array.<number>} numbers Non-negative integers to encode into an ID
	 * @param {number} increment An internal number used to modify the `offset` variable in order to re-generate the ID
	 * @returns {string} Generated ID
	 */
	private string function encodeNumbers(required array numbers, numeric increment = 0) {
		// if increment is greater than alphabet length, we"ve reached max attempts
		if (increment > variables.alphabet.len()) {
			throw(type="custom", message="Reached max attempts to re-generate the ID");
		}

		// get a semi-random offset from input numbers
		var offset = numbers.reduce(
			function (required numeric result, required numeric item, required numeric index)
			{
				return asc(variables.alphabet[item mod Len(variables.alphabet) + 1]) + index - 1 + result;
			}, numbers.len()
		) mod variables.alphabet.len() + 1;

		// if there is a non-zero `increment`, it's an internal attempt to re-generated the ID
		offset = (offset + increment) mod variables.alphabet.len();

		// re-arrange alphabet so that second-half goes in front of the first-half
		var alphabet = variables.alphabet.mid(offset);
		alphabet.append(variables.alphabet.mid(1, offset - 1), true);

		// `prefix` is the first character in the generated ID, used for randomization
		var prefix = alphabet[1];

		// reverse alphabet (otherwise for [0, x] `offset` and `separator` will be the same char)
		alphabet = alphabet.reverse();

		// final ID will always have the `prefix` character at the beginning
		var ret = [prefix];

		// encode input array
		for (var i = 1; i <= numbers.len(); i++) {
			var num = numbers[i];

			// the first character of the alphabet is going to be reserved for the `separator`
			var alphabetWithoutSeparator = alphabet.mid(2);
			ret.append(toId(num, alphabetWithoutSeparator), true);

			// if not the last number
			if (i < numbers.len()) {
				// `separator` character is used to isolate numbers within the ID
				ret.append(alphabet.mid(1, 1), true);

				// shuffle on every iteration
				alphabet = shuffle(alphabet);
			}
		}

		return arrayToList(ret, "");
	}

	public array function decode(required string id) {
		var ret = [];

		// if an empty string, return an empty array
		if (id == "") {
			return ret;
		}

		return ret;
	}


	// consistent shuffle (always produces the same result given the input)
	private array function shuffle(array alphabet) {
		var chars = arguments.alphabet;
		var numberOfChars = chars.len();

		var i = 1;
		for (var j = numberOfChars; j > 1; j--) {
			var r = (i * j + asc(chars[i]) + asc(chars[j])) mod numberOfChars + 1;
			var temp = chars[i];
			chars[i] = chars[r];
			chars[r] = temp;

			i++;
		}

		return chars;
	}

	private array function toId(required numeric num, required array alphabet) {
		var id = [];
		var chars = arguments.alphabet;

		var result = num;

		do {
			id.prepend(chars[result mod chars.len() + 1]);
			result = Int(result / chars.len());
		} while (result > 0);

		return id;
	}
}
