1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/GSN/Context.sol
4 
5 pragma solidity ^0.7.0;
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
28 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
29 
30 pragma solidity ^0.7.0;
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
108 pragma solidity ^0.7.0;
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
266 // File: @openzeppelin/contracts/utils/Address.sol
267 
268 pragma solidity ^0.7.0;
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
292         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
293         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
294         // for accounts without code, i.e. `keccak256('')`
295         bytes32 codehash;
296         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
297         // solhint-disable-next-line no-inline-assembly
298         assembly { codehash := extcodehash(account) }
299         return (codehash != accountHash && codehash != 0x0);
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
408 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
409 
410 pragma solidity ^0.7.0;
411 
412 /**
413  * @dev Implementation of the {IERC20} interface.
414  *
415  * This implementation is agnostic to the way tokens are created. This means
416  * that a supply mechanism has to be added in a derived contract using {_mint}.
417  * For a generic mechanism see {ERC20PresetMinterPauser}.
418  *
419  * TIP: For a detailed writeup see our guide
420  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
421  * to implement supply mechanisms].
422  *
423  * We have followed general OpenZeppelin guidelines: functions revert instead
424  * of returning `false` on failure. This behavior is nonetheless conventional
425  * and does not conflict with the expectations of ERC20 applications.
426  *
427  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
428  * This allows applications to reconstruct the allowance for all accounts just
429  * by listening to said events. Other implementations of the EIP may not emit
430  * these events, as it isn't required by the specification.
431  *
432  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
433  * functions have been added to mitigate the well-known issues around setting
434  * allowances. See {IERC20-approve}.
435  */
436 contract ERC20 is Context, IERC20 {
437     using SafeMath for uint256;
438     using Address for address;
439 
440     mapping (address => uint256) private _balances;
441 
442     mapping (address => mapping (address => uint256)) private _allowances;
443 
444     uint256 private _totalSupply;
445 
446     string private _name;
447     string private _symbol;
448     uint8 private _decimals;
449 
450     /**
451      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
452      * a default value of 18.
453      *
454      * To select a different value for {decimals}, use {_setupDecimals}.
455      *
456      * All three of these values are immutable: they can only be set once during
457      * construction.
458      */
459     constructor (string memory name, string memory symbol) {
460         _name = name;
461         _symbol = symbol;
462         _decimals = 18;
463     }
464 
465     /**
466      * @dev Returns the name of the token.
467      */
468     function name() public view returns (string memory) {
469         return _name;
470     }
471 
472     /**
473      * @dev Returns the symbol of the token, usually a shorter version of the
474      * name.
475      */
476     function symbol() public view returns (string memory) {
477         return _symbol;
478     }
479 
480     /**
481      * @dev Returns the number of decimals used to get its user representation.
482      * For example, if `decimals` equals `2`, a balance of `505` tokens should
483      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
484      *
485      * Tokens usually opt for a value of 18, imitating the relationship between
486      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
487      * called.
488      *
489      * NOTE: This information is only used for _display_ purposes: it in
490      * no way affects any of the arithmetic of the contract, including
491      * {IERC20-balanceOf} and {IERC20-transfer}.
492      */
493     function decimals() public view returns (uint8) {
494         return _decimals;
495     }
496 
497     /**
498      * @dev See {IERC20-totalSupply}.
499      */
500     function totalSupply() public view override returns (uint256) {
501         return _totalSupply;
502     }
503 
504     /**
505      * @dev See {IERC20-balanceOf}.
506      */
507     function balanceOf(address account) public view override returns (uint256) {
508         return _balances[account];
509     }
510 
511     /**
512      * @dev See {IERC20-transfer}.
513      *
514      * Requirements:
515      *
516      * - `recipient` cannot be the zero address.
517      * - the caller must have a balance of at least `amount`.
518      */
519     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
520         _transfer(_msgSender(), recipient, amount);
521         return true;
522     }
523 
524     /**
525      * @dev See {IERC20-allowance}.
526      */
527     function allowance(address owner, address spender) public view virtual override returns (uint256) {
528         return _allowances[owner][spender];
529     }
530 
531     /**
532      * @dev See {IERC20-approve}.
533      *
534      * Requirements:
535      *
536      * - `spender` cannot be the zero address.
537      */
538     function approve(address spender, uint256 amount) public virtual override returns (bool) {
539         _approve(_msgSender(), spender, amount);
540         return true;
541     }
542 
543     /**
544      * @dev See {IERC20-transferFrom}.
545      *
546      * Emits an {Approval} event indicating the updated allowance. This is not
547      * required by the EIP. See the note at the beginning of {ERC20};
548      *
549      * Requirements:
550      * - `sender` and `recipient` cannot be the zero address.
551      * - `sender` must have a balance of at least `amount`.
552      * - the caller must have allowance for ``sender``'s tokens of at least
553      * `amount`.
554      */
555     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
556         _transfer(sender, recipient, amount);
557         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
558         return true;
559     }
560 
561     /**
562      * @dev Atomically increases the allowance granted to `spender` by the caller.
563      *
564      * This is an alternative to {approve} that can be used as a mitigation for
565      * problems described in {IERC20-approve}.
566      *
567      * Emits an {Approval} event indicating the updated allowance.
568      *
569      * Requirements:
570      *
571      * - `spender` cannot be the zero address.
572      */
573     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
574         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
575         return true;
576     }
577 
578     /**
579      * @dev Atomically decreases the allowance granted to `spender` by the caller.
580      *
581      * This is an alternative to {approve} that can be used as a mitigation for
582      * problems described in {IERC20-approve}.
583      *
584      * Emits an {Approval} event indicating the updated allowance.
585      *
586      * Requirements:
587      *
588      * - `spender` cannot be the zero address.
589      * - `spender` must have allowance for the caller of at least
590      * `subtractedValue`.
591      */
592     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
593         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
594         return true;
595     }
596 
597     /**
598      * @dev Moves tokens `amount` from `sender` to `recipient`.
599      *
600      * This is internal function is equivalent to {transfer}, and can be used to
601      * e.g. implement automatic token fees, slashing mechanisms, etc.
602      *
603      * Emits a {Transfer} event.
604      *
605      * Requirements:
606      *
607      * - `sender` cannot be the zero address.
608      * - `recipient` cannot be the zero address.
609      * - `sender` must have a balance of at least `amount`.
610      */
611     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
612         require(sender != address(0), "ERC20: transfer from the zero address");
613         require(recipient != address(0), "ERC20: transfer to the zero address");
614 
615         _beforeTokenTransfer(sender, recipient, amount);
616 
617         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
618         _balances[recipient] = _balances[recipient].add(amount);
619         emit Transfer(sender, recipient, amount);
620     }
621 
622     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
623      * the total supply.
624      *
625      * Emits a {Transfer} event with `from` set to the zero address.
626      *
627      * Requirements
628      *
629      * - `to` cannot be the zero address.
630      */
631     function _mint(address account, uint256 amount) internal virtual {
632         require(account != address(0), "ERC20: mint to the zero address");
633 
634         _beforeTokenTransfer(address(0), account, amount);
635 
636         _totalSupply = _totalSupply.add(amount);
637         _balances[account] = _balances[account].add(amount);
638         emit Transfer(address(0), account, amount);
639     }
640 
641     /**
642      * @dev Destroys `amount` tokens from `account`, reducing the
643      * total supply.
644      *
645      * Emits a {Transfer} event with `to` set to the zero address.
646      *
647      * Requirements
648      *
649      * - `account` cannot be the zero address.
650      * - `account` must have at least `amount` tokens.
651      */
652     function _burn(address account, uint256 amount) internal virtual {
653         require(account != address(0), "ERC20: burn from the zero address");
654 
655         _beforeTokenTransfer(account, address(0), amount);
656 
657         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
658         _totalSupply = _totalSupply.sub(amount);
659         emit Transfer(account, address(0), amount);
660     }
661 
662     /**
663      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
664      *
665      * This internal function is equivalent to `approve`, and can be used to
666      * e.g. set automatic allowances for certain subsystems, etc.
667      *
668      * Emits an {Approval} event.
669      *
670      * Requirements:
671      *
672      * - `owner` cannot be the zero address.
673      * - `spender` cannot be the zero address.
674      */
675     function _approve(address owner, address spender, uint256 amount) internal virtual {
676         require(owner != address(0), "ERC20: approve from the zero address");
677         require(spender != address(0), "ERC20: approve to the zero address");
678 
679         _allowances[owner][spender] = amount;
680         emit Approval(owner, spender, amount);
681     }
682 
683     /**
684      * @dev Sets {decimals} to a value other than the default one of 18.
685      *
686      * WARNING: This function should only be called from the constructor. Most
687      * applications that interact with token contracts will not expect
688      * {decimals} to ever change, and may work incorrectly if it does.
689      */
690     function _setupDecimals(uint8 decimals_) internal {
691         _decimals = decimals_;
692     }
693 
694     /**
695      * @dev Hook that is called before any transfer of tokens. This includes
696      * minting and burning.
697      *
698      * Calling conditions:
699      *
700      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
701      * will be to transferred to `to`.
702      * - when `from` is zero, `amount` tokens will be minted for `to`.
703      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
704      * - `from` and `to` are never both zero.
705      *
706      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
707      */
708     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
709 }
710 
711 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
712 
713 pragma solidity ^0.7.0;
714 
715 /**
716  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
717  */
718 abstract contract ERC20Capped is ERC20 {
719     using SafeMath for uint256;
720 
721     uint256 private _cap;
722 
723     /**
724      * @dev Sets the value of the `cap`. This value is immutable, it can only be
725      * set once during construction.
726      */
727     constructor (uint256 cap) {
728         require(cap > 0, "ERC20Capped: cap is 0");
729         _cap = cap;
730     }
731 
732     /**
733      * @dev Returns the cap on the token's total supply.
734      */
735     function cap() public view returns (uint256) {
736         return _cap;
737     }
738 
739     /**
740      * @dev See {ERC20-_beforeTokenTransfer}.
741      *
742      * Requirements:
743      *
744      * - minted tokens must not cause the total supply to go over the cap.
745      */
746     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
747         super._beforeTokenTransfer(from, to, amount);
748 
749         if (from == address(0)) { // When minting tokens
750             require(totalSupply().add(amount) <= _cap, "ERC20Capped: cap exceeded");
751         }
752     }
753 }
754 
755 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
756 
757 pragma solidity ^0.7.0;
758 
759 /**
760  * @dev Extension of {ERC20} that allows token holders to destroy both their own
761  * tokens and those that they have an allowance for, in a way that can be
762  * recognized off-chain (via event analysis).
763  */
764 abstract contract ERC20Burnable is Context, ERC20 {
765     using SafeMath for uint256;
766 
767     /**
768      * @dev Destroys `amount` tokens from the caller.
769      *
770      * See {ERC20-_burn}.
771      */
772     function burn(uint256 amount) public virtual {
773         _burn(_msgSender(), amount);
774     }
775 
776     /**
777      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
778      * allowance.
779      *
780      * See {ERC20-_burn} and {ERC20-allowance}.
781      *
782      * Requirements:
783      *
784      * - the caller must have allowance for ``accounts``'s tokens of at least
785      * `amount`.
786      */
787     function burnFrom(address account, uint256 amount) public virtual {
788         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
789 
790         _approve(account, _msgSender(), decreasedAllowance);
791         _burn(account, amount);
792     }
793 }
794 
795 // File: @openzeppelin/contracts/introspection/IERC165.sol
796 
797 pragma solidity ^0.7.0;
798 
799 /**
800  * @dev Interface of the ERC165 standard, as defined in the
801  * https://eips.ethereum.org/EIPS/eip-165[EIP].
802  *
803  * Implementers can declare support of contract interfaces, which can then be
804  * queried by others ({ERC165Checker}).
805  *
806  * For an implementation, see {ERC165}.
807  */
808 interface IERC165 {
809     /**
810      * @dev Returns true if this contract implements the interface defined by
811      * `interfaceId`. See the corresponding
812      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
813      * to learn more about how these ids are created.
814      *
815      * This function call must use less than 30 000 gas.
816      */
817     function supportsInterface(bytes4 interfaceId) external view returns (bool);
818 }
819 
820 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
821 
822 pragma solidity ^0.7.0;
823 
824 /**
825  * @title IERC1363 Interface
826  * @author Vittorio Minacori (https://github.com/vittominacori)
827  * @dev Interface for a Payable Token contract as defined in
828  *  https://eips.ethereum.org/EIPS/eip-1363
829  */
830 interface IERC1363 is IERC20, IERC165 {
831     /*
832      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
833      * 0x4bbee2df ===
834      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
835      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
836      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
837      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
838      */
839 
840     /*
841      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
842      * 0xfb9ec8ce ===
843      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
844      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
845      */
846 
847     /**
848      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
849      * @param to address The address which you want to transfer to
850      * @param value uint256 The amount of tokens to be transferred
851      * @return true unless throwing
852      */
853     function transferAndCall(address to, uint256 value) external returns (bool);
854 
855     /**
856      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
857      * @param to address The address which you want to transfer to
858      * @param value uint256 The amount of tokens to be transferred
859      * @param data bytes Additional data with no specified format, sent in call to `to`
860      * @return true unless throwing
861      */
862     function transferAndCall(address to, uint256 value, bytes calldata data) external returns (bool);
863 
864     /**
865      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
866      * @param from address The address which you want to send tokens from
867      * @param to address The address which you want to transfer to
868      * @param value uint256 The amount of tokens to be transferred
869      * @return true unless throwing
870      */
871     function transferFromAndCall(address from, address to, uint256 value) external returns (bool);
872 
873     /**
874      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
875      * @param from address The address which you want to send tokens from
876      * @param to address The address which you want to transfer to
877      * @param value uint256 The amount of tokens to be transferred
878      * @param data bytes Additional data with no specified format, sent in call to `to`
879      * @return true unless throwing
880      */
881     function transferFromAndCall(address from, address to, uint256 value, bytes calldata data) external returns (bool);
882 
883     /**
884      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
885      * and then call `onApprovalReceived` on spender.
886      * Beware that changing an allowance with this method brings the risk that someone may use both the old
887      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
888      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
889      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
890      * @param spender address The address which will spend the funds
891      * @param value uint256 The amount of tokens to be spent
892      */
893     function approveAndCall(address spender, uint256 value) external returns (bool);
894 
895     /**
896      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
897      * and then call `onApprovalReceived` on spender.
898      * Beware that changing an allowance with this method brings the risk that someone may use both the old
899      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
900      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
901      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
902      * @param spender address The address which will spend the funds
903      * @param value uint256 The amount of tokens to be spent
904      * @param data bytes Additional data with no specified format, sent in call to `spender`
905      */
906     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
907 }
908 
909 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
910 
911 pragma solidity ^0.7.0;
912 
913 /**
914  * @title IERC1363Receiver Interface
915  * @author Vittorio Minacori (https://github.com/vittominacori)
916  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
917  *  from ERC1363 token contracts as defined in
918  *  https://eips.ethereum.org/EIPS/eip-1363
919  */
920 interface IERC1363Receiver {
921     /*
922      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
923      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
924      */
925 
926     /**
927      * @notice Handle the receipt of ERC1363 tokens
928      * @dev Any ERC1363 smart contract calls this function on the recipient
929      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
930      * transfer. Return of other than the magic value MUST result in the
931      * transaction being reverted.
932      * Note: the token contract address is always the message sender.
933      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
934      * @param from address The address which are token transferred from
935      * @param value uint256 The amount of tokens transferred
936      * @param data bytes Additional data with no specified format
937      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
938      *  unless throwing
939      */
940     function onTransferReceived(address operator, address from, uint256 value, bytes calldata data) external returns (bytes4); // solhint-disable-line  max-line-length
941 }
942 
943 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
944 
945 pragma solidity ^0.7.0;
946 
947 /**
948  * @title IERC1363Spender Interface
949  * @author Vittorio Minacori (https://github.com/vittominacori)
950  * @dev Interface for any contract that wants to support approveAndCall
951  *  from ERC1363 token contracts as defined in
952  *  https://eips.ethereum.org/EIPS/eip-1363
953  */
954 interface IERC1363Spender {
955     /*
956      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
957      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
958      */
959 
960     /**
961      * @notice Handle the approval of ERC1363 tokens
962      * @dev Any ERC1363 smart contract calls this function on the recipient
963      * after an `approve`. This function MAY throw to revert and reject the
964      * approval. Return of other than the magic value MUST result in the
965      * transaction being reverted.
966      * Note: the token contract address is always the message sender.
967      * @param owner address The address which called `approveAndCall` function
968      * @param value uint256 The amount of tokens to be spent
969      * @param data bytes Additional data with no specified format
970      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
971      *  unless throwing
972      */
973     function onApprovalReceived(address owner, uint256 value, bytes calldata data) external returns (bytes4);
974 }
975 
976 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
977 
978 pragma solidity ^0.7.0;
979 
980 /**
981  * @dev Library used to query support of an interface declared via {IERC165}.
982  *
983  * Note that these functions return the actual result of the query: they do not
984  * `revert` if an interface is not supported. It is up to the caller to decide
985  * what to do in these cases.
986  */
987 library ERC165Checker {
988     // As per the EIP-165 spec, no interface should ever match 0xffffffff
989     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
990 
991     /*
992      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
993      */
994     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
995 
996     /**
997      * @dev Returns true if `account` supports the {IERC165} interface,
998      */
999     function supportsERC165(address account) internal view returns (bool) {
1000         // Any contract that implements ERC165 must explicitly indicate support of
1001         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
1002         return _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
1003             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
1004     }
1005 
1006     /**
1007      * @dev Returns true if `account` supports the interface defined by
1008      * `interfaceId`. Support for {IERC165} itself is queried automatically.
1009      *
1010      * See {IERC165-supportsInterface}.
1011      */
1012     function supportsInterface(address account, bytes4 interfaceId) internal view returns (bool) {
1013         // query support of both ERC165 as per the spec and support of _interfaceId
1014         return supportsERC165(account) &&
1015             _supportsERC165Interface(account, interfaceId);
1016     }
1017 
1018     /**
1019      * @dev Returns true if `account` supports all the interfaces defined in
1020      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
1021      *
1022      * Batch-querying can lead to gas savings by skipping repeated checks for
1023      * {IERC165} support.
1024      *
1025      * See {IERC165-supportsInterface}.
1026      */
1027     function supportsAllInterfaces(address account, bytes4[] memory interfaceIds) internal view returns (bool) {
1028         // query support of ERC165 itself
1029         if (!supportsERC165(account)) {
1030             return false;
1031         }
1032 
1033         // query support of each interface in _interfaceIds
1034         for (uint256 i = 0; i < interfaceIds.length; i++) {
1035             if (!_supportsERC165Interface(account, interfaceIds[i])) {
1036                 return false;
1037             }
1038         }
1039 
1040         // all interfaces supported
1041         return true;
1042     }
1043 
1044     /**
1045      * @notice Query if a contract implements an interface, does not check ERC165 support
1046      * @param account The address of the contract to query for support of an interface
1047      * @param interfaceId The interface identifier, as specified in ERC-165
1048      * @return true if the contract at account indicates support of the interface with
1049      * identifier interfaceId, false otherwise
1050      * @dev Assumes that account contains a contract that supports ERC165, otherwise
1051      * the behavior of this method is undefined. This precondition can be checked
1052      * with {supportsERC165}.
1053      * Interface identification is specified in ERC-165.
1054      */
1055     function _supportsERC165Interface(address account, bytes4 interfaceId) private view returns (bool) {
1056         // success determines whether the staticcall succeeded and result determines
1057         // whether the contract at account indicates support of _interfaceId
1058         (bool success, bool result) = _callERC165SupportsInterface(account, interfaceId);
1059 
1060         return (success && result);
1061     }
1062 
1063     /**
1064      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
1065      * @param account The address of the contract to query for support of an interface
1066      * @param interfaceId The interface identifier, as specified in ERC-165
1067      * @return success true if the STATICCALL succeeded, false otherwise
1068      * @return result true if the STATICCALL succeeded and the contract at account
1069      * indicates support of the interface with identifier interfaceId, false otherwise
1070      */
1071     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
1072         private
1073         view
1074         returns (bool, bool)
1075     {
1076         bytes memory encodedParams = abi.encodeWithSelector(_INTERFACE_ID_ERC165, interfaceId);
1077         (bool success, bytes memory result) = account.staticcall{ gas: 30000 }(encodedParams);
1078         if (result.length < 32) return (false, false);
1079         return (success, abi.decode(result, (bool)));
1080     }
1081 }
1082 
1083 // File: @openzeppelin/contracts/introspection/ERC165.sol
1084 
1085 pragma solidity ^0.7.0;
1086 
1087 /**
1088  * @dev Implementation of the {IERC165} interface.
1089  *
1090  * Contracts may inherit from this and call {_registerInterface} to declare
1091  * their support of an interface.
1092  */
1093 contract ERC165 is IERC165 {
1094     /*
1095      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1096      */
1097     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1098 
1099     /**
1100      * @dev Mapping of interface ids to whether or not it's supported.
1101      */
1102     mapping(bytes4 => bool) private _supportedInterfaces;
1103 
1104     constructor () {
1105         // Derived contracts need only register support for their own interfaces,
1106         // we register support for ERC165 itself here
1107         _registerInterface(_INTERFACE_ID_ERC165);
1108     }
1109 
1110     /**
1111      * @dev See {IERC165-supportsInterface}.
1112      *
1113      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1114      */
1115     function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
1116         return _supportedInterfaces[interfaceId];
1117     }
1118 
1119     /**
1120      * @dev Registers the contract as an implementer of the interface defined by
1121      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1122      * registering its interface id is not required.
1123      *
1124      * See {IERC165-supportsInterface}.
1125      *
1126      * Requirements:
1127      *
1128      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1129      */
1130     function _registerInterface(bytes4 interfaceId) internal virtual {
1131         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1132         _supportedInterfaces[interfaceId] = true;
1133     }
1134 }
1135 
1136 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1137 
1138 pragma solidity ^0.7.0;
1139 
1140 /**
1141  * @title ERC1363
1142  * @author Vittorio Minacori (https://github.com/vittominacori)
1143  * @dev Implementation of an ERC1363 interface
1144  */
1145 contract ERC1363 is ERC20, IERC1363, ERC165 {
1146     using Address for address;
1147 
1148     /*
1149      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1150      * 0x4bbee2df ===
1151      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1152      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1153      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1154      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1155      */
1156     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
1157 
1158     /*
1159      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1160      * 0xfb9ec8ce ===
1161      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1162      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1163      */
1164     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
1165 
1166     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1167     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
1168     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
1169 
1170     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1171     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
1172     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
1173 
1174     /**
1175      * @param name Name of the token
1176      * @param symbol A symbol to be used as ticker
1177      */
1178     constructor (string memory name, string memory symbol) ERC20(name, symbol) {
1179         // register the supported interfaces to conform to ERC1363 via ERC165
1180         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
1181         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
1182     }
1183 
1184     /**
1185      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1186      * @param to The address to transfer to.
1187      * @param value The amount to be transferred.
1188      * @return A boolean that indicates if the operation was successful.
1189      */
1190     function transferAndCall(address to, uint256 value) public override returns (bool) {
1191         return transferAndCall(to, value, "");
1192     }
1193 
1194     /**
1195      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1196      * @param to The address to transfer to
1197      * @param value The amount to be transferred
1198      * @param data Additional data with no specified format
1199      * @return A boolean that indicates if the operation was successful.
1200      */
1201     function transferAndCall(address to, uint256 value, bytes memory data) public override returns (bool) {
1202         transfer(to, value);
1203         require(_checkAndCallTransfer(_msgSender(), to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1204         return true;
1205     }
1206 
1207     /**
1208      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1209      * @param from The address which you want to send tokens from
1210      * @param to The address which you want to transfer to
1211      * @param value The amount of tokens to be transferred
1212      * @return A boolean that indicates if the operation was successful.
1213      */
1214     function transferFromAndCall(address from, address to, uint256 value) public override returns (bool) {
1215         return transferFromAndCall(from, to, value, "");
1216     }
1217 
1218     /**
1219      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1220      * @param from The address which you want to send tokens from
1221      * @param to The address which you want to transfer to
1222      * @param value The amount of tokens to be transferred
1223      * @param data Additional data with no specified format
1224      * @return A boolean that indicates if the operation was successful.
1225      */
1226     function transferFromAndCall(address from, address to, uint256 value, bytes memory data) public override returns (bool) {
1227         transferFrom(from, to, value);
1228         require(_checkAndCallTransfer(from, to, value, data), "ERC1363: _checkAndCallTransfer reverts");
1229         return true;
1230     }
1231 
1232     /**
1233      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1234      * @param spender The address allowed to transfer to
1235      * @param value The amount allowed to be transferred
1236      * @return A boolean that indicates if the operation was successful.
1237      */
1238     function approveAndCall(address spender, uint256 value) public override returns (bool) {
1239         return approveAndCall(spender, value, "");
1240     }
1241 
1242     /**
1243      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1244      * @param spender The address allowed to transfer to.
1245      * @param value The amount allowed to be transferred.
1246      * @param data Additional data with no specified format.
1247      * @return A boolean that indicates if the operation was successful.
1248      */
1249     function approveAndCall(address spender, uint256 value, bytes memory data) public override returns (bool) {
1250         approve(spender, value);
1251         require(_checkAndCallApprove(spender, value, data), "ERC1363: _checkAndCallApprove reverts");
1252         return true;
1253     }
1254 
1255     /**
1256      * @dev Internal function to invoke `onTransferReceived` on a target address
1257      *  The call is not executed if the target address is not a contract
1258      * @param from address Representing the previous owner of the given token value
1259      * @param to address Target address that will receive the tokens
1260      * @param value uint256 The amount mount of tokens to be transferred
1261      * @param data bytes Optional data to send along with the call
1262      * @return whether the call correctly returned the expected magic value
1263      */
1264     function _checkAndCallTransfer(address from, address to, uint256 value, bytes memory data) internal returns (bool) {
1265         if (!to.isContract()) {
1266             return false;
1267         }
1268         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
1269             _msgSender(), from, value, data
1270         );
1271         return (retval == _ERC1363_RECEIVED);
1272     }
1273 
1274     /**
1275      * @dev Internal function to invoke `onApprovalReceived` on a target address
1276      *  The call is not executed if the target address is not a contract
1277      * @param spender address The address which will spend the funds
1278      * @param value uint256 The amount of tokens to be spent
1279      * @param data bytes Optional data to send along with the call
1280      * @return whether the call correctly returned the expected magic value
1281      */
1282     function _checkAndCallApprove(address spender, uint256 value, bytes memory data) internal returns (bool) {
1283         if (!spender.isContract()) {
1284             return false;
1285         }
1286         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1287             _msgSender(), value, data
1288         );
1289         return (retval == _ERC1363_APPROVED);
1290     }
1291 }
1292 
1293 // File: @openzeppelin/contracts/access/Ownable.sol
1294 
1295 pragma solidity ^0.7.0;
1296 
1297 /**
1298  * @dev Contract module which provides a basic access control mechanism, where
1299  * there is an account (an owner) that can be granted exclusive access to
1300  * specific functions.
1301  *
1302  * By default, the owner account will be the one that deploys the contract. This
1303  * can later be changed with {transferOwnership}.
1304  *
1305  * This module is used through inheritance. It will make available the modifier
1306  * `onlyOwner`, which can be applied to your functions to restrict their use to
1307  * the owner.
1308  */
1309 contract Ownable is Context {
1310     address private _owner;
1311 
1312     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1313 
1314     /**
1315      * @dev Initializes the contract setting the deployer as the initial owner.
1316      */
1317     constructor () {
1318         address msgSender = _msgSender();
1319         _owner = msgSender;
1320         emit OwnershipTransferred(address(0), msgSender);
1321     }
1322 
1323     /**
1324      * @dev Returns the address of the current owner.
1325      */
1326     function owner() public view returns (address) {
1327         return _owner;
1328     }
1329 
1330     /**
1331      * @dev Throws if called by any account other than the owner.
1332      */
1333     modifier onlyOwner() {
1334         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1335         _;
1336     }
1337 
1338     /**
1339      * @dev Leaves the contract without owner. It will not be possible to call
1340      * `onlyOwner` functions anymore. Can only be called by the current owner.
1341      *
1342      * NOTE: Renouncing ownership will leave the contract without an owner,
1343      * thereby removing any functionality that is only available to the owner.
1344      */
1345     function renounceOwnership() public virtual onlyOwner {
1346         emit OwnershipTransferred(_owner, address(0));
1347         _owner = address(0);
1348     }
1349 
1350     /**
1351      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1352      * Can only be called by the current owner.
1353      */
1354     function transferOwnership(address newOwner) public virtual onlyOwner {
1355         require(newOwner != address(0), "Ownable: new owner is the zero address");
1356         emit OwnershipTransferred(_owner, newOwner);
1357         _owner = newOwner;
1358     }
1359 }
1360 
1361 // File: eth-token-recover/contracts/TokenRecover.sol
1362 
1363 pragma solidity ^0.7.0;
1364 
1365 /**
1366  * @title TokenRecover
1367  * @author Vittorio Minacori (https://github.com/vittominacori)
1368  * @dev Allow to recover any ERC20 sent into the contract for error
1369  */
1370 contract TokenRecover is Ownable {
1371 
1372     /**
1373      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1374      * @param tokenAddress The token contract address
1375      * @param tokenAmount Number of tokens to be sent
1376      */
1377     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
1378         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1379     }
1380 }
1381 
1382 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
1383 
1384 pragma solidity ^0.7.0;
1385 
1386 /**
1387  * @dev Library for managing
1388  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1389  * types.
1390  *
1391  * Sets have the following properties:
1392  *
1393  * - Elements are added, removed, and checked for existence in constant time
1394  * (O(1)).
1395  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1396  *
1397  * ```
1398  * contract Example {
1399  *     // Add the library methods
1400  *     using EnumerableSet for EnumerableSet.AddressSet;
1401  *
1402  *     // Declare a set state variable
1403  *     EnumerableSet.AddressSet private mySet;
1404  * }
1405  * ```
1406  *
1407  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1408  * (`UintSet`) are supported.
1409  */
1410 library EnumerableSet {
1411     // To implement this library for multiple types with as little code
1412     // repetition as possible, we write it in terms of a generic Set type with
1413     // bytes32 values.
1414     // The Set implementation uses private functions, and user-facing
1415     // implementations (such as AddressSet) are just wrappers around the
1416     // underlying Set.
1417     // This means that we can only create new EnumerableSets for types that fit
1418     // in bytes32.
1419 
1420     struct Set {
1421         // Storage of set values
1422         bytes32[] _values;
1423 
1424         // Position of the value in the `values` array, plus 1 because index 0
1425         // means a value is not in the set.
1426         mapping (bytes32 => uint256) _indexes;
1427     }
1428 
1429     /**
1430      * @dev Add a value to a set. O(1).
1431      *
1432      * Returns true if the value was added to the set, that is if it was not
1433      * already present.
1434      */
1435     function _add(Set storage set, bytes32 value) private returns (bool) {
1436         if (!_contains(set, value)) {
1437             set._values.push(value);
1438             // The value is stored at length-1, but we add 1 to all indexes
1439             // and use 0 as a sentinel value
1440             set._indexes[value] = set._values.length;
1441             return true;
1442         } else {
1443             return false;
1444         }
1445     }
1446 
1447     /**
1448      * @dev Removes a value from a set. O(1).
1449      *
1450      * Returns true if the value was removed from the set, that is if it was
1451      * present.
1452      */
1453     function _remove(Set storage set, bytes32 value) private returns (bool) {
1454         // We read and store the value's index to prevent multiple reads from the same storage slot
1455         uint256 valueIndex = set._indexes[value];
1456 
1457         if (valueIndex != 0) { // Equivalent to contains(set, value)
1458             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1459             // the array, and then remove the last element (sometimes called as 'swap and pop').
1460             // This modifies the order of the array, as noted in {at}.
1461 
1462             uint256 toDeleteIndex = valueIndex - 1;
1463             uint256 lastIndex = set._values.length - 1;
1464 
1465             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1466             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1467 
1468             bytes32 lastvalue = set._values[lastIndex];
1469 
1470             // Move the last value to the index where the value to delete is
1471             set._values[toDeleteIndex] = lastvalue;
1472             // Update the index for the moved value
1473             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1474 
1475             // Delete the slot where the moved value was stored
1476             set._values.pop();
1477 
1478             // Delete the index for the deleted slot
1479             delete set._indexes[value];
1480 
1481             return true;
1482         } else {
1483             return false;
1484         }
1485     }
1486 
1487     /**
1488      * @dev Returns true if the value is in the set. O(1).
1489      */
1490     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1491         return set._indexes[value] != 0;
1492     }
1493 
1494     /**
1495      * @dev Returns the number of values on the set. O(1).
1496      */
1497     function _length(Set storage set) private view returns (uint256) {
1498         return set._values.length;
1499     }
1500 
1501    /**
1502     * @dev Returns the value stored at position `index` in the set. O(1).
1503     *
1504     * Note that there are no guarantees on the ordering of values inside the
1505     * array, and it may change when more values are added or removed.
1506     *
1507     * Requirements:
1508     *
1509     * - `index` must be strictly less than {length}.
1510     */
1511     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1512         require(set._values.length > index, "EnumerableSet: index out of bounds");
1513         return set._values[index];
1514     }
1515 
1516     // AddressSet
1517 
1518     struct AddressSet {
1519         Set _inner;
1520     }
1521 
1522     /**
1523      * @dev Add a value to a set. O(1).
1524      *
1525      * Returns true if the value was added to the set, that is if it was not
1526      * already present.
1527      */
1528     function add(AddressSet storage set, address value) internal returns (bool) {
1529         return _add(set._inner, bytes32(uint256(value)));
1530     }
1531 
1532     /**
1533      * @dev Removes a value from a set. O(1).
1534      *
1535      * Returns true if the value was removed from the set, that is if it was
1536      * present.
1537      */
1538     function remove(AddressSet storage set, address value) internal returns (bool) {
1539         return _remove(set._inner, bytes32(uint256(value)));
1540     }
1541 
1542     /**
1543      * @dev Returns true if the value is in the set. O(1).
1544      */
1545     function contains(AddressSet storage set, address value) internal view returns (bool) {
1546         return _contains(set._inner, bytes32(uint256(value)));
1547     }
1548 
1549     /**
1550      * @dev Returns the number of values in the set. O(1).
1551      */
1552     function length(AddressSet storage set) internal view returns (uint256) {
1553         return _length(set._inner);
1554     }
1555 
1556    /**
1557     * @dev Returns the value stored at position `index` in the set. O(1).
1558     *
1559     * Note that there are no guarantees on the ordering of values inside the
1560     * array, and it may change when more values are added or removed.
1561     *
1562     * Requirements:
1563     *
1564     * - `index` must be strictly less than {length}.
1565     */
1566     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1567         return address(uint256(_at(set._inner, index)));
1568     }
1569 
1570 
1571     // UintSet
1572 
1573     struct UintSet {
1574         Set _inner;
1575     }
1576 
1577     /**
1578      * @dev Add a value to a set. O(1).
1579      *
1580      * Returns true if the value was added to the set, that is if it was not
1581      * already present.
1582      */
1583     function add(UintSet storage set, uint256 value) internal returns (bool) {
1584         return _add(set._inner, bytes32(value));
1585     }
1586 
1587     /**
1588      * @dev Removes a value from a set. O(1).
1589      *
1590      * Returns true if the value was removed from the set, that is if it was
1591      * present.
1592      */
1593     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1594         return _remove(set._inner, bytes32(value));
1595     }
1596 
1597     /**
1598      * @dev Returns true if the value is in the set. O(1).
1599      */
1600     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1601         return _contains(set._inner, bytes32(value));
1602     }
1603 
1604     /**
1605      * @dev Returns the number of values on the set. O(1).
1606      */
1607     function length(UintSet storage set) internal view returns (uint256) {
1608         return _length(set._inner);
1609     }
1610 
1611    /**
1612     * @dev Returns the value stored at position `index` in the set. O(1).
1613     *
1614     * Note that there are no guarantees on the ordering of values inside the
1615     * array, and it may change when more values are added or removed.
1616     *
1617     * Requirements:
1618     *
1619     * - `index` must be strictly less than {length}.
1620     */
1621     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1622         return uint256(_at(set._inner, index));
1623     }
1624 }
1625 
1626 // File: @openzeppelin/contracts/access/AccessControl.sol
1627 
1628 pragma solidity ^0.7.0;
1629 
1630 /**
1631  * @dev Contract module that allows children to implement role-based access
1632  * control mechanisms.
1633  *
1634  * Roles are referred to by their `bytes32` identifier. These should be exposed
1635  * in the external API and be unique. The best way to achieve this is by
1636  * using `public constant` hash digests:
1637  *
1638  * ```
1639  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1640  * ```
1641  *
1642  * Roles can be used to represent a set of permissions. To restrict access to a
1643  * function call, use {hasRole}:
1644  *
1645  * ```
1646  * function foo() public {
1647  *     require(hasRole(MY_ROLE, msg.sender));
1648  *     ...
1649  * }
1650  * ```
1651  *
1652  * Roles can be granted and revoked dynamically via the {grantRole} and
1653  * {revokeRole} functions. Each role has an associated admin role, and only
1654  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1655  *
1656  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1657  * that only accounts with this role will be able to grant or revoke other
1658  * roles. More complex role relationships can be created by using
1659  * {_setRoleAdmin}.
1660  *
1661  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1662  * grant and revoke this role. Extra precautions should be taken to secure
1663  * accounts that have been granted it.
1664  */
1665 abstract contract AccessControl is Context {
1666     using EnumerableSet for EnumerableSet.AddressSet;
1667     using Address for address;
1668 
1669     struct RoleData {
1670         EnumerableSet.AddressSet members;
1671         bytes32 adminRole;
1672     }
1673 
1674     mapping (bytes32 => RoleData) private _roles;
1675 
1676     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1677 
1678     /**
1679      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1680      *
1681      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1682      * {RoleAdminChanged} not being emitted signaling this.
1683      *
1684      * _Available since v3.1._
1685      */
1686     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1687 
1688     /**
1689      * @dev Emitted when `account` is granted `role`.
1690      *
1691      * `sender` is the account that originated the contract call, an admin role
1692      * bearer except when using {_setupRole}.
1693      */
1694     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1695 
1696     /**
1697      * @dev Emitted when `account` is revoked `role`.
1698      *
1699      * `sender` is the account that originated the contract call:
1700      *   - if using `revokeRole`, it is the admin role bearer
1701      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1702      */
1703     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1704 
1705     /**
1706      * @dev Returns `true` if `account` has been granted `role`.
1707      */
1708     function hasRole(bytes32 role, address account) public view returns (bool) {
1709         return _roles[role].members.contains(account);
1710     }
1711 
1712     /**
1713      * @dev Returns the number of accounts that have `role`. Can be used
1714      * together with {getRoleMember} to enumerate all bearers of a role.
1715      */
1716     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1717         return _roles[role].members.length();
1718     }
1719 
1720     /**
1721      * @dev Returns one of the accounts that have `role`. `index` must be a
1722      * value between 0 and {getRoleMemberCount}, non-inclusive.
1723      *
1724      * Role bearers are not sorted in any particular way, and their ordering may
1725      * change at any point.
1726      *
1727      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1728      * you perform all queries on the same block. See the following
1729      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1730      * for more information.
1731      */
1732     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1733         return _roles[role].members.at(index);
1734     }
1735 
1736     /**
1737      * @dev Returns the admin role that controls `role`. See {grantRole} and
1738      * {revokeRole}.
1739      *
1740      * To change a role's admin, use {_setRoleAdmin}.
1741      */
1742     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1743         return _roles[role].adminRole;
1744     }
1745 
1746     /**
1747      * @dev Grants `role` to `account`.
1748      *
1749      * If `account` had not been already granted `role`, emits a {RoleGranted}
1750      * event.
1751      *
1752      * Requirements:
1753      *
1754      * - the caller must have ``role``'s admin role.
1755      */
1756     function grantRole(bytes32 role, address account) public virtual {
1757         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1758 
1759         _grantRole(role, account);
1760     }
1761 
1762     /**
1763      * @dev Revokes `role` from `account`.
1764      *
1765      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1766      *
1767      * Requirements:
1768      *
1769      * - the caller must have ``role``'s admin role.
1770      */
1771     function revokeRole(bytes32 role, address account) public virtual {
1772         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1773 
1774         _revokeRole(role, account);
1775     }
1776 
1777     /**
1778      * @dev Revokes `role` from the calling account.
1779      *
1780      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1781      * purpose is to provide a mechanism for accounts to lose their privileges
1782      * if they are compromised (such as when a trusted device is misplaced).
1783      *
1784      * If the calling account had been granted `role`, emits a {RoleRevoked}
1785      * event.
1786      *
1787      * Requirements:
1788      *
1789      * - the caller must be `account`.
1790      */
1791     function renounceRole(bytes32 role, address account) public virtual {
1792         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1793 
1794         _revokeRole(role, account);
1795     }
1796 
1797     /**
1798      * @dev Grants `role` to `account`.
1799      *
1800      * If `account` had not been already granted `role`, emits a {RoleGranted}
1801      * event. Note that unlike {grantRole}, this function doesn't perform any
1802      * checks on the calling account.
1803      *
1804      * [WARNING]
1805      * ====
1806      * This function should only be called from the constructor when setting
1807      * up the initial roles for the system.
1808      *
1809      * Using this function in any other way is effectively circumventing the admin
1810      * system imposed by {AccessControl}.
1811      * ====
1812      */
1813     function _setupRole(bytes32 role, address account) internal virtual {
1814         _grantRole(role, account);
1815     }
1816 
1817     /**
1818      * @dev Sets `adminRole` as ``role``'s admin role.
1819      *
1820      * Emits a {RoleAdminChanged} event.
1821      */
1822     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1823         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1824         _roles[role].adminRole = adminRole;
1825     }
1826 
1827     function _grantRole(bytes32 role, address account) private {
1828         if (_roles[role].members.add(account)) {
1829             emit RoleGranted(role, account, _msgSender());
1830         }
1831     }
1832 
1833     function _revokeRole(bytes32 role, address account) private {
1834         if (_roles[role].members.remove(account)) {
1835             emit RoleRevoked(role, account, _msgSender());
1836         }
1837     }
1838 }
1839 
1840 // File: @vittominacori/erc20-token/contracts/access/Roles.sol
1841 
1842 pragma solidity ^0.7.0;
1843 
1844 contract Roles is AccessControl {
1845 
1846     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
1847     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
1848 
1849     constructor () {
1850         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1851         _setupRole(MINTER_ROLE, _msgSender());
1852         _setupRole(OPERATOR_ROLE, _msgSender());
1853     }
1854 
1855     modifier onlyMinter() {
1856         require(hasRole(MINTER_ROLE, _msgSender()), "Roles: caller does not have the MINTER role");
1857         _;
1858     }
1859 
1860     modifier onlyOperator() {
1861         require(hasRole(OPERATOR_ROLE, _msgSender()), "Roles: caller does not have the OPERATOR role");
1862         _;
1863     }
1864 }
1865 
1866 // File: @vittominacori/erc20-token/contracts/ERC20Base.sol
1867 
1868 pragma solidity ^0.7.0;
1869 
1870 /**
1871  * @title ERC20Base
1872  * @author Vittorio Minacori (https://github.com/vittominacori)
1873  * @dev Implementation of the ERC20Base
1874  */
1875 contract ERC20Base is ERC20Capped, ERC20Burnable, ERC1363, Roles, TokenRecover {
1876 
1877     // indicates if minting is finished
1878     bool private _mintingFinished = false;
1879 
1880     // indicates if transfer is enabled
1881     bool private _transferEnabled = false;
1882 
1883     /**
1884      * @dev Emitted during finish minting
1885      */
1886     event MintFinished();
1887 
1888     /**
1889      * @dev Emitted during transfer enabling
1890      */
1891     event TransferEnabled();
1892 
1893     /**
1894      * @dev Tokens can be minted only before minting finished.
1895      */
1896     modifier canMint() {
1897         require(!_mintingFinished, "ERC20Base: minting is finished");
1898         _;
1899     }
1900 
1901     /**
1902      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
1903      */
1904     modifier canTransfer(address from) {
1905         require(
1906             _transferEnabled || hasRole(OPERATOR_ROLE, from),
1907             "ERC20Base: transfer is not enabled or from does not have the OPERATOR role"
1908         );
1909         _;
1910     }
1911 
1912     /**
1913      * @param name Name of the token
1914      * @param symbol A symbol to be used as ticker
1915      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
1916      * @param cap Maximum number of tokens mintable
1917      * @param initialSupply Initial token supply
1918      * @param transferEnabled If transfer is enabled on token creation
1919      * @param mintingFinished If minting is finished after token creation
1920      */
1921     constructor(
1922         string memory name,
1923         string memory symbol,
1924         uint8 decimals,
1925         uint256 cap,
1926         uint256 initialSupply,
1927         bool transferEnabled,
1928         bool mintingFinished
1929     )
1930         ERC20Capped(cap)
1931         ERC1363(name, symbol)
1932     {
1933         require(
1934             mintingFinished == false || cap == initialSupply,
1935             "ERC20Base: if finish minting, cap must be equal to initialSupply"
1936         );
1937 
1938         _setupDecimals(decimals);
1939 
1940         if (initialSupply > 0) {
1941             _mint(owner(), initialSupply);
1942         }
1943 
1944         if (mintingFinished) {
1945             finishMinting();
1946         }
1947 
1948         if (transferEnabled) {
1949             enableTransfer();
1950         }
1951     }
1952 
1953     /**
1954      * @return if minting is finished or not.
1955      */
1956     function mintingFinished() public view returns (bool) {
1957         return _mintingFinished;
1958     }
1959 
1960     /**
1961      * @return if transfer is enabled or not.
1962      */
1963     function transferEnabled() public view returns (bool) {
1964         return _transferEnabled;
1965     }
1966 
1967     /**
1968      * @dev Function to mint tokens.
1969      * @param to The address that will receive the minted tokens
1970      * @param value The amount of tokens to mint
1971      */
1972     function mint(address to, uint256 value) public canMint onlyMinter {
1973         _mint(to, value);
1974     }
1975 
1976     /**
1977      * @dev Transfer tokens to a specified address.
1978      * @param to The address to transfer to
1979      * @param value The amount to be transferred
1980      * @return A boolean that indicates if the operation was successful.
1981      */
1982     function transfer(address to, uint256 value) public virtual override(ERC20) canTransfer(_msgSender()) returns (bool) {
1983         return super.transfer(to, value);
1984     }
1985 
1986     /**
1987      * @dev Transfer tokens from one address to another.
1988      * @param from The address which you want to send tokens from
1989      * @param to The address which you want to transfer to
1990      * @param value the amount of tokens to be transferred
1991      * @return A boolean that indicates if the operation was successful.
1992      */
1993     function transferFrom(address from, address to, uint256 value) public virtual override(ERC20) canTransfer(from) returns (bool) {
1994         return super.transferFrom(from, to, value);
1995     }
1996 
1997     /**
1998      * @dev Function to stop minting new tokens.
1999      */
2000     function finishMinting() public canMint onlyOwner {
2001         _mintingFinished = true;
2002 
2003         emit MintFinished();
2004     }
2005 
2006     /**
2007      * @dev Function to enable transfers.
2008      */
2009     function enableTransfer() public onlyOwner {
2010         _transferEnabled = true;
2011 
2012         emit TransferEnabled();
2013     }
2014 
2015     /**
2016      * @dev See {ERC20-_beforeTokenTransfer}.
2017      */
2018     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override(ERC20, ERC20Capped) {
2019         super._beforeTokenTransfer(from, to, amount);
2020     }
2021 }
2022 
2023 // File: contracts/BaseToken.sol
2024 
2025 pragma solidity ^0.7.1;
2026 
2027 /**
2028  * @title BaseToken
2029  * @author Vittorio Minacori (https://github.com/vittominacori)
2030  * @dev Implementation of the BaseToken
2031  */
2032 contract BaseToken is ERC20Base {
2033 
2034   string private constant _GENERATOR = "https://vittominacori.github.io/erc20-generator";
2035   string private constant _VERSION = "v3.2.0";
2036 
2037   constructor (
2038     string memory name,
2039     string memory symbol,
2040     uint8 decimals,
2041     uint256 cap,
2042     uint256 initialSupply,
2043     bool transferEnabled,
2044     bool mintingFinished
2045   ) ERC20Base(name, symbol, decimals, cap, initialSupply, transferEnabled, mintingFinished) {}
2046 
2047   /**
2048    * @dev Returns the token generator tool.
2049    */
2050   function generator() public pure returns (string memory) {
2051     return _GENERATOR;
2052   }
2053 
2054   /**
2055    * @dev Returns the token generator version.
2056    */
2057   function version() public pure returns (string memory) {
2058     return _VERSION;
2059   }
2060 }