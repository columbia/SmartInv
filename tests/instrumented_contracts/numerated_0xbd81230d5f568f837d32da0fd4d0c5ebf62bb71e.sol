1 pragma solidity ^0.4.24;
2 pragma solidity ^0.4.24;
3 
4 
5 
6 /**
7  * @title ERC20Basic
8  * @dev Simpler version of ERC20 interface
9  * @dev see https://github.com/ethereum/EIPs/issues/179
10  */
11 contract ERC20Basic {
12   function totalSupply() public view returns (uint256);
13   function balanceOf(address who) public view returns (uint256);
14   function transfer(address to, uint256 value) public returns (bool);
15   event Transfer(address indexed from, address indexed to, uint256 value);
16 }
17 
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29     if (a == 0) {
30       return 0;
31     }
32     uint256 c = a * b;
33     assert(c / a == b);
34     return c;
35   }
36 
37   /**
38   * @dev Integer division of two numbers, truncating the quotient.
39   */
40   function div(uint256 a, uint256 b) internal pure returns (uint256) {
41     // assert(b > 0); // Solidity automatically throws when dividing by 0
42     uint256 c = a / b;
43     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
44     return c;
45   }
46 
47   /**
48   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     assert(b <= a);
52     return a - b;
53   }
54 
55   /**
56   * @dev Adds two numbers, throws on overflow.
57   */
58   function add(uint256 a, uint256 b) internal pure returns (uint256) {
59     uint256 c = a + b;
60     assert(c >= a);
61     return c;
62   }
63 }
64 
65 
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     // SafeMath.sub will throw if there is not enough balance.
95     balances[msg.sender] = balances[msg.sender].sub(_value);
96     balances[_to] = balances[_to].add(_value);
97     Transfer(msg.sender, _to, _value);
98     return true;
99   }
100 
101   /**
102   * @dev Gets the balance of the specified address.
103   * @param _owner The address to query the the balance of.
104   * @return An uint256 representing the amount owned by the passed address.
105   */
106   function balanceOf(address _owner) public view returns (uint256 balance) {
107     return balances[_owner];
108   }
109 
110 }
111 
112 
113 
114 
115 
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender) public view returns (uint256);
123   function transferFrom(address from, address to, uint256 value) public returns (bool);
124   function approve(address spender, uint256 value) public returns (bool);
125   event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 
129 
130 /**
131  * @title Standard ERC20 token
132  *
133  * @dev Implementation of the basic standard token.
134  * @dev https://github.com/ethereum/EIPs/issues/20
135  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
136  */
137 contract StandardToken is ERC20, BasicToken {
138 
139   mapping (address => mapping (address => uint256)) internal allowed;
140 
141 
142   /**
143    * @dev Transfer tokens from one address to another
144    * @param _from address The address which you want to send tokens from
145    * @param _to address The address which you want to transfer to
146    * @param _value uint256 the amount of tokens to be transferred
147    */
148   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
149     require(_to != address(0));
150     require(_value <= balances[_from]);
151     require(_value <= allowed[_from][msg.sender]);
152 
153     balances[_from] = balances[_from].sub(_value);
154     balances[_to] = balances[_to].add(_value);
155     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
156     Transfer(_from, _to, _value);
157     return true;
158   }
159 
160   /**
161    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162    *
163    * Beware that changing an allowance with this method brings the risk that someone may use both the old
164    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
165    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
166    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167    * @param _spender The address which will spend the funds.
168    * @param _value The amount of tokens to be spent.
169    */
170   function approve(address _spender, uint256 _value) public returns (bool) {
171     allowed[msg.sender][_spender] = _value;
172     Approval(msg.sender, _spender, _value);
173     return true;
174   }
175 
176   /**
177    * @dev Function to check the amount of tokens that an owner allowed to a spender.
178    * @param _owner address The address which owns the funds.
179    * @param _spender address The address which will spend the funds.
180    * @return A uint256 specifying the amount of tokens still available for the spender.
181    */
182   function allowance(address _owner, address _spender) public view returns (uint256) {
183     return allowed[_owner][_spender];
184   }
185 
186   /**
187    * @dev Increase the amount of tokens that an owner allowed to a spender.
188    *
189    * approve should be called when allowed[_spender] == 0. To increment
190    * allowed value is better to use this function to avoid 2 calls (and wait until
191    * the first transaction is mined)
192    * From MonolithDAO Token.sol
193    * @param _spender The address which will spend the funds.
194    * @param _addedValue The amount of tokens to increase the allowance by.
195    */
196   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
197     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
198     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
199     return true;
200   }
201 
202   /**
203    * @dev Decrease the amount of tokens that an owner allowed to a spender.
204    *
205    * approve should be called when allowed[_spender] == 0. To decrement
206    * allowed value is better to use this function to avoid 2 calls (and wait until
207    * the first transaction is mined)
208    * From MonolithDAO Token.sol
209    * @param _spender The address which will spend the funds.
210    * @param _subtractedValue The amount of tokens to decrease the allowance by.
211    */
212   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
213     uint oldValue = allowed[msg.sender][_spender];
214     if (_subtractedValue > oldValue) {
215       allowed[msg.sender][_spender] = 0;
216     } else {
217       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
218     }
219     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
220     return true;
221   }
222 
223 }
224 
225 
226 /**
227  * @title Ownable
228  * @dev The Ownable contract has an owner address, and provides basic authorization control
229  * functions, this simplifies the implementation of "user permissions".
230  */
231 contract Ownable {
232   address public owner;
233 
234 
235   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
236 
237 
238   /**
239    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
240    * account.
241    */
242   function Ownable() public {
243     owner = msg.sender;
244   }
245 
246   /**
247    * @dev Throws if called by any account other than the owner.
248    */
249   modifier onlyOwner() {
250     require(msg.sender == owner);
251     _;
252   }
253 
254   /**
255    * @dev Allows the current owner to transfer control of the contract to a newOwner.
256    * @param newOwner The address to transfer ownership to.
257    */
258   function transferOwnership(address newOwner) public onlyOwner {
259     require(newOwner != address(0));
260     OwnershipTransferred(owner, newOwner);
261     owner = newOwner;
262   }
263 
264 }
265 
266 contract SingleLockingContract is Ownable {
267     using SafeMath for uint256;
268 
269     /* --- EVENTS --- */
270 
271     event ReleasedTokens(address indexed _beneficiary);
272 
273     /* --- FIELDS --- */
274 
275     ERC20 public tokenContract;
276     uint256 public unlockTime;
277     address public beneficiary;
278 
279     /* --- MODIFIERS --- */
280 
281     modifier onlyWhenUnlocked() {
282         require(!isLocked());
283         _;
284     }
285 
286     modifier onlyWhenLocked() {
287         require(isLocked());
288         _;
289     }
290 
291     /* --- CONSTRUCTOR --- */
292 
293     function SingleLockingContract(ERC20 _tokenContract, uint256 _unlockTime, address _beneficiary) public {
294         require(_unlockTime > now);
295         require(address(_tokenContract) != 0x0);
296         require(_beneficiary != 0x0);
297 
298         unlockTime = _unlockTime;
299         tokenContract = _tokenContract;
300         beneficiary = _beneficiary;
301     }
302 
303     /* --- PUBLIC / EXTERNAL METHODS --- */
304 
305     function isLocked() public view returns(bool) {
306         return now < unlockTime;
307     }
308 
309     function balanceOf() public view returns (uint256 balance) {
310         return tokenContract.balanceOf(address(this));
311     }
312 
313     function releaseTokens() public onlyWhenUnlocked {
314         require(msg.sender == owner || msg.sender == beneficiary);
315         require(tokenContract.transfer(beneficiary, balanceOf())); 
316         emit ReleasedTokens(beneficiary);
317     }
318 }
319 
320 
321 contract Whitelist is Ownable {
322     mapping(address => bool) whitelist;
323     event AddedToWhitelist(address indexed account);
324     event RemovedFromWhitelist(address indexed account);
325 
326     modifier onlyWhitelisted() {
327         require(isWhitelisted(msg.sender));
328         _;
329     }
330 
331     function add(address _address) public onlyOwner {
332         whitelist[_address] = true;
333         emit AddedToWhitelist(_address);
334     }
335 
336     function remove(address _address) public onlyOwner {
337         whitelist[_address] = false;
338         emit RemovedFromWhitelist(_address);
339     }
340 
341     function isWhitelisted(address _address) public view returns(bool) {
342         return whitelist[_address];
343     }
344 }
345 
346 contract LockingContract is Ownable {
347     using SafeMath for uint256;
348 
349     event NotedTokens(address indexed _beneficiary, uint256 _tokenAmount);
350     event ReleasedTokens(address indexed _beneficiary);
351     event ReducedLockingTime(uint256 _newUnlockTime);
352 
353     ERC20 public tokenContract;
354     mapping(address => uint256) public tokens;
355     uint256 public totalTokens;
356     uint256 public unlockTime;
357 
358     function isLocked() public view returns(bool) {
359         return now < unlockTime;
360     }
361 
362     modifier onlyWhenUnlocked() {
363         require(!isLocked());
364         _;
365     }
366 
367     modifier onlyWhenLocked() {
368         require(isLocked());
369         _;
370     }
371 
372     function LockingContract(ERC20 _tokenContract, uint256 _unlockTime) public {
373         require(_unlockTime > now);
374         require(address(_tokenContract) != 0x0);
375         unlockTime = _unlockTime;
376         tokenContract = _tokenContract;
377     }
378 
379     function balanceOf(address _owner) public view returns (uint256 balance) {
380         return tokens[_owner];
381     }
382 
383     // Should only be done from another contract.
384     // To ensure that the LockingContract can release all noted tokens later,
385     // one should mint/transfer tokens to the LockingContract's account prior to noting
386     function noteTokens(address _beneficiary, uint256 _tokenAmount) external onlyOwner onlyWhenLocked {
387         uint256 tokenBalance = tokenContract.balanceOf(this);
388         require(tokenBalance >= totalTokens.add(_tokenAmount));
389 
390         tokens[_beneficiary] = tokens[_beneficiary].add(_tokenAmount);
391         totalTokens = totalTokens.add(_tokenAmount);
392         emit NotedTokens(_beneficiary, _tokenAmount);
393     }
394 
395     function releaseTokens(address _beneficiary) public onlyWhenUnlocked {
396         require(msg.sender == owner || msg.sender == _beneficiary);
397         uint256 amount = tokens[_beneficiary];
398         tokens[_beneficiary] = 0;
399         require(tokenContract.transfer(_beneficiary, amount)); 
400         totalTokens = totalTokens.sub(amount);
401         emit ReleasedTokens(_beneficiary);
402     }
403 
404     function reduceLockingTime(uint256 _newUnlockTime) public onlyOwner onlyWhenLocked {
405         require(_newUnlockTime >= now);
406         require(_newUnlockTime < unlockTime);
407         unlockTime = _newUnlockTime;
408         emit ReducedLockingTime(_newUnlockTime);
409     }
410 }
411 
412 
413 
414 
415 /**
416  * @title Mintable token
417  * @dev Simple ERC20 Token example, with mintable token creation
418  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
419  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
420  */
421 contract MintableToken is StandardToken, Ownable {
422   event Mint(address indexed to, uint256 amount);
423   event MintFinished();
424 
425   bool public mintingFinished = false;
426 
427 
428   modifier canMint() {
429     require(!mintingFinished);
430     _;
431   }
432 
433   /**
434    * @dev Function to mint tokens
435    * @param _to The address that will receive the minted tokens.
436    * @param _amount The amount of tokens to mint.
437    * @return A boolean that indicates if the operation was successful.
438    */
439   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
440     totalSupply_ = totalSupply_.add(_amount);
441     balances[_to] = balances[_to].add(_amount);
442     Mint(_to, _amount);
443     Transfer(address(0), _to, _amount);
444     return true;
445   }
446 
447   /**
448    * @dev Function to stop minting new tokens.
449    * @return True if the operation was successful.
450    */
451   function finishMinting() onlyOwner canMint public returns (bool) {
452     mintingFinished = true;
453     MintFinished();
454     return true;
455   }
456 }
457 
458 
459 contract CrowdfundableToken is MintableToken {
460     string public name;
461     string public symbol;
462     uint8 public decimals;
463     uint256 public cap;
464 
465     function CrowdfundableToken(uint256 _cap, string _name, string _symbol, uint8 _decimals) public {
466         require(_cap > 0);
467         require(bytes(_name).length > 0);
468         require(bytes(_symbol).length > 0);
469         cap = _cap;
470         name = _name;
471         symbol = _symbol;
472         decimals = _decimals;
473     }
474 
475     // override
476     function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
477         require(totalSupply_.add(_amount) <= cap);
478         return super.mint(_to, _amount);
479     }
480 
481     // override
482     function transfer(address _to, uint256 _value) public returns (bool) {
483         require(mintingFinished == true);
484         return super.transfer(_to, _value);
485     }
486 
487     // override
488     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
489         require(mintingFinished == true);
490         return super.transferFrom(_from, _to, _value);
491     }
492 
493     function burn(uint amount) public {
494         totalSupply_ = totalSupply_.sub(amount);
495         balances[msg.sender] = balances[msg.sender].sub(amount);
496     }
497 }
498 
499 contract AllSporterCoin is CrowdfundableToken {
500     constructor() public 
501         CrowdfundableToken(260000000 * (10**18), "AllSporter Coin", "ALL", 18) {
502     }
503 }
504 
505 
506 contract Minter is Ownable {
507     using SafeMath for uint;
508 
509     /* --- EVENTS --- */
510 
511     event Minted(address indexed account, uint etherAmount, uint tokenAmount);
512     event Reserved(uint etherAmount);
513     event MintedReserved(address indexed account, uint etherAmount, uint tokenAmount);
514     event Unreserved(uint etherAmount);
515 
516     /* --- FIELDS --- */
517 
518     CrowdfundableToken public token;
519     uint public saleEtherCap;
520     uint public confirmedSaleEther;
521     uint public reservedSaleEther;
522 
523     /* --- MODIFIERS --- */
524 
525     modifier onlyInUpdatedState() {
526         updateState();
527         _;
528     }
529 
530     modifier upToSaleEtherCap(uint additionalEtherAmount) {
531         uint totalEtherAmount = confirmedSaleEther.add(reservedSaleEther).add(additionalEtherAmount);
532         require(totalEtherAmount <= saleEtherCap);
533         _;
534     }
535 
536     modifier onlyApprovedMinter() {
537         require(canMint(msg.sender));
538         _;
539     }
540 
541     modifier atLeastMinimumAmount(uint etherAmount) {
542         require(etherAmount >= getMinimumContribution());
543         _;
544     }
545 
546     modifier onlyValidAddress(address account) {
547         require(account != 0x0);
548         _;
549     }
550 
551     /* --- CONSTRUCTOR --- */
552 
553     constructor(CrowdfundableToken _token, uint _saleEtherCap) public onlyValidAddress(address(_token)) {
554         require(_saleEtherCap > 0);
555 
556         token = _token;
557         saleEtherCap = _saleEtherCap;
558     }
559 
560     /* --- PUBLIC / EXTERNAL METHODS --- */
561 
562     function transferTokenOwnership() external onlyOwner {
563         token.transferOwnership(owner);
564     }
565 
566     function reserve(uint etherAmount) external
567         onlyInUpdatedState
568         onlyApprovedMinter
569         upToSaleEtherCap(etherAmount)
570         atLeastMinimumAmount(etherAmount)
571     {
572         reservedSaleEther = reservedSaleEther.add(etherAmount);
573         updateState();
574         emit Reserved(etherAmount);
575     }
576 
577     function mintReserved(address account, uint etherAmount, uint tokenAmount) external
578         onlyInUpdatedState
579         onlyApprovedMinter
580     {
581         reservedSaleEther = reservedSaleEther.sub(etherAmount);
582         confirmedSaleEther = confirmedSaleEther.add(etherAmount);
583         require(token.mint(account, tokenAmount));
584         updateState();
585         emit MintedReserved(account, etherAmount, tokenAmount);
586     }
587 
588     function unreserve(uint etherAmount) public
589         onlyInUpdatedState
590         onlyApprovedMinter
591     {
592         reservedSaleEther = reservedSaleEther.sub(etherAmount);
593         updateState();
594         emit Unreserved(etherAmount);
595     }
596 
597     function mint(address account, uint etherAmount, uint tokenAmount) public
598         onlyInUpdatedState
599         onlyApprovedMinter
600         upToSaleEtherCap(etherAmount)
601     {
602         confirmedSaleEther = confirmedSaleEther.add(etherAmount);
603         require(token.mint(account, tokenAmount));
604         updateState();
605         emit Minted(account, etherAmount, tokenAmount);
606     }
607 
608     // abstract
609     function getMinimumContribution() public view returns(uint);
610 
611     // abstract
612     function updateState() public;
613 
614     // abstract
615     function canMint(address sender) public view returns(bool);
616 
617     // abstract
618     function getTokensForEther(uint etherAmount) public view returns(uint);
619 }
620 
621 contract DeferredKyc is Ownable {
622     using SafeMath for uint;
623 
624     /* --- EVENTS --- */
625 
626     event AddedToKyc(address indexed investor, uint etherAmount, uint tokenAmount);
627     event Approved(address indexed investor, uint etherAmount, uint tokenAmount);
628     event Rejected(address indexed investor, uint etherAmount, uint tokenAmount);
629     event RejectedWithdrawn(address indexed investor, uint etherAmount);
630     event ApproverTransferred(address newApprover);
631     event TreasuryUpdated(address newTreasury);
632 
633     /* --- FIELDS --- */
634 
635     address public treasury;
636     Minter public minter;
637     address public approver;
638     mapping(address => uint) public etherInProgress;
639     mapping(address => uint) public tokenInProgress;
640     mapping(address => uint) public etherRejected;
641 
642     /* --- MODIFIERS --- */ 
643 
644     modifier onlyApprover() {
645         require(msg.sender == approver);
646         _;
647     }
648 
649     modifier onlyValidAddress(address account) {
650         require(account != 0x0);
651         _;
652     }
653 
654     /* --- CONSTRUCTOR --- */
655 
656     constructor(Minter _minter, address _approver, address _treasury)
657         public
658         onlyValidAddress(address(_minter))
659         onlyValidAddress(_approver)
660         onlyValidAddress(_treasury)
661     {
662         minter = _minter;
663         approver = _approver;
664         treasury = _treasury;
665     }
666 
667     /* --- PUBLIC / EXTERNAL METHODS --- */
668 
669     function updateTreasury(address newTreasury) external onlyOwner {
670         treasury = newTreasury;
671         emit TreasuryUpdated(newTreasury);
672     }
673 
674     function addToKyc(address investor) external payable onlyOwner {
675         minter.reserve(msg.value);
676         uint tokenAmount = minter.getTokensForEther(msg.value);
677         require(tokenAmount > 0);
678         emit AddedToKyc(investor, msg.value, tokenAmount);
679 
680         etherInProgress[investor] = etherInProgress[investor].add(msg.value);
681         tokenInProgress[investor] = tokenInProgress[investor].add(tokenAmount);
682     }
683 
684     function approve(address investor) external onlyApprover {
685         minter.mintReserved(investor, etherInProgress[investor], tokenInProgress[investor]);
686         emit Approved(investor, etherInProgress[investor], tokenInProgress[investor]);
687         
688         uint value = etherInProgress[investor];
689         etherInProgress[investor] = 0;
690         tokenInProgress[investor] = 0;
691         treasury.transfer(value);
692     }
693 
694     function reject(address investor) external onlyApprover {
695         minter.unreserve(etherInProgress[investor]);
696         emit Rejected(investor, etherInProgress[investor], tokenInProgress[investor]);
697 
698         etherRejected[investor] = etherRejected[investor].add(etherInProgress[investor]);
699         etherInProgress[investor] = 0;
700         tokenInProgress[investor] = 0;
701     }
702 
703     function withdrawRejected() external {
704         uint value = etherRejected[msg.sender];
705         etherRejected[msg.sender] = 0;
706         (msg.sender).transfer(value);
707         emit RejectedWithdrawn(msg.sender, value);
708     }
709 
710     function forceWithdrawRejected(address investor) external onlyApprover {
711         uint value = etherRejected[investor];
712         etherRejected[investor] = 0;
713         (investor).transfer(value);
714         emit RejectedWithdrawn(investor, value);
715     }
716 
717     function transferApprover(address newApprover) external onlyApprover {
718         approver = newApprover;
719         emit ApproverTransferred(newApprover);
720     }
721 }
722 
723 /**
724  * @title SafeERC20
725  * @dev Wrappers around ERC20 operations that throw on failure.
726  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
727  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
728  */
729 library SafeERC20 {
730   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
731     assert(token.transfer(to, value));
732   }
733 
734   function safeTransferFrom(ERC20 token, address from, address to, uint256 value) internal {
735     assert(token.transferFrom(from, to, value));
736   }
737 
738   function safeApprove(ERC20 token, address spender, uint256 value) internal {
739     assert(token.approve(spender, value));
740   }
741 }
742 
743 
744 /**
745  * @title TokenVesting
746  * @dev A token holder contract that can release its token balance gradually like a
747  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
748  * owner.
749  */
750 contract TokenVesting is Ownable {
751   using SafeMath for uint256;
752   using SafeERC20 for ERC20Basic;
753 
754   event Released(uint256 amount);
755   event Revoked();
756 
757   // beneficiary of tokens after they are released
758   address public beneficiary;
759 
760   uint256 public cliff;
761   uint256 public start;
762   uint256 public duration;
763 
764   bool public revocable;
765 
766   mapping (address => uint256) public released;
767   mapping (address => bool) public revoked;
768 
769   /**
770    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
771    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
772    * of the balance will have vested.
773    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
774    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
775    * @param _duration duration in seconds of the period in which the tokens will vest
776    * @param _revocable whether the vesting is revocable or not
777    */
778   function TokenVesting(address _beneficiary, uint256 _start, uint256 _cliff, uint256 _duration, bool _revocable) public {
779     require(_beneficiary != address(0));
780     require(_cliff <= _duration);
781 
782     beneficiary = _beneficiary;
783     revocable = _revocable;
784     duration = _duration;
785     cliff = _start.add(_cliff);
786     start = _start;
787   }
788 
789   /**
790    * @notice Transfers vested tokens to beneficiary.
791    * @param token ERC20 token which is being vested
792    */
793   function release(ERC20Basic token) public {
794     uint256 unreleased = releasableAmount(token);
795 
796     require(unreleased > 0);
797 
798     released[token] = released[token].add(unreleased);
799 
800     token.safeTransfer(beneficiary, unreleased);
801 
802     Released(unreleased);
803   }
804 
805   /**
806    * @notice Allows the owner to revoke the vesting. Tokens already vested
807    * remain in the contract, the rest are returned to the owner.
808    * @param token ERC20 token which is being vested
809    */
810   function revoke(ERC20Basic token) public onlyOwner {
811     require(revocable);
812     require(!revoked[token]);
813 
814     uint256 balance = token.balanceOf(this);
815 
816     uint256 unreleased = releasableAmount(token);
817     uint256 refund = balance.sub(unreleased);
818 
819     revoked[token] = true;
820 
821     token.safeTransfer(owner, refund);
822 
823     Revoked();
824   }
825 
826   /**
827    * @dev Calculates the amount that has already vested but hasn't been released yet.
828    * @param token ERC20 token which is being vested
829    */
830   function releasableAmount(ERC20Basic token) public view returns (uint256) {
831     return vestedAmount(token).sub(released[token]);
832   }
833 
834   /**
835    * @dev Calculates the amount that has already vested.
836    * @param token ERC20 token which is being vested
837    */
838   function vestedAmount(ERC20Basic token) public view returns (uint256) {
839     uint256 currentBalance = token.balanceOf(this);
840     uint256 totalBalance = currentBalance.add(released[token]);
841 
842     if (now < cliff) {
843       return 0;
844     } else if (now >= start.add(duration) || revoked[token]) {
845       return totalBalance;
846     } else {
847       return totalBalance.mul(now.sub(start)).div(duration);
848     }
849   }
850 }
851 
852 
853 
854 contract Allocator is Ownable {
855     using SafeMath for uint;
856 
857     /* --- CONSTANTS --- */
858 
859     uint constant public ETHER_AMOUNT = 0;
860 
861     // percentages
862     uint constant public COMMUNITY_PERCENTAGE = 5;
863     uint constant public ADVISORS_PERCENTAGE = 8;
864     uint constant public CUSTOMER_PERCENTAGE = 15;
865     uint constant public TEAM_PERCENTAGE = 17;
866     uint constant public SALE_PERCENTAGE = 55;
867     
868     // locking
869     uint constant public LOCKING_UNLOCK_TIME = 1602324000;
870 
871     // vesting
872     uint constant public VESTING_START_TIME = 1568109600;
873     uint constant public VESTING_CLIFF_DURATION = 10000;
874     uint constant public VESTING_PERIOD = 50000;
875     
876     /* --- EVENTS --- */
877 
878     event Initialized();
879     event AllocatedCommunity(address indexed account, uint tokenAmount);
880     event AllocatedAdvisors(address indexed account, uint tokenAmount);
881     event AllocatedCustomer(address indexed account, uint tokenAmount, address contractAddress);
882     event AllocatedTeam(address indexed account, uint tokenAmount, address contractAddress);
883     event LockedTokensReleased(address indexed account);
884     event VestedTokensReleased(address indexed account);
885 
886     /* --- FIELDS --- */
887 
888     Minter public minter;
889     bool public isInitialized = false;
890     mapping(address => TokenVesting) public vestingContracts; // one customer => one TokenVesting contract
891     mapping(address => SingleLockingContract) public lockingContracts; // one team => one SingleLockingContract
892 
893     // pools
894     uint public communityPool;
895     uint public advisorsPool;
896     uint public customerPool;
897     uint public teamPool;
898     
899 
900     /* --- MODIFIERS --- */
901 
902     modifier initialized() {
903         if (!isInitialized) {
904             initialize();
905         }
906         _;
907     }
908 
909     modifier validPercentage(uint percent) {
910         require(percent >= 0 && percent <= 100);
911         _;
912     }
913 
914     modifier onlyValidAddress(address account) {
915         require(account != 0x0);
916         _;
917     }
918 
919     /* --- CONSTRUCTOR --- */
920 
921     constructor(Minter _minter)
922     public
923     validPercentage(COMMUNITY_PERCENTAGE)
924     validPercentage(ADVISORS_PERCENTAGE)
925     validPercentage(CUSTOMER_PERCENTAGE)
926     validPercentage(TEAM_PERCENTAGE)
927     validPercentage(SALE_PERCENTAGE)
928     onlyValidAddress(_minter)
929     {
930         require(COMMUNITY_PERCENTAGE.add(ADVISORS_PERCENTAGE).add(CUSTOMER_PERCENTAGE).add(TEAM_PERCENTAGE).add(SALE_PERCENTAGE) == 100);
931         minter = _minter;
932     }
933 
934     /* --- PUBLIC / EXTERNAL METHODS --- */
935 
936     function releaseVested(address account) external initialized {
937         require(msg.sender == account || msg.sender == owner);
938         TokenVesting vesting = vestingContracts[account];
939         vesting.release(minter.token());
940         emit VestedTokensReleased(account);
941     }
942 
943     function releaseLocked(address account) external initialized {
944         require(msg.sender == account || msg.sender == owner);
945         SingleLockingContract locking = lockingContracts[account];
946         locking.releaseTokens();
947         emit LockedTokensReleased(account);
948     }
949 
950     function allocateCommunity(address account, uint tokenAmount) external initialized onlyOwner {
951         communityPool = communityPool.sub(tokenAmount);
952         minter.mint(account, ETHER_AMOUNT, tokenAmount);
953         emit AllocatedCommunity(account, tokenAmount);
954     }
955 
956     function allocateAdvisors(address account, uint tokenAmount) external initialized onlyOwner {
957         advisorsPool = advisorsPool.sub(tokenAmount);
958         minter.mint(account, ETHER_AMOUNT, tokenAmount);
959         emit AllocatedAdvisors(account, tokenAmount);
960     }
961 
962     // vesting
963     function allocateCustomer(address account, uint tokenAmount) external initialized onlyOwner {
964         customerPool = customerPool.sub(tokenAmount);
965         if (address(vestingContracts[account]) == 0x0) {
966             vestingContracts[account] = new TokenVesting(account, VESTING_START_TIME, VESTING_CLIFF_DURATION, VESTING_PERIOD, false);
967         }
968         minter.mint(address(vestingContracts[account]), ETHER_AMOUNT, tokenAmount);
969         emit AllocatedCustomer(account, tokenAmount, address(vestingContracts[account]));
970     }
971 
972     // locking
973     function allocateTeam(address account, uint tokenAmount) external initialized onlyOwner {
974         teamPool = teamPool.sub(tokenAmount);
975         if (address(lockingContracts[account]) == 0x0) {
976             lockingContracts[account] = new SingleLockingContract(minter.token(), LOCKING_UNLOCK_TIME, account);
977         }
978         minter.mint(lockingContracts[account], ETHER_AMOUNT, tokenAmount);
979         emit AllocatedTeam(account, tokenAmount, address(lockingContracts[account]));
980     }
981 
982     /* --- INTERNAL METHODS --- */
983 
984     function initialize() internal {
985         isInitialized = true;
986         CrowdfundableToken token = minter.token();
987         uint tokensSold = token.totalSupply();
988         uint tokensPerPercent = tokensSold.div(SALE_PERCENTAGE);
989 
990         communityPool = COMMUNITY_PERCENTAGE.mul(tokensPerPercent);
991         advisorsPool = ADVISORS_PERCENTAGE.mul(tokensPerPercent);
992         customerPool = CUSTOMER_PERCENTAGE.mul(tokensPerPercent);
993         teamPool = TEAM_PERCENTAGE.mul(tokensPerPercent);
994 
995         emit Initialized();
996     }
997 }