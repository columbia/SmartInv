1 /* 
2 
3 website: jiaozi.farm
4 
5                          .@@@@        ,@@@@@@@@        .@@@@@@@.                                            
6                        ,@@@@@@@    ,@@@@@@@@@@@@@,    ,@@@@@@@@@@                               
7                    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                             
8                 .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                
9              @@@@@@@@@@@@@@@@@@@@@@@@@@&      @@@@@@@@@@(   @@@@@@@@@@@@@@@@@@@@@@              
10      @@@@@@@@@@@@@@@@@@        @@@@@@@@,       @@@@@@@@     @@@@@@@@@@@@@@@@@@@@@@@             
11   @@@@@@@@@@@@@@@@@@@@          @@@@@@@@      &@@@@@@@    ,@@@@@@@@@@@    #@@@@@@@@             
12  @@@@@@@@@@@@@@@@@@@@@@@            ,@@@          &@@@    @@@@@@@@       @@@@@@@@@@@@@@         
13  @@@@@@@@       @@@@@@@@@                                             @@@@@@@@@@@@@@@@@@@@@     
14   @@@@@@@@@      *@@@@@@@@        @@@@                 @@@@         @@@@@@@@@@@@@@@@@@@@@@@@@   
15    @@@@@@@@@@                   @@@@@@@@@@         @@@@@@@@@@      &@@@@@@@@        @@@@@@@@@   
16      @@@@@@@@@@                &@@@@@@@@@@@@,   @@@@@@@@@@@@@(                 .@@@@@@@@@@@@    
17        @@@@@@@@@&                  @@@@@@@@       @@@@@@@%                @@@@@@@@@@@@@@@@      
18          @@@@@@@@@                     @@          %@&                    @@@@@@@@@@@@@         
19           @@@@@@@@@                                                       (@@@@@@@              
20            @@@@@@@@@@                                                     @@@@@@@@              
21              @@@@@@@@@@                                                  @@@@@@@@#              
22                @@@@@@@@@@.                                            #@@@@@@@@@.               
23                  @@@@@@@@@@@@                                      @@@@@@@@@@@@                 
24                    @@@@@@@@@@@@@@@                            @@@@@@@@@@@@@@@                   
25                       @@@@@@@@@@@@@@@@@@@@@@%*. .*%@@@@@@@@@@@@@@@@@@@@@@@                      
26                           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                          
27                                @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@.                               
28                                         .&@@@@@@@@@@@@*
29 
30 
31 This project was forked from KIMCHI, which was forked from SUSHI and YUNO projects.
32 
33 mint() backdoor removed
34 
35 Unless those projects have severe vulnerabilities, this contract will be fine
36 
37 */
38 
39 pragma solidity ^0.6.12;
40 /*
41  * @dev Provides information about the current execution context, including the
42  * sender of the transaction and its data. While these are generally available
43  * via msg.sender and msg.data, they should not be accessed in such a direct
44  * manner, since when dealing with GSN meta-transactions the account sending and
45  * paying for execution may not be the actual sender (as far as an application
46  * is concerned).
47  *
48  * This contract is only required for intermediate, library-like contracts.
49  */
50 abstract contract Context {
51     function _msgSender() internal view virtual returns (address payable) {
52         return msg.sender;
53     }
54 
55     function _msgData() internal view virtual returns (bytes memory) {
56         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
57         return msg.data;
58     }
59 }
60 
61 /**
62  * @dev Interface of the ERC20 standard as defined in the EIP.
63  */
64 interface IERC20 {
65     /**
66      * @dev Returns the amount of tokens in existence.
67      */
68     function totalSupply() external view returns (uint256);
69 
70     /**
71      * @dev Returns the amount of tokens owned by `account`.
72      */
73     function balanceOf(address account) external view returns (uint256);
74 
75     /**
76      * @dev Moves `amount` tokens from the caller's account to `recipient`.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transfer(address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Returns the remaining number of tokens that `spender` will be
86      * allowed to spend on behalf of `owner` through {transferFrom}. This is
87      * zero by default.
88      *
89      * This value changes when {approve} or {transferFrom} are called.
90      */
91     function allowance(address owner, address spender) external view returns (uint256);
92 
93     /**
94      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * IMPORTANT: Beware that changing an allowance with this method brings the risk
99      * that someone may use both the old and the new allowance by unfortunate
100      * transaction ordering. One possible solution to mitigate this race
101      * condition is to first reduce the spender's allowance to 0 and set the
102      * desired value afterwards:
103      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104      *
105      * Emits an {Approval} event.
106      */
107     function approve(address spender, uint256 amount) external returns (bool);
108 
109     /**
110      * @dev Moves `amount` tokens from `sender` to `recipient` using the
111      * allowance mechanism. `amount` is then deducted from the caller's
112      * allowance.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
119 
120     /**
121      * @dev Emitted when `value` tokens are moved from one account (`from`) to
122      * another (`to`).
123      *
124      * Note that `value` may be zero.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 value);
127 
128     /**
129      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
130      * a call to {approve}. `value` is the new allowance.
131      */
132     event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 /**
136  * @dev Wrappers over Solidity's arithmetic operations with added overflow
137  * checks.
138  *
139  * Arithmetic operations in Solidity wrap on overflow. This can easily result
140  * in bugs, because programmers usually assume that an overflow raises an
141  * error, which is the standard behavior in high level programming languages.
142  * `SafeMath` restores this intuition by reverting the transaction when an
143  * operation overflows.
144  *
145  * Using this library instead of the unchecked operations eliminates an entire
146  * class of bugs, so it's recommended to use it always.
147  */
148 library SafeMath {
149     /**
150      * @dev Returns the addition of two unsigned integers, reverting on
151      * overflow.
152      *
153      * Counterpart to Solidity's `+` operator.
154      *
155      * Requirements:
156      *
157      * - Addition cannot overflow.
158      */
159     function add(uint256 a, uint256 b) internal pure returns (uint256) {
160         uint256 c = a + b;
161         require(c >= a, "SafeMath: addition overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the subtraction of two unsigned integers, reverting on
168      * overflow (when the result is negative).
169      *
170      * Counterpart to Solidity's `-` operator.
171      *
172      * Requirements:
173      *
174      * - Subtraction cannot overflow.
175      */
176     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
177         return sub(a, b, "SafeMath: subtraction overflow");
178     }
179 
180     /**
181      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
182      * overflow (when the result is negative).
183      *
184      * Counterpart to Solidity's `-` operator.
185      *
186      * Requirements:
187      *
188      * - Subtraction cannot overflow.
189      */
190     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b <= a, errorMessage);
192         uint256 c = a - b;
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the multiplication of two unsigned integers, reverting on
199      * overflow.
200      *
201      * Counterpart to Solidity's `*` operator.
202      *
203      * Requirements:
204      *
205      * - Multiplication cannot overflow.
206      */
207     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
208         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
209         // benefit is lost if 'b' is also tested.
210         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
211         if (a == 0) {
212             return 0;
213         }
214 
215         uint256 c = a * b;
216         require(c / a == b, "SafeMath: multiplication overflow");
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the integer division of two unsigned integers. Reverts on
223      * division by zero. The result is rounded towards zero.
224      *
225      * Counterpart to Solidity's `/` operator. Note: this function uses a
226      * `revert` opcode (which leaves remaining gas untouched) while Solidity
227      * uses an invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function div(uint256 a, uint256 b) internal pure returns (uint256) {
234         return div(a, b, "SafeMath: division by zero");
235     }
236 
237     /**
238      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
239      * division by zero. The result is rounded towards zero.
240      *
241      * Counterpart to Solidity's `/` operator. Note: this function uses a
242      * `revert` opcode (which leaves remaining gas untouched) while Solidity
243      * uses an invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b > 0, errorMessage);
251         uint256 c = a / b;
252         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
253 
254         return c;
255     }
256 
257     /**
258      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
259      * Reverts when dividing by zero.
260      *
261      * Counterpart to Solidity's `%` operator. This function uses a `revert`
262      * opcode (which leaves remaining gas untouched) while Solidity uses an
263      * invalid opcode to revert (consuming all remaining gas).
264      *
265      * Requirements:
266      *
267      * - The divisor cannot be zero.
268      */
269     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
270         return mod(a, b, "SafeMath: modulo by zero");
271     }
272 
273     /**
274      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
275      * Reverts with custom message when dividing by zero.
276      *
277      * Counterpart to Solidity's `%` operator. This function uses a `revert`
278      * opcode (which leaves remaining gas untouched) while Solidity uses an
279      * invalid opcode to revert (consuming all remaining gas).
280      *
281      * Requirements:
282      *
283      * - The divisor cannot be zero.
284      */
285     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         require(b != 0, errorMessage);
287         return a % b;
288     }
289 }
290 
291 
292 /**
293  * @dev Collection of functions related to the address type
294  */
295 library Address {
296     /**
297      * @dev Returns true if `account` is a contract.
298      *
299      * [IMPORTANT]
300      * ====
301      * It is unsafe to assume that an address for which this function returns
302      * false is an externally-owned account (EOA) and not a contract.
303      *
304      * Among others, `isContract` will return false for the following
305      * types of addresses:
306      *
307      *  - an externally-owned account
308      *  - a contract in construction
309      *  - an address where a contract will be created
310      *  - an address where a contract lived, but was destroyed
311      * ====
312      */
313     function isContract(address account) internal view returns (bool) {
314         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
315         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
316         // for accounts without code, i.e. `keccak256('')`
317         bytes32 codehash;
318         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
319         // solhint-disable-next-line no-inline-assembly
320         assembly { codehash := extcodehash(account) }
321         return (codehash != accountHash && codehash != 0x0);
322     }
323 
324     /**
325      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
326      * `recipient`, forwarding all available gas and reverting on errors.
327      *
328      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
329      * of certain opcodes, possibly making contracts go over the 2300 gas limit
330      * imposed by `transfer`, making them unable to receive funds via
331      * `transfer`. {sendValue} removes this limitation.
332      *
333      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
334      *
335      * IMPORTANT: because control is transferred to `recipient`, care must be
336      * taken to not create reentrancy vulnerabilities. Consider using
337      * {ReentrancyGuard} or the
338      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
339      */
340     function sendValue(address payable recipient, uint256 amount) internal {
341         require(address(this).balance >= amount, "Address: insufficient balance");
342 
343         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
344         (bool success, ) = recipient.call{ value: amount }("");
345         require(success, "Address: unable to send value, recipient may have reverted");
346     }
347 
348     /**
349      * @dev Performs a Solidity function call using a low level `call`. A
350      * plain`call` is an unsafe replacement for a function call: use this
351      * function instead.
352      *
353      * If `target` reverts with a revert reason, it is bubbled up by this
354      * function (like regular Solidity function calls).
355      *
356      * Returns the raw returned data. To convert to the expected return value,
357      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
358      *
359      * Requirements:
360      *
361      * - `target` must be a contract.
362      * - calling `target` with `data` must not revert.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
367       return functionCall(target, data, "Address: low-level call failed");
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
372      * `errorMessage` as a fallback revert reason when `target` reverts.
373      *
374      * _Available since v3.1._
375      */
376     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
377         return _functionCallWithValue(target, data, 0, errorMessage);
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
382      * but also transferring `value` wei to `target`.
383      *
384      * Requirements:
385      *
386      * - the calling contract must have an ETH balance of at least `value`.
387      * - the called Solidity function must be `payable`.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
392         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
393     }
394 
395     /**
396      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
397      * with `errorMessage` as a fallback revert reason when `target` reverts.
398      *
399      * _Available since v3.1._
400      */
401     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
402         require(address(this).balance >= value, "Address: insufficient balance for call");
403         return _functionCallWithValue(target, data, value, errorMessage);
404     }
405 
406     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
407         require(isContract(target), "Address: call to non-contract");
408 
409         // solhint-disable-next-line avoid-low-level-calls
410         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
411         if (success) {
412             return returndata;
413         } else {
414             // Look for revert reason and bubble it up if present
415             if (returndata.length > 0) {
416                 // The easiest way to bubble the revert reason is using memory via assembly
417 
418                 // solhint-disable-next-line no-inline-assembly
419                 assembly {
420                     let returndata_size := mload(returndata)
421                     revert(add(32, returndata), returndata_size)
422                 }
423             } else {
424                 revert(errorMessage);
425             }
426         }
427     }
428 }
429 
430 /**
431  * @title SafeERC20
432  * @dev Wrappers around ERC20 operations that throw on failure (when the token
433  * contract returns false). Tokens that return no value (and instead revert or
434  * throw on failure) are also supported, non-reverting calls are assumed to be
435  * successful.
436  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
437  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
438  */
439 library SafeERC20 {
440     using SafeMath for uint256;
441     using Address for address;
442 
443     function safeTransfer(IERC20 token, address to, uint256 value) internal {
444         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
445     }
446 
447     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
448         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
449     }
450 
451     /**
452      * @dev Deprecated. This function has issues similar to the ones found in
453      * {IERC20-approve}, and its usage is discouraged.
454      *
455      * Whenever possible, use {safeIncreaseAllowance} and
456      * {safeDecreaseAllowance} instead.
457      */
458     function safeApprove(IERC20 token, address spender, uint256 value) internal {
459         // safeApprove should only be called when setting an initial allowance,
460         // or when resetting it to zero. To increase and decrease it, use
461         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
462         // solhint-disable-next-line max-line-length
463         require((value == 0) || (token.allowance(address(this), spender) == 0),
464             "SafeERC20: approve from non-zero to non-zero allowance"
465         );
466         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
467     }
468 
469     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
470         uint256 newAllowance = token.allowance(address(this), spender).add(value);
471         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
472     }
473 
474     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
475         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
476         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
477     }
478 
479     /**
480      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
481      * on the return value: the return value is optional (but if data is returned, it must not be false).
482      * @param token The token targeted by the call.
483      * @param data The call data (encoded using abi.encode or one of its variants).
484      */
485     function _callOptionalReturn(IERC20 token, bytes memory data) private {
486         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
487         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
488         // the target address contains contract code and also asserts for success in the low-level call.
489 
490         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
491         if (returndata.length > 0) { // Return data is optional
492             // solhint-disable-next-line max-line-length
493             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
494         }
495     }
496 }
497 
498 
499 
500 /**
501  * @dev Contract module which provides a basic access control mechanism, where
502  * there is an account (an owner) that can be granted exclusive access to
503  * specific functions.
504  *
505  * By default, the owner account will be the one that deploys the contract. This
506  * can later be changed with {transferOwnership}.
507  *
508  * This module is used through inheritance. It will make available the modifier
509  * `onlyOwner`, which can be applied to your functions to restrict their use to
510  * the owner.
511  */
512 contract Ownable is Context {
513     address private _owner;
514 
515     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
516 
517     /**
518      * @dev Initializes the contract setting the deployer as the initial owner.
519      */
520     constructor () internal {
521         address msgSender = _msgSender();
522         _owner = msgSender;
523         emit OwnershipTransferred(address(0), msgSender);
524     }
525 
526     /**
527      * @dev Returns the address of the current owner.
528      */
529     function owner() public view returns (address) {
530         return _owner;
531     }
532 
533     /**
534      * @dev Throws if called by any account other than the owner.
535      */
536     modifier onlyOwner() {
537         require(_owner == _msgSender(), "Ownable: caller is not the owner");
538         _;
539     }
540 
541     /**
542      * @dev Leaves the contract without owner. It will not be possible to call
543      * `onlyOwner` functions anymore. Can only be called by the current owner.
544      *
545      * NOTE: Renouncing ownership will leave the contract without an owner,
546      * thereby removing any functionality that is only available to the owner.
547      */
548     function renounceOwnership() public virtual onlyOwner {
549         emit OwnershipTransferred(_owner, address(0));
550         _owner = address(0);
551     }
552 
553     /**
554      * @dev Transfers ownership of the contract to a new account (`newOwner`).
555      * Can only be called by the current owner.
556      */
557     function transferOwnership(address newOwner) public virtual onlyOwner {
558         require(newOwner != address(0), "Ownable: new owner is the zero address");
559         emit OwnershipTransferred(_owner, newOwner);
560         _owner = newOwner;
561     }
562 }
563 
564 
565 /**
566  * @dev Implementation of the {IERC20} interface.
567  *
568  * This implementation is agnostic to the way tokens are created. This means
569  * that a supply mechanism has to be added in a derived contract using {_mint}.
570  * For a generic mechanism see {ERC20PresetMinterPauser}.
571  *
572  * TIP: For a detailed writeup see our guide
573  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
574  * to implement supply mechanisms].
575  *
576  * We have followed general OpenZeppelin guidelines: functions revert instead
577  * of returning `false` on failure. This behavior is nonetheless conventional
578  * and does not conflict with the expectations of ERC20 applications.
579  *
580  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
581  * This allows applications to reconstruct the allowance for all accounts just
582  * by listening to said events. Other implementations of the EIP may not emit
583  * these events, as it isn't required by the specification.
584  *
585  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
586  * functions have been added to mitigate the well-known issues around setting
587  * allowances. See {IERC20-approve}.
588  */
589 contract ERC20 is Context, IERC20 {
590     using SafeMath for uint256;
591     using Address for address;
592 
593     mapping (address => uint256) private _balances;
594 
595     mapping (address => mapping (address => uint256)) private _allowances;
596 
597     uint256 private _totalSupply;
598 
599     string private _name;
600     string private _symbol;
601     uint8 private _decimals;
602 
603     /**
604      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
605      * a default value of 18.
606      *
607      * To select a different value for {decimals}, use {_setupDecimals}.
608      *
609      * All three of these values are immutable: they can only be set once during
610      * construction.
611      */
612     constructor (string memory name, string memory symbol) public {
613         _name = name;
614         _symbol = symbol;
615         _decimals = 18;
616     }
617 
618     /**
619      * @dev Returns the name of the token.
620      */
621     function name() public view returns (string memory) {
622         return _name;
623     }
624 
625     /**
626      * @dev Returns the symbol of the token, usually a shorter version of the
627      * name.
628      */
629     function symbol() public view returns (string memory) {
630         return _symbol;
631     }
632 
633     /**
634      * @dev Returns the number of decimals used to get its user representation.
635      * For example, if `decimals` equals `2`, a balance of `505` tokens should
636      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
637      *
638      * Tokens usually opt for a value of 18, imitating the relationship between
639      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
640      * called.
641      *
642      * NOTE: This information is only used for _display_ purposes: it in
643      * no way affects any of the arithmetic of the contract, including
644      * {IERC20-balanceOf} and {IERC20-transfer}.
645      */
646     function decimals() public view returns (uint8) {
647         return _decimals;
648     }
649 
650     /**
651      * @dev See {IERC20-totalSupply}.
652      */
653     function totalSupply() public view override returns (uint256) {
654         return _totalSupply;
655     }
656 
657     /**
658      * @dev See {IERC20-balanceOf}.
659      */
660     function balanceOf(address account) public view override returns (uint256) {
661         return _balances[account];
662     }
663 
664     /**
665      * @dev See {IERC20-transfer}.
666      *
667      * Requirements:
668      *
669      * - `recipient` cannot be the zero address.
670      * - the caller must have a balance of at least `amount`.
671      */
672     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
673         _transfer(_msgSender(), recipient, amount);
674         return true;
675     }
676 
677     /**
678      * @dev See {IERC20-allowance}.
679      */
680     function allowance(address owner, address spender) public view virtual override returns (uint256) {
681         return _allowances[owner][spender];
682     }
683 
684     /**
685      * @dev See {IERC20-approve}.
686      *
687      * Requirements:
688      *
689      * - `spender` cannot be the zero address.
690      */
691     function approve(address spender, uint256 amount) public virtual override returns (bool) {
692         _approve(_msgSender(), spender, amount);
693         return true;
694     }
695 
696     /**
697      * @dev See {IERC20-transferFrom}.
698      *
699      * Emits an {Approval} event indicating the updated allowance. This is not
700      * required by the EIP. See the note at the beginning of {ERC20};
701      *
702      * Requirements:
703      * - `sender` and `recipient` cannot be the zero address.
704      * - `sender` must have a balance of at least `amount`.
705      * - the caller must have allowance for ``sender``'s tokens of at least
706      * `amount`.
707      */
708     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
709         _transfer(sender, recipient, amount);
710         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
711         return true;
712     }
713 
714     /**
715      * @dev Atomically increases the allowance granted to `spender` by the caller.
716      *
717      * This is an alternative to {approve} that can be used as a mitigation for
718      * problems described in {IERC20-approve}.
719      *
720      * Emits an {Approval} event indicating the updated allowance.
721      *
722      * Requirements:
723      *
724      * - `spender` cannot be the zero address.
725      */
726     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
727         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
728         return true;
729     }
730 
731     /**
732      * @dev Atomically decreases the allowance granted to `spender` by the caller.
733      *
734      * This is an alternative to {approve} that can be used as a mitigation for
735      * problems described in {IERC20-approve}.
736      *
737      * Emits an {Approval} event indicating the updated allowance.
738      *
739      * Requirements:
740      *
741      * - `spender` cannot be the zero address.
742      * - `spender` must have allowance for the caller of at least
743      * `subtractedValue`.
744      */
745     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
746         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
747         return true;
748     }
749 
750     /**
751      * @dev Moves tokens `amount` from `sender` to `recipient`.
752      *
753      * This is internal function is equivalent to {transfer}, and can be used to
754      * e.g. implement automatic token fees, slashing mechanisms, etc.
755      *
756      * Emits a {Transfer} event.
757      *
758      * Requirements:
759      *
760      * - `sender` cannot be the zero address.
761      * - `recipient` cannot be the zero address.
762      * - `sender` must have a balance of at least `amount`.
763      */
764     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
765         require(sender != address(0), "ERC20: transfer from the zero address");
766         require(recipient != address(0), "ERC20: transfer to the zero address");
767 
768         _beforeTokenTransfer(sender, recipient, amount);
769 
770         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
771         _balances[recipient] = _balances[recipient].add(amount);
772         emit Transfer(sender, recipient, amount);
773     }
774 
775     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
776      * the total supply.
777      *
778      * Emits a {Transfer} event with `from` set to the zero address.
779      *
780      * Requirements
781      *
782      * - `to` cannot be the zero address.
783      */
784     function _mint(address account, uint256 amount) internal virtual {
785         require(account != address(0), "ERC20: mint to the zero address");
786 
787         _beforeTokenTransfer(address(0), account, amount);
788 
789         _totalSupply = _totalSupply.add(amount);
790         _balances[account] = _balances[account].add(amount);
791         emit Transfer(address(0), account, amount);
792     }
793 
794     /**
795      * @dev Destroys `amount` tokens from `account`, reducing the
796      * total supply.
797      *
798      * Emits a {Transfer} event with `to` set to the zero address.
799      *
800      * Requirements
801      *
802      * - `account` cannot be the zero address.
803      * - `account` must have at least `amount` tokens.
804      */
805     function _burn(address account, uint256 amount) internal virtual {
806         require(account != address(0), "ERC20: burn from the zero address");
807 
808         _beforeTokenTransfer(account, address(0), amount);
809 
810         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
811         _totalSupply = _totalSupply.sub(amount);
812         emit Transfer(account, address(0), amount);
813     }
814 
815     /**
816      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
817      *
818      * This is internal function is equivalent to `approve`, and can be used to
819      * e.g. set automatic allowances for certain subsystems, etc.
820      *
821      * Emits an {Approval} event.
822      *
823      * Requirements:
824      *
825      * - `owner` cannot be the zero address.
826      * - `spender` cannot be the zero address.
827      */
828     function _approve(address owner, address spender, uint256 amount) internal virtual {
829         require(owner != address(0), "ERC20: approve from the zero address");
830         require(spender != address(0), "ERC20: approve to the zero address");
831 
832         _allowances[owner][spender] = amount;
833         emit Approval(owner, spender, amount);
834     }
835 
836     /**
837      * @dev Sets {decimals} to a value other than the default one of 18.
838      *
839      * WARNING: This function should only be called from the constructor. Most
840      * applications that interact with token contracts will not expect
841      * {decimals} to ever change, and may work incorrectly if it does.
842      */
843     function _setupDecimals(uint8 decimals_) internal {
844         _decimals = decimals_;
845     }
846 
847     /**
848      * @dev Hook that is called before any transfer of tokens. This includes
849      * minting and burning.
850      *
851      * Calling conditions:
852      *
853      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
854      * will be to transferred to `to`.
855      * - when `from` is zero, `amount` tokens will be minted for `to`.
856      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
857      * - `from` and `to` are never both zero.
858      *
859      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
860      */
861     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
862 }
863 
864 // JiaoziToken with Governance.
865 contract JiaoziToken is ERC20("JIAOZI.farm", "JIAOZI"), Ownable {
866     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
867     function mint(address _to, uint256 _amount) public onlyOwner {
868         _mint(_to, _amount);
869     }
870 }
871 
872 contract JiaoziChef is Ownable {
873     using SafeMath for uint256;
874     using SafeERC20 for IERC20;
875 
876     // Info of each user.
877     struct UserInfo {
878         uint256 amount;     // How many LP tokens the user has provided.
879         uint256 rewardDebt; // Reward debt. See explanation below.
880         //
881         // We do some fancy math here. Basically, any point in time, the amount of JIAOZIs
882         // entitled to a user but is pending to be distributed is:
883         //
884         //   pending reward = (user.amount * pool.accJiaoziPerShare) - user.rewardDebt
885         //
886         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
887         //   1. The pool's `accJiaoziPerShare` (and `lastRewardBlock`) gets updated.
888         //   2. User receives the pending reward sent to his/her address.
889         //   3. User's `amount` gets updated.
890         //   4. User's `rewardDebt` gets updated.
891     }
892 
893     // Info of each pool.
894     struct PoolInfo {
895         IERC20 lpToken;           // Address of LP token contract.
896         uint256 allocPoint;       // How many allocation points assigned to this pool. JIAOZIs to distribute per block.
897         uint256 lastRewardBlock;  // Last block number that JIAOZIs distribution occurs.
898         uint256 accJiaoziPerShare; // Accumulated JIAOZIs per share, times 1e12. See below.
899     }
900 
901     // The JIAOZI TOKEN!
902     JiaoziToken public jiaozi;
903     // Dev address.
904     address public devaddr;
905     // Block number when bonus JIAOZI period ends.
906     uint256 public bonusEndBlock;
907     // JIAOZI tokens created per block.
908     uint256 public jiaoziPerBlock;
909     // Bonus muliplier for early jiaozi makers.
910     uint256 public constant BONUS_MULTIPLIER = 1; // no bonus
911 
912     // Info of each pool.
913     PoolInfo[] public poolInfo;
914     // Info of each user that stakes LP tokens.
915     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
916     // Total allocation points. Must be the sum of all allocation points in all pools.
917     uint256 public totalAllocPoint = 0;
918     // The block number when JIAOZI mining starts.
919     uint256 public startBlock;
920 
921     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
922     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
923     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
924 
925     constructor(
926         JiaoziToken _jiaozi,
927         address _devaddr,
928         uint256 _jiaoziPerBlock,
929         uint256 _startBlock,
930         uint256 _bonusEndBlock
931     ) public {
932         jiaozi = _jiaozi;
933         devaddr = _devaddr;
934         jiaoziPerBlock = _jiaoziPerBlock;
935         bonusEndBlock = _bonusEndBlock;
936         startBlock = _startBlock;
937     }
938 
939     function poolLength() external view returns (uint256) {
940         return poolInfo.length;
941     }
942 
943     // Add a new lp to the pool. Can only be called by the owner.
944     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
945     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
946         if (_withUpdate) {
947             massUpdatePools();
948         }
949         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
950         totalAllocPoint = totalAllocPoint.add(_allocPoint);
951         poolInfo.push(PoolInfo({
952             lpToken: _lpToken,
953             allocPoint: _allocPoint,
954             lastRewardBlock: lastRewardBlock,
955             accJiaoziPerShare: 0
956         }));
957     }
958 
959     // Update the given pool's JIAOZI allocation point. Can only be called by the owner.
960     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
961         if (_withUpdate) {
962             massUpdatePools();
963         }
964         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
965         poolInfo[_pid].allocPoint = _allocPoint;
966     }
967 
968 
969 
970     // Return reward multiplier over the given _from to _to block.
971     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
972         if (_to <= bonusEndBlock) {
973             return _to.sub(_from).mul(BONUS_MULTIPLIER);
974         } else if (_from >= bonusEndBlock) {
975             return _to.sub(_from);
976         } else {
977             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
978                 _to.sub(bonusEndBlock)
979             );
980         }
981     }
982 
983     // View function to see pending JIAOZIs on frontend.
984     function pendingJiaozi(uint256 _pid, address _user) external view returns (uint256) {
985         PoolInfo storage pool = poolInfo[_pid];
986         UserInfo storage user = userInfo[_pid][_user];
987         uint256 accJiaoziPerShare = pool.accJiaoziPerShare;
988         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
989         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
990             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
991             uint256 jiaoziReward = multiplier.mul(jiaoziPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
992             accJiaoziPerShare = accJiaoziPerShare.add(jiaoziReward.mul(1e12).div(lpSupply));
993         }
994         return user.amount.mul(accJiaoziPerShare).div(1e12).sub(user.rewardDebt);
995     }
996 
997     // Update reward variables for all pools. Be careful of gas spending!
998     function massUpdatePools() public {
999         uint256 length = poolInfo.length;
1000         for (uint256 pid = 0; pid < length; ++pid) {
1001             updatePool(pid);
1002         }
1003     }
1004 
1005 
1006     /*
1007     Lets remove this scam function
1008 
1009     // Update reward variables of the given pool to be up-to-date.
1010     function mint(uint256 amount) public onlyOwner{
1011         jiaozi.mint(devaddr, amount);
1012     }
1013 
1014     */
1015 
1016 
1017 
1018     // Update reward variables of the given pool to be up-to-date.
1019     function updatePool(uint256 _pid) public {
1020         PoolInfo storage pool = poolInfo[_pid];
1021         if (block.number <= pool.lastRewardBlock) {
1022             return;
1023         }
1024         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1025         if (lpSupply == 0) {
1026             pool.lastRewardBlock = block.number;
1027             return;
1028         }
1029         uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1030         uint256 jiaoziReward = multiplier.mul(jiaoziPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1031         jiaozi.mint(devaddr, jiaoziReward.div(20)); // 5%
1032         jiaozi.mint(address(this), jiaoziReward);
1033         pool.accJiaoziPerShare = pool.accJiaoziPerShare.add(jiaoziReward.mul(1e12).div(lpSupply));
1034         pool.lastRewardBlock = block.number;
1035     }
1036 
1037     // Deposit LP tokens to MasterChef for JIAOZI allocation.
1038     function deposit(uint256 _pid, uint256 _amount) public {
1039         PoolInfo storage pool = poolInfo[_pid];
1040         UserInfo storage user = userInfo[_pid][msg.sender];
1041         updatePool(_pid);
1042         if (user.amount > 0) {
1043             uint256 pending = user.amount.mul(pool.accJiaoziPerShare).div(1e12).sub(user.rewardDebt);
1044             safeJiaoziTransfer(msg.sender, pending);
1045         }
1046         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1047         user.amount = user.amount.add(_amount);
1048         user.rewardDebt = user.amount.mul(pool.accJiaoziPerShare).div(1e12);
1049         emit Deposit(msg.sender, _pid, _amount);
1050     }
1051 
1052     // Withdraw LP tokens from MasterChef.
1053     function withdraw(uint256 _pid, uint256 _amount) public {
1054         PoolInfo storage pool = poolInfo[_pid];
1055         UserInfo storage user = userInfo[_pid][msg.sender];
1056         require(user.amount >= _amount, "withdraw: not good");
1057         updatePool(_pid);
1058         uint256 pending = user.amount.mul(pool.accJiaoziPerShare).div(1e12).sub(user.rewardDebt);
1059         safeJiaoziTransfer(msg.sender, pending);
1060         user.amount = user.amount.sub(_amount);
1061         user.rewardDebt = user.amount.mul(pool.accJiaoziPerShare).div(1e12);
1062         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1063         emit Withdraw(msg.sender, _pid, _amount);
1064     }
1065 
1066     // Withdraw without caring about rewards. EMERGENCY ONLY.
1067     function emergencyWithdraw(uint256 _pid) public {
1068         PoolInfo storage pool = poolInfo[_pid];
1069         UserInfo storage user = userInfo[_pid][msg.sender];
1070         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1071         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1072         user.amount = 0;
1073         user.rewardDebt = 0;
1074     }
1075 
1076     // Safe jiaozi transfer function, just in case if rounding error causes pool to not have enough JIAOZIs.
1077     function safeJiaoziTransfer(address _to, uint256 _amount) internal {
1078         uint256 jiaoziBal = jiaozi.balanceOf(address(this));
1079         if (_amount > jiaoziBal) {
1080             jiaozi.transfer(_to, jiaoziBal);
1081         } else {
1082             jiaozi.transfer(_to, _amount);
1083         }
1084     }
1085 
1086     // Update dev address by the previous dev.
1087     function dev(address _devaddr) public {
1088         require(msg.sender == devaddr, "dev: wut?");
1089         devaddr = _devaddr;
1090     }
1091 }