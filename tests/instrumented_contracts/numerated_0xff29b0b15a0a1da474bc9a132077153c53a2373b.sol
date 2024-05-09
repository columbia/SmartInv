1 pragma solidity ^0.4.21;
2 
3 // File: contracts/Oracle/DSAuth.sol
4 
5 contract DSAuthority {
6     function canCall(
7         address src, address dst, bytes4 sig
8     ) public view returns (bool);
9 }
10 
11 contract DSAuthEvents {
12     event LogSetAuthority (address indexed authority);
13     event LogSetOwner     (address indexed owner);
14 }
15 
16 contract DSAuth is DSAuthEvents {
17     DSAuthority  public  authority;
18     address      public  owner;
19 
20     function DSAuth() public {
21         owner = msg.sender;
22         LogSetOwner(msg.sender);
23     }
24 
25     function setOwner(address owner_)
26         public
27         auth
28     {
29         owner = owner_;
30         LogSetOwner(owner);
31     }
32 
33     function setAuthority(DSAuthority authority_)
34         public
35         auth
36     {
37         authority = authority_;
38         LogSetAuthority(authority);
39     }
40 
41     modifier auth {
42         require(isAuthorized(msg.sender, msg.sig));
43         _;
44     }
45 
46     function isAuthorized(address src, bytes4 sig) internal view returns (bool) {
47         if (src == address(this)) {
48             return true;
49         } else if (src == owner) {
50             return true;
51         } else if (authority == DSAuthority(0)) {
52             return false;
53         } else {
54             return authority.canCall(src, this, sig);
55         }
56     }
57 }
58 
59 // File: contracts/Oracle/DSMath.sol
60 
61 contract DSMath {
62     
63     /*
64     standard uint256 functions
65      */
66 
67     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
68         assert((z = x + y) >= x);
69     }
70 
71     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
72         assert((z = x - y) <= x);
73     }
74 
75     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
76         assert((z = x * y) >= x);
77     }
78 
79     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
80         z = x / y;
81     }
82 
83     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
84         return x <= y ? x : y;
85     }
86     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
87         return x >= y ? x : y;
88     }
89 
90     /*
91     uint128 functions (h is for half)
92      */
93 
94 
95     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
96         assert((z = x + y) >= x);
97     }
98 
99     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
100         assert((z = x - y) <= x);
101     }
102 
103     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
104         assert((z = x * y) >= x);
105     }
106 
107     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
108         z = x / y;
109     }
110 
111     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
112         return x <= y ? x : y;
113     }
114     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
115         return x >= y ? x : y;
116     }
117 
118 
119     /*
120     int256 functions
121      */
122 
123     function imin(int256 x, int256 y) constant internal returns (int256 z) {
124         return x <= y ? x : y;
125     }
126     function imax(int256 x, int256 y) constant internal returns (int256 z) {
127         return x >= y ? x : y;
128     }
129 
130     /*
131     WAD math
132      */
133 
134     uint128 constant WAD = 10 ** 18;
135 
136     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
137         return hadd(x, y);
138     }
139 
140     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
141         return hsub(x, y);
142     }
143 
144     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
145         z = cast((uint256(x) * y + WAD / 2) / WAD);
146     }
147 
148     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
149         z = cast((uint256(x) * WAD + y / 2) / y);
150     }
151 
152     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
153         return hmin(x, y);
154     }
155     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
156         return hmax(x, y);
157     }
158 
159     /*
160     RAY math
161      */
162 
163     uint128 constant RAY = 10 ** 27;
164 
165     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
166         return hadd(x, y);
167     }
168 
169     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
170         return hsub(x, y);
171     }
172 
173     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
174         z = cast((uint256(x) * y + RAY / 2) / RAY);
175     }
176 
177     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
178         z = cast((uint256(x) * RAY + y / 2) / y);
179     }
180 
181     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
182         // This famous algorithm is called "exponentiation by squaring"
183         // and calculates x^n with x as fixed-point and n as regular unsigned.
184         //
185         // It's O(log n), instead of O(n) for naive repeated multiplication.
186         //
187         // These facts are why it works:
188         //
189         //  If n is even, then x^n = (x^2)^(n/2).
190         //  If n is odd,  then x^n = x * x^(n-1),
191         //   and applying the equation for even x gives
192         //    x^n = x * (x^2)^((n-1) / 2).
193         //
194         //  Also, EVM division is flooring and
195         //    floor[(n-1) / 2] = floor[n / 2].
196 
197         z = n % 2 != 0 ? x : RAY;
198 
199         for (n /= 2; n != 0; n /= 2) {
200             x = rmul(x, x);
201 
202             if (n % 2 != 0) {
203                 z = rmul(z, x);
204             }
205         }
206     }
207 
208     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
209         return hmin(x, y);
210     }
211     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
212         return hmax(x, y);
213     }
214 
215     function cast(uint256 x) constant internal returns (uint128 z) {
216         assert((z = uint128(x)) == x);
217     }
218 
219 }
220 
221 // File: contracts/Oracle/DSNote.sol
222 
223 contract DSNote {
224     event LogNote(
225         bytes4   indexed  sig,
226         address  indexed  guy,
227         bytes32  indexed  foo,
228         bytes32  indexed  bar,
229         uint              wad,
230         bytes             fax
231     ) anonymous;
232 
233     modifier note {
234         bytes32 foo;
235         bytes32 bar;
236 
237         assembly {
238             foo := calldataload(4)
239             bar := calldataload(36)
240         }
241 
242         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
243 
244         _;
245     }
246 }
247 
248 // File: contracts/Oracle/DSThing.sol
249 
250 contract DSThing is DSAuth, DSNote, DSMath {
251 }
252 
253 // File: contracts/Oracle/DSValue.sol
254 
255 contract DSValue is DSThing {
256     bool    has;
257     bytes32 val;
258     function peek() constant returns (bytes32, bool) {
259         return (val,has);
260     }
261     function read() constant returns (bytes32) {
262         var (wut, has) = peek();
263         assert(has);
264         return wut;
265     }
266     function poke(bytes32 wut) note auth {
267         val = wut;
268         has = true;
269     }
270     function void() note auth { // unset the value
271         has = false;
272     }
273 }
274 
275 // File: contracts/Oracle/Medianizer.sol
276 
277 contract Medianizer is DSValue {
278     mapping (bytes12 => address) public values;
279     mapping (address => bytes12) public indexes;
280     bytes12 public next = 0x1;
281 
282     uint96 public min = 0x1;
283 
284     function set(address wat) auth {
285         bytes12 nextId = bytes12(uint96(next) + 1);
286         assert(nextId != 0x0);
287         set(next, wat);
288         next = nextId;
289     }
290 
291     function set(bytes12 pos, address wat) note auth {
292         if (pos == 0x0) throw;
293 
294         if (wat != 0 && indexes[wat] != 0) throw;
295 
296         indexes[values[pos]] = 0; // Making sure to remove a possible existing address in that position
297 
298         if (wat != 0) {
299             indexes[wat] = pos;
300         }
301 
302         values[pos] = wat;
303     }
304 
305     function setMin(uint96 min_) note auth {
306         if (min_ == 0x0) throw;
307         min = min_;
308     }
309 
310     function setNext(bytes12 next_) note auth {
311         if (next_ == 0x0) throw;
312         next = next_;
313     }
314 
315     function unset(bytes12 pos) {
316         set(pos, 0);
317     }
318 
319     function unset(address wat) {
320         set(indexes[wat], 0);
321     }
322 
323     function poke() {
324         poke(0);
325     }
326 
327     function poke(bytes32) note {
328         (val, has) = compute();
329     }
330 
331     function compute() constant returns (bytes32, bool) {
332         bytes32[] memory wuts = new bytes32[](uint96(next) - 1);
333         uint96 ctr = 0;
334         for (uint96 i = 1; i < uint96(next); i++) {
335             if (values[bytes12(i)] != 0) {
336                 var (wut, wuz) = DSValue(values[bytes12(i)]).peek();
337                 if (wuz) {
338                     if (ctr == 0 || wut >= wuts[ctr - 1]) {
339                         wuts[ctr] = wut;
340                     } else {
341                         uint96 j = 0;
342                         while (wut >= wuts[j]) {
343                             j++;
344                         }
345                         for (uint96 k = ctr; k > j; k--) {
346                             wuts[k] = wuts[k - 1];
347                         }
348                         wuts[j] = wut;
349                     }
350                     ctr++;
351                 }
352             }
353         }
354 
355         if (ctr < min) return (val, false);
356 
357         bytes32 value;
358         if (ctr % 2 == 0) {
359             uint128 val1 = uint128(wuts[(ctr / 2) - 1]);
360             uint128 val2 = uint128(wuts[ctr / 2]);
361             value = bytes32(wdiv(hadd(val1, val2), 2 ether));
362         } else {
363             value = wuts[(ctr - 1) / 2];
364         }
365 
366         return (value, true);
367     }
368 }
369 
370 // File: contracts/Oracle/PriceFeed.sol
371 
372 /// price-feed.sol
373 
374 // Copyright (C) 2017  DappHub, LLC
375 
376 // Licensed under the Apache License, Version 2.0 (the "License").
377 // You may not use this file except in compliance with the License.
378 
379 // Unless required by applicable law or agreed to in writing, software
380 // distributed under the License is distributed on an "AS IS" BASIS,
381 // WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND (express or implied).
382 
383 
384 
385 contract PriceFeed is DSThing {
386 
387     uint128 val;
388     uint32 public zzz;
389 
390     function peek() public view
391         returns (bytes32, bool)
392     {
393         return (bytes32(val), now < zzz);
394     }
395 
396     function read() public view
397         returns (bytes32)
398     {
399         assert(now < zzz);
400         return bytes32(val);
401     }
402 
403     function post(uint128 val_, uint32 zzz_, address med_) public note auth
404     {
405         val = val_;
406         zzz = zzz_;
407         bool ret = med_.call(bytes4(keccak256("poke()")));
408         ret;
409     }
410 
411     function void() public note auth
412     {
413         zzz = 0;
414     }
415 
416 }
417 
418 // File: contracts/Oracle/PriceOracleInterface.sol
419 
420 /*
421 This contract is the interface between the MakerDAO priceFeed and our DX platform.
422 */
423 
424 
425 
426 contract PriceOracleInterface {
427 
428     address public priceFeedSource;
429     address public owner;
430     bool public emergencyMode;
431 
432     event NonValidPriceFeed(address priceFeedSource);
433 
434     // Modifiers
435     modifier onlyOwner() {
436         require(msg.sender == owner);
437         _;
438     }
439 
440     /// @dev constructor of the contract
441     /// @param _priceFeedSource address of price Feed Source -> should be maker feeds Medianizer contract
442     function PriceOracleInterface(
443         address _owner,
444         address _priceFeedSource
445     )
446         public
447     {
448         owner = _owner;
449         priceFeedSource = _priceFeedSource;
450     }
451     /// @dev gives the owner the possibility to put the Interface into an emergencyMode, which will 
452     /// output always a price of 600 USD. This gives everyone time to set up a new pricefeed.
453     function raiseEmergency(bool _emergencyMode)
454         public
455         onlyOwner()
456     {
457         emergencyMode = _emergencyMode;
458     }
459 
460     /// @dev updates the priceFeedSource
461     /// @param _owner address of owner
462     function updateCurator(
463         address _owner
464     )
465         public
466         onlyOwner()
467     {
468         owner = _owner;
469     }
470 
471     /// @dev returns the USDETH price, ie gets the USD price from Maker feed with 18 digits, but last 18 digits are cut off
472     function getUSDETHPrice() 
473         public
474         returns (uint256)
475     {
476         // if the contract is in the emergencyMode, because there is an issue with the oracle, we will simply return a price of 600 USD
477         if(emergencyMode){
478             return 600;
479         }
480 
481         bytes32 price;
482         bool valid=true;
483         (price, valid) = Medianizer(priceFeedSource).peek();
484         if (!valid) {
485             NonValidPriceFeed(priceFeedSource);
486         }
487         // ensuring that there is no underflow or overflow possible,
488         // even if the price is compromised
489         uint priceUint = uint256(price)/(1 ether);
490         if (priceUint == 0) return 1;
491         if (priceUint > 1000000) return 1000000; 
492         return priceUint;
493     }  
494 }