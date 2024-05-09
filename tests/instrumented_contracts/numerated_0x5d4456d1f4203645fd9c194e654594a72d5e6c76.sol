1 pragma solidity 0.5.6;
2 
3 
4 
5 /*
6 *  deex.exchange pre-ICO tokens smart contract
7 *  implements [ERC-20 Token Standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md)
8 *
9 *  Style
10 *  1) before start coding, run Python and type 'import this' in Python console.
11 *  2) we avoid using inheritance (contract B is A) as it makes code less clear for observer
12 *  ("Flat is better than nested", "Readability counts")
13 *  3) we avoid using -= ; =- ; +=; =+
14 *  see: https://github.com/ether-camp/virtual-accelerator/issues/8
15 *  https://www.ethnews.com/ethercamps-hkg-token-has-a-bug-and-needs-to-be-reissued
16 *  4) always explicitly mark variables and functions visibility ("Explicit is better than implicit")
17 *  5) every function except constructor should trigger at leas one event.
18 *  6) smart contracts have to be audited and reviewed, comment your code.
19 *
20 *  Code is published on https://github.com/thedeex/thedeex.github.io
21 */
22 
23 
24 /* "Interfaces" */
25 
26 //  this is expected from another contracts
27 //  if it wants to spend tokens of behalf of the token owner in our contract
28 //  this can be used in many situations, for example to convert pre-ICO tokens to ICO tokens
29 //  see 'approveAndCall' function
30 contract allowanceRecipient {
31     function receiveApproval(address _from, uint256 _value, address _inContract, bytes memory _extraData) public returns (bool success);
32 }
33 
34 
35 // see:
36 // https://github.com/ethereum/EIPs/issues/677
37 contract tokenRecipient {
38     function tokenFallback(address _from, uint256 _value, bytes memory _extraData) public returns (bool success);
39 }
40 
41 
42 contract DEEX {
43 
44     // ver. 2.0
45 
46     /* ---------- Variables */
47 
48     /* --- ERC-20 variables */
49 
50     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#name
51     // function name() constant returns (string name)
52     string public name = "deex";
53 
54     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#symbol
55     // function symbol() constant returns (string symbol)
56     string public symbol = "deex";
57 
58     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#decimals
59     // function decimals() constant returns (uint8 decimals)
60     uint8 public decimals = 0;
61 
62     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#totalsupply
63     // function totalSupply() constant returns (uint256 totalSupply)
64     // we start with zero and will create tokens as SC receives ETH
65     uint256 public totalSupply;
66 
67     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#balanceof
68     // function balanceOf(address _owner) constant returns (uint256 balance)
69     mapping (address => uint256) public balanceOf;
70 
71     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#allowance
72     // function allowance(address _owner, address _spender) constant returns (uint256 remaining)
73     mapping (address => mapping (address => uint256)) public allowance;
74 
75     /* ----- For tokens sale */
76 
77     uint256 public salesCounter = 0;
78 
79     uint256 public maxSalesAllowed;
80 
81     bool private transfersBetweenSalesAllowed;
82 
83     // initial value should be changed by the owner
84     uint256 public tokenPriceInWei = 0;
85 
86     uint256 public saleStartUnixTime = 0; // block.timestamp
87     uint256 public saleEndUnixTime = 0;  // block.timestamp
88 
89     /* --- administrative */
90     address public owner;
91 
92     // account that can set prices
93     address public priceSetter;
94 
95     // 0 - not set
96     uint256 private priceMaxWei = 0;
97     // 0 - not set
98     uint256 private priceMinWei = 0;
99 
100     // accounts holding tokens for for the team, for advisers and for the bounty campaign
101     mapping (address => bool) public isPreferredTokensAccount;
102 
103     bool public contractInitialized = false;
104 
105 
106     /* ---------- Constructor */
107     // do not forget about:
108     // https://medium.com/@codetractio/a-look-into-paritys-multisig-wallet-bug-affecting-100-million-in-ether-and-tokens-356f5ba6e90a
109     constructor () public {
110         owner = msg.sender;
111 
112         // for testNet can be more than 2
113         // --------------------------------2------------------------------------------------------change  in production!
114         maxSalesAllowed = 2;
115         //
116         transfersBetweenSalesAllowed = true;
117     }
118 
119 
120     function initContract(address team, address advisers, address bounty) public onlyBy(owner) returns (bool){
121 
122         require(contractInitialized == false);
123         contractInitialized = true;
124 
125         priceSetter = msg.sender;
126 
127         totalSupply = 100000000;
128 
129         // tokens for sale go SC own account
130         balanceOf[address(this)] = 75000000;
131 
132         // for the team
133         balanceOf[team] = balanceOf[team] + 15000000;
134         isPreferredTokensAccount[team] = true;
135 
136         // for advisers
137         balanceOf[advisers] = balanceOf[advisers] + 7000000;
138         isPreferredTokensAccount[advisers] = true;
139 
140         // for the bounty campaign
141         balanceOf[bounty] = balanceOf[bounty] + 3000000;
142         isPreferredTokensAccount[bounty] = true;
143 
144     }
145 
146     /* ---------- Events */
147 
148     /* --- ERC-20 events */
149     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#events
150 
151     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer-1
152     event Transfer(address indexed from, address indexed to, uint256 value);
153 
154     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approval
155     event Approval(address indexed _owner, address indexed spender, uint256 value);
156 
157     /* --- Administrative events:  */
158     event OwnerChanged(address indexed oldOwner, address indexed newOwner);
159 
160     /* ---- Tokens creation and sale events  */
161 
162     event PriceChanged(uint256 indexed newTokenPriceInWei);
163 
164     event SaleStarted(uint256 startUnixTime, uint256 endUnixTime, uint256 indexed saleNumber);
165 
166     event NewTokensSold(uint256 numberOfTokens, address indexed purchasedBy, uint256 indexed priceInWei);
167 
168     event Withdrawal(address indexed to, uint sumInWei);
169 
170     /* --- Interaction with other contracts events  */
171     event DataSentToAnotherContract(address indexed _from, address indexed _toContract, bytes _extraData);
172 
173     /* ---------- Functions */
174 
175     /* --- Modifiers  */
176     modifier onlyBy(address _account){
177         require(msg.sender == _account);
178 
179         _;
180     }
181 
182     /* --- ERC-20 Functions */
183     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#methods
184 
185     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer
186     function transfer(address _to, uint256 _value) public returns (bool){
187         return transferFrom(msg.sender, _to, _value);
188     }
189 
190     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transferfrom
191     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
192 
193         // transfers are possible only after sale is finished
194         // except for manager and preferred accounts
195 
196         bool saleFinished = saleIsFinished();
197         require(saleFinished || msg.sender == owner || isPreferredTokensAccount[msg.sender]);
198 
199         // transfers can be forbidden until final ICO is finished
200         // except for manager and preferred accounts
201         require(transfersBetweenSalesAllowed || salesCounter == maxSalesAllowed || msg.sender == owner || isPreferredTokensAccount[msg.sender]);
202 
203         // Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event (ERC-20)
204         require(_value >= 0);
205 
206         // The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism
207         require(msg.sender == _from || _value <= allowance[_from][msg.sender]);
208 
209         // check if _from account have required amount
210         require(_value <= balanceOf[_from]);
211 
212         // Subtract from the sender
213         balanceOf[_from] = balanceOf[_from] - _value;
214         //
215         // Add the same to the recipient
216         balanceOf[_to] = balanceOf[_to] + _value;
217 
218         // If allowance used, change allowances correspondingly
219         if (_from != msg.sender) {
220             allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value;
221         }
222 
223         // event
224         emit Transfer(_from, _to, _value);
225 
226         return true;
227     }
228 
229     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve
230     // there is and attack, see:
231     // https://github.com/CORIONplatform/solidity/issues/6,
232     // https://drive.google.com/file/d/0ByMtMw2hul0EN3NCaVFHSFdxRzA/view
233     // but this function is required by ERC-20
234     function approve(address _spender, uint256 _value) public returns (bool success){
235 
236         require(_value >= 0);
237 
238         allowance[msg.sender][_spender] = _value;
239 
240         // event
241         emit Approval(msg.sender, _spender, _value);
242 
243         return true;
244     }
245 
246     /*  ---------- Interaction with other contracts  */
247 
248     /* User can allow another smart contract to spend some shares in his behalf
249     *  (this function should be called by user itself)
250     *  @param _spender another contract's address
251     *  @param _value number of tokens
252     *  @param _extraData Data that can be sent from user to another contract to be processed
253     *  bytes - dynamically-sized byte array,
254     *  see http://solidity.readthedocs.io/en/v0.4.15/types.html#dynamically-sized-byte-array
255     *  see possible attack information in comments to function 'approve'
256     *  > this may be used to convert pre-ICO tokens to ICO tokens
257     */
258     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
259 
260         approve(_spender, _value);
261 
262         // 'spender' is another contract that implements code as prescribed in 'allowanceRecipient' above
263         allowanceRecipient spender = allowanceRecipient(_spender);
264 
265         // our contract calls 'receiveApproval' function of another contract ('allowanceRecipient') to send information about
266         // allowance and data sent by user
267         // 'this' is this (our) contract address
268         if (spender.receiveApproval(msg.sender, _value, address(this), _extraData)) {
269             emit DataSentToAnotherContract(msg.sender, _spender, _extraData);
270             return true;
271         }
272         else return false;
273     }
274 
275     function approveAllAndCall(address _spender, bytes memory _extraData) public returns (bool success) {
276         return approveAndCall(_spender, balanceOf[msg.sender], _extraData);
277     }
278 
279     /* https://github.com/ethereum/EIPs/issues/677
280     * transfer tokens with additional info to another smart contract, and calls its correspondent function
281     * @param address _to - another smart contract address
282     * @param uint256 _value - number of tokens
283     * @param bytes _extraData - data to send to another contract
284     * > this may be used to convert pre-ICO tokens to ICO tokens
285     */
286     function transferAndCall(address _to, uint256 _value, bytes memory _extraData) public returns (bool success){
287 
288         transferFrom(msg.sender, _to, _value);
289 
290         tokenRecipient receiver = tokenRecipient(_to);
291 
292         if (receiver.tokenFallback(msg.sender, _value, _extraData)) {
293             emit DataSentToAnotherContract(msg.sender, _to, _extraData);
294             return true;
295         }
296         else return false;
297     }
298 
299     // for example for conveting ALL tokens of user account to another tokens
300     function transferAllAndCall(address _to, bytes memory _extraData) public returns (bool success){
301         return transferAndCall(_to, balanceOf[msg.sender], _extraData);
302     }
303 
304     /* --- Administrative functions */
305 
306     function changeOwner(address _newOwner) public onlyBy(owner) returns (bool success){
307         //
308         require(_newOwner != address(0));
309 
310         address oldOwner = owner;
311         owner = _newOwner;
312 
313         emit OwnerChanged(oldOwner, _newOwner);
314 
315         return true;
316     }
317 
318     /* ---------- Create and sell tokens  */
319 
320     /* set time for start and time for end pre-ICO
321     * time is integer representing block timestamp
322     * in UNIX Time,
323     * see: https://www.epochconverter.com
324     * @param uint256 startTime - time to start
325     * @param uint256 endTime - time to end
326     * should be taken into account that
327     * "block.timestamp" can be influenced by miners to a certain degree.
328     * That means that a miner can "choose" the block.timestamp, to a certain degree,
329     * to change the outcome of a transaction in the mined block.
330     * see:
331     * http://solidity.readthedocs.io/en/v0.4.15/frequently-asked-questions.html#are-timestamps-now-block-timestamp-reliable
332     */
333 
334     function startSale(uint256 _startUnixTime, uint256 _endUnixTime) public onlyBy(owner) returns (bool success){
335 
336         require(balanceOf[address(this)] > 0);
337         require(salesCounter < maxSalesAllowed);
338 
339         // time for sale can be set only if:
340         // this is first sale (saleStartUnixTime == 0 && saleEndUnixTime == 0) , or:
341         // previous sale finished ( saleIsFinished() )
342         require(
343             (saleStartUnixTime == 0 && saleEndUnixTime == 0) || saleIsFinished()
344         );
345         // time can be set only for future
346         require(_startUnixTime > now && _endUnixTime > now);
347         // end time should be later than start time
348         require(_endUnixTime - _startUnixTime > 0);
349 
350         saleStartUnixTime = _startUnixTime;
351         saleEndUnixTime = _endUnixTime;
352         salesCounter = salesCounter + 1;
353 
354         emit SaleStarted(_startUnixTime, _endUnixTime, salesCounter);
355 
356         return true;
357     }
358 
359     function saleIsRunning() public view returns (bool){
360 
361         if (balanceOf[address(this)] == 0) {
362             return false;
363         }
364 
365         if (saleStartUnixTime == 0 && saleEndUnixTime == 0) {
366             return false;
367         }
368 
369         if (now > saleStartUnixTime && now < saleEndUnixTime) {
370             return true;
371         }
372 
373         return false;
374     }
375 
376     function saleIsFinished() public view returns (bool){
377 
378         if (balanceOf[address(this)] == 0) {
379             return true;
380         }
381 
382         else if (
383             (saleStartUnixTime > 0 && saleEndUnixTime > 0)
384             && now > saleEndUnixTime) {
385 
386             return true;
387         }
388 
389         // <<<
390         return true;
391     }
392 
393     function changePriceSetter(address _priceSetter) public onlyBy(owner) returns (bool success) {
394         priceSetter = _priceSetter;
395         return true;
396     }
397 
398     function setMinMaxPriceInWei(uint256 _priceMinWei, uint256 _priceMaxWei) public onlyBy(owner) returns (bool success){
399         require(_priceMinWei >= 0 && _priceMaxWei >= 0);
400         priceMinWei = _priceMinWei;
401         priceMaxWei = _priceMaxWei;
402         return true;
403     }
404 
405 
406     function setTokenPriceInWei(uint256 _priceInWei) public onlyBy(priceSetter) returns (bool success){
407 
408         require(_priceInWei >= 0);
409 
410         // if 0 - not set
411         if (priceMinWei != 0 && _priceInWei < priceMinWei) {
412             tokenPriceInWei = priceMinWei;
413         }
414         else if (priceMaxWei != 0 && _priceInWei > priceMaxWei) {
415             tokenPriceInWei = priceMaxWei;
416         }
417         else {
418             tokenPriceInWei = _priceInWei;
419         }
420 
421         emit PriceChanged(tokenPriceInWei);
422 
423         return true;
424     }
425 
426     // allows sending ether and receiving tokens just using contract address
427     // warning:
428     // 'If the fallback function requires more than 2300 gas, the contract cannot receive Ether'
429     // see:
430     // https://ethereum.stackexchange.com/questions/21643/fallback-function-best-practices-when-registering-information
431     function() external payable {
432         buyTokens();
433     }
434 
435     //
436     function buyTokens() public payable returns (bool success){
437 
438         if (saleIsRunning() && tokenPriceInWei > 0) {
439 
440             uint256 numberOfTokens = msg.value / tokenPriceInWei;
441 
442             if (numberOfTokens <= balanceOf[address(this)]) {
443 
444                 balanceOf[msg.sender] = balanceOf[msg.sender] + numberOfTokens;
445                 balanceOf[address(this)] = balanceOf[address(this)] - numberOfTokens;
446 
447                 emit NewTokensSold(numberOfTokens, msg.sender, tokenPriceInWei);
448 
449                 return true;
450             }
451             else {
452                 // (payable)
453                 revert();
454             }
455         }
456         else {
457             // (payable)
458             revert();
459         }
460     }
461 
462     /*  After sale contract owner
463     *  (can be another contract or account)
464     *  can withdraw all collected Ether
465     */
466     function withdrawAllToOwner() public onlyBy(owner) returns (bool) {
467 
468         // only after sale is finished:
469         require(saleIsFinished());
470         uint256 sumInWei = address(this).balance;
471 
472         if (
473         // makes withdrawal and returns true or false
474             !msg.sender.send(address(this).balance)
475         ) {
476             return false;
477         }
478         else {
479             // event
480             emit Withdrawal(msg.sender, sumInWei);
481             return true;
482         }
483     }
484 
485     /* ---------- Referral System */
486 
487     // list of registered referrers
488     // represented by keccak256(address) (returns bytes32)
489     // ! referrers can not be removed !
490     mapping (bytes32 => bool) private isReferrer;
491 
492     uint256 private referralBonus = 0;
493 
494     uint256 private referrerBonus = 0;
495     // tokens owned by referrers:
496     mapping (bytes32 => uint256) public referrerBalanceOf;
497 
498     mapping (bytes32 => uint) public referrerLinkedSales;
499 
500     function addReferrer(bytes32 _referrer) public onlyBy(owner) returns (bool success){
501         isReferrer[_referrer] = true;
502         return true;
503     }
504 
505     function removeReferrer(bytes32 _referrer) public onlyBy(owner) returns (bool success){
506         isReferrer[_referrer] = false;
507         return true;
508     }
509 
510     // bonuses are set in as integers (20%, 30%), initial 0%
511     function setReferralBonuses(uint256 _referralBonus, uint256 _referrerBonus) public onlyBy(owner) returns (bool success){
512         require(_referralBonus > 0 && _referrerBonus > 0);
513         referralBonus = _referralBonus;
514         referrerBonus = _referrerBonus;
515         return true;
516     }
517 
518     function buyTokensWithReferrerAddress(address _referrer) public payable returns (bool success){
519 
520         bytes32 referrer = keccak256(abi.encodePacked(_referrer));
521 
522         if (saleIsRunning() && tokenPriceInWei > 0) {
523 
524             if (isReferrer[referrer]) {
525 
526                 uint256 numberOfTokens = msg.value / tokenPriceInWei;
527 
528                 if (numberOfTokens <= balanceOf[address(this)]) {
529 
530                     referrerLinkedSales[referrer] = referrerLinkedSales[referrer] + numberOfTokens;
531 
532                     uint256 referralBonusTokens = (numberOfTokens * (100 + referralBonus) / 100) - numberOfTokens;
533                     uint256 referrerBonusTokens = (numberOfTokens * (100 + referrerBonus) / 100) - numberOfTokens;
534 
535                     balanceOf[address(this)] = balanceOf[address(this)] - numberOfTokens - referralBonusTokens - referrerBonusTokens;
536 
537                     balanceOf[msg.sender] = balanceOf[msg.sender] + (numberOfTokens + referralBonusTokens);
538 
539                     referrerBalanceOf[referrer] = referrerBalanceOf[referrer] + referrerBonusTokens;
540 
541                     emit NewTokensSold(numberOfTokens + referralBonusTokens, msg.sender, tokenPriceInWei);
542 
543                     return true;
544                 }
545                 else {
546                     // (payable)
547                     revert();
548                 }
549             }
550             else {
551                 // (payable)
552                 buyTokens();
553             }
554         }
555         else {
556             // (payable)
557             revert();
558         }
559     }
560 
561     event ReferrerBonusTokensTaken(address referrer, uint256 bonusTokensValue);
562 
563     function getReferrerBonusTokens() public returns (bool success){
564         require(saleIsFinished());
565         uint256 bonusTokens = referrerBalanceOf[keccak256(abi.encodePacked(msg.sender))];
566         balanceOf[msg.sender] = balanceOf[msg.sender] + bonusTokens;
567         emit ReferrerBonusTokensTaken(msg.sender, bonusTokens);
568         return true;
569     }
570 
571 }
572 
573 /**
574  * @title SafeMath
575  * @dev Unsigned math operations with safety checks that revert on error
576  */
577 library SafeMath {
578     /**
579      * @dev Multiplies two unsigned integers, reverts on overflow.
580      */
581     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
582         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
583         // benefit is lost if 'b' is also tested.
584         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
585         if (a == 0) {
586             return 0;
587         }
588 
589         uint256 c = a * b;
590         require(c / a == b);
591 
592         return c;
593     }
594 
595     /**
596      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
597      */
598     function div(uint256 a, uint256 b) internal pure returns (uint256) {
599         // Solidity only automatically asserts when dividing by 0
600         require(b > 0);
601         uint256 c = a / b;
602         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
603 
604         return c;
605     }
606 
607     /**
608      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
609      */
610     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
611         require(b <= a);
612         uint256 c = a - b;
613 
614         return c;
615     }
616 
617     /**
618      * @dev Adds two unsigned integers, reverts on overflow.
619      */
620     function add(uint256 a, uint256 b) internal pure returns (uint256) {
621         uint256 c = a + b;
622         require(c >= a);
623 
624         return c;
625     }
626 
627     /**
628      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
629      * reverts when dividing by zero.
630      */
631     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
632         require(b != 0);
633         return a % b;
634     }
635 }
636 
637 
638 contract Ownable {
639     address payable public owner;
640     /**
641      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
642      * account.
643      */
644     constructor() public {
645         owner = msg.sender;
646     }
647     /**
648      * @dev Throws if called by any account other than the owner.
649      */
650     modifier onlyOwner() {
651         require(msg.sender == owner);
652         _;
653     }
654     function transferOwnership(address payable newOwner) public onlyOwner {
655         require(newOwner != address(0));
656         owner = newOwner;
657     }
658 }
659 
660 
661 /*
662 * @title Bank
663 * @dev Bank contract which contained all ETH from Dragons and Hamsters teams.
664 * When time in blockchain will be grater then current deadline or last deadline need call getWinner function
665 * then participants able get prizes.
666 *
667 * Last participant(last hero) win 10% from all bank
668 *
669 * - To get prize send 0 ETH to this contract
670 */
671 contract Bank is Ownable {
672 
673     using SafeMath for uint256;
674 
675     mapping (uint256 => mapping (address => uint256)) public depositDragons;
676     mapping (uint256 => mapping (address => uint256)) public depositHamsters;
677 
678     address payable public team = 0x7De1eFb9E5035784FB931433c8a884588929338E;
679 
680     uint256 public currentDeadline;
681     uint256 public currentRound = 1;
682     uint256 public lastDeadline;
683     uint256 public defaultCurrentDeadlineInHours = 24;
684     uint256 public defaultLastDeadlineInHours = 48;
685     uint256 public countOfDragons;
686     uint256 public countOfHamsters;
687     uint256 public totalSupplyOfHamsters;
688     uint256 public totalSupplyOfDragons;
689     uint256 public totalDeexSupplyOfHamsters;
690     uint256 public totalDeexSupplyOfDragons;
691     uint256 public probabilityOfHamsters;
692     uint256 public probabilityOfDragons;
693     address public lastHero;
694     address public lastHeroHistory;
695     uint256 public jackPot;
696     uint256 public winner;
697     uint256 public withdrawn;
698     uint256 public withdrawnDeex;
699     uint256 public remainder;
700     uint256 public remainderDeex;
701     uint256 public rate = 1;
702     uint256 public rateModifier = 0;
703     uint256 public tokenReturn;
704 
705     uint256 public lastTotalSupplyOfHamsters;
706     uint256 public lastTotalSupplyOfDragons;
707     uint256 public lastTotalDeexSupplyOfHamsters;
708     uint256 public lastTotalDeexSupplyOfDragons;
709     uint256 public lastProbabilityOfHamsters;
710     uint256 public lastProbabilityOfDragons;
711     address public lastRoundHero;
712     uint256 public lastJackPot;
713     uint256 public lastWinner;
714     uint256 public lastBalance;
715     uint256 public lastBalanceDeex;
716     uint256 public lastCountOfDragons;
717     uint256 public lastCountOfHamsters;
718     uint256 public lastWithdrawn;
719     uint256 public lastWithdrawnDeex;
720 
721 
722     bool public finished = false;
723 
724     Dragons public DragonsContract;
725     Hamsters public HamstersContract;
726     DEEX public DEEXContract;
727 
728     /**
729     * @dev Setter token rate.
730     * @param _rate this value for change percent relation rate to count of tokens.
731     * @param _rateModifier this value for change math operation under tokens.
732     */
733     function setRateToken(uint256 _rate, uint256 _rateModifier) public onlyOwner returns(uint256){
734         rate = _rate;
735         rateModifier = _rateModifier;
736     }
737 
738     /**
739     * @dev Setter round time.
740     * @param _currentDeadlineInHours this value current deadline in hours.
741     * @param _lastDeadlineInHours this value last deadline in hours.
742     */
743     function _setRoundTime(uint _currentDeadlineInHours, uint _lastDeadlineInHours) internal {
744         defaultCurrentDeadlineInHours = _currentDeadlineInHours;
745         defaultLastDeadlineInHours = _lastDeadlineInHours;
746         currentDeadline = block.timestamp + 60 * 60 * _currentDeadlineInHours;
747         lastDeadline = block.timestamp + 60 * 60 * _lastDeadlineInHours;
748     }
749 
750     /**
751     * @dev Setter round time.
752     * @param _currentDeadlineInHours this value current deadline in hours.
753     * @param _lastDeadlineInHours this value last deadline in hours.
754     */
755     function setRoundTime(uint _currentDeadlineInHours, uint _lastDeadlineInHours) public onlyOwner {
756         _setRoundTime(_currentDeadlineInHours, _lastDeadlineInHours);
757     }
758 
759 
760     /**
761     * @dev Setter the DEEX contract address. Address can be set at once.
762     * @param _DEEXAddress Address of the DEEX contract
763     */
764     function setDEEXAddress(address payable _DEEXAddress) public {
765         require(address(DEEXContract) == address(0x0));
766         DEEXContract = DEEX(_DEEXAddress);
767     }
768 
769     /**
770     * @dev Setter the Dragons contract address. Address can be set at once.
771     * @param _DragonsAddress Address of the Dragons contract
772     */
773     function setDragonsAddress(address payable _DragonsAddress) external {
774         require(address(DragonsContract) == address(0x0));
775         DragonsContract = Dragons(_DragonsAddress);
776     }
777 
778     /**
779     * @dev Setter the Hamsters contract address. Address can be set at once.
780     * @param _HamstersAddress Address of the Hamsters contract
781     */
782     function setHamstersAddress(address payable _HamstersAddress) external {
783         require(address(HamstersContract) == address(0x0));
784         HamstersContract = Hamsters(_HamstersAddress);
785     }
786 
787     /**
788     * @dev Getting time from blockchain for timer
789     */
790     function getNow() view public returns(uint){
791         return block.timestamp;
792     }
793 
794     /**
795     * @dev Getting state of game. True - game continue, False - game stopped
796     */
797     function getState() view public returns(bool) {
798         if (block.timestamp > currentDeadline) {
799             return false;
800         }
801         return true;
802     }
803 
804     /**
805     * @dev Setting info about participant from Dragons or Hamsters contract
806     * @param _lastHero Address of participant
807     * @param _deposit Amount of deposit
808     */
809     function setInfo(address _lastHero, uint256 _deposit) public {
810         require(address(DragonsContract) == msg.sender || address(HamstersContract) == msg.sender);
811 
812         if (address(DragonsContract) == msg.sender) {
813             require(depositHamsters[currentRound][_lastHero] == 0, "You are already in Hamsters team");
814             if (depositDragons[currentRound][_lastHero] == 0)
815                 countOfDragons++;
816             totalSupplyOfDragons = totalSupplyOfDragons.add(_deposit.mul(90).div(100));
817             depositDragons[currentRound][_lastHero] = depositDragons[currentRound][_lastHero].add(_deposit.mul(90).div(100));
818         }
819 
820         if (address(HamstersContract) == msg.sender) {
821             require(depositDragons[currentRound][_lastHero] == 0, "You are already in Dragons team");
822             if (depositHamsters[currentRound][_lastHero] == 0)
823                 countOfHamsters++;
824             totalSupplyOfHamsters = totalSupplyOfHamsters.add(_deposit.mul(90).div(100));
825             depositHamsters[currentRound][_lastHero] = depositHamsters[currentRound][_lastHero].add(_deposit.mul(90).div(100));
826         }
827 
828         lastHero = _lastHero;
829 
830         if (currentDeadline.add(120) <= lastDeadline) {
831             currentDeadline = currentDeadline.add(120);
832         } else {
833             currentDeadline = lastDeadline;
834         }
835 
836         jackPot += _deposit.mul(10).div(100);
837 
838         calculateProbability();
839     }
840 
841     function estimateTokenPercent(uint256 _difference) public view returns(uint256){
842         if (rateModifier == 0) {
843             return _difference.mul(rate);
844         } else {
845             return _difference.div(rate);
846         }
847     }
848 
849     /**
850     * @dev Calculation probability for team's win
851     */
852     function calculateProbability() public {
853         require(winner == 0 && getState());
854 
855         totalDeexSupplyOfHamsters = DEEXContract.balanceOf(address(HamstersContract));
856         totalDeexSupplyOfDragons = DEEXContract.balanceOf(address(DragonsContract));
857         uint256 percent = (totalSupplyOfHamsters.add(totalSupplyOfDragons)).div(100);
858 
859         if (totalDeexSupplyOfHamsters < 1) {
860             totalDeexSupplyOfHamsters = 0;
861         }
862 
863         if (totalDeexSupplyOfDragons < 1) {
864             totalDeexSupplyOfDragons = 0;
865         }
866 
867         if (totalDeexSupplyOfHamsters <= totalDeexSupplyOfDragons) {
868             uint256 difference = totalDeexSupplyOfDragons.sub(totalDeexSupplyOfHamsters).mul(100);
869             probabilityOfDragons = totalSupplyOfDragons.mul(100).div(percent).add(estimateTokenPercent(difference));
870   
871             if (probabilityOfDragons > 8000) {
872                 probabilityOfDragons = 8000;
873             }
874             if (probabilityOfDragons < 2000) {
875                 probabilityOfDragons = 2000;
876             }
877             probabilityOfHamsters = 10000 - probabilityOfDragons;
878         } else {
879             uint256 difference = totalDeexSupplyOfHamsters.sub(totalDeexSupplyOfDragons).mul(100);
880             probabilityOfHamsters = totalSupplyOfHamsters.mul(100).div(percent).add(estimateTokenPercent(difference));
881 
882             if (probabilityOfHamsters > 8000) {
883                 probabilityOfHamsters = 8000;
884             }
885             if (probabilityOfHamsters < 2000) {
886                 probabilityOfHamsters = 2000;
887             }
888             probabilityOfDragons = 10000 - probabilityOfHamsters;
889         }
890 
891         totalDeexSupplyOfHamsters = DEEXContract.balanceOf(address(HamstersContract));
892         totalDeexSupplyOfDragons = DEEXContract.balanceOf(address(DragonsContract));
893     }
894 
895     /**
896     * @dev Getting winner team
897     */
898     function getWinners() public {
899         require(winner == 0 && !getState());
900         uint256 seed1 = address(this).balance;
901         uint256 seed2 = totalSupplyOfHamsters;
902         uint256 seed3 = totalSupplyOfDragons;
903         uint256 seed4 = totalDeexSupplyOfHamsters;
904         uint256 seed5 = totalDeexSupplyOfHamsters;
905         uint256 seed6 = block.difficulty;
906         uint256 seed7 = block.timestamp;
907 
908         bytes32 randomHash = keccak256(abi.encodePacked(seed1, seed2, seed3, seed4, seed5, seed6, seed7));
909         uint randomNumber = uint(randomHash);
910 
911         if (randomNumber == 0){
912             randomNumber = 1;
913         }
914 
915         uint winningNumber = randomNumber % 10000;
916 
917         if (1 <= winningNumber && winningNumber <= probabilityOfDragons){
918             winner = 1;
919         }
920 
921         if (probabilityOfDragons < winningNumber && winningNumber <= 10000){
922             winner = 2;
923         }
924 
925         if (DEEXContract.balanceOf(address(HamstersContract)) > 0)
926             DEEXContract.transferFrom(
927                 address(HamstersContract),
928                 address(this),
929                 DEEXContract.balanceOf(address(HamstersContract))
930             );
931 
932         if (DEEXContract.balanceOf(address(DragonsContract)) > 0)
933             DEEXContract.transferFrom(
934                 address(DragonsContract),
935                 address(this),
936                 DEEXContract.balanceOf(address(DragonsContract))
937             );
938 
939         lastTotalSupplyOfHamsters = totalSupplyOfHamsters;
940         lastTotalSupplyOfDragons = totalSupplyOfDragons;
941         lastTotalDeexSupplyOfDragons = totalDeexSupplyOfDragons;
942         lastTotalDeexSupplyOfHamsters = totalDeexSupplyOfHamsters;
943         lastRoundHero = lastHero;
944         lastJackPot = jackPot;
945         lastWinner = winner;
946         lastCountOfDragons = countOfDragons;
947         lastCountOfHamsters = countOfHamsters;
948         lastWithdrawn = withdrawn;
949         lastWithdrawnDeex = withdrawnDeex;
950 
951         if (lastBalance > lastWithdrawn){
952             remainder = lastBalance.sub(lastWithdrawn);
953            team.transfer(remainder);
954         }
955 
956         lastBalance = lastTotalSupplyOfDragons.add(lastTotalSupplyOfHamsters).add(lastJackPot);
957 
958         if (lastBalanceDeex > lastWithdrawnDeex){
959             remainderDeex = lastBalanceDeex.sub(lastWithdrawnDeex);
960             tokenReturn = (totalDeexSupplyOfDragons.add(totalDeexSupplyOfHamsters)).mul(20).div(100).add(remainderDeex);
961             DEEXContract.transfer(team, tokenReturn);
962         }
963 
964         lastBalanceDeex = DEEXContract.balanceOf(address(this));
965 
966         totalSupplyOfHamsters = 0;
967         totalSupplyOfDragons = 0;
968         totalDeexSupplyOfHamsters = 0;
969         totalDeexSupplyOfDragons = 0;
970         remainder = 0;
971         remainderDeex = 0;
972         jackPot = 0;
973 
974         withdrawn = 0;
975         winner = 0;
976         withdrawnDeex = 0;
977         countOfDragons = 0;
978         countOfHamsters = 0;
979         probabilityOfHamsters = 0;
980         probabilityOfDragons = 0;
981 
982         _setRoundTime(defaultCurrentDeadlineInHours, defaultLastDeadlineInHours);
983         currentRound++;
984     }
985 
986     /**
987     * @dev Payable function for take prize
988     */
989     function () external payable {
990         if (msg.value == 0){
991             require(depositDragons[currentRound - 1][msg.sender] > 0 || depositHamsters[currentRound - 1][msg.sender] > 0);
992 
993             uint payout = 0;
994             uint payoutDeex = 0;
995 
996             if (lastWinner == 1 && depositDragons[currentRound - 1][msg.sender] > 0) {
997                 payout = calculateLastETHPrize(msg.sender);
998             }
999             if (lastWinner == 2 && depositHamsters[currentRound - 1][msg.sender] > 0) {
1000                 payout = calculateLastETHPrize(msg.sender);
1001             }
1002 
1003             if (payout > 0) {
1004                 depositDragons[currentRound - 1][msg.sender] = 0;
1005                 depositHamsters[currentRound - 1][msg.sender] = 0;
1006                 withdrawn = withdrawn.add(payout);
1007                 msg.sender.transfer(payout);
1008             }
1009 
1010             if ((lastWinner == 1 && depositDragons[currentRound - 1][msg.sender] == 0) || (lastWinner == 2 && depositHamsters[currentRound - 1][msg.sender] == 0)) {
1011                 payoutDeex = calculateLastDeexPrize(msg.sender);
1012                 withdrawnDeex = withdrawnDeex.add(payoutDeex);
1013                 DEEXContract.transfer(msg.sender, payoutDeex);
1014             }
1015 
1016             if (msg.sender == lastRoundHero) {
1017                 lastHeroHistory = lastRoundHero;
1018                 lastRoundHero = address(0x0);
1019                 withdrawn = withdrawn.add(lastJackPot);
1020                 msg.sender.transfer(lastJackPot);
1021             }
1022         }
1023     }
1024 
1025     /**
1026     * @dev Getting ETH prize of participant
1027     * @param participant Address of participant
1028     */
1029     function calculateETHPrize(address participant) public view returns(uint) {
1030 
1031         uint payout = 0;
1032         uint256 totalSupply = (totalSupplyOfDragons.add(totalSupplyOfHamsters));
1033 
1034         if (depositDragons[currentRound][participant] > 0) {
1035             payout = totalSupply.mul(depositDragons[currentRound][participant]).div(totalSupplyOfDragons);
1036         }
1037 
1038         if (depositHamsters[currentRound][participant] > 0) {
1039             payout = totalSupply.mul(depositHamsters[currentRound][participant]).div(totalSupplyOfHamsters);
1040         }
1041 
1042         return payout;
1043     }
1044 
1045     /**
1046     * @dev Getting Deex Token prize of participant
1047     * @param participant Address of participant
1048     */
1049     function calculateDeexPrize(address participant) public view returns(uint) {
1050 
1051         uint payout = 0;
1052         uint totalSupply = (totalDeexSupplyOfDragons.add(totalDeexSupplyOfHamsters)).mul(80).div(100);
1053 
1054         if (depositDragons[currentRound][participant] > 0) {
1055             payout = totalSupply.mul(depositDragons[currentRound][participant]).div(totalSupplyOfDragons);
1056         }
1057 
1058         if (depositHamsters[currentRound][participant] > 0) {
1059             payout = totalSupply.mul(depositHamsters[currentRound][participant]).div(totalSupplyOfHamsters);
1060         }
1061 
1062         return payout;
1063     }
1064 
1065     /**
1066     * @dev Getting ETH prize of _lastParticipant
1067     * @param _lastParticipant Address of _lastParticipant
1068     */
1069     function calculateLastETHPrize(address _lastParticipant) public view returns(uint) {
1070 
1071         uint payout = 0;
1072         uint256 totalSupply = (lastTotalSupplyOfDragons.add(lastTotalSupplyOfHamsters));
1073 
1074         if (depositDragons[currentRound - 1][_lastParticipant] > 0) {
1075             payout = totalSupply.mul(depositDragons[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfDragons);
1076         }
1077 
1078         if (depositHamsters[currentRound - 1][_lastParticipant] > 0) {
1079             payout = totalSupply.mul(depositHamsters[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfHamsters);
1080         }
1081 
1082         return payout;
1083     }
1084 
1085     /**
1086     * @dev Getting Deex Token prize of _lastParticipant
1087     * @param _lastParticipant Address of _lastParticipant
1088     */
1089     function calculateLastDeexPrize(address _lastParticipant) public view returns(uint) {
1090 
1091         uint payout = 0;
1092         uint totalSupply = (lastTotalDeexSupplyOfDragons.add(lastTotalDeexSupplyOfHamsters)).mul(80).div(100);
1093 
1094         if (depositDragons[currentRound - 1][_lastParticipant] > 0) {
1095             payout = totalSupply.mul(depositDragons[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfDragons);
1096         }
1097 
1098         if (depositHamsters[currentRound - 1][_lastParticipant] > 0) {
1099             payout = totalSupply.mul(depositHamsters[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfHamsters);
1100         }
1101 
1102         return payout;
1103     }
1104 }
1105 
1106 /**
1107 * @dev Base contract for teams
1108 */
1109 contract CryptoTeam {
1110     using SafeMath for uint256;
1111 
1112     Bank public BankContract;
1113     DEEX public DEEXContract;
1114     address payable public team = 0x7De1eFb9E5035784FB931433c8a884588929338E;
1115 
1116     /**
1117     * @dev Payable function. 10% will send to Developers fund and 90% will send to JackPot contract.
1118     * Also setting info about player.
1119     */
1120     function () external payable {
1121         require(BankContract.getState() && msg.value >= 0.05 ether);
1122 
1123         BankContract.setInfo(msg.sender, msg.value.mul(90).div(100));
1124 
1125         team.transfer(msg.value.mul(10).div(100));
1126 
1127         address(BankContract).transfer(msg.value.mul(90).div(100));
1128     }
1129 }
1130 
1131 /*
1132 * @dev Dragons contract. To play game with Dragons send ETH to this contract
1133 */
1134 contract Dragons is CryptoTeam {
1135     constructor(address payable _bankAddress, address payable _DEEXAddress) public {
1136         BankContract = Bank(_bankAddress);
1137         BankContract.setDragonsAddress(address(this));
1138         DEEXContract = DEEX(_DEEXAddress);
1139         DEEXContract.approve(_bankAddress, 9999999999999999999000000000000000000);
1140     }
1141 }
1142 
1143 /*
1144 * @dev Hamsters contract. To play game with Hamsters send ETH to this contract
1145 */
1146 contract Hamsters is CryptoTeam {
1147     constructor(address payable _bankAddress, address payable _DEEXAddress) public {
1148         BankContract = Bank(_bankAddress);
1149         BankContract.setHamstersAddress(address(this));
1150         DEEXContract = DEEX(_DEEXAddress);
1151         DEEXContract.approve(_bankAddress, 9999999999999999999000000000000000000);
1152     }
1153 }