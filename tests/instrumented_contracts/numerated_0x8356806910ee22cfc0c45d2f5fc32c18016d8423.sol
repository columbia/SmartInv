1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 
4 pragma solidity ^0.6.0;
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 pragma solidity ^0.6.0;
31 
32 /**
33  * @dev Contract module which provides a basic access control mechanism, where
34  * there is an account (an owner) that can be granted exclusive access to
35  * specific functions.
36  *
37  * By default, the owner account will be the one that deploys the contract. This
38  * can later be changed with {transferOwnership}.
39  *
40  * This module is used through inheritance. It will make available the modifier
41  * `onlyOwner`, which can be applied to your functions to restrict their use to
42  * the owner.
43  */
44 contract Ownable is Context {
45     address private _owner;
46 
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * @dev Initializes the contract setting the deployer as the initial owner.
51      */
52     constructor () internal {
53         address msgSender = _msgSender();
54         _owner = msgSender;
55         emit OwnershipTransferred(address(0), msgSender);
56     }
57 
58     /**
59      * @dev Returns the address of the current owner.
60      */
61     function owner() public view returns (address) {
62         return _owner;
63     }
64 
65     /**
66      * @dev Throws if called by any account other than the owner.
67      */
68     modifier onlyOwner() {
69         require(_owner == _msgSender(), "Ownable: caller is not the owner");
70         _;
71     }
72 
73     /**
74      * @dev Leaves the contract without owner. It will not be possible to call
75      * `onlyOwner` functions anymore. Can only be called by the current owner.
76      *
77      * NOTE: Renouncing ownership will leave the contract without an owner,
78      * thereby removing any functionality that is only available to the owner.
79      */
80     function renounceOwnership() public virtual onlyOwner {
81         emit OwnershipTransferred(_owner, address(0));
82         _owner = address(0);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Can only be called by the current owner.
88      */
89     function transferOwnership(address newOwner) public virtual onlyOwner {
90         require(newOwner != address(0), "Ownable: new owner is the zero address");
91         emit OwnershipTransferred(_owner, newOwner);
92         _owner = newOwner;
93     }
94 }
95 
96 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
97 
98 
99 pragma solidity ^0.6.0;
100 
101 
102 
103 
104 /**
105  * @title SafeERC20
106  * @dev Wrappers around ERC20 operations that throw on failure (when the token
107  * contract returns false). Tokens that return no value (and instead revert or
108  * throw on failure) are also supported, non-reverting calls are assumed to be
109  * successful.
110  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
111  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
112  */
113 library SafeERC20 {
114     using SafeMath for uint256;
115     using Address for address;
116 
117     function safeTransfer(IERC20 token, address to, uint256 value) internal {
118         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
119     }
120 
121     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
122         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
123     }
124 
125     /**
126      * @dev Deprecated. This function has issues similar to the ones found in
127      * {IERC20-approve}, and its usage is discouraged.
128      *
129      * Whenever possible, use {safeIncreaseAllowance} and
130      * {safeDecreaseAllowance} instead.
131      */
132     function safeApprove(IERC20 token, address spender, uint256 value) internal {
133         // safeApprove should only be called when setting an initial allowance,
134         // or when resetting it to zero. To increase and decrease it, use
135         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
136         // solhint-disable-next-line max-line-length
137         require((value == 0) || (token.allowance(address(this), spender) == 0),
138             "SafeERC20: approve from non-zero to non-zero allowance"
139         );
140         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
141     }
142 
143     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
144         uint256 newAllowance = token.allowance(address(this), spender).add(value);
145         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
146     }
147 
148     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
149         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
150         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
151     }
152 
153     /**
154      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
155      * on the return value: the return value is optional (but if data is returned, it must not be false).
156      * @param token The token targeted by the call.
157      * @param data The call data (encoded using abi.encode or one of its variants).
158      */
159     function _callOptionalReturn(IERC20 token, bytes memory data) private {
160         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
161         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
162         // the target address contains contract code and also asserts for success in the low-level call.
163 
164         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
165         if (returndata.length > 0) { // Return data is optional
166             // solhint-disable-next-line max-line-length
167             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
168         }
169     }
170 }
171 
172 // File: @openzeppelin/contracts/utils/Address.sol
173 
174 
175 pragma solidity ^0.6.2;
176 
177 /**
178  * @dev Collection of functions related to the address type
179  */
180 library Address {
181     /**
182      * @dev Returns true if `account` is a contract.
183      *
184      * [IMPORTANT]
185      * ====
186      * It is unsafe to assume that an address for which this function returns
187      * false is an externally-owned account (EOA) and not a contract.
188      *
189      * Among others, `isContract` will return false for the following
190      * types of addresses:
191      *
192      *  - an externally-owned account
193      *  - a contract in construction
194      *  - an address where a contract will be created
195      *  - an address where a contract lived, but was destroyed
196      * ====
197      */
198     function isContract(address account) internal view returns (bool) {
199         // This method relies in extcodesize, which returns 0 for contracts in
200         // construction, since the code is only stored at the end of the
201         // constructor execution.
202 
203         uint256 size;
204         // solhint-disable-next-line no-inline-assembly
205         assembly { size := extcodesize(account) }
206         return size > 0;
207     }
208 
209     /**
210      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
211      * `recipient`, forwarding all available gas and reverting on errors.
212      *
213      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
214      * of certain opcodes, possibly making contracts go over the 2300 gas limit
215      * imposed by `transfer`, making them unable to receive funds via
216      * `transfer`. {sendValue} removes this limitation.
217      *
218      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
219      *
220      * IMPORTANT: because control is transferred to `recipient`, care must be
221      * taken to not create reentrancy vulnerabilities. Consider using
222      * {ReentrancyGuard} or the
223      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
224      */
225     function sendValue(address payable recipient, uint256 amount) internal {
226         require(address(this).balance >= amount, "Address: insufficient balance");
227 
228         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
229         (bool success, ) = recipient.call{ value: amount }("");
230         require(success, "Address: unable to send value, recipient may have reverted");
231     }
232 
233     /**
234      * @dev Performs a Solidity function call using a low level `call`. A
235      * plain`call` is an unsafe replacement for a function call: use this
236      * function instead.
237      *
238      * If `target` reverts with a revert reason, it is bubbled up by this
239      * function (like regular Solidity function calls).
240      *
241      * Returns the raw returned data. To convert to the expected return value,
242      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
243      *
244      * Requirements:
245      *
246      * - `target` must be a contract.
247      * - calling `target` with `data` must not revert.
248      *
249      * _Available since v3.1._
250      */
251     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
252       return functionCall(target, data, "Address: low-level call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
257      * `errorMessage` as a fallback revert reason when `target` reverts.
258      *
259      * _Available since v3.1._
260      */
261     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
262         return _functionCallWithValue(target, data, 0, errorMessage);
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
267      * but also transferring `value` wei to `target`.
268      *
269      * Requirements:
270      *
271      * - the calling contract must have an ETH balance of at least `value`.
272      * - the called Solidity function must be `payable`.
273      *
274      * _Available since v3.1._
275      */
276     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
282      * with `errorMessage` as a fallback revert reason when `target` reverts.
283      *
284      * _Available since v3.1._
285      */
286     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
287         require(address(this).balance >= value, "Address: insufficient balance for call");
288         return _functionCallWithValue(target, data, value, errorMessage);
289     }
290 
291     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
292         require(isContract(target), "Address: call to non-contract");
293 
294         // solhint-disable-next-line avoid-low-level-calls
295         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
296         if (success) {
297             return returndata;
298         } else {
299             // Look for revert reason and bubble it up if present
300             if (returndata.length > 0) {
301                 // The easiest way to bubble the revert reason is using memory via assembly
302 
303                 // solhint-disable-next-line no-inline-assembly
304                 assembly {
305                     let returndata_size := mload(returndata)
306                     revert(add(32, returndata), returndata_size)
307                 }
308             } else {
309                 revert(errorMessage);
310             }
311         }
312     }
313 }
314 
315 // File: @openzeppelin/contracts/math/SafeMath.sol
316 
317 
318 pragma solidity ^0.6.0;
319 
320 /**
321  * @dev Wrappers over Solidity's arithmetic operations with added overflow
322  * checks.
323  *
324  * Arithmetic operations in Solidity wrap on overflow. This can easily result
325  * in bugs, because programmers usually assume that an overflow raises an
326  * error, which is the standard behavior in high level programming languages.
327  * `SafeMath` restores this intuition by reverting the transaction when an
328  * operation overflows.
329  *
330  * Using this library instead of the unchecked operations eliminates an entire
331  * class of bugs, so it's recommended to use it always.
332  */
333 library SafeMath {
334     /**
335      * @dev Returns the addition of two unsigned integers, reverting on
336      * overflow.
337      *
338      * Counterpart to Solidity's `+` operator.
339      *
340      * Requirements:
341      *
342      * - Addition cannot overflow.
343      */
344     function add(uint256 a, uint256 b) internal pure returns (uint256) {
345         uint256 c = a + b;
346         require(c >= a, "SafeMath: addition overflow");
347 
348         return c;
349     }
350 
351     /**
352      * @dev Returns the subtraction of two unsigned integers, reverting on
353      * overflow (when the result is negative).
354      *
355      * Counterpart to Solidity's `-` operator.
356      *
357      * Requirements:
358      *
359      * - Subtraction cannot overflow.
360      */
361     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
362         return sub(a, b, "SafeMath: subtraction overflow");
363     }
364 
365     /**
366      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
367      * overflow (when the result is negative).
368      *
369      * Counterpart to Solidity's `-` operator.
370      *
371      * Requirements:
372      *
373      * - Subtraction cannot overflow.
374      */
375     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
376         require(b <= a, errorMessage);
377         uint256 c = a - b;
378 
379         return c;
380     }
381 
382     /**
383      * @dev Returns the multiplication of two unsigned integers, reverting on
384      * overflow.
385      *
386      * Counterpart to Solidity's `*` operator.
387      *
388      * Requirements:
389      *
390      * - Multiplication cannot overflow.
391      */
392     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
393         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
394         // benefit is lost if 'b' is also tested.
395         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
396         if (a == 0) {
397             return 0;
398         }
399 
400         uint256 c = a * b;
401         require(c / a == b, "SafeMath: multiplication overflow");
402 
403         return c;
404     }
405 
406     /**
407      * @dev Returns the integer division of two unsigned integers. Reverts on
408      * division by zero. The result is rounded towards zero.
409      *
410      * Counterpart to Solidity's `/` operator. Note: this function uses a
411      * `revert` opcode (which leaves remaining gas untouched) while Solidity
412      * uses an invalid opcode to revert (consuming all remaining gas).
413      *
414      * Requirements:
415      *
416      * - The divisor cannot be zero.
417      */
418     function div(uint256 a, uint256 b) internal pure returns (uint256) {
419         return div(a, b, "SafeMath: division by zero");
420     }
421 
422     /**
423      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
424      * division by zero. The result is rounded towards zero.
425      *
426      * Counterpart to Solidity's `/` operator. Note: this function uses a
427      * `revert` opcode (which leaves remaining gas untouched) while Solidity
428      * uses an invalid opcode to revert (consuming all remaining gas).
429      *
430      * Requirements:
431      *
432      * - The divisor cannot be zero.
433      */
434     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
435         require(b > 0, errorMessage);
436         uint256 c = a / b;
437         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
438 
439         return c;
440     }
441 
442     /**
443      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
444      * Reverts when dividing by zero.
445      *
446      * Counterpart to Solidity's `%` operator. This function uses a `revert`
447      * opcode (which leaves remaining gas untouched) while Solidity uses an
448      * invalid opcode to revert (consuming all remaining gas).
449      *
450      * Requirements:
451      *
452      * - The divisor cannot be zero.
453      */
454     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
455         return mod(a, b, "SafeMath: modulo by zero");
456     }
457 
458     /**
459      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
460      * Reverts with custom message when dividing by zero.
461      *
462      * Counterpart to Solidity's `%` operator. This function uses a `revert`
463      * opcode (which leaves remaining gas untouched) while Solidity uses an
464      * invalid opcode to revert (consuming all remaining gas).
465      *
466      * Requirements:
467      *
468      * - The divisor cannot be zero.
469      */
470     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
471         require(b != 0, errorMessage);
472         return a % b;
473     }
474 }
475 
476 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
477 
478 
479 pragma solidity ^0.6.0;
480 
481 /**
482  * @dev Interface of the ERC20 standard as defined in the EIP.
483  */
484 interface IERC20 {
485     /**
486      * @dev Returns the amount of tokens in existence.
487      */
488     function totalSupply() external view returns (uint256);
489 
490     /**
491      * @dev Returns the amount of tokens owned by `account`.
492      */
493     function balanceOf(address account) external view returns (uint256);
494 
495     /**
496      * @dev Moves `amount` tokens from the caller's account to `recipient`.
497      *
498      * Returns a boolean value indicating whether the operation succeeded.
499      *
500      * Emits a {Transfer} event.
501      */
502     function transfer(address recipient, uint256 amount) external returns (bool);
503 
504     /**
505      * @dev Returns the remaining number of tokens that `spender` will be
506      * allowed to spend on behalf of `owner` through {transferFrom}. This is
507      * zero by default.
508      *
509      * This value changes when {approve} or {transferFrom} are called.
510      */
511     function allowance(address owner, address spender) external view returns (uint256);
512 
513     /**
514      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
515      *
516      * Returns a boolean value indicating whether the operation succeeded.
517      *
518      * IMPORTANT: Beware that changing an allowance with this method brings the risk
519      * that someone may use both the old and the new allowance by unfortunate
520      * transaction ordering. One possible solution to mitigate this race
521      * condition is to first reduce the spender's allowance to 0 and set the
522      * desired value afterwards:
523      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
524      *
525      * Emits an {Approval} event.
526      */
527     function approve(address spender, uint256 amount) external returns (bool);
528 
529     /**
530      * @dev Moves `amount` tokens from `sender` to `recipient` using the
531      * allowance mechanism. `amount` is then deducted from the caller's
532      * allowance.
533      *
534      * Returns a boolean value indicating whether the operation succeeded.
535      *
536      * Emits a {Transfer} event.
537      */
538     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
539 
540     /**
541      * @dev Emitted when `value` tokens are moved from one account (`from`) to
542      * another (`to`).
543      *
544      * Note that `value` may be zero.
545      */
546     event Transfer(address indexed from, address indexed to, uint256 value);
547 
548     /**
549      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
550      * a call to {approve}. `value` is the new allowance.
551      */
552     event Approval(address indexed owner, address indexed spender, uint256 value);
553 }
554 
555 
556 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
557 
558 
559 pragma solidity ^0.6.0;
560 
561 
562 
563 
564 
565 /**
566  * @dev Implementation of the {IERC20} interface.
567  *
568  * This implementation is agnostic to the way tokens are created. This means
569  * that a supply mechanism has to be added in a derived contract using {_mint}.
570  * For a generic mechanism see {ERC20PresetMinterPauser}.
571  *
572  * TIP: For a detailed writeup see our guide
573  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
574  * to implement supply mechanisms].
575  *
576  * We have followed general OpenZeppelin guidelines: functions revert instead
577  * of returning `false` on failure. This behavior is nonetheless conventional
578  * and does not conflict with the expectations of ERC20 applications.
579  *
580  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
581  * This allows applications to reconstruct the allowance for all accounts just
582  * by listening to said events. Other implementations of the EIP may not emit
583  * these events, as it isn't required by the specification.
584  *
585  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
586  * functions have been added to mitigate the well-known issues around setting
587  * allowances. See {IERC20-approve}.
588  */
589 contract ERC20 is Context, IERC20 {
590     using SafeMath for uint256;
591     using Address for address;
592 
593     mapping (address => uint256) private _balances;
594 
595     mapping (address => mapping (address => uint256)) private _allowances;
596 
597     uint256 private _totalSupply;
598 
599     string private _name;
600     string private _symbol;
601     uint8 private _decimals;
602 
603     /**
604      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
605      * a default value of 18.
606      *
607      * To select a different value for {decimals}, use {_setupDecimals}.
608      *
609      * All three of these values are immutable: they can only be set once during
610      * construction.
611      */
612     constructor (string memory name, string memory symbol) public {
613         _name = name;
614         _symbol = symbol;
615         _decimals = 18;
616     }
617 
618     /**
619      * @dev Returns the name of the token.
620      */
621     function name() public view returns (string memory) {
622         return _name;
623     }
624 
625     /**
626      * @dev Returns the symbol of the token, usually a shorter version of the
627      * name.
628      */
629     function symbol() public view returns (string memory) {
630         return _symbol;
631     }
632 
633     /**
634      * @dev Returns the number of decimals used to get its user representation.
635      * For example, if `decimals` equals `2`, a balance of `505` tokens should
636      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
637      *
638      * Tokens usually opt for a value of 18, imitating the relationship between
639      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
640      * called.
641      *
642      * NOTE: This information is only used for _display_ purposes: it in
643      * no way affects any of the arithmetic of the contract, including
644      * {IERC20-balanceOf} and {IERC20-transfer}.
645      */
646     function decimals() public view returns (uint8) {
647         return _decimals;
648     }
649 
650     /**
651      * @dev See {IERC20-totalSupply}.
652      */
653     function totalSupply() public view override returns (uint256) {
654         return _totalSupply;
655     }
656 
657     /**
658      * @dev See {IERC20-balanceOf}.
659      */
660     function balanceOf(address account) public view override returns (uint256) {
661         return _balances[account];
662     }
663 
664     /**
665      * @dev See {IERC20-transfer}.
666      *
667      * Requirements:
668      *
669      * - `recipient` cannot be the zero address.
670      * - the caller must have a balance of at least `amount`.
671      */
672     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
673         _transfer(_msgSender(), recipient, amount);
674         return true;
675     }
676 
677     /**
678      * @dev See {IERC20-allowance}.
679      */
680     function allowance(address owner, address spender) public view virtual override returns (uint256) {
681         return _allowances[owner][spender];
682     }
683 
684     /**
685      * @dev See {IERC20-approve}.
686      *
687      * Requirements:
688      *
689      * - `spender` cannot be the zero address.
690      */
691     function approve(address spender, uint256 amount) public virtual override returns (bool) {
692         _approve(_msgSender(), spender, amount);
693         return true;
694     }
695 
696     /**
697      * @dev See {IERC20-transferFrom}.
698      *
699      * Emits an {Approval} event indicating the updated allowance. This is not
700      * required by the EIP. See the note at the beginning of {ERC20};
701      *
702      * Requirements:
703      * - `sender` and `recipient` cannot be the zero address.
704      * - `sender` must have a balance of at least `amount`.
705      * - the caller must have allowance for ``sender``'s tokens of at least
706      * `amount`.
707      */
708     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
709         _transfer(sender, recipient, amount);
710         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
711         return true;
712     }
713 
714     /**
715      * @dev Atomically increases the allowance granted to `spender` by the caller.
716      *
717      * This is an alternative to {approve} that can be used as a mitigation for
718      * problems described in {IERC20-approve}.
719      *
720      * Emits an {Approval} event indicating the updated allowance.
721      *
722      * Requirements:
723      *
724      * - `spender` cannot be the zero address.
725      */
726     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
727         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
728         return true;
729     }
730 
731     /**
732      * @dev Atomically decreases the allowance granted to `spender` by the caller.
733      *
734      * This is an alternative to {approve} that can be used as a mitigation for
735      * problems described in {IERC20-approve}.
736      *
737      * Emits an {Approval} event indicating the updated allowance.
738      *
739      * Requirements:
740      *
741      * - `spender` cannot be the zero address.
742      * - `spender` must have allowance for the caller of at least
743      * `subtractedValue`.
744      */
745     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
746         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
747         return true;
748     }
749 
750     /**
751      * @dev Moves tokens `amount` from `sender` to `recipient`.
752      *
753      * This is internal function is equivalent to {transfer}, and can be used to
754      * e.g. implement automatic token fees, slashing mechanisms, etc.
755      *
756      * Emits a {Transfer} event.
757      *
758      * Requirements:
759      *
760      * - `sender` cannot be the zero address.
761      * - `recipient` cannot be the zero address.
762      * - `sender` must have a balance of at least `amount`.
763      */
764     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
765         require(sender != address(0), "ERC20: transfer from the zero address");
766         require(recipient != address(0), "ERC20: transfer to the zero address");
767 
768         _beforeTokenTransfer(sender, recipient, amount);
769 
770         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
771         _balances[recipient] = _balances[recipient].add(amount);
772         emit Transfer(sender, recipient, amount);
773     }
774 
775     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
776      * the total supply.
777      *
778      * Emits a {Transfer} event with `from` set to the zero address.
779      *
780      * Requirements
781      *
782      * - `to` cannot be the zero address.
783      */
784     function _mint(address account, uint256 amount) internal virtual {
785         require(account != address(0), "ERC20: mint to the zero address");
786 
787         _beforeTokenTransfer(address(0), account, amount);
788 
789         _totalSupply = _totalSupply.add(amount);
790         _balances[account] = _balances[account].add(amount);
791         emit Transfer(address(0), account, amount);
792     }
793 
794     /**
795      * @dev Destroys `amount` tokens from `account`, reducing the
796      * total supply.
797      *
798      * Emits a {Transfer} event with `to` set to the zero address.
799      *
800      * Requirements
801      *
802      * - `account` cannot be the zero address.
803      * - `account` must have at least `amount` tokens.
804      */
805     function _burn(address account, uint256 amount) internal virtual {
806         require(account != address(0), "ERC20: burn from the zero address");
807 
808         _beforeTokenTransfer(account, address(0), amount);
809 
810         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
811         _totalSupply = _totalSupply.sub(amount);
812         emit Transfer(account, address(0), amount);
813     }
814 
815     /**
816      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
817      *
818      * This internal function is equivalent to `approve`, and can be used to
819      * e.g. set automatic allowances for certain subsystems, etc.
820      *
821      * Emits an {Approval} event.
822      *
823      * Requirements:
824      *
825      * - `owner` cannot be the zero address.
826      * - `spender` cannot be the zero address.
827      */
828     function _approve(address owner, address spender, uint256 amount) internal virtual {
829         require(owner != address(0), "ERC20: approve from the zero address");
830         require(spender != address(0), "ERC20: approve to the zero address");
831 
832         _allowances[owner][spender] = amount;
833         emit Approval(owner, spender, amount);
834     }
835 
836     /**
837      * @dev Sets {decimals} to a value other than the default one of 18.
838      *
839      * WARNING: This function should only be called from the constructor. Most
840      * applications that interact with token contracts will not expect
841      * {decimals} to ever change, and may work incorrectly if it does.
842      */
843     function _setupDecimals(uint8 decimals_) internal {
844         _decimals = decimals_;
845     }
846 
847     /**
848      * @dev Hook that is called before any transfer of tokens. This includes
849      * minting and burning.
850      *
851      * Calling conditions:
852      *
853      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
854      * will be to transferred to `to`.
855      * - when `from` is zero, `amount` tokens will be minted for `to`.
856      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
857      * - `from` and `to` are never both zero.
858      *
859      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
860      */
861     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
862 }
863 
864 // File: localhost/contracts/SpaceMineToken.sol
865 
866 // SPDX-License-Identifier: MIT
867 
868 pragma solidity 0.6.12;
869 
870 
871 
872 
873 
874 contract SpaceMineCore is ERC20("SpaceMineToken", "MINE"), Ownable {
875     using SafeMath for uint256;
876 
877     address internal _taxer;
878     address internal _taxDestination;
879 	uint256 internal _cap;
880     uint internal _taxRate = 0;
881     bool internal _lock = true;
882     mapping (address => bool) internal _taxWhitelist;
883 
884     function transfer(address recipient, uint256 amount) public override returns (bool) {
885         require(msg.sender == owner() || !_lock, "Transfer is locking");
886 
887         uint256 taxAmount = amount.mul(_taxRate).div(100);
888         if (_taxWhitelist[msg.sender] == true) {
889             taxAmount = 0;
890         }
891         uint256 transferAmount = amount.sub(taxAmount);
892         require(balanceOf(msg.sender) >= amount, "insufficient balance.");
893         super.transfer(recipient, transferAmount);
894 
895         if (taxAmount != 0) {
896             super.transfer(_taxDestination, taxAmount);
897         }
898         return true;
899     }
900 
901     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
902         require(sender == owner() || !_lock, "TransferFrom is locking");
903 
904         uint256 taxAmount = amount.mul(_taxRate).div(100);
905         if (_taxWhitelist[sender] == true) {
906             taxAmount = 0;
907         }
908         uint256 transferAmount = amount.sub(taxAmount);
909         require(balanceOf(sender) >= amount, "insufficient balance.");
910         super.transferFrom(sender, recipient, transferAmount);
911         if (taxAmount != 0) {
912             super.transferFrom(sender, _taxDestination, taxAmount);
913         }
914         return true;
915     }
916 
917 	function _mint(address account, uint256 value) override internal {
918         require(totalSupply().add(value) <= _cap, "cap exceeded");
919         super._mint(account, value);
920     }
921 }
922 
923 contract SpaceMineToken is SpaceMineCore {
924     mapping (address => bool) public minters;
925 
926 	uint256 public constant hard_cap = 96000 * 1e18;
927 
928     constructor() public {
929         _taxer = owner();
930         _taxDestination = owner();
931 		_cap = hard_cap;
932     }
933 
934 	function cap() public view returns (uint256) {
935         return _cap;
936     }
937 
938     function mint(address to, uint amount) public onlyMinter {
939         _mint(to, amount);
940 		_moveDelegates(address(0), _delegates[to], amount);
941     }
942 
943 	/// @notice A record of each accounts delegate
944 	mapping (address => address) public _delegates;
945 	/// @notice A checkpoint for marking number of votes from a given block
946     struct Checkpoint {
947         uint32 fromBlock;
948         uint256 votes;
949     }
950 
951     /// @notice A record of votes checkpoints for each account, by index
952     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
953 
954     /// @notice The number of checkpoints for each account
955     mapping (address => uint32) public numCheckpoints;
956 
957     /// @notice The EIP-712 typehash for the contract's domain
958     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
959 
960     /// @notice The EIP-712 typehash for the delegation struct used by the contract
961     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
962 
963     /// @notice A record of states for signing / validating signatures
964     mapping (address => uint) public nonces;
965 
966       /// @notice An event thats emitted when an account changes its delegate
967     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
968 
969     /// @notice An event thats emitted when a delegate account's vote balance changes
970     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
971 
972     /**
973      * @notice Delegate votes from `msg.sender` to `delegatee`
974      * @param delegator The address to get delegatee for
975      */
976     function delegates(address delegator)
977         external
978         view
979         returns (address)
980     {
981         return _delegates[delegator];
982     }
983 
984    /**
985     * @notice Delegate votes from `msg.sender` to `delegatee`
986     * @param delegatee The address to delegate votes to
987     */
988     function delegate(address delegatee) external {
989         return _delegate(msg.sender, delegatee);
990     }
991 
992     /**
993      * @notice Delegates votes from signatory to `delegatee`
994      * @param delegatee The address to delegate votes to
995      * @param nonce The contract state required to match the signature
996      * @param expiry The time at which to expire the signature
997      * @param v The recovery byte of the signature
998      * @param r Half of the ECDSA signature pair
999      * @param s Half of the ECDSA signature pair
1000      */
1001     function delegateBySig(
1002         address delegatee,
1003         uint nonce,
1004         uint expiry,
1005         uint8 v,
1006         bytes32 r,
1007         bytes32 s
1008     )
1009         external
1010     {
1011         bytes32 domainSeparator = keccak256(
1012             abi.encode(
1013                 DOMAIN_TYPEHASH,
1014                 keccak256(bytes(name())),
1015                 getChainId(),
1016                 address(this)
1017             )
1018         );
1019 
1020         bytes32 structHash = keccak256(
1021             abi.encode(
1022                 DELEGATION_TYPEHASH,
1023                 delegatee,
1024                 nonce,
1025                 expiry
1026             )
1027         );
1028 
1029         bytes32 digest = keccak256(
1030             abi.encodePacked(
1031                 "\x19\x01",
1032                 domainSeparator,
1033                 structHash
1034             )
1035         );
1036 
1037         address signatory = ecrecover(digest, v, r, s);
1038         require(signatory != address(0), "MINE:delegateBySig: invalid signature");
1039         require(nonce == nonces[signatory]++, "MINE::delegateBySig: invalid nonce");
1040         require(block.timestamp <= expiry, "MINE::delegateBySig: signature expired");
1041         return _delegate(signatory, delegatee);
1042     }
1043 
1044     /**
1045      * @notice Gets the current votes balance for `account`
1046      * @param account The address to get votes balance
1047      * @return The number of current votes for `account`
1048      */
1049     function getCurrentVotes(address account)
1050         external
1051         view
1052         returns (uint256)
1053     {
1054         uint32 nCheckpoints = numCheckpoints[account];
1055         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1056     }
1057 
1058     /**
1059      * @notice Determine the prior number of votes for an account as of a block number
1060      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1061      * @param account The address of the account to check
1062      * @param blockNumber The block number to get the vote balance at
1063      * @return The number of votes the account had as of the given block
1064      */
1065     function getPriorVotes(address account, uint blockNumber)
1066         external
1067         view
1068         returns (uint256)
1069     {
1070         require(blockNumber < block.number, "MINE::getPriorVotes: not yet determined");
1071 
1072         uint32 nCheckpoints = numCheckpoints[account];
1073         if (nCheckpoints == 0) {
1074             return 0;
1075         }
1076 
1077         // First check most recent balance
1078         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1079             return checkpoints[account][nCheckpoints - 1].votes;
1080         }
1081 
1082         // Next check implicit zero balance
1083         if (checkpoints[account][0].fromBlock > blockNumber) {
1084             return 0;
1085         }
1086 
1087         uint32 lower = 0;
1088         uint32 upper = nCheckpoints - 1;
1089         while (upper > lower) {
1090             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1091             Checkpoint memory cp = checkpoints[account][center];
1092             if (cp.fromBlock == blockNumber) {
1093                 return cp.votes;
1094             } else if (cp.fromBlock < blockNumber) {
1095                 lower = center;
1096             } else {
1097                 upper = center - 1;
1098             }
1099         }
1100         return checkpoints[account][lower].votes;
1101     }
1102 
1103     function _delegate(address delegator, address delegatee)
1104         internal
1105     {
1106         address currentDelegate = _delegates[delegator];
1107         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying MINE;
1108         _delegates[delegator] = delegatee;
1109 
1110         emit DelegateChanged(delegator, currentDelegate, delegatee);
1111 
1112         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1113     }
1114 
1115     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1116         if (srcRep != dstRep && amount > 0) {
1117             if (srcRep != address(0)) {
1118                 // decrease old representative
1119                 uint32 srcRepNum = numCheckpoints[srcRep];
1120                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1121                 uint256 srcRepNew = srcRepOld-amount;
1122                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1123             }
1124 
1125             if (dstRep != address(0)) {
1126                 // increase new representative
1127                 uint32 dstRepNum = numCheckpoints[dstRep];
1128                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1129                 uint256 dstRepNew = dstRepOld+amount;
1130                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1131             }
1132         }
1133     }
1134 
1135     function _writeCheckpoint(
1136         address delegatee,
1137         uint32 nCheckpoints,
1138         uint256 oldVotes,
1139         uint256 newVotes
1140     )
1141         internal
1142     {
1143         uint32 blockNumber = safe32(block.number, "MINE::_writeCheckpoint: block number exceeds 32 bits");
1144 
1145         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1146             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1147         } else {
1148             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1149             numCheckpoints[delegatee] = nCheckpoints + 1;
1150         }
1151 
1152         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1153     }
1154 
1155     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1156         require(n < 2**32, errorMessage);
1157         return uint32(n);
1158     }
1159 
1160     function getChainId() internal pure returns (uint) {
1161         uint256 chainId;
1162         assembly { chainId := chainid() }
1163         return chainId;
1164     }
1165 
1166     function burn(uint amount) public {
1167         require(amount > 0);
1168         require(balanceOf(msg.sender) >= amount);
1169         _burn(msg.sender, amount);
1170     }
1171 
1172     function addMinter(address account) public onlyOwner {
1173         minters[account] = true;
1174     }
1175 
1176     function removeMinter(address account) public onlyOwner {
1177         minters[account] = false;
1178     }
1179 
1180     modifier onlyMinter() {
1181         require(minters[msg.sender], "Restricted to minters.");
1182         _;
1183     }
1184 
1185     modifier onlyTaxer() {
1186         require(msg.sender == _taxer, "Only for taxer.");
1187         _;
1188     }
1189 
1190     function setTaxer(address account) public onlyTaxer {
1191         _taxer = account;
1192     }
1193 
1194     function setTaxRate(uint256 rate) public onlyTaxer {
1195         _taxRate = rate;
1196     }
1197 
1198     function setTaxDestination(address account) public onlyTaxer {
1199         _taxDestination = account;
1200     }
1201 
1202     function addToWhitelist(address account) public onlyTaxer {
1203         _taxWhitelist[account] = true;
1204     }
1205 
1206     function removeFromWhitelist(address account) public onlyTaxer {
1207         _taxWhitelist[account] = false;
1208     }
1209 
1210     function taxer() public view returns(address) {
1211         return _taxer;
1212     }
1213 
1214     function taxDestination() public view returns(address) {
1215         return _taxDestination;
1216     }
1217 
1218     function taxRate() public view returns(uint256) {
1219         return _taxRate;
1220     }
1221 
1222     function isInWhitelist(address account) public view returns(bool) {
1223         return _taxWhitelist[account];
1224     }
1225 
1226     function unlock() public onlyOwner {
1227         _lock = false;
1228     }
1229 
1230     function getLockStatus() view public returns(bool) {
1231         return _lock;
1232     }
1233 }