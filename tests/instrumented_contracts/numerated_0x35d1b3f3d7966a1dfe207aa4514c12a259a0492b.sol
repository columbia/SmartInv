1 // hevm: flattened sources of /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/vat.sol
2 pragma solidity =0.5.12;
3 
4 ////// /nix/store/8xb41r4qd0cjb63wcrxf1qmfg88p0961-dss-6fd7de0/src/vat.sol
5 /// vat.sol -- Dai CDP database
6 
7 // Copyright (C) 2018 Rain <rainbreak@riseup.net>
8 //
9 // This program is free software: you can redistribute it and/or modify
10 // it under the terms of the GNU Affero General Public License as published by
11 // the Free Software Foundation, either version 3 of the License, or
12 // (at your option) any later version.
13 //
14 // This program is distributed in the hope that it will be useful,
15 // but WITHOUT ANY WARRANTY; without even the implied warranty of
16 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
17 // GNU Affero General Public License for more details.
18 //
19 // You should have received a copy of the GNU Affero General Public License
20 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
21 
22 /* pragma solidity 0.5.12; */
23 
24 contract Vat {
25     // --- Auth ---
26     mapping (address => uint) public wards;
27     function rely(address usr) external note auth { require(live == 1, "Vat/not-live"); wards[usr] = 1; }
28     function deny(address usr) external note auth { require(live == 1, "Vat/not-live"); wards[usr] = 0; }
29     modifier auth {
30         require(wards[msg.sender] == 1, "Vat/not-authorized");
31         _;
32     }
33 
34     mapping(address => mapping (address => uint)) public can;
35     function hope(address usr) external note { can[msg.sender][usr] = 1; }
36     function nope(address usr) external note { can[msg.sender][usr] = 0; }
37     function wish(address bit, address usr) internal view returns (bool) {
38         return either(bit == usr, can[bit][usr] == 1);
39     }
40 
41     // --- Data ---
42     struct Ilk {
43         uint256 Art;   // Total Normalised Debt     [wad]
44         uint256 rate;  // Accumulated Rates         [ray]
45         uint256 spot;  // Price with Safety Margin  [ray]
46         uint256 line;  // Debt Ceiling              [rad]
47         uint256 dust;  // Urn Debt Floor            [rad]
48     }
49     struct Urn {
50         uint256 ink;   // Locked Collateral  [wad]
51         uint256 art;   // Normalised Debt    [wad]
52     }
53 
54     mapping (bytes32 => Ilk)                       public ilks;
55     mapping (bytes32 => mapping (address => Urn )) public urns;
56     mapping (bytes32 => mapping (address => uint)) public gem;  // [wad]
57     mapping (address => uint256)                   public dai;  // [rad]
58     mapping (address => uint256)                   public sin;  // [rad]
59 
60     uint256 public debt;  // Total Dai Issued    [rad]
61     uint256 public vice;  // Total Unbacked Dai  [rad]
62     uint256 public Line;  // Total Debt Ceiling  [rad]
63     uint256 public live;  // Access Flag
64 
65     // --- Logs ---
66     event LogNote(
67         bytes4   indexed  sig,
68         bytes32  indexed  arg1,
69         bytes32  indexed  arg2,
70         bytes32  indexed  arg3,
71         bytes             data
72     ) anonymous;
73 
74     modifier note {
75         _;
76         assembly {
77             // log an 'anonymous' event with a constant 6 words of calldata
78             // and four indexed topics: the selector and the first three args
79             let mark := msize                         // end of memory ensures zero
80             mstore(0x40, add(mark, 288))              // update free memory pointer
81             mstore(mark, 0x20)                        // bytes type data offset
82             mstore(add(mark, 0x20), 224)              // bytes size (padded)
83             calldatacopy(add(mark, 0x40), 0, 224)     // bytes payload
84             log4(mark, 288,                           // calldata
85                  shl(224, shr(224, calldataload(0))), // msg.sig
86                  calldataload(4),                     // arg1
87                  calldataload(36),                    // arg2
88                  calldataload(68)                     // arg3
89                 )
90         }
91     }
92 
93     // --- Init ---
94     constructor() public {
95         wards[msg.sender] = 1;
96         live = 1;
97     }
98 
99     // --- Math ---
100     function add(uint x, int y) internal pure returns (uint z) {
101         z = x + uint(y);
102         require(y >= 0 || z <= x);
103         require(y <= 0 || z >= x);
104     }
105     function sub(uint x, int y) internal pure returns (uint z) {
106         z = x - uint(y);
107         require(y <= 0 || z <= x);
108         require(y >= 0 || z >= x);
109     }
110     function mul(uint x, int y) internal pure returns (int z) {
111         z = int(x) * y;
112         require(int(x) >= 0);
113         require(y == 0 || z / y == int(x));
114     }
115     function add(uint x, uint y) internal pure returns (uint z) {
116         require((z = x + y) >= x);
117     }
118     function sub(uint x, uint y) internal pure returns (uint z) {
119         require((z = x - y) <= x);
120     }
121     function mul(uint x, uint y) internal pure returns (uint z) {
122         require(y == 0 || (z = x * y) / y == x);
123     }
124 
125     // --- Administration ---
126     function init(bytes32 ilk) external note auth {
127         require(ilks[ilk].rate == 0, "Vat/ilk-already-init");
128         ilks[ilk].rate = 10 ** 27;
129     }
130     function file(bytes32 what, uint data) external note auth {
131         require(live == 1, "Vat/not-live");
132         if (what == "Line") Line = data;
133         else revert("Vat/file-unrecognized-param");
134     }
135     function file(bytes32 ilk, bytes32 what, uint data) external note auth {
136         require(live == 1, "Vat/not-live");
137         if (what == "spot") ilks[ilk].spot = data;
138         else if (what == "line") ilks[ilk].line = data;
139         else if (what == "dust") ilks[ilk].dust = data;
140         else revert("Vat/file-unrecognized-param");
141     }
142     function cage() external note auth {
143         live = 0;
144     }
145 
146     // --- Fungibility ---
147     function slip(bytes32 ilk, address usr, int256 wad) external note auth {
148         gem[ilk][usr] = add(gem[ilk][usr], wad);
149     }
150     function flux(bytes32 ilk, address src, address dst, uint256 wad) external note {
151         require(wish(src, msg.sender), "Vat/not-allowed");
152         gem[ilk][src] = sub(gem[ilk][src], wad);
153         gem[ilk][dst] = add(gem[ilk][dst], wad);
154     }
155     function move(address src, address dst, uint256 rad) external note {
156         require(wish(src, msg.sender), "Vat/not-allowed");
157         dai[src] = sub(dai[src], rad);
158         dai[dst] = add(dai[dst], rad);
159     }
160 
161     function either(bool x, bool y) internal pure returns (bool z) {
162         assembly{ z := or(x, y)}
163     }
164     function both(bool x, bool y) internal pure returns (bool z) {
165         assembly{ z := and(x, y)}
166     }
167 
168     // --- CDP Manipulation ---
169     function frob(bytes32 i, address u, address v, address w, int dink, int dart) external note {
170         // system is live
171         require(live == 1, "Vat/not-live");
172 
173         Urn memory urn = urns[i][u];
174         Ilk memory ilk = ilks[i];
175         // ilk has been initialised
176         require(ilk.rate != 0, "Vat/ilk-not-init");
177 
178         urn.ink = add(urn.ink, dink);
179         urn.art = add(urn.art, dart);
180         ilk.Art = add(ilk.Art, dart);
181 
182         int dtab = mul(ilk.rate, dart);
183         uint tab = mul(ilk.rate, urn.art);
184         debt     = add(debt, dtab);
185 
186         // either debt has decreased, or debt ceilings are not exceeded
187         require(either(dart <= 0, both(mul(ilk.Art, ilk.rate) <= ilk.line, debt <= Line)), "Vat/ceiling-exceeded");
188         // urn is either less risky than before, or it is safe
189         require(either(both(dart <= 0, dink >= 0), tab <= mul(urn.ink, ilk.spot)), "Vat/not-safe");
190 
191         // urn is either more safe, or the owner consents
192         require(either(both(dart <= 0, dink >= 0), wish(u, msg.sender)), "Vat/not-allowed-u");
193         // collateral src consents
194         require(either(dink <= 0, wish(v, msg.sender)), "Vat/not-allowed-v");
195         // debt dst consents
196         require(either(dart >= 0, wish(w, msg.sender)), "Vat/not-allowed-w");
197 
198         // urn has no debt, or a non-dusty amount
199         require(either(urn.art == 0, tab >= ilk.dust), "Vat/dust");
200 
201         gem[i][v] = sub(gem[i][v], dink);
202         dai[w]    = add(dai[w],    dtab);
203 
204         urns[i][u] = urn;
205         ilks[i]    = ilk;
206     }
207     // --- CDP Fungibility ---
208     function fork(bytes32 ilk, address src, address dst, int dink, int dart) external note {
209         Urn storage u = urns[ilk][src];
210         Urn storage v = urns[ilk][dst];
211         Ilk storage i = ilks[ilk];
212 
213         u.ink = sub(u.ink, dink);
214         u.art = sub(u.art, dart);
215         v.ink = add(v.ink, dink);
216         v.art = add(v.art, dart);
217 
218         uint utab = mul(u.art, i.rate);
219         uint vtab = mul(v.art, i.rate);
220 
221         // both sides consent
222         require(both(wish(src, msg.sender), wish(dst, msg.sender)), "Vat/not-allowed");
223 
224         // both sides safe
225         require(utab <= mul(u.ink, i.spot), "Vat/not-safe-src");
226         require(vtab <= mul(v.ink, i.spot), "Vat/not-safe-dst");
227 
228         // both sides non-dusty
229         require(either(utab >= i.dust, u.art == 0), "Vat/dust-src");
230         require(either(vtab >= i.dust, v.art == 0), "Vat/dust-dst");
231     }
232     // --- CDP Confiscation ---
233     function grab(bytes32 i, address u, address v, address w, int dink, int dart) external note auth {
234         Urn storage urn = urns[i][u];
235         Ilk storage ilk = ilks[i];
236 
237         urn.ink = add(urn.ink, dink);
238         urn.art = add(urn.art, dart);
239         ilk.Art = add(ilk.Art, dart);
240 
241         int dtab = mul(ilk.rate, dart);
242 
243         gem[i][v] = sub(gem[i][v], dink);
244         sin[w]    = sub(sin[w],    dtab);
245         vice      = sub(vice,      dtab);
246     }
247 
248     // --- Settlement ---
249     function heal(uint rad) external note {
250         address u = msg.sender;
251         sin[u] = sub(sin[u], rad);
252         dai[u] = sub(dai[u], rad);
253         vice   = sub(vice,   rad);
254         debt   = sub(debt,   rad);
255     }
256     function suck(address u, address v, uint rad) external note auth {
257         sin[u] = add(sin[u], rad);
258         dai[v] = add(dai[v], rad);
259         vice   = add(vice,   rad);
260         debt   = add(debt,   rad);
261     }
262 
263     // --- Rates ---
264     function fold(bytes32 i, address u, int rate) external note auth {
265         require(live == 1, "Vat/not-live");
266         Ilk storage ilk = ilks[i];
267         ilk.rate = add(ilk.rate, rate);
268         int rad  = mul(ilk.Art, rate);
269         dai[u]   = add(dai[u], rad);
270         debt     = add(debt,   rad);
271     }
272 }