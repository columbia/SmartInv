1 // File: @openzeppelin/contracts/GSN/Context.sol
2 // SPDX-License-Identifier: GPL-3.0-or-later
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
294         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
295         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
296         // for accounts without code, i.e. `keccak256('')`
297         bytes32 codehash;
298         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
299         // solhint-disable-next-line no-inline-assembly
300         assembly { codehash := extcodehash(account) }
301         return (codehash != accountHash && codehash != 0x0);
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
417 
418 
419 /**
420  * @dev Implementation of the {IERC20} interface.
421  *
422  * This implementation is agnostic to the way tokens are created. This means
423  * that a supply mechanism has to be added in a derived contract using {_mint}.
424  * For a generic mechanism see {ERC20PresetMinterPauser}.
425  *
426  * TIP: For a detailed writeup see our guide
427  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
428  * to implement supply mechanisms].
429  *
430  * We have followed general OpenZeppelin guidelines: functions revert instead
431  * of returning `false` on failure. This behavior is nonetheless conventional
432  * and does not conflict with the expectations of ERC20 applications.
433  *
434  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
435  * This allows applications to reconstruct the allowance for all accounts just
436  * by listening to said events. Other implementations of the EIP may not emit
437  * these events, as it isn't required by the specification.
438  *
439  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
440  * functions have been added to mitigate the well-known issues around setting
441  * allowances. See {IERC20-approve}.
442  */
443 contract ERC20 is Context, IERC20 {
444     using SafeMath for uint256;
445     using Address for address;
446 
447     mapping (address => uint256) private _balances;
448 
449     mapping (address => mapping (address => uint256)) private _allowances;
450 
451     uint256 private _totalSupply;
452 
453     string private _name;
454     string private _symbol;
455     uint8 private _decimals;
456 
457     /**
458      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
459      * a default value of 18.
460      *
461      * To select a different value for {decimals}, use {_setupDecimals}.
462      *
463      * All three of these values are immutable: they can only be set once during
464      * construction.
465      */
466     constructor (string memory name, string memory symbol) public {
467         _name = name;
468         _symbol = symbol;
469         _decimals = 18;
470     }
471 
472     /**
473      * @dev Returns the name of the token.
474      */
475     function name() public view returns (string memory) {
476         return _name;
477     }
478 
479     /**
480      * @dev Returns the symbol of the token, usually a shorter version of the
481      * name.
482      */
483     function symbol() public view returns (string memory) {
484         return _symbol;
485     }
486 
487     /**
488      * @dev Returns the number of decimals used to get its user representation.
489      * For example, if `decimals` equals `2`, a balance of `505` tokens should
490      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
491      *
492      * Tokens usually opt for a value of 18, imitating the relationship between
493      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
494      * called.
495      *
496      * NOTE: This information is only used for _display_ purposes: it in
497      * no way affects any of the arithmetic of the contract, including
498      * {IERC20-balanceOf} and {IERC20-transfer}.
499      */
500     function decimals() public view returns (uint8) {
501         return _decimals;
502     }
503 
504     /**
505      * @dev See {IERC20-totalSupply}.
506      */
507     function totalSupply() public view override returns (uint256) {
508         return _totalSupply;
509     }
510 
511     /**
512      * @dev See {IERC20-balanceOf}.
513      */
514     function balanceOf(address account) public view override returns (uint256) {
515         return _balances[account];
516     }
517 
518     /**
519      * @dev See {IERC20-transfer}.
520      *
521      * Requirements:
522      *
523      * - `recipient` cannot be the zero address.
524      * - the caller must have a balance of at least `amount`.
525      */
526     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
527         _transfer(_msgSender(), recipient, amount);
528         return true;
529     }
530 
531     /**
532      * @dev See {IERC20-allowance}.
533      */
534     function allowance(address owner, address spender) public view virtual override returns (uint256) {
535         return _allowances[owner][spender];
536     }
537 
538     /**
539      * @dev See {IERC20-approve}.
540      *
541      * Requirements:
542      *
543      * - `spender` cannot be the zero address.
544      */
545     function approve(address spender, uint256 amount) public virtual override returns (bool) {
546         _approve(_msgSender(), spender, amount);
547         return true;
548     }
549 
550     /**
551      * @dev See {IERC20-transferFrom}.
552      *
553      * Emits an {Approval} event indicating the updated allowance. This is not
554      * required by the EIP. See the note at the beginning of {ERC20};
555      *
556      * Requirements:
557      * - `sender` and `recipient` cannot be the zero address.
558      * - `sender` must have a balance of at least `amount`.
559      * - the caller must have allowance for ``sender``'s tokens of at least
560      * `amount`.
561      */
562     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
563         _transfer(sender, recipient, amount);
564         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
565         return true;
566     }
567 
568     /**
569      * @dev Atomically increases the allowance granted to `spender` by the caller.
570      *
571      * This is an alternative to {approve} that can be used as a mitigation for
572      * problems described in {IERC20-approve}.
573      *
574      * Emits an {Approval} event indicating the updated allowance.
575      *
576      * Requirements:
577      *
578      * - `spender` cannot be the zero address.
579      */
580     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
581         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
582         return true;
583     }
584 
585     /**
586      * @dev Atomically decreases the allowance granted to `spender` by the caller.
587      *
588      * This is an alternative to {approve} that can be used as a mitigation for
589      * problems described in {IERC20-approve}.
590      *
591      * Emits an {Approval} event indicating the updated allowance.
592      *
593      * Requirements:
594      *
595      * - `spender` cannot be the zero address.
596      * - `spender` must have allowance for the caller of at least
597      * `subtractedValue`.
598      */
599     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
600         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
601         return true;
602     }
603 
604     /**
605      * @dev Moves tokens `amount` from `sender` to `recipient`.
606      *
607      * This is internal function is equivalent to {transfer}, and can be used to
608      * e.g. implement automatic token fees, slashing mechanisms, etc.
609      *
610      * Emits a {Transfer} event.
611      *
612      * Requirements:
613      *
614      * - `sender` cannot be the zero address.
615      * - `recipient` cannot be the zero address.
616      * - `sender` must have a balance of at least `amount`.
617      */
618     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
619         require(sender != address(0), "ERC20: transfer from the zero address");
620         require(recipient != address(0), "ERC20: transfer to the zero address");
621 
622         _beforeTokenTransfer(sender, recipient, amount);
623 
624         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
625         _balances[recipient] = _balances[recipient].add(amount);
626         emit Transfer(sender, recipient, amount);
627     }
628 
629     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
630      * the total supply.
631      *
632      * Emits a {Transfer} event with `from` set to the zero address.
633      *
634      * Requirements
635      *
636      * - `to` cannot be the zero address.
637      */
638     function _mint(address account, uint256 amount) internal virtual {
639         require(account != address(0), "ERC20: mint to the zero address");
640 
641         _beforeTokenTransfer(address(0), account, amount);
642 
643         _totalSupply = _totalSupply.add(amount);
644         _balances[account] = _balances[account].add(amount);
645         emit Transfer(address(0), account, amount);
646     }
647 
648     /**
649      * @dev Destroys `amount` tokens from `account`, reducing the
650      * total supply.
651      *
652      * Emits a {Transfer} event with `to` set to the zero address.
653      *
654      * Requirements
655      *
656      * - `account` cannot be the zero address.
657      * - `account` must have at least `amount` tokens.
658      */
659     function _burn(address account, uint256 amount) internal virtual {
660         require(account != address(0), "ERC20: burn from the zero address");
661 
662         _beforeTokenTransfer(account, address(0), amount);
663 
664         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
665         _totalSupply = _totalSupply.sub(amount);
666         emit Transfer(account, address(0), amount);
667     }
668 
669     /**
670      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
671      *
672      * This is internal function is equivalent to `approve`, and can be used to
673      * e.g. set automatic allowances for certain subsystems, etc.
674      *
675      * Emits an {Approval} event.
676      *
677      * Requirements:
678      *
679      * - `owner` cannot be the zero address.
680      * - `spender` cannot be the zero address.
681      */
682     function _approve(address owner, address spender, uint256 amount) internal virtual {
683         require(owner != address(0), "ERC20: approve from the zero address");
684         require(spender != address(0), "ERC20: approve to the zero address");
685 
686         _allowances[owner][spender] = amount;
687         emit Approval(owner, spender, amount);
688     }
689 
690     /**
691      * @dev Sets {decimals} to a value other than the default one of 18.
692      *
693      * WARNING: This function should only be called from the constructor. Most
694      * applications that interact with token contracts will not expect
695      * {decimals} to ever change, and may work incorrectly if it does.
696      */
697     function _setupDecimals(uint8 decimals_) internal {
698         _decimals = decimals_;
699     }
700 
701     /**
702      * @dev Hook that is called before any transfer of tokens. This includes
703      * minting and burning.
704      *
705      * Calling conditions:
706      *
707      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
708      * will be to transferred to `to`.
709      * - when `from` is zero, `amount` tokens will be minted for `to`.
710      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
711      * - `from` and `to` are never both zero.
712      *
713      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
714      */
715     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
716 }
717 
718 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
719 
720 
721 pragma solidity ^0.6.0;
722 
723 
724 
725 
726 /**
727  * @title SafeERC20
728  * @dev Wrappers around ERC20 operations that throw on failure (when the token
729  * contract returns false). Tokens that return no value (and instead revert or
730  * throw on failure) are also supported, non-reverting calls are assumed to be
731  * successful.
732  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
733  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
734  */
735 library SafeERC20 {
736     using SafeMath for uint256;
737     using Address for address;
738 
739     function safeTransfer(IERC20 token, address to, uint256 value) internal {
740         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
741     }
742 
743     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
744         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
745     }
746 
747     /**
748      * @dev Deprecated. This function has issues similar to the ones found in
749      * {IERC20-approve}, and its usage is discouraged.
750      *
751      * Whenever possible, use {safeIncreaseAllowance} and
752      * {safeDecreaseAllowance} instead.
753      */
754     function safeApprove(IERC20 token, address spender, uint256 value) internal {
755         // safeApprove should only be called when setting an initial allowance,
756         // or when resetting it to zero. To increase and decrease it, use
757         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
758         // solhint-disable-next-line max-line-length
759         require((value == 0) || (token.allowance(address(this), spender) == 0),
760             "SafeERC20: approve from non-zero to non-zero allowance"
761         );
762         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
763     }
764 
765     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
766         uint256 newAllowance = token.allowance(address(this), spender).add(value);
767         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
768     }
769 
770     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
771         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
772         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
773     }
774 
775     /**
776      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
777      * on the return value: the return value is optional (but if data is returned, it must not be false).
778      * @param token The token targeted by the call.
779      * @param data The call data (encoded using abi.encode or one of its variants).
780      */
781     function _callOptionalReturn(IERC20 token, bytes memory data) private {
782         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
783         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
784         // the target address contains contract code and also asserts for success in the low-level call.
785 
786         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
787         if (returndata.length > 0) { // Return data is optional
788             // solhint-disable-next-line max-line-length
789             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
790         }
791     }
792 }
793 
794 // File: @openzeppelin/contracts/access/Ownable.sol
795 
796 
797 pragma solidity ^0.6.0;
798 
799 /**
800  * @dev Contract module which provides a basic access control mechanism, where
801  * there is an account (an owner) that can be granted exclusive access to
802  * specific functions.
803  *
804  * By default, the owner account will be the one that deploys the contract. This
805  * can later be changed with {transferOwnership}.
806  *
807  * This module is used through inheritance. It will make available the modifier
808  * `onlyOwner`, which can be applied to your functions to restrict their use to
809  * the owner.
810  */
811 contract Ownable is Context {
812     address private _owner;
813 
814     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
815 
816     /**
817      * @dev Initializes the contract setting the deployer as the initial owner.
818      */
819     constructor () internal {
820         address msgSender = _msgSender();
821         _owner = msgSender;
822         emit OwnershipTransferred(address(0), msgSender);
823     }
824 
825     /**
826      * @dev Returns the address of the current owner.
827      */
828     function owner() public view returns (address) {
829         return _owner;
830     }
831 
832     /**
833      * @dev Throws if called by any account other than the owner.
834      */
835     modifier onlyOwner() {
836         require(_owner == _msgSender(), "Ownable: caller is not the owner");
837         _;
838     }
839 
840     /**
841      * @dev Leaves the contract without owner. It will not be possible to call
842      * `onlyOwner` functions anymore. Can only be called by the current owner.
843      *
844      * NOTE: Renouncing ownership will leave the contract without an owner,
845      * thereby removing any functionality that is only available to the owner.
846      */
847     function renounceOwnership() public virtual onlyOwner {
848         emit OwnershipTransferred(_owner, address(0));
849         _owner = address(0);
850     }
851 
852     /**
853      * @dev Transfers ownership of the contract to a new account (`newOwner`).
854      * Can only be called by the current owner.
855      */
856     function transferOwnership(address newOwner) public virtual onlyOwner {
857         require(newOwner != address(0), "Ownable: new owner is the zero address");
858         emit OwnershipTransferred(_owner, newOwner);
859         _owner = newOwner;
860     }
861 }
862 
863 // File: @chainlink/contracts/src/v0.6/interfaces/AggregatorV3Interface.sol
864 
865 pragma solidity >=0.6.0;
866 
867 interface AggregatorV3Interface {
868   function decimals() external view returns (uint8);
869   function description() external view returns (string memory);
870   function version() external view returns (uint256);
871 
872   // getRoundData and latestRoundData should both raise "No data present"
873   // if they do not have data to report, instead of returning unset values
874   // which could be misinterpreted as actual reported values.
875   function getRoundData(uint80 _roundId)
876     external
877     view
878     returns (
879       uint80 roundId,
880       int256 answer,
881       uint256 startedAt,
882       uint256 updatedAt,
883       uint80 answeredInRound
884     );
885   function latestRoundData()
886     external
887     view
888     returns (
889       uint80 roundId,
890       int256 answer,
891       uint256 startedAt,
892       uint256 updatedAt,
893       uint80 answeredInRound
894     );
895 }
896 
897 // File: @uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router01.sol
898 
899 pragma solidity >=0.6.2;
900 
901 interface IUniswapV2Router01 {
902     function factory() external pure returns (address);
903     function WETH() external pure returns (address);
904 
905     function addLiquidity(
906         address tokenA,
907         address tokenB,
908         uint amountADesired,
909         uint amountBDesired,
910         uint amountAMin,
911         uint amountBMin,
912         address to,
913         uint deadline
914     ) external returns (uint amountA, uint amountB, uint liquidity);
915     function addLiquidityETH(
916         address token,
917         uint amountTokenDesired,
918         uint amountTokenMin,
919         uint amountETHMin,
920         address to,
921         uint deadline
922     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
923     function removeLiquidity(
924         address tokenA,
925         address tokenB,
926         uint liquidity,
927         uint amountAMin,
928         uint amountBMin,
929         address to,
930         uint deadline
931     ) external returns (uint amountA, uint amountB);
932     function removeLiquidityETH(
933         address token,
934         uint liquidity,
935         uint amountTokenMin,
936         uint amountETHMin,
937         address to,
938         uint deadline
939     ) external returns (uint amountToken, uint amountETH);
940     function removeLiquidityWithPermit(
941         address tokenA,
942         address tokenB,
943         uint liquidity,
944         uint amountAMin,
945         uint amountBMin,
946         address to,
947         uint deadline,
948         bool approveMax, uint8 v, bytes32 r, bytes32 s
949     ) external returns (uint amountA, uint amountB);
950     function removeLiquidityETHWithPermit(
951         address token,
952         uint liquidity,
953         uint amountTokenMin,
954         uint amountETHMin,
955         address to,
956         uint deadline,
957         bool approveMax, uint8 v, bytes32 r, bytes32 s
958     ) external returns (uint amountToken, uint amountETH);
959     function swapExactTokensForTokens(
960         uint amountIn,
961         uint amountOutMin,
962         address[] calldata path,
963         address to,
964         uint deadline
965     ) external returns (uint[] memory amounts);
966     function swapTokensForExactTokens(
967         uint amountOut,
968         uint amountInMax,
969         address[] calldata path,
970         address to,
971         uint deadline
972     ) external returns (uint[] memory amounts);
973     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
974         external
975         payable
976         returns (uint[] memory amounts);
977     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
978         external
979         returns (uint[] memory amounts);
980     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
981         external
982         returns (uint[] memory amounts);
983     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
984         external
985         payable
986         returns (uint[] memory amounts);
987 
988     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
989     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
990     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
991     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
992     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
993 }
994 
995 // File: contracts/Interfaces/Interfaces.sol
996 
997 pragma solidity 0.6.12;
998 
999 /**
1000  * Hegic
1001  * Copyright (C) 2020 Hegic Protocol
1002  *
1003  * This program is free software: you can redistribute it and/or modify
1004  * it under the terms of the GNU General Public License as published by
1005  * the Free Software Foundation, either version 3 of the License, or
1006  * (at your option) any later version.
1007  *
1008  * This program is distributed in the hope that it will be useful,
1009  * but WITHOUT ANY WARRANTY; without even the implied warranty of
1010  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1011  * GNU General Public License for more details.
1012  *
1013  * You should have received a copy of the GNU General Public License
1014  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
1015  */
1016 
1017 
1018 
1019 
1020 
1021 
1022 
1023 interface ILiquidityPool {
1024     struct LockedLiquidity { uint amount; uint premium; bool locked; }
1025 
1026     event Profit(uint indexed id, uint amount);
1027     event Loss(uint indexed id, uint amount);
1028     event Provide(address indexed account, uint256 amount, uint256 writeAmount);
1029     event Withdraw(address indexed account, uint256 amount, uint256 writeAmount);
1030 
1031     function unlock(uint256 id) external;
1032     function send(uint256 id, address payable account, uint256 amount) external;
1033     function setLockupPeriod(uint value) external;
1034     function totalBalance() external view returns (uint256 amount);
1035     // function unlockPremium(uint256 amount) external;
1036 }
1037 
1038 
1039 interface IERCLiquidityPool is ILiquidityPool {
1040     function lock(uint id, uint256 amount, uint premium) external;
1041     function token() external view returns (IERC20);
1042 }
1043 
1044 
1045 interface IETHLiquidityPool is ILiquidityPool {
1046     function lock(uint id, uint256 amount) external payable;
1047 }
1048 
1049 
1050 interface IHegicStaking {    
1051     event Claim(address indexed acount, uint amount);
1052     event Profit(uint amount);
1053 
1054 
1055     function claimProfit() external returns (uint profit);
1056     function buy(uint amount) external;
1057     function sell(uint amount) external;
1058     function profitOf(address account) external view returns (uint);
1059 }
1060 
1061 
1062 interface IHegicStakingETH is IHegicStaking {
1063     function sendProfit() external payable;
1064 }
1065 
1066 
1067 interface IHegicStakingERC20 is IHegicStaking {
1068     function sendProfit(uint amount) external;
1069 }
1070 
1071 
1072 interface IHegicOptions {
1073     event Create(
1074         uint256 indexed id,
1075         address indexed account,
1076         uint256 settlementFee,
1077         uint256 totalFee
1078     );
1079 
1080     event Exercise(uint256 indexed id, uint256 profit);
1081     event Expire(uint256 indexed id, uint256 premium);
1082     enum State {Inactive, Active, Exercised, Expired}
1083     enum OptionType {Invalid, Put, Call}
1084 
1085     struct Option {
1086         State state;
1087         address payable holder;
1088         uint256 strike;
1089         uint256 amount;
1090         uint256 lockedAmount;
1091         uint256 premium;
1092         uint256 expiration;
1093         OptionType optionType;
1094     }
1095 
1096     function options(uint) external view returns (
1097         State state,
1098         address payable holder,
1099         uint256 strike,
1100         uint256 amount,
1101         uint256 lockedAmount,
1102         uint256 premium,
1103         uint256 expiration,
1104         OptionType optionType
1105     );
1106 }
1107 
1108 // For the future integrations of non-standard ERC20 tokens such as USDT and others
1109 // interface ERC20Incorrect {
1110 //     event Transfer(address indexed from, address indexed to, uint256 value);
1111 //
1112 //     event Approval(address indexed owner, address indexed spender, uint256 value);
1113 //
1114 //     function transfer(address to, uint256 value) external;
1115 //
1116 //     function transferFrom(
1117 //         address from,
1118 //         address to,
1119 //         uint256 value
1120 //     ) external;
1121 //
1122 //     function approve(address spender, uint256 value) external;
1123 //     function balanceOf(address who) external view returns (uint256);
1124 //     function allowance(address owner, address spender) external view returns (uint256);
1125 //
1126 // }
1127 
1128 // File: contracts/Pool/HegicETHPool.sol
1129 
1130 pragma solidity 0.6.12;
1131 
1132 /**
1133  * Hegic
1134  * Copyright (C) 2020 Hegic Protocol
1135  *
1136  * This program is free software: you can redistribute it and/or modify
1137  * it under the terms of the GNU General Public License as published by
1138  * the Free Software Foundation, either version 3 of the License, or
1139  * (at your option) any later version.
1140  *
1141  * This program is distributed in the hope that it will be useful,
1142  * but WITHOUT ANY WARRANTY; without even the implied warranty of
1143  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1144  * GNU General Public License for more details.
1145  *
1146  * You should have received a copy of the GNU General Public License
1147  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
1148  */
1149 
1150 
1151 
1152 /**
1153  * @author 0mllwntrmt3
1154  * @title Hegic ETH Liquidity Pool
1155  * @notice Accumulates liquidity in ETH from LPs and distributes P&L in ETH
1156  */
1157 contract HegicETHPool is
1158     IETHLiquidityPool,
1159     Ownable,
1160     ERC20("Hegic ETH LP Token", "writeETH")
1161 {
1162     using SafeMath for uint256;
1163     uint256 public constant INITIAL_RATE = 1e3;
1164     uint256 public lockupPeriod = 2 weeks;
1165     uint256 public lockedAmount;
1166     uint256 public lockedPremium;
1167     mapping(address => uint256) public lastProvideTimestamp;
1168     mapping(address => bool) public _revertTransfersInLockUpPeriod;
1169     LockedLiquidity[] public lockedLiquidity;
1170 
1171     /**
1172      * @notice Used for changing the lockup period
1173      * @param value New period value
1174      */
1175     function setLockupPeriod(uint256 value) external override onlyOwner {
1176         require(value <= 60 days, "Lockup period is too large");
1177         lockupPeriod = value;
1178     }
1179 
1180     /**
1181      * @notice Used for ...
1182      */
1183     function revertTransfersInLockUpPeriod(bool value) external {
1184         _revertTransfersInLockUpPeriod[msg.sender] = value;
1185     }
1186 
1187     /*
1188      * @nonce A provider supplies ETH to the pool and receives writeETH tokens
1189      * @param minMint Minimum amount of tokens that should be received by a provider.
1190                       Calling the provide function will require the minimum amount of tokens to be minted.
1191                       The actual amount that will be minted could vary but can only be higher (not lower) than the minimum value.
1192      * @return mint Amount of tokens to be received
1193      */
1194     function provide(uint256 minMint) external payable returns (uint256 mint) {
1195         lastProvideTimestamp[msg.sender] = block.timestamp;
1196         uint supply = totalSupply();
1197         uint balance = totalBalance();
1198         if (supply > 0 && balance > 0)
1199             mint = msg.value.mul(supply).div(balance.sub(msg.value));
1200         else
1201             mint = msg.value.mul(INITIAL_RATE);
1202 
1203         require(mint >= minMint, "Pool: Mint limit is too large");
1204         require(mint > 0, "Pool: Amount is too small");
1205 
1206         _mint(msg.sender, mint);
1207         emit Provide(msg.sender, msg.value, mint);
1208     }
1209 
1210     /*
1211      * @nonce Provider burns writeETH and receives ETH from the pool
1212      * @param amount Amount of ETH to receive
1213      * @return burn Amount of tokens to be burnt
1214      */
1215     function withdraw(uint256 amount, uint256 maxBurn) external returns (uint256 burn) {
1216         require(
1217             lastProvideTimestamp[msg.sender].add(lockupPeriod) <= block.timestamp,
1218             "Pool: Withdrawal is locked up"
1219         );
1220         require(
1221             amount <= availableBalance(),
1222             "Pool Error: Not enough funds on the pool contract. Please lower the amount."
1223         );
1224 
1225         burn = divCeil(amount.mul(totalSupply()), totalBalance());
1226 
1227         require(burn <= maxBurn, "Pool: Burn limit is too small");
1228         require(burn <= balanceOf(msg.sender), "Pool: Amount is too large");
1229         require(burn > 0, "Pool: Amount is too small");
1230 
1231         _burn(msg.sender, burn);
1232         emit Withdraw(msg.sender, amount, burn);
1233         msg.sender.transfer(amount);
1234     }
1235 
1236     /*
1237      * @nonce calls by HegicCallOptions to lock the funds
1238      * @param amount Amount of funds that should be locked in an option
1239      */
1240     function lock(uint id, uint256 amount) external override onlyOwner payable {
1241         require(id == lockedLiquidity.length, "Wrong id");
1242         require(
1243             lockedAmount.add(amount).mul(10) <= totalBalance().sub(msg.value).mul(8),
1244             "Pool Error: Amount is too large."
1245         );
1246 
1247         lockedLiquidity.push(LockedLiquidity(amount, msg.value, true));
1248         lockedPremium = lockedPremium.add(msg.value);
1249         lockedAmount = lockedAmount.add(amount);
1250     }
1251 
1252     /*
1253      * @nonce calls by HegicOptions to unlock the funds
1254      * @param id Id of LockedLiquidity that should be unlocked
1255      */
1256     function unlock(uint256 id) external override onlyOwner {
1257         LockedLiquidity storage ll = lockedLiquidity[id];
1258         require(ll.locked, "LockedLiquidity with such id has already unlocked");
1259         ll.locked = false;
1260 
1261         lockedPremium = lockedPremium.sub(ll.premium);
1262         lockedAmount = lockedAmount.sub(ll.amount);
1263 
1264         emit Profit(id, ll.premium);
1265     }
1266 
1267     /*
1268      * @nonce calls by HegicCallOptions to send funds to liquidity providers after an option's expiration
1269      * @param to Provider
1270      * @param amount Funds that should be sent
1271      */
1272     function send(uint id, address payable to, uint256 amount)
1273         external
1274         override
1275         onlyOwner
1276     {
1277         LockedLiquidity storage ll = lockedLiquidity[id];
1278         require(ll.locked, "LockedLiquidity with such id has already unlocked");
1279         require(to != address(0));
1280 
1281         ll.locked = false;
1282         lockedPremium = lockedPremium.sub(ll.premium);
1283         lockedAmount = lockedAmount.sub(ll.amount);
1284 
1285         uint transferAmount = amount > ll.amount ? ll.amount : amount;
1286         to.transfer(transferAmount);
1287 
1288         if (transferAmount <= ll.premium)
1289             emit Profit(id, ll.premium - transferAmount);
1290         else
1291             emit Loss(id, transferAmount - ll.premium);
1292     }
1293 
1294     /*
1295      * @nonce Returns provider's share in ETH
1296      * @param account Provider's address
1297      * @return Provider's share in ETH
1298      */
1299     function shareOf(address account) external view returns (uint256 share) {
1300         if (totalSupply() > 0)
1301             share = totalBalance().mul(balanceOf(account)).div(totalSupply());
1302         else
1303             share = 0;
1304     }
1305 
1306     /*
1307      * @nonce Returns the amount of ETH available for withdrawals
1308      * @return balance Unlocked amount
1309      */
1310     function availableBalance() public view returns (uint256 balance) {
1311         return totalBalance().sub(lockedAmount);
1312     }
1313 
1314     /*
1315      * @nonce Returns the total balance of ETH provided to the pool
1316      * @return balance Pool balance
1317      */
1318     function totalBalance() public override view returns (uint256 balance) {
1319         return address(this).balance.sub(lockedPremium);
1320     }
1321 
1322     function _beforeTokenTransfer(address from, address to, uint256) internal override {
1323         if (
1324             lastProvideTimestamp[from].add(lockupPeriod) > block.timestamp &&
1325             lastProvideTimestamp[from] > lastProvideTimestamp[to]
1326         ) {
1327             require(
1328                 !_revertTransfersInLockUpPeriod[to],
1329                 "the recipient does not accept blocked funds"
1330             );
1331             lastProvideTimestamp[to] = lastProvideTimestamp[from];
1332         }
1333     }
1334 
1335     function divCeil(uint256 a, uint256 b) internal pure returns (uint256) {
1336         require(b > 0);
1337         uint256 c = a / b;
1338         if (a % b != 0)
1339             c = c + 1;
1340         return c;
1341     }
1342 }
1343 
1344 // File: contracts/Options/HegicETHOptions.sol
1345 
1346 pragma solidity 0.6.12;
1347 
1348 /**
1349  * Hegic
1350  * Copyright (C) 2020 Hegic Protocol
1351  *
1352  * This program is free software: you can redistribute it and/or modify
1353  * it under the terms of the GNU General Public License as published by
1354  * the Free Software Foundation, either version 3 of the License, or
1355  * (at your option) any later version.
1356  *
1357  * This program is distributed in the hope that it will be useful,
1358  * but WITHOUT ANY WARRANTY; without even the implied warranty of
1359  * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1360  * GNU General Public License for more details.
1361  *
1362  * You should have received a copy of the GNU General Public License
1363  * along with this program.  If not, see <http://www.gnu.org/licenses/>.
1364  */
1365 
1366 
1367 
1368 /**
1369  * @author 0mllwntrmt3
1370  * @title Hegic ETH (Ether) Bidirectional (Call and Put) Options
1371  * @notice Hegic ETH Options Contract
1372  */
1373 contract HegicETHOptions is Ownable, IHegicOptions {
1374     using SafeMath for uint256;
1375 
1376     IHegicStakingETH public settlementFeeRecipient;
1377     Option[] public override options;
1378     uint256 public impliedVolRate;
1379     uint256 public optionCollateralizationRatio = 100;
1380     uint256 internal constant PRICE_DECIMALS = 1e8;
1381     uint256 internal contractCreationTimestamp;
1382     AggregatorV3Interface public priceProvider;
1383     HegicETHPool public pool;
1384 
1385     /**
1386      * @param pp The address of ChainLink ETH/USD price feed contract
1387      */
1388     constructor(AggregatorV3Interface pp, IHegicStakingETH staking) public {
1389         pool = new HegicETHPool();
1390         priceProvider = pp;
1391         settlementFeeRecipient = staking;
1392         impliedVolRate = 4500;
1393         contractCreationTimestamp = block.timestamp;
1394     }
1395 
1396     /**
1397      * @notice Can be used to update the contract in critical situations
1398      *         in the first 14 days after deployment
1399      */
1400     function transferPoolOwnership() external onlyOwner {
1401         require(block.timestamp < contractCreationTimestamp + 14 days);
1402         pool.transferOwnership(owner());
1403     }
1404 
1405     /**
1406      * @notice Used for adjusting the options prices while balancing asset's implied volatility rate
1407      * @param value New IVRate value
1408      */
1409     function setImpliedVolRate(uint256 value) external onlyOwner {
1410         require(value >= 1000, "ImpliedVolRate limit is too small");
1411         impliedVolRate = value;
1412     }
1413 
1414     /**
1415      * @notice Used for changing settlementFeeRecipient
1416      * @param recipient New settlementFee recipient address
1417      */
1418     function setSettlementFeeRecipient(IHegicStakingETH recipient) external onlyOwner {
1419         require(block.timestamp < contractCreationTimestamp + 14 days);
1420         require(address(recipient) != address(0));
1421         settlementFeeRecipient = recipient;
1422     }
1423 
1424     /**
1425      * @notice Used for changing option collateralization ratio
1426      * @param value New optionCollateralizationRatio value
1427      */
1428     function setOptionCollaterizationRatio(uint value) external onlyOwner {
1429         require(50 <= value && value <= 100, "wrong value");
1430         optionCollateralizationRatio = value;
1431     }
1432 
1433     /**
1434      * @notice Creates a new option
1435      * @param period Option period in seconds (1 days <= period <= 4 weeks)
1436      * @param amount Option amount
1437      * @param strike Strike price of the option
1438      * @param optionType Call or Put option type
1439      * @return optionID Created option's ID
1440      */
1441     function create(
1442         uint256 period,
1443         uint256 amount,
1444         uint256 strike,
1445         OptionType optionType
1446     )
1447         external
1448         payable
1449         returns (uint256 optionID)
1450     {
1451         (uint256 total, uint256 settlementFee, uint256 strikeFee, ) = fees(
1452             period,
1453             amount,
1454             strike,
1455             optionType
1456         );
1457         require(period >= 1 days, "Period is too short");
1458         require(period <= 4 weeks, "Period is too long");
1459         require(amount > strikeFee, "Price difference is too large");
1460         require(msg.value >= total, "Wrong value");
1461         if (msg.value > total) msg.sender.transfer(msg.value - total);
1462 
1463         uint256 strikeAmount = amount.sub(strikeFee);
1464         optionID = options.length;
1465         Option memory option = Option(
1466             State.Active,
1467             msg.sender,
1468             strike,
1469             amount,
1470             strikeAmount.mul(optionCollateralizationRatio).div(100).add(strikeFee),
1471             total.sub(settlementFee),
1472             block.timestamp + period,
1473             optionType
1474         );
1475 
1476         options.push(option);
1477         settlementFeeRecipient.sendProfit {value: settlementFee}();
1478         pool.lock {value: option.premium} (optionID, option.lockedAmount);
1479         emit Create(optionID, msg.sender, settlementFee, total);
1480     }
1481 
1482     /**
1483      * @notice Transfers an active option
1484      * @param optionID ID of your option
1485      * @param newHolder Address of new option holder
1486      */
1487     function transfer(uint256 optionID, address payable newHolder) external {
1488         Option storage option = options[optionID];
1489 
1490         require(newHolder != address(0), "new holder address is zero");
1491         require(option.expiration >= block.timestamp, "Option has expired");
1492         require(option.holder == msg.sender, "Wrong msg.sender");
1493         require(option.state == State.Active, "Only active options could be transferred");
1494 
1495         option.holder = newHolder;
1496     }
1497 
1498     /**
1499      * @notice Exercises an active option
1500      * @param optionID ID of your option
1501      */
1502     function exercise(uint256 optionID) external {
1503         Option storage option = options[optionID];
1504 
1505         require(option.expiration >= block.timestamp, "Option has expired");
1506         require(option.holder == msg.sender, "Wrong msg.sender");
1507         require(option.state == State.Active, "Wrong state");
1508 
1509         option.state = State.Exercised;
1510         uint256 profit = payProfit(optionID);
1511 
1512         emit Exercise(optionID, profit);
1513     }
1514 
1515     /**
1516      * @notice Unlocks an array of options
1517      * @param optionIDs array of options
1518      */
1519     function unlockAll(uint256[] calldata optionIDs) external {
1520         uint arrayLength = optionIDs.length;
1521         for (uint256 i = 0; i < arrayLength; i++) {
1522             unlock(optionIDs[i]);
1523         }
1524     }
1525 
1526     /**
1527      * @notice Used for getting the actual options prices
1528      * @param period Option period in seconds (1 days <= period <= 4 weeks)
1529      * @param amount Option amount
1530      * @param strike Strike price of the option
1531      * @return total Total price to be paid
1532      * @return settlementFee Amount to be distributed to the HEGIC token holders
1533      * @return strikeFee Amount that covers the price difference in the ITM options
1534      * @return periodFee Option period fee amount
1535      */
1536     function fees(
1537         uint256 period,
1538         uint256 amount,
1539         uint256 strike,
1540         OptionType optionType
1541     )
1542         public
1543         view
1544         returns (
1545             uint256 total,
1546             uint256 settlementFee,
1547             uint256 strikeFee,
1548             uint256 periodFee
1549         )
1550     {
1551         (,int latestPrice,,,) = priceProvider.latestRoundData();
1552         uint256 currentPrice = uint256(latestPrice);
1553         settlementFee = getSettlementFee(amount);
1554         periodFee = getPeriodFee(amount, period, strike, currentPrice, optionType);
1555         strikeFee = getStrikeFee(amount, strike, currentPrice, optionType);
1556         total = periodFee.add(strikeFee).add(settlementFee);
1557     }
1558 
1559     /**
1560      * @notice Unlock funds locked in the expired options
1561      * @param optionID ID of the option
1562      */
1563     function unlock(uint256 optionID) public {
1564         Option storage option = options[optionID];
1565         require(option.expiration < block.timestamp, "Option has not expired yet");
1566         require(option.state == State.Active, "Option is not active");
1567         option.state = State.Expired;
1568         pool.unlock(optionID);
1569         emit Expire(optionID, option.premium);
1570     }
1571 
1572     /**
1573      * @notice Calculates settlementFee
1574      * @param amount Option amount
1575      * @return fee Settlement fee amount
1576      */
1577     function getSettlementFee(uint256 amount)
1578         internal
1579         pure
1580         returns (uint256 fee)
1581     {
1582         return amount / 100;
1583     }
1584 
1585     /**
1586      * @notice Calculates periodFee
1587      * @param amount Option amount
1588      * @param period Option period in seconds (1 days <= period <= 4 weeks)
1589      * @param strike Strike price of the option
1590      * @param currentPrice Current price of ETH
1591      * @return fee Period fee amount
1592      *
1593      * amount < 1e30        |
1594      * impliedVolRate < 1e10| => amount * impliedVolRate * strike < 1e60 < 2^uint256
1595      * strike < 1e20 ($1T)  |
1596      *
1597      * in case amount * impliedVolRate * strike >= 2^256
1598      * transaction will be reverted by the SafeMath
1599      */
1600     function getPeriodFee(
1601         uint256 amount,
1602         uint256 period,
1603         uint256 strike,
1604         uint256 currentPrice,
1605         OptionType optionType
1606     ) internal view returns (uint256 fee) {
1607         if (optionType == OptionType.Put)
1608             return amount
1609                 .mul(sqrt(period))
1610                 .mul(impliedVolRate)
1611                 .mul(strike)
1612                 .div(currentPrice)
1613                 .div(PRICE_DECIMALS);
1614         else
1615             return amount
1616                 .mul(sqrt(period))
1617                 .mul(impliedVolRate)
1618                 .mul(currentPrice)
1619                 .div(strike)
1620                 .div(PRICE_DECIMALS);
1621     }
1622 
1623     /**
1624      * @notice Calculates strikeFee
1625      * @param amount Option amount
1626      * @param strike Strike price of the option
1627      * @param currentPrice Current price of ETH
1628      * @return fee Strike fee amount
1629      */
1630     function getStrikeFee(
1631         uint256 amount,
1632         uint256 strike,
1633         uint256 currentPrice,
1634         OptionType optionType
1635     ) internal pure returns (uint256 fee) {
1636         if (strike > currentPrice && optionType == OptionType.Put)
1637             return strike.sub(currentPrice).mul(amount).div(currentPrice);
1638         if (strike < currentPrice && optionType == OptionType.Call)
1639             return currentPrice.sub(strike).mul(amount).div(currentPrice);
1640         return 0;
1641     }
1642 
1643     /**
1644      * @notice Sends profits in ETH from the ETH pool to an option holder's address
1645      * @param optionID A specific option contract id
1646      */
1647     function payProfit(uint optionID)
1648         internal
1649         returns (uint profit)
1650     {
1651         Option memory option = options[optionID];
1652         (, int latestPrice, , , ) = priceProvider.latestRoundData();
1653         uint256 currentPrice = uint256(latestPrice);
1654         if (option.optionType == OptionType.Call) {
1655             require(option.strike <= currentPrice, "Current price is too low");
1656             profit = currentPrice.sub(option.strike).mul(option.amount).div(currentPrice);
1657         } else {
1658             require(option.strike >= currentPrice, "Current price is too high");
1659             profit = option.strike.sub(currentPrice).mul(option.amount).div(currentPrice);
1660         }
1661         if (profit > option.lockedAmount)
1662             profit = option.lockedAmount;
1663         pool.send(optionID, option.holder, profit);
1664     }
1665 
1666 
1667 
1668     /**
1669      * @return result Square root of the number
1670      */
1671     function sqrt(uint256 x) private pure returns (uint256 result) {
1672         result = x;
1673         uint256 k = x.div(2).add(1);
1674         while (k < result) (result, k) = (k, x.div(k).add(k).div(2));
1675     }
1676 }