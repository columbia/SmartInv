1 pragma solidity ^0.4.21;
2 
3 // This program is free software: you can redistribute it and/or modify
4 // it under the terms of the GNU General Public License as published by
5 // the Free Software Foundation, either version 3 of the License, or
6 // (at your option) any later version.
7 
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU General Public License for more details.
12 
13 // You should have received a copy of the GNU General Public License
14 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
15 
16 contract DSAuthority {
17     function canCall(
18         address src, address dst, bytes4 sig
19     ) public view returns (bool);
20 }
21 
22 contract DSAuthEvents {
23     event LogSetAuthority (address indexed authority);
24     event LogSetOwner     (address indexed owner);
25 }
26 
27 contract DSAuth is DSAuthEvents {
28     DSAuthority  public  authority;
29     address      public  owner;
30 
31     function DSAuth() public {
32         owner = msg.sender;
33         LogSetOwner(msg.sender);
34     }
35 
36     function setOwner(address owner_)
37         public
38         auth
39     {
40         owner = owner_;
41         LogSetOwner(owner);
42     }
43 
44     function setAuthority(DSAuthority authority_)
45         public
46         auth
47     {
48         authority = authority_;
49         LogSetAuthority(authority);
50     }
51 
52     modifier auth {
53         require(isAuthorized(msg.sender, msg.sig));
54         _;
55     }
56 
57     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
58         if (src == address(this)) {
59             return true;
60         } else if (src == owner) {
61             return true;
62         } else if (authority == DSAuthority(0)) {
63             return false;
64         } else {
65             return authority.canCall(src, this, sig);
66         }
67     }
68 }
69 
70 /// math.sol -- mixin for inline numerical wizardry
71 
72 // This program is free software: you can redistribute it and/or modify
73 // it under the terms of the GNU General Public License as published by
74 // the Free Software Foundation, either version 3 of the License, or
75 // (at your option) any later version.
76 
77 // This program is distributed in the hope that it will be useful,
78 // but WITHOUT ANY WARRANTY; without even the implied warranty of
79 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
80 // GNU General Public License for more details.
81 
82 // You should have received a copy of the GNU General Public License
83 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
84 
85 contract DSMath {
86     function add(uint x, uint y) internal pure returns (uint z) {
87         require((z = x + y) >= x);
88     }
89     function sub(uint x, uint y) internal pure returns (uint z) {
90         require((z = x - y) <= x);
91     }
92     function mul(uint x, uint y) internal pure returns (uint z) {
93         require(y == 0 || (z = x * y) / y == x);
94     }
95 
96     function min(uint x, uint y) internal pure returns (uint z) {
97         return x <= y ? x : y;
98     }
99     function max(uint x, uint y) internal pure returns (uint z) {
100         return x >= y ? x : y;
101     }
102     function imin(int x, int y) internal pure returns (int z) {
103         return x <= y ? x : y;
104     }
105     function imax(int x, int y) internal pure returns (int z) {
106         return x >= y ? x : y;
107     }
108 
109     uint constant WAD = 10 ** 18;
110     uint constant RAY = 10 ** 27;
111 
112     function wmul(uint x, uint y) internal pure returns (uint z) {
113         z = add(mul(x, y), WAD / 2) / WAD;
114     }
115     function rmul(uint x, uint y) internal pure returns (uint z) {
116         z = add(mul(x, y), RAY / 2) / RAY;
117     }
118     function wdiv(uint x, uint y) internal pure returns (uint z) {
119         z = add(mul(x, WAD), y / 2) / y;
120     }
121     function rdiv(uint x, uint y) internal pure returns (uint z) {
122         z = add(mul(x, RAY), y / 2) / y;
123     }
124 
125     // This famous algorithm is called "exponentiation by squaring"
126     // and calculates x^n with x as fixed-point and n as regular unsigned.
127     //
128     // It's O(log n), instead of O(n) for naive repeated multiplication.
129     //
130     // These facts are why it works:
131     //
132     //  If n is even, then x^n = (x^2)^(n/2).
133     //  If n is odd,  then x^n = x * x^(n-1),
134     //   and applying the equation for even x gives
135     //    x^n = x * (x^2)^((n-1) / 2).
136     //
137     //  Also, EVM division is flooring and
138     //    floor[(n-1) / 2] = floor[n / 2].
139     //
140     function rpow(uint x, uint n) internal pure returns (uint z) {
141         z = n % 2 != 0 ? x : RAY;
142 
143         for (n /= 2; n != 0; n /= 2) {
144             x = rmul(x, x);
145 
146             if (n % 2 != 0) {
147                 z = rmul(z, x);
148             }
149         }
150     }
151 }
152 
153 /// note.sol -- the `note' modifier, for logging calls as events
154 
155 // This program is free software: you can redistribute it and/or modify
156 // it under the terms of the GNU General Public License as published by
157 // the Free Software Foundation, either version 3 of the License, or
158 // (at your option) any later version.
159 
160 // This program is distributed in the hope that it will be useful,
161 // but WITHOUT ANY WARRANTY; without even the implied warranty of
162 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
163 // GNU General Public License for more details.
164 
165 // You should have received a copy of the GNU General Public License
166 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
167 
168 contract DSNote {
169     event LogNote(
170         bytes4   indexed  sig,
171         address  indexed  guy,
172         bytes32  indexed  foo,
173         bytes32  indexed  bar,
174         uint              wad,
175         bytes             fax
176     ) anonymous;
177 
178     modifier note {
179         bytes32 foo;
180         bytes32 bar;
181 
182         assembly {
183             foo := calldataload(4)
184             bar := calldataload(36)
185         }
186 
187         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
188 
189         _;
190     }
191 }
192 
193 /// stop.sol -- mixin for enable/disable functionality
194 
195 // Copyright (C) 2017  DappHub, LLC
196 
197 // This program is free software: you can redistribute it and/or modify
198 // it under the terms of the GNU General Public License as published by
199 // the Free Software Foundation, either version 3 of the License, or
200 // (at your option) any later version.
201 
202 // This program is distributed in the hope that it will be useful,
203 // but WITHOUT ANY WARRANTY; without even the implied warranty of
204 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
205 // GNU General Public License for more details.
206 
207 // You should have received a copy of the GNU General Public License
208 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
209 
210 contract DSStop is DSNote, DSAuth {
211 
212     bool public stopped;
213 
214     modifier stoppable {
215         require(!stopped);
216         _;
217     }
218     function stop() public auth note {
219         stopped = true;
220     }
221     function start() public auth note {
222         stopped = false;
223     }
224 
225 }
226 
227 /// erc20.sol -- API for the ERC20 token standard
228 
229 // See <https://github.com/ethereum/EIPs/issues/20>.
230 
231 // This file likely does not meet the threshold of originality
232 // required for copyright to apply.  As a result, this is free and
233 // unencumbered software belonging to the public domain.
234 
235 contract ERC20Events {
236     event Approval(address indexed src, address indexed guy, uint wad);
237     event Transfer(address indexed src, address indexed dst, uint wad);
238 }
239 
240 contract ERC20 is ERC20Events {
241     function totalSupply() public view returns (uint);
242     function balanceOf(address guy) public view returns (uint);
243     function allowance(address src, address guy) public view returns (uint);
244 
245     function approve(address guy, uint wad) public returns (bool);
246     function transfer(address dst, uint wad) public returns (bool);
247     function transferFrom(
248         address src, address dst, uint wad
249     ) public returns (bool);
250 }
251 
252 /// base.sol -- basic ERC20 implementation
253 
254 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
255 
256 // This program is free software: you can redistribute it and/or modify
257 // it under the terms of the GNU General Public License as published by
258 // the Free Software Foundation, either version 3 of the License, or
259 // (at your option) any later version.
260 
261 // This program is distributed in the hope that it will be useful,
262 // but WITHOUT ANY WARRANTY; without even the implied warranty of
263 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
264 // GNU General Public License for more details.
265 
266 // You should have received a copy of the GNU General Public License
267 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
268 
269 contract DSTokenBase is ERC20, DSMath {
270     uint256                                            _supply;
271     mapping (address => uint256)                       _balances;
272     mapping (address => mapping (address => uint256))  _approvals;
273 
274     function DSTokenBase(uint supply) public {
275         _balances[msg.sender] = supply;
276         _supply = supply;
277     }
278 
279     function totalSupply() public view returns (uint) {
280         return _supply;
281     }
282     function balanceOf(address src) public view returns (uint) {
283         return _balances[src];
284     }
285     function allowance(address src, address guy) public view returns (uint) {
286         return _approvals[src][guy];
287     }
288 
289     function transfer(address dst, uint wad) public returns (bool) {
290         return transferFrom(msg.sender, dst, wad);
291     }
292 
293     function transferFrom(address src, address dst, uint wad)
294         public
295         returns (bool)
296     {
297         if (src != msg.sender) {
298             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
299         }
300 
301         _balances[src] = sub(_balances[src], wad);
302         _balances[dst] = add(_balances[dst], wad);
303 
304         Transfer(src, dst, wad);
305 
306         return true;
307     }
308 
309     function approve(address guy, uint wad) public returns (bool) {
310         _approvals[msg.sender][guy] = wad;
311 
312         Approval(msg.sender, guy, wad);
313 
314         return true;
315     }
316 }
317 
318 /// token.sol -- ERC20 implementation with minting and burning
319 
320 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
321 
322 // This program is free software: you can redistribute it and/or modify
323 // it under the terms of the GNU General Public License as published by
324 // the Free Software Foundation, either version 3 of the License, or
325 // (at your option) any later version.
326 
327 // This program is distributed in the hope that it will be useful,
328 // but WITHOUT ANY WARRANTY; without even the implied warranty of
329 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
330 // GNU General Public License for more details.
331 
332 // You should have received a copy of the GNU General Public License
333 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
334 
335 contract DSToken is DSTokenBase(0), DSStop {
336 
337     bytes32  public  symbol;
338     uint256  public  decimals = 18; // standard token precision. override to customize
339 
340     function DSToken(bytes32 symbol_) public {
341         symbol = symbol_;
342     }
343 
344     event Mint(address indexed guy, uint wad);
345     event Burn(address indexed guy, uint wad);
346 
347     function approve(address guy) public stoppable returns (bool) {
348         return super.approve(guy, uint(-1));
349     }
350 
351     function approve(address guy, uint wad) public stoppable returns (bool) {
352         return super.approve(guy, wad);
353     }
354 
355     function transferFrom(address src, address dst, uint wad)
356         public
357         stoppable
358         returns (bool)
359     {
360         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
361             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
362         }
363 
364         _balances[src] = sub(_balances[src], wad);
365         _balances[dst] = add(_balances[dst], wad);
366 
367         Transfer(src, dst, wad);
368 
369         return true;
370     }
371 
372     function push(address dst, uint wad) public {
373         transferFrom(msg.sender, dst, wad);
374     }
375     function pull(address src, uint wad) public {
376         transferFrom(src, msg.sender, wad);
377     }
378     function move(address src, address dst, uint wad) public {
379         transferFrom(src, dst, wad);
380     }
381 
382     function mint(uint wad) public {
383         mint(msg.sender, wad);
384     }
385     function burn(uint wad) public {
386         burn(msg.sender, wad);
387     }
388     function mint(address guy, uint wad) public auth stoppable {
389         _balances[guy] = add(_balances[guy], wad);
390         _supply = add(_supply, wad);
391         Mint(guy, wad);
392     }
393     function burn(address guy, uint wad) public auth stoppable {
394         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
395             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
396         }
397 
398         _balances[guy] = sub(_balances[guy], wad);
399         _supply = sub(_supply, wad);
400         Burn(guy, wad);
401     }
402 
403     // Optional token name
404     bytes32   public  name = "";
405 
406     function setName(bytes32 name_) public auth {
407         name = name_;
408     }
409 }
410 // thing.sol - `auth` with handy mixins. your things should be DSThings
411 
412 // Copyright (C) 2017  DappHub, LLC
413 
414 // This program is free software: you can redistribute it and/or modify
415 // it under the terms of the GNU General Public License as published by
416 // the Free Software Foundation, either version 3 of the License, or
417 // (at your option) any later version.
418 
419 // This program is distributed in the hope that it will be useful,
420 // but WITHOUT ANY WARRANTY; without even the implied warranty of
421 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
422 // GNU General Public License for more details.
423 
424 // You should have received a copy of the GNU General Public License
425 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
426 
427 contract DSThing is DSAuth, DSNote, DSMath {
428 
429     function S(string s) internal pure returns (bytes4) {
430         return bytes4(keccak256(s));
431     }
432 
433 }
434 
435 /// value.sol - a value is a simple thing, it can be get and set
436 
437 // Copyright (C) 2017  DappHub, LLC
438 
439 // This program is free software: you can redistribute it and/or modify
440 // it under the terms of the GNU General Public License as published by
441 // the Free Software Foundation, either version 3 of the License, or
442 // (at your option) any later version.
443 
444 // This program is distributed in the hope that it will be useful,
445 // but WITHOUT ANY WARRANTY; without even the implied warranty of
446 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
447 // GNU General Public License for more details.
448 
449 // You should have received a copy of the GNU General Public License
450 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
451 
452 contract DSValue is DSThing {
453     bool    has;
454     bytes32 val;
455     function peek() public view returns (bytes32, bool) {
456         return (val,has);
457     }
458     function read() public view returns (bytes32) {
459         bytes32 wut; bool haz;
460         (wut, haz) = peek();
461         assert(haz);
462         return wut;
463     }
464     function poke(bytes32 wut) public note auth {
465         val = wut;
466         has = true;
467     }
468     function void() public note auth {  // unset the value
469         has = false;
470     }
471 }
472 
473 /// lpc.sol -- really dumb liquidity pool
474 
475 // Copyright (C) 2017, 2018 Rain <rainbreak@riseup.net>
476 
477 // This program is free software: you can redistribute it and/or modify
478 // it under the terms of the GNU Affero General Public License as published by
479 // the Free Software Foundation, either version 3 of the License, or
480 // (at your option) any later version.
481 
482 // This program is distributed in the hope that it will be useful,
483 // but WITHOUT ANY WARRANTY; without even the implied warranty of
484 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
485 // GNU Affero General Public License for more details.
486 
487 // You should have received a copy of the GNU Affero General Public License
488 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
489 
490 contract SaiLPC is DSThing {
491     // This is a simple two token liquidity pool that uses an external
492     // price feed.
493 
494     // Makers
495     // - `pool` their gems and receive LPS tokens, which are a claim
496     //    on the pool.
497     // - `exit` and trade their LPS tokens for a share of the gems in
498     //    the pool
499 
500     // Takers
501     // - `take` and exchange one gem for another, whilst paying a
502     //   fee (the `gap`). The collected fee goes into the pool.
503 
504     // To avoid `pool`, `exit` being used to circumvent the taker fee,
505     // makers must pay the same fee on `exit`.
506 
507     // provide liquidity for this gem pair
508     ERC20    public  ref;
509     ERC20    public  alt;
510 
511     DSValue  public  pip;  // price feed, giving refs per alt
512     uint256  public  gap;  // spread, charged on `take`
513     DSToken  public  lps;  // 'liquidity provider shares', earns spread
514 
515     function SaiLPC(ERC20 ref_, ERC20 alt_, DSValue pip_, DSToken lps_) public {
516         ref = ref_;
517         alt = alt_;
518         pip = pip_;
519 
520         lps = lps_;
521         gap = WAD;
522     }
523 
524     function jump(uint wad) public note auth {
525         assert(wad != 0);
526         gap = wad;
527     }
528 
529     // ref per alt
530     function tag() public view returns (uint) {
531         return uint(pip.read());
532     }
533 
534     // total pool value
535     function pie() public view returns (uint) {
536         return add(ref.balanceOf(this), wmul(alt.balanceOf(this), tag()));
537     }
538 
539     // lps per ref
540     function per() public view returns (uint) {
541         return lps.totalSupply() == 0
542              ? RAY
543              : rdiv(lps.totalSupply(), pie());
544     }
545 
546     // {ref,alt} -> lps
547     function pool(ERC20 gem, uint wad) public note auth {
548         require(gem == alt || gem == ref);
549 
550         uint jam = (gem == ref) ? wad : wmul(wad, tag());
551         uint ink = rmul(jam, per());
552         lps.mint(ink);
553         lps.push(msg.sender, ink);
554 
555         gem.transferFrom(msg.sender, this, wad);
556     }
557 
558     // lps -> {ref,alt}
559     function exit(ERC20 gem, uint wad) public note auth {
560         require(gem == alt || gem == ref);
561 
562         uint jam = (gem == ref) ? wad : wmul(wad, tag());
563         uint ink = rmul(jam, per());
564         // pay fee to exit, unless you're the last out
565         ink = (jam == pie())? ink : wmul(gap, ink);
566         lps.pull(msg.sender, ink);
567         lps.burn(ink);
568 
569         gem.transfer(msg.sender, wad);
570     }
571 
572     // ref <-> alt
573     // TODO: meme 'swap'?
574     // TODO: mem 'yen' means to desire. pair with 'pay'? or 'ney'
575     function take(ERC20 gem, uint wad) public note auth {
576         require(gem == alt || gem == ref);
577 
578         uint jam = (gem == ref) ? wdiv(wad, tag()) : wmul(wad, tag());
579         jam = wmul(gap, jam);
580 
581         ERC20 pay = (gem == ref) ? alt : ref;
582         pay.transferFrom(msg.sender, this, jam);
583         gem.transfer(msg.sender, wad);
584     }
585 }
586 
587 /// @title Kyber Reserve contract
588 interface KyberReserveInterface {
589     function() payable;
590     function getConversionRate(ERC20 src, ERC20 dest, uint srcQty, uint blockNumber) external view returns(uint);
591     function withdraw(ERC20 token, uint amount, address destination) external returns(bool);
592     function getBalance(ERC20 token) external view returns(uint);
593 }
594 
595 interface WETHInterface {
596   function() external payable;
597   function deposit() external payable;
598   function withdraw(uint wad) external;
599 }
600 
601 contract WETH is WETHInterface, ERC20 { }
602 
603 contract LPCReserveWrapper is DSThing {
604     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
605 
606     KyberReserveInterface public reserve;
607     WETH public weth;
608     ERC20 public dai;
609     SaiLPC public lpc;
610 
611     function LPCReserveWrapper(KyberReserveInterface reserve_, WETH weth_, ERC20 dai_, SaiLPC lpc_) public {
612         assert(address(reserve_) != 0);
613         assert(address(weth_) != 0);
614         assert(address(dai_) != 0);
615         assert(address(lpc_) != 0);
616 
617         reserve = reserve_;
618         weth = weth_;
619         lpc = lpc_;
620         dai = dai_;
621     }
622 
623     function switchLPC(SaiLPC lpc_) public note auth {
624         assert(address(lpc_) != 0);
625         lpc = lpc_;
626     }
627 
628     function switchReserve(KyberReserveInterface reserve_) public note auth {
629         assert(address(reserve_) != 0);
630         reserve = reserve_;
631     }
632 
633     function() public payable { }
634 
635     function withdrawFromReserve(ERC20 token, uint amount) internal returns (bool success) {
636         if (token == weth) {
637             require(reserve.withdraw(ETH_TOKEN_ADDRESS, amount, this));
638             weth.deposit.value(amount)();
639         } else {
640             require(reserve.withdraw(token, amount, this));
641         }
642         return true;
643     }
644 
645     function transferToReserve(ERC20 token, uint amount) internal returns (bool success) {
646         if (token == weth) {
647             weth.withdraw(amount);
648             reserve.transfer(amount);
649         } else {
650             require(token.transfer(reserve, amount));
651         }
652         return true;
653     }
654 
655     function approveToken(ERC20 token, address who, uint wad) public note auth {
656         require(token.approve(who, wad));
657     }
658 
659     event Take(
660         address indexed origin,
661         address indexed srcToken,
662         uint srcAmount,
663         address indexed destToken,
664         uint destAmount,
665         address destAddress,
666         uint tag
667     );
668 
669     function take(ERC20 token, uint wad) public auth {
670         require(token == weth || token == dai);
671         // Handle only ref == DAI and alt == WETH in this contract
672         require(lpc.ref() == dai);
673         require(lpc.alt() == weth);
674         // Get from LPC the amount that we need to have
675         uint tag = lpc.tag();
676         uint amountToWithdraw = (token == dai) ? wdiv(wad, tag) : wmul(wad, tag);
677         ERC20 withdrawToken = (token == dai) ? weth : dai;
678         // Get the amount from the reserve
679         require(withdrawFromReserve(withdrawToken, amountToWithdraw));
680         // Magic
681         lpc.take(token, wad);
682         // Transfer DAI/WETH to reserve
683         require(transferToReserve(token, wad));
684         emit Take(reserve, withdrawToken, amountToWithdraw, token, wad, lpc, tag);
685     }
686 
687     function withdraw(ERC20 token, uint amount, address destination) public note auth {
688         if (token == ETH_TOKEN_ADDRESS) {
689             destination.transfer(amount);
690         } else {
691             require(token.transfer(destination, amount));
692         }
693     }
694 }