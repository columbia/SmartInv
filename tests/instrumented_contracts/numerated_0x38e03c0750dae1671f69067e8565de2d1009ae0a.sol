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
386         paused = true;
387         transferOwnership(_admin);
388     }
389 
390     /**
391      * EXTERNAL FUNCTION 
392      * 
393      * @dev SeeleCrowdSale contract instance mint token
394      * @param receipent The destination account owned mint tokens    
395      * @param amount The amount of mint token
396      * @param isLock Lock token flag
397      * be sent to this address.
398      */
399 
400     function mint(address receipent, uint amount, bool isLock)
401         external
402         onlyMinter
403         maxTokenAmountNotReached(amount)
404         returns (bool)
405     {
406         if (isLock ) {
407             lockedBalances[receipent] = lockedBalances[receipent].add(amount);
408         } else {
409             balances[receipent] = balances[receipent].add(amount);
410         }
411         currentSupply = currentSupply.add(amount);
412         return true;
413     }
414 
415 
416     function setClaimedFlag(bool flag) 
417         public
418         onlyOwner 
419     {
420         claimedFlag = flag;
421     }
422 
423      /*
424      * PUBLIC FUNCTIONS
425      */
426 
427     /// @dev Locking period has passed - Locked tokens have turned into tradeable
428     function claimTokens(address[] receipents)
429         external
430         onlyOwner
431         canClaimed
432     {        
433         for (uint i = 0; i < receipents.length; i++) {
434             address receipent = receipents[i];
435             balances[receipent] = balances[receipent].add(lockedBalances[receipent]);
436             lockedBalances[receipent] = 0;
437         }
438     }
439 
440     function airdrop(address[] receipents, uint[] tokens)
441         external
442     {        
443         for (uint i = 0; i < receipents.length; i++) {
444             address receipent = receipents[i];
445             uint token = tokens[i];
446             if(balances[msg.sender] >= token ){
447                 balances[msg.sender] = balances[msg.sender].sub(token);
448                 balances[receipent] = balances[receipent].add(token);
449             }
450         }
451     }
452 }
453 
454 // File: contracts/SeeleCrowdSale.sol
455 
456 /// @title SeeleCrowdSale Contract
457 /// For more information about this token sale, please visit https://seele.pro
458 /// @author reedhong
459 contract SeeleCrowdSale is Pausable {
460     using SafeMath for uint;
461 
462     /// Constant fields
463     /// seele total tokens supply
464     uint public constant SEELE_TOTAL_SUPPLY = 1000000000 ether;
465     uint public constant MAX_SALE_DURATION = 4 days;
466     uint public constant STAGE_1_TIME =  6 hours;
467     uint public constant STAGE_2_TIME = 12 hours;
468     uint public constant MIN_LIMIT = 0.1 ether;
469     uint public constant MAX_STAGE_1_LIMIT = 1 ether;
470     uint public constant MAX_STAGE_2_LIMIT = 2 ether;
471 
472     uint public constant STAGE_1 = 1;
473     uint public constant STAGE_2 = 2;
474     uint public constant STAGE_3 = 3;
475 
476 
477     /// Exchange rates
478     uint public  exchangeRate = 12500;
479 
480 
481     uint public constant MINER_STAKE = 3000;    // for minter
482     uint public constant OPEN_SALE_STAKE = 625; // for public
483     uint public constant OTHER_STAKE = 6375;    // for others
484 
485     
486     uint public constant DIVISOR_STAKE = 10000;
487 
488     // max open sale tokens
489     uint public constant MAX_OPEN_SOLD = SEELE_TOTAL_SUPPLY * OPEN_SALE_STAKE / DIVISOR_STAKE;
490     uint public constant STAKE_MULTIPLIER = SEELE_TOTAL_SUPPLY / DIVISOR_STAKE;
491 
492     /// All deposited ETH will be instantly forwarded to this address.
493     address public wallet;
494     address public minerAddress;
495     address public otherAddress;
496 
497     /// Contribution start time
498     uint public startTime;
499     /// Contribution end time
500     uint public endTime;
501 
502     /// Fields that can be changed by functions
503     /// Accumulator for open sold tokens
504     uint public openSoldTokens;
505     /// ERC20 compilant seele token contact instance
506     SeeleToken public seeleToken; 
507 
508     SeeleToken public oldSeeleToken;
509 
510     /// tags show address can join in open sale
511     mapping (address => bool) public fullWhiteList;
512 
513     mapping (address => bool) public vistFlagList;
514 
515     mapping (address => uint) public firstStageFund;
516     mapping (address => uint) public secondStageFund;
517 
518     /*
519      * EVENTS
520      */
521     event NewSale(address indexed destAddress, uint ethCost, uint gotTokens);
522     event NewWallet(address onwer, address oldWallet, address newWallet);
523 
524     modifier notEarlierThan(uint x) {
525         require(now >= x);
526         _;
527     }
528 
529     modifier earlierThan(uint x) {
530         require(now < x);
531         _;
532     }
533 
534     modifier ceilingNotReached() {
535         require(openSoldTokens < MAX_OPEN_SOLD);
536         _;
537     }  
538 
539     modifier isSaleEnded() {
540         require(now > endTime || openSoldTokens >= MAX_OPEN_SOLD);
541         _;
542     }
543 
544     modifier validAddress( address addr ) {
545         require(addr != address(0x0));
546         require(addr != address(this));
547         _;
548     }
549 
550     function SeeleCrowdSale (
551         address _wallet, 
552         address _minerAddress,
553         address _otherAddress
554         ) public 
555         validAddress(_wallet) 
556         validAddress(_minerAddress) 
557         validAddress(_otherAddress) 
558         {
559         paused = true;  
560         wallet = _wallet;
561         minerAddress = _minerAddress;
562         otherAddress = _otherAddress;     
563 
564         openSoldTokens = 0;
565         /// Create seele token contract instance
566         seeleToken = new SeeleToken(this, msg.sender, SEELE_TOTAL_SUPPLY);
567 
568         seeleToken.mint(minerAddress, MINER_STAKE * STAKE_MULTIPLIER, false);
569         seeleToken.mint(otherAddress, OTHER_STAKE * STAKE_MULTIPLIER, false);
570     }
571 
572     function setOldSeelToken(address addr)
573         public
574         onlyOwner
575     {
576         oldSeeleToken = SeeleToken(addr);
577     }
578 
579     function setExchangeRate(uint256 rate)
580         public
581         onlyOwner
582         earlierThan(endTime)
583     {
584         exchangeRate = rate;
585     }
586 
587     function setStartTime(uint _startTime )
588         public
589         onlyOwner
590     {
591         startTime = _startTime;
592         endTime = startTime + MAX_SALE_DURATION;
593     }
594 
595     /// @dev batch set quota for user admin
596     /// if openTag <=0, removed 
597     function setWhiteList(address[] users, bool openTag)
598         external
599         onlyOwner
600         earlierThan(endTime)
601     {
602         require(saleNotEnd());
603         for (uint i = 0; i < users.length; i++) {
604             address receipient = users[i];
605             bool visitFlag = vistFlagList[receipient];
606             if( openTag == true && visitFlag == false){
607                 uint token = oldSeeleToken.lockedBalances(receipient);
608                 if( token > 0){
609                     seeleToken.mint(receipient, token,true);
610                     openSoldTokens = openSoldTokens.add(token);
611                 }
612                 vistFlagList[receipient] = true;
613             }
614             fullWhiteList[receipient] = openTag;
615         }
616     }
617 
618 
619     /// @dev batch set quota for early user quota
620     /// if openTag <=0, removed 
621     function addWhiteList(address user, bool openTag)
622         external
623         onlyOwner
624         earlierThan(endTime)
625     {
626         require(saleNotEnd());
627         fullWhiteList[user] = openTag;
628 
629     }
630 
631     /// @dev Emergency situation
632     function setWallet(address newAddress)  external onlyOwner { 
633         NewWallet(owner, wallet, newAddress);
634         wallet = newAddress; 
635     }
636 
637     /// @return true if sale not ended, false otherwise.
638     function saleNotEnd() constant internal returns (bool) {
639         return now < endTime && openSoldTokens < MAX_OPEN_SOLD;
640     }
641 
642     /**
643      * Fallback function 
644      * 
645      * @dev If anybody sends Ether directly to this  contract, consider he is getting seele token
646      */
647     function () public payable {
648         buySeele(msg.sender);
649     }
650 
651     /*
652      * PUBLIC FUNCTIONS
653      */
654     /// @dev Exchange msg.value ether to Seele for account recepient
655     /// @param receipient Seele tokens receiver
656     function buySeele(address receipient) 
657         internal 
658         whenNotPaused  
659         ceilingNotReached 
660         notEarlierThan(startTime)
661         earlierThan(endTime)
662         validAddress(receipient)
663         returns (bool) 
664     {
665         // Do not allow contracts to game the system
666         require(!isContract(msg.sender));    
667         require(tx.gasprice <= 100000000000 wei);
668         require(msg.value >= MIN_LIMIT);
669 
670         bool inWhiteListTag = fullWhiteList[receipient];       
671         require(inWhiteListTag == true);
672 
673         uint stage = STAGE_3;
674         if ( startTime <= now && now < startTime + STAGE_1_TIME ) {
675             stage = STAGE_1;
676             require(msg.value <= MAX_STAGE_1_LIMIT);
677             uint fund1 = firstStageFund[receipient];
678             require (fund1 < MAX_STAGE_1_LIMIT );
679         }else if ( startTime + STAGE_1_TIME <= now && now < startTime + STAGE_2_TIME ) {
680             stage = STAGE_2;
681             require(msg.value <= MAX_STAGE_2_LIMIT);
682             uint fund2 = secondStageFund[receipient];
683             require (fund2 < MAX_STAGE_2_LIMIT );
684         }
685 
686         doBuy(receipient, stage);
687 
688         return true;
689     }
690 
691 
692     /// @dev Buy seele token normally
693     function doBuy(address receipient, uint stage) internal {
694         // protect partner quota in stage one
695         uint value = msg.value;
696 
697         if ( stage == STAGE_1 ) {
698             uint fund1 = firstStageFund[receipient];
699             fund1 = fund1.add(value);
700             if (fund1 > MAX_STAGE_1_LIMIT ) {
701                 uint refund1 = fund1.sub(MAX_STAGE_1_LIMIT);
702                 value = value.sub(refund1);
703                 msg.sender.transfer(refund1);
704             }
705         }else if ( stage == STAGE_2 ) {
706             uint fund2 = secondStageFund[receipient];
707             fund2 = fund2.add(value);
708             if (fund2 > MAX_STAGE_2_LIMIT) {
709                 uint refund2 = fund2.sub(MAX_STAGE_2_LIMIT);
710                 value = value.sub(refund2);
711                 msg.sender.transfer(refund2);
712             }            
713         }
714 
715         uint tokenAvailable = MAX_OPEN_SOLD.sub(openSoldTokens);
716         require(tokenAvailable > 0);
717         uint toFund;
718         uint toCollect;
719         (toFund, toCollect) = costAndBuyTokens(tokenAvailable, value);
720         if (toFund > 0) {
721             require(seeleToken.mint(receipient, toCollect,true));         
722             wallet.transfer(toFund);
723             openSoldTokens = openSoldTokens.add(toCollect);
724             NewSale(receipient, toFund, toCollect);             
725         }
726 
727         // not enough token sale, just return eth
728         uint toReturn = value.sub(toFund);
729         if (toReturn > 0) {
730             msg.sender.transfer(toReturn);
731         }
732 
733         if ( stage == STAGE_1 ) {
734             firstStageFund[receipient] = firstStageFund[receipient].add(toFund);
735         }else if ( stage == STAGE_2 ) {
736             secondStageFund[receipient] = secondStageFund[receipient].add(toFund);          
737         }
738     }
739 
740     /// @dev Utility function for calculate available tokens and cost ethers
741     function costAndBuyTokens(uint availableToken, uint value) constant internal returns (uint costValue, uint getTokens) {
742         // all conditions has checked in the caller functions
743         getTokens = exchangeRate * value;
744 
745         if (availableToken >= getTokens) {
746             costValue = value;
747         } else {
748             costValue = availableToken / exchangeRate;
749             getTokens = availableToken;
750         }
751     }
752 
753     /// @dev Internal function to determine if an address is a contract
754     /// @param _addr The address being queried
755     /// @return True if `_addr` is a contract
756     function isContract(address _addr) constant internal returns(bool) {
757         uint size;
758         if (_addr == 0) {
759             return false;
760         }
761 
762         assembly {
763             size := extcodesize(_addr)
764         }
765         return size > 0;
766     }
767 }