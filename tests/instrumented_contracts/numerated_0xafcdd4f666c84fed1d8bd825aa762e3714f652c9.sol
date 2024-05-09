1 // SPDX-License-Identifier: GPL-3.0-only
2 pragma solidity 0.6.5;
3 
4 interface IERC20 {
5   /**
6    * @dev Returns the amount of tokens in existence.
7    */
8   function totalSupply() external view returns (uint256);
9 
10   /**
11    * @dev Returns the token decimals.
12    */
13   function decimals() external view returns (uint8);
14 
15   /**
16    * @dev Returns the token symbol.
17    */
18   function symbol() external view returns (string memory);
19 
20   /**
21   * @dev Returns the token name.
22   */
23   function name() external view returns (string memory);
24 
25   /**
26    * @dev Returns the bep token owner.
27    */
28   function getOwner() external view returns (address);
29 
30   /**
31    * @dev Returns the amount of tokens owned by `account`.
32    */
33   function balanceOf(address account) external view returns (uint256);
34 
35   /**
36    * @dev Moves `amount` tokens from the caller's account to `recipient`.
37    *
38    * Returns a boolean value indicating whether the operation succeeded.
39    *
40    * Emits a {Transfer} event.
41    */
42   function transfer(address recipient, uint256 amount) external returns (bool);
43 
44   /**
45    * @dev Returns the remaining number of tokens that `spender` will be
46    * allowed to spend on behalf of `owner` through {transferFrom}. This is
47    * zero by default.
48    *
49    * This value changes when {approve} or {transferFrom} are called.
50    */
51   function allowance(address _owner, address spender) external view returns (uint256);
52 
53   /**
54    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55    *
56    * Returns a boolean value indicating whether the operation succeeded.
57    *
58    * IMPORTANT: Beware that changing an allowance with this method brings the risk
59    * that someone may use both the old and the new allowance by unfortunate
60    * transaction ordering. One possible solution to mitigate this race
61    * condition is to first reduce the spender's allowance to 0 and set the
62    * desired value afterwards:
63    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64    *
65    * Emits an {Approval} event.
66    */
67   function approve(address spender, uint256 amount) external returns (bool);
68 
69   /**
70    * @dev Moves `amount` tokens from `sender` to `recipient` using the
71    * allowance mechanism. `amount` is then deducted from the caller's
72    * allowance.
73    *
74    * Returns a boolean value indicating whether the operation succeeded.
75    *
76    * Emits a {Transfer} event.
77    */
78   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
79 
80   /**
81    * @dev Emitted when `value` tokens are moved from one account (`from`) to
82    * another (`to`).
83    *
84    * Note that `value` may be zero.
85    */
86   event Transfer(address indexed from, address indexed to, uint256 value);
87 
88   /**
89    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90    * a call to {approve}. `value` is the new allowance.
91    */
92   event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 /*
96  * @dev Provides information about the current execution context, including the
97  * sender of the transaction and its data. While these are generally available
98  * via msg.sender and msg.data, they should not be accessed in such a direct
99  * manner, since when dealing with GSN meta-transactions the account sending and
100  * paying for execution may not be the actual sender (as far as an application
101  * is concerned).
102  *
103  * This contract is only required for intermediate, library-like contracts.
104  */
105 contract Context {
106   // Empty internal constructor, to prevent people from mistakenly deploying
107   // an instance of this contract, which should be used via inheritance.
108   constructor () internal { }
109 
110   function _msgSender() internal view returns (address payable) {
111     return msg.sender;
112   }
113 
114   function _msgData() internal view returns (bytes memory) {
115     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
116     return msg.data;
117   }
118 }
119 
120 /**
121  * @dev Wrappers over Solidity's arithmetic operations with added overflow
122  * checks.
123  *
124  * Arithmetic operations in Solidity wrap on overflow. This can easily result
125  * in bugs, because programmers usually assume that an overflow raises an
126  * error, which is the standard behavior in high level programming languages.
127  * `SafeMath` restores this intuition by reverting the transaction when an
128  * operation overflows.
129  *
130  * Using this library instead of the unchecked operations eliminates an entire
131  * class of bugs, so it's recommended to use it always.
132  */
133 library SafeMath {
134   /**
135    * @dev Returns the addition of two unsigned integers, reverting on
136    * overflow.
137    *
138    * Counterpart to Solidity's `+` operator.
139    *
140    * Requirements:
141    * - Addition cannot overflow.
142    */
143   function add(uint256 a, uint256 b) internal pure returns (uint256) {
144     uint256 c = a + b;
145     require(c >= a, "SafeMath: addition overflow");
146 
147     return c;
148   }
149 
150   /**
151    * @dev Returns the subtraction of two unsigned integers, reverting on
152    * overflow (when the result is negative).
153    *
154    * Counterpart to Solidity's `-` operator.
155    *
156    * Requirements:
157    * - Subtraction cannot overflow.
158    */
159   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160     return sub(a, b, "SafeMath: subtraction overflow");
161   }
162 
163   /**
164    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165    * overflow (when the result is negative).
166    *
167    * Counterpart to Solidity's `-` operator.
168    *
169    * Requirements:
170    * - Subtraction cannot overflow.
171    */
172   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173     require(b <= a, errorMessage);
174     uint256 c = a - b;
175 
176     return c;
177   }
178 
179   /**
180    * @dev Returns the multiplication of two unsigned integers, reverting on
181    * overflow.
182    *
183    * Counterpart to Solidity's `*` operator.
184    *
185    * Requirements:
186    * - Multiplication cannot overflow.
187    */
188   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190     // benefit is lost if 'b' is also tested.
191     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192     if (a == 0) {
193       return 0;
194     }
195 
196     uint256 c = a * b;
197     require(c / a == b, "SafeMath: multiplication overflow");
198 
199     return c;
200   }
201 
202   /**
203    * @dev Returns the integer division of two unsigned integers. Reverts on
204    * division by zero. The result is rounded towards zero.
205    *
206    * Counterpart to Solidity's `/` operator. Note: this function uses a
207    * `revert` opcode (which leaves remaining gas untouched) while Solidity
208    * uses an invalid opcode to revert (consuming all remaining gas).
209    *
210    * Requirements:
211    * - The divisor cannot be zero.
212    */
213   function div(uint256 a, uint256 b) internal pure returns (uint256) {
214     return div(a, b, "SafeMath: division by zero");
215   }
216 
217   /**
218    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
219    * division by zero. The result is rounded towards zero.
220    *
221    * Counterpart to Solidity's `/` operator. Note: this function uses a
222    * `revert` opcode (which leaves remaining gas untouched) while Solidity
223    * uses an invalid opcode to revert (consuming all remaining gas).
224    *
225    * Requirements:
226    * - The divisor cannot be zero.
227    */
228   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229     // Solidity only automatically asserts when dividing by 0
230     require(b > 0, errorMessage);
231     uint256 c = a / b;
232     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
233 
234     return c;
235   }
236 
237   /**
238    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239    * Reverts when dividing by zero.
240    *
241    * Counterpart to Solidity's `%` operator. This function uses a `revert`
242    * opcode (which leaves remaining gas untouched) while Solidity uses an
243    * invalid opcode to revert (consuming all remaining gas).
244    *
245    * Requirements:
246    * - The divisor cannot be zero.
247    */
248   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249     return mod(a, b, "SafeMath: modulo by zero");
250   }
251 
252   /**
253    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254    * Reverts with custom message when dividing by zero.
255    *
256    * Counterpart to Solidity's `%` operator. This function uses a `revert`
257    * opcode (which leaves remaining gas untouched) while Solidity uses an
258    * invalid opcode to revert (consuming all remaining gas).
259    *
260    * Requirements:
261    * - The divisor cannot be zero.
262    */
263   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264     require(b != 0, errorMessage);
265     return a % b;
266   }
267 }
268 
269 /**
270  * @dev Contract module which provides a basic access control mechanism, where
271  * there is an account (an owner) that can be granted exclusive access to
272  * specific functions.
273  *
274  * By default, the owner account will be the one that deploys the contract. This
275  * can later be changed with {transferOwnership}.
276  *
277  * This module is used through inheritance. It will make available the modifier
278  * `onlyOwner`, which can be applied to your functions to restrict their use to
279  * the owner.
280  */
281 contract Ownable is Context {
282   address private _owner;
283 
284   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
285 
286   /**
287    * @dev Initializes the contract setting the deployer as the initial owner.
288    */
289   constructor () internal {
290     address msgSender = _msgSender();
291     _owner = msgSender;
292     emit OwnershipTransferred(address(0), msgSender);
293   }
294 
295   /**
296    * @dev Returns the address of the current owner.
297    */
298   function owner() public view returns (address) {
299     return _owner;
300   }
301 
302   /**
303    * @dev Throws if called by any account other than the owner.
304    */
305   modifier onlyOwner() {
306     require(_owner == _msgSender(), "Ownable: caller is not the owner");
307     _;
308   }
309 
310   /**
311    * @dev Leaves the contract without owner. It will not be possible to call
312    * `onlyOwner` functions anymore. Can only be called by the current owner.
313    *
314    * NOTE: Renouncing ownership will leave the contract without an owner,
315    * thereby removing any functionality that is only available to the owner.
316    */
317   function renounceOwnership() public onlyOwner {
318     emit OwnershipTransferred(_owner, address(0));
319     _owner = address(0);
320   }
321 
322   /**
323    * @dev Transfers ownership of the contract to a new account (`newOwner`).
324    * Can only be called by the current owner.
325    */
326   function transferOwnership(address newOwner) public onlyOwner {
327     _transferOwnership(newOwner);
328   }
329 
330   /**
331    * @dev Transfers ownership of the contract to a new account (`newOwner`).
332    */
333   function _transferOwnership(address newOwner) internal {
334     require(newOwner != address(0), "Ownable: new owner is the zero address");
335     emit OwnershipTransferred(_owner, newOwner);
336     _owner = newOwner;
337   }
338 }
339 
340 contract ERC20Vinu is Context, IERC20, Ownable {
341   using SafeMath for uint256;
342 
343   mapping (address => uint256) private _balances;
344 
345   mapping (address => mapping (address => uint256)) private _allowances;
346 
347   uint256 private _totalSupply;
348   uint8 public immutable _decimals;
349   string public constant _symbol = "VINU";
350   string public constant _name = "Vita Inu";
351 
352   constructor() public {
353     _decimals = 18;
354     _totalSupply = 961232095273833 * 10**18;
355     _balances[msg.sender] = _totalSupply;
356 
357     emit Transfer(address(0), msg.sender, _totalSupply);
358   }
359 
360   /**
361    * @dev Returns the bep token owner.
362    */
363   function getOwner() external override view returns (address) {
364     return owner();
365   }
366 
367   /**
368    * @dev Returns the token decimals.
369    */
370   function decimals() external override view returns (uint8) {
371     return _decimals;
372   }
373 
374   /**
375    * @dev Returns the token symbol.
376    */
377   function symbol() external override view returns (string memory) {
378     return _symbol;
379   }
380 
381   /**
382   * @dev Returns the token name.
383   */
384   function name() external override view returns (string memory) {
385     return _name;
386   }
387 
388   /**
389    * @dev See {ERC20-totalSupply}.
390    */
391   function totalSupply() external override view returns (uint256) {
392     return _totalSupply;
393   }
394 
395   /**
396    * @dev See {ERC20-balanceOf}.
397    */
398   function balanceOf(address account) external override view returns (uint256) {
399     return _balances[account];
400   }
401 
402   /**
403    * @dev See {ERC20-transfer}.
404    *
405    * Requirements:
406    *
407    * - `recipient` cannot be the zero address.
408    * - the caller must have a balance of at least `amount`.
409    */
410   function transfer(address recipient, uint256 amount) external override returns (bool) {
411     _transfer(_msgSender(), recipient, amount);
412     return true;
413   }
414 
415   /**
416    * @dev See {ERC20-allowance}.
417    */
418   function allowance(address owner, address spender) external override view returns (uint256) {
419     return _allowances[owner][spender];
420   }
421 
422   /**
423    * @dev See {ERC20-approve}.
424    *
425    * Requirements:
426    *
427    * - `spender` cannot be the zero address.
428    */
429   function approve(address spender, uint256 amount) external override returns (bool) {
430     _approve(_msgSender(), spender, amount);
431     return true;
432   }
433 
434   /**
435    * @dev See {ERC20-transferFrom}.
436    *
437    * Emits an {Approval} event indicating the updated allowance. This is not
438    * required by the EIP. See the note at the beginning of {ERC20};
439    *
440    * Requirements:
441    * - `sender` and `recipient` cannot be the zero address.
442    * - `sender` must have a balance of at least `amount`.
443    * - the caller must have allowance for `sender`'s tokens of at least
444    * `amount`.
445    */
446   function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
447     _transfer(sender, recipient, amount);
448     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
449     return true;
450   }
451 
452   /**
453    * @dev Atomically increases the allowance granted to `spender` by the caller.
454    *
455    * This is an alternative to {approve} that can be used as a mitigation for
456    * problems described in {ERC20-approve}.
457    *
458    * Emits an {Approval} event indicating the updated allowance.
459    *
460    * Requirements:
461    *
462    * - `spender` cannot be the zero address.
463    */
464   function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
465     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
466     return true;
467   }
468 
469   /**
470    * @dev Atomically decreases the allowance granted to `spender` by the caller.
471    *
472    * This is an alternative to {approve} that can be used as a mitigation for
473    * problems described in {ERC20-approve}.
474    *
475    * Emits an {Approval} event indicating the updated allowance.
476    *
477    * Requirements:
478    *
479    * - `spender` cannot be the zero address.
480    * - `spender` must have allowance for the caller of at least
481    * `subtractedValue`.
482    */
483   function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
484     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
485     return true;
486   }
487 
488   /**
489    * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
490    * the total supply.
491    *
492    * Requirements
493    *
494    * - `msg.sender` must be the token owner
495    */
496   function mint(uint256 amount) external onlyOwner returns (bool) {
497     _mint(_msgSender(), amount);
498     return true;
499   }
500 
501   /**
502    * @dev Burn `amount` tokens and decreasing the total supply.
503    */
504   function burn(uint256 amount) external returns (bool) {
505     _burn(_msgSender(), amount);
506     return true;
507   }
508 
509   /**
510    * @dev Moves tokens `amount` from `sender` to `recipient`.
511    *
512    * This is internal function is equivalent to {transfer}, and can be used to
513    * e.g. implement automatic token fees, slashing mechanisms, etc.
514    *
515    * Emits a {Transfer} event.
516    *
517    * Requirements:
518    *
519    * - `sender` cannot be the zero address.
520    * - `recipient` cannot be the zero address.
521    * - `sender` must have a balance of at least `amount`.
522    */
523   function _transfer(address sender, address recipient, uint256 amount) internal {
524     require(sender != address(0), "ERC20: transfer from the zero address");
525     require(recipient != address(0), "ERC20: transfer to the zero address");
526 
527     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
528     _balances[recipient] = _balances[recipient].add(amount);
529     emit Transfer(sender, recipient, amount);
530   }
531 
532   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
533    * the total supply.
534    *
535    * Emits a {Transfer} event with `from` set to the zero address.
536    *
537    * Requirements
538    *
539    * - `to` cannot be the zero address.
540    */
541   function _mint(address account, uint256 amount) internal {
542     require(account != address(0), "ERC20: mint to the zero address");
543 
544     _totalSupply = _totalSupply.add(amount);
545     _balances[account] = _balances[account].add(amount);
546     emit Transfer(address(0), account, amount);
547   }
548 
549   /**
550    * @dev Destroys `amount` tokens from `account`, reducing the
551    * total supply.
552    *
553    * Emits a {Transfer} event with `to` set to the zero address.
554    *
555    * Requirements
556    *
557    * - `account` cannot be the zero address.
558    * - `account` must have at least `amount` tokens.
559    */
560   function _burn(address account, uint256 amount) internal {
561     require(account != address(0), "ERC20: burn from the zero address");
562 
563     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
564     _totalSupply = _totalSupply.sub(amount);
565     emit Transfer(account, address(0), amount);
566   }
567 
568   /**
569    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
570    *
571    * This is internal function is equivalent to `approve`, and can be used to
572    * e.g. set automatic allowances for certain subsystems, etc.
573    *
574    * Emits an {Approval} event.
575    *
576    * Requirements:
577    *
578    * - `owner` cannot be the zero address.
579    * - `spender` cannot be the zero address.
580    */
581   function _approve(address owner, address spender, uint256 amount) internal {
582     require(owner != address(0), "ERC20: approve from the zero address");
583     require(spender != address(0), "ERC20: approve to the zero address");
584 
585     _allowances[owner][spender] = amount;
586     emit Approval(owner, spender, amount);
587   }
588 }