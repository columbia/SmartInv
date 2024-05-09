1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 pragma solidity ^0.6.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () internal {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(_owner == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 // File: contracts/owner/Operator.sol
98 
99 pragma solidity ^0.6.0;
100 
101 
102 
103 contract Operator is Context, Ownable {
104     address private _operator;
105 
106     event OperatorTransferred(
107         address indexed previousOperator,
108         address indexed newOperator
109     );
110 
111     constructor() internal {
112         _operator = _msgSender();
113         emit OperatorTransferred(address(0), _operator);
114     }
115 
116     function operator() public view returns (address) {
117         return _operator;
118     }
119 
120     modifier onlyOperator() {
121         require(
122             _operator == msg.sender,
123             'operator: caller is not the operator'
124         );
125         _;
126     }
127 
128     function isOperator() public view returns (bool) {
129         return _msgSender() == _operator;
130     }
131 
132     function transferOperator(address newOperator_) public onlyOwner {
133         _transferOperator(newOperator_);
134     }
135 
136     function _transferOperator(address newOperator_) internal {
137         require(
138             newOperator_ != address(0),
139             'operator: zero address given for new operator'
140         );
141         emit OperatorTransferred(address(0), newOperator_);
142         _operator = newOperator_;
143     }
144 }
145 
146 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
147 
148 
149 pragma solidity ^0.6.0;
150 
151 /**
152  * @dev Interface of the ERC20 standard as defined in the EIP.
153  */
154 interface IERC20 {
155     /**
156      * @dev Returns the amount of tokens in existence.
157      */
158     function totalSupply() external view returns (uint256);
159 
160     /**
161      * @dev Returns the amount of tokens owned by `account`.
162      */
163     function balanceOf(address account) external view returns (uint256);
164 
165     /**
166      * @dev Moves `amount` tokens from the caller's account to `recipient`.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transfer(address recipient, uint256 amount) external returns (bool);
173 
174     /**
175      * @dev Returns the remaining number of tokens that `spender` will be
176      * allowed to spend on behalf of `owner` through {transferFrom}. This is
177      * zero by default.
178      *
179      * This value changes when {approve} or {transferFrom} are called.
180      */
181     function allowance(address owner, address spender) external view returns (uint256);
182 
183     /**
184      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * IMPORTANT: Beware that changing an allowance with this method brings the risk
189      * that someone may use both the old and the new allowance by unfortunate
190      * transaction ordering. One possible solution to mitigate this race
191      * condition is to first reduce the spender's allowance to 0 and set the
192      * desired value afterwards:
193      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
194      *
195      * Emits an {Approval} event.
196      */
197     function approve(address spender, uint256 amount) external returns (bool);
198 
199     /**
200      * @dev Moves `amount` tokens from `sender` to `recipient` using the
201      * allowance mechanism. `amount` is then deducted from the caller's
202      * allowance.
203      *
204      * Returns a boolean value indicating whether the operation succeeded.
205      *
206      * Emits a {Transfer} event.
207      */
208     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
209 
210     /**
211      * @dev Emitted when `value` tokens are moved from one account (`from`) to
212      * another (`to`).
213      *
214      * Note that `value` may be zero.
215      */
216     event Transfer(address indexed from, address indexed to, uint256 value);
217 
218     /**
219      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
220      * a call to {approve}. `value` is the new allowance.
221      */
222     event Approval(address indexed owner, address indexed spender, uint256 value);
223 }
224 
225 // File: @openzeppelin/contracts/math/SafeMath.sol
226 
227 
228 pragma solidity ^0.6.0;
229 
230 /**
231  * @dev Wrappers over Solidity's arithmetic operations with added overflow
232  * checks.
233  *
234  * Arithmetic operations in Solidity wrap on overflow. This can easily result
235  * in bugs, because programmers usually assume that an overflow raises an
236  * error, which is the standard behavior in high level programming languages.
237  * `SafeMath` restores this intuition by reverting the transaction when an
238  * operation overflows.
239  *
240  * Using this library instead of the unchecked operations eliminates an entire
241  * class of bugs, so it's recommended to use it always.
242  */
243 library SafeMath {
244     /**
245      * @dev Returns the addition of two unsigned integers, reverting on
246      * overflow.
247      *
248      * Counterpart to Solidity's `+` operator.
249      *
250      * Requirements:
251      *
252      * - Addition cannot overflow.
253      */
254     function add(uint256 a, uint256 b) internal pure returns (uint256) {
255         uint256 c = a + b;
256         require(c >= a, "SafeMath: addition overflow");
257 
258         return c;
259     }
260 
261     /**
262      * @dev Returns the subtraction of two unsigned integers, reverting on
263      * overflow (when the result is negative).
264      *
265      * Counterpart to Solidity's `-` operator.
266      *
267      * Requirements:
268      *
269      * - Subtraction cannot overflow.
270      */
271     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
272         return sub(a, b, "SafeMath: subtraction overflow");
273     }
274 
275     /**
276      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
277      * overflow (when the result is negative).
278      *
279      * Counterpart to Solidity's `-` operator.
280      *
281      * Requirements:
282      *
283      * - Subtraction cannot overflow.
284      */
285     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
286         require(b <= a, errorMessage);
287         uint256 c = a - b;
288 
289         return c;
290     }
291 
292     /**
293      * @dev Returns the multiplication of two unsigned integers, reverting on
294      * overflow.
295      *
296      * Counterpart to Solidity's `*` operator.
297      *
298      * Requirements:
299      *
300      * - Multiplication cannot overflow.
301      */
302     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
303         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
304         // benefit is lost if 'b' is also tested.
305         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
306         if (a == 0) {
307             return 0;
308         }
309 
310         uint256 c = a * b;
311         require(c / a == b, "SafeMath: multiplication overflow");
312 
313         return c;
314     }
315 
316     /**
317      * @dev Returns the integer division of two unsigned integers. Reverts on
318      * division by zero. The result is rounded towards zero.
319      *
320      * Counterpart to Solidity's `/` operator. Note: this function uses a
321      * `revert` opcode (which leaves remaining gas untouched) while Solidity
322      * uses an invalid opcode to revert (consuming all remaining gas).
323      *
324      * Requirements:
325      *
326      * - The divisor cannot be zero.
327      */
328     function div(uint256 a, uint256 b) internal pure returns (uint256) {
329         return div(a, b, "SafeMath: division by zero");
330     }
331 
332     /**
333      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
334      * division by zero. The result is rounded towards zero.
335      *
336      * Counterpart to Solidity's `/` operator. Note: this function uses a
337      * `revert` opcode (which leaves remaining gas untouched) while Solidity
338      * uses an invalid opcode to revert (consuming all remaining gas).
339      *
340      * Requirements:
341      *
342      * - The divisor cannot be zero.
343      */
344     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
345         require(b > 0, errorMessage);
346         uint256 c = a / b;
347         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
348 
349         return c;
350     }
351 
352     /**
353      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
354      * Reverts when dividing by zero.
355      *
356      * Counterpart to Solidity's `%` operator. This function uses a `revert`
357      * opcode (which leaves remaining gas untouched) while Solidity uses an
358      * invalid opcode to revert (consuming all remaining gas).
359      *
360      * Requirements:
361      *
362      * - The divisor cannot be zero.
363      */
364     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
365         return mod(a, b, "SafeMath: modulo by zero");
366     }
367 
368     /**
369      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
370      * Reverts with custom message when dividing by zero.
371      *
372      * Counterpart to Solidity's `%` operator. This function uses a `revert`
373      * opcode (which leaves remaining gas untouched) while Solidity uses an
374      * invalid opcode to revert (consuming all remaining gas).
375      *
376      * Requirements:
377      *
378      * - The divisor cannot be zero.
379      */
380     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
381         require(b != 0, errorMessage);
382         return a % b;
383     }
384 }
385 
386 // File: @openzeppelin/contracts/utils/Address.sol
387 
388 
389 pragma solidity ^0.6.2;
390 
391 /**
392  * @dev Collection of functions related to the address type
393  */
394 library Address {
395     /**
396      * @dev Returns true if `account` is a contract.
397      *
398      * [IMPORTANT]
399      * ====
400      * It is unsafe to assume that an address for which this function returns
401      * false is an externally-owned account (EOA) and not a contract.
402      *
403      * Among others, `isContract` will return false for the following
404      * types of addresses:
405      *
406      *  - an externally-owned account
407      *  - a contract in construction
408      *  - an address where a contract will be created
409      *  - an address where a contract lived, but was destroyed
410      * ====
411      */
412     function isContract(address account) internal view returns (bool) {
413         // This method relies in extcodesize, which returns 0 for contracts in
414         // construction, since the code is only stored at the end of the
415         // constructor execution.
416 
417         uint256 size;
418         // solhint-disable-next-line no-inline-assembly
419         assembly { size := extcodesize(account) }
420         return size > 0;
421     }
422 
423     /**
424      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
425      * `recipient`, forwarding all available gas and reverting on errors.
426      *
427      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
428      * of certain opcodes, possibly making contracts go over the 2300 gas limit
429      * imposed by `transfer`, making them unable to receive funds via
430      * `transfer`. {sendValue} removes this limitation.
431      *
432      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
433      *
434      * IMPORTANT: because control is transferred to `recipient`, care must be
435      * taken to not create reentrancy vulnerabilities. Consider using
436      * {ReentrancyGuard} or the
437      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
438      */
439     function sendValue(address payable recipient, uint256 amount) internal {
440         require(address(this).balance >= amount, "Address: insufficient balance");
441 
442         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
443         (bool success, ) = recipient.call{ value: amount }("");
444         require(success, "Address: unable to send value, recipient may have reverted");
445     }
446 
447     /**
448      * @dev Performs a Solidity function call using a low level `call`. A
449      * plain`call` is an unsafe replacement for a function call: use this
450      * function instead.
451      *
452      * If `target` reverts with a revert reason, it is bubbled up by this
453      * function (like regular Solidity function calls).
454      *
455      * Returns the raw returned data. To convert to the expected return value,
456      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
457      *
458      * Requirements:
459      *
460      * - `target` must be a contract.
461      * - calling `target` with `data` must not revert.
462      *
463      * _Available since v3.1._
464      */
465     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
466       return functionCall(target, data, "Address: low-level call failed");
467     }
468 
469     /**
470      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
471      * `errorMessage` as a fallback revert reason when `target` reverts.
472      *
473      * _Available since v3.1._
474      */
475     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
476         return _functionCallWithValue(target, data, 0, errorMessage);
477     }
478 
479     /**
480      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
481      * but also transferring `value` wei to `target`.
482      *
483      * Requirements:
484      *
485      * - the calling contract must have an ETH balance of at least `value`.
486      * - the called Solidity function must be `payable`.
487      *
488      * _Available since v3.1._
489      */
490     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
491         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
496      * with `errorMessage` as a fallback revert reason when `target` reverts.
497      *
498      * _Available since v3.1._
499      */
500     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
501         require(address(this).balance >= value, "Address: insufficient balance for call");
502         return _functionCallWithValue(target, data, value, errorMessage);
503     }
504 
505     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
506         require(isContract(target), "Address: call to non-contract");
507 
508         // solhint-disable-next-line avoid-low-level-calls
509         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
510         if (success) {
511             return returndata;
512         } else {
513             // Look for revert reason and bubble it up if present
514             if (returndata.length > 0) {
515                 // The easiest way to bubble the revert reason is using memory via assembly
516 
517                 // solhint-disable-next-line no-inline-assembly
518                 assembly {
519                     let returndata_size := mload(returndata)
520                     revert(add(32, returndata), returndata_size)
521                 }
522             } else {
523                 revert(errorMessage);
524             }
525         }
526     }
527 }
528 
529 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
530 
531 
532 pragma solidity ^0.6.0;
533 
534 
535 
536 
537 
538 /**
539  * @dev Implementation of the {IERC20} interface.
540  *
541  * This implementation is agnostic to the way tokens are created. This means
542  * that a supply mechanism has to be added in a derived contract using {_mint}.
543  * For a generic mechanism see {ERC20PresetMinterPauser}.
544  *
545  * TIP: For a detailed writeup see our guide
546  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
547  * to implement supply mechanisms].
548  *
549  * We have followed general OpenZeppelin guidelines: functions revert instead
550  * of returning `false` on failure. This behavior is nonetheless conventional
551  * and does not conflict with the expectations of ERC20 applications.
552  *
553  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
554  * This allows applications to reconstruct the allowance for all accounts just
555  * by listening to said events. Other implementations of the EIP may not emit
556  * these events, as it isn't required by the specification.
557  *
558  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
559  * functions have been added to mitigate the well-known issues around setting
560  * allowances. See {IERC20-approve}.
561  */
562 contract ERC20 is Context, IERC20 {
563     using SafeMath for uint256;
564     using Address for address;
565 
566     mapping (address => uint256) private _balances;
567 
568     mapping (address => mapping (address => uint256)) private _allowances;
569 
570     uint256 private _totalSupply;
571 
572     string private _name;
573     string private _symbol;
574     uint8 private _decimals;
575 
576     /**
577      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
578      * a default value of 18.
579      *
580      * To select a different value for {decimals}, use {_setupDecimals}.
581      *
582      * All three of these values are immutable: they can only be set once during
583      * construction.
584      */
585     constructor (string memory name, string memory symbol) public {
586         _name = name;
587         _symbol = symbol;
588         _decimals = 18;
589     }
590 
591     /**
592      * @dev Returns the name of the token.
593      */
594     function name() public view returns (string memory) {
595         return _name;
596     }
597 
598     /**
599      * @dev Returns the symbol of the token, usually a shorter version of the
600      * name.
601      */
602     function symbol() public view returns (string memory) {
603         return _symbol;
604     }
605 
606     /**
607      * @dev Returns the number of decimals used to get its user representation.
608      * For example, if `decimals` equals `2`, a balance of `505` tokens should
609      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
610      *
611      * Tokens usually opt for a value of 18, imitating the relationship between
612      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
613      * called.
614      *
615      * NOTE: This information is only used for _display_ purposes: it in
616      * no way affects any of the arithmetic of the contract, including
617      * {IERC20-balanceOf} and {IERC20-transfer}.
618      */
619     function decimals() public view returns (uint8) {
620         return _decimals;
621     }
622 
623     /**
624      * @dev See {IERC20-totalSupply}.
625      */
626     function totalSupply() public view override returns (uint256) {
627         return _totalSupply;
628     }
629 
630     /**
631      * @dev See {IERC20-balanceOf}.
632      */
633     function balanceOf(address account) public view override returns (uint256) {
634         return _balances[account];
635     }
636 
637     /**
638      * @dev See {IERC20-transfer}.
639      *
640      * Requirements:
641      *
642      * - `recipient` cannot be the zero address.
643      * - the caller must have a balance of at least `amount`.
644      */
645     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
646         _transfer(_msgSender(), recipient, amount);
647         return true;
648     }
649 
650     /**
651      * @dev See {IERC20-allowance}.
652      */
653     function allowance(address owner, address spender) public view virtual override returns (uint256) {
654         return _allowances[owner][spender];
655     }
656 
657     /**
658      * @dev See {IERC20-approve}.
659      *
660      * Requirements:
661      *
662      * - `spender` cannot be the zero address.
663      */
664     function approve(address spender, uint256 amount) public virtual override returns (bool) {
665         _approve(_msgSender(), spender, amount);
666         return true;
667     }
668 
669     /**
670      * @dev See {IERC20-transferFrom}.
671      *
672      * Emits an {Approval} event indicating the updated allowance. This is not
673      * required by the EIP. See the note at the beginning of {ERC20};
674      *
675      * Requirements:
676      * - `sender` and `recipient` cannot be the zero address.
677      * - `sender` must have a balance of at least `amount`.
678      * - the caller must have allowance for ``sender``'s tokens of at least
679      * `amount`.
680      */
681     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
682         _transfer(sender, recipient, amount);
683         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
684         return true;
685     }
686 
687     /**
688      * @dev Atomically increases the allowance granted to `spender` by the caller.
689      *
690      * This is an alternative to {approve} that can be used as a mitigation for
691      * problems described in {IERC20-approve}.
692      *
693      * Emits an {Approval} event indicating the updated allowance.
694      *
695      * Requirements:
696      *
697      * - `spender` cannot be the zero address.
698      */
699     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
700         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
701         return true;
702     }
703 
704     /**
705      * @dev Atomically decreases the allowance granted to `spender` by the caller.
706      *
707      * This is an alternative to {approve} that can be used as a mitigation for
708      * problems described in {IERC20-approve}.
709      *
710      * Emits an {Approval} event indicating the updated allowance.
711      *
712      * Requirements:
713      *
714      * - `spender` cannot be the zero address.
715      * - `spender` must have allowance for the caller of at least
716      * `subtractedValue`.
717      */
718     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
719         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
720         return true;
721     }
722 
723     /**
724      * @dev Moves tokens `amount` from `sender` to `recipient`.
725      *
726      * This is internal function is equivalent to {transfer}, and can be used to
727      * e.g. implement automatic token fees, slashing mechanisms, etc.
728      *
729      * Emits a {Transfer} event.
730      *
731      * Requirements:
732      *
733      * - `sender` cannot be the zero address.
734      * - `recipient` cannot be the zero address.
735      * - `sender` must have a balance of at least `amount`.
736      */
737     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
738         require(sender != address(0), "ERC20: transfer from the zero address");
739         require(recipient != address(0), "ERC20: transfer to the zero address");
740 
741         _beforeTokenTransfer(sender, recipient, amount);
742 
743         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
744         _balances[recipient] = _balances[recipient].add(amount);
745         emit Transfer(sender, recipient, amount);
746     }
747 
748     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
749      * the total supply.
750      *
751      * Emits a {Transfer} event with `from` set to the zero address.
752      *
753      * Requirements
754      *
755      * - `to` cannot be the zero address.
756      */
757     function _mint(address account, uint256 amount) internal virtual {
758         require(account != address(0), "ERC20: mint to the zero address");
759 
760         _beforeTokenTransfer(address(0), account, amount);
761 
762         _totalSupply = _totalSupply.add(amount);
763         _balances[account] = _balances[account].add(amount);
764         emit Transfer(address(0), account, amount);
765     }
766 
767     /**
768      * @dev Destroys `amount` tokens from `account`, reducing the
769      * total supply.
770      *
771      * Emits a {Transfer} event with `to` set to the zero address.
772      *
773      * Requirements
774      *
775      * - `account` cannot be the zero address.
776      * - `account` must have at least `amount` tokens.
777      */
778     function _burn(address account, uint256 amount) internal virtual {
779         require(account != address(0), "ERC20: burn from the zero address");
780 
781         _beforeTokenTransfer(account, address(0), amount);
782 
783         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
784         _totalSupply = _totalSupply.sub(amount);
785         emit Transfer(account, address(0), amount);
786     }
787 
788     /**
789      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
790      *
791      * This internal function is equivalent to `approve`, and can be used to
792      * e.g. set automatic allowances for certain subsystems, etc.
793      *
794      * Emits an {Approval} event.
795      *
796      * Requirements:
797      *
798      * - `owner` cannot be the zero address.
799      * - `spender` cannot be the zero address.
800      */
801     function _approve(address owner, address spender, uint256 amount) internal virtual {
802         require(owner != address(0), "ERC20: approve from the zero address");
803         require(spender != address(0), "ERC20: approve to the zero address");
804 
805         _allowances[owner][spender] = amount;
806         emit Approval(owner, spender, amount);
807     }
808 
809     /**
810      * @dev Sets {decimals} to a value other than the default one of 18.
811      *
812      * WARNING: This function should only be called from the constructor. Most
813      * applications that interact with token contracts will not expect
814      * {decimals} to ever change, and may work incorrectly if it does.
815      */
816     function _setupDecimals(uint8 decimals_) internal {
817         _decimals = decimals_;
818     }
819 
820     /**
821      * @dev Hook that is called before any transfer of tokens. This includes
822      * minting and burning.
823      *
824      * Calling conditions:
825      *
826      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
827      * will be to transferred to `to`.
828      * - when `from` is zero, `amount` tokens will be minted for `to`.
829      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
830      * - `from` and `to` are never both zero.
831      *
832      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
833      */
834     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
835 }
836 
837 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
838 
839 
840 pragma solidity ^0.6.0;
841 
842 
843 
844 /**
845  * @dev Extension of {ERC20} that allows token holders to destroy both their own
846  * tokens and those that they have an allowance for, in a way that can be
847  * recognized off-chain (via event analysis).
848  */
849 abstract contract ERC20Burnable is Context, ERC20 {
850     /**
851      * @dev Destroys `amount` tokens from the caller.
852      *
853      * See {ERC20-_burn}.
854      */
855     function burn(uint256 amount) public virtual {
856         _burn(_msgSender(), amount);
857     }
858 
859     /**
860      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
861      * allowance.
862      *
863      * See {ERC20-_burn} and {ERC20-allowance}.
864      *
865      * Requirements:
866      *
867      * - the caller must have allowance for ``accounts``'s tokens of at least
868      * `amount`.
869      */
870     function burnFrom(address account, uint256 amount) public virtual {
871         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
872 
873         _approve(account, _msgSender(), decreasedAllowance);
874         _burn(account, amount);
875     }
876 }
877 
878 // File: contracts/Sharev3.sol
879 
880 pragma solidity ^0.6.0;
881 
882 
883 
884 contract Sharev3 is ERC20Burnable, Operator {
885 
886     uint256 public constant MAX_SUPPLY = 500000 * 10**18;
887 
888     constructor() public ERC20('MIS3', 'MIS3') {
889         // Mints 1 Basis Share to contract creator for initial Uniswap oracle deployment.
890         // Will be burned after oracle deployment
891         _mint(msg.sender, 1 * 10**18);
892     }
893 
894     /**
895      * @notice Operator mints basis cash to a recipient
896      * @param recipient_ The address of recipient
897      * @param amount_ The amount of basis cash to mint to
898      */
899     function mint(address recipient_, uint256 amount_)
900         public
901         onlyOperator
902         returns (bool)
903     {
904         uint256 supply = totalSupply();
905         require(supply.add(amount_) <= MAX_SUPPLY, "Share: Minting over max supply");
906 
907         uint256 balanceBefore = balanceOf(recipient_);
908         _mint(recipient_, amount_);
909         uint256 balanceAfter = balanceOf(recipient_);
910         return balanceAfter >= balanceBefore;
911     }
912 
913     function burn(uint256 amount) public override onlyOperator {
914         super.burn(amount);
915     }
916 
917     function burnFrom(address account, uint256 amount)
918         public
919         override
920         onlyOperator
921     {
922         super.burnFrom(account, amount);
923     }
924 }