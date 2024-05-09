1 /// flap.sol -- Surplus auction
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
50     function move(address,address,uint) external;
51 }
52 interface GemLike {
53     function move(address,address,uint) external;
54     function burn(address,uint) external;
55 }
56 
57 /*
58    This thing lets you sell some dai in return for gems.
59 
60  - `lot` dai in return for bid
61  - `bid` gems paid
62  - `ttl` single bid lifetime
63  - `beg` minimum bid increase
64  - `end` max auction duration
65 */
66 
67 contract Flapper is LibNote {
68     // --- Auth ---
69     mapping (address => uint) public wards;
70     function rely(address usr) external note auth { wards[usr] = 1; }
71     function deny(address usr) external note auth { wards[usr] = 0; }
72     modifier auth {
73         require(wards[msg.sender] == 1, "Flapper/not-authorized");
74         _;
75     }
76 
77     // --- Data ---
78     struct Bid {
79         uint256 bid;  // gems paid               [wad]
80         uint256 lot;  // dai in return for bid   [rad]
81         address guy;  // high bidder
82         uint48  tic;  // bid expiry time         [unix epoch time]
83         uint48  end;  // auction expiry time     [unix epoch time]
84     }
85 
86     mapping (uint => Bid) public bids;
87 
88     VatLike  public   vat;  // CDP Engine
89     GemLike  public   gem;
90 
91     uint256  constant ONE = 1.00E18;
92     uint256  public   beg = 1.05E18;  // 5% minimum bid increase
93     uint48   public   ttl = 3 hours;  // 3 hours bid duration         [seconds]
94     uint48   public   tau = 2 days;   // 2 days total auction length  [seconds]
95     uint256  public kicks = 0;
96     uint256  public live;  // Active Flag
97 
98     // --- Events ---
99     event Kick(
100       uint256 id,
101       uint256 lot,
102       uint256 bid
103     );
104 
105     // --- Init ---
106     constructor(address vat_, address gem_) public {
107         wards[msg.sender] = 1;
108         vat = VatLike(vat_);
109         gem = GemLike(gem_);
110         live = 1;
111     }
112 
113     // --- Math ---
114     function add(uint48 x, uint48 y) internal pure returns (uint48 z) {
115         require((z = x + y) >= x);
116     }
117     function mul(uint x, uint y) internal pure returns (uint z) {
118         require(y == 0 || (z = x * y) / y == x);
119     }
120 
121     // --- Admin ---
122     function file(bytes32 what, uint data) external note auth {
123         if (what == "beg") beg = data;
124         else if (what == "ttl") ttl = uint48(data);
125         else if (what == "tau") tau = uint48(data);
126         else revert("Flapper/file-unrecognized-param");
127     }
128 
129     // --- Auction ---
130     function kick(uint lot, uint bid) external auth returns (uint id) {
131         require(live == 1, "Flapper/not-live");
132         require(kicks < uint(-1), "Flapper/overflow");
133         id = ++kicks;
134 
135         bids[id].bid = bid;
136         bids[id].lot = lot;
137         bids[id].guy = msg.sender;  // configurable??
138         bids[id].end = add(uint48(now), tau);
139 
140         vat.move(msg.sender, address(this), lot);
141 
142         emit Kick(id, lot, bid);
143     }
144     function tick(uint id) external note {
145         require(bids[id].end < now, "Flapper/not-finished");
146         require(bids[id].tic == 0, "Flapper/bid-already-placed");
147         bids[id].end = add(uint48(now), tau);
148     }
149     function tend(uint id, uint lot, uint bid) external note {
150         require(live == 1, "Flapper/not-live");
151         require(bids[id].guy != address(0), "Flapper/guy-not-set");
152         require(bids[id].tic > now || bids[id].tic == 0, "Flapper/already-finished-tic");
153         require(bids[id].end > now, "Flapper/already-finished-end");
154 
155         require(lot == bids[id].lot, "Flapper/lot-not-matching");
156         require(bid >  bids[id].bid, "Flapper/bid-not-higher");
157         require(mul(bid, ONE) >= mul(beg, bids[id].bid), "Flapper/insufficient-increase");
158 
159         if (msg.sender != bids[id].guy) {
160             gem.move(msg.sender, bids[id].guy, bids[id].bid);
161             bids[id].guy = msg.sender;
162         }
163         gem.move(msg.sender, address(this), bid - bids[id].bid);
164 
165         bids[id].bid = bid;
166         bids[id].tic = add(uint48(now), ttl);
167     }
168     function deal(uint id) external note {
169         require(live == 1, "Flapper/not-live");
170         require(bids[id].tic != 0 && (bids[id].tic < now || bids[id].end < now), "Flapper/not-finished");
171         vat.move(address(this), bids[id].guy, bids[id].lot);
172         gem.burn(address(this), bids[id].bid);
173         delete bids[id];
174     }
175 
176     function cage(uint rad) external note auth {
177        live = 0;
178        vat.move(address(this), msg.sender, rad);
179     }
180     function yank(uint id) external note {
181         require(live == 0, "Flapper/still-live");
182         require(bids[id].guy != address(0), "Flapper/guy-not-set");
183         gem.move(address(this), bids[id].guy, bids[id].bid);
184         delete bids[id];
185     }
186 }