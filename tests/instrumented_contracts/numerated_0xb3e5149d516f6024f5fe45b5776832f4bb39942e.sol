1 // File: contracts/ChiGasSaver.sol
2 
3 pragma solidity >=0.4.22 <0.8.0;
4 
5 interface IFreeFromUpTo {
6    function freeFromUpTo(address from, uint256 value) external returns(uint256 freed);
7 }
8 
9 contract ChiGasSaver {
10 
11    modifier saveGas(address payable sponsor, address chiToken) {
12        uint256 gasStart = gasleft();
13        _;
14        uint256 gasSpent = 21000 + gasStart - gasleft() + 16 * msg.data.length;
15 
16        IFreeFromUpTo chi = IFreeFromUpTo(chiToken);
17        chi.freeFromUpTo(sponsor, (gasSpent + 14154) / 41947);
18    }
19 }
20 
21 // File: @openzeppelin/contracts/GSN/Context.sol
22 
23 /*
24  * @dev Provides information about the current execution context, including the
25  * sender of the transaction and its data. While these are generally available
26  * via msg.sender and msg.data, they should not be accessed in such a direct
27  * manner, since when dealing with GSN meta-transactions the account sending and
28  * paying for execution may not be the actual sender (as far as an application
29  * is concerned).
30  *
31  * This contract is only required for intermediate, library-like contracts.
32  */
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address payable) {
35         return msg.sender;
36     }
37 
38     function _msgData() internal view virtual returns (bytes memory) {
39         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
40         return msg.data;
41     }
42 }
43 
44 // File: @openzeppelin/contracts/access/Ownable.sol
45 
46 
47 /**
48  * @dev Contract module which provides a basic access control mechanism, where
49  * there is an account (an owner) that can be granted exclusive access to
50  * specific functions.
51  *
52  * By default, the owner account will be the one that deploys the contract. This
53  * can later be changed with {transferOwnership}.
54  *
55  * This module is used through inheritance. It will make available the modifier
56  * `onlyOwner`, which can be applied to your functions to restrict their use to
57  * the owner.
58  */
59 contract Ownable is Context {
60     address private _owner;
61 
62     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
63 
64     /**
65      * @dev Initializes the contract setting the deployer as the initial owner.
66      */
67     constructor () internal {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     /**
74      * @dev Returns the address of the current owner.
75      */
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     /**
81      * @dev Throws if called by any account other than the owner.
82      */
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     /**
89      * @dev Leaves the contract without owner. It will not be possible to call
90      * `onlyOwner` functions anymore. Can only be called by the current owner.
91      *
92      * NOTE: Renouncing ownership will leave the contract without an owner,
93      * thereby removing any functionality that is only available to the owner.
94      */
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99 
100     /**
101      * @dev Transfers ownership of the contract to a new account (`newOwner`).
102      * Can only be called by the current owner.
103      */
104     function transferOwnership(address newOwner) public virtual onlyOwner {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         emit OwnershipTransferred(_owner, newOwner);
107         _owner = newOwner;
108     }
109 }
110 
111 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
112 
113 
114 /**
115  * @dev Interface of the ERC20 standard as defined in the EIP.
116  */
117 interface IERC20 {
118     /**
119      * @dev Returns the amount of tokens in existence.
120      */
121     function totalSupply() external view returns (uint256);
122 
123     /**
124      * @dev Returns the amount of tokens owned by `account`.
125      */
126     function balanceOf(address account) external view returns (uint256);
127 
128     /**
129      * @dev Moves `amount` tokens from the caller's account to `recipient`.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * Emits a {Transfer} event.
134      */
135     function transfer(address recipient, uint256 amount) external returns (bool);
136 
137     /**
138      * @dev Returns the remaining number of tokens that `spender` will be
139      * allowed to spend on behalf of `owner` through {transferFrom}. This is
140      * zero by default.
141      *
142      * This value changes when {approve} or {transferFrom} are called.
143      */
144     function allowance(address owner, address spender) external view returns (uint256);
145 
146     /**
147      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * IMPORTANT: Beware that changing an allowance with this method brings the risk
152      * that someone may use both the old and the new allowance by unfortunate
153      * transaction ordering. One possible solution to mitigate this race
154      * condition is to first reduce the spender's allowance to 0 and set the
155      * desired value afterwards:
156      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
157      *
158      * Emits an {Approval} event.
159      */
160     function approve(address spender, uint256 amount) external returns (bool);
161 
162     /**
163      * @dev Moves `amount` tokens from `sender` to `recipient` using the
164      * allowance mechanism. `amount` is then deducted from the caller's
165      * allowance.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Emitted when `value` tokens are moved from one account (`from`) to
175      * another (`to`).
176      *
177      * Note that `value` may be zero.
178      */
179     event Transfer(address indexed from, address indexed to, uint256 value);
180 
181     /**
182      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
183      * a call to {approve}. `value` is the new allowance.
184      */
185     event Approval(address indexed owner, address indexed spender, uint256 value);
186 }
187 
188 // File: @openzeppelin/contracts/math/SafeMath.sol
189 
190 
191 /**
192  * @dev Wrappers over Solidity's arithmetic operations with added overflow
193  * checks.
194  *
195  * Arithmetic operations in Solidity wrap on overflow. This can easily result
196  * in bugs, because programmers usually assume that an overflow raises an
197  * error, which is the standard behavior in high level programming languages.
198  * `SafeMath` restores this intuition by reverting the transaction when an
199  * operation overflows.
200  *
201  * Using this library instead of the unchecked operations eliminates an entire
202  * class of bugs, so it's recommended to use it always.
203  */
204 library SafeMath {
205     /**
206      * @dev Returns the addition of two unsigned integers, reverting on
207      * overflow.
208      *
209      * Counterpart to Solidity's `+` operator.
210      *
211      * Requirements:
212      *
213      * - Addition cannot overflow.
214      */
215     function add(uint256 a, uint256 b) internal pure returns (uint256) {
216         uint256 c = a + b;
217         require(c >= a, "SafeMath: addition overflow");
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the subtraction of two unsigned integers, reverting on
224      * overflow (when the result is negative).
225      *
226      * Counterpart to Solidity's `-` operator.
227      *
228      * Requirements:
229      *
230      * - Subtraction cannot overflow.
231      */
232     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
233         return sub(a, b, "SafeMath: subtraction overflow");
234     }
235 
236     /**
237      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
238      * overflow (when the result is negative).
239      *
240      * Counterpart to Solidity's `-` operator.
241      *
242      * Requirements:
243      *
244      * - Subtraction cannot overflow.
245      */
246     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247         require(b <= a, errorMessage);
248         uint256 c = a - b;
249 
250         return c;
251     }
252 
253     /**
254      * @dev Returns the multiplication of two unsigned integers, reverting on
255      * overflow.
256      *
257      * Counterpart to Solidity's `*` operator.
258      *
259      * Requirements:
260      *
261      * - Multiplication cannot overflow.
262      */
263     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
264         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
265         // benefit is lost if 'b' is also tested.
266         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
267         if (a == 0) {
268             return 0;
269         }
270 
271         uint256 c = a * b;
272         require(c / a == b, "SafeMath: multiplication overflow");
273 
274         return c;
275     }
276 
277     /**
278      * @dev Returns the integer division of two unsigned integers. Reverts on
279      * division by zero. The result is rounded towards zero.
280      *
281      * Counterpart to Solidity's `/` operator. Note: this function uses a
282      * `revert` opcode (which leaves remaining gas untouched) while Solidity
283      * uses an invalid opcode to revert (consuming all remaining gas).
284      *
285      * Requirements:
286      *
287      * - The divisor cannot be zero.
288      */
289     function div(uint256 a, uint256 b) internal pure returns (uint256) {
290         return div(a, b, "SafeMath: division by zero");
291     }
292 
293     /**
294      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
295      * division by zero. The result is rounded towards zero.
296      *
297      * Counterpart to Solidity's `/` operator. Note: this function uses a
298      * `revert` opcode (which leaves remaining gas untouched) while Solidity
299      * uses an invalid opcode to revert (consuming all remaining gas).
300      *
301      * Requirements:
302      *
303      * - The divisor cannot be zero.
304      */
305     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
306         require(b > 0, errorMessage);
307         uint256 c = a / b;
308         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
309 
310         return c;
311     }
312 
313     /**
314      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
315      * Reverts when dividing by zero.
316      *
317      * Counterpart to Solidity's `%` operator. This function uses a `revert`
318      * opcode (which leaves remaining gas untouched) while Solidity uses an
319      * invalid opcode to revert (consuming all remaining gas).
320      *
321      * Requirements:
322      *
323      * - The divisor cannot be zero.
324      */
325     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
326         return mod(a, b, "SafeMath: modulo by zero");
327     }
328 
329     /**
330      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
331      * Reverts with custom message when dividing by zero.
332      *
333      * Counterpart to Solidity's `%` operator. This function uses a `revert`
334      * opcode (which leaves remaining gas untouched) while Solidity uses an
335      * invalid opcode to revert (consuming all remaining gas).
336      *
337      * Requirements:
338      *
339      * - The divisor cannot be zero.
340      */
341     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
342         require(b != 0, errorMessage);
343         return a % b;
344     }
345 }
346 
347 // File: @openzeppelin/contracts/utils/Address.sol
348 
349 /**
350  * @dev Collection of functions related to the address type
351  */
352 library Address {
353     /**
354      * @dev Returns true if `account` is a contract.
355      *
356      * [IMPORTANT]
357      * ====
358      * It is unsafe to assume that an address for which this function returns
359      * false is an externally-owned account (EOA) and not a contract.
360      *
361      * Among others, `isContract` will return false for the following
362      * types of addresses:
363      *
364      *  - an externally-owned account
365      *  - a contract in construction
366      *  - an address where a contract will be created
367      *  - an address where a contract lived, but was destroyed
368      * ====
369      */
370     function isContract(address account) internal view returns (bool) {
371         // This method relies in extcodesize, which returns 0 for contracts in
372         // construction, since the code is only stored at the end of the
373         // constructor execution.
374 
375         uint256 size;
376         // solhint-disable-next-line no-inline-assembly
377         assembly { size := extcodesize(account) }
378         return size > 0;
379     }
380 
381     /**
382      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
383      * `recipient`, forwarding all available gas and reverting on errors.
384      *
385      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
386      * of certain opcodes, possibly making contracts go over the 2300 gas limit
387      * imposed by `transfer`, making them unable to receive funds via
388      * `transfer`. {sendValue} removes this limitation.
389      *
390      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
391      *
392      * IMPORTANT: because control is transferred to `recipient`, care must be
393      * taken to not create reentrancy vulnerabilities. Consider using
394      * {ReentrancyGuard} or the
395      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
396      */
397     function sendValue(address payable recipient, uint256 amount) internal {
398         require(address(this).balance >= amount, "Address: insufficient balance");
399 
400         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
401         (bool success, ) = recipient.call{ value: amount }("");
402         require(success, "Address: unable to send value, recipient may have reverted");
403     }
404 
405     /**
406      * @dev Performs a Solidity function call using a low level `call`. A
407      * plain`call` is an unsafe replacement for a function call: use this
408      * function instead.
409      *
410      * If `target` reverts with a revert reason, it is bubbled up by this
411      * function (like regular Solidity function calls).
412      *
413      * Returns the raw returned data. To convert to the expected return value,
414      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
415      *
416      * Requirements:
417      *
418      * - `target` must be a contract.
419      * - calling `target` with `data` must not revert.
420      *
421      * _Available since v3.1._
422      */
423     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
424       return functionCall(target, data, "Address: low-level call failed");
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
429      * `errorMessage` as a fallback revert reason when `target` reverts.
430      *
431      * _Available since v3.1._
432      */
433     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
434         return _functionCallWithValue(target, data, 0, errorMessage);
435     }
436 
437     /**
438      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
439      * but also transferring `value` wei to `target`.
440      *
441      * Requirements:
442      *
443      * - the calling contract must have an ETH balance of at least `value`.
444      * - the called Solidity function must be `payable`.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
449         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
450     }
451 
452     /**
453      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
454      * with `errorMessage` as a fallback revert reason when `target` reverts.
455      *
456      * _Available since v3.1._
457      */
458     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
459         require(address(this).balance >= value, "Address: insufficient balance for call");
460         return _functionCallWithValue(target, data, value, errorMessage);
461     }
462 
463     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
464         require(isContract(target), "Address: call to non-contract");
465 
466         // solhint-disable-next-line avoid-low-level-calls
467         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
468         if (success) {
469             return returndata;
470         } else {
471             // Look for revert reason and bubble it up if present
472             if (returndata.length > 0) {
473                 // The easiest way to bubble the revert reason is using memory via assembly
474 
475                 // solhint-disable-next-line no-inline-assembly
476                 assembly {
477                     let returndata_size := mload(returndata)
478                     revert(add(32, returndata), returndata_size)
479                 }
480             } else {
481                 revert(errorMessage);
482             }
483         }
484     }
485 }
486 
487 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
488 
489 
490 /**
491  * @dev Implementation of the {IERC20} interface.
492  *
493  * This implementation is agnostic to the way tokens are created. This means
494  * that a supply mechanism has to be added in a derived contract using {_mint}.
495  * For a generic mechanism see {ERC20PresetMinterPauser}.
496  *
497  * TIP: For a detailed writeup see our guide
498  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
499  * to implement supply mechanisms].
500  *
501  * We have followed general OpenZeppelin guidelines: functions revert instead
502  * of returning `false` on failure. This behavior is nonetheless conventional
503  * and does not conflict with the expectations of ERC20 applications.
504  *
505  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
506  * This allows applications to reconstruct the allowance for all accounts just
507  * by listening to said events. Other implementations of the EIP may not emit
508  * these events, as it isn't required by the specification.
509  *
510  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
511  * functions have been added to mitigate the well-known issues around setting
512  * allowances. See {IERC20-approve}.
513  */
514 contract ERC20 is Context, IERC20 {
515     using SafeMath for uint256;
516     using Address for address;
517 
518     mapping (address => uint256) private _balances;
519 
520     mapping (address => mapping (address => uint256)) private _allowances;
521 
522     uint256 private _totalSupply;
523 
524     string private _name;
525     string private _symbol;
526     uint8 private _decimals;
527 
528     /**
529      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
530      * a default value of 18.
531      *
532      * To select a different value for {decimals}, use {_setupDecimals}.
533      *
534      * All three of these values are immutable: they can only be set once during
535      * construction.
536      */
537     constructor (string memory name, string memory symbol) public {
538         _name = name;
539         _symbol = symbol;
540         _decimals = 18;
541     }
542 
543     /**
544      * @dev Returns the name of the token.
545      */
546     function name() public view returns (string memory) {
547         return _name;
548     }
549 
550     /**
551      * @dev Returns the symbol of the token, usually a shorter version of the
552      * name.
553      */
554     function symbol() public view returns (string memory) {
555         return _symbol;
556     }
557 
558     /**
559      * @dev Returns the number of decimals used to get its user representation.
560      * For example, if `decimals` equals `2`, a balance of `505` tokens should
561      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
562      *
563      * Tokens usually opt for a value of 18, imitating the relationship between
564      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
565      * called.
566      *
567      * NOTE: This information is only used for _display_ purposes: it in
568      * no way affects any of the arithmetic of the contract, including
569      * {IERC20-balanceOf} and {IERC20-transfer}.
570      */
571     function decimals() public view returns (uint8) {
572         return _decimals;
573     }
574 
575     /**
576      * @dev See {IERC20-totalSupply}.
577      */
578     function totalSupply() public view override returns (uint256) {
579         return _totalSupply;
580     }
581 
582     /**
583      * @dev See {IERC20-balanceOf}.
584      */
585     function balanceOf(address account) public view override returns (uint256) {
586         return _balances[account];
587     }
588 
589     /**
590      * @dev See {IERC20-transfer}.
591      *
592      * Requirements:
593      *
594      * - `recipient` cannot be the zero address.
595      * - the caller must have a balance of at least `amount`.
596      */
597     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
598         _transfer(_msgSender(), recipient, amount);
599         return true;
600     }
601 
602     /**
603      * @dev See {IERC20-allowance}.
604      */
605     function allowance(address owner, address spender) public view virtual override returns (uint256) {
606         return _allowances[owner][spender];
607     }
608 
609     /**
610      * @dev See {IERC20-approve}.
611      *
612      * Requirements:
613      *
614      * - `spender` cannot be the zero address.
615      */
616     function approve(address spender, uint256 amount) public virtual override returns (bool) {
617         _approve(_msgSender(), spender, amount);
618         return true;
619     }
620 
621     /**
622      * @dev See {IERC20-transferFrom}.
623      *
624      * Emits an {Approval} event indicating the updated allowance. This is not
625      * required by the EIP. See the note at the beginning of {ERC20};
626      *
627      * Requirements:
628      * - `sender` and `recipient` cannot be the zero address.
629      * - `sender` must have a balance of at least `amount`.
630      * - the caller must have allowance for ``sender``'s tokens of at least
631      * `amount`.
632      */
633     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
634         _transfer(sender, recipient, amount);
635         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
636         return true;
637     }
638 
639     /**
640      * @dev Atomically increases the allowance granted to `spender` by the caller.
641      *
642      * This is an alternative to {approve} that can be used as a mitigation for
643      * problems described in {IERC20-approve}.
644      *
645      * Emits an {Approval} event indicating the updated allowance.
646      *
647      * Requirements:
648      *
649      * - `spender` cannot be the zero address.
650      */
651     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
652         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
653         return true;
654     }
655 
656     /**
657      * @dev Atomically decreases the allowance granted to `spender` by the caller.
658      *
659      * This is an alternative to {approve} that can be used as a mitigation for
660      * problems described in {IERC20-approve}.
661      *
662      * Emits an {Approval} event indicating the updated allowance.
663      *
664      * Requirements:
665      *
666      * - `spender` cannot be the zero address.
667      * - `spender` must have allowance for the caller of at least
668      * `subtractedValue`.
669      */
670     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
671         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
672         return true;
673     }
674 
675     /**
676      * @dev Moves tokens `amount` from `sender` to `recipient`.
677      *
678      * This is internal function is equivalent to {transfer}, and can be used to
679      * e.g. implement automatic token fees, slashing mechanisms, etc.
680      *
681      * Emits a {Transfer} event.
682      *
683      * Requirements:
684      *
685      * - `sender` cannot be the zero address.
686      * - `recipient` cannot be the zero address.
687      * - `sender` must have a balance of at least `amount`.
688      */
689     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
690         require(sender != address(0), "ERC20: transfer from the zero address");
691         require(recipient != address(0), "ERC20: transfer to the zero address");
692 
693         _beforeTokenTransfer(sender, recipient, amount);
694 
695         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
696         _balances[recipient] = _balances[recipient].add(amount);
697         emit Transfer(sender, recipient, amount);
698     }
699 
700     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
701      * the total supply.
702      *
703      * Emits a {Transfer} event with `from` set to the zero address.
704      *
705      * Requirements
706      *
707      * - `to` cannot be the zero address.
708      */
709     function _mint(address account, uint256 amount) internal virtual {
710         require(account != address(0), "ERC20: mint to the zero address");
711 
712         _beforeTokenTransfer(address(0), account, amount);
713 
714         _totalSupply = _totalSupply.add(amount);
715         _balances[account] = _balances[account].add(amount);
716         emit Transfer(address(0), account, amount);
717     }
718 
719     /**
720      * @dev Destroys `amount` tokens from `account`, reducing the
721      * total supply.
722      *
723      * Emits a {Transfer} event with `to` set to the zero address.
724      *
725      * Requirements
726      *
727      * - `account` cannot be the zero address.
728      * - `account` must have at least `amount` tokens.
729      */
730     function _burn(address account, uint256 amount) internal virtual {
731         require(account != address(0), "ERC20: burn from the zero address");
732 
733         _beforeTokenTransfer(account, address(0), amount);
734 
735         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
736         _totalSupply = _totalSupply.sub(amount);
737         emit Transfer(account, address(0), amount);
738     }
739 
740     /**
741      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
742      *
743      * This internal function is equivalent to `approve`, and can be used to
744      * e.g. set automatic allowances for certain subsystems, etc.
745      *
746      * Emits an {Approval} event.
747      *
748      * Requirements:
749      *
750      * - `owner` cannot be the zero address.
751      * - `spender` cannot be the zero address.
752      */
753     function _approve(address owner, address spender, uint256 amount) internal virtual {
754         require(owner != address(0), "ERC20: approve from the zero address");
755         require(spender != address(0), "ERC20: approve to the zero address");
756 
757         _allowances[owner][spender] = amount;
758         emit Approval(owner, spender, amount);
759     }
760 
761     /**
762      * @dev Sets {decimals} to a value other than the default one of 18.
763      *
764      * WARNING: This function should only be called from the constructor. Most
765      * applications that interact with token contracts will not expect
766      * {decimals} to ever change, and may work incorrectly if it does.
767      */
768     function _setupDecimals(uint8 decimals_) internal {
769         _decimals = decimals_;
770     }
771 
772     /**
773      * @dev Hook that is called before any transfer of tokens. This includes
774      * minting and burning.
775      *
776      * Calling conditions:
777      *
778      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
779      * will be to transferred to `to`.
780      * - when `from` is zero, `amount` tokens will be minted for `to`.
781      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
782      * - `from` and `to` are never both zero.
783      *
784      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
785      */
786     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
787 }
788 
789 // File: contracts/TellorProxy.sol
790 
791 
792 interface ITellor {
793   function addTip(uint256 _requestId, uint256 _tip) external;
794   function submitMiningSolution(string calldata _nonce, uint256 _requestId, uint256 _value) external;
795   function submitMiningSolution(string calldata _nonce,uint256[5] calldata _requestId, uint256[5] calldata _value) external;
796   function depositStake() external;
797   function requestStakingWithdraw() external;
798   function withdrawStake() external;
799   function vote(uint256 _disputeId, bool _supportsDispute) external;
800 }
801 
802 
803 contract TellorProxy is ChiGasSaver, Ownable, ERC20 {
804 
805   address tellorAddress;   // Address of Tellor Oracle
806   address gasToken;        // Gas token address to use for gas saver
807   uint256 stakedAt;        // Timestamp when the stake was deposited
808   uint256 unstakedAt;      // Timestamp when the stake was withdrawn
809   uint256 fee;             // Fee that stakers collect, where 100 is 1%
810   uint256 stakeAmount;     // The Tellor token staking amount
811   uint256 feesCollected;   // The fees collected for the stakers
812 
813   constructor(address _tellorAddress,
814     address _gasToken,
815     uint256 _fee,
816     uint256 _stakeAmount)
817     public
818     // NOTE: Change the token name and symbol for each staked miner
819     // Use the form: TPS-YYYYMM-D
820     // Where YYYY == year, MM == month, and D = duration (e.g. 1 month)
821     ERC20("Tellorpool Token", "TPS-202011")
822   {
823     tellorAddress = _tellorAddress;
824     gasToken = _gasToken;
825     fee = _fee;
826     stakeAmount = _stakeAmount * 1e18;
827     feesCollected = 0;
828   }
829 
830   // Enter the contract, get TPS for your TRB
831   function enter(uint256 _amount) public {
832     require(IERC20(tellorAddress).transferFrom(msg.sender, address(this), _amount));
833     _mint(msg.sender, _amount);
834     require(totalSupply() <= stakeAmount, "CAN NOT ACCEPT MORE THAN STAKE AMOUNT");
835   }
836 
837   // Leave the contract, get TRB for your TPS
838   function leave() public {
839     // Can only leave after the contract has been unstaked or before staking
840     require(unstakedAt != 0 || stakedAt == 0, "NOT UNSTAKED YET");
841     uint256 totalTRB = IERC20(tellorAddress).balanceOf(address(this));
842     uint256 totalShares = totalSupply();
843     uint256 theirShares = balanceOf(msg.sender);
844     uint256 theirTRB = totalTRB.mul(theirShares).div(totalShares);
845     _burn(msg.sender, theirShares);
846     require(IERC20(tellorAddress).transfer(msg.sender, theirTRB));
847   }
848 
849   // Close the contract, send remaining balance to owner
850   function close() external onlyOwner {
851     // Can only close after being unstaked for 90 days
852     // or after 365 days from staking (in case of dispute)
853     require((unstakedAt < now - 90 days && unstakedAt != 0) || (stakedAt < now - 365 days && stakedAt != 0), "CAN NOT CLOSE YET");
854     uint256 leftovers = IERC20(tellorAddress).balanceOf(address(this));
855     require(IERC20(tellorAddress).transfer(owner(), leftovers));
856   }
857 
858   // Withdraw rewards less fees
859   function withdrawRewards() external onlyOwner {
860     require(unstakedAt == 0, "NO WITHDRAWS AFTER UNSTAKING");
861     require(stakedAt != 0, "NO WITHDRAWS BEFORE STAKING");
862     uint256 surplus = IERC20(tellorAddress).balanceOf(address(this)) - stakeAmount;
863     uint256 available = surplus.mul(10000 - fee).div(10000);
864     feesCollected += surplus - available;
865     require(IERC20(tellorAddress).transfer(owner(), available));
866   }
867 
868   // Returns the TRB value of the token with 5 decimals of percision
869   function getTokenValue() external view returns (uint256) {
870     if (stakedAt != 0) {
871       return (stakeAmount + feesCollected).mul(100000).div(totalSupply());
872     } else {
873       return 100000;
874     }
875   }
876 
877   // Returns the fee as a percentage with 2 decimals of percision
878   function getFee() external view returns (uint256) {
879     return fee;
880   }
881 
882   // Withdraw for other tokens if not Tellor
883   function tokenWithdraw(address _tokenAddress, uint256 _amount)
884     external
885     onlyOwner
886   {
887     require(_tokenAddress != tellorAddress, "CAN NOT WITHDRAW TRB");
888     require(IERC20(_tokenAddress).transfer(owner(), _amount));
889   }
890 
891   function addTip(uint256 _requestId, uint256 _tip)
892     external
893     onlyOwner
894     saveGas(msg.sender, gasToken)
895   {
896     ITellor(tellorAddress).addTip(_requestId, _tip);
897   }
898 
899   function submitMiningSolutionSaveGas(string calldata _nonce, uint256 _requestId, uint256 _value)
900     external
901     onlyOwner
902     saveGas(msg.sender, gasToken)
903   {
904     ITellor(tellorAddress).submitMiningSolution(_nonce, _requestId, _value);
905   }
906 
907   function submitMiningSolutionSaveGas(string calldata _nonce, uint256[5] calldata _requestId, uint256[5] calldata _value)
908     external
909     onlyOwner
910     saveGas(msg.sender, gasToken)
911   {
912     ITellor(tellorAddress).submitMiningSolution(_nonce, _requestId, _value);
913   }
914 
915   function submitMiningSolution(string calldata _nonce, uint256 _requestId, uint256 _value)
916     external
917     onlyOwner
918   {
919     ITellor(tellorAddress).submitMiningSolution(_nonce, _requestId, _value);
920   }
921 
922   function submitMiningSolution(string calldata _nonce, uint256[5] calldata _requestId, uint256[5] calldata _value)
923     external
924     onlyOwner
925   {
926     ITellor(tellorAddress).submitMiningSolution(_nonce, _requestId, _value);
927   }
928 
929   function depositStake()
930     external
931     onlyOwner
932   {
933     stakedAt = now;
934     ITellor(tellorAddress).depositStake();
935   }
936 
937   function requestStakingWithdraw()
938     external
939     onlyOwner
940   {
941     ITellor(tellorAddress).requestStakingWithdraw();
942   }
943 
944   function withdrawStake()
945     external
946     onlyOwner
947   {
948     unstakedAt = now;
949     ITellor(tellorAddress).withdrawStake();
950   }
951 
952   function vote(uint256 _disputeId, bool _supportsDispute)
953     external
954     onlyOwner
955   {
956     ITellor(tellorAddress).vote(_disputeId, _supportsDispute);
957   }
958 
959 }