1 pragma solidity ^0.4.20;
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
70 // This program is free software: you can redistribute it and/or modify
71 // it under the terms of the GNU General Public License as published by
72 // the Free Software Foundation, either version 3 of the License, or
73 // (at your option) any later version.
74 
75 // This program is distributed in the hope that it will be useful,
76 // but WITHOUT ANY WARRANTY; without even the implied warranty of
77 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
78 // GNU General Public License for more details.
79 
80 // You should have received a copy of the GNU General Public License
81 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
82 
83 contract DSMath {
84     function add(uint x, uint y) internal pure returns (uint z) {
85         require((z = x + y) >= x);
86     }
87     function sub(uint x, uint y) internal pure returns (uint z) {
88         require((z = x - y) <= x);
89     }
90     function mul(uint x, uint y) internal pure returns (uint z) {
91         require(y == 0 || (z = x * y) / y == x);
92     }
93 
94     function min(uint x, uint y) internal pure returns (uint z) {
95         return x <= y ? x : y;
96     }
97     function max(uint x, uint y) internal pure returns (uint z) {
98         return x >= y ? x : y;
99     }
100     function imin(int x, int y) internal pure returns (int z) {
101         return x <= y ? x : y;
102     }
103     function imax(int x, int y) internal pure returns (int z) {
104         return x >= y ? x : y;
105     }
106 
107     uint constant WAD = 10 ** 18;
108     uint constant RAY = 10 ** 27;
109 
110     function wmul(uint x, uint y) internal pure returns (uint z) {
111         z = add(mul(x, y), WAD / 2) / WAD;
112     }
113     function rmul(uint x, uint y) internal pure returns (uint z) {
114         z = add(mul(x, y), RAY / 2) / RAY;
115     }
116     function wdiv(uint x, uint y) internal pure returns (uint z) {
117         z = add(mul(x, WAD), y / 2) / y;
118     }
119     function rdiv(uint x, uint y) internal pure returns (uint z) {
120         z = add(mul(x, RAY), y / 2) / y;
121     }
122 
123     // This famous algorithm is called "exponentiation by squaring"
124     // and calculates x^n with x as fixed-point and n as regular unsigned.
125     //
126     // It's O(log n), instead of O(n) for naive repeated multiplication.
127     //
128     // These facts are why it works:
129     //
130     //  If n is even, then x^n = (x^2)^(n/2).
131     //  If n is odd,  then x^n = x * x^(n-1),
132     //   and applying the equation for even x gives
133     //    x^n = x * (x^2)^((n-1) / 2).
134     //
135     //  Also, EVM division is flooring and
136     //    floor[(n-1) / 2] = floor[n / 2].
137     //
138     function rpow(uint x, uint n) internal pure returns (uint z) {
139         z = n % 2 != 0 ? x : RAY;
140 
141         for (n /= 2; n != 0; n /= 2) {
142             x = rmul(x, x);
143 
144             if (n % 2 != 0) {
145                 z = rmul(z, x);
146             }
147         }
148     }
149 }
150 
151 // This program is free software: you can redistribute it and/or modify
152 // it under the terms of the GNU General Public License as published by
153 // the Free Software Foundation, either version 3 of the License, or
154 // (at your option) any later version.
155 
156 // This program is distributed in the hope that it will be useful,
157 // but WITHOUT ANY WARRANTY; without even the implied warranty of
158 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
159 // GNU General Public License for more details.
160 
161 // You should have received a copy of the GNU General Public License
162 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
163 
164 contract DSNote {
165     event LogNote(
166         bytes4   indexed  sig,
167         address  indexed  guy,
168         bytes32  indexed  foo,
169         bytes32  indexed  bar,
170         uint              wad,
171         bytes             fax
172     ) anonymous;
173 
174     modifier note {
175         bytes32 foo;
176         bytes32 bar;
177 
178         assembly {
179             foo := calldataload(4)
180             bar := calldataload(36)
181         }
182 
183         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
184 
185         _;
186     }
187 }
188 
189 // Copyright (C) 2017  DappHub, LLC
190 
191 // This program is free software: you can redistribute it and/or modify
192 // it under the terms of the GNU General Public License as published by
193 // the Free Software Foundation, either version 3 of the License, or
194 // (at your option) any later version.
195 
196 // This program is distributed in the hope that it will be useful,
197 // but WITHOUT ANY WARRANTY; without even the implied warranty of
198 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
199 // GNU General Public License for more details.
200 
201 // You should have received a copy of the GNU General Public License
202 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
203 
204 contract DSStop is DSNote, DSAuth {
205 
206     bool public stopped;
207 
208     modifier stoppable {
209         require(!stopped);
210         _;
211     }
212     function stop() public auth note {
213         stopped = true;
214     }
215     function start() public auth note {
216         stopped = false;
217     }
218 
219 }
220 
221 // See <https://github.com/ethereum/EIPs/issues/20>.
222 
223 // This file likely does not meet the threshold of originality
224 // required for copyright to apply.  As a result, this is free and
225 // unencumbered software belonging to the public domain.
226 
227 contract ERC20Events {
228     event Approval(address indexed src, address indexed guy, uint wad);
229     event Transfer(address indexed src, address indexed dst, uint wad);
230 }
231 
232 contract ERC20 is ERC20Events {
233     function totalSupply() public view returns (uint);
234     function balanceOf(address guy) public view returns (uint);
235     function allowance(address src, address guy) public view returns (uint);
236 
237     function approve(address guy, uint wad) public returns (bool);
238     function transfer(address dst, uint wad) public returns (bool);
239     function transferFrom(
240         address src, address dst, uint wad
241     ) public returns (bool);
242 }
243 
244 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
245 
246 // This program is free software: you can redistribute it and/or modify
247 // it under the terms of the GNU General Public License as published by
248 // the Free Software Foundation, either version 3 of the License, or
249 // (at your option) any later version.
250 
251 // This program is distributed in the hope that it will be useful,
252 // but WITHOUT ANY WARRANTY; without even the implied warranty of
253 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
254 // GNU General Public License for more details.
255 
256 // You should have received a copy of the GNU General Public License
257 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
258 
259 contract DSTokenBase is ERC20, DSMath {
260     uint256                                            _supply;
261     mapping (address => uint256)                       _balances;
262     mapping (address => mapping (address => uint256))  _approvals;
263 
264     function DSTokenBase(uint supply) public {
265         _balances[msg.sender] = supply;
266         _supply = supply;
267     }
268 
269     function totalSupply() public view returns (uint) {
270         return _supply;
271     }
272     function balanceOf(address src) public view returns (uint) {
273         return _balances[src];
274     }
275     function allowance(address src, address guy) public view returns (uint) {
276         return _approvals[src][guy];
277     }
278 
279     function transfer(address dst, uint wad) public returns (bool) {
280         return transferFrom(msg.sender, dst, wad);
281     }
282 
283     function transferFrom(address src, address dst, uint wad)
284         public
285         returns (bool)
286     {
287         if (src != msg.sender) {
288             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
289         }
290 
291         _balances[src] = sub(_balances[src], wad);
292         _balances[dst] = add(_balances[dst], wad);
293 
294         Transfer(src, dst, wad);
295 
296         return true;
297     }
298 
299     function approve(address guy, uint wad) public returns (bool) {
300         _approvals[msg.sender][guy] = wad;
301 
302         Approval(msg.sender, guy, wad);
303 
304         return true;
305     }
306 }
307 
308 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
309 
310 // This program is free software: you can redistribute it and/or modify
311 // it under the terms of the GNU General Public License as published by
312 // the Free Software Foundation, either version 3 of the License, or
313 // (at your option) any later version.
314 
315 // This program is distributed in the hope that it will be useful,
316 // but WITHOUT ANY WARRANTY; without even the implied warranty of
317 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
318 // GNU General Public License for more details.
319 
320 // You should have received a copy of the GNU General Public License
321 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
322 
323 contract DSToken is DSTokenBase(0), DSStop {
324 
325     bytes32  public  symbol;
326     uint256  public  decimals = 18; // standard token precision. override to customize
327 
328     function DSToken(bytes32 symbol_) public {
329         symbol = symbol_;
330     }
331 
332     event Mint(address indexed guy, uint wad);
333     event Burn(address indexed guy, uint wad);
334 
335     function approve(address guy) public stoppable returns (bool) {
336         return super.approve(guy, uint(-1));
337     }
338 
339     function approve(address guy, uint wad) public stoppable returns (bool) {
340         return super.approve(guy, wad);
341     }
342 
343     function transferFrom(address src, address dst, uint wad)
344         public
345         stoppable
346         returns (bool)
347     {
348         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
349             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
350         }
351 
352         _balances[src] = sub(_balances[src], wad);
353         _balances[dst] = add(_balances[dst], wad);
354 
355         Transfer(src, dst, wad);
356 
357         return true;
358     }
359 
360     function push(address dst, uint wad) public {
361         transferFrom(msg.sender, dst, wad);
362     }
363     function pull(address src, uint wad) public {
364         transferFrom(src, msg.sender, wad);
365     }
366     function move(address src, address dst, uint wad) public {
367         transferFrom(src, dst, wad);
368     }
369 
370     function mint(uint wad) public {
371         mint(msg.sender, wad);
372     }
373     function burn(uint wad) public {
374         burn(msg.sender, wad);
375     }
376     function mint(address guy, uint wad) public auth stoppable {
377         _balances[guy] = add(_balances[guy], wad);
378         _supply = add(_supply, wad);
379         Mint(guy, wad);
380     }
381     function burn(address guy, uint wad) public auth stoppable {
382         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
383             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
384         }
385 
386         _balances[guy] = sub(_balances[guy], wad);
387         _supply = sub(_supply, wad);
388         Burn(guy, wad);
389     }
390 
391     // Optional token name
392     bytes32   public  name = "";
393 
394     function setName(bytes32 name_) public auth {
395         name = name_;
396     }
397 }
398 
399 // Copyright (C) 2017  DappHub, LLC
400 
401 // This program is free software: you can redistribute it and/or modify
402 // it under the terms of the GNU General Public License as published by
403 // the Free Software Foundation, either version 3 of the License, or
404 // (at your option) any later version.
405 
406 // This program is distributed in the hope that it will be useful,
407 // but WITHOUT ANY WARRANTY; without even the implied warranty of
408 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
409 // GNU General Public License for more details.
410 
411 // You should have received a copy of the GNU General Public License
412 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
413 
414 contract DSThing is DSAuth, DSNote, DSMath {
415 
416     function S(string s) internal pure returns (bytes4) {
417         return bytes4(keccak256(s));
418     }
419 
420 }
421 
422 // Copyright (C) 2017  DappHub, LLC
423 
424 // This program is free software: you can redistribute it and/or modify
425 // it under the terms of the GNU General Public License as published by
426 // the Free Software Foundation, either version 3 of the License, or
427 // (at your option) any later version.
428 
429 // This program is distributed in the hope that it will be useful,
430 // but WITHOUT ANY WARRANTY; without even the implied warranty of
431 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
432 // GNU General Public License for more details.
433 
434 // You should have received a copy of the GNU General Public License
435 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
436 
437 contract DSValue is DSThing {
438     bool    has;
439     bytes32 val;
440     function peek() public view returns (bytes32, bool) {
441         return (val,has);
442     }
443     function read() public view returns (bytes32) {
444         bytes32 wut; bool haz;
445         (wut, haz) = peek();
446         assert(haz);
447         return wut;
448     }
449     function poke(bytes32 wut) public note auth {
450         val = wut;
451         has = true;
452     }
453     function void() public note auth {  // unset the value
454         has = false;
455     }
456 }
457 
458 // Copyright (C) 2017, 2018 Rain <rainbreak@riseup.net>
459 
460 // This program is free software: you can redistribute it and/or modify
461 // it under the terms of the GNU Affero General Public License as published by
462 // the Free Software Foundation, either version 3 of the License, or
463 // (at your option) any later version.
464 
465 // This program is distributed in the hope that it will be useful,
466 // but WITHOUT ANY WARRANTY; without even the implied warranty of
467 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
468 // GNU Affero General Public License for more details.
469 
470 // You should have received a copy of the GNU Affero General Public License
471 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
472 
473 contract SaiLPC is DSThing {
474     // This is a simple two token liquidity pool that uses an external
475     // price feed.
476 
477     // Makers
478     // - `pool` their gems and receive LPS tokens, which are a claim
479     //    on the pool.
480     // - `exit` and trade their LPS tokens for a share of the gems in
481     //    the pool
482 
483     // Takers
484     // - `take` and exchange one gem for another, whilst paying a
485     //   fee (the `gap`). The collected fee goes into the pool.
486 
487     // To avoid `pool`, `exit` being used to circumvent the taker fee,
488     // makers must pay the same fee on `exit`.
489 
490     // provide liquidity for this gem pair
491     ERC20    public  ref;
492     ERC20    public  alt;
493 
494     DSValue  public  pip;  // price feed, giving refs per alt
495     uint256  public  gap;  // spread, charged on `take`
496     DSToken  public  lps;  // 'liquidity provider shares', earns spread
497 
498     function SaiLPC(ERC20 ref_, ERC20 alt_, DSValue pip_, DSToken lps_) public {
499         ref = ref_;
500         alt = alt_;
501         pip = pip_;
502 
503         lps = lps_;
504         gap = WAD;
505     }
506 
507     function jump(uint wad) public note auth {
508         assert(wad != 0);
509         gap = wad;
510     }
511 
512     // ref per alt
513     function tag() public view returns (uint) {
514         return uint(pip.read());
515     }
516 
517     // total pool value
518     function pie() public view returns (uint) {
519         return add(ref.balanceOf(this), wmul(alt.balanceOf(this), tag()));
520     }
521 
522     // lps per ref
523     function per() public view returns (uint) {
524         return lps.totalSupply() == 0
525              ? RAY
526              : rdiv(lps.totalSupply(), pie());
527     }
528 
529     // {ref,alt} -> lps
530     function pool(ERC20 gem, uint wad) public note auth {
531         require(gem == alt || gem == ref);
532 
533         uint jam = (gem == ref) ? wad : wmul(wad, tag());
534         uint ink = rmul(jam, per());
535         lps.mint(ink);
536         lps.push(msg.sender, ink);
537 
538         gem.transferFrom(msg.sender, this, wad);
539     }
540 
541     // lps -> {ref,alt}
542     function exit(ERC20 gem, uint wad) public note auth {
543         require(gem == alt || gem == ref);
544 
545         uint jam = (gem == ref) ? wad : wmul(wad, tag());
546         uint ink = rmul(jam, per());
547         // pay fee to exit, unless you're the last out
548         ink = (jam == pie())? ink : wmul(gap, ink);
549         lps.pull(msg.sender, ink);
550         lps.burn(ink);
551 
552         gem.transfer(msg.sender, wad);
553     }
554 
555     // ref <-> alt
556     function take(ERC20 gem, uint wad) public note auth {
557         require(gem == alt || gem == ref);
558 
559         uint jam = (gem == ref) ? wdiv(wad, tag()) : wmul(wad, tag());
560         jam = wmul(gap, jam);
561 
562         ERC20 pay = (gem == ref) ? alt : ref;
563         pay.transferFrom(msg.sender, this, jam);
564         gem.transfer(msg.sender, wad);
565     }
566 }