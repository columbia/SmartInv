1 pragma solidity 0.5.6;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8   function totalSupply() external view returns (uint256);
9 
10   function balanceOf(address who) external view returns (uint256);
11 
12   function allowance(address owner, address spender)
13   external view returns (uint256);
14 
15   function transfer(address to, uint256 value) external returns (bool);
16 
17   function approve(address spender, uint256 value)
18   external returns (bool);
19 
20   function transferFrom(address from, address to, uint256 value)
21   external returns (bool);
22 
23   event Transfer(
24     address indexed from,
25     address indexed to,
26     uint256 value
27   );
28 
29   event Approval(
30     address indexed owner,
31     address indexed spender,
32     uint256 value
33   );
34 }
35 
36 /**
37  * @title SafeMath
38  * @dev Unsigned math operations with safety checks that revert on error
39  */
40 library SafeMath {
41   /**
42    * @dev Multiplies two unsigned integers, reverts on overflow.
43    */
44   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
46     // benefit is lost if 'b' is also tested.
47     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
48     if (a == 0) {
49       return 0;
50     }
51 
52     uint256 c = a * b;
53     require(c / a == b);
54 
55     return c;
56   }
57 
58   /**
59    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
60    */
61   function div(uint256 a, uint256 b) internal pure returns (uint256) {
62     // Solidity only automatically asserts when dividing by 0
63     require(b > 0);
64     uint256 c = a / b;
65     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
66 
67     return c;
68   }
69 
70   /**
71    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
72    */
73   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74     require(b <= a);
75     uint256 c = a - b;
76 
77     return c;
78   }
79 
80   /**
81    * @dev Adds two unsigned integers, reverts on overflow.
82    */
83   function add(uint256 a, uint256 b) internal pure returns (uint256) {
84     uint256 c = a + b;
85     require(c >= a);
86 
87     return c;
88   }
89 
90   /**
91    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
92    * reverts when dividing by zero.
93    */
94   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
95     require(b != 0);
96     return a % b;
97   }
98 }
99 
100 /**
101  * @title Standard ERC20 token
102  *
103  * @dev Implementation of the basic standard token.
104  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
105  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
106  */
107 contract ERC20 is IERC20 {
108   using SafeMath for uint256;
109 
110   mapping (address => uint256) private _balances;
111 
112   mapping (address => mapping (address => uint256)) private _allowed;
113 
114   uint256 private _totalSupply;
115 
116   /**
117   * @dev Total number of tokens in existence
118   */
119   function totalSupply() public view returns (uint256) {
120     return _totalSupply;
121   }
122 
123   /**
124   * @dev Gets the balance of the specified address.
125   * @param owner The address to query the balance of.
126   * @return An uint256 representing the amount owned by the passed address.
127   */
128   function balanceOf(address owner) public view returns (uint256) {
129     return _balances[owner];
130   }
131 
132   /**
133    * @dev Function to check the amount of tokens that an owner allowed to a spender.
134    * @param owner address The address which owns the funds.
135    * @param spender address The address which will spend the funds.
136    * @return A uint256 specifying the amount of tokens still available for the spender.
137    */
138   function allowance(
139     address owner,
140     address spender
141   )
142   public
143   view
144   returns (uint256)
145   {
146     return _allowed[owner][spender];
147   }
148 
149   /**
150   * @dev Transfer token for a specified address
151   * @param to The address to transfer to.
152   * @param value The amount to be transferred.
153   */
154   function transfer(address to, uint256 value) public returns (bool) {
155     _transfer(msg.sender, to, value);
156 
157     return true;
158   }
159 
160   /**
161    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
162    * Beware that changing an allowance with this method brings the risk that someone may use both the old
163    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
164    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
165    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166    * @param spender The address which will spend the funds.
167    * @param value The amount of tokens to be spent.
168    */
169   function approve(address spender, uint256 value) public returns (bool) {
170     require(spender != address(0));
171 
172     _allowed[msg.sender][spender] = value;
173 
174     emit Approval(msg.sender, spender, value);
175 
176     return true;
177   }
178 
179   /**
180    * @dev Transfer tokens from one address to another
181    * @param from address The address which you want to send tokens from
182    * @param to address The address which you want to transfer to
183    * @param value uint256 the amount of tokens to be transferred
184    */
185   function transferFrom(
186     address from,
187     address to,
188     uint256 value
189   )
190   public
191   returns (bool)
192   {
193     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
194     _transfer(from, to, value);
195 
196     return true;
197   }
198 
199   /**
200    * @dev Increase the amount of tokens that an owner allowed to a spender.
201    * approve should be called when allowed_[_spender] == 0. To increment
202    * allowed value is better to use this function to avoid 2 calls (and wait until
203    * the first transaction is mined)
204    * From MonolithDAO Token.sol
205    * @param spender The address which will spend the funds.
206    * @param addedValue The amount of tokens to increase the allowance by.
207    */
208   function increaseAllowance(
209     address spender,
210     uint256 addedValue
211   )
212   public
213   returns (bool)
214   {
215     require(spender != address(0));
216 
217     _allowed[msg.sender][spender] = (
218     _allowed[msg.sender][spender].add(addedValue));
219 
220     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
221 
222     return true;
223   }
224 
225   /**
226    * @dev Decrease the amount of tokens that an owner allowed to a spender.
227    * approve should be called when allowed_[_spender] == 0. To decrement
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param spender The address which will spend the funds.
232    * @param subtractedValue The amount of tokens to decrease the allowance by.
233    */
234   function decreaseAllowance(
235     address spender,
236     uint256 subtractedValue
237   )
238   public
239   returns (bool)
240   {
241     require(spender != address(0));
242 
243     _allowed[msg.sender][spender] = (
244     _allowed[msg.sender][spender].sub(subtractedValue));
245 
246     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
247 
248     return true;
249   }
250 
251   /**
252   * @dev Transfer token for a specified addresses
253   * @param from The address to transfer from.
254   * @param to The address to transfer to.
255   * @param value The amount to be transferred.
256   */
257   function _transfer(address from, address to, uint256 value) internal {
258     require(to != address(0));
259 
260     _balances[from] = _balances[from].sub(value);
261     _balances[to] = _balances[to].add(value);
262 
263     emit Transfer(from, to, value);
264   }
265 
266   /**
267    * @dev Internal function that mints an amount of the token and assigns it to
268    * an account. This encapsulates the modification of balances such that the
269    * proper events are emitted.
270    * @param account The account that will receive the created tokens.
271    * @param value The amount that will be created.
272    */
273   function _mint(address account, uint256 value) internal {
274     require(account != address(0));
275 
276     _totalSupply = _totalSupply.add(value);
277     _balances[account] = _balances[account].add(value);
278 
279     emit Transfer(address(0), account, value);
280   }
281 
282   /**
283    * @dev Internal function that burns an amount of the token of a given
284    * account.
285    * @param account The account whose tokens will be burnt.
286    * @param value The amount that will be burnt.
287    */
288   function _burn(address account, uint256 value) internal {
289     require(account != address(0));
290 
291     _totalSupply = _totalSupply.sub(value);
292     _balances[account] = _balances[account].sub(value);
293 
294     emit Transfer(account, address(0), value);
295   }
296 
297   /**
298    * @dev Internal function that burns an amount of the token of a given
299    * account, deducting from the sender's allowance for said account. Uses the
300    * internal burn function.
301    * @param account The account whose tokens will be burnt.
302    * @param value The amount that will be burnt.
303    */
304   function _burnFrom(address account, uint256 value) internal {
305     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
306     // this function needs to emit an event with the updated approval.
307     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
308       value);
309     _burn(account, value);
310   }
311 }
312 
313 /**
314  * @title SafeERC20
315  * @dev Wrappers around ERC20 operations that throw on failure.
316  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
317  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
318  */
319 library SafeERC20 {
320 
321   using SafeMath for uint256;
322 
323   function safeTransfer(
324     IERC20 token,
325     address to,
326     uint256 value
327   )
328   internal
329   {
330     require(token.transfer(to, value));
331   }
332 
333   function safeTransferFrom(
334     IERC20 token,
335     address from,
336     address to,
337     uint256 value
338   )
339   internal
340   {
341     require(token.transferFrom(from, to, value));
342   }
343 
344   function safeApprove(
345     IERC20 token,
346     address spender,
347     uint256 value
348   )
349   internal
350   {
351     // safeApprove should only be called when setting an initial allowance,
352     // or when resetting it to zero. To increase and decrease it, use
353     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
354     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
355     require(token.approve(spender, value));
356   }
357 
358   function safeIncreaseAllowance(
359     IERC20 token,
360     address spender,
361     uint256 value
362   )
363   internal
364   {
365     uint256 newAllowance = token.allowance(address(this), spender).add(value);
366     require(token.approve(spender, newAllowance));
367   }
368 
369   function safeDecreaseAllowance(
370     IERC20 token,
371     address spender,
372     uint256 value
373   )
374   internal
375   {
376     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
377     require(token.approve(spender, newAllowance));
378   }
379 }
380 
381 /**
382  * @title ERC20Detailed token
383  * @dev The decimals are only for visualization purposes.
384  * All the operations are done using the smallest and indivisible token unit,
385  * just as on Ethereum all the operations are done in wei.
386  */
387 contract ERC20Detailed is IERC20 {
388   string private _name;
389   string private _symbol;
390   uint8 private _decimals;
391 
392   constructor(string memory name, string memory symbol, uint8 decimals) public {
393     _name = name;
394     _symbol = symbol;
395     _decimals = decimals;
396   }
397 
398   /**
399    * @return the name of the token.
400    */
401   function name() public view returns(string memory) {
402     return _name;
403   }
404 
405   /**
406    * @return the symbol of the token.
407    */
408   function symbol() public view returns(string memory) {
409     return _symbol;
410   }
411 
412   /**
413    * @return the number of decimals of the token.
414    */
415   function decimals() public view returns(uint8) {
416     return _decimals;
417   }
418 }
419 
420 contract Ownable {
421   address payable public owner;
422   /**
423    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
424    * account.
425    */
426   constructor() public {
427     owner = msg.sender;
428   }
429   /**
430    * @dev Throws if called by any account other than the owner.
431    */
432   modifier onlyOwner() {
433     require(msg.sender == owner);
434     _;
435   }
436   function transferOwnership(address payable newOwner) public onlyOwner {
437     require(newOwner != address(0));
438     owner = newOwner;
439   }
440 }
441 
442 
443 
444 contract GameWave is ERC20, ERC20Detailed, Ownable {
445 
446   uint paymentsTime = block.timestamp;
447   uint totalPaymentAmount;
448   uint lastTotalPaymentAmount;
449   uint minted = 20000000;
450 
451   mapping (address => uint256) lastWithdrawTime;
452 
453   /**
454    * @dev The GW constructor sets the original variables
455    * specified in the contract ERC20Detailed.
456    */
457   constructor() public ERC20Detailed("Game wave token", "GWT", 18) {
458     _mint(msg.sender, minted * (10 ** uint256(decimals())));
459   }
460 
461   /**
462     * Fallback function
463     *
464     * The function without name is the default function that is called whenever anyone sends funds to a contract.
465     */
466   function () payable external {
467     if (msg.value == 0){
468       withdrawDividends(msg.sender);
469     }
470   }
471 
472   /**
473     * @notice This function allows the investor to see the amount of dividends available for withdrawal.
474     * @param _holder this is the address of the investor, where you can see the number of diverders available for withdrawal.
475     * @return An uint the value available for the removal of dividends.
476     */
477   function getDividends(address _holder) view public returns(uint) {
478     if (paymentsTime >= lastWithdrawTime[_holder]){
479       return totalPaymentAmount.mul(balanceOf(_holder)).div(minted * (10 ** uint256(decimals())));
480     } else {
481       return 0;
482     }
483   }
484 
485   /**
486     * @notice This function allows the investor to withdraw dividends available for withdrawal.
487     * @param _holder this is the address of the investor, by which there is a withdrawal available to dividend.
488     * @return An uint value of removed dividends.
489     */
490   function withdrawDividends(address payable _holder) public returns(uint) {
491     uint dividends = getDividends(_holder);
492     lastWithdrawTime[_holder] = block.timestamp;
493     lastTotalPaymentAmount = lastTotalPaymentAmount.add(dividends);
494     _holder.transfer(dividends);
495   }
496 
497   /**
498   * @notice This function initializes payments with a period of 30 days.
499   *
500   */
501 
502   function startPayments() public {
503     require(block.timestamp >= paymentsTime + 30 days);
504     owner.transfer(totalPaymentAmount.sub(lastTotalPaymentAmount));
505     totalPaymentAmount = address(this).balance;
506     paymentsTime = block.timestamp;
507     lastTotalPaymentAmount = 0;
508   }
509 }
510 
511 /*
512 * @title Bank
513 * @dev Bank contract which contained all ETH from Bears and Bulls teams.
514 * When time in blockchain will be grater then current deadline or last deadline need call getWinner function
515 * then participants able get prizes.
516 *
517 * Last participant(last hero) win 10% from all bank
518 *
519 * - To get prize send 0 ETH to this contract
520 */
521 contract Bank is Ownable {
522 
523     using SafeMath for uint256;
524 
525     mapping (uint256 => mapping (address => uint256)) public depositBears;
526     mapping (uint256 => mapping (address => uint256)) public depositBulls;
527 
528     uint256 public currentDeadline;
529     uint256 public currentRound = 1;
530     uint256 public lastDeadline;
531     uint256 public defaultCurrentDeadlineInHours = 24;
532     uint256 public defaultLastDeadlineInHours = 48;
533     uint256 public countOfBears;
534     uint256 public countOfBulls;
535     uint256 public totalSupplyOfBulls;
536     uint256 public totalSupplyOfBears;
537     uint256 public totalGWSupplyOfBulls;
538     uint256 public totalGWSupplyOfBears;
539     uint256 public probabilityOfBulls;
540     uint256 public probabilityOfBears;
541     address public lastHero;
542     address public lastHeroHistory;
543     uint256 public jackPot;
544     uint256 public winner;
545     uint256 public withdrawn;
546     uint256 public withdrawnGW;
547     uint256 public remainder;
548     uint256 public remainderGW;
549     uint256 public rate = 1;
550     uint256 public rateModifier = 0;
551     uint256 public tokenReturn;
552     address crowdSale;
553 
554     uint256 public lastTotalSupplyOfBulls;
555     uint256 public lastTotalSupplyOfBears;
556     uint256 public lastTotalGWSupplyOfBulls;
557     uint256 public lastTotalGWSupplyOfBears;
558     uint256 public lastProbabilityOfBulls;
559     uint256 public lastProbabilityOfBears;
560     address public lastRoundHero;
561     uint256 public lastJackPot;
562     uint256 public lastWinner;
563     uint256 public lastBalance;
564     uint256 public lastBalanceGW;
565     uint256 public lastCountOfBears;
566     uint256 public lastCountOfBulls;
567     uint256 public lastWithdrawn;
568     uint256 public lastWithdrawnGW;
569 
570 
571     bool public finished = false;
572 
573     Bears public BearsContract;
574     Bulls public BullsContract;
575     GameWave public GameWaveContract;
576 
577     /*
578     * @dev Constructor create first deadline
579     */
580     constructor(address _crowdSale) public {
581         _setRoundTime(6, 8);
582         crowdSale = _crowdSale;
583     }
584 
585     /**
586     * @dev Setter token rate.
587     * @param _rate this value for change percent relation rate to count of tokens.
588     * @param _rateModifier this value for change math operation under tokens.
589     */
590     function setRateToken(uint256 _rate, uint256 _rateModifier) public onlyOwner returns(uint256){
591         rate = _rate;
592         rateModifier = _rateModifier;
593     }
594 
595     /**
596     * @dev Setter crowd sale address.
597     * @param _crowdSale Address of the crowd sale contract.
598     */
599     function setCrowdSale(address _crowdSale) public onlyOwner{
600         crowdSale = _crowdSale;
601     }
602 
603     /**
604     * @dev Setter round time.
605     * @param _currentDeadlineInHours this value current deadline in hours.
606     * @param _lastDeadlineInHours this value last deadline in hours.
607     */
608     function _setRoundTime(uint _currentDeadlineInHours, uint _lastDeadlineInHours) internal {
609         defaultCurrentDeadlineInHours = _currentDeadlineInHours;
610         defaultLastDeadlineInHours = _lastDeadlineInHours;
611         currentDeadline = block.timestamp + 60 * 60 * _currentDeadlineInHours;
612         lastDeadline = block.timestamp + 60 * 60 * _lastDeadlineInHours;
613     }
614 
615     /**
616     * @dev Setter round time.
617     * @param _currentDeadlineInHours this value current deadline in hours.
618     * @param _lastDeadlineInHours this value last deadline in hours.
619     */
620     function setRoundTime(uint _currentDeadlineInHours, uint _lastDeadlineInHours) public onlyOwner {
621         _setRoundTime(_currentDeadlineInHours, _lastDeadlineInHours);
622     }
623 
624 
625     /**
626     * @dev Setter the GameWave contract address. Address can be set at once.
627     * @param _GameWaveAddress Address of the GameWave contract
628     */
629     function setGameWaveAddress(address payable _GameWaveAddress) public {
630         require(address(GameWaveContract) == address(0x0));
631         GameWaveContract = GameWave(_GameWaveAddress);
632     }
633 
634     /**
635     * @dev Setter the Bears contract address. Address can be set at once.
636     * @param _bearsAddress Address of the Bears contract
637     */
638     function setBearsAddress(address payable _bearsAddress) external {
639         require(address(BearsContract) == address(0x0));
640         BearsContract = Bears(_bearsAddress);
641     }
642 
643     /**
644     * @dev Setter the Bulls contract address. Address can be set at once.
645     * @param _bullsAddress Address of the Bulls contract
646     */
647     function setBullsAddress(address payable _bullsAddress) external {
648         require(address(BullsContract) == address(0x0));
649         BullsContract = Bulls(_bullsAddress);
650     }
651 
652     /**
653     * @dev Getting time from blockchain for timer
654     */
655     function getNow() view public returns(uint){
656         return block.timestamp;
657     }
658 
659     /**
660     * @dev Getting state of game. True - game continue, False - game stopped
661     */
662     function getState() view public returns(bool) {
663         if (block.timestamp > currentDeadline) {
664             return false;
665         }
666         return true;
667     }
668 
669     /**
670     * @dev Setting info about participant from Bears or Bulls contract
671     * @param _lastHero Address of participant
672     * @param _deposit Amount of deposit
673     */
674     function setInfo(address _lastHero, uint256 _deposit) public {
675         require(address(BearsContract) == msg.sender || address(BullsContract) == msg.sender);
676 
677         if (address(BearsContract) == msg.sender) {
678             require(depositBulls[currentRound][_lastHero] == 0, "You are already in bulls team");
679             if (depositBears[currentRound][_lastHero] == 0)
680                 countOfBears++;
681             totalSupplyOfBears = totalSupplyOfBears.add(_deposit.mul(90).div(100));
682             depositBears[currentRound][_lastHero] = depositBears[currentRound][_lastHero].add(_deposit.mul(90).div(100));
683         }
684 
685         if (address(BullsContract) == msg.sender) {
686             require(depositBears[currentRound][_lastHero] == 0, "You are already in bears team");
687             if (depositBulls[currentRound][_lastHero] == 0)
688                 countOfBulls++;
689             totalSupplyOfBulls = totalSupplyOfBulls.add(_deposit.mul(90).div(100));
690             depositBulls[currentRound][_lastHero] = depositBulls[currentRound][_lastHero].add(_deposit.mul(90).div(100));
691         }
692 
693         lastHero = _lastHero;
694 
695         if (currentDeadline.add(120) <= lastDeadline) {
696             currentDeadline = currentDeadline.add(120);
697         } else {
698             currentDeadline = lastDeadline;
699         }
700 
701         jackPot += _deposit.mul(10).div(100);
702 
703         calculateProbability();
704     }
705 
706     function estimateTokenPercent(uint256 _difference) public view returns(uint256){
707         if (rateModifier == 0) {
708             return _difference.mul(rate);
709         } else {
710             return _difference.div(rate);
711         }
712     }
713 
714     /**
715     * @dev Calculation probability for team's win
716     */
717     function calculateProbability() public {
718         require(winner == 0 && getState());
719 
720         totalGWSupplyOfBulls = GameWaveContract.balanceOf(address(BullsContract));
721         totalGWSupplyOfBears = GameWaveContract.balanceOf(address(BearsContract));
722         uint256 percent = (totalSupplyOfBulls.add(totalSupplyOfBears)).div(100);
723 
724         if (totalGWSupplyOfBulls < 1 ether) {
725             totalGWSupplyOfBulls = 0;
726         }
727 
728         if (totalGWSupplyOfBears < 1 ether) {
729             totalGWSupplyOfBears = 0;
730         }
731 
732         if (totalGWSupplyOfBulls <= totalGWSupplyOfBears) {
733             uint256 difference = totalGWSupplyOfBears.sub(totalGWSupplyOfBulls).div(0.01 ether);
734 
735             probabilityOfBears = totalSupplyOfBears.mul(100).div(percent).add(estimateTokenPercent(difference));
736 
737             if (probabilityOfBears > 8000) {
738                 probabilityOfBears = 8000;
739             }
740             if (probabilityOfBears < 2000) {
741                 probabilityOfBears = 2000;
742             }
743             probabilityOfBulls = 10000 - probabilityOfBears;
744         } else {
745             uint256 difference = totalGWSupplyOfBulls.sub(totalGWSupplyOfBears).div(0.01 ether);
746             probabilityOfBulls = totalSupplyOfBulls.mul(100).div(percent).add(estimateTokenPercent(difference));
747 
748             if (probabilityOfBulls > 8000) {
749                 probabilityOfBulls = 8000;
750             }
751             if (probabilityOfBulls < 2000) {
752                 probabilityOfBulls = 2000;
753             }
754             probabilityOfBears = 10000 - probabilityOfBulls;
755         }
756 
757         totalGWSupplyOfBulls = GameWaveContract.balanceOf(address(BullsContract));
758         totalGWSupplyOfBears = GameWaveContract.balanceOf(address(BearsContract));
759     }
760 
761     /**
762     * @dev Getting winner team
763     */
764     function getWinners() public {
765         require(winner == 0 && !getState());
766         uint256 seed1 = address(this).balance;
767         uint256 seed2 = totalSupplyOfBulls;
768         uint256 seed3 = totalSupplyOfBears;
769         uint256 seed4 = totalGWSupplyOfBulls;
770         uint256 seed5 = totalGWSupplyOfBulls;
771         uint256 seed6 = block.difficulty;
772         uint256 seed7 = block.timestamp;
773 
774         bytes32 randomHash = keccak256(abi.encodePacked(seed1, seed2, seed3, seed4, seed5, seed6, seed7));
775         uint randomNumber = uint(randomHash);
776 
777         if (randomNumber == 0){
778             randomNumber = 1;
779         }
780 
781         uint winningNumber = randomNumber % 10000;
782 
783         if (1 <= winningNumber && winningNumber <= probabilityOfBears){
784             winner = 1;
785         }
786 
787         if (probabilityOfBears < winningNumber && winningNumber <= 10000){
788             winner = 2;
789         }
790 
791         if (GameWaveContract.balanceOf(address(BullsContract)) > 0)
792             GameWaveContract.transferFrom(
793                 address(BullsContract),
794                 address(this),
795                 GameWaveContract.balanceOf(address(BullsContract))
796             );
797 
798         if (GameWaveContract.balanceOf(address(BearsContract)) > 0)
799             GameWaveContract.transferFrom(
800                 address(BearsContract),
801                 address(this),
802                 GameWaveContract.balanceOf(address(BearsContract))
803             );
804 
805         lastTotalSupplyOfBulls = totalSupplyOfBulls;
806         lastTotalSupplyOfBears = totalSupplyOfBears;
807         lastTotalGWSupplyOfBears = totalGWSupplyOfBears;
808         lastTotalGWSupplyOfBulls = totalGWSupplyOfBulls;
809         lastRoundHero = lastHero;
810         lastJackPot = jackPot;
811         lastWinner = winner;
812         lastCountOfBears = countOfBears;
813         lastCountOfBulls = countOfBulls;
814         lastWithdrawn = withdrawn;
815         lastWithdrawnGW = withdrawnGW;
816 
817         if (lastBalance > lastWithdrawn){
818             remainder = lastBalance.sub(lastWithdrawn);
819             address(GameWaveContract).transfer(remainder);
820         }
821 
822         lastBalance = lastTotalSupplyOfBears.add(lastTotalSupplyOfBulls).add(lastJackPot);
823 
824         if (lastBalanceGW > lastWithdrawnGW){
825             remainderGW = lastBalanceGW.sub(lastWithdrawnGW);
826             tokenReturn = (totalGWSupplyOfBears.add(totalGWSupplyOfBulls)).mul(20).div(100).add(remainderGW);
827             GameWaveContract.transfer(crowdSale, tokenReturn);
828         }
829 
830         lastBalanceGW = GameWaveContract.balanceOf(address(this));
831 
832         totalSupplyOfBulls = 0;
833         totalSupplyOfBears = 0;
834         totalGWSupplyOfBulls = 0;
835         totalGWSupplyOfBears = 0;
836         remainder = 0;
837         remainderGW = 0;
838         jackPot = 0;
839 
840         withdrawn = 0;
841         winner = 0;
842         withdrawnGW = 0;
843         countOfBears = 0;
844         countOfBulls = 0;
845         probabilityOfBulls = 0;
846         probabilityOfBears = 0;
847 
848         _setRoundTime(defaultCurrentDeadlineInHours, defaultLastDeadlineInHours);
849         currentRound++;
850     }
851 
852     /**
853     * @dev Payable function for take prize
854     */
855     function () external payable {
856         if (msg.value == 0){
857             require(depositBears[currentRound - 1][msg.sender] > 0 || depositBulls[currentRound - 1][msg.sender] > 0);
858 
859             uint payout = 0;
860             uint payoutGW = 0;
861 
862             if (lastWinner == 1 && depositBears[currentRound - 1][msg.sender] > 0) {
863                 payout = calculateLastETHPrize(msg.sender);
864             }
865             if (lastWinner == 2 && depositBulls[currentRound - 1][msg.sender] > 0) {
866                 payout = calculateLastETHPrize(msg.sender);
867             }
868 
869             if (payout > 0) {
870                 depositBears[currentRound - 1][msg.sender] = 0;
871                 depositBulls[currentRound - 1][msg.sender] = 0;
872                 withdrawn = withdrawn.add(payout);
873                 msg.sender.transfer(payout);
874             }
875 
876             if ((lastWinner == 1 && depositBears[currentRound - 1][msg.sender] == 0) || (lastWinner == 2 && depositBulls[currentRound - 1][msg.sender] == 0)) {
877                 payoutGW = calculateLastGWPrize(msg.sender);
878                 withdrawnGW = withdrawnGW.add(payoutGW);
879                 GameWaveContract.transfer(msg.sender, payoutGW);
880             }
881 
882             if (msg.sender == lastRoundHero) {
883                 lastHeroHistory = lastRoundHero;
884                 lastRoundHero = address(0x0);
885                 withdrawn = withdrawn.add(lastJackPot);
886                 msg.sender.transfer(lastJackPot);
887             }
888         }
889     }
890 
891     /**
892     * @dev Getting ETH prize of participant
893     * @param participant Address of participant
894     */
895     function calculateETHPrize(address participant) public view returns(uint) {
896 
897         uint payout = 0;
898         uint256 totalSupply = (totalSupplyOfBears.add(totalSupplyOfBulls));
899 
900         if (depositBears[currentRound][participant] > 0) {
901             payout = totalSupply.mul(depositBears[currentRound][participant]).div(totalSupplyOfBears);
902         }
903 
904         if (depositBulls[currentRound][participant] > 0) {
905             payout = totalSupply.mul(depositBulls[currentRound][participant]).div(totalSupplyOfBulls);
906         }
907 
908         return payout;
909     }
910 
911     /**
912     * @dev Getting GW Token prize of participant
913     * @param participant Address of participant
914     */
915     function calculateGWPrize(address participant) public view returns(uint) {
916 
917         uint payout = 0;
918         uint totalSupply = (totalGWSupplyOfBears.add(totalGWSupplyOfBulls)).mul(80).div(100);
919 
920         if (depositBears[currentRound][participant] > 0) {
921             payout = totalSupply.mul(depositBears[currentRound][participant]).div(totalSupplyOfBears);
922         }
923 
924         if (depositBulls[currentRound][participant] > 0) {
925             payout = totalSupply.mul(depositBulls[currentRound][participant]).div(totalSupplyOfBulls);
926         }
927 
928         return payout;
929     }
930 
931     /**
932     * @dev Getting ETH prize of _lastParticipant
933     * @param _lastParticipant Address of _lastParticipant
934     */
935     function calculateLastETHPrize(address _lastParticipant) public view returns(uint) {
936 
937         uint payout = 0;
938         uint256 totalSupply = (lastTotalSupplyOfBears.add(lastTotalSupplyOfBulls));
939 
940         if (depositBears[currentRound - 1][_lastParticipant] > 0) {
941             payout = totalSupply.mul(depositBears[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBears);
942         }
943 
944         if (depositBulls[currentRound - 1][_lastParticipant] > 0) {
945             payout = totalSupply.mul(depositBulls[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBulls);
946         }
947 
948         return payout;
949     }
950 
951     /**
952     * @dev Getting GW Token prize of _lastParticipant
953     * @param _lastParticipant Address of _lastParticipant
954     */
955     function calculateLastGWPrize(address _lastParticipant) public view returns(uint) {
956 
957         uint payout = 0;
958         uint totalSupply = (lastTotalGWSupplyOfBears.add(lastTotalGWSupplyOfBulls)).mul(80).div(100);
959 
960         if (depositBears[currentRound - 1][_lastParticipant] > 0) {
961             payout = totalSupply.mul(depositBears[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBears);
962         }
963 
964         if (depositBulls[currentRound - 1][_lastParticipant] > 0) {
965             payout = totalSupply.mul(depositBulls[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBulls);
966         }
967 
968         return payout;
969     }
970 }
971 
972 /**
973 * @dev Base contract for teams
974 */
975 contract CryptoTeam {
976     using SafeMath for uint256;
977 
978     Bank public BankContract;
979     GameWave public GameWaveContract;
980     
981     /**
982     * @dev Payable function. 10% will send to Developers fund and 90% will send to JackPot contract.
983     * Also setting info about player.
984     */
985     function () external payable {
986         require(BankContract.getState() && msg.value >= 0.05 ether);
987 
988         BankContract.setInfo(msg.sender, msg.value.mul(90).div(100));
989 
990         address(GameWaveContract).transfer(msg.value.mul(10).div(100));
991         
992         address(BankContract).transfer(msg.value.mul(90).div(100));
993     }
994 }
995 
996 /*
997 * @dev Bears contract. To play game with Bears send ETH to this contract
998 */
999 contract Bears is CryptoTeam {
1000     constructor(address payable _bankAddress, address payable _GameWaveAddress) public {
1001         BankContract = Bank(_bankAddress);
1002         BankContract.setBearsAddress(address(this));
1003         GameWaveContract = GameWave(_GameWaveAddress);
1004         GameWaveContract.approve(_bankAddress, 9999999999999999999000000000000000000);
1005     }
1006 }
1007 
1008 /*
1009 * @dev Bulls contract. To play game with Bulls send ETH to this contract
1010 */
1011 contract Bulls is CryptoTeam {
1012     constructor(address payable _bankAddress, address payable _GameWaveAddress) public {
1013         BankContract = Bank(_bankAddress);
1014         BankContract.setBullsAddress(address(this));
1015         GameWaveContract = GameWave(_GameWaveAddress);
1016         GameWaveContract.approve(_bankAddress, 9999999999999999999000000000000000000);
1017     }
1018 }
1019 
1020 /*
1021 * @dev Crowdsal contract
1022 */
1023 contract Sale {
1024 
1025     GameWave public GWContract;
1026     uint256 public buyPrice;
1027     address public owner;
1028     uint balance;
1029 
1030     bool crowdSaleClosed = false;
1031 
1032     constructor(
1033         address payable _GWContract
1034     ) payable public {
1035         owner = msg.sender;
1036         GWContract = GameWave(_GWContract);
1037         GWContract.approve(owner, 9999999999999999999000000000000000000);
1038     }
1039 
1040     /**
1041      * @notice Allow users to buy tokens for `newBuyPrice`
1042      * @param newBuyPrice Price users can buy from the contract.
1043      */
1044 
1045     function setPrice(uint256 newBuyPrice) public {
1046         buyPrice = newBuyPrice;
1047     }
1048 
1049     /**
1050      * Fallback function
1051      *
1052      * The function without name is the default function that is called whenever anyone sends funds to a contract and
1053      * sends tokens to the buyer.
1054      */
1055 
1056     function () payable external {
1057         uint amount = msg.value;
1058         balance = (amount / buyPrice) * 10 ** 18;
1059         GWContract.transfer(msg.sender, balance);
1060         address(GWContract).transfer(amount);
1061     }
1062 }