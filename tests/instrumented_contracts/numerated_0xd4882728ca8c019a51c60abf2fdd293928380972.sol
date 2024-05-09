1 pragma solidity ^0.4.18;
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
21   function Ownable() public {
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
41     OwnershipTransferred(owner, newOwner);
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
81     Pause();
82   }
83 
84   /**
85    * @dev called by the owner to unpause, returns to normal state
86    */
87   function unpause() onlyOwner whenPaused public {
88     paused = false;
89     Unpause();
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
165     Transfer(msg.sender, _to, _value);
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
221     Transfer(_from, _to, _value);
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
237     Approval(msg.sender, _spender, _value);
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
263     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
284     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
321 // File: contracts/SeeleToken.sol
322 
323 /// @title SeeleToken Contract
324 /// For more information about this token sale, please visit https://seele.pro
325 /// @author reedhong
326 contract SeeleToken is PausableToken {
327     using SafeMath for uint;
328 
329     /// Constant token specific fields
330     string public constant name = "SeeleToken";
331     string public constant symbol = "Seele";
332     uint public constant decimals = 18;
333 
334     /// seele total tokens supply
335     uint public currentSupply;
336 
337     /// Fields that are only changed in constructor
338     /// seele sale  contract
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
374      * @dev Initialize the Seele Token
375      * @param _minter The SeeleCrowdSale Contract 
376      * @param _maxTotalSupply total supply token    
377      */
378     function SeeleToken(address _minter, address _admin, uint _maxTotalSupply) 
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
389     /**
390      * EXTERNAL FUNCTION 
391      * 
392      * @dev SeeleCrowdSale contract instance mint token
393      * @param receipent The destination account owned mint tokens    
394      * @param amount The amount of mint token
395      * @param isLock Lock token flag
396      * be sent to this address.
397      */
398 
399     function mint(address receipent, uint amount, bool isLock)
400         external
401         onlyMinter
402         maxTokenAmountNotReached(amount)
403         returns (bool)
404     {
405         if (isLock ) {
406             lockedBalances[receipent] = lockedBalances[receipent].add(amount);
407         } else {
408             balances[receipent] = balances[receipent].add(amount);
409         }
410         currentSupply = currentSupply.add(amount);
411         return true;
412     }
413 
414 
415     function setClaimedFlag(bool flag) 
416         public
417         onlyOwner 
418     {
419         claimedFlag = flag;
420     }
421 
422      /*
423      * PUBLIC FUNCTIONS
424      */
425 
426     /// @dev Locking period has passed - Locked tokens have turned into tradeable
427     function claimTokens(address[] receipents)
428         public
429         canClaimed
430     {        
431         for (uint i = 0; i < receipents.length; i++) {
432             address receipent = receipents[i];
433             balances[receipent] = balances[receipent].add(lockedBalances[receipent]);
434             lockedBalances[receipent] = 0;
435         }
436     }
437 }
438 
439 // File: contracts/SeeleCrowdSale.sol
440 
441 /// @title SeeleCrowdSale Contract
442 /// For more information about this token sale, please visit https://seele.pro
443 /// @author reedhong
444 contract SeeleCrowdSale is Pausable {
445     using SafeMath for uint;
446 
447     /// Constant fields
448     /// seele total tokens supply
449     uint public constant SEELE_TOTAL_SUPPLY = 1000000000 ether;
450     uint public constant MAX_SALE_DURATION = 4 days;
451     uint public constant STAGE_1_TIME =  6 hours;
452     uint public constant STAGE_2_TIME = 12 hours;
453     uint public constant MIN_LIMIT = 0.1 ether;
454     uint public constant MAX_STAGE_1_LIMIT = 1 ether;
455     uint public constant MAX_STAGE_2_LIMIT = 2 ether;
456 
457     uint public constant STAGE_1 = 1;
458     uint public constant STAGE_2 = 2;
459     uint public constant STAGE_3 = 3;
460 
461 
462     /// Exchange rates
463     uint public  exchangeRate = 12500;
464 
465 
466     uint public constant MINER_STAKE = 3000;    // for minter
467     uint public constant OPEN_SALE_STAKE = 625; // for public
468     uint public constant OTHER_STAKE = 6375;    // for others
469 
470     
471     uint public constant DIVISOR_STAKE = 10000;
472 
473     // max open sale tokens
474     uint public constant MAX_OPEN_SOLD = SEELE_TOTAL_SUPPLY * OPEN_SALE_STAKE / DIVISOR_STAKE;
475     uint public constant STAKE_MULTIPLIER = SEELE_TOTAL_SUPPLY / DIVISOR_STAKE;
476 
477     /// All deposited ETH will be instantly forwarded to this address.
478     address public wallet;
479     address public minerAddress;
480     address public otherAddress;
481 
482     /// Contribution start time
483     uint public startTime;
484     /// Contribution end time
485     uint public endTime;
486 
487     /// Fields that can be changed by functions
488     /// Accumulator for open sold tokens
489     uint public openSoldTokens;
490     /// ERC20 compilant seele token contact instance
491     SeeleToken public seeleToken; 
492 
493     /// tags show address can join in open sale
494     mapping (address => bool) public fullWhiteList;
495 
496     mapping (address => uint) public firstStageFund;
497     mapping (address => uint) public secondStageFund;
498 
499     /*
500      * EVENTS
501      */
502     event NewSale(address indexed destAddress, uint ethCost, uint gotTokens);
503     event NewWallet(address onwer, address oldWallet, address newWallet);
504 
505     modifier notEarlierThan(uint x) {
506         require(now >= x);
507         _;
508     }
509 
510     modifier earlierThan(uint x) {
511         require(now < x);
512         _;
513     }
514 
515     modifier ceilingNotReached() {
516         require(openSoldTokens < MAX_OPEN_SOLD);
517         _;
518     }  
519 
520     modifier isSaleEnded() {
521         require(now > endTime || openSoldTokens >= MAX_OPEN_SOLD);
522         _;
523     }
524 
525     modifier validAddress( address addr ) {
526         require(addr != address(0x0));
527         require(addr != address(this));
528         _;
529     }
530 
531     function SeeleCrowdSale (
532         address _wallet, 
533         address _minerAddress,
534         address _otherAddress
535         ) public 
536         validAddress(_wallet) 
537         validAddress(_minerAddress) 
538         validAddress(_otherAddress) 
539         {
540         paused = true;  
541         wallet = _wallet;
542         minerAddress = _minerAddress;
543         otherAddress = _otherAddress;     
544 
545         openSoldTokens = 0;
546         /// Create seele token contract instance
547         seeleToken = new SeeleToken(this, msg.sender, SEELE_TOTAL_SUPPLY);
548 
549         seeleToken.mint(minerAddress, MINER_STAKE * STAKE_MULTIPLIER, false);
550         seeleToken.mint(otherAddress, OTHER_STAKE * STAKE_MULTIPLIER, false);
551     }
552 
553     function setExchangeRate(uint256 rate)
554         public
555         onlyOwner
556         earlierThan(endTime)
557     {
558         exchangeRate = rate;
559     }
560 
561     function setStartTime(uint _startTime )
562         public
563         onlyOwner
564     {
565         startTime = _startTime;
566         endTime = startTime + MAX_SALE_DURATION;
567     }
568 
569     /// @dev batch set quota for user admin
570     /// if openTag <=0, removed 
571     function setWhiteList(address[] users, bool openTag)
572         external
573         onlyOwner
574         earlierThan(endTime)
575     {
576         require(saleNotEnd());
577         for (uint i = 0; i < users.length; i++) {
578             fullWhiteList[users[i]] = openTag;
579         }
580     }
581 
582 
583     /// @dev batch set quota for early user quota
584     /// if openTag <=0, removed 
585     function addWhiteList(address user, bool openTag)
586         external
587         onlyOwner
588         earlierThan(endTime)
589     {
590         require(saleNotEnd());
591         fullWhiteList[user] = openTag;
592 
593     }
594 
595     /// @dev Emergency situation
596     function setWallet(address newAddress)  external onlyOwner { 
597         NewWallet(owner, wallet, newAddress);
598         wallet = newAddress; 
599     }
600 
601     /// @return true if sale not ended, false otherwise.
602     function saleNotEnd() constant internal returns (bool) {
603         return now < endTime && openSoldTokens < MAX_OPEN_SOLD;
604     }
605 
606     /**
607      * Fallback function 
608      * 
609      * @dev If anybody sends Ether directly to this  contract, consider he is getting seele token
610      */
611     function () public payable {
612         buySeele(msg.sender);
613     }
614 
615     /*
616      * PUBLIC FUNCTIONS
617      */
618     /// @dev Exchange msg.value ether to Seele for account recepient
619     /// @param receipient Seele tokens receiver
620     function buySeele(address receipient) 
621         internal 
622         whenNotPaused  
623         ceilingNotReached 
624         notEarlierThan(startTime)
625         earlierThan(endTime)
626         validAddress(receipient)
627         returns (bool) 
628     {
629         // Do not allow contracts to game the system
630         require(!isContract(msg.sender));    
631         require(tx.gasprice <= 100000000000 wei);
632         require(msg.value >= MIN_LIMIT);
633 
634         bool inWhiteListTag = fullWhiteList[receipient];       
635         require(inWhiteListTag == true);
636 
637         uint stage = STAGE_3;
638         if ( startTime <= now && now < startTime + STAGE_1_TIME ) {
639             stage = STAGE_1;
640             require(msg.value <= MAX_STAGE_1_LIMIT);
641             uint fund1 = firstStageFund[receipient];
642             require (fund1 < MAX_STAGE_1_LIMIT );
643         }else if ( startTime + STAGE_1_TIME <= now && now < startTime + STAGE_2_TIME ) {
644             stage = STAGE_2;
645             require(msg.value <= MAX_STAGE_2_LIMIT);
646             uint fund2 = secondStageFund[receipient];
647             require (fund2 < MAX_STAGE_2_LIMIT );
648         }
649 
650         doBuy(receipient, stage);
651 
652         return true;
653     }
654 
655 
656     /// @dev Buy seele token normally
657     function doBuy(address receipient, uint stage) internal {
658         // protect partner quota in stage one
659         uint value = msg.value;
660 
661         if ( stage == STAGE_1 ) {
662             uint fund1 = firstStageFund[receipient];
663             fund1 = fund1.add(value);
664             if (fund1 > MAX_STAGE_1_LIMIT ) {
665                 uint refund1 = fund1.sub(MAX_STAGE_1_LIMIT);
666                 value = value.sub(refund1);
667                 msg.sender.transfer(refund1);
668             }
669         }else if ( stage == STAGE_2 ) {
670             uint fund2 = secondStageFund[receipient];
671             fund2 = fund2.add(value);
672             if (fund2 > MAX_STAGE_2_LIMIT) {
673                 uint refund2 = fund2.sub(MAX_STAGE_2_LIMIT);
674                 value = value.sub(refund2);
675                 msg.sender.transfer(refund2);
676             }            
677         }
678 
679         uint tokenAvailable = MAX_OPEN_SOLD.sub(openSoldTokens);
680         require(tokenAvailable > 0);
681         uint toFund;
682         uint toCollect;
683         (toFund, toCollect) = costAndBuyTokens(tokenAvailable, value);
684         if (toFund > 0) {
685             require(seeleToken.mint(receipient, toCollect,true));         
686             wallet.transfer(toFund);
687             openSoldTokens = openSoldTokens.add(toCollect);
688             NewSale(receipient, toFund, toCollect);             
689         }
690 
691         // not enough token sale, just return eth
692         uint toReturn = value.sub(toFund);
693         if (toReturn > 0) {
694             msg.sender.transfer(toReturn);
695         }
696 
697         if ( stage == STAGE_1 ) {
698             firstStageFund[receipient] = firstStageFund[receipient].add(toFund);
699         }else if ( stage == STAGE_2 ) {
700             secondStageFund[receipient] = secondStageFund[receipient].add(toFund);          
701         }
702     }
703 
704     /// @dev Utility function for calculate available tokens and cost ethers
705     function costAndBuyTokens(uint availableToken, uint value) constant internal returns (uint costValue, uint getTokens) {
706         // all conditions has checked in the caller functions
707         getTokens = exchangeRate * value;
708 
709         if (availableToken >= getTokens) {
710             costValue = value;
711         } else {
712             costValue = availableToken / exchangeRate;
713             getTokens = availableToken;
714         }
715     }
716 
717     /// @dev Internal function to determine if an address is a contract
718     /// @param _addr The address being queried
719     /// @return True if `_addr` is a contract
720     function isContract(address _addr) constant internal returns(bool) {
721         uint size;
722         if (_addr == 0) {
723             return false;
724         }
725 
726         assembly {
727             size := extcodesize(_addr)
728         }
729         return size > 0;
730     }
731 }