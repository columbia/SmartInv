1 // hevm: flattened sources of /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/flip.sol
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
49 ////// /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/flip.sol
50 /// flip.sol -- Collateral auction
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
71 contract VatLike {
72     function move(address,address,uint) external;
73     function flux(bytes32,address,address,uint) external;
74 }
75 
76 /*
77    This thing lets you flip some gems for a given amount of dai.
78    Once the given amount of dai is raised, gems are forgone instead.
79 
80  - `lot` gems for sale
81  - `tab` total dai wanted
82  - `bid` dai paid
83  - `gal` receives dai income
84  - `usr` receives gem forgone
85  - `ttl` single bid lifetime
86  - `beg` minimum bid increase
87  - `end` max auction duration
88 */
89 
90 contract Flipper is LibNote {
91     // --- Auth ---
92     mapping (address => uint) public wards;
93     function rely(address usr) external note auth { wards[usr] = 1; }
94     function deny(address usr) external note auth { wards[usr] = 0; }
95     modifier auth {
96         require(wards[msg.sender] == 1, "Flipper/not-authorized");
97         _;
98     }
99 
100     // --- Data ---
101     struct Bid {
102         uint256 bid;
103         uint256 lot;
104         address guy;  // high bidder
105         uint48  tic;  // expiry time
106         uint48  end;
107         address usr;
108         address gal;
109         uint256 tab;
110     }
111 
112     mapping (uint => Bid) public bids;
113 
114     VatLike public   vat;
115     bytes32 public   ilk;
116 
117     uint256 constant ONE = 1.00E18;
118     uint256 public   beg = 1.05E18;  // 5% minimum bid increase
119     uint48  public   ttl = 3 hours;  // 3 hours bid duration
120     uint48  public   tau = 2 days;   // 2 days total auction length
121     uint256 public kicks = 0;
122 
123     // --- Events ---
124     event Kick(
125       uint256 id,
126       uint256 lot,
127       uint256 bid,
128       uint256 tab,
129       address indexed usr,
130       address indexed gal
131     );
132 
133     // --- Init ---
134     constructor(address vat_, bytes32 ilk_) public {
135         vat = VatLike(vat_);
136         ilk = ilk_;
137         wards[msg.sender] = 1;
138     }
139 
140     // --- Math ---
141     function add(uint48 x, uint48 y) internal pure returns (uint48 z) {
142         require((z = x + y) >= x);
143     }
144     function mul(uint x, uint y) internal pure returns (uint z) {
145         require(y == 0 || (z = x * y) / y == x);
146     }
147 
148     // --- Admin ---
149     function file(bytes32 what, uint data) external note auth {
150         if (what == "beg") beg = data;
151         else if (what == "ttl") ttl = uint48(data);
152         else if (what == "tau") tau = uint48(data);
153         else revert("Flipper/file-unrecognized-param");
154     }
155 
156     // --- Auction ---
157     function kick(address usr, address gal, uint tab, uint lot, uint bid)
158         public auth returns (uint id)
159     {
160         require(kicks < uint(-1), "Flipper/overflow");
161         id = ++kicks;
162 
163         bids[id].bid = bid;
164         bids[id].lot = lot;
165         bids[id].guy = msg.sender; // configurable??
166         bids[id].end = add(uint48(now), tau);
167         bids[id].usr = usr;
168         bids[id].gal = gal;
169         bids[id].tab = tab;
170 
171         vat.flux(ilk, msg.sender, address(this), lot);
172 
173         emit Kick(id, lot, bid, tab, usr, gal);
174     }
175     function tick(uint id) external note {
176         require(bids[id].end < now, "Flipper/not-finished");
177         require(bids[id].tic == 0, "Flipper/bid-already-placed");
178         bids[id].end = add(uint48(now), tau);
179     }
180     function tend(uint id, uint lot, uint bid) external note {
181         require(bids[id].guy != address(0), "Flipper/guy-not-set");
182         require(bids[id].tic > now || bids[id].tic == 0, "Flipper/already-finished-tic");
183         require(bids[id].end > now, "Flipper/already-finished-end");
184 
185         require(lot == bids[id].lot, "Flipper/lot-not-matching");
186         require(bid <= bids[id].tab, "Flipper/higher-than-tab");
187         require(bid >  bids[id].bid, "Flipper/bid-not-higher");
188         require(mul(bid, ONE) >= mul(beg, bids[id].bid) || bid == bids[id].tab, "Flipper/insufficient-increase");
189 
190         vat.move(msg.sender, bids[id].guy, bids[id].bid);
191         vat.move(msg.sender, bids[id].gal, bid - bids[id].bid);
192 
193         bids[id].guy = msg.sender;
194         bids[id].bid = bid;
195         bids[id].tic = add(uint48(now), ttl);
196     }
197     function dent(uint id, uint lot, uint bid) external note {
198         require(bids[id].guy != address(0), "Flipper/guy-not-set");
199         require(bids[id].tic > now || bids[id].tic == 0, "Flipper/already-finished-tic");
200         require(bids[id].end > now, "Flipper/already-finished-end");
201 
202         require(bid == bids[id].bid, "Flipper/not-matching-bid");
203         require(bid == bids[id].tab, "Flipper/tend-not-finished");
204         require(lot < bids[id].lot, "Flipper/lot-not-lower");
205         require(mul(beg, lot) <= mul(bids[id].lot, ONE), "Flipper/insufficient-decrease");
206 
207         vat.move(msg.sender, bids[id].guy, bid);
208         vat.flux(ilk, address(this), bids[id].usr, bids[id].lot - lot);
209 
210         bids[id].guy = msg.sender;
211         bids[id].lot = lot;
212         bids[id].tic = add(uint48(now), ttl);
213     }
214     function deal(uint id) external note {
215         require(bids[id].tic != 0 && (bids[id].tic < now || bids[id].end < now), "Flipper/not-finished");
216         vat.flux(ilk, address(this), bids[id].guy, bids[id].lot);
217         delete bids[id];
218     }
219 
220     function yank(uint id) external note auth {
221         require(bids[id].guy != address(0), "Flipper/guy-not-set");
222         require(bids[id].bid < bids[id].tab, "Flipper/already-dent-phase");
223         vat.flux(ilk, address(this), msg.sender, bids[id].lot);
224         vat.move(msg.sender, bids[id].guy, bids[id].bid);
225         delete bids[id];
226     }
227 }