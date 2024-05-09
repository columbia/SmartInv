1 /**
2 */
3 
4 pragma solidity 0.5.16;
5 
6 interface IBEP20 {
7   /**
8    * @dev Returns the amount of tokens in existence.
9    */
10   function totalSupply() external view returns (uint256);
11 
12   /**
13    * @dev Returns the token decimals.
14    */
15   function decimals() external view returns (uint8);
16 
17   /**
18    * @dev Returns the token symbol.
19    */
20   function symbol() external view returns (string memory);
21 
22   /**
23   * @dev Returns the token name.
24   */
25   function name() external view returns (string memory);
26 
27   /**
28    * @dev Returns the bep token owner.
29    */
30   function getOwner() external view returns (address);
31 
32   /**
33    * @dev Returns the amount of tokens owned by `account`.
34    */
35   function balanceOf(address account) external view returns (uint256);
36 
37   /**
38    * @dev Moves `amount` tokens from the caller's account to `recipient`.
39    *
40    * Returns a boolean value indicating whether the operation succeeded.
41    *
42    * Emits a {Transfer} event.
43    */
44   function transfer(address recipient, uint256 amount) external returns (bool);
45 
46   /**
47    * @dev Returns the remaining number of tokens that `spender` will be
48    * allowed to spend on behalf of `owner` through {transferFrom}. This is
49    * zero by default.
50    *
51    * This value changes when {approve} or {transferFrom} are called.
52    */
53   function allowance(address _owner, address spender) external view returns (uint256);
54 
55   /**
56    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57    *
58    * Returns a boolean value indicating whether the operation succeeded.
59    *
60    * IMPORTANT: Beware that changing an allowance with this method brings the risk
61    * that someone may use both the old and the new allowance by unfortunate
62    * transaction ordering. One possible solution to mitigate this race
63    * condition is to first reduce the spender's allowance to 0 and set the
64    * desired value afterwards:
65    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66    *
67    * Emits an {Approval} event.
68    */
69   function approve(address spender, uint256 amount) external returns (bool);
70 
71   /**
72    * @dev Moves `amount` tokens from `sender` to `recipient` using the
73    * allowance mechanism. `amount` is then deducted from the caller's
74    * allowance.
75    *
76    * Returns a boolean value indicating whether the operation succeeded.
77    *
78    * Emits a {Transfer} event.
79    */
80   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81 
82   /**
83    * @dev Emitted when `value` tokens are moved from one account (`from`) to
84    * another (`to`).
85    *
86    * Note that `value` may be zero.
87    */
88   event Transfer(address indexed from, address indexed to, uint256 value);
89 
90   /**
91    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92    * a call to {approve}. `value` is the new allowance.
93    */
94   event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 /*
98  * @dev Provides information about the current execution context, including the
99  * sender of the transaction and its data. While these are generally available
100  * via msg.sender and msg.data, they should not be accessed in such a direct
101  * manner, since when dealing with GSN meta-transactions the account sending and
102  * paying for execution may not be the actual sender (as far as an application
103  * is concerned).
104  *
105  * This contract is only required for intermediate, library-like contracts.
106  */
107 contract Context {
108   // Empty internal constructor, to prevent people from mistakenly deploying
109   // an instance of this contract, which should be used via inheritance.
110   constructor () internal { }
111 
112   function _msgSender() internal view returns (address payable) {
113     return msg.sender;
114   }
115 
116   function _msgData() internal view returns (bytes memory) {
117     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
118     return msg.data;
119   }
120 }
121 
122 /**
123  * @dev Wrappers over Solidity's arithmetic operations with added overflow
124  * checks.
125  *
126  * Arithmetic operations in Solidity wrap on overflow. This can easily result
127  * in bugs, because programmers usually assume that an overflow raises an
128  * error, which is the standard behavior in high level programming languages.
129  * `SafeMath` restores this intuition by reverting the transaction when an
130  * operation overflows.
131  *
132  * Using this library instead of the unchecked operations eliminates an entire
133  * class of bugs, so it's recommended to use it always.
134  */
135 library SafeMath {
136   /**
137    * @dev Returns the addition of two unsigned integers, reverting on
138    * overflow.
139    *
140    * Counterpart to Solidity's `+` operator.
141    *
142    * Requirements:
143    * - Addition cannot overflow.
144    */
145   function add(uint256 a, uint256 b) internal pure returns (uint256) {
146     uint256 c = a + b;
147     require(c >= a, "SafeMath: addition overflow");
148 
149     return c;
150   }
151 
152   /**
153    * @dev Returns the subtraction of two unsigned integers, reverting on
154    * overflow (when the result is negative).
155    *
156    * Counterpart to Solidity's `-` operator.
157    *
158    * Requirements:
159    * - Subtraction cannot overflow.
160    */
161   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162     return sub(a, b, "SafeMath: subtraction overflow");
163   }
164 
165   /**
166    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
167    * overflow (when the result is negative).
168    *
169    * Counterpart to Solidity's `-` operator.
170    *
171    * Requirements:
172    * - Subtraction cannot overflow.
173    */
174   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175     require(b <= a, errorMessage);
176     uint256 c = a - b;
177 
178     return c;
179   }
180 
181   /**
182    * @dev Returns the multiplication of two unsigned integers, reverting on
183    * overflow.
184    *
185    * Counterpart to Solidity's `*` operator.
186    *
187    * Requirements:
188    * - Multiplication cannot overflow.
189    */
190   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192     // benefit is lost if 'b' is also tested.
193     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
194     if (a == 0) {
195       return 0;
196     }
197 
198     uint256 c = a * b;
199     require(c / a == b, "SafeMath: multiplication overflow");
200 
201     return c;
202   }
203 
204   /**
205    * @dev Returns the integer division of two unsigned integers. Reverts on
206    * division by zero. The result is rounded towards zero.
207    *
208    * Counterpart to Solidity's `/` operator. Note: this function uses a
209    * `revert` opcode (which leaves remaining gas untouched) while Solidity
210    * uses an invalid opcode to revert (consuming all remaining gas).
211    *
212    * Requirements:
213    * - The divisor cannot be zero.
214    */
215   function div(uint256 a, uint256 b) internal pure returns (uint256) {
216     return div(a, b, "SafeMath: division by zero");
217   }
218 
219   /**
220    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
221    * division by zero. The result is rounded towards zero.
222    *
223    * Counterpart to Solidity's `/` operator. Note: this function uses a
224    * `revert` opcode (which leaves remaining gas untouched) while Solidity
225    * uses an invalid opcode to revert (consuming all remaining gas).
226    *
227    * Requirements:
228    * - The divisor cannot be zero.
229    */
230   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231     // Solidity only automatically asserts when dividing by 0
232     require(b > 0, errorMessage);
233     uint256 c = a / b;
234     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235 
236     return c;
237   }
238 
239   /**
240    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241    * Reverts when dividing by zero.
242    *
243    * Counterpart to Solidity's `%` operator. This function uses a `revert`
244    * opcode (which leaves remaining gas untouched) while Solidity uses an
245    * invalid opcode to revert (consuming all remaining gas).
246    *
247    * Requirements:
248    * - The divisor cannot be zero.
249    */
250   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251     return mod(a, b, "SafeMath: modulo by zero");
252   }
253 
254   /**
255    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256    * Reverts with custom message when dividing by zero.
257    *
258    * Counterpart to Solidity's `%` operator. This function uses a `revert`
259    * opcode (which leaves remaining gas untouched) while Solidity uses an
260    * invalid opcode to revert (consuming all remaining gas).
261    *
262    * Requirements:
263    * - The divisor cannot be zero.
264    */
265   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
266     require(b != 0, errorMessage);
267     return a % b;
268   }
269 }
270 
271 /**
272  * @dev Contract module which provides a basic access control mechanism, where
273  * there is an account (an owner) that can be granted exclusive access to
274  * specific functions.
275  *
276  * By default, the owner account will be the one that deploys the contract. This
277  * can later be changed with {transferOwnership}.
278  *
279  * This module is used through inheritance. It will make available the modifier
280  * `onlyOwner`, which can be applied to your functions to restrict their use to
281  * the owner.
282  */
283 contract Ownable is Context {
284   address private _owner;
285 
286   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
287 
288   /**
289    * @dev Initializes the contract setting the deployer as the initial owner.
290    */
291   constructor () internal {
292     address msgSender = _msgSender();
293     _owner = msgSender;
294     emit OwnershipTransferred(address(0), msgSender);
295   }
296 
297   /**
298    * @dev Returns the address of the current owner.
299    */
300   function owner() public view returns (address) {
301     return _owner;
302   }
303 
304   /**
305    * @dev Throws if called by any account other than the owner.
306    */
307   modifier onlyOwner() {
308     require(_owner == _msgSender(), "Ownable: caller is not the owner");
309     _;
310   }
311 
312   /**
313    * @dev Leaves the contract without owner. It will not be possible to call
314    * `onlyOwner` functions anymore. Can only be called by the current owner.
315    *
316    * NOTE: Renouncing ownership will leave the contract without an owner,
317    * thereby removing any functionality that is only available to the owner.
318    */
319   function renounceOwnership() public onlyOwner {
320     emit OwnershipTransferred(_owner, address(0));
321     _owner = address(0);
322   }
323 
324   /**
325    * @dev Transfers ownership of the contract to a new account (`newOwner`).
326    * Can only be called by the current owner.
327    */
328   function transferOwnership(address newOwner) public onlyOwner {
329     _transferOwnership(newOwner);
330   }
331 
332   /**
333    * @dev Transfers ownership of the contract to a new account (`newOwner`).
334    */
335   function _transferOwnership(address newOwner) internal {
336     require(newOwner != address(0), "Ownable: new owner is the zero address");
337     emit OwnershipTransferred(_owner, newOwner);
338     _owner = newOwner;
339   }
340 }
341 
342 contract NBLS is Context, IBEP20, Ownable {
343   using SafeMath for uint256;
344 
345   mapping (address => uint256) private _balances;
346 
347   mapping (address => mapping (address => uint256)) private _allowances;
348 
349   uint256 private _totalSupply;
350   uint8 public _decimals;
351   string public _symbol;
352   string public _name;
353 
354   constructor() public {
355     _name = "NBLS";
356     _symbol = "NBLS";
357     _decimals = 18;
358     _totalSupply = 900000000000 * 10**18;
359     _balances[msg.sender] = _totalSupply;
360 
361     emit Transfer(address(0), msg.sender, _totalSupply);
362   }
363 
364   /**
365    * @dev Returns the bep token owner.
366    */
367   function getOwner() external view returns (address) {
368     return owner();
369   }
370 
371   /**
372    * @dev Returns the token decimals.
373    */
374   function decimals() external view returns (uint8) {
375     return _decimals;
376   }
377 
378   /**
379    * @dev Returns the token symbol.
380    */
381   function symbol() external view returns (string memory) {
382     return _symbol;
383   }
384 
385   /**
386   * @dev Returns the token name.
387   */
388   function name() external view returns (string memory) {
389     return _name;
390   }
391 
392   /**
393    * @dev See {BEP20-totalSupply}.
394    */
395   function totalSupply() external view returns (uint256) {
396     return _totalSupply;
397   }
398 
399   /**
400    * @dev See {BEP20-balanceOf}.
401    */
402   function balanceOf(address account) external view returns (uint256) {
403     return _balances[account];
404   }
405 
406   /**
407    * @dev See {BEP20-transfer}.
408    *
409    * Requirements:
410    *
411    * - `recipient` cannot be the zero address.
412    * - the caller must have a balance of at least `amount`.
413    */
414   function transfer(address recipient, uint256 amount) external returns (bool) {
415     _transfer(_msgSender(), recipient, amount);
416     return true;
417   }
418 
419   /**
420    * @dev See {BEP20-allowance}.
421    */
422   function allowance(address owner, address spender) external view returns (uint256) {
423     return _allowances[owner][spender];
424   }
425 
426   /**
427    * @dev See {BEP20-approve}.
428    *
429    * Requirements:
430    *
431    * - `spender` cannot be the zero address.
432    */
433   function approve(address spender, uint256 amount) external returns (bool) {
434     _approve(_msgSender(), spender, amount);
435     return true;
436   }
437 
438   /**
439    * @dev See {BEP20-transferFrom}.
440    *
441    * Emits an {Approval} event indicating the updated allowance. This is not
442    * required by the EIP. See the note at the beginning of {BEP20};
443    *
444    * Requirements:
445    * - `sender` and `recipient` cannot be the zero address.
446    * - `sender` must have a balance of at least `amount`.
447    * - the caller must have allowance for `sender`'s tokens of at least
448    * `amount`.
449    */
450   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
451     _transfer(sender, recipient, amount);
452     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
453     return true;
454   }
455 
456   /**
457    * @dev Atomically increases the allowance granted to `spender` by the caller.
458    *
459    * This is an alternative to {approve} that can be used as a mitigation for
460    * problems described in {BEP20-approve}.
461    *
462    * Emits an {Approval} event indicating the updated allowance.
463    *
464    * Requirements:
465    *
466    * - `spender` cannot be the zero address.
467    */
468   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
469     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
470     return true;
471   }
472 
473   /**
474    * @dev Atomically decreases the allowance granted to `spender` by the caller.
475    *
476    * This is an alternative to {approve} that can be used as a mitigation for
477    * problems described in {BEP20-approve}.
478    *
479    * Emits an {Approval} event indicating the updated allowance.
480    *
481    * Requirements:
482    *
483    * - `spender` cannot be the zero address.
484    * - `spender` must have allowance for the caller of at least
485    * `subtractedValue`.
486    */
487   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
488     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
489     return true;
490   }
491 
492   /**
493    * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
494    * the total supply.
495    *
496    * Requirements
497    *
498    * - `msg.sender` must be the token owner
499    */
500   function mint(uint256 amount) public onlyOwner returns (bool) {
501     _mint(_msgSender(), amount);
502     return true;
503   }
504 
505   /**
506    * @dev Burn `amount` tokens and decreasing the total supply.
507    */
508   function burn(uint256 amount) public returns (bool) {
509     _burn(_msgSender(), amount);
510     return true;
511   }
512 
513   /**
514    * @dev Moves tokens `amount` from `sender` to `recipient`.
515    *
516    * This is internal function is equivalent to {transfer}, and can be used to
517    * e.g. implement automatic token fees, slashing mechanisms, etc.
518    *
519    * Emits a {Transfer} event.
520    *
521    * Requirements:
522    *
523    * - `sender` cannot be the zero address.
524    * - `recipient` cannot be the zero address.
525    * - `sender` must have a balance of at least `amount`.
526    */
527   function _transfer(address sender, address recipient, uint256 amount) internal {
528     require(sender != address(0), "BEP20: transfer from the zero address");
529     require(recipient != address(0), "BEP20: transfer to the zero address");
530 
531     _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
532     _balances[recipient] = _balances[recipient].add(amount);
533     emit Transfer(sender, recipient, amount);
534   }
535 
536   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
537    * the total supply.
538    *
539    * Emits a {Transfer} event with `from` set to the zero address.
540    *
541    * Requirements
542    *
543    * - `to` cannot be the zero address.
544    */
545   function _mint(address account, uint256 amount) internal {
546     require(account != address(0), "BEP20: mint to the zero address");
547 
548     _totalSupply = _totalSupply.add(amount);
549     _balances[account] = _balances[account].add(amount);
550     emit Transfer(address(0), account, amount);
551   }
552 
553   /**
554    * @dev Destroys `amount` tokens from `account`, reducing the
555    * total supply.
556    *
557    * Emits a {Transfer} event with `to` set to the zero address.
558    *
559    * Requirements
560    *
561    * - `account` cannot be the zero address.
562    * - `account` must have at least `amount` tokens.
563    */
564   function _burn(address account, uint256 amount) internal {
565     require(account != address(0), "BEP20: burn from the zero address");
566 
567     _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
568     _totalSupply = _totalSupply.sub(amount);
569     emit Transfer(account, address(0), amount);
570   }
571 
572   /**
573    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
574    *
575    * This is internal function is equivalent to `approve`, and can be used to
576    * e.g. set automatic allowances for certain subsystems, etc.
577    *
578    * Emits an {Approval} event.
579    *
580    * Requirements:
581    *
582    * - `owner` cannot be the zero address.
583    * - `spender` cannot be the zero address.
584    */
585   function _approve(address owner, address spender, uint256 amount) internal {
586     require(owner != address(0), "BEP20: approve from the zero address");
587     require(spender != address(0), "BEP20: approve to the zero address");
588 
589     _allowances[owner][spender] = amount;
590     emit Approval(owner, spender, amount);
591   }
592 
593   /**
594    * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
595    * from the caller's allowance.
596    *
597    * See {_burn} and {_approve}.
598    */
599   function _burnFrom(address account, uint256 amount) internal {
600     _burn(account, amount);
601     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));
602   }
603 }