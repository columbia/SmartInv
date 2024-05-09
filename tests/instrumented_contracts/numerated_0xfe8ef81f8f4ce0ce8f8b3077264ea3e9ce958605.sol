1 pragma solidity ^0.4.18;
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
14   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
15     if (a == 0) {
16       return 0;
17     }
18     uint256 c = a * b;
19     assert(c / a == b);
20     return c;
21   }
22 
23   /**
24   * @dev Integer division of two numbers, truncating the quotient.
25   */
26   function div(uint256 a, uint256 b) internal pure returns (uint256) {
27     // assert(b > 0); // Solidity automatically throws when dividing by 0
28     uint256 c = a / b;
29     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
30     return c;
31   }
32 
33   /**
34   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
35   */
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   /**
42   * @dev Adds two numbers, throws on overflow.
43   */
44   function add(uint256 a, uint256 b) internal pure returns (uint256) {
45     uint256 c = a + b;
46     assert(c >= a);
47     return c;
48   }
49 }
50 
51 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
52 
53 /**
54  * @title ERC20Basic
55  * @dev Simpler version of ERC20 interface
56  * @dev see https://github.com/ethereum/EIPs/issues/179
57  */
58 contract ERC20Basic {
59   function totalSupply() public view returns (uint256);
60   function balanceOf(address who) public view returns (uint256);
61   function transfer(address to, uint256 value) public returns (bool);
62   event Transfer(address indexed from, address indexed to, uint256 value);
63 }
64 
65 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
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
112 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
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
125 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
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
222 // File: zeppelin-solidity/contracts/examples/SimpleToken.sol
223 
224 /**
225  * @title SimpleToken
226  * @dev Very simple ERC20 Token example, where all tokens are pre-assigned to the creator.
227  * Note they can later distribute these tokens as they wish using `transfer` and other
228  * `StandardToken` functions.
229  */
230 contract SimpleToken is StandardToken {
231 
232   string public constant name = "SimpleToken"; // solium-disable-line uppercase
233   string public constant symbol = "SIM"; // solium-disable-line uppercase
234   uint8 public constant decimals = 18; // solium-disable-line uppercase
235 
236   uint256 public constant INITIAL_SUPPLY = 10000 * (10 ** uint256(decimals));
237 
238   /**
239    * @dev Constructor that gives msg.sender all of existing tokens.
240    */
241   function SimpleToken() public {
242     totalSupply_ = INITIAL_SUPPLY;
243     balances[msg.sender] = INITIAL_SUPPLY;
244     Transfer(0x0, msg.sender, INITIAL_SUPPLY);
245   }
246 
247 }
248 
249 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
250 
251 /**
252  * @title Ownable
253  * @dev The Ownable contract has an owner address, and provides basic authorization control
254  * functions, this simplifies the implementation of "user permissions".
255  */
256 contract Ownable {
257   address public owner;
258 
259 
260   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
261 
262 
263   /**
264    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
265    * account.
266    */
267   function Ownable() public {
268     owner = msg.sender;
269   }
270 
271   /**
272    * @dev Throws if called by any account other than the owner.
273    */
274   modifier onlyOwner() {
275     require(msg.sender == owner);
276     _;
277   }
278 
279   /**
280    * @dev Allows the current owner to transfer control of the contract to a newOwner.
281    * @param newOwner The address to transfer ownership to.
282    */
283   function transferOwnership(address newOwner) public onlyOwner {
284     require(newOwner != address(0));
285     OwnershipTransferred(owner, newOwner);
286     owner = newOwner;
287   }
288 
289 }
290 
291 // File: contracts/LockedOutTokens.sol
292 
293 // for unit test purposes only
294 
295 
296 
297 contract LockedOutTokens is Ownable {
298 
299     address public wallet;
300     uint8 public tranchesCount;
301     uint256 public trancheSize;
302     uint256 public period;
303 
304     uint256 public startTimestamp;
305     uint8 public tranchesPayedOut = 0;
306 
307     ERC20Basic internal token;
308     
309     function LockedOutTokens(
310         address _wallet,
311         address _tokenAddress,
312         uint256 _startTimestamp,
313         uint8 _tranchesCount,
314         uint256 _trancheSize,
315         uint256 _periodSeconds
316     ) {
317         require(_wallet != address(0));
318         require(_tokenAddress != address(0));
319         require(_startTimestamp > 0);
320         require(_tranchesCount > 0);
321         require(_trancheSize > 0);
322         require(_periodSeconds > 0);
323 
324         wallet = _wallet;
325         tranchesCount = _tranchesCount;
326         startTimestamp = _startTimestamp;
327         trancheSize = _trancheSize;
328         period = _periodSeconds;
329 
330         token = ERC20Basic(_tokenAddress);
331     }
332 
333     function grant()
334         public
335     {
336         require(wallet == msg.sender);
337         require(tranchesPayedOut < tranchesCount);
338         require(startTimestamp > 0);
339         require(now >= startTimestamp + (period * (tranchesPayedOut + 1)));
340 
341         tranchesPayedOut = tranchesPayedOut + 1;
342         token.transfer(wallet, trancheSize);
343     }
344 }
345 
346 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
347 
348 /**
349  * @title Pausable
350  * @dev Base contract which allows children to implement an emergency stop mechanism.
351  */
352 contract Pausable is Ownable {
353   event Pause();
354   event Unpause();
355 
356   bool public paused = false;
357 
358 
359   /**
360    * @dev Modifier to make a function callable only when the contract is not paused.
361    */
362   modifier whenNotPaused() {
363     require(!paused);
364     _;
365   }
366 
367   /**
368    * @dev Modifier to make a function callable only when the contract is paused.
369    */
370   modifier whenPaused() {
371     require(paused);
372     _;
373   }
374 
375   /**
376    * @dev called by the owner to pause, triggers stopped state
377    */
378   function pause() onlyOwner whenNotPaused public {
379     paused = true;
380     Pause();
381   }
382 
383   /**
384    * @dev called by the owner to unpause, returns to normal state
385    */
386   function unpause() onlyOwner whenPaused public {
387     paused = false;
388     Unpause();
389   }
390 }
391 
392 // File: contracts/TiqpitToken.sol
393 
394 contract TiqpitToken is StandardToken, Pausable {
395     using SafeMath for uint256;
396 
397     string constant public name = "Tiqpit Token";
398     string constant public symbol = "PIT";
399     uint8 constant public decimals = 18;
400 
401     string constant public smallestUnitName = "TIQ";
402 
403     uint256 constant public INITIAL_TOTAL_SUPPLY = 500e6 * (uint256(10) ** decimals);
404 
405     address private addressIco;
406 
407     modifier onlyIco() {
408         require(msg.sender == addressIco);
409         _;
410     }
411     
412     /**
413     * @dev Create TiqpitToken contract and set pause
414     * @param _ico The address of ICO contract.
415     */
416     function TiqpitToken (address _ico) public {
417         require(_ico != address(0));
418 
419         addressIco = _ico;
420 
421         totalSupply_ = totalSupply_.add(INITIAL_TOTAL_SUPPLY);
422         balances[_ico] = balances[_ico].add(INITIAL_TOTAL_SUPPLY);
423         Transfer(address(0), _ico, INITIAL_TOTAL_SUPPLY);
424 
425         pause();
426     }
427 
428      /**
429     * @dev Transfer token for a specified address with pause feature for owner.
430     * @dev Only applies when the transfer is allowed by the owner.
431     * @param _to The address to transfer to.
432     * @param _value The amount to be transferred.
433     */
434     function transfer(address _to, uint256 _value) whenNotPaused public returns (bool) {
435         super.transfer(_to, _value);
436     }
437 
438     /**
439     * @dev Transfer tokens from one address to another with pause feature for owner.
440     * @dev Only applies when the transfer is allowed by the owner.
441     * @param _from address The address which you want to send tokens from
442     * @param _to address The address which you want to transfer to
443     * @param _value uint256 the amount of tokens to be transferred
444     */
445     function transferFrom(address _from, address _to, uint256 _value) whenNotPaused public returns (bool) {
446         super.transferFrom(_from, _to, _value);
447     }
448 
449     /**
450     * @dev Transfer tokens from ICO address to another address.
451     * @param _to The address to transfer to.
452     * @param _value The amount to be transferred.
453     */
454     function transferFromIco(address _to, uint256 _value) onlyIco public returns (bool) {
455         super.transfer(_to, _value);
456     }
457 
458     /**
459     * @dev Burn a specific amount of tokens of other token holders if refund process enable.
460     * @param _from The address of token holder whose tokens to be burned.
461     */
462     function burnFromAddress(address _from) onlyIco public {
463         uint256 amount = balances[_from];
464 
465         require(_from != address(0));
466         require(amount > 0);
467         require(amount <= balances[_from]);
468 
469         balances[_from] = balances[_from].sub(amount);
470         totalSupply_ = totalSupply_.sub(amount);
471         Transfer(_from, address(0), amount);
472     }
473 }
474 
475 // File: contracts/Whitelist.sol
476 
477 /**
478  * @title Whitelist contract
479  * @dev Whitelist for wallets.
480 */
481 contract Whitelist is Ownable {
482     mapping(address => bool) whitelist;
483 
484     uint256 public whitelistLength = 0;
485 
486     address public backendAddress;
487 
488     /**
489     * @dev Add wallet to whitelist.
490     * @dev Accept request from the owner only.
491     * @param _wallet The address of wallet to add.
492     */  
493     function addWallet(address _wallet) public onlyPrivilegedAddresses {
494         require(_wallet != address(0));
495         require(!isWhitelisted(_wallet));
496         whitelist[_wallet] = true;
497         whitelistLength++;
498     }
499 
500     /**
501     * @dev Remove wallet from whitelist.
502     * @dev Accept request from the owner only.
503     * @param _wallet The address of whitelisted wallet to remove.
504     */  
505     function removeWallet(address _wallet) public onlyOwner {
506         require(_wallet != address(0));
507         require(isWhitelisted(_wallet));
508         whitelist[_wallet] = false;
509         whitelistLength--;
510     }
511 
512     /**
513     * @dev Check the specified wallet whether it is in the whitelist.
514     * @param _wallet The address of wallet to check.
515     */ 
516     function isWhitelisted(address _wallet) constant public returns (bool) {
517         return whitelist[_wallet];
518     }
519 
520     /**
521     * @dev Sets the backend address for automated operations.
522     * @param _backendAddress The backend address to allow.
523     */
524     function setBackendAddress(address _backendAddress) public onlyOwner {
525         require(_backendAddress != address(0));
526         backendAddress = _backendAddress;
527     }
528 
529     /**
530     * @dev Allows the function to be called only by the owner and backend.
531     */
532     modifier onlyPrivilegedAddresses() {
533         require(msg.sender == owner || msg.sender == backendAddress);
534         _;
535     }
536 }
537 
538 // File: contracts/Whitelistable.sol
539 
540 contract Whitelistable {
541     Whitelist public whitelist;
542 
543     modifier whenWhitelisted(address _wallet) {
544         require(whitelist.isWhitelisted(_wallet));
545         _;
546     }
547 
548     /**
549     * @dev Constructor for Whitelistable contract.
550     */
551     function Whitelistable() public {
552         whitelist = new Whitelist();
553     }
554 }
555 
556 // File: contracts/TiqpitCrowdsale.sol
557 
558 contract TiqpitCrowdsale is Pausable, Whitelistable {
559     using SafeMath for uint256;
560 
561     uint256 constant private DECIMALS = 18;
562     
563     uint256 constant public RESERVED_TOKENS_BOUNTY = 10e6 * (10 ** DECIMALS);
564     uint256 constant public RESERVED_TOKENS_FOUNDERS = 25e6 * (10 ** DECIMALS);
565     uint256 constant public RESERVED_TOKENS_ADVISORS = 25e5 * (10 ** DECIMALS);
566     uint256 constant public RESERVED_TOKENS_TIQPIT_SOLUTIONS = 625e5 * (10 ** DECIMALS);
567 
568     uint256 constant public MIN_INVESTMENT = 200 * (10 ** DECIMALS);
569     
570     uint256 constant public MINCAP_TOKENS_PRE_ICO = 1e6 * (10 ** DECIMALS);
571     uint256 constant public MAXCAP_TOKENS_PRE_ICO = 75e5 * (10 ** DECIMALS);
572     
573     uint256 constant public MINCAP_TOKENS_ICO = 5e6 * (10 ** DECIMALS);    
574     uint256 constant public MAXCAP_TOKENS_ICO = 3925e5 * (10 ** DECIMALS);
575 
576     uint256 public tokensRemainingIco = MAXCAP_TOKENS_ICO;
577     uint256 public tokensRemainingPreIco = MAXCAP_TOKENS_PRE_ICO;
578 
579     uint256 public soldTokensPreIco = 0;
580     uint256 public soldTokensIco = 0;
581     uint256 public soldTokensTotal = 0;
582 
583     uint256 public preIcoRate = 2857;        // 1 PIT = 0.00035 ETH //Base rate for  Pre-ICO stage.
584 
585     // ICO rates
586     uint256 public firstRate = 2500;         // 1 PIT = 0.0004 ETH
587     uint256 public secondRate = 2222;        // 1 PIT = 0.00045 ETH
588     uint256 public thirdRate = 2000;         // 1 PIT = 0.0005 ETH
589 
590     uint256 public startTimePreIco = 0;
591     uint256 public endTimePreIco = 0;
592 
593     uint256 public startTimeIco = 0;
594     uint256 public endTimeIco = 0;
595 
596     uint256 public weiRaisedPreIco = 0;
597     uint256 public weiRaisedIco = 0;
598     uint256 public weiRaisedTotal = 0;
599 
600     TiqpitToken public token = new TiqpitToken(this);
601 
602     // Key - address of wallet, Value - address of  contract.
603     mapping (address => address) private lockedList;
604 
605     address private tiqpitSolutionsWallet;
606     address private foundersWallet;
607     address private advisorsWallet;
608     address private bountyWallet;
609 
610     address public backendAddress;
611 
612     bool private hasPreIcoFailed = false;
613     bool private hasIcoFailed = false;
614 
615     bool private isInitialDistributionDone = false;
616 
617     struct Purchase {
618         uint256 refundableWei;
619         uint256 burnableTiqs;
620     }
621 
622     mapping(address => Purchase) private preIcoPurchases;
623     mapping(address => Purchase) private icoPurchases;
624 
625     /**
626     * @dev Constructor for TiqpitCrowdsale contract.
627     * @dev Set the owner who can manage whitelist and token.
628     * @param _startTimePreIco The pre-ICO start time.
629     * @param _endTimePreIco The pre-ICO end time.
630     * @param _foundersWallet The address to which reserved tokens for founders will be transferred.
631     * @param _advisorsWallet The address to which reserved tokens for advisors.
632     * @param _tiqpitSolutionsWallet The address to which reserved tokens for Tiqpit Solutions.
633     */
634     function TiqpitCrowdsale(
635         uint256 _startTimePreIco,
636         uint256 _endTimePreIco,
637         uint256 _startTimeIco,
638         uint256 _endTimeIco,
639         address _foundersWallet,
640         address _advisorsWallet,
641         address _tiqpitSolutionsWallet,
642         address _bountyWallet
643     ) Whitelistable() public
644     {
645         require(_bountyWallet != address(0) && _foundersWallet != address(0) && _tiqpitSolutionsWallet != address(0) && _advisorsWallet != address(0));
646         
647         require(_startTimePreIco >= now && _endTimePreIco > _startTimePreIco);
648         require(_startTimeIco >= _endTimePreIco && _endTimeIco > _startTimeIco);
649 
650         startTimePreIco = _startTimePreIco;
651         endTimePreIco = _endTimePreIco;
652 
653         startTimeIco = _startTimeIco;
654         endTimeIco = _endTimeIco;
655 
656         tiqpitSolutionsWallet = _tiqpitSolutionsWallet;
657         advisorsWallet = _advisorsWallet;
658         foundersWallet = _foundersWallet;
659         bountyWallet = _bountyWallet;
660 
661         whitelist.transferOwnership(msg.sender);
662         token.transferOwnership(msg.sender);
663     }
664 
665     /**
666     * @dev Fallback function can be used to buy tokens.
667     */
668     function() public payable {
669         sellTokens();
670     }
671 
672     /**
673     * @dev Check whether the pre-ICO is active at the moment.
674     */
675     function isPreIco() public view returns (bool) {
676         return now >= startTimePreIco && now <= endTimePreIco;
677     }
678 
679     /**
680     * @dev Check whether the ICO is active at the moment.
681     */
682     function isIco() public view returns (bool) {
683         return now >= startTimeIco && now <= endTimeIco;
684     }
685 
686     /**
687     * @dev Burn Remaining Tokens.
688     */
689     function burnRemainingTokens() onlyOwner public {
690         require(tokensRemainingIco > 0);
691         require(now > endTimeIco);
692 
693         token.burnFromAddress(this);
694 
695         tokensRemainingIco = 0;
696     }
697 
698     /**
699     * @dev Send tokens to Advisors & Tiqpit Solutions Wallets.
700     * @dev Locked  tokens for Founders wallet.
701     */
702     function initialDistribution() onlyOwner public {
703         require(!isInitialDistributionDone);
704 
705         token.transferFromIco(bountyWallet, RESERVED_TOKENS_BOUNTY);
706 
707         token.transferFromIco(advisorsWallet, RESERVED_TOKENS_ADVISORS);
708         token.transferFromIco(tiqpitSolutionsWallet, RESERVED_TOKENS_TIQPIT_SOLUTIONS);
709         
710         lockTokens(foundersWallet, RESERVED_TOKENS_FOUNDERS, 1 years);
711 
712         isInitialDistributionDone = true;
713     }
714 
715     /**
716     * @dev Get Purchase by investor's address.
717     * @param _address The address of a ICO investor.
718     */
719     function getIcoPurchase(address _address) view public returns(uint256 weis, uint256 tokens) {
720         return (icoPurchases[_address].refundableWei, icoPurchases[_address].burnableTiqs);
721     }
722 
723     /**
724     * @dev Get Purchase by investor's address.
725     * @param _address The address of a Pre-ICO investor.
726     */
727     function getPreIcoPurchase(address _address) view public returns(uint256 weis, uint256 tokens) {
728         return (preIcoPurchases[_address].refundableWei, preIcoPurchases[_address].burnableTiqs);
729     }
730 
731     /**
732     * @dev Refund Ether invested in pre-ICO to the sender if pre-ICO failed.
733     */
734     function refundPreIco() public {
735         require(hasPreIcoFailed);
736 
737         require(preIcoPurchases[msg.sender].burnableTiqs > 0 && preIcoPurchases[msg.sender].refundableWei > 0);
738         
739         uint256 amountWei = preIcoPurchases[msg.sender].refundableWei;
740         msg.sender.transfer(amountWei);
741 
742         preIcoPurchases[msg.sender].refundableWei = 0;
743         preIcoPurchases[msg.sender].burnableTiqs = 0;
744 
745         token.burnFromAddress(msg.sender);
746     }
747 
748     /**
749     * @dev Refund Ether invested in ICO to the sender if ICO failed.
750     */
751     function refundIco() public {
752         require(hasIcoFailed);
753 
754         require(icoPurchases[msg.sender].burnableTiqs > 0 && icoPurchases[msg.sender].refundableWei > 0);
755         
756         uint256 amountWei = icoPurchases[msg.sender].refundableWei;
757         msg.sender.transfer(amountWei);
758 
759         icoPurchases[msg.sender].refundableWei = 0;
760         icoPurchases[msg.sender].burnableTiqs = 0;
761 
762         token.burnFromAddress(msg.sender);
763     }
764 
765     /**
766     * @dev Manual burn tokens from specified address.
767     * @param _address The address of a investor.
768     */
769     function burnTokens(address _address) onlyOwner public {
770         require(hasIcoFailed);
771 
772         require(icoPurchases[_address].burnableTiqs > 0 || preIcoPurchases[_address].burnableTiqs > 0);
773 
774         icoPurchases[_address].burnableTiqs = 0;
775         preIcoPurchases[_address].burnableTiqs = 0;
776 
777         token.burnFromAddress(_address);
778     }
779 
780     /**
781     * @dev Manual send tokens  for  specified address.
782     * @param _address The address of a investor.
783     * @param _tokensAmount Amount of tokens.
784     */
785     function manualSendTokens(address _address, uint256 _tokensAmount) whenWhitelisted(_address) public onlyPrivilegedAddresses {
786         require(_tokensAmount > 0);
787         
788         if (isPreIco() && _tokensAmount <= tokensRemainingPreIco) {
789             token.transferFromIco(_address, _tokensAmount);
790 
791             addPreIcoPurchaseInfo(_address, 0, _tokensAmount);
792         } else if (isIco() && _tokensAmount <= tokensRemainingIco && soldTokensPreIco >= MINCAP_TOKENS_PRE_ICO) {
793             token.transferFromIco(_address, _tokensAmount);
794 
795             addIcoPurchaseInfo(_address, 0, _tokensAmount);
796         } else {
797             revert();
798         }
799     }
800 
801     /**
802     * @dev Get Locked Contract Address.
803     */
804     function getLockedContractAddress(address wallet) public view returns(address) {
805         return lockedList[wallet];
806     }
807 
808     /**
809     * @dev Enable refund process.
810     */
811     function triggerFailFlags() onlyOwner public {
812         if (!hasPreIcoFailed && now > endTimePreIco && soldTokensPreIco < MINCAP_TOKENS_PRE_ICO) {
813             hasPreIcoFailed = true;
814         }
815 
816         if (!hasIcoFailed && now > endTimeIco && soldTokensIco < MINCAP_TOKENS_ICO) {
817             hasIcoFailed = true;
818         }
819     }
820 
821     /**
822     * @dev Calculate rate for ICO phase.
823     */
824     function currentIcoRate() public view returns(uint256) {     
825         if (now > startTimeIco && now <= startTimeIco + 5 days) {
826             return firstRate;
827         }
828 
829         if (now > startTimeIco + 5 days && now <= startTimeIco + 10 days) {
830             return secondRate;
831         }
832 
833         if (now > startTimeIco + 10 days) {
834             return thirdRate;
835         }
836     }
837 
838     /**
839     * @dev Sell tokens during Pre-ICO && ICO stages.
840     * @dev Sell tokens only for whitelisted wallets.
841     */
842     function sellTokens() whenWhitelisted(msg.sender) whenNotPaused public payable {
843         require(msg.value > 0);
844         
845         bool preIco = isPreIco();
846         bool ico = isIco();
847 
848         if (ico) {require(soldTokensPreIco >= MINCAP_TOKENS_PRE_ICO);}
849         
850         require((preIco && tokensRemainingPreIco > 0) || (ico && tokensRemainingIco > 0));
851         
852         uint256 currentRate = preIco ? preIcoRate : currentIcoRate();
853         
854         uint256 weiAmount = msg.value;
855         uint256 tokensAmount = weiAmount.mul(currentRate);
856 
857         require(tokensAmount >= MIN_INVESTMENT);
858 
859         if (ico) {
860             // Move unsold Pre-Ico tokens for current phase.
861             if (tokensRemainingPreIco > 0) {
862                 tokensRemainingIco = tokensRemainingIco.add(tokensRemainingPreIco);
863                 tokensRemainingPreIco = 0;
864             }
865         }
866        
867         uint256 tokensRemaining = preIco ? tokensRemainingPreIco : tokensRemainingIco;
868         if (tokensAmount > tokensRemaining) {
869             uint256 tokensRemainder = tokensAmount.sub(tokensRemaining);
870             tokensAmount = tokensAmount.sub(tokensRemainder);
871             
872             uint256 overpaidWei = tokensRemainder.div(currentRate);
873             msg.sender.transfer(overpaidWei);
874 
875             weiAmount = msg.value.sub(overpaidWei);
876         }
877 
878         token.transferFromIco(msg.sender, tokensAmount);
879 
880         if (preIco) {
881             addPreIcoPurchaseInfo(msg.sender, weiAmount, tokensAmount);
882 
883             if (soldTokensPreIco >= MINCAP_TOKENS_PRE_ICO) {
884                 tiqpitSolutionsWallet.transfer(this.balance);
885             }
886         }
887 
888         if (ico) {
889             addIcoPurchaseInfo(msg.sender, weiAmount, tokensAmount);
890 
891             if (soldTokensIco >= MINCAP_TOKENS_ICO) {
892                 tiqpitSolutionsWallet.transfer(this.balance);
893             }
894         }
895     }
896 
897     /**
898     * @dev Add new investment to the Pre-ICO investments storage.
899     * @param _address The address of a Pre-ICO investor.
900     * @param _amountWei The investment received from a Pre-ICO investor.
901     * @param _amountTokens The tokens that will be sent to Pre-ICO investor.
902     */
903     function addPreIcoPurchaseInfo(address _address, uint256 _amountWei, uint256 _amountTokens) internal {
904         preIcoPurchases[_address].refundableWei = preIcoPurchases[_address].refundableWei.add(_amountWei);
905         preIcoPurchases[_address].burnableTiqs = preIcoPurchases[_address].burnableTiqs.add(_amountTokens);
906 
907         soldTokensPreIco = soldTokensPreIco.add(_amountTokens);
908         tokensRemainingPreIco = tokensRemainingPreIco.sub(_amountTokens);
909 
910         weiRaisedPreIco = weiRaisedPreIco.add(_amountWei);
911 
912         soldTokensTotal = soldTokensTotal.add(_amountTokens);
913         weiRaisedTotal = weiRaisedTotal.add(_amountWei);
914     }
915 
916     /**
917     * @dev Add new investment to the ICO investments storage.
918     * @param _address The address of a ICO investor.
919     * @param _amountWei The investment received from a ICO investor.
920     * @param _amountTokens The tokens that will be sent to ICO investor.
921     */
922     function addIcoPurchaseInfo(address _address, uint256 _amountWei, uint256 _amountTokens) internal {
923         icoPurchases[_address].refundableWei = icoPurchases[_address].refundableWei.add(_amountWei);
924         icoPurchases[_address].burnableTiqs = icoPurchases[_address].burnableTiqs.add(_amountTokens);
925 
926         soldTokensIco = soldTokensIco.add(_amountTokens);
927         tokensRemainingIco = tokensRemainingIco.sub(_amountTokens);
928 
929         weiRaisedIco = weiRaisedIco.add(_amountWei);
930 
931         soldTokensTotal = soldTokensTotal.add(_amountTokens);
932         weiRaisedTotal = weiRaisedTotal.add(_amountWei);
933     }
934 
935     /**
936     * @dev Locked specified amount  of  tokens for  specified wallet.
937     * @param _wallet The address of wallet.
938     * @param _amount The tokens  for locked.
939     * @param _time The time for locked period.
940     */
941     function lockTokens(address _wallet, uint256 _amount, uint256 _time) internal {
942         LockedOutTokens locked = new LockedOutTokens(_wallet, token, endTimePreIco, 1, _amount, _time);
943         lockedList[_wallet] = locked;
944         token.transferFromIco(locked, _amount);
945     }
946 
947     /**
948     * @dev Sets the backend address for automated operations.
949     * @param _backendAddress The backend address to allow.
950     */
951     function setBackendAddress(address _backendAddress) public onlyOwner {
952         require(_backendAddress != address(0));
953         backendAddress = _backendAddress;
954     }
955 
956     /**
957     * @dev Allows the function to be called only by the owner and backend.
958     */
959     modifier onlyPrivilegedAddresses() {
960         require(msg.sender == owner || msg.sender == backendAddress);
961         _;
962     }
963 }