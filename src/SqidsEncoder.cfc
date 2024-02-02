component namespace="Sqids"
{
    public SqidsEncoder function init(SqidsOptions options) {
        variables.MaxMinLength = 255;
        variables.MinAlphabetLength = 3;
        variables.MaxNumber = createObject("java", "java.lang.Integer").MAX_VALUE;

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

		// clean up blocklist:
		// 1. all blocklist words should be lowercase
		// 2. no words less than 3 chars
		// 3. if some words contain chars that are not in the alphabet, remove those
		var filteredBlocklist = [];
		var alphabetChars = listToArray(lCase(alphabet), "");
		for (var word in blocklist) {
			if (word.len() >= 3) {
				var wordLowercased = lCase(word);
				var wordChars = listToArray(wordLowercased, "");
				var intersection = wordChars.filter(
					function (required string wordChar)
					{
						var _wordChar = arguments.wordChar;
						return alphabetChars.some(
							function (required string alphabetChar)
							{
								return arguments.alphabetChar == _wordChar;
							});
					});
				if (intersection.len() == wordChars.len()) {
					filteredBlocklist.append(wordLowercased);
				}
			}
		}

        variables.alphabet = shuffle(listToArray(alphabet, ""));
        variables.minLength = minLength;
        variables.blocklist = filteredBlocklist;

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
	public string function encode(required array numbersArg) {
		var numbers = arguments.numbersArg;

		// if no numbers passed, return an empty string
		if (arrayLen(numbers) == 0) {
			return "";
		}

		// don"t allow out-of-range numbers [might be lang-specific]
		var inRangeNumbers = numbers.filter(
			function (required numeric n)
			{
				return arguments.n >= 0 && arguments.n <= variables.MaxNumber;
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
	private string function encodeNumbers(required array numbersArg, numeric increment = 0) {
		var numbers = arguments.numbersArg;

		// if increment is greater than alphabet length, we"ve reached max attempts
		if (increment > variables.alphabet.len()) {
			throw(type="custom", message="Reached max attempts to re-generate the ID");
		}

		// get a semi-random offset from input numbers
		var offset = numbers.reduce(
			function (required numeric result, required numeric item, required numeric index)
			{
				return asc(variables.alphabet[arguments.item mod Len(variables.alphabet) + 1]) + arguments.index - 1 + arguments.result;
			}, numbers.len()
		) mod variables.alphabet.len() + 1;

		// if there is a non-zero `increment`, it's an internal attempt to re-generated the ID
		offset = (offset + arguments.increment) mod variables.alphabet.len();

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

		// handle `minLength` requirement, if the ID is too short
		if (variables.minLength > ret.len()) {
			// append a separator
			ret.append(alphabet.mid(1, 1), true);

			// keep appending `separator` + however much alphabet is needed
			// for decoding: two separators next to each other is what tells us the rest are junk characters
			while (variables.minLength - ret.len() > 0) {
				alphabet = shuffle(alphabet);
				ret.append(alphabet.mid(1, min(variables.minLength - ret.len(), alphabet.len())), true);
			}
		}

		var id = arrayToList(ret, "");

		// if ID has a blocked word anywhere, restart with a +1 increment
		if (isBlockedId(id)) {
			id = encodeNumbers(numbers, increment + 1);
		}

		return id;
	}

	/**
	 * Decodes an ID back into an array of unsigned integers
	 *
	 * These are the cases where the return value might be an empty array:
	 * - Empty ID / empty string
	 * - Non-alphabet character is found within ID
	 *
	 * @param {string} id Encoded ID
	 * @returns {array.<number>} Array of unsigned integers
	 */
	public array function decode(required string idArg) {
		var id = arguments.idArg;
		var ret = [];

		// if an empty string, return an empty array
		if (id == "") {
			return ret;
		}

		// if a character is not in the alphabet, return an empty array
		var alphabetChars = variables.alphabet;
		for (var idChar in listToArray(id, "")) {
			if (!alphabetChars.some(
					function (required string alphabetChar)
					{
						return arguments.alphabetChar == idChar;
					})) {
				return ret;
			}
		}

		// first character is always the `prefix`
		var prefix = id[1];

		// `offset` is the semi-random position that was generated during encoding
		var offset = variables.alphabet.find(prefix);

		// re-arrange alphabet back into it's original form
		var alphabet = variables.alphabet.mid(offset);
		alphabet.append(variables.alphabet.mid(1, offset - 1), true);

		// reverse alphabet
		alphabet = alphabet.reverse();

		// now it's safe to remove the prefix character from ID, it's not needed anymore
		id = id.right(id.len() - 1);

		while (id.len()) {
			var separator = alphabet[1];
			// we need the first part to the left of the separator to decode the number
			var chunks = listToArray(id, separator, true);

			// if chunk is empty, we are done (the rest are junk characters)
			if (chunks[1] == "") {
				return ret;
			}

			// decode the number without using the `separator` character
			var alphabetWithoutSeparator = alphabet.mid(2);
			ret.append(toNumber(chunks[1], alphabetWithoutSeparator), true);

			// if this ID has multiple numbers, shuffle the alphabet because that's what encoding function did
			if (chunks.len() > 1) {
				alphabet = this.shuffle(alphabet);
			}

			// `id` is now going to be everything to the right of the `separator`
			id = arrayToList(chunks.mid(2), separator);

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
		var result = arguments.num;

		do {
			id.prepend(chars[result mod chars.len() + 1]);
			result = Int(result / chars.len());
		} while (result > 0);

		return id;
	}

	private numeric function toNumber(required string id, required array alphabetArg)
	{
		var alphabet = arguments.alphabetArg;
		var idChars = listToArray(arguments.id, "");

		return idChars.reduce(
			function (required numeric result, required string item)
			{
				return arguments.result * alphabet.len() + alphabet.find(arguments.item) - 1;
			}, 0);
	}

	private boolean function isBlockedId(required string idArg) {
		var id = lCase(arguments.idArg);

		for (var word in variables.blocklist) {
			// no point in checking words that are longer than the ID
			if (word.len() <= id.len()) {
				if (id.len() <= 3 || word.len() <= 3) {
					// short words have to match completely; otherwise, too many matches
					if (id == word) {
						return true;
					}
				} else if (ReFind("\d", word) > 0) { // test for a number in the word
					// words with leet speak replacements are visible mostly on the ends of the ID
					if (Left(id, word.len()) == word || Right(id, word.len()) == word) {
						return true;
					}
				} else if (findNoCase(word, id) > 0) {
					// otherwise, check for blocked word anywhere in the string
					return true;
				}
			}
		}

		return false;
	}
}
