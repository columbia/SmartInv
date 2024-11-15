1 # Sherlock V2
2 
3 Sherlock V2 is a multi contract protocol with upgradable parts.
4 
5 This README explains how the contracts are working together and what the tasks of every contract are. For a deep dive on the protocol mechanics please read our docs.
6 
7 ## Sherlock.sol
8 
9 > contracts/Sherlock.sol
10 
11 `Sherlock.sol` is the core contract which is not upgradable. It is the contract that holds and has access to all the capital.
12 
13 Stakers interact with this contract to create and manage positions in Sherlock.
14 
15 The owner (governance) will be able to update other logic parts of the protocol, these parts are
16 
17 - Claim Manager; is able to pull funds out of the Sherlock contract.
18 - SHER Distribution Manager; contains the SHER tokens and logic to distribute among stakers.
19 - Protocol Manager; manages covered protocols, balances and incoming premiums
20 - NonStaker; is used by `Protocol Manager` to split premiums.
21 - Yield Strategy; the capital can be deployed to earn extra yield in other protocols (Aave, Compound)
22 
23 ## Claim Manager
24 
25 > contracts/managers/SherlockClaimManager.sol
26 
27 The task of this contract is to expose a fully 'automated' claim process where governance is not step in between.
28 
29 Protocol agents are able to submit a claim that first passes by the Sherlock Protocol Claims Committee (SPCC), a multisig of security people in the space. In the SPCC denies the claim the protocol agent can escalate to UMA court, which gives UMA tokens holders (independent party) the final say in the validity of the claim.
30 
31 The UMA Halt Operator (UMAHO) is able to dismiss a validated claim by UMA. This role can be renounced by governance.
32 
33 If a claim is valid, funds are pulled out of the Sherlock contract and every staker is hit evenly.
34 
35 ## SHER distribution manager
36 
37 > contracts/managers/SherDistributionManager.sol
38 
39 The task of this contract is to distribute SHER tokens to stakers that are locking up their capital.
40 
41 The distribution curve is based on current TVL, using the time period as multiplier.
42 
43 The curve starts with a flat part to provide a fixed rate. It ends with a lineair slope all the way to a 0 rate.
44 
45 ## Protocol manager
46 
47 > contracts/managers/SherlockProtocolManager.sol
48 
49 Task of this contract is to manage the protocols that Sherlock covers. The contract is designed in a way where protocols are removed by arbs if their active balance runs out.
50 
51 Part of the premiums paid by the protocols go to non stakers.
52 
53 ## Non staker
54 
55 This address is able to pull funds out of the protocol manager contract. In the future a TBD contract will be used to compensate Watsons, reinsurers and potential other parties that provide value to this protocol relationship.
56 
57 ## Yield strategy
58 
59 > contracts/managers/AaveV2Strategy.sol
60 
61 Task of this contract is to allocate stakers fund to earn yield.
