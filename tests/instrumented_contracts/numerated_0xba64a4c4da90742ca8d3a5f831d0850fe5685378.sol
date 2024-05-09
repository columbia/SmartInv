1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-16
3 */
4 
5 // SPDX-License-Identifier: MIT
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
29 contract Ownable is Context {
30     address private _owner;
31 
32     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
33 
34     /**
35      * @dev Initializes the contract setting the deployer as the initial owner.
36      */
37     constructor () internal {
38         address msgSender = _msgSender();
39         _owner = msgSender;
40         emit OwnershipTransferred(address(0), msgSender);
41     }
42 
43     /**
44      * @dev Returns the address of the current owner.
45      */
46     function owner() public view returns (address) {
47         return _owner;
48     }
49 
50     /**
51      * @dev Throws if called by any account other than the owner.
52      */
53     modifier onlyOwner() {
54         require(_owner == _msgSender(), "Ownable: caller is not the owner");
55         _;
56     }
57 
58     /**
59      * @dev Leaves the contract without owner. It will not be possible to call
60      * `onlyOwner` functions anymore. Can only be called by the current owner.
61      *
62      * NOTE: Renouncing ownership will leave the contract without an owner,
63      * thereby removing any functionality that is only available to the owner.
64      */
65     function renounceOwnership() public virtual onlyOwner {
66         emit OwnershipTransferred(_owner, address(0));
67         _owner = address(0);
68     }
69 
70     /**
71      * @dev Transfers ownership of the contract to a new account (`newOwner`).
72      * Can only be called by the current owner.
73      */
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(newOwner != address(0), "Ownable: new owner is the zero address");
76         emit OwnershipTransferred(_owner, newOwner);
77         _owner = newOwner;
78     }
79 }
80 
81 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
82 
83 pragma solidity ^0.6.0;
84 
85 /**
86  * @dev Interface of the ERC20 standard as defined in the EIP.
87  */
88 interface IERC20 {
89     /**
90      * @dev Returns the amount of tokens in existence.
91      */
92     function totalSupply() external view returns (uint256);
93 
94     /**
95      * @dev Returns the amount of tokens owned by `account`.
96      */
97     function balanceOf(address account) external view returns (uint256);
98 
99     /**
100      * @dev Moves `amount` tokens from the caller's account to `recipient`.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transfer(address recipient, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Returns the remaining number of tokens that `spender` will be
110      * allowed to spend on behalf of `owner` through {transferFrom}. This is
111      * zero by default.
112      *
113      * This value changes when {approve} or {transferFrom} are called.
114      */
115     function allowance(address owner, address spender) external view returns (uint256);
116 
117     /**
118      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * IMPORTANT: Beware that changing an allowance with this method brings the risk
123      * that someone may use both the old and the new allowance by unfortunate
124      * transaction ordering. One possible solution to mitigate this race
125      * condition is to first reduce the spender's allowance to 0 and set the
126      * desired value afterwards:
127      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address spender, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Moves `amount` tokens from `sender` to `recipient` using the
135      * allowance mechanism. `amount` is then deducted from the caller's
136      * allowance.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Emitted when `value` tokens are moved from one account (`from`) to
146      * another (`to`).
147      *
148      * Note that `value` may be zero.
149      */
150     event Transfer(address indexed from, address indexed to, uint256 value);
151 
152     /**
153      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
154      * a call to {approve}. `value` is the new allowance.
155      */
156     event Approval(address indexed owner, address indexed spender, uint256 value);
157 }
158 
159 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
160 
161 pragma solidity ^0.6.0;
162 
163 /**
164  * @dev Wrappers over Solidity's arithmetic operations with added overflow
165  * checks.
166  *
167  * Arithmetic operations in Solidity wrap on overflow. This can easily result
168  * in bugs, because programmers usually assume that an overflow raises an
169  * error, which is the standard behavior in high level programming languages.
170  * `SafeMath` restores this intuition by reverting the transaction when an
171  * operation overflows.
172  *
173  * Using this library instead of the unchecked operations eliminates an entire
174  * class of bugs, so it's recommended to use it always.
175  */
176 library SafeMath {
177     /**
178      * @dev Returns the addition of two unsigned integers, reverting on
179      * overflow.
180      *
181      * Counterpart to Solidity's `+` operator.
182      *
183      * Requirements:
184      *
185      * - Addition cannot overflow.
186      */
187     function add(uint256 a, uint256 b) internal pure returns (uint256) {
188         uint256 c = a + b;
189         require(c >= a, "SafeMath: addition overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the subtraction of two unsigned integers, reverting on
196      * overflow (when the result is negative).
197      *
198      * Counterpart to Solidity's `-` operator.
199      *
200      * Requirements:
201      *
202      * - Subtraction cannot overflow.
203      */
204     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
205         return sub(a, b, "SafeMath: subtraction overflow");
206     }
207 
208     /**
209      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
210      * overflow (when the result is negative).
211      *
212      * Counterpart to Solidity's `-` operator.
213      *
214      * Requirements:
215      *
216      * - Subtraction cannot overflow.
217      */
218     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b <= a, errorMessage);
220         uint256 c = a - b;
221 
222         return c;
223     }
224 
225     /**
226      * @dev Returns the multiplication of two unsigned integers, reverting on
227      * overflow.
228      *
229      * Counterpart to Solidity's `*` operator.
230      *
231      * Requirements:
232      *
233      * - Multiplication cannot overflow.
234      */
235     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
236         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
237         // benefit is lost if 'b' is also tested.
238         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
239         if (a == 0) {
240             return 0;
241         }
242 
243         uint256 c = a * b;
244         require(c / a == b, "SafeMath: multiplication overflow");
245 
246         return c;
247     }
248 
249     /**
250      * @dev Returns the integer division of two unsigned integers. Reverts on
251      * division by zero. The result is rounded towards zero.
252      *
253      * Counterpart to Solidity's `/` operator. Note: this function uses a
254      * `revert` opcode (which leaves remaining gas untouched) while Solidity
255      * uses an invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function div(uint256 a, uint256 b) internal pure returns (uint256) {
262         return div(a, b, "SafeMath: division by zero");
263     }
264 
265     /**
266      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
267      * division by zero. The result is rounded towards zero.
268      *
269      * Counterpart to Solidity's `/` operator. Note: this function uses a
270      * `revert` opcode (which leaves remaining gas untouched) while Solidity
271      * uses an invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278         require(b > 0, errorMessage);
279         uint256 c = a / b;
280         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
281 
282         return c;
283     }
284 
285     /**
286      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
287      * Reverts when dividing by zero.
288      *
289      * Counterpart to Solidity's `%` operator. This function uses a `revert`
290      * opcode (which leaves remaining gas untouched) while Solidity uses an
291      * invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
298         return mod(a, b, "SafeMath: modulo by zero");
299     }
300 
301     /**
302      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
303      * Reverts with custom message when dividing by zero.
304      *
305      * Counterpart to Solidity's `%` operator. This function uses a `revert`
306      * opcode (which leaves remaining gas untouched) while Solidity uses an
307      * invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      *
311      * - The divisor cannot be zero.
312      */
313     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
314         require(b != 0, errorMessage);
315         return a % b;
316     }
317 }
318 
319 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
320 
321 pragma solidity ^0.6.2;
322 
323 /**
324  * @dev Collection of functions related to the address type
325  */
326 library Address {
327     /**
328      * @dev Returns true if `account` is a contract.
329      *
330      * [IMPORTANT]
331      * ====
332      * It is unsafe to assume that an address for which this function returns
333      * false is an externally-owned account (EOA) and not a contract.
334      *
335      * Among others, `isContract` will return false for the following
336      * types of addresses:
337      *
338      *  - an externally-owned account
339      *  - a contract in construction
340      *  - an address where a contract will be created
341      *  - an address where a contract lived, but was destroyed
342      * ====
343      */
344     function isContract(address account) internal view returns (bool) {
345         // This method relies in extcodesize, which returns 0 for contracts in
346         // construction, since the code is only stored at the end of the
347         // constructor execution.
348 
349         uint256 size;
350         // solhint-disable-next-line no-inline-assembly
351         assembly { size := extcodesize(account) }
352         return size > 0;
353     }
354 
355     /**
356      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
357      * `recipient`, forwarding all available gas and reverting on errors.
358      *
359      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
360      * of certain opcodes, possibly making contracts go over the 2300 gas limit
361      * imposed by `transfer`, making them unable to receive funds via
362      * `transfer`. {sendValue} removes this limitation.
363      *
364      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
365      *
366      * IMPORTANT: because control is transferred to `recipient`, care must be
367      * taken to not create reentrancy vulnerabilities. Consider using
368      * {ReentrancyGuard} or the
369      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
370      */
371     function sendValue(address payable recipient, uint256 amount) internal {
372         require(address(this).balance >= amount, "Address: insufficient balance");
373 
374         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
375         (bool success, ) = recipient.call{ value: amount }("");
376         require(success, "Address: unable to send value, recipient may have reverted");
377     }
378 
379     /**
380      * @dev Performs a Solidity function call using a low level `call`. A
381      * plain`call` is an unsafe replacement for a function call: use this
382      * function instead.
383      *
384      * If `target` reverts with a revert reason, it is bubbled up by this
385      * function (like regular Solidity function calls).
386      *
387      * Returns the raw returned data. To convert to the expected return value,
388      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
389      *
390      * Requirements:
391      *
392      * - `target` must be a contract.
393      * - calling `target` with `data` must not revert.
394      *
395      * _Available since v3.1._
396      */
397     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
398       return functionCall(target, data, "Address: low-level call failed");
399     }
400 
401     /**
402      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
403      * `errorMessage` as a fallback revert reason when `target` reverts.
404      *
405      * _Available since v3.1._
406      */
407     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
408         return _functionCallWithValue(target, data, 0, errorMessage);
409     }
410 
411     /**
412      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
413      * but also transferring `value` wei to `target`.
414      *
415      * Requirements:
416      *
417      * - the calling contract must have an ETH balance of at least `value`.
418      * - the called Solidity function must be `payable`.
419      *
420      * _Available since v3.1._
421      */
422     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
423         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
424     }
425 
426     /**
427      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
428      * with `errorMessage` as a fallback revert reason when `target` reverts.
429      *
430      * _Available since v3.1._
431      */
432     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
433         require(address(this).balance >= value, "Address: insufficient balance for call");
434         return _functionCallWithValue(target, data, value, errorMessage);
435     }
436 
437     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
438         require(isContract(target), "Address: call to non-contract");
439 
440         // solhint-disable-next-line avoid-low-level-calls
441         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
442         if (success) {
443             return returndata;
444         } else {
445             // Look for revert reason and bubble it up if present
446             if (returndata.length > 0) {
447                 // The easiest way to bubble the revert reason is using memory via assembly
448 
449                 // solhint-disable-next-line no-inline-assembly
450                 assembly {
451                     let returndata_size := mload(returndata)
452                     revert(add(32, returndata), returndata_size)
453                 }
454             } else {
455                 revert(errorMessage);
456             }
457         }
458     }
459 }
460 
461 // File: node_modules\@openzeppelin\contracts\token\ERC20\ERC20.sol
462 
463 pragma solidity ^0.6.0;
464 
465 
466 
467 
468 
469 /**
470  * @dev Implementation of the {IERC20} interface.
471  *
472  * This implementation is agnostic to the way tokens are created. This means
473  * that a supply mechanism has to be added in a derived contract using {_mint}.
474  * For a generic mechanism see {ERC20PresetMinterPauser}.
475  *
476  * TIP: For a detailed writeup see our guide
477  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
478  * to implement supply mechanisms].
479  *
480  * We have followed general OpenZeppelin guidelines: functions revert instead
481  * of returning `false` on failure. This behavior is nonetheless conventional
482  * and does not conflict with the expectations of ERC20 applications.
483  *
484  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
485  * This allows applications to reconstruct the allowance for all accounts just
486  * by listening to said events. Other implementations of the EIP may not emit
487  * these events, as it isn't required by the specification.
488  *
489  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
490  * functions have been added to mitigate the well-known issues around setting
491  * allowances. See {IERC20-approve}.
492  */
493 contract ERC20 is Context, IERC20 {
494     using SafeMath for uint256;
495     using Address for address;
496 
497     mapping (address => uint256) private _balances;
498 
499     mapping (address => mapping (address => uint256)) private _allowances;
500 
501     uint256 private _totalSupply;
502 
503     string private _name;
504     string private _symbol;
505     uint8 private _decimals;
506 
507     /**
508      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
509      * a default value of 18.
510      *
511      * To select a different value for {decimals}, use {_setupDecimals}.
512      *
513      * All three of these values are immutable: they can only be set once during
514      * construction.
515      */
516     constructor (string memory name, string memory symbol) public {
517         _name = name;
518         _symbol = symbol;
519         _decimals = 18;
520     }
521 
522     /**
523      * @dev Returns the name of the token.
524      */
525     function name() public view returns (string memory) {
526         return _name;
527     }
528 
529     /**
530      * @dev Returns the symbol of the token, usually a shorter version of the
531      * name.
532      */
533     function symbol() public view returns (string memory) {
534         return _symbol;
535     }
536 
537     /**
538      * @dev Returns the number of decimals used to get its user representation.
539      * For example, if `decimals` equals `2`, a balance of `505` tokens should
540      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
541      *
542      * Tokens usually opt for a value of 18, imitating the relationship between
543      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
544      * called.
545      *
546      * NOTE: This information is only used for _display_ purposes: it in
547      * no way affects any of the arithmetic of the contract, including
548      * {IERC20-balanceOf} and {IERC20-transfer}.
549      */
550     function decimals() public view returns (uint8) {
551         return _decimals;
552     }
553 
554     /**
555      * @dev See {IERC20-totalSupply}.
556      */
557     function totalSupply() public view override returns (uint256) {
558         return _totalSupply;
559     }
560 
561     /**
562      * @dev See {IERC20-balanceOf}.
563      */
564     function balanceOf(address account) public view override returns (uint256) {
565         return _balances[account];
566     }
567 
568     /**
569      * @dev See {IERC20-transfer}.
570      *
571      * Requirements:
572      *
573      * - `recipient` cannot be the zero address.
574      * - the caller must have a balance of at least `amount`.
575      */
576     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
577         _transfer(_msgSender(), recipient, amount);
578         return true;
579     }
580 
581     /**
582      * @dev See {IERC20-allowance}.
583      */
584     function allowance(address owner, address spender) public view virtual override returns (uint256) {
585         return _allowances[owner][spender];
586     }
587 
588     /**
589      * @dev See {IERC20-approve}.
590      *
591      * Requirements:
592      *
593      * - `spender` cannot be the zero address.
594      */
595     function approve(address spender, uint256 amount) public virtual override returns (bool) {
596         _approve(_msgSender(), spender, amount);
597         return true;
598     }
599 
600     /**
601      * @dev See {IERC20-transferFrom}.
602      *
603      * Emits an {Approval} event indicating the updated allowance. This is not
604      * required by the EIP. See the note at the beginning of {ERC20};
605      *
606      * Requirements:
607      * - `sender` and `recipient` cannot be the zero address.
608      * - `sender` must have a balance of at least `amount`.
609      * - the caller must have allowance for ``sender``'s tokens of at least
610      * `amount`.
611      */
612     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
613         _transfer(sender, recipient, amount);
614         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
615         return true;
616     }
617 
618     /**
619      * @dev Atomically increases the allowance granted to `spender` by the caller.
620      *
621      * This is an alternative to {approve} that can be used as a mitigation for
622      * problems described in {IERC20-approve}.
623      *
624      * Emits an {Approval} event indicating the updated allowance.
625      *
626      * Requirements:
627      *
628      * - `spender` cannot be the zero address.
629      */
630     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
631         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
632         return true;
633     }
634 
635     /**
636      * @dev Atomically decreases the allowance granted to `spender` by the caller.
637      *
638      * This is an alternative to {approve} that can be used as a mitigation for
639      * problems described in {IERC20-approve}.
640      *
641      * Emits an {Approval} event indicating the updated allowance.
642      *
643      * Requirements:
644      *
645      * - `spender` cannot be the zero address.
646      * - `spender` must have allowance for the caller of at least
647      * `subtractedValue`.
648      */
649     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
650         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
651         return true;
652     }
653 
654     /**
655      * @dev Moves tokens `amount` from `sender` to `recipient`.
656      *
657      * This is internal function is equivalent to {transfer}, and can be used to
658      * e.g. implement automatic token fees, slashing mechanisms, etc.
659      *
660      * Emits a {Transfer} event.
661      *
662      * Requirements:
663      *
664      * - `sender` cannot be the zero address.
665      * - `recipient` cannot be the zero address.
666      * - `sender` must have a balance of at least `amount`.
667      */
668     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
669         require(sender != address(0), "ERC20: transfer from the zero address");
670         require(recipient != address(0), "ERC20: transfer to the zero address");
671 
672         _beforeTokenTransfer(sender, recipient, amount);
673 
674         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
675         _balances[recipient] = _balances[recipient].add(amount);
676         emit Transfer(sender, recipient, amount);
677     }
678 
679     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
680      * the total supply.
681      *
682      * Emits a {Transfer} event with `from` set to the zero address.
683      *
684      * Requirements
685      *
686      * - `to` cannot be the zero address.
687      */
688     function _mint(address account, uint256 amount) internal virtual {
689         require(account != address(0), "ERC20: mint to the zero address");
690 
691         _beforeTokenTransfer(address(0), account, amount);
692 
693         _totalSupply = _totalSupply.add(amount);
694         _balances[account] = _balances[account].add(amount);
695         emit Transfer(address(0), account, amount);
696     }
697 
698     /**
699      * @dev Destroys `amount` tokens from `account`, reducing the
700      * total supply.
701      *
702      * Emits a {Transfer} event with `to` set to the zero address.
703      *
704      * Requirements
705      *
706      * - `account` cannot be the zero address.
707      * - `account` must have at least `amount` tokens.
708      */
709     function _burn(address account, uint256 amount) internal virtual {
710         require(account != address(0), "ERC20: burn from the zero address");
711 
712         _beforeTokenTransfer(account, address(0), amount);
713 
714         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
715         _totalSupply = _totalSupply.sub(amount);
716         emit Transfer(account, address(0), amount);
717     }
718 
719     /**
720      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
721      *
722      * This internal function is equivalent to `approve`, and can be used to
723      * e.g. set automatic allowances for certain subsystems, etc.
724      *
725      * Emits an {Approval} event.
726      *
727      * Requirements:
728      *
729      * - `owner` cannot be the zero address.
730      * - `spender` cannot be the zero address.
731      */
732     function _approve(address owner, address spender, uint256 amount) internal virtual {
733         require(owner != address(0), "ERC20: approve from the zero address");
734         require(spender != address(0), "ERC20: approve to the zero address");
735 
736         _allowances[owner][spender] = amount;
737         emit Approval(owner, spender, amount);
738     }
739 
740     /**
741      * @dev Sets {decimals} to a value other than the default one of 18.
742      *
743      * WARNING: This function should only be called from the constructor. Most
744      * applications that interact with token contracts will not expect
745      * {decimals} to ever change, and may work incorrectly if it does.
746      */
747     function _setupDecimals(uint8 decimals_) internal {
748         _decimals = decimals_;
749     }
750 
751     /**
752      * @dev Hook that is called before any transfer of tokens. This includes
753      * minting and burning.
754      *
755      * Calling conditions:
756      *
757      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
758      * will be to transferred to `to`.
759      * - when `from` is zero, `amount` tokens will be minted for `to`.
760      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
761      * - `from` and `to` are never both zero.
762      *
763      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
764      */
765     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
766 }
767 
768 // File: @openzeppelin\contracts\token\ERC20\ERC20Burnable.sol
769 
770 pragma solidity ^0.6.0;
771 
772 /**
773  * @dev Extension of {ERC20} that allows token holders to destroy both their own
774  * tokens and those that they have an allowance for, in a way that can be
775  * recognized off-chain (via event analysis).
776  */
777 abstract contract ERC20Burnable is Context, ERC20 {
778     /**
779      * @dev Destroys `amount` tokens from the caller.
780      *
781      * See {ERC20-_burn}.
782      */
783     function burn(uint256 amount) public virtual {
784         _burn(_msgSender(), amount);
785     }
786 
787     /**
788      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
789      * allowance.
790      *
791      * See {ERC20-_burn} and {ERC20-allowance}.
792      *
793      * Requirements:
794      *
795      * - the caller must have allowance for ``accounts``'s tokens of at least
796      * `amount`.
797      */
798     function burnFrom(address account, uint256 amount) public virtual {
799         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
800 
801         _approve(account, _msgSender(), decreasedAllowance);
802         _burn(account, amount);
803     }
804 }
805 
806 contract DuckToken is ERC20Burnable, Ownable {
807 
808 	uint public constant PRESALE_SUPPLY		= 20000000e18;
809 	uint public constant TEAM_SUPPLY 		= 10000000e18;
810 	uint public constant MAX_FARMING_POOL 	= 70000000e18;
811 
812 	uint public currentFarmingPool;
813 
814 	constructor(address presaleWallet, address teamWallet) public ERC20("DuckToken", "DLC") {
815 		_mint(presaleWallet, PRESALE_SUPPLY);
816 		_mint(teamWallet, TEAM_SUPPLY);
817 	}
818 
819 	function mint(address to, uint256 amount) public onlyOwner {
820 		require(currentFarmingPool.add(amount) <= MAX_FARMING_POOL, "exceed farming amount");
821 		currentFarmingPool += amount; 
822         _mint(to, amount);
823   }
824 }
825 
826 /**
827  * @title SafeERC20
828  * @dev Wrappers around ERC20 operations that throw on failure (when the token
829  * contract returns false). Tokens that return no value (and instead revert or
830  * throw on failure) are also supported, non-reverting calls are assumed to be
831  * successful.
832  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
833  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
834  */
835 library SafeERC20 {
836     using SafeMath for uint256;
837     using Address for address;
838 
839     function safeTransfer(IERC20 token, address to, uint256 value) internal {
840         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
841     }
842 
843     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
844         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
845     }
846 
847     /**
848      * @dev Deprecated. This function has issues similar to the ones found in
849      * {IERC20-approve}, and its usage is discouraged.
850      *
851      * Whenever possible, use {safeIncreaseAllowance} and
852      * {safeDecreaseAllowance} instead.
853      */
854     function safeApprove(IERC20 token, address spender, uint256 value) internal {
855         // safeApprove should only be called when setting an initial allowance,
856         // or when resetting it to zero. To increase and decrease it, use
857         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
858         // solhint-disable-next-line max-line-length
859         require((value == 0) || (token.allowance(address(this), spender) == 0),
860             "SafeERC20: approve from non-zero to non-zero allowance"
861         );
862         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
863     }
864 
865     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
866         uint256 newAllowance = token.allowance(address(this), spender).add(value);
867         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
868     }
869 
870     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
871         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
872         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
873     }
874 
875     /**
876      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
877      * on the return value: the return value is optional (but if data is returned, it must not be false).
878      * @param token The token targeted by the call.
879      * @param data The call data (encoded using abi.encode or one of its variants).
880      */
881     function _callOptionalReturn(IERC20 token, bytes memory data) private {
882         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
883         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
884         // the target address contains contract code and also asserts for success in the low-level call.
885 
886         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
887         if (returndata.length > 0) { // Return data is optional
888             // solhint-disable-next-line max-line-length
889             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
890         }
891     }
892 }
893 
894 
895 
896 abstract contract IUniswapPool {
897 	address public token0;
898 	address public token1;
899 }
900 
901 abstract contract IUniswapRouter {
902 	function removeLiquidity(
903 	    address tokenA,
904 	    address tokenB,
905 	    uint liquidity,
906 	    uint amountAMin,
907 	    uint amountBMin,
908 	    address to,
909 	    uint deadline
910 	) virtual external returns (uint amountA, uint amountB);
911 }
912 
913 contract Pool {
914 
915 	using SafeMath for uint256;
916 	using SafeERC20 for IERC20;
917 
918 	// Info of each user.
919 	struct UserInfo {
920 		uint256 amount;     // How many LP tokens the user has provided.
921 		uint256 rewardDebt; // Reward debt. See explanation below.
922 		//
923 		// We do some fancy math here. Basically, any point in time, the amount of SUSHIs
924 		// entitled to a user but is pending to be distributed is:
925 		//
926 		//   pending reward = (user.amount * pool.accSushiPerShare) - user.rewardDebt
927 		//
928 		// Whenever a user deposits or withdraws LP tokens to a pool. Here's what happens:
929 		//   1. The pool's `accSushiPerShare` (and `lastRewardBlock`) gets updated.
930 		//   2. User receives the pending reward sent to his/her address.
931 		//   3. User's `amount` gets updated.
932 		//   4. User's `rewardDebt` gets updated.
933 	}
934 
935 	// Info of each period.
936 	struct Period {
937 		uint startingBlock;
938 		uint blocks;
939 		uint farmingSupply;
940 		uint tokensPerBlock;
941 	}
942 
943 	// Info of each period.
944 	Period[] public periods;
945 
946 	// Controller address
947 	PoolController public controller;
948 
949 	// Last block number that DUCKs distribution occurs.
950 	uint public lastRewardBlock;
951 
952 	// The DUCK TOKEN
953 	ERC20Burnable public duck;
954 
955 	// Address of LP token contract.
956 	IERC20 public lpToken;
957 
958 	// Accumulated DUCKs per share, times 1e18. See below.
959 	uint public accDuckPerShare;
960 
961 	// Info of each user that stakes LP tokens.
962 	mapping(address => UserInfo) public userInfo;
963 
964 	IUniswapRouter public uniswapRouter = IUniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
965 
966 	//Revenue part
967 	struct Revenue {
968 		address tokenAddress;
969 		uint totalSupply;
970 		uint amount;
971 	}
972 
973 	// Array of created revenues
974 	Revenue[] public revenues;
975 
976 	// mapping of claimed user revenues
977 	mapping(address => mapping(uint => bool)) revenuesClaimed;
978 
979   	event Deposit(address indexed from, uint amount);
980   	event Withdraw(address indexed to, uint amount);
981   	event NewPeriod(uint indexed startingBlock, uint indexed blocks, uint farmingSupply);
982   	event EmergencyWithdraw(address indexed user, uint256 indexed pid, uint256 amount);
983 
984 	modifier onlyController() {
985 		require(msg.sender == address(controller), "onlyController"); 
986 		_;
987 	}
988 	
989 	constructor(address _lpToken, uint _startingBlock, uint[] memory _blocks, uint[] memory _farmingSupplies) public {
990 	    require(_blocks.length > 0, "emply data");
991 	    require(_blocks.length == _farmingSupplies.length, "invalid data");
992 
993 	    controller = PoolController(msg.sender);
994 	    duck = ERC20Burnable(controller.duck());
995 	    lpToken = IERC20(_lpToken);
996 
997 	    addPeriod(_startingBlock, _blocks[0], _farmingSupplies[0]);
998 	    uint _bufStartingBlock = _startingBlock.add(_blocks[0]);
999 
1000 	    for(uint i = 1; i < _blocks.length; i++) {
1001 	        addPeriod(_bufStartingBlock, _blocks[i], _farmingSupplies[i]);
1002 	        _bufStartingBlock = _bufStartingBlock.add(_blocks[i]);
1003 	    }
1004 	    
1005 	    IERC20(_lpToken).approve(address(uniswapRouter), uint256(-1));
1006 	    
1007 	    lastRewardBlock = _startingBlock;
1008 	}
1009 	
1010   // Update a pool by adding NEW period. Can only be called by the controller.
1011 	function addPeriod(uint startingBlock, uint blocks, uint farmingSupply) public onlyController {
1012 	    require(startingBlock >= block.number, "startingBlock should be greater than now");
1013 	    
1014 	    if(periods.length > 0) {
1015 	      require(startingBlock > periods[periods.length-1].startingBlock.add(periods[periods.length-1].blocks), "two periods in the same time");
1016 	    }
1017 
1018 		uint tokensPerBlock = farmingSupply.div(blocks);
1019 		Period memory newPeriod = Period({
1020 			startingBlock: startingBlock,
1021 			blocks: blocks.sub(1),
1022 			farmingSupply: farmingSupply,
1023 			tokensPerBlock: tokensPerBlock
1024 		});
1025 
1026 		periods.push(newPeriod);
1027     	emit NewPeriod(startingBlock, blocks, farmingSupply);
1028 	}
1029 
1030 	// Update reward variables of the given pool to be up-to-date.
1031 	function updatePool() public {
1032 	    if (block.number <= lastRewardBlock) {
1033 	    	return;
1034 	    }
1035 
1036 	    claimRevenue(msg.sender);
1037 	 
1038 	    uint256 lpSupply = lpToken.balanceOf(address(this));
1039 	    if (lpSupply == 0) {
1040 			lastRewardBlock = block.number;
1041 			return;
1042 	    }
1043 	 
1044 	    uint256 duckReward = calculateDuckTokensForMint();
1045 	    if (duckReward > 0) {
1046 			controller.mint(controller.devAddress(), duckReward.mul(7).div(100));
1047 			controller.mint(address(this), duckReward.mul(93).div(100));
1048 
1049 			accDuckPerShare = accDuckPerShare.add(duckReward.mul(1e18).mul(93).div(100).div(lpSupply));
1050 	    }
1051 	    
1052 	    lastRewardBlock = block.number;
1053   	}
1054   
1055 	// Deposit LP tokens to Pool for DUCK allocation.
1056 	function deposit(uint256 amount) public {
1057 	    require(amount > 0, "amount must be more than zero");
1058 	    UserInfo storage user = userInfo[msg.sender];
1059 	 
1060 	    updatePool();
1061 	 
1062 	    if (user.amount > 0) {
1063 			uint256 pending = user.amount.mul(accDuckPerShare).div(1e18).sub(user.rewardDebt);
1064 			if(pending > 0) {
1065 				safeDuckTransfer(msg.sender, pending);
1066 			}
1067 	    }
1068 	    
1069 	    user.amount = user.amount.add(amount);
1070 	    lpToken.safeTransferFrom(msg.sender, address(this), amount);
1071 	    
1072 	    user.rewardDebt = user.amount.mul(accDuckPerShare).div(1e18);
1073 	    
1074 	    emit Deposit(msg.sender, amount);
1075 	}
1076 
1077 	// Withdraw LP tokens from the Pool.
1078 	function withdraw(uint256 amount) public {
1079 
1080 		UserInfo storage user = userInfo[msg.sender];
1081 
1082 		require(user.amount >= amount, "withdraw: not good");
1083 
1084 		updatePool();
1085 
1086 		uint256 pending = user.amount.mul(accDuckPerShare).div(1e18).sub(user.rewardDebt);
1087 		if(pending > 0) {
1088 			safeDuckTransfer(msg.sender, pending);
1089 		}
1090 
1091 		if(amount > 0) {
1092 			// lpToken.safeTransfer(address(msg.sender), amount);
1093 			user.amount = user.amount.sub(amount);
1094 			uniWithdraw(msg.sender, amount);
1095 		}
1096 		 
1097 		user.rewardDebt = user.amount.mul(accDuckPerShare).div(1e18);
1098 		emit Withdraw(msg.sender, amount);
1099 	}
1100 
1101   	function uniWithdraw(address receiver, uint lpTokenAmount) internal {
1102 		IUniswapPool uniswapPool = IUniswapPool(address(lpToken));
1103 
1104 		address token0 = uniswapPool.token0();
1105 		address token1 = uniswapPool.token1();
1106 
1107 		(uint amountA, uint amountB) = uniswapRouter.removeLiquidity(token0, token1, lpTokenAmount, 1, 1, address(this), block.timestamp + 100);
1108 
1109 		bool isDuckBurned;
1110 		bool token0Sent;
1111 		bool token1Sent;
1112 	    if(token0 == address(duck)) {
1113 	        duck.burn(amountA);
1114 	        isDuckBurned = true;
1115 	        token0Sent = true;
1116 	    }
1117 
1118 	    if(token1 == address(duck)) {
1119 	        duck.burn(amountB);
1120 	        isDuckBurned = true;
1121 	        token1Sent = true;
1122 	    }
1123 	    
1124 	    if(!token0Sent) {
1125 	        if(token0 == controller.ddimTokenAddress() && !isDuckBurned) {
1126 	            IERC20(controller.ddimTokenAddress()).transfer(address(0), amountA);
1127 	        } else {
1128 	            IERC20(token0).transfer(receiver, amountA);
1129 	        }
1130 	    }
1131 	    
1132 	    if(!token1Sent) {
1133 	        if(token1 == controller.ddimTokenAddress() && !isDuckBurned) {
1134 	            IERC20(controller.ddimTokenAddress()).transfer(address(0), amountB);
1135 	        } else {
1136 	            IERC20(token1).transfer(receiver, amountB);
1137 	        }
1138 	    }
1139 	}
1140   
1141 
1142 	// Withdraw without caring about rewards. EMERGENCY ONLY.
1143 	function emergencyWithdraw(uint256 pid) public {
1144 		UserInfo storage user = userInfo[msg.sender];
1145 		lpToken.safeTransfer(address(msg.sender), user.amount);
1146 		emit EmergencyWithdraw(msg.sender, pid, user.amount);
1147 		user.amount = 0;
1148 		user.rewardDebt = 0;
1149 	}
1150 
1151 	// Get user pending reward. Frontend function..
1152 	function getUserPendingReward(address userAddress) public view returns(uint) {
1153 		UserInfo storage user = userInfo[userAddress];
1154 		uint256 duckReward = calculateDuckTokensForMint();
1155 
1156 		uint256 lpSupply = lpToken.balanceOf(address(this));
1157 		if (lpSupply == 0) {
1158 		  return 0;
1159 		}
1160 
1161 		uint _accDuckPerShare = accDuckPerShare.add(duckReward.mul(1e18).mul(93).div(100).div(lpSupply));
1162 
1163 		return user.amount.mul(_accDuckPerShare).div(1e18).sub(user.rewardDebt);
1164 	}
1165 
1166 	// Get current period index.
1167 	function getCurrentPeriodIndex() public view returns(uint) {
1168 		for(uint i = 0; i < periods.length; i++) {
1169 			if(block.number > periods[i].startingBlock && block.number < periods[i].startingBlock.add(periods[i].blocks)) {
1170 				return i;
1171 			}
1172 		}
1173 	}
1174 
1175 	// Calculate DUCK Tokens for mint near current time.
1176 	function calculateDuckTokensForMint() public view returns(uint) {
1177 		uint totalTokens;
1178 		bool overflown;
1179 
1180 		for(uint i = 0; i < periods.length; i++) {
1181 			if(block.number < periods[i].startingBlock) {
1182 				break;
1183 			}
1184 
1185 			uint buf = periods[i].startingBlock.add(periods[i].blocks);
1186 
1187 			if(lastRewardBlock > buf) {
1188 				continue;
1189 			}
1190 
1191 			if(block.number > buf) {
1192 			  	totalTokens += buf.sub(max(lastRewardBlock, periods[i].startingBlock-1)).mul(periods[i].tokensPerBlock);
1193 				overflown = true;
1194 			} else {
1195 				if(overflown) {
1196 					totalTokens += block.number.sub(periods[i].startingBlock-1).mul(periods[i].tokensPerBlock);
1197 				} else {
1198 	      			totalTokens += block.number.sub(max(lastRewardBlock, periods[i].startingBlock-1)).mul(periods[i].tokensPerBlock);
1199 				}
1200 
1201 				break;
1202 			}
1203 		}
1204 
1205 		return totalTokens;
1206 	}
1207 
1208 	// Safe duck transfer function, just in case if rounding error causes pool to not have enough DUCKs.
1209 	function safeDuckTransfer(address to, uint256 amount) internal {
1210 		uint256 duckBal = duck.balanceOf(address(this));
1211 		if (amount > duckBal) {
1212 		  	duck.transfer(to, duckBal);
1213 		} else {
1214 			duck.transfer(to, amount);
1215 		}
1216 	}
1217     
1218 	//--------------------------------------------------------------------------------------
1219 	//---------------------------------REVENUE PART-----------------------------------------
1220 	//--------------------------------------------------------------------------------------
1221   
1222 	// Add new Revenue, can be called only by controller
1223 	function addRevenue(address _tokenAddress, uint _amount, address _revenueSource) public onlyController {
1224 		require(revenues.length < 50, "exceed revenue limit");
1225 
1226 		uint revenueBefore = IERC20(_tokenAddress).balanceOf(address(this));
1227 		IERC20(_tokenAddress).transferFrom(_revenueSource, address(this), _amount);
1228 		uint revenueAfter = IERC20(_tokenAddress).balanceOf(address(this));
1229 		_amount = revenueAfter.sub(revenueBefore);
1230 
1231 		Revenue memory revenue = Revenue({
1232 			tokenAddress: _tokenAddress,
1233 			totalSupply: lpToken.balanceOf(address(this)),
1234 			amount: _amount
1235 		});
1236 
1237 		revenues.push(revenue);
1238 	}
1239 
1240 	// Get user last revenue. Frontend function.
1241 	function getUserLastRevenue(address userAddress) public view returns(address, uint) {
1242 		UserInfo storage user = userInfo[userAddress];
1243 
1244 		for(uint i = 0; i < revenues.length; i++) {
1245 			if(!revenuesClaimed[userAddress][i]) {
1246 				uint userRevenue = revenues[i].amount.mul(user.amount).div(revenues[i].totalSupply);
1247 				return (revenues[i].tokenAddress, userRevenue);
1248 			}
1249 		}
1250 	}
1251     
1252 	// claimRevenue is private function, called on updatePool for transaction caller
1253 	function claimRevenue(address userAddress) private {
1254 		UserInfo storage user = userInfo[userAddress];
1255 
1256 		for(uint i = 0; i < revenues.length; i++) {
1257 			if(!revenuesClaimed[userAddress][i]) {
1258 				revenuesClaimed[userAddress][i] = true;
1259 				uint userRevenue = revenues[i].amount.mul(user.amount).div(revenues[i].totalSupply);
1260 
1261 				safeRevenueTransfer(revenues[i].tokenAddress, userAddress, userRevenue);
1262 			}
1263 		}
1264 	}
1265     
1266 	// Safe revenue transfer for avoid misscalculations
1267 	function safeRevenueTransfer(address tokenAddress, address to, uint amount) private {
1268 		uint balance = IERC20(tokenAddress).balanceOf(address(this));
1269 		if(balance == 0 || amount == 0) {
1270 			return;
1271 		}
1272 
1273 		if(balance >= amount) {
1274 			IERC20(tokenAddress).transfer(to, amount);
1275 		} else {
1276 		  	IERC20(tokenAddress).transfer(to, balance);
1277 		}
1278 	}
1279 
1280 	function max(uint a, uint b) public pure returns(uint) {
1281 		if(a > b) {
1282 		  	return a;
1283 		}
1284 		return b;
1285 	}
1286 }
1287 
1288 contract PoolController is Ownable {
1289 	
1290 	// DUCK TOKEN
1291 	DuckToken public duck;
1292 	// Array of pools
1293 	Pool[] public pools;
1294 	
1295 	address public devAddress;
1296     address public ddimTokenAddress;
1297 
1298 	// Mapping is address is pool
1299 	mapping(address => bool) public canMint;
1300 
1301 	event NewPool(address indexed poolAddress, address lpToken);
1302 
1303 	constructor(address _duckTokenAddress, address _devAddress, address _ddimTokenAddress) public {
1304 		duck = DuckToken(_duckTokenAddress);
1305 		devAddress = _devAddress;
1306 		ddimTokenAddress = _ddimTokenAddress;
1307 	}
1308 
1309 	// Add a new pool. Can only be called by the owner.
1310 	function newPool(address lpToken, uint startingBlock, uint[] memory blocks, uint[] memory farmingSupplies) public onlyOwner {
1311 		Pool pool = new Pool(lpToken, startingBlock, blocks, farmingSupplies);
1312 		pools.push(pool);
1313 
1314 		canMint[address(pool)] = true;
1315 		emit NewPool(address(pool), lpToken);
1316 	}
1317 
1318 	// Update already created pool by adding NEW period. Can only be called by the owner.
1319 	function addPeriod(uint poolIndex, uint startingBlock, uint blocks, uint farmingSupply) public onlyOwner {
1320 		pools[poolIndex].addPeriod(startingBlock, blocks, farmingSupply);
1321 	}
1322 	
1323 	// Add new revenue for a pool. Can only be called by the owner. 
1324 	function addRevenue(uint poolIndex, address tokenAddress, uint amount, address _revenueSource) public onlyOwner {
1325 	    pools[poolIndex].addRevenue(tokenAddress, amount, _revenueSource);
1326 	}
1327 
1328 	// Mint DUCK TOKEN. Can be called by pools only
1329 	function mint(address to, uint value) public {
1330 		require(canMint[msg.sender], "only pools");
1331 		duck.mint(to, value);
1332 	}
1333 }