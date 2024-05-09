1 pragma solidity 0.5.6;
2 
3 
4 
5 /**
6  * @title ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/20
8  */
9 interface IERC20 {
10   function totalSupply() external view returns (uint256);
11 
12   function balanceOf(address who) external view returns (uint256);
13 
14   function allowance(address owner, address spender)
15   external view returns (uint256);
16 
17   function transfer(address to, uint256 value) external returns (bool);
18 
19   function approve(address spender, uint256 value)
20   external returns (bool);
21 
22   function transferFrom(address from, address to, uint256 value)
23   external returns (bool);
24 
25   event Transfer(
26     address indexed from,
27     address indexed to,
28     uint256 value
29   );
30 
31   event Approval(
32     address indexed owner,
33     address indexed spender,
34     uint256 value
35   );
36 }
37 
38 /**
39  * @title SafeMath
40  * @dev Unsigned math operations with safety checks that revert on error
41  */
42 library SafeMath {
43   /**
44    * @dev Multiplies two unsigned integers, reverts on overflow.
45    */
46   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
48     // benefit is lost if 'b' is also tested.
49     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
50     if (a == 0) {
51       return 0;
52     }
53 
54     uint256 c = a * b;
55     require(c / a == b);
56 
57     return c;
58   }
59 
60   /**
61    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
62    */
63   function div(uint256 a, uint256 b) internal pure returns (uint256) {
64     // Solidity only automatically asserts when dividing by 0
65     require(b > 0);
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68 
69     return c;
70   }
71 
72   /**
73    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
74    */
75   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
76     require(b <= a);
77     uint256 c = a - b;
78 
79     return c;
80   }
81 
82   /**
83    * @dev Adds two unsigned integers, reverts on overflow.
84    */
85   function add(uint256 a, uint256 b) internal pure returns (uint256) {
86     uint256 c = a + b;
87     require(c >= a);
88 
89     return c;
90   }
91 
92   /**
93    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
94    * reverts when dividing by zero.
95    */
96   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
97     require(b != 0);
98     return a % b;
99   }
100 }
101 
102 /**
103  * @title Standard ERC20 token
104  *
105  * @dev Implementation of the basic standard token.
106  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
107  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
108  */
109 contract ERC20 is IERC20 {
110   using SafeMath for uint256;
111 
112   mapping (address => uint256) private _balances;
113 
114   mapping (address => mapping (address => uint256)) private _allowed;
115 
116   uint256 private _totalSupply;
117 
118   /**
119   * @dev Total number of tokens in existence
120   */
121   function totalSupply() public view returns (uint256) {
122     return _totalSupply;
123   }
124 
125   /**
126   * @dev Gets the balance of the specified address.
127   * @param owner The address to query the balance of.
128   * @return An uint256 representing the amount owned by the passed address.
129   */
130   function balanceOf(address owner) public view returns (uint256) {
131     return _balances[owner];
132   }
133 
134   /**
135    * @dev Function to check the amount of tokens that an owner allowed to a spender.
136    * @param owner address The address which owns the funds.
137    * @param spender address The address which will spend the funds.
138    * @return A uint256 specifying the amount of tokens still available for the spender.
139    */
140   function allowance(
141     address owner,
142     address spender
143   )
144   public
145   view
146   returns (uint256)
147   {
148     return _allowed[owner][spender];
149   }
150 
151   /**
152   * @dev Transfer token for a specified address
153   * @param to The address to transfer to.
154   * @param value The amount to be transferred.
155   */
156   function transfer(address to, uint256 value) public returns (bool) {
157     _transfer(msg.sender, to, value);
158 
159     return true;
160   }
161 
162   /**
163    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
164    * Beware that changing an allowance with this method brings the risk that someone may use both the old
165    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168    * @param spender The address which will spend the funds.
169    * @param value The amount of tokens to be spent.
170    */
171   function approve(address spender, uint256 value) public returns (bool) {
172     require(spender != address(0));
173 
174     _allowed[msg.sender][spender] = value;
175 
176     emit Approval(msg.sender, spender, value);
177 
178     return true;
179   }
180 
181   /**
182    * @dev Transfer tokens from one address to another
183    * @param from address The address which you want to send tokens from
184    * @param to address The address which you want to transfer to
185    * @param value uint256 the amount of tokens to be transferred
186    */
187   function transferFrom(
188     address from,
189     address to,
190     uint256 value
191   )
192   public
193   returns (bool)
194   {
195     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
196     _transfer(from, to, value);
197 
198     return true;
199   }
200 
201   /**
202    * @dev Increase the amount of tokens that an owner allowed to a spender.
203    * approve should be called when allowed_[_spender] == 0. To increment
204    * allowed value is better to use this function to avoid 2 calls (and wait until
205    * the first transaction is mined)
206    * From MonolithDAO Token.sol
207    * @param spender The address which will spend the funds.
208    * @param addedValue The amount of tokens to increase the allowance by.
209    */
210   function increaseAllowance(
211     address spender,
212     uint256 addedValue
213   )
214   public
215   returns (bool)
216   {
217     require(spender != address(0));
218 
219     _allowed[msg.sender][spender] = (
220     _allowed[msg.sender][spender].add(addedValue));
221 
222     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
223 
224     return true;
225   }
226 
227   /**
228    * @dev Decrease the amount of tokens that an owner allowed to a spender.
229    * approve should be called when allowed_[_spender] == 0. To decrement
230    * allowed value is better to use this function to avoid 2 calls (and wait until
231    * the first transaction is mined)
232    * From MonolithDAO Token.sol
233    * @param spender The address which will spend the funds.
234    * @param subtractedValue The amount of tokens to decrease the allowance by.
235    */
236   function decreaseAllowance(
237     address spender,
238     uint256 subtractedValue
239   )
240   public
241   returns (bool)
242   {
243     require(spender != address(0));
244 
245     _allowed[msg.sender][spender] = (
246     _allowed[msg.sender][spender].sub(subtractedValue));
247 
248     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
249 
250     return true;
251   }
252 
253   /**
254   * @dev Transfer token for a specified addresses
255   * @param from The address to transfer from.
256   * @param to The address to transfer to.
257   * @param value The amount to be transferred.
258   */
259   function _transfer(address from, address to, uint256 value) internal {
260     require(to != address(0));
261 
262     _balances[from] = _balances[from].sub(value);
263     _balances[to] = _balances[to].add(value);
264 
265     emit Transfer(from, to, value);
266   }
267 
268   /**
269    * @dev Internal function that mints an amount of the token and assigns it to
270    * an account. This encapsulates the modification of balances such that the
271    * proper events are emitted.
272    * @param account The account that will receive the created tokens.
273    * @param value The amount that will be created.
274    */
275   function _mint(address account, uint256 value) internal {
276     require(account != address(0));
277 
278     _totalSupply = _totalSupply.add(value);
279     _balances[account] = _balances[account].add(value);
280 
281     emit Transfer(address(0), account, value);
282   }
283 
284   /**
285    * @dev Internal function that burns an amount of the token of a given
286    * account.
287    * @param account The account whose tokens will be burnt.
288    * @param value The amount that will be burnt.
289    */
290   function _burn(address account, uint256 value) internal {
291     require(account != address(0));
292 
293     _totalSupply = _totalSupply.sub(value);
294     _balances[account] = _balances[account].sub(value);
295 
296     emit Transfer(account, address(0), value);
297   }
298 
299   /**
300    * @dev Internal function that burns an amount of the token of a given
301    * account, deducting from the sender's allowance for said account. Uses the
302    * internal burn function.
303    * @param account The account whose tokens will be burnt.
304    * @param value The amount that will be burnt.
305    */
306   function _burnFrom(address account, uint256 value) internal {
307     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
308     // this function needs to emit an event with the updated approval.
309     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
310       value);
311     _burn(account, value);
312   }
313 }
314 
315 /**
316  * @title SafeERC20
317  * @dev Wrappers around ERC20 operations that throw on failure.
318  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
319  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
320  */
321 library SafeERC20 {
322 
323   using SafeMath for uint256;
324 
325   function safeTransfer(
326     IERC20 token,
327     address to,
328     uint256 value
329   )
330   internal
331   {
332     require(token.transfer(to, value));
333   }
334 
335   function safeTransferFrom(
336     IERC20 token,
337     address from,
338     address to,
339     uint256 value
340   )
341   internal
342   {
343     require(token.transferFrom(from, to, value));
344   }
345 
346   function safeApprove(
347     IERC20 token,
348     address spender,
349     uint256 value
350   )
351   internal
352   {
353     // safeApprove should only be called when setting an initial allowance,
354     // or when resetting it to zero. To increase and decrease it, use
355     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
356     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
357     require(token.approve(spender, value));
358   }
359 
360   function safeIncreaseAllowance(
361     IERC20 token,
362     address spender,
363     uint256 value
364   )
365   internal
366   {
367     uint256 newAllowance = token.allowance(address(this), spender).add(value);
368     require(token.approve(spender, newAllowance));
369   }
370 
371   function safeDecreaseAllowance(
372     IERC20 token,
373     address spender,
374     uint256 value
375   )
376   internal
377   {
378     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
379     require(token.approve(spender, newAllowance));
380   }
381 }
382 
383 /**
384  * @title ERC20Detailed token
385  * @dev The decimals are only for visualization purposes.
386  * All the operations are done using the smallest and indivisible token unit,
387  * just as on Ethereum all the operations are done in wei.
388  */
389 contract ERC20Detailed is IERC20 {
390   string private _name;
391   string private _symbol;
392   uint8 private _decimals;
393 
394   constructor(string memory name, string memory symbol, uint8 decimals) public {
395     _name = name;
396     _symbol = symbol;
397     _decimals = decimals;
398   }
399 
400   /**
401    * @return the name of the token.
402    */
403   function name() public view returns(string memory) {
404     return _name;
405   }
406 
407   /**
408    * @return the symbol of the token.
409    */
410   function symbol() public view returns(string memory) {
411     return _symbol;
412   }
413 
414   /**
415    * @return the number of decimals of the token.
416    */
417   function decimals() public view returns(uint8) {
418     return _decimals;
419   }
420 }
421 
422 contract Ownable {
423   address payable public owner;
424   /**
425    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
426    * account.
427    */
428   constructor() public {
429     owner = msg.sender;
430   }
431   /**
432    * @dev Throws if called by any account other than the owner.
433    */
434   modifier onlyOwner() {
435     require(msg.sender == owner);
436     _;
437   }
438   function transferOwnership(address payable newOwner) public onlyOwner {
439     require(newOwner != address(0));
440     owner = newOwner;
441   }
442 }
443 
444 /*
445 * @title Bank
446 * @dev Bank contract which contained all ETH from Bulls and Bears teams.
447 * When time in blockchain will be grater then current deadline or last deadline need call getWinner function
448 * then participants able get prizes.
449 *
450 * Last participant(last hero) win 10% from all bank
451 *
452 * - To get prize send 0 ETH to this contract
453 */
454 contract Bank is Ownable {
455 
456     using SafeMath for uint256;
457 
458     mapping (uint256 => mapping (address => uint256)) public depositBears;
459     mapping (uint256 => mapping (address => uint256)) public depositBulls;
460 
461     uint256 public currentDeadline;
462     uint256 public currentRound = 1;
463     uint256 public lastDeadline;
464     uint256 public defaultCurrentDeadlineInHours = 24;
465     uint256 public defaultLastDeadlineInHours = 48;
466     uint256 public countOfBears;
467     uint256 public countOfBulls;
468     uint256 public totalSupplyOfBulls;
469     uint256 public totalSupplyOfBears;
470     uint256 public totalGWSupplyOfBulls;
471     uint256 public totalGWSupplyOfBears;
472     uint256 public probabilityOfBulls;
473     uint256 public probabilityOfBears;
474     address public lastHero;
475     address public lastHeroHistory;
476     uint256 public jackPot;
477     uint256 public winner;
478     uint256 public withdrawn;
479     uint256 public withdrawnGW;
480     uint256 public remainder;
481     uint256 public remainderGW;
482     uint256 public rate = 1;
483     uint256 public rateModifier = 0;
484     uint256 public tokenReturn;
485     address crowdSale;
486 
487     uint256 public lastTotalSupplyOfBulls;
488     uint256 public lastTotalSupplyOfBears;
489     uint256 public lastTotalGWSupplyOfBulls;
490     uint256 public lastTotalGWSupplyOfBears;
491     uint256 public lastProbabilityOfBulls;
492     uint256 public lastProbabilityOfBears;
493     address public lastRoundHero;
494     uint256 public lastJackPot;
495     uint256 public lastWinner;
496     uint256 public lastBalance;
497     uint256 public lastBalanceGW;
498     uint256 public lastCountOfBears;
499     uint256 public lastCountOfBulls;
500     uint256 public lastWithdrawn;
501     uint256 public lastWithdrawnGW;
502 
503 
504     bool public finished = false;
505 
506     Bears public BearsContract;
507     Bulls public BullsContract;
508     GameWave public GameWaveContract;
509 
510     /*
511     * @dev Constructor create first deadline
512     */
513     constructor(address _crowdSale) public {
514         _setRoundTime(6, 8);
515         crowdSale = _crowdSale;
516     }
517 
518     /**
519     * @dev Setter token rate.
520     * @param _rate this value for change percent relation rate to count of tokens.
521     * @param _rateModifier this value for change math operation under tokens.
522     */
523     function setRateToken(uint256 _rate, uint256 _rateModifier) public onlyOwner returns(uint256){
524         rate = _rate;
525         rateModifier = _rateModifier;
526     }
527 
528     /**
529     * @dev Setter crowd sale address.
530     * @param _crowdSale Address of the crowd sale contract.
531     */
532     function setCrowdSale(address _crowdSale) public onlyOwner{
533         crowdSale = _crowdSale;
534     }
535 
536     /**
537     * @dev Setter round time.
538     * @param _currentDeadlineInHours this value current deadline in hours.
539     * @param _lastDeadlineInHours this value last deadline in hours.
540     */
541     function _setRoundTime(uint _currentDeadlineInHours, uint _lastDeadlineInHours) internal {
542         defaultCurrentDeadlineInHours = _currentDeadlineInHours;
543         defaultLastDeadlineInHours = _lastDeadlineInHours;
544         currentDeadline = block.timestamp + 60 * 60 * _currentDeadlineInHours;
545         lastDeadline = block.timestamp + 60 * 60 * _lastDeadlineInHours;
546     }
547 
548     /**
549     * @dev Setter round time.
550     * @param _currentDeadlineInHours this value current deadline in hours.
551     * @param _lastDeadlineInHours this value last deadline in hours.
552     */
553     function setRoundTime(uint _currentDeadlineInHours, uint _lastDeadlineInHours) public onlyOwner {
554         _setRoundTime(_currentDeadlineInHours, _lastDeadlineInHours);
555     }
556 
557 
558     /**
559     * @dev Setter the GameWave contract address. Address can be set at once.
560     * @param _GameWaveAddress Address of the GameWave contract
561     */
562     function setGameWaveAddress(address payable _GameWaveAddress) public {
563         require(address(GameWaveContract) == address(0x0));
564         GameWaveContract = GameWave(_GameWaveAddress);
565     }
566 
567     /**
568     * @dev Setter the Bears contract address. Address can be set at once.
569     * @param _bearsAddress Address of the Bears contract
570     */
571     function setBearsAddress(address payable _bearsAddress) external {
572         require(address(BearsContract) == address(0x0));
573         BearsContract = Bears(_bearsAddress);
574     }
575 
576     /**
577     * @dev Setter the Bulls contract address. Address can be set at once.
578     * @param _bullsAddress Address of the Bulls contract
579     */
580     function setBullsAddress(address payable _bullsAddress) external {
581         require(address(BullsContract) == address(0x0));
582         BullsContract = Bulls(_bullsAddress);
583     }
584 
585     /**
586     * @dev Getting time from blockchain for timer
587     */
588     function getNow() view public returns(uint){
589         return block.timestamp;
590     }
591 
592     /**
593     * @dev Getting state of game. True - game continue, False - game stopped
594     */
595     function getState() view public returns(bool) {
596         if (block.timestamp > currentDeadline) {
597             return false;
598         }
599         return true;
600     }
601 
602     /**
603     * @dev Setting info about participant from Bears or Bulls contract
604     * @param _lastHero Address of participant
605     * @param _deposit Amount of deposit
606     */
607     function setInfo(address _lastHero, uint256 _deposit) public {
608         require(address(BearsContract) == msg.sender || address(BullsContract) == msg.sender);
609 
610         if (address(BearsContract) == msg.sender) {
611             require(depositBulls[currentRound][_lastHero] == 0, "You are already in bulls team");
612             if (depositBears[currentRound][_lastHero] == 0)
613                 countOfBears++;
614             totalSupplyOfBears = totalSupplyOfBears.add(_deposit.mul(90).div(100));
615             depositBears[currentRound][_lastHero] = depositBears[currentRound][_lastHero].add(_deposit.mul(90).div(100));
616         }
617 
618         if (address(BullsContract) == msg.sender) {
619             require(depositBears[currentRound][_lastHero] == 0, "You are already in bears team");
620             if (depositBulls[currentRound][_lastHero] == 0)
621                 countOfBulls++;
622             totalSupplyOfBulls = totalSupplyOfBulls.add(_deposit.mul(90).div(100));
623             depositBulls[currentRound][_lastHero] = depositBulls[currentRound][_lastHero].add(_deposit.mul(90).div(100));
624         }
625 
626         lastHero = _lastHero;
627 
628         if (currentDeadline.add(120) <= lastDeadline) {
629             currentDeadline = currentDeadline.add(120);
630         } else {
631             currentDeadline = lastDeadline;
632         }
633 
634         jackPot += _deposit.mul(10).div(100);
635 
636         calculateProbability();
637     }
638 
639     function estimateTokenPercent(uint256 _difference) public view returns(uint256){
640         if (rateModifier == 0) {
641             return _difference.mul(rate);
642         } else {
643             return _difference.div(rate);
644         }
645     }
646 
647     /**
648     * @dev Calculation probability for team's win
649     */
650     function calculateProbability() public {
651         require(winner == 0 && getState());
652 
653         totalGWSupplyOfBulls = GameWaveContract.balanceOf(address(BullsContract));
654         totalGWSupplyOfBears = GameWaveContract.balanceOf(address(BearsContract));
655         uint256 percent = (totalSupplyOfBulls.add(totalSupplyOfBears)).div(100);
656 
657         if (totalGWSupplyOfBulls < 1 ether) {
658             totalGWSupplyOfBulls = 0;
659         }
660 
661         if (totalGWSupplyOfBears < 1 ether) {
662             totalGWSupplyOfBears = 0;
663         }
664 
665         if (totalGWSupplyOfBulls <= totalGWSupplyOfBears) {
666             uint256 difference = totalGWSupplyOfBears.sub(totalGWSupplyOfBulls).div(0.01 ether);
667 
668             probabilityOfBears = totalSupplyOfBears.mul(100).div(percent).add(estimateTokenPercent(difference));
669 
670             if (probabilityOfBears > 8000) {
671                 probabilityOfBears = 8000;
672             }
673             if (probabilityOfBears < 2000) {
674                 probabilityOfBears = 2000;
675             }
676             probabilityOfBulls = 10000 - probabilityOfBears;
677         } else {
678             uint256 difference = totalGWSupplyOfBulls.sub(totalGWSupplyOfBears).div(0.01 ether);
679             probabilityOfBulls = totalSupplyOfBulls.mul(100).div(percent).add(estimateTokenPercent(difference));
680 
681             if (probabilityOfBulls > 8000) {
682                 probabilityOfBulls = 8000;
683             }
684             if (probabilityOfBulls < 2000) {
685                 probabilityOfBulls = 2000;
686             }
687             probabilityOfBears = 10000 - probabilityOfBulls;
688         }
689 
690         totalGWSupplyOfBulls = GameWaveContract.balanceOf(address(BullsContract));
691         totalGWSupplyOfBears = GameWaveContract.balanceOf(address(BearsContract));
692     }
693 
694     /**
695     * @dev Getting winner team
696     */
697     function getWinners() public {
698         require(winner == 0 && !getState());
699         uint256 seed1 = address(this).balance;
700         uint256 seed2 = totalSupplyOfBulls;
701         uint256 seed3 = totalSupplyOfBears;
702         uint256 seed4 = totalGWSupplyOfBulls;
703         uint256 seed5 = totalGWSupplyOfBulls;
704         uint256 seed6 = block.difficulty;
705         uint256 seed7 = block.timestamp;
706 
707         bytes32 randomHash = keccak256(abi.encodePacked(seed1, seed2, seed3, seed4, seed5, seed6, seed7));
708         uint randomNumber = uint(randomHash);
709 
710         if (randomNumber == 0){
711             randomNumber = 1;
712         }
713 
714         uint winningNumber = randomNumber % 10000;
715 
716         if (1 <= winningNumber && winningNumber <= probabilityOfBears){
717             winner = 1;
718         }
719 
720         if (probabilityOfBears < winningNumber && winningNumber <= 10000){
721             winner = 2;
722         }
723 
724         if (GameWaveContract.balanceOf(address(BullsContract)) > 0)
725             GameWaveContract.transferFrom(
726                 address(BullsContract),
727                 address(this),
728                 GameWaveContract.balanceOf(address(BullsContract))
729             );
730 
731         if (GameWaveContract.balanceOf(address(BearsContract)) > 0)
732             GameWaveContract.transferFrom(
733                 address(BearsContract),
734                 address(this),
735                 GameWaveContract.balanceOf(address(BearsContract))
736             );
737 
738         lastTotalSupplyOfBulls = totalSupplyOfBulls;
739         lastTotalSupplyOfBears = totalSupplyOfBears;
740         lastTotalGWSupplyOfBears = totalGWSupplyOfBears;
741         lastTotalGWSupplyOfBulls = totalGWSupplyOfBulls;
742         lastRoundHero = lastHero;
743         lastJackPot = jackPot;
744         lastWinner = winner;
745         lastCountOfBears = countOfBears;
746         lastCountOfBulls = countOfBulls;
747         lastWithdrawn = withdrawn;
748         lastWithdrawnGW = withdrawnGW;
749 
750         if (lastBalance > lastWithdrawn){
751             remainder = lastBalance.sub(lastWithdrawn);
752             address(GameWaveContract).transfer(remainder);
753         }
754 
755         lastBalance = lastTotalSupplyOfBears.add(lastTotalSupplyOfBulls).add(lastJackPot);
756 
757         if (lastBalanceGW > lastWithdrawnGW){
758             remainderGW = lastBalanceGW.sub(lastWithdrawnGW);
759             tokenReturn = (totalGWSupplyOfBears.add(totalGWSupplyOfBulls)).mul(20).div(100).add(remainderGW);
760             GameWaveContract.transfer(crowdSale, tokenReturn);
761         }
762 
763         lastBalanceGW = GameWaveContract.balanceOf(address(this));
764 
765         totalSupplyOfBulls = 0;
766         totalSupplyOfBears = 0;
767         totalGWSupplyOfBulls = 0;
768         totalGWSupplyOfBears = 0;
769         remainder = 0;
770         remainderGW = 0;
771         jackPot = 0;
772 
773         withdrawn = 0;
774         winner = 0;
775         withdrawnGW = 0;
776         countOfBears = 0;
777         countOfBulls = 0;
778         probabilityOfBulls = 0;
779         probabilityOfBears = 0;
780 
781         _setRoundTime(defaultCurrentDeadlineInHours, defaultLastDeadlineInHours);
782         currentRound++;
783     }
784 
785     /**
786     * @dev Payable function for take prize
787     */
788     function () external payable {
789         if (msg.value == 0){
790             require(depositBears[currentRound - 1][msg.sender] > 0 || depositBulls[currentRound - 1][msg.sender] > 0);
791 
792             uint payout = 0;
793             uint payoutGW = 0;
794 
795             if (lastWinner == 1 && depositBears[currentRound - 1][msg.sender] > 0) {
796                 payout = calculateLastETHPrize(msg.sender);
797             }
798             if (lastWinner == 2 && depositBulls[currentRound - 1][msg.sender] > 0) {
799                 payout = calculateLastETHPrize(msg.sender);
800             }
801 
802             if (payout > 0) {
803                 depositBears[currentRound - 1][msg.sender] = 0;
804                 depositBulls[currentRound - 1][msg.sender] = 0;
805                 withdrawn = withdrawn.add(payout);
806                 msg.sender.transfer(payout);
807             }
808 
809             if ((lastWinner == 1 && depositBears[currentRound - 1][msg.sender] == 0) || (lastWinner == 2 && depositBulls[currentRound - 1][msg.sender] == 0)) {
810                 payoutGW = calculateLastGWPrize(msg.sender);
811                 withdrawnGW = withdrawnGW.add(payoutGW);
812                 GameWaveContract.transfer(msg.sender, payoutGW);
813             }
814 
815             if (msg.sender == lastRoundHero) {
816                 lastHeroHistory = lastRoundHero;
817                 lastRoundHero = address(0x0);
818                 withdrawn = withdrawn.add(lastJackPot);
819                 msg.sender.transfer(lastJackPot);
820             }
821         }
822     }
823 
824     /**
825     * @dev Getting ETH prize of participant
826     * @param participant Address of participant
827     */
828     function calculateETHPrize(address participant) public view returns(uint) {
829 
830         uint payout = 0;
831         uint256 totalSupply = (totalSupplyOfBears.add(totalSupplyOfBulls));
832 
833         if (depositBears[currentRound][participant] > 0) {
834             payout = totalSupply.mul(depositBears[currentRound][participant]).div(totalSupplyOfBears);
835         }
836 
837         if (depositBulls[currentRound][participant] > 0) {
838             payout = totalSupply.mul(depositBulls[currentRound][participant]).div(totalSupplyOfBulls);
839         }
840 
841         return payout;
842     }
843 
844     /**
845     * @dev Getting GW Token prize of participant
846     * @param participant Address of participant
847     */
848     function calculateGWPrize(address participant) public view returns(uint) {
849 
850         uint payout = 0;
851         uint totalSupply = (totalGWSupplyOfBears.add(totalGWSupplyOfBulls)).mul(80).div(100);
852 
853         if (depositBears[currentRound][participant] > 0) {
854             payout = totalSupply.mul(depositBears[currentRound][participant]).div(totalSupplyOfBears);
855         }
856 
857         if (depositBulls[currentRound][participant] > 0) {
858             payout = totalSupply.mul(depositBulls[currentRound][participant]).div(totalSupplyOfBulls);
859         }
860 
861         return payout;
862     }
863 
864     /**
865     * @dev Getting ETH prize of _lastParticipant
866     * @param _lastParticipant Address of _lastParticipant
867     */
868     function calculateLastETHPrize(address _lastParticipant) public view returns(uint) {
869 
870         uint payout = 0;
871         uint256 totalSupply = (lastTotalSupplyOfBears.add(lastTotalSupplyOfBulls));
872 
873         if (depositBears[currentRound - 1][_lastParticipant] > 0) {
874             payout = totalSupply.mul(depositBears[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBears);
875         }
876 
877         if (depositBulls[currentRound - 1][_lastParticipant] > 0) {
878             payout = totalSupply.mul(depositBulls[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBulls);
879         }
880 
881         return payout;
882     }
883 
884     /**
885     * @dev Getting GW Token prize of _lastParticipant
886     * @param _lastParticipant Address of _lastParticipant
887     */
888     function calculateLastGWPrize(address _lastParticipant) public view returns(uint) {
889 
890         uint payout = 0;
891         uint totalSupply = (lastTotalGWSupplyOfBears.add(lastTotalGWSupplyOfBulls)).mul(80).div(100);
892 
893         if (depositBears[currentRound - 1][_lastParticipant] > 0) {
894             payout = totalSupply.mul(depositBears[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBears);
895         }
896 
897         if (depositBulls[currentRound - 1][_lastParticipant] > 0) {
898             payout = totalSupply.mul(depositBulls[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBulls);
899         }
900 
901         return payout;
902     }
903 }
904 
905 contract GameWave is ERC20, ERC20Detailed, Ownable {
906 
907   uint paymentsTime = block.timestamp;
908   uint totalPaymentAmount;
909   uint lastTotalPaymentAmount;
910   uint minted = 20000000;
911 
912   mapping (address => uint256) lastWithdrawTime;
913 
914   /**
915    * @dev The GW constructor sets the original variables
916    * specified in the contract ERC20Detailed.
917    */
918   constructor() public ERC20Detailed("Game wave token", "GWT", 18) {
919     _mint(msg.sender, minted * (10 ** uint256(decimals())));
920   }
921 
922   /**
923     * Fallback function
924     *
925     * The function without name is the default function that is called whenever anyone sends funds to a contract.
926     */
927   function () payable external {
928     if (msg.value == 0){
929       withdrawDividends(msg.sender);
930     }
931   }
932 
933   /**
934     * @notice This function allows the investor to see the amount of dividends available for withdrawal.
935     * @param _holder this is the address of the investor, where you can see the number of diverders available for withdrawal.
936     * @return An uint the value available for the removal of dividends.
937     */
938   function getDividends(address _holder) view public returns(uint) {
939     if (paymentsTime >= lastWithdrawTime[_holder]){
940       return totalPaymentAmount.mul(balanceOf(_holder)).div(minted * (10 ** uint256(decimals())));
941     } else {
942       return 0;
943     }
944   }
945 
946   /**
947     * @notice This function allows the investor to withdraw dividends available for withdrawal.
948     * @param _holder this is the address of the investor, by which there is a withdrawal available to dividend.
949     * @return An uint value of removed dividends.
950     */
951   function withdrawDividends(address payable _holder) public returns(uint) {
952     uint dividends = getDividends(_holder);
953     lastWithdrawTime[_holder] = block.timestamp;
954     lastTotalPaymentAmount = lastTotalPaymentAmount.add(dividends);
955     _holder.transfer(dividends);
956   }
957 
958   /**
959   * @notice This function initializes payments with a period of 30 days.
960   *
961   */
962 
963   function startPayments() public {
964     require(block.timestamp >= paymentsTime + 30 days);
965     owner.transfer(totalPaymentAmount.sub(lastTotalPaymentAmount));
966     totalPaymentAmount = address(this).balance;
967     paymentsTime = block.timestamp;
968     lastTotalPaymentAmount = 0;
969   }
970 }
971 
972 /**
973 * @dev Base contract for teams
974 */
975 contract CryptoTeam {
976     using SafeMath for uint256;
977 
978     //Developers fund
979     address payable public owner;
980 
981     Bank public BankContract;
982     GameWave public GameWaveContract;
983 
984     constructor() public {
985         owner = msg.sender;
986     }
987     
988     /**
989     * @dev Payable function. 10% will send to Developers fund and 90% will send to JackPot contract.
990     * Also setting info about player.
991     */
992     function () external payable {
993         require(BankContract.getState() && msg.value >= 0.05 ether);
994 
995         BankContract.setInfo(msg.sender, msg.value.mul(90).div(100));
996 
997         owner.transfer(msg.value.mul(10).div(100));
998         
999         address(BankContract).transfer(msg.value.mul(90).div(100));
1000     }
1001 }
1002 
1003 /*
1004 * @dev Bears contract. To play game with Bears send ETH to this contract
1005 */
1006 contract Bears is CryptoTeam {
1007     constructor(address payable _bankAddress, address payable _GameWaveAddress) public {
1008         BankContract = Bank(_bankAddress);
1009         BankContract.setBearsAddress(address(this));
1010         GameWaveContract = GameWave(_GameWaveAddress);
1011         GameWaveContract.approve(_bankAddress, 9999999999999999999000000000000000000);
1012     }
1013 }
1014 
1015 /*
1016 * @dev Bulls contract. To play game with Bulls send ETH to this contract
1017 */
1018 contract Bulls is CryptoTeam {
1019     constructor(address payable _bankAddress, address payable _GameWaveAddress) public {
1020         BankContract = Bank(_bankAddress);
1021         BankContract.setBullsAddress(address(this));
1022         GameWaveContract = GameWave(_GameWaveAddress);
1023         GameWaveContract.approve(_bankAddress, 9999999999999999999000000000000000000);
1024     }
1025 }
1026 
1027 /*
1028 * @dev Crowdsal contract
1029 */
1030 contract Sale {
1031 
1032     GameWave public GWContract;
1033     uint256 public buyPrice;
1034     address public owner;
1035     uint balance;
1036 
1037     bool crowdSaleClosed = false;
1038 
1039     constructor(
1040         address payable _GWContract
1041     ) payable public {
1042         owner = msg.sender;
1043         GWContract = GameWave(_GWContract);
1044         GWContract.approve(owner, 9999999999999999999000000000000000000);
1045     }
1046 
1047     /**
1048      * @notice Allow users to buy tokens for `newBuyPrice`
1049      * @param newBuyPrice Price users can buy from the contract.
1050      */
1051 
1052     function setPrice(uint256 newBuyPrice) public {
1053         buyPrice = newBuyPrice;
1054     }
1055 
1056     /**
1057      * Fallback function
1058      *
1059      * The function without name is the default function that is called whenever anyone sends funds to a contract and
1060      * sends tokens to the buyer.
1061      */
1062 
1063     function () payable external {
1064         uint amount = msg.value;
1065         balance = (amount / buyPrice) * 10 ** 18;
1066         GWContract.transfer(msg.sender, balance);
1067         address(GWContract).transfer(amount);
1068     }
1069 }