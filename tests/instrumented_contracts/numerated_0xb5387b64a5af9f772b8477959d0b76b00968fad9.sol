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
56    * Emits an {Approval} event.
57    */
58   function approve(address spender, uint256 amount) external returns (bool);
59 
60   /**
61    * @dev Moves `amount` tokens from `sender` to `recipient` using the
62    * allowance mechanism. `amount` is then deducted from the caller's
63    * allowance.
64    *
65    * Returns a boolean value indicating whether the operation succeeded.
66    *
67    * Emits a {Transfer} event.
68    */
69   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71   /**
72    * @dev Emitted when `value` tokens are moved from one account (`from`) to
73    * another (`to`).
74    *
75    * Note that `value` may be zero.
76    */
77   event Transfer(address indexed from, address indexed to, uint256 value);
78 
79   /**
80    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81    * a call to {approve}. `value` is the new allowance.
82    */
83   event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 /*
87  * @dev Provides information about the current execution context, including the
88  * sender of the transaction and its data. While these are generally available
89  * via msg.sender and msg.data, they should not be accessed in such a direct
90  * manner, since when dealing with GSN meta-transactions the account sending and
91  * paying for execution may not be the actual sender (as far as an application
92  * is concerned).
93  *
94  * This contract is only required for intermediate, library-like contracts.
95  */
96 contract Context {
97   // Empty internal constructor, to prevent people from mistakenly deploying
98   // an instance of this contract, which should be used via inheritance.
99   constructor () internal { }
100 
101   function _msgSender() internal view returns (address payable) {
102     return msg.sender;
103   }
104 
105   function _msgData() internal view returns (bytes memory) {
106     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
107     return msg.data;
108   }
109 }
110 
111 /**
112  * @dev Wrappers over Solidity's arithmetic operations with added overflow
113  * checks.
114  *
115  * Arithmetic operations in Solidity wrap on overflow. This can easily result
116  * in bugs, because programmers usually assume that an overflow raises an
117  * error, which is the standard behavior in high level programming languages.
118  * `SafeMath` restores this intuition by reverting the transaction when an
119  * operation overflows.
120  *
121  * Using this library instead of the unchecked operations eliminates an entire
122  * class of bugs, so it's recommended to use it always.
123  */
124 library SafeMath {
125   /**
126    * @dev Returns the addition of two unsigned integers, reverting on
127    * overflow.
128    *
129    * Counterpart to Solidity's `+` operator.
130    *
131    * Requirements:
132    * - Addition cannot overflow.
133    */
134   function add(uint256 a, uint256 b) internal pure returns (uint256) {
135     uint256 c = a + b;
136     require(c >= a, "SafeMath: addition overflow");
137 
138     return c;
139   }
140 
141   /**
142    * @dev Returns the subtraction of two unsigned integers, reverting on
143    * overflow (when the result is negative).
144    *
145    * Counterpart to Solidity's `-` operator.
146    *
147    * Requirements:
148    * - Subtraction cannot overflow.
149    */
150   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
151     return sub(a, b, "SafeMath: subtraction overflow");
152   }
153 
154   /**
155    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
156    * overflow (when the result is negative).
157    *
158    * Counterpart to Solidity's `-` operator.
159    *
160    * Requirements:
161    * - Subtraction cannot overflow.
162    */
163   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164     require(b <= a, errorMessage);
165     uint256 c = a - b;
166 
167     return c;
168   }
169 
170   /**
171    * @dev Returns the multiplication of two unsigned integers, reverting on
172    * overflow.
173    *
174    * Counterpart to Solidity's `*` operator.
175    *
176    * Requirements:
177    * - Multiplication cannot overflow.
178    */
179   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
181     // benefit is lost if 'b' is also tested.
182     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
183     if (a == 0) {
184       return 0;
185     }
186 
187     uint256 c = a * b;
188     require(c / a == b, "SafeMath: multiplication overflow");
189 
190     return c;
191   }
192 
193   /**
194    * @dev Returns the integer division of two unsigned integers. Reverts on
195    * division by zero. The result is rounded towards zero.
196    *
197    * Counterpart to Solidity's `/` operator. Note: this function uses a
198    * `revert` opcode (which leaves remaining gas untouched) while Solidity
199    * uses an invalid opcode to revert (consuming all remaining gas).
200    *
201    * Requirements:
202    * - The divisor cannot be zero.
203    */
204   function div(uint256 a, uint256 b) internal pure returns (uint256) {
205     return div(a, b, "SafeMath: division by zero");
206   }
207 
208   /**
209    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210    * division by zero. The result is rounded towards zero.
211    *
212    * Counterpart to Solidity's `/` operator. Note: this function uses a
213    * `revert` opcode (which leaves remaining gas untouched) while Solidity
214    * uses an invalid opcode to revert (consuming all remaining gas).
215    *
216    * Requirements:
217    * - The divisor cannot be zero.
218    */
219   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220     // Solidity only automatically asserts when dividing by 0
221     require(b > 0, errorMessage);
222     uint256 c = a / b;
223     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225     return c;
226   }
227 
228   /**
229    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230    * Reverts when dividing by zero.
231    *
232    * Counterpart to Solidity's `%` operator. This function uses a `revert`
233    * opcode (which leaves remaining gas untouched) while Solidity uses an
234    * invalid opcode to revert (consuming all remaining gas).
235    *
236    * Requirements:
237    * - The divisor cannot be zero.
238    */
239   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240     return mod(a, b, "SafeMath: modulo by zero");
241   }
242 
243   /**
244    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245    * Reverts with custom message when dividing by zero.
246    *
247    * Counterpart to Solidity's `%` operator. This function uses a `revert`
248    * opcode (which leaves remaining gas untouched) while Solidity uses an
249    * invalid opcode to revert (consuming all remaining gas).
250    *
251    * Requirements:
252    * - The divisor cannot be zero.
253    */
254   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255     require(b != 0, errorMessage);
256     return a % b;
257   }
258 }
259 
260 /**
261  * @dev Contract module which provides a basic access control mechanism, where
262  * there is an account (an owner) that can be granted exclusive access to
263  * specific functions.
264  *
265  * By default, the owner account will be the one that deploys the contract. This
266  * can later be changed with {transferOwnership}.
267  *
268  * This module is used through inheritance. It will make available the modifier
269  * `onlyOwner`, which can be applied to your functions to restrict their use to
270  * the owner.
271  */
272 contract Ownable is Context {
273   address private _owner;
274 
275   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
276 
277   /**
278    * @dev Initializes the contract setting the deployer as the initial owner.
279    */
280   constructor () internal {
281     address msgSender = _msgSender();
282     _owner = msgSender;
283     emit OwnershipTransferred(address(0), msgSender);
284   }
285 
286   /**
287    * @dev Returns the address of the current owner.
288    */
289   function owner() public view returns (address) {
290     return _owner;
291   }
292 
293   /**
294    * @dev Throws if called by any account other than the owner.
295    */
296   modifier onlyOwner() {
297     require(_owner == _msgSender(), "Ownable: caller is not the owner");
298     _;
299   }
300 
301   /**
302    * @dev Leaves the contract without owner. It will not be possible to call
303    * `onlyOwner` functions anymore. Can only be called by the current owner.
304    *
305    * NOTE: Renouncing ownership will leave the contract without an owner,
306    * thereby removing any functionality that is only available to the owner.
307    */
308   function renounceOwnership() public onlyOwner {
309     emit OwnershipTransferred(_owner, address(0));
310     _owner = address(0);
311   }
312 
313   /**
314    * @dev Transfers ownership of the contract to a new account (`newOwner`).
315    * Can only be called by the current owner.
316    */
317   function transferOwnership(address newOwner) public onlyOwner {
318     _transferOwnership(newOwner);
319   }
320 
321   /**
322    * @dev Transfers ownership of the contract to a new account (`newOwner`).
323    */
324   function _transferOwnership(address newOwner) internal {
325     require(newOwner != address(0), "Ownable: new owner is the zero address");
326     emit OwnershipTransferred(_owner, newOwner);
327     _owner = newOwner;
328   }
329 }
330 
331 contract SKX2 is Context, IBEP20, Ownable {
332   using SafeMath for uint256;
333 
334   mapping (address => uint256) private _balances;
335 
336   mapping (address => mapping (address => uint256)) private _allowances;
337 
338   uint256 private _totalSupply;
339   uint8 public _decimals;
340   string public _symbol;
341   string public _name;
342 
343   constructor() public {
344     _name = "SKX2";
345     _symbol = "SKX2";
346     _decimals = 18;
347     _totalSupply = 1000000000 * 10**18;
348     _balances[msg.sender] = _totalSupply;
349 
350     emit Transfer(address(0), msg.sender, _totalSupply);
351   }
352 
353   /**
354    * @dev Returns the bep token owner.
355    */
356   function getOwner() external view returns (address) {
357     return owner();
358   }
359 
360   /**
361    * @dev Returns the token decimals.
362    */
363   function decimals() external view returns (uint8) {
364     return _decimals;
365   }
366 
367   /**
368    * @dev Returns the token symbol.
369    */
370   function symbol() external view returns (string memory) {
371     return _symbol;
372   }
373 
374   /**
375   * @dev Returns the token name.
376   */
377   function name() external view returns (string memory) {
378     return _name;
379   }
380 
381   /**
382    * @dev See {BEP20-totalSupply}.
383    */
384   function totalSupply() external view returns (uint256) {
385     return _totalSupply;
386   }
387 
388   /**
389    * @dev See {BEP20-balanceOf}.
390    */
391   function balanceOf(address account) external view returns (uint256) {
392     return _balances[account];
393   }
394 
395   /**
396    * @dev See {BEP20-transfer}.
397    *
398    * Requirements:
399    *
400    * - `recipient` cannot be the zero address.
401    * - the caller must have a balance of at least `amount`.
402    */
403   function transfer(address recipient, uint256 amount) external returns (bool) {
404     _transfer(_msgSender(), recipient, amount);
405     return true;
406   }
407 
408   /**
409    * @dev See {BEP20-allowance}.
410    */
411   function allowance(address owner, address spender) external view returns (uint256) {
412     return _allowances[owner][spender];
413   }
414 
415   /**
416    * @dev See {BEP20-approve}.
417    *
418    * Requirements:
419    *
420    * - `spender` cannot be the zero address.
421    */
422   function approve(address spender, uint256 amount) external returns (bool) {
423     _approve(_msgSender(), spender, amount);
424     return true;
425   }
426 
427   /**
428    * @dev See {BEP20-transferFrom}.
429    *
430    * Emits an {Approval} event indicating the updated allowance. This is not
431    * required by the EIP. See the note at the beginning of {BEP20};
432    *
433    * Requirements:
434    * - `sender` and `recipient` cannot be the zero address.
435    * - `sender` must have a balance of at least `amount`.
436    * - the caller must have allowance for `sender`'s tokens of at least
437    * `amount`.
438    */
439   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
440     _transfer(sender, recipient, amount);
441     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
442     return true;
443   }
444 
445   /**
446    * @dev Atomically increases the allowance granted to `spender` by the caller.
447    *
448    * This is an alternative to {approve} that can be used as a mitigation for
449    * problems described in {BEP20-approve}.
450    *
451    * Emits an {Approval} event indicating the updated allowance.
452    *
453    * Requirements:
454    *
455    * - `spender` cannot be the zero address.
456    */
457   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
458     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
459     return true;
460   }
461 
462   /**
463    * @dev Atomically decreases the allowance granted to `spender` by the caller.
464    *
465    * This is an alternative to {approve} that can be used as a mitigation for
466    * problems described in {BEP20-approve}.
467    *
468    * Emits an {Approval} event indicating the updated allowance.
469    *
470    * Requirements:
471    *
472    * - `spender` cannot be the zero address.
473    * - `spender` must have allowance for the caller of at least
474    * `subtractedValue`.
475    */
476   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
477     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
478     return true;
479   }
480 
481 
482   /**
483    * @dev Burn `amount` tokens and decreasing the total supply.
484    */
485   function burn(uint256 amount) public returns (bool) {
486     _burn(_msgSender(), amount);
487     return true;
488   }
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
505     require(sender != address(0), "BEP20: transfer from the zero address");
506     require(recipient != address(0), "BEP20: transfer to the zero address");
507 
508     _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
509     _balances[recipient] = _balances[recipient].add(amount);
510     emit Transfer(sender, recipient, amount);
511   }
512 
513   /**
514    * @dev Destroys `amount` tokens from `account`, reducing the
515    * total supply.
516    *
517    * Emits a {Transfer} event with `to` set to the zero address.
518    *
519    * Requirements
520    *
521    * - `account` cannot be the zero address.
522    * - `account` must have at least `amount` tokens.
523    */
524   function _burn(address account, uint256 amount) internal {
525     require(account != address(0), "BEP20: burn from the zero address");
526 
527     _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
528     _totalSupply = _totalSupply.sub(amount);
529     emit Transfer(account, address(0), amount);
530   }
531 
532   /**
533    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
534    *
535    * This is internal function is equivalent to `approve`, and can be used to
536    * e.g. set automatic allowances for certain subsystems, etc.
537    *
538    * Emits an {Approval} event.
539    *
540    * Requirements:
541    *
542    * - `owner` cannot be the zero address.
543    * - `spender` cannot be the zero address.
544    */
545   function _approve(address owner, address spender, uint256 amount) internal {
546     require(owner != address(0), "BEP20: approve from the zero address");
547     require(spender != address(0), "BEP20: approve to the zero address");
548 
549     _allowances[owner][spender] = amount;
550     emit Approval(owner, spender, amount);
551   }
552 
553   /**
554    * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
555    * from the caller's allowance.
556    *
557    * See {_burn} and {_approve}.
558    */
559   function _burnFrom(address account, uint256 amount) internal {
560     _burn(account, amount);
561     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));
562   }
563 }