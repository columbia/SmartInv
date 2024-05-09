1 // File: @openzeppelin/contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
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
30 // SPDX-License-Identifier: MIT
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
110 // SPDX-License-Identifier: MIT
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
327 // SPDX-License-Identifier: MIT
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
383         _decimals = 6;
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
633 // File: contracts/root/RootToken/IMintableERC20.sol
634 
635 pragma solidity 0.6.6;
636 
637 interface IMintableERC20 is IERC20 {
638     /**
639      * @notice called by predicate contract to mint tokens while withdrawing
640      * @dev Should be callable only by MintableERC20Predicate
641      * Make sure minting is done only by this function
642      * @param user user address for whom token is being minted
643      * @param amount amount of token being minted
644      */
645     function mint(address user, uint256 amount) external;
646 }
647 
648 // File: contracts/common/Initializable.sol
649 
650 pragma solidity 0.6.6;
651 
652 contract Initializable {
653     bool inited = false;
654 
655     modifier initializer() {
656         require(!inited, "already inited");
657         _;
658         inited = true;
659     }
660 }
661 
662 // File: contracts/common/EIP712Base.sol
663 
664 pragma solidity 0.6.6;
665 
666 
667 contract EIP712Base is Initializable {
668     struct EIP712Domain {
669         string name;
670         string version;
671         address verifyingContract;
672         bytes32 salt;
673     }
674 
675     string constant public ERC712_VERSION = "1";
676 
677     bytes32 internal constant EIP712_DOMAIN_TYPEHASH = keccak256(
678         bytes(
679             "EIP712Domain(string name,string version,address verifyingContract,bytes32 salt)"
680         )
681     );
682     bytes32 internal domainSeperator;
683 
684     // supposed to be called once while initializing.
685     // one of the contractsa that inherits this contract follows proxy pattern
686     // so it is not possible to do this in a constructor
687     function _initializeEIP712(
688         string memory name
689     )
690         internal
691         initializer
692     {
693         _setDomainSeperator(name);
694     }
695 
696     function _setDomainSeperator(string memory name) internal {
697         domainSeperator = keccak256(
698             abi.encode(
699                 EIP712_DOMAIN_TYPEHASH,
700                 keccak256(bytes(name)),
701                 keccak256(bytes(ERC712_VERSION)),
702                 address(this),
703                 bytes32(getChainId())
704             )
705         );
706     }
707 
708     function getDomainSeperator() public view returns (bytes32) {
709         return domainSeperator;
710     }
711 
712     function getChainId() public pure returns (uint256) {
713         uint256 id;
714         assembly {
715             id := chainid()
716         }
717         return id;
718     }
719 
720     /**
721      * Accept message hash and returns hash message in EIP712 compatible form
722      * So that it can be used to recover signer from signature signed using EIP712 formatted data
723      * https://eips.ethereum.org/EIPS/eip-712
724      * "\\x19" makes the encoding deterministic
725      * "\\x01" is the version byte to make it compatible to EIP-191
726      */
727     function toTypedMessageHash(bytes32 messageHash)
728         internal
729         view
730         returns (bytes32)
731     {
732         return
733             keccak256(
734                 abi.encodePacked("\x19\x01", getDomainSeperator(), messageHash)
735             );
736     }
737 }
738 
739 // File: contracts/common/NativeMetaTransaction.sol
740 
741 pragma solidity 0.6.6;
742 
743 
744 
745 contract NativeMetaTransaction is EIP712Base {
746     using SafeMath for uint256;
747     bytes32 private constant META_TRANSACTION_TYPEHASH = keccak256(
748         bytes(
749             "MetaTransaction(uint256 nonce,address from,bytes functionSignature)"
750         )
751     );
752     event MetaTransactionExecuted(
753         address userAddress,
754         address payable relayerAddress,
755         bytes functionSignature
756     );
757     mapping(address => uint256) nonces;
758 
759     /*
760      * Meta transaction structure.
761      * No point of including value field here as if user is doing value transfer then he has the funds to pay for gas
762      * He should call the desired function directly in that case.
763      */
764     struct MetaTransaction {
765         uint256 nonce;
766         address from;
767         bytes functionSignature;
768     }
769 
770     function executeMetaTransaction(
771         address userAddress,
772         bytes memory functionSignature,
773         bytes32 sigR,
774         bytes32 sigS,
775         uint8 sigV
776     ) public payable returns (bytes memory) {
777         MetaTransaction memory metaTx = MetaTransaction({
778             nonce: nonces[userAddress],
779             from: userAddress,
780             functionSignature: functionSignature
781         });
782 
783         require(
784             verify(userAddress, metaTx, sigR, sigS, sigV),
785             "Signer and signature do not match"
786         );
787 
788         // increase nonce for user (to avoid re-use)
789         nonces[userAddress] = nonces[userAddress].add(1);
790 
791         emit MetaTransactionExecuted(
792             userAddress,
793             msg.sender,
794             functionSignature
795         );
796 
797         // Append userAddress and relayer address at the end to extract it from calling context
798         (bool success, bytes memory returnData) = address(this).call(
799             abi.encodePacked(functionSignature, userAddress)
800         );
801         require(success, "Function call not successful");
802 
803         return returnData;
804     }
805 
806     function hashMetaTransaction(MetaTransaction memory metaTx)
807         internal
808         pure
809         returns (bytes32)
810     {
811         return
812             keccak256(
813                 abi.encode(
814                     META_TRANSACTION_TYPEHASH,
815                     metaTx.nonce,
816                     metaTx.from,
817                     keccak256(metaTx.functionSignature)
818                 )
819             );
820     }
821 
822     function getNonce(address user) public view returns (uint256 nonce) {
823         nonce = nonces[user];
824     }
825 
826     function verify(
827         address signer,
828         MetaTransaction memory metaTx,
829         bytes32 sigR,
830         bytes32 sigS,
831         uint8 sigV
832     ) internal view returns (bool) {
833         require(signer != address(0), "NativeMetaTransaction: INVALID_SIGNER");
834         return
835             signer ==
836             ecrecover(
837                 toTypedMessageHash(hashMetaTransaction(metaTx)),
838                 sigV,
839                 sigR,
840                 sigS
841             );
842     }
843 }
844 
845 // File: contracts/common/ContextMixin.sol
846 
847 pragma solidity 0.6.6;
848 
849 abstract contract ContextMixin {
850     function msgSender()
851         internal
852         view
853         returns (address payable sender)
854     {
855         if (msg.sender == address(this)) {
856             bytes memory array = msg.data;
857             uint256 index = msg.data.length;
858             assembly {
859                 // Load the 32 bytes word from memory with the address on the lower 20 bytes, and mask those.
860                 sender := and(
861                     mload(add(array, index)),
862                     0xffffffffffffffffffffffffffffffffffffffff
863                 )
864             }
865         } else {
866             sender = msg.sender;
867         }
868         return sender;
869     }
870 }
871 
872 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
873 
874 // SPDX-License-Identifier: MIT
875 
876 pragma solidity >=0.6.0 <0.8.0;
877 
878 /**
879  * @dev Library for managing
880  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
881  * types.
882  *
883  * Sets have the following properties:
884  *
885  * - Elements are added, removed, and checked for existence in constant time
886  * (O(1)).
887  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
888  *
889  * ```
890  * contract Example {
891  *     // Add the library methods
892  *     using EnumerableSet for EnumerableSet.AddressSet;
893  *
894  *     // Declare a set state variable
895  *     EnumerableSet.AddressSet private mySet;
896  * }
897  * ```
898  *
899  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
900  * and `uint256` (`UintSet`) are supported.
901  */
902 library EnumerableSet {
903     // To implement this library for multiple types with as little code
904     // repetition as possible, we write it in terms of a generic Set type with
905     // bytes32 values.
906     // The Set implementation uses private functions, and user-facing
907     // implementations (such as AddressSet) are just wrappers around the
908     // underlying Set.
909     // This means that we can only create new EnumerableSets for types that fit
910     // in bytes32.
911 
912     struct Set {
913         // Storage of set values
914         bytes32[] _values;
915 
916         // Position of the value in the `values` array, plus 1 because index 0
917         // means a value is not in the set.
918         mapping (bytes32 => uint256) _indexes;
919     }
920 
921     /**
922      * @dev Add a value to a set. O(1).
923      *
924      * Returns true if the value was added to the set, that is if it was not
925      * already present.
926      */
927     function _add(Set storage set, bytes32 value) private returns (bool) {
928         if (!_contains(set, value)) {
929             set._values.push(value);
930             // The value is stored at length-1, but we add 1 to all indexes
931             // and use 0 as a sentinel value
932             set._indexes[value] = set._values.length;
933             return true;
934         } else {
935             return false;
936         }
937     }
938 
939     /**
940      * @dev Removes a value from a set. O(1).
941      *
942      * Returns true if the value was removed from the set, that is if it was
943      * present.
944      */
945     function _remove(Set storage set, bytes32 value) private returns (bool) {
946         // We read and store the value's index to prevent multiple reads from the same storage slot
947         uint256 valueIndex = set._indexes[value];
948 
949         if (valueIndex != 0) { // Equivalent to contains(set, value)
950             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
951             // the array, and then remove the last element (sometimes called as 'swap and pop').
952             // This modifies the order of the array, as noted in {at}.
953 
954             uint256 toDeleteIndex = valueIndex - 1;
955             uint256 lastIndex = set._values.length - 1;
956 
957             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
958             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
959 
960             bytes32 lastvalue = set._values[lastIndex];
961 
962             // Move the last value to the index where the value to delete is
963             set._values[toDeleteIndex] = lastvalue;
964             // Update the index for the moved value
965             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
966 
967             // Delete the slot where the moved value was stored
968             set._values.pop();
969 
970             // Delete the index for the deleted slot
971             delete set._indexes[value];
972 
973             return true;
974         } else {
975             return false;
976         }
977     }
978 
979     /**
980      * @dev Returns true if the value is in the set. O(1).
981      */
982     function _contains(Set storage set, bytes32 value) private view returns (bool) {
983         return set._indexes[value] != 0;
984     }
985 
986     /**
987      * @dev Returns the number of values on the set. O(1).
988      */
989     function _length(Set storage set) private view returns (uint256) {
990         return set._values.length;
991     }
992 
993    /**
994     * @dev Returns the value stored at position `index` in the set. O(1).
995     *
996     * Note that there are no guarantees on the ordering of values inside the
997     * array, and it may change when more values are added or removed.
998     *
999     * Requirements:
1000     *
1001     * - `index` must be strictly less than {length}.
1002     */
1003     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1004         require(set._values.length > index, "EnumerableSet: index out of bounds");
1005         return set._values[index];
1006     }
1007 
1008     // Bytes32Set
1009 
1010     struct Bytes32Set {
1011         Set _inner;
1012     }
1013 
1014     /**
1015      * @dev Add a value to a set. O(1).
1016      *
1017      * Returns true if the value was added to the set, that is if it was not
1018      * already present.
1019      */
1020     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1021         return _add(set._inner, value);
1022     }
1023 
1024     /**
1025      * @dev Removes a value from a set. O(1).
1026      *
1027      * Returns true if the value was removed from the set, that is if it was
1028      * present.
1029      */
1030     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1031         return _remove(set._inner, value);
1032     }
1033 
1034     /**
1035      * @dev Returns true if the value is in the set. O(1).
1036      */
1037     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1038         return _contains(set._inner, value);
1039     }
1040 
1041     /**
1042      * @dev Returns the number of values in the set. O(1).
1043      */
1044     function length(Bytes32Set storage set) internal view returns (uint256) {
1045         return _length(set._inner);
1046     }
1047 
1048    /**
1049     * @dev Returns the value stored at position `index` in the set. O(1).
1050     *
1051     * Note that there are no guarantees on the ordering of values inside the
1052     * array, and it may change when more values are added or removed.
1053     *
1054     * Requirements:
1055     *
1056     * - `index` must be strictly less than {length}.
1057     */
1058     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1059         return _at(set._inner, index);
1060     }
1061 
1062     // AddressSet
1063 
1064     struct AddressSet {
1065         Set _inner;
1066     }
1067 
1068     /**
1069      * @dev Add a value to a set. O(1).
1070      *
1071      * Returns true if the value was added to the set, that is if it was not
1072      * already present.
1073      */
1074     function add(AddressSet storage set, address value) internal returns (bool) {
1075         return _add(set._inner, bytes32(uint256(uint160(value))));
1076     }
1077 
1078     /**
1079      * @dev Removes a value from a set. O(1).
1080      *
1081      * Returns true if the value was removed from the set, that is if it was
1082      * present.
1083      */
1084     function remove(AddressSet storage set, address value) internal returns (bool) {
1085         return _remove(set._inner, bytes32(uint256(uint160(value))));
1086     }
1087 
1088     /**
1089      * @dev Returns true if the value is in the set. O(1).
1090      */
1091     function contains(AddressSet storage set, address value) internal view returns (bool) {
1092         return _contains(set._inner, bytes32(uint256(uint160(value))));
1093     }
1094 
1095     /**
1096      * @dev Returns the number of values in the set. O(1).
1097      */
1098     function length(AddressSet storage set) internal view returns (uint256) {
1099         return _length(set._inner);
1100     }
1101 
1102    /**
1103     * @dev Returns the value stored at position `index` in the set. O(1).
1104     *
1105     * Note that there are no guarantees on the ordering of values inside the
1106     * array, and it may change when more values are added or removed.
1107     *
1108     * Requirements:
1109     *
1110     * - `index` must be strictly less than {length}.
1111     */
1112     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1113         return address(uint160(uint256(_at(set._inner, index))));
1114     }
1115 
1116 
1117     // UintSet
1118 
1119     struct UintSet {
1120         Set _inner;
1121     }
1122 
1123     /**
1124      * @dev Add a value to a set. O(1).
1125      *
1126      * Returns true if the value was added to the set, that is if it was not
1127      * already present.
1128      */
1129     function add(UintSet storage set, uint256 value) internal returns (bool) {
1130         return _add(set._inner, bytes32(value));
1131     }
1132 
1133     /**
1134      * @dev Removes a value from a set. O(1).
1135      *
1136      * Returns true if the value was removed from the set, that is if it was
1137      * present.
1138      */
1139     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1140         return _remove(set._inner, bytes32(value));
1141     }
1142 
1143     /**
1144      * @dev Returns true if the value is in the set. O(1).
1145      */
1146     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1147         return _contains(set._inner, bytes32(value));
1148     }
1149 
1150     /**
1151      * @dev Returns the number of values on the set. O(1).
1152      */
1153     function length(UintSet storage set) internal view returns (uint256) {
1154         return _length(set._inner);
1155     }
1156 
1157    /**
1158     * @dev Returns the value stored at position `index` in the set. O(1).
1159     *
1160     * Note that there are no guarantees on the ordering of values inside the
1161     * array, and it may change when more values are added or removed.
1162     *
1163     * Requirements:
1164     *
1165     * - `index` must be strictly less than {length}.
1166     */
1167     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1168         return uint256(_at(set._inner, index));
1169     }
1170 }
1171 
1172 // File: @openzeppelin/contracts/utils/Address.sol
1173 
1174 // SPDX-License-Identifier: MIT
1175 
1176 pragma solidity >=0.6.2 <0.8.0;
1177 
1178 /**
1179  * @dev Collection of functions related to the address type
1180  */
1181 library Address {
1182     /**
1183      * @dev Returns true if `account` is a contract.
1184      *
1185      * [IMPORTANT]
1186      * ====
1187      * It is unsafe to assume that an address for which this function returns
1188      * false is an externally-owned account (EOA) and not a contract.
1189      *
1190      * Among others, `isContract` will return false for the following
1191      * types of addresses:
1192      *
1193      *  - an externally-owned account
1194      *  - a contract in construction
1195      *  - an address where a contract will be created
1196      *  - an address where a contract lived, but was destroyed
1197      * ====
1198      */
1199     function isContract(address account) internal view returns (bool) {
1200         // This method relies on extcodesize, which returns 0 for contracts in
1201         // construction, since the code is only stored at the end of the
1202         // constructor execution.
1203 
1204         uint256 size;
1205         // solhint-disable-next-line no-inline-assembly
1206         assembly { size := extcodesize(account) }
1207         return size > 0;
1208     }
1209 
1210     /**
1211      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1212      * `recipient`, forwarding all available gas and reverting on errors.
1213      *
1214      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1215      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1216      * imposed by `transfer`, making them unable to receive funds via
1217      * `transfer`. {sendValue} removes this limitation.
1218      *
1219      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1220      *
1221      * IMPORTANT: because control is transferred to `recipient`, care must be
1222      * taken to not create reentrancy vulnerabilities. Consider using
1223      * {ReentrancyGuard} or the
1224      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1225      */
1226     function sendValue(address payable recipient, uint256 amount) internal {
1227         require(address(this).balance >= amount, "Address: insufficient balance");
1228 
1229         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1230         (bool success, ) = recipient.call{ value: amount }("");
1231         require(success, "Address: unable to send value, recipient may have reverted");
1232     }
1233 
1234     /**
1235      * @dev Performs a Solidity function call using a low level `call`. A
1236      * plain`call` is an unsafe replacement for a function call: use this
1237      * function instead.
1238      *
1239      * If `target` reverts with a revert reason, it is bubbled up by this
1240      * function (like regular Solidity function calls).
1241      *
1242      * Returns the raw returned data. To convert to the expected return value,
1243      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1244      *
1245      * Requirements:
1246      *
1247      * - `target` must be a contract.
1248      * - calling `target` with `data` must not revert.
1249      *
1250      * _Available since v3.1._
1251      */
1252     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1253       return functionCall(target, data, "Address: low-level call failed");
1254     }
1255 
1256     /**
1257      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1258      * `errorMessage` as a fallback revert reason when `target` reverts.
1259      *
1260      * _Available since v3.1._
1261      */
1262     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1263         return functionCallWithValue(target, data, 0, errorMessage);
1264     }
1265 
1266     /**
1267      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1268      * but also transferring `value` wei to `target`.
1269      *
1270      * Requirements:
1271      *
1272      * - the calling contract must have an ETH balance of at least `value`.
1273      * - the called Solidity function must be `payable`.
1274      *
1275      * _Available since v3.1._
1276      */
1277     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1278         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1279     }
1280 
1281     /**
1282      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1283      * with `errorMessage` as a fallback revert reason when `target` reverts.
1284      *
1285      * _Available since v3.1._
1286      */
1287     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1288         require(address(this).balance >= value, "Address: insufficient balance for call");
1289         require(isContract(target), "Address: call to non-contract");
1290 
1291         // solhint-disable-next-line avoid-low-level-calls
1292         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1293         return _verifyCallResult(success, returndata, errorMessage);
1294     }
1295 
1296     /**
1297      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1298      * but performing a static call.
1299      *
1300      * _Available since v3.3._
1301      */
1302     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1303         return functionStaticCall(target, data, "Address: low-level static call failed");
1304     }
1305 
1306     /**
1307      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1308      * but performing a static call.
1309      *
1310      * _Available since v3.3._
1311      */
1312     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1313         require(isContract(target), "Address: static call to non-contract");
1314 
1315         // solhint-disable-next-line avoid-low-level-calls
1316         (bool success, bytes memory returndata) = target.staticcall(data);
1317         return _verifyCallResult(success, returndata, errorMessage);
1318     }
1319 
1320     /**
1321      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1322      * but performing a delegate call.
1323      *
1324      * _Available since v3.4._
1325      */
1326     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1327         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1328     }
1329 
1330     /**
1331      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1332      * but performing a delegate call.
1333      *
1334      * _Available since v3.4._
1335      */
1336     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1337         require(isContract(target), "Address: delegate call to non-contract");
1338 
1339         // solhint-disable-next-line avoid-low-level-calls
1340         (bool success, bytes memory returndata) = target.delegatecall(data);
1341         return _verifyCallResult(success, returndata, errorMessage);
1342     }
1343 
1344     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
1345         if (success) {
1346             return returndata;
1347         } else {
1348             // Look for revert reason and bubble it up if present
1349             if (returndata.length > 0) {
1350                 // The easiest way to bubble the revert reason is using memory via assembly
1351 
1352                 // solhint-disable-next-line no-inline-assembly
1353                 assembly {
1354                     let returndata_size := mload(returndata)
1355                     revert(add(32, returndata), returndata_size)
1356                 }
1357             } else {
1358                 revert(errorMessage);
1359             }
1360         }
1361     }
1362 }
1363 
1364 // File: @openzeppelin/contracts/access/AccessControl.sol
1365 
1366 // SPDX-License-Identifier: MIT
1367 
1368 pragma solidity >=0.6.0 <0.8.0;
1369 
1370 
1371 
1372 
1373 /**
1374  * @dev Contract module that allows children to implement role-based access
1375  * control mechanisms.
1376  *
1377  * Roles are referred to by their `bytes32` identifier. These should be exposed
1378  * in the external API and be unique. The best way to achieve this is by
1379  * using `public constant` hash digests:
1380  *
1381  * ```
1382  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
1383  * ```
1384  *
1385  * Roles can be used to represent a set of permissions. To restrict access to a
1386  * function call, use {hasRole}:
1387  *
1388  * ```
1389  * function foo() public {
1390  *     require(hasRole(MY_ROLE, msg.sender));
1391  *     ...
1392  * }
1393  * ```
1394  *
1395  * Roles can be granted and revoked dynamically via the {grantRole} and
1396  * {revokeRole} functions. Each role has an associated admin role, and only
1397  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
1398  *
1399  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
1400  * that only accounts with this role will be able to grant or revoke other
1401  * roles. More complex role relationships can be created by using
1402  * {_setRoleAdmin}.
1403  *
1404  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1405  * grant and revoke this role. Extra precautions should be taken to secure
1406  * accounts that have been granted it.
1407  */
1408 abstract contract AccessControl is Context {
1409     using EnumerableSet for EnumerableSet.AddressSet;
1410     using Address for address;
1411 
1412     struct RoleData {
1413         EnumerableSet.AddressSet members;
1414         bytes32 adminRole;
1415     }
1416 
1417     mapping (bytes32 => RoleData) private _roles;
1418 
1419     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1420 
1421     /**
1422      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1423      *
1424      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1425      * {RoleAdminChanged} not being emitted signaling this.
1426      *
1427      * _Available since v3.1._
1428      */
1429     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1430 
1431     /**
1432      * @dev Emitted when `account` is granted `role`.
1433      *
1434      * `sender` is the account that originated the contract call, an admin role
1435      * bearer except when using {_setupRole}.
1436      */
1437     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1438 
1439     /**
1440      * @dev Emitted when `account` is revoked `role`.
1441      *
1442      * `sender` is the account that originated the contract call:
1443      *   - if using `revokeRole`, it is the admin role bearer
1444      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1445      */
1446     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1447 
1448     /**
1449      * @dev Returns `true` if `account` has been granted `role`.
1450      */
1451     function hasRole(bytes32 role, address account) public view returns (bool) {
1452         return _roles[role].members.contains(account);
1453     }
1454 
1455     /**
1456      * @dev Returns the number of accounts that have `role`. Can be used
1457      * together with {getRoleMember} to enumerate all bearers of a role.
1458      */
1459     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1460         return _roles[role].members.length();
1461     }
1462 
1463     /**
1464      * @dev Returns one of the accounts that have `role`. `index` must be a
1465      * value between 0 and {getRoleMemberCount}, non-inclusive.
1466      *
1467      * Role bearers are not sorted in any particular way, and their ordering may
1468      * change at any point.
1469      *
1470      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1471      * you perform all queries on the same block. See the following
1472      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1473      * for more information.
1474      */
1475     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1476         return _roles[role].members.at(index);
1477     }
1478 
1479     /**
1480      * @dev Returns the admin role that controls `role`. See {grantRole} and
1481      * {revokeRole}.
1482      *
1483      * To change a role's admin, use {_setRoleAdmin}.
1484      */
1485     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1486         return _roles[role].adminRole;
1487     }
1488 
1489     /**
1490      * @dev Grants `role` to `account`.
1491      *
1492      * If `account` had not been already granted `role`, emits a {RoleGranted}
1493      * event.
1494      *
1495      * Requirements:
1496      *
1497      * - the caller must have ``role``'s admin role.
1498      */
1499     function grantRole(bytes32 role, address account) public virtual {
1500         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1501 
1502         _grantRole(role, account);
1503     }
1504 
1505     /**
1506      * @dev Revokes `role` from `account`.
1507      *
1508      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1509      *
1510      * Requirements:
1511      *
1512      * - the caller must have ``role``'s admin role.
1513      */
1514     function revokeRole(bytes32 role, address account) public virtual {
1515         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1516 
1517         _revokeRole(role, account);
1518     }
1519 
1520     /**
1521      * @dev Revokes `role` from the calling account.
1522      *
1523      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1524      * purpose is to provide a mechanism for accounts to lose their privileges
1525      * if they are compromised (such as when a trusted device is misplaced).
1526      *
1527      * If the calling account had been granted `role`, emits a {RoleRevoked}
1528      * event.
1529      *
1530      * Requirements:
1531      *
1532      * - the caller must be `account`.
1533      */
1534     function renounceRole(bytes32 role, address account) public virtual {
1535         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1536 
1537         _revokeRole(role, account);
1538     }
1539 
1540     /**
1541      * @dev Grants `role` to `account`.
1542      *
1543      * If `account` had not been already granted `role`, emits a {RoleGranted}
1544      * event. Note that unlike {grantRole}, this function doesn't perform any
1545      * checks on the calling account.
1546      *
1547      * [WARNING]
1548      * ====
1549      * This function should only be called from the constructor when setting
1550      * up the initial roles for the system.
1551      *
1552      * Using this function in any other way is effectively circumventing the admin
1553      * system imposed by {AccessControl}.
1554      * ====
1555      */
1556     function _setupRole(bytes32 role, address account) internal virtual {
1557         _grantRole(role, account);
1558     }
1559 
1560     /**
1561      * @dev Sets `adminRole` as ``role``'s admin role.
1562      *
1563      * Emits a {RoleAdminChanged} event.
1564      */
1565     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1566         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1567         _roles[role].adminRole = adminRole;
1568     }
1569 
1570     function _grantRole(bytes32 role, address account) private {
1571         if (_roles[role].members.add(account)) {
1572             emit RoleGranted(role, account, _msgSender());
1573         }
1574     }
1575 
1576     function _revokeRole(bytes32 role, address account) private {
1577         if (_roles[role].members.remove(account)) {
1578             emit RoleRevoked(role, account, _msgSender());
1579         }
1580     }
1581 }
1582 
1583 // File: contracts/common/AccessControlMixin.sol
1584 
1585 pragma solidity 0.6.6;
1586 
1587 
1588 contract AccessControlMixin is AccessControl {
1589     string private _revertMsg;
1590     function _setupContractId(string memory contractId) internal {
1591         _revertMsg = string(abi.encodePacked(contractId, ": INSUFFICIENT_PERMISSIONS"));
1592     }
1593 
1594     modifier only(bytes32 role) {
1595         require(
1596             hasRole(role, _msgSender()),
1597             _revertMsg
1598         );
1599         _;
1600     }
1601 }
1602 
1603 // File: contracts/root/RootToken/DummyMintableERC20.sol
1604 
1605 // This contract is not supposed to be used in production
1606 // It's strictly for testing purpose
1607 
1608 pragma solidity 0.6.6;
1609 
1610 
1611 
1612 
1613 
1614 
1615 contract NFT is
1616     ERC20,
1617     AccessControlMixin,
1618     NativeMetaTransaction,
1619     ContextMixin,
1620     IMintableERC20
1621 {
1622     bytes32 public constant PREDICATE_ROLE = keccak256("PREDICATE_ROLE");
1623 
1624     constructor(string memory name_, string memory symbol_)
1625         public
1626         ERC20(name_, symbol_)
1627     {
1628         _setupContractId("NFT");
1629         _setupRole(PREDICATE_ROLE, 0x9277a463A508F45115FdEaf22FfeDA1B16352433);
1630         _initializeEIP712(name_);
1631     }
1632 
1633     /**
1634      * @dev See {IMintableERC20-mint}.
1635      */
1636     function mint(address user, uint256 amount) external override only(PREDICATE_ROLE) {
1637         _mint(user, amount);
1638     }
1639 
1640     function _msgSender()
1641         internal
1642         override
1643         view
1644         returns (address payable sender)
1645     {
1646         return ContextMixin.msgSender();
1647     }
1648 }