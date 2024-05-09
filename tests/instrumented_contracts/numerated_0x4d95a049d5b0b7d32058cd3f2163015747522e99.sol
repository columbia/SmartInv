1 /**
2  *Submitted for verification at Etherscan.io on 2019-11-14
3 */
4 
5 // hevm: flattened sources of /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/flop.sol
6 pragma solidity =0.5.12;
7 
8 ////// /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/lib.sol
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
22 /* pragma solidity 0.5.12; */
23 
24 contract LibNote {
25     event LogNote(
26         bytes4   indexed  sig,
27         address  indexed  usr,
28         bytes32  indexed  arg1,
29         bytes32  indexed  arg2,
30         bytes             data
31     ) anonymous;
32 
33     modifier note {
34         _;
35         assembly {
36             // log an 'anonymous' event with a constant 6 words of calldata
37             // and four indexed topics: selector, caller, arg1 and arg2
38             let mark := msize                         // end of memory ensures zero
39             mstore(0x40, add(mark, 288))              // update free memory pointer
40             mstore(mark, 0x20)                        // bytes type data offset
41             mstore(add(mark, 0x20), 224)              // bytes size (padded)
42             calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
43             log4(mark, 288,                           // calldata
44                  shl(224, shr(224, calldataload(0))), // msg.sig
45                  caller,                              // msg.sender
46                  calldataload(4),                     // arg1
47                  calldataload(36)                     // arg2
48                 )
49         }
50     }
51 }
52 
53 ////// /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/flop.sol
54 /// flop.sol -- Debt auction
55 
56 // Copyright (C) 2018 Rain <rainbreak@riseup.net>
57 //
58 // This program is free software: you can redistribute it and/or modify
59 // it under the terms of the GNU Affero General Public License as published by
60 // the Free Software Foundation, either version 3 of the License, or
61 // (at your option) any later version.
62 //
63 // This program is distributed in the hope that it will be useful,
64 // but WITHOUT ANY WARRANTY; without even the implied warranty of
65 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
66 // GNU Affero General Public License for more details.
67 //
68 // You should have received a copy of the GNU Affero General Public License
69 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
70 
71 /* pragma solidity 0.5.12; */
72 
73 /* import "./lib.sol"; */
74 
75 contract VatLike {
76     function move(address,address,uint) external;
77     function suck(address,address,uint) external;
78 }
79 contract GemLike {
80     function mint(address,uint) external;
81 }
82 
83 /*
84    This thing creates gems on demand in return for dai.
85 
86  - `lot` gems for sale
87  - `bid` dai paid
88  - `gal` receives dai income
89  - `ttl` single bid lifetime
90  - `beg` minimum bid increase
91  - `end` max auction duration
92 */
93 
94 contract Flopper is LibNote {
95     // --- Auth ---
96     mapping (address => uint) public wards;
97     function rely(address usr) external note auth { wards[usr] = 1; }
98     function deny(address usr) external note auth { wards[usr] = 0; }
99     modifier auth {
100         require(wards[msg.sender] == 1, "Flopper/not-authorized");
101         _;
102     }
103 
104     // --- Data ---
105     struct Bid {
106         uint256 bid;
107         uint256 lot;
108         address guy;  // high bidder
109         uint48  tic;  // expiry time
110         uint48  end;
111     }
112 
113     mapping (uint => Bid) public bids;
114 
115     VatLike  public   vat;
116     GemLike  public   gem;
117 
118     uint256  constant ONE = 1.00E18;
119     uint256  public   beg = 1.05E18;  // 5% minimum bid increase
120     uint256  public   pad = 1.50E18;  // 50% lot increase for tick
121     uint48   public   ttl = 3 hours;  // 3 hours bid lifetime
122     uint48   public   tau = 2 days;   // 2 days total auction length
123     uint256  public kicks = 0;
124     uint256  public live;
125     address  public vow;  // not used until shutdown
126 
127     // --- Events ---
128     event Kick(
129       uint256 id,
130       uint256 lot,
131       uint256 bid,
132       address indexed gal
133     );
134 
135     // --- Init ---
136     constructor(address vat_, address gem_) public {
137         wards[msg.sender] = 1;
138         vat = VatLike(vat_);
139         gem = GemLike(gem_);
140         live = 1;
141     }
142 
143     // --- Math ---
144     function add(uint48 x, uint48 y) internal pure returns (uint48 z) {
145         require((z = x + y) >= x);
146     }
147     function mul(uint x, uint y) internal pure returns (uint z) {
148         require(y == 0 || (z = x * y) / y == x);
149     }
150 
151     // --- Admin ---
152     function file(bytes32 what, uint data) external note auth {
153         if (what == "beg") beg = data;
154         else if (what == "pad") pad = data;
155         else if (what == "ttl") ttl = uint48(data);
156         else if (what == "tau") tau = uint48(data);
157         else revert("Flopper/file-unrecognized-param");
158     }
159 
160     // --- Auction ---
161     function kick(address gal, uint lot, uint bid) external auth returns (uint id) {
162         require(live == 1, "Flopper/not-live");
163         require(kicks < uint(-1), "Flopper/overflow");
164         id = ++kicks;
165 
166         bids[id].bid = bid;
167         bids[id].lot = lot;
168         bids[id].guy = gal;
169         bids[id].end = add(uint48(now), tau);
170 
171         emit Kick(id, lot, bid, gal);
172     }
173     function tick(uint id) external note {
174         require(bids[id].end < now, "Flopper/not-finished");
175         require(bids[id].tic == 0, "Flopper/bid-already-placed");
176         bids[id].lot = mul(pad, bids[id].lot) / ONE;
177         bids[id].end = add(uint48(now), tau);
178     }
179     function dent(uint id, uint lot, uint bid) external note {
180         require(live == 1, "Flopper/not-live");
181         require(bids[id].guy != address(0), "Flopper/guy-not-set");
182         require(bids[id].tic > now || bids[id].tic == 0, "Flopper/already-finished-tic");
183         require(bids[id].end > now, "Flopper/already-finished-end");
184 
185         require(bid == bids[id].bid, "Flopper/not-matching-bid");
186         require(lot <  bids[id].lot, "Flopper/lot-not-lower");
187         require(mul(beg, lot) <= mul(bids[id].lot, ONE), "Flopper/insufficient-decrease");
188 
189         vat.move(msg.sender, bids[id].guy, bid);
190 
191         bids[id].guy = msg.sender;
192         bids[id].lot = lot;
193         bids[id].tic = add(uint48(now), ttl);
194     }
195     function deal(uint id) external note {
196         require(live == 1, "Flopper/not-live");
197         require(bids[id].tic != 0 && (bids[id].tic < now || bids[id].end < now), "Flopper/not-finished");
198         gem.mint(bids[id].guy, bids[id].lot);
199         delete bids[id];
200     }
201     // --- Shutdown ---
202     function cage() external note auth {
203        live = 0;
204        vow = msg.sender;
205     }
206     function yank(uint id) external note {
207         require(live == 0, "Flopper/still-live");
208         require(bids[id].guy != address(0), "Flopper/guy-not-set");
209         vat.suck(vow, bids[id].guy, bids[id].bid);
210         delete bids[id];
211     }
212 }