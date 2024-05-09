1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Wrappers over Solidity's arithmetic operations with added overflow
5  * checks.
6  *
7  * Arithmetic operations in Solidity wrap on overflow. This can easily result
8  * in bugs, because programmers usually assume that an overflow raises an
9  * error, which is the standard behavior in high level programming languages.
10  * `SafeMath` restores this intuition by reverting the transaction when an
11  * operation overflows.
12  *
13  * Using this library instead of the unchecked operations eliminates an entire
14  * class of bugs, so it's recommended to use it always.
15  */
16 library SafeMath {
17     /**
18      * @dev Returns the addition of two unsigned integers, reverting on
19      * overflow.
20      *
21      * Counterpart to Solidity's `+` operator.
22      *
23      * Requirements:
24      * - Addition cannot overflow.
25      */
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29 
30         return c;
31     }
32 
33     /**
34      * @dev Returns the subtraction of two unsigned integers, reverting on
35      * overflow (when the result is negative).
36      *
37      * Counterpart to Solidity's `-` operator.
38      *
39      * Requirements:
40      * - Subtraction cannot overflow.
41      */
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      * - Subtraction cannot overflow.
54      *
55      * _Available since v2.4.0._
56      */
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the multiplication of two unsigned integers, reverting on
66      * overflow.
67      *
68      * Counterpart to Solidity's `*` operator.
69      *
70      * Requirements:
71      * - Multiplication cannot overflow.
72      */
73     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
74         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
75         // benefit is lost if 'b' is also tested.
76         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
77         if (a == 0) {
78             return 0;
79         }
80 
81         uint256 c = a * b;
82         require(c / a == b, "SafeMath: multiplication overflow");
83 
84         return c;
85     }
86 
87     /**
88      * @dev Returns the integer division of two unsigned integers. Reverts on
89      * division by zero. The result is rounded towards zero.
90      *
91      * Counterpart to Solidity's `/` operator. Note: this function uses a
92      * `revert` opcode (which leaves remaining gas untouched) while Solidity
93      * uses an invalid opcode to revert (consuming all remaining gas).
94      *
95      * Requirements:
96      * - The divisor cannot be zero.
97      */
98     function div(uint256 a, uint256 b) internal pure returns (uint256) {
99         return div(a, b, "SafeMath: division by zero");
100     }
101 
102     /**
103      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
104      * division by zero. The result is rounded towards zero.
105      *
106      * Counterpart to Solidity's `/` operator. Note: this function uses a
107      * `revert` opcode (which leaves remaining gas untouched) while Solidity
108      * uses an invalid opcode to revert (consuming all remaining gas).
109      *
110      * Requirements:
111      * - The divisor cannot be zero.
112      *
113      * _Available since v2.4.0._
114      */
115     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         // Solidity only automatically asserts when dividing by 0
117         require(b > 0, errorMessage);
118         uint256 c = a / b;
119         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
126      * Reverts when dividing by zero.
127      *
128      * Counterpart to Solidity's `%` operator. This function uses a `revert`
129      * opcode (which leaves remaining gas untouched) while Solidity uses an
130      * invalid opcode to revert (consuming all remaining gas).
131      *
132      * Requirements:
133      * - The divisor cannot be zero.
134      */
135     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
136         return mod(a, b, "SafeMath: modulo by zero");
137     }
138 
139     /**
140      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
141      * Reverts with custom message when dividing by zero.
142      *
143      * Counterpart to Solidity's `%` operator. This function uses a `revert`
144      * opcode (which leaves remaining gas untouched) while Solidity uses an
145      * invalid opcode to revert (consuming all remaining gas).
146      *
147      * Requirements:
148      * - The divisor cannot be zero.
149      *
150      * _Available since v2.4.0._
151      */
152     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b != 0, errorMessage);
154         return a % b;
155     }
156 }
157 
158 
159 
160 pragma solidity ^0.5.0;
161 
162 /**
163  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
164  * the optional functions; to access them see {ERC20Detailed}.
165  */
166 interface IERC20 {
167     /**
168      * @dev Returns the amount of tokens in existence.
169      */
170     function totalSupply() external view returns (uint256);
171 
172     /**
173      * @dev Returns the amount of tokens owned by `account`.
174      */
175     function balanceOf(address account) external view returns (uint256);
176 
177     /**
178      * @dev Moves `amount` tokens from the caller's account to `recipient`.
179      *
180      * Returns a boolean value indicating whether the operation succeeded.
181      *
182      * Emits a {Transfer} event.
183      */
184     function transfer(address recipient, uint256 amount) external returns (bool);
185 
186     /**
187      * @dev Returns the remaining number of tokens that `spender` will be
188      * allowed to spend on behalf of `owner` through {transferFrom}. This is
189      * zero by default.
190      *
191      * This value changes when {approve} or {transferFrom} are called.
192      */
193     function allowance(address owner, address spender) external view returns (uint256);
194 
195     /**
196      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * IMPORTANT: Beware that changing an allowance with this method brings the risk
201      * that someone may use both the old and the new allowance by unfortunate
202      * transaction ordering. One possible solution to mitigate this race
203      * condition is to first reduce the spender's allowance to 0 and set the
204      * desired value afterwards:
205      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
206      *
207      * Emits an {Approval} event.
208      */
209     function approve(address spender, uint256 amount) external returns (bool);
210 
211     /**
212      * @dev Moves `amount` tokens from `sender` to `recipient` using the
213      * allowance mechanism. `amount` is then deducted from the caller's
214      * allowance.
215      *
216      * Returns a boolean value indicating whether the operation succeeded.
217      *
218      * Emits a {Transfer} event.
219      */
220     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
221     
222     /**
223      * @dev Emitted when `value` tokens are moved from one account (`from`) to
224      * another (`to`).
225      *
226      * Note that `value` may be zero.
227      */
228     event Transfer(address indexed from, address indexed to, uint256 value);
229 
230     /**
231      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
232      * a call to {approve}. `value` is the new allowance.
233      */
234     event Approval(address indexed owner, address indexed spender, uint256 value);
235 }
236 
237 
238 pragma solidity ^0.5.0;
239 
240 
241 
242 /**
243  * @dev Optional functions from the ERC20 standard.
244  */
245 contract ERC20Detailed is IERC20 {
246     string private _name;
247     string private _symbol;
248     uint8 private _decimals;
249 
250     /**
251      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
252      * these values are immutable: they can only be set once during
253      * construction.
254      */
255     constructor (string memory name, string memory symbol, uint8 decimals) public {
256         _name = name;
257         _symbol = symbol;
258         _decimals = decimals;
259     }
260 
261     /**
262      * @dev Returns the name of the token.
263      */
264     function name() public view returns (string memory) {
265         return _name;
266     }
267 
268     /**
269      * @dev Returns the symbol of the token, usually a shorter version of the
270      * name.
271      */
272     function symbol() public view returns (string memory) {
273         return _symbol;
274     }
275 
276     /**
277      * @dev Returns the number of decimals used to get its user representation.
278      * For example, if `decimals` equals `2`, a balance of `505` tokens should
279      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
280      *
281      * Tokens usually opt for a value of 18, imitating the relationship between
282      * Ether and Wei.
283      *
284      * NOTE: This information is only used for _display_ purposes: it in
285      * no way affects any of the arithmetic of the contract, including
286      * {IERC20-balanceOf} and {IERC20-transfer}.
287      */
288     function decimals() public view returns (uint8) {
289         return _decimals;
290     }
291 }
292 
293 
294 
295 pragma solidity ^0.5.5;
296 
297 contract Governance {
298 
299     address public governance;
300 
301     constructor() public {
302         governance = tx.origin;
303     }
304 
305     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
306 
307     modifier onlyGovernance {
308         require(msg.sender == governance, "not governance");
309         _;
310     }
311 
312     function setGovernance(address _governance)  public  onlyGovernance
313     {
314         require(_governance != address(0), "new governance the zero address");
315         emit GovernanceTransferred(governance, _governance);
316         governance = _governance;
317     }
318 
319 
320 
321 }
322 
323 pragma solidity ^0.5.5;
324 
325 
326 
327 /// @title DegoToken Contract
328 
329 contract TLSToken is Governance, ERC20Detailed{
330 
331     using SafeMath for uint256;
332 
333     //events
334     event eveSetRate(uint256 burn_rate, uint256 reward_rate);
335     event eveRewardPool(address rewardPool);
336     event Transfer(address indexed from, address indexed to, uint256 value);
337     event Mint(address indexed from, address indexed to, uint256 value);
338     event Approval(address indexed owner, address indexed spender, uint256 value);
339 
340     // for minters
341     mapping (address => bool) public _minters;
342     mapping (address => uint256) public _minters_number;
343     //token base data
344     uint256 internal _totalSupply;
345     mapping(address => uint256) public _balances;
346     mapping (address => mapping (address => uint256)) public _allowances;
347 
348     /// Constant token specific fields
349     uint8 internal constant _decimals = 18;
350     uint256 public  _maxSupply = 0;
351 
352     ///
353     bool public _openTransfer = false;
354 
355     // hardcode limit rate
356     uint256 public constant _maxGovernValueRate = 2000;//2000/10000
357     uint256 public constant _minGovernValueRate = 10;  //10/10000
358     uint256 public constant _rateBase = 10000; 
359 
360     // additional variables for use if transaction fees ever became necessary
361     uint256 public  _burnRate = 150;       
362     uint256 public  _rewardRate = 150;   
363 
364     uint256 public _totalBurnToken = 0;
365     uint256 public _totalRewardToken = 0;
366 
367     //todo reward pool!
368     address public _rewardPool = 0xd340A68642C3de2c73C98713006663633E6F93E1;
369     //todo burn pool!
370     address public _burnPool = 0x6666666666666666666666666666666666666666;
371 
372     /**
373     * @dev set the token transfer switch
374     */
375     function enableOpenTransfer() public onlyGovernance  
376     {
377         _openTransfer = true;
378     }
379 
380 
381     /**
382      * CONSTRUCTOR
383      *
384      * @dev Initialize the Token
385      */
386 
387     constructor () public ERC20Detailed("tellus", "TLS", _decimals) {
388         uint256 _exp = _decimals;
389          _maxSupply = 21000000 * (10**_exp);
390     }
391 
392 
393     
394     /**
395     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
396     * @param spender The address which will spend the funds.
397     * @param amount The amount of tokens to be spent.
398     */
399     function approve(address spender, uint256 amount) public 
400     returns (bool) 
401     {
402         require(msg.sender != address(0), "ERC20: approve from the zero address");
403         require(spender != address(0), "ERC20: approve to the zero address");
404 
405         _allowances[msg.sender][spender] = amount;
406         emit Approval(msg.sender, spender, amount);
407 
408         return true;
409     }
410 
411     /**
412     * @dev Function to check the amount of tokens than an owner _allowed to a spender.
413     * @param owner address The address which owns the funds.
414     * @param spender address The address which will spend the funds.
415     * @return A uint256 specifying the amount of tokens still available for the spender.
416     */
417     function allowance(address owner, address spender) public view 
418     returns (uint256) 
419     {
420         return _allowances[owner][spender];
421     }
422 
423     /**
424     * @dev Gets the balance of the specified address.
425     * @param owner The address to query the the balance of.
426     * @return An uint256 representing the amount owned by the passed address.
427     */
428     function balanceOf(address owner) public  view 
429     returns (uint256) 
430     {
431         return _balances[owner];
432     }
433 
434     /**
435     * @dev return the token total supply
436     */
437     function totalSupply() public view 
438     returns (uint256) 
439     {
440         return _totalSupply;
441     }
442 
443     /**
444     * @dev for mint function
445     */
446     function mint(address account, uint256 amount) public 
447     {
448         require(account != address(0), "ERC20: mint to the zero address");
449         require(_minters[msg.sender], "!minter");
450         require(_minters_number[msg.sender]>=amount);
451         uint256 curMintSupply = _totalSupply.add(_totalBurnToken);
452         uint256 newMintSupply = curMintSupply.add(amount);
453         require( newMintSupply <= _maxSupply,"supply is max!");
454 
455         _totalSupply = _totalSupply.add(amount);
456         _balances[account] = _balances[account].add(amount);
457         _minters_number[msg.sender] = _minters_number[msg.sender].sub(amount);
458         emit Mint(address(0), account, amount);
459         emit Transfer(address(0), account, amount);
460     }
461 
462     function addMinter(address _minter,uint256 number) public onlyGovernance 
463     {
464         _minters[_minter] = true;
465         _minters_number[_minter] = number;
466     }
467 
468 
469     function setMinter_number(address _minter,uint256 number) public onlyGovernance 
470     {
471         require(_minters[_minter]);
472         _minters_number[_minter] = number;
473     }
474     
475     function removeMinter(address _minter) public onlyGovernance 
476     {
477         _minters[_minter] = false;
478         _minters_number[_minter] = 0;
479     }
480     
481 
482     function() external payable {
483         revert();
484     }
485 
486     /**
487     * @dev for govern value
488     */
489     function setRate(uint256 burn_rate, uint256 reward_rate) public 
490         onlyGovernance 
491     {
492         
493         require(_maxGovernValueRate >= burn_rate && burn_rate >= _minGovernValueRate,"invalid burn rate");
494         require(_maxGovernValueRate >= reward_rate && reward_rate >= _minGovernValueRate,"invalid reward rate");
495 
496         _burnRate = burn_rate;
497         _rewardRate = reward_rate;
498 
499         emit eveSetRate(burn_rate, reward_rate);
500     }
501 
502 
503     /**
504     * @dev for set reward
505     */
506     function setRewardPool(address rewardPool) public 
507         onlyGovernance 
508     {
509         require(rewardPool != address(0x0));
510 
511         _rewardPool = rewardPool;
512 
513         emit eveRewardPool(_rewardPool);
514     }
515     /**
516     * @dev transfer token for a specified address
517     * @param to The address to transfer to.
518     * @param value The amount to be transferred.
519     */
520    function transfer(address to, uint256 value) public 
521    returns (bool)  
522    {
523         return _transfer(msg.sender,to,value);
524     }
525 
526     /**
527     * @dev Transfer tokens from one address to another
528     * @param from address The address which you want to send tokens from
529     * @param to address The address which you want to transfer to
530     * @param value uint256 the amount of tokens to be transferred
531     */
532     function transferFrom(address from, address to, uint256 value) public 
533     returns (bool) 
534     {
535         uint256 allow = _allowances[from][msg.sender];
536         _allowances[from][msg.sender] = allow.sub(value);
537         
538         return _transfer(from,to,value);
539     }
540 
541  
542 
543     /**
544     * @dev Transfer tokens with fee
545     * @param from address The address which you want to send tokens from
546     * @param to address The address which you want to transfer to
547     * @param value uint256s the amount of tokens to be transferred
548     */
549     function _transfer(address from, address to, uint256 value) internal 
550     returns (bool) 
551     {
552         // :)
553         require(_openTransfer || from == governance, "transfer closed");
554 
555         require(from != address(0), "ERC20: transfer from the zero address");
556         require(to != address(0), "ERC20: transfer to the zero address");
557 
558         uint256 sendAmount = value;
559         uint256 burnFee = (value.mul(_burnRate)).div(_rateBase);
560         if (burnFee > 0) {
561             //to burn
562             _balances[_burnPool] = _balances[_burnPool].add(burnFee);
563             _totalSupply = _totalSupply.sub(burnFee);
564             sendAmount = sendAmount.sub(burnFee);
565 
566             _totalBurnToken = _totalBurnToken.add(burnFee);
567 
568             emit Transfer(from, _burnPool, burnFee);
569         }
570 
571         uint256 rewardFee = (value.mul(_rewardRate)).div(_rateBase);
572         if (rewardFee > 0) {
573            //to reward
574             _balances[_rewardPool] = _balances[_rewardPool].add(rewardFee);
575             sendAmount = sendAmount.sub(rewardFee);
576 
577             _totalRewardToken = _totalRewardToken.add(rewardFee);
578 
579             emit Transfer(from, _rewardPool, rewardFee);
580         }
581 
582         _balances[from] = _balances[from].sub(value);
583         _balances[to] = _balances[to].add(sendAmount);
584 
585         emit Transfer(from, to, sendAmount);
586 
587         return true;
588     }
589 }