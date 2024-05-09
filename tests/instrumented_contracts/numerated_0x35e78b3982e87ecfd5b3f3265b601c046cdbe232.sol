1 // File: https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/GSN/Context.sol
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
27 
28 // File: https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/token/ERC20/IERC20.sol
29 
30 
31 pragma solidity ^0.6.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 
108 
109 // File: https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/token/ERC20/ERC20.sol
110 
111 
112 pragma solidity ^0.6.0;
113 
114 
115 
116 
117 
118 /**
119  * @dev Implementation of the {IERC20} interface.
120  *
121  * This implementation is agnostic to the way tokens are created. This means
122  * that a supply mechanism has to be added in a derived contract using {_mint}.
123  * For a generic mechanism see {ERC20PresetMinterPauser}.
124  *
125  * TIP: For a detailed writeup see our guide
126  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
127  * to implement supply mechanisms].
128  *
129  * We have followed general OpenZeppelin guidelines: functions revert instead
130  * of returning `false` on failure. This behavior is nonetheless conventional
131  * and does not conflict with the expectations of ERC20 applications.
132  *
133  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
134  * This allows applications to reconstruct the allowance for all accounts just
135  * by listening to said events. Other implementations of the EIP may not emit
136  * these events, as it isn't required by the specification.
137  *
138  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
139  * functions have been added to mitigate the well-known issues around setting
140  * allowances. See {IERC20-approve}.
141  */
142 contract ERC20 is Context, IERC20 {
143     using SafeMath for uint256;
144     using Address for address;
145 
146     mapping (address => uint256) private _balances;
147 
148     mapping (address => mapping (address => uint256)) private _allowances;
149 
150     uint256 private _totalSupply;
151 
152     string private _name;
153     string private _symbol;
154     uint8 private _decimals;
155 
156     /**
157      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
158      * a default value of 18.
159      *
160      * To select a different value for {decimals}, use {_setupDecimals}.
161      *
162      * All three of these values are immutable: they can only be set once during
163      * construction.
164      */
165     constructor (string memory name, string memory symbol) public {
166         _name = name;
167         _symbol = symbol;
168         _decimals = 18;
169     }
170 
171     /**
172      * @dev Returns the name of the token.
173      */
174     function name() public view returns (string memory) {
175         return _name;
176     }
177 
178     /**
179      * @dev Returns the symbol of the token, usually a shorter version of the
180      * name.
181      */
182     function symbol() public view returns (string memory) {
183         return _symbol;
184     }
185 
186     /**
187      * @dev Returns the number of decimals used to get its user representation.
188      * For example, if `decimals` equals `2`, a balance of `505` tokens should
189      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
190      *
191      * Tokens usually opt for a value of 18, imitating the relationship between
192      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
193      * called.
194      *
195      * NOTE: This information is only used for _display_ purposes: it in
196      * no way affects any of the arithmetic of the contract, including
197      * {IERC20-balanceOf} and {IERC20-transfer}.
198      */
199     function decimals() public view returns (uint8) {
200         return _decimals;
201     }
202 
203     /**
204      * @dev See {IERC20-totalSupply}.
205      */
206     function totalSupply() public view override returns (uint256) {
207         return _totalSupply;
208     }
209 
210     /**
211      * @dev See {IERC20-balanceOf}.
212      */
213     function balanceOf(address account) public view override returns (uint256) {
214         return _balances[account];
215     }
216 
217     /**
218      * @dev See {IERC20-transfer}.
219      *
220      * Requirements:
221      *
222      * - `recipient` cannot be the zero address.
223      * - the caller must have a balance of at least `amount`.
224      */
225     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
226         _transfer(_msgSender(), recipient, amount);
227         return true;
228     }
229 
230     /**
231      * @dev See {IERC20-allowance}.
232      */
233     function allowance(address owner, address spender) public view virtual override returns (uint256) {
234         return _allowances[owner][spender];
235     }
236 
237     /**
238      * @dev See {IERC20-approve}.
239      *
240      * Requirements:
241      *
242      * - `spender` cannot be the zero address.
243      */
244     function approve(address spender, uint256 amount) public virtual override returns (bool) {
245         _approve(_msgSender(), spender, amount);
246         return true;
247     }
248 
249     /**
250      * @dev See {IERC20-transferFrom}.
251      *
252      * Emits an {Approval} event indicating the updated allowance. This is not
253      * required by the EIP. See the note at the beginning of {ERC20};
254      *
255      * Requirements:
256      * - `sender` and `recipient` cannot be the zero address.
257      * - `sender` must have a balance of at least `amount`.
258      * - the caller must have allowance for ``sender``'s tokens of at least
259      * `amount`.
260      */
261     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
262         _transfer(sender, recipient, amount);
263         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
264         return true;
265     }
266 
267     /**
268      * @dev Atomically increases the allowance granted to `spender` by the caller.
269      *
270      * This is an alternative to {approve} that can be used as a mitigation for
271      * problems described in {IERC20-approve}.
272      *
273      * Emits an {Approval} event indicating the updated allowance.
274      *
275      * Requirements:
276      *
277      * - `spender` cannot be the zero address.
278      */
279     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
280         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
281         return true;
282     }
283 
284     /**
285      * @dev Atomically decreases the allowance granted to `spender` by the caller.
286      *
287      * This is an alternative to {approve} that can be used as a mitigation for
288      * problems described in {IERC20-approve}.
289      *
290      * Emits an {Approval} event indicating the updated allowance.
291      *
292      * Requirements:
293      *
294      * - `spender` cannot be the zero address.
295      * - `spender` must have allowance for the caller of at least
296      * `subtractedValue`.
297      */
298     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
299         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
300         return true;
301     }
302 
303     /**
304      * @dev Moves tokens `amount` from `sender` to `recipient`.
305      *
306      * This is internal function is equivalent to {transfer}, and can be used to
307      * e.g. implement automatic token fees, slashing mechanisms, etc.
308      *
309      * Emits a {Transfer} event.
310      *
311      * Requirements:
312      *
313      * - `sender` cannot be the zero address.
314      * - `recipient` cannot be the zero address.
315      * - `sender` must have a balance of at least `amount`.
316      */
317     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
318         require(sender != address(0), "ERC20: transfer from the zero address");
319         require(recipient != address(0), "ERC20: transfer to the zero address");
320 
321         _beforeTokenTransfer(sender, recipient, amount);
322 
323         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
324         _balances[recipient] = _balances[recipient].add(amount);
325         emit Transfer(sender, recipient, amount);
326     }
327 
328     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
329      * the total supply.
330      *
331      * Emits a {Transfer} event with `from` set to the zero address.
332      *
333      * Requirements
334      *
335      * - `to` cannot be the zero address.
336      */
337     function _mint(address account, uint256 amount) internal virtual {
338         require(account != address(0), "ERC20: mint to the zero address");
339 
340         _beforeTokenTransfer(address(0), account, amount);
341 
342         _totalSupply = _totalSupply.add(amount);
343         _balances[account] = _balances[account].add(amount);
344         emit Transfer(address(0), account, amount);
345     }
346 
347     /**
348      * @dev Destroys `amount` tokens from `account`, reducing the
349      * total supply.
350      *
351      * Emits a {Transfer} event with `to` set to the zero address.
352      *
353      * Requirements
354      *
355      * - `account` cannot be the zero address.
356      * - `account` must have at least `amount` tokens.
357      */
358     function _burn(address account, uint256 amount) internal virtual {
359         require(account != address(0), "ERC20: burn from the zero address");
360 
361         _beforeTokenTransfer(account, address(0), amount);
362 
363         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
364         _totalSupply = _totalSupply.sub(amount);
365         emit Transfer(account, address(0), amount);
366     }
367 
368     /**
369      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
370      *
371      * This internal function is equivalent to `approve`, and can be used to
372      * e.g. set automatic allowances for certain subsystems, etc.
373      *
374      * Emits an {Approval} event.
375      *
376      * Requirements:
377      *
378      * - `owner` cannot be the zero address.
379      * - `spender` cannot be the zero address.
380      */
381     function _approve(address owner, address spender, uint256 amount) internal virtual {
382         require(owner != address(0), "ERC20: approve from the zero address");
383         require(spender != address(0), "ERC20: approve to the zero address");
384 
385         _allowances[owner][spender] = amount;
386         emit Approval(owner, spender, amount);
387     }
388 
389     /**
390      * @dev Sets {decimals} to a value other than the default one of 18.
391      *
392      * WARNING: This function should only be called from the constructor. Most
393      * applications that interact with token contracts will not expect
394      * {decimals} to ever change, and may work incorrectly if it does.
395      */
396     function _setupDecimals(uint8 decimals_) internal {
397         _decimals = decimals_;
398     }
399 
400     /**
401      * @dev Hook that is called before any transfer of tokens. This includes
402      * minting and burning.
403      *
404      * Calling conditions:
405      *
406      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
407      * will be to transferred to `to`.
408      * - when `from` is zero, `amount` tokens will be minted for `to`.
409      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
410      * - `from` and `to` are never both zero.
411      *
412      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
413      */
414     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
415 }
416 
417 
418 
419 // File: https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/token/ERC20/ERC20Burnable.sol
420 
421 
422 pragma solidity ^0.6.0;
423 
424 
425 
426 /**
427  * @dev Extension of {ERC20} that allows token holders to destroy both their own
428  * tokens and those that they have an allowance for, in a way that can be
429  * recognized off-chain (via event analysis).
430  */
431 abstract contract ERC20Burnable is Context, ERC20 {
432     /**
433      * @dev Destroys `amount` tokens from the caller.
434      *
435      * See {ERC20-_burn}.
436      */
437     function burn(uint256 amount) public virtual {
438         _burn(_msgSender(), amount);
439     }
440 
441     /**
442      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
443      * allowance.
444      *
445      * See {ERC20-_burn} and {ERC20-allowance}.
446      *
447      * Requirements:
448      *
449      * - the caller must have allowance for ``accounts``'s tokens of at least
450      * `amount`.
451      */
452     function burnFrom(address account, uint256 amount) public virtual {
453         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
454 
455         _approve(account, _msgSender(), decreasedAllowance);
456         _burn(account, amount);
457     }
458 }
459 
460 // File: https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/utils/Address.sol
461 
462 
463 pragma solidity ^0.6.2;
464 
465 /**
466  * @dev Collection of functions related to the address type
467  */
468 library Address {
469     /**
470      * @dev Returns true if `account` is a contract.
471      *
472      * [IMPORTANT]
473      * ====
474      * It is unsafe to assume that an address for which this function returns
475      * false is an externally-owned account (EOA) and not a contract.
476      *
477      * Among others, `isContract` will return false for the following
478      * types of addresses:
479      *
480      *  - an externally-owned account
481      *  - a contract in construction
482      *  - an address where a contract will be created
483      *  - an address where a contract lived, but was destroyed
484      * ====
485      */
486     function isContract(address account) internal view returns (bool) {
487         // This method relies on extcodesize, which returns 0 for contracts in
488         // construction, since the code is only stored at the end of the
489         // constructor execution.
490 
491         uint256 size;
492         // solhint-disable-next-line no-inline-assembly
493         assembly { size := extcodesize(account) }
494         return size > 0;
495     }
496 
497     /**
498      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
499      * `recipient`, forwarding all available gas and reverting on errors.
500      *
501      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
502      * of certain opcodes, possibly making contracts go over the 2300 gas limit
503      * imposed by `transfer`, making them unable to receive funds via
504      * `transfer`. {sendValue} removes this limitation.
505      *
506      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
507      *
508      * IMPORTANT: because control is transferred to `recipient`, care must be
509      * taken to not create reentrancy vulnerabilities. Consider using
510      * {ReentrancyGuard} or the
511      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
512      */
513     function sendValue(address payable recipient, uint256 amount) internal {
514         require(address(this).balance >= amount, "Address: insufficient balance");
515 
516         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
517         (bool success, ) = recipient.call{ value: amount }("");
518         require(success, "Address: unable to send value, recipient may have reverted");
519     }
520 
521     /**
522      * @dev Performs a Solidity function call using a low level `call`. A
523      * plain`call` is an unsafe replacement for a function call: use this
524      * function instead.
525      *
526      * If `target` reverts with a revert reason, it is bubbled up by this
527      * function (like regular Solidity function calls).
528      *
529      * Returns the raw returned data. To convert to the expected return value,
530      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
531      *
532      * Requirements:
533      *
534      * - `target` must be a contract.
535      * - calling `target` with `data` must not revert.
536      *
537      * _Available since v3.1._
538      */
539     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
540       return functionCall(target, data, "Address: low-level call failed");
541     }
542 
543     /**
544      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
545      * `errorMessage` as a fallback revert reason when `target` reverts.
546      *
547      * _Available since v3.1._
548      */
549     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
550         return _functionCallWithValue(target, data, 0, errorMessage);
551     }
552 
553     /**
554      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
555      * but also transferring `value` wei to `target`.
556      *
557      * Requirements:
558      *
559      * - the calling contract must have an ETH balance of at least `value`.
560      * - the called Solidity function must be `payable`.
561      *
562      * _Available since v3.1._
563      */
564     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
565         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
566     }
567 
568     /**
569      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
570      * with `errorMessage` as a fallback revert reason when `target` reverts.
571      *
572      * _Available since v3.1._
573      */
574     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
575         require(address(this).balance >= value, "Address: insufficient balance for call");
576         return _functionCallWithValue(target, data, value, errorMessage);
577     }
578 
579     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
580         require(isContract(target), "Address: call to non-contract");
581 
582         // solhint-disable-next-line avoid-low-level-calls
583         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
584         if (success) {
585             return returndata;
586         } else {
587             // Look for revert reason and bubble it up if present
588             if (returndata.length > 0) {
589                 // The easiest way to bubble the revert reason is using memory via assembly
590 
591                 // solhint-disable-next-line no-inline-assembly
592                 assembly {
593                     let returndata_size := mload(returndata)
594                     revert(add(32, returndata), returndata_size)
595                 }
596             } else {
597                 revert(errorMessage);
598             }
599         }
600     }
601 }
602 
603 // File: https://raw.githubusercontent.com/OpenZeppelin/openzeppelin-contracts/master/contracts/math/SafeMath.sol
604 
605 
606 pragma solidity ^0.6.0;
607 
608 /**
609  * @dev Wrappers over Solidity's arithmetic operations with added overflow
610  * checks.
611  *
612  * Arithmetic operations in Solidity wrap on overflow. This can easily result
613  * in bugs, because programmers usually assume that an overflow raises an
614  * error, which is the standard behavior in high level programming languages.
615  * `SafeMath` restores this intuition by reverting the transaction when an
616  * operation overflows.
617  *
618  * Using this library instead of the unchecked operations eliminates an entire
619  * class of bugs, so it's recommended to use it always.
620  */
621 library SafeMath {
622     /**
623      * @dev Returns the addition of two unsigned integers, reverting on
624      * overflow.
625      *
626      * Counterpart to Solidity's `+` operator.
627      *
628      * Requirements:
629      *
630      * - Addition cannot overflow.
631      */
632     function add(uint256 a, uint256 b) internal pure returns (uint256) {
633         uint256 c = a + b;
634         require(c >= a, "SafeMath: addition overflow");
635 
636         return c;
637     }
638 
639     /**
640      * @dev Returns the subtraction of two unsigned integers, reverting on
641      * overflow (when the result is negative).
642      *
643      * Counterpart to Solidity's `-` operator.
644      *
645      * Requirements:
646      *
647      * - Subtraction cannot overflow.
648      */
649     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
650         return sub(a, b, "SafeMath: subtraction overflow");
651     }
652 
653     /**
654      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
655      * overflow (when the result is negative).
656      *
657      * Counterpart to Solidity's `-` operator.
658      *
659      * Requirements:
660      *
661      * - Subtraction cannot overflow.
662      */
663     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
664         require(b <= a, errorMessage);
665         uint256 c = a - b;
666 
667         return c;
668     }
669 
670     /**
671      * @dev Returns the multiplication of two unsigned integers, reverting on
672      * overflow.
673      *
674      * Counterpart to Solidity's `*` operator.
675      *
676      * Requirements:
677      *
678      * - Multiplication cannot overflow.
679      */
680     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
681         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
682         // benefit is lost if 'b' is also tested.
683         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
684         if (a == 0) {
685             return 0;
686         }
687 
688         uint256 c = a * b;
689         require(c / a == b, "SafeMath: multiplication overflow");
690 
691         return c;
692     }
693 
694     /**
695      * @dev Returns the integer division of two unsigned integers. Reverts on
696      * division by zero. The result is rounded towards zero.
697      *
698      * Counterpart to Solidity's `/` operator. Note: this function uses a
699      * `revert` opcode (which leaves remaining gas untouched) while Solidity
700      * uses an invalid opcode to revert (consuming all remaining gas).
701      *
702      * Requirements:
703      *
704      * - The divisor cannot be zero.
705      */
706     function div(uint256 a, uint256 b) internal pure returns (uint256) {
707         return div(a, b, "SafeMath: division by zero");
708     }
709 
710     /**
711      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
712      * division by zero. The result is rounded towards zero.
713      *
714      * Counterpart to Solidity's `/` operator. Note: this function uses a
715      * `revert` opcode (which leaves remaining gas untouched) while Solidity
716      * uses an invalid opcode to revert (consuming all remaining gas).
717      *
718      * Requirements:
719      *
720      * - The divisor cannot be zero.
721      */
722     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
723         require(b > 0, errorMessage);
724         uint256 c = a / b;
725         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
726 
727         return c;
728     }
729 
730     /**
731      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
732      * Reverts when dividing by zero.
733      *
734      * Counterpart to Solidity's `%` operator. This function uses a `revert`
735      * opcode (which leaves remaining gas untouched) while Solidity uses an
736      * invalid opcode to revert (consuming all remaining gas).
737      *
738      * Requirements:
739      *
740      * - The divisor cannot be zero.
741      */
742     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
743         return mod(a, b, "SafeMath: modulo by zero");
744     }
745 
746     /**
747      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
748      * Reverts with custom message when dividing by zero.
749      *
750      * Counterpart to Solidity's `%` operator. This function uses a `revert`
751      * opcode (which leaves remaining gas untouched) while Solidity uses an
752      * invalid opcode to revert (consuming all remaining gas).
753      *
754      * Requirements:
755      *
756      * - The divisor cannot be zero.
757      */
758     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
759         require(b != 0, errorMessage);
760         return a % b;
761     }
762 }
763 
764 
765 // File: browser/XAI.sol
766 
767 pragma solidity ^0.6.0;
768 
769 // import '@openzeppelin/contracts/token/ERC20/ERC20.sol';
770 
771 
772 
773 contract XAI is ERC20, ERC20Burnable {
774     constructor() public ERC20('SideShift Token', 'XAI') {
775         _mint(msg.sender, 210_000_000 * 10**18);
776     }
777 }