1 /**
2  *Submitted for verification at BscScan.com on 2021-07-09
3 */
4 
5 /**
6  *Submitted for verification at hecoinfo.com on 2021-05-24
7 */
8 
9 pragma solidity 0.5.16;
10 
11 interface IDOJO {
12   /**
13    * @dev Returns the amount of tokens in existence.
14    */
15   function totalSupply() external view returns (uint256);
16 
17   /**
18    * @dev Returns the token decimals.
19    */
20   function decimals() external view returns (uint8);
21 
22   /**
23    * @dev Returns the token symbol.
24    */
25   function symbol() external view returns (string memory);
26 
27   /**
28   * @dev Returns the token name.
29   */
30   function name() external view returns (string memory);
31 
32   /**
33    * @dev Returns the bep token owner.
34    */
35   function getOwner() external view returns (address);
36 
37   /**
38    * @dev Returns the amount of tokens owned by `account`.
39    */
40   function balanceOf(address account) external view returns (uint256);
41 
42   /**
43    * @dev Moves `amount` tokens from the caller's account to `recipient`.
44    *
45    * Returns a boolean value indicating whether the operation succeeded.
46    *
47    * Emits a {Transfer} event.
48    */
49   function transfer(address recipient, uint256 amount) external returns (bool);
50 
51   /**
52    * @dev Returns the remaining number of tokens that `spender` will be
53    * allowed to spend on behalf of `owner` through {transferFrom}. This is
54    * zero by default.
55    *
56    * This value changes when {approve} or {transferFrom} are called.
57    */
58   function allowance(address _owner, address spender) external view returns (uint256);
59 
60   /**
61    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62    *
63    * Returns a boolean value indicating whether the operation succeeded.
64    *
65    * IMPORTANT: Beware that changing an allowance with this method brings the risk
66    * that someone may use both the old and the new allowance by unfortunate
67    * transaction ordering. One possible solution to mitigate this race
68    * condition is to first reduce the spender's allowance to 0 and set the
69    * desired value afterwards:
70    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71    *
72    * Emits an {Approval} event.
73    */
74   function approve(address spender, uint256 amount) external returns (bool);
75 
76   /**
77    * @dev Moves `amount` tokens from `sender` to `recipient` using the
78    * allowance mechanism. `amount` is then deducted from the caller's
79    * allowance.
80    *
81    * Returns a boolean value indicating whether the operation succeeded.
82    *
83    * Emits a {Transfer} event.
84    */
85   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86 
87   /**
88    * @dev Emitted when `value` tokens are moved from one account (`from`) to
89    * another (`to`).
90    *
91    * Note that `value` may be zero.
92    */
93   event Transfer(address indexed from, address indexed to, uint256 value);
94 
95   /**
96    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97    * a call to {approve}. `value` is the new allowance.
98    */
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 /*
103  * @dev Provides information about the current execution context, including the
104  * sender of the transaction and its data. While these are generally available
105  * via msg.sender and msg.data, they should not be accessed in such a direct
106  * manner, since when dealing with GSN meta-transactions the account sending and
107  * paying for execution may not be the actual sender (as far as an application
108  * is concerned).
109  *
110  * This contract is only required for intermediate, library-like contracts.
111  */
112 contract Context {
113   // Empty internal constructor, to prevent people from mistakenly deploying
114   // an instance of this contract, which should be used via inheritance.
115   constructor () internal { }
116 
117   function _msgSender() internal view returns (address payable) {
118     return msg.sender;
119   }
120 
121   function _msgData() internal view returns (bytes memory) {
122     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
123     return msg.data;
124   }
125 }
126 
127 /**
128  * @dev Wrappers over Solidity's arithmetic operations with added overflow
129  * checks.
130  *
131  * Arithmetic operations in Solidity wrap on overflow. This can easily result
132  * in bugs, because programmers usually assume that an overflow raises an
133  * error, which is the standard behavior in high level programming languages.
134  * `SafeMath` restores this intuition by reverting the transaction when an
135  * operation overflows.
136  *
137  * Using this library instead of the unchecked operations eliminates an entire
138  * class of bugs, so it's recommended to use it always.
139  */
140 library SafeMath {
141   /**
142    * @dev Returns the addition of two unsigned integers, reverting on
143    * overflow.
144    *
145    * Counterpart to Solidity's `+` operator.
146    *
147    * Requirements:
148    * - Addition cannot overflow.
149    */
150   function add(uint256 a, uint256 b) internal pure returns (uint256) {
151     uint256 c = a + b;
152     require(c >= a, "SafeMath: addition overflow");
153 
154     return c;
155   }
156 
157   /**
158    * @dev Returns the subtraction of two unsigned integers, reverting on
159    * overflow (when the result is negative).
160    *
161    * Counterpart to Solidity's `-` operator.
162    *
163    * Requirements:
164    * - Subtraction cannot overflow.
165    */
166   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167     return sub(a, b, "SafeMath: subtraction overflow");
168   }
169 
170   /**
171    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
172    * overflow (when the result is negative).
173    *
174    * Counterpart to Solidity's `-` operator.
175    *
176    * Requirements:
177    * - Subtraction cannot overflow.
178    */
179   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
180     require(b <= a, errorMessage);
181     uint256 c = a - b;
182 
183     return c;
184   }
185 
186   /**
187    * @dev Returns the multiplication of two unsigned integers, reverting on
188    * overflow.
189    *
190    * Counterpart to Solidity's `*` operator.
191    *
192    * Requirements:
193    * - Multiplication cannot overflow.
194    */
195   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
196     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
197     // benefit is lost if 'b' is also tested.
198     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
199     if (a == 0) {
200       return 0;
201     }
202 
203     uint256 c = a * b;
204     require(c / a == b, "SafeMath: multiplication overflow");
205 
206     return c;
207   }
208 
209   /**
210    * @dev Returns the integer division of two unsigned integers. Reverts on
211    * division by zero. The result is rounded towards zero.
212    *
213    * Counterpart to Solidity's `/` operator. Note: this function uses a
214    * `revert` opcode (which leaves remaining gas untouched) while Solidity
215    * uses an invalid opcode to revert (consuming all remaining gas).
216    *
217    * Requirements:
218    * - The divisor cannot be zero.
219    */
220   function div(uint256 a, uint256 b) internal pure returns (uint256) {
221     return div(a, b, "SafeMath: division by zero");
222   }
223 
224   /**
225    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
226    * division by zero. The result is rounded towards zero.
227    *
228    * Counterpart to Solidity's `/` operator. Note: this function uses a
229    * `revert` opcode (which leaves remaining gas untouched) while Solidity
230    * uses an invalid opcode to revert (consuming all remaining gas).
231    *
232    * Requirements:
233    * - The divisor cannot be zero.
234    */
235   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236     // Solidity only automatically asserts when dividing by 0
237     require(b > 0, errorMessage);
238     uint256 c = a / b;
239     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
240 
241     return c;
242   }
243 
244   /**
245    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246    * Reverts when dividing by zero.
247    *
248    * Counterpart to Solidity's `%` operator. This function uses a `revert`
249    * opcode (which leaves remaining gas untouched) while Solidity uses an
250    * invalid opcode to revert (consuming all remaining gas).
251    *
252    * Requirements:
253    * - The divisor cannot be zero.
254    */
255   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256     return mod(a, b, "SafeMath: modulo by zero");
257   }
258 
259   /**
260    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261    * Reverts with custom message when dividing by zero.
262    *
263    * Counterpart to Solidity's `%` operator. This function uses a `revert`
264    * opcode (which leaves remaining gas untouched) while Solidity uses an
265    * invalid opcode to revert (consuming all remaining gas).
266    *
267    * Requirements:
268    * - The divisor cannot be zero.
269    */
270   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
271     require(b != 0, errorMessage);
272     return a % b;
273   }
274 }
275 
276 /**
277  * @dev Contract module which provides a basic access control mechanism, where
278  * there is an account (an owner) that can be granted exclusive access to
279  * specific functions.
280  *
281  * By default, the owner account will be the one that deploys the contract. This
282  * can later be changed with {transferOwnership}.
283  *
284  * This module is used through inheritance. It will make available the modifier
285  * `onlyOwner`, which can be applied to your functions to restrict their use to
286  * the owner.
287  */
288 contract Ownable is Context {
289   address private _owner;
290 
291   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
292 
293   /**
294    * @dev Initializes the contract setting the deployer as the initial owner.
295    */
296   constructor () internal {
297     address msgSender = _msgSender();
298     _owner = msgSender;
299     emit OwnershipTransferred(address(0), msgSender);
300   }
301 
302   /**
303    * @dev Returns the address of the current owner.
304    */
305   function owner() public view returns (address) {
306     return _owner;
307   }
308 
309   /**
310    * @dev Throws if called by any account other than the owner.
311    */
312   modifier onlyOwner() {
313     require(_owner == _msgSender(), "Ownable: caller is not the owner");
314     _;
315   }
316 
317   /**
318    * @dev Leaves the contract without owner. It will not be possible to call
319    * `onlyOwner` functions anymore. Can only be called by the current owner.
320    *
321    * NOTE: Renouncing ownership will leave the contract without an owner,
322    * thereby removing any functionality that is only available to the owner.
323    */
324   function renounceOwnership() public onlyOwner {
325     emit OwnershipTransferred(_owner, address(0));
326     _owner = address(0);
327   }
328 
329   /**
330    * @dev Transfers ownership of the contract to a new account (`newOwner`).
331    * Can only be called by the current owner.
332    */
333   function transferOwnership(address newOwner) public onlyOwner {
334     _transferOwnership(newOwner);
335   }
336 
337   /**
338    * @dev Transfers ownership of the contract to a new account (`newOwner`).
339    */
340   function _transferOwnership(address newOwner) internal {
341     require(newOwner != address(0), "Ownable: new owner is the zero address");
342     emit OwnershipTransferred(_owner, newOwner);
343     _owner = newOwner;
344   }
345 }
346 
347 contract DOJOToken is Context, IDOJO, Ownable {
348   using SafeMath for uint256;
349 
350   mapping (address => uint256) private _balances;
351 
352   mapping (address => mapping (address => uint256)) private _allowances;
353 
354   uint256 private _totalSupply;
355   uint8 private _decimals;
356   string private _symbol;
357   string private _name;
358 
359   constructor() public {
360     _name = "DOJO";
361     _symbol = "DOJO";
362     _decimals = 18;
363     _totalSupply = 19716280000000000000000000000000;
364     _balances[msg.sender] = _totalSupply;
365 
366     emit Transfer(address(0), msg.sender, _totalSupply);
367   }
368 
369   /**
370    * @dev Returns the bep token owner.
371    */
372   function getOwner() external view returns (address) {
373     return owner();
374   }
375 
376   /**
377    * @dev Returns the token decimals.
378    */
379   function decimals() external view returns (uint8) {
380     return _decimals;
381   }
382 
383   /**
384    * @dev Returns the token symbol.
385    */
386   function symbol() external view returns (string memory) {
387     return _symbol;
388   }
389 
390   /**
391   * @dev Returns the token name.
392   */
393   function name() external view returns (string memory) {
394     return _name;
395   }
396 
397   /**
398    * @dev See {DOJO-totalSupply}.
399    */
400   function totalSupply() external view returns (uint256) {
401     return _totalSupply;
402   }
403 
404   /**
405    * @dev See {DOJO-balanceOf}.
406    */
407   function balanceOf(address account) external view returns (uint256) {
408     return _balances[account];
409   }
410 
411   /**
412    * @dev See {DOJO-transfer}.
413    *
414    * Requirements:
415    *
416    * - `recipient` cannot be the zero address.
417    * - the caller must have a balance of at least `amount`.
418    */
419   function transfer(address recipient, uint256 amount) external returns (bool) {
420     _transfer(_msgSender(), recipient, amount);
421     return true;
422   }
423 
424   /**
425    * @dev See {DOJO-allowance}.
426    */
427   function allowance(address owner, address spender) external view returns (uint256) {
428     return _allowances[owner][spender];
429   }
430 
431   /**
432    * @dev See {DOJO-approve}.
433    *
434    * Requirements:
435    *
436    * - `spender` cannot be the zero address.
437    */
438   function approve(address spender, uint256 amount) external returns (bool) {
439     _approve(_msgSender(), spender, amount);
440     return true;
441   }
442 
443   /**
444    * @dev See {DOJO-transferFrom}.
445    *
446    * Emits an {Approval} event indicating the updated allowance. This is not
447    * required by the EIP. See the note at the beginning of {DOJO};
448    *
449    * Requirements:
450    * - `sender` and `recipient` cannot be the zero address.
451    * - `sender` must have a balance of at least `amount`.
452    * - the caller must have allowance for `sender`'s tokens of at least
453    * `amount`.
454    */
455   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
456     _transfer(sender, recipient, amount);
457     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "DOJO: transfer amount exceeds allowance"));
458     return true;
459   }
460 
461   /**
462    * @dev Atomically increases the allowance granted to `spender` by the caller.
463    *
464    * This is an alternative to {approve} that can be used as a mitigation for
465    * problems described in {DOJO-approve}.
466    *
467    * Emits an {Approval} event indicating the updated allowance.
468    *
469    * Requirements:
470    *
471    * - `spender` cannot be the zero address.
472    */
473   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
474     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
475     return true;
476   }
477 
478   /**
479    * @dev Atomically decreases the allowance granted to `spender` by the caller.
480    *
481    * This is an alternative to {approve} that can be used as a mitigation for
482    * problems described in {DOJO-approve}.
483    *
484    * Emits an {Approval} event indicating the updated allowance.
485    *
486    * Requirements:
487    *
488    * - `spender` cannot be the zero address.
489    * - `spender` must have allowance for the caller of at least
490    * `subtractedValue`.
491    */
492   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
493     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "DOJO: decreased allowance below zero"));
494     return true;
495   }
496 
497   /**
498    * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
499    * the total supply.
500    *
501    * Requirements
502    *
503    * - `msg.sender` must be the token owner
504    */
505   function mint(uint256 amount) public onlyOwner returns (bool) {
506     _mint(_msgSender(), amount);
507     return true;
508   }
509 
510   /**
511    * @dev Moves tokens `amount` from `sender` to `recipient`.
512    *
513    * This is internal function is equivalent to {transfer}, and can be used to
514    * e.g. implement automatic token fees, slashing mechanisms, etc.
515    *
516    * Emits a {Transfer} event.
517    *
518    * Requirements:
519    *
520    * - `sender` cannot be the zero address.
521    * - `recipient` cannot be the zero address.
522    * - `sender` must have a balance of at least `amount`.
523    */
524   function _transfer(address sender, address recipient, uint256 amount) internal {
525     require(sender != address(0), "DOJO: transfer from the zero address");
526     require(recipient != address(0), "DOJO: transfer to the zero address");
527 
528     _balances[sender] = _balances[sender].sub(amount, "DOJO: transfer amount exceeds balance");
529     _balances[recipient] = _balances[recipient].add(amount);
530     emit Transfer(sender, recipient, amount);
531   }
532 
533   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
534    * the total supply.
535    *
536    * Emits a {Transfer} event with `from` set to the zero address.
537    *
538    * Requirements
539    *
540    * - `to` cannot be the zero address.
541    */
542   function _mint(address account, uint256 amount) internal {
543     require(account != address(0), "DOJO: mint to the zero address");
544 
545     _totalSupply = _totalSupply.add(amount);
546     _balances[account] = _balances[account].add(amount);
547     emit Transfer(address(0), account, amount);
548   }
549 
550   /**
551    * @dev Destroys `amount` tokens from `account`, reducing the
552    * total supply.
553    *
554    * Emits a {Transfer} event with `to` set to the zero address.
555    *
556    * Requirements
557    *
558    * - `account` cannot be the zero address.
559    * - `account` must have at least `amount` tokens.
560    */
561   function _burn(address account, uint256 amount) internal {
562     require(account != address(0), "DOJO: burn from the zero address");
563 
564     _balances[account] = _balances[account].sub(amount, "DOJO: burn amount exceeds balance");
565     _totalSupply = _totalSupply.sub(amount);
566     emit Transfer(account, address(0), amount);
567   }
568 
569   /**
570    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
571    *
572    * This is internal function is equivalent to `approve`, and can be used to
573    * e.g. set automatic allowances for certain subsystems, etc.
574    *
575    * Emits an {Approval} event.
576    *
577    * Requirements:
578    *
579    * - `owner` cannot be the zero address.
580    * - `spender` cannot be the zero address.
581    */
582   function _approve(address owner, address spender, uint256 amount) internal {
583     require(owner != address(0), "DOJO: approve from the zero address");
584     require(spender != address(0), "DOJO: approve to the zero address");
585 
586     _allowances[owner][spender] = amount;
587     emit Approval(owner, spender, amount);
588   }
589 
590   /**
591    * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
592    * from the caller's allowance.
593    *
594    * See {_burn} and {_approve}.
595    */
596   function _burnFrom(address account, uint256 amount) internal {
597     _burn(account, amount);
598     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "DOJO: burn amount exceeds allowance"));
599   }
600 }