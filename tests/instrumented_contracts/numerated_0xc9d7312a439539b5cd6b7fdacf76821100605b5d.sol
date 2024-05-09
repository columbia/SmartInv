1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.6.0;
4 
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 // File: @openzeppelin/contracts/access/Ownable.sol
28 
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
97 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
98 
99 
100 
101 pragma solidity ^0.6.0;
102 
103 /**
104  * @dev Interface of the ERC20 standard as defined in the EIP.
105  */
106 interface IERC20 {
107     /**
108      * @dev Returns the amount of tokens in existence.
109      */
110     function totalSupply() external view returns (uint256);
111 
112     /**
113      * @dev Returns the amount of tokens owned by `account`.
114      */
115     function balanceOf(address account) external view returns (uint256);
116 
117     /**
118      * @dev Moves `amount` tokens from the caller's account to `recipient`.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transfer(address recipient, uint256 amount) external returns (bool);
125 
126     /**
127      * @dev Returns the remaining number of tokens that `spender` will be
128      * allowed to spend on behalf of `owner` through {transferFrom}. This is
129      * zero by default.
130      *
131      * This value changes when {approve} or {transferFrom} are called.
132      */
133     function allowance(address owner, address spender) external view returns (uint256);
134 
135     /**
136      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * IMPORTANT: Beware that changing an allowance with this method brings the risk
141      * that someone may use both the old and the new allowance by unfortunate
142      * transaction ordering. One possible solution to mitigate this race
143      * condition is to first reduce the spender's allowance to 0 and set the
144      * desired value afterwards:
145      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
146      *
147      * Emits an {Approval} event.
148      */
149     function approve(address spender, uint256 amount) external returns (bool);
150 
151     /**
152      * @dev Moves `amount` tokens from `sender` to `recipient` using the
153      * allowance mechanism. `amount` is then deducted from the caller's
154      * allowance.
155      *
156      * Returns a boolean value indicating whether the operation succeeded.
157      *
158      * Emits a {Transfer} event.
159      */
160     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
161 
162     /**
163      * @dev Emitted when `value` tokens are moved from one account (`from`) to
164      * another (`to`).
165      *
166      * Note that `value` may be zero.
167      */
168     event Transfer(address indexed from, address indexed to, uint256 value);
169 
170     /**
171      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
172      * a call to {approve}. `value` is the new allowance.
173      */
174     event Approval(address indexed owner, address indexed spender, uint256 value);
175 }
176 
177 // File: @openzeppelin/contracts/math/SafeMath.sol
178 
179 
180 
181 pragma solidity ^0.6.0;
182 
183 /**
184  * @dev Wrappers over Solidity's arithmetic operations with added overflow
185  * checks.
186  *
187  * Arithmetic operations in Solidity wrap on overflow. This can easily result
188  * in bugs, because programmers usually assume that an overflow raises an
189  * error, which is the standard behavior in high level programming languages.
190  * `SafeMath` restores this intuition by reverting the transaction when an
191  * operation overflows.
192  *
193  * Using this library instead of the unchecked operations eliminates an entire
194  * class of bugs, so it's recommended to use it always.
195  */
196 library SafeMath {
197     /**
198      * @dev Returns the addition of two unsigned integers, reverting on
199      * overflow.
200      *
201      * Counterpart to Solidity's `+` operator.
202      *
203      * Requirements:
204      *
205      * - Addition cannot overflow.
206      */
207     function add(uint256 a, uint256 b) internal pure returns (uint256) {
208         uint256 c = a + b;
209         require(c >= a, "SafeMath: addition overflow");
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the subtraction of two unsigned integers, reverting on
216      * overflow (when the result is negative).
217      *
218      * Counterpart to Solidity's `-` operator.
219      *
220      * Requirements:
221      *
222      * - Subtraction cannot overflow.
223      */
224     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
225         return sub(a, b, "SafeMath: subtraction overflow");
226     }
227 
228     /**
229      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
230      * overflow (when the result is negative).
231      *
232      * Counterpart to Solidity's `-` operator.
233      *
234      * Requirements:
235      *
236      * - Subtraction cannot overflow.
237      */
238     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
239         require(b <= a, errorMessage);
240         uint256 c = a - b;
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the multiplication of two unsigned integers, reverting on
247      * overflow.
248      *
249      * Counterpart to Solidity's `*` operator.
250      *
251      * Requirements:
252      *
253      * - Multiplication cannot overflow.
254      */
255     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
256         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
257         // benefit is lost if 'b' is also tested.
258         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
259         if (a == 0) {
260             return 0;
261         }
262 
263         uint256 c = a * b;
264         require(c / a == b, "SafeMath: multiplication overflow");
265 
266         return c;
267     }
268 
269     /**
270      * @dev Returns the integer division of two unsigned integers. Reverts on
271      * division by zero. The result is rounded towards zero.
272      *
273      * Counterpart to Solidity's `/` operator. Note: this function uses a
274      * `revert` opcode (which leaves remaining gas untouched) while Solidity
275      * uses an invalid opcode to revert (consuming all remaining gas).
276      *
277      * Requirements:
278      *
279      * - The divisor cannot be zero.
280      */
281     function div(uint256 a, uint256 b) internal pure returns (uint256) {
282         return div(a, b, "SafeMath: division by zero");
283     }
284 
285     /**
286      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
287      * division by zero. The result is rounded towards zero.
288      *
289      * Counterpart to Solidity's `/` operator. Note: this function uses a
290      * `revert` opcode (which leaves remaining gas untouched) while Solidity
291      * uses an invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         require(b > 0, errorMessage);
299         uint256 c = a / b;
300         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
301 
302         return c;
303     }
304 
305     /**
306      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
307      * Reverts when dividing by zero.
308      *
309      * Counterpart to Solidity's `%` operator. This function uses a `revert`
310      * opcode (which leaves remaining gas untouched) while Solidity uses an
311      * invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
318         return mod(a, b, "SafeMath: modulo by zero");
319     }
320 
321     /**
322      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
323      * Reverts with custom message when dividing by zero.
324      *
325      * Counterpart to Solidity's `%` operator. This function uses a `revert`
326      * opcode (which leaves remaining gas untouched) while Solidity uses an
327      * invalid opcode to revert (consuming all remaining gas).
328      *
329      * Requirements:
330      *
331      * - The divisor cannot be zero.
332      */
333     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
334         require(b != 0, errorMessage);
335         return a % b;
336     }
337 }
338 
339 // File: @openzeppelin/contracts/utils/Address.sol
340 
341 
342 
343 pragma solidity ^0.6.2;
344 
345 /**
346  * @dev Collection of functions related to the address type
347  */
348 library Address {
349     /**
350      * @dev Returns true if `account` is a contract.
351      *
352      * [IMPORTANT]
353      * ====
354      * It is unsafe to assume that an address for which this function returns
355      * false is an externally-owned account (EOA) and not a contract.
356      *
357      * Among others, `isContract` will return false for the following
358      * types of addresses:
359      *
360      *  - an externally-owned account
361      *  - a contract in construction
362      *  - an address where a contract will be created
363      *  - an address where a contract lived, but was destroyed
364      * ====
365      */
366     function isContract(address account) internal view returns (bool) {
367         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
368         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
369         // for accounts without code, i.e. `keccak256('')`
370         bytes32 codehash;
371         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
372         // solhint-disable-next-line no-inline-assembly
373         assembly { codehash := extcodehash(account) }
374         return (codehash != accountHash && codehash != 0x0);
375     }
376 
377     /**
378      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
379      * `recipient`, forwarding all available gas and reverting on errors.
380      *
381      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
382      * of certain opcodes, possibly making contracts go over the 2300 gas limit
383      * imposed by `transfer`, making them unable to receive funds via
384      * `transfer`. {sendValue} removes this limitation.
385      *
386      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
387      *
388      * IMPORTANT: because control is transferred to `recipient`, care must be
389      * taken to not create reentrancy vulnerabilities. Consider using
390      * {ReentrancyGuard} or the
391      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
392      */
393     function sendValue(address payable recipient, uint256 amount) internal {
394         require(address(this).balance >= amount, "Address: insufficient balance");
395 
396         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
397         (bool success, ) = recipient.call{ value: amount }("");
398         require(success, "Address: unable to send value, recipient may have reverted");
399     }
400 
401     /**
402      * @dev Performs a Solidity function call using a low level `call`. A
403      * plain`call` is an unsafe replacement for a function call: use this
404      * function instead.
405      *
406      * If `target` reverts with a revert reason, it is bubbled up by this
407      * function (like regular Solidity function calls).
408      *
409      * Returns the raw returned data. To convert to the expected return value,
410      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
411      *
412      * Requirements:
413      *
414      * - `target` must be a contract.
415      * - calling `target` with `data` must not revert.
416      *
417      * _Available since v3.1._
418      */
419     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
420       return functionCall(target, data, "Address: low-level call failed");
421     }
422 
423     /**
424      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
425      * `errorMessage` as a fallback revert reason when `target` reverts.
426      *
427      * _Available since v3.1._
428      */
429     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
430         return _functionCallWithValue(target, data, 0, errorMessage);
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
435      * but also transferring `value` wei to `target`.
436      *
437      * Requirements:
438      *
439      * - the calling contract must have an ETH balance of at least `value`.
440      * - the called Solidity function must be `payable`.
441      *
442      * _Available since v3.1._
443      */
444     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
445         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
446     }
447 
448     /**
449      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
450      * with `errorMessage` as a fallback revert reason when `target` reverts.
451      *
452      * _Available since v3.1._
453      */
454     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
455         require(address(this).balance >= value, "Address: insufficient balance for call");
456         return _functionCallWithValue(target, data, value, errorMessage);
457     }
458 
459     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
460         require(isContract(target), "Address: call to non-contract");
461 
462         // solhint-disable-next-line avoid-low-level-calls
463         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
464         if (success) {
465             return returndata;
466         } else {
467             // Look for revert reason and bubble it up if present
468             if (returndata.length > 0) {
469                 // The easiest way to bubble the revert reason is using memory via assembly
470 
471                 // solhint-disable-next-line no-inline-assembly
472                 assembly {
473                     let returndata_size := mload(returndata)
474                     revert(add(32, returndata), returndata_size)
475                 }
476             } else {
477                 revert(errorMessage);
478             }
479         }
480     }
481 }
482 
483 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
484 
485 
486 
487 pragma solidity ^0.6.0;
488 
489 
490 
491 
492 
493 /**
494  * @dev Implementation of the {IERC20} interface.
495  *
496  * This implementation is agnostic to the way tokens are created. This means
497  * that a supply mechanism has to be added in a derived contract using {_mint}.
498  * For a generic mechanism see {ERC20PresetMinterPauser}.
499  *
500  * TIP: For a detailed writeup see our guide
501  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
502  * to implement supply mechanisms].
503  *
504  * We have followed general OpenZeppelin guidelines: functions revert instead
505  * of returning `false` on failure. This behavior is nonetheless conventional
506  * and does not conflict with the expectations of ERC20 applications.
507  *
508  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
509  * This allows applications to reconstruct the allowance for all accounts just
510  * by listening to said events. Other implementations of the EIP may not emit
511  * these events, as it isn't required by the specification.
512  *
513  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
514  * functions have been added to mitigate the well-known issues around setting
515  * allowances. See {IERC20-approve}.
516  */
517 contract ERC20 is Context, IERC20 {
518     using SafeMath for uint256;
519     using Address for address;
520 
521     mapping (address => uint256) private _balances;
522 
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
792 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
793 
794 
795 
796 pragma solidity ^0.6.0;
797 
798 
799 
800 /**
801  * @dev Extension of {ERC20} that allows token holders to destroy both their own
802  * tokens and those that they have an allowance for, in a way that can be
803  * recognized off-chain (via event analysis).
804  */
805 abstract contract ERC20Burnable is Context, ERC20 {
806     /**
807      * @dev Destroys `amount` tokens from the caller.
808      *
809      * See {ERC20-_burn}.
810      */
811     function burn(uint256 amount) public virtual {
812         _burn(_msgSender(), amount);
813     }
814 
815     /**
816      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
817      * allowance.
818      *
819      * See {ERC20-_burn} and {ERC20-allowance}.
820      *
821      * Requirements:
822      *
823      * - the caller must have allowance for ``accounts``'s tokens of at least
824      * `amount`.
825      */
826     function burnFrom(address account, uint256 amount) public virtual {
827         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
828 
829         _approve(account, _msgSender(), decreasedAllowance);
830         _burn(account, amount);
831     }
832 }
833 
834 // File: contracts/governance.sol
835 
836 pragma solidity ^0.6.0;
837 pragma experimental ABIEncoderV2;
838 
839 
840 
841 abstract contract DeligateERC20 is ERC20Burnable {
842     /// @notice A record of each accounts delegate
843     mapping (address => address) internal _delegates;
844 
845     /// @notice A checkpoint for marking number of votes from a given block
846     struct Checkpoint {
847         uint32 fromBlock;
848         uint256 votes;
849     }
850 
851     /// @notice A record of votes checkpoints for each account, by index
852     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
853 
854     /// @notice The number of checkpoints for each account
855     mapping (address => uint32) public numCheckpoints;
856 
857     /// @notice The EIP-712 typehash for the contract's domain
858     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
859 
860     /// @notice The EIP-712 typehash for the delegation struct used by the contract
861     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
862 
863     /// @notice A record of states for signing / validating signatures
864     mapping (address => uint) public nonces;
865 
866 
867     // support delegates mint
868     function _mint(address account, uint256 amount) internal override virtual {
869         super._mint(account, amount);
870 
871         // add delegates to the minter
872         _moveDelegates(address(0), _delegates[account], amount);
873     }
874 
875     function _transfer(address sender, address recipient, uint256 amount) internal override virtual {
876         super._transfer(sender, recipient, amount);
877         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
878     }
879 
880 
881     // support delegates burn
882     function burn(uint256 amount) public override virtual {
883         super.burn(amount);
884 
885         // del delegates to backhole
886         _moveDelegates(_delegates[_msgSender()], address(0), amount);
887     }
888 
889     function burnFrom(address account, uint256 amount) public override virtual {
890         super.burnFrom(account, amount);
891 
892         // del delegates to the backhole
893         _moveDelegates(_delegates[account], address(0), amount);
894     }
895     
896     /**
897     * @notice Delegate votes from `msg.sender` to `delegatee`
898     * @param delegatee The address to delegate votes to
899     */
900     function delegate(address delegatee) external {
901         return _delegate(msg.sender, delegatee);
902     }
903 
904     /**
905      * @notice Delegates votes from signatory to `delegatee`
906      * @param delegatee The address to delegate votes to
907      * @param nonce The contract state required to match the signature
908      * @param expiry The time at which to expire the signature
909      * @param v The recovery byte of the signature
910      * @param r Half of the ECDSA signature pair
911      * @param s Half of the ECDSA signature pair
912      */
913     function delegateBySig(
914         address delegatee,
915         uint nonce,
916         uint expiry,
917         uint8 v,
918         bytes32 r,
919         bytes32 s
920     )
921         external
922     {
923         bytes32 domainSeparator = keccak256(
924             abi.encode(
925                 DOMAIN_TYPEHASH,
926                 keccak256(bytes(name())),
927                 getChainId(),
928                 address(this)
929             )
930         );
931 
932         bytes32 structHash = keccak256(
933             abi.encode(
934                 DELEGATION_TYPEHASH,
935                 delegatee,
936                 nonce,
937                 expiry
938             )
939         );
940 
941         bytes32 digest = keccak256(
942             abi.encodePacked(
943                 "\x19\x01",
944                 domainSeparator,
945                 structHash
946             )
947         );
948 
949         address signatory = ecrecover(digest, v, r, s);
950         require(signatory != address(0), "Governance::delegateBySig: invalid signature");
951         require(nonce == nonces[signatory]++, "Governance::delegateBySig: invalid nonce");
952         require(now <= expiry, "Governance::delegateBySig: signature expired");
953         return _delegate(signatory, delegatee);
954     }
955 
956     /**
957      * @notice Gets the current votes balance for `account`
958      * @param account The address to get votes balance
959      * @return The number of current votes for `account`
960      */
961     function getCurrentVotes(address account)
962         external
963         view
964         returns (uint256)
965     {
966         uint32 nCheckpoints = numCheckpoints[account];
967         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
968     }
969 
970     /**
971      * @notice Determine the prior number of votes for an account as of a block number
972      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
973      * @param account The address of the account to check
974      * @param blockNumber The block number to get the vote balance at
975      * @return The number of votes the account had as of the given block
976      */
977     function getPriorVotes(address account, uint blockNumber)
978         external
979         view
980         returns (uint256)
981     {
982         require(blockNumber < block.number, "Governance::getPriorVotes: not yet determined");
983 
984         uint32 nCheckpoints = numCheckpoints[account];
985         if (nCheckpoints == 0) {
986             return 0;
987         }
988 
989         // First check most recent balance
990         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
991             return checkpoints[account][nCheckpoints - 1].votes;
992         }
993 
994         // Next check implicit zero balance
995         if (checkpoints[account][0].fromBlock > blockNumber) {
996             return 0;
997         }
998 
999         uint32 lower = 0;
1000         uint32 upper = nCheckpoints - 1;
1001         while (upper > lower) {
1002             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1003             Checkpoint memory cp = checkpoints[account][center];
1004             if (cp.fromBlock == blockNumber) {
1005                 return cp.votes;
1006             } else if (cp.fromBlock < blockNumber) {
1007                 lower = center;
1008             } else {
1009                 upper = center - 1;
1010             }
1011         }
1012         return checkpoints[account][lower].votes;
1013     }
1014 
1015     function _delegate(address delegator, address delegatee)
1016         internal
1017     {
1018         address currentDelegate = _delegates[delegator];
1019         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying balances (not scaled);
1020         _delegates[delegator] = delegatee;
1021 
1022         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1023 
1024         emit DelegateChanged(delegator, currentDelegate, delegatee);
1025     }
1026 
1027     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1028         if (srcRep != dstRep && amount > 0) {
1029             if (srcRep != address(0)) {
1030                 // decrease old representative
1031                 uint32 srcRepNum = numCheckpoints[srcRep];
1032                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1033                 uint256 srcRepNew = srcRepOld.sub(amount);
1034                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1035             }
1036 
1037             if (dstRep != address(0)) {
1038                 // increase new representative
1039                 uint32 dstRepNum = numCheckpoints[dstRep];
1040                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1041                 uint256 dstRepNew = dstRepOld.add(amount);
1042                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1043             }
1044         }
1045     }
1046 
1047     function _writeCheckpoint(
1048         address delegatee,
1049         uint32 nCheckpoints,
1050         uint256 oldVotes,
1051         uint256 newVotes
1052     )
1053         internal
1054     {
1055         uint32 blockNumber = safe32(block.number, "Governance::_writeCheckpoint: block number exceeds 32 bits");
1056 
1057         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1058             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1059         } else {
1060             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1061             numCheckpoints[delegatee] = nCheckpoints + 1;
1062         }
1063 
1064         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1065     }
1066 
1067     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1068         require(n < 2**32, errorMessage);
1069         return uint32(n);
1070     }
1071 
1072     function getChainId() internal pure returns (uint) {
1073         uint256 chainId;
1074         assembly { chainId := chainid() }
1075         
1076         return chainId;
1077     }
1078 
1079     
1080 
1081     /// @notice An event thats emitted when an account changes its delegate
1082     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
1083 
1084     /// @notice An event thats emitted when a delegate account's vote balance changes
1085     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
1086 
1087 }
1088 
1089 
1090 // SPDX-License-Identifier: DynamicDollar.Finance
1091 
1092 /**
1093  * @author  DynamicDollar.Finance
1094  *
1095  * @dev     Contract for DynamicDollar.Finance token with burn support
1096  */
1097 
1098 pragma solidity ^0.6.0;
1099 
1100 
1101 
1102 contract DynamicDollarFinance is DeligateERC20, Ownable {
1103     uint256 private constant maxSupply      = 210 * 1e3 * 1e18;     // the total supply
1104 
1105     address private _minter;
1106 
1107 
1108     constructor() public ERC20("DynamicDollar.Finance", "DFI") {
1109         _minter = _msgSender();
1110     }
1111 
1112 
1113     // mint with max supply
1114     function mint(address _to, uint256 _amount) public onlyMinter returns (bool) {
1115         if(_amount.add(totalSupply()) > maxSupply) {
1116             return false;
1117         }
1118 
1119         _mint(_to, _amount);
1120         return true;
1121     }
1122 
1123     function setMinter(address _addr) external onlyOwner {
1124         _minter = _addr;
1125     }
1126 
1127 
1128     function isMinter(address account) public view returns (bool) {
1129         return _minter == account;
1130     }
1131 
1132 
1133     modifier onlyMinter() {
1134         require(isMinter(_msgSender()), "Error: caller is not the minter");
1135         _;
1136     }
1137 
1138     /// @dev Method to claim junk and accidentally sent tokens
1139     function rescueTokens(
1140         IERC20 _token,
1141         address payable _to,
1142         uint256 _balance
1143     ) external onlyOwner {
1144         require(_to != address(0), "can not send to zero address");
1145 
1146         if (_token == IERC20(0)) {
1147             // for Ether
1148             uint256 totalBalance = address(this).balance;
1149             uint256 balance = (_balance == 0) ? totalBalance : min(totalBalance, _balance);
1150             _to.transfer(balance);
1151         } else {
1152             // any other erc20
1153             uint256 totalBalance = _token.balanceOf(address(this));
1154             uint256 balance = _balance == 0 ? totalBalance : min(totalBalance, _balance);
1155             require(balance > 0, "trying to send 0 balance");
1156             _token.transfer(_to, balance);
1157         }
1158     }
1159     
1160     function min(uint256 a, uint256 b) internal pure returns (uint256) {
1161         return a < b ? a : b;
1162     }
1163 
1164 }