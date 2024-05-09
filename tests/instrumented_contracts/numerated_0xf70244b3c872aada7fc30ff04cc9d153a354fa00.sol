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
164     address public saleAddress;
165 
166     string public name = "ACA Network Token";
167     string public symbol = "ACA";
168     uint8 public decimals = 18;
169 
170     uint256 totalSupply_;
171     mapping (address => mapping (address => uint256)) internal allowed;
172     mapping (address => uint256) balances;
173 
174     bool transferable = false;
175     mapping (address => bool) internal transferLocked;
176 
177     event Genesis(address owner, uint256 value);
178     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
179     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
180     event Burn(address indexed burner, uint256 value);
181     event LogAddress(address indexed addr);
182     event LogUint256(uint256 value);
183     event TransferLock(address indexed target, bool value);
184 
185     // modifiers
186     modifier onlyOwner() {
187         require(msg.sender == owner);
188         _;
189     }
190 
191     modifier onlyAdmin() {
192         require(msg.sender == owner || msg.sender == admin);
193         _;
194     }
195 
196     modifier canTransfer(address _from, address _to) {
197         require(_to != address(0x0));
198         require(_to != address(this));
199 
200         if ( _from != owner && _from != admin ) {
201             require(transferable);
202             require (!transferLocked[_from]);
203         }
204         _;
205     }
206 
207     // constructor
208     function ACAToken(uint256 _totalSupply, address _saleAddress, address _admin) public {
209         require(_totalSupply > 0);
210         owner = msg.sender;
211         require(_saleAddress != address(0x0));
212         require(_saleAddress != address(this));
213         require(_saleAddress != owner);
214 
215         require(_admin != address(0x0));
216         require(_admin != address(this));
217         require(_admin != owner);
218 
219         require(_admin != _saleAddress);
220 
221         admin = _admin;
222         saleAddress = _saleAddress;
223 
224         totalSupply_ = _totalSupply;
225 
226         balances[owner] = totalSupply_;
227         approve(saleAddress, totalSupply_);
228 
229         emit Genesis(owner, totalSupply_);
230     }
231 
232     // permission related
233     function transferOwnership(address newOwner) public onlyOwner {
234         require(newOwner != address(0));
235         require(newOwner != address(this));
236         require(newOwner != admin);
237 
238         owner = newOwner;
239         emit OwnershipTransferred(owner, newOwner);
240     }
241 
242     function transferAdmin(address _newAdmin) public onlyOwner {
243         require(_newAdmin != address(0));
244         require(_newAdmin != address(this));
245         require(_newAdmin != owner);
246 
247         admin = _newAdmin;
248         emit AdminTransferred(admin, _newAdmin);
249     }
250 
251     function setTransferable(bool _transferable) public onlyAdmin {
252         transferable = _transferable;
253     }
254 
255     function isTransferable() public view returns (bool) {
256         return transferable;
257     }
258 
259     function transferLock() public returns (bool) {
260         transferLocked[msg.sender] = true;
261         emit TransferLock(msg.sender, true);
262         return true;
263     }
264 
265     function manageTransferLock(address _target, bool _value) public onlyAdmin returns (bool) {
266         transferLocked[_target] = _value;
267         emit TransferLock(_target, _value);
268         return true;
269     }
270 
271     function transferAllowed(address _target) public view returns (bool) {
272         return (transferable && transferLocked[_target] == false);
273     }
274 
275     // token related
276     function totalSupply() public view returns (uint256) {
277         return totalSupply_;
278     }
279 
280     function transfer(address _to, uint256 _value) canTransfer(msg.sender, _to) public returns (bool) {
281         require(_value <= balances[msg.sender]);
282 
283         // SafeMath.sub will throw if there is not enough balance.
284         balances[msg.sender] = balances[msg.sender].sub(_value);
285         balances[_to] = balances[_to].add(_value);
286         emit Transfer(msg.sender, _to, _value);
287         return true;
288     }
289 
290     function balanceOf(address _owner) public view returns (uint256 balance) {
291         return balances[_owner];
292     }
293 
294     function balanceOfOwner() public view returns (uint256 balance) {
295         return balances[owner];
296     }
297 
298     function transferFrom(address _from, address _to, uint256 _value) public canTransfer(_from, _to) returns (bool) {
299         require(_value <= balances[_from]);
300         require(_value <= allowed[_from][msg.sender]);
301 
302         balances[_from] = balances[_from].sub(_value);
303         balances[_to] = balances[_to].add(_value);
304         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
305         emit Transfer(_from, _to, _value);
306         return true;
307     }
308 
309     function approve(address _spender, uint256 _value) public canTransfer(msg.sender, _spender) returns (bool) {
310         allowed[msg.sender][_spender] = _value;
311         emit Approval(msg.sender, _spender, _value);
312         return true;
313     }
314 
315     function allowance(address _owner, address _spender) public view returns (uint256) {
316         return allowed[_owner][_spender];
317     }
318 
319     function increaseApproval(address _spender, uint _addedValue) public canTransfer(msg.sender, _spender) returns (bool) {
320         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
321         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
322         return true;
323     }
324 
325     function decreaseApproval(address _spender, uint _subtractedValue) public canTransfer(msg.sender, _spender) returns (bool) {
326         uint oldValue = allowed[msg.sender][_spender];
327         if (_subtractedValue > oldValue) {
328             allowed[msg.sender][_spender] = 0;
329         } else {
330             allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
331         }
332         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
333         return true;
334     }
335 
336     function burn(uint256 _value) public {
337         require(_value <= balances[msg.sender]);
338         // no need to require value <= totalSupply, since that would imply the
339         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
340 
341         address burner = msg.sender;
342         balances[burner] = balances[burner].sub(_value);
343         totalSupply_ = totalSupply_.sub(_value);
344         emit Burn(burner, _value);
345     }
346 
347     function emergencyERC20Drain(ERC20 _token, uint256 _amount) public onlyOwner {
348         _token.transfer(owner, _amount);
349     }
350 }
351 
352 contract ACATokenSale {
353     using SafeMath for uint256;
354 
355     address public owner;
356     address public admin;
357 
358     address public wallet;
359     ACAToken public token;
360 
361     uint256 totalSupply;
362 
363     struct StageInfo {
364         uint256 opening;
365         uint256 closing;
366         uint256 capacity;
367         uint256 minimumWei;
368         uint256 maximumWei;
369         uint256 rate;
370         uint256 sold;
371     }
372     bool public tokenSaleEnabled = false;
373 
374     mapping(address => bool) public whitelist;
375     mapping(address => bool) public kyclist;
376     mapping(address => bool) public whitelistBonus;
377 
378     uint256 public whitelistBonusClosingTime;
379     uint256 public whitelistBonusSent = 0;
380     uint256 public whitelistBonusRate;
381     uint256 public whitelistBonusAmount;
382 
383     mapping (address => uint256) public sales;
384     uint256 public softCap;
385     uint256 public hardCap;
386     uint256 public weiRaised = 0;
387 
388     RefundVault public vault;
389 
390     mapping (address => address) public referrals;
391     uint256 public referralAmount;
392     uint256 public referralRateInviter;
393     uint256 public referralRateInvitee;
394     uint256 public referralSent = 0;
395     bool public referralDone = false;
396 
397     mapping (address => uint256) public bounties;
398     uint256 public bountyAmount;
399     uint256 public bountySent = 0;
400 
401     StageInfo[] public stages;
402     uint256 public currentStage = 0;
403 
404     bool public isFinalized = false;
405     bool public isClaimable = false;
406 
407     // events
408     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
409     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
410     event TokenSaleCreated(address indexed wallet, uint256 totalSupply);
411     event StageAdded(uint256 openingTime, uint256 closingTime, uint256 capacity, uint256 minimumWei, uint256 maximumWei, uint256 rate);
412     event TokenSaleEnabled();
413 
414     event WhitelistUpdated(address indexed beneficiary, bool flag);
415     event VerificationUpdated(address indexed beneficiary, bool flag);
416     event BulkWhitelistUpdated(address[] beneficiary, bool flag);
417     event BulkVerificationUpdated(address[] beneficiary, bool flag);
418 
419     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
420     event TokenClaimed(address indexed beneficiary, uint256 amount);
421     event Finalized();
422     event BountySetupDone();
423     event BountyUpdated(address indexed target, bool flag, uint256 amount);
424     event PurchaseReferral(address indexed beneficiary, uint256 amount);
425     event StageUpdated(uint256 stage);
426     event StageCapReached(uint256 stage);
427     event ReferralCapReached();
428 
429     // do not use this on mainnet!
430     event LogAddress(address indexed addr);
431     event LogUint256(uint256 value);
432 
433     // modifiers
434     modifier onlyOwner() {
435         require(msg.sender == owner);
436         _;
437     }
438 
439     modifier onlyAdmin() {
440         require(msg.sender == owner || msg.sender == admin);
441         _;
442     }
443 
444     modifier onlyWhileOpen {
445         require(tokenSaleEnabled == true);
446         require(now >= stages[currentStage].opening && now <= stages[currentStage].closing);
447         _;
448     }
449 
450     modifier isVerified(address _beneficiary) {
451         require(whitelist[_beneficiary] == true);
452         require(kyclist[_beneficiary] == true);
453         _;
454     }
455 
456     modifier claimable {
457         require(isFinalized == true || isClaimable == true);
458         require(isGoalReached());
459         _;
460     }
461 
462     // getters
463     function isEnabled() public view returns (bool) {
464         return tokenSaleEnabled;
465     }
466 
467     function isClosed() public view returns (bool) {
468         return now > stages[stages.length - 1].closing;
469     }
470 
471     function isGoalReached() public view returns (bool) {
472         return getTotalTokenSold() >= softCap;
473     }
474 
475     function getTotalTokenSold() public view returns (uint256) {
476         uint256 sold = 0;
477         for ( uint i = 0; i < stages.length; ++i ) {
478             sold = sold.add(stages[i].sold);
479         }
480 
481         return sold;
482     }
483 
484     function getOpeningTime() public view returns (uint256) {
485         return stages[currentStage].opening;
486     }
487 
488     function getOpeningTimeByStage(uint _index) public view returns (uint256) {
489         require(_index < stages.length);
490         return stages[_index].opening;
491     }
492 
493     function getClosingTime() public view returns (uint256) {
494         return stages[currentStage].closing;
495     }
496 
497     function getClosingTimeByStage(uint _index) public view returns (uint256) {
498         require(_index < stages.length);
499         return stages[_index].closing;
500     }
501 
502     function getCurrentCapacity() public view returns (uint256) {
503         return stages[currentStage].capacity;
504     }
505 
506     function getCapacity(uint _index) public view returns (uint256) {
507         require(_index < stages.length);
508         return stages[_index].capacity;
509     }
510 
511     function getCurrentSold() public view returns (uint256) {
512         return stages[currentStage].sold;
513     }
514 
515     function getSold(uint _index) public view returns (uint256) {
516         require(_index < stages.length);
517         return stages[_index].sold;
518     }
519 
520     function getCurrentRate() public view returns (uint256) {
521         return stages[currentStage].rate;
522     }
523 
524     function getRate(uint _index) public view returns (uint256) {
525         require(_index < stages.length);
526         return stages[_index].rate;
527     }
528 
529     function getRateWithoutBonus() public view returns (uint256) {
530         return stages[stages.length - 1].rate;
531     }
532 
533     function getSales(address _beneficiary) public view returns (uint256) {
534         return sales[_beneficiary];
535     }
536     
537     // setter
538     function setSalePeriod(uint _index, uint256 _openingTime, uint256 _closingTime) onlyOwner public {
539         require(_openingTime > now);
540         require(_closingTime > _openingTime);
541 
542         require(_index > currentStage);
543         require(_index < stages.length);
544 
545         stages[_index].opening = _openingTime;        
546         stages[_index].closing = _closingTime;        
547     }
548 
549     function setRate(uint _index, uint256 _rate) onlyOwner public {
550         require(_index > currentStage);
551         require(_index < stages.length);
552 
553         require(_rate > 0);
554 
555         stages[_index].rate = _rate;
556     }
557 
558     function setCapacity(uint _index, uint256 _capacity) onlyOwner public {
559         require(_index > currentStage);
560         require(_index < stages.length);
561 
562         require(_capacity > 0);
563 
564         stages[_index].capacity = _capacity;
565     }
566 
567     function setClaimable(bool _claimable) onlyOwner public {
568         if ( _claimable == true ) {
569             require(isGoalReached());
570         }
571 
572         isClaimable = _claimable;
573     }
574 
575     function addPrivateSale(uint256 _amount) onlyOwner public {
576         require(currentStage == 0);
577         require(_amount > 0);
578         require(_amount < stages[0].capacity.sub(stages[0].sold));
579 
580         stages[0].sold = stages[0].sold.add(_amount);
581     }
582 
583     function subPrivateSale(uint256 _amount) onlyOwner public {
584         require(currentStage == 0);
585         require(_amount > 0);
586         require(stages[0].sold > _amount);
587 
588         stages[0].sold = stages[0].sold.sub(_amount);
589     }
590 
591     // permission
592     function setAdmin(address _newAdmin) public onlyOwner {
593         require(_newAdmin != address(0x0));
594         require(_newAdmin != address(this));
595         require(_newAdmin != owner);
596 
597         emit AdminTransferred(admin, _newAdmin);
598         admin = _newAdmin;
599     }
600 
601     function transferOwnership(address newOwner) public onlyOwner {
602         require(newOwner != address(0));
603         require(newOwner != address(this));
604         emit OwnershipTransferred(owner, newOwner);
605         owner = newOwner;
606     }
607 
608     // constructor
609     function ACATokenSale(
610         address _wallet, 
611         address _admin,
612         uint256 _totalSupply,
613         uint256 _softCap,
614         uint256 _hardCap) public {
615         owner = msg.sender;
616 
617         require(_admin != address(0));
618         require(_wallet != address(0));
619 
620         require(_totalSupply > 0);
621         require(_softCap > 0);
622         require(_hardCap > _softCap);
623 
624         admin = _admin;
625         wallet = _wallet;
626 
627         totalSupply = _totalSupply;
628         softCap = _softCap;
629         hardCap = _hardCap;
630 
631         emit TokenSaleCreated(wallet, _totalSupply);
632     }
633 
634     // state related
635     function setupBounty(
636         uint256 _referralAmount,
637         uint256 _referralRateInviter,
638         uint256 _referralRateInvitee,
639         uint256 _bountyAmount,
640         uint256 _whitelistBonusClosingTime,
641         uint256 _whitelistBonusRate,
642         uint256 _whitelistBonusAmount
643     ) onlyOwner public {
644         
645         require(_referralAmount > 0);
646 
647         require(_referralRateInviter > 0 && _referralRateInviter < 100);
648         require(_referralRateInvitee > 0 && _referralRateInvitee < 100);
649 
650         require(_whitelistBonusClosingTime > now);
651         require(_whitelistBonusRate > 0);
652         require(_whitelistBonusAmount > _whitelistBonusRate);
653         require(_bountyAmount > 0);
654 
655         referralAmount = _referralAmount;
656         referralRateInviter = _referralRateInviter;
657         referralRateInvitee = _referralRateInvitee;
658         bountyAmount = _bountyAmount;
659         whitelistBonusClosingTime = _whitelistBonusClosingTime;
660         whitelistBonusRate = _whitelistBonusRate;
661         whitelistBonusAmount = _whitelistBonusAmount;
662 
663         emit BountySetupDone();
664     }
665     function addStage(
666         uint256 _openingTime, 
667         uint256 _closingTime, 
668         uint256 _capacity, 
669         uint256 _minimumWei, 
670         uint256 _maximumWei, 
671         uint256 _rate) onlyOwner public {
672         require(tokenSaleEnabled == false);
673 
674         // require(_openingTime > now);
675         require(_closingTime > _openingTime);
676 
677         require(_capacity > 0);
678         require(_capacity < hardCap);
679 
680         require(_minimumWei > 0);
681         require(_maximumWei >= _minimumWei);
682 
683         require(_rate > 0);
684 
685         require(_minimumWei.mul(_rate) < _capacity);
686         require(_maximumWei.mul(_rate) < _capacity);
687         if ( stages.length > 0 ) {
688             StageInfo memory prevStage = stages[stages.length - 1];
689             require(_openingTime > prevStage.closing);
690         }
691 
692         stages.push(StageInfo(_openingTime, _closingTime, _capacity, _minimumWei, _maximumWei, _rate, 0));
693 
694         emit StageAdded(_openingTime, _closingTime, _capacity, _minimumWei, _maximumWei, _rate);
695     }
696 
697     function setToken(ACAToken _token) onlyOwner public {
698         token = _token;
699     }
700 
701     function enableTokenSale() onlyOwner public returns (bool) {
702         require(stages.length > 0);
703 
704         vault = new RefundVault(wallet);
705 
706         tokenSaleEnabled = true;
707         emit TokenSaleEnabled();
708         return true;
709     }
710 
711     function updateStage() public returns (uint256) {
712         require(tokenSaleEnabled == true);
713         require(currentStage < stages.length);
714         require(now >= stages[currentStage].opening);
715 
716         uint256 remains = stages[currentStage].capacity.sub(stages[currentStage].sold);
717         if ( now > stages[currentStage].closing ) {
718             uint256 nextStage = currentStage.add(1);
719             if ( remains > 0 && nextStage < stages.length ) {
720                 stages[nextStage].capacity = stages[nextStage].capacity.add(remains);
721                 remains = stages[nextStage].capacity;
722             }
723 
724             currentStage = nextStage;
725             emit StageUpdated(nextStage);
726         }
727 
728         return remains;
729     }
730 
731     function finalize() onlyOwner public {
732         require(isFinalized == false);
733         require(isClosed());
734 
735         finalization();
736         emit Finalized();
737 
738         isFinalized = true;
739     }
740 
741     function finalization() internal {
742         if (isGoalReached()) {
743             vault.close();
744         } else {
745             vault.enableRefunds();
746         }
747 
748     }
749 
750     // transaction
751     function () public payable {
752         buyTokens(msg.sender);
753     }
754 
755     function buyTokens(address _beneficiary) public payable {
756         uint256 weiAmount = msg.value;
757 
758         _preValidatePurchase(_beneficiary, weiAmount);
759         // calculate token amount to be created
760         uint256 tokens = _getTokenAmount(weiAmount);
761 
762         // update state
763         weiRaised = weiRaised.add(weiAmount);
764 
765         _processPurchase(_beneficiary, tokens);
766         emit TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
767 
768         _updatePurchasingState(_beneficiary, weiAmount);
769 
770         _forwardFunds();
771         _postValidatePurchase(_beneficiary, weiAmount);
772     }
773 
774     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
775         return _weiAmount.mul(getCurrentRate());
776     }
777 
778     function _getTokenAmountWithoutBonus(uint256 _weiAmount) internal view returns (uint256) {
779         return _weiAmount.mul(getRateWithoutBonus());
780     }
781 
782     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal isVerified(_beneficiary) {
783         require(_beneficiary != address(0));
784         require(_weiAmount != 0);
785 
786         require(tokenSaleEnabled == true);
787 
788         require(now >= stages[currentStage].opening);
789 
790         // lazy execution
791         uint256 remains = updateStage();
792 
793         require(currentStage < stages.length);
794         require(now >= stages[currentStage].opening && now <= stages[currentStage].closing);
795 
796         require(_weiAmount >= stages[currentStage].minimumWei);
797         require(_weiAmount <= stages[currentStage].maximumWei);
798 
799         uint256 amount = _getTokenAmount(_weiAmount);
800 
801         require(remains > amount);
802     }
803 
804     function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
805         if ( getCurrentSold() == getCurrentCapacity() ) {
806             currentStage = currentStage.add(1);
807             emit StageUpdated(currentStage);
808         }
809     }
810 
811     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
812         if ( isClaimable ) {
813             token.transferFrom(owner, _beneficiary, _tokenAmount);
814         }
815         else {
816             sales[_beneficiary] = sales[_beneficiary].add(_tokenAmount);
817         }
818     }
819 
820     function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
821 
822         stages[currentStage].sold = stages[currentStage].sold.add(_tokenAmount);
823         _deliverTokens(_beneficiary, _tokenAmount);
824 
825         uint256 weiAmount = msg.value;
826         address inviter = referrals[_beneficiary];
827         if ( inviter != address(0x0) && referralDone == false ) {
828             uint256 baseRate = _getTokenAmountWithoutBonus(weiAmount);
829             uint256 referralAmountInviter = baseRate.div(100).mul(referralRateInviter);
830             uint256 referralAmountInvitee = baseRate.div(100).mul(referralRateInvitee);
831             uint256 referralRemains = referralAmount.sub(referralSent);
832             if ( referralRemains == 0 ) {
833                 referralDone = true;
834             }
835             else {
836                 if ( referralAmountInviter >= referralRemains ) {
837                     referralAmountInviter = referralRemains;
838                     referralAmountInvitee = 0; // priority to inviter
839                     emit ReferralCapReached();
840                     referralDone = true;
841                 }
842                 if ( referralDone == false && referralAmountInviter >= referralRemains ) {
843                     referralAmountInvitee = referralRemains.sub(referralAmountInviter);
844                     emit ReferralCapReached();
845                     referralDone = true;
846                 }
847 
848                 uint256 referralAmountTotal = referralAmountInviter.add(referralAmountInvitee);
849                 referralSent = referralSent.add(referralAmountTotal);
850 
851                 if ( referralAmountInviter > 0 ) {
852                     _deliverTokens(inviter, referralAmountInviter);
853                     emit PurchaseReferral(inviter, referralAmountInviter);
854                 }
855                 if ( referralAmountInvitee > 0 ) {
856                     _deliverTokens(_beneficiary, referralAmountInvitee);
857                     emit PurchaseReferral(_beneficiary, referralAmountInvitee);
858                 }
859             }
860         }
861     }
862 
863     function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
864         // optional override
865     }
866 
867     function _forwardFunds() internal {
868         vault.deposit.value(msg.value)(msg.sender);
869     }
870 
871     // claim
872     function claimToken() public claimable isVerified(msg.sender) returns (bool) {
873         address beneficiary = msg.sender;
874         uint256 amount = sales[beneficiary];
875 
876         emit TokenClaimed(beneficiary, amount);
877 
878         sales[beneficiary] = 0;
879         return token.transferFrom(owner, beneficiary, amount);
880     }
881 
882     function claimRefund() isVerified(msg.sender) public {
883         require(isFinalized == true);
884         require(!isGoalReached());
885 
886         vault.refund(msg.sender);
887     }
888 
889     function claimBountyToken() public claimable isVerified(msg.sender) returns (bool) {
890         address beneficiary = msg.sender;
891         uint256 amount = bounties[beneficiary];
892 
893         emit TokenClaimed(beneficiary, amount);
894 
895         bounties[beneficiary] = 0;
896         return token.transferFrom(owner, beneficiary, amount);
897     }
898 
899     // bounty
900     function addBounty(address _address, uint256 _amount) public onlyAdmin isVerified(_address) returns (bool) {
901         require(bountyAmount.sub(bountySent) >= _amount);
902 
903         bountySent = bountySent.add(_amount);
904         bounties[_address] = bounties[_address].add(_amount);
905         emit BountyUpdated(_address, true, _amount);
906     }
907     function delBounty(address _address, uint256 _amount) public onlyAdmin isVerified(_address) returns (bool) {
908         require(bounties[_address] >= _amount);
909         require(_amount >= bountySent);
910 
911         bountySent = bountySent.sub(_amount);
912         bounties[_address] = bounties[_address].sub(_amount);
913         emit BountyUpdated(_address, false, _amount);
914     }
915     function getBountyAmount(address _address) public view returns (uint256) {
916         return bounties[_address];
917     }
918 
919     // referral
920     function addReferral(address _inviter, address _invitee) public onlyAdmin isVerified(_inviter) isVerified(_invitee) returns (bool) {
921         referrals[_invitee] = _inviter;
922     }
923     function delReferral(address _inviter, address _invitee) public onlyAdmin isVerified(_inviter) isVerified(_invitee) returns (bool) {
924         delete referrals[_invitee];
925     }
926     function getReferral(address _address) public view returns (address) {
927         return referrals[_address];
928     }
929 
930     // whitelist
931     function _deliverWhitelistBonus(address _beneficiary) internal {
932         if ( _beneficiary == address(0x0) ) {
933             return;
934         }
935 
936         if ( whitelistBonus[_beneficiary] == true ) {
937             return;
938         }
939         
940         if (whitelistBonusAmount.sub(whitelistBonusSent) > whitelistBonusRate ) {
941             whitelistBonus[_beneficiary] = true;
942 
943             whitelistBonusSent = whitelistBonusSent.add(whitelistBonusRate);
944             bounties[_beneficiary] = bounties[_beneficiary].add(whitelistBonusRate);
945             emit BountyUpdated(_beneficiary, true, whitelistBonusRate);
946         }
947     }
948     function isAccountWhitelisted(address _beneficiary) public view returns (bool) {
949         return whitelist[_beneficiary];
950     }
951 
952     function addToWhitelist(address _beneficiary) external onlyAdmin {
953         whitelist[_beneficiary] = true;
954 
955         if ( whitelistBonus[_beneficiary] == false && now < whitelistBonusClosingTime ) {
956             _deliverWhitelistBonus(_beneficiary);
957         }
958 
959         emit WhitelistUpdated(_beneficiary, true);
960     }
961 
962     function addManyToWhitelist(address[] _beneficiaries) external onlyAdmin {
963         uint256 i = 0;
964         if ( now < whitelistBonusClosingTime ) {
965             for (i = 0; i < _beneficiaries.length; i++) {
966                 whitelist[_beneficiaries[i]] = true;
967                 _deliverWhitelistBonus(_beneficiaries[i]);
968             }
969             return;
970         }
971 
972         for (i = 0; i < _beneficiaries.length; i++) {
973             whitelist[_beneficiaries[i]] = true;
974         }
975 
976         emit BulkWhitelistUpdated(_beneficiaries, true);
977     }
978 
979     function removeFromWhitelist(address _beneficiary) external onlyAdmin {
980         whitelist[_beneficiary] = false;
981 
982         emit WhitelistUpdated(_beneficiary, false);
983     }
984 
985     // kyc
986     function isAccountVerified(address _beneficiary) public view returns (bool) {
987         return kyclist[_beneficiary];
988     }
989 
990     function setAccountVerified(address _beneficiary) external onlyAdmin {
991         kyclist[_beneficiary] = true;
992 
993         emit VerificationUpdated(_beneficiary, true);
994     }
995 
996     function setManyAccountsVerified(address[] _beneficiaries) external onlyAdmin {
997         for (uint256 i = 0; i < _beneficiaries.length; i++) {
998             kyclist[_beneficiaries[i]] = true;
999         }
1000 
1001         emit BulkVerificationUpdated(_beneficiaries, true);
1002     }
1003 
1004     function unverifyAccount(address _beneficiary) external onlyAdmin {
1005         kyclist[_beneficiary] = false;
1006 
1007         emit VerificationUpdated(_beneficiary, false);
1008     }
1009 }