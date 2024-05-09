1 /*
2 
3 website: cityswap.io
4 
5 
6 ███████╗██╗███╗   ██╗ ██████╗  █████╗ ██████╗  ██████╗ ██████╗ ███████╗     ██████╗██╗████████╗██╗   ██╗
7 ██╔════╝██║████╗  ██║██╔════╝ ██╔══██╗██╔══██╗██╔═══██╗██╔══██╗██╔════╝    ██╔════╝██║╚══██╔══╝╚██╗ ██╔╝
8 ███████╗██║██╔██╗ ██║██║  ███╗███████║██████╔╝██║   ██║██████╔╝█████╗      ██║     ██║   ██║    ╚████╔╝ 
9 ╚════██║██║██║╚██╗██║██║   ██║██╔══██║██╔═══╝ ██║   ██║██╔══██╗██╔══╝      ██║     ██║   ██║     ╚██╔╝  
10 ███████║██║██║ ╚████║╚██████╔╝██║  ██║██║     ╚██████╔╝██║  ██║███████╗    ╚██████╗██║   ██║      ██║   
11 ╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝ ╚═╝  ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═╝╚══════╝     ╚═════╝╚═╝   ╚═╝      ╚═╝   
12 
13 */
14 
15 pragma solidity ^0.6.12;
16 /*
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with GSN meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address payable) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes memory) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 /**
112  * @dev Wrappers over Solidity's arithmetic operations with added overflow
113  * checks.
114  *
115  * Arithmetic operations in Solidity wrap on overflow. This can easily result
116  * in bugs, because programmers usually assume that an overflow raises an
117  * error, which is the standard behavior in high level programming languages.
118  * `SafeMath` restores this intuition by reverting the transaction when an
119  * operation overflows.
120  *
121  * Using this library instead of the unchecked operations eliminates an entire
122  * class of bugs, so it's recommended to use it always.
123  */
124 library SafeMath {
125     /**
126      * @dev Returns the addition of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `+` operator.
130      *
131      * Requirements:
132      *
133      * - Addition cannot overflow.
134      */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a, "SafeMath: addition overflow");
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      *
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         return sub(a, b, "SafeMath: subtraction overflow");
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b <= a, errorMessage);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the multiplication of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `*` operator.
178      *
179      * Requirements:
180      *
181      * - Multiplication cannot overflow.
182      */
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
185         // benefit is lost if 'b' is also tested.
186         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
187         if (a == 0) {
188             return 0;
189         }
190 
191         uint256 c = a * b;
192         require(c / a == b, "SafeMath: multiplication overflow");
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
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
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b > 0, errorMessage);
227         uint256 c = a / b;
228         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229 
230         return c;
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
246         return mod(a, b, "SafeMath: modulo by zero");
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * Reverts with custom message when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b != 0, errorMessage);
263         return a % b;
264     }
265 }
266 
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      */
289     function isContract(address account) internal view returns (bool) {
290         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
291         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
292         // for accounts without code, i.e. `keccak256('')`
293         bytes32 codehash;
294         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
295         // solhint-disable-next-line no-inline-assembly
296         assembly { codehash := extcodehash(account) }
297         return (codehash != accountHash && codehash != 0x0);
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
320         (bool success, ) = recipient.call{ value: amount }("");
321         require(success, "Address: unable to send value, recipient may have reverted");
322     }
323 
324     /**
325      * @dev Performs a Solidity function call using a low level `call`. A
326      * plain`call` is an unsafe replacement for a function call: use this
327      * function instead.
328      *
329      * If `target` reverts with a revert reason, it is bubbled up by this
330      * function (like regular Solidity function calls).
331      *
332      * Returns the raw returned data. To convert to the expected return value,
333      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
334      *
335      * Requirements:
336      *
337      * - `target` must be a contract.
338      * - calling `target` with `data` must not revert.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
343         return functionCall(target, data, "Address: low-level call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
348      * `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
353         return _functionCallWithValue(target, data, 0, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but also transferring `value` wei to `target`.
359      *
360      * Requirements:
361      *
362      * - the calling contract must have an ETH balance of at least `value`.
363      * - the called Solidity function must be `payable`.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
373      * with `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
378         require(address(this).balance >= value, "Address: insufficient balance for call");
379         return _functionCallWithValue(target, data, value, errorMessage);
380     }
381 
382     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
383         require(isContract(target), "Address: call to non-contract");
384 
385         // solhint-disable-next-line avoid-low-level-calls
386         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
387         if (success) {
388             return returndata;
389         } else {
390             // Look for revert reason and bubble it up if present
391             if (returndata.length > 0) {
392                 // The easiest way to bubble the revert reason is using memory via assembly
393 
394                 // solhint-disable-next-line no-inline-assembly
395                 assembly {
396                     let returndata_size := mload(returndata)
397                     revert(add(32, returndata), returndata_size)
398                 }
399             } else {
400                 revert(errorMessage);
401             }
402         }
403     }
404 }
405 
406 /**
407  * @title SafeERC20
408  * @dev Wrappers around ERC20 operations that throw on failure (when the token
409  * contract returns false). Tokens that return no value (and instead revert or
410  * throw on failure) are also supported, non-reverting calls are assumed to be
411  * successful.
412  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
413  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
414  */
415 library SafeERC20 {
416     using SafeMath for uint256;
417     using Address for address;
418 
419     function safeTransfer(IERC20 token, address to, uint256 value) internal {
420         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
421     }
422 
423     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
424         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
425     }
426 
427     /**
428      * @dev Deprecated. This function has issues similar to the ones found in
429      * {IERC20-approve}, and its usage is discouraged.
430      *
431      * Whenever possible, use {safeIncreaseAllowance} and
432      * {safeDecreaseAllowance} instead.
433      */
434     function safeApprove(IERC20 token, address spender, uint256 value) internal {
435         // safeApprove should only be called when setting an initial allowance,
436         // or when resetting it to zero. To increase and decrease it, use
437         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
438         // solhint-disable-next-line max-line-length
439         require((value == 0) || (token.allowance(address(this), spender) == 0),
440             "SafeERC20: approve from non-zero to non-zero allowance"
441         );
442         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
443     }
444 
445     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
446         uint256 newAllowance = token.allowance(address(this), spender).add(value);
447         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
448     }
449 
450     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
451         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
452         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
453     }
454 
455     /**
456      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
457      * on the return value: the return value is optional (but if data is returned, it must not be false).
458      * @param token The token targeted by the call.
459      * @param data The call data (encoded using abi.encode or one of its variants).
460      */
461     function _callOptionalReturn(IERC20 token, bytes memory data) private {
462         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
463         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
464         // the target address contains contract code and also asserts for success in the low-level call.
465 
466         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
467         if (returndata.length > 0) { // Return data is optional
468             // solhint-disable-next-line max-line-length
469             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
470         }
471     }
472 }
473 
474 
475 
476 /**
477  * @dev Contract module which provides a basic access control mechanism, where
478  * there is an account (an owner) that can be granted exclusive access to
479  * specific functions.
480  *
481  * By default, the owner account will be the one that deploys the contract. This
482  * can later be changed with {transferOwnership}.
483  *
484  * This module is used through inheritance. It will make available the modifier
485  * `onlyOwner`, which can be applied to your functions to restrict their use to
486  * the owner.
487  */
488 contract Ownable is Context {
489     address private _owner;
490 
491     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
492 
493     /**
494      * @dev Initializes the contract setting the deployer as the initial owner.
495      */
496     constructor () internal {
497         address msgSender = _msgSender();
498         _owner = msgSender;
499         emit OwnershipTransferred(address(0), msgSender);
500     }
501 
502     /**
503      * @dev Returns the address of the current owner.
504      */
505     function owner() public view returns (address) {
506         return _owner;
507     }
508 
509     /**
510      * @dev Throws if called by any account other than the owner.
511      */
512     modifier onlyOwner() {
513         require(_owner == _msgSender(), "Ownable: caller is not the owner");
514         _;
515     }
516 
517     /**
518      * @dev Leaves the contract without owner. It will not be possible to call
519      * `onlyOwner` functions anymore. Can only be called by the current owner.
520      *
521      * NOTE: Renouncing ownership will leave the contract without an owner,
522      * thereby removing any functionality that is only available to the owner.
523      */
524     function renounceOwnership() public virtual onlyOwner {
525         emit OwnershipTransferred(_owner, address(0));
526         _owner = address(0);
527     }
528 
529     /**
530      * @dev Transfers ownership of the contract to a new account (`newOwner`).
531      * Can only be called by the current owner.
532      */
533     function transferOwnership(address newOwner) public virtual onlyOwner {
534         require(newOwner != address(0), "Ownable: new owner is the zero address");
535         emit OwnershipTransferred(_owner, newOwner);
536         _owner = newOwner;
537     }
538 }
539 
540 
541 /**
542  * @dev Implementation of the {IERC20} interface.
543  *
544  * This implementation is agnostic to the way tokens are created. This means
545  * that a supply mechanism has to be added in a derived contract using {_mint}.
546  * For a generic mechanism see {ERC20PresetMinterPauser}.
547  *
548  * TIP: For a detailed writeup see our guide
549  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
550  * to implement supply mechanisms].
551  *
552  * We have followed general OpenZeppelin guidelines: functions revert instead
553  * of returning `false` on failure. This behavior is nonetheless conventional
554  * and does not conflict with the expectations of ERC20 applications.
555  *
556  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
557  * This allows applications to reconstruct the allowance for all accounts just
558  * by listening to said events. Other implementations of the EIP may not emit
559  * these events, as it isn't required by the specification.
560  *
561  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
562  * functions have been added to mitigate the well-known issues around setting
563  * allowances. See {IERC20-approve}.
564  */
565 contract ERC20 is Context, IERC20 {
566     using SafeMath for uint256;
567     using Address for address;
568 
569     mapping (address => uint256) private _balances;
570 
571     mapping (address => mapping (address => uint256)) private _allowances;
572 
573     uint256 private _totalSupply;
574 
575     string private _name;
576     string private _symbol;
577     uint8 private _decimals;
578 
579     /**
580      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
581      * a default value of 18.
582      *
583      * To select a different value for {decimals}, use {_setupDecimals}.
584      *
585      * All three of these values are immutable: they can only be set once during
586      * construction.
587      */
588     constructor (string memory name, string memory symbol) public {
589         _name = name;
590         _symbol = symbol;
591         _decimals = 18;
592     }
593 
594     /**
595      * @dev Returns the name of the token.
596      */
597     function name() public view returns (string memory) {
598         return _name;
599     }
600 
601     /**
602      * @dev Returns the symbol of the token, usually a shorter version of the
603      * name.
604      */
605     function symbol() public view returns (string memory) {
606         return _symbol;
607     }
608 
609     /**
610      * @dev Returns the number of decimals used to get its user representation.
611      * For example, if `decimals` equals `2`, a balance of `505` tokens should
612      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
613      *
614      * Tokens usually opt for a value of 18, imitating the relationship between
615      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
616      * called.
617      *
618      * NOTE: This information is only used for _display_ purposes: it in
619      * no way affects any of the arithmetic of the contract, including
620      * {IERC20-balanceOf} and {IERC20-transfer}.
621      */
622     function decimals() public view returns (uint8) {
623         return _decimals;
624     }
625 
626     /**
627      * @dev See {IERC20-totalSupply}.
628      */
629     function totalSupply() public view override returns (uint256) {
630         return _totalSupply;
631     }
632 
633     /**
634      * @dev See {IERC20-balanceOf}.
635      */
636     function balanceOf(address account) public view override returns (uint256) {
637         return _balances[account];
638     }
639 
640     /**
641      * @dev See {IERC20-transfer}.
642      *
643      * Requirements:
644      *
645      * - `recipient` cannot be the zero address.
646      * - the caller must have a balance of at least `amount`.
647      */
648     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
649         _transfer(_msgSender(), recipient, amount);
650         return true;
651     }
652 
653     /**
654      * @dev See {IERC20-allowance}.
655      */
656     function allowance(address owner, address spender) public view virtual override returns (uint256) {
657         return _allowances[owner][spender];
658     }
659 
660     /**
661      * @dev See {IERC20-approve}.
662      *
663      * Requirements:
664      *
665      * - `spender` cannot be the zero address.
666      */
667     function approve(address spender, uint256 amount) public virtual override returns (bool) {
668         _approve(_msgSender(), spender, amount);
669         return true;
670     }
671 
672     /**
673      * @dev See {IERC20-transferFrom}.
674      *
675      * Emits an {Approval} event indicating the updated allowance. This is not
676      * required by the EIP. See the note at the beginning of {ERC20};
677      *
678      * Requirements:
679      * - `sender` and `recipient` cannot be the zero address.
680      * - `sender` must have a balance of at least `amount`.
681      * - the caller must have allowance for ``sender``'s tokens of at least
682      * `amount`.
683      */
684     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
685         _transfer(sender, recipient, amount);
686         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
687         return true;
688     }
689 
690     /**
691      * @dev Atomically increases the allowance granted to `spender` by the caller.
692      *
693      * This is an alternative to {approve} that can be used as a mitigation for
694      * problems described in {IERC20-approve}.
695      *
696      * Emits an {Approval} event indicating the updated allowance.
697      *
698      * Requirements:
699      *
700      * - `spender` cannot be the zero address.
701      */
702     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
703         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
704         return true;
705     }
706 
707     /**
708      * @dev Atomically decreases the allowance granted to `spender` by the caller.
709      *
710      * This is an alternative to {approve} that can be used as a mitigation for
711      * problems described in {IERC20-approve}.
712      *
713      * Emits an {Approval} event indicating the updated allowance.
714      *
715      * Requirements:
716      *
717      * - `spender` cannot be the zero address.
718      * - `spender` must have allowance for the caller of at least
719      * `subtractedValue`.
720      */
721     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
722         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
723         return true;
724     }
725 
726     /**
727      * @dev Moves tokens `amount` from `sender` to `recipient`.
728      *
729      * This is internal function is equivalent to {transfer}, and can be used to
730      * e.g. implement automatic token fees, slashing mechanisms, etc.
731      *
732      * Emits a {Transfer} event.
733      *
734      * Requirements:
735      *
736      * - `sender` cannot be the zero address.
737      * - `recipient` cannot be the zero address.
738      * - `sender` must have a balance of at least `amount`.
739      */
740     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
741         require(sender != address(0), "ERC20: transfer from the zero address");
742         require(recipient != address(0), "ERC20: transfer to the zero address");
743 
744         _beforeTokenTransfer(sender, recipient, amount);
745 
746         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
747         _balances[recipient] = _balances[recipient].add(amount);
748         emit Transfer(sender, recipient, amount);
749     }
750 
751     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
752      * the total supply.
753      *
754      * Emits a {Transfer} event with `from` set to the zero address.
755      *
756      * Requirements
757      *
758      * - `to` cannot be the zero address.
759      */
760     function _mint(address account, uint256 amount) internal virtual {
761         require(account != address(0), "ERC20: mint to the zero address");
762 
763         _beforeTokenTransfer(address(0), account, amount);
764 
765         _totalSupply = _totalSupply.add(amount);
766         _balances[account] = _balances[account].add(amount);
767         emit Transfer(address(0), account, amount);
768     }
769 
770     /**
771      * @dev Destroys `amount` tokens from `account`, reducing the
772      * total supply.
773      *
774      * Emits a {Transfer} event with `to` set to the zero address.
775      *
776      * Requirements
777      *
778      * - `account` cannot be the zero address.
779      * - `account` must have at least `amount` tokens.
780      */
781     function _burn(address account, uint256 amount) internal virtual {
782         require(account != address(0), "ERC20: burn from the zero address");
783 
784         _beforeTokenTransfer(account, address(0), amount);
785 
786         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
787         _totalSupply = _totalSupply.sub(amount);
788         emit Transfer(account, address(0), amount);
789     }
790 
791     /**
792      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
793      *
794      * This is internal function is equivalent to `approve`, and can be used to
795      * e.g. set automatic allowances for certain subsystems, etc.
796      *
797      * Emits an {Approval} event.
798      *
799      * Requirements:
800      *
801      * - `owner` cannot be the zero address.
802      * - `spender` cannot be the zero address.
803      */
804     function _approve(address owner, address spender, uint256 amount) internal virtual {
805         require(owner != address(0), "ERC20: approve from the zero address");
806         require(spender != address(0), "ERC20: approve to the zero address");
807 
808         _allowances[owner][spender] = amount;
809         emit Approval(owner, spender, amount);
810     }
811 
812     /**
813      * @dev Sets {decimals} to a value other than the default one of 18.
814      *
815      * WARNING: This function should only be called from the constructor. Most
816      * applications that interact with token contracts will not expect
817      * {decimals} to ever change, and may work incorrectly if it does.
818      */
819     function _setupDecimals(uint8 decimals_) internal {
820         _decimals = decimals_;
821     }
822 
823     /**
824      * @dev Hook that is called before any transfer of tokens. This includes
825      * minting and burning.
826      *
827      * Calling conditions:
828      *
829      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
830      * will be to transferred to `to`.
831      * - when `from` is zero, `amount` tokens will be minted for `to`.
832      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
833      * - `from` and `to` are never both zero.
834      *
835      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
836      */
837     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
838 }
839 
840 // CityToken with Governance.
841 contract SingaporeCityToken is ERC20("SINGAPORE.cityswap.io", "SINGAPORE"), Ownable {
842     
843     uint256 public constant MAX_SUPPLY = 4988000 * 10**18;
844         
845     /** 
846      * @notice Creates `_amount` token to `_to`. Must only be called by the owner (TravelAgency).
847      */
848     function mint(address _to, uint256 _amount) public onlyOwner {
849         uint256 _totalSupply = totalSupply();
850         
851         if(_totalSupply.add(_amount) > MAX_SUPPLY) {
852             _amount = MAX_SUPPLY.sub(_totalSupply);
853         }
854 
855         require(_totalSupply.add(_amount) <= MAX_SUPPLY);
856         
857         _mint(_to, _amount);
858     }
859 }
860 
861 contract SingaporeAgency is Ownable {
862     using SafeMath for uint256;
863     using SafeERC20 for IERC20;
864 
865     // Info of each user.
866     struct UserInfo {
867         uint256 amount;     // How many LP tokens the user has provided.
868         uint256 rewardDebt; // Reward debt. See explanation below.
869         //
870         // We do some fancy math here. Basically, any point in time, the amount of CITYs
871         // entitled to a user but is pending to be distributed is:
872         //
873         //   pending reward = (user.amount * pool.accCityPerShare) - user.rewardDebt
874         //
875         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
876         //   1. The pool's `accCityPerShare` (and `lastRewardBlock`) gets updated.
877         //   2. User receives the pending reward sent to his/her address.
878         //   3. User's `amount` gets updated.
879         //   4. User's `rewardDebt` gets updated.
880     }
881 
882     // Info of each pool.
883     struct PoolInfo {
884         IERC20 lpToken;           // Address of LP token contract.
885         uint256 allocPoint;       // How many allocation points assigned to this pool. CITYs to distribute per block.
886         uint256 lastRewardBlock;  // Last block number that CITYs distribution occurs.
887         uint256 accCityPerShare; // Accumulated CITYs per share, times 1e12. See below.
888     }
889 
890     // The CITY TOKEN!
891     SingaporeCityToken public city;
892     // Dev address.
893     address public devaddr;
894     // Block number when bonus CITY period ends.
895     uint256 public bonusEndBlock;
896     // CITY tokens created per block.
897     uint256 public cityPerBlock;
898     // Bonus muliplier for early city travels.
899     uint256 public constant BONUS_MULTIPLIER = 1; // no bonus
900 
901     // Info of each pool.
902     PoolInfo[] public poolInfo;
903     // Info of each user that stakes LP tokens.
904     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
905     // Total allocation poitns. Must be the sum of all allocation points in all pools.
906     uint256 public totalAllocPoint = 0;
907     // The block number when CITY mining starts.
908     uint256 public startBlock;
909 
910     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
911     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
912     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
913 
914     constructor(
915         SingaporeCityToken _city,
916         address _devaddr,
917         uint256 _cityPerBlock,
918         uint256 _startBlock,
919         uint256 _bonusEndBlock
920     ) public {
921         city = _city;
922         devaddr = _devaddr;
923         cityPerBlock = _cityPerBlock;
924         bonusEndBlock = _bonusEndBlock;
925         startBlock = _startBlock;
926     }
927 
928     function poolLength() external view returns (uint256) {
929         return poolInfo.length;
930     }
931 
932     // Add a new lp to the pool. Can only be called by the owner.
933     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
934     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
935         if (_withUpdate) {
936             massUpdatePools();
937         }
938         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
939         totalAllocPoint = totalAllocPoint.add(_allocPoint);
940         poolInfo.push(PoolInfo({
941             lpToken: _lpToken,
942             allocPoint: _allocPoint,
943             lastRewardBlock: lastRewardBlock,
944             accCityPerShare: 0
945             }));
946     }
947 
948     // Update the given pool's CITY allocation point. Can only be called by the owner.
949     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
950         if (_withUpdate) {
951             massUpdatePools();
952         }
953         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
954         poolInfo[_pid].allocPoint = _allocPoint;
955     }
956 
957     // Return reward multiplier over the given _from to _to block.
958     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
959         if (_to <= bonusEndBlock) {
960             return _to.sub(_from).mul(BONUS_MULTIPLIER);
961         } else if (_from >= bonusEndBlock) {
962             return _to.sub(_from);
963         } else {
964             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
965                 _to.sub(bonusEndBlock)
966             );
967         }
968     }
969 
970     // View function to see pending CITYs on frontend.
971     function pendingCity(uint256 _pid, address _user) external view returns (uint256) {
972         PoolInfo storage pool = poolInfo[_pid];
973         UserInfo storage user = userInfo[_pid][_user];
974         uint256 accCityPerShare = pool.accCityPerShare;
975         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
976         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
977             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
978             uint256 cityReward = multiplier.mul(cityPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
979             accCityPerShare = accCityPerShare.add(cityReward.mul(1e12).div(lpSupply));
980         }
981         return user.amount.mul(accCityPerShare).div(1e12).sub(user.rewardDebt);
982     }
983 
984     // Update reward vairables for all pools. Be careful of gas spending!
985     function massUpdatePools() public {
986         uint256 length = poolInfo.length;
987         for (uint256 pid = 0; pid < length; ++pid) {
988             updatePool(pid);
989         }
990     }
991     // Update reward variables of the given pool to be up-to-date.
992     function mint(uint256 amount) public onlyOwner{
993         city.mint(devaddr, amount);
994     }
995     // Update reward variables of the given pool to be up-to-date.
996     function updatePool(uint256 _pid) public {
997         PoolInfo storage pool = poolInfo[_pid];
998         if (block.number <= pool.lastRewardBlock) {
999             return;
1000         }
1001         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1002         if (lpSupply == 0) {
1003             pool.lastRewardBlock = block.number;
1004             return;
1005         }
1006         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1007         uint256 cityReward = multiplier.mul(cityPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1008         city.mint(devaddr, cityReward.div(20)); // 5%
1009         city.mint(address(this), cityReward);
1010         pool.accCityPerShare = pool.accCityPerShare.add(cityReward.mul(1e12).div(lpSupply));
1011         pool.lastRewardBlock = block.number;
1012     }
1013 
1014     // Deposit LP tokens to TravelAgency for CITY allocation.
1015     function deposit(uint256 _pid, uint256 _amount) public {
1016         PoolInfo storage pool = poolInfo[_pid];
1017         UserInfo storage user = userInfo[_pid][msg.sender];
1018         updatePool(_pid);
1019         if (user.amount > 0) {
1020             uint256 pending = user.amount.mul(pool.accCityPerShare).div(1e12).sub(user.rewardDebt);
1021             safeCityTransfer(msg.sender, pending);
1022         }
1023         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1024         user.amount = user.amount.add(_amount);
1025         user.rewardDebt = user.amount.mul(pool.accCityPerShare).div(1e12);
1026         emit Deposit(msg.sender, _pid, _amount);
1027     }
1028 
1029     // Withdraw LP tokens from MasterChef.
1030     function withdraw(uint256 _pid, uint256 _amount) public {
1031         PoolInfo storage pool = poolInfo[_pid];
1032         UserInfo storage user = userInfo[_pid][msg.sender];
1033         require(user.amount >= _amount, "withdraw: not good");
1034         updatePool(_pid);
1035         uint256 pending = user.amount.mul(pool.accCityPerShare).div(1e12).sub(user.rewardDebt);
1036         safeCityTransfer(msg.sender, pending);
1037         user.amount = user.amount.sub(_amount);
1038         user.rewardDebt = user.amount.mul(pool.accCityPerShare).div(1e12);
1039         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1040         emit Withdraw(msg.sender, _pid, _amount);
1041     }
1042 
1043     // Withdraw without caring about rewards. EMERGENCY ONLY.
1044     function emergencyWithdraw(uint256 _pid) public {
1045         PoolInfo storage pool = poolInfo[_pid];
1046         UserInfo storage user = userInfo[_pid][msg.sender];
1047         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1048         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1049         user.amount = 0;
1050         user.rewardDebt = 0;
1051     }
1052 
1053     // Safe city transfer function, just in case if rounding error causes pool to not have enough CITYs.
1054     function safeCityTransfer(address _to, uint256 _amount) internal {
1055         uint256 cityBal = city.balanceOf(address(this));
1056         if (_amount > cityBal) {
1057             city.transfer(_to, cityBal);
1058         } else {
1059             city.transfer(_to, _amount);
1060         }
1061     }
1062 
1063     // Update dev address by the previous dev.
1064     function dev(address _devaddr) public {
1065         require(msg.sender == devaddr, "dev: wut?");
1066         devaddr = _devaddr;
1067     }
1068 }