1 // hevm: flattened sources of /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/join.sol
2 pragma solidity =0.5.12;
3 
4 ////// /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/lib.sol
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU General Public License for more details.
14 
15 // You should have received a copy of the GNU General Public License
16 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
17 
18 /* pragma solidity 0.5.12; */
19 
20 contract LibNote {
21     event LogNote(
22         bytes4   indexed  sig,
23         address  indexed  usr,
24         bytes32  indexed  arg1,
25         bytes32  indexed  arg2,
26         bytes             data
27     ) anonymous;
28 
29     modifier note {
30         _;
31         assembly {
32             // log an 'anonymous' event with a constant 6 words of calldata
33             // and four indexed topics: selector, caller, arg1 and arg2
34             let mark := msize                         // end of memory ensures zero
35             mstore(0x40, add(mark, 288))              // update free memory pointer
36             mstore(mark, 0x20)                        // bytes type data offset
37             mstore(add(mark, 0x20), 224)              // bytes size (padded)
38             calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
39             log4(mark, 288,                           // calldata
40                  shl(224, shr(224, calldataload(0))), // msg.sig
41                  caller,                              // msg.sender
42                  calldataload(4),                     // arg1
43                  calldataload(36)                     // arg2
44                 )
45         }
46     }
47 }
48 
49 ////// /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/join.sol
50 /// join.sol -- Basic token adapters
51 
52 // Copyright (C) 2018 Rain <rainbreak@riseup.net>
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
67 /* pragma solidity 0.5.12; */
68 
69 /* import "./lib.sol"; */
70 
71 contract GemLike {
72     function decimals() public view returns (uint);
73     function transfer(address,uint) external returns (bool);
74     function transferFrom(address,address,uint) external returns (bool);
75 }
76 
77 contract DSTokenLike {
78     function mint(address,uint) external;
79     function burn(address,uint) external;
80 }
81 
82 contract VatLike {
83     function slip(bytes32,address,int) external;
84     function move(address,address,uint) external;
85 }
86 
87 /*
88     Here we provide *adapters* to connect the Vat to arbitrary external
89     token implementations, creating a bounded context for the Vat. The
90     adapters here are provided as working examples:
91 
92       - `GemJoin`: For well behaved ERC20 tokens, with simple transfer
93                    semantics.
94 
95       - `ETHJoin`: For native Ether.
96 
97       - `DaiJoin`: For connecting internal Dai balances to an external
98                    `DSToken` implementation.
99 
100     In practice, adapter implementations will be varied and specific to
101     individual collateral types, accounting for different transfer
102     semantics and token standards.
103 
104     Adapters need to implement two basic methods:
105 
106       - `join`: enter collateral into the system
107       - `exit`: remove collateral from the system
108 
109 */
110 
111 contract GemJoin is LibNote {
112     // --- Auth ---
113     mapping (address => uint) public wards;
114     function rely(address usr) external note auth { wards[usr] = 1; }
115     function deny(address usr) external note auth { wards[usr] = 0; }
116     modifier auth {
117         require(wards[msg.sender] == 1, "GemJoin/not-authorized");
118         _;
119     }
120 
121     VatLike public vat;
122     bytes32 public ilk;
123     GemLike public gem;
124     uint    public dec;
125     uint    public live;  // Access Flag
126 
127     constructor(address vat_, bytes32 ilk_, address gem_) public {
128         wards[msg.sender] = 1;
129         live = 1;
130         vat = VatLike(vat_);
131         ilk = ilk_;
132         gem = GemLike(gem_);
133         dec = gem.decimals();
134     }
135     function cage() external note auth {
136         live = 0;
137     }
138     function join(address usr, uint wad) external note {
139         require(live == 1, "GemJoin/not-live");
140         require(int(wad) >= 0, "GemJoin/overflow");
141         vat.slip(ilk, usr, int(wad));
142         require(gem.transferFrom(msg.sender, address(this), wad), "GemJoin/failed-transfer");
143     }
144     function exit(address usr, uint wad) external note {
145         require(wad <= 2 ** 255, "GemJoin/overflow");
146         vat.slip(ilk, msg.sender, -int(wad));
147         require(gem.transfer(usr, wad), "GemJoin/failed-transfer");
148     }
149 }
150 
151 contract ETHJoin is LibNote {
152     // --- Auth ---
153     mapping (address => uint) public wards;
154     function rely(address usr) external note auth { wards[usr] = 1; }
155     function deny(address usr) external note auth { wards[usr] = 0; }
156     modifier auth {
157         require(wards[msg.sender] == 1, "ETHJoin/not-authorized");
158         _;
159     }
160 
161     VatLike public vat;
162     bytes32 public ilk;
163     uint    public live;  // Access Flag
164 
165     constructor(address vat_, bytes32 ilk_) public {
166         wards[msg.sender] = 1;
167         live = 1;
168         vat = VatLike(vat_);
169         ilk = ilk_;
170     }
171     function cage() external note auth {
172         live = 0;
173     }
174     function join(address usr) external payable note {
175         require(live == 1, "ETHJoin/not-live");
176         require(int(msg.value) >= 0, "ETHJoin/overflow");
177         vat.slip(ilk, usr, int(msg.value));
178     }
179     function exit(address payable usr, uint wad) external note {
180         require(int(wad) >= 0, "ETHJoin/overflow");
181         vat.slip(ilk, msg.sender, -int(wad));
182         usr.transfer(wad);
183     }
184 }
185 
186 contract DaiJoin is LibNote {
187     // --- Auth ---
188     mapping (address => uint) public wards;
189     function rely(address usr) external note auth { wards[usr] = 1; }
190     function deny(address usr) external note auth { wards[usr] = 0; }
191     modifier auth {
192         require(wards[msg.sender] == 1, "DaiJoin/not-authorized");
193         _;
194     }
195 
196     VatLike public vat;
197     DSTokenLike public dai;
198     uint    public live;  // Access Flag
199 
200     constructor(address vat_, address dai_) public {
201         wards[msg.sender] = 1;
202         live = 1;
203         vat = VatLike(vat_);
204         dai = DSTokenLike(dai_);
205     }
206     function cage() external note auth {
207         live = 0;
208     }
209     uint constant ONE = 10 ** 27;
210     function mul(uint x, uint y) internal pure returns (uint z) {
211         require(y == 0 || (z = x * y) / y == x);
212     }
213     function join(address usr, uint wad) external note {
214         vat.move(address(this), usr, mul(ONE, wad));
215         dai.burn(msg.sender, wad);
216     }
217     function exit(address usr, uint wad) external note {
218         require(live == 1, "DaiJoin/not-live");
219         vat.move(msg.sender, address(this), mul(ONE, wad));
220         dai.mint(usr, wad);
221     }
222 }