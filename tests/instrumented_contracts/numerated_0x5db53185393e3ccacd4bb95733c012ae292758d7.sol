1 pragma solidity ^0.6.12;
2 
3 
4 /*
5 
6 website: baconswap.org
7 
8                                                             
9                                                             
10   ,---,                                                     
11 ,---.'|                                ,---.         ,---,  
12 |   | :                               '   ,'\    ,-+-. /  | 
13 :   : :       ,--.--.       ,---.    /   /   |  ,--.'|'   | 
14 :     |,-.   /       \     /     \  .   ; ,. : |   |  ,"' | 
15 |   : '  |  .--.  .-. |   /    / '  '   | |: : |   | /  | | 
16 |   |  / :   \__\/: . .  .    ' /   '   | .; : |   | |  | | 
17 '   : |: |   ," .--.; |  '   ; :__  |   :    | |   | |  |/  
18 |   | '/ :  /  /  ,.  |  '   | '.'|  \   \  /  |   | |--'   
19 |   :    | ;  :   .'   \ |   :    :   `----'   |   |/       
20 /    \  /  |  ,     .-./  \   \  /             '---'        
21 `-'----'    `--`---'       `----'                           
22                                                             
23 
24 
25 forked from SUSHI and YUNO and KIMCHI
26 
27 */
28 /*
29  * @dev Provides information about the current execution context, including the
30  * sender of the transaction and its data. While these are generally available
31  * via msg.sender and msg.data, they should not be accessed in such a direct
32  * manner, since when dealing with GSN meta-transactions the account sending and
33  * paying for execution may not be the actual sender (as far as an application
34  * is concerned).
35  *
36  * This contract is only required for intermediate, library-like contracts.
37  */
38 abstract contract Context {
39     function _msgSender() internal view virtual returns (address payable) {
40         return msg.sender;
41     }
42 
43     function _msgData() internal view virtual returns (bytes memory) {
44         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
45         return msg.data;
46     }
47 }
48 
49 /**
50  * @dev Interface of the ERC20 standard as defined in the EIP.
51  */
52 interface IERC20 {
53     /**
54      * @dev Returns the amount of tokens in existence.
55      */
56     function totalSupply() external view returns (uint256);
57 
58     /**
59      * @dev Returns the amount of tokens owned by `account`.
60      */
61     function balanceOf(address account) external view returns (uint256);
62 
63     /**
64      * @dev Moves `amount` tokens from the caller's account to `recipient`.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transfer(address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Returns the remaining number of tokens that `spender` will be
74      * allowed to spend on behalf of `owner` through {transferFrom}. This is
75      * zero by default.
76      *
77      * This value changes when {approve} or {transferFrom} are called.
78      */
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     /**
82      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * IMPORTANT: Beware that changing an allowance with this method brings the risk
87      * that someone may use both the old and the new allowance by unfortunate
88      * transaction ordering. One possible solution to mitigate this race
89      * condition is to first reduce the spender's allowance to 0 and set the
90      * desired value afterwards:
91      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
92      *
93      * Emits an {Approval} event.
94      */
95     function approve(address spender, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Moves `amount` tokens from `sender` to `recipient` using the
99      * allowance mechanism. `amount` is then deducted from the caller's
100      * allowance.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Emitted when `value` tokens are moved from one account (`from`) to
110      * another (`to`).
111      *
112      * Note that `value` may be zero.
113      */
114     event Transfer(address indexed from, address indexed to, uint256 value);
115 
116     /**
117      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
118      * a call to {approve}. `value` is the new allowance.
119      */
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 /**
124  * @dev Wrappers over Solidity's arithmetic operations with added overflow
125  * checks.
126  *
127  * Arithmetic operations in Solidity wrap on overflow. This can easily result
128  * in bugs, because programmers usually assume that an overflow raises an
129  * error, which is the standard behavior in high level programming languages.
130  * `SafeMath` restores this intuition by reverting the transaction when an
131  * operation overflows.
132  *
133  * Using this library instead of the unchecked operations eliminates an entire
134  * class of bugs, so it's recommended to use it always.
135  */
136 library SafeMath {
137     /**
138      * @dev Returns the addition of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `+` operator.
142      *
143      * Requirements:
144      *
145      * - Addition cannot overflow.
146      */
147     function add(uint256 a, uint256 b) internal pure returns (uint256) {
148         uint256 c = a + b;
149         require(c >= a, "SafeMath: addition overflow");
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting on
156      * overflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      *
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165         return sub(a, b, "SafeMath: subtraction overflow");
166     }
167 
168     /**
169      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
170      * overflow (when the result is negative).
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      *
176      * - Subtraction cannot overflow.
177      */
178     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b <= a, errorMessage);
180         uint256 c = a - b;
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the multiplication of two unsigned integers, reverting on
187      * overflow.
188      *
189      * Counterpart to Solidity's `*` operator.
190      *
191      * Requirements:
192      *
193      * - Multiplication cannot overflow.
194      */
195     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
196         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
197         // benefit is lost if 'b' is also tested.
198         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
199         if (a == 0) {
200             return 0;
201         }
202 
203         uint256 c = a * b;
204         require(c / a == b, "SafeMath: multiplication overflow");
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function div(uint256 a, uint256 b) internal pure returns (uint256) {
222         return div(a, b, "SafeMath: division by zero");
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b > 0, errorMessage);
239         uint256 c = a / b;
240         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
258         return mod(a, b, "SafeMath: modulo by zero");
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263      * Reverts with custom message when dividing by zero.
264      *
265      * Counterpart to Solidity's `%` operator. This function uses a `revert`
266      * opcode (which leaves remaining gas untouched) while Solidity uses an
267      * invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b != 0, errorMessage);
275         return a % b;
276     }
277 }
278 
279 /**
280  * @dev Collection of functions related to the address type
281  */
282 library Address {
283     /**
284      * @dev Returns true if `account` is a contract.
285      *
286      * [IMPORTANT]
287      * ====
288      * It is unsafe to assume that an address for which this function returns
289      * false is an externally-owned account (EOA) and not a contract.
290      *
291      * Among others, `isContract` will return false for the following
292      * types of addresses:
293      *
294      *  - an externally-owned account
295      *  - a contract in construction
296      *  - an address where a contract will be created
297      *  - an address where a contract lived, but was destroyed
298      * ====
299      */
300     function isContract(address account) internal view returns (bool) {
301         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
302         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
303         // for accounts without code, i.e. `keccak256('')`
304         bytes32 codehash;
305         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
306         // solhint-disable-next-line no-inline-assembly
307         assembly { codehash := extcodehash(account) }
308         return (codehash != accountHash && codehash != 0x0);
309     }
310 
311     /**
312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
313      * `recipient`, forwarding all available gas and reverting on errors.
314      *
315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
317      * imposed by `transfer`, making them unable to receive funds via
318      * `transfer`. {sendValue} removes this limitation.
319      *
320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
321      *
322      * IMPORTANT: because control is transferred to `recipient`, care must be
323      * taken to not create reentrancy vulnerabilities. Consider using
324      * {ReentrancyGuard} or the
325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
326      */
327     function sendValue(address payable recipient, uint256 amount) internal {
328         require(address(this).balance >= amount, "Address: insufficient balance");
329 
330         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
331         (bool success, ) = recipient.call{ value: amount }("");
332         require(success, "Address: unable to send value, recipient may have reverted");
333     }
334 
335     /**
336      * @dev Performs a Solidity function call using a low level `call`. A
337      * plain`call` is an unsafe replacement for a function call: use this
338      * function instead.
339      *
340      * If `target` reverts with a revert reason, it is bubbled up by this
341      * function (like regular Solidity function calls).
342      *
343      * Returns the raw returned data. To convert to the expected return value,
344      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
345      *
346      * Requirements:
347      *
348      * - `target` must be a contract.
349      * - calling `target` with `data` must not revert.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
354       return functionCall(target, data, "Address: low-level call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
359      * `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
364         return _functionCallWithValue(target, data, 0, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but also transferring `value` wei to `target`.
370      *
371      * Requirements:
372      *
373      * - the calling contract must have an ETH balance of at least `value`.
374      * - the called Solidity function must be `payable`.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
384      * with `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         return _functionCallWithValue(target, data, value, errorMessage);
391     }
392 
393     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
394         require(isContract(target), "Address: call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404 
405                 // solhint-disable-next-line no-inline-assembly
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 /**
418  * @title SafeERC20
419  * @dev Wrappers around ERC20 operations that throw on failure (when the token
420  * contract returns false). Tokens that return no value (and instead revert or
421  * throw on failure) are also supported, non-reverting calls are assumed to be
422  * successful.
423  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
424  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
425  */
426 library SafeERC20 {
427     using SafeMath for uint256;
428     using Address for address;
429 
430     function safeTransfer(IERC20 token, address to, uint256 value) internal {
431         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
432     }
433 
434     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
435         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
436     }
437 
438     /**
439      * @dev Deprecated. This function has issues similar to the ones found in
440      * {IERC20-approve}, and its usage is discouraged.
441      *
442      * Whenever possible, use {safeIncreaseAllowance} and
443      * {safeDecreaseAllowance} instead.
444      */
445     function safeApprove(IERC20 token, address spender, uint256 value) internal {
446         // safeApprove should only be called when setting an initial allowance,
447         // or when resetting it to zero. To increase and decrease it, use
448         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
449         // solhint-disable-next-line max-line-length
450         require((value == 0) || (token.allowance(address(this), spender) == 0),
451             "SafeERC20: approve from non-zero to non-zero allowance"
452         );
453         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
454     }
455 
456     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
457         uint256 newAllowance = token.allowance(address(this), spender).add(value);
458         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
459     }
460 
461     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
462         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
463         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
464     }
465 
466     /**
467      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
468      * on the return value: the return value is optional (but if data is returned, it must not be false).
469      * @param token The token targeted by the call.
470      * @param data The call data (encoded using abi.encode or one of its variants).
471      */
472     function _callOptionalReturn(IERC20 token, bytes memory data) private {
473         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
474         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
475         // the target address contains contract code and also asserts for success in the low-level call.
476 
477         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
478         if (returndata.length > 0) { // Return data is optional
479             // solhint-disable-next-line max-line-length
480             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
481         }
482     }
483 }
484 
485 /**
486  * @dev Contract module which provides a basic access control mechanism, where
487  * there is an account (an owner) that can be granted exclusive access to
488  * specific functions.
489  *
490  * By default, the owner account will be the one that deploys the contract. This
491  * can later be changed with {transferOwnership}.
492  *
493  * This module is used through inheritance. It will make available the modifier
494  * `onlyOwner`, which can be applied to your functions to restrict their use to
495  * the owner.
496  */
497 contract Ownable is Context {
498     address private _owner;
499 
500     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
501 
502     /**
503      * @dev Initializes the contract setting the deployer as the initial owner.
504      */
505     constructor () internal {
506         address msgSender = _msgSender();
507         _owner = msgSender;
508         emit OwnershipTransferred(address(0), msgSender);
509     }
510 
511     /**
512      * @dev Returns the address of the current owner.
513      */
514     function owner() public view returns (address) {
515         return _owner;
516     }
517 
518     /**
519      * @dev Throws if called by any account other than the owner.
520      */
521     modifier onlyOwner() {
522         require(_owner == _msgSender(), "Ownable: caller is not the owner");
523         _;
524     }
525 
526     /**
527      * @dev Leaves the contract without owner. It will not be possible to call
528      * `onlyOwner` functions anymore. Can only be called by the current owner.
529      *
530      * NOTE: Renouncing ownership will leave the contract without an owner,
531      * thereby removing any functionality that is only available to the owner.
532      */
533     function renounceOwnership() public virtual onlyOwner {
534         emit OwnershipTransferred(_owner, address(0));
535         _owner = address(0);
536     }
537 
538     /**
539      * @dev Transfers ownership of the contract to a new account (`newOwner`).
540      * Can only be called by the current owner.
541      */
542     function transferOwnership(address newOwner) public virtual onlyOwner {
543         require(newOwner != address(0), "Ownable: new owner is the zero address");
544         emit OwnershipTransferred(_owner, newOwner);
545         _owner = newOwner;
546     }
547 }
548 
549 /**
550  * @dev Implementation of the {IERC20} interface.
551  *
552  * This implementation is agnostic to the way tokens are created. This means
553  * that a supply mechanism has to be added in a derived contract using {_mint}.
554  * For a generic mechanism see {ERC20PresetMinterPauser}.
555  *
556  * TIP: For a detailed writeup see our guide
557  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
558  * to implement supply mechanisms].
559  *
560  * We have followed general OpenZeppelin guidelines: functions revert instead
561  * of returning `false` on failure. This behavior is nonetheless conventional
562  * and does not conflict with the expectations of ERC20 applications.
563  *
564  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
565  * This allows applications to reconstruct the allowance for all accounts just
566  * by listening to said events. Other implementations of the EIP may not emit
567  * these events, as it isn't required by the specification.
568  *
569  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
570  * functions have been added to mitigate the well-known issues around setting
571  * allowances. See {IERC20-approve}.
572  */
573 contract ERC20 is Context, IERC20 {
574     using SafeMath for uint256;
575     using Address for address;
576 
577     mapping (address => uint256) private _balances;
578 
579     mapping (address => mapping (address => uint256)) private _allowances;
580 
581     uint256 private _totalSupply;
582 
583     string private _name;
584     string private _symbol;
585     uint8 private _decimals;
586 
587     /**
588      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
589      * a default value of 18.
590      *
591      * To select a different value for {decimals}, use {_setupDecimals}.
592      *
593      * All three of these values are immutable: they can only be set once during
594      * construction.
595      */
596     constructor (string memory name, string memory symbol) public {
597         _name = name;
598         _symbol = symbol;
599         _decimals = 18;
600     }
601 
602     /**
603      * @dev Returns the name of the token.
604      */
605     function name() public view returns (string memory) {
606         return _name;
607     }
608 
609     /**
610      * @dev Returns the symbol of the token, usually a shorter version of the
611      * name.
612      */
613     function symbol() public view returns (string memory) {
614         return _symbol;
615     }
616 
617     /**
618      * @dev Returns the number of decimals used to get its user representation.
619      * For example, if `decimals` equals `2`, a balance of `505` tokens should
620      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
621      *
622      * Tokens usually opt for a value of 18, imitating the relationship between
623      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
624      * called.
625      *
626      * NOTE: This information is only used for _display_ purposes: it in
627      * no way affects any of the arithmetic of the contract, including
628      * {IERC20-balanceOf} and {IERC20-transfer}.
629      */
630     function decimals() public view returns (uint8) {
631         return _decimals;
632     }
633 
634     /**
635      * @dev See {IERC20-totalSupply}.
636      */
637     function totalSupply() public view override returns (uint256) {
638         return _totalSupply;
639     }
640 
641     /**
642      * @dev See {IERC20-balanceOf}.
643      */
644     function balanceOf(address account) public view override returns (uint256) {
645         return _balances[account];
646     }
647 
648     /**
649      * @dev See {IERC20-transfer}.
650      *
651      * Requirements:
652      *
653      * - `recipient` cannot be the zero address.
654      * - the caller must have a balance of at least `amount`.
655      */
656     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
657         _transfer(_msgSender(), recipient, amount);
658         return true;
659     }
660 
661     /**
662      * @dev See {IERC20-allowance}.
663      */
664     function allowance(address owner, address spender) public view virtual override returns (uint256) {
665         return _allowances[owner][spender];
666     }
667 
668     /**
669      * @dev See {IERC20-approve}.
670      *
671      * Requirements:
672      *
673      * - `spender` cannot be the zero address.
674      */
675     function approve(address spender, uint256 amount) public virtual override returns (bool) {
676         _approve(_msgSender(), spender, amount);
677         return true;
678     }
679 
680     /**
681      * @dev See {IERC20-transferFrom}.
682      *
683      * Emits an {Approval} event indicating the updated allowance. This is not
684      * required by the EIP. See the note at the beginning of {ERC20};
685      *
686      * Requirements:
687      * - `sender` and `recipient` cannot be the zero address.
688      * - `sender` must have a balance of at least `amount`.
689      * - the caller must have allowance for ``sender``'s tokens of at least
690      * `amount`.
691      */
692     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
693         _transfer(sender, recipient, amount);
694         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
695         return true;
696     }
697 
698     /**
699      * @dev Atomically increases the allowance granted to `spender` by the caller.
700      *
701      * This is an alternative to {approve} that can be used as a mitigation for
702      * problems described in {IERC20-approve}.
703      *
704      * Emits an {Approval} event indicating the updated allowance.
705      *
706      * Requirements:
707      *
708      * - `spender` cannot be the zero address.
709      */
710     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
711         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
712         return true;
713     }
714 
715     /**
716      * @dev Atomically decreases the allowance granted to `spender` by the caller.
717      *
718      * This is an alternative to {approve} that can be used as a mitigation for
719      * problems described in {IERC20-approve}.
720      *
721      * Emits an {Approval} event indicating the updated allowance.
722      *
723      * Requirements:
724      *
725      * - `spender` cannot be the zero address.
726      * - `spender` must have allowance for the caller of at least
727      * `subtractedValue`.
728      */
729     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
730         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
731         return true;
732     }
733 
734     /**
735      * @dev Moves tokens `amount` from `sender` to `recipient`.
736      *
737      * This is internal function is equivalent to {transfer}, and can be used to
738      * e.g. implement automatic token fees, slashing mechanisms, etc.
739      *
740      * Emits a {Transfer} event.
741      *
742      * Requirements:
743      *
744      * - `sender` cannot be the zero address.
745      * - `recipient` cannot be the zero address.
746      * - `sender` must have a balance of at least `amount`.
747      */
748     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
749         require(sender != address(0), "ERC20: transfer from the zero address");
750         require(recipient != address(0), "ERC20: transfer to the zero address");
751 
752         _beforeTokenTransfer(sender, recipient, amount);
753 
754         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
755         _balances[recipient] = _balances[recipient].add(amount);
756         emit Transfer(sender, recipient, amount);
757     }
758 
759     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
760      * the total supply.
761      *
762      * Emits a {Transfer} event with `from` set to the zero address.
763      *
764      * Requirements
765      *
766      * - `to` cannot be the zero address.
767      */
768     function _mint(address account, uint256 amount) internal virtual {
769         require(account != address(0), "ERC20: mint to the zero address");
770 
771         _beforeTokenTransfer(address(0), account, amount);
772 
773         _totalSupply = _totalSupply.add(amount);
774         _balances[account] = _balances[account].add(amount);
775         emit Transfer(address(0), account, amount);
776     }
777 
778     /**
779      * @dev Destroys `amount` tokens from `account`, reducing the
780      * total supply.
781      *
782      * Emits a {Transfer} event with `to` set to the zero address.
783      *
784      * Requirements
785      *
786      * - `account` cannot be the zero address.
787      * - `account` must have at least `amount` tokens.
788      */
789     function _burn(address account, uint256 amount) internal virtual {
790         require(account != address(0), "ERC20: burn from the zero address");
791 
792         _beforeTokenTransfer(account, address(0), amount);
793 
794         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
795         _totalSupply = _totalSupply.sub(amount);
796         emit Transfer(account, address(0), amount);
797     }
798 
799     /**
800      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
801      *
802      * This is internal function is equivalent to `approve`, and can be used to
803      * e.g. set automatic allowances for certain subsystems, etc.
804      *
805      * Emits an {Approval} event.
806      *
807      * Requirements:
808      *
809      * - `owner` cannot be the zero address.
810      * - `spender` cannot be the zero address.
811      */
812     function _approve(address owner, address spender, uint256 amount) internal virtual {
813         require(owner != address(0), "ERC20: approve from the zero address");
814         require(spender != address(0), "ERC20: approve to the zero address");
815 
816         _allowances[owner][spender] = amount;
817         emit Approval(owner, spender, amount);
818     }
819 
820     /**
821      * @dev Sets {decimals} to a value other than the default one of 18.
822      *
823      * WARNING: This function should only be called from the constructor. Most
824      * applications that interact with token contracts will not expect
825      * {decimals} to ever change, and may work incorrectly if it does.
826      */
827     function _setupDecimals(uint8 decimals_) internal {
828         _decimals = decimals_;
829     }
830 
831     /**
832      * @dev Hook that is called before any transfer of tokens. This includes
833      * minting and burning.
834      *
835      * Calling conditions:
836      *
837      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
838      * will be to transferred to `to`.
839      * - when `from` is zero, `amount` tokens will be minted for `to`.
840      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
841      * - `from` and `to` are never both zero.
842      *
843      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
844      */
845     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
846 }
847 
848 // BaconToken with Governance.
849 contract BaconToken is ERC20("BACON", "BACON"), Ownable {
850     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
851     function mint(address _to, uint256 _amount) public onlyOwner {
852         _mint(_to, _amount);
853     }
854 }
855 
856 contract BaconChef is Ownable {
857     using SafeMath for uint256;
858     using SafeERC20 for IERC20;
859 
860     // Info of each user.
861     struct UserInfo {
862         uint256 amount;     // How many LP tokens the user has provided.
863         uint256 rewardDebt; // Reward debt. See explanation below.
864         //
865         // We do some fancy math here. Basically, any point in time, the amount of BACONs
866         // entitled to a user but is pending to be distributed is:
867         //
868         //   pending reward = (user.amount * pool.accBaconPerShare) - user.rewardDebt
869         //
870         // Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
871         //   1. The pool's `accBaconPerShare` (and `lastRewardBlock`) gets updated.
872         //   2. User receives the pending reward sent to his/her address.
873         //   3. User's `amount` gets updated.
874         //   4. User's `rewardDebt` gets updated.
875     }
876 
877     // Info of each pool.
878     struct PoolInfo {
879         IERC20 lpToken;           // Address of LP token contract.
880         uint256 allocPoint;       // How many allocation points assigned to this pool. BACONs to distribute per block.
881         uint256 lastRewardBlock;  // Last block number that BACONs distribution occurs.
882         uint256 accBaconPerShare; // Accumulated BACONs per share, times 1e12. See below.
883     }
884 
885     // The BACON TOKEN!
886     BaconToken public bacon;
887     // Dev address.
888     address public devaddr;
889     // Block number when bonus BACON period ends.
890     uint256 public bonusEndBlock;
891     // BACON tokens created per block.
892     uint256 public baconPerBlock;
893     // Bonus muliplier for early bacon makers.
894     uint256 public constant BONUS_MULTIPLIER = 1; // no bonus
895 
896     // Info of each pool.
897     PoolInfo[] public poolInfo;
898     // Info of each user that stakes LP tokens.
899     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
900     // Total allocation poitns. Must be the sum of all allocation points in all pools.
901     uint256 public totalAllocPoint = 0;
902     // The block number when BACON mining starts.
903     uint256 public startBlock;
904 
905     uint256 public blockInADay = 5760; // Assume 15s per block
906     uint256 public halvePeriod = blockInADay;
907     uint256 public lastHalveBlock;
908     uint256 public minimumBaconPerBlock = 1 ether;
909 
910 
911     event Deposit(address indexed user, uint256 indexed pid, uint256 amount);
912     event Withdraw(address indexed user, uint256 indexed pid, uint256 amount);
913     event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
914 
915     event Halve(uint256 newBaconPerBlock, uint256 nextHalveBlockNumber);
916 
917     constructor(
918         BaconToken _bacon,
919         address _devaddr,
920         uint256 _startBlock
921     ) public {
922         bacon = _bacon;
923         devaddr = _devaddr;
924         baconPerBlock = 1000 ether;
925         startBlock = _startBlock;
926         lastHalveBlock = _startBlock;
927     }
928 
929     function doHalvingCheck(bool _withUpdate) public {
930         if (baconPerBlock <= minimumBaconPerBlock) {
931             return;
932         }
933         bool doHalve = block.number > lastHalveBlock + halvePeriod;
934         if (!doHalve) {
935             return;
936         }
937         uint256 newBaconPerBlock = baconPerBlock.div(2);
938         if (newBaconPerBlock >= minimumBaconPerBlock) {
939             baconPerBlock = newBaconPerBlock;
940             lastHalveBlock = block.number;
941             emit Halve(newBaconPerBlock, block.number + halvePeriod);
942 
943             if (_withUpdate) {
944                 massUpdatePools();
945             }
946         }
947     }
948 
949     function poolLength() external view returns (uint256) {
950         return poolInfo.length;
951     }
952 
953     // Add a new lp to the pool. Can only be called by the owner.
954     // XXX DO NOT add the same LP token more than once. Rewards will be messed up if you do.
955     function add(uint256 _allocPoint, IERC20 _lpToken, bool _withUpdate) public onlyOwner {
956         if (_withUpdate) {
957             massUpdatePools();
958         }
959         uint256 lastRewardBlock = block.number > startBlock ? block.number : startBlock;
960         totalAllocPoint = totalAllocPoint.add(_allocPoint);
961         poolInfo.push(PoolInfo({
962             lpToken: _lpToken,
963             allocPoint: _allocPoint,
964             lastRewardBlock: lastRewardBlock,
965             accBaconPerShare: 0
966         }));
967     }
968 
969     // Update the given pool's BACON allocation point. Can only be called by the owner.
970     function set(uint256 _pid, uint256 _allocPoint, bool _withUpdate) public onlyOwner {
971         if (_withUpdate) {
972             massUpdatePools();
973         }
974         totalAllocPoint = totalAllocPoint.sub(poolInfo[_pid].allocPoint).add(_allocPoint);
975         poolInfo[_pid].allocPoint = _allocPoint;
976     }
977 
978 
979 
980     // Return reward multiplier over the given _from to _to block.
981     function getMultiplier(uint256 _from, uint256 _to) public view returns (uint256) {
982         if (_to <= bonusEndBlock) {
983             return _to.sub(_from).mul(BONUS_MULTIPLIER);
984         } else if (_from >= bonusEndBlock) {
985             return _to.sub(_from);
986         } else {
987             return bonusEndBlock.sub(_from).mul(BONUS_MULTIPLIER).add(
988                 _to.sub(bonusEndBlock)
989             );
990         }
991     }
992 
993     // View function to see pending BACONs on frontend.
994     function pendingBacon(uint256 _pid, address _user) external view returns (uint256) {
995         PoolInfo storage pool = poolInfo[_pid];
996         UserInfo storage user = userInfo[_pid][_user];
997         uint256 accBaconPerShare = pool.accBaconPerShare;
998         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
999         if (block.number > pool.lastRewardBlock && lpSupply != 0) {
1000             uint256 multiplier = getMultiplier(pool.lastRewardBlock, block.number);
1001             uint256 baconReward = multiplier.mul(baconPerBlock).mul(pool.allocPoint).div(totalAllocPoint);
1002             accBaconPerShare = accBaconPerShare.add(baconReward.mul(1e12).div(lpSupply));
1003         }
1004         return user.amount.mul(accBaconPerShare).div(1e12).sub(user.rewardDebt);
1005     }
1006 
1007     // Update reward vairables for all pools. Be careful of gas spending!
1008     function massUpdatePools() public {
1009         uint256 length = poolInfo.length;
1010         for (uint256 pid = 0; pid < length; ++pid) {
1011             updatePool(pid);
1012         }
1013     }
1014     // Update reward variables of the given pool to be up-to-date.
1015     //function mint(uint256 amount) public onlyOwner{
1016     //    bacon.mint(devaddr, amount);
1017     //}
1018     // Update reward variables of the given pool to be up-to-date.
1019     function updatePool(uint256 _pid) public {
1020         doHalvingCheck(false);
1021         PoolInfo storage pool = poolInfo[_pid];
1022         if (block.number <= pool.lastRewardBlock) {
1023             return;
1024         }
1025         uint256 lpSupply = pool.lpToken.balanceOf(address(this));
1026         if (lpSupply == 0) {
1027             pool.lastRewardBlock = block.number;
1028             return;
1029         }
1030         uint256 blockPassed = block.number.sub(pool.lastRewardBlock);
1031         uint256 baconReward = blockPassed
1032             .mul(baconPerBlock)
1033             .mul(pool.allocPoint)
1034             .div(totalAllocPoint);
1035         bacon.mint(devaddr, baconReward.div(20)); // 5%
1036         bacon.mint(address(this), baconReward);
1037         pool.accBaconPerShare = pool.accBaconPerShare.add(baconReward.mul(1e12).div(lpSupply));
1038         pool.lastRewardBlock = block.number;
1039     }
1040 
1041     // Deposit LP tokens to MasterChef for BACON allocation.
1042     function deposit(uint256 _pid, uint256 _amount) public {
1043         PoolInfo storage pool = poolInfo[_pid];
1044         UserInfo storage user = userInfo[_pid][msg.sender];
1045         updatePool(_pid);
1046         if (user.amount > 0) {
1047             uint256 pending = user.amount.mul(pool.accBaconPerShare).div(1e12).sub(user.rewardDebt);
1048             safeBaconTransfer(msg.sender, pending);
1049         }
1050         pool.lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
1051         user.amount = user.amount.add(_amount);
1052         user.rewardDebt = user.amount.mul(pool.accBaconPerShare).div(1e12);
1053         emit Deposit(msg.sender, _pid, _amount);
1054     }
1055 
1056     // Withdraw LP tokens from MasterChef.
1057     function withdraw(uint256 _pid, uint256 _amount) public {
1058         PoolInfo storage pool = poolInfo[_pid];
1059         UserInfo storage user = userInfo[_pid][msg.sender];
1060         require(user.amount >= _amount, "withdraw: not good");
1061         updatePool(_pid);
1062         uint256 pending = user.amount.mul(pool.accBaconPerShare).div(1e12).sub(user.rewardDebt);
1063         safeBaconTransfer(msg.sender, pending);
1064         user.amount = user.amount.sub(_amount);
1065         user.rewardDebt = user.amount.mul(pool.accBaconPerShare).div(1e12);
1066         pool.lpToken.safeTransfer(address(msg.sender), _amount);
1067         emit Withdraw(msg.sender, _pid, _amount);
1068     }
1069 
1070     // Withdraw without caring about rewards. EMERGENCY ONLY.
1071     function emergencyWithdraw(uint256 _pid) public {
1072         PoolInfo storage pool = poolInfo[_pid];
1073         UserInfo storage user = userInfo[_pid][msg.sender];
1074         pool.lpToken.safeTransfer(address(msg.sender), user.amount);
1075         emit EmergencyWithdraw(msg.sender, _pid, user.amount);
1076         user.amount = 0;
1077         user.rewardDebt = 0;
1078     }
1079 
1080     // Safe bacon transfer function, just in case if rounding error causes pool to not have enough BACONs.
1081     function safeBaconTransfer(address _to, uint256 _amount) internal {
1082         uint256 baconBal = bacon.balanceOf(address(this));
1083         if (_amount > baconBal) {
1084             bacon.transfer(_to, baconBal);
1085         } else {
1086             bacon.transfer(_to, _amount);
1087         }
1088     }
1089 
1090     // Update dev address by the previous dev.
1091     function dev(address _devaddr) public {
1092         require(msg.sender == devaddr, "dev: wut?");
1093         devaddr = _devaddr;
1094     }
1095 }