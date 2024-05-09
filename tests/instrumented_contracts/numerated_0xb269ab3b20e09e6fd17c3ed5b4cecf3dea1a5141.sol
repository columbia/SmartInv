1 /**
2  *  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity 0.8.7;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 
86 /**
87  * @dev Interface for the optional metadata functions from the ERC20 standard.
88  *
89  * _Available since v4.1._
90  */
91 interface IERC20Metadata is IERC20 {
92     /**
93      * @dev Returns the name of the token.
94      */
95     function name() external view returns (string memory);
96 
97     /**
98      * @dev Returns the symbol of the token.
99      */
100     function symbol() external view returns (string memory);
101 
102     /**
103      * @dev Returns the decimals places of the token.
104      */
105     function decimals() external view returns (uint8);
106 }
107 
108 
109 // CAUTION
110 // This version of SafeMath should only be used with Solidity 0.8 or later,
111 // because it relies on the compiler's built in overflow checks.
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations.
115  *
116  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
117  * now has built in overflow checking.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, with an overflow flag.
122      *
123      * _Available since v3.4._
124      */
125     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
126         unchecked {
127             uint256 c = a + b;
128             if (c < a) return (false, 0);
129             return (true, c);
130         }
131     }
132 
133     /**
134      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
135      *
136      * _Available since v3.4._
137      */
138     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         unchecked {
140             if (b > a) return (false, 0);
141             return (true, a - b);
142         }
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
147      *
148      * _Available since v3.4._
149      */
150     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         unchecked {
152             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
153             // benefit is lost if 'b' is also tested.
154             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
155             if (a == 0) return (true, 0);
156             uint256 c = a * b;
157             if (c / a != b) return (false, 0);
158             return (true, c);
159         }
160     }
161 
162     /**
163      * @dev Returns the division of two unsigned integers, with a division by zero flag.
164      *
165      * _Available since v3.4._
166      */
167     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
168         unchecked {
169             if (b == 0) return (false, 0);
170             return (true, a / b);
171         }
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
176      *
177      * _Available since v3.4._
178      */
179     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
180         unchecked {
181             if (b == 0) return (false, 0);
182             return (true, a % b);
183         }
184     }
185 
186     /**
187      * @dev Returns the addition of two unsigned integers, reverting on
188      * overflow.
189      *
190      * Counterpart to Solidity's `+` operator.
191      *
192      * Requirements:
193      *
194      * - Addition cannot overflow.
195      */
196     function add(uint256 a, uint256 b) internal pure returns (uint256) {
197         return a + b;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         return a - b;
212     }
213 
214     /**
215      * @dev Returns the multiplication of two unsigned integers, reverting on
216      * overflow.
217      *
218      * Counterpart to Solidity's `*` operator.
219      *
220      * Requirements:
221      *
222      * - Multiplication cannot overflow.
223      */
224     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
225         return a * b;
226     }
227 
228     /**
229      * @dev Returns the integer division of two unsigned integers, reverting on
230      * division by zero. The result is rounded towards zero.
231      *
232      * Counterpart to Solidity's `/` operator.
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function div(uint256 a, uint256 b) internal pure returns (uint256) {
239         return a / b;
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * reverting when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
255         return a % b;
256     }
257 
258     /**
259      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
260      * overflow (when the result is negative).
261      *
262      * CAUTION: This function is deprecated because it requires allocating memory for the error
263      * message unnecessarily. For custom revert reasons use {trySub}.
264      *
265      * Counterpart to Solidity's `-` operator.
266      *
267      * Requirements:
268      *
269      * - Subtraction cannot overflow.
270      */
271     function sub(
272         uint256 a,
273         uint256 b,
274         string memory errorMessage
275     ) internal pure returns (uint256) {
276         unchecked {
277             require(b <= a, errorMessage);
278             return a - b;
279         }
280     }
281 
282     /**
283      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
284      * division by zero. The result is rounded towards zero.
285      *
286      * Counterpart to Solidity's `/` operator. Note: this function uses a
287      * `revert` opcode (which leaves remaining gas untouched) while Solidity
288      * uses an invalid opcode to revert (consuming all remaining gas).
289      *
290      * Requirements:
291      *
292      * - The divisor cannot be zero.
293      */
294     function div(
295         uint256 a,
296         uint256 b,
297         string memory errorMessage
298     ) internal pure returns (uint256) {
299         unchecked {
300             require(b > 0, errorMessage);
301             return a / b;
302         }
303     }
304 
305     /**
306      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
307      * reverting with custom message when dividing by zero.
308      *
309      * CAUTION: This function is deprecated because it requires allocating memory for the error
310      * message unnecessarily. For custom revert reasons use {tryMod}.
311      *
312      * Counterpart to Solidity's `%` operator. This function uses a `revert`
313      * opcode (which leaves remaining gas untouched) while Solidity uses an
314      * invalid opcode to revert (consuming all remaining gas).
315      *
316      * Requirements:
317      *
318      * - The divisor cannot be zero.
319      */
320     function mod(
321         uint256 a,
322         uint256 b,
323         string memory errorMessage
324     ) internal pure returns (uint256) {
325         unchecked {
326             require(b > 0, errorMessage);
327             return a % b;
328         }
329     }
330 }
331 
332 /*
333  * @dev Provides information about the current execution context, including the
334  * sender of the transaction and its data. While these are generally available
335  * via msg.sender and msg.data, they should not be accessed in such a direct
336  * manner, since when dealing with meta-transactions the account sending and
337  * paying for execution may not be the actual sender (as far as an application
338  * is concerned).
339  *
340  * This contract is only required for intermediate, library-like contracts.
341  */
342 abstract contract Context {
343     function _msgSender() internal view virtual returns (address) {
344         return msg.sender;
345     }
346 
347     function _msgData() internal view virtual returns (bytes calldata) {
348         return msg.data;
349     }
350 }
351 
352 /**
353  * @dev Contract module which provides a basic access control mechanism, where
354  * there is an account (an owner) that can be granted exclusive access to
355  * specific functions.
356  *
357  * By default, the owner account will be the one that deploys the contract. This
358  * can later be changed with {transferOwnership}.
359  *
360  * This module is used through inheritance. It will make available the modifier
361  * `onlyOwner`, which can be applied to your functions to restrict their use to
362  * the owner.
363  */
364 abstract contract Ownable is Context {
365     address private _owner;
366 
367     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
368 
369     /**
370      * @dev Initializes the contract setting the deployer as the initial owner.
371      */
372     constructor() {
373         _setOwner(_msgSender());
374     }
375 
376     /**
377      * @dev Returns the address of the current owner.
378      */
379     function owner() public view virtual returns (address) {
380         return _owner;
381     }
382 
383     /**
384      * @dev Throws if called by any account other than the owner.
385      */
386     modifier onlyOwner() {
387         require(owner() == _msgSender(), "Ownable: caller is not the owner");
388         _;
389     }
390 
391     /**
392      * @dev Leaves the contract without owner. It will not be possible to call
393      * `onlyOwner` functions anymore. Can only be called by the current owner.
394      *
395      * NOTE: Renouncing ownership will leave the contract without an owner,
396      * thereby removing any functionality that is only available to the owner.
397      */
398     function renounceOwnership() public virtual onlyOwner {
399         _setOwner(address(0));
400     }
401 
402     /**
403      * @dev Transfers ownership of the contract to a new account (`newOwner`).
404      * Can only be called by the current owner.
405      */
406     function transferOwnership(address newOwner) public virtual onlyOwner {
407         require(newOwner != address(0), "Ownable: new owner is the zero address");
408         _setOwner(newOwner);
409     }
410 
411     function _setOwner(address newOwner) internal {
412         address oldOwner = _owner;
413         _owner = newOwner;
414         emit OwnershipTransferred(oldOwner, newOwner);
415     }
416 }
417 
418 library Address {
419     /**
420      * @dev Returns true if `account` is a contract.
421      *
422      * [IMPORTANT]
423      * ====
424      * It is unsafe to assume that an address for which this function returns
425      * false is an externally-owned account (EOA) and not a contract.
426      *
427      * Among others, `isContract` will return false for the following
428      * types of addresses:
429      *
430      *  - an externally-owned account
431      *  - a contract in construction
432      *  - an address where a contract will be created
433      *  - an address where a contract lived, but was destroyed
434      * ====
435      */
436     function isContract(address account) internal view returns (bool) {
437         // This method relies in extcodesize, which returns 0 for contracts in
438         // construction, since the code is only stored at the end of the
439         // constructor execution.
440 
441         uint256 size;
442         // solhint-disable-next-line no-inline-assembly
443         assembly { size := extcodesize(account) }
444         return size > 0;
445     }
446 
447     /**
448      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
449      * `recipient`, forwarding all available gas and reverting on errors.
450      *
451      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
452      * of certain opcodes, possibly making contracts go over the 2300 gas limit
453      * imposed by `transfer`, making them unable to receive funds via
454      * `transfer`. {sendValue} removes this limitation.
455      *
456      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
457      *
458      * IMPORTANT: because control is transferred to `recipient`, care must be
459      * taken to not create reentrancy vulnerabilities. Consider using
460      * {ReentrancyGuard} or the
461      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
462      */
463     function sendValue(address payable recipient, uint256 amount) internal {
464         require(address(this).balance >= amount, "Address: insufficient balance");
465 
466         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
467         (bool success, ) = recipient.call{ value: amount }("");
468         require(success, "Address: unable to send value, recipient may have reverted");
469     }
470 
471     /**
472      * @dev Performs a Solidity function call using a low level `call`. A
473      * plain`call` is an unsafe replacement for a function call: use this
474      * function instead.
475      *
476      * If `target` reverts with a revert reason, it is bubbled up by this
477      * function (like regular Solidity function calls).
478      *
479      * Returns the raw returned data. To convert to the expected return value,
480      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
481      *
482      * Requirements:
483      *
484      * - `target` must be a contract.
485      * - calling `target` with `data` must not revert.
486      *
487      * _Available since v3.1._
488      */
489     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
490       return functionCall(target, data, "Address: low-level call failed");
491     }
492 
493     /**
494      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
495      * `errorMessage` as a fallback revert reason when `target` reverts.
496      *
497      * _Available since v3.1._
498      */
499     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
500         return _functionCallWithValue(target, data, 0, errorMessage);
501     }
502 
503     /**
504      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
505      * but also transferring `value` wei to `target`.
506      *
507      * Requirements:
508      *
509      * - the calling contract must have an ETH balance of at least `value`.
510      * - the called Solidity function must be `payable`.
511      *
512      * _Available since v3.1._
513      */
514     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
515         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
520      * with `errorMessage` as a fallback revert reason when `target` reverts.
521      *
522      * _Available since v3.1._
523      */
524     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
525         require(address(this).balance >= value, "Address: insufficient balance for call");
526         return _functionCallWithValue(target, data, value, errorMessage);
527     }
528 
529     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
530         require(isContract(target), "Address: call to non-contract");
531 
532         // solhint-disable-next-line avoid-low-level-calls
533         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
534         if (success) {
535             return returndata;
536         } else {
537             // Look for revert reason and bubble it up if present
538             if (returndata.length > 0) {
539                 // The easiest way to bubble the revert reason is using memory via assembly
540 
541                 // solhint-disable-next-line no-inline-assembly
542                 assembly {
543                     let returndata_size := mload(returndata)
544                     revert(add(32, returndata), returndata_size)
545                 }
546             } else {
547                 revert(errorMessage);
548             }
549         }
550     }
551 }
552 
553 library SafeERC20 {
554     using SafeMath for uint256;
555     using Address for address;
556 
557     function safeTransfer(IERC20 token, address to, uint256 value) internal {
558         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
559     }
560 
561     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
562         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
563     }
564 
565     /**
566      * @dev Deprecated. This function has issues similar to the ones found in
567      * {IERC20-approve}, and its usage is discouraged.
568      *
569      * Whenever possible, use {safeIncreaseAllowance} and
570      * {safeDecreaseAllowance} instead.
571      */
572     function safeApprove(IERC20 token, address spender, uint256 value) internal {
573         // safeApprove should only be called when setting an initial allowance,
574         // or when resetting it to zero. To increase and decrease it, use
575         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
576         // solhint-disable-next-line max-line-length
577         require((value == 0) || (token.allowance(address(this), spender) == 0),
578             "SafeERC20: approve from non-zero to non-zero allowance"
579         );
580         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
581     }
582 
583     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
584         uint256 newAllowance = token.allowance(address(this), spender).add(value);
585         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
586     }
587 
588     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
589         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
590         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
591     }
592 
593     /**
594      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
595      * on the return value: the return value is optional (but if data is returned, it must not be false).
596      * @param token The token targeted by the call.
597      * @param data The call data (encoded using abi.encode or one of its variants).
598      */
599     function _callOptionalReturn(IERC20 token, bytes memory data) private {
600         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
601         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
602         // the target address contains contract code and also asserts for success in the low-level call.
603 
604         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
605         if (returndata.length > 0) { // Return data is optional
606             // solhint-disable-next-line max-line-length
607             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
608         }
609     }
610 }
611 
612 contract Sakura is IERC20,IERC20Metadata,Ownable {
613     
614     using SafeMath for uint256;
615     using SafeERC20 for IERC20;
616     
617     mapping(address => uint256) private _balances;
618 
619     mapping(address => mapping(address => uint256)) private _allowances;
620 
621     uint256 private _totalSupply;
622     string private _name;
623     string private _symbol;  
624 
625 
626 
627     /**
628      * @dev Sets the values for {name} and {symbol}.
629      *
630      * The default value of {decimals} is 18. To select a different value for
631      * {decimals} you should overload it.
632      *
633      * All two of these values are immutable: they can only be set once during
634      * construction.
635      */
636     constructor() {
637         _setOwner(_msgSender());            
638         _totalSupply = 1000000000*10**18;
639         _balances[_msgSender()] = _totalSupply;
640         _name = "Sakura";
641         _symbol = "SAK";
642         emit Transfer(address(0), _msgSender(), _totalSupply);
643     }  
644     
645     function withdrawExternalToken(address _tokenAddress,address _recieptAddress) external onlyOwner{
646         uint256 amount = IERC20(_tokenAddress).balanceOf(address(this));
647         if(amount > 0){
648             IERC20(_tokenAddress).safeTransfer(_recieptAddress,amount);
649         }
650     }
651 
652     /**
653      * @dev Returns the name of the token.
654      */
655     function name() external view virtual override returns (string memory) {
656         return _name;
657     }
658 
659     /**
660      * @dev Returns the symbol of the token, usually a shorter version of the
661      * name.
662      */
663     function symbol() external view virtual override returns (string memory) {
664         return _symbol;
665     }
666 
667     /**
668      * @dev Returns the number of decimals used to get its user representation.
669      * For example, if `decimals` equals `2`, a balance of `505` tokens should
670      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
671      *
672      * Tokens usually opt for a value of 18, imitating the relationship between
673      * Ether and Wei. This is the value {ERC20} uses, unless this function is
674      * overridden;
675      *
676      * NOTE: This information is only used for _display_ purposes: it in
677      * no way affects any of the arithmetic of the contract, including
678      * {IERC20-balanceOf} and {IERC20-transfer}.
679      */
680     function decimals() external view virtual override returns (uint8) {
681         return 18;
682     }
683 
684     /**
685      * @dev See {IERC20-totalSupply}.
686      */
687     function totalSupply() external view virtual override returns (uint256) {
688         return _totalSupply;
689     }
690 
691     /**
692      * @dev See {IERC20-balanceOf}.
693      */
694     function balanceOf(address account) external view virtual override returns (uint256) {
695         return _balances[account];
696     }
697 
698     /**
699      * @dev See {IERC20-transfer}.
700      *
701      * Requirements:
702      *
703      * - `recipient` cannot be the zero address.
704      * - the caller must have a balance of at least `amount`.
705      */
706     function transfer(address recipient, uint256 amount) external virtual override returns (bool) {
707         _transfer(_msgSender(), recipient, amount);
708         return true;
709     }
710 
711     /**
712      * @dev See {IERC20-allowance}.
713      */
714     function allowance(address owner, address spender) external view virtual override returns (uint256) {
715         return _allowances[owner][spender];
716     }
717 
718     /**
719      * @dev See {IERC20-approve}.
720      *
721      * Requirements:
722      *
723      * - `spender` cannot be the zero address.
724      */
725     function approve(address spender, uint256 amount) external virtual override returns (bool) {
726         _approve(_msgSender(), spender, amount);
727         return true;
728     }
729 
730     /**
731      * @dev See {IERC20-transferFrom}.
732      *
733      * Emits an {Approval} event indicating the updated allowance. This is not
734      * required by the EIP. See the note at the beginning of {ERC20}.
735      *
736      * Requirements:
737      *
738      * - `sender` and `recipient` cannot be the zero address.
739      * - `sender` must have a balance of at least `amount`.
740      * - the caller must have allowance for ``sender``'s tokens of at least
741      * `amount`.
742      */
743     function transferFrom(
744         address sender,
745         address recipient,
746         uint256 amount
747     ) external virtual override returns (bool) {
748         _transfer(sender, recipient, amount);
749 
750         uint256 currentAllowance = _allowances[sender][_msgSender()];
751         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
752         unchecked {
753             _approve(sender, _msgSender(), currentAllowance - amount);
754         }
755 
756         return true;
757     }
758 
759     /**
760      * @dev Atomically increases the allowance granted to `spender` by the caller.
761      *
762      * This is an alternative to {approve} that can be used as a mitigation for
763      * problems described in {IERC20-approve}.
764      *
765      * Emits an {Approval} event indicating the updated allowance.
766      *
767      * Requirements:
768      *
769      * - `spender` cannot be the zero address.
770      */
771     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool) {
772         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
773         return true;
774     }
775 
776     /**
777      * @dev Atomically decreases the allowance granted to `spender` by the caller.
778      *
779      * This is an alternative to {approve} that can be used as a mitigation for
780      * problems described in {IERC20-approve}.
781      *
782      * Emits an {Approval} event indicating the updated allowance.
783      *
784      * Requirements:
785      *
786      * - `spender` cannot be the zero address.
787      * - `spender` must have allowance for the caller of at least
788      * `subtractedValue`.
789      */
790     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
791         uint256 currentAllowance = _allowances[_msgSender()][spender];
792         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
793         unchecked {
794             _approve(_msgSender(), spender, currentAllowance.sub(subtractedValue));
795         }
796 
797         return true;
798     }
799     
800     
801     /**
802      * @dev Moves `amount` of tokens from `sender` to `recipient`.
803      *
804      * This internal function is equivalent to {transfer}, and can be used to
805      * e.g. implement automatic token fees, slashing mechanisms, etc.
806      *
807      * Emits a {Transfer} event.
808      *
809      * Requirements:
810      *
811      * - `sender` cannot be the zero address.
812      * - `recipient` cannot be the zero address.
813      * - `sender` must have a balance of at least `amount`.
814      */
815     function _transfer(
816         address sender,
817         address recipient,
818         uint256 amount
819     ) internal {
820         require(sender != address(0), "ERC20: transfer from the zero address");
821         require(recipient != address(0), "ERC20: transfer to the zero address");    
822                         
823         uint256 senderBalance = _balances[sender];
824         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
825         unchecked {
826             _balances[sender] = senderBalance.sub(amount);
827         }   
828 
829         _balances[recipient] = _balances[recipient].add(amount);        
830         emit Transfer(sender, recipient, amount);
831     }
832 
833 
834 
835     /**
836      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
837      *
838      * This internal function is equivalent to `approve`, and can be used to
839      * e.g. set automatic allowances for certain subsystems, etc.
840      *
841      * Emits an {Approval} event.
842      *
843      * Requirements:
844      *
845      * - `owner` cannot be the zero address.
846      * - `spender` cannot be the zero address.
847      */
848     function _approve(
849         address owner,
850         address spender,
851         uint256 amount
852     ) internal virtual {
853         require(owner != address(0), "ERC20: approve from the zero address");
854         require(spender != address(0), "ERC20: approve to the zero address");
855 
856         _allowances[owner][spender] = amount;
857         emit Approval(owner, spender, amount);
858     }
859 }