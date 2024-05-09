1 pragma solidity ^0.4.19;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
13     if (a == 0) {
14       return 0;
15     }
16     uint256 c = a * b;
17     assert(c / a == b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 a, uint256 b) internal pure returns (uint256) {
25     // assert(b > 0); // Solidity automatically throws when dividing by 0
26     uint256 c = a / b;
27     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28     return c;
29   }
30 
31   /**
32   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35     assert(b <= a);
36     return a - b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 a, uint256 b) internal pure returns (uint256) {
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
60   function Ownable() public {
61     owner = msg.sender;
62   }
63 
64   /**
65    * @dev Throws if called by any account other than the owner.
66    */
67   modifier onlyOwner() {
68     require(msg.sender == owner);
69     _;
70   }
71 
72   /**
73    * @dev Allows the current owner to transfer control of the contract to a newOwner.
74    * @param newOwner The address to transfer ownership to.
75    */
76   function transferOwnership(address newOwner) public onlyOwner {
77     require(newOwner != address(0));
78     OwnershipTransferred(owner, newOwner);
79     owner = newOwner;
80   }
81 
82 }
83 
84 /**
85  * @title RefundVault
86  * @dev This contract is used for storing funds while a crowdsale
87  * is in progress. Supports refunding the money if crowdsale fails,
88  * and forwarding it if crowdsale is successful.
89  */
90 contract RefundVault is Ownable {
91   using SafeMath for uint256;
92 
93   enum State { Active, Refunding, Closed }
94 
95   mapping (address => uint256) public deposited;
96   address public wallet;
97   State public state;
98 
99   event Closed();
100   event RefundsEnabled();
101   event Refunded(address indexed beneficiary, uint256 weiAmount);
102 
103   /**
104    * @param _wallet Vault address
105    */
106   function RefundVault(address _wallet) public {
107     require(_wallet != address(0));
108     wallet = _wallet;
109     state = State.Active;
110   }
111 
112   /**
113    * @param investor Investor address
114    */
115   function deposit(address investor) onlyOwner public payable {
116     require(state == State.Active);
117     deposited[investor] = deposited[investor].add(msg.value);
118   }
119 
120   function close() onlyOwner public {
121     require(state == State.Active);
122     state = State.Closed;
123     Closed();
124     wallet.transfer(this.balance);
125   }
126 
127   function enableRefunds() onlyOwner public {
128     require(state == State.Active);
129     state = State.Refunding;
130     RefundsEnabled();
131   }
132 
133   /**
134    * @param investor Investor address
135    */
136   function refund(address investor) public {
137     require(state == State.Refunding);
138     uint256 depositedValue = deposited[investor];
139     deposited[investor] = 0;
140     investor.transfer(depositedValue);
141     Refunded(investor, depositedValue);
142   }
143 }
144 
145 contract ERC20Basic {
146   function totalSupply() public view returns (uint256);
147   function balanceOf(address who) public view returns (uint256);
148   function transfer(address to, uint256 value) public returns (bool);
149   event Transfer(address indexed from, address indexed to, uint256 value);
150 }
151 
152 contract ERC20 is ERC20Basic {
153   function allowance(address owner, address spender) public view returns (uint256);
154   function transferFrom(address from, address to, uint256 value) public returns (bool);
155   function approve(address spender, uint256 value) public returns (bool);
156   event Approval(address indexed owner, address indexed spender, uint256 value);
157 }
158 
159 contract ACAToken is ERC20 {
160     using SafeMath for uint256;
161 
162     address public owner;
163     address public admin;
164 
165     string public name = "ACA Network Token";
166     string public symbol = "ACA";
167     uint8 public decimals = 18;
168 
169     uint256 totalSupply_;
170     mapping (address => mapping (address => uint256)) internal allowed;
171     mapping (address => uint256) balances;
172 
173     bool transferable = false;
174     mapping (address => bool) internal transferLocked;
175 
176     event Genesis(address owner, uint256 value);
177     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
178     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
179     event Burn(address indexed burner, uint256 value);
180     event LogAddress(address indexed addr);
181     event LogUint256(uint256 value);
182     event TransferLock(address indexed target, bool value);
183 
184     // modifiers
185     modifier onlyOwner() {
186         require(msg.sender == owner);
187         _;
188     }
189 
190     modifier onlyAdmin() {
191         require(msg.sender == owner || msg.sender == admin);
192         _;
193     }
194 
195     modifier canTransfer(address _from, address _to) {
196         require(_to != address(0x0));
197         require(_to != address(this));
198 
199         if ( _from != owner && _from != admin ) {
200             require(transferable);
201             require (!transferLocked[_from]);
202         }
203         _;
204     }
205 
206     // constructor
207     function ACAToken(uint256 _totalSupply, address _newAdmin) public {
208         require(_totalSupply > 0);
209         require(_newAdmin != address(0x0));
210         require(_newAdmin != msg.sender);
211 
212         owner = msg.sender;
213         admin = _newAdmin;
214 
215         totalSupply_ = _totalSupply;
216 
217         balances[owner] = totalSupply_;
218         approve(admin, totalSupply_);
219         emit Genesis(owner, totalSupply_);
220     }
221 
222     // permission related
223     function transferOwnership(address newOwner) public onlyOwner {
224         require(newOwner != address(0));
225         require(newOwner != admin);
226 
227         owner = newOwner;
228         emit OwnershipTransferred(owner, newOwner);
229     }
230 
231     function transferAdmin(address _newAdmin) public onlyOwner {
232         require(_newAdmin != address(0));
233         require(_newAdmin != address(this));
234         require(_newAdmin != owner);
235 
236         admin = _newAdmin;
237         emit AdminTransferred(admin, _newAdmin);
238     }
239 
240     function setTransferable(bool _transferable) public onlyAdmin {
241         transferable = _transferable;
242     }
243 
244     function isTransferable() public view returns (bool) {
245         return transferable;
246     }
247 
248     function transferLock() public returns (bool) {
249         transferLocked[msg.sender] = true;
250         emit TransferLock(msg.sender, true);
251         return true;
252     }
253 
254     function manageTransferLock(address _target, bool _value) public onlyOwner returns (bool) {
255         transferLocked[_target] = _value;
256         emit TransferLock(_target, _value);
257         return true;
258     }
259 
260     function transferAllowed(address _target) public view returns (bool) {
261         return (transferable && transferLocked[_target] == false);
262     }
263 
264     // token related
265     function totalSupply() public view returns (uint256) {
266         return totalSupply_;
267     }
268 
269     function transfer(address _to, uint256 _value) canTransfer(msg.sender, _to) public returns (bool) {
270         require(_value <= balances[msg.sender]);
271 
272         // SafeMath.sub will throw if there is not enough balance.
273         balances[msg.sender] = balances[msg.sender].sub(_value);
274         balances[_to] = balances[_to].add(_value);
275         emit Transfer(msg.sender, _to, _value);
276         return true;
277     }
278 
279     function balanceOf(address _owner) public view returns (uint256 balance) {
280         return balances[_owner];
281     }
282 
283     function balanceOfOwner() public view returns (uint256 balance) {
284         return balances[owner];
285     }
286 
287     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to) returns (bool) {
288         require(_value <= balances[_from]);
289         require(_value <= allowed[_from][msg.sender]);
290 
291         balances[_from] = balances[_from].sub(_value);
292         balances[_to] = balances[_to].add(_value);
293         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
294         emit Transfer(_from, _to, _value);
295         return true;
296     }
297 
298     function approve(address _spender, uint256 _value) public canTransfer(msg.sender, _spender) returns (bool) {
299         allowed[msg.sender][_spender] = _value;
300         emit Approval(msg.sender, _spender, _value);
301         return true;
302     }
303 
304     function allowance(address _owner, address _spender) public view returns (uint256) {
305         return allowed[_owner][_spender];
306     }
307 
308     function increaseApproval(address _spender, uint _addedValue) public canTransfer(msg.sender, _spender) returns (bool) {
309         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
310         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
311         return true;
312     }
313 
314     function decreaseApproval(address _spender, uint _subtractedValue) public canTransfer(msg.sender, _spender) returns (bool) {
315         uint oldValue = allowed[msg.sender][_spender];
316         if (_subtractedValue > oldValue) {
317             allowed[msg.sender][_spender] = 0;
318         } else {
319             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
320         }
321         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
322         return true;
323     }
324 
325     function burn(uint256 _value) public {
326         require(_value <= balances[msg.sender]);
327         // no need to require value <= totalSupply, since that would imply the
328         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
329 
330         address burner = msg.sender;
331         balances[burner] = balances[burner].sub(_value);
332         totalSupply_ = totalSupply_.sub(_value);
333         emit Burn(burner, _value);
334     }
335 
336     function emergencyERC20Drain(ERC20 _token, uint256 _amount) public onlyOwner {
337         _token.transfer(owner, _amount);
338     }
339 }
340 
341 contract ACATokenSale {
342     using SafeMath for uint256;
343 
344     address public owner;
345     address public admin;
346 
347     address public wallet;
348     ACAToken public token;
349 
350     uint256 totalSupply;
351 
352     struct StageInfo {
353         uint256 opening;
354         uint256 closing;
355         uint256 capacity;
356         uint256 minimumWei;
357         uint256 maximumWei;
358         uint256 rate;
359         uint256 sold;
360     }
361     bool public tokenSaleEnabled = false;
362 
363     mapping(address => bool) public whitelist;
364     mapping(address => bool) public kyclist;
365     mapping(address => bool) public whitelistBonus;
366 
367     uint256 public whitelistBonusClosingTime;
368     uint256 public whitelistBonusSent = 0;
369     uint256 public whitelistBonusRate;
370     uint256 public whitelistBonusAmount;
371 
372     mapping (address => uint256) public sales;
373     uint256 public softCap;
374     uint256 public hardCap;
375     uint256 public weiRaised = 0;
376 
377     RefundVault public vault;
378 
379     mapping (address => address) public referrals;
380     uint256 public referralAmount;
381     uint256 public referralRateInviter;
382     uint256 public referralRateInvitee;
383     uint256 public referralSent = 0;
384     bool public referralDone = false;
385 
386     mapping (address => uint256) public bounties;
387     uint256 public bountyAmount;
388     uint256 public bountySent = 0;
389 
390     StageInfo[] public stages;
391     uint256 public currentStage = 0;
392     uint256 public maxStage = 0;
393 
394     bool public isFinalized = false;
395 
396     // events
397     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
398     event TokenSaleCreated(address indexed wallet, uint256 totalSupply);
399     event StageAdded(uint256 openingTime, uint256 closingTime, uint256 capacity, uint256 minimumWei, uint256 maximumWei, uint256 rate);
400     event TokenSaleEnabled();
401 
402     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
403     event TokenClaimed(address indexed beneficiary, uint256 amount);
404     event Finalized();
405     event BountySetupDone();
406     event BountyUpdated(address indexed target, bool flag, uint256 amount);
407     event PurchaseReferral(address indexed beneficiary, uint256 amount);
408     event StageUpdated(uint256 stage);
409     event StageCapReached(uint256 stage);
410     event ReferralCapReached();
411 
412     // do not use this on mainnet!
413     event LogAddress(address indexed addr);
414     event LogUint256(uint256 value);
415 
416     // modifiers
417     modifier onlyOwner() {
418         require(msg.sender == owner);
419         _;
420     }
421 
422     modifier onlyAdmin() {
423         require(msg.sender == owner || msg.sender == admin);
424         _;
425     }
426 
427     modifier onlyWhileOpen {
428         require(tokenSaleEnabled == true);
429         require(now >= stages[currentStage].opening && now <= stages[currentStage].closing);
430         _;
431     }
432 
433     modifier isVerified(address _beneficiary) {
434         require(whitelist[_beneficiary] == true);
435         require(kyclist[_beneficiary] == true);
436         _;
437     }
438 
439     modifier claimable {
440         require(isFinalized == true);
441         require(isGoalReached());
442         _;
443     }
444 
445     // getters
446     function isEnabled() public view returns (bool) {
447         return tokenSaleEnabled;
448     }
449 
450     function isClosed() public view returns (bool) {
451         return now > stages[maxStage - 1].closing;
452     }
453 
454     function isGoalReached() public view returns (bool) {
455         return getTotalTokenSold() >= softCap;
456     }
457 
458     function getTotalTokenSold() public view returns (uint256) {
459         uint256 sold = 0;
460         for ( uint i = 0; i < maxStage; ++i ) {
461             sold = sold.add(stages[i].sold);
462         }
463 
464         return sold;
465     }
466 
467     function getOpeningTime() public view returns (uint256) {
468         return stages[currentStage].opening;
469     }
470 
471     function getOpeningTimeByStage(uint _index) public view returns (uint256) {
472         require(_index < maxStage);
473         return stages[_index].opening;
474     }
475 
476     function getClosingTime() public view returns (uint256) {
477         return stages[currentStage].closing;
478     }
479 
480     function getClosingTimeByStage(uint _index) public view returns (uint256) {
481         require(_index < maxStage);
482         return stages[_index].closing;
483     }
484 
485     function getCurrentCapacity() public view returns (uint256) {
486         return stages[currentStage].capacity;
487     }
488 
489     function getCapacity(uint _index) public view returns (uint256) {
490         require(_index < maxStage);
491         return stages[_index].capacity;
492     }
493 
494     function getCurrentSold() public view returns (uint256) {
495         return stages[currentStage].sold;
496     }
497 
498     function getSold(uint _index) public view returns (uint256) {
499         require(_index < maxStage);
500         return stages[_index].sold;
501     }
502 
503     function getCurrentRate() public view returns (uint256) {
504         return stages[currentStage].rate;
505     }
506 
507     function getRate(uint _index) public view returns (uint256) {
508         require(_index < maxStage);
509         return stages[_index].rate;
510     }
511 
512     function getRateWithoutBonus() public view returns (uint256) {
513         return stages[maxStage - 1].rate;
514     }
515 
516     function getSales(address _beneficiary) public view returns (uint256) {
517         return sales[_beneficiary];
518     }
519     
520     // setter
521     function setSalePeriod(uint _index, uint256 _openingTime, uint256 _closingTime) onlyOwner public {
522         require(_openingTime > now);
523         require(_closingTime > _openingTime);
524 
525         require(_index > currentStage);
526         require(_index < stages.length);
527 
528         stages[_index].opening = _openingTime;        
529         stages[_index].closing = _closingTime;        
530     }
531 
532     function setRate(uint _index, uint256 _rate) onlyOwner public {
533         require(_index > currentStage);
534         require(_index < stages.length);
535 
536         require(_rate > 0);
537 
538         stages[_index].rate = _rate;
539     }
540 
541     
542     // permission
543     function setAdmin(address _newAdmin) public onlyOwner {
544         require(_newAdmin != address(0x0));
545         require(_newAdmin != address(this));
546         require(_newAdmin != owner);
547 
548         admin = _newAdmin;
549     }
550 
551     function transferOwnership(address newOwner) public onlyOwner {
552         require(newOwner != address(0));
553         emit OwnershipTransferred(owner, newOwner);
554         owner = newOwner;
555     }
556 
557     // constructor
558     function ACATokenSale(
559         address _wallet, 
560         uint256 _totalSupply,
561         uint256 _softCap,
562         uint256 _hardCap,
563         address _admin) public {
564         owner = msg.sender;
565 
566         require(_admin != address(0));
567         require(_wallet != address(0));
568 
569         require(_totalSupply > 0);
570         require(_softCap > 0);
571         require(_hardCap > _softCap);
572 
573         admin = _admin;
574         wallet = _wallet;
575 
576         totalSupply = _totalSupply;
577         softCap = _softCap;
578         hardCap = _hardCap;
579 
580         emit TokenSaleCreated(wallet, _totalSupply);
581     }
582 
583     // state related
584     function setupBounty(
585         uint256 _referralAmount,
586         uint256 _referralRateInviter,
587         uint256 _referralRateInvitee,
588         uint256 _bountyAmount,
589         uint256 _whitelistBonusClosingTime,
590         uint256 _whitelistBonusRate,
591         uint256 _whitelistBonusAmount
592     ) onlyOwner public {
593         
594         require(_referralAmount > 0);
595 
596         require(_referralRateInviter > 0 && _referralRateInviter < 100);
597         require(_referralRateInvitee > 0 && _referralRateInvitee < 100);
598 
599         require(_whitelistBonusClosingTime > now);
600         require(_whitelistBonusRate > 0);
601         require(_whitelistBonusAmount > _whitelistBonusRate);
602         require(_bountyAmount > 0);
603 
604         referralAmount = _referralAmount;
605         referralRateInviter = _referralRateInviter;
606         referralRateInvitee = _referralRateInvitee;
607         bountyAmount = _bountyAmount;
608         whitelistBonusClosingTime = _whitelistBonusClosingTime;
609         whitelistBonusRate = _whitelistBonusRate;
610         whitelistBonusAmount = _whitelistBonusAmount;
611 
612         emit BountySetupDone();
613     }
614     function addStage(
615         uint256 _openingTime, 
616         uint256 _closingTime, 
617         uint256 _capacity, 
618         uint256 _minimumWei, 
619         uint256 _maximumWei, 
620         uint256 _rate) onlyOwner public {
621         require(tokenSaleEnabled == false);
622 
623         require(_openingTime > now);
624         require(_closingTime > _openingTime);
625 
626         require(_capacity > 0);
627         require(_capacity < hardCap);
628 
629         require(_minimumWei > 0);
630         require(_maximumWei >= _minimumWei);
631 
632         require(_rate > 0);
633 
634         require(_minimumWei.mul(_rate) < _capacity);
635         require(_maximumWei.mul(_rate) < _capacity);
636         if ( stages.length > 0 ) {
637             StageInfo memory prevStage = stages[stages.length - 1];
638             require(_openingTime > prevStage.closing);
639         }
640 
641         stages.push(StageInfo(_openingTime, _closingTime, _capacity, _minimumWei, _maximumWei, _rate, 0));
642         emit StageAdded(_openingTime, _closingTime, _capacity, _minimumWei, _maximumWei, _rate);
643     }
644 
645     function setToken(ACAToken _token) onlyOwner public {
646         token = _token;
647     }
648 
649     function enableTokenSale() onlyOwner public returns (bool) {
650         require(stages.length > 0);
651         maxStage = stages.length;
652 
653         tokenSaleEnabled = true;
654 
655         vault = new RefundVault(wallet);
656 
657         emit TokenSaleEnabled();
658 
659         return true;
660     }
661 
662     function updateStage() public returns (uint256) {
663         require(tokenSaleEnabled == true);
664         require(currentStage < maxStage);
665         require(now >= stages[currentStage].opening);
666 
667         uint256 remains = stages[currentStage].capacity.sub(stages[currentStage].sold);
668         if ( now > stages[currentStage].closing ) {
669             uint256 nextStage = currentStage.add(1);
670             if ( remains > 0 && nextStage < maxStage ) {
671                 stages[nextStage].capacity = stages[nextStage].capacity.add(remains);
672                 remains = stages[nextStage].capacity;
673             }
674 
675             currentStage = nextStage;
676             emit StageUpdated(nextStage);
677         }
678 
679         return remains;
680     }
681 
682     function finalize() onlyOwner public {
683         require(isFinalized == false);
684         require(isClosed());
685 
686         finalization();
687         emit Finalized();
688 
689         isFinalized = true;
690     }
691 
692     function finalization() internal {
693         if (isGoalReached()) {
694             vault.close();
695             // token.setTransferable(true);
696         } else {
697             vault.enableRefunds();
698         }
699     }
700 
701     // transaction
702     function () external payable {
703         buyTokens(msg.sender);
704     }
705 
706     function buyTokens(address _beneficiary) public payable {
707         uint256 weiAmount = msg.value;
708 
709         _preValidatePurchase(_beneficiary, weiAmount);
710         // calculate token amount to be created
711         uint256 tokens = _getTokenAmount(weiAmount);
712 
713         // update state
714         weiRaised = weiRaised.add(weiAmount);
715 
716         _processPurchase(_beneficiary, tokens);
717         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
718 
719         _updatePurchasingState(_beneficiary, weiAmount);
720 
721         _forwardFunds();
722         _postValidatePurchase(_beneficiary, weiAmount);
723     }
724 
725     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
726         return _weiAmount.mul(getCurrentRate());
727     }
728 
729     function _getTokenAmountWithoutBonus(uint256 _weiAmount) internal view returns (uint256) {
730         return _weiAmount.mul(getRateWithoutBonus());
731     }
732 
733     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isVerified(_beneficiary) {
734         require(_beneficiary != address(0));
735         require(_weiAmount != 0);
736 
737         require(tokenSaleEnabled == true);
738 
739         require(now >= stages[currentStage].opening);
740 
741         // lazy execution
742         uint256 remains = updateStage();
743 
744         require(currentStage < maxStage);
745         require(now >= stages[currentStage].opening && now <= stages[currentStage].closing);
746 
747         require(_weiAmount >= stages[currentStage].minimumWei);
748         require(_weiAmount <= stages[currentStage].maximumWei);
749 
750         uint256 amount = _getTokenAmount(_weiAmount);
751 
752         require(remains > amount);
753     }
754 
755     function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
756         if ( getCurrentSold() == getCurrentCapacity() ) {
757             currentStage = currentStage.add(1);
758             emit StageUpdated(currentStage);
759         }
760     }
761 
762     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
763         sales[_beneficiary] = sales[_beneficiary].add(_tokenAmount);
764     }
765 
766     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
767 
768         stages[currentStage].sold = stages[currentStage].sold.add(_tokenAmount);
769         _deliverTokens(_beneficiary, _tokenAmount);
770 
771         uint256 weiAmount = msg.value;
772         address inviter = referrals[_beneficiary];
773         if ( inviter != address(0x0) && referralDone == false ) {
774             uint256 baseRate = _getTokenAmountWithoutBonus(weiAmount);
775             uint256 referralAmountInviter = baseRate.div(100).mul(referralRateInviter);
776             uint256 referralAmountInvitee = baseRate.div(100).mul(referralRateInvitee);
777             uint256 referralRemains = referralAmount.sub(referralSent);
778             if ( referralRemains == 0 ) {
779                 referralDone = true;
780             }
781             else {
782                 if ( referralAmountInviter >= referralRemains ) {
783                     referralAmountInviter = referralRemains;
784                     referralAmountInvitee = 0; // priority to inviter
785                     emit ReferralCapReached();
786                     referralDone = true;
787                 }
788                 if ( referralDone == false && referralAmountInviter >= referralRemains ) {
789                     referralAmountInvitee = referralRemains.sub(referralAmountInviter);
790                     emit ReferralCapReached();
791                     referralDone = true;
792                 }
793 
794                 uint256 referralAmountTotal = referralAmountInviter.add(referralAmountInvitee);
795                 referralSent = referralSent.add(referralAmountTotal);
796 
797                 if ( referralAmountInviter > 0 ) {
798                     _deliverTokens(inviter, referralAmountInviter);
799                     emit PurchaseReferral(inviter, referralAmountInviter);
800                 }
801                 if ( referralAmountInvitee > 0 ) {
802                     _deliverTokens(_beneficiary, referralAmountInvitee);
803                     emit PurchaseReferral(_beneficiary, referralAmountInvitee);
804                 }
805             }
806         }
807     }
808 
809     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
810         // optional override
811     }
812 
813     function _forwardFunds() internal {
814         vault.deposit.value(msg.value)(msg.sender);
815     }
816 
817     // claim
818     function claimToken() public claimable isVerified(msg.sender) returns (bool) {
819         address beneficiary = msg.sender;
820         uint256 amount = sales[beneficiary];
821 
822         emit TokenClaimed(beneficiary, amount);
823 
824         sales[beneficiary] = 0;
825         return token.transferFrom(owner, beneficiary, amount);
826     }
827 
828     function claimRefund() isVerified(msg.sender) public {
829         require(isFinalized == true);
830         require(!isGoalReached());
831 
832         vault.refund(msg.sender);
833     }
834 
835     function claimBountyToken() public claimable isVerified(msg.sender) returns (bool) {
836         address beneficiary = msg.sender;
837         uint256 amount = bounties[beneficiary];
838 
839         emit TokenClaimed(beneficiary, amount);
840 
841         bounties[beneficiary] = 0;
842         return token.transferFrom(owner, beneficiary, amount);
843     }
844 
845     // bounty
846     function addBounty(address _address, uint256 _amount) public onlyAdmin isVerified(_address) returns (bool) {
847         require(bountyAmount.sub(bountySent) >= _amount);
848 
849         bountySent = bountySent.add(_amount);
850         bounties[_address] = bounties[_address].add(_amount);
851         emit BountyUpdated(_address, true, _amount);
852     }
853     function delBounty(address _address, uint256 _amount) public onlyAdmin isVerified(_address) returns (bool) {
854         require(bounties[_address] >= _amount);
855         require(_amount >= bountySent);
856 
857         bountySent = bountySent.sub(_amount);
858         bounties[_address] = bounties[_address].sub(_amount);
859         emit BountyUpdated(_address, false, _amount);
860     }
861     function getBountyAmount(address _address) public view returns (uint256) {
862         return bounties[_address];
863     }
864 
865     // referral
866     function addReferral(address _inviter, address _invitee) public onlyAdmin isVerified(_inviter) isVerified(_invitee) returns (bool) {
867         referrals[_invitee] = _inviter;
868     }
869     function delReferral(address _inviter, address _invitee) public onlyAdmin isVerified(_inviter) isVerified(_invitee) returns (bool) {
870         delete referrals[_invitee];
871     }
872     function getReferral(address _address) public view returns (address) {
873         return referrals[_address];
874     }
875 
876     // whitelist
877     function _deliverWhitelistBonus(address _beneficiary) internal {
878         if ( _beneficiary == address(0x0) ) {
879             return;
880         }
881 
882         if ( whitelistBonus[_beneficiary] == true ) {
883             return;
884         }
885         
886         if (whitelistBonusAmount.sub(whitelistBonusSent) > whitelistBonusRate ) {
887             whitelistBonus[_beneficiary] = true;
888 
889             whitelistBonusSent = whitelistBonusSent.add(whitelistBonusRate);
890             bounties[_beneficiary] = bounties[_beneficiary].add(whitelistBonusRate);
891             emit BountyUpdated(_beneficiary, true, whitelistBonusRate);
892         }
893     }
894     function isAccountWhitelisted(address _beneficiary) public view returns (bool) {
895         return whitelist[_beneficiary];
896     }
897 
898     function addToWhitelist(address _beneficiary) external onlyAdmin {
899         whitelist[_beneficiary] = true;
900 
901         if ( whitelistBonus[_beneficiary] == false && now < whitelistBonusClosingTime ) {
902             _deliverWhitelistBonus(_beneficiary);
903         }
904     }
905 
906     function addManyToWhitelist(address[] _beneficiaries) external onlyAdmin {
907         uint256 i = 0;
908         if ( now < whitelistBonusClosingTime ) {
909             for (i = 0; i < _beneficiaries.length; i++) {
910                 whitelist[_beneficiaries[i]] = true;
911                 _deliverWhitelistBonus(_beneficiaries[i]);
912             }
913             return;
914         }
915 
916         for (i = 0; i < _beneficiaries.length; i++) {
917             whitelist[_beneficiaries[i]] = true;
918         }
919     }
920 
921     function removeFromWhitelist(address _beneficiary) external onlyAdmin {
922         whitelist[_beneficiary] = false;
923     }
924 
925     // kyc
926     function isAccountVerified(address _beneficiary) public view returns (bool) {
927         return kyclist[_beneficiary];
928     }
929 
930     function setAccountVerified(address _beneficiary) external onlyAdmin {
931         kyclist[_beneficiary] = true;
932     }
933 
934     function setManyAccountsVerified(address[] _beneficiaries) external onlyAdmin {
935         for (uint256 i = 0; i < _beneficiaries.length; i++) {
936             kyclist[_beneficiaries[i]] = true;
937         }
938     }
939 
940     function unverifyAccount(address _beneficiary) external onlyAdmin {
941         kyclist[_beneficiary] = false;
942     }
943 }