1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.5.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
32 
33 pragma solidity ^0.5.0;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: @openzeppelin/contracts/math/SafeMath.sol
111 
112 pragma solidity ^0.5.0;
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
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      *
261      * _Available since v2.4.0._
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
270 
271 pragma solidity ^0.5.0;
272 
273 
274 
275 
276 /**
277  * @dev Implementation of the {IERC20} interface.
278  *
279  * This implementation is agnostic to the way tokens are created. This means
280  * that a supply mechanism has to be added in a derived contract using {_mint}.
281  * For a generic mechanism see {ERC20Mintable}.
282  *
283  * TIP: For a detailed writeup see our guide
284  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
285  * to implement supply mechanisms].
286  *
287  * We have followed general OpenZeppelin guidelines: functions revert instead
288  * of returning `false` on failure. This behavior is nonetheless conventional
289  * and does not conflict with the expectations of ERC20 applications.
290  *
291  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
292  * This allows applications to reconstruct the allowance for all accounts just
293  * by listening to said events. Other implementations of the EIP may not emit
294  * these events, as it isn't required by the specification.
295  *
296  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
297  * functions have been added to mitigate the well-known issues around setting
298  * allowances. See {IERC20-approve}.
299  */
300 contract ERC20 is Context, IERC20 {
301     using SafeMath for uint256;
302 
303     mapping (address => uint256) private _balances;
304 
305     mapping (address => mapping (address => uint256)) private _allowances;
306 
307     uint256 private _totalSupply;
308 
309     /**
310      * @dev See {IERC20-totalSupply}.
311      */
312     function totalSupply() public view returns (uint256) {
313         return _totalSupply;
314     }
315 
316     /**
317      * @dev See {IERC20-balanceOf}.
318      */
319     function balanceOf(address account) public view returns (uint256) {
320         return _balances[account];
321     }
322 
323     /**
324      * @dev See {IERC20-transfer}.
325      *
326      * Requirements:
327      *
328      * - `recipient` cannot be the zero address.
329      * - the caller must have a balance of at least `amount`.
330      */
331     function transfer(address recipient, uint256 amount) public returns (bool) {
332         _transfer(_msgSender(), recipient, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-allowance}.
338      */
339     function allowance(address owner, address spender) public view returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See {IERC20-approve}.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function approve(address spender, uint256 amount) public returns (bool) {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20};
360      *
361      * Requirements:
362      * - `sender` and `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      * - the caller must have allowance for `sender`'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
368         _transfer(sender, recipient, amount);
369         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
370         return true;
371     }
372 
373     /**
374      * @dev Atomically increases the allowance granted to `spender` by the caller.
375      *
376      * This is an alternative to {approve} that can be used as a mitigation for
377      * problems described in {IERC20-approve}.
378      *
379      * Emits an {Approval} event indicating the updated allowance.
380      *
381      * Requirements:
382      *
383      * - `spender` cannot be the zero address.
384      */
385     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
386         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
387         return true;
388     }
389 
390     /**
391      * @dev Atomically decreases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      * - `spender` must have allowance for the caller of at least
402      * `subtractedValue`.
403      */
404     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
405         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
406         return true;
407     }
408 
409     /**
410      * @dev Moves tokens `amount` from `sender` to `recipient`.
411      *
412      * This is internal function is equivalent to {transfer}, and can be used to
413      * e.g. implement automatic token fees, slashing mechanisms, etc.
414      *
415      * Emits a {Transfer} event.
416      *
417      * Requirements:
418      *
419      * - `sender` cannot be the zero address.
420      * - `recipient` cannot be the zero address.
421      * - `sender` must have a balance of at least `amount`.
422      */
423     function _transfer(address sender, address recipient, uint256 amount) internal {
424         require(sender != address(0), "ERC20: transfer from the zero address");
425         require(recipient != address(0), "ERC20: transfer to the zero address");
426 
427         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
428         _balances[recipient] = _balances[recipient].add(amount);
429         emit Transfer(sender, recipient, amount);
430     }
431 
432     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
433      * the total supply.
434      *
435      * Emits a {Transfer} event with `from` set to the zero address.
436      *
437      * Requirements
438      *
439      * - `to` cannot be the zero address.
440      */
441     function _mint(address account, uint256 amount) internal {
442         require(account != address(0), "ERC20: mint to the zero address");
443 
444         _totalSupply = _totalSupply.add(amount);
445         _balances[account] = _balances[account].add(amount);
446         emit Transfer(address(0), account, amount);
447     }
448 
449     /**
450      * @dev Destroys `amount` tokens from `account`, reducing the
451      * total supply.
452      *
453      * Emits a {Transfer} event with `to` set to the zero address.
454      *
455      * Requirements
456      *
457      * - `account` cannot be the zero address.
458      * - `account` must have at least `amount` tokens.
459      */
460     function _burn(address account, uint256 amount) internal {
461         require(account != address(0), "ERC20: burn from the zero address");
462 
463         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
464         _totalSupply = _totalSupply.sub(amount);
465         emit Transfer(account, address(0), amount);
466     }
467 
468     /**
469      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
470      *
471      * This is internal function is equivalent to `approve`, and can be used to
472      * e.g. set automatic allowances for certain subsystems, etc.
473      *
474      * Emits an {Approval} event.
475      *
476      * Requirements:
477      *
478      * - `owner` cannot be the zero address.
479      * - `spender` cannot be the zero address.
480      */
481     function _approve(address owner, address spender, uint256 amount) internal {
482         require(owner != address(0), "ERC20: approve from the zero address");
483         require(spender != address(0), "ERC20: approve to the zero address");
484 
485         _allowances[owner][spender] = amount;
486         emit Approval(owner, spender, amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
491      * from the caller's allowance.
492      *
493      * See {_burn} and {_approve}.
494      */
495     function _burnFrom(address account, uint256 amount) internal {
496         _burn(account, amount);
497         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
498     }
499 }
500 
501 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
502 
503 pragma solidity ^0.5.0;
504 
505 
506 
507 /**
508  * @dev Extension of {ERC20} that allows token holders to destroy both their own
509  * tokens and those that they have an allowance for, in a way that can be
510  * recognized off-chain (via event analysis).
511  */
512 contract ERC20Burnable is Context, ERC20 {
513     /**
514      * @dev Destroys `amount` tokens from the caller.
515      *
516      * See {ERC20-_burn}.
517      */
518     function burn(uint256 amount) public {
519         _burn(_msgSender(), amount);
520     }
521 
522     /**
523      * @dev See {ERC20-_burnFrom}.
524      */
525     function burnFrom(address account, uint256 amount) public {
526         _burnFrom(account, amount);
527     }
528 }
529 
530 // File: @openzeppelin/contracts/utils/Address.sol
531 
532 pragma solidity ^0.5.5;
533 
534 /**
535  * @dev Collection of functions related to the address type
536  */
537 library Address {
538     /**
539      * @dev Returns true if `account` is a contract.
540      *
541      * [IMPORTANT]
542      * ====
543      * It is unsafe to assume that an address for which this function returns
544      * false is an externally-owned account (EOA) and not a contract.
545      *
546      * Among others, `isContract` will return false for the following 
547      * types of addresses:
548      *
549      *  - an externally-owned account
550      *  - a contract in construction
551      *  - an address where a contract will be created
552      *  - an address where a contract lived, but was destroyed
553      * ====
554      */
555     function isContract(address account) internal view returns (bool) {
556         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
557         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
558         // for accounts without code, i.e. `keccak256('')`
559         bytes32 codehash;
560         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
561         // solhint-disable-next-line no-inline-assembly
562         assembly { codehash := extcodehash(account) }
563         return (codehash != accountHash && codehash != 0x0);
564     }
565 
566     /**
567      * @dev Converts an `address` into `address payable`. Note that this is
568      * simply a type cast: the actual underlying value is not changed.
569      *
570      * _Available since v2.4.0._
571      */
572     function toPayable(address account) internal pure returns (address payable) {
573         return address(uint160(account));
574     }
575 
576     /**
577      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
578      * `recipient`, forwarding all available gas and reverting on errors.
579      *
580      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
581      * of certain opcodes, possibly making contracts go over the 2300 gas limit
582      * imposed by `transfer`, making them unable to receive funds via
583      * `transfer`. {sendValue} removes this limitation.
584      *
585      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
586      *
587      * IMPORTANT: because control is transferred to `recipient`, care must be
588      * taken to not create reentrancy vulnerabilities. Consider using
589      * {ReentrancyGuard} or the
590      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
591      *
592      * _Available since v2.4.0._
593      */
594     function sendValue(address payable recipient, uint256 amount) internal {
595         require(address(this).balance >= amount, "Address: insufficient balance");
596 
597         // solhint-disable-next-line avoid-call-value
598         (bool success, ) = recipient.call.value(amount)("");
599         require(success, "Address: unable to send value, recipient may have reverted");
600     }
601 }
602 
603 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
604 
605 pragma solidity ^0.5.0;
606 
607 
608 
609 
610 /**
611  * @title SafeERC20
612  * @dev Wrappers around ERC20 operations that throw on failure (when the token
613  * contract returns false). Tokens that return no value (and instead revert or
614  * throw on failure) are also supported, non-reverting calls are assumed to be
615  * successful.
616  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
617  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
618  */
619 library SafeERC20 {
620     using SafeMath for uint256;
621     using Address for address;
622 
623     function safeTransfer(IERC20 token, address to, uint256 value) internal {
624         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
625     }
626 
627     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
628         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
629     }
630 
631     function safeApprove(IERC20 token, address spender, uint256 value) internal {
632         // safeApprove should only be called when setting an initial allowance,
633         // or when resetting it to zero. To increase and decrease it, use
634         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
635         // solhint-disable-next-line max-line-length
636         require((value == 0) || (token.allowance(address(this), spender) == 0),
637             "SafeERC20: approve from non-zero to non-zero allowance"
638         );
639         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
640     }
641 
642     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
643         uint256 newAllowance = token.allowance(address(this), spender).add(value);
644         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
645     }
646 
647     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
648         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
649         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
650     }
651 
652     /**
653      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
654      * on the return value: the return value is optional (but if data is returned, it must not be false).
655      * @param token The token targeted by the call.
656      * @param data The call data (encoded using abi.encode or one of its variants).
657      */
658     function callOptionalReturn(IERC20 token, bytes memory data) private {
659         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
660         // we're implementing it ourselves.
661 
662         // A Solidity high level call has three parts:
663         //  1. The target address is checked to verify it contains contract code
664         //  2. The call itself is made, and success asserted
665         //  3. The return value is decoded, which in turn checks the size of the returned data.
666         // solhint-disable-next-line max-line-length
667         require(address(token).isContract(), "SafeERC20: call to non-contract");
668 
669         // solhint-disable-next-line avoid-low-level-calls
670         (bool success, bytes memory returndata) = address(token).call(data);
671         require(success, "SafeERC20: low-level call failed");
672 
673         if (returndata.length > 0) { // Return data is optional
674             // solhint-disable-next-line max-line-length
675             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
676         }
677     }
678 }
679 
680 // File: contracts/utils/ERC20Detailed.sol
681 
682 //SPDX-License-Identifier: MIT
683 
684 pragma solidity ^0.5.12;
685 
686 
687 contract ERC20Detailed is IERC20 {
688     string private _name;
689     string private _symbol;
690     uint8 private _decimals;
691 
692     constructor(
693         string memory name,
694         string memory symbol,
695         uint8 decimals
696     ) public {
697         _name = name;
698         _symbol = symbol;
699         _decimals = decimals;
700     }
701 
702     function name() public view returns (string memory) {
703         return _name;
704     }
705 
706     function symbol() public view returns (string memory) {
707         return _symbol;
708     }
709 
710     function decimals() public view returns (uint8) {
711         return _decimals;
712     }
713 }
714 
715 // File: contracts/utils/PermissionGroups.sol
716 
717 //SPDX-License-Identifier: MIT
718 
719 pragma solidity ^0.5.12;
720 
721 contract PermissionGroups {
722     address public admin;
723     address public pendingAdmin;
724     mapping(address => bool) internal operators;
725     address[] internal operatorsGroup;
726     uint256 internal constant MAX_GROUP_SIZE = 50;
727 
728     constructor(address _admin) public {
729         require(_admin != address(0), "Admin 0");
730         admin = _admin;
731     }
732 
733     modifier onlyAdmin() {
734         require(msg.sender == admin, "Only admin");
735         _;
736     }
737 
738     modifier onlyOperator() {
739         require(operators[msg.sender], "Only operator");
740         _;
741     }
742 
743     function getOperators() external view returns (address[] memory) {
744         return operatorsGroup;
745     }
746 
747     event TransferAdminPending(address pendingAdmin);
748 
749     /**
750      * @dev Allows the current admin to set the pendingAdmin address.
751      * @param newAdmin The address to transfer ownership to.
752      */
753     function transferAdmin(address newAdmin) public onlyAdmin {
754         require(newAdmin != address(0), "New admin 0");
755         emit TransferAdminPending(newAdmin);
756         pendingAdmin = newAdmin;
757     }
758 
759     /**
760      * @dev Allows the current admin to set the admin in one tx. Useful initial deployment.
761      * @param newAdmin The address to transfer ownership to.
762      */
763     function transferAdminQuickly(address newAdmin) public onlyAdmin {
764         require(newAdmin != address(0), "Admin 0");
765         emit TransferAdminPending(newAdmin);
766         emit AdminClaimed(newAdmin, admin);
767         admin = newAdmin;
768     }
769 
770     event AdminClaimed(address newAdmin, address previousAdmin);
771 
772     /**
773      * @dev Allows the pendingAdmin address to finalize the change admin process.
774      */
775     function claimAdmin() public {
776         require(pendingAdmin == msg.sender, "not pending");
777         emit AdminClaimed(pendingAdmin, admin);
778         admin = pendingAdmin;
779         pendingAdmin = address(0);
780     }
781 
782     event OperatorAdded(address newOperator, bool isAdd);
783 
784     function addOperator(address newOperator) public onlyAdmin {
785         require(!operators[newOperator], "Operator exists"); // prevent duplicates.
786         require(operatorsGroup.length < MAX_GROUP_SIZE, "Max operators");
787 
788         emit OperatorAdded(newOperator, true);
789         operators[newOperator] = true;
790         operatorsGroup.push(newOperator);
791     }
792 
793     function removeOperator(address operator) public onlyAdmin {
794         require(operators[operator], "Not operator");
795         operators[operator] = false;
796 
797         for (uint256 i = 0; i < operatorsGroup.length; ++i) {
798             if (operatorsGroup[i] == operator) {
799                 operatorsGroup[i] = operatorsGroup[operatorsGroup.length - 1];
800                 operatorsGroup.pop();
801                 emit OperatorAdded(operator, false);
802                 break;
803             }
804         }
805     }
806 }
807 
808 // File: contracts/utils/Withdrawable.sol
809 
810 //SPDX-License-Identifier: MIT
811 
812 pragma solidity ^0.5.12;
813 
814 
815 
816 contract Withdrawable is PermissionGroups {
817     mapping(address => bool) internal blacklist;
818 
819     event TokenWithdraw(IERC20 token, uint256 amount, address sendTo);
820 
821     event EtherWithdraw(uint256 amount, address sendTo);
822 
823     constructor(address _admin) public PermissionGroups(_admin) {}
824 
825     /**
826      * @dev Withdraw all IERC20 compatible tokens
827      * @param token IERC20 The address of the token contract
828      */
829     function withdrawToken(
830         IERC20 token,
831         uint256 amount,
832         address sendTo
833     ) external onlyAdmin {
834         require(!blacklist[address(token)], "forbid to withdraw that token");
835         token.transfer(sendTo, amount);
836         emit TokenWithdraw(token, amount, sendTo);
837     }
838 
839     /**
840      * @dev Withdraw Ethers
841      */
842     function withdrawEther(uint256 amount, address payable sendTo) external onlyAdmin {
843         (bool success, ) = sendTo.call.value(amount)("");
844         require(success);
845         emit EtherWithdraw(amount, sendTo);
846     }
847 
848     function setBlackList(address token) internal {
849         blacklist[token] = true;
850     }
851 }
852 
853 // File: contracts/GoddessToken.sol
854 
855 //SPDX-License-Identifier: MIT
856 
857 pragma solidity ^0.5.12;
858 
859 
860 
861 
862 
863 
864 contract GoddessToken is ERC20, ERC20Detailed, ERC20Burnable, Withdrawable {
865     using SafeERC20 for IERC20;
866     using Address for address;
867     using SafeMath for uint256;
868 
869     constructor() public ERC20Detailed("Goddess Token", "GDS", 18) Withdrawable(msg.sender) {
870         _mint(msg.sender, 1e24);
871     }
872 }