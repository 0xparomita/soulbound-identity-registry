# Soulbound Identity Registry

This repository implements the **Soulbound Token (SBT)** pattern. These tokens represent a user's digital identity or reputation and cannot be sold, traded, or transferred after being issued.

## Core Logic
* **Non-Transferability**: The `_update` function is overridden to revert on any transfer attempt, except for the initial minting (from `address(0)`).
* **Attestations**: Only authorized "Issuers" (e.g., a KYC provider or a DAO) can mint tokens to a user's wallet.
* **Burnable**: Users can "discard" their own identity tokens if they no longer wish to associate with the issuer, but they cannot give them to someone else.

## Use Cases
* **KYC/AML Compliance**: Marking a wallet as "Verified."
* **Gaming Achievements**: Non-tradable trophies or rank badges.
* **Governance**: Tracking voting power based on historical contributions rather than liquid tokens.
