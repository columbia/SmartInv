1 pragma solidity ^0.5.2;
2 
3 // File: contracts/Oracle/DSMath.sol
4 
5 contract DSMath {
6     /*
7     standard uint256 functions
8      */
9 
10     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
11         assert((z = x + y) >= x);
12     }
13 
14     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
15         assert((z = x - y) <= x);
16     }
17 
18     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
19         assert((z = x * y) >= x);
20     }
21 
22     function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
23         z = x / y;
24     }
25 
26     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
27         return x <= y ? x : y;
28     }
29 
30     function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
31         return x >= y ? x : y;
32     }
33 
34     /*
35     uint128 functions (h is for half)
36      */
37 
38     function hadd(uint128 x, uint128 y) internal pure returns (uint128 z) {
39         assert((z = x + y) >= x);
40     }
41 
42     function hsub(uint128 x, uint128 y) internal pure returns (uint128 z) {
43         assert((z = x - y) <= x);
44     }
45 
46     function hmul(uint128 x, uint128 y) internal pure returns (uint128 z) {
47         assert((z = x * y) >= x);
48     }
49 
50     function hdiv(uint128 x, uint128 y) internal pure returns (uint128 z) {
51         z = x / y;
52     }
53 
54     function hmin(uint128 x, uint128 y) internal pure returns (uint128 z) {
55         return x <= y ? x : y;
56     }
57 
58     function hmax(uint128 x, uint128 y) internal pure returns (uint128 z) {
59         return x >= y ? x : y;
60     }
61 
62     /*
63     int256 functions
64      */
65 
66     function imin(int256 x, int256 y) internal pure returns (int256 z) {
67         return x <= y ? x : y;
68     }
69 
70     function imax(int256 x, int256 y) internal pure returns (int256 z) {
71         return x >= y ? x : y;
72     }
73 
74     /*
75     WAD math
76      */
77 
78     uint128 constant WAD = 10 ** 18;
79 
80     function wadd(uint128 x, uint128 y) internal pure returns (uint128) {
81         return hadd(x, y);
82     }
83 
84     function wsub(uint128 x, uint128 y) internal pure returns (uint128) {
85         return hsub(x, y);
86     }
87 
88     function wmul(uint128 x, uint128 y) internal pure returns (uint128 z) {
89         z = cast((uint256(x) * y + WAD / 2) / WAD);
90     }
91 
92     function wdiv(uint128 x, uint128 y) internal pure returns (uint128 z) {
93         z = cast((uint256(x) * WAD + y / 2) / y);
94     }
95 
96     function wmin(uint128 x, uint128 y) internal pure returns (uint128) {
97         return hmin(x, y);
98     }
99 
100     function wmax(uint128 x, uint128 y) internal pure returns (uint128) {
101         return hmax(x, y);
102     }
103 
104     /*
105     RAY math
106      */
107 
108     uint128 constant RAY = 10 ** 27;
109 
110     function radd(uint128 x, uint128 y) internal pure returns (uint128) {
111         return hadd(x, y);
112     }
113 
114     function rsub(uint128 x, uint128 y) internal pure returns (uint128) {
115         return hsub(x, y);
116     }
117 
118     function rmul(uint128 x, uint128 y) internal pure returns (uint128 z) {
119         z = cast((uint256(x) * y + RAY / 2) / RAY);
120     }
121 
122     function rdiv(uint128 x, uint128 y) internal pure returns (uint128 z) {
123         z = cast((uint256(x) * RAY + y / 2) / y);
124     }
125 
126     function rpow(uint128 x, uint64 n) internal pure returns (uint128 z) {
127         // This famous algorithm is called "exponentiation by squaring"
128         // and calculates x^n with x as fixed-point and n as regular unsigned.
129         //
130         // It's O(log n), instead of O(n) for naive repeated multiplication.
131         //
132         // These facts are why it works:
133         //
134         //  If n is even, then x^n = (x^2)^(n/2).
135         //  If n is odd,  then x^n = x * x^(n-1),
136         //   and applying the equation for even x gives
137         //    x^n = x * (x^2)^((n-1) / 2).
138         //
139         //  Also, EVM division is flooring and
140         //    floor[(n-1) / 2] = floor[n / 2].
141 
142         z = n % 2 != 0 ? x : RAY;
143 
144         for (n /= 2; n != 0; n /= 2) {
145             x = rmul(x, x);
146 
147             if (n % 2 != 0) {
148                 z = rmul(z, x);
149             }
150         }
151     }
152 
153     function rmin(uint128 x, uint128 y) internal pure returns (uint128) {
154         return hmin(x, y);
155     }
156 
157     function rmax(uint128 x, uint128 y) internal pure returns (uint128) {
158         return hmax(x, y);
159     }
160 
161     function cast(uint256 x) internal pure returns (uint128 z) {
162         assert((z = uint128(x)) == x);
163     }
164 
165 }
166 
167 // File: contracts/Oracle/DSAuth.sol
168 
169 contract DSAuthority {
170     function canCall(address src, address dst, bytes4 sig) public view returns (bool);
171 }
172 
173 
174 contract DSAuthEvents {
175     event LogSetAuthority(address indexed authority);
176     event LogSetOwner(address indexed owner);
177 }
178 
179 
180 contract DSAuth is DSAuthEvents {
181     DSAuthority public authority;
182     address public owner;
183 
184     constructor() public {
185         owner = msg.sender;
186         emit LogSetOwner(msg.sender);
187     }
188 
189     function setOwner(address owner_) public auth {
190         owner = owner_;
191         emit LogSetOwner(owner);
192     }
193 
194     function setAuthority(DSAuthority authority_) public auth {
195         authority = authority_;
196         emit LogSetAuthority(address(authority));
197     }
198 
199     modifier auth {
200         require(isAuthorized(msg.sender, msg.sig), "It must be an authorized call");
201         _;
202     }
203 
204     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
205         if (src == address(this)) {
206             return true;
207         } else if (src == owner) {
208             return true;
209         } else if (authority == DSAuthority(0)) {
210             return false;
211         } else {
212             return authority.canCall(src, address(this), sig);
213         }
214     }
215 }
216 
217 // File: contracts/Oracle/DSNote.sol
218 
219 contract DSNote {
220     event LogNote(
221         bytes4 indexed sig,
222         address indexed guy,
223         bytes32 indexed foo,
224         bytes32 bar,
225         uint wad,
226         bytes fax
227     );
228 
229     modifier note {
230         bytes32 foo;
231         bytes32 bar;
232         // solium-disable-next-line security/no-inline-assembly
233         assembly {
234             foo := calldataload(4)
235             bar := calldataload(36)
236         }
237 
238         emit LogNote(
239             msg.sig,
240             msg.sender,
241             foo,
242             bar,
243             msg.value,
244             msg.data
245         );
246 
247         _;
248     }
249 }
250 
251 // File: contracts/Oracle/DSThing.sol
252 
253 contract DSThing is DSAuth, DSNote, DSMath {}
254 
255 // File: contracts/Oracle/PriceFeed.sol
256 
257 /// price-feed.sol
258 
259 // Copyright (C) 2017  DappHub, LLC
260 
261 // Licensed under the Apache License, Version 2.0 (the "License").
262 // You may not use this file except in compliance with the License.
263 
264 // Unless required by applicable law or agreed to in writing, software
265 // distributed under the License is distributed on an "AS IS" BASIS,
266 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
267 
268 
269 
270 contract PriceFeed is DSThing {
271     uint128 val;
272     uint32 public zzz;
273 
274     function peek() public view returns (bytes32, bool) {
275         return (bytes32(uint256(val)), block.timestamp < zzz);
276     }
277 
278     function read() public view returns (bytes32) {
279         assert(block.timestamp < zzz);
280         return bytes32(uint256(val));
281     }
282 
283     function post(uint128 val_, uint32 zzz_, address med_) public payable note auth {
284         val = val_;
285         zzz = zzz_;
286         (bool success, ) = med_.call(abi.encodeWithSignature("poke()"));
287         require(success, "The poke must succeed");
288     }
289 
290     function void() public payable note auth {
291         zzz = 0;
292     }
293 
294 }
295 
296 // File: contracts/Oracle/DSValue.sol
297 
298 contract DSValue is DSThing {
299     bool has;
300     bytes32 val;
301     function peek() public view returns (bytes32, bool) {
302         return (val, has);
303     }
304 
305     function read() public view returns (bytes32) {
306         (bytes32 wut, bool _has) = peek();
307         assert(_has);
308         return wut;
309     }
310 
311     function poke(bytes32 wut) public payable note auth {
312         val = wut;
313         has = true;
314     }
315 
316     function void() public payable note auth {
317         // unset the value
318         has = false;
319     }
320 }
321 
322 // File: contracts/Oracle/Medianizer.sol
323 
324 contract Medianizer is DSValue {
325     mapping(bytes12 => address) public values;
326     mapping(address => bytes12) public indexes;
327     bytes12 public next = bytes12(uint96(1));
328     uint96 public minimun = 0x1;
329 
330     function set(address wat) public auth {
331         bytes12 nextId = bytes12(uint96(next) + 1);
332         assert(nextId != 0x0);
333         set(next, wat);
334         next = nextId;
335     }
336 
337     function set(bytes12 pos, address wat) public payable note auth {
338         require(pos != 0x0, "pos cannot be 0x0");
339         require(wat == address(0) || indexes[wat] == 0, "wat is not defined or it has an index");
340 
341         indexes[values[pos]] = bytes12(0); // Making sure to remove a possible existing address in that position
342 
343         if (wat != address(0)) {
344             indexes[wat] = pos;
345         }
346 
347         values[pos] = wat;
348     }
349 
350     function setMin(uint96 min_) public payable note auth {
351         require(min_ != 0x0, "min cannot be 0x0");
352         minimun = min_;
353     }
354 
355     function setNext(bytes12 next_) public payable note auth {
356         require(next_ != 0x0, "next cannot be 0x0");
357         next = next_;
358     }
359 
360     function unset(bytes12 pos) public {
361         set(pos, address(0));
362     }
363 
364     function unset(address wat) public {
365         set(indexes[wat], address(0));
366     }
367 
368     function poke() public {
369         poke(0);
370     }
371 
372     function poke(bytes32) public payable note {
373         (val, has) = compute();
374     }
375 
376     function compute() public view returns (bytes32, bool) {
377         bytes32[] memory wuts = new bytes32[](uint96(next) - 1);
378         uint96 ctr = 0;
379         for (uint96 i = 1; i < uint96(next); i++) {
380             if (values[bytes12(i)] != address(0)) {
381                 (bytes32 wut, bool wuz) = DSValue(values[bytes12(i)]).peek();
382                 if (wuz) {
383                     if (ctr == 0 || wut >= wuts[ctr - 1]) {
384                         wuts[ctr] = wut;
385                     } else {
386                         uint96 j = 0;
387                         while (wut >= wuts[j]) {
388                             j++;
389                         }
390                         for (uint96 k = ctr; k > j; k--) {
391                             wuts[k] = wuts[k - 1];
392                         }
393                         wuts[j] = wut;
394                     }
395                     ctr++;
396                 }
397             }
398         }
399 
400         if (ctr < minimun)
401             return (val, false);
402 
403         bytes32 value;
404         if (ctr % 2 == 0) {
405             uint128 val1 = uint128(uint(wuts[(ctr / 2) - 1]));
406             uint128 val2 = uint128(uint(wuts[ctr / 2]));
407             value = bytes32(uint256(wdiv(hadd(val1, val2), 2 ether)));
408         } else {
409             value = wuts[(ctr - 1) / 2];
410         }
411 
412         return (value, true);
413     }
414 }
415 
416 // File: contracts/Oracle/PriceOracleInterface.sol
417 
418 /*
419 This contract is the interface between the MakerDAO priceFeed and our DX platform.
420 */
421 
422 
423 
424 
425 contract PriceOracleInterface {
426     address public priceFeedSource;
427     address public owner;
428     bool public emergencyMode;
429 
430     // Modifiers
431     modifier onlyOwner() {
432         require(msg.sender == owner, "Only the owner can do the operation");
433         _;
434     }
435 
436     /// @dev constructor of the contract
437     /// @param _priceFeedSource address of price Feed Source -> should be maker feeds Medianizer contract
438     constructor(address _owner, address _priceFeedSource) public {
439         owner = _owner;
440         priceFeedSource = _priceFeedSource;
441     }
442     
443     /// @dev gives the owner the possibility to put the Interface into an emergencyMode, which will
444     /// output always a price of 600 USD. This gives everyone time to set up a new pricefeed.
445     function raiseEmergency(bool _emergencyMode) public onlyOwner {
446         emergencyMode = _emergencyMode;
447     }
448 
449     /// @dev updates the priceFeedSource
450     /// @param _owner address of owner
451     function updateCurator(address _owner) public onlyOwner {
452         owner = _owner;
453     }
454 
455     /// @dev returns the USDETH price
456     function getUsdEthPricePeek() public view returns (bytes32 price, bool valid) {
457         return Medianizer(priceFeedSource).peek();
458     }
459 
460     /// @dev returns the USDETH price, ie gets the USD price from Maker feed with 18 digits, but last 18 digits are cut off
461     function getUSDETHPrice() public view returns (uint256) {
462         // if the contract is in the emergencyMode, because there is an issue with the oracle, we will simply return a price of 600 USD
463         if (emergencyMode) {
464             return 600;
465         }
466         (bytes32 price, ) = Medianizer(priceFeedSource).peek();
467 
468         // ensuring that there is no underflow or overflow possible,
469         // even if the price is compromised
470         uint priceUint = uint256(price)/(1 ether);
471         if (priceUint == 0) {
472             return 1;
473         }
474         if (priceUint > 1000000) {
475             return 1000000; 
476         }
477         return priceUint;
478     }
479 }