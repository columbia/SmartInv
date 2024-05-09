1 pragma solidity 0.6.12;
2 
3 
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
63 /*
64  * @dev Provides information about the current execution context, including the
65  * sender of the transaction and its data. While these are generally available
66  * via msg.sender and msg.data, they should not be accessed in such a direct
67  * manner, since when dealing with GSN meta-transactions the account sending and
68  * paying for execution may not be the actual sender (as far as an application
69  * is concerned).
70  *
71  * This contract is only required for intermediate, library-like contracts.
72  */
73 abstract contract Context {
74     function _msgSender() internal view virtual returns (address payable) {
75         return msg.sender;
76     }
77 
78     function _msgData() internal view virtual returns (bytes memory) {
79         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
80         return msg.data;
81     }
82 }
83 
84 /**
85  * @dev Contract module which provides a basic access control mechanism, where
86  * there is an account (an owner) that can be granted exclusive access to
87  * specific functions.
88  *
89  * By default, the owner account will be the one that deploys the contract. This
90  * can later be changed with {transferOwnership}.
91  *
92  * This module is used through inheritance. It will make available the modifier
93  * `onlyOwner`, which can be applied to your functions to restrict their use to
94  * the owner.
95  */
96 contract Ownable is Context {
97     address private _owner;
98 
99     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
100 
101     /**
102      * @dev Initializes the contract setting the deployer as the initial owner.
103      */
104     constructor () internal {
105         address msgSender = _msgSender();
106         _owner = msgSender;
107         emit OwnershipTransferred(address(0), msgSender);
108     }
109 
110     /**
111      * @dev Returns the address of the current owner.
112      */
113     function owner() public view returns (address) {
114         return _owner;
115     }
116 
117     /**
118      * @dev Throws if called by any account other than the owner.
119      */
120     modifier onlyOwner() {
121         require(_owner == _msgSender(), "Ownable: caller is not the owner");
122         _;
123     }
124 
125     /**
126      * @dev Leaves the contract without owner. It will not be possible to call
127      * `onlyOwner` functions anymore. Can only be called by the current owner.
128      *
129      * NOTE: Renouncing ownership will leave the contract without an owner,
130      * thereby removing any functionality that is only available to the owner.
131      */
132     function renounceOwnership() public virtual onlyOwner {
133         emit OwnershipTransferred(_owner, address(0));
134         _owner = address(0);
135     }
136 
137     /**
138      * @dev Transfers ownership of the contract to a new account (`newOwner`).
139      * Can only be called by the current owner.
140      */
141     function transferOwnership(address newOwner) public virtual onlyOwner {
142         require(newOwner != address(0), "Ownable: new owner is the zero address");
143         emit OwnershipTransferred(_owner, newOwner);
144         _owner = newOwner;
145     }
146 }
147 
148 // Inheritance
149 // https://docs.synthetix.io/contracts/Pausable
150 abstract contract Pausable is Ownable {
151     uint256 public lastPauseTime;
152     bool public paused;
153 
154     constructor() internal {
155         // This contract is abstract, and thus cannot be instantiated directly
156         require(owner() != address(0), "Owner must be set");
157         // Paused will be false, and lastPauseTime will be 0 upon initialisation
158     }
159 
160     /**
161      * @notice Change the paused state of the contract
162      * @dev Only the contract owner may call this.
163      */
164     function setPaused(bool _paused) external onlyOwner {
165         // Ensure we're actually changing the state before we do anything
166         if (_paused == paused) {
167             return;
168         }
169 
170         // Set our paused state.
171         paused = _paused;
172 
173         // If applicable, set the last pause time.
174         if (paused) {
175             lastPauseTime = now;
176         }
177 
178         // Let everyone know that our pause state has changed.
179         emit PauseChanged(paused);
180     }
181 
182     event PauseChanged(bool isPaused);
183 
184     modifier notPaused {
185         require(
186             !paused,
187             "This action cannot be performed while the contract is paused"
188         );
189         _;
190     }
191 }
192 
193 /**
194  * @dev Wrappers over Solidity's arithmetic operations with added overflow
195  * checks.
196  *
197  * Arithmetic operations in Solidity wrap on overflow. This can easily result
198  * in bugs, because programmers usually assume that an overflow raises an
199  * error, which is the standard behavior in high level programming languages.
200  * `SafeMath` restores this intuition by reverting the transaction when an
201  * operation overflows.
202  *
203  * Using this library instead of the unchecked operations eliminates an entire
204  * class of bugs, so it's recommended to use it always.
205  */
206 library SafeMath {
207     /**
208      * @dev Returns the addition of two unsigned integers, reverting on
209      * overflow.
210      *
211      * Counterpart to Solidity's `+` operator.
212      *
213      * Requirements:
214      *
215      * - Addition cannot overflow.
216      */
217     function add(uint256 a, uint256 b) internal pure returns (uint256) {
218         uint256 c = a + b;
219         require(c >= a, "SafeMath: addition overflow");
220 
221         return c;
222     }
223 
224     /**
225      * @dev Returns the subtraction of two unsigned integers, reverting on
226      * overflow (when the result is negative).
227      *
228      * Counterpart to Solidity's `-` operator.
229      *
230      * Requirements:
231      *
232      * - Subtraction cannot overflow.
233      */
234     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
235         return sub(a, b, "SafeMath: subtraction overflow");
236     }
237 
238     /**
239      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
240      * overflow (when the result is negative).
241      *
242      * Counterpart to Solidity's `-` operator.
243      *
244      * Requirements:
245      *
246      * - Subtraction cannot overflow.
247      */
248     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         require(b <= a, errorMessage);
250         uint256 c = a - b;
251 
252         return c;
253     }
254 
255     /**
256      * @dev Returns the multiplication of two unsigned integers, reverting on
257      * overflow.
258      *
259      * Counterpart to Solidity's `*` operator.
260      *
261      * Requirements:
262      *
263      * - Multiplication cannot overflow.
264      */
265     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
266         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
267         // benefit is lost if 'b' is also tested.
268         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
269         if (a == 0) {
270             return 0;
271         }
272 
273         uint256 c = a * b;
274         require(c / a == b, "SafeMath: multiplication overflow");
275 
276         return c;
277     }
278 
279     /**
280      * @dev Returns the integer division of two unsigned integers. Reverts on
281      * division by zero. The result is rounded towards zero.
282      *
283      * Counterpart to Solidity's `/` operator. Note: this function uses a
284      * `revert` opcode (which leaves remaining gas untouched) while Solidity
285      * uses an invalid opcode to revert (consuming all remaining gas).
286      *
287      * Requirements:
288      *
289      * - The divisor cannot be zero.
290      */
291     function div(uint256 a, uint256 b) internal pure returns (uint256) {
292         return div(a, b, "SafeMath: division by zero");
293     }
294 
295     /**
296      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
297      * division by zero. The result is rounded towards zero.
298      *
299      * Counterpart to Solidity's `/` operator. Note: this function uses a
300      * `revert` opcode (which leaves remaining gas untouched) while Solidity
301      * uses an invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      *
305      * - The divisor cannot be zero.
306      */
307     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
308         require(b > 0, errorMessage);
309         uint256 c = a / b;
310         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
311 
312         return c;
313     }
314 
315     /**
316      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
317      * Reverts when dividing by zero.
318      *
319      * Counterpart to Solidity's `%` operator. This function uses a `revert`
320      * opcode (which leaves remaining gas untouched) while Solidity uses an
321      * invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      *
325      * - The divisor cannot be zero.
326      */
327     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
328         return mod(a, b, "SafeMath: modulo by zero");
329     }
330 
331     /**
332      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
333      * Reverts with custom message when dividing by zero.
334      *
335      * Counterpart to Solidity's `%` operator. This function uses a `revert`
336      * opcode (which leaves remaining gas untouched) while Solidity uses an
337      * invalid opcode to revert (consuming all remaining gas).
338      *
339      * Requirements:
340      *
341      * - The divisor cannot be zero.
342      */
343     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
344         require(b != 0, errorMessage);
345         return a % b;
346     }
347 }
348 
349 /**
350  * @dev Interface of the ERC20 standard as defined in the EIP.
351  */
352 interface IERC20 {
353     /**
354      * @dev Returns the amount of tokens in existence.
355      */
356     function totalSupply() external view returns (uint256);
357 
358     /**
359      * @dev Returns the amount of tokens owned by `account`.
360      */
361     function balanceOf(address account) external view returns (uint256);
362 
363     /**
364      * @dev Moves `amount` tokens from the caller's account to `recipient`.
365      *
366      * Returns a boolean value indicating whether the operation succeeded.
367      *
368      * Emits a {Transfer} event.
369      */
370     function transfer(address recipient, uint256 amount) external returns (bool);
371 
372     /**
373      * @dev Returns the remaining number of tokens that `spender` will be
374      * allowed to spend on behalf of `owner` through {transferFrom}. This is
375      * zero by default.
376      *
377      * This value changes when {approve} or {transferFrom} are called.
378      */
379     function allowance(address owner, address spender) external view returns (uint256);
380 
381     /**
382      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
383      *
384      * Returns a boolean value indicating whether the operation succeeded.
385      *
386      * IMPORTANT: Beware that changing an allowance with this method brings the risk
387      * that someone may use both the old and the new allowance by unfortunate
388      * transaction ordering. One possible solution to mitigate this race
389      * condition is to first reduce the spender's allowance to 0 and set the
390      * desired value afterwards:
391      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
392      *
393      * Emits an {Approval} event.
394      */
395     function approve(address spender, uint256 amount) external returns (bool);
396 
397     /**
398      * @dev Moves `amount` tokens from `sender` to `recipient` using the
399      * allowance mechanism. `amount` is then deducted from the caller's
400      * allowance.
401      *
402      * Returns a boolean value indicating whether the operation succeeded.
403      *
404      * Emits a {Transfer} event.
405      */
406     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
407 
408     /**
409      * @dev Emitted when `value` tokens are moved from one account (`from`) to
410      * another (`to`).
411      *
412      * Note that `value` may be zero.
413      */
414     event Transfer(address indexed from, address indexed to, uint256 value);
415 
416     /**
417      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
418      * a call to {approve}. `value` is the new allowance.
419      */
420     event Approval(address indexed owner, address indexed spender, uint256 value);
421 }
422 
423 // File: contracts/utils/Address.sol
424 /**
425  * @dev Collection of functions related to the address type
426  */
427 library Address {
428     /**
429      * @dev Returns true if `account` is a contract.
430      *
431      * [IMPORTANT]
432      * ====
433      * It is unsafe to assume that an address for which this function returns
434      * false is an externally-owned account (EOA) and not a contract.
435      *
436      * Among others, `isContract` will return false for the following
437      * types of addresses:
438      *
439      *  - an externally-owned account
440      *  - a contract in construction
441      *  - an address where a contract will be created
442      *  - an address where a contract lived, but was destroyed
443      * ====
444      */
445     function isContract(address account) internal view returns (bool) {
446         // This method relies on extcodesize, which returns 0 for contracts in
447         // construction, since the code is only stored at the end of the
448         // constructor execution.
449 
450         uint256 size;
451         // solhint-disable-next-line no-inline-assembly
452         assembly { size := extcodesize(account) }
453         return size > 0;
454     }
455 
456     /**
457      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
458      * `recipient`, forwarding all available gas and reverting on errors.
459      *
460      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
461      * of certain opcodes, possibly making contracts go over the 2300 gas limit
462      * imposed by `transfer`, making them unable to receive funds via
463      * `transfer`. {sendValue} removes this limitation.
464      *
465      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
466      *
467      * IMPORTANT: because control is transferred to `recipient`, care must be
468      * taken to not create reentrancy vulnerabilities. Consider using
469      * {ReentrancyGuard} or the
470      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
471      */
472     function sendValue(address payable recipient, uint256 amount) internal {
473         require(address(this).balance >= amount, "Address: insufficient balance");
474 
475         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
476         (bool success, ) = recipient.call{ value: amount }("");
477         require(success, "Address: unable to send value, recipient may have reverted");
478     }
479 
480     /**
481      * @dev Performs a Solidity function call using a low level `call`. A
482      * plain`call` is an unsafe replacement for a function call: use this
483      * function instead.
484      *
485      * If `target` reverts with a revert reason, it is bubbled up by this
486      * function (like regular Solidity function calls).
487      *
488      * Returns the raw returned data. To convert to the expected return value,
489      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
490      *
491      * Requirements:
492      *
493      * - `target` must be a contract.
494      * - calling `target` with `data` must not revert.
495      *
496      * _Available since v3.1._
497      */
498     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
499       return functionCall(target, data, "Address: low-level call failed");
500     }
501 
502     /**
503      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
504      * `errorMessage` as a fallback revert reason when `target` reverts.
505      *
506      * _Available since v3.1._
507      */
508     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
509         return _functionCallWithValue(target, data, 0, errorMessage);
510     }
511 
512     /**
513      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
514      * but also transferring `value` wei to `target`.
515      *
516      * Requirements:
517      *
518      * - the calling contract must have an ETH balance of at least `value`.
519      * - the called Solidity function must be `payable`.
520      *
521      * _Available since v3.1._
522      */
523     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
524         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
525     }
526 
527     /**
528      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
529      * with `errorMessage` as a fallback revert reason when `target` reverts.
530      *
531      * _Available since v3.1._
532      */
533     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
534         require(address(this).balance >= value, "Address: insufficient balance for call");
535         return _functionCallWithValue(target, data, value, errorMessage);
536     }
537 
538     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
539         require(isContract(target), "Address: call to non-contract");
540 
541         // solhint-disable-next-line avoid-low-level-calls
542         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
543         if (success) {
544             return returndata;
545         } else {
546             // Look for revert reason and bubble it up if present
547             if (returndata.length > 0) {
548                 // The easiest way to bubble the revert reason is using memory via assembly
549 
550                 // solhint-disable-next-line no-inline-assembly
551                 assembly {
552                     let returndata_size := mload(returndata)
553                     revert(add(32, returndata), returndata_size)
554                 }
555             } else {
556                 revert(errorMessage);
557             }
558         }
559     }
560 }
561 
562 // File: contracts/token/ERC20/ERC20.sol
563 /**
564  * @dev Implementation of the {IERC20} interface.
565  *
566  * This implementation is agnostic to the way tokens are created. This means
567  * that a supply mechanism has to be added in a derived contract using {_mint}.
568  * For a generic mechanism see {ERC20PresetMinterPauser}.
569  *
570  * TIP: For a detailed writeup see our guide
571  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
572  * to implement supply mechanisms].
573  *
574  * We have followed general OpenZeppelin guidelines: functions revert instead
575  * of returning `false` on failure. This behavior is nonetheless conventional
576  * and does not conflict with the expectations of ERC20 applications.
577  *
578  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
579  * This allows applications to reconstruct the allowance for all accounts just
580  * by listening to said events. Other implementations of the EIP may not emit
581  * these events, as it isn't required by the specification.
582  *
583  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
584  * functions have been added to mitigate the well-known issues around setting
585  * allowances. See {IERC20-approve}.
586  */
587 contract ERC20 is Context, IERC20 {
588     using SafeMath for uint256;
589     using Address for address;
590 
591     mapping (address => uint256) private _balances;
592 
593     mapping (address => mapping (address => uint256)) private _allowances;
594 
595     uint256 private _totalSupply;
596 
597     string private _name;
598     string private _symbol;
599     uint8 private _decimals;
600 
601     /**
602      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
603      * a default value of 18.
604      *
605      * To select a different value for {decimals}, use {_setupDecimals}.
606      *
607      * All three of these values are immutable: they can only be set once during
608      * construction.
609      */
610     constructor (string memory name, string memory symbol) public {
611         _name = name;
612         _symbol = symbol;
613         _decimals = 18;
614     }
615 
616     /**
617      * @dev Returns the name of the token.
618      */
619     function name() public view returns (string memory) {
620         return _name;
621     }
622 
623     /**
624      * @dev Returns the symbol of the token, usually a shorter version of the
625      * name.
626      */
627     function symbol() public view returns (string memory) {
628         return _symbol;
629     }
630 
631     /**
632      * @dev Returns the number of decimals used to get its user representation.
633      * For example, if `decimals` equals `2`, a balance of `505` tokens should
634      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
635      *
636      * Tokens usually opt for a value of 18, imitating the relationship between
637      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
638      * called.
639      *
640      * NOTE: This information is only used for _display_ purposes: it in
641      * no way affects any of the arithmetic of the contract, including
642      * {IERC20-balanceOf} and {IERC20-transfer}.
643      */
644     function decimals() public view returns (uint8) {
645         return _decimals;
646     }
647 
648     /**
649      * @dev See {IERC20-totalSupply}.
650      */
651     function totalSupply() public view override returns (uint256) {
652         return _totalSupply;
653     }
654 
655     /**
656      * @dev See {IERC20-balanceOf}.
657      */
658     function balanceOf(address account) public view override returns (uint256) {
659         return _balances[account];
660     }
661 
662     /**
663      * @dev See {IERC20-transfer}.
664      *
665      * Requirements:
666      *
667      * - `recipient` cannot be the zero address.
668      * - the caller must have a balance of at least `amount`.
669      */
670     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
671         _transfer(_msgSender(), recipient, amount);
672         return true;
673     }
674 
675     /**
676      * @dev See {IERC20-allowance}.
677      */
678     function allowance(address owner, address spender) public view virtual override returns (uint256) {
679         return _allowances[owner][spender];
680     }
681 
682     /**
683      * @dev See {IERC20-approve}.
684      *
685      * Requirements:
686      *
687      * - `spender` cannot be the zero address.
688      */
689     function approve(address spender, uint256 amount) public virtual override returns (bool) {
690         _approve(_msgSender(), spender, amount);
691         return true;
692     }
693 
694     /**
695      * @dev See {IERC20-transferFrom}.
696      *
697      * Emits an {Approval} event indicating the updated allowance. This is not
698      * required by the EIP. See the note at the beginning of {ERC20};
699      *
700      * Requirements:
701      * - `sender` and `recipient` cannot be the zero address.
702      * - `sender` must have a balance of at least `amount`.
703      * - the caller must have allowance for ``sender``'s tokens of at least
704      * `amount`.
705      */
706     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
707         _transfer(sender, recipient, amount);
708         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
709         return true;
710     }
711 
712     /**
713      * @dev Atomically increases the allowance granted to `spender` by the caller.
714      *
715      * This is an alternative to {approve} that can be used as a mitigation for
716      * problems described in {IERC20-approve}.
717      *
718      * Emits an {Approval} event indicating the updated allowance.
719      *
720      * Requirements:
721      *
722      * - `spender` cannot be the zero address.
723      */
724     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
725         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
726         return true;
727     }
728 
729     /**
730      * @dev Atomically decreases the allowance granted to `spender` by the caller.
731      *
732      * This is an alternative to {approve} that can be used as a mitigation for
733      * problems described in {IERC20-approve}.
734      *
735      * Emits an {Approval} event indicating the updated allowance.
736      *
737      * Requirements:
738      *
739      * - `spender` cannot be the zero address.
740      * - `spender` must have allowance for the caller of at least
741      * `subtractedValue`.
742      */
743     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
744         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
745         return true;
746     }
747 
748     /**
749      * @dev Moves tokens `amount` from `sender` to `recipient`.
750      *
751      * This is internal function is equivalent to {transfer}, and can be used to
752      * e.g. implement automatic token fees, slashing mechanisms, etc.
753      *
754      * Emits a {Transfer} event.
755      *
756      * Requirements:
757      *
758      * - `sender` cannot be the zero address.
759      * - `recipient` cannot be the zero address.
760      * - `sender` must have a balance of at least `amount`.
761      */
762     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
763         require(sender != address(0), "ERC20: transfer from the zero address");
764         require(recipient != address(0), "ERC20: transfer to the zero address");
765 
766         _beforeTokenTransfer(sender, recipient, amount);
767 
768         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
769         _balances[recipient] = _balances[recipient].add(amount);
770         emit Transfer(sender, recipient, amount);
771     }
772 
773     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
774      * the total supply.
775      *
776      * Emits a {Transfer} event with `from` set to the zero address.
777      *
778      * Requirements
779      *
780      * - `to` cannot be the zero address.
781      */
782     function _mint(address account, uint256 amount) internal virtual {
783         require(account != address(0), "ERC20: mint to the zero address");
784 
785         _beforeTokenTransfer(address(0), account, amount);
786 
787         _totalSupply = _totalSupply.add(amount);
788         _balances[account] = _balances[account].add(amount);
789         emit Transfer(address(0), account, amount);
790     }
791 
792     /**
793      * @dev Destroys `amount` tokens from `account`, reducing the
794      * total supply.
795      *
796      * Emits a {Transfer} event with `to` set to the zero address.
797      *
798      * Requirements
799      *
800      * - `account` cannot be the zero address.
801      * - `account` must have at least `amount` tokens.
802      */
803     function _burn(address account, uint256 amount) internal virtual {
804         require(account != address(0), "ERC20: burn from the zero address");
805 
806         _beforeTokenTransfer(account, address(0), amount);
807 
808         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
809         _totalSupply = _totalSupply.sub(amount);
810         emit Transfer(account, address(0), amount);
811     }
812 
813     /**
814      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
815      *
816      * This internal function is equivalent to `approve`, and can be used to
817      * e.g. set automatic allowances for certain subsystems, etc.
818      *
819      * Emits an {Approval} event.
820      *
821      * Requirements:
822      *
823      * - `owner` cannot be the zero address.
824      * - `spender` cannot be the zero address.
825      */
826     function _approve(address owner, address spender, uint256 amount) internal virtual {
827         require(owner != address(0), "ERC20: approve from the zero address");
828         require(spender != address(0), "ERC20: approve to the zero address");
829 
830         _allowances[owner][spender] = amount;
831         emit Approval(owner, spender, amount);
832     }
833 
834     /**
835      * @dev Sets {decimals} to a value other than the default one of 18.
836      *
837      * WARNING: This function should only be called from the constructor. Most
838      * applications that interact with token contracts will not expect
839      * {decimals} to ever change, and may work incorrectly if it does.
840      */
841     function _setupDecimals(uint8 decimals_) internal {
842         _decimals = decimals_;
843     }
844 
845     /**
846      * @dev Hook that is called before any transfer of tokens. This includes
847      * minting and burning.
848      *
849      * Calling conditions:
850      *
851      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
852      * will be to transferred to `to`.
853      * - when `from` is zero, `amount` tokens will be minted for `to`.
854      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
855      * - `from` and `to` are never both zero.
856      *
857      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
858      */
859     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
860 }
861 
862 /**
863  * @title SafeERC20
864  * @dev Wrappers around ERC20 operations that throw on failure (when the token
865  * contract returns false). Tokens that return no value (and instead revert or
866  * throw on failure) are also supported, non-reverting calls are assumed to be
867  * successful.
868  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
869  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
870  */
871 library SafeERC20 {
872     using SafeMath for uint256;
873     using Address for address;
874 
875     function safeTransfer(IERC20 token, address to, uint256 value) internal {
876         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
877     }
878 
879     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
880         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
881     }
882 
883     /**
884      * @dev Deprecated. This function has issues similar to the ones found in
885      * {IERC20-approve}, and its usage is discouraged.
886      *
887      * Whenever possible, use {safeIncreaseAllowance} and
888      * {safeDecreaseAllowance} instead.
889      */
890     function safeApprove(IERC20 token, address spender, uint256 value) internal {
891         // safeApprove should only be called when setting an initial allowance,
892         // or when resetting it to zero. To increase and decrease it, use
893         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
894         // solhint-disable-next-line max-line-length
895         require((value == 0) || (token.allowance(address(this), spender) == 0),
896             "SafeERC20: approve from non-zero to non-zero allowance"
897         );
898         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
899     }
900 
901     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
902         uint256 newAllowance = token.allowance(address(this), spender).add(value);
903         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
904     }
905 
906     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
907         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
908         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
909     }
910 
911     /**
912      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
913      * on the return value: the return value is optional (but if data is returned, it must not be false).
914      * @param token The token targeted by the call.
915      * @param data The call data (encoded using abi.encode or one of its variants).
916      */
917     function _callOptionalReturn(IERC20 token, bytes memory data) private {
918         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
919         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
920         // the target address contains contract code and also asserts for success in the low-level call.
921 
922         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
923         if (returndata.length > 0) { // Return data is optional
924             // solhint-disable-next-line max-line-length
925             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
926         }
927     }
928 }
929 
930 contract YvsPool is ReentrancyGuard, Pausable {
931     using SafeMath for uint256;
932     using SafeERC20 for IERC20;
933 
934     // STATE VARIABLES
935 
936     address public controller;
937 
938     IERC20 public rewardsToken;
939     IERC20 public stakingToken;
940     uint256 public periodFinish = 0;
941     uint256 public rewardRate = 0;
942     uint256 public rewardsDuration = 52600000;
943     uint256 public lastUpdateTime;
944     uint256 public rewardPerTokenStored;
945 
946     mapping(address => uint256) public userRewardPerTokenPaid;
947     mapping(address => uint256) public rewards;
948 
949     uint256 private _totalSupply;
950     mapping(address => uint256) private _balances;
951 
952     // CONSTRUCTOR
953 
954     constructor(
955         address _rewardsToken,
956         address _stakingToken
957     ) public {
958         rewardsToken = IERC20(_rewardsToken);
959         if (_stakingToken != address(0)) {
960             stakingToken = IERC20(_stakingToken);
961         }
962     }
963 
964     // VIEWS
965 
966     function totalSupply() external view returns (uint256) {
967         return _totalSupply;
968     }
969 
970     function balanceOf(address account) external view returns (uint256) {
971         return _balances[account];
972     }
973 
974     function lastTimeRewardApplicable() public view returns (uint256) {
975         return min(block.timestamp, periodFinish);
976     }
977 
978     function rewardPerToken() public view returns (uint256) {
979         if (_totalSupply == 0) {
980             return rewardPerTokenStored;
981         }
982         return
983             rewardPerTokenStored.add(
984                 lastTimeRewardApplicable()
985                     .sub(lastUpdateTime)
986                     .mul(rewardRate)
987                     .mul(1e18)
988                     .div(_totalSupply)
989             );
990     }
991 
992     function earned(address account) public view returns (uint256) {
993         return
994             _balances[account]
995                 .mul(rewardPerToken().sub(userRewardPerTokenPaid[account]))
996                 .div(1e18)
997                 .add(rewards[account]);
998     }
999 
1000     function getRewardForDuration() external view returns (uint256) {
1001         return rewardRate.mul(rewardsDuration);
1002     }
1003 
1004     function min(uint256 a, uint256 b) public pure returns (uint256) {
1005         return a < b ? a : b;
1006     }
1007 
1008     // PUBLIC FUNCTIONS
1009 
1010     function stake(uint256 amount)
1011         external
1012         nonReentrant
1013         notPaused
1014         updateReward(msg.sender)
1015     {
1016         require(amount > 0, "Cannot stake 0");
1017 
1018         uint256 balBefore = stakingToken.balanceOf(address(this));
1019         stakingToken.safeTransferFrom(msg.sender, address(this), amount);
1020         uint256 balAfter = stakingToken.balanceOf(address(this));
1021         uint256 actualReceived = balAfter.sub(balBefore);
1022 
1023         _totalSupply = _totalSupply.add(actualReceived);
1024         _balances[msg.sender] = _balances[msg.sender].add(actualReceived);
1025         
1026         emit Staked(msg.sender, actualReceived);
1027     }
1028 
1029     function withdraw(uint256 amount)
1030         public
1031         nonReentrant
1032         updateReward(msg.sender)
1033     {
1034         require(amount > 0, "Cannot withdraw 0");
1035 
1036         _totalSupply = _totalSupply.sub(amount);
1037         _balances[msg.sender] = _balances[msg.sender].sub(amount);
1038         stakingToken.safeTransfer(msg.sender, amount);
1039 
1040         emit Withdrawn(msg.sender, amount);
1041     }
1042 
1043     function getReward() public nonReentrant updateReward(msg.sender) {
1044         uint256 reward = rewards[msg.sender];
1045         if (reward > 0) {
1046             rewards[msg.sender] = 0;
1047             rewardsToken.safeTransfer(msg.sender, reward);
1048             emit RewardPaid(msg.sender, reward);
1049         }
1050     }
1051 
1052     function exit() external {
1053         withdraw(_balances[msg.sender]);
1054         getReward();
1055     }
1056 
1057     // RESTRICTED FUNCTIONS
1058 
1059     function setStakingToken(address _stakingToken)
1060         external
1061         restricted
1062     {
1063         require(address(stakingToken) == address(0), "!stakingToken");
1064         stakingToken = IERC20(_stakingToken);
1065     }
1066 
1067     function setController(address _controller)
1068         external
1069         restricted
1070     {
1071         require(controller == address(0), "!controller");
1072         controller = _controller;
1073     }
1074 
1075     function notifyRewardAmount(uint256 reward)
1076         external
1077         restricted
1078         updateReward(address(0))
1079     {
1080         if (block.timestamp >= periodFinish) {
1081             rewardRate = reward.div(rewardsDuration);
1082         } else {
1083             uint256 remaining = periodFinish.sub(block.timestamp);
1084             uint256 leftover = remaining.mul(rewardRate);
1085             rewardRate = reward.add(leftover).div(rewardsDuration);
1086         }
1087 
1088         // Ensure the provided reward amount is not more than the balance in the contract.
1089         // This keeps the reward rate in the right range, preventing overflows due to
1090         // very high values of rewardRate in the earned and rewardsPerToken functions;
1091         // Reward + leftover must be less than 2^256 / 10^18 to avoid overflow.
1092         uint256 balance = rewardsToken.balanceOf(address(this));
1093         require(
1094             rewardRate <= balance.div(rewardsDuration),
1095             "Provided reward too high"
1096         );
1097 
1098         lastUpdateTime = block.timestamp;
1099         periodFinish = block.timestamp.add(rewardsDuration);
1100         emit RewardAdded(reward);
1101     }
1102 
1103     // Added to support recovering LP Rewards from other systems such as BAL to be distributed to holders
1104     function recoverERC20(address tokenAddress, uint256 tokenAmount)
1105         external
1106         onlyOwner
1107     {
1108         // Cannot recover the staking token or the rewards token
1109         require(
1110             tokenAddress != address(stakingToken) &&
1111                 tokenAddress != address(rewardsToken),
1112             "Cannot withdraw the staking or rewards tokens"
1113         );
1114         IERC20(tokenAddress).safeTransfer(owner(), tokenAmount);
1115         emit Recovered(tokenAddress, tokenAmount);
1116     }
1117 
1118     function setRewardsDuration(uint256 _rewardsDuration) external restricted {
1119         require(
1120             block.timestamp > periodFinish,
1121             "Previous rewards period must be complete before changing the duration for the new period"
1122         );
1123         rewardsDuration = _rewardsDuration;
1124         emit RewardsDurationUpdated(rewardsDuration);
1125     }
1126 
1127     // *** MODIFIERS ***
1128 
1129     modifier updateReward(address account) {
1130         rewardPerTokenStored = rewardPerToken();
1131         lastUpdateTime = lastTimeRewardApplicable();
1132         if (account != address(0)) {
1133             rewards[account] = earned(account);
1134             userRewardPerTokenPaid[account] = rewardPerTokenStored;
1135         }
1136 
1137         _;
1138     }
1139 
1140     modifier restricted {
1141         require(
1142             msg.sender == controller ||
1143             msg.sender == owner(),
1144             '!restricted'
1145         );
1146 
1147         _;
1148     }
1149 
1150     // EVENTS
1151 
1152     event RewardAdded(uint256 reward);
1153     event Staked(address indexed user, uint256 amount);
1154     event Withdrawn(address indexed user, uint256 amount);
1155     event RewardPaid(address indexed user, uint256 reward);
1156     event RewardsDurationUpdated(uint256 newDuration);
1157     event Recovered(address token, uint256 amount);
1158 }