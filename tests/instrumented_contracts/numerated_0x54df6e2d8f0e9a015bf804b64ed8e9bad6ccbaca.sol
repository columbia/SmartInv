1 /// math.sol -- mixin for inline numerical wizardry
2 
3 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
4 
5 // Licensed under the Apache License, Version 2.0 (the "License").
6 // You may not use this file except in compliance with the License.
7 
8 // Unless required by applicable law or agreed to in writing, software
9 // distributed under the License is distributed on an "AS IS" BASIS,
10 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
11 
12 pragma solidity ^0.4.13;
13 
14 contract DSMath {
15     function add(uint x, uint y) internal pure returns (uint z) {
16         require((z = x + y) >= x);
17     }
18     function sub(uint x, uint y) internal pure returns (uint z) {
19         require((z = x - y) <= x);
20     }
21     function mul(uint x, uint y) internal pure returns (uint z) {
22         require(y == 0 || (z = x * y) / y == x);
23     }
24 
25     function min(uint x, uint y) internal pure returns (uint z) {
26         return x <= y ? x : y;
27     }
28     function max(uint x, uint y) internal pure returns (uint z) {
29         return x >= y ? x : y;
30     }
31     function imin(int x, int y) internal pure returns (int z) {
32         return x <= y ? x : y;
33     }
34     function imax(int x, int y) internal pure returns (int z) {
35         return x >= y ? x : y;
36     }
37 
38     uint constant WAD = 10 ** 18;
39     uint constant RAY = 10 ** 27;
40 
41     function wmul(uint x, uint y) internal pure returns (uint z) {
42         z = add(mul(x, y), WAD / 2) / WAD;
43     }
44     function rmul(uint x, uint y) internal pure returns (uint z) {
45         z = add(mul(x, y), RAY / 2) / RAY;
46     }
47     function wdiv(uint x, uint y) internal pure returns (uint z) {
48         z = add(mul(x, WAD), y / 2) / y;
49     }
50     function rdiv(uint x, uint y) internal pure returns (uint z) {
51         z = add(mul(x, RAY), y / 2) / y;
52     }
53 
54     // This famous algorithm is called "exponentiation by squaring"
55     // and calculates x^n with x as fixed-point and n as regular unsigned.
56     //
57     // It's O(log n), instead of O(n) for naive repeated multiplication.
58     //
59     // These facts are why it works:
60     //
61     //  If n is even, then x^n = (x^2)^(n/2).
62     //  If n is odd,  then x^n = x * x^(n-1),
63     //   and applying the equation for even x gives
64     //    x^n = x * (x^2)^((n-1) / 2).
65     //
66     //  Also, EVM division is flooring and
67     //    floor[(n-1) / 2] = floor[n / 2].
68     //
69     function rpow(uint x, uint n) internal pure returns (uint z) {
70         z = n % 2 != 0 ? x : RAY;
71 
72         for (n /= 2; n != 0; n /= 2) {
73             x = rmul(x, x);
74 
75             if (n % 2 != 0) {
76                 z = rmul(z, x);
77             }
78         }
79     }
80 }
81 
82 /// auth.sol -- widely-used access control pattern for Ethereum
83 
84 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
85 
86 // Licensed under the Apache License, Version 2.0 (the "License").
87 // You may not use this file except in compliance with the License.
88 
89 // Unless required by applicable law or agreed to in writing, software
90 // distributed under the License is distributed on an "AS IS" BASIS,
91 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
92 
93 pragma solidity ^0.4.13;
94 
95 contract DSAuthority {
96     function canCall(
97         address src, address dst, bytes4 sig
98     ) public view returns (bool);
99 }
100 
101 contract DSAuthEvents {
102     event LogSetAuthority (address indexed authority);
103     event LogSetOwner     (address indexed owner);
104 }
105 
106 contract DSAuth is DSAuthEvents {
107     DSAuthority  public  authority;
108     address      public  owner;
109 
110     function DSAuth() public {
111         owner = msg.sender;
112         LogSetOwner(msg.sender);
113     }
114 
115     function setOwner(address owner_)
116         public
117         auth
118     {
119         owner = owner_;
120         LogSetOwner(owner);
121     }
122 
123     function setAuthority(DSAuthority authority_)
124         public
125         auth
126     {
127         authority = authority_;
128         LogSetAuthority(authority);
129     }
130 
131     modifier auth {
132         require(isAuthorized(msg.sender, msg.sig));
133         _;
134     }
135 
136     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
137         if (src == address(this)) {
138             return true;
139         } else if (src == owner) {
140             return true;
141         } else if (authority == DSAuthority(0)) {
142             return false;
143         } else {
144             return authority.canCall(src, this, sig);
145         }
146     }
147 }
148 
149 /// note.sol -- the `note' modifier, for logging calls as events
150 
151 // Copyright (C) 2017  DappHub, LLC
152 //
153 // Licensed under the Apache License, Version 2.0 (the "License").
154 // You may not use this file except in compliance with the License.
155 //
156 // Unless required by applicable law or agreed to in writing, software
157 // distributed under the License is distributed on an "AS IS" BASIS,
158 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
159 
160 pragma solidity ^0.4.13;
161 
162 contract DSNote {
163     event LogNote(
164         bytes4   indexed  sig,
165         address  indexed  guy,
166         bytes32  indexed  foo,
167         bytes32  indexed  bar,
168         uint              wad,
169         bytes             fax
170     ) anonymous;
171 
172     modifier note {
173         bytes32 foo;
174         bytes32 bar;
175 
176         assembly {
177             foo := calldataload(4)
178             bar := calldataload(36)
179         }
180 
181         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
182 
183         _;
184     }
185 }
186 
187 /// stop.sol -- mixin for enable/disable functionality
188 
189 // Copyright (C) 2017  DappHub, LLC
190 
191 // Licensed under the Apache License, Version 2.0 (the "License").
192 // You may not use this file except in compliance with the License.
193 
194 // Unless required by applicable law or agreed to in writing, software
195 // distributed under the License is distributed on an "AS IS" BASIS,
196 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
197 
198 pragma solidity ^0.4.13;
199 
200 contract DSStop is DSNote, DSAuth {
201 
202     bool public stopped;
203 
204     modifier stoppable {
205         require(!stopped);
206         _;
207     }
208     function stop() public auth note {
209         stopped = true;
210     }
211     function start() public auth note {
212         stopped = false;
213     }
214 
215 }
216 
217 /*
218    Copyright 2017 DappHub, LLC
219 
220    Licensed under the Apache License, Version 2.0 (the "License");
221    you may not use this file except in compliance with the License.
222    You may obtain a copy of the License at
223 
224        http://www.apache.org/licenses/LICENSE-2.0
225 
226    Unless required by applicable law or agreed to in writing, software
227    distributed under the License is distributed on an "AS IS" BASIS,
228    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
229    See the License for the specific language governing permissions and
230    limitations under the License.
231 */
232 
233 pragma solidity ^0.4.8;
234 
235 // Token standard API
236 // https://github.com/ethereum/EIPs/issues/20
237 
238 contract ERC20 {
239     function totalSupply() public view returns (uint supply);
240     function balanceOf( address who ) public view returns (uint value);
241     function allowance( address owner, address spender ) public view returns (uint _allowance);
242 
243     function transfer( address to, uint value) public returns (bool ok);
244     function transferFrom( address from, address to, uint value) public returns (bool ok);
245     function approve( address spender, uint value ) public returns (bool ok);
246 
247     event Transfer( address indexed from, address indexed to, uint value);
248     event Approval( address indexed owner, address indexed spender, uint value);
249 }
250 
251 /// base.sol -- basic ERC20 implementation
252 
253 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
254 
255 // Licensed under the Apache License, Version 2.0 (the "License").
256 // You may not use this file except in compliance with the License.
257 
258 // Unless required by applicable law or agreed to in writing, software
259 // distributed under the License is distributed on an "AS IS" BASIS,
260 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
261 
262 pragma solidity ^0.4.13;
263 
264 contract DSTokenBase is ERC20, DSMath {
265     uint256                                            _supply;
266     mapping (address => uint256)                       _balances;
267     mapping (address => mapping (address => uint256))  _approvals;
268 
269     function DSTokenBase(uint supply) public {
270         _balances[msg.sender] = supply;
271         _supply = supply;
272     }
273 
274     function totalSupply() public view returns (uint) {
275         return _supply;
276     }
277     function balanceOf(address src) public view returns (uint) {
278         return _balances[src];
279     }
280     function allowance(address src, address guy) public view returns (uint) {
281         return _approvals[src][guy];
282     }
283 
284     function transfer(address dst, uint wad) public returns (bool) {
285         return transferFrom(msg.sender, dst, wad);
286     }
287 
288     function transferFrom(address src, address dst, uint wad)
289         public
290         returns (bool)
291     {
292         if (src != msg.sender) {
293             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
294         }
295 
296         _balances[src] = sub(_balances[src], wad);
297         _balances[dst] = add(_balances[dst], wad);
298 
299         Transfer(src, dst, wad);
300 
301         return true;
302     }
303 
304     function approve(address guy, uint wad) public returns (bool) {
305         _approvals[msg.sender][guy] = wad;
306 
307         Approval(msg.sender, guy, wad);
308 
309         return true;
310     }
311 }
312 
313 /// token.sol -- ERC20 implementation with minting and burning
314 
315 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
316 
317 // Licensed under the Apache License, Version 2.0 (the "License").
318 // You may not use this file except in compliance with the License.
319 
320 // Unless required by applicable law or agreed to in writing, software
321 // distributed under the License is distributed on an "AS IS" BASIS,
322 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
323 
324 pragma solidity ^0.4.13;
325 
326 contract DSToken is DSTokenBase(0), DSStop {
327 
328     mapping (address => mapping (address => bool)) _trusted;
329 
330     bytes32  public  symbol;
331     uint256  public  decimals = 18; // standard token precision. override to customize
332 
333     function DSToken(bytes32 symbol_) public {
334         symbol = symbol_;
335     }
336 
337     event Trust(address indexed src, address indexed guy, bool wat);
338     event Mint(address indexed guy, uint wad);
339     event Burn(address indexed guy, uint wad);
340 
341     function trusted(address src, address guy) public view returns (bool) {
342         return _trusted[src][guy];
343     }
344     function trust(address guy, bool wat) public stoppable {
345         _trusted[msg.sender][guy] = wat;
346         Trust(msg.sender, guy, wat);
347     }
348 
349     function approve(address guy, uint wad) public stoppable returns (bool) {
350         return super.approve(guy, wad);
351     }
352     function transferFrom(address src, address dst, uint wad)
353         public
354         stoppable
355         returns (bool)
356     {
357         if (src != msg.sender && !_trusted[src][msg.sender]) {
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
391         if (guy != msg.sender && !_trusted[guy][msg.sender]) {
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
408 pragma solidity ^0.4.24;
409 
410 // Pay to publish videos on Viewly.
411 contract VideoPublisher is DSAuth, DSMath {
412 
413     DSToken public viewToken;
414     uint public priceView;
415     uint public priceEth;
416     // videoID => publisher
417     mapping (bytes12 => address) public videos;
418     event Published(bytes12 videoID);
419 
420     function VideoPublisher(
421         DSToken viewToken_,
422         uint priceView_,
423         uint priceEth_) public {
424         viewToken = viewToken_;
425         priceView = priceView_;
426         priceEth = priceEth_;
427     }
428 
429     function publish(bytes12 videoID) payable public {
430         require(videos[videoID] == 0);
431         if (msg.value == 0) {
432             require(viewToken.transferFrom(msg.sender, address(this), priceView));
433         } else {
434             require(msg.value >= priceEth);
435         }
436         videos[videoID] = msg.sender;
437         emit Published(videoID);
438     }
439 
440     function publishFor(bytes12 videoID, address beneficiary) payable public {
441         require(videos[videoID] == 0);
442         if (msg.value == 0) {
443             require(viewToken.transferFrom(msg.sender, address(this), priceView));
444         } else {
445             require(msg.value >= priceEth);
446         }
447         videos[videoID] = beneficiary;
448         emit Published(videoID);
449     }
450 
451     function setPrices(uint priceView_, uint priceEth_) public auth {
452         priceView = priceView_;
453         priceEth = priceEth_;
454     }
455 
456     function withdraw(address addr) public payable auth {
457         uint tokenBalance = viewToken.balanceOf(this);
458         if (tokenBalance > 0) {
459             viewToken.transfer(addr, tokenBalance);
460         }
461         if (address(this).balance > 0) {
462             addr.transfer(address(this).balance);
463         }
464     }
465 
466     function destruct(address addr) public payable auth {
467         require(address(this).balance == 0);
468         require(viewToken.balanceOf(this) == 0);
469         selfdestruct(addr);
470     }
471 
472     function () public payable {
473         revert();
474     }
475 
476 }