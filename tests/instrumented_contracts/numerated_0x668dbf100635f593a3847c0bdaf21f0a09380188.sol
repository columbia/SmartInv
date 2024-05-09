1 /*
2 
3 website: bns.finance
4 
5 
6 BBBBBBBBBBBBBBBBB   NNNNNNNN        NNNNNNNN   SSSSSSSSSSSSSSS         DDDDDDDDDDDDD      EEEEEEEEEEEEEEEEEEEEEEFFFFFFFFFFFFFFFFFFFFFFIIIIIIIIII
7 B::::::::::::::::B  N:::::::N       N::::::N SS:::::::::::::::S        D::::::::::::DDD   E::::::::::::::::::::EF::::::::::::::::::::FI::::::::I
8 B::::::BBBBBB:::::B N::::::::N      N::::::NS:::::SSSSSS::::::S        D:::::::::::::::DD E::::::::::::::::::::EF::::::::::::::::::::FI::::::::I
9 BB:::::B     B:::::BN:::::::::N     N::::::NS:::::S     SSSSSSS        DDD:::::DDDDD:::::DEE::::::EEEEEEEEE::::EFF::::::FFFFFFFFF::::FII::::::II
10   B::::B     B:::::BN::::::::::N    N::::::NS:::::S                      D:::::D    D:::::D E:::::E       EEEEEE  F:::::F       FFFFFF  I::::I  
11   B::::B     B:::::BN:::::::::::N   N::::::NS:::::S                      D:::::D     D:::::DE:::::E               F:::::F               I::::I  
12   B::::BBBBBB:::::B N:::::::N::::N  N::::::N S::::SSSS                   D:::::D     D:::::DE::::::EEEEEEEEEE     F::::::FFFFFFFFFF     I::::I  
13   B:::::::::::::BB  N::::::N N::::N N::::::N  SS::::::SSSSS              D:::::D     D:::::DE:::::::::::::::E     F:::::::::::::::F     I::::I  
14   B::::BBBBBB:::::B N::::::N  N::::N:::::::N    SSS::::::::SS            D:::::D     D:::::DE:::::::::::::::E     F:::::::::::::::F     I::::I  
15   B::::B     B:::::BN::::::N   N:::::::::::N       SSSSSS::::S           D:::::D     D:::::DE::::::EEEEEEEEEE     F::::::FFFFFFFFFF     I::::I  
16   B::::B     B:::::BN::::::N    N::::::::::N            S:::::S          D:::::D     D:::::DE:::::E               F:::::F               I::::I  
17   B::::B     B:::::BN::::::N     N:::::::::N            S:::::S          D:::::D    D:::::D E:::::E       EEEEEE  F:::::F               I::::I  
18 BB:::::BBBBBB::::::BN::::::N      N::::::::NSSSSSSS     S:::::S        DDD:::::DDDDD:::::DEE::::::EEEEEEEE:::::EFF:::::::FF           II::::::II
19 B:::::::::::::::::B N::::::N       N:::::::NS::::::SSSSSS:::::S ...... D:::::::::::::::DD E::::::::::::::::::::EF::::::::FF           I::::::::I
20 B::::::::::::::::B  N::::::N        N::::::NS:::::::::::::::SS  .::::. D::::::::::::DDD   E::::::::::::::::::::EF::::::::FF           I::::::::I
21 BBBBBBBBBBBBBBBBB   NNNNNNNN         NNNNNNN SSSSSSSSSSSSSSS    ...... DDDDDDDDDDDDD      EEEEEEEEEEEEEEEEEEEEEEFFFFFFFFFFF           IIIIIIIIII
22                                                                                                                                                                                       
23                                                          
24 
25 BNS defi token
26 
27 */
28 
29 pragma solidity ^0.6.12;
30 /*
31  * @dev Provides information about the current execution context, including the
32  * sender of the transaction and its data. While these are generally available
33  * via msg.sender and msg.data, they should not be accessed in such a direct
34  * manner, since when dealing with GSN meta-transactions the account sending and
35  * paying for execution may not be the actual sender (as far as an application
36  * is concerned).
37  *
38  * This contract is only required for intermediate, library-like contracts.
39  */
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address payable) {
42         return msg.sender;
43     }
44 
45     function _msgData() internal view virtual returns (bytes memory) {
46         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
47         return msg.data;
48     }
49 }
50 
51 /**
52  * @dev Interface of the ERC20 standard as defined in the EIP.
53  */
54 interface IERC20 {
55     /**
56      * @dev Returns the amount of tokens in existence.
57      */
58     function totalSupply() external view returns (uint256);
59 
60     /**
61      * @dev Returns the amount of tokens owned by `account`.
62      */
63     function balanceOf(address account) external view returns (uint256);
64 
65     /**
66      * @dev Moves `amount` tokens from the caller's account to `recipient`.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * Emits a {Transfer} event.
71      */
72     function transfer(address recipient, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Returns the remaining number of tokens that `spender` will be
76      * allowed to spend on behalf of `owner` through {transferFrom}. This is
77      * zero by default.
78      *
79      * This value changes when {approve} or {transferFrom} are called.
80      */
81     function allowance(address owner, address spender) external view returns (uint256);
82 
83     /**
84      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * IMPORTANT: Beware that changing an allowance with this method brings the risk
89      * that someone may use both the old and the new allowance by unfortunate
90      * transaction ordering. One possible solution to mitigate this race
91      * condition is to first reduce the spender's allowance to 0 and set the
92      * desired value afterwards:
93      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
94      *
95      * Emits an {Approval} event.
96      */
97     function approve(address spender, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Moves `amount` tokens from `sender` to `recipient` using the
101      * allowance mechanism. `amount` is then deducted from the caller's
102      * allowance.
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      *
106      * Emits a {Transfer} event.
107      */
108     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
109 
110     /**
111      * @dev Emitted when `value` tokens are moved from one account (`from`) to
112      * another (`to`).
113      *
114      * Note that `value` may be zero.
115      */
116     event Transfer(address indexed from, address indexed to, uint256 value);
117 
118     /**
119      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
120      * a call to {approve}. `value` is the new allowance.
121      */
122     event Approval(address indexed owner, address indexed spender, uint256 value);
123 }
124 
125 /**
126  * @dev Wrappers over Solidity's arithmetic operations with added overflow
127  * checks.
128  *
129  * Arithmetic operations in Solidity wrap on overflow. This can easily result
130  * in bugs, because programmers usually assume that an overflow raises an
131  * error, which is the standard behavior in high level programming languages.
132  * `SafeMath` restores this intuition by reverting the transaction when an
133  * operation overflows.
134  *
135  * Using this library instead of the unchecked operations eliminates an entire
136  * class of bugs, so it's recommended to use it always.
137  */
138 library SafeMath {
139     /**
140      * @dev Returns the addition of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `+` operator.
144      *
145      * Requirements:
146      *
147      * - Addition cannot overflow.
148      */
149     function add(uint256 a, uint256 b) internal pure returns (uint256) {
150         uint256 c = a + b;
151         require(c >= a, "SafeMath: addition overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167         return sub(a, b, "SafeMath: subtraction overflow");
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
181         require(b <= a, errorMessage);
182         uint256 c = a - b;
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the multiplication of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `*` operator.
192      *
193      * Requirements:
194      *
195      * - Multiplication cannot overflow.
196      */
197     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
198         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
199         // benefit is lost if 'b' is also tested.
200         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
201         if (a == 0) {
202             return 0;
203         }
204 
205         uint256 c = a * b;
206         require(c / a == b, "SafeMath: multiplication overflow");
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(uint256 a, uint256 b) internal pure returns (uint256) {
224         return div(a, b, "SafeMath: division by zero");
225     }
226 
227     /**
228      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
229      * division by zero. The result is rounded towards zero.
230      *
231      * Counterpart to Solidity's `/` operator. Note: this function uses a
232      * `revert` opcode (which leaves remaining gas untouched) while Solidity
233      * uses an invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b > 0, errorMessage);
241         uint256 c = a / b;
242         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260         return mod(a, b, "SafeMath: modulo by zero");
261     }
262 
263     /**
264      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
265      * Reverts with custom message when dividing by zero.
266      *
267      * Counterpart to Solidity's `%` operator. This function uses a `revert`
268      * opcode (which leaves remaining gas untouched) while Solidity uses an
269      * invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b != 0, errorMessage);
277         return a % b;
278     }
279 }
280 
281 
282 /**
283  * @dev Collection of functions related to the address type
284  */
285 library Address {
286     /**
287      * @dev Returns true if `account` is a contract.
288      *
289      * [IMPORTANT]
290      * ====
291      * It is unsafe to assume that an address for which this function returns
292      * false is an externally-owned account (EOA) and not a contract.
293      *
294      * Among others, `isContract` will return false for the following
295      * types of addresses:
296      *
297      *  - an externally-owned account
298      *  - a contract in construction
299      *  - an address where a contract will be created
300      *  - an address where a contract lived, but was destroyed
301      * ====
302      */
303     function isContract(address account) internal view returns (bool) {
304         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
305         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
306         // for accounts without code, i.e. `keccak256('')`
307         bytes32 codehash;
308         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
309         // solhint-disable-next-line no-inline-assembly
310         assembly { codehash := extcodehash(account) }
311         return (codehash != accountHash && codehash != 0x0);
312     }
313 
314     /**
315      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
316      * `recipient`, forwarding all available gas and reverting on errors.
317      *
318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
320      * imposed by `transfer`, making them unable to receive funds via
321      * `transfer`. {sendValue} removes this limitation.
322      *
323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
324      *
325      * IMPORTANT: because control is transferred to `recipient`, care must be
326      * taken to not create reentrancy vulnerabilities. Consider using
327      * {ReentrancyGuard} or the
328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(address(this).balance >= amount, "Address: insufficient balance");
332 
333         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
334         (bool success, ) = recipient.call{ value: amount }("");
335         require(success, "Address: unable to send value, recipient may have reverted");
336     }
337 
338     /**
339      * @dev Performs a Solidity function call using a low level `call`. A
340      * plain`call` is an unsafe replacement for a function call: use this
341      * function instead.
342      *
343      * If `target` reverts with a revert reason, it is bubbled up by this
344      * function (like regular Solidity function calls).
345      *
346      * Returns the raw returned data. To convert to the expected return value,
347      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
348      *
349      * Requirements:
350      *
351      * - `target` must be a contract.
352      * - calling `target` with `data` must not revert.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
357       return functionCall(target, data, "Address: low-level call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
362      * `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
367         return _functionCallWithValue(target, data, 0, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but also transferring `value` wei to `target`.
373      *
374      * Requirements:
375      *
376      * - the calling contract must have an ETH balance of at least `value`.
377      * - the called Solidity function must be `payable`.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
387      * with `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
392         require(address(this).balance >= value, "Address: insufficient balance for call");
393         return _functionCallWithValue(target, data, value, errorMessage);
394     }
395 
396     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
397         require(isContract(target), "Address: call to non-contract");
398 
399         // solhint-disable-next-line avoid-low-level-calls
400         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
401         if (success) {
402             return returndata;
403         } else {
404             // Look for revert reason and bubble it up if present
405             if (returndata.length > 0) {
406                 // The easiest way to bubble the revert reason is using memory via assembly
407 
408                 // solhint-disable-next-line no-inline-assembly
409                 assembly {
410                     let returndata_size := mload(returndata)
411                     revert(add(32, returndata), returndata_size)
412                 }
413             } else {
414                 revert(errorMessage);
415             }
416         }
417     }
418 }
419 
420 /**
421  * @title SafeERC20
422  * @dev Wrappers around ERC20 operations that throw on failure (when the token
423  * contract returns false). Tokens that return no value (and instead revert or
424  * throw on failure) are also supported, non-reverting calls are assumed to be
425  * successful.
426  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
427  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
428  */
429 library SafeERC20 {
430     using SafeMath for uint256;
431     using Address for address;
432 
433     function safeTransfer(IERC20 token, address to, uint256 value) internal {
434         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
435     }
436 
437     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
438         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
439     }
440 
441     /**
442      * @dev Deprecated. This function has issues similar to the ones found in
443      * {IERC20-approve}, and its usage is discouraged.
444      *
445      * Whenever possible, use {safeIncreaseAllowance} and
446      * {safeDecreaseAllowance} instead.
447      */
448     function safeApprove(IERC20 token, address spender, uint256 value) internal {
449         // safeApprove should only be called when setting an initial allowance,
450         // or when resetting it to zero. To increase and decrease it, use
451         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
452         // solhint-disable-next-line max-line-length
453         require((value == 0) || (token.allowance(address(this), spender) == 0),
454             "SafeERC20: approve from non-zero to non-zero allowance"
455         );
456         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
457     }
458 
459     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
460         uint256 newAllowance = token.allowance(address(this), spender).add(value);
461         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
462     }
463 
464     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
465         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
466         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
467     }
468 
469     /**
470      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
471      * on the return value: the return value is optional (but if data is returned, it must not be false).
472      * @param token The token targeted by the call.
473      * @param data The call data (encoded using abi.encode or one of its variants).
474      */
475     function _callOptionalReturn(IERC20 token, bytes memory data) private {
476         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
477         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
478         // the target address contains contract code and also asserts for success in the low-level call.
479 
480         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
481         if (returndata.length > 0) { // Return data is optional
482             // solhint-disable-next-line max-line-length
483             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
484         }
485     }
486 }
487 
488 
489 
490 /**
491  * @dev Contract module which provides a basic access control mechanism, where
492  * there is an account (an owner) that can be granted exclusive access to
493  * specific functions.
494  *
495  * By default, the owner account will be the one that deploys the contract. This
496  * can later be changed with {transferOwnership}.
497  *
498  * This module is used through inheritance. It will make available the modifier
499  * `onlyOwner`, which can be applied to your functions to restrict their use to
500  * the owner.
501  */
502 contract Ownable is Context {
503     address private _owner;
504 
505     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
506 
507     /**
508      * @dev Initializes the contract setting the deployer as the initial owner.
509      */
510     constructor () internal {
511         address msgSender = _msgSender();
512         _owner = msgSender;
513         emit OwnershipTransferred(address(0), msgSender);
514     }
515 
516     /**
517      * @dev Returns the address of the current owner.
518      */
519     function owner() public view returns (address) {
520         return _owner;
521     }
522 
523     /**
524      * @dev Throws if called by any account other than the owner.
525      */
526     modifier onlyOwner() {
527         require(_owner == _msgSender(), "Ownable: caller is not the owner");
528         _;
529     }
530 
531     /**
532      * @dev Leaves the contract without owner. It will not be possible to call
533      * `onlyOwner` functions anymore. Can only be called by the current owner.
534      *
535      * NOTE: Renouncing ownership will leave the contract without an owner,
536      * thereby removing any functionality that is only available to the owner.
537      */
538     function renounceOwnership() public virtual onlyOwner {
539         emit OwnershipTransferred(_owner, address(0));
540         _owner = address(0);
541     }
542 
543     /**
544      * @dev Transfers ownership of the contract to a new account (`newOwner`).
545      * Can only be called by the current owner.
546      */
547     function transferOwnership(address newOwner) public virtual onlyOwner {
548         require(newOwner != address(0), "Ownable: new owner is the zero address");
549         emit OwnershipTransferred(_owner, newOwner);
550         _owner = newOwner;
551     }
552 }
553 
554 
555 /**
556  * @dev Implementation of the {IERC20} interface.
557  *
558  * This implementation is agnostic to the way tokens are created. This means
559  * that a supply mechanism has to be added in a derived contract using {_mint}.
560  * For a generic mechanism see {ERC20PresetMinterPauser}.
561  *
562  * TIP: For a detailed writeup see our guide
563  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
564  * to implement supply mechanisms].
565  *
566  * We have followed general OpenZeppelin guidelines: functions revert instead
567  * of returning `false` on failure. This behavior is nonetheless conventional
568  * and does not conflict with the expectations of ERC20 applications.
569  *
570  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
571  * This allows applications to reconstruct the allowance for all accounts just
572  * by listening to said events. Other implementations of the EIP may not emit
573  * these events, as it isn't required by the specification.
574  *
575  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
576  * functions have been added to mitigate the well-known issues around setting
577  * allowances. See {IERC20-approve}.
578  */
579 contract ERC20 is Context, IERC20 {
580     using SafeMath for uint256;
581     using Address for address;
582 
583     mapping (address => uint256) private _balances;
584 
585     mapping (address => mapping (address => uint256)) private _allowances;
586 
587     uint256 private _totalSupply;
588 
589     string private _name;
590     string private _symbol;
591     uint8 private _decimals;
592 
593     /**
594      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
595      * a default value of 18.
596      *
597      * To select a different value for {decimals}, use {_setupDecimals}.
598      *
599      * All three of these values are immutable: they can only be set once during
600      * construction.
601      */
602     constructor (string memory name, string memory symbol) public {
603         _name = name;
604         _symbol = symbol;
605         _decimals = 18;
606     }
607 
608     /**
609      * @dev Returns the name of the token.
610      */
611     function name() public view returns (string memory) {
612         return _name;
613     }
614 
615     /**
616      * @dev Returns the symbol of the token, usually a shorter version of the
617      * name.
618      */
619     function symbol() public view returns (string memory) {
620         return _symbol;
621     }
622 
623     /**
624      * @dev Returns the number of decimals used to get its user representation.
625      * For example, if `decimals` equals `2`, a balance of `505` tokens should
626      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
627      *
628      * Tokens usually opt for a value of 18, imitating the relationship between
629      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
630      * called.
631      *
632      * NOTE: This information is only used for _display_ purposes: it in
633      * no way affects any of the arithmetic of the contract, including
634      * {IERC20-balanceOf} and {IERC20-transfer}.
635      */
636     function decimals() public view returns (uint8) {
637         return _decimals;
638     }
639 
640     /**
641      * @dev See {IERC20-totalSupply}.
642      */
643     function totalSupply() public view override returns (uint256) {
644         return _totalSupply;
645     }
646 
647     /**
648      * @dev See {IERC20-balanceOf}.
649      */
650     function balanceOf(address account) public view override returns (uint256) {
651         return _balances[account];
652     }
653 
654     /**
655      * @dev See {IERC20-transfer}.
656      *
657      * Requirements:
658      *
659      * - `recipient` cannot be the zero address.
660      * - the caller must have a balance of at least `amount`.
661      */
662     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
663         _transfer(_msgSender(), recipient, amount);
664         return true;
665     }
666 
667     /**
668      * @dev See {IERC20-allowance}.
669      */
670     function allowance(address owner, address spender) public view virtual override returns (uint256) {
671         return _allowances[owner][spender];
672     }
673 
674     /**
675      * @dev See {IERC20-approve}.
676      *
677      * Requirements:
678      *
679      * - `spender` cannot be the zero address.
680      */
681     function approve(address spender, uint256 amount) public virtual override returns (bool) {
682         _approve(_msgSender(), spender, amount);
683         return true;
684     }
685 
686     /**
687      * @dev See {IERC20-transferFrom}.
688      *
689      * Emits an {Approval} event indicating the updated allowance. This is not
690      * required by the EIP. See the note at the beginning of {ERC20};
691      *
692      * Requirements:
693      * - `sender` and `recipient` cannot be the zero address.
694      * - `sender` must have a balance of at least `amount`.
695      * - the caller must have allowance for ``sender``'s tokens of at least
696      * `amount`.
697      */
698     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
699         _transfer(sender, recipient, amount);
700         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
701         return true;
702     }
703 
704     /**
705      * @dev Atomically increases the allowance granted to `spender` by the caller.
706      *
707      * This is an alternative to {approve} that can be used as a mitigation for
708      * problems described in {IERC20-approve}.
709      *
710      * Emits an {Approval} event indicating the updated allowance.
711      *
712      * Requirements:
713      *
714      * - `spender` cannot be the zero address.
715      */
716     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
717         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
718         return true;
719     }
720 
721     /**
722      * @dev Atomically decreases the allowance granted to `spender` by the caller.
723      *
724      * This is an alternative to {approve} that can be used as a mitigation for
725      * problems described in {IERC20-approve}.
726      *
727      * Emits an {Approval} event indicating the updated allowance.
728      *
729      * Requirements:
730      *
731      * - `spender` cannot be the zero address.
732      * - `spender` must have allowance for the caller of at least
733      * `subtractedValue`.
734      */
735     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
736         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
737         return true;
738     }
739 
740     /**
741      * @dev Moves tokens `amount` from `sender` to `recipient`.
742      *
743      * This is internal function is equivalent to {transfer}, and can be used to
744      * e.g. implement automatic token fees, slashing mechanisms, etc.
745      *
746      * Emits a {Transfer} event.
747      *
748      * Requirements:
749      *
750      * - `sender` cannot be the zero address.
751      * - `recipient` cannot be the zero address.
752      * - `sender` must have a balance of at least `amount`.
753      */
754     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
755         require(sender != address(0), "ERC20: transfer from the zero address");
756         require(recipient != address(0), "ERC20: transfer to the zero address");
757 
758         _beforeTokenTransfer(sender, recipient, amount);
759 
760         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
761         _balances[recipient] = _balances[recipient].add(amount);
762         emit Transfer(sender, recipient, amount);
763     }
764 
765     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
766      * the total supply.
767      *
768      * Emits a {Transfer} event with `from` set to the zero address.
769      *
770      * Requirements
771      *
772      * - `to` cannot be the zero address.
773      */
774     function _mint(address account, uint256 amount) internal virtual {
775         require(account != address(0), "ERC20: mint to the zero address");
776 
777         _beforeTokenTransfer(address(0), account, amount);
778 
779         _totalSupply = _totalSupply.add(amount);
780         _balances[account] = _balances[account].add(amount);
781         emit Transfer(address(0), account, amount);
782     }
783 
784     /**
785      * @dev Destroys `amount` tokens from `account`, reducing the
786      * total supply.
787      *
788      * Emits a {Transfer} event with `to` set to the zero address.
789      *
790      * Requirements
791      *
792      * - `account` cannot be the zero address.
793      * - `account` must have at least `amount` tokens.
794      */
795     function _burn(address account, uint256 amount) internal virtual {
796         require(account != address(0), "ERC20: burn from the zero address");
797 
798         _beforeTokenTransfer(account, address(0), amount);
799 
800         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
801         _totalSupply = _totalSupply.sub(amount);
802         emit Transfer(account, address(0), amount);
803     }
804 
805     /**
806      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
807      *
808      * This is internal function is equivalent to `approve`, and can be used to
809      * e.g. set automatic allowances for certain subsystems, etc.
810      *
811      * Emits an {Approval} event.
812      *
813      * Requirements:
814      *
815      * - `owner` cannot be the zero address.
816      * - `spender` cannot be the zero address.
817      */
818     function _approve(address owner, address spender, uint256 amount) internal virtual {
819         require(owner != address(0), "ERC20: approve from the zero address");
820         require(spender != address(0), "ERC20: approve to the zero address");
821 
822         _allowances[owner][spender] = amount;
823         emit Approval(owner, spender, amount);
824     }
825 
826     /**
827      * @dev Sets {decimals} to a value other than the default one of 18.
828      *
829      * WARNING: This function should only be called from the constructor. Most
830      * applications that interact with token contracts will not expect
831      * {decimals} to ever change, and may work incorrectly if it does.
832      */
833     function _setupDecimals(uint8 decimals_) internal {
834         _decimals = decimals_;
835     }
836 
837     /**
838      * @dev Hook that is called before any transfer of tokens. This includes
839      * minting and burning.
840      *
841      * Calling conditions:
842      *
843      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
844      * will be to transferred to `to`.
845      * - when `from` is zero, `amount` tokens will be minted for `to`.
846      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
847      * - `from` and `to` are never both zero.
848      *
849      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
850      */
851     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
852 }
853 
854 // BnsdToken with Governance.
855 contract BnsdToken is ERC20("bns.finance", "BNSD"), Ownable {
856     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
857     function mint(address _to, uint256 _amount) public onlyOwner {
858         _mint(_to, _amount);
859     }
860 }