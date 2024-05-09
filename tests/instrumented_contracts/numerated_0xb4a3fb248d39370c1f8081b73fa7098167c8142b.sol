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
190 /// stop.sol -- mixin for enable/disable functionality
191 
192 // Copyright (C) 2017  DappHub, LLC
193 
194 // This program is free software: you can redistribute it and/or modify
195 // it under the terms of the GNU General Public License as published by
196 // the Free Software Foundation, either version 3 of the License, or
197 // (at your option) any later version.
198 
199 // This program is distributed in the hope that it will be useful,
200 // but WITHOUT ANY WARRANTY; without even the implied warranty of
201 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
202 // GNU General Public License for more details.
203 
204 // You should have received a copy of the GNU General Public License
205 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
206 
207 contract DSStop is DSNote, DSAuth {
208 
209     bool public stopped;
210 
211     modifier stoppable {
212         require(!stopped);
213         _;
214     }
215     function stop() public auth note {
216         stopped = true;
217     }
218     function start() public auth note {
219         stopped = false;
220     }
221 
222 }
223 
224 /// erc20.sol -- API for the ERC20 token standard
225 
226 // See <https://github.com/ethereum/EIPs/issues/20>.
227 
228 // This file likely does not meet the threshold of originality
229 // required for copyright to apply.  As a result, this is free and
230 // unencumbered software belonging to the public domain.
231 
232 contract ERC20Events {
233     event Approval(address indexed src, address indexed guy, uint wad);
234     event Transfer(address indexed src, address indexed dst, uint wad);
235 }
236 
237 contract ERC20 is ERC20Events {
238     function totalSupply() public view returns (uint);
239     function balanceOf(address guy) public view returns (uint);
240     function allowance(address src, address guy) public view returns (uint);
241 
242     function approve(address guy, uint wad) public returns (bool);
243     function transfer(address dst, uint wad) public returns (bool);
244     function transferFrom(
245         address src, address dst, uint wad
246     ) public returns (bool);
247 }
248 
249 /// base.sol -- basic ERC20 implementation
250 
251 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
252 
253 // This program is free software: you can redistribute it and/or modify
254 // it under the terms of the GNU General Public License as published by
255 // the Free Software Foundation, either version 3 of the License, or
256 // (at your option) any later version.
257 
258 // This program is distributed in the hope that it will be useful,
259 // but WITHOUT ANY WARRANTY; without even the implied warranty of
260 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
261 // GNU General Public License for more details.
262 
263 // You should have received a copy of the GNU General Public License
264 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
265 
266 contract DSTokenBase is ERC20, DSMath {
267     uint256                                            _supply;
268     mapping (address => uint256)                       _balances;
269     mapping (address => mapping (address => uint256))  _approvals;
270 
271     function DSTokenBase(uint supply) public {
272         _balances[msg.sender] = supply;
273         _supply = supply;
274     }
275 
276     function totalSupply() public view returns (uint) {
277         return _supply;
278     }
279     function balanceOf(address src) public view returns (uint) {
280         return _balances[src];
281     }
282     function allowance(address src, address guy) public view returns (uint) {
283         return _approvals[src][guy];
284     }
285 
286     function transfer(address dst, uint wad) public returns (bool) {
287         return transferFrom(msg.sender, dst, wad);
288     }
289 
290     function transferFrom(address src, address dst, uint wad)
291         public
292         returns (bool)
293     {
294         if (src != msg.sender) {
295             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
296         }
297 
298         _balances[src] = sub(_balances[src], wad);
299         _balances[dst] = add(_balances[dst], wad);
300 
301         Transfer(src, dst, wad);
302 
303         return true;
304     }
305 
306     function approve(address guy, uint wad) public returns (bool) {
307         _approvals[msg.sender][guy] = wad;
308 
309         Approval(msg.sender, guy, wad);
310 
311         return true;
312     }
313 }
314 
315 /// token.sol -- ERC20 implementation with minting and burning
316 
317 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
318 
319 // This program is free software: you can redistribute it and/or modify
320 // it under the terms of the GNU General Public License as published by
321 // the Free Software Foundation, either version 3 of the License, or
322 // (at your option) any later version.
323 
324 // This program is distributed in the hope that it will be useful,
325 // but WITHOUT ANY WARRANTY; without even the implied warranty of
326 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
327 // GNU General Public License for more details.
328 
329 // You should have received a copy of the GNU General Public License
330 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
331 
332 contract DSToken is DSTokenBase(0), DSStop {
333 
334     bytes32  public  symbol;
335     uint256  public  decimals = 18; // standard token precision. override to customize
336 
337     function DSToken(bytes32 symbol_) public {
338         symbol = symbol_;
339     }
340 
341     event Mint(address indexed guy, uint wad);
342     event Burn(address indexed guy, uint wad);
343 
344     function approve(address guy) public stoppable returns (bool) {
345         return super.approve(guy, uint(-1));
346     }
347 
348     function approve(address guy, uint wad) public stoppable returns (bool) {
349         return super.approve(guy, wad);
350     }
351 
352     function transferFrom(address src, address dst, uint wad)
353         public
354         stoppable
355         returns (bool)
356     {
357         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
358             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
359         }
360 
361         _balances[src] = sub(_balances[src], wad);
362         _balances[dst] = add(_balances[dst], wad);
363 
364         Transfer(src, dst, wad);
365 
366         return true;
367     }
368 
369     function push(address dst, uint wad) public {
370         transferFrom(msg.sender, dst, wad);
371     }
372     function pull(address src, uint wad) public {
373         transferFrom(src, msg.sender, wad);
374     }
375     function move(address src, address dst, uint wad) public {
376         transferFrom(src, dst, wad);
377     }
378 
379     function mint(uint wad) public {
380         mint(msg.sender, wad);
381     }
382     function burn(uint wad) public {
383         burn(msg.sender, wad);
384     }
385     function mint(address guy, uint wad) public auth stoppable {
386         _balances[guy] = add(_balances[guy], wad);
387         _supply = add(_supply, wad);
388         Mint(guy, wad);
389     }
390     function burn(address guy, uint wad) public auth stoppable {
391         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
392             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
393         }
394 
395         _balances[guy] = sub(_balances[guy], wad);
396         _supply = sub(_supply, wad);
397         Burn(guy, wad);
398     }
399 
400     // Optional token name
401     bytes32   public  name = "";
402 
403     function setName(bytes32 name_) public auth {
404         name = name_;
405     }
406 }
407 
408 // thing.sol - `auth` with handy mixins. your things should be DSThings
409 
410 // Copyright (C) 2017  DappHub, LLC
411 
412 // This program is free software: you can redistribute it and/or modify
413 // it under the terms of the GNU General Public License as published by
414 // the Free Software Foundation, either version 3 of the License, or
415 // (at your option) any later version.
416 
417 // This program is distributed in the hope that it will be useful,
418 // but WITHOUT ANY WARRANTY; without even the implied warranty of
419 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
420 // GNU General Public License for more details.
421 
422 // You should have received a copy of the GNU General Public License
423 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
424 
425 contract DSThing is DSAuth, DSNote, DSMath {
426 
427     function S(string s) internal pure returns (bytes4) {
428         return bytes4(keccak256(s));
429     }
430 
431 }
432 
433 /// value.sol - a value is a simple thing, it can be get and set
434 
435 // Copyright (C) 2017  DappHub, LLC
436 
437 // This program is free software: you can redistribute it and/or modify
438 // it under the terms of the GNU General Public License as published by
439 // the Free Software Foundation, either version 3 of the License, or
440 // (at your option) any later version.
441 
442 // This program is distributed in the hope that it will be useful,
443 // but WITHOUT ANY WARRANTY; without even the implied warranty of
444 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
445 // GNU General Public License for more details.
446 
447 // You should have received a copy of the GNU General Public License
448 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
449 
450 contract DSValue is DSThing {
451     bool    has;
452     bytes32 val;
453     function peek() public view returns (bytes32, bool) {
454         return (val,has);
455     }
456     function read() public view returns (bytes32) {
457         bytes32 wut; bool haz;
458         (wut, haz) = peek();
459         assert(haz);
460         return wut;
461     }
462     function poke(bytes32 wut) public note auth {
463         val = wut;
464         has = true;
465     }
466     function void() public note auth {  // unset the value
467         has = false;
468     }
469 }
470 
471 /// lpc.sol -- really dumb liquidity pool
472 
473 // Copyright (C) 2017, 2018 Rain <rainbreak@riseup.net>
474 
475 // This program is free software: you can redistribute it and/or modify
476 // it under the terms of the GNU Affero General Public License as published by
477 // the Free Software Foundation, either version 3 of the License, or
478 // (at your option) any later version.
479 
480 // This program is distributed in the hope that it will be useful,
481 // but WITHOUT ANY WARRANTY; without even the implied warranty of
482 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
483 // GNU Affero General Public License for more details.
484 
485 // You should have received a copy of the GNU Affero General Public License
486 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
487 
488 contract SaiLPC is DSThing {
489     // This is a simple two token liquidity pool that uses an external
490     // price feed.
491 
492     // Makers
493     // - `pool` their gems and receive LPS tokens, which are a claim
494     //    on the pool.
495     // - `exit` and trade their LPS tokens for a share of the gems in
496     //    the pool
497 
498     // Takers
499     // - `take` and exchange one gem for another, whilst paying a
500     //   fee (the `gap`). The collected fee goes into the pool.
501 
502     // To avoid `pool`, `exit` being used to circumvent the taker fee,
503     // makers must pay the same fee on `exit`.
504 
505     // provide liquidity for this gem pair
506     ERC20    public  ref;
507     ERC20    public  alt;
508 
509     DSValue  public  pip;  // price feed, giving refs per alt
510     uint256  public  gap;  // spread, charged on `take`
511     DSToken  public  lps;  // 'liquidity provider shares', earns spread
512 
513     function SaiLPC(ERC20 ref_, ERC20 alt_, DSValue pip_, DSToken lps_) public {
514         ref = ref_;
515         alt = alt_;
516         pip = pip_;
517 
518         lps = lps_;
519         gap = WAD;
520     }
521 
522     function jump(uint wad) public note auth {
523         assert(wad != 0);
524         gap = wad;
525     }
526 
527     // ref per alt
528     function tag() public view returns (uint) {
529         return uint(pip.read());
530     }
531 
532     // total pool value
533     function pie() public view returns (uint) {
534         return add(ref.balanceOf(this), wmul(alt.balanceOf(this), tag()));
535     }
536 
537     // lps per ref
538     function per() public view returns (uint) {
539         return lps.totalSupply() == 0
540              ? RAY
541              : rdiv(lps.totalSupply(), pie());
542     }
543 
544     // {ref,alt} -> lps
545     function pool(ERC20 gem, uint wad) public note auth {
546         require(gem == alt || gem == ref);
547 
548         uint jam = (gem == ref) ? wad : wmul(wad, tag());
549         uint ink = rmul(jam, per());
550         lps.mint(ink);
551         lps.push(msg.sender, ink);
552 
553         gem.transferFrom(msg.sender, this, wad);
554     }
555 
556     // lps -> {ref,alt}
557     function exit(ERC20 gem, uint wad) public note auth {
558         require(gem == alt || gem == ref);
559 
560         uint jam = (gem == ref) ? wad : wmul(wad, tag());
561         uint ink = rmul(jam, per());
562         // pay fee to exit, unless you're the last out
563         ink = (jam == pie())? ink : wmul(gap, ink);
564         lps.pull(msg.sender, ink);
565         lps.burn(ink);
566 
567         gem.transfer(msg.sender, wad);
568     }
569 
570     // ref <-> alt
571     // TODO: meme 'swap'?
572     // TODO: mem 'yen' means to desire. pair with 'pay'? or 'ney'
573     function take(ERC20 gem, uint wad) public note auth {
574         require(gem == alt || gem == ref);
575 
576         uint jam = (gem == ref) ? wdiv(wad, tag()) : wmul(wad, tag());
577         jam = wmul(gap, jam);
578 
579         ERC20 pay = (gem == ref) ? alt : ref;
580         pay.transferFrom(msg.sender, this, jam);
581         gem.transfer(msg.sender, wad);
582     }
583 }
584 
585 interface WETHInterface {
586   function() external payable;
587   function deposit() external payable;
588   function withdraw(uint wad) external;
589 }
590 
591 contract WETH is WETHInterface, ERC20 { }
592 
593 contract LPCWalletReserveWrapper is DSThing {
594     ERC20 constant internal ETH_TOKEN_ADDRESS = ERC20(0x00eeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee);
595 
596     address public walletReserve;
597     WETH public weth;
598     ERC20 public dai;
599     SaiLPC public lpc;
600 
601     function LPCWalletReserveWrapper(address walletReserve_, WETH weth_, ERC20 dai_, SaiLPC lpc_) public {
602         assert(address(walletReserve_) != 0);
603         assert(address(weth_) != 0);
604         assert(address(dai_) != 0);
605         assert(address(lpc_) != 0);
606 
607         walletReserve = walletReserve_;
608         weth = weth_;
609         lpc = lpc_;
610         dai = dai_;
611     }
612 
613     function switchLPC(SaiLPC lpc_) public note auth {
614         assert(address(lpc_) != 0);
615         lpc = lpc_;
616     }
617 
618     function switchReserve(address walletReserve_) public note auth {
619         assert(address(walletReserve_) != 0);
620         walletReserve = walletReserve_;
621     }
622 
623     function approveToken(ERC20 token, address who, uint wad) public note auth {
624         require(token.approve(who, wad));
625     }
626 
627     event Take(
628         address indexed origin,
629         address indexed srcToken,
630         uint srcAmount,
631         address indexed destToken,
632         uint destAmount,
633         address destAddress,
634         uint tag
635     );
636 
637     function take(ERC20 token, uint wad) public auth {
638         require(token == weth || token == dai);
639         // Handle only ref == DAI and alt == WETH in this contract
640         require(lpc.ref() == dai);
641         require(lpc.alt() == weth);
642         // Get from LPC the amount that we need to have
643         uint tag = lpc.tag();
644         uint amountToWithdraw = (token == dai) ? wdiv(wad, tag) : wmul(wad, tag);
645         ERC20 withdrawToken = (token == dai) ? weth : dai;
646         // Get the amount from the reserve
647         require(withdrawToken.transferFrom(walletReserve, this, amountToWithdraw));
648         // Magic
649         lpc.take(token, wad);
650         // Transfer DAI/WETH to reserve
651         require(token.transfer(walletReserve, wad));
652         emit Take(walletReserve, withdrawToken, amountToWithdraw, token, wad, lpc, tag);
653     }
654 
655     function withdraw(ERC20 token, uint amount, address destination) public note auth {
656         if (token == ETH_TOKEN_ADDRESS) {
657             destination.transfer(amount);
658         } else {
659             require(token.transfer(destination, amount));
660         }
661     }
662 }