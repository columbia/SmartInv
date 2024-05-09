1 pragma solidity ^0.4.13;
2 
3 contract CollectibleExposure {
4   function getClosingTime(bytes32 id) constant returns (uint64 value);
5   function collect(bytes32 id) returns (uint256 value);
6   function close(bytes32 id) payable;
7 }
8 
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 contract ERC20 is ERC20Basic {
17   function allowance(address owner, address spender) public constant returns (uint256);
18   function transferFrom(address from, address to, uint256 value) public returns (bool);
19   function approve(address spender, uint256 value) public returns (bool);
20   event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 
23 library SafeMath {
24   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
25     uint256 c = a * b;
26     assert(a == 0 || c / a == b);
27     return c;
28   }
29 
30   function div(uint256 a, uint256 b) internal constant returns (uint256) {
31     // assert(b > 0); // Solidity automatically throws when dividing by 0
32     uint256 c = a / b;
33     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
34     return c;
35   }
36 
37   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
38     assert(b <= a);
39     return a - b;
40   }
41 
42   function add(uint256 a, uint256 b) internal constant returns (uint256) {
43     uint256 c = a + b;
44     assert(c >= a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55 
56   /**
57    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
58    * account.
59    */
60   function Ownable() {
61     owner = msg.sender;
62   }
63 
64 
65   /**
66    * @dev Throws if called by any account other than the owner.
67    */
68   modifier onlyOwner() {
69     require(msg.sender == owner);
70     _;
71   }
72 
73 
74   /**
75    * @dev Allows the current owner to transfer control of the contract to a newOwner.
76    * @param newOwner The address to transfer ownership to.
77    */
78   function transferOwnership(address newOwner) onlyOwner public {
79     require(newOwner != address(0));
80     OwnershipTransferred(owner, newOwner);
81     owner = newOwner;
82   }
83 
84 }
85 
86 contract TokenDestructible is Ownable {
87 
88   function TokenDestructible() payable { }
89 
90   /**
91    * @notice Terminate contract and refund to owner
92    * @param tokens List of addresses of ERC20 or ERC20Basic token contracts to
93    refund.
94    * @notice The called token contracts could try to re-enter this contract. Only
95    supply token contracts you trust.
96    */
97   function destroy(address[] tokens) onlyOwner public {
98 
99     // Transfer tokens to owner
100     for(uint256 i = 0; i < tokens.length; i++) {
101       ERC20Basic token = ERC20Basic(tokens[i]);
102       uint256 balance = token.balanceOf(this);
103       token.transfer(owner, balance);
104     }
105 
106     // Transfer Eth to owner and terminate contract
107     selfdestruct(owner);
108   }
109 }
110 
111 contract VePortfolio is TokenDestructible {
112 
113     //--- Definitions
114 
115     using SafeMath for uint256;
116 
117     struct ExposureInfo {
118         bytes32 exposureId;
119         uint256 value;
120     }
121 
122     struct Bucket {
123         uint256 value; // Ether
124         mapping(address => uint256) holdings; // Tokens
125         ExposureInfo[] exposures;
126         bool trading;
127         uint64 maxClosingTime;
128     }
129 
130     //--- Storage
131 
132     CollectibleExposure collectibleExposure;
133     EDExecutor etherDeltaExecutor;
134 
135     address public bucketManager;
136     address public portfolioManager;
137     address public trader;
138 
139     mapping (bytes32 => Bucket) private buckets;
140     mapping (address => uint) public model;
141     address[] public assets;
142 
143 
144 
145     //--- Constructor
146 
147     function VePortfolio() {
148         bucketManager = msg.sender;
149         portfolioManager = msg.sender;
150         trader = msg.sender;
151     }
152 
153     //--- Events
154 
155     event BucketCreated(bytes32 id, uint256 initialValue, uint64 closingTime);
156     event BucketBuy(bytes32 id, uint256 etherSpent, address token, uint256 tokensBought);
157     event BucketSell(bytes32 id, uint256 etherBought, address token, uint256 tokensSold);
158     event BucketDestroyed(bytes32 id, uint256 finalValue);
159 
160     //--- Modifiers
161 
162     modifier onlyBucketManager() {
163         require(msg.sender == bucketManager);
164         _;
165     }
166 
167     modifier onlyPortfolioManager() {
168         require(msg.sender == portfolioManager);
169         _;
170     }
171 
172     modifier onlyTrader() {
173         require(msg.sender == trader);
174         _;
175     }
176 
177     //--- Accessors
178 
179     function setCollectibleExposure(CollectibleExposure _collectibleExposure) onlyOwner {
180         require(_collectibleExposure != address(0));
181 
182         collectibleExposure = _collectibleExposure;
183     }
184 
185     function setEtherDeltaExecutor(EDExecutor _etherDeltaExecutor) public onlyOwner {
186         require(_etherDeltaExecutor != address(0));
187 
188         etherDeltaExecutor = _etherDeltaExecutor;
189     }
190 
191     function setBucketManager(address _bucketManager) public onlyOwner {
192         require(_bucketManager != address(0));
193 
194         bucketManager = _bucketManager;
195     }
196 
197     function setPortfolioManager(address _portfolioManager) public onlyOwner {
198         require(_portfolioManager != address(0));
199 
200         portfolioManager = _portfolioManager;
201     }
202 
203     function setTrader(address _trader) public onlyOwner {
204         require(_trader != address(0));
205 
206         trader = _trader;
207     }
208 
209     function getAssets() public constant returns (address[]) {
210         return assets;
211     }
212 
213     //--- Public functions
214 
215     /**
216      * @dev Sets supported assets
217      * @param _assets Array of asset addresses
218      */
219     function setAssets(address[] _assets) public onlyPortfolioManager {
220         clearModel();
221 
222         assets.length = _assets.length;
223         for(uint i = 0; i < assets.length; i++) {
224             assets[i] = _assets[i];
225         }
226     }
227 
228     /**
229      * @dev Updates the model portfolio
230      * @param  _assets       Array of asset addresses
231      * @param  _alloc        Array of percentage values (wei)
232      */
233     function setModel(address[] _assets, uint256[] _alloc) public onlyPortfolioManager {
234         require(_assets.length == _alloc.length);
235 
236         validateModel(_assets);
237         clearModel();
238 
239         uint total = 0;
240         for(uint256 i = 0; i < _assets.length; i++) {
241             uint256 alloc = _alloc[i];
242             address asset = _assets[i];
243 
244             total = total.add(alloc);
245             model[asset] = alloc;
246         }
247 
248         // allocation should be at least 99%
249         uint256 whole = 1 ether;
250         require(whole.sub(total) < 10 finney);
251     }
252 
253     function createBucket(bytes32[] exposureIds)
254         public
255         onlyBucketManager
256         returns (bytes32)
257     {
258         require(collectibleExposure != address(0));
259         require(exposureIds.length > 0);
260 
261         bytes32 bucketId = calculateBucketId(exposureIds);
262         Bucket storage bucket = buckets[bucketId];
263         require(bucket.exposures.length == 0); // ensure it is a new bucket
264 
265         for (uint256 i = 0; i < exposureIds.length; i++) {
266             bytes32 exposureId = exposureIds[i];
267             uint64 closureTime = collectibleExposure.getClosingTime(exposureId);
268             if (bucket.maxClosingTime < closureTime) {
269                 bucket.maxClosingTime = closureTime;
270             }
271 
272             // Possible reentry attack. Collectible instance must be trusted.
273             uint256 value = collectibleExposure.collect(exposureId);
274 
275             bucket.exposures.push(ExposureInfo({
276                 exposureId: exposureId,
277                 value: value
278             }));
279 
280             bucket.value += value;
281         }
282 
283         BucketCreated(bucketId, bucket.value, bucket.maxClosingTime);
284     }
285 
286     function destroyBucket(bytes32 bucketId)
287         public
288         onlyBucketManager
289     {
290         require(collectibleExposure != address(0));
291         Bucket storage bucket = buckets[bucketId];
292         require(bucket.exposures.length > 0); // ensure bucket exists
293         require(bucket.trading == false);
294         uint256 finalValue;
295 
296         for (uint256 i = 0; i < bucket.exposures.length; i++) {
297             ExposureInfo storage exposure = bucket.exposures[i];
298             finalValue += exposure.value;
299 
300             // Possible reentry attack. Collectible instance must be trusted.
301             collectibleExposure.close.value(exposure.value)(exposure.exposureId);
302         }
303 
304         BucketDestroyed(bucketId, finalValue);
305 
306         delete buckets[bucketId];
307     }
308 
309     function executeEtherDeltaBuy(
310         uint256 orderEthAmount,
311         address orderToken,
312         uint256 orderTokenAmount,
313         uint256 orderExpires,
314         uint256 orderNonce,
315         address orderUser,
316         uint8 v,
317         bytes32 r,
318         bytes32 s,
319         bytes32 bucketId,
320         uint256 amount
321     ) onlyTrader {
322         //Bucket storage bucket = buckets[bucketId];
323         require(buckets[bucketId].value >= amount);
324         require(isInPortfolioModel(orderToken));
325 
326         uint256 tradedAmount;
327         uint256 leftoverEther;
328 
329         // Trusts that etherDeltaExecutor transfers all leftover ether
330         // tokens to the sender
331         (tradedAmount, leftoverEther) =
332             etherDeltaExecutor.buyTokens.value(amount)(
333                 orderEthAmount,
334                 orderToken,
335                 orderTokenAmount,
336                 orderExpires,
337                 orderNonce,
338                 orderUser,
339                 v, r, s
340             );
341 
342         buckets[bucketId].value -= (amount - leftoverEther);
343         buckets[bucketId].holdings[orderToken] += tradedAmount;
344 
345         BucketBuy(bucketId, (amount - leftoverEther), orderToken, tradedAmount);
346     }
347 
348     function executeEtherDeltaSell(
349         uint256 orderEthAmount,
350         address orderToken,
351         uint256 orderTokenAmount,
352         uint256 orderExpires,
353         uint256 orderNonce,
354         address orderUser,
355         uint8 v,
356         bytes32 r,
357         bytes32 s,
358         bytes32 bucketId,
359         uint256 amount
360     ) onlyTrader {
361         require(buckets[bucketId].holdings[orderToken] >= amount);
362         uint256 tradedValue;
363         uint256 leftoverTokens;
364 
365         ERC20(orderToken).transfer(etherDeltaExecutor, amount);
366 
367         // Trusts that etherDeltaExecutor transfers all leftover ether
368         // tokens to the sender
369         (tradedValue, leftoverTokens) =
370             etherDeltaExecutor.sellTokens(
371                 orderEthAmount,
372                 orderToken,
373                 orderTokenAmount,
374                 orderExpires,
375                 orderNonce,
376                 orderUser,
377                 v, r, s
378                 );
379 
380         buckets[bucketId].value += tradedValue;
381         buckets[bucketId].holdings[orderToken] -= (amount - leftoverTokens);
382 
383         BucketSell(bucketId, tradedValue, orderToken, (amount - leftoverTokens));
384     }
385 
386     function() payable {
387         // Accept Ether deposits
388     }
389 
390     //--- Public constant functions
391 
392     function bucketExists(bytes32 bucketId) public constant returns (bool) {
393         return buckets[bucketId].exposures.length > 0;
394     }
395 
396     function calculateBucketId(bytes32[] exposures)
397         public
398         constant
399         returns (bytes32)
400     {
401         return sha256(this, exposures);
402     }
403 
404     function bucketHolding(bytes32 _bucketId, address _asset) constant returns (uint256) {
405         Bucket storage bucket = buckets[_bucketId];
406         return bucket.holdings[_asset];
407     }
408 
409     function bucketValue(bytes32 _bucketId) constant returns (uint256) {
410         Bucket storage bucket = buckets[_bucketId];
411         return bucket.value;
412     }
413 
414     function numAssets() constant public returns (uint256) {
415         return assets.length;
416     }
417 
418     //--- Private mutable functions
419 
420     function clearModel() private {
421         for(uint256 i = 0; i < assets.length; i++) {
422             delete model[assets[i]];
423         }
424     }
425 
426     //--- Private constant functions
427 
428     function validateModel(address[] _assets) internal {
429         require(assets.length == _assets.length);
430 
431         for (uint256 i = 0; i < assets.length; i++) {
432             require(_assets[i] == assets[i]);
433         }
434     }
435 
436     function bucketClosureTime(bytes32 bucketId) constant public returns (uint64) {
437        return buckets[bucketId].maxClosingTime;
438     }
439 
440     function isInPortfolioModel(address token) constant private returns (bool) {
441         return model[token] != 0;
442     }
443 }
444 
445 contract VeExposure is TokenDestructible {
446 
447     //--- Definitions
448 
449     using SafeMath for uint256;
450 
451     enum State { None, Open, Collected, Closing, Closed }
452 
453     struct Exposure {
454         address account;
455         uint256 veriAmount;
456         uint256 initialValue;
457         uint256 finalValue;
458         uint64 creationTime;
459         uint64 closingTime;
460         State state;
461     }
462 
463     //--- Storage
464 
465     ERC20 public veToken;
466     address public portfolio;
467 
468     uint256 public ratio;
469     uint32 public minDuration;
470     uint32 public maxDuration;
471     uint256 public minVeriAmount;
472     uint256 public maxVeriAmount;
473 
474     mapping (bytes32 => Exposure) exposures;
475     //--- Constructor
476 
477     function VeExposure(
478         ERC20 _veToken,
479         uint256 _ratio,
480         uint32 _minDuration,
481         uint32 _maxDuration,
482         uint256 _minVeriAmount,
483         uint256 _maxVeriAmount
484     ) {
485         require(_veToken != address(0));
486         require(_minDuration > 0 && _minDuration <= _maxDuration);
487         require(_minVeriAmount > 0 && _minVeriAmount <= _maxVeriAmount);
488 
489         veToken = _veToken;
490         ratio = _ratio;
491         minDuration = _minDuration;
492         maxDuration = _maxDuration;
493         minVeriAmount = _minVeriAmount;
494         maxVeriAmount = _maxVeriAmount;
495     }
496 
497     //--- Modifiers
498     modifier onlyPortfolio {
499         require(msg.sender == portfolio);
500         _;
501     }
502 
503     //--- Accessors
504 
505     function setPortfolio(address _portfolio) public onlyOwner {
506         require(_portfolio != address(0));
507 
508         portfolio = _portfolio;
509     }
510 
511     function setMinDuration(uint32 _minDuration) public onlyOwner {
512         require(_minDuration > 0 && _minDuration <= maxDuration);
513 
514         minDuration = _minDuration;
515     }
516 
517     function setMaxDuration(uint32 _maxDuration) public onlyOwner {
518         require(_maxDuration >= minDuration);
519 
520         maxDuration = _maxDuration;
521     }
522 
523     function setMinVeriAmount(uint32 _minVeriAmount) public onlyOwner {
524         require(_minVeriAmount > 0 && _minVeriAmount <= maxVeriAmount);
525 
526         minVeriAmount = _minVeriAmount;
527     }
528 
529     function setMaxVeriAmount(uint32 _maxVeriAmount) public onlyOwner {
530         require(_maxVeriAmount >= minVeriAmount);
531 
532         maxVeriAmount = _maxVeriAmount;
533     }
534 
535     //--- Events
536 
537     event ExposureOpened(
538         bytes32 indexed id,
539         address indexed account,
540         uint256 veriAmount,
541         uint256 value,
542         uint64 creationTime,
543         uint64 closingTime
544     );
545 
546     event ExposureCollected(
547         bytes32 indexed id,
548         address indexed account,
549         uint256 value
550     );
551 
552     event ExposureClosed(
553         bytes32 indexed id,
554         address indexed account,
555         uint256 initialValue,
556         uint256 finalValue
557     );
558 
559     event ExposureSettled(
560         bytes32 indexed id,
561         address indexed account,
562         uint256 value
563     );
564 
565     //--- Public functions
566 
567     function open(uint256 veriAmount, uint32 duration, uint256 nonce) public payable {
568         require(veriAmount >= minVeriAmount && veriAmount <= maxVeriAmount);
569         require(duration >= minDuration && duration <= maxDuration);
570         require(checkRatio(veriAmount, msg.value));
571 
572         bytes32 id = calculateId({
573             veriAmount: veriAmount,
574             value: msg.value,
575             duration: duration,
576             nonce: nonce
577         });
578         require(!exists(id));
579 
580         openExposure(id, veriAmount, duration);
581         forwardTokens(veriAmount);
582     }
583 
584     function getClosingTime(bytes32 id) public onlyPortfolio constant returns (uint64) {
585         Exposure storage exposure = exposures[id];
586         return exposure.closingTime;
587     }
588 
589     function collect(bytes32 id) public onlyPortfolio returns (uint256 value) {
590         Exposure storage exposure = exposures[id];
591         require(exposure.state == State.Open);
592 
593         value = exposure.initialValue;
594 
595         exposure.state = State.Collected;
596         msg.sender.transfer(value);
597 
598         ExposureCollected({
599             id: id,
600             account: exposure.account,
601             value: value
602         });
603     }
604 
605     function close(bytes32 id) public payable onlyPortfolio {
606         Exposure storage exposure = exposures[id];
607         require(exposure.state == State.Collected);
608         require(hasPassed(exposure.closingTime));
609 
610         exposure.state = State.Closed;
611         exposure.finalValue = msg.value;
612 
613         ExposureClosed({
614             id: id,
615             account: exposure.account,
616             initialValue: exposure.initialValue,
617             finalValue: exposure.finalValue
618         });
619     }
620 
621     function settle(bytes32 id) public returns (uint256 finalValue) {
622         Exposure storage exposure = exposures[id];
623         require(msg.sender == exposure.account);
624         require(exposure.state == State.Closed);
625 
626         finalValue = exposure.finalValue;
627         delete exposures[id];
628 
629         msg.sender.transfer(finalValue);
630 
631         ExposureSettled({
632             id: id,
633             account: msg.sender,
634             value: finalValue
635         });
636     }
637 
638     //--- Public constant functions
639 
640     function status(bytes32 id)
641         public
642         constant
643         returns (uint8 state)
644     {
645         Exposure storage exposure = exposures[id];
646         state = uint8(exposure.state);
647 
648         if (exposure.state == State.Collected && hasPassed(exposure.closingTime)) {
649             state = uint8(State.Closing);
650         }
651     }
652 
653     function exists(bytes32 id) public constant returns (bool) {
654         return exposures[id].creationTime > 0;
655     }
656 
657     function checkRatio(uint256 veriAmount, uint256 value)
658         public
659         constant
660         returns (bool)
661     {
662         uint256 expectedValue = ratio.mul(veriAmount).div(1 ether);
663         return value == expectedValue;
664     }
665 
666     function calculateId(
667         uint256 veriAmount,
668         uint256 value,
669         uint32 duration,
670         uint256 nonce
671     )
672         public
673         constant
674         returns (bytes32)
675     {
676         return sha256(
677             this,
678             msg.sender,
679             value,
680             veriAmount,
681             duration,
682             nonce
683         );
684     }
685 
686     //--- Fallback function
687 
688     function() public payable {
689         // accept Ether deposits
690     }
691 
692     //--- Private functions
693 
694     function forwardTokens(uint256 veriAmount) private {
695         require(veToken.transferFrom(msg.sender, this, veriAmount));
696         require(veToken.approve(portfolio, veriAmount));
697     }
698 
699     function openExposure(bytes32 id, uint256 veriAmount, uint32 duration) private constant {
700         uint64 creationTime = uint64(block.timestamp);
701         uint64 closingTime = uint64(block.timestamp.add(duration));
702 
703         exposures[id] = Exposure({
704             account: msg.sender,
705             veriAmount: veriAmount,
706             initialValue: msg.value,
707             finalValue: 0,
708             creationTime: creationTime,
709             closingTime: closingTime,
710             state: State.Open
711         });
712 
713         ExposureOpened({
714             id: id,
715             account: msg.sender,
716             creationTime: creationTime,
717             closingTime: closingTime,
718             veriAmount: veriAmount,
719             value: msg.value
720         });
721     }
722 
723     //--- Private constant functions
724 
725     function hasPassed(uint64 time)
726         private
727         constant
728         returns (bool)
729     {
730         return block.timestamp >= time;
731     }
732 }
733 
734 contract EDExecutor {
735     function buyTokens(
736         uint256 orderEthAmount,
737         address orderToken,
738         uint256 orderTokenAmount,
739         uint256 orderExpires,
740         uint256 orderNonce,
741         address orderUser,
742         uint8 v,
743         bytes32 r,
744         bytes32 s
745     ) payable returns (uint256 tradedAmount, uint256 leftoverEther);
746 
747     function sellTokens(
748         // ED Order identification
749         uint256 orderEthAmount,
750         address orderToken,
751         uint256 orderTokenAmount,
752         uint256 orderExpires,
753         uint256 orderNonce,
754         address orderUser,
755         uint8 v,
756         bytes32 r,
757         bytes32 s
758     ) returns (uint256 tradedValue, uint256 leftoverTokens);
759 }