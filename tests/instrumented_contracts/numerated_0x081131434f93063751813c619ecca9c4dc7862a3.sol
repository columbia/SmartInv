1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.6.12;
4 
5 interface IBEP20 {
6   /**
7    * @dev Returns the amount of tokens in existence.
8    */
9   function totalSupply() external view returns (uint256);
10 
11   /**
12    * @dev Returns the token decimals.
13    */
14   function decimals() external view returns (uint8);
15 
16   /**
17    * @dev Returns the token symbol.
18    */
19   function symbol() external view returns (string memory);
20 
21   /**
22   * @dev Returns the token name.
23   */
24   function name() external view returns (string memory);
25 
26   /**
27    * @dev Returns the bep token owner.
28    */
29   function getOwner() external view returns (address);
30 
31   /**
32    * @dev Returns the amount of tokens owned by `account`.
33    */
34   function balanceOf(address account) external view returns (uint256);
35 
36   /**
37    * @dev Moves `amount` tokens from the caller's account to `recipient`.
38    *
39    * Returns a boolean value indicating whether the operation succeeded.
40    *
41    * Emits a {Transfer} event.
42    */
43   function transfer(address recipient, uint256 amount) external returns (bool);
44 
45   /**
46    * @dev Returns the remaining number of tokens that `spender` will be
47    * allowed to spend on behalf of `owner` through {transferFrom}. This is
48    * zero by default.
49    *
50    * This value changes when {approve} or {transferFrom} are called.
51    */
52   function allowance(address _owner, address spender) external view returns (uint256);
53 
54   /**
55    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56    *
57    * Returns a boolean value indicating whether the operation succeeded.
58    *
59    * IMPORTANT: Beware that changing an allowance with this method brings the risk
60    * that someone may use both the old and the new allowance by unfortunate
61    * transaction ordering. One possible solution to mitigate this race
62    * condition is to first reduce the spender's allowance to 0 and set the
63    * desired value afterwards:
64    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65    *
66    * Emits an {Approval} event.
67    */
68   function approve(address spender, uint256 amount) external returns (bool);
69 
70   /**
71    * @dev Moves `amount` tokens from `sender` to `recipient` using the
72    * allowance mechanism. `amount` is then deducted from the caller's
73    * allowance.
74    *
75    * Returns a boolean value indicating whether the operation succeeded.
76    *
77    * Emits a {Transfer} event.
78    */
79   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
80 
81   /**
82    * @dev Emitted when `value` tokens are moved from one account (`from`) to
83    * another (`to`).
84    *
85    * Note that `value` may be zero.
86    */
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 
89   /**
90    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91    * a call to {approve}. `value` is the new allowance.
92    */
93   event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 /*
97  * @dev Provides information about the current execution context, including the
98  * sender of the transaction and its data. While these are generally available
99  * via msg.sender and msg.data, they should not be accessed in such a direct
100  * manner, since when dealing with GSN meta-transactions the account sending and
101  * paying for execution may not be the actual sender (as far as an application
102  * is concerned).
103  *
104  * This contract is only required for intermediate, library-like contracts.
105  */
106 contract Context {
107   // Empty internal constructor, to prevent people from mistakenly deploying
108   // an instance of this contract, which should be used via inheritance.
109   constructor () internal { }
110 
111   function _msgSender() internal view returns (address payable) {
112     return msg.sender;
113   }
114 
115   function _msgData() internal view returns (bytes memory) {
116     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
117     return msg.data;
118   }
119 }
120 
121 /**
122  * @dev Wrappers over Solidity's arithmetic operations with added overflow
123  * checks.
124  *
125  * Arithmetic operations in Solidity wrap on overflow. This can easily result
126  * in bugs, because programmers usually assume that an overflow raises an
127  * error, which is the standard behavior in high level programming languages.
128  * `SafeMath` restores this intuition by reverting the transaction when an
129  * operation overflows.
130  *
131  * Using this library instead of the unchecked operations eliminates an entire
132  * class of bugs, so it's recommended to use it always.
133  */
134 library SafeMath {
135   /**
136    * @dev Returns the addition of two unsigned integers, reverting on
137    * overflow.
138    *
139    * Counterpart to Solidity's `+` operator.
140    *
141    * Requirements:
142    * - Addition cannot overflow.
143    */
144   function add(uint256 a, uint256 b) internal pure returns (uint256) {
145     uint256 c = a + b;
146     require(c >= a, "SafeMath: addition overflow");
147 
148     return c;
149   }
150 
151   /**
152    * @dev Returns the subtraction of two unsigned integers, reverting on
153    * overflow (when the result is negative).
154    *
155    * Counterpart to Solidity's `-` operator.
156    *
157    * Requirements:
158    * - Subtraction cannot overflow.
159    */
160   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161     return sub(a, b, "SafeMath: subtraction overflow");
162   }
163 
164   /**
165    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
166    * overflow (when the result is negative).
167    *
168    * Counterpart to Solidity's `-` operator.
169    *
170    * Requirements:
171    * - Subtraction cannot overflow.
172    */
173   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174     require(b <= a, errorMessage);
175     uint256 c = a - b;
176 
177     return c;
178   }
179 
180   /**
181    * @dev Returns the multiplication of two unsigned integers, reverting on
182    * overflow.
183    *
184    * Counterpart to Solidity's `*` operator.
185    *
186    * Requirements:
187    * - Multiplication cannot overflow.
188    */
189   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
191     // benefit is lost if 'b' is also tested.
192     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
193     if (a == 0) {
194       return 0;
195     }
196 
197     uint256 c = a * b;
198     require(c / a == b, "SafeMath: multiplication overflow");
199 
200     return c;
201   }
202 
203   /**
204    * @dev Returns the integer division of two unsigned integers. Reverts on
205    * division by zero. The result is rounded towards zero.
206    *
207    * Counterpart to Solidity's `/` operator. Note: this function uses a
208    * `revert` opcode (which leaves remaining gas untouched) while Solidity
209    * uses an invalid opcode to revert (consuming all remaining gas).
210    *
211    * Requirements:
212    * - The divisor cannot be zero.
213    */
214   function div(uint256 a, uint256 b) internal pure returns (uint256) {
215     return div(a, b, "SafeMath: division by zero");
216   }
217 
218   /**
219    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
220    * division by zero. The result is rounded towards zero.
221    *
222    * Counterpart to Solidity's `/` operator. Note: this function uses a
223    * `revert` opcode (which leaves remaining gas untouched) while Solidity
224    * uses an invalid opcode to revert (consuming all remaining gas).
225    *
226    * Requirements:
227    * - The divisor cannot be zero.
228    */
229   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
230     // Solidity only automatically asserts when dividing by 0
231     require(b > 0, errorMessage);
232     uint256 c = a / b;
233     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
234 
235     return c;
236   }
237 
238   /**
239    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240    * Reverts when dividing by zero.
241    *
242    * Counterpart to Solidity's `%` operator. This function uses a `revert`
243    * opcode (which leaves remaining gas untouched) while Solidity uses an
244    * invalid opcode to revert (consuming all remaining gas).
245    *
246    * Requirements:
247    * - The divisor cannot be zero.
248    */
249   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
250     return mod(a, b, "SafeMath: modulo by zero");
251   }
252 
253   /**
254    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255    * Reverts with custom message when dividing by zero.
256    *
257    * Counterpart to Solidity's `%` operator. This function uses a `revert`
258    * opcode (which leaves remaining gas untouched) while Solidity uses an
259    * invalid opcode to revert (consuming all remaining gas).
260    *
261    * Requirements:
262    * - The divisor cannot be zero.
263    */
264   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265     require(b != 0, errorMessage);
266     return a % b;
267   }
268 }
269 
270 /**
271  * @dev Contract module which provides a basic access control mechanism, where
272  * there is an account (an owner) that can be granted exclusive access to
273  * specific functions.
274  *
275  * By default, the owner account will be the one that deploys the contract. This
276  * can later be changed with {transferOwnership}.
277  *
278  * This module is used through inheritance. It will make available the modifier
279  * `onlyOwner`, which can be applied to your functions to restrict their use to
280  * the owner.
281  */
282 contract Ownable is Context {
283   address private _owner;
284 
285   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
286 
287   /**
288    * @dev Initializes the contract setting the deployer as the initial owner.
289    */
290   constructor () internal {
291     address msgSender = _msgSender();
292     _owner = msgSender;
293     emit OwnershipTransferred(address(0), msgSender);
294   }
295 
296   /**
297    * @dev Returns the address of the current owner.
298    */
299   function owner() public view returns (address) {
300     return _owner;
301   }
302 
303   /**
304    * @dev Throws if called by any account other than the owner.
305    */
306   modifier onlyOwner() {
307     require(_owner == _msgSender(), "Ownable: caller is not the owner");
308     _;
309   }
310 
311   /**
312    * @dev Leaves the contract without owner. It will not be possible to call
313    * `onlyOwner` functions anymore. Can only be called by the current owner.
314    *
315    * NOTE: Renouncing ownership will leave the contract without an owner,
316    * thereby removing any functionality that is only available to the owner.
317    */
318   function renounceOwnership() public onlyOwner {
319     emit OwnershipTransferred(_owner, address(0));
320     _owner = address(0);
321   }
322 
323   /**
324    * @dev Transfers ownership of the contract to a new account (`newOwner`).
325    * Can only be called by the current owner.
326    */
327   function transferOwnership(address newOwner) public onlyOwner {
328     _transferOwnership(newOwner);
329   }
330 
331   /**
332    * @dev Transfers ownership of the contract to a new account (`newOwner`).
333    */
334   function _transferOwnership(address newOwner) internal {
335     require(newOwner != address(0), "Ownable: new owner is the zero address");
336     emit OwnershipTransferred(_owner, newOwner);
337     _owner = newOwner;
338   }
339 }
340 
341 contract BEP20Token is Context, IBEP20, Ownable {
342   using SafeMath for uint256;
343 
344   mapping (address => uint256) private _balances;
345 
346   mapping (address => mapping (address => uint256)) private _allowances;
347   
348   event TransferToNative(address indexed from, bytes32 indexed to, uint256 value);
349   event TransferFromNative(address indexed to, bytes32 indexed refID, uint256 value);
350 
351   uint256 private _totalSupply;
352   uint8 private _decimals;
353   string private _symbol;
354   string private _name;
355 
356   constructor(uint256 totalSupply, address owner) public {
357     _name = "Dalarnia";
358     _symbol = "DAR";
359     _decimals = 6;
360     _totalSupply = totalSupply;
361     _balances[owner] = totalSupply;
362     emit Transfer(address(0), owner, _totalSupply);
363     
364     transferOwnership(owner);
365   }
366 
367   /**
368    * @dev Returns the bep token owner.
369    */
370   function getOwner() override external view returns (address) {
371     return owner();
372   }
373 
374   /**
375    * @dev Returns the token decimals.
376    */
377   function decimals() override external view returns (uint8) {
378     return _decimals;
379   }
380 
381   /**
382    * @dev Returns the token symbol.
383    */
384   function symbol() override external view returns (string memory) {
385     return _symbol;
386   }
387 
388   /**
389   * @dev Returns the token name.
390   */
391   function name() override external view returns (string memory) {
392     return _name;
393   }
394 
395   /**
396    * @dev See {BEP20-totalSupply}.
397    */
398   function totalSupply() override external view returns (uint256) {
399     return _totalSupply;
400   }
401 
402   /**
403    * @dev See {BEP20-balanceOf}.
404    */
405   function balanceOf(address account) override external view returns (uint256) {
406     return _balances[account];
407   }
408 
409   /**
410    * @dev See {BEP20-transfer}.
411    *
412    * Requirements:
413    *
414    * - `recipient` cannot be the zero address.
415    * - the caller must have a balance of at least `amount`.
416    */
417   function transfer(address recipient, uint256 amount) override external returns (bool) {
418     _transfer(_msgSender(), recipient, amount);
419     return true;
420   }
421 
422   /**
423    * @dev See {BEP20-allowance}.
424    */
425   function allowance(address owner, address spender) override external view returns (uint256) {
426     return _allowances[owner][spender];
427   }
428 
429   /**
430    * @dev See {BEP20-approve}.
431    *
432    * Requirements:
433    *
434    * - `spender` cannot be the zero address.
435    */
436   function approve(address spender, uint256 amount) override external returns (bool) {
437     _approve(_msgSender(), spender, amount);
438     return true;
439   }
440 
441   /**
442    * @dev See {BEP20-transferFrom}.
443    *
444    * Emits an {Approval} event indicating the updated allowance. This is not
445    * required by the EIP. See the note at the beginning of {BEP20};
446    *
447    * Requirements:
448    * - `sender` and `recipient` cannot be the zero address.
449    * - `sender` must have a balance of at least `amount`.
450    * - the caller must have allowance for `sender`'s tokens of at least
451    * `amount`.
452    */
453   function transferFrom(address sender, address recipient, uint256 amount) override external returns (bool) {
454     _transfer(sender, recipient, amount);
455     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
456     return true;
457   }
458 
459   /**
460    * @dev Atomically increases the allowance granted to `spender` by the caller.
461    *
462    * This is an alternative to {approve} that can be used as a mitigation for
463    * problems described in {BEP20-approve}.
464    *
465    * Emits an {Approval} event indicating the updated allowance.
466    *
467    * Requirements:
468    *
469    * - `spender` cannot be the zero address.
470    */
471   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
472     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
473     return true;
474   }
475 
476   /**
477    * @dev Atomically decreases the allowance granted to `spender` by the caller.
478    *
479    * This is an alternative to {approve} that can be used as a mitigation for
480    * problems described in {BEP20-approve}.
481    *
482    * Emits an {Approval} event indicating the updated allowance.
483    *
484    * Requirements:
485    *
486    * - `spender` cannot be the zero address.
487    * - `spender` must have allowance for the caller of at least
488    * `subtractedValue`.
489    */
490   function decreaseAllowance(address spender, uint256 subtractedValue)  public returns (bool) {
491     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
492     return true;
493   }
494 
495   /**
496    * @dev Moves tokens `amount` from `sender` to `recipient`.
497    *
498    * This is internal function is equivalent to {transfer}, and can be used to
499    * e.g. implement automatic token fees, slashing mechanisms, etc.
500    *
501    * Emits a {Transfer} event.
502    *
503    * Requirements:
504    *
505    * - `sender` cannot be the zero address.
506    * - `recipient` cannot be the zero address.
507    * - `sender` must have a balance of at least `amount`.
508    */
509   function _transfer(address sender, address recipient, uint256 amount) internal {
510     require(sender != address(0), "BEP20: transfer from the zero address");
511     require(recipient != address(0), "BEP20: transfer to the zero address");
512 
513     _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
514     _balances[recipient] = _balances[recipient].add(amount);
515     emit Transfer(sender, recipient, amount);
516   }
517 
518   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
519    * the total supply.
520    *
521    * Emits a {Transfer} event with `from` set to the zero address.
522    *
523    * Requirements
524    *
525    * - `to` cannot be the zero address.
526    */
527   function _mint(address account, uint256 amount) internal {
528     require(account != address(0), "BEP20: mint to the zero address");
529 
530     _totalSupply = _totalSupply.add(amount);
531     _balances[account] = _balances[account].add(amount);
532     emit Transfer(address(0), account, amount);
533   }
534   
535     /**
536      * @dev Burns a specific amount of tokens and emit transfer event for native chain
537      * @param to The address to transfer to in the native chain.
538      * @param value The amount of token to be burned.
539      */
540     function transferToNative(bytes32 to, uint256 value) public {
541         _burn(msg.sender, value);
542         emit TransferToNative(msg.sender, to, value);
543     }
544   
545     /**
546      * @dev Function to mint tokens
547      * @param to The address that will receive the minted tokens.
548      * @param value The amount of tokens to mint.
549      * @param refID identifier of a transfer on source chain, if any
550      * @return A boolean that indicates if the operation was successful.
551      */
552     function transferFromNative(address to, uint256 value, bytes32 refID) public onlyOwner returns (bool) {
553         _mint(to, value);
554         emit TransferFromNative(to, refID, value);
555         return true;
556     }
557 
558   /**
559    * @dev Destroys `amount` tokens from `account`, reducing the
560    * total supply.
561    *
562    * Emits a {Transfer} event with `to` set to the zero address.
563    *
564    * Requirements
565    *
566    * - `account` cannot be the zero address.
567    * - `account` must have at least `amount` tokens.
568    */
569   function _burn(address account, uint256 amount) internal {
570     require(account != address(0), "BEP20: burn from the zero address");
571 
572     _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
573     _totalSupply = _totalSupply.sub(amount);
574     emit Transfer(account, address(0), amount);
575   }
576 
577   /**
578    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
579    *
580    * This is internal function is equivalent to `approve`, and can be used to
581    * e.g. set automatic allowances for certain subsystems, etc.
582    *
583    * Emits an {Approval} event.
584    *
585    * Requirements:
586    *
587    * - `owner` cannot be the zero address.
588    * - `spender` cannot be the zero address.
589    */
590   function _approve(address owner, address spender, uint256 amount) internal {
591     require(owner != address(0), "BEP20: approve from the zero address");
592     require(spender != address(0), "BEP20: approve to the zero address");
593 
594     _allowances[owner][spender] = amount;
595     emit Approval(owner, spender, amount);
596   }
597 
598   /**
599    * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
600    * from the caller's allowance.
601    *
602    * See {_burn} and {_approve}.
603    */
604   function _burnFrom(address account, uint256 amount) internal {
605     _burn(account, amount);
606     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));
607   }
608 }