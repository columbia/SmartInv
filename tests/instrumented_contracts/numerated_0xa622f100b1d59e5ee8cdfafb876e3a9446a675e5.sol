1 /* $FOMO
2 
3 FOMO IS COMING FOR YOU
4 6% BUY AND SELL TAX
5 
6  * 
7  * SPDX-License-Identifier: MIT
8  * */
9 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
10 pragma experimental ABIEncoderV2;
11 
12 /* pragma solidity ^0.8.0; */
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18     function _msgData() internal view virtual returns (bytes calldata) {
19         return msg.data;
20     }
21 }
22 
23 /* pragma solidity ^0.8.0; */
24 
25 abstract contract Ownable is Context {
26     address private _owner;
27 
28     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30     /**
31      * @dev Initializes the contract setting the deployer as the initial owner.
32      */
33     constructor() {
34         _transferOwnership(_msgSender());
35     }
36 
37     /**
38      * @dev Returns the address of the current owner.
39      */
40     function owner() public view virtual returns (address) {
41         return _owner;
42     }
43 
44     /**
45      * @dev Throws if called by any account other than the owner.
46      */
47     modifier onlyOwner() {
48         require(owner() == _msgSender(), "Ownable: caller is not the owner");
49         _;
50     }
51 
52     /**
53      * @dev Leaves the contract without owner. It will not be possible to call
54      * `onlyOwner` functions anymore. Can only be called by the current owner.
55      *
56      * NOTE: Renouncing ownership will leave the contract without an owner,
57      * thereby removing any functionality that is only available to the owner.
58      */
59     function renounceOwnership() public virtual onlyOwner {
60         _transferOwnership(address(0));
61     }
62 
63     /**
64      * @dev Transfers ownership of the contract to a new account (`newOwner`).
65      * Can only be called by the current owner.
66      */
67     function transferOwnership(address newOwner) public virtual onlyOwner {
68         require(newOwner != address(0), "Ownable: new owner is the zero address");
69         _transferOwnership(newOwner);
70     }
71 
72     /**
73      * @dev Transfers ownership of the contract to a new account (`newOwner`).
74      * Internal function without access restriction.
75      */
76     function _transferOwnership(address newOwner) internal virtual {
77         address oldOwner = _owner;
78         _owner = newOwner;
79         emit OwnershipTransferred(oldOwner, newOwner);
80     }
81 }
82 
83 /* pragma solidity ^0.8.0; */
84 
85 /**
86  * @dev Interface of the ERC20 standard as defined in the EIP.
87  */
88 interface IERC20 {
89     /**
90      * @dev Returns the amount of tokens in existence.
91      */
92     function totalSupply() external view returns (uint256);
93 
94     /**
95      * @dev Returns the amount of tokens owned by `account`.
96      */
97     function balanceOf(address account) external view returns (uint256);
98 
99     /**
100      * @dev Moves `amount` tokens from the caller's account to `recipient`.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transfer(address recipient, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Returns the remaining number of tokens that `spender` will be
110      * allowed to spend on behalf of `owner` through {transferFrom}. This is
111      * zero by default.
112      *
113      * This value changes when {approve} or {transferFrom} are called.
114      */
115     function allowance(address owner, address spender) external view returns (uint256);
116 
117     /**
118      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * IMPORTANT: Beware that changing an allowance with this method brings the risk
123      * that someone may use both the old and the new allowance by unfortunate
124      * transaction ordering. One possible solution to mitigate this race
125      * condition is to first reduce the spender's allowance to 0 and set the
126      * desired value afterwards:
127      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address spender, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Moves `amount` tokens from `sender` to `recipient` using the
135      * allowance mechanism. `amount` is then deducted from the caller's
136      * allowance.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transferFrom(
143         address sender,
144         address recipient,
145         uint256 amount
146     ) external returns (bool);
147 
148     /**
149      * @dev Emitted when `value` tokens are moved from one account (`from`) to
150      * another (`to`).
151      *
152      * Note that `value` may be zero.
153      */
154     event Transfer(address indexed from, address indexed to, uint256 value);
155 
156     /**
157      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
158      * a call to {approve}. `value` is the new allowance.
159      */
160     event Approval(address indexed owner, address indexed spender, uint256 value);
161 }
162 
163 /* pragma solidity ^0.8.0; */
164 
165 /* import "../IERC20.sol"; */
166 
167 /**
168  * @dev Interface for the optional metadata functions from the ERC20 standard.
169  *
170  * _Available since v4.1._
171  */
172 interface IERC20Metadata is IERC20 {
173     /**
174      * @dev Returns the name of the token.
175      */
176     function name() external view returns (string memory);
177 
178     /**
179      * @dev Returns the symbol of the token.
180      */
181     function symbol() external view returns (string memory);
182 
183     /**
184      * @dev Returns the decimals places of the token.
185      */
186     function decimals() external view returns (uint8);
187 }
188 
189 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
190 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
191 
192 /* pragma solidity ^0.8.0; */
193 
194 /* import "./IERC20.sol"; */
195 /* import "./extensions/IERC20Metadata.sol"; */
196 /* import "../../utils/Context.sol"; */
197 
198 /**
199  * @dev Implementation of the {IERC20} interface.
200  *
201  * This implementation is agnostic to the way tokens are created. This means
202  * that a supply mechanism has to be added in a derived contract using {_mint}.
203  * For a generic mechanism see {ERC20PresetMinterPauser}.
204  *
205  * TIP: For a detailed writeup see our guide
206  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
207  * to implement supply mechanisms].
208  *
209  * We have followed general OpenZeppelin Contracts guidelines: functions revert
210  * instead returning `false` on failure. This behavior is nonetheless
211  * conventional and does not conflict with the expectations of ERC20
212  * applications.
213  *
214  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
215  * This allows applications to reconstruct the allowance for all accounts just
216  * by listening to said events. Other implementations of the EIP may not emit
217  * these events, as it isn't required by the specification.
218  *
219  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
220  * functions have been added to mitigate the well-known issues around setting
221  * allowances. See {IERC20-approve}.
222  */
223 contract ERC20 is Context, IERC20, IERC20Metadata {
224     mapping(address => uint256) private _balances;
225 
226     mapping(address => mapping(address => uint256)) private _allowances;
227 
228     uint256 private _totalSupply;
229 
230     string private _name;
231     string private _symbol;
232 
233     /**
234      * @dev Sets the values for {name} and {symbol}.
235      *
236      * The default value of {decimals} is 18. To select a different value for
237      * {decimals} you should overload it.
238      *
239      * All two of these values are immutable: they can only be set once during
240      * construction.
241      */
242     constructor(string memory name_, string memory symbol_) {
243         _name = name_;
244         _symbol = symbol_;
245     }
246 
247     /**
248      * @dev Returns the name of the token.
249      */
250     function name() public view virtual override returns (string memory) {
251         return _name;
252     }
253 
254     /**
255      * @dev Returns the symbol of the token, usually a shorter version of the
256      * name.
257      */
258     function symbol() public view virtual override returns (string memory) {
259         return _symbol;
260     }
261 
262     /**
263      * @dev Returns the number of decimals used to get its user representation.
264      * For example, if `decimals` equals `2`, a balance of `505` tokens should
265      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
266      *
267      * Tokens usually opt for a value of 18, imitating the relationship between
268      * Ether and Wei. This is the value {ERC20} uses, unless this function is
269      * overridden;
270      *
271      * NOTE: This information is only used for _display_ purposes: it in
272      * no way affects any of the arithmetic of the contract, including
273      * {IERC20-balanceOf} and {IERC20-transfer}.
274      */
275     function decimals() public view virtual override returns (uint8) {
276         return 18;
277     }
278 
279     /**
280      * @dev See {IERC20-totalSupply}.
281      */
282     function totalSupply() public view virtual override returns (uint256) {
283         return _totalSupply;
284     }
285 
286     /**
287      * @dev See {IERC20-balanceOf}.
288      */
289     function balanceOf(address account) public view virtual override returns (uint256) {
290         return _balances[account];
291     }
292 
293     /**
294      * @dev See {IERC20-transfer}.
295      *
296      * Requirements:
297      *
298      * - `recipient` cannot be the zero address.
299      * - the caller must have a balance of at least `amount`.
300      */
301     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
302         _transfer(_msgSender(), recipient, amount);
303         return true;
304     }
305 
306     /**
307      * @dev See {IERC20-allowance}.
308      */
309     function allowance(address owner, address spender) public view virtual override returns (uint256) {
310         return _allowances[owner][spender];
311     }
312 
313     /**
314      * @dev See {IERC20-approve}.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function approve(address spender, uint256 amount) public virtual override returns (bool) {
321         _approve(_msgSender(), spender, amount);
322         return true;
323     }
324 
325     /**
326      * @dev See {IERC20-transferFrom}.
327      *
328      * Emits an {Approval} event indicating the updated allowance. This is not
329      * required by the EIP. See the note at the beginning of {ERC20}.
330      *
331      * Requirements:
332      *
333      * - `sender` and `recipient` cannot be the zero address.
334      * - `sender` must have a balance of at least `amount`.
335      * - the caller must have allowance for ``sender``'s tokens of at least
336      * `amount`.
337      */
338     function transferFrom(
339         address sender,
340         address recipient,
341         uint256 amount
342     ) public virtual override returns (bool) {
343         _transfer(sender, recipient, amount);
344 
345         uint256 currentAllowance = _allowances[sender][_msgSender()];
346         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
347         unchecked {
348             _approve(sender, _msgSender(), currentAllowance - amount);
349         }
350 
351         return true;
352     }
353 
354     /**
355      * @dev Atomically increases the allowance granted to `spender` by the caller.
356      *
357      * This is an alternative to {approve} that can be used as a mitigation for
358      * problems described in {IERC20-approve}.
359      *
360      * Emits an {Approval} event indicating the updated allowance.
361      *
362      * Requirements:
363      *
364      * - `spender` cannot be the zero address.
365      */
366     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
367         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
368         return true;
369     }
370 
371     /**
372      * @dev Atomically decreases the allowance granted to `spender` by the caller.
373      *
374      * This is an alternative to {approve} that can be used as a mitigation for
375      * problems described in {IERC20-approve}.
376      *
377      * Emits an {Approval} event indicating the updated allowance.
378      *
379      * Requirements:
380      *
381      * - `spender` cannot be the zero address.
382      * - `spender` must have allowance for the caller of at least
383      * `subtractedValue`.
384      */
385     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
386         uint256 currentAllowance = _allowances[_msgSender()][spender];
387         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
388         unchecked {
389             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
390         }
391 
392         return true;
393     }
394 
395     /**
396      * @dev Moves `amount` of tokens from `sender` to `recipient`.
397      *
398      * This internal function is equivalent to {transfer}, and can be used to
399      * e.g. implement automatic token fees, slashing mechanisms, etc.
400      *
401      * Emits a {Transfer} event.
402      *
403      * Requirements:
404      *
405      * - `sender` cannot be the zero address.
406      * - `recipient` cannot be the zero address.
407      * - `sender` must have a balance of at least `amount`.
408      */
409     function _transfer(
410         address sender,
411         address recipient,
412         uint256 amount
413     ) internal virtual {
414         require(sender != address(0), "ERC20: transfer from the zero address");
415         require(recipient != address(0), "ERC20: transfer to the zero address");
416 
417         _beforeTokenTransfer(sender, recipient, amount);
418 
419         uint256 senderBalance = _balances[sender];
420         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
421         unchecked {
422             _balances[sender] = senderBalance - amount;
423         }
424         _balances[recipient] += amount;
425 
426         emit Transfer(sender, recipient, amount);
427 
428         _afterTokenTransfer(sender, recipient, amount);
429     }
430 
431     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
432      * the total supply.
433      *
434      * Emits a {Transfer} event with `from` set to the zero address.
435      *
436      * Requirements:
437      *
438      * - `account` cannot be the zero address.
439      */
440     function _mint(address account, uint256 amount) internal virtual {
441         require(account != address(0), "ERC20: mint to the zero address");
442 
443         _beforeTokenTransfer(address(0), account, amount);
444 
445         _totalSupply += amount;
446         _balances[account] += amount;
447         emit Transfer(address(0), account, amount);
448 
449         _afterTokenTransfer(address(0), account, amount);
450     }
451 
452     /**
453      * @dev Destroys `amount` tokens from `account`, reducing the
454      * total supply.
455      *
456      * Emits a {Transfer} event with `to` set to the zero address.
457      *
458      * Requirements:
459      *
460      * - `account` cannot be the zero address.
461      * - `account` must have at least `amount` tokens.
462      */
463     function _burn(address account, uint256 amount) internal virtual {
464         require(account != address(0), "ERC20: burn from the zero address");
465 
466         _beforeTokenTransfer(account, address(0), amount);
467 
468         uint256 accountBalance = _balances[account];
469         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
470         unchecked {
471             _balances[account] = accountBalance - amount;
472         }
473         _totalSupply -= amount;
474 
475         emit Transfer(account, address(0), amount);
476 
477         _afterTokenTransfer(account, address(0), amount);
478     }
479 
480     /**
481      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
482      *
483      * This internal function is equivalent to `approve`, and can be used to
484      * e.g. set automatic allowances for certain subsystems, etc.
485      *
486      * Emits an {Approval} event.
487      *
488      * Requirements:
489      *
490      * - `owner` cannot be the zero address.
491      * - `spender` cannot be the zero address.
492      */
493     function _approve(
494         address owner,
495         address spender,
496         uint256 amount
497     ) internal virtual {
498         require(owner != address(0), "ERC20: approve from the zero address");
499         require(spender != address(0), "ERC20: approve to the zero address");
500 
501         _allowances[owner][spender] = amount;
502         emit Approval(owner, spender, amount);
503     }
504 
505     /**
506      * @dev Hook that is called before any transfer of tokens. This includes
507      * minting and burning.
508      *
509      * Calling conditions:
510      *
511      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
512      * will be transferred to `to`.
513      * - when `from` is zero, `amount` tokens will be minted for `to`.
514      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
515      * - `from` and `to` are never both zero.
516      *
517      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
518      */
519     function _beforeTokenTransfer(
520         address from,
521         address to,
522         uint256 amount
523     ) internal virtual {}
524 
525     /**
526      * @dev Hook that is called after any transfer of tokens. This includes
527      * minting and burning.
528      *
529      * Calling conditions:
530      *
531      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
532      * has been transferred to `to`.
533      * - when `from` is zero, `amount` tokens have been minted for `to`.
534      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
535      * - `from` and `to` are never both zero.
536      *
537      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
538      */
539     function _afterTokenTransfer(
540         address from,
541         address to,
542         uint256 amount
543     ) internal virtual {}
544 }
545 
546 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
547 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
548 
549 /* pragma solidity ^0.8.0; */
550 
551 // CAUTION
552 // This version of SafeMath should only be used with Solidity 0.8 or later,
553 // because it relies on the compiler's built in overflow checks.
554 
555 /**
556  * @dev Wrappers over Solidity's arithmetic operations.
557  *
558  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
559  * now has built in overflow checking.
560  */
561 library SafeMath {
562     /**
563      * @dev Returns the addition of two unsigned integers, with an overflow flag.
564      *
565      * _Available since v3.4._
566      */
567     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
568         unchecked {
569             uint256 c = a + b;
570             if (c < a) return (false, 0);
571             return (true, c);
572         }
573     }
574 
575     /**
576      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
577      *
578      * _Available since v3.4._
579      */
580     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
581         unchecked {
582             if (b > a) return (false, 0);
583             return (true, a - b);
584         }
585     }
586 
587     /**
588      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
589      *
590      * _Available since v3.4._
591      */
592     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
593         unchecked {
594             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
595             // benefit is lost if 'b' is also tested.
596             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
597             if (a == 0) return (true, 0);
598             uint256 c = a * b;
599             if (c / a != b) return (false, 0);
600             return (true, c);
601         }
602     }
603 
604     /**
605      * @dev Returns the division of two unsigned integers, with a division by zero flag.
606      *
607      * _Available since v3.4._
608      */
609     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
610         unchecked {
611             if (b == 0) return (false, 0);
612             return (true, a / b);
613         }
614     }
615 
616     /**
617      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
618      *
619      * _Available since v3.4._
620      */
621     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
622         unchecked {
623             if (b == 0) return (false, 0);
624             return (true, a % b);
625         }
626     }
627 
628     /**
629      * @dev Returns the addition of two unsigned integers, reverting on
630      * overflow.
631      *
632      * Counterpart to Solidity's `+` operator.
633      *
634      * Requirements:
635      *
636      * - Addition cannot overflow.
637      */
638     function add(uint256 a, uint256 b) internal pure returns (uint256) {
639         return a + b;
640     }
641 
642     /**
643      * @dev Returns the subtraction of two unsigned integers, reverting on
644      * overflow (when the result is negative).
645      *
646      * Counterpart to Solidity's `-` operator.
647      *
648      * Requirements:
649      *
650      * - Subtraction cannot overflow.
651      */
652     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
653         return a - b;
654     }
655 
656     /**
657      * @dev Returns the multiplication of two unsigned integers, reverting on
658      * overflow.
659      *
660      * Counterpart to Solidity's `*` operator.
661      *
662      * Requirements:
663      *
664      * - Multiplication cannot overflow.
665      */
666     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
667         return a * b;
668     }
669 
670     /**
671      * @dev Returns the integer division of two unsigned integers, reverting on
672      * division by zero. The result is rounded towards zero.
673      *
674      * Counterpart to Solidity's `/` operator.
675      *
676      * Requirements:
677      *
678      * - The divisor cannot be zero.
679      */
680     function div(uint256 a, uint256 b) internal pure returns (uint256) {
681         return a / b;
682     }
683 
684     /**
685      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
686      * reverting when dividing by zero.
687      *
688      * Counterpart to Solidity's `%` operator. This function uses a `revert`
689      * opcode (which leaves remaining gas untouched) while Solidity uses an
690      * invalid opcode to revert (consuming all remaining gas).
691      *
692      * Requirements:
693      *
694      * - The divisor cannot be zero.
695      */
696     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
697         return a % b;
698     }
699 
700     /**
701      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
702      * overflow (when the result is negative).
703      *
704      * CAUTION: This function is deprecated because it requires allocating memory for the error
705      * message unnecessarily. For custom revert reasons use {trySub}.
706      *
707      * Counterpart to Solidity's `-` operator.
708      *
709      * Requirements:
710      *
711      * - Subtraction cannot overflow.
712      */
713     function sub(
714         uint256 a,
715         uint256 b,
716         string memory errorMessage
717     ) internal pure returns (uint256) {
718         unchecked {
719             require(b <= a, errorMessage);
720             return a - b;
721         }
722     }
723 
724     /**
725      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
726      * division by zero. The result is rounded towards zero.
727      *
728      * Counterpart to Solidity's `/` operator. Note: this function uses a
729      * `revert` opcode (which leaves remaining gas untouched) while Solidity
730      * uses an invalid opcode to revert (consuming all remaining gas).
731      *
732      * Requirements:
733      *
734      * - The divisor cannot be zero.
735      */
736     function div(
737         uint256 a,
738         uint256 b,
739         string memory errorMessage
740     ) internal pure returns (uint256) {
741         unchecked {
742             require(b > 0, errorMessage);
743             return a / b;
744         }
745     }
746 
747     /**
748      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
749      * reverting with custom message when dividing by zero.
750      *
751      * CAUTION: This function is deprecated because it requires allocating memory for the error
752      * message unnecessarily. For custom revert reasons use {tryMod}.
753      *
754      * Counterpart to Solidity's `%` operator. This function uses a `revert`
755      * opcode (which leaves remaining gas untouched) while Solidity uses an
756      * invalid opcode to revert (consuming all remaining gas).
757      *
758      * Requirements:
759      *
760      * - The divisor cannot be zero.
761      */
762     function mod(
763         uint256 a,
764         uint256 b,
765         string memory errorMessage
766     ) internal pure returns (uint256) {
767         unchecked {
768             require(b > 0, errorMessage);
769             return a % b;
770         }
771     }
772 }
773 
774 ////// src/IUniswapV2Factory.sol
775 /* pragma solidity 0.8.10; */
776 /* pragma experimental ABIEncoderV2; */
777 
778 interface IUniswapV2Factory {
779     event PairCreated(
780         address indexed token0,
781         address indexed token1,
782         address pair,
783         uint256
784     );
785 
786     function feeTo() external view returns (address);
787 
788     function feeToSetter() external view returns (address);
789 
790     function getPair(address tokenA, address tokenB)
791         external
792         view
793         returns (address pair);
794 
795     function allPairs(uint256) external view returns (address pair);
796 
797     function allPairsLength() external view returns (uint256);
798 
799     function createPair(address tokenA, address tokenB)
800         external
801         returns (address pair);
802 
803     function setFeeTo(address) external;
804 
805     function setFeeToSetter(address) external;
806 }
807 
808 ////// src/IUniswapV2Pair.sol
809 /* pragma solidity 0.8.10; */
810 /* pragma experimental ABIEncoderV2; */
811 
812 interface IUniswapV2Pair {
813     event Approval(
814         address indexed owner,
815         address indexed spender,
816         uint256 value
817     );
818     event Transfer(address indexed from, address indexed to, uint256 value);
819 
820     function name() external pure returns (string memory);
821 
822     function symbol() external pure returns (string memory);
823 
824     function decimals() external pure returns (uint8);
825 
826     function totalSupply() external view returns (uint256);
827 
828     function balanceOf(address owner) external view returns (uint256);
829 
830     function allowance(address owner, address spender)
831         external
832         view
833         returns (uint256);
834 
835     function approve(address spender, uint256 value) external returns (bool);
836 
837     function transfer(address to, uint256 value) external returns (bool);
838 
839     function transferFrom(
840         address from,
841         address to,
842         uint256 value
843     ) external returns (bool);
844 
845     function DOMAIN_SEPARATOR() external view returns (bytes32);
846 
847     function PERMIT_TYPEHASH() external pure returns (bytes32);
848 
849     function nonces(address owner) external view returns (uint256);
850 
851     function permit(
852         address owner,
853         address spender,
854         uint256 value,
855         uint256 deadline,
856         uint8 v,
857         bytes32 r,
858         bytes32 s
859     ) external;
860 
861     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
862     event Burn(
863         address indexed sender,
864         uint256 amount0,
865         uint256 amount1,
866         address indexed to
867     );
868     event Swap(
869         address indexed sender,
870         uint256 amount0In,
871         uint256 amount1In,
872         uint256 amount0Out,
873         uint256 amount1Out,
874         address indexed to
875     );
876     event Sync(uint112 reserve0, uint112 reserve1);
877 
878     function MINIMUM_LIQUIDITY() external pure returns (uint256);
879 
880     function factory() external view returns (address);
881 
882     function token0() external view returns (address);
883 
884     function token1() external view returns (address);
885 
886     function getReserves()
887         external
888         view
889         returns (
890             uint112 reserve0,
891             uint112 reserve1,
892             uint32 blockTimestampLast
893         );
894 
895     function price0CumulativeLast() external view returns (uint256);
896 
897     function price1CumulativeLast() external view returns (uint256);
898 
899     function kLast() external view returns (uint256);
900 
901     function mint(address to) external returns (uint256 liquidity);
902 
903     function burn(address to)
904         external
905         returns (uint256 amount0, uint256 amount1);
906 
907     function swap(
908         uint256 amount0Out,
909         uint256 amount1Out,
910         address to,
911         bytes calldata data
912     ) external;
913 
914     function skim(address to) external;
915 
916     function sync() external;
917 
918     function initialize(address, address) external;
919 }
920 
921 ////// src/IUniswapV2Router02.sol
922 /* pragma solidity 0.8.10; */
923 /* pragma experimental ABIEncoderV2; */
924 
925 interface IUniswapV2Router02 {
926     function factory() external pure returns (address);
927 
928     function WETH() external pure returns (address);
929 
930     function addLiquidity(
931         address tokenA,
932         address tokenB,
933         uint256 amountADesired,
934         uint256 amountBDesired,
935         uint256 amountAMin,
936         uint256 amountBMin,
937         address to,
938         uint256 deadline
939     )
940         external
941         returns (
942             uint256 amountA,
943             uint256 amountB,
944             uint256 liquidity
945         );
946 
947     function addLiquidityETH(
948         address token,
949         uint256 amountTokenDesired,
950         uint256 amountTokenMin,
951         uint256 amountETHMin,
952         address to,
953         uint256 deadline
954     )
955         external
956         payable
957         returns (
958             uint256 amountToken,
959             uint256 amountETH,
960             uint256 liquidity
961         );
962 
963     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
964         uint256 amountIn,
965         uint256 amountOutMin,
966         address[] calldata path,
967         address to,
968         uint256 deadline
969     ) external;
970 
971     function swapExactETHForTokensSupportingFeeOnTransferTokens(
972         uint256 amountOutMin,
973         address[] calldata path,
974         address to,
975         uint256 deadline
976     ) external payable;
977 
978     function swapExactTokensForETHSupportingFeeOnTransferTokens(
979         uint256 amountIn,
980         uint256 amountOutMin,
981         address[] calldata path,
982         address to,
983         uint256 deadline
984     ) external;
985 }
986 
987 /* pragma solidity >=0.8.10; */
988 
989 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
990 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
991 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
992 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
993 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
994 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
995 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
996 
997 contract FOMO is ERC20, Ownable {
998     using SafeMath for uint256;
999 
1000     IUniswapV2Router02 public immutable uniswapV2Router;
1001     address public immutable uniswapV2Pair;
1002     address public constant deadAddress = address(0xdead);
1003 
1004     bool private swapping;
1005 
1006     address public marketingWallet;
1007     address public devWallet;
1008 
1009     uint256 public maxTransactionAmount;
1010     uint256 public swapTokensAtAmount;
1011     uint256 public maxWallet;
1012 
1013     uint256 public percentForLPBurn = 25; // 25 = .25%
1014     bool public lpBurnEnabled = false;
1015     uint256 public lpBurnFrequency = 3600 seconds;
1016     uint256 public lastLpBurnTime;
1017 
1018     uint256 public manualBurnFrequency = 30 minutes;
1019     uint256 public lastManualLpBurnTime;
1020 
1021     bool public limitsInEffect = true;
1022     bool public tradingActive = false;
1023     bool public swapEnabled = false;
1024 
1025     // Anti-bot and anti-whale mappings and variables
1026     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1027     bool public transferDelayEnabled = true;
1028 
1029     uint256 public buyTotalFees;
1030     uint256 public buyMarketingFee;
1031     uint256 public buyLiquidityFee;
1032     uint256 public buyDevFee;
1033 
1034     uint256 public sellTotalFees;
1035     uint256 public sellMarketingFee;
1036     uint256 public sellLiquidityFee;
1037     uint256 public sellDevFee;
1038 
1039     uint256 public tokensForMarketing;
1040     uint256 public tokensForLiquidity;
1041     uint256 public tokensForDev;
1042 
1043     /******************/
1044 
1045     // exlcude from fees and max transaction amount
1046     mapping(address => bool) private _isExcludedFromFees;
1047     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1048 
1049     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1050     // could be subject to a maximum transfer amount
1051     mapping(address => bool) public automatedMarketMakerPairs;
1052 
1053     event UpdateUniswapV2Router(
1054         address indexed newAddress,
1055         address indexed oldAddress
1056     );
1057 
1058     event ExcludeFromFees(address indexed account, bool isExcluded);
1059 
1060     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1061 
1062     event marketingWalletUpdated(
1063         address indexed newWallet,
1064         address indexed oldWallet
1065     );
1066 
1067     event devWalletUpdated(
1068         address indexed newWallet,
1069         address indexed oldWallet
1070     );
1071 
1072     event SwapAndLiquify(
1073         uint256 tokensSwapped,
1074         uint256 ethReceived,
1075         uint256 tokensIntoLiquidity
1076     );
1077 
1078     event AutoNukeLP();
1079 
1080     event ManualNukeLP();
1081 
1082     constructor() ERC20("FOMO", "$FOMO") {
1083         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1084             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1085         );
1086 
1087         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1088         uniswapV2Router = _uniswapV2Router;
1089 
1090         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1091             .createPair(address(this), _uniswapV2Router.WETH());
1092         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1093         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1094 
1095         uint256 _buyMarketingFee = 5;
1096         uint256 _buyLiquidityFee = 1;
1097         uint256 _buyDevFee = 0;
1098 
1099         uint256 _sellMarketingFee = 5;
1100         uint256 _sellLiquidityFee = 1;
1101         uint256 _sellDevFee = 0;
1102 
1103         uint256 totalSupply = 1_000_000_000 * 1e18;
1104 
1105         maxTransactionAmount = 20_000_000 * 1e18; // 2% from total supply maxTransactionAmountTxn
1106         maxWallet = 20_000_000 * 1e18; // 2% from total supply maxWallet
1107         swapTokensAtAmount = (totalSupply * 30) / 10000; // 0.3% swap wallet
1108 
1109         buyMarketingFee = _buyMarketingFee;
1110         buyLiquidityFee = _buyLiquidityFee;
1111         buyDevFee = _buyDevFee;
1112         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1113 
1114         sellMarketingFee = _sellMarketingFee;
1115         sellLiquidityFee = _sellLiquidityFee;
1116         sellDevFee = _sellDevFee;
1117         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1118 
1119         marketingWallet = address(0xd02b2269319e2c3C10cd35b42936bE5A5df75600); // set as marketing wallet
1120         devWallet = address(0xd02b2269319e2c3C10cd35b42936bE5A5df75600); // set as dev wallet
1121 
1122         // exclude from paying fees or having max transaction amount
1123         excludeFromFees(owner(), true);
1124         excludeFromFees(address(this), true);
1125         excludeFromFees(address(0xdead), true);
1126 
1127         excludeFromMaxTransaction(owner(), true);
1128         excludeFromMaxTransaction(address(this), true);
1129         excludeFromMaxTransaction(address(0xdead), true);
1130 
1131         /*
1132             _mint is an internal function in ERC20.sol that is only called here,
1133             and CANNOT be called ever again
1134         */
1135         _mint(msg.sender, totalSupply);
1136     }
1137 
1138     receive() external payable {}
1139 
1140     // once enabled, can never be turned off
1141     function enableTrading() external onlyOwner {
1142         tradingActive = true;
1143         swapEnabled = true;
1144         lastLpBurnTime = block.timestamp;
1145     }
1146 
1147     // remove limits after token is stable
1148     function removeLimits() external onlyOwner returns (bool) {
1149         limitsInEffect = false;
1150         return true;
1151     }
1152 
1153     // disable Transfer delay - cannot be reenabled
1154     function disableTransferDelay() external onlyOwner returns (bool) {
1155         transferDelayEnabled = false;
1156         return true;
1157     }
1158 
1159     // change the minimum amount of tokens to sell from fees
1160     function updateSwapTokensAtAmount(uint256 newAmount)
1161         external
1162         onlyOwner
1163         returns (bool)
1164     {
1165         require(
1166             newAmount >= (totalSupply() * 1) / 100000,
1167             "Swap amount cannot be lower than 0.001% total supply."
1168         );
1169         require(
1170             newAmount <= (totalSupply() * 5) / 1000,
1171             "Swap amount cannot be higher than 0.5% total supply."
1172         );
1173         swapTokensAtAmount = newAmount;
1174         return true;
1175     }
1176 
1177     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1178         require(
1179             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1180             "Cannot set maxTransactionAmount lower than 0.1%"
1181         );
1182         maxTransactionAmount = newNum * (10**18);
1183     }
1184 
1185     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1186         require(
1187             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1188             "Cannot set maxWallet lower than 0.5%"
1189         );
1190         maxWallet = newNum * (10**18);
1191     }
1192 
1193     function excludeFromMaxTransaction(address updAds, bool isEx)
1194         public
1195         onlyOwner
1196     {
1197         _isExcludedMaxTransactionAmount[updAds] = isEx;
1198     }
1199 
1200     // only use to disable contract sales if absolutely necessary (emergency use only)
1201     function updateSwapEnabled(bool enabled) external onlyOwner {
1202         swapEnabled = enabled;
1203     }
1204 
1205     function updateBuyFees(
1206         uint256 _marketingFee,
1207         uint256 _liquidityFee,
1208         uint256 _devFee
1209     ) external onlyOwner {
1210         buyMarketingFee = _marketingFee;
1211         buyLiquidityFee = _liquidityFee;
1212         buyDevFee = _devFee;
1213         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1214         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1215     }
1216 
1217     function updateSellFees(
1218         uint256 _marketingFee,
1219         uint256 _liquidityFee,
1220         uint256 _devFee
1221     ) external onlyOwner {
1222         sellMarketingFee = _marketingFee;
1223         sellLiquidityFee = _liquidityFee;
1224         sellDevFee = _devFee;
1225         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1226         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1227     }
1228 
1229     function excludeFromFees(address account, bool excluded) public onlyOwner {
1230         _isExcludedFromFees[account] = excluded;
1231         emit ExcludeFromFees(account, excluded);
1232     }
1233 
1234     function setAutomatedMarketMakerPair(address pair, bool value)
1235         public
1236         onlyOwner
1237     {
1238         require(
1239             pair != uniswapV2Pair,
1240             "The pair cannot be removed from automatedMarketMakerPairs"
1241         );
1242 
1243         _setAutomatedMarketMakerPair(pair, value);
1244     }
1245 
1246     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1247         automatedMarketMakerPairs[pair] = value;
1248 
1249         emit SetAutomatedMarketMakerPair(pair, value);
1250     }
1251 
1252     function updateMarketingWallet(address newMarketingWallet)
1253         external
1254         onlyOwner
1255     {
1256         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1257         marketingWallet = newMarketingWallet;
1258     }
1259 
1260     function updateDevWallet(address newWallet) external onlyOwner {
1261         emit devWalletUpdated(newWallet, devWallet);
1262         devWallet = newWallet;
1263     }
1264 
1265     function isExcludedFromFees(address account) public view returns (bool) {
1266         return _isExcludedFromFees[account];
1267     }
1268 
1269     event BoughtEarly(address indexed sniper);
1270 
1271     function _transfer(
1272         address from,
1273         address to,
1274         uint256 amount
1275     ) internal override {
1276         require(from != address(0), "ERC20: transfer from the zero address");
1277         require(to != address(0), "ERC20: transfer to the zero address");
1278 
1279         if (amount == 0) {
1280             super._transfer(from, to, 0);
1281             return;
1282         }
1283 
1284         if (limitsInEffect) {
1285             if (
1286                 from != owner() &&
1287                 to != owner() &&
1288                 to != address(0) &&
1289                 to != address(0xdead) &&
1290                 !swapping
1291             ) {
1292                 if (!tradingActive) {
1293                     require(
1294                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1295                         "Trading is not active."
1296                     );
1297                 }
1298 
1299                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1300                 if (transferDelayEnabled) {
1301                     if (
1302                         to != owner() &&
1303                         to != address(uniswapV2Router) &&
1304                         to != address(uniswapV2Pair)
1305                     ) {
1306                         require(
1307                             _holderLastTransferTimestamp[tx.origin] <
1308                                 block.number,
1309                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1310                         );
1311                         _holderLastTransferTimestamp[tx.origin] = block.number;
1312                     }
1313                 }
1314 
1315                 //when buy
1316                 if (
1317                     automatedMarketMakerPairs[from] &&
1318                     !_isExcludedMaxTransactionAmount[to]
1319                 ) {
1320                     require(
1321                         amount <= maxTransactionAmount,
1322                         "Buy transfer amount exceeds the maxTransactionAmount."
1323                     );
1324                     require(
1325                         amount + balanceOf(to) <= maxWallet,
1326                         "Max wallet exceeded"
1327                     );
1328                 }
1329                 //when sell
1330                 else if (
1331                     automatedMarketMakerPairs[to] &&
1332                     !_isExcludedMaxTransactionAmount[from]
1333                 ) {
1334                     require(
1335                         amount <= maxTransactionAmount,
1336                         "Sell transfer amount exceeds the maxTransactionAmount."
1337                     );
1338                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1339                     require(
1340                         amount + balanceOf(to) <= maxWallet,
1341                         "Max wallet exceeded"
1342                     );
1343                 }
1344             }
1345         }
1346 
1347         uint256 contractTokenBalance = balanceOf(address(this));
1348 
1349         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1350 
1351         if (
1352             canSwap &&
1353             swapEnabled &&
1354             !swapping &&
1355             !automatedMarketMakerPairs[from] &&
1356             !_isExcludedFromFees[from] &&
1357             !_isExcludedFromFees[to]
1358         ) {
1359             swapping = true;
1360 
1361             swapBack();
1362 
1363             swapping = false;
1364         }
1365 
1366         if (
1367             !swapping &&
1368             automatedMarketMakerPairs[to] &&
1369             lpBurnEnabled &&
1370             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1371             !_isExcludedFromFees[from]
1372         ) {
1373             autoBurnLiquidityPairTokens();
1374         }
1375 
1376         bool takeFee = !swapping;
1377 
1378         // if any account belongs to _isExcludedFromFee account then remove the fee
1379         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1380             takeFee = false;
1381         }
1382 
1383         uint256 fees = 0;
1384         // only take fees on buys/sells, do not take on wallet transfers
1385         if (takeFee) {
1386             // on sell
1387             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1388                 fees = amount.mul(sellTotalFees).div(100);
1389                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1390                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1391                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1392             }
1393             // on buy
1394             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1395                 fees = amount.mul(buyTotalFees).div(100);
1396                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1397                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1398                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1399             }
1400 
1401             if (fees > 0) {
1402                 super._transfer(from, address(this), fees);
1403             }
1404 
1405             amount -= fees;
1406         }
1407 
1408         super._transfer(from, to, amount);
1409     }
1410 
1411     function swapTokensForEth(uint256 tokenAmount) private {
1412         // generate the uniswap pair path of token -> weth
1413         address[] memory path = new address[](2);
1414         path[0] = address(this);
1415         path[1] = uniswapV2Router.WETH();
1416 
1417         _approve(address(this), address(uniswapV2Router), tokenAmount);
1418 
1419         // make the swap
1420         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1421             tokenAmount,
1422             0, // accept any amount of ETH
1423             path,
1424             address(this),
1425             block.timestamp
1426         );
1427     }
1428 
1429     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1430         // approve token transfer to cover all possible scenarios
1431         _approve(address(this), address(uniswapV2Router), tokenAmount);
1432 
1433         // add the liquidity
1434         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1435             address(this),
1436             tokenAmount,
1437             0, // slippage is unavoidable
1438             0, // slippage is unavoidable
1439             deadAddress,
1440             block.timestamp
1441         );
1442     }
1443 
1444     function swapBack() private {
1445         uint256 contractBalance = balanceOf(address(this));
1446         uint256 totalTokensToSwap = tokensForLiquidity +
1447             tokensForMarketing +
1448             tokensForDev;
1449         bool success;
1450 
1451         if (contractBalance == 0 || totalTokensToSwap == 0) {
1452             return;
1453         }
1454 
1455         if (contractBalance > swapTokensAtAmount * 20) {
1456             contractBalance = swapTokensAtAmount * 20;
1457         }
1458 
1459         // Halve the amount of liquidity tokens
1460         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1461             totalTokensToSwap /
1462             2;
1463         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1464 
1465         uint256 initialETHBalance = address(this).balance;
1466 
1467         swapTokensForEth(amountToSwapForETH);
1468 
1469         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1470 
1471         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1472             totalTokensToSwap
1473         );
1474         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1475 
1476         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1477 
1478         tokensForLiquidity = 0;
1479         tokensForMarketing = 0;
1480         tokensForDev = 0;
1481 
1482         (success, ) = address(devWallet).call{value: ethForDev}("");
1483 
1484         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1485             addLiquidity(liquidityTokens, ethForLiquidity);
1486             emit SwapAndLiquify(
1487                 amountToSwapForETH,
1488                 ethForLiquidity,
1489                 tokensForLiquidity
1490             );
1491         }
1492 
1493         (success, ) = address(marketingWallet).call{
1494             value: address(this).balance
1495         }("");
1496     }
1497 
1498     function setAutoLPBurnSettings(
1499         uint256 _frequencyInSeconds,
1500         uint256 _percent,
1501         bool _Enabled
1502     ) external onlyOwner {
1503         require(
1504             _frequencyInSeconds >= 600,
1505             "cannot set buyback more often than every 10 minutes"
1506         );
1507         require(
1508             _percent <= 1000 && _percent >= 0,
1509             "Must set auto LP burn percent between 0% and 10%"
1510         );
1511         lpBurnFrequency = _frequencyInSeconds;
1512         percentForLPBurn = _percent;
1513         lpBurnEnabled = _Enabled;
1514     }
1515 
1516     function autoBurnLiquidityPairTokens() internal returns (bool) {
1517         lastLpBurnTime = block.timestamp;
1518 
1519         // get balance of liquidity pair
1520         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1521 
1522         // calculate amount to burn
1523         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1524             10000
1525         );
1526 
1527         // pull tokens from pancakePair liquidity and move to dead address permanently
1528         if (amountToBurn > 0) {
1529             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1530         }
1531 
1532         //sync price since this is not in a swap transaction!
1533         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1534         pair.sync();
1535         emit AutoNukeLP();
1536         return true;
1537     }
1538 
1539     function manualBurnLiquidityPairTokens(uint256 percent)
1540         external
1541         onlyOwner
1542         returns (bool)
1543     {
1544         require(
1545             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1546             "Must wait for cooldown to finish"
1547         );
1548         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1549         lastManualLpBurnTime = block.timestamp;
1550 
1551         // get balance of liquidity pair
1552         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1553 
1554         // calculate amount to burn
1555         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1556 
1557         // pull tokens from pancakePair liquidity and move to dead address permanently
1558         if (amountToBurn > 0) {
1559             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1560         }
1561 
1562         //sync price since this is not in a swap transaction!
1563         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1564         pair.sync();
1565         emit ManualNukeLP();
1566         return true;
1567     }
1568 }