1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-02
3 */
4 
5 pragma solidity 0.5.16;
6 
7 interface IERC20 {
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
38   /**
39    * @dev Moves `amount` tokens from the caller's account to `recipient`.
40    *
41    * Returns a boolean value indicating whether the operation succeeded.
42    *
43    * Emits a {Transfer} event.
44    */
45   function transfer(address recipient, uint256 amount) external returns (bool);
46 
47   /**
48    * @dev Returns the remaining number of tokens that `spender` will be
49    * allowed to spend on behalf of `owner` through {transferFrom}. This is
50    * zero by default.
51    *
52    * This value changes when {approve} or {transferFrom} are called.
53    */
54   function allowance(address _owner, address spender) external view returns (uint256);
55 
56   /**
57    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58    *
59    * Returns a boolean value indicating whether the operation succeeded.
60    *
61    * IMPORTANT: Beware that changing an allowance with this method brings the risk
62    * that someone may use both the old and the new allowance by unfortunate
63    * transaction ordering. One possible solution to mitigate this race
64    * condition is to first reduce the spender's allowance to 0 and set the
65    * desired value afterwards:
66    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67    *
68    * Emits an {Approval} event.
69    */
70   function approve(address spender, uint256 amount) external returns (bool);
71 
72   /**
73    * @dev Moves `amount` tokens from `sender` to `recipient` using the
74    * allowance mechanism. `amount` is then deducted from the caller's
75    * allowance.
76    *
77    * Returns a boolean value indicating whether the operation succeeded.
78    *
79    * Emits a {Transfer} event.
80    */
81   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82 
83   /**
84    * @dev Emitted when `value` tokens are moved from one account (`from`) to
85    * another (`to`).
86    *
87    * Note that `value` may be zero.
88    */
89   event Transfer(address indexed from, address indexed to, uint256 value);
90 
91   /**
92    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93    * a call to {approve}. `value` is the new allowance.
94    */
95   event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 /*
99  * @dev Provides information about the current execution context, including the
100  * sender of the transaction and its data. While these are generally available
101  * via msg.sender and msg.data, they should not be accessed in such a direct
102  * manner, since when dealing with GSN meta-transactions the account sending and
103  * paying for execution may not be the actual sender (as far as an application
104  * is concerned).
105  *
106  * This contract is only required for intermediate, library-like contracts.
107  */
108 contract Context {
109   // Empty internal constructor, to prevent people from mistakenly deploying
110   // an instance of this contract, which should be used via inheritance.
111   constructor () internal { }
112 
113   function _msgSender() internal view returns (address payable) {
114     return msg.sender;
115   }
116 
117   function _msgData() internal view returns (bytes memory) {
118     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
119     return msg.data;
120   }
121 }
122 
123 /**
124  * @dev Wrappers over Solidity's arithmetic operations with added overflow
125  * checks.
126  *
127  * Arithmetic operations in Solidity wrap on overflow. This can easily result
128  * in bugs, because programmers usually assume that an overflow raises an
129  * error, which is the standard behavior in high level programming languages.
130  * `SafeMath` restores this intuition by reverting the transaction when an
131  * operation overflows.
132  *
133  * Using this library instead of the unchecked operations eliminates an entire
134  * class of bugs, so it's recommended to use it always.
135  */
136 library SafeMath {
137   /**
138    * @dev Returns the addition of two unsigned integers, reverting on
139    * overflow.
140    *
141    * Counterpart to Solidity's `+` operator.
142    *
143    * Requirements:
144    * - Addition cannot overflow.
145    */
146   function add(uint256 a, uint256 b) internal pure returns (uint256) {
147     uint256 c = a + b;
148     require(c >= a, "SafeMath: addition overflow");
149 
150     return c;
151   }
152 
153   /**
154    * @dev Returns the subtraction of two unsigned integers, reverting on
155    * overflow (when the result is negative).
156    *
157    * Counterpart to Solidity's `-` operator.
158    *
159    * Requirements:
160    * - Subtraction cannot overflow.
161    */
162   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163     return sub(a, b, "SafeMath: subtraction overflow");
164   }
165 
166   /**
167    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
168    * overflow (when the result is negative).
169    *
170    * Counterpart to Solidity's `-` operator.
171    *
172    * Requirements:
173    * - Subtraction cannot overflow.
174    */
175   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
176     require(b <= a, errorMessage);
177     uint256 c = a - b;
178 
179     return c;
180   }
181 
182   /**
183    * @dev Returns the multiplication of two unsigned integers, reverting on
184    * overflow.
185    *
186    * Counterpart to Solidity's `*` operator.
187    *
188    * Requirements:
189    * - Multiplication cannot overflow.
190    */
191   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
193     // benefit is lost if 'b' is also tested.
194     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
195     if (a == 0) {
196       return 0;
197     }
198 
199     uint256 c = a * b;
200     require(c / a == b, "SafeMath: multiplication overflow");
201 
202     return c;
203   }
204 
205   /**
206    * @dev Returns the integer division of two unsigned integers. Reverts on
207    * division by zero. The result is rounded towards zero.
208    *
209    * Counterpart to Solidity's `/` operator. Note: this function uses a
210    * `revert` opcode (which leaves remaining gas untouched) while Solidity
211    * uses an invalid opcode to revert (consuming all remaining gas).
212    *
213    * Requirements:
214    * - The divisor cannot be zero.
215    */
216   function div(uint256 a, uint256 b) internal pure returns (uint256) {
217     return div(a, b, "SafeMath: division by zero");
218   }
219 
220   /**
221    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
222    * division by zero. The result is rounded towards zero.
223    *
224    * Counterpart to Solidity's `/` operator. Note: this function uses a
225    * `revert` opcode (which leaves remaining gas untouched) while Solidity
226    * uses an invalid opcode to revert (consuming all remaining gas).
227    *
228    * Requirements:
229    * - The divisor cannot be zero.
230    */
231   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232     // Solidity only automatically asserts when dividing by 0
233     require(b > 0, errorMessage);
234     uint256 c = a / b;
235     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
236 
237     return c;
238   }
239 
240   /**
241    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242    * Reverts when dividing by zero.
243    *
244    * Counterpart to Solidity's `%` operator. This function uses a `revert`
245    * opcode (which leaves remaining gas untouched) while Solidity uses an
246    * invalid opcode to revert (consuming all remaining gas).
247    *
248    * Requirements:
249    * - The divisor cannot be zero.
250    */
251   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252     return mod(a, b, "SafeMath: modulo by zero");
253   }
254 
255   /**
256    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257    * Reverts with custom message when dividing by zero.
258    *
259    * Counterpart to Solidity's `%` operator. This function uses a `revert`
260    * opcode (which leaves remaining gas untouched) while Solidity uses an
261    * invalid opcode to revert (consuming all remaining gas).
262    *
263    * Requirements:
264    * - The divisor cannot be zero.
265    */
266   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267     require(b != 0, errorMessage);
268     return a % b;
269   }
270 }
271 
272 /**
273  * @dev Contract module which provides a basic access control mechanism, where
274  * there is an account (an owner) that can be granted exclusive access to
275  * specific functions.
276  *
277  * By default, the owner account will be the one that deploys the contract. This
278  * can later be changed with {transferOwnership}.
279  *
280  * This module is used through inheritance. It will make available the modifier
281  * `onlyOwner`, which can be applied to your functions to restrict their use to
282  * the owner.
283  */
284 contract Ownable is Context {
285   address private _owner;
286 
287   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
288 
289   /**
290    * @dev Initializes the contract setting the deployer as the initial owner.
291    */
292   constructor () internal {
293     address msgSender = _msgSender();
294     _owner = msgSender;
295     emit OwnershipTransferred(address(0), msgSender);
296   }
297 
298   /**
299    * @dev Returns the address of the current owner.
300    */
301   function owner() public view returns (address) {
302     return _owner;
303   }
304 
305   /**
306    * @dev Throws if called by any account other than the owner.
307    */
308   modifier onlyOwner() {
309     require(_owner == _msgSender(), "Ownable: caller is not the owner");
310     _;
311   }
312 
313   /**
314    * @dev Leaves the contract without owner. It will not be possible to call
315    * `onlyOwner` functions anymore. Can only be called by the current owner.
316    *
317    * NOTE: Renouncing ownership will leave the contract without an owner,
318    * thereby removing any functionality that is only available to the owner.
319    */
320   function renounceOwnership() public onlyOwner {
321     emit OwnershipTransferred(_owner, address(0));
322     _owner = address(0);
323   }
324 
325   /**
326    * @dev Transfers ownership of the contract to a new account (`newOwner`).
327    * Can only be called by the current owner.
328    */
329   function transferOwnership(address newOwner) public onlyOwner {
330     _transferOwnership(newOwner);
331   }
332 
333   /**
334    * @dev Transfers ownership of the contract to a new account (`newOwner`).
335    */
336   function _transferOwnership(address newOwner) internal {
337     require(newOwner != address(0), "Ownable: new owner is the zero address");
338     emit OwnershipTransferred(_owner, newOwner);
339     _owner = newOwner;
340   }
341 }
342 
343 contract BRISE is Context, IERC20, Ownable {
344   using SafeMath for uint256;
345 
346   mapping (address => uint256) private _balances;
347 
348   mapping (address => mapping (address => uint256)) private _allowances;
349 
350   uint256 private _totalSupply;
351   uint8 public _decimals;
352   string public _symbol;
353   string public _name;
354 
355   constructor() public {
356     _name = "Bitgert";
357     _symbol = "BRISE";
358     _decimals = 9;
359     _totalSupply = 1000000000;
360     _balances[msg.sender] = _totalSupply;
361 
362     emit Transfer(address(0), msg.sender, _totalSupply);
363   }
364 
365   /**
366    * @dev Returns the bep token owner.
367    */
368   function getOwner() external view returns (address) {
369     return owner();
370   }
371 
372   /**
373    * @dev Returns the token decimals.
374    */
375   function decimals() external view returns (uint8) {
376     return _decimals;
377   }
378 
379   /**
380    * @dev Returns the token symbol.
381    */
382   function symbol() external view returns (string memory) {
383     return _symbol;
384   }
385 
386   /**
387   * @dev Returns the token name.
388   */
389   function name() external view returns (string memory) {
390     return _name;
391   }
392 
393   /**
394    * @dev See {ERC20-totalSupply}.
395    */
396   function totalSupply() external view returns (uint256) {
397     return _totalSupply;
398   }
399 
400   /**
401    * @dev See {ERC20-balanceOf}.
402    */
403   function balanceOf(address account) external view returns (uint256) {
404     return _balances[account];
405   }
406 
407   /**
408    * @dev See {ERC20-transfer}.
409    *
410    * Requirements:
411    *
412    * - `recipient` cannot be the zero address.
413    * - the caller must have a balance of at least `amount`.
414    */
415   function transfer(address recipient, uint256 amount) external returns (bool) {
416     _transfer(_msgSender(), recipient, amount);
417     return true;
418   }
419 
420   /**
421    * @dev See {ERC20-allowance}.
422    */
423   function allowance(address owner, address spender) external view returns (uint256) {
424     return _allowances[owner][spender];
425   }
426 
427   /**
428    * @dev See {ERC20-approve}.
429    *
430    * Requirements:
431    *
432    * - `spender` cannot be the zero address.
433    */
434   function approve(address spender, uint256 amount) external returns (bool) {
435     _approve(_msgSender(), spender, amount);
436     return true;
437   }
438 
439   /**
440    * @dev See {ERC20-transferFrom}.
441    *
442    * Emits an {Approval} event indicating the updated allowance. This is not
443    * required by the EIP. See the note at the beginning of {ERC20};
444    *
445    * Requirements:
446    * - `sender` and `recipient` cannot be the zero address.
447    * - `sender` must have a balance of at least `amount`.
448    * - the caller must have allowance for `sender`'s tokens of at least
449    * `amount`.
450    */
451   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
452     _transfer(sender, recipient, amount);
453     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
454     return true;
455   }
456 
457   /**
458    * @dev Atomically increases the allowance granted to `spender` by the caller.
459    *
460    * This is an alternative to {approve} that can be used as a mitigation for
461    * problems described in {ERC20-approve}.
462    *
463    * Emits an {Approval} event indicating the updated allowance.
464    *
465    * Requirements:
466    *
467    * - `spender` cannot be the zero address.
468    */
469   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
470     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
471     return true;
472   }
473 
474   /**
475    * @dev Atomically decreases the allowance granted to `spender` by the caller.
476    *
477    * This is an alternative to {approve} that can be used as a mitigation for
478    * problems described in {ERC20-approve}.
479    *
480    * Emits an {Approval} event indicating the updated allowance.
481    *
482    * Requirements:
483    *
484    * - `spender` cannot be the zero address.
485    * - `spender` must have allowance for the caller of at least
486    * `subtractedValue`.
487    */
488   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
489     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
490     return true;
491   }
492 
493   /**
494    * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
495    * the total supply.
496    *
497    * Requirements
498    *
499    * - `msg.sender` must be the token owner
500    */
501   function mint(uint256 amount) public onlyOwner returns (bool) {
502     _mint(_msgSender(), amount);
503     return true;
504   }
505 
506   /**
507    * @dev Burn `amount` tokens and decreasing the total supply.
508    */
509   function burn(uint256 amount) public returns (bool) {
510     _burn(_msgSender(), amount);
511     return true;
512   }
513 
514   /**
515    * @dev Moves tokens `amount` from `sender` to `recipient`.
516    *
517    * This is internal function is equivalent to {transfer}, and can be used to
518    * e.g. implement automatic token fees, slashing mechanisms, etc.
519    *
520    * Emits a {Transfer} event.
521    *
522    * Requirements:
523    *
524    * - `sender` cannot be the zero address.
525    * - `recipient` cannot be the zero address.
526    * - `sender` must have a balance of at least `amount`.
527    */
528   function _transfer(address sender, address recipient, uint256 amount) internal {
529     require(sender != address(0), "ERC20: transfer from the zero address");
530     require(recipient != address(0), "ERC20: transfer to the zero address");
531 
532     _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
533     _balances[recipient] = _balances[recipient].add(amount);
534     emit Transfer(sender, recipient, amount);
535   }
536 
537   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
538    * the total supply.
539    *
540    * Emits a {Transfer} event with `from` set to the zero address.
541    *
542    * Requirements
543    *
544    * - `to` cannot be the zero address.
545    */
546   function _mint(address account, uint256 amount) internal {
547     require(account != address(0), "ERC20: mint to the zero address");
548 
549     _totalSupply = _totalSupply.add(amount);
550     _balances[account] = _balances[account].add(amount);
551     emit Transfer(address(0), account, amount);
552   }
553 
554   /**
555    * @dev Destroys `amount` tokens from `account`, reducing the
556    * total supply.
557    *
558    * Emits a {Transfer} event with `to` set to the zero address.
559    *
560    * Requirements
561    *
562    * - `account` cannot be the zero address.
563    * - `account` must have at least `amount` tokens.
564    */
565   function _burn(address account, uint256 amount) internal {
566     require(account != address(0), "ERC20: burn from the zero address");
567 
568     _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
569     _totalSupply = _totalSupply.sub(amount);
570     emit Transfer(account, address(0), amount);
571   }
572 
573   /**
574    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
575    *
576    * This is internal function is equivalent to `approve`, and can be used to
577    * e.g. set automatic allowances for certain subsystems, etc.
578    *
579    * Emits an {Approval} event.
580    *
581    * Requirements:
582    *
583    * - `owner` cannot be the zero address.
584    * - `spender` cannot be the zero address.
585    */
586   function _approve(address owner, address spender, uint256 amount) internal {
587     require(owner != address(0), "ERC20: approve from the zero address");
588     require(spender != address(0), "ERC20: approve to the zero address");
589 
590     _allowances[owner][spender] = amount;
591     emit Approval(owner, spender, amount);
592   }
593 
594   /**
595    * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
596    * from the caller's allowance.
597    *
598    * See {_burn} and {_approve}.
599    */
600   function _burnFrom(address account, uint256 amount) internal {
601     _burn(account, amount);
602     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
603   }
604 }