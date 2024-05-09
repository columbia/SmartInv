1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
7  * the optional functions; to access them see `ERC20Detailed`.
8  */
9 interface IERC20 {
10     /**
11      * @dev Returns the amount of tokens in existence.
12      */
13     function totalSupply() external view returns (uint256);
14 
15     /**
16      * @dev Returns the amount of tokens owned by `account`.
17      */
18     function balanceOf(address account) external view returns (uint256);
19 
20     /**
21      * @dev Moves `amount` tokens from the caller's account to `recipient`.
22      *
23      * Returns a boolean value indicating whether the operation succeeded.
24      *
25      * Emits a `Transfer` event.
26      */
27     function transfer(address recipient, uint256 amount) external returns (bool);
28 
29     /**
30      * @dev Returns the remaining number of tokens that `spender` will be
31      * allowed to spend on behalf of `owner` through `transferFrom`. This is
32      * zero by default.
33      *
34      * This value changes when `approve` or `transferFrom` are called.
35      */
36     function allowance(address owner, address spender) external view returns (uint256);
37 
38     /**
39      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * > Beware that changing an allowance with this method brings the risk
44      * that someone may use both the old and the new allowance by unfortunate
45      * transaction ordering. One possible solution to mitigate this race
46      * condition is to first reduce the spender's allowance to 0 and set the
47      * desired value afterwards:
48      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
49      *
50      * Emits an `Approval` event.
51      */
52     function approve(address spender, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Moves `amount` tokens from `sender` to `recipient` using the
56      * allowance mechanism. `amount` is then deducted from the caller's
57      * allowance.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a `Transfer` event.
62      */
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Emitted when `value` tokens are moved from one account (`from`) to
67      * another (`to`).
68      *
69      * Note that `value` may be zero.
70      */
71     event Transfer(address indexed from, address indexed to, uint256 value);
72 
73     /**
74      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
75      * a call to `approve`. `value` is the new allowance.
76      */
77     event Approval(address indexed owner, address indexed spender, uint256 value);
78 }
79 
80 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
81 
82 pragma solidity ^0.5.0;
83 
84 /**
85  * @dev Wrappers over Solidity's arithmetic operations with added overflow
86  * checks.
87  *
88  * Arithmetic operations in Solidity wrap on overflow. This can easily result
89  * in bugs, because programmers usually assume that an overflow raises an
90  * error, which is the standard behavior in high level programming languages.
91  * `SafeMath` restores this intuition by reverting the transaction when an
92  * operation overflows.
93  *
94  * Using this library instead of the unchecked operations eliminates an entire
95  * class of bugs, so it's recommended to use it always.
96  */
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      * - Subtraction cannot overflow.
122      */
123     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
124         require(b <= a, "SafeMath: subtraction overflow");
125         uint256 c = a - b;
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the multiplication of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `*` operator.
135      *
136      * Requirements:
137      * - Multiplication cannot overflow.
138      */
139     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
140         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
141         // benefit is lost if 'b' is also tested.
142         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the integer division of two unsigned integers. Reverts on
155      * division by zero. The result is rounded towards zero.
156      *
157      * Counterpart to Solidity's `/` operator. Note: this function uses a
158      * `revert` opcode (which leaves remaining gas untouched) while Solidity
159      * uses an invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      * - The divisor cannot be zero.
163      */
164     function div(uint256 a, uint256 b) internal pure returns (uint256) {
165         // Solidity only automatically asserts when dividing by 0
166         require(b > 0, "SafeMath: division by zero");
167         uint256 c = a / b;
168         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
175      * Reverts when dividing by zero.
176      *
177      * Counterpart to Solidity's `%` operator. This function uses a `revert`
178      * opcode (which leaves remaining gas untouched) while Solidity uses an
179      * invalid opcode to revert (consuming all remaining gas).
180      *
181      * Requirements:
182      * - The divisor cannot be zero.
183      */
184     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
185         require(b != 0, "SafeMath: modulo by zero");
186         return a % b;
187     }
188 }
189 
190 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
191 
192 pragma solidity ^0.5.0;
193 
194 
195 
196 /**
197  * @dev Implementation of the `IERC20` interface.
198  *
199  * This implementation is agnostic to the way tokens are created. This means
200  * that a supply mechanism has to be added in a derived contract using `_mint`.
201  * For a generic mechanism see `ERC20Mintable`.
202  *
203  * *For a detailed writeup see our guide [How to implement supply
204  * mechanisms](https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226).*
205  *
206  * We have followed general OpenZeppelin guidelines: functions revert instead
207  * of returning `false` on failure. This behavior is nonetheless conventional
208  * and does not conflict with the expectations of ERC20 applications.
209  *
210  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
211  * This allows applications to reconstruct the allowance for all accounts just
212  * by listening to said events. Other implementations of the EIP may not emit
213  * these events, as it isn't required by the specification.
214  *
215  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
216  * functions have been added to mitigate the well-known issues around setting
217  * allowances. See `IERC20.approve`.
218  */
219 contract ERC20 is IERC20 {
220     using SafeMath for uint256;
221 
222     mapping (address => uint256) private _balances;
223 
224     mapping (address => mapping (address => uint256)) private _allowances;
225 
226     uint256 private _totalSupply;
227 
228     /**
229      * @dev See `IERC20.totalSupply`.
230      */
231     function totalSupply() public view returns (uint256) {
232         return _totalSupply;
233     }
234 
235     /**
236      * @dev See `IERC20.balanceOf`.
237      */
238     function balanceOf(address account) public view returns (uint256) {
239         return _balances[account];
240     }
241 
242     /**
243      * @dev See `IERC20.transfer`.
244      *
245      * Requirements:
246      *
247      * - `recipient` cannot be the zero address.
248      * - the caller must have a balance of at least `amount`.
249      */
250     function transfer(address recipient, uint256 amount) public returns (bool) {
251         _transfer(msg.sender, recipient, amount);
252         return true;
253     }
254 
255     /**
256      * @dev See `IERC20.allowance`.
257      */
258     function allowance(address owner, address spender) public view returns (uint256) {
259         return _allowances[owner][spender];
260     }
261 
262     /**
263      * @dev See `IERC20.approve`.
264      *
265      * Requirements:
266      *
267      * - `spender` cannot be the zero address.
268      */
269     function approve(address spender, uint256 value) public returns (bool) {
270         _approve(msg.sender, spender, value);
271         return true;
272     }
273 
274     /**
275      * @dev See `IERC20.transferFrom`.
276      *
277      * Emits an `Approval` event indicating the updated allowance. This is not
278      * required by the EIP. See the note at the beginning of `ERC20`;
279      *
280      * Requirements:
281      * - `sender` and `recipient` cannot be the zero address.
282      * - `sender` must have a balance of at least `value`.
283      * - the caller must have allowance for `sender`'s tokens of at least
284      * `amount`.
285      */
286     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
287         _transfer(sender, recipient, amount);
288         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
289         return true;
290     }
291 
292     /**
293      * @dev Atomically increases the allowance granted to `spender` by the caller.
294      *
295      * This is an alternative to `approve` that can be used as a mitigation for
296      * problems described in `IERC20.approve`.
297      *
298      * Emits an `Approval` event indicating the updated allowance.
299      *
300      * Requirements:
301      *
302      * - `spender` cannot be the zero address.
303      */
304     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
305         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
306         return true;
307     }
308 
309     /**
310      * @dev Atomically decreases the allowance granted to `spender` by the caller.
311      *
312      * This is an alternative to `approve` that can be used as a mitigation for
313      * problems described in `IERC20.approve`.
314      *
315      * Emits an `Approval` event indicating the updated allowance.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      * - `spender` must have allowance for the caller of at least
321      * `subtractedValue`.
322      */
323     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
324         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
325         return true;
326     }
327 
328     /**
329      * @dev Moves tokens `amount` from `sender` to `recipient`.
330      *
331      * This is internal function is equivalent to `transfer`, and can be used to
332      * e.g. implement automatic token fees, slashing mechanisms, etc.
333      *
334      * Emits a `Transfer` event.
335      *
336      * Requirements:
337      *
338      * - `sender` cannot be the zero address.
339      * - `recipient` cannot be the zero address.
340      * - `sender` must have a balance of at least `amount`.
341      */
342     function _transfer(address sender, address recipient, uint256 amount) internal {
343         require(sender != address(0), "ERC20: transfer from the zero address");
344         require(recipient != address(0), "ERC20: transfer to the zero address");
345 
346         _balances[sender] = _balances[sender].sub(amount);
347         _balances[recipient] = _balances[recipient].add(amount);
348         emit Transfer(sender, recipient, amount);
349     }
350 
351     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
352      * the total supply.
353      *
354      * Emits a `Transfer` event with `from` set to the zero address.
355      *
356      * Requirements
357      *
358      * - `to` cannot be the zero address.
359      */
360     function _mint(address account, uint256 amount) internal {
361         require(account != address(0), "ERC20: mint to the zero address");
362 
363         _totalSupply = _totalSupply.add(amount);
364         _balances[account] = _balances[account].add(amount);
365         emit Transfer(address(0), account, amount);
366     }
367 
368      /**
369      * @dev Destoys `amount` tokens from `account`, reducing the
370      * total supply.
371      *
372      * Emits a `Transfer` event with `to` set to the zero address.
373      *
374      * Requirements
375      *
376      * - `account` cannot be the zero address.
377      * - `account` must have at least `amount` tokens.
378      */
379     function _burn(address account, uint256 value) internal {
380         require(account != address(0), "ERC20: burn from the zero address");
381 
382         _totalSupply = _totalSupply.sub(value);
383         _balances[account] = _balances[account].sub(value);
384         emit Transfer(account, address(0), value);
385     }
386 
387     /**
388      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
389      *
390      * This is internal function is equivalent to `approve`, and can be used to
391      * e.g. set automatic allowances for certain subsystems, etc.
392      *
393      * Emits an `Approval` event.
394      *
395      * Requirements:
396      *
397      * - `owner` cannot be the zero address.
398      * - `spender` cannot be the zero address.
399      */
400     function _approve(address owner, address spender, uint256 value) internal {
401         require(owner != address(0), "ERC20: approve from the zero address");
402         require(spender != address(0), "ERC20: approve to the zero address");
403 
404         _allowances[owner][spender] = value;
405         emit Approval(owner, spender, value);
406     }
407 
408     /**
409      * @dev Destoys `amount` tokens from `account`.`amount` is then deducted
410      * from the caller's allowance.
411      *
412      * See `_burn` and `_approve`.
413      */
414     function _burnFrom(address account, uint256 amount) internal {
415         _burn(account, amount);
416         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
417     }
418 }
419 
420 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Detailed.sol
421 
422 pragma solidity ^0.5.0;
423 
424 
425 /**
426  * @dev Optional functions from the ERC20 standard.
427  */
428 contract ERC20Detailed is IERC20 {
429     string private _name;
430     string private _symbol;
431     uint8 private _decimals;
432 
433     /**
434      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
435      * these values are immutable: they can only be set once during
436      * construction.
437      */
438     constructor (string memory name, string memory symbol, uint8 decimals) public {
439         _name = name;
440         _symbol = symbol;
441         _decimals = decimals;
442     }
443 
444     /**
445      * @dev Returns the name of the token.
446      */
447     function name() public view returns (string memory) {
448         return _name;
449     }
450 
451     /**
452      * @dev Returns the symbol of the token, usually a shorter version of the
453      * name.
454      */
455     function symbol() public view returns (string memory) {
456         return _symbol;
457     }
458 
459     /**
460      * @dev Returns the number of decimals used to get its user representation.
461      * For example, if `decimals` equals `2`, a balance of `505` tokens should
462      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
463      *
464      * Tokens usually opt for a value of 18, imitating the relationship between
465      * Ether and Wei.
466      *
467      * > Note that this information is only used for _display_ purposes: it in
468      * no way affects any of the arithmetic of the contract, including
469      * `IERC20.balanceOf` and `IERC20.transfer`.
470      */
471     function decimals() public view returns (uint8) {
472         return _decimals;
473     }
474 }
475 
476 // File: openzeppelin-solidity/contracts/utils/ReentrancyGuard.sol
477 
478 pragma solidity ^0.5.0;
479 
480 /**
481  * @dev Contract module that helps prevent reentrant calls to a function.
482  *
483  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
484  * available, which can be aplied to functions to make sure there are no nested
485  * (reentrant) calls to them.
486  *
487  * Note that because there is a single `nonReentrant` guard, functions marked as
488  * `nonReentrant` may not call one another. This can be worked around by making
489  * those functions `private`, and then adding `external` `nonReentrant` entry
490  * points to them.
491  */
492 contract ReentrancyGuard {
493     /// @dev counter to allow mutex lock with only one SSTORE operation
494     uint256 private _guardCounter;
495 
496     constructor () internal {
497         // The counter starts at one to prevent changing it from zero to a non-zero
498         // value, which is a more expensive operation.
499         _guardCounter = 1;
500     }
501 
502     /**
503      * @dev Prevents a contract from calling itself, directly or indirectly.
504      * Calling a `nonReentrant` function from another `nonReentrant`
505      * function is not supported. It is possible to prevent this from happening
506      * by making the `nonReentrant` function external, and make it call a
507      * `private` function that does the actual work.
508      */
509     modifier nonReentrant() {
510         _guardCounter += 1;
511         uint256 localCounter = _guardCounter;
512         _;
513         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
514     }
515 }
516 
517 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
518 
519 pragma solidity ^0.5.0;
520 
521 /**
522  * @dev Contract module which provides a basic access control mechanism, where
523  * there is an account (an owner) that can be granted exclusive access to
524  * specific functions.
525  *
526  * This module is used through inheritance. It will make available the modifier
527  * `onlyOwner`, which can be aplied to your functions to restrict their use to
528  * the owner.
529  */
530 contract Ownable {
531     address private _owner;
532 
533     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
534 
535     /**
536      * @dev Initializes the contract setting the deployer as the initial owner.
537      */
538     constructor () internal {
539         _owner = msg.sender;
540         emit OwnershipTransferred(address(0), _owner);
541     }
542 
543     /**
544      * @dev Returns the address of the current owner.
545      */
546     function owner() public view returns (address) {
547         return _owner;
548     }
549 
550     /**
551      * @dev Throws if called by any account other than the owner.
552      */
553     modifier onlyOwner() {
554         require(isOwner(), "Ownable: caller is not the owner");
555         _;
556     }
557 
558     /**
559      * @dev Returns true if the caller is the current owner.
560      */
561     function isOwner() public view returns (bool) {
562         return msg.sender == _owner;
563     }
564 
565     /**
566      * @dev Leaves the contract without owner. It will not be possible to call
567      * `onlyOwner` functions anymore. Can only be called by the current owner.
568      *
569      * > Note: Renouncing ownership will leave the contract without an owner,
570      * thereby removing any functionality that is only available to the owner.
571      */
572     function renounceOwnership() public onlyOwner {
573         emit OwnershipTransferred(_owner, address(0));
574         _owner = address(0);
575     }
576 
577     /**
578      * @dev Transfers ownership of the contract to a new account (`newOwner`).
579      * Can only be called by the current owner.
580      */
581     function transferOwnership(address newOwner) public onlyOwner {
582         _transferOwnership(newOwner);
583     }
584 
585     /**
586      * @dev Transfers ownership of the contract to a new account (`newOwner`).
587      */
588     function _transferOwnership(address newOwner) internal {
589         require(newOwner != address(0), "Ownable: new owner is the zero address");
590         emit OwnershipTransferred(_owner, newOwner);
591         _owner = newOwner;
592     }
593 }
594 
595 // File: openzeppelin-solidity/contracts/utils/Address.sol
596 
597 pragma solidity ^0.5.0;
598 
599 /**
600  * @dev Collection of functions related to the address type,
601  */
602 library Address {
603     /**
604      * @dev Returns true if `account` is a contract.
605      *
606      * This test is non-exhaustive, and there may be false-negatives: during the
607      * execution of a contract's constructor, its address will be reported as
608      * not containing a contract.
609      *
610      * > It is unsafe to assume that an address for which this function returns
611      * false is an externally-owned account (EOA) and not a contract.
612      */
613     function isContract(address account) internal view returns (bool) {
614         // This method relies in extcodesize, which returns 0 for contracts in
615         // construction, since the code is only stored at the end of the
616         // constructor execution.
617 
618         uint256 size;
619         // solhint-disable-next-line no-inline-assembly
620         assembly { size := extcodesize(account) }
621         return size > 0;
622     }
623 }
624 
625 // File: openzeppelin-solidity/contracts/token/ERC20/SafeERC20.sol
626 
627 pragma solidity ^0.5.0;
628 
629 
630 
631 
632 /**
633  * @title SafeERC20
634  * @dev Wrappers around ERC20 operations that throw on failure (when the token
635  * contract returns false). Tokens that return no value (and instead revert or
636  * throw on failure) are also supported, non-reverting calls are assumed to be
637  * successful.
638  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
639  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
640  */
641 library SafeERC20 {
642     using SafeMath for uint256;
643     using Address for address;
644 
645     function safeTransfer(IERC20 token, address to, uint256 value) internal {
646         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
647     }
648 
649     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
650         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
651     }
652 
653     function safeApprove(IERC20 token, address spender, uint256 value) internal {
654         // safeApprove should only be called when setting an initial allowance,
655         // or when resetting it to zero. To increase and decrease it, use
656         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
657         // solhint-disable-next-line max-line-length
658         require((value == 0) || (token.allowance(address(this), spender) == 0),
659             "SafeERC20: approve from non-zero to non-zero allowance"
660         );
661         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
662     }
663 
664     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
665         uint256 newAllowance = token.allowance(address(this), spender).add(value);
666         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
667     }
668 
669     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
670         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
671         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
672     }
673 
674     /**
675      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
676      * on the return value: the return value is optional (but if data is returned, it must not be false).
677      * @param token The token targeted by the call.
678      * @param data The call data (encoded using abi.encode or one of its variants).
679      */
680     function callOptionalReturn(IERC20 token, bytes memory data) private {
681         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
682         // we're implementing it ourselves.
683 
684         // A Solidity high level call has three parts:
685         //  1. The target address is checked to verify it contains contract code
686         //  2. The call itself is made, and success asserted
687         //  3. The return value is decoded, which in turn checks the size of the returned data.
688         // solhint-disable-next-line max-line-length
689         require(address(token).isContract(), "SafeERC20: call to non-contract");
690 
691         // solhint-disable-next-line avoid-low-level-calls
692         (bool success, bytes memory returndata) = address(token).call(data);
693         require(success, "SafeERC20: low-level call failed");
694 
695         if (returndata.length > 0) { // Return data is optional
696             // solhint-disable-next-line max-line-length
697             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
698         }
699     }
700 }
701 
702 // File: contracts/interfaces/CERC20.sol
703 
704 pragma solidity ^0.5.2;
705 
706 interface CERC20 {
707   function mint(uint256 mintAmount) external returns (uint256);
708   function redeem(uint256 redeemTokens) external returns (uint256);
709   function exchangeRateStored() external view returns (uint256);
710   function supplyRatePerBlock() external view returns (uint256);
711 
712   function borrowRatePerBlock() external view returns (uint256);
713   function totalReserves() external view returns (uint256);
714   function getCash() external view returns (uint256);
715   function totalBorrows() external view returns (uint256);
716   function reserveFactorMantissa() external view returns (uint256);
717 }
718 
719 // File: contracts/interfaces/iERC20.sol
720 
721 pragma solidity ^0.5.2;
722 
723 interface iERC20 {
724   function mint(
725     address receiver,
726     uint256 depositAmount)
727     external
728     returns (uint256 mintAmount);
729 
730   function burn(
731     address receiver,
732     uint256 burnAmount)
733     external
734     returns (uint256 loanAmountPaid);
735 
736   function tokenPrice()
737     external
738     view
739     returns (uint256 price);
740 
741   function supplyInterestRate()
742     external
743     view
744     returns (uint256);
745 
746   function rateMultiplier()
747     external
748     view
749     returns (uint256);
750   function baseRate()
751     external
752     view
753     returns (uint256);
754 
755   function borrowInterestRate()
756     external
757     view
758     returns (uint256);
759 
760   function totalAssetBorrow()
761     external
762     view
763     returns (uint256);
764 
765   function totalAssetSupply()
766     external
767     view
768     returns (uint256);
769 
770   function nextSupplyInterestRate(uint256)
771     external
772     view
773     returns (uint256);
774 
775   function nextBorrowInterestRate(uint256)
776     external
777     view
778     returns (uint256);
779   function nextLoanInterestRate(uint256)
780     external
781     view
782     returns (uint256);
783 
784   function claimLoanToken()
785     external
786     returns (uint256 claimedAmount);
787 
788   /* function burnToEther(
789     address receiver,
790     uint256 burnAmount)
791     external
792     returns (uint256 loanAmountPaid);
793 
794 
795   function supplyInterestRate()
796     external
797     view
798     returns (uint256);
799 
800   function assetBalanceOf(
801     address _owner)
802     external
803     view
804     returns (uint256);
805 
806   function claimLoanToken()
807     external
808     returns (uint256 claimedAmount); */
809 }
810 
811 // File: contracts/IdleHelp.sol
812 
813 pragma solidity ^0.5.2;
814 
815 
816 
817 
818 
819 library IdleHelp {
820   using SafeMath for uint256;
821   function getPriceInToken(address cToken, address iToken, address bestToken, uint256 totalSupply, uint256 poolSupply)
822     public view
823     returns (uint256 tokenPrice) {
824       // 1Token = net_asset_value / total_Token_liquidity
825       // net_asset_value = (rate of 1(cToken || iToken) in underlying_Token) * balanceOf((cToken || iToken))
826       uint256 navPool;
827       uint256 price;
828 
829       // rate
830       if (bestToken == cToken) {
831         // exchangeRateStored is the rate (in wei, 8 decimals) of 1cDAI in DAI * 10**18
832         price = CERC20(cToken).exchangeRateStored(); // 202487304197710837666727644 ->
833       } else {
834         price = iERC20(iToken).tokenPrice(); // eg 1001495070730287403 -> 1iToken in wei = 1001495070730287403 Token
835       }
836       navPool = price.mul(poolSupply); // eg 43388429749999990000 in DAI
837       tokenPrice = navPool.div(totalSupply); // idleToken price in token wei
838   }
839   function getAPRs(address cToken, address iToken, uint256 blocksInAYear)
840     public view
841     returns (uint256 cApr, uint256 iApr) {
842       uint256 cRate = CERC20(cToken).supplyRatePerBlock(); // interest % per block
843       cApr = cRate.mul(blocksInAYear).mul(100);
844       iApr = iERC20(iToken).supplyInterestRate(); // APR in wei 18 decimals
845   }
846   function getBestRateToken(address cToken, address iToken, uint256 blocksInAYear)
847     public view
848     returns (address bestRateToken, uint256 bestRate, uint256 worstRate) {
849       (uint256 cApr, uint256 iApr) = getAPRs(cToken, iToken, blocksInAYear);
850       bestRateToken = cToken;
851       bestRate = cApr;
852       worstRate = iApr;
853       if (iApr > cApr) {
854         worstRate = cApr;
855         bestRate = iApr;
856         bestRateToken = iToken;
857       }
858   }
859   function rebalanceCheck(address cToken, address iToken, address bestToken, uint256 blocksInAYear, uint256 minRateDifference)
860     public view
861     returns (bool shouldRebalance, address bestTokenAddr) {
862       shouldRebalance = false;
863 
864       uint256 _bestRate;
865       uint256 _worstRate;
866       (bestTokenAddr, _bestRate, _worstRate) = getBestRateToken(cToken, iToken, blocksInAYear);
867       if (
868           bestToken == address(0) ||
869           (bestTokenAddr != bestToken && (_worstRate.add(minRateDifference) < _bestRate))) {
870         shouldRebalance = true;
871         return (shouldRebalance, bestTokenAddr);
872       }
873 
874       return (shouldRebalance, bestTokenAddr);
875   }
876 }
877 
878 // File: contracts/IdleDAI.sol
879 
880 pragma solidity ^0.5.2;
881 
882 
883 
884 
885 
886 
887 
888 
889 
890 
891 
892 contract IdleDAI is ERC20, ERC20Detailed, ReentrancyGuard, Ownable {
893   using SafeERC20 for IERC20;
894   using SafeMath for uint256;
895 
896   address public cToken; // cTokens have 8 decimals
897   address public iToken; // iTokens have 18 decimals
898   address public token;
899   address public bestToken;
900 
901   uint256 public blocksInAYear;
902   uint256 public minRateDifference;
903 
904   /**
905    * @dev constructor
906    */
907   constructor(address _cToken, address _iToken, address _token)
908     public
909     ERC20Detailed("IdleDAI", "IDLEDAI", 18) {
910       cToken = _cToken;
911       iToken = _iToken;
912       token = _token;
913       blocksInAYear = 2102400; // ~15 sec per block
914       minRateDifference = 100000000000000000; // 0.1% min
915   }
916 
917   // onlyOwner
918   function setMinRateDifference(uint256 _rate)
919     external onlyOwner {
920       minRateDifference = _rate;
921   }
922   function setBlocksInAYear(uint256 _blocks)
923     external onlyOwner {
924       blocksInAYear = _blocks;
925   }
926   function setToken(address _token)
927     external onlyOwner {
928       token = _token;
929   }
930   function setIToken(address _iToken)
931     external onlyOwner {
932       iToken = _iToken;
933   }
934   function setCToken(address _cToken)
935     external onlyOwner {
936       cToken = _cToken;
937   }
938   // This should never be called, only in case of contract failure
939   // after an audit this should be removed
940   function emergencyWithdraw(address _token, uint256 _value)
941     external onlyOwner {
942       IERC20 underlying = IERC20(_token);
943       if (_value != 0) {
944         underlying.safeTransfer(msg.sender, _value);
945       } else {
946         underlying.safeTransfer(msg.sender, underlying.balanceOf(address(this)));
947       }
948   }
949 
950   // view
951   function tokenPrice()
952     public view
953     returns (uint256 price) {
954       uint256 poolSupply = IERC20(cToken).balanceOf(address(this));
955       if (bestToken == iToken) {
956         poolSupply = IERC20(iToken).balanceOf(address(this));
957       }
958 
959       price = IdleHelp.getPriceInToken(
960         cToken,
961         iToken,
962         bestToken,
963         this.totalSupply(),
964         poolSupply
965       );
966   }
967   function rebalanceCheck()
968     public view
969     returns (bool, address) {
970       return IdleHelp.rebalanceCheck(cToken, iToken, bestToken, blocksInAYear, minRateDifference);
971   }
972   function getAPRs()
973     external view
974     returns (uint256, uint256) {
975       return IdleHelp.getAPRs(cToken, iToken, blocksInAYear);
976   }
977 
978   // public
979   /**
980    * @dev User should 'approve' _amount tokens before calling mintIdleToken
981    */
982   function mintIdleToken(uint256 _amount)
983     external nonReentrant
984     returns (uint256 mintedTokens) {
985       require(_amount > 0, "Amount is not > 0");
986 
987       // First rebalance the current pool if needed
988       rebalance();
989 
990       // get a handle for the underlying asset contract
991       IERC20 underlying = IERC20(token);
992       // transfer to this contract
993       underlying.safeTransferFrom(msg.sender, address(this), _amount);
994 
995       uint256 idlePrice = 10**18;
996       uint256 totalSupply = this.totalSupply();
997 
998       if (totalSupply != 0) {
999         idlePrice = tokenPrice();
1000       }
1001 
1002       if (bestToken == cToken) {
1003         _mintCTokens(_amount);
1004       } else {
1005         _mintITokens(_amount);
1006       }
1007       if (totalSupply == 0) {
1008         mintedTokens = _amount; // 1:1
1009       } else {
1010         mintedTokens = _amount.mul(10**18).div(idlePrice);
1011       }
1012       _mint(msg.sender, mintedTokens);
1013   }
1014 
1015   /**
1016    * @dev here we calc the pool share of the cTokens | iTokens one can withdraw
1017    */
1018   function redeemIdleToken(uint256 _amount)
1019     external nonReentrant
1020     returns (uint256 tokensRedeemed) {
1021     uint256 idleSupply = this.totalSupply();
1022     require(idleSupply > 0, 'No IDLEDAI have been issued');
1023 
1024     if (bestToken == cToken) {
1025       uint256 cPoolBalance = IERC20(cToken).balanceOf(address(this));
1026       uint256 cDAItoRedeem = _amount.mul(cPoolBalance).div(idleSupply);
1027       tokensRedeemed = _redeemCTokens(cDAItoRedeem, msg.sender);
1028     } else {
1029       uint256 iPoolBalance = IERC20(iToken).balanceOf(address(this));
1030       uint256 iDAItoRedeem = _amount.mul(iPoolBalance).div(idleSupply);
1031       // TODO we should inform the user of the eventual excess of token that can be redeemed directly in Fulcrum
1032       tokensRedeemed = _redeemITokens(iDAItoRedeem, msg.sender);
1033     }
1034     _burn(msg.sender, _amount);
1035     rebalance();
1036   }
1037 
1038   /**
1039    * @dev Convert cToken pool in iToken pool (or the contrary) if needed
1040    * Everyone should be incentivized in calling this method
1041    */
1042   function rebalance()
1043     public {
1044       (bool shouldRebalance, address newBestTokenAddr) = rebalanceCheck();
1045       if (!shouldRebalance) {
1046         return;
1047       }
1048 
1049       if (bestToken != address(0)) {
1050         // bestToken here is the 'old' best token
1051         if (bestToken == cToken) {
1052           _redeemCTokens(IERC20(cToken).balanceOf(address(this)), address(this)); // token are now in this contract
1053           _mintITokens(IERC20(token).balanceOf(address(this)));
1054         } else {
1055           _redeemITokens(IERC20(iToken).balanceOf(address(this)), address(this));
1056           _mintCTokens(IERC20(token).balanceOf(address(this)));
1057         }
1058       }
1059 
1060       // Update best token address
1061       bestToken = newBestTokenAddr;
1062   }
1063   /**
1064    * @dev here we are redeeming unclaimed token (from iToken contract) to this contracts
1065    * then converting the claimedTokens in the bestToken after rebalancing
1066    * Everyone should be incentivized in calling this method
1067    */
1068   function claimITokens()
1069     external
1070     returns (uint256 claimedTokens) {
1071       claimedTokens = iERC20(iToken).claimLoanToken();
1072       if (claimedTokens == 0) {
1073         return claimedTokens;
1074       }
1075 
1076       rebalance();
1077       if (bestToken == cToken) {
1078         _mintCTokens(claimedTokens);
1079       } else {
1080         _mintITokens(claimedTokens);
1081       }
1082 
1083       return claimedTokens;
1084   }
1085 
1086   // internal
1087   function _mintCTokens(uint256 _amount)
1088     internal
1089     returns (uint256 cTokens) {
1090       if (IERC20(token).balanceOf(address(this)) == 0) {
1091         return cTokens;
1092       }
1093       // approve the transfer to cToken contract
1094       IERC20(token).safeIncreaseAllowance(cToken, _amount);
1095 
1096       // get a handle for the corresponding cToken contract
1097       CERC20 _cToken = CERC20(cToken);
1098       // mint the cTokens and assert there is no error
1099       require(_cToken.mint(_amount) == 0, "Error minting");
1100       // cTokens are now in this contract
1101 
1102       // generic solidity formula is exchangeRateMantissa = (underlying / cTokens) * 1e18
1103       uint256 exchangeRateMantissa = _cToken.exchangeRateStored(); // (exchange_rate * 1e18)
1104       // so cTokens = (underlying * 1e18) / exchangeRateMantissa
1105       cTokens = _amount.mul(10**18).div(exchangeRateMantissa);
1106   }
1107   function _mintITokens(uint256 _amount)
1108     internal
1109     returns (uint256 iTokens) {
1110       if (IERC20(token).balanceOf(address(this)) == 0) {
1111         return iTokens;
1112       }
1113       // approve the transfer to iToken contract
1114       IERC20(token).safeIncreaseAllowance(iToken, _amount);
1115       // get a handle for the corresponding iToken contract
1116       iERC20 _iToken = iERC20(iToken);
1117       // mint the iTokens
1118       iTokens = _iToken.mint(address(this), _amount);
1119   }
1120 
1121   function _redeemCTokens(uint256 _amount, address _account)
1122     internal
1123     returns (uint256 tokens) {
1124       CERC20 _cToken = CERC20(cToken);
1125       // redeem all user's underlying
1126       require(_cToken.redeem(_amount) == 0, "Something went wrong when redeeming in cTokens");
1127 
1128       // generic solidity formula is exchangeRateMantissa = (underlying / cTokens) * 1e18
1129       uint256 exchangeRateMantissa = _cToken.exchangeRateStored(); // exchange_rate * 1e18
1130       // so underlying = (exchangeRateMantissa * cTokens) / 1e18
1131       tokens = _amount.mul(exchangeRateMantissa).div(10**18);
1132 
1133       if (_account != address(this)) {
1134         IERC20(token).safeTransfer(_account, tokens);
1135       }
1136   }
1137   function _redeemITokens(uint256 _amount, address _account)
1138     internal
1139     returns (uint256 tokens) {
1140       tokens = iERC20(iToken).burn(_account, _amount);
1141   }
1142 }