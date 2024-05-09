1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() public {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 
60 
61 
62 /**
63  * Math operations with safety checks
64  */
65 library SafeMath {
66   function mul(uint a, uint b) internal returns (uint) {
67     uint c = a * b;
68     assert(a == 0 || c / a == b);
69     return c;
70   }
71 
72   function div(uint a, uint b) internal returns (uint) {
73     assert(b > 0);
74     uint c = a / b;
75     assert(a == b * c + a % b);
76     return c;
77   }
78 
79   function sub(uint a, uint b) internal returns (uint) {
80     assert(b <= a);
81     return a - b;
82   }
83 
84   function add(uint a, uint b) internal returns (uint) {
85     uint c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 
90   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
91     return a >= b ? a : b;
92   }
93 
94   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
95     return a < b ? a : b;
96   }
97 
98   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
99     return a >= b ? a : b;
100   }
101 
102   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
103     return a < b ? a : b;
104   }
105 }
106 
107 
108 
109 
110 
111 
112 
113 
114 
115 
116 
117 
118 
119 
120 
121 
122 /**
123  * @title Basic token
124  * @dev Basic version of StandardToken, with no allowances.
125  */
126 contract BasicToken is ERC20Basic {
127   using SafeMath for uint256;
128 
129   /**
130   * @dev Fix for the ERC20 short address attack.
131    */
132   modifier onlyPayloadSize(uint size) {
133     require(msg.data.length >= size + 4) ;
134     _;
135   }
136 
137   mapping(address => uint256) balances;
138 
139   /**
140   * @dev transfer token for a specified address
141   * @param _to The address to transfer to.
142   * @param _value The amount to be transferred.
143   */
144   function transfer(address _to, uint256 _value) public onlyPayloadSize(2 * 32) returns (bool) {
145     require(_to != address(0));
146 
147     // SafeMath.sub will throw if there is not enough balance.
148     balances[msg.sender] = balances[msg.sender].sub(_value);
149     balances[_to] = balances[_to].add(_value);
150     Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   /**
155   * @dev Gets the balance of the specified address.
156   * @param _owner The address to query the the balance of.
157   * @return An uint256 representing the amount owned by the passed address.
158   */
159   function balanceOf(address _owner) public constant returns (uint256 balance) {
160     return balances[_owner];
161   }
162 
163 }
164 
165 
166 
167 
168 
169 
170 /**
171  * @title ERC20 interface
172  * @dev see https://github.com/ethereum/EIPs/issues/20
173  */
174 contract ERC20 is ERC20Basic {
175   function allowance(address owner, address spender) public constant returns (uint256);
176   function transferFrom(address from, address to, uint256 value) public returns (bool);
177   function approve(address spender, uint256 value) public returns (bool);
178   event Approval(address indexed owner, address indexed spender, uint256 value);
179 }
180 
181 
182 
183 /**
184  * @title Standard ERC20 token
185  *
186  * @dev Implementation of the basic standard token.
187  * @dev https://github.com/ethereum/EIPs/issues/20
188  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
189  */
190 contract StandardToken is ERC20, BasicToken {
191 
192   /**
193   * @dev Fix for the ERC20 short address attack.
194    */
195   modifier onlyPayloadSize(uint size) {
196     require(msg.data.length >= size + 4) ;
197     _;
198   }
199 
200   mapping (address => mapping (address => uint256)) allowed;
201 
202 
203   /**
204    * @dev Transfer tokens from one address to another
205    * @param _from address The address which you want to send tokens from
206    * @param _to address The address which you want to transfer to
207    * @param _value uint256 the amount of tokens to be transferred
208    */
209   function transferFrom(address _from, address _to, uint256 _value) public onlyPayloadSize(3 * 32) returns (bool) {
210     require(_to != address(0));
211 
212     uint256 _allowance = allowed[_from][msg.sender];
213 
214     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
215     // require (_value <= _allowance);
216 
217     balances[_from] = balances[_from].sub(_value);
218     balances[_to] = balances[_to].add(_value);
219     allowed[_from][msg.sender] = _allowance.sub(_value);
220     Transfer(_from, _to, _value);
221     return true;
222   }
223 
224   /**
225    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
226    *
227    * Beware that changing an allowance with this method brings the risk that someone may use both the old
228    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231    * @param _spender The address which will spend the funds.
232    * @param _value The amount of tokens to be spent.
233    */
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     allowed[msg.sender][_spender] = _value;
236     Approval(msg.sender, _spender, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Function to check the amount of tokens that an owner allowed to a spender.
242    * @param _owner address The address which owns the funds.
243    * @param _spender address The address which will spend the funds.
244    * @return A uint256 specifying the amount of tokens still available for the spender.
245    */
246   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
247     return allowed[_owner][_spender];
248   }
249 
250   /**
251    * approve should be called when allowed[_spender] == 0. To increment
252    * allowed value is better to use this function to avoid 2 calls (and wait until
253    * the first transaction is mined)
254    * From MonolithDAO Token.sol
255    */
256   function increaseApproval (address _spender, uint _addedValue)
257     public returns (bool success) {
258     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
259     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
260     return true;
261   }
262 
263   function decreaseApproval (address _spender, uint _subtractedValue)
264     public returns (bool success) {
265     uint oldValue = allowed[msg.sender][_spender];
266     if (_subtractedValue > oldValue) {
267       allowed[msg.sender][_spender] = 0;
268     } else {
269       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
270     }
271     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
272     return true;
273   }
274 
275 }
276 
277 
278 
279 
280 
281 
282 
283 /**
284  * @title Pausable
285  * @dev Base contract which allows children to implement an emergency stop mechanism.
286  */
287 contract Pausable is Ownable {
288   event Pause();
289   event Unpause();
290 
291   bool public paused = false;
292 
293 
294   /**
295    * @dev Modifier to make a function callable only when the contract is not paused.
296    */
297   modifier whenNotPaused() {
298     require(!paused);
299     _;
300   }
301 
302   /**
303    * @dev Modifier to make a function callable only when the contract is paused.
304    */
305   modifier whenPaused() {
306     require(paused);
307     _;
308   }
309 
310   /**
311    * @dev called by the owner to pause, triggers stopped state
312    */
313   function pause() onlyOwner whenNotPaused public {
314     paused = true;
315     Pause();
316   }
317 
318   /**
319    * @dev called by the owner to unpause, returns to normal state
320    */
321   function unpause() onlyOwner whenPaused public {
322     paused = false;
323     Unpause();
324   }
325 }
326 
327 
328 /**
329  * @title DML Token Contract
330  * @dev DML Token Contract
331  * @dev inherite from StandardToken, Pasuable and Ownable by Zeppelin
332  * @author DML team
333  */
334 
335 contract DmlToken is StandardToken, Pausable{
336 	using SafeMath for uint;
337 
338  	string public constant name = "DML Token";
339 	uint8 public constant decimals = 18;
340 	string public constant symbol = 'DML';
341 
342 	uint public constant MAX_TOTAL_TOKEN_AMOUNT = 330000000 ether;
343 	address public minter;
344 	uint public endTime;
345 
346 	mapping (address => uint) public lockedBalances;
347 
348 	modifier onlyMinter {
349     	  assert(msg.sender == minter);
350     	  _;
351     }
352 
353     modifier maxDmlTokenAmountNotReached (uint amount){
354     	  assert(totalSupply.add(amount) <= MAX_TOTAL_TOKEN_AMOUNT);
355     	  _;
356     }
357 
358     /**
359      * @dev Constructor
360      * @param _minter Contribution Smart Contract
361      * @return _endTime End of the contribution period
362      */
363 	function DmlToken(address _minter, uint _endTime){
364     	  minter = _minter;
365     	  endTime = _endTime;
366     }
367 
368     /**
369      * @dev Mint Token
370      * @param receipent address owning mint tokens    
371      * @param amount amount of token
372      */
373     function mintToken(address receipent, uint amount)
374         external
375         onlyMinter
376         maxDmlTokenAmountNotReached(amount)
377         returns (bool)
378     {
379         require(now <= endTime);
380       	lockedBalances[receipent] = lockedBalances[receipent].add(amount);
381       	totalSupply = totalSupply.add(amount);
382       	return true;
383     }
384 
385     /**
386      * @dev Unlock token for trade
387      */
388     function claimTokens(address receipent)
389         public
390         onlyMinter
391     {
392       	balances[receipent] = balances[receipent].add(lockedBalances[receipent]);
393       	lockedBalances[receipent] = 0;
394     }
395 
396     function lockedBalanceOf(address _owner) constant returns (uint balance) {
397         return lockedBalances[_owner];
398     }
399 
400 	/**
401 	* @dev override to add validRecipient
402 	* @param _to The address to transfer to.
403 	* @param _value The amount to be transferred.
404 	*/
405 	function transfer(address _to, uint _value)
406 		public
407 		validRecipient(_to)
408 		returns (bool success)
409 	{
410 		return super.transfer(_to, _value);
411 	}
412 
413 	/**
414 	* @dev override to add validRecipient
415 	* @param _spender The address which will spend the funds.
416 	* @param _value The amount of tokens to be spent.
417 	*/
418 	function approve(address _spender, uint256 _value)
419 		public
420 		validRecipient(_spender)
421 		returns (bool)
422 	{
423 		return super.approve(_spender,  _value);
424 	}
425 
426 	/**
427 	* @dev override to add validRecipient
428 	* @param _from address The address which you want to send tokens from
429 	* @param _to address The address which you want to transfer to
430 	* @param _value uint256 the amount of tokens to be transferred
431 	*/
432 	function transferFrom(address _from, address _to, uint256 _value)
433 		public
434 		validRecipient(_to)
435 		returns (bool)
436 	{
437 		return super.transferFrom(_from, _to, _value);
438 	}
439 
440 	// MODIFIERS
441 
442  	modifier validRecipient(address _recipient) {
443     	require(_recipient != address(this));
444     	_;
445   	}
446 }
447 
448 
449 
450 /**
451  * @title DML Contribution Contract
452  * @dev DML Contribution Contract
453  * @dev inherite from StandardToken, Ownable by Zeppelin
454  * @author DML team
455  */
456 contract DmlContribution is Ownable {
457     using SafeMath for uint;
458 
459     /// Constant fields
460     /// total tokens supply
461     uint public constant DML_TOTAL_SUPPLY = 330000000 ether;
462     uint public constant EARLY_CONTRIBUTION_DURATION = 24 hours;
463     uint public constant MAX_CONTRIBUTION_DURATION = 5 days;
464 
465     /// Exchange rates
466     uint public constant PRICE_RATE_FIRST = 3780;
467     uint public constant PRICE_RATE_SECOND = 4158;
468 
469     /// ----------------------------------------------------------------------------------------------------
470     /// |                                   |              |                    |             |            |
471     /// |    SALE (PRESALE + PUBLIC SALE)   |  ECO SYSTEM  |  COMMUNITY BOUNTY  |  OPERATION  |  RESERVES  |
472     /// |            36%                    |     9.9%     |         8.3%       |     30.8%   |     15%    |
473     /// ----------------------------------------------------------------------------------------------------
474     uint public constant SALE_STAKE = 360;  // 36% for open sale
475 
476     // Reserved stakes
477     uint public constant ECO_SYSTEM_STAKE = 99;   // 9.9%
478     uint public constant COMMUNITY_BOUNTY_STAKE = 83; // 8.3%
479     uint public constant OPERATION_STAKE = 308;     // 30.8%
480     uint public constant RESERVES_STAKE = 150;     // 15.0%
481 
482     uint public constant DIVISOR_STAKE = 1000;
483 
484     uint public constant PRESALE_RESERVERED_AMOUNT = 56899342578812412860512236;
485     
486     /// Holder address
487     address public constant ECO_SYSTEM_HOLDER = 0x2D8C705a66b2E87A9249380d4Cdfe9D80BBF826B;
488     address public constant COMMUNITY_BOUNTY_HOLDER = 0x68500ffEfb57D88A600E2f1c63Bb5866e7107b6B;
489     address public constant OPERATION_HOLDER = 0xC7b6DFf52014E59Cb88fAc3b371FA955D0A9249F;
490     address public constant RESERVES_HOLDER = 0xab376b3eC2ed446444911E549c7C953fB086070f;
491     address public constant PRESALE_HOLDER = 0xcB52583D19fd42c0f85a0c83A45DEa6C73B9EBfb;
492     
493     uint public MAX_PUBLIC_SOLD = DML_TOTAL_SUPPLY * SALE_STAKE / DIVISOR_STAKE - PRESALE_RESERVERED_AMOUNT;
494 
495     /// Fields that are only changed in constructor    
496     /// Address that storing all ETH
497     address public dmlwallet;
498     uint public earlyWhitelistBeginTime;
499     uint public startTime;
500     uint public endTime;
501 
502     /// Fields that can be changed by functions
503     /// Accumulator for open sold tokens
504     uint public openSoldTokens;
505     /// Due to an emergency, set this to true to halt the contribution
506     bool public halted; 
507     /// ERC20 compilant DML token contact instance
508     DmlToken public dmlToken; 
509 
510     mapping (address => WhitelistUser) private whitelisted;
511     address[] private whitelistedIndex;
512 
513     struct WhitelistUser {
514       uint256 quota;
515       uint index;
516       uint level;
517     }
518     /// level 1 Main Whitelist
519     /// level 2 Early Whitelist
520     /// level 3 Early Super Whitelist
521 
522     uint256 public maxBuyLimit = 68 ether;
523 
524     /*
525      * EVENTS
526      */
527 
528     event NewSale(address indexed destAddress, uint ethCost, uint gotTokens);
529     event ToFundAmount(uint ethCost);
530     event ValidFundAmount(uint ethCost);
531     event Debug(uint number);
532     event UserCallBuy();
533     event ShowTokenAvailable(uint);
534     event NowTime(uint, uint, uint, uint);
535 
536     /*
537      * MODIFIERS
538      */
539 
540     modifier notHalted() {
541         require(!halted);
542         _;
543     }
544 
545     modifier initialized() {
546         require(address(dmlwallet) != 0x0);
547         _;
548     }    
549 
550     modifier notEarlierThan(uint x) {
551         require(now >= x);
552         _;
553     }
554 
555     modifier earlierThan(uint x) {
556         require(now < x);
557         _;
558     }
559 
560     modifier ceilingNotReached() {
561         require(openSoldTokens < MAX_PUBLIC_SOLD);
562         _;
563     }  
564 
565     modifier isSaleEnded() {
566         require(now > endTime || openSoldTokens >= MAX_PUBLIC_SOLD);
567         _;
568     }
569 
570 
571     /**
572      * CONSTRUCTOR 
573      * 
574      * @dev Initialize the DML contribution contract
575      * @param _dmlwallet The escrow account address, all ethers will be sent to this address.
576      * @param _bootTime ICO boot time
577      */
578     function DmlContribution(address _dmlwallet, uint _bootTime){
579         require(_dmlwallet != 0x0);
580 
581         halted = false;
582         dmlwallet = _dmlwallet;
583         earlyWhitelistBeginTime = _bootTime;
584         startTime = earlyWhitelistBeginTime + EARLY_CONTRIBUTION_DURATION;
585         endTime = startTime + MAX_CONTRIBUTION_DURATION;
586         openSoldTokens = 0;
587         dmlToken = new DmlToken(this, endTime);
588 
589         uint stakeMultiplier = DML_TOTAL_SUPPLY / DIVISOR_STAKE;
590         
591         dmlToken.mintToken(ECO_SYSTEM_HOLDER, ECO_SYSTEM_STAKE * stakeMultiplier);
592         dmlToken.mintToken(COMMUNITY_BOUNTY_HOLDER, COMMUNITY_BOUNTY_STAKE * stakeMultiplier);
593         dmlToken.mintToken(OPERATION_HOLDER, OPERATION_STAKE * stakeMultiplier);
594         dmlToken.mintToken(RESERVES_HOLDER, RESERVES_STAKE * stakeMultiplier);
595 
596         dmlToken.mintToken(PRESALE_HOLDER, PRESALE_RESERVERED_AMOUNT);      
597         
598     }
599 
600     /**
601      * Fallback function 
602      * 
603      * @dev Set it to buy Token if anyone send ETH
604      */
605     function () public payable {
606         buyDmlCoin(msg.sender);
607         //NowTime(now, earlyWhitelistBeginTime, startTime, endTime);
608     }
609 
610     /*
611      * PUBLIC FUNCTIONS
612      */
613 
614     /// @dev Exchange msg.value ether to DML for account recepient
615     /// @param receipient DML tokens receiver
616     function buyDmlCoin(address receipient) 
617         public 
618         payable 
619         notHalted 
620         initialized 
621         ceilingNotReached 
622         notEarlierThan(earlyWhitelistBeginTime)
623         earlierThan(endTime)
624         returns (bool) 
625     {
626         require(receipient != 0x0);
627         require(isWhitelisted(receipient));
628 
629         // Do not allow contracts to game the system
630         require(!isContract(msg.sender));        
631         require( tx.gasprice <= 99000000000 wei );
632 
633         if( now < startTime && now >= earlyWhitelistBeginTime)
634         {
635             if (whitelisted[receipient].level >= 2)
636             {
637                 require(msg.value >= 1 ether);
638             }
639             else
640             {
641                 require(msg.value >= 0.5 ether);
642             }
643             buyEarlyWhitelist(receipient);
644         }
645         else
646         {
647             require(msg.value >= 0.1 ether);
648             require(msg.value <= maxBuyLimit);
649             buyRemaining(receipient);
650         }
651 
652         return true;
653     }
654 
655     function setMaxBuyLimit(uint256 limit)
656         public
657         initialized
658         onlyOwner
659         earlierThan(endTime)
660     {
661         maxBuyLimit = limit;
662     }
663 
664 
665     /// @dev batch set quota for early user quota
666     function addWhiteListUsers(address[] userAddresses, uint256[] quota, uint[] level)
667         public
668         onlyOwner
669         earlierThan(endTime)
670     {
671         for( uint i = 0; i < userAddresses.length; i++) {
672             addWhiteListUser(userAddresses[i], quota[i], level[i]);
673         }
674     }
675 
676     function addWhiteListUser(address userAddress, uint256 quota, uint level)
677         public
678         onlyOwner
679         earlierThan(endTime)
680     {
681         if (!isWhitelisted(userAddress)) {
682             whitelisted[userAddress].quota = quota;
683             whitelisted[userAddress].level = level;
684             whitelisted[userAddress].index = whitelistedIndex.push(userAddress) - 1;
685         }
686     }
687 
688     /**
689     * @dev Get a user's whitelisted state
690     * @param userAddress      address       the wallet address of the user
691     * @return bool  true if the user is in the whitelist
692     */
693     function isWhitelisted (address userAddress) public constant returns (bool isIndeed) {
694         if (whitelistedIndex.length == 0) return false;
695         return (whitelistedIndex[whitelisted[userAddress].index] == userAddress);
696     }
697 
698     /*****
699     * @dev Get a whitelisted user
700     * @param userAddress      address       the wallet address of the user
701     * @return uint256  the amount pledged by the user
702     * @return uint     the index of the user
703     */
704     function getWhitelistUser (address userAddress) public constant returns (uint256 quota, uint index, uint level) {
705         require(isWhitelisted(userAddress));
706         return(whitelisted[userAddress].quota, whitelisted[userAddress].index, whitelisted[userAddress].level);
707     }
708 
709 
710     /// @dev Emergency situation that requires contribution period to stop.
711     /// Contributing not possible anymore.
712     function halt() public onlyOwner{
713         halted = true;
714     }
715 
716     /// @dev Emergency situation resolved.
717     /// Contributing becomes possible again withing the outlined restrictions.
718     function unHalt() public onlyOwner{
719         halted = false;
720     }
721 
722     /// @dev Emergency situation
723     function changeWalletAddress(address newAddress) onlyOwner{ 
724         dmlwallet = newAddress; 
725     }
726 
727     /// @return true if sale not ended, false otherwise.
728     function saleNotEnd() constant returns (bool) {
729         return now < endTime && openSoldTokens < MAX_PUBLIC_SOLD;
730     }
731 
732     /// CONSTANT METHODS
733     /// @dev Get current exchange rate
734     function priceRate() public constant returns (uint) {
735         // Two price tiers
736         if (earlyWhitelistBeginTime <= now && now < startTime)
737         {
738             if (whitelisted[msg.sender].level >= 2)
739             {
740                 return PRICE_RATE_SECOND;
741             }
742             else
743             {
744                 return PRICE_RATE_FIRST;
745             }
746         }
747         if (startTime <= now && now < endTime)
748         {
749             return PRICE_RATE_FIRST;
750         }
751         // Should not be called before or after contribution period
752         assert(false);
753     }
754     function claimTokens(address receipent)
755         public
756         isSaleEnded
757     {
758         dmlToken.claimTokens(receipent);
759     }
760 
761     /*
762      * INTERNAL FUNCTIONS
763      */
764 
765     /// @dev early_whitelist to buy token with quota
766     function buyEarlyWhitelist(address receipient) internal {
767         uint quotaAvailable = whitelisted[receipient].quota;
768         require(quotaAvailable > 0);
769 
770         uint tokenAvailable = MAX_PUBLIC_SOLD.sub(openSoldTokens);
771         ShowTokenAvailable(tokenAvailable);
772         require(tokenAvailable > 0);
773 
774         uint validFund = quotaAvailable.min256(msg.value);
775         ValidFundAmount(validFund);
776 
777         uint toFund;
778         uint toCollect;
779         (toFund, toCollect) = costAndBuyTokens(tokenAvailable, validFund);
780 
781         whitelisted[receipient].quota = whitelisted[receipient].quota.sub(toFund);
782         buyCommon(receipient, toFund, toCollect);
783     }
784 
785     /// @dev early_whitelist and main whitelist to buy token with their quota + extra quota
786     function buyRemaining(address receipient) internal {
787         uint tokenAvailable = MAX_PUBLIC_SOLD.sub(openSoldTokens);
788         ShowTokenAvailable(tokenAvailable);
789         require(tokenAvailable > 0);
790 
791         uint toFund;
792         uint toCollect;
793         (toFund, toCollect) = costAndBuyTokens(tokenAvailable, msg.value);
794         
795         buyCommon(receipient, toFund, toCollect);
796     }
797 
798     /// @dev Utility function for buy token
799     function buyCommon(address receipient, uint toFund, uint dmlTokenCollect) internal {
800         require(msg.value >= toFund); // double check
801 
802         if(toFund > 0) {
803             require(dmlToken.mintToken(receipient, dmlTokenCollect));
804             ToFundAmount(toFund);
805             dmlwallet.transfer(toFund);
806             openSoldTokens = openSoldTokens.add(dmlTokenCollect);
807             NewSale(receipient, toFund, dmlTokenCollect);            
808         }
809 
810         uint toReturn = msg.value.sub(toFund);
811         if(toReturn > 0) {
812             msg.sender.transfer(toReturn);
813         }
814     }
815 
816     /// @dev Utility function for calculate available tokens and cost ethers
817     function costAndBuyTokens(uint availableToken, uint validFund) constant internal returns (uint costValue, uint getTokens){
818         // all conditions has checked in the caller functions
819         uint exchangeRate = priceRate();
820         getTokens = exchangeRate * validFund;
821 
822         if(availableToken >= getTokens){
823             costValue = validFund;
824         } else {
825             costValue = availableToken / exchangeRate;
826             getTokens = availableToken;
827         }
828     }
829 
830     /// @dev Internal function to determine if an address is a contract
831     /// @param _addr The address being queried
832     /// @return True if `_addr` is a contract
833     function isContract(address _addr) constant internal returns(bool) {
834         uint size;
835         assembly {
836             size := extcodesize(_addr)
837         }
838         return size > 0;
839     }
840 }