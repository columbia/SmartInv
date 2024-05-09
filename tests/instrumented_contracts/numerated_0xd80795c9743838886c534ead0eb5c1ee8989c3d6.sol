1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title SafeMath
18  * @dev Math operations with safety checks that throw on error
19  */
20 library SafeMath {
21 
22   /**
23   * @dev Multiplies two numbers, throws on overflow.
24   */
25   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
26     if (a == 0) {
27       return 0;
28     }
29     uint256 c = a * b;
30     assert(c / a == b);
31     return c;
32   }
33 
34   /**
35   * @dev Integer division of two numbers, truncating the quotient.
36   */
37   function div(uint256 a, uint256 b) internal pure returns (uint256) {
38     // assert(b > 0); // Solidity automatically throws when dividing by 0
39     uint256 c = a / b;
40     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
41     return c;
42   }
43 
44   /**
45   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
46   */
47   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   /**
53   * @dev Adds two numbers, throws on overflow.
54   */
55   function add(uint256 a, uint256 b) internal pure returns (uint256) {
56     uint256 c = a + b;
57     assert(c >= a);
58     return c;
59   }
60 }
61 
62 
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances.
67  */
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   uint256 totalSupply_;
74 
75   /**
76   * @dev total number of tokens in existence
77   */
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81 
82   /**
83   * @dev transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     // SafeMath.sub will throw if there is not enough balance.
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256 balance) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 
110 
111 
112 
113 
114 /**
115  * @title ERC20 interface
116  * @dev see https://github.com/ethereum/EIPs/issues/20
117  */
118 contract ERC20 is ERC20Basic {
119   function allowance(address owner, address spender) public view returns (uint256);
120   function transferFrom(address from, address to, uint256 value) public returns (bool);
121   function approve(address spender, uint256 value) public returns (bool);
122   event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 
126 
127 /**
128  * @title Standard ERC20 token
129  *
130  * @dev Implementation of the basic standard token.
131  * @dev https://github.com/ethereum/EIPs/issues/20
132  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
133  */
134 contract StandardToken is ERC20, BasicToken {
135 
136   mapping (address => mapping (address => uint256)) internal allowed;
137 
138 
139   /**
140    * @dev Transfer tokens from one address to another
141    * @param _from address The address which you want to send tokens from
142    * @param _to address The address which you want to transfer to
143    * @param _value uint256 the amount of tokens to be transferred
144    */
145   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
146     require(_to != address(0));
147     require(_value <= balances[_from]);
148     require(_value <= allowed[_from][msg.sender]);
149 
150     balances[_from] = balances[_from].sub(_value);
151     balances[_to] = balances[_to].add(_value);
152     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
153     Transfer(_from, _to, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
159    *
160    * Beware that changing an allowance with this method brings the risk that someone may use both the old
161    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
162    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
163    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
164    * @param _spender The address which will spend the funds.
165    * @param _value The amount of tokens to be spent.
166    */
167   function approve(address _spender, uint256 _value) public returns (bool) {
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifying the amount of tokens still available for the spender.
178    */
179   function allowance(address _owner, address _spender) public view returns (uint256) {
180     return allowed[_owner][_spender];
181   }
182 
183   /**
184    * @dev Increase the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To increment
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _addedValue The amount of tokens to increase the allowance by.
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   /**
200    * @dev Decrease the amount of tokens that an owner allowed to a spender.
201    *
202    * approve should be called when allowed[_spender] == 0. To decrement
203    * allowed value is better to use this function to avoid 2 calls (and wait until
204    * the first transaction is mined)
205    * From MonolithDAO Token.sol
206    * @param _spender The address which will spend the funds.
207    * @param _subtractedValue The amount of tokens to decrease the allowance by.
208    */
209   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
210     uint oldValue = allowed[msg.sender][_spender];
211     if (_subtractedValue > oldValue) {
212       allowed[msg.sender][_spender] = 0;
213     } else {
214       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
215     }
216     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
217     return true;
218   }
219 
220 }
221 
222 
223 /**
224  * @title Ownable
225  * @dev The Ownable contract has an owner address, and provides basic authorization control
226  * functions, this simplifies the implementation of "user permissions".
227  */
228 contract Ownable {
229   address public owner;
230 
231 
232   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
233 
234 
235   /**
236    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
237    * account.
238    */
239   function Ownable() public {
240     owner = msg.sender;
241   }
242 
243   /**
244    * @dev Throws if called by any account other than the owner.
245    */
246   modifier onlyOwner() {
247     require(msg.sender == owner);
248     _;
249   }
250 
251   /**
252    * @dev Allows the current owner to transfer control of the contract to a newOwner.
253    * @param newOwner The address to transfer ownership to.
254    */
255   function transferOwnership(address newOwner) public onlyOwner {
256     require(newOwner != address(0));
257     OwnershipTransferred(owner, newOwner);
258     owner = newOwner;
259   }
260 
261 }
262 
263 
264 contract Whitelist is Ownable {
265     mapping(address => bool) whitelist;
266     event AddedToWhitelist(address indexed account);
267     event RemovedFromWhitelist(address indexed account);
268 
269     modifier onlyWhitelisted() {
270         require(isWhitelisted(msg.sender));
271         _;
272     }
273 
274     function add(address _address) public onlyOwner {
275         whitelist[_address] = true;
276         emit AddedToWhitelist(_address);
277     }
278 
279     function remove(address _address) public onlyOwner {
280         whitelist[_address] = false;
281         emit RemovedFromWhitelist(_address);
282     }
283 
284     function isWhitelisted(address _address) public view returns(bool) {
285         return whitelist[_address];
286     }
287 }
288 
289 contract LockingContract is Ownable {
290     using SafeMath for uint256;
291 
292     event NotedTokens(address indexed _beneficiary, uint256 _tokenAmount);
293     event ReleasedTokens(address indexed _beneficiary);
294     event ReducedLockingTime(uint256 _newUnlockTime);
295 
296     ERC20 public tokenContract;
297     mapping(address => uint256) public tokens;
298     uint256 public totalTokens;
299     uint256 public unlockTime;
300 
301     function isLocked() public view returns(bool) {
302         return now < unlockTime;
303     }
304 
305     modifier onlyWhenUnlocked() {
306         require(!isLocked());
307         _;
308     }
309 
310     modifier onlyWhenLocked() {
311         require(isLocked());
312         _;
313     }
314 
315     function LockingContract(ERC20 _tokenContract, uint256 _unlockTime) public {
316         require(_unlockTime > now);
317         require(address(_tokenContract) != 0x0);
318         unlockTime = _unlockTime;
319         tokenContract = _tokenContract;
320     }
321 
322     function balanceOf(address _owner) public view returns (uint256 balance) {
323         return tokens[_owner];
324     }
325 
326     // Should only be done from another contract.
327     // To ensure that the LockingContract can release all noted tokens later,
328     // one should mint/transfer tokens to the LockingContract's account prior to noting
329     function noteTokens(address _beneficiary, uint256 _tokenAmount) external onlyOwner onlyWhenLocked {
330         uint256 tokenBalance = tokenContract.balanceOf(this);
331         require(tokenBalance >= totalTokens.add(_tokenAmount));
332 
333         tokens[_beneficiary] = tokens[_beneficiary].add(_tokenAmount);
334         totalTokens = totalTokens.add(_tokenAmount);
335         emit NotedTokens(_beneficiary, _tokenAmount);
336     }
337 
338     function releaseTokens(address _beneficiary) public onlyWhenUnlocked {
339         require(msg.sender == owner || msg.sender == _beneficiary);
340         uint256 amount = tokens[_beneficiary];
341         tokens[_beneficiary] = 0;
342         require(tokenContract.transfer(_beneficiary, amount)); 
343         totalTokens = totalTokens.sub(amount);
344         emit ReleasedTokens(_beneficiary);
345     }
346 
347     function reduceLockingTime(uint256 _newUnlockTime) public onlyOwner onlyWhenLocked {
348         require(_newUnlockTime >= now);
349         require(_newUnlockTime < unlockTime);
350         unlockTime = _newUnlockTime;
351         emit ReducedLockingTime(_newUnlockTime);
352     }
353 }
354 
355 
356 
357 
358 /**
359  * @title Mintable token
360  * @dev Simple ERC20 Token example, with mintable token creation
361  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
362  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
363  */
364 contract MintableToken is StandardToken, Ownable {
365   event Mint(address indexed to, uint256 amount);
366   event MintFinished();
367 
368   bool public mintingFinished = false;
369 
370 
371   modifier canMint() {
372     require(!mintingFinished);
373     _;
374   }
375 
376   /**
377    * @dev Function to mint tokens
378    * @param _to The address that will receive the minted tokens.
379    * @param _amount The amount of tokens to mint.
380    * @return A boolean that indicates if the operation was successful.
381    */
382   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
383     totalSupply_ = totalSupply_.add(_amount);
384     balances[_to] = balances[_to].add(_amount);
385     Mint(_to, _amount);
386     Transfer(address(0), _to, _amount);
387     return true;
388   }
389 
390   /**
391    * @dev Function to stop minting new tokens.
392    * @return True if the operation was successful.
393    */
394   function finishMinting() onlyOwner canMint public returns (bool) {
395     mintingFinished = true;
396     MintFinished();
397     return true;
398   }
399 }
400 
401 
402 contract CrowdfundableToken is MintableToken {
403     string public name;
404     string public symbol;
405     uint8 public decimals;
406     uint256 public cap;
407 
408     function CrowdfundableToken(uint256 _cap, string _name, string _symbol, uint8 _decimals) public {
409         require(_cap > 0);
410         require(bytes(_name).length > 0);
411         require(bytes(_symbol).length > 0);
412         cap = _cap;
413         name = _name;
414         symbol = _symbol;
415         decimals = _decimals;
416     }
417 
418     // override
419     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
420         require(totalSupply_.add(_amount) <= cap);
421         return super.mint(_to, _amount);
422     }
423 
424     // override
425     function transfer(address _to, uint256 _value) public returns (bool) {
426         require(mintingFinished == true);
427         return super.transfer(_to, _value);
428     }
429 
430     // override
431     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
432         require(mintingFinished == true);
433         return super.transferFrom(_from, _to, _value);
434     }
435 
436     function burn(uint amount) public {
437         totalSupply_ = totalSupply_.sub(amount);
438         balances[msg.sender] = balances[msg.sender].sub(amount);
439     }
440 }
441 
442 contract AllSporterCoin is CrowdfundableToken {
443     constructor() public 
444         CrowdfundableToken(260000000 * (10**18), "AllSporter Coin", "ALL", 18) {
445     }
446 }
447 
448 
449 contract Minter is Ownable {
450     using SafeMath for uint;
451 
452     /* --- EVENTS --- */
453 
454     event Minted(address indexed account, uint etherAmount, uint tokenAmount);
455     event Reserved(uint etherAmount);
456     event MintedReserved(address indexed account, uint etherAmount, uint tokenAmount);
457     event Unreserved(uint etherAmount);
458 
459     /* --- FIELDS --- */
460 
461     CrowdfundableToken public token;
462     uint public saleEtherCap;
463     uint public confirmedSaleEther;
464     uint public reservedSaleEther;
465 
466     /* --- MODIFIERS --- */
467 
468     modifier onlyInUpdatedState() {
469         updateState();
470         _;
471     }
472 
473     modifier upToSaleEtherCap(uint additionalEtherAmount) {
474         uint totalEtherAmount = confirmedSaleEther.add(reservedSaleEther).add(additionalEtherAmount);
475         require(totalEtherAmount <= saleEtherCap);
476         _;
477     }
478 
479     modifier onlyApprovedMinter() {
480         require(canMint(msg.sender));
481         _;
482     }
483 
484     modifier atLeastMinimumAmount(uint etherAmount) {
485         require(etherAmount >= getMinimumContribution());
486         _;
487     }
488 
489     modifier onlyValidAddress(address account) {
490         require(account != 0x0);
491         _;
492     }
493 
494     /* --- CONSTRUCTOR --- */
495 
496     constructor(CrowdfundableToken _token, uint _saleEtherCap) public onlyValidAddress(address(_token)) {
497         require(_saleEtherCap > 0);
498 
499         token = _token;
500         saleEtherCap = _saleEtherCap;
501     }
502 
503     /* --- PUBLIC / EXTERNAL METHODS --- */
504 
505     function transferTokenOwnership() external onlyOwner {
506         token.transferOwnership(owner);
507     }
508 
509     function reserve(uint etherAmount) external
510         onlyInUpdatedState
511         onlyApprovedMinter
512         upToSaleEtherCap(etherAmount)
513         atLeastMinimumAmount(etherAmount)
514     {
515         reservedSaleEther = reservedSaleEther.add(etherAmount);
516         updateState();
517         emit Reserved(etherAmount);
518     }
519 
520     function mintReserved(address account, uint etherAmount, uint tokenAmount) external
521         onlyInUpdatedState
522         onlyApprovedMinter
523     {
524         reservedSaleEther = reservedSaleEther.sub(etherAmount);
525         confirmedSaleEther = confirmedSaleEther.add(etherAmount);
526         require(token.mint(account, tokenAmount));
527         updateState();
528         emit MintedReserved(account, etherAmount, tokenAmount);
529     }
530 
531     function unreserve(uint etherAmount) public
532         onlyInUpdatedState
533         onlyApprovedMinter
534     {
535         reservedSaleEther = reservedSaleEther.sub(etherAmount);
536         updateState();
537         emit Unreserved(etherAmount);
538     }
539 
540     function mint(address account, uint etherAmount, uint tokenAmount) public
541         onlyInUpdatedState
542         onlyApprovedMinter
543         upToSaleEtherCap(etherAmount)
544     {
545         confirmedSaleEther = confirmedSaleEther.add(etherAmount);
546         require(token.mint(account, tokenAmount));
547         updateState();
548         emit Minted(account, etherAmount, tokenAmount);
549     }
550 
551     // abstract
552     function getMinimumContribution() public view returns(uint);
553 
554     // abstract
555     function updateState() public;
556 
557     // abstract
558     function canMint(address sender) public view returns(bool);
559 
560     // abstract
561     function getTokensForEther(uint etherAmount) public view returns(uint);
562 }
563 
564 contract DeferredKyc is Ownable {
565     using SafeMath for uint;
566 
567     /* --- EVENTS --- */
568 
569     event AddedToKyc(address indexed investor, uint etherAmount, uint tokenAmount);
570     event Approved(address indexed investor, uint etherAmount, uint tokenAmount);
571     event Rejected(address indexed investor, uint etherAmount, uint tokenAmount);
572     event RejectedWithdrawn(address indexed investor, uint etherAmount);
573     event ApproverTransferred(address newApprover);
574     event TreasuryUpdated(address newTreasury);
575 
576     /* --- FIELDS --- */
577 
578     address public treasury;
579     Minter public minter;
580     address public approver;
581     mapping(address => uint) public etherInProgress;
582     mapping(address => uint) public tokenInProgress;
583     mapping(address => uint) public etherRejected;
584 
585     /* --- MODIFIERS --- */ 
586 
587     modifier onlyApprover() {
588         require(msg.sender == approver);
589         _;
590     }
591 
592     modifier onlyValidAddress(address account) {
593         require(account != 0x0);
594         _;
595     }
596 
597     /* --- CONSTRUCTOR --- */
598 
599     constructor(Minter _minter, address _approver, address _treasury)
600         public
601         onlyValidAddress(address(_minter))
602         onlyValidAddress(_approver)
603         onlyValidAddress(_treasury)
604     {
605         minter = _minter;
606         approver = _approver;
607         treasury = _treasury;
608     }
609 
610     /* --- PUBLIC / EXTERNAL METHODS --- */
611 
612     function updateTreasury(address newTreasury) external onlyOwner {
613         treasury = newTreasury;
614         emit TreasuryUpdated(newTreasury);
615     }
616 
617     function addToKyc(address investor) external payable onlyOwner {
618         minter.reserve(msg.value);
619         uint tokenAmount = minter.getTokensForEther(msg.value);
620         require(tokenAmount > 0);
621         emit AddedToKyc(investor, msg.value, tokenAmount);
622 
623         etherInProgress[investor] = etherInProgress[investor].add(msg.value);
624         tokenInProgress[investor] = tokenInProgress[investor].add(tokenAmount);
625     }
626 
627     function approve(address investor) external onlyApprover {
628         minter.mintReserved(investor, etherInProgress[investor], tokenInProgress[investor]);
629         emit Approved(investor, etherInProgress[investor], tokenInProgress[investor]);
630         
631         uint value = etherInProgress[investor];
632         etherInProgress[investor] = 0;
633         tokenInProgress[investor] = 0;
634         treasury.transfer(value);
635     }
636 
637     function reject(address investor) external onlyApprover {
638         minter.unreserve(etherInProgress[investor]);
639         emit Rejected(investor, etherInProgress[investor], tokenInProgress[investor]);
640 
641         etherRejected[investor] = etherRejected[investor].add(etherInProgress[investor]);
642         etherInProgress[investor] = 0;
643         tokenInProgress[investor] = 0;
644     }
645 
646     function withdrawRejected() external {
647         uint value = etherRejected[msg.sender];
648         etherRejected[msg.sender] = 0;
649         (msg.sender).transfer(value);
650         emit RejectedWithdrawn(msg.sender, value);
651     }
652 
653     function forceWithdrawRejected(address investor) external onlyApprover {
654         uint value = etherRejected[investor];
655         etherRejected[investor] = 0;
656         (investor).transfer(value);
657         emit RejectedWithdrawn(investor, value);
658     }
659 
660     function transferApprover(address newApprover) external onlyApprover {
661         approver = newApprover;
662         emit ApproverTransferred(newApprover);
663     }
664 }
665 
666 
667 contract ReferralManager is Ownable {
668     using SafeMath for uint;
669 
670     /* --- CONSTANTS --- */
671 
672     uint constant public ETHER_AMOUNT = 0;
673     uint constant public MAXIMUM_PERCENT = 15;
674 
675     /* --- EVENTS --- */
676 
677     event FeeAdded(address indexed account, uint tokenAmount);
678 
679     /* --- FIELDS --- */
680 
681     Minter public minter;
682     mapping(address => bool) alreadyReferred;
683 
684     /* --- MODIFIERS --- */
685 
686     modifier notAlreadyReferred(address account) {
687         require(!alreadyReferred[account]);
688         _;
689     }
690 
691     modifier onlyValidPercent(uint percent) {
692         require(percent >= 0 && percent <= 100);
693         require(percent <= MAXIMUM_PERCENT);
694         _;
695     }
696 
697     modifier onlyValidAddress(address account) {
698         require(account != 0x0);
699         _;
700     }
701 
702     /* --- CONSTRUCTOR --- */
703 
704     constructor(Minter _minter) public onlyValidAddress(address(_minter)) {
705         minter = _minter;
706     }
707 
708     /* --- PUBLIC / EXTERNAL METHODS --- */
709 
710     function addFee(address referring, uint referringPercent, address referred, uint referredPercent)
711         external
712         onlyOwner
713         onlyValidAddress(referring)
714         onlyValidAddress(referred)
715         onlyValidPercent(referringPercent)
716         onlyValidPercent(referredPercent)
717         notAlreadyReferred(referred)
718     {
719         alreadyReferred[referred] = true;
720         uint baseContribution = minter.token().balanceOf(referred);
721         applyFee(referring, baseContribution, referringPercent);
722         applyFee(referred, baseContribution, referredPercent);
723     }
724 
725     /* --- INTERNAL METHODS --- */
726 
727     function applyFee(address account, uint baseContribution, uint percent) internal {
728         uint tokensDue = baseContribution.div(100).mul(percent);
729         minter.mint(account, ETHER_AMOUNT, tokensDue);
730         emit FeeAdded(account, tokensDue);
731     }
732 }