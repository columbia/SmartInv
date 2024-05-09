1 pragma solidity 0.5.1;
2 
3 /**
4 * @dev Base contract for teams
5 */
6 contract Team {
7     using SafeMath for uint256;
8 
9     //DEEX fund address
10     address payable public DEEXFund = 0xA2A3aD8319D24f4620Fbe06D2bC57c045ECF0932;
11 
12     JackPot public JPContract;
13     DEEX public DEEXContract;
14 
15     /**
16     * @dev Payable function. 10% will send to DEEX fund and 90% will send to JackPot contract.
17     * Also setting info about player.
18     */
19     function () external payable {
20         require(JPContract.getState() && msg.value >= 0.05 ether);
21 
22         JPContract.setInfo(msg.sender, msg.value.mul(90).div(100));
23 
24         DEEXFund.transfer(msg.value.mul(10).div(100));
25 
26         address(JPContract).transfer(msg.value.mul(90).div(100));
27     }
28 }
29 
30 /*
31 * @dev Dragons contract. To play game with Dragons send ETH to this contract
32 */
33 contract Dragons is Team {
34 
35     /*
36     * @dev Approving JackPot contract for spending token from Dragons contract.
37     * Also setting Dragons address in JackPot contract
38     */
39     constructor(address payable _jackPotAddress, address payable _DEEXAddress) public {
40         JPContract = JackPot(_jackPotAddress);
41         JPContract.setDragonsAddress(address(this));
42         DEEXContract = DEEX(_DEEXAddress);
43         DEEXContract.approve(_jackPotAddress, 9999999999999999999000000000000000000);
44     }
45 }
46 
47 /*
48 * @dev Hamsters contract. To play game with Hamsters send ETH to this contract
49 */
50 contract Hamsters is Team {
51 
52     /*
53     * @dev Approving JackPot contract for spending token from Hamsters contract.
54     * Also setting Hamsters address in JackPot contract
55     */
56     constructor(address payable _jackPotAddress, address payable _DEEXAddress) public {
57         JPContract = JackPot(_jackPotAddress);
58         JPContract.setHamstersAddress(address(this));
59         DEEXContract = DEEX(_DEEXAddress);
60         DEEXContract.approve(_jackPotAddress, 9999999999999999999000000000000000000);
61     }
62 }
63 
64 /**
65  * @title SafeMath
66  * @dev Math operations with safety checks that revert on error. Latest version on 05.01.2019
67  */
68 library SafeMath {
69     int256 constant private INT256_MIN = -2**255;
70 
71     /**
72     * @dev Multiplies two unsigned integers, reverts on overflow.
73     */
74     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
75         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
76         // benefit is lost if 'b' is also tested.
77         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
78         if (a == 0) {
79             return 0;
80         }
81 
82         uint256 c = a * b;
83         require(c / a == b);
84 
85         return c;
86     }
87 
88     /**
89     * @dev Multiplies two signed integers, reverts on overflow.
90     */
91     function mul(int256 a, int256 b) internal pure returns (int256) {
92         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
93         // benefit is lost if 'b' is also tested.
94         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
95         if (a == 0) {
96             return 0;
97         }
98 
99         require(!(a == -1 && b == INT256_MIN)); // This is the only case of overflow not detected by the check below
100 
101         int256 c = a * b;
102         require(c / a == b);
103 
104         return c;
105     }
106 
107     /**
108     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
109     */
110     function div(uint256 a, uint256 b) internal pure returns (uint256) {
111         // Solidity only automatically asserts when dividing by 0
112         require(b > 0);
113         uint256 c = a / b;
114         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
115 
116         return c;
117     }
118 
119     /**
120     * @dev Integer division of two signed integers truncating the quotient, reverts on division by zero.
121     */
122     function div(int256 a, int256 b) internal pure returns (int256) {
123         require(b != 0); // Solidity only automatically asserts when dividing by 0
124         require(!(b == -1 && a == INT256_MIN)); // This is the only case of overflow
125 
126         int256 c = a / b;
127 
128         return c;
129     }
130 
131     /**
132     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
133     */
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         require(b <= a);
136         uint256 c = a - b;
137 
138         return c;
139     }
140 
141     /**
142     * @dev Subtracts two signed integers, reverts on overflow.
143     */
144     function sub(int256 a, int256 b) internal pure returns (int256) {
145         int256 c = a - b;
146         require((b >= 0 && c <= a) || (b < 0 && c > a));
147 
148         return c;
149     }
150 
151     /**
152     * @dev Adds two unsigned integers, reverts on overflow.
153     */
154     function add(uint256 a, uint256 b) internal pure returns (uint256) {
155         uint256 c = a + b;
156         require(c >= a);
157 
158         return c;
159     }
160 
161     /**
162     * @dev Adds two signed integers, reverts on overflow.
163     */
164     function add(int256 a, int256 b) internal pure returns (int256) {
165         int256 c = a + b;
166         require((b >= 0 && c >= a) || (b < 0 && c < a));
167 
168         return c;
169     }
170 
171     /**
172     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
173     * reverts when dividing by zero.
174     */
175     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
176         require(b != 0);
177         return a % b;
178     }
179 }
180 
181 /*
182 * @title JackPot
183 * @dev Jackpot contract which contained all ETH from Dragons and Hamsters teams.
184 * When time in blockchain will be grater then current deadline or last deadline need call getWinner function
185 * then participants able get prizes.
186 *
187 * Last participant(last hero) win 10% from all bank
188 *
189 * - To get prize send 0 ETH to this contract
190 */
191 contract JackPot {
192 
193     using SafeMath for uint256;
194 
195     mapping (address => uint256) public depositDragons;
196     mapping (address => uint256) public depositHamsters;
197     uint256 public currentDeadline;
198     uint256 public lastDeadline = 1551978000; //last deadline for game
199     uint256 public countOfDragons;
200     uint256 public countOfHamsters;
201     uint256 public totalSupplyOfHamsters;
202     uint256 public totalSupplyOfDragons;
203     uint256 public totalDEEXSupplyOfHamsters;
204     uint256 public totalDEEXSupplyOfDragons;
205     uint256 public probabilityOfHamsters;
206     uint256 public probabilityOfDragons;
207     address public lastHero;
208     address public lastHeroHistory;
209     uint256 public jackPot;
210     uint256 public winner;
211     bool public finished = false;
212 
213     Dragons public DragonsContract;
214     Hamsters public HamstersContract;
215     DEEX public DEEXContract;
216 
217     /*
218     * @dev Constructor create first deadline
219     */
220     constructor() public {
221         currentDeadline = block.timestamp + 60 * 60 * 24 * 30 ; //days for first deadline
222     }
223 
224     /**
225     * @dev Setter the DEEX Token contract address. Address can be set at once.
226     * @param _DEEXAddress Address of the DEEX Token contract
227     */
228     function setDEEXAddress(address payable _DEEXAddress) public {
229         require(address(DEEXContract) == address(0x0));
230         DEEXContract = DEEX(_DEEXAddress);
231     }
232 
233     /**
234     * @dev Setter the Dragons contract address. Address can be set at once.
235     * @param _dragonsAddress Address of the Dragons contract
236     */
237     function setDragonsAddress(address payable _dragonsAddress) external {
238         require(address(DragonsContract) == address(0x0));
239         DragonsContract = Dragons(_dragonsAddress);
240     }
241 
242     /**
243     * @dev Setter the Hamsters contract address. Address can be set at once.
244     * @param _hamstersAddress Address of the Hamsters contract
245     */
246     function setHamstersAddress(address payable _hamstersAddress) external {
247         require(address(HamstersContract) == address(0x0));
248         HamstersContract = Hamsters(_hamstersAddress);
249     }
250 
251     /**
252     * @dev Getting time from blockchain
253     */
254     function getNow() view public returns(uint){
255         return block.timestamp;
256     }
257 
258     /**
259     * @dev Getting state of game. True - game continue, False - game stopped
260     */
261     function getState() view public returns(bool) {
262         if (block.timestamp > currentDeadline) {
263             return false;
264         }
265         return true;
266     }
267 
268     /**
269     * @dev Setting info about participant from Dragons or Hamsters contract
270     * @param _lastHero Address of participant
271     * @param _deposit Amount of deposit
272     */
273     function setInfo(address _lastHero, uint256 _deposit) public {
274         require(address(DragonsContract) == msg.sender || address(HamstersContract) == msg.sender);
275 
276         if (address(DragonsContract) == msg.sender) {
277             require(depositHamsters[_lastHero] == 0, "You are already in hamsters team");
278             if (depositDragons[_lastHero] == 0)
279                 countOfDragons++;
280             totalSupplyOfDragons = totalSupplyOfDragons.add(_deposit.mul(90).div(100));
281             depositDragons[_lastHero] = depositDragons[_lastHero].add(_deposit.mul(90).div(100));
282         }
283 
284         if (address(HamstersContract) == msg.sender) {
285             require(depositDragons[_lastHero] == 0, "You are already in dragons team");
286             if (depositHamsters[_lastHero] == 0)
287                 countOfHamsters++;
288             totalSupplyOfHamsters = totalSupplyOfHamsters.add(_deposit.mul(90).div(100));
289             depositHamsters[_lastHero] = depositHamsters[_lastHero].add(_deposit.mul(90).div(100));
290         }
291 
292         lastHero = _lastHero;
293 
294         if (currentDeadline.add(120) <= lastDeadline) {
295             currentDeadline = currentDeadline.add(120);
296         } else {
297             currentDeadline = lastDeadline;
298         }
299 
300         jackPot = (address(this).balance.add(_deposit)).mul(10).div(100);
301 
302         calculateProbability();
303     }
304 
305     /**
306     * @dev Calculation probability for team's win
307     */
308     function calculateProbability() public {
309         require(winner == 0 && getState());
310 
311         totalDEEXSupplyOfHamsters = DEEXContract.balanceOf(address(HamstersContract));
312         totalDEEXSupplyOfDragons = DEEXContract.balanceOf(address(DragonsContract));
313         uint256 percent = (totalSupplyOfHamsters.add(totalSupplyOfDragons)).div(100);
314 
315         if (totalDEEXSupplyOfHamsters < 1) {
316             totalDEEXSupplyOfHamsters = 0;
317         }
318 
319         if (totalDEEXSupplyOfDragons < 1) {
320             totalDEEXSupplyOfDragons = 0;
321         }
322 
323         if (totalDEEXSupplyOfHamsters <= totalDEEXSupplyOfDragons) {
324             uint256 difference = (totalDEEXSupplyOfDragons.sub(totalDEEXSupplyOfHamsters)).mul(100);
325             probabilityOfDragons = totalSupplyOfDragons.mul(100).div(percent).add(difference);
326 
327             if (probabilityOfDragons > 8000) {
328                 probabilityOfDragons = 8000;
329             }
330             if (probabilityOfDragons < 2000) {
331                 probabilityOfDragons = 2000;
332             }
333             probabilityOfHamsters = 10000 - probabilityOfDragons;
334         } else {
335             uint256 difference = (totalDEEXSupplyOfHamsters.sub(totalDEEXSupplyOfDragons)).mul(100);
336 
337             probabilityOfHamsters = totalSupplyOfHamsters.mul(100).div(percent).add(difference);
338 
339             if (probabilityOfHamsters > 8000) {
340                 probabilityOfHamsters = 8000;
341             }
342             if (probabilityOfHamsters < 2000) {
343                 probabilityOfHamsters = 2000;
344             }
345             probabilityOfDragons = 10000 - probabilityOfHamsters;
346         }
347 
348         totalDEEXSupplyOfHamsters = DEEXContract.balanceOf(address(HamstersContract));
349         totalDEEXSupplyOfDragons = DEEXContract.balanceOf(address(DragonsContract));
350     }
351 
352     /**
353     * @dev Getting winner team
354     */
355     function getWinners() public {
356         require(winner == 0 && !getState());
357 
358         uint256 seed1 = address(this).balance;
359         uint256 seed2 = totalSupplyOfHamsters;
360         uint256 seed3 = totalSupplyOfDragons;
361         uint256 seed4 = totalDEEXSupplyOfHamsters;
362         uint256 seed5 = totalDEEXSupplyOfHamsters;
363         uint256 seed6 = block.difficulty;
364         uint256 seed7 = block.timestamp;
365 
366         bytes32 randomHash = keccak256(abi.encodePacked(seed1, seed2, seed3, seed4, seed5, seed6, seed7));
367         uint randomNumber = uint(randomHash);
368 
369         if (randomNumber == 0){
370             randomNumber = 1;
371         }
372 
373         uint winningNumber = randomNumber % 10000;
374 
375         if (1 <= winningNumber && winningNumber <= probabilityOfDragons){
376             winner = 1;
377         }
378 
379         if (probabilityOfDragons < winningNumber && winningNumber <= 10000){
380             winner = 2;
381         }
382     }
383 
384     /**
385     * @dev Payable function for take prize
386     */
387     function () external payable {
388         if (msg.value == 0 &&  !getState() && winner > 0){
389             require(depositDragons[msg.sender] > 0 || depositHamsters[msg.sender] > 0);
390 
391             uint payout = 0;
392             uint payoutDEEX = 0;
393 
394             if (winner == 1 && depositDragons[msg.sender] > 0) {
395                 payout = calculateETHPrize(msg.sender);
396             }
397             if (winner == 2 && depositHamsters[msg.sender] > 0) {
398                 payout = calculateETHPrize(msg.sender);
399             }
400 
401             if (payout > 0) {
402                 depositDragons[msg.sender] = 0;
403                 depositHamsters[msg.sender] = 0;
404                 msg.sender.transfer(payout);
405             }
406 
407             if ((winner == 1 && depositDragons[msg.sender] == 0) || (winner == 2 && depositHamsters[msg.sender] == 0)) {
408                 payoutDEEX = calculateDEEXPrize(msg.sender);
409                 if (DEEXContract.balanceOf(address(HamstersContract)) > 0)
410                     DEEXContract.transferFrom(
411                         address(HamstersContract),
412                         address(this),
413                         DEEXContract.balanceOf(address(HamstersContract))
414                     );
415                 if (DEEXContract.balanceOf(address(DragonsContract)) > 0)
416                     DEEXContract.transferFrom(
417                         address(DragonsContract),
418                         address(this),
419                         DEEXContract.balanceOf(address(DragonsContract))
420                     );
421                 if (payoutDEEX > 0){
422                     DEEXContract.transfer(msg.sender, payoutDEEX);
423                 }
424             }
425 
426             if (msg.sender == lastHero) {
427                 lastHeroHistory = lastHero;
428                 lastHero = address(0x0);
429                 msg.sender.transfer(jackPot);
430             }
431         }
432     }
433 
434     /**
435     * @dev Getting ETH prize of participant
436     * @param participant Address of participant
437     */
438     function calculateETHPrize(address participant) public view returns(uint) {
439         uint payout = 0;
440 
441         uint256 totalSupply = totalSupplyOfDragons.add(totalSupplyOfHamsters);
442         if (totalSupply > 0) {
443             if (depositDragons[participant] > 0) {
444                 payout = totalSupply.mul(depositDragons[participant]).div(totalSupplyOfDragons);
445             }
446 
447             if (depositHamsters[participant] > 0) {
448                 payout = totalSupply.mul(depositHamsters[participant]).div(totalSupplyOfHamsters);
449             }
450         }
451         return payout;
452     }
453 
454     /**
455     * @dev Getting DEEX Token prize of participant
456     * @param participant Address of participant
457     */
458     function calculateDEEXPrize(address participant) public view returns(uint) {
459         uint payout = 0;
460 
461         if (totalDEEXSupplyOfDragons.add(totalDEEXSupplyOfHamsters) > 0){
462             uint totalSupply = (totalDEEXSupplyOfDragons.add(totalDEEXSupplyOfHamsters)).mul(80).div(100);
463 
464             if (depositDragons[participant] > 0) {
465                 payout = totalSupply.mul(depositDragons[participant]).div(totalSupplyOfDragons);
466             }
467 
468             if (depositHamsters[participant] > 0) {
469                 payout = totalSupply.mul(depositHamsters[participant]).div(totalSupplyOfHamsters);
470             }
471 
472             return payout;
473         }
474         return payout;
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