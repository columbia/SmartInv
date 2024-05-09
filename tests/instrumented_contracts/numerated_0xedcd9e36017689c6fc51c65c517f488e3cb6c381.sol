1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of src/lender/operator.sol
4 pragma solidity >=0.4.23 >=0.5.15 <0.6.0;
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
21 
22 /* pragma solidity >=0.4.23; */
23 
24 contract DSNote {
25     event LogNote(
26         bytes4   indexed  sig,
27         address  indexed  guy,
28         bytes32  indexed  foo,
29         bytes32  indexed  bar,
30         uint256           wad,
31         bytes             fax
32     ) anonymous;
33 
34     modifier note {
35         bytes32 foo;
36         bytes32 bar;
37         uint256 wad;
38 
39         assembly {
40             foo := calldataload(4)
41             bar := calldataload(36)
42             wad := callvalue()
43         }
44 
45         _;
46 
47         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
48     }
49 }
50 
51 ////// lib/tinlake-auth/src/auth.sol
52 // Copyright (C) Centrifuge 2020, based on MakerDAO dss https://github.com/makerdao/dss
53 //
54 // This program is free software: you can redistribute it and/or modify
55 // it under the terms of the GNU Affero General Public License as published by
56 // the Free Software Foundation, either version 3 of the License, or
57 // (at your option) any later version.
58 //
59 // This program is distributed in the hope that it will be useful,
60 // but WITHOUT ANY WARRANTY; without even the implied warranty of
61 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
62 // GNU Affero General Public License for more details.
63 //
64 // You should have received a copy of the GNU Affero General Public License
65 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
66 
67 /* pragma solidity >=0.5.15 <0.6.0; */
68 
69 /* import "ds-note/note.sol"; */
70 
71 contract Auth is DSNote {
72     mapping (address => uint) public wards;
73     function rely(address usr) public auth note { wards[usr] = 1; }
74     function deny(address usr) public auth note { wards[usr] = 0; }
75     modifier auth { require(wards[msg.sender] == 1); _; }
76 }
77 
78 ////// src/lender/operator.sol
79 // Copyright (C) 2020 Centrifuge
80 //
81 // This program is free software: you can redistribute it and/or modify
82 // it under the terms of the GNU Affero General Public License as published by
83 // the Free Software Foundation, either version 3 of the License, or
84 // (at your option) any later version.
85 //
86 // This program is distributed in the hope that it will be useful,
87 // but WITHOUT ANY WARRANTY; without even the implied warranty of
88 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
89 // GNU Affero General Public License for more details.
90 //
91 // You should have received a copy of the GNU Affero General Public License
92 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
93 
94 /* pragma solidity >=0.5.15 <0.6.0; */
95 
96 /* import "ds-note/note.sol"; */
97 /* import "tinlake-auth/auth.sol"; */
98 
99 contract TrancheLike_3 {
100     function supplyOrder(address usr, uint currencyAmount) public;
101     function redeemOrder(address usr, uint tokenAmount) public;
102     function disburse(address usr) public returns (uint payoutCurrencyAmount, uint payoutTokenAmount, uint remainingSupplyCurrency,  uint remainingRedeemToken);
103     function disburse(address usr, uint endEpoch) public returns (uint payoutCurrencyAmount, uint payoutTokenAmount, uint remainingSupplyCurrency,  uint remainingRedeemToken);
104     function currency() public view returns (address);
105 }
106 
107 interface RestrictedTokenLike {
108     function hasMember(address) external view returns (bool);
109 }
110 
111 interface EIP2612PermitLike {
112     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
113 }
114 
115 interface DaiPermitLike {
116     function permit(address holder, address spender, uint256 nonce, uint256 expiry, bool allowed, uint8 v, bytes32 r, bytes32 s) external;
117 }
118 
119 contract Operator is DSNote, Auth {
120     TrancheLike_3 public tranche;
121     RestrictedTokenLike public token;
122 
123     constructor(address tranche_) public {
124         wards[msg.sender] = 1;
125         tranche = TrancheLike_3(tranche_);
126     }
127 
128     /// sets the dependency to another contract
129     function depend(bytes32 contractName, address addr) public auth {
130         if (contractName == "tranche") { tranche = TrancheLike_3(addr); }
131         else if (contractName == "token") { token = RestrictedTokenLike(addr); }
132         else revert();
133     }
134 
135     /// only investors that are on the memberlist can submit supplyOrders
136     function supplyOrder(uint amount) public note {
137         require((token.hasMember(msg.sender) == true), "user-not-allowed-to-hold-token");
138         tranche.supplyOrder(msg.sender, amount);
139     }
140 
141     /// only investors that are on the memberlist can submit redeemOrders
142     function redeemOrder(uint amount) public note {
143         require((token.hasMember(msg.sender) == true), "user-not-allowed-to-hold-token");
144         token.hasMember(msg.sender);
145         tranche.redeemOrder(msg.sender, amount);
146     }
147 
148     /// only investors that are on the memberlist can disburse
149     function disburse() external
150         returns(uint payoutCurrencyAmount, uint payoutTokenAmount, uint remainingSupplyCurrency,  uint remainingRedeemToken)
151     {
152         require((token.hasMember(msg.sender) == true), "user-not-allowed-to-hold-token");
153         return tranche.disburse(msg.sender);
154     }
155 
156     function disburse(uint endEpoch) external
157         returns(uint payoutCurrencyAmount, uint payoutTokenAmount, uint remainingSupplyCurrency,  uint remainingRedeemToken)
158     {
159         require((token.hasMember(msg.sender) == true), "user-not-allowed-to-hold-token");
160         return tranche.disburse(msg.sender, endEpoch);
161     }
162 
163     // --- Permit Support ---
164     function supplyOrderWithDaiPermit(uint amount, uint nonce, uint expiry, uint8 v, bytes32 r, bytes32 s) public {
165         DaiPermitLike(tranche.currency()).permit(msg.sender, address(tranche), nonce, expiry, true, v, r, s);
166         supplyOrder(amount);
167     }
168     function supplyOrderWithPermit(uint amount, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) public {
169         EIP2612PermitLike(tranche.currency()).permit(msg.sender, address(tranche), value, deadline, v, r, s);
170         supplyOrder(amount);
171     }
172     function redeemOrderWithPermit(uint amount, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) public {
173         EIP2612PermitLike(address(token)).permit(msg.sender, address(tranche), value, deadline, v, r, s);
174         redeemOrder(amount);
175     }
176 }
