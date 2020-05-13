# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/)
and this project adheres to the following versioning pattern:

Given a version number MAJOR.MINOR.PATCH, increment:

- MAJOR version when the **API** version is incremented. This may include backwards incompatible changes;
- MINOR version when **breaking changes** are introduced OR **new functionalities** are added in a backwards compatible manner;
- PATCH version when backwards compatible bug **fixes** are implemented.


## [Unreleased]

## [0.3.0] - 2020-05-12
### Added
- "receiver_name" & "receiver_tax_id" properties to Boleto entities

## [0.2.1] - 2020-05-05
### Fixed
- Docstrings


## [0.2.0] - 2020-05-04
### Added
- "discounts" property to Boleto entities
- Support for hashes in create methods
- "balance" property to Transaction entities
### Changed
- Internal folder structure
### Fixed
- Docstrings
- BoletoPayment spec

## [0.1.0] - 2020-04-17
### Added
- Full Stark Bank API v2 compatibility
