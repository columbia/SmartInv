1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 
4 pragma solidity ^0.6.0;
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
27 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
28 
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
106 // File: @openzeppelin/contracts/math/SafeMath.sol
107 
108 
109 pragma solidity ^0.6.0;
110 
111 /**
112  * @dev Wrappers over Solidity's arithmetic operations with added overflow
113  * checks.
114  *
115  * Arithmetic operations in Solidity wrap on overflow. This can easily result
116  * in bugs, because programmers usually assume that an overflow raises an
117  * error, which is the standard behavior in high level programming languages.
118  * `SafeMath` restores this intuition by reverting the transaction when an
119  * operation overflows.
120  *
121  * Using this library instead of the unchecked operations eliminates an entire
122  * class of bugs, so it's recommended to use it always.
123  */
124 library SafeMath {
125     /**
126      * @dev Returns the addition of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `+` operator.
130      *
131      * Requirements:
132      *
133      * - Addition cannot overflow.
134      */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a, "SafeMath: addition overflow");
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      *
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         return sub(a, b, "SafeMath: subtraction overflow");
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b <= a, errorMessage);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the multiplication of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `*` operator.
178      *
179      * Requirements:
180      *
181      * - Multiplication cannot overflow.
182      */
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
185         // benefit is lost if 'b' is also tested.
186         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
187         if (a == 0) {
188             return 0;
189         }
190 
191         uint256 c = a * b;
192         require(c / a == b, "SafeMath: multiplication overflow");
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b > 0, errorMessage);
227         uint256 c = a / b;
228         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229 
230         return c;
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
246         return mod(a, b, "SafeMath: modulo by zero");
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * Reverts with custom message when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b != 0, errorMessage);
263         return a % b;
264     }
265 }
266 
267 // File: @openzeppelin/contracts/utils/Address.sol
268 
269 
270 pragma solidity ^0.6.2;
271 
272 /**
273  * @dev Collection of functions related to the address type
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * [IMPORTANT]
280      * ====
281      * It is unsafe to assume that an address for which this function returns
282      * false is an externally-owned account (EOA) and not a contract.
283      *
284      * Among others, `isContract` will return false for the following
285      * types of addresses:
286      *
287      *  - an externally-owned account
288      *  - a contract in construction
289      *  - an address where a contract will be created
290      *  - an address where a contract lived, but was destroyed
291      * ====
292      */
293     function isContract(address account) internal view returns (bool) {
294         // This method relies in extcodesize, which returns 0 for contracts in
295         // construction, since the code is only stored at the end of the
296         // constructor execution.
297 
298         uint256 size;
299         // solhint-disable-next-line no-inline-assembly
300         assembly { size := extcodesize(account) }
301         return size > 0;
302     }
303 
304     /**
305      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306      * `recipient`, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by `transfer`, making them unable to receive funds via
311      * `transfer`. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to `recipient`, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      */
320     function sendValue(address payable recipient, uint256 amount) internal {
321         require(address(this).balance >= amount, "Address: insufficient balance");
322 
323         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
324         (bool success, ) = recipient.call{ value: amount }("");
325         require(success, "Address: unable to send value, recipient may have reverted");
326     }
327 
328     /**
329      * @dev Performs a Solidity function call using a low level `call`. A
330      * plain`call` is an unsafe replacement for a function call: use this
331      * function instead.
332      *
333      * If `target` reverts with a revert reason, it is bubbled up by this
334      * function (like regular Solidity function calls).
335      *
336      * Returns the raw returned data. To convert to the expected return value,
337      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
338      *
339      * Requirements:
340      *
341      * - `target` must be a contract.
342      * - calling `target` with `data` must not revert.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
347       return functionCall(target, data, "Address: low-level call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
352      * `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
357         return _functionCallWithValue(target, data, 0, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but also transferring `value` wei to `target`.
363      *
364      * Requirements:
365      *
366      * - the calling contract must have an ETH balance of at least `value`.
367      * - the called Solidity function must be `payable`.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
372         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
377      * with `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
382         require(address(this).balance >= value, "Address: insufficient balance for call");
383         return _functionCallWithValue(target, data, value, errorMessage);
384     }
385 
386     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
387         require(isContract(target), "Address: call to non-contract");
388 
389         // solhint-disable-next-line avoid-low-level-calls
390         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
391         if (success) {
392             return returndata;
393         } else {
394             // Look for revert reason and bubble it up if present
395             if (returndata.length > 0) {
396                 // The easiest way to bubble the revert reason is using memory via assembly
397 
398                 // solhint-disable-next-line no-inline-assembly
399                 assembly {
400                     let returndata_size := mload(returndata)
401                     revert(add(32, returndata), returndata_size)
402                 }
403             } else {
404                 revert(errorMessage);
405             }
406         }
407     }
408 }
409 
410 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
411 
412 
413 pragma solidity ^0.6.0;
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
716 // File: @openzeppelin/contracts/access/Ownable.sol
717 
718 // SPDX-License-Identifier: MIT
719 
720 pragma solidity ^0.6.0;
721 
722 /**
723  * @dev Contract module which provides a basic access control mechanism, where
724  * there is an account (an owner) that can be granted exclusive access to
725  * specific functions.
726  *
727  * By default, the owner account will be the one that deploys the contract. This
728  * can later be changed with {transferOwnership}.
729  *
730  * This module is used through inheritance. It will make available the modifier
731  * `onlyOwner`, which can be applied to your functions to restrict their use to
732  * the owner.
733  */
734 contract Ownable is Context {
735     address private _owner;
736 
737     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
738 
739     /**
740      * @dev Initializes the contract setting the deployer as the initial owner.
741      */
742     constructor () internal {
743         address msgSender = _msgSender();
744         _owner = msgSender;
745         emit OwnershipTransferred(address(0), msgSender);
746     }
747 
748     /**
749      * @dev Returns the address of the current owner.
750      */
751     function owner() public view returns (address) {
752         return _owner;
753     }
754 
755     /**
756      * @dev Throws if called by any account other than the owner.
757      */
758     modifier onlyOwner() {
759         require(_owner == _msgSender(), "Ownable: caller is not the owner");
760         _;
761     }
762 
763     /**
764      * @dev Leaves the contract without owner. It will not be possible to call
765      * `onlyOwner` functions anymore. Can only be called by the current owner.
766      *
767      * NOTE: Renouncing ownership will leave the contract without an owner,
768      * thereby removing any functionality that is only available to the owner.
769      */
770     function renounceOwnership() public virtual onlyOwner {
771         emit OwnershipTransferred(_owner, address(0));
772         _owner = address(0);
773     }
774 
775     /**
776      * @dev Transfers ownership of the contract to a new account (`newOwner`).
777      * Can only be called by the current owner.
778      */
779     function transferOwnership(address newOwner) public virtual onlyOwner {
780         require(newOwner != address(0), "Ownable: new owner is the zero address");
781         emit OwnershipTransferred(_owner, newOwner);
782         _owner = newOwner;
783     }
784 }
785 
786 contract YODAToken is ERC20("YODA", "YODA"), Ownable {
787     uint256 private _cap = 3000000000000000000000;
788     uint256 private _totalLock;
789 
790     uint256 public lockFromBlock;
791     uint256 public lockToBlock;
792     
793 
794     mapping(address => uint256) private _locks;
795     mapping(address => uint256) private _lastUnlockBlock;
796 
797     event Lock(address indexed to, uint256 value);
798 
799     constructor(uint256 _lockFromBlock, uint256 _lockToBlock) public {
800         lockFromBlock = _lockFromBlock;
801         lockToBlock = _lockToBlock;
802     }
803 
804     /**
805      * @dev Returns the cap on the token's total supply.
806      */
807     function cap() public view returns (uint256) {
808         return _cap;
809     }
810 
811     function circulatingSupply() public view returns (uint256) {
812         return totalSupply().sub(_totalLock);
813     }
814 
815     function totalLock() public view returns (uint256) {
816         return _totalLock;
817     }
818 
819     /**
820      * @dev See {ERC20-_beforeTokenTransfer}.
821      *
822      * Requirements:
823      *
824      * - minted tokens must not cause the total supply to go over the cap.
825      */
826     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
827         super._beforeTokenTransfer(from, to, amount);
828 
829         if (from == address(0)) { // When minting tokens
830             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
831         }
832     }
833 
834     /**
835      * @dev Moves tokens `amount` from `sender` to `recipient`.
836      *
837      * This is internal function is equivalent to {transfer}, and can be used to
838      * e.g. implement automatic token fees, slashing mechanisms, etc.
839      *
840      * Emits a {Transfer} event.
841      *
842      * Requirements:
843      *
844      * - `sender` cannot be the zero address.
845      * - `recipient` cannot be the zero address.
846      * - `sender` must have a balance of at least `amount`.
847      */
848     function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
849         super._transfer(sender, recipient, amount);
850         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
851     }
852 
853     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
854     function mint(address _to, uint256 _amount) public onlyOwner {
855         _mint(_to, _amount);
856         _moveDelegates(address(0), _delegates[_to], _amount);
857     }
858 
859     function totalBalanceOf(address _holder) public view returns (uint256) {
860         return _locks[_holder].add(balanceOf(_holder));
861     }
862 
863     function lockOf(address _holder) public view returns (uint256) {
864         return _locks[_holder];
865     }
866 
867     function lastUnlockBlock(address _holder) public view returns (uint256) {
868         return _lastUnlockBlock[_holder];
869     }
870 
871     function lock(address _holder, uint256 _amount) public onlyOwner {
872         require(_holder != address(0), "ERC20: lock to the zero address");
873         require(_amount <= balanceOf(_holder), "ERC20: lock amount over blance");
874 
875         _transfer(_holder, address(this), _amount);
876 
877         _locks[_holder] = _locks[_holder].add(_amount);
878         _totalLock = _totalLock.add(_amount);
879         if (_lastUnlockBlock[_holder] < lockFromBlock) {
880             _lastUnlockBlock[_holder] = lockFromBlock;
881         }
882         emit Lock(_holder, _amount);
883     }
884 
885     function canUnlockAmount(address _holder) public view returns (uint256) {
886         if (block.number < lockFromBlock) {
887             return 0;
888         }
889         else if (block.number >= lockToBlock) {
890             return _locks[_holder];
891         }
892         else {
893             uint256 releaseBlock = block.number.sub(_lastUnlockBlock[_holder]);
894             uint256 numberLockBlock = lockToBlock.sub(_lastUnlockBlock[_holder]);
895             return _locks[_holder].mul(releaseBlock).div(numberLockBlock);
896         }
897     }
898 
899     function unlock() public {
900         require(_locks[msg.sender] > 0, "ERC20: cannot unlock");
901         
902         uint256 amount = canUnlockAmount(msg.sender);
903         // just for sure
904         if (amount > balanceOf(address(this))) {
905             amount = balanceOf(address(this));
906         }
907         _transfer(address(this), msg.sender, amount);
908         _locks[msg.sender] = _locks[msg.sender].sub(amount);
909         _lastUnlockBlock[msg.sender] = block.number;
910         _totalLock = _totalLock.sub(amount);
911     }
912 
913     // This function is for dev address migrate all balance to a multi sig address
914     function transferAll(address _to) public {
915         _locks[_to] = _locks[_to].add(_locks[msg.sender]);
916 
917         if (_lastUnlockBlock[_to] < lockFromBlock) {
918             _lastUnlockBlock[_to] = lockFromBlock;
919         }
920 
921         if (_lastUnlockBlock[_to] < _lastUnlockBlock[msg.sender]) {
922             _lastUnlockBlock[_to] = _lastUnlockBlock[msg.sender];
923         }
924 
925         _locks[msg.sender] = 0;
926         _lastUnlockBlock[msg.sender] = 0;
927 
928         _transfer(msg.sender, _to, balanceOf(msg.sender));
929     }
930 
931     // Copied and modified from YAM code:
932     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
933     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
934     // Which is copied and modified from COMPOUND:
935     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
936 
937     /// @dev A record of each accounts delegate
938     mapping (address => address) internal _delegates;
939 
940     /// @notice A checkpoint for marking number of votes from a given block
941     struct Checkpoint {
942         uint32 fromBlock;
943         uint256 votes;
944     }
945 
946     /// @notice A record of votes checkpoints for each account, by index
947     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
948 
949     /// @notice The number of checkpoints for each account
950     mapping (address => uint32) public numCheckpoints;
951 
952     /// @notice The EIP-712 typehash for the contract's domain
953     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
954 
955     /// @notice The EIP-712 typehash for the delegation struct used by the contract
956     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
957 
958     /// @notice A record of states for signing / validating signatures
959     mapping (address => uint) public nonces;
960 
961       /// @notice An event thats emitted when an account changes its delegate
962     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
963 
964     /// @notice An event thats emitted when a delegate account's vote balance changes
965     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
966 
967     /**
968      * @notice Delegate votes from `msg.sender` to `delegatee`
969      * @param delegator The address to get delegatee for
970      */
971     function delegates(address delegator)
972         external
973         view
974         returns (address)
975     {
976         return _delegates[delegator];
977     }
978 
979    /**
980     * @notice Delegate votes from `msg.sender` to `delegatee`
981     * @param delegatee The address to delegate votes to
982     */
983     function delegate(address delegatee) external {
984         return _delegate(msg.sender, delegatee);
985     }
986 
987 
988     function delegateBySig(
989         address delegatee,
990         uint nonce,
991         uint expiry,
992         uint8 v,
993         bytes32 r,
994         bytes32 s
995     )
996         external
997     {
998         bytes32 domainSeparator = keccak256(
999             abi.encode(
1000                 DOMAIN_TYPEHASH,
1001                 keccak256(bytes(name())),
1002                 getChainId(),
1003                 address(this)
1004             )
1005         );
1006 
1007         bytes32 structHash = keccak256(
1008             abi.encode(
1009                 DELEGATION_TYPEHASH,
1010                 delegatee,
1011                 nonce,
1012                 expiry
1013             )
1014         );
1015 
1016         bytes32 digest = keccak256(
1017             abi.encodePacked(
1018                 "\x19\x01",
1019                 domainSeparator,
1020                 structHash
1021             )
1022         );
1023 
1024         address signatory = ecrecover(digest, v, r, s);
1025         require(signatory != address(0), "YODA::delegateBySig: invalid signature");
1026         require(nonce == nonces[signatory]++, "YODA::delegateBySig: invalid nonce");
1027         require(now <= expiry, "YODA::delegateBySig: signature expired");
1028         return _delegate(signatory, delegatee);
1029     }
1030 
1031     /**
1032      * @notice Gets the current votes balance for `account`
1033      * @param account The address to get votes balance
1034      * @return The number of current votes for `account`
1035      */
1036     function getCurrentVotes(address account)
1037         external
1038         view
1039         returns (uint256)
1040     {
1041         uint32 nCheckpoints = numCheckpoints[account];
1042         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1043     }
1044 
1045     /**
1046      * @notice Determine the prior number of votes for an account as of a block number
1047      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1048      * @param account The address of the account to check
1049      * @param blockNumber The block number to get the vote balance at
1050      * @return The number of votes the account had as of the given block
1051      */
1052     function getPriorVotes(address account, uint blockNumber)
1053         external
1054         view
1055         returns (uint256)
1056     {
1057         require(blockNumber < block.number, "YODA::getPriorVotes: not yet determined");
1058 
1059         uint32 nCheckpoints = numCheckpoints[account];
1060         if (nCheckpoints == 0) {
1061             return 0;
1062         }
1063 
1064         // First check most recent balance
1065         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1066             return checkpoints[account][nCheckpoints - 1].votes;
1067         }
1068 
1069         // Next check implicit zero balance
1070         if (checkpoints[account][0].fromBlock > blockNumber) {
1071             return 0;
1072         }
1073 
1074         uint32 lower = 0;
1075         uint32 upper = nCheckpoints - 1;
1076         while (upper > lower) {
1077             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1078             Checkpoint memory cp = checkpoints[account][center];
1079             if (cp.fromBlock == blockNumber) {
1080                 return cp.votes;
1081             } else if (cp.fromBlock < blockNumber) {
1082                 lower = center;
1083             } else {
1084                 upper = center - 1;
1085             }
1086         }
1087         return checkpoints[account][lower].votes;
1088     }
1089 
1090     function _delegate(address delegator, address delegatee)
1091         internal
1092     {
1093         address currentDelegate = _delegates[delegator];
1094         uint256 delegatorBalance = balanceOf(delegator);
1095         _delegates[delegator] = delegatee;
1096 
1097         emit DelegateChanged(delegator, currentDelegate, delegatee);
1098 
1099         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1100     }
1101 
1102     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1103         if (srcRep != dstRep && amount > 0) {
1104             if (srcRep != address(0)) {
1105                 // decrease old representative
1106                 uint32 srcRepNum = numCheckpoints[srcRep];
1107                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1108                 uint256 srcRepNew = srcRepOld.sub(amount);
1109                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1110             }
1111 
1112             if (dstRep != address(0)) {
1113                 // increase new representative
1114                 uint32 dstRepNum = numCheckpoints[dstRep];
1115                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1116                 uint256 dstRepNew = dstRepOld.add(amount);
1117                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1118             }
1119         }
1120     }
1121 
1122     function _writeCheckpoint(
1123         address delegatee,
1124         uint32 nCheckpoints,
1125         uint256 oldVotes,
1126         uint256 newVotes
1127     )
1128         internal
1129     {
1130         uint32 blockNumber = safe32(block.number, "YODA::_writeCheckpoint: block number exceeds 32 bits");
1131 
1132         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1133             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1134         } else {
1135             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1136             numCheckpoints[delegatee] = nCheckpoints + 1;
1137         }
1138 
1139         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1140     }
1141 
1142     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1143         require(n < 2**32, errorMessage);
1144         return uint32(n);
1145     }
1146 
1147     function getChainId() internal pure returns (uint) {
1148         uint256 chainId;
1149         assembly { chainId := chainid() }
1150         return chainId;
1151     }
1152 }