1 pragma solidity ^0.4.21;
2 
3 // File: zeppelin-solidity/contracts/math/SafeMath.sol
4 
5 /**
6  * @title SafeMath
7  * @dev Math operations with safety checks that throw on error
8  */
9 library SafeMath {
10 
11   /**
12   * @dev Multiplies two numbers, throws on overflow.
13   */
14   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
15     if (a == 0) {
16       return 0;
17     }
18     c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     // uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return a / b;
31   }
32 
33   /**
34   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
45     c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
52 
53 /**
54  * @title Ownable
55  * @dev The Ownable contract has an owner address, and provides basic authorization control
56  * functions, this simplifies the implementation of "user permissions".
57  */
58 contract Ownable {
59   address public owner;
60 
61 
62   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64 
65   /**
66    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
67    * account.
68    */
69   function Ownable() public {
70     owner = msg.sender;
71   }
72 
73   /**
74    * @dev Throws if called by any account other than the owner.
75    */
76   modifier onlyOwner() {
77     require(msg.sender == owner);
78     _;
79   }
80 
81   /**
82    * @dev Allows the current owner to transfer control of the contract to a newOwner.
83    * @param newOwner The address to transfer ownership to.
84    */
85   function transferOwnership(address newOwner) public onlyOwner {
86     require(newOwner != address(0));
87     emit OwnershipTransferred(owner, newOwner);
88     owner = newOwner;
89   }
90 
91 }
92 
93 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
94 
95 /**
96  * @title ERC20Basic
97  * @dev Simpler version of ERC20 interface
98  * @dev see https://github.com/ethereum/EIPs/issues/179
99  */
100 contract ERC20Basic {
101   function totalSupply() public view returns (uint256);
102   function balanceOf(address who) public view returns (uint256);
103   function transfer(address to, uint256 value) public returns (bool);
104   event Transfer(address indexed from, address indexed to, uint256 value);
105 }
106 
107 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
108 
109 /**
110  * @title Basic token
111  * @dev Basic version of StandardToken, with no allowances.
112  */
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) balances;
117 
118   uint256 totalSupply_;
119 
120   /**
121   * @dev total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_to != address(0));
134     require(_value <= balances[msg.sender]);
135 
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     emit Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256) {
148     return balances[_owner];
149   }
150 
151 }
152 
153 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
154 
155 /**
156  * @title ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/20
158  */
159 contract ERC20 is ERC20Basic {
160   function allowance(address owner, address spender) public view returns (uint256);
161   function transferFrom(address from, address to, uint256 value) public returns (bool);
162   function approve(address spender, uint256 value) public returns (bool);
163   event Approval(address indexed owner, address indexed spender, uint256 value);
164 }
165 
166 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
167 
168 /**
169  * @title Standard ERC20 token
170  *
171  * @dev Implementation of the basic standard token.
172  * @dev https://github.com/ethereum/EIPs/issues/20
173  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
174  */
175 contract StandardToken is ERC20, BasicToken {
176 
177   mapping (address => mapping (address => uint256)) internal allowed;
178 
179 
180   /**
181    * @dev Transfer tokens from one address to another
182    * @param _from address The address which you want to send tokens from
183    * @param _to address The address which you want to transfer to
184    * @param _value uint256 the amount of tokens to be transferred
185    */
186   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
187     require(_to != address(0));
188     require(_value <= balances[_from]);
189     require(_value <= allowed[_from][msg.sender]);
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     emit Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    *
201    * Beware that changing an allowance with this method brings the risk that someone may use both the old
202    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
203    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
204    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205    * @param _spender The address which will spend the funds.
206    * @param _value The amount of tokens to be spent.
207    */
208   function approve(address _spender, uint256 _value) public returns (bool) {
209     allowed[msg.sender][_spender] = _value;
210     emit Approval(msg.sender, _spender, _value);
211     return true;
212   }
213 
214   /**
215    * @dev Function to check the amount of tokens that an owner allowed to a spender.
216    * @param _owner address The address which owns the funds.
217    * @param _spender address The address which will spend the funds.
218    * @return A uint256 specifying the amount of tokens still available for the spender.
219    */
220   function allowance(address _owner, address _spender) public view returns (uint256) {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
235     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
236     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240   /**
241    * @dev Decrease the amount of tokens that an owner allowed to a spender.
242    *
243    * approve should be called when allowed[_spender] == 0. To decrement
244    * allowed value is better to use this function to avoid 2 calls (and wait until
245    * the first transaction is mined)
246    * From MonolithDAO Token.sol
247    * @param _spender The address which will spend the funds.
248    * @param _subtractedValue The amount of tokens to decrease the allowance by.
249    */
250   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
251     uint oldValue = allowed[msg.sender][_spender];
252     if (_subtractedValue > oldValue) {
253       allowed[msg.sender][_spender] = 0;
254     } else {
255       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
256     }
257     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
258     return true;
259   }
260 
261 }
262 
263 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
264 
265 /**
266  * @title Mintable token
267  * @dev Simple ERC20 Token example, with mintable token creation
268  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
269  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
270  */
271 contract MintableToken is StandardToken, Ownable {
272   event Mint(address indexed to, uint256 amount);
273   event MintFinished();
274 
275   bool public mintingFinished = false;
276 
277 
278   modifier canMint() {
279     require(!mintingFinished);
280     _;
281   }
282 
283   /**
284    * @dev Function to mint tokens
285    * @param _to The address that will receive the minted tokens.
286    * @param _amount The amount of tokens to mint.
287    * @return A boolean that indicates if the operation was successful.
288    */
289   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
290     totalSupply_ = totalSupply_.add(_amount);
291     balances[_to] = balances[_to].add(_amount);
292     emit Mint(_to, _amount);
293     emit Transfer(address(0), _to, _amount);
294     return true;
295   }
296 
297   /**
298    * @dev Function to stop minting new tokens.
299    * @return True if the operation was successful.
300    */
301   function finishMinting() onlyOwner canMint public returns (bool) {
302     mintingFinished = true;
303     emit MintFinished();
304     return true;
305   }
306 }
307 
308 // File: contracts/HoldToken.sol
309 
310 contract HoldToken is MintableToken {
311     using SafeMath for uint256;
312 
313     string public name = 'HOLD';
314     string public symbol = 'HOLD';
315     uint8 public decimals = 18;
316 
317     event Burn(address indexed burner, uint256 value);
318     event BurnTransferred(address indexed previousBurner, address indexed newBurner);
319 
320     address burnerRole;
321 
322     modifier onlyBurner() {
323         require(msg.sender == burnerRole);
324         _;
325     }
326 
327     function HoldToken(address _burner) public {
328         burnerRole = _burner;
329     }
330 
331     function transferBurnRole(address newBurner) public onlyBurner {
332         require(newBurner != address(0));
333         BurnTransferred(burnerRole, newBurner);
334         burnerRole = newBurner;
335     }
336 
337     function burn(uint256 _value) public onlyBurner {
338         require(_value <= balances[msg.sender]);
339         balances[msg.sender] = balances[msg.sender].sub(_value);
340         totalSupply_ = totalSupply_.sub(_value);
341         Burn(msg.sender, _value);
342         Transfer(msg.sender, address(0), _value);
343     }
344 }
345 
346 // File: contracts/Crowdsale.sol
347 
348 /**
349  * @title Crowdsale
350  * @dev Crowdsale is a base contract for managing a token crowdsale.
351  * Crowdsales have a start and end timestamps, where investors can make
352  * token purchases and the crowdsale will assign them tokens based
353  * on a token per ETH rate. Funds collected are forwarded to a wallet
354  * as they arrive.
355  */
356 contract Crowdsale {
357     using SafeMath for uint256;
358 
359     // The token being sold
360     HoldToken public token;
361 
362     // start and end timestamps where investments are allowed (both inclusive)
363     uint256 public startTime;
364     uint256 public endTime;
365 
366     uint256 public rate;
367 
368     // address where funds are collected
369     address public wallet;
370 
371     // amount of raised money in wei
372     uint256 public weiRaised;
373 
374     /**
375      * event for token purchase logging
376      * @param beneficiary who got the tokens
377      * @param value weis paid for purchase
378      * @param amount amount of tokens purchased
379      * @param transactionId identifier which corresponds to transaction under which the tokens were purchased
380      */
381     event TokenPurchase(address indexed beneficiary, uint256 indexed value, uint256 indexed amount, uint256 transactionId);
382 
383 
384     function Crowdsale(
385         uint256 _startTime,
386         uint256 _endTime,
387         uint256 _rate,
388         address _wallet,
389         uint256 _initialWeiRaised
390     ) public {
391         require(_startTime >= now);
392         require(_endTime >= _startTime);
393         require(_wallet != address(0));
394         require(_rate > 0);
395 
396         token = new HoldToken(_wallet);
397         startTime = _startTime;
398         endTime = _endTime;
399         rate = _rate;
400         wallet = _wallet;
401         weiRaised = _initialWeiRaised;
402     }
403 
404     // @return true if crowdsale event has ended
405     function hasEnded() public view returns (bool) {
406         return now > endTime;
407     }
408 }
409 
410 // File: zeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
411 
412 /**
413  * @title SafeERC20
414  * @dev Wrappers around ERC20 operations that throw on failure.
415  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
416  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
417  */
418 library SafeERC20 {
419   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
420     assert(token.transfer(to, value));
421   }
422 
423   function safeTransferFrom(
424     ERC20 token,
425     address from,
426     address to,
427     uint256 value
428   )
429     internal
430   {
431     assert(token.transferFrom(from, to, value));
432   }
433 
434   function safeApprove(ERC20 token, address spender, uint256 value) internal {
435     assert(token.approve(spender, value));
436   }
437 }
438 
439 // File: zeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
440 
441 /**
442  * @title TokenTimelock
443  * @dev TokenTimelock is a token holder contract that will allow a
444  * beneficiary to extract the tokens after a given release time
445  */
446 contract TokenTimelock {
447   using SafeERC20 for ERC20Basic;
448 
449   // ERC20 basic token contract being held
450   ERC20Basic public token;
451 
452   // beneficiary of tokens after they are released
453   address public beneficiary;
454 
455   // timestamp when token release is enabled
456   uint256 public releaseTime;
457 
458   function TokenTimelock(ERC20Basic _token, address _beneficiary, uint256 _releaseTime) public {
459     // solium-disable-next-line security/no-block-members
460     require(_releaseTime > block.timestamp);
461     token = _token;
462     beneficiary = _beneficiary;
463     releaseTime = _releaseTime;
464   }
465 
466   /**
467    * @notice Transfers tokens held by timelock to beneficiary.
468    */
469   function release() public {
470     // solium-disable-next-line security/no-block-members
471     require(block.timestamp >= releaseTime);
472 
473     uint256 amount = token.balanceOf(this);
474     require(amount > 0);
475 
476     token.safeTransfer(beneficiary, amount);
477   }
478 }
479 
480 // File: contracts/CappedCrowdsale.sol
481 
482 contract CappedCrowdsale is Crowdsale, Ownable {
483     using SafeMath for uint256;
484 
485     uint256 public hardCap;
486     uint256 public tokensToLock;
487     uint256 public releaseTime;
488     bool public isFinalized = false;
489     TokenTimelock public timeLock;
490 
491     event Finalized();
492     event FinishMinting();
493     event TokensMinted(
494         address indexed beneficiary,
495         uint256 indexed amount
496     );
497 
498     function CappedCrowdsale(uint256 _hardCap, uint256 _tokensToLock, uint256 _releaseTime) public {
499         require(_hardCap > 0);
500         require(_tokensToLock > 0);
501         require(_releaseTime > endTime);
502         hardCap = _hardCap;
503         releaseTime = _releaseTime;
504         tokensToLock = _tokensToLock;
505 
506         timeLock = new TokenTimelock(token, wallet, releaseTime);
507     }
508 
509     /**
510      * @dev Must be called after crowdsale ends, to do some extra finalization
511      * work. Calls the contract's finalization function.
512      */
513     function finalize() onlyOwner public {
514         require(!isFinalized);
515 
516         token.mint(address(timeLock), tokensToLock);
517 
518         Finalized();
519         isFinalized = true;
520     }
521 
522     function finishMinting() onlyOwner public {
523         require(token.mintingFinished() == false);
524         require(isFinalized);
525         token.finishMinting();
526 
527         FinishMinting();
528     }
529 
530     function mint(address beneficiary, uint256 amount) onlyOwner public {
531         require(!token.mintingFinished());
532         require(isFinalized);
533         require(amount > 0);
534         require(beneficiary != address(0));
535         token.mint(beneficiary, amount);
536 
537         TokensMinted(beneficiary, amount);
538     }
539 
540     // overriding Crowdsale#hasEnded to add cap logic
541     // @return true if crowdsale event has ended
542     function hasEnded() public view returns (bool) {
543         bool capReached = weiRaised >= hardCap;
544         return super.hasEnded() || capReached || isFinalized;
545     }
546 
547 }
548 
549 // File: contracts/OnlyWhiteListedAddresses.sol
550 
551 contract OnlyWhiteListedAddresses is Ownable {
552     using SafeMath for uint256;
553     address utilityAccount;
554     mapping (address => bool) whitelist;
555     mapping (address => address) public referrals;
556 
557     modifier onlyOwnerOrUtility() {
558         require(msg.sender == owner || msg.sender == utilityAccount);
559         _;
560     }
561 
562     event WhitelistedAddresses(
563         address[] users
564     );
565 
566     event ReferralsAdded(
567         address[] user,
568         address[] referral
569     );
570 
571     function OnlyWhiteListedAddresses(address _utilityAccount) public {
572         utilityAccount = _utilityAccount;
573     }
574 
575     function whitelistAddress (address[] users) public onlyOwnerOrUtility {
576         for (uint i = 0; i < users.length; i++) {
577             whitelist[users[i]] = true;
578         }
579         WhitelistedAddresses(users);
580     }
581 
582     function addAddressReferrals (address[] users, address[] _referrals) public onlyOwnerOrUtility {
583         require(users.length == _referrals.length);
584         for (uint i = 0; i < users.length; i++) {
585             require(isWhiteListedAddress(users[i]));
586 
587             referrals[users[i]] = _referrals[i];
588         }
589         ReferralsAdded(users, _referrals);
590     }
591 
592     function isWhiteListedAddress (address addr) public view returns (bool) {
593         return whitelist[addr];
594     }
595 }
596 
597 // File: contracts/HoldCrowdsale.sol
598 
599 contract HoldCrowdsale is CappedCrowdsale, OnlyWhiteListedAddresses {
600     using SafeMath for uint256;
601 
602     struct TokenPurchaseRecord {
603         uint256 timestamp;
604         uint256 weiAmount;
605         address beneficiary;
606     }
607 
608     uint256 transactionId = 1;
609 
610     mapping (uint256 => TokenPurchaseRecord) pendingTransactions;
611     mapping (uint256 => bool) completedTransactions;
612 
613     uint256 public referralPercentage;
614     uint256 public individualCap;
615 
616     /**
617      * event for token purchase logging
618      * @param transactionId transaction identifier
619      * @param beneficiary who will get the tokens
620      * @param timestamp when the token purchase request was made
621      * @param weiAmount wei invested
622      */
623     event TokenPurchaseRequest(
624         uint256 indexed transactionId,
625         address beneficiary,
626         uint256 indexed timestamp,
627         uint256 indexed weiAmount,
628         uint256 tokensAmount
629     );
630 
631     event ReferralTokensSent(
632         address indexed beneficiary,
633         uint256 indexed tokensAmount,
634         uint256 indexed transactionId
635     );
636 
637     event BonusTokensSent(
638         address indexed beneficiary,
639         uint256 indexed tokensAmount,
640         uint256 indexed transactionId
641     );
642 
643     function HoldCrowdsale(
644         uint256 _startTime,
645         uint256 _endTime,
646         uint256 _icoHardCapWei,
647         uint256 _referralPercentage,
648         uint256 _rate,
649         address _wallet,
650         uint256 _tokensToLock,
651         uint256 _releaseTime,
652         uint256 _privateWeiRaised,
653         uint256 _individualCap,
654         address _utilityAccount
655     ) public
656     OnlyWhiteListedAddresses(_utilityAccount)
657     CappedCrowdsale(_icoHardCapWei, _tokensToLock, _releaseTime)
658     Crowdsale(_startTime, _endTime, _rate, _wallet, _privateWeiRaised)
659     {
660         referralPercentage = _referralPercentage;
661         individualCap = _individualCap;
662     }
663 
664     // fallback function can be used to buy tokens
665     function () external payable {
666         buyTokens(msg.sender);
667     }
668 
669     // low level token purchase function
670     function buyTokens(address beneficiary) public payable {
671         require(!isFinalized);
672         require(beneficiary == msg.sender);
673         require(msg.value != 0);
674         require(msg.value >= individualCap);
675 
676         uint256 weiAmount = msg.value;
677         require(isWhiteListedAddress(beneficiary));
678         require(validPurchase(weiAmount));
679 
680         // update state
681         weiRaised = weiRaised.add(weiAmount);
682 
683         uint256 _transactionId = transactionId;
684         uint256 tokensAmount = weiAmount.mul(rate);
685 
686         pendingTransactions[_transactionId] = TokenPurchaseRecord(now, weiAmount, beneficiary);
687         transactionId += 1;
688 
689 
690         TokenPurchaseRequest(_transactionId, beneficiary, now, weiAmount, tokensAmount);
691         forwardFunds();
692     }
693 
694     function issueTokensMultiple(uint256[] _transactionIds, uint256[] bonusTokensAmounts) public onlyOwner {
695         require(isFinalized);
696         require(_transactionIds.length == bonusTokensAmounts.length);
697         for (uint i = 0; i < _transactionIds.length; i++) {
698             issueTokens(_transactionIds[i], bonusTokensAmounts[i]);
699         }
700     }
701 
702     function issueTokens(uint256 _transactionId, uint256 bonusTokensAmount) internal {
703         require(completedTransactions[_transactionId] != true);
704         require(pendingTransactions[_transactionId].timestamp != 0);
705 
706         TokenPurchaseRecord memory record = pendingTransactions[_transactionId];
707         uint256 tokens = record.weiAmount.mul(rate);
708         address referralAddress = referrals[record.beneficiary];
709 
710         token.mint(record.beneficiary, tokens);
711         TokenPurchase(record.beneficiary, record.weiAmount, tokens, _transactionId);
712 
713         completedTransactions[_transactionId] = true;
714 
715         if (bonusTokensAmount != 0) {
716             require(bonusTokensAmount != 0);
717             token.mint(record.beneficiary, bonusTokensAmount);
718             BonusTokensSent(record.beneficiary, bonusTokensAmount, _transactionId);
719         }
720 
721         if (referralAddress != address(0)) {
722             uint256 referralAmount = tokens.mul(referralPercentage).div(uint256(100));
723             token.mint(referralAddress, referralAmount);
724             ReferralTokensSent(referralAddress, referralAmount, _transactionId);
725         }
726     }
727 
728     function validPurchase(uint256 weiAmount) internal view returns (bool) {
729         bool withinCap = weiRaised.add(weiAmount) <= hardCap;
730         bool withinCrowdsaleInterval = now >= startTime && now <= endTime;
731         return withinCrowdsaleInterval && withinCap;
732     }
733 
734     function forwardFunds() internal {
735         wallet.transfer(msg.value);
736     }
737 }
738 
739 // File: contracts/Migrations.sol
740 
741 contract Migrations {
742   address public owner;
743   uint public last_completed_migration;
744 
745   modifier restricted() {
746     if (msg.sender == owner) _;
747   }
748 
749   function Migrations() public {
750     owner = msg.sender;
751   }
752 
753   function setCompleted(uint completed) public restricted {
754     last_completed_migration = completed;
755   }
756 
757   function upgrade(address new_address) public restricted {
758     Migrations upgraded = Migrations(new_address);
759     upgraded.setCompleted(last_completed_migration);
760   }
761 }