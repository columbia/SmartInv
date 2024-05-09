# Sherlock V2

Sherlock V2 is a multi contract protocol with upgradable parts.

This README explains how the contracts are working together and what the tasks of every contract are. For a deep dive on the protocol mechanics please read our docs.

## Sherlock.sol

> contracts/Sherlock.sol

`Sherlock.sol` is the core contract which is not upgradable. It is the contract that holds and has access to all the capital.

Stakers interact with this contract to create and manage positions in Sherlock.

The owner (governance) will be able to update other logic parts of the protocol, these parts are

- Claim Manager; is able to pull funds out of the Sherlock contract.
- SHER Distribution Manager; contains the SHER tokens and logic to distribute among stakers.
- Protocol Manager; manages covered protocols, balances and incoming premiums
- NonStaker; is used by `Protocol Manager` to split premiums.
- Yield Strategy; the capital can be deployed to earn extra yield in other protocols (Aave, Compound)

## Claim Manager

> contracts/managers/SherlockClaimManager.sol

The task of this contract is to expose a fully 'automated' claim process where governance is not step in between.

Protocol agents are able to submit a claim that first passes by the Sherlock Protocol Claims Committee (SPCC), a multisig of security people in the space. In the SPCC denies the claim the protocol agent can escalate to UMA court, which gives UMA tokens holders (independent party) the final say in the validity of the claim.

The UMA Halt Operator (UMAHO) is able to dismiss a validated claim by UMA. This role can be renounced by governance.

If a claim is valid, funds are pulled out of the Sherlock contract and every staker is hit evenly.

## SHER distribution manager

> contracts/managers/SherDistributionManager.sol

The task of this contract is to distribute SHER tokens to stakers that are locking up their capital.

The distribution curve is based on current TVL, using the time period as multiplier.

The curve starts with a flat part to provide a fixed rate. It ends with a lineair slope all the way to a 0 rate.

## Protocol manager

> contracts/managers/SherlockProtocolManager.sol

Task of this contract is to manage the protocols that Sherlock covers. The contract is designed in a way where protocols are removed by arbs if their active balance runs out.

Part of the premiums paid by the protocols go to non stakers.

## Non staker

This address is able to pull funds out of the protocol manager contract. In the future a TBD contract will be used to compensate Watsons, reinsurers and potential other parties that provide value to this protocol relationship.

## Yield strategy

> contracts/managers/AaveV2Strategy.sol

Task of this contract is to allocate stakers fund to earn yield.
