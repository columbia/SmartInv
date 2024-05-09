1 contract DSMath {
2     function add(uint x, uint y) internal pure returns (uint z) {
3         require((z = x + y) >= x, "ds-math-add-overflow");
4     }
5     function sub(uint x, uint y) internal pure returns (uint z) {
6         require((z = x - y) <= x, "ds-math-sub-underflow");
7     }
8     function mul(uint x, uint y) internal pure returns (uint z) {
9         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
10     }
11 
12     function min(uint x, uint y) internal pure returns (uint z) {
13         return x <= y ? x : y;
14     }
15     function max(uint x, uint y) internal pure returns (uint z) {
16         return x >= y ? x : y;
17     }
18     function imin(int x, int y) internal pure returns (int z) {
19         return x <= y ? x : y;
20     }
21     function imax(int x, int y) internal pure returns (int z) {
22         return x >= y ? x : y;
23     }
24 
25     uint constant WAD = 10 ** 18;
26     uint constant RAY = 10 ** 27;
27 
28     //rounds to zero if x*y < WAD / 2
29     function wmul(uint x, uint y) internal pure returns (uint z) {
30         z = add(mul(x, y), WAD / 2) / WAD;
31     }
32     //rounds to zero if x*y < WAD / 2
33     function rmul(uint x, uint y) internal pure returns (uint z) {
34         z = add(mul(x, y), RAY / 2) / RAY;
35     }
36     //rounds to zero if x*y < WAD / 2
37     function wdiv(uint x, uint y) internal pure returns (uint z) {
38         z = add(mul(x, WAD), y / 2) / y;
39     }
40     //rounds to zero if x*y < RAY / 2
41     function rdiv(uint x, uint y) internal pure returns (uint z) {
42         z = add(mul(x, RAY), y / 2) / y;
43     }
44 
45     // This famous algorithm is called "exponentiation by squaring"
46     // and calculates x^n with x as fixed-point and n as regular unsigned.
47     //
48     // It's O(log n), instead of O(n) for naive repeated multiplication.
49     //
50     // These facts are why it works:
51     //
52     //  If n is even, then x^n = (x^2)^(n/2).
53     //  If n is odd,  then x^n = x * x^(n-1),
54     //   and applying the equation for even x gives
55     //    x^n = x * (x^2)^((n-1) / 2).
56     //
57     //  Also, EVM division is flooring and
58     //    floor[(n-1) / 2] = floor[n / 2].
59     //
60     function rpow(uint x, uint n) internal pure returns (uint z) {
61         z = n % 2 != 0 ? x : RAY;
62 
63         for (n /= 2; n != 0; n /= 2) {
64             x = rmul(x, x);
65 
66             if (n % 2 != 0) {
67                 z = rmul(z, x);
68             }
69         }
70     }
71 }
72 
73 /// erc20.sol -- API for the ERC20 token standard
74 
75 // See <https://github.com/ethereum/EIPs/issues/20>.
76 
77 // This file likely does not meet the threshold of originality
78 // required for copyright to apply.  As a result, this is free and
79 // unencumbered software belonging to the public domain.
80 
81 //pragma solidity >0.4.20;
82 
83 contract ERC20Events {
84     event Approval(address indexed src, address indexed guy, uint wad);
85     event Transfer(address indexed src, address indexed dst, uint wad);
86 }
87 
88 contract ERC20 is ERC20Events {
89     function totalSupply() public view returns (uint);
90     function balanceOf(address guy) public view returns (uint);
91     function allowance(address src, address guy) public view returns (uint);
92 
93     function approve(address guy, uint wad) public returns (bool);
94     function transfer(address dst, uint wad) public returns (bool);
95     function transferFrom(
96         address src, address dst, uint wad
97     ) public returns (bool);
98 }
99 
100 /// note.sol -- the `note' modifier, for logging calls as events
101 
102 // This program is free software: you can redistribute it and/or modify
103 // it under the terms of the GNU General Public License as published by
104 // the Free Software Foundation, either version 3 of the License, or
105 // (at your option) any later version.
106 
107 // This program is distributed in the hope that it will be useful,
108 // but WITHOUT ANY WARRANTY; without even the implied warranty of
109 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
110 // GNU General Public License for more details.
111 
112 // You should have received a copy of the GNU General Public License
113 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
114 
115 //pragma solidity >=0.4.23;
116 
117 contract DSNote {
118     event LogNote(
119         bytes4   indexed  sig,
120         address  indexed  guy,
121         bytes32  indexed  foo,
122         bytes32  indexed  bar,
123         uint256           wad,
124         bytes             fax
125     ) anonymous;
126 
127     modifier note {
128         bytes32 foo;
129         bytes32 bar;
130         uint256 wad;
131 
132         assembly {
133             foo := calldataload(4)
134             bar := calldataload(36)
135             wad := callvalue()
136         }
137 
138         _;
139 
140         emit LogNote(msg.sig, msg.sender, foo, bar, wad, msg.data);
141     }
142 }
143 
144 // This program is free software: you can redistribute it and/or modify
145 // it under the terms of the GNU General Public License as published by
146 // the Free Software Foundation, either version 3 of the License, or
147 // (at your option) any later version.
148 
149 // This program is distributed in the hope that it will be useful,
150 // but WITHOUT ANY WARRANTY; without even the implied warranty of
151 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
152 // GNU General Public License for more details.
153 
154 // You should have received a copy of the GNU General Public License
155 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
156 
157 pragma solidity >=0.4.23;
158 
159 interface DSAuthority {
160     function canCall(
161         address src, address dst, bytes4 sig
162     ) external view returns (bool);
163 }
164 
165 contract DSAuthEvents {
166     event LogSetAuthority (address indexed authority);
167     event LogSetOwner     (address indexed owner);
168 }
169 
170 contract DSAuth is DSAuthEvents {
171     DSAuthority  public  authority;
172     address      public  owner;
173 
174     constructor() public {
175         owner = msg.sender;
176         emit LogSetOwner(msg.sender);
177     }
178 
179     function setOwner(address owner_)
180         public
181         auth
182     {
183         owner = owner_;
184         emit LogSetOwner(owner);
185     }
186 
187     function setAuthority(DSAuthority authority_)
188         public
189         auth
190     {
191         authority = authority_;
192         emit LogSetAuthority(address(authority));
193     }
194 
195     modifier auth {
196         require(isAuthorized(msg.sender, msg.sig), "ds-auth-unauthorized");
197         _;
198     }
199 
200     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
201         if (src == address(this)) {
202             return true;
203         } else if (src == owner) {
204             return true;
205         } else if (authority == DSAuthority(0)) {
206             return false;
207         } else {
208             return authority.canCall(src, address(this), sig);
209         }
210     }
211 }
212 
213 /// stop.sol -- mixin for enable/disable functionality
214 
215 // Copyright (C) 2017  DappHub, LLC
216 
217 // This program is free software: you can redistribute it and/or modify
218 // it under the terms of the GNU General Public License as published by
219 // the Free Software Foundation, either version 3 of the License, or
220 // (at your option) any later version.
221 
222 // This program is distributed in the hope that it will be useful,
223 // but WITHOUT ANY WARRANTY; without even the implied warranty of
224 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
225 // GNU General Public License for more details.
226 
227 // You should have received a copy of the GNU General Public License
228 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
229 
230 //pragma solidity >=0.4.23;
231 
232 //import "ds-auth/auth.sol";
233 //import "ds-note/note.sol";
234 
235 contract DSStop is DSNote, DSAuth {
236     bool public stopped;
237 
238     modifier stoppable {
239         require(!stopped, "ds-stop-is-stopped");
240         _;
241     }
242     function stop() public auth note {
243         stopped = true;
244     }
245     function start() public auth note {
246         stopped = false;
247     }
248 
249 }
250 
251 /// base.sol -- basic ERC20 implementation
252 
253 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
254 
255 // This program is free software: you can redistribute it and/or modify
256 // it under the terms of the GNU General Public License as published by
257 // the Free Software Foundation, either version 3 of the License, or
258 // (at your option) any later version.
259 
260 // This program is distributed in the hope that it will be useful,
261 // but WITHOUT ANY WARRANTY; without even the implied warranty of
262 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
263 // GNU General Public License for more details.
264 
265 // You should have received a copy of the GNU General Public License
266 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
267 
268 //pragma solidity >=0.4.23;
269 
270 //import "erc20/erc20.sol";
271 //import "ds-math/math.sol";
272 
273 contract DSTokenBase is ERC20, DSMath {
274     uint256                                            _supply;
275     mapping (address => uint256)                       _balances;
276     mapping (address => mapping (address => uint256))  _approvals;
277 
278     constructor(uint supply) public {
279         _balances[msg.sender] = supply;
280         _supply = supply;
281     }
282 
283     function totalSupply() public view returns (uint) {
284         return _supply;
285     }
286     function balanceOf(address src) public view returns (uint) {
287         return _balances[src];
288     }
289     function allowance(address src, address guy) public view returns (uint) {
290         return _approvals[src][guy];
291     }
292 
293     function transfer(address dst, uint wad) public returns (bool) {
294         return transferFrom(msg.sender, dst, wad);
295     }
296 
297     function transferFrom(address src, address dst, uint wad)
298         public
299         returns (bool)
300     {
301         if (src != msg.sender) {
302             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
303             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
304         }
305 
306         require(_balances[src] >= wad, "ds-token-insufficient-balance");
307         _balances[src] = sub(_balances[src], wad);
308         _balances[dst] = add(_balances[dst], wad);
309 
310         emit Transfer(src, dst, wad);
311 
312         return true;
313     }
314 
315     function approve(address guy, uint wad) public returns (bool) {
316         _approvals[msg.sender][guy] = wad;
317 
318         emit Approval(msg.sender, guy, wad);
319 
320         return true;
321     }
322 }
323 
324 /// token.sol -- ERC20 implementation with minting and burning
325 
326 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
327 
328 // This program is free software: you can redistribute it and/or modify
329 // it under the terms of the GNU General Public License as published by
330 // the Free Software Foundation, either version 3 of the License, or
331 // (at your option) any later version.
332 
333 // This program is distributed in the hope that it will be useful,
334 // but WITHOUT ANY WARRANTY; without even the implied warranty of
335 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
336 // GNU General Public License for more details.
337 
338 // You should have received a copy of the GNU General Public License
339 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
340 
341 //pragma solidity >=0.4.23;
342 
343 //import "ds-stop/stop.sol";
344 
345 //import "./base.sol";
346 
347 contract DSToken is DSTokenBase(0), DSStop {
348 
349     bytes32  public  symbol;
350     uint256  public  decimals = 18; // standard token precision. override to customize
351 
352     constructor(bytes32 symbol_) public {
353         symbol = symbol_;
354     }
355 
356     event Mint(address indexed guy, uint wad);
357     event Burn(address indexed guy, uint wad);
358 
359     function approve(address guy) public stoppable returns (bool) {
360         return super.approve(guy, uint(-1));
361     }
362 
363     function approve(address guy, uint wad) public stoppable returns (bool) {
364         return super.approve(guy, wad);
365     }
366 
367     function transferFrom(address src, address dst, uint wad)
368         public
369         stoppable
370         returns (bool)
371     {
372         if (src != msg.sender && _approvals[src][msg.sender] != uint(-1)) {
373             require(_approvals[src][msg.sender] >= wad, "ds-token-insufficient-approval");
374             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
375         }
376 
377         require(_balances[src] >= wad, "ds-token-insufficient-balance");
378         _balances[src] = sub(_balances[src], wad);
379         _balances[dst] = add(_balances[dst], wad);
380 
381         emit Transfer(src, dst, wad);
382 
383         return true;
384     }
385 
386     function push(address dst, uint wad) public {
387         transferFrom(msg.sender, dst, wad);
388     }
389     function pull(address src, uint wad) public {
390         transferFrom(src, msg.sender, wad);
391     }
392     function move(address src, address dst, uint wad) public {
393         transferFrom(src, dst, wad);
394     }
395 
396     function mint(uint wad) public {
397         mint(msg.sender, wad);
398     }
399     function burn(uint wad) public {
400         burn(msg.sender, wad);
401     }
402     function mint(address guy, uint wad) public auth stoppable {
403         _balances[guy] = add(_balances[guy], wad);
404         _supply = add(_supply, wad);
405         emit Mint(guy, wad);
406     }
407     function burn(address guy, uint wad) public auth stoppable {
408         if (guy != msg.sender && _approvals[guy][msg.sender] != uint(-1)) {
409             require(_approvals[guy][msg.sender] >= wad, "ds-token-insufficient-approval");
410             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
411         }
412 
413         require(_balances[guy] >= wad, "ds-token-insufficient-balance");
414         _balances[guy] = sub(_balances[guy], wad);
415         _supply = sub(_supply, wad);
416         emit Burn(guy, wad);
417     }
418 
419     // Optional token name
420     bytes32   public  name = "";
421 
422     function setName(bytes32 name_) public auth {
423         name = name_;
424     }
425 }