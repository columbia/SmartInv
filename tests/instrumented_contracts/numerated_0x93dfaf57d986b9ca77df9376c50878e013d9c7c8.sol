1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-29
3 */
4 
5 /*
6  
7           _       _________ _______           _______ 
8 |\     /|( (    /|\__   __/(  ___  )|\     /|(  ____ \
9 | )   ( ||  \  ( |   ) (   | (   ) || )   ( || (    \/
10 | |   | ||   \ | |   | |   | |   | || |   | || (__    
11 | |   | || (\ \) |   | |   | |   | || |   | ||  __)   
12 | |   | || | \   |   | |   | | /\| || |   | || (      
13 | (___) || )  \  |___) (___| (_\ \ || (___) || (____/\
14 (_______)|/    )_)\_______/(____\/_)(_______)(_______/
15                                                       
16  _______  _        _______ 
17 (  ___  )( (    /|(  ____ \
18 | (   ) ||  \  ( || (    \/
19 | |   | ||   \ | || (__    
20 | |   | || (\ \) ||  __)   
21 | |   | || | \   || (      
22 | (___) || )  \  || (____/\
23 (_______)|/    )_)(_______/
24  
25  
26  https://unique.one
27  
28 */
29 
30 // File: @openzeppelin/contracts/GSN/Context.sol
31 
32 pragma solidity ^0.6.0;
33 
34 /*
35  * @dev Provides information about the current execution context, including the
36  * sender of the transaction and its data. While these are generally available
37  * via msg.sender and msg.data, they should not be accessed in such a direct
38  * manner, since when dealing with GSN meta-transactions the account sending and
39  * paying for execution may not be the actual sender (as far as an application
40  * is concerned).
41  *
42  * This contract is only required for intermediate, library-like contracts.
43  */
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address payable) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view virtual returns (bytes memory) {
50         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
51         return msg.data;
52     }
53 }
54 
55 
56 // File: @openzeppelin/contracts/math/SafeMath.sol
57 
58 pragma solidity ^0.6.0;
59 
60 /**
61  * @dev Wrappers over Solidity's arithmetic operations with added overflow
62  * checks.
63  *
64  * Arithmetic operations in Solidity wrap on overflow. This can easily result
65  * in bugs, because programmers usually assume that an overflow raises an
66  * error, which is the standard behavior in high level programming languages.
67  * `SafeMath` restores this intuition by reverting the transaction when an
68  * operation overflows.
69  *
70  * Using this library instead of the unchecked operations eliminates an entire
71  * class of bugs, so it's recommended to use it always.
72  */
73 library SafeMath {
74     /**
75      * @dev Returns the addition of two unsigned integers, reverting on
76      * overflow.
77      *
78      * Counterpart to Solidity's `+` operator.
79      *
80      * Requirements:
81      *
82      * - Addition cannot overflow.
83      */
84     function add(uint256 a, uint256 b) internal pure returns (uint256) {
85         uint256 c = a + b;
86         require(c >= a, "SafeMath: addition overflow");
87 
88         return c;
89     }
90 
91     /**
92      * @dev Returns the subtraction of two unsigned integers, reverting on
93      * overflow (when the result is negative).
94      *
95      * Counterpart to Solidity's `-` operator.
96      *
97      * Requirements:
98      *
99      * - Subtraction cannot overflow.
100      */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         return sub(a, b, "SafeMath: subtraction overflow");
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      *
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
116         require(b <= a, errorMessage);
117         uint256 c = a - b;
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the multiplication of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `*` operator.
127      *
128      * Requirements:
129      *
130      * - Multiplication cannot overflow.
131      */
132     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
133         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
134         // benefit is lost if 'b' is also tested.
135         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
136         if (a == 0) {
137             return 0;
138         }
139 
140         uint256 c = a * b;
141         require(c / a == b, "SafeMath: multiplication overflow");
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the integer division of two unsigned integers. Reverts on
148      * division by zero. The result is rounded towards zero.
149      *
150      * Counterpart to Solidity's `/` operator. Note: this function uses a
151      * `revert` opcode (which leaves remaining gas untouched) while Solidity
152      * uses an invalid opcode to revert (consuming all remaining gas).
153      *
154      * Requirements:
155      *
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         return div(a, b, "SafeMath: division by zero");
160     }
161 
162     /**
163      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
164      * division by zero. The result is rounded towards zero.
165      *
166      * Counterpart to Solidity's `/` operator. Note: this function uses a
167      * `revert` opcode (which leaves remaining gas untouched) while Solidity
168      * uses an invalid opcode to revert (consuming all remaining gas).
169      *
170      * Requirements:
171      *
172      * - The divisor cannot be zero.
173      */
174     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
175         require(b > 0, errorMessage);
176         uint256 c = a / b;
177         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
184      * Reverts when dividing by zero.
185      *
186      * Counterpart to Solidity's `%` operator. This function uses a `revert`
187      * opcode (which leaves remaining gas untouched) while Solidity uses an
188      * invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
195         return mod(a, b, "SafeMath: modulo by zero");
196     }
197 
198     /**
199      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
200      * Reverts with custom message when dividing by zero.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b != 0, errorMessage);
212         return a % b;
213     }
214 }
215 
216 
217 // File: @openzeppelin/contracts/utils/Address.sol
218 
219 pragma solidity ^0.6.2;
220 
221 /**
222  * @dev Collection of functions related to the address type
223  */
224 library Address {
225     /**
226      * @dev Returns true if `account` is a contract.
227      *
228      * [IMPORTANT]
229      * ====
230      * It is unsafe to assume that an address for which this function returns
231      * false is an externally-owned account (EOA) and not a contract.
232      *
233      * Among others, `isContract` will return false for the following
234      * types of addresses:
235      *
236      *  - an externally-owned account
237      *  - a contract in construction
238      *  - an address where a contract will be created
239      *  - an address where a contract lived, but was destroyed
240      * ====
241      */
242     function isContract(address account) internal view returns (bool) {
243         // This method relies in extcodesize, which returns 0 for contracts in
244         // construction, since the code is only stored at the end of the
245         // constructor execution.
246 
247         uint256 size;
248         // solhint-disable-next-line no-inline-assembly
249         assembly { size := extcodesize(account) }
250         return size > 0;
251     }
252 
253     /**
254      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
255      * `recipient`, forwarding all available gas and reverting on errors.
256      *
257      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
258      * of certain opcodes, possibly making contracts go over the 2300 gas limit
259      * imposed by `transfer`, making them unable to receive funds via
260      * `transfer`. {sendValue} removes this limitation.
261      *
262      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
263      *
264      * IMPORTANT: because control is transferred to `recipient`, care must be
265      * taken to not create reentrancy vulnerabilities. Consider using
266      * {ReentrancyGuard} or the
267      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
268      */
269     function sendValue(address payable recipient, uint256 amount) internal {
270         require(address(this).balance >= amount, "Address: insufficient balance");
271 
272         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
273         (bool success, ) = recipient.call{ value: amount }("");
274         require(success, "Address: unable to send value, recipient may have reverted");
275     }
276 
277     /**
278      * @dev Performs a Solidity function call using a low level `call`. A
279      * plain`call` is an unsafe replacement for a function call: use this
280      * function instead.
281      *
282      * If `target` reverts with a revert reason, it is bubbled up by this
283      * function (like regular Solidity function calls).
284      *
285      * Returns the raw returned data. To convert to the expected return value,
286      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
287      *
288      * Requirements:
289      *
290      * - `target` must be a contract.
291      * - calling `target` with `data` must not revert.
292      *
293      * _Available since v3.1._
294      */
295     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
296       return functionCall(target, data, "Address: low-level call failed");
297     }
298 
299     /**
300      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
301      * `errorMessage` as a fallback revert reason when `target` reverts.
302      *
303      * _Available since v3.1._
304      */
305     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
306         return _functionCallWithValue(target, data, 0, errorMessage);
307     }
308 
309     /**
310      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
311      * but also transferring `value` wei to `target`.
312      *
313      * Requirements:
314      *
315      * - the calling contract must have an ETH balance of at least `value`.
316      * - the called Solidity function must be `payable`.
317      *
318      * _Available since v3.1._
319      */
320     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
321         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
326      * with `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
331         require(address(this).balance >= value, "Address: insufficient balance for call");
332         return _functionCallWithValue(target, data, value, errorMessage);
333     }
334 
335     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
336         require(isContract(target), "Address: call to non-contract");
337 
338         // solhint-disable-next-line avoid-low-level-calls
339         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
340         if (success) {
341             return returndata;
342         } else {
343             // Look for revert reason and bubble it up if present
344             if (returndata.length > 0) {
345                 // The easiest way to bubble the revert reason is using memory via assembly
346 
347                 // solhint-disable-next-line no-inline-assembly
348                 assembly {
349                     let returndata_size := mload(returndata)
350                     revert(add(32, returndata), returndata_size)
351                 }
352             } else {
353                 revert(errorMessage);
354             }
355         }
356     }
357 }
358 
359 
360 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
361 
362 pragma solidity ^0.6.0;
363 
364 /**
365  * @dev Interface of the ERC20 standard as defined in the EIP.
366  */
367 interface IERC20 {
368     /**
369      * @dev Returns the amount of tokens in existence.
370      */
371     function totalSupply() external view returns (uint256);
372 
373     /**
374      * @dev Returns the amount of tokens owned by `account`.
375      */
376     function balanceOf(address account) external view returns (uint256);
377 
378     /**
379      * @dev Moves `amount` tokens from the caller's account to `recipient`.
380      *
381      * Returns a boolean value indicating whether the operation succeeded.
382      *
383      * Emits a {Transfer} event.
384      */
385     function transfer(address recipient, uint256 amount) external returns (bool);
386 
387     /**
388      * @dev Returns the remaining number of tokens that `spender` will be
389      * allowed to spend on behalf of `owner` through {transferFrom}. This is
390      * zero by default.
391      *
392      * This value changes when {approve} or {transferFrom} are called.
393      */
394     function allowance(address owner, address spender) external view returns (uint256);
395 
396     /**
397      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
398      *
399      * Returns a boolean value indicating whether the operation succeeded.
400      *
401      * IMPORTANT: Beware that changing an allowance with this method brings the risk
402      * that someone may use both the old and the new allowance by unfortunate
403      * transaction ordering. One possible solution to mitigate this race
404      * condition is to first reduce the spender's allowance to 0 and set the
405      * desired value afterwards:
406      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
407      *
408      * Emits an {Approval} event.
409      */
410     function approve(address spender, uint256 amount) external returns (bool);
411 
412     /**
413      * @dev Moves `amount` tokens from `sender` to `recipient` using the
414      * allowance mechanism. `amount` is then deducted from the caller's
415      * allowance.
416      *
417      * Returns a boolean value indicating whether the operation succeeded.
418      *
419      * Emits a {Transfer} event.
420      */
421     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
422 
423     /**
424      * @dev Emitted when `value` tokens are moved from one account (`from`) to
425      * another (`to`).
426      *
427      * Note that `value` may be zero.
428      */
429     event Transfer(address indexed from, address indexed to, uint256 value);
430 
431     /**
432      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
433      * a call to {approve}. `value` is the new allowance.
434      */
435     event Approval(address indexed owner, address indexed spender, uint256 value);
436 }
437 
438 
439 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
440 
441 pragma solidity ^0.6.0;
442 
443 /**
444  * @title SafeERC20
445  * @dev Wrappers around ERC20 operations that throw on failure (when the token
446  * contract returns false). Tokens that return no value (and instead revert or
447  * throw on failure) are also supported, non-reverting calls are assumed to be
448  * successful.
449  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
450  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
451  */
452 library SafeERC20 {
453     using SafeMath for uint256;
454     using Address for address;
455 
456     function safeTransfer(IERC20 token, address to, uint256 value) internal {
457         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
458     }
459 
460     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
461         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
462     }
463 
464     /**
465      * @dev Deprecated. This function has issues similar to the ones found in
466      * {IERC20-approve}, and its usage is discouraged.
467      *
468      * Whenever possible, use {safeIncreaseAllowance} and
469      * {safeDecreaseAllowance} instead.
470      */
471     function safeApprove(IERC20 token, address spender, uint256 value) internal {
472         // safeApprove should only be called when setting an initial allowance,
473         // or when resetting it to zero. To increase and decrease it, use
474         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
475         // solhint-disable-next-line max-line-length
476         require((value == 0) || (token.allowance(address(this), spender) == 0),
477             "SafeERC20: approve from non-zero to non-zero allowance"
478         );
479         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
480     }
481 
482     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
483         uint256 newAllowance = token.allowance(address(this), spender).add(value);
484         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
485     }
486 
487     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
488         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
489         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
490     }
491 
492     /**
493      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
494      * on the return value: the return value is optional (but if data is returned, it must not be false).
495      * @param token The token targeted by the call.
496      * @param data The call data (encoded using abi.encode or one of its variants).
497      */
498     function _callOptionalReturn(IERC20 token, bytes memory data) private {
499         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
500         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
501         // the target address contains contract code and also asserts for success in the low-level call.
502 
503         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
504         if (returndata.length > 0) { // Return data is optional
505             // solhint-disable-next-line max-line-length
506             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
507         }
508     }
509 }
510 
511 
512 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
513 
514 pragma solidity ^0.6.0;
515 
516 /**
517  * @dev Implementation of the {IERC20} interface.
518  *
519  * This implementation is agnostic to the way tokens are created. This means
520  * that a supply mechanism has to be added in a derived contract using {_mint}.
521  * For a generic mechanism see {ERC20PresetMinterPauser}.
522  *
523  * TIP: For a detailed writeup see our guide
524  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
525  * to implement supply mechanisms].
526  *
527  * We have followed general OpenZeppelin guidelines: functions revert instead
528  * of returning `false` on failure. This behavior is nonetheless conventional
529  * and does not conflict with the expectations of ERC20 applications.
530  *
531  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
532  * This allows applications to reconstruct the allowance for all accounts just
533  * by listening to said events. Other implementations of the EIP may not emit
534  * these events, as it isn't required by the specification.
535  *
536  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
537  * functions have been added to mitigate the well-known issues around setting
538  * allowances. See {IERC20-approve}.
539  */
540 contract ERC20 is Context, IERC20 {
541     using SafeMath for uint256;
542     using Address for address;
543 
544     mapping (address => uint256) private _balances;
545 
546     mapping (address => mapping (address => uint256)) private _allowances;
547 
548     uint256 private _totalSupply;
549 
550     string private _name;
551     string private _symbol;
552     uint8 private _decimals;
553 
554     /**
555      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
556      * a default value of 18.
557      *
558      * To select a different value for {decimals}, use {_setupDecimals}.
559      *
560      * All three of these values are immutable: they can only be set once during
561      * construction.
562      */
563     constructor (string memory name, string memory symbol) public {
564         _name = name;
565         _symbol = symbol;
566         _decimals = 18;
567     }
568 
569     /**
570      * @dev Returns the name of the token.
571      */
572     function name() public view returns (string memory) {
573         return _name;
574     }
575 
576     /**
577      * @dev Returns the symbol of the token, usually a shorter version of the
578      * name.
579      */
580     function symbol() public view returns (string memory) {
581         return _symbol;
582     }
583 
584     /**
585      * @dev Returns the number of decimals used to get its user representation.
586      * For example, if `decimals` equals `2`, a balance of `505` tokens should
587      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
588      *
589      * Tokens usually opt for a value of 18, imitating the relationship between
590      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
591      * called.
592      *
593      * NOTE: This information is only used for _display_ purposes: it in
594      * no way affects any of the arithmetic of the contract, including
595      * {IERC20-balanceOf} and {IERC20-transfer}.
596      */
597     function decimals() public view returns (uint8) {
598         return _decimals;
599     }
600 
601     /**
602      * @dev See {IERC20-totalSupply}.
603      */
604     function totalSupply() public view override returns (uint256) {
605         return _totalSupply;
606     }
607 
608     /**
609      * @dev See {IERC20-balanceOf}.
610      */
611     function balanceOf(address account) public view override returns (uint256) {
612         return _balances[account];
613     }
614 
615     /**
616      * @dev See {IERC20-transfer}.
617      *
618      * Requirements:
619      *
620      * - `recipient` cannot be the zero address.
621      * - the caller must have a balance of at least `amount`.
622      */
623     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
624         _transfer(_msgSender(), recipient, amount);
625         return true;
626     }
627 
628     /**
629      * @dev See {IERC20-allowance}.
630      */
631     function allowance(address owner, address spender) public view virtual override returns (uint256) {
632         return _allowances[owner][spender];
633     }
634 
635     /**
636      * @dev See {IERC20-approve}.
637      *
638      * Requirements:
639      *
640      * - `spender` cannot be the zero address.
641      */
642     function approve(address spender, uint256 amount) public virtual override returns (bool) {
643         _approve(_msgSender(), spender, amount);
644         return true;
645     }
646 
647     /**
648      * @dev See {IERC20-transferFrom}.
649      *
650      * Emits an {Approval} event indicating the updated allowance. This is not
651      * required by the EIP. See the note at the beginning of {ERC20};
652      *
653      * Requirements:
654      * - `sender` and `recipient` cannot be the zero address.
655      * - `sender` must have a balance of at least `amount`.
656      * - the caller must have allowance for ``sender``'s tokens of at least
657      * `amount`.
658      */
659     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
660         _transfer(sender, recipient, amount);
661         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
662         return true;
663     }
664 
665     /**
666      * @dev Atomically increases the allowance granted to `spender` by the caller.
667      *
668      * This is an alternative to {approve} that can be used as a mitigation for
669      * problems described in {IERC20-approve}.
670      *
671      * Emits an {Approval} event indicating the updated allowance.
672      *
673      * Requirements:
674      *
675      * - `spender` cannot be the zero address.
676      */
677     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
678         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
679         return true;
680     }
681 
682     /**
683      * @dev Atomically decreases the allowance granted to `spender` by the caller.
684      *
685      * This is an alternative to {approve} that can be used as a mitigation for
686      * problems described in {IERC20-approve}.
687      *
688      * Emits an {Approval} event indicating the updated allowance.
689      *
690      * Requirements:
691      *
692      * - `spender` cannot be the zero address.
693      * - `spender` must have allowance for the caller of at least
694      * `subtractedValue`.
695      */
696     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
697         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
698         return true;
699     }
700 
701     /**
702      * @dev Moves tokens `amount` from `sender` to `recipient`.
703      *
704      * This is internal function is equivalent to {transfer}, and can be used to
705      * e.g. implement automatic token fees, slashing mechanisms, etc.
706      *
707      * Emits a {Transfer} event.
708      *
709      * Requirements:
710      *
711      * - `sender` cannot be the zero address.
712      * - `recipient` cannot be the zero address.
713      * - `sender` must have a balance of at least `amount`.
714      */
715     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
716         require(sender != address(0), "ERC20: transfer from the zero address");
717         require(recipient != address(0), "ERC20: transfer to the zero address");
718 
719         _beforeTokenTransfer(sender, recipient, amount);
720 
721         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
722         _balances[recipient] = _balances[recipient].add(amount);
723         emit Transfer(sender, recipient, amount);
724     }
725 
726     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
727      * the total supply.
728      *
729      * Emits a {Transfer} event with `from` set to the zero address.
730      *
731      * Requirements
732      *
733      * - `to` cannot be the zero address.
734      */
735     function _mint(address account, uint256 amount) internal virtual {
736         require(account != address(0), "ERC20: mint to the zero address");
737 
738         _beforeTokenTransfer(address(0), account, amount);
739 
740         _totalSupply = _totalSupply.add(amount);
741         _balances[account] = _balances[account].add(amount);
742         emit Transfer(address(0), account, amount);
743     }
744 
745     /**
746      * @dev Destroys `amount` tokens from `account`, reducing the
747      * total supply.
748      *
749      * Emits a {Transfer} event with `to` set to the zero address.
750      *
751      * Requirements
752      *
753      * - `account` cannot be the zero address.
754      * - `account` must have at least `amount` tokens.
755      */
756     function _burn(address account, uint256 amount) internal virtual {
757         require(account != address(0), "ERC20: burn from the zero address");
758 
759         _beforeTokenTransfer(account, address(0), amount);
760 
761         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
762         _totalSupply = _totalSupply.sub(amount);
763         emit Transfer(account, address(0), amount);
764     }
765 
766     /**
767      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
768      *
769      * This internal function is equivalent to `approve`, and can be used to
770      * e.g. set automatic allowances for certain subsystems, etc.
771      *
772      * Emits an {Approval} event.
773      *
774      * Requirements:
775      *
776      * - `owner` cannot be the zero address.
777      * - `spender` cannot be the zero address.
778      */
779     function _approve(address owner, address spender, uint256 amount) internal virtual {
780         require(owner != address(0), "ERC20: approve from the zero address");
781         require(spender != address(0), "ERC20: approve to the zero address");
782 
783         _allowances[owner][spender] = amount;
784         emit Approval(owner, spender, amount);
785     }
786 
787     /**
788      * @dev Sets {decimals} to a value other than the default one of 18.
789      *
790      * WARNING: This function should only be called from the constructor. Most
791      * applications that interact with token contracts will not expect
792      * {decimals} to ever change, and may work incorrectly if it does.
793      */
794     function _setupDecimals(uint8 decimals_) internal {
795         _decimals = decimals_;
796     }
797 
798     /**
799      * @dev Hook that is called before any transfer of tokens. This includes
800      * minting and burning.
801      *
802      * Calling conditions:
803      *
804      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
805      * will be to transferred to `to`.
806      * - when `from` is zero, `amount` tokens will be minted for `to`.
807      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
808      * - `from` and `to` are never both zero.
809      *
810      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
811      */
812     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
813 }
814 
815 
816 
817 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
818 
819 pragma solidity ^0.6.0;
820 
821 /**
822  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
823  */
824 abstract contract ERC20Capped is ERC20 {
825     uint256 private _cap;
826 
827     /**
828      * @dev Sets the value of the `cap`. This value is immutable, it can only be
829      * set once during construction.
830      */
831     constructor (uint256 cap) public {
832         require(cap > 0, "ERC20Capped: cap is 0");
833         _cap = cap;
834     }
835 
836     /**
837      * @dev Returns the cap on the token's total supply.
838      */
839     function cap() public view returns (uint256) {
840         return _cap;
841     }
842 
843     /**
844      * @dev See {ERC20-_beforeTokenTransfer}.
845      *
846      * Requirements:
847      *
848      * - minted tokens must not cause the total supply to go over the cap.
849      */
850     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
851         super._beforeTokenTransfer(from, to, amount);
852 
853         if (from == address(0)) { // When minting tokens
854             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
855         }
856     }
857 }
858 
859 
860 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
861 
862 pragma solidity ^0.6.0;
863 
864 /**
865  * @dev Extension of {ERC20} that allows token holders to destroy both their own
866  * tokens and those that they have an allowance for, in a way that can be
867  * recognized off-chain (via event analysis).
868  */
869 abstract contract ERC20Burnable is Context, ERC20 {
870     /**
871      * @dev Destroys `amount` tokens from the caller.
872      *
873      * See {ERC20-_burn}.
874      */
875     function burn(uint256 amount) public virtual {
876         _burn(_msgSender(), amount);
877     }
878 
879     /**
880      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
881      * allowance.
882      *
883      * See {ERC20-_burn} and {ERC20-allowance}.
884      *
885      * Requirements:
886      *
887      * - the caller must have allowance for ``accounts``'s tokens of at least
888      * `amount`.
889      */
890     function burnFrom(address account, uint256 amount) public virtual {
891         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
892 
893         _approve(account, _msgSender(), decreasedAllowance);
894         _burn(account, amount);
895     }
896 }
897 
898 
899 
900 // File: RareToken.sol
901 
902 pragma solidity ^0.6.2;
903 
904 contract RareToken is ERC20Capped, ERC20Burnable {
905     using SafeERC20 for IERC20;
906     using Address for address;
907     using SafeMath for uint;
908 
909     address public governance;
910     mapping (address => bool) public minters;
911 
912     constructor()
913         public
914         ERC20('RARE.UNIQUE', 'RARE')
915         ERC20Capped(10000000000000000000000000)   // Cap at 10 mil token
916         { 
917             governance = msg.sender;
918         }
919 
920     function mint(address account, uint256 amount) public {
921         require(minters[msg.sender], "!minter");
922         _mint(account, amount);
923     }
924 
925     function setGovernance(address _governance) public {
926         require(msg.sender == governance, "!governance");
927         governance = _governance;
928     }
929 
930     function addMinter(address _minter) public {
931         require(msg.sender == governance, "!governance");
932         minters[_minter] = true;
933     }
934 
935     function removeMinter(address _minter) public {
936         require(msg.sender == governance, "!governance");
937         minters[_minter] = false;
938     }
939     
940     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override (ERC20, ERC20Capped) {
941         ERC20Capped._beforeTokenTransfer(from, to, amount);
942 
943     }    
944 
945 }