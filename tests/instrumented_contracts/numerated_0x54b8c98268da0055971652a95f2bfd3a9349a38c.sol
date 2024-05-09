1 /*
2 
3 website: printer.finance
4 
5       ___           ___                       ___           ___           ___           ___     
6      /\  \         /\  \          ___        /\__\         /\  \         /\  \         /\  \    
7     /::\  \       /::\  \        /\  \      /::|  |        \:\  \       /::\  \       /::\  \   
8    /:/\:\  \     /:/\:\  \       \:\  \    /:|:|  |         \:\  \     /:/\:\  \     /:/\:\  \  
9   /::\~\:\  \   /::\~\:\  \      /::\__\  /:/|:|  |__       /::\  \   /::\~\:\  \   /::\~\:\  \ 
10  /:/\:\ \:\__\ /:/\:\ \:\__\  __/:/\/__/ /:/ |:| /\__\     /:/\:\__\ /:/\:\ \:\__\ /:/\:\ \:\__\
11  \/__\:\/:/  / \/_|::\/:/  / /\/:/  /    \/__|:|/:/  /    /:/  \/__/ \:\~\:\ \/__/ \/_|::\/:/  /
12       \::/  /     |:|::/  /  \::/__/         |:/:/  /    /:/  /       \:\ \:\__\      |:|::/  / 
13        \/__/      |:|\/__/    \:\__\         |::/  /     \/__/         \:\ \/__/      |:|\/__/  
14                   |:|  |       \/__/         /:/  /                     \:\__\        |:|  |    
15                    \|__|                     \/__/                       \/__/         \|__|    
16 
17 forked from KIMCHI, SUSHI, KIMBAP and some other chinese food
18 but without public mint() function or 5% mint for devaddress and shit like this
19 
20 */
21 
22 pragma solidity ^0.6.12;
23 /*
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with GSN meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address payable) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes memory) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 /**
45  * @dev Interface of the ERC20 standard as defined in the EIP.
46  */
47 interface IERC20 {
48     /**
49      * @dev Returns the amount of tokens in existence.
50      */
51     function totalSupply() external view returns (uint256);
52 
53     /**
54      * @dev Returns the amount of tokens owned by `account`.
55      */
56     function balanceOf(address account) external view returns (uint256);
57 
58     /**
59      * @dev Moves `amount` tokens from the caller's account to `recipient`.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transfer(address recipient, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Returns the remaining number of tokens that `spender` will be
69      * allowed to spend on behalf of `owner` through {transferFrom}. This is
70      * zero by default.
71      *
72      * This value changes when {approve} or {transferFrom} are called.
73      */
74     function allowance(address owner, address spender) external view returns (uint256);
75 
76     /**
77      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * IMPORTANT: Beware that changing an allowance with this method brings the risk
82      * that someone may use both the old and the new allowance by unfortunate
83      * transaction ordering. One possible solution to mitigate this race
84      * condition is to first reduce the spender's allowance to 0 and set the
85      * desired value afterwards:
86      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
87      *
88      * Emits an {Approval} event.
89      */
90     function approve(address spender, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Moves `amount` tokens from `sender` to `recipient` using the
94      * allowance mechanism. `amount` is then deducted from the caller's
95      * allowance.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
102 
103     /**
104      * @dev Emitted when `value` tokens are moved from one account (`from`) to
105      * another (`to`).
106      *
107      * Note that `value` may be zero.
108      */
109     event Transfer(address indexed from, address indexed to, uint256 value);
110 
111     /**
112      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
113      * a call to {approve}. `value` is the new allowance.
114      */
115     event Approval(address indexed owner, address indexed spender, uint256 value);
116 }
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      *
140      * - Addition cannot overflow.
141      */
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         require(c >= a, "SafeMath: addition overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         return sub(a, b, "SafeMath: subtraction overflow");
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b <= a, errorMessage);
175         uint256 c = a - b;
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      *
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192         // benefit is lost if 'b' is also tested.
193         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
194         if (a == 0) {
195             return 0;
196         }
197 
198         uint256 c = a * b;
199         require(c / a == b, "SafeMath: multiplication overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
217         return div(a, b, "SafeMath: division by zero");
218     }
219 
220     /**
221      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator. Note: this function uses a
225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
226      * uses an invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b > 0, errorMessage);
234         uint256 c = a / b;
235         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
236 
237         return c;
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
253         return mod(a, b, "SafeMath: modulo by zero");
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * Reverts with custom message when dividing by zero.
259      *
260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
261      * opcode (which leaves remaining gas untouched) while Solidity uses an
262      * invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b != 0, errorMessage);
270         return a % b;
271     }
272 }
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
480 /**
481  * @dev Contract module which provides a basic access control mechanism, where
482  * there is an account (an owner) that can be granted exclusive access to
483  * specific functions.
484  *
485  * By default, the owner account will be the one that deploys the contract. This
486  * can later be changed with {transferOwnership}.
487  *
488  * This module is used through inheritance. It will make available the modifier
489  * `onlyOwner`, which can be applied to your functions to restrict their use to
490  * the owner.
491  */
492 contract Ownable is Context {
493 
494     /**
495      * @dev So here we seperate the rights of the classic ownership into 'owner' and 'minter'
496      * this way the developer/owner stays the 'owner' and can make changes like adding a pool
497      * at any time but cannot mint anymore as soon as the 'minter' gets changes (to the chef contract)
498      */
499     address private _owner;
500 
501     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
502 
503     /**
504      * @dev Initializes the contract setting the deployer as the initial owner.
505      */
506     constructor () internal {
507         address msgSender = _msgSender();
508         _owner = msgSender;
509         emit OwnershipTransferred(address(0), msgSender);
510     }
511 
512     /**
513      * @dev Returns the address of the current owner.
514      */
515     function owner() public view returns (address) {
516         return _owner;
517     }
518 
519     /**
520      * @dev Throws if called by any account other than the owner.
521      */
522     modifier onlyOwner() {
523         require(_owner == _msgSender(), "Ownable: caller is not the owner");
524         _;
525     }
526 
527     /**
528      * @dev Leaves the contract without owner. It will not be possible to call
529      * `onlyOwner` functions anymore. Can only be called by the current owner.
530      *
531      * NOTE: Renouncing ownership will leave the contract without an owner,
532      * thereby removing any functionality that is only available to the owner.
533      */
534     function renounceOwnership() public virtual onlyOwner {
535         emit OwnershipTransferred(_owner, address(0));
536         _owner = address(0);
537     }
538 
539     /**
540      * @dev Transfers ownership of the contract to a new account (`newOwner`).
541      * Can only be called by the current owner.
542      */
543     function transferOwnership(address newOwner) public virtual onlyOwner {
544         require(newOwner != address(0), "Ownable: new owner is the zero address");
545         emit OwnershipTransferred(_owner, newOwner);
546         _owner = newOwner;
547     }
548 }
549 
550 /**
551  * @dev Contract module which provides a basic access control mechanism, where
552  * there is an account (an minter) that can be granted exclusive access to
553  * specific functions.
554  *
555  * By default, the minter account will be the one that deploys the contract. This
556  * can later be changed with {transferMintership}.
557  *
558  * This module is used through inheritance. It will make available the modifier
559  * `onlyMinter`, which can be applied to your functions to restrict their use to
560  * the minter.
561  */
562 contract Mintable is Context {
563 
564     /**
565      * @dev So here we seperate the rights of the classic ownership into 'owner' and 'minter'
566      * this way the developer/owner stays the 'owner' and can make changes like adding a pool
567      * at any time but cannot mint anymore as soon as the 'minter' gets changes (to the chef contract)
568      */
569     address private _minter;
570 
571     event MintershipTransferred(address indexed previousMinter, address indexed newMinter);
572 
573     /**
574      * @dev Initializes the contract setting the deployer as the initial minter.
575      */
576     constructor () internal {
577         address msgSender = _msgSender();
578         _minter = msgSender;
579         emit MintershipTransferred(address(0), msgSender);
580     }
581 
582     /**
583      * @dev Returns the address of the current minter.
584      */
585     function minter() public view returns (address) {
586         return _minter;
587     }
588 
589     /**
590      * @dev Throws if called by any account other than the minter.
591      */
592     modifier onlyMinter() {
593         require(_minter == _msgSender(), "Mintable: caller is not the minter");
594         _;
595     }
596 
597     /**
598      * @dev Transfers mintership of the contract to a new account (`newMinter`).
599      * Can only be called by the current minter.
600      */
601     function transferMintership(address newMinter) public virtual onlyMinter {
602         require(newMinter != address(0), "Mintable: new minter is the zero address");
603         emit MintershipTransferred(_minter, newMinter);
604         _minter = newMinter;
605     }
606 }
607 
608 /**
609  * @dev Implementation of the {IERC20} interface.
610  *
611  * This implementation is agnostic to the way tokens are created. This means
612  * that a supply mechanism has to be added in a derived contract using {_mint}.
613  * For a generic mechanism see {ERC20PresetMinterPauser}.
614  *
615  * TIP: For a detailed writeup see our guide
616  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
617  * to implement supply mechanisms].
618  *
619  * We have followed general OpenZeppelin guidelines: functions revert instead
620  * of returning `false` on failure. This behavior is nonetheless conventional
621  * and does not conflict with the expectations of ERC20 applications.
622  *
623  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
624  * This allows applications to reconstruct the allowance for all accounts just
625  * by listening to said events. Other implementations of the EIP may not emit
626  * these events, as it isn't required by the specification.
627  *
628  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
629  * functions have been added to mitigate the well-known issues around setting
630  * allowances. See {IERC20-approve}.
631  */
632 contract ERC20 is Context, IERC20 {
633     using SafeMath for uint256;
634     using Address for address;
635 
636     mapping (address => uint256) private _balances;
637     mapping (address => mapping (address => uint256)) private _allowances;
638 
639     uint256 private _totalSupply;
640     uint256 private _burnedSupply;
641     uint256 private _burnRate;
642     string private _name;
643     string private _symbol;
644     uint256 private _decimals;
645 
646     /**
647      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
648      * a default value of 18.
649      *
650      * To select a different value for {decimals}, use {_setupDecimals}.
651      *
652      * All three of these values are immutable: they can only be set once during
653      * construction.
654      */
655     constructor (string memory name, string memory symbol, uint256 decimals, uint256 burnrate, uint256 initSupply) public {
656         _name = name;
657         _symbol = symbol;
658         _decimals = decimals;
659         _burnRate = burnrate;
660         _totalSupply = 0;
661         _mint(msg.sender, initSupply*(10**_decimals));
662         _burnedSupply = 0;
663     }
664 
665     /**
666      * @dev Returns the name of the token.
667      */
668     function name() public view returns (string memory) {
669         return _name;
670     }
671 
672     /**
673      * @dev Returns the symbol of the token, usually a shorter version of the
674      * name.
675      */
676     function symbol() public view returns (string memory) {
677         return _symbol;
678     }
679 
680     /**
681      * @dev Returns the number of decimals used to get its user representation.
682      * For example, if `decimals` equals `2`, a balance of `505` tokens should
683      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
684      *
685      * Tokens usually opt for a value of 18, imitating the relationship between
686      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
687      * called.
688      *
689      * NOTE: This information is only used for _display_ purposes: it in
690      * no way affects any of the arithmetic of the contract, including
691      * {IERC20-balanceOf} and {IERC20-transfer}.
692      */
693     function decimals() public view returns (uint256) {
694         return _decimals;
695     }
696 
697     /**
698      * @dev See {IERC20-totalSupply}.
699      */
700     function totalSupply() public view override returns (uint256) {
701         return _totalSupply;
702     }
703 
704     /**
705      * @dev Returns the amount of burned tokens.
706      */
707     function burnedSupply() public view returns (uint256) {
708         return _burnedSupply;
709     }
710 
711     /**
712      * @dev Returns the burnrate.
713      */
714     function burnRate() public view returns (uint256) {
715         return _burnRate;
716     }
717 
718     /**
719      * @dev See {IERC20-balanceOf}.
720      */
721     function balanceOf(address account) public view override returns (uint256) {
722         return _balances[account];
723     }
724 
725     /**
726      * @dev See {IERC20-transfer}.
727      *
728      * Requirements:
729      *
730      * - `recipient` cannot be the zero address.
731      * - the caller must have a balance of at least `amount`.
732      */
733     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
734         _transfer(_msgSender(), recipient, amount);
735         return true;
736     }
737 
738     /**
739      * @dev See {IERC20-transfer}.
740      *
741      * Requirements:
742      *
743      * - `account` cannot be the zero address.
744      * - the caller must have a balance of at least `amount`.
745      */
746     function burn(uint256 amount) public virtual returns (bool) {
747         _burn(_msgSender(), amount);
748         return true;
749     }
750 
751     /**
752      * @dev See {IERC20-allowance}.
753      */
754     function allowance(address owner, address spender) public view virtual override returns (uint256) {
755         return _allowances[owner][spender];
756     }
757 
758     /**
759      * @dev See {IERC20-approve}.
760      *
761      * Requirements:
762      *
763      * - `spender` cannot be the zero address.
764      */
765     function approve(address spender, uint256 amount) public virtual override returns (bool) {
766         _approve(_msgSender(), spender, amount);
767         return true;
768     }
769 
770     /**
771      * @dev See {IERC20-transferFrom}.
772      *
773      * Emits an {Approval} event indicating the updated allowance. This is not
774      * required by the EIP. See the note at the beginning of {ERC20};
775      *
776      * Requirements:
777      * - `sender` and `recipient` cannot be the zero address.
778      * - `sender` must have a balance of at least `amount`.
779      * - the caller must have allowance for ``sender``'s tokens of at least
780      * `amount`.
781      */
782     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
783         _transfer(sender, recipient, amount);
784         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
785         return true;
786     }
787 
788     /**
789      * @dev Atomically increases the allowance granted to `spender` by the caller.
790      *
791      * This is an alternative to {approve} that can be used as a mitigation for
792      * problems described in {IERC20-approve}.
793      *
794      * Emits an {Approval} event indicating the updated allowance.
795      *
796      * Requirements:
797      *
798      * - `spender` cannot be the zero address.
799      */
800     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
801         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
802         return true;
803     }
804 
805     /**
806      * @dev Atomically decreases the allowance granted to `spender` by the caller.
807      *
808      * This is an alternative to {approve} that can be used as a mitigation for
809      * problems described in {IERC20-approve}.
810      *
811      * Emits an {Approval} event indicating the updated allowance.
812      *
813      * Requirements:
814      *
815      * - `spender` cannot be the zero address.
816      * - `spender` must have allowance for the caller of at least
817      * `subtractedValue`.
818      */
819     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
820         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
821         return true;
822     }
823 
824     /**
825      * @dev Moves tokens `amount` from `sender` to `recipient`.
826      *
827      * This is internal function is equivalent to {transfer}, and can be used to
828      * e.g. implement automatic token fees, slashing mechanisms, etc.
829      *
830      * Emits a {Transfer} event.
831      *
832      * Requirements:
833      *
834      * - `sender` cannot be the zero address.
835      * - `recipient` cannot be the zero address.
836      * - `sender` must have a balance of at least `amount`.
837      */
838     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
839         require(sender != address(0), "ERC20: transfer from the zero address");
840         require(recipient != address(0), "ERC20: transfer to the zero address");
841         uint256 amount_burn = amount.mul(_burnRate).div(100);
842         uint256 amount_send = amount.sub(amount_burn);
843         require(amount == amount_send + amount_burn, "Burn value invalid");
844         _burn(sender, amount_burn);
845         amount = amount_send;
846         _beforeTokenTransfer(sender, recipient, amount);
847         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
848         _balances[recipient] = _balances[recipient].add(amount);
849         emit Transfer(sender, recipient, amount);
850     }
851 
852     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
853      * the total supply.
854      *
855      * Emits a {Transfer} event with `from` set to the zero address.
856      *
857      * Requirements
858      *
859      * - `to` cannot be the zero address.
860      * 
861      * HINT: This function is 'internal' and therefore can only be called from another
862      * function inside this contract!
863      */
864     function _mint(address account, uint256 amount) internal virtual {
865         require(account != address(0), "ERC20: mint to the zero address");
866         _beforeTokenTransfer(address(0), account, amount);
867         _totalSupply = _totalSupply.add(amount);
868         _balances[account] = _balances[account].add(amount);
869         emit Transfer(address(0), account, amount);
870     }
871 
872     /**
873      * @dev Destroys `amount` tokens from `account`, reducing the
874      * total supply.
875      *
876      * Emits a {Transfer} event with `to` set to the zero address.
877      *
878      * Requirements
879      *
880      * - `account` cannot be the zero address.
881      * - `account` must have at least `amount` tokens.
882      */
883     function _burn(address account, uint256 amount) internal virtual {
884         require(account != address(0), "ERC20: burn from the zero address");
885         _beforeTokenTransfer(account, address(0), amount);
886         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
887         _totalSupply = _totalSupply.sub(amount);
888         _burnedSupply = _burnedSupply.add(amount);
889         emit Transfer(account, address(0), amount);
890     }
891 
892     /**
893      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
894      *
895      * This is internal function is equivalent to `approve`, and can be used to
896      * e.g. set automatic allowances for certain subsystems, etc.
897      *
898      * Emits an {Approval} event.
899      *
900      * Requirements:
901      *
902      * - `owner` cannot be the zero address.
903      * - `spender` cannot be the zero address.
904      */
905     function _approve(address owner, address spender, uint256 amount) internal virtual {
906         require(owner != address(0), "ERC20: approve from the zero address");
907         require(spender != address(0), "ERC20: approve to the zero address");
908         _allowances[owner][spender] = amount;
909         emit Approval(owner, spender, amount);
910     }
911 
912     /**
913      * @dev Sets {burnRate} to a value other than the initial one.
914      */
915     function _setupBurnrate(uint8 burnrate_) internal virtual {
916         _burnRate = burnrate_;
917     }
918 
919     /**
920      * @dev Hook that is called before any transfer of tokens. This includes
921      * minting and burning.
922      *
923      * Calling conditions:
924      *
925      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
926      * will be to transferred to `to`.
927      * - when `from` is zero, `amount` tokens will be minted for `to`.
928      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
929      * - `from` and `to` are never both zero.
930      *
931      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
932      */
933     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
934 }
935 
936 // PrinterToken with Governance.
937 //                       ERC20 (name, symbol, decimals, burnrate, initSupply)
938 contract Token is ERC20("Printer.Finance", "PRINT", 18, 0, 1200), Ownable, Mintable {
939     function mint(address _to, uint256 _amount) public onlyMinter {
940         _mint(_to, _amount);
941     }
942     function setupBurnrate(uint8 burnrate_) public onlyOwner {
943         _setupBurnrate(burnrate_);
944     }
945 }