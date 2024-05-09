1 /***
2  *  _____       _     _____                         
3  * |   | |___ _| |___| __  |_ _ ___ ___ ___ ___ ___ 
4  * | | | | . | . | -_|    -| | |   |   | -_|  _|_ -|
5  * |_|___|___|___|___|__|__|___|_|_|_|_|___|_| |___|
6  * 
7  * https://noderunners.io
8 
9 * MIT License
10 * ===========
11 *
12 * Copyright (c) 2020 NodeRunners
13 *
14 * Permission is hereby granted, free of charge, to any person obtaining a copy
15 * of this software and associated documentation files (the "Software"), to deal
16 * in the Software without restriction, including without limitation the rights
17 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
18 * copies of the Software, and to permit persons to whom the Software is
19 * furnished to do so, subject to the following conditions:
20 *
21 * The above copyright notice and this permission notice shall be included in all
22 * copies or substantial portions of the Software.
23 *
24 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
25 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
26 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
27 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
28 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
29 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
30 */
31 
32 pragma solidity ^0.5.0;
33 
34 /**
35  * @dev Wrappers over Solidity's arithmetic operations with added overflow
36  * checks.
37  *
38  * Arithmetic operations in Solidity wrap on overflow. This can easily result
39  * in bugs, because programmers usually assume that an overflow raises an
40  * error, which is the standard behavior in high level programming languages.
41  * `SafeMath` restores this intuition by reverting the transaction when an
42  * operation overflows.
43  *
44  * Using this library instead of the unchecked operations eliminates an entire
45  * class of bugs, so it's recommended to use it always.
46  */
47 library SafeMath {
48     /**
49      * @dev Returns the addition of two unsigned integers, reverting on
50      * overflow.
51      *
52      * Counterpart to Solidity's `+` operator.
53      *
54      * Requirements:
55      * - Addition cannot overflow.
56      */
57     function add(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a + b;
59         require(c >= a, "SafeMath: addition overflow");
60 
61         return c;
62     }
63 
64     /**
65      * @dev Returns the subtraction of two unsigned integers, reverting on
66      * overflow (when the result is negative).
67      *
68      * Counterpart to Solidity's `-` operator.
69      *
70      * Requirements:
71      * - Subtraction cannot overflow.
72      */
73     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
74         return sub(a, b, "SafeMath: subtraction overflow");
75     }
76 
77     /**
78      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
79      * overflow (when the result is negative).
80      *
81      * Counterpart to Solidity's `-` operator.
82      *
83      * Requirements:
84      * - Subtraction cannot overflow.
85      *
86      * _Available since v2.4.0._
87      */
88     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
89         require(b <= a, errorMessage);
90         uint256 c = a - b;
91 
92         return c;
93     }
94 
95     /**
96      * @dev Returns the multiplication of two unsigned integers, reverting on
97      * overflow.
98      *
99      * Counterpart to Solidity's `*` operator.
100      *
101      * Requirements:
102      * - Multiplication cannot overflow.
103      */
104     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
105         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
106         // benefit is lost if 'b' is also tested.
107         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
108         if (a == 0) {
109             return 0;
110         }
111 
112         uint256 c = a * b;
113         require(c / a == b, "SafeMath: multiplication overflow");
114 
115         return c;
116     }
117 
118     /**
119      * @dev Returns the integer division of two unsigned integers. Reverts on
120      * division by zero. The result is rounded towards zero.
121      *
122      * Counterpart to Solidity's `/` operator. Note: this function uses a
123      * `revert` opcode (which leaves remaining gas untouched) while Solidity
124      * uses an invalid opcode to revert (consuming all remaining gas).
125      *
126      * Requirements:
127      * - The divisor cannot be zero.
128      */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         return div(a, b, "SafeMath: division by zero");
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator. Note: this function uses a
138      * `revert` opcode (which leaves remaining gas untouched) while Solidity
139      * uses an invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      * - The divisor cannot be zero.
143      *
144      * _Available since v2.4.0._
145      */
146     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         // Solidity only automatically asserts when dividing by 0
148         require(b > 0, errorMessage);
149         uint256 c = a / b;
150         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
157      * Reverts when dividing by zero.
158      *
159      * Counterpart to Solidity's `%` operator. This function uses a `revert`
160      * opcode (which leaves remaining gas untouched) while Solidity uses an
161      * invalid opcode to revert (consuming all remaining gas).
162      *
163      * Requirements:
164      * - The divisor cannot be zero.
165      */
166     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
167         return mod(a, b, "SafeMath: modulo by zero");
168     }
169 
170     /**
171      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
172      * Reverts with custom message when dividing by zero.
173      *
174      * Counterpart to Solidity's `%` operator. This function uses a `revert`
175      * opcode (which leaves remaining gas untouched) while Solidity uses an
176      * invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      * - The divisor cannot be zero.
180      *
181      * _Available since v2.4.0._
182      */
183     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
184         require(b != 0, errorMessage);
185         return a % b;
186     }
187 }
188 
189 
190 pragma solidity ^0.5.0;
191 
192 /**
193  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
194  * the optional functions; to access them see {ERC20Detailed}.
195  */
196 interface IERC20 {
197     /**
198      * @dev Returns the amount of tokens in existence.
199      */
200     function totalSupply() external view returns (uint256);
201 
202     /**
203      * @dev Returns the amount of tokens owned by `account`.
204      */
205     function balanceOf(address account) external view returns (uint256);
206 
207     /**
208      * @dev Moves `amount` tokens from the caller's account to `recipient`.
209      *
210      * Returns a boolean value indicating whether the operation succeeded.
211      *
212      * Emits a {Transfer} event.
213      */
214     function transfer(address recipient, uint256 amount) external returns (bool);
215 
216     /**
217      * @dev Returns the remaining number of tokens that `spender` will be
218      * allowed to spend on behalf of `owner` through {transferFrom}. This is
219      * zero by default.
220      *
221      * This value changes when {approve} or {transferFrom} are called.
222      */
223     function allowance(address owner, address spender) external view returns (uint256);
224 
225     /**
226      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
227      *
228      * Returns a boolean value indicating whether the operation succeeded.
229      *
230      * IMPORTANT: Beware that changing an allowance with this method brings the risk
231      * that someone may use both the old and the new allowance by unfortunate
232      * transaction ordering. One possible solution to mitigate this race
233      * condition is to first reduce the spender's allowance to 0 and set the
234      * desired value afterwards:
235      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
236      *
237      * Emits an {Approval} event.
238      */
239     function approve(address spender, uint256 amount) external returns (bool);
240 
241     /**
242      * @dev Moves `amount` tokens from `sender` to `recipient` using the
243      * allowance mechanism. `amount` is then deducted from the caller's
244      * allowance.
245      *
246      * Returns a boolean value indicating whether the operation succeeded.
247      *
248      * Emits a {Transfer} event.
249      */
250     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
251 
252     /**
253      * @dev Emitted when `value` tokens are moved from one account (`from`) to
254      * another (`to`).
255      *
256      * Note that `value` may be zero.
257      */
258     event Transfer(address indexed from, address indexed to, uint256 value);
259 
260     /**
261      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
262      * a call to {approve}. `value` is the new allowance.
263      */
264     event Approval(address indexed owner, address indexed spender, uint256 value);
265 }
266 
267 
268 pragma solidity ^0.5.0;
269 
270 
271 /**
272  * @dev Optional functions from the ERC20 standard.
273  */
274 contract ERC20Detailed is IERC20 {
275     string private _name;
276     string private _symbol;
277     uint8 private _decimals;
278 
279     /**
280      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
281      * these values are immutable: they can only be set once during
282      * construction.
283      */
284     constructor (string memory name, string memory symbol, uint8 decimals) public {
285         _name = name;
286         _symbol = symbol;
287         _decimals = decimals;
288     }
289 
290     /**
291      * @dev Returns the name of the token.
292      */
293     function name() public view returns (string memory) {
294         return _name;
295     }
296 
297     /**
298      * @dev Returns the symbol of the token, usually a shorter version of the
299      * name.
300      */
301     function symbol() public view returns (string memory) {
302         return _symbol;
303     }
304 
305     /**
306      * @dev Returns the number of decimals used to get its user representation.
307      * For example, if `decimals` equals `2`, a balance of `505` tokens should
308      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
309      *
310      * Tokens usually opt for a value of 18, imitating the relationship between
311      * Ether and Wei.
312      *
313      * NOTE: This information is only used for _display_ purposes: it in
314      * no way affects any of the arithmetic of the contract, including
315      * {IERC20-balanceOf} and {IERC20-transfer}.
316      */
317     function decimals() public view returns (uint8) {
318         return _decimals;
319     }
320 }
321 
322 
323 pragma solidity ^0.5.5;
324 
325 contract Governance {
326 
327     address public governance;
328 
329     constructor() public {
330         governance = tx.origin;
331     }
332 
333     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
334 
335     modifier onlyGovernance {
336         require(msg.sender == governance, "not governance");
337         _;
338     }
339 
340     function setGovernance(address _governance)  public  onlyGovernance
341     {
342         require(_governance != address(0), "new governance the zero address");
343         emit GovernanceTransferred(governance, _governance);
344         governance = _governance;
345     }
346 }
347 
348 
349 pragma solidity ^0.5.5;
350 
351 /// @title NodeRunners Contract
352 
353 contract NodeRunnersToken is Governance, ERC20Detailed{
354 
355     using SafeMath for uint256;
356 
357     //events
358     event eveSetRate(uint256 burn_rate, uint256 reward_rate);
359     event eveStakingPool(address stakingPool);
360     event Transfer(address indexed from, address indexed to, uint256 value);
361     event Approval(address indexed owner, address indexed spender, uint256 value);
362 
363     //token base data
364     uint256 internal _totalSupply;
365     mapping(address => uint256) public _balances;
366     mapping (address => mapping (address => uint256)) public _allowances;
367 
368     bool public _openTransfer = false;
369 
370     // hardcode limit rate
371     uint256 public constant _maxGovernValueRate = 2000;//2000/10000
372     uint256 public constant _minGovernValueRate = 0;  //0/10000
373     uint256 public constant _rateBase = 10000;
374 
375     // additional variables for use if transaction fees ever became necessary
376     uint256 public  _burnRate = 0;
377     uint256 public  _rewardRate = 200;
378 
379     uint256 public _totalBurnToken = 0;
380     uint256 public _totalRewardToken = 0;
381 
382     address public _stakingPool;
383     address public _burnPool = 0x0000000000000000000000000000000000000000;
384 
385     /**
386     * @dev set the token transfer switch
387     */
388     function enableOpenTransfer() public onlyGovernance
389     {
390         _openTransfer = true;
391     }
392 
393     /**
394     * CONSTRUCTOR
395     *
396     * @dev Initialize the Token
397     */
398     constructor (address governance) public ERC20Detailed("NodeRunners", "NDR", 18) {
399         _totalSupply = 28000 * (10**18); //28,000
400         _balances[governance] = _balances[governance].add(_totalSupply);
401         emit Transfer(address(0), governance, _totalSupply);
402     }
403 
404     /**
405     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
406     * @param spender The address which will spend the funds.
407     * @param amount The amount of tokens to be spent.
408     */
409     function approve(address spender, uint256 amount) external
410     returns (bool)
411     {
412         require(msg.sender != address(0), "ERC20: approve from the zero address");
413         require(spender != address(0), "ERC20: approve to the zero address");
414 
415         _allowances[msg.sender][spender] = amount;
416         emit Approval(msg.sender, spender, amount);
417 
418         return true;
419     }
420 
421     /**
422     * @dev Function to check the amount of tokens than an owner _allowed to a spender.
423     * @param owner address The address which owns the funds.
424     * @param spender address The address which will spend the funds.
425     * @return A uint256 specifying the amount of tokens still available for the spender.
426     */
427     function allowance(address owner, address spender) external view
428     returns (uint256)
429     {
430         return _allowances[owner][spender];
431     }
432 
433     /**
434     * @dev Gets the balance of the specified address.
435     * @param owner The address to query the the balance of.
436     * @return An uint256 representing the amount owned by the passed address.
437     */
438     function balanceOf(address owner) external  view
439     returns (uint256)
440     {
441         return _balances[owner];
442     }
443 
444     /**
445     * @dev return the token total supply
446     */
447     function totalSupply() external view
448     returns (uint256)
449     {
450         return _totalSupply;
451     }
452 
453     function() external payable {
454         revert();
455     }
456 
457     /**
458     * @dev for govern value
459     */
460     function setRate(uint256 burn_rate, uint256 reward_rate) public
461         onlyGovernance
462     {
463         require(_maxGovernValueRate >= burn_rate && burn_rate >= _minGovernValueRate,"invalid burn rate");
464         require(_maxGovernValueRate >= reward_rate && reward_rate >= _minGovernValueRate,"invalid reward rate");
465 
466         _burnRate = burn_rate;
467         _rewardRate = reward_rate;
468 
469         emit eveSetRate(burn_rate, reward_rate);
470     }
471 
472     /**
473     * @dev for set reward
474     */
475     function setStakingPool(address stakingPool) public
476         onlyGovernance
477     {
478         require(stakingPool != address(0x0));
479 
480         _stakingPool = stakingPool;
481 
482         emit eveStakingPool(_stakingPool);
483     }
484     /**
485     * @dev transfer token for a specified address
486     * @param to The address to transfer to.
487     * @param value The amount to be transferred.
488     */
489    function transfer(address to, uint256 value) external
490    returns (bool)
491    {
492         return _transfer(msg.sender,to,value);
493     }
494 
495     /**
496     * @dev Transfer tokens from one address to another
497     * @param from address The address which you want to send tokens from
498     * @param to address The address which you want to transfer to
499     * @param value uint256 the amount of tokens to be transferred
500     */
501     function transferFrom(address from, address to, uint256 value) external
502     returns (bool)
503     {
504         uint256 allow = _allowances[from][msg.sender];
505         _allowances[from][msg.sender] = allow.sub(value);
506 
507         return _transfer(from,to,value);
508     }
509 
510 
511     /**
512     * @dev Transfer tokens with fee
513     * @param from address The address which you want to send tokens from
514     * @param to address The address which you want to transfer to
515     * @param value uint256s the amount of tokens to be transferred
516     */
517     function _transfer(address from, address to, uint256 value) internal
518     returns (bool)
519     {
520         // :)
521         require(_openTransfer || from == governance, "transfer closed");
522 
523         require(from != address(0), "ERC20: transfer from the zero address");
524         require(to != address(0), "ERC20: transfer to the zero address");
525 
526         uint256 sendAmount = value;
527         uint256 burnFee = (value.mul(_burnRate)).div(_rateBase);
528         if (burnFee > 0) {
529             //to burn
530             _balances[_burnPool] = _balances[_burnPool].add(burnFee);
531             _totalSupply = _totalSupply.sub(burnFee);
532             sendAmount = sendAmount.sub(burnFee);
533 
534             _totalBurnToken = _totalBurnToken.add(burnFee);
535 
536             emit Transfer(from, _burnPool, burnFee);
537         }
538 
539         uint256 rewardFee = (value.mul(_rewardRate)).div(_rateBase);
540         if (rewardFee > 0) {
541            //to reward
542             _balances[_stakingPool] = _balances[_stakingPool].add(rewardFee);
543             sendAmount = sendAmount.sub(rewardFee);
544 
545             _totalRewardToken = _totalRewardToken.add(rewardFee);
546 
547             emit Transfer(from, _stakingPool, rewardFee);
548         }
549 
550         _balances[from] = _balances[from].sub(value);
551         _balances[to] = _balances[to].add(sendAmount);
552 
553         emit Transfer(from, to, sendAmount);
554 
555         return true;
556     }
557 }