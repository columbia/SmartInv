1 /* 
2 
3 website: bns.finance
4 
5 This project was forked from SUSHI and YUNO projects with a twist of halving.
6 
7 Unless those projects have severe vulnerabilities, this contract will be fine
8     
9 
10 
11 BBBBBBBBBBBBBBBBB   NNNNNNNN        NNNNNNNN   SSSSSSSSSSSSSSS         DDDDDDDDDDDDD      EEEEEEEEEEEEEEEEEEEEEEFFFFFFFFFFFFFFFFFFFFFFIIIIIIIIII
12 B::::::::::::::::B  N:::::::N       N::::::N SS:::::::::::::::S        D::::::::::::DDD   E::::::::::::::::::::EF::::::::::::::::::::FI::::::::I
13 B::::::BBBBBB:::::B N::::::::N      N::::::NS:::::SSSSSS::::::S        D:::::::::::::::DD E::::::::::::::::::::EF::::::::::::::::::::FI::::::::I
14 BB:::::B     B:::::BN:::::::::N     N::::::NS:::::S     SSSSSSS        DDD:::::DDDDD:::::DEE::::::EEEEEEEEE::::EFF::::::FFFFFFFFF::::FII::::::II
15   B::::B     B:::::BN::::::::::N    N::::::NS:::::S                      D:::::D    D:::::D E:::::E       EEEEEE  F:::::F       FFFFFF  I::::I  
16   B::::B     B:::::BN:::::::::::N   N::::::NS:::::S                      D:::::D     D:::::DE:::::E               F:::::F               I::::I  
17   B::::BBBBBB:::::B N:::::::N::::N  N::::::N S::::SSSS                   D:::::D     D:::::DE::::::EEEEEEEEEE     F::::::FFFFFFFFFF     I::::I  
18   B:::::::::::::BB  N::::::N N::::N N::::::N  SS::::::SSSSS              D:::::D     D:::::DE:::::::::::::::E     F:::::::::::::::F     I::::I  
19   B::::BBBBBB:::::B N::::::N  N::::N:::::::N    SSS::::::::SS            D:::::D     D:::::DE:::::::::::::::E     F:::::::::::::::F     I::::I  
20   B::::B     B:::::BN::::::N   N:::::::::::N       SSSSSS::::S           D:::::D     D:::::DE::::::EEEEEEEEEE     F::::::FFFFFFFFFF     I::::I  
21   B::::B     B:::::BN::::::N    N::::::::::N            S:::::S          D:::::D     D:::::DE:::::E               F:::::F               I::::I  
22   B::::B     B:::::BN::::::N     N:::::::::N            S:::::S          D:::::D    D:::::D E:::::E       EEEEEE  F:::::F               I::::I  
23 BB:::::BBBBBB::::::BN::::::N      N::::::::NSSSSSSS     S:::::S        DDD:::::DDDDD:::::DEE::::::EEEEEEEE:::::EFF:::::::FF           II::::::II
24 B:::::::::::::::::B N::::::N       N:::::::NS::::::SSSSSS:::::S ...... D:::::::::::::::DD E::::::::::::::::::::EF::::::::FF           I::::::::I
25 B::::::::::::::::B  N::::::N        N::::::NS:::::::::::::::SS  .::::. D::::::::::::DDD   E::::::::::::::::::::EF::::::::FF           I::::::::I
26 BBBBBBBBBBBBBBBBB   NNNNNNNN         NNNNNNN SSSSSSSSSSSSSSS    ...... DDDDDDDDDDDDD      EEEEEEEEEEEEEEEEEEEEEEFFFFFFFFFFF           IIIIIIIIII
27                                                                                                                                                 
28                                                        
29 
30 */
31 
32 pragma solidity ^0.6.12;
33 /*
34  * @dev Provides information about the current execution context, including the
35  * sender of the transaction and its data. While these are generally available
36  * via msg.sender and msg.data, they should not be accessed in such a direct
37  * manner, since when dealing with GSN meta-transactions the account sending and
38  * paying for execution may not be the actual sender (as far as an application
39  * is concerned).
40  *
41  * This contract is only required for intermediate, library-like contracts.
42  */
43 abstract contract Context {
44     function _msgSender() internal view virtual returns (address payable) {
45         return msg.sender;
46     }
47 
48     function _msgData() internal view virtual returns (bytes memory) {
49         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
50         return msg.data;
51     }
52 }
53 
54 /**
55  * @dev Interface of the ERC20 standard as defined in the EIP.
56  */
57 interface IERC20 {
58     /**
59      * @dev Returns the amount of tokens in existence.
60      */
61     function totalSupply() external view returns (uint256);
62 
63     /**
64      * @dev Returns the amount of tokens owned by `account`.
65      */
66     function balanceOf(address account) external view returns (uint256);
67 
68     /**
69      * @dev Moves `amount` tokens from the caller's account to `recipient`.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Returns the remaining number of tokens that `spender` will be
79      * allowed to spend on behalf of `owner` through {transferFrom}. This is
80      * zero by default.
81      *
82      * This value changes when {approve} or {transferFrom} are called.
83      */
84     function allowance(address owner, address spender) external view returns (uint256);
85 
86     /**
87      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * IMPORTANT: Beware that changing an allowance with this method brings the risk
92      * that someone may use both the old and the new allowance by unfortunate
93      * transaction ordering. One possible solution to mitigate this race
94      * condition is to first reduce the spender's allowance to 0 and set the
95      * desired value afterwards:
96      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
97      *
98      * Emits an {Approval} event.
99      */
100     function approve(address spender, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Moves `amount` tokens from `sender` to `recipient` using the
104      * allowance mechanism. `amount` is then deducted from the caller's
105      * allowance.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
112 
113     /**
114      * @dev Emitted when `value` tokens are moved from one account (`from`) to
115      * another (`to`).
116      *
117      * Note that `value` may be zero.
118      */
119     event Transfer(address indexed from, address indexed to, uint256 value);
120 
121     /**
122      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
123      * a call to {approve}. `value` is the new allowance.
124      */
125     event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 /**
129  * @dev Wrappers over Solidity's arithmetic operations with added overflow
130  * checks.
131  *
132  * Arithmetic operations in Solidity wrap on overflow. This can easily result
133  * in bugs, because programmers usually assume that an overflow raises an
134  * error, which is the standard behavior in high level programming languages.
135  * `SafeMath` restores this intuition by reverting the transaction when an
136  * operation overflows.
137  *
138  * Using this library instead of the unchecked operations eliminates an entire
139  * class of bugs, so it's recommended to use it always.
140  */
141 library SafeMath {
142     /**
143      * @dev Returns the addition of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `+` operator.
147      *
148      * Requirements:
149      *
150      * - Addition cannot overflow.
151      */
152     function add(uint256 a, uint256 b) internal pure returns (uint256) {
153         uint256 c = a + b;
154         require(c >= a, "SafeMath: addition overflow");
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
170         return sub(a, b, "SafeMath: subtraction overflow");
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
175      * overflow (when the result is negative).
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      *
181      * - Subtraction cannot overflow.
182      */
183     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
184         require(b <= a, errorMessage);
185         uint256 c = a - b;
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the multiplication of two unsigned integers, reverting on
192      * overflow.
193      *
194      * Counterpart to Solidity's `*` operator.
195      *
196      * Requirements:
197      *
198      * - Multiplication cannot overflow.
199      */
200     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
201         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
202         // benefit is lost if 'b' is also tested.
203         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
204         if (a == 0) {
205             return 0;
206         }
207 
208         uint256 c = a * b;
209         require(c / a == b, "SafeMath: multiplication overflow");
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts on
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
226     function div(uint256 a, uint256 b) internal pure returns (uint256) {
227         return div(a, b, "SafeMath: division by zero");
228     }
229 
230     /**
231      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
232      * division by zero. The result is rounded towards zero.
233      *
234      * Counterpart to Solidity's `/` operator. Note: this function uses a
235      * `revert` opcode (which leaves remaining gas untouched) while Solidity
236      * uses an invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         require(b > 0, errorMessage);
244         uint256 c = a / b;
245         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
263         return mod(a, b, "SafeMath: modulo by zero");
264     }
265 
266     /**
267      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
268      * Reverts with custom message when dividing by zero.
269      *
270      * Counterpart to Solidity's `%` operator. This function uses a `revert`
271      * opcode (which leaves remaining gas untouched) while Solidity uses an
272      * invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         require(b != 0, errorMessage);
280         return a % b;
281     }
282 }
283 
284 
285 /**
286  * @dev Collection of functions related to the address type
287  */
288 library Address {
289     /**
290      * @dev Returns true if `account` is a contract.
291      *
292      * [IMPORTANT]
293      * ====
294      * It is unsafe to assume that an address for which this function returns
295      * false is an externally-owned account (EOA) and not a contract.
296      *
297      * Among others, `isContract` will return false for the following
298      * types of addresses:
299      *
300      *  - an externally-owned account
301      *  - a contract in construction
302      *  - an address where a contract will be created
303      *  - an address where a contract lived, but was destroyed
304      * ====
305      */
306     function isContract(address account) internal view returns (bool) {
307         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
308         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
309         // for accounts without code, i.e. `keccak256('')`
310         bytes32 codehash;
311         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
312         // solhint-disable-next-line no-inline-assembly
313         assembly { codehash := extcodehash(account) }
314         return (codehash != accountHash && codehash != 0x0);
315     }
316 
317     /**
318      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
319      * `recipient`, forwarding all available gas and reverting on errors.
320      *
321      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
322      * of certain opcodes, possibly making contracts go over the 2300 gas limit
323      * imposed by `transfer`, making them unable to receive funds via
324      * `transfer`. {sendValue} removes this limitation.
325      *
326      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
327      *
328      * IMPORTANT: because control is transferred to `recipient`, care must be
329      * taken to not create reentrancy vulnerabilities. Consider using
330      * {ReentrancyGuard} or the
331      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
332      */
333     function sendValue(address payable recipient, uint256 amount) internal {
334         require(address(this).balance >= amount, "Address: insufficient balance");
335 
336         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
337         (bool success, ) = recipient.call{ value: amount }("");
338         require(success, "Address: unable to send value, recipient may have reverted");
339     }
340 
341     /**
342      * @dev Performs a Solidity function call using a low level `call`. A
343      * plain`call` is an unsafe replacement for a function call: use this
344      * function instead.
345      *
346      * If `target` reverts with a revert reason, it is bubbled up by this
347      * function (like regular Solidity function calls).
348      *
349      * Returns the raw returned data. To convert to the expected return value,
350      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
351      *
352      * Requirements:
353      *
354      * - `target` must be a contract.
355      * - calling `target` with `data` must not revert.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
360       return functionCall(target, data, "Address: low-level call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
365      * `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
370         return _functionCallWithValue(target, data, 0, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but also transferring `value` wei to `target`.
376      *
377      * Requirements:
378      *
379      * - the calling contract must have an ETH balance of at least `value`.
380      * - the called Solidity function must be `payable`.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
390      * with `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
395         require(address(this).balance >= value, "Address: insufficient balance for call");
396         return _functionCallWithValue(target, data, value, errorMessage);
397     }
398 
399     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
400         require(isContract(target), "Address: call to non-contract");
401 
402         // solhint-disable-next-line avoid-low-level-calls
403         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
404         if (success) {
405             return returndata;
406         } else {
407             // Look for revert reason and bubble it up if present
408             if (returndata.length > 0) {
409                 // The easiest way to bubble the revert reason is using memory via assembly
410 
411                 // solhint-disable-next-line no-inline-assembly
412                 assembly {
413                     let returndata_size := mload(returndata)
414                     revert(add(32, returndata), returndata_size)
415                 }
416             } else {
417                 revert(errorMessage);
418             }
419         }
420     }
421 }
422 
423 /**
424  * @title SafeERC20
425  * @dev Wrappers around ERC20 operations that throw on failure (when the token
426  * contract returns false). Tokens that return no value (and instead revert or
427  * throw on failure) are also supported, non-reverting calls are assumed to be
428  * successful.
429  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
430  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
431  */
432 library SafeERC20 {
433     using SafeMath for uint256;
434     using Address for address;
435 
436     function safeTransfer(IERC20 token, address to, uint256 value) internal {
437         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
438     }
439 
440     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
441         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
442     }
443 
444     /**
445      * @dev Deprecated. This function has issues similar to the ones found in
446      * {IERC20-approve}, and its usage is discouraged.
447      *
448      * Whenever possible, use {safeIncreaseAllowance} and
449      * {safeDecreaseAllowance} instead.
450      */
451     function safeApprove(IERC20 token, address spender, uint256 value) internal {
452         // safeApprove should only be called when setting an initial allowance,
453         // or when resetting it to zero. To increase and decrease it, use
454         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
455         // solhint-disable-next-line max-line-length
456         require((value == 0) || (token.allowance(address(this), spender) == 0),
457             "SafeERC20: approve from non-zero to non-zero allowance"
458         );
459         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
460     }
461 
462     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
463         uint256 newAllowance = token.allowance(address(this), spender).add(value);
464         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
465     }
466 
467     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
468         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
469         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
470     }
471 
472     /**
473      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
474      * on the return value: the return value is optional (but if data is returned, it must not be false).
475      * @param token The token targeted by the call.
476      * @param data The call data (encoded using abi.encode or one of its variants).
477      */
478     function _callOptionalReturn(IERC20 token, bytes memory data) private {
479         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
480         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
481         // the target address contains contract code and also asserts for success in the low-level call.
482 
483         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
484         if (returndata.length > 0) { // Return data is optional
485             // solhint-disable-next-line max-line-length
486             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
487         }
488     }
489 }
490 
491 
492 
493 /**
494  * @dev Contract module which provides a basic access control mechanism, where
495  * there is an account (an owner) that can be granted exclusive access to
496  * specific functions.
497  *
498  * By default, the owner account will be the one that deploys the contract. This
499  * can later be changed with {transferOwnership}.
500  *
501  * This module is used through inheritance. It will make available the modifier
502  * `onlyOwner`, which can be applied to your functions to restrict their use to
503  * the owner.
504  */
505 contract Ownable is Context {
506     address private _owner;
507 
508     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
509 
510     /**
511      * @dev Initializes the contract setting the deployer as the initial owner.
512      */
513     constructor () internal {
514         address msgSender = _msgSender();
515         _owner = msgSender;
516         emit OwnershipTransferred(address(0), msgSender);
517     }
518 
519     /**
520      * @dev Returns the address of the current owner.
521      */
522     function owner() public view returns (address) {
523         return _owner;
524     }
525 
526     /**
527      * @dev Throws if called by any account other than the owner.
528      */
529     modifier onlyOwner() {
530         require(_owner == _msgSender(), "Ownable: caller is not the owner");
531         _;
532     }
533 
534     /**
535      * @dev Leaves the contract without owner. It will not be possible to call
536      * `onlyOwner` functions anymore. Can only be called by the current owner.
537      *
538      * NOTE: Renouncing ownership will leave the contract without an owner,
539      * thereby removing any functionality that is only available to the owner.
540      */
541     function renounceOwnership() public virtual onlyOwner {
542         emit OwnershipTransferred(_owner, address(0));
543         _owner = address(0);
544     }
545 
546     /**
547      * @dev Transfers ownership of the contract to a new account (`newOwner`).
548      * Can only be called by the current owner.
549      */
550     function transferOwnership(address newOwner) public virtual onlyOwner {
551         require(newOwner != address(0), "Ownable: new owner is the zero address");
552         emit OwnershipTransferred(_owner, newOwner);
553         _owner = newOwner;
554     }
555 }
556 
557 
558 /**
559  * @dev Implementation of the {IERC20} interface.
560  *
561  * This implementation is agnostic to the way tokens are created. This means
562  * that a supply mechanism has to be added in a derived contract using {_mint}.
563  * For a generic mechanism see {ERC20PresetMinterPauser}.
564  *
565  * TIP: For a detailed writeup see our guide
566  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
567  * to implement supply mechanisms].
568  *
569  * We have followed general OpenZeppelin guidelines: functions revert instead
570  * of returning `false` on failure. This behavior is nonetheless conventional
571  * and does not conflict with the expectations of ERC20 applications.
572  *
573  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
574  * This allows applications to reconstruct the allowance for all accounts just
575  * by listening to said events. Other implementations of the EIP may not emit
576  * these events, as it isn't required by the specification.
577  *
578  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
579  * functions have been added to mitigate the well-known issues around setting
580  * allowances. See {IERC20-approve}.
581  */
582 contract ERC20 is Context, IERC20 {
583     using SafeMath for uint256;
584     using Address for address;
585 
586     mapping (address => uint256) private _balances;
587 
588     mapping (address => mapping (address => uint256)) private _allowances;
589 
590     uint256 private _totalSupply;
591 
592     string private _name;
593     string private _symbol;
594     uint8 private _decimals;
595 
596     /**
597      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
598      * a default value of 18.
599      *
600      * To select a different value for {decimals}, use {_setupDecimals}.
601      *
602      * All three of these values are immutable: they can only be set once during
603      * construction.
604      */
605     constructor (string memory name, string memory symbol) public {
606         _name = name;
607         _symbol = symbol;
608         _decimals = 18;
609     }
610 
611     /**
612      * @dev Returns the name of the token.
613      */
614     function name() public view returns (string memory) {
615         return _name;
616     }
617 
618     /**
619      * @dev Returns the symbol of the token, usually a shorter version of the
620      * name.
621      */
622     function symbol() public view returns (string memory) {
623         return _symbol;
624     }
625 
626     /**
627      * @dev Returns the number of decimals used to get its user representation.
628      * For example, if `decimals` equals `2`, a balance of `505` tokens should
629      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
630      *
631      * Tokens usually opt for a value of 18, imitating the relationship between
632      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
633      * called.
634      *
635      * NOTE: This information is only used for _display_ purposes: it in
636      * no way affects any of the arithmetic of the contract, including
637      * {IERC20-balanceOf} and {IERC20-transfer}.
638      */
639     function decimals() public view returns (uint8) {
640         return _decimals;
641     }
642 
643     /**
644      * @dev See {IERC20-totalSupply}.
645      */
646     function totalSupply() public view override returns (uint256) {
647         return _totalSupply;
648     }
649 
650     /**
651      * @dev See {IERC20-balanceOf}.
652      */
653     function balanceOf(address account) public view override returns (uint256) {
654         return _balances[account];
655     }
656 
657     /**
658      * @dev See {IERC20-transfer}.
659      *
660      * Requirements:
661      *
662      * - `recipient` cannot be the zero address.
663      * - the caller must have a balance of at least `amount`.
664      */
665     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
666         _transfer(_msgSender(), recipient, amount);
667         return true;
668     }
669 
670     /**
671      * @dev See {IERC20-allowance}.
672      */
673     function allowance(address owner, address spender) public view virtual override returns (uint256) {
674         return _allowances[owner][spender];
675     }
676 
677     /**
678      * @dev See {IERC20-approve}.
679      *
680      * Requirements:
681      *
682      * - `spender` cannot be the zero address.
683      */
684     function approve(address spender, uint256 amount) public virtual override returns (bool) {
685         _approve(_msgSender(), spender, amount);
686         return true;
687     }
688 
689     /**
690      * @dev See {IERC20-transferFrom}.
691      *
692      * Emits an {Approval} event indicating the updated allowance. This is not
693      * required by the EIP. See the note at the beginning of {ERC20};
694      *
695      * Requirements:
696      * - `sender` and `recipient` cannot be the zero address.
697      * - `sender` must have a balance of at least `amount`.
698      * - the caller must have allowance for ``sender``'s tokens of at least
699      * `amount`.
700      */
701     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
702         _transfer(sender, recipient, amount);
703         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
704         return true;
705     }
706 
707     /**
708      * @dev Atomically increases the allowance granted to `spender` by the caller.
709      *
710      * This is an alternative to {approve} that can be used as a mitigation for
711      * problems described in {IERC20-approve}.
712      *
713      * Emits an {Approval} event indicating the updated allowance.
714      *
715      * Requirements:
716      *
717      * - `spender` cannot be the zero address.
718      */
719     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
720         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
721         return true;
722     }
723 
724     /**
725      * @dev Atomically decreases the allowance granted to `spender` by the caller.
726      *
727      * This is an alternative to {approve} that can be used as a mitigation for
728      * problems described in {IERC20-approve}.
729      *
730      * Emits an {Approval} event indicating the updated allowance.
731      *
732      * Requirements:
733      *
734      * - `spender` cannot be the zero address.
735      * - `spender` must have allowance for the caller of at least
736      * `subtractedValue`.
737      */
738     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
739         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
740         return true;
741     }
742 
743     /**
744      * @dev Moves tokens `amount` from `sender` to `recipient`.
745      *
746      * This is internal function is equivalent to {transfer}, and can be used to
747      * e.g. implement automatic token fees, slashing mechanisms, etc.
748      *
749      * Emits a {Transfer} event.
750      *
751      * Requirements:
752      *
753      * - `sender` cannot be the zero address.
754      * - `recipient` cannot be the zero address.
755      * - `sender` must have a balance of at least `amount`.
756      */
757     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
758         require(sender != address(0), "ERC20: transfer from the zero address");
759         require(recipient != address(0), "ERC20: transfer to the zero address");
760 
761         _beforeTokenTransfer(sender, recipient, amount);
762 
763         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
764         _balances[recipient] = _balances[recipient].add(amount);
765         emit Transfer(sender, recipient, amount);
766     }
767 
768     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
769      * the total supply.
770      *
771      * Emits a {Transfer} event with `from` set to the zero address.
772      *
773      * Requirements
774      *
775      * - `to` cannot be the zero address.
776      */
777     function _mint(address account, uint256 amount) internal virtual {
778         require(account != address(0), "ERC20: mint to the zero address");
779 
780         _beforeTokenTransfer(address(0), account, amount);
781 
782         _totalSupply = _totalSupply.add(amount);
783         _balances[account] = _balances[account].add(amount);
784         emit Transfer(address(0), account, amount);
785     }
786 
787     /**
788      * @dev Destroys `amount` tokens from `account`, reducing the
789      * total supply.
790      *
791      * Emits a {Transfer} event with `to` set to the zero address.
792      *
793      * Requirements
794      *
795      * - `account` cannot be the zero address.
796      * - `account` must have at least `amount` tokens.
797      */
798     function _burn(address account, uint256 amount) internal virtual {
799         require(account != address(0), "ERC20: burn from the zero address");
800 
801         _beforeTokenTransfer(account, address(0), amount);
802 
803         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
804         _totalSupply = _totalSupply.sub(amount);
805         emit Transfer(account, address(0), amount);
806     }
807 
808     /**
809      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
810      *
811      * This is internal function is equivalent to `approve`, and can be used to
812      * e.g. set automatic allowances for certain subsystems, etc.
813      *
814      * Emits an {Approval} event.
815      *
816      * Requirements:
817      *
818      * - `owner` cannot be the zero address.
819      * - `spender` cannot be the zero address.
820      */
821     function _approve(address owner, address spender, uint256 amount) internal virtual {
822         require(owner != address(0), "ERC20: approve from the zero address");
823         require(spender != address(0), "ERC20: approve to the zero address");
824 
825         _allowances[owner][spender] = amount;
826         emit Approval(owner, spender, amount);
827     }
828 
829     /**
830      * @dev Sets {decimals} to a value other than the default one of 18.
831      *
832      * WARNING: This function should only be called from the constructor. Most
833      * applications that interact with token contracts will not expect
834      * {decimals} to ever change, and may work incorrectly if it does.
835      */
836     function _setupDecimals(uint8 decimals_) internal {
837         _decimals = decimals_;
838     }
839 
840     /**
841      * @dev Hook that is called before any transfer of tokens. This includes
842      * minting and burning.
843      *
844      * Calling conditions:
845      *
846      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
847      * will be to transferred to `to`.
848      * - when `from` is zero, `amount` tokens will be minted for `to`.
849      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
850      * - `from` and `to` are never both zero.
851      *
852      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
853      */
854     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
855 }
856 
857 // BnsdToken with Governance.
858 contract BnsdToken is ERC20("bns.finance", "BNSD"), Ownable {
859     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
860     function mint(address _to, uint256 _amount) public onlyOwner {
861         _mint(_to, _amount);
862     }
863 }
864 
865 contract BnsdChef is Ownable {
866     using SafeMath for uint256;
867     using SafeERC20 for IERC20;
868 
869     // Info of each user.
870     struct UserInfo {
871         uint256 amount;     // How many LP tokens the user has provided.
872         uint256 rewardDebt; // Reward debt. See explanation below.
873         //
874         // We do some fancy math here. Basically, any point in time, the amount of BNSDs
875         // entitled to a user but is pending to be distributed is:
876         //
877         //   pending reward = (user.amount * pool.accBnsdPerShare) - user.rewardDebt
878         //
879         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
880         //   1. The pool's `accBnsdPerShare` (and `lastRewardBlock`) gets updated.
881         //   2. User receives the pending reward sent to his/her address.
882         //   3. User's `amount` gets updated.
883         //   4. User's `rewardDebt` gets updated.
884     }
885 
886     // Info of each pool.
887     struct PoolInfo {
888         IERC20 lpToken;           // Address of LP token contract.
889         uint256 allocPoint;       // How many allocation points assigned to this pool. BNSDs to distribute per block.
890         uint256 lastRewardBlock;  // Last block number that BNSDs distribution occurs.
891         uint256 accBnsdPerShare; // Accumulated BNSDs per share, times 1e12. See below.
892     }
893 
894     // The BNSD TOKEN!
895     BnsdToken public bnsd;
896     // Dev address.
897     address public devaddr;
898     // Block number when bonus BNSD period ends.
899     uint256 public bonusEndBlock;
900     // BNSD tokens created per block.
901     uint256 public bnsdPerBlock;
902     // Bonus muliplier for early bnsd makers.
903     uint256 public constant BONUS_MULTIPLIER = 1; // no bonus
904 
905     // No of blocks in a day  - 7000
906     uint256 public constant perDayBlocks = 7000; // no bonus
907 
908     // Info of each pool.
909     PoolInfo[] public poolInfo;
910     // Info of each user that stakes LP tokens.
911     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
912     // Total allocation poitns. Must be the sum of all allocation points in all pools.
913     uint256 public totalAllocPoint = 0;
914     // The block number when BNSD mining starts.
915     uint256 public startBlock;
916 
917     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
918     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
919     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
920 
921     constructor(
922         BnsdToken _bnsd,
923         address _devaddr,
924         uint256 _bnsdPerBlock,
925         uint256 _startBlock,
926         uint256 _bonusEndBlock
927     ) public {
928         bnsd = _bnsd;
929         devaddr = _devaddr;
930         bnsdPerBlock = _bnsdPerBlock;
931         bonusEndBlock = _bonusEndBlock;
932         startBlock = _startBlock;
933     }
934 
935     function poolLength() external view returns (uint256) {
936         return poolInfo.length;
937     }
938 
939     // Add a new lp to the pool. Can only be called by the owner.
940     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
941     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
942         if (_withUpdate) {
943             massUpdatePools();
944         }
945         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
946         totalAllocPoint = totalAllocPoint.add(_allocPoint);
947         poolInfo.push(PoolInfo({
948             lpToken: _lpToken,
949             allocPoint: _allocPoint,
950             lastRewardBlock: lastRewardBlock,
951             accBnsdPerShare: 0
952         }));
953     }
954 
955     // Update the given pool's BNSD allocation point. Can only be called by the owner.
956     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
957         if (_withUpdate) {
958             massUpdatePools();
959         }
960         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
961         poolInfo[_pid].allocPoint = _allocPoint;
962     }
963 
964 
965 
966     // Return reward multiplier over the given _from to _to block.
967     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
968         if (_to <= bonusEndBlock) {
969             return _to.sub(_from).mul(BONUS_MULTIPLIER);
970         } else if (_from >= bonusEndBlock) {
971             return _to.sub(_from);
972         } else {
973             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
974                 _to.sub(bonusEndBlock)
975             );
976         }
977     }
978     
979      // reward prediction at specific block
980     function getRewardPerBlock(uint blockNumber) public view returns (uint256) {
981         if (blockNumber >= startBlock){
982 
983             uint256 blockDaysPassed = (blockNumber.sub(startBlock)).div(perDayBlocks);
984 
985             if(blockDaysPassed <= 0){
986                  return bnsdPerBlock;
987             }
988             else if(blockDaysPassed > 0 && blockDaysPassed <= 7){
989                  return bnsdPerBlock.div(2);
990             }
991             else if(blockDaysPassed > 7 && blockDaysPassed <= 30){
992                  return bnsdPerBlock.div(4);
993             }
994             else if(blockDaysPassed > 30 && blockDaysPassed <= 90){
995                  return bnsdPerBlock.div(8);
996             }
997             else {
998                 return bnsdPerBlock.div(10);
999             }
1000 
1001         } else {
1002             return 0;
1003         }
1004     }
1005 
1006     // View function to see pending BNSDs on frontend.
1007     function pendingBnsd(uint256 _pid, address _user) external view returns (uint256) {
1008         PoolInfo storage pool = poolInfo[_pid];
1009         UserInfo storage user = userInfo[_pid][_user];
1010         uint256 accBnsdPerShare = pool.accBnsdPerShare;
1011         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1012         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1013             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1014             uint256 rewardThisBlock = getRewardPerBlock(block.number);
1015             uint256 bnsdReward = multiplier.mul(rewardThisBlock).mul(pool.allocPoint).div(totalAllocPoint);
1016             accBnsdPerShare = accBnsdPerShare.add(bnsdReward.mul(1e12).div(lpSupply));
1017         }
1018         return user.amount.mul(accBnsdPerShare).div(1e12).sub(user.rewardDebt);
1019     }
1020 
1021     // Update reward vairables for all pools. Be careful of gas spending!
1022     function massUpdatePools() public {
1023         uint256 length = poolInfo.length;
1024         for (uint256 pid = 0; pid < length; ++pid) {
1025             updatePool(pid);
1026         }
1027     }
1028 
1029 
1030     // Update reward variables of the given pool to be up-to-date.
1031     function updatePool(uint256 _pid) public {
1032         PoolInfo storage pool = poolInfo[_pid];
1033         if (block.number <= pool.lastRewardBlock) {
1034             return;
1035         }
1036         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1037         if (lpSupply == 0) {
1038             pool.lastRewardBlock = block.number;
1039             return;
1040         }
1041         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1042         uint256 rewardThisBlock = getRewardPerBlock(block.number);
1043         uint256 bnsdReward = multiplier.mul(rewardThisBlock).mul(pool.allocPoint).div(totalAllocPoint);
1044         bnsd.mint(devaddr, bnsdReward.div(25)); // 4%
1045         bnsd.mint(address(this), bnsdReward);
1046         pool.accBnsdPerShare = pool.accBnsdPerShare.add(bnsdReward.mul(1e12).div(lpSupply));
1047         pool.lastRewardBlock = block.number;
1048     }
1049 
1050     // Deposit LP tokens to MasterChef for BNSD allocation.
1051     function deposit(uint256 _pid, uint256 _amount) public {
1052         PoolInfo storage pool = poolInfo[_pid];
1053         UserInfo storage user = userInfo[_pid][msg.sender];
1054         updatePool(_pid);
1055         if (user.amount > 0) {
1056             uint256 pending = user.amount.mul(pool.accBnsdPerShare).div(1e12).sub(user.rewardDebt);
1057             safeBnsdTransfer(msg.sender, pending);
1058         }
1059         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1060         user.amount = user.amount.add(_amount);
1061         user.rewardDebt = user.amount.mul(pool.accBnsdPerShare).div(1e12);
1062         emit Deposit(msg.sender, _pid, _amount);
1063     }
1064 
1065     // Withdraw LP tokens from MasterChef.
1066     function withdraw(uint256 _pid, uint256 _amount) public {
1067         PoolInfo storage pool = poolInfo[_pid];
1068         UserInfo storage user = userInfo[_pid][msg.sender];
1069         require(user.amount >= _amount, "withdraw: not good");
1070         updatePool(_pid);
1071         uint256 pending = user.amount.mul(pool.accBnsdPerShare).div(1e12).sub(user.rewardDebt);
1072         safeBnsdTransfer(msg.sender, pending);
1073         user.amount = user.amount.sub(_amount);
1074         user.rewardDebt = user.amount.mul(pool.accBnsdPerShare).div(1e12);
1075         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1076         emit Withdraw(msg.sender, _pid, _amount);
1077     }
1078 
1079     // Withdraw without caring about rewards. EMERGENCY ONLY.
1080     function emergencyWithdraw(uint256 _pid) public {
1081         PoolInfo storage pool = poolInfo[_pid];
1082         UserInfo storage user = userInfo[_pid][msg.sender];
1083         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1084         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1085         user.amount = 0;
1086         user.rewardDebt = 0;
1087     }
1088 
1089     // Safe bnsd transfer function, just in case if rounding error causes pool to not have enough BNSDs.
1090     function safeBnsdTransfer(address _to, uint256 _amount) internal {
1091         uint256 bnsdBal = bnsd.balanceOf(address(this));
1092         if (_amount > bnsdBal) {
1093             bnsd.transfer(_to, bnsdBal);
1094         } else {
1095             bnsd.transfer(_to, _amount);
1096         }
1097     }
1098 
1099     // Update dev address by the previous dev.
1100     function dev(address _devaddr) public {
1101         require(msg.sender == devaddr, "dev: wut?");
1102         devaddr = _devaddr;
1103     }
1104 }