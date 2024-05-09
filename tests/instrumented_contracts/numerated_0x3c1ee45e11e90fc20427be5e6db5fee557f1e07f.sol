1 /*
2 
3 website: sleeping.finance
4 
5 This project was based on SUSHI projects, but these are what makes SLEEP different:
6 
7 1. Extra sleep token rewards are given to users based on time staked.
8 2. The number of tokens minted by each block is halved every 100000 blocks(around 17 days).
9 
10 Unless those projects have severe vulnerabilities, this contract will be fine
11 
12 The gamification part is still in Beta so please use it under your own risk!
13 
14 
15   ██████  ██▓    ▓█████ ▓█████  ██▓███   ██▓ ███▄    █   ▄████
16 ▒██    ▒ ▓██▒    ▓█   ▀ ▓█   ▀ ▓██░  ██▒▓██▒ ██ ▀█   █  ██▒ ▀█▒
17 ░ ▓██▄   ▒██░    ▒███   ▒███   ▓██░ ██▓▒▒██▒▓██  ▀█ ██▒▒██░▄▄▄░
18   ▒   ██▒▒██░    ▒▓█  ▄ ▒▓█  ▄ ▒██▄█▓▒ ▒░██░▓██▒  ▐▌██▒░▓█  ██▓
19 ▒██████▒▒░██████▒░▒████▒░▒████▒▒██▒ ░  ░░██░▒██░   ▓██░░▒▓███▀▒
20 ▒ ▒▓▒ ▒ ░░ ▒░▓  ░░░ ▒░ ░░░ ▒░ ░▒▓▒░ ░  ░░▓  ░ ▒░   ▒ ▒  ░▒   ▒
21 ░ ░▒  ░ ░░ ░ ▒  ░ ░ ░  ░ ░ ░  ░░▒ ░      ▒ ░░ ░░   ░ ▒░  ░   ░
22 ░  ░  ░    ░ ░      ░      ░   ░░        ▒ ░   ░   ░ ░ ░ ░   ░
23       ░      ░  ░   ░  ░   ░  ░          ░           ░       ░
24 
25 
26   ######                                       # #       ######     ######        #
27              ######   ########## ##########    # #         #                     #
28 ##########       #            #          #     # #     ########## ##########    #
29      #          #            #          #      # #   #     #      #        #   #
30      #          #         # #        # #      #  #  #      #             ##   #     #
31     #      ##########      #          #      #   # #       #           ##    #########
32   ##                        #          #    #    ##         ####     ##               #
33 
34 */
35 
36 pragma solidity ^0.6.12;
37 /*
38  * @dev Provides information about the current execution context, including the
39  * sender of the transaction and its data. While these are generally available
40  * via msg.sender and msg.data, they should not be accessed in such a direct
41  * manner, since when dealing with GSN meta-transactions the account sending and
42  * paying for execution may not be the actual sender (as far as an application
43  * is concerned).
44  *
45  * This contract is only required for intermediate, library-like contracts.
46  */
47 abstract contract Context {
48     function _msgSender() internal view virtual returns (address payable) {
49         return msg.sender;
50     }
51 
52     function _msgData() internal view virtual returns (bytes memory) {
53         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
54         return msg.data;
55     }
56 }
57 
58 /**
59  * @dev Interface of the ERC20 standard as defined in the EIP.
60  */
61 interface IERC20 {
62     /**
63      * @dev Returns the amount of tokens in existence.
64      */
65     function totalSupply() external view returns (uint256);
66 
67     /**
68      * @dev Returns the amount of tokens owned by `account`.
69      */
70     function balanceOf(address account) external view returns (uint256);
71 
72     /**
73      * @dev Moves `amount` tokens from the caller's account to `recipient`.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transfer(address recipient, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Returns the remaining number of tokens that `spender` will be
83      * allowed to spend on behalf of `owner` through {transferFrom}. This is
84      * zero by default.
85      *
86      * This value changes when {approve} or {transferFrom} are called.
87      */
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90     /**
91      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * IMPORTANT: Beware that changing an allowance with this method brings the risk
96      * that someone may use both the old and the new allowance by unfortunate
97      * transaction ordering. One possible solution to mitigate this race
98      * condition is to first reduce the spender's allowance to 0 and set the
99      * desired value afterwards:
100      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101      *
102      * Emits an {Approval} event.
103      */
104     function approve(address spender, uint256 amount) external returns (bool);
105 
106     /**
107      * @dev Moves `amount` tokens from `sender` to `recipient` using the
108      * allowance mechanism. `amount` is then deducted from the caller's
109      * allowance.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
116 
117     /**
118      * @dev Emitted when `value` tokens are moved from one account (`from`) to
119      * another (`to`).
120      *
121      * Note that `value` may be zero.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     /**
126      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
127      * a call to {approve}. `value` is the new allowance.
128      */
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 /**
133  * @dev Wrappers over Solidity's arithmetic operations with added overflow
134  * checks.
135  *
136  * Arithmetic operations in Solidity wrap on overflow. This can easily result
137  * in bugs, because programmers usually assume that an overflow raises an
138  * error, which is the standard behavior in high level programming languages.
139  * `SafeMath` restores this intuition by reverting the transaction when an
140  * operation overflows.
141  *
142  * Using this library instead of the unchecked operations eliminates an entire
143  * class of bugs, so it's recommended to use it always.
144  */
145 library SafeMath {
146     /**
147      * @dev Returns the addition of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `+` operator.
151      *
152      * Requirements:
153      *
154      * - Addition cannot overflow.
155      */
156     function add(uint256 a, uint256 b) internal pure returns (uint256) {
157         uint256 c = a + b;
158         require(c >= a, "SafeMath: addition overflow");
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
174         return sub(a, b, "SafeMath: subtraction overflow");
175     }
176 
177     /**
178      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
179      * overflow (when the result is negative).
180      *
181      * Counterpart to Solidity's `-` operator.
182      *
183      * Requirements:
184      *
185      * - Subtraction cannot overflow.
186      */
187     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188         require(b <= a, errorMessage);
189         uint256 c = a - b;
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the multiplication of two unsigned integers, reverting on
196      * overflow.
197      *
198      * Counterpart to Solidity's `*` operator.
199      *
200      * Requirements:
201      *
202      * - Multiplication cannot overflow.
203      */
204     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
205         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
206         // benefit is lost if 'b' is also tested.
207         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
208         if (a == 0) {
209             return 0;
210         }
211 
212         uint256 c = a * b;
213         require(c / a == b, "SafeMath: multiplication overflow");
214 
215         return c;
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers. Reverts on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function div(uint256 a, uint256 b) internal pure returns (uint256) {
231         return div(a, b, "SafeMath: division by zero");
232     }
233 
234     /**
235      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
236      * division by zero. The result is rounded towards zero.
237      *
238      * Counterpart to Solidity's `/` operator. Note: this function uses a
239      * `revert` opcode (which leaves remaining gas untouched) while Solidity
240      * uses an invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247         require(b > 0, errorMessage);
248         uint256 c = a / b;
249         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
250 
251         return c;
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
267         return mod(a, b, "SafeMath: modulo by zero");
268     }
269 
270     /**
271      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
272      * Reverts with custom message when dividing by zero.
273      *
274      * Counterpart to Solidity's `%` operator. This function uses a `revert`
275      * opcode (which leaves remaining gas untouched) while Solidity uses an
276      * invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
283         require(b != 0, errorMessage);
284         return a % b;
285     }
286 }
287 
288 
289 /**
290  * @dev Collection of functions related to the address type
291  */
292 library Address {
293     /**
294      * @dev Returns true if `account` is a contract.
295      *
296      * [IMPORTANT]
297      * ====
298      * It is unsafe to assume that an address for which this function returns
299      * false is an externally-owned account (EOA) and not a contract.
300      *
301      * Among others, `isContract` will return false for the following
302      * types of addresses:
303      *
304      *  - an externally-owned account
305      *  - a contract in construction
306      *  - an address where a contract will be created
307      *  - an address where a contract lived, but was destroyed
308      * ====
309      */
310     function isContract(address account) internal view returns (bool) {
311         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
312         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
313         // for accounts without code, i.e. `keccak256('')`
314         bytes32 codehash;
315         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
316         // solhint-disable-next-line no-inline-assembly
317         assembly { codehash := extcodehash(account) }
318         return (codehash != accountHash && codehash != 0x0);
319     }
320 
321     /**
322      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
323      * `recipient`, forwarding all available gas and reverting on errors.
324      *
325      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
326      * of certain opcodes, possibly making contracts go over the 2300 gas limit
327      * imposed by `transfer`, making them unable to receive funds via
328      * `transfer`. {sendValue} removes this limitation.
329      *
330      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
331      *
332      * IMPORTANT: because control is transferred to `recipient`, care must be
333      * taken to not create reentrancy vulnerabilities. Consider using
334      * {ReentrancyGuard} or the
335      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
336      */
337     function sendValue(address payable recipient, uint256 amount) internal {
338         require(address(this).balance >= amount, "Address: insufficient balance");
339 
340         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
341         (bool success, ) = recipient.call{ value: amount }("");
342         require(success, "Address: unable to send value, recipient may have reverted");
343     }
344 
345     /**
346      * @dev Performs a Solidity function call using a low level `call`. A
347      * plain`call` is an unsafe replacement for a function call: use this
348      * function instead.
349      *
350      * If `target` reverts with a revert reason, it is bubbled up by this
351      * function (like regular Solidity function calls).
352      *
353      * Returns the raw returned data. To convert to the expected return value,
354      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
355      *
356      * Requirements:
357      *
358      * - `target` must be a contract.
359      * - calling `target` with `data` must not revert.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
364         return functionCall(target, data, "Address: low-level call failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
369      * `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
374         return _functionCallWithValue(target, data, 0, errorMessage);
375     }
376 
377     /**
378      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
379      * but also transferring `value` wei to `target`.
380      *
381      * Requirements:
382      *
383      * - the calling contract must have an ETH balance of at least `value`.
384      * - the called Solidity function must be `payable`.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
389         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
390     }
391 
392     /**
393      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
394      * with `errorMessage` as a fallback revert reason when `target` reverts.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
399         require(address(this).balance >= value, "Address: insufficient balance for call");
400         return _functionCallWithValue(target, data, value, errorMessage);
401     }
402 
403     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
404         require(isContract(target), "Address: call to non-contract");
405 
406         // solhint-disable-next-line avoid-low-level-calls
407         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
408         if (success) {
409             return returndata;
410         } else {
411             // Look for revert reason and bubble it up if present
412             if (returndata.length > 0) {
413                 // The easiest way to bubble the revert reason is using memory via assembly
414 
415                 // solhint-disable-next-line no-inline-assembly
416                 assembly {
417                     let returndata_size := mload(returndata)
418                     revert(add(32, returndata), returndata_size)
419                 }
420             } else {
421                 revert(errorMessage);
422             }
423         }
424     }
425 }
426 
427 /**
428  * @title SafeERC20
429  * @dev Wrappers around ERC20 operations that throw on failure (when the token
430  * contract returns false). Tokens that return no value (and instead revert or
431  * throw on failure) are also supported, non-reverting calls are assumed to be
432  * successful.
433  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
434  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
435  */
436 library SafeERC20 {
437     using SafeMath for uint256;
438     using Address for address;
439 
440     function safeTransfer(IERC20 token, address to, uint256 value) internal {
441         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
442     }
443 
444     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
445         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
446     }
447 
448     /**
449      * @dev Deprecated. This function has issues similar to the ones found in
450      * {IERC20-approve}, and its usage is discouraged.
451      *
452      * Whenever possible, use {safeIncreaseAllowance} and
453      * {safeDecreaseAllowance} instead.
454      */
455     function safeApprove(IERC20 token, address spender, uint256 value) internal {
456         // safeApprove should only be called when setting an initial allowance,
457         // or when resetting it to zero. To increase and decrease it, use
458         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
459         // solhint-disable-next-line max-line-length
460         require((value == 0) || (token.allowance(address(this), spender) == 0),
461             "SafeERC20: approve from non-zero to non-zero allowance"
462         );
463         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
464     }
465 
466     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
467         uint256 newAllowance = token.allowance(address(this), spender).add(value);
468         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
469     }
470 
471     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
472         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
473         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
474     }
475 
476     /**
477      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
478      * on the return value: the return value is optional (but if data is returned, it must not be false).
479      * @param token The token targeted by the call.
480      * @param data The call data (encoded using abi.encode or one of its variants).
481      */
482     function _callOptionalReturn(IERC20 token, bytes memory data) private {
483         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
484         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
485         // the target address contains contract code and also asserts for success in the low-level call.
486 
487         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
488         if (returndata.length > 0) { // Return data is optional
489             // solhint-disable-next-line max-line-length
490             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
491         }
492     }
493 }
494 
495 
496 
497 /**
498  * @dev Contract module which provides a basic access control mechanism, where
499  * there is an account (an owner) that can be granted exclusive access to
500  * specific functions.
501  *
502  * By default, the owner account will be the one that deploys the contract. This
503  * can later be changed with {transferOwnership}.
504  *
505  * This module is used through inheritance. It will make available the modifier
506  * `onlyOwner`, which can be applied to your functions to restrict their use to
507  * the owner.
508  */
509 contract Ownable is Context {
510     address private _owner;
511 
512     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
513 
514     /**
515      * @dev Initializes the contract setting the deployer as the initial owner.
516      */
517     constructor () internal {
518         address msgSender = _msgSender();
519         _owner = msgSender;
520         emit OwnershipTransferred(address(0), msgSender);
521     }
522 
523     /**
524      * @dev Returns the address of the current owner.
525      */
526     function owner() public view returns (address) {
527         return _owner;
528     }
529 
530     /**
531      * @dev Throws if called by any account other than the owner.
532      */
533     modifier onlyOwner() {
534         require(_owner == _msgSender(), "Ownable: caller is not the owner");
535         _;
536     }
537 
538     /**
539      * @dev Leaves the contract without owner. It will not be possible to call
540      * `onlyOwner` functions anymore. Can only be called by the current owner.
541      *
542      * NOTE: Renouncing ownership will leave the contract without an owner,
543      * thereby removing any functionality that is only available to the owner.
544      */
545     function renounceOwnership() public virtual onlyOwner {
546         emit OwnershipTransferred(_owner, address(0));
547         _owner = address(0);
548     }
549 
550     /**
551      * @dev Transfers ownership of the contract to a new account (`newOwner`).
552      * Can only be called by the current owner.
553      */
554     function transferOwnership(address newOwner) public virtual onlyOwner {
555         require(newOwner != address(0), "Ownable: new owner is the zero address");
556         emit OwnershipTransferred(_owner, newOwner);
557         _owner = newOwner;
558     }
559 }
560 
561 
562 /**
563  * @dev Implementation of the {IERC20} interface.
564  *
565  * This implementation is agnostic to the way tokens are created. This means
566  * that a supply mechanism has to be added in a derived contract using {_mint}.
567  * For a generic mechanism see {ERC20PresetMinterPauser}.
568  *
569  * TIP: For a detailed writeup see our guide
570  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
571  * to implement supply mechanisms].
572  *
573  * We have followed general OpenZeppelin guidelines: functions revert instead
574  * of returning `false` on failure. This behavior is nonetheless conventional
575  * and does not conflict with the expectations of ERC20 applications.
576  *
577  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
578  * This allows applications to reconstruct the allowance for all accounts just
579  * by listening to said events. Other implementations of the EIP may not emit
580  * these events, as it isn't required by the specification.
581  *
582  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
583  * functions have been added to mitigate the well-known issues around setting
584  * allowances. See {IERC20-approve}.
585  */
586 contract ERC20 is Context, IERC20 {
587     using SafeMath for uint256;
588     using Address for address;
589 
590     mapping (address => uint256) private _balances;
591 
592     mapping (address => mapping (address => uint256)) private _allowances;
593 
594     uint256 private _totalSupply;
595 
596     string private _name;
597     string private _symbol;
598     uint8 private _decimals;
599 
600     /**
601      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
602      * a default value of 18.
603      *
604      * To select a different value for {decimals}, use {_setupDecimals}.
605      *
606      * All three of these values are immutable: they can only be set once during
607      * construction.
608      */
609     constructor (string memory name, string memory symbol) public {
610         _name = name;
611         _symbol = symbol;
612         _decimals = 18;
613     }
614 
615     /**
616      * @dev Returns the name of the token.
617      */
618     function name() public view returns (string memory) {
619         return _name;
620     }
621 
622     /**
623      * @dev Returns the symbol of the token, usually a shorter version of the
624      * name.
625      */
626     function symbol() public view returns (string memory) {
627         return _symbol;
628     }
629 
630     /**
631      * @dev Returns the number of decimals used to get its user representation.
632      * For example, if `decimals` equals `2`, a balance of `505` tokens should
633      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
634      *
635      * Tokens usually opt for a value of 18, imitating the relationship between
636      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
637      * called.
638      *
639      * NOTE: This information is only used for _display_ purposes: it in
640      * no way affects any of the arithmetic of the contract, including
641      * {IERC20-balanceOf} and {IERC20-transfer}.
642      */
643     function decimals() public view returns (uint8) {
644         return _decimals;
645     }
646 
647     /**
648      * @dev See {IERC20-totalSupply}.
649      */
650     function totalSupply() public view override returns (uint256) {
651         return _totalSupply;
652     }
653 
654     /**
655      * @dev See {IERC20-balanceOf}.
656      */
657     function balanceOf(address account) public view override returns (uint256) {
658         return _balances[account];
659     }
660 
661     /**
662      * @dev See {IERC20-transfer}.
663      *
664      * Requirements:
665      *
666      * - `recipient` cannot be the zero address.
667      * - the caller must have a balance of at least `amount`.
668      */
669     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
670         _transfer(_msgSender(), recipient, amount);
671         return true;
672     }
673 
674     /**
675      * @dev See {IERC20-allowance}.
676      */
677     function allowance(address owner, address spender) public view virtual override returns (uint256) {
678         return _allowances[owner][spender];
679     }
680 
681     /**
682      * @dev See {IERC20-approve}.
683      *
684      * Requirements:
685      *
686      * - `spender` cannot be the zero address.
687      */
688     function approve(address spender, uint256 amount) public virtual override returns (bool) {
689         _approve(_msgSender(), spender, amount);
690         return true;
691     }
692 
693     /**
694      * @dev See {IERC20-transferFrom}.
695      *
696      * Emits an {Approval} event indicating the updated allowance. This is not
697      * required by the EIP. See the note at the beginning of {ERC20};
698      *
699      * Requirements:
700      * - `sender` and `recipient` cannot be the zero address.
701      * - `sender` must have a balance of at least `amount`.
702      * - the caller must have allowance for ``sender``'s tokens of at least
703      * `amount`.
704      */
705     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
706         _transfer(sender, recipient, amount);
707         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
708         return true;
709     }
710 
711     /**
712      * @dev Atomically increases the allowance granted to `spender` by the caller.
713      *
714      * This is an alternative to {approve} that can be used as a mitigation for
715      * problems described in {IERC20-approve}.
716      *
717      * Emits an {Approval} event indicating the updated allowance.
718      *
719      * Requirements:
720      *
721      * - `spender` cannot be the zero address.
722      */
723     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
724         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
725         return true;
726     }
727 
728     /**
729      * @dev Atomically decreases the allowance granted to `spender` by the caller.
730      *
731      * This is an alternative to {approve} that can be used as a mitigation for
732      * problems described in {IERC20-approve}.
733      *
734      * Emits an {Approval} event indicating the updated allowance.
735      *
736      * Requirements:
737      *
738      * - `spender` cannot be the zero address.
739      * - `spender` must have allowance for the caller of at least
740      * `subtractedValue`.
741      */
742     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
743         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
744         return true;
745     }
746 
747     /**
748      * @dev Moves tokens `amount` from `sender` to `recipient`.
749      *
750      * This is internal function is equivalent to {transfer}, and can be used to
751      * e.g. implement automatic token fees, slashing mechanisms, etc.
752      *
753      * Emits a {Transfer} event.
754      *
755      * Requirements:
756      *
757      * - `sender` cannot be the zero address.
758      * - `recipient` cannot be the zero address.
759      * - `sender` must have a balance of at least `amount`.
760      */
761     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
762         require(sender != address(0), "ERC20: transfer from the zero address");
763         require(recipient != address(0), "ERC20: transfer to the zero address");
764 
765         _beforeTokenTransfer(sender, recipient, amount);
766 
767         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
768         _balances[recipient] = _balances[recipient].add(amount);
769         emit Transfer(sender, recipient, amount);
770     }
771 
772     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
773      * the total supply.
774      *
775      * Emits a {Transfer} event with `from` set to the zero address.
776      *
777      * Requirements
778      *
779      * - `to` cannot be the zero address.
780      */
781     function _mint(address account, uint256 amount) internal virtual {
782         require(account != address(0), "ERC20: mint to the zero address");
783 
784         _beforeTokenTransfer(address(0), account, amount);
785 
786         _totalSupply = _totalSupply.add(amount);
787         _balances[account] = _balances[account].add(amount);
788         emit Transfer(address(0), account, amount);
789     }
790 
791     /**
792      * @dev Destroys `amount` tokens from `account`, reducing the
793      * total supply.
794      *
795      * Emits a {Transfer} event with `to` set to the zero address.
796      *
797      * Requirements
798      *
799      * - `account` cannot be the zero address.
800      * - `account` must have at least `amount` tokens.
801      */
802     function _burn(address account, uint256 amount) internal virtual {
803         require(account != address(0), "ERC20: burn from the zero address");
804 
805         _beforeTokenTransfer(account, address(0), amount);
806 
807         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
808         _totalSupply = _totalSupply.sub(amount);
809         emit Transfer(account, address(0), amount);
810     }
811 
812     /**
813      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
814      *
815      * This is internal function is equivalent to `approve`, and can be used to
816      * e.g. set automatic allowances for certain subsystems, etc.
817      *
818      * Emits an {Approval} event.
819      *
820      * Requirements:
821      *
822      * - `owner` cannot be the zero address.
823      * - `spender` cannot be the zero address.
824      */
825     function _approve(address owner, address spender, uint256 amount) internal virtual {
826         require(owner != address(0), "ERC20: approve from the zero address");
827         require(spender != address(0), "ERC20: approve to the zero address");
828 
829         _allowances[owner][spender] = amount;
830         emit Approval(owner, spender, amount);
831     }
832 
833     /**
834      * @dev Sets {decimals} to a value other than the default one of 18.
835      *
836      * WARNING: This function should only be called from the constructor. Most
837      * applications that interact with token contracts will not expect
838      * {decimals} to ever change, and may work incorrectly if it does.
839      */
840     function _setupDecimals(uint8 decimals_) internal {
841         _decimals = decimals_;
842     }
843 
844     /**
845      * @dev Hook that is called before any transfer of tokens. This includes
846      * minting and burning.
847      *
848      * Calling conditions:
849      *
850      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
851      * will be to transferred to `to`.
852      * - when `from` is zero, `amount` tokens will be minted for `to`.
853      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
854      * - `from` and `to` are never both zero.
855      *
856      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
857      */
858     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
859 }
860 
861 // SleepToken with Governance.
862 contract SleepToken is ERC20("sleeping.finance", "SLEEP"), Ownable {
863     using SafeERC20 for ERC20;
864     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterBedroom).
865     function mint(address _to, uint256 _amount) public onlyOwner {
866         _mint(_to, _amount);
867         _moveDelegates(address(0), _delegates[_to], _amount);
868     }
869 
870     /// @notice A record of each accounts delegate
871     mapping (address => address) internal _delegates;
872 
873     /// @notice A checkpoint for marking number of votes from a given block
874     struct Checkpoint {
875         uint32 fromBlock;
876         uint256 votes;
877     }
878 
879     /// @notice A record of votes checkpoints for each account, by index
880     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
881 
882     /// @notice The number of checkpoints for each account
883     mapping (address => uint32) public numCheckpoints;
884 
885     /// @notice The EIP-712 typehash for the contract's domain
886     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
887 
888     /// @notice The EIP-712 typehash for the delegation struct used by the contract
889     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
890 
891     /// @notice A record of states for signing / validating signatures
892     mapping (address => uint) public nonces;
893 
894     /// @notice An event thats emitted when an account changes its delegate
895     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
896 
897     /// @notice An event thats emitted when a delegate account's vote balance changes
898     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
899 
900     /**
901      * @notice Delegate votes from `msg.sender` to `delegatee`
902      * @param delegator The address to get delegatee for
903      */
904     function delegates(address delegator)
905     external
906     view
907     returns (address)
908     {
909         return _delegates[delegator];
910     }
911 
912     /**
913      * @notice Delegate votes from `msg.sender` to `delegatee`
914      * @param delegatee The address to delegate votes to
915      */
916     function delegate(address delegatee) external {
917         return _delegate(msg.sender, delegatee);
918     }
919 
920     /**
921      * @notice Delegates votes from signatory to `delegatee`
922      * @param delegatee The address to delegate votes to
923      * @param nonce The contract state required to match the signature
924      * @param expiry The time at which to expire the signature
925      * @param v The recovery byte of the signature
926      * @param r Half of the ECDSA signature pair
927      * @param s Half of the ECDSA signature pair
928      */
929     function delegateBySig(
930         address delegatee,
931         uint nonce,
932         uint expiry,
933         uint8 v,
934         bytes32 r,
935         bytes32 s
936     )
937     external
938     {
939         bytes32 domainSeparator = keccak256(
940             abi.encode(
941                 DOMAIN_TYPEHASH,
942                 keccak256(bytes(name())),
943                 getChainId(),
944                 address(this)
945             )
946         );
947 
948         bytes32 structHash = keccak256(
949             abi.encode(
950                 DELEGATION_TYPEHASH,
951                 delegatee,
952                 nonce,
953                 expiry
954             )
955         );
956 
957         bytes32 digest = keccak256(
958             abi.encodePacked(
959                 "\x19\x01",
960                 domainSeparator,
961                 structHash
962             )
963         );
964 
965         address signatory = ecrecover(digest, v, r, s);
966         require(signatory != address(0), "SLEEP::delegateBySig: invalid signature");
967         require(nonce == nonces[signatory]++, "SLEEP::delegateBySig: invalid nonce");
968         require(now <= expiry, "SLEEP::delegateBySig: signature expired");
969         return _delegate(signatory, delegatee);
970     }
971 
972     /**
973      * @notice Gets the current votes balance for `account`
974      * @param account The address to get votes balance
975      * @return The number of current votes for `account`
976      */
977     function getCurrentVotes(address account)
978     external
979     view
980     returns (uint256)
981     {
982         uint32 nCheckpoints = numCheckpoints[account];
983         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
984     }
985 
986     /**
987      * @notice Determine the prior number of votes for an account as of a block number
988      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
989      * @param account The address of the account to check
990      * @param blockNumber The block number to get the vote balance at
991      * @return The number of votes the account had as of the given block
992      */
993     function getPriorVotes(address account, uint blockNumber)
994     external
995     view
996     returns (uint256)
997     {
998         require(blockNumber < block.number, "SLEEP::getPriorVotes: not yet determined");
999 
1000         uint32 nCheckpoints = numCheckpoints[account];
1001         if (nCheckpoints == 0) {
1002             return 0;
1003         }
1004 
1005         // First check most recent balance
1006         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1007             return checkpoints[account][nCheckpoints - 1].votes;
1008         }
1009 
1010         // Next check implicit zero balance
1011         if (checkpoints[account][0].fromBlock > blockNumber) {
1012             return 0;
1013         }
1014 
1015         uint32 lower = 0;
1016         uint32 upper = nCheckpoints - 1;
1017         while (upper > lower) {
1018             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1019             Checkpoint memory cp = checkpoints[account][center];
1020             if (cp.fromBlock == blockNumber) {
1021                 return cp.votes;
1022             } else if (cp.fromBlock < blockNumber) {
1023                 lower = center;
1024             } else {
1025                 upper = center - 1;
1026             }
1027         }
1028         return checkpoints[account][lower].votes;
1029     }
1030 
1031     function _delegate(address delegator, address delegatee)
1032     internal
1033     {
1034         address currentDelegate = _delegates[delegator];
1035         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying SLEEPs (not scaled);
1036         _delegates[delegator] = delegatee;
1037 
1038         emit DelegateChanged(delegator, currentDelegate, delegatee);
1039 
1040         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1041     }
1042 
1043     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1044         if (srcRep != dstRep && amount > 0) {
1045             if (srcRep != address(0)) {
1046                 // decrease old representative
1047                 uint32 srcRepNum = numCheckpoints[srcRep];
1048                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1049                 uint256 srcRepNew = srcRepOld.sub(amount);
1050                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1051             }
1052 
1053             if (dstRep != address(0)) {
1054                 // increase new representative
1055                 uint32 dstRepNum = numCheckpoints[dstRep];
1056                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1057                 uint256 dstRepNew = dstRepOld.add(amount);
1058                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1059             }
1060         }
1061     }
1062 
1063     function _writeCheckpoint(
1064         address delegatee,
1065         uint32 nCheckpoints,
1066         uint256 oldVotes,
1067         uint256 newVotes
1068     )
1069     internal
1070     {
1071         uint32 blockNumber = safe32(block.number, "SLEEP::_writeCheckpoint: block number exceeds 32 bits");
1072 
1073         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1074             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1075         } else {
1076             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1077             numCheckpoints[delegatee] = nCheckpoints + 1;
1078         }
1079 
1080         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1081     }
1082 
1083     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1084         require(n < 2**32, errorMessage);
1085         return uint32(n);
1086     }
1087 
1088     function getChainId() internal pure returns (uint) {
1089         uint256 chainId;
1090         assembly { chainId := chainid() }
1091         return chainId;
1092     }
1093 }
1094 
1095 interface IMigratorChef {
1096     function migrate(IERC20 token) external returns (IERC20);
1097 }
1098 
1099 contract SleepBedroom is Ownable {
1100     using SafeMath for uint256;
1101     using SafeERC20 for IERC20;
1102 
1103     // Info of each user.
1104     struct UserInfo {
1105         uint256 amount;     // How many LP tokens the user has provided.
1106         uint256 rewardDebt; // Reward debt. See explanation below.
1107         uint256 startStakeTime; // Average start stake time of the staked tokens in pool
1108     }
1109 
1110     // Info of each pool.
1111     struct PoolInfo {
1112         IERC20 lpToken;           // Address of LP token contract.
1113         uint256 allocPoint;       // How many allocation points assigned to this pool. SLEEPs to distribute per block.
1114         uint256 lastRewardBlock;  // Last block number that SLEEPs distribution occurs.
1115         uint256 accSleepPerShare; // Accumulated SLEEPs per share, times 1e12. See below.
1116     }
1117 
1118     // The SLEEP TOKEN!
1119     SleepToken public sleep;
1120     // Dev address.
1121     address public devaddr;
1122     // Block number when bonus SLEEP period ends.
1123     uint256 public bonusEndBlock;
1124     // SLEEP tokens created per block.
1125     uint256 public sleepPerBlock;
1126     // Bonus muliplier for early sleep makers.
1127     uint256 public constant BONUS_MULTIPLIER = 10; // 3 times of bonus
1128     // Extra reward increases for maximum 100000 blocks(around 17 days).
1129     uint256 public constant MAX_EXTRA_REWARD_BLOCK_INTERVAL = 100000;
1130 
1131     // Info of each pool.
1132     PoolInfo[] public poolInfo;
1133     // Info of each user that stakes LP tokens.
1134     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1135     // Total allocation points. Must be the sum of all allocation points in all pools.
1136     uint256 public totalAllocPoint = 0;
1137     // The block number when SLEEP mining starts.
1138     uint256 public startBlock;
1139     // Extra sleep token reward per block for stake time based calculation
1140     uint256 public extraSleepPerBlock;
1141     // Maximum time based extra reward per MAX_EXTRA_REWARD_BLOCK_INTERVAL block for each user;
1142     uint256 public maxExtraReward;
1143     // The migrator contract. Can only be set through governance (owner).
1144     IMigratorChef public migrator;
1145 
1146     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1147     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1148     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1149 
1150     constructor(
1151         SleepToken _sleep,
1152         address _devaddr,
1153         uint256 _sleepPerBlock,
1154         uint256 _startBlock,
1155         uint256 _bonusEndBlock,
1156         uint256 _extraSleepPerBlock,
1157         uint256 _maxExtraReward
1158     ) public {
1159         sleep = _sleep;
1160         devaddr = _devaddr;
1161         sleepPerBlock = _sleepPerBlock;
1162         bonusEndBlock = _bonusEndBlock;
1163         startBlock = _startBlock;
1164         extraSleepPerBlock = _extraSleepPerBlock;
1165         maxExtraReward = _maxExtraReward;
1166     }
1167 
1168     function poolLength() external view returns (uint256) {
1169         return poolInfo.length;
1170     }
1171 
1172     function setMaxExtraReward(uint256 _maxExtraReward) external onlyOwner() {
1173         maxExtraReward = _maxExtraReward;
1174     }
1175 
1176     // Add a new lp to the pool. Can only be called by the owner.
1177     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
1178     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
1179         if (_withUpdate) {
1180             massUpdatePools();
1181         }
1182         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
1183         totalAllocPoint = totalAllocPoint.add(_allocPoint);
1184         poolInfo.push(PoolInfo({
1185         lpToken: _lpToken,
1186         allocPoint: _allocPoint,
1187         lastRewardBlock: lastRewardBlock,
1188         accSleepPerShare: 0
1189         }));
1190     }
1191 
1192     // Update the given pool's SLEEP allocation point. Can only be called by the owner.
1193     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
1194         if (_withUpdate) {
1195             massUpdatePools();
1196         }
1197         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
1198         poolInfo[_pid].allocPoint = _allocPoint;
1199     }
1200 
1201 
1202 
1203     // Return reward multiplier over the given _from to _to block.
1204     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
1205         if (_to <= bonusEndBlock) {
1206             return _to.sub(_from).mul(BONUS_MULTIPLIER);
1207         } else if (_from >= bonusEndBlock) {
1208             return _to.sub(_from);
1209         } else {
1210             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
1211                 _to.sub(bonusEndBlock)
1212             );
1213         }
1214     }
1215 
1216     // View function to see pending SLEEPs on frontend.
1217     function pendingSleep(uint256 _pid, address _user) external view returns (uint256) {
1218         PoolInfo storage pool = poolInfo[_pid];
1219         UserInfo storage user = userInfo[_pid][_user];
1220         uint256 accSleepPerShare = pool.accSleepPerShare;
1221         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1222         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1223             uint256 multiplier = (getMultiplier(pool.lastRewardBlock, block.number));
1224             uint256 sleepReward = multiplier.mul(sleepPerBlock).mul(pool.allocPoint).div(totalAllocPoint).div(getHalvingFactor());
1225             accSleepPerShare = accSleepPerShare.add(sleepReward.mul(1e12).div(lpSupply));
1226         }
1227         return user.amount.mul(accSleepPerShare).div(1e12).sub(user.rewardDebt);
1228     }
1229 
1230     // Update reward variables for all pools. Be careful of gas spending!
1231     function massUpdatePools() public {
1232         uint256 length = poolInfo.length;
1233         for (uint256 pid = 0; pid < length; ++pid) {
1234             updatePool(pid);
1235         }
1236     }
1237 
1238 
1239     // Update reward variables of the given pool to be up-to-date.
1240     function updatePool(uint256 _pid) public {
1241         PoolInfo storage pool = poolInfo[_pid];
1242         if (block.number <= pool.lastRewardBlock) {
1243             return;
1244         }
1245         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1246         if (lpSupply == 0) {
1247             pool.lastRewardBlock = block.number;
1248             return;
1249         }
1250         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1251         uint256 sleepReward = multiplier.mul(sleepPerBlock).mul(pool.allocPoint).div(totalAllocPoint).div(getHalvingFactor());
1252         sleep.mint(devaddr, sleepReward.div(10));
1253         sleep.mint(address(this), sleepReward);
1254         pool.accSleepPerShare = pool.accSleepPerShare.add(sleepReward.mul(1e12).div(lpSupply));
1255         pool.lastRewardBlock = block.number;
1256     }
1257 
1258     // Deposit LP tokens to MasterBedroom for SLEEP allocation.
1259     function deposit(uint256 _pid, uint256 _amount) public {
1260         PoolInfo storage pool = poolInfo[_pid];
1261         UserInfo storage user = userInfo[_pid][msg.sender];
1262         updatePool(_pid);
1263         if (user.amount > 0) {
1264             uint256 pending = user.amount.mul(pool.accSleepPerShare).div(1e12).sub(user.rewardDebt);
1265             safeSleepTransfer(msg.sender, pending);
1266         }
1267         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1268         user.startStakeTime = ((user.startStakeTime.mul(user.amount)).add(_amount.mul(block.number))).div(user.amount.add(_amount));
1269         user.amount = user.amount.add(_amount);
1270         user.rewardDebt = user.amount.mul(pool.accSleepPerShare).div(1e12);
1271         emit Deposit(msg.sender, _pid, _amount);
1272     }
1273 
1274     // Withdraw LP tokens from MasterBedroom.
1275     function withdraw(uint256 _pid, uint256 _amount) public {
1276         PoolInfo storage pool = poolInfo[_pid];
1277         UserInfo storage user = userInfo[_pid][msg.sender];
1278         require(user.amount >= _amount, "withdraw: not good");
1279         updatePool(_pid);
1280         uint256 pending = user.amount.mul(pool.accSleepPerShare).div(1e12).sub(user.rewardDebt);
1281         safeSleepTransfer(msg.sender, pending);
1282         uint256 extraReward = getExtraReward(_pid, user.startStakeTime, block.number, _amount).div(getHalvingFactor());
1283         sleep.mint(msg.sender, extraReward); // stake time based reward
1284         sleep.mint(devaddr, extraReward.div(10));
1285         user.amount = user.amount.sub(_amount);
1286         user.rewardDebt = user.amount.mul(pool.accSleepPerShare).div(1e12);
1287         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1288 
1289         emit Withdraw(msg.sender, _pid, _amount);
1290     }
1291 
1292     function getHalvingFactor() public view returns (uint256) {
1293         return 2 ** ((block.number - startBlock) / 100000); // halve per 100000 blocks
1294     }
1295 
1296     function getExtraRewardForUser(uint256 _pid, address _userAddress) public view returns(uint256) {
1297         UserInfo storage user = userInfo[_pid][_userAddress];
1298         return getExtraReward(_pid, user.startStakeTime, block.number, user.amount);
1299     }
1300 
1301     // get stake time based extra reward
1302     function getExtraReward(uint256 _pid, uint256 startStakeBlock, uint256 endBlock, uint256 numLPTokens) public view returns(uint256){
1303         if(startStakeBlock > endBlock) {
1304             return 0;
1305         }
1306         PoolInfo storage pool = poolInfo[_pid];
1307         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1308         if (lpSupply == 0) {
1309             return 0;
1310         }
1311         uint256 extraRewardBlockInterval = endBlock.sub(startStakeBlock) > MAX_EXTRA_REWARD_BLOCK_INTERVAL ? MAX_EXTRA_REWARD_BLOCK_INTERVAL : endBlock.sub(startStakeBlock);
1312         uint256 extraReward = extraRewardBlockInterval.mul(extraRewardBlockInterval).mul(extraSleepPerBlock).div(poolInfo.length).mul(numLPTokens).div(lpSupply).div(10000).div(getHalvingFactor());
1313         uint256 maxExtraReward = maxExtraReward.div(getHalvingFactor()).mul(extraRewardBlockInterval).mul(extraRewardBlockInterval).div(MAX_EXTRA_REWARD_BLOCK_INTERVAL).div(MAX_EXTRA_REWARD_BLOCK_INTERVAL);
1314         return extraReward;
1315     }
1316 
1317     // get stake time based extra reward
1318     function getMaxExtraReward(uint256 _pid, uint256 startStakeBlock, uint256 endBlock) public view returns(uint256){
1319         if(startStakeBlock > endBlock) {
1320             return 0;
1321         }
1322         uint256 extraRewardBlockInterval = endBlock.sub(startStakeBlock) > MAX_EXTRA_REWARD_BLOCK_INTERVAL ? MAX_EXTRA_REWARD_BLOCK_INTERVAL : endBlock.sub(startStakeBlock);
1323         uint256 maxExtraReward = maxExtraReward.div(getHalvingFactor()).mul(extraRewardBlockInterval).mul(extraRewardBlockInterval).div(MAX_EXTRA_REWARD_BLOCK_INTERVAL).div(MAX_EXTRA_REWARD_BLOCK_INTERVAL);
1324         return maxExtraReward;
1325     }
1326 
1327     // Withdraw without caring about rewards. EMERGENCY ONLY.
1328     function emergencyWithdraw(uint256 _pid) public {
1329         PoolInfo storage pool = poolInfo[_pid];
1330         UserInfo storage user = userInfo[_pid][msg.sender];
1331         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1332         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1333         user.amount = 0;
1334         user.rewardDebt = 0;
1335     }
1336 
1337     // Safe Sleep transfer function, just in case if rounding error causes pool to not have enough SLEEPs.
1338     function safeSleepTransfer(address _to, uint256 _amount) internal {
1339         uint256 sleepBal = sleep.balanceOf(address(this));
1340         if (_amount > sleepBal) {
1341             sleep.transfer(_to, sleepBal);
1342         } else {
1343             sleep.transfer(_to, _amount);
1344         }
1345     }
1346 
1347     // Update dev address by the previous dev.
1348     function dev(address _devaddr) public onlyOwner {
1349         devaddr = _devaddr;
1350     }
1351 
1352     // Set the migrator contract. Can only be called by the owner.
1353     function setMigrator(IMigratorChef _migrator) public onlyOwner {
1354         migrator = _migrator;
1355     }
1356 
1357     // Migrate lp token to another lp contract. Can be called by anyone. We trust that migrator contract is good.
1358     function migrate(uint256 _pid) public {
1359         require(address(migrator) != address(0), "migrate: no migrator");
1360         PoolInfo storage pool = poolInfo[_pid];
1361         IERC20 lpToken = pool.lpToken;
1362         uint256 bal = lpToken.balanceOf(address(this));
1363         lpToken.safeApprove(address(migrator), bal);
1364         IERC20 newLpToken = migrator.migrate(lpToken);
1365         require(bal == newLpToken.balanceOf(address(this)), "migrate: bad");
1366         pool.lpToken = newLpToken;
1367     }
1368 }
1369 
1370 /**
1371 * @title SleepVesting
1372 * @dev A token holder contract that can release its token balance gradually like a
1373 * typical vesting scheme, with a vesting period. Optionally revocable by the
1374 * owner.
1375 */
1376 contract SleepVesting is Ownable {
1377     using SafeMath for uint256;
1378     using SafeERC20 for ERC20;
1379     event TokensVested(address token, uint256 amount);
1380     address private _beneficiary;
1381     uint256 private _start;
1382     uint256 private _duration;
1383     uint256 private _released;
1384     // The SLEEP Token!
1385     ERC20 public sleep;
1386     constructor(address beneficiary, uint256 start, uint256 duration, SleepToken _sleep) public {
1387         require(beneficiary != address(0), "SleepVesting: beneficiary is the zero address");
1388         require(duration > 0, "SleepVesting: duration is 0");
1389         require(start.add(duration) > block.number, "SleepVesting: final time is before current time");
1390         _beneficiary = beneficiary;
1391         _start = start;
1392         _duration = duration;
1393         sleep = _sleep;
1394     }
1395     /**
1396      * @return the beneficiary of the tokens.
1397      */
1398     function beneficiary() public view returns (address) {
1399         return _beneficiary;
1400     }
1401     /**
1402     * @return the start time of the token vesting.
1403     */
1404     function start() public view returns (uint256) {
1405         return _start;
1406     }
1407     /**
1408      * @return the duration of the token vesting.
1409      */
1410     function duration() public view returns (uint256) {
1411         return _duration;
1412     }
1413     /**
1414      * @return the amount of the token released.
1415      */
1416     function released() public view returns (uint256) {
1417         return _released;
1418     }
1419     /**
1420      * @notice Transfers vested tokens to beneficiary.
1421      */
1422     function withdraw() public onlyOwner {
1423         uint256 unreleased = _releasableAmount();
1424         require(unreleased > 0, "SleepVesting: no tokens are due");
1425         _released = _released.add(unreleased);
1426         sleep.safeTransfer(_beneficiary, unreleased);
1427         emit TokensVested(address(sleep), unreleased);
1428     }
1429     /**
1430      * @dev Calculates the amount that has already vested but hasn't been released yet.
1431     */
1432     function _releasableAmount() private view returns (uint256) {
1433         return _vestedAmount().sub(_released);
1434     }
1435     /**
1436      * @dev Calculates the amount that has already vested.
1437      */
1438     function _vestedAmount() private view returns (uint256) {
1439         uint256 curBalance = sleep.balanceOf(address(this));
1440         uint256 totalBalance = curBalance.add(_released);
1441         return block.number.sub(_start) <
1442         _duration ? totalBalance.div(_duration).mul(block.number.sub(_start)) : totalBalance;
1443     }
1444 }