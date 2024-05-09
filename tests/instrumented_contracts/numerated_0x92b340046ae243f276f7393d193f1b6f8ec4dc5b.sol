1 pragma solidity ^0.6.0;
2 
3 /*
4  * @dev Provides information about the current execution context, including the
5  * sender of the transaction and its data. While these are generally available
6  * via msg.sender and msg.data, they should not be accessed in such a direct
7  * manner, since when dealing with GSN meta-transactions the account sending and
8  * paying for execution may not be the actual sender (as far as an application
9  * is concerned).
10  *
11  * This contract is only required for intermediate, library-like contracts.
12  */
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
20         return msg.data;
21     }
22 }
23 
24 
25 // Partial License: MIT
26 
27 pragma solidity ^0.6.0;
28 
29 /**
30  * @dev Contract module which provides a basic access control mechanism, where
31  * there is an account (an owner) that can be granted exclusive access to
32  * specific functions.
33  *
34  * By default, the owner account will be the one that deploys the contract. This
35  * can later be changed with {transferOwnership}.
36  *
37  * This module is used through inheritance. It will make available the modifier
38  * `onlyOwner`, which can be applied to your functions to restrict their use to
39  * the owner.
40  */
41 contract Ownable is Context {
42     
43     address private _owner;
44     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
45 
46     /**
47      * @dev Initializes the contract setting the deployer as the initial owner.
48      */
49     constructor () internal {
50         address msgSender = _msgSender();
51         _owner = msgSender;
52         emit OwnershipTransferred(address(0), msgSender);
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(_owner == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         emit OwnershipTransferred(_owner, address(0));
79         _owner = address(0);
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Can only be called by the current owner.
85      */
86     function transferOwnership(address newOwner) public virtual onlyOwner {
87         require(newOwner != address(0), "Ownable: new owner is the zero address");
88         emit OwnershipTransferred(_owner, newOwner);
89         _owner = newOwner;
90     }
91 }
92 
93 // Partial License: MIT
94 
95 pragma solidity ^0.6.0;
96 
97 /**
98  * @dev Interface of the ERC20 standard as defined in the EIP.
99  */
100  
101 interface IERC20 {
102     /**
103      * @dev Returns the amount of tokens in existence.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     /**
108      * @dev Returns the amount of tokens owned by `account`.
109      */
110     function balanceOf(address account) external view returns (uint256);
111 
112     /**
113      * @dev Moves `amount` tokens from the caller's account to `recipient`.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transfer(address recipient, uint256 amount) external returns (bool);
120 
121     /**
122      * @dev Returns the remaining number of tokens that `spender` will be
123      * allowed to spend on behalf of `owner` through {transferFrom}. This is
124      * zero by default.
125      *
126      * This value changes when {approve} or {transferFrom} are called.
127      */
128     function allowance(address owner, address spender) external view returns (uint256);
129 
130     /**
131      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * IMPORTANT: Beware that changing an allowance with this method brings the risk
136      * that someone may use both the old and the new allowance by unfortunate
137      * transaction ordering. One possible solution to mitigate this race
138      * condition is to first reduce the spender's allowance to 0 and set the
139      * desired value afterwards:
140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address spender, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Moves `amount` tokens from `sender` to `recipient` using the
148      * allowance mechanism. `amount` is then deducted from the caller's
149      * allowance.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Emitted when `value` tokens are moved from one account (`from`) to
159      * another (`to`).
160      *
161      * Note that `value` may be zero.
162      */
163     event Transfer(address indexed from, address indexed to, uint256 value);
164 
165     /**
166      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
167      * a call to {approve}. `value` is the new allowance.
168      */
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171 
172 
173 // Partial License: MIT
174 
175 pragma solidity ^0.6.0;
176 
177 /**
178  * @dev Wrappers over Solidity's arithmetic operations with added overflow
179  * checks.
180  *
181  * Arithmetic operations in Solidity wrap on overflow. This can easily result
182  * in bugs, because programmers usually assume that an overflow raises an
183  * error, which is the standard behavior in high level programming languages.
184  * `SafeMath` restores this intuition by reverting the transaction when an
185  * operation overflows.
186  *
187  * Using this library instead of the unchecked operations eliminates an entire
188  * class of bugs, so it's recommended to use it always.
189  */
190 library SafeMath {
191     /**
192      * @dev Returns the addition of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `+` operator.
196      *
197      * Requirements:
198      *
199      * - Addition cannot overflow.
200      */
201     function add(uint256 a, uint256 b) internal pure returns (uint256) {
202         uint256 c = a + b;
203         require(c >= a, "SafeMath: addition overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the subtraction of two unsigned integers, reverting on
210      * overflow (when the result is negative).
211      *
212      * Counterpart to Solidity's `-` operator.
213      *
214      * Requirements:
215      *
216      * - Subtraction cannot overflow.
217      */
218     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
219         return sub(a, b, "SafeMath: subtraction overflow");
220     }
221 
222     /**
223      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
224      * overflow (when the result is negative).
225      *
226      * Counterpart to Solidity's `-` operator.
227      *
228      * Requirements:
229      *
230      * - Subtraction cannot overflow.
231      */
232     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b <= a, errorMessage);
234         uint256 c = a - b;
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the multiplication of two unsigned integers, reverting on
241      * overflow.
242      *
243      * Counterpart to Solidity's `*` operator.
244      *
245      * Requirements:
246      *
247      * - Multiplication cannot overflow.
248      */
249     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
250         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
251         // benefit is lost if 'b' is also tested.
252         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
253         if (a == 0) {
254             return 0;
255         }
256 
257         uint256 c = a * b;
258         require(c / a == b, "SafeMath: multiplication overflow");
259 
260         return c;
261     }
262 
263     /**
264      * @dev Returns the integer division of two unsigned integers. Reverts on
265      * division by zero. The result is rounded towards zero.
266      *
267      * Counterpart to Solidity's `/` operator. Note: this function uses a
268      * `revert` opcode (which leaves remaining gas untouched) while Solidity
269      * uses an invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function div(uint256 a, uint256 b) internal pure returns (uint256) {
276         return div(a, b, "SafeMath: division by zero");
277     }
278 
279     /**
280      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
291     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
292         require(b > 0, errorMessage);
293         uint256 c = a / b;
294         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
295 
296         return c;
297     }
298 
299     /**
300      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
301      * Reverts when dividing by zero.
302      *
303      * Counterpart to Solidity's `%` operator. This function uses a `revert`
304      * opcode (which leaves remaining gas untouched) while Solidity uses an
305      * invalid opcode to revert (consuming all remaining gas).
306      *
307      * Requirements:
308      *
309      * - The divisor cannot be zero.
310      */
311     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
312         return mod(a, b, "SafeMath: modulo by zero");
313     }
314 
315     /**
316      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
317      * Reverts with custom message when dividing by zero.
318      *
319      * Counterpart to Solidity's `%` operator. This function uses a `revert`
320      * opcode (which leaves remaining gas untouched) while Solidity uses an
321      * invalid opcode to revert (consuming all remaining gas).
322      *
323      * Requirements:
324      *
325      * - The divisor cannot be zero.
326      */
327     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
328         require(b != 0, errorMessage);
329         return a % b;
330     }
331 }
332 
333 
334 // Partial License: MIT
335 
336 pragma solidity ^0.6.2;
337 
338 /**
339  * @dev Collection of functions related to the address type
340  */
341 library Address {
342     /**
343      * @dev Returns true if `account` is a contract.
344      *
345      * [IMPORTANT]
346      * ====
347      * It is unsafe to assume that an address for which this function returns
348      * false is an externally-owned account (EOA) and not a contract.
349      *
350      * Among others, `isContract` will return false for the following
351      * types of addresses:
352      *
353      *  - an externally-owned account
354      *  - a contract in construction
355      *  - an address where a contract will be created
356      *  - an address where a contract lived, but was destroyed
357      * ====
358      */
359     function isContract(address account) internal view returns (bool) {
360         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
361         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
362         // for accounts without code, i.e. `keccak256('')`
363         bytes32 codehash;
364         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
365         // solhint-disable-next-line no-inline-assembly
366         assembly { codehash := extcodehash(account) }
367         return (codehash != accountHash && codehash != 0x0);
368     }
369 
370     /**
371      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
372      * `recipient`, forwarding all available gas and reverting on errors.
373      *
374      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
375      * of certain opcodes, possibly making contracts go over the 2300 gas limit
376      * imposed by `transfer`, making them unable to receive funds via
377      * `transfer`. {sendValue} removes this limitation.
378      *
379      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
380      *
381      * IMPORTANT: because control is transferred to `recipient`, care must be
382      * taken to not create reentrancy vulnerabilities. Consider using
383      * {ReentrancyGuard} or the
384      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
385      */
386     function sendValue(address payable recipient, uint256 amount) internal {
387         require(address(this).balance >= amount, "Address: insufficient balance");
388 
389         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
390         (bool success, ) = recipient.call{ value: amount }("");
391         require(success, "Address: unable to send value, recipient may have reverted");
392     }
393 
394     /**
395      * @dev Performs a Solidity function call using a low level `call`. A
396      * plain`call` is an unsafe replacement for a function call: use this
397      * function instead.
398      *
399      * If `target` reverts with a revert reason, it is bubbled up by this
400      * function (like regular Solidity function calls).
401      *
402      * Returns the raw returned data. To convert to the expected return value,
403      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
404      *
405      * Requirements:
406      *
407      * - `target` must be a contract.
408      * - calling `target` with `data` must not revert.
409      *
410      * _Available since v3.1._
411      */
412     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
413       return functionCall(target, data, "Address: low-level call failed");
414     }
415 
416     /**
417      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
418      * `errorMessage` as a fallback revert reason when `target` reverts.
419      *
420      * _Available since v3.1._
421      */
422     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
423         return _functionCallWithValue(target, data, 0, errorMessage);
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
428      * but also transferring `value` wei to `target`.
429      *
430      * Requirements:
431      *
432      * - the calling contract must have an ETH balance of at least `value`.
433      * - the called Solidity function must be `payable`.
434      *
435      * _Available since v3.1._
436      */
437     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
438         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
439     }
440 
441     /**
442      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
443      * with `errorMessage` as a fallback revert reason when `target` reverts.
444      *
445      * _Available since v3.1._
446      */
447     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
448         require(address(this).balance >= value, "Address: insufficient balance for call");
449         return _functionCallWithValue(target, data, value, errorMessage);
450     }
451 
452     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
453         require(isContract(target), "Address: call to non-contract");
454 
455         // solhint-disable-next-line avoid-low-level-calls
456         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
457         if (success) {
458             return returndata;
459         } else {
460             // Look for revert reason and bubble it up if present
461             if (returndata.length > 0) {
462                 // The easiest way to bubble the revert reason is using memory via assembly
463 
464                 // solhint-disable-next-line no-inline-assembly
465                 assembly {
466                     let returndata_size := mload(returndata)
467                     revert(add(32, returndata), returndata_size)
468                 }
469             } else {
470                 revert(errorMessage);
471             }
472         }
473     }
474 }
475 
476 
477 // Partial License: MIT
478 
479 pragma solidity ^0.6.0;
480 
481 /**
482  * @dev Implementation of the {IERC20} interface.
483  *
484  * This implementation is agnostic to the way tokens are created. This means
485  * that a supply mechanism has to be added in a derived contract using {_mint}.
486  * For a generic mechanism see {ERC20PresetMinterPauser}.
487  *
488  * TIP: For a detailed writeup see our guide
489  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
490  * to implement supply mechanisms].
491  *
492  * We have followed general OpenZeppelin guidelines: functions revert instead
493  * of returning `false` on failure. This behavior is nonetheless conventional
494  * and does not conflict with the expectations of ERC20 applications.
495  *
496  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
497  * This allows applications to reconstruct the allowance for all accounts just
498  * by listening to said events. Other implementations of the EIP may not emit
499  * these events, as it isn't required by the specification.
500  *
501  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
502  * functions have been added to mitigate the well-known issues around setting
503  * allowances. See {IERC20-approve}.
504  */
505 contract ERC20 is Context, IERC20 {
506     using SafeMath for uint256;
507     using Address for address;
508 
509     mapping (address => uint256) private _balances;
510 
511     mapping (address => mapping (address => uint256)) private _allowances;
512 
513     uint256 private _totalSupply;
514     uint256 public _minimumSupply = 5000000000000000000000;
515     uint256 public BURN_RATE = 2;
516     uint256 constant public PERCENTS_DIVIDER = 100;
517 
518     string private _name;
519     string private _symbol;
520     uint8 private _decimals;
521 
522     /**
523      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
524      * a default value of 18.
525      *
526      * To select a different value for {decimals}, use {_setupDecimals}.
527      *
528      * All three of these values are immutable: they can only be set once during
529      * construction.
530      */
531     constructor (string memory name, string memory symbol) public {
532         _name = name;
533         _symbol = symbol;
534         _decimals = 18;
535     }
536 
537     /**
538      * @dev Returns the name of the token.
539      */
540     function name() public view returns (string memory) {
541         return _name;
542     }
543 
544     /**
545      * @dev Returns the symbol of the token, usually a shorter version of the
546      * name.
547      */
548     function symbol() public view returns (string memory) {
549         return _symbol;
550     }
551 
552     /**
553      * @dev Returns the number of decimals used to get its user representation.
554      * For example, if `decimals` equals `2`, a balance of `505` tokens should
555      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
556      *
557      * Tokens usually opt for a value of 18, imitating the relationship between
558      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
559      * called.
560      *
561      * NOTE: This information is only used for _display_ purposes: it in
562      * no way affects any of the arithmetic of the contract, including
563      * {IERC20-balanceOf} and {IERC20-transfer}.
564      */
565     function decimals() public view returns (uint8) {
566         return _decimals;
567     }
568 
569     /**
570      * @dev See {IERC20-totalSupply}.
571      */
572     function totalSupply() public view override returns (uint256) {
573         return _totalSupply;
574     }
575     
576     /**
577      * @dev See {IERC20-minimumSupply}.
578      */
579     function minimumSupply() public view returns (uint256) {
580         return _minimumSupply;
581     }
582 
583     /**
584      * @dev See {IERC20-balanceOf}.
585      */
586     function balanceOf(address account) public view override returns (uint256) {
587         return _balances[account];
588     }
589 
590     /**
591      * @dev See {IERC20-transfer}.
592      *
593      * Requirements:
594      *
595      * - `recipient` cannot be the zero address.
596      * - the caller must have a balance of at least `amount`.
597      */
598     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
599         _transfer(_msgSender(), recipient, amount);
600         return true;
601     }
602 
603     /**
604      * @dev See {IERC20-allowance}.
605      */
606     function allowance(address owner, address spender) public view virtual override returns (uint256) {
607         return _allowances[owner][spender];
608     }
609 
610     /**
611      * @dev See {IERC20-approve}.
612      *
613      * Requirements:
614      *
615      * - `spender` cannot be the zero address.
616      */
617     function approve(address spender, uint256 amount) public virtual override returns (bool) {
618         _approve(_msgSender(), spender, amount);
619         return true;
620     }
621 
622     /**
623      * @dev See {IERC20-transferFrom}.
624      *
625      * Emits an {Approval} event indicating the updated allowance. This is not
626      * required by the EIP. See the note at the beginning of {ERC20};
627      *
628      * Requirements:
629      * - `sender` and `recipient` cannot be the zero address.
630      * - `sender` must have a balance of at least `amount`.
631      * - the caller must have allowance for ``sender``'s tokens of at least
632      * `amount`.
633      */
634     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
635         _transfer(sender, recipient, amount);
636         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
637         return true;
638     }
639 
640     /**
641      * @dev Atomically increases the allowance granted to `spender` by the caller.
642      *
643      * This is an alternative to {approve} that can be used as a mitigation for
644      * problems described in {IERC20-approve}.
645      *
646      * Emits an {Approval} event indicating the updated allowance.
647      *
648      * Requirements:
649      *
650      * - `spender` cannot be the zero address.
651      */
652     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
653         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
654         return true;
655     }
656 
657     /**
658      * @dev Atomically decreases the allowance granted to `spender` by the caller.
659      *
660      * This is an alternative to {approve} that can be used as a mitigation for
661      * problems described in {IERC20-approve}.
662      *
663      * Emits an {Approval} event indicating the updated allowance.
664      *
665      * Requirements:
666      *
667      * - `spender` cannot be the zero address.
668      * - `spender` must have allowance for the caller of at least
669      * `subtractedValue`.
670      */
671     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
672         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
673         return true;
674     }
675 
676     /**
677      * @dev Moves tokens `amount` from `sender` to `recipient`.
678      *
679      * This is internal function is equivalent to {transfer}, and can be used to
680      * e.g. implement automatic token fees, slashing mechanisms, etc.
681      *
682      * Emits a {Transfer} event.
683      *
684      * Requirements:
685      *
686      * - `sender` cannot be the zero address.
687      * - `recipient` cannot be the zero address.
688      * - `sender` must have a balance of at least `amount`.
689      */
690     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
691         require(sender != address(0), "ERC20: transfer from the zero address");
692         require(recipient != address(0), "ERC20: transfer to the zero address");
693 
694         _beforeTokenTransfer(sender, recipient, amount);
695 
696         uint256 remainingAmount = amount;
697         if(_totalSupply > _minimumSupply) {
698             if(BURN_RATE > 0) {
699                 uint256 burnAmount = amount.mul(BURN_RATE).div(PERCENTS_DIVIDER);
700                 _burn(sender, burnAmount);
701                 remainingAmount = remainingAmount.sub(burnAmount);
702             }
703         }
704         _balances[sender] = _balances[sender].sub(remainingAmount, "ERC20: transfer amount exceeds balance");
705         _balances[recipient] = _balances[recipient].add(remainingAmount);
706         emit Transfer(sender, recipient, remainingAmount);
707     }
708 
709     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
710      * the total supply.
711      *
712      * Emits a {Transfer} event with `from` set to the zero address.
713      *
714      * Requirements
715      *
716      * - `to` cannot be the zero address.
717      */
718     function _mint(address account, uint256 amount) internal virtual {
719         require(account != address(0), "ERC20: mint to the zero address");
720 
721         _beforeTokenTransfer(address(0), account, amount);
722 
723         _totalSupply = _totalSupply.add(amount);
724         _balances[account] = _balances[account].add(amount);
725         emit Transfer(address(0), account, amount);
726     }
727 
728     /**
729      * @dev Destroys `amount` tokens from `account`, reducing the
730      * total supply.
731      *
732      * Emits a {Transfer} event with `to` set to the zero address.
733      *
734      * Requirements
735      *
736      * - `account` cannot be the zero address.
737      * - `account` must have at least `amount` tokens.
738      */
739     function _burn(address account, uint256 amount) internal virtual {
740         require(account != address(0), "ERC20: burn from the zero address");
741 
742         _beforeTokenTransfer(account, address(0), amount);
743 
744         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
745         _totalSupply = _totalSupply.sub(amount);
746         emit Transfer(account, address(0), amount);
747     }
748 
749     /**
750      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
751      *
752      * This is internal function is equivalent to `approve`, and can be used to
753      * e.g. set automatic allowances for certain subsystems, etc.
754      *
755      * Emits an {Approval} event.
756      *
757      * Requirements:
758      *
759      * - `owner` cannot be the zero address.
760      * - `spender` cannot be the zero address.
761      */
762     function _approve(address owner, address spender, uint256 amount) internal virtual {
763         require(owner != address(0), "ERC20: approve from the zero address");
764         require(spender != address(0), "ERC20: approve to the zero address");
765 
766         _allowances[owner][spender] = amount;
767         emit Approval(owner, spender, amount);
768     }
769 
770     /**
771      * @dev Sets {decimals} to a value other than the default one of 18.
772      *
773      * WARNING: This function should only be called from the constructor. Most
774      * applications that interact with token contracts will not expect
775      * {decimals} to ever change, and may work incorrectly if it does.
776      */
777     function _setupDecimals(uint8 decimals_) internal {
778         _decimals = decimals_;
779     }
780 
781     /**
782      * @dev Hook that is called before any transfer of tokens. This includes
783      * minting and burning.
784      *
785      * Calling conditions:
786      *
787      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
788      * will be to transferred to `to`.
789      * - when `from` is zero, `amount` tokens will be minted for `to`.
790      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
791      * - `from` and `to` are never both zero.
792      *
793      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
794      */
795     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
796 }
797 
798 
799 // Partial License: MIT
800 
801 pragma solidity ^0.6.0;
802 
803 /**
804  * @dev Extension of {ERC20} that allows token holders to destroy both their own
805  * tokens and those that they have an allowance for, in a way that can be
806  * recognized off-chain (via event analysis).
807  */
808 abstract contract ERC20Burnable is Context, ERC20 {
809     /**
810      * @dev Destroys `amount` tokens from the caller.
811      *
812      * See {ERC20-_burn}.
813      */
814     function burn(uint256 amount) public virtual {
815         _burn(_msgSender(), amount);
816     }
817 
818     /**
819      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
820      * allowance.
821      *
822      * See {ERC20-_burn} and {ERC20-allowance}.
823      *
824      * Requirements:
825      *
826      * - the caller must have allowance for ``accounts``'s tokens of at least
827      * `amount`.
828      */
829     function burnFrom(address account, uint256 amount) public virtual {
830         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
831 
832         _approve(account, _msgSender(), decreasedAllowance);
833         _burn(account, amount);
834     }
835 }
836 
837 
838 // Partial License: MIT
839 
840 pragma solidity ^0.6.0;
841 
842 /**
843  * @dev Library for managing
844  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
845  * types.
846  *
847  * Sets have the following properties:
848  *
849  * - Elements are added, removed, and checked for existence in constant time
850  * (O(1)).
851  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
852  *
853  * ```
854  * contract Example {
855  *     // Add the library methods
856  *     using EnumerableSet for EnumerableSet.AddressSet;
857  *
858  *     // Declare a set state variable
859  *     EnumerableSet.AddressSet private mySet;
860  * }
861  * ```
862  *
863  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
864  * (`UintSet`) are supported.
865  */
866 library EnumerableSet {
867     // To implement this library for multiple types with as little code
868     // repetition as possible, we write it in terms of a generic Set type with
869     // bytes32 values.
870     // The Set implementation uses private functions, and user-facing
871     // implementations (such as AddressSet) are just wrappers around the
872     // underlying Set.
873     // This means that we can only create new EnumerableSets for types that fit
874     // in bytes32.
875 
876     struct Set {
877         // Storage of set values
878         bytes32[] _values;
879 
880         // Position of the value in the `values` array, plus 1 because index 0
881         // means a value is not in the set.
882         mapping (bytes32 => uint256) _indexes;
883     }
884 
885     /**
886      * @dev Add a value to a set. O(1).
887      *
888      * Returns true if the value was added to the set, that is if it was not
889      * already present.
890      */
891     function _add(Set storage set, bytes32 value) private returns (bool) {
892         if (!_contains(set, value)) {
893             set._values.push(value);
894             // The value is stored at length-1, but we add 1 to all indexes
895             // and use 0 as a sentinel value
896             set._indexes[value] = set._values.length;
897             return true;
898         } else {
899             return false;
900         }
901     }
902 
903     /**
904      * @dev Removes a value from a set. O(1).
905      *
906      * Returns true if the value was removed from the set, that is if it was
907      * present.
908      */
909     function _remove(Set storage set, bytes32 value) private returns (bool) {
910         // We read and store the value's index to prevent multiple reads from the same storage slot
911         uint256 valueIndex = set._indexes[value];
912 
913         if (valueIndex != 0) { // Equivalent to contains(set, value)
914             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
915             // the array, and then remove the last element (sometimes called as 'swap and pop').
916             // This modifies the order of the array, as noted in {at}.
917 
918             uint256 toDeleteIndex = valueIndex - 1;
919             uint256 lastIndex = set._values.length - 1;
920 
921             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
922             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
923 
924             bytes32 lastvalue = set._values[lastIndex];
925 
926             // Move the last value to the index where the value to delete is
927             set._values[toDeleteIndex] = lastvalue;
928             // Update the index for the moved value
929             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
930 
931             // Delete the slot where the moved value was stored
932             set._values.pop();
933 
934             // Delete the index for the deleted slot
935             delete set._indexes[value];
936 
937             return true;
938         } else {
939             return false;
940         }
941     }
942 
943     /**
944      * @dev Returns true if the value is in the set. O(1).
945      */
946     function _contains(Set storage set, bytes32 value) private view returns (bool) {
947         return set._indexes[value] != 0;
948     }
949 
950     /**
951      * @dev Returns the number of values on the set. O(1).
952      */
953     function _length(Set storage set) private view returns (uint256) {
954         return set._values.length;
955     }
956 
957    /**
958     * @dev Returns the value stored at position `index` in the set. O(1).
959     *
960     * Note that there are no guarantees on the ordering of values inside the
961     * array, and it may change when more values are added or removed.
962     *
963     * Requirements:
964     *
965     * - `index` must be strictly less than {length}.
966     */
967     function _at(Set storage set, uint256 index) private view returns (bytes32) {
968         require(set._values.length > index, "EnumerableSet: index out of bounds");
969         return set._values[index];
970     }
971 
972     // AddressSet
973 
974     struct AddressSet {
975         Set _inner;
976     }
977 
978     /**
979      * @dev Add a value to a set. O(1).
980      *
981      * Returns true if the value was added to the set, that is if it was not
982      * already present.
983      */
984     function add(AddressSet storage set, address value) internal returns (bool) {
985         return _add(set._inner, bytes32(uint256(value)));
986     }
987 
988     /**
989      * @dev Removes a value from a set. O(1).
990      *
991      * Returns true if the value was removed from the set, that is if it was
992      * present.
993      */
994     function remove(AddressSet storage set, address value) internal returns (bool) {
995         return _remove(set._inner, bytes32(uint256(value)));
996     }
997 
998     /**
999      * @dev Returns true if the value is in the set. O(1).
1000      */
1001     function contains(AddressSet storage set, address value) internal view returns (bool) {
1002         return _contains(set._inner, bytes32(uint256(value)));
1003     }
1004 
1005     /**
1006      * @dev Returns the number of values in the set. O(1).
1007      */
1008     function length(AddressSet storage set) internal view returns (uint256) {
1009         return _length(set._inner);
1010     }
1011 
1012    /**
1013     * @dev Returns the value stored at position `index` in the set. O(1).
1014     *
1015     * Note that there are no guarantees on the ordering of values inside the
1016     * array, and it may change when more values are added or removed.
1017     *
1018     * Requirements:
1019     *
1020     * - `index` must be strictly less than {length}.
1021     */
1022     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1023         return address(uint256(_at(set._inner, index)));
1024     }
1025 
1026 
1027     // UintSet
1028 
1029     struct UintSet {
1030         Set _inner;
1031     }
1032 
1033     /**
1034      * @dev Add a value to a set. O(1).
1035      *
1036      * Returns true if the value was added to the set, that is if it was not
1037      * already present.
1038      */
1039     function add(UintSet storage set, uint256 value) internal returns (bool) {
1040         return _add(set._inner, bytes32(value));
1041     }
1042 
1043     /**
1044      * @dev Removes a value from a set. O(1).
1045      *
1046      * Returns true if the value was removed from the set, that is if it was
1047      * present.
1048      */
1049     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1050         return _remove(set._inner, bytes32(value));
1051     }
1052 
1053     /**
1054      * @dev Returns true if the value is in the set. O(1).
1055      */
1056     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1057         return _contains(set._inner, bytes32(value));
1058     }
1059 
1060     /**
1061      * @dev Returns the number of values on the set. O(1).
1062      */
1063     function length(UintSet storage set) internal view returns (uint256) {
1064         return _length(set._inner);
1065     }
1066 
1067     /**
1068     * @dev Returns the value stored at position `index` in the set. O(1).
1069     *
1070     * Note that there are no guarantees on the ordering of values inside the
1071     * array, and it may change when more values are added or removed.
1072     *
1073     * Requirements:
1074     *
1075     * - `index` must be strictly less than {length}.
1076     */
1077     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1078         return uint256(_at(set._inner, index));
1079     }
1080 }
1081 
1082 
1083 // Partial License: MIT
1084 
1085 pragma solidity ^0.6.0;
1086 
1087 /**
1088  * @dev Contract module that allows children to implement role-based access
1089  * control mechanisms.
1090  *
1091  * Roles are referred to by their `bytes32` identifier. These should be exposed
1092  * in the external API and be unique. The best way to achieve this is by
1093  * using `public constant` hash digests:
1094  *
1095  * ```
1096  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1097  * ```
1098  *
1099  * Roles can be used to represent a set of permissions. To restrict access to a
1100  * function call, use {hasRole}:
1101  *
1102  * ```
1103  * function foo() public {
1104  *     require(hasRole(MY_ROLE, msg.sender));
1105  *     ...
1106  * }
1107  * ```
1108  *
1109  * Roles can be granted and revoked dynamically via the {grantRole} and
1110  * {revokeRole} functions. Each role has an associated admin role, and only
1111  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1112  *
1113  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1114  * that only accounts with this role will be able to grant or revoke other
1115  * roles. More complex role relationships can be created by using
1116  * {_setRoleAdmin}.
1117  *
1118  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1119  * grant and revoke this role. Extra precautions should be taken to secure
1120  * accounts that have been granted it.
1121  */
1122 abstract contract AccessControl is Context {
1123     using EnumerableSet for EnumerableSet.AddressSet;
1124     using Address for address;
1125 
1126     struct RoleData {
1127         EnumerableSet.AddressSet members;
1128         bytes32 adminRole;
1129     }
1130 
1131     mapping (bytes32 => RoleData) private _roles;
1132 
1133     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1134 
1135     /**
1136      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1137      *
1138      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1139      * {RoleAdminChanged} not being emitted signaling this.
1140      *
1141      * _Available since v3.1._
1142      */
1143     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1144 
1145     /**
1146      * @dev Emitted when `account` is granted `role`.
1147      *
1148      * `sender` is the account that originated the contract call, an admin role
1149      * bearer except when using {_setupRole}.
1150      */
1151     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1152 
1153     /**
1154      * @dev Emitted when `account` is revoked `role`.
1155      *
1156      * `sender` is the account that originated the contract call:
1157      *   - if using `revokeRole`, it is the admin role bearer
1158      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1159      */
1160     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1161 
1162     /**
1163      * @dev Returns `true` if `account` has been granted `role`.
1164      */
1165     function hasRole(bytes32 role, address account) public view returns (bool) {
1166         return _roles[role].members.contains(account);
1167     }
1168 
1169     /**
1170      * @dev Returns the number of accounts that have `role`. Can be used
1171      * together with {getRoleMember} to enumerate all bearers of a role.
1172      */
1173     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1174         return _roles[role].members.length();
1175     }
1176 
1177     /**
1178      * @dev Returns one of the accounts that have `role`. `index` must be a
1179      * value between 0 and {getRoleMemberCount}, non-inclusive.
1180      *
1181      * Role bearers are not sorted in any particular way, and their ordering may
1182      * change at any point.
1183      *
1184      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1185      * you perform all queries on the same block. See the following
1186      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1187      * for more information.
1188      */
1189     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1190         return _roles[role].members.at(index);
1191     }
1192 
1193     /**
1194      * @dev Returns the admin role that controls `role`. See {grantRole} and
1195      * {revokeRole}.
1196      *
1197      * To change a role's admin, use {_setRoleAdmin}.
1198      */
1199     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1200         return _roles[role].adminRole;
1201     }
1202 
1203     /**
1204      * @dev Grants `role` to `account`.
1205      *
1206      * If `account` had not been already granted `role`, emits a {RoleGranted}
1207      * event.
1208      *
1209      * Requirements:
1210      *
1211      * - the caller must have ``role``'s admin role.
1212      */
1213     function grantRole(bytes32 role, address account) public virtual {
1214         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1215 
1216         _grantRole(role, account);
1217     }
1218 
1219     /**
1220      * @dev Revokes `role` from `account`.
1221      *
1222      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1223      *
1224      * Requirements:
1225      *
1226      * - the caller must have ``role``'s admin role.
1227      */
1228     function revokeRole(bytes32 role, address account) public virtual {
1229         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1230 
1231         _revokeRole(role, account);
1232     }
1233 
1234     /**
1235      * @dev Revokes `role` from the calling account.
1236      *
1237      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1238      * purpose is to provide a mechanism for accounts to lose their privileges
1239      * if they are compromised (such as when a trusted device is misplaced).
1240      *
1241      * If the calling account had been granted `role`, emits a {RoleRevoked}
1242      * event.
1243      *
1244      * Requirements:
1245      *
1246      * - the caller must be `account`.
1247      */
1248     function renounceRole(bytes32 role, address account) public virtual {
1249         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1250 
1251         _revokeRole(role, account);
1252     }
1253 
1254     /**
1255      * @dev Grants `role` to `account`.
1256      *
1257      * If `account` had not been already granted `role`, emits a {RoleGranted}
1258      * event. Note that unlike {grantRole}, this function doesn't perform any
1259      * checks on the calling account.
1260      *
1261      * [WARNING]
1262      * ====
1263      * This function should only be called from the constructor when setting
1264      * up the initial roles for the system.
1265      *
1266      * Using this function in any other way is effectively circumventing the admin
1267      * system imposed by {AccessControl}.
1268      * ====
1269      */
1270     function _setupRole(bytes32 role, address account) internal virtual {
1271         _grantRole(role, account);
1272     }
1273 
1274     /**
1275      * @dev Sets `adminRole` as ``role``'s admin role.
1276      *
1277      * Emits a {RoleAdminChanged} event.
1278      */
1279     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1280         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1281         _roles[role].adminRole = adminRole;
1282     }
1283 
1284     function _grantRole(bytes32 role, address account) private {
1285         if (_roles[role].members.add(account)) {
1286             emit RoleGranted(role, account, _msgSender());
1287         }
1288     }
1289 
1290     function _revokeRole(bytes32 role, address account) private {
1291         if (_roles[role].members.remove(account)) {
1292             emit RoleRevoked(role, account, _msgSender());
1293         }
1294     }
1295 }
1296 
1297 
1298 // Partial License: MIT
1299 
1300 pragma solidity ^0.6.0;
1301 
1302 /**
1303  * @dev Standard math utilities missing in the Solidity language.
1304  */
1305 library Math {
1306     /**
1307      * @dev Returns the largest of two numbers.
1308      */
1309     function max(uint256 a, uint256 b) internal pure returns (uint256) {
1310         return a >= b ? a : b;
1311     }
1312 
1313     /**
1314      * @dev Returns the smallest of two numbers.
1315      */
1316     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1317         return a < b ? a : b;
1318     }
1319 
1320     /**
1321      * @dev Returns the average of two numbers. The result is rounded towards
1322      * zero.
1323      */
1324     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1325         // (a + b) / 2 can overflow, so we distribute
1326         return (a / 2) + (b / 2) + ((a % 2 + b % 2) / 2);
1327     }
1328 }
1329 
1330 
1331 // Partial License: MIT
1332 
1333 pragma solidity ^0.6.0;
1334 
1335 /**
1336  * @dev Collection of functions related to array types.
1337  */
1338 library Arrays {
1339    /**
1340      * @dev Searches a sorted `array` and returns the first index that contains
1341      * a value greater or equal to `element`. If no such index exists (i.e. all
1342      * values in the array are strictly less than `element`), the array length is
1343      * returned. Time complexity O(log n).
1344      *
1345      * `array` is expected to be sorted in ascending order, and to contain no
1346      * repeated elements.
1347      */
1348     function findUpperBound(uint256[] storage array, uint256 element) internal view returns (uint256) {
1349         if (array.length == 0) {
1350             return 0;
1351         }
1352 
1353         uint256 low = 0;
1354         uint256 high = array.length;
1355 
1356         while (low < high) {
1357             uint256 mid = Math.average(low, high);
1358 
1359             // Note that mid will always be strictly less than high (i.e. it will be a valid array index)
1360             // because Math.average rounds down (it does integer division with truncation).
1361             if (array[mid] > element) {
1362                 high = mid;
1363             } else {
1364                 low = mid + 1;
1365             }
1366         }
1367 
1368         // At this point `low` is the exclusive upper bound. We will return the inclusive upper bound.
1369         if (low > 0 && array[low - 1] == element) {
1370             return low - 1;
1371         } else {
1372             return low;
1373         }
1374     }
1375 }
1376 
1377 
1378 // Partial License: MIT
1379 
1380 pragma solidity ^0.6.0;
1381 
1382 /**
1383  * @title Counters
1384  * @author Matt Condon (@shrugs)
1385  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
1386  * of elements in a mapping, issuing ERC721 ids, or counting request ids.
1387  *
1388  * Include with `using Counters for Counters.Counter;`
1389  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the {SafeMath}
1390  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
1391  * directly accessed.
1392  */
1393 library Counters {
1394     using SafeMath for uint256;
1395 
1396     struct Counter {
1397         // This variable should never be directly accessed by users of the library: interactions must be restricted to
1398         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
1399         // this feature: see https://github.com/ethereum/solidity/issues/4637
1400         uint256 _value; // default: 0
1401     }
1402 
1403     function current(Counter storage counter) internal view returns (uint256) {
1404         return counter._value;
1405     }
1406 
1407     function increment(Counter storage counter) internal {
1408         // The {SafeMath} overflow check can be skipped here, see the comment at the top
1409         counter._value += 1;
1410     }
1411 
1412     function decrement(Counter storage counter) internal {
1413         counter._value = counter._value.sub(1);
1414     }
1415 }
1416 
1417 
1418 // Partial License: MIT
1419 
1420 pragma solidity ^0.6.0;
1421 
1422 /**
1423  * @dev This contract extends an ERC20 token with a snapshot mechanism. When a snapshot is created, the balances and
1424  * total supply at the time are recorded for later access.
1425  *
1426  * This can be used to safely create mechanisms based on token balances such as trustless dividends or weighted voting.
1427  * In naive implementations it's possible to perform a "double spend" attack by reusing the same balance from different
1428  * accounts. By using snapshots to calculate dividends or voting power, those attacks no longer apply. It can also be
1429  * used to create an efficient ERC20 forking mechanism.
1430  *
1431  * Snapshots are created by the internal {_snapshot} function, which will emit the {Snapshot} event and return a
1432  * snapshot id. To get the total supply at the time of a snapshot, call the function {totalSupplyAt} with the snapshot
1433  * id. To get the balance of an account at the time of a snapshot, call the {balanceOfAt} function with the snapshot id
1434  * and the account address.
1435  *
1436  * ==== Gas Costs
1437  *
1438  * Snapshots are efficient. Snapshot creation is _O(1)_. Retrieval of balances or total supply from a snapshot is _O(log
1439  * n)_ in the number of snapshots that have been created, although _n_ for a specific account will generally be much
1440  * smaller since identical balances in subsequent snapshots are stored as a single entry.
1441  *
1442  * There is a constant overhead for normal ERC20 transfers due to the additional snapshot bookkeeping. This overhead is
1443  * only significant for the first transfer that immediately follows a snapshot for a particular account. Subsequent
1444  * transfers will have normal cost until the next snapshot, and so on.
1445  */
1446 abstract contract ERC20Snapshot is ERC20 {
1447     // Inspired by Jordi Baylina's MiniMeToken to record historical balances:
1448     // https://github.com/Giveth/minimd/blob/ea04d950eea153a04c51fa510b068b9dded390cb/contracts/MiniMeToken.sol
1449 
1450     using SafeMath for uint256;
1451     using Arrays for uint256[];
1452     using Counters for Counters.Counter;
1453 
1454     // Snapshotted values have arrays of ids and the value corresponding to that id. These could be an array of a
1455     // Snapshot struct, but that would impede usage of functions that work on an array.
1456     struct Snapshots {
1457         uint256[] ids;
1458         uint256[] values;
1459     }
1460 
1461     mapping (address => Snapshots) private _accountBalanceSnapshots;
1462     Snapshots private _totalSupplySnapshots;
1463 
1464     // Snapshot ids increase monotonically, with the first value being 1. An id of 0 is invalid.
1465     Counters.Counter private _currentSnapshotId;
1466 
1467     /**
1468      * @dev Emitted by {_snapshot} when a snapshot identified by `id` is created.
1469      */
1470     event Snapshot(uint256 id);
1471 
1472     /**
1473      * @dev Creates a new snapshot and returns its snapshot id.
1474      *
1475      * Emits a {Snapshot} event that contains the same id.
1476      *
1477      * {_snapshot} is `internal` and you have to decide how to expose it externally. Its usage may be restricted to a
1478      * set of accounts, for example using {AccessControl}, or it may be open to the public.
1479      *
1480      * [WARNING]
1481      * ====
1482      * While an open way of calling {_snapshot} is required for certain trust minimization mechanisms such as forking,
1483      * you must consider that it can potentially be used by attackers in two ways.
1484      *
1485      * First, it can be used to increase the cost of retrieval of values from snapshots, although it will grow
1486      * logarithmically thus rendering this attack ineffective in the long term. Second, it can be used to target
1487      * specific accounts and increase the cost of ERC20 transfers for them, in the ways specified in the Gas Costs
1488      * section above.
1489      *
1490      * We haven't measured the actual numbers; if this is something you're interested in please reach out to us.
1491      * ====
1492      */
1493     function _snapshot() internal virtual returns (uint256) {
1494         _currentSnapshotId.increment();
1495 
1496         uint256 currentId = _currentSnapshotId.current();
1497         emit Snapshot(currentId);
1498         return currentId;
1499     }
1500 
1501     /**
1502      * @dev Retrieves the balance of `account` at the time `snapshotId` was created.
1503      */
1504     function balanceOfAt(address account, uint256 snapshotId) public view returns (uint256) {
1505         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _accountBalanceSnapshots[account]);
1506 
1507         return snapshotted ? value : balanceOf(account);
1508     }
1509 
1510     /**
1511      * @dev Retrieves the total supply at the time `snapshotId` was created.
1512      */
1513     function totalSupplyAt(uint256 snapshotId) public view returns(uint256) {
1514         (bool snapshotted, uint256 value) = _valueAt(snapshotId, _totalSupplySnapshots);
1515 
1516         return snapshotted ? value : totalSupply();
1517     }
1518 
1519     // _transfer, _mint and _burn are the only functions where the balances are modified, so it is there that the
1520     // snapshots are updated. Note that the update happens _before_ the balance change, with the pre-modified value.
1521     // The same is true for the total supply and _mint and _burn.
1522     function _transfer(address from, address to, uint256 value) internal virtual override {
1523         _updateAccountSnapshot(from);
1524         _updateAccountSnapshot(to);
1525 
1526         super._transfer(from, to, value);
1527     }
1528 
1529     function _mint(address account, uint256 value) internal virtual override {
1530         _updateAccountSnapshot(account);
1531         _updateTotalSupplySnapshot();
1532 
1533         super._mint(account, value);
1534     }
1535 
1536     function _burn(address account, uint256 value) internal virtual override {
1537         _updateAccountSnapshot(account);
1538         _updateTotalSupplySnapshot();
1539 
1540         super._burn(account, value);
1541     }
1542 
1543     function _valueAt(uint256 snapshotId, Snapshots storage snapshots)
1544         private view returns (bool, uint256)
1545     {
1546         require(snapshotId > 0, "ERC20Snapshot: id is 0");
1547         // solhint-disable-next-line max-line-length
1548         require(snapshotId <= _currentSnapshotId.current(), "ERC20Snapshot: nonexistent id");
1549 
1550         // When a valid snapshot is queried, there are three possibilities:
1551         //  a) The queried value was not modified after the snapshot was taken. Therefore, a snapshot entry was never
1552         //  created for this id, and all stored snapshot ids are smaller than the requested one. The value that corresponds
1553         //  to this id is the current one.
1554         //  b) The queried value was modified after the snapshot was taken. Therefore, there will be an entry with the
1555         //  requested id, and its value is the one to return.
1556         //  c) More snapshots were created after the requested one, and the queried value was later modified. There will be
1557         //  no entry for the requested id: the value that corresponds to it is that of the smallest snapshot id that is
1558         //  larger than the requested one.
1559         //
1560         // In summary, we need to find an element in an array, returning the index of the smallest value that is larger if
1561         // it is not found, unless said value doesn't exist (e.g. when all values are smaller). Arrays.findUpperBound does
1562         // exactly this.
1563 
1564         uint256 index = snapshots.ids.findUpperBound(snapshotId);
1565 
1566         if (index == snapshots.ids.length) {
1567             return (false, 0);
1568         } else {
1569             return (true, snapshots.values[index]);
1570         }
1571     }
1572 
1573     function _updateAccountSnapshot(address account) private {
1574         _updateSnapshot(_accountBalanceSnapshots[account], balanceOf(account));
1575     }
1576 
1577     function _updateTotalSupplySnapshot() private {
1578         _updateSnapshot(_totalSupplySnapshots, totalSupply());
1579     }
1580 
1581     function _updateSnapshot(Snapshots storage snapshots, uint256 currentValue) private {
1582         uint256 currentId = _currentSnapshotId.current();
1583         if (_lastSnapshotId(snapshots.ids) < currentId) {
1584             snapshots.ids.push(currentId);
1585             snapshots.values.push(currentValue);
1586         }
1587     }
1588 
1589     function _lastSnapshotId(uint256[] storage ids) private view returns (uint256) {
1590         if (ids.length == 0) {
1591             return 0;
1592         } else {
1593             return ids[ids.length - 1];
1594         }
1595     }
1596 }
1597 
1598 
1599 pragma solidity ^0.6.0;
1600 
1601 abstract contract CMERC20Snapshot is Context, AccessControl, ERC20Snapshot {
1602 
1603     bytes32 public constant SNAPSHOT_ROLE = keccak256("SNAPSHOT_ROLE");
1604     
1605     function snapshot() public {
1606         require(hasRole(SNAPSHOT_ROLE, _msgSender()), "ERC20Snapshot: must have snapshotter role to snapshot");
1607         _snapshot();
1608     }
1609 
1610 }
1611 
1612 
1613 pragma solidity ^0.6.0;
1614 
1615 // imports
1616 
1617 contract BOOMswap is ERC20Burnable, CMERC20Snapshot {
1618 
1619     constructor(string memory name, string memory symbol, uint256 amount, uint8 decimals) ERC20(name, symbol) public payable {
1620         _setupDecimals(decimals);
1621         _mint(msg.sender, amount);
1622         
1623         // set up required roles
1624         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1625         _setupRole(SNAPSHOT_ROLE, _msgSender());
1626     }
1627 
1628     
1629     // overrides
1630     function _burn(address account, uint256 value) internal override(ERC20, ERC20Snapshot) {
1631         super._burn(account, value);
1632     }
1633 
1634     function _mint(address account, uint256 value) internal override(ERC20, ERC20Snapshot) {
1635         super._mint(account, value);
1636     }
1637 
1638     function _transfer(address from, address to, uint256 value)internal override(ERC20, ERC20Snapshot) {
1639         super._transfer(from, to, value);
1640     }
1641 }