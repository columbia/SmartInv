1 pragma solidity ^0.5.16;
2 
3 interface IERC20 {
4   /**
5    * @dev Returns the amount of tokens in existence.
6    */
7   function totalSupply() external view returns (uint256);
8 
9   /**
10    * @dev Returns the token decimals.
11    */
12   function decimals() external view returns (uint8);
13 
14   /**
15    * @dev Returns the token symbol.
16    */
17   function symbol() external view returns (string memory);
18 
19   /**
20   * @dev Returns the token name.
21   */
22   function name() external view returns (string memory);
23 
24   /**
25    * @dev Returns the bep token owner.
26    */
27   function getOwner() external view returns (address);
28 
29   /**
30    * @dev Returns the amount of tokens owned by `account`.
31    */
32   function balanceOf(address account) external view returns (uint256);
33 
34   /**
35    * @dev Moves `amount` tokens from the caller's account to `recipient`.
36    *
37    * Returns a boolean value indicating whether the operation succeeded.
38    *
39    * Emits a {Transfer} event.
40    */
41   function transfer(address recipient, uint256 amount) external returns (bool);
42 
43   /**
44    * @dev Returns the remaining number of tokens that `spender` will be
45    * allowed to spend on behalf of `owner` through {transferFrom}. This is
46    * zero by default.
47    *
48    * This value changes when {approve} or {transferFrom} are called.
49    */
50   function allowance(address _owner, address spender) external view returns (uint256);
51 
52   /**
53    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54    *
55    * Returns a boolean value indicating whether the operation succeeded.
56    *
57    * IMPORTANT: Beware that changing an allowance with this method brings the risk
58    * that someone may use both the old and the new allowance by unfortunate
59    * transaction ordering. One possible solution to mitigate this race
60    * condition is to first reduce the spender's allowance to 0 and set the
61    * desired value afterwards:
62    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63    *
64    * Emits an {Approval} event.
65    */
66   function approve(address spender, uint256 amount) external returns (bool);
67 
68   /**
69    * @dev Moves `amount` tokens from `sender` to `recipient` using the
70    * allowance mechanism. `amount` is then deducted from the caller's
71    * allowance.
72    *
73    * Returns a boolean value indicating whether the operation succeeded.
74    *
75    * Emits a {Transfer} event.
76    */
77   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79   /**
80    * @dev Emitted when `value` tokens are moved from one account (`from`) to
81    * another (`to`).
82    *
83    * Note that `value` may be zero.
84    */
85   event Transfer(address indexed from, address indexed to, uint256 value);
86 
87   /**
88    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89    * a call to {approve}. `value` is the new allowance.
90    */
91   event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /*
95  * @dev Provides information about the current execution context, including the
96  * sender of the transaction and its data. While these are generally available
97  * via msg.sender and msg.data, they should not be accessed in such a direct
98  * manner, since when dealing with GSN meta-transactions the account sending and
99  * paying for execution may not be the actual sender (as far as an application
100  * is concerned).
101  *
102  * This contract is only required for intermediate, library-like contracts.
103  */
104 contract Context {
105   // Empty internal constructor, to prevent people from mistakenly deploying
106   // an instance of this contract, which should be used via inheritance.
107   constructor () internal { }
108 
109   function _msgSender() internal view returns (address payable) {
110     return msg.sender;
111   }
112 
113   function _msgData() internal view returns (bytes memory) {
114     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
115     return msg.data;
116   }
117 }
118 
119 /**
120  * @dev Wrappers over Solidity's arithmetic operations with added overflow
121  * checks.
122  *
123  * Arithmetic operations in Solidity wrap on overflow. This can easily result
124  * in bugs, because programmers usually assume that an overflow raises an
125  * error, which is the standard behavior in high level programming languages.
126  * `SafeMath` restores this intuition by reverting the transaction when an
127  * operation overflows.
128  *
129  * Using this library instead of the unchecked operations eliminates an entire
130  * class of bugs, so it's recommended to use it always.
131  */
132 library SafeMath {
133   /**
134    * @dev Returns the addition of two unsigned integers, reverting on
135    * overflow.
136    *
137    * Counterpart to Solidity's `+` operator.
138    *
139    * Requirements:
140    * - Addition cannot overflow.
141    */
142   function add(uint256 a, uint256 b) internal pure returns (uint256) {
143     uint256 c = a + b;
144     require(c >= a, "SafeMath: addition overflow");
145 
146     return c;
147   }
148 
149   /**
150    * @dev Returns the subtraction of two unsigned integers, reverting on
151    * overflow (when the result is negative).
152    *
153    * Counterpart to Solidity's `-` operator.
154    *
155    * Requirements:
156    * - Subtraction cannot overflow.
157    */
158   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159     return sub(a, b, "SafeMath: subtraction overflow");
160   }
161 
162   /**
163    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
164    * overflow (when the result is negative).
165    *
166    * Counterpart to Solidity's `-` operator.
167    *
168    * Requirements:
169    * - Subtraction cannot overflow.
170    */
171   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172     require(b <= a, errorMessage);
173     uint256 c = a - b;
174 
175     return c;
176   }
177 
178   /**
179    * @dev Returns the multiplication of two unsigned integers, reverting on
180    * overflow.
181    *
182    * Counterpart to Solidity's `*` operator.
183    *
184    * Requirements:
185    * - Multiplication cannot overflow.
186    */
187   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
189     // benefit is lost if 'b' is also tested.
190     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
191     if (a == 0) {
192       return 0;
193     }
194 
195     uint256 c = a * b;
196     require(c / a == b, "SafeMath: multiplication overflow");
197 
198     return c;
199   }
200 
201   /**
202    * @dev Returns the integer division of two unsigned integers. Reverts on
203    * division by zero. The result is rounded towards zero.
204    *
205    * Counterpart to Solidity's `/` operator. Note: this function uses a
206    * `revert` opcode (which leaves remaining gas untouched) while Solidity
207    * uses an invalid opcode to revert (consuming all remaining gas).
208    *
209    * Requirements:
210    * - The divisor cannot be zero.
211    */
212   function div(uint256 a, uint256 b) internal pure returns (uint256) {
213     return div(a, b, "SafeMath: division by zero");
214   }
215 
216   /**
217    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218    * division by zero. The result is rounded towards zero.
219    *
220    * Counterpart to Solidity's `/` operator. Note: this function uses a
221    * `revert` opcode (which leaves remaining gas untouched) while Solidity
222    * uses an invalid opcode to revert (consuming all remaining gas).
223    *
224    * Requirements:
225    * - The divisor cannot be zero.
226    */
227   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228     // Solidity only automatically asserts when dividing by 0
229     require(b > 0, errorMessage);
230     uint256 c = a / b;
231     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233     return c;
234   }
235 
236   /**
237    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238    * Reverts when dividing by zero.
239    *
240    * Counterpart to Solidity's `%` operator. This function uses a `revert`
241    * opcode (which leaves remaining gas untouched) while Solidity uses an
242    * invalid opcode to revert (consuming all remaining gas).
243    *
244    * Requirements:
245    * - The divisor cannot be zero.
246    */
247   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248     return mod(a, b, "SafeMath: modulo by zero");
249   }
250 
251   /**
252    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253    * Reverts with custom message when dividing by zero.
254    *
255    * Counterpart to Solidity's `%` operator. This function uses a `revert`
256    * opcode (which leaves remaining gas untouched) while Solidity uses an
257    * invalid opcode to revert (consuming all remaining gas).
258    *
259    * Requirements:
260    * - The divisor cannot be zero.
261    */
262   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263     require(b != 0, errorMessage);
264     return a % b;
265   }
266 }
267 
268 /**
269  * @dev Contract module which provides a basic access control mechanism, where
270  * there is an account (an owner) that can be granted exclusive access to
271  * specific functions.
272  *
273  * By default, the owner account will be the one that deploys the contract. This
274  * can later be changed with {transferOwnership}.
275  *
276  * This module is used through inheritance. It will make available the modifier
277  * `onlyOwner`, which can be applied to your functions to restrict their use to
278  * the owner.
279  */
280 contract Ownable is Context {
281   address private _owner;
282 
283   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
284 
285   /**
286    * @dev Initializes the contract setting the deployer as the initial owner.
287    */
288   constructor () internal {
289     address msgSender = _msgSender();
290     _owner = msgSender;
291     emit OwnershipTransferred(address(0), msgSender);
292   }
293 
294   /**
295    * @dev Returns the address of the current owner.
296    */
297   function owner() public view returns (address) {
298     return _owner;
299   }
300 
301   /**
302    * @dev Throws if called by any account other than the owner.
303    */
304   modifier onlyOwner() {
305     require(_owner == _msgSender(), "Ownable: caller is not the owner");
306     _;
307   }
308 
309   /**
310    * @dev Leaves the contract without owner. It will not be possible to call
311    * `onlyOwner` functions anymore. Can only be called by the current owner.
312    *
313    * NOTE: Renouncing ownership will leave the contract without an owner,
314    * thereby removing any functionality that is only available to the owner.
315    */
316   function renounceOwnership() public onlyOwner {
317     emit OwnershipTransferred(_owner, address(0));
318     _owner = address(0);
319   }
320 
321   /**
322    * @dev Transfers ownership of the contract to a new account (`newOwner`).
323    * Can only be called by the current owner.
324    */
325   function transferOwnership(address newOwner) public onlyOwner {
326     _transferOwnership(newOwner);
327   }
328 
329   /**
330    * @dev Transfers ownership of the contract to a new account (`newOwner`).
331    */
332   function _transferOwnership(address newOwner) internal {
333     require(newOwner != address(0), "Ownable: new owner is the zero address");
334     emit OwnershipTransferred(_owner, newOwner);
335     _owner = newOwner;
336   }
337 }
338 
339 contract ERC20Token is Context, IERC20, Ownable {
340   using SafeMath for uint256;
341 
342   mapping (address => uint256) private _balances;
343 
344   mapping (address => mapping (address => uint256)) private _allowances;
345 
346   uint256 private _totalSupply;
347   uint8 public _decimals;
348   string public _symbol;
349   string public _name;
350   address private burnAddress = address(0);
351 
352   constructor() public {
353     _name = "meta.com";
354     _symbol = "META";
355     _decimals = 18;
356     _totalSupply = 1000000000000000000000000000000;
357     _balances[msg.sender] = _totalSupply;
358 
359     emit Transfer(address(0), msg.sender, _totalSupply);
360   }
361 
362   /**
363    * @dev Returns the bep token owner.
364    */
365   function getOwner() external view returns (address) {
366     return owner();
367   }
368 
369   /**
370    * @dev Returns the token decimals.
371    */
372   function decimals() external view returns (uint8) {
373     return _decimals;
374   }
375 
376   /**
377    * @dev Returns the token symbol.
378    */
379   function symbol() external view returns (string memory) {
380     return _symbol;
381   }
382 
383   /**
384   * @dev Returns the token name.
385   */
386   function name() external view returns (string memory) {
387     return _name;
388   }
389 
390   /**
391    * @dev See {ERC20-totalSupply}.
392    */
393   function totalSupply() external view returns (uint256) {
394     return _totalSupply;
395   }
396 
397   /**
398    * @dev See {ERC20-balanceOf}.
399    */
400   function balanceOf(address account) external view returns (uint256) {
401     return _balances[account];
402   }
403 
404   /**
405    * @dev See {ERC20-transfer}.
406    *
407    * Requirements:
408    *
409    * - `recipient` cannot be the zero address.
410    * - the caller must have a balance of at least `amount`.
411    */
412   function transfer(address recipient, uint256 amount) external returns (bool) {
413     _transfer(_msgSender(), recipient, amount);
414     return true;
415   }
416 
417   /**
418    * @dev See {ERC20-allowance}.
419    */
420   function allowance(address owner, address spender) external view returns (uint256) {
421     return _allowances[owner][spender];
422   }
423 
424   /**
425    * @dev See {ERC20-approve}.
426    *
427    * Requirements:
428    *
429    * - `spender` cannot be the zero address.
430    */
431   function approve(address spender, uint256 amount) external returns (bool) {
432     _approve(_msgSender(), spender, amount);
433     return true;
434   }
435 
436   /**
437    * @dev See {ERC20-transferFrom}.
438    *
439    * Emits an {Approval} event indicating the updated allowance. This is not
440    * required by the EIP. See the note at the beginning of {ERC20};
441    *
442    * Requirements:
443    * - `sender` and `recipient` cannot be the zero address.
444    * - `sender` must have a balance of at least `amount`.
445    * - the caller must have allowance for `sender`'s tokens of at least
446    * `amount`.
447    */
448   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
449     _transfer(sender, recipient, amount);
450     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
451     return true;
452   }
453 
454   /**
455    * @dev Atomically increases the allowance granted to `spender` by the caller.
456    *
457    * This is an alternative to {approve} that can be used as a mitigation for
458    * problems described in {ERC20-approve}.
459    *
460    * Emits an {Approval} event indicating the updated allowance.
461    *
462    * Requirements:
463    *
464    * - `spender` cannot be the zero address.
465    */
466   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
467     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
468     return true;
469   }
470 
471   /**
472    * @dev Atomically decreases the allowance granted to `spender` by the caller.
473    *
474    * This is an alternative to {approve} that can be used as a mitigation for
475    * problems described in {ERC20-approve}.
476    *
477    * Emits an {Approval} event indicating the updated allowance.
478    *
479    * Requirements:
480    *
481    * - `spender` cannot be the zero address.
482    * - `spender` must have allowance for the caller of at least
483    * `subtractedValue`.
484    */
485   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
486     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
487     return true;
488   }
489 
490   /**
491    * @dev Set the burn address.
492    */
493   function setBurnAddress(address addr) public onlyOwner {
494       burnAddress = addr;
495   }
496 
497   /**
498    * @dev Burn `amount` tokens and decreasing the total supply.
499    */
500   function burn(uint256 amount) public returns (bool) {
501     _burn(_msgSender(), amount);
502     return true;
503   }
504 
505   /**
506    * @dev Moves tokens `amount` from `sender` to `recipient`.
507    *
508    * This is internal function is equivalent to {transfer}, and can be used to
509    * e.g. implement automatic token fees, slashing mechanisms, etc.
510    *
511    * Emits a {Transfer} event.
512    *
513    * Requirements:
514    *
515    * - `sender` cannot be the zero address.
516    * - `recipient` cannot be the zero address.
517    * - `sender` must have a balance of at least `amount`.
518    */
519   function _transfer(address sender, address recipient, uint256 amount) internal {
520     require(sender != address(0), "ERC20: transfer from the zero address");
521     require(recipient != address(0), "ERC20: transfer to the zero address");
522     require(recipient != burnAddress, "ERC20: transfer to the burn address");
523 
524     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
525     _balances[recipient] = _balances[recipient].add(amount);
526     emit Transfer(sender, recipient, amount);
527   }
528 
529   /**
530    * @dev Destroys `amount` tokens from `account`, reducing the
531    * total supply.
532    *
533    * Emits a {Transfer} event with `to` set to the zero address.
534    *
535    * Requirements
536    *
537    * - `account` cannot be the zero address.
538    * - `account` must have at least `amount` tokens.
539    */
540   function _burn(address account, uint256 amount) internal {
541     require(account != address(0), "ERC20: burn from the zero address");
542 
543     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
544     _balances[burnAddress] = _balances[burnAddress].add(amount);
545     emit Transfer(account, burnAddress, amount);
546   }
547 
548   /**
549    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
550    *
551    * This is internal function is equivalent to `approve`, and can be used to
552    * e.g. set automatic allowances for certain subsystems, etc.
553    *
554    * Emits an {Approval} event.
555    *
556    * Requirements:
557    *
558    * - `owner` cannot be the zero address.
559    * - `spender` cannot be the zero address.
560    */
561   function _approve(address owner, address spender, uint256 amount) internal {
562     require(owner != address(0), "ERC20: approve from the zero address");
563     require(spender != address(0), "ERC20: approve to the zero address");
564 
565     _allowances[owner][spender] = amount;
566     emit Approval(owner, spender, amount);
567   }
568 
569   /**
570    * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
571    * from the caller's allowance.
572    *
573    * See {_burn} and {_approve}.
574    */
575   function _burnFrom(address account, uint256 amount) internal {
576     _burn(account, amount);
577     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
578   }
579 }