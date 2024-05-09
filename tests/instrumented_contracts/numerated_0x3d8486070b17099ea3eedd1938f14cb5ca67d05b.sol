1 pragma solidity ^0.6.7;
2 
3 // SPDX-License-Identifier: MIT
4 /**
5  * @dev Contract module that helps prevent reentrant calls to a function.
6  *
7  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
8  * available, which can be applied to functions to make sure there are no nested
9  * (reentrant) calls to them.
10  *
11  * Note that because there is a single `nonReentrant` guard, functions marked as
12  * `nonReentrant` may not call one another. This can be worked around by making
13  * those functions `private`, and then adding `external` `nonReentrant` entry
14  * points to them.
15  *
16  * TIP: If you would like to learn more about reentrancy and alternative ways
17  * to protect against it, check out our blog post
18  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
19  */
20 contract ReentrancyGuard {
21     // Booleans are more expensive than uint256 or any type that takes up a full
22     // word because each write operation emits an extra SLOAD to first read the
23     // slot's contents, replace the bits taken up by the boolean, and then write
24     // back. This is the compiler's defense against contract upgrades and
25     // pointer aliasing, and it cannot be disabled.
26 
27     // The values being non-zero value makes deployment a bit more expensive,
28     // but in exchange the refund on every call to nonReentrant will be lower in
29     // amount. Since refunds are capped to a percentage of the total
30     // transaction's gas, it is best to keep them low in cases like this one, to
31     // increase the likelihood of the full refund coming into effect.
32     uint256 private constant _NOT_ENTERED = 1;
33     uint256 private constant _ENTERED = 2;
34 
35     uint256 private _status;
36 
37     constructor () internal {
38         _status = _NOT_ENTERED;
39     }
40 
41     /**
42      * @dev Prevents a contract from calling itself, directly or indirectly.
43      * Calling a `nonReentrant` function from another `nonReentrant`
44      * function is not supported. It is possible to prevent this from happening
45      * by making the `nonReentrant` function external, and make it call a
46      * `private` function that does the actual work.
47      */
48     modifier nonReentrant() {
49         // On the first call to nonReentrant, _notEntered will be true
50         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
51 
52         // Any calls to nonReentrant after this point will fail
53         _status = _ENTERED;
54 
55         _;
56 
57         // By storing the original value once again, a refund is triggered (see
58         // https://eips.ethereum.org/EIPS/eip-2200)
59         _status = _NOT_ENTERED;
60     }
61 }
62 
63 // https://docs.synthetix.io/contracts/Owned
64 contract Owned {
65     address public owner;
66     address public nominatedOwner;
67 
68     constructor(address _owner) public {
69         require(_owner != address(0), "Owner address cannot be 0");
70         owner = _owner;
71         emit OwnerChanged(address(0), _owner);
72     }
73 
74     function nominateNewOwner(address _owner) external onlyOwner {
75         nominatedOwner = _owner;
76         emit OwnerNominated(_owner);
77     }
78 
79     function acceptOwnership() external {
80         require(
81             msg.sender == nominatedOwner,
82             "You must be nominated before you can accept ownership"
83         );
84         emit OwnerChanged(owner, nominatedOwner);
85         owner = nominatedOwner;
86         nominatedOwner = address(0);
87     }
88 
89     modifier onlyOwner {
90         _onlyOwner();
91         _;
92     }
93 
94     function _onlyOwner() private view {
95         require(
96             msg.sender == owner,
97             "Only the contract owner may perform this action"
98         );
99     }
100 
101     event OwnerNominated(address newOwner);
102     event OwnerChanged(address oldOwner, address newOwner);
103 }
104 
105 // Inheritance
106 // https://docs.synthetix.io/contracts/Pausable
107 abstract contract Pausable is Owned {
108     uint256 public lastPauseTime;
109     bool public paused;
110 
111     constructor() internal {
112         // This contract is abstract, and thus cannot be instantiated directly
113         require(owner != address(0), "Owner must be set");
114         // Paused will be false, and lastPauseTime will be 0 upon initialisation
115     }
116 
117     /**
118      * @notice Change the paused state of the contract
119      * @dev Only the contract owner may call this.
120      */
121     function setPaused(bool _paused) external onlyOwner {
122         // Ensure we're actually changing the state before we do anything
123         if (_paused == paused) {
124             return;
125         }
126 
127         // Set our paused state.
128         paused = _paused;
129 
130         // If applicable, set the last pause time.
131         if (paused) {
132             lastPauseTime = now;
133         }
134 
135         // Let everyone know that our pause state has changed.
136         emit PauseChanged(paused);
137     }
138 
139     event PauseChanged(bool isPaused);
140 
141     modifier notPaused {
142         require(
143             !paused,
144             "This action cannot be performed while the contract is paused"
145         );
146         _;
147     }
148 }
149 
150 /**
151  * @dev Wrappers over Solidity's arithmetic operations with added overflow
152  * checks.
153  *
154  * Arithmetic operations in Solidity wrap on overflow. This can easily result
155  * in bugs, because programmers usually assume that an overflow raises an
156  * error, which is the standard behavior in high level programming languages.
157  * `SafeMath` restores this intuition by reverting the transaction when an
158  * operation overflows.
159  *
160  * Using this library instead of the unchecked operations eliminates an entire
161  * class of bugs, so it's recommended to use it always.
162  */
163 library SafeMath {
164     /**
165      * @dev Returns the addition of two unsigned integers, reverting on
166      * overflow.
167      *
168      * Counterpart to Solidity's `+` operator.
169      *
170      * Requirements:
171      *
172      * - Addition cannot overflow.
173      */
174     function add(uint256 a, uint256 b) internal pure returns (uint256) {
175         uint256 c = a + b;
176         require(c >= a, "SafeMath: addition overflow");
177 
178         return c;
179     }
180 
181     /**
182      * @dev Returns the subtraction of two unsigned integers, reverting on
183      * overflow (when the result is negative).
184      *
185      * Counterpart to Solidity's `-` operator.
186      *
187      * Requirements:
188      *
189      * - Subtraction cannot overflow.
190      */
191     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
192         return sub(a, b, "SafeMath: subtraction overflow");
193     }
194 
195     /**
196      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
197      * overflow (when the result is negative).
198      *
199      * Counterpart to Solidity's `-` operator.
200      *
201      * Requirements:
202      *
203      * - Subtraction cannot overflow.
204      */
205     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b <= a, errorMessage);
207         uint256 c = a - b;
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the multiplication of two unsigned integers, reverting on
214      * overflow.
215      *
216      * Counterpart to Solidity's `*` operator.
217      *
218      * Requirements:
219      *
220      * - Multiplication cannot overflow.
221      */
222     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
223         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
224         // benefit is lost if 'b' is also tested.
225         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
226         if (a == 0) {
227             return 0;
228         }
229 
230         uint256 c = a * b;
231         require(c / a == b, "SafeMath: multiplication overflow");
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the integer division of two unsigned integers. Reverts on
238      * division by zero. The result is rounded towards zero.
239      *
240      * Counterpart to Solidity's `/` operator. Note: this function uses a
241      * `revert` opcode (which leaves remaining gas untouched) while Solidity
242      * uses an invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
249         return div(a, b, "SafeMath: division by zero");
250     }
251 
252     /**
253      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
254      * division by zero. The result is rounded towards zero.
255      *
256      * Counterpart to Solidity's `/` operator. Note: this function uses a
257      * `revert` opcode (which leaves remaining gas untouched) while Solidity
258      * uses an invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b > 0, errorMessage);
266         uint256 c = a / b;
267         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
268 
269         return c;
270     }
271 
272     /**
273      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
274      * Reverts when dividing by zero.
275      *
276      * Counterpart to Solidity's `%` operator. This function uses a `revert`
277      * opcode (which leaves remaining gas untouched) while Solidity uses an
278      * invalid opcode to revert (consuming all remaining gas).
279      *
280      * Requirements:
281      *
282      * - The divisor cannot be zero.
283      */
284     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
285         return mod(a, b, "SafeMath: modulo by zero");
286     }
287 
288     /**
289      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
290      * Reverts with custom message when dividing by zero.
291      *
292      * Counterpart to Solidity's `%` operator. This function uses a `revert`
293      * opcode (which leaves remaining gas untouched) while Solidity uses an
294      * invalid opcode to revert (consuming all remaining gas).
295      *
296      * Requirements:
297      *
298      * - The divisor cannot be zero.
299      */
300     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
301         require(b != 0, errorMessage);
302         return a % b;
303     }
304 }
305 
306 /*
307  * @dev Provides information about the current execution context, including the
308  * sender of the transaction and its data. While these are generally available
309  * via msg.sender and msg.data, they should not be accessed in such a direct
310  * manner, since when dealing with GSN meta-transactions the account sending and
311  * paying for execution may not be the actual sender (as far as an application
312  * is concerned).
313  *
314  * This contract is only required for intermediate, library-like contracts.
315  */
316 abstract contract Context {
317     function _msgSender() internal view virtual returns (address payable) {
318         return msg.sender;
319     }
320 
321     function _msgData() internal view virtual returns (bytes memory) {
322         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
323         return msg.data;
324     }
325 }
326 
327 /**
328  * @dev Interface of the ERC20 standard as defined in the EIP.
329  */
330 interface IERC20 {
331     /**
332      * @dev Returns the amount of tokens in existence.
333      */
334     function totalSupply() external view returns (uint256);
335 
336     /**
337      * @dev Returns the amount of tokens owned by `account`.
338      */
339     function balanceOf(address account) external view returns (uint256);
340 
341     /**
342      * @dev Moves `amount` tokens from the caller's account to `recipient`.
343      *
344      * Returns a boolean value indicating whether the operation succeeded.
345      *
346      * Emits a {Transfer} event.
347      */
348     function transfer(address recipient, uint256 amount) external returns (bool);
349 
350     /**
351      * @dev Returns the remaining number of tokens that `spender` will be
352      * allowed to spend on behalf of `owner` through {transferFrom}. This is
353      * zero by default.
354      *
355      * This value changes when {approve} or {transferFrom} are called.
356      */
357     function allowance(address owner, address spender) external view returns (uint256);
358 
359     /**
360      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
361      *
362      * Returns a boolean value indicating whether the operation succeeded.
363      *
364      * IMPORTANT: Beware that changing an allowance with this method brings the risk
365      * that someone may use both the old and the new allowance by unfortunate
366      * transaction ordering. One possible solution to mitigate this race
367      * condition is to first reduce the spender's allowance to 0 and set the
368      * desired value afterwards:
369      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
370      *
371      * Emits an {Approval} event.
372      */
373     function approve(address spender, uint256 amount) external returns (bool);
374 
375     /**
376      * @dev Moves `amount` tokens from `sender` to `recipient` using the
377      * allowance mechanism. `amount` is then deducted from the caller's
378      * allowance.
379      *
380      * Returns a boolean value indicating whether the operation succeeded.
381      *
382      * Emits a {Transfer} event.
383      */
384     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
385 
386     /**
387      * @dev Emitted when `value` tokens are moved from one account (`from`) to
388      * another (`to`).
389      *
390      * Note that `value` may be zero.
391      */
392     event Transfer(address indexed from, address indexed to, uint256 value);
393 
394     /**
395      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
396      * a call to {approve}. `value` is the new allowance.
397      */
398     event Approval(address indexed owner, address indexed spender, uint256 value);
399 }
400 
401 // File: contracts/utils/Address.sol
402 /**
403  * @dev Collection of functions related to the address type
404  */
405 library Address {
406     /**
407      * @dev Returns true if `account` is a contract.
408      *
409      * [IMPORTANT]
410      * ====
411      * It is unsafe to assume that an address for which this function returns
412      * false is an externally-owned account (EOA) and not a contract.
413      *
414      * Among others, `isContract` will return false for the following
415      * types of addresses:
416      *
417      *  - an externally-owned account
418      *  - a contract in construction
419      *  - an address where a contract will be created
420      *  - an address where a contract lived, but was destroyed
421      * ====
422      */
423     function isContract(address account) internal view returns (bool) {
424         // This method relies on extcodesize, which returns 0 for contracts in
425         // construction, since the code is only stored at the end of the
426         // constructor execution.
427 
428         uint256 size;
429         // solhint-disable-next-line no-inline-assembly
430         assembly { size := extcodesize(account) }
431         return size > 0;
432     }
433 
434     /**
435      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
436      * `recipient`, forwarding all available gas and reverting on errors.
437      *
438      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
439      * of certain opcodes, possibly making contracts go over the 2300 gas limit
440      * imposed by `transfer`, making them unable to receive funds via
441      * `transfer`. {sendValue} removes this limitation.
442      *
443      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
444      *
445      * IMPORTANT: because control is transferred to `recipient`, care must be
446      * taken to not create reentrancy vulnerabilities. Consider using
447      * {ReentrancyGuard} or the
448      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
449      */
450     function sendValue(address payable recipient, uint256 amount) internal {
451         require(address(this).balance >= amount, "Address: insufficient balance");
452 
453         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
454         (bool success, ) = recipient.call{ value: amount }("");
455         require(success, "Address: unable to send value, recipient may have reverted");
456     }
457 
458     /**
459      * @dev Performs a Solidity function call using a low level `call`. A
460      * plain`call` is an unsafe replacement for a function call: use this
461      * function instead.
462      *
463      * If `target` reverts with a revert reason, it is bubbled up by this
464      * function (like regular Solidity function calls).
465      *
466      * Returns the raw returned data. To convert to the expected return value,
467      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
468      *
469      * Requirements:
470      *
471      * - `target` must be a contract.
472      * - calling `target` with `data` must not revert.
473      *
474      * _Available since v3.1._
475      */
476     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
477       return functionCall(target, data, "Address: low-level call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
482      * `errorMessage` as a fallback revert reason when `target` reverts.
483      *
484      * _Available since v3.1._
485      */
486     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
487         return _functionCallWithValue(target, data, 0, errorMessage);
488     }
489 
490     /**
491      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
492      * but also transferring `value` wei to `target`.
493      *
494      * Requirements:
495      *
496      * - the calling contract must have an ETH balance of at least `value`.
497      * - the called Solidity function must be `payable`.
498      *
499      * _Available since v3.1._
500      */
501     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
502         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
503     }
504 
505     /**
506      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
507      * with `errorMessage` as a fallback revert reason when `target` reverts.
508      *
509      * _Available since v3.1._
510      */
511     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
512         require(address(this).balance >= value, "Address: insufficient balance for call");
513         return _functionCallWithValue(target, data, value, errorMessage);
514     }
515 
516     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
517         require(isContract(target), "Address: call to non-contract");
518 
519         // solhint-disable-next-line avoid-low-level-calls
520         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
521         if (success) {
522             return returndata;
523         } else {
524             // Look for revert reason and bubble it up if present
525             if (returndata.length > 0) {
526                 // The easiest way to bubble the revert reason is using memory via assembly
527 
528                 // solhint-disable-next-line no-inline-assembly
529                 assembly {
530                     let returndata_size := mload(returndata)
531                     revert(add(32, returndata), returndata_size)
532                 }
533             } else {
534                 revert(errorMessage);
535             }
536         }
537     }
538 }
539 
540 // File: contracts/token/ERC20/ERC20.sol
541 /**
542  * @dev Implementation of the {IERC20} interface.
543  *
544  * This implementation is agnostic to the way tokens are created. This means
545  * that a supply mechanism has to be added in a derived contract using {_mint}.
546  * For a generic mechanism see {ERC20PresetMinterPauser}.
547  *
548  * TIP: For a detailed writeup see our guide
549  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
550  * to implement supply mechanisms].
551  *
552  * We have followed general OpenZeppelin guidelines: functions revert instead
553  * of returning `false` on failure. This behavior is nonetheless conventional
554  * and does not conflict with the expectations of ERC20 applications.
555  *
556  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
557  * This allows applications to reconstruct the allowance for all accounts just
558  * by listening to said events. Other implementations of the EIP may not emit
559  * these events, as it isn't required by the specification.
560  *
561  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
562  * functions have been added to mitigate the well-known issues around setting
563  * allowances. See {IERC20-approve}.
564  */
565 contract ERC20 is Context, IERC20 {
566     using SafeMath for uint256;
567     using Address for address;
568 
569     mapping (address => uint256) private _balances;
570 
571     mapping (address => mapping (address => uint256)) private _allowances;
572 
573     uint256 private _totalSupply;
574 
575     string private _name;
576     string private _symbol;
577     uint8 private _decimals;
578 
579     /**
580      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
581      * a default value of 18.
582      *
583      * To select a different value for {decimals}, use {_setupDecimals}.
584      *
585      * All three of these values are immutable: they can only be set once during
586      * construction.
587      */
588     constructor (string memory name, string memory symbol) public {
589         _name = name;
590         _symbol = symbol;
591         _decimals = 18;
592     }
593 
594     /**
595      * @dev Returns the name of the token.
596      */
597     function name() public view returns (string memory) {
598         return _name;
599     }
600 
601     /**
602      * @dev Returns the symbol of the token, usually a shorter version of the
603      * name.
604      */
605     function symbol() public view returns (string memory) {
606         return _symbol;
607     }
608 
609     /**
610      * @dev Returns the number of decimals used to get its user representation.
611      * For example, if `decimals` equals `2`, a balance of `505` tokens should
612      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
613      *
614      * Tokens usually opt for a value of 18, imitating the relationship between
615      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
616      * called.
617      *
618      * NOTE: This information is only used for _display_ purposes: it in
619      * no way affects any of the arithmetic of the contract, including
620      * {IERC20-balanceOf} and {IERC20-transfer}.
621      */
622     function decimals() public view returns (uint8) {
623         return _decimals;
624     }
625 
626     /**
627      * @dev See {IERC20-totalSupply}.
628      */
629     function totalSupply() public view override returns (uint256) {
630         return _totalSupply;
631     }
632 
633     /**
634      * @dev See {IERC20-balanceOf}.
635      */
636     function balanceOf(address account) public view override returns (uint256) {
637         return _balances[account];
638     }
639 
640     /**
641      * @dev See {IERC20-transfer}.
642      *
643      * Requirements:
644      *
645      * - `recipient` cannot be the zero address.
646      * - the caller must have a balance of at least `amount`.
647      */
648     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
649         _transfer(_msgSender(), recipient, amount);
650         return true;
651     }
652 
653     /**
654      * @dev See {IERC20-allowance}.
655      */
656     function allowance(address owner, address spender) public view virtual override returns (uint256) {
657         return _allowances[owner][spender];
658     }
659 
660     /**
661      * @dev See {IERC20-approve}.
662      *
663      * Requirements:
664      *
665      * - `spender` cannot be the zero address.
666      */
667     function approve(address spender, uint256 amount) public virtual override returns (bool) {
668         _approve(_msgSender(), spender, amount);
669         return true;
670     }
671 
672     /**
673      * @dev See {IERC20-transferFrom}.
674      *
675      * Emits an {Approval} event indicating the updated allowance. This is not
676      * required by the EIP. See the note at the beginning of {ERC20};
677      *
678      * Requirements:
679      * - `sender` and `recipient` cannot be the zero address.
680      * - `sender` must have a balance of at least `amount`.
681      * - the caller must have allowance for ``sender``'s tokens of at least
682      * `amount`.
683      */
684     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
685         _transfer(sender, recipient, amount);
686         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
687         return true;
688     }
689 
690     /**
691      * @dev Atomically increases the allowance granted to `spender` by the caller.
692      *
693      * This is an alternative to {approve} that can be used as a mitigation for
694      * problems described in {IERC20-approve}.
695      *
696      * Emits an {Approval} event indicating the updated allowance.
697      *
698      * Requirements:
699      *
700      * - `spender` cannot be the zero address.
701      */
702     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
703         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
704         return true;
705     }
706 
707     /**
708      * @dev Atomically decreases the allowance granted to `spender` by the caller.
709      *
710      * This is an alternative to {approve} that can be used as a mitigation for
711      * problems described in {IERC20-approve}.
712      *
713      * Emits an {Approval} event indicating the updated allowance.
714      *
715      * Requirements:
716      *
717      * - `spender` cannot be the zero address.
718      * - `spender` must have allowance for the caller of at least
719      * `subtractedValue`.
720      */
721     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
722         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
723         return true;
724     }
725 
726     /**
727      * @dev Moves tokens `amount` from `sender` to `recipient`.
728      *
729      * This is internal function is equivalent to {transfer}, and can be used to
730      * e.g. implement automatic token fees, slashing mechanisms, etc.
731      *
732      * Emits a {Transfer} event.
733      *
734      * Requirements:
735      *
736      * - `sender` cannot be the zero address.
737      * - `recipient` cannot be the zero address.
738      * - `sender` must have a balance of at least `amount`.
739      */
740     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
741         require(sender != address(0), "ERC20: transfer from the zero address");
742         require(recipient != address(0), "ERC20: transfer to the zero address");
743 
744         _beforeTokenTransfer(sender, recipient, amount);
745 
746         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
747         _balances[recipient] = _balances[recipient].add(amount);
748         emit Transfer(sender, recipient, amount);
749     }
750 
751     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
752      * the total supply.
753      *
754      * Emits a {Transfer} event with `from` set to the zero address.
755      *
756      * Requirements
757      *
758      * - `to` cannot be the zero address.
759      */
760     function _mint(address account, uint256 amount) internal virtual {
761         require(account != address(0), "ERC20: mint to the zero address");
762 
763         _beforeTokenTransfer(address(0), account, amount);
764 
765         _totalSupply = _totalSupply.add(amount);
766         _balances[account] = _balances[account].add(amount);
767         emit Transfer(address(0), account, amount);
768     }
769 
770     /**
771      * @dev Destroys `amount` tokens from `account`, reducing the
772      * total supply.
773      *
774      * Emits a {Transfer} event with `to` set to the zero address.
775      *
776      * Requirements
777      *
778      * - `account` cannot be the zero address.
779      * - `account` must have at least `amount` tokens.
780      */
781     function _burn(address account, uint256 amount) internal virtual {
782         require(account != address(0), "ERC20: burn from the zero address");
783 
784         _beforeTokenTransfer(account, address(0), amount);
785 
786         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
787         _totalSupply = _totalSupply.sub(amount);
788         emit Transfer(account, address(0), amount);
789     }
790 
791     /**
792      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
793      *
794      * This internal function is equivalent to `approve`, and can be used to
795      * e.g. set automatic allowances for certain subsystems, etc.
796      *
797      * Emits an {Approval} event.
798      *
799      * Requirements:
800      *
801      * - `owner` cannot be the zero address.
802      * - `spender` cannot be the zero address.
803      */
804     function _approve(address owner, address spender, uint256 amount) internal virtual {
805         require(owner != address(0), "ERC20: approve from the zero address");
806         require(spender != address(0), "ERC20: approve to the zero address");
807 
808         _allowances[owner][spender] = amount;
809         emit Approval(owner, spender, amount);
810     }
811 
812     /**
813      * @dev Sets {decimals} to a value other than the default one of 18.
814      *
815      * WARNING: This function should only be called from the constructor. Most
816      * applications that interact with token contracts will not expect
817      * {decimals} to ever change, and may work incorrectly if it does.
818      */
819     function _setupDecimals(uint8 decimals_) internal {
820         _decimals = decimals_;
821     }
822 
823     /**
824      * @dev Hook that is called before any transfer of tokens. This includes
825      * minting and burning.
826      *
827      * Calling conditions:
828      *
829      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
830      * will be to transferred to `to`.
831      * - when `from` is zero, `amount` tokens will be minted for `to`.
832      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
833      * - `from` and `to` are never both zero.
834      *
835      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
836      */
837     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
838 }
839 
840 /**
841  * @title SafeERC20
842  * @dev Wrappers around ERC20 operations that throw on failure (when the token
843  * contract returns false). Tokens that return no value (and instead revert or
844  * throw on failure) are also supported, non-reverting calls are assumed to be
845  * successful.
846  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
847  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
848  */
849 library SafeERC20 {
850     using SafeMath for uint256;
851     using Address for address;
852 
853     function safeTransfer(IERC20 token, address to, uint256 value) internal {
854         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
855     }
856 
857     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
858         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
859     }
860 
861     /**
862      * @dev Deprecated. This function has issues similar to the ones found in
863      * {IERC20-approve}, and its usage is discouraged.
864      *
865      * Whenever possible, use {safeIncreaseAllowance} and
866      * {safeDecreaseAllowance} instead.
867      */
868     function safeApprove(IERC20 token, address spender, uint256 value) internal {
869         // safeApprove should only be called when setting an initial allowance,
870         // or when resetting it to zero. To increase and decrease it, use
871         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
872         // solhint-disable-next-line max-line-length
873         require((value == 0) || (token.allowance(address(this), spender) == 0),
874             "SafeERC20: approve from non-zero to non-zero allowance"
875         );
876         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
877     }
878 
879     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
880         uint256 newAllowance = token.allowance(address(this), spender).add(value);
881         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
882     }
883 
884     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
885         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
886         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
887     }
888 
889     /**
890      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
891      * on the return value: the return value is optional (but if data is returned, it must not be false).
892      * @param token The token targeted by the call.
893      * @param data The call data (encoded using abi.encode or one of its variants).
894      */
895     function _callOptionalReturn(IERC20 token, bytes memory data) private {
896         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
897         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
898         // the target address contains contract code and also asserts for success in the low-level call.
899 
900         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
901         if (returndata.length > 0) { // Return data is optional
902             // solhint-disable-next-line max-line-length
903             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
904         }
905     }
906 }
907 
908 contract VoxPrivateStakingPool is ReentrancyGuard, Pausable {
909     using SafeMath for uint256;
910     using SafeERC20 for IERC20;
911 
912     // STATE VARIABLES
913 
914     IERC20 public rewardsToken;
915     IERC20 public stakingToken;
916     uint256 public periodFinish = 0;
917     uint256 public rewardRate = 0;
918     uint256 public rewardsDuration = 14 days;
919     uint256 public lastUpdateTime;
920     uint256 public rewardPerTokenStored;
921 
922     mapping(address => uint256) public userRewardPerTokenPaid;
923     mapping(address => uint256) public rewards;
924 
925     uint256 private _totalSupply;
926     mapping(address => uint256) private _balances;
927 
928     // CONSTRUCTOR
929 
930     constructor(
931         address _owner,
932         address _rewardsToken,
933         address _stakingToken
934     ) public Owned(_owner) {
935         rewardsToken = IERC20(_rewardsToken);
936         stakingToken = IERC20(_stakingToken);
937     }
938 
939     // VIEWS
940 
941     function totalSupply() external view returns (uint256) {
942         return _totalSupply;
943     }
944 
945     function balanceOf(address account) external view returns (uint256) {
946         return _balances[account];
947     }
948 
949     function lastTimeRewardApplicable() public view returns (uint256) {
950         return min(block.timestamp, periodFinish);
951     }
952 
953     function rewardPerToken() public view returns (uint256) {
954         if (_totalSupply == 0) {
955             return rewardPerTokenStored;
956         }
957         return
958             rewardPerTokenStored.add(
959                 lastTimeRewardApplicable()
960                     .sub(lastUpdateTime)
961                     .mul(rewardRate)
962                     .mul(1e18)
963                     .div(_totalSupply)
964             );
965     }
966 
967     function earned(address account) public view returns (uint256) {
968         return
969             _balances[account]
970                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
971                 .div(1e18)
972                 .add(rewards[account]);
973     }
974 
975     function getRewardForDuration() external view returns (uint256) {
976         return rewardRate.mul(rewardsDuration);
977     }
978 
979     function min(uint256 a, uint256 b) public pure returns (uint256) {
980         return a < b ? a : b;
981     }
982 
983     // PUBLIC FUNCTIONS
984 
985     function stake(uint256 amount)
986         external
987         nonReentrant
988         notPaused
989         updateReward(msg.sender)
990     {
991         require(amount > 0, "Cannot stake 0");
992         _totalSupply = _totalSupply.add(amount);
993         _balances[msg.sender] = _balances[msg.sender].add(amount);
994         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
995         emit Staked(msg.sender, amount);
996     }
997 
998     function withdraw(uint256 amount)
999         public
1000         nonReentrant
1001         updateReward(msg.sender)
1002     {
1003         require(amount > 0, "Cannot withdraw 0");
1004         _totalSupply = _totalSupply.sub(amount);
1005         _balances[msg.sender] = _balances[msg.sender].sub(amount);
1006         stakingToken.safeTransfer(msg.sender, amount);
1007         emit Withdrawn(msg.sender, amount);
1008     }
1009 
1010     function getReward() public nonReentrant updateReward(msg.sender) {
1011         uint256 reward = rewards[msg.sender];
1012         if (reward > 0) {
1013             rewards[msg.sender] = 0;
1014             rewardsToken.safeTransfer(msg.sender, reward);
1015             emit RewardPaid(msg.sender, reward);
1016         }
1017     }
1018 
1019     function exit() external {
1020         withdraw(_balances[msg.sender]);
1021         getReward();
1022     }
1023 
1024     // RESTRICTED FUNCTIONS
1025 
1026     function notifyRewardAmount(uint256 reward)
1027         external
1028         onlyOwner
1029         updateReward(address(0))
1030     {
1031         if (block.timestamp >= periodFinish) {
1032             rewardRate = reward.div(rewardsDuration);
1033         } else {
1034             uint256 remaining = periodFinish.sub(block.timestamp);
1035             uint256 leftover = remaining.mul(rewardRate);
1036             rewardRate = reward.add(leftover).div(rewardsDuration);
1037         }
1038 
1039         // Ensure the provided reward amount is not more than the balance in the contract.
1040         // This keeps the reward rate in the right range, preventing overflows due to
1041         // very high values of rewardRate in the earned and rewardsPerToken functions;
1042         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1043         uint256 balance = rewardsToken.balanceOf(address(this));
1044         require(
1045             rewardRate <= balance.div(rewardsDuration),
1046             "Provided reward too high"
1047         );
1048 
1049         lastUpdateTime = block.timestamp;
1050         periodFinish = block.timestamp.add(rewardsDuration);
1051         emit RewardAdded(reward);
1052     }
1053 
1054     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
1055     function recoverERC20(address tokenAddress, uint256 tokenAmount)
1056         external
1057         onlyOwner
1058     {
1059         // Cannot recover the staking token or the rewards token
1060         require(
1061             tokenAddress != address(stakingToken) &&
1062                 tokenAddress != address(rewardsToken),
1063             "Cannot withdraw the staking or rewards tokens"
1064         );
1065         IERC20(tokenAddress).safeTransfer(owner, tokenAmount);
1066         emit Recovered(tokenAddress, tokenAmount);
1067     }
1068 
1069     function setRewardsDuration(uint256 _rewardsDuration) external onlyOwner {
1070         require(
1071             block.timestamp > periodFinish,
1072             "Previous rewards period must be complete before changing the duration for the new period"
1073         );
1074         rewardsDuration = _rewardsDuration;
1075         emit RewardsDurationUpdated(rewardsDuration);
1076     }
1077 
1078     // MODIFIERS
1079 
1080     modifier updateReward(address account) {
1081         rewardPerTokenStored = rewardPerToken();
1082         lastUpdateTime = lastTimeRewardApplicable();
1083         if (account != address(0)) {
1084             rewards[account] = earned(account);
1085             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1086         }
1087         _;
1088     }
1089 
1090     // EVENTS
1091 
1092     event RewardAdded(uint256 reward);
1093     event Staked(address indexed user, uint256 amount);
1094     event Withdrawn(address indexed user, uint256 amount);
1095     event RewardPaid(address indexed user, uint256 reward);
1096     event RewardsDurationUpdated(uint256 newDuration);
1097     event Recovered(address token, uint256 amount);
1098 }