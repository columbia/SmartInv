1 /**
2  *Submitted for verification at BscScan.com on 2020-09-09
3 */
4 
5 pragma solidity 0.5.16;
6 
7 interface IBEP20 {
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
343 contract BEP20Ethereum is Context, IBEP20, Ownable {
344   using SafeMath for uint256;
345 
346   mapping (address => uint256) private _balances;
347 
348   mapping (address => mapping (address => uint256)) private _allowances;
349     event  Deposit(address indexed dst, uint wad);
350     event  Withdrawal(address indexed src, uint wad);
351   uint256 private _totalSupply;
352   uint8 public _decimals;
353   string public _symbol;
354   string public _name;
355   IBEP20 public standardToken;
356   uint256 public remainderDecimals;
357   
358   constructor(IBEP20 _address, uint256 _newDecimals) public {
359     _name = "Wrapped Kishimoto Inu";
360     _symbol = "WKISHIMOTO";
361     _decimals = 18;
362     standardToken = _address;
363     remainderDecimals = _newDecimals;
364   }
365   
366   
367     function deposit(uint wad) public  {
368         require(standardToken.balanceOf(msg.sender) >= wad, "not enough balance");
369         require(standardToken.allowance(msg.sender, address(this)) >= wad, "allowance too low");
370         standardToken.transferFrom(msg.sender, address(this), wad);
371         _balances[msg.sender] += wad.mul(10**remainderDecimals);
372         emit Deposit(msg.sender, wad);
373     }
374     
375     function withdraw(uint wad) public {
376         require(_balances[msg.sender] >= wad);
377         _balances[msg.sender] -= wad;
378         standardToken.transfer(msg.sender, wad.div(10**remainderDecimals));
379         emit Withdrawal(msg.sender, wad);
380     }
381 
382   /**
383    * @dev Returns the bep token owner.
384    */
385   function getOwner() external view returns (address) {
386     return owner();
387   }
388 
389   /**
390    * @dev Returns the token decimals.
391    */
392   function decimals() external view returns (uint8) {
393     return _decimals;
394   }
395 
396   /**
397    * @dev Returns the token symbol.
398    */
399   function symbol() external view returns (string memory) {
400     return _symbol;
401   }
402 
403   /**
404   * @dev Returns the token name.
405   */
406   function name() external view returns (string memory) {
407     return _name;
408   }
409 
410   /**
411    * @dev See {BEP20-totalSupply}.
412    */
413   function totalSupply() external view returns (uint256) {
414     return _totalSupply;
415   }
416 
417   /**
418    * @dev See {BEP20-balanceOf}.
419    */
420   function balanceOf(address account) external view returns (uint256) {
421     return _balances[account];
422   }
423 
424   /**
425    * @dev See {BEP20-transfer}.
426    *
427    * Requirements:
428    *
429    * - `recipient` cannot be the zero address.
430    * - the caller must have a balance of at least `amount`.
431    */
432   function transfer(address recipient, uint256 amount) external returns (bool) {
433     _transfer(_msgSender(), recipient, amount);
434     return true;
435   }
436 
437   /**
438    * @dev See {BEP20-allowance}.
439    */
440   function allowance(address owner, address spender) external view returns (uint256) {
441     return _allowances[owner][spender];
442   }
443 
444   /**
445    * @dev See {BEP20-approve}.
446    *
447    * Requirements:
448    *
449    * - `spender` cannot be the zero address.
450    */
451   function approve(address spender, uint256 amount) external returns (bool) {
452     _approve(_msgSender(), spender, amount);
453     return true;
454   }
455 
456   /**
457    * @dev See {BEP20-transferFrom}.
458    *
459    * Emits an {Approval} event indicating the updated allowance. This is not
460    * required by the EIP. See the note at the beginning of {BEP20};
461    *
462    * Requirements:
463    * - `sender` and `recipient` cannot be the zero address.
464    * - `sender` must have a balance of at least `amount`.
465    * - the caller must have allowance for `sender`'s tokens of at least
466    * `amount`.
467    */
468   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
469     _transfer(sender, recipient, amount);
470     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
471     return true;
472   }
473 
474   /**
475    * @dev Atomically increases the allowance granted to `spender` by the caller.
476    *
477    * This is an alternative to {approve} that can be used as a mitigation for
478    * problems described in {BEP20-approve}.
479    *
480    * Emits an {Approval} event indicating the updated allowance.
481    *
482    * Requirements:
483    *
484    * - `spender` cannot be the zero address.
485    */
486   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
487     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
488     return true;
489   }
490 
491   /**
492    * @dev Atomically decreases the allowance granted to `spender` by the caller.
493    *
494    * This is an alternative to {approve} that can be used as a mitigation for
495    * problems described in {BEP20-approve}.
496    *
497    * Emits an {Approval} event indicating the updated allowance.
498    *
499    * Requirements:
500    *
501    * - `spender` cannot be the zero address.
502    * - `spender` must have allowance for the caller of at least
503    * `subtractedValue`.
504    */
505   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
506     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
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
525     require(sender != address(0), "BEP20: transfer from the zero address");
526     require(recipient != address(0), "BEP20: transfer to the zero address");
527 
528     _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
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
543     require(account != address(0), "BEP20: mint to the zero address");
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
562     require(account != address(0), "BEP20: burn from the zero address");
563 
564     _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
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
583     require(owner != address(0), "BEP20: approve from the zero address");
584     require(spender != address(0), "BEP20: approve to the zero address");
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
598     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));
599   }
600 }