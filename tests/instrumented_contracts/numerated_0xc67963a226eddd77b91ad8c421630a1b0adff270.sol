1 // SPDX-License-Identifier: AGPL-3.0-or-later
2 
3 /// clip.sol -- Dai auction module 2.0
4 
5 // Copyright (C) 2020-2021 Maker Ecosystem Growth Holdings, INC.
6 //
7 // This program is free software: you can redistribute it and/or modify
8 // it under the terms of the GNU Affero General Public License as published
9 // by the Free Software Foundation, either version 3 of the License, or
10 // (at your option) any later version.
11 //
12 // This program is distributed in the hope that it will be useful,
13 // but WITHOUT ANY WARRANTY; without even the implied warranty of
14 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15 // GNU Affero General Public License for more details.
16 //
17 // You should have received a copy of the GNU Affero General Public License
18 // along with this program.  If not, see <https://www.gnu.org/licenses/>.
19 
20 pragma solidity >=0.6.12;
21 
22 interface VatLike {
23     function move(address,address,uint256) external;
24     function flux(bytes32,address,address,uint256) external;
25     function ilks(bytes32) external returns (uint256, uint256, uint256, uint256, uint256);
26     function suck(address,address,uint256) external;
27 }
28 
29 interface PipLike {
30     function peek() external returns (bytes32, bool);
31 }
32 
33 interface SpotterLike {
34     function par() external returns (uint256);
35     function ilks(bytes32) external returns (PipLike, uint256);
36 }
37 
38 interface DogLike {
39     function chop(bytes32) external returns (uint256);
40     function digs(bytes32, uint256) external;
41 }
42 
43 interface ClipperCallee {
44     function clipperCall(address, uint256, uint256, bytes calldata) external;
45 }
46 
47 interface AbacusLike {
48     function price(uint256, uint256) external view returns (uint256);
49 }
50 
51 contract Clipper {
52     // --- Auth ---
53     mapping (address => uint256) public wards;
54     function rely(address usr) external auth { wards[usr] = 1; emit Rely(usr); }
55     function deny(address usr) external auth { wards[usr] = 0; emit Deny(usr); }
56     modifier auth {
57         require(wards[msg.sender] == 1, "Clipper/not-authorized");
58         _;
59     }
60 
61     // --- Data ---
62     bytes32  immutable public ilk;   // Collateral type of this Clipper
63     VatLike  immutable public vat;   // Core CDP Engine
64 
65     DogLike     public dog;      // Liquidation module
66     address     public vow;      // Recipient of dai raised in auctions
67     SpotterLike public spotter;  // Collateral price module
68     AbacusLike  public calc;     // Current price calculator
69 
70     uint256 public buf;    // Multiplicative factor to increase starting price                  [ray]
71     uint256 public tail;   // Time elapsed before auction reset                                 [seconds]
72     uint256 public cusp;   // Percentage drop before auction reset                              [ray]
73     uint64  public chip;   // Percentage of tab to suck from vow to incentivize keepers         [wad]
74     uint192 public tip;    // Flat fee to suck from vow to incentivize keepers                  [rad]
75     uint256 public chost;  // Cache the ilk dust times the ilk chop to prevent excessive SLOADs [rad]
76 
77     uint256   public kicks;   // Total auctions
78     uint256[] public active;  // Array of active auction ids
79 
80     struct Sale {
81         uint256 pos;  // Index in active array
82         uint256 tab;  // Dai to raise       [rad]
83         uint256 lot;  // collateral to sell [wad]
84         address usr;  // Liquidated CDP
85         uint96  tic;  // Auction start time
86         uint256 top;  // Starting price     [ray]
87     }
88     mapping(uint256 => Sale) public sales;
89 
90     uint256 internal locked;
91 
92     // Levels for circuit breaker
93     // 0: no breaker
94     // 1: no new kick()
95     // 2: no new kick() or redo()
96     // 3: no new kick(), redo(), or take()
97     uint256 public stopped = 0;
98 
99     // --- Events ---
100     event Rely(address indexed usr);
101     event Deny(address indexed usr);
102 
103     event File(bytes32 indexed what, uint256 data);
104     event File(bytes32 indexed what, address data);
105 
106     event Kick(
107         uint256 indexed id,
108         uint256 top,
109         uint256 tab,
110         uint256 lot,
111         address indexed usr,
112         address indexed kpr,
113         uint256 coin
114     );
115     event Take(
116         uint256 indexed id,
117         uint256 max,
118         uint256 price,
119         uint256 owe,
120         uint256 tab,
121         uint256 lot,
122         address indexed usr
123     );
124     event Redo(
125         uint256 indexed id,
126         uint256 top,
127         uint256 tab,
128         uint256 lot,
129         address indexed usr,
130         address indexed kpr,
131         uint256 coin
132     );
133 
134     event Yank(uint256 id);
135 
136     // --- Init ---
137     constructor(address vat_, address spotter_, address dog_, bytes32 ilk_) public {
138         vat     = VatLike(vat_);
139         spotter = SpotterLike(spotter_);
140         dog     = DogLike(dog_);
141         ilk     = ilk_;
142         buf     = RAY;
143         wards[msg.sender] = 1;
144         emit Rely(msg.sender);
145     }
146 
147     // --- Synchronization ---
148     modifier lock {
149         require(locked == 0, "Clipper/system-locked");
150         locked = 1;
151         _;
152         locked = 0;
153     }
154 
155     modifier isStopped(uint256 level) {
156         require(stopped < level, "Clipper/stopped-incorrect");
157         _;
158     }
159 
160     // --- Administration ---
161     function file(bytes32 what, uint256 data) external auth lock {
162         if      (what == "buf")         buf = data;
163         else if (what == "tail")       tail = data;           // Time elapsed before auction reset
164         else if (what == "cusp")       cusp = data;           // Percentage drop before auction reset
165         else if (what == "chip")       chip = uint64(data);   // Percentage of tab to incentivize (max: 2^64 - 1 => 18.xxx WAD = 18xx%)
166         else if (what == "tip")         tip = uint192(data);  // Flat fee to incentivize keepers (max: 2^192 - 1 => 6.277T RAD)
167         else if (what == "stopped") stopped = data;           // Set breaker (0, 1, 2, or 3)
168         else revert("Clipper/file-unrecognized-param");
169         emit File(what, data);
170     }
171     function file(bytes32 what, address data) external auth lock {
172         if (what == "spotter") spotter = SpotterLike(data);
173         else if (what == "dog")    dog = DogLike(data);
174         else if (what == "vow")    vow = data;
175         else if (what == "calc")  calc = AbacusLike(data);
176         else revert("Clipper/file-unrecognized-param");
177         emit File(what, data);
178     }
179 
180     // --- Math ---
181     uint256 constant BLN = 10 **  9;
182     uint256 constant WAD = 10 ** 18;
183     uint256 constant RAY = 10 ** 27;
184 
185     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
186         z = x <= y ? x : y;
187     }
188     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
189         require((z = x + y) >= x);
190     }
191     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
192         require((z = x - y) <= x);
193     }
194     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
195         require(y == 0 || (z = x * y) / y == x);
196     }
197     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
198         z = mul(x, y) / WAD;
199     }
200     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
201         z = mul(x, y) / RAY;
202     }
203     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
204         z = mul(x, RAY) / y;
205     }
206 
207     // --- Auction ---
208 
209     // get the price directly from the OSM
210     // Could get this from rmul(Vat.ilks(ilk).spot, Spotter.mat()) instead, but
211     // if mat has changed since the last poke, the resulting value will be
212     // incorrect.
213     function getFeedPrice() internal returns (uint256 feedPrice) {
214         (PipLike pip, ) = spotter.ilks(ilk);
215         (bytes32 val, bool has) = pip.peek();
216         require(has, "Clipper/invalid-price");
217         feedPrice = rdiv(mul(uint256(val), BLN), spotter.par());
218     }
219 
220     // start an auction
221     // note: trusts the caller to transfer collateral to the contract
222     // The starting price `top` is obtained as follows:
223     //
224     //     top = val * buf / par
225     //
226     // Where `val` is the collateral's unitary value in USD, `buf` is a
227     // multiplicative factor to increase the starting price, and `par` is a
228     // reference per DAI.
229     function kick(
230         uint256 tab,  // Debt                   [rad]
231         uint256 lot,  // Collateral             [wad]
232         address usr,  // Address that will receive any leftover collateral
233         address kpr   // Address that will receive incentives
234     ) external auth lock isStopped(1) returns (uint256 id) {
235         // Input validation
236         require(tab  >          0, "Clipper/zero-tab");
237         require(lot  >          0, "Clipper/zero-lot");
238         require(usr != address(0), "Clipper/zero-usr");
239         id = ++kicks;
240         require(id   >          0, "Clipper/overflow");
241 
242         active.push(id);
243 
244         sales[id].pos = active.length - 1;
245 
246         sales[id].tab = tab;
247         sales[id].lot = lot;
248         sales[id].usr = usr;
249         sales[id].tic = uint96(block.timestamp);
250 
251         uint256 top;
252         top = rmul(getFeedPrice(), buf);
253         require(top > 0, "Clipper/zero-top-price");
254         sales[id].top = top;
255 
256         // incentive to kick auction
257         uint256 _tip  = tip;
258         uint256 _chip = chip;
259         uint256 coin;
260         if (_tip > 0 || _chip > 0) {
261             coin = add(_tip, wmul(tab, _chip));
262             vat.suck(vow, kpr, coin);
263         }
264 
265         emit Kick(id, top, tab, lot, usr, kpr, coin);
266     }
267 
268     // Reset an auction
269     // See `kick` above for an explanation of the computation of `top`.
270     function redo(
271         uint256 id,  // id of the auction to reset
272         address kpr  // Address that will receive incentives
273     ) external lock isStopped(2) {
274         // Read auction data
275         address usr = sales[id].usr;
276         uint96  tic = sales[id].tic;
277         uint256 top = sales[id].top;
278 
279         require(usr != address(0), "Clipper/not-running-auction");
280 
281         // Check that auction needs reset
282         // and compute current price [ray]
283         (bool done,) = status(tic, top);
284         require(done, "Clipper/cannot-reset");
285 
286         uint256 tab   = sales[id].tab;
287         uint256 lot   = sales[id].lot;
288         sales[id].tic = uint96(block.timestamp);
289 
290         uint256 feedPrice = getFeedPrice();
291         top = rmul(feedPrice, buf);
292         require(top > 0, "Clipper/zero-top-price");
293         sales[id].top = top;
294 
295         // incentive to redo auction
296         uint256 _tip  = tip;
297         uint256 _chip = chip;
298         uint256 coin;
299         if (_tip > 0 || _chip > 0) {
300             uint256 _chost = chost;
301             if (tab >= _chost && mul(lot, feedPrice) >= _chost) {
302                 coin = add(_tip, wmul(tab, _chip));
303                 vat.suck(vow, kpr, coin);
304             }
305         }
306 
307         emit Redo(id, top, tab, lot, usr, kpr, coin);
308     }
309 
310     // Buy up to `amt` of collateral from the auction indexed by `id`.
311     // 
312     // Auctions will not collect more DAI than their assigned DAI target,`tab`;
313     // thus, if `amt` would cost more DAI than `tab` at the current price, the
314     // amount of collateral purchased will instead be just enough to collect `tab` DAI.
315     //
316     // To avoid partial purchases resulting in very small leftover auctions that will
317     // never be cleared, any partial purchase must leave at least `Clipper.chost`
318     // remaining DAI target. `chost` is an asynchronously updated value equal to
319     // (Vat.dust * Dog.chop(ilk) / WAD) where the values are understood to be determined
320     // by whatever they were when Clipper.upchost() was last called. Purchase amounts
321     // will be minimally decreased when necessary to respect this limit; i.e., if the
322     // specified `amt` would leave `tab < chost` but `tab > 0`, the amount actually
323     // purchased will be such that `tab == chost`.
324     //
325     // If `tab <= chost`, partial purchases are no longer possible; that is, the remaining
326     // collateral can only be purchased entirely, or not at all.
327     function take(
328         uint256 id,           // Auction id
329         uint256 amt,          // Upper limit on amount of collateral to buy  [wad]
330         uint256 max,          // Maximum acceptable price (DAI / collateral) [ray]
331         address who,          // Receiver of collateral and external call address
332         bytes calldata data   // Data to pass in external call; if length 0, no call is done
333     ) external lock isStopped(3) {
334 
335         address usr = sales[id].usr;
336         uint96  tic = sales[id].tic;
337 
338         require(usr != address(0), "Clipper/not-running-auction");
339 
340         uint256 price;
341         {
342             bool done;
343             (done, price) = status(tic, sales[id].top);
344 
345             // Check that auction doesn't need reset
346             require(!done, "Clipper/needs-reset");
347         }
348 
349         // Ensure price is acceptable to buyer
350         require(max >= price, "Clipper/too-expensive");
351 
352         uint256 lot = sales[id].lot;
353         uint256 tab = sales[id].tab;
354         uint256 owe;
355 
356         {
357             // Purchase as much as possible, up to amt
358             uint256 slice = min(lot, amt);  // slice <= lot
359 
360             // DAI needed to buy a slice of this sale
361             owe = mul(slice, price);
362 
363             // Don't collect more than tab of DAI
364             if (owe > tab) {
365                 // Total debt will be paid
366                 owe = tab;                  // owe' <= owe
367                 // Adjust slice
368                 slice = owe / price;        // slice' = owe' / price <= owe / price == slice <= lot
369             } else if (owe < tab && slice < lot) {
370                 // If slice == lot => auction completed => dust doesn't matter
371                 uint256 _chost = chost;
372                 if (tab - owe < _chost) {    // safe as owe < tab
373                     // If tab <= chost, buyers have to take the entire lot.
374                     require(tab > _chost, "Clipper/no-partial-purchase");
375                     // Adjust amount to pay
376                     owe = tab - _chost;      // owe' <= owe
377                     // Adjust slice
378                     slice = owe / price;     // slice' = owe' / price < owe / price == slice < lot
379                 }
380             }
381 
382             // Calculate remaining tab after operation
383             tab = tab - owe;  // safe since owe <= tab
384             // Calculate remaining lot after operation
385             lot = lot - slice;
386 
387             // Send collateral to who
388             vat.flux(ilk, address(this), who, slice);
389 
390             // Do external call (if data is defined) but to be
391             // extremely careful we don't allow to do it to the two
392             // contracts which the Clipper needs to be authorized
393             DogLike dog_ = dog;
394             if (data.length > 0 && who != address(vat) && who != address(dog_)) {
395                 ClipperCallee(who).clipperCall(msg.sender, owe, slice, data);
396             }
397 
398             // Get DAI from caller
399             vat.move(msg.sender, vow, owe);
400 
401             // Removes Dai out for liquidation from accumulator
402             dog_.digs(ilk, lot == 0 ? tab + owe : owe);
403         }
404 
405         if (lot == 0) {
406             _remove(id);
407         } else if (tab == 0) {
408             vat.flux(ilk, address(this), usr, lot);
409             _remove(id);
410         } else {
411             sales[id].tab = tab;
412             sales[id].lot = lot;
413         }
414 
415         emit Take(id, max, price, owe, tab, lot, usr);
416     }
417 
418     function _remove(uint256 id) internal {
419         uint256 _move    = active[active.length - 1];
420         if (id != _move) {
421             uint256 _index   = sales[id].pos;
422             active[_index]   = _move;
423             sales[_move].pos = _index;
424         }
425         active.pop();
426         delete sales[id];
427     }
428 
429     // The number of active auctions
430     function count() external view returns (uint256) {
431         return active.length;
432     }
433 
434     // Return the entire array of active auctions
435     function list() external view returns (uint256[] memory) {
436         return active;
437     }
438 
439     // Externally returns boolean for if an auction needs a redo and also the current price
440     function getStatus(uint256 id) external view returns (bool needsRedo, uint256 price, uint256 lot, uint256 tab) {
441         // Read auction data
442         address usr = sales[id].usr;
443         uint96  tic = sales[id].tic;
444 
445         bool done;
446         (done, price) = status(tic, sales[id].top);
447 
448         needsRedo = usr != address(0) && done;
449         lot = sales[id].lot;
450         tab = sales[id].tab;
451     }
452 
453     // Internally returns boolean for if an auction needs a redo
454     function status(uint96 tic, uint256 top) internal view returns (bool done, uint256 price) {
455         price = calc.price(top, sub(block.timestamp, tic));
456         done  = (sub(block.timestamp, tic) > tail || rdiv(price, top) < cusp);
457     }
458 
459     // Public function to update the cached dust*chop value.
460     function upchost() external {
461         (,,,, uint256 _dust) = VatLike(vat).ilks(ilk);
462         chost = wmul(_dust, dog.chop(ilk));
463     }
464 
465     // Cancel an auction during ES or via governance action.
466     function yank(uint256 id) external auth lock {
467         require(sales[id].usr != address(0), "Clipper/not-running-auction");
468         dog.digs(ilk, sales[id].tab);
469         vat.flux(ilk, address(this), msg.sender, sales[id].lot);
470         _remove(id);
471         emit Yank(id);
472     }
473 }