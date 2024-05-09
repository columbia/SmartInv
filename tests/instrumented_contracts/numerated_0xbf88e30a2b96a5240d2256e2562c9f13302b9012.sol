1 pragma solidity 0.5.6;
2 
3 /*
4 * @dev Crowdsal contract
5 */
6 contract Sale {
7 
8     GameWave public GWContract;
9     uint256 public buyPrice;
10     address public owner;
11     uint balance;
12 
13     bool crowdSaleClosed = false;
14 
15     constructor(
16         address payable _GWContract
17     ) payable public {
18         owner = msg.sender;
19         GWContract = GameWave(_GWContract);
20         GWContract.approve(owner, 9999999999999999999000000000000000000);
21     }
22 
23     /**
24      * @notice Allow users to buy tokens for `newBuyPrice`
25      * @param newBuyPrice Price users can buy from the contract.
26      */
27 
28     function setPrice(uint256 newBuyPrice) public {
29         buyPrice = newBuyPrice;
30     }
31 
32     /**
33      * Fallback function
34      *
35      * The function without name is the default function that is called whenever anyone sends funds to a contract and
36      * sends tokens to the buyer.
37      */
38 
39     function () payable external {
40         uint amount = msg.value;
41         balance = (amount / buyPrice) * 10 ** 18;
42         GWContract.transfer(msg.sender, balance);
43         address(GWContract).transfer(amount);
44     }
45 }
46 
47 
48 /**
49  * @title ERC20 interface
50  * @dev see https://github.com/ethereum/EIPs/issues/20
51  */
52 interface IERC20 {
53   function totalSupply() external view returns (uint256);
54 
55   function balanceOf(address who) external view returns (uint256);
56 
57   function allowance(address owner, address spender)
58   external view returns (uint256);
59 
60   function transfer(address to, uint256 value) external returns (bool);
61 
62   function approve(address spender, uint256 value)
63   external returns (bool);
64 
65   function transferFrom(address from, address to, uint256 value)
66   external returns (bool);
67 
68   event Transfer(
69     address indexed from,
70     address indexed to,
71     uint256 value
72   );
73 
74   event Approval(
75     address indexed owner,
76     address indexed spender,
77     uint256 value
78   );
79 }
80 
81 /**
82  * @title SafeMath
83  * @dev Unsigned math operations with safety checks that revert on error
84  */
85 library SafeMath {
86   /**
87    * @dev Multiplies two unsigned integers, reverts on overflow.
88    */
89   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
90     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
91     // benefit is lost if 'b' is also tested.
92     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
93     if (a == 0) {
94       return 0;
95     }
96 
97     uint256 c = a * b;
98     require(c / a == b);
99 
100     return c;
101   }
102 
103   /**
104    * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
105    */
106   function div(uint256 a, uint256 b) internal pure returns (uint256) {
107     // Solidity only automatically asserts when dividing by 0
108     require(b > 0);
109     uint256 c = a / b;
110     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
111 
112     return c;
113   }
114 
115   /**
116    * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
117    */
118   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119     require(b <= a);
120     uint256 c = a - b;
121 
122     return c;
123   }
124 
125   /**
126    * @dev Adds two unsigned integers, reverts on overflow.
127    */
128   function add(uint256 a, uint256 b) internal pure returns (uint256) {
129     uint256 c = a + b;
130     require(c >= a);
131 
132     return c;
133   }
134 
135   /**
136    * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
137    * reverts when dividing by zero.
138    */
139   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140     require(b != 0);
141     return a % b;
142   }
143 }
144 
145 /**
146  * @title Standard ERC20 token
147  *
148  * @dev Implementation of the basic standard token.
149  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
150  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract ERC20 is IERC20 {
153   using SafeMath for uint256;
154 
155   mapping (address => uint256) private _balances;
156 
157   mapping (address => mapping (address => uint256)) private _allowed;
158 
159   uint256 private _totalSupply;
160 
161   /**
162   * @dev Total number of tokens in existence
163   */
164   function totalSupply() public view returns (uint256) {
165     return _totalSupply;
166   }
167 
168   /**
169   * @dev Gets the balance of the specified address.
170   * @param owner The address to query the balance of.
171   * @return An uint256 representing the amount owned by the passed address.
172   */
173   function balanceOf(address owner) public view returns (uint256) {
174     return _balances[owner];
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param owner address The address which owns the funds.
180    * @param spender address The address which will spend the funds.
181    * @return A uint256 specifying the amount of tokens still available for the spender.
182    */
183   function allowance(
184     address owner,
185     address spender
186   )
187   public
188   view
189   returns (uint256)
190   {
191     return _allowed[owner][spender];
192   }
193 
194   /**
195   * @dev Transfer token for a specified address
196   * @param to The address to transfer to.
197   * @param value The amount to be transferred.
198   */
199   function transfer(address to, uint256 value) public returns (bool) {
200     _transfer(msg.sender, to, value);
201 
202     return true;
203   }
204 
205   /**
206    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
207    * Beware that changing an allowance with this method brings the risk that someone may use both the old
208    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
209    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
210    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
211    * @param spender The address which will spend the funds.
212    * @param value The amount of tokens to be spent.
213    */
214   function approve(address spender, uint256 value) public returns (bool) {
215     require(spender != address(0));
216 
217     _allowed[msg.sender][spender] = value;
218 
219     emit Approval(msg.sender, spender, value);
220 
221     return true;
222   }
223 
224   /**
225    * @dev Transfer tokens from one address to another
226    * @param from address The address which you want to send tokens from
227    * @param to address The address which you want to transfer to
228    * @param value uint256 the amount of tokens to be transferred
229    */
230   function transferFrom(
231     address from,
232     address to,
233     uint256 value
234   )
235   public
236   returns (bool)
237   {
238     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
239     _transfer(from, to, value);
240 
241     return true;
242   }
243 
244   /**
245    * @dev Increase the amount of tokens that an owner allowed to a spender.
246    * approve should be called when allowed_[_spender] == 0. To increment
247    * allowed value is better to use this function to avoid 2 calls (and wait until
248    * the first transaction is mined)
249    * From MonolithDAO Token.sol
250    * @param spender The address which will spend the funds.
251    * @param addedValue The amount of tokens to increase the allowance by.
252    */
253   function increaseAllowance(
254     address spender,
255     uint256 addedValue
256   )
257   public
258   returns (bool)
259   {
260     require(spender != address(0));
261 
262     _allowed[msg.sender][spender] = (
263     _allowed[msg.sender][spender].add(addedValue));
264 
265     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
266 
267     return true;
268   }
269 
270   /**
271    * @dev Decrease the amount of tokens that an owner allowed to a spender.
272    * approve should be called when allowed_[_spender] == 0. To decrement
273    * allowed value is better to use this function to avoid 2 calls (and wait until
274    * the first transaction is mined)
275    * From MonolithDAO Token.sol
276    * @param spender The address which will spend the funds.
277    * @param subtractedValue The amount of tokens to decrease the allowance by.
278    */
279   function decreaseAllowance(
280     address spender,
281     uint256 subtractedValue
282   )
283   public
284   returns (bool)
285   {
286     require(spender != address(0));
287 
288     _allowed[msg.sender][spender] = (
289     _allowed[msg.sender][spender].sub(subtractedValue));
290 
291     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
292 
293     return true;
294   }
295 
296   /**
297   * @dev Transfer token for a specified addresses
298   * @param from The address to transfer from.
299   * @param to The address to transfer to.
300   * @param value The amount to be transferred.
301   */
302   function _transfer(address from, address to, uint256 value) internal {
303     require(to != address(0));
304 
305     _balances[from] = _balances[from].sub(value);
306     _balances[to] = _balances[to].add(value);
307 
308     emit Transfer(from, to, value);
309   }
310 
311   /**
312    * @dev Internal function that mints an amount of the token and assigns it to
313    * an account. This encapsulates the modification of balances such that the
314    * proper events are emitted.
315    * @param account The account that will receive the created tokens.
316    * @param value The amount that will be created.
317    */
318   function _mint(address account, uint256 value) internal {
319     require(account != address(0));
320 
321     _totalSupply = _totalSupply.add(value);
322     _balances[account] = _balances[account].add(value);
323 
324     emit Transfer(address(0), account, value);
325   }
326 
327   /**
328    * @dev Internal function that burns an amount of the token of a given
329    * account.
330    * @param account The account whose tokens will be burnt.
331    * @param value The amount that will be burnt.
332    */
333   function _burn(address account, uint256 value) internal {
334     require(account != address(0));
335 
336     _totalSupply = _totalSupply.sub(value);
337     _balances[account] = _balances[account].sub(value);
338 
339     emit Transfer(account, address(0), value);
340   }
341 
342   /**
343    * @dev Internal function that burns an amount of the token of a given
344    * account, deducting from the sender's allowance for said account. Uses the
345    * internal burn function.
346    * @param account The account whose tokens will be burnt.
347    * @param value The amount that will be burnt.
348    */
349   function _burnFrom(address account, uint256 value) internal {
350     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
351     // this function needs to emit an event with the updated approval.
352     _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(
353       value);
354     _burn(account, value);
355   }
356 }
357 
358 /**
359  * @title SafeERC20
360  * @dev Wrappers around ERC20 operations that throw on failure.
361  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
362  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
363  */
364 library SafeERC20 {
365 
366   using SafeMath for uint256;
367 
368   function safeTransfer(
369     IERC20 token,
370     address to,
371     uint256 value
372   )
373   internal
374   {
375     require(token.transfer(to, value));
376   }
377 
378   function safeTransferFrom(
379     IERC20 token,
380     address from,
381     address to,
382     uint256 value
383   )
384   internal
385   {
386     require(token.transferFrom(from, to, value));
387   }
388 
389   function safeApprove(
390     IERC20 token,
391     address spender,
392     uint256 value
393   )
394   internal
395   {
396     // safeApprove should only be called when setting an initial allowance,
397     // or when resetting it to zero. To increase and decrease it, use
398     // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
399     require((value == 0) || (token.allowance(msg.sender, spender) == 0));
400     require(token.approve(spender, value));
401   }
402 
403   function safeIncreaseAllowance(
404     IERC20 token,
405     address spender,
406     uint256 value
407   )
408   internal
409   {
410     uint256 newAllowance = token.allowance(address(this), spender).add(value);
411     require(token.approve(spender, newAllowance));
412   }
413 
414   function safeDecreaseAllowance(
415     IERC20 token,
416     address spender,
417     uint256 value
418   )
419   internal
420   {
421     uint256 newAllowance = token.allowance(address(this), spender).sub(value);
422     require(token.approve(spender, newAllowance));
423   }
424 }
425 
426 /**
427  * @title ERC20Detailed token
428  * @dev The decimals are only for visualization purposes.
429  * All the operations are done using the smallest and indivisible token unit,
430  * just as on Ethereum all the operations are done in wei.
431  */
432 contract ERC20Detailed is IERC20 {
433   string private _name;
434   string private _symbol;
435   uint8 private _decimals;
436 
437   constructor(string memory name, string memory symbol, uint8 decimals) public {
438     _name = name;
439     _symbol = symbol;
440     _decimals = decimals;
441   }
442 
443   /**
444    * @return the name of the token.
445    */
446   function name() public view returns(string memory) {
447     return _name;
448   }
449 
450   /**
451    * @return the symbol of the token.
452    */
453   function symbol() public view returns(string memory) {
454     return _symbol;
455   }
456 
457   /**
458    * @return the number of decimals of the token.
459    */
460   function decimals() public view returns(uint8) {
461     return _decimals;
462   }
463 }
464 
465 contract Ownable {
466   address payable public owner;
467   /**
468    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
469    * account.
470    */
471   constructor() public {
472     owner = msg.sender;
473   }
474   /**
475    * @dev Throws if called by any account other than the owner.
476    */
477   modifier onlyOwner() {
478     require(msg.sender == owner);
479     _;
480   }
481   function transferOwnership(address payable newOwner) public onlyOwner {
482     require(newOwner != address(0));
483     owner = newOwner;
484   }
485 }
486 
487 
488 
489 contract GameWave is ERC20, ERC20Detailed, Ownable {
490 
491   uint paymentsTime = block.timestamp;
492   uint totalPaymentAmount;
493   uint lastTotalPaymentAmount;
494   uint minted = 20000000;
495 
496   mapping (address => uint256) lastWithdrawTime;
497 
498   /**
499    * @dev The GW constructor sets the original variables
500    * specified in the contract ERC20Detailed.
501    */
502   constructor() public ERC20Detailed("Game wave token", "GWT", 18) {
503     _mint(msg.sender, minted * (10 ** uint256(decimals())));
504   }
505 
506   /**
507     * Fallback function
508     *
509     * The function without name is the default function that is called whenever anyone sends funds to a contract.
510     */
511   function () payable external {
512     if (msg.value == 0){
513       withdrawDividends(msg.sender);
514     }
515   }
516 
517   /**
518     * @notice This function allows the investor to see the amount of dividends available for withdrawal.
519     * @param _holder this is the address of the investor, where you can see the number of diverders available for withdrawal.
520     * @return An uint the value available for the removal of dividends.
521     */
522   function getDividends(address _holder) view public returns(uint) {
523     if (paymentsTime >= lastWithdrawTime[_holder]){
524       return totalPaymentAmount.mul(balanceOf(_holder)).div(minted * (10 ** uint256(decimals())));
525     } else {
526       return 0;
527     }
528   }
529 
530   /**
531     * @notice This function allows the investor to withdraw dividends available for withdrawal.
532     * @param _holder this is the address of the investor, by which there is a withdrawal available to dividend.
533     * @return An uint value of removed dividends.
534     */
535   function withdrawDividends(address payable _holder) public returns(uint) {
536     uint dividends = getDividends(_holder);
537     lastWithdrawTime[_holder] = block.timestamp;
538     lastTotalPaymentAmount = lastTotalPaymentAmount.add(dividends);
539     _holder.transfer(dividends);
540   }
541 
542   /**
543   * @notice This function initializes payments with a period of 30 days.
544   *
545   */
546 
547   function startPayments() public {
548     require(block.timestamp >= paymentsTime + 30 days);
549     owner.transfer(totalPaymentAmount.sub(lastTotalPaymentAmount));
550     totalPaymentAmount = address(this).balance;
551     paymentsTime = block.timestamp;
552     lastTotalPaymentAmount = 0;
553   }
554 }
555 
556 /*
557 * @title Bank
558 * @dev Bank contract which contained all ETH from Dragons and Hamsters teams.
559 * When time in blockchain will be grater then current deadline or last deadline need call getWinner function
560 * then participants able get prizes.
561 *
562 * Last participant(last hero) win 10% from all bank
563 *
564 * - To get prize send 0 ETH to this contract
565 */
566 contract Bank is Ownable {
567 
568     using SafeMath for uint256;
569 
570     mapping (uint256 => mapping (address => uint256)) public depositBears;
571     mapping (uint256 => mapping (address => uint256)) public depositBulls;
572 
573     uint256 public currentDeadline;
574     uint256 public currentRound = 1;
575     uint256 public lastDeadline;
576     uint256 public defaultCurrentDeadlineInHours = 24;
577     uint256 public defaultLastDeadlineInHours = 48;
578     uint256 public countOfBears;
579     uint256 public countOfBulls;
580     uint256 public totalSupplyOfBulls;
581     uint256 public totalSupplyOfBears;
582     uint256 public totalGWSupplyOfBulls;
583     uint256 public totalGWSupplyOfBears;
584     uint256 public probabilityOfBulls;
585     uint256 public probabilityOfBears;
586     address public lastHero;
587     address public lastHeroHistory;
588     uint256 public jackPot;
589     uint256 public winner;
590     uint256 public withdrawn;
591     uint256 public withdrawnGW;
592     uint256 public remainder;
593     uint256 public remainderGW;
594     uint256 public rate = 1;
595     uint256 public rateModifier = 0;
596     uint256 public tokenReturn;
597     address crowdSale;
598 
599     uint256 public lastTotalSupplyOfBulls;
600     uint256 public lastTotalSupplyOfBears;
601     uint256 public lastTotalGWSupplyOfBulls;
602     uint256 public lastTotalGWSupplyOfBears;
603     uint256 public lastProbabilityOfBulls;
604     uint256 public lastProbabilityOfBears;
605     address public lastRoundHero;
606     uint256 public lastJackPot;
607     uint256 public lastWinner;
608     uint256 public lastBalance;
609     uint256 public lastBalanceGW;
610     uint256 public lastCountOfBears;
611     uint256 public lastCountOfBulls;
612     uint256 public lastWithdrawn;
613     uint256 public lastWithdrawnGW;
614 
615 
616     bool public finished = false;
617 
618     Bears public BearsContract;
619     Bulls public BullsContract;
620     GameWave public GameWaveContract;
621 
622     /*
623     * @dev Constructor create first deadline
624     */
625     constructor(address _crowdSale) public {
626         _setRoundTime(6, 8);
627         crowdSale = _crowdSale;
628     }
629 
630     /**
631     * @dev Setter token rate.
632     * @param _rate this value for change percent relation rate to count of tokens.
633     * @param _rateModifier this value for change math operation under tokens.
634     */
635     function setRateToken(uint256 _rate, uint256 _rateModifier) public onlyOwner returns(uint256){
636         rate = _rate;
637         rateModifier = _rateModifier;
638     }
639 
640     /**
641     * @dev Setter crowd sale address.
642     * @param _crowdSale Address of the crowd sale contract.
643     */
644     function setCrowdSale(address _crowdSale) public onlyOwner{
645         crowdSale = _crowdSale;
646     }
647 
648     /**
649     * @dev Setter round time.
650     * @param _currentDeadlineInHours this value current deadline in hours.
651     * @param _lastDeadlineInHours this value last deadline in hours.
652     */
653     function _setRoundTime(uint _currentDeadlineInHours, uint _lastDeadlineInHours) internal {
654         defaultCurrentDeadlineInHours = _currentDeadlineInHours;
655         defaultLastDeadlineInHours = _lastDeadlineInHours;
656         currentDeadline = block.timestamp + 60 * 60 * _currentDeadlineInHours;
657         lastDeadline = block.timestamp + 60 * 60 * _lastDeadlineInHours;
658     }
659 
660     /**
661     * @dev Setter round time.
662     * @param _currentDeadlineInHours this value current deadline in hours.
663     * @param _lastDeadlineInHours this value last deadline in hours.
664     */
665     function setRoundTime(uint _currentDeadlineInHours, uint _lastDeadlineInHours) public onlyOwner {
666         _setRoundTime(_currentDeadlineInHours, _lastDeadlineInHours);
667     }
668 
669 
670     /**
671     * @dev Setter the GameWave contract address. Address can be set at once.
672     * @param _GameWaveAddress Address of the GameWave contract
673     */
674     function setGameWaveAddress(address payable _GameWaveAddress) public {
675         require(address(GameWaveContract) == address(0x0));
676         GameWaveContract = GameWave(_GameWaveAddress);
677     }
678 
679     /**
680     * @dev Setter the Bears contract address. Address can be set at once.
681     * @param _bearsAddress Address of the Bears contract
682     */
683     function setBearsAddress(address payable _bearsAddress) external {
684         require(address(BearsContract) == address(0x0));
685         BearsContract = Bears(_bearsAddress);
686     }
687 
688     /**
689     * @dev Setter the Bulls contract address. Address can be set at once.
690     * @param _bullsAddress Address of the Bulls contract
691     */
692     function setBullsAddress(address payable _bullsAddress) external {
693         require(address(BullsContract) == address(0x0));
694         BullsContract = Bulls(_bullsAddress);
695     }
696 
697     /**
698     * @dev Getting time from blockchain for timer
699     */
700     function getNow() view public returns(uint){
701         return block.timestamp;
702     }
703 
704     /**
705     * @dev Getting state of game. True - game continue, False - game stopped
706     */
707     function getState() view public returns(bool) {
708         if (block.timestamp > currentDeadline) {
709             return false;
710         }
711         return true;
712     }
713 
714     /**
715     * @dev Setting info about participant from Bears or Bulls contract
716     * @param _lastHero Address of participant
717     * @param _deposit Amount of deposit
718     */
719     function setInfo(address _lastHero, uint256 _deposit) public {
720         require(address(BearsContract) == msg.sender || address(BullsContract) == msg.sender);
721 
722         if (address(BearsContract) == msg.sender) {
723             require(depositBulls[currentRound][_lastHero] == 0, "You are already in bulls team");
724             if (depositBears[currentRound][_lastHero] == 0)
725                 countOfBears++;
726             totalSupplyOfBears = totalSupplyOfBears.add(_deposit.mul(90).div(100));
727             depositBears[currentRound][_lastHero] = depositBears[currentRound][_lastHero].add(_deposit.mul(90).div(100));
728         }
729 
730         if (address(BullsContract) == msg.sender) {
731             require(depositBears[currentRound][_lastHero] == 0, "You are already in bears team");
732             if (depositBulls[currentRound][_lastHero] == 0)
733                 countOfBulls++;
734             totalSupplyOfBulls = totalSupplyOfBulls.add(_deposit.mul(90).div(100));
735             depositBulls[currentRound][_lastHero] = depositBulls[currentRound][_lastHero].add(_deposit.mul(90).div(100));
736         }
737 
738         lastHero = _lastHero;
739 
740         if (currentDeadline.add(120) <= lastDeadline) {
741             currentDeadline = currentDeadline.add(120);
742         } else {
743             currentDeadline = lastDeadline;
744         }
745 
746         jackPot += _deposit.mul(10).div(100);
747 
748         calculateProbability();
749     }
750 
751     function estimateTokenPercent(uint256 _difference) public view returns(uint256){
752         if (rateModifier == 0) {
753             return _difference.mul(rate);
754         } else {
755             return _difference.div(rate);
756         }
757     }
758 
759     /**
760     * @dev Calculation probability for team's win
761     */
762     function calculateProbability() public {
763         require(winner == 0 && getState());
764 
765         totalGWSupplyOfBulls = GameWaveContract.balanceOf(address(BullsContract));
766         totalGWSupplyOfBears = GameWaveContract.balanceOf(address(BearsContract));
767         uint256 percent = (totalSupplyOfBulls.add(totalSupplyOfBears)).div(100);
768 
769         if (totalGWSupplyOfBulls < 1 ether) {
770             totalGWSupplyOfBulls = 0;
771         }
772 
773         if (totalGWSupplyOfBears < 1 ether) {
774             totalGWSupplyOfBears = 0;
775         }
776 
777         if (totalGWSupplyOfBulls <= totalGWSupplyOfBears) {
778             uint256 difference = totalGWSupplyOfBears.sub(totalGWSupplyOfBulls).div(0.01 ether);
779 
780             probabilityOfBears = totalSupplyOfBears.mul(100).div(percent).add(estimateTokenPercent(difference));
781 
782             if (probabilityOfBears > 8000) {
783                 probabilityOfBears = 8000;
784             }
785             if (probabilityOfBears < 2000) {
786                 probabilityOfBears = 2000;
787             }
788             probabilityOfBulls = 10000 - probabilityOfBears;
789         } else {
790             uint256 difference = totalGWSupplyOfBulls.sub(totalGWSupplyOfBears).div(0.01 ether);
791             probabilityOfBulls = totalSupplyOfBulls.mul(100).div(percent).add(estimateTokenPercent(difference));
792 
793             if (probabilityOfBulls > 8000) {
794                 probabilityOfBulls = 8000;
795             }
796             if (probabilityOfBulls < 2000) {
797                 probabilityOfBulls = 2000;
798             }
799             probabilityOfBears = 10000 - probabilityOfBulls;
800         }
801 
802         totalGWSupplyOfBulls = GameWaveContract.balanceOf(address(BullsContract));
803         totalGWSupplyOfBears = GameWaveContract.balanceOf(address(BearsContract));
804     }
805 
806     /**
807     * @dev Getting winner team
808     */
809     function getWinners() public {
810         require(winner == 0 && !getState());
811         uint256 seed1 = address(this).balance;
812         uint256 seed2 = totalSupplyOfBulls;
813         uint256 seed3 = totalSupplyOfBears;
814         uint256 seed4 = totalGWSupplyOfBulls;
815         uint256 seed5 = totalGWSupplyOfBulls;
816         uint256 seed6 = block.difficulty;
817         uint256 seed7 = block.timestamp;
818 
819         bytes32 randomHash = keccak256(abi.encodePacked(seed1, seed2, seed3, seed4, seed5, seed6, seed7));
820         uint randomNumber = uint(randomHash);
821 
822         if (randomNumber == 0){
823             randomNumber = 1;
824         }
825 
826         uint winningNumber = randomNumber % 10000;
827 
828         if (1 <= winningNumber && winningNumber <= probabilityOfBears){
829             winner = 1;
830         }
831 
832         if (probabilityOfBears < winningNumber && winningNumber <= 10000){
833             winner = 2;
834         }
835 
836         if (GameWaveContract.balanceOf(address(BullsContract)) > 0)
837             GameWaveContract.transferFrom(
838                 address(BullsContract),
839                 address(this),
840                 GameWaveContract.balanceOf(address(BullsContract))
841             );
842 
843         if (GameWaveContract.balanceOf(address(BearsContract)) > 0)
844             GameWaveContract.transferFrom(
845                 address(BearsContract),
846                 address(this),
847                 GameWaveContract.balanceOf(address(BearsContract))
848             );
849 
850         lastTotalSupplyOfBulls = totalSupplyOfBulls;
851         lastTotalSupplyOfBears = totalSupplyOfBears;
852         lastTotalGWSupplyOfBears = totalGWSupplyOfBears;
853         lastTotalGWSupplyOfBulls = totalGWSupplyOfBulls;
854         lastRoundHero = lastHero;
855         lastJackPot = jackPot;
856         lastWinner = winner;
857         lastCountOfBears = countOfBears;
858         lastCountOfBulls = countOfBulls;
859         lastWithdrawn = withdrawn;
860         lastWithdrawnGW = withdrawnGW;
861 
862         if (lastBalance > lastWithdrawn){
863             remainder = lastBalance.sub(lastWithdrawn);
864             address(GameWaveContract).transfer(remainder);
865         }
866 
867         lastBalance = lastTotalSupplyOfBears.add(lastTotalSupplyOfBulls).add(lastJackPot);
868 
869         if (lastBalanceGW > lastWithdrawnGW){
870             remainderGW = lastBalanceGW.sub(lastWithdrawnGW);
871             tokenReturn = (totalGWSupplyOfBears.add(totalGWSupplyOfBulls)).mul(20).div(100).add(remainderGW);
872             GameWaveContract.transfer(crowdSale, tokenReturn);
873         }
874 
875         lastBalanceGW = GameWaveContract.balanceOf(address(this));
876 
877         totalSupplyOfBulls = 0;
878         totalSupplyOfBears = 0;
879         totalGWSupplyOfBulls = 0;
880         totalGWSupplyOfBears = 0;
881         remainder = 0;
882         remainderGW = 0;
883         jackPot = 0;
884 
885         withdrawn = 0;
886         winner = 0;
887         withdrawnGW = 0;
888         countOfBears = 0;
889         countOfBulls = 0;
890         probabilityOfBulls = 0;
891         probabilityOfBears = 0;
892 
893         _setRoundTime(defaultCurrentDeadlineInHours, defaultLastDeadlineInHours);
894         currentRound++;
895     }
896 
897     /**
898     * @dev Payable function for take prize
899     */
900     function () external payable {
901         if (msg.value == 0){
902             require(depositBears[currentRound - 1][msg.sender] > 0 || depositBulls[currentRound - 1][msg.sender] > 0);
903 
904             uint payout = 0;
905             uint payoutGW = 0;
906 
907             if (lastWinner == 1 && depositBears[currentRound - 1][msg.sender] > 0) {
908                 payout = calculateLastETHPrize(msg.sender);
909             }
910             if (lastWinner == 2 && depositBulls[currentRound - 1][msg.sender] > 0) {
911                 payout = calculateLastETHPrize(msg.sender);
912             }
913 
914             if (payout > 0) {
915                 depositBears[currentRound - 1][msg.sender] = 0;
916                 depositBulls[currentRound - 1][msg.sender] = 0;
917                 withdrawn = withdrawn.add(payout);
918                 msg.sender.transfer(payout);
919             }
920 
921             if ((lastWinner == 1 && depositBears[currentRound - 1][msg.sender] == 0) || (lastWinner == 2 && depositBulls[currentRound - 1][msg.sender] == 0)) {
922                 payoutGW = calculateLastGWPrize(msg.sender);
923                 withdrawnGW = withdrawnGW.add(payoutGW);
924                 GameWaveContract.transfer(msg.sender, payoutGW);
925             }
926 
927             if (msg.sender == lastRoundHero) {
928                 lastHeroHistory = lastRoundHero;
929                 lastRoundHero = address(0x0);
930                 withdrawn = withdrawn.add(lastJackPot);
931                 msg.sender.transfer(lastJackPot);
932             }
933         }
934     }
935 
936     /**
937     * @dev Getting ETH prize of participant
938     * @param participant Address of participant
939     */
940     function calculateETHPrize(address participant) public view returns(uint) {
941 
942         uint payout = 0;
943         uint256 totalSupply = (totalSupplyOfBears.add(totalSupplyOfBulls));
944 
945         if (depositBears[currentRound][participant] > 0) {
946             payout = totalSupply.mul(depositBears[currentRound][participant]).div(totalSupplyOfBears);
947         }
948 
949         if (depositBulls[currentRound][participant] > 0) {
950             payout = totalSupply.mul(depositBulls[currentRound][participant]).div(totalSupplyOfBulls);
951         }
952 
953         return payout;
954     }
955 
956     /**
957     * @dev Getting GW Token prize of participant
958     * @param participant Address of participant
959     */
960     function calculateGWPrize(address participant) public view returns(uint) {
961 
962         uint payout = 0;
963         uint totalSupply = (totalGWSupplyOfBears.add(totalGWSupplyOfBulls)).mul(80).div(100);
964 
965         if (depositBears[currentRound][participant] > 0) {
966             payout = totalSupply.mul(depositBears[currentRound][participant]).div(totalSupplyOfBears);
967         }
968 
969         if (depositBulls[currentRound][participant] > 0) {
970             payout = totalSupply.mul(depositBulls[currentRound][participant]).div(totalSupplyOfBulls);
971         }
972 
973         return payout;
974     }
975 
976     /**
977     * @dev Getting ETH prize of _lastParticipant
978     * @param _lastParticipant Address of _lastParticipant
979     */
980     function calculateLastETHPrize(address _lastParticipant) public view returns(uint) {
981 
982         uint payout = 0;
983         uint256 totalSupply = (lastTotalSupplyOfBears.add(lastTotalSupplyOfBulls));
984 
985         if (depositBears[currentRound - 1][_lastParticipant] > 0) {
986             payout = totalSupply.mul(depositBears[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBears);
987         }
988 
989         if (depositBulls[currentRound - 1][_lastParticipant] > 0) {
990             payout = totalSupply.mul(depositBulls[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBulls);
991         }
992 
993         return payout;
994     }
995 
996     /**
997     * @dev Getting GW Token prize of _lastParticipant
998     * @param _lastParticipant Address of _lastParticipant
999     */
1000     function calculateLastGWPrize(address _lastParticipant) public view returns(uint) {
1001 
1002         uint payout = 0;
1003         uint totalSupply = (lastTotalGWSupplyOfBears.add(lastTotalGWSupplyOfBulls)).mul(80).div(100);
1004 
1005         if (depositBears[currentRound - 1][_lastParticipant] > 0) {
1006             payout = totalSupply.mul(depositBears[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBears);
1007         }
1008 
1009         if (depositBulls[currentRound - 1][_lastParticipant] > 0) {
1010             payout = totalSupply.mul(depositBulls[currentRound - 1][_lastParticipant]).div(lastTotalSupplyOfBulls);
1011         }
1012 
1013         return payout;
1014     }
1015 }
1016 
1017 /**
1018 * @dev Base contract for teams
1019 */
1020 contract CryptoTeam {
1021     using SafeMath for uint256;
1022 
1023     //Developers fund
1024     address payable public owner;
1025 
1026     Bank public BankContract;
1027     GameWave public GameWaveContract;
1028 
1029     constructor() public {
1030         owner = msg.sender;
1031     }
1032     
1033     /**
1034     * @dev Payable function. 10% will send to Developers fund and 90% will send to JackPot contract.
1035     * Also setting info about player.
1036     */
1037     function () external payable {
1038         require(BankContract.getState() && msg.value >= 0.05 ether);
1039 
1040         BankContract.setInfo(msg.sender, msg.value.mul(90).div(100));
1041 
1042         owner.transfer(msg.value.mul(10).div(100));
1043         
1044         address(BankContract).transfer(msg.value.mul(90).div(100));
1045     }
1046 }
1047 
1048 /*
1049 * @dev Bears contract. To play game with Bears send ETH to this contract
1050 */
1051 contract Bears is CryptoTeam {
1052     constructor(address payable _bankAddress, address payable _GameWaveAddress) public {
1053         BankContract = Bank(_bankAddress);
1054         BankContract.setBearsAddress(address(this));
1055         GameWaveContract = GameWave(_GameWaveAddress);
1056         GameWaveContract.approve(_bankAddress, 9999999999999999999000000000000000000);
1057     }
1058 }
1059 
1060 /*
1061 * @dev Bulls contract. To play game with Bulls send ETH to this contract
1062 */
1063 contract Bulls is CryptoTeam {
1064     constructor(address payable _bankAddress, address payable _GameWaveAddress) public {
1065         BankContract = Bank(_bankAddress);
1066         BankContract.setBullsAddress(address(this));
1067         GameWaveContract = GameWave(_GameWaveAddress);
1068         GameWaveContract.approve(_bankAddress, 9999999999999999999000000000000000000);
1069     }
1070 }