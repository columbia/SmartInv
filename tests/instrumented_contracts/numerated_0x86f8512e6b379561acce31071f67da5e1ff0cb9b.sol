1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-18
3 */
4 
5 pragma solidity ^0.5.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, reverting on
23      * overflow.
24      *
25      * Counterpart to Solidity's `+` operator.
26      *
27      * Requirements:
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      * - Subtraction cannot overflow.
45      */
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     /**
51      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
52      * overflow (when the result is negative).
53      *
54      * Counterpart to Solidity's `-` operator.
55      *
56      * Requirements:
57      * - Subtraction cannot overflow.
58      *
59      * _Available since v2.4.0._
60      */
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, reverting on
70      * overflow.
71      *
72      * Counterpart to Solidity's `*` operator.
73      *
74      * Requirements:
75      * - Multiplication cannot overflow.
76      */
77     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
78         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
79         // benefit is lost if 'b' is also tested.
80         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
81         if (a == 0) {
82             return 0;
83         }
84 
85         uint256 c = a * b;
86         require(c / a == b, "SafeMath: multiplication overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the integer division of two unsigned integers. Reverts on
93      * division by zero. The result is rounded towards zero.
94      *
95      * Counterpart to Solidity's `/` operator. Note: this function uses a
96      * `revert` opcode (which leaves remaining gas untouched) while Solidity
97      * uses an invalid opcode to revert (consuming all remaining gas).
98      *
99      * Requirements:
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      * - The divisor cannot be zero.
116      *
117      * _Available since v2.4.0._
118      */
119     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
120         // Solidity only automatically asserts when dividing by 0
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      * - The divisor cannot be zero.
138      */
139     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
140         return mod(a, b, "SafeMath: modulo by zero");
141     }
142 
143     /**
144      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
145      * Reverts with custom message when dividing by zero.
146      *
147      * Counterpart to Solidity's `%` operator. This function uses a `revert`
148      * opcode (which leaves remaining gas untouched) while Solidity uses an
149      * invalid opcode to revert (consuming all remaining gas).
150      *
151      * Requirements:
152      * - The divisor cannot be zero.
153      *
154      * _Available since v2.4.0._
155      */
156     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b != 0, errorMessage);
158         return a % b;
159     }
160 }
161 
162 
163 
164 pragma solidity ^0.5.0;
165 
166 /**
167  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
168  * the optional functions; to access them see {ERC20Detailed}.
169  */
170 interface IERC20 {
171     /**
172      * @dev Returns the amount of tokens in existence.
173      */
174     function totalSupply() external view returns (uint256);
175 
176     /**
177      * @dev Returns the amount of tokens owned by `account`.
178      */
179     function balanceOf(address account) external view returns (uint256);
180 
181     /**
182      * @dev Moves `amount` tokens from the caller's account to `recipient`.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transfer(address recipient, uint256 amount) external returns (bool);
189 
190     /**
191      * @dev Returns the remaining number of tokens that `spender` will be
192      * allowed to spend on behalf of `owner` through {transferFrom}. This is
193      * zero by default.
194      *
195      * This value changes when {approve} or {transferFrom} are called.
196      */
197     function allowance(address owner, address spender) external view returns (uint256);
198 
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * IMPORTANT: Beware that changing an allowance with this method brings the risk
205      * that someone may use both the old and the new allowance by unfortunate
206      * transaction ordering. One possible solution to mitigate this race
207      * condition is to first reduce the spender's allowance to 0 and set the
208      * desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address spender, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Moves `amount` tokens from `sender` to `recipient` using the
217      * allowance mechanism. `amount` is then deducted from the caller's
218      * allowance.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
225     
226     /**
227      * @dev Emitted when `value` tokens are moved from one account (`from`) to
228      * another (`to`).
229      *
230      * Note that `value` may be zero.
231      */
232     event Transfer(address indexed from, address indexed to, uint256 value);
233 
234     /**
235      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
236      * a call to {approve}. `value` is the new allowance.
237      */
238     event Approval(address indexed owner, address indexed spender, uint256 value);
239 }
240 
241 
242 pragma solidity ^0.5.0;
243 
244 
245 
246 /**
247  * @dev Optional functions from the ERC20 standard.
248  */
249 contract ERC20Detailed is IERC20 {
250     string private _name;
251     string private _symbol;
252     uint8 private _decimals;
253 
254     /**
255      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
256      * these values are immutable: they can only be set once during
257      * construction.
258      */
259     constructor (string memory name, string memory symbol, uint8 decimals) public {
260         _name = name;
261         _symbol = symbol;
262         _decimals = decimals;
263     }
264 
265     /**
266      * @dev Returns the name of the token.
267      */
268     function name() public view returns (string memory) {
269         return _name;
270     }
271 
272     /**
273      * @dev Returns the symbol of the token, usually a shorter version of the
274      * name.
275      */
276     function symbol() public view returns (string memory) {
277         return _symbol;
278     }
279 
280     /**
281      * @dev Returns the number of decimals used to get its user representation.
282      * For example, if `decimals` equals `2`, a balance of `505` tokens should
283      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
284      *
285      * Tokens usually opt for a value of 18, imitating the relationship between
286      * Ether and Wei.
287      *
288      * NOTE: This information is only used for _display_ purposes: it in
289      * no way affects any of the arithmetic of the contract, including
290      * {IERC20-balanceOf} and {IERC20-transfer}.
291      */
292     function decimals() public view returns (uint8) {
293         return _decimals;
294     }
295 }
296 
297 
298 
299 pragma solidity ^0.5.5;
300 
301 contract Governance {
302 
303     address public governance;
304 
305     constructor() public {
306         governance = tx.origin;
307     }
308 
309     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
310 
311     modifier onlyGovernance {
312         require(msg.sender == governance, "not governance");
313         _;
314     }
315 
316     function setGovernance(address _governance)  public  onlyGovernance
317     {
318         require(_governance != address(0), "new governance the zero address");
319         emit GovernanceTransferred(governance, _governance);
320         governance = _governance;
321     }
322 
323 
324 
325 }
326 
327 pragma solidity ^0.5.5;
328 
329 
330 
331 /// @title DegoToken Contract
332 
333 contract BDMToken is Governance, ERC20Detailed{
334 
335     using SafeMath for uint256;
336 
337     //events
338     event eveSetRate(uint256 burn_rate, uint256 reward_rate);
339     event eveRewardPool(address rewardPool,address burnPool);
340     event Transfer(address indexed from, address indexed to, uint256 value);
341     event Mint(address indexed from, address indexed to, uint256 value);
342     event Approval(address indexed owner, address indexed spender, uint256 value);
343 
344     // for minters
345     mapping (address => bool) public _minters;
346     mapping (address => uint256) public _minters_number;
347     //token base data
348     uint256 internal _totalSupply;
349     mapping(address => uint256) public _balances;
350     mapping (address => mapping (address => uint256)) public _allowances;
351 
352     /// Constant token specific fields
353     uint8 internal constant _decimals = 18;
354     uint256 public  _maxSupply = 0;
355 
356     ///
357     bool public _openTransfer = false;
358 
359     // hardcode limit rate
360     uint256 public constant _maxGovernValueRate = 1000000;//2000/10000
361     uint256 public constant _minGovernValueRate = 0;  //10/10000
362     uint256 public constant _rateBase = 1000000; 
363 
364     // additional variables for use if transaction fees ever became necessary
365     uint256 public  _burnRate = 100;       
366     uint256 public  _rewardRate = 0;   
367 
368     uint256 public _totalBurnToken = 0;
369     uint256 public _totalRewardToken = 0;
370 
371     //todo reward pool!
372     address public _rewardPool = 0xbDa5A375154A629090d9e3bE0ea26C23e5d1BD33;
373     //todo burn pool!
374     address public _burnPool = 0xbDa5A375154A629090d9e3bE0ea26C23e5d1BD33;
375 
376     /**
377     * @dev set the token transfer switch
378     */
379     function enableOpenTransfer() public onlyGovernance  
380     {
381         _openTransfer = true;
382     }
383 
384 
385     /**
386      * CONSTRUCTOR
387      *
388      * @dev Initialize the Token
389      */
390 
391     constructor () public ERC20Detailed("bdm", "bdm", _decimals) {
392         uint256 _exp = _decimals;
393          _maxSupply = 21000000 * (10**_exp);
394     }
395 
396 
397     
398     /**
399     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
400     * @param spender The address which will spend the funds.
401     * @param amount The amount of tokens to be spent.
402     */
403     function approve(address spender, uint256 amount) public 
404     returns (bool) 
405     {
406         require(msg.sender != address(0), "ERC20: approve from the zero address");
407         require(spender != address(0), "ERC20: approve to the zero address");
408 
409         _allowances[msg.sender][spender] = amount;
410         emit Approval(msg.sender, spender, amount);
411 
412         return true;
413     }
414 
415     /**
416     * @dev Function to check the amount of tokens than an owner _allowed to a spender.
417     * @param owner address The address which owns the funds.
418     * @param spender address The address which will spend the funds.
419     * @return A uint256 specifying the amount of tokens still available for the spender.
420     */
421     function allowance(address owner, address spender) public view 
422     returns (uint256) 
423     {
424         return _allowances[owner][spender];
425     }
426 
427     /**
428     * @dev Gets the balance of the specified address.
429     * @param owner The address to query the the balance of.
430     * @return An uint256 representing the amount owned by the passed address.
431     */
432     function balanceOf(address owner) public  view 
433     returns (uint256) 
434     {
435         return _balances[owner];
436     }
437 
438     /**
439     * @dev return the token total supply
440     */
441     function totalSupply() public view 
442     returns (uint256) 
443     {
444         return _totalSupply;
445     }
446 
447     /**
448     * @dev for mint function
449     */
450     function mint(address account, uint256 amount) public 
451     {
452         require(account != address(0), "ERC20: mint to the zero address");
453         require(_minters[msg.sender], "!minter");
454         require(_minters_number[msg.sender]>=amount);
455         uint256 curMintSupply = _totalSupply.add(_totalBurnToken);
456         uint256 newMintSupply = curMintSupply.add(amount);
457         require( newMintSupply <= _maxSupply,"supply is max!");
458 
459         _totalSupply = _totalSupply.add(amount);
460         _balances[account] = _balances[account].add(amount);
461         _minters_number[msg.sender] = _minters_number[msg.sender].sub(amount);
462         emit Mint(address(0), account, amount);
463         emit Transfer(address(0), account, amount);
464     }
465 
466     function addMinter(address _minter,uint256 number) public onlyGovernance 
467     {
468         _minters[_minter] = true;
469         _minters_number[_minter] = number;
470     }
471 
472 
473     function setMinter_number(address _minter,uint256 number) public onlyGovernance 
474     {
475         require(_minters[_minter]);
476         _minters_number[_minter] = number;
477     }
478     
479     function removeMinter(address _minter) public onlyGovernance 
480     {
481         _minters[_minter] = false;
482         _minters_number[_minter] = 0;
483     }
484     
485 
486     function() external payable {
487         revert();
488     }
489 
490     /**
491     * @dev for govern value
492     */
493     function setRate(uint256 burn_rate, uint256 reward_rate) public 
494         onlyGovernance 
495     {
496         
497         require(_maxGovernValueRate >= burn_rate && burn_rate >= _minGovernValueRate,"invalid burn rate");
498         require(_maxGovernValueRate >= reward_rate && reward_rate >= _minGovernValueRate,"invalid reward rate");
499 
500         _burnRate = burn_rate;
501         _rewardRate = reward_rate;
502 
503         emit eveSetRate(burn_rate, reward_rate);
504     }
505 
506 
507     
508 
509     /**
510     * @dev for set reward
511     */
512     function setRewardPool(address rewardPool,address burnPool) public 
513         onlyGovernance 
514     {
515         require(rewardPool != address(0x0));
516         require(burnPool != address(0x0));
517         _rewardPool = rewardPool;
518         _burnPool = burnPool;
519 
520         emit eveRewardPool(_rewardPool,_burnPool);
521     }
522     /**
523     * @dev transfer token for a specified address
524     * @param to The address to transfer to.
525     * @param value The amount to be transferred.
526     */
527    function transfer(address to, uint256 value) public 
528    returns (bool)  
529    {
530         return _transfer(msg.sender,to,value);
531     }
532 
533     /**
534     * @dev Transfer tokens from one address to another
535     * @param from address The address which you want to send tokens from
536     * @param to address The address which you want to transfer to
537     * @param value uint256 the amount of tokens to be transferred
538     */
539     function transferFrom(address from, address to, uint256 value) public 
540     returns (bool) 
541     {
542         uint256 allow = _allowances[from][msg.sender];
543         _allowances[from][msg.sender] = allow.sub(value);
544         
545         return _transfer(from,to,value);
546     }
547 
548  
549 
550     /**
551     * @dev Transfer tokens with fee
552     * @param from address The address which you want to send tokens from
553     * @param to address The address which you want to transfer to
554     * @param value uint256s the amount of tokens to be transferred
555     */
556     function _transfer(address from, address to, uint256 value) internal 
557     returns (bool) 
558     {
559         // :)
560         require(_openTransfer || from == governance, "transfer closed");
561 
562         require(from != address(0), "ERC20: transfer from the zero address");
563         require(to != address(0), "ERC20: transfer to the zero address");
564 
565         uint256 sendAmount = value;
566         uint256 burnFee = (value.mul(_burnRate)).div(_rateBase);
567         if (burnFee > 0) {
568             //to burn
569             _balances[_burnPool] = _balances[_burnPool].add(burnFee);
570             _totalSupply = _totalSupply.sub(burnFee);
571             sendAmount = sendAmount.sub(burnFee);
572 
573             _totalBurnToken = _totalBurnToken.add(burnFee);
574 
575             emit Transfer(from, _burnPool, burnFee);
576         }
577 
578         uint256 rewardFee = (value.mul(_rewardRate)).div(_rateBase);
579         if (rewardFee > 0) {
580            //to reward
581             _balances[_rewardPool] = _balances[_rewardPool].add(rewardFee);
582             sendAmount = sendAmount.sub(rewardFee);
583 
584             _totalRewardToken = _totalRewardToken.add(rewardFee);
585 
586             emit Transfer(from, _rewardPool, rewardFee);
587         }
588 
589         _balances[from] = _balances[from].sub(value);
590         _balances[to] = _balances[to].add(sendAmount);
591 
592         emit Transfer(from, to, sendAmount);
593 
594         return true;
595     }
596 }