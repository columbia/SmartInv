1 // File: contracts/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity 0.6.2;
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
28 // File: contracts/Address.sol
29 
30 // SPDX-License-Identifier: MIT
31 
32 pragma solidity 0.6.2;
33 
34 /**
35  * @dev Collection of functions related to the address type
36  */
37 library Address {
38     /**
39      * @dev Returns true if `account` is a contract.
40      *
41      * [IMPORTANT]
42      * ====
43      * It is unsafe to assume that an address for which this function returns
44      * false is an externally-owned account (EOA) and not a contract.
45      *
46      * Among others, `isContract` will return false for the following
47      * types of addresses:
48      *
49      *  - an externally-owned account
50      *  - a contract in construction
51      *  - an address where a contract will be created
52      *  - an address where a contract lived, but was destroyed
53      * ====
54      */
55     function isContract(address account) internal view returns (bool) {
56         // This method relies in extcodesize, which returns 0 for contracts in
57         // construction, since the code is only stored at the end of the
58         // constructor execution.
59 
60         uint256 size;
61         // solhint-disable-next-line no-inline-assembly
62         assembly { size := extcodesize(account) }
63         return size > 0;
64     }
65 
66     /**
67      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
68      * `recipient`, forwarding all available gas and reverting on errors.
69      *
70      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
71      * of certain opcodes, possibly making contracts go over the 2300 gas limit
72      * imposed by `transfer`, making them unable to receive funds via
73      * `transfer`. {sendValue} removes this limitation.
74      *
75      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
76      *
77      * IMPORTANT: because control is transferred to `recipient`, care must be
78      * taken to not create reentrancy vulnerabilities. Consider using
79      * {ReentrancyGuard} or the
80      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
81      */
82     function sendValue(address payable recipient, uint256 amount) internal {
83         require(address(this).balance >= amount, "Address: insufficient balance");
84 
85         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
86         (bool success, ) = recipient.call{ value: amount }("");
87         require(success, "Address: unable to send value, recipient may have reverted");
88     }
89 
90     /**
91      * @dev Performs a Solidity function call using a low level `call`. A
92      * plain`call` is an unsafe replacement for a function call: use this
93      * function instead.
94      *
95      * If `target` reverts with a revert reason, it is bubbled up by this
96      * function (like regular Solidity function calls).
97      *
98      * Returns the raw returned data. To convert to the expected return value,
99      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
100      *
101      * Requirements:
102      *
103      * - `target` must be a contract.
104      * - calling `target` with `data` must not revert.
105      *
106      * _Available since v3.1._
107      */
108     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
109       return functionCall(target, data, "Address: low-level call failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
114      * `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
119         return _functionCallWithValue(target, data, 0, errorMessage);
120     }
121 
122     /**
123      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
124      * but also transferring `value` wei to `target`.
125      *
126      * Requirements:
127      *
128      * - the calling contract must have an ETH balance of at least `value`.
129      * - the called Solidity function must be `payable`.
130      *
131      * _Available since v3.1._
132      */
133     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
134         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
135     }
136 
137     /**
138      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
139      * with `errorMessage` as a fallback revert reason when `target` reverts.
140      *
141      * _Available since v3.1._
142      */
143     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
144         require(address(this).balance >= value, "Address: insufficient balance for call");
145         return _functionCallWithValue(target, data, value, errorMessage);
146     }
147 
148     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
149         require(isContract(target), "Address: call to non-contract");
150 
151         // solhint-disable-next-line avoid-low-level-calls
152         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
153         if (success) {
154             return returndata;
155         } else {
156             // Look for revert reason and bubble it up if present
157             if (returndata.length > 0) {
158                 // The easiest way to bubble the revert reason is using memory via assembly
159 
160                 // solhint-disable-next-line no-inline-assembly
161                 assembly {
162                     let returndata_size := mload(returndata)
163                     revert(add(32, returndata), returndata_size)
164                 }
165             } else {
166                 revert(errorMessage);
167             }
168         }
169     }
170 }
171 
172 // File: contracts/IERC20.sol
173 
174 // SPDX-License-Identifier: MIT
175 
176 pragma solidity 0.6.2;
177 
178 
179 /**
180  * @dev Interface of the ERC20 standard as defined in the EIP.
181  */
182 interface IERC20 {
183     /**
184      * @dev Returns the amount of tokens in existence.
185      */
186     function totalSupply() external view returns (uint256);
187 
188     /**
189      * @dev Returns the amount of tokens owned by `account`.
190      */
191     function balanceOf(address account) external view returns (uint256);
192 
193     /**
194      * @dev Moves `amount` tokens from the caller's account to `recipient`.
195      *
196      * Returns a boolean value indicating whether the operation succeeded.
197      *
198      * Emits a {Transfer} event.
199      */
200     function transfer(address recipient, uint256 amount) external returns (bool);
201 
202     /**
203      * @dev Returns the remaining number of tokens that `spender` will be
204      * allowed to spend on behalf of `owner` through {transferFrom}. This is
205      * zero by default.
206      *
207      * This value changes when {approve} or {transferFrom} are called.
208      */
209     function allowance(address owner, address spender) external view returns (uint256);
210 
211     /**
212      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
213      *
214      * Returns a boolean value indicating whether the operation succeeded.
215      *
216      * IMPORTANT: Beware that changing an allowance with this method brings the risk
217      * that someone may use both the old and the new allowance by unfortunate
218      * transaction ordering. One possible solution to mitigate this race
219      * condition is to first reduce the spender's allowance to 0 and set the
220      * desired value afterwards:
221      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222      *
223      * Emits an {Approval} event.
224      */
225     function approve(address spender, uint256 amount) external returns (bool);
226 
227     /**
228      * @dev Moves `amount` tokens from `sender` to `recipient` using the
229      * allowance mechanism. `amount` is then deducted from the caller's
230      * allowance.
231      *
232      * Returns a boolean value indicating whether the operation succeeded.
233      *
234      * Emits a {Transfer} event.
235      */
236     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
237 
238     /**
239      * @dev Emitted when `value` tokens are moved from one account (`from`) to
240      * another (`to`).
241      *
242      * Note that `value` may be zero.
243      */
244     event Transfer(address indexed from, address indexed to, uint256 value);
245 
246     /**
247      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
248      * a call to {approve}. `value` is the new allowance.
249      */
250     event Approval(address indexed owner, address indexed spender, uint256 value);
251 }
252 
253 // File: contracts/SafeMath.sol
254 
255 // SPDX-License-Identifier: MIT
256 
257 pragma solidity 0.6.2;
258 
259 /**
260  * @dev Wrappers over Solidity's arithmetic operations with added overflow
261  * checks.
262  *
263  * Arithmetic operations in Solidity wrap on overflow. This can easily result
264  * in bugs, because programmers usually assume that an overflow raises an
265  * error, which is the standard behavior in high level programming languages.
266  * `SafeMath` restores this intuition by reverting the transaction when an
267  * operation overflows.
268  *
269  * Using this library instead of the unchecked operations eliminates an entire
270  * class of bugs, so it's recommended to use it always.
271  */
272 library SafeMath {
273     /**
274      * @dev Returns the addition of two unsigned integers, reverting on
275      * overflow.
276      *
277      * Counterpart to Solidity's `+` operator.
278      *
279      * Requirements:
280      *
281      * - Addition cannot overflow.
282      */
283     function add(uint256 a, uint256 b) internal pure returns (uint256) {
284         uint256 c = a + b;
285         require(c >= a, "SafeMath: addition overflow");
286 
287         return c;
288     }
289 
290     /**
291      * @dev Returns the subtraction of two unsigned integers, reverting on
292      * overflow (when the result is negative).
293      *
294      * Counterpart to Solidity's `-` operator.
295      *
296      * Requirements:
297      *
298      * - Subtraction cannot overflow.
299      */
300     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
301         return sub(a, b, "SafeMath: subtraction overflow");
302     }
303 
304     /**
305      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
306      * overflow (when the result is negative).
307      *
308      * Counterpart to Solidity's `-` operator.
309      *
310      * Requirements:
311      *
312      * - Subtraction cannot overflow.
313      */
314     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
315         require(b <= a, errorMessage);
316         uint256 c = a - b;
317 
318         return c;
319     }
320 
321     /**
322      * @dev Returns the multiplication of two unsigned integers, reverting on
323      * overflow.
324      *
325      * Counterpart to Solidity's `*` operator.
326      *
327      * Requirements:
328      *
329      * - Multiplication cannot overflow.
330      */
331     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
332         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
333         // benefit is lost if 'b' is also tested.
334         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
335         if (a == 0) {
336             return 0;
337         }
338 
339         uint256 c = a * b;
340         require(c / a == b, "SafeMath: multiplication overflow");
341 
342         return c;
343     }
344 
345     /**
346      * @dev Returns the integer division of two unsigned integers. Reverts on
347      * division by zero. The result is rounded towards zero.
348      *
349      * Counterpart to Solidity's `/` operator. Note: this function uses a
350      * `revert` opcode (which leaves remaining gas untouched) while Solidity
351      * uses an invalid opcode to revert (consuming all remaining gas).
352      *
353      * Requirements:
354      *
355      * - The divisor cannot be zero.
356      */
357     function div(uint256 a, uint256 b) internal pure returns (uint256) {
358         return div(a, b, "SafeMath: division by zero");
359     }
360 
361     /**
362      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
363      * division by zero. The result is rounded towards zero.
364      *
365      * Counterpart to Solidity's `/` operator. Note: this function uses a
366      * `revert` opcode (which leaves remaining gas untouched) while Solidity
367      * uses an invalid opcode to revert (consuming all remaining gas).
368      *
369      * Requirements:
370      *
371      * - The divisor cannot be zero.
372      */
373     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
374         require(b > 0, errorMessage);
375         uint256 c = a / b;
376         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
377 
378         return c;
379     }
380 
381     /**
382      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
383      * Reverts when dividing by zero.
384      *
385      * Counterpart to Solidity's `%` operator. This function uses a `revert`
386      * opcode (which leaves remaining gas untouched) while Solidity uses an
387      * invalid opcode to revert (consuming all remaining gas).
388      *
389      * Requirements:
390      *
391      * - The divisor cannot be zero.
392      */
393     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
394         return mod(a, b, "SafeMath: modulo by zero");
395     }
396 
397     /**
398      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
399      * Reverts with custom message when dividing by zero.
400      *
401      * Counterpart to Solidity's `%` operator. This function uses a `revert`
402      * opcode (which leaves remaining gas untouched) while Solidity uses an
403      * invalid opcode to revert (consuming all remaining gas).
404      *
405      * Requirements:
406      *
407      * - The divisor cannot be zero.
408      */
409     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
410         require(b != 0, errorMessage);
411         return a % b;
412     }
413 }
414 
415 // File: contracts/ERC20.sol
416 
417 // SPDX-License-Identifier: MIT
418 
419 pragma solidity 0.6.2;
420 
421 
422 
423 
424 
425 /**
426  * @dev Implementation of the {IERC20} interface.
427  *
428  * This implementation is agnostic to the way tokens are created. This means
429  * that a supply mechanism has to be added in a derived contract using {_mint}.
430  * For a generic mechanism see {ERC20PresetMinterPauser}.
431  *
432  * TIP: For a detailed writeup see our guide
433  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
434  * to implement supply mechanisms].
435  *
436  * We have followed general OpenZeppelin guidelines: functions revert instead
437  * of returning `false` on failure. This behavior is nonetheless conventional
438  * and does not conflict with the expectations of ERC20 applications.
439  *
440  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
441  * This allows applications to reconstruct the allowance for all accounts just
442  * by listening to said events. Other implementations of the EIP may not emit
443  * these events, as it isn't required by the specification.
444  *
445  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
446  * functions have been added to mitigate the well-known issues around setting
447  * allowances. See {IERC20-approve}.
448  */
449 contract ERC20 is Context, IERC20 {
450     using SafeMath for uint256;
451     using Address for address;
452 
453     mapping (address => uint256) private _balances;
454 
455     mapping (address => mapping (address => uint256)) internal _allowances;
456 
457     uint256 private _totalSupply;
458 
459     string private _name;
460     string private _symbol;
461     uint8 private _decimals;
462 
463     /**
464      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
465      * a default value of 18.
466      *
467      * To select a different value for {decimals}, use {_setupDecimals}.
468      *
469      * All three of these values are immutable: they can only be set once during
470      * construction.
471      */
472     constructor (string memory name, string memory symbol) public {
473         _name = name;
474         _symbol = symbol;
475         _decimals = 18;
476     }
477 
478     /**
479      * @dev Returns the name of the token.
480      */
481     function name() public view returns (string memory) {
482         return _name;
483     }
484 
485     /**
486      * @dev Returns the symbol of the token, usually a shorter version of the
487      * name.
488      */
489     function symbol() public view returns (string memory) {
490         return _symbol;
491     }
492 
493     /**
494      * @dev Returns the number of decimals used to get its user representation.
495      * For example, if `decimals` equals `2`, a balance of `505` tokens should
496      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
497      *
498      * Tokens usually opt for a value of 18, imitating the relationship between
499      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
500      * called.
501      *
502      * NOTE: This information is only used for _display_ purposes: it in
503      * no way affects any of the arithmetic of the contract, including
504      * {IERC20-balanceOf} and {IERC20-transfer}.
505      */
506     function decimals() public view returns (uint8) {
507         return _decimals;
508     }
509 
510     /**
511      * @dev See {IERC20-totalSupply}.
512      */
513     function totalSupply() public view override returns (uint256) {
514         return _totalSupply;
515     }
516 
517     /**
518      * @dev See {IERC20-balanceOf}.
519      */
520     function balanceOf(address account) public view override returns (uint256) {
521         return _balances[account];
522     }
523 
524     /**
525      * @dev See {IERC20-transfer}.
526      *
527      * Requirements:
528      *
529      * - `recipient` cannot be the zero address.
530      * - the caller must have a balance of at least `amount`.
531      */
532     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
533         _transfer(_msgSender(), recipient, amount);
534         return true;
535     }
536 
537     /**
538      * @dev See {IERC20-allowance}.
539      */
540     function allowance(address owner, address spender) public view virtual override returns (uint256) {
541         return _allowances[owner][spender];
542     }
543 
544     /**
545      * @dev See {IERC20-approve}.
546      *
547      * Requirements:
548      *
549      * - `spender` cannot be the zero address.
550      */
551     function approve(address spender, uint256 amount) public virtual override returns (bool) {
552         _approve(_msgSender(), spender, amount);
553         return true;
554     }
555 
556     /**
557      * @dev See {IERC20-transferFrom}.
558      *
559      * Emits an {Approval} event indicating the updated allowance. This is not
560      * required by the EIP. See the note at the beginning of {ERC20};
561      *
562      * Requirements:
563      * - `sender` and `recipient` cannot be the zero address.
564      * - `sender` must have a balance of at least `amount`.
565      * - the caller must have allowance for ``sender``'s tokens of at least
566      * `amount`.
567      */
568     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
569         _transfer(sender, recipient, amount);
570         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
571         return true;
572     }
573 
574     /**
575      * @dev Atomically increases the allowance granted to `spender` by the caller.
576      *
577      * This is an alternative to {approve} that can be used as a mitigation for
578      * problems described in {IERC20-approve}.
579      *
580      * Emits an {Approval} event indicating the updated allowance.
581      *
582      * Requirements:
583      *
584      * - `spender` cannot be the zero address.
585      */
586     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
587         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
588         return true;
589     }
590 
591     /**
592      * @dev Atomically decreases the allowance granted to `spender` by the caller.
593      *
594      * This is an alternative to {approve} that can be used as a mitigation for
595      * problems described in {IERC20-approve}.
596      *
597      * Emits an {Approval} event indicating the updated allowance.
598      *
599      * Requirements:
600      *
601      * - `spender` cannot be the zero address.
602      * - `spender` must have allowance for the caller of at least
603      * `subtractedValue`.
604      */
605     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
606         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
607         return true;
608     }
609 
610     /**
611      * @dev Moves tokens `amount` from `sender` to `recipient`.
612      *
613      * This is internal function is equivalent to {transfer}, and can be used to
614      * e.g. implement automatic token fees, slashing mechanisms, etc.
615      *
616      * Emits a {Transfer} event.
617      *
618      * Requirements:
619      *
620      * - `sender` cannot be the zero address.
621      * - `recipient` cannot be the zero address.
622      * - `sender` must have a balance of at least `amount`.
623      */
624     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
625         require(sender != address(0), "ERC20: transfer from the zero address");
626         require(recipient != address(0), "ERC20: transfer to the zero address");
627 
628         _beforeTokenTransfer(sender, recipient, amount);
629 
630         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
631         _balances[recipient] = _balances[recipient].add(amount);
632         emit Transfer(sender, recipient, amount);
633     }
634 
635     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
636      * the total supply.
637      *
638      * Emits a {Transfer} event with `from` set to the zero address.
639      *
640      * Requirements
641      *
642      * - `to` cannot be the zero address.
643      */
644     function _mint(address account, uint256 amount) internal virtual {
645         require(account != address(0), "ERC20: mint to the zero address");
646 
647         _beforeTokenTransfer(address(0), account, amount);
648 
649         _totalSupply = _totalSupply.add(amount);
650         _balances[account] = _balances[account].add(amount);
651         emit Transfer(address(0), account, amount);
652     }
653 
654     /**
655      * @dev Destroys `amount` tokens from `account`, reducing the
656      * total supply.
657      *
658      * Emits a {Transfer} event with `to` set to the zero address.
659      *
660      * Requirements
661      *
662      * - `account` cannot be the zero address.
663      * - `account` must have at least `amount` tokens.
664      */
665     function _burn(address account, uint256 amount) internal virtual {
666         require(account != address(0), "ERC20: burn from the zero address");
667 
668         _beforeTokenTransfer(account, address(0), amount);
669 
670         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
671         _totalSupply = _totalSupply.sub(amount);
672         emit Transfer(account, address(0), amount);
673     }
674 
675     /**
676      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
677      *
678      * This internal function is equivalent to `approve`, and can be used to
679      * e.g. set automatic allowances for certain subsystems, etc.
680      *
681      * Emits an {Approval} event.
682      *
683      * Requirements:
684      *
685      * - `owner` cannot be the zero address.
686      * - `spender` cannot be the zero address.
687      */
688     function _approve(address owner, address spender, uint256 amount) internal virtual {
689         require(owner != address(0), "ERC20: approve from the zero address");
690         require(spender != address(0), "ERC20: approve to the zero address");
691 
692         _allowances[owner][spender] = amount;
693         emit Approval(owner, spender, amount);
694     }
695 
696     /**
697      * @dev Sets {decimals} to a value other than the default one of 18.
698      *
699      * WARNING: This function should only be called from the constructor. Most
700      * applications that interact with token contracts will not expect
701      * {decimals} to ever change, and may work incorrectly if it does.
702      */
703     function _setupDecimals(uint8 decimals_) internal {
704         _decimals = decimals_;
705     }
706 
707     /**
708      * @dev Hook that is called before any transfer of tokens. This includes
709      * minting and burning.
710      *
711      * Calling conditions:
712      *
713      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
714      * will be to transferred to `to`.
715      * - when `from` is zero, `amount` tokens will be minted for `to`.
716      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
717      * - `from` and `to` are never both zero.
718      *
719      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
720      */
721     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
722 }
723 
724 // File: contracts/LockedLP.sol
725 
726 // Brain/WETH Locked LP
727 // https://nobrainer.finance/
728 // SPDX-License-Identifier: MIT
729 pragma solidity 0.6.2;
730 
731 
732 interface LP {
733   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
734 }
735 
736 contract LockedLP is ERC20 {
737   address public UniswapPair;
738   
739   constructor(address _lp) public ERC20("Nobrainer.Finance Locked Univ2 BRAIN/WETH LP", "LOCKED BRAINWETH") {
740     UniswapPair = _lp;
741   }
742 
743   function lockLP(uint256 _amount) public {
744     LP(UniswapPair).transferFrom(msg.sender, address(this), _amount);
745     _mint(msg.sender, _amount);
746   }
747 
748   function burn(uint256 _amount) public {
749     _burn(msg.sender, _amount);
750   }
751 
752 }