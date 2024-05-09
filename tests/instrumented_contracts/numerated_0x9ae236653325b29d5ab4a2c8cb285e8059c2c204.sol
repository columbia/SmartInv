1 /*
2 https://powerpool.finance/
3 
4           wrrrw r wrr
5          ppwr rrr wppr0       prwwwrp                                 prwwwrp                   wr0
6         rr 0rrrwrrprpwp0      pp   pr  prrrr0 pp   0r  prrrr0  0rwrrr pp   pr  prrrr0  prrrr0    r0
7         rrp pr   wr00rrp      prwww0  pp   wr pp w00r prwwwpr  0rw    prwww0  pp   wr pp   wr    r0
8         r0rprprwrrrp pr0      pp      wr   pr pp rwwr wr       0r     pp      wr   pr wr   pr    r0
9          prwr wrr0wpwr        00        www0   0w0ww    www0   0w     00        www0    www0   0www0
10           wrr ww0rrrr
11 
12 */
13 
14 // SPDX-License-Identifier: MIT
15 
16 pragma solidity >=0.6.0 <0.8.0;
17 
18 /**
19  * @dev Interface of the ERC20 standard as defined in the EIP.
20  */
21 interface IERC20 {
22     /**
23      * @dev Returns the amount of tokens in existence.
24      */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28      * @dev Returns the amount of tokens owned by `account`.
29      */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33      * @dev Moves `amount` tokens from the caller's account to `recipient`.
34      *
35      * Returns a boolean value indicating whether the operation succeeded.
36      *
37      * Emits a {Transfer} event.
38      */
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     /**
42      * @dev Returns the remaining number of tokens that `spender` will be
43      * allowed to spend on behalf of `owner` through {transferFrom}. This is
44      * zero by default.
45      *
46      * This value changes when {approve} or {transferFrom} are called.
47      */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * IMPORTANT: Beware that changing an allowance with this method brings the risk
56      * that someone may use both the old and the new allowance by unfortunate
57      * transaction ordering. One possible solution to mitigate this race
58      * condition is to first reduce the spender's allowance to 0 and set the
59      * desired value afterwards:
60      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61      *
62      * Emits an {Approval} event.
63      */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Moves `amount` tokens from `sender` to `recipient` using the
68      * allowance mechanism. `amount` is then deducted from the caller's
69      * allowance.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Emitted when `value` tokens are moved from one account (`from`) to
79      * another (`to`).
80      *
81      * Note that `value` may be zero.
82      */
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     /**
86      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87      * a call to {approve}. `value` is the new allowance.
88      */
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 // File: @openzeppelin/contracts/utils/Context.sol
93 
94 pragma solidity >=0.6.0 <0.8.0;
95 
96 /*
97  * @dev Provides information about the current execution context, including the
98  * sender of the transaction and its data. While these are generally available
99  * via msg.sender and msg.data, they should not be accessed in such a direct
100  * manner, since when dealing with GSN meta-transactions the account sending and
101  * paying for execution may not be the actual sender (as far as an application
102  * is concerned).
103  *
104  * This contract is only required for intermediate, library-like contracts.
105  */
106 abstract contract Context {
107     function _msgSender() internal view virtual returns (address payable) {
108         return msg.sender;
109     }
110 
111     function _msgData() internal view virtual returns (bytes memory) {
112         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
113         return msg.data;
114     }
115 }
116 
117 // File: @openzeppelin/contracts/math/SafeMath.sol
118 
119 pragma solidity >=0.6.0 <0.8.0;
120 
121 /**
122  * @dev Wrappers over Solidity's arithmetic operations with added overflow
123  * checks.
124  *
125  * Arithmetic operations in Solidity wrap on overflow. This can easily result
126  * in bugs, because programmers usually assume that an overflow raises an
127  * error, which is the standard behavior in high level programming languages.
128  * `SafeMath` restores this intuition by reverting the transaction when an
129  * operation overflows.
130  *
131  * Using this library instead of the unchecked operations eliminates an entire
132  * class of bugs, so it's recommended to use it always.
133  */
134 library SafeMath {
135     /**
136      * @dev Returns the addition of two unsigned integers, with an overflow flag.
137      *
138      * _Available since v3.4._
139      */
140     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
141         uint256 c = a + b;
142         if (c < a) return (false, 0);
143         return (true, c);
144     }
145 
146     /**
147      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
148      *
149      * _Available since v3.4._
150      */
151     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
152         if (b > a) return (false, 0);
153         return (true, a - b);
154     }
155 
156     /**
157      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
158      *
159      * _Available since v3.4._
160      */
161     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
162         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
163         // benefit is lost if 'b' is also tested.
164         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
165         if (a == 0) return (true, 0);
166         uint256 c = a * b;
167         if (c / a != b) return (false, 0);
168         return (true, c);
169     }
170 
171     /**
172      * @dev Returns the division of two unsigned integers, with a division by zero flag.
173      *
174      * _Available since v3.4._
175      */
176     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
177         if (b == 0) return (false, 0);
178         return (true, a / b);
179     }
180 
181     /**
182      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
183      *
184      * _Available since v3.4._
185      */
186     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
187         if (b == 0) return (false, 0);
188         return (true, a % b);
189     }
190 
191     /**
192      * @dev Returns the addition of two unsigned integers, reverting on
193      * overflow.
194      *
195      * Counterpart to Solidity's `+` operator.
196      *
197      * Requirements:
198      *
199      * - Addition cannot overflow.
200      */
201     function add(uint256 a, uint256 b) internal pure returns (uint256) {
202         uint256 c = a + b;
203         require(c >= a, "SafeMath: addition overflow");
204         return c;
205     }
206 
207     /**
208      * @dev Returns the subtraction of two unsigned integers, reverting on
209      * overflow (when the result is negative).
210      *
211      * Counterpart to Solidity's `-` operator.
212      *
213      * Requirements:
214      *
215      * - Subtraction cannot overflow.
216      */
217     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
218         require(b <= a, "SafeMath: subtraction overflow");
219         return a - b;
220     }
221 
222     /**
223      * @dev Returns the multiplication of two unsigned integers, reverting on
224      * overflow.
225      *
226      * Counterpart to Solidity's `*` operator.
227      *
228      * Requirements:
229      *
230      * - Multiplication cannot overflow.
231      */
232     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
233         if (a == 0) return 0;
234         uint256 c = a * b;
235         require(c / a == b, "SafeMath: multiplication overflow");
236         return c;
237     }
238 
239     /**
240      * @dev Returns the integer division of two unsigned integers, reverting on
241      * division by zero. The result is rounded towards zero.
242      *
243      * Counterpart to Solidity's `/` operator. Note: this function uses a
244      * `revert` opcode (which leaves remaining gas untouched) while Solidity
245      * uses an invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function div(uint256 a, uint256 b) internal pure returns (uint256) {
252         require(b > 0, "SafeMath: division by zero");
253         return a / b;
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * reverting when dividing by zero.
259      *
260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
261      * opcode (which leaves remaining gas untouched) while Solidity uses an
262      * invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
269         require(b > 0, "SafeMath: modulo by zero");
270         return a % b;
271     }
272 
273     /**
274      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
275      * overflow (when the result is negative).
276      *
277      * CAUTION: This function is deprecated because it requires allocating memory for the error
278      * message unnecessarily. For custom revert reasons use {trySub}.
279      *
280      * Counterpart to Solidity's `-` operator.
281      *
282      * Requirements:
283      *
284      * - Subtraction cannot overflow.
285      */
286     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
287         require(b <= a, errorMessage);
288         return a - b;
289     }
290 
291     /**
292      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
293      * division by zero. The result is rounded towards zero.
294      *
295      * CAUTION: This function is deprecated because it requires allocating memory for the error
296      * message unnecessarily. For custom revert reasons use {tryDiv}.
297      *
298      * Counterpart to Solidity's `/` operator. Note: this function uses a
299      * `revert` opcode (which leaves remaining gas untouched) while Solidity
300      * uses an invalid opcode to revert (consuming all remaining gas).
301      *
302      * Requirements:
303      *
304      * - The divisor cannot be zero.
305      */
306     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
307         require(b > 0, errorMessage);
308         return a / b;
309     }
310 
311     /**
312      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
313      * reverting with custom message when dividing by zero.
314      *
315      * CAUTION: This function is deprecated because it requires allocating memory for the error
316      * message unnecessarily. For custom revert reasons use {tryMod}.
317      *
318      * Counterpart to Solidity's `%` operator. This function uses a `revert`
319      * opcode (which leaves remaining gas untouched) while Solidity uses an
320      * invalid opcode to revert (consuming all remaining gas).
321      *
322      * Requirements:
323      *
324      * - The divisor cannot be zero.
325      */
326     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
327         require(b > 0, errorMessage);
328         return a % b;
329     }
330 }
331 
332 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
333 
334 pragma solidity >=0.6.0 <0.8.0;
335 
336 /**
337  * @dev Implementation of the {IERC20} interface.
338  *
339  * This implementation is agnostic to the way tokens are created. This means
340  * that a supply mechanism has to be added in a derived contract using {_mint}.
341  * For a generic mechanism see {ERC20PresetMinterPauser}.
342  *
343  * TIP: For a detailed writeup see our guide
344  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
345  * to implement supply mechanisms].
346  *
347  * We have followed general OpenZeppelin guidelines: functions revert instead
348  * of returning `false` on failure. This behavior is nonetheless conventional
349  * and does not conflict with the expectations of ERC20 applications.
350  *
351  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
352  * This allows applications to reconstruct the allowance for all accounts just
353  * by listening to said events. Other implementations of the EIP may not emit
354  * these events, as it isn't required by the specification.
355  *
356  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
357  * functions have been added to mitigate the well-known issues around setting
358  * allowances. See {IERC20-approve}.
359  */
360 contract ERC20 is Context, IERC20 {
361     using SafeMath for uint256;
362 
363     mapping (address => uint256) private _balances;
364 
365     mapping (address => mapping (address => uint256)) private _allowances;
366 
367     uint256 private _totalSupply;
368 
369     string private _name;
370     string private _symbol;
371     uint8 private _decimals;
372 
373     /**
374      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
375      * a default value of 18.
376      *
377      * To select a different value for {decimals}, use {_setupDecimals}.
378      *
379      * All three of these values are immutable: they can only be set once during
380      * construction.
381      */
382     constructor (string memory name_, string memory symbol_) public {
383         _name = name_;
384         _symbol = symbol_;
385         _decimals = 18;
386     }
387 
388     /**
389      * @dev Returns the name of the token.
390      */
391     function name() public view virtual returns (string memory) {
392         return _name;
393     }
394 
395     /**
396      * @dev Returns the symbol of the token, usually a shorter version of the
397      * name.
398      */
399     function symbol() public view virtual returns (string memory) {
400         return _symbol;
401     }
402 
403     /**
404      * @dev Returns the number of decimals used to get its user representation.
405      * For example, if `decimals` equals `2`, a balance of `505` tokens should
406      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
407      *
408      * Tokens usually opt for a value of 18, imitating the relationship between
409      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
410      * called.
411      *
412      * NOTE: This information is only used for _display_ purposes: it in
413      * no way affects any of the arithmetic of the contract, including
414      * {IERC20-balanceOf} and {IERC20-transfer}.
415      */
416     function decimals() public view virtual returns (uint8) {
417         return _decimals;
418     }
419 
420     /**
421      * @dev See {IERC20-totalSupply}.
422      */
423     function totalSupply() public view virtual override returns (uint256) {
424         return _totalSupply;
425     }
426 
427     /**
428      * @dev See {IERC20-balanceOf}.
429      */
430     function balanceOf(address account) public view virtual override returns (uint256) {
431         return _balances[account];
432     }
433 
434     /**
435      * @dev See {IERC20-transfer}.
436      *
437      * Requirements:
438      *
439      * - `recipient` cannot be the zero address.
440      * - the caller must have a balance of at least `amount`.
441      */
442     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
443         _transfer(_msgSender(), recipient, amount);
444         return true;
445     }
446 
447     /**
448      * @dev See {IERC20-allowance}.
449      */
450     function allowance(address owner, address spender) public view virtual override returns (uint256) {
451         return _allowances[owner][spender];
452     }
453 
454     /**
455      * @dev See {IERC20-approve}.
456      *
457      * Requirements:
458      *
459      * - `spender` cannot be the zero address.
460      */
461     function approve(address spender, uint256 amount) public virtual override returns (bool) {
462         _approve(_msgSender(), spender, amount);
463         return true;
464     }
465 
466     /**
467      * @dev See {IERC20-transferFrom}.
468      *
469      * Emits an {Approval} event indicating the updated allowance. This is not
470      * required by the EIP. See the note at the beginning of {ERC20}.
471      *
472      * Requirements:
473      *
474      * - `sender` and `recipient` cannot be the zero address.
475      * - `sender` must have a balance of at least `amount`.
476      * - the caller must have allowance for ``sender``'s tokens of at least
477      * `amount`.
478      */
479     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
480         _transfer(sender, recipient, amount);
481         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
482         return true;
483     }
484 
485     /**
486      * @dev Atomically increases the allowance granted to `spender` by the caller.
487      *
488      * This is an alternative to {approve} that can be used as a mitigation for
489      * problems described in {IERC20-approve}.
490      *
491      * Emits an {Approval} event indicating the updated allowance.
492      *
493      * Requirements:
494      *
495      * - `spender` cannot be the zero address.
496      */
497     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
498         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
499         return true;
500     }
501 
502     /**
503      * @dev Atomically decreases the allowance granted to `spender` by the caller.
504      *
505      * This is an alternative to {approve} that can be used as a mitigation for
506      * problems described in {IERC20-approve}.
507      *
508      * Emits an {Approval} event indicating the updated allowance.
509      *
510      * Requirements:
511      *
512      * - `spender` cannot be the zero address.
513      * - `spender` must have allowance for the caller of at least
514      * `subtractedValue`.
515      */
516     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
517         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
518         return true;
519     }
520 
521     /**
522      * @dev Moves tokens `amount` from `sender` to `recipient`.
523      *
524      * This is internal function is equivalent to {transfer}, and can be used to
525      * e.g. implement automatic token fees, slashing mechanisms, etc.
526      *
527      * Emits a {Transfer} event.
528      *
529      * Requirements:
530      *
531      * - `sender` cannot be the zero address.
532      * - `recipient` cannot be the zero address.
533      * - `sender` must have a balance of at least `amount`.
534      */
535     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
536         require(sender != address(0), "ERC20: transfer from the zero address");
537         require(recipient != address(0), "ERC20: transfer to the zero address");
538 
539         _beforeTokenTransfer(sender, recipient, amount);
540 
541         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
542         _balances[recipient] = _balances[recipient].add(amount);
543         emit Transfer(sender, recipient, amount);
544     }
545 
546     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
547      * the total supply.
548      *
549      * Emits a {Transfer} event with `from` set to the zero address.
550      *
551      * Requirements:
552      *
553      * - `to` cannot be the zero address.
554      */
555     function _mint(address account, uint256 amount) internal virtual {
556         require(account != address(0), "ERC20: mint to the zero address");
557 
558         _beforeTokenTransfer(address(0), account, amount);
559 
560         _totalSupply = _totalSupply.add(amount);
561         _balances[account] = _balances[account].add(amount);
562         emit Transfer(address(0), account, amount);
563     }
564 
565     /**
566      * @dev Destroys `amount` tokens from `account`, reducing the
567      * total supply.
568      *
569      * Emits a {Transfer} event with `to` set to the zero address.
570      *
571      * Requirements:
572      *
573      * - `account` cannot be the zero address.
574      * - `account` must have at least `amount` tokens.
575      */
576     function _burn(address account, uint256 amount) internal virtual {
577         require(account != address(0), "ERC20: burn from the zero address");
578 
579         _beforeTokenTransfer(account, address(0), amount);
580 
581         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
582         _totalSupply = _totalSupply.sub(amount);
583         emit Transfer(account, address(0), amount);
584     }
585 
586     /**
587      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
588      *
589      * This internal function is equivalent to `approve`, and can be used to
590      * e.g. set automatic allowances for certain subsystems, etc.
591      *
592      * Emits an {Approval} event.
593      *
594      * Requirements:
595      *
596      * - `owner` cannot be the zero address.
597      * - `spender` cannot be the zero address.
598      */
599     function _approve(address owner, address spender, uint256 amount) internal virtual {
600         require(owner != address(0), "ERC20: approve from the zero address");
601         require(spender != address(0), "ERC20: approve to the zero address");
602 
603         _allowances[owner][spender] = amount;
604         emit Approval(owner, spender, amount);
605     }
606 
607     /**
608      * @dev Sets {decimals} to a value other than the default one of 18.
609      *
610      * WARNING: This function should only be called from the constructor. Most
611      * applications that interact with token contracts will not expect
612      * {decimals} to ever change, and may work incorrectly if it does.
613      */
614     function _setupDecimals(uint8 decimals_) internal virtual {
615         _decimals = decimals_;
616     }
617 
618     /**
619      * @dev Hook that is called before any transfer of tokens. This includes
620      * minting and burning.
621      *
622      * Calling conditions:
623      *
624      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
625      * will be to transferred to `to`.
626      * - when `from` is zero, `amount` tokens will be minted for `to`.
627      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
628      * - `from` and `to` are never both zero.
629      *
630      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
631      */
632     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
633 }
634 
635 // File: @openzeppelin/contracts/utils/Address.sol
636 
637 pragma solidity >=0.6.2 <0.8.0;
638 
639 /**
640  * @dev Collection of functions related to the address type
641  */
642 library Address {
643     /**
644      * @dev Returns true if `account` is a contract.
645      *
646      * [IMPORTANT]
647      * ====
648      * It is unsafe to assume that an address for which this function returns
649      * false is an externally-owned account (EOA) and not a contract.
650      *
651      * Among others, `isContract` will return false for the following
652      * types of addresses:
653      *
654      *  - an externally-owned account
655      *  - a contract in construction
656      *  - an address where a contract will be created
657      *  - an address where a contract lived, but was destroyed
658      * ====
659      */
660     function isContract(address account) internal view returns (bool) {
661         // This method relies on extcodesize, which returns 0 for contracts in
662         // construction, since the code is only stored at the end of the
663         // constructor execution.
664 
665         uint256 size;
666         // solhint-disable-next-line no-inline-assembly
667         assembly { size := extcodesize(account) }
668         return size > 0;
669     }
670 
671     /**
672      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
673      * `recipient`, forwarding all available gas and reverting on errors.
674      *
675      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
676      * of certain opcodes, possibly making contracts go over the 2300 gas limit
677      * imposed by `transfer`, making them unable to receive funds via
678      * `transfer`. {sendValue} removes this limitation.
679      *
680      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
681      *
682      * IMPORTANT: because control is transferred to `recipient`, care must be
683      * taken to not create reentrancy vulnerabilities. Consider using
684      * {ReentrancyGuard} or the
685      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
686      */
687     function sendValue(address payable recipient, uint256 amount) internal {
688         require(address(this).balance >= amount, "Address: insufficient balance");
689 
690         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
691         (bool success, ) = recipient.call{ value: amount }("");
692         require(success, "Address: unable to send value, recipient may have reverted");
693     }
694 
695     /**
696      * @dev Performs a Solidity function call using a low level `call`. A
697      * plain`call` is an unsafe replacement for a function call: use this
698      * function instead.
699      *
700      * If `target` reverts with a revert reason, it is bubbled up by this
701      * function (like regular Solidity function calls).
702      *
703      * Returns the raw returned data. To convert to the expected return value,
704      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
705      *
706      * Requirements:
707      *
708      * - `target` must be a contract.
709      * - calling `target` with `data` must not revert.
710      *
711      * _Available since v3.1._
712      */
713     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
714       return functionCall(target, data, "Address: low-level call failed");
715     }
716 
717     /**
718      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
719      * `errorMessage` as a fallback revert reason when `target` reverts.
720      *
721      * _Available since v3.1._
722      */
723     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
724         return functionCallWithValue(target, data, 0, errorMessage);
725     }
726 
727     /**
728      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
729      * but also transferring `value` wei to `target`.
730      *
731      * Requirements:
732      *
733      * - the calling contract must have an ETH balance of at least `value`.
734      * - the called Solidity function must be `payable`.
735      *
736      * _Available since v3.1._
737      */
738     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
739         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
744      * with `errorMessage` as a fallback revert reason when `target` reverts.
745      *
746      * _Available since v3.1._
747      */
748     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
749         require(address(this).balance >= value, "Address: insufficient balance for call");
750         require(isContract(target), "Address: call to non-contract");
751 
752         // solhint-disable-next-line avoid-low-level-calls
753         (bool success, bytes memory returndata) = target.call{ value: value }(data);
754         return _verifyCallResult(success, returndata, errorMessage);
755     }
756 
757     /**
758      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
759      * but performing a static call.
760      *
761      * _Available since v3.3._
762      */
763     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
764         return functionStaticCall(target, data, "Address: low-level static call failed");
765     }
766 
767     /**
768      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
769      * but performing a static call.
770      *
771      * _Available since v3.3._
772      */
773     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
774         require(isContract(target), "Address: static call to non-contract");
775 
776         // solhint-disable-next-line avoid-low-level-calls
777         (bool success, bytes memory returndata) = target.staticcall(data);
778         return _verifyCallResult(success, returndata, errorMessage);
779     }
780 
781     /**
782      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
783      * but performing a delegate call.
784      *
785      * _Available since v3.4._
786      */
787     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
788         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
789     }
790 
791     /**
792      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
793      * but performing a delegate call.
794      *
795      * _Available since v3.4._
796      */
797     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
798         require(isContract(target), "Address: delegate call to non-contract");
799 
800         // solhint-disable-next-line avoid-low-level-calls
801         (bool success, bytes memory returndata) = target.delegatecall(data);
802         return _verifyCallResult(success, returndata, errorMessage);
803     }
804 
805     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
806         if (success) {
807             return returndata;
808         } else {
809             // Look for revert reason and bubble it up if present
810             if (returndata.length > 0) {
811                 // The easiest way to bubble the revert reason is using memory via assembly
812 
813                 // solhint-disable-next-line no-inline-assembly
814                 assembly {
815                     let returndata_size := mload(returndata)
816                     revert(add(32, returndata), returndata_size)
817                 }
818             } else {
819                 revert(errorMessage);
820             }
821         }
822     }
823 }
824 
825 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
826 
827 pragma solidity >=0.6.0 <0.8.0;
828 
829 /**
830  * @title SafeERC20
831  * @dev Wrappers around ERC20 operations that throw on failure (when the token
832  * contract returns false). Tokens that return no value (and instead revert or
833  * throw on failure) are also supported, non-reverting calls are assumed to be
834  * successful.
835  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
836  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
837  */
838 library SafeERC20 {
839     using SafeMath for uint256;
840     using Address for address;
841 
842     function safeTransfer(IERC20 token, address to, uint256 value) internal {
843         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
844     }
845 
846     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
847         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
848     }
849 
850     /**
851      * @dev Deprecated. This function has issues similar to the ones found in
852      * {IERC20-approve}, and its usage is discouraged.
853      *
854      * Whenever possible, use {safeIncreaseAllowance} and
855      * {safeDecreaseAllowance} instead.
856      */
857     function safeApprove(IERC20 token, address spender, uint256 value) internal {
858         // safeApprove should only be called when setting an initial allowance,
859         // or when resetting it to zero. To increase and decrease it, use
860         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
861         // solhint-disable-next-line max-line-length
862         require((value == 0) || (token.allowance(address(this), spender) == 0),
863             "SafeERC20: approve from non-zero to non-zero allowance"
864         );
865         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
866     }
867 
868     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
869         uint256 newAllowance = token.allowance(address(this), spender).add(value);
870         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
871     }
872 
873     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
874         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
875         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
876     }
877 
878     /**
879      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
880      * on the return value: the return value is optional (but if data is returned, it must not be false).
881      * @param token The token targeted by the call.
882      * @param data The call data (encoded using abi.encode or one of its variants).
883      */
884     function _callOptionalReturn(IERC20 token, bytes memory data) private {
885         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
886         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
887         // the target address contains contract code and also asserts for success in the low-level call.
888 
889         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
890         if (returndata.length > 0) { // Return data is optional
891             // solhint-disable-next-line max-line-length
892             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
893         }
894     }
895 }
896 
897 // File: contracts/pvp/xCVP.sol
898 
899 pragma solidity 0.6.12;
900 
901 contract xCVP is ERC20("", "") {
902   using SafeMath for uint256;
903   using SafeERC20 for IERC20;
904   IERC20 public immutable cvp;
905 
906   constructor(IERC20 cvp_) public {
907     cvp = cvp_;
908   }
909 
910   /**
911    * @notice Deposits CVP token to receive xCVP
912    * @param _amount CVP amount to deposit
913    * @return shareMinted The minted xCVP amount
914    */
915   function enter(uint256 _amount) external returns (uint256 shareMinted) {
916     uint256 totalCVP = cvp.balanceOf(address(this));
917     uint256 totalShares = totalSupply();
918     if (totalShares == 0 || totalCVP == 0) {
919       shareMinted = _amount;
920     } else {
921       shareMinted = _amount.mul(totalShares).div(totalCVP);
922     }
923     _mint(msg.sender, shareMinted);
924     cvp.safeTransferFrom(msg.sender, address(this), _amount);
925   }
926 
927   /**
928    * @notice Burn xCVP token to withdraw CVP
929    * @param _share xCVP amount to burn
930    * @return cvpSent The sent CVP amount
931    */
932   function leave(uint256 _share) external returns (uint256 cvpSent) {
933     uint256 totalShares = totalSupply();
934     cvpSent = _share.mul(cvp.balanceOf(address(this))).div(totalShares);
935     _burn(msg.sender, _share);
936     cvp.safeTransfer(msg.sender, cvpSent);
937   }
938 
939   function name() public view override returns (string memory) {
940     return "Staked Concentrated Voting Power";
941   }
942 
943   function symbol() public view override returns (string memory) {
944     return "xCVP";
945   }
946 
947   function decimals() public view override returns (uint8) {
948     return uint8(18);
949   }
950 }