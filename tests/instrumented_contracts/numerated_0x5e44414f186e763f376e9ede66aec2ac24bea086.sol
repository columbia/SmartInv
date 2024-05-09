1 pragma solidity ^0.5.2;
2 
3 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   constructor() public {
22     owner = msg.sender;
23   }
24 
25 
26   /**
27    * @dev Throws if called by any account other than the owner.
28    */
29   modifier onlyOwner() {
30     require(msg.sender == owner);
31     _;
32   }
33 
34 
35   /**
36    * @dev Allows the current owner to transfer control of the contract to a newOwner.
37    * @param newOwner The address to transfer ownership to.
38    */
39   function transferOwnership(address newOwner) public onlyOwner {
40     require(newOwner != address(0));
41     emit OwnershipTransferred(owner, newOwner);
42     owner = newOwner;
43   }
44 
45 }
46 
47 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
48 
49 /**
50  * @title Pausable
51  * @dev Base contract which allows children to implement an emergency stop mechanism.
52  */
53 contract Pausable is Ownable {
54   event Pause();
55   event Unpause();
56 
57   bool public paused = false;
58 
59 
60   /**
61    * @dev Modifier to make a function callable only when the contract is not paused.
62    */
63   modifier whenNotPaused() {
64     require(!paused);
65     _;
66   }
67 
68   /**
69    * @dev Modifier to make a function callable only when the contract is paused.
70    */
71   modifier whenPaused() {
72     require(paused);
73     _;
74   }
75 
76   /**
77    * @dev called by the owner to pause, triggers stopped state
78    */
79   function pause() onlyOwner whenNotPaused public {
80     paused = true;
81     emit Pause();
82   }
83 
84   /**
85    * @dev called by the owner to unpause, returns to normal state
86    */
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     emit Unpause();
90   }
91 }
92 
93 // File: zeppelin-solidity/contracts/math/SafeMath.sol
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that throw on error
98  */
99 library SafeMath {
100   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101     if (a == 0) {
102       return 0;
103     }
104     uint256 c = a * b;
105     assert(c / a == b);
106     return c;
107   }
108 
109   function div(uint256 a, uint256 b) internal pure returns (uint256) {
110     // assert(b > 0); // Solidity automatically throws when dividing by 0
111     uint256 c = a / b;
112     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
113     return c;
114   }
115 
116   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117     assert(b <= a);
118     return a - b;
119   }
120 
121   function add(uint256 a, uint256 b) internal pure returns (uint256) {
122     uint256 c = a + b;
123     assert(c >= a);
124     return c;
125   }
126 }
127 
128 // File: zeppelin-solidity/contracts/token/ERC20Basic.sol
129 
130 /**
131  * @title ERC20Basic
132  * @dev Simpler version of ERC20 interface
133  * @dev see https://github.com/ethereum/EIPs/issues/179
134  */
135 contract ERC20Basic {
136   uint256 public totalSupply;
137   function balanceOf(address who) public view returns (uint256);
138   function transfer(address to, uint256 value) public returns (bool);
139   event Transfer(address indexed from, address indexed to, uint256 value);
140 }
141 
142 // File: zeppelin-solidity/contracts/token/BasicToken.sol
143 
144 /**
145  * @title Basic token
146  * @dev Basic version of StandardToken, with no allowances.
147  */
148 contract BasicToken is ERC20Basic {
149   using SafeMath for uint256;
150 
151   mapping(address => uint256) balances;
152 
153   /**
154   * @dev transfer token for a specified address
155   * @param _to The address to transfer to.
156   * @param _value The amount to be transferred.
157   */
158   function transfer(address _to, uint256 _value) public returns (bool) {
159     require(_to != address(0));
160     require(_value <= balances[msg.sender]);
161 
162     // SafeMath.sub will throw if there is not enough balance.
163     balances[msg.sender] = balances[msg.sender].sub(_value);
164     balances[_to] = balances[_to].add(_value);
165     emit Transfer(msg.sender, _to, _value);
166     return true;
167   }
168 
169   /**
170   * @dev Gets the balance of the specified address.
171   * @param _owner The address to query the the balance of.
172   * @return An uint256 representing the amount owned by the passed address.
173   */
174   function balanceOf(address _owner) public view returns (uint256 balance) {
175     return balances[_owner];
176   }
177 
178 }
179 
180 // File: zeppelin-solidity/contracts/token/ERC20.sol
181 
182 /**
183  * @title ERC20 interface
184  * @dev see https://github.com/ethereum/EIPs/issues/20
185  */
186 contract ERC20 is ERC20Basic {
187   function allowance(address owner, address spender) public view returns (uint256);
188   function transferFrom(address from, address to, uint256 value) public returns (bool);
189   function approve(address spender, uint256 value) public returns (bool);
190   event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 // File: zeppelin-solidity/contracts/token/StandardToken.sol
194 
195 /**
196  * @title Standard ERC20 token
197  *
198  * @dev Implementation of the basic standard token.
199  * @dev https://github.com/ethereum/EIPs/issues/20
200  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
201  */
202 contract StandardToken is ERC20, BasicToken {
203 
204   mapping (address => mapping (address => uint256)) internal allowed;
205 
206 
207   /**
208    * @dev Transfer tokens from one address to another
209    * @param _from address The address which you want to send tokens from
210    * @param _to address The address which you want to transfer to
211    * @param _value uint256 the amount of tokens to be transferred
212    */
213   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
214     require(_to != address(0));
215     require(_value <= balances[_from]);
216     require(_value <= allowed[_from][msg.sender]);
217 
218     balances[_from] = balances[_from].sub(_value);
219     balances[_to] = balances[_to].add(_value);
220     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
221     emit Transfer(_from, _to, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227    *
228    * Beware that changing an allowance with this method brings the risk that someone may use both the old
229    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
230    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
231    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
232    * @param _spender The address which will spend the funds.
233    * @param _value The amount of tokens to be spent.
234    */
235   function approve(address _spender, uint256 _value) public returns (bool) {
236     allowed[msg.sender][_spender] = _value;
237     emit Approval(msg.sender, _spender, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Function to check the amount of tokens that an owner allowed to a spender.
243    * @param _owner address The address which owns the funds.
244    * @param _spender address The address which will spend the funds.
245    * @return A uint256 specifying the amount of tokens still available for the spender.
246    */
247   function allowance(address _owner, address _spender) public view returns (uint256) {
248     return allowed[_owner][_spender];
249   }
250 
251   /**
252    * @dev Increase the amount of tokens that an owner allowed to a spender.
253    *
254    * approve should be called when allowed[_spender] == 0. To increment
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _addedValue The amount of tokens to increase the allowance by.
260    */
261   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
262     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
263     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
264     return true;
265   }
266 
267   /**
268    * @dev Decrease the amount of tokens that an owner allowed to a spender.
269    *
270    * approve should be called when allowed[_spender] == 0. To decrement
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param _spender The address which will spend the funds.
275    * @param _subtractedValue The amount of tokens to decrease the allowance by.
276    */
277   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
278     uint oldValue = allowed[msg.sender][_spender];
279     if (_subtractedValue > oldValue) {
280       allowed[msg.sender][_spender] = 0;
281     } else {
282       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
283     }
284     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
285     return true;
286   }
287 
288 }
289 
290 // File: zeppelin-solidity/contracts/token/PausableToken.sol
291 
292 /**
293  * @title Pausable token
294  *
295  * @dev StandardToken modified with pausable transfers.
296  **/
297 
298 contract PausableToken is StandardToken, Pausable {
299 
300   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
301     return super.transfer(_to, _value);
302   }
303 
304   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
305     return super.transferFrom(_from, _to, _value);
306   }
307 
308   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
309     return super.approve(_spender, _value);
310   }
311 
312   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
313     return super.increaseApproval(_spender, _addedValue);
314   }
315 
316   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
317     return super.decreaseApproval(_spender, _subtractedValue);
318   }
319 }
320 
321 // File: contracts/URACToken.sol
322 
323 /// @title URACToken Contract
324 /// For more information about this token sale, please visit http://www.uranus.io
325 /// @author reedhong
326 contract URACToken is PausableToken {
327     using SafeMath for uint;
328 
329     /// Constant token specific fields
330     string public constant name = "URACToken";
331     string public constant symbol = "URAC";
332     uint public constant decimals = 18;
333 
334     /// URAC total tokens supply
335     uint public currentSupply;
336 
337     /// Fields that are only changed in constructor
338     /// URAC sale  contract
339     address public minter;
340 
341     /// Fields that can be changed by functions
342     mapping (address => uint) public lockedBalances;
343 
344     /// claim flag
345     bool public claimedFlag;
346 
347     /*
348      * MODIFIERS
349      */
350     modifier onlyMinter {
351         require(msg.sender == minter);
352         _;
353     }
354 
355     modifier canClaimed {
356         require(claimedFlag == true);
357         _;
358     }
359 
360     modifier maxTokenAmountNotReached (uint amount){
361         require(currentSupply.add(amount) <= totalSupply);
362         _;
363     }
364 
365     modifier validAddress( address addr ) {
366         require(addr != address(0x0));
367         require(addr != address(this));
368         _;
369     }
370 
371     /**
372      * CONSTRUCTOR
373      *
374      * @dev Initialize the URAC Token
375      * @param _minter The URACCrowdSale Contract
376      * @param _maxTotalSupply total supply token
377      */
378     constructor(address _minter, address _admin, uint _maxTotalSupply)
379         public
380         validAddress(_admin)
381         validAddress(_minter)
382         {
383         minter = _minter;
384         totalSupply = _maxTotalSupply;
385         claimedFlag = false;
386         transferOwnership(_admin);
387     }
388 
389     function mintex(uint amount) public onlyOwner {
390         balances[msg.sender] = balances[msg.sender].add(amount);
391         totalSupply = totalSupply.add(amount);
392     }
393 
394     /**
395      * EXTERNAL FUNCTION
396      *
397      * @dev URACCrowdSale contract instance mint token
398      * @param receipent The destination account owned mint tokens
399      * @param amount The amount of mint token
400      * @param isLock Lock token flag
401      * be sent to this address.
402      */
403 
404     function mint(address receipent, uint amount, bool isLock)
405         external
406         onlyMinter
407         maxTokenAmountNotReached(amount)
408         returns (bool)
409     {
410         if (isLock ) {
411             lockedBalances[receipent] = lockedBalances[receipent].add(amount);
412         } else {
413             balances[receipent] = balances[receipent].add(amount);
414         }
415         currentSupply = currentSupply.add(amount);
416         return true;
417     }
418 
419 
420     function setClaimedFlag(bool flag)
421         public
422         onlyOwner
423     {
424         claimedFlag = flag;
425     }
426 
427      /*
428      * PUBLIC FUNCTIONS
429      */
430 
431     /// @dev Locking period has passed - Locked tokens have turned into tradeable
432     function claimTokens(address[] calldata receipents)
433         external
434         canClaimed
435     {
436         for (uint i = 0; i < receipents.length; i++) {
437             address receipent = receipents[i];
438             //balances[receipent] = balances[receipent].add(lockedBalances[receipent]);
439             balances[msg.sender] = balances[msg.sender].add(lockedBalances[receipent]);
440             transfer(receipent, lockedBalances[receipent]);
441             lockedBalances[receipent] = 0;
442         }
443     }
444 }
445 
446 // File: contracts/URACCrowdSale.sol
447 
448 /// @title URACCrowdSale Contract
449 /// For more information about this token sale, please visit http://www.uranus.io
450 /// @author reedhong
451 contract URACCrowdSale is Pausable {
452     using SafeMath for uint;
453 
454     /// Constant fields
455     /// URAC total tokens supply
456     uint public constant URAC_TOTAL_SUPPLY = 3500000000 ether;
457     uint public constant MAX_SALE_DURATION = 10 days;
458     uint public constant STAGE_1_TIME =  3 days;
459     uint public constant STAGE_2_TIME = 7 days;
460     uint public constant MIN_LIMIT = 0.1 ether;
461     uint public constant MAX_STAGE_1_LIMIT = 10 ether;
462 
463     //uint public constant STAGE_1 = 1;
464     //uint public constant STAGE_2 = 2;
465     enum STAGE {STAGE_1, STAGE_2}
466 
467     /// Exchange rates
468     uint public  exchangeRate = 6200;
469 
470 
471     uint public constant MINER_STAKE = 4000;    // for minter
472     uint public constant OPEN_SALE_STAKE = 158; // for public
473     uint public constant OTHER_STAKE = 5842;    // for others
474 
475 
476     uint public constant DIVISOR_STAKE = 10000;
477 
478     // max open sale tokens
479     uint public constant MAX_OPEN_SOLD = URAC_TOTAL_SUPPLY * OPEN_SALE_STAKE / DIVISOR_STAKE;
480     uint public constant STAKE_MULTIPLIER = URAC_TOTAL_SUPPLY / DIVISOR_STAKE;
481 
482     /// All deposited ETH will be instantly forwarded to this address.
483     address payable public wallet;
484     address payable public minerAddress;
485     address payable public otherAddress;
486 
487     /// Contribution start time
488     uint public startTime;
489     /// Contribution end time
490     uint public endTime;
491 
492     /// Fields that can be changed by functions
493     /// Accumulator for open sold tokens
494     uint public openSoldTokens;
495     /// ERC20 compilant URAC token contact instance
496     URACToken public uracToken;
497 
498     /// tags show address can join in open sale
499     mapping (address => bool) public fullWhiteList;
500 
501     mapping (address => uint) public firstStageFund;
502  
503     /*
504      * EVENTS
505      */
506     event NewSale(address indexed destAddress, uint ethCost, uint gotTokens);
507     event NewWallet(address onwer, address oldWallet, address newWallet);
508 
509     modifier notEarlierThan(uint x) {
510         require(now >= x);
511         _;
512     }
513 
514     modifier earlierThan(uint x) {
515         require(now < x);
516         _;
517     }
518 
519     modifier ceilingNotReached() {
520         require(openSoldTokens < MAX_OPEN_SOLD);
521         _;
522     }
523 
524     modifier isSaleEnded() {
525         require(now > endTime || openSoldTokens >= MAX_OPEN_SOLD);
526         _;
527     }
528 
529     modifier validAddress( address addr ) {
530         require(addr != address(0x0));
531         require(addr != address(this));
532         _;
533     }
534 
535     constructor (
536         address payable _wallet,
537         address payable _minerAddress,
538         address payable _otherAddress
539         ) public
540         validAddress(_wallet)
541         validAddress(_minerAddress)
542         validAddress(_otherAddress)
543         {
544         paused = true;
545         wallet = _wallet;
546         minerAddress = _minerAddress;
547         otherAddress = _otherAddress;
548 
549         openSoldTokens = 0;
550         /// Create urac token contract instance
551         uracToken = new URACToken(address(this), msg.sender, URAC_TOTAL_SUPPLY);
552 
553         uracToken.mint(minerAddress, MINER_STAKE * STAKE_MULTIPLIER, false);
554         uracToken.mint(otherAddress, OTHER_STAKE * STAKE_MULTIPLIER, false);
555     }
556 
557     function setExchangeRate(uint256 rate)
558         public
559         onlyOwner
560         earlierThan(endTime)
561     {
562         exchangeRate = rate;
563     }
564 
565     function setStartTime(uint _startTime )
566         public
567         onlyOwner
568     {
569         startTime = _startTime;
570         endTime = startTime + MAX_SALE_DURATION;
571     }
572 
573     /// @dev batch set quota for user admin
574     /// if openTag <=0, removed
575     function setWhiteList(address[] calldata users, bool openTag)
576         external
577         onlyOwner
578         earlierThan(endTime)
579     {
580         require(saleNotEnd());
581         for (uint i = 0; i < users.length; i++) {
582             fullWhiteList[users[i]] = openTag;
583         }
584     }
585 
586 
587     /// @dev batch set quota for early user quota
588     /// if openTag <=0, removed
589     function addWhiteList(address user, bool openTag)
590         external
591         onlyOwner
592         earlierThan(endTime)
593     {
594         require(saleNotEnd());
595         fullWhiteList[user] = openTag;
596 
597     }
598 
599     /// @dev Emergency situation
600     function setWallet(address payable newAddress)  external onlyOwner {
601         emit NewWallet(owner, wallet, newAddress);
602         wallet = newAddress;
603     }
604 
605     /// @return true if sale not ended, false otherwise.
606     function saleNotEnd() view internal returns (bool) {
607         return now < endTime && openSoldTokens < MAX_OPEN_SOLD;
608     }
609 
610     /**
611      * Fallback function
612      *
613      * @dev If anybody sends Ether directly to this  contract, consider he is getting URAC token
614      */
615     function ()external payable {
616         buyURAC(msg.sender);
617     }
618 
619     /*
620      * PUBLIC FUNCTIONS
621      */
622     /// @dev Exchange msg.value ether to URAC for account recepient
623     /// @param receipient URAC tokens receiver
624     function buyURAC(address receipient)
625         internal
626         whenNotPaused
627         ceilingNotReached
628         notEarlierThan(startTime)
629         earlierThan(endTime)
630         validAddress(receipient)
631         returns (bool)
632     {
633         // Do not allow contracts to game the system
634         require(!isContract(msg.sender));
635         require(tx.gasprice <= 100000000000 wei);
636         require(msg.value >= MIN_LIMIT);
637 
638         bool inWhiteListTag = fullWhiteList[receipient];
639         require(inWhiteListTag == true);
640 
641         STAGE stage = STAGE.STAGE_2;
642         if ( startTime <= now && now < startTime + STAGE_1_TIME ) {
643             stage = STAGE.STAGE_1;
644             require(msg.value <= MAX_STAGE_1_LIMIT);
645             uint fund1 = firstStageFund[receipient];
646             require (fund1 < MAX_STAGE_1_LIMIT );
647         }
648 
649         doBuy(receipient, stage);
650 
651         return true;
652     }
653 
654 
655     /// @dev Buy URAC token normally
656     function doBuy(address receipient, STAGE stage) internal {
657         // protect partner quota in stage one
658         uint value = msg.value;
659 
660         if ( stage == STAGE.STAGE_1 ) {
661             uint fund1 = firstStageFund[receipient];
662             fund1 = fund1.add(value);
663             if (fund1 > MAX_STAGE_1_LIMIT ) {
664                 uint refund1 = fund1.sub(MAX_STAGE_1_LIMIT);
665                 value = value.sub(refund1);
666                 msg.sender.transfer(refund1);
667             }
668         }
669 
670         uint tokenAvailable = MAX_OPEN_SOLD.sub(openSoldTokens);
671         require(tokenAvailable > 0);
672         uint toFund;
673         uint toCollect;
674         (toFund, toCollect) = costAndBuyTokens(tokenAvailable, value);
675         if (toFund > 0) {
676             require(uracToken.mint(receipient, toCollect, true));
677             wallet.transfer(toFund);
678             openSoldTokens = openSoldTokens.add(toCollect);
679             emit NewSale(receipient, toFund, toCollect);
680         }
681 
682         // not enough token sale, just return eth
683         uint toReturn = value.sub(toFund);
684         if (toReturn > 0) {
685             msg.sender.transfer(toReturn);
686         }
687 
688         if ( stage == STAGE.STAGE_1 ) {
689             firstStageFund[receipient] = firstStageFund[receipient].add(toFund);
690         }
691     }
692 
693     /// @dev Utility function for calculate available tokens and cost ethers
694     function costAndBuyTokens(uint availableToken, uint value) view internal returns (uint costValue, uint getTokens) {
695         // all conditions has checked in the caller functions
696         getTokens = exchangeRate * value;
697 
698         if (availableToken >= getTokens) {
699             costValue = value;
700         } else {
701             costValue = availableToken / exchangeRate;
702             getTokens = availableToken;
703         }
704     }
705 
706     /// @dev Internal function to determine if an address is a contract
707     /// @param _addr The address being queried
708     /// @return True if `_addr` is a contract
709     function isContract(address payable _addr) view internal returns(bool) {
710         uint size;
711         if (_addr == 0x0000000000000000000000000000000000000000) {
712             return false;
713         }
714 
715         assembly {
716             size := extcodesize(_addr)
717         }
718         return size > 0;
719     }
720 }