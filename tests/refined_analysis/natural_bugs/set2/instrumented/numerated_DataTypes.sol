1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.19;
4 
5 /**
6  * @title DataTypes
7  * @notice Library containing various data structures and enums for the PirexEth.
8  * @dev This library provides data structures and enums crucial for the functionality of the Pirex protocol.
9  * @author redactedcartel.finance
10  */
11 library DataTypes {
12     // Validator struct type
13     struct Validator {
14         // Publickey of the validator
15         bytes pubKey;
16         // Signature associated with the validator
17         bytes signature;
18         // Root hash of deposit data for the validator
19         bytes32 depositDataRoot;
20         // beneficiazry address to receive pxEth against preDeposit
21         address receiver;
22     }
23 
24     // ValidatorDeque struct type
25     struct ValidatorDeque {
26         // Beginning index of the validator deque
27         int128 _begin;
28         // End index of the validator deque
29         int128 _end;
30         // Mapping of validator index to Validator struct
31         mapping(int128 => Validator) _validators;
32     }
33 
34     // Burner Account Type
35     struct BurnerAccount {
36         // Address of the burner account
37         address account;
38         // Amount associated with the burner account
39         uint256 amount;
40     }
41 
42     // Configurable fees
43     enum Fees {
44         // Fee type for deposit
45         Deposit,
46         // Fee type for redemption
47         Redemption,
48         // Fee type for instant redemption
49         InstantRedemption
50     }
51 
52     // Configurable contracts
53     enum Contract {
54         // PxEth contract
55         PxEth,
56         // UpxEth contract
57         UpxEth,
58         // AutoPxEth contract
59         AutoPxEth,
60         // OracleAdapter contract
61         OracleAdapter,
62         // PirexEth contract
63         PirexEth,
64         // RewardRecipient contract
65         RewardRecipient
66     }
67 
68     // Validator statuses
69     enum ValidatorStatus {
70         // The validator is not staking and has no defined status.
71         None,
72         // The validator is actively participating in the staking process.
73         // It could be in one of the following states: pending_initialized, pending_queued, or active_ongoing.
74         Staking,
75         // The validator has proceed with the withdrawal process.
76         // It represents a meta state for active_exiting, exited_unslashed, and the withdrawal process being possible.
77         Withdrawable,
78         // The validator's status indicating that ETH is released to the pirexEthValidators
79         // It represents the withdrawal_done status.
80         Dissolved,
81         // The validator's status indicating that it has been slashed due to misbehavior.
82         // It serves as a meta state encompassing active_slashed, exited_slashed,
83         // and the possibility of starting the withdrawal process (withdrawal_possible) or already completed (withdrawal_done)
84         // with the release of ETH, subject to a penalty for the misbehavior.
85         Slashed
86     }
87 }
