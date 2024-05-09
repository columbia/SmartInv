1 // Redeemer
2 // Copyright 2017 - DappHub
3 
4 // hevm: flattened sources of src/mkr-499.sol
5 pragma solidity ^0.4.15;
6 
7 ////// lib/ds-roles/lib/ds-auth/src/auth.sol
8 // This program is free software: you can redistribute it and/or modify
9 // it under the terms of the GNU General Public License as published by
10 // the Free Software Foundation, either version 3 of the License, or
11 // (at your option) any later version.
12 
13 // This program is distributed in the hope that it will be useful,
14 // but WITHOUT ANY WARRANTY; without even the implied warranty of
15 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
16 // GNU General Public License for more details.
17 
18 // You should have received a copy of the GNU General Public License
19 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
20 
21 /* pragma solidity ^0.4.13; */
22 
23 contract DSAuthority {
24     function canCall(
25         address src, address dst, bytes4 sig
26     ) public view returns (bool);
27 }
28 
29 contract DSAuthEvents {
30     event LogSetAuthority (address indexed authority);
31     event LogSetOwner     (address indexed owner);
32 }
33 
34 contract DSAuth is DSAuthEvents {
35     DSAuthority  public  authority;
36     address      public  owner;
37 
38     function DSAuth() public {
39         owner = msg.sender;
40         LogSetOwner(msg.sender);
41     }
42 
43     function setOwner(address owner_)
44         public
45         auth
46     {
47         owner = owner_;
48         LogSetOwner(owner);
49     }
50 
51     function setAuthority(DSAuthority authority_)
52         public
53         auth
54     {
55         authority = authority_;
56         LogSetAuthority(authority);
57     }
58 
59     modifier auth {
60         require(isAuthorized(msg.sender, msg.sig));
61         _;
62     }
63 
64     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
65         if (src == address(this)) {
66             return true;
67         } else if (src == owner) {
68             return true;
69         } else if (authority == DSAuthority(0)) {
70             return false;
71         } else {
72             return authority.canCall(src, this, sig);
73         }
74     }
75 }
76 
77 ////// lib/ds-thing/lib/ds-math/src/math.sol
78 /// math.sol -- mixin for inline numerical wizardry
79 
80 // This program is free software: you can redistribute it and/or modify
81 // it under the terms of the GNU General Public License as published by
82 // the Free Software Foundation, either version 3 of the License, or
83 // (at your option) any later version.
84 
85 // This program is distributed in the hope that it will be useful,
86 // but WITHOUT ANY WARRANTY; without even the implied warranty of
87 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
88 // GNU General Public License for more details.
89 
90 // You should have received a copy of the GNU General Public License
91 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
92 
93 /* pragma solidity ^0.4.13; */
94 
95 contract DSMath {
96     function add(uint x, uint y) internal pure returns (uint z) {
97         require((z = x + y) >= x);
98     }
99     function sub(uint x, uint y) internal pure returns (uint z) {
100         require((z = x - y) <= x);
101     }
102     function mul(uint x, uint y) internal pure returns (uint z) {
103         require(y == 0 || (z = x * y) / y == x);
104     }
105 
106     function min(uint x, uint y) internal pure returns (uint z) {
107         return x <= y ? x : y;
108     }
109     function max(uint x, uint y) internal pure returns (uint z) {
110         return x >= y ? x : y;
111     }
112     function imin(int x, int y) internal pure returns (int z) {
113         return x <= y ? x : y;
114     }
115     function imax(int x, int y) internal pure returns (int z) {
116         return x >= y ? x : y;
117     }
118 
119     uint constant WAD = 10 ** 18;
120     uint constant RAY = 10 ** 27;
121 
122     function wmul(uint x, uint y) internal pure returns (uint z) {
123         z = add(mul(x, y), WAD / 2) / WAD;
124     }
125     function rmul(uint x, uint y) internal pure returns (uint z) {
126         z = add(mul(x, y), RAY / 2) / RAY;
127     }
128     function wdiv(uint x, uint y) internal pure returns (uint z) {
129         z = add(mul(x, WAD), y / 2) / y;
130     }
131     function rdiv(uint x, uint y) internal pure returns (uint z) {
132         z = add(mul(x, RAY), y / 2) / y;
133     }
134 
135     // This famous algorithm is called "exponentiation by squaring"
136     // and calculates x^n with x as fixed-point and n as regular unsigned.
137     //
138     // It's O(log n), instead of O(n) for naive repeated multiplication.
139     //
140     // These facts are why it works:
141     //
142     //  If n is even, then x^n = (x^2)^(n/2).
143     //  If n is odd,  then x^n = x * x^(n-1),
144     //   and applying the equation for even x gives
145     //    x^n = x * (x^2)^((n-1) / 2).
146     //
147     //  Also, EVM division is flooring and
148     //    floor[(n-1) / 2] = floor[n / 2].
149     //
150     function rpow(uint x, uint n) internal pure returns (uint z) {
151         z = n % 2 != 0 ? x : RAY;
152 
153         for (n /= 2; n != 0; n /= 2) {
154             x = rmul(x, x);
155 
156             if (n % 2 != 0) {
157                 z = rmul(z, x);
158             }
159         }
160     }
161 }
162 
163 ////// lib/ds-thing/lib/ds-note/src/note.sol
164 /// note.sol -- the `note' modifier, for logging calls as events
165 
166 // This program is free software: you can redistribute it and/or modify
167 // it under the terms of the GNU General Public License as published by
168 // the Free Software Foundation, either version 3 of the License, or
169 // (at your option) any later version.
170 
171 // This program is distributed in the hope that it will be useful,
172 // but WITHOUT ANY WARRANTY; without even the implied warranty of
173 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
174 // GNU General Public License for more details.
175 
176 // You should have received a copy of the GNU General Public License
177 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
178 
179 /* pragma solidity ^0.4.13; */
180 
181 contract DSNote {
182     event LogNote(
183         bytes4   indexed  sig,
184         address  indexed  guy,
185         bytes32  indexed  foo,
186         bytes32  indexed  bar,
187         uint              wad,
188         bytes             fax
189     ) anonymous;
190 
191     modifier note {
192         bytes32 foo;
193         bytes32 bar;
194 
195         assembly {
196             foo := calldataload(4)
197             bar := calldataload(36)
198         }
199 
200         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
201 
202         _;
203     }
204 }
205 
206 ////// lib/ds-thing/src/thing.sol
207 // thing.sol - `auth` with handy mixins. your things should be DSThings
208 
209 // Copyright (C) 2017  DappHub, LLC
210 
211 // This program is free software: you can redistribute it and/or modify
212 // it under the terms of the GNU General Public License as published by
213 // the Free Software Foundation, either version 3 of the License, or
214 // (at your option) any later version.
215 
216 // This program is distributed in the hope that it will be useful,
217 // but WITHOUT ANY WARRANTY; without even the implied warranty of
218 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
219 // GNU General Public License for more details.
220 
221 // You should have received a copy of the GNU General Public License
222 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
223 
224 /* pragma solidity ^0.4.13; */
225 
226 /* import 'ds-auth/auth.sol'; */
227 /* import 'ds-note/note.sol'; */
228 /* import 'ds-math/math.sol'; */
229 
230 contract DSThing is DSAuth, DSNote, DSMath {
231 }
232 
233 ////// lib/ds-token/lib/ds-stop/src/stop.sol
234 /// stop.sol -- mixin for enable/disable functionality
235 
236 // Copyright (C) 2017  DappHub, LLC
237 
238 // This program is free software: you can redistribute it and/or modify
239 // it under the terms of the GNU General Public License as published by
240 // the Free Software Foundation, either version 3 of the License, or
241 // (at your option) any later version.
242 
243 // This program is distributed in the hope that it will be useful,
244 // but WITHOUT ANY WARRANTY; without even the implied warranty of
245 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
246 // GNU General Public License for more details.
247 
248 // You should have received a copy of the GNU General Public License
249 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
250 
251 /* pragma solidity ^0.4.13; */
252 
253 /* import "ds-auth/auth.sol"; */
254 /* import "ds-note/note.sol"; */
255 
256 contract DSStop is DSNote, DSAuth {
257 
258     bool public stopped;
259 
260     modifier stoppable {
261         require(!stopped);
262         _;
263     }
264     function stop() public auth note {
265         stopped = true;
266     }
267     function start() public auth note {
268         stopped = false;
269     }
270 
271 }
272 
273 ////// lib/ds-token/lib/erc20/src/erc20.sol
274 // This program is free software: you can redistribute it and/or modify
275 // it under the terms of the GNU General Public License as published by
276 // the Free Software Foundation, either version 3 of the License, or
277 // (at your option) any later version.
278 
279 // This program is distributed in the hope that it will be useful,
280 // but WITHOUT ANY WARRANTY; without even the implied warranty of
281 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
282 // GNU General Public License for more details.
283 
284 // You should have received a copy of the GNU General Public License
285 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
286 
287 /* pragma solidity ^0.4.8; */
288 
289 // Token standard API
290 // https://github.com/ethereum/EIPs/issues/20
291 
292 contract ERC20 {
293     function totalSupply() public view returns (uint supply);
294     function balanceOf( address who ) public view returns (uint value);
295     function allowance( address owner, address spender ) public view returns (uint _allowance);
296 
297     function transfer( address to, uint value) public returns (bool ok);
298     function transferFrom( address from, address to, uint value) public returns (bool ok);
299     function approve( address spender, uint value ) public returns (bool ok);
300 
301     event Transfer( address indexed from, address indexed to, uint value);
302     event Approval( address indexed owner, address indexed spender, uint value);
303 }
304 
305 ////// lib/ds-token/src/base.sol
306 /// base.sol -- basic ERC20 implementation
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
323 /* pragma solidity ^0.4.13; */
324 
325 /* import "erc20/erc20.sol"; */
326 /* import "ds-math/math.sol"; */
327 
328 contract DSTokenBase is ERC20, DSMath {
329     uint256                                            _supply;
330     mapping (address => uint256)                       _balances;
331     mapping (address => mapping (address => uint256))  _approvals;
332 
333     function DSTokenBase(uint supply) public {
334         _balances[msg.sender] = supply;
335         _supply = supply;
336     }
337 
338     function totalSupply() public view returns (uint) {
339         return _supply;
340     }
341     function balanceOf(address src) public view returns (uint) {
342         return _balances[src];
343     }
344     function allowance(address src, address guy) public view returns (uint) {
345         return _approvals[src][guy];
346     }
347 
348     function transfer(address dst, uint wad) public returns (bool) {
349         return transferFrom(msg.sender, dst, wad);
350     }
351 
352     function transferFrom(address src, address dst, uint wad)
353         public
354         returns (bool)
355     {
356         if (src != msg.sender) {
357             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
358         }
359 
360         _balances[src] = sub(_balances[src], wad);
361         _balances[dst] = add(_balances[dst], wad);
362 
363         Transfer(src, dst, wad);
364 
365         return true;
366     }
367 
368     function approve(address guy, uint wad) public returns (bool) {
369         _approvals[msg.sender][guy] = wad;
370 
371         Approval(msg.sender, guy, wad);
372 
373         return true;
374     }
375 }
376 
377 ////// lib/ds-token/src/token.sol
378 /// token.sol -- ERC20 implementation with minting and burning
379 
380 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
381 
382 // This program is free software: you can redistribute it and/or modify
383 // it under the terms of the GNU General Public License as published by
384 // the Free Software Foundation, either version 3 of the License, or
385 // (at your option) any later version.
386 
387 // This program is distributed in the hope that it will be useful,
388 // but WITHOUT ANY WARRANTY; without even the implied warranty of
389 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
390 // GNU General Public License for more details.
391 
392 // You should have received a copy of the GNU General Public License
393 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
394 
395 /* pragma solidity ^0.4.13; */
396 
397 /* import "ds-stop/stop.sol"; */
398 
399 /* import "./base.sol"; */
400 
401 contract DSToken is DSTokenBase(0), DSStop {
402 
403     bytes32  public  symbol;
404     uint256  public  decimals = 18; // standard token precision. override to customize
405 
406     function DSToken(bytes32 symbol_) public {
407         symbol = symbol_;
408     }
409 
410     event Mint(address indexed guy, uint wad);
411     event Burn(address indexed guy, uint wad);
412 
413     function approve(address guy) public stoppable returns (bool) {
414         return super.approve(guy, uint(-1));
415     }
416 
417     function approve(address guy, uint wad) public stoppable returns (bool) {
418         return super.approve(guy, wad);
419     }
420 
421     function transferFrom(address src, address dst, uint wad)
422         public
423         stoppable
424         returns (bool)
425     {
426         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
427             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
428         }
429 
430         _balances[src] = sub(_balances[src], wad);
431         _balances[dst] = add(_balances[dst], wad);
432 
433         Transfer(src, dst, wad);
434 
435         return true;
436     }
437 
438     function push(address dst, uint wad) public {
439         transferFrom(msg.sender, dst, wad);
440     }
441     function pull(address src, uint wad) public {
442         transferFrom(src, msg.sender, wad);
443     }
444     function move(address src, address dst, uint wad) public {
445         transferFrom(src, dst, wad);
446     }
447 
448     function mint(uint wad) public {
449         mint(msg.sender, wad);
450     }
451     function burn(uint wad) public {
452         burn(msg.sender, wad);
453     }
454     function mint(address guy, uint wad) public auth stoppable {
455         _balances[guy] = add(_balances[guy], wad);
456         _supply = add(_supply, wad);
457         Mint(guy, wad);
458     }
459     function burn(address guy, uint wad) public auth stoppable {
460         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
461             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
462         }
463 
464         _balances[guy] = sub(_balances[guy], wad);
465         _supply = sub(_supply, wad);
466         Burn(guy, wad);
467     }
468 
469     // Optional token name
470     bytes32   public  name = "";
471 
472     function setName(bytes32 name_) public auth {
473         name = name_;
474     }
475 }
476 
477 ////// src/mkr-499.sol
478 // (c) Dai Foundation, 2017
479 
480 /* pragma solidity ^0.4.15; */
481 
482 /* import 'ds-token/token.sol'; */
483 //import 'ds-vault/vault.sol';
484 
485 /* import 'ds-thing/thing.sol'; */
486 
487 contract Redeemer is DSStop {
488     ERC20   public from;
489     DSToken public to;
490     uint    public undo_deadline;
491     function Redeemer(ERC20 from_, DSToken to_, uint undo_deadline_) public {
492         from = from_;
493         to = to_;
494         undo_deadline = undo_deadline_;
495     }
496     function redeem() public stoppable {
497         var wad = from.balanceOf(msg.sender);
498         require(from.transferFrom(msg.sender, this, wad));
499         to.push(msg.sender, wad);
500     }
501     function undo() public stoppable {
502         var wad = to.balanceOf(msg.sender);
503         require(now < undo_deadline);
504         require(from.transfer(msg.sender, wad));
505         to.pull(msg.sender, wad);
506     }
507     function reclaim() public auth {
508         require(stopped);
509         var wad = from.balanceOf(this);
510         require(from.transfer(msg.sender, wad));
511         wad = to.balanceOf(this);
512         to.push(msg.sender, wad);
513     }
514 }