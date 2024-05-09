1 /* 
2 
3 website: pizzafinance.com
4 
5 This project was forked from SUSHI and YUNO projects.
6 
7 Unless those projects have severe vulnerabilities, this contract will be fine
8 
9 
10  ███████████  █████ ███████████ ███████████   █████████  
11 ░░███░░░░░███░░███ ░█░░░░░░███ ░█░░░░░░███   ███░░░░░███ 
12  ░███    ░███ ░███ ░     ███░  ░     ███░   ░███    ░███ 
13  ░██████████  ░███      ███         ███     ░███████████ 
14  ░███░░░░░░   ░███     ███         ███      ░███░░░░░███ 
15  ░███         ░███   ████     █  ████     █ ░███    ░███ 
16  █████        █████ ███████████ ███████████ █████   █████
17 ░░░░░        ░░░░░ ░░░░░░░░░░░ ░░░░░░░░░░░ ░░░░░   ░░░░░ 
18                                                          
19                                                          
20 
21 */
22 
23 pragma solidity ^0.6.12;
24 /*
25  * @dev Provides information about the current execution context, including the
26  * sender of the transaction and its data. While these are generally available
27  * via msg.sender and msg.data, they should not be accessed in such a direct
28  * manner, since when dealing with GSN meta-transactions the account sending and
29  * paying for execution may not be the actual sender (as far as an application
30  * is concerned).
31  *
32  * This contract is only required for intermediate, library-like contracts.
33  */
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address payable) {
36         return msg.sender;
37     }
38 
39     function _msgData() internal view virtual returns (bytes memory) {
40         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
41         return msg.data;
42     }
43 }
44 
45 /**
46  * @dev Interface of the ERC20 standard as defined in the EIP.
47  */
48 interface IERC20 {
49     /**
50      * @dev Returns the amount of tokens in existence.
51      */
52     function totalSupply() external view returns (uint256);
53 
54     /**
55      * @dev Returns the amount of tokens owned by `account`.
56      */
57     function balanceOf(address account) external view returns (uint256);
58 
59     /**
60      * @dev Moves `amount` tokens from the caller's account to `recipient`.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transfer(address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Returns the remaining number of tokens that `spender` will be
70      * allowed to spend on behalf of `owner` through {transferFrom}. This is
71      * zero by default.
72      *
73      * This value changes when {approve} or {transferFrom} are called.
74      */
75     function allowance(address owner, address spender) external view returns (uint256);
76 
77     /**
78      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
79      *
80      * Returns a boolean value indicating whether the operation succeeded.
81      *
82      * IMPORTANT: Beware that changing an allowance with this method brings the risk
83      * that someone may use both the old and the new allowance by unfortunate
84      * transaction ordering. One possible solution to mitigate this race
85      * condition is to first reduce the spender's allowance to 0 and set the
86      * desired value afterwards:
87      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
88      *
89      * Emits an {Approval} event.
90      */
91     function approve(address spender, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Moves `amount` tokens from `sender` to `recipient` using the
95      * allowance mechanism. `amount` is then deducted from the caller's
96      * allowance.
97      *
98      * Returns a boolean value indicating whether the operation succeeded.
99      *
100      * Emits a {Transfer} event.
101      */
102     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
103 
104     /**
105      * @dev Emitted when `value` tokens are moved from one account (`from`) to
106      * another (`to`).
107      *
108      * Note that `value` may be zero.
109      */
110     event Transfer(address indexed from, address indexed to, uint256 value);
111 
112     /**
113      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
114      * a call to {approve}. `value` is the new allowance.
115      */
116     event Approval(address indexed owner, address indexed spender, uint256 value);
117 }
118 
119 /**
120  * @dev Wrappers over Solidity's arithmetic operations with added overflow
121  * checks.
122  *
123  * Arithmetic operations in Solidity wrap on overflow. This can easily result
124  * in bugs, because programmers usually assume that an overflow raises an
125  * error, which is the standard behavior in high level programming languages.
126  * `SafeMath` restores this intuition by reverting the transaction when an
127  * operation overflows.
128  *
129  * Using this library instead of the unchecked operations eliminates an entire
130  * class of bugs, so it's recommended to use it always.
131  */
132 library SafeMath {
133     /**
134      * @dev Returns the addition of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `+` operator.
138      *
139      * Requirements:
140      *
141      * - Addition cannot overflow.
142      */
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         require(c >= a, "SafeMath: addition overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161         return sub(a, b, "SafeMath: subtraction overflow");
162     }
163 
164     /**
165      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
166      * overflow (when the result is negative).
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b <= a, errorMessage);
176         uint256 c = a - b;
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the multiplication of two unsigned integers, reverting on
183      * overflow.
184      *
185      * Counterpart to Solidity's `*` operator.
186      *
187      * Requirements:
188      *
189      * - Multiplication cannot overflow.
190      */
191     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
193         // benefit is lost if 'b' is also tested.
194         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
195         if (a == 0) {
196             return 0;
197         }
198 
199         uint256 c = a * b;
200         require(c / a == b, "SafeMath: multiplication overflow");
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the integer division of two unsigned integers. Reverts on
207      * division by zero. The result is rounded towards zero.
208      *
209      * Counterpart to Solidity's `/` operator. Note: this function uses a
210      * `revert` opcode (which leaves remaining gas untouched) while Solidity
211      * uses an invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function div(uint256 a, uint256 b) internal pure returns (uint256) {
218         return div(a, b, "SafeMath: division by zero");
219     }
220 
221     /**
222      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
223      * division by zero. The result is rounded towards zero.
224      *
225      * Counterpart to Solidity's `/` operator. Note: this function uses a
226      * `revert` opcode (which leaves remaining gas untouched) while Solidity
227      * uses an invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b > 0, errorMessage);
235         uint256 c = a / b;
236         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
243      * Reverts when dividing by zero.
244      *
245      * Counterpart to Solidity's `%` operator. This function uses a `revert`
246      * opcode (which leaves remaining gas untouched) while Solidity uses an
247      * invalid opcode to revert (consuming all remaining gas).
248      *
249      * Requirements:
250      *
251      * - The divisor cannot be zero.
252      */
253     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
254         return mod(a, b, "SafeMath: modulo by zero");
255     }
256 
257     /**
258      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259      * Reverts with custom message when dividing by zero.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
270         require(b != 0, errorMessage);
271         return a % b;
272     }
273 }
274 
275 
276 /**
277  * @dev Collection of functions related to the address type
278  */
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, `isContract` will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      */
297     function isContract(address account) internal view returns (bool) {
298         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
299         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
300         // for accounts without code, i.e. `keccak256('')`
301         bytes32 codehash;
302         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
303         // solhint-disable-next-line no-inline-assembly
304         assembly { codehash := extcodehash(account) }
305         return (codehash != accountHash && codehash != 0x0);
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(address(this).balance >= amount, "Address: insufficient balance");
326 
327         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
328         (bool success, ) = recipient.call{ value: amount }("");
329         require(success, "Address: unable to send value, recipient may have reverted");
330     }
331 
332     /**
333      * @dev Performs a Solidity function call using a low level `call`. A
334      * plain`call` is an unsafe replacement for a function call: use this
335      * function instead.
336      *
337      * If `target` reverts with a revert reason, it is bubbled up by this
338      * function (like regular Solidity function calls).
339      *
340      * Returns the raw returned data. To convert to the expected return value,
341      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
342      *
343      * Requirements:
344      *
345      * - `target` must be a contract.
346      * - calling `target` with `data` must not revert.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
351       return functionCall(target, data, "Address: low-level call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
356      * `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
361         return _functionCallWithValue(target, data, 0, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but also transferring `value` wei to `target`.
367      *
368      * Requirements:
369      *
370      * - the calling contract must have an ETH balance of at least `value`.
371      * - the called Solidity function must be `payable`.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
376         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
381      * with `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
386         require(address(this).balance >= value, "Address: insufficient balance for call");
387         return _functionCallWithValue(target, data, value, errorMessage);
388     }
389 
390     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
391         require(isContract(target), "Address: call to non-contract");
392 
393         // solhint-disable-next-line avoid-low-level-calls
394         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
395         if (success) {
396             return returndata;
397         } else {
398             // Look for revert reason and bubble it up if present
399             if (returndata.length > 0) {
400                 // The easiest way to bubble the revert reason is using memory via assembly
401 
402                 // solhint-disable-next-line no-inline-assembly
403                 assembly {
404                     let returndata_size := mload(returndata)
405                     revert(add(32, returndata), returndata_size)
406                 }
407             } else {
408                 revert(errorMessage);
409             }
410         }
411     }
412 }
413 
414 /**
415  * @title SafeERC20
416  * @dev Wrappers around ERC20 operations that throw on failure (when the token
417  * contract returns false). Tokens that return no value (and instead revert or
418  * throw on failure) are also supported, non-reverting calls are assumed to be
419  * successful.
420  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
421  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
422  */
423 library SafeERC20 {
424     using SafeMath for uint256;
425     using Address for address;
426 
427     function safeTransfer(IERC20 token, address to, uint256 value) internal {
428         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
429     }
430 
431     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
432         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
433     }
434 
435     /**
436      * @dev Deprecated. This function has issues similar to the ones found in
437      * {IERC20-approve}, and its usage is discouraged.
438      *
439      * Whenever possible, use {safeIncreaseAllowance} and
440      * {safeDecreaseAllowance} instead.
441      */
442     function safeApprove(IERC20 token, address spender, uint256 value) internal {
443         // safeApprove should only be called when setting an initial allowance,
444         // or when resetting it to zero. To increase and decrease it, use
445         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
446         // solhint-disable-next-line max-line-length
447         require((value == 0) || (token.allowance(address(this), spender) == 0),
448             "SafeERC20: approve from non-zero to non-zero allowance"
449         );
450         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
451     }
452 
453     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
454         uint256 newAllowance = token.allowance(address(this), spender).add(value);
455         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
456     }
457 
458     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
459         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
460         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
461     }
462 
463     /**
464      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
465      * on the return value: the return value is optional (but if data is returned, it must not be false).
466      * @param token The token targeted by the call.
467      * @param data The call data (encoded using abi.encode or one of its variants).
468      */
469     function _callOptionalReturn(IERC20 token, bytes memory data) private {
470         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
471         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
472         // the target address contains contract code and also asserts for success in the low-level call.
473 
474         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
475         if (returndata.length > 0) { // Return data is optional
476             // solhint-disable-next-line max-line-length
477             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
478         }
479     }
480 }
481 
482 
483 
484 /**
485  * @dev Contract module which provides a basic access control mechanism, where
486  * there is an account (an owner) that can be granted exclusive access to
487  * specific functions.
488  *
489  * By default, the owner account will be the one that deploys the contract. This
490  * can later be changed with {transferOwnership}.
491  *
492  * This module is used through inheritance. It will make available the modifier
493  * `onlyOwner`, which can be applied to your functions to restrict their use to
494  * the owner.
495  */
496 contract Ownable is Context {
497     address private _owner;
498 
499     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
500 
501     /**
502      * @dev Initializes the contract setting the deployer as the initial owner.
503      */
504     constructor () internal {
505         address msgSender = _msgSender();
506         _owner = msgSender;
507         emit OwnershipTransferred(address(0), msgSender);
508     }
509 
510     /**
511      * @dev Returns the address of the current owner.
512      */
513     function owner() public view returns (address) {
514         return _owner;
515     }
516 
517     /**
518      * @dev Throws if called by any account other than the owner.
519      */
520     modifier onlyOwner() {
521         require(_owner == _msgSender(), "Ownable: caller is not the owner");
522         _;
523     }
524 
525     /**
526      * @dev Leaves the contract without owner. It will not be possible to call
527      * `onlyOwner` functions anymore. Can only be called by the current owner.
528      *
529      * NOTE: Renouncing ownership will leave the contract without an owner,
530      * thereby removing any functionality that is only available to the owner.
531      */
532     function renounceOwnership() public virtual onlyOwner {
533         emit OwnershipTransferred(_owner, address(0));
534         _owner = address(0);
535     }
536 
537     /**
538      * @dev Transfers ownership of the contract to a new account (`newOwner`).
539      * Can only be called by the current owner.
540      */
541     function transferOwnership(address newOwner) public virtual onlyOwner {
542         require(newOwner != address(0), "Ownable: new owner is the zero address");
543         emit OwnershipTransferred(_owner, newOwner);
544         _owner = newOwner;
545     }
546 }
547 
548 
549 /**
550  * @dev Implementation of the {IERC20} interface.
551  *
552  * This implementation is agnostic to the way tokens are created. This means
553  * that a supply mechanism has to be added in a derived contract using {_mint}.
554  * For a generic mechanism see {ERC20PresetMinterPauser}.
555  *
556  * TIP: For a detailed writeup see our guide
557  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
558  * to implement supply mechanisms].
559  *
560  * We have followed general OpenZeppelin guidelines: functions revert instead
561  * of returning `false` on failure. This behavior is nonetheless conventional
562  * and does not conflict with the expectations of ERC20 applications.
563  *
564  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
565  * This allows applications to reconstruct the allowance for all accounts just
566  * by listening to said events. Other implementations of the EIP may not emit
567  * these events, as it isn't required by the specification.
568  *
569  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
570  * functions have been added to mitigate the well-known issues around setting
571  * allowances. See {IERC20-approve}.
572  */
573 contract ERC20 is Context, IERC20 {
574     using SafeMath for uint256;
575     using Address for address;
576 
577     mapping (address => uint256) private _balances;
578 
579     mapping (address => mapping (address => uint256)) private _allowances;
580 
581     uint256 private _totalSupply;
582 
583     string private _name;
584     string private _symbol;
585     uint8 private _decimals;
586 
587     /**
588      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
589      * a default value of 18.
590      *
591      * To select a different value for {decimals}, use {_setupDecimals}.
592      *
593      * All three of these values are immutable: they can only be set once during
594      * construction.
595      */
596     constructor (string memory name, string memory symbol) public {
597         _name = name;
598         _symbol = symbol;
599         _decimals = 18;
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
623      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
624      * called.
625      *
626      * NOTE: This information is only used for _display_ purposes: it in
627      * no way affects any of the arithmetic of the contract, including
628      * {IERC20-balanceOf} and {IERC20-transfer}.
629      */
630     function decimals() public view returns (uint8) {
631         return _decimals;
632     }
633 
634     /**
635      * @dev See {IERC20-totalSupply}.
636      */
637     function totalSupply() public view override returns (uint256) {
638         return _totalSupply;
639     }
640 
641     /**
642      * @dev See {IERC20-balanceOf}.
643      */
644     function balanceOf(address account) public view override returns (uint256) {
645         return _balances[account];
646     }
647 
648     /**
649      * @dev See {IERC20-transfer}.
650      *
651      * Requirements:
652      *
653      * - `recipient` cannot be the zero address.
654      * - the caller must have a balance of at least `amount`.
655      */
656     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
657         _transfer(_msgSender(), recipient, amount);
658         return true;
659     }
660 
661     /**
662      * @dev See {IERC20-allowance}.
663      */
664     function allowance(address owner, address spender) public view virtual override returns (uint256) {
665         return _allowances[owner][spender];
666     }
667 
668     /**
669      * @dev See {IERC20-approve}.
670      *
671      * Requirements:
672      *
673      * - `spender` cannot be the zero address.
674      */
675     function approve(address spender, uint256 amount) public virtual override returns (bool) {
676         _approve(_msgSender(), spender, amount);
677         return true;
678     }
679 
680     /**
681      * @dev See {IERC20-transferFrom}.
682      *
683      * Emits an {Approval} event indicating the updated allowance. This is not
684      * required by the EIP. See the note at the beginning of {ERC20};
685      *
686      * Requirements:
687      * - `sender` and `recipient` cannot be the zero address.
688      * - `sender` must have a balance of at least `amount`.
689      * - the caller must have allowance for ``sender``'s tokens of at least
690      * `amount`.
691      */
692     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
693         _transfer(sender, recipient, amount);
694         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
695         return true;
696     }
697 
698     /**
699      * @dev Atomically increases the allowance granted to `spender` by the caller.
700      *
701      * This is an alternative to {approve} that can be used as a mitigation for
702      * problems described in {IERC20-approve}.
703      *
704      * Emits an {Approval} event indicating the updated allowance.
705      *
706      * Requirements:
707      *
708      * - `spender` cannot be the zero address.
709      */
710     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
711         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
712         return true;
713     }
714 
715     /**
716      * @dev Atomically decreases the allowance granted to `spender` by the caller.
717      *
718      * This is an alternative to {approve} that can be used as a mitigation for
719      * problems described in {IERC20-approve}.
720      *
721      * Emits an {Approval} event indicating the updated allowance.
722      *
723      * Requirements:
724      *
725      * - `spender` cannot be the zero address.
726      * - `spender` must have allowance for the caller of at least
727      * `subtractedValue`.
728      */
729     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
730         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
731         return true;
732     }
733 
734     /**
735      * @dev Moves tokens `amount` from `sender` to `recipient`.
736      *
737      * This is internal function is equivalent to {transfer}, and can be used to
738      * e.g. implement automatic token fees, slashing mechanisms, etc.
739      *
740      * Emits a {Transfer} event.
741      *
742      * Requirements:
743      *
744      * - `sender` cannot be the zero address.
745      * - `recipient` cannot be the zero address.
746      * - `sender` must have a balance of at least `amount`.
747      */
748     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
749         require(sender != address(0), "ERC20: transfer from the zero address");
750         require(recipient != address(0), "ERC20: transfer to the zero address");
751 
752         _beforeTokenTransfer(sender, recipient, amount);
753 
754         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
755         _balances[recipient] = _balances[recipient].add(amount);
756         emit Transfer(sender, recipient, amount);
757     }
758 
759     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
760      * the total supply.
761      *
762      * Emits a {Transfer} event with `from` set to the zero address.
763      *
764      * Requirements
765      *
766      * - `to` cannot be the zero address.
767      */
768     function _mint(address account, uint256 amount) internal virtual {
769         require(account != address(0), "ERC20: mint to the zero address");
770 
771         _beforeTokenTransfer(address(0), account, amount);
772 
773         _totalSupply = _totalSupply.add(amount);
774         _balances[account] = _balances[account].add(amount);
775         emit Transfer(address(0), account, amount);
776     }
777 
778     /**
779      * @dev Destroys `amount` tokens from `account`, reducing the
780      * total supply.
781      *
782      * Emits a {Transfer} event with `to` set to the zero address.
783      *
784      * Requirements
785      *
786      * - `account` cannot be the zero address.
787      * - `account` must have at least `amount` tokens.
788      */
789     function _burn(address account, uint256 amount) internal virtual {
790         require(account != address(0), "ERC20: burn from the zero address");
791 
792         _beforeTokenTransfer(account, address(0), amount);
793 
794         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
795         _totalSupply = _totalSupply.sub(amount);
796         emit Transfer(account, address(0), amount);
797     }
798 
799     /**
800      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
801      *
802      * This is internal function is equivalent to `approve`, and can be used to
803      * e.g. set automatic allowances for certain subsystems, etc.
804      *
805      * Emits an {Approval} event.
806      *
807      * Requirements:
808      *
809      * - `owner` cannot be the zero address.
810      * - `spender` cannot be the zero address.
811      */
812     function _approve(address owner, address spender, uint256 amount) internal virtual {
813         require(owner != address(0), "ERC20: approve from the zero address");
814         require(spender != address(0), "ERC20: approve to the zero address");
815 
816         _allowances[owner][spender] = amount;
817         emit Approval(owner, spender, amount);
818     }
819 
820     /**
821      * @dev Sets {decimals} to a value other than the default one of 18.
822      *
823      * WARNING: This function should only be called from the constructor. Most
824      * applications that interact with token contracts will not expect
825      * {decimals} to ever change, and may work incorrectly if it does.
826      */
827     function _setupDecimals(uint8 decimals_) internal {
828         _decimals = decimals_;
829     }
830 
831     /**
832      * @dev Hook that is called before any transfer of tokens. This includes
833      * minting and burning.
834      *
835      * Calling conditions:
836      *
837      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
838      * will be to transferred to `to`.
839      * - when `from` is zero, `amount` tokens will be minted for `to`.
840      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
841      * - `from` and `to` are never both zero.
842      *
843      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
844      */
845     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
846 }
847 
848 // PizzaToken with Governance.
849 contract PizzaToken is ERC20("pizzafinance.com", "PIZZA"), Ownable {
850     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
851     function mint(address _to, uint256 _amount) public onlyOwner {
852         _mint(_to, _amount);
853     }
854 }
855 
856 contract PizzaChef is Ownable {
857     using SafeMath for uint256;
858     using SafeERC20 for IERC20;
859 
860     // Info of each user.
861     struct UserInfo {
862         uint256 amount;     // How many LP tokens the user has provided.
863         uint256 rewardDebt; // Reward debt. See explanation below.
864         //
865         // We do some fancy math here. Basically, any point in time, the amount of PIZZAs
866         // entitled to a user but is pending to be distributed is:
867         //
868         //   pending reward = (user.amount * pool.accPizzaPerShare) - user.rewardDebt
869         //
870         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
871         //   1. The pool's `accPizzaPerShare` (and `lastRewardBlock`) gets updated.
872         //   2. User receives the pending reward sent to his/her address.
873         //   3. User's `amount` gets updated.
874         //   4. User's `rewardDebt` gets updated.
875     }
876 
877     // Info of each pool.
878     struct PoolInfo {
879         IERC20 lpToken;           // Address of LP token contract.
880         uint256 allocPoint;       // How many allocation points assigned to this pool. PIZZAs to distribute per block.
881         uint256 lastRewardBlock;  // Last block number that PIZZAs distribution occurs.
882         uint256 accPizzaPerShare; // Accumulated PIZZAs per share, times 1e12. See below.
883     }
884 
885     // The PIZZA TOKEN!
886     PizzaToken public pizza;
887     // Dev address.
888     address public devaddr;
889     // Block number when bonus PIZZA period ends.
890     uint256 public bonusEndBlock;
891     // PIZZA tokens created per block.
892     uint256 public pizzaPerBlock;
893     // Bonus muliplier for early pizza makers.
894     uint256 public constant BONUS_MULTIPLIER = 1; // no bonus
895 
896     // Info of each pool.
897     PoolInfo[] public poolInfo;
898     // Info of each user that stakes LP tokens.
899     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
900     // Total allocation poitns. Must be the sum of all allocation points in all pools.
901     uint256 public totalAllocPoint = 0;
902     // The block number when PIZZA mining starts.
903     uint256 public startBlock;
904 
905     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
906     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
907     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
908 
909     constructor(
910         PizzaToken _pizza,
911         address _devaddr,
912         uint256 _pizzaPerBlock,
913         uint256 _startBlock,
914         uint256 _bonusEndBlock
915     ) public {
916         pizza = _pizza;
917         devaddr = _devaddr;
918         pizzaPerBlock = _pizzaPerBlock;
919         bonusEndBlock = _bonusEndBlock;
920         startBlock = _startBlock;
921     }
922 
923     function poolLength() external view returns (uint256) {
924         return poolInfo.length;
925     }
926 
927     // Add a new lp to the pool. Can only be called by the owner.
928     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
929     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
930         if (_withUpdate) {
931             massUpdatePools();
932         }
933         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
934         totalAllocPoint = totalAllocPoint.add(_allocPoint);
935         poolInfo.push(PoolInfo({
936             lpToken: _lpToken,
937             allocPoint: _allocPoint,
938             lastRewardBlock: lastRewardBlock,
939             accPizzaPerShare: 0
940         }));
941     }
942 
943     // Update the given pool's PIZZA allocation point. Can only be called by the owner.
944     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
945         if (_withUpdate) {
946             massUpdatePools();
947         }
948         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
949         poolInfo[_pid].allocPoint = _allocPoint;
950     }
951 
952 
953 
954     // Return reward multiplier over the given _from to _to block.
955     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
956         if (_to <= bonusEndBlock) {
957             return _to.sub(_from).mul(BONUS_MULTIPLIER);
958         } else if (_from >= bonusEndBlock) {
959             return _to.sub(_from);
960         } else {
961             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
962                 _to.sub(bonusEndBlock)
963             );
964         }
965     }
966 
967     // View function to see pending PIZZAs on frontend.
968     function pendingPizza(uint256 _pid, address _user) external view returns (uint256) {
969         PoolInfo storage pool = poolInfo[_pid];
970         UserInfo storage user = userInfo[_pid][_user];
971         uint256 accPizzaPerShare = pool.accPizzaPerShare;
972         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
973         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
974             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
975             uint256 pizzaReward = multiplier.mul(pizzaPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
976             accPizzaPerShare = accPizzaPerShare.add(pizzaReward.mul(1e12).div(lpSupply));
977         }
978         return user.amount.mul(accPizzaPerShare).div(1e12).sub(user.rewardDebt);
979     }
980 
981     // Update reward vairables for all pools. Be careful of gas spending!
982     function massUpdatePools() public {
983         uint256 length = poolInfo.length;
984         for (uint256 pid = 0; pid < length; ++pid) {
985             updatePool(pid);
986         }
987     }
988 
989 
990     // Update reward variables of the given pool to be up-to-date.
991     function updatePool(uint256 _pid) public {
992         PoolInfo storage pool = poolInfo[_pid];
993         if (block.number <= pool.lastRewardBlock) {
994             return;
995         }
996         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
997         if (lpSupply == 0) {
998             pool.lastRewardBlock = block.number;
999             return;
1000         }
1001         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1002         uint256 pizzaReward = multiplier.mul(pizzaPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1003         pizza.mint(devaddr, pizzaReward.div(25)); // 4%
1004         pizza.mint(address(this), pizzaReward);
1005         pool.accPizzaPerShare = pool.accPizzaPerShare.add(pizzaReward.mul(1e12).div(lpSupply));
1006         pool.lastRewardBlock = block.number;
1007     }
1008 
1009     // Deposit LP tokens to MasterChef for PIZZA allocation.
1010     function deposit(uint256 _pid, uint256 _amount) public {
1011         PoolInfo storage pool = poolInfo[_pid];
1012         UserInfo storage user = userInfo[_pid][msg.sender];
1013         updatePool(_pid);
1014         if (user.amount > 0) {
1015             uint256 pending = user.amount.mul(pool.accPizzaPerShare).div(1e12).sub(user.rewardDebt);
1016             safePizzaTransfer(msg.sender, pending);
1017         }
1018         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1019         user.amount = user.amount.add(_amount);
1020         user.rewardDebt = user.amount.mul(pool.accPizzaPerShare).div(1e12);
1021         emit Deposit(msg.sender, _pid, _amount);
1022     }
1023 
1024     // Withdraw LP tokens from MasterChef.
1025     function withdraw(uint256 _pid, uint256 _amount) public {
1026         PoolInfo storage pool = poolInfo[_pid];
1027         UserInfo storage user = userInfo[_pid][msg.sender];
1028         require(user.amount >= _amount, "withdraw: not good");
1029         updatePool(_pid);
1030         uint256 pending = user.amount.mul(pool.accPizzaPerShare).div(1e12).sub(user.rewardDebt);
1031         safePizzaTransfer(msg.sender, pending);
1032         user.amount = user.amount.sub(_amount);
1033         user.rewardDebt = user.amount.mul(pool.accPizzaPerShare).div(1e12);
1034         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1035         emit Withdraw(msg.sender, _pid, _amount);
1036     }
1037 
1038     // Withdraw without caring about rewards. EMERGENCY ONLY.
1039     function emergencyWithdraw(uint256 _pid) public {
1040         PoolInfo storage pool = poolInfo[_pid];
1041         UserInfo storage user = userInfo[_pid][msg.sender];
1042         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1043         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1044         user.amount = 0;
1045         user.rewardDebt = 0;
1046     }
1047 
1048     // Safe pizza transfer function, just in case if rounding error causes pool to not have enough PIZZAs.
1049     function safePizzaTransfer(address _to, uint256 _amount) internal {
1050         uint256 pizzaBal = pizza.balanceOf(address(this));
1051         if (_amount > pizzaBal) {
1052             pizza.transfer(_to, pizzaBal);
1053         } else {
1054             pizza.transfer(_to, _amount);
1055         }
1056     }
1057 
1058     // Update dev address by the previous dev.
1059     function dev(address _devaddr) public {
1060         require(msg.sender == devaddr, "dev: wut?");
1061         devaddr = _devaddr;
1062     }
1063 }