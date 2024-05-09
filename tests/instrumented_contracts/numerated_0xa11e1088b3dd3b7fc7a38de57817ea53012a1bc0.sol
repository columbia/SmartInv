1 /// note.sol -- the `note' modifier, for logging calls as events
2 
3 // Copyright (C) 2017  DappHub, LLC
4 //
5 // Licensed under the Apache License, Version 2.0 (the "License").
6 // You may not use this file except in compliance with the License.
7 //
8 // Unless required by applicable law or agreed to in writing, software
9 // distributed under the License is distributed on an "AS IS" BASIS,
10 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
11 
12 pragma solidity ^0.4.24;
13 
14 contract DSNote {
15     event LogNote(
16         bytes4   indexed  sig,
17         address  indexed  guy,
18         bytes32  indexed  foo,
19         bytes32  indexed  bar,
20         uint              wad,
21         bytes             fax
22     ) anonymous;
23 
24     modifier note {
25         bytes32 foo;
26         bytes32 bar;
27 
28         assembly {
29             foo := calldataload(4)
30             bar := calldataload(36)
31         }
32 
33         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
34 
35         _;
36     }
37 }
38 /// auth.sol -- widely-used access control pattern for Ethereum
39 
40 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
41 
42 // Licensed under the Apache License, Version 2.0 (the "License").
43 // You may not use this file except in compliance with the License.
44 
45 // Unless required by applicable law or agreed to in writing, software
46 // distributed under the License is distributed on an "AS IS" BASIS,
47 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
48 
49 pragma solidity ^0.4.24;
50 
51 
52 contract DSAuthEvents {
53     event LogSetAuthority (address indexed authority);
54     event LogSetOwner     (address indexed owner);
55 }
56 
57 contract DSAuth is DSAuthEvents {
58     mapping(address => bool)  public  authority;
59     address      public  owner;
60 
61     constructor() public {
62         owner = msg.sender;
63         emit LogSetOwner(msg.sender);
64     }
65 
66     function setOwner(address owner_)
67         public
68         auth
69     {
70         owner = owner_;
71         emit LogSetOwner(owner);
72     }
73 
74     function setAuthority(address authority_)
75         public
76         auth
77     {
78         authority[authority_] = true;
79         emit LogSetAuthority(authority_);
80     }
81 
82     modifier auth {
83         require(isAuthorized(msg.sender));
84         _;
85     }
86 
87     function isAuthorized(address src) internal view returns (bool) {
88         if (src == address(this)) {
89             return true;
90         } else if (src == owner) {
91             return true;
92         } else if (authority[src] == true) {
93             return true;
94         } else {
95             return false;
96         }
97     }
98 }
99 
100 /// math.sol -- mixin for inline numerical wizardry
101 
102 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
103 
104 // Licensed under the Apache License, Version 2.0 (the "License").
105 // You may not use this file except in compliance with the License.
106 
107 // Unless required by applicable law or agreed to in writing, software
108 // distributed under the License is distributed on an "AS IS" BASIS,
109 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
110 
111 pragma solidity ^0.4.24;
112 
113 contract DSMath {
114     function add(uint x, uint y) internal pure returns (uint z) {
115         require((z = x + y) >= x);
116     }
117     function sub(uint x, uint y) internal pure returns (uint z) {
118         require((z = x - y) <= x);
119     }
120     function mul(uint x, uint y) internal pure returns (uint z) {
121         require(y == 0 || (z = x * y) / y == x);
122     }
123 
124     function min(uint x, uint y) internal pure returns (uint z) {
125         return x <= y ? x : y;
126     }
127     function max(uint x, uint y) internal pure returns (uint z) {
128         return x >= y ? x : y;
129     }
130     function imin(int x, int y) internal pure returns (int z) {
131         return x <= y ? x : y;
132     }
133     function imax(int x, int y) internal pure returns (int z) {
134         return x >= y ? x : y;
135     }
136 
137     uint constant WAD = 10 ** 18;
138     uint constant RAY = 10 ** 27;
139 
140     function wmul(uint x, uint y) internal pure returns (uint z) {
141         z = add(mul(x, y), WAD / 2) / WAD;
142     }
143     function rmul(uint x, uint y) internal pure returns (uint z) {
144         z = add(mul(x, y), RAY / 2) / RAY;
145     }
146     function wdiv(uint x, uint y) internal pure returns (uint z) {
147         z = add(mul(x, WAD), y / 2) / y;
148     }
149     function rdiv(uint x, uint y) internal pure returns (uint z) {
150         z = add(mul(x, RAY), y / 2) / y;
151     }
152 
153     // This famous algorithm is called "exponentiation by squaring"
154     // and calculates x^n with x as fixed-point and n as regular unsigned.
155     //
156     // It's O(log n), instead of O(n) for naive repeated multiplication.
157     //
158     // These facts are why it works:
159     //
160     //  If n is even, then x^n = (x^2)^(n/2).
161     //  If n is odd,  then x^n = x * x^(n-1),
162     //   and applying the equation for even x gives
163     //    x^n = x * (x^2)^((n-1) / 2).
164     //
165     //  Also, EVM division is flooring and
166     //    floor[(n-1) / 2] = floor[n / 2].
167     //
168     function rpow(uint x, uint n) internal pure returns (uint z) {
169         z = n % 2 != 0 ? x : RAY;
170 
171         for (n /= 2; n != 0; n /= 2) {
172             x = rmul(x, x);
173 
174             if (n % 2 != 0) {
175                 z = rmul(z, x);
176             }
177         }
178     }
179 }
180 
181 /*
182    Copyright 2017 DappHub, LLC
183 
184    Licensed under the Apache License, Version 2.0 (the "License");
185    you may not use this file except in compliance with the License.
186    You may obtain a copy of the License at
187 
188        http://www.apache.org/licenses/LICENSE-2.0
189 
190    Unless required by applicable law or agreed to in writing, software
191    distributed under the License is distributed on an "AS IS" BASIS,
192    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
193    See the License for the specific language governing permissions and
194    limitations under the License.
195 */
196 
197 pragma solidity ^0.4.24;
198 
199 // Token standard API
200 // https://github.com/ethereum/EIPs/issues/20
201 
202 contract ERC20 {
203     function totalSupply() public view returns (uint supply);
204     function balanceOf( address who ) public view returns (uint value);
205     function allowance( address owner, address spender ) public view returns (uint _allowance);
206 
207     function transfer( address to, uint value) public returns (bool ok);
208     function transferFrom( address from, address to, uint value) public returns (bool ok);
209     function approve( address spender, uint value ) public returns (bool ok);
210 
211     event Transfer( address indexed from, address indexed to, uint value);
212     event Approval( address indexed owner, address indexed spender, uint value);
213 }
214 
215 /// stop.sol -- mixin for enable/disable functionality
216 
217 // Copyright (C) 2017  DappHub, LLC
218 
219 // Licensed under the Apache License, Version 2.0 (the "License").
220 // You may not use this file except in compliance with the License.
221 
222 // Unless required by applicable law or agreed to in writing, software
223 // distributed under the License is distributed on an "AS IS" BASIS,
224 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
225 
226 pragma solidity ^0.4.13;
227 
228 
229 contract DSStop is DSNote, DSAuth {
230 
231     bool public stopped;
232 
233     modifier stoppable {
234         require(!stopped);
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
246 /// base.sol -- basic ERC20 implementation
247 
248 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
249 
250 // Licensed under the Apache License, Version 2.0 (the "License").
251 // You may not use this file except in compliance with the License.
252 
253 // Unless required by applicable law or agreed to in writing, software
254 // distributed under the License is distributed on an "AS IS" BASIS,
255 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
256 
257 pragma solidity ^0.4.24;
258 
259 
260 contract DSTokenBase is ERC20, DSMath {
261     uint256                                            _supply;
262     mapping (address => uint256)                       _balances;
263     mapping (address => mapping (address => uint256))  _approvals;
264 
265     constructor (uint supply) public {
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
295         emit Transfer(src, dst, wad);
296 
297         return true;
298     }
299 
300     function approve(address guy, uint wad) public returns (bool) {
301         _approvals[msg.sender][guy] = wad;
302 
303         emit Approval(msg.sender, guy, wad);
304 
305         return true;
306     }
307 }
308 /// token.sol -- ERC20 implementation with minting and burning
309 
310 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
311 
312 // Licensed under the Apache License, Version 2.0 (the "License").
313 // You may not use this file except in compliance with the License.
314 
315 // Unless required by applicable law or agreed to in writing, software
316 // distributed under the License is distributed on an "AS IS" BASIS,
317 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
318 
319 pragma solidity ^0.4.24;
320 
321 
322 
323 contract TrueGoldToken is DSTokenBase(0), DSStop {
324 
325     mapping (address => mapping (address => bool)) _trusted;
326 
327     // Optional token name
328     string  public  name = "";
329     string  public  symbol = "";
330     uint256  public  decimals = 18; // standard token precision. override to customize
331     uint256 public totalBuyBackRequested;
332     
333     constructor (string name_,string symbol_) public {
334         name = name_;
335         symbol = symbol_;
336     }
337 
338     event Trust(address indexed src, address indexed guy, bool wat);
339     event BuyBackIssuance(address buyBackHolder,address indexed guy, uint wad);
340     event Mint(address indexed guy, uint wad);
341     event Burn(address indexed guy, uint wad);
342     event BuyBackRequested(address indexed guy,uint wad);
343     
344     
345     function trusted(address src, address guy) public view returns (bool) {
346         return _trusted[src][guy];
347     }
348     function trust(address guy, bool wat) public stoppable {
349         _trusted[msg.sender][guy] = wat;
350         emit Trust(msg.sender, guy, wat);
351     }
352 
353     function approve(address guy, uint wad) public stoppable returns (bool) {
354         return super.approve(guy, wad);
355     }
356     
357     function transfer(address dst, uint wad) public stoppable returns (bool) {
358         
359         return super.transfer(dst,wad);
360     }
361     
362     
363     function transferFrom(address src, address dst, uint wad)
364         public
365         stoppable
366         returns (bool)
367     {
368         if (src != msg.sender && !_trusted[src][msg.sender]) {
369             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
370         }
371 
372         _balances[src] = sub(_balances[src], wad);
373         _balances[dst] = add(_balances[dst], wad);
374 
375         emit Transfer(src, dst, wad);
376 
377         return true;
378     }
379 
380     function mint(uint wad) public {
381         mint(msg.sender, wad);
382     }
383     function burn(uint wad) public {
384         burn(msg.sender, wad);
385     }
386     function mint(address guy, uint wad) public auth stoppable {
387         _balances[guy] = add(_balances[guy], wad);
388         _supply = add(_supply, wad);
389         
390         emit Mint(guy, wad);
391     }
392 
393     function burn(address guy, uint wad) public auth stoppable {
394 
395         _balances[guy] = sub(_balances[guy], wad);
396         _supply = sub(_supply, wad);
397         emit Burn(guy, wad);
398     }
399 
400     function sendBuyBackRequest(address _sender,uint wad) public returns(bool)
401     {   
402         require(wad > 0,"Insufficient Value");
403         require(_balances[_sender] >= wad,"Insufficient Balance");
404 
405         burn(_sender,wad);
406 
407         totalBuyBackRequested = add(totalBuyBackRequested,wad);
408 
409         emit BuyBackRequested(_sender, wad);
410 
411         return true;
412     }
413 
414     function setName(string name_) public auth {
415         name = name_;
416     }
417 
418     
419 }