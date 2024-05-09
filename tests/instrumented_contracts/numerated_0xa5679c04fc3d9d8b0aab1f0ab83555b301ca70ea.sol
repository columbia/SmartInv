1 /// cat.sol -- Dai liquidation module
2 
3 // Copyright (C) 2018 Rain <rainbreak@riseup.net>
4 //
5 // This program is free software: you can redistribute it and/or modify
6 // it under the terms of the GNU Affero General Public License as published by
7 // the Free Software Foundation, either version 3 of the License, or
8 // (at your option) any later version.
9 //
10 // This program is distributed in the hope that it will be useful,
11 // but WITHOUT ANY WARRANTY; without even the implied warranty of
12 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
13 // GNU Affero General Public License for more details.
14 //
15 // You should have received a copy of the GNU Affero General Public License
16 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
17 
18 pragma solidity >=0.5.12;
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
34             let mark := msize()                       // end of memory ensures zero
35             mstore(0x40, add(mark, 288))              // update free memory pointer
36             mstore(mark, 0x20)                        // bytes type data offset
37             mstore(add(mark, 0x20), 224)              // bytes size (padded)
38             calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
39             log4(mark, 288,                           // calldata
40                  shl(224, shr(224, calldataload(0))), // msg.sig
41                  caller(),                            // msg.sender
42                  calldataload(4),                     // arg1
43                  calldataload(36)                     // arg2
44                 )
45         }
46     }
47 }
48 
49 interface Kicker {
50     function kick(address urn, address gal, uint256 tab, uint256 lot, uint256 bid)
51         external returns (uint256);
52 }
53 
54 interface VatLike {
55     function ilks(bytes32) external view returns (
56         uint256 Art,  // [wad]
57         uint256 rate, // [ray]
58         uint256 spot, // [ray]
59         uint256 line, // [rad]
60         uint256 dust  // [rad]
61     );
62     function urns(bytes32,address) external view returns (
63         uint256 ink,  // [wad]
64         uint256 art   // [wad]
65     );
66     function grab(bytes32,address,address,address,int256,int256) external;
67     function hope(address) external;
68     function nope(address) external;
69 }
70 
71 interface VowLike {
72     function fess(uint256) external;
73 }
74 
75 contract Cat is LibNote {
76     // --- Auth ---
77     mapping (address => uint256) public wards;
78     function rely(address usr) external note auth { wards[usr] = 1; }
79     function deny(address usr) external note auth { wards[usr] = 0; }
80     modifier auth {
81         require(wards[msg.sender] == 1, "Cat/not-authorized");
82         _;
83     }
84 
85     // --- Data ---
86     struct Ilk {
87         address flip;  // Liquidator
88         uint256 chop;  // Liquidation Penalty  [wad]
89         uint256 dunk;  // Liquidation Quantity [rad]
90     }
91 
92     mapping (bytes32 => Ilk) public ilks;
93 
94     uint256 public live;   // Active Flag
95     VatLike public vat;    // CDP Engine
96     VowLike public vow;    // Debt Engine
97     uint256 public box;    // Max Dai out for liquidation        [rad]
98     uint256 public litter; // Balance of Dai out for liquidation [rad]
99 
100     // --- Events ---
101     event Bite(
102       bytes32 indexed ilk,
103       address indexed urn,
104       uint256 ink,
105       uint256 art,
106       uint256 tab,
107       address flip,
108       uint256 id
109     );
110 
111     // --- Init ---
112     constructor(address vat_) public {
113         wards[msg.sender] = 1;
114         vat = VatLike(vat_);
115         live = 1;
116     }
117 
118     // --- Math ---
119     uint256 constant WAD = 10 ** 18;
120 
121     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
122         if (x > y) { z = y; } else { z = x; }
123     }
124     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
125         require((z = x + y) >= x);
126     }
127     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
128         require((z = x - y) <= x);
129     }
130     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
131         require(y == 0 || (z = x * y) / y == x);
132     }
133 
134     // --- Administration ---
135     function file(bytes32 what, address data) external note auth {
136         if (what == "vow") vow = VowLike(data);
137         else revert("Cat/file-unrecognized-param");
138     }
139     function file(bytes32 what, uint256 data) external note auth {
140         if (what == "box") box = data;
141         else revert("Cat/file-unrecognized-param");
142     }
143     function file(bytes32 ilk, bytes32 what, uint256 data) external note auth {
144         if (what == "chop") ilks[ilk].chop = data;
145         else if (what == "dunk") ilks[ilk].dunk = data;
146         else revert("Cat/file-unrecognized-param");
147     }
148     function file(bytes32 ilk, bytes32 what, address flip) external note auth {
149         if (what == "flip") {
150             vat.nope(ilks[ilk].flip);
151             ilks[ilk].flip = flip;
152             vat.hope(flip);
153         }
154         else revert("Cat/file-unrecognized-param");
155     }
156 
157     // --- CDP Liquidation ---
158     function bite(bytes32 ilk, address urn) external returns (uint256 id) {
159         (,uint256 rate,uint256 spot,,uint256 dust) = vat.ilks(ilk);
160         (uint256 ink, uint256 art) = vat.urns(ilk, urn);
161 
162         require(live == 1, "Cat/not-live");
163         require(spot > 0 && mul(ink, spot) < mul(art, rate), "Cat/not-unsafe");
164 
165         Ilk memory milk = ilks[ilk];
166         uint256 dart;
167         {
168             uint256 room = sub(box, litter);
169 
170             // test whether the remaining space in the litterbox is dusty
171             require(litter < box && room >= dust, "Cat/liquidation-limit-hit");
172 
173             dart = min(art, mul(min(milk.dunk, room), WAD) / rate / milk.chop);
174         }
175 
176         uint256 dink = min(ink, mul(ink, dart) / art);
177 
178         require(dart >  0      && dink >  0     , "Cat/null-auction");
179         require(dart <= 2**255 && dink <= 2**255, "Cat/overflow"    );
180 
181         // This may leave the CDP in a dusty state
182         vat.grab(
183             ilk, urn, address(this), address(vow), -int256(dink), -int256(dart)
184         );
185         vow.fess(mul(dart, rate));
186 
187         { // Avoid stack too deep
188             // This calcuation will overflow if dart*rate exceeds ~10^14,
189             // i.e. the maximum dunk is roughly 100 trillion DAI.
190             uint256 tab = mul(mul(dart, rate), milk.chop) / WAD;
191             litter = add(litter, tab);
192 
193             id = Kicker(milk.flip).kick({
194                 urn: urn,
195                 gal: address(vow),
196                 tab: tab,
197                 lot: dink,
198                 bid: 0
199             });
200         }
201 
202         emit Bite(ilk, urn, dink, dart, mul(dart, rate), milk.flip, id);
203     }
204 
205     function claw(uint256 rad) external note auth {
206         litter = sub(litter, rad);
207     }
208 
209     function cage() external note auth {
210         live = 0;
211     }
212 }