1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of src/lender/operator.sol
4 pragma solidity >=0.5.15 >=0.5.15 <0.6.0;
5 
6 ////// lib/tinlake-auth/lib/ds-note/src/note.sol
7 /// note.sol -- the `note' modifier, for logging calls as events
8 
9 // This program is free software: you can redistribute it and/or modify
10 // it under the terms of the GNU General Public License as published by
11 // the Free Software Foundation, either version 3 of the License, or
12 // (at your option) any later version.
13 
14 // This program is distributed in the hope that it will be useful,
15 // but WITHOUT ANY WARRANTY; without even the implied warranty of
16 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17 // GNU General Public License for more details.
18 
19 // You should have received a copy of the GNU General Public License
20 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
21 /* pragma solidity >=0.5.15; */
22 
23 contract DSNote {
24     event LogNote(
25         bytes4   indexed  sig,
26         address  indexed  guy,
27         bytes32  indexed  foo,
28         bytes32  indexed  bar,
29         uint256           wad,
30         bytes             fax
31     ) anonymous;
32 
33     modifier note {
34         bytes32 foo;
35         bytes32 bar;
36         uint256 wad;
37 
38         assembly {
39             foo := calldataload(4)
40             bar := calldataload(36)
41             wad := callvalue()
42         }
43 
44         _;
45 
46         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
47     }
48 }
49 
50 ////// lib/tinlake-auth/src/auth.sol
51 // Copyright (C) Centrifuge 2020, based on MakerDAO dss https://github.com/makerdao/dss
52 //
53 // This program is free software: you can redistribute it and/or modify
54 // it under the terms of the GNU Affero General Public License as published by
55 // the Free Software Foundation, either version 3 of the License, or
56 // (at your option) any later version.
57 //
58 // This program is distributed in the hope that it will be useful,
59 // but WITHOUT ANY WARRANTY; without even the implied warranty of
60 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
61 // GNU Affero General Public License for more details.
62 //
63 // You should have received a copy of the GNU Affero General Public License
64 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
65 
66 /* pragma solidity >=0.5.15 <0.6.0; */
67 
68 /* import "ds-note/note.sol"; */
69 
70 contract Auth is DSNote {
71     mapping (address => uint) public wards;
72     function rely(address usr) public auth note { wards[usr] = 1; }
73     function deny(address usr) public auth note { wards[usr] = 0; }
74     modifier auth { require(wards[msg.sender] == 1); _; }
75 }
76 
77 ////// src/lender/operator.sol
78 // Copyright (C) 2020 Centrifuge
79 //
80 // This program is free software: you can redistribute it and/or modify
81 // it under the terms of the GNU Affero General Public License as published by
82 // the Free Software Foundation, either version 3 of the License, or
83 // (at your option) any later version.
84 //
85 // This program is distributed in the hope that it will be useful,
86 // but WITHOUT ANY WARRANTY; without even the implied warranty of
87 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
88 // GNU Affero General Public License for more details.
89 //
90 // You should have received a copy of the GNU Affero General Public License
91 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
92 
93 /* pragma solidity >=0.5.15 <0.6.0; */
94 
95 /* import "ds-note/note.sol"; */
96 /* import "tinlake-auth/auth.sol"; */
97 
98 contract TrancheLike_2 {
99     function supplyOrder(address usr, uint currencyAmount) public;
100     function redeemOrder(address usr, uint tokenAmount) public;
101     function disburse(address usr) public returns (uint payoutCurrencyAmount, uint payoutTokenAmount, uint remainingSupplyCurrency,  uint remainingRedeemToken);
102     function disburse(address usr, uint endEpoch) public returns (uint payoutCurrencyAmount, uint payoutTokenAmount, uint remainingSupplyCurrency,  uint remainingRedeemToken);
103     function currency() public view returns (address);
104 }
105 
106 interface RestrictedTokenLike {
107     function hasMember(address) external view returns (bool);
108 }
109 
110 interface EIP2612PermitLike {
111     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
112 }
113 
114 interface DaiPermitLike {
115     function permit(address holder, address spender, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s) external;
116 }
117 
118 contract Operator is DSNote, Auth {
119     TrancheLike_2 public tranche;
120     RestrictedTokenLike public token;
121 
122     constructor(address tranche_) public {
123         wards[msg.sender] = 1;
124         tranche = TrancheLike_2(tranche_);
125     }
126 
127     /// sets the dependency to another contract
128     function depend(bytes32 contractName, address addr) public auth {
129         if (contractName == "tranche") { tranche = TrancheLike_2(addr); }
130         else if (contractName == "token") { token = RestrictedTokenLike(addr); }
131         else revert();
132     }
133 
134     /// only investors that are on the memberlist can submit supplyOrders
135     function supplyOrder(uint amount) public note {
136         require((token.hasMember(msg.sender) == true), "user-not-allowed-to-hold-token");
137         tranche.supplyOrder(msg.sender, amount);
138     }
139 
140     /// only investors that are on the memberlist can submit redeemOrders
141     function redeemOrder(uint amount) public note {
142         require((token.hasMember(msg.sender) == true), "user-not-allowed-to-hold-token");
143         token.hasMember(msg.sender);
144         tranche.redeemOrder(msg.sender, amount);
145     }
146 
147     /// only investors that are on the memberlist can disburse
148     function disburse() external
149         returns(uint payoutCurrencyAmount, uint payoutTokenAmount, uint remainingSupplyCurrency,  uint remainingRedeemToken)
150     {
151         require((token.hasMember(msg.sender) == true), "user-not-allowed-to-hold-token");
152         return tranche.disburse(msg.sender);
153     }
154 
155     function disburse(uint endEpoch) external
156         returns(uint payoutCurrencyAmount, uint payoutTokenAmount, uint remainingSupplyCurrency,  uint remainingRedeemToken)
157     {
158         require((token.hasMember(msg.sender) == true), "user-not-allowed-to-hold-token");
159         return tranche.disburse(msg.sender, endEpoch);
160     }
161 
162     // --- Permit Support ---
163     function supplyOrderWithDaiPermit(uint amount, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
164         DaiPermitLike(tranche.currency()).permit(msg.sender, address(tranche), nonce, expiry, true, v, r, s);
165         supplyOrder(amount);
166     }
167     function supplyOrderWithPermit(uint amount, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) public {
168         EIP2612PermitLike(tranche.currency()).permit(msg.sender, address(tranche), value, deadline, v, r, s);
169         supplyOrder(amount);
170     }
171     function redeemOrderWithPermit(uint amount, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) public {
172         EIP2612PermitLike(address(token)).permit(msg.sender, address(tranche), value, deadline, v, r, s);
173         redeemOrder(amount);
174     }
175 }
