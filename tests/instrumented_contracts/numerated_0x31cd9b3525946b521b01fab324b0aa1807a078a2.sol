1 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
2 
3 // SPDX-License-Identifier: MIT
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
28 // File: @openzeppelin\contracts\access\Ownable.sol
29 
30 // SPDX-License-Identifier: MIT
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
99 
100 // SPDX-License-Identifier: MIT
101 
102 pragma solidity ^0.6.0;
103 
104 /**
105  * @dev Interface of the ERC20 standard as defined in the EIP.
106  */
107 interface IERC20 {
108     /**
109      * @dev Returns the amount of tokens in existence.
110      */
111     function totalSupply() external view returns (uint256);
112 
113     /**
114      * @dev Returns the amount of tokens owned by `account`.
115      */
116     function balanceOf(address account) external view returns (uint256);
117 
118     /**
119      * @dev Moves `amount` tokens from the caller's account to `recipient`.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transfer(address recipient, uint256 amount) external returns (bool);
126 
127     /**
128      * @dev Returns the remaining number of tokens that `spender` will be
129      * allowed to spend on behalf of `owner` through {transferFrom}. This is
130      * zero by default.
131      *
132      * This value changes when {approve} or {transferFrom} are called.
133      */
134     function allowance(address owner, address spender) external view returns (uint256);
135 
136     /**
137      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * IMPORTANT: Beware that changing an allowance with this method brings the risk
142      * that someone may use both the old and the new allowance by unfortunate
143      * transaction ordering. One possible solution to mitigate this race
144      * condition is to first reduce the spender's allowance to 0 and set the
145      * desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      *
148      * Emits an {Approval} event.
149      */
150     function approve(address spender, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Moves `amount` tokens from `sender` to `recipient` using the
154      * allowance mechanism. `amount` is then deducted from the caller's
155      * allowance.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Emitted when `value` tokens are moved from one account (`from`) to
165      * another (`to`).
166      *
167      * Note that `value` may be zero.
168      */
169     event Transfer(address indexed from, address indexed to, uint256 value);
170 
171     /**
172      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
173      * a call to {approve}. `value` is the new allowance.
174      */
175     event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
179 
180 // SPDX-License-Identifier: MIT
181 
182 pragma solidity ^0.6.0;
183 
184 /**
185  * @dev Wrappers over Solidity's arithmetic operations with added overflow
186  * checks.
187  *
188  * Arithmetic operations in Solidity wrap on overflow. This can easily result
189  * in bugs, because programmers usually assume that an overflow raises an
190  * error, which is the standard behavior in high level programming languages.
191  * `SafeMath` restores this intuition by reverting the transaction when an
192  * operation overflows.
193  *
194  * Using this library instead of the unchecked operations eliminates an entire
195  * class of bugs, so it's recommended to use it always.
196  */
197 library SafeMath {
198     /**
199      * @dev Returns the addition of two unsigned integers, reverting on
200      * overflow.
201      *
202      * Counterpart to Solidity's `+` operator.
203      *
204      * Requirements:
205      *
206      * - Addition cannot overflow.
207      */
208     function add(uint256 a, uint256 b) internal pure returns (uint256) {
209         uint256 c = a + b;
210         require(c >= a, "SafeMath: addition overflow");
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the subtraction of two unsigned integers, reverting on
217      * overflow (when the result is negative).
218      *
219      * Counterpart to Solidity's `-` operator.
220      *
221      * Requirements:
222      *
223      * - Subtraction cannot overflow.
224      */
225     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
226         return sub(a, b, "SafeMath: subtraction overflow");
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      *
237      * - Subtraction cannot overflow.
238      */
239     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b <= a, errorMessage);
241         uint256 c = a - b;
242 
243         return c;
244     }
245 
246     /**
247      * @dev Returns the multiplication of two unsigned integers, reverting on
248      * overflow.
249      *
250      * Counterpart to Solidity's `*` operator.
251      *
252      * Requirements:
253      *
254      * - Multiplication cannot overflow.
255      */
256     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
257         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
258         // benefit is lost if 'b' is also tested.
259         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
260         if (a == 0) {
261             return 0;
262         }
263 
264         uint256 c = a * b;
265         require(c / a == b, "SafeMath: multiplication overflow");
266 
267         return c;
268     }
269 
270     /**
271      * @dev Returns the integer division of two unsigned integers. Reverts on
272      * division by zero. The result is rounded towards zero.
273      *
274      * Counterpart to Solidity's `/` operator. Note: this function uses a
275      * `revert` opcode (which leaves remaining gas untouched) while Solidity
276      * uses an invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function div(uint256 a, uint256 b) internal pure returns (uint256) {
283         return div(a, b, "SafeMath: division by zero");
284     }
285 
286     /**
287      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
288      * division by zero. The result is rounded towards zero.
289      *
290      * Counterpart to Solidity's `/` operator. Note: this function uses a
291      * `revert` opcode (which leaves remaining gas untouched) while Solidity
292      * uses an invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
299         require(b > 0, errorMessage);
300         uint256 c = a / b;
301         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
302 
303         return c;
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * Reverts when dividing by zero.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
319         return mod(a, b, "SafeMath: modulo by zero");
320     }
321 
322     /**
323      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
324      * Reverts with custom message when dividing by zero.
325      *
326      * Counterpart to Solidity's `%` operator. This function uses a `revert`
327      * opcode (which leaves remaining gas untouched) while Solidity uses an
328      * invalid opcode to revert (consuming all remaining gas).
329      *
330      * Requirements:
331      *
332      * - The divisor cannot be zero.
333      */
334     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
335         require(b != 0, errorMessage);
336         return a % b;
337     }
338 }
339 
340 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
341 
342 // SPDX-License-Identifier: MIT
343 
344 pragma solidity ^0.6.2;
345 
346 /**
347  * @dev Collection of functions related to the address type
348  */
349 library Address {
350     /**
351      * @dev Returns true if `account` is a contract.
352      *
353      * [IMPORTANT]
354      * ====
355      * It is unsafe to assume that an address for which this function returns
356      * false is an externally-owned account (EOA) and not a contract.
357      *
358      * Among others, `isContract` will return false for the following
359      * types of addresses:
360      *
361      *  - an externally-owned account
362      *  - a contract in construction
363      *  - an address where a contract will be created
364      *  - an address where a contract lived, but was destroyed
365      * ====
366      */
367     function isContract(address account) internal view returns (bool) {
368         // This method relies in extcodesize, which returns 0 for contracts in
369         // construction, since the code is only stored at the end of the
370         // constructor execution.
371 
372         uint256 size;
373         // solhint-disable-next-line no-inline-assembly
374         assembly { size := extcodesize(account) }
375         return size > 0;
376     }
377 
378     /**
379      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
380      * `recipient`, forwarding all available gas and reverting on errors.
381      *
382      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
383      * of certain opcodes, possibly making contracts go over the 2300 gas limit
384      * imposed by `transfer`, making them unable to receive funds via
385      * `transfer`. {sendValue} removes this limitation.
386      *
387      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
388      *
389      * IMPORTANT: because control is transferred to `recipient`, care must be
390      * taken to not create reentrancy vulnerabilities. Consider using
391      * {ReentrancyGuard} or the
392      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
393      */
394     function sendValue(address payable recipient, uint256 amount) internal {
395         require(address(this).balance >= amount, "Address: insufficient balance");
396 
397         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
398         (bool success, ) = recipient.call{ value: amount }("");
399         require(success, "Address: unable to send value, recipient may have reverted");
400     }
401 
402     /**
403      * @dev Performs a Solidity function call using a low level `call`. A
404      * plain`call` is an unsafe replacement for a function call: use this
405      * function instead.
406      *
407      * If `target` reverts with a revert reason, it is bubbled up by this
408      * function (like regular Solidity function calls).
409      *
410      * Returns the raw returned data. To convert to the expected return value,
411      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
412      *
413      * Requirements:
414      *
415      * - `target` must be a contract.
416      * - calling `target` with `data` must not revert.
417      *
418      * _Available since v3.1._
419      */
420     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
421       return functionCall(target, data, "Address: low-level call failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
426      * `errorMessage` as a fallback revert reason when `target` reverts.
427      *
428      * _Available since v3.1._
429      */
430     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
431         return _functionCallWithValue(target, data, 0, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but also transferring `value` wei to `target`.
437      *
438      * Requirements:
439      *
440      * - the calling contract must have an ETH balance of at least `value`.
441      * - the called Solidity function must be `payable`.
442      *
443      * _Available since v3.1._
444      */
445     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
446         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
451      * with `errorMessage` as a fallback revert reason when `target` reverts.
452      *
453      * _Available since v3.1._
454      */
455     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
456         require(address(this).balance >= value, "Address: insufficient balance for call");
457         return _functionCallWithValue(target, data, value, errorMessage);
458     }
459 
460     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
461         require(isContract(target), "Address: call to non-contract");
462 
463         // solhint-disable-next-line avoid-low-level-calls
464         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
465         if (success) {
466             return returndata;
467         } else {
468             // Look for revert reason and bubble it up if present
469             if (returndata.length > 0) {
470                 // The easiest way to bubble the revert reason is using memory via assembly
471 
472                 // solhint-disable-next-line no-inline-assembly
473                 assembly {
474                     let returndata_size := mload(returndata)
475                     revert(add(32, returndata), returndata_size)
476                 }
477             } else {
478                 revert(errorMessage);
479             }
480         }
481     }
482 }
483 
484 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
485 
486 // SPDX-License-Identifier: MIT
487 
488 pragma solidity ^0.6.0;
489 
490 
491 
492 
493 
494 /**
495  * @dev Implementation of the {IERC20} interface.
496  *
497  * This implementation is agnostic to the way tokens are created. This means
498  * that a supply mechanism has to be added in a derived contract using {_mint}.
499  * For a generic mechanism see {ERC20PresetMinterPauser}.
500  *
501  * TIP: For a detailed writeup see our guide
502  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
503  * to implement supply mechanisms].
504  *
505  * We have followed general OpenZeppelin guidelines: functions revert instead
506  * of returning `false` on failure. This behavior is nonetheless conventional
507  * and does not conflict with the expectations of ERC20 applications.
508  *
509  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
510  * This allows applications to reconstruct the allowance for all accounts just
511  * by listening to said events. Other implementations of the EIP may not emit
512  * these events, as it isn't required by the specification.
513  *
514  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
515  * functions have been added to mitigate the well-known issues around setting
516  * allowances. See {IERC20-approve}.
517  */
518 contract ERC20 is Context, IERC20 {
519     using SafeMath for uint256;
520     using Address for address;
521 
522     mapping (address => uint256) private _balances;
523 
524     mapping (address => mapping (address => uint256)) private _allowances;
525 
526     uint256 private _totalSupply;
527 
528     string private _name;
529     string private _symbol;
530     uint8 private _decimals;
531 
532     /**
533      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
534      * a default value of 18.
535      *
536      * To select a different value for {decimals}, use {_setupDecimals}.
537      *
538      * All three of these values are immutable: they can only be set once during
539      * construction.
540      */
541     constructor (string memory name, string memory symbol) public {
542         _name = name;
543         _symbol = symbol;
544         _decimals = 18;
545     }
546 
547     /**
548      * @dev Returns the name of the token.
549      */
550     function name() public view returns (string memory) {
551         return _name;
552     }
553 
554     /**
555      * @dev Returns the symbol of the token, usually a shorter version of the
556      * name.
557      */
558     function symbol() public view returns (string memory) {
559         return _symbol;
560     }
561 
562     /**
563      * @dev Returns the number of decimals used to get its user representation.
564      * For example, if `decimals` equals `2`, a balance of `505` tokens should
565      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
566      *
567      * Tokens usually opt for a value of 18, imitating the relationship between
568      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
569      * called.
570      *
571      * NOTE: This information is only used for _display_ purposes: it in
572      * no way affects any of the arithmetic of the contract, including
573      * {IERC20-balanceOf} and {IERC20-transfer}.
574      */
575     function decimals() public view returns (uint8) {
576         return _decimals;
577     }
578 
579     /**
580      * @dev See {IERC20-totalSupply}.
581      */
582     function totalSupply() public view override returns (uint256) {
583         return _totalSupply;
584     }
585 
586     /**
587      * @dev See {IERC20-balanceOf}.
588      */
589     function balanceOf(address account) public view override returns (uint256) {
590         return _balances[account];
591     }
592 
593     /**
594      * @dev See {IERC20-transfer}.
595      *
596      * Requirements:
597      *
598      * - `recipient` cannot be the zero address.
599      * - the caller must have a balance of at least `amount`.
600      */
601     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
602         _transfer(_msgSender(), recipient, amount);
603         return true;
604     }
605 
606     /**
607      * @dev See {IERC20-allowance}.
608      */
609     function allowance(address owner, address spender) public view virtual override returns (uint256) {
610         return _allowances[owner][spender];
611     }
612 
613     /**
614      * @dev See {IERC20-approve}.
615      *
616      * Requirements:
617      *
618      * - `spender` cannot be the zero address.
619      */
620     function approve(address spender, uint256 amount) public virtual override returns (bool) {
621         _approve(_msgSender(), spender, amount);
622         return true;
623     }
624 
625     /**
626      * @dev See {IERC20-transferFrom}.
627      *
628      * Emits an {Approval} event indicating the updated allowance. This is not
629      * required by the EIP. See the note at the beginning of {ERC20};
630      *
631      * Requirements:
632      * - `sender` and `recipient` cannot be the zero address.
633      * - `sender` must have a balance of at least `amount`.
634      * - the caller must have allowance for ``sender``'s tokens of at least
635      * `amount`.
636      */
637     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
638         _transfer(sender, recipient, amount);
639         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
640         return true;
641     }
642 
643     /**
644      * @dev Atomically increases the allowance granted to `spender` by the caller.
645      *
646      * This is an alternative to {approve} that can be used as a mitigation for
647      * problems described in {IERC20-approve}.
648      *
649      * Emits an {Approval} event indicating the updated allowance.
650      *
651      * Requirements:
652      *
653      * - `spender` cannot be the zero address.
654      */
655     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
656         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
657         return true;
658     }
659 
660     /**
661      * @dev Atomically decreases the allowance granted to `spender` by the caller.
662      *
663      * This is an alternative to {approve} that can be used as a mitigation for
664      * problems described in {IERC20-approve}.
665      *
666      * Emits an {Approval} event indicating the updated allowance.
667      *
668      * Requirements:
669      *
670      * - `spender` cannot be the zero address.
671      * - `spender` must have allowance for the caller of at least
672      * `subtractedValue`.
673      */
674     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
675         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
676         return true;
677     }
678 
679     /**
680      * @dev Moves tokens `amount` from `sender` to `recipient`.
681      *
682      * This is internal function is equivalent to {transfer}, and can be used to
683      * e.g. implement automatic token fees, slashing mechanisms, etc.
684      *
685      * Emits a {Transfer} event.
686      *
687      * Requirements:
688      *
689      * - `sender` cannot be the zero address.
690      * - `recipient` cannot be the zero address.
691      * - `sender` must have a balance of at least `amount`.
692      */
693     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
694         require(sender != address(0), "ERC20: transfer from the zero address");
695         require(recipient != address(0), "ERC20: transfer to the zero address");
696 
697         _beforeTokenTransfer(sender, recipient, amount);
698 
699         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
700         _balances[recipient] = _balances[recipient].add(amount);
701         emit Transfer(sender, recipient, amount);
702     }
703 
704     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
705      * the total supply.
706      *
707      * Emits a {Transfer} event with `from` set to the zero address.
708      *
709      * Requirements
710      *
711      * - `to` cannot be the zero address.
712      */
713     function _mint(address account, uint256 amount) internal virtual {
714         require(account != address(0), "ERC20: mint to the zero address");
715 
716         _beforeTokenTransfer(address(0), account, amount);
717 
718         _totalSupply = _totalSupply.add(amount);
719         _balances[account] = _balances[account].add(amount);
720         emit Transfer(address(0), account, amount);
721     }
722 
723     /**
724      * @dev Destroys `amount` tokens from `account`, reducing the
725      * total supply.
726      *
727      * Emits a {Transfer} event with `to` set to the zero address.
728      *
729      * Requirements
730      *
731      * - `account` cannot be the zero address.
732      * - `account` must have at least `amount` tokens.
733      */
734     function _burn(address account, uint256 amount) internal virtual {
735         require(account != address(0), "ERC20: burn from the zero address");
736 
737         _beforeTokenTransfer(account, address(0), amount);
738 
739         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
740         _totalSupply = _totalSupply.sub(amount);
741         emit Transfer(account, address(0), amount);
742     }
743 
744     /**
745      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
746      *
747      * This internal function is equivalent to `approve`, and can be used to
748      * e.g. set automatic allowances for certain subsystems, etc.
749      *
750      * Emits an {Approval} event.
751      *
752      * Requirements:
753      *
754      * - `owner` cannot be the zero address.
755      * - `spender` cannot be the zero address.
756      */
757     function _approve(address owner, address spender, uint256 amount) internal virtual {
758         require(owner != address(0), "ERC20: approve from the zero address");
759         require(spender != address(0), "ERC20: approve to the zero address");
760 
761         _allowances[owner][spender] = amount;
762         emit Approval(owner, spender, amount);
763     }
764 
765     /**
766      * @dev Sets {decimals} to a value other than the default one of 18.
767      *
768      * WARNING: This function should only be called from the constructor. Most
769      * applications that interact with token contracts will not expect
770      * {decimals} to ever change, and may work incorrectly if it does.
771      */
772     function _setupDecimals(uint8 decimals_) internal {
773         _decimals = decimals_;
774     }
775 
776     /**
777      * @dev Hook that is called before any transfer of tokens. This includes
778      * minting and burning.
779      *
780      * Calling conditions:
781      *
782      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
783      * will be to transferred to `to`.
784      * - when `from` is zero, `amount` tokens will be minted for `to`.
785      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
786      * - `from` and `to` are never both zero.
787      *
788      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
789      */
790     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
791 }
792 
793 // File: contracts\compound\CarefulMath.sol
794 
795 pragma solidity ^0.6.0;
796 
797 /**
798   * @title Careful Math
799   * @author Compound
800 
801 /blob/master/contracts/math/SafeMath.sol
802   */
803 contract CarefulMath {
804 
805     /**
806      * @dev Possible error codes that we can return
807      */
808     enum MathError {
809         NO_ERROR,
810         DIVISION_BY_ZERO,
811         INTEGER_OVERFLOW,
812         INTEGER_UNDERFLOW
813     }
814 
815     /**
816     * @dev Multiplies two numbers, returns an error on overflow.
817     */
818     function mulUInt(uint a, uint b) internal pure returns (MathError, uint) {
819         if (a == 0) {
820             return (MathError.NO_ERROR, 0);
821         }
822 
823         uint c = a * b;
824 
825         if (c / a != b) {
826             return (MathError.INTEGER_OVERFLOW, 0);
827         } else {
828             return (MathError.NO_ERROR, c);
829         }
830     }
831 
832     /**
833     * @dev Integer division of two numbers, truncating the quotient.
834     */
835     function divUInt(uint a, uint b) internal pure returns (MathError, uint) {
836         if (b == 0) {
837             return (MathError.DIVISION_BY_ZERO, 0);
838         }
839 
840         return (MathError.NO_ERROR, a / b);
841     }
842 
843     /**
844     * @dev Subtracts two numbers, returns an error on overflow (i.e. if subtrahend is greater than minuend).
845     */
846     function subUInt(uint a, uint b) internal pure returns (MathError, uint) {
847         if (b <= a) {
848             return (MathError.NO_ERROR, a - b);
849         } else {
850             return (MathError.INTEGER_UNDERFLOW, 0);
851         }
852     }
853 
854     /**
855     * @dev Adds two numbers, returns an error on overflow.
856     */
857     function addUInt(uint a, uint b) internal pure returns (MathError, uint) {
858         uint c = a + b;
859 
860         if (c >= a) {
861             return (MathError.NO_ERROR, c);
862         } else {
863             return (MathError.INTEGER_OVERFLOW, 0);
864         }
865     }
866 
867     /**
868     * @dev add a and b and then subtract c
869     */
870     function addThenSubUInt(uint a, uint b, uint c) internal pure returns (MathError, uint) {
871         (MathError err0, uint sum) = addUInt(a, b);
872 
873         if (err0 != MathError.NO_ERROR) {
874             return (err0, 0);
875         }
876 
877         return subUInt(sum, c);
878     }
879 }
880 
881 // File: contracts\compound\Exponential.sol
882 
883 pragma solidity ^0.6.0;
884 
885 
886 /**
887  * @title Exponential module for storing fixed-precision decimals
888  * @author Compound
889  * @notice Exp is a struct which stores decimals with a fixed precision of 18 decimal places.
890  *         Thus, if we wanted to store the 5.1, mantissa would store 5.1e18. That is:
891  *         `Exp({mantissa: 5100000000000000000})`.
892  */
893 contract Exponential is CarefulMath {
894     uint constant expScale = 1e18;
895     uint constant doubleScale = 1e36;
896     uint constant halfExpScale = expScale/2;
897     uint constant mantissaOne = expScale;
898 
899     struct Exp {
900         uint mantissa;
901     }
902 
903     struct Double {
904         uint mantissa;
905     }
906 
907     /**
908      * @dev Creates an exponential from numerator and denominator values.
909      *      Note: Returns an error if (`num` * 10e18) > MAX_INT,
910      *            or if `denom` is zero.
911      */
912     function getExp(uint num, uint denom) pure internal returns (MathError, Exp memory) {
913         (MathError err0, uint scaledNumerator) = mulUInt(num, expScale);
914         if (err0 != MathError.NO_ERROR) {
915             return (err0, Exp({mantissa: 0}));
916         }
917 
918         (MathError err1, uint rational) = divUInt(scaledNumerator, denom);
919         if (err1 != MathError.NO_ERROR) {
920             return (err1, Exp({mantissa: 0}));
921         }
922 
923         return (MathError.NO_ERROR, Exp({mantissa: rational}));
924     }
925 
926     /**
927      * @dev Adds two exponentials, returning a new exponential.
928      */
929     function addExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
930         (MathError error, uint result) = addUInt(a.mantissa, b.mantissa);
931 
932         return (error, Exp({mantissa: result}));
933     }
934 
935     /**
936      * @dev Subtracts two exponentials, returning a new exponential.
937      */
938     function subExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
939         (MathError error, uint result) = subUInt(a.mantissa, b.mantissa);
940 
941         return (error, Exp({mantissa: result}));
942     }
943 
944     /**
945      * @dev Multiply an Exp by a scalar, returning a new Exp.
946      */
947     function mulScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
948         (MathError err0, uint scaledMantissa) = mulUInt(a.mantissa, scalar);
949         if (err0 != MathError.NO_ERROR) {
950             return (err0, Exp({mantissa: 0}));
951         }
952 
953         return (MathError.NO_ERROR, Exp({mantissa: scaledMantissa}));
954     }
955 
956     /**
957      * @dev Multiply an Exp by a scalar, then truncate to return an unsigned integer.
958      */
959     function mulScalarTruncate(Exp memory a, uint scalar) pure internal returns (MathError, uint) {
960         (MathError err, Exp memory product) = mulScalar(a, scalar);
961         if (err != MathError.NO_ERROR) {
962             return (err, 0);
963         }
964 
965         return (MathError.NO_ERROR, truncate(product));
966     }
967 
968     /**
969      * @dev Multiply an Exp by a scalar, truncate, then add an to an unsigned integer, returning an unsigned integer.
970      */
971     function mulScalarTruncateAddUInt(Exp memory a, uint scalar, uint addend) pure internal returns (MathError, uint) {
972         (MathError err, Exp memory product) = mulScalar(a, scalar);
973         if (err != MathError.NO_ERROR) {
974             return (err, 0);
975         }
976 
977         return addUInt(truncate(product), addend);
978     }
979 
980     /**
981      * @dev Divide an Exp by a scalar, returning a new Exp.
982      */
983     function divScalar(Exp memory a, uint scalar) pure internal returns (MathError, Exp memory) {
984         (MathError err0, uint descaledMantissa) = divUInt(a.mantissa, scalar);
985         if (err0 != MathError.NO_ERROR) {
986             return (err0, Exp({mantissa: 0}));
987         }
988 
989         return (MathError.NO_ERROR, Exp({mantissa: descaledMantissa}));
990     }
991 
992     /**
993      * @dev Divide a scalar by an Exp, returning a new Exp.
994      */
995     function divScalarByExp(uint scalar, Exp memory divisor) pure internal returns (MathError, Exp memory) {
996         /*
997           We are doing this as:
998           getExp(mulUInt(expScale, scalar), divisor.mantissa)
999 
1000           How it works:
1001           Exp = a / b;
1002           Scalar = s;
1003           `s / (a / b)` = `b * s / a` and since for an Exp `a = mantissa, b = expScale`
1004         */
1005         (MathError err0, uint numerator) = mulUInt(expScale, scalar);
1006         if (err0 != MathError.NO_ERROR) {
1007             return (err0, Exp({mantissa: 0}));
1008         }
1009         return getExp(numerator, divisor.mantissa);
1010     }
1011 
1012     /**
1013      * @dev Divide a scalar by an Exp, then truncate to return an unsigned integer.
1014      */
1015     function divScalarByExpTruncate(uint scalar, Exp memory divisor) pure internal returns (MathError, uint) {
1016         (MathError err, Exp memory fraction) = divScalarByExp(scalar, divisor);
1017         if (err != MathError.NO_ERROR) {
1018             return (err, 0);
1019         }
1020 
1021         return (MathError.NO_ERROR, truncate(fraction));
1022     }
1023 
1024     /**
1025      * @dev Multiplies two exponentials, returning a new exponential.
1026      */
1027     function mulExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
1028 
1029         (MathError err0, uint doubleScaledProduct) = mulUInt(a.mantissa, b.mantissa);
1030         if (err0 != MathError.NO_ERROR) {
1031             return (err0, Exp({mantissa: 0}));
1032         }
1033 
1034         // We add half the scale before dividing so that we get rounding instead of truncation.
1035         //  See "Listing 6" and text above it at https://accu.org/index.php/journals/1717
1036         // Without this change, a result like 6.6...e-19 will be truncated to 0 instead of being rounded to 1e-18.
1037         (MathError err1, uint doubleScaledProductWithHalfScale) = addUInt(halfExpScale, doubleScaledProduct);
1038         if (err1 != MathError.NO_ERROR) {
1039             return (err1, Exp({mantissa: 0}));
1040         }
1041 
1042         (MathError err2, uint product) = divUInt(doubleScaledProductWithHalfScale, expScale);
1043         // The only error `div` can return is MathError.DIVISION_BY_ZERO but we control `expScale` and it is not zero.
1044         assert(err2 == MathError.NO_ERROR);
1045 
1046         return (MathError.NO_ERROR, Exp({mantissa: product}));
1047     }
1048 
1049     /**
1050      * @dev Multiplies two exponentials given their mantissas, returning a new exponential.
1051      */
1052     function mulExp(uint a, uint b) pure internal returns (MathError, Exp memory) {
1053         return mulExp(Exp({mantissa: a}), Exp({mantissa: b}));
1054     }
1055 
1056     /**
1057      * @dev Multiplies three exponentials, returning a new exponential.
1058      */
1059     function mulExp3(Exp memory a, Exp memory b, Exp memory c) pure internal returns (MathError, Exp memory) {
1060         (MathError err, Exp memory ab) = mulExp(a, b);
1061         if (err != MathError.NO_ERROR) {
1062             return (err, ab);
1063         }
1064         return mulExp(ab, c);
1065     }
1066 
1067     /**
1068      * @dev Divides two exponentials, returning a new exponential.
1069      *     (a/scale) / (b/scale) = (a/scale) * (scale/b) = a/b,
1070      *  which we can scale as an Exp by calling getExp(a.mantissa, b.mantissa)
1071      */
1072     function divExp(Exp memory a, Exp memory b) pure internal returns (MathError, Exp memory) {
1073         return getExp(a.mantissa, b.mantissa);
1074     }
1075 
1076     /**
1077      * @dev Truncates the given exp to a whole number value.
1078      *      For example, truncate(Exp{mantissa: 15 * expScale}) = 15
1079      */
1080     function truncate(Exp memory exp) pure internal returns (uint) {
1081         // Note: We are not using careful math here as we're performing a division that cannot fail
1082         return exp.mantissa / expScale;
1083     }
1084 
1085     /**
1086      * @dev Checks if first Exp is less than second Exp.
1087      */
1088     function lessThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
1089         return left.mantissa < right.mantissa;
1090     }
1091 
1092     /**
1093      * @dev Checks if left Exp <= right Exp.
1094      */
1095     function lessThanOrEqualExp(Exp memory left, Exp memory right) pure internal returns (bool) {
1096         return left.mantissa <= right.mantissa;
1097     }
1098 
1099     /**
1100      * @dev Checks if left Exp > right Exp.
1101      */
1102     function greaterThanExp(Exp memory left, Exp memory right) pure internal returns (bool) {
1103         return left.mantissa > right.mantissa;
1104     }
1105 
1106     /**
1107      * @dev returns true if Exp is exactly zero
1108      */
1109     function isZeroExp(Exp memory value) pure internal returns (bool) {
1110         return value.mantissa == 0;
1111     }
1112 
1113     function safe224(uint n, string memory errorMessage) pure internal returns (uint224) {
1114         require(n < 2**224, errorMessage);
1115         return uint224(n);
1116     }
1117 
1118     function safe32(uint n, string memory errorMessage) pure internal returns (uint32) {
1119         require(n < 2**32, errorMessage);
1120         return uint32(n);
1121     }
1122 
1123     function add_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1124         return Exp({mantissa: add_(a.mantissa, b.mantissa)});
1125     }
1126 
1127     function add_(Double memory a, Double memory b) pure internal returns (Double memory) {
1128         return Double({mantissa: add_(a.mantissa, b.mantissa)});
1129     }
1130 
1131     function add_(uint a, uint b) pure internal returns (uint) {
1132         return add_(a, b, "addition overflow");
1133     }
1134 
1135     function add_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1136         uint c = a + b;
1137         require(c >= a, errorMessage);
1138         return c;
1139     }
1140 
1141     function sub_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1142         return Exp({mantissa: sub_(a.mantissa, b.mantissa)});
1143     }
1144 
1145     function sub_(Double memory a, Double memory b) pure internal returns (Double memory) {
1146         return Double({mantissa: sub_(a.mantissa, b.mantissa)});
1147     }
1148 
1149     function sub_(uint a, uint b) pure internal returns (uint) {
1150         return sub_(a, b, "subtraction underflow");
1151     }
1152 
1153     function sub_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1154         require(b <= a, errorMessage);
1155         return a - b;
1156     }
1157 
1158     function mul_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1159         return Exp({mantissa: mul_(a.mantissa, b.mantissa) / expScale});
1160     }
1161 
1162     function mul_(Exp memory a, uint b) pure internal returns (Exp memory) {
1163         return Exp({mantissa: mul_(a.mantissa, b)});
1164     }
1165 
1166     function mul_(uint a, Exp memory b) pure internal returns (uint) {
1167         return mul_(a, b.mantissa) / expScale;
1168     }
1169 
1170     function mul_(Double memory a, Double memory b) pure internal returns (Double memory) {
1171         return Double({mantissa: mul_(a.mantissa, b.mantissa) / doubleScale});
1172     }
1173 
1174     function mul_(Double memory a, uint b) pure internal returns (Double memory) {
1175         return Double({mantissa: mul_(a.mantissa, b)});
1176     }
1177 
1178     function mul_(uint a, Double memory b) pure internal returns (uint) {
1179         return mul_(a, b.mantissa) / doubleScale;
1180     }
1181 
1182     function mul_(uint a, uint b) pure internal returns (uint) {
1183         return mul_(a, b, "multiplication overflow");
1184     }
1185 
1186     function mul_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1187         if (a == 0 || b == 0) {
1188             return 0;
1189         }
1190         uint c = a * b;
1191         require(c / a == b, errorMessage);
1192         return c;
1193     }
1194 
1195     function div_(Exp memory a, Exp memory b) pure internal returns (Exp memory) {
1196         return Exp({mantissa: div_(mul_(a.mantissa, expScale), b.mantissa)});
1197     }
1198 
1199     function div_(Exp memory a, uint b) pure internal returns (Exp memory) {
1200         return Exp({mantissa: div_(a.mantissa, b)});
1201     }
1202 
1203     function div_(uint a, Exp memory b) pure internal returns (uint) {
1204         return div_(mul_(a, expScale), b.mantissa);
1205     }
1206 
1207     function div_(Double memory a, Double memory b) pure internal returns (Double memory) {
1208         return Double({mantissa: div_(mul_(a.mantissa, doubleScale), b.mantissa)});
1209     }
1210 
1211     function div_(Double memory a, uint b) pure internal returns (Double memory) {
1212         return Double({mantissa: div_(a.mantissa, b)});
1213     }
1214 
1215     function div_(uint a, Double memory b) pure internal returns (uint) {
1216         return div_(mul_(a, doubleScale), b.mantissa);
1217     }
1218 
1219     function div_(uint a, uint b) pure internal returns (uint) {
1220         return div_(a, b, "divide by zero");
1221     }
1222 
1223     function div_(uint a, uint b, string memory errorMessage) pure internal returns (uint) {
1224         require(b > 0, errorMessage);
1225         return a / b;
1226     }
1227 
1228     function fraction(uint a, uint b) pure internal returns (Double memory) {
1229         return Double({mantissa: div_(mul_(a, doubleScale), b)});
1230     }
1231 }
1232 
1233 // File: contracts\compound\InterestRateModel.sol
1234 
1235 pragma solidity ^0.6.0;
1236 
1237 /**
1238   * @title Compound's InterestRateModel Interface
1239   * @author Compound
1240   */
1241 abstract contract InterestRateModel {
1242     /// @notice Indicator that this is an InterestRateModel contract (for inspection)
1243     bool public constant isInterestRateModel = true;
1244 
1245     /**
1246       * @notice Calculates the current borrow interest rate per block
1247       * @param cash The total amount of cash the market has
1248       * @param borrows The total amount of borrows the market has outstanding
1249       * @param reserves The total amount of reserves the market has
1250       * @return The borrow rate per block (as a percentage, and scaled by 1e18)
1251       */
1252     function getBorrowRate(uint cash, uint borrows, uint reserves) external virtual view returns (uint);
1253 
1254     /**
1255       * @notice Calculates the current supply interest rate per block
1256       * @param cash The total amount of cash the market has
1257       * @param borrows The total amount of borrows the market has outstanding
1258       * @param reserves The total amount of reserves the market has
1259       * @param reserveFactorMantissa The current reserve factor the market has
1260       * @return The supply rate per block (as a percentage, and scaled by 1e18)
1261       */
1262     function getSupplyRate(uint cash, uint borrows, uint reserves, uint reserveFactorMantissa) external virtual view returns (uint);
1263 
1264 }
1265 
1266 // File: contracts\interfaces\UniswapLPOracleFactoryI.sol
1267 
1268 pragma solidity ^0.6.0;
1269 
1270 ////////////////////////////////////////////////////////////////////////////////////////////
1271 /// @title UniswapLPOracleFactoryI
1272 /// @author Christopher Dixon
1273 ////////////////////////////////////////////////////////////////////////////////////////////
1274 /**
1275 The UniswapLPOracleFactoryI contract an abstract contract the Warp platform uses to interface
1276     With the UniswapOracleFactory to retrieve token prices.
1277 **/
1278 
1279 abstract contract UniswapLPOracleFactoryI {
1280     /**
1281 @notice createNewOracle allows the owner of this contract to deploy a new oracle contract when
1282         a new asset is whitelisted
1283 @dev this function is marked as virtual as it is an abstracted function
1284 **/
1285 
1286     function createNewOracles(
1287         address _tokenA,
1288         address _tokenB,
1289         address _lpToken
1290     ) public virtual;
1291 
1292     function OneUSDC() public virtual view returns (uint256);
1293 
1294     /**
1295 @notice getUnderlyingPrice allows for the price retrieval of a MoneyMarketInstances underlying asset
1296 @param _MMI is the address of the MoneyMarketInstance whos asset price is being retrieved
1297 @return returns the price of the asset
1298 **/
1299     function getUnderlyingPrice(address _MMI)
1300         public
1301         virtual
1302         returns (uint256);
1303 
1304     function viewUnderlyingPrice(address _MMI)
1305         public
1306         view
1307         virtual
1308         returns (uint256);
1309 
1310     function getPriceOfToken(address _token, uint256 _amount) public virtual returns (uint256);
1311     function viewPriceOfToken(address token, uint256 _amount) public view virtual returns (uint256);
1312 
1313     function transferOwnership(address _newOwner) public virtual;
1314 
1315       function _calculatePriceOfLP(uint256 supply, uint256 value0, uint256 value1, uint8 supplyDecimals)
1316       public pure virtual returns (uint256);
1317 }
1318 
1319 // File: contracts\WarpWrapperToken.sol
1320 
1321 pragma solidity ^0.6.2;
1322 
1323 
1324 
1325 ////////////////////////////////////////////////////////////////////////////////////////////
1326 /// @title WarpWrapperToken
1327 /// @author Christopher Dixon
1328 ////////////////////////////////////////////////////////////////////////////////////////////
1329 /**
1330 @notice the WarpWrapperToken contract is designed  as a token Wrapper to represent ownership of stablecoins added to a specific
1331         WarpVault. This contract inherits Ownership and ERC20 functionality from the Open Zeppelin Library.
1332 **/
1333 contract WarpWrapperToken is Ownable, ERC20 {
1334     address public stablecoin;
1335 
1336     ///@notice constructor sets up token names and symbols for the WarpWrapperToken
1337     constructor(
1338         address _SC,
1339         string memory _tokenName,
1340         string memory _tokenSymbol
1341     ) public ERC20(_tokenSymbol, _tokenName) {
1342         stablecoin = _SC;
1343     }
1344 
1345     /**
1346 @notice mint is an only owner function that allows the owner to mint new tokens to an input account
1347 @param _to is the address that will receive the new tokens
1348 @param _amount is the amount of token they will receive
1349 **/
1350     function mint(address _to, uint256 _amount) public onlyOwner {
1351         _mint(_to, _amount);
1352     }
1353 
1354     /**
1355 @notice burn is an only owner function that allows the owner to burn  tokens from an input account
1356 @param _from is the address where the tokens will be burnt
1357 @param _amount is the amount of token to be burnt
1358 **/
1359     function burn(address _from, uint256 _amount) public onlyOwner {
1360         _burn(_from, _amount);
1361     }
1362 }
1363 
1364 // File: contracts\interfaces\WarpControlI.sol
1365 
1366 pragma solidity ^0.6.0;
1367 
1368 ////////////////////////////////////////////////////////////////////////////////////////////
1369 /// @title WarpVaultI
1370 /// @author Christopher Dixon
1371 ////////////////////////////////////////////////////////////////////////////////////////////
1372 /**
1373 The WarpControlI contract is an abstract contract used by individual WarpVault contracts to call the
1374   maxWithdrawAllowed function on the WarpControl contract
1375 **/
1376 
1377 abstract contract WarpControlI {
1378     function getMaxWithdrawAllowed(address account, address lpToken) public virtual returns (uint256);
1379     function viewMaxWithdrawAllowed(address account, address lpToken) public view virtual returns (uint256);
1380     function viewPriceOfCollateral(address lpToken) public virtual view returns (uint256);
1381     function addMemberToGroup(address _refferalCode, address _member) public virtual;
1382     function checkIfGroupMember(address _account) public view virtual returns(bool);
1383     function getTotalAvailableCollateralValue(address _account) public virtual returns (uint256);
1384     function viewTotalAvailableCollateralValue(address _account) public view virtual returns (uint256);
1385     function viewPriceOfToken(address token) public view virtual returns(uint256);
1386     function viewTotalBorrowedValue(address _account) public view virtual returns (uint256);
1387     function getTotalBorrowedValue(address _account) public virtual returns (uint256);
1388     function calcBorrowLimit(uint256 _collateralValue) public pure virtual returns (uint256);
1389     function calcCollateralRequired(uint256 _borrowAmount) public view virtual returns (uint256);
1390     function getBorrowLimit(address _account) public virtual returns (uint256);
1391     function viewBorrowLimit(address _account) public view virtual returns (uint256);
1392     function liquidateAccount(address _borrower) public virtual;
1393 }
1394 
1395 // File: contracts\WarpVaultSC.sol
1396 
1397 pragma solidity ^0.6.2;
1398 
1399 
1400 
1401 
1402 
1403 
1404 
1405 
1406 
1407 ////////////////////////////////////////////////////////////////////////////////////////////
1408 /// @title WarpVaultSC
1409 /// @author Christopher Dixon
1410 ////////////////////////////////////////////////////////////////////////////////////////////
1411 /**
1412 @notice the WarpVaultSC contract is the main point of interface for a specific LP asset class and an end user in the
1413 Warp lending platform. This contract is responsible for distributing WarpWrapper tokens in exchange for stablecoin assets,
1414 holding and accounting of stablecoins and LP tokens and all associates lending/borrowing calculations for a specific Warp LP asset class.
1415 This contract inherits Ownership and ERC20 functionality from the Open Zeppelin Library as well as Exponential and the InterestRateModel contracts
1416 from the coumpound protocol.
1417 **/
1418 
1419 contract WarpVaultSC is Ownable, Exponential {
1420     using SafeMath for uint256;
1421 
1422     uint256 internal initialExchangeRateMantissa;
1423     uint256 public reserveFactorMantissa;
1424     uint256 public accrualBlockNumber;
1425     uint256 public borrowIndex;
1426     uint256 public totalBorrows;
1427     uint256 public totalReserves;
1428     uint256 internal constant borrowRateMaxMantissa = 0.0005e16;
1429     uint256 public percent = 1500;
1430     uint256 public divisor = 10000;
1431     uint256 public timeWizard;
1432     address public warpTeam;
1433 
1434     ERC20 public stablecoin;
1435     WarpWrapperToken public wStableCoin;
1436     WarpControlI public WC;
1437     InterestRateModel public InterestRate;
1438 
1439     mapping(address => BorrowSnapshot) public accountBorrows;
1440     mapping(address => uint256) public principalBalance;
1441     mapping(address => uint256) public historicalReward;
1442 
1443     event InterestAccrued(uint accrualBlockNumber, uint borrowIndex, uint totalBorrows, uint totalReserves);
1444     event StableCoinLent(address _lender, uint _amountLent, uint _amountOfWarpMinted);
1445     event StableCoinWithdraw(address _lender, uint _amountWithdrawn, uint _amountOfWarpBurnt);
1446     event LoanRepayed(address _borrower, uint _repayAmount, uint remainingPrinciple, uint remainingInterest);
1447     event ReserveWithdraw(uint _amount);
1448 
1449     /**
1450     @notice struct for borrow balance information
1451     @member principal Total balance (with accrued interest), after applying the most recent balance-changing action
1452     @member interestIndex Global borrowIndex as of the most recent balance-changing action
1453     */
1454     struct BorrowSnapshot {
1455         uint256 principal;
1456         uint256 interestIndex;
1457     }
1458 
1459     /**
1460     @dev Throws if called by any account other than a warp control
1461     **/
1462     modifier onlyWC() {
1463         require(msg.sender == address(WC));
1464         _;
1465     }
1466 
1467     /**
1468     @dev Throws if a function is called before the time wizard allows it
1469     **/
1470         modifier angryWizard() {
1471             require(now > timeWizard);
1472             _;
1473         }
1474 
1475     /**
1476     @dev Throws if a function is called by anyone but the warp team
1477     **/
1478         modifier onlyWarpT() {
1479               require(msg.sender == warpTeam);
1480               _;
1481           }
1482 
1483     /**
1484     @notice constructor sets up token names and symbols for the WarpWrapperToken
1485     @param _InterestRate is the address of the Interest Rate Model this vault will be using
1486     @param _StableCoin is the address of the stablecoin this vault will manage
1487     @param _warpTeam is the address of the Warp Team used for fees
1488     @param _initialExchangeRate is the initial exchange rate mantissa used to determine how a Warp wrapper token will be distributed when stablecoin is received
1489     @param _timelock is a variable representing the number of seconds the timeWizard will prevent withdraws and borrows from a contracts(one week is 605800 seconds)
1490     **/
1491     constructor(
1492         address _InterestRate,
1493         address _StableCoin,
1494         address _warpControl,
1495         address _warpTeam,
1496         uint256 _initialExchangeRate,
1497         uint256 _timelock,
1498         uint256 _reserveFactorMantissa
1499     ) public {
1500         WC = WarpControlI(_warpControl);
1501         stablecoin = ERC20(_StableCoin);
1502         InterestRate = InterestRateModel(_InterestRate);
1503         accrualBlockNumber = getBlockNumber();
1504         borrowIndex = mantissaOne;
1505         initialExchangeRateMantissa = _initialExchangeRate; //sets the initialExchangeRateMantissa
1506         warpTeam = _warpTeam;
1507         timeWizard = now.add(_timelock);
1508         reserveFactorMantissa = _reserveFactorMantissa;
1509         wStableCoin = new WarpWrapperToken(
1510             address(stablecoin),
1511             stablecoin.name(),
1512             stablecoin.symbol()
1513         );
1514     }
1515     /**
1516     @notice getSCDecimals allows for easy retrieval of the vaults stablecoin decimals
1517     **/
1518     function getSCDecimals() public view returns(uint8) {
1519         return stablecoin.decimals();
1520     }
1521 
1522     /**
1523     @notice getSCAddress allows for the easy retrieval of the vaults stablecoin address
1524     **/
1525     function getSCAddress() public view returns(address) {
1526         return address(stablecoin);
1527     }
1528 
1529     /**
1530     @notice upgrade is used when upgrading to a new version of the WarpControl contracts
1531     @dev this is a protected function that can only be called by the WarpControl contract
1532     **/
1533     function upgrade(address _warpControl) public onlyWC {
1534       WC = WarpControlI(_warpControl);
1535       transferOwnership(_warpControl);
1536     }
1537 
1538     function updateTeam(address _team) public onlyWC {
1539         warpTeam = _team;
1540     }
1541 
1542     /**
1543     @notice getCashPrior is a view funcion that returns the USD balance of all held underlying stablecoin assets
1544     **/
1545     function getCashPrior() public view returns (uint256) {
1546         return stablecoin.balanceOf(address(this));
1547     }
1548 
1549     /**
1550     @notice calculateFee is used to calculate the fee earned by the Warp Platform
1551     @param _payedAmount is a uint representing the full amount of stablecoin earned as interest
1552         **/
1553     function calculateFee(uint256 _payedAmount) public view returns(uint256) {
1554         uint256 fee = _payedAmount.mul(percent).div(divisor);
1555         return fee;
1556     }
1557 
1558     /**
1559     @notice withdrawReserves allows the warp team to withdraw the reserves earned by fees
1560     @param _amount is the amount of a stablecoin being withdrawn
1561     @dev this is a protected function that can only be called by the warpTeam address
1562     **/
1563     function withdrawReserves(uint _amount) public onlyWarpT{
1564       require(totalReserves >= _amount, "You are trying to withdraw too much");
1565       totalReserves = totalReserves.sub(_amount);
1566       stablecoin.transfer(warpTeam, _amount);
1567       emit ReserveWithdraw(_amount);
1568     }
1569 
1570     /**
1571     @notice setNewInterestModel allows for a new interest rate model to be set for this vault
1572     @param _newModel is the address of the new interest rate model contract
1573     @dev this is a protected function that can only be called by the WarpControl contract
1574     **/
1575     function setNewInterestModel(address _newModel) public onlyWC {
1576       InterestRate = InterestRateModel(_newModel);
1577     }
1578 
1579     /**
1580     @notice updateReserve allows for a new reserv percentage to be set
1581     @param _newReserveMantissa is the reserve percentage scaled by 1e18
1582     **/
1583     function updateReserve(uint _newReserveMantissa) public onlyWarpT {
1584       reserveFactorMantissa = _newReserveMantissa;
1585     }
1586 
1587     /**
1588     @notice Applies accrued interest to total borrows and reserves
1589     @dev This calculates interest accrued from the last checkpointed block
1590         up to the current block and writes new checkpoint to storage.
1591     **/
1592     function accrueInterest() public {
1593         //Remember the initial block number
1594         uint256 currentBlockNumber = getBlockNumber();
1595         uint256 accrualBlockNumberPrior = accrualBlockNumber;
1596         //Short-circuit accumulating 0 interest
1597         require(accrualBlockNumberPrior != currentBlockNumber, "Trying to accrue interest twice");
1598         //Read the previous values out of storage
1599         uint256 cashPrior = getCashPrior();
1600         uint256 borrowsPrior = totalBorrows;
1601         uint256 reservesPrior = totalReserves;
1602         uint256 borrowIndexPrior = borrowIndex;
1603         //Calculate the current borrow interest rate
1604         uint256 borrowRateMantissa = InterestRate.getBorrowRate(
1605             cashPrior,
1606             borrowsPrior,
1607             reservesPrior
1608         );
1609         require(borrowRateMantissa <= borrowRateMaxMantissa, "Borrow Rate mantissa error");
1610         //Calculate the number of blocks elapsed since the last accrual
1611         (MathError mathErr, uint256 blockDelta) = subUInt(
1612             currentBlockNumber,
1613             accrualBlockNumberPrior
1614         );
1615         //Calculate the interest accumulated into borrows and reserves and the new index:
1616         Exp memory simpleInterestFactor;
1617         uint256 interestAccumulated;
1618         uint256 totalBorrowsNew;
1619         uint256 totalReservesNew;
1620         uint256 borrowIndexNew;
1621         //simpleInterestFactor = borrowRate * blockDelta
1622         (mathErr, simpleInterestFactor) = mulScalar(
1623             Exp({mantissa: borrowRateMantissa}),
1624             blockDelta
1625         );
1626         //interestAccumulated = simpleInterestFactor * totalBorrows
1627         (mathErr, interestAccumulated) = mulScalarTruncate(
1628             simpleInterestFactor,
1629             borrowsPrior
1630         );
1631         //totalBorrowsNew = interestAccumulated + totalBorrows
1632         (mathErr, totalBorrowsNew) = addUInt(interestAccumulated, borrowsPrior);
1633         //totalReservesNew = interestAccumulated * reserveFactor + totalReserves
1634         (mathErr, totalReservesNew) = mulScalarTruncateAddUInt(
1635             Exp({mantissa: reserveFactorMantissa}),
1636             interestAccumulated,
1637             reservesPrior
1638         );
1639         //borrowIndexNew = simpleInterestFactor * borrowIndex + borrowIndex
1640         (mathErr, borrowIndexNew) = mulScalarTruncateAddUInt(
1641             simpleInterestFactor,
1642             borrowIndexPrior,
1643             borrowIndexPrior
1644         );
1645 
1646         //Write the previously calculated values into storage
1647         accrualBlockNumber = currentBlockNumber;
1648         borrowIndex = borrowIndexNew;
1649         totalBorrows = totalBorrowsNew;
1650         totalReserves = totalReservesNew;
1651         emit InterestAccrued(accrualBlockNumber, borrowIndex, totalBorrows, totalReserves);
1652     }
1653 
1654     /**
1655     @notice returns last calculated account's borrow balance using the prior borrowIndex
1656     @param account The address whose balance should be calculated after updating borrowIndex
1657     @return The calculated balance
1658     **/
1659     function borrowBalancePrior(address account) public view returns (uint256) {
1660         MathError mathErr;
1661         uint256 principalTimesIndex;
1662         uint256 result;
1663 
1664         //Get borrowBalance and borrowIndex
1665         BorrowSnapshot storage borrowSnapshot = accountBorrows[account];
1666         //If borrowBalance = 0 then borrowIndex is likely also 0.
1667         //Rather than failing the calculation with a division by 0, we immediately return 0 in this case.
1668         if (borrowSnapshot.principal == 0) {
1669             return (0);
1670         }
1671         //Calculate new borrow balance using the interest index:
1672         //recentBorrowBalance = borrower.borrowBalance * market.borrowIndex / borrower.borrowIndex
1673         (mathErr, principalTimesIndex) = mulUInt(
1674             borrowSnapshot.principal,
1675             borrowIndex
1676         );
1677         //if theres a math error return zero so as not to fail
1678         if (mathErr != MathError.NO_ERROR) {
1679             return (0);
1680         }
1681         (mathErr, result) = divUInt(
1682             principalTimesIndex,
1683             borrowSnapshot.interestIndex
1684         );
1685         //if theres a math error return zero so as not to fail
1686         if (mathErr != MathError.NO_ERROR) {
1687             return (0);
1688         }
1689         return (result);
1690     }
1691 
1692     /**
1693     @notice Accrue interest to updated borrowIndex and then calculate account's borrow balance using the updated borrowIndex
1694     @param account The address whose balance should be calculated after updating borrowIndex
1695     @return The calculated balance
1696     **/
1697     function borrowBalanceCurrent(address account) public returns (uint256) {
1698         accrueInterest();
1699         return borrowBalancePrior(account);
1700     }
1701 
1702     /**
1703     @notice getBlockNumber allows for easy retrieval of block number
1704     **/
1705     function getBlockNumber() internal view returns (uint256) {
1706         return block.number;
1707     }
1708 
1709     /**
1710     @notice Returns the current per-block borrow interest rate for this cToken
1711     @return The borrow interest rate per block, scaled by 1e18
1712     **/
1713     function borrowRatePerBlock() public view returns (uint256) {
1714         return
1715             InterestRate.getBorrowRate(
1716                 getCashPrior(),
1717                 totalBorrows,
1718                 totalReserves
1719             );
1720     }
1721 
1722     /**
1723     @notice Returns the current per-block supply interest rate for this cToken
1724     @return The supply interest rate per block, scaled by 1e18
1725     **/
1726     function supplyRatePerBlock() public view returns (uint256) {
1727         return
1728             InterestRate.getSupplyRate(
1729                 getCashPrior(),
1730                 totalBorrows,
1731                 totalReserves,
1732                 reserveFactorMantissa
1733             );
1734     }
1735 
1736     /**
1737      @notice Returns the current total borrows plus accrued interest
1738      @return The total borrows with interest
1739      **/
1740     function totalBorrowsCurrent() external returns (uint256) {
1741         accrueInterest();
1742         return totalBorrows;
1743     }
1744 
1745     /**
1746     @notice  return the not up-to-date exchange rate
1747     @return Calculated exchange rate scaled by 1e18
1748     **/
1749     function exchangeRatePrior() public view returns (uint256) {
1750         if (wStableCoin.totalSupply() == 0) {
1751             //If there are no tokens minted: exchangeRate = initialExchangeRate
1752             return initialExchangeRateMantissa;
1753         } else {
1754             //Otherwise: exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply
1755             uint256 totalCash = getCashPrior(); //get contract asset balance
1756             uint256 cashPlusBorrowsMinusReserves;
1757             Exp memory exchangeRate;
1758             MathError mathErr;
1759             //calculate total value held by contract plus owed to contract
1760             (mathErr, cashPlusBorrowsMinusReserves) = addThenSubUInt(
1761                 totalCash,
1762                 totalBorrows,
1763                 totalReserves
1764             );
1765             //calculate exchange rate
1766             (mathErr, exchangeRate) = getExp(
1767                 cashPlusBorrowsMinusReserves,
1768                 wStableCoin.totalSupply()
1769             );
1770             return (exchangeRate.mantissa);
1771         }
1772     }
1773 
1774     /**
1775      @notice Accrue interest then return the up-to-date exchange rate
1776      @return Calculated exchange rate scaled by 1e18
1777      **/
1778     function exchangeRateCurrent() public returns (uint256) {
1779         accrueInterest();
1780 
1781         if (wStableCoin.totalSupply() == 0) {
1782             //If there are no tokens minted: exchangeRate = initialExchangeRate
1783             return initialExchangeRateMantissa;
1784         } else {
1785             //Otherwise: exchangeRate = (totalCash + totalBorrows - totalReserves) / totalSupply
1786             uint256 totalCash = getCashPrior(); //get contract asset balance
1787             uint256 cashPlusBorrowsMinusReserves;
1788             Exp memory exchangeRate;
1789             MathError mathErr;
1790             //calculate total value held by contract plus owed to contract
1791             (mathErr, cashPlusBorrowsMinusReserves) = addThenSubUInt(
1792                 totalCash,
1793                 totalBorrows,
1794                 totalReserves
1795             );
1796             //calculate exchange rate
1797             (mathErr, exchangeRate) = getExp(
1798                 cashPlusBorrowsMinusReserves,
1799                 wStableCoin.totalSupply()
1800             );
1801             return (exchangeRate.mantissa);
1802         }
1803     }
1804 
1805     /**
1806     @notice Get cash balance of this cToken in the underlying asset in other contracts
1807     @return The quantity of underlying asset owned by this contract
1808     **/
1809     function getCash() external view returns (uint256) {
1810         return getCashPrior();
1811     }
1812 
1813     //struct used by mint to avoid stack too deep errors
1814     struct MintLocalVars {
1815         MathError mathErr;
1816         uint256 exchangeRateMantissa;
1817         uint256 mintTokens;
1818         bool isMember;
1819     }
1820 
1821     /**
1822     @notice lendToWarpVault is used to lend stablecoin assets to a WaprVault
1823     @param _amount is the amount of the asset being lent
1824     @dev the user will need to first approve the transfer of the underlying asset
1825     **/
1826     function lendToWarpVault(uint256 _amount) public {
1827         //declare struct
1828         MintLocalVars memory vars;
1829         //retrieve exchange rate
1830         vars.exchangeRateMantissa = exchangeRateCurrent();
1831         //We get the current exchange rate and calculate the number of WarpWrapperToken to be minted:
1832         //mintTokens = _amount / exchangeRate
1833         (vars.mathErr, vars.mintTokens) = divScalarByExpTruncate(
1834             _amount,
1835             Exp({mantissa: vars.exchangeRateMantissa})
1836         );
1837 
1838         //transfer appropriate amount of DAI from msg.sender to the Vault
1839         stablecoin.transferFrom(msg.sender, address(this), _amount);
1840 
1841         principalBalance[msg.sender] = principalBalance[msg.sender] + _amount;
1842 
1843 
1844         //mint appropriate Warp DAI
1845         wStableCoin.mint(msg.sender, vars.mintTokens);
1846         emit StableCoinLent(msg.sender, _amount, vars.mintTokens);
1847     }
1848 
1849     struct RedeemLocalVars {
1850         MathError mathErr;
1851         uint256 exchangeRateMantissa;
1852         uint256 burnTokens;
1853         uint256 currentWarpBalance;
1854         uint256 currentCoinBalance;
1855         uint256 principalRedeemed;
1856         uint256 amount;
1857     }
1858 
1859     /**
1860     @notice redeem allows a user to redeem their Warp Wrapper Token for the appropriate amount of underlying stablecoin asset
1861     @param _amount is the amount of StableCoin the user wishes to exchange
1862     **/
1863     function redeem(uint256 _amount) public  {
1864 
1865         RedeemLocalVars memory vars;
1866         //retreive the users current Warp Wrapper balance
1867         vars.currentWarpBalance = wStableCoin.balanceOf(msg.sender);
1868         //retreive current exchange rate
1869         vars.exchangeRateMantissa = exchangeRateCurrent();
1870 
1871         (vars.mathErr, vars.currentCoinBalance) = mulScalarTruncate(
1872           Exp({mantissa: vars.exchangeRateMantissa}),
1873           vars.currentWarpBalance
1874         );
1875           if(_amount == 0) {
1876                 vars.amount = vars.currentCoinBalance;
1877             } else {
1878                 vars.amount = _amount;
1879             }
1880           //We get the current exchange rate and calculate the number of WarpWrapperToken to be burned:
1881           //burnTokens = _amount / exchangeRate
1882           (vars.mathErr, vars.burnTokens) = divScalarByExpTruncate(
1883               vars.amount,
1884               Exp({mantissa: vars.exchangeRateMantissa})
1885           );
1886           //require the vault has enough stablecoin
1887         require(stablecoin.balanceOf(address(this)) >= vars.amount, "Not enough stablecoin in vault.");
1888         //calculate the users current stablecoin balance
1889 
1890         //calculate and record balances for historical tracking
1891         uint256 currentStableCoinReward = 0;
1892         if (vars.currentCoinBalance > principalBalance[msg.sender]) {
1893             currentStableCoinReward = vars.currentCoinBalance.sub(principalBalance[msg.sender]);
1894         }
1895         vars.principalRedeemed = vars.amount.sub(currentStableCoinReward);
1896 
1897         if (vars.amount >= currentStableCoinReward) {
1898             historicalReward[msg.sender] = historicalReward[msg.sender].add(currentStableCoinReward);
1899             require(vars.principalRedeemed <= principalBalance[msg.sender], "Error calculating reward.");
1900             principalBalance[msg.sender] = principalBalance[msg.sender].sub(vars.principalRedeemed);
1901         } else {
1902             historicalReward[msg.sender] = historicalReward[msg.sender].add(vars.amount);
1903         }
1904         wStableCoin.burn(msg.sender, vars.burnTokens);
1905         stablecoin.transfer(msg.sender, vars.amount);
1906         emit StableCoinLent(msg.sender, vars.amount, vars.burnTokens);
1907     }
1908 
1909     /**
1910     @notice viewAccountBalance is used to view the current balance of an account
1911     @param _account is the account whos balance is being viewed
1912     **/
1913     function viewAccountBalance(address _account) public view returns (uint256) {
1914         uint256 exchangeRate = exchangeRatePrior();
1915         uint256 accountBalance = wStableCoin.balanceOf(_account);
1916 
1917         MathError mathError;
1918         uint256 balance;
1919        (mathError, balance) =  mulScalarTruncate(
1920             Exp({mantissa: exchangeRate}),
1921             accountBalance
1922         );
1923 
1924         return balance;
1925     }
1926 
1927     /**
1928     @notice viewHistoricalReward is used to view the total gains of an account
1929     @param _account is the account whos gains are being viewed 
1930     **/
1931     function viewHistoricalReward(address _account) public view returns (uint256) {
1932         uint256 exchangeRate = exchangeRatePrior();
1933         uint256 currentWarpBalance = wStableCoin.balanceOf(_account);
1934         uint256 principal = principalBalance[_account];
1935 
1936         if (currentWarpBalance == 0) {
1937             return historicalReward[_account];
1938         }
1939 
1940         MathError mathError;
1941         uint256 currentStableCoinBalance;
1942         (mathError, currentStableCoinBalance) =  mulScalarTruncate(
1943             Exp({mantissa: exchangeRate}),
1944             currentWarpBalance
1945         );
1946 
1947         uint256 currentGains = currentStableCoinBalance.sub(principal);
1948         uint256 totalGains = currentGains.add(historicalReward[_account]);
1949 
1950         return totalGains;
1951     }
1952 
1953     //struct used by borrow function to avoid stack too deep errors
1954     struct BorrowLocalVars {
1955         MathError mathErr;
1956         uint256 accountBorrows;
1957         uint256 accountBorrowsNew;
1958         uint256 totalBorrowsNew;
1959     }
1960 
1961     /**
1962     @notice Sender borrows stablecoin assets from the protocol to their own address
1963     @param _borrowAmount The amount of the underlying asset to borrow
1964     */
1965     function _borrow(uint256 _borrowAmount, address _borrower) external onlyWC angryWizard{
1966         //create local vars storage
1967         BorrowLocalVars memory vars;
1968 
1969         //Fail if protocol has insufficient underlying cash
1970         require(getCashPrior() > _borrowAmount, "Not enough tokens to lend");
1971         //calculate the new borrower and total borrow balances, failing on overflow:
1972         vars.accountBorrows = borrowBalancePrior(_borrower);
1973         //accountBorrowsNew = accountBorrows + borrowAmount
1974         (vars.mathErr, vars.accountBorrowsNew) = addUInt(
1975             vars.accountBorrows,
1976             _borrowAmount
1977         );
1978         //totalBorrowsNew = totalBorrows + borrowAmount
1979         (vars.mathErr, vars.totalBorrowsNew) = addUInt(
1980             totalBorrows,
1981             _borrowAmount
1982         );
1983         //We write the previously calculated values into storage
1984         accountBorrows[_borrower].principal = vars.accountBorrowsNew;
1985         accountBorrows[_borrower].interestIndex = borrowIndex;
1986         totalBorrows = vars.totalBorrowsNew;
1987         //send them their loaned asset
1988         stablecoin.transfer(_borrower, _borrowAmount);
1989     }
1990 
1991     struct RepayBorrowLocalVars {
1992         MathError mathErr;
1993         uint256 repayAmount;
1994         uint256 borrowerIndex;
1995         uint256 accountBorrows;
1996         uint256 accountBorrowsNew;
1997         uint256 totalBorrowsNew;
1998         uint256 totalOwed;
1999         uint256 borrowPrinciple;
2000         uint256 interestPayed;
2001     }
2002 
2003     /**
2004     @notice Sender repays their own borrow
2005     @param _repayAmount The amount to repay
2006     */
2007     function repayBorrow(uint256 _repayAmount) public angryWizard{
2008         //create local vars storage
2009         RepayBorrowLocalVars memory vars;
2010 
2011         //We fetch the amount the borrower owes, with accumulated interest
2012         vars.accountBorrows = borrowBalanceCurrent(msg.sender);
2013         //require the borrower cant pay more than they owe
2014         require(_repayAmount <= vars.accountBorrows, "You are trying to pay back more than you owe");
2015 
2016         //If repayAmount == 0, repayAmount = accountBorrows
2017         if (_repayAmount == 0) {
2018             vars.repayAmount = vars.accountBorrows;
2019         } else {
2020             vars.repayAmount = _repayAmount;
2021         }
2022 
2023         require(stablecoin.balanceOf(msg.sender) >= vars.repayAmount, "Not enough stablecoin to repay");
2024         //transfer the stablecoin from the borrower
2025         stablecoin.transferFrom(msg.sender, address(this), vars.repayAmount);
2026 
2027         //We calculate the new borrower and total borrow balances
2028         //accountBorrowsNew = accountBorrows - actualRepayAmount
2029         (vars.mathErr, vars.accountBorrowsNew) = subUInt(
2030             vars.accountBorrows,
2031             vars.repayAmount
2032         );
2033         require(vars.mathErr == MathError.NO_ERROR, "Repay borrow new account balance calculation failed");
2034 
2035         //totalBorrowsNew = totalBorrows - actualRepayAmount
2036         (vars.mathErr, vars.totalBorrowsNew) = subUInt(
2037             totalBorrows,
2038             vars.repayAmount
2039         );
2040         require(vars.mathErr == MathError.NO_ERROR, "Repay borrow new total balance calculation failed");
2041 
2042         /* We write the previously calculated values into storage */
2043         totalBorrows = vars.totalBorrowsNew;
2044         accountBorrows[msg.sender].principal = vars.accountBorrowsNew;
2045         accountBorrows[msg.sender].interestIndex = borrowIndex;
2046 
2047 
2048         emit LoanRepayed(msg.sender, _repayAmount, accountBorrows[msg.sender].principal, accountBorrows[msg.sender].interestIndex);
2049     }
2050 
2051     /**
2052     @notice repayLiquidatedLoan is a function used by the Warp Control contract to repay a loan on behalf of a liquidator
2053     @param _borrower is the address of the borrower who took out the loan
2054     @param _liquidator is the address of the account who is liquidating the loan
2055     @param _amount is the amount of StableCoin being repayed
2056     @dev this function uses the onlyWC modifier which means it can only be called by the Warp Control contract
2057     **/
2058     function _repayLiquidatedLoan(
2059         address _borrower,
2060         address _liquidator,
2061         uint256 _amount
2062     ) public onlyWC angryWizard{
2063       stablecoin.transferFrom(_liquidator, address(this), _amount);
2064         //calculate the fee on the principle received
2065         uint256 fee = calculateFee(_amount);
2066         //transfer fee amount to Warp team
2067         totalReserves = totalReserves.add(fee);
2068         // Clear the borrowers loan
2069         accountBorrows[_borrower].principal = 0;
2070         accountBorrows[_borrower].interestIndex = 0;
2071         totalBorrows = totalBorrows.sub(_amount);
2072 
2073         //transfer the owed amount of stablecoin from the borrower to this contract
2074     }
2075 
2076 
2077 }