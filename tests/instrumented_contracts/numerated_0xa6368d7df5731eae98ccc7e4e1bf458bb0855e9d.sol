1 /**
2  *Submitted for verification at Etherscan.io on 2021-07-27
3 */
4 
5 // SPDX-License-Identifier: Unlicensed
6 pragma solidity 0.6.12;
7 
8 interface IERC20 {
9   /**
10    * @dev Returns the amount of tokens in existence.
11    */
12   function totalSupply() external view returns (uint256);
13 
14   /**
15    * @dev Returns the token decimals.
16    */
17   function decimals() external view returns (uint8);
18 
19   /**
20    * @dev Returns the token symbol.
21    */
22   function symbol() external view returns (string memory);
23 
24   /**
25   * @dev Returns the token name.
26   */
27   function name() external view returns (string memory);
28 
29   /**
30    * @dev Returns the ERC token owner.
31    */
32   function getOwner() external view returns (address);
33 
34   /**
35    * @dev Returns the amount of tokens owned by `account`.
36    */
37   function balanceOf(address account) external view returns (uint256);
38 
39   /**
40    * @dev Moves `amount` tokens from the caller's account to `recipient`.
41    *
42    * Returns a boolean value indicating whether the operation succeeded.
43    *
44    * Emits a {Transfer} event.
45    */
46   function transfer(address recipient, uint256 amount) external returns (bool);
47 
48   /**
49    * @dev Returns the remaining number of tokens that `spender` will be
50    * allowed to spend on behalf of `owner` through {transferFrom}. This is
51    * zero by default.
52    *
53    * This value changes when {approve} or {transferFrom} are called.
54    */
55   function allowance(address _owner, address spender) external view returns (uint256);
56 
57   /**
58    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59    *
60    * Returns a boolean value indicating whether the operation succeeded.
61    *
62    * IMPORTANT: Beware that changing an allowance with this method brings the risk
63    * that someone may use both the old and the new allowance by unfortunate
64    * transaction ordering. One possible solution to mitigate this race
65    * condition is to first reduce the spender's allowance to 0 and set the
66    * desired value afterwards:
67    * https://github.com/ether/EIPs/issues/20#issuecomment-263524729
68    *
69    * Emits an {Approval} event.
70    */
71   function approve(address spender, uint256 amount) external returns (bool);
72 
73   /**
74    * @dev Moves `amount` tokens from `sender` to `recipient` using the
75    * allowance mechanism. `amount` is then deducted from the caller's
76    * allowance.
77    *
78    * Returns a boolean value indicating whether the operation succeeded.
79    *
80    * Emits a {Transfer} event.
81    */
82   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
83 
84   /**
85    * @dev Emitted when `value` tokens are moved from one account (`from`) to
86    * another (`to`).
87    *
88    * Note that `value` may be zero.
89    */
90   event Transfer(address indexed from, address indexed to, uint256 value);
91 
92   /**
93    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
94    * a call to {approve}. `value` is the new allowance.
95    */
96   event Approval(address indexed owner, address indexed spender, uint256 value);
97 }
98 
99 /*
100  * @dev Provides information about the current execution context, including the
101  * sender of the transaction and its data. While these are generally available
102  * via msg.sender and msg.data, they should not be accessed in such a direct
103  * manner, since when dealing with GSN meta-transactions the account sending and
104  * paying for execution may not be the actual sender (as far as an application
105  * is concerned).
106  *
107  * This contract is only required for intermediate, library-like contracts.
108  */
109 contract Context {
110   // Empty internal constructor, to prevent people from mistakenly deploying
111   // an instance of this contract, which should be used via inheritance.
112   constructor () internal { }
113 
114   function _msgSender() internal view returns (address payable) {
115     return msg.sender;
116   }
117 
118   function _msgData() internal view returns (bytes memory) {
119     this; // silence state mutability warning without generating bytecode - see https://github.com/ether/solidity/issues/2691
120     return msg.data;
121   }
122 }
123 
124 /**
125  * @dev Wrappers over Solidity's arithmetic operations with added overflow
126  * checks.
127  *
128  * Arithmetic operations in Solidity wrap on overflow. This can easily result
129  * in bugs, because programmers usually assume that an overflow raises an
130  * error, which is the standard behavior in high level programming languages.
131  * `SafeMath` restores this intuition by reverting the transaction when an
132  * operation overflows.
133  *
134  * Using this library instead of the unchecked operations eliminates an entire
135  * class of bugs, so it's recommended to use it always.
136  */
137 library SafeMath {
138   /**
139    * @dev Returns the addition of two unsigned integers, reverting on
140    * overflow.
141    *
142    * Counterpart to Solidity's `+` operator.
143    *
144    * Requirements:
145    * - Addition cannot overflow.
146    */
147   function add(uint256 a, uint256 b) internal pure returns (uint256) {
148     uint256 c = a + b;
149     require(c >= a, "SafeMath: addition overflow");
150 
151     return c;
152   }
153 
154   /**
155    * @dev Returns the subtraction of two unsigned integers, reverting on
156    * overflow (when the result is negative).
157    *
158    * Counterpart to Solidity's `-` operator.
159    *
160    * Requirements:
161    * - Subtraction cannot overflow.
162    */
163   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164     return sub(a, b, "SafeMath: subtraction overflow");
165   }
166 
167   /**
168    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
169    * overflow (when the result is negative).
170    *
171    * Counterpart to Solidity's `-` operator.
172    *
173    * Requirements:
174    * - Subtraction cannot overflow.
175    */
176   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177     require(b <= a, errorMessage);
178     uint256 c = a - b;
179 
180     return c;
181   }
182 
183   /**
184    * @dev Returns the multiplication of two unsigned integers, reverting on
185    * overflow.
186    *
187    * Counterpart to Solidity's `*` operator.
188    *
189    * Requirements:
190    * - Multiplication cannot overflow.
191    */
192   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
193     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
194     // benefit is lost if 'b' is also tested.
195     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
196     if (a == 0) {
197       return 0;
198     }
199 
200     uint256 c = a * b;
201     require(c / a == b, "SafeMath: multiplication overflow");
202 
203     return c;
204   }
205 
206   /**
207    * @dev Returns the integer division of two unsigned integers. Reverts on
208    * division by zero. The result is rounded towards zero.
209    *
210    * Counterpart to Solidity's `/` operator. Note: this function uses a
211    * `revert` opcode (which leaves remaining gas untouched) while Solidity
212    * uses an invalid opcode to revert (consuming all remaining gas).
213    *
214    * Requirements:
215    * - The divisor cannot be zero.
216    */
217   function div(uint256 a, uint256 b) internal pure returns (uint256) {
218     return div(a, b, "SafeMath: division by zero");
219   }
220 
221   /**
222    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
223    * division by zero. The result is rounded towards zero.
224    *
225    * Counterpart to Solidity's `/` operator. Note: this function uses a
226    * `revert` opcode (which leaves remaining gas untouched) while Solidity
227    * uses an invalid opcode to revert (consuming all remaining gas).
228    *
229    * Requirements:
230    * - The divisor cannot be zero.
231    */
232   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233     // Solidity only automatically asserts when dividing by 0
234     require(b > 0, errorMessage);
235     uint256 c = a / b;
236     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
237 
238     return c;
239   }
240 
241   /**
242    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243    * Reverts when dividing by zero.
244    *
245    * Counterpart to Solidity's `%` operator. This function uses a `revert`
246    * opcode (which leaves remaining gas untouched) while Solidity uses an
247    * invalid opcode to revert (consuming all remaining gas).
248    *
249    * Requirements:
250    * - The divisor cannot be zero.
251    */
252   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
253     return mod(a, b, "SafeMath: modulo by zero");
254   }
255 
256   /**
257    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258    * Reverts with custom message when dividing by zero.
259    *
260    * Counterpart to Solidity's `%` operator. This function uses a `revert`
261    * opcode (which leaves remaining gas untouched) while Solidity uses an
262    * invalid opcode to revert (consuming all remaining gas).
263    *
264    * Requirements:
265    * - The divisor cannot be zero.
266    */
267   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268     require(b != 0, errorMessage);
269     return a % b;
270   }
271 }
272 
273 /**
274  * @dev Contract module which provides a basic access control mechanism, where
275  * there is an account (an owner) that can be granted exclusive access to
276  * specific functions.
277  *
278  * By default, the owner account will be the one that deploys the contract. This
279  * can later be changed with {transferOwnership}.
280  *
281  * This module is used through inheritance. It will make available the modifier
282  * `onlyOwner`, which can be applied to your functions to restrict their use to
283  * the owner.
284  */
285 contract Ownable is Context {
286   address private _owner;
287 
288   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
289 
290   /**
291    * @dev Initializes the contract setting the deployer as the initial owner.
292    */
293   constructor () internal {
294     address msgSender = _msgSender();
295     _owner = msgSender;
296     emit OwnershipTransferred(address(0), msgSender);
297   }
298 
299   /**
300    * @dev Returns the address of the current owner.
301    */
302   function owner() public view returns (address) {
303     return _owner;
304   }
305 
306   /**
307    * @dev Throws if called by any account other than the owner.
308    */
309   modifier onlyOwner() {
310     require(_owner == _msgSender(), "Ownable: caller is not the owner");
311     _;
312   }
313   
314   /**
315    * @dev Transfers ownership of the contract to a new account (`newOwner`).
316    * Can only be called by the current owner.
317    */
318   function transferOwnership(address newOwner) public onlyOwner {
319     _transferOwnership(newOwner);
320   }
321 
322   /**
323    * @dev Transfers ownership of the contract to a new account (`newOwner`).
324    */
325   function _transferOwnership(address newOwner) internal {
326     require(newOwner != address(0), "Ownable: new owner is the zero address");
327     emit OwnershipTransferred(_owner, newOwner);
328     _owner = newOwner;
329   }
330 }
331 
332 contract KirbyReloaded is Context, IERC20, Ownable {
333   using SafeMath for uint256;
334 
335   mapping (address => uint256) private _balances;
336 
337   mapping (address => mapping (address => uint256)) private _allowances;
338 
339   uint256 private _totalSupply;
340   uint8 public _decimals;
341   string public _symbol;
342   string public _name;
343 
344   constructor() public {
345     _name = "Kirby Reloaded";
346     _symbol = "$KIRBYRELOADED";
347     _decimals = 18;
348     _totalSupply = 10000000 * 10**18;
349     _balances[msg.sender] = _totalSupply;
350     emit Transfer(address(0), msg.sender, _totalSupply);
351   }
352 
353   /**
354    * @dev Returns the ERC token owner.
355    */
356   function getOwner() external override view returns (address) {
357     return owner();
358   }
359 
360   /**
361    * @dev Returns the token decimals.
362    */
363   function decimals() external override view returns (uint8) {
364     return _decimals;
365   }
366 
367   /**
368    * @dev Returns the token symbol.
369    */
370   function symbol() external override view returns (string memory) {
371     return _symbol;
372   }
373 
374   /**
375   * @dev Returns the token name.
376   */
377   function name() external override view returns (string memory) {
378     return _name;
379   }
380 
381   /**
382    * @dev See {ERC20-totalSupply}.
383    */
384   function totalSupply() external override view returns (uint256) {
385     return _totalSupply;
386   }
387 
388   /**
389    * @dev See {ERC20-balanceOf}.
390    */
391   function balanceOf(address account) external override view returns (uint256) {
392     return _balances[account];
393   }
394 
395   /**
396    * @dev See {ERC20-transfer}.
397    *
398    * Requirements:
399    *
400    * - `recipient` cannot be the zero address.
401    * - the caller must have a balance of at least `amount`.
402    */
403   function transfer(address recipient, uint256 amount) external override returns (bool) {
404     _transfer(_msgSender(), recipient, amount);
405     return true;
406   }
407 
408   /**
409    * @dev See {ERC20-allowance}.
410    */
411   function allowance(address owner, address spender) external override view returns (uint256) {
412     return _allowances[owner][spender];
413   }
414 
415   /**
416    * @dev See {ERC20-approve}.
417    *
418    * Requirements:
419    *
420    * - `spender` cannot be the zero address.
421    */
422   function approve(address spender, uint256 amount) external override returns (bool) {
423     _approve(_msgSender(), spender, amount);
424     return true;
425   }
426 
427   /**
428    * @dev See {ERC20-transferFrom}.
429    *
430    * Emits an {Approval} event indicating the updated allowance. This is not
431    * required by the EIP. See the note at the beginning of {ERC20};
432    *
433    * Requirements:
434    * - `sender` and `recipient` cannot be the zero address.
435    * - `sender` must have a balance of at least `amount`.
436    * - the caller must have allowance for `sender`'s tokens of at least
437    * `amount`.
438    */
439   function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
440     _transfer(sender, recipient, amount);
441     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
442     return true;
443   }
444 
445   /**
446    * @dev Atomically increases the allowance granted to `spender` by the caller.
447    *
448    * This is an alternative to {approve} that can be used as a mitigation for
449    * problems described in {ERC20-approve}.
450    *
451    * Emits an {Approval} event indicating the updated allowance.
452    *
453    * Requirements:
454    *
455    * - `spender` cannot be the zero address.
456    */
457   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
458     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
459     return true;
460   }
461 
462   /**
463    * @dev Atomically decreases the allowance granted to `spender` by the caller.
464    *
465    * This is an alternative to {approve} that can be used as a mitigation for
466    * problems described in {ERC20-approve}.
467    *
468    * Emits an {Approval} event indicating the updated allowance.
469    *
470    * Requirements:
471    *
472    * - `spender` cannot be the zero address.
473    * - `spender` must have allowance for the caller of at least
474    * `subtractedValue`.
475    */
476   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
477     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
478     return true;
479   }
480 
481   /**
482    * @dev Burn `amount` tokens and decreasing the total supply.
483    */
484   function burn(uint256 amount) public returns (bool) {
485     _burn(_msgSender(), amount);
486     return true;
487   }
488 
489   /**
490    * @dev Moves tokens `amount` from `sender` to `recipient`.
491    *
492    * This is internal function is equivalent to {transfer}, and can be used to
493    * e.g. implement automatic token fees, slashing mechanisms, etc.
494    *
495    * Emits a {Transfer} event.
496    *
497    * Requirements:
498    *
499    * - `sender` cannot be the zero address.
500    * - `recipient` cannot be the zero address.
501    * - `sender` must have a balance of at least `amount`.
502    */
503   function _transfer(address sender, address recipient, uint256 amount) internal {
504     require(sender != address(0), "ERC20: transfer from the zero address");
505     require(recipient != address(0), "ERC20: transfer to the zero address");
506 
507     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
508     _balances[recipient] = _balances[recipient].add(amount);
509     emit Transfer(sender, recipient, amount);
510   }
511 
512   /**
513    * @dev Destroys `amount` tokens from `account`, reducing the
514    * total supply.
515    *
516    * Emits a {Transfer} event with `to` set to the zero address.
517    *
518    * Requirements
519    *
520    * - `account` cannot be the zero address.
521    * - `account` must have at least `amount` tokens.
522    */
523   function _burn(address account, uint256 amount) internal {
524     require(account != address(0), "ERC20: burn from the zero address");
525 
526     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
527     _totalSupply = _totalSupply.sub(amount);
528     emit Transfer(account, address(0), amount);
529   }
530 
531   /**
532    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
533    *
534    * This is internal function is equivalent to `approve`, and can be used to
535    * e.g. set automatic allowances for certain subsystems, etc.
536    *
537    * Emits an {Approval} event.
538    *
539    * Requirements:
540    *
541    * - `owner` cannot be the zero address.
542    * - `spender` cannot be the zero address.
543    */
544   function _approve(address owner, address spender, uint256 amount) internal {
545     require(owner != address(0), "ERC20: approve from the zero address");
546     require(spender != address(0), "ERC20: approve to the zero address");
547 
548     _allowances[owner][spender] = amount;
549     emit Approval(owner, spender, amount);
550   }
551 
552   /**
553    * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
554    * from the caller's allowance.
555    *
556    * See {_burn} and {_approve}.
557    */
558   function _burnFrom(address account, uint256 amount) public {
559     _burn(account, amount);
560     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
561   }
562 }