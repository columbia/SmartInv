1 // SPDX-License-Identifier: UNLICENSED AND MIT
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 
5 
6 pragma solidity ^0.6.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
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
180 pragma solidity ^0.6.0;
181 
182 /**
183  * @dev Wrappers over Solidity's arithmetic operations with added overflow
184  * checks.
185  *
186  * Arithmetic operations in Solidity wrap on overflow. This can easily result
187  * in bugs, because programmers usually assume that an overflow raises an
188  * error, which is the standard behavior in high level programming languages.
189  * `SafeMath` restores this intuition by reverting the transaction when an
190  * operation overflows.
191  *
192  * Using this library instead of the unchecked operations eliminates an entire
193  * class of bugs, so it's recommended to use it always.
194  */
195 library SafeMath {
196     /**
197      * @dev Returns the addition of two unsigned integers, reverting on
198      * overflow.
199      *
200      * Counterpart to Solidity's `+` operator.
201      *
202      * Requirements:
203      *
204      * - Addition cannot overflow.
205      */
206     function add(uint256 a, uint256 b) internal pure returns (uint256) {
207         uint256 c = a + b;
208         require(c >= a, "SafeMath: addition overflow");
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the subtraction of two unsigned integers, reverting on
215      * overflow (when the result is negative).
216      *
217      * Counterpart to Solidity's `-` operator.
218      *
219      * Requirements:
220      *
221      * - Subtraction cannot overflow.
222      */
223     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
224         return sub(a, b, "SafeMath: subtraction overflow");
225     }
226 
227     /**
228      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
229      * overflow (when the result is negative).
230      *
231      * Counterpart to Solidity's `-` operator.
232      *
233      * Requirements:
234      *
235      * - Subtraction cannot overflow.
236      */
237     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b <= a, errorMessage);
239         uint256 c = a - b;
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the multiplication of two unsigned integers, reverting on
246      * overflow.
247      *
248      * Counterpart to Solidity's `*` operator.
249      *
250      * Requirements:
251      *
252      * - Multiplication cannot overflow.
253      */
254     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
255         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
256         // benefit is lost if 'b' is also tested.
257         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
258         if (a == 0) {
259             return 0;
260         }
261 
262         uint256 c = a * b;
263         require(c / a == b, "SafeMath: multiplication overflow");
264 
265         return c;
266     }
267 
268     /**
269      * @dev Returns the integer division of two unsigned integers. Reverts on
270      * division by zero. The result is rounded towards zero.
271      *
272      * Counterpart to Solidity's `/` operator. Note: this function uses a
273      * `revert` opcode (which leaves remaining gas untouched) while Solidity
274      * uses an invalid opcode to revert (consuming all remaining gas).
275      *
276      * Requirements:
277      *
278      * - The divisor cannot be zero.
279      */
280     function div(uint256 a, uint256 b) internal pure returns (uint256) {
281         return div(a, b, "SafeMath: division by zero");
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
296     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
297         require(b > 0, errorMessage);
298         uint256 c = a / b;
299         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
300 
301         return c;
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * Reverts when dividing by zero.
307      *
308      * Counterpart to Solidity's `%` operator. This function uses a `revert`
309      * opcode (which leaves remaining gas untouched) while Solidity uses an
310      * invalid opcode to revert (consuming all remaining gas).
311      *
312      * Requirements:
313      *
314      * - The divisor cannot be zero.
315      */
316     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
317         return mod(a, b, "SafeMath: modulo by zero");
318     }
319 
320     /**
321      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
322      * Reverts with custom message when dividing by zero.
323      *
324      * Counterpart to Solidity's `%` operator. This function uses a `revert`
325      * opcode (which leaves remaining gas untouched) while Solidity uses an
326      * invalid opcode to revert (consuming all remaining gas).
327      *
328      * Requirements:
329      *
330      * - The divisor cannot be zero.
331      */
332     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
333         require(b != 0, errorMessage);
334         return a % b;
335     }
336 }
337 
338 // File: @openzeppelin/contracts/utils/Address.sol
339 
340 
341 pragma solidity ^0.6.2;
342 
343 /**
344  * @dev Collection of functions related to the address type
345  */
346 library Address {
347     /**
348      * @dev Returns true if `account` is a contract.
349      *
350      * [IMPORTANT]
351      * ====
352      * It is unsafe to assume that an address for which this function returns
353      * false is an externally-owned account (EOA) and not a contract.
354      *
355      * Among others, `isContract` will return false for the following
356      * types of addresses:
357      *
358      *  - an externally-owned account
359      *  - a contract in construction
360      *  - an address where a contract will be created
361      *  - an address where a contract lived, but was destroyed
362      * ====
363      */
364     function isContract(address account) internal view returns (bool) {
365         // This method relies in extcodesize, which returns 0 for contracts in
366         // construction, since the code is only stored at the end of the
367         // constructor execution.
368 
369         uint256 size;
370         // solhint-disable-next-line no-inline-assembly
371         assembly { size := extcodesize(account) }
372         return size > 0;
373     }
374 
375     /**
376      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
377      * `recipient`, forwarding all available gas and reverting on errors.
378      *
379      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
380      * of certain opcodes, possibly making contracts go over the 2300 gas limit
381      * imposed by `transfer`, making them unable to receive funds via
382      * `transfer`. {sendValue} removes this limitation.
383      *
384      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
385      *
386      * IMPORTANT: because control is transferred to `recipient`, care must be
387      * taken to not create reentrancy vulnerabilities. Consider using
388      * {ReentrancyGuard} or the
389      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
390      */
391     function sendValue(address payable recipient, uint256 amount) internal {
392         require(address(this).balance >= amount, "Address: insufficient balance");
393 
394         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
395         (bool success, ) = recipient.call{ value: amount }("");
396         require(success, "Address: unable to send value, recipient may have reverted");
397     }
398 
399     /**
400      * @dev Performs a Solidity function call using a low level `call`. A
401      * plain`call` is an unsafe replacement for a function call: use this
402      * function instead.
403      *
404      * If `target` reverts with a revert reason, it is bubbled up by this
405      * function (like regular Solidity function calls).
406      *
407      * Returns the raw returned data. To convert to the expected return value,
408      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
409      *
410      * Requirements:
411      *
412      * - `target` must be a contract.
413      * - calling `target` with `data` must not revert.
414      *
415      * _Available since v3.1._
416      */
417     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
418       return functionCall(target, data, "Address: low-level call failed");
419     }
420 
421     /**
422      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
423      * `errorMessage` as a fallback revert reason when `target` reverts.
424      *
425      * _Available since v3.1._
426      */
427     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
428         return _functionCallWithValue(target, data, 0, errorMessage);
429     }
430 
431     /**
432      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
433      * but also transferring `value` wei to `target`.
434      *
435      * Requirements:
436      *
437      * - the calling contract must have an ETH balance of at least `value`.
438      * - the called Solidity function must be `payable`.
439      *
440      * _Available since v3.1._
441      */
442     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
443         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
444     }
445 
446     /**
447      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
448      * with `errorMessage` as a fallback revert reason when `target` reverts.
449      *
450      * _Available since v3.1._
451      */
452     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
453         require(address(this).balance >= value, "Address: insufficient balance for call");
454         return _functionCallWithValue(target, data, value, errorMessage);
455     }
456 
457     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
458         require(isContract(target), "Address: call to non-contract");
459 
460         // solhint-disable-next-line avoid-low-level-calls
461         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
462         if (success) {
463             return returndata;
464         } else {
465             // Look for revert reason and bubble it up if present
466             if (returndata.length > 0) {
467                 // The easiest way to bubble the revert reason is using memory via assembly
468 
469                 // solhint-disable-next-line no-inline-assembly
470                 assembly {
471                     let returndata_size := mload(returndata)
472                     revert(add(32, returndata), returndata_size)
473                 }
474             } else {
475                 revert(errorMessage);
476             }
477         }
478     }
479 }
480 
481 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
482 
483 
484 pragma solidity ^0.6.0;
485 
486 
487 
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
789 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
790 
791 
792 pragma solidity ^0.6.0;
793 
794 
795 
796 /**
797  * @dev Extension of {ERC20} that allows token holders to destroy both their own
798  * tokens and those that they have an allowance for, in a way that can be
799  * recognized off-chain (via event analysis).
800  */
801 abstract contract ERC20Burnable is Context, ERC20 {
802     /**
803      * @dev Destroys `amount` tokens from the caller.
804      *
805      * See {ERC20-_burn}.
806      */
807     function burn(uint256 amount) public virtual {
808         _burn(_msgSender(), amount);
809     }
810 
811     /**
812      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
813      * allowance.
814      *
815      * See {ERC20-_burn} and {ERC20-allowance}.
816      *
817      * Requirements:
818      *
819      * - the caller must have allowance for ``accounts``'s tokens of at least
820      * `amount`.
821      */
822     function burnFrom(address account, uint256 amount) public virtual {
823         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
824 
825         _approve(account, _msgSender(), decreasedAllowance);
826         _burn(account, amount);
827     }
828 }
829 
830 // File: @openzeppelin/contracts/introspection/IERC165.sol
831 
832 
833 pragma solidity ^0.6.0;
834 
835 /**
836  * @dev Interface of the ERC165 standard, as defined in the
837  * https://eips.ethereum.org/EIPS/eip-165[EIP].
838  *
839  * Implementers can declare support of contract interfaces, which can then be
840  * queried by others ({ERC165Checker}).
841  *
842  * For an implementation, see {ERC165}.
843  */
844 interface IERC165 {
845     /**
846      * @dev Returns true if this contract implements the interface defined by
847      * `interfaceId`. See the corresponding
848      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
849      * to learn more about how these ids are created.
850      *
851      * This function call must use less than 30 000 gas.
852      */
853     function supportsInterface(bytes4 interfaceId) external view returns (bool);
854 }
855 
856 // File: @openzeppelin/contracts/introspection/ERC165.sol
857 
858 
859 pragma solidity ^0.6.0;
860 
861 
862 /**
863  * @dev Implementation of the {IERC165} interface.
864  *
865  * Contracts may inherit from this and call {_registerInterface} to declare
866  * their support of an interface.
867  */
868 contract ERC165 is IERC165 {
869     /*
870      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
871      */
872     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
873 
874     /**
875      * @dev Mapping of interface ids to whether or not it's supported.
876      */
877     mapping(bytes4 => bool) private _supportedInterfaces;
878 
879     constructor () internal {
880         // Derived contracts need only register support for their own interfaces,
881         // we register support for ERC165 itself here
882         _registerInterface(_INTERFACE_ID_ERC165);
883     }
884 
885     /**
886      * @dev See {IERC165-supportsInterface}.
887      *
888      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
889      */
890     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
891         return _supportedInterfaces[interfaceId];
892     }
893 
894     /**
895      * @dev Registers the contract as an implementer of the interface defined by
896      * `interfaceId`. Support of the actual ERC165 interface is automatic and
897      * registering its interface id is not required.
898      *
899      * See {IERC165-supportsInterface}.
900      *
901      * Requirements:
902      *
903      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
904      */
905     function _registerInterface(bytes4 interfaceId) internal virtual {
906         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
907         _supportedInterfaces[interfaceId] = true;
908     }
909 }
910 
911 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
912 
913 
914 pragma solidity ^0.6.2;
915 
916 
917 /**
918  * @dev Required interface of an ERC721 compliant contract.
919  */
920 interface IERC721 is IERC165 {
921     /**
922      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
923      */
924     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
925 
926     /**
927      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
928      */
929     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
930 
931     /**
932      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
933      */
934     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
935 
936     /**
937      * @dev Returns the number of tokens in ``owner``'s account.
938      */
939     function balanceOf(address owner) external view returns (uint256 balance);
940 
941     /**
942      * @dev Returns the owner of the `tokenId` token.
943      *
944      * Requirements:
945      *
946      * - `tokenId` must exist.
947      */
948     function ownerOf(uint256 tokenId) external view returns (address owner);
949 
950     /**
951      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
952      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
953      *
954      * Requirements:
955      *
956      * - `from` cannot be the zero address.
957      * - `to` cannot be the zero address.
958      * - `tokenId` token must exist and be owned by `from`.
959      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
960      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
961      *
962      * Emits a {Transfer} event.
963      */
964     function safeTransferFrom(address from, address to, uint256 tokenId) external;
965 
966     /**
967      * @dev Transfers `tokenId` token from `from` to `to`.
968      *
969      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
970      *
971      * Requirements:
972      *
973      * - `from` cannot be the zero address.
974      * - `to` cannot be the zero address.
975      * - `tokenId` token must be owned by `from`.
976      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
977      *
978      * Emits a {Transfer} event.
979      */
980     function transferFrom(address from, address to, uint256 tokenId) external;
981 
982     /**
983      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
984      * The approval is cleared when the token is transferred.
985      *
986      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
987      *
988      * Requirements:
989      *
990      * - The caller must own the token or be an approved operator.
991      * - `tokenId` must exist.
992      *
993      * Emits an {Approval} event.
994      */
995     function approve(address to, uint256 tokenId) external;
996 
997     /**
998      * @dev Returns the account approved for `tokenId` token.
999      *
1000      * Requirements:
1001      *
1002      * - `tokenId` must exist.
1003      */
1004     function getApproved(uint256 tokenId) external view returns (address operator);
1005 
1006     /**
1007      * @dev Approve or remove `operator` as an operator for the caller.
1008      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
1009      *
1010      * Requirements:
1011      *
1012      * - The `operator` cannot be the caller.
1013      *
1014      * Emits an {ApprovalForAll} event.
1015      */
1016     function setApprovalForAll(address operator, bool _approved) external;
1017 
1018     /**
1019      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1020      *
1021      * See {setApprovalForAll}
1022      */
1023     function isApprovedForAll(address owner, address operator) external view returns (bool);
1024 
1025     /**
1026       * @dev Safely transfers `tokenId` token from `from` to `to`.
1027       *
1028       * Requirements:
1029       *
1030      * - `from` cannot be the zero address.
1031      * - `to` cannot be the zero address.
1032       * - `tokenId` token must exist and be owned by `from`.
1033       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
1034       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1035       *
1036       * Emits a {Transfer} event.
1037       */
1038     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
1039 }
1040 
1041 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
1042 
1043 
1044 pragma solidity ^0.6.2;
1045 
1046 
1047 /**
1048  * @dev Required interface of an ERC1155 compliant contract, as defined in the
1049  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
1050  *
1051  * _Available since v3.1._
1052  */
1053 interface IERC1155 is IERC165 {
1054     /**
1055      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
1056      */
1057     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
1058 
1059     /**
1060      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
1061      * transfers.
1062      */
1063     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
1064 
1065     /**
1066      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
1067      * `approved`.
1068      */
1069     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
1070 
1071     /**
1072      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
1073      *
1074      * If an {URI} event was emitted for `id`, the standard
1075      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
1076      * returned by {IERC1155MetadataURI-uri}.
1077      */
1078     event URI(string value, uint256 indexed id);
1079 
1080     /**
1081      * @dev Returns the amount of tokens of token type `id` owned by `account`.
1082      *
1083      * Requirements:
1084      *
1085      * - `account` cannot be the zero address.
1086      */
1087     function balanceOf(address account, uint256 id) external view returns (uint256);
1088 
1089     /**
1090      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
1091      *
1092      * Requirements:
1093      *
1094      * - `accounts` and `ids` must have the same length.
1095      */
1096     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
1097 
1098     /**
1099      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
1100      *
1101      * Emits an {ApprovalForAll} event.
1102      *
1103      * Requirements:
1104      *
1105      * - `operator` cannot be the caller.
1106      */
1107     function setApprovalForAll(address operator, bool approved) external;
1108 
1109     /**
1110      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
1111      *
1112      * See {setApprovalForAll}.
1113      */
1114     function isApprovedForAll(address account, address operator) external view returns (bool);
1115 
1116     /**
1117      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
1118      *
1119      * Emits a {TransferSingle} event.
1120      *
1121      * Requirements:
1122      *
1123      * - `to` cannot be the zero address.
1124      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
1125      * - `from` must have a balance of tokens of type `id` of at least `amount`.
1126      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
1127      * acceptance magic value.
1128      */
1129     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
1130 
1131     /**
1132      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
1133      *
1134      * Emits a {TransferBatch} event.
1135      *
1136      * Requirements:
1137      *
1138      * - `ids` and `amounts` must have the same length.
1139      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
1140      * acceptance magic value.
1141      */
1142     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
1143 }
1144 
1145 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
1146 
1147 
1148 pragma solidity ^0.6.0;
1149 
1150 
1151 /**
1152  * _Available since v3.1._
1153  */
1154 interface IERC1155Receiver is IERC165 {
1155 
1156     /**
1157         @dev Handles the receipt of a single ERC1155 token type. This function is
1158         called at the end of a `safeTransferFrom` after the balance has been updated.
1159         To accept the transfer, this must return
1160         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
1161         (i.e. 0xf23a6e61, or its own function selector).
1162         @param operator The address which initiated the transfer (i.e. msg.sender)
1163         @param from The address which previously owned the token
1164         @param id The ID of the token being transferred
1165         @param value The amount of tokens being transferred
1166         @param data Additional data with no specified format
1167         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
1168     */
1169     function onERC1155Received(
1170         address operator,
1171         address from,
1172         uint256 id,
1173         uint256 value,
1174         bytes calldata data
1175     )
1176         external
1177         returns(bytes4);
1178 
1179     /**
1180         @dev Handles the receipt of a multiple ERC1155 token types. This function
1181         is called at the end of a `safeBatchTransferFrom` after the balances have
1182         been updated. To accept the transfer(s), this must return
1183         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
1184         (i.e. 0xbc197c81, or its own function selector).
1185         @param operator The address which initiated the batch transfer (i.e. msg.sender)
1186         @param from The address which previously owned the token
1187         @param ids An array containing ids of each token being transferred (order and length must match values array)
1188         @param values An array containing amounts of each token being transferred (order and length must match ids array)
1189         @param data Additional data with no specified format
1190         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
1191     */
1192     function onERC1155BatchReceived(
1193         address operator,
1194         address from,
1195         uint256[] calldata ids,
1196         uint256[] calldata values,
1197         bytes calldata data
1198     )
1199         external
1200         returns(bytes4);
1201 }
1202 
1203 // File: @openzeppelin/contracts/token/ERC1155/ERC1155Receiver.sol
1204 
1205 
1206 pragma solidity ^0.6.0;
1207 
1208 
1209 
1210 /**
1211  * @dev _Available since v3.1._
1212  */
1213 abstract contract ERC1155Receiver is ERC165, IERC1155Receiver {
1214     constructor() public {
1215         _registerInterface(
1216             ERC1155Receiver(0).onERC1155Received.selector ^
1217             ERC1155Receiver(0).onERC1155BatchReceived.selector
1218         );
1219     }
1220 }
1221 
1222 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
1223 
1224 
1225 pragma solidity ^0.6.0;
1226 
1227 /**
1228  * @dev Library for managing
1229  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1230  * types.
1231  *
1232  * Sets have the following properties:
1233  *
1234  * - Elements are added, removed, and checked for existence in constant time
1235  * (O(1)).
1236  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1237  *
1238  * ```
1239  * contract Example {
1240  *     // Add the library methods
1241  *     using EnumerableSet for EnumerableSet.AddressSet;
1242  *
1243  *     // Declare a set state variable
1244  *     EnumerableSet.AddressSet private mySet;
1245  * }
1246  * ```
1247  *
1248  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1249  * (`UintSet`) are supported.
1250  */
1251 library EnumerableSet {
1252     // To implement this library for multiple types with as little code
1253     // repetition as possible, we write it in terms of a generic Set type with
1254     // bytes32 values.
1255     // The Set implementation uses private functions, and user-facing
1256     // implementations (such as AddressSet) are just wrappers around the
1257     // underlying Set.
1258     // This means that we can only create new EnumerableSets for types that fit
1259     // in bytes32.
1260 
1261     struct Set {
1262         // Storage of set values
1263         bytes32[] _values;
1264 
1265         // Position of the value in the `values` array, plus 1 because index 0
1266         // means a value is not in the set.
1267         mapping (bytes32 => uint256) _indexes;
1268     }
1269 
1270     /**
1271      * @dev Add a value to a set. O(1).
1272      *
1273      * Returns true if the value was added to the set, that is if it was not
1274      * already present.
1275      */
1276     function _add(Set storage set, bytes32 value) private returns (bool) {
1277         if (!_contains(set, value)) {
1278             set._values.push(value);
1279             // The value is stored at length-1, but we add 1 to all indexes
1280             // and use 0 as a sentinel value
1281             set._indexes[value] = set._values.length;
1282             return true;
1283         } else {
1284             return false;
1285         }
1286     }
1287 
1288     /**
1289      * @dev Removes a value from a set. O(1).
1290      *
1291      * Returns true if the value was removed from the set, that is if it was
1292      * present.
1293      */
1294     function _remove(Set storage set, bytes32 value) private returns (bool) {
1295         // We read and store the value's index to prevent multiple reads from the same storage slot
1296         uint256 valueIndex = set._indexes[value];
1297 
1298         if (valueIndex != 0) { // Equivalent to contains(set, value)
1299             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1300             // the array, and then remove the last element (sometimes called as 'swap and pop').
1301             // This modifies the order of the array, as noted in {at}.
1302 
1303             uint256 toDeleteIndex = valueIndex - 1;
1304             uint256 lastIndex = set._values.length - 1;
1305 
1306             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1307             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1308 
1309             bytes32 lastvalue = set._values[lastIndex];
1310 
1311             // Move the last value to the index where the value to delete is
1312             set._values[toDeleteIndex] = lastvalue;
1313             // Update the index for the moved value
1314             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1315 
1316             // Delete the slot where the moved value was stored
1317             set._values.pop();
1318 
1319             // Delete the index for the deleted slot
1320             delete set._indexes[value];
1321 
1322             return true;
1323         } else {
1324             return false;
1325         }
1326     }
1327 
1328     /**
1329      * @dev Returns true if the value is in the set. O(1).
1330      */
1331     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1332         return set._indexes[value] != 0;
1333     }
1334 
1335     /**
1336      * @dev Returns the number of values on the set. O(1).
1337      */
1338     function _length(Set storage set) private view returns (uint256) {
1339         return set._values.length;
1340     }
1341 
1342    /**
1343     * @dev Returns the value stored at position `index` in the set. O(1).
1344     *
1345     * Note that there are no guarantees on the ordering of values inside the
1346     * array, and it may change when more values are added or removed.
1347     *
1348     * Requirements:
1349     *
1350     * - `index` must be strictly less than {length}.
1351     */
1352     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1353         require(set._values.length > index, "EnumerableSet: index out of bounds");
1354         return set._values[index];
1355     }
1356 
1357     // AddressSet
1358 
1359     struct AddressSet {
1360         Set _inner;
1361     }
1362 
1363     /**
1364      * @dev Add a value to a set. O(1).
1365      *
1366      * Returns true if the value was added to the set, that is if it was not
1367      * already present.
1368      */
1369     function add(AddressSet storage set, address value) internal returns (bool) {
1370         return _add(set._inner, bytes32(uint256(value)));
1371     }
1372 
1373     /**
1374      * @dev Removes a value from a set. O(1).
1375      *
1376      * Returns true if the value was removed from the set, that is if it was
1377      * present.
1378      */
1379     function remove(AddressSet storage set, address value) internal returns (bool) {
1380         return _remove(set._inner, bytes32(uint256(value)));
1381     }
1382 
1383     /**
1384      * @dev Returns true if the value is in the set. O(1).
1385      */
1386     function contains(AddressSet storage set, address value) internal view returns (bool) {
1387         return _contains(set._inner, bytes32(uint256(value)));
1388     }
1389 
1390     /**
1391      * @dev Returns the number of values in the set. O(1).
1392      */
1393     function length(AddressSet storage set) internal view returns (uint256) {
1394         return _length(set._inner);
1395     }
1396 
1397    /**
1398     * @dev Returns the value stored at position `index` in the set. O(1).
1399     *
1400     * Note that there are no guarantees on the ordering of values inside the
1401     * array, and it may change when more values are added or removed.
1402     *
1403     * Requirements:
1404     *
1405     * - `index` must be strictly less than {length}.
1406     */
1407     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1408         return address(uint256(_at(set._inner, index)));
1409     }
1410 
1411 
1412     // UintSet
1413 
1414     struct UintSet {
1415         Set _inner;
1416     }
1417 
1418     /**
1419      * @dev Add a value to a set. O(1).
1420      *
1421      * Returns true if the value was added to the set, that is if it was not
1422      * already present.
1423      */
1424     function add(UintSet storage set, uint256 value) internal returns (bool) {
1425         return _add(set._inner, bytes32(value));
1426     }
1427 
1428     /**
1429      * @dev Removes a value from a set. O(1).
1430      *
1431      * Returns true if the value was removed from the set, that is if it was
1432      * present.
1433      */
1434     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1435         return _remove(set._inner, bytes32(value));
1436     }
1437 
1438     /**
1439      * @dev Returns true if the value is in the set. O(1).
1440      */
1441     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1442         return _contains(set._inner, bytes32(value));
1443     }
1444 
1445     /**
1446      * @dev Returns the number of values on the set. O(1).
1447      */
1448     function length(UintSet storage set) internal view returns (uint256) {
1449         return _length(set._inner);
1450     }
1451 
1452    /**
1453     * @dev Returns the value stored at position `index` in the set. O(1).
1454     *
1455     * Note that there are no guarantees on the ordering of values inside the
1456     * array, and it may change when more values are added or removed.
1457     *
1458     * Requirements:
1459     *
1460     * - `index` must be strictly less than {length}.
1461     */
1462     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1463         return uint256(_at(set._inner, index));
1464     }
1465 }
1466 
1467 // File: contracts/Rats.sol
1468 
1469 pragma solidity ^0.6.0;
1470 pragma experimental ABIEncoderV2;
1471 
1472 
1473 
1474 
1475 
1476 
1477 
1478 
1479 
1480 contract Rats is ERC20, ERC20Burnable, ERC165, Ownable {
1481     using EnumerableSet for EnumerableSet.AddressSet;
1482 
1483     bool public allowEmergencyAccess;
1484     address payable public donationAddress;
1485     EnumerableSet.AddressSet private allowedErc721Contracts;
1486     EnumerableSet.AddressSet private allowedErc1155Contracts;
1487 
1488     bytes4 immutable onErc721SuccessfulResult =
1489         bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
1490     bytes4 immutable onErc1155SuccessfulResult =
1491         bytes4(
1492             keccak256(
1493                 "onERC1155Received(address,address,uint256,uint256,bytes)"
1494             )
1495         );
1496 
1497     event DepositedToken(address from);
1498     event DepositedERC721(address from, address tokenAddress, uint256 tokenId);
1499     event DepositedERC1155(
1500         address from,
1501         address tokenAddress,
1502         uint256 tokenId,
1503         uint256 amount
1504     );
1505     event WithdrewToken(address from);
1506     event WithdrewERC721(address from, address tokenAddress, uint256 tokenId);
1507     event WithdrewERC1155(
1508         address from,
1509         address tokenAddress,
1510         uint256 tokenId,
1511         uint256 amount
1512     );
1513 
1514     constructor() public ERC20("RATS", "RATS") ERC20Burnable() Ownable() {
1515         allowEmergencyAccess = true;
1516         donationAddress = (payable(owner()));
1517 
1518         // from ERC1155Receiver.sol
1519         _registerInterface(
1520             ERC1155Receiver(0).onERC1155Received.selector ^
1521                 ERC1155Receiver(0).onERC1155BatchReceived.selector
1522         );
1523     }
1524 
1525     function revokeEmergencyAccess() public onlyOwner {
1526         allowEmergencyAccess = false;
1527     }
1528 
1529     function changeDonationAddress(address payable newAddress)
1530         public
1531         onlyOwner
1532     {
1533         donationAddress = newAddress;
1534     }
1535 
1536     modifier onlyEmergencyAccess() {
1537         require(msg.sender == owner(), "must be owner");
1538         require(allowEmergencyAccess, "emergency access not allowed");
1539         _;
1540     }
1541 
1542     // ---- receive callbacks ----
1543     function onERC721Received(
1544         address operator,
1545         address from,
1546         uint256 tokenId,
1547         bytes calldata data
1548     ) external returns (bytes4) {
1549         address receivingErc721ContractAddress = msg.sender;
1550         IERC721 receivingErc721Contract =
1551             IERC721(receivingErc721ContractAddress);
1552 
1553         // ensure address is whitelisted
1554         require(
1555             allowedErc721Contracts.contains(receivingErc721ContractAddress),
1556             "contract not whitelisted"
1557         );
1558         // ensure we have the nft
1559         require(
1560             receivingErc721Contract.ownerOf(tokenId) == address(this),
1561             "dont own erc721"
1562         );
1563         // emit event
1564         emit DepositedERC721(from, receivingErc721ContractAddress, tokenId);
1565         // take action
1566         _giveTokenOrWithdrawArt(from, data);
1567         return onErc721SuccessfulResult;
1568     }
1569 
1570     function onERC1155Received(
1571         address operator,
1572         address from,
1573         uint256 tokenId,
1574         uint256 amountTokens,
1575         bytes calldata data
1576     ) external returns (bytes4) {
1577         address receivingErc1155ContractAddress = msg.sender;
1578         IERC1155 receivingErc1155Contract =
1579             IERC1155(receivingErc1155ContractAddress);
1580         // ensure address is whitelisted
1581         require(
1582             allowedErc1155Contracts.contains(receivingErc1155ContractAddress),
1583             "contract not whitelisted"
1584         );
1585         // ensure we have the nft and didn't have prior
1586         require(amountTokens > 0, "must have non-zero amountTokens");
1587         uint256 ourCurrentBalance =
1588             receivingErc1155Contract.balanceOf(address(this), tokenId);
1589         require(ourCurrentBalance == amountTokens, "Already had ERC1155");
1590 
1591         // emit event
1592         emit DepositedERC1155(
1593             from,
1594             receivingErc1155ContractAddress,
1595             tokenId,
1596             amountTokens
1597         );
1598         // take action
1599         _giveTokenOrWithdrawArt(from, data);
1600         return onErc1155SuccessfulResult;
1601     }
1602 
1603     function swapTokensForERC721Art(
1604         address contractAddressToSend,
1605         uint256 tokenIdToSend
1606     ) external payable {
1607         // burn erc20 from user
1608         emit DepositedToken(msg.sender);
1609         _burn(msg.sender, 1 ether);
1610 
1611         // send art
1612         _sendERC721Art(contractAddressToSend, tokenIdToSend, msg.sender);
1613     }
1614 
1615     function swapTokensForERC1155Art(
1616         address contractAddressToSend,
1617         uint256 tokenIdToSend
1618     ) external payable {
1619         // burn erc20 from user
1620         emit DepositedToken(msg.sender);
1621         _burn(msg.sender, 1 ether);
1622 
1623         // send art
1624         _sendERC1155Art(contractAddressToSend, tokenIdToSend, msg.sender);
1625     }
1626 
1627     function withdrawDonations() public {
1628         Address.sendValue(donationAddress, address(this).balance);
1629     }
1630 
1631     function maxSupply() public pure virtual returns (uint256) {
1632         return 1000 ether;
1633     }
1634 
1635     function maxTokensCreated() public view returns (bool) {
1636         return totalSupply() >= maxSupply();
1637     }
1638 
1639     function _sendERC721Art(
1640         address contractAddressToSend,
1641         uint256 tokenIdToSend,
1642         address recipient
1643     ) private {
1644         IERC721 sendingErc721Contract = IERC721(contractAddressToSend);
1645         sendingErc721Contract.safeTransferFrom(
1646             address(this),
1647             recipient,
1648             tokenIdToSend
1649         );
1650 
1651         emit WithdrewERC721(recipient, contractAddressToSend, tokenIdToSend);
1652     }
1653 
1654     function _sendERC1155Art(
1655         address contractAddressToSend,
1656         uint256 tokenIdToSend,
1657         address recipient
1658     ) private {
1659         IERC1155 sendingErc1155Contract = IERC1155(contractAddressToSend);
1660         uint256 balance =
1661             sendingErc1155Contract.balanceOf(address(this), tokenIdToSend);
1662         require(balance > 0, "doesnt hold any balance");
1663 
1664         sendingErc1155Contract.safeTransferFrom(
1665             address(this),
1666             recipient,
1667             tokenIdToSend,
1668             balance,
1669             ""
1670         );
1671 
1672         emit WithdrewERC1155(
1673             recipient,
1674             contractAddressToSend,
1675             tokenIdToSend,
1676             balance
1677         );
1678     }
1679 
1680     function _giveTokenOrWithdrawArt(address from, bytes calldata data)
1681         private
1682     {
1683         if (data.length == 0) {
1684             // send tokens
1685             if (maxTokensCreated()) {
1686                 revert("Max tokens created");
1687             }
1688             _mint(from, 1 ether);
1689             emit WithdrewToken(from);
1690         } else {
1691             // do swap
1692             (
1693                 address contractAddressToSend,
1694                 uint256 tokenIdToSend,
1695                 bool isErc1155
1696             ) = abi.decode(data, (address, uint256, bool));
1697             if (isErc1155) {
1698                 _sendERC1155Art(contractAddressToSend, tokenIdToSend, from);
1699             } else {
1700                 _sendERC721Art(contractAddressToSend, tokenIdToSend, from);
1701             }
1702         }
1703     }
1704 
1705     // ------ allowedContracts fns -------
1706     function getAllowedContractsLength(bool isErc721)
1707         public
1708         view
1709         returns (uint256)
1710     {
1711         EnumerableSet.AddressSet storage allowedAddresses =
1712             isErc721 ? allowedErc721Contracts : allowedErc1155Contracts;
1713         return allowedAddresses.length();
1714     }
1715 
1716     function getAllowedContracts(
1717         bool isErc721,
1718         uint256 start,
1719         uint256 end
1720     ) public view returns (address[] memory) {
1721         EnumerableSet.AddressSet storage allowedAddresses =
1722             isErc721 ? allowedErc721Contracts : allowedErc1155Contracts;
1723         address[] memory re = new address[](end - start);
1724         for (uint256 i = start; i < end; i++) {
1725             re[i - start] = allowedAddresses.at(i);
1726         }
1727         return re;
1728     }
1729 
1730     function addAllowedContracts(
1731         bool isErc721,
1732         address[] memory contractAddresses
1733     ) public onlyOwner {
1734         EnumerableSet.AddressSet storage allowedAddresses =
1735             isErc721 ? allowedErc721Contracts : allowedErc1155Contracts;
1736         for (uint256 i = 0; i < contractAddresses.length; ++i) {
1737             allowedAddresses.add(contractAddresses[i]);
1738         }
1739     }
1740 
1741     // ----- emergency functions ------
1742     function emergencyRemoveAllowedContracts(
1743         bool isErc721,
1744         address[] memory contractAddresses
1745     ) public onlyEmergencyAccess {
1746         EnumerableSet.AddressSet storage allowedAddresses =
1747             isErc721 ? allowedErc721Contracts : allowedErc1155Contracts;
1748         for (uint256 i = 0; i < contractAddresses.length; ++i) {
1749             allowedAddresses.remove(contractAddresses[i]);
1750         }
1751     }
1752 
1753     function emergencyMint(address account, uint256 amount)
1754         public
1755         onlyEmergencyAccess
1756     {
1757         _mint(account, amount);
1758     }
1759 
1760     function emergencyBurn(address account, uint256 amount)
1761         public
1762         onlyEmergencyAccess
1763     {
1764         _burn(account, amount);
1765     }
1766 
1767     function emergencyExecute(
1768         address targetAddress,
1769         bytes calldata targetCallData
1770     ) public onlyEmergencyAccess returns (bool) {
1771         (bool success, ) = targetAddress.call(targetCallData);
1772         return success;
1773     }
1774 }