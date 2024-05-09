1 // File: @openzeppelin/contracts/math/SafeMath.sol
2 
3 // SPDX-License-Identifier: BUSL-1.1 AND Unlicense AND MIT AND GPL-2.0-or-later
4 
5 pragma solidity ^0.7.0;
6 
7 /**
8  * @dev Wrappers over Solidity's arithmetic operations with added overflow
9  * checks.
10  *
11  * Arithmetic operations in Solidity wrap on overflow. This can easily result
12  * in bugs, because programmers usually assume that an overflow raises an
13  * error, which is the standard behavior in high level programming languages.
14  * `SafeMath` restores this intuition by reverting the transaction when an
15  * operation overflows.
16  *
17  * Using this library instead of the unchecked operations eliminates an entire
18  * class of bugs, so it's recommended to use it always.
19  */
20 library SafeMath {
21     /**
22      * @dev Returns the addition of two unsigned integers, with an overflow flag.
23      *
24      * _Available since v3.4._
25      */
26     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
27         uint256 c = a + b;
28         if (c < a) return (false, 0);
29         return (true, c);
30     }
31 
32     /**
33      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
34      *
35      * _Available since v3.4._
36      */
37     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
38         if (b > a) return (false, 0);
39         return (true, a - b);
40     }
41 
42     /**
43      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
44      *
45      * _Available since v3.4._
46      */
47     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
48         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49         // benefit is lost if 'b' is also tested.
50         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
51         if (a == 0) return (true, 0);
52         uint256 c = a * b;
53         if (c / a != b) return (false, 0);
54         return (true, c);
55     }
56 
57     /**
58      * @dev Returns the division of two unsigned integers, with a division by zero flag.
59      *
60      * _Available since v3.4._
61      */
62     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
63         if (b == 0) return (false, 0);
64         return (true, a / b);
65     }
66 
67     /**
68      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
69      *
70      * _Available since v3.4._
71      */
72     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
73         if (b == 0) return (false, 0);
74         return (true, a % b);
75     }
76 
77     /**
78      * @dev Returns the addition of two unsigned integers, reverting on
79      * overflow.
80      *
81      * Counterpart to Solidity's `+` operator.
82      *
83      * Requirements:
84      *
85      * - Addition cannot overflow.
86      */
87     function add(uint256 a, uint256 b) internal pure returns (uint256) {
88         uint256 c = a + b;
89         require(c >= a, "SafeMath: addition overflow");
90         return c;
91     }
92 
93     /**
94      * @dev Returns the subtraction of two unsigned integers, reverting on
95      * overflow (when the result is negative).
96      *
97      * Counterpart to Solidity's `-` operator.
98      *
99      * Requirements:
100      *
101      * - Subtraction cannot overflow.
102      */
103     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
104         require(b <= a, "SafeMath: subtraction overflow");
105         return a - b;
106     }
107 
108     /**
109      * @dev Returns the multiplication of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `*` operator.
113      *
114      * Requirements:
115      *
116      * - Multiplication cannot overflow.
117      */
118     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
119         if (a == 0) return 0;
120         uint256 c = a * b;
121         require(c / a == b, "SafeMath: multiplication overflow");
122         return c;
123     }
124 
125     /**
126      * @dev Returns the integer division of two unsigned integers, reverting on
127      * division by zero. The result is rounded towards zero.
128      *
129      * Counterpart to Solidity's `/` operator. Note: this function uses a
130      * `revert` opcode (which leaves remaining gas untouched) while Solidity
131      * uses an invalid opcode to revert (consuming all remaining gas).
132      *
133      * Requirements:
134      *
135      * - The divisor cannot be zero.
136      */
137     function div(uint256 a, uint256 b) internal pure returns (uint256) {
138         require(b > 0, "SafeMath: division by zero");
139         return a / b;
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * reverting when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
155         require(b > 0, "SafeMath: modulo by zero");
156         return a % b;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * CAUTION: This function is deprecated because it requires allocating memory for the error
164      * message unnecessarily. For custom revert reasons use {trySub}.
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         return a - b;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
179      * division by zero. The result is rounded towards zero.
180      *
181      * CAUTION: This function is deprecated because it requires allocating memory for the error
182      * message unnecessarily. For custom revert reasons use {tryDiv}.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         return a / b;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * reverting with custom message when dividing by zero.
200      *
201      * CAUTION: This function is deprecated because it requires allocating memory for the error
202      * message unnecessarily. For custom revert reasons use {tryMod}.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
213         require(b > 0, errorMessage);
214         return a % b;
215     }
216 }
217 
218 // File: @openzeppelin/contracts/utils/Context.sol
219 
220 // License-Identifier: MIT
221 
222 pragma solidity >=0.6.0 <0.8.0;
223 
224 /*
225  * @dev Provides information about the current execution context, including the
226  * sender of the transaction and its data. While these are generally available
227  * via msg.sender and msg.data, they should not be accessed in such a direct
228  * manner, since when dealing with GSN meta-transactions the account sending and
229  * paying for execution may not be the actual sender (as far as an application
230  * is concerned).
231  *
232  * This contract is only required for intermediate, library-like contracts.
233  */
234 abstract contract Context {
235     function _msgSender() internal view virtual returns (address payable) {
236         return msg.sender;
237     }
238 
239     function _msgData() internal view virtual returns (bytes memory) {
240         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
241         return msg.data;
242     }
243 }
244 
245 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
246 
247 // License-Identifier: MIT
248 
249 pragma solidity ^0.7.0;
250 
251 /**
252  * @dev Interface of the ERC20 standard as defined in the EIP.
253  */
254 interface IERC20 {
255     /**
256      * @dev Returns the amount of tokens in existence.
257      */
258     function totalSupply() external view returns (uint256);
259 
260     /**
261      * @dev Returns the amount of tokens owned by `account`.
262      */
263     function balanceOf(address account) external view returns (uint256);
264 
265     /**
266      * @dev Moves `amount` tokens from the caller's account to `recipient`.
267      *
268      * Returns a boolean value indicating whether the operation succeeded.
269      *
270      * Emits a {Transfer} event.
271      */
272     function transfer(address recipient, uint256 amount) external returns (bool);
273 
274     /**
275      * @dev Returns the remaining number of tokens that `spender` will be
276      * allowed to spend on behalf of `owner` through {transferFrom}. This is
277      * zero by default.
278      *
279      * This value changes when {approve} or {transferFrom} are called.
280      */
281     function allowance(address owner, address spender) external view returns (uint256);
282 
283     /**
284      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
285      *
286      * Returns a boolean value indicating whether the operation succeeded.
287      *
288      * IMPORTANT: Beware that changing an allowance with this method brings the risk
289      * that someone may use both the old and the new allowance by unfortunate
290      * transaction ordering. One possible solution to mitigate this race
291      * condition is to first reduce the spender's allowance to 0 and set the
292      * desired value afterwards:
293      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
294      *
295      * Emits an {Approval} event.
296      */
297     function approve(address spender, uint256 amount) external returns (bool);
298 
299     /**
300      * @dev Moves `amount` tokens from `sender` to `recipient` using the
301      * allowance mechanism. `amount` is then deducted from the caller's
302      * allowance.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * Emits a {Transfer} event.
307      */
308     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
309 
310     /**
311      * @dev Emitted when `value` tokens are moved from one account (`from`) to
312      * another (`to`).
313      *
314      * Note that `value` may be zero.
315      */
316     event Transfer(address indexed from, address indexed to, uint256 value);
317 
318     /**
319      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
320      * a call to {approve}. `value` is the new allowance.
321      */
322     event Approval(address indexed owner, address indexed spender, uint256 value);
323 }
324 
325 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
326 
327 // License-Identifier: MIT
328 
329 pragma solidity ^0.7.0;
330 
331 /**
332  * @dev Implementation of the {IERC20} interface.
333  *
334  * This implementation is agnostic to the way tokens are created. This means
335  * that a supply mechanism has to be added in a derived contract using {_mint}.
336  * For a generic mechanism see {ERC20PresetMinterPauser}.
337  *
338  * TIP: For a detailed writeup see our guide
339  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
340  * to implement supply mechanisms].
341  *
342  * We have followed general OpenZeppelin guidelines: functions revert instead
343  * of returning `false` on failure. This behavior is nonetheless conventional
344  * and does not conflict with the expectations of ERC20 applications.
345  *
346  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
347  * This allows applications to reconstruct the allowance for all accounts just
348  * by listening to said events. Other implementations of the EIP may not emit
349  * these events, as it isn't required by the specification.
350  *
351  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
352  * functions have been added to mitigate the well-known issues around setting
353  * allowances. See {IERC20-approve}.
354  */
355 contract ERC20 is Context, IERC20 {
356     using SafeMath for uint256;
357 
358     mapping (address => uint256) private _balances;
359 
360     mapping (address => mapping (address => uint256)) private _allowances;
361 
362     uint256 private _totalSupply;
363 
364     string private _name;
365     string private _symbol;
366     uint8 private _decimals;
367 
368     /**
369      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
370      * a default value of 18.
371      *
372      * To select a different value for {decimals}, use {_setupDecimals}.
373      *
374      * All three of these values are immutable: they can only be set once during
375      * construction.
376      */
377     constructor (string memory name_, string memory symbol_) {
378         _name = name_;
379         _symbol = symbol_;
380         _decimals = 18;
381     }
382 
383     /**
384      * @dev Returns the name of the token.
385      */
386     function name() public view virtual returns (string memory) {
387         return _name;
388     }
389 
390     /**
391      * @dev Returns the symbol of the token, usually a shorter version of the
392      * name.
393      */
394     function symbol() public view virtual returns (string memory) {
395         return _symbol;
396     }
397 
398     /**
399      * @dev Returns the number of decimals used to get its user representation.
400      * For example, if `decimals` equals `2`, a balance of `505` tokens should
401      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
402      *
403      * Tokens usually opt for a value of 18, imitating the relationship between
404      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
405      * called.
406      *
407      * NOTE: This information is only used for _display_ purposes: it in
408      * no way affects any of the arithmetic of the contract, including
409      * {IERC20-balanceOf} and {IERC20-transfer}.
410      */
411     function decimals() public view virtual returns (uint8) {
412         return _decimals;
413     }
414 
415     /**
416      * @dev See {IERC20-totalSupply}.
417      */
418     function totalSupply() public view virtual override returns (uint256) {
419         return _totalSupply;
420     }
421 
422     /**
423      * @dev See {IERC20-balanceOf}.
424      */
425     function balanceOf(address account) public view virtual override returns (uint256) {
426         return _balances[account];
427     }
428 
429     /**
430      * @dev See {IERC20-transfer}.
431      *
432      * Requirements:
433      *
434      * - `recipient` cannot be the zero address.
435      * - the caller must have a balance of at least `amount`.
436      */
437     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
438         _transfer(_msgSender(), recipient, amount);
439         return true;
440     }
441 
442     /**
443      * @dev See {IERC20-allowance}.
444      */
445     function allowance(address owner, address spender) public view virtual override returns (uint256) {
446         return _allowances[owner][spender];
447     }
448 
449     /**
450      * @dev See {IERC20-approve}.
451      *
452      * Requirements:
453      *
454      * - `spender` cannot be the zero address.
455      */
456     function approve(address spender, uint256 amount) public virtual override returns (bool) {
457         _approve(_msgSender(), spender, amount);
458         return true;
459     }
460 
461     /**
462      * @dev See {IERC20-transferFrom}.
463      *
464      * Emits an {Approval} event indicating the updated allowance. This is not
465      * required by the EIP. See the note at the beginning of {ERC20}.
466      *
467      * Requirements:
468      *
469      * - `sender` and `recipient` cannot be the zero address.
470      * - `sender` must have a balance of at least `amount`.
471      * - the caller must have allowance for ``sender``'s tokens of at least
472      * `amount`.
473      */
474     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
475         _transfer(sender, recipient, amount);
476         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
477         return true;
478     }
479 
480     /**
481      * @dev Atomically increases the allowance granted to `spender` by the caller.
482      *
483      * This is an alternative to {approve} that can be used as a mitigation for
484      * problems described in {IERC20-approve}.
485      *
486      * Emits an {Approval} event indicating the updated allowance.
487      *
488      * Requirements:
489      *
490      * - `spender` cannot be the zero address.
491      */
492     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
493         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
494         return true;
495     }
496 
497     /**
498      * @dev Atomically decreases the allowance granted to `spender` by the caller.
499      *
500      * This is an alternative to {approve} that can be used as a mitigation for
501      * problems described in {IERC20-approve}.
502      *
503      * Emits an {Approval} event indicating the updated allowance.
504      *
505      * Requirements:
506      *
507      * - `spender` cannot be the zero address.
508      * - `spender` must have allowance for the caller of at least
509      * `subtractedValue`.
510      */
511     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
512         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
513         return true;
514     }
515 
516     /**
517      * @dev Moves tokens `amount` from `sender` to `recipient`.
518      *
519      * This is internal function is equivalent to {transfer}, and can be used to
520      * e.g. implement automatic token fees, slashing mechanisms, etc.
521      *
522      * Emits a {Transfer} event.
523      *
524      * Requirements:
525      *
526      * - `sender` cannot be the zero address.
527      * - `recipient` cannot be the zero address.
528      * - `sender` must have a balance of at least `amount`.
529      */
530     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
531         require(sender != address(0), "ERC20: transfer from the zero address");
532         require(recipient != address(0), "ERC20: transfer to the zero address");
533 
534         _beforeTokenTransfer(sender, recipient, amount);
535 
536         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
537         _balances[recipient] = _balances[recipient].add(amount);
538         emit Transfer(sender, recipient, amount);
539     }
540 
541     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
542      * the total supply.
543      *
544      * Emits a {Transfer} event with `from` set to the zero address.
545      *
546      * Requirements:
547      *
548      * - `to` cannot be the zero address.
549      */
550     function _mint(address account, uint256 amount) internal virtual {
551         require(account != address(0), "ERC20: mint to the zero address");
552 
553         _beforeTokenTransfer(address(0), account, amount);
554 
555         _totalSupply = _totalSupply.add(amount);
556         _balances[account] = _balances[account].add(amount);
557         emit Transfer(address(0), account, amount);
558     }
559 
560     /**
561      * @dev Destroys `amount` tokens from `account`, reducing the
562      * total supply.
563      *
564      * Emits a {Transfer} event with `to` set to the zero address.
565      *
566      * Requirements:
567      *
568      * - `account` cannot be the zero address.
569      * - `account` must have at least `amount` tokens.
570      */
571     function _burn(address account, uint256 amount) internal virtual {
572         require(account != address(0), "ERC20: burn from the zero address");
573 
574         _beforeTokenTransfer(account, address(0), amount);
575 
576         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
577         _totalSupply = _totalSupply.sub(amount);
578         emit Transfer(account, address(0), amount);
579     }
580 
581     /**
582      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
583      *
584      * This internal function is equivalent to `approve`, and can be used to
585      * e.g. set automatic allowances for certain subsystems, etc.
586      *
587      * Emits an {Approval} event.
588      *
589      * Requirements:
590      *
591      * - `owner` cannot be the zero address.
592      * - `spender` cannot be the zero address.
593      */
594     function _approve(address owner, address spender, uint256 amount) internal virtual {
595         require(owner != address(0), "ERC20: approve from the zero address");
596         require(spender != address(0), "ERC20: approve to the zero address");
597 
598         _allowances[owner][spender] = amount;
599         emit Approval(owner, spender, amount);
600     }
601 
602     /**
603      * @dev Sets {decimals} to a value other than the default one of 18.
604      *
605      * WARNING: This function should only be called from the constructor. Most
606      * applications that interact with token contracts will not expect
607      * {decimals} to ever change, and may work incorrectly if it does.
608      */
609     function _setupDecimals(uint8 decimals_) internal virtual {
610         _decimals = decimals_;
611     }
612 
613     /**
614      * @dev Hook that is called before any transfer of tokens. This includes
615      * minting and burning.
616      *
617      * Calling conditions:
618      *
619      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
620      * will be to transferred to `to`.
621      * - when `from` is zero, `amount` tokens will be minted for `to`.
622      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
623      * - `from` and `to` are never both zero.
624      *
625      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
626      */
627     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
628 }
629 
630 // File: @openzeppelin/contracts/utils/Address.sol
631 
632 // License-Identifier: MIT
633 
634 pragma solidity ^0.7.0;
635 
636 /**
637  * @dev Collection of functions related to the address type
638  */
639 library Address {
640     /**
641      * @dev Returns true if `account` is a contract.
642      *
643      * [IMPORTANT]
644      * ====
645      * It is unsafe to assume that an address for which this function returns
646      * false is an externally-owned account (EOA) and not a contract.
647      *
648      * Among others, `isContract` will return false for the following
649      * types of addresses:
650      *
651      *  - an externally-owned account
652      *  - a contract in construction
653      *  - an address where a contract will be created
654      *  - an address where a contract lived, but was destroyed
655      * ====
656      */
657     function isContract(address account) internal view returns (bool) {
658         // This method relies on extcodesize, which returns 0 for contracts in
659         // construction, since the code is only stored at the end of the
660         // constructor execution.
661 
662         uint256 size;
663         // solhint-disable-next-line no-inline-assembly
664         assembly { size := extcodesize(account) }
665         return size > 0;
666     }
667 
668     /**
669      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
670      * `recipient`, forwarding all available gas and reverting on errors.
671      *
672      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
673      * of certain opcodes, possibly making contracts go over the 2300 gas limit
674      * imposed by `transfer`, making them unable to receive funds via
675      * `transfer`. {sendValue} removes this limitation.
676      *
677      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
678      *
679      * IMPORTANT: because control is transferred to `recipient`, care must be
680      * taken to not create reentrancy vulnerabilities. Consider using
681      * {ReentrancyGuard} or the
682      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
683      */
684     function sendValue(address payable recipient, uint256 amount) internal {
685         require(address(this).balance >= amount, "Address: insufficient balance");
686 
687         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
688         (bool success, ) = recipient.call{ value: amount }("");
689         require(success, "Address: unable to send value, recipient may have reverted");
690     }
691 
692     /**
693      * @dev Performs a Solidity function call using a low level `call`. A
694      * plain`call` is an unsafe replacement for a function call: use this
695      * function instead.
696      *
697      * If `target` reverts with a revert reason, it is bubbled up by this
698      * function (like regular Solidity function calls).
699      *
700      * Returns the raw returned data. To convert to the expected return value,
701      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
702      *
703      * Requirements:
704      *
705      * - `target` must be a contract.
706      * - calling `target` with `data` must not revert.
707      *
708      * _Available since v3.1._
709      */
710     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
711       return functionCall(target, data, "Address: low-level call failed");
712     }
713 
714     /**
715      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
716      * `errorMessage` as a fallback revert reason when `target` reverts.
717      *
718      * _Available since v3.1._
719      */
720     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
721         return functionCallWithValue(target, data, 0, errorMessage);
722     }
723 
724     /**
725      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
726      * but also transferring `value` wei to `target`.
727      *
728      * Requirements:
729      *
730      * - the calling contract must have an ETH balance of at least `value`.
731      * - the called Solidity function must be `payable`.
732      *
733      * _Available since v3.1._
734      */
735     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
736         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
737     }
738 
739     /**
740      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
741      * with `errorMessage` as a fallback revert reason when `target` reverts.
742      *
743      * _Available since v3.1._
744      */
745     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
746         require(address(this).balance >= value, "Address: insufficient balance for call");
747         require(isContract(target), "Address: call to non-contract");
748 
749         // solhint-disable-next-line avoid-low-level-calls
750         (bool success, bytes memory returndata) = target.call{ value: value }(data);
751         return _verifyCallResult(success, returndata, errorMessage);
752     }
753 
754     /**
755      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
756      * but performing a static call.
757      *
758      * _Available since v3.3._
759      */
760     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
761         return functionStaticCall(target, data, "Address: low-level static call failed");
762     }
763 
764     /**
765      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
766      * but performing a static call.
767      *
768      * _Available since v3.3._
769      */
770     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
771         require(isContract(target), "Address: static call to non-contract");
772 
773         // solhint-disable-next-line avoid-low-level-calls
774         (bool success, bytes memory returndata) = target.staticcall(data);
775         return _verifyCallResult(success, returndata, errorMessage);
776     }
777 
778     /**
779      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
780      * but performing a delegate call.
781      *
782      * _Available since v3.4._
783      */
784     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
785         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
786     }
787 
788     /**
789      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
790      * but performing a delegate call.
791      *
792      * _Available since v3.4._
793      */
794     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
795         require(isContract(target), "Address: delegate call to non-contract");
796 
797         // solhint-disable-next-line avoid-low-level-calls
798         (bool success, bytes memory returndata) = target.delegatecall(data);
799         return _verifyCallResult(success, returndata, errorMessage);
800     }
801 
802     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
803         if (success) {
804             return returndata;
805         } else {
806             // Look for revert reason and bubble it up if present
807             if (returndata.length > 0) {
808                 // The easiest way to bubble the revert reason is using memory via assembly
809 
810                 // solhint-disable-next-line no-inline-assembly
811                 assembly {
812                     let returndata_size := mload(returndata)
813                     revert(add(32, returndata), returndata_size)
814                 }
815             } else {
816                 revert(errorMessage);
817             }
818         }
819     }
820 }
821 
822 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
823 
824 // License-Identifier: MIT
825 
826 pragma solidity ^0.7.0;
827 
828 /**
829  * @title SafeERC20
830  * @dev Wrappers around ERC20 operations that throw on failure (when the token
831  * contract returns false). Tokens that return no value (and instead revert or
832  * throw on failure) are also supported, non-reverting calls are assumed to be
833  * successful.
834  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
835  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
836  */
837 library SafeERC20 {
838     using SafeMath for uint256;
839     using Address for address;
840 
841     function safeTransfer(IERC20 token, address to, uint256 value) internal {
842         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
843     }
844 
845     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
846         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
847     }
848 
849     /**
850      * @dev Deprecated. This function has issues similar to the ones found in
851      * {IERC20-approve}, and its usage is discouraged.
852      *
853      * Whenever possible, use {safeIncreaseAllowance} and
854      * {safeDecreaseAllowance} instead.
855      */
856     function safeApprove(IERC20 token, address spender, uint256 value) internal {
857         // safeApprove should only be called when setting an initial allowance,
858         // or when resetting it to zero. To increase and decrease it, use
859         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
860         // solhint-disable-next-line max-line-length
861         require((value == 0) || (token.allowance(address(this), spender) == 0),
862             "SafeERC20: approve from non-zero to non-zero allowance"
863         );
864         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
865     }
866 
867     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
868         uint256 newAllowance = token.allowance(address(this), spender).add(value);
869         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
870     }
871 
872     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
873         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
874         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
875     }
876 
877     /**
878      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
879      * on the return value: the return value is optional (but if data is returned, it must not be false).
880      * @param token The token targeted by the call.
881      * @param data The call data (encoded using abi.encode or one of its variants).
882      */
883     function _callOptionalReturn(IERC20 token, bytes memory data) private {
884         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
885         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
886         // the target address contains contract code and also asserts for success in the low-level call.
887 
888         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
889         if (returndata.length > 0) { // Return data is optional
890             // solhint-disable-next-line max-line-length
891             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
892         }
893     }
894 }
895 
896 // File: @openzeppelin/contracts/access/Ownable.sol
897 
898 // License-Identifier: MIT
899 
900 pragma solidity ^0.7.0;
901 
902 /**
903  * @dev Contract module which provides a basic access control mechanism, where
904  * there is an account (an owner) that can be granted exclusive access to
905  * specific functions.
906  *
907  * By default, the owner account will be the one that deploys the contract. This
908  * can later be changed with {transferOwnership}.
909  *
910  * This module is used through inheritance. It will make available the modifier
911  * `onlyOwner`, which can be applied to your functions to restrict their use to
912  * the owner.
913  */
914 abstract contract Ownable is Context {
915     address private _owner;
916 
917     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
918 
919     /**
920      * @dev Initializes the contract setting the deployer as the initial owner.
921      */
922     constructor () {
923         address msgSender = _msgSender();
924         _owner = msgSender;
925         emit OwnershipTransferred(address(0), msgSender);
926     }
927 
928     /**
929      * @dev Returns the address of the current owner.
930      */
931     function owner() public view virtual returns (address) {
932         return _owner;
933     }
934 
935     /**
936      * @dev Throws if called by any account other than the owner.
937      */
938     modifier onlyOwner() {
939         require(owner() == _msgSender(), "Ownable: caller is not the owner");
940         _;
941     }
942 
943     /**
944      * @dev Leaves the contract without owner. It will not be possible to call
945      * `onlyOwner` functions anymore. Can only be called by the current owner.
946      *
947      * NOTE: Renouncing ownership will leave the contract without an owner,
948      * thereby removing any functionality that is only available to the owner.
949      */
950     function renounceOwnership() public virtual onlyOwner {
951         emit OwnershipTransferred(_owner, address(0));
952         _owner = address(0);
953     }
954 
955     /**
956      * @dev Transfers ownership of the contract to a new account (`newOwner`).
957      * Can only be called by the current owner.
958      */
959     function transferOwnership(address newOwner) public virtual onlyOwner {
960         require(newOwner != address(0), "Ownable: new owner is the zero address");
961         emit OwnershipTransferred(_owner, newOwner);
962         _owner = newOwner;
963     }
964 }
965 
966 // File: @uniswap/v3-core/contracts/libraries/TickMath.sol
967 
968 // License-Identifier: GPL-2.0-or-later
969 
970 pragma solidity >=0.5.0;
971 
972 /// @title Math library for computing sqrt prices from ticks and vice versa
973 /// @notice Computes sqrt price for ticks of size 1.0001, i.e. sqrt(1.0001^tick) as fixed point Q64.96 numbers. Supports
974 /// prices between 2**-128 and 2**128
975 library TickMath {
976     /// @dev The minimum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**-128
977     int24 internal constant MIN_TICK = -887272;
978     /// @dev The maximum tick that may be passed to #getSqrtRatioAtTick computed from log base 1.0001 of 2**128
979     int24 internal constant MAX_TICK = -MIN_TICK;
980 
981     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
982     uint160 internal constant MIN_SQRT_RATIO = 4295128739;
983     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
984     uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
985 
986     /// @notice Calculates sqrt(1.0001^tick) * 2^96
987     /// @dev Throws if |tick| > max tick
988     /// @param tick The input tick for the above formula
989     /// @return sqrtPriceX96 A Fixed point Q64.96 number representing the sqrt of the ratio of the two assets (token1/token0)
990     /// at the given tick
991     function getSqrtRatioAtTick(int24 tick) internal pure returns (uint160 sqrtPriceX96) {
992         uint256 absTick = tick < 0 ? uint256(-int256(tick)) : uint256(int256(tick));
993         require(absTick <= uint256(MAX_TICK), 'T');
994 
995         uint256 ratio = absTick & 0x1 != 0 ? 0xfffcb933bd6fad37aa2d162d1a594001 : 0x100000000000000000000000000000000;
996         if (absTick & 0x2 != 0) ratio = (ratio * 0xfff97272373d413259a46990580e213a) >> 128;
997         if (absTick & 0x4 != 0) ratio = (ratio * 0xfff2e50f5f656932ef12357cf3c7fdcc) >> 128;
998         if (absTick & 0x8 != 0) ratio = (ratio * 0xffe5caca7e10e4e61c3624eaa0941cd0) >> 128;
999         if (absTick & 0x10 != 0) ratio = (ratio * 0xffcb9843d60f6159c9db58835c926644) >> 128;
1000         if (absTick & 0x20 != 0) ratio = (ratio * 0xff973b41fa98c081472e6896dfb254c0) >> 128;
1001         if (absTick & 0x40 != 0) ratio = (ratio * 0xff2ea16466c96a3843ec78b326b52861) >> 128;
1002         if (absTick & 0x80 != 0) ratio = (ratio * 0xfe5dee046a99a2a811c461f1969c3053) >> 128;
1003         if (absTick & 0x100 != 0) ratio = (ratio * 0xfcbe86c7900a88aedcffc83b479aa3a4) >> 128;
1004         if (absTick & 0x200 != 0) ratio = (ratio * 0xf987a7253ac413176f2b074cf7815e54) >> 128;
1005         if (absTick & 0x400 != 0) ratio = (ratio * 0xf3392b0822b70005940c7a398e4b70f3) >> 128;
1006         if (absTick & 0x800 != 0) ratio = (ratio * 0xe7159475a2c29b7443b29c7fa6e889d9) >> 128;
1007         if (absTick & 0x1000 != 0) ratio = (ratio * 0xd097f3bdfd2022b8845ad8f792aa5825) >> 128;
1008         if (absTick & 0x2000 != 0) ratio = (ratio * 0xa9f746462d870fdf8a65dc1f90e061e5) >> 128;
1009         if (absTick & 0x4000 != 0) ratio = (ratio * 0x70d869a156d2a1b890bb3df62baf32f7) >> 128;
1010         if (absTick & 0x8000 != 0) ratio = (ratio * 0x31be135f97d08fd981231505542fcfa6) >> 128;
1011         if (absTick & 0x10000 != 0) ratio = (ratio * 0x9aa508b5b7a84e1c677de54f3e99bc9) >> 128;
1012         if (absTick & 0x20000 != 0) ratio = (ratio * 0x5d6af8dedb81196699c329225ee604) >> 128;
1013         if (absTick & 0x40000 != 0) ratio = (ratio * 0x2216e584f5fa1ea926041bedfe98) >> 128;
1014         if (absTick & 0x80000 != 0) ratio = (ratio * 0x48a170391f7dc42444e8fa2) >> 128;
1015 
1016         if (tick > 0) ratio = type(uint256).max / ratio;
1017 
1018         // this divides by 1<<32 rounding up to go from a Q128.128 to a Q128.96.
1019         // we then downcast because we know the result always fits within 160 bits due to our tick input constraint
1020         // we round up in the division so getTickAtSqrtRatio of the output price is always consistent
1021         sqrtPriceX96 = uint160((ratio >> 32) + (ratio % (1 << 32) == 0 ? 0 : 1));
1022     }
1023 
1024     /// @notice Calculates the greatest tick value such that getRatioAtTick(tick) <= ratio
1025     /// @dev Throws in case sqrtPriceX96 < MIN_SQRT_RATIO, as MIN_SQRT_RATIO is the lowest value getRatioAtTick may
1026     /// ever return.
1027     /// @param sqrtPriceX96 The sqrt ratio for which to compute the tick as a Q64.96
1028     /// @return tick The greatest tick for which the ratio is less than or equal to the input ratio
1029     function getTickAtSqrtRatio(uint160 sqrtPriceX96) internal pure returns (int24 tick) {
1030         // second inequality must be < because the price can never reach the price at the max tick
1031         require(sqrtPriceX96 >= MIN_SQRT_RATIO && sqrtPriceX96 < MAX_SQRT_RATIO, 'R');
1032         uint256 ratio = uint256(sqrtPriceX96) << 32;
1033 
1034         uint256 r = ratio;
1035         uint256 msb = 0;
1036 
1037         assembly {
1038             let f := shl(7, gt(r, 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF))
1039             msb := or(msb, f)
1040             r := shr(f, r)
1041         }
1042         assembly {
1043             let f := shl(6, gt(r, 0xFFFFFFFFFFFFFFFF))
1044             msb := or(msb, f)
1045             r := shr(f, r)
1046         }
1047         assembly {
1048             let f := shl(5, gt(r, 0xFFFFFFFF))
1049             msb := or(msb, f)
1050             r := shr(f, r)
1051         }
1052         assembly {
1053             let f := shl(4, gt(r, 0xFFFF))
1054             msb := or(msb, f)
1055             r := shr(f, r)
1056         }
1057         assembly {
1058             let f := shl(3, gt(r, 0xFF))
1059             msb := or(msb, f)
1060             r := shr(f, r)
1061         }
1062         assembly {
1063             let f := shl(2, gt(r, 0xF))
1064             msb := or(msb, f)
1065             r := shr(f, r)
1066         }
1067         assembly {
1068             let f := shl(1, gt(r, 0x3))
1069             msb := or(msb, f)
1070             r := shr(f, r)
1071         }
1072         assembly {
1073             let f := gt(r, 0x1)
1074             msb := or(msb, f)
1075         }
1076 
1077         if (msb >= 128) r = ratio >> (msb - 127);
1078         else r = ratio << (127 - msb);
1079 
1080         int256 log_2 = (int256(msb) - 128) << 64;
1081 
1082         assembly {
1083             r := shr(127, mul(r, r))
1084             let f := shr(128, r)
1085             log_2 := or(log_2, shl(63, f))
1086             r := shr(f, r)
1087         }
1088         assembly {
1089             r := shr(127, mul(r, r))
1090             let f := shr(128, r)
1091             log_2 := or(log_2, shl(62, f))
1092             r := shr(f, r)
1093         }
1094         assembly {
1095             r := shr(127, mul(r, r))
1096             let f := shr(128, r)
1097             log_2 := or(log_2, shl(61, f))
1098             r := shr(f, r)
1099         }
1100         assembly {
1101             r := shr(127, mul(r, r))
1102             let f := shr(128, r)
1103             log_2 := or(log_2, shl(60, f))
1104             r := shr(f, r)
1105         }
1106         assembly {
1107             r := shr(127, mul(r, r))
1108             let f := shr(128, r)
1109             log_2 := or(log_2, shl(59, f))
1110             r := shr(f, r)
1111         }
1112         assembly {
1113             r := shr(127, mul(r, r))
1114             let f := shr(128, r)
1115             log_2 := or(log_2, shl(58, f))
1116             r := shr(f, r)
1117         }
1118         assembly {
1119             r := shr(127, mul(r, r))
1120             let f := shr(128, r)
1121             log_2 := or(log_2, shl(57, f))
1122             r := shr(f, r)
1123         }
1124         assembly {
1125             r := shr(127, mul(r, r))
1126             let f := shr(128, r)
1127             log_2 := or(log_2, shl(56, f))
1128             r := shr(f, r)
1129         }
1130         assembly {
1131             r := shr(127, mul(r, r))
1132             let f := shr(128, r)
1133             log_2 := or(log_2, shl(55, f))
1134             r := shr(f, r)
1135         }
1136         assembly {
1137             r := shr(127, mul(r, r))
1138             let f := shr(128, r)
1139             log_2 := or(log_2, shl(54, f))
1140             r := shr(f, r)
1141         }
1142         assembly {
1143             r := shr(127, mul(r, r))
1144             let f := shr(128, r)
1145             log_2 := or(log_2, shl(53, f))
1146             r := shr(f, r)
1147         }
1148         assembly {
1149             r := shr(127, mul(r, r))
1150             let f := shr(128, r)
1151             log_2 := or(log_2, shl(52, f))
1152             r := shr(f, r)
1153         }
1154         assembly {
1155             r := shr(127, mul(r, r))
1156             let f := shr(128, r)
1157             log_2 := or(log_2, shl(51, f))
1158             r := shr(f, r)
1159         }
1160         assembly {
1161             r := shr(127, mul(r, r))
1162             let f := shr(128, r)
1163             log_2 := or(log_2, shl(50, f))
1164         }
1165 
1166         int256 log_sqrt10001 = log_2 * 255738958999603826347141; // 128.128 number
1167 
1168         int24 tickLow = int24((log_sqrt10001 - 3402992956809132418596140100660247210) >> 128);
1169         int24 tickHi = int24((log_sqrt10001 + 291339464771989622907027621153398088495) >> 128);
1170 
1171         tick = tickLow == tickHi ? tickLow : getSqrtRatioAtTick(tickHi) <= sqrtPriceX96 ? tickHi : tickLow;
1172     }
1173 }
1174 
1175 // File: @uniswap/v3-core/contracts/libraries/FullMath.sol
1176 
1177 // License-Identifier: MIT
1178 
1179 pragma solidity >=0.4.0;
1180 
1181 /// @title Contains 512-bit math functions
1182 /// @notice Facilitates multiplication and division that can have overflow of an intermediate value without any loss of precision
1183 /// @dev Handles "phantom overflow" i.e., allows multiplication and division where an intermediate value overflows 256 bits
1184 library FullMath {
1185     /// @notice Calculates floor(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1186     /// @param a The multiplicand
1187     /// @param b The multiplier
1188     /// @param denominator The divisor
1189     /// @return result The 256-bit result
1190     /// @dev Credit to Remco Bloemen under MIT license https://xn--2-umb.com/21/muldiv
1191     function mulDiv(
1192         uint256 a,
1193         uint256 b,
1194         uint256 denominator
1195     ) internal pure returns (uint256 result) {
1196         // 512-bit multiply [prod1 prod0] = a * b
1197         // Compute the product mod 2**256 and mod 2**256 - 1
1198         // then use the Chinese Remainder Theorem to reconstruct
1199         // the 512 bit result. The result is stored in two 256
1200         // variables such that product = prod1 * 2**256 + prod0
1201         uint256 prod0; // Least significant 256 bits of the product
1202         uint256 prod1; // Most significant 256 bits of the product
1203         assembly {
1204             let mm := mulmod(a, b, not(0))
1205             prod0 := mul(a, b)
1206             prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1207         }
1208 
1209         // Handle non-overflow cases, 256 by 256 division
1210         if (prod1 == 0) {
1211             require(denominator > 0);
1212             assembly {
1213                 result := div(prod0, denominator)
1214             }
1215             return result;
1216         }
1217 
1218         // Make sure the result is less than 2**256.
1219         // Also prevents denominator == 0
1220         require(denominator > prod1);
1221 
1222         ///////////////////////////////////////////////
1223         // 512 by 256 division.
1224         ///////////////////////////////////////////////
1225 
1226         // Make division exact by subtracting the remainder from [prod1 prod0]
1227         // Compute remainder using mulmod
1228         uint256 remainder;
1229         assembly {
1230             remainder := mulmod(a, b, denominator)
1231         }
1232         // Subtract 256 bit number from 512 bit number
1233         assembly {
1234             prod1 := sub(prod1, gt(remainder, prod0))
1235             prod0 := sub(prod0, remainder)
1236         }
1237 
1238         // Factor powers of two out of denominator
1239         // Compute largest power of two divisor of denominator.
1240         // Always >= 1.
1241         uint256 twos = -denominator & denominator;
1242         // Divide denominator by power of two
1243         assembly {
1244             denominator := div(denominator, twos)
1245         }
1246 
1247         // Divide [prod1 prod0] by the factors of two
1248         assembly {
1249             prod0 := div(prod0, twos)
1250         }
1251         // Shift in bits from prod1 into prod0. For this we need
1252         // to flip `twos` such that it is 2**256 / twos.
1253         // If twos is zero, then it becomes one
1254         assembly {
1255             twos := add(div(sub(0, twos), twos), 1)
1256         }
1257         prod0 |= prod1 * twos;
1258 
1259         // Invert denominator mod 2**256
1260         // Now that denominator is an odd number, it has an inverse
1261         // modulo 2**256 such that denominator * inv = 1 mod 2**256.
1262         // Compute the inverse by starting with a seed that is correct
1263         // correct for four bits. That is, denominator * inv = 1 mod 2**4
1264         uint256 inv = (3 * denominator) ^ 2;
1265         // Now use Newton-Raphson iteration to improve the precision.
1266         // Thanks to Hensel's lifting lemma, this also works in modular
1267         // arithmetic, doubling the correct bits in each step.
1268         inv *= 2 - denominator * inv; // inverse mod 2**8
1269         inv *= 2 - denominator * inv; // inverse mod 2**16
1270         inv *= 2 - denominator * inv; // inverse mod 2**32
1271         inv *= 2 - denominator * inv; // inverse mod 2**64
1272         inv *= 2 - denominator * inv; // inverse mod 2**128
1273         inv *= 2 - denominator * inv; // inverse mod 2**256
1274 
1275         // Because the division is now exact we can divide by multiplying
1276         // with the modular inverse of denominator. This will give us the
1277         // correct result modulo 2**256. Since the precoditions guarantee
1278         // that the outcome is less than 2**256, this is the final result.
1279         // We don't need to compute the high bits of the result and prod1
1280         // is no longer required.
1281         result = prod0 * inv;
1282         return result;
1283     }
1284 
1285     /// @notice Calculates ceil(a×b÷denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1286     /// @param a The multiplicand
1287     /// @param b The multiplier
1288     /// @param denominator The divisor
1289     /// @return result The 256-bit result
1290     function mulDivRoundingUp(
1291         uint256 a,
1292         uint256 b,
1293         uint256 denominator
1294     ) internal pure returns (uint256 result) {
1295         result = mulDiv(a, b, denominator);
1296         if (mulmod(a, b, denominator) > 0) {
1297             require(result < type(uint256).max);
1298             result++;
1299         }
1300     }
1301 }
1302 
1303 // File: @uniswap/v3-core/contracts/libraries/FixedPoint96.sol
1304 
1305 // License-Identifier: GPL-2.0-or-later
1306 
1307 pragma solidity >=0.4.0;
1308 
1309 /// @title FixedPoint96
1310 /// @notice A library for handling binary fixed point numbers, see https://en.wikipedia.org/wiki/Q_(number_format)
1311 /// @dev Used in SqrtPriceMath.sol
1312 library FixedPoint96 {
1313     uint8 internal constant RESOLUTION = 96;
1314     uint256 internal constant Q96 = 0x1000000000000000000000000;
1315 }
1316 
1317 // File: @uniswap/v3-periphery/contracts/libraries/LiquidityAmounts.sol
1318 
1319 // License-Identifier: GPL-2.0-or-later
1320 
1321 pragma solidity >=0.5.0;
1322 
1323 /// @title Liquidity amount functions
1324 /// @notice Provides functions for computing liquidity amounts from token amounts and prices
1325 library LiquidityAmounts {
1326     /// @notice Downcasts uint256 to uint128
1327     /// @param x The uint258 to be downcasted
1328     /// @return y The passed value, downcasted to uint128
1329     function toUint128(uint256 x) private pure returns (uint128 y) {
1330         require((y = uint128(x)) == x);
1331     }
1332 
1333     /// @notice Computes the amount of liquidity received for a given amount of token0 and price range
1334     /// @dev Calculates amount0 * (sqrt(upper) * sqrt(lower)) / (sqrt(upper) - sqrt(lower))
1335     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1336     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1337     /// @param amount0 The amount0 being sent in
1338     /// @return liquidity The amount of returned liquidity
1339     function getLiquidityForAmount0(
1340         uint160 sqrtRatioAX96,
1341         uint160 sqrtRatioBX96,
1342         uint256 amount0
1343     ) internal pure returns (uint128 liquidity) {
1344         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1345         uint256 intermediate = FullMath.mulDiv(sqrtRatioAX96, sqrtRatioBX96, FixedPoint96.Q96);
1346         return toUint128(FullMath.mulDiv(amount0, intermediate, sqrtRatioBX96 - sqrtRatioAX96));
1347     }
1348 
1349     /// @notice Computes the amount of liquidity received for a given amount of token1 and price range
1350     /// @dev Calculates amount1 / (sqrt(upper) - sqrt(lower)).
1351     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1352     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1353     /// @param amount1 The amount1 being sent in
1354     /// @return liquidity The amount of returned liquidity
1355     function getLiquidityForAmount1(
1356         uint160 sqrtRatioAX96,
1357         uint160 sqrtRatioBX96,
1358         uint256 amount1
1359     ) internal pure returns (uint128 liquidity) {
1360         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1361         return toUint128(FullMath.mulDiv(amount1, FixedPoint96.Q96, sqrtRatioBX96 - sqrtRatioAX96));
1362     }
1363 
1364     /// @notice Computes the maximum amount of liquidity received for a given amount of token0, token1, the current
1365     /// pool prices and the prices at the tick boundaries
1366     /// @param sqrtRatioX96 A sqrt price representing the current pool prices
1367     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1368     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1369     /// @param amount0 The amount of token0 being sent in
1370     /// @param amount1 The amount of token1 being sent in
1371     /// @return liquidity The maximum amount of liquidity received
1372     function getLiquidityForAmounts(
1373         uint160 sqrtRatioX96,
1374         uint160 sqrtRatioAX96,
1375         uint160 sqrtRatioBX96,
1376         uint256 amount0,
1377         uint256 amount1
1378     ) internal pure returns (uint128 liquidity) {
1379         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1380 
1381         if (sqrtRatioX96 <= sqrtRatioAX96) {
1382             liquidity = getLiquidityForAmount0(sqrtRatioAX96, sqrtRatioBX96, amount0);
1383         } else if (sqrtRatioX96 < sqrtRatioBX96) {
1384             uint128 liquidity0 = getLiquidityForAmount0(sqrtRatioX96, sqrtRatioBX96, amount0);
1385             uint128 liquidity1 = getLiquidityForAmount1(sqrtRatioAX96, sqrtRatioX96, amount1);
1386 
1387             liquidity = liquidity0 < liquidity1 ? liquidity0 : liquidity1;
1388         } else {
1389             liquidity = getLiquidityForAmount1(sqrtRatioAX96, sqrtRatioBX96, amount1);
1390         }
1391     }
1392 
1393     /// @notice Computes the amount of token0 for a given amount of liquidity and a price range
1394     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1395     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1396     /// @param liquidity The liquidity being valued
1397     /// @return amount0 The amount of token0
1398     function getAmount0ForLiquidity(
1399         uint160 sqrtRatioAX96,
1400         uint160 sqrtRatioBX96,
1401         uint128 liquidity
1402     ) internal pure returns (uint256 amount0) {
1403         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1404 
1405         return
1406             FullMath.mulDiv(
1407                 uint256(liquidity) << FixedPoint96.RESOLUTION,
1408                 sqrtRatioBX96 - sqrtRatioAX96,
1409                 sqrtRatioBX96
1410             ) / sqrtRatioAX96;
1411     }
1412 
1413     /// @notice Computes the amount of token1 for a given amount of liquidity and a price range
1414     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1415     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1416     /// @param liquidity The liquidity being valued
1417     /// @return amount1 The amount of token1
1418     function getAmount1ForLiquidity(
1419         uint160 sqrtRatioAX96,
1420         uint160 sqrtRatioBX96,
1421         uint128 liquidity
1422     ) internal pure returns (uint256 amount1) {
1423         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1424 
1425         return FullMath.mulDiv(liquidity, sqrtRatioBX96 - sqrtRatioAX96, FixedPoint96.Q96);
1426     }
1427 
1428     /// @notice Computes the token0 and token1 value for a given amount of liquidity, the current
1429     /// pool prices and the prices at the tick boundaries
1430     /// @param sqrtRatioX96 A sqrt price representing the current pool prices
1431     /// @param sqrtRatioAX96 A sqrt price representing the first tick boundary
1432     /// @param sqrtRatioBX96 A sqrt price representing the second tick boundary
1433     /// @param liquidity The liquidity being valued
1434     /// @return amount0 The amount of token0
1435     /// @return amount1 The amount of token1
1436     function getAmountsForLiquidity(
1437         uint160 sqrtRatioX96,
1438         uint160 sqrtRatioAX96,
1439         uint160 sqrtRatioBX96,
1440         uint128 liquidity
1441     ) internal pure returns (uint256 amount0, uint256 amount1) {
1442         if (sqrtRatioAX96 > sqrtRatioBX96) (sqrtRatioAX96, sqrtRatioBX96) = (sqrtRatioBX96, sqrtRatioAX96);
1443 
1444         if (sqrtRatioX96 <= sqrtRatioAX96) {
1445             amount0 = getAmount0ForLiquidity(sqrtRatioAX96, sqrtRatioBX96, liquidity);
1446         } else if (sqrtRatioX96 < sqrtRatioBX96) {
1447             amount0 = getAmount0ForLiquidity(sqrtRatioX96, sqrtRatioBX96, liquidity);
1448             amount1 = getAmount1ForLiquidity(sqrtRatioAX96, sqrtRatioX96, liquidity);
1449         } else {
1450             amount1 = getAmount1ForLiquidity(sqrtRatioAX96, sqrtRatioBX96, liquidity);
1451         }
1452     }
1453 }
1454 
1455 // File: @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolImmutables.sol
1456 
1457 // License-Identifier: GPL-2.0-or-later
1458 
1459 pragma solidity >=0.5.0;
1460 
1461 /// @title Pool state that never changes
1462 /// @notice These parameters are fixed for a pool forever, i.e., the methods will always return the same values
1463 interface IUniswapV3PoolImmutables {
1464     /// @notice The contract that deployed the pool, which must adhere to the IUniswapV3Factory interface
1465     /// @return The contract address
1466     function factory() external view returns (address);
1467 
1468     /// @notice The first of the two tokens of the pool, sorted by address
1469     /// @return The token contract address
1470     function token0() external view returns (address);
1471 
1472     /// @notice The second of the two tokens of the pool, sorted by address
1473     /// @return The token contract address
1474     function token1() external view returns (address);
1475 
1476     /// @notice The pool's fee in hundredths of a bip, i.e. 1e-6
1477     /// @return The fee
1478     function fee() external view returns (uint24);
1479 
1480     /// @notice The pool tick spacing
1481     /// @dev Ticks can only be used at multiples of this value, minimum of 1 and always positive
1482     /// e.g.: a tickSpacing of 3 means ticks can be initialized every 3rd tick, i.e., ..., -6, -3, 0, 3, 6, ...
1483     /// This value is an int24 to avoid casting even though it is always positive.
1484     /// @return The tick spacing
1485     function tickSpacing() external view returns (int24);
1486 
1487     /// @notice The maximum amount of position liquidity that can use any tick in the range
1488     /// @dev This parameter is enforced per tick to prevent liquidity from overflowing a uint128 at any point, and
1489     /// also prevents out-of-range liquidity from being used to prevent adding in-range liquidity to a pool
1490     /// @return The max amount of liquidity per tick
1491     function maxLiquidityPerTick() external view returns (uint128);
1492 }
1493 
1494 // File: @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolState.sol
1495 
1496 // License-Identifier: GPL-2.0-or-later
1497 
1498 pragma solidity >=0.5.0;
1499 
1500 /// @title Pool state that can change
1501 /// @notice These methods compose the pool's state, and can change with any frequency including multiple times
1502 /// per transaction
1503 interface IUniswapV3PoolState {
1504     /// @notice The 0th storage slot in the pool stores many values, and is exposed as a single method to save gas
1505     /// when accessed externally.
1506     /// @return sqrtPriceX96 The current price of the pool as a sqrt(token1/token0) Q64.96 value
1507     /// tick The current tick of the pool, i.e. according to the last tick transition that was run.
1508     /// This value may not always be equal to SqrtTickMath.getTickAtSqrtRatio(sqrtPriceX96) if the price is on a tick
1509     /// boundary.
1510     /// observationIndex The index of the last oracle observation that was written,
1511     /// observationCardinality The current maximum number of observations stored in the pool,
1512     /// observationCardinalityNext The next maximum number of observations, to be updated when the observation.
1513     /// feeProtocol The protocol fee for both tokens of the pool.
1514     /// Encoded as two 4 bit values, where the protocol fee of token1 is shifted 4 bits and the protocol fee of token0
1515     /// is the lower 4 bits. Used as the denominator of a fraction of the swap fee, e.g. 4 means 1/4th of the swap fee.
1516     /// unlocked Whether the pool is currently locked to reentrancy
1517     function slot0()
1518         external
1519         view
1520         returns (
1521             uint160 sqrtPriceX96,
1522             int24 tick,
1523             uint16 observationIndex,
1524             uint16 observationCardinality,
1525             uint16 observationCardinalityNext,
1526             uint8 feeProtocol,
1527             bool unlocked
1528         );
1529 
1530     /// @notice The fee growth as a Q128.128 fees of token0 collected per unit of liquidity for the entire life of the pool
1531     /// @dev This value can overflow the uint256
1532     function feeGrowthGlobal0X128() external view returns (uint256);
1533 
1534     /// @notice The fee growth as a Q128.128 fees of token1 collected per unit of liquidity for the entire life of the pool
1535     /// @dev This value can overflow the uint256
1536     function feeGrowthGlobal1X128() external view returns (uint256);
1537 
1538     /// @notice The amounts of token0 and token1 that are owed to the protocol
1539     /// @dev Protocol fees will never exceed uint128 max in either token
1540     function protocolFees() external view returns (uint128 token0, uint128 token1);
1541 
1542     /// @notice The currently in range liquidity available to the pool
1543     /// @dev This value has no relationship to the total liquidity across all ticks
1544     function liquidity() external view returns (uint128);
1545 
1546     /// @notice Look up information about a specific tick in the pool
1547     /// @param tick The tick to look up
1548     /// @return liquidityGross the total amount of position liquidity that uses the pool either as tick lower or
1549     /// tick upper,
1550     /// liquidityNet how much liquidity changes when the pool price crosses the tick,
1551     /// feeGrowthOutside0X128 the fee growth on the other side of the tick from the current tick in token0,
1552     /// feeGrowthOutside1X128 the fee growth on the other side of the tick from the current tick in token1,
1553     /// tickCumulativeOutside the cumulative tick value on the other side of the tick from the current tick
1554     /// secondsPerLiquidityOutsideX128 the seconds spent per liquidity on the other side of the tick from the current tick,
1555     /// secondsOutside the seconds spent on the other side of the tick from the current tick,
1556     /// initialized Set to true if the tick is initialized, i.e. liquidityGross is greater than 0, otherwise equal to false.
1557     /// Outside values can only be used if the tick is initialized, i.e. if liquidityGross is greater than 0.
1558     /// In addition, these values are only relative and must be used only in comparison to previous snapshots for
1559     /// a specific position.
1560     function ticks(int24 tick)
1561         external
1562         view
1563         returns (
1564             uint128 liquidityGross,
1565             int128 liquidityNet,
1566             uint256 feeGrowthOutside0X128,
1567             uint256 feeGrowthOutside1X128,
1568             int56 tickCumulativeOutside,
1569             uint160 secondsPerLiquidityOutsideX128,
1570             uint32 secondsOutside,
1571             bool initialized
1572         );
1573 
1574     /// @notice Returns 256 packed tick initialized boolean values. See TickBitmap for more information
1575     function tickBitmap(int16 wordPosition) external view returns (uint256);
1576 
1577     /// @notice Returns the information about a position by the position's key
1578     /// @param key The position's key is a hash of a preimage composed by the owner, tickLower and tickUpper
1579     /// @return _liquidity The amount of liquidity in the position,
1580     /// Returns feeGrowthInside0LastX128 fee growth of token0 inside the tick range as of the last mint/burn/poke,
1581     /// Returns feeGrowthInside1LastX128 fee growth of token1 inside the tick range as of the last mint/burn/poke,
1582     /// Returns tokensOwed0 the computed amount of token0 owed to the position as of the last mint/burn/poke,
1583     /// Returns tokensOwed1 the computed amount of token1 owed to the position as of the last mint/burn/poke
1584     function positions(bytes32 key)
1585         external
1586         view
1587         returns (
1588             uint128 _liquidity,
1589             uint256 feeGrowthInside0LastX128,
1590             uint256 feeGrowthInside1LastX128,
1591             uint128 tokensOwed0,
1592             uint128 tokensOwed1
1593         );
1594 
1595     /// @notice Returns data about a specific observation index
1596     /// @param index The element of the observations array to fetch
1597     /// @dev You most likely want to use #observe() instead of this method to get an observation as of some amount of time
1598     /// ago, rather than at a specific index in the array.
1599     /// @return blockTimestamp The timestamp of the observation,
1600     /// Returns tickCumulative the tick multiplied by seconds elapsed for the life of the pool as of the observation timestamp,
1601     /// Returns secondsPerLiquidityCumulativeX128 the seconds per in range liquidity for the life of the pool as of the observation timestamp,
1602     /// Returns initialized whether the observation has been initialized and the values are safe to use
1603     function observations(uint256 index)
1604         external
1605         view
1606         returns (
1607             uint32 blockTimestamp,
1608             int56 tickCumulative,
1609             uint160 secondsPerLiquidityCumulativeX128,
1610             bool initialized
1611         );
1612 }
1613 
1614 // File: @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolDerivedState.sol
1615 
1616 // License-Identifier: GPL-2.0-or-later
1617 
1618 pragma solidity >=0.5.0;
1619 
1620 /// @title Pool state that is not stored
1621 /// @notice Contains view functions to provide information about the pool that is computed rather than stored on the
1622 /// blockchain. The functions here may have variable gas costs.
1623 interface IUniswapV3PoolDerivedState {
1624     /// @notice Returns the cumulative tick and liquidity as of each timestamp `secondsAgo` from the current block timestamp
1625     /// @dev To get a time weighted average tick or liquidity-in-range, you must call this with two values, one representing
1626     /// the beginning of the period and another for the end of the period. E.g., to get the last hour time-weighted average tick,
1627     /// you must call it with secondsAgos = [3600, 0].
1628     /// @dev The time weighted average tick represents the geometric time weighted average price of the pool, in
1629     /// log base sqrt(1.0001) of token1 / token0. The TickMath library can be used to go from a tick value to a ratio.
1630     /// @param secondsAgos From how long ago each cumulative tick and liquidity value should be returned
1631     /// @return tickCumulatives Cumulative tick values as of each `secondsAgos` from the current block timestamp
1632     /// @return secondsPerLiquidityCumulativeX128s Cumulative seconds per liquidity-in-range value as of each `secondsAgos` from the current block
1633     /// timestamp
1634     function observe(uint32[] calldata secondsAgos)
1635         external
1636         view
1637         returns (int56[] memory tickCumulatives, uint160[] memory secondsPerLiquidityCumulativeX128s);
1638 
1639     /// @notice Returns a snapshot of the tick cumulative, seconds per liquidity and seconds inside a tick range
1640     /// @dev Snapshots must only be compared to other snapshots, taken over a period for which a position existed.
1641     /// I.e., snapshots cannot be compared if a position is not held for the entire period between when the first
1642     /// snapshot is taken and the second snapshot is taken.
1643     /// @param tickLower The lower tick of the range
1644     /// @param tickUpper The upper tick of the range
1645     /// @return tickCumulativeInside The snapshot of the tick accumulator for the range
1646     /// @return secondsPerLiquidityInsideX128 The snapshot of seconds per liquidity for the range
1647     /// @return secondsInside The snapshot of seconds per liquidity for the range
1648     function snapshotCumulativesInside(int24 tickLower, int24 tickUpper)
1649         external
1650         view
1651         returns (
1652             int56 tickCumulativeInside,
1653             uint160 secondsPerLiquidityInsideX128,
1654             uint32 secondsInside
1655         );
1656 }
1657 
1658 // File: @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolActions.sol
1659 
1660 // License-Identifier: GPL-2.0-or-later
1661 
1662 pragma solidity >=0.5.0;
1663 
1664 /// @title Permissionless pool actions
1665 /// @notice Contains pool methods that can be called by anyone
1666 interface IUniswapV3PoolActions {
1667     /// @notice Sets the initial price for the pool
1668     /// @dev Price is represented as a sqrt(amountToken1/amountToken0) Q64.96 value
1669     /// @param sqrtPriceX96 the initial sqrt price of the pool as a Q64.96
1670     function initialize(uint160 sqrtPriceX96) external;
1671 
1672     /// @notice Adds liquidity for the given recipient/tickLower/tickUpper position
1673     /// @dev The caller of this method receives a callback in the form of IUniswapV3MintCallback#uniswapV3MintCallback
1674     /// in which they must pay any token0 or token1 owed for the liquidity. The amount of token0/token1 due depends
1675     /// on tickLower, tickUpper, the amount of liquidity, and the current price.
1676     /// @param recipient The address for which the liquidity will be created
1677     /// @param tickLower The lower tick of the position in which to add liquidity
1678     /// @param tickUpper The upper tick of the position in which to add liquidity
1679     /// @param amount The amount of liquidity to mint
1680     /// @param data Any data that should be passed through to the callback
1681     /// @return amount0 The amount of token0 that was paid to mint the given amount of liquidity. Matches the value in the callback
1682     /// @return amount1 The amount of token1 that was paid to mint the given amount of liquidity. Matches the value in the callback
1683     function mint(
1684         address recipient,
1685         int24 tickLower,
1686         int24 tickUpper,
1687         uint128 amount,
1688         bytes calldata data
1689     ) external returns (uint256 amount0, uint256 amount1);
1690 
1691     /// @notice Collects tokens owed to a position
1692     /// @dev Does not recompute fees earned, which must be done either via mint or burn of any amount of liquidity.
1693     /// Collect must be called by the position owner. To withdraw only token0 or only token1, amount0Requested or
1694     /// amount1Requested may be set to zero. To withdraw all tokens owed, caller may pass any value greater than the
1695     /// actual tokens owed, e.g. type(uint128).max. Tokens owed may be from accumulated swap fees or burned liquidity.
1696     /// @param recipient The address which should receive the fees collected
1697     /// @param tickLower The lower tick of the position for which to collect fees
1698     /// @param tickUpper The upper tick of the position for which to collect fees
1699     /// @param amount0Requested How much token0 should be withdrawn from the fees owed
1700     /// @param amount1Requested How much token1 should be withdrawn from the fees owed
1701     /// @return amount0 The amount of fees collected in token0
1702     /// @return amount1 The amount of fees collected in token1
1703     function collect(
1704         address recipient,
1705         int24 tickLower,
1706         int24 tickUpper,
1707         uint128 amount0Requested,
1708         uint128 amount1Requested
1709     ) external returns (uint128 amount0, uint128 amount1);
1710 
1711     /// @notice Burn liquidity from the sender and account tokens owed for the liquidity to the position
1712     /// @dev Can be used to trigger a recalculation of fees owed to a position by calling with an amount of 0
1713     /// @dev Fees must be collected separately via a call to #collect
1714     /// @param tickLower The lower tick of the position for which to burn liquidity
1715     /// @param tickUpper The upper tick of the position for which to burn liquidity
1716     /// @param amount How much liquidity to burn
1717     /// @return amount0 The amount of token0 sent to the recipient
1718     /// @return amount1 The amount of token1 sent to the recipient
1719     function burn(
1720         int24 tickLower,
1721         int24 tickUpper,
1722         uint128 amount
1723     ) external returns (uint256 amount0, uint256 amount1);
1724 
1725     /// @notice Swap token0 for token1, or token1 for token0
1726     /// @dev The caller of this method receives a callback in the form of IUniswapV3SwapCallback#uniswapV3SwapCallback
1727     /// @param recipient The address to receive the output of the swap
1728     /// @param zeroForOne The direction of the swap, true for token0 to token1, false for token1 to token0
1729     /// @param amountSpecified The amount of the swap, which implicitly configures the swap as exact input (positive), or exact output (negative)
1730     /// @param sqrtPriceLimitX96 The Q64.96 sqrt price limit. If zero for one, the price cannot be less than this
1731     /// value after the swap. If one for zero, the price cannot be greater than this value after the swap
1732     /// @param data Any data to be passed through to the callback
1733     /// @return amount0 The delta of the balance of token0 of the pool, exact when negative, minimum when positive
1734     /// @return amount1 The delta of the balance of token1 of the pool, exact when negative, minimum when positive
1735     function swap(
1736         address recipient,
1737         bool zeroForOne,
1738         int256 amountSpecified,
1739         uint160 sqrtPriceLimitX96,
1740         bytes calldata data
1741     ) external returns (int256 amount0, int256 amount1);
1742 
1743     /// @notice Receive token0 and/or token1 and pay it back, plus a fee, in the callback
1744     /// @dev The caller of this method receives a callback in the form of IUniswapV3FlashCallback#uniswapV3FlashCallback
1745     /// @dev Can be used to donate underlying tokens pro-rata to currently in-range liquidity providers by calling
1746     /// with 0 amount{0,1} and sending the donation amount(s) from the callback
1747     /// @param recipient The address which will receive the token0 and token1 amounts
1748     /// @param amount0 The amount of token0 to send
1749     /// @param amount1 The amount of token1 to send
1750     /// @param data Any data to be passed through to the callback
1751     function flash(
1752         address recipient,
1753         uint256 amount0,
1754         uint256 amount1,
1755         bytes calldata data
1756     ) external;
1757 
1758     /// @notice Increase the maximum number of price and liquidity observations that this pool will store
1759     /// @dev This method is no-op if the pool already has an observationCardinalityNext greater than or equal to
1760     /// the input observationCardinalityNext.
1761     /// @param observationCardinalityNext The desired minimum number of observations for the pool to store
1762     function increaseObservationCardinalityNext(uint16 observationCardinalityNext) external;
1763 }
1764 
1765 // File: @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolOwnerActions.sol
1766 
1767 // License-Identifier: GPL-2.0-or-later
1768 
1769 pragma solidity >=0.5.0;
1770 
1771 /// @title Permissioned pool actions
1772 /// @notice Contains pool methods that may only be called by the factory owner
1773 interface IUniswapV3PoolOwnerActions {
1774     /// @notice Set the denominator of the protocol's % share of the fees
1775     /// @param feeProtocol0 new protocol fee for token0 of the pool
1776     /// @param feeProtocol1 new protocol fee for token1 of the pool
1777     function setFeeProtocol(uint8 feeProtocol0, uint8 feeProtocol1) external;
1778 
1779     /// @notice Collect the protocol fee accrued to the pool
1780     /// @param recipient The address to which collected protocol fees should be sent
1781     /// @param amount0Requested The maximum amount of token0 to send, can be 0 to collect fees in only token1
1782     /// @param amount1Requested The maximum amount of token1 to send, can be 0 to collect fees in only token0
1783     /// @return amount0 The protocol fee collected in token0
1784     /// @return amount1 The protocol fee collected in token1
1785     function collectProtocol(
1786         address recipient,
1787         uint128 amount0Requested,
1788         uint128 amount1Requested
1789     ) external returns (uint128 amount0, uint128 amount1);
1790 }
1791 
1792 // File: @uniswap/v3-core/contracts/interfaces/pool/IUniswapV3PoolEvents.sol
1793 
1794 // License-Identifier: GPL-2.0-or-later
1795 
1796 pragma solidity >=0.5.0;
1797 
1798 /// @title Events emitted by a pool
1799 /// @notice Contains all events emitted by the pool
1800 interface IUniswapV3PoolEvents {
1801     /// @notice Emitted exactly once by a pool when #initialize is first called on the pool
1802     /// @dev Mint/Burn/Swap cannot be emitted by the pool before Initialize
1803     /// @param sqrtPriceX96 The initial sqrt price of the pool, as a Q64.96
1804     /// @param tick The initial tick of the pool, i.e. log base 1.0001 of the starting price of the pool
1805     event Initialize(uint160 sqrtPriceX96, int24 tick);
1806 
1807     /// @notice Emitted when liquidity is minted for a given position
1808     /// @param sender The address that minted the liquidity
1809     /// @param owner The owner of the position and recipient of any minted liquidity
1810     /// @param tickLower The lower tick of the position
1811     /// @param tickUpper The upper tick of the position
1812     /// @param amount The amount of liquidity minted to the position range
1813     /// @param amount0 How much token0 was required for the minted liquidity
1814     /// @param amount1 How much token1 was required for the minted liquidity
1815     event Mint(
1816         address sender,
1817         address indexed owner,
1818         int24 indexed tickLower,
1819         int24 indexed tickUpper,
1820         uint128 amount,
1821         uint256 amount0,
1822         uint256 amount1
1823     );
1824 
1825     /// @notice Emitted when fees are collected by the owner of a position
1826     /// @dev Collect events may be emitted with zero amount0 and amount1 when the caller chooses not to collect fees
1827     /// @param owner The owner of the position for which fees are collected
1828     /// @param tickLower The lower tick of the position
1829     /// @param tickUpper The upper tick of the position
1830     /// @param amount0 The amount of token0 fees collected
1831     /// @param amount1 The amount of token1 fees collected
1832     event Collect(
1833         address indexed owner,
1834         address recipient,
1835         int24 indexed tickLower,
1836         int24 indexed tickUpper,
1837         uint128 amount0,
1838         uint128 amount1
1839     );
1840 
1841     /// @notice Emitted when a position's liquidity is removed
1842     /// @dev Does not withdraw any fees earned by the liquidity position, which must be withdrawn via #collect
1843     /// @param owner The owner of the position for which liquidity is removed
1844     /// @param tickLower The lower tick of the position
1845     /// @param tickUpper The upper tick of the position
1846     /// @param amount The amount of liquidity to remove
1847     /// @param amount0 The amount of token0 withdrawn
1848     /// @param amount1 The amount of token1 withdrawn
1849     event Burn(
1850         address indexed owner,
1851         int24 indexed tickLower,
1852         int24 indexed tickUpper,
1853         uint128 amount,
1854         uint256 amount0,
1855         uint256 amount1
1856     );
1857 
1858     /// @notice Emitted by the pool for any swaps between token0 and token1
1859     /// @param sender The address that initiated the swap call, and that received the callback
1860     /// @param recipient The address that received the output of the swap
1861     /// @param amount0 The delta of the token0 balance of the pool
1862     /// @param amount1 The delta of the token1 balance of the pool
1863     /// @param sqrtPriceX96 The sqrt(price) of the pool after the swap, as a Q64.96
1864     /// @param liquidity The liquidity of the pool after the swap
1865     /// @param tick The log base 1.0001 of price of the pool after the swap
1866     event Swap(
1867         address indexed sender,
1868         address indexed recipient,
1869         int256 amount0,
1870         int256 amount1,
1871         uint160 sqrtPriceX96,
1872         uint128 liquidity,
1873         int24 tick
1874     );
1875 
1876     /// @notice Emitted by the pool for any flashes of token0/token1
1877     /// @param sender The address that initiated the swap call, and that received the callback
1878     /// @param recipient The address that received the tokens from flash
1879     /// @param amount0 The amount of token0 that was flashed
1880     /// @param amount1 The amount of token1 that was flashed
1881     /// @param paid0 The amount of token0 paid for the flash, which can exceed the amount0 plus the fee
1882     /// @param paid1 The amount of token1 paid for the flash, which can exceed the amount1 plus the fee
1883     event Flash(
1884         address indexed sender,
1885         address indexed recipient,
1886         uint256 amount0,
1887         uint256 amount1,
1888         uint256 paid0,
1889         uint256 paid1
1890     );
1891 
1892     /// @notice Emitted by the pool for increases to the number of observations that can be stored
1893     /// @dev observationCardinalityNext is not the observation cardinality until an observation is written at the index
1894     /// just before a mint/swap/burn.
1895     /// @param observationCardinalityNextOld The previous value of the next observation cardinality
1896     /// @param observationCardinalityNextNew The updated value of the next observation cardinality
1897     event IncreaseObservationCardinalityNext(
1898         uint16 observationCardinalityNextOld,
1899         uint16 observationCardinalityNextNew
1900     );
1901 
1902     /// @notice Emitted when the protocol fee is changed by the pool
1903     /// @param feeProtocol0Old The previous value of the token0 protocol fee
1904     /// @param feeProtocol1Old The previous value of the token1 protocol fee
1905     /// @param feeProtocol0New The updated value of the token0 protocol fee
1906     /// @param feeProtocol1New The updated value of the token1 protocol fee
1907     event SetFeeProtocol(uint8 feeProtocol0Old, uint8 feeProtocol1Old, uint8 feeProtocol0New, uint8 feeProtocol1New);
1908 
1909     /// @notice Emitted when the collected protocol fees are withdrawn by the factory owner
1910     /// @param sender The address that collects the protocol fees
1911     /// @param recipient The address that receives the collected protocol fees
1912     /// @param amount0 The amount of token0 protocol fees that is withdrawn
1913     /// @param amount0 The amount of token1 protocol fees that is withdrawn
1914     event CollectProtocol(address indexed sender, address indexed recipient, uint128 amount0, uint128 amount1);
1915 }
1916 
1917 // File: @uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol
1918 
1919 // License-Identifier: GPL-2.0-or-later
1920 
1921 pragma solidity >=0.5.0;
1922 
1923 /// @title The interface for a Uniswap V3 Pool
1924 /// @notice A Uniswap pool facilitates swapping and automated market making between any two assets that strictly conform
1925 /// to the ERC20 specification
1926 /// @dev The pool interface is broken up into many smaller pieces
1927 interface IUniswapV3Pool is
1928     IUniswapV3PoolImmutables,
1929     IUniswapV3PoolState,
1930     IUniswapV3PoolDerivedState,
1931     IUniswapV3PoolActions,
1932     IUniswapV3PoolOwnerActions,
1933     IUniswapV3PoolEvents
1934 {
1935 
1936 }
1937 
1938 // File: @uniswap/v3-core/contracts/libraries/LowGasSafeMath.sol
1939 
1940 // License-Identifier: GPL-2.0-or-later
1941 
1942 pragma solidity >=0.7.0;
1943 
1944 /// @title Optimized overflow and underflow safe math operations
1945 /// @notice Contains methods for doing math operations that revert on overflow or underflow for minimal gas cost
1946 library LowGasSafeMath {
1947     /// @notice Returns x + y, reverts if sum overflows uint256
1948     /// @param x The augend
1949     /// @param y The addend
1950     /// @return z The sum of x and y
1951     function add(uint256 x, uint256 y) internal pure returns (uint256 z) {
1952         require((z = x + y) >= x);
1953     }
1954 
1955     /// @notice Returns x - y, reverts if underflows
1956     /// @param x The minuend
1957     /// @param y The subtrahend
1958     /// @return z The difference of x and y
1959     function sub(uint256 x, uint256 y) internal pure returns (uint256 z) {
1960         require((z = x - y) <= x);
1961     }
1962 
1963     /// @notice Returns x * y, reverts if overflows
1964     /// @param x The multiplicand
1965     /// @param y The multiplier
1966     /// @return z The product of x and y
1967     function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
1968         require(x == 0 || (z = x * y) / x == y);
1969     }
1970 
1971     /// @notice Returns x + y, reverts if overflows or underflows
1972     /// @param x The augend
1973     /// @param y The addend
1974     /// @return z The sum of x and y
1975     function add(int256 x, int256 y) internal pure returns (int256 z) {
1976         require((z = x + y) >= x == (y >= 0));
1977     }
1978 
1979     /// @notice Returns x - y, reverts if overflows or underflows
1980     /// @param x The minuend
1981     /// @param y The subtrahend
1982     /// @return z The difference of x and y
1983     function sub(int256 x, int256 y) internal pure returns (int256 z) {
1984         require((z = x - y) <= x == (y >= 0));
1985     }
1986 }
1987 
1988 // File: @uniswap/v3-periphery/contracts/libraries/PoolAddress.sol
1989 
1990 // License-Identifier: GPL-2.0-or-later
1991 
1992 pragma solidity >=0.5.0;
1993 
1994 /// @title Provides functions for deriving a pool address from the factory, tokens, and the fee
1995 library PoolAddress {
1996     bytes32 internal constant POOL_INIT_CODE_HASH = 0xe34f199b19b2b4f47f68442619d555527d244f78a3297ea89325f843f87b8b54;
1997 
1998     /// @notice The identifying key of the pool
1999     struct PoolKey {
2000         address token0;
2001         address token1;
2002         uint24 fee;
2003     }
2004 
2005     /// @notice Returns PoolKey: the ordered tokens with the matched fee levels
2006     /// @param tokenA The first token of a pool, unsorted
2007     /// @param tokenB The second token of a pool, unsorted
2008     /// @param fee The fee level of the pool
2009     /// @return Poolkey The pool details with ordered token0 and token1 assignments
2010     function getPoolKey(
2011         address tokenA,
2012         address tokenB,
2013         uint24 fee
2014     ) internal pure returns (PoolKey memory) {
2015         if (tokenA > tokenB) (tokenA, tokenB) = (tokenB, tokenA);
2016         return PoolKey({token0: tokenA, token1: tokenB, fee: fee});
2017     }
2018 
2019     /// @notice Deterministically computes the pool address given the factory and PoolKey
2020     /// @param factory The Uniswap V3 factory contract address
2021     /// @param key The PoolKey
2022     /// @return pool The contract address of the V3 pool
2023     function computeAddress(address factory, PoolKey memory key) internal pure returns (address pool) {
2024         require(key.token0 < key.token1);
2025         pool = address(
2026             uint256(
2027                 keccak256(
2028                     abi.encodePacked(
2029                         hex'ff',
2030                         factory,
2031                         keccak256(abi.encode(key.token0, key.token1, key.fee)),
2032                         POOL_INIT_CODE_HASH
2033                     )
2034                 )
2035             )
2036         );
2037     }
2038 }
2039 
2040 // File: @uniswap/v3-periphery/contracts/libraries/OracleLibrary.sol
2041 
2042 // License-Identifier: GPL-2.0-or-later
2043 
2044 pragma solidity >=0.5.0 <0.8.0;
2045 
2046 /// @title Oracle library
2047 /// @notice Provides functions to integrate with V3 pool oracle
2048 library OracleLibrary {
2049     /// @notice Fetches time-weighted average tick using Uniswap V3 oracle
2050     /// @param pool Address of Uniswap V3 pool that we want to observe
2051     /// @param period Number of seconds in the past to start calculating time-weighted average
2052     /// @return timeWeightedAverageTick The time-weighted average tick from (block.timestamp - period) to block.timestamp
2053     function consult(address pool, uint32 period) internal view returns (int24 timeWeightedAverageTick) {
2054         require(period != 0, 'BP');
2055 
2056         uint32[] memory secondAgos = new uint32[](2);
2057         secondAgos[0] = period;
2058         secondAgos[1] = 0;
2059 
2060         (int56[] memory tickCumulatives, ) = IUniswapV3Pool(pool).observe(secondAgos);
2061         int56 tickCumulativesDelta = tickCumulatives[1] - tickCumulatives[0];
2062 
2063         timeWeightedAverageTick = int24(tickCumulativesDelta / period);
2064 
2065         // Always round to negative infinity
2066         if (tickCumulativesDelta < 0 && (tickCumulativesDelta % period != 0)) timeWeightedAverageTick--;
2067     }
2068 
2069     /// @notice Given a tick and a token amount, calculates the amount of token received in exchange
2070     /// @param tick Tick value used to calculate the quote
2071     /// @param baseAmount Amount of token to be converted
2072     /// @param baseToken Address of an ERC20 token contract used as the baseAmount denomination
2073     /// @param quoteToken Address of an ERC20 token contract used as the quoteAmount denomination
2074     /// @return quoteAmount Amount of quoteToken received for baseAmount of baseToken
2075     function getQuoteAtTick(
2076         int24 tick,
2077         uint128 baseAmount,
2078         address baseToken,
2079         address quoteToken
2080     ) internal pure returns (uint256 quoteAmount) {
2081         uint160 sqrtRatioX96 = TickMath.getSqrtRatioAtTick(tick);
2082 
2083         // Calculate quoteAmount with better precision if it doesn't overflow when multiplied by itself
2084         if (sqrtRatioX96 <= type(uint128).max) {
2085             uint256 ratioX192 = uint256(sqrtRatioX96) * sqrtRatioX96;
2086             quoteAmount = baseToken < quoteToken
2087                 ? FullMath.mulDiv(ratioX192, baseAmount, 1 << 192)
2088                 : FullMath.mulDiv(1 << 192, baseAmount, ratioX192);
2089         } else {
2090             uint256 ratioX128 = FullMath.mulDiv(sqrtRatioX96, sqrtRatioX96, 1 << 64);
2091             quoteAmount = baseToken < quoteToken
2092                 ? FullMath.mulDiv(ratioX128, baseAmount, 1 << 128)
2093                 : FullMath.mulDiv(1 << 128, baseAmount, ratioX128);
2094         }
2095     }
2096 }
2097 
2098 // File: contracts/lib/UV3Math.sol
2099 
2100 // License-Identifier: BUSL-1.1
2101 
2102 pragma solidity 0.7.6;
2103 
2104 library UV3Math {
2105 
2106     /// @dev The minimum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MIN_TICK)
2107     uint160 internal constant MIN_SQRT_RATIO = 4295128739;
2108     /// @dev The maximum value that can be returned from #getSqrtRatioAtTick. Equivalent to getSqrtRatioAtTick(MAX_TICK)
2109     uint160 internal constant MAX_SQRT_RATIO = 1461446703485210103287273052203988822378723970342;
2110 
2111     /*******************
2112      * Tick Math
2113      *******************/
2114     
2115     function getSqrtRatioAtTick(
2116         int24 currentTick
2117     ) public pure returns(uint160 sqrtPriceX96) {
2118         sqrtPriceX96 = TickMath.getSqrtRatioAtTick(currentTick);
2119     }
2120 
2121     /*******************
2122      * LiquidityAmounts
2123      *******************/
2124 
2125     function getAmountsForLiquidity(
2126         uint160 sqrtRatioX96,
2127         uint160 sqrtRatioAX96,
2128         uint160 sqrtRatioBX96,
2129         uint128 liquidity
2130     ) public pure returns (uint256 amount0, uint256 amount1) {
2131         (amount0, amount1) = LiquidityAmounts.getAmountsForLiquidity(
2132             sqrtRatioX96,
2133             sqrtRatioAX96,
2134             sqrtRatioBX96,
2135             liquidity);
2136     }
2137 
2138     function getLiquidityForAmounts(
2139         uint160 sqrtRatioX96,
2140         uint160 sqrtRatioAX96,
2141         uint160 sqrtRatioBX96,
2142         uint256 amount0,
2143         uint256 amount1
2144     ) public pure returns (uint128 liquidity) {
2145         liquidity = LiquidityAmounts.getLiquidityForAmounts(
2146             sqrtRatioX96,
2147             sqrtRatioAX96,
2148             sqrtRatioBX96,
2149             amount0,
2150             amount1);
2151     }
2152 
2153     /*******************
2154      * OracleLibrary
2155      *******************/
2156 
2157     function consult(
2158         address _pool, 
2159         uint32 _twapPeriod
2160     ) public view returns(int24 timeWeightedAverageTick) {
2161         timeWeightedAverageTick = OracleLibrary.consult(_pool, _twapPeriod);
2162     }
2163 
2164     function getQuoteAtTick(
2165         int24 tick,
2166         uint128 baseAmount,
2167         address baseToken,
2168         address quoteToken
2169     ) public pure returns (uint256 quoteAmount) {
2170         quoteAmount = OracleLibrary.getQuoteAtTick(tick, baseAmount, baseToken, quoteToken);
2171     }
2172 
2173     /*******************
2174      * SafeUnit128
2175      *******************/
2176 
2177     /// @notice Cast a uint256 to a uint128, revert on overflow
2178     /// @param y The uint256 to be downcasted
2179     /// @return z The downcasted integer, now type uint128
2180     function toUint128(uint256 y) public  pure returns (uint128 z) {
2181         require((z = uint128(y)) == y, "SafeUint128: overflow");
2182     }
2183 }
2184 
2185 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
2186 
2187 // License-Identifier: MIT
2188 
2189 pragma solidity ^0.7.0;
2190 
2191 /**
2192  * @dev Contract module that helps prevent reentrant calls to a function.
2193  *
2194  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
2195  * available, which can be applied to functions to make sure there are no nested
2196  * (reentrant) calls to them.
2197  *
2198  * Note that because there is a single `nonReentrant` guard, functions marked as
2199  * `nonReentrant` may not call one another. This can be worked around by making
2200  * those functions `private`, and then adding `external` `nonReentrant` entry
2201  * points to them.
2202  *
2203  * TIP: If you would like to learn more about reentrancy and alternative ways
2204  * to protect against it, check out our blog post
2205  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
2206  */
2207 abstract contract ReentrancyGuard {
2208     // Booleans are more expensive than uint256 or any type that takes up a full
2209     // word because each write operation emits an extra SLOAD to first read the
2210     // slot's contents, replace the bits taken up by the boolean, and then write
2211     // back. This is the compiler's defense against contract upgrades and
2212     // pointer aliasing, and it cannot be disabled.
2213 
2214     // The values being non-zero value makes deployment a bit more expensive,
2215     // but in exchange the refund on every call to nonReentrant will be lower in
2216     // amount. Since refunds are capped to a percentage of the total
2217     // transaction's gas, it is best to keep them low in cases like this one, to
2218     // increase the likelihood of the full refund coming into effect.
2219     uint256 private constant _NOT_ENTERED = 1;
2220     uint256 private constant _ENTERED = 2;
2221 
2222     uint256 private _status;
2223 
2224     constructor () {
2225         _status = _NOT_ENTERED;
2226     }
2227 
2228     /**
2229      * @dev Prevents a contract from calling itself, directly or indirectly.
2230      * Calling a `nonReentrant` function from another `nonReentrant`
2231      * function is not supported. It is possible to prevent this from happening
2232      * by making the `nonReentrant` function external, and make it call a
2233      * `private` function that does the actual work.
2234      */
2235     modifier nonReentrant() {
2236         // On the first call to nonReentrant, _notEntered will be true
2237         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
2238 
2239         // Any calls to nonReentrant after this point will fail
2240         _status = _ENTERED;
2241 
2242         _;
2243 
2244         // By storing the original value once again, a refund is triggered (see
2245         // https://eips.ethereum.org/EIPS/eip-2200)
2246         _status = _NOT_ENTERED;
2247     }
2248 }
2249 
2250 // File: @uniswap/v3-core/contracts/interfaces/callback/IUniswapV3MintCallback.sol
2251 
2252 // License-Identifier: GPL-2.0-or-later
2253 
2254 pragma solidity >=0.5.0;
2255 
2256 /// @title Callback for IUniswapV3PoolActions#mint
2257 /// @notice Any contract that calls IUniswapV3PoolActions#mint must implement this interface
2258 interface IUniswapV3MintCallback {
2259     /// @notice Called to `msg.sender` after minting liquidity to a position from IUniswapV3Pool#mint.
2260     /// @dev In the implementation you must pay the pool tokens owed for the minted liquidity.
2261     /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
2262     /// @param amount0Owed The amount of token0 due to the pool for the minted liquidity
2263     /// @param amount1Owed The amount of token1 due to the pool for the minted liquidity
2264     /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#mint call
2265     function uniswapV3MintCallback(
2266         uint256 amount0Owed,
2267         uint256 amount1Owed,
2268         bytes calldata data
2269     ) external;
2270 }
2271 
2272 // File: @uniswap/v3-core/contracts/interfaces/callback/IUniswapV3SwapCallback.sol
2273 
2274 // License-Identifier: GPL-2.0-or-later
2275 
2276 pragma solidity >=0.5.0;
2277 
2278 /// @title Callback for IUniswapV3PoolActions#swap
2279 /// @notice Any contract that calls IUniswapV3PoolActions#swap must implement this interface
2280 interface IUniswapV3SwapCallback {
2281     /// @notice Called to `msg.sender` after executing a swap via IUniswapV3Pool#swap.
2282     /// @dev In the implementation you must pay the pool tokens owed for the swap.
2283     /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
2284     /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
2285     /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
2286     /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
2287     /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
2288     /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
2289     /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
2290     function uniswapV3SwapCallback(
2291         int256 amount0Delta,
2292         int256 amount1Delta,
2293         bytes calldata data
2294     ) external;
2295 }
2296 
2297 // File: interfaces/IICHIVault.sol
2298 
2299 // License-Identifier: Unlicense
2300 
2301 pragma solidity 0.7.6;
2302 
2303 interface IICHIVault{
2304 
2305     function ichiVaultFactory() external view returns(address);
2306 
2307     function pool() external view returns(address);
2308     function token0() external view returns(address);
2309     function allowToken0() external view returns(bool);
2310     function token1() external view returns(address);
2311     function allowToken1() external view returns(bool);
2312     function fee() external view returns(uint24);
2313     function tickSpacing() external view returns(int24);
2314     function affiliate() external view returns(address);
2315 
2316     function baseLower() external view returns(int24);
2317     function baseUpper() external view returns(int24);
2318     function limitLower() external view returns(int24);
2319     function limitUpper() external view returns(int24);
2320 
2321     function deposit0Max() external view returns(uint256);
2322     function deposit1Max() external view returns(uint256);
2323     function maxTotalSupply() external view returns(uint256);
2324     function hysteresis() external view returns(uint256);
2325 
2326     function getTotalAmounts() external view returns (uint256, uint256);
2327 
2328     function deposit(
2329         uint256,
2330         uint256,
2331         address
2332     ) external returns (uint256);
2333 
2334     function withdraw(
2335         uint256,
2336         address
2337     ) external returns (uint256, uint256);
2338 
2339     function rebalance(
2340         int24 _baseLower,
2341         int24 _baseUpper,
2342         int24 _limitLower,
2343         int24 _limitUpper,
2344         int256 swapQuantity
2345     ) external;
2346 
2347     function setDepositMax(
2348         uint256 _deposit0Max, 
2349         uint256 _deposit1Max) external;
2350 
2351     function setAffiliate(
2352         address _affiliate) external;
2353 
2354     event DeployICHIVault(
2355         address indexed sender, 
2356         address indexed pool, 
2357         bool allowToken0,
2358         bool allowToken1,
2359         address owner,
2360         uint256 twapPeriod);
2361 
2362     event SetTwapPeriod(
2363         address sender, 
2364         uint32 newTwapPeriod
2365     );
2366 
2367     event Deposit(
2368         address indexed sender,
2369         address indexed to,
2370         uint256 shares,
2371         uint256 amount0,
2372         uint256 amount1
2373     );
2374 
2375     event Withdraw(
2376         address indexed sender,
2377         address indexed to,
2378         uint256 shares,
2379         uint256 amount0,
2380         uint256 amount1
2381     );
2382 
2383     event Rebalance(
2384         int24 tick,
2385         uint256 totalAmount0,
2386         uint256 totalAmount1,
2387         uint256 feeAmount0,
2388         uint256 feeAmount1,
2389         uint256 totalSupply
2390     );
2391 
2392     event MaxTotalSupply(
2393         address indexed sender, 
2394         uint256 maxTotalSupply);
2395 
2396     event Hysteresis(
2397         address indexed sender, 
2398         uint256 hysteresis);
2399 
2400     event DepositMax(
2401         address indexed sender, 
2402         uint256 deposit0Max, 
2403         uint256 deposit1Max);
2404         
2405     event Affiliate(
2406         address indexed sender, 
2407         address affiliate);    
2408 }
2409 
2410 // File: interfaces/IICHIVaultFactory.sol
2411 
2412 // License-Identifier: BUSL-1.1
2413 
2414 pragma solidity 0.7.6;
2415 
2416 interface IICHIVaultFactory {
2417 
2418     event FeeRecipient(
2419         address indexed sender, 
2420         address feeRecipient);
2421 
2422     event BaseFee(
2423         address indexed sender, 
2424         uint256 baseFee);
2425 
2426     event BaseFeeSplit(
2427         address indexed sender, 
2428         uint256 baseFeeSplit);
2429     
2430     event DeployICHIVaultFactory(
2431         address indexed sender, 
2432         address uniswapV3Factory);
2433 
2434     event ICHIVaultCreated(
2435         address indexed sender, 
2436         address ichiVault, 
2437         address tokenA,
2438         bool allowTokenA,
2439         address tokenB,
2440         bool allowTokenB,
2441         uint24 fee,
2442         uint256 count);    
2443 
2444     function uniswapV3Factory() external view returns(address);
2445     function feeRecipient() external view returns(address);
2446     function baseFee() external view returns(uint256);
2447     function baseFeeSplit() external view returns(uint256);
2448     
2449     function setFeeRecipient(address _feeRecipient) external;
2450     function setBaseFee(uint256 _baseFee) external;
2451     function setBaseFeeSplit(uint256 _baseFeeSplit) external;
2452 
2453     function createICHIVault(
2454         address tokenA,
2455         bool allowTokenA,
2456         address tokenB,
2457         bool allowTokenB,
2458         uint24 fee
2459     ) external returns (address ichiVault);
2460 
2461     function genKey(
2462         address deployer, 
2463         address token0, 
2464         address token1, 
2465         uint24 fee, 
2466         bool allowToken0, 
2467         bool allowToken1) external pure returns(bytes32 key);
2468 }
2469 
2470 // File: contracts/ICHIVault.sol
2471 
2472 // License-Identifier: BUSL-1.1
2473 
2474 pragma solidity 0.7.6;
2475 
2476 /**
2477  @notice A Uniswap V2-like interface with fungible liquidity to Uniswap V3 
2478  which allows for either one-sided or two-sided liquidity provision.
2479  ICHIVaults should be deployed by the ICHIVaultFactory. 
2480  ICHIVaults should not be used with tokens that charge transaction fees.  
2481  */
2482 contract ICHIVault is
2483     IICHIVault,
2484     IUniswapV3MintCallback,
2485     IUniswapV3SwapCallback,
2486     ERC20,
2487     ReentrancyGuard,
2488     Ownable
2489 {
2490     using SafeERC20 for IERC20;
2491     using SafeMath for uint256;
2492 
2493     address public immutable override ichiVaultFactory;
2494     address public immutable override pool;
2495     address public immutable override token0;
2496     address public immutable override token1;
2497     bool public immutable override allowToken0;
2498     bool public immutable override allowToken1;
2499     uint24 public immutable override fee;
2500     int24 public immutable override tickSpacing;
2501 
2502     address public override affiliate;
2503     int24 public override baseLower;
2504     int24 public override baseUpper;
2505     int24 public override limitLower;
2506     int24 public override limitUpper;
2507 
2508     // The following three variables serve the very important purpose of
2509     // limiting inventory risk and the arbitrage opportunities made possible by
2510     // instant deposit & withdrawal.
2511     // If, in the ETHUSDT pool at an ETH price of 2500 USDT, I deposit 100k
2512     // USDT in a pool with 40 WETH, and then directly afterwards withdraw 50k
2513     // USDT and 20 WETH (this is of equivalent dollar value), I drastically
2514     // change the pool composition and additionally decreases deployed capital
2515     // by 50%. Keeping a maxTotalSupply just above our current total supply
2516     // means that large amounts of funds can't be deposited all at once to
2517     // create a large imbalance of funds or to sideline many funds.
2518     // Additionally, deposit maximums prevent users from using the pool as
2519     // a counterparty to trade assets against while avoiding uniswap fees
2520     // & slippage--if someone were to try to do this with a large amount of
2521     // capital they would be overwhelmed by the gas fees necessary to call
2522     // deposit & withdrawal many times.
2523 
2524     uint256 public override deposit0Max;
2525     uint256 public override deposit1Max;
2526     uint256 public override maxTotalSupply;
2527     uint256 public override hysteresis;
2528 
2529     uint256 public constant PRECISION = 10**18;
2530     uint256 constant PERCENT = 100;
2531     address constant NULL_ADDRESS = address(0);
2532 
2533     uint32 public twapPeriod;
2534 
2535     /**
2536      @notice creates an instance of ICHIVault based on the pool. allowToken parameters control whether the ICHIVault allows one-sided or two-sided liquidity provision
2537      @param _pool Uniswap V3 pool for which liquidity is managed
2538      @param _allowToken0 flag that indicates whether token0 is accepted during deposit
2539      @param _allowToken1 flag that indicates whether token1 is accepted during deposit
2540      @param __owner Owner of the ICHIVault
2541      */
2542     constructor(
2543         address _pool,
2544         bool _allowToken0,
2545         bool _allowToken1,
2546         address __owner,
2547         uint32 _twapPeriod
2548     ) ERC20("ICHI Vault Liquidity", "ICHI_Vault_LP") {
2549         require(_pool != NULL_ADDRESS, "IV.constructor: zero address");
2550         require(_allowToken0 || _allowToken1, 'IV.constructor: no allowed tokens');
2551 
2552         ichiVaultFactory = msg.sender;
2553         pool = _pool;
2554         token0 = IUniswapV3Pool(_pool).token0();
2555         token1 = IUniswapV3Pool(_pool).token1();
2556         fee = IUniswapV3Pool(_pool).fee();
2557         allowToken0 = _allowToken0;
2558         allowToken1 = _allowToken1;
2559         twapPeriod = _twapPeriod;
2560         tickSpacing = IUniswapV3Pool(_pool).tickSpacing();
2561 
2562         transferOwnership(__owner);
2563 
2564         maxTotalSupply = 0; // no cap
2565         hysteresis = PRECISION.div(PERCENT); // 1% threshold
2566         deposit0Max = uint256(-1); // max uint256
2567         deposit1Max = uint256(-1); // max uint256
2568         affiliate = NULL_ADDRESS; // by default there is no affiliate address
2569         emit DeployICHIVault(
2570             msg.sender,
2571             _pool,
2572             _allowToken0,
2573             _allowToken1,
2574             __owner,
2575             _twapPeriod
2576         );
2577     }
2578 
2579     function setTwapPeriod(uint32 newTwapPeriod) external onlyOwner {
2580         require(newTwapPeriod > 0, "IV.setTwapPeriod: missing period");
2581         twapPeriod = newTwapPeriod;
2582         emit SetTwapPeriod(msg.sender, newTwapPeriod);
2583     }
2584 
2585     /**
2586      @notice Distributes shares to depositor equal to the token1 value of his deposit multiplied by the ratio of total liquidity shares issued divided by the pool's AUM measured in token1 value. 
2587      @param deposit0 Amount of token0 transfered from sender to ICHIVault
2588      @param deposit1 Amount of token0 transfered from sender to ICHIVault
2589      @param to Address to which liquidity tokens are minted
2590      @param shares Quantity of liquidity tokens minted as a result of deposit
2591      */
2592     function deposit(
2593         uint256 deposit0,
2594         uint256 deposit1,
2595         address to
2596     ) external override nonReentrant returns (uint256 shares) {
2597 
2598         require(allowToken0 || deposit0 == 0, "IV.deposit: token0 not allowed");
2599         require(allowToken1 || deposit1 == 0, "IV.deposit: token1 not allowed");
2600         require(
2601             deposit0 > 0 || deposit1 > 0,
2602             "IV.deposit: deposits must be > 0"
2603         );
2604         require(
2605             deposit0 < deposit0Max && deposit1 < deposit1Max,
2606             "IV.deposit: deposits too large"
2607         );
2608         require(to != NULL_ADDRESS && to != address(this), "IV.deposit: to");
2609 
2610         // update fees for inclusion in total pool amounts
2611         (uint128 baseLiquidity, , ) = _position(baseLower, baseUpper);
2612         if (baseLiquidity > 0) {
2613             (uint burn0, uint burn1) = IUniswapV3Pool(pool).burn(baseLower, baseUpper, 0);
2614             require(burn0 == 0 && burn1 == 0, "IV.deposit: unexpected burn (1)");
2615         }
2616 
2617         (uint128 limitLiquidity, , ) = _position(limitLower, limitUpper);
2618         if (limitLiquidity > 0) {
2619             (uint burn0, uint burn1) = IUniswapV3Pool(pool).burn(limitLower, limitUpper, 0);
2620             require(burn0 == 0 && burn1 == 0, "IV.deposit: unexpected burn (2)");
2621         }
2622 
2623         // Spot
2624 
2625         uint256 price = _fetchSpot(
2626             token0,
2627             token1,
2628             currentTick(),
2629             PRECISION
2630         );
2631 
2632         // TWAP
2633  
2634         uint256 twap = _fetchTwap(
2635             pool,
2636             token0,
2637             token1,
2638             twapPeriod,
2639             PRECISION);
2640 
2641         // if difference between spot and twap is too big, check if the price may have been manipulated in this block
2642         uint256 delta = (price > twap) ? price.sub(twap).mul(PRECISION).div(price) : twap.sub(price).mul(PRECISION).div(twap);
2643         if (delta > hysteresis) require(checkHysteresis(), "IV.deposit: try later");
2644 
2645         (uint256 pool0, uint256 pool1) = getTotalAmounts();
2646 
2647         // aggregated deposit 
2648         uint256 deposit0PricedInToken1 = deposit0.mul((price < twap) ? price : twap).div(PRECISION);
2649 
2650         if (deposit0 > 0) {
2651             IERC20(token0).safeTransferFrom(
2652                 msg.sender,
2653                 address(this),
2654                 deposit0
2655             );
2656         }
2657         if (deposit1 > 0) {
2658             IERC20(token1).safeTransferFrom(
2659                 msg.sender,
2660                 address(this),
2661                 deposit1
2662             );
2663         }
2664 
2665         shares = deposit1.add(deposit0PricedInToken1);
2666 
2667         if (totalSupply() != 0) {
2668             uint256 pool0PricedInToken1 = pool0.mul((price > twap) ? price : twap).div(PRECISION);
2669             shares = shares.mul(totalSupply()).div(
2670                 pool0PricedInToken1.add(pool1)
2671             );
2672         }
2673         _mint(to, shares);
2674         emit Deposit(msg.sender, to, shares, deposit0, deposit1);
2675         // Check total supply cap not exceeded. A value of 0 means no limit.
2676         require(
2677             maxTotalSupply == 0 || totalSupply() <= maxTotalSupply,
2678             "IV.deposit: maxTotalSupply"
2679         );
2680     }
2681 
2682     /**
2683      @notice Redeems shares by sending out a percentage of the ICHIVault's AUM - this percentage is equal to the percentage of total issued shares represented by the redeeemed shares.
2684      @param shares Number of liquidity tokens to redeem as pool assets
2685      @param to Address to which redeemed pool assets are sent
2686      @param amount0 Amount of token0 redeemed by the submitted liquidity tokens
2687      @param amount1 Amount of token1 redeemed by the submitted liquidity tokens
2688      */
2689     function withdraw(uint256 shares, address to)
2690         external
2691         override
2692         nonReentrant 
2693         returns (uint256 amount0, uint256 amount1)
2694     {
2695         require(shares > 0, "IV.withdraw: shares");
2696         require(to != NULL_ADDRESS, "IV.withdraw: to");
2697 
2698         // Withdraw liquidity from Uniswap pool
2699         (uint256 base0, uint256 base1) = _burnLiquidity(
2700             baseLower,
2701             baseUpper,
2702             _liquidityForShares(baseLower, baseUpper, shares),
2703             to,
2704             false
2705         );
2706         (uint256 limit0, uint256 limit1) = _burnLiquidity(
2707             limitLower,
2708             limitUpper,
2709             _liquidityForShares(limitLower, limitUpper, shares),
2710             to,
2711             false
2712         );
2713 
2714         // Push tokens proportional to unused balances
2715         uint256 _totalSupply = totalSupply();
2716         uint256 unusedAmount0 = IERC20(token0)
2717             .balanceOf(address(this))
2718             .mul(shares)
2719             .div(_totalSupply);
2720         uint256 unusedAmount1 = IERC20(token1)
2721             .balanceOf(address(this))
2722             .mul(shares)
2723             .div(_totalSupply);
2724         if (unusedAmount0 > 0) IERC20(token0).safeTransfer(to, unusedAmount0);
2725         if (unusedAmount1 > 0) IERC20(token1).safeTransfer(to, unusedAmount1);
2726 
2727         amount0 = base0.add(limit0).add(unusedAmount0);
2728         amount1 = base1.add(limit1).add(unusedAmount1);
2729 
2730         _burn(msg.sender, shares);
2731 
2732         emit Withdraw(msg.sender, to, shares, amount0, amount1);
2733     }
2734 
2735     /**
2736      @notice Updates ICHIVault's LP positions.
2737      @dev The base position is placed first with as much liquidity as possible and is typically symmetric around the current price. This order should use up all of one token, leaving some unused quantity of the other. This unused amount is then placed as a single-sided order.
2738      @param _baseLower The lower tick of the base position
2739      @param _baseUpper The upper tick of the base position
2740      @param _limitLower The lower tick of the limit position
2741      @param _limitUpper The upper tick of the limit position
2742      @param swapQuantity Quantity of tokens to swap; if quantity is positive, `swapQuantity` token0 are swaped for token1, if negative, `swapQuantity` token1 is swaped for token0
2743      */
2744     function rebalance(
2745         int24 _baseLower,
2746         int24 _baseUpper,
2747         int24 _limitLower,
2748         int24 _limitUpper,
2749         int256 swapQuantity
2750     ) external override nonReentrant onlyOwner {
2751         require(
2752             _baseLower < _baseUpper &&
2753                 _baseLower % tickSpacing == 0 &&
2754                 _baseUpper % tickSpacing == 0,
2755             "IV.rebalance: base position invalid"
2756         );
2757         require(
2758             _limitLower < _limitUpper &&
2759                 _limitLower % tickSpacing == 0 &&
2760                 _limitUpper % tickSpacing == 0,
2761             "IV.rebalance: limit position invalid"
2762         );
2763 
2764         // update fees
2765         (uint128 baseLiquidity, , ) = _position(baseLower, baseUpper);
2766         if (baseLiquidity > 0) {
2767             IUniswapV3Pool(pool).burn(baseLower, baseUpper, 0);
2768         }
2769         (uint128 limitLiquidity, , ) = _position(limitLower, limitUpper);
2770         if (limitLiquidity > 0) {
2771             IUniswapV3Pool(pool).burn(limitLower, limitUpper, 0);
2772         }
2773 
2774         // Withdraw all liquidity and collect all fees from Uniswap pool
2775         (, uint256 feesBase0, uint256 feesBase1) = _position(
2776             baseLower,
2777             baseUpper
2778         );
2779         (, uint256 feesLimit0, uint256 feesLimit1) = _position(
2780             limitLower,
2781             limitUpper
2782         );
2783 
2784         uint256 fees0 = feesBase0.add(feesLimit0);
2785         uint256 fees1 = feesBase1.add(feesLimit1);
2786 
2787         _burnLiquidity(
2788             baseLower,
2789             baseUpper,
2790             baseLiquidity,
2791             address(this),
2792             true
2793         );
2794         _burnLiquidity(
2795             limitLower,
2796             limitUpper,
2797             limitLiquidity,
2798             address(this),
2799             true
2800         );
2801 
2802         _distributeFees(fees0, fees1);
2803 
2804         emit Rebalance(
2805             currentTick(),
2806             IERC20(token0).balanceOf(address(this)),
2807             IERC20(token1).balanceOf(address(this)),
2808             fees0,
2809             fees1,
2810             totalSupply()
2811         );
2812 
2813         // swap tokens if required
2814         if (swapQuantity != 0) {
2815             IUniswapV3Pool(pool).swap(
2816                 address(this),
2817                 swapQuantity > 0,
2818                 swapQuantity > 0 ? swapQuantity : -swapQuantity,
2819                 swapQuantity > 0
2820                     ? UV3Math.MIN_SQRT_RATIO + 1
2821                     : UV3Math.MAX_SQRT_RATIO - 1,
2822                 abi.encode(address(this))
2823             );
2824         }
2825 
2826         baseLower = _baseLower;
2827         baseUpper = _baseUpper;
2828         baseLiquidity = _liquidityForAmounts(
2829             baseLower,
2830             baseUpper,
2831             IERC20(token0).balanceOf(address(this)),
2832             IERC20(token1).balanceOf(address(this))
2833         );
2834         _mintLiquidity(baseLower, baseUpper, baseLiquidity);
2835 
2836         limitLower = _limitLower;
2837         limitUpper = _limitUpper;
2838         limitLiquidity = _liquidityForAmounts(
2839             limitLower,
2840             limitUpper,
2841             IERC20(token0).balanceOf(address(this)),
2842             IERC20(token1).balanceOf(address(this))
2843         );
2844         _mintLiquidity(limitLower, limitUpper, limitLiquidity);
2845     }
2846 
2847     /**
2848      @notice Sends portion of swap fees to feeRecipient and affiliate.
2849      @param fees0 fees for token0
2850      @param fees1 fees for token1
2851      */
2852     function _distributeFees(uint256 fees0, uint256 fees1) internal {
2853         uint256 baseFee = IICHIVaultFactory(ichiVaultFactory).baseFee();
2854         // if there is no affiliate 100% of the baseFee should go to feeRecipient
2855         uint256 baseFeeSplit = (affiliate == NULL_ADDRESS)
2856             ? PRECISION
2857             : IICHIVaultFactory(ichiVaultFactory).baseFeeSplit();
2858         address feeRecipient = IICHIVaultFactory(ichiVaultFactory).feeRecipient();
2859 
2860         require(baseFee <= PRECISION, "IV.rebalance: fee must be <= 10**18");
2861         require(baseFeeSplit <= PRECISION, "IV.rebalance: split must be <= 10**18");
2862         require(feeRecipient != NULL_ADDRESS, "IV.rebalance: zero address");
2863 
2864         if (baseFee > 0) {
2865             if (fees0 > 0) {
2866                 uint256 totalFee = fees0.mul(baseFee).div(PRECISION);
2867                 uint256 toRecipient = totalFee.mul(baseFeeSplit).div(PRECISION);
2868                 uint256 toAffiliate = totalFee.sub(toRecipient);
2869                 IERC20(token0).safeTransfer(feeRecipient, toRecipient);
2870                 if (toAffiliate > 0) {
2871                     IERC20(token0).safeTransfer(affiliate, toAffiliate);
2872                 }
2873             }
2874             if (fees1 > 0) {
2875                 uint256 totalFee = fees1.mul(baseFee).div(PRECISION);
2876                 uint256 toRecipient = totalFee.mul(baseFeeSplit).div(PRECISION);
2877                 uint256 toAffiliate = totalFee.sub(toRecipient);
2878                 IERC20(token1).safeTransfer(feeRecipient, toRecipient);
2879                 if (toAffiliate > 0) {
2880                     IERC20(token1).safeTransfer(affiliate, toAffiliate);
2881                 }
2882             }
2883         }
2884     }
2885 
2886     /**
2887      @notice Mint liquidity in Uniswap V3 pool.
2888      @param tickLower The lower tick of the liquidity position
2889      @param tickUpper The upper tick of the liquidity position
2890      @param liquidity Amount of liquidity to mint
2891      @param amount0 Used amount of token0
2892      @param amount1 Used amount of token1
2893      */
2894     function _mintLiquidity(
2895         int24 tickLower,
2896         int24 tickUpper,
2897         uint128 liquidity
2898     ) internal returns (uint256 amount0, uint256 amount1) {
2899         if (liquidity > 0) {
2900             (amount0, amount1) = IUniswapV3Pool(pool).mint(
2901                 address(this),
2902                 tickLower,
2903                 tickUpper,
2904                 liquidity,
2905                 abi.encode(address(this))
2906             );
2907         }
2908     }
2909 
2910     /**
2911      @notice Burn liquidity in Uniswap V3 pool.
2912      @param tickLower The lower tick of the liquidity position
2913      @param tickUpper The upper tick of the liquidity position
2914      @param liquidity amount of liquidity to burn
2915      @param to The account to receive token0 and token1 amounts
2916      @param collectAll Flag that indicates whether all token0 and token1 tokens should be collected or only the ones released during this burn
2917      @param amount0 released amount of token0
2918      @param amount1 released amount of token1
2919      */
2920     function _burnLiquidity(
2921         int24 tickLower,
2922         int24 tickUpper,
2923         uint128 liquidity,
2924         address to,
2925         bool collectAll
2926     ) internal returns (uint256 amount0, uint256 amount1) {
2927         if (liquidity > 0) {
2928             // Burn liquidity
2929             (uint256 owed0, uint256 owed1) = IUniswapV3Pool(pool).burn(
2930                 tickLower,
2931                 tickUpper,
2932                 liquidity
2933             );
2934 
2935             // Collect amount owed
2936             uint128 collect0 = collectAll
2937                 ? type(uint128).max
2938                 : _uint128Safe(owed0);
2939             uint128 collect1 = collectAll
2940                 ? type(uint128).max
2941                 : _uint128Safe(owed1);
2942             if (collect0 > 0 || collect1 > 0) {
2943                 (amount0, amount1) = IUniswapV3Pool(pool).collect(
2944                     to,
2945                     tickLower,
2946                     tickUpper,
2947                     collect0,
2948                     collect1
2949                 );
2950             }
2951         }
2952     }
2953 
2954     /**
2955      @notice Calculates liquidity amount for the given shares.
2956      @param tickLower The lower tick of the liquidity position
2957      @param tickUpper The upper tick of the liquidity position
2958      @param shares number of shares
2959      */
2960     function _liquidityForShares(
2961         int24 tickLower,
2962         int24 tickUpper,
2963         uint256 shares
2964     ) internal view returns (uint128) {
2965         (uint128 position, , ) = _position(tickLower, tickUpper);
2966         return _uint128Safe(uint256(position).mul(shares).div(totalSupply()));
2967     }
2968 
2969     /**
2970      @notice Returns information about the liquidity position.
2971      @param tickLower The lower tick of the liquidity position
2972      @param tickUpper The upper tick of the liquidity position
2973      @param liquidity liquidity amount
2974      @param tokensOwed0 amount of token0 owed to the owner of the position
2975      @param tokensOwed1 amount of token1 owed to the owner of the position
2976      */
2977     function _position(int24 tickLower, int24 tickUpper)
2978         internal
2979         view
2980         returns (
2981             uint128 liquidity,
2982             uint128 tokensOwed0,
2983             uint128 tokensOwed1
2984         )
2985     {
2986         bytes32 positionKey = keccak256(
2987             abi.encodePacked(address(this), tickLower, tickUpper)
2988         );
2989         (liquidity, , , tokensOwed0, tokensOwed1) = IUniswapV3Pool(pool)
2990             .positions(positionKey);
2991     }
2992 
2993     /**
2994      @notice Callback function for mint
2995      @dev this is where the payer transfers required token0 and token1 amounts
2996      @param amount0 required amount of token0
2997      @param amount1 required amount of token1
2998      @param data encoded payer's address
2999      */
3000     function uniswapV3MintCallback(
3001         uint256 amount0,
3002         uint256 amount1,
3003         bytes calldata data
3004     ) external override {
3005         require(msg.sender == address(pool), "cb1");
3006         address payer = abi.decode(data, (address));
3007 
3008         if (payer == address(this)) {
3009             if (amount0 > 0) IERC20(token0).safeTransfer(msg.sender, amount0);
3010             if (amount1 > 0) IERC20(token1).safeTransfer(msg.sender, amount1);
3011         } else {
3012             if (amount0 > 0)
3013                 IERC20(token0).safeTransferFrom(payer, msg.sender, amount0);
3014             if (amount1 > 0)
3015                 IERC20(token1).safeTransferFrom(payer, msg.sender, amount1);
3016         }
3017     }
3018 
3019     /**
3020      @notice Callback function for swap
3021      @dev this is where the payer transfers required token0 and token1 amounts
3022      @param amount0Delta required amount of token0
3023      @param amount1Delta required amount of token1
3024      @param data encoded payer's address
3025      */
3026     function uniswapV3SwapCallback(
3027         int256 amount0Delta,
3028         int256 amount1Delta,
3029         bytes calldata data
3030     ) external override {
3031         require(msg.sender == address(pool), "cb2");
3032         address payer = abi.decode(data, (address));
3033 
3034         if (amount0Delta > 0) {
3035             if (payer == address(this)) {
3036                 IERC20(token0).safeTransfer(msg.sender, uint256(amount0Delta));
3037             } else {
3038                 IERC20(token0).safeTransferFrom(
3039                     payer,
3040                     msg.sender,
3041                     uint256(amount0Delta)
3042                 );
3043             }
3044         } else if (amount1Delta > 0) {
3045             if (payer == address(this)) {
3046                 IERC20(token1).safeTransfer(msg.sender, uint256(amount1Delta));
3047             } else {
3048                 IERC20(token1).safeTransferFrom(
3049                     payer,
3050                     msg.sender,
3051                     uint256(amount1Delta)
3052                 );
3053             }
3054         }
3055     }
3056 
3057     /**
3058      @notice Checks if the last price change happened in the current block
3059      */
3060     function checkHysteresis() private view returns(bool) {
3061         (, , uint16 observationIndex, , , , ) = IUniswapV3Pool(pool).slot0();
3062         (uint32 blockTimestamp, , ,) = IUniswapV3Pool(pool).observations(observationIndex);
3063         return( block.timestamp != blockTimestamp );
3064     }
3065 
3066     /**
3067      @notice Sets the maximum liquidity token supply the contract allows
3068      @dev onlyOwner
3069      @param _maxTotalSupply The maximum liquidity token supply the contract allows
3070      */
3071     function setMaxTotalSupply(uint256 _maxTotalSupply) external onlyOwner {
3072         maxTotalSupply = _maxTotalSupply;
3073         emit MaxTotalSupply(msg.sender, _maxTotalSupply);
3074     }
3075 
3076     /**
3077      @notice Sets the hysteresis threshold (in percentage points, 10**16 = 1%). When difference between spot price and TWAP exceeds the threshold, a check for a flashloan attack is executed
3078      @dev onlyOwner
3079      @param _hysteresis hysteresis threshold
3080      */
3081     function setHysteresis(uint256 _hysteresis) external onlyOwner {
3082         hysteresis = _hysteresis;
3083         emit Hysteresis(msg.sender, _hysteresis);
3084     }
3085 
3086     /**
3087      @notice Sets the affiliate account address where portion of the collected swap fees will be distributed
3088      @dev onlyOwner
3089      @param _affiliate The affiliate account address
3090      */
3091     function setAffiliate(address _affiliate) external override onlyOwner {
3092         affiliate = _affiliate;
3093         emit Affiliate(msg.sender, _affiliate);
3094     }
3095 
3096     /**
3097      @notice Sets the maximum token0 and token1 amounts the contract allows in a deposit
3098      @dev onlyOwner
3099      @param _deposit0Max The maximum amount of token0 allowed in a deposit
3100      @param _deposit1Max The maximum amount of token1 allowed in a deposit
3101      */
3102     function setDepositMax(uint256 _deposit0Max, uint256 _deposit1Max)
3103         external
3104         override
3105         onlyOwner
3106     {
3107         deposit0Max = _deposit0Max;
3108         deposit1Max = _deposit1Max;
3109         emit DepositMax(msg.sender, _deposit0Max, _deposit1Max);
3110     }  
3111 
3112    /**
3113      @notice Calculates token0 and token1 amounts for liquidity in a position
3114      @param tickLower The lower tick of the liquidity position
3115      @param tickUpper The upper tick of the liquidity position
3116      @param liquidity Amount of liquidity in the position
3117      */
3118     function _amountsForLiquidity(
3119         int24 tickLower,
3120         int24 tickUpper,
3121         uint128 liquidity
3122     ) internal view returns (uint256, uint256) {
3123         (uint160 sqrtRatioX96, , , , , , ) = IUniswapV3Pool(pool).slot0();
3124         return
3125             UV3Math.getAmountsForLiquidity(
3126                 sqrtRatioX96,
3127                 UV3Math.getSqrtRatioAtTick(tickLower),
3128                 UV3Math.getSqrtRatioAtTick(tickUpper),
3129                 liquidity
3130             );
3131     }
3132 
3133     /**
3134      @notice Calculates amount of liquidity in a position for given token0 and token1 amounts
3135      @param tickLower The lower tick of the liquidity position
3136      @param tickUpper The upper tick of the liquidity position
3137      @param amount0 token0 amount
3138      @param amount1 token1 amount
3139      */
3140     function _liquidityForAmounts(
3141         int24 tickLower,
3142         int24 tickUpper,
3143         uint256 amount0,
3144         uint256 amount1
3145     ) internal view returns (uint128) {
3146         (uint160 sqrtRatioX96, , , , , , ) = IUniswapV3Pool(pool).slot0();
3147         return
3148             UV3Math.getLiquidityForAmounts(
3149                 sqrtRatioX96,
3150                 UV3Math.getSqrtRatioAtTick(tickLower),
3151                 UV3Math.getSqrtRatioAtTick(tickUpper),
3152                 amount0,
3153                 amount1
3154             );
3155     }
3156 
3157     /**
3158      @notice uint128Safe function
3159      @param x input value
3160      */
3161     function _uint128Safe(uint256 x) internal pure returns (uint128) {
3162         require(x <= type(uint128).max, "IV.128_OF");
3163         return uint128(x);
3164     }
3165 
3166     /**
3167      @notice Calculates total quantity of token0 and token1 in both positions (and unused in the ICHIVault)
3168      @param total0 Quantity of token0 in both positions (and unused in the ICHIVault)
3169      @param total1 Quantity of token1 in both positions (and unused in the ICHIVault)
3170      */
3171     function getTotalAmounts()
3172         public
3173         view
3174         override
3175         returns (uint256 total0, uint256 total1)
3176     {
3177         (, uint256 base0, uint256 base1) = getBasePosition();
3178         (, uint256 limit0, uint256 limit1) = getLimitPosition();
3179         total0 = IERC20(token0).balanceOf(address(this)).add(base0).add(limit0);
3180         total1 = IERC20(token1).balanceOf(address(this)).add(base1).add(limit1);
3181     }
3182 
3183     /**
3184      @notice Calculates amount of total liquidity in the base position
3185      @param liquidity Amount of total liquidity in the base position
3186      @param amount0 Estimated amount of token0 that could be collected by burning the base position
3187      @param amount1 Estimated amount of token1 that could be collected by burning the base position
3188      */
3189     function getBasePosition()
3190         public
3191         view
3192         returns (
3193             uint128 liquidity,
3194             uint256 amount0,
3195             uint256 amount1
3196         )
3197     {
3198         (
3199             uint128 positionLiquidity,
3200             uint128 tokensOwed0,
3201             uint128 tokensOwed1
3202         ) = _position(baseLower, baseUpper);
3203         (amount0, amount1) = _amountsForLiquidity(
3204             baseLower,
3205             baseUpper,
3206             positionLiquidity
3207         );
3208         liquidity = positionLiquidity;
3209         amount0 = amount0.add(uint256(tokensOwed0));
3210         amount1 = amount1.add(uint256(tokensOwed1));
3211     }
3212 
3213     /**
3214      @notice Calculates amount of total liquidity in the limit position
3215      @param liquidity Amount of total liquidity in the base position
3216      @param amount0 Estimated amount of token0 that could be collected by burning the limit position
3217      @param amount1 Estimated amount of token1 that could be collected by burning the limit position
3218      */
3219     function getLimitPosition()
3220         public
3221         view
3222         returns (
3223             uint128 liquidity,
3224             uint256 amount0,
3225             uint256 amount1
3226         )
3227     {
3228         (
3229             uint128 positionLiquidity,
3230             uint128 tokensOwed0,
3231             uint128 tokensOwed1
3232         ) = _position(limitLower, limitUpper);
3233         (amount0, amount1) = _amountsForLiquidity(
3234             limitLower,
3235             limitUpper,
3236             positionLiquidity
3237         );
3238         liquidity = positionLiquidity;
3239         amount0 = amount0.add(uint256(tokensOwed0));
3240         amount1 = amount1.add(uint256(tokensOwed1));
3241     }
3242 
3243     /**
3244      @notice Returns current price tick
3245      @param tick Uniswap pool's current price tick
3246      */
3247     function currentTick() public view returns (int24 tick) {
3248         (, int24 tick_, , , , , bool unlocked_) = IUniswapV3Pool(pool).slot0();
3249         require(unlocked_, "IV.currentTick: the pool is locked");
3250         tick = tick_;
3251     } 
3252 
3253     /**
3254      @notice returns equivalent _tokenOut for _amountIn, _tokenIn using spot price
3255      @param _tokenIn token the input amount is in
3256      @param _tokenOut token for the output amount
3257      @param _tick tick for the spot price
3258      @param _amountIn amount in _tokenIn
3259      @param amountOut equivalent anount in _tokenOut
3260      */
3261     function _fetchSpot(
3262         address _tokenIn,
3263         address _tokenOut,
3264         int24 _tick,
3265         uint256 _amountIn
3266     ) internal pure returns (uint256 amountOut) { 
3267         return
3268             UV3Math.getQuoteAtTick(
3269                 _tick,
3270                 UV3Math.toUint128(_amountIn),
3271                 _tokenIn,
3272                 _tokenOut
3273             );
3274     }
3275 
3276     /**
3277      @notice returns equivalent _tokenOut for _amountIn, _tokenIn using TWAP price
3278      @param _pool Uniswap V3 pool address to be used for price checking
3279      @param _tokenIn token the input amount is in
3280      @param _tokenOut token for the output amount
3281      @param _twapPeriod the averaging time period
3282      @param _amountIn amount in _tokenIn
3283      @param amountOut equivalent anount in _tokenOut
3284      */
3285     function _fetchTwap(
3286         address _pool,
3287         address _tokenIn,
3288         address _tokenOut,
3289         uint32 _twapPeriod,
3290         uint256 _amountIn
3291     ) internal view returns (uint256 amountOut) {
3292         // Leave twapTick as a int256 to avoid solidity casting
3293         int256 twapTick = UV3Math.consult(_pool, _twapPeriod);
3294         return
3295             UV3Math.getQuoteAtTick(
3296                 int24(twapTick), // can assume safe being result from consult()
3297                 UV3Math.toUint128(_amountIn),
3298                 _tokenIn,
3299                 _tokenOut
3300             );
3301     }
3302 }