1 pragma solidity ^0.4.23;
2 
3 // File: contracts/WhitelistableConstraints.sol
4 
5 /**
6  * @title WhitelistableConstraints
7  * @dev Contract encapsulating the constraints applicable to a Whitelistable contract.
8  */
9 contract WhitelistableConstraints {
10 
11     /**
12      * @dev Check if whitelist with specified parameters is allowed.
13      * @param _maxWhitelistLength The maximum length of whitelist. Zero means no whitelist.
14      * @param _weiWhitelistThresholdBalance The threshold balance triggering whitelist check.
15      * @return true if whitelist with specified parameters is allowed, false otherwise
16      */
17     function isAllowedWhitelist(uint256 _maxWhitelistLength, uint256 _weiWhitelistThresholdBalance)
18         public pure returns(bool isReallyAllowedWhitelist) {
19         return _maxWhitelistLength > 0 || _weiWhitelistThresholdBalance > 0;
20     }
21 }
22 
23 // File: contracts/Whitelistable.sol
24 
25 /**
26  * @title Whitelistable
27  * @dev Base contract implementing a whitelist to keep track of investors.
28  * The construction parameters allow for both whitelisted and non-whitelisted contracts:
29  * 1) maxWhitelistLength = 0 and whitelistThresholdBalance > 0: whitelist disabled
30  * 2) maxWhitelistLength > 0 and whitelistThresholdBalance = 0: whitelist enabled, full whitelisting
31  * 3) maxWhitelistLength > 0 and whitelistThresholdBalance > 0: whitelist enabled, partial whitelisting
32  */
33 contract Whitelistable is WhitelistableConstraints {
34 
35     event LogMaxWhitelistLengthChanged(address indexed caller, uint256 indexed maxWhitelistLength);
36     event LogWhitelistThresholdBalanceChanged(address indexed caller, uint256 indexed whitelistThresholdBalance);
37     event LogWhitelistAddressAdded(address indexed caller, address indexed subscriber);
38     event LogWhitelistAddressRemoved(address indexed caller, address indexed subscriber);
39 
40     mapping (address => bool) public whitelist;
41 
42     uint256 public whitelistLength;
43 
44     uint256 public maxWhitelistLength;
45 
46     uint256 public whitelistThresholdBalance;
47 
48     constructor(uint256 _maxWhitelistLength, uint256 _whitelistThresholdBalance) internal {
49         require(isAllowedWhitelist(_maxWhitelistLength, _whitelistThresholdBalance), "parameters not allowed");
50 
51         maxWhitelistLength = _maxWhitelistLength;
52         whitelistThresholdBalance = _whitelistThresholdBalance;
53     }
54 
55     /**
56      * @return true if whitelist is currently enabled, false otherwise
57      */
58     function isWhitelistEnabled() public view returns(bool isReallyWhitelistEnabled) {
59         return maxWhitelistLength > 0;
60     }
61 
62     /**
63      * @return true if subscriber is whitelisted, false otherwise
64      */
65     function isWhitelisted(address _subscriber) public view returns(bool isReallyWhitelisted) {
66         return whitelist[_subscriber];
67     }
68 
69     function setMaxWhitelistLengthInternal(uint256 _maxWhitelistLength) internal {
70         require(isAllowedWhitelist(_maxWhitelistLength, whitelistThresholdBalance),
71             "_maxWhitelistLength not allowed");
72         require(_maxWhitelistLength != maxWhitelistLength, "_maxWhitelistLength equal to current one");
73 
74         maxWhitelistLength = _maxWhitelistLength;
75 
76         emit LogMaxWhitelistLengthChanged(msg.sender, maxWhitelistLength);
77     }
78 
79     function setWhitelistThresholdBalanceInternal(uint256 _whitelistThresholdBalance) internal {
80         require(isAllowedWhitelist(maxWhitelistLength, _whitelistThresholdBalance),
81             "_whitelistThresholdBalance not allowed");
82         require(whitelistLength == 0 || _whitelistThresholdBalance > whitelistThresholdBalance,
83             "_whitelistThresholdBalance not greater than current one");
84 
85         whitelistThresholdBalance = _whitelistThresholdBalance;
86 
87         emit LogWhitelistThresholdBalanceChanged(msg.sender, _whitelistThresholdBalance);
88     }
89 
90     function addToWhitelistInternal(address _subscriber) internal {
91         require(_subscriber != address(0), "_subscriber is zero");
92         require(!whitelist[_subscriber], "already whitelisted");
93         require(whitelistLength < maxWhitelistLength, "max whitelist length reached");
94 
95         whitelistLength++;
96 
97         whitelist[_subscriber] = true;
98 
99         emit LogWhitelistAddressAdded(msg.sender, _subscriber);
100     }
101 
102     function removeFromWhitelistInternal(address _subscriber, uint256 _balance) internal {
103         require(_subscriber != address(0), "_subscriber is zero");
104         require(whitelist[_subscriber], "not whitelisted");
105         require(_balance <= whitelistThresholdBalance, "_balance greater than whitelist threshold");
106 
107         assert(whitelistLength > 0);
108 
109         whitelistLength--;
110 
111         whitelist[_subscriber] = false;
112 
113         emit LogWhitelistAddressRemoved(msg.sender, _subscriber);
114     }
115 
116     /**
117      * @param _subscriber The subscriber for which the balance check is required.
118      * @param _balance The balance value to check for allowance.
119      * @return true if the balance is allowed for the subscriber, false otherwise
120      */
121     function isAllowedBalance(address _subscriber, uint256 _balance) public view returns(bool isReallyAllowed) {
122         return !isWhitelistEnabled() || _balance <= whitelistThresholdBalance || whitelist[_subscriber];
123     }
124 }
125 
126 // File: openzeppelin-solidity/contracts/AddressUtils.sol
127 
128 /**
129  * Utility library of inline functions on addresses
130  */
131 library AddressUtils {
132 
133   /**
134    * Returns whether the target address is a contract
135    * @dev This function will return false if invoked during the constructor of a contract,
136    *  as the code is not actually created until after the constructor finishes.
137    * @param addr address to check
138    * @return whether the target address is a contract
139    */
140   function isContract(address addr) internal view returns (bool) {
141     uint256 size;
142     // XXX Currently there is no better way to check if there is a contract in an address
143     // than to check the size of the code at that address.
144     // See https://ethereum.stackexchange.com/a/14016/36603
145     // for more details about how this works.
146     // TODO Check this again before the Serenity release, because all addresses will be
147     // contracts then.
148     assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
149     return size > 0;
150   }
151 
152 }
153 
154 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
155 
156 /**
157  * @title Ownable
158  * @dev The Ownable contract has an owner address, and provides basic authorization control
159  * functions, this simplifies the implementation of "user permissions".
160  */
161 contract Ownable {
162   address public owner;
163 
164 
165   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
166 
167 
168   /**
169    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
170    * account.
171    */
172   function Ownable() public {
173     owner = msg.sender;
174   }
175 
176   /**
177    * @dev Throws if called by any account other than the owner.
178    */
179   modifier onlyOwner() {
180     require(msg.sender == owner);
181     _;
182   }
183 
184   /**
185    * @dev Allows the current owner to transfer control of the contract to a newOwner.
186    * @param newOwner The address to transfer ownership to.
187    */
188   function transferOwnership(address newOwner) public onlyOwner {
189     require(newOwner != address(0));
190     emit OwnershipTransferred(owner, newOwner);
191     owner = newOwner;
192   }
193 
194 }
195 
196 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
197 
198 /**
199  * @title Pausable
200  * @dev Base contract which allows children to implement an emergency stop mechanism.
201  */
202 contract Pausable is Ownable {
203   event Pause();
204   event Unpause();
205 
206   bool public paused = false;
207 
208 
209   /**
210    * @dev Modifier to make a function callable only when the contract is not paused.
211    */
212   modifier whenNotPaused() {
213     require(!paused);
214     _;
215   }
216 
217   /**
218    * @dev Modifier to make a function callable only when the contract is paused.
219    */
220   modifier whenPaused() {
221     require(paused);
222     _;
223   }
224 
225   /**
226    * @dev called by the owner to pause, triggers stopped state
227    */
228   function pause() onlyOwner whenNotPaused public {
229     paused = true;
230     emit Pause();
231   }
232 
233   /**
234    * @dev called by the owner to unpause, returns to normal state
235    */
236   function unpause() onlyOwner whenPaused public {
237     paused = false;
238     emit Unpause();
239   }
240 }
241 
242 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
243 
244 /**
245  * @title SafeMath
246  * @dev Math operations with safety checks that throw on error
247  */
248 library SafeMath {
249 
250   /**
251   * @dev Multiplies two numbers, throws on overflow.
252   */
253   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
254     if (a == 0) {
255       return 0;
256     }
257     c = a * b;
258     assert(c / a == b);
259     return c;
260   }
261 
262   /**
263   * @dev Integer division of two numbers, truncating the quotient.
264   */
265   function div(uint256 a, uint256 b) internal pure returns (uint256) {
266     // assert(b > 0); // Solidity automatically throws when dividing by 0
267     // uint256 c = a / b;
268     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
269     return a / b;
270   }
271 
272   /**
273   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
274   */
275   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
276     assert(b <= a);
277     return a - b;
278   }
279 
280   /**
281   * @dev Adds two numbers, throws on overflow.
282   */
283   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
284     c = a + b;
285     assert(c >= a);
286     return c;
287   }
288 }
289 
290 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
291 
292 /**
293  * @title ERC20Basic
294  * @dev Simpler version of ERC20 interface
295  * @dev see https://github.com/ethereum/EIPs/issues/179
296  */
297 contract ERC20Basic {
298   function totalSupply() public view returns (uint256);
299   function balanceOf(address who) public view returns (uint256);
300   function transfer(address to, uint256 value) public returns (bool);
301   event Transfer(address indexed from, address indexed to, uint256 value);
302 }
303 
304 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
305 
306 /**
307  * @title Basic token
308  * @dev Basic version of StandardToken, with no allowances.
309  */
310 contract BasicToken is ERC20Basic {
311   using SafeMath for uint256;
312 
313   mapping(address => uint256) balances;
314 
315   uint256 totalSupply_;
316 
317   /**
318   * @dev total number of tokens in existence
319   */
320   function totalSupply() public view returns (uint256) {
321     return totalSupply_;
322   }
323 
324   /**
325   * @dev transfer token for a specified address
326   * @param _to The address to transfer to.
327   * @param _value The amount to be transferred.
328   */
329   function transfer(address _to, uint256 _value) public returns (bool) {
330     require(_to != address(0));
331     require(_value <= balances[msg.sender]);
332 
333     balances[msg.sender] = balances[msg.sender].sub(_value);
334     balances[_to] = balances[_to].add(_value);
335     emit Transfer(msg.sender, _to, _value);
336     return true;
337   }
338 
339   /**
340   * @dev Gets the balance of the specified address.
341   * @param _owner The address to query the the balance of.
342   * @return An uint256 representing the amount owned by the passed address.
343   */
344   function balanceOf(address _owner) public view returns (uint256) {
345     return balances[_owner];
346   }
347 
348 }
349 
350 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
351 
352 /**
353  * @title ERC20 interface
354  * @dev see https://github.com/ethereum/EIPs/issues/20
355  */
356 contract ERC20 is ERC20Basic {
357   function allowance(address owner, address spender) public view returns (uint256);
358   function transferFrom(address from, address to, uint256 value) public returns (bool);
359   function approve(address spender, uint256 value) public returns (bool);
360   event Approval(address indexed owner, address indexed spender, uint256 value);
361 }
362 
363 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
364 
365 /**
366  * @title Standard ERC20 token
367  *
368  * @dev Implementation of the basic standard token.
369  * @dev https://github.com/ethereum/EIPs/issues/20
370  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
371  */
372 contract StandardToken is ERC20, BasicToken {
373 
374   mapping (address => mapping (address => uint256)) internal allowed;
375 
376 
377   /**
378    * @dev Transfer tokens from one address to another
379    * @param _from address The address which you want to send tokens from
380    * @param _to address The address which you want to transfer to
381    * @param _value uint256 the amount of tokens to be transferred
382    */
383   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
384     require(_to != address(0));
385     require(_value <= balances[_from]);
386     require(_value <= allowed[_from][msg.sender]);
387 
388     balances[_from] = balances[_from].sub(_value);
389     balances[_to] = balances[_to].add(_value);
390     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
391     emit Transfer(_from, _to, _value);
392     return true;
393   }
394 
395   /**
396    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
397    *
398    * Beware that changing an allowance with this method brings the risk that someone may use both the old
399    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
400    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
401    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
402    * @param _spender The address which will spend the funds.
403    * @param _value The amount of tokens to be spent.
404    */
405   function approve(address _spender, uint256 _value) public returns (bool) {
406     allowed[msg.sender][_spender] = _value;
407     emit Approval(msg.sender, _spender, _value);
408     return true;
409   }
410 
411   /**
412    * @dev Function to check the amount of tokens that an owner allowed to a spender.
413    * @param _owner address The address which owns the funds.
414    * @param _spender address The address which will spend the funds.
415    * @return A uint256 specifying the amount of tokens still available for the spender.
416    */
417   function allowance(address _owner, address _spender) public view returns (uint256) {
418     return allowed[_owner][_spender];
419   }
420 
421   /**
422    * @dev Increase the amount of tokens that an owner allowed to a spender.
423    *
424    * approve should be called when allowed[_spender] == 0. To increment
425    * allowed value is better to use this function to avoid 2 calls (and wait until
426    * the first transaction is mined)
427    * From MonolithDAO Token.sol
428    * @param _spender The address which will spend the funds.
429    * @param _addedValue The amount of tokens to increase the allowance by.
430    */
431   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
432     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
433     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
434     return true;
435   }
436 
437   /**
438    * @dev Decrease the amount of tokens that an owner allowed to a spender.
439    *
440    * approve should be called when allowed[_spender] == 0. To decrement
441    * allowed value is better to use this function to avoid 2 calls (and wait until
442    * the first transaction is mined)
443    * From MonolithDAO Token.sol
444    * @param _spender The address which will spend the funds.
445    * @param _subtractedValue The amount of tokens to decrease the allowance by.
446    */
447   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
448     uint oldValue = allowed[msg.sender][_spender];
449     if (_subtractedValue > oldValue) {
450       allowed[msg.sender][_spender] = 0;
451     } else {
452       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
453     }
454     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
455     return true;
456   }
457 
458 }
459 
460 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
461 
462 /**
463  * @title Mintable token
464  * @dev Simple ERC20 Token example, with mintable token creation
465  * @dev Issue: * https://github.com/OpenZeppelin/openzeppelin-solidity/issues/120
466  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
467  */
468 contract MintableToken is StandardToken, Ownable {
469   event Mint(address indexed to, uint256 amount);
470   event MintFinished();
471 
472   bool public mintingFinished = false;
473 
474 
475   modifier canMint() {
476     require(!mintingFinished);
477     _;
478   }
479 
480   /**
481    * @dev Function to mint tokens
482    * @param _to The address that will receive the minted tokens.
483    * @param _amount The amount of tokens to mint.
484    * @return A boolean that indicates if the operation was successful.
485    */
486   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
487     totalSupply_ = totalSupply_.add(_amount);
488     balances[_to] = balances[_to].add(_amount);
489     emit Mint(_to, _amount);
490     emit Transfer(address(0), _to, _amount);
491     return true;
492   }
493 
494   /**
495    * @dev Function to stop minting new tokens.
496    * @return True if the operation was successful.
497    */
498   function finishMinting() onlyOwner canMint public returns (bool) {
499     mintingFinished = true;
500     emit MintFinished();
501     return true;
502   }
503 }
504 
505 // File: contracts/Presale.sol
506 
507 /**
508  * @title Presale
509  * @dev A simple Presale Contract (PsC) for deposit collection during pre-sale events.
510  */
511 contract Presale is Whitelistable, Pausable {
512     using AddressUtils for address;
513     using SafeMath for uint256;
514 
515     event LogCreated(
516         address caller,
517         uint256 indexed startBlock,
518         uint256 indexed endBlock,
519         uint256 minDeposit,
520         address wallet,
521         address indexed providerWallet,
522         uint256 maxWhitelistLength,
523         uint256 whitelistThreshold
524     );
525     event LogMinDepositChanged(address indexed caller, uint256 indexed minDeposit);
526     event LogInvestmentReceived(
527         address indexed caller,
528         address indexed beneficiary,
529         uint256 indexed amount,
530         uint256 netAmount
531     );
532     event LogPresaleTokenChanged(
533         address indexed caller,
534         address indexed presaleToken,
535         uint256 indexed rate
536     );
537 
538     // The start and end block where investments are allowed (both inclusive)
539     uint256 public startBlock;
540     uint256 public endBlock;
541 
542     // Address where funds are collected
543     address public wallet;
544 
545     // Presale minimum deposit in wei
546     uint256 public minDeposit;
547 
548     // Presale balances (expressed in wei) deposited by each subscriber
549     mapping (address => uint256) public balanceOf;
550     
551     // Amount of raised money in wei
552     uint256 public raisedFunds;
553 
554     // Amount of service provider fees in wei
555     uint256 public providerFees;
556 
557     // Address where service provider fees are collected
558     address public providerWallet;
559 
560     // Two fee thresholds separating the raised money into three partitions
561     uint256 public feeThreshold1;
562     uint256 public feeThreshold2;
563 
564     // Three percentage levels for fee calculation in each partition
565     uint256 public lowFeePercentage;
566     uint256 public mediumFeePercentage;
567     uint256 public highFeePercentage;
568 
569     // Optional ERC20 presale token (0 means no presale token)
570     MintableToken public presaleToken;
571 
572     // How many ERC20 presale token units a buyer gets per wei (0 means no presale token)
573     uint256 public rate;
574 
575     constructor(
576         uint256 _startBlock,
577         uint256 _endBlock,
578         uint256 _minDeposit,
579         address _wallet,
580         address _providerWallet,
581         uint256 _maxWhitelistLength,
582         uint256 _whitelistThreshold,
583         uint256 _feeThreshold1,
584         uint256 _feeThreshold2,
585         uint256 _lowFeePercentage,
586         uint256 _mediumFeePercentage,
587         uint256 _highFeePercentage
588     )
589     Whitelistable(_maxWhitelistLength, _whitelistThreshold)
590     public
591     {
592         require(_startBlock >= block.number, "_startBlock is lower than current block number");
593         require(_endBlock >= _startBlock, "_endBlock is lower than _startBlock");
594         require(_minDeposit > 0, "_minDeposit is zero");
595         require(_wallet != address(0) && !_wallet.isContract(), "_wallet is zero or contract");
596         require(!_providerWallet.isContract(), "_providerWallet is contract");
597         require(_feeThreshold2 >= _feeThreshold1, "_feeThreshold2 is lower than _feeThreshold1");
598         require(0 <= _lowFeePercentage && _lowFeePercentage <= 100, "_lowFeePercentage not in range [0, 100]");
599         require(0 <= _mediumFeePercentage && _mediumFeePercentage <= 100, "_mediumFeePercentage not in range [0, 100]");
600         require(0 <= _highFeePercentage && _highFeePercentage <= 100, "_highFeePercentage not in range [0, 100]");
601 
602         startBlock = _startBlock;
603         endBlock = _endBlock;
604         minDeposit = _minDeposit;
605         wallet = _wallet;
606         providerWallet = _providerWallet;
607         feeThreshold1 = _feeThreshold1;
608         feeThreshold2 = _feeThreshold2;
609         lowFeePercentage = _lowFeePercentage;
610         mediumFeePercentage = _mediumFeePercentage;
611         highFeePercentage = _highFeePercentage;
612 
613         emit LogCreated(
614             msg.sender,
615             _startBlock,
616             _endBlock,
617             _minDeposit,
618             _wallet,
619             _providerWallet,
620             _maxWhitelistLength,
621             _whitelistThreshold
622         );
623     }
624 
625     function hasStarted() public view returns (bool ended) {
626         return block.number >= startBlock;
627     }
628 
629     // @return true if presale event has ended
630     function hasEnded() public view returns (bool ended) {
631         return block.number > endBlock;
632     }
633 
634     // @return The current fee percentage based on raised funds
635     function currentFeePercentage() public view returns (uint256 feePercentage) {
636         return raisedFunds < feeThreshold1 ? lowFeePercentage :
637             raisedFunds < feeThreshold2 ? mediumFeePercentage : highFeePercentage;
638     }
639 
640     /**
641      * Change the minimum deposit for each subscriber. New value shall be lower than previous.
642      * @param _minDeposit The minimum deposit for each subscriber, expressed in wei
643      */
644     function setMinDeposit(uint256 _minDeposit) external onlyOwner {
645         require(0 < _minDeposit && _minDeposit < minDeposit, "_minDeposit not in range [0, minDeposit]");
646         require(!hasEnded(), "presale has ended");
647 
648         minDeposit = _minDeposit;
649 
650         emit LogMinDepositChanged(msg.sender, _minDeposit);
651     }
652 
653     /**
654      * Change the maximum whitelist length. New value shall satisfy the #isAllowedWhitelist conditions.
655      * @param _maxWhitelistLength The maximum whitelist length
656      */
657     function setMaxWhitelistLength(uint256 _maxWhitelistLength) external onlyOwner {
658         require(!hasEnded(), "presale has ended");
659         setMaxWhitelistLengthInternal(_maxWhitelistLength);
660     }
661 
662     /**
663      * Change the whitelist threshold balance. New value shall satisfy the #isAllowedWhitelist conditions.
664      * @param _whitelistThreshold The threshold balance (in wei) above which whitelisting is required to invest
665      */
666     function setWhitelistThresholdBalance(uint256 _whitelistThreshold) external onlyOwner {
667         require(!hasEnded(), "presale has ended");
668         setWhitelistThresholdBalanceInternal(_whitelistThreshold);
669     }
670 
671     /**
672      * Add the subscriber to the whitelist.
673      * @param _subscriber The subscriber to add to the whitelist.
674      */
675     function addToWhitelist(address _subscriber) external onlyOwner {
676         require(!hasEnded(), "presale has ended");
677         addToWhitelistInternal(_subscriber);
678     }
679 
680     /**
681      * Removed the subscriber from the whitelist.
682      * @param _subscriber The subscriber to remove from the whitelist.
683      */
684     function removeFromWhitelist(address _subscriber) external onlyOwner {
685         require(!hasEnded(), "presale has ended");
686         removeFromWhitelistInternal(_subscriber, balanceOf[_subscriber]);
687     }
688 
689     /**
690      * Set the ERC20 presale token address and conversion rate.
691      * @param _presaleToken The ERC20 presale token.
692      * @param _rate How many ERC20 presale token units a buyer gets per wei.
693      */
694     function setPresaleToken(MintableToken _presaleToken, uint256 _rate) external onlyOwner {
695         require(_presaleToken != presaleToken || _rate != rate, "both _presaleToken and _rate equal to current ones");
696         require(!hasEnded(), "presale has ended");
697 
698         presaleToken = _presaleToken;
699         rate = _rate;
700 
701         emit LogPresaleTokenChanged(msg.sender, _presaleToken, _rate);
702     }
703 
704     function isAllowedBalance(address _beneficiary, uint256 _balance) public view returns (bool isReallyAllowed) {
705         bool hasMinimumBalance = _balance >= minDeposit;
706         return hasMinimumBalance && super.isAllowedBalance(_beneficiary, _balance);
707     }
708 
709     function isValidInvestment(address _beneficiary, uint256 _amount) public view returns (bool isValid) {
710         bool withinPeriod = startBlock <= block.number && block.number <= endBlock;
711         bool nonZeroPurchase = _amount != 0;
712         bool isAllowedAmount = isAllowedBalance(_beneficiary, balanceOf[_beneficiary].add(_amount));
713 
714         return withinPeriod && nonZeroPurchase && isAllowedAmount;
715     }
716 
717     function invest(address _beneficiary) public payable whenNotPaused {
718         require(_beneficiary != address(0), "_beneficiary is zero");
719         require(_beneficiary != wallet, "_beneficiary is equal to wallet");
720         require(_beneficiary != providerWallet, "_beneficiary is equal to providerWallet");
721         require(isValidInvestment(_beneficiary, msg.value), "forbidden investment for _beneficiary");
722 
723         balanceOf[_beneficiary] = balanceOf[_beneficiary].add(msg.value);
724         raisedFunds = raisedFunds.add(msg.value);
725 
726         // Optionally distribute presale token to buyer, if configured
727         if (presaleToken != address(0) && rate != 0) {
728             uint256 tokenAmount = msg.value.mul(rate);
729             presaleToken.mint(_beneficiary, tokenAmount);
730         }
731 
732         if (providerWallet == 0) {
733             wallet.transfer(msg.value);
734 
735             emit LogInvestmentReceived(msg.sender, _beneficiary, msg.value, msg.value);
736         }
737         else {
738             uint256 feePercentage = currentFeePercentage();
739             uint256 fees = msg.value.mul(feePercentage).div(100);
740             uint256 netAmount = msg.value.sub(fees);
741 
742             providerFees = providerFees.add(fees);
743 
744             providerWallet.transfer(fees);
745             wallet.transfer(netAmount);
746 
747             emit LogInvestmentReceived(msg.sender, _beneficiary, msg.value, netAmount);
748         }
749     }
750 
751     function () external payable whenNotPaused {
752         invest(msg.sender);
753     }
754 }
755 
756 // File: contracts/CappedPresale.sol
757 
758 /**
759  * @title CappedPresale
760  * @dev Extension of Presale with a max amount of funds raised
761  */
762 contract CappedPresale is Presale {
763     using SafeMath for uint256;
764 
765     event LogMaxCapChanged(address indexed caller, uint256 indexed maxCap);
766 
767     // Maximum cap in wei
768     uint256 public maxCap;
769 
770     constructor(
771         uint256 _startBlock,
772         uint256 _endBlock,
773         uint256 _minDeposit,
774         address _wallet,
775         address _providerWallet,
776         uint256 _maxWhitelistLength,
777         uint256 _whitelistThreshold,
778         uint256 _feeThreshold1,
779         uint256 _feeThreshold2,
780         uint256 _lowFeePercentage,
781         uint256 _mediumFeePercentage,
782         uint256 _highFeePercentage,
783         uint256 _maxCap
784     )
785     Presale(
786         _startBlock,
787         _endBlock,
788         _minDeposit,
789         _wallet,
790         _providerWallet,
791         _maxWhitelistLength,
792         _whitelistThreshold,
793         _feeThreshold1,
794         _feeThreshold2,
795         _lowFeePercentage,
796         _mediumFeePercentage,
797         _highFeePercentage
798     )
799     public
800     {
801         require(_maxCap > 0, "_maxCap is zero");
802         require(_maxCap >= _feeThreshold2, "_maxCap is lower than _feeThreshold2");
803         
804         maxCap = _maxCap;
805     }
806 
807     /**
808      * Change the maximum cap of the presale. New value shall be greater than previous one.
809      * @param _maxCap The maximum cap of the presale, expressed in wei
810      */
811     function setMaxCap(uint256 _maxCap) external onlyOwner {
812         require(_maxCap > maxCap, "_maxCap is not greater than current maxCap");
813         require(!hasEnded(), "presale has ended");
814         
815         maxCap = _maxCap;
816 
817         emit LogMaxCapChanged(msg.sender, _maxCap);
818     }
819 
820     // overriding Presale#hasEnded to add cap logic
821     // @return true if presale event has ended
822     function hasEnded() public view returns (bool ended) {
823         bool capReached = raisedFunds >= maxCap;
824         
825         return super.hasEnded() || capReached;
826     }
827 
828     // overriding Presale#isValidInvestment to add extra cap logic
829     // @return true if beneficiary can buy at the moment
830     function isValidInvestment(address _beneficiary, uint256 _amount) public view returns (bool isValid) {
831         bool withinCap = raisedFunds.add(_amount) <= maxCap;
832 
833         return super.isValidInvestment(_beneficiary, _amount) && withinCap;
834     }
835 }
836 
837 // File: contracts/NokuCustomPresale.sol
838 
839 /**
840  * @title NokuCustomPresale
841  * @dev Extension of CappedPresale.
842  */
843 contract NokuCustomPresale is CappedPresale {
844     event LogNokuCustomPresaleCreated(
845         address caller,
846         uint256 indexed startBlock,
847         uint256 indexed endBlock,
848         uint256 minDeposit,
849         address wallet,
850         address indexed providerWallet,
851         uint256 maxWhitelistLength,
852         uint256 whitelistThreshold
853     );
854 
855     constructor(
856         uint256 _startBlock,
857         uint256 _endBlock,
858         uint256 _minDeposit,
859         address _wallet,
860         address _providerWallet,
861         uint256 _maxWhitelistLength,
862         uint256 _whitelistThreshold,
863         uint256 _feeThreshold1,
864         uint256 _feeThreshold2,
865         uint256 _lowFeePercentage,
866         uint256 _mediumFeePercentage,
867         uint256 _highFeePercentage,
868         uint256 _maxCap
869     )
870     CappedPresale(
871         _startBlock,
872         _endBlock,
873         _minDeposit,
874         _wallet,
875         _providerWallet,
876         _maxWhitelistLength,
877         _whitelistThreshold,
878         _feeThreshold1,
879         _feeThreshold2,
880         _lowFeePercentage,
881         _mediumFeePercentage,
882         _highFeePercentage,
883         _maxCap
884     )
885     public {
886         emit LogNokuCustomPresaleCreated(
887             msg.sender,
888             _startBlock,
889             _endBlock,
890             _minDeposit,
891             _wallet,
892             _providerWallet,
893             _maxWhitelistLength,
894             _whitelistThreshold
895         );
896     }
897 }
898 
899 // File: contracts/NokuPricingPlan.sol
900 
901 /**
902 * @dev The NokuPricingPlan contract defines the responsibilities of a Noku pricing plan.
903 */
904 contract NokuPricingPlan {
905     /**
906     * @dev Pay the fee for the service identified by the specified name.
907     * The fee amount shall already be approved by the client.
908     * @param serviceName The name of the target service.
909     * @param multiplier The multiplier of the base service fee to apply.
910     * @param client The client of the target service.
911     * @return true if fee has been paid.
912     */
913     function payFee(bytes32 serviceName, uint256 multiplier, address client) public returns(bool paid);
914 
915     /**
916     * @dev Get the usage fee for the service identified by the specified name.
917     * The returned fee amount shall be approved before using #payFee method.
918     * @param serviceName The name of the target service.
919     * @param multiplier The multiplier of the base service fee to apply.
920     * @return The amount to approve before really paying such fee.
921     */
922     function usageFee(bytes32 serviceName, uint256 multiplier) public constant returns(uint fee);
923 }
924 
925 // File: contracts/NokuCustomService.sol
926 
927 contract NokuCustomService is Pausable {
928     using AddressUtils for address;
929 
930     event LogPricingPlanChanged(address indexed caller, address indexed pricingPlan);
931 
932     // The pricing plan determining the fee to be paid in NOKU tokens by customers
933     NokuPricingPlan public pricingPlan;
934 
935     constructor(address _pricingPlan) internal {
936         require(_pricingPlan.isContract(), "_pricingPlan is not contract");
937 
938         pricingPlan = NokuPricingPlan(_pricingPlan);
939     }
940 
941     function setPricingPlan(address _pricingPlan) public onlyOwner {
942         require(_pricingPlan.isContract(), "_pricingPlan is not contract");
943         require(NokuPricingPlan(_pricingPlan) != pricingPlan, "_pricingPlan equal to current");
944         
945         pricingPlan = NokuPricingPlan(_pricingPlan);
946 
947         emit LogPricingPlanChanged(msg.sender, _pricingPlan);
948     }
949 }
950 
951 // File: contracts/NokuCustomPresaleService.sol
952 
953 /**
954  * @title NokuCustomPresaleService
955  * @dev Extension of NokuCustomService adding the fee payment in NOKU tokens.
956  */
957 contract NokuCustomPresaleService is NokuCustomService {
958     event LogNokuCustomPresaleServiceCreated(address indexed caller);
959 
960     bytes32 public constant SERVICE_NAME = "NokuCustomERC20.presale";
961     uint256 public constant CREATE_AMOUNT = 1 * 10**18;
962 
963     constructor(address _pricingPlan) NokuCustomService(_pricingPlan) public {
964         emit LogNokuCustomPresaleServiceCreated(msg.sender);
965     }
966 
967     function createCustomPresale(
968         uint256 _startBlock,
969         uint256 _endBlock,
970         uint256 _minDeposit,
971         address _wallet,
972         address _providerWallet,
973         uint256 _maxWhitelistLength,
974         uint256 _whitelistThreshold,
975         uint256 _feeThreshold1,
976         uint256 _feeThreshold2,
977         uint256 _lowFeePercentage,
978         uint256 _mediumFeePercentage,
979         uint256 _highFeePercentage,
980         uint256 _maxCap
981     )
982     public returns(NokuCustomPresale customPresale)
983     {
984         customPresale = new NokuCustomPresale(
985             _startBlock,
986             _endBlock,
987             _minDeposit,
988             _wallet,
989             _providerWallet,
990             _maxWhitelistLength,
991             _whitelistThreshold,
992             _feeThreshold1,
993             _feeThreshold2,
994             _lowFeePercentage,
995             _mediumFeePercentage,
996             _highFeePercentage,
997             _maxCap
998         );
999 
1000         // Transfer NokuCustomPresale ownership to the client
1001         customPresale.transferOwnership(msg.sender);
1002 
1003         require(pricingPlan.payFee(SERVICE_NAME, CREATE_AMOUNT, msg.sender), "fee payment failed");
1004     }
1005 }