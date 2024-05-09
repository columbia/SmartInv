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
651 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
652 
653 pragma solidity ^0.5.0;
654 
655 
656 /**
657  * @dev Optional functions from the ERC20 standard.
658  */
659 contract ERC20Detailed is IERC20 {
660     string private _name;
661     string private _symbol;
662     uint8 private _decimals;
663 
664     /**
665      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
666      * these values are immutable: they can only be set once during
667      * construction.
668      */
669     constructor (string memory name, string memory symbol, uint8 decimals) public {
670         _name = name;
671         _symbol = symbol;
672         _decimals = decimals;
673     }
674 
675     /**
676      * @dev Returns the name of the token.
677      */
678     function name() public view returns (string memory) {
679         return _name;
680     }
681 
682     /**
683      * @dev Returns the symbol of the token, usually a shorter version of the
684      * name.
685      */
686     function symbol() public view returns (string memory) {
687         return _symbol;
688     }
689 
690     /**
691      * @dev Returns the number of decimals used to get its user representation.
692      * For example, if `decimals` equals `2`, a balance of `505` tokens should
693      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
694      *
695      * Tokens usually opt for a value of 18, imitating the relationship between
696      * Ether and Wei.
697      *
698      * NOTE: This information is only used for _display_ purposes: it in
699      * no way affects any of the arithmetic of the contract, including
700      * {IERC20-balanceOf} and {IERC20-transfer}.
701      */
702     function decimals() public view returns (uint8) {
703         return _decimals;
704     }
705 }
706 
707 // File: @openzeppelin/contracts/access/Roles.sol
708 
709 pragma solidity ^0.5.0;
710 
711 /**
712  * @title Roles
713  * @dev Library for managing addresses assigned to a Role.
714  */
715 library Roles {
716     struct Role {
717         mapping (address => bool) bearer;
718     }
719 
720     /**
721      * @dev Give an account access to this role.
722      */
723     function add(Role storage role, address account) internal {
724         require(!has(role, account), "Roles: account already has role");
725         role.bearer[account] = true;
726     }
727 
728     /**
729      * @dev Remove an account's access to this role.
730      */
731     function remove(Role storage role, address account) internal {
732         require(has(role, account), "Roles: account does not have role");
733         role.bearer[account] = false;
734     }
735 
736     /**
737      * @dev Check if an account has this role.
738      * @return bool
739      */
740     function has(Role storage role, address account) internal view returns (bool) {
741         require(account != address(0), "Roles: account is the zero address");
742         return role.bearer[account];
743     }
744 }
745 
746 // File: @openzeppelin/contracts/access/roles/PauserRole.sol
747 
748 pragma solidity ^0.5.0;
749 
750 
751 
752 contract PauserRole is Context {
753     using Roles for Roles.Role;
754 
755     event PauserAdded(address indexed account);
756     event PauserRemoved(address indexed account);
757 
758     Roles.Role private _pausers;
759 
760     constructor () internal {
761         _addPauser(_msgSender());
762     }
763 
764     modifier onlyPauser() {
765         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
766         _;
767     }
768 
769     function isPauser(address account) public view returns (bool) {
770         return _pausers.has(account);
771     }
772 
773     function addPauser(address account) public onlyPauser {
774         _addPauser(account);
775     }
776 
777     function renouncePauser() public {
778         _removePauser(_msgSender());
779     }
780 
781     function _addPauser(address account) internal {
782         _pausers.add(account);
783         emit PauserAdded(account);
784     }
785 
786     function _removePauser(address account) internal {
787         _pausers.remove(account);
788         emit PauserRemoved(account);
789     }
790 }
791 
792 // File: @openzeppelin/contracts/lifecycle/Pausable.sol
793 
794 pragma solidity ^0.5.0;
795 
796 
797 
798 /**
799  * @dev Contract module which allows children to implement an emergency stop
800  * mechanism that can be triggered by an authorized account.
801  *
802  * This module is used through inheritance. It will make available the
803  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
804  * the functions of your contract. Note that they will not be pausable by
805  * simply including this module, only once the modifiers are put in place.
806  */
807 contract Pausable is Context, PauserRole {
808     /**
809      * @dev Emitted when the pause is triggered by a pauser (`account`).
810      */
811     event Paused(address account);
812 
813     /**
814      * @dev Emitted when the pause is lifted by a pauser (`account`).
815      */
816     event Unpaused(address account);
817 
818     bool private _paused;
819 
820     /**
821      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
822      * to the deployer.
823      */
824     constructor () internal {
825         _paused = false;
826     }
827 
828     /**
829      * @dev Returns true if the contract is paused, and false otherwise.
830      */
831     function paused() public view returns (bool) {
832         return _paused;
833     }
834 
835     /**
836      * @dev Modifier to make a function callable only when the contract is not paused.
837      */
838     modifier whenNotPaused() {
839         require(!_paused, "Pausable: paused");
840         _;
841     }
842 
843     /**
844      * @dev Modifier to make a function callable only when the contract is paused.
845      */
846     modifier whenPaused() {
847         require(_paused, "Pausable: not paused");
848         _;
849     }
850 
851     /**
852      * @dev Called by a pauser to pause, triggers stopped state.
853      */
854     function pause() public onlyPauser whenNotPaused {
855         _paused = true;
856         emit Paused(_msgSender());
857     }
858 
859     /**
860      * @dev Called by a pauser to unpause, returns to normal state.
861      */
862     function unpause() public onlyPauser whenPaused {
863         _paused = false;
864         emit Unpaused(_msgSender());
865     }
866 }
867 
868 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
869 
870 pragma solidity ^0.5.0;
871 
872 /**
873  * @dev Contract module that helps prevent reentrant calls to a function.
874  *
875  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
876  * available, which can be applied to functions to make sure there are no nested
877  * (reentrant) calls to them.
878  *
879  * Note that because there is a single `nonReentrant` guard, functions marked as
880  * `nonReentrant` may not call one another. This can be worked around by making
881  * those functions `private`, and then adding `external` `nonReentrant` entry
882  * points to them.
883  *
884  * TIP: If you would like to learn more about reentrancy and alternative ways
885  * to protect against it, check out our blog post
886  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
887  *
888  * _Since v2.5.0:_ this module is now much more gas efficient, given net gas
889  * metering changes introduced in the Istanbul hardfork.
890  */
891 contract ReentrancyGuard {
892     bool private _notEntered;
893 
894     constructor () internal {
895         // Storing an initial non-zero value makes deployment a bit more
896         // expensive, but in exchange the refund on every call to nonReentrant
897         // will be lower in amount. Since refunds are capped to a percetange of
898         // the total transaction's gas, it is best to keep them low in cases
899         // like this one, to increase the likelihood of the full refund coming
900         // into effect.
901         _notEntered = true;
902     }
903 
904     /**
905      * @dev Prevents a contract from calling itself, directly or indirectly.
906      * Calling a `nonReentrant` function from another `nonReentrant`
907      * function is not supported. It is possible to prevent this from happening
908      * by making the `nonReentrant` function external, and make it call a
909      * `private` function that does the actual work.
910      */
911     modifier nonReentrant() {
912         // On the first call to nonReentrant, _notEntered will be true
913         require(_notEntered, "ReentrancyGuard: reentrant call");
914 
915         // Any calls to nonReentrant after this point will fail
916         _notEntered = false;
917 
918         _;
919 
920         // By storing the original value once again, a refund is triggered (see
921         // https://eips.ethereum.org/EIPS/eip-2200)
922         _notEntered = true;
923     }
924 }
925 
926 // File: @openzeppelin/contracts/ownership/Ownable.sol
927 
928 pragma solidity ^0.5.0;
929 
930 /**
931  * @dev Contract module which provides a basic access control mechanism, where
932  * there is an account (an owner) that can be granted exclusive access to
933  * specific functions.
934  *
935  * This module is used through inheritance. It will make available the modifier
936  * `onlyOwner`, which can be applied to your functions to restrict their use to
937  * the owner.
938  */
939 contract Ownable is Context {
940     address private _owner;
941 
942     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
943 
944     /**
945      * @dev Initializes the contract setting the deployer as the initial owner.
946      */
947     constructor () internal {
948         address msgSender = _msgSender();
949         _owner = msgSender;
950         emit OwnershipTransferred(address(0), msgSender);
951     }
952 
953     /**
954      * @dev Returns the address of the current owner.
955      */
956     function owner() public view returns (address) {
957         return _owner;
958     }
959 
960     /**
961      * @dev Throws if called by any account other than the owner.
962      */
963     modifier onlyOwner() {
964         require(isOwner(), "Ownable: caller is not the owner");
965         _;
966     }
967 
968     /**
969      * @dev Returns true if the caller is the current owner.
970      */
971     function isOwner() public view returns (bool) {
972         return _msgSender() == _owner;
973     }
974 
975     /**
976      * @dev Leaves the contract without owner. It will not be possible to call
977      * `onlyOwner` functions anymore. Can only be called by the current owner.
978      *
979      * NOTE: Renouncing ownership will leave the contract without an owner,
980      * thereby removing any functionality that is only available to the owner.
981      */
982     function renounceOwnership() public onlyOwner {
983         emit OwnershipTransferred(_owner, address(0));
984         _owner = address(0);
985     }
986 
987     /**
988      * @dev Transfers ownership of the contract to a new account (`newOwner`).
989      * Can only be called by the current owner.
990      */
991     function transferOwnership(address newOwner) public onlyOwner {
992         _transferOwnership(newOwner);
993     }
994 
995     /**
996      * @dev Transfers ownership of the contract to a new account (`newOwner`).
997      */
998     function _transferOwnership(address newOwner) internal {
999         require(newOwner != address(0), "Ownable: new owner is the zero address");
1000         emit OwnershipTransferred(_owner, newOwner);
1001         _owner = newOwner;
1002     }
1003 }
1004 
1005 // File: contracts/util/Whitelist.sol
1006 
1007 pragma solidity 0.5.15;
1008 
1009 
1010 contract Whitelist is Ownable {
1011 	mapping(address => bool) whitelist;
1012 	event AddedToWhitelist(address indexed account);
1013 	event RemovedFromWhitelist(address indexed account);
1014 
1015 	function addToWhitelist(address _address) public onlyOwner {
1016 		whitelist[_address] = true;
1017 		emit AddedToWhitelist(_address);
1018 	}
1019 
1020 	function removefromWhitelist(address _address) public onlyOwner {
1021 		whitelist[_address] = false;
1022 		emit RemovedFromWhitelist(_address);
1023 	}
1024 
1025 	function isWhitelisted(address _address) public view returns (bool) {
1026 		return whitelist[_address];
1027 	}
1028 }
1029 
1030 // File: contracts/interface/IKyberNetworkProxy.sol
1031 
1032 pragma solidity 0.5.15;
1033 
1034 
1035 contract IKyberNetworkProxy {
1036     function getExpectedRate(ERC20 src, ERC20 dest, uint srcQty) external view returns (uint expectedRate, uint slippageRate);
1037     function swapEtherToToken(ERC20 token, uint minConversionRate) external payable returns(uint);
1038     function swapTokenToEther(ERC20 token, uint tokenQty, uint minRate) external payable returns(uint);
1039     function swapTokenToToken(ERC20 src, uint srcAmount, ERC20 dest, uint minRate) external returns(uint);
1040 }
1041 
1042 // File: contracts/interface/IKyberStaking.sol
1043 
1044 pragma solidity 0.5.15;
1045 
1046 contract IKyberStaking {
1047     function deposit(uint256 amount) external;
1048     function withdraw(uint256 amount) external;
1049     function getLatestStakeBalance(address staker) external view returns(uint);
1050 }
1051 
1052 // File: contracts/interface/IKyberDAO.sol
1053 
1054 pragma solidity 0.5.15;
1055 
1056 contract IKyberDAO {
1057     function vote(uint256 campaignID, uint256 option) external;
1058 }
1059 
1060 // File: contracts/interface/IKyberFeeHandler.sol
1061 
1062 pragma solidity 0.5.15;
1063 
1064 contract IKyberFeeHandler {
1065     function claimStakerReward(
1066         address staker,
1067         uint256 epoch
1068     ) external returns(uint256 amountWei);
1069 }
1070 
1071 // File: contracts/xKNC.sol
1072 
1073 pragma solidity 0.5.15;
1074 
1075 
1076 
1077 
1078 
1079 
1080 
1081 
1082 
1083 
1084 
1085 
1086 
1087 /*
1088  * xKNC KyberDAO Pool Token
1089  * Communal Staking Pool with Stated Governance Position
1090  */
1091 contract xKNC is ERC20, ERC20Detailed, Whitelist, Pausable, ReentrancyGuard {
1092     using SafeMath for uint256;
1093     using SafeERC20 for ERC20;
1094 
1095     address private constant ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1096 
1097     ERC20 public knc;
1098     IKyberDAO public kyberDao;
1099     IKyberStaking public kyberStaking;
1100     IKyberNetworkProxy public kyberProxy;
1101     IKyberFeeHandler[] public kyberFeeHandlers;
1102 
1103     address[] private kyberFeeTokens;
1104 
1105     uint256 constant PERCENT = 100;
1106     uint256 constant MAX_UINT = 2**256 - 1;
1107     uint256 constant INITIAL_SUPPLY_MULTIPLIER = 10;
1108 
1109     uint256[] public feeDivisors;
1110     uint256 private withdrawableEthFees;
1111     uint256 private withdrawableKncFees;
1112 
1113     string public mandate;
1114 
1115     mapping(address => bool) fallbackAllowedAddress;
1116 
1117     struct FeeStructure {
1118         uint mintFee;
1119         uint burnFee;
1120         uint claimFee;
1121     }
1122 
1123     FeeStructure public feeStructure;
1124 
1125     event MintWithEth(
1126         address indexed user,
1127         uint256 ethPayable,
1128         uint256 mintAmount,
1129         uint256 timestamp
1130     );
1131     event MintWithKnc(
1132         address indexed user,
1133         uint256 kncPayable,
1134         uint256 mintAmount,
1135         uint256 timestamp
1136     );
1137     event Burn(
1138         address indexed user,
1139         bool redeemedForKnc,
1140         uint256 burnAmount,
1141         uint256 timestamp
1142     );
1143     event FeeWithdraw(uint256 ethAmount, uint256 kncAmount, uint256 timestamp);
1144     event FeeDivisorsSet(uint256 mintFee, uint256 burnFee, uint256 claimFee);
1145     event EthRewardClaimed(uint256 amount, uint256 timestamp);
1146     event TokenRewardClaimed(uint256 amount, uint256 timestamp);
1147 
1148     enum FeeTypes {MINT, BURN, CLAIM}
1149 
1150     constructor(
1151         string memory _mandate,
1152         address _kyberStakingAddress,
1153         address _kyberProxyAddress,
1154         address _kyberTokenAddress,
1155         address _kyberDaoAddress
1156     ) public ERC20Detailed("xKNC", "xKNCa", 18) {
1157         mandate = _mandate;
1158         kyberStaking = IKyberStaking(_kyberStakingAddress);
1159         kyberProxy = IKyberNetworkProxy(_kyberProxyAddress);
1160         knc = ERC20(_kyberTokenAddress);
1161         kyberDao = IKyberDAO(_kyberDaoAddress);
1162 
1163         _addFallbackAllowedAddress(_kyberProxyAddress);
1164     }
1165 
1166     /*
1167      * @notice Called by users buying with ETH
1168      * @dev Swaps ETH for KNC, deposits to Staking contract
1169      * @dev: Mints pro rata xKNC tokens
1170      * @param: kyberProxy.getExpectedRate(eth => knc)
1171      */
1172     function mint(uint256 minRate) external payable whenNotPaused {
1173         require(msg.value > 0, "Must send eth with tx");
1174         // ethBalBefore checked in case of eth still waiting for exch to KNC
1175         uint256 ethBalBefore = getFundEthBalanceWei().sub(msg.value);
1176         uint256 fee = _administerEthFee(FeeTypes.MINT, ethBalBefore);
1177 
1178         uint256 ethValueForKnc = msg.value.sub(fee);
1179         uint256 kncBalanceBefore = getFundKncBalanceTwei();
1180 
1181         _swapEtherToKnc(ethValueForKnc, minRate);
1182         _deposit(getAvailableKncBalanceTwei());
1183 
1184         uint256 mintAmount = _calculateMintAmount(kncBalanceBefore);
1185 
1186         emit MintWithEth(msg.sender, msg.value, mintAmount, block.timestamp);
1187         return super._mint(msg.sender, mintAmount);
1188     }
1189 
1190     /*
1191      * @notice Called by users buying with KNC
1192      * @notice Users must submit ERC20 approval before calling
1193      * @dev Deposits to Staking contract
1194      * @dev: Mints pro rata xKNC tokens
1195      * @param: Number of KNC to contribue
1196      */
1197     function mintWithKnc(uint256 kncAmountTwei) external whenNotPaused {
1198         require(kncAmountTwei > 0, "Must contribute KNC");
1199         knc.safeTransferFrom(msg.sender, address(this), kncAmountTwei);
1200 
1201         uint256 kncBalanceBefore = getFundKncBalanceTwei();
1202         _administerKncFee(kncAmountTwei, FeeTypes.MINT);
1203 
1204         _deposit(getAvailableKncBalanceTwei());
1205 
1206         uint256 mintAmount = _calculateMintAmount(kncBalanceBefore);
1207 
1208         emit MintWithKnc(msg.sender, kncAmountTwei, mintAmount, block.timestamp);
1209         return super._mint(msg.sender, mintAmount);
1210     }
1211 
1212     /*
1213      * @notice Called by users burning their xKNC
1214      * @dev Calculates pro rata KNC and redeems from Staking contract
1215      * @dev: Exchanges for ETH if necessary and pays out to caller
1216      * @param tokensToRedeem
1217      * @param redeemForKnc bool: if true, redeem for KNC; otherwise ETH
1218      * @param kyberProxy.getExpectedRate(knc => eth)
1219      */
1220     function burn(
1221         uint256 tokensToRedeemTwei,
1222         bool redeemForKnc,
1223         uint256 minRate
1224     ) external nonReentrant {
1225         require(
1226             balanceOf(msg.sender) >= tokensToRedeemTwei,
1227             "Insufficient balance"
1228         );
1229 
1230         uint256 proRataKnc = getFundKncBalanceTwei().mul(tokensToRedeemTwei).div(
1231             totalSupply()
1232         );
1233         _withdraw(proRataKnc);
1234         super._burn(msg.sender, tokensToRedeemTwei);
1235 
1236         if (redeemForKnc) {
1237             uint256 fee = _administerKncFee(proRataKnc, FeeTypes.BURN);
1238             knc.safeTransfer(msg.sender, proRataKnc.sub(fee));
1239         } else {
1240             // safeguard to not overcompensate _burn sender in case eth still awaiting for exch to KNC
1241             uint256 ethBalBefore = getFundEthBalanceWei();
1242             kyberProxy.swapTokenToEther(
1243                 knc,
1244                 getAvailableKncBalanceTwei(),
1245                 minRate
1246             );
1247 
1248             _administerEthFee(FeeTypes.BURN, ethBalBefore);
1249 
1250             uint256 valToSend = getFundEthBalanceWei().sub(ethBalBefore);
1251             (bool success, ) = msg.sender.call.value(valToSend)("");
1252             require(success, "Burn transfer failed");
1253         }
1254 
1255         emit Burn(msg.sender, redeemForKnc, tokensToRedeemTwei, block.timestamp);
1256     }
1257 
1258     /*
1259      * @notice Calculates proportional issuance according to KNC contribution
1260      * @notice Fund starts at ratio of INITIAL_SUPPLY_MULTIPLIER/1 == xKNC supply/KNC balance
1261      * and approaches 1/1 as rewards accrue in KNC
1262      * @param kncBalanceBefore used to determine ratio of incremental to current KNC
1263      */
1264     function _calculateMintAmount(uint256 kncBalanceBefore)
1265         private
1266         view
1267         returns (uint256 mintAmount)
1268     {
1269         uint256 kncBalanceAfter = getFundKncBalanceTwei();
1270         if (totalSupply() == 0)
1271             return kncBalanceAfter.mul(INITIAL_SUPPLY_MULTIPLIER);
1272 
1273         mintAmount = (kncBalanceAfter.sub(kncBalanceBefore))
1274             .mul(totalSupply())
1275             .div(kncBalanceBefore);
1276     }
1277 
1278     /*
1279      * @notice KyberDAO deposit
1280      */
1281     function _deposit(uint256 amount) private {
1282         kyberStaking.deposit(amount);
1283     }
1284 
1285     /*
1286      * @notice KyberDAO withdraw
1287      */
1288     function _withdraw(uint256 amount) private {
1289         kyberStaking.withdraw(amount);
1290     }
1291 
1292     /*
1293      * @notice Vote on KyberDAO campaigns
1294      * @dev Admin calls with relevant params for each campaign in an epoch
1295      * @param DAO campaign ID
1296      * @param Choice of voting option
1297      */
1298     function vote(uint256 campaignID, uint256 option) external onlyOwner {
1299         kyberDao.vote(campaignID, option);
1300     }
1301 
1302     /*
1303      * @notice Claim reward from previous epoch
1304      * @notice All fee handlers should be called at once
1305      * @dev Admin calls with relevant params
1306      * @dev ETH/other asset rewards swapped into KNC
1307      * @param epoch - KyberDAO epoch
1308      * @param feeHandlerIndices - indices of feeHandler contract to claim from
1309      * @param maxAmountsToSell - sellAmount above which slippage would be too high
1310      * and rewards would redirected into KNC in multiple trades
1311      * @param minRates - kyberProxy.getExpectedRate(eth/token => knc)
1312      */
1313     function claimReward(
1314         uint256 epoch,
1315         uint256[] calldata feeHandlerIndices,
1316         uint256[] calldata maxAmountsToSell,
1317         uint256[] calldata minRates
1318     ) external onlyOwner {
1319         require(
1320             feeHandlerIndices.length == maxAmountsToSell.length,
1321             "Arrays must be equal length"
1322         );
1323         require(
1324             maxAmountsToSell.length == minRates.length,
1325             "Arrays must be equal length"
1326         );
1327 
1328         uint256 ethBalBefore = getFundEthBalanceWei();
1329         for (uint256 i = 0; i < feeHandlerIndices.length; i++) {
1330             kyberFeeHandlers[i].claimStakerReward(address(this), epoch);
1331 
1332             if (kyberFeeTokens[i] == ETH_ADDRESS) {
1333                 emit EthRewardClaimed(
1334                     getFundEthBalanceWei().sub(ethBalBefore),
1335                     block.timestamp
1336                 );
1337                 _administerEthFee(FeeTypes.CLAIM, ethBalBefore);
1338             } else {
1339                 uint256 tokenBal = IERC20(kyberFeeTokens[i]).balanceOf(
1340                     address(this)
1341                 );
1342                 emit TokenRewardClaimed(tokenBal, block.timestamp);
1343             }
1344 
1345             _unwindRewards(
1346                 feeHandlerIndices[i],
1347                 maxAmountsToSell[i],
1348                 minRates[i]
1349             );
1350         }
1351 
1352         _deposit(getAvailableKncBalanceTwei());
1353     }
1354 
1355     /*
1356      * @notice Called when rewards size is too big for the one trade executed by `claimReward`
1357      * @param feeHandlerIndices - index of feeHandler previously claimed from
1358      * @param maxAmountsToSell - sellAmount above which slippage would be too high
1359      * and rewards would redirected into KNC in multiple trades
1360      * @param minRates - kyberProxy.getExpectedRate(eth/token => knc)
1361      */
1362     function unwindRewards(
1363         uint256[] calldata feeHandlerIndices,
1364         uint256[] calldata maxAmountsToSell,
1365         uint256[] calldata minRates
1366     ) external onlyOwner {
1367         for (uint256 i = 0; i < feeHandlerIndices.length; i++) {
1368             _unwindRewards(
1369                 feeHandlerIndices[i],
1370                 maxAmountsToSell[i],
1371                 minRates[i]
1372             );
1373         }
1374 
1375         _deposit(getAvailableKncBalanceTwei());
1376     }
1377 
1378     /*
1379      * @notice Exchanges reward tokens (ETH, etc) for KNC
1380      */
1381     function _unwindRewards(
1382         uint256 feeHandlerIndex,
1383         uint256 maxAmountToSell,
1384         uint256 minRate
1385     ) private {
1386         address rewardTokenAddress = kyberFeeTokens[feeHandlerIndex];
1387 
1388         uint256 amountToSell;
1389         if (rewardTokenAddress == ETH_ADDRESS) {
1390             uint256 ethBal = getFundEthBalanceWei();
1391             if (maxAmountToSell < ethBal) {
1392                 amountToSell = maxAmountToSell;
1393             } else {
1394                 amountToSell = ethBal;
1395             }
1396 
1397             _swapEtherToKnc(amountToSell, minRate);
1398         } else {
1399             uint256 tokenBal = IERC20(rewardTokenAddress).balanceOf(
1400                 address(this)
1401             );
1402             if (maxAmountToSell < tokenBal) {
1403                 amountToSell = maxAmountToSell;
1404             } else {
1405                 amountToSell = tokenBal;
1406             }
1407 
1408             uint256 kncBalanceBefore = getAvailableKncBalanceTwei();
1409 
1410             _swapTokenToKnc(
1411                 rewardTokenAddress,
1412                 amountToSell,
1413                 minRate
1414             );
1415 
1416             uint256 kncBalanceAfter = getAvailableKncBalanceTwei();
1417             _administerKncFee(
1418                 kncBalanceAfter.sub(kncBalanceBefore),
1419                 FeeTypes.CLAIM
1420             );
1421         }
1422     }
1423 
1424     function _swapEtherToKnc(
1425         uint256 amount,
1426         uint256 minRate
1427     ) private {
1428         kyberProxy.swapEtherToToken.value(amount)(knc, minRate);
1429     }
1430 
1431     function _swapTokenToKnc(
1432         address fromAddress,
1433         uint256 amount,
1434         uint256 minRate
1435     ) private {
1436         kyberProxy.swapTokenToToken(
1437             ERC20(fromAddress),
1438             amount,
1439             knc,
1440             minRate
1441         );
1442     }
1443 
1444     /*
1445      * @notice Returns ETH balance belonging to the fund
1446      */
1447     function getFundEthBalanceWei() public view returns (uint256) {
1448         return address(this).balance.sub(withdrawableEthFees);
1449     }
1450 
1451     /*
1452      * @notice Returns KNC balance staked to DAO
1453      */
1454     function getFundKncBalanceTwei() public view returns (uint256) {
1455         return kyberStaking.getLatestStakeBalance(address(this));
1456     }
1457 
1458     /*
1459      * @notice Returns KNC balance available to stake
1460      */
1461     function getAvailableKncBalanceTwei() public view returns (uint256) {
1462         return knc.balanceOf(address(this)).sub(withdrawableKncFees);
1463     }
1464 
1465     function _administerEthFee(FeeTypes _type, uint256 ethBalBefore)
1466         private
1467         returns (uint256 fee)
1468     {
1469         if (!isWhitelisted(msg.sender)) {
1470             uint256 feeRate = getFeeRate(_type);
1471             if (feeRate == 0) return 0;
1472 
1473             fee = (getFundEthBalanceWei().sub(ethBalBefore)).div(feeRate);
1474             withdrawableEthFees = withdrawableEthFees.add(fee);
1475         }
1476     }
1477 
1478     function _administerKncFee(uint256 _kncAmount, FeeTypes _type)
1479         private
1480         returns (uint256 fee)
1481     {
1482         if (!isWhitelisted(msg.sender)) {
1483             uint256 feeRate = getFeeRate(_type);
1484             if (feeRate == 0) return 0;
1485 
1486             fee = _kncAmount.div(feeRate);
1487             withdrawableKncFees = withdrawableKncFees.add(fee);
1488         }
1489     }
1490 
1491     function getFeeRate(FeeTypes _type) public view returns (uint256) {
1492         if (_type == FeeTypes.MINT) return feeStructure.mintFee;
1493         if (_type == FeeTypes.BURN) return feeStructure.burnFee;
1494         if (_type == FeeTypes.CLAIM) return feeStructure.claimFee;
1495     }
1496 
1497     /*
1498      * @notice Called on initial deployment and on the addition of new fee handlers
1499      * @param Address of KyberFeeHandler contract
1500      * @param Address of underlying rewards token
1501      */
1502     function addKyberFeeHandler(
1503         address _kyberfeeHandlerAddress,
1504         address _tokenAddress
1505     ) external onlyOwner {
1506         kyberFeeHandlers.push(IKyberFeeHandler(_kyberfeeHandlerAddress));
1507         kyberFeeTokens.push(_tokenAddress);
1508 
1509         if (_tokenAddress != ETH_ADDRESS) {
1510             _approveKyberProxyContract(_tokenAddress, false);
1511         } else {
1512             _addFallbackAllowedAddress(_kyberfeeHandlerAddress);
1513         }
1514     }
1515 
1516     /* UTILS */
1517 
1518     /*
1519      * @notice Called by admin on deployment
1520      * @dev Approves Kyber Staking contract to deposit KNC
1521      * @param Pass _reset as true if resetting allowance to zero
1522      */
1523     function approveStakingContract(bool _reset) external onlyOwner {
1524         uint256 amount = _reset ? 0 : MAX_UINT;
1525         knc.approve(address(kyberStaking), amount);
1526     }
1527 
1528     /*
1529      * @notice Called by admin on deployment for KNC
1530      * @dev Approves Kyber Proxy contract to trade KNC
1531      * @param Token to approve on proxy contract
1532      * @param Pass _reset as true if resetting allowance to zero
1533      */
1534     function approveKyberProxyContract(address _token, bool _reset)
1535         external
1536         onlyOwner
1537     {
1538         _approveKyberProxyContract(_token, _reset);
1539     }
1540 
1541     function _approveKyberProxyContract(address _token, bool _reset) private {
1542         uint256 amount = _reset ? 0 : MAX_UINT;
1543         IERC20(_token).approve(address(kyberProxy), amount);
1544     }
1545 
1546     /*
1547      * @notice Called by admin on deployment
1548      * @dev (1 / feeDivisor) = % fee on mint, burn, ETH claims
1549      * @dev ex: A feeDivisor of 334 suggests a fee of 0.3%
1550      * @param feeDivisors[mint, burn, claim]:
1551      */
1552     function setFeeDivisors(uint256 _mintFee, uint256 _burnFee, uint256 _claimFee)
1553         external
1554         onlyOwner
1555     {
1556         require(
1557             _mintFee >= 100 || _mintFee == 0,
1558             "Mint fee must be zero or equal to or less than 1%"
1559         );
1560         require(
1561             _burnFee >= 100,
1562             "Burn fee must be equal to or less than 1%"
1563         );
1564         require(_claimFee >= 10, "Claim fee must be less than 10%");
1565         feeStructure.mintFee = _mintFee;
1566         feeStructure.burnFee = _burnFee;
1567         feeStructure.claimFee = _claimFee;
1568 
1569         emit FeeDivisorsSet(_mintFee, _burnFee, _claimFee);
1570     }
1571 
1572     function withdrawFees() external onlyOwner {
1573         uint256 ethFees = withdrawableEthFees;
1574         uint256 kncFees = withdrawableKncFees;
1575 
1576         withdrawableEthFees = 0;
1577         withdrawableKncFees = 0;
1578 
1579         (bool success, ) = msg.sender.call.value(ethFees)("");
1580         require(success, "Burn transfer failed");
1581 
1582         knc.safeTransfer(owner(), kncFees);
1583         emit FeeWithdraw(ethFees, kncFees, block.timestamp);
1584     }
1585 
1586     function addFallbackAllowedAddress(address _address) external onlyOwner {
1587         _addFallbackAllowedAddress(_address);
1588     }
1589 
1590     function _addFallbackAllowedAddress(address _address) private {
1591         fallbackAllowedAddress[_address] = true;
1592     }
1593 
1594     /*
1595      * @notice Fallback to accommodate claimRewards function
1596      */
1597     function() external payable {
1598         require(
1599             fallbackAllowedAddress[msg.sender],
1600             "Only approved address can use fallback"
1601         );
1602     }
1603 }