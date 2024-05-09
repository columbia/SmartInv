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
501 // File: @openzeppelin/contracts/utils/Address.sol
502 
503 pragma solidity ^0.5.5;
504 
505 /**
506  * @dev Collection of functions related to the address type
507  */
508 library Address {
509     /**
510      * @dev Returns true if `account` is a contract.
511      *
512      * [IMPORTANT]
513      * ====
514      * It is unsafe to assume that an address for which this function returns
515      * false is an externally-owned account (EOA) and not a contract.
516      *
517      * Among others, `isContract` will return false for the following 
518      * types of addresses:
519      *
520      *  - an externally-owned account
521      *  - a contract in construction
522      *  - an address where a contract will be created
523      *  - an address where a contract lived, but was destroyed
524      * ====
525      */
526     function isContract(address account) internal view returns (bool) {
527         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
528         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
529         // for accounts without code, i.e. `keccak256('')`
530         bytes32 codehash;
531         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
532         // solhint-disable-next-line no-inline-assembly
533         assembly { codehash := extcodehash(account) }
534         return (codehash != accountHash && codehash != 0x0);
535     }
536 
537     /**
538      * @dev Converts an `address` into `address payable`. Note that this is
539      * simply a type cast: the actual underlying value is not changed.
540      *
541      * _Available since v2.4.0._
542      */
543     function toPayable(address account) internal pure returns (address payable) {
544         return address(uint160(account));
545     }
546 
547     /**
548      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
549      * `recipient`, forwarding all available gas and reverting on errors.
550      *
551      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
552      * of certain opcodes, possibly making contracts go over the 2300 gas limit
553      * imposed by `transfer`, making them unable to receive funds via
554      * `transfer`. {sendValue} removes this limitation.
555      *
556      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
557      *
558      * IMPORTANT: because control is transferred to `recipient`, care must be
559      * taken to not create reentrancy vulnerabilities. Consider using
560      * {ReentrancyGuard} or the
561      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
562      *
563      * _Available since v2.4.0._
564      */
565     function sendValue(address payable recipient, uint256 amount) internal {
566         require(address(this).balance >= amount, "Address: insufficient balance");
567 
568         // solhint-disable-next-line avoid-call-value
569         (bool success, ) = recipient.call.value(amount)("");
570         require(success, "Address: unable to send value, recipient may have reverted");
571     }
572 }
573 
574 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
575 
576 pragma solidity ^0.5.0;
577 
578 
579 
580 
581 /**
582  * @title SafeERC20
583  * @dev Wrappers around ERC20 operations that throw on failure (when the token
584  * contract returns false). Tokens that return no value (and instead revert or
585  * throw on failure) are also supported, non-reverting calls are assumed to be
586  * successful.
587  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
588  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
589  */
590 library SafeERC20 {
591     using SafeMath for uint256;
592     using Address for address;
593 
594     function safeTransfer(IERC20 token, address to, uint256 value) internal {
595         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
596     }
597 
598     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
599         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
600     }
601 
602     function safeApprove(IERC20 token, address spender, uint256 value) internal {
603         // safeApprove should only be called when setting an initial allowance,
604         // or when resetting it to zero. To increase and decrease it, use
605         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
606         // solhint-disable-next-line max-line-length
607         require((value == 0) || (token.allowance(address(this), spender) == 0),
608             "SafeERC20: approve from non-zero to non-zero allowance"
609         );
610         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
611     }
612 
613     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
614         uint256 newAllowance = token.allowance(address(this), spender).add(value);
615         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
616     }
617 
618     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
619         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
620         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
621     }
622 
623     /**
624      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
625      * on the return value: the return value is optional (but if data is returned, it must not be false).
626      * @param token The token targeted by the call.
627      * @param data The call data (encoded using abi.encode or one of its variants).
628      */
629     function callOptionalReturn(IERC20 token, bytes memory data) private {
630         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
631         // we're implementing it ourselves.
632 
633         // A Solidity high level call has three parts:
634         //  1. The target address is checked to verify it contains contract code
635         //  2. The call itself is made, and success asserted
636         //  3. The return value is decoded, which in turn checks the size of the returned data.
637         // solhint-disable-next-line max-line-length
638         require(address(token).isContract(), "SafeERC20: call to non-contract");
639 
640         // solhint-disable-next-line avoid-low-level-calls
641         (bool success, bytes memory returndata) = address(token).call(data);
642         require(success, "SafeERC20: low-level call failed");
643 
644         if (returndata.length > 0) { // Return data is optional
645             // solhint-disable-next-line max-line-length
646             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
647         }
648     }
649 }
650 
651 // File: contracts/PepemonStore.sol
652 
653 pragma solidity ^0.5.0;
654 
655 
656 
657 
658 /**
659  * @dev Standard math utilities missing in the Solidity language.
660  */
661 library Math {
662     /**
663      * @dev Returns the largest of two numbers.
664      */
665     function max(uint256 a, uint256 b) internal pure returns (uint256) {
666         return a >= b ? a : b;
667     }
668 
669     /**
670      * @dev Returns the smallest of two numbers.
671      */
672     function min(uint256 a, uint256 b) internal pure returns (uint256) {
673         return a < b ? a : b;
674     }
675 
676     /**
677      * @dev Returns the average of two numbers. The result is rounded towards
678      * zero.
679      */
680     function average(uint256 a, uint256 b) internal pure returns (uint256) {
681         // (a + b) / 2 can overflow, so we distribute
682         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
683     }
684 }
685 
686 /**
687  * @dev Contract module which provides a basic access control mechanism, where
688  * there is an account (an owner) that can be granted exclusive access to
689  * specific functions.
690  *
691  * This module is used through inheritance. It will make available the modifier
692  * `onlyOwner`, which can be applied to your functions to restrict their use to
693  * the owner.
694  */
695 contract Ownable is Context {
696     address private _owner;
697 
698     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
699 
700     /**
701      * @dev Initializes the contract setting the deployer as the initial owner.
702      */
703     constructor () internal {
704         address msgSender = _msgSender();
705         _owner = msgSender;
706         emit OwnershipTransferred(address(0), msgSender);
707     }
708 
709     /**
710      * @dev Returns the address of the current owner.
711      */
712     function owner() public view returns (address) {
713         return _owner;
714     }
715 
716     /**
717      * @dev Throws if called by any account other than the owner.
718      */
719     modifier onlyOwner() {
720         require(isOwner(), "Ownable: caller is not the owner");
721         _;
722     }
723 
724     /**
725      * @dev Returns true if the caller is the current owner.
726      */
727     function isOwner() public view returns (bool) {
728         return _msgSender() == _owner;
729     }
730 
731     /**
732      * @dev Leaves the contract without owner. It will not be possible to call
733      * `onlyOwner` functions anymore. Can only be called by the current owner.
734      *
735      * NOTE: Renouncing ownership will leave the contract without an owner,
736      * thereby removing any functionality that is only available to the owner.
737      */
738     function renounceOwnership() public onlyOwner {
739         emit OwnershipTransferred(_owner, address(0));
740         _owner = address(0);
741     }
742 
743     /**
744      * @dev Transfers ownership of the contract to a new account (`newOwner`).
745      * Can only be called by the current owner.
746      */
747     function transferOwnership(address newOwner) public onlyOwner {
748         _transferOwnership(newOwner);
749     }
750 
751     /**
752      * @dev Transfers ownership of the contract to a new account (`newOwner`).
753      */
754     function _transferOwnership(address newOwner) internal {
755         require(newOwner != address(0), "Ownable: new owner is the zero address");
756         emit OwnershipTransferred(_owner, newOwner);
757         _owner = newOwner;
758     }
759 }
760 
761 /**
762  * @title Roles
763  * @dev Library for managing addresses assigned to a Role.
764  */
765 library Roles {
766     struct Role {
767         mapping (address => bool) bearer;
768     }
769 
770     /**
771      * @dev Give an account access to this role.
772      */
773     function add(Role storage role, address account) internal {
774         require(!has(role, account), "Roles: account already has role");
775         role.bearer[account] = true;
776     }
777 
778     /**
779      * @dev Remove an account's access to this role.
780      */
781     function remove(Role storage role, address account) internal {
782         require(has(role, account), "Roles: account does not have role");
783         role.bearer[account] = false;
784     }
785 
786     /**
787      * @dev Check if an account has this role.
788      * @return bool
789      */
790     function has(Role storage role, address account) internal view returns (bool) {
791         require(account != address(0), "Roles: account is the zero address");
792         return role.bearer[account];
793     }
794 }
795 
796 contract MinterRole is Context {
797     using Roles for Roles.Role;
798 
799     event MinterAdded(address indexed account);
800     event MinterRemoved(address indexed account);
801 
802     Roles.Role private _minters;
803 
804     constructor () internal {
805         _addMinter(_msgSender());
806     }
807 
808     modifier onlyMinter() {
809         require(isMinter(_msgSender()), "MinterRole: caller does not have the Minter role");
810         _;
811     }
812 
813     function isMinter(address account) public view returns (bool) {
814         return _minters.has(account);
815     }
816 
817     function addMinter(address account) public onlyMinter {
818         _addMinter(account);
819     }
820 
821     function renounceMinter() public {
822         _removeMinter(_msgSender());
823     }
824 
825     function _addMinter(address account) internal {
826         _minters.add(account);
827         emit MinterAdded(account);
828     }
829 
830     function _removeMinter(address account) internal {
831         _minters.remove(account);
832         emit MinterRemoved(account);
833     }
834 }
835 
836 /**
837  * @title WhitelistAdminRole
838  * @dev WhitelistAdmins are responsible for assigning and removing Whitelisted accounts.
839  */
840 contract WhitelistAdminRole is Context {
841     using Roles for Roles.Role;
842 
843     event WhitelistAdminAdded(address indexed account);
844     event WhitelistAdminRemoved(address indexed account);
845 
846     Roles.Role private _whitelistAdmins;
847 
848     constructor () internal {
849         _addWhitelistAdmin(_msgSender());
850     }
851 
852     modifier onlyWhitelistAdmin() {
853         require(isWhitelistAdmin(_msgSender()), "WhitelistAdminRole: caller does not have the WhitelistAdmin role");
854         _;
855     }
856 
857     function isWhitelistAdmin(address account) public view returns (bool) {
858         return _whitelistAdmins.has(account);
859     }
860 
861     function addWhitelistAdmin(address account) public onlyWhitelistAdmin {
862         _addWhitelistAdmin(account);
863     }
864 
865     function renounceWhitelistAdmin() public {
866         _removeWhitelistAdmin(_msgSender());
867     }
868 
869     function _addWhitelistAdmin(address account) internal {
870         _whitelistAdmins.add(account);
871         emit WhitelistAdminAdded(account);
872     }
873 
874     function _removeWhitelistAdmin(address account) internal {
875         _whitelistAdmins.remove(account);
876         emit WhitelistAdminRemoved(account);
877     }
878 }
879 
880 /**
881  * @title ERC165
882  * @dev https://github.com/ethereum/EIPs/blob/master/EIPS/eip-165.md
883  */
884 interface IERC165 {
885 
886     /**
887      * @notice Query if a contract implements an interface
888      * @dev Interface identification is specified in ERC-165. This function
889      * uses less than 30,000 gas
890      * @param _interfaceId The interface identifier, as specified in ERC-165
891      */
892     function supportsInterface(bytes4 _interfaceId)
893     external
894     view
895     returns (bool);
896 }
897 
898 /**
899  * @dev ERC-1155 interface for accepting safe transfers.
900  */
901 interface IERC1155TokenReceiver {
902 
903     /**
904      * @notice Handle the receipt of a single ERC1155 token type
905      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeTransferFrom` after the balance has been updated
906      * This function MAY throw to revert and reject the transfer
907      * Return of other amount than the magic value MUST result in the transaction being reverted
908      * Note: The token contract address is always the message sender
909      * @param _operator  The address which called the `safeTransferFrom` function
910      * @param _from      The address which previously owned the token
911      * @param _id        The id of the token being transferred
912      * @param _amount    The amount of tokens being transferred
913      * @param _data      Additional data with no specified format
914      * @return           `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
915      */
916     function onERC1155Received(address _operator, address _from, uint256 _id, uint256 _amount, bytes calldata _data) external returns(bytes4);
917 
918     /**
919      * @notice Handle the receipt of multiple ERC1155 token types
920      * @dev An ERC1155-compliant smart contract MUST call this function on the token recipient contract, at the end of a `safeBatchTransferFrom` after the balances have been updated
921      * This function MAY throw to revert and reject the transfer
922      * Return of other amount than the magic value WILL result in the transaction being reverted
923      * Note: The token contract address is always the message sender
924      * @param _operator  The address which called the `safeBatchTransferFrom` function
925      * @param _from      The address which previously owned the token
926      * @param _ids       An array containing ids of each token being transferred
927      * @param _amounts   An array containing amounts of each token being transferred
928      * @param _data      Additional data with no specified format
929      * @return           `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
930      */
931     function onERC1155BatchReceived(address _operator, address _from, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external returns(bytes4);
932 
933     /**
934      * @notice Indicates whether a contract implements the `ERC1155TokenReceiver` functions and so can accept ERC1155 token types.
935      * @param  interfaceID The ERC-165 interface ID that is queried for support.s
936      * @dev This function MUST return true if it implements the ERC1155TokenReceiver interface and ERC-165 interface.
937      *      This function MUST NOT consume more than 5,000 gas.
938      * @return Wheter ERC-165 or ERC1155TokenReceiver interfaces are supported.
939      */
940     function supportsInterface(bytes4 interfaceID) external view returns (bool);
941 
942 }
943 
944 interface IERC1155 {
945     // Events
946 
947     /**
948      * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
949      *   Operator MUST be msg.sender
950      *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
951      *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
952      *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
953      *   To broadcast the existence of a token ID with no initial balance, the contract SHOULD emit the TransferSingle event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
954      */
955     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
956 
957     /**
958      * @dev Either TransferSingle or TransferBatch MUST emit when tokens are transferred, including zero amount transfers as well as minting or burning
959      *   Operator MUST be msg.sender
960      *   When minting/creating tokens, the `_from` field MUST be set to `0x0`
961      *   When burning/destroying tokens, the `_to` field MUST be set to `0x0`
962      *   The total amount transferred from address 0x0 minus the total amount transferred to 0x0 may be used by clients and exchanges to be added to the "circulating supply" for a given token ID
963      *   To broadcast the existence of multiple token IDs with no initial balance, this SHOULD emit the TransferBatch event from `0x0` to `0x0`, with the token creator as `_operator`, and a `_amount` of 0
964      */
965     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
966 
967     /**
968      * @dev MUST emit when an approval is updated
969      */
970     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
971 
972     /**
973      * @dev MUST emit when the URI is updated for a token ID
974      *   URIs are defined in RFC 3986
975      *   The URI MUST point a JSON file that conforms to the "ERC-1155 Metadata JSON Schema"
976      */
977     event URI(string _amount, uint256 indexed _id);
978 
979     /**
980      * @notice Transfers amount of an _id from the _from address to the _to address specified
981      * @dev MUST emit TransferSingle event on success
982      * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
983      * MUST throw if `_to` is the zero address
984      * MUST throw if balance of sender for token `_id` is lower than the `_amount` sent
985      * MUST throw on any other error
986      * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155Received` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
987      * @param _from    Source address
988      * @param _to      Target address
989      * @param _id      ID of the token type
990      * @param _amount  Transfered amount
991      * @param _data    Additional data with no specified format, sent in call to `_to`
992      */
993     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes calldata _data) external;
994 
995     /**
996      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
997      * @dev MUST emit TransferBatch event on success
998      * Caller must be approved to manage the _from account's tokens (see isApprovedForAll)
999      * MUST throw if `_to` is the zero address
1000      * MUST throw if length of `_ids` is not the same as length of `_amounts`
1001      * MUST throw if any of the balance of sender for token `_ids` is lower than the respective `_amounts` sent
1002      * MUST throw on any other error
1003      * When transfer is complete, this function MUST check if `_to` is a smart contract (code size > 0). If so, it MUST call `onERC1155BatchReceived` on `_to` and revert if the return amount is not `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1004      * Transfers and events MUST occur in the array order they were submitted (_ids[0] before _ids[1], etc)
1005      * @param _from     Source addresses
1006      * @param _to       Target addresses
1007      * @param _ids      IDs of each token type
1008      * @param _amounts  Transfer amounts per token type
1009      * @param _data     Additional data with no specified format, sent in call to `_to`
1010     */
1011     function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _ids, uint256[] calldata _amounts, bytes calldata _data) external;
1012 
1013     /**
1014      * @notice Get the balance of an account's Tokens
1015      * @param _owner  The address of the token holder
1016      * @param _id     ID of the Token
1017      * @return        The _owner's balance of the Token type requested
1018      */
1019     function balanceOf(address _owner, uint256 _id) external view returns (uint256);
1020 
1021     /**
1022      * @notice Get the balance of multiple account/token pairs
1023      * @param _owners The addresses of the token holders
1024      * @param _ids    ID of the Tokens
1025      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
1026      */
1027     function balanceOfBatch(address[] calldata _owners, uint256[] calldata _ids) external view returns (uint256[] memory);
1028 
1029     /**
1030      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
1031      * @dev MUST emit the ApprovalForAll event on success
1032      * @param _operator  Address to add to the set of authorized operators
1033      * @param _approved  True if the operator is approved, false to revoke approval
1034      */
1035     function setApprovalForAll(address _operator, bool _approved) external;
1036 
1037     /**
1038      * @notice Queries the approval status of an operator for a given owner
1039      * @param _owner     The owner of the Tokens
1040      * @param _operator  Address of authorized operator
1041      * @return           True if the operator is approved, false if not
1042      */
1043     function isApprovedForAll(address _owner, address _operator) external view returns (bool isOperator);
1044 
1045 }
1046 
1047 /**
1048  * @dev Implementation of Multi-Token Standard contract
1049  */
1050 contract ERC1155 is IERC165 {
1051     using SafeMath for uint256;
1052     using Address for address;
1053 
1054 
1055     /***********************************|
1056     |        Variables and Events       |
1057     |__________________________________*/
1058 
1059     // onReceive function signatures
1060     bytes4 constant internal ERC1155_RECEIVED_VALUE = 0xf23a6e61;
1061     bytes4 constant internal ERC1155_BATCH_RECEIVED_VALUE = 0xbc197c81;
1062 
1063     // Objects balances
1064     mapping (address => mapping(uint256 => uint256)) internal balances;
1065 
1066     // Operator Functions
1067     mapping (address => mapping(address => bool)) internal operators;
1068 
1069     // Events
1070     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _amount);
1071     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _amounts);
1072     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
1073     event URI(string _uri, uint256 indexed _id);
1074 
1075 
1076     /***********************************|
1077     |     Public Transfer Functions     |
1078     |__________________________________*/
1079 
1080     /**
1081      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
1082      * @param _from    Source address
1083      * @param _to      Target address
1084      * @param _id      ID of the token type
1085      * @param _amount  Transfered amount
1086      * @param _data    Additional data with no specified format, sent in call to `_to`
1087      */
1088     function safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
1089     public
1090     {
1091         require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeTransferFrom: INVALID_OPERATOR");
1092         require(_to != address(0),"ERC1155#safeTransferFrom: INVALID_RECIPIENT");
1093         // require(_amount >= balances[_from][_id]) is not necessary since checked with safemath operations
1094 
1095         _safeTransferFrom(_from, _to, _id, _amount);
1096         _callonERC1155Received(_from, _to, _id, _amount, _data);
1097     }
1098 
1099     /**
1100      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
1101      * @param _from     Source addresses
1102      * @param _to       Target addresses
1103      * @param _ids      IDs of each token type
1104      * @param _amounts  Transfer amounts per token type
1105      * @param _data     Additional data with no specified format, sent in call to `_to`
1106      */
1107     function safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
1108     public
1109     {
1110         // Requirements
1111         require((msg.sender == _from) || isApprovedForAll(_from, msg.sender), "ERC1155#safeBatchTransferFrom: INVALID_OPERATOR");
1112         require(_to != address(0), "ERC1155#safeBatchTransferFrom: INVALID_RECIPIENT");
1113 
1114         _safeBatchTransferFrom(_from, _to, _ids, _amounts);
1115         _callonERC1155BatchReceived(_from, _to, _ids, _amounts, _data);
1116     }
1117 
1118 
1119     /***********************************|
1120     |    Internal Transfer Functions    |
1121     |__________________________________*/
1122 
1123     /**
1124      * @notice Transfers amount amount of an _id from the _from address to the _to address specified
1125      * @param _from    Source address
1126      * @param _to      Target address
1127      * @param _id      ID of the token type
1128      * @param _amount  Transfered amount
1129      */
1130     function _safeTransferFrom(address _from, address _to, uint256 _id, uint256 _amount)
1131     internal
1132     {
1133         // Update balances
1134         balances[_from][_id] = balances[_from][_id].sub(_amount); // Subtract amount
1135         balances[_to][_id] = balances[_to][_id].add(_amount);     // Add amount
1136 
1137         // Emit event
1138         emit TransferSingle(msg.sender, _from, _to, _id, _amount);
1139     }
1140 
1141     /**
1142      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155Received(...)
1143      */
1144     function _callonERC1155Received(address _from, address _to, uint256 _id, uint256 _amount, bytes memory _data)
1145     internal
1146     {
1147         // Check if recipient is contract
1148         if (_to.isContract()) {
1149             bytes4 retval = IERC1155TokenReceiver(_to).onERC1155Received(msg.sender, _from, _id, _amount, _data);
1150             require(retval == ERC1155_RECEIVED_VALUE, "ERC1155#_callonERC1155Received: INVALID_ON_RECEIVE_MESSAGE");
1151         }
1152     }
1153 
1154     /**
1155      * @notice Send multiple types of Tokens from the _from address to the _to address (with safety call)
1156      * @param _from     Source addresses
1157      * @param _to       Target addresses
1158      * @param _ids      IDs of each token type
1159      * @param _amounts  Transfer amounts per token type
1160      */
1161     function _safeBatchTransferFrom(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts)
1162     internal
1163     {
1164         require(_ids.length == _amounts.length, "ERC1155#_safeBatchTransferFrom: INVALID_ARRAYS_LENGTH");
1165 
1166         // Number of transfer to execute
1167         uint256 nTransfer = _ids.length;
1168 
1169         // Executing all transfers
1170         for (uint256 i = 0; i < nTransfer; i++) {
1171             // Update storage balance of previous bin
1172             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
1173             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
1174         }
1175 
1176         // Emit event
1177         emit TransferBatch(msg.sender, _from, _to, _ids, _amounts);
1178     }
1179 
1180     /**
1181      * @notice Verifies if receiver is contract and if so, calls (_to).onERC1155BatchReceived(...)
1182      */
1183     function _callonERC1155BatchReceived(address _from, address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
1184     internal
1185     {
1186         // Pass data if recipient is contract
1187         if (_to.isContract()) {
1188             bytes4 retval = IERC1155TokenReceiver(_to).onERC1155BatchReceived(msg.sender, _from, _ids, _amounts, _data);
1189             require(retval == ERC1155_BATCH_RECEIVED_VALUE, "ERC1155#_callonERC1155BatchReceived: INVALID_ON_RECEIVE_MESSAGE");
1190         }
1191     }
1192 
1193 
1194     /***********************************|
1195     |         Operator Functions        |
1196     |__________________________________*/
1197 
1198     /**
1199      * @notice Enable or disable approval for a third party ("operator") to manage all of caller's tokens
1200      * @param _operator  Address to add to the set of authorized operators
1201      * @param _approved  True if the operator is approved, false to revoke approval
1202      */
1203     function setApprovalForAll(address _operator, bool _approved)
1204     external
1205     {
1206         // Update operator status
1207         operators[msg.sender][_operator] = _approved;
1208         emit ApprovalForAll(msg.sender, _operator, _approved);
1209     }
1210 
1211     /**
1212      * @notice Queries the approval status of an operator for a given owner
1213      * @param _owner     The owner of the Tokens
1214      * @param _operator  Address of authorized operator
1215      * @return True if the operator is approved, false if not
1216      */
1217     function isApprovedForAll(address _owner, address _operator)
1218     public view returns (bool isOperator)
1219     {
1220         return operators[_owner][_operator];
1221     }
1222 
1223 
1224     /***********************************|
1225     |         Balance Functions         |
1226     |__________________________________*/
1227 
1228     /**
1229      * @notice Get the balance of an account's Tokens
1230      * @param _owner  The address of the token holder
1231      * @param _id     ID of the Token
1232      * @return The _owner's balance of the Token type requested
1233      */
1234     function balanceOf(address _owner, uint256 _id)
1235     public view returns (uint256)
1236     {
1237         return balances[_owner][_id];
1238     }
1239 
1240     /**
1241      * @notice Get the balance of multiple account/token pairs
1242      * @param _owners The addresses of the token holders
1243      * @param _ids    ID of the Tokens
1244      * @return        The _owner's balance of the Token types requested (i.e. balance for each (owner, id) pair)
1245      */
1246     function balanceOfBatch(address[] memory _owners, uint256[] memory _ids)
1247     public view returns (uint256[] memory)
1248     {
1249         require(_owners.length == _ids.length, "ERC1155#balanceOfBatch: INVALID_ARRAY_LENGTH");
1250 
1251         // Variables
1252         uint256[] memory batchBalances = new uint256[](_owners.length);
1253 
1254         // Iterate over each owner and token ID
1255         for (uint256 i = 0; i < _owners.length; i++) {
1256             batchBalances[i] = balances[_owners[i]][_ids[i]];
1257         }
1258 
1259         return batchBalances;
1260     }
1261 
1262 
1263     /***********************************|
1264     |          ERC165 Functions         |
1265     |__________________________________*/
1266 
1267     /**
1268      * INTERFACE_SIGNATURE_ERC165 = bytes4(keccak256("supportsInterface(bytes4)"));
1269      */
1270     bytes4 constant private INTERFACE_SIGNATURE_ERC165 = 0x01ffc9a7;
1271 
1272     /**
1273      * INTERFACE_SIGNATURE_ERC1155 =
1274      * bytes4(keccak256("safeTransferFrom(address,address,uint256,uint256,bytes)")) ^
1275      * bytes4(keccak256("safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)")) ^
1276      * bytes4(keccak256("balanceOf(address,uint256)")) ^
1277      * bytes4(keccak256("balanceOfBatch(address[],uint256[])")) ^
1278      * bytes4(keccak256("setApprovalForAll(address,bool)")) ^
1279      * bytes4(keccak256("isApprovedForAll(address,address)"));
1280      */
1281     bytes4 constant private INTERFACE_SIGNATURE_ERC1155 = 0xd9b67a26;
1282 
1283     /**
1284      * @notice Query if a contract implements an interface
1285      * @param _interfaceID  The interface identifier, as specified in ERC-165
1286      * @return `true` if the contract implements `_interfaceID` and
1287      */
1288     function supportsInterface(bytes4 _interfaceID) external view returns (bool) {
1289         if (_interfaceID == INTERFACE_SIGNATURE_ERC165 ||
1290             _interfaceID == INTERFACE_SIGNATURE_ERC1155) {
1291             return true;
1292         }
1293         return false;
1294     }
1295 
1296 }
1297 
1298 /**
1299  * @notice Contract that handles metadata related methods.
1300  * @dev Methods assume a deterministic generation of URI based on token IDs.
1301  *      Methods also assume that URI uses hex representation of token IDs.
1302  */
1303 contract ERC1155Metadata {
1304 
1305     // URI's default URI prefix
1306     string internal baseMetadataURI;
1307     event URI(string _uri, uint256 indexed _id);
1308 
1309 
1310     /***********************************|
1311     |     Metadata Public Function s    |
1312     |__________________________________*/
1313 
1314     /**
1315      * @notice A distinct Uniform Resource Identifier (URI) for a given token.
1316      * @dev URIs are defined in RFC 3986.
1317      *      URIs are assumed to be deterministically generated based on token ID
1318      *      Token IDs are assumed to be represented in their hex format in URIs
1319      * @return URI string
1320      */
1321     function uri(uint256 _id) public view returns (string memory) {
1322         return string(abi.encodePacked(baseMetadataURI, _uint2str(_id), ".json"));
1323     }
1324 
1325 
1326     /***********************************|
1327     |    Metadata Internal Functions    |
1328     |__________________________________*/
1329 
1330     /**
1331      * @notice Will emit default URI log event for corresponding token _id
1332      * @param _tokenIDs Array of IDs of tokens to log default URI
1333      */
1334     function _logURIs(uint256[] memory _tokenIDs) internal {
1335         string memory baseURL = baseMetadataURI;
1336         string memory tokenURI;
1337 
1338         for (uint256 i = 0; i < _tokenIDs.length; i++) {
1339             tokenURI = string(abi.encodePacked(baseURL, _uint2str(_tokenIDs[i]), ".json"));
1340             emit URI(tokenURI, _tokenIDs[i]);
1341         }
1342     }
1343 
1344     /**
1345      * @notice Will emit a specific URI log event for corresponding token
1346      * @param _tokenIDs IDs of the token corresponding to the _uris logged
1347      * @param _URIs    The URIs of the specified _tokenIDs
1348      */
1349     function _logURIs(uint256[] memory _tokenIDs, string[] memory _URIs) internal {
1350         require(_tokenIDs.length == _URIs.length, "ERC1155Metadata#_logURIs: INVALID_ARRAYS_LENGTH");
1351         for (uint256 i = 0; i < _tokenIDs.length; i++) {
1352             emit URI(_URIs[i], _tokenIDs[i]);
1353         }
1354     }
1355 
1356     /**
1357      * @notice Will update the base URL of token's URI
1358      * @param _newBaseMetadataURI New base URL of token's URI
1359      */
1360     function _setBaseMetadataURI(string memory _newBaseMetadataURI) internal {
1361         baseMetadataURI = _newBaseMetadataURI;
1362     }
1363 
1364 
1365     /***********************************|
1366     |    Utility Internal Functions     |
1367     |__________________________________*/
1368 
1369     /**
1370      * @notice Convert uint256 to string
1371      * @param _i Unsigned integer to convert to string
1372      */
1373     function _uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1374         if (_i == 0) {
1375             return "0";
1376         }
1377 
1378         uint256 j = _i;
1379         uint256 ii = _i;
1380         uint256 len;
1381 
1382         // Get number of bytes
1383         while (j != 0) {
1384             len++;
1385             j /= 10;
1386         }
1387 
1388         bytes memory bstr = new bytes(len);
1389         uint256 k = len - 1;
1390 
1391         // Get each individual ASCII
1392         while (ii != 0) {
1393             bstr[k--] = byte(uint8(48 + ii % 10));
1394             ii /= 10;
1395         }
1396 
1397         // Convert to string
1398         return string(bstr);
1399     }
1400 
1401 }
1402 
1403 /**
1404  * @dev Multi-Fungible Tokens with minting and burning methods. These methods assume
1405  *      a parent contract to be executed as they are `internal` functions
1406  */
1407 contract ERC1155MintBurn is ERC1155 {
1408 
1409 
1410     /****************************************|
1411     |            Minting Functions           |
1412     |_______________________________________*/
1413 
1414     /**
1415      * @notice Mint _amount of tokens of a given id
1416      * @param _to      The address to mint tokens to
1417      * @param _id      Token id to mint
1418      * @param _amount  The amount to be minted
1419      * @param _data    Data to pass if receiver is contract
1420      */
1421     function _mint(address _to, uint256 _id, uint256 _amount, bytes memory _data)
1422     internal
1423     {
1424         // Add _amount
1425         balances[_to][_id] = balances[_to][_id].add(_amount);
1426 
1427         // Emit event
1428         emit TransferSingle(msg.sender, address(0x0), _to, _id, _amount);
1429 
1430         // Calling onReceive method if recipient is contract
1431         _callonERC1155Received(address(0x0), _to, _id, _amount, _data);
1432     }
1433 
1434     /**
1435      * @notice Mint tokens for each ids in _ids
1436      * @param _to       The address to mint tokens to
1437      * @param _ids      Array of ids to mint
1438      * @param _amounts  Array of amount of tokens to mint per id
1439      * @param _data    Data to pass if receiver is contract
1440      */
1441     function _batchMint(address _to, uint256[] memory _ids, uint256[] memory _amounts, bytes memory _data)
1442     internal
1443     {
1444         require(_ids.length == _amounts.length, "ERC1155MintBurn#batchMint: INVALID_ARRAYS_LENGTH");
1445 
1446         // Number of mints to execute
1447         uint256 nMint = _ids.length;
1448 
1449         // Executing all minting
1450         for (uint256 i = 0; i < nMint; i++) {
1451             // Update storage balance
1452             balances[_to][_ids[i]] = balances[_to][_ids[i]].add(_amounts[i]);
1453         }
1454 
1455         // Emit batch mint event
1456         emit TransferBatch(msg.sender, address(0x0), _to, _ids, _amounts);
1457 
1458         // Calling onReceive method if recipient is contract
1459         _callonERC1155BatchReceived(address(0x0), _to, _ids, _amounts, _data);
1460     }
1461 
1462 
1463     /****************************************|
1464     |            Burning Functions           |
1465     |_______________________________________*/
1466 
1467     /**
1468      * @notice Burn _amount of tokens of a given token id
1469      * @param _from    The address to burn tokens from
1470      * @param _id      Token id to burn
1471      * @param _amount  The amount to be burned
1472      */
1473     function _burn(address _from, uint256 _id, uint256 _amount)
1474     internal
1475     {
1476         //Substract _amount
1477         balances[_from][_id] = balances[_from][_id].sub(_amount);
1478 
1479         // Emit event
1480         emit TransferSingle(msg.sender, _from, address(0x0), _id, _amount);
1481     }
1482 
1483     /**
1484      * @notice Burn tokens of given token id for each (_ids[i], _amounts[i]) pair
1485      * @param _from     The address to burn tokens from
1486      * @param _ids      Array of token ids to burn
1487      * @param _amounts  Array of the amount to be burned
1488      */
1489     function _batchBurn(address _from, uint256[] memory _ids, uint256[] memory _amounts)
1490     internal
1491     {
1492         require(_ids.length == _amounts.length, "ERC1155MintBurn#batchBurn: INVALID_ARRAYS_LENGTH");
1493 
1494         // Number of mints to execute
1495         uint256 nBurn = _ids.length;
1496 
1497         // Executing all minting
1498         for (uint256 i = 0; i < nBurn; i++) {
1499             // Update storage balance
1500             balances[_from][_ids[i]] = balances[_from][_ids[i]].sub(_amounts[i]);
1501         }
1502 
1503         // Emit batch mint event
1504         emit TransferBatch(msg.sender, _from, address(0x0), _ids, _amounts);
1505     }
1506 
1507 }
1508 
1509 library Strings {
1510     // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol
1511     function strConcat(
1512         string memory _a,
1513         string memory _b,
1514         string memory _c,
1515         string memory _d,
1516         string memory _e
1517     ) internal pure returns (string memory) {
1518         bytes memory _ba = bytes(_a);
1519         bytes memory _bb = bytes(_b);
1520         bytes memory _bc = bytes(_c);
1521         bytes memory _bd = bytes(_d);
1522         bytes memory _be = bytes(_e);
1523         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1524         bytes memory babcde = bytes(abcde);
1525         uint256 k = 0;
1526         for (uint256 i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1527         for (uint256 i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1528         for (uint256 i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1529         for (uint256 i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1530         for (uint256 i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1531         return string(babcde);
1532     }
1533 
1534     function strConcat(
1535         string memory _a,
1536         string memory _b,
1537         string memory _c,
1538         string memory _d
1539     ) internal pure returns (string memory) {
1540         return strConcat(_a, _b, _c, _d, "");
1541     }
1542 
1543     function strConcat(
1544         string memory _a,
1545         string memory _b,
1546         string memory _c
1547     ) internal pure returns (string memory) {
1548         return strConcat(_a, _b, _c, "", "");
1549     }
1550 
1551     function strConcat(string memory _a, string memory _b) internal pure returns (string memory) {
1552         return strConcat(_a, _b, "", "", "");
1553     }
1554 
1555     function uint2str(uint256 _i) internal pure returns (string memory _uintAsString) {
1556         if (_i == 0) {
1557             return "0";
1558         }
1559         uint256 j = _i;
1560         uint256 len;
1561         while (j != 0) {
1562             len++;
1563             j /= 10;
1564         }
1565         bytes memory bstr = new bytes(len);
1566         uint256 k = len - 1;
1567         while (_i != 0) {
1568             bstr[k--] = bytes1(uint8(48 + (_i % 10)));
1569             _i /= 10;
1570         }
1571         return string(bstr);
1572     }
1573 }
1574 
1575 contract OwnableDelegateProxy {}
1576 
1577 contract ProxyRegistry {
1578     mapping(address => OwnableDelegateProxy) public proxies;
1579 }
1580 
1581 /**
1582  * @title ERC1155Tradable
1583  * ERC1155Tradable - ERC1155 contract that whitelists an operator address,
1584  * has create and mint functionality, and supports useful standards from OpenZeppelin,
1585   like _exists(), name(), symbol(), and totalSupply()
1586  */
1587 contract ERC1155Tradable is ERC1155, ERC1155MintBurn, ERC1155Metadata, Ownable, MinterRole, WhitelistAdminRole {
1588     using Strings for string;
1589 
1590     address proxyRegistryAddress;
1591     uint256 private _currentTokenID = 0;
1592     mapping(uint256 => address) public creators;
1593     mapping(uint256 => uint256) public tokenSupply;
1594     mapping(uint256 => uint256) public tokenMaxSupply;
1595     // Contract name
1596     string public name;
1597     // Contract symbol
1598     string public symbol;
1599 
1600     constructor(
1601         string memory _name,
1602         string memory _symbol,
1603         address _proxyRegistryAddress
1604     ) public {
1605         name = _name;
1606         symbol = _symbol;
1607         proxyRegistryAddress = _proxyRegistryAddress;
1608     }
1609 
1610     function removeWhitelistAdmin(address account) public onlyOwner {
1611         _removeWhitelistAdmin(account);
1612     }
1613 
1614     function removeMinter(address account) public onlyOwner {
1615         _removeMinter(account);
1616     }
1617 
1618     function uri(uint256 _id) public view returns (string memory) {
1619         require(_exists(_id), "ERC721Tradable#uri: NONEXISTENT_TOKEN");
1620         return Strings.strConcat(baseMetadataURI, Strings.uint2str(_id));
1621     }
1622 
1623     /**
1624      * @dev Returns the total quantity for a token ID
1625      * @param _id uint256 ID of the token to query
1626      * @return amount of token in existence
1627      */
1628     function totalSupply(uint256 _id) public view returns (uint256) {
1629         return tokenSupply[_id];
1630     }
1631 
1632     /**
1633      * @dev Returns the max quantity for a token ID
1634      * @param _id uint256 ID of the token to query
1635      * @return amount of token in existence
1636      */
1637     function maxSupply(uint256 _id) public view returns (uint256) {
1638         return tokenMaxSupply[_id];
1639     }
1640 
1641     /**
1642      * @dev Will update the base URL of token's URI
1643      * @param _newBaseMetadataURI New base URL of token's URI
1644      */
1645     function setBaseMetadataURI(string memory _newBaseMetadataURI) public onlyWhitelistAdmin {
1646         _setBaseMetadataURI(_newBaseMetadataURI);
1647     }
1648 
1649     /**
1650      * @dev Creates a new token type and assigns _initialSupply to an address
1651      * @param _maxSupply max supply allowed
1652      * @param _initialSupply Optional amount to supply the first owner
1653      * @param _uri Optional URI for this token type
1654      * @param _data Optional data to pass if receiver is contract
1655      * @return The newly created token ID
1656      */
1657     function create(
1658         uint256 _maxSupply,
1659         uint256 _initialSupply,
1660         string calldata _uri,
1661         bytes calldata _data
1662     ) external onlyWhitelistAdmin returns (uint256 tokenId) {
1663         require(_initialSupply <= _maxSupply, "Initial supply cannot be more than max supply");
1664         uint256 _id = _getNextTokenID();
1665         _incrementTokenTypeId();
1666         creators[_id] = msg.sender;
1667 
1668         if (bytes(_uri).length > 0) {
1669             emit URI(_uri, _id);
1670         }
1671 
1672         if (_initialSupply != 0) _mint(msg.sender, _id, _initialSupply, _data);
1673         tokenSupply[_id] = _initialSupply;
1674         tokenMaxSupply[_id] = _maxSupply;
1675         return _id;
1676     }
1677 
1678     /**
1679      * @dev Mints some amount of tokens to an address
1680      * @param _to          Address of the future owner of the token
1681      * @param _id          Token ID to mint
1682      * @param _quantity    Amount of tokens to mint
1683      * @param _data        Data to pass if receiver is contract
1684      */
1685     function mint(
1686         address _to,
1687         uint256 _id,
1688         uint256 _quantity,
1689         bytes memory _data
1690     ) public onlyMinter {
1691         uint256 tokenId = _id;
1692         require(tokenSupply[tokenId] < tokenMaxSupply[tokenId], "Max supply reached");
1693         _mint(_to, _id, _quantity, _data);
1694         tokenSupply[_id] = tokenSupply[_id].add(_quantity);
1695     }
1696 
1697     /**
1698      * Override isApprovedForAll to whitelist user's OpenSea proxy accounts to enable gas-free listings.
1699      */
1700     function isApprovedForAll(address _owner, address _operator) public view returns (bool isOperator) {
1701         // Whitelist OpenSea proxy contract for easy trading.
1702         ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);
1703         if (address(proxyRegistry.proxies(_owner)) == _operator) {
1704             return true;
1705         }
1706 
1707         return ERC1155.isApprovedForAll(_owner, _operator);
1708     }
1709 
1710     /**
1711      * @dev Returns whether the specified token exists by checking to see if it has a creator
1712      * @param _id uint256 ID of the token to query the existence of
1713      * @return bool whether the token exists
1714      */
1715     function _exists(uint256 _id) internal view returns (bool) {
1716         return creators[_id] != address(0);
1717     }
1718 
1719     /**
1720      * @dev calculates the next token ID based on value of _currentTokenID
1721      * @return uint256 for the next token ID
1722      */
1723     function _getNextTokenID() private view returns (uint256) {
1724         return _currentTokenID.add(1);
1725     }
1726 
1727     /**
1728      * @dev increments the value of _currentTokenID
1729      */
1730     function _incrementTokenTypeId() private {
1731         _currentTokenID++;
1732     }
1733 }
1734 
1735 contract PepemonStore is Ownable {
1736     using SafeERC20 for IERC20;
1737     using SafeMath for uint256;
1738 
1739     ERC1155Tradable public PepemonFactory;
1740     IERC20 private PepedexToken;
1741     address public fundAddress;
1742     uint256 public totalPPDEXSpend;
1743 
1744     mapping(uint256 => uint256) public cardCosts;
1745 
1746     event CardAdded(uint256 card, uint256 points);
1747     event Redeemed(address indexed user, uint256 amount);
1748 
1749     constructor(ERC1155Tradable _PepemonFactoryAddress, IERC20 _ppdexAddress) public {
1750         PepemonFactory = _PepemonFactoryAddress;
1751         PepedexToken = IERC20(_ppdexAddress);
1752         totalPPDEXSpend = 0;
1753     }
1754 
1755     function setFundAddress(address _fundAddress) public onlyOwner {
1756         fundAddress = _fundAddress;
1757     }
1758 
1759     function addCard(uint256 cardId, uint256 amount) public onlyOwner {
1760         cardCosts[cardId] = amount;
1761         emit CardAdded(cardId, amount);
1762     }
1763 
1764     function redeem(uint256 card) public {
1765         require(cardCosts[card] != 0, "Card not found");
1766         require(PepedexToken.balanceOf(msg.sender) >= cardCosts[card], "Not enough points to redeem for card");
1767         require(PepemonFactory.totalSupply(card) < PepemonFactory.maxSupply(card), "Max cards minted");
1768 
1769         PepedexToken.safeTransferFrom(msg.sender, address(0xdead), cardCosts[card].mul(9) / (10));
1770         PepedexToken.safeTransferFrom(msg.sender, fundAddress, cardCosts[card].mul(1) / (10));
1771         totalPPDEXSpend = totalPPDEXSpend.add(cardCosts[card]);
1772 
1773         PepemonFactory.mint(msg.sender, card, 1, "");
1774         emit Redeemed(msg.sender, cardCosts[card]);
1775     }
1776 }