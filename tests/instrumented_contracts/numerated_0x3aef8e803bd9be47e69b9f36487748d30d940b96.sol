1 /**
2  *Submitted for verification at Etherscan.io on 2020-08-15
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-08-15
7 */
8 
9 // File: @openzeppelin\contracts\math\SafeMath.sol
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity ^0.6.0;
14 
15 /**
16  * @dev Wrappers over Solidity's arithmetic operations with added overflow
17  * checks.
18  *
19  * Arithmetic operations in Solidity wrap on overflow. This can easily result
20  * in bugs, because programmers usually assume that an overflow raises an
21  * error, which is the standard behavior in high level programming languages.
22  * `SafeMath` restores this intuition by reverting the transaction when an
23  * operation overflows.
24  *
25  * Using this library instead of the unchecked operations eliminates an entire
26  * class of bugs, so it's recommended to use it always.
27  */
28 library SafeMath {
29     /**
30      * @dev Returns the addition of two unsigned integers, reverting on
31      * overflow.
32      *
33      * Counterpart to Solidity's `+` operator.
34      *
35      * Requirements:
36      *
37      * - Addition cannot overflow.
38      */
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42 
43         return c;
44     }
45 
46     /**
47      * @dev Returns the subtraction of two unsigned integers, reverting on
48      * overflow (when the result is negative).
49      *
50      * Counterpart to Solidity's `-` operator.
51      *
52      * Requirements:
53      *
54      * - Subtraction cannot overflow.
55      */
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return sub(a, b, "SafeMath: subtraction overflow");
58     }
59 
60     /**
61      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
62      * overflow (when the result is negative).
63      *
64      * Counterpart to Solidity's `-` operator.
65      *
66      * Requirements:
67      *
68      * - Subtraction cannot overflow.
69      */
70     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b <= a, errorMessage);
72         uint256 c = a - b;
73 
74         return c;
75     }
76 
77     /**
78      * @dev Returns the multiplication of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `*` operator.
82      *
83      * Requirements:
84      *
85      * - Multiplication cannot overflow.
86      */
87     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
88         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
89         // benefit is lost if 'b' is also tested.
90         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
91         if (a == 0) {
92             return 0;
93         }
94 
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97 
98         return c;
99     }
100 
101     /**
102      * @dev Returns the integer division of two unsigned integers. Reverts on
103      * division by zero. The result is rounded towards zero.
104      *
105      * Counterpart to Solidity's `/` operator. Note: this function uses a
106      * `revert` opcode (which leaves remaining gas untouched) while Solidity
107      * uses an invalid opcode to revert (consuming all remaining gas).
108      *
109      * Requirements:
110      *
111      * - The divisor cannot be zero.
112      */
113     function div(uint256 a, uint256 b) internal pure returns (uint256) {
114         return div(a, b, "SafeMath: division by zero");
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      *
127      * - The divisor cannot be zero.
128      */
129     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         require(b > 0, errorMessage);
131         uint256 c = a / b;
132         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
139      * Reverts when dividing by zero.
140      *
141      * Counterpart to Solidity's `%` operator. This function uses a `revert`
142      * opcode (which leaves remaining gas untouched) while Solidity uses an
143      * invalid opcode to revert (consuming all remaining gas).
144      *
145      * Requirements:
146      *
147      * - The divisor cannot be zero.
148      */
149     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
150         return mod(a, b, "SafeMath: modulo by zero");
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts with custom message when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b != 0, errorMessage);
167         return a % b;
168     }
169 }
170 
171 // File: @openzeppelin\contracts\utils\Address.sol
172 
173 // SPDX-License-Identifier: MIT
174 
175 pragma solidity ^0.6.2;
176 
177 /**
178  * @dev Collection of functions related to the address type
179  */
180 library Address {
181     /**
182      * @dev Returns true if `account` is a contract.
183      *
184      * [IMPORTANT]
185      * ====
186      * It is unsafe to assume that an address for which this function returns
187      * false is an externally-owned account (EOA) and not a contract.
188      *
189      * Among others, `isContract` will return false for the following
190      * types of addresses:
191      *
192      *  - an externally-owned account
193      *  - a contract in construction
194      *  - an address where a contract will be created
195      *  - an address where a contract lived, but was destroyed
196      * ====
197      */
198     function isContract(address account) internal view returns (bool) {
199         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
200         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
201         // for accounts without code, i.e. `keccak256('')`
202         bytes32 codehash;
203         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
204         // solhint-disable-next-line no-inline-assembly
205         assembly { codehash := extcodehash(account) }
206         return (codehash != accountHash && codehash != 0x0);
207     }
208 
209     /**
210      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
211      * `recipient`, forwarding all available gas and reverting on errors.
212      *
213      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
214      * of certain opcodes, possibly making contracts go over the 2300 gas limit
215      * imposed by `transfer`, making them unable to receive funds via
216      * `transfer`. {sendValue} removes this limitation.
217      *
218      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
219      *
220      * IMPORTANT: because control is transferred to `recipient`, care must be
221      * taken to not create reentrancy vulnerabilities. Consider using
222      * {ReentrancyGuard} or the
223      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
224      */
225     function sendValue(address payable recipient, uint256 amount) internal {
226         require(address(this).balance >= amount, "Address: insufficient balance");
227 
228         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
229         (bool success, ) = recipient.call{ value: amount }("");
230         require(success, "Address: unable to send value, recipient may have reverted");
231     }
232 
233     /**
234      * @dev Performs a Solidity function call using a low level `call`. A
235      * plain`call` is an unsafe replacement for a function call: use this
236      * function instead.
237      *
238      * If `target` reverts with a revert reason, it is bubbled up by this
239      * function (like regular Solidity function calls).
240      *
241      * Returns the raw returned data. To convert to the expected return value,
242      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
243      *
244      * Requirements:
245      *
246      * - `target` must be a contract.
247      * - calling `target` with `data` must not revert.
248      *
249      * _Available since v3.1._
250      */
251     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
252       return functionCall(target, data, "Address: low-level call failed");
253     }
254 
255     /**
256      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
257      * `errorMessage` as a fallback revert reason when `target` reverts.
258      *
259      * _Available since v3.1._
260      */
261     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
262         return _functionCallWithValue(target, data, 0, errorMessage);
263     }
264 
265     /**
266      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
267      * but also transferring `value` wei to `target`.
268      *
269      * Requirements:
270      *
271      * - the calling contract must have an ETH balance of at least `value`.
272      * - the called Solidity function must be `payable`.
273      *
274      * _Available since v3.1._
275      */
276     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
277         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
278     }
279 
280     /**
281      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
282      * with `errorMessage` as a fallback revert reason when `target` reverts.
283      *
284      * _Available since v3.1._
285      */
286     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
287         require(address(this).balance >= value, "Address: insufficient balance for call");
288         return _functionCallWithValue(target, data, value, errorMessage);
289     }
290 
291     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
292         require(isContract(target), "Address: call to non-contract");
293 
294         // solhint-disable-next-line avoid-low-level-calls
295         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
296         if (success) {
297             return returndata;
298         } else {
299             // Look for revert reason and bubble it up if present
300             if (returndata.length > 0) {
301                 // The easiest way to bubble the revert reason is using memory via assembly
302 
303                 // solhint-disable-next-line no-inline-assembly
304                 assembly {
305                     let returndata_size := mload(returndata)
306                     revert(add(32, returndata), returndata_size)
307                 }
308             } else {
309                 revert(errorMessage);
310             }
311         }
312     }
313 }
314 
315 // File: node_modules\@openzeppelin\contracts\GSN\Context.sol
316 
317 // SPDX-License-Identifier: MIT
318 
319 pragma solidity ^0.6.0;
320 
321 /*
322  * @dev Provides information about the current execution context, including the
323  * sender of the transaction and its data. While these are generally available
324  * via msg.sender and msg.data, they should not be accessed in such a direct
325  * manner, since when dealing with GSN meta-transactions the account sending and
326  * paying for execution may not be the actual sender (as far as an application
327  * is concerned).
328  *
329  * This contract is only required for intermediate, library-like contracts.
330  */
331 abstract contract Context {
332     function _msgSender() internal view virtual returns (address payable) {
333         return msg.sender;
334     }
335 
336     function _msgData() internal view virtual returns (bytes memory) {
337         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
338         return msg.data;
339     }
340 }
341 
342 // File: node_modules\@openzeppelin\contracts\token\ERC20\IERC20.sol
343 
344 // SPDX-License-Identifier: MIT
345 
346 pragma solidity ^0.6.0;
347 
348 /**
349  * @dev Interface of the ERC20 standard as defined in the EIP.
350  */
351 interface IERC20 {
352     /**
353      * @dev Returns the amount of tokens in existence.
354      */
355     function totalSupply() external view returns (uint256);
356 
357     /**
358      * @dev Returns the amount of tokens owned by `account`.
359      */
360     function balanceOf(address account) external view returns (uint256);
361 
362     /**
363      * @dev Moves `amount` tokens from the caller's account to `recipient`.
364      *
365      * Returns a boolean value indicating whether the operation succeeded.
366      *
367      * Emits a {Transfer} event.
368      */
369     function transfer(address recipient, uint256 amount) external returns (bool);
370 
371     /**
372      * @dev Returns the remaining number of tokens that `spender` will be
373      * allowed to spend on behalf of `owner` through {transferFrom}. This is
374      * zero by default.
375      *
376      * This value changes when {approve} or {transferFrom} are called.
377      */
378     function allowance(address owner, address spender) external view returns (uint256);
379 
380     /**
381      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
382      *
383      * Returns a boolean value indicating whether the operation succeeded.
384      *
385      * IMPORTANT: Beware that changing an allowance with this method brings the risk
386      * that someone may use both the old and the new allowance by unfortunate
387      * transaction ordering. One possible solution to mitigate this race
388      * condition is to first reduce the spender's allowance to 0 and set the
389      * desired value afterwards:
390      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
391      *
392      * Emits an {Approval} event.
393      */
394     function approve(address spender, uint256 amount) external returns (bool);
395 
396     /**
397      * @dev Moves `amount` tokens from `sender` to `recipient` using the
398      * allowance mechanism. `amount` is then deducted from the caller's
399      * allowance.
400      *
401      * Returns a boolean value indicating whether the operation succeeded.
402      *
403      * Emits a {Transfer} event.
404      */
405     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
406 
407     /**
408      * @dev Emitted when `value` tokens are moved from one account (`from`) to
409      * another (`to`).
410      *
411      * Note that `value` may be zero.
412      */
413     event Transfer(address indexed from, address indexed to, uint256 value);
414 
415     /**
416      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
417      * a call to {approve}. `value` is the new allowance.
418      */
419     event Approval(address indexed owner, address indexed spender, uint256 value);
420 }
421 // File: @openzeppelin\contracts\token\ERC20\ERC20.sol
422 
423 // SPDX-License-Identifier: MIT
424 
425 pragma solidity ^0.6.0;
426 
427 
428 
429 /**
430  * @dev Implementation of the {IERC20} interface.
431  *
432  * This implementation is agnostic to the way tokens are created. This means
433  * that a supply mechanism has to be added in a derived contract using {_mint}.
434  * For a generic mechanism see {ERC20PresetMinterPauser}.
435  *
436  * TIP: For a detailed writeup see our guide
437  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
438  * to implement supply mechanisms].
439  *
440  * We have followed general OpenZeppelin guidelines: functions revert instead
441  * of returning `false` on failure. This behavior is nonetheless conventional
442  * and does not conflict with the expectations of ERC20 applications.
443  *
444  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
445  * This allows applications to reconstruct the allowance for all accounts just
446  * by listening to said events. Other implementations of the EIP may not emit
447  * these events, as it isn't required by the specification.
448  *
449  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
450  * functions have been added to mitigate the well-known issues around setting
451  * allowances. See {IERC20-approve}.
452  */
453 contract ERC20 is Context, IERC20 {
454     using SafeMath for uint256;
455     using Address for address;
456 
457     mapping (address => uint256) private _balances;
458 
459     mapping (address => mapping (address => uint256)) private _allowances;
460 
461     uint256 private _totalSupply;
462 
463     string private _name;
464     string private _symbol;
465     uint8 private _decimals;
466 
467     /**
468      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
469      * a default value of 18.
470      *
471      * To select a different value for {decimals}, use {_setupDecimals}.
472      *
473      * All three of these values are immutable: they can only be set once during
474      * construction.
475      */
476     constructor (string memory name, string memory symbol) public {
477         _name = name;
478         _symbol = symbol;
479         _decimals = 18;
480     }
481 
482     /**
483      * @dev Returns the name of the token.
484      */
485     function name() public view returns (string memory) {
486         return _name;
487     }
488 
489     /**
490      * @dev Returns the symbol of the token, usually a shorter version of the
491      * name.
492      */
493     function symbol() public view returns (string memory) {
494         return _symbol;
495     }
496 
497     /**
498      * @dev Returns the number of decimals used to get its user representation.
499      * For example, if `decimals` equals `2`, a balance of `505` tokens should
500      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
501      *
502      * Tokens usually opt for a value of 18, imitating the relationship between
503      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
504      * called.
505      *
506      * NOTE: This information is only used for _display_ purposes: it in
507      * no way affects any of the arithmetic of the contract, including
508      * {IERC20-balanceOf} and {IERC20-transfer}.
509      */
510     function decimals() public view returns (uint8) {
511         return _decimals;
512     }
513 
514     /**
515      * @dev See {IERC20-totalSupply}.
516      */
517     function totalSupply() public view override returns (uint256) {
518         return _totalSupply;
519     }
520 
521     /**
522      * @dev See {IERC20-balanceOf}.
523      */
524     function balanceOf(address account) public view override returns (uint256) {
525         return _balances[account];
526     }
527 
528     /**
529      * @dev See {IERC20-transfer}.
530      *
531      * Requirements:
532      *
533      * - `recipient` cannot be the zero address.
534      * - the caller must have a balance of at least `amount`.
535      */
536     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
537         _transfer(_msgSender(), recipient, amount);
538         return true;
539     }
540 
541     /**
542      * @dev See {IERC20-allowance}.
543      */
544     function allowance(address owner, address spender) public view virtual override returns (uint256) {
545         return _allowances[owner][spender];
546     }
547 
548     /**
549      * @dev See {IERC20-approve}.
550      *
551      * Requirements:
552      *
553      * - `spender` cannot be the zero address.
554      */
555     function approve(address spender, uint256 amount) public virtual override returns (bool) {
556         _approve(_msgSender(), spender, amount);
557         return true;
558     }
559 
560     /**
561      * @dev See {IERC20-transferFrom}.
562      *
563      * Emits an {Approval} event indicating the updated allowance. This is not
564      * required by the EIP. See the note at the beginning of {ERC20};
565      *
566      * Requirements:
567      * - `sender` and `recipient` cannot be the zero address.
568      * - `sender` must have a balance of at least `amount`.
569      * - the caller must have allowance for ``sender``'s tokens of at least
570      * `amount`.
571      */
572     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
573         _transfer(sender, recipient, amount);
574         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
575         return true;
576     }
577 
578     /**
579      * @dev Atomically increases the allowance granted to `spender` by the caller.
580      *
581      * This is an alternative to {approve} that can be used as a mitigation for
582      * problems described in {IERC20-approve}.
583      *
584      * Emits an {Approval} event indicating the updated allowance.
585      *
586      * Requirements:
587      *
588      * - `spender` cannot be the zero address.
589      */
590     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
591         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
592         return true;
593     }
594 
595     /**
596      * @dev Atomically decreases the allowance granted to `spender` by the caller.
597      *
598      * This is an alternative to {approve} that can be used as a mitigation for
599      * problems described in {IERC20-approve}.
600      *
601      * Emits an {Approval} event indicating the updated allowance.
602      *
603      * Requirements:
604      *
605      * - `spender` cannot be the zero address.
606      * - `spender` must have allowance for the caller of at least
607      * `subtractedValue`.
608      */
609     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
610         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
611         return true;
612     }
613 
614     /**
615      * @dev Moves tokens `amount` from `sender` to `recipient`.
616      *
617      * This is internal function is equivalent to {transfer}, and can be used to
618      * e.g. implement automatic token fees, slashing mechanisms, etc.
619      *
620      * Emits a {Transfer} event.
621      *
622      * Requirements:
623      *
624      * - `sender` cannot be the zero address.
625      * - `recipient` cannot be the zero address.
626      * - `sender` must have a balance of at least `amount`.
627      */
628     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
629         require(sender != address(0), "ERC20: transfer from the zero address");
630         require(recipient != address(0), "ERC20: transfer to the zero address");
631 
632         _beforeTokenTransfer(sender, recipient, amount);
633 
634         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
635         _balances[recipient] = _balances[recipient].add(amount);
636         emit Transfer(sender, recipient, amount);
637     }
638 
639     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
640      * the total supply.
641      *
642      * Emits a {Transfer} event with `from` set to the zero address.
643      *
644      * Requirements
645      *
646      * - `to` cannot be the zero address.
647      */
648     function _mint(address account, uint256 amount) internal virtual {
649         require(account != address(0), "ERC20: mint to the zero address");
650 
651         _beforeTokenTransfer(address(0), account, amount);
652 
653         _totalSupply = _totalSupply.add(amount);
654         _balances[account] = _balances[account].add(amount);
655         emit Transfer(address(0), account, amount);
656     }
657 
658     /**
659      * @dev Destroys `amount` tokens from `account`, reducing the
660      * total supply.
661      *
662      * Emits a {Transfer} event with `to` set to the zero address.
663      *
664      * Requirements
665      *
666      * - `account` cannot be the zero address.
667      * - `account` must have at least `amount` tokens.
668      */
669     function _burn(address account, uint256 amount) internal virtual {
670         require(account != address(0), "ERC20: burn from the zero address");
671 
672         _beforeTokenTransfer(account, address(0), amount);
673 
674         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
675         _totalSupply = _totalSupply.sub(amount);
676         emit Transfer(account, address(0), amount);
677     }
678 
679     /**
680      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
681      *
682      * This is internal function is equivalent to `approve`, and can be used to
683      * e.g. set automatic allowances for certain subsystems, etc.
684      *
685      * Emits an {Approval} event.
686      *
687      * Requirements:
688      *
689      * - `owner` cannot be the zero address.
690      * - `spender` cannot be the zero address.
691      */
692     function _approve(address owner, address spender, uint256 amount) internal virtual {
693         require(owner != address(0), "ERC20: approve from the zero address");
694         require(spender != address(0), "ERC20: approve to the zero address");
695 
696         _allowances[owner][spender] = amount;
697         emit Approval(owner, spender, amount);
698     }
699 
700     /**
701      * @dev Sets {decimals} to a value other than the default one of 18.
702      *
703      * WARNING: This function should only be called from the constructor. Most
704      * applications that interact with token contracts will not expect
705      * {decimals} to ever change, and may work incorrectly if it does.
706      */
707     function _setupDecimals(uint8 decimals_) internal {
708         _decimals = decimals_;
709     }
710 
711     /**
712      * @dev Hook that is called before any transfer of tokens. This includes
713      * minting and burning.
714      *
715      * Calling conditions:
716      *
717      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
718      * will be to transferred to `to`.
719      * - when `from` is zero, `amount` tokens will be minted for `to`.
720      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
721      * - `from` and `to` are never both zero.
722      *
723      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
724      */
725     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
726 }
727 
728 // File: @openzeppelin\contracts\access\Ownable.sol
729 
730 // SPDX-License-Identifier: MIT
731 
732 pragma solidity ^0.6.0;
733 
734 /**
735  * @dev Contract module which provides a basic access control mechanism, where
736  * there is an account (an owner) that can be granted exclusive access to
737  * specific functions.
738  *
739  * By default, the owner account will be the one that deploys the contract. This
740  * can later be changed with {transferOwnership}.
741  *
742  * This module is used through inheritance. It will make available the modifier
743  * `onlyOwner`, which can be applied to your functions to restrict their use to
744  * the owner.
745  */
746 contract Ownable is Context {
747     address private _owner;
748 
749     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
750 
751     /**
752      * @dev Initializes the contract setting the deployer as the initial owner.
753      */
754     constructor () internal {
755         address msgSender = _msgSender();
756         _owner = msgSender;
757         emit OwnershipTransferred(address(0), msgSender);
758     }
759 
760     /**
761      * @dev Returns the address of the current owner.
762      */
763     function owner() public view returns (address) {
764         return _owner;
765     }
766 
767     /**
768      * @dev Throws if called by any account other than the owner.
769      */
770     modifier onlyOwner() {
771         require(_owner == _msgSender(), "Ownable: caller is not the owner");
772         _;
773     }
774 
775     /**
776      * @dev Leaves the contract without owner. It will not be possible to call
777      * `onlyOwner` functions anymore. Can only be called by the current owner.
778      *
779      * NOTE: Renouncing ownership will leave the contract without an owner,
780      * thereby removing any functionality that is only available to the owner.
781      */
782     function renounceOwnership() public virtual onlyOwner {
783         emit OwnershipTransferred(_owner, address(0));
784         _owner = address(0);
785     }
786 
787     /**
788      * @dev Transfers ownership of the contract to a new account (`newOwner`).
789      * Can only be called by the current owner.
790      */
791     function transferOwnership(address newOwner) public virtual onlyOwner {
792         require(newOwner != address(0), "Ownable: new owner is the zero address");
793         emit OwnershipTransferred(_owner, newOwner);
794         _owner = newOwner;
795     }
796 }
797 
798 // File: contracts\VTPToken.sol
799 
800 pragma solidity ^0.6.0;
801 
802 
803 
804 
805 
806 contract VTPToken is ERC20,Ownable{
807 
808     using SafeMath for uint256;
809     using Address for address;
810 
811     bytes32 public DOMAIN_SEPARATOR;
812 
813     constructor()
814     ERC20("vesta",'vesta')
815     public {
816         uint chainId;
817         assembly {
818             chainId := chainid()
819         }
820         DOMAIN_SEPARATOR = keccak256(
821             abi.encode(
822                 0x8b73c3c69bb8fe3d512ecc4cf759cc79239f7b179b0ffacaa9a75d522b39400f,
823                 //keccak256('EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)'),
824                 keccak256(bytes("Vesta")),
825                 keccak256(bytes('1')),
826                 chainId,
827                 address(this)
828             )
829         );
830     }
831 
832     function mint(address account, uint256 amount) public onlyOwner{
833         return _mint(account, amount);
834     }
835 }