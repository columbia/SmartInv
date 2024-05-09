1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of src/DexC2CGateway.sol
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
452 ////// lib/ds-value/lib/ds-thing/src/thing.sol
453 // thing.sol - `auth` with handy mixins. your things should be DSThings
454 
455 // Copyright (C) 2017  DappHub, LLC
456 
457 // This program is free software: you can redistribute it and/or modify
458 // it under the terms of the GNU General Public License as published by
459 // the Free Software Foundation, either version 3 of the License, or
460 // (at your option) any later version.
461 
462 // This program is distributed in the hope that it will be useful,
463 // but WITHOUT ANY WARRANTY; without even the implied warranty of
464 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
465 // GNU General Public License for more details.
466 
467 // You should have received a copy of the GNU General Public License
468 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
469 
470 /* pragma solidity >=0.4.23; */
471 
472 /* import 'ds-auth/auth.sol'; */
473 /* import 'ds-note/note.sol'; */
474 /* import 'ds-math/math.sol'; */
475 
476 contract DSThing is DSAuth, DSNote, DSMath {
477     function S(string memory s) internal pure returns (bytes4) {
478         return bytes4(keccak256(abi.encodePacked(s)));
479     }
480 
481 }
482 
483 ////// lib/ds-value/src/value.sol
484 /// value.sol - a value is a simple thing, it can be get and set
485 
486 // Copyright (C) 2017  DappHub, LLC
487 
488 // This program is free software: you can redistribute it and/or modify
489 // it under the terms of the GNU General Public License as published by
490 // the Free Software Foundation, either version 3 of the License, or
491 // (at your option) any later version.
492 
493 // This program is distributed in the hope that it will be useful,
494 // but WITHOUT ANY WARRANTY; without even the implied warranty of
495 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
496 // GNU General Public License for more details.
497 
498 // You should have received a copy of the GNU General Public License
499 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
500 
501 /* pragma solidity >=0.4.23; */
502 
503 /* import 'ds-thing/thing.sol'; */
504 
505 contract DSValue is DSThing {
506     bool    has;
507     bytes32 val;
508     function peek() public view returns (bytes32, bool) {
509         return (val,has);
510     }
511     function read() public view returns (bytes32) {
512         bytes32 wut; bool haz;
513         (wut, haz) = peek();
514         assert(haz);
515         return wut;
516     }
517     function poke(bytes32 wut) public note auth {
518         val = wut;
519         has = true;
520     }
521     function void() public note auth {  // unset the value
522         has = false;
523     }
524 }
525 
526 ////// src/EscrowDataInterface.sol
527 /* pragma solidity ^0.4.24; */
528 
529 /* import "ds-token/token.sol"; */
530 
531 interface EscrowDataInterface
532 {
533     ///@notice Create and fund a new escrow.
534     function createEscrow(
535         bytes32 _tradeId, 
536         DSToken _token, 
537         address _buyer, 
538         address _seller, 
539         uint256 _value, 
540         uint16 _fee,
541         uint32 _paymentWindowInSeconds
542     ) external returns(bool);
543 
544     function getEscrow(
545         bytes32 _tradeHash
546     ) external returns(bool, uint32, uint128);
547 
548     function removeEscrow(
549         bytes32 _tradeHash
550     ) external returns(bool);
551 
552     function updateSellerCanCancelAfter(
553         bytes32 _tradeHash,
554         uint32 _paymentWindowInSeconds
555     ) external returns(bool);
556 
557     function increaseTotalGasFeesSpentByRelayer(
558         bytes32 _tradeHash,
559         uint128 _increaseGasFees
560     ) external returns(bool);
561 }
562 ////// src/DexC2C.sol
563 /* pragma solidity ^0.4.24; */
564 
565 /* import "ds-token/token.sol"; */
566 /* import "ds-auth/auth.sol"; */
567 /* import "ds-value/value.sol"; */
568 // import "ds-math/math.sol";
569 /* import "./EscrowDataInterface.sol"; */
570 
571 contract DexC2C is DSAuth
572 {
573     DSToken constant internal ETH_TOKEN_ADDRESS = DSToken(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
574     bool public enableMake = true;
575     EscrowDataInterface escrowData;
576     // address escrowData;
577     address public gateway;
578     address public arbitrator;
579     address public relayer;
580     address public signer;
581     uint32 public requestCancellationMinimumTime;
582 
583     uint8 constant ACTION_TYPE_BUYER_PAID = 0x01;
584     uint8 constant ACTION_TYPE_SELLER_CANCEL = 0x02;
585     uint8 constant ACTION_TYPE_RELEASE = 0x03;
586     uint8 constant ACTION_TYPE_RESOLVE = 0x04;
587 
588     mapping(address => bool) public listTokens;
589     mapping(address => uint256) feesAvailableForWithdraw;
590     // mapping(bytes32 => bool) withdrawAddresses;
591     mapping(address => DSValue) public tokenPriceFeed;
592 
593 
594     // event SetGateway(address _gateway);
595     // event SetEscrowData(address _escrowData);
596     // event SetToken(address caller, DSToken token, bool enable);
597     // event ResetOwner(address curr, address old);
598     // event ResetRelayer(address curr, address old);
599     // event ResetSigner(address curr, address old);
600     // event ResetArbitrator(address curr, address ocl);
601     // event ResetEnabled(bool curr, bool old);
602     // event WithdrawAddressApproved(DSToken token, address addr, bool approve);
603     // event LogWithdraw(DSToken token, address receiver, uint amnt);
604 
605     event CreatedEscrow(address indexed _buyer, address indexed _seller, bytes32 indexed _tradeHash, DSToken _token);
606     event CancelledBySeller(address indexed _buyer, address indexed _seller, bytes32 indexed _tradeHash, DSToken _token);
607     event BuyerPaid(address indexed _buyer, address indexed _seller, bytes32 indexed _tradeHash, DSToken _token);
608     event Release(address indexed _buyer, address indexed _seller, bytes32 indexed _tradeHash, DSToken _token);
609     event DisputeResolved(address indexed _buyer, address indexed _seller, bytes32 indexed _tradeHash, DSToken _token);
610 
611     struct EscrowParams{
612         bytes32 tradeId;
613         DSToken tradeToken;
614         address buyer;
615         address seller;
616         uint256 value;
617         uint16 fee;
618         uint32 paymentWindowInSeconds;
619         uint32 expiry;
620         uint8 v;
621         bytes32 r;
622         bytes32 s;
623         address caller;
624     }
625 
626     struct Escrow{
627         bytes32 tradeHash;
628         bool exists;
629         uint32 sellerCanCancelAfter;
630         uint128 totalGasFeesSpentByRelayer;
631     }
632 
633     modifier onlyGateway(){
634         require(msg.sender == gateway, "Must be gateway contract");
635         _;
636     }
637     
638     constructor(EscrowDataInterface _escrowData, address _signer) DSAuth() public{
639         // require(_escrowData != address(0x00), "EscrowData address must exists");
640         arbitrator = msg.sender;
641         relayer = msg.sender;
642         signer = _signer;
643         escrowData = _escrowData;
644         listTokens[ETH_TOKEN_ADDRESS] = true;
645         requestCancellationMinimumTime = 2 hours;
646     }
647 
648     function setPriceFeed(DSToken _token, DSValue _priceFeed) public auth{
649         // require(_priceFeed != address(0x00), "price feed must not be null");
650         tokenPriceFeed[_token] = _priceFeed;
651     }
652 
653     function setRelayer(address _relayer) public auth {
654         // require(_relayer != address(0x00), "Relayer is null");
655         // emit ResetRelayer(_relayer, relayer);
656         relayer = _relayer;
657     }
658 
659     function setSigner(address _signer) public auth {
660         // require(_signer != address(0x00), "Signer is null");
661         // emit ResetSigner(_signer, signer);
662         signer = _signer;
663     }
664 
665     function setArbitrator(address _arbitrator) public auth{
666         // require(_arbitrator != address(0x00), "Arbitrator is null");
667         // emit ResetArbitrator(arbitrator, _arbitrator);
668         arbitrator = _arbitrator;
669     }
670 
671 
672     function setGateway(address _gateway) public auth returns(bool){
673         // require(_gateway != address(0x00), "Gateway address must valid");
674         gateway = _gateway;
675         // emit SetGateway(_gateway);
676     }
677 
678     function setEscrowData(EscrowDataInterface _escrowData) public auth returns(bool){
679         // require(_escrowData != address(0x00), "EscrowData address must valid");
680         escrowData = _escrowData;
681         // emit SetEscrowData(_escrowData);
682     }
683 
684     function setToken(DSToken token, bool enable) public auth returns(bool){
685         // require(gateway != address(0x00), "Set gateway first");
686         // require(token != address(0x00), "Token address can not be 0x00");
687         listTokens[token] = enable;
688         // emit SetToken(msg.sender, token, enable);
689     }
690 
691     function setRequestCancellationMinimumTime(
692         uint32 _newRequestCancellationMinimumTime
693     ) external auth {
694         requestCancellationMinimumTime = _newRequestCancellationMinimumTime;
695     }
696 
697     function enabled() public view returns(bool) {
698         return enableMake;
699     }
700 
701     function setEnabled(bool _enableMake) public auth{
702         require(_enableMake != enableMake, "Enabled same value");
703         // emit ResetEnabled(enableMake, _enableMake);
704         enableMake = _enableMake;
705     }
706 
707     function getTokenAmount(DSToken _token, uint ethWad) public view returns(uint){
708         require(tokenPriceFeed[address(_token)] != address(0x00), "the token has not price feed(to eth).");
709         DSValue feed = tokenPriceFeed[address(_token)];
710         return wmul(ethWad, uint(feed.read()));
711     }
712 
713     function checkCanResolveDispute(
714         bytes32 _tradeId,
715         DSToken _token,
716         address _buyer,
717         address _seller,
718         uint256 _value,
719         uint16 _fee,
720         uint8 _v,
721         bytes32 _r,
722         bytes32 _s,
723         uint8 _buyerPercent,
724         address _caller
725     ) private view {
726         require(_caller == arbitrator, "Must be arbitrator");
727         bytes32 tradeHash = keccak256(abi.encodePacked(_tradeId, _token, _buyer, _seller, _value, _fee));
728         bytes32 invitationHash = keccak256(abi.encodePacked(tradeHash, ACTION_TYPE_RESOLVE, _buyerPercent));
729         address _signature = recoverAddress(invitationHash, _v, _r, _s);
730         require(_signature == _buyer || _signature == _seller, "Must be buyer or seller");
731     }
732 
733     function resolveDispute(
734         bytes32 _tradeId,
735         DSToken _token,
736         address _buyer,
737         address _seller,
738         uint256 _value,
739         uint16 _fee,
740         uint8 _v,
741         bytes32 _r,
742         bytes32 _s,
743         uint8 _buyerPercent,
744         address _caller
745     ) external onlyGateway {
746         checkCanResolveDispute(_tradeId, _token, _buyer, _seller, _value, _fee, _v, _r, _s,_buyerPercent, _caller);
747 
748         Escrow memory escrow = getEscrow(_tradeId, _token, _buyer, _seller, _value, _fee);
749         require(escrow.exists, "Escrow does not exists");
750         require(_buyerPercent <= 100, "BuyerPercent must be 100 or lower");
751 
752         doResolveDispute(
753             escrow.tradeHash,
754             _token,
755             _buyer,
756             _seller,
757             _value,
758             _buyerPercent,
759             escrow.totalGasFeesSpentByRelayer
760         );
761     }
762 
763     uint16 constant GAS_doResolveDispute = 36100;
764     function doResolveDispute(
765         bytes32 _tradeHash,
766         DSToken _token,
767         address _buyer,
768         address _seller,
769         uint256 _value,
770         uint8 _buyerPercent,
771         uint128 _totalGasFeesSpentByRelayer
772     ) private {
773         uint256 _totalFees = _totalGasFeesSpentByRelayer;
774         if(_token == ETH_TOKEN_ADDRESS){
775             _totalFees += (GAS_doResolveDispute * uint128(tx.gasprice));
776         } else {
777             ///如果交易非ETH需要按照汇率换算成等值的token
778             _totalFees += getTokenAmount(_token, GAS_doResolveDispute * uint(tx.gasprice));
779         }
780         require(_value - _totalFees <= _value, "Overflow error");
781         feesAvailableForWithdraw[_token] += _totalFees;
782 
783         escrowData.removeEscrow(_tradeHash);
784         emit DisputeResolved(_buyer, _seller, _tradeHash, _token);
785         if(_token == ETH_TOKEN_ADDRESS){
786             if (_buyerPercent > 0){
787                 _buyer.transfer((_value - _totalFees) * _buyerPercent / 100);
788             }
789             if (_buyerPercent < 100){
790                 _seller.transfer((_value - _totalFees) * (100 - _buyerPercent) / 100);
791             }
792         }else{
793             if (_buyerPercent > 0){
794                 require(_token.transfer(_buyer, (_value - _totalFees) * _buyerPercent / 100));
795             }
796             if (_buyerPercent < 100){
797                 require(_token.transfer(_seller, (_value - _totalFees) * (100 - _buyerPercent) / 100));
798             }
799         }
800 
801     }
802 
803     uint16 constant GAS_relayBaseCost = 35500;
804     function relay(
805         bytes32 _tradeId,
806         DSToken _tradeToken,
807         address _buyer,
808         address _seller,
809         uint256 _value,
810         uint16 _fee,
811         uint128 _maxGasPrice,
812         uint8 _v,
813         bytes32 _r,
814         bytes32 _s,
815         uint8 _actionType,
816         address _caller
817     ) public onlyGateway returns (bool) {
818         address _relayedSender = getRelayedSender(_tradeId, _actionType, _maxGasPrice, _v, _r, _s);
819         uint128 _additionalGas = uint128(_caller == relayer ? GAS_relayBaseCost : 0);
820         if(_relayedSender == _buyer){
821             if(_actionType == ACTION_TYPE_BUYER_PAID){
822                 return doBuyerPaid(_tradeId, _tradeToken, _buyer, _seller, _value, _fee, _caller, _additionalGas);
823             }
824         }else if(_relayedSender == _seller) {
825             if(_actionType == ACTION_TYPE_SELLER_CANCEL){
826                 return doSellerCancel(_tradeId, _tradeToken, _buyer, _seller, _value, _fee, _caller, _additionalGas);
827             }else if(_actionType == ACTION_TYPE_RELEASE){
828                 return doRelease(_tradeId, _tradeToken, _buyer, _seller, _value, _fee, _caller, _additionalGas);
829             }
830         }else{
831             require(_relayedSender == _seller, "Unrecognised party");
832             return false;
833         }
834     }
835 
836     function createEscrow(
837         bytes32 _tradeId,
838         DSToken _tradeToken,
839         address _buyer,
840         address _seller,
841         uint256 _value,
842         uint16 _fee,
843         uint32 _paymentWindowInSeconds,
844         uint32 _expiry,
845         uint8 _v,
846         bytes32 _r,
847         bytes32 _s,
848         address _caller
849     ) external payable onlyGateway returns (bool){
850         EscrowParams memory params;
851         params.tradeId = _tradeId;
852         params.tradeToken = _tradeToken;
853         params.buyer = _buyer;
854         params.seller = _seller;
855         params.value = _value;
856         params.fee = _fee;
857         params.paymentWindowInSeconds = _paymentWindowInSeconds;
858         params.expiry = _expiry;
859         params.v = _v;
860         params.r = _r;
861         params.s = _s;
862         params.caller = _caller;
863 
864         return doCreateEscrow(params);
865     }
866 
867     function doCreateEscrow(
868         EscrowParams params
869     ) internal returns (bool) {
870         require(enableMake, "DESC2C is not enable");
871         require(listTokens[params.tradeToken], "Token is not allowed");
872         // require(params.caller == params.seller, "Must be seller");
873 
874         bytes32 _tradeHash = keccak256(
875             abi.encodePacked(params.tradeId, params.tradeToken, params.buyer, params.seller, params.value, params.fee));
876         bytes32 _invitationHash = keccak256(abi.encodePacked(_tradeHash, params.paymentWindowInSeconds, params.expiry));
877         require(recoverAddress(_invitationHash, params.v, params.r, params.s) == signer, "Must be signer");
878         require(block.timestamp < params.expiry, "Signature has expired");
879 
880         emit CreatedEscrow(params.buyer, params.seller, _tradeHash, params.tradeToken);
881         return escrowData.createEscrow(params.tradeId, params.tradeToken, params.buyer, params.seller, params.value, 
882         params.fee, params.paymentWindowInSeconds);
883     }
884 
885     function buyerPaid(
886         bytes32 _tradeId,
887         DSToken _token,
888         address _buyer,
889         address _seller,
890         uint256 _value,
891         uint16 _fee,
892         address _caller
893     ) external onlyGateway returns(bool) {
894         require(_caller == _buyer, "Must by buyer");
895         return doBuyerPaid(_tradeId, _token, _buyer, _seller, _value, _fee, _caller, 0);
896     }
897 
898     function release(
899         bytes32 _tradeId,
900         DSToken _token,
901         address _buyer,
902         address _seller,
903         uint256 _value,
904         uint16 _fee,
905         address _caller
906     ) external onlyGateway returns(bool){
907         require(_caller == _seller, "Must by seller");
908         doRelease(_tradeId, _token, _buyer, _seller, _value, _fee, _caller, 0);
909     }
910 
911     uint16 constant GAS_doRelease = 46588;
912     function doRelease(
913         bytes32 _tradeId,
914         DSToken _token,
915         address _buyer,
916         address _seller,
917         uint256 _value,
918         uint16 _fee,
919         address _caller,
920         uint128 _additionalGas
921     ) internal returns(bool){
922         Escrow memory escrow = getEscrow(_tradeId, _token, _buyer, _seller, _value, _fee);
923         require(escrow.exists, "Escrow does not exists");
924 
925         uint128 _gasFees = escrow.totalGasFeesSpentByRelayer;
926         if(_caller == relayer){
927             if(_token == ETH_TOKEN_ADDRESS){
928                 _gasFees += (GAS_doRelease + _additionalGas) * uint128(tx.gasprice);
929             }else{
930                 uint256 relayGas = (GAS_doRelease + _additionalGas) * tx.gasprice;
931                 _gasFees += uint128(getTokenAmount(_token, relayGas));
932             }
933         }else{
934             require(_caller == _seller, "Must by seller");
935         }
936         escrowData.removeEscrow(escrow.tradeHash);
937         transferMinusFees(_token, _buyer, _value, _gasFees, _fee);
938         emit Release(_buyer, _seller, escrow.tradeHash, _token);
939         return true;
940     }
941 
942     uint16 constant GAS_doBuyerPaid = 35944;
943     function doBuyerPaid(
944         bytes32 _tradeId,
945         DSToken _token,
946         address _buyer,
947         address _seller,
948         uint256 _value,
949         uint16 _fee,
950         address _caller,
951         uint128 _additionalGas
952     ) internal returns(bool){
953         Escrow memory escrow = getEscrow(_tradeId, _token, _buyer, _seller, _value, _fee);
954         require(escrow.exists, "Escrow not exists");
955 
956         if(_caller == relayer){
957             if(_token == ETH_TOKEN_ADDRESS){
958                 require(escrowData.increaseTotalGasFeesSpentByRelayer(escrow.tradeHash, (GAS_doBuyerPaid + _additionalGas) * uint128(tx.gasprice)));
959             }else{
960                 uint256 relayGas = (GAS_doBuyerPaid + _additionalGas) * tx.gasprice;
961                 require(escrowData.increaseTotalGasFeesSpentByRelayer(escrow.tradeHash, uint128(getTokenAmount(_token, relayGas))));
962             }
963         }else{
964             require(_caller == _buyer, "Must be buyer");
965         }
966         
967         require(escrowData.updateSellerCanCancelAfter(escrow.tradeHash, requestCancellationMinimumTime));
968         emit BuyerPaid(_buyer, _seller, escrow.tradeHash, _token);
969         return true;
970     }
971 
972     function sellerCancel(
973         bytes32 _tradeId,
974         DSToken _token,
975         address _buyer,
976         address _seller,
977         uint256 _value,
978         uint16 _fee,
979         uint32 _expiry,
980         uint8 _v,
981         bytes32 _r,
982         bytes32 _s,
983         address _caller
984     ) external onlyGateway returns (bool){
985         require(_caller == _seller, "Must be seller");
986         bytes32 tradeHash = keccak256(abi.encodePacked(_tradeId, _token, _buyer, _seller, _value, _fee));
987         bytes32 invitationHash = keccak256(abi.encodePacked(tradeHash, ACTION_TYPE_SELLER_CANCEL, _expiry));
988         require(recoverAddress(invitationHash, _v, _r, _s) == signer, "Must be signer");
989         return doSellerCancel(_tradeId, _token, _buyer, _seller, _value, _fee, _caller, 0);
990     }
991 
992     uint16 constant GAS_doSellerCancel = 46255;
993     function doSellerCancel(
994         bytes32 _tradeId,
995         DSToken _token,
996         address _buyer,
997         address _seller,
998         uint256 _value,
999         uint16 _fee,
1000         address _caller,
1001         uint128 _additionalGas
1002     ) private returns (bool) {
1003         Escrow memory escrow = getEscrow(_tradeId, _token, _buyer, _seller, _value, _fee);
1004         require(escrow.exists, "Escrow does not exists");
1005 
1006         if(block.timestamp < escrow.sellerCanCancelAfter){
1007             return false;
1008         }
1009 
1010         uint128 _gasFees = escrow.totalGasFeesSpentByRelayer;
1011         if(_caller == relayer){
1012             if(_token == ETH_TOKEN_ADDRESS){
1013                 _gasFees += (GAS_doSellerCancel + _additionalGas) * uint128(tx.gasprice);
1014             }else{
1015                 uint256 relayGas = (GAS_doSellerCancel + _additionalGas) * tx.gasprice;
1016                 _gasFees += uint128(getTokenAmount(_token, relayGas));
1017             }
1018         }else{
1019             require(_caller == _seller, "Must be buyer");
1020         }
1021         
1022         escrowData.removeEscrow(escrow.tradeHash);
1023         emit CancelledBySeller(_buyer, _seller, escrow.tradeHash, _token);
1024         transferMinusFees(_token, _seller, _value, _gasFees, 0);
1025         return true;
1026     }
1027 
1028     function transferMinusFees(
1029         DSToken _token,
1030         address _to,
1031         uint256 _value,
1032         uint128 _totalGasFeesSpentByRelayer,
1033         uint16 _fee
1034     ) private {
1035         uint256 _totalFees = (_value * _fee / 10000);
1036         _totalFees += _totalGasFeesSpentByRelayer;
1037         if(_value - _totalFees > _value) {
1038             return;
1039         }
1040         feesAvailableForWithdraw[_token] += _totalFees;
1041 
1042         if(_token == ETH_TOKEN_ADDRESS){
1043             _to.transfer(_value - _totalFees);
1044         }else{
1045             require(_token.transfer(_to, _value - _totalFees));
1046         }
1047     }
1048 
1049     function getFeesAvailableForWithdraw(
1050         DSToken _token
1051     ) public view auth returns(uint256){
1052         // bytes32 key = keccak256(abi.encodePacked(_token, msg.sender));
1053         // require(withdrawAddresses[key], "unauthorization address!");
1054         return feesAvailableForWithdraw[_token];
1055     }
1056 
1057     // function approvedWithdrawAddress(DSToken _token, address _addr, bool _approve) public auth returns(bool){
1058     //     // require(_addr != address(0x00), "Approved address is null");
1059     //     bytes32 key = keccak256(abi.encodePacked(_token, _addr));
1060     //     require(withdrawAddresses[key] != _approve, "Address has approved");
1061     //     withdrawAddresses[key] = _approve;
1062     //     // emit WithdrawAddressApproved(_token, _addr, _approve);
1063     //     return true;
1064     // }
1065 
1066     function withdraw(DSToken _token, uint _amnt, address _receiver) external auth returns(bool){
1067         // require(withdrawAddresses[keccak256(abi.encodePacked(_token, _receiver))], "Address not in white list");
1068         require(feesAvailableForWithdraw[_token] > 0, "Fees is 0 or token not exists");
1069         require(_amnt <= feesAvailableForWithdraw[_token], "Amount is higher than amount available");
1070         if(_token == ETH_TOKEN_ADDRESS){
1071             _receiver.transfer(_amnt);
1072         }else{
1073             require(_token.transfer(_receiver, _amnt), "Withdraw failed");
1074         }
1075         // emit LogWithdraw(_token, _receiver, _amnt);
1076         return true;
1077     }
1078 
1079     function getEscrow(
1080         bytes32 _tradeId,
1081         DSToken _token,
1082         address _buyer,
1083         address _seller,
1084         uint256 _value,
1085         uint16 _fee
1086     ) private returns(Escrow){
1087         bytes32 _tradeHash = keccak256(abi.encodePacked(_tradeId, _token, _buyer, _seller, _value, _fee));
1088         bool exists;
1089         uint32 sellerCanCancelAfter;
1090         uint128 totalFeesSpentByRelayer; 
1091         (exists, sellerCanCancelAfter, totalFeesSpentByRelayer) = escrowData.getEscrow(_tradeHash);
1092 
1093         return Escrow(_tradeHash, exists, sellerCanCancelAfter, totalFeesSpentByRelayer);
1094     }
1095 
1096     function () public payable{
1097     }
1098 
1099     function recoverAddress(
1100         bytes32 _h,
1101         uint8 _v,
1102         bytes32 _r,
1103         bytes32 _s
1104     ) internal pure returns (address){
1105         bytes memory _prefix = "\x19Ethereum Signed Message:\n32";
1106         bytes32 _prefixedHash = keccak256(abi.encodePacked(_prefix, _h));
1107         return ecrecover(_prefixedHash, _v, _r, _s); 
1108     }
1109 
1110     function getRelayedSender(
1111         bytes32 _tradeId,
1112         uint8 _actionType,
1113         uint128 _maxGasPrice,
1114         uint8 _v,
1115         bytes32 _r,
1116         bytes32 _s
1117     ) internal view returns(address){
1118         bytes32 _hash = keccak256(abi.encodePacked(_tradeId, _actionType, _maxGasPrice));
1119         if(tx.gasprice > _maxGasPrice){
1120             return;
1121         }
1122         return recoverAddress(_hash, _v, _r, _s);
1123     }
1124     function add(uint x, uint y) internal pure returns (uint z) {
1125         require((z = x + y) >= x, "ds-math-add-overflow");
1126     }
1127     function mul(uint x, uint y) internal pure returns (uint z) {
1128         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
1129     }
1130     uint constant WAD = 10 ** 18;
1131     function wmul(uint x, uint y) internal pure returns (uint z) {
1132         z = add(mul(x, y), WAD / 2) / WAD;
1133     }
1134 }
1135 ////// src/DexC2CGateway.sol
1136 /* pragma solidity ^0.4.24; */
1137 
1138 /* import "./DexC2C.sol"; */
1139 /* import "ds-token/token.sol"; */
1140 /* import "ds-auth/auth.sol"; */
1141 
1142 contract DexC2CGateway is DSAuth{
1143     
1144     DSToken constant internal ETH_TOKEN_ADDRESS = DSToken(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
1145     DexC2C dexc2c;
1146 
1147     event ResetDexC2C(address curr, address old);
1148 
1149     struct BatchRelayParams{
1150         bytes32[] _tradeId;
1151         DSToken[] _token;
1152         address[] _buyer;
1153         address[] _seller;
1154         uint256[] _value;
1155         uint16[] _fee;
1156         uint128[] _maxGasPrice;
1157         uint8[] _v;
1158         bytes32[] _r;
1159         bytes32[] _s;
1160         uint8[] _actionType;
1161     }
1162 
1163 
1164     constructor() DSAuth() public{
1165     }
1166 
1167     function setDexC2C(DexC2C _dexc2c) public auth{
1168         require(_dexc2c != address(0x00), "DexC2C is null");
1169         dexc2c = _dexc2c;
1170         emit ResetDexC2C(_dexc2c, dexc2c);
1171     }
1172 
1173     function resolveDispute(
1174         bytes32 _tradeId,
1175         DSToken _token,
1176         address _buyer,
1177         address _seller,
1178         uint256 _value,
1179         uint16 _fee,
1180         uint8 _v,
1181         bytes32 _r,
1182         bytes32 _s,
1183         uint8 _buyerPercent
1184     ) public{
1185         dexc2c.resolveDispute(_tradeId, _token, _buyer, _seller, _value, _fee, _v, _r, _s, _buyerPercent, msg.sender);
1186     }
1187 
1188     function relay(
1189         bytes32 _tradeId,
1190         DSToken _token,
1191         address _buyer,
1192         address _seller,
1193         uint256 _value,
1194         uint16 _fee,
1195         uint128 _maxGasPrice,
1196         uint8 _v,
1197         bytes32 _r,
1198         bytes32 _s,
1199         uint8 _actionType
1200     ) public returns(bool){
1201         return dexc2c.relay(_tradeId, _token, _buyer, _seller, _value, _fee, _maxGasPrice, _v, _r, _s, _actionType, msg.sender);
1202     }
1203 
1204     function createEscrow(
1205         bytes32 _tradeId,
1206         DSToken _tradeToken,
1207         address _buyer,
1208         address _seller,
1209         uint256 _value,
1210         uint16 _fee,
1211         uint32 _paymentWindowInSeconds,
1212         uint32 _expiry,
1213         uint8 _v,
1214         bytes32 _r,
1215         bytes32 _s
1216     ) public payable returns(bool) {
1217         if(_tradeToken == ETH_TOKEN_ADDRESS){
1218             require(msg.value == _value && msg.value > 0, "Incorrect token sent");
1219         }else{
1220             require(_tradeToken.transferFrom(_seller, dexc2c, _value), "Can not transfer token from seller");
1221         }
1222         return doCreateEscrow(_tradeId, _tradeToken, _buyer, _seller, _value, _fee, _paymentWindowInSeconds, _expiry, _v, _r, _s, msg.sender);
1223     }
1224 
1225     function sellerCancel(
1226         bytes32 _tradeId,
1227         DSToken _tradeToken,
1228         address _buyer,
1229         address _seller,
1230         uint256 _value,
1231         uint16 _fee,
1232         uint32 _expiry,
1233         uint8 _v,
1234         bytes32 _r,
1235         bytes32 _s
1236     ) public returns(bool){
1237         return dexc2c.sellerCancel(_tradeId, _tradeToken, _buyer, _seller, _value, _fee, _expiry, _v, _r, _s, msg.sender);
1238     }
1239 
1240     function buyerPaid(
1241         bytes32 _tradeId,
1242         DSToken _tradeToken,
1243         address _buyer,
1244         address _seller,
1245         uint256 _value,
1246         uint16 _fee
1247     )public returns(bool){
1248         return dexc2c.buyerPaid(_tradeId, _tradeToken, _buyer, _seller, _value, _fee, msg.sender);
1249     }
1250 
1251     function release(
1252         bytes32 _tradeId,
1253         DSToken _tradeToken,
1254         address _buyer,
1255         address _seller,
1256         uint256 _value,
1257         uint16 _fee
1258     )public returns(bool){
1259         return dexc2c.release(_tradeId, _tradeToken, _buyer, _seller, _value, _fee, msg.sender);
1260     }
1261 
1262     function doCreateEscrow(
1263         bytes32 _tradeId,
1264         DSToken _tradeToken,
1265         address _buyer,
1266         address _seller,
1267         uint256 _value,
1268         uint16 _fee,
1269         uint32 _paymentWindowInSeconds,
1270         uint32 _expiry,
1271         uint8 _v,
1272         bytes32 _r,
1273         bytes32 _s,
1274         address _caller
1275     ) internal returns(bool){
1276         return dexc2c.createEscrow.value(msg.value)(
1277             _tradeId,
1278             _tradeToken,
1279             _buyer,
1280             _seller,
1281             _value,
1282             _fee,
1283             _paymentWindowInSeconds,
1284             _expiry,
1285             _v,
1286             _r,
1287             _s,
1288             _caller
1289         );
1290     }
1291 
1292     function recoverAddress(
1293         bytes32 _h,
1294         uint8 _v,
1295         bytes32 _r,
1296         bytes32 _s
1297     ) internal pure returns (address){
1298         // bytes memory _prefix = "\x19Ethereum Signed Message:\n32";
1299         // bytes32 _prefixedHash = keccak256(abi.encodePacked(_prefix, _h));
1300         // return ecrecover(_prefixedHash, _v, _r, _s); 
1301         return ecrecover(_h, _v, _r, _s);
1302     }
1303 
1304     function getRelayedSender(
1305         bytes32 _tradeId,
1306         uint8 _actionType,
1307         uint128 _maxGasPrice,
1308         uint8 _v,
1309         bytes32 _r,
1310         bytes32 _s
1311     ) internal view returns(address){
1312         bytes32 _hash = keccak256(abi.encodePacked(_tradeId, _actionType, _maxGasPrice));
1313         if(tx.gasprice > _maxGasPrice){
1314             return;
1315         }
1316         return recoverAddress(_hash, _v, _r, _s);
1317     }
1318 }
