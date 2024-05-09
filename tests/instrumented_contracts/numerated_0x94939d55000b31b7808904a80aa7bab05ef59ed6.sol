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
31 
32 forked from KIMCHI
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
364       return functionCall(target, data, "Address: low-level call failed");
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
861 // JiaoziToken with Governance.
862 contract JiaoziToken is ERC20("JIAOZI.farm", "JIAOZI"), Ownable {
863     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
864     function mint(address _to, uint256 _amount) public onlyOwner {
865         _mint(_to, _amount);
866     }
867 }