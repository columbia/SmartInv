1 pragma solidity ^0.4.11;
2 
3 
4 
5 contract PullPayInterface {
6   function asyncSend(address _dest) public payable;
7 }
8 
9 contract Governable {
10 
11   // list of admins, council at first spot
12   address[] public admins;
13 
14   function Governable() {
15     admins.length = 1;
16     admins[0] = msg.sender;
17   }
18 
19   modifier onlyAdmins() {
20     bool isAdmin = false;
21     for (uint256 i = 0; i < admins.length; i++) {
22       if (msg.sender == admins[i]) {
23         isAdmin = true;
24       }
25     }
26     require(isAdmin == true);
27     _;
28   }
29 
30   function addAdmin(address _admin) public onlyAdmins {
31     for (uint256 i = 0; i < admins.length; i++) {
32       require(_admin != admins[i]);
33     }
34     require(admins.length < 10);
35     admins[admins.length++] = _admin;
36   }
37 
38   function removeAdmin(address _admin) public onlyAdmins {
39     uint256 pos = admins.length;
40     for (uint256 i = 0; i < admins.length; i++) {
41       if (_admin == admins[i]) {
42         pos = i;
43       }
44     }
45     require(pos < admins.length);
46     // if not last element, switch with last
47     if (pos < admins.length - 1) {
48       admins[pos] = admins[admins.length - 1];
49     }
50     // then cut off the tail
51     admins.length--;
52   }
53 
54 }
55 
56 
57 
58 
59 contract StorageEnabled {
60 
61   // satelite contract addresses
62   address public storageAddr;
63 
64   function StorageEnabled(address _storageAddr) {
65     storageAddr = _storageAddr;
66   }
67 
68 
69   // ############################################
70   // ########### NUTZ FUNCTIONS  ################
71   // ############################################
72 
73 
74   // all Nutz balances
75   function babzBalanceOf(address _owner) constant returns (uint256) {
76     return Storage(storageAddr).getBal('Nutz', _owner);
77   }
78   function _setBabzBalanceOf(address _owner, uint256 _newValue) internal {
79     Storage(storageAddr).setBal('Nutz', _owner, _newValue);
80   }
81   // active supply - sum of balances above
82   function activeSupply() constant returns (uint256) {
83     return Storage(storageAddr).getUInt('Nutz', 'activeSupply');
84   }
85   function _setActiveSupply(uint256 _newActiveSupply) internal {
86     Storage(storageAddr).setUInt('Nutz', 'activeSupply', _newActiveSupply);
87   }
88   // burn pool - inactive supply
89   function burnPool() constant returns (uint256) {
90     return Storage(storageAddr).getUInt('Nutz', 'burnPool');
91   }
92   function _setBurnPool(uint256 _newBurnPool) internal {
93     Storage(storageAddr).setUInt('Nutz', 'burnPool', _newBurnPool);
94   }
95   // power pool - inactive supply
96   function powerPool() constant returns (uint256) {
97     return Storage(storageAddr).getUInt('Nutz', 'powerPool');
98   }
99   function _setPowerPool(uint256 _newPowerPool) internal {
100     Storage(storageAddr).setUInt('Nutz', 'powerPool', _newPowerPool);
101   }
102 
103 
104 
105 
106 
107   // ############################################
108   // ########### POWER   FUNCTIONS  #############
109   // ############################################
110 
111   // all power balances
112   function powerBalanceOf(address _owner) constant returns (uint256) {
113     return Storage(storageAddr).getBal('Power', _owner);
114   }
115 
116   function _setPowerBalanceOf(address _owner, uint256 _newValue) internal {
117     Storage(storageAddr).setBal('Power', _owner, _newValue);
118   }
119 
120   function outstandingPower() constant returns (uint256) {
121     return Storage(storageAddr).getUInt('Power', 'outstandingPower');
122   }
123 
124   function _setOutstandingPower(uint256 _newOutstandingPower) internal {
125     Storage(storageAddr).setUInt('Power', 'outstandingPower', _newOutstandingPower);
126   }
127 
128   function authorizedPower() constant returns (uint256) {
129     return Storage(storageAddr).getUInt('Power', 'authorizedPower');
130   }
131 
132   function _setAuthorizedPower(uint256 _newAuthorizedPower) internal {
133     Storage(storageAddr).setUInt('Power', 'authorizedPower', _newAuthorizedPower);
134   }
135 
136 
137   function downs(address _user) constant public returns (uint256 total, uint256 left, uint256 start) {
138     uint256 rawBytes = Storage(storageAddr).getBal('PowerDown', _user);
139     start = uint64(rawBytes);
140     left = uint96(rawBytes >> (64));
141     total = uint96(rawBytes >> (96 + 64));
142     return;
143   }
144 
145   function _setDownRequest(address _holder, uint256 total, uint256 left, uint256 start) internal {
146     uint256 result = uint64(start) + (left << 64) + (total << (96 + 64));
147     Storage(storageAddr).setBal('PowerDown', _holder, result);
148   }
149 
150 }
151 
152 
153 /**
154  * @title Pausable
155  * @dev Base contract which allows children to implement an emergency stop mechanism.
156  */
157 contract Pausable is Governable {
158 
159   bool public paused = true;
160 
161   /**
162    * @dev modifier to allow actions only when the contract IS paused
163    */
164   modifier whenNotPaused() {
165     require(!paused);
166     _;
167   }
168 
169   /**
170    * @dev modifier to allow actions only when the contract IS NOT paused
171    */
172   modifier whenPaused() {
173     require(paused);
174     _;
175   }
176 
177   /**
178    * @dev called by the owner to pause, triggers stopped state
179    */
180   function pause() onlyAdmins whenNotPaused {
181     paused = true;
182   }
183 
184   /**
185    * @dev called by the owner to unpause, returns to normal state
186    */
187   function unpause() onlyAdmins whenPaused {
188     //TODO: do some checks
189     paused = false;
190   }
191 
192 }
193 
194 
195 /*
196  * ERC20Basic
197  * Simpler version of ERC20 interface
198  * see https://github.com/ethereum/EIPs/issues/20
199  */
200 contract ERC20Basic {
201   function totalSupply() constant returns (uint256);
202   function balanceOf(address _owner) constant returns (uint256);
203   function transfer(address _to, uint256 _value) returns (bool);
204   event Transfer(address indexed from, address indexed to, uint value);
205 }
206 
207 contract ERC223Basic is ERC20Basic {
208     function transfer(address to, uint value, bytes data) returns (bool);
209 }
210 
211 /*
212  * ERC20 interface
213  * see https://github.com/ethereum/EIPs/issues/20
214  */
215 contract ERC20 is ERC223Basic {
216   // active supply of tokens
217   function activeSupply() constant returns (uint256);
218   function allowance(address _owner, address _spender) constant returns (uint256);
219   function transferFrom(address _from, address _to, uint _value) returns (bool);
220   function approve(address _spender, uint256 _value);
221   event Approval(address indexed owner, address indexed spender, uint256 value);
222 }
223 /**
224  * @title Ownable
225  * @dev The Ownable contract has an owner address, and provides basic authorization control
226  * functions, this simplifies the implementation of "user permissions".
227  */
228 contract Ownable {
229   address public owner;
230 
231 
232   /**
233    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
234    * account.
235    */
236   function Ownable() {
237     owner = msg.sender;
238   }
239 
240 
241   /**
242    * @dev Throws if called by any account other than the owner.
243    */
244   modifier onlyOwner() {
245     require(msg.sender == owner);
246     _;
247   }
248 
249 
250   /**
251    * @dev Allows the current owner to transfer control of the contract to a newOwner.
252    * @param newOwner The address to transfer ownership to.
253    */
254   function transferOwnership(address newOwner) onlyOwner {
255     require(newOwner != address(0));      
256     owner = newOwner;
257   }
258 
259 }
260 
261 contract Power is Ownable, ERC20Basic {
262 
263   event Slashing(address indexed holder, uint value, bytes32 data);
264 
265   string public name = "Acebusters Power";
266   string public symbol = "ABP";
267   uint256 public decimals = 12;
268 
269 
270   function balanceOf(address _holder) constant returns (uint256) {
271     return ControllerInterface(owner).powerBalanceOf(_holder);
272   }
273 
274   function totalSupply() constant returns (uint256) {
275     return ControllerInterface(owner).powerTotalSupply();
276   }
277 
278   function activeSupply() constant returns (uint256) {
279     return ControllerInterface(owner).outstandingPower();
280   }
281 
282 
283   // ############################################
284   // ########### ADMIN FUNCTIONS ################
285   // ############################################
286 
287   function slashPower(address _holder, uint256 _value, bytes32 _data) public onlyOwner {
288     Slashing(_holder, _value, _data);
289   }
290 
291   function powerUp(address _holder, uint256 _value) public onlyOwner {
292     // NTZ transfered from user's balance to power pool
293     Transfer(address(0), _holder, _value);
294   }
295 
296   // ############################################
297   // ########### PUBLIC FUNCTIONS ###############
298   // ############################################
299 
300   // registers a powerdown request
301   function transfer(address _to, uint256 _amountPower) public returns (bool success) {
302     // make Power not transferable
303     require(_to == address(0));
304     ControllerInterface(owner).createDownRequest(msg.sender, _amountPower);
305     Transfer(msg.sender, address(0), _amountPower);
306     return true;
307   }
308 
309   function downtime() public returns (uint256) {
310     ControllerInterface(owner).downtime;
311   }
312 
313   function downTick(address _owner) public {
314     ControllerInterface(owner).downTick(_owner, now);
315   }
316 
317   function downs(address _owner) constant public returns (uint256, uint256, uint256) {
318     return ControllerInterface(owner).downs(_owner);
319   }
320 
321 }
322 
323 
324 contract Storage is Ownable {
325     struct Crate {
326         mapping(bytes32 => uint256) uints;
327         mapping(bytes32 => address) addresses;
328         mapping(bytes32 => bool) bools;
329         mapping(address => uint256) bals;
330     }
331 
332     mapping(bytes32 => Crate) crates;
333 
334     function setUInt(bytes32 _crate, bytes32 _key, uint256 _value) onlyOwner {
335         crates[_crate].uints[_key] = _value;
336     }
337 
338     function getUInt(bytes32 _crate, bytes32 _key) constant returns(uint256) {
339         return crates[_crate].uints[_key];
340     }
341 
342     function setAddress(bytes32 _crate, bytes32 _key, address _value) onlyOwner {
343         crates[_crate].addresses[_key] = _value;
344     }
345 
346     function getAddress(bytes32 _crate, bytes32 _key) constant returns(address) {
347         return crates[_crate].addresses[_key];
348     }
349 
350     function setBool(bytes32 _crate, bytes32 _key, bool _value) onlyOwner {
351         crates[_crate].bools[_key] = _value;
352     }
353 
354     function getBool(bytes32 _crate, bytes32 _key) constant returns(bool) {
355         return crates[_crate].bools[_key];
356     }
357 
358     function setBal(bytes32 _crate, address _key, uint256 _value) onlyOwner {
359         crates[_crate].bals[_key] = _value;
360     }
361 
362     function getBal(bytes32 _crate, address _key) constant returns(uint256) {
363         return crates[_crate].bals[_key];
364     }
365 }
366 
367 
368 contract NutzEnabled is Pausable, StorageEnabled {
369   using SafeMath for uint;
370 
371   // satelite contract addresses
372   address public nutzAddr;
373 
374 
375   modifier onlyNutz() {
376     require(msg.sender == nutzAddr);
377     _;
378   }
379 
380   function NutzEnabled(address _nutzAddr, address _storageAddr)
381     StorageEnabled(_storageAddr) {
382     nutzAddr = _nutzAddr;
383   }
384 
385   // ############################################
386   // ########### NUTZ FUNCTIONS  ################
387   // ############################################
388 
389   // total supply(modified for etherscan display)
390   function totalSupply() constant returns (uint256) {
391     return activeSupply();
392   }
393 
394   // total supply(for internal calculations)
395   function completeSupply() constant returns (uint256) {
396     return activeSupply().add(powerPool()).add(burnPool());
397   }
398 
399   // allowances according to ERC20
400   // not written to storage, as not very critical
401   mapping (address => mapping (address => uint)) internal allowed;
402 
403   function allowance(address _owner, address _spender) constant returns (uint256) {
404     return allowed[_owner][_spender];
405   }
406 
407   function approve(address _owner, address _spender, uint256 _amountBabz) public onlyNutz whenNotPaused {
408     require(_owner != _spender);
409     allowed[_owner][_spender] = _amountBabz;
410   }
411 
412   function _transfer(address _from, address _to, uint256 _amountBabz, bytes _data) internal {
413     require(_to != address(this));
414     require(_to != address(0));
415     require(_amountBabz > 0);
416     require(_from != _to);
417     _setBabzBalanceOf(_from, babzBalanceOf(_from).sub(_amountBabz));
418     _setBabzBalanceOf(_to, babzBalanceOf(_to).add(_amountBabz));
419   }
420 
421   function transfer(address _from, address _to, uint256 _amountBabz, bytes _data) public onlyNutz whenNotPaused {
422     _transfer(_from, _to, _amountBabz, _data);
423   }
424 
425   function transferFrom(address _sender, address _from, address _to, uint256 _amountBabz, bytes _data) public onlyNutz whenNotPaused {
426     allowed[_from][_sender] = allowed[_from][_sender].sub(_amountBabz);
427     _transfer(_from, _to, _amountBabz, _data);
428   }
429 
430 }
431 
432 
433 
434 
435  /*
436  * Contract that is working with ERC223 tokens
437  */
438  
439 contract ERC223ReceivingContract {
440     function tokenFallback(address _from, uint _value, bytes _data);
441 }
442 
443 
444 contract ControllerInterface {
445 
446 
447   // State Variables
448   bool public paused;
449   address public nutzAddr;
450 
451   // Nutz functions
452   function babzBalanceOf(address _owner) constant returns (uint256);
453   function activeSupply() constant returns (uint256);
454   function burnPool() constant returns (uint256);
455   function powerPool() constant returns (uint256);
456   function totalSupply() constant returns (uint256);
457   function completeSupply() constant returns (uint256);
458   function allowance(address _owner, address _spender) constant returns (uint256);
459 
460   function approve(address _owner, address _spender, uint256 _amountBabz) public;
461   function transfer(address _from, address _to, uint256 _amountBabz, bytes _data) public;
462   function transferFrom(address _sender, address _from, address _to, uint256 _amountBabz, bytes _data) public;
463 
464   // Market functions
465   function floor() constant returns (uint256);
466   function ceiling() constant returns (uint256);
467 
468   function purchase(address _sender, uint256 _value, uint256 _price) public returns (uint256);
469   function sell(address _from, uint256 _price, uint256 _amountBabz);
470 
471   // Power functions
472   function powerBalanceOf(address _owner) constant returns (uint256);
473   function outstandingPower() constant returns (uint256);
474   function authorizedPower() constant returns (uint256);
475   function powerTotalSupply() constant returns (uint256);
476 
477   function powerUp(address _sender, address _from, uint256 _amountBabz) public;
478   function downTick(address _owner, uint256 _now) public;
479   function createDownRequest(address _owner, uint256 _amountPower) public;
480   function downs(address _owner) constant public returns(uint256, uint256, uint256);
481   function downtime() constant returns (uint256);
482 }
483 
484 
485 /**
486  * @title PullPayment
487  * @dev Base contract supporting async send for pull payments.
488  */
489 contract PullPayment is Ownable {
490   using SafeMath for uint256;
491 
492 
493   uint public dailyLimit = 1000000000000000000000;  // 1 ETH
494   uint public lastDay;
495   uint public spentToday;
496 
497   // 8bytes date, 24 bytes value
498   mapping(address => uint256) internal payments;
499 
500   modifier onlyNutz() {
501     require(msg.sender == ControllerInterface(owner).nutzAddr());
502     _;
503   }
504 
505   modifier whenNotPaused () {
506     require(!ControllerInterface(owner).paused());
507      _;
508   }
509 
510   function balanceOf(address _owner) constant returns (uint256 value) {
511     return uint192(payments[_owner]);
512   }
513 
514   function paymentOf(address _owner) constant returns (uint256 value, uint256 date) {
515     value = uint192(payments[_owner]);
516     date = (payments[_owner] >> 192);
517     return;
518   }
519 
520   /// @dev Allows to change the daily limit. Transaction has to be sent by wallet.
521   /// @param _dailyLimit Amount in wei.
522   function changeDailyLimit(uint _dailyLimit) public onlyOwner {
523       dailyLimit = _dailyLimit;
524   }
525 
526   function changeWithdrawalDate(address _owner, uint256 _newDate)  public onlyOwner {
527     // allow to withdraw immediately
528     // move witdrawal date more days into future
529     payments[_owner] = (_newDate << 192) + uint192(payments[_owner]);
530   }
531 
532   function asyncSend(address _dest) public payable onlyNutz {
533     require(msg.value > 0);
534     uint256 newValue = msg.value.add(uint192(payments[_dest]));
535     uint256 newDate;
536     if (isUnderLimit(msg.value)) {
537       uint256 date = payments[_dest] >> 192;
538       newDate = (date > now) ? date : now;
539     } else {
540       newDate = now.add(3 days);
541     }
542     spentToday = spentToday.add(msg.value);
543     payments[_dest] = (newDate << 192) + uint192(newValue);
544   }
545 
546 
547   function withdraw() public whenNotPaused {
548     address untrustedRecipient = msg.sender;
549     uint256 amountWei = uint192(payments[untrustedRecipient]);
550 
551     require(amountWei != 0);
552     require(now >= (payments[untrustedRecipient] >> 192));
553     require(this.balance >= amountWei);
554 
555     payments[untrustedRecipient] = 0;
556 
557     assert(untrustedRecipient.call.gas(1000).value(amountWei)());
558   }
559 
560   /*
561    * Internal functions
562    */
563   /// @dev Returns if amount is within daily limit and resets spentToday after one day.
564   /// @param amount Amount to withdraw.
565   /// @return Returns if amount is under daily limit.
566   function isUnderLimit(uint amount) internal returns (bool) {
567     if (now > lastDay.add(24 hours)) {
568       lastDay = now;
569       spentToday = 0;
570     }
571     // not using safe math because we don't want to throw;
572     if (spentToday + amount > dailyLimit || spentToday + amount < spentToday) {
573       return false;
574     }
575     return true;
576   }
577 
578 }
579 
580 
581 /**
582  * Nutz implements a price floor and a price ceiling on the token being
583  * sold. It is based of the zeppelin token contract.
584  */
585 contract Nutz is Ownable, ERC20 {
586 
587   event Sell(address indexed seller, uint256 value);
588 
589   string public name = "Acebusters Nutz";
590   // acebusters units:
591   // 10^12 - Nutz   (NTZ)
592   // 10^9 - Jonyz
593   // 10^6 - Helcz
594   // 10^3 - Pascalz
595   // 10^0 - Babz
596   string public symbol = "NTZ";
597   uint256 public decimals = 12;
598 
599   // returns balances of active holders
600   function balanceOf(address _owner) constant returns (uint) {
601     return ControllerInterface(owner).babzBalanceOf(_owner);
602   }
603 
604   function totalSupply() constant returns (uint256) {
605     return ControllerInterface(owner).totalSupply();
606   }
607 
608   function activeSupply() constant returns (uint256) {
609     return ControllerInterface(owner).activeSupply();
610   }
611 
612   // return remaining allowance
613   // if calling return allowed[address(this)][_spender];
614   // returns balance of ether parked to be withdrawn
615   function allowance(address _owner, address _spender) constant returns (uint256) {
616     return ControllerInterface(owner).allowance(_owner, _spender);
617   }
618 
619   // returns either the salePrice, or if reserve does not suffice
620   // for active supply, returns maxFloor
621   function floor() constant returns (uint256) {
622     return ControllerInterface(owner).floor();
623   }
624 
625   // returns either the salePrice, or if reserve does not suffice
626   // for active supply, returns maxFloor
627   function ceiling() constant returns (uint256) {
628     return ControllerInterface(owner).ceiling();
629   }
630 
631   function powerPool() constant returns (uint256) {
632     return ControllerInterface(owner).powerPool();
633   }
634 
635 
636   function _checkDestination(address _from, address _to, uint256 _value, bytes _data) internal {
637     // erc223: Retrieve the size of the code on target address, this needs assembly .
638     uint256 codeLength;
639     assembly {
640       codeLength := extcodesize(_to)
641     }
642     if(codeLength>0) {
643       ERC223ReceivingContract untrustedReceiver = ERC223ReceivingContract(_to);
644       // untrusted contract call
645       untrustedReceiver.tokenFallback(_from, _value, _data);
646     }
647   }
648 
649 
650 
651   // ############################################
652   // ########### ADMIN FUNCTIONS ################
653   // ############################################
654 
655   function powerDown(address powerAddr, address _holder, uint256 _amountBabz) public onlyOwner {
656     bytes memory empty;
657     _checkDestination(powerAddr, _holder, _amountBabz, empty);
658     // NTZ transfered from power pool to user's balance
659     Transfer(powerAddr, _holder, _amountBabz);
660   }
661 
662 
663   function asyncSend(address _pullAddr, address _dest, uint256 _amountWei) public onlyOwner {
664     assert(_amountWei <= this.balance);
665     PullPayInterface(_pullAddr).asyncSend.value(_amountWei)(_dest);
666   }
667 
668 
669   // ############################################
670   // ########### PUBLIC FUNCTIONS ###############
671   // ############################################
672 
673   function approve(address _spender, uint256 _amountBabz) public {
674     ControllerInterface(owner).approve(msg.sender, _spender, _amountBabz);
675     Approval(msg.sender, _spender, _amountBabz);
676   }
677 
678   function transfer(address _to, uint256 _amountBabz, bytes _data) public returns (bool) {
679     ControllerInterface(owner).transfer(msg.sender, _to, _amountBabz, _data);
680     Transfer(msg.sender, _to, _amountBabz);
681     _checkDestination(msg.sender, _to, _amountBabz, _data);
682     return true;
683   }
684 
685   function transfer(address _to, uint256 _amountBabz) public returns (bool) {
686     bytes memory empty;
687     return transfer(_to, _amountBabz, empty);
688   }
689 
690   function transData(address _to, uint256 _amountBabz, bytes _data) public returns (bool) {
691     return transfer(_to, _amountBabz, _data);
692   }
693 
694   function transferFrom(address _from, address _to, uint256 _amountBabz, bytes _data) public returns (bool) {
695     ControllerInterface(owner).transferFrom(msg.sender, _from, _to, _amountBabz, _data);
696     Transfer(_from, _to, _amountBabz);
697     _checkDestination(_from, _to, _amountBabz, _data);
698     return true;
699   }
700 
701   function transferFrom(address _from, address _to, uint256 _amountBabz) public returns (bool) {
702     bytes memory empty;
703     return transferFrom(_from, _to, _amountBabz, empty);
704   }
705 
706   function () public payable {
707     uint256 price = ControllerInterface(owner).ceiling();
708     purchase(price);
709     require(msg.value > 0);
710   }
711 
712   function purchase(uint256 _price) public payable {
713     require(msg.value > 0);
714     uint256 amountBabz = ControllerInterface(owner).purchase(msg.sender, msg.value, _price);
715     Transfer(owner, msg.sender, amountBabz);
716     bytes memory empty;
717     _checkDestination(address(this), msg.sender, amountBabz, empty);
718   }
719 
720   function sell(uint256 _price, uint256 _amountBabz) public {
721     require(_amountBabz != 0);
722     ControllerInterface(owner).sell(msg.sender, _price, _amountBabz);
723     Sell(msg.sender, _amountBabz);
724   }
725 
726   function powerUp(uint256 _amountBabz) public {
727     Transfer(msg.sender, owner, _amountBabz);
728     ControllerInterface(owner).powerUp(msg.sender, msg.sender, _amountBabz);
729   }
730 
731 }
732 
733 
734 contract MarketEnabled is NutzEnabled {
735 
736   uint256 constant INFINITY = 0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
737 
738   // address of the pull payemnt satelite
739   address public pullAddr;
740 
741   // the Token sale mechanism parameters:
742   // purchasePrice is the number of NTZ received for purchase with 1 ETH
743   uint256 internal purchasePrice;
744 
745   // floor is the number of NTZ needed, to receive 1 ETH in sell
746   uint256 internal salePrice;
747 
748   function MarketEnabled(address _pullAddr, address _storageAddr, address _nutzAddr)
749     NutzEnabled(_nutzAddr, _storageAddr) {
750     pullAddr = _pullAddr;
751   }
752 
753 
754   function ceiling() constant returns (uint256) {
755     return purchasePrice;
756   }
757 
758   // returns either the salePrice, or if reserve does not suffice
759   // for active supply, returns maxFloor
760   function floor() constant returns (uint256) {
761     if (nutzAddr.balance == 0) {
762       return INFINITY;
763     }
764     uint256 maxFloor = activeSupply().mul(1000000).div(nutzAddr.balance); // 1,000,000 WEI, used as price factor
765     // return max of maxFloor or salePrice
766     return maxFloor >= salePrice ? maxFloor : salePrice;
767   }
768 
769   function moveCeiling(uint256 _newPurchasePrice) public onlyAdmins {
770     require(_newPurchasePrice <= salePrice);
771     purchasePrice = _newPurchasePrice;
772   }
773 
774   function moveFloor(uint256 _newSalePrice) public onlyAdmins {
775     require(_newSalePrice >= purchasePrice);
776     // moveFloor fails if the administrator tries to push the floor so low
777     // that the sale mechanism is no longer able to buy back all tokens at
778     // the floor price if those funds were to be withdrawn.
779     if (_newSalePrice < INFINITY) {
780       require(nutzAddr.balance >= activeSupply().mul(1000000).div(_newSalePrice)); // 1,000,000 WEI, used as price factor
781     }
782     salePrice = _newSalePrice;
783   }
784 
785   function purchase(address _sender, uint256 _value, uint256 _price) public onlyNutz whenNotPaused returns (uint256) {
786     // disable purchases if purchasePrice set to 0
787     require(purchasePrice > 0);
788     require(_price == purchasePrice);
789 
790     uint256 amountBabz = purchasePrice.mul(_value).div(1000000); // 1,000,000 WEI, used as price factor
791     // avoid deposits that issue nothing
792     // might happen with very high purchase price
793     require(amountBabz > 0);
794 
795     // make sure power pool grows proportional to economy
796     uint256 activeSup = activeSupply();
797     uint256 powPool = powerPool();
798     if (powPool > 0) {
799       uint256 powerShare = powPool.mul(amountBabz).div(activeSup.add(burnPool()));
800       _setPowerPool(powPool.add(powerShare));
801     }
802     _setActiveSupply(activeSup.add(amountBabz));
803     _setBabzBalanceOf(_sender, babzBalanceOf(_sender).add(amountBabz));
804     return amountBabz;
805   }
806 
807   function sell(address _from, uint256 _price, uint256 _amountBabz) public onlyNutz whenNotPaused {
808     uint256 effectiveFloor = floor();
809     require(_amountBabz != 0);
810     require(effectiveFloor != INFINITY);
811     require(_price == effectiveFloor);
812 
813     uint256 amountWei = _amountBabz.mul(1000000).div(effectiveFloor);  // 1,000,000 WEI, used as price factor
814     require(amountWei > 0);
815     // make sure power pool shrinks proportional to economy
816     uint256 powPool = powerPool();
817     uint256 activeSup = activeSupply();
818     if (powPool > 0) {
819       uint256 powerShare = powPool.mul(_amountBabz).div(activeSup.add(burnPool()));
820       _setPowerPool(powPool.sub(powerShare));
821     }
822     _setActiveSupply(activeSup.sub(_amountBabz));
823     _setBabzBalanceOf(_from, babzBalanceOf(_from).sub(_amountBabz));
824     Nutz(nutzAddr).asyncSend(pullAddr, _from, amountWei);
825   }
826 
827 
828   // withdraw excessive reserve - i.e. milestones
829   function allocateEther(uint256 _amountWei, address _beneficiary) public onlyAdmins {
830     require(_amountWei > 0);
831     // allocateEther fails if allocating those funds would mean that the
832     // sale mechanism is no longer able to buy back all tokens at the floor
833     // price if those funds were to be withdrawn.
834     require(nutzAddr.balance.sub(_amountWei) >= activeSupply().mul(1000000).div(salePrice)); // 1,000,000 WEI, used as price factor
835     Nutz(nutzAddr).asyncSend(pullAddr, _beneficiary, _amountWei);
836   }
837 
838 }
839 
840 
841 contract PowerEnabled is MarketEnabled {
842 
843   // satelite contract addresses
844   address public powerAddr;
845 
846   // maxPower is a limit of total power that can be outstanding
847   // maxPower has a valid value between outstandingPower and authorizedPow/2
848   uint256 public maxPower = 0;
849 
850   // time it should take to power down
851   uint256 public downtime;
852 
853   uint public constant MIN_SHARE_OF_POWER = 100000;
854 
855   modifier onlyPower() {
856     require(msg.sender == powerAddr);
857     _;
858   }
859 
860   function PowerEnabled(address _powerAddr, address _pullAddr, address _storageAddr, address _nutzAddr)
861     MarketEnabled(_pullAddr, _nutzAddr, _storageAddr) {
862     powerAddr = _powerAddr;
863   }
864 
865   function setMaxPower(uint256 _maxPower) public onlyAdmins {
866     require(outstandingPower() <= _maxPower && _maxPower < authorizedPower());
867     maxPower = _maxPower;
868   }
869 
870   function setDowntime(uint256 _downtime) public onlyAdmins {
871     downtime = _downtime;
872   }
873 
874   function minimumPowerUpSizeBabz() public constant returns (uint256) {
875     uint256 completeSupplyBabz = completeSupply();
876     if (completeSupplyBabz == 0) {
877       return INFINITY;
878     }
879     return completeSupplyBabz.div(MIN_SHARE_OF_POWER);
880   }
881 
882   // this is called when NTZ are deposited into the burn pool
883   function dilutePower(uint256 _amountBabz, uint256 _amountPower) public onlyAdmins {
884     uint256 authorizedPow = authorizedPower();
885     uint256 totalBabz = completeSupply();
886     if (authorizedPow == 0) {
887       // during the first capital increase, set value directly as authorized shares
888       _setAuthorizedPower((_amountPower > 0) ? _amountPower : _amountBabz.add(totalBabz));
889     } else {
890       // in later increases, expand authorized shares at same rate like economy
891       _setAuthorizedPower(authorizedPow.mul(totalBabz.add(_amountBabz)).div(totalBabz));
892     }
893     _setBurnPool(burnPool().add(_amountBabz));
894   }
895 
896   function _slashPower(address _holder, uint256 _value, bytes32 _data) internal {
897     uint256 previouslyOutstanding = outstandingPower();
898     _setOutstandingPower(previouslyOutstanding.sub(_value));
899     // adjust size of power pool
900     uint256 powPool = powerPool();
901     uint256 slashingBabz = _value.mul(powPool).div(previouslyOutstanding);
902     _setPowerPool(powPool.sub(slashingBabz));
903     // put event into satelite contract
904     Power(powerAddr).slashPower(_holder, _value, _data);
905   }
906 
907   function slashPower(address _holder, uint256 _value, bytes32 _data) public onlyAdmins {
908     _setPowerBalanceOf(_holder, powerBalanceOf(_holder).sub(_value));
909     _slashPower(_holder, _value, _data);
910   }
911 
912   function slashDownRequest(uint256 _pos, address _holder, uint256 _value, bytes32 _data) public onlyAdmins {
913     var (total, left, start) = downs(_holder);
914     left = left.sub(_value);
915     _setDownRequest(_holder, total, left, start);
916     _slashPower(_holder, _value, _data);
917   }
918 
919   // this is called when NTZ are deposited into the power pool
920   function powerUp(address _sender, address _from, uint256 _amountBabz) public onlyNutz whenNotPaused {
921     uint256 authorizedPow = authorizedPower();
922     require(authorizedPow != 0);
923     require(_amountBabz != 0);
924     uint256 totalBabz = completeSupply();
925     require(totalBabz != 0);
926     uint256 amountPow = _amountBabz.mul(authorizedPow).div(totalBabz);
927     // check pow limits
928     uint256 outstandingPow = outstandingPower();
929     require(outstandingPow.add(amountPow) <= maxPower);
930     uint256 powBal = powerBalanceOf(_from).add(amountPow);
931     require(powBal >= authorizedPow.div(MIN_SHARE_OF_POWER));
932 
933     if (_sender != _from) {
934       allowed[_from][_sender] = allowed[_from][_sender].sub(_amountBabz);
935     }
936 
937     _setOutstandingPower(outstandingPow.add(amountPow));
938     _setPowerBalanceOf(_from, powBal);
939     _setActiveSupply(activeSupply().sub(_amountBabz));
940     _setBabzBalanceOf(_from, babzBalanceOf(_from).sub(_amountBabz));
941     _setPowerPool(powerPool().add(_amountBabz));
942     Power(powerAddr).powerUp(_from, amountPow);
943   }
944 
945   function powerTotalSupply() constant returns (uint256) {
946     uint256 issuedPower = authorizedPower().div(2);
947     // return max of maxPower or issuedPower
948     return maxPower >= issuedPower ? maxPower : issuedPower;
949   }
950 
951   function _vestedDown(uint256 _total, uint256 _left, uint256 _start, uint256 _now) internal constant returns (uint256) {
952     if (_now <= _start) {
953       return 0;
954     }
955     // calculate amountVested
956     // amountVested is amount that can be withdrawn according to time passed
957     uint256 timePassed = _now.sub(_start);
958     if (timePassed > downtime) {
959      timePassed = downtime;
960     }
961     uint256 amountVested = _total.mul(timePassed).div(downtime);
962     uint256 amountFrozen = _total.sub(amountVested);
963     if (_left <= amountFrozen) {
964       return 0;
965     }
966     return _left.sub(amountFrozen);
967   }
968 
969   function createDownRequest(address _owner, uint256 _amountPower) public onlyPower whenNotPaused {
970     // prevent powering down tiny amounts
971     // when powering down, at least completeSupply/minShare Power should be claimed
972     require(_amountPower >= authorizedPower().div(MIN_SHARE_OF_POWER));
973     _setPowerBalanceOf(_owner, powerBalanceOf(_owner).sub(_amountPower));
974 
975     var (, left, ) = downs(_owner);
976     uint256 total = _amountPower.add(left);
977     _setDownRequest(_owner, total, total, now);
978   }
979 
980   // executes a powerdown request
981   function downTick(address _holder, uint256 _now) public onlyPower whenNotPaused {
982     var (total, left, start) = downs(_holder);
983     uint256 amountPow = _vestedDown(total, left, start, _now);
984 
985     // prevent power down in tiny steps
986     uint256 minStep = total.div(10);
987     require(left <= minStep || minStep <= amountPow);
988 
989     // calculate token amount representing share of power
990     uint256 amountBabz = amountPow.mul(completeSupply()).div(authorizedPower());
991 
992     // transfer power and tokens
993     _setOutstandingPower(outstandingPower().sub(amountPow));
994     left = left.sub(amountPow);
995     _setPowerPool(powerPool().sub(amountBabz));
996     _setActiveSupply(activeSupply().add(amountBabz));
997     _setBabzBalanceOf(_holder, babzBalanceOf(_holder).add(amountBabz));
998     // down request completed
999     if (left == 0) {
1000       start = 0;
1001       total = 0;
1002     }
1003     // TODO
1004     _setDownRequest(_holder, total, left, start);
1005     Nutz(nutzAddr).powerDown(powerAddr, _holder, amountBabz);
1006   }
1007 }
1008 
1009 
1010 /**
1011  * @title SafeMath
1012  * @dev Math operations with safety checks that throw on error
1013  */
1014 library SafeMath {
1015   function mul(uint256 a, uint256 b) internal returns (uint256) {
1016     uint256 c = a * b;
1017     assert(a == 0 || c / a == b);
1018     return c;
1019   }
1020 
1021   function div(uint256 a, uint256 b) internal returns (uint256) {
1022     // assert(b > 0); // Solidity automatically throws when dividing by 0
1023     uint256 c = a / b;
1024     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1025     return c;
1026   }
1027 
1028   function sub(uint256 a, uint256 b) internal returns (uint256) {
1029     assert(b <= a);
1030     return a - b;
1031   }
1032 
1033   function add(uint256 a, uint256 b) internal returns (uint256) {
1034     uint256 c = a + b;
1035     assert(c >= a);
1036     return c;
1037   }
1038 }
1039 
1040 
1041 
1042 
1043 
1044 contract Controller is PowerEnabled {
1045 
1046   function Controller(address _powerAddr, address _pullAddr, address _nutzAddr, address _storageAddr) 
1047     PowerEnabled(_powerAddr, _pullAddr, _nutzAddr, _storageAddr) {
1048   }
1049 
1050   function setContracts(address _storageAddr, address _nutzAddr, address _powerAddr, address _pullAddr) public onlyAdmins whenPaused {
1051     storageAddr = _storageAddr;
1052     nutzAddr = _nutzAddr;
1053     powerAddr = _powerAddr;
1054     pullAddr = _pullAddr;
1055   }
1056 
1057   function changeDailyLimit(uint256 _dailyLimit) public onlyAdmins {
1058     PullPayment(pullAddr).changeDailyLimit(_dailyLimit);
1059   }
1060 
1061   function kill(address _newController) public onlyAdmins whenPaused {
1062     if (powerAddr != address(0)) { Ownable(powerAddr).transferOwnership(msg.sender); }
1063     if (pullAddr != address(0)) { Ownable(pullAddr).transferOwnership(msg.sender); }
1064     if (nutzAddr != address(0)) { Ownable(nutzAddr).transferOwnership(msg.sender); }
1065     if (storageAddr != address(0)) { Ownable(storageAddr).transferOwnership(msg.sender); }
1066     selfdestruct(_newController);
1067   }
1068 
1069 }
1070 
1071 contract UpgradeEventCompact {
1072   using SafeMath for uint;
1073 
1074   // states
1075   //  - verifying, initial state
1076   //  - controlling, after verifying, before complete
1077   //  - complete, after controlling
1078   enum EventState { Verifying, Complete }
1079   EventState public state;
1080 
1081   // Terms
1082   address public nextController;
1083   address public oldController;
1084   address public council;
1085 
1086   // Params
1087   address nextPullPayment;
1088   address storageAddr;
1089   address nutzAddr;
1090   address powerAddr;
1091   uint256 maxPower;
1092   uint256 downtime;
1093   uint256 purchasePrice;
1094   uint256 salePrice;
1095 
1096   function UpgradeEventCompact(address _oldController, address _nextController, address _nextPullPayment) {
1097     state = EventState.Verifying;
1098     nextController = _nextController;
1099     oldController = _oldController;
1100     nextPullPayment = _nextPullPayment; //the ownership of this satellite should be with oldController
1101     council = msg.sender;
1102   }
1103 
1104   modifier isState(EventState _state) {
1105     require(state == _state);
1106     _;
1107   }
1108 
1109   function upgrade() isState(EventState.Verifying) {
1110     // check old controller
1111     var old = Controller(oldController);
1112     old.pause();
1113     require(old.admins(1) == address(this));
1114     require(old.paused() == true);
1115     // check next controller
1116     var next = Controller(nextController);
1117     require(next.admins(1) == address(this));
1118     require(next.paused() == true);
1119     // kill old one, and transfer ownership
1120     // transfer ownership of payments and storage to here
1121     storageAddr = old.storageAddr();
1122     nutzAddr = old.nutzAddr();
1123     powerAddr = old.powerAddr();
1124     maxPower = old.maxPower();
1125     downtime = old.downtime();
1126     purchasePrice = old.ceiling();
1127     salePrice = old.floor();
1128     uint newPowerPool = (old.outstandingPower()).mul(old.activeSupply().add(old.burnPool())).div(old.authorizedPower().sub(old.outstandingPower()));
1129     //set pull payment contract in old controller
1130     old.setContracts(powerAddr, nextPullPayment, nutzAddr, storageAddr);
1131     // kill old controller, sending all ETH to new controller
1132     old.kill(nextController);
1133     // transfer ownership of Nutz/Power contracts to next controller
1134     Ownable(nutzAddr).transferOwnership(nextController);
1135     Ownable(powerAddr).transferOwnership(nextController);
1136     // transfer ownership of storage to next controller
1137     Storage(storageAddr).setUInt('Nutz', 'powerPool', newPowerPool);
1138     Ownable(storageAddr).transferOwnership(nextController);
1139     // if intended, transfer ownership of pull payment account
1140     Ownable(nextPullPayment).transferOwnership(nextController);
1141     // resume next controller
1142     if (maxPower > 0) {
1143       next.setMaxPower(maxPower);
1144     }
1145     next.setDowntime(downtime);
1146     next.moveFloor(salePrice);
1147     next.moveCeiling(purchasePrice);
1148     next.unpause();
1149     // remove access
1150     next.removeAdmin(address(this));
1151     // set state
1152     state = EventState.Complete;
1153   }
1154 
1155 }