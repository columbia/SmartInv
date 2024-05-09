1 // File: openzeppelin-solidity/contracts/AddressUtils.sol
2 
3 pragma solidity ^0.4.23;
4 
5 
6 /**
7  * Utility library of inline functions on addresses
8  */
9 library AddressUtils {
10 
11   /**
12    * Returns whether the target address is a contract
13    * @dev This function will return false if invoked during the constructor of a contract,
14    *  as the code is not actually created until after the constructor finishes.
15    * @param addr address to check
16    * @return whether the target address is a contract
17    */
18   function isContract(address addr) internal view returns (bool) {
19     uint256 size;
20     // XXX Currently there is no better way to check if there is a contract in an address
21     // than to check the size of the code at that address.
22     // See https://ethereum.stackexchange.com/a/14016/36603
23     // for more details about how this works.
24     // TODO Check this again before the Serenity release, because all addresses will be
25     // contracts then.
26     // solium-disable-next-line security/no-inline-assembly
27     assembly { size := extcodesize(addr) }
28     return size > 0;
29   }
30 
31 }
32 
33 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
34 
35 pragma solidity ^0.4.23;
36 
37 
38 /**
39  * @title Ownable
40  * @dev The Ownable contract has an owner address, and provides basic authorization control
41  * functions, this simplifies the implementation of "user permissions".
42  */
43 contract Ownable {
44   address public owner;
45 
46 
47   event OwnershipRenounced(address indexed previousOwner);
48   event OwnershipTransferred(
49     address indexed previousOwner,
50     address indexed newOwner
51   );
52 
53 
54   /**
55    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
56    * account.
57    */
58   constructor() public {
59     owner = msg.sender;
60   }
61 
62   /**
63    * @dev Throws if called by any account other than the owner.
64    */
65   modifier onlyOwner() {
66     require(msg.sender == owner);
67     _;
68   }
69 
70   /**
71    * @dev Allows the current owner to relinquish control of the contract.
72    */
73   function renounceOwnership() public onlyOwner {
74     emit OwnershipRenounced(owner);
75     owner = address(0);
76   }
77 
78   /**
79    * @dev Allows the current owner to transfer control of the contract to a newOwner.
80    * @param _newOwner The address to transfer ownership to.
81    */
82   function transferOwnership(address _newOwner) public onlyOwner {
83     _transferOwnership(_newOwner);
84   }
85 
86   /**
87    * @dev Transfers control of the contract to a newOwner.
88    * @param _newOwner The address to transfer ownership to.
89    */
90   function _transferOwnership(address _newOwner) internal {
91     require(_newOwner != address(0));
92     emit OwnershipTransferred(owner, _newOwner);
93     owner = _newOwner;
94   }
95 }
96 
97 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
98 
99 pragma solidity ^0.4.23;
100 
101 
102 
103 /**
104  * @title Pausable
105  * @dev Base contract which allows children to implement an emergency stop mechanism.
106  */
107 contract Pausable is Ownable {
108   event Pause();
109   event Unpause();
110 
111   bool public paused = false;
112 
113 
114   /**
115    * @dev Modifier to make a function callable only when the contract is not paused.
116    */
117   modifier whenNotPaused() {
118     require(!paused);
119     _;
120   }
121 
122   /**
123    * @dev Modifier to make a function callable only when the contract is paused.
124    */
125   modifier whenPaused() {
126     require(paused);
127     _;
128   }
129 
130   /**
131    * @dev called by the owner to pause, triggers stopped state
132    */
133   function pause() onlyOwner whenNotPaused public {
134     paused = true;
135     emit Pause();
136   }
137 
138   /**
139    * @dev called by the owner to unpause, returns to normal state
140    */
141   function unpause() onlyOwner whenPaused public {
142     paused = false;
143     emit Unpause();
144   }
145 }
146 
147 // File: contracts/NokuPricingPlan.sol
148 
149 pragma solidity ^0.4.23;
150 
151 /**
152 * @dev The NokuPricingPlan contract defines the responsibilities of a Noku pricing plan.
153 */
154 contract NokuPricingPlan {
155     /**
156     * @dev Pay the fee for the service identified by the specified name.
157     * The fee amount shall already be approved by the client.
158     * @param serviceName The name of the target service.
159     * @param multiplier The multiplier of the base service fee to apply.
160     * @param client The client of the target service.
161     * @return true if fee has been paid.
162     */
163     function payFee(bytes32 serviceName, uint256 multiplier, address client) public returns(bool paid);
164 
165     /**
166     * @dev Get the usage fee for the service identified by the specified name.
167     * The returned fee amount shall be approved before using #payFee method.
168     * @param serviceName The name of the target service.
169     * @param multiplier The multiplier of the base service fee to apply.
170     * @return The amount to approve before really paying such fee.
171     */
172     function usageFee(bytes32 serviceName, uint256 multiplier) public constant returns(uint fee);
173 }
174 
175 // File: contracts/NokuCustomService.sol
176 
177 pragma solidity ^0.4.23;
178 
179 
180 
181 
182 contract NokuCustomService is Pausable {
183     using AddressUtils for address;
184 
185     event LogPricingPlanChanged(address indexed caller, address indexed pricingPlan);
186 
187     // The pricing plan determining the fee to be paid in NOKU tokens by customers
188     NokuPricingPlan public pricingPlan;
189 
190     constructor(address _pricingPlan) internal {
191         require(_pricingPlan.isContract(), "_pricingPlan is not contract");
192 
193         pricingPlan = NokuPricingPlan(_pricingPlan);
194     }
195 
196     function setPricingPlan(address _pricingPlan) public onlyOwner {
197         require(_pricingPlan.isContract(), "_pricingPlan is not contract");
198         require(NokuPricingPlan(_pricingPlan) != pricingPlan, "_pricingPlan equal to current");
199         
200         pricingPlan = NokuPricingPlan(_pricingPlan);
201 
202         emit LogPricingPlanChanged(msg.sender, _pricingPlan);
203     }
204 }
205 
206 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
207 
208 pragma solidity ^0.4.23;
209 
210 
211 /**
212  * @title SafeMath
213  * @dev Math operations with safety checks that throw on error
214  */
215 library SafeMath {
216 
217   /**
218   * @dev Multiplies two numbers, throws on overflow.
219   */
220   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
221     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
222     // benefit is lost if 'b' is also tested.
223     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
224     if (a == 0) {
225       return 0;
226     }
227 
228     c = a * b;
229     assert(c / a == b);
230     return c;
231   }
232 
233   /**
234   * @dev Integer division of two numbers, truncating the quotient.
235   */
236   function div(uint256 a, uint256 b) internal pure returns (uint256) {
237     // assert(b > 0); // Solidity automatically throws when dividing by 0
238     // uint256 c = a / b;
239     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
240     return a / b;
241   }
242 
243   /**
244   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
245   */
246   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
247     assert(b <= a);
248     return a - b;
249   }
250 
251   /**
252   * @dev Adds two numbers, throws on overflow.
253   */
254   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
255     c = a + b;
256     assert(c >= a);
257     return c;
258   }
259 }
260 
261 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
262 
263 pragma solidity ^0.4.23;
264 
265 
266 /**
267  * @title ERC20Basic
268  * @dev Simpler version of ERC20 interface
269  * @dev see https://github.com/ethereum/EIPs/issues/179
270  */
271 contract ERC20Basic {
272   function totalSupply() public view returns (uint256);
273   function balanceOf(address who) public view returns (uint256);
274   function transfer(address to, uint256 value) public returns (bool);
275   event Transfer(address indexed from, address indexed to, uint256 value);
276 }
277 
278 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
279 
280 pragma solidity ^0.4.23;
281 
282 
283 
284 
285 /**
286  * @title Basic token
287  * @dev Basic version of StandardToken, with no allowances.
288  */
289 contract BasicToken is ERC20Basic {
290   using SafeMath for uint256;
291 
292   mapping(address => uint256) balances;
293 
294   uint256 totalSupply_;
295 
296   /**
297   * @dev total number of tokens in existence
298   */
299   function totalSupply() public view returns (uint256) {
300     return totalSupply_;
301   }
302 
303   /**
304   * @dev transfer token for a specified address
305   * @param _to The address to transfer to.
306   * @param _value The amount to be transferred.
307   */
308   function transfer(address _to, uint256 _value) public returns (bool) {
309     require(_to != address(0));
310     require(_value <= balances[msg.sender]);
311 
312     balances[msg.sender] = balances[msg.sender].sub(_value);
313     balances[_to] = balances[_to].add(_value);
314     emit Transfer(msg.sender, _to, _value);
315     return true;
316   }
317 
318   /**
319   * @dev Gets the balance of the specified address.
320   * @param _owner The address to query the the balance of.
321   * @return An uint256 representing the amount owned by the passed address.
322   */
323   function balanceOf(address _owner) public view returns (uint256) {
324     return balances[_owner];
325   }
326 
327 }
328 
329 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
330 
331 pragma solidity ^0.4.23;
332 
333 
334 
335 /**
336  * @title ERC20 interface
337  * @dev see https://github.com/ethereum/EIPs/issues/20
338  */
339 contract ERC20 is ERC20Basic {
340   function allowance(address owner, address spender)
341     public view returns (uint256);
342 
343   function transferFrom(address from, address to, uint256 value)
344     public returns (bool);
345 
346   function approve(address spender, uint256 value) public returns (bool);
347   event Approval(
348     address indexed owner,
349     address indexed spender,
350     uint256 value
351   );
352 }
353 
354 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
355 
356 pragma solidity ^0.4.23;
357 
358 
359 
360 
361 /**
362  * @title Standard ERC20 token
363  *
364  * @dev Implementation of the basic standard token.
365  * @dev https://github.com/ethereum/EIPs/issues/20
366  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
367  */
368 contract StandardToken is ERC20, BasicToken {
369 
370   mapping (address => mapping (address => uint256)) internal allowed;
371 
372 
373   /**
374    * @dev Transfer tokens from one address to another
375    * @param _from address The address which you want to send tokens from
376    * @param _to address The address which you want to transfer to
377    * @param _value uint256 the amount of tokens to be transferred
378    */
379   function transferFrom(
380     address _from,
381     address _to,
382     uint256 _value
383   )
384     public
385     returns (bool)
386   {
387     require(_to != address(0));
388     require(_value <= balances[_from]);
389     require(_value <= allowed[_from][msg.sender]);
390 
391     balances[_from] = balances[_from].sub(_value);
392     balances[_to] = balances[_to].add(_value);
393     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
394     emit Transfer(_from, _to, _value);
395     return true;
396   }
397 
398   /**
399    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
400    *
401    * Beware that changing an allowance with this method brings the risk that someone may use both the old
402    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
403    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
404    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
405    * @param _spender The address which will spend the funds.
406    * @param _value The amount of tokens to be spent.
407    */
408   function approve(address _spender, uint256 _value) public returns (bool) {
409     allowed[msg.sender][_spender] = _value;
410     emit Approval(msg.sender, _spender, _value);
411     return true;
412   }
413 
414   /**
415    * @dev Function to check the amount of tokens that an owner allowed to a spender.
416    * @param _owner address The address which owns the funds.
417    * @param _spender address The address which will spend the funds.
418    * @return A uint256 specifying the amount of tokens still available for the spender.
419    */
420   function allowance(
421     address _owner,
422     address _spender
423    )
424     public
425     view
426     returns (uint256)
427   {
428     return allowed[_owner][_spender];
429   }
430 
431   /**
432    * @dev Increase the amount of tokens that an owner allowed to a spender.
433    *
434    * approve should be called when allowed[_spender] == 0. To increment
435    * allowed value is better to use this function to avoid 2 calls (and wait until
436    * the first transaction is mined)
437    * From MonolithDAO Token.sol
438    * @param _spender The address which will spend the funds.
439    * @param _addedValue The amount of tokens to increase the allowance by.
440    */
441   function increaseApproval(
442     address _spender,
443     uint _addedValue
444   )
445     public
446     returns (bool)
447   {
448     allowed[msg.sender][_spender] = (
449       allowed[msg.sender][_spender].add(_addedValue));
450     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
451     return true;
452   }
453 
454   /**
455    * @dev Decrease the amount of tokens that an owner allowed to a spender.
456    *
457    * approve should be called when allowed[_spender] == 0. To decrement
458    * allowed value is better to use this function to avoid 2 calls (and wait until
459    * the first transaction is mined)
460    * From MonolithDAO Token.sol
461    * @param _spender The address which will spend the funds.
462    * @param _subtractedValue The amount of tokens to decrease the allowance by.
463    */
464   function decreaseApproval(
465     address _spender,
466     uint _subtractedValue
467   )
468     public
469     returns (bool)
470   {
471     uint oldValue = allowed[msg.sender][_spender];
472     if (_subtractedValue > oldValue) {
473       allowed[msg.sender][_spender] = 0;
474     } else {
475       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
476     }
477     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
478     return true;
479   }
480 
481 }
482 
483 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
484 
485 pragma solidity ^0.4.23;
486 
487 
488 
489 
490 /**
491  * @title Mintable token
492  * @dev Simple ERC20 Token example, with mintable token creation
493  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
494  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
495  */
496 contract MintableToken is StandardToken, Ownable {
497   event Mint(address indexed to, uint256 amount);
498   event MintFinished();
499 
500   bool public mintingFinished = false;
501 
502 
503   modifier canMint() {
504     require(!mintingFinished);
505     _;
506   }
507 
508   modifier hasMintPermission() {
509     require(msg.sender == owner);
510     _;
511   }
512 
513   /**
514    * @dev Function to mint tokens
515    * @param _to The address that will receive the minted tokens.
516    * @param _amount The amount of tokens to mint.
517    * @return A boolean that indicates if the operation was successful.
518    */
519   function mint(
520     address _to,
521     uint256 _amount
522   )
523     hasMintPermission
524     canMint
525     public
526     returns (bool)
527   {
528     totalSupply_ = totalSupply_.add(_amount);
529     balances[_to] = balances[_to].add(_amount);
530     emit Mint(_to, _amount);
531     emit Transfer(address(0), _to, _amount);
532     return true;
533   }
534 
535   /**
536    * @dev Function to stop minting new tokens.
537    * @return True if the operation was successful.
538    */
539   function finishMinting() onlyOwner canMint public returns (bool) {
540     mintingFinished = true;
541     emit MintFinished();
542     return true;
543   }
544 }
545 
546 // File: contracts/KYCBase.sol
547 
548 pragma solidity ^0.4.23;
549 
550 
551 // Abstract base contract
552 contract KYCBase {
553     using SafeMath for uint256;
554 
555     mapping (address => bool) public isKycSigner;
556     mapping (uint64 => uint256) public alreadyPayed;
557 
558     event KycVerified(address indexed signer, address buyerAddress, uint64 buyerId, uint maxAmount);
559 
560     constructor(address[] kycSigners) internal {
561         for (uint i = 0; i < kycSigners.length; i++) {
562             isKycSigner[kycSigners[i]] = true;
563         }
564     }
565 
566     // Must be implemented in descending contract to assign tokens to the buyers. Called after the KYC verification is passed
567     function releaseTokensTo(address buyer) internal returns(bool);
568 
569     // This method can be overridden to enable some sender to buy token for a different address
570     function senderAllowedFor(address buyer)
571         internal view returns(bool)
572     {
573         return buyer == msg.sender;
574     }
575 
576     function buyTokensFor(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
577         public payable returns (bool)
578     {
579         require(senderAllowedFor(buyerAddress));
580         return buyImplementation(buyerAddress, buyerId, maxAmount, v, r, s);
581     }
582 
583     function buyTokens(uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
584         public payable returns (bool)
585     {
586         return buyImplementation(msg.sender, buyerId, maxAmount, v, r, s);
587     }
588 
589     function buyImplementation(address buyerAddress, uint64 buyerId, uint maxAmount, uint8 v, bytes32 r, bytes32 s)
590         private returns (bool)
591     {
592         // check the signature
593         bytes32 hash = sha256(abi.encodePacked("Eidoo icoengine authorization", this, buyerAddress, buyerId, maxAmount));
594         address signer = ecrecover(hash, v, r, s);
595         if (!isKycSigner[signer]) {
596             revert();
597         } else {
598             uint256 totalPayed = alreadyPayed[buyerId].add(msg.value);
599             require(totalPayed <= maxAmount);
600             alreadyPayed[buyerId] = totalPayed;
601             emit KycVerified(signer, buyerAddress, buyerId, maxAmount);
602             return releaseTokensTo(buyerAddress);
603         }
604     }
605 
606     // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor
607     function () public {
608         revert();
609     }
610 }
611 
612 // File: contracts/WhitelistableConstraints.sol
613 
614 pragma solidity ^0.4.23;
615 
616 /**
617  * @title WhitelistableConstraints
618  * @dev Contract encapsulating the constraints applicable to a Whitelistable contract.
619  */
620 contract WhitelistableConstraints {
621 
622     /**
623      * @dev Check if whitelist with specified parameters is allowed.
624      * @param _maxWhitelistLength The maximum length of whitelist. Zero means no whitelist.
625      * @param _weiWhitelistThresholdBalance The threshold balance triggering whitelist check.
626      * @return true if whitelist with specified parameters is allowed, false otherwise
627      */
628     function isAllowedWhitelist(uint256 _maxWhitelistLength, uint256 _weiWhitelistThresholdBalance)
629         public pure returns(bool isReallyAllowedWhitelist) {
630         return _maxWhitelistLength > 0 || _weiWhitelistThresholdBalance > 0;
631     }
632 }
633 
634 // File: contracts/Whitelistable.sol
635 
636 pragma solidity ^0.4.23;
637 
638 
639 /**
640  * @title Whitelistable
641  * @dev Base contract implementing a whitelist to keep track of investors.
642  * The construction parameters allow for both whitelisted and non-whitelisted contracts:
643  * 1) maxWhitelistLength = 0 and whitelistThresholdBalance > 0: whitelist disabled
644  * 2) maxWhitelistLength > 0 and whitelistThresholdBalance = 0: whitelist enabled, full whitelisting
645  * 3) maxWhitelistLength > 0 and whitelistThresholdBalance > 0: whitelist enabled, partial whitelisting
646  */
647 contract Whitelistable is WhitelistableConstraints {
648 
649     event LogMaxWhitelistLengthChanged(address indexed caller, uint256 indexed maxWhitelistLength);
650     event LogWhitelistThresholdBalanceChanged(address indexed caller, uint256 indexed whitelistThresholdBalance);
651     event LogWhitelistAddressAdded(address indexed caller, address indexed subscriber);
652     event LogWhitelistAddressRemoved(address indexed caller, address indexed subscriber);
653 
654     mapping (address => bool) public whitelist;
655 
656     uint256 public whitelistLength;
657 
658     uint256 public maxWhitelistLength;
659 
660     uint256 public whitelistThresholdBalance;
661 
662     constructor(uint256 _maxWhitelistLength, uint256 _whitelistThresholdBalance) internal {
663         require(isAllowedWhitelist(_maxWhitelistLength, _whitelistThresholdBalance), "parameters not allowed");
664 
665         maxWhitelistLength = _maxWhitelistLength;
666         whitelistThresholdBalance = _whitelistThresholdBalance;
667     }
668 
669     /**
670      * @return true if whitelist is currently enabled, false otherwise
671      */
672     function isWhitelistEnabled() public view returns(bool isReallyWhitelistEnabled) {
673         return maxWhitelistLength > 0;
674     }
675 
676     /**
677      * @return true if subscriber is whitelisted, false otherwise
678      */
679     function isWhitelisted(address _subscriber) public view returns(bool isReallyWhitelisted) {
680         return whitelist[_subscriber];
681     }
682 
683     function setMaxWhitelistLengthInternal(uint256 _maxWhitelistLength) internal {
684         require(isAllowedWhitelist(_maxWhitelistLength, whitelistThresholdBalance),
685             "_maxWhitelistLength not allowed");
686         require(_maxWhitelistLength != maxWhitelistLength, "_maxWhitelistLength equal to current one");
687 
688         maxWhitelistLength = _maxWhitelistLength;
689 
690         emit LogMaxWhitelistLengthChanged(msg.sender, maxWhitelistLength);
691     }
692 
693     function setWhitelistThresholdBalanceInternal(uint256 _whitelistThresholdBalance) internal {
694         require(isAllowedWhitelist(maxWhitelistLength, _whitelistThresholdBalance),
695             "_whitelistThresholdBalance not allowed");
696         require(whitelistLength == 0 || _whitelistThresholdBalance > whitelistThresholdBalance,
697             "_whitelistThresholdBalance not greater than current one");
698 
699         whitelistThresholdBalance = _whitelistThresholdBalance;
700 
701         emit LogWhitelistThresholdBalanceChanged(msg.sender, _whitelistThresholdBalance);
702     }
703 
704     function addToWhitelistInternal(address _subscriber) internal {
705         require(_subscriber != address(0), "_subscriber is zero");
706         require(!whitelist[_subscriber], "already whitelisted");
707         require(whitelistLength < maxWhitelistLength, "max whitelist length reached");
708 
709         whitelistLength++;
710 
711         whitelist[_subscriber] = true;
712 
713         emit LogWhitelistAddressAdded(msg.sender, _subscriber);
714     }
715 
716     function removeFromWhitelistInternal(address _subscriber, uint256 _balance) internal {
717         require(_subscriber != address(0), "_subscriber is zero");
718         require(whitelist[_subscriber], "not whitelisted");
719         require(_balance <= whitelistThresholdBalance, "_balance greater than whitelist threshold");
720 
721         assert(whitelistLength > 0);
722 
723         whitelistLength--;
724 
725         whitelist[_subscriber] = false;
726 
727         emit LogWhitelistAddressRemoved(msg.sender, _subscriber);
728     }
729 
730     /**
731      * @param _subscriber The subscriber for which the balance check is required.
732      * @param _balance The balance value to check for allowance.
733      * @return true if the balance is allowed for the subscriber, false otherwise
734      */
735     function isAllowedBalance(address _subscriber, uint256 _balance) public view returns(bool isReallyAllowed) {
736         return !isWhitelistEnabled() || _balance <= whitelistThresholdBalance || whitelist[_subscriber];
737     }
738 }
739 
740 // File: contracts/CrowdsaleKYC.sol
741 
742 pragma solidity ^0.4.23;
743 
744 
745 
746 
747 
748 
749 
750 /**
751  * @title CrowdsaleKYC 
752  * @dev Crowdsale is a base contract for managing a token crowdsale.
753  * Crowdsales have a start and end block, where investors can make
754  * token purchases and the crowdsale will assign them tokens based
755  * on a token per ETH rate. Funds collected are forwarded to a wallet 
756  * as they arrive.
757  */
758 contract CrowdsaleKYC is Pausable, Whitelistable, KYCBase {
759     using AddressUtils for address;
760     using SafeMath for uint256;
761 
762     event LogStartBlockChanged(uint256 indexed startBlock);
763     event LogEndBlockChanged(uint256 indexed endBlock);
764     event LogMinDepositChanged(uint256 indexed minDeposit);
765     event LogTokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 indexed amount, uint256 tokenAmount);
766 
767     // The token being sold
768     MintableToken public token;
769 
770     // The start and end block where investments are allowed (both inclusive)
771     uint256 public startBlock;
772     uint256 public endBlock;
773 
774     // How many token units a buyer gets per wei
775     uint256 public rate;
776 
777     // Amount of raised money in wei
778     uint256 public raisedFunds;
779 
780     // Amount of tokens already sold
781     uint256 public soldTokens;
782 
783     // Balances in wei deposited by each subscriber
784     mapping (address => uint256) public balanceOf;
785 
786     // The minimum balance for each subscriber in wei
787     uint256 public minDeposit;
788 
789     modifier beforeStart() {
790         require(block.number < startBlock, "already started");
791         _;
792     }
793 
794     modifier beforeEnd() {
795         require(block.number <= endBlock, "already ended");
796         _;
797     }
798 
799     constructor(
800         uint256 _startBlock,
801         uint256 _endBlock,
802         uint256 _rate,
803         uint256 _minDeposit,
804         uint256 maxWhitelistLength,
805         uint256 whitelistThreshold,
806         address[] kycSigner
807     )
808     Whitelistable(maxWhitelistLength, whitelistThreshold)
809     KYCBase(kycSigner) internal
810     {
811         require(_startBlock >= block.number, "_startBlock is lower than current block.number");
812         require(_endBlock >= _startBlock, "_endBlock is lower than _startBlock");
813         require(_rate > 0, "_rate is zero");
814         require(_minDeposit > 0, "_minDeposit is zero");
815 
816         startBlock = _startBlock;
817         endBlock = _endBlock;
818         rate = _rate;
819         minDeposit = _minDeposit;
820     }
821 
822     /*
823     * @return true if crowdsale event has started
824     */
825     function hasStarted() public view returns (bool started) {
826         return block.number >= startBlock;
827     }
828 
829     /*
830     * @return true if crowdsale event has ended
831     */
832     function hasEnded() public view returns (bool ended) {
833         return block.number > endBlock;
834     }
835 
836     /**
837      * Change the crowdsale start block number.
838      * @param _startBlock The new start block
839      */
840     function setStartBlock(uint256 _startBlock) external onlyOwner beforeStart {
841         require(_startBlock >= block.number, "_startBlock < current block");
842         require(_startBlock <= endBlock, "_startBlock > endBlock");
843         require(_startBlock != startBlock, "_startBlock == startBlock");
844 
845         startBlock = _startBlock;
846 
847         emit LogStartBlockChanged(_startBlock);
848     }
849 
850     /**
851      * Change the crowdsale end block number.
852      * @param _endBlock The new end block
853      */
854     function setEndBlock(uint256 _endBlock) external onlyOwner beforeEnd {
855         require(_endBlock >= block.number, "_endBlock < current block");
856         require(_endBlock >= startBlock, "_endBlock < startBlock");
857         require(_endBlock != endBlock, "_endBlock == endBlock");
858 
859         endBlock = _endBlock;
860 
861         emit LogEndBlockChanged(_endBlock);
862     }
863 
864     /**
865      * Change the minimum deposit for each subscriber. New value shall be lower than previous.
866      * @param _minDeposit The minimum deposit for each subscriber, expressed in wei
867      */
868     function setMinDeposit(uint256 _minDeposit) external onlyOwner beforeEnd {
869         require(0 < _minDeposit && _minDeposit < minDeposit, "_minDeposit is not in [0, minDeposit]");
870 
871         minDeposit = _minDeposit;
872 
873         emit LogMinDepositChanged(minDeposit);
874     }
875 
876     /**
877      * Change the maximum whitelist length. New value shall satisfy the #isAllowedWhitelist conditions.
878      * @param maxWhitelistLength The maximum whitelist length
879      */
880     function setMaxWhitelistLength(uint256 maxWhitelistLength) external onlyOwner beforeEnd {
881         setMaxWhitelistLengthInternal(maxWhitelistLength);
882     }
883 
884     /**
885      * Change the whitelist threshold balance. New value shall satisfy the #isAllowedWhitelist conditions.
886      * @param whitelistThreshold The threshold balance (in wei) above which whitelisting is required to invest
887      */
888     function setWhitelistThresholdBalance(uint256 whitelistThreshold) external onlyOwner beforeEnd {
889         setWhitelistThresholdBalanceInternal(whitelistThreshold);
890     }
891 
892     /**
893      * Add the subscriber to the whitelist.
894      * @param subscriber The subscriber to add to the whitelist.
895      */
896     function addToWhitelist(address subscriber) external onlyOwner beforeEnd {
897         addToWhitelistInternal(subscriber);
898     }
899 
900     /**
901      * Removed the subscriber from the whitelist.
902      * @param subscriber The subscriber to remove from the whitelist.
903      */
904     function removeFromWhitelist(address subscriber) external onlyOwner beforeEnd {
905         removeFromWhitelistInternal(subscriber, balanceOf[subscriber]);
906     }
907 
908     // // fallback function can be used to buy tokens
909     // function () external payable whenNotPaused {
910     //     buyTokens(msg.sender);
911     // }
912 
913     // No payable fallback function, the tokens must be buyed using the functions buyTokens and buyTokensFor
914     function () public {
915         revert("No payable fallback function");
916     }
917 
918     // low level token purchase function
919     // function buyTokens(address beneficiary) public payable whenNotPaused {
920     function releaseTokensTo(address beneficiary) internal whenNotPaused returns(bool) {
921         require(beneficiary != address(0), "beneficiary is zero");
922         require(isValidPurchase(beneficiary), "invalid purchase by beneficiary");
923 
924         balanceOf[beneficiary] = balanceOf[beneficiary].add(msg.value);
925 
926         raisedFunds = raisedFunds.add(msg.value);
927 
928         uint256 tokenAmount = calculateTokens(msg.value);
929 
930         soldTokens = soldTokens.add(tokenAmount);
931 
932         distributeTokens(beneficiary, tokenAmount);
933 
934         emit LogTokenPurchase(msg.sender, beneficiary, msg.value, tokenAmount);
935 
936         forwardFunds(msg.value);
937 
938         return true;
939     }
940 
941     /**
942      * @dev Overrides Whitelistable#isAllowedBalance to add minimum deposit logic.
943      */
944     function isAllowedBalance(address beneficiary, uint256 balance) public view returns (bool isReallyAllowed) {
945         bool hasMinimumBalance = balance >= minDeposit;
946         return hasMinimumBalance && super.isAllowedBalance(beneficiary, balance);
947     }
948 
949     /**
950      * @dev Determine if the token purchase is valid or not.
951      * @return true if the transaction can buy tokens
952      */
953     function isValidPurchase(address beneficiary) internal view returns (bool isValid) {
954         bool withinPeriod = startBlock <= block.number && block.number <= endBlock;
955         bool nonZeroPurchase = msg.value != 0;
956         bool isValidBalance = isAllowedBalance(beneficiary, balanceOf[beneficiary].add(msg.value));
957 
958         return withinPeriod && nonZeroPurchase && isValidBalance;
959     }
960 
961     // Calculate the token amount given the invested ether amount.
962     // Override to create custom fund forwarding mechanisms
963     function calculateTokens(uint256 amount) internal view returns (uint256 tokenAmount) {
964         return amount.mul(rate);
965     }
966 
967     /**
968      * @dev Distribute the token amount to the beneficiary.
969      * @notice Override to create custom distribution mechanisms
970      */
971     function distributeTokens(address beneficiary, uint256 tokenAmount) internal {
972         token.mint(beneficiary, tokenAmount);
973     }
974 
975     // Send ether amount to the fund collection wallet.
976     // override to create custom fund forwarding mechanisms
977     function forwardFunds(uint256 amount) internal;
978 }
979 
980 // File: openzeppelin-solidity/contracts/token/ERC20/BurnableToken.sol
981 
982 pragma solidity ^0.4.23;
983 
984 
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
1016 pragma solidity ^0.4.23;
1017 
1018 
1019 
1020 /**
1021  * @title DetailedERC20 token
1022  * @dev The decimals are only for visualization purposes.
1023  * All the operations are done using the smallest and indivisible token unit,
1024  * just as on Ethereum all the operations are done in wei.
1025  */
1026 contract DetailedERC20 is ERC20 {
1027   string public name;
1028   string public symbol;
1029   uint8 public decimals;
1030 
1031   constructor(string _name, string _symbol, uint8 _decimals) public {
1032     name = _name;
1033     symbol = _symbol;
1034     decimals = _decimals;
1035   }
1036 }
1037 
1038 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
1039 
1040 pragma solidity ^0.4.23;
1041 
1042 
1043 
1044 
1045 /**
1046  * @title SafeERC20
1047  * @dev Wrappers around ERC20 operations that throw on failure.
1048  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
1049  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
1050  */
1051 library SafeERC20 {
1052   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
1053     require(token.transfer(to, value));
1054   }
1055 
1056   function safeTransferFrom(
1057     ERC20 token,
1058     address from,
1059     address to,
1060     uint256 value
1061   )
1062     internal
1063   {
1064     require(token.transferFrom(from, to, value));
1065   }
1066 
1067   function safeApprove(ERC20 token, address spender, uint256 value) internal {
1068     require(token.approve(spender, value));
1069   }
1070 }
1071 
1072 // File: openzeppelin-solidity/contracts/token/ERC20/TokenTimelock.sol
1073 
1074 pragma solidity ^0.4.23;
1075 
1076 
1077 
1078 /**
1079  * @title TokenTimelock
1080  * @dev TokenTimelock is a token holder contract that will allow a
1081  * beneficiary to extract the tokens after a given release time
1082  */
1083 contract TokenTimelock {
1084   using SafeERC20 for ERC20Basic;
1085 
1086   // ERC20 basic token contract being held
1087   ERC20Basic public token;
1088 
1089   // beneficiary of tokens after they are released
1090   address public beneficiary;
1091 
1092   // timestamp when token release is enabled
1093   uint256 public releaseTime;
1094 
1095   constructor(
1096     ERC20Basic _token,
1097     address _beneficiary,
1098     uint256 _releaseTime
1099   )
1100     public
1101   {
1102     // solium-disable-next-line security/no-block-members
1103     require(_releaseTime > block.timestamp);
1104     token = _token;
1105     beneficiary = _beneficiary;
1106     releaseTime = _releaseTime;
1107   }
1108 
1109   /**
1110    * @notice Transfers tokens held by timelock to beneficiary.
1111    */
1112   function release() public {
1113     // solium-disable-next-line security/no-block-members
1114     require(block.timestamp >= releaseTime);
1115 
1116     uint256 amount = token.balanceOf(this);
1117     require(amount > 0);
1118 
1119     token.safeTransfer(beneficiary, amount);
1120   }
1121 }
1122 
1123 // File: openzeppelin-solidity/contracts/token/ERC20/TokenVesting.sol
1124 
1125 /* solium-disable security/no-block-members */
1126 
1127 pragma solidity ^0.4.23;
1128 
1129 
1130 
1131 
1132 
1133 
1134 /**
1135  * @title TokenVesting
1136  * @dev A token holder contract that can release its token balance gradually like a
1137  * typical vesting scheme, with a cliff and vesting period. Optionally revocable by the
1138  * owner.
1139  */
1140 contract TokenVesting is Ownable {
1141   using SafeMath for uint256;
1142   using SafeERC20 for ERC20Basic;
1143 
1144   event Released(uint256 amount);
1145   event Revoked();
1146 
1147   // beneficiary of tokens after they are released
1148   address public beneficiary;
1149 
1150   uint256 public cliff;
1151   uint256 public start;
1152   uint256 public duration;
1153 
1154   bool public revocable;
1155 
1156   mapping (address => uint256) public released;
1157   mapping (address => bool) public revoked;
1158 
1159   /**
1160    * @dev Creates a vesting contract that vests its balance of any ERC20 token to the
1161    * _beneficiary, gradually in a linear fashion until _start + _duration. By then all
1162    * of the balance will have vested.
1163    * @param _beneficiary address of the beneficiary to whom vested tokens are transferred
1164    * @param _cliff duration in seconds of the cliff in which tokens will begin to vest
1165    * @param _start the time (as Unix time) at which point vesting starts 
1166    * @param _duration duration in seconds of the period in which the tokens will vest
1167    * @param _revocable whether the vesting is revocable or not
1168    */
1169   constructor(
1170     address _beneficiary,
1171     uint256 _start,
1172     uint256 _cliff,
1173     uint256 _duration,
1174     bool _revocable
1175   )
1176     public
1177   {
1178     require(_beneficiary != address(0));
1179     require(_cliff <= _duration);
1180 
1181     beneficiary = _beneficiary;
1182     revocable = _revocable;
1183     duration = _duration;
1184     cliff = _start.add(_cliff);
1185     start = _start;
1186   }
1187 
1188   /**
1189    * @notice Transfers vested tokens to beneficiary.
1190    * @param token ERC20 token which is being vested
1191    */
1192   function release(ERC20Basic token) public {
1193     uint256 unreleased = releasableAmount(token);
1194 
1195     require(unreleased > 0);
1196 
1197     released[token] = released[token].add(unreleased);
1198 
1199     token.safeTransfer(beneficiary, unreleased);
1200 
1201     emit Released(unreleased);
1202   }
1203 
1204   /**
1205    * @notice Allows the owner to revoke the vesting. Tokens already vested
1206    * remain in the contract, the rest are returned to the owner.
1207    * @param token ERC20 token which is being vested
1208    */
1209   function revoke(ERC20Basic token) public onlyOwner {
1210     require(revocable);
1211     require(!revoked[token]);
1212 
1213     uint256 balance = token.balanceOf(this);
1214 
1215     uint256 unreleased = releasableAmount(token);
1216     uint256 refund = balance.sub(unreleased);
1217 
1218     revoked[token] = true;
1219 
1220     token.safeTransfer(owner, refund);
1221 
1222     emit Revoked();
1223   }
1224 
1225   /**
1226    * @dev Calculates the amount that has already vested but hasn't been released yet.
1227    * @param token ERC20 token which is being vested
1228    */
1229   function releasableAmount(ERC20Basic token) public view returns (uint256) {
1230     return vestedAmount(token).sub(released[token]);
1231   }
1232 
1233   /**
1234    * @dev Calculates the amount that has already vested.
1235    * @param token ERC20 token which is being vested
1236    */
1237   function vestedAmount(ERC20Basic token) public view returns (uint256) {
1238     uint256 currentBalance = token.balanceOf(this);
1239     uint256 totalBalance = currentBalance.add(released[token]);
1240 
1241     if (block.timestamp < cliff) {
1242       return 0;
1243     } else if (block.timestamp >= start.add(duration) || revoked[token]) {
1244       return totalBalance;
1245     } else {
1246       return totalBalance.mul(block.timestamp.sub(start)).div(duration);
1247     }
1248   }
1249 }
1250 
1251 // File: contracts/NokuCustomToken.sol
1252 
1253 pragma solidity ^0.4.23;
1254 
1255 
1256 
1257 contract NokuCustomToken is Ownable {
1258 
1259     event LogBurnFinished();
1260     event LogPricingPlanChanged(address indexed caller, address indexed pricingPlan);
1261 
1262     // The pricing plan determining the fee to be paid in NOKU tokens by customers for using Noku services
1263     NokuPricingPlan public pricingPlan;
1264 
1265     // The entity acting as Custom Token service provider i.e. Noku
1266     address public serviceProvider;
1267 
1268     // Flag indicating if Custom Token burning has been permanently finished or not.
1269     bool public burningFinished;
1270 
1271     /**
1272     * @dev Modifier to make a function callable only by service provider i.e. Noku.
1273     */
1274     modifier onlyServiceProvider() {
1275         require(msg.sender == serviceProvider, "caller is not service provider");
1276         _;
1277     }
1278 
1279     modifier canBurn() {
1280         require(!burningFinished, "burning finished");
1281         _;
1282     }
1283 
1284     constructor(address _pricingPlan, address _serviceProvider) internal {
1285         require(_pricingPlan != 0, "_pricingPlan is zero");
1286         require(_serviceProvider != 0, "_serviceProvider is zero");
1287 
1288         pricingPlan = NokuPricingPlan(_pricingPlan);
1289         serviceProvider = _serviceProvider;
1290     }
1291 
1292     /**
1293     * @dev Presence of this function indicates the contract is a Custom Token.
1294     */
1295     function isCustomToken() public pure returns(bool isCustom) {
1296         return true;
1297     }
1298 
1299     /**
1300     * @dev Stop burning new tokens.
1301     * @return true if the operation was successful.
1302     */
1303     function finishBurning() public onlyOwner canBurn returns(bool finished) {
1304         burningFinished = true;
1305 
1306         emit LogBurnFinished();
1307 
1308         return true;
1309     }
1310 
1311     /**
1312     * @dev Change the pricing plan of service fee to be paid in NOKU tokens.
1313     * @param _pricingPlan The pricing plan of NOKU token to be paid, zero means flat subscription.
1314     */
1315     function setPricingPlan(address _pricingPlan) public onlyServiceProvider {
1316         require(_pricingPlan != 0, "_pricingPlan is 0");
1317         require(_pricingPlan != address(pricingPlan), "_pricingPlan == pricingPlan");
1318 
1319         pricingPlan = NokuPricingPlan(_pricingPlan);
1320 
1321         emit LogPricingPlanChanged(msg.sender, _pricingPlan);
1322     }
1323 }
1324 
1325 // File: contracts/NokuTokenBurner.sol
1326 
1327 pragma solidity ^0.4.23;
1328 
1329 
1330 
1331 
1332 contract BurnableERC20 is ERC20 {
1333     function burn(uint256 amount) public returns (bool burned);
1334 }
1335 
1336 /**
1337 * @dev The NokuTokenBurner contract has the responsibility to burn the configured fraction of received
1338 * ERC20-compliant tokens and distribute the remainder to the configured wallet.
1339 */
1340 contract NokuTokenBurner is Pausable {
1341     using SafeMath for uint256;
1342 
1343     event LogNokuTokenBurnerCreated(address indexed caller, address indexed wallet);
1344     event LogBurningPercentageChanged(address indexed caller, uint256 indexed burningPercentage);
1345 
1346     // The wallet receiving the unburnt tokens.
1347     address public wallet;
1348 
1349     // The percentage of tokens to burn after being received (range [0, 100])
1350     uint256 public burningPercentage;
1351 
1352     // The cumulative amount of burnt tokens.
1353     uint256 public burnedTokens;
1354 
1355     // The cumulative amount of tokens transferred back to the wallet.
1356     uint256 public transferredTokens;
1357 
1358     /**
1359     * @dev Create a new NokuTokenBurner with predefined burning fraction.
1360     * @param _wallet The wallet receiving the unburnt tokens.
1361     */
1362     constructor(address _wallet) public {
1363         require(_wallet != address(0), "_wallet is zero");
1364         
1365         wallet = _wallet;
1366         burningPercentage = 100;
1367 
1368         emit LogNokuTokenBurnerCreated(msg.sender, _wallet);
1369     }
1370 
1371     /**
1372     * @dev Change the percentage of tokens to burn after being received.
1373     * @param _burningPercentage The percentage of tokens to be burnt.
1374     */
1375     function setBurningPercentage(uint256 _burningPercentage) public onlyOwner {
1376         require(0 <= _burningPercentage && _burningPercentage <= 100, "_burningPercentage not in [0, 100]");
1377         require(_burningPercentage != burningPercentage, "_burningPercentage equal to current one");
1378         
1379         burningPercentage = _burningPercentage;
1380 
1381         emit LogBurningPercentageChanged(msg.sender, _burningPercentage);
1382     }
1383 
1384     /**
1385     * @dev Called after burnable tokens has been transferred for burning.
1386     * @param _token THe extended ERC20 interface supported by the sent tokens.
1387     * @param _amount The amount of burnable tokens just arrived ready for burning.
1388     */
1389     function tokenReceived(address _token, uint256 _amount) public whenNotPaused {
1390         require(_token != address(0), "_token is zero");
1391         require(_amount > 0, "_amount is zero");
1392 
1393         uint256 amountToBurn = _amount.mul(burningPercentage).div(100);
1394         if (amountToBurn > 0) {
1395             assert(BurnableERC20(_token).burn(amountToBurn));
1396             
1397             burnedTokens = burnedTokens.add(amountToBurn);
1398         }
1399 
1400         uint256 amountToTransfer = _amount.sub(amountToBurn);
1401         if (amountToTransfer > 0) {
1402             assert(BurnableERC20(_token).transfer(wallet, amountToTransfer));
1403 
1404             transferredTokens = transferredTokens.add(amountToTransfer);
1405         }
1406     }
1407 }
1408 
1409 // File: contracts/NokuCustomERC20.sol
1410 
1411 pragma solidity ^0.4.23;
1412 
1413 
1414 
1415 
1416 
1417 
1418 
1419 
1420 
1421 /**
1422 * @dev The NokuCustomERC20Token contract is a custom ERC20-compliant token available in the Noku Service Platform (NSP).
1423 * The Noku customer is able to choose the token name, symbol, decimals, initial supply and to administer its lifecycle
1424 * by minting or burning tokens in order to increase or decrease the token supply.
1425 */
1426 contract NokuCustomERC20 is NokuCustomToken, DetailedERC20, MintableToken, BurnableToken {
1427     using SafeMath for uint256;
1428 
1429     event LogNokuCustomERC20Created(
1430         address indexed caller,
1431         string indexed name,
1432         string indexed symbol,
1433         uint8 decimals,
1434         uint256 transferableFromBlock,
1435         uint256 lockEndBlock,
1436         address pricingPlan,
1437         address serviceProvider
1438     );
1439     event LogMintingFeeEnabledChanged(address indexed caller, bool indexed mintingFeeEnabled);
1440     event LogInformationChanged(address indexed caller, string name, string symbol);
1441     event LogTransferFeePaymentFinished(address indexed caller);
1442     event LogTransferFeePercentageChanged(address indexed caller, uint256 indexed transferFeePercentage);
1443 
1444     // Flag indicating if minting fees are enabled or disabled
1445     bool public mintingFeeEnabled;
1446 
1447     // Block number from which tokens are initially transferable
1448     uint256 public transferableFromBlock;
1449 
1450     // Block number from which initial lock ends
1451     uint256 public lockEndBlock;
1452 
1453     // The initially locked balances by address
1454     mapping (address => uint256) public initiallyLockedBalanceOf;
1455 
1456     // The fee percentage for Custom Token transfer or zero if transfer is free of charge
1457     uint256 public transferFeePercentage;
1458 
1459     // Flag indicating if fee payment in Custom Token transfer has been permanently finished or not. 
1460     bool public transferFeePaymentFinished;
1461 
1462     bytes32 public constant BURN_SERVICE_NAME = "NokuCustomERC20.burn";
1463     bytes32 public constant MINT_SERVICE_NAME = "NokuCustomERC20.mint";
1464 
1465     modifier canTransfer(address _from, uint _value) {
1466         require(block.number >= transferableFromBlock, "token not transferable");
1467 
1468         if (block.number < lockEndBlock) {
1469             uint256 locked = lockedBalanceOf(_from);
1470             if (locked > 0) {
1471                 uint256 newBalance = balanceOf(_from).sub(_value);
1472                 require(newBalance >= locked, "_value exceeds locked amount");
1473             }
1474         }
1475         _;
1476     }
1477 
1478     constructor(
1479         string _name,
1480         string _symbol,
1481         uint8 _decimals,
1482         uint256 _transferableFromBlock,
1483         uint256 _lockEndBlock,
1484         address _pricingPlan,
1485         address _serviceProvider
1486     )
1487     NokuCustomToken(_pricingPlan, _serviceProvider)
1488     DetailedERC20(_name, _symbol, _decimals) public
1489     {
1490         require(bytes(_name).length > 0, "_name is empty");
1491         require(bytes(_symbol).length > 0, "_symbol is empty");
1492         require(_lockEndBlock >= _transferableFromBlock, "_lockEndBlock lower than _transferableFromBlock");
1493 
1494         transferableFromBlock = _transferableFromBlock;
1495         lockEndBlock = _lockEndBlock;
1496         mintingFeeEnabled = true;
1497 
1498         emit LogNokuCustomERC20Created(
1499             msg.sender,
1500             _name,
1501             _symbol,
1502             _decimals,
1503             _transferableFromBlock,
1504             _lockEndBlock,
1505             _pricingPlan,
1506             _serviceProvider
1507         );
1508     }
1509 
1510     function setMintingFeeEnabled(bool _mintingFeeEnabled) public onlyOwner returns(bool successful) {
1511         require(_mintingFeeEnabled != mintingFeeEnabled, "_mintingFeeEnabled == mintingFeeEnabled");
1512 
1513         mintingFeeEnabled = _mintingFeeEnabled;
1514 
1515         emit LogMintingFeeEnabledChanged(msg.sender, _mintingFeeEnabled);
1516 
1517         return true;
1518     }
1519 
1520     /**
1521     * @dev Change the Custom Token detailed information after creation.
1522     * @param _name The name to assign to the Custom Token.
1523     * @param _symbol The symbol to assign to the Custom Token.
1524     */
1525     function setInformation(string _name, string _symbol) public onlyOwner returns(bool successful) {
1526         require(bytes(_name).length > 0, "_name is empty");
1527         require(bytes(_symbol).length > 0, "_symbol is empty");
1528 
1529         name = _name;
1530         symbol = _symbol;
1531 
1532         emit LogInformationChanged(msg.sender, _name, _symbol);
1533 
1534         return true;
1535     }
1536 
1537     /**
1538     * @dev Stop trasfer fee payment for tokens.
1539     * @return true if the operation was successful.
1540     */
1541     function finishTransferFeePayment() public onlyOwner returns(bool finished) {
1542         require(!transferFeePaymentFinished, "transfer fee finished");
1543 
1544         transferFeePaymentFinished = true;
1545 
1546         emit LogTransferFeePaymentFinished(msg.sender);
1547 
1548         return true;
1549     }
1550 
1551     /**
1552     * @dev Change the transfer fee percentage to be paid in Custom tokens.
1553     * @param _transferFeePercentage The fee percentage to be paid for transfer in range [0, 100].
1554     */
1555     function setTransferFeePercentage(uint256 _transferFeePercentage) public onlyOwner {
1556         require(0 <= _transferFeePercentage && _transferFeePercentage <= 100, "_transferFeePercentage not in [0, 100]");
1557         require(_transferFeePercentage != transferFeePercentage, "_transferFeePercentage equal to current value");
1558 
1559         transferFeePercentage = _transferFeePercentage;
1560 
1561         emit LogTransferFeePercentageChanged(msg.sender, _transferFeePercentage);
1562     }
1563 
1564     function lockedBalanceOf(address _to) public constant returns(uint256 locked) {
1565         uint256 initiallyLocked = initiallyLockedBalanceOf[_to];
1566         if (block.number >= lockEndBlock) return 0;
1567         else if (block.number <= transferableFromBlock) return initiallyLocked;
1568 
1569         uint256 releaseForBlock = initiallyLocked.div(lockEndBlock.sub(transferableFromBlock));
1570         uint256 released = block.number.sub(transferableFromBlock).mul(releaseForBlock);
1571         return initiallyLocked.sub(released);
1572     }
1573 
1574     /**
1575     * @dev Get the fee to be paid for the transfer of NOKU tokens.
1576     * @param _value The amount of NOKU tokens to be transferred.
1577     */
1578     function transferFee(uint256 _value) public view returns(uint256 usageFee) {
1579         return _value.mul(transferFeePercentage).div(100);
1580     }
1581 
1582     /**
1583     * @dev Check if token transfer is free of any charge or not.
1584     * @return true if transfer is free of any charge.
1585     */
1586     function freeTransfer() public view returns (bool isTransferFree) {
1587         return transferFeePaymentFinished || transferFeePercentage == 0;
1588     }
1589 
1590     /**
1591     * @dev Override #transfer for optionally paying fee to Custom token owner.
1592     */
1593     function transfer(address _to, uint256 _value) canTransfer(msg.sender, _value) public returns(bool transferred) {
1594         if (freeTransfer()) {
1595             return super.transfer(_to, _value);
1596         }
1597         else {
1598             uint256 usageFee = transferFee(_value);
1599             uint256 netValue = _value.sub(usageFee);
1600 
1601             bool feeTransferred = super.transfer(owner, usageFee);
1602             bool netValueTransferred = super.transfer(_to, netValue);
1603 
1604             return feeTransferred && netValueTransferred;
1605         }
1606     }
1607 
1608     /**
1609     * @dev Override #transferFrom for optionally paying fee to Custom token owner.
1610     */
1611     function transferFrom(address _from, address _to, uint256 _value) canTransfer(_from, _value) public returns(bool transferred) {
1612         if (freeTransfer()) {
1613             return super.transferFrom(_from, _to, _value);
1614         }
1615         else {
1616             uint256 usageFee = transferFee(_value);
1617             uint256 netValue = _value.sub(usageFee);
1618 
1619             bool feeTransferred = super.transferFrom(_from, owner, usageFee);
1620             bool netValueTransferred = super.transferFrom(_from, _to, netValue);
1621 
1622             return feeTransferred && netValueTransferred;
1623         }
1624     }
1625 
1626     /**
1627     * @dev Burn a specific amount of tokens, paying the service fee.
1628     * @param _amount The amount of token to be burned.
1629     */
1630     function burn(uint256 _amount) public canBurn {
1631         require(_amount > 0, "_amount is zero");
1632 
1633         super.burn(_amount);
1634 
1635         require(pricingPlan.payFee(BURN_SERVICE_NAME, _amount, msg.sender), "burn fee failed");
1636     }
1637 
1638     /**
1639     * @dev Mint a specific amount of tokens, paying the service fee.
1640     * @param _to The address that will receive the minted tokens.
1641     * @param _amount The amount of tokens to mint.
1642     * @return A boolean that indicates if the operation was successful.
1643     */
1644     function mint(address _to, uint256 _amount) public onlyOwner canMint returns(bool minted) {
1645         require(_to != 0, "_to is zero");
1646         require(_amount > 0, "_amount is zero");
1647 
1648         super.mint(_to, _amount);
1649 
1650         if (mintingFeeEnabled) {
1651             require(pricingPlan.payFee(MINT_SERVICE_NAME, _amount, msg.sender), "mint fee failed");
1652         }
1653 
1654         return true;
1655     }
1656 
1657     /**
1658     * @dev Mint new locked tokens, which will unlock progressively.
1659     * @param _to The address that will receieve the minted locked tokens.
1660     * @param _amount The amount of tokens to mint.
1661     * @return A boolean that indicates if the operation was successful.
1662     */
1663     function mintLocked(address _to, uint256 _amount) public onlyOwner canMint returns(bool minted) {
1664         initiallyLockedBalanceOf[_to] = initiallyLockedBalanceOf[_to].add(_amount);
1665         
1666         return mint(_to, _amount);
1667     }
1668 
1669     /**
1670      * @dev Mint timelocked tokens.
1671      * @param _to The address that will receieve the minted locked tokens.
1672      * @param _amount The amount of tokens to mint.
1673      * @param _releaseTime The token release time as timestamp from Unix epoch.
1674      * @return A boolean that indicates if the operation was successful.
1675      */
1676     /*function mintTimelocked(address _to, uint256 _amount, uint256 _releaseTime) public onlyOwner canMint
1677     returns (TokenTimelock tokenTimelock)
1678     {
1679         TokenTimelock timelock = new TokenTimelock(this, _to, _releaseTime);
1680         mint(timelock, _amount);
1681 
1682         return timelock;
1683     }*/
1684 
1685     /**
1686     * @dev Mint vested tokens.
1687     * @param _to The address that will receieve the minted vested tokens.
1688     * @param _amount The amount of tokens to mint.
1689     * @param _startTime When the vesting starts as timestamp in seconds from Unix epoch.
1690     * @param _duration The duration in seconds of the period in which the tokens will vest.
1691     * @return A boolean that indicates if the operation was successful.
1692     */
1693     /*function mintVested(address _to, uint256 _amount, uint256 _startTime, uint256 _duration) public onlyOwner canMint
1694     returns (TokenVesting tokenVesting)
1695     {
1696         TokenVesting vesting = new TokenVesting(_to, _startTime, 0, _duration, true);
1697         mint(vesting, _amount);
1698 
1699         return vesting;
1700     }*/
1701 
1702     /**
1703      * @dev Release vested tokens to beneficiary.
1704      * @param _vesting The token vesting to release.
1705      */
1706     /*function releaseVested(TokenVesting _vesting) public {
1707         require(_vesting != address(0));
1708 
1709         _vesting.release(this);
1710     }*/
1711 
1712     /**
1713      * @dev Revoke vested tokens. Just the token can revoke because it is the vesting owner.
1714      * @param _vesting The token vesting to revoke.
1715      */
1716     /*function revokeVested(TokenVesting _vesting) public onlyOwner {
1717         require(_vesting != address(0));
1718 
1719         _vesting.revoke(this);
1720     }*/
1721 }
1722 
1723 // File: contracts/TokenCappedCrowdsaleKYC.sol
1724 
1725 pragma solidity ^0.4.23;
1726 
1727 
1728 
1729 /**
1730  * @title CappedCrowdsaleKYC
1731  * @dev Extension of Crowsdale with a max amount of funds raised
1732  */
1733 contract TokenCappedCrowdsaleKYC is CrowdsaleKYC {
1734     using SafeMath for uint256;
1735 
1736     // The maximum token cap, should be initialized in derived contract
1737     uint256 public tokenCap;
1738 
1739     // Overriding Crowdsale#hasEnded to add tokenCap logic
1740     // @return true if crowdsale event has ended
1741     function hasEnded() public constant returns (bool) {
1742         bool capReached = soldTokens >= tokenCap;
1743         return super.hasEnded() || capReached;
1744     }
1745 
1746     // Overriding Crowdsale#isValidPurchase to add extra cap logic
1747     // @return true if investors can buy at the moment
1748     function isValidPurchase(address beneficiary) internal constant returns (bool isValid) {
1749         uint256 tokenAmount = calculateTokens(msg.value);
1750         bool withinCap = soldTokens.add(tokenAmount) <= tokenCap;
1751         return withinCap && super.isValidPurchase(beneficiary);
1752     }
1753 }
1754 
1755 // File: contracts/NokuCustomCrowdsaleKYC.sol
1756 
1757 pragma solidity ^0.4.23;
1758 
1759 
1760 
1761 
1762 
1763 
1764 /**
1765  * @title NokuCustomCrowdsaleKYC
1766  * @dev Extension of TokenCappedCrowdsaleKYC using values specific for Noku Custom ICO crowdsale
1767  */
1768 contract NokuCustomCrowdsaleKYC is TokenCappedCrowdsaleKYC {
1769     using AddressUtils for address;
1770     using SafeMath for uint256;
1771 
1772     event LogNokuCustomCrowdsaleCreated(
1773         address sender,
1774         uint256 indexed startBlock,
1775         uint256 indexed endBlock,
1776         address indexed wallet
1777     );
1778     event LogThreePowerAgesChanged(
1779         address indexed sender,
1780         uint256 indexed platinumAgeEndBlock,
1781         uint256 indexed goldenAgeEndBlock,
1782         uint256 silverAgeEndBlock,
1783         uint256 platinumAgeRate,
1784         uint256 goldenAgeRate,
1785         uint256 silverAgeRate
1786     );
1787     event LogTwoPowerAgesChanged(
1788         address indexed sender,
1789         uint256 indexed platinumAgeEndBlock,
1790         uint256 indexed goldenAgeEndBlock,
1791         uint256 platinumAgeRate,
1792         uint256 goldenAgeRate
1793     );
1794     event LogOnePowerAgeChanged(address indexed sender, uint256 indexed platinumAgeEndBlock, uint256 indexed platinumAgeRate);
1795 
1796     // The end block of the 'platinum' age interval
1797     uint256 public platinumAgeEndBlock;
1798 
1799     // The end block of the 'golden' age interval
1800     uint256 public goldenAgeEndBlock;
1801 
1802     // The end block of the 'silver' age interval
1803     uint256 public silverAgeEndBlock;
1804 
1805     // The conversion rate of the 'platinum' age
1806     uint256 public platinumAgeRate;
1807 
1808     // The conversion rate of the 'golden' age
1809     uint256 public goldenAgeRate;
1810 
1811     // The conversion rate of the 'silver' age
1812     uint256 public silverAgeRate;
1813 
1814     // The wallet address or contract
1815     address public wallet;
1816 
1817     constructor(
1818         uint256 _startBlock,
1819         uint256 _endBlock,
1820         uint256 _rate,
1821         uint256 _minDeposit,
1822         uint256 _maxWhitelistLength,
1823         uint256 _whitelistThreshold,
1824         address _token,
1825         uint256 _tokenMaximumSupply,
1826         address _wallet,
1827         address[] _kycSigner
1828     )
1829     CrowdsaleKYC(
1830         _startBlock,
1831         _endBlock,
1832         _rate,
1833         _minDeposit,
1834         _maxWhitelistLength,
1835         _whitelistThreshold,
1836         _kycSigner
1837     )
1838     public {
1839         require(_token.isContract(), "_token is not contract");
1840         require(_tokenMaximumSupply > 0, "_tokenMaximumSupply is zero");
1841 
1842         platinumAgeRate = _rate;
1843         goldenAgeRate = _rate;
1844         silverAgeRate = _rate;
1845 
1846         token = NokuCustomERC20(_token);
1847         wallet = _wallet;
1848 
1849         // Assume predefined token supply has been minted and calculate the maximum number of tokens that can be sold
1850         tokenCap = _tokenMaximumSupply.sub(token.totalSupply());
1851 
1852         emit LogNokuCustomCrowdsaleCreated(msg.sender, startBlock, endBlock, _wallet);
1853     }
1854 
1855     function setThreePowerAges(
1856         uint256 _platinumAgeEndBlock,
1857         uint256 _goldenAgeEndBlock,
1858         uint256 _silverAgeEndBlock,
1859         uint256 _platinumAgeRate,
1860         uint256 _goldenAgeRate,
1861         uint256 _silverAgeRate
1862     )
1863     external onlyOwner beforeStart
1864     {
1865         require(startBlock < _platinumAgeEndBlock, "_platinumAgeEndBlock not greater than start block");
1866         require(_platinumAgeEndBlock < _goldenAgeEndBlock, "_platinumAgeEndBlock not lower than _goldenAgeEndBlock");
1867         require(_goldenAgeEndBlock < _silverAgeEndBlock, "_silverAgeEndBlock not greater than _goldenAgeEndBlock");
1868         require(_silverAgeEndBlock <= endBlock, "_silverAgeEndBlock greater than end block");
1869         require(_platinumAgeRate > _goldenAgeRate, "_platinumAgeRate not greater than _goldenAgeRate");
1870         require(_goldenAgeRate > _silverAgeRate, "_goldenAgeRate not greater than _silverAgeRate");
1871         require(_silverAgeRate > rate, "_silverAgeRate not greater than nominal rate");
1872 
1873         platinumAgeEndBlock = _platinumAgeEndBlock;
1874         goldenAgeEndBlock = _goldenAgeEndBlock;
1875         silverAgeEndBlock = _silverAgeEndBlock;
1876 
1877         platinumAgeRate = _platinumAgeRate;
1878         goldenAgeRate = _goldenAgeRate;
1879         silverAgeRate = _silverAgeRate;
1880 
1881         emit LogThreePowerAgesChanged(
1882             msg.sender,
1883             _platinumAgeEndBlock,
1884             _goldenAgeEndBlock,
1885             _silverAgeEndBlock,
1886             _platinumAgeRate,
1887             _goldenAgeRate,
1888             _silverAgeRate
1889         );
1890     }
1891 
1892     function setTwoPowerAges(
1893         uint256 _platinumAgeEndBlock,
1894         uint256 _goldenAgeEndBlock,
1895         uint256 _platinumAgeRate,
1896         uint256 _goldenAgeRate
1897     )
1898     external onlyOwner beforeStart
1899     {
1900         require(startBlock < _platinumAgeEndBlock, "_platinumAgeEndBlock not greater than start block");
1901         require(_platinumAgeEndBlock < _goldenAgeEndBlock, "_platinumAgeEndBlock not lower than _goldenAgeEndBlock");
1902         require(_goldenAgeEndBlock <= endBlock, "_goldenAgeEndBlock greater than end block");
1903         require(_platinumAgeRate > _goldenAgeRate, "_platinumAgeRate not greater than _goldenAgeRate");
1904         require(_goldenAgeRate > rate, "_goldenAgeRate not greater than nominal rate");
1905 
1906         platinumAgeEndBlock = _platinumAgeEndBlock;
1907         goldenAgeEndBlock = _goldenAgeEndBlock;
1908 
1909         platinumAgeRate = _platinumAgeRate;
1910         goldenAgeRate = _goldenAgeRate;
1911         silverAgeRate = rate;
1912 
1913         emit LogTwoPowerAgesChanged(
1914             msg.sender,
1915             _platinumAgeEndBlock,
1916             _goldenAgeEndBlock,
1917             _platinumAgeRate,
1918             _goldenAgeRate
1919         );
1920     }
1921 
1922     function setOnePowerAge(uint256 _platinumAgeEndBlock, uint256 _platinumAgeRate)
1923     external onlyOwner beforeStart
1924     {
1925         require(startBlock < _platinumAgeEndBlock, "_platinumAgeEndBlock not greater than start block");
1926         require(_platinumAgeEndBlock <= endBlock, "_platinumAgeEndBlock greater than end block");
1927         require(_platinumAgeRate > rate, "_platinumAgeRate not greater than nominal rate");
1928 
1929         platinumAgeEndBlock = _platinumAgeEndBlock;
1930 
1931         platinumAgeRate = _platinumAgeRate;
1932         goldenAgeRate = rate;
1933         silverAgeRate = rate;
1934 
1935         emit LogOnePowerAgeChanged(msg.sender, _platinumAgeEndBlock, _platinumAgeRate);
1936     }
1937 
1938     function grantTokenOwnership(address _client) external onlyOwner returns(bool granted) {
1939         require(!_client.isContract(), "_client is contract");
1940         require(hasEnded(), "crowdsale not ended yet");
1941 
1942         // Transfer NokuCustomERC20 ownership back to the client
1943         token.transferOwnership(_client);
1944 
1945         return true;
1946     }
1947 
1948     // Overriding Crowdsale#calculateTokens to apply age discounts to token calculus.
1949     function calculateTokens(uint256 amount) internal view returns(uint256 tokenAmount) {
1950         uint256 conversionRate = block.number <= platinumAgeEndBlock ? platinumAgeRate :
1951             block.number <= goldenAgeEndBlock ? goldenAgeRate :
1952             block.number <= silverAgeEndBlock ? silverAgeRate :
1953             rate;
1954 
1955         return amount.mul(conversionRate);
1956     }
1957 
1958     /**
1959      * @dev Overriding Crowdsale#distributeTokens to apply age rules to token distributions.
1960      */
1961     function distributeTokens(address beneficiary, uint256 tokenAmount) internal {
1962         if (block.number <= platinumAgeEndBlock) {
1963             NokuCustomERC20(token).mintLocked(beneficiary, tokenAmount);
1964         }
1965         else {
1966             super.distributeTokens(beneficiary, tokenAmount);
1967         }
1968     }
1969 
1970     /**
1971      * @dev Overriding Crowdsale#forwardFunds to split net/fee payment.
1972      */
1973     function forwardFunds(uint256 amount) internal {
1974         wallet.transfer(amount);
1975     }
1976 }
1977 
1978 // File: contracts/NokuCustomCrowdsaleServiceKYC.sol
1979 
1980 pragma solidity ^0.4.23;
1981 
1982 
1983 
1984 /**
1985  * @title NokuCustomCrowdsaleServiceKYC
1986  * @dev Extension of NokuCustomService adding the fee payment in NOKU tokens.
1987  */
1988 contract NokuCustomCrowdsaleServiceKYC is NokuCustomService {
1989     event LogNokuCustomCrowdsaleServiceKYCCreated(address indexed caller);
1990 
1991     bytes32 public constant SERVICE_NAME = "NokuCustomERC20.crowdsale.kyc";
1992     uint256 public constant CREATE_AMOUNT = 1 * 10**18;
1993 
1994     constructor(address _pricingPlan) NokuCustomService(_pricingPlan) public {
1995         emit LogNokuCustomCrowdsaleServiceKYCCreated(msg.sender);
1996     }
1997 
1998     function createCustomCrowdsale(
1999         uint256 _startBlock,
2000         uint256 _endBlock,
2001         uint256 _rate,
2002         uint256 _minDeposit,
2003         uint256 _maxWhitelistLength,
2004         uint256 _whitelistThreshold,
2005         address _token,
2006         uint256 _tokenMaximumSupply,
2007         address _wallet,
2008         address[] _kycSigner
2009     )
2010     public returns(NokuCustomCrowdsaleKYC customCrowdsale)
2011     {
2012         customCrowdsale = new NokuCustomCrowdsaleKYC(
2013             _startBlock,
2014             _endBlock,
2015             _rate,
2016             _minDeposit,
2017             _maxWhitelistLength,
2018             _whitelistThreshold,
2019             _token,
2020             _tokenMaximumSupply,
2021             _wallet,
2022             _kycSigner
2023         );
2024 
2025         // Transfer NokuCustomCrowdsaleKYC ownership to the client
2026         customCrowdsale.transferOwnership(msg.sender);
2027 
2028         require(pricingPlan.payFee(SERVICE_NAME, CREATE_AMOUNT, msg.sender), "fee payment failed");
2029     }
2030 }