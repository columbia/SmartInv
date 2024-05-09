1 pragma solidity 0.6.12;
2 
3 
4 
5 /**
6  * @dev Contract module that helps prevent reentrant calls to a function.
7  *
8  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
9  * available, which can be applied to functions to make sure there are no nested
10  * (reentrant) calls to them.
11  *
12  * Note that because there is a single `nonReentrant` guard, functions marked as
13  * `nonReentrant` may not call one another. This can be worked around by making
14  * those functions `private`, and then adding `external` `nonReentrant` entry
15  * points to them.
16  *
17  * TIP: If you would like to learn more about reentrancy and alternative ways
18  * to protect against it, check out our blog post
19  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
20  */
21 contract ReentrancyGuard {
22     // Booleans are more expensive than uint256 or any type that takes up a full
23     // word because each write operation emits an extra SLOAD to first read the
24     // slot's contents, replace the bits taken up by the boolean, and then write
25     // back. This is the compiler's defense against contract upgrades and
26     // pointer aliasing, and it cannot be disabled.
27 
28     // The values being non-zero value makes deployment a bit more expensive,
29     // but in exchange the refund on every call to nonReentrant will be lower in
30     // amount. Since refunds are capped to a percentage of the total
31     // transaction's gas, it is best to keep them low in cases like this one, to
32     // increase the likelihood of the full refund coming into effect.
33     uint256 private constant _NOT_ENTERED = 1;
34     uint256 private constant _ENTERED = 2;
35 
36     uint256 private _status;
37 
38     constructor () internal {
39         _status = _NOT_ENTERED;
40     }
41 
42     /**
43      * @dev Prevents a contract from calling itself, directly or indirectly.
44      * Calling a `nonReentrant` function from another `nonReentrant`
45      * function is not supported. It is possible to prevent this from happening
46      * by making the `nonReentrant` function external, and make it call a
47      * `private` function that does the actual work.
48      */
49     modifier nonReentrant() {
50         // On the first call to nonReentrant, _notEntered will be true
51         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
52 
53         // Any calls to nonReentrant after this point will fail
54         _status = _ENTERED;
55 
56         _;
57 
58         // By storing the original value once again, a refund is triggered (see
59         // https://eips.ethereum.org/EIPS/eip-2200)
60         _status = _NOT_ENTERED;
61     }
62 }
63 
64 
65 /*
66  * @dev Provides information about the current execution context, including the
67  * sender of the transaction and its data. While these are generally available
68  * via msg.sender and msg.data, they should not be accessed in such a direct
69  * manner, since when dealing with GSN meta-transactions the account sending and
70  * paying for execution may not be the actual sender (as far as an application
71  * is concerned).
72  *
73  * This contract is only required for intermediate, library-like contracts.
74  */
75 abstract contract Context {
76     function _msgSender() internal view virtual returns (address payable) {
77         return msg.sender;
78     }
79 
80     function _msgData() internal view virtual returns (bytes memory) {
81         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
82         return msg.data;
83     }
84 }
85 
86 
87 /**
88  * @dev Contract module which provides a basic access control mechanism, where
89  * there is an account (an owner) that can be granted exclusive access to
90  * specific functions.
91  *
92  * By default, the owner account will be the one that deploys the contract. This
93  * can later be changed with {transferOwnership}.
94  *
95  * This module is used through inheritance. It will make available the modifier
96  * `onlyOwner`, which can be applied to your functions to restrict their use to
97  * the owner.
98  */
99 contract Ownable is Context {
100     address private _owner;
101 
102     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
103 
104     /**
105      * @dev Initializes the contract setting the deployer as the initial owner.
106      */
107     constructor () internal {
108         address msgSender = _msgSender();
109         _owner = msgSender;
110         emit OwnershipTransferred(address(0), msgSender);
111     }
112 
113     /**
114      * @dev Returns the address of the current owner.
115      */
116     function owner() public view returns (address) {
117         return _owner;
118     }
119 
120     /**
121      * @dev Throws if called by any account other than the owner.
122      */
123     modifier onlyOwner() {
124         require(_owner == _msgSender(), "Ownable: caller is not the owner");
125         _;
126     }
127 
128     /**
129      * @dev Leaves the contract without owner. It will not be possible to call
130      * `onlyOwner` functions anymore. Can only be called by the current owner.
131      *
132      * NOTE: Renouncing ownership will leave the contract without an owner,
133      * thereby removing any functionality that is only available to the owner.
134      */
135     function renounceOwnership() public virtual onlyOwner {
136         emit OwnershipTransferred(_owner, address(0));
137         _owner = address(0);
138     }
139 
140     /**
141      * @dev Transfers ownership of the contract to a new account (`newOwner`).
142      * Can only be called by the current owner.
143      */
144     function transferOwnership(address newOwner) public virtual onlyOwner {
145         require(newOwner != address(0), "Ownable: new owner is the zero address");
146         emit OwnershipTransferred(_owner, newOwner);
147         _owner = newOwner;
148     }
149 }
150 
151 
152 // Inheritance
153 // https://docs.synthetix.io/contracts/Pausable
154 abstract contract Pausable is Ownable {
155     uint256 public lastPauseTime;
156     bool public paused;
157 
158     constructor() internal {
159         // This contract is abstract, and thus cannot be instantiated directly
160         require(owner() != address(0), "Owner must be set");
161         // Paused will be false, and lastPauseTime will be 0 upon initialisation
162     }
163 
164     /**
165      * @notice Change the paused state of the contract
166      * @dev Only the contract owner may call this.
167      */
168     function setPaused(bool _paused) external onlyOwner {
169         // Ensure we're actually changing the state before we do anything
170         if (_paused == paused) {
171             return;
172         }
173 
174         // Set our paused state.
175         paused = _paused;
176 
177         // If applicable, set the last pause time.
178         if (paused) {
179             lastPauseTime = now;
180         }
181 
182         // Let everyone know that our pause state has changed.
183         emit PauseChanged(paused);
184     }
185 
186     event PauseChanged(bool isPaused);
187 
188     modifier notPaused {
189         require(
190             !paused,
191             "This action cannot be performed while the contract is paused"
192         );
193         _;
194     }
195 }
196 
197 
198 /**
199  * @dev Wrappers over Solidity's arithmetic operations with added overflow
200  * checks.
201  *
202  * Arithmetic operations in Solidity wrap on overflow. This can easily result
203  * in bugs, because programmers usually assume that an overflow raises an
204  * error, which is the standard behavior in high level programming languages.
205  * `SafeMath` restores this intuition by reverting the transaction when an
206  * operation overflows.
207  *
208  * Using this library instead of the unchecked operations eliminates an entire
209  * class of bugs, so it's recommended to use it always.
210  */
211 library SafeMath {
212     /**
213      * @dev Returns the addition of two unsigned integers, reverting on
214      * overflow.
215      *
216      * Counterpart to Solidity's `+` operator.
217      *
218      * Requirements:
219      *
220      * - Addition cannot overflow.
221      */
222     function add(uint256 a, uint256 b) internal pure returns (uint256) {
223         uint256 c = a + b;
224         require(c >= a, "SafeMath: addition overflow");
225 
226         return c;
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      *
237      * - Subtraction cannot overflow.
238      */
239     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
240         return sub(a, b, "SafeMath: subtraction overflow");
241     }
242 
243     /**
244      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
245      * overflow (when the result is negative).
246      *
247      * Counterpart to Solidity's `-` operator.
248      *
249      * Requirements:
250      *
251      * - Subtraction cannot overflow.
252      */
253     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
254         require(b <= a, errorMessage);
255         uint256 c = a - b;
256 
257         return c;
258     }
259 
260     /**
261      * @dev Returns the multiplication of two unsigned integers, reverting on
262      * overflow.
263      *
264      * Counterpart to Solidity's `*` operator.
265      *
266      * Requirements:
267      *
268      * - Multiplication cannot overflow.
269      */
270     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
271         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
272         // benefit is lost if 'b' is also tested.
273         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
274         if (a == 0) {
275             return 0;
276         }
277 
278         uint256 c = a * b;
279         require(c / a == b, "SafeMath: multiplication overflow");
280 
281         return c;
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers. Reverts on
286      * division by zero. The result is rounded towards zero.
287      *
288      * Counterpart to Solidity's `/` operator. Note: this function uses a
289      * `revert` opcode (which leaves remaining gas untouched) while Solidity
290      * uses an invalid opcode to revert (consuming all remaining gas).
291      *
292      * Requirements:
293      *
294      * - The divisor cannot be zero.
295      */
296     function div(uint256 a, uint256 b) internal pure returns (uint256) {
297         return div(a, b, "SafeMath: division by zero");
298     }
299 
300     /**
301      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
302      * division by zero. The result is rounded towards zero.
303      *
304      * Counterpart to Solidity's `/` operator. Note: this function uses a
305      * `revert` opcode (which leaves remaining gas untouched) while Solidity
306      * uses an invalid opcode to revert (consuming all remaining gas).
307      *
308      * Requirements:
309      *
310      * - The divisor cannot be zero.
311      */
312     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
313         require(b > 0, errorMessage);
314         uint256 c = a / b;
315         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
316 
317         return c;
318     }
319 
320     /**
321      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
322      * Reverts when dividing by zero.
323      *
324      * Counterpart to Solidity's `%` operator. This function uses a `revert`
325      * opcode (which leaves remaining gas untouched) while Solidity uses an
326      * invalid opcode to revert (consuming all remaining gas).
327      *
328      * Requirements:
329      *
330      * - The divisor cannot be zero.
331      */
332     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
333         return mod(a, b, "SafeMath: modulo by zero");
334     }
335 
336     /**
337      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
338      * Reverts with custom message when dividing by zero.
339      *
340      * Counterpart to Solidity's `%` operator. This function uses a `revert`
341      * opcode (which leaves remaining gas untouched) while Solidity uses an
342      * invalid opcode to revert (consuming all remaining gas).
343      *
344      * Requirements:
345      *
346      * - The divisor cannot be zero.
347      */
348     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
349         require(b != 0, errorMessage);
350         return a % b;
351     }
352 }
353 
354 
355 /**
356  * @dev Interface of the ERC20 standard as defined in the EIP.
357  */
358 interface IERC20 {
359     /**
360      * @dev Returns the amount of tokens in existence.
361      */
362     function totalSupply() external view returns (uint256);
363 
364     /**
365      * @dev Returns the amount of tokens owned by `account`.
366      */
367     function balanceOf(address account) external view returns (uint256);
368 
369     /**
370      * @dev Moves `amount` tokens from the caller's account to `recipient`.
371      *
372      * Returns a boolean value indicating whether the operation succeeded.
373      *
374      * Emits a {Transfer} event.
375      */
376     function transfer(address recipient, uint256 amount) external returns (bool);
377 
378     /**
379      * @dev Returns the remaining number of tokens that `spender` will be
380      * allowed to spend on behalf of `owner` through {transferFrom}. This is
381      * zero by default.
382      *
383      * This value changes when {approve} or {transferFrom} are called.
384      */
385     function allowance(address owner, address spender) external view returns (uint256);
386 
387     /**
388      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
389      *
390      * Returns a boolean value indicating whether the operation succeeded.
391      *
392      * IMPORTANT: Beware that changing an allowance with this method brings the risk
393      * that someone may use both the old and the new allowance by unfortunate
394      * transaction ordering. One possible solution to mitigate this race
395      * condition is to first reduce the spender's allowance to 0 and set the
396      * desired value afterwards:
397      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
398      *
399      * Emits an {Approval} event.
400      */
401     function approve(address spender, uint256 amount) external returns (bool);
402 
403     /**
404      * @dev Moves `amount` tokens from `sender` to `recipient` using the
405      * allowance mechanism. `amount` is then deducted from the caller's
406      * allowance.
407      *
408      * Returns a boolean value indicating whether the operation succeeded.
409      *
410      * Emits a {Transfer} event.
411      */
412     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
413 
414     /**
415      * @dev Emitted when `value` tokens are moved from one account (`from`) to
416      * another (`to`).
417      *
418      * Note that `value` may be zero.
419      */
420     event Transfer(address indexed from, address indexed to, uint256 value);
421 
422     /**
423      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
424      * a call to {approve}. `value` is the new allowance.
425      */
426     event Approval(address indexed owner, address indexed spender, uint256 value);
427 }
428 
429 // File: contracts/utils/Address.sol
430 /**
431  * @dev Collection of functions related to the address type
432  */
433 library Address {
434     /**
435      * @dev Returns true if `account` is a contract.
436      *
437      * [IMPORTANT]
438      * ====
439      * It is unsafe to assume that an address for which this function returns
440      * false is an externally-owned account (EOA) and not a contract.
441      *
442      * Among others, `isContract` will return false for the following
443      * types of addresses:
444      *
445      *  - an externally-owned account
446      *  - a contract in construction
447      *  - an address where a contract will be created
448      *  - an address where a contract lived, but was destroyed
449      * ====
450      */
451     function isContract(address account) internal view returns (bool) {
452         // This method relies on extcodesize, which returns 0 for contracts in
453         // construction, since the code is only stored at the end of the
454         // constructor execution.
455 
456         uint256 size;
457         // solhint-disable-next-line no-inline-assembly
458         assembly { size := extcodesize(account) }
459         return size > 0;
460     }
461 
462     /**
463      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
464      * `recipient`, forwarding all available gas and reverting on errors.
465      *
466      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
467      * of certain opcodes, possibly making contracts go over the 2300 gas limit
468      * imposed by `transfer`, making them unable to receive funds via
469      * `transfer`. {sendValue} removes this limitation.
470      *
471      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
472      *
473      * IMPORTANT: because control is transferred to `recipient`, care must be
474      * taken to not create reentrancy vulnerabilities. Consider using
475      * {ReentrancyGuard} or the
476      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
477      */
478     function sendValue(address payable recipient, uint256 amount) internal {
479         require(address(this).balance >= amount, "Address: insufficient balance");
480 
481         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
482         (bool success, ) = recipient.call{ value: amount }("");
483         require(success, "Address: unable to send value, recipient may have reverted");
484     }
485 
486     /**
487      * @dev Performs a Solidity function call using a low level `call`. A
488      * plain`call` is an unsafe replacement for a function call: use this
489      * function instead.
490      *
491      * If `target` reverts with a revert reason, it is bubbled up by this
492      * function (like regular Solidity function calls).
493      *
494      * Returns the raw returned data. To convert to the expected return value,
495      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
496      *
497      * Requirements:
498      *
499      * - `target` must be a contract.
500      * - calling `target` with `data` must not revert.
501      *
502      * _Available since v3.1._
503      */
504     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
505       return functionCall(target, data, "Address: low-level call failed");
506     }
507 
508     /**
509      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
510      * `errorMessage` as a fallback revert reason when `target` reverts.
511      *
512      * _Available since v3.1._
513      */
514     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
515         return _functionCallWithValue(target, data, 0, errorMessage);
516     }
517 
518     /**
519      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
520      * but also transferring `value` wei to `target`.
521      *
522      * Requirements:
523      *
524      * - the calling contract must have an ETH balance of at least `value`.
525      * - the called Solidity function must be `payable`.
526      *
527      * _Available since v3.1._
528      */
529     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
530         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
531     }
532 
533     /**
534      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
535      * with `errorMessage` as a fallback revert reason when `target` reverts.
536      *
537      * _Available since v3.1._
538      */
539     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
540         require(address(this).balance >= value, "Address: insufficient balance for call");
541         return _functionCallWithValue(target, data, value, errorMessage);
542     }
543 
544     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
545         require(isContract(target), "Address: call to non-contract");
546 
547         // solhint-disable-next-line avoid-low-level-calls
548         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
549         if (success) {
550             return returndata;
551         } else {
552             // Look for revert reason and bubble it up if present
553             if (returndata.length > 0) {
554                 // The easiest way to bubble the revert reason is using memory via assembly
555 
556                 // solhint-disable-next-line no-inline-assembly
557                 assembly {
558                     let returndata_size := mload(returndata)
559                     revert(add(32, returndata), returndata_size)
560                 }
561             } else {
562                 revert(errorMessage);
563             }
564         }
565     }
566 }
567 
568 // File: contracts/token/ERC20/ERC20.sol
569 /**
570  * @dev Implementation of the {IERC20} interface.
571  *
572  * This implementation is agnostic to the way tokens are created. This means
573  * that a supply mechanism has to be added in a derived contract using {_mint}.
574  * For a generic mechanism see {ERC20PresetMinterPauser}.
575  *
576  * TIP: For a detailed writeup see our guide
577  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
578  * to implement supply mechanisms].
579  *
580  * We have followed general OpenZeppelin guidelines: functions revert instead
581  * of returning `false` on failure. This behavior is nonetheless conventional
582  * and does not conflict with the expectations of ERC20 applications.
583  *
584  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
585  * This allows applications to reconstruct the allowance for all accounts just
586  * by listening to said events. Other implementations of the EIP may not emit
587  * these events, as it isn't required by the specification.
588  *
589  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
590  * functions have been added to mitigate the well-known issues around setting
591  * allowances. See {IERC20-approve}.
592  */
593 contract ERC20 is Context, IERC20 {
594     using SafeMath for uint256;
595     using Address for address;
596 
597     mapping (address => uint256) private _balances;
598 
599     mapping (address => mapping (address => uint256)) private _allowances;
600 
601     uint256 private _totalSupply;
602 
603     string private _name;
604     string private _symbol;
605     uint8 private _decimals;
606 
607     /**
608      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
609      * a default value of 18.
610      *
611      * To select a different value for {decimals}, use {_setupDecimals}.
612      *
613      * All three of these values are immutable: they can only be set once during
614      * construction.
615      */
616     constructor (string memory name, string memory symbol) public {
617         _name = name;
618         _symbol = symbol;
619         _decimals = 18;
620     }
621 
622     /**
623      * @dev Returns the name of the token.
624      */
625     function name() public view returns (string memory) {
626         return _name;
627     }
628 
629     /**
630      * @dev Returns the symbol of the token, usually a shorter version of the
631      * name.
632      */
633     function symbol() public view returns (string memory) {
634         return _symbol;
635     }
636 
637     /**
638      * @dev Returns the number of decimals used to get its user representation.
639      * For example, if `decimals` equals `2`, a balance of `505` tokens should
640      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
641      *
642      * Tokens usually opt for a value of 18, imitating the relationship between
643      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
644      * called.
645      *
646      * NOTE: This information is only used for _display_ purposes: it in
647      * no way affects any of the arithmetic of the contract, including
648      * {IERC20-balanceOf} and {IERC20-transfer}.
649      */
650     function decimals() public view returns (uint8) {
651         return _decimals;
652     }
653 
654     /**
655      * @dev See {IERC20-totalSupply}.
656      */
657     function totalSupply() public view override returns (uint256) {
658         return _totalSupply;
659     }
660 
661     /**
662      * @dev See {IERC20-balanceOf}.
663      */
664     function balanceOf(address account) public view override returns (uint256) {
665         return _balances[account];
666     }
667 
668     /**
669      * @dev See {IERC20-transfer}.
670      *
671      * Requirements:
672      *
673      * - `recipient` cannot be the zero address.
674      * - the caller must have a balance of at least `amount`.
675      */
676     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
677         _transfer(_msgSender(), recipient, amount);
678         return true;
679     }
680 
681     /**
682      * @dev See {IERC20-allowance}.
683      */
684     function allowance(address owner, address spender) public view virtual override returns (uint256) {
685         return _allowances[owner][spender];
686     }
687 
688     /**
689      * @dev See {IERC20-approve}.
690      *
691      * Requirements:
692      *
693      * - `spender` cannot be the zero address.
694      */
695     function approve(address spender, uint256 amount) public virtual override returns (bool) {
696         _approve(_msgSender(), spender, amount);
697         return true;
698     }
699 
700     /**
701      * @dev See {IERC20-transferFrom}.
702      *
703      * Emits an {Approval} event indicating the updated allowance. This is not
704      * required by the EIP. See the note at the beginning of {ERC20};
705      *
706      * Requirements:
707      * - `sender` and `recipient` cannot be the zero address.
708      * - `sender` must have a balance of at least `amount`.
709      * - the caller must have allowance for ``sender``'s tokens of at least
710      * `amount`.
711      */
712     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
713         _transfer(sender, recipient, amount);
714         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
715         return true;
716     }
717 
718     /**
719      * @dev Atomically increases the allowance granted to `spender` by the caller.
720      *
721      * This is an alternative to {approve} that can be used as a mitigation for
722      * problems described in {IERC20-approve}.
723      *
724      * Emits an {Approval} event indicating the updated allowance.
725      *
726      * Requirements:
727      *
728      * - `spender` cannot be the zero address.
729      */
730     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
731         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
732         return true;
733     }
734 
735     /**
736      * @dev Atomically decreases the allowance granted to `spender` by the caller.
737      *
738      * This is an alternative to {approve} that can be used as a mitigation for
739      * problems described in {IERC20-approve}.
740      *
741      * Emits an {Approval} event indicating the updated allowance.
742      *
743      * Requirements:
744      *
745      * - `spender` cannot be the zero address.
746      * - `spender` must have allowance for the caller of at least
747      * `subtractedValue`.
748      */
749     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
750         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
751         return true;
752     }
753 
754     /**
755      * @dev Moves tokens `amount` from `sender` to `recipient`.
756      *
757      * This is internal function is equivalent to {transfer}, and can be used to
758      * e.g. implement automatic token fees, slashing mechanisms, etc.
759      *
760      * Emits a {Transfer} event.
761      *
762      * Requirements:
763      *
764      * - `sender` cannot be the zero address.
765      * - `recipient` cannot be the zero address.
766      * - `sender` must have a balance of at least `amount`.
767      */
768     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
769         require(sender != address(0), "ERC20: transfer from the zero address");
770         require(recipient != address(0), "ERC20: transfer to the zero address");
771 
772         _beforeTokenTransfer(sender, recipient, amount);
773 
774         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
775         _balances[recipient] = _balances[recipient].add(amount);
776         emit Transfer(sender, recipient, amount);
777     }
778 
779     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
780      * the total supply.
781      *
782      * Emits a {Transfer} event with `from` set to the zero address.
783      *
784      * Requirements
785      *
786      * - `to` cannot be the zero address.
787      */
788     function _mint(address account, uint256 amount) internal virtual {
789         require(account != address(0), "ERC20: mint to the zero address");
790 
791         _beforeTokenTransfer(address(0), account, amount);
792 
793         _totalSupply = _totalSupply.add(amount);
794         _balances[account] = _balances[account].add(amount);
795         emit Transfer(address(0), account, amount);
796     }
797 
798     /**
799      * @dev Destroys `amount` tokens from `account`, reducing the
800      * total supply.
801      *
802      * Emits a {Transfer} event with `to` set to the zero address.
803      *
804      * Requirements
805      *
806      * - `account` cannot be the zero address.
807      * - `account` must have at least `amount` tokens.
808      */
809     function _burn(address account, uint256 amount) internal virtual {
810         require(account != address(0), "ERC20: burn from the zero address");
811 
812         _beforeTokenTransfer(account, address(0), amount);
813 
814         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
815         _totalSupply = _totalSupply.sub(amount);
816         emit Transfer(account, address(0), amount);
817     }
818 
819     /**
820      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
821      *
822      * This internal function is equivalent to `approve`, and can be used to
823      * e.g. set automatic allowances for certain subsystems, etc.
824      *
825      * Emits an {Approval} event.
826      *
827      * Requirements:
828      *
829      * - `owner` cannot be the zero address.
830      * - `spender` cannot be the zero address.
831      */
832     function _approve(address owner, address spender, uint256 amount) internal virtual {
833         require(owner != address(0), "ERC20: approve from the zero address");
834         require(spender != address(0), "ERC20: approve to the zero address");
835 
836         _allowances[owner][spender] = amount;
837         emit Approval(owner, spender, amount);
838     }
839 
840     /**
841      * @dev Sets {decimals} to a value other than the default one of 18.
842      *
843      * WARNING: This function should only be called from the constructor. Most
844      * applications that interact with token contracts will not expect
845      * {decimals} to ever change, and may work incorrectly if it does.
846      */
847     function _setupDecimals(uint8 decimals_) internal {
848         _decimals = decimals_;
849     }
850 
851     /**
852      * @dev Hook that is called before any transfer of tokens. This includes
853      * minting and burning.
854      *
855      * Calling conditions:
856      *
857      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
858      * will be to transferred to `to`.
859      * - when `from` is zero, `amount` tokens will be minted for `to`.
860      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
861      * - `from` and `to` are never both zero.
862      *
863      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
864      */
865     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
866 }
867 
868 /**
869  * @title SafeERC20
870  * @dev Wrappers around ERC20 operations that throw on failure (when the token
871  * contract returns false). Tokens that return no value (and instead revert or
872  * throw on failure) are also supported, non-reverting calls are assumed to be
873  * successful.
874  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
875  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
876  */
877 library SafeERC20 {
878     using SafeMath for uint256;
879     using Address for address;
880 
881     function safeTransfer(IERC20 token, address to, uint256 value) internal {
882         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
883     }
884 
885     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
886         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
887     }
888 
889     /**
890      * @dev Deprecated. This function has issues similar to the ones found in
891      * {IERC20-approve}, and its usage is discouraged.
892      *
893      * Whenever possible, use {safeIncreaseAllowance} and
894      * {safeDecreaseAllowance} instead.
895      */
896     function safeApprove(IERC20 token, address spender, uint256 value) internal {
897         // safeApprove should only be called when setting an initial allowance,
898         // or when resetting it to zero. To increase and decrease it, use
899         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
900         // solhint-disable-next-line max-line-length
901         require((value == 0) || (token.allowance(address(this), spender) == 0),
902             "SafeERC20: approve from non-zero to non-zero allowance"
903         );
904         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
905     }
906 
907     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
908         uint256 newAllowance = token.allowance(address(this), spender).add(value);
909         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
910     }
911 
912     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
913         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
914         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
915     }
916 
917     /**
918      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
919      * on the return value: the return value is optional (but if data is returned, it must not be false).
920      * @param token The token targeted by the call.
921      * @param data The call data (encoded using abi.encode or one of its variants).
922      */
923     function _callOptionalReturn(IERC20 token, bytes memory data) private {
924         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
925         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
926         // the target address contains contract code and also asserts for success in the low-level call.
927 
928         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
929         if (returndata.length > 0) { // Return data is optional
930             // solhint-disable-next-line max-line-length
931             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
932         }
933     }
934 }
935 
936 
937 contract YvsLiquidityPool is ReentrancyGuard, Pausable {
938     using SafeMath for uint256;
939     using SafeERC20 for IERC20;
940 
941     // STATE VARIABLES
942 
943     address public controller;
944 
945     IERC20 public rewardsToken;
946     IERC20 public stakingToken;
947     uint256 public periodFinish = 0;
948     uint256 public rewardRate = 0;
949     uint256 public rewardsDuration = 52600000;
950     uint256 public lastUpdateTime;
951     uint256 public rewardPerTokenStored;
952 
953     mapping(address => uint256) public userRewardPerTokenPaid;
954     mapping(address => uint256) public rewards;
955 
956     uint256 private _totalSupply;
957     uint256 private _totalLocked;
958 
959     mapping(address => uint256) private _balances;
960     mapping(address => uint256) private _locked;
961 
962     // CONSTRUCTOR
963 
964     constructor(
965         address _rewardsToken,
966         address _stakingToken
967     ) public {
968         rewardsToken = IERC20(_rewardsToken);
969         if (_stakingToken != address(0)) {
970             stakingToken = IERC20(_stakingToken);
971         }
972     }
973 
974     // VIEWS
975 
976     function totalSupply() external view returns (uint256) {
977         return _totalSupply;
978     }
979 
980     function totalLocked() external view returns (uint256) {
981         return _totalLocked;
982     }
983 
984     function balanceOf(address account) external view returns (uint256) {
985         return _balances[account];
986     }
987 
988     function withdrawable(address account) external view returns (uint256) {
989         return _balances[account].sub(_locked[account]);
990     }
991 
992     function lastTimeRewardApplicable() public view returns (uint256) {
993         return min(block.timestamp, periodFinish);
994     }
995 
996     function rewardPerToken() public view returns (uint256) {
997         if (_totalSupply == 0) {
998             return rewardPerTokenStored;
999         }
1000         return
1001             rewardPerTokenStored.add(
1002                 lastTimeRewardApplicable()
1003                     .sub(lastUpdateTime)
1004                     .mul(rewardRate)
1005                     .mul(1e18)
1006                     .div(_totalSupply)
1007             );
1008     }
1009 
1010     function earned(address account) public view returns (uint256) {
1011         return
1012             _balances[account]
1013                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
1014                 .div(1e18)
1015                 .add(rewards[account]);
1016     }
1017 
1018     function getRewardForDuration() external view returns (uint256) {
1019         return rewardRate.mul(rewardsDuration);
1020     }
1021 
1022     function min(uint256 a, uint256 b) public pure returns (uint256) {
1023         return a < b ? a : b;
1024     }
1025 
1026     // PUBLIC FUNCTIONS
1027 
1028     function stake(uint256 amount)
1029         external
1030         nonReentrant
1031         notPaused
1032         updateReward(msg.sender)
1033     {
1034         require(amount > 0, "stake: cannot stake 0");
1035 
1036         uint256 balBefore = stakingToken.balanceOf(address(this));
1037         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1038         uint256 balAfter = stakingToken.balanceOf(address(this));
1039         uint256 actualReceived = balAfter.sub(balBefore);
1040 
1041         // 50 % od deposited liquidity is locked forever
1042         uint256 lockedAmount = actualReceived.div(2);
1043         _totalSupply = _totalSupply.add(actualReceived);
1044         _balances[msg.sender] = _balances[msg.sender].add(actualReceived);
1045         _locked[msg.sender] = _locked[msg.sender].add(lockedAmount);
1046         _totalLocked = _totalLocked.add(lockedAmount);
1047         
1048         emit Staked(msg.sender, amount);
1049     }
1050 
1051     function withdraw(uint256 amount)
1052         public
1053         nonReentrant
1054         updateReward(msg.sender)
1055     {
1056         require(amount > 0, "withdraw: cannot withdraw 0");
1057         require(_balances[msg.sender].sub(amount) >= _locked[msg.sender], "withdraw: 50 % of tokens stay locked forever");
1058 
1059         // user can only withdraw what is not locked
1060         _totalSupply = _totalSupply.sub(amount);
1061         _balances[msg.sender] = _balances[msg.sender].sub(amount);
1062         stakingToken.safeTransfer(msg.sender, amount);
1063 
1064         emit Withdrawn(msg.sender, amount);
1065     }
1066 
1067     function getReward() public nonReentrant updateReward(msg.sender) {
1068         uint256 reward = rewards[msg.sender];
1069         if (reward > 0) {
1070             rewards[msg.sender] = 0;
1071             rewardsToken.safeTransfer(msg.sender, reward);
1072             emit RewardPaid(msg.sender, reward);
1073         }
1074     }
1075 
1076     function exit() external {
1077         withdraw(_balances[msg.sender].sub(_locked[msg.sender]));
1078         getReward();
1079     }
1080 
1081     // RESTRICTED FUNCTIONS
1082 
1083     function setStakingToken(address _stakingToken)
1084         external
1085         restricted
1086     {
1087         require(address(stakingToken) == address(0), "!stakingToken");
1088         stakingToken = IERC20(_stakingToken);
1089     }
1090 
1091     function setController(address _controller)
1092         external
1093         restricted
1094     {
1095         require(controller == address(0), "!controller");
1096         controller = _controller;
1097     }
1098 
1099     function notifyRewardAmount(uint256 reward)
1100         external
1101         restricted
1102         updateReward(address(0))
1103     {
1104         if (block.timestamp >= periodFinish) {
1105             rewardRate = reward.div(rewardsDuration);
1106         } else {
1107             uint256 remaining = periodFinish.sub(block.timestamp);
1108             uint256 leftover = remaining.mul(rewardRate);
1109             rewardRate = reward.add(leftover).div(rewardsDuration);
1110         }
1111 
1112         // Ensure the provided reward amount is not more than the balance in the contract.
1113         // This keeps the reward rate in the right range, preventing overflows due to
1114         // very high values of rewardRate in the earned and rewardsPerToken functions;
1115         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1116         uint256 balance = rewardsToken.balanceOf(address(this));
1117         require(
1118             rewardRate <= balance.div(rewardsDuration),
1119             "Provided reward too high"
1120         );
1121 
1122         lastUpdateTime = block.timestamp;
1123         periodFinish = block.timestamp.add(rewardsDuration);
1124         emit RewardAdded(reward);
1125     }
1126 
1127     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
1128     function recoverERC20(address tokenAddress, uint256 tokenAmount)
1129         external
1130         onlyOwner
1131     {
1132         // Cannot recover the staking token or the rewards token
1133         require(
1134             tokenAddress != address(stakingToken) &&
1135                 tokenAddress != address(rewardsToken),
1136             "Cannot withdraw the staking or rewards tokens"
1137         );
1138         IERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
1139         emit Recovered(tokenAddress, tokenAmount);
1140     }
1141 
1142     function setRewardsDuration(uint256 _rewardsDuration) external restricted {
1143         require(
1144             block.timestamp > periodFinish,
1145             "Previous rewards period must be complete before changing the duration for the new period"
1146         );
1147         rewardsDuration = _rewardsDuration;
1148         emit RewardsDurationUpdated(rewardsDuration);
1149     }
1150 
1151     // *** MODIFIERS ***
1152 
1153     modifier updateReward(address account) {
1154         rewardPerTokenStored = rewardPerToken();
1155         lastUpdateTime = lastTimeRewardApplicable();
1156         if (account != address(0)) {
1157             rewards[account] = earned(account);
1158             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1159         }
1160 
1161         _;
1162     }
1163 
1164     modifier restricted {
1165         require(
1166             msg.sender == controller ||
1167             msg.sender == owner(),
1168             '!restricted'
1169         );
1170 
1171         _;
1172     }
1173 
1174     // EVENTS
1175 
1176     event RewardAdded(uint256 reward);
1177     event Staked(address indexed user, uint256 amount);
1178     event Withdrawn(address indexed user, uint256 amount);
1179     event RewardPaid(address indexed user, uint256 reward);
1180     event RewardsDurationUpdated(uint256 newDuration);
1181     event Recovered(address token, uint256 amount);
1182 }