1 pragma solidity ^0.4.11;
2 
3 
4 contract Storage {
5     struct Crate {
6         mapping(bytes32 => uint256) uints;
7         mapping(bytes32 => address) addresses;
8         mapping(bytes32 => bool) bools;
9         mapping(address => uint256) bals;
10     }
11 
12     mapping(bytes32 => Crate) crates;
13 
14     function setUInt(bytes32 _crate, bytes32 _key, uint256 _value)  {
15         crates[_crate].uints[_key] = _value;
16     }
17 
18     function getUInt(bytes32 _crate, bytes32 _key) constant returns(uint256) {
19         return crates[_crate].uints[_key];
20     }
21 
22     function setAddress(bytes32 _crate, bytes32 _key, address _value)  {
23         crates[_crate].addresses[_key] = _value;
24     }
25 
26     function getAddress(bytes32 _crate, bytes32 _key) constant returns(address) {
27         return crates[_crate].addresses[_key];
28     }
29 
30     function setBool(bytes32 _crate, bytes32 _key, bool _value)  {
31         crates[_crate].bools[_key] = _value;
32     }
33 
34     function getBool(bytes32 _crate, bytes32 _key) constant returns(bool) {
35         return crates[_crate].bools[_key];
36     }
37 
38     function setBal(bytes32 _crate, address _key, uint256 _value)  {
39         crates[_crate].bals[_key] = _value;
40     }
41 
42     function getBal(bytes32 _crate, address _key) constant returns(uint256) {
43         return crates[_crate].bals[_key];
44     }
45 }
46 
47 contract StorageEnabled {
48 
49   // satelite contract addresses
50   address public storageAddr;
51 
52   function StorageEnabled(address _storageAddr) {
53     storageAddr = _storageAddr;
54   }
55 
56 
57   // ############################################
58   // ########### NUTZ FUNCTIONS  ################
59   // ############################################
60 
61 
62   // all Nutz balances
63   function babzBalanceOf(address _owner) constant returns (uint256) {
64     return Storage(storageAddr).getBal('Nutz', _owner);
65   }
66   function _setBabzBalanceOf(address _owner, uint256 _newValue) internal {
67     Storage(storageAddr).setBal('Nutz', _owner, _newValue);
68   }
69   // active supply - sum of balances above
70   function activeSupply() constant returns (uint256) {
71     return Storage(storageAddr).getUInt('Nutz', 'activeSupply');
72   }
73   function _setActiveSupply(uint256 _newActiveSupply) internal {
74     Storage(storageAddr).setUInt('Nutz', 'activeSupply', _newActiveSupply);
75   }
76   // burn pool - inactive supply
77   function burnPool() constant returns (uint256) {
78     return Storage(storageAddr).getUInt('Nutz', 'burnPool');
79   }
80   function _setBurnPool(uint256 _newBurnPool) internal {
81     Storage(storageAddr).setUInt('Nutz', 'burnPool', _newBurnPool);
82   }
83   // power pool - inactive supply
84   function powerPool() constant returns (uint256) {
85     return Storage(storageAddr).getUInt('Nutz', 'powerPool');
86   }
87   function _setPowerPool(uint256 _newPowerPool) internal {
88     Storage(storageAddr).setUInt('Nutz', 'powerPool', _newPowerPool);
89   }
90 
91 
92 
93 
94 
95   // ############################################
96   // ########### POWER   FUNCTIONS  #############
97   // ############################################
98 
99   // all power balances
100   function powerBalanceOf(address _owner) constant returns (uint256) {
101     return Storage(storageAddr).getBal('Power', _owner);
102   }
103 
104   function _setPowerBalanceOf(address _owner, uint256 _newValue) internal {
105     Storage(storageAddr).setBal('Power', _owner, _newValue);
106   }
107 
108   function outstandingPower() constant returns (uint256) {
109     return Storage(storageAddr).getUInt('Power', 'outstandingPower');
110   }
111 
112   function _setOutstandingPower(uint256 _newOutstandingPower) internal {
113     Storage(storageAddr).setUInt('Power', 'outstandingPower', _newOutstandingPower);
114   }
115 
116   function authorizedPower() constant returns (uint256) {
117     return Storage(storageAddr).getUInt('Power', 'authorizedPower');
118   }
119 
120   function _setAuthorizedPower(uint256 _newAuthorizedPower) internal {
121     Storage(storageAddr).setUInt('Power', 'authorizedPower', _newAuthorizedPower);
122   }
123 
124 
125   function downs(address _user) constant public returns (uint256 total, uint256 left, uint256 start) {
126     uint256 rawBytes = Storage(storageAddr).getBal('PowerDown', _user);
127     start = uint64(rawBytes);
128     left = uint96(rawBytes >> (64));
129     total = uint96(rawBytes >> (96 + 64));
130     return;
131   }
132 
133   function _setDownRequest(address _holder, uint256 total, uint256 left, uint256 start) internal {
134     uint256 result = uint64(start) + (left << 64) + (total << (96 + 64));
135     Storage(storageAddr).setBal('PowerDown', _holder, result);
136   }
137 
138 }
139 
140 
141 contract Governable {
142 
143   // list of admins, council at first spot
144   address[] public admins;
145 
146   function Governable() {
147     admins.length = 1;
148     admins[0] = msg.sender;
149   }
150 
151   modifier onlyAdmins() {
152     bool isAdmin = false;
153     for (uint256 i = 0; i < admins.length; i++) {
154       if (msg.sender == admins[i]) {
155         isAdmin = true;
156       }
157     }
158     require(isAdmin == true);
159     _;
160   }
161 
162   function addAdmin(address _admin) public onlyAdmins {
163     for (uint256 i = 0; i < admins.length; i++) {
164       require(_admin != admins[i]);
165     }
166     require(admins.length < 10);
167     admins[admins.length++] = _admin;
168   }
169 
170   function removeAdmin(address _admin) public onlyAdmins {
171     uint256 pos = admins.length;
172     for (uint256 i = 0; i < admins.length; i++) {
173       if (_admin == admins[i]) {
174         pos = i;
175       }
176     }
177     require(pos < admins.length);
178     // if not last element, switch with last
179     if (pos < admins.length - 1) {
180       admins[pos] = admins[admins.length - 1];
181     }
182     // then cut off the tail
183     admins.length--;
184   }
185 
186 }
187 
188 /**
189  * @title Pausable
190  * @dev Base contract which allows children to implement an emergency stop mechanism.
191  */
192 contract Pausable is Governable {
193 
194   bool public paused = true;
195 
196   /**
197    * @dev modifier to allow actions only when the contract IS paused
198    */
199   modifier whenNotPaused() {
200     require(!paused);
201     _;
202   }
203 
204   /**
205    * @dev modifier to allow actions only when the contract IS NOT paused
206    */
207   modifier whenPaused() {
208     require(paused);
209     _;
210   }
211 
212   /**
213    * @dev called by the owner to pause, triggers stopped state
214    */
215   function pause() onlyAdmins whenNotPaused {
216     paused = true;
217   }
218 
219   /**
220    * @dev called by the owner to unpause, returns to normal state
221    */
222   function unpause() onlyAdmins whenPaused {
223     //TODO: do some checks
224     paused = false;
225   }
226 
227 }
228 
229 /**
230  * @title SafeMath
231  * @dev Math operations with safety checks that throw on error
232  */
233 library SafeMath {
234   function mul(uint256 a, uint256 b) internal returns (uint256) {
235     uint256 c = a * b;
236     assert(a == 0 || c / a == b);
237     return c;
238   }
239 
240   function div(uint256 a, uint256 b) internal returns (uint256) {
241     // assert(b > 0); // Solidity automatically throws when dividing by 0
242     uint256 c = a / b;
243     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
244     return c;
245   }
246 
247   function sub(uint256 a, uint256 b) internal returns (uint256) {
248     assert(b <= a);
249     return a - b;
250   }
251 
252   function add(uint256 a, uint256 b) internal returns (uint256) {
253     uint256 c = a + b;
254     assert(c >= a);
255     return c;
256   }
257 }
258 
259 contract NutzEnabled is Pausable, StorageEnabled {
260   using SafeMath for uint;
261 
262   // satelite contract addresses
263   address public nutzAddr;
264 
265 
266   modifier onlyNutz() {
267     require(msg.sender == nutzAddr);
268     _;
269   }
270 
271   function NutzEnabled(address _nutzAddr, address _storageAddr)
272     StorageEnabled(_storageAddr) {
273     nutzAddr = _nutzAddr;
274   }
275 
276   // ############################################
277   // ########### NUTZ FUNCTIONS  ################
278   // ############################################
279 
280   // total supply
281   function totalSupply() constant returns (uint256) {
282     return activeSupply().add(powerPool()).add(burnPool());
283   }
284 
285   // allowances according to ERC20
286   // not written to storage, as not very critical
287   mapping (address => mapping (address => uint)) internal allowed;
288 
289   function allowance(address _owner, address _spender) constant returns (uint256) {
290     return allowed[_owner][_spender];
291   }
292 
293   function approve(address _owner, address _spender, uint256 _amountBabz) public onlyNutz whenNotPaused {
294     require(_owner != _spender);
295     allowed[_owner][_spender] = _amountBabz;
296   }
297 
298   function _transfer(address _from, address _to, uint256 _amountBabz, bytes _data) internal {
299     require(_to != address(this));
300     require(_to != address(0));
301     require(_amountBabz > 0);
302     require(_from != _to);
303     _setBabzBalanceOf(_from, babzBalanceOf(_from).sub(_amountBabz));
304     _setBabzBalanceOf(_to, babzBalanceOf(_to).add(_amountBabz));
305   }
306 
307   function transfer(address _from, address _to, uint256 _amountBabz, bytes _data) public onlyNutz whenNotPaused {
308     _transfer(_from, _to, _amountBabz, _data);
309   }
310 
311   function transferFrom(address _sender, address _from, address _to, uint256 _amountBabz, bytes _data) public onlyNutz whenNotPaused {
312     allowed[_from][_sender] = allowed[_from][_sender].sub(_amountBabz);
313     _transfer(_from, _to, _amountBabz, _data);
314   }
315 
316 }
317 
318 /**
319  * @title PullPayment
320  * @dev Base contract supporting async send for pull payments.
321  */
322 contract PullPayment {
323 
324   modifier onlyNutz() {
325       _;
326   }
327   
328 modifier onlyOwner() {
329       _;
330   }
331 
332   modifier whenNotPaused () {_;}
333 
334   function balanceOf(address _owner) constant returns (uint256 value);
335 
336   function paymentOf(address _owner) constant returns (uint256 value, uint256 date) ;
337 
338   /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
339   /// @param _dailyLimit Amount in wei.
340   function changeDailyLimit(uint _dailyLimit) public ;
341 
342   function changeWithdrawalDate(address _owner, uint256 _newDate)  public ;
343 
344   function asyncSend(address _dest) public payable ;
345 
346 
347   function withdraw() public ;
348 
349   /*
350    * Internal functions
351    */
352   /// @dev Returns if amount is within daily limit and resets spentToday after one day.
353   /// @param amount Amount to withdraw.
354   /// @return Returns if amount is under daily limit.
355   function isUnderLimit(uint amount) internal returns (bool);
356 
357 }
358 
359 
360 /**
361  * Nutz implements a price floor and a price ceiling on the token being
362  * sold. It is based of the zeppelin token contract.
363  */
364 contract Nutz {
365 
366 
367   // returns balances of active holders
368   function balanceOf(address _owner) constant returns (uint);
369 
370   function totalSupply() constant returns (uint256);
371 
372   function activeSupply() constant returns (uint256);
373 
374   // return remaining allowance
375   // if calling return allowed[address(this)][_spender];
376   // returns balance of ether parked to be withdrawn
377   function allowance(address _owner, address _spender) constant returns (uint256);
378 
379   // returns either the salePrice, or if reserve does not suffice
380   // for active supply, returns maxFloor
381   function floor() constant returns (uint256);
382 
383   // returns either the salePrice, or if reserve does not suffice
384   // for active supply, returns maxFloor
385   function ceiling() constant returns (uint256);
386 
387   function powerPool() constant returns (uint256);
388 
389 
390   function _checkDestination(address _from, address _to, uint256 _value, bytes _data) internal;
391 
392 
393 
394   // ############################################
395   // ########### ADMIN FUNCTIONS ################
396   // ############################################
397 
398   function powerDown(address powerAddr, address _holder, uint256 _amountBabz) public ;
399 
400 
401   function asyncSend(address _pullAddr, address _dest, uint256 _amountWei) public ;
402 
403 
404   // ############################################
405   // ########### PUBLIC FUNCTIONS ###############
406   // ############################################
407 
408   function approve(address _spender, uint256 _amountBabz) public;
409 
410   function transfer(address _to, uint256 _amountBabz, bytes _data) public returns (bool);
411 
412   function transfer(address _to, uint256 _amountBabz) public returns (bool);
413 
414   function transData(address _to, uint256 _amountBabz, bytes _data) public returns (bool);
415 
416   function transferFrom(address _from, address _to, uint256 _amountBabz, bytes _data) public returns (bool);
417 
418   function transferFrom(address _from, address _to, uint256 _amountBabz);
419 
420   function () public payable;
421 
422   function purchase(uint256 _price) public payable;
423 
424   function sell(uint256 _price, uint256 _amountBabz);
425 
426   function powerUp(uint256 _amountBabz) public;
427 
428 }
429 
430 
431 contract MarketEnabled is NutzEnabled {
432 
433   uint256 constant INFINITY = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
434 
435   // address of the pull payemnt satelite
436   address public pullAddr;
437 
438   // the Token sale mechanism parameters:
439   // purchasePrice is the number of NTZ received for purchase with 1 ETH
440   uint256 internal purchasePrice;
441 
442   // floor is the number of NTZ needed, to receive 1 ETH in sell
443   uint256 internal salePrice;
444 
445   function MarketEnabled(address _pullAddr, address _storageAddr, address _nutzAddr)
446     NutzEnabled(_nutzAddr, _storageAddr) {
447     pullAddr = _pullAddr;
448   }
449 
450 
451   function ceiling() constant returns (uint256) {
452     return purchasePrice;
453   }
454 
455   // returns either the salePrice, or if reserve does not suffice
456   // for active supply, returns maxFloor
457   function floor() constant returns (uint256) {
458     if (nutzAddr.balance == 0) {
459       return INFINITY;
460     }
461     uint256 maxFloor = activeSupply().mul(1000000).div(nutzAddr.balance); // 1,000,000 WEI, used as price factor
462     // return max of maxFloor or salePrice
463     return maxFloor >= salePrice ? maxFloor : salePrice;
464   }
465 
466   function moveCeiling(uint256 _newPurchasePrice) public onlyAdmins {
467     require(_newPurchasePrice <= salePrice);
468     purchasePrice = _newPurchasePrice;
469   }
470 
471   function moveFloor(uint256 _newSalePrice) public onlyAdmins {
472     require(_newSalePrice >= purchasePrice);
473     // moveFloor fails if the administrator tries to push the floor so low
474     // that the sale mechanism is no longer able to buy back all tokens at
475     // the floor price if those funds were to be withdrawn.
476     if (_newSalePrice < INFINITY) {
477       require(nutzAddr.balance >= activeSupply().mul(1000000).div(_newSalePrice)); // 1,000,000 WEI, used as price factor
478     }
479     salePrice = _newSalePrice;
480   }
481 
482   function purchase(address _sender, uint256 _value, uint256 _price) public onlyNutz whenNotPaused returns (uint256) {
483     // disable purchases if purchasePrice set to 0
484     require(purchasePrice > 0);
485     require(_price == purchasePrice);
486 
487     uint256 amountBabz = purchasePrice.mul(_value).div(1000000); // 1,000,000 WEI, used as price factor
488     // avoid deposits that issue nothing
489     // might happen with very high purchase price
490     require(amountBabz > 0);
491 
492     // make sure power pool grows proportional to economy
493     uint256 activeSup = activeSupply();
494     uint256 powPool = powerPool();
495     if (powPool > 0) {
496       uint256 powerShare = powPool.mul(amountBabz).div(activeSup.add(burnPool()));
497       _setPowerPool(powPool.add(powerShare));
498     }
499     _setActiveSupply(activeSup.add(amountBabz));
500     _setBabzBalanceOf(_sender, babzBalanceOf(_sender).add(amountBabz));
501     return amountBabz;
502   }
503 
504   function sell(address _from, uint256 _price, uint256 _amountBabz) public onlyNutz whenNotPaused {
505     uint256 effectiveFloor = floor();
506     require(_amountBabz != 0);
507     require(effectiveFloor != INFINITY);
508     require(_price == effectiveFloor);
509 
510     uint256 amountWei = _amountBabz.mul(1000000).div(effectiveFloor);  // 1,000,000 WEI, used as price factor
511     require(amountWei > 0);
512     // make sure power pool shrinks proportional to economy
513     uint256 powPool = powerPool();
514     uint256 activeSup = activeSupply();
515     if (powPool > 0) {
516       uint256 powerShare = powPool.mul(_amountBabz).div(activeSup);
517       _setPowerPool(powPool.sub(powerShare));
518     }
519     _setActiveSupply(activeSup.sub(_amountBabz));
520     _setBabzBalanceOf(_from, babzBalanceOf(_from).sub(_amountBabz));
521     Nutz(nutzAddr).asyncSend(pullAddr, _from, amountWei);
522   }
523 
524 
525   // withdraw excessive reserve - i.e. milestones
526   function allocateEther(uint256 _amountWei, address _beneficiary) public onlyAdmins {
527     require(_amountWei > 0);
528     // allocateEther fails if allocating those funds would mean that the
529     // sale mechanism is no longer able to buy back all tokens at the floor
530     // price if those funds were to be withdrawn.
531     require(nutzAddr.balance.sub(_amountWei) >= activeSupply().mul(1000000).div(salePrice)); // 1,000,000 WEI, used as price factor
532     Nutz(nutzAddr).asyncSend(pullAddr, _beneficiary, _amountWei);
533   }
534 
535 }
536 
537 
538 
539 contract Power {
540 
541 
542 
543   function balanceOf(address _holder) constant returns (uint256);
544 
545   function totalSupply() constant returns (uint256);
546 
547   function activeSupply() constant returns (uint256);
548 
549 
550   // ############################################
551   // ########### ADMIN FUNCTIONS ################
552   // ############################################
553 
554   function slashPower(address _holder, uint256 _value, bytes32 _data) public ;
555 
556   function powerUp(address _holder, uint256 _value) public ;
557 
558   // ############################################
559   // ########### PUBLIC FUNCTIONS ###############
560   // ############################################
561 
562   // registers a powerdown request
563   function transfer(address _to, uint256 _amountPower) public returns (bool success);
564 
565   function downtime() public returns (uint256);
566 
567   function downTick(address _owner) public;
568 
569   function downs(address _owner) constant public returns (uint256, uint256, uint256);
570 
571 }
572 
573 
574 contract PowerEnabled is MarketEnabled {
575 
576   // satelite contract addresses
577   address public powerAddr;
578 
579   // maxPower is a limit of total power that can be outstanding
580   // maxPower has a valid value between outstandingPower and authorizedPow/2
581   uint256 public maxPower = 0;
582 
583   // time it should take to power down
584   uint256 public downtime;
585 
586   modifier onlyPower() {
587     require(msg.sender == powerAddr);
588     _;
589   }
590 
591   function PowerEnabled(address _powerAddr, address _pullAddr, address _storageAddr, address _nutzAddr)
592     MarketEnabled(_pullAddr, _nutzAddr, _storageAddr) {
593     powerAddr = _powerAddr;
594   }
595 
596   function setMaxPower(uint256 _maxPower) public onlyAdmins {
597     require(outstandingPower() <= _maxPower && _maxPower < authorizedPower());
598     maxPower = _maxPower;
599   }
600 
601   function setDowntime(uint256 _downtime) public onlyAdmins {
602     downtime = _downtime;
603   }
604 
605   // this is called when NTZ are deposited into the burn pool
606   function dilutePower(uint256 _amountBabz, uint256 _amountPower) public onlyAdmins {
607     uint256 authorizedPow = authorizedPower();
608     uint256 totalBabz = totalSupply();
609     if (authorizedPow == 0) {
610       // during the first capital increase, set value directly as authorized shares
611       _setAuthorizedPower((_amountPower > 0) ? _amountPower : _amountBabz.add(totalBabz));
612     } else {
613       // in later increases, expand authorized shares at same rate like economy
614       _setAuthorizedPower(authorizedPow.mul(totalBabz.add(_amountBabz)).div(totalBabz));
615     }
616     _setBurnPool(burnPool().add(_amountBabz));
617   }
618 
619   function _slashPower(address _holder, uint256 _value, bytes32 _data) internal {
620     uint256 previouslyOutstanding = outstandingPower();
621     _setOutstandingPower(previouslyOutstanding.sub(_value));
622     // adjust size of power pool
623     uint256 powPool = powerPool();
624     uint256 slashingBabz = _value.mul(powPool).div(previouslyOutstanding);
625     _setPowerPool(powPool.sub(slashingBabz));
626     // put event into satelite contract
627     Power(powerAddr).slashPower(_holder, _value, _data);
628   }
629 
630   function slashPower(address _holder, uint256 _value, bytes32 _data) public onlyAdmins {
631     _setPowerBalanceOf(_holder, powerBalanceOf(_holder).sub(_value));
632     _slashPower(_holder, _value, _data);
633   }
634 
635   function slashDownRequest(uint256 _pos, address _holder, uint256 _value, bytes32 _data) public onlyAdmins {
636     var (total, left, start) = downs(_holder);
637     left = left.sub(_value);
638     _setDownRequest(_holder, total, left, start);
639     _slashPower(_holder, _value, _data);
640   }
641 
642   // this is called when NTZ are deposited into the power pool
643   function powerUp(address _sender, address _from, uint256 _amountBabz) public onlyNutz whenNotPaused {
644     uint256 authorizedPow = authorizedPower();
645     require(authorizedPow != 0);
646     require(_amountBabz != 0);
647     uint256 totalBabz = totalSupply();
648     require(totalBabz != 0);
649     uint256 amountPow = _amountBabz.mul(authorizedPow).div(totalBabz);
650     // check pow limits
651     uint256 outstandingPow = outstandingPower();
652     require(outstandingPow.add(amountPow) <= maxPower);
653 
654     if (_sender != _from) {
655       allowed[_from][_sender] = allowed[_from][_sender].sub(_amountBabz);
656     }
657 
658     _setOutstandingPower(outstandingPow.add(amountPow));
659 
660     uint256 powBal = powerBalanceOf(_from).add(amountPow);
661     require(powBal >= authorizedPow.div(10000)); // minShare = 10000
662     _setPowerBalanceOf(_from, powBal);
663     _setActiveSupply(activeSupply().sub(_amountBabz));
664     _setBabzBalanceOf(_from, babzBalanceOf(_from).sub(_amountBabz));
665     _setPowerPool(powerPool().add(_amountBabz));
666     Power(powerAddr).powerUp(_from, amountPow);
667   }
668 
669   function powerTotalSupply() constant returns (uint256) {
670     uint256 issuedPower = authorizedPower().div(2);
671     // return max of maxPower or issuedPower
672     return maxPower >= issuedPower ? maxPower : issuedPower;
673   }
674 
675   function _vestedDown(uint256 _total, uint256 _left, uint256 _start, uint256 _now) internal constant returns (uint256) {
676     if (_now <= _start) {
677       return 0;
678     }
679     // calculate amountVested
680     // amountVested is amount that can be withdrawn according to time passed
681     uint256 timePassed = _now.sub(_start);
682     if (timePassed > downtime) {
683      timePassed = downtime;
684     }
685     uint256 amountVested = _total.mul(timePassed).div(downtime);
686     uint256 amountFrozen = _total.sub(amountVested);
687     if (_left <= amountFrozen) {
688       return 0;
689     }
690     return _left.sub(amountFrozen);
691   }
692 
693   function createDownRequest(address _owner, uint256 _amountPower) public onlyPower whenNotPaused {
694     // prevent powering down tiny amounts
695     // when powering down, at least totalSupply/minShare Power should be claimed
696     require(_amountPower >= authorizedPower().div(10000)); // minShare = 10000;
697     _setPowerBalanceOf(_owner, powerBalanceOf(_owner).sub(_amountPower));
698 
699     var (, left, ) = downs(_owner);
700     uint256 total = _amountPower.add(left);
701     _setDownRequest(_owner, total, total, now);
702   }
703 
704   // executes a powerdown request
705   function downTick(address _holder, uint256 _now) public onlyPower whenNotPaused {
706     var (total, left, start) = downs(_holder);
707     uint256 amountPow = _vestedDown(total, left, start, _now);
708 
709     // prevent power down in tiny steps
710     uint256 minStep = total.div(10);
711     require(left <= minStep || minStep <= amountPow);
712 
713     // calculate token amount representing share of power
714     uint256 amountBabz = amountPow.mul(totalSupply()).div(authorizedPower());
715 
716     // transfer power and tokens
717     _setOutstandingPower(outstandingPower().sub(amountPow));
718     left = left.sub(amountPow);
719     _setPowerPool(powerPool().sub(amountBabz));
720     _setActiveSupply(activeSupply().add(amountBabz));
721     _setBabzBalanceOf(_holder, babzBalanceOf(_holder).add(amountBabz));
722     // down request completed
723     if (left == 0) {
724       start = 0;
725       total = 0;
726     }
727     // TODO
728     _setDownRequest(_holder, total, left, start);
729     Nutz(nutzAddr).powerDown(powerAddr, _holder, amountBabz);
730   }
731 }
732 
733 
734 contract Controller is PowerEnabled {
735 
736   function Controller(address _powerAddr, address _pullAddr, address _nutzAddr, address _storageAddr) 
737     PowerEnabled(_powerAddr, _pullAddr, _nutzAddr, _storageAddr) {
738   }
739 
740   function setContracts(address _storageAddr, address _nutzAddr, address _powerAddr, address _pullAddr) public onlyAdmins whenPaused {
741     storageAddr = _storageAddr;
742     nutzAddr = _nutzAddr;
743     powerAddr = _powerAddr;
744     pullAddr = _pullAddr;
745   }
746 
747   function changeDailyLimit(uint256 _dailyLimit) public onlyAdmins {
748     PullPayment(pullAddr).changeDailyLimit(_dailyLimit);
749   }
750 
751   function kill(address _newController) public onlyAdmins whenPaused {
752     if (powerAddr != address(0)) { Ownable(powerAddr).transferOwnership(msg.sender); }
753     if (pullAddr != address(0)) { Ownable(pullAddr).transferOwnership(msg.sender); }
754     if (nutzAddr != address(0)) { Ownable(nutzAddr).transferOwnership(msg.sender); }
755     if (storageAddr != address(0)) { Ownable(storageAddr).transferOwnership(msg.sender); }
756     selfdestruct(_newController);
757   }
758 
759 }
760 
761 
762 /**
763  * @title Ownable
764  * @dev The Ownable contract has an owner address, and provides basic authorization control
765  * functions, this simplifies the implementation of "user permissions".
766  */
767 contract Ownable {
768   address public owner;
769 
770 
771   /**
772    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
773    * account.
774    */
775   function Ownable() {
776     owner = msg.sender;
777   }
778 
779 
780   /**
781    * @dev Throws if called by any account other than the owner.
782    */
783   modifier onlyOwner() {
784     require(msg.sender == owner);
785     _;
786   }
787 
788 
789   /**
790    * @dev Allows the current owner to transfer control of the contract to a newOwner.
791    * @param newOwner The address to transfer ownership to.
792    */
793   function transferOwnership(address newOwner) onlyOwner {
794     require(newOwner != address(0));      
795     owner = newOwner;
796   }
797 
798 }