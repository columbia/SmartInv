1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of src/lender/operator.sol
4 // SPDX-License-Identifier: AGPL-3.0-only
5 pragma solidity >=0.5.15 >=0.6.12;
6 
7 ////// lib/tinlake-auth/src/auth.sol
8 // Copyright (C) Centrifuge 2020, based on MakerDAO dss https://github.com/makerdao/dss
9 /* pragma solidity >=0.5.15; */
10 
11 contract Auth {
12     mapping (address => uint256) public wards;
13     
14     event Rely(address indexed usr);
15     event Deny(address indexed usr);
16 
17     function rely(address usr) external auth {
18         wards[usr] = 1;
19         emit Rely(usr);
20     }
21     function deny(address usr) external auth {
22         wards[usr] = 0;
23         emit Deny(usr);
24     }
25 
26     modifier auth {
27         require(wards[msg.sender] == 1, "not-authorized");
28         _;
29     }
30 
31 }
32 
33 ////// src/lender/operator.sol
34 /* pragma solidity >=0.6.12; */
35 
36 /* import "tinlake-auth/auth.sol"; */
37 
38 interface TrancheLike_4 {
39     function supplyOrder(address usr, uint currencyAmount) external;
40     function redeemOrder(address usr, uint tokenAmount) external;
41     function disburse(address usr) external returns (uint payoutCurrencyAmount, uint payoutTokenAmount, uint remainingSupplyCurrency,  uint remainingRedeemToken);
42     function disburse(address usr, uint endEpoch) external returns (uint payoutCurrencyAmount, uint payoutTokenAmount, uint remainingSupplyCurrency,  uint remainingRedeemToken);
43     function currency() external view returns (address);
44 }
45 
46 interface RestrictedTokenLike {
47     function hasMember(address) external view returns (bool);
48 }
49 
50 interface EIP2612PermitLike {
51     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
52 }
53 
54 interface DaiPermitLike {
55     function permit(address holder, address spender, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s) external;
56 }
57 
58 contract Operator is Auth {
59     TrancheLike_4 public tranche;
60     RestrictedTokenLike public token;
61 
62     // Events
63     event SupplyOrder(uint indexed amount);
64     event RedeemOrder(uint indexed amount);
65 
66     constructor(address tranche_) {
67         wards[msg.sender] = 1;
68         tranche = TrancheLike_4(tranche_);
69     }
70 
71     // sets the dependency to another contract
72     function depend(bytes32 contractName, address addr) public auth {
73         if (contractName == "tranche") { tranche = TrancheLike_4(addr); }
74         else if (contractName == "token") { token = RestrictedTokenLike(addr); }
75         else revert();
76     }
77 
78     // only investors that are on the memberlist can submit supplyOrders
79     function supplyOrder(uint amount) public {
80         require((token.hasMember(msg.sender) == true), "user-not-allowed-to-hold-token");
81         tranche.supplyOrder(msg.sender, amount);
82         emit SupplyOrder(amount);
83     }
84 
85     // only investors that are on the memberlist can submit redeemOrders
86     function redeemOrder(uint amount) public {
87         require((token.hasMember(msg.sender) == true), "user-not-allowed-to-hold-token");
88         tranche.redeemOrder(msg.sender, amount);
89         emit RedeemOrder(amount);
90     }
91 
92     // only investors that are on the memberlist can disburse
93     function disburse() external
94         returns(uint payoutCurrencyAmount, uint payoutTokenAmount, uint remainingSupplyCurrency,  uint remainingRedeemToken)
95     {
96         require((token.hasMember(msg.sender) == true), "user-not-allowed-to-hold-token");
97         return tranche.disburse(msg.sender);
98     }
99 
100     function disburse(uint endEpoch) external
101         returns(uint payoutCurrencyAmount, uint payoutTokenAmount, uint remainingSupplyCurrency,  uint remainingRedeemToken)
102     {
103         require((token.hasMember(msg.sender) == true), "user-not-allowed-to-hold-token");
104         return tranche.disburse(msg.sender, endEpoch);
105     }
106 
107     // --- Permit Support ---
108     function supplyOrderWithDaiPermit(uint amount, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
109         DaiPermitLike(tranche.currency()).permit(msg.sender, address(tranche), nonce, expiry, true, v, r, s);
110         supplyOrder(amount);
111     }
112     function supplyOrderWithPermit(uint amount, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) public {
113         EIP2612PermitLike(tranche.currency()).permit(msg.sender, address(tranche), value, deadline, v, r, s);
114         supplyOrder(amount);
115     }
116     function redeemOrderWithPermit(uint amount, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) public {
117         EIP2612PermitLike(address(token)).permit(msg.sender, address(tranche), value, deadline, v, r, s);
118         redeemOrder(amount);
119     }
120 }
