1 pragma solidity 0.5.1;
2 
3 /*
4 * @title JackPot
5 * @dev Jackpot contract which contained all ETH from Dragons and Hamsters teams.
6 * When time in blockchain will be grater then current deadline or last deadline need call getWinner function
7 * then participants able get prizes.
8 *
9 * Last participant(last hero) win 10% from all bank
10 *
11 * - To get prize send 0 ETH to this contract
12 */
13 contract JackPot {
14 
15     using SafeMath for uint256;
16 
17     mapping (address => uint256) public depositDragons;
18     mapping (address => uint256) public depositHamsters;
19     uint256 public currentDeadline;
20     uint256 public lastDeadline = 1551978000; //last deadline for game
21     uint256 public countOfDragons;
22     uint256 public countOfHamsters;
23     uint256 public totalSupplyOfHamsters;
24     uint256 public totalSupplyOfDragons;
25     uint256 public totalDEEXSupplyOfHamsters;
26     uint256 public totalDEEXSupplyOfDragons;
27     uint256 public probabilityOfHamsters;
28     uint256 public probabilityOfDragons;
29     address public lastHero;
30     address public lastHeroHistory;
31     uint256 public jackPot;
32     uint256 public winner;
33     bool public finished = false;
34 
35     Dragons public DragonsContract;
36     Hamsters public HamstersContract;
37     DEEX public DEEXContract;
38 
39     /*
40     * @dev Constructor create first deadline
41     */
42     constructor() public {
43         currentDeadline = block.timestamp + 60 * 60 * 24 * 30 ; //days for first deadline
44     }
45 
46     /**
47     * @dev Setter the DEEX Token contract address. Address can be set at once.
48     * @param _DEEXAddress Address of the DEEX Token contract
49     */
50     function setDEEXAddress(address payable _DEEXAddress) public {
51         require(address(DEEXContract) == address(0x0));
52         DEEXContract = DEEX(_DEEXAddress);
53     }
54 
55     /**
56     * @dev Setter the Dragons contract address. Address can be set at once.
57     * @param _dragonsAddress Address of the Dragons contract
58     */
59     function setDragonsAddress(address payable _dragonsAddress) external {
60         require(address(DragonsContract) == address(0x0));
61         DragonsContract = Dragons(_dragonsAddress);
62     }
63 
64     /**
65     * @dev Setter the Hamsters contract address. Address can be set at once.
66     * @param _hamstersAddress Address of the Hamsters contract
67     */
68     function setHamstersAddress(address payable _hamstersAddress) external {
69         require(address(HamstersContract) == address(0x0));
70         HamstersContract = Hamsters(_hamstersAddress);
71     }
72 
73     /**
74     * @dev Getting time from blockchain
75     */
76     function getNow() view public returns(uint){
77         return block.timestamp;
78     }
79 
80     /**
81     * @dev Getting state of game. True - game continue, False - game stopped
82     */
83     function getState() view public returns(bool) {
84         if (block.timestamp > currentDeadline) {
85             return false;
86         }
87         return true;
88     }
89 
90     /**
91     * @dev Setting info about participant from Dragons or Hamsters contract
92     * @param _lastHero Address of participant
93     * @param _deposit Amount of deposit
94     */
95     function setInfo(address _lastHero, uint256 _deposit) public {
96         require(address(DragonsContract) == msg.sender || address(HamstersContract) == msg.sender);
97 
98         if (address(DragonsContract) == msg.sender) {
99             require(depositHamsters[_lastHero] == 0, "You are already in hamsters team");
100             if (depositDragons[_lastHero] == 0)
101                 countOfDragons++;
102             totalSupplyOfDragons = totalSupplyOfDragons.add(_deposit.mul(90).div(100));
103             depositDragons[_lastHero] = depositDragons[_lastHero].add(_deposit.mul(90).div(100));
104         }
105 
106         if (address(HamstersContract) == msg.sender) {
107             require(depositDragons[_lastHero] == 0, "You are already in dragons team");
108             if (depositHamsters[_lastHero] == 0)
109                 countOfHamsters++;
110             totalSupplyOfHamsters = totalSupplyOfHamsters.add(_deposit.mul(90).div(100));
111             depositHamsters[_lastHero] = depositHamsters[_lastHero].add(_deposit.mul(90).div(100));
112         }
113 
114         lastHero = _lastHero;
115 
116         if (currentDeadline.add(120) <= lastDeadline) {
117             currentDeadline = currentDeadline.add(120);
118         } else {
119             currentDeadline = lastDeadline;
120         }
121 
122         jackPot = (address(this).balance.add(_deposit)).mul(10).div(100);
123 
124         calculateProbability();
125     }
126 
127     /**
128     * @dev Calculation probability for team's win
129     */
130     function calculateProbability() public {
131         require(winner == 0 && getState());
132 
133         totalDEEXSupplyOfHamsters = DEEXContract.balanceOf(address(HamstersContract));
134         totalDEEXSupplyOfDragons = DEEXContract.balanceOf(address(DragonsContract));
135         uint256 percent = (totalSupplyOfHamsters.add(totalSupplyOfDragons)).div(100);
136 
137         if (totalDEEXSupplyOfHamsters < 1) {
138             totalDEEXSupplyOfHamsters = 0;
139         }
140 
141         if (totalDEEXSupplyOfDragons < 1) {
142             totalDEEXSupplyOfDragons = 0;
143         }
144 
145         if (totalDEEXSupplyOfHamsters <= totalDEEXSupplyOfDragons) {
146             uint256 difference = (totalDEEXSupplyOfDragons.sub(totalDEEXSupplyOfHamsters)).mul(100);
147             probabilityOfDragons = totalSupplyOfDragons.mul(100).div(percent).add(difference);
148 
149             if (probabilityOfDragons > 8000) {
150                 probabilityOfDragons = 8000;
151             }
152             if (probabilityOfDragons < 2000) {
153                 probabilityOfDragons = 2000;
154             }
155             probabilityOfHamsters = 10000 - probabilityOfDragons;
156         } else {
157             uint256 difference = (totalDEEXSupplyOfHamsters.sub(totalDEEXSupplyOfDragons)).mul(100);
158 
159             probabilityOfHamsters = totalSupplyOfHamsters.mul(100).div(percent).add(difference);
160 
161             if (probabilityOfHamsters > 8000) {
162                 probabilityOfHamsters = 8000;
163             }
164             if (probabilityOfHamsters < 2000) {
165                 probabilityOfHamsters = 2000;
166             }
167             probabilityOfDragons = 10000 - probabilityOfHamsters;
168         }
169 
170         totalDEEXSupplyOfHamsters = DEEXContract.balanceOf(address(HamstersContract));
171         totalDEEXSupplyOfDragons = DEEXContract.balanceOf(address(DragonsContract));
172     }
173 
174     /**
175     * @dev Getting winner team
176     */
177     function getWinners() public {
178         require(winner == 0 && !getState());
179 
180         uint256 seed1 = address(this).balance;
181         uint256 seed2 = totalSupplyOfHamsters;
182         uint256 seed3 = totalSupplyOfDragons;
183         uint256 seed4 = totalDEEXSupplyOfHamsters;
184         uint256 seed5 = totalDEEXSupplyOfHamsters;
185         uint256 seed6 = block.difficulty;
186         uint256 seed7 = block.timestamp;
187 
188         bytes32 randomHash = keccak256(abi.encodePacked(seed1, seed2, seed3, seed4, seed5, seed6, seed7));
189         uint randomNumber = uint(randomHash);
190 
191         if (randomNumber == 0){
192             randomNumber = 1;
193         }
194 
195         uint winningNumber = randomNumber % 10000;
196 
197         if (1 <= winningNumber && winningNumber <= probabilityOfDragons){
198             winner = 1;
199         }
200 
201         if (probabilityOfDragons < winningNumber && winningNumber <= 10000){
202             winner = 2;
203         }
204     }
205 
206     /**
207     * @dev Payable function for take prize
208     */
209     function () external payable {
210         if (msg.value == 0 &&  !getState() && winner > 0){
211             require(depositDragons[msg.sender] > 0 || depositHamsters[msg.sender] > 0);
212 
213             uint payout = 0;
214             uint payoutDEEX = 0;
215 
216             if (winner == 1 && depositDragons[msg.sender] > 0) {
217                 payout = calculateETHPrize(msg.sender);
218             }
219             if (winner == 2 && depositHamsters[msg.sender] > 0) {
220                 payout = calculateETHPrize(msg.sender);
221             }
222 
223             if (payout > 0) {
224                 depositDragons[msg.sender] = 0;
225                 depositHamsters[msg.sender] = 0;
226                 msg.sender.transfer(payout);
227             }
228 
229             if ((winner == 1 && depositDragons[msg.sender] == 0) || (winner == 2 && depositHamsters[msg.sender] == 0)) {
230                 payoutDEEX = calculateDEEXPrize(msg.sender);
231                 if (DEEXContract.balanceOf(address(HamstersContract)) > 0)
232                     DEEXContract.transferFrom(
233                         address(HamstersContract),
234                         address(this),
235                         DEEXContract.balanceOf(address(HamstersContract))
236                     );
237                 if (DEEXContract.balanceOf(address(DragonsContract)) > 0)
238                     DEEXContract.transferFrom(
239                         address(DragonsContract),
240                         address(this),
241                         DEEXContract.balanceOf(address(DragonsContract))
242                     );
243                 if (payoutDEEX > 0){
244                     DEEXContract.transfer(msg.sender, payoutDEEX);
245                 }
246             }
247 
248             if (msg.sender == lastHero) {
249                 lastHeroHistory = lastHero;
250                 lastHero = address(0x0);
251                 msg.sender.transfer(jackPot);
252             }
253         }
254     }
255 
256     /**
257     * @dev Getting ETH prize of participant
258     * @param participant Address of participant
259     */
260     function calculateETHPrize(address participant) public view returns(uint) {
261         uint payout = 0;
262 
263         uint256 totalSupply = totalSupplyOfDragons.add(totalSupplyOfHamsters);
264         if (totalSupply > 0) {
265             if (depositDragons[participant] > 0) {
266                 payout = totalSupply.mul(depositDragons[participant]).div(totalSupplyOfDragons);
267             }
268 
269             if (depositHamsters[participant] > 0) {
270                 payout = totalSupply.mul(depositHamsters[participant]).div(totalSupplyOfHamsters);
271             }
272         }
273         return payout;
274     }
275 
276     /**
277     * @dev Getting DEEX Token prize of participant
278     * @param participant Address of participant
279     */
280     function calculateDEEXPrize(address participant) public view returns(uint) {
281         uint payout = 0;
282 
283         if (totalDEEXSupplyOfDragons.add(totalDEEXSupplyOfHamsters) > 0){
284             uint totalSupply = (totalDEEXSupplyOfDragons.add(totalDEEXSupplyOfHamsters)).mul(80).div(100);
285 
286             if (depositDragons[participant] > 0) {
287                 payout = totalSupply.mul(depositDragons[participant]).div(totalSupplyOfDragons);
288             }
289 
290             if (depositHamsters[participant] > 0) {
291                 payout = totalSupply.mul(depositHamsters[participant]).div(totalSupplyOfHamsters);
292             }
293 
294             return payout;
295         }
296         return payout;
297     }
298 }
299 
300 /**
301 * @dev Base contract for teams
302 */
303 contract Team {
304     using SafeMath for uint256;
305 
306     //DEEX fund address
307     address payable public DEEXFund = 0xA2A3aD8319D24f4620Fbe06D2bC57c045ECF0932;
308 
309     JackPot public JPContract;
310     DEEX public DEEXContract;
311 
312     /**
313     * @dev Payable function. 10% will send to DEEX fund and 90% will send to JackPot contract.
314     * Also setting info about player.
315     */
316     function () external payable {
317         require(JPContract.getState() && msg.value >= 0.05 ether);
318 
319         JPContract.setInfo(msg.sender, msg.value.mul(90).div(100));
320 
321         DEEXFund.transfer(msg.value.mul(10).div(100));
322 
323         address(JPContract).transfer(msg.value.mul(90).div(100));
324     }
325 }
326 
327 /*
328 * @dev Dragons contract. To play game with Dragons send ETH to this contract
329 */
330 contract Dragons is Team {
331 
332     /*
333     * @dev Approving JackPot contract for spending token from Dragons contract.
334     * Also setting Dragons address in JackPot contract
335     */
336     constructor(address payable _jackPotAddress, address payable _DEEXAddress) public {
337         JPContract = JackPot(_jackPotAddress);
338         JPContract.setDragonsAddress(address(this));
339         DEEXContract = DEEX(_DEEXAddress);
340         DEEXContract.approve(_jackPotAddress, 9999999999999999999000000000000000000);
341     }
342 }
343 
344 /*
345 * @dev Hamsters contract. To play game with Hamsters send ETH to this contract
346 */
347 contract Hamsters is Team {
348 
349     /*
350     * @dev Approving JackPot contract for spending token from Hamsters contract.
351     * Also setting Hamsters address in JackPot contract
352     */
353     constructor(address payable _jackPotAddress, address payable _DEEXAddress) public {
354         JPContract = JackPot(_jackPotAddress);
355         JPContract.setHamstersAddress(address(this));
356         DEEXContract = DEEX(_DEEXAddress);
357         DEEXContract.approve(_jackPotAddress, 9999999999999999999000000000000000000);
358     }
359 }
360 
361 /**
362  * @title SafeMath
363  * @dev Math operations with safety checks that revert on error. Latest version on 05.01.2019
364  */
365 library SafeMath {
366     int256 constant private INT256_MIN = -2**255;
367 
368     /**
369     * @dev Multiplies two unsigned integers, reverts on overflow.
370     */
371     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
372         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
373         // benefit is lost if 'b' is also tested.
374         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
375         if (a == 0) {
376             return 0;
377         }
378 
379         uint256 c = a * b;
380         require(c / a == b);
381 
382         return c;
383     }
384 
385     /**
386     * @dev Multiplies two signed integers, reverts on overflow.
387     */
388     function mul(int256 a, int256 b) internal pure returns (int256) {
389         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
390         // benefit is lost if 'b' is also tested.
391         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
392         if (a == 0) {
393             return 0;
394         }
395 
396         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
397 
398         int256 c = a * b;
399         require(c / a == b);
400 
401         return c;
402     }
403 
404     /**
405     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
406     */
407     function div(uint256 a, uint256 b) internal pure returns (uint256) {
408         // Solidity only automatically asserts when dividing by 0
409         require(b > 0);
410         uint256 c = a / b;
411         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
412 
413         return c;
414     }
415 
416     /**
417     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
418     */
419     function div(int256 a, int256 b) internal pure returns (int256) {
420         require(b != 0); // Solidity only automatically asserts when dividing by 0
421         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
422 
423         int256 c = a / b;
424 
425         return c;
426     }
427 
428     /**
429     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
430     */
431     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
432         require(b <= a);
433         uint256 c = a - b;
434 
435         return c;
436     }
437 
438     /**
439     * @dev Subtracts two signed integers, reverts on overflow.
440     */
441     function sub(int256 a, int256 b) internal pure returns (int256) {
442         int256 c = a - b;
443         require((b >= 0 && c <= a) || (b < 0 && c > a));
444 
445         return c;
446     }
447 
448     /**
449     * @dev Adds two unsigned integers, reverts on overflow.
450     */
451     function add(uint256 a, uint256 b) internal pure returns (uint256) {
452         uint256 c = a + b;
453         require(c >= a);
454 
455         return c;
456     }
457 
458     /**
459     * @dev Adds two signed integers, reverts on overflow.
460     */
461     function add(int256 a, int256 b) internal pure returns (int256) {
462         int256 c = a + b;
463         require((b >= 0 && c >= a) || (b < 0 && c < a));
464 
465         return c;
466     }
467 
468     /**
469     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
470     * reverts when dividing by zero.
471     */
472     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
473         require(b != 0);
474         return a % b;
475     }
476 }
477 
478 /*
479 *  deex.exchange pre-ICO tokens smart contract
480 *  implements [ERC-20 Token Standard](https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md)
481 *
482 *  Style
483 *  1) before start coding, run Python and type 'import this' in Python console.
484 *  2) we avoid using inheritance (contract B is A) as it makes code less clear for observer
485 *  ("Flat is better than nested", "Readability counts")
486 *  3) we avoid using -= ; =- ; +=; =+
487 *  see: https://github.com/ether-camp/virtual-accelerator/issues/8
488 *  https://www.ethnews.com/ethercamps-hkg-token-has-a-bug-and-needs-to-be-reissued
489 *  4) always explicitly mark variables and functions visibility ("Explicit is better than implicit")
490 *  5) every function except constructor should trigger at leas one event.
491 *  6) smart contracts have to be audited and reviewed, comment your code.
492 *
493 *  Code is published on https://github.com/thedeex/thedeex.github.io
494 */
495 
496 
497 /* "Interfaces" */
498 
499 //  this is expected from another contracts
500 //  if it wants to spend tokens of behalf of the token owner in our contract
501 //  this can be used in many situations, for example to convert pre-ICO tokens to ICO tokens
502 //  see 'approveAndCall' function
503 contract allowanceRecipient {
504     function receiveApproval(address _from, uint256 _value, address _inContract, bytes memory _extraData) public returns (bool success);
505 }
506 
507 
508 // see:
509 // https://github.com/ethereum/EIPs/issues/677
510 contract tokenRecipient {
511     function tokenFallback(address _from, uint256 _value, bytes memory _extraData) public returns (bool success);
512 }
513 
514 
515 contract DEEX {
516 
517     // ver. 2.0
518 
519     /* ---------- Variables */
520 
521     /* --- ERC-20 variables */
522 
523     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#name
524     // function name() constant returns (string name)
525     string public name = "deex";
526 
527     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#symbol
528     // function symbol() constant returns (string symbol)
529     string public symbol = "deex";
530 
531     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#decimals
532     // function decimals() constant returns (uint8 decimals)
533     uint8 public decimals = 0;
534 
535     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#totalsupply
536     // function totalSupply() constant returns (uint256 totalSupply)
537     // we start with zero and will create tokens as SC receives ETH
538     uint256 public totalSupply;
539 
540     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#balanceof
541     // function balanceOf(address _owner) constant returns (uint256 balance)
542     mapping (address => uint256) public balanceOf;
543 
544     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#allowance
545     // function allowance(address _owner, address _spender) constant returns (uint256 remaining)
546     mapping (address => mapping (address => uint256)) public allowance;
547 
548     /* ----- For tokens sale */
549 
550     uint256 public salesCounter = 0;
551 
552     uint256 public maxSalesAllowed;
553 
554     bool private transfersBetweenSalesAllowed;
555 
556     // initial value should be changed by the owner
557     uint256 public tokenPriceInWei = 0;
558 
559     uint256 public saleStartUnixTime = 0; // block.timestamp
560     uint256 public saleEndUnixTime = 0;  // block.timestamp
561 
562     /* --- administrative */
563     address public owner;
564 
565     // account that can set prices
566     address public priceSetter;
567 
568     // 0 - not set
569     uint256 private priceMaxWei = 0;
570     // 0 - not set
571     uint256 private priceMinWei = 0;
572 
573     // accounts holding tokens for for the team, for advisers and for the bounty campaign
574     mapping (address => bool) public isPreferredTokensAccount;
575 
576     bool public contractInitialized = false;
577 
578 
579     /* ---------- Constructor */
580     // do not forget about:
581     // https://medium.com/@codetractio/a-look-into-paritys-multisig-wallet-bug-affecting-100-million-in-ether-and-tokens-356f5ba6e90a
582     constructor () public {
583         owner = msg.sender;
584 
585         // for testNet can be more than 2
586         // --------------------------------2------------------------------------------------------change  in production!
587         maxSalesAllowed = 2;
588         //
589         transfersBetweenSalesAllowed = true;
590     }
591 
592 
593     function initContract(address team, address advisers, address bounty) public onlyBy(owner) returns (bool){
594 
595         require(contractInitialized == false);
596         contractInitialized = true;
597 
598         priceSetter = msg.sender;
599 
600         totalSupply = 100000000;
601 
602         // tokens for sale go SC own account
603         balanceOf[address(this)] = 75000000;
604 
605         // for the team
606         balanceOf[team] = balanceOf[team] + 15000000;
607         isPreferredTokensAccount[team] = true;
608 
609         // for advisers
610         balanceOf[advisers] = balanceOf[advisers] + 7000000;
611         isPreferredTokensAccount[advisers] = true;
612 
613         // for the bounty campaign
614         balanceOf[bounty] = balanceOf[bounty] + 3000000;
615         isPreferredTokensAccount[bounty] = true;
616 
617     }
618 
619     /* ---------- Events */
620 
621     /* --- ERC-20 events */
622     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#events
623 
624     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer-1
625     event Transfer(address indexed from, address indexed to, uint256 value);
626 
627     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approval
628     event Approval(address indexed _owner, address indexed spender, uint256 value);
629 
630     /* --- Administrative events:  */
631     event OwnerChanged(address indexed oldOwner, address indexed newOwner);
632 
633     /* ---- Tokens creation and sale events  */
634 
635     event PriceChanged(uint256 indexed newTokenPriceInWei);
636 
637     event SaleStarted(uint256 startUnixTime, uint256 endUnixTime, uint256 indexed saleNumber);
638 
639     event NewTokensSold(uint256 numberOfTokens, address indexed purchasedBy, uint256 indexed priceInWei);
640 
641     event Withdrawal(address indexed to, uint sumInWei);
642 
643     /* --- Interaction with other contracts events  */
644     event DataSentToAnotherContract(address indexed _from, address indexed _toContract, bytes _extraData);
645 
646     /* ---------- Functions */
647 
648     /* --- Modifiers  */
649     modifier onlyBy(address _account){
650         require(msg.sender == _account);
651 
652         _;
653     }
654 
655     /* --- ERC-20 Functions */
656     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#methods
657 
658     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transfer
659     function transfer(address _to, uint256 _value) public returns (bool){
660         return transferFrom(msg.sender, _to, _value);
661     }
662 
663     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#transferfrom
664     function transferFrom(address _from, address _to, uint256 _value) public returns (bool){
665 
666         // transfers are possible only after sale is finished
667         // except for manager and preferred accounts
668 
669         bool saleFinished = saleIsFinished();
670         require(saleFinished || msg.sender == owner || isPreferredTokensAccount[msg.sender]);
671 
672         // transfers can be forbidden until final ICO is finished
673         // except for manager and preferred accounts
674         require(transfersBetweenSalesAllowed || salesCounter == maxSalesAllowed || msg.sender == owner || isPreferredTokensAccount[msg.sender]);
675 
676         // Transfers of 0 values MUST be treated as normal transfers and fire the Transfer event (ERC-20)
677         require(_value >= 0);
678 
679         // The function SHOULD throw unless the _from account has deliberately authorized the sender of the message via some mechanism
680         require(msg.sender == _from || _value <= allowance[_from][msg.sender]);
681 
682         // check if _from account have required amount
683         require(_value <= balanceOf[_from]);
684 
685         // Subtract from the sender
686         balanceOf[_from] = balanceOf[_from] - _value;
687         //
688         // Add the same to the recipient
689         balanceOf[_to] = balanceOf[_to] + _value;
690 
691         // If allowance used, change allowances correspondingly
692         if (_from != msg.sender) {
693             allowance[_from][msg.sender] = allowance[_from][msg.sender] - _value;
694         }
695 
696         // event
697         emit Transfer(_from, _to, _value);
698 
699         return true;
700     }
701 
702     // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20-token-standard.md#approve
703     // there is and attack, see:
704     // https://github.com/CORIONplatform/solidity/issues/6,
705     // https://drive.google.com/file/d/0ByMtMw2hul0EN3NCaVFHSFdxRzA/view
706     // but this function is required by ERC-20
707     function approve(address _spender, uint256 _value) public returns (bool success){
708 
709         require(_value >= 0);
710 
711         allowance[msg.sender][_spender] = _value;
712 
713         // event
714         emit Approval(msg.sender, _spender, _value);
715 
716         return true;
717     }
718 
719     /*  ---------- Interaction with other contracts  */
720 
721     /* User can allow another smart contract to spend some shares in his behalf
722     *  (this function should be called by user itself)
723     *  @param _spender another contract's address
724     *  @param _value number of tokens
725     *  @param _extraData Data that can be sent from user to another contract to be processed
726     *  bytes - dynamically-sized byte array,
727     *  see http://solidity.readthedocs.io/en/v0.4.15/types.html#dynamically-sized-byte-array
728     *  see possible attack information in comments to function 'approve'
729     *  > this may be used to convert pre-ICO tokens to ICO tokens
730     */
731     function approveAndCall(address _spender, uint256 _value, bytes memory _extraData) public returns (bool success) {
732 
733         approve(_spender, _value);
734 
735         // 'spender' is another contract that implements code as prescribed in 'allowanceRecipient' above
736         allowanceRecipient spender = allowanceRecipient(_spender);
737 
738         // our contract calls 'receiveApproval' function of another contract ('allowanceRecipient') to send information about
739         // allowance and data sent by user
740         // 'this' is this (our) contract address
741         if (spender.receiveApproval(msg.sender, _value, address(this), _extraData)) {
742             emit DataSentToAnotherContract(msg.sender, _spender, _extraData);
743             return true;
744         }
745         else return false;
746     }
747 
748     function approveAllAndCall(address _spender, bytes memory _extraData) public returns (bool success) {
749         return approveAndCall(_spender, balanceOf[msg.sender], _extraData);
750     }
751 
752     /* https://github.com/ethereum/EIPs/issues/677
753     * transfer tokens with additional info to another smart contract, and calls its correspondent function
754     * @param address _to - another smart contract address
755     * @param uint256 _value - number of tokens
756     * @param bytes _extraData - data to send to another contract
757     * > this may be used to convert pre-ICO tokens to ICO tokens
758     */
759     function transferAndCall(address _to, uint256 _value, bytes memory _extraData) public returns (bool success){
760 
761         transferFrom(msg.sender, _to, _value);
762 
763         tokenRecipient receiver = tokenRecipient(_to);
764 
765         if (receiver.tokenFallback(msg.sender, _value, _extraData)) {
766             emit DataSentToAnotherContract(msg.sender, _to, _extraData);
767             return true;
768         }
769         else return false;
770     }
771 
772     // for example for conveting ALL tokens of user account to another tokens
773     function transferAllAndCall(address _to, bytes memory _extraData) public returns (bool success){
774         return transferAndCall(_to, balanceOf[msg.sender], _extraData);
775     }
776 
777     /* --- Administrative functions */
778 
779     function changeOwner(address _newOwner) public onlyBy(owner) returns (bool success){
780         //
781         require(_newOwner != address(0));
782 
783         address oldOwner = owner;
784         owner = _newOwner;
785 
786         emit OwnerChanged(oldOwner, _newOwner);
787 
788         return true;
789     }
790 
791     /* ---------- Create and sell tokens  */
792 
793     /* set time for start and time for end pre-ICO
794     * time is integer representing block timestamp
795     * in UNIX Time,
796     * see: https://www.epochconverter.com
797     * @param uint256 startTime - time to start
798     * @param uint256 endTime - time to end
799     * should be taken into account that
800     * "block.timestamp" can be influenced by miners to a certain degree.
801     * That means that a miner can "choose" the block.timestamp, to a certain degree,
802     * to change the outcome of a transaction in the mined block.
803     * see:
804     * http://solidity.readthedocs.io/en/v0.4.15/frequently-asked-questions.html#are-timestamps-now-block-timestamp-reliable
805     */
806 
807     function startSale(uint256 _startUnixTime, uint256 _endUnixTime) public onlyBy(owner) returns (bool success){
808 
809         require(balanceOf[address(this)] > 0);
810         require(salesCounter < maxSalesAllowed);
811 
812         // time for sale can be set only if:
813         // this is first sale (saleStartUnixTime == 0 && saleEndUnixTime == 0) , or:
814         // previous sale finished ( saleIsFinished() )
815         require(
816         (saleStartUnixTime == 0 && saleEndUnixTime == 0) || saleIsFinished()
817         );
818         // time can be set only for future
819         require(_startUnixTime > now && _endUnixTime > now);
820         // end time should be later than start time
821         require(_endUnixTime - _startUnixTime > 0);
822 
823         saleStartUnixTime = _startUnixTime;
824         saleEndUnixTime = _endUnixTime;
825         salesCounter = salesCounter + 1;
826 
827         emit SaleStarted(_startUnixTime, _endUnixTime, salesCounter);
828 
829         return true;
830     }
831 
832     function saleIsRunning() public view returns (bool){
833 
834         if (balanceOf[address(this)] == 0) {
835             return false;
836         }
837 
838         if (saleStartUnixTime == 0 && saleEndUnixTime == 0) {
839             return false;
840         }
841 
842         if (now > saleStartUnixTime && now < saleEndUnixTime) {
843             return true;
844         }
845 
846         return false;
847     }
848 
849     function saleIsFinished() public view returns (bool){
850 
851         if (balanceOf[address(this)] == 0) {
852             return true;
853         }
854 
855         else if (
856         (saleStartUnixTime > 0 && saleEndUnixTime > 0)
857         && now > saleEndUnixTime) {
858 
859             return true;
860         }
861 
862         // <<<
863         return true;
864     }
865 
866     function changePriceSetter(address _priceSetter) public onlyBy(owner) returns (bool success) {
867         priceSetter = _priceSetter;
868         return true;
869     }
870 
871     function setMinMaxPriceInWei(uint256 _priceMinWei, uint256 _priceMaxWei) public onlyBy(owner) returns (bool success){
872         require(_priceMinWei >= 0 && _priceMaxWei >= 0);
873         priceMinWei = _priceMinWei;
874         priceMaxWei = _priceMaxWei;
875         return true;
876     }
877 
878 
879     function setTokenPriceInWei(uint256 _priceInWei) public onlyBy(priceSetter) returns (bool success){
880 
881         require(_priceInWei >= 0);
882 
883         // if 0 - not set
884         if (priceMinWei != 0 && _priceInWei < priceMinWei) {
885             tokenPriceInWei = priceMinWei;
886         }
887         else if (priceMaxWei != 0 && _priceInWei > priceMaxWei) {
888             tokenPriceInWei = priceMaxWei;
889         }
890         else {
891             tokenPriceInWei = _priceInWei;
892         }
893 
894         emit PriceChanged(tokenPriceInWei);
895 
896         return true;
897     }
898 
899     // allows sending ether and receiving tokens just using contract address
900     // warning:
901     // 'If the fallback function requires more than 2300 gas, the contract cannot receive Ether'
902     // see:
903     // https://ethereum.stackexchange.com/questions/21643/fallback-function-best-practices-when-registering-information
904     function() external payable {
905         buyTokens();
906     }
907 
908     //
909     function buyTokens() public payable returns (bool success){
910 
911         if (saleIsRunning() && tokenPriceInWei > 0) {
912 
913             uint256 numberOfTokens = msg.value / tokenPriceInWei;
914 
915             if (numberOfTokens <= balanceOf[address(this)]) {
916 
917                 balanceOf[msg.sender] = balanceOf[msg.sender] + numberOfTokens;
918                 balanceOf[address(this)] = balanceOf[address(this)] - numberOfTokens;
919 
920                 emit NewTokensSold(numberOfTokens, msg.sender, tokenPriceInWei);
921 
922                 return true;
923             }
924             else {
925                 // (payable)
926                 revert();
927             }
928         }
929         else {
930             // (payable)
931             revert();
932         }
933     }
934 
935     /*  After sale contract owner
936     *  (can be another contract or account)
937     *  can withdraw all collected Ether
938     */
939     function withdrawAllToOwner() public onlyBy(owner) returns (bool) {
940 
941         // only after sale is finished:
942         require(saleIsFinished());
943         uint256 sumInWei = address(this).balance;
944 
945         if (
946         // makes withdrawal and returns true or false
947         !msg.sender.send(address(this).balance)
948         ) {
949             return false;
950         }
951         else {
952             // event
953             emit Withdrawal(msg.sender, sumInWei);
954             return true;
955         }
956     }
957 
958     /* ---------- Referral System */
959 
960     // list of registered referrers
961     // represented by keccak256(address) (returns bytes32)
962     // ! referrers can not be removed !
963     mapping (bytes32 => bool) private isReferrer;
964 
965     uint256 private referralBonus = 0;
966 
967     uint256 private referrerBonus = 0;
968     // tokens owned by referrers:
969     mapping (bytes32 => uint256) public referrerBalanceOf;
970 
971     mapping (bytes32 => uint) public referrerLinkedSales;
972 
973     function addReferrer(bytes32 _referrer) public onlyBy(owner) returns (bool success){
974         isReferrer[_referrer] = true;
975         return true;
976     }
977 
978     function removeReferrer(bytes32 _referrer) public onlyBy(owner) returns (bool success){
979         isReferrer[_referrer] = false;
980         return true;
981     }
982 
983     // bonuses are set in as integers (20%, 30%), initial 0%
984     function setReferralBonuses(uint256 _referralBonus, uint256 _referrerBonus) public onlyBy(owner) returns (bool success){
985         require(_referralBonus > 0 && _referrerBonus > 0);
986         referralBonus = _referralBonus;
987         referrerBonus = _referrerBonus;
988         return true;
989     }
990 
991     function buyTokensWithReferrerAddress(address _referrer) public payable returns (bool success){
992 
993         bytes32 referrer = keccak256(abi.encodePacked(_referrer));
994 
995         if (saleIsRunning() && tokenPriceInWei > 0) {
996 
997             if (isReferrer[referrer]) {
998 
999                 uint256 numberOfTokens = msg.value / tokenPriceInWei;
1000 
1001                 if (numberOfTokens <= balanceOf[address(this)]) {
1002 
1003                     referrerLinkedSales[referrer] = referrerLinkedSales[referrer] + numberOfTokens;
1004 
1005                     uint256 referralBonusTokens = (numberOfTokens * (100 + referralBonus) / 100) - numberOfTokens;
1006                     uint256 referrerBonusTokens = (numberOfTokens * (100 + referrerBonus) / 100) - numberOfTokens;
1007 
1008                     balanceOf[address(this)] = balanceOf[address(this)] - numberOfTokens - referralBonusTokens - referrerBonusTokens;
1009 
1010                     balanceOf[msg.sender] = balanceOf[msg.sender] + (numberOfTokens + referralBonusTokens);
1011 
1012                     referrerBalanceOf[referrer] = referrerBalanceOf[referrer] + referrerBonusTokens;
1013 
1014                     emit NewTokensSold(numberOfTokens + referralBonusTokens, msg.sender, tokenPriceInWei);
1015 
1016                     return true;
1017                 }
1018                 else {
1019                     // (payable)
1020                     revert();
1021                 }
1022             }
1023             else {
1024                 // (payable)
1025                 buyTokens();
1026             }
1027         }
1028         else {
1029             // (payable)
1030             revert();
1031         }
1032     }
1033 
1034     event ReferrerBonusTokensTaken(address referrer, uint256 bonusTokensValue);
1035 
1036     function getReferrerBonusTokens() public returns (bool success){
1037         require(saleIsFinished());
1038         uint256 bonusTokens = referrerBalanceOf[keccak256(abi.encodePacked(msg.sender))];
1039         balanceOf[msg.sender] = balanceOf[msg.sender] + bonusTokens;
1040         emit ReferrerBonusTokensTaken(msg.sender, bonusTokens);
1041         return true;
1042     }
1043 
1044 }