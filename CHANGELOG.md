# CHANGELOG

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Adobe ColdFusion 2016 support: replaced string bracket indexing (`str[i]`) with `mid()`/`left()` and `arraySome()` with `arrayFind()`, neither of which exists on CF2016
- `adobe@2016` added to the CI engine matrix, plus `server-sqids-coldfusion-adobe2016.json`

### Changed

- TestBox dev dependency pinned to 4.x so the suite can run on CF2016 (TestBox 5 requires CF2018+)

### Fixed

- `decode()` threw on a one-character ID instead of returning an empty array

## [0.0.1] - 2024-02-02

### Added

- Initial implementation of [the spec](https://github.com/sqids/sqids-spec)
