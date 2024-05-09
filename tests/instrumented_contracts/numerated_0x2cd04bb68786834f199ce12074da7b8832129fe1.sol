1 pragma solidity 0.5.11;
2 
3 /**
4  * @dev Collection of functions related to the address type,
5  */
6 library Address {
7     /**
8      * @dev Returns true if `account` is a contract.
9      *
10      * This test is non-exhaustive, and there may be false-negatives: during the
11      * execution of a contract's constructor, its address will be reported as
12      * not containing a contract.
13      *
14      * > It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      */
17     function isContract(address account) internal view returns (bool) {
18         // This method relies in extcodesize, which returns 0 for contracts in
19         // construction, since the code is only stored at the end of the
20         // constructor execution.
21 
22         uint256 size;
23         // solhint-disable-next-line no-inline-assembly
24         assembly { size := extcodesize(account) }
25         return size > 0;
26     }
27 }
28 
29 /**
30  * @title SafeERC20
31  * @dev Wrappers around ERC20 operations that throw on failure (when the token
32  * contract returns false). Tokens that return no value (and instead revert or
33  * throw on failure) are also supported, non-reverting calls are assumed to be
34  * successful.
35  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
36  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
37  */
38 library SafeERC20 {
39     using SafeMath for uint256;
40     using Address for address;
41 
42     function safeTransfer(IERC20 token, address to, uint256 value) internal {
43         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
44     }
45 
46     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
47         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
48     }
49 
50     function safeApprove(IERC20 token, address spender, uint256 value) internal {
51         // safeApprove should only be called when setting an initial allowance,
52         // or when resetting it to zero. To increase and decrease it, use
53         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
54         // solhint-disable-next-line max-line-length
55         require((value == 0) || (token.allowance(address(this), spender) == 0),
56             "SafeERC20: approve from non-zero to non-zero allowance"
57         );
58         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
59     }
60 
61     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
62         uint256 newAllowance = token.allowance(address(this), spender).add(value);
63         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
64     }
65 
66     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
67         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
68         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
69     }
70 
71     /**
72      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
73      * on the return value: the return value is optional (but if data is returned, it must not be false).
74      * @param token The token targeted by the call.
75      * @param data The call data (encoded using abi.encode or one of its variants).
76      */
77     function callOptionalReturn(IERC20 token, bytes memory data) private {
78         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
79         // we're implementing it ourselves.
80 
81         // A Solidity high level call has three parts:
82         //  1. The target address is checked to verify it contains contract code
83         //  2. The call itself is made, and success asserted
84         //  3. The return value is decoded, which in turn checks the size of the returned data.
85         // solhint-disable-next-line max-line-length
86         require(address(token).isContract(), "SafeERC20: call to non-contract");
87 
88         // solhint-disable-next-line avoid-low-level-calls
89         (bool success, bytes memory returndata) = address(token).call(data);
90         require(success, "SafeERC20: low-level call failed");
91 
92         if (returndata.length > 0) { // Return data is optional
93             // solhint-disable-next-line max-line-length
94             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
95         }
96     }
97 }
98 
99 
100 /**
101  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
102  * the optional functions; to access them see `ERC20Detailed`.
103  */
104 interface IERC20 {
105     /**
106      * @dev Returns the amount of tokens in existence.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     /**
111      * @dev Returns the amount of tokens owned by `account`.
112      */
113     function balanceOf(address account) external view returns (uint256);
114 
115     /**
116      * @dev Moves `amount` tokens from the caller's account to `recipient`.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * Emits a `Transfer` event.
121      */
122     function transfer(address recipient, uint256 amount) external returns (bool);
123 
124     /**
125      * @dev Returns the remaining number of tokens that `spender` will be
126      * allowed to spend on behalf of `owner` through `transferFrom`. This is
127      * zero by default.
128      *
129      * This value changes when `approve` or `transferFrom` are called.
130      */
131     function allowance(address owner, address spender) external view returns (uint256);
132 
133     /**
134      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * > Beware that changing an allowance with this method brings the risk
139      * that someone may use both the old and the new allowance by unfortunate
140      * transaction ordering. One possible solution to mitigate this race
141      * condition is to first reduce the spender's allowance to 0 and set the
142      * desired value afterwards:
143      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144      *
145      * Emits an `Approval` event.
146      */
147     function approve(address spender, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Moves `amount` tokens from `sender` to `recipient` using the
151      * allowance mechanism. `amount` is then deducted from the caller's
152      * allowance.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a `Transfer` event.
157      */
158     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Emitted when `value` tokens are moved from one account (`from`) to
162      * another (`to`).
163      *
164      * Note that `value` may be zero.
165      */
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     /**
169      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
170      * a call to `approve`. `value` is the new allowance.
171      */
172     event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 
176 /**
177  * @dev Wrappers over Solidity's arithmetic operations with added overflow
178  * checks.
179  *
180  * Arithmetic operations in Solidity wrap on overflow. This can easily result
181  * in bugs, because programmers usually assume that an overflow raises an
182  * error, which is the standard behavior in high level programming languages.
183  * `SafeMath` restores this intuition by reverting the transaction when an
184  * operation overflows.
185  *
186  * Using this library instead of the unchecked operations eliminates an entire
187  * class of bugs, so it's recommended to use it always.
188  */
189 library SafeMath {
190     /**
191      * @dev Returns the addition of two unsigned integers, reverting on
192      * overflow.
193      *
194      * Counterpart to Solidity's `+` operator.
195      *
196      * Requirements:
197      * - Addition cannot overflow.
198      */
199     function add(uint256 a, uint256 b) internal pure returns (uint256) {
200         uint256 c = a + b;
201         require(c >= a, "SafeMath: addition overflow");
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the subtraction of two unsigned integers, reverting on
208      * overflow (when the result is negative).
209      *
210      * Counterpart to Solidity's `-` operator.
211      *
212      * Requirements:
213      * - Subtraction cannot overflow.
214      */
215     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
216         require(b <= a, "SafeMath: subtraction overflow");
217         uint256 c = a - b;
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the multiplication of two unsigned integers, reverting on
224      * overflow.
225      *
226      * Counterpart to Solidity's `*` operator.
227      *
228      * Requirements:
229      * - Multiplication cannot overflow.
230      */
231     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
232         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
233         // benefit is lost if 'b' is also tested.
234         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
235         if (a == 0) {
236             return 0;
237         }
238 
239         uint256 c = a * b;
240         require(c / a == b, "SafeMath: multiplication overflow");
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the integer division of two unsigned integers. Reverts on
247      * division by zero. The result is rounded towards zero.
248      *
249      * Counterpart to Solidity's `/` operator. Note: this function uses a
250      * `revert` opcode (which leaves remaining gas untouched) while Solidity
251      * uses an invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      * - The divisor cannot be zero.
255      */
256     function div(uint256 a, uint256 b) internal pure returns (uint256) {
257         // Solidity only automatically asserts when dividing by 0
258         require(b > 0, "SafeMath: division by zero");
259         uint256 c = a / b;
260         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
261 
262         return c;
263     }
264 
265     /**
266      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
267      * Reverts when dividing by zero.
268      *
269      * Counterpart to Solidity's `%` operator. This function uses a `revert`
270      * opcode (which leaves remaining gas untouched) while Solidity uses an
271      * invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      * - The divisor cannot be zero.
275      */
276     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
277         require(b != 0, "SafeMath: modulo by zero");
278         return a % b;
279     }
280 }
281 
282 /**
283  * @dev Contract module which provides a basic access control mechanism, where
284  * there is an account (an owner) that can be granted exclusive access to
285  * specific functions.
286  *
287  * This module is used through inheritance. It will make available the modifier
288  * `onlyOwner`, which can be aplied to your functions to restrict their use to
289  * the owner.
290  */
291 contract Ownable {
292     address private _owner;
293 
294     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
295 
296     /**
297      * @dev Initializes the contract setting the deployer as the initial owner.
298      */
299     constructor () internal {
300         _owner = msg.sender;
301         emit OwnershipTransferred(address(0), _owner);
302     }
303 
304     /**
305      * @dev Returns the address of the current owner.
306      */
307     function owner() public view returns (address) {
308         return _owner;
309     }
310 
311     /**
312      * @dev Throws if called by any account other than the owner.
313      */
314     modifier onlyOwner() {
315         require(isOwner(), "Ownable: caller is not the owner");
316         _;
317     }
318 
319     /**
320      * @dev Returns true if the caller is the current owner.
321      */
322     function isOwner() public view returns (bool) {
323         return msg.sender == _owner;
324     }
325 
326     /**
327      * @dev Leaves the contract without owner. It will not be possible to call
328      * `onlyOwner` functions anymore. Can only be called by the current owner.
329      *
330      * > Note: Renouncing ownership will leave the contract without an owner,
331      * thereby removing any functionality that is only available to the owner.
332      */
333     function renounceOwnership() public onlyOwner {
334         emit OwnershipTransferred(_owner, address(0));
335         _owner = address(0);
336     }
337 
338     /**
339      * @dev Transfers ownership of the contract to a new account (`newOwner`).
340      * Can only be called by the current owner.
341      */
342     function transferOwnership(address newOwner) public onlyOwner {
343         _transferOwnership(newOwner);
344     }
345 
346     /**
347      * @dev Transfers ownership of the contract to a new account (`newOwner`).
348      */
349     function _transferOwnership(address newOwner) internal {
350         require(newOwner != address(0), "Ownable: new owner is the zero address");
351         emit OwnershipTransferred(_owner, newOwner);
352         _owner = newOwner;
353     }
354 }
355 
356 
357 
358 /**
359  * @dev Implementation of the `IERC20` interface.
360  *
361  * This implementation is agnostic to the way tokens are created. This means
362  * that a supply mechanism has to be added in a derived contract using `_mint`.
363  * For a generic mechanism see `ERC20Mintable`.
364  *
365  * *For a detailed writeup see our guide [How to implement supply
366  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
367  *
368  * We have followed general OpenZeppelin guidelines: functions revert instead
369  * of returning `false` on failure. This behavior is nonetheless conventional
370  * and does not conflict with the expectations of ERC20 applications.
371  *
372  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
373  * This allows applications to reconstruct the allowance for all accounts just
374  * by listening to said events. Other implementations of the EIP may not emit
375  * these events, as it isn't required by the specification.
376  *
377  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
378  * functions have been added to mitigate the well-known issues around setting
379  * allowances. See `IERC20.approve`.
380  */
381 contract ERC20 is IERC20 {
382     using SafeMath for uint256;
383 
384     mapping (address => uint256) private _balances;
385 
386     mapping (address => mapping (address => uint256)) private _allowances;
387 
388     uint256 private _totalSupply;
389 
390     /**
391      * @dev See `IERC20.totalSupply`.
392      */
393     function totalSupply() public view returns (uint256) {
394         return _totalSupply;
395     }
396 
397     /**
398      * @dev See `IERC20.balanceOf`.
399      */
400     function balanceOf(address account) public view returns (uint256) {
401         return _balances[account];
402     }
403 
404     /**
405      * @dev See `IERC20.transfer`.
406      *
407      * Requirements:
408      *
409      * - `recipient` cannot be the zero address.
410      * - the caller must have a balance of at least `amount`.
411      */
412     function transfer(address recipient, uint256 amount) public returns (bool) {
413         _transfer(msg.sender, recipient, amount);
414         return true;
415     }
416 
417     /**
418      * @dev See `IERC20.allowance`.
419      */
420     function allowance(address owner, address spender) public view returns (uint256) {
421         return _allowances[owner][spender];
422     }
423 
424     /**
425      * @dev See `IERC20.approve`.
426      *
427      * Requirements:
428      *
429      * - `spender` cannot be the zero address.
430      */
431     function approve(address spender, uint256 value) public returns (bool) {
432         _approve(msg.sender, spender, value);
433         return true;
434     }
435 
436     /**
437      * @dev See `IERC20.transferFrom`.
438      *
439      * Emits an `Approval` event indicating the updated allowance. This is not
440      * required by the EIP. See the note at the beginning of `ERC20`;
441      *
442      * Requirements:
443      * - `sender` and `recipient` cannot be the zero address.
444      * - `sender` must have a balance of at least `value`.
445      * - the caller must have allowance for `sender`'s tokens of at least
446      * `amount`.
447      */
448     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
449         _transfer(sender, recipient, amount);
450         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
451         return true;
452     }
453 
454     /**
455      * @dev Atomically increases the allowance granted to `spender` by the caller.
456      *
457      * This is an alternative to `approve` that can be used as a mitigation for
458      * problems described in `IERC20.approve`.
459      *
460      * Emits an `Approval` event indicating the updated allowance.
461      *
462      * Requirements:
463      *
464      * - `spender` cannot be the zero address.
465      */
466     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
467         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
468         return true;
469     }
470 
471     /**
472      * @dev Atomically decreases the allowance granted to `spender` by the caller.
473      *
474      * This is an alternative to `approve` that can be used as a mitigation for
475      * problems described in `IERC20.approve`.
476      *
477      * Emits an `Approval` event indicating the updated allowance.
478      *
479      * Requirements:
480      *
481      * - `spender` cannot be the zero address.
482      * - `spender` must have allowance for the caller of at least
483      * `subtractedValue`.
484      */
485     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
486         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
487         return true;
488     }
489 
490     /**
491      * @dev Moves tokens `amount` from `sender` to `recipient`.
492      *
493      * This is internal function is equivalent to `transfer`, and can be used to
494      * e.g. implement automatic token fees, slashing mechanisms, etc.
495      *
496      * Emits a `Transfer` event.
497      *
498      * Requirements:
499      *
500      * - `sender` cannot be the zero address.
501      * - `recipient` cannot be the zero address.
502      * - `sender` must have a balance of at least `amount`.
503      */
504     function _transfer(address sender, address recipient, uint256 amount) internal {
505         require(sender != address(0), "ERC20: transfer from the zero address");
506         require(recipient != address(0), "ERC20: transfer to the zero address");
507 
508         _balances[sender] = _balances[sender].sub(amount);
509         _balances[recipient] = _balances[recipient].add(amount);
510         emit Transfer(sender, recipient, amount);
511     }
512 
513     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
514      * the total supply.
515      *
516      * Emits a `Transfer` event with `from` set to the zero address.
517      *
518      * Requirements
519      *
520      * - `to` cannot be the zero address.
521      */
522     function _mint(address account, uint256 amount) internal {
523         require(account != address(0), "ERC20: mint to the zero address");
524 
525         _totalSupply = _totalSupply.add(amount);
526         _balances[account] = _balances[account].add(amount);
527         emit Transfer(address(0), account, amount);
528     }
529 
530      /**
531      * @dev Destoys `amount` tokens from `account`, reducing the
532      * total supply.
533      *
534      * Emits a `Transfer` event with `to` set to the zero address.
535      *
536      * Requirements
537      *
538      * - `account` cannot be the zero address.
539      * - `account` must have at least `amount` tokens.
540      */
541     function _burn(address account, uint256 value) internal {
542         require(account != address(0), "ERC20: burn from the zero address");
543 
544         _totalSupply = _totalSupply.sub(value);
545         _balances[account] = _balances[account].sub(value);
546         emit Transfer(account, address(0), value);
547     }
548 
549     /**
550      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
551      *
552      * This is internal function is equivalent to `approve`, and can be used to
553      * e.g. set automatic allowances for certain subsystems, etc.
554      *
555      * Emits an `Approval` event.
556      *
557      * Requirements:
558      *
559      * - `owner` cannot be the zero address.
560      * - `spender` cannot be the zero address.
561      */
562     function _approve(address owner, address spender, uint256 value) internal {
563         require(owner != address(0), "ERC20: approve from the zero address");
564         require(spender != address(0), "ERC20: approve to the zero address");
565 
566         _allowances[owner][spender] = value;
567         emit Approval(owner, spender, value);
568     }
569 
570     /**
571      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
572      * from the caller's allowance.
573      *
574      * See `_burn` and `_approve`.
575      */
576     function _burnFrom(address account, uint256 amount) internal {
577         _burn(account, amount);
578         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
579     }
580 }
581 
582 
583 /**
584  * @dev Optional functions from the ERC20 standard.
585  */
586 contract ERC20Detailed is IERC20 {
587     string private _name;
588     string private _symbol;
589     uint8 private _decimals;
590 
591     /**
592      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
593      * these values are immutable: they can only be set once during
594      * construction.
595      */
596     constructor (string memory name, string memory symbol, uint8 decimals) public {
597         _name = name;
598         _symbol = symbol;
599         _decimals = decimals;
600     }
601 
602     /**
603      * @dev Returns the name of the token.
604      */
605     function name() public view returns (string memory) {
606         return _name;
607     }
608 
609     /**
610      * @dev Returns the symbol of the token, usually a shorter version of the
611      * name.
612      */
613     function symbol() public view returns (string memory) {
614         return _symbol;
615     }
616 
617     /**
618      * @dev Returns the number of decimals used to get its user representation.
619      * For example, if `decimals` equals `2`, a balance of `505` tokens should
620      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
621      *
622      * Tokens usually opt for a value of 18, imitating the relationship between
623      * Ether and Wei.
624      *
625      * > Note that this information is only used for _display_ purposes: it in
626      * no way affects any of the arithmetic of the contract, including
627      * `IERC20.balanceOf` and `IERC20.transfer`.
628      */
629     function decimals() public view returns (uint8) {
630         return _decimals;
631     }
632 }
633 
634 
635 // @contract Math library for known rounding properties of mul and div, and simulating DSS Pot functionality
636 // @notice Credit https://github.com/dapphub/chai
637 contract ChaiMath {
638     // --- Math ---
639     uint256 constant RAY = 10**27;
640     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
641         require((z = x + y) >= x, 'math/add-overflow');
642     }
643     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
644         require((z = x - y) <= x, 'math/sub-overflow');
645     }
646     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
647         require(y == 0 || (z = x * y) / y == x, 'math/mul-overflow');
648     }
649     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
650         // always rounds down
651         z = mul(x, y) / RAY;
652     }
653     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
654         // always rounds down
655         z = mul(x, RAY) / y;
656     }
657     function rdivup(uint256 x, uint256 y) internal pure returns (uint256 z) {
658         // always rounds up
659         z = add(mul(x, RAY), sub(y, 1)) / y;
660     }
661 
662     // prettier-ignore
663     function rpow(uint x, uint n, uint base) internal pure returns (uint z) {
664         assembly {
665             switch x case 0 {switch n case 0 {z := base} default {z := 0}}
666             default {
667                 switch mod(n, 2) case 0 { z := base } default { z := x }
668                 let half := div(base, 2)  // for rounding.
669                 for { n := div(n, 2) } n { n := div(n,2) } {
670                 let xx := mul(x, x)
671                 if iszero(eq(div(xx, x), x)) { revert(0,0) }
672                 let xxRound := add(xx, half)
673                 if lt(xxRound, xx) { revert(0,0) }
674                 x := div(xxRound, base)
675                 if mod(n,2) {
676                     let zx := mul(z, x)
677                     if and(iszero(iszero(x)), iszero(eq(div(zx, x), z))) { revert(0,0) }
678                     let zxRound := add(zx, half)
679                     if lt(zxRound, zx) { revert(0,0) }
680                     z := div(zxRound, base)
681                 }
682             }
683             }
684         }
685     }
686 }
687 
688 contract GemLike {
689     function approve(address, uint256) public;
690     function transfer(address, uint256) public;
691     function transferFrom(address, address, uint256) public;
692     function deposit() public payable;
693     function withdraw(uint256) public;
694 }
695 
696 contract DaiJoinLike {
697     function vat() public returns (VatLike);
698     function dai() public returns (GemLike);
699     function join(address, uint256) public payable;
700     function exit(address, uint256) public;
701 }
702 
703 contract PotLike {
704     function pie(address) public view returns (uint256);
705     function drip() public returns (uint256);
706     function join(uint256) public;
707     function exit(uint256) public;
708     function rho() public view returns (uint256);
709     function dsr() public view returns (uint256);
710     function chi() public view returns (uint256);
711 }
712 
713 contract VatLike {
714     function can(address, address) public view returns (uint256);
715     function ilks(bytes32) public view returns (uint256, uint256, uint256, uint256, uint256);
716     function dai(address) public view returns (uint256);
717     function urns(bytes32, address) public view returns (uint256, uint256);
718     function hope(address) public;
719     function move(address, address, uint256) public;
720 }
721 
722 /*
723 
724   Copyright DeversiFi Inc 2019
725 
726   Licensed under the Apache License, Version 2.0
727   http://www.apache.org/licenses/LICENSE-2.0
728 
729 */
730 
731 contract WrapperDai is ERC20, ERC20Detailed, Ownable, ChaiMath {
732     using SafeERC20 for IERC20;
733     using SafeMath for uint256;
734 
735     address public TRANSFER_PROXY_V2 = 0x95E6F48254609A6ee006F7D493c8e5fB97094ceF;
736     address public daiJoin;
737     address public pot;
738     address public vat;
739     mapping(address => bool) public isSigner;
740 
741     address public originalToken;
742     uint256 public interestFee;
743 
744     uint256 public constant MAX_PERCENTAGE = 100;
745 
746     mapping(address => uint256) public depositLock;
747     mapping(address => uint256) public deposited;
748     mapping(address => uint256) public pieBalances;
749     uint256 public totalPie;
750 
751     event InterestFeeSet(uint256 interestFee);
752     event ExitExcessPie(uint256 pie);
753     event WithdrawVatBalance(uint256 rad);
754 
755     event TransferPie(address indexed from, address indexed to, uint256 pie);
756 
757     event Deposit(address indexed sender, uint256 value, uint256 pie);
758     event Withdraw(address indexed sender, uint256 pie, uint256 exitWad);
759 
760     constructor(
761         address _originalToken,
762         string memory name,
763         string memory symbol,
764         uint8 decimals,
765         uint256 _interestFee,
766         address _daiJoin,
767         address _daiPot
768     ) public Ownable() ERC20Detailed(name, symbol, decimals) {
769         require(_interestFee <= MAX_PERCENTAGE);
770 
771         originalToken = _originalToken;
772         interestFee = _interestFee;
773         daiJoin = _daiJoin;
774         pot = _daiPot;
775         vat = address(DaiJoinLike(daiJoin).vat());
776 
777         // Approves the pot to take out DAI from the proxy's balance in the vat
778         VatLike(vat).hope(daiJoin);
779 
780         // Allows adapter to access to proxy's DAI balance in the vat
781         VatLike(vat).hope(pot);
782 
783         // Allows adapter to access proxy's DAI balance in the token
784         IERC20(originalToken).approve(address(daiJoin), uint256(-1));
785 
786         isSigner[msg.sender] = true;
787 
788         emit InterestFeeSet(interestFee);
789     }
790 
791     // @notice Get the true value of dai claimable by an account, factoring in the interest split
792     // @param _account Account to check
793     function dai(address _account) external view returns (uint256) {
794         return _dai(_account, _simulateChi());
795     }
796 
797     // @notice Get the true value of dai claimable by an account, factoring in the interest split
798     // @dev Overrides usual ERC20 balanceOf() to show true claimable balance across wallets and dApps
799     // @param account Account to check
800     function balanceOf(address account) public view returns (uint256) {
801         return _dai(account, _simulateChi());
802     }
803 
804     // @notice Get the true value of dai claimable by an account, factoring in the interest split
805     // @param _account Account to check
806     function _dai(address _account, uint _chi) internal view returns (uint256) {
807         if (pieBalances[_account] == 0) {
808             return 0;
809         }
810 
811         uint256 principalPlusInterest = rmul(_chi, pieBalances[_account]);
812         uint256 principal = deposited[_account];
813 
814         uint256 interest;
815         uint256 interestToExchange;
816         uint256 interestToUser;
817 
818         if (principalPlusInterest >= principal) {
819             interest = sub(principalPlusInterest, principal);
820             interestToExchange = mul(interest, interestFee) / MAX_PERCENTAGE;
821             interestToUser = interest - interestToExchange;
822         } else {
823             interest = sub(principal, principalPlusInterest);
824             interestToUser = 0;
825         }
826 
827         return add(principal, interestToUser);
828     }
829 
830     // @dev Update chi via drip if necessary. Simulated version for view calls
831     function _simulateChi() internal view returns (uint) {
832         return (now > PotLike(pot).rho()) ? _simulateDrip() : PotLike(pot).chi();
833     }
834 
835     // @dev Update chi via drip if necessary
836     function _getChi() internal returns (uint) {
837         return (now > PotLike(pot).rho()) ? PotLike(pot).drip() : PotLike(pot).chi();
838     }
839 
840     // @dev Non-stateful copy of pot.drip() for view functions
841     function _simulateDrip() internal view returns (uint256 tmp) {
842         uint256 dsr = PotLike(pot).dsr();
843         uint256 chi = PotLike(pot).chi();
844         uint256 rho = PotLike(pot).rho();
845         tmp = rmul(rpow(dsr, now - rho, RAY), chi);
846     }
847 
848     // @dev Transfer original token from the user, deposit them in DSR to get interest, and give the user wrapped tokens
849     function deposit(uint256 _value, uint256 _forTime) external returns (bool success) {
850         require(_forTime >= 1);
851         require(now + _forTime * 1 hours >= depositLock[msg.sender]);
852         depositLock[msg.sender] = now + _forTime * 1 hours;
853 
854         _deposit(_value);
855         return true;
856     }
857 
858     function _deposit(uint256 _value) internal returns (bool success) {
859         uint256 chi = _getChi();
860         uint256 pie = rdiv(_value, chi);
861         _mintPie(msg.sender, pie);
862         deposited[msg.sender] = add(deposited[msg.sender], _value);
863 
864         IERC20(originalToken).transferFrom(msg.sender, address(this), _value);
865 
866         DaiJoinLike(daiJoin).join(address(this), _value);
867 
868         PotLike(pot).join(pie);
869         emit Deposit(msg.sender, _value, pie);
870         return true;
871     }
872 
873     // @dev Send WRAP to withdraw their normalized value in DAI
874     function withdraw(
875         uint256 _value,
876         uint8 v,
877         bytes32 r,
878         bytes32 s,
879         uint256 signatureValidUntilBlock
880     ) external returns (bool success) {
881         // If we're not past the deposit lock time, we have to check signature
882         if (depositLock[msg.sender] >= now) {
883             require(block.number < signatureValidUntilBlock);
884             require(
885                 isValidSignature(
886                     keccak256(
887                         abi.encodePacked(msg.sender, address(this), signatureValidUntilBlock)
888                     ),
889                     v,
890                     r,
891                     s
892                 ),
893                 'signature'
894             );
895             depositLock[msg.sender] = 0;
896         }
897 
898         uint256 startPie = pieBalances[msg.sender];
899         uint256 chi = _getChi();
900         uint256 pie = rdivup(_value, chi);
901         uint256 pieToLose;
902         uint256 valueToLose;
903 
904         uint256 trueDai = _dai(msg.sender, chi);
905         pieToLose = mul(startPie, _value) / trueDai;
906         valueToLose = mul(deposited[msg.sender], pieToLose) / startPie;
907 
908         _burnPie(msg.sender, pieToLose);
909         deposited[msg.sender] = sub(deposited[msg.sender], valueToLose);
910         return _withdrawPie(pie);
911     }
912 
913     //@ dev PIE denominated withdraw
914     function _withdrawPie(uint256 _pie) internal returns (bool success) {
915         uint256 chi = (now > PotLike(pot).rho()) ? PotLike(pot).drip() : PotLike(pot).chi();
916         PotLike(pot).exit(_pie);
917 
918         // Rounding Safeguard: Checks the actual balance of DAI in the vat after the pot exit
919         // If our expected exit is less than the actual balance, withdraw that instead
920         uint256 actualBal = VatLike(vat).dai(address(this)) / RAY;
921         uint256 expectedOut = rmul(chi, _pie);
922         uint256 toExit = expectedOut > actualBal ? actualBal : expectedOut;
923 
924         DaiJoinLike(daiJoin).exit(msg.sender, toExit);
925         emit Withdraw(msg.sender, _pie, toExit);
926         return true;
927     }
928 
929     // @dev Admin function to 'gulp' excess tokens that were sent to this address, for the wrapped token
930     // @dev The wrapped token doesn't store balances anymore - that DAI is sent from the user to the proxy, converted to vat balance (burned in the process), and deposited in the pot on behalf of the proxy.
931     // @dev So, we can safely assume any dai tokens sent here are withdrawable.
932     function withdrawBalanceDifference() external onlyOwner returns (bool success) {
933         uint256 bal = IERC20(originalToken).balanceOf(address(this));
934         require(bal > 0);
935         IERC20(originalToken).safeTransfer(msg.sender, bal);
936         return true;
937     }
938 
939     // @dev Admin function to 'gulp' excess tokens that were sent to this address, for any token other than the wrapped
940     function withdrawDifferentToken(address _differentToken) external onlyOwner returns (bool) {
941         require(_differentToken != originalToken);
942         require(IERC20(_differentToken).balanceOf(address(this)) > 0);
943         IERC20(_differentToken).safeTransfer(
944             msg.sender,
945             IERC20(_differentToken).balanceOf(address(this))
946         );
947         return true;
948     }
949 
950     // @dev Admin function to withdraw excess vat balance to Owner
951     // @dev Excess vat balance is accumulated due to precision loss when converting RAD -> WAD. This resulting 'VAT Dust' means an extremely minor increase in the % of interest accumulated by the Wrapper vs User.
952     // @dev Vat is also accumulated by exiting excess Pie
953     // @param _rad Balance to withdraw, in Rads
954 
955     function withdrawVatBalance(uint256 _rad) public onlyOwner returns (bool) {
956         VatLike(vat).move(address(this), owner(), _rad);
957         emit WithdrawVatBalance(_rad);
958         return true;
959     }
960 
961     // @notice Owner claims interest portion accumulated by exchange
962     // @dev The wrapper accumulates pie in the Pot during interest resolution in the withdraw and transferFrom functions
963     // @dev Convert the Pie to Vat, which can then be interacted with via withdrawVatBalance()
964     // @returns bool success
965     function exitExcessPie() external onlyOwner returns (bool) {
966         uint256 truePie = PotLike(pot).pie(address(this));
967         uint256 excessPie = sub(truePie, totalPie);
968 
969         uint256 chi = (now > PotLike(pot).rho()) ? PotLike(pot).drip() : PotLike(pot).chi();
970         PotLike(pot).exit(excessPie);
971 
972         emit ExitExcessPie(excessPie);
973         return true;
974     }
975 
976     // @dev Admin function to change interestFee for future calculations
977     function setInterestFee(uint256 _interestFee) external onlyOwner returns (bool) {
978         require(_interestFee <= MAX_PERCENTAGE);
979 
980         interestFee = _interestFee;
981 
982         emit InterestFeeSet(interestFee);
983         return true;
984     }
985 
986     // @dev Override from ERC20 - We don't allow the users to transfer their wrapped tokens directly
987     function transfer(address _to, uint256 _value) public returns (bool) {
988         return false;
989     }
990 
991     // @dev Override from  ERC20: We don't allow the users to transfer their wrapped tokens directly
992     // @dev DAI denominated transferFrom
993     function transferFrom(address _from, address _to, uint256 _value)
994     public
995     returns (bool success)
996     {
997         require(isSigner[_to] || isSigner[_from]);
998         assert(msg.sender == TRANSFER_PROXY_V2);
999 
1000         uint256 startPie = pieBalances[_from];
1001         uint256 chi = _getChi();
1002         uint256 pie = rdivup(_value, chi);
1003         uint256 pieToLose;
1004         uint256 valueToLose;
1005 
1006         uint256 trueDai = _dai(_from, chi);
1007         pieToLose = mul(startPie, _value) / trueDai;
1008         valueToLose = mul(deposited[_from], pieToLose) / startPie;
1009 
1010         _burnPie(_from, pieToLose);
1011         deposited[_from] = sub(deposited[_from], valueToLose);
1012 
1013         _mintPie(_to, pie);
1014         deposited[_to] = add(deposited[_to], _value);
1015 
1016         emit Transfer(_from, _to, _value);
1017 
1018         return true;
1019     }
1020 
1021     // @dev Allowances can only be set with the TransferProxy as the spender, meaning only it can use transferFrom
1022     function allowance(address _owner, address _spender) public view returns (uint256) {
1023         if (_spender == TRANSFER_PROXY_V2) {
1024             return 2**256 - 1;
1025         } else {
1026             return 0;
1027         }
1028     }
1029 
1030     function _mintPie(address account, uint256 amount) internal {
1031         require(account != address(0), "ERC20: mint to the zero address");
1032 
1033         totalPie = totalPie.add(amount);
1034         pieBalances[account] = pieBalances[account].add(amount);
1035         emit TransferPie(address(0), account, amount);
1036     }
1037 
1038     function _burnPie(address account, uint256 value) internal {
1039         require(account != address(0), "ERC20: burn from the zero address");
1040 
1041         totalPie = totalPie.sub(value);
1042         pieBalances[account] = pieBalances[account].sub(value);
1043         emit TransferPie(account, address(0), value);
1044     }
1045 
1046     function isValidSignature(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
1047     public
1048     view
1049     returns (bool)
1050     {
1051         return
1052         isSigner[ecrecover(
1053             keccak256(abi.encodePacked('\x19Ethereum Signed Message:\n32', hash)),
1054             v,
1055             r,
1056             s
1057         )];
1058 
1059     }
1060 
1061     // @dev Existing signers can add new signers
1062     function addSigner(address _newSigner) public {
1063         require(isSigner[msg.sender]);
1064         isSigner[_newSigner] = true;
1065     }
1066 
1067     function keccak(address _sender, address _wrapper, uint256 _validTill)
1068     public
1069     pure
1070     returns (bytes32)
1071     {
1072         return keccak256(abi.encodePacked(_sender, _wrapper, _validTill));
1073     }
1074 }