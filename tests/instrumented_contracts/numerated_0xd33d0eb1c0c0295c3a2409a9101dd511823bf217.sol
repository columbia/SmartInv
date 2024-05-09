1 /*
2  
3           _       _________ _______           _______ 
4 |\     /|( (    /|\__   __/(  ___  )|\     /|(  ____ \
5 | )   ( ||  \  ( |   ) (   | (   ) || )   ( || (    \/
6 | |   | ||   \ | |   | |   | |   | || |   | || (__    
7 | |   | || (\ \) |   | |   | |   | || |   | ||  __)   
8 | |   | || | \   |   | |   | | /\| || |   | || (      
9 | (___) || )  \  |___) (___| (_\ \ || (___) || (____/\
10 (_______)|/    )_)\_______/(____\/_)(_______)(_______/
11                                                       
12  _______  _______  _        _______                   
13 (  ____ \(  ___  )( (    /|(  ____ \                  
14 | (    \/| (   ) ||  \  ( || (    \/                  
15 | (__    | (___) ||   \ | || (_____                   
16 |  __)   |  ___  || (\ \) |(_____  )                  
17 | (      | (   ) || | \   |      ) |                  
18 | )      | )   ( || )  \  |/\____) |                  
19 |/       |/     \||/    )_)\_______)                  
20                                                       
21  https://unique.fans
22  
23 */
24 
25 // File: @openzeppelin/contracts/GSN/Context.sol
26 
27 pragma solidity ^0.6.0;
28 
29 /*
30  * @dev Provides information about the current execution context, including the
31  * sender of the transaction and its data. While these are generally available
32  * via msg.sender and msg.data, they should not be accessed in such a direct
33  * manner, since when dealing with GSN meta-transactions the account sending and
34  * paying for execution may not be the actual sender (as far as an application
35  * is concerned).
36  *
37  * This contract is only required for intermediate, library-like contracts.
38  */
39 abstract contract Context {
40     function _msgSender() internal view virtual returns (address payable) {
41         return msg.sender;
42     }
43 
44     function _msgData() internal view virtual returns (bytes memory) {
45         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
46         return msg.data;
47     }
48 }
49 
50 
51 // File: @openzeppelin/contracts/math/SafeMath.sol
52 
53 pragma solidity ^0.6.0;
54 
55 /**
56  * @dev Wrappers over Solidity's arithmetic operations with added overflow
57  * checks.
58  *
59  * Arithmetic operations in Solidity wrap on overflow. This can easily result
60  * in bugs, because programmers usually assume that an overflow raises an
61  * error, which is the standard behavior in high level programming languages.
62  * `SafeMath` restores this intuition by reverting the transaction when an
63  * operation overflows.
64  *
65  * Using this library instead of the unchecked operations eliminates an entire
66  * class of bugs, so it's recommended to use it always.
67  */
68 library SafeMath {
69     /**
70      * @dev Returns the addition of two unsigned integers, reverting on
71      * overflow.
72      *
73      * Counterpart to Solidity's `+` operator.
74      *
75      * Requirements:
76      *
77      * - Addition cannot overflow.
78      */
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a, "SafeMath: addition overflow");
82 
83         return c;
84     }
85 
86     /**
87      * @dev Returns the subtraction of two unsigned integers, reverting on
88      * overflow (when the result is negative).
89      *
90      * Counterpart to Solidity's `-` operator.
91      *
92      * Requirements:
93      *
94      * - Subtraction cannot overflow.
95      */
96     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
97         return sub(a, b, "SafeMath: subtraction overflow");
98     }
99 
100     /**
101      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
102      * overflow (when the result is negative).
103      *
104      * Counterpart to Solidity's `-` operator.
105      *
106      * Requirements:
107      *
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
111         require(b <= a, errorMessage);
112         uint256 c = a - b;
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the multiplication of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `*` operator.
122      *
123      * Requirements:
124      *
125      * - Multiplication cannot overflow.
126      */
127     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
128         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
129         // benefit is lost if 'b' is also tested.
130         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
131         if (a == 0) {
132             return 0;
133         }
134 
135         uint256 c = a * b;
136         require(c / a == b, "SafeMath: multiplication overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the integer division of two unsigned integers. Reverts on
143      * division by zero. The result is rounded towards zero.
144      *
145      * Counterpart to Solidity's `/` operator. Note: this function uses a
146      * `revert` opcode (which leaves remaining gas untouched) while Solidity
147      * uses an invalid opcode to revert (consuming all remaining gas).
148      *
149      * Requirements:
150      *
151      * - The divisor cannot be zero.
152      */
153     function div(uint256 a, uint256 b) internal pure returns (uint256) {
154         return div(a, b, "SafeMath: division by zero");
155     }
156 
157     /**
158      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
159      * division by zero. The result is rounded towards zero.
160      *
161      * Counterpart to Solidity's `/` operator. Note: this function uses a
162      * `revert` opcode (which leaves remaining gas untouched) while Solidity
163      * uses an invalid opcode to revert (consuming all remaining gas).
164      *
165      * Requirements:
166      *
167      * - The divisor cannot be zero.
168      */
169     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b > 0, errorMessage);
171         uint256 c = a / b;
172         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
179      * Reverts when dividing by zero.
180      *
181      * Counterpart to Solidity's `%` operator. This function uses a `revert`
182      * opcode (which leaves remaining gas untouched) while Solidity uses an
183      * invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
190         return mod(a, b, "SafeMath: modulo by zero");
191     }
192 
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * Reverts with custom message when dividing by zero.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b != 0, errorMessage);
207         return a % b;
208     }
209 }
210 
211 
212 // File: @openzeppelin/contracts/utils/Address.sol
213 
214 pragma solidity ^0.6.2;
215 
216 /**
217  * @dev Collection of functions related to the address type
218  */
219 library Address {
220     /**
221      * @dev Returns true if `account` is a contract.
222      *
223      * [IMPORTANT]
224      * ====
225      * It is unsafe to assume that an address for which this function returns
226      * false is an externally-owned account (EOA) and not a contract.
227      *
228      * Among others, `isContract` will return false for the following
229      * types of addresses:
230      *
231      *  - an externally-owned account
232      *  - a contract in construction
233      *  - an address where a contract will be created
234      *  - an address where a contract lived, but was destroyed
235      * ====
236      */
237     function isContract(address account) internal view returns (bool) {
238         // This method relies in extcodesize, which returns 0 for contracts in
239         // construction, since the code is only stored at the end of the
240         // constructor execution.
241 
242         uint256 size;
243         // solhint-disable-next-line no-inline-assembly
244         assembly { size := extcodesize(account) }
245         return size > 0;
246     }
247 
248     /**
249      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
250      * `recipient`, forwarding all available gas and reverting on errors.
251      *
252      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
253      * of certain opcodes, possibly making contracts go over the 2300 gas limit
254      * imposed by `transfer`, making them unable to receive funds via
255      * `transfer`. {sendValue} removes this limitation.
256      *
257      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
258      *
259      * IMPORTANT: because control is transferred to `recipient`, care must be
260      * taken to not create reentrancy vulnerabilities. Consider using
261      * {ReentrancyGuard} or the
262      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
263      */
264     function sendValue(address payable recipient, uint256 amount) internal {
265         require(address(this).balance >= amount, "Address: insufficient balance");
266 
267         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
268         (bool success, ) = recipient.call{ value: amount }("");
269         require(success, "Address: unable to send value, recipient may have reverted");
270     }
271 
272     /**
273      * @dev Performs a Solidity function call using a low level `call`. A
274      * plain`call` is an unsafe replacement for a function call: use this
275      * function instead.
276      *
277      * If `target` reverts with a revert reason, it is bubbled up by this
278      * function (like regular Solidity function calls).
279      *
280      * Returns the raw returned data. To convert to the expected return value,
281      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
282      *
283      * Requirements:
284      *
285      * - `target` must be a contract.
286      * - calling `target` with `data` must not revert.
287      *
288      * _Available since v3.1._
289      */
290     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
291       return functionCall(target, data, "Address: low-level call failed");
292     }
293 
294     /**
295      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
296      * `errorMessage` as a fallback revert reason when `target` reverts.
297      *
298      * _Available since v3.1._
299      */
300     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
301         return _functionCallWithValue(target, data, 0, errorMessage);
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
306      * but also transferring `value` wei to `target`.
307      *
308      * Requirements:
309      *
310      * - the calling contract must have an ETH balance of at least `value`.
311      * - the called Solidity function must be `payable`.
312      *
313      * _Available since v3.1._
314      */
315     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
316         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
317     }
318 
319     /**
320      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
321      * with `errorMessage` as a fallback revert reason when `target` reverts.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
326         require(address(this).balance >= value, "Address: insufficient balance for call");
327         return _functionCallWithValue(target, data, value, errorMessage);
328     }
329 
330     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
331         require(isContract(target), "Address: call to non-contract");
332 
333         // solhint-disable-next-line avoid-low-level-calls
334         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
335         if (success) {
336             return returndata;
337         } else {
338             // Look for revert reason and bubble it up if present
339             if (returndata.length > 0) {
340                 // The easiest way to bubble the revert reason is using memory via assembly
341 
342                 // solhint-disable-next-line no-inline-assembly
343                 assembly {
344                     let returndata_size := mload(returndata)
345                     revert(add(32, returndata), returndata_size)
346                 }
347             } else {
348                 revert(errorMessage);
349             }
350         }
351     }
352 }
353 
354 
355 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
356 
357 pragma solidity ^0.6.0;
358 
359 /**
360  * @dev Interface of the ERC20 standard as defined in the EIP.
361  */
362 interface IERC20 {
363     /**
364      * @dev Returns the amount of tokens in existence.
365      */
366     function totalSupply() external view returns (uint256);
367 
368     /**
369      * @dev Returns the amount of tokens owned by `account`.
370      */
371     function balanceOf(address account) external view returns (uint256);
372 
373     /**
374      * @dev Moves `amount` tokens from the caller's account to `recipient`.
375      *
376      * Returns a boolean value indicating whether the operation succeeded.
377      *
378      * Emits a {Transfer} event.
379      */
380     function transfer(address recipient, uint256 amount) external returns (bool);
381 
382     /**
383      * @dev Returns the remaining number of tokens that `spender` will be
384      * allowed to spend on behalf of `owner` through {transferFrom}. This is
385      * zero by default.
386      *
387      * This value changes when {approve} or {transferFrom} are called.
388      */
389     function allowance(address owner, address spender) external view returns (uint256);
390 
391     /**
392      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
393      *
394      * Returns a boolean value indicating whether the operation succeeded.
395      *
396      * IMPORTANT: Beware that changing an allowance with this method brings the risk
397      * that someone may use both the old and the new allowance by unfortunate
398      * transaction ordering. One possible solution to mitigate this race
399      * condition is to first reduce the spender's allowance to 0 and set the
400      * desired value afterwards:
401      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
402      *
403      * Emits an {Approval} event.
404      */
405     function approve(address spender, uint256 amount) external returns (bool);
406 
407     /**
408      * @dev Moves `amount` tokens from `sender` to `recipient` using the
409      * allowance mechanism. `amount` is then deducted from the caller's
410      * allowance.
411      *
412      * Returns a boolean value indicating whether the operation succeeded.
413      *
414      * Emits a {Transfer} event.
415      */
416     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
417 
418     /**
419      * @dev Emitted when `value` tokens are moved from one account (`from`) to
420      * another (`to`).
421      *
422      * Note that `value` may be zero.
423      */
424     event Transfer(address indexed from, address indexed to, uint256 value);
425 
426     /**
427      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
428      * a call to {approve}. `value` is the new allowance.
429      */
430     event Approval(address indexed owner, address indexed spender, uint256 value);
431 }
432 
433 
434 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
435 
436 pragma solidity ^0.6.0;
437 
438 /**
439  * @title SafeERC20
440  * @dev Wrappers around ERC20 operations that throw on failure (when the token
441  * contract returns false). Tokens that return no value (and instead revert or
442  * throw on failure) are also supported, non-reverting calls are assumed to be
443  * successful.
444  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
445  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
446  */
447 library SafeERC20 {
448     using SafeMath for uint256;
449     using Address for address;
450 
451     function safeTransfer(IERC20 token, address to, uint256 value) internal {
452         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
453     }
454 
455     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
456         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
457     }
458 
459     /**
460      * @dev Deprecated. This function has issues similar to the ones found in
461      * {IERC20-approve}, and its usage is discouraged.
462      *
463      * Whenever possible, use {safeIncreaseAllowance} and
464      * {safeDecreaseAllowance} instead.
465      */
466     function safeApprove(IERC20 token, address spender, uint256 value) internal {
467         // safeApprove should only be called when setting an initial allowance,
468         // or when resetting it to zero. To increase and decrease it, use
469         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
470         // solhint-disable-next-line max-line-length
471         require((value == 0) || (token.allowance(address(this), spender) == 0),
472             "SafeERC20: approve from non-zero to non-zero allowance"
473         );
474         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
475     }
476 
477     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
478         uint256 newAllowance = token.allowance(address(this), spender).add(value);
479         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
480     }
481 
482     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
483         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
484         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
485     }
486 
487     /**
488      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
489      * on the return value: the return value is optional (but if data is returned, it must not be false).
490      * @param token The token targeted by the call.
491      * @param data The call data (encoded using abi.encode or one of its variants).
492      */
493     function _callOptionalReturn(IERC20 token, bytes memory data) private {
494         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
495         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
496         // the target address contains contract code and also asserts for success in the low-level call.
497 
498         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
499         if (returndata.length > 0) { // Return data is optional
500             // solhint-disable-next-line max-line-length
501             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
502         }
503     }
504 }
505 
506 
507 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
508 
509 pragma solidity ^0.6.0;
510 
511 /**
512  * @dev Implementation of the {IERC20} interface.
513  *
514  * This implementation is agnostic to the way tokens are created. This means
515  * that a supply mechanism has to be added in a derived contract using {_mint}.
516  * For a generic mechanism see {ERC20PresetMinterPauser}.
517  *
518  * TIP: For a detailed writeup see our guide
519  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
520  * to implement supply mechanisms].
521  *
522  * We have followed general OpenZeppelin guidelines: functions revert instead
523  * of returning `false` on failure. This behavior is nonetheless conventional
524  * and does not conflict with the expectations of ERC20 applications.
525  *
526  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
527  * This allows applications to reconstruct the allowance for all accounts just
528  * by listening to said events. Other implementations of the EIP may not emit
529  * these events, as it isn't required by the specification.
530  *
531  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
532  * functions have been added to mitigate the well-known issues around setting
533  * allowances. See {IERC20-approve}.
534  */
535 contract ERC20 is Context, IERC20 {
536     using SafeMath for uint256;
537     using Address for address;
538 
539     mapping (address => uint256) private _balances;
540 
541     mapping (address => mapping (address => uint256)) private _allowances;
542 
543     uint256 private _totalSupply;
544 
545     string private _name;
546     string private _symbol;
547     uint8 private _decimals;
548 
549     /**
550      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
551      * a default value of 18.
552      *
553      * To select a different value for {decimals}, use {_setupDecimals}.
554      *
555      * All three of these values are immutable: they can only be set once during
556      * construction.
557      */
558     constructor (string memory name, string memory symbol) public {
559         _name = name;
560         _symbol = symbol;
561         _decimals = 18;
562     }
563 
564     /**
565      * @dev Returns the name of the token.
566      */
567     function name() public view returns (string memory) {
568         return _name;
569     }
570 
571     /**
572      * @dev Returns the symbol of the token, usually a shorter version of the
573      * name.
574      */
575     function symbol() public view returns (string memory) {
576         return _symbol;
577     }
578 
579     /**
580      * @dev Returns the number of decimals used to get its user representation.
581      * For example, if `decimals` equals `2`, a balance of `505` tokens should
582      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
583      *
584      * Tokens usually opt for a value of 18, imitating the relationship between
585      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
586      * called.
587      *
588      * NOTE: This information is only used for _display_ purposes: it in
589      * no way affects any of the arithmetic of the contract, including
590      * {IERC20-balanceOf} and {IERC20-transfer}.
591      */
592     function decimals() public view returns (uint8) {
593         return _decimals;
594     }
595 
596     /**
597      * @dev See {IERC20-totalSupply}.
598      */
599     function totalSupply() public view override returns (uint256) {
600         return _totalSupply;
601     }
602 
603     /**
604      * @dev See {IERC20-balanceOf}.
605      */
606     function balanceOf(address account) public view override returns (uint256) {
607         return _balances[account];
608     }
609 
610     /**
611      * @dev See {IERC20-transfer}.
612      *
613      * Requirements:
614      *
615      * - `recipient` cannot be the zero address.
616      * - the caller must have a balance of at least `amount`.
617      */
618     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
619         _transfer(_msgSender(), recipient, amount);
620         return true;
621     }
622 
623     /**
624      * @dev See {IERC20-allowance}.
625      */
626     function allowance(address owner, address spender) public view virtual override returns (uint256) {
627         return _allowances[owner][spender];
628     }
629 
630     /**
631      * @dev See {IERC20-approve}.
632      *
633      * Requirements:
634      *
635      * - `spender` cannot be the zero address.
636      */
637     function approve(address spender, uint256 amount) public virtual override returns (bool) {
638         _approve(_msgSender(), spender, amount);
639         return true;
640     }
641 
642     /**
643      * @dev See {IERC20-transferFrom}.
644      *
645      * Emits an {Approval} event indicating the updated allowance. This is not
646      * required by the EIP. See the note at the beginning of {ERC20};
647      *
648      * Requirements:
649      * - `sender` and `recipient` cannot be the zero address.
650      * - `sender` must have a balance of at least `amount`.
651      * - the caller must have allowance for ``sender``'s tokens of at least
652      * `amount`.
653      */
654     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
655         _transfer(sender, recipient, amount);
656         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
657         return true;
658     }
659 
660     /**
661      * @dev Atomically increases the allowance granted to `spender` by the caller.
662      *
663      * This is an alternative to {approve} that can be used as a mitigation for
664      * problems described in {IERC20-approve}.
665      *
666      * Emits an {Approval} event indicating the updated allowance.
667      *
668      * Requirements:
669      *
670      * - `spender` cannot be the zero address.
671      */
672     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
673         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
674         return true;
675     }
676 
677     /**
678      * @dev Atomically decreases the allowance granted to `spender` by the caller.
679      *
680      * This is an alternative to {approve} that can be used as a mitigation for
681      * problems described in {IERC20-approve}.
682      *
683      * Emits an {Approval} event indicating the updated allowance.
684      *
685      * Requirements:
686      *
687      * - `spender` cannot be the zero address.
688      * - `spender` must have allowance for the caller of at least
689      * `subtractedValue`.
690      */
691     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
692         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
693         return true;
694     }
695 
696     /**
697      * @dev Moves tokens `amount` from `sender` to `recipient`.
698      *
699      * This is internal function is equivalent to {transfer}, and can be used to
700      * e.g. implement automatic token fees, slashing mechanisms, etc.
701      *
702      * Emits a {Transfer} event.
703      *
704      * Requirements:
705      *
706      * - `sender` cannot be the zero address.
707      * - `recipient` cannot be the zero address.
708      * - `sender` must have a balance of at least `amount`.
709      */
710     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
711         require(sender != address(0), "ERC20: transfer from the zero address");
712         require(recipient != address(0), "ERC20: transfer to the zero address");
713 
714         _beforeTokenTransfer(sender, recipient, amount);
715 
716         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
717         _balances[recipient] = _balances[recipient].add(amount);
718         emit Transfer(sender, recipient, amount);
719     }
720 
721     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
722      * the total supply.
723      *
724      * Emits a {Transfer} event with `from` set to the zero address.
725      *
726      * Requirements
727      *
728      * - `to` cannot be the zero address.
729      */
730     function _mint(address account, uint256 amount) internal virtual {
731         require(account != address(0), "ERC20: mint to the zero address");
732 
733         _beforeTokenTransfer(address(0), account, amount);
734 
735         _totalSupply = _totalSupply.add(amount);
736         _balances[account] = _balances[account].add(amount);
737         emit Transfer(address(0), account, amount);
738     }
739 
740     /**
741      * @dev Destroys `amount` tokens from `account`, reducing the
742      * total supply.
743      *
744      * Emits a {Transfer} event with `to` set to the zero address.
745      *
746      * Requirements
747      *
748      * - `account` cannot be the zero address.
749      * - `account` must have at least `amount` tokens.
750      */
751     function _burn(address account, uint256 amount) internal virtual {
752         require(account != address(0), "ERC20: burn from the zero address");
753 
754         _beforeTokenTransfer(account, address(0), amount);
755 
756         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
757         _totalSupply = _totalSupply.sub(amount);
758         emit Transfer(account, address(0), amount);
759     }
760 
761     /**
762      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
763      *
764      * This internal function is equivalent to `approve`, and can be used to
765      * e.g. set automatic allowances for certain subsystems, etc.
766      *
767      * Emits an {Approval} event.
768      *
769      * Requirements:
770      *
771      * - `owner` cannot be the zero address.
772      * - `spender` cannot be the zero address.
773      */
774     function _approve(address owner, address spender, uint256 amount) internal virtual {
775         require(owner != address(0), "ERC20: approve from the zero address");
776         require(spender != address(0), "ERC20: approve to the zero address");
777 
778         _allowances[owner][spender] = amount;
779         emit Approval(owner, spender, amount);
780     }
781 
782     /**
783      * @dev Sets {decimals} to a value other than the default one of 18.
784      *
785      * WARNING: This function should only be called from the constructor. Most
786      * applications that interact with token contracts will not expect
787      * {decimals} to ever change, and may work incorrectly if it does.
788      */
789     function _setupDecimals(uint8 decimals_) internal {
790         _decimals = decimals_;
791     }
792 
793     /**
794      * @dev Hook that is called before any transfer of tokens. This includes
795      * minting and burning.
796      *
797      * Calling conditions:
798      *
799      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
800      * will be to transferred to `to`.
801      * - when `from` is zero, `amount` tokens will be minted for `to`.
802      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
803      * - `from` and `to` are never both zero.
804      *
805      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
806      */
807     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
808 }
809 
810 
811 
812 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
813 
814 pragma solidity ^0.6.0;
815 
816 /**
817  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
818  */
819 abstract contract ERC20Capped is ERC20 {
820     uint256 private _cap;
821 
822     /**
823      * @dev Sets the value of the `cap`. This value is immutable, it can only be
824      * set once during construction.
825      */
826     constructor (uint256 cap) public {
827         require(cap > 0, "ERC20Capped: cap is 0");
828         _cap = cap;
829     }
830 
831     /**
832      * @dev Returns the cap on the token's total supply.
833      */
834     function cap() public view returns (uint256) {
835         return _cap;
836     }
837 
838     /**
839      * @dev See {ERC20-_beforeTokenTransfer}.
840      *
841      * Requirements:
842      *
843      * - minted tokens must not cause the total supply to go over the cap.
844      */
845     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
846         super._beforeTokenTransfer(from, to, amount);
847 
848         if (from == address(0)) { // When minting tokens
849             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
850         }
851     }
852 }
853 
854 
855 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
856 
857 pragma solidity ^0.6.0;
858 
859 /**
860  * @dev Extension of {ERC20} that allows token holders to destroy both their own
861  * tokens and those that they have an allowance for, in a way that can be
862  * recognized off-chain (via event analysis).
863  */
864 abstract contract ERC20Burnable is Context, ERC20 {
865     /**
866      * @dev Destroys `amount` tokens from the caller.
867      *
868      * See {ERC20-_burn}.
869      */
870     function burn(uint256 amount) public virtual {
871         _burn(_msgSender(), amount);
872     }
873 
874     /**
875      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
876      * allowance.
877      *
878      * See {ERC20-_burn} and {ERC20-allowance}.
879      *
880      * Requirements:
881      *
882      * - the caller must have allowance for ``accounts``'s tokens of at least
883      * `amount`.
884      */
885     function burnFrom(address account, uint256 amount) public virtual {
886         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
887 
888         _approve(account, _msgSender(), decreasedAllowance);
889         _burn(account, amount);
890     }
891 }
892 
893 
894 
895 // File: FansToken.sol
896 
897 pragma solidity ^0.6.2;
898 
899 contract FansToken is ERC20Capped, ERC20Burnable {
900     using SafeERC20 for IERC20;
901     using Address for address;
902     using SafeMath for uint;
903 
904     address public governance;
905     mapping (address => bool) public minters;
906 
907     constructor()
908         public
909         ERC20('FANS.UNIQUE', 'FANS')
910         ERC20Capped(1000000000000000000000000)   // Cap at 1 mil token
911         { 
912             governance = msg.sender;
913         }
914 
915     function mint(address account, uint256 amount) public {
916         require(minters[msg.sender], "!minter");
917         _mint(account, amount);
918     }
919 
920     function setGovernance(address _governance) public {
921         require(msg.sender == governance, "!governance");
922         governance = _governance;
923     }
924 
925     function addMinter(address _minter) public {
926         require(msg.sender == governance, "!governance");
927         minters[_minter] = true;
928     }
929 
930     function removeMinter(address _minter) public {
931         require(msg.sender == governance, "!governance");
932         minters[_minter] = false;
933     }
934     
935     function _beforeTokenTransfer(address from, address to, uint256 amount) internal override (ERC20, ERC20Capped) {
936         ERC20Capped._beforeTokenTransfer(from, to, amount);
937 
938     }    
939 
940 }