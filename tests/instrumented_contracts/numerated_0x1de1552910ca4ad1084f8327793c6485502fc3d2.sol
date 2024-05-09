1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/utils/Context.sol
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
31 pragma solidity >=0.6.0 <0.8.0;
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
107 // File: @openzeppelin/contracts/math/SafeMath.sol
108 
109 
110 pragma solidity >=0.6.0 <0.8.0;
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, with an overflow flag.
128      *
129      * _Available since v3.4._
130      */
131     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
132         uint256 c = a + b;
133         if (c < a) return (false, 0);
134         return (true, c);
135     }
136 
137     /**
138      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
139      *
140      * _Available since v3.4._
141      */
142     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
143         if (b > a) return (false, 0);
144         return (true, a - b);
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
149      *
150      * _Available since v3.4._
151      */
152     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) return (true, 0);
157         uint256 c = a * b;
158         if (c / a != b) return (false, 0);
159         return (true, c);
160     }
161 
162     /**
163      * @dev Returns the division of two unsigned integers, with a division by zero flag.
164      *
165      * _Available since v3.4._
166      */
167     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
168         if (b == 0) return (false, 0);
169         return (true, a / b);
170     }
171 
172     /**
173      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
174      *
175      * _Available since v3.4._
176      */
177     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
178         if (b == 0) return (false, 0);
179         return (true, a % b);
180     }
181 
182     /**
183      * @dev Returns the addition of two unsigned integers, reverting on
184      * overflow.
185      *
186      * Counterpart to Solidity's `+` operator.
187      *
188      * Requirements:
189      *
190      * - Addition cannot overflow.
191      */
192     function add(uint256 a, uint256 b) internal pure returns (uint256) {
193         uint256 c = a + b;
194         require(c >= a, "SafeMath: addition overflow");
195         return c;
196     }
197 
198     /**
199      * @dev Returns the subtraction of two unsigned integers, reverting on
200      * overflow (when the result is negative).
201      *
202      * Counterpart to Solidity's `-` operator.
203      *
204      * Requirements:
205      *
206      * - Subtraction cannot overflow.
207      */
208     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
209         require(b <= a, "SafeMath: subtraction overflow");
210         return a - b;
211     }
212 
213     /**
214      * @dev Returns the multiplication of two unsigned integers, reverting on
215      * overflow.
216      *
217      * Counterpart to Solidity's `*` operator.
218      *
219      * Requirements:
220      *
221      * - Multiplication cannot overflow.
222      */
223     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
224         if (a == 0) return 0;
225         uint256 c = a * b;
226         require(c / a == b, "SafeMath: multiplication overflow");
227         return c;
228     }
229 
230     /**
231      * @dev Returns the integer division of two unsigned integers, reverting on
232      * division by zero. The result is rounded towards zero.
233      *
234      * Counterpart to Solidity's `/` operator. Note: this function uses a
235      * `revert` opcode (which leaves remaining gas untouched) while Solidity
236      * uses an invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function div(uint256 a, uint256 b) internal pure returns (uint256) {
243         require(b > 0, "SafeMath: division by zero");
244         return a / b;
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * reverting when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260         require(b > 0, "SafeMath: modulo by zero");
261         return a % b;
262     }
263 
264     /**
265      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
266      * overflow (when the result is negative).
267      *
268      * CAUTION: This function is deprecated because it requires allocating memory for the error
269      * message unnecessarily. For custom revert reasons use {trySub}.
270      *
271      * Counterpart to Solidity's `-` operator.
272      *
273      * Requirements:
274      *
275      * - Subtraction cannot overflow.
276      */
277     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
278         require(b <= a, errorMessage);
279         return a - b;
280     }
281 
282     /**
283      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
284      * division by zero. The result is rounded towards zero.
285      *
286      * CAUTION: This function is deprecated because it requires allocating memory for the error
287      * message unnecessarily. For custom revert reasons use {tryDiv}.
288      *
289      * Counterpart to Solidity's `/` operator. Note: this function uses a
290      * `revert` opcode (which leaves remaining gas untouched) while Solidity
291      * uses an invalid opcode to revert (consuming all remaining gas).
292      *
293      * Requirements:
294      *
295      * - The divisor cannot be zero.
296      */
297     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
298         require(b > 0, errorMessage);
299         return a / b;
300     }
301 
302     /**
303      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
304      * reverting with custom message when dividing by zero.
305      *
306      * CAUTION: This function is deprecated because it requires allocating memory for the error
307      * message unnecessarily. For custom revert reasons use {tryMod}.
308      *
309      * Counterpart to Solidity's `%` operator. This function uses a `revert`
310      * opcode (which leaves remaining gas untouched) while Solidity uses an
311      * invalid opcode to revert (consuming all remaining gas).
312      *
313      * Requirements:
314      *
315      * - The divisor cannot be zero.
316      */
317     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
318         require(b > 0, errorMessage);
319         return a % b;
320     }
321 }
322 
323 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
324 
325 
326 pragma solidity >=0.6.0 <0.8.0;
327 
328 
329 
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
377     constructor (string memory name_, string memory symbol_) public {
378         _name = name_;
379         _symbol = symbol_;
380         _decimals = 9;
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
632 
633 pragma solidity >=0.6.2 <0.8.0;
634 
635 /**
636  * @dev Collection of functions related to the address type
637  */
638 library Address {
639     /**
640      * @dev Returns true if `account` is a contract.
641      *
642      * [IMPORTANT]
643      * ====
644      * It is unsafe to assume that an address for which this function returns
645      * false is an externally-owned account (EOA) and not a contract.
646      *
647      * Among others, `isContract` will return false for the following
648      * types of addresses:
649      *
650      *  - an externally-owned account
651      *  - a contract in construction
652      *  - an address where a contract will be created
653      *  - an address where a contract lived, but was destroyed
654      * ====
655      */
656     function isContract(address account) internal view returns (bool) {
657         // This method relies on extcodesize, which returns 0 for contracts in
658         // construction, since the code is only stored at the end of the
659         // constructor execution.
660 
661         uint256 size;
662         // solhint-disable-next-line no-inline-assembly
663         assembly { size := extcodesize(account) }
664         return size > 0;
665     }
666 
667     /**
668      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
669      * `recipient`, forwarding all available gas and reverting on errors.
670      *
671      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
672      * of certain opcodes, possibly making contracts go over the 2300 gas limit
673      * imposed by `transfer`, making them unable to receive funds via
674      * `transfer`. {sendValue} removes this limitation.
675      *
676      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
677      *
678      * IMPORTANT: because control is transferred to `recipient`, care must be
679      * taken to not create reentrancy vulnerabilities. Consider using
680      * {ReentrancyGuard} or the
681      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
682      */
683     function sendValue(address payable recipient, uint256 amount) internal {
684         require(address(this).balance >= amount, "Address: insufficient balance");
685 
686         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
687         (bool success, ) = recipient.call{ value: amount }("");
688         require(success, "Address: unable to send value, recipient may have reverted");
689     }
690 
691     /**
692      * @dev Performs a Solidity function call using a low level `call`. A
693      * plain`call` is an unsafe replacement for a function call: use this
694      * function instead.
695      *
696      * If `target` reverts with a revert reason, it is bubbled up by this
697      * function (like regular Solidity function calls).
698      *
699      * Returns the raw returned data. To convert to the expected return value,
700      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
701      *
702      * Requirements:
703      *
704      * - `target` must be a contract.
705      * - calling `target` with `data` must not revert.
706      *
707      * _Available since v3.1._
708      */
709     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
710       return functionCall(target, data, "Address: low-level call failed");
711     }
712 
713     /**
714      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
715      * `errorMessage` as a fallback revert reason when `target` reverts.
716      *
717      * _Available since v3.1._
718      */
719     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
720         return functionCallWithValue(target, data, 0, errorMessage);
721     }
722 
723     /**
724      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
725      * but also transferring `value` wei to `target`.
726      *
727      * Requirements:
728      *
729      * - the calling contract must have an ETH balance of at least `value`.
730      * - the called Solidity function must be `payable`.
731      *
732      * _Available since v3.1._
733      */
734     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
735         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
736     }
737 
738     /**
739      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
740      * with `errorMessage` as a fallback revert reason when `target` reverts.
741      *
742      * _Available since v3.1._
743      */
744     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
745         require(address(this).balance >= value, "Address: insufficient balance for call");
746         require(isContract(target), "Address: call to non-contract");
747 
748         // solhint-disable-next-line avoid-low-level-calls
749         (bool success, bytes memory returndata) = target.call{ value: value }(data);
750         return _verifyCallResult(success, returndata, errorMessage);
751     }
752 
753     /**
754      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
755      * but performing a static call.
756      *
757      * _Available since v3.3._
758      */
759     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
760         return functionStaticCall(target, data, "Address: low-level static call failed");
761     }
762 
763     /**
764      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
765      * but performing a static call.
766      *
767      * _Available since v3.3._
768      */
769     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
770         require(isContract(target), "Address: static call to non-contract");
771 
772         // solhint-disable-next-line avoid-low-level-calls
773         (bool success, bytes memory returndata) = target.staticcall(data);
774         return _verifyCallResult(success, returndata, errorMessage);
775     }
776 
777     /**
778      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
779      * but performing a delegate call.
780      *
781      * _Available since v3.4._
782      */
783     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
784         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
785     }
786 
787     /**
788      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
789      * but performing a delegate call.
790      *
791      * _Available since v3.4._
792      */
793     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
794         require(isContract(target), "Address: delegate call to non-contract");
795 
796         // solhint-disable-next-line avoid-low-level-calls
797         (bool success, bytes memory returndata) = target.delegatecall(data);
798         return _verifyCallResult(success, returndata, errorMessage);
799     }
800 
801     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
802         if (success) {
803             return returndata;
804         } else {
805             // Look for revert reason and bubble it up if present
806             if (returndata.length > 0) {
807                 // The easiest way to bubble the revert reason is using memory via assembly
808 
809                 // solhint-disable-next-line no-inline-assembly
810                 assembly {
811                     let returndata_size := mload(returndata)
812                     revert(add(32, returndata), returndata_size)
813                 }
814             } else {
815                 revert(errorMessage);
816             }
817         }
818     }
819 }
820 
821 // File: @openzeppelin/contracts/token/ERC20/SafeERC20.sol
822 
823 
824 pragma solidity >=0.6.0 <0.8.0;
825 
826 
827 
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
897 // File: @openzeppelin/contracts/access/Ownable.sol
898 
899 
900 pragma solidity >=0.6.0 <0.8.0;
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
922     constructor () internal {
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
966 // File: @openzeppelin/contracts/utils/ReentrancyGuard.sol
967 
968 
969 pragma solidity >=0.6.0 <0.8.0;
970 
971 /**
972  * @dev Contract module that helps prevent reentrant calls to a function.
973  *
974  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
975  * available, which can be applied to functions to make sure there are no nested
976  * (reentrant) calls to them.
977  *
978  * Note that because there is a single `nonReentrant` guard, functions marked as
979  * `nonReentrant` may not call one another. This can be worked around by making
980  * those functions `private`, and then adding `external` `nonReentrant` entry
981  * points to them.
982  *
983  * TIP: If you would like to learn more about reentrancy and alternative ways
984  * to protect against it, check out our blog post
985  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
986  */
987 abstract contract ReentrancyGuard {
988     // Booleans are more expensive than uint256 or any type that takes up a full
989     // word because each write operation emits an extra SLOAD to first read the
990     // slot's contents, replace the bits taken up by the boolean, and then write
991     // back. This is the compiler's defense against contract upgrades and
992     // pointer aliasing, and it cannot be disabled.
993 
994     // The values being non-zero value makes deployment a bit more expensive,
995     // but in exchange the refund on every call to nonReentrant will be lower in
996     // amount. Since refunds are capped to a percentage of the total
997     // transaction's gas, it is best to keep them low in cases like this one, to
998     // increase the likelihood of the full refund coming into effect.
999     uint256 private constant _NOT_ENTERED = 1;
1000     uint256 private constant _ENTERED = 2;
1001 
1002     uint256 private _status;
1003 
1004     constructor () internal {
1005         _status = _NOT_ENTERED;
1006     }
1007 
1008     /**
1009      * @dev Prevents a contract from calling itself, directly or indirectly.
1010      * Calling a `nonReentrant` function from another `nonReentrant`
1011      * function is not supported. It is possible to prevent this from happening
1012      * by making the `nonReentrant` function external, and make it call a
1013      * `private` function that does the actual work.
1014      */
1015     modifier nonReentrant() {
1016         // On the first call to nonReentrant, _notEntered will be true
1017         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1018 
1019         // Any calls to nonReentrant after this point will fail
1020         _status = _ENTERED;
1021 
1022         _;
1023 
1024         // By storing the original value once again, a refund is triggered (see
1025         // https://eips.ethereum.org/EIPS/eip-2200)
1026         _status = _NOT_ENTERED;
1027     }
1028 }
1029 
1030 // File: contracts/OtherDAO/interfaces/OTHR/IStrategy.sol
1031 
1032 
1033 pragma solidity ^0.6.0;
1034 
1035 
1036 interface IStrategy {
1037     function vault() external view returns (address);
1038     function want() external view returns (IERC20);
1039     function beforeDeposit() external;
1040     function deposit() external;
1041     function withdraw(uint256) external;
1042     function balanceOf() external view returns (uint256);
1043     function balanceOfWant() external view returns (uint256);
1044     function balanceOfPool() external view returns (uint256);
1045     function harvest() external;
1046     function retireStrat() external;
1047     function panic() external;
1048     function pause() external;
1049     function unpause() external;
1050     function paused() external view returns (bool);
1051     function unirouter() external view returns (address);
1052 }
1053 
1054 // File: contracts/OTHR/vaults/OtherDAOVault.sol
1055 
1056 
1057 pragma solidity ^0.6.0;
1058 
1059 
1060 
1061 
1062 
1063 
1064 
1065 /**
1066  * @dev Implementation of a vault to deposit funds for yield optimizing.
1067  * This is the contract that receives funds and that users interface with.
1068  * The yield optimizing strategy itself is implemented in a separate 'Strategy.sol' contract.
1069  */
1070 contract OtherDAOVault is ERC20, Ownable, ReentrancyGuard {
1071     using SafeERC20 for IERC20;
1072     using SafeMath for uint256;
1073 
1074     struct StratCandidate {
1075         address implementation;
1076         uint proposedTime;
1077     }
1078 
1079     // The last proposed strategy to switch to.
1080     StratCandidate public stratCandidate;
1081     // The strategy currently in use by the vault.
1082     IStrategy public strategy;
1083     // The minimum time it has to pass before a strat candidate can be approved.
1084     uint256 public immutable approvalDelay;
1085 
1086     event NewStratCandidate(address implementation);
1087     event UpgradeStrat(address implementation);
1088 
1089     /**
1090      * @dev Sets the value of {token} to the token that the vault will
1091      * hold as underlying value. It initializes the vault's own 'othr' token.
1092      * This token is minted when someone does a deposit. It is burned in order
1093      * to withdraw the corresponding portion of the underlying assets.
1094      * @param _strategy the address of the strategy.
1095      * @param _name the name of the vault token.
1096      * @param _symbol the symbol of the vault token.
1097      * @param _approvalDelay the delay before a new strat can be approved.
1098      */
1099     constructor (
1100         IStrategy _strategy,
1101         string memory _name,
1102         string memory _symbol,
1103         uint256 _approvalDelay
1104     ) public ERC20(
1105         _name,
1106         _symbol
1107     ) {
1108         strategy = _strategy;
1109         approvalDelay = _approvalDelay;
1110     }
1111 
1112     function want() public view returns (IERC20) {
1113         return IERC20(strategy.want());
1114     }
1115 
1116     /**
1117      * @dev It calculates the total underlying value of {token} held by the system.
1118      * It takes into account the vault contract balance, the strategy contract balance
1119      *  and the balance deployed in other contracts as part of the strategy.
1120      */
1121     function balance() public view returns (uint) {
1122         return want().balanceOf(address(this)).add(IStrategy(strategy).balanceOf());
1123     }
1124 
1125     /**
1126      * @dev Custom logic in here for how much the vault allows to be borrowed.
1127      * We return 100% of tokens for now. Under certain conditions we might
1128      * want to keep some of the system funds at hand in the vault, instead
1129      * of putting them to work.
1130      */
1131     function available() public view returns (uint256) {
1132         return want().balanceOf(address(this));
1133     }
1134 
1135     /**
1136      * @dev Function for various UIs to display the current value of one of our yield tokens.
1137      * Returns an uint256 with 18 decimals of how much underlying asset one vault share represents.
1138      */
1139     function getPricePerFullShare() public view returns (uint256) {
1140         return totalSupply() == 0 ? 1e18 : balance().mul(1e18).div(totalSupply());
1141     }
1142 
1143     /**
1144      * @dev A helper function to call deposit() with all the sender's funds.
1145      */
1146     function depositAll() external {
1147         deposit(want().balanceOf(msg.sender));
1148     }
1149 
1150     /**
1151      * @dev The entrypoint of funds into the system. People deposit with this function
1152      * into the vault. The vault is then in charge of sending funds into the strategy.
1153      */
1154     function deposit(uint _amount) public nonReentrant {
1155         strategy.beforeDeposit();
1156 
1157         uint256 _pool = balance();
1158         want().safeTransferFrom(msg.sender, address(this), _amount);
1159         earn();
1160         uint256 _after = balance();
1161         _amount = _after.sub(_pool); // Additional check for deflationary tokens
1162         uint256 shares = 0;
1163         if (totalSupply() == 0) {
1164             shares = _amount;
1165         } else {
1166             shares = (_amount.mul(totalSupply())).div(_pool);
1167         }
1168         _mint(msg.sender, shares);
1169     }
1170 
1171     /**
1172      * @dev Function to send funds into the strategy and put them to work. It's primarily called
1173      * by the vault's deposit() function.
1174      */
1175     function earn() public {
1176         uint _bal = available();
1177         want().safeTransfer(address(strategy), _bal);
1178         strategy.deposit();
1179     }
1180 
1181     /**
1182      * @dev A helper function to call withdraw() with all the sender's funds.
1183      */
1184     function withdrawAll() external {
1185         withdraw(balanceOf(msg.sender));
1186     }
1187 
1188     /**
1189      * @dev Function to exit the system. The vault will withdraw the required tokens
1190      * from the strategy and pay up the token holder. A proportional number of IOU
1191      * tokens are burned in the process.
1192      */
1193     function withdraw(uint256 _shares) public {
1194         uint256 r = (balance().mul(_shares)).div(totalSupply());
1195         _burn(msg.sender, _shares);
1196 
1197         uint b = want().balanceOf(address(this));
1198         if (b < r) {
1199             uint _withdraw = r.sub(b);
1200             strategy.withdraw(_withdraw);
1201             uint _after = want().balanceOf(address(this));
1202             uint _diff = _after.sub(b);
1203             if (_diff < _withdraw) {
1204                 r = b.add(_diff);
1205             }
1206         }
1207 
1208         want().safeTransfer(msg.sender, r);
1209     }
1210 
1211     /** 
1212      * @dev Sets the candidate for the new strat to use with this vault.
1213      * @param _implementation The address of the candidate strategy.  
1214      */
1215     function proposeStrat(address _implementation) public onlyOwner {
1216         require(address(this) == IStrategy(_implementation).vault(), "Proposal not valid for this Vault");
1217         stratCandidate = StratCandidate({
1218             implementation: _implementation,
1219             proposedTime: block.timestamp
1220          });
1221 
1222         emit NewStratCandidate(_implementation);
1223     }
1224 
1225     /** 
1226      * @dev It switches the active strat for the strat candidate. After upgrading, the 
1227      * candidate implementation is set to the 0x00 address, and proposedTime to a time 
1228      * happening in +100 years for safety. 
1229      */
1230 
1231     function upgradeStrat() public onlyOwner {
1232         require(stratCandidate.implementation != address(0), "There is no candidate");
1233         require(stratCandidate.proposedTime.add(approvalDelay) < block.timestamp, "Delay has not passed");
1234 
1235         emit UpgradeStrat(stratCandidate.implementation);
1236 
1237         strategy.retireStrat();
1238         strategy = IStrategy(stratCandidate.implementation);
1239         stratCandidate.implementation = address(0);
1240         stratCandidate.proposedTime = 5000000000;
1241 
1242         earn();
1243     }
1244 
1245     /**
1246      * @dev Rescues random funds stuck that the strat can't handle.
1247      * @param _token address of the token to rescue.
1248      */
1249     function inCaseTokensGetStuck(address _token) external onlyOwner {
1250         require(_token != address(want()), "!token");
1251 
1252         uint256 amount = IERC20(_token).balanceOf(address(this));
1253         IERC20(_token).safeTransfer(msg.sender, amount);
1254     }
1255 }