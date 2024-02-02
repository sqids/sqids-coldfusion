# [Sqids Coldfusion](https://sqids.org/coldfusion)

[Sqids](https://sqids.org/coldfusion) (*pronounced "squids"*) is a small library that lets you **generate unique IDs from numbers**. It's good for link shortening, fast & URL-safe ID generation and decoding back into numbers for quicker database lookups.

Features:

- **Encode multiple numbers** - generate short IDs from one or several non-negative numbers
- **Quick decoding** - easily decode IDs back into numbers
- **Unique IDs** - generate unique IDs by shuffling the alphabet once
- **ID padding** - provide minimum length to make IDs more uniform
- **URL safe** - auto-generated IDs do not contain common profanity
- **Randomized output** - Sequential input provides nonconsecutive IDs
- **Many implementations** - Support for [40+ programming languages](https://sqids.org/)

## 🧰 Use-cases

Good for:

- Generating IDs for public URLs (eg: link shortening)
- Generating IDs for internal systems (eg: event tracking)
- Decoding for quicker database lookups (eg: by primary keys)

Not good for:

- Sensitive data (this is not an encryption library)
- User IDs (can be decoded revealing user count)

## 🚀 Getting started

Tested with:
 * Adobe Coldfusion 2018
 * Adobe Coldfusion 2021
 * Adobe Coldfusion 2023
 * Lucee 5
 * Lucee 6

Clone the repository and copy the Sqids folder to your project. Then in the application.cfc add a mapping
```java
this.mappings[ "/Sqids" ] = expandPath( "/src/Sqids" );
```

## 👩‍💻 Examples

Simple encode & decode:

```java
var sqids = new Sqids.SquidsEncoder();
var id = sqids.encode([1, 2, 3]); // "86Rf07"
var numbers = sqids.decode(id); // [1, 2, 3]
```

> **Note**
> 🚧 Because of the algorithm's design, **multiple IDs can decode back into the same sequence of numbers**. If it's important to your design that IDs are canonical, you have to manually re-encode decoded numbers and check that the generated ID matches.

Enforce a *minimum* length for IDs:

```java
var sqids = new Sqids.SquidsEncoder(new Sqids.SqidsOptions(minLength = 10));
var id = sqids.encode([1, 2, 3]); // "86Rf07xd4z"
var numbers = sqids.decode(id); // [1, 2, 3]
```

Randomize IDs by providing a custom alphabet:

```java
var sqids = new Sqids.SquidsEncoder(new Sqids.SqidsOptions(alphabet = "FxnXM1kBN6cuhsAvjW3Co7l2RePyY8DwaU04Tzt9fHQrqSVKdpimLGIJOgb5ZE"));
var id = sqids.encode([1, 2, 3]); // "B4aajs"
var numbers = sqids.decode(id); // [1, 2, 3]
```

Prevent specific words from appearing anywhere in the auto-generated IDs:

```java
var sqids = new Sqids.SquidsEncoder(new Sqids.SqidsOptions(blocklist = ["86Rf07"]));
var id = sqids.encode([1, 2, 3]); // "se8ojk"
var numbers = sqids.decode(id); // [1, 2, 3]
```

## 📝 License

[MIT](LICENSE)
