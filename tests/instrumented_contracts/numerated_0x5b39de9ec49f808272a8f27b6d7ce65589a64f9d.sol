1 /**
2  Website - https://100xbot.io
3  Telegram - https://t.me/the100xbottg
4  Twitter - https://twitter.com/the100xbot
5 /**
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity 0.8.20;
9 pragma experimental ABIEncoderV2;
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() {
52         _transferOwnership(_msgSender());
53     }
54 
55     /**
56      * @dev Returns the address of the current owner.
57      */
58     function owner() public view virtual returns (address) {
59         return _owner;
60     }
61 
62     /**
63      * @dev Throws if called by any account other than the owner.
64      */
65     modifier onlyOwner() {
66         require(owner() == _msgSender(), "Ownable: caller is not the owner");
67         _;
68     }
69 
70     /**
71      * @dev Leaves the contract without owner. It will not be possible to call
72      * `onlyOwner` functions anymore. Can only be called by the current owner.
73      *
74      * NOTE: Renouncing ownership will leave the contract without an owner,
75      * thereby removing any functionality that is only available to the owner.
76      */
77     function renounceOwnership() public virtual onlyOwner {
78         _transferOwnership(address(0));
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Can only be called by the current owner.
84      */
85     function transferOwnership(address newOwner) public virtual onlyOwner {
86         require(newOwner != address(0), "Ownable: new owner is the zero address");
87         _transferOwnership(newOwner);
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Internal function without access restriction.
93      */
94     function _transferOwnership(address newOwner) internal virtual {
95         address oldOwner = _owner;
96         _owner = newOwner;
97         emit OwnershipTransferred(oldOwner, newOwner);
98     }
99 }
100 
101 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
102 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
103 
104 /* pragma solidity ^0.8.0; */
105 
106 /**
107  * @dev Interface of the ERC20 standard as defined in the EIP.
108  */
109 interface IERC20 {
110     /**
111      * @dev Returns the amount of tokens in existence.
112      */
113     function totalSupply() external view returns (uint256);
114 
115     /**
116      * @dev Returns the amount of tokens owned by `account`.
117      */
118     function balanceOf(address account) external view returns (uint256);
119 
120     /**
121      * @dev Moves `amount` tokens from the caller's account to `recipient`.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transfer(address recipient, uint256 amount) external returns (bool);
128 
129     /**
130      * @dev Returns the remaining number of tokens that `spender` will be
131      * allowed to spend on behalf of `owner` through {transferFrom}. This is
132      * zero by default.
133      *
134      * This value changes when {approve} or {transferFrom} are called.
135      */
136     function allowance(address owner, address spender) external view returns (uint256);
137 
138     /**
139      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * IMPORTANT: Beware that changing an allowance with this method brings the risk
144      * that someone may use both the old and the new allowance by unfortunate
145      * transaction ordering. One possible solution to mitigate this race
146      * condition is to first reduce the spender's allowance to 0 and set the
147      * desired value afterwards:
148      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
149      *
150      * Emits an {Approval} event.
151      */
152     function approve(address spender, uint256 amount) external returns (bool);
153 
154     /**
155      * @dev Moves `amount` tokens from `sender` to `recipient` using the
156      * allowance mechanism. `amount` is then deducted from the caller's
157      * allowance.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * Emits a {Transfer} event.
162      */
163     function transferFrom(
164         address sender,
165         address recipient,
166         uint256 amount
167     ) external returns (bool);
168 
169     /**
170      * @dev Emitted when `value` tokens are moved from one account (`from`) to
171      * another (`to`).
172      *
173      * Note that `value` may be zero.
174      */
175     event Transfer(address indexed from, address indexed to, uint256 value);
176 
177     /**
178      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
179      * a call to {approve}. `value` is the new allowance.
180      */
181     event Approval(address indexed owner, address indexed spender, uint256 value);
182 }
183 
184 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
185 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
186 
187 /* pragma solidity ^0.8.0; */
188 
189 /* import "../IERC20.sol"; */
190 
191 /**
192  * @dev Interface for the optional metadata functions from the ERC20 standard.
193  *
194  * _Available since v4.1._
195  */
196 interface IERC20Metadata is IERC20 {
197     /**
198      * @dev Returns the name of the token.
199      */
200     function name() external view returns (string memory);
201 
202     /**
203      * @dev Returns the symbol of the token.
204      */
205     function symbol() external view returns (string memory);
206 
207     /**
208      * @dev Returns the decimals places of the token.
209      */
210     function decimals() external view returns (uint8);
211 }
212 
213 /**
214  * @dev Implementation of the {IERC20} interface.
215  *
216  * This implementation is agnostic to the way tokens are created. This means
217  * that a supply mechanism has to be added in a derived contract using {_mint}.
218  * For a generic mechanism see {ERC20PresetMinterPauser}.
219  *
220  * TIP: For a detailed writeup see our guide
221  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
222  * to implement supply mechanisms].
223  *
224  * We have followed general OpenZeppelin Contracts guidelines: functions revert
225  * instead returning `false` on failure. This behavior is nonetheless
226  * conventional and does not conflict with the expectations of ERC20
227  * applications.
228  *
229  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
230  * This allows applications to reconstruct the allowance for all accounts just
231  * by listening to said events. Other implementations of the EIP may not emit
232  * these events, as it isn't required by the specification.
233  *
234  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
235  * functions have been added to mitigate the well-known issues around setting
236  * allowances. See {IERC20-approve}.
237  */
238 contract ERC20 is Context, IERC20, IERC20Metadata {
239     mapping(address => uint256) private _balances;
240 
241     mapping(address => mapping(address => uint256)) private _allowances;
242 
243     uint256 private _totalSupply;
244 
245     string private _name;
246     string private _symbol;
247 
248     /**
249      * @dev Sets the values for {name} and {symbol}.
250      *
251      * The default value of {decimals} is 18. To select a different value for
252      * {decimals} you should overload it.
253      *
254      * All two of these values are immutable: they can only be set once during
255      * construction.
256      */
257     constructor(string memory name_, string memory symbol_) {
258         _name = name_;
259         _symbol = symbol_;
260     }
261 
262     /**
263      * @dev Returns the name of the token.
264      */
265     function name() public view virtual override returns (string memory) {
266         return _name;
267     }
268 
269     /**
270      * @dev Returns the symbol of the token, usually a shorter version of the
271      * name.
272      */
273     function symbol() public view virtual override returns (string memory) {
274         return _symbol;
275     }
276 
277     /**
278      * @dev Returns the number of decimals used to get its user representation.
279      * For example, if `decimals` equals `2`, a balance of `505` tokens should
280      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
281      *
282      * Tokens usually opt for a value of 18, imitating the relationship between
283      * Ether and Wei. This is the value {ERC20} uses, unless this function is
284      * overridden;
285      *
286      * NOTE: This information is only used for _display_ purposes: it in
287      * no way affects any of the arithmetic of the contract, including
288      * {IERC20-balanceOf} and {IERC20-transfer}.
289      */
290     function decimals() public view virtual override returns (uint8) {
291         return 18;
292     }
293 
294     /**
295      * @dev See {IERC20-totalSupply}.
296      */
297     function totalSupply() public view virtual override returns (uint256) {
298         return _totalSupply;
299     }
300 
301     /**
302      * @dev See {IERC20-balanceOf}.
303      */
304     function balanceOf(address account) public view virtual override returns (uint256) {
305         return _balances[account];
306     }
307 
308     /**
309      * @dev See {IERC20-transfer}.
310      *
311      * Requirements:
312      *
313      * - `recipient` cannot be the zero address.
314      * - the caller must have a balance of at least `amount`.
315      */
316     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
317         _transfer(_msgSender(), recipient, amount);
318         return true;
319     }
320 
321     /**
322      * @dev See {IERC20-allowance}.
323      */
324     function allowance(address owner, address spender) public view virtual override returns (uint256) {
325         return _allowances[owner][spender];
326     }
327 
328     /**
329      * @dev See {IERC20-approve}.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      */
335     function approve(address spender, uint256 amount) public virtual override returns (bool) {
336         _approve(_msgSender(), spender, amount);
337         return true;
338     }
339 
340     /**
341      * @dev See {IERC20-transferFrom}.
342      *
343      * Emits an {Approval} event indicating the updated allowance. This is not
344      * required by the EIP. See the note at the beginning of {ERC20}.
345      *
346      * Requirements:
347      *
348      * - `sender` and `recipient` cannot be the zero address.
349      * - `sender` must have a balance of at least `amount`.
350      * - the caller must have allowance for ``sender``'s tokens of at least
351      * `amount`.
352      */
353     function transferFrom(
354         address sender,
355         address recipient,
356         uint256 amount
357     ) public virtual override returns (bool) {
358         _transfer(sender, recipient, amount);
359 
360         uint256 currentAllowance = _allowances[sender][_msgSender()];
361         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
362         unchecked {
363             _approve(sender, _msgSender(), currentAllowance - amount);
364         }
365 
366         return true;
367     }
368 
369     /**
370      * @dev Atomically increases the allowance granted to `spender` by the caller.
371      *
372      * This is an alternative to {approve} that can be used as a mitigation for
373      * problems described in {IERC20-approve}.
374      *
375      * Emits an {Approval} event indicating the updated allowance.
376      *
377      * Requirements:
378      *
379      * - `spender` cannot be the zero address.
380      */
381     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
382         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
383         return true;
384     }
385 
386     /**
387      * @dev Atomically decreases the allowance granted to `spender` by the caller.
388      *
389      * This is an alternative to {approve} that can be used as a mitigation for
390      * problems described in {IERC20-approve}.
391      *
392      * Emits an {Approval} event indicating the updated allowance.
393      *
394      * Requirements:
395      *
396      * - `spender` cannot be the zero address.
397      * - `spender` must have allowance for the caller of at least
398      * `subtractedValue`.
399      */
400     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
401         uint256 currentAllowance = _allowances[_msgSender()][spender];
402         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
403         unchecked {
404             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
405         }
406 
407         return true;
408     }
409 
410     /**
411      * @dev Moves `amount` of tokens from `sender` to `recipient`.
412      *
413      * This internal function is equivalent to {transfer}, and can be used to
414      * e.g. implement automatic token fees, slashing mechanisms, etc.
415      *
416      * Emits a {Transfer} event.
417      *
418      * Requirements:
419      *
420      * - `sender` cannot be the zero address.
421      * - `recipient` cannot be the zero address.
422      * - `sender` must have a balance of at least `amount`.
423      */
424     function _transfer(
425         address sender,
426         address recipient,
427         uint256 amount
428     ) internal virtual {
429         require(sender != address(0), "ERC20: transfer from the zero address");
430         require(recipient != address(0), "ERC20: transfer to the zero address");
431 
432         _beforeTokenTransfer(sender, recipient, amount);
433 
434         uint256 senderBalance = _balances[sender];
435         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
436         unchecked {
437             _balances[sender] = senderBalance - amount;
438         }
439         _balances[recipient] += amount;
440 
441         emit Transfer(sender, recipient, amount);
442 
443         _afterTokenTransfer(sender, recipient, amount);
444     }
445 
446     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
447      * the total supply.
448      *
449      * Emits a {Transfer} event with `from` set to the zero address.
450      *
451      * Requirements:
452      *
453      * - `account` cannot be the zero address.
454      */
455     function _mint(address account, uint256 amount) internal virtual {
456         require(account != address(0), "ERC20: mint to the zero address");
457 
458         _beforeTokenTransfer(address(0), account, amount);
459 
460         _totalSupply += amount;
461         _balances[account] += amount;
462         emit Transfer(address(0), account, amount);
463 
464         _afterTokenTransfer(address(0), account, amount);
465     }
466 
467     /**
468      * @dev Destroys `amount` tokens from `account`, reducing the
469      * total supply.
470      *
471      * Emits a {Transfer} event with `to` set to the zero address.
472      *
473      * Requirements:
474      *
475      * - `account` cannot be the zero address.
476      * - `account` must have at least `amount` tokens.
477      */
478     function _burn(address account, uint256 amount) internal virtual {
479         require(account != address(0), "ERC20: burn from the zero address");
480 
481         _beforeTokenTransfer(account, address(0), amount);
482 
483         uint256 accountBalance = _balances[account];
484         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
485         unchecked {
486             _balances[account] = accountBalance - amount;
487         }
488         _totalSupply -= amount;
489 
490         emit Transfer(account, address(0), amount);
491 
492         _afterTokenTransfer(account, address(0), amount);
493     }
494 
495     /**
496      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
497      *
498      * This internal function is equivalent to `approve`, and can be used to
499      * e.g. set automatic allowances for certain subsystems, etc.
500      *
501      * Emits an {Approval} event.
502      *
503      * Requirements:
504      *
505      * - `owner` cannot be the zero address.
506      * - `spender` cannot be the zero address.
507      */
508     function _approve(
509         address owner,
510         address spender,
511         uint256 amount
512     ) internal virtual {
513         require(owner != address(0), "ERC20: approve from the zero address");
514         require(spender != address(0), "ERC20: approve to the zero address");
515 
516         _allowances[owner][spender] = amount;
517         emit Approval(owner, spender, amount);
518     }
519 
520     /**
521      * @dev Hook that is called before any transfer of tokens. This includes
522      * minting and burning.
523      *
524      * Calling conditions:
525      *
526      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
527      * will be transferred to `to`.
528      * - when `from` is zero, `amount` tokens will be minted for `to`.
529      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
530      * - `from` and `to` are never both zero.
531      *
532      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
533      */
534     function _beforeTokenTransfer(
535         address from,
536         address to,
537         uint256 amount
538     ) internal virtual {}
539 
540     /**
541      * @dev Hook that is called after any transfer of tokens. This includes
542      * minting and burning.
543      *
544      * Calling conditions:
545      *
546      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
547      * has been transferred to `to`.
548      * - when `from` is zero, `amount` tokens have been minted for `to`.
549      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
550      * - `from` and `to` are never both zero.
551      *
552      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
553      */
554     function _afterTokenTransfer(
555         address from,
556         address to,
557         uint256 amount
558     ) internal virtual {}
559 }
560 
561 /**
562  * @dev Wrappers over Solidity's arithmetic operations.
563  *
564  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
565  * now has built in overflow checking.
566  */
567 library SafeMath {
568     /**
569      * @dev Returns the addition of two unsigned integers, with an overflow flag.
570      *
571      * _Available since v3.4._
572      */
573     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
574         unchecked {
575             uint256 c = a + b;
576             if (c < a) return (false, 0);
577             return (true, c);
578         }
579     }
580 
581     /**
582      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
583      *
584      * _Available since v3.4._
585      */
586     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
587         unchecked {
588             if (b > a) return (false, 0);
589             return (true, a - b);
590         }
591     }
592 
593     /**
594      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
595      *
596      * _Available since v3.4._
597      */
598     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
599         unchecked {
600             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
601             // benefit is lost if 'b' is also tested.
602             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
603             if (a == 0) return (true, 0);
604             uint256 c = a * b;
605             if (c / a != b) return (false, 0);
606             return (true, c);
607         }
608     }
609 
610     /**
611      * @dev Returns the division of two unsigned integers, with a division by zero flag.
612      *
613      * _Available since v3.4._
614      */
615     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
616         unchecked {
617             if (b == 0) return (false, 0);
618             return (true, a / b);
619         }
620     }
621 
622     /**
623      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
624      *
625      * _Available since v3.4._
626      */
627     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
628         unchecked {
629             if (b == 0) return (false, 0);
630             return (true, a % b);
631         }
632     }
633 
634     /**
635      * @dev Returns the addition of two unsigned integers, reverting on
636      * overflow.
637      *
638      * Counterpart to Solidity's `+` operator.
639      *
640      * Requirements:
641      *
642      * - Addition cannot overflow.
643      */
644     function add(uint256 a, uint256 b) internal pure returns (uint256) {
645         return a + b;
646     }
647 
648     /**
649      * @dev Returns the subtraction of two unsigned integers, reverting on
650      * overflow (when the result is negative).
651      *
652      * Counterpart to Solidity's `-` operator.
653      *
654      * Requirements:
655      *
656      * - Subtraction cannot overflow.
657      */
658     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
659         return a - b;
660     }
661 
662     /**
663      * @dev Returns the multiplication of two unsigned integers, reverting on
664      * overflow.
665      *
666      * Counterpart to Solidity's `*` operator.
667      *
668      * Requirements:
669      *
670      * - Multiplication cannot overflow.
671      */
672     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
673         return a * b;
674     }
675 
676     /**
677      * @dev Returns the integer division of two unsigned integers, reverting on
678      * division by zero. The result is rounded towards zero.
679      *
680      * Counterpart to Solidity's `/` operator.
681      *
682      * Requirements:
683      *
684      * - The divisor cannot be zero.
685      */
686     function div(uint256 a, uint256 b) internal pure returns (uint256) {
687         return a / b;
688     }
689 
690     /**
691      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
692      * reverting when dividing by zero.
693      *
694      * Counterpart to Solidity's `%` operator. This function uses a `revert`
695      * opcode (which leaves remaining gas untouched) while Solidity uses an
696      * invalid opcode to revert (consuming all remaining gas).
697      *
698      * Requirements:
699      *
700      * - The divisor cannot be zero.
701      */
702     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
703         return a % b;
704     }
705 
706     /**
707      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
708      * overflow (when the result is negative).
709      *
710      * CAUTION: This function is deprecated because it requires allocating memory for the error
711      * message unnecessarily. For custom revert reasons use {trySub}.
712      *
713      * Counterpart to Solidity's `-` operator.
714      *
715      * Requirements:
716      *
717      * - Subtraction cannot overflow.
718      */
719     function sub(
720         uint256 a,
721         uint256 b,
722         string memory errorMessage
723     ) internal pure returns (uint256) {
724         unchecked {
725             require(b <= a, errorMessage);
726             return a - b;
727         }
728     }
729 
730     /**
731      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
732      * division by zero. The result is rounded towards zero.
733      *
734      * Counterpart to Solidity's `/` operator. Note: this function uses a
735      * `revert` opcode (which leaves remaining gas untouched) while Solidity
736      * uses an invalid opcode to revert (consuming all remaining gas).
737      *
738      * Requirements:
739      *
740      * - The divisor cannot be zero.
741      */
742     function div(
743         uint256 a,
744         uint256 b,
745         string memory errorMessage
746     ) internal pure returns (uint256) {
747         unchecked {
748             require(b > 0, errorMessage);
749             return a / b;
750         }
751     }
752 
753     /**
754      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
755      * reverting with custom message when dividing by zero.
756      *
757      * CAUTION: This function is deprecated because it requires allocating memory for the error
758      * message unnecessarily. For custom revert reasons use {tryMod}.
759      *
760      * Counterpart to Solidity's `%` operator. This function uses a `revert`
761      * opcode (which leaves remaining gas untouched) while Solidity uses an
762      * invalid opcode to revert (consuming all remaining gas).
763      *
764      * Requirements:
765      *
766      * - The divisor cannot be zero.
767      */
768     function mod(
769         uint256 a,
770         uint256 b,
771         string memory errorMessage
772     ) internal pure returns (uint256) {
773         unchecked {
774             require(b > 0, errorMessage);
775             return a % b;
776         }
777     }
778 }
779 
780 interface IUniswapV2Factory {
781     event PairCreated(
782         address indexed token0,
783         address indexed token1,
784         address pair,
785         uint256
786     );
787 
788     function feeTo() external view returns (address);
789 
790     function feeToSetter() external view returns (address);
791 
792     function getPair(address tokenA, address tokenB)
793         external
794         view
795         returns (address pair);
796 
797     function allPairs(uint256) external view returns (address pair);
798 
799     function allPairsLength() external view returns (uint256);
800 
801     function createPair(address tokenA, address tokenB)
802         external
803         returns (address pair);
804 
805     function setFeeTo(address) external;
806 
807     function setFeeToSetter(address) external;
808 }
809 
810 ////// src/IUniswapV2Pair.sol
811 /* pragma solidity 0.8.10; */
812 /* pragma experimental ABIEncoderV2; */
813 
814 interface IUniswapV2Pair {
815     event Approval(
816         address indexed owner,
817         address indexed spender,
818         uint256 value
819     );
820     event Transfer(address indexed from, address indexed to, uint256 value);
821 
822     function name() external pure returns (string memory);
823 
824     function symbol() external pure returns (string memory);
825 
826     function decimals() external pure returns (uint8);
827 
828     function totalSupply() external view returns (uint256);
829 
830     function balanceOf(address owner) external view returns (uint256);
831 
832     function allowance(address owner, address spender)
833         external
834         view
835         returns (uint256);
836 
837     function approve(address spender, uint256 value) external returns (bool);
838 
839     function transfer(address to, uint256 value) external returns (bool);
840 
841     function transferFrom(
842         address from,
843         address to,
844         uint256 value
845     ) external returns (bool);
846 
847     function DOMAIN_SEPARATOR() external view returns (bytes32);
848 
849     function PERMIT_TYPEHASH() external pure returns (bytes32);
850 
851     function nonces(address owner) external view returns (uint256);
852 
853     function permit(
854         address owner,
855         address spender,
856         uint256 value,
857         uint256 deadline,
858         uint8 v,
859         bytes32 r,
860         bytes32 s
861     ) external;
862 
863     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
864     event Burn(
865         address indexed sender,
866         uint256 amount0,
867         uint256 amount1,
868         address indexed to
869     );
870     event Swap(
871         address indexed sender,
872         uint256 amount0In,
873         uint256 amount1In,
874         uint256 amount0Out,
875         uint256 amount1Out,
876         address indexed to
877     );
878     event Sync(uint112 reserve0, uint112 reserve1);
879 
880     function MINIMUM_LIQUIDITY() external pure returns (uint256);
881 
882     function factory() external view returns (address);
883 
884     function token0() external view returns (address);
885 
886     function token1() external view returns (address);
887 
888     function getReserves()
889         external
890         view
891         returns (
892             uint112 reserve0,
893             uint112 reserve1,
894             uint32 blockTimestampLast
895         );
896 
897     function price0CumulativeLast() external view returns (uint256);
898 
899     function price1CumulativeLast() external view returns (uint256);
900 
901     function kLast() external view returns (uint256);
902 
903     function mint(address to) external returns (uint256 liquidity);
904 
905     function burn(address to)
906         external
907         returns (uint256 amount0, uint256 amount1);
908 
909     function swap(
910         uint256 amount0Out,
911         uint256 amount1Out,
912         address to,
913         bytes calldata data
914     ) external;
915 
916     function skim(address to) external;
917 
918     function sync() external;
919 
920     function initialize(address, address) external;
921 }
922 
923 interface IUniswapV2Router02 {
924     function factory() external pure returns (address);
925 
926     function WETH() external pure returns (address);
927 
928     function addLiquidity(
929         address tokenA,
930         address tokenB,
931         uint256 amountADesired,
932         uint256 amountBDesired,
933         uint256 amountAMin,
934         uint256 amountBMin,
935         address to,
936         uint256 deadline
937     )
938         external
939         returns (
940             uint256 amountA,
941             uint256 amountB,
942             uint256 liquidity
943         );
944 
945     function addLiquidityETH(
946         address token,
947         uint256 amountTokenDesired,
948         uint256 amountTokenMin,
949         uint256 amountETHMin,
950         address to,
951         uint256 deadline
952     )
953         external
954         payable
955         returns (
956             uint256 amountToken,
957             uint256 amountETH,
958             uint256 liquidity
959         );
960 
961     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
962         uint256 amountIn,
963         uint256 amountOutMin,
964         address[] calldata path,
965         address to,
966         uint256 deadline
967     ) external;
968 
969     function swapExactETHForTokensSupportingFeeOnTransferTokens(
970         uint256 amountOutMin,
971         address[] calldata path,
972         address to,
973         uint256 deadline
974     ) external payable;
975 
976     function swapExactTokensForETHSupportingFeeOnTransferTokens(
977         uint256 amountIn,
978         uint256 amountOutMin,
979         address[] calldata path,
980         address to,
981         uint256 deadline
982     ) external;
983 }
984 
985 contract BOT is ERC20, Ownable {
986     using SafeMath for uint256;
987 
988     IUniswapV2Router02 public immutable uniswapV2Router;
989     address public immutable uniswapV2Pair;
990     address public constant deadAddress = address(0xdead);
991 
992     bool private swapping;
993 
994     address public revShareWallet;
995     address public teamWallet;
996 
997     uint256 public maxTransactionAmount;
998     uint256 public swapTokensAtAmount;
999     uint256 public maxWallet;
1000 
1001     bool public limitsInEffect = true;
1002     bool public tradingActive = false;
1003     bool public swapEnabled = false;
1004 
1005     bool public blacklistRenounced = false;
1006 
1007     // Anti-bot and anti-whale mappings and variables
1008     mapping(address => bool) blacklisted;
1009 
1010     uint256 public buyTotalFees;
1011     uint256 public buyRevShareFee;
1012     uint256 public buyLiquidityFee;
1013     uint256 public buyTeamFee;
1014 
1015     uint256 public sellTotalFees;
1016     uint256 public sellRevShareFee;
1017     uint256 public sellLiquidityFee;
1018     uint256 public sellTeamFee;
1019 
1020     uint256 public tokensForRevShare;
1021     uint256 public tokensForLiquidity;
1022     uint256 public tokensForTeam;
1023 
1024     /******************/
1025 
1026     // exclude from fees and max transaction amount
1027     mapping(address => bool) private _isExcludedFromFees;
1028     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1029 
1030     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1031     // could be subject to a maximum transfer amount
1032     mapping(address => bool) public automatedMarketMakerPairs;
1033 
1034   
1035 
1036     event UpdateUniswapV2Router(
1037         address indexed newAddress,
1038         address indexed oldAddress
1039     );
1040 
1041     event ExcludeFromFees(address indexed account, bool isExcluded);
1042 
1043     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1044 
1045     event revShareWalletUpdated(
1046         address indexed newWallet,
1047         address indexed oldWallet
1048     );
1049 
1050     event teamWalletUpdated(
1051         address indexed newWallet,
1052         address indexed oldWallet
1053     );
1054 
1055     event SwapAndLiquify(
1056         uint256 tokensSwapped,
1057         uint256 ethReceived,
1058         uint256 tokensIntoLiquidity
1059     );
1060 
1061     constructor() ERC20("100x BOT", "100X") {
1062         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1063             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1064         );
1065 
1066         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1067         uniswapV2Router = _uniswapV2Router;
1068 
1069         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1070             .createPair(address(this), _uniswapV2Router.WETH());
1071         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1072         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1073 
1074         uint256 _buyRevShareFee = 33;
1075         uint256 _buyLiquidityFee = 33;
1076         uint256 _buyTeamFee = 33;
1077 
1078         uint256 _sellRevShareFee = 2;
1079         uint256 _sellLiquidityFee = 1;
1080         uint256 _sellTeamFee = 2;
1081 
1082         uint256 totalSupply = 100_000_000 * 1e18;
1083 
1084         maxTransactionAmount = 1000_000 * 1e18; // 1%
1085         maxWallet = 1000_000 * 1e18; // 1% 
1086         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% 
1087 
1088         buyRevShareFee = _buyRevShareFee;
1089         buyLiquidityFee = _buyLiquidityFee;
1090         buyTeamFee = _buyTeamFee;
1091         buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;
1092 
1093         sellRevShareFee = _sellRevShareFee;
1094         sellLiquidityFee = _sellLiquidityFee;
1095         sellTeamFee = _sellTeamFee;
1096         sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;
1097 
1098         revShareWallet = address(0x52Cfc575f1276e5c1421dEFC4C5eB5b220863187); // set as revShare wallet
1099         teamWallet = owner(); // set as team wallet
1100 
1101         // exclude from paying fees or having max transaction amount
1102         excludeFromFees(owner(), true);
1103         excludeFromFees(address(this), true);
1104         excludeFromFees(address(0xdead), true);
1105 
1106         excludeFromMaxTransaction(owner(), true);
1107         excludeFromMaxTransaction(address(this), true);
1108         excludeFromMaxTransaction(address(0xdead), true);
1109 
1110       
1111 
1112         /*
1113             _mint is an internal function in ERC20.sol that is only called here,
1114             and CANNOT be called ever again
1115         */
1116         _mint(msg.sender, totalSupply);
1117     }
1118 
1119     receive() external payable {}
1120 
1121     // once enabled, can never be turned off
1122     function enableTrading() external onlyOwner {
1123         tradingActive = true;
1124         swapEnabled = true;
1125       
1126     }
1127 
1128     // remove limits after token is stable
1129     function removeLimits() external onlyOwner returns (bool) {
1130         limitsInEffect = false;
1131         return true;
1132     }
1133 
1134     // change the minimum amount of tokens to sell from fees
1135     function updateSwapTokensAtAmount(uint256 newAmount)
1136         external
1137         onlyOwner
1138         returns (bool)
1139     {
1140         require(
1141             newAmount >= (totalSupply() * 1) / 100000,
1142             "Swap amount cannot be lower than 0.001% total supply."
1143         );
1144         require(
1145             newAmount <= (totalSupply() * 5) / 1000,
1146             "Swap amount cannot be higher than 0.5% total supply."
1147         );
1148         swapTokensAtAmount = newAmount;
1149         return true;
1150     }
1151 
1152     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1153         require(
1154             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1155             "Cannot set maxTransactionAmount lower than 0.5%"
1156         );
1157         maxTransactionAmount = newNum * (10**18);
1158     }
1159 
1160     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1161         require(
1162             newNum >= ((totalSupply() * 10) / 1000) / 1e18,
1163             "Cannot set maxWallet lower than 1.0%"
1164         );
1165         maxWallet = newNum * (10**18);
1166     }
1167 
1168     function excludeFromMaxTransaction(address updAds, bool isEx)
1169         public
1170         onlyOwner
1171     {
1172         _isExcludedMaxTransactionAmount[updAds] = isEx;
1173     }
1174 
1175     // only use to disable contract sales if absolutely necessary (emergency use only)
1176     function updateSwapEnabled(bool enabled) external onlyOwner {
1177         swapEnabled = enabled;
1178     }
1179 
1180     function updateBuyFees(
1181         uint256 _revShareFee,
1182         uint256 _liquidityFee,
1183         uint256 _teamFee
1184     ) external onlyOwner {
1185         buyRevShareFee = _revShareFee;
1186         buyLiquidityFee = _liquidityFee;
1187         buyTeamFee = _teamFee;
1188         buyTotalFees = buyRevShareFee + buyLiquidityFee + buyTeamFee;
1189         require(buyTotalFees <= 50, "Buy fees must be <= 50.");
1190     }
1191 
1192     function updateSellFees(
1193         uint256 _revShareFee,
1194         uint256 _liquidityFee,
1195         uint256 _teamFee
1196     ) external onlyOwner {
1197         sellRevShareFee = _revShareFee;
1198         sellLiquidityFee = _liquidityFee;
1199         sellTeamFee = _teamFee;
1200         sellTotalFees = sellRevShareFee + sellLiquidityFee + sellTeamFee;
1201         require(sellTotalFees <= 5, "Sell fees must be <= 5.");
1202     }
1203 
1204     function excludeFromFees(address account, bool excluded) public onlyOwner {
1205         _isExcludedFromFees[account] = excluded;
1206         emit ExcludeFromFees(account, excluded);
1207     }
1208 
1209     function setAutomatedMarketMakerPair(address pair, bool value)
1210         public
1211         onlyOwner
1212     {
1213         require(
1214             pair != uniswapV2Pair,
1215             "The pair cannot be removed from automatedMarketMakerPairs"
1216         );
1217 
1218         _setAutomatedMarketMakerPair(pair, value);
1219     }
1220 
1221     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1222         automatedMarketMakerPairs[pair] = value;
1223 
1224         emit SetAutomatedMarketMakerPair(pair, value);
1225     }
1226 
1227     function updateRevShareWallet(address newRevShareWallet) external onlyOwner {
1228         emit revShareWalletUpdated(newRevShareWallet, revShareWallet);
1229         revShareWallet = newRevShareWallet;
1230     }
1231 
1232     function updateTeamWallet(address newWallet) external onlyOwner {
1233         emit teamWalletUpdated(newWallet, teamWallet);
1234         teamWallet = newWallet;
1235     }
1236 
1237     function isExcludedFromFees(address account) public view returns (bool) {
1238         return _isExcludedFromFees[account];
1239     }
1240 
1241     function isBlacklisted(address account) public view returns (bool) {
1242         return blacklisted[account];
1243     }
1244 
1245     function _transfer(
1246         address from,
1247         address to,
1248         uint256 amount
1249     ) internal override {
1250         require(from != address(0), "ERC20: transfer from the zero address");
1251         require(to != address(0), "ERC20: transfer to the zero address");
1252         require(!blacklisted[from],"Sender blacklisted");
1253         require(!blacklisted[to],"Receiver blacklisted");
1254 
1255         
1256         
1257 
1258         if (amount == 0) {
1259             super._transfer(from, to, 0);
1260             return;
1261         }
1262 
1263         if (limitsInEffect) {
1264             if (
1265                 from != owner() &&
1266                 to != owner() &&
1267                 to != address(0) &&
1268                 to != address(0xdead) &&
1269                 !swapping
1270             ) {
1271                 if (!tradingActive) {
1272                     require(
1273                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1274                         "Trading is not active."
1275                     );
1276                 }
1277 
1278                 //when buy
1279                 if (
1280                     automatedMarketMakerPairs[from] &&
1281                     !_isExcludedMaxTransactionAmount[to]
1282                 ) {
1283                     require(
1284                         amount <= maxTransactionAmount,
1285                         "Buy transfer amount exceeds the maxTransactionAmount."
1286                     );
1287                     require(
1288                         amount + balanceOf(to) <= maxWallet,
1289                         "Max wallet exceeded"
1290                     );
1291                 }
1292                 //when sell
1293                 else if (
1294                     automatedMarketMakerPairs[to] &&
1295                     !_isExcludedMaxTransactionAmount[from]
1296                 ) {
1297                     require(
1298                         amount <= maxTransactionAmount,
1299                         "Sell transfer amount exceeds the maxTransactionAmount."
1300                     );
1301                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1302                     require(
1303                         amount + balanceOf(to) <= maxWallet,
1304                         "Max wallet exceeded"
1305                     );
1306                 }
1307             }
1308         }
1309 
1310         uint256 contractTokenBalance = balanceOf(address(this));
1311 
1312         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1313 
1314         if (
1315             canSwap &&
1316             swapEnabled &&
1317             !swapping &&
1318             !automatedMarketMakerPairs[from] &&
1319             !_isExcludedFromFees[from] &&
1320             !_isExcludedFromFees[to]
1321         ) {
1322             swapping = true;
1323 
1324             swapBack();
1325 
1326             swapping = false;
1327         }
1328 
1329         bool takeFee = !swapping;
1330 
1331         // if any account belongs to _isExcludedFromFee account then remove the fee
1332         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1333             takeFee = false;
1334         }
1335 
1336         uint256 fees = 0;
1337         // only take fees on buys/sells, do not take on wallet transfers
1338         if (takeFee) {
1339             // on sell
1340             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1341                 fees = amount.mul(sellTotalFees).div(100);
1342                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1343                 tokensForTeam += (fees * sellTeamFee) / sellTotalFees;
1344                 tokensForRevShare += (fees * sellRevShareFee) / sellTotalFees;
1345             }
1346             // on buy
1347             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1348                 fees = amount.mul(buyTotalFees).div(100);
1349                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1350                 tokensForTeam += (fees * buyTeamFee) / buyTotalFees;
1351                 tokensForRevShare += (fees * buyRevShareFee) / buyTotalFees;
1352             }
1353 
1354             if (fees > 0) {
1355                 super._transfer(from, address(this), fees);
1356             }
1357 
1358             amount -= fees;
1359         }
1360 
1361         super._transfer(from, to, amount);
1362     }
1363 
1364     function swapTokensForEth(uint256 tokenAmount) private {
1365         // generate the uniswap pair path of token -> weth
1366         address[] memory path = new address[](2);
1367         path[0] = address(this);
1368         path[1] = uniswapV2Router.WETH();
1369 
1370         _approve(address(this), address(uniswapV2Router), tokenAmount);
1371 
1372         // make the swap
1373         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1374             tokenAmount,
1375             0, // accept any amount of ETH
1376             path,
1377             address(this),
1378             block.timestamp
1379         );
1380     }
1381 
1382     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1383         // approve token transfer to cover all possible scenarios
1384         _approve(address(this), address(uniswapV2Router), tokenAmount);
1385 
1386         // add the liquidity
1387         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1388             address(this),
1389             tokenAmount,
1390             0, // slippage is unavoidable
1391             0, // slippage is unavoidable
1392             owner(),
1393             block.timestamp
1394         );
1395     }
1396 
1397     function swapBack() private {
1398         uint256 contractBalance = balanceOf(address(this));
1399         uint256 totalTokensToSwap = tokensForLiquidity +
1400             tokensForRevShare +
1401             tokensForTeam;
1402         bool success;
1403 
1404         if (contractBalance == 0 || totalTokensToSwap == 0) {
1405             return;
1406         }
1407 
1408         if (contractBalance > swapTokensAtAmount * 20) {
1409             contractBalance = swapTokensAtAmount * 20;
1410         }
1411 
1412         // Halve the amount of liquidity tokens
1413         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1414             totalTokensToSwap /
1415             2;
1416         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1417 
1418         uint256 initialETHBalance = address(this).balance;
1419 
1420         swapTokensForEth(amountToSwapForETH);
1421 
1422         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1423 
1424         uint256 ethForRevShare = ethBalance.mul(tokensForRevShare).div(totalTokensToSwap - (tokensForLiquidity / 2));
1425         
1426         uint256 ethForTeam = ethBalance.mul(tokensForTeam).div(totalTokensToSwap - (tokensForLiquidity / 2));
1427 
1428         uint256 ethForLiquidity = ethBalance - ethForRevShare - ethForTeam;
1429 
1430         tokensForLiquidity = 0;
1431         tokensForRevShare = 0;
1432         tokensForTeam = 0;
1433 
1434         (success, ) = address(teamWallet).call{value: ethForTeam}("");
1435 
1436         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1437             addLiquidity(liquidityTokens, ethForLiquidity);
1438             emit SwapAndLiquify(
1439                 amountToSwapForETH,
1440                 ethForLiquidity,
1441                 tokensForLiquidity
1442             );
1443         }
1444 
1445         (success, ) = address(revShareWallet).call{value: address(this).balance}("");
1446     }
1447 
1448     function withdrawStuckUnibot() external onlyOwner {
1449         uint256 balance = IERC20(address(this)).balanceOf(address(this));
1450         IERC20(address(this)).transfer(msg.sender, balance);
1451         payable(msg.sender).transfer(address(this).balance);
1452     }
1453 
1454     function withdrawStuckToken(address _token, address _to) external onlyOwner {
1455         require(_token != address(0), "_token address cannot be 0");
1456         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1457         IERC20(_token).transfer(_to, _contractBalance);
1458     }
1459 
1460     function withdrawStuckEth(address toAddr) external onlyOwner {
1461         (bool success, ) = toAddr.call{
1462             value: address(this).balance
1463         } ("");
1464         require(success);
1465     }
1466 
1467     // @dev team renounce blacklist commands
1468     function renounceBlacklist() public onlyOwner {
1469         blacklistRenounced = true;
1470     }
1471 
1472     function blacklist(address _addr) public onlyOwner {
1473         require(!blacklistRenounced, "Team has revoked blacklist rights");
1474         require(
1475             _addr != address(uniswapV2Pair) && _addr != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1476             "Cannot blacklist token's v2 router or v2 pool."
1477         );
1478         blacklisted[_addr] = true;
1479     }
1480 
1481     // @dev blacklist v3 pools; can unblacklist() down the road to suit project and community
1482     function blacklistLiquidityPool(address lpAddress) public onlyOwner {
1483         require(!blacklistRenounced, "Team has revoked blacklist rights");
1484         require(
1485             lpAddress != address(uniswapV2Pair) && lpAddress != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D), 
1486             "Cannot blacklist token's v2 router or v2 pool."
1487         );
1488         blacklisted[lpAddress] = true;
1489     }
1490 
1491     // @dev unblacklist address; not affected by blacklistRenounced incase team wants to unblacklist v3 pools down the road
1492     function unblacklist(address _addr) public onlyOwner {
1493         blacklisted[_addr] = false;
1494     }
1495 }