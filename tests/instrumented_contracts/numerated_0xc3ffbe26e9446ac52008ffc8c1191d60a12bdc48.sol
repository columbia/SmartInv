1 /**
2  *Submitted for verification at Etherscan.io on 2021-11-29
3 */
4 // SPDX-License-Identifier: UNLICENSED
5 pragma solidity 0.6.8;
6 
7 interface iERC20 {
8   /**
9    * @dev Returns the amount of tokens in existence.
10    */
11   function totalSupply() external view returns (uint256);
12 
13   /**
14    * @dev Returns the token decimals.
15    */
16   function decimals() external view returns (uint8);
17 
18   /**
19    * @dev Returns the token symbol.
20    */
21   function symbol() external view returns (string memory);
22 
23   /**
24   * @dev Returns the token name.
25   */
26   function name() external view returns (string memory);
27 
28   /**
29    * @dev Returns the bep token owner.
30    */
31   function getOwner() external view returns (address);
32 
33   /**
34    * @dev Returns the amount of tokens owned by `account`.
35    */
36   function balanceOf(address account) external view returns (uint256);
37 
38   function transfer(address recipient, uint256 amount) external returns (bool);
39 
40  
41   function allowance(address _owner, address spender) external view returns (uint256);
42 
43   
44   function approve(address spender, uint256 amount) external returns (bool);
45 
46   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
47 
48   
49   event Transfer(address indexed from, address indexed to, uint256 value);
50 
51   event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 /*
55  * @dev Provides information about the current execution context, including the
56  * sender of the transaction and its data. While these are generally available
57  * via msg.sender and msg.data, they should not be accessed in such a direct
58  * manner, since when dealing with GSN meta-transactions the account sending and
59  * paying for execution may not be the actual sender (as far as an application
60  * is concerned).
61  *
62  * This contract is only required for intermediate, library-like contracts.
63  */
64 contract Context {
65   // Empty internal constructor, to prevent people from mistakenly deploying
66   // an instance of this contract, which should be used via inheritance.
67   constructor () internal { }
68 
69   function _msgSender() internal view returns (address payable) {
70     return msg.sender;
71   }
72 
73   function _msgData() internal view returns (bytes memory) {
74     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
75     return msg.data;
76   }
77 }
78 
79 /**
80  * @dev Wrappers over Solidity's arithmetic operations with added overflow
81  * checks.
82  *
83  * Arithmetic operations in Solidity wrap on overflow. This can easily result
84  * in bugs, because programmers usually assume that an overflow raises an
85  * error, which is the standard behavior in high level programming languages.
86  * `SafeMath` restores this intuition by reverting the transaction when an
87  * operation overflows.
88  *
89  * Using this library instead of the unchecked operations eliminates an entire
90  * class of bugs, so it's recommended to use it always.
91  */
92 library SafeMath {
93   /**
94    * @dev Returns the addition of two unsigned integers, reverting on
95    * overflow.
96    *
97    * Counterpart to Solidity's `+` operator.
98    *
99    * Requirements:
100    * - Addition cannot overflow.
101    */
102   function add(uint256 a, uint256 b) internal pure returns (uint256) {
103     uint256 c = a + b;
104     require(c >= a, "SafeMath: addition overflow");
105 
106     return c;
107   }
108 
109   /**
110    * @dev Returns the subtraction of two unsigned integers, reverting on
111    * overflow (when the result is negative).
112    *
113    * Counterpart to Solidity's `-` operator.
114    *
115    * Requirements:
116    * - Subtraction cannot overflow.
117    */
118   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
119     return sub(a, b, "SafeMath: subtraction overflow");
120   }
121 
122   /**
123    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
124    * overflow (when the result is negative).
125    *
126    * Counterpart to Solidity's `-` operator.
127    *
128    * Requirements:
129    * - Subtraction cannot overflow.
130    */
131   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
132     require(b <= a, errorMessage);
133     uint256 c = a - b;
134 
135     return c;
136   }
137 
138   /**
139    * @dev Returns the multiplication of two unsigned integers, reverting on
140    * overflow.
141    *
142    * Counterpart to Solidity's `*` operator.
143    *
144    * Requirements:
145    * - Multiplication cannot overflow.
146    */
147   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149     // benefit is lost if 'b' is also tested.
150     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
151     if (a == 0) {
152       return 0;
153     }
154 
155     uint256 c = a * b;
156     require(c / a == b, "SafeMath: multiplication overflow");
157 
158     return c;
159   }
160 
161   /**
162    * @dev Returns the integer division of two unsigned integers. Reverts on
163    * division by zero. The result is rounded towards zero.
164    *
165    * Counterpart to Solidity's `/` operator. Note: this function uses a
166    * `revert` opcode (which leaves remaining gas untouched) while Solidity
167    * uses an invalid opcode to revert (consuming all remaining gas).
168    *
169    * Requirements:
170    * - The divisor cannot be zero.
171    */
172   function div(uint256 a, uint256 b) internal pure returns (uint256) {
173     return div(a, b, "SafeMath: division by zero");
174   }
175 
176   /**
177    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
178    * division by zero. The result is rounded towards zero.
179    *
180    * Counterpart to Solidity's `/` operator. Note: this function uses a
181    * `revert` opcode (which leaves remaining gas untouched) while Solidity
182    * uses an invalid opcode to revert (consuming all remaining gas).
183    *
184    * Requirements:
185    * - The divisor cannot be zero.
186    */
187   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188     // Solidity only automatically asserts when dividing by 0
189     require(b > 0, errorMessage);
190     uint256 c = a / b;
191     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 
193     return c;
194   }
195 
196   /**
197    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198    * Reverts when dividing by zero.
199    *
200    * Counterpart to Solidity's `%` operator. This function uses a `revert`
201    * opcode (which leaves remaining gas untouched) while Solidity uses an
202    * invalid opcode to revert (consuming all remaining gas).
203    *
204    * Requirements:
205    * - The divisor cannot be zero.
206    */
207   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
208     return mod(a, b, "SafeMath: modulo by zero");
209   }
210 
211   /**
212    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213    * Reverts with custom message when dividing by zero.
214    *
215    * Counterpart to Solidity's `%` operator. This function uses a `revert`
216    * opcode (which leaves remaining gas untouched) while Solidity uses an
217    * invalid opcode to revert (consuming all remaining gas).
218    *
219    * Requirements:
220    * - The divisor cannot be zero.
221    */
222   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223     require(b != 0, errorMessage);
224     return a % b;
225   }
226 }
227 
228 /**
229  * @dev Contract module which provides a basic access control mechanism, where
230  * there is an account (an owner) that can be granted exclusive access to
231  * specific functions.
232  *
233  * By default, the owner account will be the one that deploys the contract. This
234  * can later be changed with {transferOwnership}.
235  *
236  * This module is used through inheritance. It will make available the modifier
237  * `onlyOwner`, which can be applied to your functions to restrict their use to
238  * the owner.
239  */
240 contract Ownable is Context {
241   address private _owner;
242 
243   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
244 
245   /**
246    * @dev Initializes the contract setting the deployer as the initial owner.
247    */
248   constructor () internal {
249     address msgSender = _msgSender();
250     _owner = msgSender;
251     emit OwnershipTransferred(address(0), msgSender);
252   }
253 
254   /**
255    * @dev Returns the address of the current owner.
256    */
257   function owner() public view returns (address) {
258     return _owner;
259   }
260 
261   /**
262    * @dev Throws if called by any account other than the owner.
263    */
264   modifier onlyOwner() {
265     require(_owner == _msgSender(), "Ownable: caller is not the owner");
266     _;
267   }
268 
269   /**
270    * @dev Leaves the contract without owner. It will not be possible to call
271    * `onlyOwner` functions anymore. Can only be called by the current owner.
272    *
273    * NOTE: Renouncing ownership will leave the contract without an owner,
274    * thereby removing any functionality that is only available to the owner.
275    */
276   function renounceOwnership() public onlyOwner {
277     emit OwnershipTransferred(_owner, address(0));
278     _owner = address(0);
279   }
280 
281   /**
282    * @dev Transfers ownership of the contract to a new account (`newOwner`).
283    * Can only be called by the current owner.
284    */
285   function transferOwnership(address newOwner) public onlyOwner {
286     _transferOwnership(newOwner);
287   }
288 
289   /**
290    * @dev Transfers ownership of the contract to a new account (`newOwner`).
291    */
292   function _transferOwnership(address newOwner) internal {
293     require(newOwner != address(0), "Ownable: new owner is the zero address");
294     emit OwnershipTransferred(_owner, newOwner);
295     _owner = newOwner;
296   }
297 }
298 
299 contract MEDIFAKT is Context, iERC20, Ownable {
300   using SafeMath for uint256;
301 
302   mapping (address => uint256) private _balances;
303 
304   mapping (address => mapping (address => uint256)) private _allowances;
305 
306   uint256 private _totalSupply;
307   uint8 public _decimals;
308   string public _symbol;
309   string public _name;
310 
311   constructor() public {
312     _name = 'MEDIFAKT';
313     _symbol = 'FAKT';
314     _decimals = 18;
315     _totalSupply = 999999999 * 10**18;
316     _balances[msg.sender] = _totalSupply;
317 
318     emit Transfer(address(0), msg.sender, _totalSupply);
319   }
320 
321   /**
322    * @dev Returns the bep token owner.
323    */
324   function getOwner() external view virtual override returns (address) {
325     return owner();
326   }
327 
328   /**
329    * @dev Returns the token decimals.
330    */
331   function decimals() external view virtual override returns (uint8) {
332     return _decimals;
333   }
334 
335   /**
336    * @dev Returns the token symbol.
337    */
338   function symbol() external view virtual override returns (string memory) {
339     return _symbol;
340   }
341 
342   /**
343   * @dev Returns the token name.
344   */
345   function name() external view virtual override returns (string memory) {
346     return _name;
347   }
348 
349   /**
350    * @dev See {ERC20-totalSupply}.
351    */
352   function totalSupply() external view virtual override returns (uint256) {
353     return _totalSupply;
354   }
355 
356   /**
357    * @dev See {ERC20-balanceOf}.
358    */
359   function balanceOf(address account) external view virtual override returns (uint256) {
360     return _balances[account];
361   }
362 
363   /**
364    * @dev See {ERC20-transfer}.
365    *
366    * Requirements:
367    *
368    * - `recipient` cannot be the zero address.
369    * - the caller must have a balance of at least `amount`.
370    */
371   function transfer(address recipient, uint256 amount) external override returns (bool) {
372     _transfer(_msgSender(), recipient, amount);
373     return true;
374   }
375 
376   /**
377    * @dev See {ERC20-allowance}.
378    */
379   function allowance(address owner, address spender) external view override returns (uint256) {
380     return _allowances[owner][spender];
381   }
382 
383   /**
384    * @dev See {ERC20-approve}.
385    *
386    * Requirements:
387    *
388    * - `spender` cannot be the zero address.
389    */
390   function approve(address spender, uint256 amount) external override returns (bool) {
391     _approve(_msgSender(), spender, amount);
392     return true;
393   }
394 
395   /**
396    * @dev See {ERC20-transferFrom}.
397    *
398    * Emits an {Approval} event indicating the updated allowance. This is not
399    * required by the EIP. See the note at the beginning of {ERC20};
400    *
401    * Requirements:
402    * - `sender` and `recipient` cannot be the zero address.
403    * - `sender` must have a balance of at least `amount`.
404    * - the caller must have allowance for `sender`'s tokens of at least
405    * `amount`.
406    */
407   function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
408     _transfer(sender, recipient, amount);
409     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
410     return true;
411   }
412 
413   /**
414    * @dev Atomically increases the allowance granted to `spender` by the caller.
415    *
416    * This is an alternative to {approve} that can be used as a mitigation for
417    * problems described in {ERC20-approve}.
418    *
419    * Emits an {Approval} event indicating the updated allowance.
420    *
421    * Requirements:
422    *
423    * - `spender` cannot be the zero address.
424    */
425   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
426     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
427     return true;
428   }
429 
430   /**
431    * @dev Atomically decreases the allowance granted to `spender` by the caller.
432    *
433    * This is an alternative to {approve} that can be used as a mitigation for
434    * problems described in {ERC20-approve}.
435    *
436    * Emits an {Approval} event indicating the updated allowance.
437    *
438    * Requirements:
439    *
440    * - `spender` cannot be the zero address.
441    * - `spender` must have allowance for the caller of at least
442    * `subtractedValue`.
443    */
444   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
445     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
446     return true;
447   }
448 
449  /**
450    * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
451    * the total supply.
452    *
453    * Requirements
454    *
455    * - `msg.sender` must be the token owner
456    */
457   function mint(uint256 amount) public onlyOwner returns (bool) {
458     _mint(_msgSender(), amount);
459     return true;
460   }
461 
462     /**
463     * @dev Destroys `amount` tokens from the caller.
464     *
465     * See {ERC20-_burn}.
466     */
467   function burn(uint256 amount) public virtual {
468       _burn(_msgSender(), amount);
469   }
470 
471   /**
472     * @dev Destroys `amount` tokens from `account`, deducting from the caller's
473     * allowance.
474     *
475     * See {ERC20-_burn} and {ERC20-allowance}.
476     *
477     * Requirements:
478     *
479     * - the caller must have allowance for ``accounts``'s tokens of at least
480     * `amount`.
481     */
482   function burnFrom(address account, uint256 amount) public virtual {
483       uint256 decreasedAllowance = _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance");
484 
485       _approve(account, _msgSender(), decreasedAllowance);
486       _burn(account, amount);
487   }
488 
489 
490   /**
491    * @dev Moves tokens `amount` from `sender` to `recipient`.
492    *
493    * This is internal function is equivalent to {transfer}, and can be used to
494    * e.g. implement automatic token fees, slashing mechanisms, etc.
495    *
496    * Emits a {Transfer} event.
497    *
498    * Requirements:
499    *
500    * - `sender` cannot be the zero address.
501    * - `recipient` cannot be the zero address.
502    * - `sender` must have a balance of at least `amount`.
503    */
504   function _transfer(address sender, address recipient, uint256 amount) internal {
505     require(sender != address(0), "ERC20: transfer from the zero address");
506     require(recipient != address(0), "ERC20: transfer to the zero address");
507 
508     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
509     _balances[recipient] = _balances[recipient].add(amount);
510     emit Transfer(sender, recipient, amount);
511   }
512 
513   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
514    * the total supply.
515    *
516    * Emits a {Transfer} event with `from` set to the zero address.
517    *
518    * Requirements
519    *
520    * - `to` cannot be the zero address.
521    */
522   function _mint(address account, uint256 amount) internal {
523     require(account != address(0), "ERC20: mint to the zero address");
524 
525     _totalSupply = _totalSupply.add(amount);
526     _balances[account] = _balances[account].add(amount);
527     emit Transfer(address(0), account, amount);
528   }
529 
530   /**
531    * @dev Destroys `amount` tokens from `account`, reducing the
532    * total supply.
533    *
534    * Emits a {Transfer} event with `to` set to the zero address.
535    *
536    * Requirements
537    *
538    * - `account` cannot be the zero address.
539    * - `account` must have at least `amount` tokens.
540    */
541   function _burn(address account, uint256 amount) internal {
542     require(account != address(0), "ERC20: burn from the zero address");
543 
544     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
545     _totalSupply = _totalSupply.sub(amount);
546     emit Transfer(account, address(0), amount);
547   }
548 
549   /**
550    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
551    *
552    * This is internal function is equivalent to `approve`, and can be used to
553    * e.g. set automatic allowances for certain subsystems, etc.
554    *
555    * Emits an {Approval} event.
556    *
557    * Requirements:
558    *
559    * - `owner` cannot be the zero address.
560    * - `spender` cannot be the zero address.
561    */
562   function _approve(address owner, address spender, uint256 amount) internal {
563     require(owner != address(0), "ERC20: approve from the zero address");
564     require(spender != address(0), "ERC20: approve to the zero address");
565 
566     _allowances[owner][spender] = amount;
567     emit Approval(owner, spender, amount);
568   }
569 }