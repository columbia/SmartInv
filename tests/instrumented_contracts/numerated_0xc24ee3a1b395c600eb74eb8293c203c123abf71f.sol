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
670      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
671      *
672      * This internal function is equivalent to `approve`, and can be used to
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
718 // File: @openzeppelin/contracts/access/Ownable.sol
719 
720 
721 pragma solidity ^0.6.0;
722 
723 /**
724  * @dev Contract module which provides a basic access control mechanism, where
725  * there is an account (an owner) that can be granted exclusive access to
726  * specific functions.
727  *
728  * By default, the owner account will be the one that deploys the contract. This
729  * can later be changed with {transferOwnership}.
730  *
731  * This module is used through inheritance. It will make available the modifier
732  * `onlyOwner`, which can be applied to your functions to restrict their use to
733  * the owner.
734  */
735 contract Ownable is Context {
736     address private _owner;
737 
738     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
739 
740     /**
741      * @dev Initializes the contract setting the deployer as the initial owner.
742      */
743     constructor () internal {
744         address msgSender = _msgSender();
745         _owner = msgSender;
746         emit OwnershipTransferred(address(0), msgSender);
747     }
748 
749     /**
750      * @dev Returns the address of the current owner.
751      */
752     function owner() public view returns (address) {
753         return _owner;
754     }
755 
756     /**
757      * @dev Throws if called by any account other than the owner.
758      */
759     modifier onlyOwner() {
760         require(_owner == _msgSender(), "Ownable: caller is not the owner");
761         _;
762     }
763 
764     /**
765      * @dev Leaves the contract without owner. It will not be possible to call
766      * `onlyOwner` functions anymore. Can only be called by the current owner.
767      *
768      * NOTE: Renouncing ownership will leave the contract without an owner,
769      * thereby removing any functionality that is only available to the owner.
770      */
771     function renounceOwnership() public virtual onlyOwner {
772         emit OwnershipTransferred(_owner, address(0));
773         _owner = address(0);
774     }
775 
776     /**
777      * @dev Transfers ownership of the contract to a new account (`newOwner`).
778      * Can only be called by the current owner.
779      */
780     function transferOwnership(address newOwner) public virtual onlyOwner {
781         require(newOwner != address(0), "Ownable: new owner is the zero address");
782         emit OwnershipTransferred(_owner, newOwner);
783         _owner = newOwner;
784     }
785 }
786 
787 // File: contracts/RoseToken.sol
788 
789 pragma solidity 0.6.12;
790 
791 
792 
793 // RoseToken with Governance.
794 contract RoseToken is ERC20("RoseToken", "ROSE"), Ownable {
795     // @notice Creates `_amount` token to `_to`. Must only be called by the owner (RoseMain).
796     function mint(address _to, uint256 _amount) public onlyOwner {
797         _mint(_to, _amount);
798     }
799 }