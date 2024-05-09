1 pragma solidity ^0.4.13;
2 
3 ////// lib/ds-math/src/math.sol
4 /// math.sol -- mixin for inline numerical wizardry
5 
6 // This program is free software: you can redistribute it and/or modify
7 // it under the terms of the GNU General Public License as published by
8 // the Free Software Foundation, either version 3 of the License, or
9 // (at your option) any later version.
10 
11 // This program is distributed in the hope that it will be useful,
12 // but WITHOUT ANY WARRANTY; without even the implied warranty of
13 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
14 // GNU General Public License for more details.
15 
16 // You should have received a copy of the GNU General Public License
17 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
18 
19 /* pragma solidity ^0.4.13; */
20 
21 contract DSMath {
22     function add(uint x, uint y) internal pure returns (uint z) {
23         require((z = x + y) >= x);
24     }
25     function sub(uint x, uint y) internal pure returns (uint z) {
26         require((z = x - y) <= x);
27     }
28     function mul(uint x, uint y) internal pure returns (uint z) {
29         require(y == 0 || (z = x * y) / y == x);
30     }
31 
32     function min(uint x, uint y) internal pure returns (uint z) {
33         return x <= y ? x : y;
34     }
35     function max(uint x, uint y) internal pure returns (uint z) {
36         return x >= y ? x : y;
37     }
38     function imin(int x, int y) internal pure returns (int z) {
39         return x <= y ? x : y;
40     }
41     function imax(int x, int y) internal pure returns (int z) {
42         return x >= y ? x : y;
43     }
44 
45     uint constant WAD = 10 ** 18;
46     uint constant RAY = 10 ** 27;
47 
48     function wmul(uint x, uint y) internal pure returns (uint z) {
49         z = add(mul(x, y), WAD / 2) / WAD;
50     }
51     function rmul(uint x, uint y) internal pure returns (uint z) {
52         z = add(mul(x, y), RAY / 2) / RAY;
53     }
54     function wdiv(uint x, uint y) internal pure returns (uint z) {
55         z = add(mul(x, WAD), y / 2) / y;
56     }
57     function rdiv(uint x, uint y) internal pure returns (uint z) {
58         z = add(mul(x, RAY), y / 2) / y;
59     }
60 
61     // This famous algorithm is called "exponentiation by squaring"
62     // and calculates x^n with x as fixed-point and n as regular unsigned.
63     //
64     // It's O(log n), instead of O(n) for naive repeated multiplication.
65     //
66     // These facts are why it works:
67     //
68     //  If n is even, then x^n = (x^2)^(n/2).
69     //  If n is odd,  then x^n = x * x^(n-1),
70     //   and applying the equation for even x gives
71     //    x^n = x * (x^2)^((n-1) / 2).
72     //
73     //  Also, EVM division is flooring and
74     //    floor[(n-1) / 2] = floor[n / 2].
75     //
76     function rpow(uint x, uint n) internal pure returns (uint z) {
77         z = n % 2 != 0 ? x : RAY;
78 
79         for (n /= 2; n != 0; n /= 2) {
80             x = rmul(x, x);
81 
82             if (n % 2 != 0) {
83                 z = rmul(z, x);
84             }
85         }
86     }
87 }
88 
89 ////// lib/ds-stop/lib/ds-auth/src/auth.sol
90 // This program is free software: you can redistribute it and/or modify
91 // it under the terms of the GNU General Public License as published by
92 // the Free Software Foundation, either version 3 of the License, or
93 // (at your option) any later version.
94 
95 // This program is distributed in the hope that it will be useful,
96 // but WITHOUT ANY WARRANTY; without even the implied warranty of
97 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
98 // GNU General Public License for more details.
99 
100 // You should have received a copy of the GNU General Public License
101 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
102 
103 /* pragma solidity ^0.4.13; */
104 
105 contract DSAuthority {
106     function canCall(
107         address src, address dst, bytes4 sig
108     ) public view returns (bool);
109 }
110 
111 contract DSAuthEvents {
112     event LogSetAuthority (address indexed authority);
113     event LogSetOwner     (address indexed owner);
114 }
115 
116 contract DSAuth is DSAuthEvents {
117     DSAuthority  public  authority;
118     address      public  owner;
119 
120     function DSAuth() public {
121         owner = msg.sender;
122         LogSetOwner(msg.sender);
123     }
124 
125     function setOwner(address owner_)
126         public
127         auth
128     {
129         owner = owner_;
130         LogSetOwner(owner);
131     }
132 
133     function setAuthority(DSAuthority authority_)
134         public
135         auth
136     {
137         authority = authority_;
138         LogSetAuthority(authority);
139     }
140 
141     modifier auth {
142         require(isAuthorized(msg.sender, msg.sig));
143         _;
144     }
145 
146     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
147         if (src == address(this)) {
148             return true;
149         } else if (src == owner) {
150             return true;
151         } else if (authority == DSAuthority(0)) {
152             return false;
153         } else {
154             return authority.canCall(src, this, sig);
155         }
156     }
157 }
158 
159 ////// lib/ds-stop/lib/ds-note/src/note.sol
160 /// note.sol -- the `note' modifier, for logging calls as events
161 
162 // This program is free software: you can redistribute it and/or modify
163 // it under the terms of the GNU General Public License as published by
164 // the Free Software Foundation, either version 3 of the License, or
165 // (at your option) any later version.
166 
167 // This program is distributed in the hope that it will be useful,
168 // but WITHOUT ANY WARRANTY; without even the implied warranty of
169 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
170 // GNU General Public License for more details.
171 
172 // You should have received a copy of the GNU General Public License
173 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
174 
175 /* pragma solidity ^0.4.13; */
176 
177 contract DSNote {
178     event LogNote(
179         bytes4   indexed  sig,
180         address  indexed  guy,
181         bytes32  indexed  foo,
182         bytes32  indexed  bar,
183         uint              wad,
184         bytes             fax
185     ) anonymous;
186 
187     modifier note {
188         bytes32 foo;
189         bytes32 bar;
190 
191         assembly {
192             foo := calldataload(4)
193             bar := calldataload(36)
194         }
195 
196         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
197 
198         _;
199     }
200 }
201 
202 ////// lib/ds-stop/src/stop.sol
203 /// stop.sol -- mixin for enable/disable functionality
204 
205 // Copyright (C) 2017  DappHub, LLC
206 
207 // This program is free software: you can redistribute it and/or modify
208 // it under the terms of the GNU General Public License as published by
209 // the Free Software Foundation, either version 3 of the License, or
210 // (at your option) any later version.
211 
212 // This program is distributed in the hope that it will be useful,
213 // but WITHOUT ANY WARRANTY; without even the implied warranty of
214 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
215 // GNU General Public License for more details.
216 
217 // You should have received a copy of the GNU General Public License
218 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
219 
220 /* pragma solidity ^0.4.13; */
221 
222 /* import "ds-auth/auth.sol"; */
223 /* import "ds-note/note.sol"; */
224 
225 contract DSStop is DSNote, DSAuth {
226 
227     bool public stopped;
228 
229     modifier stoppable {
230         require(!stopped);
231         _;
232     }
233     function stop() public auth note {
234         stopped = true;
235     }
236     function start() public auth note {
237         stopped = false;
238     }
239 
240 }
241 
242 ////// lib/erc20/src/erc20.sol
243 /// erc20.sol -- API for the ERC20 token standard
244 
245 // See <https://github.com/ethereum/EIPs/issues/20>.
246 
247 // This file likely does not meet the threshold of originality
248 // required for copyright to apply.  As a result, this is free and
249 // unencumbered software belonging to the public domain.
250 
251 /* pragma solidity ^0.4.8; */
252 
253 contract ERC20Events {
254     event Approval(address indexed src, address indexed guy, uint wad);
255     event Transfer(address indexed src, address indexed dst, uint wad);
256 }
257 
258 contract ERC20 is ERC20Events {
259     function totalSupply() public view returns (uint);
260     function balanceOf(address guy) public view returns (uint);
261     function allowance(address src, address guy) public view returns (uint);
262 
263     function approve(address guy, uint wad) public returns (bool);
264     function transfer(address dst, uint wad) public returns (bool);
265     function transferFrom(
266         address src, address dst, uint wad
267     ) public returns (bool);
268 }
269 
270 ////// src/base.sol
271 /// base.sol -- basic ERC20 implementation
272 
273 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
274 
275 // This program is free software: you can redistribute it and/or modify
276 // it under the terms of the GNU General Public License as published by
277 // the Free Software Foundation, either version 3 of the License, or
278 // (at your option) any later version.
279 
280 // This program is distributed in the hope that it will be useful,
281 // but WITHOUT ANY WARRANTY; without even the implied warranty of
282 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
283 // GNU General Public License for more details.
284 
285 // You should have received a copy of the GNU General Public License
286 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
287 
288 /* pragma solidity ^0.4.13; */
289 
290 /* import "erc20/erc20.sol"; */
291 /* import "ds-math/math.sol"; */
292 
293 contract DSTokenBase is ERC20, DSMath {
294     uint256                                            _supply;
295     mapping (address => uint256)                       _balances;
296     mapping (address => mapping (address => uint256))  _approvals;
297 
298     function DSTokenBase(uint supply) public {
299         _balances[msg.sender] = supply;
300         _supply = supply;
301     }
302 
303     function totalSupply() public view returns (uint) {
304         return _supply;
305     }
306     function balanceOf(address src) public view returns (uint) {
307         return _balances[src];
308     }
309     function allowance(address src, address guy) public view returns (uint) {
310         return _approvals[src][guy];
311     }
312 
313     function transfer(address dst, uint wad) public returns (bool) {
314         return transferFrom(msg.sender, dst, wad);
315     }
316 
317     function transferFrom(address src, address dst, uint wad)
318         public
319         returns (bool)
320     {
321         if (src != msg.sender) {
322             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
323         }
324 
325         _balances[src] = sub(_balances[src], wad);
326         _balances[dst] = add(_balances[dst], wad);
327 
328         Transfer(src, dst, wad);
329 
330         return true;
331     }
332 
333     function approve(address guy, uint wad) public returns (bool) {
334         _approvals[msg.sender][guy] = wad;
335 
336         Approval(msg.sender, guy, wad);
337 
338         return true;
339     }
340 }
341 
342 ////// src/token.sol
343 /// token.sol -- ERC20 implementation with minting and burning
344 
345 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
346 
347 // This program is free software: you can redistribute it and/or modify
348 // it under the terms of the GNU General Public License as published by
349 // the Free Software Foundation, either version 3 of the License, or
350 // (at your option) any later version.
351 
352 // This program is distributed in the hope that it will be useful,
353 // but WITHOUT ANY WARRANTY; without even the implied warranty of
354 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
355 // GNU General Public License for more details.
356 
357 // You should have received a copy of the GNU General Public License
358 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
359 
360 /* pragma solidity ^0.4.13; */
361 
362 /* import "ds-stop/stop.sol"; */
363 
364 /* import "./base.sol"; */
365 
366 contract DSToken is DSTokenBase(0), DSStop {
367 
368     bytes32  public  symbol;
369     uint256  public  decimals = 18; // standard token precision. override to customize
370 
371     function DSToken(bytes32 symbol_) public {
372         symbol = symbol_;
373     }
374 
375     event Mint(address indexed guy, uint wad);
376     event Burn(address indexed guy, uint wad);
377 
378     function approve(address guy) public stoppable returns (bool) {
379         return super.approve(guy, uint(-1));
380     }
381 
382     function approve(address guy, uint wad) public stoppable returns (bool) {
383         return super.approve(guy, wad);
384     }
385 
386     function transferFrom(address src, address dst, uint wad)
387         public
388         stoppable
389         returns (bool)
390     {
391         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
392             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
393         }
394 
395         _balances[src] = sub(_balances[src], wad);
396         _balances[dst] = add(_balances[dst], wad);
397 
398         Transfer(src, dst, wad);
399 
400         return true;
401     }
402 
403     function push(address dst, uint wad) public {
404         transferFrom(msg.sender, dst, wad);
405     }
406     function pull(address src, uint wad) public {
407         transferFrom(src, msg.sender, wad);
408     }
409     function move(address src, address dst, uint wad) public {
410         transferFrom(src, dst, wad);
411     }
412 
413     function mint(uint wad) public {
414         mint(msg.sender, wad);
415     }
416     function burn(uint wad) public {
417         burn(msg.sender, wad);
418     }
419     function mint(address guy, uint wad) public auth stoppable {
420         _balances[guy] = add(_balances[guy], wad);
421         _supply = add(_supply, wad);
422         Mint(guy, wad);
423     }
424     function burn(address guy, uint wad) public auth stoppable {
425         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
426             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
427         }
428 
429         _balances[guy] = sub(_balances[guy], wad);
430         _supply = sub(_supply, wad);
431         Burn(guy, wad);
432     }
433 
434     // Optional token name
435     bytes32   public  name = "";
436 
437     function setName(bytes32 name_) public auth {
438         name = name_;
439     }
440 }
441 
442 contract GemPit {
443     function burn(DSToken gem) public {
444         gem.burn(gem.balanceOf(this));
445     }
446 }