1 pragma solidity 0.5.16;
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
339 contract EVDC is Context, IERC20, Ownable {
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
350 
351   constructor() public {
352     _name = "EVDC";
353     _symbol = "EVDC";
354     _decimals = 18;
355     _totalSupply = 1000000000000000000000000 * 10**18;
356     _balances[msg.sender] = _totalSupply;
357 
358     emit Transfer(address(0), msg.sender, _totalSupply);
359   }
360 
361   /**
362    * @dev Returns the bep token owner.
363    */
364   function getOwner() external view returns (address) {
365     return owner();
366   }
367 
368   /**
369    * @dev Returns the token decimals.
370    */
371   function decimals() external view returns (uint8) {
372     return _decimals;
373   }
374 
375   /**
376    * @dev Returns the token symbol.
377    */
378   function symbol() external view returns (string memory) {
379     return _symbol;
380   }
381 
382   /**
383   * @dev Returns the token name.
384   */
385   function name() external view returns (string memory) {
386     return _name;
387   }
388 
389   /**
390    * @dev See {ERC20-totalSupply}.
391    */
392   function totalSupply() external view returns (uint256) {
393     return _totalSupply;
394   }
395 
396   /**
397    * @dev See {ERC20-balanceOf}.
398    */
399   function balanceOf(address account) external view returns (uint256) {
400     return _balances[account];
401   }
402 
403   /**
404    * @dev See {ERC20-transfer}.
405    *
406    * Requirements:
407    *
408    * - `recipient` cannot be the zero address.
409    * - the caller must have a balance of at least `amount`.
410    */
411   function transfer(address recipient, uint256 amount) external returns (bool) {
412     _transfer(_msgSender(), recipient, amount);
413     return true;
414   }
415 
416   /**
417    * @dev See {ERC20-allowance}.
418    */
419   function allowance(address owner, address spender) external view returns (uint256) {
420     return _allowances[owner][spender];
421   }
422 
423   /**
424    * @dev See {ERC20-approve}.
425    *
426    * Requirements:
427    *
428    * - `spender` cannot be the zero address.
429    */
430   function approve(address spender, uint256 amount) external returns (bool) {
431     _approve(_msgSender(), spender, amount);
432     return true;
433   }
434 
435   /**
436    * @dev See {ERC20-transferFrom}.
437    *
438    * Emits an {Approval} event indicating the updated allowance. This is not
439    * required by the EIP. See the note at the beginning of {ERC20};
440    *
441    * Requirements:
442    * - `sender` and `recipient` cannot be the zero address.
443    * - `sender` must have a balance of at least `amount`.
444    * - the caller must have allowance for `sender`'s tokens of at least
445    * `amount`.
446    */
447   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
448     _transfer(sender, recipient, amount);
449     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
450     return true;
451   }
452 
453   /**
454    * @dev Atomically increases the allowance granted to `spender` by the caller.
455    *
456    * This is an alternative to {approve} that can be used as a mitigation for
457    * problems described in {ERC20-approve}.
458    *
459    * Emits an {Approval} event indicating the updated allowance.
460    *
461    * Requirements:
462    *
463    * - `spender` cannot be the zero address.
464    */
465   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
466     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
467     return true;
468   }
469 
470   /**
471    * @dev Atomically decreases the allowance granted to `spender` by the caller.
472    *
473    * This is an alternative to {approve} that can be used as a mitigation for
474    * problems described in {ERC20-approve}.
475    *
476    * Emits an {Approval} event indicating the updated allowance.
477    *
478    * Requirements:
479    *
480    * - `spender` cannot be the zero address.
481    * - `spender` must have allowance for the caller of at least
482    * `subtractedValue`.
483    */
484   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
485     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
486     return true;
487   }
488 
489   /**
490    * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
491    * the total supply.
492    *
493    * Requirements
494    *
495    * - `msg.sender` must be the token owner
496    */
497   function mint(uint256 amount) public onlyOwner returns (bool) {
498     _mint(_msgSender(), amount);
499     return true;
500   }
501 
502   /**
503    * @dev Burn `amount` tokens and decreasing the total supply.
504    */
505   function burn(uint256 amount) public returns (bool) {
506     _burn(_msgSender(), amount);
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
525     require(sender != address(0), "ERC20: transfer from the zero address");
526     require(recipient != address(0), "ERC20: transfer to the zero address");
527 
528     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
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
543     require(account != address(0), "ERC20: mint to the zero address");
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
562     require(account != address(0), "ERC20: burn from the zero address");
563 
564     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
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
583     require(owner != address(0), "ERC20: approve from the zero address");
584     require(spender != address(0), "ERC20: approve to the zero address");
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
598     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
599   }
600 }