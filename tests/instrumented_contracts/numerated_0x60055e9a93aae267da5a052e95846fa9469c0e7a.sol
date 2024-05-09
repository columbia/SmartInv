1 pragma solidity ^0.4.24;
2 
3 interface IOracle {
4 
5     /**
6     * @notice Returns address of oracle currency (0x0 for ETH)
7     */
8     function getCurrencyAddress() external view returns(address);
9 
10     /**
11     * @notice Returns symbol of oracle currency (0x0 for ETH)
12     */
13     function getCurrencySymbol() external view returns(bytes32);
14 
15     /**
16     * @notice Returns denomination of price
17     */
18     function getCurrencyDenominated() external view returns(bytes32);
19 
20     /**
21     * @notice Returns price - should throw if not valid
22     */
23     function getPrice() external view returns(uint256);
24 
25 }
26 
27 /// return median value of feeds
28 
29 // Copyright (C) 2017  DappHub, LLC
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
40 contract DSAuthority {
41     function canCall(
42         address src, address dst, bytes4 sig
43     ) constant returns (bool);
44 }
45 
46 contract DSAuthEvents {
47     event LogSetAuthority (address indexed authority);
48     event LogSetOwner     (address indexed owner);
49 }
50 
51 contract DSAuth is DSAuthEvents {
52     DSAuthority  public  authority;
53     address      public  owner;
54 
55     function DSAuth() {
56         owner = msg.sender;
57         LogSetOwner(msg.sender);
58     }
59 
60     function setOwner(address owner_)
61         auth
62     {
63         owner = owner_;
64         LogSetOwner(owner);
65     }
66 
67     function setAuthority(DSAuthority authority_)
68         auth
69     {
70         authority = authority_;
71         LogSetAuthority(authority);
72     }
73 
74     modifier auth {
75         assert(isAuthorized(msg.sender, msg.sig));
76         _;
77     }
78 
79     modifier authorized(bytes4 sig) {
80         assert(isAuthorized(msg.sender, sig));
81         _;
82     }
83 
84     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
85         if (src == address(this)) {
86             return true;
87         } else if (src == owner) {
88             return true;
89         } else if (authority == DSAuthority(0)) {
90             return false;
91         } else {
92             return authority.canCall(src, this, sig);
93         }
94     }
95 
96     function assert(bool x) internal {
97         if (!x) throw;
98     }
99 }
100 
101 contract DSNote {
102     event LogNote(
103         bytes4   indexed  sig,
104         address  indexed  guy,
105         bytes32  indexed  foo,
106         bytes32  indexed  bar,
107 	uint	 	  wad,
108         bytes             fax
109     ) anonymous;
110 
111     modifier note {
112         bytes32 foo;
113         bytes32 bar;
114 
115         assembly {
116             foo := calldataload(4)
117             bar := calldataload(36)
118         }
119 
120         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
121 
122         _;
123     }
124 }
125 
126 contract DSMath {
127 
128     /*
129     standard uint256 functions
130      */
131 
132     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
133         assert((z = x + y) >= x);
134     }
135 
136     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
137         assert((z = x - y) <= x);
138     }
139 
140     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
141         assert((z = x * y) >= x);
142     }
143 
144     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
145         z = x / y;
146     }
147 
148     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
149         return x <= y ? x : y;
150     }
151     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
152         return x >= y ? x : y;
153     }
154 
155     /*
156     uint128 functions (h is for half)
157      */
158 
159 
160     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
161         assert((z = x + y) >= x);
162     }
163 
164     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
165         assert((z = x - y) <= x);
166     }
167 
168     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
169         assert((z = x * y) >= x);
170     }
171 
172     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
173         z = x / y;
174     }
175 
176     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
177         return x <= y ? x : y;
178     }
179     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
180         return x >= y ? x : y;
181     }
182 
183 
184     /*
185     int256 functions
186      */
187 
188     function imin(int256 x, int256 y) constant internal returns (int256 z) {
189         return x <= y ? x : y;
190     }
191     function imax(int256 x, int256 y) constant internal returns (int256 z) {
192         return x >= y ? x : y;
193     }
194 
195     /*
196     WAD math
197      */
198 
199     uint128 constant WAD = 10 ** 18;
200 
201     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
202         return hadd(x, y);
203     }
204 
205     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
206         return hsub(x, y);
207     }
208 
209     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
210         z = cast((uint256(x) * y + WAD / 2) / WAD);
211     }
212 
213     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
214         z = cast((uint256(x) * WAD + y / 2) / y);
215     }
216 
217     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
218         return hmin(x, y);
219     }
220     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
221         return hmax(x, y);
222     }
223 
224     /*
225     RAY math
226      */
227 
228     uint128 constant RAY = 10 ** 27;
229 
230     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
231         return hadd(x, y);
232     }
233 
234     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
235         return hsub(x, y);
236     }
237 
238     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
239         z = cast((uint256(x) * y + RAY / 2) / RAY);
240     }
241 
242     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
243         z = cast((uint256(x) * RAY + y / 2) / y);
244     }
245 
246     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
247         // This famous algorithm is called "exponentiation by squaring"
248         // and calculates x^n with x as fixed-point and n as regular unsigned.
249         //
250         // It's O(log n), instead of O(n) for naive repeated multiplication.
251         //
252         // These facts are why it works:
253         //
254         //  If n is even, then x^n = (x^2)^(n/2).
255         //  If n is odd,  then x^n = x * x^(n-1),
256         //   and applying the equation for even x gives
257         //    x^n = x * (x^2)^((n-1) / 2).
258         //
259         //  Also, EVM division is flooring and
260         //    floor[(n-1) / 2] = floor[n / 2].
261 
262         z = n % 2 != 0 ? x : RAY;
263 
264         for (n /= 2; n != 0; n /= 2) {
265             x = rmul(x, x);
266 
267             if (n % 2 != 0) {
268                 z = rmul(z, x);
269             }
270         }
271     }
272 
273     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
274         return hmin(x, y);
275     }
276     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
277         return hmax(x, y);
278     }
279 
280     function cast(uint256 x) constant internal returns (uint128 z) {
281         assert((z = uint128(x)) == x);
282     }
283 
284 }
285 
286 contract DSThing is DSAuth, DSNote, DSMath {
287 }
288 
289 contract DSValue is DSThing {
290     bool    has;
291     bytes32 val;
292     function peek() constant returns (bytes32, bool) {
293         return (val,has);
294     }
295     function read() constant returns (bytes32) {
296         var (wut, has) = peek();
297         assert(has);
298         return wut;
299     }
300     function poke(bytes32 wut) note auth {
301         val = wut;
302         has = true;
303     }
304     function void() note auth { // unset the value
305         has = false;
306     }
307 }
308 
309 contract Medianizer is DSValue {
310     mapping (bytes12 => address) public values;
311     mapping (address => bytes12) public indexes;
312     bytes12 public next = 0x1;
313 
314     uint96 public min = 0x1;
315 
316     function set(address wat) auth {
317         bytes12 nextId = bytes12(uint96(next) + 1);
318         assert(nextId != 0x0);
319         set(next, wat);
320         next = nextId;
321     }
322 
323     function set(bytes12 pos, address wat) note auth {
324         if (pos == 0x0) throw;
325 
326         if (wat != 0 && indexes[wat] != 0) throw;
327 
328         indexes[values[pos]] = 0; // Making sure to remove a possible existing address in that position
329 
330         if (wat != 0) {
331             indexes[wat] = pos;
332         }
333 
334         values[pos] = wat;
335     }
336 
337     function setMin(uint96 min_) note auth {
338         if (min_ == 0x0) throw;
339         min = min_;
340     }
341 
342     function setNext(bytes12 next_) note auth {
343         if (next_ == 0x0) throw;
344         next = next_;
345     }
346 
347     function unset(bytes12 pos) {
348         set(pos, 0);
349     }
350 
351     function unset(address wat) {
352         set(indexes[wat], 0);
353     }
354 
355     function poke() {
356         poke(0);
357     }
358 
359     function poke(bytes32) note {
360         (val, has) = compute();
361     }
362 
363     function compute() constant returns (bytes32, bool) {
364         bytes32[] memory wuts = new bytes32[](uint96(next) - 1);
365         uint96 ctr = 0;
366         for (uint96 i = 1; i < uint96(next); i++) {
367             if (values[bytes12(i)] != 0) {
368                 var (wut, wuz) = DSValue(values[bytes12(i)]).peek();
369                 if (wuz) {
370                     if (ctr == 0 || wut >= wuts[ctr - 1]) {
371                         wuts[ctr] = wut;
372                     } else {
373                         uint96 j = 0;
374                         while (wut >= wuts[j]) {
375                             j++;
376                         }
377                         for (uint96 k = ctr; k > j; k--) {
378                             wuts[k] = wuts[k - 1];
379                         }
380                         wuts[j] = wut;
381                     }
382                     ctr++;
383                 }
384             }
385         }
386 
387         if (ctr < min) return (val, false);
388 
389         bytes32 value;
390         if (ctr % 2 == 0) {
391             uint128 val1 = uint128(wuts[(ctr / 2) - 1]);
392             uint128 val2 = uint128(wuts[ctr / 2]);
393             value = bytes32(wdiv(hadd(val1, val2), 2 ether));
394         } else {
395             value = wuts[(ctr - 1) / 2];
396         }
397 
398         return (value, true);
399     }
400 
401 }
402 
403 /**
404  * @title Ownable
405  * @dev The Ownable contract has an owner address, and provides basic authorization control
406  * functions, this simplifies the implementation of "user permissions".
407  */
408 contract Ownable {
409   address public owner;
410 
411 
412   event OwnershipRenounced(address indexed previousOwner);
413   event OwnershipTransferred(
414     address indexed previousOwner,
415     address indexed newOwner
416   );
417 
418 
419   /**
420    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
421    * account.
422    */
423   constructor() public {
424     owner = msg.sender;
425   }
426 
427   /**
428    * @dev Throws if called by any account other than the owner.
429    */
430   modifier onlyOwner() {
431     require(msg.sender == owner);
432     _;
433   }
434 
435   /**
436    * @dev Allows the current owner to relinquish control of the contract.
437    */
438   function renounceOwnership() public onlyOwner {
439     emit OwnershipRenounced(owner);
440     owner = address(0);
441   }
442 
443   /**
444    * @dev Allows the current owner to transfer control of the contract to a newOwner.
445    * @param _newOwner The address to transfer ownership to.
446    */
447   function transferOwnership(address _newOwner) public onlyOwner {
448     _transferOwnership(_newOwner);
449   }
450 
451   /**
452    * @dev Transfers control of the contract to a newOwner.
453    * @param _newOwner The address to transfer ownership to.
454    */
455   function _transferOwnership(address _newOwner) internal {
456     require(_newOwner != address(0));
457     emit OwnershipTransferred(owner, _newOwner);
458     owner = _newOwner;
459   }
460 }
461 
462 contract MakerDAOOracle is IOracle, Ownable {
463 
464     address public makerDAO = 0x729D19f657BD0614b4985Cf1D82531c67569197B;
465 
466     bool public manualOverride;
467 
468     uint256 public manualPrice;
469 
470     event LogChangeMakerDAO(address _newMakerDAO, address _oldMakerDAO, uint256 _now);
471     event LogSetManualPrice(uint256 _oldPrice, uint256 _newPrice, uint256 _time);
472     event LogSetManualOverride(bool _override, uint256 _time);
473 
474     function changeMakerDAO(address _makerDAO) public onlyOwner {
475         emit LogChangeMakerDAO(_makerDAO, makerDAO, now);
476         makerDAO = _makerDAO;
477     }
478 
479     /**
480     * @notice Returns address of oracle currency (0x0 for ETH)
481     */
482     function getCurrencyAddress() external view returns(address) {
483         return address(0);
484     }
485 
486     /**
487     * @notice Returns symbol of oracle currency (0x0 for ETH)
488     */
489     function getCurrencySymbol() external view returns(bytes32) {
490         return bytes32("ETH");
491     }
492 
493     /**
494     * @notice Returns denomination of price
495     */
496     function getCurrencyDenominated() external view returns(bytes32) {
497         return bytes32("USD");
498     }
499 
500     /**
501     * @notice Returns price - should throw if not valid
502     */
503     function getPrice() external view returns(uint256) {
504         if (manualOverride) {
505             return manualPrice;
506         }
507         (bytes32 price, bool valid) = Medianizer(makerDAO).peek();
508         require(valid, "MakerDAO Oracle returning invalid value");
509         return uint256(price);
510     }
511 
512     /**
513       * @notice Set a manual price. NA - this will only be used if manualOverride == true
514       * @param _price Price to set
515       */
516     function setManualPrice(uint256 _price) public onlyOwner {
517         emit LogSetManualPrice(manualPrice, _price, now);
518         manualPrice = _price;
519     }
520 
521     /**
522       * @notice Determine whether manual price is used or not
523       * @param _override Whether to use the manual override price or not
524       */
525     function setManualOverride(bool _override) public onlyOwner {
526         manualOverride = _override;
527         emit LogSetManualOverride(_override, now);
528     }
529 
530 }