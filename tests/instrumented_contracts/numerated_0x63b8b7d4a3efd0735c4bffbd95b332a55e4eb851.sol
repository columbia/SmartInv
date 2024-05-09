1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor() internal {}
19 
20     function _msgSender() internal virtual view returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal virtual view returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
31 
32 pragma solidity ^0.6.0;
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
55     function transfer(address recipient, uint256 amount)
56         external
57         returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender)
67         external
68         view
69         returns (uint256);
70 
71     /**
72      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * IMPORTANT: Beware that changing an allowance with this method brings the risk
77      * that someone may use both the old and the new allowance by unfortunate
78      * transaction ordering. One possible solution to mitigate this race
79      * condition is to first reduce the spender's allowance to 0 and set the
80      * desired value afterwards:
81      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
82      *
83      * Emits an {Approval} event.
84      */
85     function approve(address spender, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Moves `amount` tokens from `sender` to `recipient` using the
89      * allowance mechanism. `amount` is then deducted from the caller's
90      * allowance.
91      *
92      * Returns a boolean value indicating whether the operation succeeded.
93      *
94      * Emits a {Transfer} event.
95      */
96     function transferFrom(
97         address sender,
98         address recipient,
99         uint256 amount
100     ) external returns (bool);
101 
102     /**
103      * @dev Emitted when `value` tokens are moved from one account (`from`) to
104      * another (`to`).
105      *
106      * Note that `value` may be zero.
107      */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /**
111      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
112      * a call to {approve}. `value` is the new allowance.
113      */
114     event Approval(
115         address indexed owner,
116         address indexed spender,
117         uint256 value
118     );
119 }
120 
121 // File: @openzeppelin/contracts/math/SafeMath.sol
122 
123 pragma solidity ^0.6.0;
124 
125 /**
126  * @dev Wrappers over Solidity's arithmetic operations with added overflow
127  * checks.
128  *
129  * Arithmetic operations in Solidity wrap on overflow. This can easily result
130  * in bugs, because programmers usually assume that an overflow raises an
131  * error, which is the standard behavior in high level programming languages.
132  * `SafeMath` restores this intuition by reverting the transaction when an
133  * operation overflows.
134  *
135  * Using this library instead of the unchecked operations eliminates an entire
136  * class of bugs, so it's recommended to use it always.
137  */
138 library SafeMath {
139     /**
140      * @dev Returns the addition of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `+` operator.
144      *
145      * Requirements:
146      * - Addition cannot overflow.
147      */
148     function add(uint256 a, uint256 b) internal pure returns (uint256) {
149         uint256 c = a + b;
150         require(c >= a, "SafeMath: addition overflow");
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165         return sub(a, b, "SafeMath: subtraction overflow");
166     }
167 
168     /**
169      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
170      * overflow (when the result is negative).
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      * - Subtraction cannot overflow.
176      */
177     function sub(
178         uint256 a,
179         uint256 b,
180         string memory errorMessage
181     ) internal pure returns (uint256) {
182         require(b <= a, errorMessage);
183         uint256 c = a - b;
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the multiplication of two unsigned integers, reverting on
190      * overflow.
191      *
192      * Counterpart to Solidity's `*` operator.
193      *
194      * Requirements:
195      * - Multiplication cannot overflow.
196      */
197     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
198         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
199         // benefit is lost if 'b' is also tested.
200         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
201         if (a == 0) {
202             return 0;
203         }
204 
205         uint256 c = a * b;
206         require(c / a == b, "SafeMath: multiplication overflow");
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b) internal pure returns (uint256) {
223         return div(a, b, "SafeMath: division by zero");
224     }
225 
226     /**
227      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
228      * division by zero. The result is rounded towards zero.
229      *
230      * Counterpart to Solidity's `/` operator. Note: this function uses a
231      * `revert` opcode (which leaves remaining gas untouched) while Solidity
232      * uses an invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      * - The divisor cannot be zero.
236      */
237     function div(
238         uint256 a,
239         uint256 b,
240         string memory errorMessage
241     ) internal pure returns (uint256) {
242         // Solidity only automatically asserts when dividing by 0
243         require(b > 0, errorMessage);
244         uint256 c = a / b;
245         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         return mod(a, b, "SafeMath: modulo by zero");
263     }
264 
265     /**
266      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
267      * Reverts with custom message when dividing by zero.
268      *
269      * Counterpart to Solidity's `%` operator. This function uses a `revert`
270      * opcode (which leaves remaining gas untouched) while Solidity uses an
271      * invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      * - The divisor cannot be zero.
275      */
276     function mod(
277         uint256 a,
278         uint256 b,
279         string memory errorMessage
280     ) internal pure returns (uint256) {
281         require(b != 0, errorMessage);
282         return a % b;
283     }
284 }
285 
286 // File: @openzeppelin/contracts/utils/Address.sol
287 
288 pragma solidity ^0.6.2;
289 
290 /**
291  * @dev Collection of functions related to the address type
292  */
293 library Address {
294     /**
295      * @dev Returns true if `account` is a contract.
296      *
297      * [IMPORTANT]
298      * ====
299      * It is unsafe to assume that an address for which this function returns
300      * false is an externally-owned account (EOA) and not a contract.
301      *
302      * Among others, `isContract` will return false for the following
303      * types of addresses:
304      *
305      *  - an externally-owned account
306      *  - a contract in construction
307      *  - an address where a contract will be created
308      *  - an address where a contract lived, but was destroyed
309      * ====
310      */
311     function isContract(address account) internal view returns (bool) {
312         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
313         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
314         // for accounts without code, i.e. `keccak256('')`
315         bytes32 codehash;
316 
317             bytes32 accountHash
318          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
319         // solhint-disable-next-line no-inline-assembly
320         assembly {
321             codehash := extcodehash(account)
322         }
323         return (codehash != accountHash && codehash != 0x0);
324     }
325 
326     /**
327      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
328      * `recipient`, forwarding all available gas and reverting on errors.
329      *
330      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
331      * of certain opcodes, possibly making contracts go over the 2300 gas limit
332      * imposed by `transfer`, making them unable to receive funds via
333      * `transfer`. {sendValue} removes this limitation.
334      *
335      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
336      *
337      * IMPORTANT: because control is transferred to `recipient`, care must be
338      * taken to not create reentrancy vulnerabilities. Consider using
339      * {ReentrancyGuard} or the
340      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
341      */
342     function sendValue(address payable recipient, uint256 amount) internal {
343         require(
344             address(this).balance >= amount,
345             "Address: insufficient balance"
346         );
347 
348         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
349         (bool success, ) = recipient.call{value: amount}("");
350         require(
351             success,
352             "Address: unable to send value, recipient may have reverted"
353         );
354     }
355 }
356 
357 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
358 
359 pragma solidity ^0.6.0;
360 
361 /**
362  * @dev Implementation of the {IERC20} interface.
363  *
364  * This implementation is agnostic to the way tokens are created. This means
365  * that a supply mechanism has to be added in a derived contract using {_mint}.
366  * For a generic mechanism see {ERC20MinterPauser}.
367  *
368  * TIP: For a detailed writeup see our guide
369  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
370  * to implement supply mechanisms].
371  *
372  * We have followed general OpenZeppelin guidelines: functions revert instead
373  * of returning `false` on failure. This behavior is nonetheless conventional
374  * and does not conflict with the expectations of ERC20 applications.
375  *
376  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
377  * This allows applications to reconstruct the allowance for all accounts just
378  * by listening to said events. Other implementations of the EIP may not emit
379  * these events, as it isn't required by the specification.
380  *
381  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
382  * functions have been added to mitigate the well-known issues around setting
383  * allowances. See {IERC20-approve}.
384  */
385 contract ERC20 is Context, IERC20 {
386     using SafeMath for uint256;
387     using Address for address;
388 
389     mapping(address => uint256) private _balances;
390 
391     mapping(address => mapping(address => uint256)) private _allowances;
392 
393     uint256 private _totalSupply;
394 
395     string private _name;
396     string private _symbol;
397     uint8 private _decimals;
398 
399     /**
400      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
401      * a default value of 18.
402      *
403      * To select a different value for {decimals}, use {_setupDecimals}.
404      *
405      * All three of these values are immutable: they can only be set once during
406      * construction.
407      */
408     constructor(string memory name, string memory symbol) public {
409         _name = name;
410         _symbol = symbol;
411         _decimals = 18;
412     }
413 
414     /**
415      * @dev Returns the name of the token.
416      */
417     function name() public view returns (string memory) {
418         return _name;
419     }
420 
421     /**
422      * @dev Returns the symbol of the token, usually a shorter version of the
423      * name.
424      */
425     function symbol() public view returns (string memory) {
426         return _symbol;
427     }
428 
429     /**
430      * @dev Returns the number of decimals used to get its user representation.
431      * For example, if `decimals` equals `2`, a balance of `505` tokens should
432      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
433      *
434      * Tokens usually opt for a value of 18, imitating the relationship between
435      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
436      * called.
437      *
438      * NOTE: This information is only used for _display_ purposes: it in
439      * no way affects any of the arithmetic of the contract, including
440      * {IERC20-balanceOf} and {IERC20-transfer}.
441      */
442     function decimals() public view returns (uint8) {
443         return _decimals;
444     }
445 
446     /**
447      * @dev See {IERC20-totalSupply}.
448      */
449     function totalSupply() public override view returns (uint256) {
450         return _totalSupply;
451     }
452 
453     /**
454      * @dev See {IERC20-balanceOf}.
455      */
456     function balanceOf(address account) public override view returns (uint256) {
457         return _balances[account];
458     }
459 
460     /**
461      * @dev See {IERC20-transfer}.
462      *
463      * Requirements:
464      *
465      * - `recipient` cannot be the zero address.
466      * - the caller must have a balance of at least `amount`.
467      */
468     function transfer(address recipient, uint256 amount)
469         public
470         virtual
471         override
472         returns (bool)
473     {
474         _transfer(_msgSender(), recipient, amount);
475         return true;
476     }
477 
478     /**
479      * @dev See {IERC20-allowance}.
480      */
481     function allowance(address owner, address spender)
482         public
483         virtual
484         override
485         view
486         returns (uint256)
487     {
488         return _allowances[owner][spender];
489     }
490 
491     /**
492      * @dev See {IERC20-approve}.
493      *
494      * Requirements:
495      *
496      * - `spender` cannot be the zero address.
497      */
498     function approve(address spender, uint256 amount)
499         public
500         virtual
501         override
502         returns (bool)
503     {
504         _approve(_msgSender(), spender, amount);
505         return true;
506     }
507 
508     /**
509      * @dev See {IERC20-transferFrom}.
510      *
511      * Emits an {Approval} event indicating the updated allowance. This is not
512      * required by the EIP. See the note at the beginning of {ERC20};
513      *
514      * Requirements:
515      * - `sender` and `recipient` cannot be the zero address.
516      * - `sender` must have a balance of at least `amount`.
517      * - the caller must have allowance for ``sender``'s tokens of at least
518      * `amount`.
519      */
520     function transferFrom(
521         address sender,
522         address recipient,
523         uint256 amount
524     ) public virtual override returns (bool) {
525         _transfer(sender, recipient, amount);
526         _approve(
527             sender,
528             _msgSender(),
529             _allowances[sender][_msgSender()].sub(
530                 amount,
531                 "ERC20: transfer amount exceeds allowance"
532             )
533         );
534         return true;
535     }
536 
537     /**
538      * @dev Atomically increases the allowance granted to `spender` by the caller.
539      *
540      * This is an alternative to {approve} that can be used as a mitigation for
541      * problems described in {IERC20-approve}.
542      *
543      * Emits an {Approval} event indicating the updated allowance.
544      *
545      * Requirements:
546      *
547      * - `spender` cannot be the zero address.
548      */
549     function increaseAllowance(address spender, uint256 addedValue)
550         public
551         virtual
552         returns (bool)
553     {
554         _approve(
555             _msgSender(),
556             spender,
557             _allowances[_msgSender()][spender].add(addedValue)
558         );
559         return true;
560     }
561 
562     /**
563      * @dev Atomically decreases the allowance granted to `spender` by the caller.
564      *
565      * This is an alternative to {approve} that can be used as a mitigation for
566      * problems described in {IERC20-approve}.
567      *
568      * Emits an {Approval} event indicating the updated allowance.
569      *
570      * Requirements:
571      *
572      * - `spender` cannot be the zero address.
573      * - `spender` must have allowance for the caller of at least
574      * `subtractedValue`.
575      */
576     function decreaseAllowance(address spender, uint256 subtractedValue)
577         public
578         virtual
579         returns (bool)
580     {
581         _approve(
582             _msgSender(),
583             spender,
584             _allowances[_msgSender()][spender].sub(
585                 subtractedValue,
586                 "ERC20: decreased allowance below zero"
587             )
588         );
589         return true;
590     }
591 
592     /**
593      * @dev Moves tokens `amount` from `sender` to `recipient`.
594      *
595      * This is internal function is equivalent to {transfer}, and can be used to
596      * e.g. implement automatic token fees, slashing mechanisms, etc.
597      *
598      * Emits a {Transfer} event.
599      *
600      * Requirements:
601      *
602      * - `sender` cannot be the zero address.
603      * - `recipient` cannot be the zero address.
604      * - `sender` must have a balance of at least `amount`.
605      */
606     function _transfer(
607         address sender,
608         address recipient,
609         uint256 amount
610     ) internal virtual {
611         require(sender != address(0), "ERC20: transfer from the zero address");
612         require(recipient != address(0), "ERC20: transfer to the zero address");
613 
614         _beforeTokenTransfer(sender, recipient, amount);
615 
616         _balances[sender] = _balances[sender].sub(
617             amount,
618             "ERC20: transfer amount exceeds balance"
619         );
620         _balances[recipient] = _balances[recipient].add(amount);
621         emit Transfer(sender, recipient, amount);
622     }
623 
624     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
625      * the total supply.
626      *
627      * Emits a {Transfer} event with `from` set to the zero address.
628      *
629      * Requirements
630      *
631      * - `to` cannot be the zero address.
632      */
633     function _mint(address account, uint256 amount) internal virtual {
634         require(account != address(0), "ERC20: mint to the zero address");
635 
636         _beforeTokenTransfer(address(0), account, amount);
637 
638         _totalSupply = _totalSupply.add(amount);
639         _balances[account] = _balances[account].add(amount);
640         emit Transfer(address(0), account, amount);
641     }
642 
643     /**
644      * @dev Destroys `amount` tokens from `account`, reducing the
645      * total supply.
646      *
647      * Emits a {Transfer} event with `to` set to the zero address.
648      *
649      * Requirements
650      *
651      * - `account` cannot be the zero address.
652      * - `account` must have at least `amount` tokens.
653      */
654     function _burn(address account, uint256 amount) internal virtual {
655         require(account != address(0), "ERC20: burn from the zero address");
656 
657         _beforeTokenTransfer(account, address(0), amount);
658 
659         _balances[account] = _balances[account].sub(
660             amount,
661             "ERC20: burn amount exceeds balance"
662         );
663         _totalSupply = _totalSupply.sub(amount);
664         emit Transfer(account, address(0), amount);
665     }
666 
667     /**
668      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
669      *
670      * This is internal function is equivalent to `approve`, and can be used to
671      * e.g. set automatic allowances for certain subsystems, etc.
672      *
673      * Emits an {Approval} event.
674      *
675      * Requirements:
676      *
677      * - `owner` cannot be the zero address.
678      * - `spender` cannot be the zero address.
679      */
680     function _approve(
681         address owner,
682         address spender,
683         uint256 amount
684     ) internal virtual {
685         require(owner != address(0), "ERC20: approve from the zero address");
686         require(spender != address(0), "ERC20: approve to the zero address");
687 
688         _allowances[owner][spender] = amount;
689         emit Approval(owner, spender, amount);
690     }
691 
692     /**
693      * @dev Sets {decimals} to a value other than the default one of 18.
694      *
695      * WARNING: This function should only be called from the constructor. Most
696      * applications that interact with token contracts will not expect
697      * {decimals} to ever change, and may work incorrectly if it does.
698      */
699     function _setupDecimals(uint8 decimals_) internal {
700         _decimals = decimals_;
701     }
702 
703     /**
704      * @dev Hook that is called before any transfer of tokens. This includes
705      * minting and burning.
706      *
707      * Calling conditions:
708      *
709      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
710      * will be to transferred to `to`.
711      * - when `from` is zero, `amount` tokens will be minted for `to`.
712      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
713      * - `from` and `to` are never both zero.
714      *
715      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
716      */
717     function _beforeTokenTransfer(
718         address from,
719         address to,
720         uint256 amount
721     ) internal virtual {}
722 }
723 
724 // File: @openzeppelin/contracts/token/ERC20/ERC20Capped.sol
725 
726 pragma solidity ^0.6.0;
727 
728 /**
729  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
730  */
731 abstract contract ERC20Capped is ERC20 {
732     uint256 private _cap;
733 
734     /**
735      * @dev Sets the value of the `cap`. This value is immutable, it can only be
736      * set once during construction.
737      */
738     constructor(uint256 cap) public {
739         require(cap > 0, "ERC20Capped: cap is 0");
740         _cap = cap;
741     }
742 
743     /**
744      * @dev Returns the cap on the token's total supply.
745      */
746     function cap() public view returns (uint256) {
747         return _cap;
748     }
749 
750     /**
751      * @dev See {ERC20-_beforeTokenTransfer}.
752      *
753      * Requirements:
754      *
755      * - minted tokens must not cause the total supply to go over the cap.
756      */
757     function _beforeTokenTransfer(
758         address from,
759         address to,
760         uint256 amount
761     ) internal virtual override {
762         super._beforeTokenTransfer(from, to, amount);
763 
764         if (from == address(0)) {
765             // When minting tokens
766             require(
767                 totalSupply().add(amount) <= _cap,
768                 "ERC20Capped: cap exceeded"
769             );
770         }
771     }
772 }
773 
774 // File: @openzeppelin/contracts/token/ERC20/ERC20Burnable.sol
775 
776 pragma solidity ^0.6.0;
777 
778 /**
779  * @dev Extension of {ERC20} that allows token holders to destroy both their own
780  * tokens and those that they have an allowance for, in a way that can be
781  * recognized off-chain (via event analysis).
782  */
783 abstract contract ERC20Burnable is Context, ERC20 {
784     /**
785      * @dev Destroys `amount` tokens from the caller.
786      *
787      * See {ERC20-_burn}.
788      */
789     function burn(uint256 amount) public virtual {
790         _burn(_msgSender(), amount);
791     }
792 
793     /**
794      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
795      * allowance.
796      *
797      * See {ERC20-_burn} and {ERC20-allowance}.
798      *
799      * Requirements:
800      *
801      * - the caller must have allowance for ``accounts``'s tokens of at least
802      * `amount`.
803      */
804     function burnFrom(address account, uint256 amount) public virtual {
805         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(
806             amount,
807             "ERC20: burn amount exceeds allowance"
808         );
809 
810         _approve(account, _msgSender(), decreasedAllowance);
811         _burn(account, amount);
812     }
813 }
814 
815 // File: @openzeppelin/contracts/introspection/IERC165.sol
816 
817 pragma solidity ^0.6.0;
818 
819 /**
820  * @dev Interface of the ERC165 standard, as defined in the
821  * https://eips.ethereum.org/EIPS/eip-165[EIP].
822  *
823  * Implementers can declare support of contract interfaces, which can then be
824  * queried by others ({ERC165Checker}).
825  *
826  * For an implementation, see {ERC165}.
827  */
828 interface IERC165 {
829     /**
830      * @dev Returns true if this contract implements the interface defined by
831      * `interfaceId`. See the corresponding
832      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
833      * to learn more about how these ids are created.
834      *
835      * This function call must use less than 30 000 gas.
836      */
837     function supportsInterface(bytes4 interfaceId) external view returns (bool);
838 }
839 
840 // File: erc-payable-token/contracts/token/ERC1363/IERC1363.sol
841 
842 pragma solidity ^0.6.0;
843 
844 /**
845  * @title IERC1363 Interface
846  * @dev Interface for a Payable Token contract as defined in
847  *  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1363.md
848  */
849 interface IERC1363 is IERC20, IERC165 {
850     /*
851      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
852      * 0x4bbee2df ===
853      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
854      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
855      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
856      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
857      */
858 
859     /*
860      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
861      * 0xfb9ec8ce ===
862      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
863      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
864      */
865 
866     /**
867      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
868      * @param to address The address which you want to transfer to
869      * @param value uint256 The amount of tokens to be transferred
870      * @return true unless throwing
871      */
872     function transferAndCall(address to, uint256 value) external returns (bool);
873 
874     /**
875      * @notice Transfer tokens from `msg.sender` to another address and then call `onTransferReceived` on receiver
876      * @param to address The address which you want to transfer to
877      * @param value uint256 The amount of tokens to be transferred
878      * @param data bytes Additional data with no specified format, sent in call to `to`
879      * @return true unless throwing
880      */
881     function transferAndCall(
882         address to,
883         uint256 value,
884         bytes calldata data
885     ) external returns (bool);
886 
887     /**
888      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
889      * @param from address The address which you want to send tokens from
890      * @param to address The address which you want to transfer to
891      * @param value uint256 The amount of tokens to be transferred
892      * @return true unless throwing
893      */
894     function transferFromAndCall(
895         address from,
896         address to,
897         uint256 value
898     ) external returns (bool);
899 
900     /**
901      * @notice Transfer tokens from one address to another and then call `onTransferReceived` on receiver
902      * @param from address The address which you want to send tokens from
903      * @param to address The address which you want to transfer to
904      * @param value uint256 The amount of tokens to be transferred
905      * @param data bytes Additional data with no specified format, sent in call to `to`
906      * @return true unless throwing
907      */
908     function transferFromAndCall(
909         address from,
910         address to,
911         uint256 value,
912         bytes calldata data
913     ) external returns (bool);
914 
915     /**
916      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
917      * and then call `onApprovalReceived` on spender.
918      * Beware that changing an allowance with this method brings the risk that someone may use both the old
919      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
920      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
921      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
922      * @param spender address The address which will spend the funds
923      * @param value uint256 The amount of tokens to be spent
924      */
925     function approveAndCall(address spender, uint256 value)
926         external
927         returns (bool);
928 
929     /**
930      * @notice Approve the passed address to spend the specified amount of tokens on behalf of msg.sender
931      * and then call `onApprovalReceived` on spender.
932      * Beware that changing an allowance with this method brings the risk that someone may use both the old
933      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
934      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
935      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
936      * @param spender address The address which will spend the funds
937      * @param value uint256 The amount of tokens to be spent
938      * @param data bytes Additional data with no specified format, sent in call to `spender`
939      */
940     function approveAndCall(
941         address spender,
942         uint256 value,
943         bytes calldata data
944     ) external returns (bool);
945 }
946 
947 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Receiver.sol
948 
949 pragma solidity ^0.6.0;
950 
951 /**
952  * @title IERC1363Receiver Interface
953  * @dev Interface for any contract that wants to support transferAndCall or transferFromAndCall
954  *  from ERC1363 token contracts as defined in
955  *  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1363.md
956  */
957 interface IERC1363Receiver {
958     /*
959      * Note: the ERC-165 identifier for this interface is 0x88a7ca5c.
960      * 0x88a7ca5c === bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))
961      */
962 
963     /**
964      * @notice Handle the receipt of ERC1363 tokens
965      * @dev Any ERC1363 smart contract calls this function on the recipient
966      * after a `transfer` or a `transferFrom`. This function MAY throw to revert and reject the
967      * transfer. Return of other than the magic value MUST result in the
968      * transaction being reverted.
969      * Note: the token contract address is always the message sender.
970      * @param operator address The address which called `transferAndCall` or `transferFromAndCall` function
971      * @param from address The address which are token transferred from
972      * @param value uint256 The amount of tokens transferred
973      * @param data bytes Additional data with no specified format
974      * @return `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
975      *  unless throwing
976      */
977     function onTransferReceived(
978         address operator,
979         address from,
980         uint256 value,
981         bytes calldata data
982     ) external returns (bytes4); // solhint-disable-line  max-line-length
983 }
984 
985 // File: erc-payable-token/contracts/token/ERC1363/IERC1363Spender.sol
986 
987 pragma solidity ^0.6.0;
988 
989 /**
990  * @title IERC1363Spender Interface
991  * @dev Interface for any contract that wants to support approveAndCall
992  *  from ERC1363 token contracts as defined in
993  *  https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1363.md
994  */
995 interface IERC1363Spender {
996     /*
997      * Note: the ERC-165 identifier for this interface is 0x7b04a2d0.
998      * 0x7b04a2d0 === bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))
999      */
1000 
1001     /**
1002      * @notice Handle the approval of ERC1363 tokens
1003      * @dev Any ERC1363 smart contract calls this function on the recipient
1004      * after an `approve`. This function MAY throw to revert and reject the
1005      * approval. Return of other than the magic value MUST result in the
1006      * transaction being reverted.
1007      * Note: the token contract address is always the message sender.
1008      * @param owner address The address which called `approveAndCall` function
1009      * @param value uint256 The amount of tokens to be spent
1010      * @param data bytes Additional data with no specified format
1011      * @return `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1012      *  unless throwing
1013      */
1014     function onApprovalReceived(
1015         address owner,
1016         uint256 value,
1017         bytes calldata data
1018     ) external returns (bytes4);
1019 }
1020 
1021 // File: @openzeppelin/contracts/introspection/ERC165Checker.sol
1022 
1023 pragma solidity ^0.6.2;
1024 
1025 /**
1026  * @dev Library used to query support of an interface declared via {IERC165}.
1027  *
1028  * Note that these functions return the actual result of the query: they do not
1029  * `revert` if an interface is not supported. It is up to the caller to decide
1030  * what to do in these cases.
1031  */
1032 library ERC165Checker {
1033     // As per the EIP-165 spec, no interface should ever match 0xffffffff
1034     bytes4 private constant _INTERFACE_ID_INVALID = 0xffffffff;
1035 
1036     /*
1037      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1038      */
1039     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1040 
1041     /**
1042      * @dev Returns true if `account` supports the {IERC165} interface,
1043      */
1044     function supportsERC165(address account) internal view returns (bool) {
1045         // Any contract that implements ERC165 must explicitly indicate support of
1046         // InterfaceId_ERC165 and explicitly indicate non-support of InterfaceId_Invalid
1047         return
1048             _supportsERC165Interface(account, _INTERFACE_ID_ERC165) &&
1049             !_supportsERC165Interface(account, _INTERFACE_ID_INVALID);
1050     }
1051 
1052     /**
1053      * @dev Returns true if `account` supports the interface defined by
1054      * `interfaceId`. Support for {IERC165} itself is queried automatically.
1055      *
1056      * See {IERC165-supportsInterface}.
1057      */
1058     function supportsInterface(address account, bytes4 interfaceId)
1059         internal
1060         view
1061         returns (bool)
1062     {
1063         // query support of both ERC165 as per the spec and support of _interfaceId
1064         return
1065             supportsERC165(account) &&
1066             _supportsERC165Interface(account, interfaceId);
1067     }
1068 
1069     /**
1070      * @dev Returns true if `account` supports all the interfaces defined in
1071      * `interfaceIds`. Support for {IERC165} itself is queried automatically.
1072      *
1073      * Batch-querying can lead to gas savings by skipping repeated checks for
1074      * {IERC165} support.
1075      *
1076      * See {IERC165-supportsInterface}.
1077      */
1078     function supportsAllInterfaces(
1079         address account,
1080         bytes4[] memory interfaceIds
1081     ) internal view returns (bool) {
1082         // query support of ERC165 itself
1083         if (!supportsERC165(account)) {
1084             return false;
1085         }
1086 
1087         // query support of each interface in _interfaceIds
1088         for (uint256 i = 0; i < interfaceIds.length; i++) {
1089             if (!_supportsERC165Interface(account, interfaceIds[i])) {
1090                 return false;
1091             }
1092         }
1093 
1094         // all interfaces supported
1095         return true;
1096     }
1097 
1098     /**
1099      * @notice Query if a contract implements an interface, does not check ERC165 support
1100      * @param account The address of the contract to query for support of an interface
1101      * @param interfaceId The interface identifier, as specified in ERC-165
1102      * @return true if the contract at account indicates support of the interface with
1103      * identifier interfaceId, false otherwise
1104      * @dev Assumes that account contains a contract that supports ERC165, otherwise
1105      * the behavior of this method is undefined. This precondition can be checked
1106      * with {supportsERC165}.
1107      * Interface identification is specified in ERC-165.
1108      */
1109     function _supportsERC165Interface(address account, bytes4 interfaceId)
1110         private
1111         view
1112         returns (bool)
1113     {
1114         // success determines whether the staticcall succeeded and result determines
1115         // whether the contract at account indicates support of _interfaceId
1116         (bool success, bool result) = _callERC165SupportsInterface(
1117             account,
1118             interfaceId
1119         );
1120 
1121         return (success && result);
1122     }
1123 
1124     /**
1125      * @notice Calls the function with selector 0x01ffc9a7 (ERC165) and suppresses throw
1126      * @param account The address of the contract to query for support of an interface
1127      * @param interfaceId The interface identifier, as specified in ERC-165
1128      * @return success true if the STATICCALL succeeded, false otherwise
1129      * @return result true if the STATICCALL succeeded and the contract at account
1130      * indicates support of the interface with identifier interfaceId, false otherwise
1131      */
1132     function _callERC165SupportsInterface(address account, bytes4 interfaceId)
1133         private
1134         view
1135         returns (bool, bool)
1136     {
1137         bytes memory encodedParams = abi.encodeWithSelector(
1138             _INTERFACE_ID_ERC165,
1139             interfaceId
1140         );
1141         (bool success, bytes memory result) = account.staticcall{gas: 30000}(
1142             encodedParams
1143         );
1144         if (result.length < 32) return (false, false);
1145         return (success, abi.decode(result, (bool)));
1146     }
1147 }
1148 
1149 // File: @openzeppelin/contracts/introspection/ERC165.sol
1150 
1151 pragma solidity ^0.6.0;
1152 
1153 /**
1154  * @dev Implementation of the {IERC165} interface.
1155  *
1156  * Contracts may inherit from this and call {_registerInterface} to declare
1157  * their support of an interface.
1158  */
1159 contract ERC165 is IERC165 {
1160     /*
1161      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1162      */
1163     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1164 
1165     /**
1166      * @dev Mapping of interface ids to whether or not it's supported.
1167      */
1168     mapping(bytes4 => bool) private _supportedInterfaces;
1169 
1170     constructor() internal {
1171         // Derived contracts need only register support for their own interfaces,
1172         // we register support for ERC165 itself here
1173         _registerInterface(_INTERFACE_ID_ERC165);
1174     }
1175 
1176     /**
1177      * @dev See {IERC165-supportsInterface}.
1178      *
1179      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1180      */
1181     function supportsInterface(bytes4 interfaceId)
1182         public
1183         override
1184         view
1185         returns (bool)
1186     {
1187         return _supportedInterfaces[interfaceId];
1188     }
1189 
1190     /**
1191      * @dev Registers the contract as an implementer of the interface defined by
1192      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1193      * registering its interface id is not required.
1194      *
1195      * See {IERC165-supportsInterface}.
1196      *
1197      * Requirements:
1198      *
1199      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1200      */
1201     function _registerInterface(bytes4 interfaceId) internal virtual {
1202         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1203         _supportedInterfaces[interfaceId] = true;
1204     }
1205 }
1206 
1207 // File: erc-payable-token/contracts/token/ERC1363/ERC1363.sol
1208 
1209 pragma solidity ^0.6.0;
1210 
1211 /**
1212  * @title ERC1363
1213  * @dev Implementation of an ERC1363 interface
1214  */
1215 contract ERC1363 is ERC20, IERC1363, ERC165 {
1216     using Address for address;
1217 
1218     /*
1219      * Note: the ERC-165 identifier for this interface is 0x4bbee2df.
1220      * 0x4bbee2df ===
1221      *   bytes4(keccak256('transferAndCall(address,uint256)')) ^
1222      *   bytes4(keccak256('transferAndCall(address,uint256,bytes)')) ^
1223      *   bytes4(keccak256('transferFromAndCall(address,address,uint256)')) ^
1224      *   bytes4(keccak256('transferFromAndCall(address,address,uint256,bytes)'))
1225      */
1226     bytes4 internal constant _INTERFACE_ID_ERC1363_TRANSFER = 0x4bbee2df;
1227 
1228     /*
1229      * Note: the ERC-165 identifier for this interface is 0xfb9ec8ce.
1230      * 0xfb9ec8ce ===
1231      *   bytes4(keccak256('approveAndCall(address,uint256)')) ^
1232      *   bytes4(keccak256('approveAndCall(address,uint256,bytes)'))
1233      */
1234     bytes4 internal constant _INTERFACE_ID_ERC1363_APPROVE = 0xfb9ec8ce;
1235 
1236     // Equals to `bytes4(keccak256("onTransferReceived(address,address,uint256,bytes)"))`
1237     // which can be also obtained as `IERC1363Receiver(0).onTransferReceived.selector`
1238     bytes4 private constant _ERC1363_RECEIVED = 0x88a7ca5c;
1239 
1240     // Equals to `bytes4(keccak256("onApprovalReceived(address,uint256,bytes)"))`
1241     // which can be also obtained as `IERC1363Spender(0).onApprovalReceived.selector`
1242     bytes4 private constant _ERC1363_APPROVED = 0x7b04a2d0;
1243 
1244     /**
1245      * @param name Name of the token
1246      * @param symbol A symbol to be used as ticker
1247      */
1248     constructor(string memory name, string memory symbol)
1249         public
1250         payable
1251         ERC20(name, symbol)
1252     {
1253         // register the supported interfaces to conform to ERC1363 via ERC165
1254         _registerInterface(_INTERFACE_ID_ERC1363_TRANSFER);
1255         _registerInterface(_INTERFACE_ID_ERC1363_APPROVE);
1256     }
1257 
1258     /**
1259      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1260      * @param to The address to transfer to.
1261      * @param value The amount to be transferred.
1262      * @return A boolean that indicates if the operation was successful.
1263      */
1264     function transferAndCall(address to, uint256 value)
1265         public
1266         override
1267         returns (bool)
1268     {
1269         return transferAndCall(to, value, "");
1270     }
1271 
1272     /**
1273      * @dev Transfer tokens to a specified address and then execute a callback on recipient.
1274      * @param to The address to transfer to
1275      * @param value The amount to be transferred
1276      * @param data Additional data with no specified format
1277      * @return A boolean that indicates if the operation was successful.
1278      */
1279     function transferAndCall(
1280         address to,
1281         uint256 value,
1282         bytes memory data
1283     ) public override returns (bool) {
1284         transfer(to, value);
1285         require(
1286             _checkAndCallTransfer(_msgSender(), to, value, data),
1287             "ERC1363: _checkAndCallTransfer reverts"
1288         );
1289         return true;
1290     }
1291 
1292     /**
1293      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1294      * @param from The address which you want to send tokens from
1295      * @param to The address which you want to transfer to
1296      * @param value The amount of tokens to be transferred
1297      * @return A boolean that indicates if the operation was successful.
1298      */
1299     function transferFromAndCall(
1300         address from,
1301         address to,
1302         uint256 value
1303     ) public override returns (bool) {
1304         return transferFromAndCall(from, to, value, "");
1305     }
1306 
1307     /**
1308      * @dev Transfer tokens from one address to another and then execute a callback on recipient.
1309      * @param from The address which you want to send tokens from
1310      * @param to The address which you want to transfer to
1311      * @param value The amount of tokens to be transferred
1312      * @param data Additional data with no specified format
1313      * @return A boolean that indicates if the operation was successful.
1314      */
1315     function transferFromAndCall(
1316         address from,
1317         address to,
1318         uint256 value,
1319         bytes memory data
1320     ) public override returns (bool) {
1321         transferFrom(from, to, value);
1322         require(
1323             _checkAndCallTransfer(from, to, value, data),
1324             "ERC1363: _checkAndCallTransfer reverts"
1325         );
1326         return true;
1327     }
1328 
1329     /**
1330      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1331      * @param spender The address allowed to transfer to
1332      * @param value The amount allowed to be transferred
1333      * @return A boolean that indicates if the operation was successful.
1334      */
1335     function approveAndCall(address spender, uint256 value)
1336         public
1337         override
1338         returns (bool)
1339     {
1340         return approveAndCall(spender, value, "");
1341     }
1342 
1343     /**
1344      * @dev Approve spender to transfer tokens and then execute a callback on recipient.
1345      * @param spender The address allowed to transfer to.
1346      * @param value The amount allowed to be transferred.
1347      * @param data Additional data with no specified format.
1348      * @return A boolean that indicates if the operation was successful.
1349      */
1350     function approveAndCall(
1351         address spender,
1352         uint256 value,
1353         bytes memory data
1354     ) public override returns (bool) {
1355         approve(spender, value);
1356         require(
1357             _checkAndCallApprove(spender, value, data),
1358             "ERC1363: _checkAndCallApprove reverts"
1359         );
1360         return true;
1361     }
1362 
1363     /**
1364      * @dev Internal function to invoke `onTransferReceived` on a target address
1365      *  The call is not executed if the target address is not a contract
1366      * @param from address Representing the previous owner of the given token value
1367      * @param to address Target address that will receive the tokens
1368      * @param value uint256 The amount mount of tokens to be transferred
1369      * @param data bytes Optional data to send along with the call
1370      * @return whether the call correctly returned the expected magic value
1371      */
1372     function _checkAndCallTransfer(
1373         address from,
1374         address to,
1375         uint256 value,
1376         bytes memory data
1377     ) internal returns (bool) {
1378         if (!to.isContract()) {
1379             return false;
1380         }
1381         bytes4 retval = IERC1363Receiver(to).onTransferReceived(
1382             _msgSender(),
1383             from,
1384             value,
1385             data
1386         );
1387         return (retval == _ERC1363_RECEIVED);
1388     }
1389 
1390     /**
1391      * @dev Internal function to invoke `onApprovalReceived` on a target address
1392      *  The call is not executed if the target address is not a contract
1393      * @param spender address The address which will spend the funds
1394      * @param value uint256 The amount of tokens to be spent
1395      * @param data bytes Optional data to send along with the call
1396      * @return whether the call correctly returned the expected magic value
1397      */
1398     function _checkAndCallApprove(
1399         address spender,
1400         uint256 value,
1401         bytes memory data
1402     ) internal returns (bool) {
1403         if (!spender.isContract()) {
1404             return false;
1405         }
1406         bytes4 retval = IERC1363Spender(spender).onApprovalReceived(
1407             _msgSender(),
1408             value,
1409             data
1410         );
1411         return (retval == _ERC1363_APPROVED);
1412     }
1413 }
1414 
1415 // File: @openzeppelin/contracts/access/Ownable.sol
1416 
1417 pragma solidity ^0.6.0;
1418 
1419 /**
1420  * @dev Contract module which provides a basic access control mechanism, where
1421  * there is an account (an owner) that can be granted exclusive access to
1422  * specific functions.
1423  *
1424  * By default, the owner account will be the one that deploys the contract. This
1425  * can later be changed with {transferOwnership}.
1426  *
1427  * This module is used through inheritance. It will make available the modifier
1428  * `onlyOwner`, which can be applied to your functions to restrict their use to
1429  * the owner.
1430  */
1431 contract Ownable is Context {
1432     address private _owner;
1433 
1434     event OwnershipTransferred(
1435         address indexed previousOwner,
1436         address indexed newOwner
1437     );
1438 
1439     /**
1440      * @dev Initializes the contract setting the deployer as the initial owner.
1441      */
1442     constructor() internal {
1443         address msgSender = _msgSender();
1444         _owner = msgSender;
1445         emit OwnershipTransferred(address(0), msgSender);
1446     }
1447 
1448     /**
1449      * @dev Returns the address of the current owner.
1450      */
1451     function owner() public view returns (address) {
1452         return _owner;
1453     }
1454 
1455     /**
1456      * @dev Throws if called by any account other than the owner.
1457      */
1458     modifier onlyOwner() {
1459         require(_owner == _msgSender(), "Ownable: caller is not the owner");
1460         _;
1461     }
1462 
1463     /**
1464      * @dev Leaves the contract without owner. It will not be possible to call
1465      * `onlyOwner` functions anymore. Can only be called by the current owner.
1466      *
1467      * NOTE: Renouncing ownership will leave the contract without an owner,
1468      * thereby removing any functionality that is only available to the owner.
1469      */
1470     function renounceOwnership() public virtual onlyOwner {
1471         emit OwnershipTransferred(_owner, address(0));
1472         _owner = address(0);
1473     }
1474 
1475     /**
1476      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1477      * Can only be called by the current owner.
1478      */
1479     function transferOwnership(address newOwner) public virtual onlyOwner {
1480         require(
1481             newOwner != address(0),
1482             "Ownable: new owner is the zero address"
1483         );
1484         emit OwnershipTransferred(_owner, newOwner);
1485         _owner = newOwner;
1486     }
1487 }
1488 
1489 // File: eth-token-recover/contracts/TokenRecover.sol
1490 
1491 pragma solidity ^0.6.0;
1492 
1493 /**
1494  * @title TokenRecover
1495  * @dev Allow to recover any ERC20 sent into the contract for error
1496  */
1497 contract TokenRecover is Ownable {
1498     /**
1499      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
1500      * @param tokenAddress The token contract address
1501      * @param tokenAmount Number of tokens to be sent
1502      */
1503     function recoverERC20(address tokenAddress, uint256 tokenAmount)
1504         public
1505         onlyOwner
1506     {
1507         IERC20(tokenAddress).transfer(owner(), tokenAmount);
1508     }
1509 }
1510 
1511 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
1512 
1513 pragma solidity ^0.6.0;
1514 
1515 /**
1516  * @dev Library for managing
1517  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1518  * types.
1519  *
1520  * Sets have the following properties:
1521  *
1522  * - Elements are added, removed, and checked for existence in constant time
1523  * (O(1)).
1524  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1525  *
1526  * ```
1527  * contract Example {
1528  *     // Add the library methods
1529  *     using EnumerableSet for EnumerableSet.AddressSet;
1530  *
1531  *     // Declare a set state variable
1532  *     EnumerableSet.AddressSet private mySet;
1533  * }
1534  * ```
1535  *
1536  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
1537  * (`UintSet`) are supported.
1538  */
1539 library EnumerableSet {
1540     // To implement this library for multiple types with as little code
1541     // repetition as possible, we write it in terms of a generic Set type with
1542     // bytes32 values.
1543     // The Set implementation uses private functions, and user-facing
1544     // implementations (such as AddressSet) are just wrappers around the
1545     // underlying Set.
1546     // This means that we can only create new EnumerableSets for types that fit
1547     // in bytes32.
1548 
1549     struct Set {
1550         // Storage of set values
1551         bytes32[] _values;
1552         // Position of the value in the `values` array, plus 1 because index 0
1553         // means a value is not in the set.
1554         mapping(bytes32 => uint256) _indexes;
1555     }
1556 
1557     /**
1558      * @dev Add a value to a set. O(1).
1559      *
1560      * Returns true if the value was added to the set, that is if it was not
1561      * already present.
1562      */
1563     function _add(Set storage set, bytes32 value) private returns (bool) {
1564         if (!_contains(set, value)) {
1565             set._values.push(value);
1566             // The value is stored at length-1, but we add 1 to all indexes
1567             // and use 0 as a sentinel value
1568             set._indexes[value] = set._values.length;
1569             return true;
1570         } else {
1571             return false;
1572         }
1573     }
1574 
1575     /**
1576      * @dev Removes a value from a set. O(1).
1577      *
1578      * Returns true if the value was removed from the set, that is if it was
1579      * present.
1580      */
1581     function _remove(Set storage set, bytes32 value) private returns (bool) {
1582         // We read and store the value's index to prevent multiple reads from the same storage slot
1583         uint256 valueIndex = set._indexes[value];
1584 
1585         if (valueIndex != 0) {
1586             // Equivalent to contains(set, value)
1587             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1588             // the array, and then remove the last element (sometimes called as 'swap and pop').
1589             // This modifies the order of the array, as noted in {at}.
1590 
1591             uint256 toDeleteIndex = valueIndex - 1;
1592             uint256 lastIndex = set._values.length - 1;
1593 
1594             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1595             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1596 
1597             bytes32 lastvalue = set._values[lastIndex];
1598 
1599             // Move the last value to the index where the value to delete is
1600             set._values[toDeleteIndex] = lastvalue;
1601             // Update the index for the moved value
1602             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1603 
1604             // Delete the slot where the moved value was stored
1605             set._values.pop();
1606 
1607             // Delete the index for the deleted slot
1608             delete set._indexes[value];
1609 
1610             return true;
1611         } else {
1612             return false;
1613         }
1614     }
1615 
1616     /**
1617      * @dev Returns true if the value is in the set. O(1).
1618      */
1619     function _contains(Set storage set, bytes32 value)
1620         private
1621         view
1622         returns (bool)
1623     {
1624         return set._indexes[value] != 0;
1625     }
1626 
1627     /**
1628      * @dev Returns the number of values on the set. O(1).
1629      */
1630     function _length(Set storage set) private view returns (uint256) {
1631         return set._values.length;
1632     }
1633 
1634     /**
1635      * @dev Returns the value stored at position `index` in the set. O(1).
1636      *
1637      * Note that there are no guarantees on the ordering of values inside the
1638      * array, and it may change when more values are added or removed.
1639      *
1640      * Requirements:
1641      *
1642      * - `index` must be strictly less than {length}.
1643      */
1644     function _at(Set storage set, uint256 index)
1645         private
1646         view
1647         returns (bytes32)
1648     {
1649         require(
1650             set._values.length > index,
1651             "EnumerableSet: index out of bounds"
1652         );
1653         return set._values[index];
1654     }
1655 
1656     // AddressSet
1657 
1658     struct AddressSet {
1659         Set _inner;
1660     }
1661 
1662     /**
1663      * @dev Add a value to a set. O(1).
1664      *
1665      * Returns true if the value was added to the set, that is if it was not
1666      * already present.
1667      */
1668     function add(AddressSet storage set, address value)
1669         internal
1670         returns (bool)
1671     {
1672         return _add(set._inner, bytes32(uint256(value)));
1673     }
1674 
1675     /**
1676      * @dev Removes a value from a set. O(1).
1677      *
1678      * Returns true if the value was removed from the set, that is if it was
1679      * present.
1680      */
1681     function remove(AddressSet storage set, address value)
1682         internal
1683         returns (bool)
1684     {
1685         return _remove(set._inner, bytes32(uint256(value)));
1686     }
1687 
1688     /**
1689      * @dev Returns true if the value is in the set. O(1).
1690      */
1691     function contains(AddressSet storage set, address value)
1692         internal
1693         view
1694         returns (bool)
1695     {
1696         return _contains(set._inner, bytes32(uint256(value)));
1697     }
1698 
1699     /**
1700      * @dev Returns the number of values in the set. O(1).
1701      */
1702     function length(AddressSet storage set) internal view returns (uint256) {
1703         return _length(set._inner);
1704     }
1705 
1706     /**
1707      * @dev Returns the value stored at position `index` in the set. O(1).
1708      *
1709      * Note that there are no guarantees on the ordering of values inside the
1710      * array, and it may change when more values are added or removed.
1711      *
1712      * Requirements:
1713      *
1714      * - `index` must be strictly less than {length}.
1715      */
1716     function at(AddressSet storage set, uint256 index)
1717         internal
1718         view
1719         returns (address)
1720     {
1721         return address(uint256(_at(set._inner, index)));
1722     }
1723 
1724     // UintSet
1725 
1726     struct UintSet {
1727         Set _inner;
1728     }
1729 
1730     /**
1731      * @dev Add a value to a set. O(1).
1732      *
1733      * Returns true if the value was added to the set, that is if it was not
1734      * already present.
1735      */
1736     function add(UintSet storage set, uint256 value) internal returns (bool) {
1737         return _add(set._inner, bytes32(value));
1738     }
1739 
1740     /**
1741      * @dev Removes a value from a set. O(1).
1742      *
1743      * Returns true if the value was removed from the set, that is if it was
1744      * present.
1745      */
1746     function remove(UintSet storage set, uint256 value)
1747         internal
1748         returns (bool)
1749     {
1750         return _remove(set._inner, bytes32(value));
1751     }
1752 
1753     /**
1754      * @dev Returns true if the value is in the set. O(1).
1755      */
1756     function contains(UintSet storage set, uint256 value)
1757         internal
1758         view
1759         returns (bool)
1760     {
1761         return _contains(set._inner, bytes32(value));
1762     }
1763 
1764     /**
1765      * @dev Returns the number of values on the set. O(1).
1766      */
1767     function length(UintSet storage set) internal view returns (uint256) {
1768         return _length(set._inner);
1769     }
1770 
1771     /**
1772      * @dev Returns the value stored at position `index` in the set. O(1).
1773      *
1774      * Note that there are no guarantees on the ordering of values inside the
1775      * array, and it may change when more values are added or removed.
1776      *
1777      * Requirements:
1778      *
1779      * - `index` must be strictly less than {length}.
1780      */
1781     function at(UintSet storage set, uint256 index)
1782         internal
1783         view
1784         returns (uint256)
1785     {
1786         return uint256(_at(set._inner, index));
1787     }
1788 }
1789 
1790 // File: @openzeppelin/contracts/access/AccessControl.sol
1791 
1792 pragma solidity ^0.6.0;
1793 
1794 /**
1795  * @dev Contract module that allows children to implement role-based access
1796  * control mechanisms.
1797  *
1798  * Roles are referred to by their `bytes32` identifier. These should be exposed
1799  * in the external API and be unique. The best way to achieve this is by
1800  * using `public constant` hash digests:
1801  *
1802  * ```
1803  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1804  * ```
1805  *
1806  * Roles can be used to represent a set of permissions. To restrict access to a
1807  * function call, use {hasRole}:
1808  *
1809  * ```
1810  * function foo() public {
1811  *     require(hasRole(MY_ROLE, _msgSender()));
1812  *     ...
1813  * }
1814  * ```
1815  *
1816  * Roles can be granted and revoked dynamically via the {grantRole} and
1817  * {revokeRole} functions. Each role has an associated admin role, and only
1818  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1819  *
1820  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1821  * that only accounts with this role will be able to grant or revoke other
1822  * roles. More complex role relationships can be created by using
1823  * {_setRoleAdmin}.
1824  */
1825 abstract contract AccessControl is Context {
1826     using EnumerableSet for EnumerableSet.AddressSet;
1827     using Address for address;
1828 
1829     struct RoleData {
1830         EnumerableSet.AddressSet members;
1831         bytes32 adminRole;
1832     }
1833 
1834     mapping(bytes32 => RoleData) private _roles;
1835 
1836     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1837 
1838     /**
1839      * @dev Emitted when `account` is granted `role`.
1840      *
1841      * `sender` is the account that originated the contract call, an admin role
1842      * bearer except when using {_setupRole}.
1843      */
1844     event RoleGranted(
1845         bytes32 indexed role,
1846         address indexed account,
1847         address indexed sender
1848     );
1849 
1850     /**
1851      * @dev Emitted when `account` is revoked `role`.
1852      *
1853      * `sender` is the account that originated the contract call:
1854      *   - if using `revokeRole`, it is the admin role bearer
1855      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1856      */
1857     event RoleRevoked(
1858         bytes32 indexed role,
1859         address indexed account,
1860         address indexed sender
1861     );
1862 
1863     /**
1864      * @dev Returns `true` if `account` has been granted `role`.
1865      */
1866     function hasRole(bytes32 role, address account) public view returns (bool) {
1867         return _roles[role].members.contains(account);
1868     }
1869 
1870     /**
1871      * @dev Returns the number of accounts that have `role`. Can be used
1872      * together with {getRoleMember} to enumerate all bearers of a role.
1873      */
1874     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1875         return _roles[role].members.length();
1876     }
1877 
1878     /**
1879      * @dev Returns one of the accounts that have `role`. `index` must be a
1880      * value between 0 and {getRoleMemberCount}, non-inclusive.
1881      *
1882      * Role bearers are not sorted in any particular way, and their ordering may
1883      * change at any point.
1884      *
1885      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1886      * you perform all queries on the same block. See the following
1887      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1888      * for more information.
1889      */
1890     function getRoleMember(bytes32 role, uint256 index)
1891         public
1892         view
1893         returns (address)
1894     {
1895         return _roles[role].members.at(index);
1896     }
1897 
1898     /**
1899      * @dev Returns the admin role that controls `role`. See {grantRole} and
1900      * {revokeRole}.
1901      *
1902      * To change a role's admin, use {_setRoleAdmin}.
1903      */
1904     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1905         return _roles[role].adminRole;
1906     }
1907 
1908     /**
1909      * @dev Grants `role` to `account`.
1910      *
1911      * If `account` had not been already granted `role`, emits a {RoleGranted}
1912      * event.
1913      *
1914      * Requirements:
1915      *
1916      * - the caller must have ``role``'s admin role.
1917      */
1918     function grantRole(bytes32 role, address account) public virtual {
1919         require(
1920             hasRole(_roles[role].adminRole, _msgSender()),
1921             "AccessControl: sender must be an admin to grant"
1922         );
1923 
1924         _grantRole(role, account);
1925     }
1926 
1927     /**
1928      * @dev Revokes `role` from `account`.
1929      *
1930      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1931      *
1932      * Requirements:
1933      *
1934      * - the caller must have ``role``'s admin role.
1935      */
1936     function revokeRole(bytes32 role, address account) public virtual {
1937         require(
1938             hasRole(_roles[role].adminRole, _msgSender()),
1939             "AccessControl: sender must be an admin to revoke"
1940         );
1941 
1942         _revokeRole(role, account);
1943     }
1944 
1945     /**
1946      * @dev Revokes `role` from the calling account.
1947      *
1948      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1949      * purpose is to provide a mechanism for accounts to lose their privileges
1950      * if they are compromised (such as when a trusted device is misplaced).
1951      *
1952      * If the calling account had been granted `role`, emits a {RoleRevoked}
1953      * event.
1954      *
1955      * Requirements:
1956      *
1957      * - the caller must be `account`.
1958      */
1959     function renounceRole(bytes32 role, address account) public virtual {
1960         require(
1961             account == _msgSender(),
1962             "AccessControl: can only renounce roles for self"
1963         );
1964 
1965         _revokeRole(role, account);
1966     }
1967 
1968     /**
1969      * @dev Grants `role` to `account`.
1970      *
1971      * If `account` had not been already granted `role`, emits a {RoleGranted}
1972      * event. Note that unlike {grantRole}, this function doesn't perform any
1973      * checks on the calling account.
1974      *
1975      * [WARNING]
1976      * ====
1977      * This function should only be called from the constructor when setting
1978      * up the initial roles for the system.
1979      *
1980      * Using this function in any other way is effectively circumventing the admin
1981      * system imposed by {AccessControl}.
1982      * ====
1983      */
1984     function _setupRole(bytes32 role, address account) internal virtual {
1985         _grantRole(role, account);
1986     }
1987 
1988     /**
1989      * @dev Sets `adminRole` as ``role``'s admin role.
1990      */
1991     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1992         _roles[role].adminRole = adminRole;
1993     }
1994 
1995     function _grantRole(bytes32 role, address account) private {
1996         if (_roles[role].members.add(account)) {
1997             emit RoleGranted(role, account, _msgSender());
1998         }
1999     }
2000 
2001     function _revokeRole(bytes32 role, address account) private {
2002         if (_roles[role].members.remove(account)) {
2003             emit RoleRevoked(role, account, _msgSender());
2004         }
2005     }
2006 }
2007 
2008 // File: contracts/access/Roles.sol
2009 
2010 pragma solidity ^0.6.0;
2011 
2012 contract Roles is AccessControl {
2013     bytes32 public constant MINTER_ROLE = keccak256("MINTER");
2014     bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR");
2015 
2016     constructor() public {
2017         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
2018         _setupRole(MINTER_ROLE, _msgSender());
2019         _setupRole(OPERATOR_ROLE, _msgSender());
2020     }
2021 
2022     modifier onlyMinter() {
2023         require(
2024             hasRole(MINTER_ROLE, _msgSender()),
2025             "Roles: caller does not have the MINTER role"
2026         );
2027         _;
2028     }
2029 
2030     modifier onlyOperator() {
2031         require(
2032             hasRole(OPERATOR_ROLE, _msgSender()),
2033             "Roles: caller does not have the OPERATOR role"
2034         );
2035         _;
2036     }
2037 }
2038 
2039 // File: contracts/DGCLToken.sol
2040 
2041 pragma solidity ^0.6.0;
2042 
2043 // TOKEN NAME: DigiCol Token
2044 // SYMBOL: DGCL
2045 
2046 /**
2047  * @title DGCLToken
2048  * @dev Implementation of the DGCLToken
2049  */
2050 contract DGCLToken is ERC20Capped, ERC20Burnable, ERC1363, Roles, TokenRecover {
2051     // indicates if minting is finished
2052     bool private _mintingFinished = false;
2053 
2054     // indicates if transfer is enabled
2055     bool private _transferEnabled = false;
2056 
2057     /**
2058      * @dev Emitted during finish minting
2059      */
2060     event MintFinished();
2061 
2062     /**
2063      * @dev Emitted during transfer enabling
2064      */
2065     event TransferEnabled();
2066 
2067     /**
2068      * @dev Tokens can be minted only before minting finished.
2069      */
2070     modifier canMint() {
2071         require(!_mintingFinished, "DGCLToken: minting is finished");
2072         _;
2073     }
2074 
2075     /**
2076      * @dev Tokens can be moved only after if transfer enabled or if you are an approved operator.
2077      */
2078     modifier canTransfer(address from) {
2079         require(
2080             _transferEnabled || hasRole(OPERATOR_ROLE, from),
2081             "DGCLToken: transfer is not enabled or from does not have the OPERATOR role"
2082         );
2083         _;
2084     }
2085 
2086     /**
2087      * @param name Name of the token
2088      * @param symbol A symbol to be used as ticker
2089      * @param decimals Number of decimals. All the operations are done using the smallest and indivisible token unit
2090      * @param cap Maximum number of tokens mintable
2091      * @param initialSupply Initial token supply
2092      * @param transferEnabled If transfer is enabled on token creation
2093      * @param mintingFinished If minting is finished after token creation
2094      */
2095     constructor(
2096         string memory name,
2097         string memory symbol,
2098         uint8 decimals,
2099         uint256 cap,
2100         uint256 initialSupply,
2101         bool transferEnabled,
2102         bool mintingFinished
2103     ) public ERC20Capped(cap) ERC1363(name, symbol) {
2104         require(
2105             mintingFinished == false || cap == initialSupply,
2106             "DGCLToken: if finish minting, cap must be equal to initialSupply"
2107         );
2108 
2109         _setupDecimals(decimals);
2110 
2111         if (initialSupply > 0) {
2112             _mint(owner(), initialSupply);
2113         }
2114 
2115         if (mintingFinished) {
2116             finishMinting();
2117         }
2118 
2119         if (transferEnabled) {
2120             enableTransfer();
2121         }
2122     }
2123 
2124     /**
2125      * @return if minting is finished or not.
2126      */
2127     function mintingFinished() public view returns (bool) {
2128         return _mintingFinished;
2129     }
2130 
2131     /**
2132      * @return if transfer is enabled or not.
2133      */
2134     function transferEnabled() public view returns (bool) {
2135         return _transferEnabled;
2136     }
2137 
2138     /**
2139      * @dev Function to mint tokens.
2140      * @param to The address that will receive the minted tokens
2141      * @param value The amount of tokens to mint
2142      */
2143     function mint(address to, uint256 value) public canMint onlyMinter {
2144         _mint(to, value);
2145     }
2146 
2147     /**
2148      * @dev Transfer tokens to a specified address.
2149      * @param to The address to transfer to
2150      * @param value The amount to be transferred
2151      * @return A boolean that indicates if the operation was successful.
2152      */
2153     function transfer(address to, uint256 value)
2154         public
2155         virtual
2156         override(ERC20)
2157         canTransfer(_msgSender())
2158         returns (bool)
2159     {
2160         return super.transfer(to, value);
2161     }
2162 
2163     /**
2164      * @dev Transfer tokens from one address to another.
2165      * @param from The address which you want to send tokens from
2166      * @param to The address which you want to transfer to
2167      * @param value the amount of tokens to be transferred
2168      * @return A boolean that indicates if the operation was successful.
2169      */
2170     function transferFrom(
2171         address from,
2172         address to,
2173         uint256 value
2174     ) public virtual override(ERC20) canTransfer(from) returns (bool) {
2175         return super.transferFrom(from, to, value);
2176     }
2177 
2178     /**
2179      * @dev Function to stop minting new tokens.
2180      */
2181     function finishMinting() public canMint onlyOwner {
2182         _mintingFinished = true;
2183 
2184         emit MintFinished();
2185     }
2186 
2187     /**
2188      * @dev Function to enable transfers.
2189      */
2190     function enableTransfer() public onlyOwner {
2191         _transferEnabled = true;
2192 
2193         emit TransferEnabled();
2194     }
2195 
2196     /**
2197      * @dev See {ERC20-_beforeTokenTransfer}.
2198      */
2199     function _beforeTokenTransfer(
2200         address from,
2201         address to,
2202         uint256 amount
2203     ) internal virtual override(ERC20, ERC20Capped) {
2204         super._beforeTokenTransfer(from, to, amount);
2205     }
2206 }
