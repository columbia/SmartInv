1 /*
2 
3 website: volts.finance
4 
5  __     __           __    __              
6 /  |   /  |         /  |  /  |             
7 $$ |   $$ | ______  $$ | _$$ |_    _______ 
8 $$ |   $$ |/      \ $$ |/ $$   |  /       |
9 $$  \ /$$//$$$$$$  |$$ |$$$$$$/  /$$$$$$$/ 
10  $$  /$$/ $$ |  $$ |$$ |  $$ | __$$      \ 
11   $$ $$/  $$ \__$$ |$$ |  $$ |/  |$$$$$$  |
12    $$$/   $$    $$/ $$ |  $$  $$//     $$/ 
13     $/     $$$$$$/  $$/    $$$$/ $$$$$$$/  
14                                            
15 
16 improved version of CHARGED
17 
18 */
19 
20 pragma solidity ^0.6.12;
21 /*
22  * @dev Provides information about the current execution context, including the
23  * sender of the transaction and its data. While these are generally available
24  * via msg.sender and msg.data, they should not be accessed in such a direct
25  * manner, since when dealing with GSN meta-transactions the account sending and
26  * paying for execution may not be the actual sender (as far as an application
27  * is concerned).
28  *
29  * This contract is only required for intermediate, library-like contracts.
30  */
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address payable) {
33         return msg.sender;
34     }
35 
36     function _msgData() internal view virtual returns (bytes memory) {
37         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
38         return msg.data;
39     }
40 }
41 
42 /**
43  * @dev Interface of the ERC20 standard as defined in the EIP.
44  */
45 interface IERC20 {
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54     function balanceOf(address account) external view returns (uint256);
55 
56     /**
57      * @dev Moves `amount` tokens from the caller's account to `recipient`.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Returns the remaining number of tokens that `spender` will be
67      * allowed to spend on behalf of `owner` through {transferFrom}. This is
68      * zero by default.
69      *
70      * This value changes when {approve} or {transferFrom} are called.
71      */
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     /**
75      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * IMPORTANT: Beware that changing an allowance with this method brings the risk
80      * that someone may use both the old and the new allowance by unfortunate
81      * transaction ordering. One possible solution to mitigate this race
82      * condition is to first reduce the spender's allowance to 0 and set the
83      * desired value afterwards:
84      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85      *
86      * Emits an {Approval} event.
87      */
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Moves `amount` tokens from `sender` to `recipient` using the
92      * allowance mechanism. `amount` is then deducted from the caller's
93      * allowance.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
118  * checks.
119  *
120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
121  * in bugs, because programmers usually assume that an overflow raises an
122  * error, which is the standard behavior in high level programming languages.
123  * `SafeMath` restores this intuition by reverting the transaction when an
124  * operation overflows.
125  *
126  * Using this library instead of the unchecked operations eliminates an entire
127  * class of bugs, so it's recommended to use it always.
128  */
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `+` operator.
135      *
136      * Requirements:
137      *
138      * - Addition cannot overflow.
139      */
140     function add(uint256 a, uint256 b) internal pure returns (uint256) {
141         uint256 c = a + b;
142         require(c >= a, "SafeMath: addition overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158         return sub(a, b, "SafeMath: subtraction overflow");
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b <= a, errorMessage);
173         uint256 c = a - b;
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the multiplication of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `*` operator.
183      *
184      * Requirements:
185      *
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return div(a, b, "SafeMath: division by zero");
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
230     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b > 0, errorMessage);
232         uint256 c = a / b;
233         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
234 
235         return c;
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251         return mod(a, b, "SafeMath: modulo by zero");
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts with custom message when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267         require(b != 0, errorMessage);
268         return a % b;
269     }
270 }
271 
272 /**
273  * @dev Collection of functions related to the address type
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * [IMPORTANT]
280      * ====
281      * It is unsafe to assume that an address for which this function returns
282      * false is an externally-owned account (EOA) and not a contract.
283      *
284      * Among others, `isContract` will return false for the following
285      * types of addresses:
286      *
287      *  - an externally-owned account
288      *  - a contract in construction
289      *  - an address where a contract will be created
290      *  - an address where a contract lived, but was destroyed
291      * ====
292      */
293     function isContract(address account) internal view returns (bool) {
294         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
295         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
296         // for accounts without code, i.e. `keccak256('')`
297         bytes32 codehash;
298         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
299         // solhint-disable-next-line no-inline-assembly
300         assembly { codehash := extcodehash(account) }
301         return (codehash != accountHash && codehash != 0x0);
302     }
303 
304     /**
305      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306      * `recipient`, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by `transfer`, making them unable to receive funds via
311      * `transfer`. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to `recipient`, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      */
320     function sendValue(address payable recipient, uint256 amount) internal {
321         require(address(this).balance >= amount, "Address: insufficient balance");
322 
323         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
324         (bool success, ) = recipient.call{ value: amount }("");
325         require(success, "Address: unable to send value, recipient may have reverted");
326     }
327 
328     /**
329      * @dev Performs a Solidity function call using a low level `call`. A
330      * plain`call` is an unsafe replacement for a function call: use this
331      * function instead.
332      *
333      * If `target` reverts with a revert reason, it is bubbled up by this
334      * function (like regular Solidity function calls).
335      *
336      * Returns the raw returned data. To convert to the expected return value,
337      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
338      *
339      * Requirements:
340      *
341      * - `target` must be a contract.
342      * - calling `target` with `data` must not revert.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
347       return functionCall(target, data, "Address: low-level call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
352      * `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
357         return _functionCallWithValue(target, data, 0, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but also transferring `value` wei to `target`.
363      *
364      * Requirements:
365      *
366      * - the calling contract must have an ETH balance of at least `value`.
367      * - the called Solidity function must be `payable`.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
372         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
377      * with `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
382         require(address(this).balance >= value, "Address: insufficient balance for call");
383         return _functionCallWithValue(target, data, value, errorMessage);
384     }
385 
386     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
387         require(isContract(target), "Address: call to non-contract");
388 
389         // solhint-disable-next-line avoid-low-level-calls
390         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
391         if (success) {
392             return returndata;
393         } else {
394             // Look for revert reason and bubble it up if present
395             if (returndata.length > 0) {
396                 // The easiest way to bubble the revert reason is using memory via assembly
397 
398                 // solhint-disable-next-line no-inline-assembly
399                 assembly {
400                     let returndata_size := mload(returndata)
401                     revert(add(32, returndata), returndata_size)
402                 }
403             } else {
404                 revert(errorMessage);
405             }
406         }
407     }
408 }
409 
410 /**
411  * @title SafeERC20
412  * @dev Wrappers around ERC20 operations that throw on failure (when the token
413  * contract returns false). Tokens that return no value (and instead revert or
414  * throw on failure) are also supported, non-reverting calls are assumed to be
415  * successful.
416  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
417  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
418  */
419 library SafeERC20 {
420     using SafeMath for uint256;
421     using Address for address;
422 
423     function safeTransfer(IERC20 token, address to, uint256 value) internal {
424         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
425     }
426 
427     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
428         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
429     }
430 
431     /**
432      * @dev Deprecated. This function has issues similar to the ones found in
433      * {IERC20-approve}, and its usage is discouraged.
434      *
435      * Whenever possible, use {safeIncreaseAllowance} and
436      * {safeDecreaseAllowance} instead.
437      */
438     function safeApprove(IERC20 token, address spender, uint256 value) internal {
439         // safeApprove should only be called when setting an initial allowance,
440         // or when resetting it to zero. To increase and decrease it, use
441         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
442         // solhint-disable-next-line max-line-length
443         require((value == 0) || (token.allowance(address(this), spender) == 0),
444             "SafeERC20: approve from non-zero to non-zero allowance"
445         );
446         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
447     }
448 
449     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
450         uint256 newAllowance = token.allowance(address(this), spender).add(value);
451         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
452     }
453 
454     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
455         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
456         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
457     }
458 
459     /**
460      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
461      * on the return value: the return value is optional (but if data is returned, it must not be false).
462      * @param token The token targeted by the call.
463      * @param data The call data (encoded using abi.encode or one of its variants).
464      */
465     function _callOptionalReturn(IERC20 token, bytes memory data) private {
466         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
467         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
468         // the target address contains contract code and also asserts for success in the low-level call.
469 
470         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
471         if (returndata.length > 0) { // Return data is optional
472             // solhint-disable-next-line max-line-length
473             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
474         }
475     }
476 }
477 
478 /**
479  * @dev Contract module which provides a basic access control mechanism, where
480  * there is an account (an owner) that can be granted exclusive access to
481  * specific functions.
482  *
483  * By default, the owner account will be the one that deploys the contract. This
484  * can later be changed with {transferOwnership}.
485  *
486  * This module is used through inheritance. It will make available the modifier
487  * `onlyOwner`, which can be applied to your functions to restrict their use to
488  * the owner.
489  */
490 contract Ownable is Context {
491 
492     /**
493      * @dev So here we seperate the rights of the classic ownership into 'owner' and 'minter'
494      * this way the developer/owner stays the 'owner' and can make changes like adding a pool
495      * at any time but cannot mint anymore as soon as the 'minter' gets changes (to the chef contract)
496      */
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
548 /**
549  * @dev Contract module which provides a basic access control mechanism, where
550  * there is an account (an minter) that can be granted exclusive access to
551  * specific functions.
552  *
553  * By default, the minter account will be the one that deploys the contract. This
554  * can later be changed with {transferMintership}.
555  *
556  * This module is used through inheritance. It will make available the modifier
557  * `onlyMinter`, which can be applied to your functions to restrict their use to
558  * the minter.
559  */
560 contract Mintable is Context {
561 
562     /**
563      * @dev So here we seperate the rights of the classic ownership into 'owner' and 'minter'
564      * this way the developer/owner stays the 'owner' and can make changes like adding a pool
565      * at any time but cannot mint anymore as soon as the 'minter' gets changes (to the chef contract)
566      */
567     address private _minter;
568 
569     event MintershipTransferred(address indexed previousMinter, address indexed newMinter);
570 
571     /**
572      * @dev Initializes the contract setting the deployer as the initial minter.
573      */
574     constructor () internal {
575         address msgSender = _msgSender();
576         _minter = msgSender;
577         emit MintershipTransferred(address(0), msgSender);
578     }
579 
580     /**
581      * @dev Returns the address of the current minter.
582      */
583     function minter() public view returns (address) {
584         return _minter;
585     }
586 
587     /**
588      * @dev Throws if called by any account other than the minter.
589      */
590     modifier onlyMinter() {
591         require(_minter == _msgSender(), "Mintable: caller is not the minter");
592         _;
593     }
594 
595     /**
596      * @dev Transfers mintership of the contract to a new account (`newMinter`).
597      * Can only be called by the current minter.
598      */
599     function transferMintership(address newMinter) public virtual onlyMinter {
600         require(newMinter != address(0), "Mintable: new minter is the zero address");
601         emit MintershipTransferred(_minter, newMinter);
602         _minter = newMinter;
603     }
604 }
605 
606 /**
607  * @dev Implementation of the {IERC20} interface.
608  *
609  * This implementation is agnostic to the way tokens are created. This means
610  * that a supply mechanism has to be added in a derived contract using {_mint}.
611  * For a generic mechanism see {ERC20PresetMinterPauser}.
612  *
613  * TIP: For a detailed writeup see our guide
614  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
615  * to implement supply mechanisms].
616  *
617  * We have followed general OpenZeppelin guidelines: functions revert instead
618  * of returning `false` on failure. This behavior is nonetheless conventional
619  * and does not conflict with the expectations of ERC20 applications.
620  *
621  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
622  * This allows applications to reconstruct the allowance for all accounts just
623  * by listening to said events. Other implementations of the EIP may not emit
624  * these events, as it isn't required by the specification.
625  *
626  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
627  * functions have been added to mitigate the well-known issues around setting
628  * allowances. See {IERC20-approve}.
629  */
630 contract ERC20 is Context, IERC20 {
631     using SafeMath for uint256;
632     using Address for address;
633 
634     mapping (address => uint256) private _balances;
635     mapping (address => mapping (address => uint256)) private _allowances;
636 
637     uint256 private _totalSupply;
638     uint256 private _burnedSupply;
639     uint256 private _burnRate;
640     string private _name;
641     string private _symbol;
642     uint8 private _decimals;
643 
644     /**
645      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
646      * a default value of 18.
647      *
648      * To select a different value for {decimals}, use {_setupDecimals}.
649      *
650      * All three of these values are immutable: they can only be set once during
651      * construction.
652      */
653     constructor (string memory name, string memory symbol, uint8 decimals, uint256 burnrate, uint256 initSupply) public {
654         _name = name;
655         _symbol = symbol;
656         _decimals = decimals;
657         _burnRate = burnrate;
658         _totalSupply = 0;
659         _mint(msg.sender, initSupply*(10**uint256(_decimals)));
660         _burnedSupply = 0;
661     }
662 
663     /**
664      * @dev Returns the name of the token.
665      */
666     function name() public view returns (string memory) {
667         return _name;
668     }
669 
670     /**
671      * @dev Returns the symbol of the token, usually a shorter version of the
672      * name.
673      */
674     function symbol() public view returns (string memory) {
675         return _symbol;
676     }
677 
678     /**
679      * @dev Returns the number of decimals used to get its user representation.
680      * For example, if `decimals` equals `2`, a balance of `505` tokens should
681      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
682      *
683      * Tokens usually opt for a value of 18, imitating the relationship between
684      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
685      * called.
686      *
687      * NOTE: This information is only used for _display_ purposes: it in
688      * no way affects any of the arithmetic of the contract, including
689      * {IERC20-balanceOf} and {IERC20-transfer}.
690      */
691     function decimals() public view returns (uint8) {
692         return _decimals;
693     }
694 
695     /**
696      * @dev See {IERC20-totalSupply}.
697      */
698     function totalSupply() public view override returns (uint256) {
699         return _totalSupply;
700     }
701 
702     /**
703      * @dev Returns the amount of burned tokens.
704      */
705     function burnedSupply() public view returns (uint256) {
706         return _burnedSupply;
707     }
708 
709     /**
710      * @dev Returns the burnrate.
711      */
712     function burnRate() public view returns (uint256) {
713         return _burnRate;
714     }
715 
716     /**
717      * @dev See {IERC20-balanceOf}.
718      */
719     function balanceOf(address account) public view override returns (uint256) {
720         return _balances[account];
721     }
722 
723     /**
724      * @dev See {IERC20-transfer}.
725      *
726      * Requirements:
727      *
728      * - `recipient` cannot be the zero address.
729      * - the caller must have a balance of at least `amount`.
730      */
731     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
732         _transfer(_msgSender(), recipient, amount);
733         return true;
734     }
735 
736     /**
737      * @dev See {IERC20-transfer}.
738      *
739      * Requirements:
740      *
741      * - `account` cannot be the zero address.
742      * - the caller must have a balance of at least `amount`.
743      */
744     function burn(uint256 amount) public virtual returns (bool) {
745         _burn(_msgSender(), amount);
746         return true;
747     }
748 
749     /**
750      * @dev See {IERC20-allowance}.
751      */
752     function allowance(address owner, address spender) public view virtual override returns (uint256) {
753         return _allowances[owner][spender];
754     }
755 
756     /**
757      * @dev See {IERC20-approve}.
758      *
759      * Requirements:
760      *
761      * - `spender` cannot be the zero address.
762      */
763     function approve(address spender, uint256 amount) public virtual override returns (bool) {
764         _approve(_msgSender(), spender, amount);
765         return true;
766     }
767 
768     /**
769      * @dev See {IERC20-transferFrom}.
770      *
771      * Emits an {Approval} event indicating the updated allowance. This is not
772      * required by the EIP. See the note at the beginning of {ERC20};
773      *
774      * Requirements:
775      * - `sender` and `recipient` cannot be the zero address.
776      * - `sender` must have a balance of at least `amount`.
777      * - the caller must have allowance for ``sender``'s tokens of at least
778      * `amount`.
779      */
780     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
781         _transfer(sender, recipient, amount);
782         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
783         return true;
784     }
785 
786     /**
787      * @dev Atomically increases the allowance granted to `spender` by the caller.
788      *
789      * This is an alternative to {approve} that can be used as a mitigation for
790      * problems described in {IERC20-approve}.
791      *
792      * Emits an {Approval} event indicating the updated allowance.
793      *
794      * Requirements:
795      *
796      * - `spender` cannot be the zero address.
797      */
798     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
799         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
800         return true;
801     }
802 
803     /**
804      * @dev Atomically decreases the allowance granted to `spender` by the caller.
805      *
806      * This is an alternative to {approve} that can be used as a mitigation for
807      * problems described in {IERC20-approve}.
808      *
809      * Emits an {Approval} event indicating the updated allowance.
810      *
811      * Requirements:
812      *
813      * - `spender` cannot be the zero address.
814      * - `spender` must have allowance for the caller of at least
815      * `subtractedValue`.
816      */
817     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
818         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
819         return true;
820     }
821 
822     /**
823      * @dev Moves tokens `amount` from `sender` to `recipient`.
824      *
825      * This is internal function is equivalent to {transfer}, and can be used to
826      * e.g. implement automatic token fees, slashing mechanisms, etc.
827      *
828      * Emits a {Transfer} event.
829      *
830      * Requirements:
831      *
832      * - `sender` cannot be the zero address.
833      * - `recipient` cannot be the zero address.
834      * - `sender` must have a balance of at least `amount`.
835      */
836     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
837         require(sender != address(0), "ERC20: transfer from the zero address");
838         require(recipient != address(0), "ERC20: transfer to the zero address");
839         uint256 amount_burn = amount.mul(_burnRate).div(100);
840         uint256 amount_send = amount.sub(amount_burn);
841         require(amount == amount_send + amount_burn, "Burn value invalid");
842         _burn(sender, amount_burn);
843         amount = amount_send;
844         _beforeTokenTransfer(sender, recipient, amount);
845         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
846         _balances[recipient] = _balances[recipient].add(amount);
847         emit Transfer(sender, recipient, amount);
848     }
849 
850     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
851      * the total supply.
852      *
853      * Emits a {Transfer} event with `from` set to the zero address.
854      *
855      * Requirements
856      *
857      * - `to` cannot be the zero address.
858      * 
859      * HINT: This function is 'internal' and therefore can only be called from another
860      * function inside this contract!
861      */
862     function _mint(address account, uint256 amount) internal virtual {
863         require(account != address(0), "ERC20: mint to the zero address");
864         _beforeTokenTransfer(address(0), account, amount);
865         _totalSupply = _totalSupply.add(amount);
866         _balances[account] = _balances[account].add(amount);
867         emit Transfer(address(0), account, amount);
868     }
869 
870     /**
871      * @dev Destroys `amount` tokens from `account`, reducing the
872      * total supply.
873      *
874      * Emits a {Transfer} event with `to` set to the zero address.
875      *
876      * Requirements
877      *
878      * - `account` cannot be the zero address.
879      * - `account` must have at least `amount` tokens.
880      */
881     function _burn(address account, uint256 amount) internal virtual {
882         require(account != address(0), "ERC20: burn from the zero address");
883         _beforeTokenTransfer(account, address(0), amount);
884         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
885         _totalSupply = _totalSupply.sub(amount);
886         _burnedSupply = _burnedSupply.add(amount);
887         emit Transfer(account, address(0), amount);
888     }
889 
890     /**
891      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
892      *
893      * This is internal function is equivalent to `approve`, and can be used to
894      * e.g. set automatic allowances for certain subsystems, etc.
895      *
896      * Emits an {Approval} event.
897      *
898      * Requirements:
899      *
900      * - `owner` cannot be the zero address.
901      * - `spender` cannot be the zero address.
902      */
903     function _approve(address owner, address spender, uint256 amount) internal virtual {
904         require(owner != address(0), "ERC20: approve from the zero address");
905         require(spender != address(0), "ERC20: approve to the zero address");
906         _allowances[owner][spender] = amount;
907         emit Approval(owner, spender, amount);
908     }
909 
910     /**
911      * @dev Sets {burnRate} to a value other than the initial one.
912      */
913     function _setupBurnrate(uint8 burnrate_) internal virtual {
914         _burnRate = burnrate_;
915     }
916 
917     /**
918      * @dev Hook that is called before any transfer of tokens. This includes
919      * minting and burning.
920      *
921      * Calling conditions:
922      *
923      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
924      * will be to transferred to `to`.
925      * - when `from` is zero, `amount` tokens will be minted for `to`.
926      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
927      * - `from` and `to` are never both zero.
928      *
929      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
930      */
931     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
932 }
933 
934 // VoltsToken with Governance.
935 //                       ERC20 (name, symbol, decimals, burnrate, initSupply)
936 contract VoltsToken is ERC20("Volts.Finance", "VOLTS", 18, 0, 1600), Ownable, Mintable {
937     function mint(address _to, uint256 _amount) external onlyMinter {
938         _mint(_to, _amount);
939     }
940     function setupBurnrate(uint8 burnrate_) external onlyOwner {
941         _setupBurnrate(burnrate_);
942     }
943 }