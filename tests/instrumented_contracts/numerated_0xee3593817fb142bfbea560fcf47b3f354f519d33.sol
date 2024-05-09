1 // Sources flattened with hardhat v2.6.8 https://hardhat.org
2 
3 // File @openzeppelin/contracts/utils/Context.sol@v3.4.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.6.0 <0.8.0;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 // File @openzeppelin/contracts/token/ERC20/IERC20.sol@v3.4.2
32 
33 
34 
35 pragma solidity >=0.6.0 <0.8.0;
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 
112 // File @openzeppelin/contracts/math/SafeMath.sol@v3.4.2
113 
114 
115 
116 pragma solidity >=0.6.0 <0.8.0;
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, with an overflow flag.
134      *
135      * _Available since v3.4._
136      */
137     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
138         uint256 c = a + b;
139         if (c < a) return (false, 0);
140         return (true, c);
141     }
142 
143     /**
144      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
145      *
146      * _Available since v3.4._
147      */
148     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
149         if (b > a) return (false, 0);
150         return (true, a - b);
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
155      *
156      * _Available since v3.4._
157      */
158     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
159         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
160         // benefit is lost if 'b' is also tested.
161         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
162         if (a == 0) return (true, 0);
163         uint256 c = a * b;
164         if (c / a != b) return (false, 0);
165         return (true, c);
166     }
167 
168     /**
169      * @dev Returns the division of two unsigned integers, with a division by zero flag.
170      *
171      * _Available since v3.4._
172      */
173     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
174         if (b == 0) return (false, 0);
175         return (true, a / b);
176     }
177 
178     /**
179      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
180      *
181      * _Available since v3.4._
182      */
183     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
184         if (b == 0) return (false, 0);
185         return (true, a % b);
186     }
187 
188     /**
189      * @dev Returns the addition of two unsigned integers, reverting on
190      * overflow.
191      *
192      * Counterpart to Solidity's `+` operator.
193      *
194      * Requirements:
195      *
196      * - Addition cannot overflow.
197      */
198     function add(uint256 a, uint256 b) internal pure returns (uint256) {
199         uint256 c = a + b;
200         require(c >= a, "SafeMath: addition overflow");
201         return c;
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, reverting on
206      * overflow (when the result is negative).
207      *
208      * Counterpart to Solidity's `-` operator.
209      *
210      * Requirements:
211      *
212      * - Subtraction cannot overflow.
213      */
214     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
215         require(b <= a, "SafeMath: subtraction overflow");
216         return a - b;
217     }
218 
219     /**
220      * @dev Returns the multiplication of two unsigned integers, reverting on
221      * overflow.
222      *
223      * Counterpart to Solidity's `*` operator.
224      *
225      * Requirements:
226      *
227      * - Multiplication cannot overflow.
228      */
229     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
230         if (a == 0) return 0;
231         uint256 c = a * b;
232         require(c / a == b, "SafeMath: multiplication overflow");
233         return c;
234     }
235 
236     /**
237      * @dev Returns the integer division of two unsigned integers, reverting on
238      * division by zero. The result is rounded towards zero.
239      *
240      * Counterpart to Solidity's `/` operator. Note: this function uses a
241      * `revert` opcode (which leaves remaining gas untouched) while Solidity
242      * uses an invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function div(uint256 a, uint256 b) internal pure returns (uint256) {
249         require(b > 0, "SafeMath: division by zero");
250         return a / b;
251     }
252 
253     /**
254      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
255      * reverting when dividing by zero.
256      *
257      * Counterpart to Solidity's `%` operator. This function uses a `revert`
258      * opcode (which leaves remaining gas untouched) while Solidity uses an
259      * invalid opcode to revert (consuming all remaining gas).
260      *
261      * Requirements:
262      *
263      * - The divisor cannot be zero.
264      */
265     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
266         require(b > 0, "SafeMath: modulo by zero");
267         return a % b;
268     }
269 
270     /**
271      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
272      * overflow (when the result is negative).
273      *
274      * CAUTION: This function is deprecated because it requires allocating memory for the error
275      * message unnecessarily. For custom revert reasons use {trySub}.
276      *
277      * Counterpart to Solidity's `-` operator.
278      *
279      * Requirements:
280      *
281      * - Subtraction cannot overflow.
282      */
283     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         require(b <= a, errorMessage);
285         return a - b;
286     }
287 
288     /**
289      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
290      * division by zero. The result is rounded towards zero.
291      *
292      * CAUTION: This function is deprecated because it requires allocating memory for the error
293      * message unnecessarily. For custom revert reasons use {tryDiv}.
294      *
295      * Counterpart to Solidity's `/` operator. Note: this function uses a
296      * `revert` opcode (which leaves remaining gas untouched) while Solidity
297      * uses an invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
304         require(b > 0, errorMessage);
305         return a / b;
306     }
307 
308     /**
309      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
310      * reverting with custom message when dividing by zero.
311      *
312      * CAUTION: This function is deprecated because it requires allocating memory for the error
313      * message unnecessarily. For custom revert reasons use {tryMod}.
314      *
315      * Counterpart to Solidity's `%` operator. This function uses a `revert`
316      * opcode (which leaves remaining gas untouched) while Solidity uses an
317      * invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      *
321      * - The divisor cannot be zero.
322      */
323     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
324         require(b > 0, errorMessage);
325         return a % b;
326     }
327 }
328 
329 
330 // File @openzeppelin/contracts/token/ERC20/ERC20.sol@v3.4.2
331 
332 
333 
334 pragma solidity >=0.6.0 <0.8.0;
335 
336 
337 
338 /**
339  * @dev Implementation of the {IERC20} interface.
340  *
341  * This implementation is agnostic to the way tokens are created. This means
342  * that a supply mechanism has to be added in a derived contract using {_mint}.
343  * For a generic mechanism see {ERC20PresetMinterPauser}.
344  *
345  * TIP: For a detailed writeup see our guide
346  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
347  * to implement supply mechanisms].
348  *
349  * We have followed general OpenZeppelin guidelines: functions revert instead
350  * of returning `false` on failure. This behavior is nonetheless conventional
351  * and does not conflict with the expectations of ERC20 applications.
352  *
353  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
354  * This allows applications to reconstruct the allowance for all accounts just
355  * by listening to said events. Other implementations of the EIP may not emit
356  * these events, as it isn't required by the specification.
357  *
358  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
359  * functions have been added to mitigate the well-known issues around setting
360  * allowances. See {IERC20-approve}.
361  */
362 contract ERC20 is Context, IERC20 {
363     using SafeMath for uint256;
364 
365     mapping (address => uint256) private _balances;
366 
367     mapping (address => mapping (address => uint256)) private _allowances;
368 
369     uint256 private _totalSupply;
370 
371     string private _name;
372     string private _symbol;
373     uint8 private _decimals;
374 
375     /**
376      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
377      * a default value of 18.
378      *
379      * To select a different value for {decimals}, use {_setupDecimals}.
380      *
381      * All three of these values are immutable: they can only be set once during
382      * construction.
383      */
384     constructor (string memory name_, string memory symbol_) public {
385         _name = name_;
386         _symbol = symbol_;
387         _decimals = 18;
388     }
389 
390     /**
391      * @dev Returns the name of the token.
392      */
393     function name() public view virtual returns (string memory) {
394         return _name;
395     }
396 
397     /**
398      * @dev Returns the symbol of the token, usually a shorter version of the
399      * name.
400      */
401     function symbol() public view virtual returns (string memory) {
402         return _symbol;
403     }
404 
405     /**
406      * @dev Returns the number of decimals used to get its user representation.
407      * For example, if `decimals` equals `2`, a balance of `505` tokens should
408      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
409      *
410      * Tokens usually opt for a value of 18, imitating the relationship between
411      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
412      * called.
413      *
414      * NOTE: This information is only used for _display_ purposes: it in
415      * no way affects any of the arithmetic of the contract, including
416      * {IERC20-balanceOf} and {IERC20-transfer}.
417      */
418     function decimals() public view virtual returns (uint8) {
419         return _decimals;
420     }
421 
422     /**
423      * @dev See {IERC20-totalSupply}.
424      */
425     function totalSupply() public view virtual override returns (uint256) {
426         return _totalSupply;
427     }
428 
429     /**
430      * @dev See {IERC20-balanceOf}.
431      */
432     function balanceOf(address account) public view virtual override returns (uint256) {
433         return _balances[account];
434     }
435 
436     /**
437      * @dev See {IERC20-transfer}.
438      *
439      * Requirements:
440      *
441      * - `recipient` cannot be the zero address.
442      * - the caller must have a balance of at least `amount`.
443      */
444     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
445         _transfer(_msgSender(), recipient, amount);
446         return true;
447     }
448 
449     /**
450      * @dev See {IERC20-allowance}.
451      */
452     function allowance(address owner, address spender) public view virtual override returns (uint256) {
453         return _allowances[owner][spender];
454     }
455 
456     /**
457      * @dev See {IERC20-approve}.
458      *
459      * Requirements:
460      *
461      * - `spender` cannot be the zero address.
462      */
463     function approve(address spender, uint256 amount) public virtual override returns (bool) {
464         _approve(_msgSender(), spender, amount);
465         return true;
466     }
467 
468     /**
469      * @dev See {IERC20-transferFrom}.
470      *
471      * Emits an {Approval} event indicating the updated allowance. This is not
472      * required by the EIP. See the note at the beginning of {ERC20}.
473      *
474      * Requirements:
475      *
476      * - `sender` and `recipient` cannot be the zero address.
477      * - `sender` must have a balance of at least `amount`.
478      * - the caller must have allowance for ``sender``'s tokens of at least
479      * `amount`.
480      */
481     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
482         _transfer(sender, recipient, amount);
483         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
484         return true;
485     }
486 
487     /**
488      * @dev Atomically increases the allowance granted to `spender` by the caller.
489      *
490      * This is an alternative to {approve} that can be used as a mitigation for
491      * problems described in {IERC20-approve}.
492      *
493      * Emits an {Approval} event indicating the updated allowance.
494      *
495      * Requirements:
496      *
497      * - `spender` cannot be the zero address.
498      */
499     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
500         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
501         return true;
502     }
503 
504     /**
505      * @dev Atomically decreases the allowance granted to `spender` by the caller.
506      *
507      * This is an alternative to {approve} that can be used as a mitigation for
508      * problems described in {IERC20-approve}.
509      *
510      * Emits an {Approval} event indicating the updated allowance.
511      *
512      * Requirements:
513      *
514      * - `spender` cannot be the zero address.
515      * - `spender` must have allowance for the caller of at least
516      * `subtractedValue`.
517      */
518     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
519         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
520         return true;
521     }
522 
523     /**
524      * @dev Moves tokens `amount` from `sender` to `recipient`.
525      *
526      * This is internal function is equivalent to {transfer}, and can be used to
527      * e.g. implement automatic token fees, slashing mechanisms, etc.
528      *
529      * Emits a {Transfer} event.
530      *
531      * Requirements:
532      *
533      * - `sender` cannot be the zero address.
534      * - `recipient` cannot be the zero address.
535      * - `sender` must have a balance of at least `amount`.
536      */
537     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
538         require(sender != address(0), "ERC20: transfer from the zero address");
539         require(recipient != address(0), "ERC20: transfer to the zero address");
540 
541         _beforeTokenTransfer(sender, recipient, amount);
542 
543         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
544         _balances[recipient] = _balances[recipient].add(amount);
545         emit Transfer(sender, recipient, amount);
546     }
547 
548     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
549      * the total supply.
550      *
551      * Emits a {Transfer} event with `from` set to the zero address.
552      *
553      * Requirements:
554      *
555      * - `to` cannot be the zero address.
556      */
557     function _mint(address account, uint256 amount) internal virtual {
558         require(account != address(0), "ERC20: mint to the zero address");
559 
560         _beforeTokenTransfer(address(0), account, amount);
561 
562         _totalSupply = _totalSupply.add(amount);
563         _balances[account] = _balances[account].add(amount);
564         emit Transfer(address(0), account, amount);
565     }
566 
567     /**
568      * @dev Destroys `amount` tokens from `account`, reducing the
569      * total supply.
570      *
571      * Emits a {Transfer} event with `to` set to the zero address.
572      *
573      * Requirements:
574      *
575      * - `account` cannot be the zero address.
576      * - `account` must have at least `amount` tokens.
577      */
578     function _burn(address account, uint256 amount) internal virtual {
579         require(account != address(0), "ERC20: burn from the zero address");
580 
581         _beforeTokenTransfer(account, address(0), amount);
582 
583         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
584         _totalSupply = _totalSupply.sub(amount);
585         emit Transfer(account, address(0), amount);
586     }
587 
588     /**
589      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
590      *
591      * This internal function is equivalent to `approve`, and can be used to
592      * e.g. set automatic allowances for certain subsystems, etc.
593      *
594      * Emits an {Approval} event.
595      *
596      * Requirements:
597      *
598      * - `owner` cannot be the zero address.
599      * - `spender` cannot be the zero address.
600      */
601     function _approve(address owner, address spender, uint256 amount) internal virtual {
602         require(owner != address(0), "ERC20: approve from the zero address");
603         require(spender != address(0), "ERC20: approve to the zero address");
604 
605         _allowances[owner][spender] = amount;
606         emit Approval(owner, spender, amount);
607     }
608 
609     /**
610      * @dev Sets {decimals} to a value other than the default one of 18.
611      *
612      * WARNING: This function should only be called from the constructor. Most
613      * applications that interact with token contracts will not expect
614      * {decimals} to ever change, and may work incorrectly if it does.
615      */
616     function _setupDecimals(uint8 decimals_) internal virtual {
617         _decimals = decimals_;
618     }
619 
620     /**
621      * @dev Hook that is called before any transfer of tokens. This includes
622      * minting and burning.
623      *
624      * Calling conditions:
625      *
626      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
627      * will be to transferred to `to`.
628      * - when `from` is zero, `amount` tokens will be minted for `to`.
629      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
630      * - `from` and `to` are never both zero.
631      *
632      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
633      */
634     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
635 }
636 
637 
638 // File @openzeppelin/contracts/utils/Address.sol@v3.4.2
639 
640 
641 
642 pragma solidity >=0.6.2 <0.8.0;
643 
644 /**
645  * @dev Collection of functions related to the address type
646  */
647 library Address {
648     /**
649      * @dev Returns true if `account` is a contract.
650      *
651      * [IMPORTANT]
652      * ====
653      * It is unsafe to assume that an address for which this function returns
654      * false is an externally-owned account (EOA) and not a contract.
655      *
656      * Among others, `isContract` will return false for the following
657      * types of addresses:
658      *
659      *  - an externally-owned account
660      *  - a contract in construction
661      *  - an address where a contract will be created
662      *  - an address where a contract lived, but was destroyed
663      * ====
664      */
665     function isContract(address account) internal view returns (bool) {
666         // This method relies on extcodesize, which returns 0 for contracts in
667         // construction, since the code is only stored at the end of the
668         // constructor execution.
669 
670         uint256 size;
671         // solhint-disable-next-line no-inline-assembly
672         assembly { size := extcodesize(account) }
673         return size > 0;
674     }
675 
676     /**
677      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
678      * `recipient`, forwarding all available gas and reverting on errors.
679      *
680      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
681      * of certain opcodes, possibly making contracts go over the 2300 gas limit
682      * imposed by `transfer`, making them unable to receive funds via
683      * `transfer`. {sendValue} removes this limitation.
684      *
685      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
686      *
687      * IMPORTANT: because control is transferred to `recipient`, care must be
688      * taken to not create reentrancy vulnerabilities. Consider using
689      * {ReentrancyGuard} or the
690      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
691      */
692     function sendValue(address payable recipient, uint256 amount) internal {
693         require(address(this).balance >= amount, "Address: insufficient balance");
694 
695         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
696         (bool success, ) = recipient.call{ value: amount }("");
697         require(success, "Address: unable to send value, recipient may have reverted");
698     }
699 
700     /**
701      * @dev Performs a Solidity function call using a low level `call`. A
702      * plain`call` is an unsafe replacement for a function call: use this
703      * function instead.
704      *
705      * If `target` reverts with a revert reason, it is bubbled up by this
706      * function (like regular Solidity function calls).
707      *
708      * Returns the raw returned data. To convert to the expected return value,
709      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
710      *
711      * Requirements:
712      *
713      * - `target` must be a contract.
714      * - calling `target` with `data` must not revert.
715      *
716      * _Available since v3.1._
717      */
718     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
719       return functionCall(target, data, "Address: low-level call failed");
720     }
721 
722     /**
723      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
724      * `errorMessage` as a fallback revert reason when `target` reverts.
725      *
726      * _Available since v3.1._
727      */
728     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
729         return functionCallWithValue(target, data, 0, errorMessage);
730     }
731 
732     /**
733      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
734      * but also transferring `value` wei to `target`.
735      *
736      * Requirements:
737      *
738      * - the calling contract must have an ETH balance of at least `value`.
739      * - the called Solidity function must be `payable`.
740      *
741      * _Available since v3.1._
742      */
743     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
744         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
745     }
746 
747     /**
748      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
749      * with `errorMessage` as a fallback revert reason when `target` reverts.
750      *
751      * _Available since v3.1._
752      */
753     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
754         require(address(this).balance >= value, "Address: insufficient balance for call");
755         require(isContract(target), "Address: call to non-contract");
756 
757         // solhint-disable-next-line avoid-low-level-calls
758         (bool success, bytes memory returndata) = target.call{ value: value }(data);
759         return _verifyCallResult(success, returndata, errorMessage);
760     }
761 
762     /**
763      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
764      * but performing a static call.
765      *
766      * _Available since v3.3._
767      */
768     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
769         return functionStaticCall(target, data, "Address: low-level static call failed");
770     }
771 
772     /**
773      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
774      * but performing a static call.
775      *
776      * _Available since v3.3._
777      */
778     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
779         require(isContract(target), "Address: static call to non-contract");
780 
781         // solhint-disable-next-line avoid-low-level-calls
782         (bool success, bytes memory returndata) = target.staticcall(data);
783         return _verifyCallResult(success, returndata, errorMessage);
784     }
785 
786     /**
787      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
788      * but performing a delegate call.
789      *
790      * _Available since v3.4._
791      */
792     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
793         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
794     }
795 
796     /**
797      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
798      * but performing a delegate call.
799      *
800      * _Available since v3.4._
801      */
802     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
803         require(isContract(target), "Address: delegate call to non-contract");
804 
805         // solhint-disable-next-line avoid-low-level-calls
806         (bool success, bytes memory returndata) = target.delegatecall(data);
807         return _verifyCallResult(success, returndata, errorMessage);
808     }
809 
810     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
811         if (success) {
812             return returndata;
813         } else {
814             // Look for revert reason and bubble it up if present
815             if (returndata.length > 0) {
816                 // The easiest way to bubble the revert reason is using memory via assembly
817 
818                 // solhint-disable-next-line no-inline-assembly
819                 assembly {
820                     let returndata_size := mload(returndata)
821                     revert(add(32, returndata), returndata_size)
822                 }
823             } else {
824                 revert(errorMessage);
825             }
826         }
827     }
828 }
829 
830 
831 // File @openzeppelin/contracts/utils/Pausable.sol@v3.4.2
832 
833 
834 
835 pragma solidity >=0.6.0 <0.8.0;
836 
837 /**
838  * @dev Contract module which allows children to implement an emergency stop
839  * mechanism that can be triggered by an authorized account.
840  *
841  * This module is used through inheritance. It will make available the
842  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
843  * the functions of your contract. Note that they will not be pausable by
844  * simply including this module, only once the modifiers are put in place.
845  */
846 abstract contract Pausable is Context {
847     /**
848      * @dev Emitted when the pause is triggered by `account`.
849      */
850     event Paused(address account);
851 
852     /**
853      * @dev Emitted when the pause is lifted by `account`.
854      */
855     event Unpaused(address account);
856 
857     bool private _paused;
858 
859     /**
860      * @dev Initializes the contract in unpaused state.
861      */
862     constructor () internal {
863         _paused = false;
864     }
865 
866     /**
867      * @dev Returns true if the contract is paused, and false otherwise.
868      */
869     function paused() public view virtual returns (bool) {
870         return _paused;
871     }
872 
873     /**
874      * @dev Modifier to make a function callable only when the contract is not paused.
875      *
876      * Requirements:
877      *
878      * - The contract must not be paused.
879      */
880     modifier whenNotPaused() {
881         require(!paused(), "Pausable: paused");
882         _;
883     }
884 
885     /**
886      * @dev Modifier to make a function callable only when the contract is paused.
887      *
888      * Requirements:
889      *
890      * - The contract must be paused.
891      */
892     modifier whenPaused() {
893         require(paused(), "Pausable: not paused");
894         _;
895     }
896 
897     /**
898      * @dev Triggers stopped state.
899      *
900      * Requirements:
901      *
902      * - The contract must not be paused.
903      */
904     function _pause() internal virtual whenNotPaused {
905         _paused = true;
906         emit Paused(_msgSender());
907     }
908 
909     /**
910      * @dev Returns to normal state.
911      *
912      * Requirements:
913      *
914      * - The contract must be paused.
915      */
916     function _unpause() internal virtual whenPaused {
917         _paused = false;
918         emit Unpaused(_msgSender());
919     }
920 }
921 
922 
923 // File @openzeppelin/contracts/utils/ReentrancyGuard.sol@v3.4.2
924 
925 
926 
927 pragma solidity >=0.6.0 <0.8.0;
928 
929 /**
930  * @dev Contract module that helps prevent reentrant calls to a function.
931  *
932  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
933  * available, which can be applied to functions to make sure there are no nested
934  * (reentrant) calls to them.
935  *
936  * Note that because there is a single `nonReentrant` guard, functions marked as
937  * `nonReentrant` may not call one another. This can be worked around by making
938  * those functions `private`, and then adding `external` `nonReentrant` entry
939  * points to them.
940  *
941  * TIP: If you would like to learn more about reentrancy and alternative ways
942  * to protect against it, check out our blog post
943  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
944  */
945 abstract contract ReentrancyGuard {
946     // Booleans are more expensive than uint256 or any type that takes up a full
947     // word because each write operation emits an extra SLOAD to first read the
948     // slot's contents, replace the bits taken up by the boolean, and then write
949     // back. This is the compiler's defense against contract upgrades and
950     // pointer aliasing, and it cannot be disabled.
951 
952     // The values being non-zero value makes deployment a bit more expensive,
953     // but in exchange the refund on every call to nonReentrant will be lower in
954     // amount. Since refunds are capped to a percentage of the total
955     // transaction's gas, it is best to keep them low in cases like this one, to
956     // increase the likelihood of the full refund coming into effect.
957     uint256 private constant _NOT_ENTERED = 1;
958     uint256 private constant _ENTERED = 2;
959 
960     uint256 private _status;
961 
962     constructor () internal {
963         _status = _NOT_ENTERED;
964     }
965 
966     /**
967      * @dev Prevents a contract from calling itself, directly or indirectly.
968      * Calling a `nonReentrant` function from another `nonReentrant`
969      * function is not supported. It is possible to prevent this from happening
970      * by making the `nonReentrant` function external, and make it call a
971      * `private` function that does the actual work.
972      */
973     modifier nonReentrant() {
974         // On the first call to nonReentrant, _notEntered will be true
975         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
976 
977         // Any calls to nonReentrant after this point will fail
978         _status = _ENTERED;
979 
980         _;
981 
982         // By storing the original value once again, a refund is triggered (see
983         // https://eips.ethereum.org/EIPS/eip-2200)
984         _status = _NOT_ENTERED;
985     }
986 }
987 
988 
989 // File @openzeppelin/contracts/access/Ownable.sol@v3.4.2
990 
991 
992 
993 pragma solidity >=0.6.0 <0.8.0;
994 
995 /**
996  * @dev Contract module which provides a basic access control mechanism, where
997  * there is an account (an owner) that can be granted exclusive access to
998  * specific functions.
999  *
1000  * By default, the owner account will be the one that deploys the contract. This
1001  * can later be changed with {transferOwnership}.
1002  *
1003  * This module is used through inheritance. It will make available the modifier
1004  * `onlyOwner`, which can be applied to your functions to restrict their use to
1005  * the owner.
1006  */
1007 abstract contract Ownable is Context {
1008     address private _owner;
1009 
1010     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1011 
1012     /**
1013      * @dev Initializes the contract setting the deployer as the initial owner.
1014      */
1015     constructor () internal {
1016         address msgSender = _msgSender();
1017         _owner = msgSender;
1018         emit OwnershipTransferred(address(0), msgSender);
1019     }
1020 
1021     /**
1022      * @dev Returns the address of the current owner.
1023      */
1024     function owner() public view virtual returns (address) {
1025         return _owner;
1026     }
1027 
1028     /**
1029      * @dev Throws if called by any account other than the owner.
1030      */
1031     modifier onlyOwner() {
1032         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1033         _;
1034     }
1035 
1036     /**
1037      * @dev Leaves the contract without owner. It will not be possible to call
1038      * `onlyOwner` functions anymore. Can only be called by the current owner.
1039      *
1040      * NOTE: Renouncing ownership will leave the contract without an owner,
1041      * thereby removing any functionality that is only available to the owner.
1042      */
1043     function renounceOwnership() public virtual onlyOwner {
1044         emit OwnershipTransferred(_owner, address(0));
1045         _owner = address(0);
1046     }
1047 
1048     /**
1049      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1050      * Can only be called by the current owner.
1051      */
1052     function transferOwnership(address newOwner) public virtual onlyOwner {
1053         require(newOwner != address(0), "Ownable: new owner is the zero address");
1054         emit OwnershipTransferred(_owner, newOwner);
1055         _owner = newOwner;
1056     }
1057 }
1058 
1059 
1060 // File src/utils/AccessProtected.sol
1061 
1062 
1063 pragma solidity 0.7.6;
1064 
1065 
1066 abstract contract AccessProtected is Context, Ownable {
1067     mapping(address => bool) private _admins; // user address => admin? mapping
1068 
1069     event AdminAccessSet(address _admin, bool _enabled);
1070 
1071     /**
1072      * @notice Set Admin Access
1073      *
1074      * @param admin - Address of Minter
1075      * @param enabled - Enable/Disable Admin Access
1076      */
1077     function setAdmin(address admin, bool enabled) external onlyOwner {
1078         require(admin != address(0), "Admin address can not be zero");
1079         _admins[admin] = enabled;
1080         emit AdminAccessSet(admin, enabled);
1081     }
1082 
1083     /**
1084      * @notice Check Admin Access
1085      *
1086      * @param admin - Address of Admin
1087      * @return whether minter has access
1088      */
1089     function isAdmin(address admin) public view returns (bool) {
1090         return _admins[admin];
1091     }
1092 
1093     /**
1094      * Throws if called by any account other than the Admin.
1095      */
1096     modifier onlyAdmin() {
1097         require(
1098             _admins[_msgSender()] || _msgSender() == owner(),
1099             "Caller does not have Admin Access"
1100         );
1101         _;
1102     }
1103 }
1104 
1105 
1106 // File src/vesting/BicoVesting.sol
1107 
1108 
1109 pragma solidity 0.7.6;
1110 pragma abicoder v2;
1111 
1112 
1113 
1114 
1115 
1116 
1117 contract BicoVesting is AccessProtected, Pausable, ReentrancyGuard {
1118     using SafeMath for uint256;
1119     using Address for address;
1120     address public tokenAddress;
1121 
1122     struct Claim {
1123         bool isActive;
1124         uint256 vestAmount;
1125         uint256 unlockAmount;
1126         uint256 unlockTime;
1127         uint256 startTime;
1128         uint256 endTime;
1129         uint256 amountClaimed;
1130     }
1131 
1132     mapping(address => Claim) private claims;
1133 
1134     event ClaimCreated(
1135         address _creator,
1136         address _beneficiary,
1137         uint256 _vestAmount,
1138         uint256 _unlockAmount,
1139         uint256 _unlockTime,
1140         uint256 _startTime,
1141         uint256 _endTime
1142     );
1143     event Claimed(address _beneficiary, uint256 _amount);
1144     event Revoked(address _beneficiary);
1145 
1146     constructor(address _tokenAddress) {
1147         require(_tokenAddress != address(0),"Token address can not be zero");
1148         tokenAddress = _tokenAddress;
1149     }
1150 
1151     function createClaim(
1152         address _beneficiary,
1153         uint256 _vestAmount,
1154         uint256 _unlockAmount,
1155         uint256 _unlockTime,
1156         uint64 _startTime,
1157         uint64 _endTime
1158     ) public onlyAdmin {
1159         require(!claims[_beneficiary].isActive, "CLAIM_ACTIVE");
1160         require(_endTime > _startTime, "INVALID_TIME");
1161         require(_endTime != 0, "INVALID_TIME");
1162         require(_startTime > _unlockTime, "INVALID_TIME");
1163         require(_beneficiary != address(0), "INVALID_ADDRESS");
1164         require(_vestAmount > 0, "INVALID_AMOUNT");
1165         require(
1166             ERC20(tokenAddress).allowance(msg.sender, address(this)) >=
1167                 (_vestAmount.add(_unlockAmount)),
1168             "INVALID_ALLOWANCE"
1169         );
1170         ERC20(tokenAddress).transferFrom(
1171             msg.sender,
1172             address(this),
1173             _vestAmount.add(_unlockAmount)
1174         );
1175         Claim memory newClaim = Claim({
1176             isActive: true,
1177             vestAmount: _vestAmount,
1178             unlockAmount: _unlockAmount,
1179             unlockTime: _unlockTime,
1180             startTime: _startTime,
1181             endTime: _endTime,
1182             amountClaimed: 0
1183         });
1184         claims[_beneficiary] = newClaim;
1185         emit ClaimCreated(
1186             msg.sender,
1187             _beneficiary,
1188             _vestAmount,
1189             _unlockAmount,
1190             _unlockTime,
1191             _startTime,
1192             _endTime
1193         );
1194     }
1195 
1196     function createBatchClaim(
1197         address[] memory _beneficiaries,
1198         uint256[] memory _vestAmounts,
1199         uint256[] memory _unlockAmounts,
1200         uint256[] memory _unlockTimes,
1201         uint64[] memory _startTimes,
1202         uint64[] memory _endTimes
1203     ) external onlyAdmin {
1204         uint256 length = _beneficiaries.length;
1205         require(
1206             _vestAmounts.length == length &&
1207                 _unlockAmounts.length == length &&
1208                 _unlockTimes.length == length &&
1209                 _startTimes.length == length &&
1210                 _endTimes.length == length,
1211             "LENGTH_MISMATCH"
1212         );
1213         for (uint256 i; i < length; i++) {
1214             createClaim(
1215                 _beneficiaries[i],
1216                 _vestAmounts[i],
1217                 _unlockAmounts[i],
1218                 _unlockTimes[i],
1219                 _startTimes[i],
1220                 _endTimes[i]
1221             );
1222         }
1223     }
1224 
1225     function getClaim(address beneficiary)
1226         external
1227         view
1228         returns (Claim memory)
1229     {
1230         require(beneficiary != address(0), "INVALID_ADDRESS");
1231         return (claims[beneficiary]);
1232     }
1233 
1234     function claimableAmount(address beneficiary)
1235         public
1236         view
1237         returns (uint256)
1238     {
1239         Claim memory _claim = claims[beneficiary];
1240         if (
1241             block.timestamp < _claim.startTime &&
1242             block.timestamp < _claim.unlockTime
1243         ) return 0;
1244         if (_claim.amountClaimed == _claim.vestAmount) return 0;
1245         uint256 currentTimestamp = block.timestamp > _claim.endTime
1246             ? _claim.endTime
1247             : block.timestamp;
1248         uint256 claimPercent;
1249         uint256 claimAmount;
1250         uint256 unclaimedAmount;
1251         if (
1252             _claim.unlockTime <= block.timestamp &&
1253             _claim.startTime <= block.timestamp
1254         ) {
1255             claimPercent = currentTimestamp.sub(_claim.startTime).mul(1e18).div(
1256                     _claim.endTime.sub(_claim.startTime)
1257                 );
1258             claimAmount = _claim.vestAmount.mul(claimPercent).div(1e18).add(
1259                 _claim.unlockAmount
1260             );
1261             unclaimedAmount = claimAmount.sub(_claim.amountClaimed);
1262         } else if (
1263             _claim.unlockTime > block.timestamp &&
1264             _claim.startTime <= block.timestamp
1265         ) {
1266             claimPercent = currentTimestamp.sub(_claim.startTime).mul(1e18).div(
1267                     _claim.endTime.sub(_claim.startTime)
1268                 );
1269             claimAmount = _claim.vestAmount.mul(claimPercent).div(1e18);
1270             unclaimedAmount = claimAmount.sub(_claim.amountClaimed);
1271         } else {
1272             claimAmount = _claim.unlockAmount;
1273             unclaimedAmount = claimAmount.sub(_claim.amountClaimed);
1274         }
1275         return unclaimedAmount;
1276     }
1277 
1278     function claim() external whenNotPaused nonReentrant {
1279         address beneficiary = msg.sender;
1280         Claim memory _claim = claims[beneficiary];
1281         require(_claim.isActive, "CLAIM_INACTIVE");
1282         uint256 unclaimedAmount = claimableAmount(beneficiary);
1283         ERC20(tokenAddress).transfer(beneficiary, unclaimedAmount);
1284         _claim.amountClaimed = _claim.amountClaimed.add(unclaimedAmount);
1285         if (_claim.amountClaimed == _claim.vestAmount) _claim.isActive = false;
1286         claims[beneficiary] = _claim;
1287         emit Claimed(beneficiary, unclaimedAmount);
1288     }
1289 
1290     function revoke(address beneficiary) external onlyAdmin {
1291         require(claims[beneficiary].isActive != false, "Already invalidated");
1292         claims[beneficiary].isActive = false;
1293         emit Revoked(beneficiary);
1294     }
1295 
1296     function withdrawTokens(address wallet, uint256 amount) external onlyOwner nonReentrant {
1297         require(amount > 0, "Nothing to withdraw");
1298         ERC20(tokenAddress).transfer(wallet, amount);
1299     }
1300 
1301     function pause() external onlyAdmin {
1302         _pause();
1303     }
1304 
1305     function unpause() external onlyAdmin {
1306         _unpause();
1307     }
1308 }