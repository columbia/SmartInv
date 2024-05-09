1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of src/EscrowData.sol
4 pragma solidity ^0.4.24;
5 
6 ////// lib/ds-auth/src/auth.sol
7 // This program is free software: you can redistribute it and/or modify
8 // it under the terms of the GNU General Public License as published by
9 // the Free Software Foundation, either version 3 of the License, or
10 // (at your option) any later version.
11 
12 // This program is distributed in the hope that it will be useful,
13 // but WITHOUT ANY WARRANTY; without even the implied warranty of
14 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15 // GNU General Public License for more details.
16 
17 // You should have received a copy of the GNU General Public License
18 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
19 
20 /* pragma solidity >=0.4.23; */
21 
22 contract DSAuthority {
23     function canCall(
24         address src, address dst, bytes4 sig
25     ) public view returns (bool);
26 }
27 
28 contract DSAuthEvents {
29     event LogSetAuthority (address indexed authority);
30     event LogSetOwner     (address indexed owner);
31 }
32 
33 contract DSAuth is DSAuthEvents {
34     DSAuthority  public  authority;
35     address      public  owner;
36 
37     constructor() public {
38         owner = msg.sender;
39         emit LogSetOwner(msg.sender);
40     }
41 
42     function setOwner(address owner_)
43         public
44         auth
45     {
46         owner = owner_;
47         emit LogSetOwner(owner);
48     }
49 
50     function setAuthority(DSAuthority authority_)
51         public
52         auth
53     {
54         authority = authority_;
55         emit LogSetAuthority(address(authority));
56     }
57 
58     modifier auth {
59         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
60         _;
61     }
62 
63     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
64         if (src == address(this)) {
65             return true;
66         } else if (src == owner) {
67             return true;
68         } else if (authority == DSAuthority(0)) {
69             return false;
70         } else {
71             return authority.canCall(src, address(this), sig);
72         }
73     }
74 }
75 
76 ////// lib/ds-math/src/math.sol
77 /// math.sol -- mixin for inline numerical wizardry
78 
79 // This program is free software: you can redistribute it and/or modify
80 // it under the terms of the GNU General Public License as published by
81 // the Free Software Foundation, either version 3 of the License, or
82 // (at your option) any later version.
83 
84 // This program is distributed in the hope that it will be useful,
85 // but WITHOUT ANY WARRANTY; without even the implied warranty of
86 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
87 // GNU General Public License for more details.
88 
89 // You should have received a copy of the GNU General Public License
90 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
91 
92 /* pragma solidity >0.4.13; */
93 
94 contract DSMath {
95     function add(uint x, uint y) internal pure returns (uint z) {
96         require((z = x + y) >= x, "ds-math-add-overflow");
97     }
98     function sub(uint x, uint y) internal pure returns (uint z) {
99         require((z = x - y) <= x, "ds-math-sub-underflow");
100     }
101     function mul(uint x, uint y) internal pure returns (uint z) {
102         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
103     }
104 
105     function min(uint x, uint y) internal pure returns (uint z) {
106         return x <= y ? x : y;
107     }
108     function max(uint x, uint y) internal pure returns (uint z) {
109         return x >= y ? x : y;
110     }
111     function imin(int x, int y) internal pure returns (int z) {
112         return x <= y ? x : y;
113     }
114     function imax(int x, int y) internal pure returns (int z) {
115         return x >= y ? x : y;
116     }
117 
118     uint constant WAD = 10 ** 18;
119     uint constant RAY = 10 ** 27;
120 
121     function wmul(uint x, uint y) internal pure returns (uint z) {
122         z = add(mul(x, y), WAD / 2) / WAD;
123     }
124     function rmul(uint x, uint y) internal pure returns (uint z) {
125         z = add(mul(x, y), RAY / 2) / RAY;
126     }
127     function wdiv(uint x, uint y) internal pure returns (uint z) {
128         z = add(mul(x, WAD), y / 2) / y;
129     }
130     function rdiv(uint x, uint y) internal pure returns (uint z) {
131         z = add(mul(x, RAY), y / 2) / y;
132     }
133 
134     // This famous algorithm is called "exponentiation by squaring"
135     // and calculates x^n with x as fixed-point and n as regular unsigned.
136     //
137     // It's O(log n), instead of O(n) for naive repeated multiplication.
138     //
139     // These facts are why it works:
140     //
141     //  If n is even, then x^n = (x^2)^(n/2).
142     //  If n is odd,  then x^n = x * x^(n-1),
143     //   and applying the equation for even x gives
144     //    x^n = x * (x^2)^((n-1) / 2).
145     //
146     //  Also, EVM division is flooring and
147     //    floor[(n-1) / 2] = floor[n / 2].
148     //
149     function rpow(uint x, uint n) internal pure returns (uint z) {
150         z = n % 2 != 0 ? x : RAY;
151 
152         for (n /= 2; n != 0; n /= 2) {
153             x = rmul(x, x);
154 
155             if (n % 2 != 0) {
156                 z = rmul(z, x);
157             }
158         }
159     }
160 }
161 
162 ////// lib/ds-token/lib/ds-stop/lib/ds-note/src/note.sol
163 /// note.sol -- the `note' modifier, for logging calls as events
164 
165 // This program is free software: you can redistribute it and/or modify
166 // it under the terms of the GNU General Public License as published by
167 // the Free Software Foundation, either version 3 of the License, or
168 // (at your option) any later version.
169 
170 // This program is distributed in the hope that it will be useful,
171 // but WITHOUT ANY WARRANTY; without even the implied warranty of
172 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
173 // GNU General Public License for more details.
174 
175 // You should have received a copy of the GNU General Public License
176 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
177 
178 /* pragma solidity >=0.4.23; */
179 
180 contract DSNote {
181     event LogNote(
182         bytes4   indexed  sig,
183         address  indexed  guy,
184         bytes32  indexed  foo,
185         bytes32  indexed  bar,
186         uint256           wad,
187         bytes             fax
188     ) anonymous;
189 
190     modifier note {
191         bytes32 foo;
192         bytes32 bar;
193         uint256 wad;
194 
195         assembly {
196             foo := calldataload(4)
197             bar := calldataload(36)
198             wad := callvalue
199         }
200 
201         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
202 
203         _;
204     }
205 }
206 
207 ////// lib/ds-token/lib/ds-stop/src/stop.sol
208 /// stop.sol -- mixin for enable/disable functionality
209 
210 // Copyright (C) 2017  DappHub, LLC
211 
212 // This program is free software: you can redistribute it and/or modify
213 // it under the terms of the GNU General Public License as published by
214 // the Free Software Foundation, either version 3 of the License, or
215 // (at your option) any later version.
216 
217 // This program is distributed in the hope that it will be useful,
218 // but WITHOUT ANY WARRANTY; without even the implied warranty of
219 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
220 // GNU General Public License for more details.
221 
222 // You should have received a copy of the GNU General Public License
223 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
224 
225 /* pragma solidity >=0.4.23; */
226 
227 /* import "ds-auth/auth.sol"; */
228 /* import "ds-note/note.sol"; */
229 
230 contract DSStop is DSNote, DSAuth {
231     bool public stopped;
232 
233     modifier stoppable {
234         require(!stopped, "ds-stop-is-stopped");
235         _;
236     }
237     function stop() public auth note {
238         stopped = true;
239     }
240     function start() public auth note {
241         stopped = false;
242     }
243 
244 }
245 
246 ////// lib/ds-token/lib/erc20/src/erc20.sol
247 /// erc20.sol -- API for the ERC20 token standard
248 
249 // See <https://github.com/ethereum/EIPs/issues/20>.
250 
251 // This file likely does not meet the threshold of originality
252 // required for copyright to apply.  As a result, this is free and
253 // unencumbered software belonging to the public domain.
254 
255 /* pragma solidity >0.4.20; */
256 
257 contract ERC20Events {
258     event Approval(address indexed src, address indexed guy, uint wad);
259     event Transfer(address indexed src, address indexed dst, uint wad);
260 }
261 
262 contract ERC20 is ERC20Events {
263     function totalSupply() public view returns (uint);
264     function balanceOf(address guy) public view returns (uint);
265     function allowance(address src, address guy) public view returns (uint);
266 
267     function approve(address guy, uint wad) public returns (bool);
268     function transfer(address dst, uint wad) public returns (bool);
269     function transferFrom(
270         address src, address dst, uint wad
271     ) public returns (bool);
272 }
273 
274 ////// lib/ds-token/src/base.sol
275 /// base.sol -- basic ERC20 implementation
276 
277 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
278 
279 // This program is free software: you can redistribute it and/or modify
280 // it under the terms of the GNU General Public License as published by
281 // the Free Software Foundation, either version 3 of the License, or
282 // (at your option) any later version.
283 
284 // This program is distributed in the hope that it will be useful,
285 // but WITHOUT ANY WARRANTY; without even the implied warranty of
286 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
287 // GNU General Public License for more details.
288 
289 // You should have received a copy of the GNU General Public License
290 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
291 
292 /* pragma solidity >=0.4.23; */
293 
294 /* import "erc20/erc20.sol"; */
295 /* import "ds-math/math.sol"; */
296 
297 contract DSTokenBase is ERC20, DSMath {
298     uint256                                            _supply;
299     mapping (address => uint256)                       _balances;
300     mapping (address => mapping (address => uint256))  _approvals;
301 
302     constructor(uint supply) public {
303         _balances[msg.sender] = supply;
304         _supply = supply;
305     }
306 
307     function totalSupply() public view returns (uint) {
308         return _supply;
309     }
310     function balanceOf(address src) public view returns (uint) {
311         return _balances[src];
312     }
313     function allowance(address src, address guy) public view returns (uint) {
314         return _approvals[src][guy];
315     }
316 
317     function transfer(address dst, uint wad) public returns (bool) {
318         return transferFrom(msg.sender, dst, wad);
319     }
320 
321     function transferFrom(address src, address dst, uint wad)
322         public
323         returns (bool)
324     {
325         if (src != msg.sender) {
326             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
327             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
328         }
329 
330         require(_balances[src] >= wad, "ds-token-insufficient-balance");
331         _balances[src] = sub(_balances[src], wad);
332         _balances[dst] = add(_balances[dst], wad);
333 
334         emit Transfer(src, dst, wad);
335 
336         return true;
337     }
338 
339     function approve(address guy, uint wad) public returns (bool) {
340         _approvals[msg.sender][guy] = wad;
341 
342         emit Approval(msg.sender, guy, wad);
343 
344         return true;
345     }
346 }
347 
348 ////// lib/ds-token/src/token.sol
349 /// token.sol -- ERC20 implementation with minting and burning
350 
351 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
352 
353 // This program is free software: you can redistribute it and/or modify
354 // it under the terms of the GNU General Public License as published by
355 // the Free Software Foundation, either version 3 of the License, or
356 // (at your option) any later version.
357 
358 // This program is distributed in the hope that it will be useful,
359 // but WITHOUT ANY WARRANTY; without even the implied warranty of
360 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
361 // GNU General Public License for more details.
362 
363 // You should have received a copy of the GNU General Public License
364 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
365 
366 /* pragma solidity >=0.4.23; */
367 
368 /* import "ds-stop/stop.sol"; */
369 
370 /* import "./base.sol"; */
371 
372 contract DSToken is DSTokenBase(0), DSStop {
373 
374     bytes32  public  symbol;
375     uint256  public  decimals = 18; // standard token precision. override to customize
376 
377     constructor(bytes32 symbol_) public {
378         symbol = symbol_;
379     }
380 
381     event Mint(address indexed guy, uint wad);
382     event Burn(address indexed guy, uint wad);
383 
384     function approve(address guy) public stoppable returns (bool) {
385         return super.approve(guy, uint(-1));
386     }
387 
388     function approve(address guy, uint wad) public stoppable returns (bool) {
389         return super.approve(guy, wad);
390     }
391 
392     function transferFrom(address src, address dst, uint wad)
393         public
394         stoppable
395         returns (bool)
396     {
397         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
398             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
399             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
400         }
401 
402         require(_balances[src] >= wad, "ds-token-insufficient-balance");
403         _balances[src] = sub(_balances[src], wad);
404         _balances[dst] = add(_balances[dst], wad);
405 
406         emit Transfer(src, dst, wad);
407 
408         return true;
409     }
410 
411     function push(address dst, uint wad) public {
412         transferFrom(msg.sender, dst, wad);
413     }
414     function pull(address src, uint wad) public {
415         transferFrom(src, msg.sender, wad);
416     }
417     function move(address src, address dst, uint wad) public {
418         transferFrom(src, dst, wad);
419     }
420 
421     function mint(uint wad) public {
422         mint(msg.sender, wad);
423     }
424     function burn(uint wad) public {
425         burn(msg.sender, wad);
426     }
427     function mint(address guy, uint wad) public auth stoppable {
428         _balances[guy] = add(_balances[guy], wad);
429         _supply = add(_supply, wad);
430         emit Mint(guy, wad);
431     }
432     function burn(address guy, uint wad) public auth stoppable {
433         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
434             require(_approvals[guy][msg.sender] >= wad, "ds-token-insufficient-approval");
435             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
436         }
437 
438         require(_balances[guy] >= wad, "ds-token-insufficient-balance");
439         _balances[guy] = sub(_balances[guy], wad);
440         _supply = sub(_supply, wad);
441         emit Burn(guy, wad);
442     }
443 
444     // Optional token name
445     bytes32   public  name = "";
446 
447     function setName(bytes32 name_) public auth {
448         name = name_;
449     }
450 }
451 
452 ////// src/EscrowDataInterface.sol
453 /* pragma solidity ^0.4.24; */
454 
455 /* import "ds-token/token.sol"; */
456 
457 interface EscrowDataInterface
458 {
459     ///@notice Create and fund a new escrow.
460     function createEscrow(
461         bytes32 _tradeId, 
462         DSToken _token, 
463         address _buyer, 
464         address _seller, 
465         uint256 _value, 
466         uint16 _fee,
467         uint32 _paymentWindowInSeconds
468     ) external returns(bool);
469 
470     function getEscrow(
471         bytes32 _tradeHash
472     ) external returns(bool, uint32, uint128);
473 
474     function removeEscrow(
475         bytes32 _tradeHash
476     ) external returns(bool);
477 
478     function updateSellerCanCancelAfter(
479         bytes32 _tradeHash,
480         uint32 _paymentWindowInSeconds
481     ) external returns(bool);
482 
483     function increaseTotalGasFeesSpentByRelayer(
484         bytes32 _tradeHash,
485         uint128 _increaseGasFees
486     ) external returns(bool);
487 }
488 ////// src/EscrowData.sol
489 /* pragma solidity ^0.4.24; */
490 
491 /* import "ds-auth/auth.sol"; */
492 /* import "ds-token/token.sol"; */
493 /* import "./EscrowDataInterface.sol"; */
494 
495 // contract EscrowData is EscrowDataInterface, DSAuth
496 contract EscrowData is DSAuth, EscrowDataInterface
497 {
498     address public dexc2c;
499 
500     event SetDexC2C(address caller, address dexc2c);
501     event Created(bytes32 _tradeHash);
502     event Removed(bytes32 _tradeHash);
503     event Updated(bytes32 _tradeHash, uint32 _sellerCanCancelAfter);
504 
505     mapping (bytes32 => Escrow) public escrows;
506     struct Escrow
507     {
508         bool exists;
509         // This is the timestamp in which the seller can cancel the escrow after
510         uint32 sellerCanCancelAfter;
511         uint128 totalGasFeesSpentByRelayer;
512     }
513 
514     function setDexC2C(address _dexc2c)public auth returns(bool){
515         require(_dexc2c != address(0x00), "DEXC2C address error");
516         dexc2c = _dexc2c;
517         emit SetDexC2C(msg.sender, _dexc2c);
518         return true;
519     }
520 
521     modifier onlyDexc2c(){
522         require(msg.sender == dexc2c, "Must be dexc2c");
523         _;
524     }
525 
526     function createEscrow(
527         bytes32 _tradeId,
528         DSToken _tradeToken,
529         address _buyer,
530         address _seller,
531         uint256 _value,
532         uint16 _fee,
533         uint32 _paymentWindowInSeconds
534     ) public onlyDexc2c returns(bool){
535         bytes32 _tradeHash = keccak256(abi.encodePacked(_tradeId, _tradeToken, _buyer, _seller, _value, _fee));
536         require(!escrows[_tradeHash].exists, "Trade already exists");
537         uint32 _sellerCanCancelAfter = uint32(block.timestamp) + _paymentWindowInSeconds;
538     
539         escrows[_tradeHash] = Escrow(true, _sellerCanCancelAfter, 0);
540         emit Created(_tradeHash);
541         return true;
542     }
543 
544     function getEscrow(
545         bytes32 _tradeHash
546     ) public view returns (bool, uint32, uint128){
547         Escrow memory escrow = escrows[_tradeHash];
548         if(escrow.exists){
549             return (escrow.exists, escrow.sellerCanCancelAfter, escrow.totalGasFeesSpentByRelayer);
550         }
551         return (false, 0, 0);
552     }
553 
554     function exists(
555         bytes32 _tradeHash
556     ) public view returns(bool){
557         return escrows[_tradeHash].exists;
558     }
559 
560     function removeEscrow(
561         bytes32 _tradeHash
562     ) public onlyDexc2c returns(bool){
563         require(escrows[_tradeHash].exists, "Escrow not exists");
564         delete escrows[_tradeHash];
565         emit Removed(_tradeHash);
566         return true;
567     }
568 
569     function updateSellerCanCancelAfter(
570         bytes32 _tradeHash,
571         uint32 _paymentWindowInSeconds
572     ) public onlyDexc2c returns(bool){
573         require(escrows[_tradeHash].exists, "Escrow not exists");
574         uint32 _sellerCanCancelAfter = uint32(block.timestamp) + _paymentWindowInSeconds;
575         escrows[_tradeHash].sellerCanCancelAfter = _sellerCanCancelAfter;
576         emit Updated(_tradeHash, _sellerCanCancelAfter);
577         return true;
578     }
579 
580     function increaseTotalGasFeesSpentByRelayer(
581         bytes32 _tradeHash,
582         uint128 _increaseGasFees
583     ) public onlyDexc2c returns(bool){
584         require(escrows[_tradeHash].exists, "Escrow not exists");
585         escrows[_tradeHash].totalGasFeesSpentByRelayer += _increaseGasFees;
586         return true;
587     }
588 
589 }
