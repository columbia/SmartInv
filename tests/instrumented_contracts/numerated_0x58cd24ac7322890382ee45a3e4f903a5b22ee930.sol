1 /// flip.sol -- Collateral auction
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
49 interface VatLike {
50     function move(address,address,uint256) external;
51     function flux(bytes32,address,address,uint256) external;
52 }
53 
54 interface CatLike {
55     function claw(uint256) external;
56 }
57 
58 /*
59    This thing lets you flip some gems for a given amount of dai.
60    Once the given amount of dai is raised, gems are forgone instead.
61 
62  - `lot` gems in return for bid
63  - `tab` total dai wanted
64  - `bid` dai paid
65  - `gal` receives dai income
66  - `usr` receives gem forgone
67  - `ttl` single bid lifetime
68  - `beg` minimum bid increase
69  - `end` max auction duration
70 */
71 
72 contract Flipper is LibNote {
73     // --- Auth ---
74     mapping (address => uint256) public wards;
75     function rely(address usr) external note auth { wards[usr] = 1; }
76     function deny(address usr) external note auth { wards[usr] = 0; }
77     modifier auth {
78         require(wards[msg.sender] == 1, "Flipper/not-authorized");
79         _;
80     }
81 
82     // --- Data ---
83     struct Bid {
84         uint256 bid;  // dai paid                 [rad]
85         uint256 lot;  // gems in return for bid   [wad]
86         address guy;  // high bidder
87         uint48  tic;  // bid expiry time          [unix epoch time]
88         uint48  end;  // auction expiry time      [unix epoch time]
89         address usr;
90         address gal;
91         uint256 tab;  // total dai wanted         [rad]
92     }
93 
94     mapping (uint256 => Bid) public bids;
95 
96     VatLike public   vat;            // CDP Engine
97     bytes32 public   ilk;            // collateral type
98 
99     uint256 constant ONE = 1.00E18;
100     uint256 public   beg = 1.05E18;  // 5% minimum bid increase
101     uint48  public   ttl = 3 hours;  // 3 hours bid duration         [seconds]
102     uint48  public   tau = 2 days;   // 2 days total auction length  [seconds]
103     uint256 public kicks = 0;
104     CatLike public   cat;            // cat liquidation module
105 
106     // --- Events ---
107     event Kick(
108       uint256 id,
109       uint256 lot,
110       uint256 bid,
111       uint256 tab,
112       address indexed usr,
113       address indexed gal
114     );
115 
116     // --- Init ---
117     constructor(address vat_, address cat_, bytes32 ilk_) public {
118         vat = VatLike(vat_);
119         cat = CatLike(cat_);
120         ilk = ilk_;
121         wards[msg.sender] = 1;
122     }
123 
124     // --- Math ---
125     function add(uint48 x, uint48 y) internal pure returns (uint48 z) {
126         require((z = x + y) >= x);
127     }
128     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
129         require(y == 0 || (z = x * y) / y == x);
130     }
131 
132     // --- Admin ---
133     function file(bytes32 what, uint256 data) external note auth {
134         if (what == "beg") beg = data;
135         else if (what == "ttl") ttl = uint48(data);
136         else if (what == "tau") tau = uint48(data);
137         else revert("Flipper/file-unrecognized-param");
138     }
139     function file(bytes32 what, address data) external note auth {
140         if (what == "cat") cat = CatLike(data);
141         else revert("Flipper/file-unrecognized-param");
142     }
143 
144     // --- Auction ---
145     function kick(address usr, address gal, uint256 tab, uint256 lot, uint256 bid)
146         public auth returns (uint256 id)
147     {
148         require(kicks < uint256(-1), "Flipper/overflow");
149         id = ++kicks;
150 
151         bids[id].bid = bid;
152         bids[id].lot = lot;
153         bids[id].guy = msg.sender;  // configurable??
154         bids[id].end = add(uint48(now), tau);
155         bids[id].usr = usr;
156         bids[id].gal = gal;
157         bids[id].tab = tab;
158 
159         vat.flux(ilk, msg.sender, address(this), lot);
160 
161         emit Kick(id, lot, bid, tab, usr, gal);
162     }
163     function tick(uint256 id) external note {
164         require(bids[id].end < now, "Flipper/not-finished");
165         require(bids[id].tic == 0, "Flipper/bid-already-placed");
166         bids[id].end = add(uint48(now), tau);
167     }
168     function tend(uint256 id, uint256 lot, uint256 bid) external note {
169         require(bids[id].guy != address(0), "Flipper/guy-not-set");
170         require(bids[id].tic > now || bids[id].tic == 0, "Flipper/already-finished-tic");
171         require(bids[id].end > now, "Flipper/already-finished-end");
172 
173         require(lot == bids[id].lot, "Flipper/lot-not-matching");
174         require(bid <= bids[id].tab, "Flipper/higher-than-tab");
175         require(bid >  bids[id].bid, "Flipper/bid-not-higher");
176         require(mul(bid, ONE) >= mul(beg, bids[id].bid) || bid == bids[id].tab, "Flipper/insufficient-increase");
177 
178         if (msg.sender != bids[id].guy) {
179             vat.move(msg.sender, bids[id].guy, bids[id].bid);
180             bids[id].guy = msg.sender;
181         }
182         vat.move(msg.sender, bids[id].gal, bid - bids[id].bid);
183 
184         bids[id].bid = bid;
185         bids[id].tic = add(uint48(now), ttl);
186     }
187     function dent(uint256 id, uint256 lot, uint256 bid) external note {
188         require(bids[id].guy != address(0), "Flipper/guy-not-set");
189         require(bids[id].tic > now || bids[id].tic == 0, "Flipper/already-finished-tic");
190         require(bids[id].end > now, "Flipper/already-finished-end");
191 
192         require(bid == bids[id].bid, "Flipper/not-matching-bid");
193         require(bid == bids[id].tab, "Flipper/tend-not-finished");
194         require(lot < bids[id].lot, "Flipper/lot-not-lower");
195         require(mul(beg, lot) <= mul(bids[id].lot, ONE), "Flipper/insufficient-decrease");
196 
197         if (msg.sender != bids[id].guy) {
198             vat.move(msg.sender, bids[id].guy, bid);
199             bids[id].guy = msg.sender;
200         }
201         vat.flux(ilk, address(this), bids[id].usr, bids[id].lot - lot);
202 
203         bids[id].lot = lot;
204         bids[id].tic = add(uint48(now), ttl);
205     }
206     function deal(uint256 id) external note {
207         require(bids[id].tic != 0 && (bids[id].tic < now || bids[id].end < now), "Flipper/not-finished");
208         cat.claw(bids[id].tab);
209         vat.flux(ilk, address(this), bids[id].guy, bids[id].lot);
210         delete bids[id];
211     }
212 
213     function yank(uint256 id) external note auth {
214         require(bids[id].guy != address(0), "Flipper/guy-not-set");
215         require(bids[id].bid < bids[id].tab, "Flipper/already-dent-phase");
216         cat.claw(bids[id].tab);
217         vat.flux(ilk, address(this), msg.sender, bids[id].lot);
218         vat.move(msg.sender, bids[id].guy, bids[id].bid);
219         delete bids[id];
220     }
221 }