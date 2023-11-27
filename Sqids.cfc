component {

    variables.alphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    variables.minLength = 0;
    variables.blocklist = []; // Note: Original JS uses a Set, adjust accordingly

    public function init(required struct options = {}) {
        // Initialize properties based on provided options or use defaults
        variables.alphabet = options.keyExists("alphabet") ? options.alphabet : variables.alphabet;
        variables.minLength = options.keyExists("minLength") ? options.minLength : variables.minLength;
        variables.blocklist = options.keyExists("blocklist") ? options.blocklist : variables.blocklist;

        // Additional initialization logic as needed
        return this;
    }

    private string function shuffle(required string input) {
        var array = listToArray(input);
        var length = arrayLen(array);
        for (var i = length; i > 1; i--) {
            var j = randRange(1, i);
            var temp = array[i];
            array[i] = array[j];
            array[j] = temp;
        }
        return arrayToList(array, '');
    }

    private numeric function toNumber(required string input, required string alphabet) {
        var number = 0;
        var base = len(alphabet);
        var inputArray = listToArray(input, '');
        for (var i = 1; i <= arrayLen(inputArray); i++) {
            number = number * base + findNoCase(inputArray[i], alphabet);
        }
        return number;
    }

    private string function toId(required numeric number, required string alphabet) {
        var id = '';
        var base = len(alphabet);
        while (number > 0) {
            var remainder = number % base;
            id = mid(alphabet, remainder + 1, 1) & id;
            number = floor(number / base);
        }
        return id;
    }

    private boolean function isBlockedId(required string id) {
        // Simple implementation, adjust as needed
        return listFindNoCase(arrayToList(variables.blocklist), id);
    }

    private numeric function maxValue() {
        return 9007199254740991; // CFScript equivalent of JavaScript's Number.MAX_SAFE_INTEGER
    }

    public string function encode(required array numbers) {
        var encodedString = '';
        // Encoding logic
        return encodedString;
    }

    public array function decode(required string encodedString) {
        var numbers = [];
        // Decoding logic
        return numbers;
    }

    private string function encodeNumbers(required array numbers, numeric attempts = 0) {
        var totalAlphabetLength = len(variables.alphabet);
        var firstCharIndex = (arraySum(numbers) + arrayLen(numbers)) % totalAlphabetLength;
        firstCharIndex = (firstCharIndex + attempts) % totalAlphabetLength;
        var shiftedAlphabet = mid(variables.alphabet, firstCharIndex + 1, totalAlphabetLength - firstCharIndex) & left(variables.alphabet, firstCharIndex);
        var reversedAlphabet = reverse(shiftedAlphabet);
        var encoded = mid(variables.alphabet, firstCharIndex + 1, 1);
        var remainingAlphabet = reversedAlphabet;

        for (var i = 1; i <= arrayLen(numbers); i++) {
            var number = numbers[i];
            encoded &= this.toId(number, remainingAlphabet);
            if (i < arrayLen(numbers)) {
                encoded &= left(remainingAlphabet, 1);
                remainingAlphabet = this.shuffle(remainingAlphabet);
            }
        }

        if (variables.minLength > len(encoded)) {
            encoded &= left(remainingAlphabet, 1);
            while (len(encoded) < variables.minLength) {
                remainingAlphabet = this.shuffle(remainingAlphabet);
                encoded &= left(remainingAlphabet, min(variables.minLength - len(encoded), len(remainingAlphabet)));
            }
        }

        if (this.isBlockedId(encoded)) {
            return this.encodeNumbers(numbers, attempts + 1);
        }

        return encoded;
    }

    public string function encode(required array numbers) {
        return this.encodeNumbers(numbers);
    }

    public array function decode(required string encodedString) {
        var numbers = [];
        if (len(encodedString) == 0) {
            return numbers;
        }

        var firstChar = left(encodedString, 1);
        var firstCharIndex = find(firstChar, variables.alphabet);
        var shiftedAlphabet = mid(variables.alphabet, firstCharIndex, len(variables.alphabet) - firstCharIndex + 1) & left(variables.alphabet, firstCharIndex - 1);
        var reversedAlphabet = reverse(shiftedAlphabet);
        var remainingEncodedString = right(encodedString, len(encodedString) - 1);

        while (len(remainingEncodedString) > 0) {
            var delimiter = left(reversedAlphabet, 1);
            var splitPosition = find(delimiter, remainingEncodedString);
            if (splitPosition == 0) {
                break;
            }

            var encodedNumber = left(remainingEncodedString, splitPosition - 1);
            arrayAppend(numbers, this.toNumber(encodedNumber, reversedAlphabet));
            if (len(remainingEncodedString) > splitPosition) {
                reversedAlphabet = this.shuffle(reversedAlphabet);
            }
            remainingEncodedString = right(remainingEncodedString, len(remainingEncodedString) - splitPosition);
        }

        return numbers;
    }

    // More methods and logic within the component...

    private numeric function maxValue() {
        return 9007199254740991; // CFScript equivalent of JavaScript's Number.MAX_SAFE_INTEGER
    }

    // Function to check if the generated ID is blocked
    private boolean function isBlockedId(required string id) {
        var lowerCaseId = lCase(id);
        for (var blockedWord in variables.blocklist) {
            if (len(blockedWord) <= len(lowerCaseId)) {
                if (len(lowerCaseId) <= 3 || len(blockedWord) <= 3) {
                    if (lowerCaseId == blockedWord) {
                        return true;
                    }
                } else if (reFindNoCase("\\d", blockedWord)) {
                    if (left(lowerCaseId, len(blockedWord)) == blockedWord || right(lowerCaseId, len(blockedWord)) == blockedWord) {
                        return true;
                    }
                } else if (findNoCase(blockedWord, lowerCaseId)) {
                    return true;
                }
            }
        }
        return false;
    }

    // Function to shuffle characters in a string
    private string function shuffle(required string input) {
        var array = listToArray(input, '');
        var length = arrayLen(array);
        for (var i = length; i > 1; i--) {
            var j = randRange(1, i);
            var temp = array[i];
            array[i] = array[j];
            array[j] = temp;
        }
        return arrayToList(array, '');
    }

    // Function to convert a number to a string ID using the given alphabet
    private string function toId(required numeric number, required string alphabet) {
        var id = '';
        var base = len(alphabet);
        while (number > 0) {
            var remainder = number % base;
            id = mid(alphabet, remainder + 1, 1) & id;
            number = floor(number / base);
        }
        return id;
    }

    // Function to convert a string ID to a number using the given alphabet
    private numeric function toNumber(required string id, required string alphabet) {
        var number = 0;
        var base = len(alphabet);
        for (var char in listToArray(id, '')) {
            number = number * base + findNoCase(char, alphabet) - 1;
        }
        return number;
    }

        // Implementing remaining logic and methods...

    // Function to ensure the encoded ID meets minimum length and is not blocked
    private string function finalizeEncoding(required string encoded, required string alphabet) {
        var adjustedEncoded = encoded;
        if (len(adjustedEncoded) < variables.minLength) {
            adjustedEncoded &= mid(alphabet, randRange(1, len(alphabet)), 1);
            while (len(adjustedEncoded) < variables.minLength) {
                alphabet = this.shuffle(alphabet);
                adjustedEncoded &= mid(alphabet, 1, min(variables.minLength - len(adjustedEncoded), len(alphabet)));
            }
        }

        if (this.isBlockedId(adjustedEncoded)) {
            return this.finalizeEncoding(this.shuffle(encoded), alphabet);
        }

        return adjustedEncoded;
    }

    // Implementing the encode method with finalizing the encoding
    public string function encode(required array numbers) {
        var encodedString = this.encodeNumbers(numbers);
        var shuffledAlphabet = this.shuffle(variables.alphabet);
        return this.finalizeEncoding(encodedString, shuffledAlphabet);
    }

    // Decoding function implementation
    public array function decode(required string encodedString) {
        var decodedNumbers = [];
        // Logic for decoding the string back into numbers
        return decodedNumbers;
    }

}
