1 /*
2 
3 website: pizzafinance.com
4 
5 
6  ███████████  █████ ███████████ ███████████   █████████  
7 ░░███░░░░░███░░███ ░█░░░░░░███ ░█░░░░░░███   ███░░░░░███ 
8  ░███    ░███ ░███ ░     ███░  ░     ███░   ░███    ░███ 
9  ░██████████  ░███      ███         ███     ░███████████ 
10  ░███░░░░░░   ░███     ███         ███      ░███░░░░░███ 
11  ░███         ░███   ████     █  ████     █ ░███    ░███ 
12  █████        █████ ███████████ ███████████ █████   █████
13 ░░░░░        ░░░░░ ░░░░░░░░░░░ ░░░░░░░░░░░ ░░░░░   ░░░░░ 
14                                                          
15                                                          
16 
17 forked from SUSHI and YUNO
18 
19 */
20 
21 pragma solidity ^0.6.12;
22 /*
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with GSN meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address payable) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes memory) {
38         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
39         return msg.data;
40     }
41 }
42 
43 /**
44  * @dev Interface of the ERC20 standard as defined in the EIP.
45  */
46 interface IERC20 {
47     /**
48      * @dev Returns the amount of tokens in existence.
49      */
50     function totalSupply() external view returns (uint256);
51 
52     /**
53      * @dev Returns the amount of tokens owned by `account`.
54      */
55     function balanceOf(address account) external view returns (uint256);
56 
57     /**
58      * @dev Moves `amount` tokens from the caller's account to `recipient`.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transfer(address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Returns the remaining number of tokens that `spender` will be
68      * allowed to spend on behalf of `owner` through {transferFrom}. This is
69      * zero by default.
70      *
71      * This value changes when {approve} or {transferFrom} are called.
72      */
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     /**
76      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * IMPORTANT: Beware that changing an allowance with this method brings the risk
81      * that someone may use both the old and the new allowance by unfortunate
82      * transaction ordering. One possible solution to mitigate this race
83      * condition is to first reduce the spender's allowance to 0 and set the
84      * desired value afterwards:
85      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86      *
87      * Emits an {Approval} event.
88      */
89     function approve(address spender, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Moves `amount` tokens from `sender` to `recipient` using the
93      * allowance mechanism. `amount` is then deducted from the caller's
94      * allowance.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Emitted when `value` tokens are moved from one account (`from`) to
104      * another (`to`).
105      *
106      * Note that `value` may be zero.
107      */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /**
111      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
112      * a call to {approve}. `value` is the new allowance.
113      */
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 /**
118  * @dev Wrappers over Solidity's arithmetic operations with added overflow
119  * checks.
120  *
121  * Arithmetic operations in Solidity wrap on overflow. This can easily result
122  * in bugs, because programmers usually assume that an overflow raises an
123  * error, which is the standard behavior in high level programming languages.
124  * `SafeMath` restores this intuition by reverting the transaction when an
125  * operation overflows.
126  *
127  * Using this library instead of the unchecked operations eliminates an entire
128  * class of bugs, so it's recommended to use it always.
129  */
130 library SafeMath {
131     /**
132      * @dev Returns the addition of two unsigned integers, reverting on
133      * overflow.
134      *
135      * Counterpart to Solidity's `+` operator.
136      *
137      * Requirements:
138      *
139      * - Addition cannot overflow.
140      */
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a + b;
143         require(c >= a, "SafeMath: addition overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159         return sub(a, b, "SafeMath: subtraction overflow");
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
164      * overflow (when the result is negative).
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         uint256 c = a - b;
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      *
187      * - Multiplication cannot overflow.
188      */
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
191         // benefit is lost if 'b' is also tested.
192         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
193         if (a == 0) {
194             return 0;
195         }
196 
197         uint256 c = a * b;
198         require(c / a == b, "SafeMath: multiplication overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         return div(a, b, "SafeMath: division by zero");
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator. Note: this function uses a
224      * `revert` opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b > 0, errorMessage);
233         uint256 c = a / b;
234         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252         return mod(a, b, "SafeMath: modulo by zero");
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * Reverts with custom message when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         require(b != 0, errorMessage);
269         return a % b;
270     }
271 }
272 
273 
274 /**
275  * @dev Collection of functions related to the address type
276  */
277 library Address {
278     /**
279      * @dev Returns true if `account` is a contract.
280      *
281      * [IMPORTANT]
282      * ====
283      * It is unsafe to assume that an address for which this function returns
284      * false is an externally-owned account (EOA) and not a contract.
285      *
286      * Among others, `isContract` will return false for the following
287      * types of addresses:
288      *
289      *  - an externally-owned account
290      *  - a contract in construction
291      *  - an address where a contract will be created
292      *  - an address where a contract lived, but was destroyed
293      * ====
294      */
295     function isContract(address account) internal view returns (bool) {
296         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
297         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
298         // for accounts without code, i.e. `keccak256('')`
299         bytes32 codehash;
300         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
301         // solhint-disable-next-line no-inline-assembly
302         assembly { codehash := extcodehash(account) }
303         return (codehash != accountHash && codehash != 0x0);
304     }
305 
306     /**
307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
308      * `recipient`, forwarding all available gas and reverting on errors.
309      *
310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
312      * imposed by `transfer`, making them unable to receive funds via
313      * `transfer`. {sendValue} removes this limitation.
314      *
315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
316      *
317      * IMPORTANT: because control is transferred to `recipient`, care must be
318      * taken to not create reentrancy vulnerabilities. Consider using
319      * {ReentrancyGuard} or the
320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, "Address: insufficient balance");
324 
325         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
326         (bool success, ) = recipient.call{ value: amount }("");
327         require(success, "Address: unable to send value, recipient may have reverted");
328     }
329 
330     /**
331      * @dev Performs a Solidity function call using a low level `call`. A
332      * plain`call` is an unsafe replacement for a function call: use this
333      * function instead.
334      *
335      * If `target` reverts with a revert reason, it is bubbled up by this
336      * function (like regular Solidity function calls).
337      *
338      * Returns the raw returned data. To convert to the expected return value,
339      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
340      *
341      * Requirements:
342      *
343      * - `target` must be a contract.
344      * - calling `target` with `data` must not revert.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
349       return functionCall(target, data, "Address: low-level call failed");
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
354      * `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
359         return _functionCallWithValue(target, data, 0, errorMessage);
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
364      * but also transferring `value` wei to `target`.
365      *
366      * Requirements:
367      *
368      * - the calling contract must have an ETH balance of at least `value`.
369      * - the called Solidity function must be `payable`.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
374         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
379      * with `errorMessage` as a fallback revert reason when `target` reverts.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
384         require(address(this).balance >= value, "Address: insufficient balance for call");
385         return _functionCallWithValue(target, data, value, errorMessage);
386     }
387 
388     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
389         require(isContract(target), "Address: call to non-contract");
390 
391         // solhint-disable-next-line avoid-low-level-calls
392         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
393         if (success) {
394             return returndata;
395         } else {
396             // Look for revert reason and bubble it up if present
397             if (returndata.length > 0) {
398                 // The easiest way to bubble the revert reason is using memory via assembly
399 
400                 // solhint-disable-next-line no-inline-assembly
401                 assembly {
402                     let returndata_size := mload(returndata)
403                     revert(add(32, returndata), returndata_size)
404                 }
405             } else {
406                 revert(errorMessage);
407             }
408         }
409     }
410 }
411 
412 /**
413  * @title SafeERC20
414  * @dev Wrappers around ERC20 operations that throw on failure (when the token
415  * contract returns false). Tokens that return no value (and instead revert or
416  * throw on failure) are also supported, non-reverting calls are assumed to be
417  * successful.
418  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
419  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
420  */
421 library SafeERC20 {
422     using SafeMath for uint256;
423     using Address for address;
424 
425     function safeTransfer(IERC20 token, address to, uint256 value) internal {
426         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
427     }
428 
429     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
430         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
431     }
432 
433     /**
434      * @dev Deprecated. This function has issues similar to the ones found in
435      * {IERC20-approve}, and its usage is discouraged.
436      *
437      * Whenever possible, use {safeIncreaseAllowance} and
438      * {safeDecreaseAllowance} instead.
439      */
440     function safeApprove(IERC20 token, address spender, uint256 value) internal {
441         // safeApprove should only be called when setting an initial allowance,
442         // or when resetting it to zero. To increase and decrease it, use
443         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
444         // solhint-disable-next-line max-line-length
445         require((value == 0) || (token.allowance(address(this), spender) == 0),
446             "SafeERC20: approve from non-zero to non-zero allowance"
447         );
448         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
449     }
450 
451     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
452         uint256 newAllowance = token.allowance(address(this), spender).add(value);
453         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
454     }
455 
456     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
457         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
458         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
459     }
460 
461     /**
462      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
463      * on the return value: the return value is optional (but if data is returned, it must not be false).
464      * @param token The token targeted by the call.
465      * @param data The call data (encoded using abi.encode or one of its variants).
466      */
467     function _callOptionalReturn(IERC20 token, bytes memory data) private {
468         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
469         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
470         // the target address contains contract code and also asserts for success in the low-level call.
471 
472         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
473         if (returndata.length > 0) { // Return data is optional
474             // solhint-disable-next-line max-line-length
475             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
476         }
477     }
478 }
479 
480 
481 
482 /**
483  * @dev Contract module which provides a basic access control mechanism, where
484  * there is an account (an owner) that can be granted exclusive access to
485  * specific functions.
486  *
487  * By default, the owner account will be the one that deploys the contract. This
488  * can later be changed with {transferOwnership}.
489  *
490  * This module is used through inheritance. It will make available the modifier
491  * `onlyOwner`, which can be applied to your functions to restrict their use to
492  * the owner.
493  */
494 contract Ownable is Context {
495     address private _owner;
496 
497     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
498 
499     /**
500      * @dev Initializes the contract setting the deployer as the initial owner.
501      */
502     constructor () internal {
503         address msgSender = _msgSender();
504         _owner = msgSender;
505         emit OwnershipTransferred(address(0), msgSender);
506     }
507 
508     /**
509      * @dev Returns the address of the current owner.
510      */
511     function owner() public view returns (address) {
512         return _owner;
513     }
514 
515     /**
516      * @dev Throws if called by any account other than the owner.
517      */
518     modifier onlyOwner() {
519         require(_owner == _msgSender(), "Ownable: caller is not the owner");
520         _;
521     }
522 
523     /**
524      * @dev Leaves the contract without owner. It will not be possible to call
525      * `onlyOwner` functions anymore. Can only be called by the current owner.
526      *
527      * NOTE: Renouncing ownership will leave the contract without an owner,
528      * thereby removing any functionality that is only available to the owner.
529      */
530     function renounceOwnership() public virtual onlyOwner {
531         emit OwnershipTransferred(_owner, address(0));
532         _owner = address(0);
533     }
534 
535     /**
536      * @dev Transfers ownership of the contract to a new account (`newOwner`).
537      * Can only be called by the current owner.
538      */
539     function transferOwnership(address newOwner) public virtual onlyOwner {
540         require(newOwner != address(0), "Ownable: new owner is the zero address");
541         emit OwnershipTransferred(_owner, newOwner);
542         _owner = newOwner;
543     }
544 }
545 
546 
547 /**
548  * @dev Implementation of the {IERC20} interface.
549  *
550  * This implementation is agnostic to the way tokens are created. This means
551  * that a supply mechanism has to be added in a derived contract using {_mint}.
552  * For a generic mechanism see {ERC20PresetMinterPauser}.
553  *
554  * TIP: For a detailed writeup see our guide
555  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
556  * to implement supply mechanisms].
557  *
558  * We have followed general OpenZeppelin guidelines: functions revert instead
559  * of returning `false` on failure. This behavior is nonetheless conventional
560  * and does not conflict with the expectations of ERC20 applications.
561  *
562  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
563  * This allows applications to reconstruct the allowance for all accounts just
564  * by listening to said events. Other implementations of the EIP may not emit
565  * these events, as it isn't required by the specification.
566  *
567  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
568  * functions have been added to mitigate the well-known issues around setting
569  * allowances. See {IERC20-approve}.
570  */
571 contract ERC20 is Context, IERC20 {
572     using SafeMath for uint256;
573     using Address for address;
574 
575     mapping (address => uint256) private _balances;
576 
577     mapping (address => mapping (address => uint256)) private _allowances;
578 
579     uint256 private _totalSupply;
580 
581     string private _name;
582     string private _symbol;
583     uint8 private _decimals;
584 
585     /**
586      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
587      * a default value of 18.
588      *
589      * To select a different value for {decimals}, use {_setupDecimals}.
590      *
591      * All three of these values are immutable: they can only be set once during
592      * construction.
593      */
594     constructor (string memory name, string memory symbol) public {
595         _name = name;
596         _symbol = symbol;
597         _decimals = 18;
598     }
599 
600     /**
601      * @dev Returns the name of the token.
602      */
603     function name() public view returns (string memory) {
604         return _name;
605     }
606 
607     /**
608      * @dev Returns the symbol of the token, usually a shorter version of the
609      * name.
610      */
611     function symbol() public view returns (string memory) {
612         return _symbol;
613     }
614 
615     /**
616      * @dev Returns the number of decimals used to get its user representation.
617      * For example, if `decimals` equals `2`, a balance of `505` tokens should
618      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
619      *
620      * Tokens usually opt for a value of 18, imitating the relationship between
621      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
622      * called.
623      *
624      * NOTE: This information is only used for _display_ purposes: it in
625      * no way affects any of the arithmetic of the contract, including
626      * {IERC20-balanceOf} and {IERC20-transfer}.
627      */
628     function decimals() public view returns (uint8) {
629         return _decimals;
630     }
631 
632     /**
633      * @dev See {IERC20-totalSupply}.
634      */
635     function totalSupply() public view override returns (uint256) {
636         return _totalSupply;
637     }
638 
639     /**
640      * @dev See {IERC20-balanceOf}.
641      */
642     function balanceOf(address account) public view override returns (uint256) {
643         return _balances[account];
644     }
645 
646     /**
647      * @dev See {IERC20-transfer}.
648      *
649      * Requirements:
650      *
651      * - `recipient` cannot be the zero address.
652      * - the caller must have a balance of at least `amount`.
653      */
654     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
655         _transfer(_msgSender(), recipient, amount);
656         return true;
657     }
658 
659     /**
660      * @dev See {IERC20-allowance}.
661      */
662     function allowance(address owner, address spender) public view virtual override returns (uint256) {
663         return _allowances[owner][spender];
664     }
665 
666     /**
667      * @dev See {IERC20-approve}.
668      *
669      * Requirements:
670      *
671      * - `spender` cannot be the zero address.
672      */
673     function approve(address spender, uint256 amount) public virtual override returns (bool) {
674         _approve(_msgSender(), spender, amount);
675         return true;
676     }
677 
678     /**
679      * @dev See {IERC20-transferFrom}.
680      *
681      * Emits an {Approval} event indicating the updated allowance. This is not
682      * required by the EIP. See the note at the beginning of {ERC20};
683      *
684      * Requirements:
685      * - `sender` and `recipient` cannot be the zero address.
686      * - `sender` must have a balance of at least `amount`.
687      * - the caller must have allowance for ``sender``'s tokens of at least
688      * `amount`.
689      */
690     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
691         _transfer(sender, recipient, amount);
692         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
693         return true;
694     }
695 
696     /**
697      * @dev Atomically increases the allowance granted to `spender` by the caller.
698      *
699      * This is an alternative to {approve} that can be used as a mitigation for
700      * problems described in {IERC20-approve}.
701      *
702      * Emits an {Approval} event indicating the updated allowance.
703      *
704      * Requirements:
705      *
706      * - `spender` cannot be the zero address.
707      */
708     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
709         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
710         return true;
711     }
712 
713     /**
714      * @dev Atomically decreases the allowance granted to `spender` by the caller.
715      *
716      * This is an alternative to {approve} that can be used as a mitigation for
717      * problems described in {IERC20-approve}.
718      *
719      * Emits an {Approval} event indicating the updated allowance.
720      *
721      * Requirements:
722      *
723      * - `spender` cannot be the zero address.
724      * - `spender` must have allowance for the caller of at least
725      * `subtractedValue`.
726      */
727     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
728         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
729         return true;
730     }
731 
732     /**
733      * @dev Moves tokens `amount` from `sender` to `recipient`.
734      *
735      * This is internal function is equivalent to {transfer}, and can be used to
736      * e.g. implement automatic token fees, slashing mechanisms, etc.
737      *
738      * Emits a {Transfer} event.
739      *
740      * Requirements:
741      *
742      * - `sender` cannot be the zero address.
743      * - `recipient` cannot be the zero address.
744      * - `sender` must have a balance of at least `amount`.
745      */
746     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
747         require(sender != address(0), "ERC20: transfer from the zero address");
748         require(recipient != address(0), "ERC20: transfer to the zero address");
749 
750         _beforeTokenTransfer(sender, recipient, amount);
751 
752         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
753         _balances[recipient] = _balances[recipient].add(amount);
754         emit Transfer(sender, recipient, amount);
755     }
756 
757     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
758      * the total supply.
759      *
760      * Emits a {Transfer} event with `from` set to the zero address.
761      *
762      * Requirements
763      *
764      * - `to` cannot be the zero address.
765      */
766     function _mint(address account, uint256 amount) internal virtual {
767         require(account != address(0), "ERC20: mint to the zero address");
768 
769         _beforeTokenTransfer(address(0), account, amount);
770 
771         _totalSupply = _totalSupply.add(amount);
772         _balances[account] = _balances[account].add(amount);
773         emit Transfer(address(0), account, amount);
774     }
775 
776     /**
777      * @dev Destroys `amount` tokens from `account`, reducing the
778      * total supply.
779      *
780      * Emits a {Transfer} event with `to` set to the zero address.
781      *
782      * Requirements
783      *
784      * - `account` cannot be the zero address.
785      * - `account` must have at least `amount` tokens.
786      */
787     function _burn(address account, uint256 amount) internal virtual {
788         require(account != address(0), "ERC20: burn from the zero address");
789 
790         _beforeTokenTransfer(account, address(0), amount);
791 
792         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
793         _totalSupply = _totalSupply.sub(amount);
794         emit Transfer(account, address(0), amount);
795     }
796 
797     /**
798      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
799      *
800      * This is internal function is equivalent to `approve`, and can be used to
801      * e.g. set automatic allowances for certain subsystems, etc.
802      *
803      * Emits an {Approval} event.
804      *
805      * Requirements:
806      *
807      * - `owner` cannot be the zero address.
808      * - `spender` cannot be the zero address.
809      */
810     function _approve(address owner, address spender, uint256 amount) internal virtual {
811         require(owner != address(0), "ERC20: approve from the zero address");
812         require(spender != address(0), "ERC20: approve to the zero address");
813 
814         _allowances[owner][spender] = amount;
815         emit Approval(owner, spender, amount);
816     }
817 
818     /**
819      * @dev Sets {decimals} to a value other than the default one of 18.
820      *
821      * WARNING: This function should only be called from the constructor. Most
822      * applications that interact with token contracts will not expect
823      * {decimals} to ever change, and may work incorrectly if it does.
824      */
825     function _setupDecimals(uint8 decimals_) internal {
826         _decimals = decimals_;
827     }
828 
829     /**
830      * @dev Hook that is called before any transfer of tokens. This includes
831      * minting and burning.
832      *
833      * Calling conditions:
834      *
835      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
836      * will be to transferred to `to`.
837      * - when `from` is zero, `amount` tokens will be minted for `to`.
838      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
839      * - `from` and `to` are never both zero.
840      *
841      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
842      */
843     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
844 }
845 
846 // PizzaToken with Governance.
847 contract PizzaToken is ERC20("pizzafinance.com", "PIZZA"), Ownable {
848     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
849     function mint(address _to, uint256 _amount) public onlyOwner {
850         _mint(_to, _amount);
851     }
852 }