1 // hevm: flattened sources of /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/vow.sol
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
49 ////// /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/vow.sol
50 /// vow.sol -- Dai settlement module
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
71 contract FlopLike {
72     function kick(address gal, uint lot, uint bid) external returns (uint);
73     function cage() external;
74     function live() external returns (uint);
75 }
76 
77 contract FlapLike {
78     function kick(uint lot, uint bid) external returns (uint);
79     function cage(uint) external;
80     function live() external returns (uint);
81 }
82 
83 contract VatLike {
84     function dai (address) external view returns (uint);
85     function sin (address) external view returns (uint);
86     function heal(uint256) external;
87     function hope(address) external;
88     function nope(address) external;
89 }
90 
91 contract Vow is LibNote {
92     // --- Auth ---
93     mapping (address => uint) public wards;
94     function rely(address usr) external note auth { require(live == 1, "Vow/not-live"); wards[usr] = 1; }
95     function deny(address usr) external note auth { wards[usr] = 0; }
96     modifier auth {
97         require(wards[msg.sender] == 1, "Vow/not-authorized");
98         _;
99     }
100 
101     // --- Data ---
102     VatLike public vat;
103     FlapLike public flapper;
104     FlopLike public flopper;
105 
106     mapping (uint256 => uint256) public sin; // debt queue
107     uint256 public Sin;   // queued debt          [rad]
108     uint256 public Ash;   // on-auction debt      [rad]
109 
110     uint256 public wait;  // flop delay
111     uint256 public dump;  // flop initial lot size  [wad]
112     uint256 public sump;  // flop fixed bid size    [rad]
113 
114     uint256 public bump;  // flap fixed lot size    [rad]
115     uint256 public hump;  // surplus buffer       [rad]
116 
117     uint256 public live;
118 
119     // --- Init ---
120     constructor(address vat_, address flapper_, address flopper_) public {
121         wards[msg.sender] = 1;
122         vat     = VatLike(vat_);
123         flapper = FlapLike(flapper_);
124         flopper = FlopLike(flopper_);
125         vat.hope(flapper_);
126         live = 1;
127     }
128 
129     // --- Math ---
130     function add(uint x, uint y) internal pure returns (uint z) {
131         require((z = x + y) >= x);
132     }
133     function sub(uint x, uint y) internal pure returns (uint z) {
134         require((z = x - y) <= x);
135     }
136     function min(uint x, uint y) internal pure returns (uint z) {
137         return x <= y ? x : y;
138     }
139 
140     // --- Administration ---
141     function file(bytes32 what, uint data) external note auth {
142         if (what == "wait") wait = data;
143         else if (what == "bump") bump = data;
144         else if (what == "sump") sump = data;
145         else if (what == "dump") dump = data;
146         else if (what == "hump") hump = data;
147         else revert("Vow/file-unrecognized-param");
148     }
149 
150     function file(bytes32 what, address data) external note auth {
151         if (what == "flapper") {
152             vat.nope(address(flapper));
153             flapper = FlapLike(data);
154             vat.hope(data);
155         }
156         else if (what == "flopper") flopper = FlopLike(data);
157         else revert("Vow/file-unrecognized-param");
158     }
159 
160     // Push to debt-queue
161     function fess(uint tab) external note auth {
162         sin[now] = add(sin[now], tab);
163         Sin = add(Sin, tab);
164     }
165     // Pop from debt-queue
166     function flog(uint era) external note {
167         require(add(era, wait) <= now, "Vow/wait-not-finished");
168         Sin = sub(Sin, sin[era]);
169         sin[era] = 0;
170     }
171 
172     // Debt settlement
173     function heal(uint rad) external note {
174         require(rad <= vat.dai(address(this)), "Vow/insufficient-surplus");
175         require(rad <= sub(sub(vat.sin(address(this)), Sin), Ash), "Vow/insufficient-debt");
176         vat.heal(rad);
177     }
178     function kiss(uint rad) external note {
179         require(rad <= Ash, "Vow/not-enough-ash");
180         require(rad <= vat.dai(address(this)), "Vow/insufficient-surplus");
181         Ash = sub(Ash, rad);
182         vat.heal(rad);
183     }
184 
185     // Debt auction
186     function flop() external note returns (uint id) {
187         require(sump <= sub(sub(vat.sin(address(this)), Sin), Ash), "Vow/insufficient-debt");
188         require(vat.dai(address(this)) == 0, "Vow/surplus-not-zero");
189         Ash = add(Ash, sump);
190         id = flopper.kick(address(this), dump, sump);
191     }
192     // Surplus auction
193     function flap() external note returns (uint id) {
194         require(vat.dai(address(this)) >= add(add(vat.sin(address(this)), bump), hump), "Vow/insufficient-surplus");
195         require(sub(sub(vat.sin(address(this)), Sin), Ash) == 0, "Vow/debt-not-zero");
196         id = flapper.kick(bump, 0);
197     }
198 
199     function cage() external note auth {
200         require(live == 1, "Vow/not-live");
201         live = 0;
202         Sin = 0;
203         Ash = 0;
204         flapper.cage(vat.dai(address(flapper)));
205         flopper.cage();
206         vat.heal(min(vat.dai(address(this)), vat.sin(address(this))));
207     }
208 }