1 //
2 // Our shop contract acts as a payment provider for our in-game shop system. 
3 // Coin packages that are purchased here are being picked up by our offchain 
4 // sync network and are then translated into in-game assets. This happens with
5 // minimal delay and enables a fluid gameplay experience. An in-game notification
6 // informs players about the successful purchase of coins.
7 // 
8 // Prices are scaled against the current USD value of ETH courtesy of
9 // MAKERDAO (https://developer.makerdao.com/feeds/) 
10 // This enables us to match our native In-App-Purchase prices from e.g. Apple's AppStore
11 // We can also reduce the price of packages temporarily for e.g. events and promotions.
12 //
13 
14 pragma solidity ^0.4.21;
15 
16 
17 contract DSAuthority {
18     function canCall(
19         address src, address dst, bytes4 sig
20     ) constant returns (bool);
21 }
22 
23 contract DSAuthEvents {
24     event LogSetAuthority (address indexed authority);
25     event LogSetOwner     (address indexed owner);
26 }
27 
28 contract DSAuth is DSAuthEvents {
29     DSAuthority  public  authority;
30     address      public  owner;
31 
32     function DSAuth() {
33         owner = msg.sender;
34         LogSetOwner(msg.sender);
35     }
36 
37     function setOwner(address owner_)
38         auth
39     {
40         owner = owner_;
41         LogSetOwner(owner);
42     }
43 
44     function setAuthority(DSAuthority authority_)
45         auth
46     {
47         authority = authority_;
48         LogSetAuthority(authority);
49     }
50 
51     modifier auth {
52         assert(isAuthorized(msg.sender, msg.sig));
53         _;
54     }
55 
56     modifier authorized(bytes4 sig) {
57         assert(isAuthorized(msg.sender, sig));
58         _;
59     }
60 
61     function isAuthorized(address src, bytes4 sig) internal returns (bool) {
62         if (src == address(this)) {
63             return true;
64         } else if (src == owner) {
65             return true;
66         } else if (authority == DSAuthority(0)) {
67             return false;
68         } else {
69             return authority.canCall(src, this, sig);
70         }
71     }
72 
73     function assert(bool x) internal {
74         if (!x) throw;
75     }
76 }
77 
78 contract DSNote {
79     event LogNote(
80         bytes4   indexed  sig,
81         address  indexed  guy,
82         bytes32  indexed  foo,
83         bytes32  indexed  bar,
84 	uint	 	  wad,
85         bytes             fax
86     ) anonymous;
87 
88     modifier note {
89         bytes32 foo;
90         bytes32 bar;
91 
92         assembly {
93             foo := calldataload(4)
94             bar := calldataload(36)
95         }
96 
97         LogNote(msg.sig, msg.sender, foo, bar, msg.value, msg.data);
98 
99         _;
100     }
101 }
102 
103 contract DSMath {
104     
105     /*
106     standard uint256 functions
107      */
108 
109     function add(uint256 x, uint256 y) constant internal returns (uint256 z) {
110         assert((z = x + y) >= x);
111     }
112 
113     function sub(uint256 x, uint256 y) constant internal returns (uint256 z) {
114         assert((z = x - y) <= x);
115     }
116 
117     function mul(uint256 x, uint256 y) constant internal returns (uint256 z) {
118         assert((z = x * y) >= x);
119     }
120 
121     function div(uint256 x, uint256 y) constant internal returns (uint256 z) {
122         z = x / y;
123     }
124 
125     function min(uint256 x, uint256 y) constant internal returns (uint256 z) {
126         return x <= y ? x : y;
127     }
128     function max(uint256 x, uint256 y) constant internal returns (uint256 z) {
129         return x >= y ? x : y;
130     }
131 
132     /*
133     uint128 functions (h is for half)
134      */
135 
136 
137     function hadd(uint128 x, uint128 y) constant internal returns (uint128 z) {
138         assert((z = x + y) >= x);
139     }
140 
141     function hsub(uint128 x, uint128 y) constant internal returns (uint128 z) {
142         assert((z = x - y) <= x);
143     }
144 
145     function hmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
146         assert((z = x * y) >= x);
147     }
148 
149     function hdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
150         z = x / y;
151     }
152 
153     function hmin(uint128 x, uint128 y) constant internal returns (uint128 z) {
154         return x <= y ? x : y;
155     }
156     function hmax(uint128 x, uint128 y) constant internal returns (uint128 z) {
157         return x >= y ? x : y;
158     }
159 
160 
161     /*
162     int256 functions
163      */
164 
165     function imin(int256 x, int256 y) constant internal returns (int256 z) {
166         return x <= y ? x : y;
167     }
168     function imax(int256 x, int256 y) constant internal returns (int256 z) {
169         return x >= y ? x : y;
170     }
171 
172     /*
173     WAD math
174      */
175 
176     uint128 constant WAD = 10 ** 18;
177 
178     function wadd(uint128 x, uint128 y) constant internal returns (uint128) {
179         return hadd(x, y);
180     }
181 
182     function wsub(uint128 x, uint128 y) constant internal returns (uint128) {
183         return hsub(x, y);
184     }
185 
186     function wmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
187         z = cast((uint256(x) * y + WAD / 2) / WAD);
188     }
189 
190     function wdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
191         z = cast((uint256(x) * WAD + y / 2) / y);
192     }
193 
194     function wmin(uint128 x, uint128 y) constant internal returns (uint128) {
195         return hmin(x, y);
196     }
197     function wmax(uint128 x, uint128 y) constant internal returns (uint128) {
198         return hmax(x, y);
199     }
200 
201     /*
202     RAY math
203      */
204 
205     uint128 constant RAY = 10 ** 27;
206 
207     function radd(uint128 x, uint128 y) constant internal returns (uint128) {
208         return hadd(x, y);
209     }
210 
211     function rsub(uint128 x, uint128 y) constant internal returns (uint128) {
212         return hsub(x, y);
213     }
214 
215     function rmul(uint128 x, uint128 y) constant internal returns (uint128 z) {
216         z = cast((uint256(x) * y + RAY / 2) / RAY);
217     }
218 
219     function rdiv(uint128 x, uint128 y) constant internal returns (uint128 z) {
220         z = cast((uint256(x) * RAY + y / 2) / y);
221     }
222 
223     function rpow(uint128 x, uint64 n) constant internal returns (uint128 z) {
224         // This famous algorithm is called "exponentiation by squaring"
225         // and calculates x^n with x as fixed-point and n as regular unsigned.
226         //
227         // It's O(log n), instead of O(n) for naive repeated multiplication.
228         //
229         // These facts are why it works:
230         //
231         //  If n is even, then x^n = (x^2)^(n/2).
232         //  If n is odd,  then x^n = x * x^(n-1),
233         //   and applying the equation for even x gives
234         //    x^n = x * (x^2)^((n-1) / 2).
235         //
236         //  Also, EVM division is flooring and
237         //    floor[(n-1) / 2] = floor[n / 2].
238 
239         z = n % 2 != 0 ? x : RAY;
240 
241         for (n /= 2; n != 0; n /= 2) {
242             x = rmul(x, x);
243 
244             if (n % 2 != 0) {
245                 z = rmul(z, x);
246             }
247         }
248     }
249 
250     function rmin(uint128 x, uint128 y) constant internal returns (uint128) {
251         return hmin(x, y);
252     }
253     function rmax(uint128 x, uint128 y) constant internal returns (uint128) {
254         return hmax(x, y);
255     }
256 
257     function cast(uint256 x) constant internal returns (uint128 z) {
258         assert((z = uint128(x)) == x);
259     }
260 
261 }
262 
263 contract DSThing is DSAuth, DSNote, DSMath {
264 }
265 
266 contract DSValue is DSThing {
267     bool    has;
268     bytes32 val;
269     function peek() constant returns (bytes32, bool) {
270         return (val,has);
271     }
272     function read() constant returns (bytes32) {
273         var (wut, has) = peek();
274         assert(has);
275         return wut;
276     }
277     function poke(bytes32 wut) note auth {
278         val = wut;
279         has = true;
280     }
281     function void() note auth { // unset the value
282         has = false;
283     }
284 }
285 
286 contract Medianizer is DSValue {
287     mapping (bytes12 => address) public values;
288     mapping (address => bytes12) public indexes;
289     bytes12 public next = 0x1;
290 
291     uint96 public min = 0x1;
292 
293     function set(address wat) auth {
294         bytes12 nextId = bytes12(uint96(next) + 1);
295         assert(nextId != 0x0);
296         set(next, wat);
297         next = nextId;
298     }
299 
300     function set(bytes12 pos, address wat) note auth {
301         if (pos == 0x0) throw;
302 
303         if (wat != 0 && indexes[wat] != 0) throw;
304 
305         indexes[values[pos]] = 0; // Making sure to remove a possible existing address in that position
306 
307         if (wat != 0) {
308             indexes[wat] = pos;
309         }
310 
311         values[pos] = wat;
312     }
313 
314     function setMin(uint96 min_) note auth {
315         if (min_ == 0x0) throw;
316         min = min_;
317     }
318 
319     function setNext(bytes12 next_) note auth {
320         if (next_ == 0x0) throw;
321         next = next_;
322     }
323 
324     function unset(bytes12 pos) {
325         set(pos, 0);
326     }
327 
328     function unset(address wat) {
329         set(indexes[wat], 0);
330     }
331 
332     function poke() {
333         poke(0);
334     }
335 
336     function poke(bytes32) note {
337         (val, has) = compute();
338     }
339 
340     function compute() constant returns (bytes32, bool) {
341         bytes32[] memory wuts = new bytes32[](uint96(next) - 1);
342         uint96 ctr = 0;
343         for (uint96 i = 1; i < uint96(next); i++) {
344             if (values[bytes12(i)] != 0) {
345                 var (wut, wuz) = DSValue(values[bytes12(i)]).peek();
346                 if (wuz) {
347                     if (ctr == 0 || wut >= wuts[ctr - 1]) {
348                         wuts[ctr] = wut;
349                     } else {
350                         uint96 j = 0;
351                         while (wut >= wuts[j]) {
352                             j++;
353                         }
354                         for (uint96 k = ctr; k > j; k--) {
355                             wuts[k] = wuts[k - 1];
356                         }
357                         wuts[j] = wut;
358                     }
359                     ctr++;
360                 }
361             }
362         }
363 
364         if (ctr < min) return (val, false);
365 
366         bytes32 value;
367         if (ctr % 2 == 0) {
368             uint128 val1 = uint128(wuts[(ctr / 2) - 1]);
369             uint128 val2 = uint128(wuts[ctr / 2]);
370             value = bytes32(wdiv(hadd(val1, val2), 2 ether));
371         } else {
372             value = wuts[(ctr - 1) / 2];
373         }
374 
375         return (value, true);
376     }
377 
378 }
379 
380 /**
381  * @title Ownable
382  * @dev The Ownable contract has an owner address, and provides basic authorization control
383  * functions, this simplifies the implementation of "user permissions".
384  * via OpenZeppelin
385  */
386 contract Ownable {
387   address public owner;
388 
389   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
390 
391   /**
392    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
393    * account.
394    */
395   function Ownable() public {
396     owner = msg.sender;
397   }
398 
399   /**
400    * @dev Throws if called by any account other than the owner.
401    */
402   modifier onlyOwner() {
403     require(msg.sender == owner);
404     _;
405   }
406 
407   /**
408    * @dev Allows the current owner to transfer control of the contract to a newOwner.
409    * @param _newOwner The address to transfer ownership to.
410    */
411   function transferOwnership(address _newOwner) public onlyOwner {
412     require(_newOwner != address(0));
413     OwnershipTransferred(owner, _newOwner);
414     owner = _newOwner;
415   }
416 
417 }
418 
419 
420 contract ChainmonstersMedianizer is Ownable {
421 
422     address medianizerBase;
423     Medianizer makerMed;
424 
425     constructor(address _medianizerContract) public {
426         owner = msg.sender;
427 
428         medianizerBase = _medianizerContract;
429 
430         makerMed = Medianizer(medianizerBase);
431     }
432 
433     function updateMedianizerBase(address _medianizerContract) public onlyOwner {
434         medianizerBase = _medianizerContract;
435         makerMed = Medianizer(medianizerBase);
436     }
437 
438     function getUSDPrice() public view returns (uint256) {
439         return bytesToUint(toBytes(makerMed.read()));
440     }
441     
442     function isMedianizer() public view returns (bool) {
443         return true;
444     }
445     
446     
447 
448     function toBytes(bytes32 _data) public pure returns (bytes) {
449         return abi.encodePacked(_data);
450     }
451 
452     function bytesToUint(bytes b) public pure returns (uint256){
453         uint256 number;
454         for(uint i=0;i<b.length;i++){
455             number = number + uint(b[i])*(2**(8*(b.length-(i+1))));
456         }
457         return number;
458     }
459 
460 }
461 
462 /**
463 * @title SafeMath
464 * @dev Math operations with safety checks that throw on error
465 */
466 library SafeMath {
467 
468     /**
469     * @dev Multiplies two numbers, throws on overflow.
470     */
471     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
472         if (a == 0) {
473             return 0;
474         }
475         uint256 c = a * b;
476         assert(c / a == b);
477         return c;
478     }
479 
480     /**
481     * @dev Integer division of two numbers, truncating the quotient.
482     */
483     function div(uint256 a, uint256 b) internal pure returns (uint256) {
484         // assert(b > 0); // Solidity automatically throws when dividing by 0
485         uint256 c = a / b;
486         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
487         return c;
488     }
489 
490     /**
491     * @dev Substracts two numbers, returns 0 if it would go into minus range.
492     */
493     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
494         if (b >= a) {
495             return 0;
496         }
497         return a - b;
498     }
499 
500     /**
501     * @dev Adds two numbers, throws on overflow.
502     */
503     function add(uint256 a, uint256 b) internal pure returns (uint256) {
504         uint256 c = a + b;
505         assert(c >= a);
506         return c;
507     }
508 }
509 
510 contract ChainmonstersShop {
511     using SafeMath for uint256; 
512     
513     // static
514     address public owner;
515     
516     // start auction manually at given time
517     bool started;
518 
519     uint256 public totalCoinsSold;
520 
521     address medianizer;
522     uint256 shiftValue = 100; // double digit shifting to support prices like $29.99
523     uint256 multiplier = 10000; // internal multiplier
524 
525     struct Package {
526         // price in USD
527         uint256 price;
528         // reference to in-game equivalent e.g. "100 Coins"
529         string packageReference;
530         // available for purchase?
531         bool isActive;
532         // amount of coins
533         uint256 coinsAmount;
534     }
535 
536     
537     event LogPurchase(address _from, uint256 _price, string _packageReference);
538 
539     mapping(address => uint256) public addressToCoinsPurchased;
540     Package[] packages;
541 
542     constructor() public {
543         owner = msg.sender;
544 
545         started = false;
546     }
547 
548     function startShop() public onlyOwner {
549         require(started == false);
550 
551     }
552 
553     // in case of contract switch or adding new packages
554     function pauseShop() public onlyOwner {
555         require(started == true);
556     }
557 
558     function isStarted() public view returns (bool success) {
559         return started;
560     }
561 
562     function purchasePackage(uint256 _id) public
563         payable
564         returns (bool success)
565         {
566             require(started == true);
567             require(packages[_id].isActive == true);
568             require(msg.sender != owner);
569             require(msg.value == priceOf(packages[_id].price)); // only accept 100% accurate prices
570 
571             addressToCoinsPurchased[msg.sender] += packages[_id].coinsAmount;
572             totalCoinsSold += packages[_id].coinsAmount;
573             emit LogPurchase(msg.sender, msg.value, packages[_id].packageReference);
574         }
575 
576     function addPackage(uint256 _price, string _packageReference, bool _isActive, uint256 _coinsAmount)
577         external
578         onlyOwner
579         {
580             require(_price > 0);
581             Package memory _package = Package({
582             price: uint256(_price),
583             packageReference: string(_packageReference),
584             isActive: bool(_isActive),
585             coinsAmount: uint256(_coinsAmount)
586         });
587 
588         uint256 newPackageId = packages.push(_package);
589 
590         }
591 
592     function setPrice(uint256 _packageId, uint256 _newPrice)
593         external
594         onlyOwner
595         {
596             require(packages[_packageId].price > 0);
597             packages[_packageId].price = _newPrice;
598         }
599 
600     function getPackage(uint256 _id)
601         external 
602         view
603         returns (uint256 priceInETH, uint256 priceInUSD, string packageReference, uint256 coinsAmount )
604         {
605             Package storage package = packages[_id];
606             priceInETH = priceOf(_id);
607             priceInUSD = package.price;
608             packageReference = package.packageReference;
609             coinsAmount = package.coinsAmount;
610         
611         }
612 
613  
614   function priceOf(uint256 _packageId)
615     public
616     view
617     returns (uint256) 
618     {
619 
620         // if no medianizer is set then return fixed price(!)
621         if (medianizer == address(0x0)) {
622           return packages[_packageId].price;
623         }
624         else {
625           // the price of usd/eth gets returned from medianizer
626           uint256 USDinWei = ChainmonstersMedianizer(medianizer).getUSDPrice();
627     
628           uint256 multValue = (packages[_packageId].price.mul(multiplier)).div(USDinWei.div(1 ether));
629           uint256 inWei = multValue.mul(1 ether);
630           uint256 result = inWei.div(shiftValue.mul(multiplier));
631           return result;
632         }
633     
634   }
635   
636   function getPackagesCount()
637     public
638     view
639     returns (uint256)
640     {
641         return packages.length;
642     }
643 
644   function setMedianizer(ChainmonstersMedianizer _medianizer)
645      public
646     onlyOwner 
647     {
648     require(_medianizer.isMedianizer(), "given address is not a medianizer contract!");
649     medianizer = _medianizer;
650   }
651 
652     
653     modifier onlyOwner {
654         require(msg.sender == owner);
655         _;
656     }
657 
658 
659     
660    
661     
662 }