1 /*
2 
3 website: cityswap.io
4 
5 ███████╗████████╗ ██████╗  ██████╗██╗  ██╗██╗  ██╗ ██████╗ ██╗     ███╗   ███╗     ██████╗██╗████████╗██╗   ██╗
6 ██╔════╝╚══██╔══╝██╔═══██╗██╔════╝██║ ██╔╝██║  ██║██╔═══██╗██║     ████╗ ████║    ██╔════╝██║╚══██╔══╝╚██╗ ██╔╝
7 ███████╗   ██║   ██║   ██║██║     █████╔╝ ███████║██║   ██║██║     ██╔████╔██║    ██║     ██║   ██║    ╚████╔╝ 
8 ╚════██║   ██║   ██║   ██║██║     ██╔═██╗ ██╔══██║██║   ██║██║     ██║╚██╔╝██║    ██║     ██║   ██║     ╚██╔╝  
9 ███████║   ██║   ╚██████╔╝╚██████╗██║  ██╗██║  ██║╚██████╔╝███████╗██║ ╚═╝ ██║    ╚██████╗██║   ██║      ██║   
10 ╚══════╝   ╚═╝    ╚═════╝  ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝╚═╝     ╚═╝     ╚═════╝╚═╝   ╚═╝      ╚═╝   
11 
12 */
13 
14 pragma solidity ^0.6.12;
15 /*
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with GSN meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address payable) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes memory) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
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
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 
267 /**
268  * @dev Collection of functions related to the address type
269  */
270 library Address {
271     /**
272      * @dev Returns true if `account` is a contract.
273      *
274      * [IMPORTANT]
275      * ====
276      * It is unsafe to assume that an address for which this function returns
277      * false is an externally-owned account (EOA) and not a contract.
278      *
279      * Among others, `isContract` will return false for the following
280      * types of addresses:
281      *
282      *  - an externally-owned account
283      *  - a contract in construction
284      *  - an address where a contract will be created
285      *  - an address where a contract lived, but was destroyed
286      * ====
287      */
288     function isContract(address account) internal view returns (bool) {
289         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
290         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
291         // for accounts without code, i.e. `keccak256('')`
292         bytes32 codehash;
293         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
294         // solhint-disable-next-line no-inline-assembly
295         assembly { codehash := extcodehash(account) }
296         return (codehash != accountHash && codehash != 0x0);
297     }
298 
299     /**
300      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
301      * `recipient`, forwarding all available gas and reverting on errors.
302      *
303      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
304      * of certain opcodes, possibly making contracts go over the 2300 gas limit
305      * imposed by `transfer`, making them unable to receive funds via
306      * `transfer`. {sendValue} removes this limitation.
307      *
308      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
309      *
310      * IMPORTANT: because control is transferred to `recipient`, care must be
311      * taken to not create reentrancy vulnerabilities. Consider using
312      * {ReentrancyGuard} or the
313      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
314      */
315     function sendValue(address payable recipient, uint256 amount) internal {
316         require(address(this).balance >= amount, "Address: insufficient balance");
317 
318         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
319         (bool success, ) = recipient.call{ value: amount }("");
320         require(success, "Address: unable to send value, recipient may have reverted");
321     }
322 
323     /**
324      * @dev Performs a Solidity function call using a low level `call`. A
325      * plain`call` is an unsafe replacement for a function call: use this
326      * function instead.
327      *
328      * If `target` reverts with a revert reason, it is bubbled up by this
329      * function (like regular Solidity function calls).
330      *
331      * Returns the raw returned data. To convert to the expected return value,
332      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
333      *
334      * Requirements:
335      *
336      * - `target` must be a contract.
337      * - calling `target` with `data` must not revert.
338      *
339      * _Available since v3.1._
340      */
341     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
342         return functionCall(target, data, "Address: low-level call failed");
343     }
344 
345     /**
346      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
347      * `errorMessage` as a fallback revert reason when `target` reverts.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
352         return _functionCallWithValue(target, data, 0, errorMessage);
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
357      * but also transferring `value` wei to `target`.
358      *
359      * Requirements:
360      *
361      * - the calling contract must have an ETH balance of at least `value`.
362      * - the called Solidity function must be `payable`.
363      *
364      * _Available since v3.1._
365      */
366     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
367         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
372      * with `errorMessage` as a fallback revert reason when `target` reverts.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
377         require(address(this).balance >= value, "Address: insufficient balance for call");
378         return _functionCallWithValue(target, data, value, errorMessage);
379     }
380 
381     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
382         require(isContract(target), "Address: call to non-contract");
383 
384         // solhint-disable-next-line avoid-low-level-calls
385         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
386         if (success) {
387             return returndata;
388         } else {
389             // Look for revert reason and bubble it up if present
390             if (returndata.length > 0) {
391                 // The easiest way to bubble the revert reason is using memory via assembly
392 
393                 // solhint-disable-next-line no-inline-assembly
394                 assembly {
395                     let returndata_size := mload(returndata)
396                     revert(add(32, returndata), returndata_size)
397                 }
398             } else {
399                 revert(errorMessage);
400             }
401         }
402     }
403 }
404 
405 /**
406  * @title SafeERC20
407  * @dev Wrappers around ERC20 operations that throw on failure (when the token
408  * contract returns false). Tokens that return no value (and instead revert or
409  * throw on failure) are also supported, non-reverting calls are assumed to be
410  * successful.
411  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
412  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
413  */
414 library SafeERC20 {
415     using SafeMath for uint256;
416     using Address for address;
417 
418     function safeTransfer(IERC20 token, address to, uint256 value) internal {
419         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
420     }
421 
422     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
423         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
424     }
425 
426     /**
427      * @dev Deprecated. This function has issues similar to the ones found in
428      * {IERC20-approve}, and its usage is discouraged.
429      *
430      * Whenever possible, use {safeIncreaseAllowance} and
431      * {safeDecreaseAllowance} instead.
432      */
433     function safeApprove(IERC20 token, address spender, uint256 value) internal {
434         // safeApprove should only be called when setting an initial allowance,
435         // or when resetting it to zero. To increase and decrease it, use
436         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
437         // solhint-disable-next-line max-line-length
438         require((value == 0) || (token.allowance(address(this), spender) == 0),
439             "SafeERC20: approve from non-zero to non-zero allowance"
440         );
441         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
442     }
443 
444     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
445         uint256 newAllowance = token.allowance(address(this), spender).add(value);
446         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
447     }
448 
449     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
450         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
451         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
452     }
453 
454     /**
455      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
456      * on the return value: the return value is optional (but if data is returned, it must not be false).
457      * @param token The token targeted by the call.
458      * @param data The call data (encoded using abi.encode or one of its variants).
459      */
460     function _callOptionalReturn(IERC20 token, bytes memory data) private {
461         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
462         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
463         // the target address contains contract code and also asserts for success in the low-level call.
464 
465         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
466         if (returndata.length > 0) { // Return data is optional
467             // solhint-disable-next-line max-line-length
468             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
469         }
470     }
471 }
472 
473 
474 
475 /**
476  * @dev Contract module which provides a basic access control mechanism, where
477  * there is an account (an owner) that can be granted exclusive access to
478  * specific functions.
479  *
480  * By default, the owner account will be the one that deploys the contract. This
481  * can later be changed with {transferOwnership}.
482  *
483  * This module is used through inheritance. It will make available the modifier
484  * `onlyOwner`, which can be applied to your functions to restrict their use to
485  * the owner.
486  */
487 contract Ownable is Context {
488     address private _owner;
489 
490     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
491 
492     /**
493      * @dev Initializes the contract setting the deployer as the initial owner.
494      */
495     constructor () internal {
496         address msgSender = _msgSender();
497         _owner = msgSender;
498         emit OwnershipTransferred(address(0), msgSender);
499     }
500 
501     /**
502      * @dev Returns the address of the current owner.
503      */
504     function owner() public view returns (address) {
505         return _owner;
506     }
507 
508     /**
509      * @dev Throws if called by any account other than the owner.
510      */
511     modifier onlyOwner() {
512         require(_owner == _msgSender(), "Ownable: caller is not the owner");
513         _;
514     }
515 
516     /**
517      * @dev Leaves the contract without owner. It will not be possible to call
518      * `onlyOwner` functions anymore. Can only be called by the current owner.
519      *
520      * NOTE: Renouncing ownership will leave the contract without an owner,
521      * thereby removing any functionality that is only available to the owner.
522      */
523     function renounceOwnership() public virtual onlyOwner {
524         emit OwnershipTransferred(_owner, address(0));
525         _owner = address(0);
526     }
527 
528     /**
529      * @dev Transfers ownership of the contract to a new account (`newOwner`).
530      * Can only be called by the current owner.
531      */
532     function transferOwnership(address newOwner) public virtual onlyOwner {
533         require(newOwner != address(0), "Ownable: new owner is the zero address");
534         emit OwnershipTransferred(_owner, newOwner);
535         _owner = newOwner;
536     }
537 }
538 
539 
540 /**
541  * @dev Implementation of the {IERC20} interface.
542  *
543  * This implementation is agnostic to the way tokens are created. This means
544  * that a supply mechanism has to be added in a derived contract using {_mint}.
545  * For a generic mechanism see {ERC20PresetMinterPauser}.
546  *
547  * TIP: For a detailed writeup see our guide
548  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
549  * to implement supply mechanisms].
550  *
551  * We have followed general OpenZeppelin guidelines: functions revert instead
552  * of returning `false` on failure. This behavior is nonetheless conventional
553  * and does not conflict with the expectations of ERC20 applications.
554  *
555  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
556  * This allows applications to reconstruct the allowance for all accounts just
557  * by listening to said events. Other implementations of the EIP may not emit
558  * these events, as it isn't required by the specification.
559  *
560  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
561  * functions have been added to mitigate the well-known issues around setting
562  * allowances. See {IERC20-approve}.
563  */
564 contract ERC20 is Context, IERC20 {
565     using SafeMath for uint256;
566     using Address for address;
567 
568     mapping (address => uint256) private _balances;
569 
570     mapping (address => mapping (address => uint256)) private _allowances;
571 
572     uint256 private _totalSupply;
573 
574     string private _name;
575     string private _symbol;
576     uint8 private _decimals;
577 
578     /**
579      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
580      * a default value of 18.
581      *
582      * To select a different value for {decimals}, use {_setupDecimals}.
583      *
584      * All three of these values are immutable: they can only be set once during
585      * construction.
586      */
587     constructor (string memory name, string memory symbol) public {
588         _name = name;
589         _symbol = symbol;
590         _decimals = 18;
591     }
592 
593     /**
594      * @dev Returns the name of the token.
595      */
596     function name() public view returns (string memory) {
597         return _name;
598     }
599 
600     /**
601      * @dev Returns the symbol of the token, usually a shorter version of the
602      * name.
603      */
604     function symbol() public view returns (string memory) {
605         return _symbol;
606     }
607 
608     /**
609      * @dev Returns the number of decimals used to get its user representation.
610      * For example, if `decimals` equals `2`, a balance of `505` tokens should
611      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
612      *
613      * Tokens usually opt for a value of 18, imitating the relationship between
614      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
615      * called.
616      *
617      * NOTE: This information is only used for _display_ purposes: it in
618      * no way affects any of the arithmetic of the contract, including
619      * {IERC20-balanceOf} and {IERC20-transfer}.
620      */
621     function decimals() public view returns (uint8) {
622         return _decimals;
623     }
624 
625     /**
626      * @dev See {IERC20-totalSupply}.
627      */
628     function totalSupply() public view override returns (uint256) {
629         return _totalSupply;
630     }
631 
632     /**
633      * @dev See {IERC20-balanceOf}.
634      */
635     function balanceOf(address account) public view override returns (uint256) {
636         return _balances[account];
637     }
638 
639     /**
640      * @dev See {IERC20-transfer}.
641      *
642      * Requirements:
643      *
644      * - `recipient` cannot be the zero address.
645      * - the caller must have a balance of at least `amount`.
646      */
647     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
648         _transfer(_msgSender(), recipient, amount);
649         return true;
650     }
651 
652     /**
653      * @dev See {IERC20-allowance}.
654      */
655     function allowance(address owner, address spender) public view virtual override returns (uint256) {
656         return _allowances[owner][spender];
657     }
658 
659     /**
660      * @dev See {IERC20-approve}.
661      *
662      * Requirements:
663      *
664      * - `spender` cannot be the zero address.
665      */
666     function approve(address spender, uint256 amount) public virtual override returns (bool) {
667         _approve(_msgSender(), spender, amount);
668         return true;
669     }
670 
671     /**
672      * @dev See {IERC20-transferFrom}.
673      *
674      * Emits an {Approval} event indicating the updated allowance. This is not
675      * required by the EIP. See the note at the beginning of {ERC20};
676      *
677      * Requirements:
678      * - `sender` and `recipient` cannot be the zero address.
679      * - `sender` must have a balance of at least `amount`.
680      * - the caller must have allowance for ``sender``'s tokens of at least
681      * `amount`.
682      */
683     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
684         _transfer(sender, recipient, amount);
685         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
686         return true;
687     }
688 
689     /**
690      * @dev Atomically increases the allowance granted to `spender` by the caller.
691      *
692      * This is an alternative to {approve} that can be used as a mitigation for
693      * problems described in {IERC20-approve}.
694      *
695      * Emits an {Approval} event indicating the updated allowance.
696      *
697      * Requirements:
698      *
699      * - `spender` cannot be the zero address.
700      */
701     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
702         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
703         return true;
704     }
705 
706     /**
707      * @dev Atomically decreases the allowance granted to `spender` by the caller.
708      *
709      * This is an alternative to {approve} that can be used as a mitigation for
710      * problems described in {IERC20-approve}.
711      *
712      * Emits an {Approval} event indicating the updated allowance.
713      *
714      * Requirements:
715      *
716      * - `spender` cannot be the zero address.
717      * - `spender` must have allowance for the caller of at least
718      * `subtractedValue`.
719      */
720     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
721         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
722         return true;
723     }
724 
725     /**
726      * @dev Moves tokens `amount` from `sender` to `recipient`.
727      *
728      * This is internal function is equivalent to {transfer}, and can be used to
729      * e.g. implement automatic token fees, slashing mechanisms, etc.
730      *
731      * Emits a {Transfer} event.
732      *
733      * Requirements:
734      *
735      * - `sender` cannot be the zero address.
736      * - `recipient` cannot be the zero address.
737      * - `sender` must have a balance of at least `amount`.
738      */
739     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
740         require(sender != address(0), "ERC20: transfer from the zero address");
741         require(recipient != address(0), "ERC20: transfer to the zero address");
742 
743         _beforeTokenTransfer(sender, recipient, amount);
744 
745         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
746         _balances[recipient] = _balances[recipient].add(amount);
747         emit Transfer(sender, recipient, amount);
748     }
749 
750     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
751      * the total supply.
752      *
753      * Emits a {Transfer} event with `from` set to the zero address.
754      *
755      * Requirements
756      *
757      * - `to` cannot be the zero address.
758      */
759     function _mint(address account, uint256 amount) internal virtual {
760         require(account != address(0), "ERC20: mint to the zero address");
761 
762         _beforeTokenTransfer(address(0), account, amount);
763 
764         _totalSupply = _totalSupply.add(amount);
765         _balances[account] = _balances[account].add(amount);
766         emit Transfer(address(0), account, amount);
767     }
768 
769     /**
770      * @dev Destroys `amount` tokens from `account`, reducing the
771      * total supply.
772      *
773      * Emits a {Transfer} event with `to` set to the zero address.
774      *
775      * Requirements
776      *
777      * - `account` cannot be the zero address.
778      * - `account` must have at least `amount` tokens.
779      */
780     function _burn(address account, uint256 amount) internal virtual {
781         require(account != address(0), "ERC20: burn from the zero address");
782 
783         _beforeTokenTransfer(account, address(0), amount);
784 
785         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
786         _totalSupply = _totalSupply.sub(amount);
787         emit Transfer(account, address(0), amount);
788     }
789 
790     /**
791      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
792      *
793      * This is internal function is equivalent to `approve`, and can be used to
794      * e.g. set automatic allowances for certain subsystems, etc.
795      *
796      * Emits an {Approval} event.
797      *
798      * Requirements:
799      *
800      * - `owner` cannot be the zero address.
801      * - `spender` cannot be the zero address.
802      */
803     function _approve(address owner, address spender, uint256 amount) internal virtual {
804         require(owner != address(0), "ERC20: approve from the zero address");
805         require(spender != address(0), "ERC20: approve to the zero address");
806 
807         _allowances[owner][spender] = amount;
808         emit Approval(owner, spender, amount);
809     }
810 
811     /**
812      * @dev Sets {decimals} to a value other than the default one of 18.
813      *
814      * WARNING: This function should only be called from the constructor. Most
815      * applications that interact with token contracts will not expect
816      * {decimals} to ever change, and may work incorrectly if it does.
817      */
818     function _setupDecimals(uint8 decimals_) internal {
819         _decimals = decimals_;
820     }
821 
822     /**
823      * @dev Hook that is called before any transfer of tokens. This includes
824      * minting and burning.
825      *
826      * Calling conditions:
827      *
828      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
829      * will be to transferred to `to`.
830      * - when `from` is zero, `amount` tokens will be minted for `to`.
831      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
832      * - `from` and `to` are never both zero.
833      *
834      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
835      */
836     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
837 }
838 
839 // CityToken with Governance.
840 contract StockholmCityToken is ERC20("STOCKHOLM.cityswap.io", "STOCKHOLM"), Ownable {
841     
842     uint256 public constant MAX_SUPPLY = 1335000 * 10**18;
843         
844     /** 
845      * @notice Creates `_amount` token to `_to`. Must only be called by the owner (TravelAgency).
846      */
847     function mint(address _to, uint256 _amount) public onlyOwner {
848         uint256 _totalSupply = totalSupply();
849         
850         if(_totalSupply.add(_amount) > MAX_SUPPLY) {
851             _amount = MAX_SUPPLY.sub(_totalSupply);
852         }
853 
854         require(_totalSupply.add(_amount) <= MAX_SUPPLY);
855         
856         _mint(_to, _amount);
857     }
858 }
859 
860 contract StockholmAgency is Ownable {
861     using SafeMath for uint256;
862     using SafeERC20 for IERC20;
863 
864     // Info of each user.
865     struct UserInfo {
866         uint256 amount;     // How many LP tokens the user has provided.
867         uint256 rewardDebt; // Reward debt. See explanation below.
868         //
869         // We do some fancy math here. Basically, any point in time, the amount of CITYs
870         // entitled to a user but is pending to be distributed is:
871         //
872         //   pending reward = (user.amount * pool.accCityPerShare) - user.rewardDebt
873         //
874         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
875         //   1. The pool's `accCityPerShare` (and `lastRewardBlock`) gets updated.
876         //   2. User receives the pending reward sent to his/her address.
877         //   3. User's `amount` gets updated.
878         //   4. User's `rewardDebt` gets updated.
879     }
880 
881     // Info of each pool.
882     struct PoolInfo {
883         IERC20 lpToken;           // Address of LP token contract.
884         uint256 allocPoint;       // How many allocation points assigned to this pool. CITYs to distribute per block.
885         uint256 lastRewardBlock;  // Last block number that CITYs distribution occurs.
886         uint256 accCityPerShare; // Accumulated CITYs per share, times 1e12. See below.
887     }
888 
889     // The CITY TOKEN!
890     StockholmCityToken public city;
891     // Dev address.
892     address public devaddr;
893     // Block number when bonus CITY period ends.
894     uint256 public bonusEndBlock;
895     // CITY tokens created per block.
896     uint256 public cityPerBlock;
897     // Bonus muliplier for early city travels.
898     uint256 public constant BONUS_MULTIPLIER = 1; // no bonus
899 
900     // Info of each pool.
901     PoolInfo[] public poolInfo;
902     // Info of each user that stakes LP tokens.
903     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
904     // Total allocation poitns. Must be the sum of all allocation points in all pools.
905     uint256 public totalAllocPoint = 0;
906     // The block number when CITY mining starts.
907     uint256 public startBlock;
908 
909     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
910     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
911     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
912 
913     constructor(
914         StockholmCityToken _city,
915         address _devaddr,
916         uint256 _cityPerBlock,
917         uint256 _startBlock,
918         uint256 _bonusEndBlock
919     ) public {
920         city = _city;
921         devaddr = _devaddr;
922         cityPerBlock = _cityPerBlock;
923         bonusEndBlock = _bonusEndBlock;
924         startBlock = _startBlock;
925     }
926 
927     function poolLength() external view returns (uint256) {
928         return poolInfo.length;
929     }
930 
931     // Add a new lp to the pool. Can only be called by the owner.
932     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
933     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
934         if (_withUpdate) {
935             massUpdatePools();
936         }
937         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
938         totalAllocPoint = totalAllocPoint.add(_allocPoint);
939         poolInfo.push(PoolInfo({
940             lpToken: _lpToken,
941             allocPoint: _allocPoint,
942             lastRewardBlock: lastRewardBlock,
943             accCityPerShare: 0
944             }));
945     }
946 
947     // Update the given pool's CITY allocation point. Can only be called by the owner.
948     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
949         if (_withUpdate) {
950             massUpdatePools();
951         }
952         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
953         poolInfo[_pid].allocPoint = _allocPoint;
954     }
955 
956     // Return reward multiplier over the given _from to _to block.
957     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
958         if (_to <= bonusEndBlock) {
959             return _to.sub(_from).mul(BONUS_MULTIPLIER);
960         } else if (_from >= bonusEndBlock) {
961             return _to.sub(_from);
962         } else {
963             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
964                 _to.sub(bonusEndBlock)
965             );
966         }
967     }
968 
969     // View function to see pending CITYs on frontend.
970     function pendingCity(uint256 _pid, address _user) external view returns (uint256) {
971         PoolInfo storage pool = poolInfo[_pid];
972         UserInfo storage user = userInfo[_pid][_user];
973         uint256 accCityPerShare = pool.accCityPerShare;
974         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
975         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
976             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
977             uint256 cityReward = multiplier.mul(cityPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
978             accCityPerShare = accCityPerShare.add(cityReward.mul(1e12).div(lpSupply));
979         }
980         return user.amount.mul(accCityPerShare).div(1e12).sub(user.rewardDebt);
981     }
982 
983     // Update reward vairables for all pools. Be careful of gas spending!
984     function massUpdatePools() public {
985         uint256 length = poolInfo.length;
986         for (uint256 pid = 0; pid < length; ++pid) {
987             updatePool(pid);
988         }
989     }
990     // Update reward variables of the given pool to be up-to-date.
991     function mint(uint256 amount) public onlyOwner{
992         city.mint(devaddr, amount);
993     }
994     // Update reward variables of the given pool to be up-to-date.
995     function updatePool(uint256 _pid) public {
996         PoolInfo storage pool = poolInfo[_pid];
997         if (block.number <= pool.lastRewardBlock) {
998             return;
999         }
1000         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1001         if (lpSupply == 0) {
1002             pool.lastRewardBlock = block.number;
1003             return;
1004         }
1005         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1006         uint256 cityReward = multiplier.mul(cityPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1007         city.mint(devaddr, cityReward.div(20)); // 5%
1008         city.mint(address(this), cityReward);
1009         pool.accCityPerShare = pool.accCityPerShare.add(cityReward.mul(1e12).div(lpSupply));
1010         pool.lastRewardBlock = block.number;
1011     }
1012 
1013     // Deposit LP tokens to TravelAgency for CITY allocation.
1014     function deposit(uint256 _pid, uint256 _amount) public {
1015         PoolInfo storage pool = poolInfo[_pid];
1016         UserInfo storage user = userInfo[_pid][msg.sender];
1017         updatePool(_pid);
1018         if (user.amount > 0) {
1019             uint256 pending = user.amount.mul(pool.accCityPerShare).div(1e12).sub(user.rewardDebt);
1020             safeCityTransfer(msg.sender, pending);
1021         }
1022         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1023         user.amount = user.amount.add(_amount);
1024         user.rewardDebt = user.amount.mul(pool.accCityPerShare).div(1e12);
1025         emit Deposit(msg.sender, _pid, _amount);
1026     }
1027 
1028     // Withdraw LP tokens from MasterChef.
1029     function withdraw(uint256 _pid, uint256 _amount) public {
1030         PoolInfo storage pool = poolInfo[_pid];
1031         UserInfo storage user = userInfo[_pid][msg.sender];
1032         require(user.amount >= _amount, "withdraw: not good");
1033         updatePool(_pid);
1034         uint256 pending = user.amount.mul(pool.accCityPerShare).div(1e12).sub(user.rewardDebt);
1035         safeCityTransfer(msg.sender, pending);
1036         user.amount = user.amount.sub(_amount);
1037         user.rewardDebt = user.amount.mul(pool.accCityPerShare).div(1e12);
1038         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1039         emit Withdraw(msg.sender, _pid, _amount);
1040     }
1041 
1042     // Withdraw without caring about rewards. EMERGENCY ONLY.
1043     function emergencyWithdraw(uint256 _pid) public {
1044         PoolInfo storage pool = poolInfo[_pid];
1045         UserInfo storage user = userInfo[_pid][msg.sender];
1046         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1047         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1048         user.amount = 0;
1049         user.rewardDebt = 0;
1050     }
1051 
1052     // Safe city transfer function, just in case if rounding error causes pool to not have enough CITYs.
1053     function safeCityTransfer(address _to, uint256 _amount) internal {
1054         uint256 cityBal = city.balanceOf(address(this));
1055         if (_amount > cityBal) {
1056             city.transfer(_to, cityBal);
1057         } else {
1058             city.transfer(_to, _amount);
1059         }
1060     }
1061 
1062     // Update dev address by the previous dev.
1063     function dev(address _devaddr) public {
1064         require(msg.sender == devaddr, "dev: wut?");
1065         devaddr = _devaddr;
1066     }
1067 }