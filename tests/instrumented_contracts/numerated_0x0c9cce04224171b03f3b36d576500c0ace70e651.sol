1 pragma solidity ^0.4.21;
2 
3 ////// lib/ds-roles/lib/ds-auth/src/auth.sol
4 // This program is free software: you can redistribute it and/or modify
5 // it under the terms of the GNU General Public License as published by
6 // the Free Software Foundation, either version 3 of the License, or
7 // (at your option) any later version.
8 
9 // This program is distributed in the hope that it will be useful,
10 // but WITHOUT ANY WARRANTY; without even the implied warranty of
11 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
12 // GNU General Public License for more details.
13 
14 // You should have received a copy of the GNU General Public License
15 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
16 
17 contract DSAuthority {
18     function canCall(
19         address src, address dst, bytes4 sig
20     ) public view returns (bool);
21 }
22 
23 contract DSAuthEvents {
24     event LogSetAuthority (address indexed authority);
25     event LogSetOwner     (address indexed owner);
26 }
27 
28 contract DSAuth is DSAuthEvents {
29     DSAuthority  public  authority;
30     address      public  owner;
31 
32     function DSAuth() public {
33         owner = msg.sender;
34         LogSetOwner(msg.sender);
35     }
36 
37     function setOwner(address owner_)
38         public
39         auth
40     {
41         owner = owner_;
42         LogSetOwner(owner);
43     }
44 
45     function setAuthority(DSAuthority authority_)
46         public
47         auth
48     {
49         authority = authority_;
50         LogSetAuthority(authority);
51     }
52 
53     modifier auth {
54         require(isAuthorized(msg.sender, msg.sig));
55         _;
56     }
57 
58     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
59         if (src == address(this)) {
60             return true;
61         } else if (src == owner) {
62             return true;
63         } else if (authority == DSAuthority(0)) {
64             return false;
65         } else {
66             return authority.canCall(src, this, sig);
67         }
68     }
69 }
70 
71 // This program is free software: you can redistribute it and/or modify
72 // it under the terms of the GNU General Public License as published by
73 // the Free Software Foundation, either version 3 of the License, or
74 // (at your option) any later version.
75 
76 // This program is distributed in the hope that it will be useful,
77 // but WITHOUT ANY WARRANTY; without even the implied warranty of
78 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
79 // GNU General Public License for more details.
80 
81 // You should have received a copy of the GNU General Public License
82 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
83 
84 contract DSMath {
85     function add(uint x, uint y) internal pure returns (uint z) {
86         require((z = x + y) >= x);
87     }
88     function sub(uint x, uint y) internal pure returns (uint z) {
89         require((z = x - y) <= x);
90     }
91     function mul(uint x, uint y) internal pure returns (uint z) {
92         require(y == 0 || (z = x * y) / y == x);
93     }
94 
95     function min(uint x, uint y) internal pure returns (uint z) {
96         return x <= y ? x : y;
97     }
98     function max(uint x, uint y) internal pure returns (uint z) {
99         return x >= y ? x : y;
100     }
101     function imin(int x, int y) internal pure returns (int z) {
102         return x <= y ? x : y;
103     }
104     function imax(int x, int y) internal pure returns (int z) {
105         return x >= y ? x : y;
106     }
107 
108     uint constant WAD = 10 ** 18;
109     uint constant RAY = 10 ** 27;
110 
111     function wmul(uint x, uint y) internal pure returns (uint z) {
112         z = add(mul(x, y), WAD / 2) / WAD;
113     }
114     function rmul(uint x, uint y) internal pure returns (uint z) {
115         z = add(mul(x, y), RAY / 2) / RAY;
116     }
117     function wdiv(uint x, uint y) internal pure returns (uint z) {
118         z = add(mul(x, WAD), y / 2) / y;
119     }
120     function rdiv(uint x, uint y) internal pure returns (uint z) {
121         z = add(mul(x, RAY), y / 2) / y;
122     }
123 
124     // This famous algorithm is called "exponentiation by squaring"
125     // and calculates x^n with x as fixed-point and n as regular unsigned.
126     //
127     // It's O(log n), instead of O(n) for naive repeated multiplication.
128     //
129     // These facts are why it works:
130     //
131     //  If n is even, then x^n = (x^2)^(n/2).
132     //  If n is odd,  then x^n = x * x^(n-1),
133     //   and applying the equation for even x gives
134     //    x^n = x * (x^2)^((n-1) / 2).
135     //
136     //  Also, EVM division is flooring and
137     //    floor[(n-1) / 2] = floor[n / 2].
138     //
139     function rpow(uint x, uint n) internal pure returns (uint z) {
140         z = n % 2 != 0 ? x : RAY;
141 
142         for (n /= 2; n != 0; n /= 2) {
143             x = rmul(x, x);
144 
145             if (n % 2 != 0) {
146                 z = rmul(z, x);
147             }
148         }
149     }
150 }
151 
152 // This program is free software: you can redistribute it and/or modify
153 // it under the terms of the GNU General Public License as published by
154 // the Free Software Foundation, either version 3 of the License, or
155 // (at your option) any later version.
156 
157 // This program is distributed in the hope that it will be useful,
158 // but WITHOUT ANY WARRANTY; without even the implied warranty of
159 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
160 // GNU General Public License for more details.
161 
162 // You should have received a copy of the GNU General Public License
163 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
164 
165 contract DSNote {
166     event LogNote(
167         bytes4   indexed  sig,
168         address  indexed  guy,
169         bytes32  indexed  foo,
170         bytes32  indexed  bar,
171         uint              wad,
172         bytes             fax
173     ) anonymous;
174 
175     modifier note {
176         bytes32 foo;
177         bytes32 bar;
178 
179         assembly {
180             foo := calldataload(4)
181             bar := calldataload(36)
182         }
183 
184         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
185 
186         _;
187     }
188 }
189 
190 // Copyright (C) 2017  DappHub, LLC
191 
192 // This program is free software: you can redistribute it and/or modify
193 // it under the terms of the GNU General Public License as published by
194 // the Free Software Foundation, either version 3 of the License, or
195 // (at your option) any later version.
196 
197 // This program is distributed in the hope that it will be useful,
198 // but WITHOUT ANY WARRANTY; without even the implied warranty of
199 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
200 // GNU General Public License for more details.
201 
202 // You should have received a copy of the GNU General Public License
203 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
204 
205 contract DSStop is DSNote, DSAuth {
206 
207     bool public stopped;
208 
209     modifier stoppable {
210         require(!stopped);
211         _;
212     }
213     function stop() public auth note {
214         stopped = true;
215     }
216     function start() public auth note {
217         stopped = false;
218     }
219 
220 }
221 
222 // See <https://github.com/ethereum/EIPs/issues/20>.
223 
224 // This file likely does not meet the threshold of originality
225 // required for copyright to apply.  As a result, this is free and
226 // unencumbered software belonging to the public domain.
227 
228 contract ERC20Events {
229     event Approval(address indexed src, address indexed guy, uint wad);
230     event Transfer(address indexed src, address indexed dst, uint wad);
231 }
232 
233 contract ERC20 is ERC20Events {
234     function totalSupply() public view returns (uint);
235     function balanceOf(address guy) public view returns (uint);
236     function allowance(address src, address guy) public view returns (uint);
237 
238     function approve(address guy, uint wad) public returns (bool);
239     function transfer(address dst, uint wad) public returns (bool);
240     function transferFrom(
241         address src, address dst, uint wad
242     ) public returns (bool);
243 }
244 
245 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
246 
247 // This program is free software: you can redistribute it and/or modify
248 // it under the terms of the GNU General Public License as published by
249 // the Free Software Foundation, either version 3 of the License, or
250 // (at your option) any later version.
251 
252 // This program is distributed in the hope that it will be useful,
253 // but WITHOUT ANY WARRANTY; without even the implied warranty of
254 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
255 // GNU General Public License for more details.
256 
257 // You should have received a copy of the GNU General Public License
258 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
259 
260 contract DSTokenBase is ERC20, DSMath {
261     uint256                                            _supply;
262     mapping (address => uint256)                       _balances;
263     mapping (address => mapping (address => uint256))  _approvals;
264 
265     function DSTokenBase(uint supply) public {
266         _balances[msg.sender] = supply;
267         _supply = supply;
268     }
269 
270     function totalSupply() public view returns (uint) {
271         return _supply;
272     }
273     function balanceOf(address src) public view returns (uint) {
274         return _balances[src];
275     }
276     function allowance(address src, address guy) public view returns (uint) {
277         return _approvals[src][guy];
278     }
279 
280     function transfer(address dst, uint wad) public returns (bool) {
281         return transferFrom(msg.sender, dst, wad);
282     }
283 
284     function transferFrom(address src, address dst, uint wad)
285         public
286         returns (bool)
287     {
288         if (src != msg.sender) {
289             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
290         }
291 
292         _balances[src] = sub(_balances[src], wad);
293         _balances[dst] = add(_balances[dst], wad);
294 
295         Transfer(src, dst, wad);
296 
297         return true;
298     }
299 
300     function approve(address guy, uint wad) public returns (bool) {
301         _approvals[msg.sender][guy] = wad;
302 
303         Approval(msg.sender, guy, wad);
304 
305         return true;
306     }
307 }
308 
309 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
310 
311 // This program is free software: you can redistribute it and/or modify
312 // it under the terms of the GNU General Public License as published by
313 // the Free Software Foundation, either version 3 of the License, or
314 // (at your option) any later version.
315 
316 // This program is distributed in the hope that it will be useful,
317 // but WITHOUT ANY WARRANTY; without even the implied warranty of
318 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
319 // GNU General Public License for more details.
320 
321 // You should have received a copy of the GNU General Public License
322 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
323 
324 contract DSToken is DSTokenBase(0), DSStop {
325 
326     bytes32  public  symbol;
327     uint256  public  decimals = 18; // standard token precision. override to customize
328 
329     function DSToken(bytes32 symbol_) public {
330         symbol = symbol_;
331     }
332 
333     event Mint(address indexed guy, uint wad);
334     event Burn(address indexed guy, uint wad);
335 
336     function approve(address guy) public stoppable returns (bool) {
337         return super.approve(guy, uint(-1));
338     }
339 
340     function approve(address guy, uint wad) public stoppable returns (bool) {
341         return super.approve(guy, wad);
342     }
343 
344     function transferFrom(address src, address dst, uint wad)
345         public
346         stoppable
347         returns (bool)
348     {
349         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
350             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
351         }
352 
353         _balances[src] = sub(_balances[src], wad);
354         _balances[dst] = add(_balances[dst], wad);
355 
356         Transfer(src, dst, wad);
357 
358         return true;
359     }
360 
361     function push(address dst, uint wad) public {
362         transferFrom(msg.sender, dst, wad);
363     }
364     function pull(address src, uint wad) public {
365         transferFrom(src, msg.sender, wad);
366     }
367     function move(address src, address dst, uint wad) public {
368         transferFrom(src, dst, wad);
369     }
370 
371     function mint(uint wad) public {
372         mint(msg.sender, wad);
373     }
374     function burn(uint wad) public {
375         burn(msg.sender, wad);
376     }
377     function mint(address guy, uint wad) public auth stoppable {
378         _balances[guy] = add(_balances[guy], wad);
379         _supply = add(_supply, wad);
380         Mint(guy, wad);
381     }
382     function burn(address guy, uint wad) public auth stoppable {
383         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
384             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
385         }
386 
387         _balances[guy] = sub(_balances[guy], wad);
388         _supply = sub(_supply, wad);
389         Burn(guy, wad);
390     }
391 
392     // Optional token name
393     bytes32   public  name = "";
394 
395     function setName(bytes32 name_) public auth {
396         name = name_;
397     }
398 }
399 
400 // Copyright (C) 2017  DappHub, LLC
401 
402 // This program is free software: you can redistribute it and/or modify
403 // it under the terms of the GNU General Public License as published by
404 // the Free Software Foundation, either version 3 of the License, or
405 // (at your option) any later version.
406 
407 // This program is distributed in the hope that it will be useful,
408 // but WITHOUT ANY WARRANTY; without even the implied warranty of
409 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
410 // GNU General Public License for more details.
411 
412 // You should have received a copy of the GNU General Public License
413 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
414 
415 contract DSThing is DSAuth, DSNote, DSMath {
416 
417     function S(string s) internal pure returns (bytes4) {
418         return bytes4(keccak256(s));
419     }
420 
421 }
422 
423 // Copyright (C) 2017  DappHub, LLC
424 
425 // This program is free software: you can redistribute it and/or modify
426 // it under the terms of the GNU General Public License as published by
427 // the Free Software Foundation, either version 3 of the License, or
428 // (at your option) any later version.
429 
430 // This program is distributed in the hope that it will be useful,
431 // but WITHOUT ANY WARRANTY; without even the implied warranty of
432 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
433 // GNU General Public License for more details.
434 
435 // You should have received a copy of the GNU General Public License
436 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
437 
438 contract DSValue is DSThing {
439     bool    has;
440     bytes32 val;
441     function peek() public view returns (bytes32, bool) {
442         return (val,has);
443     }
444     function read() public view returns (bytes32) {
445         bytes32 wut; bool haz;
446         (wut, haz) = peek();
447         assert(haz);
448         return wut;
449     }
450     function poke(bytes32 wut) public note auth {
451         val = wut;
452         has = true;
453     }
454     function void() public note auth {  // unset the value
455         has = false;
456     }
457 }
458 
459 // Copyright (C) 2017, 2018 Rain <rainbreak@riseup.net>
460 
461 // This program is free software: you can redistribute it and/or modify
462 // it under the terms of the GNU Affero General Public License as published by
463 // the Free Software Foundation, either version 3 of the License, or
464 // (at your option) any later version.
465 
466 // This program is distributed in the hope that it will be useful,
467 // but WITHOUT ANY WARRANTY; without even the implied warranty of
468 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
469 // GNU Affero General Public License for more details.
470 
471 // You should have received a copy of the GNU Affero General Public License
472 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
473 
474 contract SaiLPC is DSThing {
475     // This is a simple two token liquidity pool that uses an external
476     // price feed.
477 
478     // Makers
479     // - `pool` their gems and receive LPS tokens, which are a claim
480     //    on the pool.
481     // - `exit` and trade their LPS tokens for a share of the gems in
482     //    the pool
483 
484     // Takers
485     // - `take` and exchange one gem for another, whilst paying a
486     //   fee (the `gap`). The collected fee goes into the pool.
487 
488     // To avoid `pool`, `exit` being used to circumvent the taker fee,
489     // makers must pay the same fee on `exit`.
490 
491     // provide liquidity for this gem pair
492     ERC20    public  ref;
493     ERC20    public  alt;
494 
495     DSValue  public  pip;  // price feed, giving refs per alt
496     uint256  public  gap;  // spread, charged on `take`
497     DSToken  public  lps;  // 'liquidity provider shares', earns spread
498 
499     function SaiLPC(ERC20 ref_, ERC20 alt_, DSValue pip_, DSToken lps_) public {
500         ref = ref_;
501         alt = alt_;
502         pip = pip_;
503 
504         lps = lps_;
505         gap = WAD;
506     }
507 
508     function jump(uint wad) public note auth {
509         assert(wad != 0);
510         gap = wad;
511     }
512 
513     // ref per alt
514     function tag() public view returns (uint) {
515         return uint(pip.read());
516     }
517 
518     // total pool value
519     function pie() public view returns (uint) {
520         return add(ref.balanceOf(this), wmul(alt.balanceOf(this), tag()));
521     }
522 
523     // lps per ref
524     function per() public view returns (uint) {
525         return lps.totalSupply() == 0
526              ? RAY
527              : rdiv(lps.totalSupply(), pie());
528     }
529 
530     // {ref,alt} -> lps
531     function pool(ERC20 gem, uint wad) public note auth {
532         require(gem == alt || gem == ref);
533 
534         uint jam = (gem == ref) ? wad : wmul(wad, tag());
535         uint ink = rmul(jam, per());
536         lps.mint(ink);
537         lps.push(msg.sender, ink);
538 
539         gem.transferFrom(msg.sender, this, wad);
540     }
541 
542     // lps -> {ref,alt}
543     function exit(ERC20 gem, uint wad) public note auth {
544         require(gem == alt || gem == ref);
545 
546         uint jam = (gem == ref) ? wad : wmul(wad, tag());
547         uint ink = rmul(jam, per());
548         // pay fee to exit, unless you're the last out
549         ink = (jam == pie())? ink : wmul(gap, ink);
550         lps.pull(msg.sender, ink);
551         lps.burn(ink);
552 
553         gem.transfer(msg.sender, wad);
554     }
555 
556     // ref <-> alt
557     // TODO: meme 'swap'?
558     // TODO: mem 'yen' means to desire. pair with 'pay'? or 'ney'
559     function take(ERC20 gem, uint wad) public note auth {
560         require(gem == alt || gem == ref);
561 
562         uint jam = (gem == ref) ? wdiv(wad, tag()) : wmul(wad, tag());
563         jam = wmul(gap, jam);
564 
565         ERC20 pay = (gem == ref) ? alt : ref;
566         pay.transferFrom(msg.sender, this, jam);
567         gem.transfer(msg.sender, wad);
568     }
569 }
570 
571 /// @title Kyber Reserve contract
572 interface KyberReserveInterface {
573     function() payable;
574     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) external view returns(uint);
575     function withdraw(ERC20 token, uint amount, address destination) external returns(bool);
576     function getBalance(ERC20 token) external view returns(uint);
577 }
578 
579 interface WETHInterface {
580   function() external payable;
581   function deposit() external payable;
582   function withdraw(uint wad) external;
583 }
584 
585 contract WETH is WETHInterface, ERC20 { }
586 
587 contract LPCReserveWrapper is DSThing {
588     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
589 
590     KyberReserveInterface public reserve;
591     WETH public weth;
592     ERC20 public dai;
593     SaiLPC public lpc;
594 
595     function LPCReserveWrapper(KyberReserveInterface reserve_, WETH weth_, ERC20 dai_, SaiLPC lpc_) public {
596         assert(address(reserve_) != 0);
597         assert(address(weth_) != 0);
598         assert(address(dai_) != 0);
599         assert(address(lpc_) != 0);
600 
601         reserve = reserve_;
602         weth = weth_;
603         lpc = lpc_;
604         dai = dai_;
605     }
606 
607     function switchLPC(SaiLPC lpc_) public note auth {
608         assert(address(lpc_) != 0);
609         lpc = lpc_;
610     }
611 
612     function switchReserve(KyberReserveInterface reserve_) public note auth {
613         assert(address(reserve_) != 0);
614         reserve = reserve_;
615     }
616 
617     function() public payable { }
618 
619     function withdrawFromReserve(ERC20 token, uint amount) internal returns (bool success) {
620         if (token == weth) {
621             require(reserve.withdraw(ETH_TOKEN_ADDRESS, amount, this));
622             weth.deposit.value(amount)();
623         } else {
624             require(reserve.withdraw(token, amount, this));
625         }
626         return true;
627     }
628 
629     function transferToReserve(ERC20 token, uint amount) internal returns (bool success) {
630         if (token == weth) {
631             weth.withdraw(amount);
632             reserve.transfer(amount);
633         } else {
634             require(token.transfer(reserve, amount));
635         }
636         return true;
637     }
638 
639     function approveToken(ERC20 token, address who, uint wad) public note auth {
640         require(token.approve(who, wad));
641     }
642 
643     function take(ERC20 token, uint wad) public note auth {
644         require(token == weth || token == dai);
645         // Handle only ref == DAI and alt == WETH in this contract
646         require(lpc.ref() == dai);
647         require(lpc.alt() == weth);
648         // Get from LPC the amount that we need to have
649         uint amountToWithdraw = (token == dai) ? wdiv(wad, lpc.tag()) : wmul(wad, lpc.tag());
650         // Get the amount from the reserve
651         require(withdrawFromReserve((token == dai) ? weth : dai, amountToWithdraw));
652         // Magic
653         lpc.take(token, wad);
654         // Transfer DAI/WETH to reserve
655         require(transferToReserve(token, wad));
656     }
657 
658     function withdraw(ERC20 token, uint amount, address destination) public note auth {
659         if (token == ETH_TOKEN_ADDRESS) {
660             destination.transfer(amount);
661         } else {
662             require(token.transfer(destination, amount));
663         }
664     }
665 }