1 /// token.sol -- ERC20 implementation with minting and burning
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
12 pragma solidity ^0.4.24;
13 
14 /// stop.sol -- mixin for enable/disable functionality
15 
16 // Copyright (C) 2017  DappHub, LLC
17 
18 // Licensed under the Apache License, Version 2.0 (the "License").
19 // You may not use this file except in compliance with the License.
20 
21 // Unless required by applicable law or agreed to in writing, software
22 // distributed under the License is distributed on an "AS IS" BASIS,
23 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
24 
25 
26 
27 /// auth.sol -- widely-used access control pattern for Ethereum
28 
29 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
30 
31 // Licensed under the Apache License, Version 2.0 (the "License").
32 // You may not use this file except in compliance with the License.
33 
34 // Unless required by applicable law or agreed to in writing, software
35 // distributed under the License is distributed on an "AS IS" BASIS,
36 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
37 
38 
39 
40 
41 contract DSAuthEvents {
42     event LogSetAuthority (address indexed authority);
43     event LogSetOwner     (address indexed owner);
44 }
45 
46 contract DSAuth is DSAuthEvents {
47     mapping(address => bool)  public  authority;
48     address      public  owner;
49 
50     constructor() public {
51         owner = msg.sender;
52         emit LogSetOwner(msg.sender);
53     }
54 
55     function setOwner(address owner_)
56         public
57         auth
58     {
59         owner = owner_;
60         emit LogSetOwner(owner);
61     }
62 
63     function setAuthority(address authority_)
64         public
65         auth
66     {
67         authority[authority_] = true;
68         emit LogSetAuthority(authority_);
69     }
70 
71     modifier auth {
72         require(isAuthorized(msg.sender));
73         _;
74     }
75 
76     function isAuthorized(address src) internal view returns (bool) {
77         if (src == address(this)) {
78             return true;
79         } else if (src == owner) {
80             return true;
81         } else if (authority[src] == true) {
82             return true;
83         } else {
84             return false;
85         }
86     }
87 }
88 
89 /// note.sol -- the `note' modifier, for logging calls as events
90 
91 // Copyright (C) 2017  DappHub, LLC
92 //
93 // Licensed under the Apache License, Version 2.0 (the "License").
94 // You may not use this file except in compliance with the License.
95 //
96 // Unless required by applicable law or agreed to in writing, software
97 // distributed under the License is distributed on an "AS IS" BASIS,
98 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
99 
100 
101 
102 contract DSNote {
103     event LogNote(
104         bytes4   indexed  sig,
105         address  indexed  guy,
106         bytes32  indexed  foo,
107         bytes32  indexed  bar,
108         uint              wad,
109         bytes             fax
110     ) anonymous;
111 
112     modifier note {
113         bytes32 foo;
114         bytes32 bar;
115 
116         assembly {
117             foo := calldataload(4)
118             bar := calldataload(36)
119         }
120 
121         emit LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
122 
123         _;
124     }
125 }
126 
127 
128 contract DSStop is DSNote, DSAuth {
129 
130     bool public stopped;
131 
132     modifier stoppable {
133         require(!stopped);
134         _;
135     }
136     function stop() public auth note {
137         stopped = true;
138     }
139     function start() public auth note {
140         stopped = false;
141     }
142 
143 }
144 
145 /// base.sol -- basic ERC20 implementation
146 
147 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
148 
149 // Licensed under the Apache License, Version 2.0 (the "License").
150 // You may not use this file except in compliance with the License.
151 
152 // Unless required by applicable law or agreed to in writing, software
153 // distributed under the License is distributed on an "AS IS" BASIS,
154 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
155 
156 
157 
158 /*
159    Copyright 2017 DappHub, LLC
160 
161    Licensed under the Apache License, Version 2.0 (the "License");
162    you may not use this file except in compliance with the License.
163    You may obtain a copy of the License at
164 
165        http://www.apache.org/licenses/LICENSE-2.0
166 
167    Unless required by applicable law or agreed to in writing, software
168    distributed under the License is distributed on an "AS IS" BASIS,
169    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
170    See the License for the specific language governing permissions and
171    limitations under the License.
172 */
173 
174 
175 
176 // Token standard API
177 // https://github.com/ethereum/EIPs/issues/20
178 
179 contract ERC20 {
180     function totalSupply() public view returns (uint supply);
181     function balanceOf( address who ) public view returns (uint value);
182     function allowance( address owner, address spender ) public view returns (uint _allowance);
183 
184     function transfer( address to, uint value) public returns (bool ok);
185     function transferFrom( address from, address to, uint value) public returns (bool ok);
186     function approve( address spender, uint value ) public returns (bool ok);
187 
188     event Transfer( address indexed from, address indexed to, uint value);
189     event Approval( address indexed owner, address indexed spender, uint value);
190 }
191 
192 /// math.sol -- mixin for inline numerical wizardry
193 
194 // Copyright (C) 2015, 2016, 2017  DappHub, LLC
195 
196 // Licensed under the Apache License, Version 2.0 (the "License").
197 // You may not use this file except in compliance with the License.
198 
199 // Unless required by applicable law or agreed to in writing, software
200 // distributed under the License is distributed on an "AS IS" BASIS,
201 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
202 
203 
204 
205 contract DSMath {
206     function add(uint x, uint y) internal pure returns (uint z) {
207         require((z = x + y) >= x);
208     }
209     function sub(uint x, uint y) internal pure returns (uint z) {
210         require((z = x - y) <= x);
211     }
212     function mul(uint x, uint y) internal pure returns (uint z) {
213         require(y == 0 || (z = x * y) / y == x);
214     }
215 
216     function min(uint x, uint y) internal pure returns (uint z) {
217         return x <= y ? x : y;
218     }
219     function max(uint x, uint y) internal pure returns (uint z) {
220         return x >= y ? x : y;
221     }
222     function imin(int x, int y) internal pure returns (int z) {
223         return x <= y ? x : y;
224     }
225     function imax(int x, int y) internal pure returns (int z) {
226         return x >= y ? x : y;
227     }
228 
229     uint constant WAD = 10 ** 18;
230     uint constant RAY = 10 ** 27;
231 
232     function wmul(uint x, uint y) internal pure returns (uint z) {
233         z = add(mul(x, y), WAD / 2) / WAD;
234     }
235     function rmul(uint x, uint y) internal pure returns (uint z) {
236         z = add(mul(x, y), RAY / 2) / RAY;
237     }
238     function wdiv(uint x, uint y) internal pure returns (uint z) {
239         z = add(mul(x, WAD), y / 2) / y;
240     }
241     function rdiv(uint x, uint y) internal pure returns (uint z) {
242         z = add(mul(x, RAY), y / 2) / y;
243     }
244 
245     // This famous algorithm is called "exponentiation by squaring"
246     // and calculates x^n with x as fixed-point and n as regular unsigned.
247     //
248     // It's O(log n), instead of O(n) for naive repeated multiplication.
249     //
250     // These facts are why it works:
251     //
252     //  If n is even, then x^n = (x^2)^(n/2).
253     //  If n is odd,  then x^n = x * x^(n-1),
254     //   and applying the equation for even x gives
255     //    x^n = x * (x^2)^((n-1) / 2).
256     //
257     //  Also, EVM division is flooring and
258     //    floor[(n-1) / 2] = floor[n / 2].
259     //
260     function rpow(uint x, uint n) internal pure returns (uint z) {
261         z = n % 2 != 0 ? x : RAY;
262 
263         for (n /= 2; n != 0; n /= 2) {
264             x = rmul(x, x);
265 
266             if (n % 2 != 0) {
267                 z = rmul(z, x);
268             }
269         }
270     }
271 }
272 
273 
274 contract DSTokenBase is ERC20, DSMath {
275     uint256                                            _supply;
276     mapping (address => uint256)                       _balances;
277     mapping (address => mapping (address => uint256))  _approvals;
278 
279     constructor (uint supply) public {
280         _balances[msg.sender] = supply;
281         _supply = supply;
282     }
283 
284     function totalSupply() public view returns (uint) {
285         return _supply;
286     }
287     function balanceOf(address src) public view returns (uint) {
288         return _balances[src];
289     }
290     function allowance(address src, address guy) public view returns (uint) {
291         return _approvals[src][guy];
292     }
293 
294     function transfer(address dst, uint wad) public returns (bool) {
295         return transferFrom(msg.sender, dst, wad);
296     }
297 
298     function transferFrom(address src, address dst, uint wad)
299         public
300         returns (bool)
301     {
302         if (src != msg.sender) {
303             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
304         }
305 
306         _balances[src] = sub(_balances[src], wad);
307         _balances[dst] = add(_balances[dst], wad);
308 
309         emit Transfer(src, dst, wad);
310 
311         return true;
312     }
313 
314     function approve(address guy, uint wad) public returns (bool) {
315         _approvals[msg.sender][guy] = wad;
316 
317         emit Approval(msg.sender, guy, wad);
318 
319         return true;
320     }
321 }
322 
323 
324 
325 
326 
327 contract KYCVerification is DSAuth{
328     
329     mapping(address => bool) public kycAddress;
330     
331     event LogKYCVerification(address _kycAddress,bool _status);
332     
333     function addVerified(address[] _kycAddress,bool _status) auth public
334     {
335         for(uint tmpIndex = 0; tmpIndex <= _kycAddress.length; tmpIndex++)
336         {
337             kycAddress[_kycAddress[tmpIndex]] = _status;
338         }
339     }
340     
341     function updateVerifcation(address _kycAddress,bool _status) auth public
342     {
343         kycAddress[_kycAddress] = _status;
344         
345         emit LogKYCVerification(_kycAddress,_status);
346     }
347     
348     function isVerified(address _user) view public returns(bool)
349     {
350         return kycAddress[_user] == true; 
351     }
352 }
353 
354 
355 contract DSToken is DSTokenBase(0), DSStop {
356 
357     mapping (address => mapping (address => bool)) _trusted;
358 
359     // Optional token name
360     string  public  name = "zeosX";
361     string  public  symbol;
362     uint256  public  decimals = 18; // standard token precision. override to customize
363     bool public kycEnabled = true;
364 
365     KYCVerification public kycVerification;
366     
367     constructor (string name_,string symbol_,KYCVerification _kycAddress) public {
368         name = name_;
369         symbol = symbol_;
370         
371         kycVerification = _kycAddress;
372     }
373 
374     event Trust(address indexed src, address indexed guy, bool wat);
375     event Burn(address indexed guy, uint wad);
376     event KYCMandateUpdate(bool _kycEnabled);
377     
378     modifier kycVerified(address _guy) {
379 
380         if(kycEnabled == true)
381         {
382             if(kycVerification.isVerified(_guy) == false)
383             {
384                 revert("KYC Not Verified");
385             }
386         }
387         _;
388     }
389     
390     function updateKycMandate(bool _kycEnabled) public auth
391     {
392         kycEnabled = _kycEnabled;
393         emit KYCMandateUpdate(_kycEnabled);
394     }
395 
396     function trusted(address src, address guy) public view returns (bool) {
397         return _trusted[src][guy];
398     }
399     function trust(address guy, bool wat) public stoppable {
400         _trusted[msg.sender][guy] = wat;
401         emit Trust(msg.sender, guy, wat);
402     }
403 
404     function approve(address guy, uint wad) public stoppable returns (bool) {
405         return super.approve(guy, wad);
406     }
407     
408     function transfer(address dst, uint wad) public stoppable kycVerified(msg.sender) returns (bool) {
409         
410         return super.transfer(dst,wad);
411     }
412     
413     
414     function transferFrom(address src, address dst, uint wad)
415         public
416         stoppable
417         returns (bool)
418     {
419         if (src != msg.sender && !_trusted[src][msg.sender]) {
420             _approvals[src][msg.sender] = sub(_approvals[src][msg.sender], wad);
421         }
422 
423         _balances[src] = sub(_balances[src], wad);
424         _balances[dst] = add(_balances[dst], wad);
425 
426         emit Transfer(src, dst, wad);
427 
428         return true;
429     }
430 
431     function mint(uint wad) public {
432         mint(msg.sender, wad);
433     }
434     function burn(uint wad) public {
435         burn(msg.sender, wad);
436     }
437     function mint(address guy, uint wad) public auth stoppable {
438         _balances[guy] = add(_balances[guy], wad);
439         _supply = add(_supply, wad);
440         
441         emit Transfer(address(0),address(this),wad);
442         emit Transfer(address(this),guy,wad);
443     }
444     function burn(address guy, uint wad) public auth stoppable {
445         if (guy != msg.sender && !_trusted[guy][msg.sender]) {
446             _approvals[guy][msg.sender] = sub(_approvals[guy][msg.sender], wad);
447         }
448 
449         _balances[guy] = sub(_balances[guy], wad);
450         _supply = sub(_supply, wad);
451         emit Burn(guy, wad);
452     }
453 
454     
455 
456     function setName(string name_) public auth {
457         name = name_;
458     }
459 }