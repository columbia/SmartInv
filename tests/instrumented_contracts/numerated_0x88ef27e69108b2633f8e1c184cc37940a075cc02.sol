1 /***
2  *    ██████╗ ███████╗ ██████╗  ██████╗ 
3  *    ██╔══██╗██╔════╝██╔════╝ ██╔═══██╗
4  *    ██║  ██║█████╗  ██║  ███╗██║   ██║
5  *    ██║  ██║██╔══╝  ██║   ██║██║   ██║
6  *    ██████╔╝███████╗╚██████╔╝╚██████╔╝
7  *    ╚═════╝ ╚══════╝ ╚═════╝  ╚═════╝ 
8  *    
9  * https://dego.finance
10                                   
11 * MIT License
12 * ===========
13 *
14 * Copyright (c) 2020 dego
15 *
16 * Permission is hereby granted, free of charge, to any person obtaining a copy
17 * of this software and associated documentation files (the "Software"), to deal
18 * in the Software without restriction, including without limitation the rights
19 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
20 * copies of the Software, and to permit persons to whom the Software is
21 * furnished to do so, subject to the following conditions:
22 *
23 * The above copyright notice and this permission notice shall be included in all
24 * copies or substantial portions of the Software.
25 *
26 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
29 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
32 */
33 // File: @openzeppelin/contracts/math/SafeMath.sol
34 
35 pragma solidity ^0.5.0;
36 
37 /**
38  * @dev Wrappers over Solidity's arithmetic operations with added overflow
39  * checks.
40  *
41  * Arithmetic operations in Solidity wrap on overflow. This can easily result
42  * in bugs, because programmers usually assume that an overflow raises an
43  * error, which is the standard behavior in high level programming languages.
44  * `SafeMath` restores this intuition by reverting the transaction when an
45  * operation overflows.
46  *
47  * Using this library instead of the unchecked operations eliminates an entire
48  * class of bugs, so it's recommended to use it always.
49  */
50 library SafeMath {
51     /**
52      * @dev Returns the addition of two unsigned integers, reverting on
53      * overflow.
54      *
55      * Counterpart to Solidity's `+` operator.
56      *
57      * Requirements:
58      * - Addition cannot overflow.
59      */
60     function add(uint256 a, uint256 b) internal pure returns (uint256) {
61         uint256 c = a + b;
62         require(c >= a, "SafeMath: addition overflow");
63 
64         return c;
65     }
66 
67     /**
68      * @dev Returns the subtraction of two unsigned integers, reverting on
69      * overflow (when the result is negative).
70      *
71      * Counterpart to Solidity's `-` operator.
72      *
73      * Requirements:
74      * - Subtraction cannot overflow.
75      */
76     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77         return sub(a, b, "SafeMath: subtraction overflow");
78     }
79 
80     /**
81      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
82      * overflow (when the result is negative).
83      *
84      * Counterpart to Solidity's `-` operator.
85      *
86      * Requirements:
87      * - Subtraction cannot overflow.
88      *
89      * _Available since v2.4.0._
90      */
91     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
92         require(b <= a, errorMessage);
93         uint256 c = a - b;
94 
95         return c;
96     }
97 
98     /**
99      * @dev Returns the multiplication of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `*` operator.
103      *
104      * Requirements:
105      * - Multiplication cannot overflow.
106      */
107     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
108         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
109         // benefit is lost if 'b' is also tested.
110         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
111         if (a == 0) {
112             return 0;
113         }
114 
115         uint256 c = a * b;
116         require(c / a == b, "SafeMath: multiplication overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the integer division of two unsigned integers. Reverts on
123      * division by zero. The result is rounded towards zero.
124      *
125      * Counterpart to Solidity's `/` operator. Note: this function uses a
126      * `revert` opcode (which leaves remaining gas untouched) while Solidity
127      * uses an invalid opcode to revert (consuming all remaining gas).
128      *
129      * Requirements:
130      * - The divisor cannot be zero.
131      */
132     function div(uint256 a, uint256 b) internal pure returns (uint256) {
133         return div(a, b, "SafeMath: division by zero");
134     }
135 
136     /**
137      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
138      * division by zero. The result is rounded towards zero.
139      *
140      * Counterpart to Solidity's `/` operator. Note: this function uses a
141      * `revert` opcode (which leaves remaining gas untouched) while Solidity
142      * uses an invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      * - The divisor cannot be zero.
146      *
147      * _Available since v2.4.0._
148      */
149     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         // Solidity only automatically asserts when dividing by 0
151         require(b > 0, errorMessage);
152         uint256 c = a / b;
153         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
160      * Reverts when dividing by zero.
161      *
162      * Counterpart to Solidity's `%` operator. This function uses a `revert`
163      * opcode (which leaves remaining gas untouched) while Solidity uses an
164      * invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      * - The divisor cannot be zero.
168      */
169     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
170         return mod(a, b, "SafeMath: modulo by zero");
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts with custom message when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      *
184      * _Available since v2.4.0._
185      */
186     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b != 0, errorMessage);
188         return a % b;
189     }
190 }
191 
192 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
193 
194 pragma solidity ^0.5.0;
195 
196 /**
197  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
198  * the optional functions; to access them see {ERC20Detailed}.
199  */
200 interface IERC20 {
201     /**
202      * @dev Returns the amount of tokens in existence.
203      */
204     function totalSupply() external view returns (uint256);
205 
206     /**
207      * @dev Returns the amount of tokens owned by `account`.
208      */
209     function balanceOf(address account) external view returns (uint256);
210 
211     /**
212      * @dev Moves `amount` tokens from the caller's account to `recipient`.
213      *
214      * Returns a boolean value indicating whether the operation succeeded.
215      *
216      * Emits a {Transfer} event.
217      */
218     function transfer(address recipient, uint256 amount) external returns (bool);
219 
220     /**
221      * @dev Returns the remaining number of tokens that `spender` will be
222      * allowed to spend on behalf of `owner` through {transferFrom}. This is
223      * zero by default.
224      *
225      * This value changes when {approve} or {transferFrom} are called.
226      */
227     function allowance(address owner, address spender) external view returns (uint256);
228 
229     /**
230      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
231      *
232      * Returns a boolean value indicating whether the operation succeeded.
233      *
234      * IMPORTANT: Beware that changing an allowance with this method brings the risk
235      * that someone may use both the old and the new allowance by unfortunate
236      * transaction ordering. One possible solution to mitigate this race
237      * condition is to first reduce the spender's allowance to 0 and set the
238      * desired value afterwards:
239      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
240      *
241      * Emits an {Approval} event.
242      */
243     function approve(address spender, uint256 amount) external returns (bool);
244 
245     /**
246      * @dev Moves `amount` tokens from `sender` to `recipient` using the
247      * allowance mechanism. `amount` is then deducted from the caller's
248      * allowance.
249      *
250      * Returns a boolean value indicating whether the operation succeeded.
251      *
252      * Emits a {Transfer} event.
253      */
254     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
255 
256     /**
257      * @dev Emitted when `value` tokens are moved from one account (`from`) to
258      * another (`to`).
259      *
260      * Note that `value` may be zero.
261      */
262     event Transfer(address indexed from, address indexed to, uint256 value);
263 
264     /**
265      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
266      * a call to {approve}. `value` is the new allowance.
267      */
268     event Approval(address indexed owner, address indexed spender, uint256 value);
269 }
270 
271 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
272 
273 pragma solidity ^0.5.0;
274 
275 
276 /**
277  * @dev Optional functions from the ERC20 standard.
278  */
279 contract ERC20Detailed is IERC20 {
280     string private _name;
281     string private _symbol;
282     uint8 private _decimals;
283 
284     /**
285      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
286      * these values are immutable: they can only be set once during
287      * construction.
288      */
289     constructor (string memory name, string memory symbol, uint8 decimals) public {
290         _name = name;
291         _symbol = symbol;
292         _decimals = decimals;
293     }
294 
295     /**
296      * @dev Returns the name of the token.
297      */
298     function name() public view returns (string memory) {
299         return _name;
300     }
301 
302     /**
303      * @dev Returns the symbol of the token, usually a shorter version of the
304      * name.
305      */
306     function symbol() public view returns (string memory) {
307         return _symbol;
308     }
309 
310     /**
311      * @dev Returns the number of decimals used to get its user representation.
312      * For example, if `decimals` equals `2`, a balance of `505` tokens should
313      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
314      *
315      * Tokens usually opt for a value of 18, imitating the relationship between
316      * Ether and Wei.
317      *
318      * NOTE: This information is only used for _display_ purposes: it in
319      * no way affects any of the arithmetic of the contract, including
320      * {IERC20-balanceOf} and {IERC20-transfer}.
321      */
322     function decimals() public view returns (uint8) {
323         return _decimals;
324     }
325 }
326 
327 // File: contracts/library/Governance.sol
328 
329 pragma solidity ^0.5.5;
330 
331 contract Governance {
332 
333     address public governance;
334 
335     constructor() public {
336         governance = tx.origin;
337     }
338 
339     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
340 
341     modifier onlyGovernance {
342         require(msg.sender == governance, "not governance");
343         _;
344     }
345 
346     function setGovernance(address _governance)  public  onlyGovernance
347     {
348         require(_governance != address(0), "new governance the zero address");
349         emit GovernanceTransferred(governance, _governance);
350         governance = _governance;
351     }
352 
353 
354 
355 }
356 
357 // File: contracts/token/DegoToken.sol
358 
359 pragma solidity ^0.5.5;
360 
361 
362 
363 
364 /// @title DegoToken Contract
365 
366 contract DegoToken is Governance, ERC20Detailed{
367 
368     using SafeMath for uint256;
369 
370     //events
371     event eveSetRate(uint256 burn_rate, uint256 reward_rate);
372     event eveRewardPool(address rewardPool);
373     event Transfer(address indexed from, address indexed to, uint256 value);
374     event Mint(address indexed from, address indexed to, uint256 value);
375     event Approval(address indexed owner, address indexed spender, uint256 value);
376 
377     // for minters
378     mapping (address => bool) public _minters;
379 
380     //token base data
381     uint256 internal _totalSupply;
382     mapping(address => uint256) public _balances;
383     mapping (address => mapping (address => uint256)) public _allowances;
384 
385     /// Constant token specific fields
386     uint256 public  _maxSupply = 0;
387 
388     ///
389     bool public _openTransfer = false;
390 
391     // hardcode limit rate
392     uint256 public constant _maxGovernValueRate = 2000;//2000/10000
393     uint256 public constant _minGovernValueRate = 10;  //10/10000
394     uint256 public constant _rateBase = 10000; 
395 
396     // additional variables for use if transaction fees ever became necessary
397     uint256 public  _burnRate = 250;       
398     uint256 public  _rewardRate = 250;   
399 
400     uint256 public _totalBurnToken = 0;
401     uint256 public _totalRewardToken = 0;
402 
403     //todo reward pool!
404     address public _rewardPool = 0xEA6dEc98e137a87F78495a8386f7A137408f7722;
405     //todo burn pool!
406     address public _burnPool = 0x6666666666666666666666666666666666666666;
407 
408     /**
409     * @dev set the token transfer switch
410     */
411     function enableOpenTransfer() public onlyGovernance  
412     {
413         _openTransfer = true;
414     }
415 
416 
417     /**
418      * CONSTRUCTOR
419      *
420      * @dev Initialize the Token
421      */
422 
423     constructor () public ERC20Detailed("dego.finance", "DEGO", 18) {
424          _maxSupply = 21000000 * (10**18);
425     }
426 
427 
428     
429     /**
430     * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
431     * @param spender The address which will spend the funds.
432     * @param amount The amount of tokens to be spent.
433     */
434     function approve(address spender, uint256 amount) external 
435     returns (bool) 
436     {
437         require(msg.sender != address(0), "ERC20: approve from the zero address");
438         require(spender != address(0), "ERC20: approve to the zero address");
439 
440         _allowances[msg.sender][spender] = amount;
441         emit Approval(msg.sender, spender, amount);
442 
443         return true;
444     }
445 
446     /**
447     * @dev Function to check the amount of tokens than an owner _allowed to a spender.
448     * @param owner address The address which owns the funds.
449     * @param spender address The address which will spend the funds.
450     * @return A uint256 specifying the amount of tokens still available for the spender.
451     */
452     function allowance(address owner, address spender) external view 
453     returns (uint256) 
454     {
455         return _allowances[owner][spender];
456     }
457 
458     /**
459     * @dev Gets the balance of the specified address.
460     * @param owner The address to query the the balance of.
461     * @return An uint256 representing the amount owned by the passed address.
462     */
463     function balanceOf(address owner) external  view 
464     returns (uint256) 
465     {
466         return _balances[owner];
467     }
468 
469     /**
470     * @dev return the token total supply
471     */
472     function totalSupply() external view 
473     returns (uint256) 
474     {
475         return _totalSupply;
476     }
477 
478     /**
479     * @dev for mint function
480     */
481     function mint(address account, uint256 amount) external 
482     {
483         require(account != address(0), "ERC20: mint to the zero address");
484         require(_minters[msg.sender], "!minter");
485 
486         uint256 curMintSupply = _totalSupply.add(_totalBurnToken);
487         uint256 newMintSupply = curMintSupply.add(amount);
488         require( newMintSupply <= _maxSupply,"supply is max!");
489       
490         _totalSupply = _totalSupply.add(amount);
491         _balances[account] = _balances[account].add(amount);
492 
493         emit Mint(address(0), account, amount);
494         emit Transfer(address(0), account, amount);
495     }
496 
497     function addMinter(address _minter) public onlyGovernance 
498     {
499         _minters[_minter] = true;
500     }
501     
502     function removeMinter(address _minter) public onlyGovernance 
503     {
504         _minters[_minter] = false;
505     }
506     
507 
508     function() external payable {
509         revert();
510     }
511 
512     /**
513     * @dev for govern value
514     */
515     function setRate(uint256 burn_rate, uint256 reward_rate) public 
516         onlyGovernance 
517     {
518         
519         require(_maxGovernValueRate >= burn_rate && burn_rate >= _minGovernValueRate,"invalid burn rate");
520         require(_maxGovernValueRate >= reward_rate && reward_rate >= _minGovernValueRate,"invalid reward rate");
521 
522         _burnRate = burn_rate;
523         _rewardRate = reward_rate;
524 
525         emit eveSetRate(burn_rate, reward_rate);
526     }
527 
528 
529     /**
530     * @dev for set reward
531     */
532     function setRewardPool(address rewardPool) public 
533         onlyGovernance 
534     {
535         require(rewardPool != address(0x0));
536 
537         _rewardPool = rewardPool;
538 
539         emit eveRewardPool(_rewardPool);
540     }
541     /**
542     * @dev transfer token for a specified address
543     * @param to The address to transfer to.
544     * @param value The amount to be transferred.
545     */
546    function transfer(address to, uint256 value) external 
547    returns (bool)  
548    {
549         return _transfer(msg.sender,to,value);
550     }
551 
552     /**
553     * @dev Transfer tokens from one address to another
554     * @param from address The address which you want to send tokens from
555     * @param to address The address which you want to transfer to
556     * @param value uint256 the amount of tokens to be transferred
557     */
558     function transferFrom(address from, address to, uint256 value) external 
559     returns (bool) 
560     {
561         uint256 allow = _allowances[from][msg.sender];
562         _allowances[from][msg.sender] = allow.sub(value);
563         
564         return _transfer(from,to,value);
565     }
566 
567  
568 
569     /**
570     * @dev Transfer tokens with fee
571     * @param from address The address which you want to send tokens from
572     * @param to address The address which you want to transfer to
573     * @param value uint256s the amount of tokens to be transferred
574     */
575     function _transfer(address from, address to, uint256 value) internal 
576     returns (bool) 
577     {
578         // :)
579         require(_openTransfer || from == governance, "transfer closed");
580 
581         require(from != address(0), "ERC20: transfer from the zero address");
582         require(to != address(0), "ERC20: transfer to the zero address");
583 
584         uint256 sendAmount = value;
585         uint256 burnFee = (value.mul(_burnRate)).div(_rateBase);
586         if (burnFee > 0) {
587             //to burn
588             _balances[_burnPool] = _balances[_burnPool].add(burnFee);
589             _totalSupply = _totalSupply.sub(burnFee);
590             sendAmount = sendAmount.sub(burnFee);
591 
592             _totalBurnToken = _totalBurnToken.add(burnFee);
593 
594             emit Transfer(from, _burnPool, burnFee);
595         }
596 
597         uint256 rewardFee = (value.mul(_rewardRate)).div(_rateBase);
598         if (rewardFee > 0) {
599            //to reward
600             _balances[_rewardPool] = _balances[_rewardPool].add(rewardFee);
601             sendAmount = sendAmount.sub(rewardFee);
602 
603             _totalRewardToken = _totalRewardToken.add(rewardFee);
604 
605             emit Transfer(from, _rewardPool, rewardFee);
606         }
607 
608         _balances[from] = _balances[from].sub(value);
609         _balances[to] = _balances[to].add(sendAmount);
610 
611         emit Transfer(from, to, sendAmount);
612 
613         return true;
614     }
615 }
