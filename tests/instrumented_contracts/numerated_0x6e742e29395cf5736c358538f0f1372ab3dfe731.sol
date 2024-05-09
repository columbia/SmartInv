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
28 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
29 
30 pragma solidity ^0.6.0;
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 // File: node_modules\@openzeppelin\contracts\math\SafeMath.sol
107 
108 pragma solidity ^0.6.0;
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 // File: node_modules\@openzeppelin\contracts\utils\Address.sol
267 
268 pragma solidity ^0.6.2;
269 
270 /**
271  * @dev Collection of functions related to the address type
272  */
273 library Address {
274     /**
275      * @dev Returns true if `account` is a contract.
276      *
277      * [IMPORTANT]
278      * ====
279      * It is unsafe to assume that an address for which this function returns
280      * false is an externally-owned account (EOA) and not a contract.
281      *
282      * Among others, `isContract` will return false for the following
283      * types of addresses:
284      *
285      *  - an externally-owned account
286      *  - a contract in construction
287      *  - an address where a contract will be created
288      *  - an address where a contract lived, but was destroyed
289      * ====
290      */
291     function isContract(address account) internal view returns (bool) {
292         // This method relies in extcodesize, which returns 0 for contracts in
293         // construction, since the code is only stored at the end of the
294         // constructor execution.
295 
296         uint256 size;
297         // solhint-disable-next-line no-inline-assembly
298         assembly { size := extcodesize(account) }
299         return size > 0;
300     }
301 
302     /**
303      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
304      * `recipient`, forwarding all available gas and reverting on errors.
305      *
306      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
307      * of certain opcodes, possibly making contracts go over the 2300 gas limit
308      * imposed by `transfer`, making them unable to receive funds via
309      * `transfer`. {sendValue} removes this limitation.
310      *
311      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
312      *
313      * IMPORTANT: because control is transferred to `recipient`, care must be
314      * taken to not create reentrancy vulnerabilities. Consider using
315      * {ReentrancyGuard} or the
316      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
317      */
318     function sendValue(address payable recipient, uint256 amount) internal {
319         require(address(this).balance >= amount, "Address: insufficient balance");
320 
321         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
322         (bool success, ) = recipient.call{ value: amount }("");
323         require(success, "Address: unable to send value, recipient may have reverted");
324     }
325 
326     /**
327      * @dev Performs a Solidity function call using a low level `call`. A
328      * plain`call` is an unsafe replacement for a function call: use this
329      * function instead.
330      *
331      * If `target` reverts with a revert reason, it is bubbled up by this
332      * function (like regular Solidity function calls).
333      *
334      * Returns the raw returned data. To convert to the expected return value,
335      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
336      *
337      * Requirements:
338      *
339      * - `target` must be a contract.
340      * - calling `target` with `data` must not revert.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
345       return functionCall(target, data, "Address: low-level call failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
350      * `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
355         return _functionCallWithValue(target, data, 0, errorMessage);
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
360      * but also transferring `value` wei to `target`.
361      *
362      * Requirements:
363      *
364      * - the calling contract must have an ETH balance of at least `value`.
365      * - the called Solidity function must be `payable`.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
370         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
375      * with `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
380         require(address(this).balance >= value, "Address: insufficient balance for call");
381         return _functionCallWithValue(target, data, value, errorMessage);
382     }
383 
384     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
385         require(isContract(target), "Address: call to non-contract");
386 
387         // solhint-disable-next-line avoid-low-level-calls
388         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
389         if (success) {
390             return returndata;
391         } else {
392             // Look for revert reason and bubble it up if present
393             if (returndata.length > 0) {
394                 // The easiest way to bubble the revert reason is using memory via assembly
395 
396                 // solhint-disable-next-line no-inline-assembly
397                 assembly {
398                     let returndata_size := mload(returndata)
399                     revert(add(32, returndata), returndata_size)
400                 }
401             } else {
402                 revert(errorMessage);
403             }
404         }
405     }
406 }
407 
408 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
409 
410 
411 pragma solidity ^0.6.0;
412 
413 
414 
415 
416 
417 /**
418  * @dev Implementation of the {IERC20} interface.
419  *
420  * This implementation is agnostic to the way tokens are created. This means
421  * that a supply mechanism has to be added in a derived contract using {_mint}.
422  * For a generic mechanism see {ERC20PresetMinterPauser}.
423  *
424  * TIP: For a detailed writeup see our guide
425  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
426  * to implement supply mechanisms].
427  *
428  * We have followed general OpenZeppelin guidelines: functions revert instead
429  * of returning `false` on failure. This behavior is nonetheless conventional
430  * and does not conflict with the expectations of ERC20 applications.
431  *
432  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
433  * This allows applications to reconstruct the allowance for all accounts just
434  * by listening to said events. Other implementations of the EIP may not emit
435  * these events, as it isn't required by the specification.
436  *
437  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
438  * functions have been added to mitigate the well-known issues around setting
439  * allowances. See {IERC20-approve}.
440  */
441 contract ERC20 is Context, IERC20 {
442     using SafeMath for uint256;
443     using Address for address;
444 
445     mapping (address => uint256) private _balances;
446 
447     mapping (address => mapping (address => uint256)) private _allowances;
448 
449     uint256 private _totalSupply;
450 
451     string private _name;
452     string private _symbol;
453     uint8 private _decimals;
454 
455     /**
456      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
457      * a default value of 18.
458      *
459      * To select a different value for {decimals}, use {_setupDecimals}.
460      *
461      * All three of these values are immutable: they can only be set once during
462      * construction.
463      */
464     constructor (string memory name, string memory symbol) public {
465         _name = name;
466         _symbol = symbol;
467         _decimals = 18;
468     }
469 
470     /**
471      * @dev Returns the name of the token.
472      */
473     function name() public view returns (string memory) {
474         return _name;
475     }
476 
477     /**
478      * @dev Returns the symbol of the token, usually a shorter version of the
479      * name.
480      */
481     function symbol() public view returns (string memory) {
482         return _symbol;
483     }
484 
485     /**
486      * @dev Returns the number of decimals used to get its user representation.
487      * For example, if `decimals` equals `2`, a balance of `505` tokens should
488      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
489      *
490      * Tokens usually opt for a value of 18, imitating the relationship between
491      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
492      * called.
493      *
494      * NOTE: This information is only used for _display_ purposes: it in
495      * no way affects any of the arithmetic of the contract, including
496      * {IERC20-balanceOf} and {IERC20-transfer}.
497      */
498     function decimals() public view returns (uint8) {
499         return _decimals;
500     }
501 
502     /**
503      * @dev See {IERC20-totalSupply}.
504      */
505     function totalSupply() public view override returns (uint256) {
506         return _totalSupply;
507     }
508 
509     /**
510      * @dev See {IERC20-balanceOf}.
511      */
512     function balanceOf(address account) public view override returns (uint256) {
513         return _balances[account];
514     }
515 
516     /**
517      * @dev See {IERC20-transfer}.
518      *
519      * Requirements:
520      *
521      * - `recipient` cannot be the zero address.
522      * - the caller must have a balance of at least `amount`.
523      */
524     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
525         _transfer(_msgSender(), recipient, amount);
526         return true;
527     }
528 
529     /**
530      * @dev See {IERC20-allowance}.
531      */
532     function allowance(address owner, address spender) public view virtual override returns (uint256) {
533         return _allowances[owner][spender];
534     }
535 
536     /**
537      * @dev See {IERC20-approve}.
538      *
539      * Requirements:
540      *
541      * - `spender` cannot be the zero address.
542      */
543     function approve(address spender, uint256 amount) public virtual override returns (bool) {
544         _approve(_msgSender(), spender, amount);
545         return true;
546     }
547 
548     /**
549      * @dev See {IERC20-transferFrom}.
550      *
551      * Emits an {Approval} event indicating the updated allowance. This is not
552      * required by the EIP. See the note at the beginning of {ERC20};
553      *
554      * Requirements:
555      * - `sender` and `recipient` cannot be the zero address.
556      * - `sender` must have a balance of at least `amount`.
557      * - the caller must have allowance for ``sender``'s tokens of at least
558      * `amount`.
559      */
560     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
561         _transfer(sender, recipient, amount);
562         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
563         return true;
564     }
565 
566     /**
567      * @dev Atomically increases the allowance granted to `spender` by the caller.
568      *
569      * This is an alternative to {approve} that can be used as a mitigation for
570      * problems described in {IERC20-approve}.
571      *
572      * Emits an {Approval} event indicating the updated allowance.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      */
578     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
579         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
580         return true;
581     }
582 
583     /**
584      * @dev Atomically decreases the allowance granted to `spender` by the caller.
585      *
586      * This is an alternative to {approve} that can be used as a mitigation for
587      * problems described in {IERC20-approve}.
588      *
589      * Emits an {Approval} event indicating the updated allowance.
590      *
591      * Requirements:
592      *
593      * - `spender` cannot be the zero address.
594      * - `spender` must have allowance for the caller of at least
595      * `subtractedValue`.
596      */
597     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
598         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
599         return true;
600     }
601 
602     /**
603      * @dev Moves tokens `amount` from `sender` to `recipient`.
604      *
605      * This is internal function is equivalent to {transfer}, and can be used to
606      * e.g. implement automatic token fees, slashing mechanisms, etc.
607      *
608      * Emits a {Transfer} event.
609      *
610      * Requirements:
611      *
612      * - `sender` cannot be the zero address.
613      * - `recipient` cannot be the zero address.
614      * - `sender` must have a balance of at least `amount`.
615      */
616     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
617         require(sender != address(0), "ERC20: transfer from the zero address");
618         require(recipient != address(0), "ERC20: transfer to the zero address");
619 
620         _beforeTokenTransfer(sender, recipient, amount);
621 
622         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
623         _balances[recipient] = _balances[recipient].add(amount);
624         emit Transfer(sender, recipient, amount);
625     }
626 
627     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
628      * the total supply.
629      *
630      * Emits a {Transfer} event with `from` set to the zero address.
631      *
632      * Requirements
633      *
634      * - `to` cannot be the zero address.
635      */
636     function _mint(address account, uint256 amount) internal virtual {
637         require(account != address(0), "ERC20: mint to the zero address");
638 
639         _beforeTokenTransfer(address(0), account, amount);
640 
641         _totalSupply = _totalSupply.add(amount);
642         _balances[account] = _balances[account].add(amount);
643         emit Transfer(address(0), account, amount);
644     }
645 
646     /**
647      * @dev Destroys `amount` tokens from `account`, reducing the
648      * total supply.
649      *
650      * Emits a {Transfer} event with `to` set to the zero address.
651      *
652      * Requirements
653      *
654      * - `account` cannot be the zero address.
655      * - `account` must have at least `amount` tokens.
656      */
657     function _burn(address account, uint256 amount) internal virtual {
658         require(account != address(0), "ERC20: burn from the zero address");
659 
660         _beforeTokenTransfer(account, address(0), amount);
661 
662         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
663         _totalSupply = _totalSupply.sub(amount);
664         emit Transfer(account, address(0), amount);
665     }
666 
667     /**
668      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
669      *
670      * This internal function is equivalent to `approve`, and can be used to
671      * e.g. set automatic allowances for certain subsystems, etc.
672      *
673      * Emits an {Approval} event.
674      *
675      * Requirements:
676      *
677      * - `owner` cannot be the zero address.
678      * - `spender` cannot be the zero address.
679      */
680     function _approve(address owner, address spender, uint256 amount) internal virtual {
681         require(owner != address(0), "ERC20: approve from the zero address");
682         require(spender != address(0), "ERC20: approve to the zero address");
683 
684         _allowances[owner][spender] = amount;
685         emit Approval(owner, spender, amount);
686     }
687 
688     /**
689      * @dev Sets {decimals} to a value other than the default one of 18.
690      *
691      * WARNING: This function should only be called from the constructor. Most
692      * applications that interact with token contracts will not expect
693      * {decimals} to ever change, and may work incorrectly if it does.
694      */
695     function _setupDecimals(uint8 decimals_) internal {
696         _decimals = decimals_;
697     }
698 
699     /**
700      * @dev Hook that is called before any transfer of tokens. This includes
701      * minting and burning.
702      *
703      * Calling conditions:
704      *
705      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
706      * will be to transferred to `to`.
707      * - when `from` is zero, `amount` tokens will be minted for `to`.
708      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
709      * - `from` and `to` are never both zero.
710      *
711      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
712      */
713     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
714 }
715 
716 // File: contracts\TME.sol
717 
718 pragma solidity ^0.6.0;
719 
720 
721 contract TME is ERC20 {
722     constructor(uint256 initialSupply) 
723     ERC20("TAMA EGG NiftyGotchi", "TME") public {
724         _mint(msg.sender, initialSupply);
725     }
726 }