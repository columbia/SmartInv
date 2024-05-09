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
598      * @dev Leaves the contract without minter. It will not be possible to call
599      * `onlyMinter` functions anymore. Can only be called by the current minter.
600      *
601      * NOTE: We don't need this function for 'minter' as the chef contract will
602      * stay the minter forever.
603      */
604     function renounceMintership() public virtual onlyMinter {
605         emit MintershipTransferred(_minter, address(0));
606         _minter = address(0);
607     }
608 
609     /**
610      * @dev Transfers mintership of the contract to a new account (`newMinter`).
611      * Can only be called by the current minter.
612      */
613     function transferMintership(address newMinter) public virtual onlyMinter {
614         require(newMinter != address(0), "Mintable: new minter is the zero address");
615         emit MintershipTransferred(_minter, newMinter);
616         _minter = newMinter;
617     }
618 }
619 
620 /**
621  * @dev Implementation of the {IERC20} interface.
622  *
623  * This implementation is agnostic to the way tokens are created. This means
624  * that a supply mechanism has to be added in a derived contract using {_mint}.
625  * For a generic mechanism see {ERC20PresetMinterPauser}.
626  *
627  * TIP: For a detailed writeup see our guide
628  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
629  * to implement supply mechanisms].
630  *
631  * We have followed general OpenZeppelin guidelines: functions revert instead
632  * of returning `false` on failure. This behavior is nonetheless conventional
633  * and does not conflict with the expectations of ERC20 applications.
634  *
635  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
636  * This allows applications to reconstruct the allowance for all accounts just
637  * by listening to said events. Other implementations of the EIP may not emit
638  * these events, as it isn't required by the specification.
639  *
640  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
641  * functions have been added to mitigate the well-known issues around setting
642  * allowances. See {IERC20-approve}.
643  */
644 contract ERC20 is Context, IERC20 {
645     using SafeMath for uint256;
646     using Address for address;
647 
648     mapping (address => uint256) private _balances;
649     mapping (address => mapping (address => uint256)) private _allowances;
650 
651     uint256 private _totalSupply;
652     uint256 private _burnedSupply;
653     uint256 private _burnRate;
654     string private _name;
655     string private _symbol;
656     uint256 private _decimals;
657 
658     /**
659      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
660      * a default value of 18.
661      *
662      * To select a different value for {decimals}, use {_setupDecimals}.
663      *
664      * All three of these values are immutable: they can only be set once during
665      * construction.
666      */
667     constructor (string memory name, string memory symbol, uint256 decimals, uint256 burnrate, uint256 initSupply) public {
668         _name = name;
669         _symbol = symbol;
670         _decimals = decimals;
671         _burnRate = burnrate;
672         _totalSupply = 0;
673         _mint(msg.sender, initSupply*(10**_decimals));
674         _burnedSupply = 0;
675     }
676 
677     /**
678      * @dev Returns the name of the token.
679      */
680     function name() public view returns (string memory) {
681         return _name;
682     }
683 
684     /**
685      * @dev Returns the symbol of the token, usually a shorter version of the
686      * name.
687      */
688     function symbol() public view returns (string memory) {
689         return _symbol;
690     }
691 
692     /**
693      * @dev Returns the number of decimals used to get its user representation.
694      * For example, if `decimals` equals `2`, a balance of `505` tokens should
695      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
696      *
697      * Tokens usually opt for a value of 18, imitating the relationship between
698      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
699      * called.
700      *
701      * NOTE: This information is only used for _display_ purposes: it in
702      * no way affects any of the arithmetic of the contract, including
703      * {IERC20-balanceOf} and {IERC20-transfer}.
704      */
705     function decimals() public view returns (uint256) {
706         return _decimals;
707     }
708 
709     /**
710      * @dev See {IERC20-totalSupply}.
711      */
712     function totalSupply() public view override returns (uint256) {
713         return _totalSupply;
714     }
715 
716     /**
717      * @dev Returns the amount of burned tokens.
718      */
719     function burnedSupply() public view returns (uint256) {
720         return _burnedSupply;
721     }
722 
723     /**
724      * @dev Returns the burnrate.
725      */
726     function burnRate() public view returns (uint256) {
727         return _burnRate;
728     }
729 
730     /**
731      * @dev See {IERC20-balanceOf}.
732      */
733     function balanceOf(address account) public view override returns (uint256) {
734         return _balances[account];
735     }
736 
737     /**
738      * @dev See {IERC20-transfer}.
739      *
740      * Requirements:
741      *
742      * - `recipient` cannot be the zero address.
743      * - the caller must have a balance of at least `amount`.
744      */
745     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
746         _transfer(_msgSender(), recipient, amount);
747         return true;
748     }
749 
750     /**
751      * @dev See {IERC20-transfer}.
752      *
753      * Requirements:
754      *
755      * - `account` cannot be the zero address.
756      * - the caller must have a balance of at least `amount`.
757      */
758     function burn(uint256 amount) public virtual returns (bool) {
759         _burn(_msgSender(), amount);
760         return true;
761     }
762 
763     /**
764      * @dev See {IERC20-allowance}.
765      */
766     function allowance(address owner, address spender) public view virtual override returns (uint256) {
767         return _allowances[owner][spender];
768     }
769 
770     /**
771      * @dev See {IERC20-approve}.
772      *
773      * Requirements:
774      *
775      * - `spender` cannot be the zero address.
776      */
777     function approve(address spender, uint256 amount) public virtual override returns (bool) {
778         _approve(_msgSender(), spender, amount);
779         return true;
780     }
781 
782     /**
783      * @dev See {IERC20-transferFrom}.
784      *
785      * Emits an {Approval} event indicating the updated allowance. This is not
786      * required by the EIP. See the note at the beginning of {ERC20};
787      *
788      * Requirements:
789      * - `sender` and `recipient` cannot be the zero address.
790      * - `sender` must have a balance of at least `amount`.
791      * - the caller must have allowance for ``sender``'s tokens of at least
792      * `amount`.
793      */
794     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
795         _transfer(sender, recipient, amount);
796         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
797         return true;
798     }
799 
800     /**
801      * @dev Atomically increases the allowance granted to `spender` by the caller.
802      *
803      * This is an alternative to {approve} that can be used as a mitigation for
804      * problems described in {IERC20-approve}.
805      *
806      * Emits an {Approval} event indicating the updated allowance.
807      *
808      * Requirements:
809      *
810      * - `spender` cannot be the zero address.
811      */
812     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
813         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
814         return true;
815     }
816 
817     /**
818      * @dev Atomically decreases the allowance granted to `spender` by the caller.
819      *
820      * This is an alternative to {approve} that can be used as a mitigation for
821      * problems described in {IERC20-approve}.
822      *
823      * Emits an {Approval} event indicating the updated allowance.
824      *
825      * Requirements:
826      *
827      * - `spender` cannot be the zero address.
828      * - `spender` must have allowance for the caller of at least
829      * `subtractedValue`.
830      */
831     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
832         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
833         return true;
834     }
835 
836     /**
837      * @dev Moves tokens `amount` from `sender` to `recipient`.
838      *
839      * This is internal function is equivalent to {transfer}, and can be used to
840      * e.g. implement automatic token fees, slashing mechanisms, etc.
841      *
842      * Emits a {Transfer} event.
843      *
844      * Requirements:
845      *
846      * - `sender` cannot be the zero address.
847      * - `recipient` cannot be the zero address.
848      * - `sender` must have a balance of at least `amount`.
849      */
850     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
851         require(sender != address(0), "ERC20: transfer from the zero address");
852         require(recipient != address(0), "ERC20: transfer to the zero address");
853         uint256 amount_burn = amount.mul(_burnRate).div(100);
854         uint256 amount_send = amount.sub(amount_burn);
855         require(amount == amount_send + amount_burn, "Burn value invalid");
856         _burn(sender, amount_burn);
857         amount = amount_send;
858         _beforeTokenTransfer(sender, recipient, amount);
859         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
860         _balances[recipient] = _balances[recipient].add(amount);
861         emit Transfer(sender, recipient, amount);
862     }
863 
864     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
865      * the total supply.
866      *
867      * Emits a {Transfer} event with `from` set to the zero address.
868      *
869      * Requirements
870      *
871      * - `to` cannot be the zero address.
872      * 
873      * HINT: This function is 'internal' and therefore can only be called from another
874      * function inside this contract!
875      */
876     function _mint(address account, uint256 amount) internal virtual {
877         require(account != address(0), "ERC20: mint to the zero address");
878         _beforeTokenTransfer(address(0), account, amount);
879         _totalSupply = _totalSupply.add(amount);
880         _balances[account] = _balances[account].add(amount);
881         emit Transfer(address(0), account, amount);
882     }
883 
884     /**
885      * @dev Destroys `amount` tokens from `account`, reducing the
886      * total supply.
887      *
888      * Emits a {Transfer} event with `to` set to the zero address.
889      *
890      * Requirements
891      *
892      * - `account` cannot be the zero address.
893      * - `account` must have at least `amount` tokens.
894      */
895     function _burn(address account, uint256 amount) internal virtual {
896         require(account != address(0), "ERC20: burn from the zero address");
897         _beforeTokenTransfer(account, address(0), amount);
898         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
899         _totalSupply = _totalSupply.sub(amount);
900         _burnedSupply = _burnedSupply.add(amount);
901         emit Transfer(account, address(0), amount);
902     }
903 
904     /**
905      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
906      *
907      * This is internal function is equivalent to `approve`, and can be used to
908      * e.g. set automatic allowances for certain subsystems, etc.
909      *
910      * Emits an {Approval} event.
911      *
912      * Requirements:
913      *
914      * - `owner` cannot be the zero address.
915      * - `spender` cannot be the zero address.
916      */
917     function _approve(address owner, address spender, uint256 amount) internal virtual {
918         require(owner != address(0), "ERC20: approve from the zero address");
919         require(spender != address(0), "ERC20: approve to the zero address");
920         _allowances[owner][spender] = amount;
921         emit Approval(owner, spender, amount);
922     }
923 
924     /**
925      * @dev Sets {burnRate} to a value other than the initial one.
926      */
927     function _setupBurnrate(uint8 burnrate_) internal virtual {
928         _burnRate = burnrate_;
929     }
930 
931     /**
932      * @dev Hook that is called before any transfer of tokens. This includes
933      * minting and burning.
934      *
935      * Calling conditions:
936      *
937      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
938      * will be to transferred to `to`.
939      * - when `from` is zero, `amount` tokens will be minted for `to`.
940      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
941      * - `from` and `to` are never both zero.
942      *
943      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
944      */
945     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
946 }
947 
948 // PrinterToken with Governance.
949 //                       ERC20 (name, symbol, decimals, burnrate, initSupply)
950 contract Token is ERC20("Printer.Finance", "PRINT", 18, 0, 1200), Ownable, Mintable {
951     function mint(address _to, uint256 _amount) public onlyMinter {
952         _mint(_to, _amount);
953     }
954     function setupBurnrate(uint8 burnrate_) public onlyOwner {
955         _setupBurnrate(burnrate_);
956     }
957 }
958 
959 contract PrinterMasterChef is Ownable {
960     using SafeMath for uint256;
961     using SafeERC20 for IERC20;
962 
963     // Info of each user.
964     struct UserInfo {
965         uint256 amount;     // How many LP tokens the user has provided.
966         uint256 rewardDebt; // Reward debt. See explanation below.
967         //
968         // We do some fancy math here. Basically, any point in time, the amount of 
969         // claimable PRINTs by a user is:
970         //
971         //   pending reward = (user.amount * pool.accPrintPerLPShare) - user.rewardDebt
972         //
973         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
974         //   1. The pool's `accPrintPerLPShare` (and `lastRewardedBlock`) gets updated.
975         //   2. User receives the pending reward sent to his/her address.
976         //   3. User's `amount` gets updated.
977         //   4. User's `rewardDebt` gets updated.
978     }
979 
980     // Info of each pool.
981     struct PoolInfo {
982         IERC20 lpTokenContract;     // Address of LP token contract.
983         string name;                // Name of the pool/pair.
984         uint256 allocPoints;        // Allocation points from the pool.
985         uint256 lastRewardedBlock;  // Last block number where PRINT distribution occured.
986         uint256 accPrintPerLPShare; // Accumulated PRINTs per share.
987         uint256 lpTokenHolding;     // Amount of LP token hold by this pool
988     }
989 
990     // Info of PRINT minting
991     struct MintInfo {
992         uint256 printPerBlock;  // Amount of minted PRINT each block.
993         uint256 mintStartBlock; // Minting of this amount starts here.
994     }
995 
996     // The PRINT token contract
997     Token public printer;
998     
999     // Dev address. (Only needed for secretly minting. We don't do that!)
1000     // address public devaddr;
1001 
1002     // Info of each pool.
1003     PoolInfo[] public poolInfo;
1004     // Info of PRINT minting block span.
1005     MintInfo[] public mintInfo;
1006     
1007     // Info of each user that stakes LP tokens.
1008     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
1009     // Total allocation points. Must be the sum of all allocation points in all pools.
1010     uint256 public totalAllocPoints = 0;
1011 
1012     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
1013     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
1014     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
1015 
1016     constructor(
1017         Token _printer,
1018         // address _devaddr,
1019         uint256 _printPerBlock,
1020         uint256 _mintStartBlock
1021     ) public {
1022         printer = _printer;
1023         // devaddr = _devaddr;
1024         mintInfo.push(MintInfo({
1025             printPerBlock: _printPerBlock,
1026             mintStartBlock: _mintStartBlock
1027         }));
1028     }
1029     
1030     // Get current mint per block
1031     function currentMint() external view returns (uint256){
1032         for(uint256 i = 0; i < mintInfo.length-1; i++){
1033             if(mintInfo[i].mintStartBlock <= block.number && mintInfo[i+1].mintStartBlock > block.number){
1034                 return i;
1035             }
1036         }
1037         if(block.number < mintInfo[0].mintStartBlock) {
1038             return 99999;
1039         }
1040         return mintInfo.length-1;
1041     }
1042 
1043     // Amount of block spans for minting different amounts of PRINT
1044     function mintLength() external view returns (uint256) {
1045         return mintInfo.length;
1046     }
1047     
1048     // Return if farming already started or not 
1049     function farmingActive() external view returns (bool){
1050         return block.number >= mintInfo[0].mintStartBlock;
1051     }
1052     
1053     // Add a new block and mint amount to the mintInfo list. Can only be called by the owner.
1054     // Only possible to change for blocks not already mined.
1055     function addMint(uint256 _block, uint256 _amount) public onlyOwner {
1056         require(_block > block.number + 10, "_block is already mined or too close on getting mined.");
1057         mintInfo.push(MintInfo({
1058             printPerBlock: _amount,
1059             mintStartBlock: _block
1060         }));
1061     }
1062     
1063     // Update the fiven blockspans startblock and mint amount. Can only be called by the owner.
1064     // Only possible to change for blocks not already mined.
1065     function setMint(uint256 _mid, uint256 _block, uint256 _amount) public onlyOwner {
1066         require(_block > block.number + 10, "_block is already mined or too close on getting mined.");
1067         require(mintInfo[_mid].mintStartBlock > block.number + 10, "mintStartBlock is already mined or too close on getting mined.");
1068         mintInfo[_mid].printPerBlock = _amount;
1069         mintInfo[_mid].mintStartBlock = _block;
1070     }
1071     
1072     // Deletes a given blockspan for minting. You can't delete first one. Can only be called by the owner.
1073     // Only possible to change for blocks not already mined.
1074     function deleteMint(uint256 _mid) public onlyOwner {
1075         require(_mid != 0, "You can't delete the first blockspan!");
1076         require(_mid < mintInfo.length, "_mid is invalid!");
1077         require(mintInfo[_mid].mintStartBlock > block.number + 10, "_block is already mined or too close on getting mined.");
1078         for(uint256 i = _mid; i < mintInfo.length - 1; i++){
1079             mintInfo[i] = mintInfo[i+1];
1080         }
1081         mintInfo.pop();
1082     }
1083 
1084     // Amount of pairs available for farming
1085     function poolLength() external view returns (uint256) {
1086         return poolInfo.length;
1087     }
1088     
1089     // Add a new LP contract to the pool. Can only be called by the owner.
1090     // !!! DO NOT add the same LP token more than once. Rewards will be messed up if you do !!!
1091     function addLP(string memory _name, uint256 _allocPoints, IERC20 _lpTokenContract, bool _withUpdate) public onlyOwner {
1092         if (_withUpdate) {
1093             massUpdatePools();
1094         }
1095         uint256 lastRewardedBlock = block.number > mintInfo[0].mintStartBlock ? block.number : mintInfo[0].mintStartBlock;
1096         totalAllocPoints = totalAllocPoints.add(_allocPoints);
1097         poolInfo.push(PoolInfo({
1098             lpTokenContract: _lpTokenContract,
1099             name: _name,
1100             allocPoints: _allocPoints,
1101             lastRewardedBlock: lastRewardedBlock,
1102             accPrintPerLPShare: 0,
1103             lpTokenHolding: 0
1104         }));
1105     }
1106 
1107     // Update the given pools allocation points. Can only be called by the owner.
1108     function setLP(uint256 _pid, string memory _name, uint256 _allocPoints, bool _withUpdate) public onlyOwner {
1109         if (_withUpdate) {
1110             massUpdatePools();
1111         }
1112         totalAllocPoints = totalAllocPoints.sub(poolInfo[_pid].allocPoints).add(_allocPoints);
1113         poolInfo[_pid].name = _name;
1114         poolInfo[_pid].allocPoints = _allocPoints;
1115     }
1116 
1117     // Return rewards over the given span from _from block to _to block.
1118     function getPrintAmountInRange(uint256 _from, uint256 _to) public view returns (uint256) {
1119         if(_from >= _to){
1120             return 0;
1121         }
1122         uint256 reward = 0;
1123         uint256 blocksleft = _to.sub(_from);
1124         for( uint256 cblock = _from+1; cblock <= _to; cblock++){
1125             if(cblock < mintInfo[0].mintStartBlock){
1126                 blocksleft--;
1127             }
1128         }
1129         for( uint256 i = 0; i < mintInfo.length-1; i++){
1130             for( uint256 cblock = _from+1; cblock <= _to; cblock++){
1131                 if(cblock >= mintInfo[i].mintStartBlock && cblock < mintInfo[i+1].mintStartBlock){
1132                     reward += mintInfo[i].printPerBlock;
1133                     blocksleft--;
1134                 }
1135             }
1136         }
1137         reward += blocksleft.mul(mintInfo[mintInfo.length-1].printPerBlock);
1138         return reward;
1139     }
1140 
1141     // View function to see pending PRINTs on frontend.
1142     function pendingPrinter(uint256 _pid, address _user) public returns (uint256) {
1143         PoolInfo storage pool = poolInfo[_pid];
1144         UserInfo storage user = userInfo[_pid][_user];
1145         uint256 accPrintPerLPShare = pool.accPrintPerLPShare;
1146         // Users LP tokens who is connected to the site
1147         uint256 lpSupply = pool.lpTokenContract.balanceOf(address(this));
1148         pool.lpTokenHolding = lpSupply;
1149         if (block.number > pool.lastRewardedBlock && lpSupply > 0) {
1150             uint256 printerReward = getPrintAmountInRange(pool.lastRewardedBlock, block.number).mul(pool.allocPoints).div(totalAllocPoints);
1151             printerReward = printerReward.mul(1e18);
1152             accPrintPerLPShare = accPrintPerLPShare.add(printerReward.div(lpSupply));
1153         }
1154         return user.amount.mul(accPrintPerLPShare).div(1e18).sub(user.rewardDebt);
1155     }
1156 
1157     // Update reward vairables for all pools. Be careful of gas spending!
1158     function massUpdatePools() public {
1159         uint256 length = poolInfo.length;
1160         for (uint256 pid = 0; pid < length; ++pid) {
1161             updatePool(pid);
1162         }
1163     }
1164 
1165     // Update reward variables of the given pool to be up-to-date.
1166     function updatePool(uint256 _pid) public {
1167         PoolInfo storage pool = poolInfo[_pid];
1168         if (block.number <= pool.lastRewardedBlock) {
1169             return;
1170         }
1171         uint256 lpSupply = pool.lpTokenContract.balanceOf(address(this));
1172         pool.lpTokenHolding = lpSupply;
1173         if (lpSupply == 0) {
1174             pool.lastRewardedBlock = block.number;
1175             return;
1176         }
1177         uint256 printerReward = getPrintAmountInRange(pool.lastRewardedBlock, block.number).mul(pool.allocPoints).div(totalAllocPoints);
1178         //printer.mint(devaddr, printerReward.div(5)); // (Sushi has 10% of this shit!)
1179         printer.mint(address(this), printerReward);
1180         printerReward = printerReward.mul(1e18);
1181         pool.accPrintPerLPShare = pool.accPrintPerLPShare.add(printerReward.div(lpSupply));
1182         pool.lastRewardedBlock = block.number;
1183     }
1184 
1185     // Deposit LP tokens to MasterChef for PRINT allocation.
1186     // Also used to claim the users pending PRINT tokens (_amount = 0)
1187     function deposit(uint256 _pid, uint256 _amount) public {
1188         PoolInfo storage pool = poolInfo[_pid];
1189         UserInfo storage user = userInfo[_pid][msg.sender];
1190         updatePool(_pid);
1191         if (user.amount > 0) {
1192             uint256 pending = user.amount.mul(pool.accPrintPerLPShare).sub(user.rewardDebt);
1193             safePrinterTransfer(msg.sender, pending);
1194         }
1195         pool.lpTokenContract.safeTransferFrom(address(msg.sender), address(this), _amount);
1196         user.amount = user.amount.add(_amount);
1197         user.rewardDebt = user.amount.mul(pool.accPrintPerLPShare).div(1e18);
1198         emit Deposit(msg.sender, _pid, _amount);
1199     }
1200 
1201     // Withdraw LP tokens from MasterChef.
1202     // Also used to claim the users pending PRINT tokens
1203     function withdraw(uint256 _pid, uint256 _amount) public {
1204         PoolInfo storage pool = poolInfo[_pid];
1205         UserInfo storage user = userInfo[_pid][msg.sender];
1206         require(user.amount >= _amount, "withdraw: not good");
1207         updatePool(_pid);
1208         uint256 pending = user.amount.mul(pool.accPrintPerLPShare).sub(user.rewardDebt);
1209         safePrinterTransfer(msg.sender, pending);
1210         user.amount = user.amount.sub(_amount);
1211         user.rewardDebt = user.amount.mul(pool.accPrintPerLPShare).div(1e18);
1212         pool.lpTokenContract.safeTransfer(address(msg.sender), _amount);
1213         emit Withdraw(msg.sender, _pid, _amount);
1214     }
1215 
1216     // Withdraw without caring about rewards. EMERGENCY ONLY.
1217     function emergencyWithdraw(uint256 _pid) public {
1218         PoolInfo storage pool = poolInfo[_pid];
1219         UserInfo storage user = userInfo[_pid][msg.sender];
1220         pool.lpTokenContract.safeTransfer(address(msg.sender), user.amount);
1221         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1222         user.amount = 0;
1223         user.rewardDebt = 0;
1224     }
1225 
1226     // Safe PRINT transfer function, just in case if rounding error causes pool to not have enough PRINTERs.
1227     function safePrinterTransfer(address _to, uint256 _amount) internal {
1228         uint256 printerBal = printer.balanceOf(address(this));
1229         if (_amount > printerBal) {
1230             printer.transfer(_to, printerBal);
1231         } else {
1232             printer.transfer(_to, _amount);
1233         }
1234     }
1235     
1236     // Update dev address by the previous dev. (We don't need this here!)
1237     // function dev(address _devaddr) public {
1238     //   require(msg.sender == devaddr, "dev: wut?");
1239     //   devaddr = _devaddr;
1240     //}
1241 }