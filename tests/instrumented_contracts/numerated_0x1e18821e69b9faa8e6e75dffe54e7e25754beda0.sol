1 /*
2 
3 website: kimchi.finance
4 
5 ██╗  ██╗██╗███╗   ███╗ ██████╗██╗  ██╗██╗
6 ██║ ██╔╝██║████╗ ████║██╔════╝██║  ██║██║
7 █████╔╝ ██║██╔████╔██║██║     ███████║██║
8 ██╔═██╗ ██║██║╚██╔╝██║██║     ██╔══██║██║
9 ██║  ██╗██║██║ ╚═╝ ██║╚██████╗██║  ██║██║
10 ╚═╝  ╚═╝╚═╝╚═╝     ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝
11 
12 forked from SUSHI and YUNO
13 
14 */
15 
16 pragma solidity ^0.6.12;
17 /*
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with GSN meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address payable) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes memory) {
33         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
34         return msg.data;
35     }
36 }
37 
38 /**
39  * @dev Interface of the ERC20 standard as defined in the EIP.
40  */
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `sender` to `recipient` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, reverting on
128      * overflow.
129      *
130      * Counterpart to Solidity's `+` operator.
131      *
132      * Requirements:
133      *
134      * - Addition cannot overflow.
135      */
136     function add(uint256 a, uint256 b) internal pure returns (uint256) {
137         uint256 c = a + b;
138         require(c >= a, "SafeMath: addition overflow");
139 
140         return c;
141     }
142 
143     /**
144      * @dev Returns the subtraction of two unsigned integers, reverting on
145      * overflow (when the result is negative).
146      *
147      * Counterpart to Solidity's `-` operator.
148      *
149      * Requirements:
150      *
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
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
168         require(b <= a, errorMessage);
169         uint256 c = a - b;
170 
171         return c;
172     }
173 
174     /**
175      * @dev Returns the multiplication of two unsigned integers, reverting on
176      * overflow.
177      *
178      * Counterpart to Solidity's `*` operator.
179      *
180      * Requirements:
181      *
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
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b) internal pure returns (uint256) {
211         return div(a, b, "SafeMath: division by zero");
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         require(b > 0, errorMessage);
228         uint256 c = a / b;
229         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
230 
231         return c;
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
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
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
263         require(b != 0, errorMessage);
264         return a % b;
265     }
266 }
267 
268 
269 /**
270  * @dev Collection of functions related to the address type
271  */
272 library Address {
273     /**
274      * @dev Returns true if `account` is a contract.
275      *
276      * [IMPORTANT]
277      * ====
278      * It is unsafe to assume that an address for which this function returns
279      * false is an externally-owned account (EOA) and not a contract.
280      *
281      * Among others, `isContract` will return false for the following
282      * types of addresses:
283      *
284      *  - an externally-owned account
285      *  - a contract in construction
286      *  - an address where a contract will be created
287      *  - an address where a contract lived, but was destroyed
288      * ====
289      */
290     function isContract(address account) internal view returns (bool) {
291         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
292         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
293         // for accounts without code, i.e. `keccak256('')`
294         bytes32 codehash;
295         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
296         // solhint-disable-next-line no-inline-assembly
297         assembly { codehash := extcodehash(account) }
298         return (codehash != accountHash && codehash != 0x0);
299     }
300 
301     /**
302      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
303      * `recipient`, forwarding all available gas and reverting on errors.
304      *
305      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
306      * of certain opcodes, possibly making contracts go over the 2300 gas limit
307      * imposed by `transfer`, making them unable to receive funds via
308      * `transfer`. {sendValue} removes this limitation.
309      *
310      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
311      *
312      * IMPORTANT: because control is transferred to `recipient`, care must be
313      * taken to not create reentrancy vulnerabilities. Consider using
314      * {ReentrancyGuard} or the
315      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
316      */
317     function sendValue(address payable recipient, uint256 amount) internal {
318         require(address(this).balance >= amount, "Address: insufficient balance");
319 
320         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
321         (bool success, ) = recipient.call{ value: amount }("");
322         require(success, "Address: unable to send value, recipient may have reverted");
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain`call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344       return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349      * `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
354         return _functionCallWithValue(target, data, 0, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but also transferring `value` wei to `target`.
360      *
361      * Requirements:
362      *
363      * - the calling contract must have an ETH balance of at least `value`.
364      * - the called Solidity function must be `payable`.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
379         require(address(this).balance >= value, "Address: insufficient balance for call");
380         return _functionCallWithValue(target, data, value, errorMessage);
381     }
382 
383     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
384         require(isContract(target), "Address: call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394 
395                 // solhint-disable-next-line no-inline-assembly
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 /**
408  * @title SafeERC20
409  * @dev Wrappers around ERC20 operations that throw on failure (when the token
410  * contract returns false). Tokens that return no value (and instead revert or
411  * throw on failure) are also supported, non-reverting calls are assumed to be
412  * successful.
413  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
414  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
415  */
416 library SafeERC20 {
417     using SafeMath for uint256;
418     using Address for address;
419 
420     function safeTransfer(IERC20 token, address to, uint256 value) internal {
421         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
422     }
423 
424     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
425         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
426     }
427 
428     /**
429      * @dev Deprecated. This function has issues similar to the ones found in
430      * {IERC20-approve}, and its usage is discouraged.
431      *
432      * Whenever possible, use {safeIncreaseAllowance} and
433      * {safeDecreaseAllowance} instead.
434      */
435     function safeApprove(IERC20 token, address spender, uint256 value) internal {
436         // safeApprove should only be called when setting an initial allowance,
437         // or when resetting it to zero. To increase and decrease it, use
438         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
439         // solhint-disable-next-line max-line-length
440         require((value == 0) || (token.allowance(address(this), spender) == 0),
441             "SafeERC20: approve from non-zero to non-zero allowance"
442         );
443         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
444     }
445 
446     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
447         uint256 newAllowance = token.allowance(address(this), spender).add(value);
448         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
449     }
450 
451     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
452         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
453         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
454     }
455 
456     /**
457      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
458      * on the return value: the return value is optional (but if data is returned, it must not be false).
459      * @param token The token targeted by the call.
460      * @param data The call data (encoded using abi.encode or one of its variants).
461      */
462     function _callOptionalReturn(IERC20 token, bytes memory data) private {
463         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
464         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
465         // the target address contains contract code and also asserts for success in the low-level call.
466 
467         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
468         if (returndata.length > 0) { // Return data is optional
469             // solhint-disable-next-line max-line-length
470             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
471         }
472     }
473 }
474 
475 
476 
477 /**
478  * @dev Contract module which provides a basic access control mechanism, where
479  * there is an account (an owner) that can be granted exclusive access to
480  * specific functions.
481  *
482  * By default, the owner account will be the one that deploys the contract. This
483  * can later be changed with {transferOwnership}.
484  *
485  * This module is used through inheritance. It will make available the modifier
486  * `onlyOwner`, which can be applied to your functions to restrict their use to
487  * the owner.
488  */
489 contract Ownable is Context {
490     address private _owner;
491 
492     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
493 
494     /**
495      * @dev Initializes the contract setting the deployer as the initial owner.
496      */
497     constructor () internal {
498         address msgSender = _msgSender();
499         _owner = msgSender;
500         emit OwnershipTransferred(address(0), msgSender);
501     }
502 
503     /**
504      * @dev Returns the address of the current owner.
505      */
506     function owner() public view returns (address) {
507         return _owner;
508     }
509 
510     /**
511      * @dev Throws if called by any account other than the owner.
512      */
513     modifier onlyOwner() {
514         require(_owner == _msgSender(), "Ownable: caller is not the owner");
515         _;
516     }
517 
518     /**
519      * @dev Leaves the contract without owner. It will not be possible to call
520      * `onlyOwner` functions anymore. Can only be called by the current owner.
521      *
522      * NOTE: Renouncing ownership will leave the contract without an owner,
523      * thereby removing any functionality that is only available to the owner.
524      */
525     function renounceOwnership() public virtual onlyOwner {
526         emit OwnershipTransferred(_owner, address(0));
527         _owner = address(0);
528     }
529 
530     /**
531      * @dev Transfers ownership of the contract to a new account (`newOwner`).
532      * Can only be called by the current owner.
533      */
534     function transferOwnership(address newOwner) public virtual onlyOwner {
535         require(newOwner != address(0), "Ownable: new owner is the zero address");
536         emit OwnershipTransferred(_owner, newOwner);
537         _owner = newOwner;
538     }
539 }
540 
541 
542 /**
543  * @dev Implementation of the {IERC20} interface.
544  *
545  * This implementation is agnostic to the way tokens are created. This means
546  * that a supply mechanism has to be added in a derived contract using {_mint}.
547  * For a generic mechanism see {ERC20PresetMinterPauser}.
548  *
549  * TIP: For a detailed writeup see our guide
550  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
551  * to implement supply mechanisms].
552  *
553  * We have followed general OpenZeppelin guidelines: functions revert instead
554  * of returning `false` on failure. This behavior is nonetheless conventional
555  * and does not conflict with the expectations of ERC20 applications.
556  *
557  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
558  * This allows applications to reconstruct the allowance for all accounts just
559  * by listening to said events. Other implementations of the EIP may not emit
560  * these events, as it isn't required by the specification.
561  *
562  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
563  * functions have been added to mitigate the well-known issues around setting
564  * allowances. See {IERC20-approve}.
565  */
566 contract ERC20 is Context, IERC20 {
567     using SafeMath for uint256;
568     using Address for address;
569 
570     mapping (address => uint256) private _balances;
571 
572     mapping (address => mapping (address => uint256)) private _allowances;
573 
574     uint256 private _totalSupply;
575 
576     string private _name;
577     string private _symbol;
578     uint8 private _decimals;
579 
580     /**
581      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
582      * a default value of 18.
583      *
584      * To select a different value for {decimals}, use {_setupDecimals}.
585      *
586      * All three of these values are immutable: they can only be set once during
587      * construction.
588      */
589     constructor (string memory name, string memory symbol) public {
590         _name = name;
591         _symbol = symbol;
592         _decimals = 18;
593     }
594 
595     /**
596      * @dev Returns the name of the token.
597      */
598     function name() public view returns (string memory) {
599         return _name;
600     }
601 
602     /**
603      * @dev Returns the symbol of the token, usually a shorter version of the
604      * name.
605      */
606     function symbol() public view returns (string memory) {
607         return _symbol;
608     }
609 
610     /**
611      * @dev Returns the number of decimals used to get its user representation.
612      * For example, if `decimals` equals `2`, a balance of `505` tokens should
613      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
614      *
615      * Tokens usually opt for a value of 18, imitating the relationship between
616      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
617      * called.
618      *
619      * NOTE: This information is only used for _display_ purposes: it in
620      * no way affects any of the arithmetic of the contract, including
621      * {IERC20-balanceOf} and {IERC20-transfer}.
622      */
623     function decimals() public view returns (uint8) {
624         return _decimals;
625     }
626 
627     /**
628      * @dev See {IERC20-totalSupply}.
629      */
630     function totalSupply() public view override returns (uint256) {
631         return _totalSupply;
632     }
633 
634     /**
635      * @dev See {IERC20-balanceOf}.
636      */
637     function balanceOf(address account) public view override returns (uint256) {
638         return _balances[account];
639     }
640 
641     /**
642      * @dev See {IERC20-transfer}.
643      *
644      * Requirements:
645      *
646      * - `recipient` cannot be the zero address.
647      * - the caller must have a balance of at least `amount`.
648      */
649     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
650         _transfer(_msgSender(), recipient, amount);
651         return true;
652     }
653 
654     /**
655      * @dev See {IERC20-allowance}.
656      */
657     function allowance(address owner, address spender) public view virtual override returns (uint256) {
658         return _allowances[owner][spender];
659     }
660 
661     /**
662      * @dev See {IERC20-approve}.
663      *
664      * Requirements:
665      *
666      * - `spender` cannot be the zero address.
667      */
668     function approve(address spender, uint256 amount) public virtual override returns (bool) {
669         _approve(_msgSender(), spender, amount);
670         return true;
671     }
672 
673     /**
674      * @dev See {IERC20-transferFrom}.
675      *
676      * Emits an {Approval} event indicating the updated allowance. This is not
677      * required by the EIP. See the note at the beginning of {ERC20};
678      *
679      * Requirements:
680      * - `sender` and `recipient` cannot be the zero address.
681      * - `sender` must have a balance of at least `amount`.
682      * - the caller must have allowance for ``sender``'s tokens of at least
683      * `amount`.
684      */
685     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
686         _transfer(sender, recipient, amount);
687         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
688         return true;
689     }
690 
691     /**
692      * @dev Atomically increases the allowance granted to `spender` by the caller.
693      *
694      * This is an alternative to {approve} that can be used as a mitigation for
695      * problems described in {IERC20-approve}.
696      *
697      * Emits an {Approval} event indicating the updated allowance.
698      *
699      * Requirements:
700      *
701      * - `spender` cannot be the zero address.
702      */
703     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
704         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
705         return true;
706     }
707 
708     /**
709      * @dev Atomically decreases the allowance granted to `spender` by the caller.
710      *
711      * This is an alternative to {approve} that can be used as a mitigation for
712      * problems described in {IERC20-approve}.
713      *
714      * Emits an {Approval} event indicating the updated allowance.
715      *
716      * Requirements:
717      *
718      * - `spender` cannot be the zero address.
719      * - `spender` must have allowance for the caller of at least
720      * `subtractedValue`.
721      */
722     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
723         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
724         return true;
725     }
726 
727     /**
728      * @dev Moves tokens `amount` from `sender` to `recipient`.
729      *
730      * This is internal function is equivalent to {transfer}, and can be used to
731      * e.g. implement automatic token fees, slashing mechanisms, etc.
732      *
733      * Emits a {Transfer} event.
734      *
735      * Requirements:
736      *
737      * - `sender` cannot be the zero address.
738      * - `recipient` cannot be the zero address.
739      * - `sender` must have a balance of at least `amount`.
740      */
741     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
742         require(sender != address(0), "ERC20: transfer from the zero address");
743         require(recipient != address(0), "ERC20: transfer to the zero address");
744 
745         _beforeTokenTransfer(sender, recipient, amount);
746 
747         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
748         _balances[recipient] = _balances[recipient].add(amount);
749         emit Transfer(sender, recipient, amount);
750     }
751 
752     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
753      * the total supply.
754      *
755      * Emits a {Transfer} event with `from` set to the zero address.
756      *
757      * Requirements
758      *
759      * - `to` cannot be the zero address.
760      */
761     function _mint(address account, uint256 amount) internal virtual {
762         require(account != address(0), "ERC20: mint to the zero address");
763 
764         _beforeTokenTransfer(address(0), account, amount);
765 
766         _totalSupply = _totalSupply.add(amount);
767         _balances[account] = _balances[account].add(amount);
768         emit Transfer(address(0), account, amount);
769     }
770 
771     /**
772      * @dev Destroys `amount` tokens from `account`, reducing the
773      * total supply.
774      *
775      * Emits a {Transfer} event with `to` set to the zero address.
776      *
777      * Requirements
778      *
779      * - `account` cannot be the zero address.
780      * - `account` must have at least `amount` tokens.
781      */
782     function _burn(address account, uint256 amount) internal virtual {
783         require(account != address(0), "ERC20: burn from the zero address");
784 
785         _beforeTokenTransfer(account, address(0), amount);
786 
787         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
788         _totalSupply = _totalSupply.sub(amount);
789         emit Transfer(account, address(0), amount);
790     }
791 
792     /**
793      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
794      *
795      * This is internal function is equivalent to `approve`, and can be used to
796      * e.g. set automatic allowances for certain subsystems, etc.
797      *
798      * Emits an {Approval} event.
799      *
800      * Requirements:
801      *
802      * - `owner` cannot be the zero address.
803      * - `spender` cannot be the zero address.
804      */
805     function _approve(address owner, address spender, uint256 amount) internal virtual {
806         require(owner != address(0), "ERC20: approve from the zero address");
807         require(spender != address(0), "ERC20: approve to the zero address");
808 
809         _allowances[owner][spender] = amount;
810         emit Approval(owner, spender, amount);
811     }
812 
813     /**
814      * @dev Sets {decimals} to a value other than the default one of 18.
815      *
816      * WARNING: This function should only be called from the constructor. Most
817      * applications that interact with token contracts will not expect
818      * {decimals} to ever change, and may work incorrectly if it does.
819      */
820     function _setupDecimals(uint8 decimals_) internal {
821         _decimals = decimals_;
822     }
823 
824     /**
825      * @dev Hook that is called before any transfer of tokens. This includes
826      * minting and burning.
827      *
828      * Calling conditions:
829      *
830      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
831      * will be to transferred to `to`.
832      * - when `from` is zero, `amount` tokens will be minted for `to`.
833      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
834      * - `from` and `to` are never both zero.
835      *
836      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
837      */
838     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
839 }
840 
841 // KimchiToken with Governance.
842 contract KimchiToken is ERC20("KIMCHI.finance", "KIMCHI"), Ownable {
843     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
844     function mint(address _to, uint256 _amount) public onlyOwner {
845         _mint(_to, _amount);
846     }
847 }