1 // File: contracts\open-zeppelin-contracts\token\ERC20\IERC20.sol
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
80 // File: contracts\open-zeppelin-contracts\math\SafeMath.sol
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
190 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20.sol
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
369      * @dev Destroys `amount` tokens from `account`, reducing the
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
420 // File: contracts\open-zeppelin-contracts\access\Roles.sol
421 
422 pragma solidity ^0.5.0;
423 
424 /**
425  * @title Roles
426  * @dev Library for managing addresses assigned to a Role.
427  */
428 library Roles {
429     struct Role {
430         mapping (address => bool) bearer;
431     }
432 
433     /**
434      * @dev Give an account access to this role.
435      */
436     function add(Role storage role, address account) internal {
437         require(!has(role, account), "Roles: account already has role");
438         role.bearer[account] = true;
439     }
440 
441     /**
442      * @dev Remove an account's access to this role.
443      */
444     function remove(Role storage role, address account) internal {
445         require(has(role, account), "Roles: account does not have role");
446         role.bearer[account] = false;
447     }
448 
449     /**
450      * @dev Check if an account has this role.
451      * @return bool
452      */
453     function has(Role storage role, address account) internal view returns (bool) {
454         require(account != address(0), "Roles: account is the zero address");
455         return role.bearer[account];
456     }
457 }
458 
459 // File: contracts\open-zeppelin-contracts\access\roles\MinterRole.sol
460 
461 pragma solidity ^0.5.0;
462 
463 
464 contract MinterRole {
465     using Roles for Roles.Role;
466 
467     event MinterAdded(address indexed account);
468     event MinterRemoved(address indexed account);
469 
470     Roles.Role private _minters;
471 
472     constructor () internal {
473         _addMinter(msg.sender);
474     }
475 
476     modifier onlyMinter() {
477         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
478         _;
479     }
480 
481     function isMinter(address account) public view returns (bool) {
482         return _minters.has(account);
483     }
484 
485     function addMinter(address account) public onlyMinter {
486         _addMinter(account);
487     }
488 
489     function renounceMinter() public {
490         _removeMinter(msg.sender);
491     }
492 
493     function _addMinter(address account) internal {
494         _minters.add(account);
495         emit MinterAdded(account);
496     }
497 
498     function _removeMinter(address account) internal {
499         _minters.remove(account);
500         emit MinterRemoved(account);
501     }
502 }
503 
504 // File: contracts\open-zeppelin-contracts\token\ERC20\ERC20Mintable.sol
505 
506 pragma solidity ^0.5.0;
507 
508 
509 
510 /**
511  * @dev Extension of `ERC20` that adds a set of accounts with the `MinterRole`,
512  * which have permission to mint (create) new tokens as they see fit.
513  *
514  * At construction, the deployer of the contract is the only minter.
515  */
516 contract ERC20Mintable is ERC20, MinterRole {
517     /**
518      * @dev See `ERC20._mint`.
519      *
520      * Requirements:
521      *
522      * - the caller must have the `MinterRole`.
523      */
524     function mint(address account, uint256 amount) public onlyMinter returns (bool) {
525         _mint(account, amount);
526         return true;
527     }
528 }
529 
530 // File: contracts\open-zeppelin-contracts\utils\Address.sol
531 
532 pragma solidity ^0.5.0;
533 
534 /**
535  * @dev Collection of functions related to the address type
536  */
537 library Address {
538     /**
539      * @dev Returns true if `account` is a contract.
540      *
541      * This test is non-exhaustive, and there may be false-negatives: during the
542      * execution of a contract's constructor, its address will be reported as
543      * not containing a contract.
544      *
545      * > It is unsafe to assume that an address for which this function returns
546      * false is an externally-owned account (EOA) and not a contract.
547      */
548     function isContract(address account) internal view returns (bool) {
549         // This method relies in extcodesize, which returns 0 for contracts in
550         // construction, since the code is only stored at the end of the
551         // constructor execution.
552         
553         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
554         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
555         // for accounts without code, i.e. `keccak256('')`
556         bytes32 codehash;
557         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
558         // solhint-disable-next-line no-inline-assembly
559         assembly { codehash := extcodehash(account) }
560         return (codehash != 0x0 && codehash != accountHash);
561     }
562 
563     /**
564      * @dev Converts an `address` into `address payable`. Note that this is
565      * simply a type cast: the actual underlying value is not changed.
566      */
567     function toPayable(address account) internal pure returns (address payable) {
568         return address(uint160(account));
569     }
570 }
571 
572 // File: contracts\open-zeppelin-contracts\token\ERC20\SafeERC20.sol
573 
574 pragma solidity ^0.5.0;
575 
576 
577 
578 
579 /**
580  * @title SafeERC20
581  * @dev Wrappers around ERC20 operations that throw on failure (when the token
582  * contract returns false). Tokens that return no value (and instead revert or
583  * throw on failure) are also supported, non-reverting calls are assumed to be
584  * successful.
585  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
586  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
587  */
588 library SafeERC20 {
589     using SafeMath for uint256;
590     using Address for address;
591 
592     function safeTransfer(IERC20 token, address to, uint256 value) internal {
593         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
594     }
595 
596     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
597         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
598     }
599 
600     function safeApprove(IERC20 token, address spender, uint256 value) internal {
601         // safeApprove should only be called when setting an initial allowance,
602         // or when resetting it to zero. To increase and decrease it, use
603         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
604         // solhint-disable-next-line max-line-length
605         require((value == 0) || (token.allowance(address(this), spender) == 0),
606             "SafeERC20: approve from non-zero to non-zero allowance"
607         );
608         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
609     }
610 
611     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
612         uint256 newAllowance = token.allowance(address(this), spender).add(value);
613         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
614     }
615 
616     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
617         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
618         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
619     }
620 
621     /**
622      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
623      * on the return value: the return value is optional (but if data is returned, it must not be false).
624      * @param token The token targeted by the call.
625      * @param data The call data (encoded using abi.encode or one of its variants).
626      */
627     function callOptionalReturn(IERC20 token, bytes memory data) private {
628         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
629         // we're implementing it ourselves.
630 
631         // A Solidity high level call has three parts:
632         //  1. The target address is checked to verify it contains contract code
633         //  2. The call itself is made, and success asserted
634         //  3. The return value is decoded, which in turn checks the size of the returned data.
635         // solhint-disable-next-line max-line-length
636         require(address(token).isContract(), "SafeERC20: call to non-contract");
637 
638         // solhint-disable-next-line avoid-low-level-calls
639         (bool success, bytes memory returndata) = address(token).call(data);
640         require(success, "SafeERC20: low-level call failed");
641 
642         if (returndata.length > 0) { // Return data is optional
643             // solhint-disable-next-line max-line-length
644             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
645         }
646     }
647 }
648 
649 // File: contracts\open-zeppelin-contracts\utils\ReentrancyGuard.sol
650 
651 pragma solidity ^0.5.0;
652 
653 /**
654  * @dev Contract module that helps prevent reentrant calls to a function.
655  *
656  * Inheriting from `ReentrancyGuard` will make the `nonReentrant` modifier
657  * available, which can be aplied to functions to make sure there are no nested
658  * (reentrant) calls to them.
659  *
660  * Note that because there is a single `nonReentrant` guard, functions marked as
661  * `nonReentrant` may not call one another. This can be worked around by making
662  * those functions `private`, and then adding `external` `nonReentrant` entry
663  * points to them.
664  */
665 contract ReentrancyGuard {
666     /// @dev counter to allow mutex lock with only one SSTORE operation
667     uint256 private _guardCounter;
668 
669     constructor () internal {
670         // The counter starts at one to prevent changing it from zero to a non-zero
671         // value, which is a more expensive operation.
672         _guardCounter = 1;
673     }
674 
675     /**
676      * @dev Prevents a contract from calling itself, directly or indirectly.
677      * Calling a `nonReentrant` function from another `nonReentrant`
678      * function is not supported. It is possible to prevent this from happening
679      * by making the `nonReentrant` function external, and make it call a
680      * `private` function that does the actual work.
681      */
682     modifier nonReentrant() {
683         _guardCounter += 1;
684         uint256 localCounter = _guardCounter;
685         _;
686         require(localCounter == _guardCounter, "ReentrancyGuard: reentrant call");
687     }
688 }
689 
690 // File: contracts\open-zeppelin-contracts\crowdsale\Crowdsale.sol
691 
692 pragma solidity ^0.5.0;
693 
694 
695 
696 
697 
698 /**
699  * @title Crowdsale
700  * @dev Crowdsale is a base contract for managing a token crowdsale,
701  * allowing investors to purchase tokens with ether. This contract implements
702  * such functionality in its most fundamental form and can be extended to provide additional
703  * functionality and/or custom behavior.
704  * The external interface represents the basic interface for purchasing tokens, and conforms
705  * the base architecture for crowdsales. It is *not* intended to be modified / overridden.
706  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
707  * the methods to add functionality. Consider using 'super' where appropriate to concatenate
708  * behavior.
709  */
710 contract Crowdsale is ReentrancyGuard {
711     using SafeMath for uint256;
712     using SafeERC20 for IERC20;
713 
714     // The token being sold
715     IERC20 private _token;
716 
717     // Address where funds are collected
718     address payable private _wallet;
719 
720     // How many token units a buyer gets per wei.
721     // The rate is the conversion between wei and the smallest and indivisible token unit.
722     // So, if you are using a rate of 1 with a ERC20Detailed token with 3 decimals called TOK
723     // 1 wei will give you 1 unit, or 0.001 TOK.
724     uint256 private _rate;
725 
726     // Amount of wei raised
727     uint256 private _weiRaised;
728 
729     /**
730      * Event for token purchase logging
731      * @param purchaser who paid for the tokens
732      * @param beneficiary who got the tokens
733      * @param value weis paid for purchase
734      * @param amount amount of tokens purchased
735      */
736     event TokensPurchased(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
737 
738     /**
739      * @param rate Number of token units a buyer gets per wei
740      * @dev The rate is the conversion between wei and the smallest and indivisible
741      * token unit. So, if you are using a rate of 1 with a ERC20Detailed token
742      * with 3 decimals called TOK, 1 wei will give you 1 unit, or 0.001 TOK.
743      * @param wallet Address where collected funds will be forwarded to
744      * @param token Address of the token being sold
745      */
746     constructor (uint256 rate, address payable wallet, IERC20 token) public {
747         require(rate > 0, "Crowdsale: rate is 0");
748         require(wallet != address(0), "Crowdsale: wallet is the zero address");
749         require(address(token) != address(0), "Crowdsale: token is the zero address");
750 
751         _rate = rate;
752         _wallet = wallet;
753         _token = token;
754     }
755 
756     /**
757      * @dev fallback function ***DO NOT OVERRIDE***
758      * Note that other contracts will transfer funds with a base gas stipend
759      * of 2300, which is not enough to call buyTokens. Consider calling
760      * buyTokens directly when purchasing tokens from a contract.
761      */
762     function () external payable {
763         buyTokens(msg.sender);
764     }
765 
766     /**
767      * @return the token being sold.
768      */
769     function token() public view returns (IERC20) {
770         return _token;
771     }
772 
773     /**
774      * @return the address where funds are collected.
775      */
776     function wallet() public view returns (address payable) {
777         return _wallet;
778     }
779 
780     /**
781      * @return the number of token units a buyer gets per wei.
782      */
783     function rate() public view returns (uint256) {
784         return _rate;
785     }
786 
787     /**
788      * @return the amount of wei raised.
789      */
790     function weiRaised() public view returns (uint256) {
791         return _weiRaised;
792     }
793 
794     /**
795      * @dev low level token purchase ***DO NOT OVERRIDE***
796      * This function has a non-reentrancy guard, so it shouldn't be called by
797      * another `nonReentrant` function.
798      * @param beneficiary Recipient of the token purchase
799      */
800     function buyTokens(address beneficiary) public nonReentrant payable {
801         uint256 weiAmount = msg.value;
802         _preValidatePurchase(beneficiary, weiAmount);
803 
804         // calculate token amount to be created
805         uint256 tokens = _getTokenAmount(weiAmount);
806 
807         // update state
808         _weiRaised = _weiRaised.add(weiAmount);
809 
810         _processPurchase(beneficiary, tokens);
811         emit TokensPurchased(msg.sender, beneficiary, weiAmount, tokens);
812 
813         _updatePurchasingState(beneficiary, weiAmount);
814 
815         _forwardFunds();
816         _postValidatePurchase(beneficiary, weiAmount);
817     }
818 
819     /**
820      * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met.
821      * Use `super` in contracts that inherit from Crowdsale to extend their validations.
822      * Example from CappedCrowdsale.sol's _preValidatePurchase method:
823      *     super._preValidatePurchase(beneficiary, weiAmount);
824      *     require(weiRaised().add(weiAmount) <= cap);
825      * @param beneficiary Address performing the token purchase
826      * @param weiAmount Value in wei involved in the purchase
827      */
828     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
829         require(beneficiary != address(0), "Crowdsale: beneficiary is the zero address");
830         require(weiAmount != 0, "Crowdsale: weiAmount is 0");
831     }
832 
833     /**
834      * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid
835      * conditions are not met.
836      * @param beneficiary Address performing the token purchase
837      * @param weiAmount Value in wei involved in the purchase
838      */
839     function _postValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
840         // solhint-disable-previous-line no-empty-blocks
841     }
842 
843     /**
844      * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends
845      * its tokens.
846      * @param beneficiary Address performing the token purchase
847      * @param tokenAmount Number of tokens to be emitted
848      */
849     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
850         _token.safeTransfer(beneficiary, tokenAmount);
851     }
852 
853     /**
854      * @dev Executed when a purchase has been validated and is ready to be executed. Doesn't necessarily emit/send
855      * tokens.
856      * @param beneficiary Address receiving the tokens
857      * @param tokenAmount Number of tokens to be purchased
858      */
859     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
860         _deliverTokens(beneficiary, tokenAmount);
861     }
862 
863     /**
864      * @dev Override for extensions that require an internal state to check for validity (current user contributions,
865      * etc.)
866      * @param beneficiary Address receiving the tokens
867      * @param weiAmount Value in wei involved in the purchase
868      */
869     function _updatePurchasingState(address beneficiary, uint256 weiAmount) internal {
870         // solhint-disable-previous-line no-empty-blocks
871     }
872 
873     /**
874      * @dev Override to extend the way in which ether is converted to tokens.
875      * @param weiAmount Value in wei to be converted into tokens
876      * @return Number of tokens that can be purchased with the specified _weiAmount
877      */
878     function _getTokenAmount(uint256 weiAmount) internal view returns (uint256) {
879         return weiAmount.mul(_rate);
880     }
881 
882     /**
883      * @dev Determines how ETH is stored/forwarded on purchases.
884      */
885     function _forwardFunds() internal {
886         _wallet.transfer(msg.value);
887     }
888 }
889 
890 // File: contracts\open-zeppelin-contracts\crowdsale\validation\CappedCrowdsale.sol
891 
892 pragma solidity ^0.5.0;
893 
894 
895 
896 /**
897  * @title CappedCrowdsale
898  * @dev Crowdsale with a limit for total contributions.
899  */
900 contract CappedCrowdsale is Crowdsale {
901     using SafeMath for uint256;
902 
903     uint256 private _cap;
904 
905     /**
906      * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
907      * @param cap Max amount of wei to be contributed
908      */
909     constructor (uint256 cap) public {
910         require(cap > 0, "CappedCrowdsale: cap is 0");
911         _cap = cap;
912     }
913 
914     /**
915      * @return the cap of the crowdsale.
916      */
917     function cap() public view returns (uint256) {
918         return _cap;
919     }
920 
921     /**
922      * @dev Checks whether the cap has been reached.
923      * @return Whether the cap was reached
924      */
925     function capReached() public view returns (bool) {
926         return weiRaised() >= _cap;
927     }
928 
929     /**
930      * @dev Extend parent behavior requiring purchase to respect the funding cap.
931      * @param beneficiary Token purchaser
932      * @param weiAmount Amount of wei contributed
933      */
934     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal view {
935         super._preValidatePurchase(beneficiary, weiAmount);
936         require(weiRaised().add(weiAmount) <= _cap, "CappedCrowdsale: cap exceeded");
937     }
938 }
939 
940 // File: contracts\open-zeppelin-contracts\crowdsale\emission\MintedCrowdsale.sol
941 
942 pragma solidity ^0.5.0;
943 
944 
945 
946 /**
947  * @title MintedCrowdsale
948  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
949  * Token ownership should be transferred to MintedCrowdsale for minting.
950  */
951 contract MintedCrowdsale is Crowdsale {
952     /**
953      * @dev Overrides delivery by minting tokens upon purchase.
954      * @param beneficiary Token purchaser
955      * @param tokenAmount Number of tokens to be minted
956      */
957     function _deliverTokens(address beneficiary, uint256 tokenAmount) internal {
958         // Potentially dangerous assumption about the type of the token.
959         require(
960             ERC20Mintable(address(token())).mint(beneficiary, tokenAmount),
961                 "MintedCrowdsale: minting failed"
962         );
963     }
964 }
965 
966 // File: contracts\open-zeppelin-contracts\crowdsale\validation\TimedCrowdsale.sol
967 
968 pragma solidity ^0.5.0;
969 
970 
971 
972 /**
973  * @title TimedCrowdsale
974  * @dev Crowdsale accepting contributions only within a time frame.
975  */
976 contract TimedCrowdsale is Crowdsale {
977     using SafeMath for uint256;
978 
979     uint256 private _openingTime;
980     uint256 private _closingTime;
981 
982     /**
983      * Event for crowdsale extending
984      * @param newClosingTime new closing time
985      * @param prevClosingTime old closing time
986      */
987     event TimedCrowdsaleExtended(uint256 prevClosingTime, uint256 newClosingTime);
988 
989     /**
990      * @dev Reverts if not in crowdsale time range.
991      */
992     modifier onlyWhileOpen {
993         require(isOpen(), "TimedCrowdsale: not open");
994         _;
995     }
996 
997     /**
998      * @dev Constructor, takes crowdsale opening and closing times.
999      * @param openingTime Crowdsale opening time
1000      * @param closingTime Crowdsale closing time
1001      */
1002     constructor (uint256 openingTime, uint256 closingTime) public {
1003         // solhint-disable-next-line not-rely-on-time
1004         require(openingTime >= block.timestamp, "TimedCrowdsale: opening time is before current time");
1005         // solhint-disable-next-line max-line-length
1006         require(closingTime > openingTime, "TimedCrowdsale: opening time is not before closing time");
1007 
1008         _openingTime = openingTime;
1009         _closingTime = closingTime;
1010     }
1011 
1012     /**
1013      * @return the crowdsale opening time.
1014      */
1015     function openingTime() public view returns (uint256) {
1016         return _openingTime;
1017     }
1018 
1019     /**
1020      * @return the crowdsale closing time.
1021      */
1022     function closingTime() public view returns (uint256) {
1023         return _closingTime;
1024     }
1025 
1026     /**
1027      * @return true if the crowdsale is open, false otherwise.
1028      */
1029     function isOpen() public view returns (bool) {
1030         // solhint-disable-next-line not-rely-on-time
1031         return block.timestamp >= _openingTime && block.timestamp <= _closingTime;
1032     }
1033 
1034     /**
1035      * @dev Checks whether the period in which the crowdsale is open has already elapsed.
1036      * @return Whether crowdsale period has elapsed
1037      */
1038     function hasClosed() public view returns (bool) {
1039         // solhint-disable-next-line not-rely-on-time
1040         return block.timestamp > _closingTime;
1041     }
1042 
1043     /**
1044      * @dev Extend parent behavior requiring to be within contributing period.
1045      * @param beneficiary Token purchaser
1046      * @param weiAmount Amount of wei contributed
1047      */
1048     function _preValidatePurchase(address beneficiary, uint256 weiAmount) internal onlyWhileOpen view {
1049         super._preValidatePurchase(beneficiary, weiAmount);
1050     }
1051 
1052     /**
1053      * @dev Extend crowdsale.
1054      * @param newClosingTime Crowdsale closing time
1055      */
1056     function _extendTime(uint256 newClosingTime) internal {
1057         require(!hasClosed(), "TimedCrowdsale: already closed");
1058         // solhint-disable-next-line max-line-length
1059         require(newClosingTime > _closingTime, "TimedCrowdsale: new closing time is before current closing time");
1060 
1061         emit TimedCrowdsaleExtended(_closingTime, newClosingTime);
1062         _closingTime = newClosingTime;
1063     }
1064 }
1065 
1066 // File: contracts\open-zeppelin-contracts\crowdsale\distribution\FinalizableCrowdsale.sol
1067 
1068 pragma solidity ^0.5.0;
1069 
1070 
1071 
1072 /**
1073  * @title FinalizableCrowdsale
1074  * @dev Extension of TimedCrowdsale with a one-off finalization action, where one
1075  * can do extra work after finishing.
1076  */
1077 contract FinalizableCrowdsale is TimedCrowdsale {
1078     using SafeMath for uint256;
1079 
1080     bool private _finalized;
1081 
1082     event CrowdsaleFinalized();
1083 
1084     constructor () internal {
1085         _finalized = false;
1086     }
1087 
1088     /**
1089      * @return true if the crowdsale is finalized, false otherwise.
1090      */
1091     function finalized() public view returns (bool) {
1092         return _finalized;
1093     }
1094 
1095     /**
1096      * @dev Must be called after crowdsale ends, to do some extra finalization
1097      * work. Calls the contract's finalization function.
1098      */
1099     function finalize() public {
1100         require(!_finalized, "FinalizableCrowdsale: already finalized");
1101         require(hasClosed(), "FinalizableCrowdsale: not closed");
1102 
1103         _finalized = true;
1104 
1105         _finalization();
1106         emit CrowdsaleFinalized();
1107     }
1108 
1109     /**
1110      * @dev Can be overridden to add finalization logic. The overriding function
1111      * should call super._finalization() to ensure the chain of finalization is
1112      * executed entirely.
1113      */
1114     function _finalization() internal {
1115         // solhint-disable-previous-line no-empty-blocks
1116     }
1117 }
1118 
1119 // File: contracts\open-zeppelin-contracts\ownership\Secondary.sol
1120 
1121 pragma solidity ^0.5.0;
1122 
1123 /**
1124  * @dev A Secondary contract can only be used by its primary account (the one that created it).
1125  */
1126 contract Secondary {
1127     address private _primary;
1128 
1129     /**
1130      * @dev Emitted when the primary contract changes.
1131      */
1132     event PrimaryTransferred(
1133         address recipient
1134     );
1135 
1136     /**
1137      * @dev Sets the primary account to the one that is creating the Secondary contract.
1138      */
1139     constructor () internal {
1140         _primary = msg.sender;
1141         emit PrimaryTransferred(_primary);
1142     }
1143 
1144     /**
1145      * @dev Reverts if called from any account other than the primary.
1146      */
1147     modifier onlyPrimary() {
1148         require(msg.sender == _primary, "Secondary: caller is not the primary account");
1149         _;
1150     }
1151 
1152     /**
1153      * @return the address of the primary.
1154      */
1155     function primary() public view returns (address) {
1156         return _primary;
1157     }
1158 
1159     /**
1160      * @dev Transfers contract to a new primary.
1161      * @param recipient The address of new primary.
1162      */
1163     function transferPrimary(address recipient) public onlyPrimary {
1164         require(recipient != address(0), "Secondary: new primary is the zero address");
1165         _primary = recipient;
1166         emit PrimaryTransferred(_primary);
1167     }
1168 }
1169 
1170 // File: contracts\open-zeppelin-contracts\payment\escrow\Escrow.sol
1171 
1172 pragma solidity ^0.5.0;
1173 
1174 
1175 
1176  /**
1177   * @title Escrow
1178   * @dev Base escrow contract, holds funds designated for a payee until they
1179   * withdraw them.
1180   * @dev Intended usage: This contract (and derived escrow contracts) should be a
1181   * standalone contract, that only interacts with the contract that instantiated
1182   * it. That way, it is guaranteed that all Ether will be handled according to
1183   * the Escrow rules, and there is no need to check for payable functions or
1184   * transfers in the inheritance tree. The contract that uses the escrow as its
1185   * payment method should be its primary, and provide public methods redirecting
1186   * to the escrow's deposit and withdraw.
1187   */
1188 contract Escrow is Secondary {
1189     using SafeMath for uint256;
1190 
1191     event Deposited(address indexed payee, uint256 weiAmount);
1192     event Withdrawn(address indexed payee, uint256 weiAmount);
1193 
1194     mapping(address => uint256) private _deposits;
1195 
1196     function depositsOf(address payee) public view returns (uint256) {
1197         return _deposits[payee];
1198     }
1199 
1200     /**
1201      * @dev Stores the sent amount as credit to be withdrawn.
1202      * @param payee The destination address of the funds.
1203      */
1204     function deposit(address payee) public onlyPrimary payable {
1205         uint256 amount = msg.value;
1206         _deposits[payee] = _deposits[payee].add(amount);
1207 
1208         emit Deposited(payee, amount);
1209     }
1210 
1211     /**
1212      * @dev Withdraw accumulated balance for a payee.
1213      * @param payee The address whose funds will be withdrawn and transferred to.
1214      */
1215     function withdraw(address payable payee) public onlyPrimary {
1216         uint256 payment = _deposits[payee];
1217 
1218         _deposits[payee] = 0;
1219 
1220         payee.transfer(payment);
1221 
1222         emit Withdrawn(payee, payment);
1223     }
1224 }
1225 
1226 // File: contracts\open-zeppelin-contracts\payment\escrow\ConditionalEscrow.sol
1227 
1228 pragma solidity ^0.5.0;
1229 
1230 
1231 /**
1232  * @title ConditionalEscrow
1233  * @dev Base abstract escrow to only allow withdrawal if a condition is met.
1234  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
1235  */
1236 contract ConditionalEscrow is Escrow {
1237     /**
1238      * @dev Returns whether an address is allowed to withdraw their funds. To be
1239      * implemented by derived contracts.
1240      * @param payee The destination address of the funds.
1241      */
1242     function withdrawalAllowed(address payee) public view returns (bool);
1243 
1244     function withdraw(address payable payee) public {
1245         require(withdrawalAllowed(payee), "ConditionalEscrow: payee is not allowed to withdraw");
1246         super.withdraw(payee);
1247     }
1248 }
1249 
1250 // File: contracts\open-zeppelin-contracts\payment\escrow\RefundEscrow.sol
1251 
1252 pragma solidity ^0.5.0;
1253 
1254 
1255 /**
1256  * @title RefundEscrow
1257  * @dev Escrow that holds funds for a beneficiary, deposited from multiple
1258  * parties.
1259  * @dev Intended usage: See Escrow.sol. Same usage guidelines apply here.
1260  * @dev The primary account (that is, the contract that instantiates this
1261  * contract) may deposit, close the deposit period, and allow for either
1262  * withdrawal by the beneficiary, or refunds to the depositors. All interactions
1263  * with RefundEscrow will be made through the primary contract. See the
1264  * RefundableCrowdsale contract for an example of RefundEscrowΓÇÖs use.
1265  */
1266 contract RefundEscrow is ConditionalEscrow {
1267     enum State { Active, Refunding, Closed }
1268 
1269     event RefundsClosed();
1270     event RefundsEnabled();
1271 
1272     State private _state;
1273     address payable private _beneficiary;
1274 
1275     /**
1276      * @dev Constructor.
1277      * @param beneficiary The beneficiary of the deposits.
1278      */
1279     constructor (address payable beneficiary) public {
1280         require(beneficiary != address(0), "RefundEscrow: beneficiary is the zero address");
1281         _beneficiary = beneficiary;
1282         _state = State.Active;
1283     }
1284 
1285     /**
1286      * @return The current state of the escrow.
1287      */
1288     function state() public view returns (State) {
1289         return _state;
1290     }
1291 
1292     /**
1293      * @return The beneficiary of the escrow.
1294      */
1295     function beneficiary() public view returns (address) {
1296         return _beneficiary;
1297     }
1298 
1299     /**
1300      * @dev Stores funds that may later be refunded.
1301      * @param refundee The address funds will be sent to if a refund occurs.
1302      */
1303     function deposit(address refundee) public payable {
1304         require(_state == State.Active, "RefundEscrow: can only deposit while active");
1305         super.deposit(refundee);
1306     }
1307 
1308     /**
1309      * @dev Allows for the beneficiary to withdraw their funds, rejecting
1310      * further deposits.
1311      */
1312     function close() public onlyPrimary {
1313         require(_state == State.Active, "RefundEscrow: can only close while active");
1314         _state = State.Closed;
1315         emit RefundsClosed();
1316     }
1317 
1318     /**
1319      * @dev Allows for refunds to take place, rejecting further deposits.
1320      */
1321     function enableRefunds() public onlyPrimary {
1322         require(_state == State.Active, "RefundEscrow: can only enable refunds while active");
1323         _state = State.Refunding;
1324         emit RefundsEnabled();
1325     }
1326 
1327     /**
1328      * @dev Withdraws the beneficiary's funds.
1329      */
1330     function beneficiaryWithdraw() public {
1331         require(_state == State.Closed, "RefundEscrow: beneficiary can only withdraw while closed");
1332         _beneficiary.transfer(address(this).balance);
1333     }
1334 
1335     /**
1336      * @dev Returns whether refundees can withdraw their deposits (be refunded). The overridden function receives a
1337      * 'payee' argument, but we ignore it here since the condition is global, not per-payee.
1338      */
1339     function withdrawalAllowed(address) public view returns (bool) {
1340         return _state == State.Refunding;
1341     }
1342 }
1343 
1344 // File: contracts\open-zeppelin-contracts\crowdsale\distribution\RefundableCrowdsale.sol
1345 
1346 pragma solidity ^0.5.0;
1347 
1348 
1349 
1350 
1351 /**
1352  * @title RefundableCrowdsale
1353  * @dev Extension of `FinalizableCrowdsale` contract that adds a funding goal, and the possibility of users
1354  * getting a refund if goal is not met.
1355  *
1356  * Deprecated, use `RefundablePostDeliveryCrowdsale` instead. Note that if you allow tokens to be traded before the goal
1357  * is met, then an attack is possible in which the attacker purchases tokens from the crowdsale and when they sees that
1358  * the goal is unlikely to be met, they sell their tokens (possibly at a discount). The attacker will be refunded when
1359  * the crowdsale is finalized, and the users that purchased from them will be left with worthless tokens.
1360  */
1361 contract RefundableCrowdsale is FinalizableCrowdsale {
1362     using SafeMath for uint256;
1363 
1364     // minimum amount of funds to be raised in weis
1365     uint256 private _goal;
1366 
1367     // refund escrow used to hold funds while crowdsale is running
1368     RefundEscrow private _escrow;
1369 
1370     /**
1371      * @dev Constructor, creates RefundEscrow.
1372      * @param goal Funding goal
1373      */
1374     constructor (uint256 goal) public {
1375         require(goal > 0, "RefundableCrowdsale: goal is 0");
1376         _escrow = new RefundEscrow(wallet());
1377         _goal = goal;
1378     }
1379 
1380     /**
1381      * @return minimum amount of funds to be raised in wei.
1382      */
1383     function goal() public view returns (uint256) {
1384         return _goal;
1385     }
1386 
1387     /**
1388      * @dev Investors can claim refunds here if crowdsale is unsuccessful.
1389      * @param refundee Whose refund will be claimed.
1390      */
1391     function claimRefund(address payable refundee) public {
1392         require(finalized(), "RefundableCrowdsale: not finalized");
1393         require(!goalReached(), "RefundableCrowdsale: goal reached");
1394 
1395         _escrow.withdraw(refundee);
1396     }
1397 
1398     /**
1399      * @dev Checks whether funding goal was reached.
1400      * @return Whether funding goal was reached
1401      */
1402     function goalReached() public view returns (bool) {
1403         return weiRaised() >= _goal;
1404     }
1405 
1406     /**
1407      * @dev Escrow finalization task, called when finalize() is called.
1408      */
1409     function _finalization() internal {
1410         if (goalReached()) {
1411             _escrow.close();
1412             _escrow.beneficiaryWithdraw();
1413         } else {
1414             _escrow.enableRefunds();
1415         }
1416 
1417         super._finalization();
1418     }
1419 
1420     /**
1421      * @dev Overrides Crowdsale fund forwarding, sending funds to escrow.
1422      */
1423     function _forwardFunds() internal {
1424         _escrow.deposit.value(msg.value)(msg.sender);
1425     }
1426 }
1427 
1428 // File: contracts\open-zeppelin-contracts\crowdsale\distribution\PostDeliveryCrowdsale.sol
1429 
1430 pragma solidity ^0.5.0;
1431 
1432 
1433 
1434 
1435 
1436 /**
1437  * @title PostDeliveryCrowdsale
1438  * @dev Crowdsale that locks tokens from withdrawal until it ends.
1439  */
1440 contract PostDeliveryCrowdsale is TimedCrowdsale {
1441     using SafeMath for uint256;
1442 
1443     mapping(address => uint256) private _balances;
1444     __unstable__TokenVault private _vault;
1445 
1446     constructor() public {
1447         _vault = new __unstable__TokenVault();
1448     }
1449 
1450     /**
1451      * @dev Withdraw tokens only after crowdsale ends.
1452      * @param beneficiary Whose tokens will be withdrawn.
1453      */
1454     function withdrawTokens(address beneficiary) public {
1455         require(hasClosed(), "PostDeliveryCrowdsale: not closed");
1456         uint256 amount = _balances[beneficiary];
1457         require(amount > 0, "PostDeliveryCrowdsale: beneficiary is not due any tokens");
1458 
1459         _balances[beneficiary] = 0;
1460         _vault.transfer(token(), beneficiary, amount);
1461     }
1462 
1463     /**
1464      * @return the balance of an account.
1465      */
1466     function balanceOf(address account) public view returns (uint256) {
1467         return _balances[account];
1468     }
1469 
1470     /**
1471      * @dev Overrides parent by storing due balances, and delivering tokens to the vault instead of the end user. This
1472      * ensures that the tokens will be available by the time they are withdrawn (which may not be the case if
1473      * `_deliverTokens` was called later).
1474      * @param beneficiary Token purchaser
1475      * @param tokenAmount Amount of tokens purchased
1476      */
1477     function _processPurchase(address beneficiary, uint256 tokenAmount) internal {
1478         _balances[beneficiary] = _balances[beneficiary].add(tokenAmount);
1479         _deliverTokens(address(_vault), tokenAmount);
1480     }
1481 }
1482 
1483 /**
1484  * @title __unstable__TokenVault
1485  * @dev Similar to an Escrow for tokens, this contract allows its primary account to spend its tokens as it sees fit.
1486  * This contract is an internal helper for PostDeliveryCrowdsale, and should not be used outside of this context.
1487  */
1488 // solhint-disable-next-line contract-name-camelcase
1489 contract __unstable__TokenVault is Secondary {
1490     function transfer(IERC20 token, address to, uint256 amount) public onlyPrimary {
1491         token.transfer(to, amount);
1492     }
1493 }
1494 
1495 // File: contracts\open-zeppelin-contracts\crowdsale\distribution\RefundablePostDeliveryCrowdsale.sol
1496 
1497 pragma solidity ^0.5.0;
1498 
1499 
1500 
1501 
1502 /**
1503  * @title RefundablePostDeliveryCrowdsale
1504  * @dev Extension of RefundableCrowdsale contract that only delivers the tokens
1505  * once the crowdsale has closed and the goal met, preventing refunds to be issued
1506  * to token holders.
1507  */
1508 contract RefundablePostDeliveryCrowdsale is RefundableCrowdsale, PostDeliveryCrowdsale {
1509     function withdrawTokens(address beneficiary) public {
1510         require(finalized(), "RefundablePostDeliveryCrowdsale: not finalized");
1511         require(goalReached(), "RefundablePostDeliveryCrowdsale: goal not reached");
1512 
1513         super.withdrawTokens(beneficiary);
1514     }
1515 }
1516 
1517 // File: contracts\open-zeppelin-contracts\ownership\Ownable.sol
1518 
1519 pragma solidity ^0.5.0;
1520 
1521 /**
1522  * @dev Contract module which provides a basic access control mechanism, where
1523  * there is an account (an owner) that can be granted exclusive access to
1524  * specific functions.
1525  *
1526  * This module is used through inheritance. It will make available the modifier
1527  * `onlyOwner`, which can be applied to your functions to restrict their use to
1528  * the owner.
1529  */
1530 contract Ownable {
1531     address private _owner;
1532 
1533     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1534 
1535     /**
1536      * @dev Initializes the contract setting the deployer as the initial owner.
1537      */
1538     constructor () internal {
1539         _owner = msg.sender;
1540         emit OwnershipTransferred(address(0), _owner);
1541     }
1542 
1543     /**
1544      * @dev Returns the address of the current owner.
1545      */
1546     function owner() public view returns (address) {
1547         return _owner;
1548     }
1549 
1550     /**
1551      * @dev Throws if called by any account other than the owner.
1552      */
1553     modifier onlyOwner() {
1554         require(isOwner(), "Ownable: caller is not the owner");
1555         _;
1556     }
1557 
1558     /**
1559      * @dev Returns true if the caller is the current owner.
1560      */
1561     function isOwner() public view returns (bool) {
1562         return msg.sender == _owner;
1563     }
1564 
1565     /**
1566      * @dev Leaves the contract without owner. It will not be possible to call
1567      * `onlyOwner` functions anymore. Can only be called by the current owner.
1568      *
1569      * > Note: Renouncing ownership will leave the contract without an owner,
1570      * thereby removing any functionality that is only available to the owner.
1571      */
1572     function renounceOwnership() public onlyOwner {
1573         emit OwnershipTransferred(_owner, address(0));
1574         _owner = address(0);
1575     }
1576 
1577     /**
1578      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1579      * Can only be called by the current owner.
1580      */
1581     function transferOwnership(address newOwner) public onlyOwner {
1582         _transferOwnership(newOwner);
1583     }
1584 
1585     /**
1586      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1587      */
1588     function _transferOwnership(address newOwner) internal {
1589         require(newOwner != address(0), "Ownable: new owner is the zero address");
1590         emit OwnershipTransferred(_owner, newOwner);
1591         _owner = newOwner;
1592     }
1593 }
1594 
1595 // File: contracts\crowdsale\CMRPDCrowdsale.sol
1596 
1597 pragma solidity ^0.5.0;
1598 
1599 
1600 
1601 
1602 
1603 
1604 /**
1605  * @title CMRPDCrowdsale
1606  * @dev CMRPDCrowdsale is an ERC-20 tokens crowdsale. Contract uses ETH as a fund raising currency. Features:
1607  *   - Capped - has a cap (maximum, hard cap) on ETH funds raised
1608  *   - Minted - new tokens are minted during crowdsale
1609  *   - Timed - has opening and closing time
1610  *   - Refundable - has a goal (minimum, soft cap), if not exceeded, funds are returned to investors
1611  *   - PostDelivery - tokens are withdrawn after crowsale is successfully finished
1612  * @author TokenMint (visit https://tokenmint.io)
1613  */
1614 contract CMRPDCrowdsale is RefundablePostDeliveryCrowdsale, CappedCrowdsale, MintedCrowdsale, Ownable {
1615 
1616     /**
1617     * @dev Constructor, creates CMRPDCrowdsale.
1618     * @param openingTime Crowdsale opening time
1619     * @param closingTime Crowdsale closing time
1620     * @param rate How many smallest token units a buyer gets per wei
1621     * @param fundRaisingAddress Address where raised funds will be transfered if crowdsale is successful
1622     * @param tokenContractAddress ERC20Mintable contract address of the token being sold, already deployed
1623     * @param cap Cap on funds raised (maximum, hard cap)
1624     * @param goal Goal on funds raised (minimum, soft cap)
1625     */
1626     constructor (
1627         uint256 openingTime,
1628         uint256 closingTime,
1629         uint256 rate,
1630         address payable fundRaisingAddress,
1631         ERC20Mintable tokenContractAddress,
1632         uint256 cap,
1633         uint256 goal
1634     )
1635         public
1636         Crowdsale(rate, fundRaisingAddress, tokenContractAddress)
1637         CappedCrowdsale(cap)
1638         TimedCrowdsale(openingTime, closingTime)
1639         RefundableCrowdsale(goal)
1640     {
1641       // As goal needs to be met for a successful crowdsale
1642       // the value needs to less or equal than a cap which is limit for accepted funds
1643       require(goal <= cap);
1644     }
1645 }