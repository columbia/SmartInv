1 pragma solidity ^0.5.16;
2 
3 /**
4   * @title ArtDeco Finance
5   *
6   * @notice Artdeco power :ArtPower contract
7   * 
8   */
9   
10 /**
11  * @dev Wrappers over Solidity's arithmetic operations with added overflow
12  * checks.
13  *
14  * Arithmetic operations in Solidity wrap on overflow. This can easily result
15  * in bugs, because programmers usually assume that an overflow raises an
16  * error, which is the standard behavior in high level programming languages.
17  * `SafeMath` restores this intuition by reverting the transaction when an
18  * operation overflows.
19  *
20  * Using this library instead of the unchecked operations eliminates an entire
21  * class of bugs, so it's recommended to use it always.
22  */
23 library SafeMath {
24     /**
25      * @dev Returns the addition of two unsigned integers, reverting on
26      * overflow.
27      *
28      * Counterpart to Solidity's `+` operator.
29      *
30      * Requirements:
31      * - Addition cannot overflow.
32      */
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36 
37         return c;
38     }
39 
40     /**
41      * @dev Returns the subtraction of two unsigned integers, reverting on
42      * overflow (when the result is negative).
43      *
44      * Counterpart to Solidity's `-` operator.
45      *
46      * Requirements:
47      * - Subtraction cannot overflow.
48      */
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     /**
54      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
55      * overflow (when the result is negative).
56      *
57      * Counterpart to Solidity's `-` operator.
58      *
59      * Requirements:
60      * - Subtraction cannot overflow.
61      *
62      * _Available since v2.4.0._
63      */
64     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67 
68         return c;
69     }
70 
71     /**
72      * @dev Returns the multiplication of two unsigned integers, reverting on
73      * overflow.
74      *
75      * Counterpart to Solidity's `*` operator.
76      *
77      * Requirements:
78      * - Multiplication cannot overflow.
79      */
80     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
81         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
82         // benefit is lost if 'b' is also tested.
83         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
84         if (a == 0) {
85             return 0;
86         }
87 
88         uint256 c = a * b;
89         require(c / a == b, "SafeMath: multiplication overflow");
90 
91         return c;
92     }
93 
94     /**
95      * @dev Returns the integer division of two unsigned integers. Reverts on
96      * division by zero. The result is rounded towards zero.
97      *
98      * Counterpart to Solidity's `/` operator. Note: this function uses a
99      * `revert` opcode (which leaves remaining gas untouched) while Solidity
100      * uses an invalid opcode to revert (consuming all remaining gas).
101      *
102      * Requirements:
103      * - The divisor cannot be zero.
104      */
105     function div(uint256 a, uint256 b) internal pure returns (uint256) {
106         return div(a, b, "SafeMath: division by zero");
107     }
108 
109     /**
110      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
111      * division by zero. The result is rounded towards zero.
112      *
113      * Counterpart to Solidity's `/` operator. Note: this function uses a
114      * `revert` opcode (which leaves remaining gas untouched) while Solidity
115      * uses an invalid opcode to revert (consuming all remaining gas).
116      *
117      * Requirements:
118      * - The divisor cannot be zero.
119      *
120      * _Available since v2.4.0._
121      */
122     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123         // Solidity only automatically asserts when dividing by 0
124         require(b > 0, errorMessage);
125         uint256 c = a / b;
126         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
133      * Reverts when dividing by zero.
134      *
135      * Counterpart to Solidity's `%` operator. This function uses a `revert`
136      * opcode (which leaves remaining gas untouched) while Solidity uses an
137      * invalid opcode to revert (consuming all remaining gas).
138      *
139      * Requirements:
140      * - The divisor cannot be zero.
141      */
142     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
143         return mod(a, b, "SafeMath: modulo by zero");
144     }
145 
146     /**
147      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
148      * Reverts with custom message when dividing by zero.
149      *
150      * Counterpart to Solidity's `%` operator. This function uses a `revert`
151      * opcode (which leaves remaining gas untouched) while Solidity uses an
152      * invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      * - The divisor cannot be zero.
156      *
157      * _Available since v2.4.0._
158      */
159     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b != 0, errorMessage);
161         return a % b;
162     }
163 }
164 
165 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
166 
167 pragma solidity ^0.5.0;
168 
169 /**
170  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
171  * the optional functions; to access them see ERC20infos.
172  */
173 interface IERC20 {
174     /**
175      * @dev Returns the amount of tokens in existence.
176      */
177     function totalSupply() external view returns (uint256);
178 
179     /**
180      * @dev Returns the amount of tokens owned by `account`.
181      */
182     function balanceOf(address account) external view returns (uint256);
183 
184     /**
185      * @dev Moves `amount` tokens from the caller's account to `recipient`.
186      *
187      * Returns a boolean value indicating whether the operation succeeded.
188      *
189      * Emits a {Transfer} event.
190      */
191     function transfer(address recipient, uint256 amount) external returns (bool);
192 
193     /**
194      * @dev Returns the remaining number of tokens that `spender` will be
195      * allowed to spend on behalf of `owner` through {transferFrom}. This is
196      * zero by default.
197      *
198      * This value changes when {approve} or {transferFrom} are called.
199      */
200     function allowance(address owner, address spender) external view returns (uint256);
201 
202     /**
203      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
204      *
205      * Returns a boolean value indicating whether the operation succeeded.
206      *
207      * IMPORTANT: Beware that changing an allowance with this method brings the risk
208      * that someone may use both the old and the new allowance by unfortunate
209      * transaction ordering. One possible solution to mitigate this race
210      * condition is to first reduce the spender's allowance to 0 and set the
211      * desired value afterwards:
212      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
213      *
214      * Emits an {Approval} event.
215      */
216     function approve(address spender, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Moves `amount` tokens from `sender` to `recipient` using the
220      * allowance mechanism. `amount` is then deducted from the caller's
221      * allowance.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * Emits a {Transfer} event.
226      */
227     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
228 
229     /**
230      * @dev Emitted when `value` tokens are moved from one account (`from`) to
231      * another (`to`).
232      *
233      * Note that `value` may be zero.
234      */
235     event Transfer(address indexed from, address indexed to, uint256 value);
236 
237     /**
238      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
239      * a call to {approve}. `value` is the new allowance.
240      */
241     event Approval(address indexed owner, address indexed spender, uint256 value);
242 }
243 
244 
245 /**
246  * @dev Optional functions from the ERC20 standard.
247  */
248 contract ERC20infos is IERC20 {
249     string private _name;
250     string private _symbol;
251     uint8 private _decimals;
252 
253     /**
254      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
255      * these values are immutable: they can only be set once during
256      * construction.
257      */
258     constructor (string memory name, string memory symbol, uint8 decimals) public {
259         _name = name;
260         _symbol = symbol;
261         _decimals = decimals;
262     }
263 
264     /**
265      * @dev Returns the name of the token.
266      */
267     function name() public view returns (string memory) {
268         return _name;
269     }
270 
271     /**
272      * @dev Returns the symbol of the token, usually a shorter version of the
273      * name.
274      */
275     function symbol() public view returns (string memory) {
276         return _symbol;
277     }
278 
279     /**
280      * @dev Returns the number of decimals used to get its user representation.
281      * For example, if `decimals` equals `2`, a balance of `505` tokens should
282      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
283      *
284      * Tokens usually opt for a value of 18, imitating the relationship between
285      * Ether and Wei.
286      *
287      * NOTE: This information is only used for _display_ purposes: it in
288      * no way affects any of the arithmetic of the contract, including
289      * {IERC20-balanceOf} and {IERC20-transfer}.
290      */
291     function decimals() public view returns (uint8) {
292         return _decimals;
293     }
294 }
295 
296 
297 /**
298  * @dev Collection of functions related to the address type
299  */
300 library Address {
301     /**
302      * @dev Returns true if `account` is a contract.
303      *
304      * [IMPORTANT]
305      * ====
306      * It is unsafe to assume that an address for which this function returns
307      * false is an externally-owned account (EOA) and not a contract.
308      *
309      * Among others, `isContract` will return false for the following 
310      * types of addresses:
311      *
312      *  - an externally-owned account
313      *  - a contract in construction
314      *  - an address where a contract will be created
315      *  - an address where a contract lived, but was destroyed
316      * ====
317      */
318     function isContract(address account) internal view returns (bool) {
319         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
320         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
321         // for accounts without code, i.e. `keccak256('')`
322         bytes32 codehash;
323         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
324         // solhint-disable-next-line no-inline-assembly
325         assembly { codehash := extcodehash(account) }
326         return (codehash != accountHash && codehash != 0x0);
327     }
328 
329     /**
330      * @dev Converts an `address` into `address payable`. Note that this is
331      * simply a type cast: the actual underlying value is not changed.
332      *
333      * _Available since v2.4.0._
334      */
335     function toPayable(address account) internal pure returns (address payable) {
336         return address(uint160(account));
337     }
338 
339     /**
340      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
341      * `recipient`, forwarding all available gas and reverting on errors.
342      *
343      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
344      * of certain opcodes, possibly making contracts go over the 2300 gas limit
345      * imposed by `transfer`, making them unable to receive funds via
346      * `transfer`. {sendValue} removes this limitation.
347      *
348      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
349      *
350      * IMPORTANT: because control is transferred to `recipient`, care must be
351      * taken to not create reentrancy vulnerabilities. Consider using
352      * {ReentrancyGuard} or the
353      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
354      *
355      * _Available since v2.4.0._
356      */
357     function sendValue(address payable recipient, uint256 amount) internal {
358         require(address(this).balance >= amount, "Address: insufficient balance");
359 
360         // solhint-disable-next-line avoid-call-value
361         (bool success, ) = recipient.call.value(amount)("");
362         require(success, "Address: unable to send value, recipient may have reverted");
363     }
364 }
365 
366 
367 /**
368  * @title SafeERC20
369  * @dev Wrappers around ERC20 operations that throw on failure (when the token
370  * contract returns false). Tokens that return no value (and instead revert or
371  * throw on failure) are also supported, non-reverting calls are assumed to be
372  * successful.
373  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
374  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
375  */
376 library SafeERC20 {
377     using SafeMath for uint256;
378     using Address for address;
379 
380     function safeTransfer(IERC20 token, address to, uint256 value) internal {
381         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
382     }
383 
384     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
385         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
386     }
387 
388     function safeApprove(IERC20 token, address spender, uint256 value) internal {
389         // safeApprove should only be called when setting an initial allowance,
390         // or when resetting it to zero. To increase and decrease it, use
391         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
392         // solhint-disable-next-line max-line-length
393         require((value == 0) || (token.allowance(address(this), spender) == 0),
394             "SafeERC20: approve from non-zero to non-zero allowance"
395         );
396         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
397     }
398 
399     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
400         uint256 newAllowance = token.allowance(address(this), spender).add(value);
401         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
402     }
403 
404     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
405         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
406         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
407     }
408 
409     /**
410      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
411      * on the return value: the return value is optional (but if data is returned, it must not be false).
412      * @param token The token targeted by the call.
413      * @param data The call data (encoded using abi.encode or one of its variants).
414      */
415     function callOptionalReturn(IERC20 token, bytes memory data) private {
416         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
417         // we're implementing it ourselves.
418 
419         // A Solidity high level call has three parts:
420         //  1. The target address is checked to verify it contains contract code
421         //  2. The call itself is made, and success asserted
422         //  3. The return value is decoded, which in turn checks the size of the returned data.
423         // solhint-disable-next-line max-line-length
424         require(address(token).isContract(), "SafeERC20: call to non-contract");
425 
426         // solhint-disable-next-line avoid-low-level-calls
427         (bool success, bytes memory returndata) = address(token).call(data);
428         require(success, "SafeERC20: low-level call failed");
429 
430         if (returndata.length > 0) { // Return data is optional
431             // solhint-disable-next-line max-line-length
432             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
433         }
434     }
435 }
436 
437 /*
438  * @dev Provides information about the current execution context, including the
439  * sender of the transaction and its data. While these are generally available
440  * via msg.sender and msg.data, they should not be accessed in such a direct
441  * manner, since when dealing with GSN meta-transactions the account sending and
442  * paying for execution may not be the actual sender (as far as an application
443  * is concerned).
444  *
445  * This contract is only required for intermediate, library-like contracts.
446  */
447 contract Context {
448     // Empty internal constructor, to prevent people from mistakenly deploying
449     // an instance of this contract, which should be used via inheritance.
450     constructor () internal { }
451     // solhint-disable-previous-line no-empty-blocks
452 
453     function _msgSender() internal view returns (address payable) {
454         return msg.sender;
455     }
456 
457     function _msgData() internal view returns (bytes memory) {
458         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
459         return msg.data;
460     }
461 }
462 
463 
464 /**
465  * @dev Implementation of the {IERC20} interface.
466  *
467  * This implementation is agnostic to the way tokens are created. This means
468  * that a supply mechanism has to be added in a derived contract using {_mint}.
469  * For a generic mechanism see {ERC20Mintable}.
470  *
471  * TIP: For a detailed writeup see our guide
472  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
473  * to implement supply mechanisms].
474  *
475  * We have followed general OpenZeppelin guidelines: functions revert instead
476  * of returning `false` on failure. This behavior is nonetheless conventional
477  * and does not conflict with the expectations of ERC20 applications.
478  *
479  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
480  * This allows applications to reconstruct the allowance for all accounts just
481  * by listening to said events. Other implementations of the EIP may not emit
482  * these events, as it isn't required by the specification.
483  *
484  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
485  * functions have been added to mitigate the well-known issues around setting
486  * allowances. See {IERC20-approve}.
487  */
488 contract ERC20 is Context, IERC20 {
489     using SafeMath for uint256;
490 
491     mapping (address => uint256) public _balances;
492 
493     mapping (address => mapping (address => uint256)) private _allowances;
494 
495     uint256 private _totalSupply;
496 
497     /**
498      * @dev See {IERC20-totalSupply}.
499      */
500     function totalSupply() public view returns (uint256) {
501         return _totalSupply;
502     }
503 
504     /**
505      * @dev See {IERC20-balanceOf}.
506      */
507     function balanceOf(address account) public view returns (uint256) {
508         return _balances[account];
509     }
510 
511     /**
512      * @dev See {IERC20-transfer}.
513      *
514      * Requirements:
515      *
516      * - `recipient` cannot be the zero address.
517      * - the caller must have a balance of at least `amount`.
518      */
519     function transfer(address recipient, uint256 amount) public returns (bool) {
520         _transfer(_msgSender(), recipient, amount);
521         return true;
522     }
523 
524     /**
525      * @dev See {IERC20-allowance}.
526      */
527     function allowance(address owner, address spender) public view returns (uint256) {
528         return _allowances[owner][spender];
529     }
530 
531     /**
532      * @dev See {IERC20-approve}.
533      *
534      * Requirements:
535      *
536      * - `spender` cannot be the zero address.
537      */
538     function approve(address spender, uint256 amount) public returns (bool) {
539         _approve(_msgSender(), spender, amount);
540         return true;
541     }
542 
543     /**
544      * @dev See {IERC20-transferFrom}.
545      *
546      * Emits an {Approval} event indicating the updated allowance. This is not
547      * required by the EIP. See the note at the beginning of {ERC20};
548      *
549      * Requirements:
550      * - `sender` and `recipient` cannot be the zero address.
551      * - `sender` must have a balance of at least `amount`.
552      * - the caller must have allowance for `sender`'s tokens of at least
553      * `amount`.
554      */
555     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
556         _transfer(sender, recipient, amount);
557         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
558         return true;
559     }
560 
561     /**
562      * @dev Atomically increases the allowance granted to `spender` by the caller.
563      *
564      * This is an alternative to {approve} that can be used as a mitigation for
565      * problems described in {IERC20-approve}.
566      *
567      * Emits an {Approval} event indicating the updated allowance.
568      *
569      * Requirements:
570      *
571      * - `spender` cannot be the zero address.
572      */
573     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
574         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
575         return true;
576     }
577 
578     /**
579      * @dev Atomically decreases the allowance granted to `spender` by the caller.
580      *
581      * This is an alternative to {approve} that can be used as a mitigation for
582      * problems described in {IERC20-approve}.
583      *
584      * Emits an {Approval} event indicating the updated allowance.
585      *
586      * Requirements:
587      *
588      * - `spender` cannot be the zero address.
589      * - `spender` must have allowance for the caller of at least
590      * `subtractedValue`.
591      */
592     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
593         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
594         return true;
595     }
596 
597     /**
598      * @dev Moves tokens `amount` from `sender` to `recipient`.
599      *
600      * This is internal function is equivalent to {transfer}, and can be used to
601      * e.g. implement automatic token fees, slashing mechanisms, etc.
602      *
603      * Emits a {Transfer} event.
604      *
605      * Requirements:
606      *
607      * - `sender` cannot be the zero address.
608      * - `recipient` cannot be the zero address.
609      * - `sender` must have a balance of at least `amount`.
610      */
611     function _transfer(address sender, address recipient, uint256 amount) internal {
612         require(sender != address(0), "ERC20: transfer from the zero address");
613         require(recipient != address(0), "ERC20: transfer to the zero address");
614 
615         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
616         _balances[recipient] = _balances[recipient].add(amount);
617         emit Transfer(sender, recipient, amount);
618     }
619 
620     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
621      * the total supply.
622      *
623      * Emits a {Transfer} event with `from` set to the zero address.
624      *
625      * Requirements
626      *
627      * - `to` cannot be the zero address.
628      */
629     function _mint(address account, uint256 amount) internal {
630         require(account != address(0), "ERC20: mint to the zero address");
631 
632         _totalSupply = _totalSupply.add(amount);
633         _balances[account] = _balances[account].add(amount);
634         emit Transfer(address(0), account, amount);
635     }
636 
637     /**
638      * @dev Destroys `amount` tokens from `account`, reducing the
639      * total supply.
640      *
641      * Emits a {Transfer} event with `to` set to the zero address.
642      *
643      * Requirements
644      *
645      * - `account` cannot be the zero address.
646      * - `account` must have at least `amount` tokens.
647      */
648     function _burn(address account, uint256 amount) internal {
649         require(account != address(0), "ERC20: burn from the zero address");
650 
651         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
652         _totalSupply = _totalSupply.sub(amount);
653         emit Transfer(account, address(0), amount);
654     }
655 
656     /**
657      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
658      *
659      * This is internal function is equivalent to `approve`, and can be used to
660      * e.g. set automatic allowances for certain subsystems, etc.
661      *
662      * Emits an {Approval} event.
663      *
664      * Requirements:
665      *
666      * - `owner` cannot be the zero address.
667      * - `spender` cannot be the zero address.
668      */
669     function _approve(address owner, address spender, uint256 amount) internal {
670         require(owner != address(0), "ERC20: approve from the zero address");
671         require(spender != address(0), "ERC20: approve to the zero address");
672 
673         _allowances[owner][spender] = amount;
674         emit Approval(owner, spender, amount);
675     }
676 
677     /**
678      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
679      * from the caller's allowance.
680      *
681      * See {_burn} and {_approve}.
682      */
683     function _burnFrom(address account, uint256 amount) internal {
684         _burn(account, amount);
685         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
686     }
687 }
688 
689 contract Governance {
690 
691     address public _governance;
692 
693     constructor() public {
694         _governance = tx.origin;
695     }
696 
697     event GovernanceTransferred(address indexed previousOwner, address indexed newOwner);
698 
699     modifier onlyGovernance {
700         require(msg.sender == _governance, "Sender not governance");
701         _;
702     }
703 
704     function setGovernance(address governance)  public  onlyGovernance
705     {
706         require(governance != address(0), "new governance the zero address");
707         emit GovernanceTransferred(_governance, governance);
708         _governance = governance;
709     }
710 
711 
712 }
713 
714 contract APowerToken is Governance, ERC20, ERC20infos {
715     using SafeERC20 for IERC20;
716     using Address for address;
717     using SafeMath for uint256;
718 
719 
720     mapping(address => bool) public _minters;
721 
722     uint256 internal _totalSupply;
723     mapping(address => mapping(address => uint256)) public _allowances;
724     
725     event Burn(address indexed burner, uint256 value);
726     
727     /**
728      * CONSTRUCTOR
729      *
730      * @dev Initialize the Token
731      */
732 
733     constructor() public ERC20infos("ArtPower", "APWR", 18) {}
734 
735     function mint(address account, uint256 amount) public {
736         require(_minters[msg.sender], "!minter");
737         _mint(account, amount);
738     }
739 
740     function burnFrom(address account, uint256 _value) public {
741         require(_value > 0);
742         require(_value <= _balances[account]);
743 
744         _burnFrom( account, _value );
745         emit Burn( account, _value);
746     }
747 
748     function addMinter(address minter) public onlyGovernance{
749         _minters[minter] = true;
750     }
751 
752     function removeMinter(address minter) public onlyGovernance {
753         _minters[minter] = false;
754     }
755 }