1 /*
2 
3 website: charged.finance
4 
5  _______  __   __  _______  ______    _______  _______  ______  
6 |       ||  | |  ||   _   ||    _ |  |       ||       ||      | 
7 |       ||  |_|  ||  |_|  ||   | ||  |    ___||    ___||  _    |
8 |       ||       ||       ||   |_||_ |   | __ |   |___ | | |   |
9 |      _||       ||       ||    __  ||   ||  ||    ___|| |_|   |
10 |     |_ |   _   ||   _   ||   |  | ||   |_| ||   |___ |       |
11 |_______||__| |__||__| |__||___|  |_||_______||_______||______| 
12 
13 forked from KIMCHI, SUSHI, KIMBAP and PRINT
14 but without public mint() function or bug
15 
16 */
17 
18 pragma solidity ^0.6.12;
19 /*
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with GSN meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address payable) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes memory) {
35         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36         return msg.data;
37     }
38 }
39 
40 /**
41  * @dev Interface of the ERC20 standard as defined in the EIP.
42  */
43 interface IERC20 {
44     /**
45      * @dev Returns the amount of tokens in existence.
46      */
47     function totalSupply() external view returns (uint256);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     /**
73      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * IMPORTANT: Beware that changing an allowance with this method brings the risk
78      * that someone may use both the old and the new allowance by unfortunate
79      * transaction ordering. One possible solution to mitigate this race
80      * condition is to first reduce the spender's allowance to 0 and set the
81      * desired value afterwards:
82      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83      *
84      * Emits an {Approval} event.
85      */
86     function approve(address spender, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Moves `amount` tokens from `sender` to `recipient` using the
90      * allowance mechanism. `amount` is then deducted from the caller's
91      * allowance.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      *
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         return div(a, b, "SafeMath: division by zero");
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
293         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
294         // for accounts without code, i.e. `keccak256('')`
295         bytes32 codehash;
296         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
297         // solhint-disable-next-line no-inline-assembly
298         assembly { codehash := extcodehash(account) }
299         return (codehash != accountHash && codehash != 0x0);
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
322         (bool success, ) = recipient.call{ value: amount }("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 
326     /**
327      * @dev Performs a Solidity function call using a low level `call`. A
328      * plain`call` is an unsafe replacement for a function call: use this
329      * function instead.
330      *
331      * If `target` reverts with a revert reason, it is bubbled up by this
332      * function (like regular Solidity function calls).
333      *
334      * Returns the raw returned data. To convert to the expected return value,
335      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
336      *
337      * Requirements:
338      *
339      * - `target` must be a contract.
340      * - calling `target` with `data` must not revert.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
345       return functionCall(target, data, "Address: low-level call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350      * `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
355         return _functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
375      * with `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
380         require(address(this).balance >= value, "Address: insufficient balance for call");
381         return _functionCallWithValue(target, data, value, errorMessage);
382     }
383 
384     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
385         require(isContract(target), "Address: call to non-contract");
386 
387         // solhint-disable-next-line avoid-low-level-calls
388         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
389         if (success) {
390             return returndata;
391         } else {
392             // Look for revert reason and bubble it up if present
393             if (returndata.length > 0) {
394                 // The easiest way to bubble the revert reason is using memory via assembly
395 
396                 // solhint-disable-next-line no-inline-assembly
397                 assembly {
398                     let returndata_size := mload(returndata)
399                     revert(add(32, returndata), returndata_size)
400                 }
401             } else {
402                 revert(errorMessage);
403             }
404         }
405     }
406 }
407 
408 /**
409  * @title SafeERC20
410  * @dev Wrappers around ERC20 operations that throw on failure (when the token
411  * contract returns false). Tokens that return no value (and instead revert or
412  * throw on failure) are also supported, non-reverting calls are assumed to be
413  * successful.
414  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
415  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
416  */
417 library SafeERC20 {
418     using SafeMath for uint256;
419     using Address for address;
420 
421     function safeTransfer(IERC20 token, address to, uint256 value) internal {
422         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
423     }
424 
425     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
426         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
427     }
428 
429     /**
430      * @dev Deprecated. This function has issues similar to the ones found in
431      * {IERC20-approve}, and its usage is discouraged.
432      *
433      * Whenever possible, use {safeIncreaseAllowance} and
434      * {safeDecreaseAllowance} instead.
435      */
436     function safeApprove(IERC20 token, address spender, uint256 value) internal {
437         // safeApprove should only be called when setting an initial allowance,
438         // or when resetting it to zero. To increase and decrease it, use
439         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
440         // solhint-disable-next-line max-line-length
441         require((value == 0) || (token.allowance(address(this), spender) == 0),
442             "SafeERC20: approve from non-zero to non-zero allowance"
443         );
444         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
445     }
446 
447     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
448         uint256 newAllowance = token.allowance(address(this), spender).add(value);
449         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
450     }
451 
452     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
453         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
454         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
455     }
456 
457     /**
458      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
459      * on the return value: the return value is optional (but if data is returned, it must not be false).
460      * @param token The token targeted by the call.
461      * @param data The call data (encoded using abi.encode or one of its variants).
462      */
463     function _callOptionalReturn(IERC20 token, bytes memory data) private {
464         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
465         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
466         // the target address contains contract code and also asserts for success in the low-level call.
467 
468         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
469         if (returndata.length > 0) { // Return data is optional
470             // solhint-disable-next-line max-line-length
471             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
472         }
473     }
474 }
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
489 
490     /**
491      * @dev So here we seperate the rights of the classic ownership into 'owner' and 'minter'
492      * this way the developer/owner stays the 'owner' and can make changes like adding a pool
493      * at any time but cannot mint anymore as soon as the 'minter' gets changes (to the chef contract)
494      */
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
546 /**
547  * @dev Contract module which provides a basic access control mechanism, where
548  * there is an account (an minter) that can be granted exclusive access to
549  * specific functions.
550  *
551  * By default, the minter account will be the one that deploys the contract. This
552  * can later be changed with {transferMintership}.
553  *
554  * This module is used through inheritance. It will make available the modifier
555  * `onlyMinter`, which can be applied to your functions to restrict their use to
556  * the minter.
557  */
558 contract Mintable is Context {
559 
560     /**
561      * @dev So here we seperate the rights of the classic ownership into 'owner' and 'minter'
562      * this way the developer/owner stays the 'owner' and can make changes like adding a pool
563      * at any time but cannot mint anymore as soon as the 'minter' gets changes (to the chef contract)
564      */
565     address private _minter;
566 
567     event MintershipTransferred(address indexed previousMinter, address indexed newMinter);
568 
569     /**
570      * @dev Initializes the contract setting the deployer as the initial minter.
571      */
572     constructor () internal {
573         address msgSender = _msgSender();
574         _minter = msgSender;
575         emit MintershipTransferred(address(0), msgSender);
576     }
577 
578     /**
579      * @dev Returns the address of the current minter.
580      */
581     function minter() public view returns (address) {
582         return _minter;
583     }
584 
585     /**
586      * @dev Throws if called by any account other than the minter.
587      */
588     modifier onlyMinter() {
589         require(_minter == _msgSender(), "Mintable: caller is not the minter");
590         _;
591     }
592 
593     /**
594      * @dev Transfers mintership of the contract to a new account (`newMinter`).
595      * Can only be called by the current minter.
596      */
597     function transferMintership(address newMinter) public virtual onlyMinter {
598         require(newMinter != address(0), "Mintable: new minter is the zero address");
599         emit MintershipTransferred(_minter, newMinter);
600         _minter = newMinter;
601     }
602 }
603 
604 /**
605  * @dev Implementation of the {IERC20} interface.
606  *
607  * This implementation is agnostic to the way tokens are created. This means
608  * that a supply mechanism has to be added in a derived contract using {_mint}.
609  * For a generic mechanism see {ERC20PresetMinterPauser}.
610  *
611  * TIP: For a detailed writeup see our guide
612  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
613  * to implement supply mechanisms].
614  *
615  * We have followed general OpenZeppelin guidelines: functions revert instead
616  * of returning `false` on failure. This behavior is nonetheless conventional
617  * and does not conflict with the expectations of ERC20 applications.
618  *
619  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
620  * This allows applications to reconstruct the allowance for all accounts just
621  * by listening to said events. Other implementations of the EIP may not emit
622  * these events, as it isn't required by the specification.
623  *
624  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
625  * functions have been added to mitigate the well-known issues around setting
626  * allowances. See {IERC20-approve}.
627  */
628 contract ERC20 is Context, IERC20 {
629     using SafeMath for uint256;
630     using Address for address;
631 
632     mapping (address => uint256) private _balances;
633     mapping (address => mapping (address => uint256)) private _allowances;
634 
635     uint256 private _totalSupply;
636     uint256 private _burnedSupply;
637     uint256 private _burnRate;
638     string private _name;
639     string private _symbol;
640     uint256 private _decimals;
641 
642     /**
643      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
644      * a default value of 18.
645      *
646      * To select a different value for {decimals}, use {_setupDecimals}.
647      *
648      * All three of these values are immutable: they can only be set once during
649      * construction.
650      */
651     constructor (string memory name, string memory symbol, uint256 decimals, uint256 burnrate, uint256 initSupply) public {
652         _name = name;
653         _symbol = symbol;
654         _decimals = decimals;
655         _burnRate = burnrate;
656         _totalSupply = 0;
657         _mint(msg.sender, initSupply*(10**_decimals));
658         _burnedSupply = 0;
659     }
660 
661     /**
662      * @dev Returns the name of the token.
663      */
664     function name() public view returns (string memory) {
665         return _name;
666     }
667 
668     /**
669      * @dev Returns the symbol of the token, usually a shorter version of the
670      * name.
671      */
672     function symbol() public view returns (string memory) {
673         return _symbol;
674     }
675 
676     /**
677      * @dev Returns the number of decimals used to get its user representation.
678      * For example, if `decimals` equals `2`, a balance of `505` tokens should
679      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
680      *
681      * Tokens usually opt for a value of 18, imitating the relationship between
682      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
683      * called.
684      *
685      * NOTE: This information is only used for _display_ purposes: it in
686      * no way affects any of the arithmetic of the contract, including
687      * {IERC20-balanceOf} and {IERC20-transfer}.
688      */
689     function decimals() public view returns (uint256) {
690         return _decimals;
691     }
692 
693     /**
694      * @dev See {IERC20-totalSupply}.
695      */
696     function totalSupply() public view override returns (uint256) {
697         return _totalSupply;
698     }
699 
700     /**
701      * @dev Returns the amount of burned tokens.
702      */
703     function burnedSupply() public view returns (uint256) {
704         return _burnedSupply;
705     }
706 
707     /**
708      * @dev Returns the burnrate.
709      */
710     function burnRate() public view returns (uint256) {
711         return _burnRate;
712     }
713 
714     /**
715      * @dev See {IERC20-balanceOf}.
716      */
717     function balanceOf(address account) public view override returns (uint256) {
718         return _balances[account];
719     }
720 
721     /**
722      * @dev See {IERC20-transfer}.
723      *
724      * Requirements:
725      *
726      * - `recipient` cannot be the zero address.
727      * - the caller must have a balance of at least `amount`.
728      */
729     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
730         _transfer(_msgSender(), recipient, amount);
731         return true;
732     }
733 
734     /**
735      * @dev See {IERC20-transfer}.
736      *
737      * Requirements:
738      *
739      * - `account` cannot be the zero address.
740      * - the caller must have a balance of at least `amount`.
741      */
742     function burn(uint256 amount) public virtual returns (bool) {
743         _burn(_msgSender(), amount);
744         return true;
745     }
746 
747     /**
748      * @dev See {IERC20-allowance}.
749      */
750     function allowance(address owner, address spender) public view virtual override returns (uint256) {
751         return _allowances[owner][spender];
752     }
753 
754     /**
755      * @dev See {IERC20-approve}.
756      *
757      * Requirements:
758      *
759      * - `spender` cannot be the zero address.
760      */
761     function approve(address spender, uint256 amount) public virtual override returns (bool) {
762         _approve(_msgSender(), spender, amount);
763         return true;
764     }
765 
766     /**
767      * @dev See {IERC20-transferFrom}.
768      *
769      * Emits an {Approval} event indicating the updated allowance. This is not
770      * required by the EIP. See the note at the beginning of {ERC20};
771      *
772      * Requirements:
773      * - `sender` and `recipient` cannot be the zero address.
774      * - `sender` must have a balance of at least `amount`.
775      * - the caller must have allowance for ``sender``'s tokens of at least
776      * `amount`.
777      */
778     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
779         _transfer(sender, recipient, amount);
780         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
781         return true;
782     }
783 
784     /**
785      * @dev Atomically increases the allowance granted to `spender` by the caller.
786      *
787      * This is an alternative to {approve} that can be used as a mitigation for
788      * problems described in {IERC20-approve}.
789      *
790      * Emits an {Approval} event indicating the updated allowance.
791      *
792      * Requirements:
793      *
794      * - `spender` cannot be the zero address.
795      */
796     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
797         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
798         return true;
799     }
800 
801     /**
802      * @dev Atomically decreases the allowance granted to `spender` by the caller.
803      *
804      * This is an alternative to {approve} that can be used as a mitigation for
805      * problems described in {IERC20-approve}.
806      *
807      * Emits an {Approval} event indicating the updated allowance.
808      *
809      * Requirements:
810      *
811      * - `spender` cannot be the zero address.
812      * - `spender` must have allowance for the caller of at least
813      * `subtractedValue`.
814      */
815     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
816         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
817         return true;
818     }
819 
820     /**
821      * @dev Moves tokens `amount` from `sender` to `recipient`.
822      *
823      * This is internal function is equivalent to {transfer}, and can be used to
824      * e.g. implement automatic token fees, slashing mechanisms, etc.
825      *
826      * Emits a {Transfer} event.
827      *
828      * Requirements:
829      *
830      * - `sender` cannot be the zero address.
831      * - `recipient` cannot be the zero address.
832      * - `sender` must have a balance of at least `amount`.
833      */
834     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
835         require(sender != address(0), "ERC20: transfer from the zero address");
836         require(recipient != address(0), "ERC20: transfer to the zero address");
837         uint256 amount_burn = amount.mul(_burnRate).div(100);
838         uint256 amount_send = amount.sub(amount_burn);
839         require(amount == amount_send + amount_burn, "Burn value invalid");
840         _burn(sender, amount_burn);
841         amount = amount_send;
842         _beforeTokenTransfer(sender, recipient, amount);
843         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
844         _balances[recipient] = _balances[recipient].add(amount);
845         emit Transfer(sender, recipient, amount);
846     }
847 
848     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
849      * the total supply.
850      *
851      * Emits a {Transfer} event with `from` set to the zero address.
852      *
853      * Requirements
854      *
855      * - `to` cannot be the zero address.
856      * 
857      * HINT: This function is 'internal' and therefore can only be called from another
858      * function inside this contract!
859      */
860     function _mint(address account, uint256 amount) internal virtual {
861         require(account != address(0), "ERC20: mint to the zero address");
862         _beforeTokenTransfer(address(0), account, amount);
863         _totalSupply = _totalSupply.add(amount);
864         _balances[account] = _balances[account].add(amount);
865         emit Transfer(address(0), account, amount);
866     }
867 
868     /**
869      * @dev Destroys `amount` tokens from `account`, reducing the
870      * total supply.
871      *
872      * Emits a {Transfer} event with `to` set to the zero address.
873      *
874      * Requirements
875      *
876      * - `account` cannot be the zero address.
877      * - `account` must have at least `amount` tokens.
878      */
879     function _burn(address account, uint256 amount) internal virtual {
880         require(account != address(0), "ERC20: burn from the zero address");
881         _beforeTokenTransfer(account, address(0), amount);
882         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
883         _totalSupply = _totalSupply.sub(amount);
884         _burnedSupply = _burnedSupply.add(amount);
885         emit Transfer(account, address(0), amount);
886     }
887 
888     /**
889      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
890      *
891      * This is internal function is equivalent to `approve`, and can be used to
892      * e.g. set automatic allowances for certain subsystems, etc.
893      *
894      * Emits an {Approval} event.
895      *
896      * Requirements:
897      *
898      * - `owner` cannot be the zero address.
899      * - `spender` cannot be the zero address.
900      */
901     function _approve(address owner, address spender, uint256 amount) internal virtual {
902         require(owner != address(0), "ERC20: approve from the zero address");
903         require(spender != address(0), "ERC20: approve to the zero address");
904         _allowances[owner][spender] = amount;
905         emit Approval(owner, spender, amount);
906     }
907 
908     /**
909      * @dev Sets {burnRate} to a value other than the initial one.
910      */
911     function _setupBurnrate(uint8 burnrate_) internal virtual {
912         _burnRate = burnrate_;
913     }
914 
915     /**
916      * @dev Hook that is called before any transfer of tokens. This includes
917      * minting and burning.
918      *
919      * Calling conditions:
920      *
921      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
922      * will be to transferred to `to`.
923      * - when `from` is zero, `amount` tokens will be minted for `to`.
924      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
925      * - `from` and `to` are never both zero.
926      *
927      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
928      */
929     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
930 }
931 
932 // ChargedToken with Governance.
933 //                       ERC20 (name, symbol, decimals, burnrate, initSupply)
934 contract Token is ERC20("Charged.Finance", "CHARGED", 18, 0, 1200), Ownable, Mintable {
935     function mint(address _to, uint256 _amount) public onlyMinter {
936         _mint(_to, _amount);
937     }
938     function setupBurnrate(uint8 burnrate_) public onlyOwner {
939         _setupBurnrate(burnrate_);
940     }
941 }
942 
943 contract ChargedChef is Ownable {
944     using SafeMath for uint256;
945     using SafeERC20 for IERC20;
946 
947     // Info of each user.
948     struct UserInfo {
949         uint256 amount;     // How many LP tokens the user has provided.
950         uint256 rewardDebt; // Reward debt. See explanation below.
951         //
952         // We do some fancy math here. Basically, any point in time, the amount of 
953         // claimable CHARGED by a user is:
954         //
955         //   pending reward = (user.amount * pool.accChargedPerLPShare) - user.rewardDebt
956         //
957         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
958         //   1. The pool's `accChargedPerLPShare` (and `lastRewardedBlock`) gets updated.
959         //   2. User receives the pending reward sent to his/her address.
960         //   3. User's `amount` gets updated.
961         //   4. User's `rewardDebt` gets updated.
962     }
963 
964     // Info of each pool.
965     struct PoolInfo {
966         IERC20 lpTokenContract;     // Address of LP token contract.
967         string name;                // Name of the pool/pair.
968         uint256 allocPoints;        // Allocation points from the pool.
969         uint256 lastRewardedBlock;  // Last block number where CHARGW distribution occured.
970         uint256 accChargedPerLPShare; // Accumulated Charged per share.
971         uint256 lpTokenHolding;     // Amount of LP token hold by this pool
972     }
973 
974     // Info of Charged minting
975     struct MintInfo {
976         uint256 ChargedPerBlock;  // Amount of minted Charged each block.
977         uint256 mintStartBlock; // Minting of this amount starts here.
978     }
979 
980     // The Charged token contract
981     Token public Charged;
982     
983     // Dev address. (Only needed for secretly minting. We don't do that!)
984     // address public devaddr;
985 
986     // Info of each pool.
987     PoolInfo[] public poolInfo;
988     // Info of Charged minting block span.
989     MintInfo[] public mintInfo;
990     
991     // Info of each user that stakes LP tokens.
992     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
993     // Total allocation points. Must be the sum of all allocation points in all pools.
994     uint256 public totalAllocPoints = 0;
995 
996     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
997     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
998     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
999 
1000     constructor(
1001         Token _Charged,
1002         // address _devaddr,
1003         uint256 _ChargedPerBlock,
1004         uint256 _mintStartBlock
1005     ) public {
1006         Charged = _Charged;
1007         // devaddr = _devaddr;
1008         mintInfo.push(MintInfo({
1009             ChargedPerBlock: _ChargedPerBlock,
1010             mintStartBlock: _mintStartBlock
1011         }));
1012     }
1013     
1014     // Get current mint per block
1015     function currentMint() external view returns (uint256){
1016         for(uint256 i = 0; i < mintInfo.length-1; i++){
1017             if(mintInfo[i].mintStartBlock <= block.number && mintInfo[i+1].mintStartBlock > block.number){
1018                 return i;
1019             }
1020         }
1021         if(block.number < mintInfo[0].mintStartBlock) {
1022             return 99999;
1023         }
1024         return mintInfo.length-1;
1025     }
1026 
1027     // Amount of block spans for minting different amounts of Charged
1028     function mintLength() external view returns (uint256) {
1029         return mintInfo.length;
1030     }
1031     
1032     // Return if farming already started or not 
1033     function farmingActive() external view returns (bool){
1034         return block.number >= mintInfo[0].mintStartBlock;
1035     }
1036     
1037     // Add a new block and mint amount to the mintInfo list. Can only be called by the owner.
1038     // Only possible to change for blocks not already mined.
1039     function addMint(uint256 _block, uint256 _amount) public onlyOwner {
1040         require(_block > block.number + 10, "_block is already mined or too close on getting mined.");
1041         mintInfo.push(MintInfo({
1042             ChargedPerBlock: _amount,
1043             mintStartBlock: _block
1044         }));
1045     }
1046     
1047     // Update the fiven blockspans startblock and mint amount. Can only be called by the owner.
1048     // Only possible to change for blocks not already mined.
1049     function setMint(uint256 _mid, uint256 _block, uint256 _amount) public onlyOwner {
1050         require(_block > block.number + 10, "_block is already mined or too close on getting mined.");
1051         require(mintInfo[_mid].mintStartBlock > block.number + 10, "mintStartBlock is already mined or too close on getting mined.");
1052         mintInfo[_mid].ChargedPerBlock = _amount;
1053         mintInfo[_mid].mintStartBlock = _block;
1054     }
1055     
1056     // Deletes a given blockspan for minting. You can't delete first one. Can only be called by the owner.
1057     // Only possible to change for blocks not already mined.
1058     function deleteMint(uint256 _mid) public onlyOwner {
1059         require(_mid != 0, "You can't delete the first blockspan!");
1060         require(_mid < mintInfo.length, "_mid is invalid!");
1061         require(mintInfo[_mid].mintStartBlock > block.number + 10, "_block is already mined or too close on getting mined.");
1062         for(uint256 i = _mid; i < mintInfo.length - 1; i++){
1063             mintInfo[i] = mintInfo[i+1];
1064         }
1065         mintInfo.pop();
1066     }
1067 
1068     // Amount of pairs available for farming
1069     function poolLength() external view returns (uint256) {
1070         return poolInfo.length;
1071     }
1072     
1073     // Add a new LP contract to the pool. Can only be called by the owner.
1074     // !!! DO NOT add the same LP token more than once. Rewards will be messed up if you do !!!
1075     function addLP(string memory _name, uint256 _allocPoints, IERC20 _lpTokenContract, bool _withUpdate) public onlyOwner {
1076         if (_withUpdate) {
1077             massUpdatePools();
1078         }
1079         uint256 lastRewardedBlock = block.number > mintInfo[0].mintStartBlock ? block.number : mintInfo[0].mintStartBlock;
1080         totalAllocPoints = totalAllocPoints.add(_allocPoints);
1081         poolInfo.push(PoolInfo({
1082             lpTokenContract: _lpTokenContract,
1083             name: _name,
1084             allocPoints: _allocPoints,
1085             lastRewardedBlock: lastRewardedBlock,
1086             accChargedPerLPShare: 0,
1087             lpTokenHolding: 0
1088         }));
1089     }
1090 
1091     // Update the given pools allocation points. Can only be called by the owner.
1092     function setLP(uint256 _pid, string memory _name, uint256 _allocPoints, bool _withUpdate) public onlyOwner {
1093         if (_withUpdate) {
1094             massUpdatePools();
1095         }
1096         totalAllocPoints = totalAllocPoints.sub(poolInfo[_pid].allocPoints).add(_allocPoints);
1097         poolInfo[_pid].name = _name;
1098         poolInfo[_pid].allocPoints = _allocPoints;
1099     }
1100 
1101     // Return rewards over the given span from _from block to _to block.
1102     function getChargedAmountInRange(uint256 _from, uint256 _to) public view returns (uint256) {
1103         if(_from >= _to){
1104             return 0;
1105         }
1106         uint256 reward = 0;
1107         uint256 blocksleft = _to.sub(_from);
1108         for( uint256 cblock = _from+1; cblock <= _to; cblock++){
1109             if(cblock < mintInfo[0].mintStartBlock){
1110                 blocksleft--;
1111             }
1112         }
1113         for( uint256 i = 0; i < mintInfo.length-1; i++){
1114             for( uint256 cblock = _from+1; cblock <= _to; cblock++){
1115                 if(cblock >= mintInfo[i].mintStartBlock && cblock < mintInfo[i+1].mintStartBlock){
1116                     reward += mintInfo[i].ChargedPerBlock;
1117                     blocksleft--;
1118                 }
1119             }
1120         }
1121         reward += blocksleft.mul(mintInfo[mintInfo.length-1].ChargedPerBlock);
1122         return reward;
1123     }
1124 
1125     // View function to see pending Charged on frontend.
1126     function pendingCharged(uint256 _pid, address _user) public returns (uint256) {
1127         PoolInfo storage pool = poolInfo[_pid];
1128         UserInfo storage user = userInfo[_pid][_user];
1129         uint256 accChargedPerLPShare = pool.accChargedPerLPShare;
1130         // Users LP tokens who is connected to the site
1131         uint256 lpSupply = pool.lpTokenContract.balanceOf(address(this));
1132         pool.lpTokenHolding = lpSupply;
1133         if (block.number > pool.lastRewardedBlock && lpSupply > 0) {
1134             uint256 ChargedReward = getChargedAmountInRange(pool.lastRewardedBlock, block.number).mul(pool.allocPoints).div(totalAllocPoints);
1135             ChargedReward = ChargedReward.mul(1e18);
1136             accChargedPerLPShare = accChargedPerLPShare.add(ChargedReward.div(lpSupply));
1137         }
1138         return user.amount.mul(accChargedPerLPShare).div(1e18).sub(user.rewardDebt);
1139     }
1140 
1141     // Update reward vairables for all pools. Be careful of gas spending!
1142     function massUpdatePools() public {
1143         uint256 length = poolInfo.length;
1144         for (uint256 pid = 0; pid < length; ++pid) {
1145             updatePool(pid);
1146         }
1147     }
1148 
1149     // Update reward variables of the given pool to be up-to-date.
1150     function updatePool(uint256 _pid) public {
1151         PoolInfo storage pool = poolInfo[_pid];
1152         if (block.number <= pool.lastRewardedBlock) {
1153             return;
1154         }
1155         uint256 lpSupply = pool.lpTokenContract.balanceOf(address(this));
1156         pool.lpTokenHolding = lpSupply;
1157         if (lpSupply == 0) {
1158             pool.lastRewardedBlock = block.number;
1159             return;
1160         }
1161         uint256 ChargedReward = getChargedAmountInRange(pool.lastRewardedBlock, block.number).mul(pool.allocPoints).div(totalAllocPoints);
1162         //Charged.mint(devaddr, ChargedReward.div(5)); // (Sushi has 10% of this shit!)
1163         Charged.mint(address(this), ChargedReward);
1164         ChargedReward = ChargedReward.mul(1e18);
1165         pool.accChargedPerLPShare = pool.accChargedPerLPShare.add(ChargedReward.div(lpSupply));
1166         pool.lastRewardedBlock = block.number;
1167     }
1168 
1169     // Deposit LP tokens to Chef for Charged allocation.
1170     // Also used to claim the users pending Charged tokens (_amount = 0)
1171     function deposit(uint256 _pid, uint256 _amount) public {
1172         PoolInfo storage pool = poolInfo[_pid];
1173         UserInfo storage user = userInfo[_pid][msg.sender];
1174         updatePool(_pid);
1175         if (user.amount > 0) {
1176             uint256 pending = user.amount.mul(pool.accChargedPerLPShare).div(1e18).sub(user.rewardDebt);
1177             safeChargedTransfer(msg.sender, pending);
1178         }
1179         pool.lpTokenContract.safeTransferFrom(address(msg.sender), address(this), _amount);
1180         user.amount = user.amount.add(_amount);
1181         user.rewardDebt = user.amount.mul(pool.accChargedPerLPShare).div(1e18);
1182         emit Deposit(msg.sender, _pid, _amount);
1183     }
1184 
1185     // Withdraw LP tokens from Chef.
1186     // Also used to claim the users pending Charged tokens
1187     function withdraw(uint256 _pid, uint256 _amount) public {
1188         PoolInfo storage pool = poolInfo[_pid];
1189         UserInfo storage user = userInfo[_pid][msg.sender];
1190         require(user.amount >= _amount, "withdraw: not good");
1191         updatePool(_pid);
1192         uint256 pending = user.amount.mul(pool.accChargedPerLPShare).div(1e18).sub(user.rewardDebt);
1193         safeChargedTransfer(msg.sender, pending);
1194         user.amount = user.amount.sub(_amount);
1195         user.rewardDebt = user.amount.mul(pool.accChargedPerLPShare).div(1e18);
1196         pool.lpTokenContract.safeTransfer(address(msg.sender), _amount);
1197         emit Withdraw(msg.sender, _pid, _amount);
1198     }
1199 
1200     // Withdraw without caring about rewards. EMERGENCY ONLY.
1201     function emergencyWithdraw(uint256 _pid) public {
1202         PoolInfo storage pool = poolInfo[_pid];
1203         UserInfo storage user = userInfo[_pid][msg.sender];
1204         pool.lpTokenContract.safeTransfer(address(msg.sender), user.amount);
1205         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1206         user.amount = 0;
1207         user.rewardDebt = 0;
1208     }
1209 
1210     // Safe Charged transfer function, just in case if rounding error causes pool to not have enough charged.
1211     function safeChargedTransfer(address _to, uint256 _amount) internal {
1212         uint256 ChargedBal = Charged.balanceOf(address(this));
1213         if (_amount > ChargedBal) {
1214             Charged.transfer(_to, ChargedBal);
1215         } else {
1216             Charged.transfer(_to, _amount);
1217         }
1218     }
1219     
1220     // Update dev address by the previous dev. (We don't need this here!)
1221     // function dev(address _devaddr) public {
1222     //   require(msg.sender == devaddr, "dev: wut?");
1223     //   devaddr = _devaddr;
1224     //}
1225 }