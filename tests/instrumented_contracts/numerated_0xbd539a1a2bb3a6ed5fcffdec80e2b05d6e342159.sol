1 pragma solidity ^0.4.23;
2 
3 // File: contracts/TokenSale.sol
4 
5 contract TokenSale {
6     /**
7     * Buy tokens for the beneficiary using paid Ether.
8     * @param beneficiary the beneficiary address that will receive the tokens.
9     */
10     function buyTokens(address beneficiary) public payable;
11 }
12 
13 // File: contracts/WhitelistableConstraints.sol
14 
15 /**
16  * @title WhitelistableConstraints
17  * @dev Contract encapsulating the constraints applicable to a Whitelistable contract.
18  */
19 contract WhitelistableConstraints {
20 
21     /**
22      * @dev Check if whitelist with specified parameters is allowed.
23      * @param _maxWhitelistLength The maximum length of whitelist. Zero means no whitelist.
24      * @param _weiWhitelistThresholdBalance The threshold balance triggering whitelist check.
25      * @return true if whitelist with specified parameters is allowed, false otherwise
26      */
27     function isAllowedWhitelist(uint256 _maxWhitelistLength, uint256 _weiWhitelistThresholdBalance)
28         public pure returns(bool isReallyAllowedWhitelist) {
29         return _maxWhitelistLength > 0 || _weiWhitelistThresholdBalance > 0;
30     }
31 }
32 
33 // File: contracts/Whitelistable.sol
34 
35 /**
36  * @title Whitelistable
37  * @dev Base contract implementing a whitelist to keep track of investors.
38  * The construction parameters allow for both whitelisted and non-whitelisted contracts:
39  * 1) maxWhitelistLength = 0 and whitelistThresholdBalance > 0: whitelist disabled
40  * 2) maxWhitelistLength > 0 and whitelistThresholdBalance = 0: whitelist enabled, full whitelisting
41  * 3) maxWhitelistLength > 0 and whitelistThresholdBalance > 0: whitelist enabled, partial whitelisting
42  */
43 contract Whitelistable is WhitelistableConstraints {
44 
45     event LogMaxWhitelistLengthChanged(address indexed caller, uint256 indexed maxWhitelistLength);
46     event LogWhitelistThresholdBalanceChanged(address indexed caller, uint256 indexed whitelistThresholdBalance);
47     event LogWhitelistAddressAdded(address indexed caller, address indexed subscriber);
48     event LogWhitelistAddressRemoved(address indexed caller, address indexed subscriber);
49 
50     mapping (address => bool) public whitelist;
51 
52     uint256 public whitelistLength;
53 
54     uint256 public maxWhitelistLength;
55 
56     uint256 public whitelistThresholdBalance;
57 
58     constructor(uint256 _maxWhitelistLength, uint256 _whitelistThresholdBalance) internal {
59         require(isAllowedWhitelist(_maxWhitelistLength, _whitelistThresholdBalance), "parameters not allowed");
60 
61         maxWhitelistLength = _maxWhitelistLength;
62         whitelistThresholdBalance = _whitelistThresholdBalance;
63     }
64 
65     /**
66      * @return true if whitelist is currently enabled, false otherwise
67      */
68     function isWhitelistEnabled() public view returns(bool isReallyWhitelistEnabled) {
69         return maxWhitelistLength > 0;
70     }
71 
72     /**
73      * @return true if subscriber is whitelisted, false otherwise
74      */
75     function isWhitelisted(address _subscriber) public view returns(bool isReallyWhitelisted) {
76         return whitelist[_subscriber];
77     }
78 
79     function setMaxWhitelistLengthInternal(uint256 _maxWhitelistLength) internal {
80         require(isAllowedWhitelist(_maxWhitelistLength, whitelistThresholdBalance),
81             "_maxWhitelistLength not allowed");
82         require(_maxWhitelistLength != maxWhitelistLength, "_maxWhitelistLength equal to current one");
83 
84         maxWhitelistLength = _maxWhitelistLength;
85 
86         emit LogMaxWhitelistLengthChanged(msg.sender, maxWhitelistLength);
87     }
88 
89     function setWhitelistThresholdBalanceInternal(uint256 _whitelistThresholdBalance) internal {
90         require(isAllowedWhitelist(maxWhitelistLength, _whitelistThresholdBalance),
91             "_whitelistThresholdBalance not allowed");
92         require(whitelistLength == 0 || _whitelistThresholdBalance > whitelistThresholdBalance,
93             "_whitelistThresholdBalance not greater than current one");
94 
95         whitelistThresholdBalance = _whitelistThresholdBalance;
96 
97         emit LogWhitelistThresholdBalanceChanged(msg.sender, _whitelistThresholdBalance);
98     }
99 
100     function addToWhitelistInternal(address _subscriber) internal {
101         require(_subscriber != address(0), "_subscriber is zero");
102         require(!whitelist[_subscriber], "already whitelisted");
103         require(whitelistLength < maxWhitelistLength, "max whitelist length reached");
104 
105         whitelistLength++;
106 
107         whitelist[_subscriber] = true;
108 
109         emit LogWhitelistAddressAdded(msg.sender, _subscriber);
110     }
111 
112     function removeFromWhitelistInternal(address _subscriber, uint256 _balance) internal {
113         require(_subscriber != address(0), "_subscriber is zero");
114         require(whitelist[_subscriber], "not whitelisted");
115         require(_balance <= whitelistThresholdBalance, "_balance greater than whitelist threshold");
116 
117         assert(whitelistLength > 0);
118 
119         whitelistLength--;
120 
121         whitelist[_subscriber] = false;
122 
123         emit LogWhitelistAddressRemoved(msg.sender, _subscriber);
124     }
125 
126     /**
127      * @param _subscriber The subscriber for which the balance check is required.
128      * @param _balance The balance value to check for allowance.
129      * @return true if the balance is allowed for the subscriber, false otherwise
130      */
131     function isAllowedBalance(address _subscriber, uint256 _balance) public view returns(bool isReallyAllowed) {
132         return !isWhitelistEnabled() || _balance <= whitelistThresholdBalance || whitelist[_subscriber];
133     }
134 }
135 
136 // File: openzeppelin-solidity/contracts/AddressUtils.sol
137 
138 /**
139  * Utility library of inline functions on addresses
140  */
141 library AddressUtils {
142 
143   /**
144    * Returns whether the target address is a contract
145    * @dev This function will return false if invoked during the constructor of a contract,
146    *  as the code is not actually created until after the constructor finishes.
147    * @param addr address to check
148    * @return whether the target address is a contract
149    */
150   function isContract(address addr) internal view returns (bool) {
151     uint256 size;
152     // XXX Currently there is no better way to check if there is a contract in an address
153     // than to check the size of the code at that address.
154     // See https://ethereum.stackexchange.com/a/14016/36603
155     // for more details about how this works.
156     // TODO Check this again before the Serenity release, because all addresses will be
157     // contracts then.
158     // solium-disable-next-line security/no-inline-assembly
159     assembly { size := extcodesize(addr) }
160     return size > 0;
161   }
162 
163 }
164 
165 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
166 
167 /**
168  * @title Ownable
169  * @dev The Ownable contract has an owner address, and provides basic authorization control
170  * functions, this simplifies the implementation of "user permissions".
171  */
172 contract Ownable {
173   address public owner;
174 
175 
176   event OwnershipRenounced(address indexed previousOwner);
177   event OwnershipTransferred(
178     address indexed previousOwner,
179     address indexed newOwner
180   );
181 
182 
183   /**
184    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
185    * account.
186    */
187   constructor() public {
188     owner = msg.sender;
189   }
190 
191   /**
192    * @dev Throws if called by any account other than the owner.
193    */
194   modifier onlyOwner() {
195     require(msg.sender == owner);
196     _;
197   }
198 
199   /**
200    * @dev Allows the current owner to relinquish control of the contract.
201    */
202   function renounceOwnership() public onlyOwner {
203     emit OwnershipRenounced(owner);
204     owner = address(0);
205   }
206 
207   /**
208    * @dev Allows the current owner to transfer control of the contract to a newOwner.
209    * @param _newOwner The address to transfer ownership to.
210    */
211   function transferOwnership(address _newOwner) public onlyOwner {
212     _transferOwnership(_newOwner);
213   }
214 
215   /**
216    * @dev Transfers control of the contract to a newOwner.
217    * @param _newOwner The address to transfer ownership to.
218    */
219   function _transferOwnership(address _newOwner) internal {
220     require(_newOwner != address(0));
221     emit OwnershipTransferred(owner, _newOwner);
222     owner = _newOwner;
223   }
224 }
225 
226 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
227 
228 /**
229  * @title Pausable
230  * @dev Base contract which allows children to implement an emergency stop mechanism.
231  */
232 contract Pausable is Ownable {
233   event Pause();
234   event Unpause();
235 
236   bool public paused = false;
237 
238 
239   /**
240    * @dev Modifier to make a function callable only when the contract is not paused.
241    */
242   modifier whenNotPaused() {
243     require(!paused);
244     _;
245   }
246 
247   /**
248    * @dev Modifier to make a function callable only when the contract is paused.
249    */
250   modifier whenPaused() {
251     require(paused);
252     _;
253   }
254 
255   /**
256    * @dev called by the owner to pause, triggers stopped state
257    */
258   function pause() onlyOwner whenNotPaused public {
259     paused = true;
260     emit Pause();
261   }
262 
263   /**
264    * @dev called by the owner to unpause, returns to normal state
265    */
266   function unpause() onlyOwner whenPaused public {
267     paused = false;
268     emit Unpause();
269   }
270 }
271 
272 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
273 
274 /**
275  * @title SafeMath
276  * @dev Math operations with safety checks that throw on error
277  */
278 library SafeMath {
279 
280   /**
281   * @dev Multiplies two numbers, throws on overflow.
282   */
283   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
284     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
285     // benefit is lost if 'b' is also tested.
286     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
287     if (a == 0) {
288       return 0;
289     }
290 
291     c = a * b;
292     assert(c / a == b);
293     return c;
294   }
295 
296   /**
297   * @dev Integer division of two numbers, truncating the quotient.
298   */
299   function div(uint256 a, uint256 b) internal pure returns (uint256) {
300     // assert(b > 0); // Solidity automatically throws when dividing by 0
301     // uint256 c = a / b;
302     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
303     return a / b;
304   }
305 
306   /**
307   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
308   */
309   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
310     assert(b <= a);
311     return a - b;
312   }
313 
314   /**
315   * @dev Adds two numbers, throws on overflow.
316   */
317   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
318     c = a + b;
319     assert(c >= a);
320     return c;
321   }
322 }
323 
324 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
325 
326 /**
327  * @title ERC20Basic
328  * @dev Simpler version of ERC20 interface
329  * @dev see https://github.com/ethereum/EIPs/issues/179
330  */
331 contract ERC20Basic {
332   function totalSupply() public view returns (uint256);
333   function balanceOf(address who) public view returns (uint256);
334   function transfer(address to, uint256 value) public returns (bool);
335   event Transfer(address indexed from, address indexed to, uint256 value);
336 }
337 
338 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
339 
340 /**
341  * @title Basic token
342  * @dev Basic version of StandardToken, with no allowances.
343  */
344 contract BasicToken is ERC20Basic {
345   using SafeMath for uint256;
346 
347   mapping(address => uint256) balances;
348 
349   uint256 totalSupply_;
350 
351   /**
352   * @dev total number of tokens in existence
353   */
354   function totalSupply() public view returns (uint256) {
355     return totalSupply_;
356   }
357 
358   /**
359   * @dev transfer token for a specified address
360   * @param _to The address to transfer to.
361   * @param _value The amount to be transferred.
362   */
363   function transfer(address _to, uint256 _value) public returns (bool) {
364     require(_to != address(0));
365     require(_value <= balances[msg.sender]);
366 
367     balances[msg.sender] = balances[msg.sender].sub(_value);
368     balances[_to] = balances[_to].add(_value);
369     emit Transfer(msg.sender, _to, _value);
370     return true;
371   }
372 
373   /**
374   * @dev Gets the balance of the specified address.
375   * @param _owner The address to query the the balance of.
376   * @return An uint256 representing the amount owned by the passed address.
377   */
378   function balanceOf(address _owner) public view returns (uint256) {
379     return balances[_owner];
380   }
381 
382 }
383 
384 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
385 
386 /**
387  * @title ERC20 interface
388  * @dev see https://github.com/ethereum/EIPs/issues/20
389  */
390 contract ERC20 is ERC20Basic {
391   function allowance(address owner, address spender)
392     public view returns (uint256);
393 
394   function transferFrom(address from, address to, uint256 value)
395     public returns (bool);
396 
397   function approve(address spender, uint256 value) public returns (bool);
398   event Approval(
399     address indexed owner,
400     address indexed spender,
401     uint256 value
402   );
403 }
404 
405 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
406 
407 /**
408  * @title Standard ERC20 token
409  *
410  * @dev Implementation of the basic standard token.
411  * @dev https://github.com/ethereum/EIPs/issues/20
412  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
413  */
414 contract StandardToken is ERC20, BasicToken {
415 
416   mapping (address => mapping (address => uint256)) internal allowed;
417 
418 
419   /**
420    * @dev Transfer tokens from one address to another
421    * @param _from address The address which you want to send tokens from
422    * @param _to address The address which you want to transfer to
423    * @param _value uint256 the amount of tokens to be transferred
424    */
425   function transferFrom(
426     address _from,
427     address _to,
428     uint256 _value
429   )
430     public
431     returns (bool)
432   {
433     require(_to != address(0));
434     require(_value <= balances[_from]);
435     require(_value <= allowed[_from][msg.sender]);
436 
437     balances[_from] = balances[_from].sub(_value);
438     balances[_to] = balances[_to].add(_value);
439     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
440     emit Transfer(_from, _to, _value);
441     return true;
442   }
443 
444   /**
445    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
446    *
447    * Beware that changing an allowance with this method brings the risk that someone may use both the old
448    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
449    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
450    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
451    * @param _spender The address which will spend the funds.
452    * @param _value The amount of tokens to be spent.
453    */
454   function approve(address _spender, uint256 _value) public returns (bool) {
455     allowed[msg.sender][_spender] = _value;
456     emit Approval(msg.sender, _spender, _value);
457     return true;
458   }
459 
460   /**
461    * @dev Function to check the amount of tokens that an owner allowed to a spender.
462    * @param _owner address The address which owns the funds.
463    * @param _spender address The address which will spend the funds.
464    * @return A uint256 specifying the amount of tokens still available for the spender.
465    */
466   function allowance(
467     address _owner,
468     address _spender
469    )
470     public
471     view
472     returns (uint256)
473   {
474     return allowed[_owner][_spender];
475   }
476 
477   /**
478    * @dev Increase the amount of tokens that an owner allowed to a spender.
479    *
480    * approve should be called when allowed[_spender] == 0. To increment
481    * allowed value is better to use this function to avoid 2 calls (and wait until
482    * the first transaction is mined)
483    * From MonolithDAO Token.sol
484    * @param _spender The address which will spend the funds.
485    * @param _addedValue The amount of tokens to increase the allowance by.
486    */
487   function increaseApproval(
488     address _spender,
489     uint _addedValue
490   )
491     public
492     returns (bool)
493   {
494     allowed[msg.sender][_spender] = (
495       allowed[msg.sender][_spender].add(_addedValue));
496     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
497     return true;
498   }
499 
500   /**
501    * @dev Decrease the amount of tokens that an owner allowed to a spender.
502    *
503    * approve should be called when allowed[_spender] == 0. To decrement
504    * allowed value is better to use this function to avoid 2 calls (and wait until
505    * the first transaction is mined)
506    * From MonolithDAO Token.sol
507    * @param _spender The address which will spend the funds.
508    * @param _subtractedValue The amount of tokens to decrease the allowance by.
509    */
510   function decreaseApproval(
511     address _spender,
512     uint _subtractedValue
513   )
514     public
515     returns (bool)
516   {
517     uint oldValue = allowed[msg.sender][_spender];
518     if (_subtractedValue > oldValue) {
519       allowed[msg.sender][_spender] = 0;
520     } else {
521       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
522     }
523     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
524     return true;
525   }
526 
527 }
528 
529 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
530 
531 /**
532  * @title Mintable token
533  * @dev Simple ERC20 Token example, with mintable token creation
534  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
535  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
536  */
537 contract MintableToken is StandardToken, Ownable {
538   event Mint(address indexed to, uint256 amount);
539   event MintFinished();
540 
541   bool public mintingFinished = false;
542 
543 
544   modifier canMint() {
545     require(!mintingFinished);
546     _;
547   }
548 
549   modifier hasMintPermission() {
550     require(msg.sender == owner);
551     _;
552   }
553 
554   /**
555    * @dev Function to mint tokens
556    * @param _to The address that will receive the minted tokens.
557    * @param _amount The amount of tokens to mint.
558    * @return A boolean that indicates if the operation was successful.
559    */
560   function mint(
561     address _to,
562     uint256 _amount
563   )
564     hasMintPermission
565     canMint
566     public
567     returns (bool)
568   {
569     totalSupply_ = totalSupply_.add(_amount);
570     balances[_to] = balances[_to].add(_amount);
571     emit Mint(_to, _amount);
572     emit Transfer(address(0), _to, _amount);
573     return true;
574   }
575 
576   /**
577    * @dev Function to stop minting new tokens.
578    * @return True if the operation was successful.
579    */
580   function finishMinting() onlyOwner canMint public returns (bool) {
581     mintingFinished = true;
582     emit MintFinished();
583     return true;
584   }
585 }
586 
587 // File: contracts/Crowdsale.sol
588 
589 /**
590  * @title Crowdsale 
591  * @dev Crowdsale is a base contract for managing a token crowdsale.
592  * Crowdsales have a start and end block, where investors can make
593  * token purchases and the crowdsale will assign them tokens based
594  * on a token per ETH rate. Funds collected are forwarded to a wallet 
595  * as they arrive.
596  */
597 contract Crowdsale is TokenSale, Pausable, Whitelistable {
598     using AddressUtils for address;
599     using SafeMath for uint256;
600 
601     event LogStartBlockChanged(uint256 indexed startBlock);
602     event LogEndBlockChanged(uint256 indexed endBlock);
603     event LogMinDepositChanged(uint256 indexed minDeposit);
604     event LogTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 indexed amount, uint256 tokenAmount);
605 
606     // The token being sold
607     MintableToken public token;
608 
609     // The start and end block where investments are allowed (both inclusive)
610     uint256 public startBlock;
611     uint256 public endBlock;
612 
613     // How many token units a buyer gets per wei
614     uint256 public rate;
615 
616     // Amount of raised money in wei
617     uint256 public raisedFunds;
618 
619     // Amount of tokens already sold
620     uint256 public soldTokens;
621 
622     // Balances in wei deposited by each subscriber
623     mapping (address => uint256) public balanceOf;
624 
625     // The minimum balance for each subscriber in wei
626     uint256 public minDeposit;
627 
628     modifier beforeStart() {
629         require(block.number < startBlock, "already started");
630         _;
631     }
632 
633     modifier beforeEnd() {
634         require(block.number <= endBlock, "already ended");
635         _;
636     }
637 
638     constructor(
639         uint256 _startBlock,
640         uint256 _endBlock,
641         uint256 _rate,
642         uint256 _minDeposit,
643         uint256 maxWhitelistLength,
644         uint256 whitelistThreshold
645     )
646     Whitelistable(maxWhitelistLength, whitelistThreshold) internal
647     {
648         require(_startBlock >= block.number, "_startBlock is lower than current block.number");
649         require(_endBlock >= _startBlock, "_endBlock is lower than _startBlock");
650         require(_rate > 0, "_rate is zero");
651         require(_minDeposit > 0, "_minDeposit is zero");
652 
653         startBlock = _startBlock;
654         endBlock = _endBlock;
655         rate = _rate;
656         minDeposit = _minDeposit;
657     }
658 
659     /*
660     * @return true if crowdsale event has started
661     */
662     function hasStarted() public view returns (bool started) {
663         return block.number >= startBlock;
664     }
665 
666     /*
667     * @return true if crowdsale event has ended
668     */
669     function hasEnded() public view returns (bool ended) {
670         return block.number > endBlock;
671     }
672 
673     /**
674      * Change the crowdsale start block number.
675      * @param _startBlock The new start block
676      */
677     function setStartBlock(uint256 _startBlock) external onlyOwner beforeStart {
678         require(_startBlock >= block.number, "_startBlock < current block");
679         require(_startBlock <= endBlock, "_startBlock > endBlock");
680         require(_startBlock != startBlock, "_startBlock == startBlock");
681 
682         startBlock = _startBlock;
683 
684         emit LogStartBlockChanged(_startBlock);
685     }
686 
687     /**
688      * Change the crowdsale end block number.
689      * @param _endBlock The new end block
690      */
691     function setEndBlock(uint256 _endBlock) external onlyOwner beforeEnd {
692         require(_endBlock >= block.number, "_endBlock < current block");
693         require(_endBlock >= startBlock, "_endBlock < startBlock");
694         require(_endBlock != endBlock, "_endBlock == endBlock");
695 
696         endBlock = _endBlock;
697 
698         emit LogEndBlockChanged(_endBlock);
699     }
700 
701     /**
702      * Change the minimum deposit for each subscriber. New value shall be lower than previous.
703      * @param _minDeposit The minimum deposit for each subscriber, expressed in wei
704      */
705     function setMinDeposit(uint256 _minDeposit) external onlyOwner beforeEnd {
706         require(0 < _minDeposit && _minDeposit < minDeposit, "_minDeposit is not in [0, minDeposit]");
707 
708         minDeposit = _minDeposit;
709 
710         emit LogMinDepositChanged(minDeposit);
711     }
712 
713     /**
714      * Change the maximum whitelist length. New value shall satisfy the #isAllowedWhitelist conditions.
715      * @param maxWhitelistLength The maximum whitelist length
716      */
717     function setMaxWhitelistLength(uint256 maxWhitelistLength) external onlyOwner beforeEnd {
718         setMaxWhitelistLengthInternal(maxWhitelistLength);
719     }
720 
721     /**
722      * Change the whitelist threshold balance. New value shall satisfy the #isAllowedWhitelist conditions.
723      * @param whitelistThreshold The threshold balance (in wei) above which whitelisting is required to invest
724      */
725     function setWhitelistThresholdBalance(uint256 whitelistThreshold) external onlyOwner beforeEnd {
726         setWhitelistThresholdBalanceInternal(whitelistThreshold);
727     }
728 
729     /**
730      * Add the subscriber to the whitelist.
731      * @param subscriber The subscriber to add to the whitelist.
732      */
733     function addToWhitelist(address subscriber) external onlyOwner beforeEnd {
734         addToWhitelistInternal(subscriber);
735     }
736 
737     /**
738      * Removed the subscriber from the whitelist.
739      * @param subscriber The subscriber to remove from the whitelist.
740      */
741     function removeFromWhitelist(address subscriber) external onlyOwner beforeEnd {
742         removeFromWhitelistInternal(subscriber, balanceOf[subscriber]);
743     }
744 
745     // fallback function can be used to buy tokens
746     function () external payable whenNotPaused {
747         buyTokens(msg.sender);
748     }
749 
750     // low level token purchase function
751     function buyTokens(address beneficiary) public payable whenNotPaused {
752         require(beneficiary != address(0), "beneficiary is zero");
753         require(isValidPurchase(beneficiary), "invalid purchase by beneficiary");
754 
755         balanceOf[beneficiary] = balanceOf[beneficiary].add(msg.value);
756 
757         raisedFunds = raisedFunds.add(msg.value);
758 
759         uint256 tokenAmount = calculateTokens(msg.value);
760 
761         soldTokens = soldTokens.add(tokenAmount);
762 
763         distributeTokens(beneficiary, tokenAmount);
764 
765         emit LogTokenPurchase(msg.sender, beneficiary, msg.value, tokenAmount);
766 
767         forwardFunds(msg.value);
768     }
769 
770     /**
771      * @dev Overrides Whitelistable#isAllowedBalance to add minimum deposit logic.
772      */
773     function isAllowedBalance(address beneficiary, uint256 balance) public view returns (bool isReallyAllowed) {
774         bool hasMinimumBalance = balance >= minDeposit;
775         return hasMinimumBalance && super.isAllowedBalance(beneficiary, balance);
776     }
777 
778     /**
779      * @dev Determine if the token purchase is valid or not.
780      * @return true if the transaction can buy tokens
781      */
782     function isValidPurchase(address beneficiary) internal view returns (bool isValid) {
783         bool withinPeriod = startBlock <= block.number && block.number <= endBlock;
784         bool nonZeroPurchase = msg.value != 0;
785         bool isValidBalance = isAllowedBalance(beneficiary, balanceOf[beneficiary].add(msg.value));
786 
787         return withinPeriod && nonZeroPurchase && isValidBalance;
788     }
789 
790     // Calculate the token amount given the invested ether amount.
791     // Override to create custom fund forwarding mechanisms
792     function calculateTokens(uint256 amount) internal view returns (uint256 tokenAmount) {
793         return amount.mul(rate);
794     }
795 
796     /**
797      * @dev Distribute the token amount to the beneficiary.
798      * @notice Override to create custom distribution mechanisms
799      */
800     function distributeTokens(address beneficiary, uint256 tokenAmount) internal {
801         token.mint(beneficiary, tokenAmount);
802     }
803 
804     // Send ether amount to the fund collection wallet.
805     // override to create custom fund forwarding mechanisms
806     function forwardFunds(uint256 amount) internal;
807 }
808 
809 // File: contracts/NokuPricingPlan.sol
810 
811 /**
812 * @dev The NokuPricingPlan contract defines the responsibilities of a Noku pricing plan.
813 */
814 contract NokuPricingPlan {
815     /**
816     * @dev Pay the fee for the service identified by the specified name.
817     * The fee amount shall already be approved by the client.
818     * @param serviceName The name of the target service.
819     * @param multiplier The multiplier of the base service fee to apply.
820     * @param client The client of the target service.
821     * @return true if fee has been paid.
822     */
823     function payFee(bytes32 serviceName, uint256 multiplier, address client) public returns(bool paid);
824 
825     /**
826     * @dev Get the usage fee for the service identified by the specified name.
827     * The returned fee amount shall be approved before using #payFee method.
828     * @param serviceName The name of the target service.
829     * @param multiplier The multiplier of the base service fee to apply.
830     * @return The amount to approve before really paying such fee.
831     */
832     function usageFee(bytes32 serviceName, uint256 multiplier) public view returns(uint fee);
833 }
834 
835 // File: contracts/NokuCustomToken.sol
836 
837 contract NokuCustomToken is Ownable {
838 
839     event LogBurnFinished();
840     event LogPricingPlanChanged(address indexed caller, address indexed pricingPlan);
841 
842     // The pricing plan determining the fee to be paid in NOKU tokens by customers for using Noku services
843     NokuPricingPlan public pricingPlan;
844 
845     // The entity acting as Custom Token service provider i.e. Noku
846     address public serviceProvider;
847 
848     // Flag indicating if Custom Token burning has been permanently finished or not.
849     bool public burningFinished;
850 
851     /**
852     * @dev Modifier to make a function callable only by service provider i.e. Noku.
853     */
854     modifier onlyServiceProvider() {
855         require(msg.sender == serviceProvider, "caller is not service provider");
856         _;
857     }
858 
859     modifier canBurn() {
860         require(!burningFinished, "burning finished");
861         _;
862     }
863 
864     constructor(address _pricingPlan, address _serviceProvider) internal {
865         require(_pricingPlan != 0, "_pricingPlan is zero");
866         require(_serviceProvider != 0, "_serviceProvider is zero");
867 
868         pricingPlan = NokuPricingPlan(_pricingPlan);
869         serviceProvider = _serviceProvider;
870     }
871 
872     /**
873     * @dev Presence of this function indicates the contract is a Custom Token.
874     */
875     function isCustomToken() public pure returns(bool isCustom) {
876         return true;
877     }
878 
879     /**
880     * @dev Stop burning new tokens.
881     * @return true if the operation was successful.
882     */
883     function finishBurning() public onlyOwner canBurn returns(bool finished) {
884         burningFinished = true;
885 
886         emit LogBurnFinished();
887 
888         return true;
889     }
890 
891     /**
892     * @dev Change the pricing plan of service fee to be paid in NOKU tokens.
893     * @param _pricingPlan The pricing plan of NOKU token to be paid, zero means flat subscription.
894     */
895     function setPricingPlan(address _pricingPlan) public onlyServiceProvider {
896         require(_pricingPlan != 0, "_pricingPlan is 0");
897         require(_pricingPlan != address(pricingPlan), "_pricingPlan == pricingPlan");
898 
899         pricingPlan = NokuPricingPlan(_pricingPlan);
900 
901         emit LogPricingPlanChanged(msg.sender, _pricingPlan);
902     }
903 }
904 
905 // File: contracts/NokuTokenBurner.sol
906 
907 contract BurnableERC20 is ERC20 {
908     function burn(uint256 amount) public returns (bool burned);
909 }
910 
911 /**
912 * @dev The NokuTokenBurner contract has the responsibility to burn the configured fraction of received
913 * ERC20-compliant tokens and distribute the remainder to the configured wallet.
914 */
915 contract NokuTokenBurner is Pausable {
916     using SafeMath for uint256;
917 
918     event LogNokuTokenBurnerCreated(address indexed caller, address indexed wallet);
919     event LogBurningPercentageChanged(address indexed caller, uint256 indexed burningPercentage);
920 
921     // The wallet receiving the unburnt tokens.
922     address public wallet;
923 
924     // The percentage of tokens to burn after being received (range [0, 100])
925     uint256 public burningPercentage;
926 
927     // The cumulative amount of burnt tokens.
928     uint256 public burnedTokens;
929 
930     // The cumulative amount of tokens transferred back to the wallet.
931     uint256 public transferredTokens;
932 
933     /**
934     * @dev Create a new NokuTokenBurner with predefined burning fraction.
935     * @param _wallet The wallet receiving the unburnt tokens.
936     */
937     constructor(address _wallet) public {
938         require(_wallet != address(0), "_wallet is zero");
939         
940         wallet = _wallet;
941         burningPercentage = 100;
942 
943         emit LogNokuTokenBurnerCreated(msg.sender, _wallet);
944     }
945 
946     /**
947     * @dev Change the percentage of tokens to burn after being received.
948     * @param _burningPercentage The percentage of tokens to be burnt.
949     */
950     function setBurningPercentage(uint256 _burningPercentage) public onlyOwner {
951         require(0 <= _burningPercentage && _burningPercentage <= 100, "_burningPercentage not in [0, 100]");
952         require(_burningPercentage != burningPercentage, "_burningPercentage equal to current one");
953         
954         burningPercentage = _burningPercentage;
955 
956         emit LogBurningPercentageChanged(msg.sender, _burningPercentage);
957     }
958 
959     /**
960     * @dev Called after burnable tokens has been transferred for burning.
961     * @param _token THe extended ERC20 interface supported by the sent tokens.
962     * @param _amount The amount of burnable tokens just arrived ready for burning.
963     */
964     function tokenReceived(address _token, uint256 _amount) public whenNotPaused {
965         require(_token != address(0), "_token is zero");
966         require(_amount > 0, "_amount is zero");
967 
968         uint256 amountToBurn = _amount.mul(burningPercentage).div(100);
969         if (amountToBurn > 0) {
970             assert(BurnableERC20(_token).burn(amountToBurn));
971             
972             burnedTokens = burnedTokens.add(amountToBurn);
973         }
974 
975         uint256 amountToTransfer = _amount.sub(amountToBurn);
976         if (amountToTransfer > 0) {
977             assert(BurnableERC20(_token).transfer(wallet, amountToTransfer));
978 
979             transferredTokens = transferredTokens.add(amountToTransfer);
980         }
981     }
982 }
983 
984 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
985 
986 /**
987  * @title Burnable Token
988  * @dev Token that can be irreversibly burned (destroyed).
989  */
990 contract BurnableToken is BasicToken {
991 
992   event Burn(address indexed burner, uint256 value);
993 
994   /**
995    * @dev Burns a specific amount of tokens.
996    * @param _value The amount of token to be burned.
997    */
998   function burn(uint256 _value) public {
999     _burn(msg.sender, _value);
1000   }
1001 
1002   function _burn(address _who, uint256 _value) internal {
1003     require(_value <= balances[_who]);
1004     // no need to require value <= totalSupply, since that would imply the
1005     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1006 
1007     balances[_who] = balances[_who].sub(_value);
1008     totalSupply_ = totalSupply_.sub(_value);
1009     emit Burn(_who, _value);
1010     emit Transfer(_who, address(0), _value);
1011   }
1012 }
1013 
1014 // File: openzeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
1015 
1016 /**
1017  * @title DetailedERC20 token
1018  * @dev The decimals are only for visualization purposes.
1019  * All the operations are done using the smallest and indivisible token unit,
1020  * just as on Ethereum all the operations are done in wei.
1021  */
1022 contract DetailedERC20 is ERC20 {
1023   string public name;
1024   string public symbol;
1025   uint8 public decimals;
1026 
1027   constructor(string _name, string _symbol, uint8 _decimals) public {
1028     name = _name;
1029     symbol = _symbol;
1030     decimals = _decimals;
1031   }
1032 }
1033 
1034 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
1035 
1036 /**
1037  * @title SafeERC20
1038  * @dev Wrappers around ERC20 operations that throw on failure.
1039  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1040  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1041  */
1042 library SafeERC20 {
1043   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
1044     require(token.transfer(to, value));
1045   }
1046 
1047   function safeTransferFrom(
1048     ERC20 token,
1049     address from,
1050     address to,
1051     uint256 value
1052   )
1053     internal
1054   {
1055     require(token.transferFrom(from, to, value));
1056   }
1057 
1058   function safeApprove(ERC20 token, address spender, uint256 value) internal {
1059     require(token.approve(spender, value));
1060   }
1061 }
1062 
1063 // File: openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
1064 
1065 /**
1066  * @title TokenTimelock
1067  * @dev TokenTimelock is a token holder contract that will allow a
1068  * beneficiary to extract the tokens after a given release time
1069  */
1070 contract TokenTimelock {
1071   using SafeERC20 for ERC20Basic;
1072 
1073   // ERC20 basic token contract being held
1074   ERC20Basic public token;
1075 
1076   // beneficiary of tokens after they are released
1077   address public beneficiary;
1078 
1079   // timestamp when token release is enabled
1080   uint256 public releaseTime;
1081 
1082   constructor(
1083     ERC20Basic _token,
1084     address _beneficiary,
1085     uint256 _releaseTime
1086   )
1087     public
1088   {
1089     // solium-disable-next-line security/no-block-members
1090     require(_releaseTime > block.timestamp);
1091     token = _token;
1092     beneficiary = _beneficiary;
1093     releaseTime = _releaseTime;
1094   }
1095 
1096   /**
1097    * @notice Transfers tokens held by timelock to beneficiary.
1098    */
1099   function release() public {
1100     // solium-disable-next-line security/no-block-members
1101     require(block.timestamp >= releaseTime);
1102 
1103     uint256 amount = token.balanceOf(this);
1104     require(amount > 0);
1105 
1106     token.safeTransfer(beneficiary, amount);
1107   }
1108 }
1109 
1110 // File: openzeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
1111 
1112 /* solium-disable security/no-block-members */
1113 
1114 pragma solidity ^0.4.23;
1115 
1116 
1117 
1118 
1119 
1120 
1121 /**
1122  * @title TokenVesting
1123  * @dev A token holder contract that can release its token balance gradually like a
1124  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
1125  * owner.
1126  */
1127 contract TokenVesting is Ownable {
1128   using SafeMath for uint256;
1129   using SafeERC20 for ERC20Basic;
1130 
1131   event Released(uint256 amount);
1132   event Revoked();
1133 
1134   // beneficiary of tokens after they are released
1135   address public beneficiary;
1136 
1137   uint256 public cliff;
1138   uint256 public start;
1139   uint256 public duration;
1140 
1141   bool public revocable;
1142 
1143   mapping (address => uint256) public released;
1144   mapping (address => bool) public revoked;
1145 
1146   /**
1147    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
1148    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
1149    * of the balance will have vested.
1150    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
1151    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
1152    * @param _start the time (as Unix time) at which point vesting starts 
1153    * @param _duration duration in seconds of the period in which the tokens will vest
1154    * @param _revocable whether the vesting is revocable or not
1155    */
1156   constructor(
1157     address _beneficiary,
1158     uint256 _start,
1159     uint256 _cliff,
1160     uint256 _duration,
1161     bool _revocable
1162   )
1163     public
1164   {
1165     require(_beneficiary != address(0));
1166     require(_cliff <= _duration);
1167 
1168     beneficiary = _beneficiary;
1169     revocable = _revocable;
1170     duration = _duration;
1171     cliff = _start.add(_cliff);
1172     start = _start;
1173   }
1174 
1175   /**
1176    * @notice Transfers vested tokens to beneficiary.
1177    * @param token ERC20 token which is being vested
1178    */
1179   function release(ERC20Basic token) public {
1180     uint256 unreleased = releasableAmount(token);
1181 
1182     require(unreleased > 0);
1183 
1184     released[token] = released[token].add(unreleased);
1185 
1186     token.safeTransfer(beneficiary, unreleased);
1187 
1188     emit Released(unreleased);
1189   }
1190 
1191   /**
1192    * @notice Allows the owner to revoke the vesting. Tokens already vested
1193    * remain in the contract, the rest are returned to the owner.
1194    * @param token ERC20 token which is being vested
1195    */
1196   function revoke(ERC20Basic token) public onlyOwner {
1197     require(revocable);
1198     require(!revoked[token]);
1199 
1200     uint256 balance = token.balanceOf(this);
1201 
1202     uint256 unreleased = releasableAmount(token);
1203     uint256 refund = balance.sub(unreleased);
1204 
1205     revoked[token] = true;
1206 
1207     token.safeTransfer(owner, refund);
1208 
1209     emit Revoked();
1210   }
1211 
1212   /**
1213    * @dev Calculates the amount that has already vested but hasn't been released yet.
1214    * @param token ERC20 token which is being vested
1215    */
1216   function releasableAmount(ERC20Basic token) public view returns (uint256) {
1217     return vestedAmount(token).sub(released[token]);
1218   }
1219 
1220   /**
1221    * @dev Calculates the amount that has already vested.
1222    * @param token ERC20 token which is being vested
1223    */
1224   function vestedAmount(ERC20Basic token) public view returns (uint256) {
1225     uint256 currentBalance = token.balanceOf(this);
1226     uint256 totalBalance = currentBalance.add(released[token]);
1227 
1228     if (block.timestamp < cliff) {
1229       return 0;
1230     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
1231       return totalBalance;
1232     } else {
1233       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
1234     }
1235   }
1236 }
1237 
1238 // File: contracts/NokuCustomERC20.sol
1239 
1240 /**
1241 * @dev The NokuCustomERC20Token contract is a custom ERC20-compliant token available in the Noku Service Platform (NSP).
1242 * The Noku customer is able to choose the token name, symbol, decimals, initial supply and to administer its lifecycle
1243 * by minting or burning tokens in order to increase or decrease the token supply.
1244 */
1245 contract NokuCustomERC20 is NokuCustomToken, DetailedERC20, MintableToken, BurnableToken {
1246     using SafeMath for uint256;
1247 
1248     event LogNokuCustomERC20Created(
1249         address indexed caller,
1250         string indexed name,
1251         string indexed symbol,
1252         uint8 decimals,
1253         uint256 transferableFromBlock,
1254         uint256 lockEndBlock,
1255         address pricingPlan,
1256         address serviceProvider
1257     );
1258     event LogMintingFeeEnabledChanged(address indexed caller, bool indexed mintingFeeEnabled);
1259     event LogInformationChanged(address indexed caller, string name, string symbol);
1260     event LogTransferFeePaymentFinished(address indexed caller);
1261     event LogTransferFeePercentageChanged(address indexed caller, uint256 indexed transferFeePercentage);
1262 
1263     // Flag indicating if minting fees are enabled or disabled
1264     bool public mintingFeeEnabled;
1265 
1266     // Block number from which tokens are initially transferable
1267     uint256 public transferableFromBlock;
1268 
1269     // Block number from which initial lock ends
1270     uint256 public lockEndBlock;
1271 
1272     // The initially locked balances by address
1273     mapping (address => uint256) public initiallyLockedBalanceOf;
1274 
1275     // The fee percentage for Custom Token transfer or zero if transfer is free of charge
1276     uint256 public transferFeePercentage;
1277 
1278     // Flag indicating if fee payment in Custom Token transfer has been permanently finished or not. 
1279     bool public transferFeePaymentFinished;
1280 
1281     // Address of optional Timelock smart contract, otherwise 0x0
1282     TokenTimelock public timelock;
1283 
1284     // Address of optional Vesting smart contract, otherwise 0x0
1285     TokenVesting public vesting;
1286 
1287     bytes32 public constant BURN_SERVICE_NAME     = "NokuCustomERC20.burn";
1288     bytes32 public constant MINT_SERVICE_NAME     = "NokuCustomERC20.mint";
1289     bytes32 public constant TIMELOCK_SERVICE_NAME = "NokuCustomERC20.timelock";
1290     bytes32 public constant VESTING_SERVICE_NAME  = "NokuCustomERC20.vesting";
1291 
1292     modifier canTransfer(address _from, uint _value) {
1293         require(block.number >= transferableFromBlock, "token not transferable");
1294 
1295         if (block.number < lockEndBlock) {
1296             uint256 locked = lockedBalanceOf(_from);
1297             if (locked > 0) {
1298                 uint256 newBalance = balanceOf(_from).sub(_value);
1299                 require(newBalance >= locked, "_value exceeds locked amount");
1300             }
1301         }
1302         _;
1303     }
1304 
1305     constructor(
1306         string _name,
1307         string _symbol,
1308         uint8 _decimals,
1309         uint256 _transferableFromBlock,
1310         uint256 _lockEndBlock,
1311         address _pricingPlan,
1312         address _serviceProvider
1313     )
1314     NokuCustomToken(_pricingPlan, _serviceProvider)
1315     DetailedERC20(_name, _symbol, _decimals) public
1316     {
1317         require(bytes(_name).length > 0, "_name is empty");
1318         require(bytes(_symbol).length > 0, "_symbol is empty");
1319         require(_lockEndBlock >= _transferableFromBlock, "_lockEndBlock lower than _transferableFromBlock");
1320 
1321         transferableFromBlock = _transferableFromBlock;
1322         lockEndBlock = _lockEndBlock;
1323         mintingFeeEnabled = true;
1324 
1325         emit LogNokuCustomERC20Created(
1326             msg.sender,
1327             _name,
1328             _symbol,
1329             _decimals,
1330             _transferableFromBlock,
1331             _lockEndBlock,
1332             _pricingPlan,
1333             _serviceProvider
1334         );
1335     }
1336 
1337     function setMintingFeeEnabled(bool _mintingFeeEnabled) public onlyOwner returns(bool successful) {
1338         require(_mintingFeeEnabled != mintingFeeEnabled, "_mintingFeeEnabled == mintingFeeEnabled");
1339 
1340         mintingFeeEnabled = _mintingFeeEnabled;
1341 
1342         emit LogMintingFeeEnabledChanged(msg.sender, _mintingFeeEnabled);
1343 
1344         return true;
1345     }
1346 
1347     /**
1348     * @dev Change the Custom Token detailed information after creation.
1349     * @param _name The name to assign to the Custom Token.
1350     * @param _symbol The symbol to assign to the Custom Token.
1351     */
1352     function setInformation(string _name, string _symbol) public onlyOwner returns(bool successful) {
1353         require(bytes(_name).length > 0, "_name is empty");
1354         require(bytes(_symbol).length > 0, "_symbol is empty");
1355 
1356         name = _name;
1357         symbol = _symbol;
1358 
1359         emit LogInformationChanged(msg.sender, _name, _symbol);
1360 
1361         return true;
1362     }
1363 
1364     /**
1365     * @dev Stop trasfer fee payment for tokens.
1366     * @return true if the operation was successful.
1367     */
1368     function finishTransferFeePayment() public onlyOwner returns(bool finished) {
1369         require(!transferFeePaymentFinished, "transfer fee finished");
1370 
1371         transferFeePaymentFinished = true;
1372 
1373         emit LogTransferFeePaymentFinished(msg.sender);
1374 
1375         return true;
1376     }
1377 
1378     /**
1379     * @dev Change the transfer fee percentage to be paid in Custom tokens.
1380     * @param _transferFeePercentage The fee percentage to be paid for transfer in range [0, 100].
1381     */
1382     function setTransferFeePercentage(uint256 _transferFeePercentage) public onlyOwner {
1383         require(0 <= _transferFeePercentage && _transferFeePercentage <= 100, "_transferFeePercentage not in [0, 100]");
1384         require(_transferFeePercentage != transferFeePercentage, "_transferFeePercentage equal to current value");
1385 
1386         transferFeePercentage = _transferFeePercentage;
1387 
1388         emit LogTransferFeePercentageChanged(msg.sender, _transferFeePercentage);
1389     }
1390 
1391     function lockedBalanceOf(address _to) public view returns(uint256 locked) {
1392         uint256 initiallyLocked = initiallyLockedBalanceOf[_to];
1393         if (block.number >= lockEndBlock) return 0;
1394         else if (block.number <= transferableFromBlock) return initiallyLocked;
1395 
1396         uint256 releaseForBlock = initiallyLocked.div(lockEndBlock.sub(transferableFromBlock));
1397         uint256 released = block.number.sub(transferableFromBlock).mul(releaseForBlock);
1398         return initiallyLocked.sub(released);
1399     }
1400 
1401     /**
1402     * @dev Get the fee to be paid for the transfer of NOKU tokens.
1403     * @param _value The amount of NOKU tokens to be transferred.
1404     */
1405     function transferFee(uint256 _value) public view returns(uint256 usageFee) {
1406         return _value.mul(transferFeePercentage).div(100);
1407     }
1408 
1409     /**
1410     * @dev Check if token transfer is free of any charge or not.
1411     * @return true if transfer is free of any charge.
1412     */
1413     function freeTransfer() public view returns (bool isTransferFree) {
1414         return transferFeePaymentFinished || transferFeePercentage == 0;
1415     }
1416 
1417     /**
1418     * @dev Override #transfer for optionally paying fee to Custom token owner.
1419     */
1420     function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns(bool transferred) {
1421         if (freeTransfer()) {
1422             return super.transfer(_to, _value);
1423         }
1424         else {
1425             uint256 usageFee = transferFee(_value);
1426             uint256 netValue = _value.sub(usageFee);
1427 
1428             bool feeTransferred = super.transfer(owner, usageFee);
1429             bool netValueTransferred = super.transfer(_to, netValue);
1430 
1431             return feeTransferred && netValueTransferred;
1432         }
1433     }
1434 
1435     /**
1436     * @dev Override #transferFrom for optionally paying fee to Custom token owner.
1437     */
1438     function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns(bool transferred) {
1439         if (freeTransfer()) {
1440             return super.transferFrom(_from, _to, _value);
1441         }
1442         else {
1443             uint256 usageFee = transferFee(_value);
1444             uint256 netValue = _value.sub(usageFee);
1445 
1446             bool feeTransferred = super.transferFrom(_from, owner, usageFee);
1447             bool netValueTransferred = super.transferFrom(_from, _to, netValue);
1448 
1449             return feeTransferred && netValueTransferred;
1450         }
1451     }
1452 
1453     /**
1454     * @dev Burn a specific amount of tokens, paying the service fee.
1455     * @param _amount The amount of token to be burned.
1456     */
1457     function burn(uint256 _amount) public canBurn {
1458         require(_amount > 0, "_amount is zero");
1459 
1460         super.burn(_amount);
1461 
1462         require(pricingPlan.payFee(BURN_SERVICE_NAME, _amount, msg.sender), "burn fee failed");
1463     }
1464 
1465     /**
1466     * @dev Mint a specific amount of tokens, paying the service fee.
1467     * @param _to The address that will receive the minted tokens.
1468     * @param _amount The amount of tokens to mint.
1469     * @return A boolean that indicates if the operation was successful.
1470     */
1471     function mint(address _to, uint256 _amount) public onlyOwner canMint returns(bool minted) {
1472         require(_to != 0, "_to is zero");
1473         require(_amount > 0, "_amount is zero");
1474 
1475         super.mint(_to, _amount);
1476 
1477         if (mintingFeeEnabled) {
1478             require(pricingPlan.payFee(MINT_SERVICE_NAME, _amount, msg.sender), "mint fee failed");
1479         }
1480 
1481         return true;
1482     }
1483 
1484     /**
1485     * @dev Mint new locked tokens, which will unlock progressively.
1486     * @param _to The address that will receieve the minted locked tokens.
1487     * @param _amount The amount of tokens to mint.
1488     * @return A boolean that indicates if the operation was successful.
1489     */
1490     function mintLocked(address _to, uint256 _amount) public onlyOwner canMint returns(bool minted) {
1491         initiallyLockedBalanceOf[_to] = initiallyLockedBalanceOf[_to].add(_amount);
1492 
1493         return mint(_to, _amount);
1494     }
1495 
1496     /**
1497      * @dev Mint the specified amount of timelocked tokens.
1498      * @param _to The address that will receieve the minted locked tokens.
1499      * @param _amount The amount of tokens to mint.
1500      * @param _releaseTime The token release time as timestamp from Unix epoch.
1501      * @return A boolean that indicates if the operation was successful.
1502      */
1503     function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime) public onlyOwner canMint
1504     returns(bool minted)
1505     {
1506         require(timelock == address(0), "TokenTimelock already activated");
1507 
1508         timelock = new TokenTimelock(this, _to, _releaseTime);
1509 
1510         minted = mint(timelock, _amount);
1511 
1512         require(pricingPlan.payFee(TIMELOCK_SERVICE_NAME, _amount, msg.sender), "timelock fee failed");
1513     }
1514 
1515     /**
1516     * @dev Mint the specified amount of vested tokens.
1517     * @param _to The address that will receieve the minted vested tokens.
1518     * @param _amount The amount of tokens to mint.
1519     * @param _startTime When the vesting starts as timestamp in seconds from Unix epoch.
1520     * @param _duration The duration in seconds of the period in which the tokens will vest.
1521     * @return A boolean that indicates if the operation was successful.
1522     */
1523     function mintVested(address _to, uint256 _amount, uint256 _startTime, uint256 _duration) public onlyOwner canMint
1524     returns(bool minted)
1525     {
1526         require(vesting == address(0), "TokenVesting already activated");
1527 
1528         vesting = new TokenVesting(_to, _startTime, 0, _duration, true);
1529 
1530         minted = mint(vesting, _amount);
1531 
1532         require(pricingPlan.payFee(VESTING_SERVICE_NAME, _amount, msg.sender), "vesting fee failed");
1533     }
1534 
1535     /**
1536      * @dev Release vested tokens to the beneficiary. Anyone can release vested tokens.
1537     * @return A boolean that indicates if the operation was successful.
1538      */
1539     function releaseVested() public returns(bool released) {
1540         require(vesting != address(0), "TokenVesting not activated");
1541 
1542         vesting.release(this);
1543 
1544         return true;
1545     }
1546 
1547     /**
1548      * @dev Revoke vested tokens. Just the token can revoke because it is the vesting owner.
1549     * @return A boolean that indicates if the operation was successful.
1550      */
1551     function revokeVested() public onlyOwner returns(bool revoked) {
1552         require(vesting != address(0), "TokenVesting not activated");
1553 
1554         vesting.revoke(this);
1555 
1556         return true;
1557     }
1558 }
1559 
1560 // File: contracts/TokenCappedCrowdsale.sol
1561 
1562 /**
1563  * @title CappedCrowdsale
1564  * @dev Extension of Crowsdale with a max amount of funds raised
1565  */
1566 contract TokenCappedCrowdsale is Crowdsale {
1567     using SafeMath for uint256;
1568 
1569     // The maximum token cap, should be initialized in derived contract
1570     uint256 public tokenCap;
1571 
1572     // Overriding Crowdsale#hasEnded to add tokenCap logic
1573     // @return true if crowdsale event has ended
1574     function hasEnded() public view returns (bool) {
1575         bool capReached = soldTokens >= tokenCap;
1576         return super.hasEnded() || capReached;
1577     }
1578 
1579     // Overriding Crowdsale#isValidPurchase to add extra cap logic
1580     // @return true if investors can buy at the moment
1581     function isValidPurchase(address beneficiary) internal view returns (bool isValid) {
1582         uint256 tokenAmount = calculateTokens(msg.value);
1583         bool withinCap = soldTokens.add(tokenAmount) <= tokenCap;
1584         return withinCap && super.isValidPurchase(beneficiary);
1585     }
1586 }
1587 
1588 // File: contracts/NokuCustomCrowdsale.sol
1589 
1590 /**
1591  * @title NokuCustomCrowdsale
1592  * @dev Extension of TokenCappedCrowdsale using values specific for Noku Custom ICO crowdsale
1593  */
1594 contract NokuCustomCrowdsale is TokenCappedCrowdsale {
1595     using AddressUtils for address;
1596     using SafeMath for uint256;
1597 
1598     event LogNokuCustomCrowdsaleCreated(
1599         address sender,
1600         uint256 indexed startBlock,
1601         uint256 indexed endBlock,
1602         address indexed wallet
1603     );
1604     event LogThreePowerAgesChanged(
1605         address indexed sender,
1606         uint256 indexed platinumAgeEndBlock,
1607         uint256 indexed goldenAgeEndBlock,
1608         uint256 silverAgeEndBlock,
1609         uint256 platinumAgeRate,
1610         uint256 goldenAgeRate,
1611         uint256 silverAgeRate
1612     );
1613     event LogTwoPowerAgesChanged(
1614         address indexed sender,
1615         uint256 indexed platinumAgeEndBlock,
1616         uint256 indexed goldenAgeEndBlock,
1617         uint256 platinumAgeRate,
1618         uint256 goldenAgeRate
1619     );
1620     event LogOnePowerAgeChanged(address indexed sender, uint256 indexed platinumAgeEndBlock, uint256 indexed platinumAgeRate);
1621 
1622     // The end block of the 'platinum' age interval
1623     uint256 public platinumAgeEndBlock;
1624 
1625     // The end block of the 'golden' age interval
1626     uint256 public goldenAgeEndBlock;
1627 
1628     // The end block of the 'silver' age interval
1629     uint256 public silverAgeEndBlock;
1630 
1631     // The conversion rate of the 'platinum' age
1632     uint256 public platinumAgeRate;
1633 
1634     // The conversion rate of the 'golden' age
1635     uint256 public goldenAgeRate;
1636 
1637     // The conversion rate of the 'silver' age
1638     uint256 public silverAgeRate;
1639 
1640     // The wallet address or contract
1641     address public wallet;
1642 
1643     constructor(
1644         uint256 _startBlock,
1645         uint256 _endBlock,
1646         uint256 _rate,
1647         uint256 _minDeposit,
1648         uint256 _maxWhitelistLength,
1649         uint256 _whitelistThreshold,
1650         address _token,
1651         uint256 _tokenMaximumSupply,
1652         address _wallet
1653     )
1654     Crowdsale(
1655         _startBlock,
1656         _endBlock,
1657         _rate,
1658         _minDeposit,
1659         _maxWhitelistLength,
1660         _whitelistThreshold
1661     )
1662     public {
1663         require(_token.isContract(), "_token is not contract");
1664         require(_tokenMaximumSupply > 0, "_tokenMaximumSupply is zero");
1665 
1666         platinumAgeRate = _rate;
1667         goldenAgeRate = _rate;
1668         silverAgeRate = _rate;
1669 
1670         token = NokuCustomERC20(_token);
1671         wallet = _wallet;
1672 
1673         // Assume predefined token supply has been minted and calculate the maximum number of tokens that can be sold
1674         tokenCap = _tokenMaximumSupply.sub(token.totalSupply());
1675 
1676         emit LogNokuCustomCrowdsaleCreated(msg.sender, startBlock, endBlock, _wallet);
1677     }
1678 
1679     function setThreePowerAges(
1680         uint256 _platinumAgeEndBlock,
1681         uint256 _goldenAgeEndBlock,
1682         uint256 _silverAgeEndBlock,
1683         uint256 _platinumAgeRate,
1684         uint256 _goldenAgeRate,
1685         uint256 _silverAgeRate
1686     )
1687     external onlyOwner beforeStart
1688     {
1689         require(startBlock < _platinumAgeEndBlock, "_platinumAgeEndBlock not greater than start block");
1690         require(_platinumAgeEndBlock < _goldenAgeEndBlock, "_platinumAgeEndBlock not lower than _goldenAgeEndBlock");
1691         require(_goldenAgeEndBlock < _silverAgeEndBlock, "_silverAgeEndBlock not greater than _goldenAgeEndBlock");
1692         require(_silverAgeEndBlock <= endBlock, "_silverAgeEndBlock greater than end block");
1693         require(_platinumAgeRate > _goldenAgeRate, "_platinumAgeRate not greater than _goldenAgeRate");
1694         require(_goldenAgeRate > _silverAgeRate, "_goldenAgeRate not greater than _silverAgeRate");
1695         require(_silverAgeRate > rate, "_silverAgeRate not greater than nominal rate");
1696 
1697         platinumAgeEndBlock = _platinumAgeEndBlock;
1698         goldenAgeEndBlock = _goldenAgeEndBlock;
1699         silverAgeEndBlock = _silverAgeEndBlock;
1700 
1701         platinumAgeRate = _platinumAgeRate;
1702         goldenAgeRate = _goldenAgeRate;
1703         silverAgeRate = _silverAgeRate;
1704 
1705         emit LogThreePowerAgesChanged(
1706             msg.sender,
1707             _platinumAgeEndBlock,
1708             _goldenAgeEndBlock,
1709             _silverAgeEndBlock,
1710             _platinumAgeRate,
1711             _goldenAgeRate,
1712             _silverAgeRate
1713         );
1714     }
1715 
1716     function setTwoPowerAges(
1717         uint256 _platinumAgeEndBlock,
1718         uint256 _goldenAgeEndBlock,
1719         uint256 _platinumAgeRate,
1720         uint256 _goldenAgeRate
1721     )
1722     external onlyOwner beforeStart
1723     {
1724         require(startBlock < _platinumAgeEndBlock, "_platinumAgeEndBlock not greater than start block");
1725         require(_platinumAgeEndBlock < _goldenAgeEndBlock, "_platinumAgeEndBlock not lower than _goldenAgeEndBlock");
1726         require(_goldenAgeEndBlock <= endBlock, "_goldenAgeEndBlock greater than end block");
1727         require(_platinumAgeRate > _goldenAgeRate, "_platinumAgeRate not greater than _goldenAgeRate");
1728         require(_goldenAgeRate > rate, "_goldenAgeRate not greater than nominal rate");
1729 
1730         platinumAgeEndBlock = _platinumAgeEndBlock;
1731         goldenAgeEndBlock = _goldenAgeEndBlock;
1732 
1733         platinumAgeRate = _platinumAgeRate;
1734         goldenAgeRate = _goldenAgeRate;
1735         silverAgeRate = rate;
1736 
1737         emit LogTwoPowerAgesChanged(
1738             msg.sender,
1739             _platinumAgeEndBlock,
1740             _goldenAgeEndBlock,
1741             _platinumAgeRate,
1742             _goldenAgeRate
1743         );
1744     }
1745 
1746     function setOnePowerAge(uint256 _platinumAgeEndBlock, uint256 _platinumAgeRate)
1747     external onlyOwner beforeStart
1748     {
1749         require(startBlock < _platinumAgeEndBlock, "_platinumAgeEndBlock not greater than start block");
1750         require(_platinumAgeEndBlock <= endBlock, "_platinumAgeEndBlock greater than end block");
1751         require(_platinumAgeRate > rate, "_platinumAgeRate not greater than nominal rate");
1752 
1753         platinumAgeEndBlock = _platinumAgeEndBlock;
1754 
1755         platinumAgeRate = _platinumAgeRate;
1756         goldenAgeRate = rate;
1757         silverAgeRate = rate;
1758 
1759         emit LogOnePowerAgeChanged(msg.sender, _platinumAgeEndBlock, _platinumAgeRate);
1760     }
1761 
1762     function grantTokenOwnership(address _client) external onlyOwner returns(bool granted) {
1763         require(!_client.isContract(), "_client is contract");
1764         require(hasEnded(), "crowdsale not ended yet");
1765 
1766         // Transfer NokuCustomERC20 ownership back to the client
1767         token.transferOwnership(_client);
1768 
1769         return true;
1770     }
1771 
1772     // Overriding Crowdsale#calculateTokens to apply age discounts to token calculus.
1773     function calculateTokens(uint256 amount) internal view returns(uint256 tokenAmount) {
1774         uint256 conversionRate = block.number <= platinumAgeEndBlock ? platinumAgeRate :
1775             block.number <= goldenAgeEndBlock ? goldenAgeRate :
1776             block.number <= silverAgeEndBlock ? silverAgeRate :
1777             rate;
1778 
1779         return amount.mul(conversionRate);
1780     }
1781 
1782     /**
1783      * @dev Overriding Crowdsale#distributeTokens to apply age rules to token distributions.
1784      */
1785     function distributeTokens(address beneficiary, uint256 tokenAmount) internal {
1786         if (block.number <= platinumAgeEndBlock) {
1787             NokuCustomERC20(token).mintLocked(beneficiary, tokenAmount);
1788         }
1789         else {
1790             super.distributeTokens(beneficiary, tokenAmount);
1791         }
1792     }
1793 
1794     /**
1795      * @dev Overriding Crowdsale#forwardFunds to split net/fee payment.
1796      */
1797     function forwardFunds(uint256 amount) internal {
1798         wallet.transfer(amount);
1799     }
1800 }
1801 
1802 // File: contracts/NokuCustomService.sol
1803 
1804 contract NokuCustomService is Pausable {
1805     using AddressUtils for address;
1806 
1807     event LogPricingPlanChanged(address indexed caller, address indexed pricingPlan);
1808 
1809     // The pricing plan determining the fee to be paid in NOKU tokens by customers
1810     NokuPricingPlan public pricingPlan;
1811 
1812     constructor(address _pricingPlan) internal {
1813         require(_pricingPlan.isContract(), "_pricingPlan is not contract");
1814 
1815         pricingPlan = NokuPricingPlan(_pricingPlan);
1816     }
1817 
1818     function setPricingPlan(address _pricingPlan) public onlyOwner {
1819         require(_pricingPlan.isContract(), "_pricingPlan is not contract");
1820         require(NokuPricingPlan(_pricingPlan) != pricingPlan, "_pricingPlan equal to current");
1821         
1822         pricingPlan = NokuPricingPlan(_pricingPlan);
1823 
1824         emit LogPricingPlanChanged(msg.sender, _pricingPlan);
1825     }
1826 }
1827 
1828 // File: contracts/NokuCustomCrowdsaleService.sol
1829 
1830 /**
1831  * @title NokuCustomCrowdsaleService
1832  * @dev Extension of NokuCustomService adding the fee payment in NOKU tokens.
1833  */
1834 contract NokuCustomCrowdsaleService is NokuCustomService {
1835     event LogNokuCustomCrowdsaleServiceCreated(address indexed caller);
1836 
1837     bytes32 public constant SERVICE_NAME = "NokuCustomERC20.crowdsale";
1838     uint256 public constant CREATE_AMOUNT = 1 * 10**18;
1839 
1840     constructor(address _pricingPlan) NokuCustomService(_pricingPlan) public {
1841         emit LogNokuCustomCrowdsaleServiceCreated(msg.sender);
1842     }
1843 
1844     function createCustomCrowdsale(
1845         uint256 _startBlock,
1846         uint256 _endBlock,
1847         uint256 _rate,
1848         uint256 _minDeposit,
1849         uint256 _maxWhitelistLength,
1850         uint256 _whitelistThreshold,
1851         address _token,
1852         uint256 _tokenMaximumSupply,
1853         address _wallet
1854     )
1855     public returns(NokuCustomCrowdsale customCrowdsale)
1856     {
1857         customCrowdsale = new NokuCustomCrowdsale(
1858             _startBlock,
1859             _endBlock,
1860             _rate,
1861             _minDeposit,
1862             _maxWhitelistLength,
1863             _whitelistThreshold,
1864             _token,
1865             _tokenMaximumSupply,
1866             _wallet
1867         );
1868 
1869         // Transfer NokuCustomCrowdsale ownership to the client
1870         customCrowdsale.transferOwnership(msg.sender);
1871 
1872         require(pricingPlan.payFee(SERVICE_NAME, CREATE_AMOUNT, msg.sender), "fee payment failed");
1873     }
1874 }