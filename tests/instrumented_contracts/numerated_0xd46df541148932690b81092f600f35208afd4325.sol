1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 
4 
5 pragma solidity >=0.6.0 <0.8.0;
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
30 
31 
32 pragma solidity >=0.6.0 <0.8.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: @openzeppelin/contracts/math/SafeMath.sol
109 
110 
111 
112 pragma solidity >=0.6.0 <0.8.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, with an overflow flag.
130      *
131      * _Available since v3.4._
132      */
133     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         uint256 c = a + b;
135         if (c < a) return (false, 0);
136         return (true, c);
137     }
138 
139     /**
140      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
141      *
142      * _Available since v3.4._
143      */
144     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
145         if (b > a) return (false, 0);
146         return (true, a - b);
147     }
148 
149     /**
150      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
151      *
152      * _Available since v3.4._
153      */
154     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
155         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
156         // benefit is lost if 'b' is also tested.
157         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
158         if (a == 0) return (true, 0);
159         uint256 c = a * b;
160         if (c / a != b) return (false, 0);
161         return (true, c);
162     }
163 
164     /**
165      * @dev Returns the division of two unsigned integers, with a division by zero flag.
166      *
167      * _Available since v3.4._
168      */
169     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
170         if (b == 0) return (false, 0);
171         return (true, a / b);
172     }
173 
174     /**
175      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
176      *
177      * _Available since v3.4._
178      */
179     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
180         if (b == 0) return (false, 0);
181         return (true, a % b);
182     }
183 
184     /**
185      * @dev Returns the addition of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `+` operator.
189      *
190      * Requirements:
191      *
192      * - Addition cannot overflow.
193      */
194     function add(uint256 a, uint256 b) internal pure returns (uint256) {
195         uint256 c = a + b;
196         require(c >= a, "SafeMath: addition overflow");
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         require(b <= a, "SafeMath: subtraction overflow");
212         return a - b;
213     }
214 
215     /**
216      * @dev Returns the multiplication of two unsigned integers, reverting on
217      * overflow.
218      *
219      * Counterpart to Solidity's `*` operator.
220      *
221      * Requirements:
222      *
223      * - Multiplication cannot overflow.
224      */
225     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
226         if (a == 0) return 0;
227         uint256 c = a * b;
228         require(c / a == b, "SafeMath: multiplication overflow");
229         return c;
230     }
231 
232     /**
233      * @dev Returns the integer division of two unsigned integers, reverting on
234      * division by zero. The result is rounded towards zero.
235      *
236      * Counterpart to Solidity's `/` operator. Note: this function uses a
237      * `revert` opcode (which leaves remaining gas untouched) while Solidity
238      * uses an invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function div(uint256 a, uint256 b) internal pure returns (uint256) {
245         require(b > 0, "SafeMath: division by zero");
246         return a / b;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * reverting when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         require(b > 0, "SafeMath: modulo by zero");
263         return a % b;
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
268      * overflow (when the result is negative).
269      *
270      * CAUTION: This function is deprecated because it requires allocating memory for the error
271      * message unnecessarily. For custom revert reasons use {trySub}.
272      *
273      * Counterpart to Solidity's `-` operator.
274      *
275      * Requirements:
276      *
277      * - Subtraction cannot overflow.
278      */
279     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
280         require(b <= a, errorMessage);
281         return a - b;
282     }
283 
284     /**
285      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
286      * division by zero. The result is rounded towards zero.
287      *
288      * CAUTION: This function is deprecated because it requires allocating memory for the error
289      * message unnecessarily. For custom revert reasons use {tryDiv}.
290      *
291      * Counterpart to Solidity's `/` operator. Note: this function uses a
292      * `revert` opcode (which leaves remaining gas untouched) while Solidity
293      * uses an invalid opcode to revert (consuming all remaining gas).
294      *
295      * Requirements:
296      *
297      * - The divisor cannot be zero.
298      */
299     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
300         require(b > 0, errorMessage);
301         return a / b;
302     }
303 
304     /**
305      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
306      * reverting with custom message when dividing by zero.
307      *
308      * CAUTION: This function is deprecated because it requires allocating memory for the error
309      * message unnecessarily. For custom revert reasons use {tryMod}.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b > 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
326 
327 
328 
329 pragma solidity >=0.6.0 <0.8.0;
330 
331 
332 
333 
334 /**
335  * @dev Implementation of the {IERC20} interface.
336  *
337  * This implementation is agnostic to the way tokens are created. This means
338  * that a supply mechanism has to be added in a derived contract using {_mint}.
339  * For a generic mechanism see {ERC20PresetMinterPauser}.
340  *
341  * TIP: For a detailed writeup see our guide
342  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
343  * to implement supply mechanisms].
344  *
345  * We have followed general OpenZeppelin guidelines: functions revert instead
346  * of returning `false` on failure. This behavior is nonetheless conventional
347  * and does not conflict with the expectations of ERC20 applications.
348  *
349  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
350  * This allows applications to reconstruct the allowance for all accounts just
351  * by listening to said events. Other implementations of the EIP may not emit
352  * these events, as it isn't required by the specification.
353  *
354  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
355  * functions have been added to mitigate the well-known issues around setting
356  * allowances. See {IERC20-approve}.
357  */
358 contract ERC20 is Context, IERC20 {
359     using SafeMath for uint256;
360 
361     mapping (address => uint256) private _balances;
362 
363     mapping (address => mapping (address => uint256)) private _allowances;
364 
365     uint256 private _totalSupply;
366 
367     string private _name;
368     string private _symbol;
369     uint8 private _decimals;
370 
371     /**
372      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
373      * a default value of 18.
374      *
375      * To select a different value for {decimals}, use {_setupDecimals}.
376      *
377      * All three of these values are immutable: they can only be set once during
378      * construction.
379      */
380     constructor (string memory name_, string memory symbol_) public {
381         _name = name_;
382         _symbol = symbol_;
383         _decimals = 18;
384     }
385 
386     /**
387      * @dev Returns the name of the token.
388      */
389     function name() public view virtual returns (string memory) {
390         return _name;
391     }
392 
393     /**
394      * @dev Returns the symbol of the token, usually a shorter version of the
395      * name.
396      */
397     function symbol() public view virtual returns (string memory) {
398         return _symbol;
399     }
400 
401     /**
402      * @dev Returns the number of decimals used to get its user representation.
403      * For example, if `decimals` equals `2`, a balance of `505` tokens should
404      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
405      *
406      * Tokens usually opt for a value of 18, imitating the relationship between
407      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
408      * called.
409      *
410      * NOTE: This information is only used for _display_ purposes: it in
411      * no way affects any of the arithmetic of the contract, including
412      * {IERC20-balanceOf} and {IERC20-transfer}.
413      */
414     function decimals() public view virtual returns (uint8) {
415         return _decimals;
416     }
417 
418     /**
419      * @dev See {IERC20-totalSupply}.
420      */
421     function totalSupply() public view virtual override returns (uint256) {
422         return _totalSupply;
423     }
424 
425     /**
426      * @dev See {IERC20-balanceOf}.
427      */
428     function balanceOf(address account) public view virtual override returns (uint256) {
429         return _balances[account];
430     }
431 
432     /**
433      * @dev See {IERC20-transfer}.
434      *
435      * Requirements:
436      *
437      * - `recipient` cannot be the zero address.
438      * - the caller must have a balance of at least `amount`.
439      */
440     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
441         _transfer(_msgSender(), recipient, amount);
442         return true;
443     }
444 
445     /**
446      * @dev See {IERC20-allowance}.
447      */
448     function allowance(address owner, address spender) public view virtual override returns (uint256) {
449         return _allowances[owner][spender];
450     }
451 
452     /**
453      * @dev See {IERC20-approve}.
454      *
455      * Requirements:
456      *
457      * - `spender` cannot be the zero address.
458      */
459     function approve(address spender, uint256 amount) public virtual override returns (bool) {
460         _approve(_msgSender(), spender, amount);
461         return true;
462     }
463 
464     /**
465      * @dev See {IERC20-transferFrom}.
466      *
467      * Emits an {Approval} event indicating the updated allowance. This is not
468      * required by the EIP. See the note at the beginning of {ERC20}.
469      *
470      * Requirements:
471      *
472      * - `sender` and `recipient` cannot be the zero address.
473      * - `sender` must have a balance of at least `amount`.
474      * - the caller must have allowance for ``sender``'s tokens of at least
475      * `amount`.
476      */
477     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
478         _transfer(sender, recipient, amount);
479         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
480         return true;
481     }
482 
483     /**
484      * @dev Atomically increases the allowance granted to `spender` by the caller.
485      *
486      * This is an alternative to {approve} that can be used as a mitigation for
487      * problems described in {IERC20-approve}.
488      *
489      * Emits an {Approval} event indicating the updated allowance.
490      *
491      * Requirements:
492      *
493      * - `spender` cannot be the zero address.
494      */
495     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
496         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
497         return true;
498     }
499 
500     /**
501      * @dev Atomically decreases the allowance granted to `spender` by the caller.
502      *
503      * This is an alternative to {approve} that can be used as a mitigation for
504      * problems described in {IERC20-approve}.
505      *
506      * Emits an {Approval} event indicating the updated allowance.
507      *
508      * Requirements:
509      *
510      * - `spender` cannot be the zero address.
511      * - `spender` must have allowance for the caller of at least
512      * `subtractedValue`.
513      */
514     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
515         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
516         return true;
517     }
518 
519     /**
520      * @dev Moves tokens `amount` from `sender` to `recipient`.
521      *
522      * This is internal function is equivalent to {transfer}, and can be used to
523      * e.g. implement automatic token fees, slashing mechanisms, etc.
524      *
525      * Emits a {Transfer} event.
526      *
527      * Requirements:
528      *
529      * - `sender` cannot be the zero address.
530      * - `recipient` cannot be the zero address.
531      * - `sender` must have a balance of at least `amount`.
532      */
533     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
534         require(sender != address(0), "ERC20: transfer from the zero address");
535         require(recipient != address(0), "ERC20: transfer to the zero address");
536 
537         _beforeTokenTransfer(sender, recipient, amount);
538 
539         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
540         _balances[recipient] = _balances[recipient].add(amount);
541         emit Transfer(sender, recipient, amount);
542     }
543 
544     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
545      * the total supply.
546      *
547      * Emits a {Transfer} event with `from` set to the zero address.
548      *
549      * Requirements:
550      *
551      * - `to` cannot be the zero address.
552      */
553     function _mint(address account, uint256 amount) internal virtual {
554         require(account != address(0), "ERC20: mint to the zero address");
555 
556         _beforeTokenTransfer(address(0), account, amount);
557 
558         _totalSupply = _totalSupply.add(amount);
559         _balances[account] = _balances[account].add(amount);
560         emit Transfer(address(0), account, amount);
561     }
562 
563     /**
564      * @dev Destroys `amount` tokens from `account`, reducing the
565      * total supply.
566      *
567      * Emits a {Transfer} event with `to` set to the zero address.
568      *
569      * Requirements:
570      *
571      * - `account` cannot be the zero address.
572      * - `account` must have at least `amount` tokens.
573      */
574     function _burn(address account, uint256 amount) internal virtual {
575         require(account != address(0), "ERC20: burn from the zero address");
576 
577         _beforeTokenTransfer(account, address(0), amount);
578 
579         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
580         _totalSupply = _totalSupply.sub(amount);
581         emit Transfer(account, address(0), amount);
582     }
583 
584     /**
585      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
586      *
587      * This internal function is equivalent to `approve`, and can be used to
588      * e.g. set automatic allowances for certain subsystems, etc.
589      *
590      * Emits an {Approval} event.
591      *
592      * Requirements:
593      *
594      * - `owner` cannot be the zero address.
595      * - `spender` cannot be the zero address.
596      */
597     function _approve(address owner, address spender, uint256 amount) internal virtual {
598         require(owner != address(0), "ERC20: approve from the zero address");
599         require(spender != address(0), "ERC20: approve to the zero address");
600 
601         _allowances[owner][spender] = amount;
602         emit Approval(owner, spender, amount);
603     }
604 
605     /**
606      * @dev Sets {decimals} to a value other than the default one of 18.
607      *
608      * WARNING: This function should only be called from the constructor. Most
609      * applications that interact with token contracts will not expect
610      * {decimals} to ever change, and may work incorrectly if it does.
611      */
612     function _setupDecimals(uint8 decimals_) internal virtual {
613         _decimals = decimals_;
614     }
615 
616     /**
617      * @dev Hook that is called before any transfer of tokens. This includes
618      * minting and burning.
619      *
620      * Calling conditions:
621      *
622      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
623      * will be to transferred to `to`.
624      * - when `from` is zero, `amount` tokens will be minted for `to`.
625      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
626      * - `from` and `to` are never both zero.
627      *
628      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
629      */
630     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
631 }
632 
633 // File: @openzeppelin/contracts/utils/Address.sol
634 
635 
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
827 
828 
829 pragma solidity >=0.6.0 <0.8.0;
830 
831 
832 
833 
834 /**
835  * @title SafeERC20
836  * @dev Wrappers around ERC20 operations that throw on failure (when the token
837  * contract returns false). Tokens that return no value (and instead revert or
838  * throw on failure) are also supported, non-reverting calls are assumed to be
839  * successful.
840  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
841  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
842  */
843 library SafeERC20 {
844     using SafeMath for uint256;
845     using Address for address;
846 
847     function safeTransfer(IERC20 token, address to, uint256 value) internal {
848         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
849     }
850 
851     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
852         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
853     }
854 
855     /**
856      * @dev Deprecated. This function has issues similar to the ones found in
857      * {IERC20-approve}, and its usage is discouraged.
858      *
859      * Whenever possible, use {safeIncreaseAllowance} and
860      * {safeDecreaseAllowance} instead.
861      */
862     function safeApprove(IERC20 token, address spender, uint256 value) internal {
863         // safeApprove should only be called when setting an initial allowance,
864         // or when resetting it to zero. To increase and decrease it, use
865         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
866         // solhint-disable-next-line max-line-length
867         require((value == 0) || (token.allowance(address(this), spender) == 0),
868             "SafeERC20: approve from non-zero to non-zero allowance"
869         );
870         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
871     }
872 
873     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
874         uint256 newAllowance = token.allowance(address(this), spender).add(value);
875         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
876     }
877 
878     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
879         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
880         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
881     }
882 
883     /**
884      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
885      * on the return value: the return value is optional (but if data is returned, it must not be false).
886      * @param token The token targeted by the call.
887      * @param data The call data (encoded using abi.encode or one of its variants).
888      */
889     function _callOptionalReturn(IERC20 token, bytes memory data) private {
890         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
891         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
892         // the target address contains contract code and also asserts for success in the low-level call.
893 
894         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
895         if (returndata.length > 0) { // Return data is optional
896             // solhint-disable-next-line max-line-length
897             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
898         }
899     }
900 }
901 
902 // File: contracts/dependencies/ERC20MintSnapshot.sol
903 
904 
905 
906 pragma solidity >=0.6.0 <0.8.0;
907 
908 
909 // Code Based on Compound's Comp.sol: https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
910 
911 contract ERC20MintSnapshot is ERC20 {
912     /// @notice A checkpoint for marking number of mints from a given block
913     struct Checkpoint {
914         uint32 fromBlock;
915         uint224 mints;
916     }
917 
918     /// @notice A record of mint checkpoints for each account, by index
919     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
920 
921     /// @notice The number of checkpoints for each account
922     mapping(address => uint32) public numCheckpoints;
923 
924     // Address to signify snapshotted total mint amount
925     address private constant TOTAL_MINT = address(0);
926 
927     constructor(string memory name, string memory symbol)
928         public
929         ERC20(name, symbol)
930     {}
931 
932     /**
933      * @notice Determine the prior amount of mints for an account as of a block number
934      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
935      * @param account The address of the account to check
936      * @param blockNumber The block number to get the mint balance at
937      * @return The amount of mints the account had as of the given block
938      */
939     function getPriorMints(address account, uint256 blockNumber)
940         public
941         view
942         returns (uint224)
943     {
944         require(
945             blockNumber < block.number,
946             "ERC20MintSnapshot::getPriorMints: not yet determined"
947         );
948 
949         uint32 nCheckpoints = numCheckpoints[account];
950         if (nCheckpoints == 0) {
951             return 0;
952         }
953 
954         // First check most recent balance
955         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
956             return checkpoints[account][nCheckpoints - 1].mints;
957         }
958 
959         // Next check implicit zero balance
960         if (checkpoints[account][0].fromBlock > blockNumber) {
961             return 0;
962         }
963 
964         uint32 lower = 0;
965         uint32 upper = nCheckpoints - 1;
966         while (upper > lower) {
967             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
968             Checkpoint memory cp = checkpoints[account][center];
969             if (cp.fromBlock == blockNumber) {
970                 return cp.mints;
971             } else if (cp.fromBlock < blockNumber) {
972                 lower = center;
973             } else {
974                 upper = center - 1;
975             }
976         }
977         return checkpoints[account][lower].mints;
978     }
979 
980     function _beforeTokenTransfer(
981         address from,
982         address to,
983         uint256 amount
984     ) internal override {
985         uint224 value =
986             safe224(
987                 amount,
988                 "ERC20MintSnapshot::_beforeTokenTransfer: Amount minted exceeds limit"
989             );
990         if (from == address(0) && value > 0) {
991             uint32 totalMintNum = numCheckpoints[TOTAL_MINT];
992             uint224 totalMintOld =
993                 totalMintNum > 0
994                     ? checkpoints[TOTAL_MINT][totalMintNum - 1].mints
995                     : 0;
996             uint224 totalMintNew =
997                 add224(
998                     totalMintOld,
999                     value,
1000                     "ERC20MintSnapshot::_beforeTokenTransfer: mint amount overflows"
1001                 );
1002             _writeCheckpoint(TOTAL_MINT, totalMintNum, totalMintNew);
1003 
1004             uint32 minterNum = numCheckpoints[to];
1005             uint224 minterOld =
1006                 minterNum > 0 ? checkpoints[to][minterNum - 1].mints : 0;
1007             uint224 minterNew =
1008                 add224(
1009                     minterOld,
1010                     value,
1011                     "ERC20MintSnapshot::_beforeTokenTransfer: mint amount overflows"
1012                 );
1013             _writeCheckpoint(to, minterNum, minterNew);
1014         }
1015     }
1016 
1017     function _writeCheckpoint(
1018         address minter,
1019         uint32 nCheckpoints,
1020         uint224 newMints
1021     ) internal {
1022         uint32 blockNumber =
1023             safe32(
1024                 block.number,
1025                 "ERC20MintSnapshot::_writeCheckpoint: block number exceeds 32 bits"
1026             );
1027 
1028         if (
1029             nCheckpoints > 0 &&
1030             checkpoints[minter][nCheckpoints - 1].fromBlock == blockNumber
1031         ) {
1032             checkpoints[minter][nCheckpoints - 1].mints = newMints;
1033         } else {
1034             checkpoints[minter][nCheckpoints] = Checkpoint(
1035                 blockNumber,
1036                 newMints
1037             );
1038             numCheckpoints[minter] = nCheckpoints + 1;
1039         }
1040     }
1041 
1042     function safe32(uint256 n, string memory errorMessage)
1043         internal
1044         pure
1045         returns (uint32)
1046     {
1047         require(n < 2**32, errorMessage);
1048         return uint32(n);
1049     }
1050 
1051     function safe224(uint256 n, string memory errorMessage)
1052         internal
1053         pure
1054         returns (uint224)
1055     {
1056         require(n < 2**224, errorMessage);
1057         return uint224(n);
1058     }
1059 
1060     function add224(
1061         uint224 a,
1062         uint224 b,
1063         string memory errorMessage
1064     ) internal pure returns (uint224) {
1065         uint224 c = a + b;
1066         require(c >= a, errorMessage);
1067         return c;
1068     }
1069 }
1070 
1071 // File: @openzeppelin/contracts/access/Ownable.sol
1072 
1073 
1074 
1075 pragma solidity >=0.6.0 <0.8.0;
1076 
1077 /**
1078  * @dev Contract module which provides a basic access control mechanism, where
1079  * there is an account (an owner) that can be granted exclusive access to
1080  * specific functions.
1081  *
1082  * By default, the owner account will be the one that deploys the contract. This
1083  * can later be changed with {transferOwnership}.
1084  *
1085  * This module is used through inheritance. It will make available the modifier
1086  * `onlyOwner`, which can be applied to your functions to restrict their use to
1087  * the owner.
1088  */
1089 abstract contract Ownable is Context {
1090     address private _owner;
1091 
1092     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1093 
1094     /**
1095      * @dev Initializes the contract setting the deployer as the initial owner.
1096      */
1097     constructor () internal {
1098         address msgSender = _msgSender();
1099         _owner = msgSender;
1100         emit OwnershipTransferred(address(0), msgSender);
1101     }
1102 
1103     /**
1104      * @dev Returns the address of the current owner.
1105      */
1106     function owner() public view virtual returns (address) {
1107         return _owner;
1108     }
1109 
1110     /**
1111      * @dev Throws if called by any account other than the owner.
1112      */
1113     modifier onlyOwner() {
1114         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1115         _;
1116     }
1117 
1118     /**
1119      * @dev Leaves the contract without owner. It will not be possible to call
1120      * `onlyOwner` functions anymore. Can only be called by the current owner.
1121      *
1122      * NOTE: Renouncing ownership will leave the contract without an owner,
1123      * thereby removing any functionality that is only available to the owner.
1124      */
1125     function renounceOwnership() public virtual onlyOwner {
1126         emit OwnershipTransferred(_owner, address(0));
1127         _owner = address(0);
1128     }
1129 
1130     /**
1131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1132      * Can only be called by the current owner.
1133      */
1134     function transferOwnership(address newOwner) public virtual onlyOwner {
1135         require(newOwner != address(0), "Ownable: new owner is the zero address");
1136         emit OwnershipTransferred(_owner, newOwner);
1137         _owner = newOwner;
1138     }
1139 }
1140 
1141 // File: contracts/dependencies/Controller.sol
1142 
1143 
1144 pragma solidity >=0.6.0 <0.8.0;
1145 
1146 
1147 contract Controller is Ownable {
1148     mapping(address => bool) operator;
1149 
1150     modifier onlyOperator() {
1151         require(operator[msg.sender], "Only-operator");
1152         _;
1153     }
1154 
1155     constructor() public {
1156         operator[msg.sender] = true;
1157     }
1158 
1159     function setOperator(address _operator, bool _whiteList) public onlyOwner {
1160         operator[_operator] = _whiteList;
1161     }
1162 }
1163 
1164 // File: contracts/dependencies/DSMath.sol
1165 
1166 
1167 
1168 /// Copied from: https://github.com/dapphub/ds-math/blob/master/src/math.sol
1169 
1170 // This program is free software: you can redistribute it and/or modify
1171 // it under the terms of the GNU General Public License as published by
1172 // the Free Software Foundation, either version 3 of the License, or
1173 // (at your option) any later version.
1174 
1175 // This program is distributed in the hope that it will be useful,
1176 // but WITHOUT ANY WARRANTY; without even the implied warranty of
1177 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1178 // GNU General Public License for more details.
1179 
1180 // You should have received a copy of the GNU General Public License
1181 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
1182 
1183 pragma solidity >0.4.13;
1184 
1185 library DSMath {
1186     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
1187         require((z = x + y) >= x, "ds-math-add-overflow");
1188     }
1189 
1190     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
1191         require((z = x - y) <= x, "ds-math-sub-underflow");
1192     }
1193 
1194     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
1195         require(y == 0 || (z = x * y) / y == x, "ds-math-mul-overflow");
1196     }
1197 
1198     function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
1199         return x <= y ? x : y;
1200     }
1201 
1202     function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
1203         return x >= y ? x : y;
1204     }
1205 
1206     function imin(int256 x, int256 y) internal pure returns (int256 z) {
1207         return x <= y ? x : y;
1208     }
1209 
1210     function imax(int256 x, int256 y) internal pure returns (int256 z) {
1211         return x >= y ? x : y;
1212     }
1213 
1214     uint256 constant WAD = 10**18;
1215     uint256 constant RAY = 10**27;
1216 
1217     //rounds to zero if x*y < WAD / 2
1218     function wmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
1219         z = add(mul(x, y), WAD / 2) / WAD;
1220     }
1221 
1222     //rounds to zero if x*y < WAD / 2
1223     function rmul(uint256 x, uint256 y) internal pure returns (uint256 z) {
1224         z = add(mul(x, y), RAY / 2) / RAY;
1225     }
1226 
1227     //rounds to zero if x*y < WAD / 2
1228     function wdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
1229         z = add(mul(x, WAD), y / 2) / y;
1230     }
1231 
1232     //rounds to zero if x*y < RAY / 2
1233     function rdiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
1234         z = add(mul(x, RAY), y / 2) / y;
1235     }
1236 
1237     // This famous algorithm is called "exponentiation by squaring"
1238     // and calculates x^n with x as fixed-point and n as regular unsigned.
1239     //
1240     // It's O(log n), instead of O(n) for naive repeated multiplication.
1241     //
1242     // These facts are why it works:
1243     //
1244     //  If n is even, then x^n = (x^2)^(n/2).
1245     //  If n is odd,  then x^n = x * x^(n-1),
1246     //   and applying the equation for even x gives
1247     //    x^n = x * (x^2)^((n-1) / 2).
1248     //
1249     //  Also, EVM division is flooring and
1250     //    floor[(n-1) / 2] = floor[n / 2].
1251     //
1252     function rpow(uint256 x, uint256 n) internal pure returns (uint256 z) {
1253         z = n % 2 != 0 ? x : RAY;
1254 
1255         for (n /= 2; n != 0; n /= 2) {
1256             x = rmul(x, x);
1257 
1258             if (n % 2 != 0) {
1259                 z = rmul(z, x);
1260             }
1261         }
1262     }
1263 }
1264 
1265 // File: contracts/dependencies/FeeToken.sol
1266 
1267 
1268 
1269 pragma solidity >=0.6.0 <0.8.0;
1270 
1271 
1272 
1273 abstract contract FeeToken is Controller {
1274     using DSMath for uint256;
1275 
1276     uint256 private constant TX_FEE = 0.0025 ether;
1277 
1278     mapping(address => bool) public feeless;
1279 
1280     constructor() public Controller() {
1281         feeless[owner()] = true;
1282     }
1283 
1284     function _consumeFee(
1285         address sender,
1286         address recipient,
1287         uint256 amount
1288     ) internal returns (uint256 output) {
1289         output = amount;
1290         if (!feeless[recipient]) {
1291             uint256 fee = output.wmul(TX_FEE);
1292             output -= fee;
1293             _transferFee(sender, fee);
1294         }
1295     }
1296 
1297     function setFeeless(address account, bool isFeeless)
1298         external
1299         onlyOperator()
1300     {
1301         feeless[account] = isFeeless;
1302     }
1303 
1304     function _transferFee(address from, uint256 amount) internal virtual;
1305 
1306     // Utility Pure Functions
1307 
1308     function getAmountPlusFee(uint256 amount) external pure returns (uint256) {
1309         return amount.wdiv(1 ether - TX_FEE) * 100;
1310     }
1311 
1312     function getTransactionFee(uint256 amount) external pure returns (uint256) {
1313         return amount.wmul(TX_FEE);
1314     }
1315 }
1316 
1317 // File: contracts/mainnet/PRISM.sol
1318 
1319 
1320 
1321 pragma solidity >=0.6.0 <0.8.0;
1322 
1323 
1324 
1325 
1326 
1327 /**
1328  * PRISM ERC20 Token
1329  *
1330  * Attributes:
1331  * - Can be burned by anyone to forcibly reduce total supply
1332  * - Converts DEF/ETH LP shares at a 0.000005 LP to PRISM ratio
1333  */
1334 contract PRISM is ERC20MintSnapshot, FeeToken {
1335     using SafeERC20 for ERC20;
1336 
1337     ERC20 private constant DEF_ETH_LP =
1338         ERC20(0x347C280FA84363147441cAE5CD28DF1B596f2C1f);
1339     uint256 private constant LP_RATIO = 0.000005 ether;
1340 
1341     event Mint(address indexed _to, uint256 indexed _amount);
1342 
1343     constructor() public ERC20MintSnapshot("PRISM Token", "PRISM") {}
1344 
1345     function mint(uint256 amount) external {
1346         require(amount > 0, "Invalid-amount");
1347         DEF_ETH_LP.safeTransferFrom(msg.sender, address(this), amount);
1348         uint256 mintAmount = amount.wdiv(LP_RATIO);
1349         require(mintAmount > 0, "Invalid-amount");
1350         _mint(msg.sender, mintAmount);
1351         emit Mint(msg.sender, mintAmount);
1352     }
1353 
1354     function burn(uint256 amount) external {
1355         _burn(msg.sender, amount);
1356     }
1357 
1358     function transfer(address recipient, uint256 amount)
1359         public
1360         override
1361         returns (bool)
1362     {
1363         _transfer(
1364             _msgSender(),
1365             recipient,
1366             _consumeFee(_msgSender(), recipient, amount)
1367         );
1368         return true;
1369     }
1370 
1371     function transferFrom(
1372         address sender,
1373         address recipient,
1374         uint256 amount
1375     ) public override returns (bool) {
1376         _transfer(sender, recipient, _consumeFee(sender, recipient, amount));
1377         _approve(
1378             sender,
1379             _msgSender(),
1380             allowance(sender, _msgSender()).sub(
1381                 amount,
1382                 "ERC20: transfer amount exceeds allowance"
1383             )
1384         );
1385         return true;
1386     }
1387 
1388     function _transferFee(address from, uint256 amount) internal override {
1389         _transfer(from, owner(), amount); // owner is bridge
1390     }
1391 }