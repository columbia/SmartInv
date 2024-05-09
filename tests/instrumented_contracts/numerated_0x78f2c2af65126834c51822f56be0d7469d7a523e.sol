1 // hevm: flattened sources of /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/cat.sol
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
49 ////// /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/cat.sol
50 /// cat.sol -- Dai liquidation module
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
71 contract Kicker {
72     function kick(address urn, address gal, uint tab, uint lot, uint bid)
73         public returns (uint);
74 }
75 
76 contract VatLike {
77     function ilks(bytes32) external view returns (
78         uint256 Art,   // wad
79         uint256 rate,  // ray
80         uint256 spot   // ray
81     );
82     function urns(bytes32,address) external view returns (
83         uint256 ink,   // wad
84         uint256 art    // wad
85     );
86     function grab(bytes32,address,address,address,int,int) external;
87     function hope(address) external;
88     function nope(address) external;
89 }
90 
91 contract VowLike {
92     function fess(uint) external;
93 }
94 
95 contract Cat is LibNote {
96     // --- Auth ---
97     mapping (address => uint) public wards;
98     function rely(address usr) external note auth { wards[usr] = 1; }
99     function deny(address usr) external note auth { wards[usr] = 0; }
100     modifier auth {
101         require(wards[msg.sender] == 1, "Cat/not-authorized");
102         _;
103     }
104 
105     // --- Data ---
106     struct Ilk {
107         address flip;  // Liquidator
108         uint256 chop;  // Liquidation Penalty   [ray]
109         uint256 lump;  // Liquidation Quantity  [wad]
110     }
111 
112     mapping (bytes32 => Ilk) public ilks;
113 
114     uint256 public live;
115     VatLike public vat;
116     VowLike public vow;
117 
118     // --- Events ---
119     event Bite(
120       bytes32 indexed ilk,
121       address indexed urn,
122       uint256 ink,
123       uint256 art,
124       uint256 tab,
125       address flip,
126       uint256 id
127     );
128 
129     // --- Init ---
130     constructor(address vat_) public {
131         wards[msg.sender] = 1;
132         vat = VatLike(vat_);
133         live = 1;
134     }
135 
136     // --- Math ---
137     uint constant ONE = 10 ** 27;
138 
139     function mul(uint x, uint y) internal pure returns (uint z) {
140         require(y == 0 || (z = x * y) / y == x);
141     }
142     function rmul(uint x, uint y) internal pure returns (uint z) {
143         z = mul(x, y) / ONE;
144     }
145     function min(uint x, uint y) internal pure returns (uint z) {
146         if (x > y) { z = y; } else { z = x; }
147     }
148 
149     // --- Administration ---
150     function file(bytes32 what, address data) external note auth {
151         if (what == "vow") vow = VowLike(data);
152         else revert("Cat/file-unrecognized-param");
153     }
154     function file(bytes32 ilk, bytes32 what, uint data) external note auth {
155         if (what == "chop") ilks[ilk].chop = data;
156         else if (what == "lump") ilks[ilk].lump = data;
157         else revert("Cat/file-unrecognized-param");
158     }
159     function file(bytes32 ilk, bytes32 what, address flip) external note auth {
160         if (what == "flip") {
161             vat.nope(ilks[ilk].flip);
162             ilks[ilk].flip = flip;
163             vat.hope(flip);
164         }
165         else revert("Cat/file-unrecognized-param");
166     }
167 
168     // --- CDP Liquidation ---
169     function bite(bytes32 ilk, address urn) external returns (uint id) {
170         (, uint rate, uint spot) = vat.ilks(ilk);
171         (uint ink, uint art) = vat.urns(ilk, urn);
172 
173         require(live == 1, "Cat/not-live");
174         require(spot > 0 && mul(ink, spot) < mul(art, rate), "Cat/not-unsafe");
175 
176         uint lot = min(ink, ilks[ilk].lump);
177         art      = min(art, mul(lot, art) / ink);
178 
179         require(lot <= 2**255 && art <= 2**255, "Cat/overflow");
180         vat.grab(ilk, urn, address(this), address(vow), -int(lot), -int(art));
181 
182         vow.fess(mul(art, rate));
183         id = Kicker(ilks[ilk].flip).kick({ urn: urn
184                                          , gal: address(vow)
185                                          , tab: rmul(mul(art, rate), ilks[ilk].chop)
186                                          , lot: lot
187                                          , bid: 0
188                                          });
189 
190         emit Bite(ilk, urn, lot, art, mul(art, rate), ilks[ilk].flip, id);
191     }
192 
193     function cage() external note auth {
194         live = 0;
195     }
196 }