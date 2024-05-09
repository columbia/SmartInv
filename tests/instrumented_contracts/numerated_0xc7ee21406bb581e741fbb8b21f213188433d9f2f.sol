1 // File: @openzeppelin/contracts/utils/Address.sol
2 
3 pragma solidity ^0.5.5;
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following 
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
28         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
29         // for accounts without code, i.e. `keccak256('')`
30         bytes32 codehash;
31         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { codehash := extcodehash(account) }
34         return (codehash != accountHash && codehash != 0x0);
35     }
36 
37     /**
38      * @dev Converts an `address` into `address payable`. Note that this is
39      * simply a type cast: the actual underlying value is not changed.
40      *
41      * _Available since v2.4.0._
42      */
43     function toPayable(address account) internal pure returns (address payable) {
44         return address(uint160(account));
45     }
46 
47     /**
48      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
49      * `recipient`, forwarding all available gas and reverting on errors.
50      *
51      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
52      * of certain opcodes, possibly making contracts go over the 2300 gas limit
53      * imposed by `transfer`, making them unable to receive funds via
54      * `transfer`. {sendValue} removes this limitation.
55      *
56      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
57      *
58      * IMPORTANT: because control is transferred to `recipient`, care must be
59      * taken to not create reentrancy vulnerabilities. Consider using
60      * {ReentrancyGuard} or the
61      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
62      *
63      * _Available since v2.4.0._
64      */
65     function sendValue(address payable recipient, uint256 amount) internal {
66         require(address(this).balance >= amount, "Address: insufficient balance");
67 
68         // solhint-disable-next-line avoid-call-value
69         (bool success, ) = recipient.call.value(amount)("");
70         require(success, "Address: unable to send value, recipient may have reverted");
71     }
72 }
73 
74 // File: @openzeppelin/contracts/math/Math.sol
75 
76 pragma solidity ^0.5.0;
77 
78 /**
79  * @dev Standard math utilities missing in the Solidity language.
80  */
81 library Math {
82     /**
83      * @dev Returns the largest of two numbers.
84      */
85     function max(uint256 a, uint256 b) internal pure returns (uint256) {
86         return a >= b ? a : b;
87     }
88 
89     /**
90      * @dev Returns the smallest of two numbers.
91      */
92     function min(uint256 a, uint256 b) internal pure returns (uint256) {
93         return a < b ? a : b;
94     }
95 
96     /**
97      * @dev Returns the average of two numbers. The result is rounded towards
98      * zero.
99      */
100     function average(uint256 a, uint256 b) internal pure returns (uint256) {
101         // (a + b) / 2 can overflow, so we distribute
102         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
103     }
104 }
105 
106 // File: @openzeppelin/contracts/math/SafeMath.sol
107 
108 pragma solidity ^0.5.0;
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      * - Addition cannot overflow.
132      */
133     function add(uint256 a, uint256 b) internal pure returns (uint256) {
134         uint256 c = a + b;
135         require(c >= a, "SafeMath: addition overflow");
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the subtraction of two unsigned integers, reverting on
142      * overflow (when the result is negative).
143      *
144      * Counterpart to Solidity's `-` operator.
145      *
146      * Requirements:
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      * - Subtraction cannot overflow.
161      *
162      * _Available since v2.4.0._
163      */
164     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b <= a, errorMessage);
166         uint256 c = a - b;
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the multiplication of two unsigned integers, reverting on
173      * overflow.
174      *
175      * Counterpart to Solidity's `*` operator.
176      *
177      * Requirements:
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         return div(a, b, "SafeMath: division by zero");
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      * - The divisor cannot be zero.
219      *
220      * _Available since v2.4.0._
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         // Solidity only automatically asserts when dividing by 0
224         require(b > 0, errorMessage);
225         uint256 c = a / b;
226         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      * - The divisor cannot be zero.
256      *
257      * _Available since v2.4.0._
258      */
259     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
260         require(b != 0, errorMessage);
261         return a % b;
262     }
263 }
264 
265 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
266 
267 pragma solidity ^0.5.0;
268 
269 /**
270  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
271  * the optional functions; to access them see {ERC20Detailed}.
272  */
273 interface IERC20 {
274     /**
275      * @dev Returns the amount of tokens in existence.
276      */
277     function totalSupply() external view returns (uint256);
278 
279     /**
280      * @dev Returns the amount of tokens owned by `account`.
281      */
282     function balanceOf(address account) external view returns (uint256);
283 
284     /**
285      * @dev Moves `amount` tokens from the caller's account to `recipient`.
286      *
287      * Returns a boolean value indicating whether the operation succeeded.
288      *
289      * Emits a {Transfer} event.
290      */
291     function transfer(address recipient, uint256 amount) external returns (bool);
292 
293     /**
294      * @dev Returns the remaining number of tokens that `spender` will be
295      * allowed to spend on behalf of `owner` through {transferFrom}. This is
296      * zero by default.
297      *
298      * This value changes when {approve} or {transferFrom} are called.
299      */
300     function allowance(address owner, address spender) external view returns (uint256);
301 
302     /**
303      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
304      *
305      * Returns a boolean value indicating whether the operation succeeded.
306      *
307      * IMPORTANT: Beware that changing an allowance with this method brings the risk
308      * that someone may use both the old and the new allowance by unfortunate
309      * transaction ordering. One possible solution to mitigate this race
310      * condition is to first reduce the spender's allowance to 0 and set the
311      * desired value afterwards:
312      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
313      *
314      * Emits an {Approval} event.
315      */
316     function approve(address spender, uint256 amount) external returns (bool);
317 
318     /**
319      * @dev Moves `amount` tokens from `sender` to `recipient` using the
320      * allowance mechanism. `amount` is then deducted from the caller's
321      * allowance.
322      *
323      * Returns a boolean value indicating whether the operation succeeded.
324      *
325      * Emits a {Transfer} event.
326      */
327     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
328 
329     /**
330      * @dev Emitted when `value` tokens are moved from one account (`from`) to
331      * another (`to`).
332      *
333      * Note that `value` may be zero.
334      */
335     event Transfer(address indexed from, address indexed to, uint256 value);
336 
337     /**
338      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
339      * a call to {approve}. `value` is the new allowance.
340      */
341     event Approval(address indexed owner, address indexed spender, uint256 value);
342 }
343 
344 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
345 
346 pragma solidity ^0.5.0;
347 
348 
349 
350 
351 /**
352  * @title SafeERC20
353  * @dev Wrappers around ERC20 operations that throw on failure (when the token
354  * contract returns false). Tokens that return no value (and instead revert or
355  * throw on failure) are also supported, non-reverting calls are assumed to be
356  * successful.
357  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
358  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
359  */
360 library SafeERC20 {
361     using SafeMath for uint256;
362     using Address for address;
363 
364     function safeTransfer(IERC20 token, address to, uint256 value) internal {
365         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
366     }
367 
368     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
369         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
370     }
371 
372     function safeApprove(IERC20 token, address spender, uint256 value) internal {
373         // safeApprove should only be called when setting an initial allowance,
374         // or when resetting it to zero. To increase and decrease it, use
375         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
376         // solhint-disable-next-line max-line-length
377         require((value == 0) || (token.allowance(address(this), spender) == 0),
378             "SafeERC20: approve from non-zero to non-zero allowance"
379         );
380         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
381     }
382 
383     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
384         uint256 newAllowance = token.allowance(address(this), spender).add(value);
385         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
386     }
387 
388     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
389         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
390         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
391     }
392 
393     /**
394      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
395      * on the return value: the return value is optional (but if data is returned, it must not be false).
396      * @param token The token targeted by the call.
397      * @param data The call data (encoded using abi.encode or one of its variants).
398      */
399     function callOptionalReturn(IERC20 token, bytes memory data) private {
400         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
401         // we're implementing it ourselves.
402 
403         // A Solidity high level call has three parts:
404         //  1. The target address is checked to verify it contains contract code
405         //  2. The call itself is made, and success asserted
406         //  3. The return value is decoded, which in turn checks the size of the returned data.
407         // solhint-disable-next-line max-line-length
408         require(address(token).isContract(), "SafeERC20: call to non-contract");
409 
410         // solhint-disable-next-line avoid-low-level-calls
411         (bool success, bytes memory returndata) = address(token).call(data);
412         require(success, "SafeERC20: low-level call failed");
413 
414         if (returndata.length > 0) { // Return data is optional
415             // solhint-disable-next-line max-line-length
416             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
417         }
418     }
419 }
420 
421 // File: @openzeppelin/contracts/GSN/Context.sol
422 
423 pragma solidity ^0.5.0;
424 
425 /*
426  * @dev Provides information about the current execution context, including the
427  * sender of the transaction and its data. While these are generally available
428  * via msg.sender and msg.data, they should not be accessed in such a direct
429  * manner, since when dealing with GSN meta-transactions the account sending and
430  * paying for execution may not be the actual sender (as far as an application
431  * is concerned).
432  *
433  * This contract is only required for intermediate, library-like contracts.
434  */
435 contract Context {
436     // Empty internal constructor, to prevent people from mistakenly deploying
437     // an instance of this contract, which should be used via inheritance.
438     constructor () internal { }
439     // solhint-disable-previous-line no-empty-blocks
440 
441     function _msgSender() internal view returns (address payable) {
442         return msg.sender;
443     }
444 
445     function _msgData() internal view returns (bytes memory) {
446         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
447         return msg.data;
448     }
449 }
450 
451 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
452 
453 pragma solidity ^0.5.0;
454 
455 
456 
457 
458 /**
459  * @dev Implementation of the {IERC20} interface.
460  *
461  * This implementation is agnostic to the way tokens are created. This means
462  * that a supply mechanism has to be added in a derived contract using {_mint}.
463  * For a generic mechanism see {ERC20Mintable}.
464  *
465  * TIP: For a detailed writeup see our guide
466  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
467  * to implement supply mechanisms].
468  *
469  * We have followed general OpenZeppelin guidelines: functions revert instead
470  * of returning `false` on failure. This behavior is nonetheless conventional
471  * and does not conflict with the expectations of ERC20 applications.
472  *
473  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
474  * This allows applications to reconstruct the allowance for all accounts just
475  * by listening to said events. Other implementations of the EIP may not emit
476  * these events, as it isn't required by the specification.
477  *
478  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
479  * functions have been added to mitigate the well-known issues around setting
480  * allowances. See {IERC20-approve}.
481  */
482 contract ERC20 is Context, IERC20 {
483     using SafeMath for uint256;
484 
485     mapping (address => uint256) private _balances;
486 
487     mapping (address => mapping (address => uint256)) private _allowances;
488 
489     uint256 private _totalSupply;
490 
491     /**
492      * @dev See {IERC20-totalSupply}.
493      */
494     function totalSupply() public view returns (uint256) {
495         return _totalSupply;
496     }
497 
498     /**
499      * @dev See {IERC20-balanceOf}.
500      */
501     function balanceOf(address account) public view returns (uint256) {
502         return _balances[account];
503     }
504 
505     /**
506      * @dev See {IERC20-transfer}.
507      *
508      * Requirements:
509      *
510      * - `recipient` cannot be the zero address.
511      * - the caller must have a balance of at least `amount`.
512      */
513     function transfer(address recipient, uint256 amount) public returns (bool) {
514         _transfer(_msgSender(), recipient, amount);
515         return true;
516     }
517 
518     /**
519      * @dev See {IERC20-allowance}.
520      */
521     function allowance(address owner, address spender) public view returns (uint256) {
522         return _allowances[owner][spender];
523     }
524 
525     /**
526      * @dev See {IERC20-approve}.
527      *
528      * Requirements:
529      *
530      * - `spender` cannot be the zero address.
531      */
532     function approve(address spender, uint256 amount) public returns (bool) {
533         _approve(_msgSender(), spender, amount);
534         return true;
535     }
536 
537     /**
538      * @dev See {IERC20-transferFrom}.
539      *
540      * Emits an {Approval} event indicating the updated allowance. This is not
541      * required by the EIP. See the note at the beginning of {ERC20};
542      *
543      * Requirements:
544      * - `sender` and `recipient` cannot be the zero address.
545      * - `sender` must have a balance of at least `amount`.
546      * - the caller must have allowance for `sender`'s tokens of at least
547      * `amount`.
548      */
549     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
550         _transfer(sender, recipient, amount);
551         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
552         return true;
553     }
554 
555     /**
556      * @dev Atomically increases the allowance granted to `spender` by the caller.
557      *
558      * This is an alternative to {approve} that can be used as a mitigation for
559      * problems described in {IERC20-approve}.
560      *
561      * Emits an {Approval} event indicating the updated allowance.
562      *
563      * Requirements:
564      *
565      * - `spender` cannot be the zero address.
566      */
567     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
568         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
569         return true;
570     }
571 
572     /**
573      * @dev Atomically decreases the allowance granted to `spender` by the caller.
574      *
575      * This is an alternative to {approve} that can be used as a mitigation for
576      * problems described in {IERC20-approve}.
577      *
578      * Emits an {Approval} event indicating the updated allowance.
579      *
580      * Requirements:
581      *
582      * - `spender` cannot be the zero address.
583      * - `spender` must have allowance for the caller of at least
584      * `subtractedValue`.
585      */
586     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
587         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
588         return true;
589     }
590 
591     /**
592      * @dev Moves tokens `amount` from `sender` to `recipient`.
593      *
594      * This is internal function is equivalent to {transfer}, and can be used to
595      * e.g. implement automatic token fees, slashing mechanisms, etc.
596      *
597      * Emits a {Transfer} event.
598      *
599      * Requirements:
600      *
601      * - `sender` cannot be the zero address.
602      * - `recipient` cannot be the zero address.
603      * - `sender` must have a balance of at least `amount`.
604      */
605     function _transfer(address sender, address recipient, uint256 amount) internal {
606         require(sender != address(0), "ERC20: transfer from the zero address");
607         require(recipient != address(0), "ERC20: transfer to the zero address");
608 
609         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
610         _balances[recipient] = _balances[recipient].add(amount);
611         emit Transfer(sender, recipient, amount);
612     }
613 
614     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
615      * the total supply.
616      *
617      * Emits a {Transfer} event with `from` set to the zero address.
618      *
619      * Requirements
620      *
621      * - `to` cannot be the zero address.
622      */
623     function _mint(address account, uint256 amount) internal {
624         require(account != address(0), "ERC20: mint to the zero address");
625 
626         _totalSupply = _totalSupply.add(amount);
627         _balances[account] = _balances[account].add(amount);
628         emit Transfer(address(0), account, amount);
629     }
630 
631     /**
632      * @dev Destroys `amount` tokens from `account`, reducing the
633      * total supply.
634      *
635      * Emits a {Transfer} event with `to` set to the zero address.
636      *
637      * Requirements
638      *
639      * - `account` cannot be the zero address.
640      * - `account` must have at least `amount` tokens.
641      */
642     function _burn(address account, uint256 amount) internal {
643         require(account != address(0), "ERC20: burn from the zero address");
644 
645         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
646         _totalSupply = _totalSupply.sub(amount);
647         emit Transfer(account, address(0), amount);
648     }
649 
650     /**
651      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
652      *
653      * This is internal function is equivalent to `approve`, and can be used to
654      * e.g. set automatic allowances for certain subsystems, etc.
655      *
656      * Emits an {Approval} event.
657      *
658      * Requirements:
659      *
660      * - `owner` cannot be the zero address.
661      * - `spender` cannot be the zero address.
662      */
663     function _approve(address owner, address spender, uint256 amount) internal {
664         require(owner != address(0), "ERC20: approve from the zero address");
665         require(spender != address(0), "ERC20: approve to the zero address");
666 
667         _allowances[owner][spender] = amount;
668         emit Approval(owner, spender, amount);
669     }
670 
671     /**
672      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
673      * from the caller's allowance.
674      *
675      * See {_burn} and {_approve}.
676      */
677     function _burnFrom(address account, uint256 amount) internal {
678         _burn(account, amount);
679         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
680     }
681 }
682 
683 // File: @openzeppelin/contracts/token/ERC20/ERC20Detailed.sol
684 
685 pragma solidity ^0.5.0;
686 
687 
688 /**
689  * @dev Optional functions from the ERC20 standard.
690  */
691 contract ERC20Detailed is IERC20 {
692     string private _name;
693     string private _symbol;
694     uint8 private _decimals;
695 
696     /**
697      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
698      * these values are immutable: they can only be set once during
699      * construction.
700      */
701     constructor (string memory name, string memory symbol, uint8 decimals) public {
702         _name = name;
703         _symbol = symbol;
704         _decimals = decimals;
705     }
706 
707     /**
708      * @dev Returns the name of the token.
709      */
710     function name() public view returns (string memory) {
711         return _name;
712     }
713 
714     /**
715      * @dev Returns the symbol of the token, usually a shorter version of the
716      * name.
717      */
718     function symbol() public view returns (string memory) {
719         return _symbol;
720     }
721 
722     /**
723      * @dev Returns the number of decimals used to get its user representation.
724      * For example, if `decimals` equals `2`, a balance of `505` tokens should
725      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
726      *
727      * Tokens usually opt for a value of 18, imitating the relationship between
728      * Ether and Wei.
729      *
730      * NOTE: This information is only used for _display_ purposes: it in
731      * no way affects any of the arithmetic of the contract, including
732      * {IERC20-balanceOf} and {IERC20-transfer}.
733      */
734     function decimals() public view returns (uint8) {
735         return _decimals;
736     }
737 }
738 
739 // File: contracts/hardworkInterface/IStrategy.sol
740 
741 pragma solidity 0.5.16;
742 
743 
744 interface IStrategy {
745     
746     function unsalvagableTokens(address tokens) external view returns (bool);
747     
748     function governance() external view returns (address);
749     function controller() external view returns (address);
750     function underlying() external view returns (address);
751     function vault() external view returns (address);
752 
753     function withdrawAllToVault() external;
754     function withdrawToVault(uint256 amount) external;
755 
756     function investedUnderlyingBalance() external view returns (uint256); // itsNotMuch()
757 
758     // should only be called by controller
759     function salvage(address recipient, address token, uint256 amount) external;
760 
761     function doHardWork() external;
762     function depositArbCheck() external view returns(bool);
763 }
764 
765 // File: contracts/hardworkInterface/IController.sol
766 
767 pragma solidity 0.5.16;
768 
769 interface IController {
770     // [Grey list]
771     // An EOA can safely interact with the system no matter what.
772     // If you're using Metamask, you're using an EOA.
773     // Only smart contracts may be affected by this grey list.
774     //
775     // This contract will not be able to ban any EOA from the system
776     // even if an EOA is being added to the greyList, he/she will still be able
777     // to interact with the whole system as if nothing happened.
778     // Only smart contracts will be affected by being added to the greyList.
779     // This grey list is only used in Vault.sol, see the code there for reference
780     function greyList(address _target) external returns(bool);
781 
782     function addVaultAndStrategy(address _vault, address _strategy) external;
783     function doHardWork(address _vault) external;
784     function hasVault(address _vault) external returns(bool);
785 
786     function salvage(address _token, uint256 amount) external;
787     function salvageStrategy(address _strategy, address _token, uint256 amount) external;
788 
789     function notifyFee(address _underlying, uint256 fee) external;
790     function profitSharingNumerator() external view returns (uint256);
791     function profitSharingDenominator() external view returns (uint256);
792 }
793 
794 // File: contracts/Storage.sol
795 
796 pragma solidity 0.5.16;
797 
798 contract Storage {
799 
800   address public governance;
801   address public controller;
802 
803   constructor() public {
804     governance = msg.sender;
805   }
806 
807   modifier onlyGovernance() {
808     require(isGovernance(msg.sender), "Not governance");
809     _;
810   }
811 
812   function setGovernance(address _governance) public onlyGovernance {
813     require(_governance != address(0), "new governance shouldn't be empty");
814     governance = _governance;
815   }
816 
817   function setController(address _controller) public onlyGovernance {
818     require(_controller != address(0), "new controller shouldn't be empty");
819     controller = _controller;
820   }
821 
822   function isGovernance(address account) public view returns (bool) {
823     return account == governance;
824   }
825 
826   function isController(address account) public view returns (bool) {
827     return account == controller;
828   }
829 }
830 
831 // File: contracts/Governable.sol
832 
833 pragma solidity 0.5.16;
834 
835 
836 contract Governable {
837 
838   Storage public store;
839 
840   constructor(address _store) public {
841     require(_store != address(0), "new storage shouldn't be empty");
842     store = Storage(_store);
843   }
844 
845   modifier onlyGovernance() {
846     require(store.isGovernance(msg.sender), "Not governance");
847     _;
848   }
849 
850   function setStorage(address _store) public onlyGovernance {
851     require(_store != address(0), "new storage shouldn't be empty");
852     store = Storage(_store);
853   }
854 
855   function governance() public view returns (address) {
856     return store.governance();
857   }
858 }
859 
860 // File: contracts/hardworkInterface/IVault.sol
861 
862 pragma solidity 0.5.16;
863 
864 
865 interface IVault {
866     // the IERC20 part is the share
867 
868     function underlyingBalanceInVault() external view returns (uint256);
869     function underlyingBalanceWithInvestment() external view returns (uint256);
870 
871     function governance() external view returns (address);
872     function controller() external view returns (address);
873     function underlying() external view returns (address);
874     function strategy() external view returns (address);
875 
876     function setStrategy(address _strategy) external;
877     function setVaultFractionToInvest(uint256 numerator, uint256 denominator) external;
878 
879     function deposit(uint256 amountWei) external;
880     function depositFor(uint256 amountWei, address holder) external;
881 
882     function withdrawAll() external;
883     function withdraw(uint256 numberOfShares) external;
884     function getPricePerFullShare() external view returns (uint256);
885 
886     function underlyingBalanceWithInvestmentForHolder(address holder) view external returns (uint256);
887 
888     // hard work should be callable only by the controller (by the hard worker) or by governance
889     function doHardWork() external;
890     function rebalance() external;
891 }
892 
893 // File: contracts/Controllable.sol
894 
895 pragma solidity 0.5.16;
896 
897 
898 contract Controllable is Governable {
899 
900   constructor(address _storage) Governable(_storage) public {
901   }
902 
903   modifier onlyController() {
904     require(store.isController(msg.sender), "Not a controller");
905     _;
906   }
907 
908   modifier onlyControllerOrGovernance(){
909     require((store.isController(msg.sender) || store.isGovernance(msg.sender)),
910       "The caller must be controller or governance");
911     _;
912   }
913 
914   function controller() public view returns (address) {
915     return store.controller();
916   }
917 }
918 
919 // File: contracts/Vault.sol
920 
921 pragma solidity 0.5.16;
922 
923 
924 
925 
926 
927 
928 
929 
930 
931 
932 
933 
934 
935 contract Vault is ERC20, ERC20Detailed, IVault, Controllable {
936   using SafeERC20 for IERC20;
937   using Address for address;
938   using SafeMath for uint256;
939 
940   event Withdraw(address indexed beneficiary, uint256 amount);
941   event Deposit(address indexed beneficiary, uint256 amount);
942   event Invest(uint256 amount);
943 
944   IStrategy public strategy;
945   IERC20 public underlying;
946 
947   uint256 public underlyingUnit;
948 
949   mapping(address => uint256) public contributions;
950   mapping(address => uint256) public withdrawals;
951 
952   uint256 public vaultFractionToInvestNumerator;
953   uint256 public vaultFractionToInvestDenominator;
954 
955   constructor(address _storage,
956       address _underlying,
957       uint256 _toInvestNumerator,
958       uint256 _toInvestDenominator
959   ) ERC20Detailed(
960     string(abi.encodePacked("FARM_", ERC20Detailed(_underlying).symbol())),
961     string(abi.encodePacked("f", ERC20Detailed(_underlying).symbol())),
962     ERC20Detailed(_underlying).decimals()
963   ) Controllable(_storage) public {
964     underlying = IERC20(_underlying);
965     require(_toInvestNumerator <= _toInvestDenominator, "cannot invest more than 100%");
966     require(_toInvestDenominator != 0, "cannot divide by 0");
967     vaultFractionToInvestDenominator = _toInvestDenominator;
968     vaultFractionToInvestNumerator = _toInvestNumerator;
969     underlyingUnit = 10 ** uint256(ERC20Detailed(address(underlying)).decimals());
970   }
971 
972   modifier whenStrategyDefined() {
973     require(address(strategy) != address(0), "Strategy must be defined");
974     _;
975   }
976 
977   // Only smart contracts will be affected by this modifier
978   modifier defense() {
979     require(
980       (msg.sender == tx.origin) ||                // If it is a normal user and not smart contract,
981                                                   // then the requirement will pass
982       !IController(controller()).greyList(msg.sender), // If it is a smart contract, then
983       "This smart contract has been grey listed"  // make sure that it is not on our greyList.
984     );
985     _;
986   }
987 
988   /**
989   * Chooses the best strategy and re-invests. If the strategy did not change, it just calls
990   * doHardWork on the current strategy. Call this through controller to claim hard rewards.
991   */
992   function doHardWork() whenStrategyDefined onlyControllerOrGovernance external {
993     // ensure that new funds are invested too
994     invest();
995     strategy.doHardWork();
996   }
997 
998   /*
999   * Returns the cash balance across all users in this contract.
1000   */
1001   function underlyingBalanceInVault() view public returns (uint256) {
1002     return underlying.balanceOf(address(this));
1003   }
1004 
1005   /* Returns the current underlying (e.g., DAI's) balance together with
1006    * the invested amount (if DAI is invested elsewhere by the strategy).
1007   */
1008   function underlyingBalanceWithInvestment() view public returns (uint256) {
1009     if (address(strategy) == address(0)) {
1010       // initial state, when not set
1011       return underlyingBalanceInVault();
1012     }
1013     return underlyingBalanceInVault().add(strategy.investedUnderlyingBalance());
1014   }
1015 
1016   /*
1017   * Allows for getting the total contributions ever made.
1018   */
1019   function getContributions(address holder) view public returns (uint256) {
1020     return contributions[holder];
1021   }
1022 
1023   /*
1024   * Allows for getting the total withdrawals ever made.
1025   */
1026   function getWithdrawals(address holder) view public returns (uint256) {
1027     return withdrawals[holder];
1028   }
1029 
1030   function getPricePerFullShare() public view returns (uint256) {
1031     return totalSupply() == 0
1032         ? underlyingUnit
1033         : underlyingUnit.mul(underlyingBalanceWithInvestment()).div(totalSupply());
1034   }
1035 
1036   /* get the user's share (in underlying)
1037   */
1038   function underlyingBalanceWithInvestmentForHolder(address holder) view external returns (uint256) {
1039     if (totalSupply() == 0) {
1040       return 0;
1041     }
1042     return underlyingBalanceWithInvestment()
1043         .mul(balanceOf(holder))
1044         .div(totalSupply());
1045   }
1046 
1047   function setStrategy(address _strategy) public onlyControllerOrGovernance {
1048     require(_strategy != address(0), "new _strategy cannot be empty");
1049     require(IStrategy(_strategy).underlying() == address(underlying), "Vault underlying must match Strategy underlying");
1050     require(IStrategy(_strategy).vault() == address(this), "the strategy does not belong to this vault");
1051 
1052     if (address(_strategy) != address(strategy)) {
1053       if (address(strategy) != address(0)) { // if the original strategy (no underscore) is defined
1054         underlying.safeApprove(address(strategy), 0);
1055         strategy.withdrawAllToVault();
1056       }
1057       strategy = IStrategy(_strategy);
1058       underlying.safeApprove(address(strategy), 0);
1059       underlying.safeApprove(address(strategy), uint256(~0));
1060     }
1061   }
1062 
1063   function setVaultFractionToInvest(uint256 numerator, uint256 denominator) external onlyGovernance {
1064     require(denominator > 0, "denominator must be greater than 0");
1065     require(numerator < denominator, "denominator must be greater than numerator");
1066     vaultFractionToInvestNumerator = numerator;
1067     vaultFractionToInvestDenominator = denominator;
1068   }
1069 
1070   function rebalance() external onlyControllerOrGovernance {
1071     withdrawAll();
1072     invest();
1073   }
1074 
1075   function availableToInvestOut() public view returns (uint256) {
1076     uint256 wantInvestInTotal = underlyingBalanceWithInvestment()
1077         .mul(vaultFractionToInvestNumerator)
1078         .div(vaultFractionToInvestDenominator);
1079     uint256 alreadyInvested = strategy.investedUnderlyingBalance();
1080     if (alreadyInvested >= wantInvestInTotal) {
1081       return 0;
1082     } else {
1083       uint256 remainingToInvest = wantInvestInTotal.sub(alreadyInvested);
1084       return remainingToInvest <= underlyingBalanceInVault()
1085         // TODO: we think that the "else" branch of the ternary operation is not
1086         // going to get hit
1087         ? remainingToInvest : underlyingBalanceInVault();
1088     }
1089   }
1090 
1091   function invest() internal whenStrategyDefined {
1092     uint256 availableAmount = availableToInvestOut();
1093     if (availableAmount > 0) {
1094       underlying.safeTransfer(address(strategy), availableAmount);
1095       emit Invest(availableAmount);
1096     }
1097   }
1098 
1099   /*
1100   * Allows for depositing the underlying asset in exchange for shares.
1101   * Approval is assumed.
1102   */
1103   function deposit(uint256 amount) external defense {
1104     _deposit(amount, msg.sender, msg.sender);
1105   }
1106 
1107   /*
1108   * Allows for depositing the underlying asset in exchange for shares
1109   * assigned to the holder.
1110   * This facilitates depositing for someone else (using DepositHelper)
1111   */
1112   function depositFor(uint256 amount, address holder) public defense {
1113     _deposit(amount, msg.sender, holder);
1114   }
1115 
1116   function withdrawAll() public onlyControllerOrGovernance whenStrategyDefined {
1117     strategy.withdrawAllToVault();
1118   }
1119 
1120   function withdraw(uint256 numberOfShares) external {
1121     require(totalSupply() > 0, "Vault has no shares");
1122     require(numberOfShares > 0, "numberOfShares must be greater than 0");
1123     uint256 totalSupply = totalSupply();
1124     _burn(msg.sender, numberOfShares);
1125 
1126     uint256 underlyingAmountToWithdraw = underlyingBalanceWithInvestment()
1127         .mul(numberOfShares)
1128         .div(totalSupply);
1129 
1130     if (underlyingAmountToWithdraw > underlyingBalanceInVault()) {
1131       // withdraw everything from the strategy to accurately check the share value
1132       if (numberOfShares == totalSupply) {
1133         strategy.withdrawAllToVault();
1134       } else {
1135         uint256 missing = underlyingAmountToWithdraw.sub(underlyingBalanceInVault());
1136         strategy.withdrawToVault(missing);
1137       }
1138       // recalculate to improve accuracy
1139       underlyingAmountToWithdraw = Math.min(underlyingBalanceWithInvestment()
1140           .mul(numberOfShares)
1141           .div(totalSupply), underlyingBalanceInVault());
1142     }
1143 
1144     underlying.safeTransfer(msg.sender, underlyingAmountToWithdraw);
1145 
1146     // update the withdrawal amount for the holder
1147     withdrawals[msg.sender] = withdrawals[msg.sender].add(underlyingAmountToWithdraw);
1148     emit Withdraw(msg.sender, underlyingAmountToWithdraw);
1149   }
1150 
1151   function _deposit(uint256 amount, address sender, address beneficiary) internal {
1152     require(amount > 0, "Cannot deposit 0");
1153     require(beneficiary != address(0), "holder must be defined");
1154 
1155     if (address(strategy) != address(0)) {
1156       require(strategy.depositArbCheck(), "Too much arb");
1157     }
1158 
1159     /*
1160       todo: Potentially exploitable with a flashloan if
1161       strategy under-reports the value.
1162     */
1163     uint256 toMint = totalSupply() == 0
1164         ? amount
1165         : amount.mul(totalSupply()).div(underlyingBalanceWithInvestment());
1166     _mint(beneficiary, toMint);
1167 
1168     underlying.safeTransferFrom(sender, address(this), amount);
1169 
1170     // update the contribution amount for the beneficiary
1171     contributions[beneficiary] = contributions[beneficiary].add(amount);
1172     emit Deposit(beneficiary, amount);
1173   }
1174 }
1175 
1176 // File: contracts/vaults/VaultUSDT.sol
1177 
1178 pragma solidity 0.5.16;
1179 
1180 
1181 contract VaultUSDT is Vault {
1182   constructor(address _controller,
1183       address _underlying,
1184       uint256 _toInvestNumerator,
1185       uint256 _toInvestDenominator
1186   ) Vault(
1187     _controller,
1188     _underlying,
1189     _toInvestNumerator,
1190     _toInvestDenominator
1191   ) public {
1192   }
1193 }