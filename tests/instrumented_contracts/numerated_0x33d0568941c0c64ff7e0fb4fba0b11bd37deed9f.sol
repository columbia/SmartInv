1 // File: @openzeppelin/contracts/GSN/Context.sol
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
28 // File: @openzeppelin/contracts/access/Ownable.sol
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
98 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
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
178 // File: @openzeppelin/contracts/math/SafeMath.sol
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
340 // File: @openzeppelin/contracts/utils/Address.sol
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
368         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
369         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
370         // for accounts without code, i.e. `keccak256('')`
371         bytes32 codehash;
372         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
373         // solhint-disable-next-line no-inline-assembly
374         assembly { codehash := extcodehash(account) }
375         return (codehash != accountHash && codehash != 0x0);
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
484 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
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
523     mapping (address => mapping (address => uint256)) private _allowances;
524 
525     uint256 private _totalSupply;
526 
527     string private _name;
528     string private _symbol;
529     uint8 private _decimals;
530 
531     /**
532      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
533      * a default value of 18.
534      *
535      * To select a different value for {decimals}, use {_setupDecimals}.
536      *
537      * All three of these values are immutable: they can only be set once during
538      * construction.
539      */
540     constructor (string memory name, string memory symbol) public {
541         _name = name;
542         _symbol = symbol;
543         _decimals = 18;
544     }
545 
546     /**
547      * @dev Returns the name of the token.
548      */
549     function name() public view returns (string memory) {
550         return _name;
551     }
552 
553     /**
554      * @dev Returns the symbol of the token, usually a shorter version of the
555      * name.
556      */
557     function symbol() public view returns (string memory) {
558         return _symbol;
559     }
560 
561     /**
562      * @dev Returns the number of decimals used to get its user representation.
563      * For example, if `decimals` equals `2`, a balance of `505` tokens should
564      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
565      *
566      * Tokens usually opt for a value of 18, imitating the relationship between
567      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
568      * called.
569      *
570      * NOTE: This information is only used for _display_ purposes: it in
571      * no way affects any of the arithmetic of the contract, including
572      * {IERC20-balanceOf} and {IERC20-transfer}.
573      */
574     function decimals() public view returns (uint8) {
575         return _decimals;
576     }
577 
578     /**
579      * @dev See {IERC20-totalSupply}.
580      */
581     function totalSupply() public view override returns (uint256) {
582         return _totalSupply;
583     }
584 
585     /**
586      * @dev See {IERC20-balanceOf}.
587      */
588     function balanceOf(address account) public view override returns (uint256) {
589         return _balances[account];
590     }
591 
592     /**
593      * @dev See {IERC20-transfer}.
594      *
595      * Requirements:
596      *
597      * - `recipient` cannot be the zero address.
598      * - the caller must have a balance of at least `amount`.
599      */
600     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
601         _transfer(_msgSender(), recipient, amount);
602         return true;
603     }
604 
605     /**
606      * @dev See {IERC20-allowance}.
607      */
608     function allowance(address owner, address spender) public view virtual override returns (uint256) {
609         return _allowances[owner][spender];
610     }
611 
612     /**
613      * @dev See {IERC20-approve}.
614      *
615      * Requirements:
616      *
617      * - `spender` cannot be the zero address.
618      */
619     function approve(address spender, uint256 amount) public virtual override returns (bool) {
620         _approve(_msgSender(), spender, amount);
621         return true;
622     }
623 
624     /**
625      * @dev See {IERC20-transferFrom}.
626      *
627      * Emits an {Approval} event indicating the updated allowance. This is not
628      * required by the EIP. See the note at the beginning of {ERC20};
629      *
630      * Requirements:
631      * - `sender` and `recipient` cannot be the zero address.
632      * - `sender` must have a balance of at least `amount`.
633      * - the caller must have allowance for ``sender``'s tokens of at least
634      * `amount`.
635      */
636     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
637         _transfer(sender, recipient, amount);
638         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
639         return true;
640     }
641 
642     /**
643      * @dev Atomically increases the allowance granted to `spender` by the caller.
644      *
645      * This is an alternative to {approve} that can be used as a mitigation for
646      * problems described in {IERC20-approve}.
647      *
648      * Emits an {Approval} event indicating the updated allowance.
649      *
650      * Requirements:
651      *
652      * - `spender` cannot be the zero address.
653      */
654     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
655         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
656         return true;
657     }
658 
659     /**
660      * @dev Atomically decreases the allowance granted to `spender` by the caller.
661      *
662      * This is an alternative to {approve} that can be used as a mitigation for
663      * problems described in {IERC20-approve}.
664      *
665      * Emits an {Approval} event indicating the updated allowance.
666      *
667      * Requirements:
668      *
669      * - `spender` cannot be the zero address.
670      * - `spender` must have allowance for the caller of at least
671      * `subtractedValue`.
672      */
673     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
674         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
675         return true;
676     }
677 
678     /**
679      * @dev Moves tokens `amount` from `sender` to `recipient`.
680      *
681      * This is internal function is equivalent to {transfer}, and can be used to
682      * e.g. implement automatic token fees, slashing mechanisms, etc.
683      *
684      * Emits a {Transfer} event.
685      *
686      * Requirements:
687      *
688      * - `sender` cannot be the zero address.
689      * - `recipient` cannot be the zero address.
690      * - `sender` must have a balance of at least `amount`.
691      */
692     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
693         require(sender != address(0), "ERC20: transfer from the zero address");
694         require(recipient != address(0), "ERC20: transfer to the zero address");
695 
696         _beforeTokenTransfer(sender, recipient, amount);
697 
698         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
699         _balances[recipient] = _balances[recipient].add(amount);
700         emit Transfer(sender, recipient, amount);
701     }
702 
703     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
704      * the total supply.
705      *
706      * Emits a {Transfer} event with `from` set to the zero address.
707      *
708      * Requirements
709      *
710      * - `to` cannot be the zero address.
711      */
712     function _mint(address account, uint256 amount) internal virtual {
713         require(account != address(0), "ERC20: mint to the zero address");
714 
715         _beforeTokenTransfer(address(0), account, amount);
716 
717         _totalSupply = _totalSupply.add(amount);
718         _balances[account] = _balances[account].add(amount);
719         emit Transfer(address(0), account, amount);
720     }
721 
722     /**
723      * @dev Destroys `amount` tokens from `account`, reducing the
724      * total supply.
725      *
726      * Emits a {Transfer} event with `to` set to the zero address.
727      *
728      * Requirements
729      *
730      * - `account` cannot be the zero address.
731      * - `account` must have at least `amount` tokens.
732      */
733     function _burn(address account, uint256 amount) internal virtual {
734         require(account != address(0), "ERC20: burn from the zero address");
735 
736         _beforeTokenTransfer(account, address(0), amount);
737 
738         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
739         _totalSupply = _totalSupply.sub(amount);
740         emit Transfer(account, address(0), amount);
741     }
742 
743     /**
744      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
745      *
746      * This is internal function is equivalent to `approve`, and can be used to
747      * e.g. set automatic allowances for certain subsystems, etc.
748      *
749      * Emits an {Approval} event.
750      *
751      * Requirements:
752      *
753      * - `owner` cannot be the zero address.
754      * - `spender` cannot be the zero address.
755      */
756     function _approve(address owner, address spender, uint256 amount) internal virtual {
757         require(owner != address(0), "ERC20: approve from the zero address");
758         require(spender != address(0), "ERC20: approve to the zero address");
759 
760         _allowances[owner][spender] = amount;
761         emit Approval(owner, spender, amount);
762     }
763 
764     /**
765      * @dev Sets {decimals} to a value other than the default one of 18.
766      *
767      * WARNING: This function should only be called from the constructor. Most
768      * applications that interact with token contracts will not expect
769      * {decimals} to ever change, and may work incorrectly if it does.
770      */
771     function _setupDecimals(uint8 decimals_) internal {
772         _decimals = decimals_;
773     }
774 
775     /**
776      * @dev Hook that is called before any transfer of tokens. This includes
777      * minting and burning.
778      *
779      * Calling conditions:
780      *
781      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
782      * will be to transferred to `to`.
783      * - when `from` is zero, `amount` tokens will be minted for `to`.
784      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
785      * - `from` and `to` are never both zero.
786      *
787      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
788      */
789     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
790 }
791 
792 // File: @openzeppelin/contracts/utils/Pausable.sol
793 
794 // SPDX-License-Identifier: MIT
795 
796 pragma solidity ^0.6.0;
797 
798 
799 /**
800  * @dev Contract module which allows children to implement an emergency stop
801  * mechanism that can be triggered by an authorized account.
802  *
803  * This module is used through inheritance. It will make available the
804  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
805  * the functions of your contract. Note that they will not be pausable by
806  * simply including this module, only once the modifiers are put in place.
807  */
808 contract Pausable is Context {
809     /**
810      * @dev Emitted when the pause is triggered by `account`.
811      */
812     event Paused(address account);
813 
814     /**
815      * @dev Emitted when the pause is lifted by `account`.
816      */
817     event Unpaused(address account);
818 
819     bool private _paused;
820 
821     /**
822      * @dev Initializes the contract in unpaused state.
823      */
824     constructor () internal {
825         _paused = false;
826     }
827 
828     /**
829      * @dev Returns true if the contract is paused, and false otherwise.
830      */
831     function paused() public view returns (bool) {
832         return _paused;
833     }
834 
835     /**
836      * @dev Modifier to make a function callable only when the contract is not paused.
837      *
838      * Requirements:
839      *
840      * - The contract must not be paused.
841      */
842     modifier whenNotPaused() {
843         require(!_paused, "Pausable: paused");
844         _;
845     }
846 
847     /**
848      * @dev Modifier to make a function callable only when the contract is paused.
849      *
850      * Requirements:
851      *
852      * - The contract must be paused.
853      */
854     modifier whenPaused() {
855         require(_paused, "Pausable: not paused");
856         _;
857     }
858 
859     /**
860      * @dev Triggers stopped state.
861      *
862      * Requirements:
863      *
864      * - The contract must not be paused.
865      */
866     function _pause() internal virtual whenNotPaused {
867         _paused = true;
868         emit Paused(_msgSender());
869     }
870 
871     /**
872      * @dev Returns to normal state.
873      *
874      * Requirements:
875      *
876      * - The contract must be paused.
877      */
878     function _unpause() internal virtual whenPaused {
879         _paused = false;
880         emit Unpaused(_msgSender());
881     }
882 }
883 
884 // File: @openzeppelin/contracts/token/ERC20/ERC20Pausable.sol
885 
886 // SPDX-License-Identifier: MIT
887 
888 pragma solidity ^0.6.0;
889 
890 
891 
892 /**
893  * @dev ERC20 token with pausable token transfers, minting and burning.
894  *
895  * Useful for scenarios such as preventing trades until the end of an evaluation
896  * period, or having an emergency switch for freezing all token transfers in the
897  * event of a large bug.
898  */
899 abstract contract ERC20Pausable is ERC20, Pausable {
900     /**
901      * @dev See {ERC20-_beforeTokenTransfer}.
902      *
903      * Requirements:
904      *
905      * - the contract must not be paused.
906      */
907     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
908         super._beforeTokenTransfer(from, to, amount);
909 
910         require(!paused(), "ERC20Pausable: token transfer while paused");
911     }
912 }
913 
914 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
915 
916 // SPDX-License-Identifier: MIT
917 
918 pragma solidity ^0.6.0;
919 
920 
921 
922 
923 /**
924  * @title SafeERC20
925  * @dev Wrappers around ERC20 operations that throw on failure (when the token
926  * contract returns false). Tokens that return no value (and instead revert or
927  * throw on failure) are also supported, non-reverting calls are assumed to be
928  * successful.
929  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
930  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
931  */
932 library SafeERC20 {
933     using SafeMath for uint256;
934     using Address for address;
935 
936     function safeTransfer(IERC20 token, address to, uint256 value) internal {
937         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
938     }
939 
940     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
941         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
942     }
943 
944     /**
945      * @dev Deprecated. This function has issues similar to the ones found in
946      * {IERC20-approve}, and its usage is discouraged.
947      *
948      * Whenever possible, use {safeIncreaseAllowance} and
949      * {safeDecreaseAllowance} instead.
950      */
951     function safeApprove(IERC20 token, address spender, uint256 value) internal {
952         // safeApprove should only be called when setting an initial allowance,
953         // or when resetting it to zero. To increase and decrease it, use
954         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
955         // solhint-disable-next-line max-line-length
956         require((value == 0) || (token.allowance(address(this), spender) == 0),
957             "SafeERC20: approve from non-zero to non-zero allowance"
958         );
959         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
960     }
961 
962     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
963         uint256 newAllowance = token.allowance(address(this), spender).add(value);
964         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
965     }
966 
967     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
968         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
969         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
970     }
971 
972     /**
973      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
974      * on the return value: the return value is optional (but if data is returned, it must not be false).
975      * @param token The token targeted by the call.
976      * @param data The call data (encoded using abi.encode or one of its variants).
977      */
978     function _callOptionalReturn(IERC20 token, bytes memory data) private {
979         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
980         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
981         // the target address contains contract code and also asserts for success in the low-level call.
982 
983         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
984         if (returndata.length > 0) { // Return data is optional
985             // solhint-disable-next-line max-line-length
986             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
987         }
988     }
989 }
990 
991 // File: contracts/Token.sol
992 
993 //SPDX-License-Identifier: MIT
994 
995 pragma solidity ^0.6.0;
996 
997 
998 
999 
1000 contract Token is Ownable, ERC20Pausable {
1001     using SafeERC20 for ERC20Pausable;
1002 
1003     constructor(
1004         address farmingAddress,
1005         address privateSaleAddress,
1006         address protocolAddress,
1007         address publicSaleAddress,
1008         address teamAddress
1009     )
1010         public
1011         ERC20(
1012             "RAMP DEFI",        // Name
1013             "RAMP"              // Symbol
1014         )
1015     {
1016         _mint(
1017             farmingAddress,                               // Farming Reserves multisig
1018             450000000e18                                  // 450,000,000 RAMP
1019         );
1020         _mint(
1021             privateSaleAddress,                           // Private Sale multisig
1022             180000000e18                                  // 180,000,000 RAMP
1023         );
1024         _mint(
1025             protocolAddress,                              // Protocol Reserves multisig
1026             200000000e18                                  // 200,000,000 RAMP
1027         );
1028         _mint(
1029             publicSaleAddress,                            // Public Sale multisig
1030             10000000e18                                   // 10,000,000 RAMP
1031         );
1032         _mint(
1033             teamAddress,                                  // Team multisig
1034             160000000e18                                  // 160,000,000 RAMP
1035         );
1036 
1037         transferOwnership(teamAddress);                   // Transfer ownership to the Team multisig
1038     }
1039 
1040     /**
1041      * @dev called by the owner to pause, triggers stopped state
1042      */
1043     function pause() onlyOwner whenNotPaused public {
1044         _pause();
1045     }
1046 
1047     /**
1048      * @dev called by the owner to unpause, returns to normal state
1049      */
1050     function unpause() onlyOwner whenPaused public {
1051         _unpause();
1052     }
1053 }