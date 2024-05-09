1 /**
2 
3 Telegram: https://t.me/blackmambatoken
4 Twitter: https://twitter.com/mambatoken/
5 Website: https://blackmambatoken.com
6 Medium: https://medium.com/@MambaToken
7 
8 */
9 
10 // SPDX-License-Identifier: MIT
11 pragma solidity >=0.8.10 >=0.8.0 <0.9.0;
12 pragma experimental ABIEncoderV2;
13 
14 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
15 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
16 
17 /* pragma solidity ^0.8.0; */
18 
19 /**
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes calldata) {
35         return msg.data;
36     }
37 }
38 
39 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
40 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
41 
42 /* pragma solidity ^0.8.0; */
43 
44 /* import "../utils/Context.sol"; */
45 
46 /**
47  * @dev Contract module which provides a basic access control mechanism, where
48  * there is an account (an owner) that can be granted exclusive access to
49  * specific functions.
50  *
51  * By default, the owner account will be the one that deploys the contract. This
52  * can later be changed with {transferOwnership}.
53  *
54  * This module is used through inheritance. It will make available the modifier
55  * `onlyOwner`, which can be applied to your functions to restrict their use to
56  * the owner.
57  */
58 abstract contract Ownable is Context {
59     address private _owner;
60 
61     event OwnershipTransferred(
62         address indexed previousOwner,
63         address indexed newOwner
64     );
65 
66     /**
67      * @dev Initializes the contract setting the deployer as the initial owner.
68      */
69     constructor() {
70         _transferOwnership(_msgSender());
71     }
72 
73     /**
74      * @dev Returns the address of the current owner.
75      */
76     function owner() public view virtual returns (address) {
77         return _owner;
78     }
79 
80     /**
81      * @dev Throws if called by any account other than the owner.
82      */
83     modifier onlyOwner() {
84         require(owner() == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     /**
89      * @dev Leaves the contract without owner. It will not be possible to call
90      * `onlyOwner` functions anymore. Can only be called by the current owner.
91      *
92      * NOTE: Renouncing ownership will leave the contract without an owner,
93      * thereby removing any functionality that is only available to the owner.
94      */
95     function renounceOwnership() public virtual onlyOwner {
96         _transferOwnership(address(0));
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Can only be called by the current owner.
102      */
103     function transferOwnership(address newOwner) public virtual onlyOwner {
104         require(
105             newOwner != address(0),
106             "Ownable: new owner is the zero address"
107         );
108         _transferOwnership(newOwner);
109     }
110 
111     /**
112      * @dev Transfers ownership of the contract to a new account (`newOwner`).
113      * Internal function without access restriction.
114      */
115     function _transferOwnership(address newOwner) internal virtual {
116         address oldOwner = _owner;
117         _owner = newOwner;
118         emit OwnershipTransferred(oldOwner, newOwner);
119     }
120 }
121 
122 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
123 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
124 
125 /* pragma solidity ^0.8.0; */
126 
127 /**
128  * @dev Interface of the ERC20 standard as defined in the EIP.
129  */
130 interface IERC20 {
131     /**
132      * @dev Returns the amount of tokens in existence.
133      */
134     function totalSupply() external view returns (uint256);
135 
136     /**
137      * @dev Returns the amount of tokens owned by `account`.
138      */
139     function balanceOf(address account) external view returns (uint256);
140 
141     /**
142      * @dev Moves `amount` tokens from the caller's account to `recipient`.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transfer(address recipient, uint256 amount)
149         external
150         returns (bool);
151 
152     /**
153      * @dev Returns the remaining number of tokens that `spender` will be
154      * allowed to spend on behalf of `owner` through {transferFrom}. This is
155      * zero by default.
156      *
157      * This value changes when {approve} or {transferFrom} are called.
158      */
159     function allowance(address owner, address spender)
160         external
161         view
162         returns (uint256);
163 
164     /**
165      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * IMPORTANT: Beware that changing an allowance with this method brings the risk
170      * that someone may use both the old and the new allowance by unfortunate
171      * transaction ordering. One possible solution to mitigate this race
172      * condition is to first reduce the spender's allowance to 0 and set the
173      * desired value afterwards:
174      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
175      *
176      * Emits an {Approval} event.
177      */
178     function approve(address spender, uint256 amount) external returns (bool);
179 
180     /**
181      * @dev Moves `amount` tokens from `sender` to `recipient` using the
182      * allowance mechanism. `amount` is then deducted from the caller's
183      * allowance.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * Emits a {Transfer} event.
188      */
189     function transferFrom(
190         address sender,
191         address recipient,
192         uint256 amount
193     ) external returns (bool);
194 
195     /**
196      * @dev Emitted when `value` tokens are moved from one account (`from`) to
197      * another (`to`).
198      *
199      * Note that `value` may be zero.
200      */
201     event Transfer(address indexed from, address indexed to, uint256 value);
202 
203     /**
204      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
205      * a call to {approve}. `value` is the new allowance.
206      */
207     event Approval(
208         address indexed owner,
209         address indexed spender,
210         uint256 value
211     );
212 }
213 
214 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
215 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
216 
217 /* pragma solidity ^0.8.0; */
218 
219 /* import "../IERC20.sol"; */
220 
221 /**
222  * @dev Interface for the optional metadata functions from the ERC20 standard.
223  *
224  * _Available since v4.1._
225  */
226 interface IERC20Metadata is IERC20 {
227     /**
228      * @dev Returns the name of the token.
229      */
230     function name() external view returns (string memory);
231 
232     /**
233      * @dev Returns the symbol of the token.
234      */
235     function symbol() external view returns (string memory);
236 
237     /**
238      * @dev Returns the decimals places of the token.
239      */
240     function decimals() external view returns (uint8);
241 }
242 
243 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
244 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
245 
246 /* pragma solidity ^0.8.0; */
247 
248 /* import "./IERC20.sol"; */
249 /* import "./extensions/IERC20Metadata.sol"; */
250 /* import "../../utils/Context.sol"; */
251 
252 /**
253  * @dev Implementation of the {IERC20} interface.
254  *
255  * This implementation is agnostic to the way tokens are created. This means
256  * that a supply mechanism has to be added in a derived contract using {_mint}.
257  * For a generic mechanism see {ERC20PresetMinterPauser}.
258  *
259  * TIP: For a detailed writeup see our guide
260  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
261  * to implement supply mechanisms].
262  *
263  * We have followed general OpenZeppelin Contracts guidelines: functions revert
264  * instead returning `false` on failure. This behavior is nonetheless
265  * conventional and does not conflict with the expectations of ERC20
266  * applications.
267  *
268  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
269  * This allows applications to reconstruct the allowance for all accounts just
270  * by listening to said events. Other implementations of the EIP may not emit
271  * these events, as it isn't required by the specification.
272  *
273  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
274  * functions have been added to mitigate the well-known issues around setting
275  * allowances. See {IERC20-approve}.
276  */
277 contract ERC20 is Context, IERC20, IERC20Metadata {
278     mapping(address => uint256) private _balances;
279 
280     mapping(address => mapping(address => uint256)) private _allowances;
281 
282     uint256 private _totalSupply;
283 
284     string private _name;
285     string private _symbol;
286 
287     /**
288      * @dev Sets the values for {name} and {symbol}.
289      *
290      * The default value of {decimals} is 18. To select a different value for
291      * {decimals} you should overload it.
292      *
293      * All two of these values are immutable: they can only be set once during
294      * construction.
295      */
296     constructor(string memory name_, string memory symbol_) {
297         _name = name_;
298         _symbol = symbol_;
299     }
300 
301     /**
302      * @dev Returns the name of the token.
303      */
304     function name() public view virtual override returns (string memory) {
305         return _name;
306     }
307 
308     /**
309      * @dev Returns the symbol of the token, usually a shorter version of the
310      * name.
311      */
312     function symbol() public view virtual override returns (string memory) {
313         return _symbol;
314     }
315 
316     /**
317      * @dev Returns the number of decimals used to get its user representation.
318      * For example, if `decimals` equals `2`, a balance of `505` tokens should
319      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
320      *
321      * Tokens usually opt for a value of 18, imitating the relationship between
322      * Ether and Wei. This is the value {ERC20} uses, unless this function is
323      * overridden;
324      *
325      * NOTE: This information is only used for _display_ purposes: it in
326      * no way affects any of the arithmetic of the contract, including
327      * {IERC20-balanceOf} and {IERC20-transfer}.
328      */
329     function decimals() public view virtual override returns (uint8) {
330         return 18;
331     }
332 
333     /**
334      * @dev See {IERC20-totalSupply}.
335      */
336     function totalSupply() public view virtual override returns (uint256) {
337         return _totalSupply;
338     }
339 
340     /**
341      * @dev See {IERC20-balanceOf}.
342      */
343     function balanceOf(address account)
344         public
345         view
346         virtual
347         override
348         returns (uint256)
349     {
350         return _balances[account];
351     }
352 
353     /**
354      * @dev See {IERC20-transfer}.
355      *
356      * Requirements:
357      *
358      * - `recipient` cannot be the zero address.
359      * - the caller must have a balance of at least `amount`.
360      */
361     function transfer(address recipient, uint256 amount)
362         public
363         virtual
364         override
365         returns (bool)
366     {
367         _transfer(_msgSender(), recipient, amount);
368         return true;
369     }
370 
371     /**
372      * @dev See {IERC20-allowance}.
373      */
374     function allowance(address owner, address spender)
375         public
376         view
377         virtual
378         override
379         returns (uint256)
380     {
381         return _allowances[owner][spender];
382     }
383 
384     /**
385      * @dev See {IERC20-approve}.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      */
391     function approve(address spender, uint256 amount)
392         public
393         virtual
394         override
395         returns (bool)
396     {
397         _approve(_msgSender(), spender, amount);
398         return true;
399     }
400 
401     /**
402      * @dev See {IERC20-transferFrom}.
403      *
404      * Emits an {Approval} event indicating the updated allowance. This is not
405      * required by the EIP. See the note at the beginning of {ERC20}.
406      *
407      * Requirements:
408      *
409      * - `sender` and `recipient` cannot be the zero address.
410      * - `sender` must have a balance of at least `amount`.
411      * - the caller must have allowance for ``sender``'s tokens of at least
412      * `amount`.
413      */
414     function transferFrom(
415         address sender,
416         address recipient,
417         uint256 amount
418     ) public virtual override returns (bool) {
419         _transfer(sender, recipient, amount);
420 
421         uint256 currentAllowance = _allowances[sender][_msgSender()];
422         require(
423             currentAllowance >= amount,
424             "ERC20: transfer amount exceeds allowance"
425         );
426         unchecked {
427             _approve(sender, _msgSender(), currentAllowance - amount);
428         }
429 
430         return true;
431     }
432 
433     /**
434      * @dev Atomically increases the allowance granted to `spender` by the caller.
435      *
436      * This is an alternative to {approve} that can be used as a mitigation for
437      * problems described in {IERC20-approve}.
438      *
439      * Emits an {Approval} event indicating the updated allowance.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      */
445     function increaseAllowance(address spender, uint256 addedValue)
446         public
447         virtual
448         returns (bool)
449     {
450         _approve(
451             _msgSender(),
452             spender,
453             _allowances[_msgSender()][spender] + addedValue
454         );
455         return true;
456     }
457 
458     /**
459      * @dev Atomically decreases the allowance granted to `spender` by the caller.
460      *
461      * This is an alternative to {approve} that can be used as a mitigation for
462      * problems described in {IERC20-approve}.
463      *
464      * Emits an {Approval} event indicating the updated allowance.
465      *
466      * Requirements:
467      *
468      * - `spender` cannot be the zero address.
469      * - `spender` must have allowance for the caller of at least
470      * `subtractedValue`.
471      */
472     function decreaseAllowance(address spender, uint256 subtractedValue)
473         public
474         virtual
475         returns (bool)
476     {
477         uint256 currentAllowance = _allowances[_msgSender()][spender];
478         require(
479             currentAllowance >= subtractedValue,
480             "ERC20: decreased allowance below zero"
481         );
482         unchecked {
483             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
484         }
485 
486         return true;
487     }
488 
489     /**
490      * @dev Moves `amount` of tokens from `sender` to `recipient`.
491      *
492      * This internal function is equivalent to {transfer}, and can be used to
493      * e.g. implement automatic token fees, slashing mechanisms, etc.
494      *
495      * Emits a {Transfer} event.
496      *
497      * Requirements:
498      *
499      * - `sender` cannot be the zero address.
500      * - `recipient` cannot be the zero address.
501      * - `sender` must have a balance of at least `amount`.
502      */
503     function _transfer(
504         address sender,
505         address recipient,
506         uint256 amount
507     ) internal virtual {
508         require(sender != address(0), "ERC20: transfer from the zero address");
509         require(recipient != address(0), "ERC20: transfer to the zero address");
510 
511         _beforeTokenTransfer(sender, recipient, amount);
512 
513         uint256 senderBalance = _balances[sender];
514         require(
515             senderBalance >= amount,
516             "ERC20: transfer amount exceeds balance"
517         );
518         unchecked {
519             _balances[sender] = senderBalance - amount;
520         }
521         _balances[recipient] += amount;
522 
523         emit Transfer(sender, recipient, amount);
524 
525         _afterTokenTransfer(sender, recipient, amount);
526     }
527 
528     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
529      * the total supply.
530      *
531      * Emits a {Transfer} event with `from` set to the zero address.
532      *
533      * Requirements:
534      *
535      * - `account` cannot be the zero address.
536      */
537     function _mint(address account, uint256 amount) internal virtual {
538         require(account != address(0), "ERC20: mint to the zero address");
539 
540         _beforeTokenTransfer(address(0), account, amount);
541 
542         _totalSupply += amount;
543         _balances[account] += amount;
544         emit Transfer(address(0), account, amount);
545 
546         _afterTokenTransfer(address(0), account, amount);
547     }
548 
549     /**
550      * @dev Destroys `amount` tokens from `account`, reducing the
551      * total supply.
552      *
553      * Emits a {Transfer} event with `to` set to the zero address.
554      *
555      * Requirements:
556      *
557      * - `account` cannot be the zero address.
558      * - `account` must have at least `amount` tokens.
559      */
560     function _burn(address account, uint256 amount) internal virtual {
561         require(account != address(0), "ERC20: burn from the zero address");
562 
563         _beforeTokenTransfer(account, address(0), amount);
564 
565         uint256 accountBalance = _balances[account];
566         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
567         unchecked {
568             _balances[account] = accountBalance - amount;
569         }
570         _totalSupply -= amount;
571 
572         emit Transfer(account, address(0), amount);
573 
574         _afterTokenTransfer(account, address(0), amount);
575     }
576 
577     /**
578      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
579      *
580      * This internal function is equivalent to `approve`, and can be used to
581      * e.g. set automatic allowances for certain subsystems, etc.
582      *
583      * Emits an {Approval} event.
584      *
585      * Requirements:
586      *
587      * - `owner` cannot be the zero address.
588      * - `spender` cannot be the zero address.
589      */
590     function _approve(
591         address owner,
592         address spender,
593         uint256 amount
594     ) internal virtual {
595         require(owner != address(0), "ERC20: approve from the zero address");
596         require(spender != address(0), "ERC20: approve to the zero address");
597 
598         _allowances[owner][spender] = amount;
599         emit Approval(owner, spender, amount);
600     }
601 
602     /**
603      * @dev Hook that is called before any transfer of tokens. This includes
604      * minting and burning.
605      *
606      * Calling conditions:
607      *
608      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
609      * will be transferred to `to`.
610      * - when `from` is zero, `amount` tokens will be minted for `to`.
611      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
612      * - `from` and `to` are never both zero.
613      *
614      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
615      */
616     function _beforeTokenTransfer(
617         address from,
618         address to,
619         uint256 amount
620     ) internal virtual {}
621 
622     /**
623      * @dev Hook that is called after any transfer of tokens. This includes
624      * minting and burning.
625      *
626      * Calling conditions:
627      *
628      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
629      * has been transferred to `to`.
630      * - when `from` is zero, `amount` tokens have been minted for `to`.
631      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
632      * - `from` and `to` are never both zero.
633      *
634      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
635      */
636     function _afterTokenTransfer(
637         address from,
638         address to,
639         uint256 amount
640     ) internal virtual {}
641 }
642 
643 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
644 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
645 
646 /* pragma solidity ^0.8.0; */
647 
648 // CAUTION
649 // This version of SafeMath should only be used with Solidity 0.8 or later,
650 // because it relies on the compiler's built in overflow checks.
651 
652 /**
653  * @dev Wrappers over Solidity's arithmetic operations.
654  *
655  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
656  * now has built in overflow checking.
657  */
658 library SafeMath {
659     /**
660      * @dev Returns the addition of two unsigned integers, with an overflow flag.
661      *
662      * _Available since v3.4._
663      */
664     function tryAdd(uint256 a, uint256 b)
665         internal
666         pure
667         returns (bool, uint256)
668     {
669         unchecked {
670             uint256 c = a + b;
671             if (c < a) return (false, 0);
672             return (true, c);
673         }
674     }
675 
676     /**
677      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
678      *
679      * _Available since v3.4._
680      */
681     function trySub(uint256 a, uint256 b)
682         internal
683         pure
684         returns (bool, uint256)
685     {
686         unchecked {
687             if (b > a) return (false, 0);
688             return (true, a - b);
689         }
690     }
691 
692     /**
693      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
694      *
695      * _Available since v3.4._
696      */
697     function tryMul(uint256 a, uint256 b)
698         internal
699         pure
700         returns (bool, uint256)
701     {
702         unchecked {
703             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
704             // benefit is lost if 'b' is also tested.
705             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
706             if (a == 0) return (true, 0);
707             uint256 c = a * b;
708             if (c / a != b) return (false, 0);
709             return (true, c);
710         }
711     }
712 
713     /**
714      * @dev Returns the division of two unsigned integers, with a division by zero flag.
715      *
716      * _Available since v3.4._
717      */
718     function tryDiv(uint256 a, uint256 b)
719         internal
720         pure
721         returns (bool, uint256)
722     {
723         unchecked {
724             if (b == 0) return (false, 0);
725             return (true, a / b);
726         }
727     }
728 
729     /**
730      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
731      *
732      * _Available since v3.4._
733      */
734     function tryMod(uint256 a, uint256 b)
735         internal
736         pure
737         returns (bool, uint256)
738     {
739         unchecked {
740             if (b == 0) return (false, 0);
741             return (true, a % b);
742         }
743     }
744 
745     /**
746      * @dev Returns the addition of two unsigned integers, reverting on
747      * overflow.
748      *
749      * Counterpart to Solidity's `+` operator.
750      *
751      * Requirements:
752      *
753      * - Addition cannot overflow.
754      */
755     function add(uint256 a, uint256 b) internal pure returns (uint256) {
756         return a + b;
757     }
758 
759     /**
760      * @dev Returns the subtraction of two unsigned integers, reverting on
761      * overflow (when the result is negative).
762      *
763      * Counterpart to Solidity's `-` operator.
764      *
765      * Requirements:
766      *
767      * - Subtraction cannot overflow.
768      */
769     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
770         return a - b;
771     }
772 
773     /**
774      * @dev Returns the multiplication of two unsigned integers, reverting on
775      * overflow.
776      *
777      * Counterpart to Solidity's `*` operator.
778      *
779      * Requirements:
780      *
781      * - Multiplication cannot overflow.
782      */
783     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
784         return a * b;
785     }
786 
787     /**
788      * @dev Returns the integer division of two unsigned integers, reverting on
789      * division by zero. The result is rounded towards zero.
790      *
791      * Counterpart to Solidity's `/` operator.
792      *
793      * Requirements:
794      *
795      * - The divisor cannot be zero.
796      */
797     function div(uint256 a, uint256 b) internal pure returns (uint256) {
798         return a / b;
799     }
800 
801     /**
802      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
803      * reverting when dividing by zero.
804      *
805      * Counterpart to Solidity's `%` operator. This function uses a `revert`
806      * opcode (which leaves remaining gas untouched) while Solidity uses an
807      * invalid opcode to revert (consuming all remaining gas).
808      *
809      * Requirements:
810      *
811      * - The divisor cannot be zero.
812      */
813     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
814         return a % b;
815     }
816 
817     /**
818      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
819      * overflow (when the result is negative).
820      *
821      * CAUTION: This function is deprecated because it requires allocating memory for the error
822      * message unnecessarily. For custom revert reasons use {trySub}.
823      *
824      * Counterpart to Solidity's `-` operator.
825      *
826      * Requirements:
827      *
828      * - Subtraction cannot overflow.
829      */
830     function sub(
831         uint256 a,
832         uint256 b,
833         string memory errorMessage
834     ) internal pure returns (uint256) {
835         unchecked {
836             require(b <= a, errorMessage);
837             return a - b;
838         }
839     }
840 
841     /**
842      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
843      * division by zero. The result is rounded towards zero.
844      *
845      * Counterpart to Solidity's `/` operator. Note: this function uses a
846      * `revert` opcode (which leaves remaining gas untouched) while Solidity
847      * uses an invalid opcode to revert (consuming all remaining gas).
848      *
849      * Requirements:
850      *
851      * - The divisor cannot be zero.
852      */
853     function div(
854         uint256 a,
855         uint256 b,
856         string memory errorMessage
857     ) internal pure returns (uint256) {
858         unchecked {
859             require(b > 0, errorMessage);
860             return a / b;
861         }
862     }
863 
864     /**
865      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
866      * reverting with custom message when dividing by zero.
867      *
868      * CAUTION: This function is deprecated because it requires allocating memory for the error
869      * message unnecessarily. For custom revert reasons use {tryMod}.
870      *
871      * Counterpart to Solidity's `%` operator. This function uses a `revert`
872      * opcode (which leaves remaining gas untouched) while Solidity uses an
873      * invalid opcode to revert (consuming all remaining gas).
874      *
875      * Requirements:
876      *
877      * - The divisor cannot be zero.
878      */
879     function mod(
880         uint256 a,
881         uint256 b,
882         string memory errorMessage
883     ) internal pure returns (uint256) {
884         unchecked {
885             require(b > 0, errorMessage);
886             return a % b;
887         }
888     }
889 }
890 
891 ////// src/IUniswapV2Factory.sol
892 /* pragma solidity 0.8.10; */
893 /* pragma experimental ABIEncoderV2; */
894 
895 interface IUniswapV2Factory {
896     event PairCreated(
897         address indexed token0,
898         address indexed token1,
899         address pair,
900         uint256
901     );
902 
903     function feeTo() external view returns (address);
904 
905     function feeToSetter() external view returns (address);
906 
907     function getPair(address tokenA, address tokenB)
908         external
909         view
910         returns (address pair);
911 
912     function allPairs(uint256) external view returns (address pair);
913 
914     function allPairsLength() external view returns (uint256);
915 
916     function createPair(address tokenA, address tokenB)
917         external
918         returns (address pair);
919 
920     function setFeeTo(address) external;
921 
922     function setFeeToSetter(address) external;
923 }
924 
925 ////// src/IUniswapV2Pair.sol
926 /* pragma solidity 0.8.10; */
927 /* pragma experimental ABIEncoderV2; */
928 
929 interface IUniswapV2Pair {
930     event Approval(
931         address indexed owner,
932         address indexed spender,
933         uint256 value
934     );
935     event Transfer(address indexed from, address indexed to, uint256 value);
936 
937     function name() external pure returns (string memory);
938 
939     function symbol() external pure returns (string memory);
940 
941     function decimals() external pure returns (uint8);
942 
943     function totalSupply() external view returns (uint256);
944 
945     function balanceOf(address owner) external view returns (uint256);
946 
947     function allowance(address owner, address spender)
948         external
949         view
950         returns (uint256);
951 
952     function approve(address spender, uint256 value) external returns (bool);
953 
954     function transfer(address to, uint256 value) external returns (bool);
955 
956     function transferFrom(
957         address from,
958         address to,
959         uint256 value
960     ) external returns (bool);
961 
962     function DOMAIN_SEPARATOR() external view returns (bytes32);
963 
964     function PERMIT_TYPEHASH() external pure returns (bytes32);
965 
966     function nonces(address owner) external view returns (uint256);
967 
968     function permit(
969         address owner,
970         address spender,
971         uint256 value,
972         uint256 deadline,
973         uint8 v,
974         bytes32 r,
975         bytes32 s
976     ) external;
977 
978     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
979     event Burn(
980         address indexed sender,
981         uint256 amount0,
982         uint256 amount1,
983         address indexed to
984     );
985     event Swap(
986         address indexed sender,
987         uint256 amount0In,
988         uint256 amount1In,
989         uint256 amount0Out,
990         uint256 amount1Out,
991         address indexed to
992     );
993     event Sync(uint112 reserve0, uint112 reserve1);
994 
995     function MINIMUM_LIQUIDITY() external pure returns (uint256);
996 
997     function factory() external view returns (address);
998 
999     function token0() external view returns (address);
1000 
1001     function token1() external view returns (address);
1002 
1003     function getReserves()
1004         external
1005         view
1006         returns (
1007             uint112 reserve0,
1008             uint112 reserve1,
1009             uint32 blockTimestampLast
1010         );
1011 
1012     function price0CumulativeLast() external view returns (uint256);
1013 
1014     function price1CumulativeLast() external view returns (uint256);
1015 
1016     function kLast() external view returns (uint256);
1017 
1018     function mint(address to) external returns (uint256 liquidity);
1019 
1020     function burn(address to)
1021         external
1022         returns (uint256 amount0, uint256 amount1);
1023 
1024     function swap(
1025         uint256 amount0Out,
1026         uint256 amount1Out,
1027         address to,
1028         bytes calldata data
1029     ) external;
1030 
1031     function skim(address to) external;
1032 
1033     function sync() external;
1034 
1035     function initialize(address, address) external;
1036 }
1037 
1038 ////// src/IUniswapV2Router02.sol
1039 /* pragma solidity 0.8.10; */
1040 /* pragma experimental ABIEncoderV2; */
1041 
1042 interface IUniswapV2Router02 {
1043     function factory() external pure returns (address);
1044 
1045     function WETH() external pure returns (address);
1046 
1047     function addLiquidity(
1048         address tokenA,
1049         address tokenB,
1050         uint256 amountADesired,
1051         uint256 amountBDesired,
1052         uint256 amountAMin,
1053         uint256 amountBMin,
1054         address to,
1055         uint256 deadline
1056     )
1057         external
1058         returns (
1059             uint256 amountA,
1060             uint256 amountB,
1061             uint256 liquidity
1062         );
1063 
1064     function addLiquidityETH(
1065         address token,
1066         uint256 amountTokenDesired,
1067         uint256 amountTokenMin,
1068         uint256 amountETHMin,
1069         address to,
1070         uint256 deadline
1071     )
1072         external
1073         payable
1074         returns (
1075             uint256 amountToken,
1076             uint256 amountETH,
1077             uint256 liquidity
1078         );
1079 
1080     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1081         uint256 amountIn,
1082         uint256 amountOutMin,
1083         address[] calldata path,
1084         address to,
1085         uint256 deadline
1086     ) external;
1087 
1088     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1089         uint256 amountOutMin,
1090         address[] calldata path,
1091         address to,
1092         uint256 deadline
1093     ) external payable;
1094 
1095     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1096         uint256 amountIn,
1097         uint256 amountOutMin,
1098         address[] calldata path,
1099         address to,
1100         uint256 deadline
1101     ) external;
1102 }
1103 
1104 contract BlackMamba is ERC20, Ownable {
1105     using SafeMath for uint256;
1106 
1107     IUniswapV2Router02 public immutable uniswapV2Router;
1108     address public immutable uniswapV2Pair;
1109     address public constant deadAddress = address(0xdead);
1110 
1111     bool private swapping;
1112 
1113     address public marketingWallet;
1114     address public devWallet;
1115 
1116     uint256 public maxTransactionAmount;
1117     uint256 public swapTokensAtAmount;
1118     uint256 public maxWallet;
1119 
1120     bool public limitsInEffect = true;
1121     bool public tradingActive = false;
1122     bool public swapEnabled = false;
1123 
1124     // Anti-bot and anti-whale mappings and variables
1125     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1126     bool public transferDelayEnabled = true;
1127 
1128     // Blacklist Map
1129     mapping (address => bool) private _blacklist;
1130 
1131     uint256 public buyTotalFees;
1132     uint256 public buyMarketingFee;
1133     uint256 public buyLiquidityFee;
1134     uint256 public buyDevFee;
1135 
1136     uint256 public sellTotalFees;
1137     uint256 public sellMarketingFee;
1138     uint256 public sellLiquidityFee;
1139     uint256 public sellDevFee;
1140 
1141     uint256 public tokensForMarketing;
1142     uint256 public tokensForLiquidity;
1143     uint256 public tokensForDev;
1144 
1145     // block number of opened trading
1146     uint256 launchedAt;
1147 
1148     /******************/
1149 
1150     // exlcude from fees and max transaction amount
1151     mapping(address => bool) private _isExcludedFromFees;
1152     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1153 
1154     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1155     // could be subject to a maximum transfer amount
1156     mapping(address => bool) public automatedMarketMakerPairs;
1157 
1158     event UpdateUniswapV2Router(
1159         address indexed newAddress,
1160         address indexed oldAddress
1161     );
1162 
1163     event ExcludeFromFees(address indexed account, bool isExcluded);
1164 
1165     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1166 
1167     event marketingWalletUpdated(
1168         address indexed newWallet,
1169         address indexed oldWallet
1170     );
1171 
1172     event devWalletUpdated(
1173         address indexed newWallet,
1174         address indexed oldWallet
1175     );
1176 
1177     event SwapAndLiquify(
1178         uint256 tokensSwapped,
1179         uint256 ethReceived,
1180         uint256 tokensIntoLiquidity
1181     );
1182 
1183     constructor() ERC20("Black Mamba", "MAMBA") {
1184         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1185             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1186         );
1187 
1188         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1189         uniswapV2Router = _uniswapV2Router;
1190 
1191         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1192             .createPair(address(this), _uniswapV2Router.WETH());
1193         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1194         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1195         
1196         uint256 _buyMarketingFee = 10;
1197         uint256 _buyLiquidityFee = 0;
1198         uint256 _buyDevFee = 10;
1199 
1200         uint256 _sellMarketingFee = 10;
1201         uint256 _sellLiquidityFee = 0;
1202         uint256 _sellDevFee = 15;
1203 
1204         uint256 totalSupply = 100_000_000 * 1e18;
1205 
1206         maxTransactionAmount = (totalSupply * 30) / 1000; // 3% from total supply maxTransactionAmountTxn
1207         maxWallet = (totalSupply * 30) / 1000; // 3% from total supply maxWallet
1208         swapTokensAtAmount = (totalSupply * 4) / 10000; // 0.04% swap wallet
1209 
1210         buyMarketingFee = _buyMarketingFee;
1211         buyLiquidityFee = _buyLiquidityFee;
1212         buyDevFee = _buyDevFee;
1213         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1214 
1215         sellMarketingFee = _sellMarketingFee;
1216         sellLiquidityFee = _sellLiquidityFee;
1217         sellDevFee = _sellDevFee;
1218         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1219 
1220         marketingWallet = address(0xe1a3D6fE187Dd9942ACC679065F178cA9F4B36bb); // set as marketing wallet
1221         devWallet = address(0xe1a3D6fE187Dd9942ACC679065F178cA9F4B36bb); // set as dev wallet
1222 
1223         // exclude from paying fees or having max transaction amount
1224         excludeFromFees(owner(), true);
1225         excludeFromFees(marketingWallet, true);
1226         excludeFromFees(devWallet, true);
1227         excludeFromFees(address(this), true);
1228         excludeFromFees(address(0xdead), true);
1229 
1230         excludeFromMaxTransaction(owner(), true);
1231         excludeFromMaxTransaction(marketingWallet, true);
1232         excludeFromMaxTransaction(devWallet, true);
1233         excludeFromMaxTransaction(address(this), true);
1234         excludeFromMaxTransaction(address(0xdead), true);
1235 
1236         /*
1237             _mint is an internal function in ERC20.sol that is only called here,
1238             and CANNOT be called ever again
1239         */
1240         _mint(msg.sender, totalSupply);
1241     }
1242 
1243     receive() external payable {}
1244 
1245     // once enabled, can never be turned off
1246     function enableTrading() external onlyOwner {
1247         tradingActive = true;
1248         swapEnabled = true;
1249         launchedAt = block.number;
1250     }
1251 
1252     // remove limits after token is stable
1253     function removeLimits() external onlyOwner returns (bool) {
1254         limitsInEffect = false;
1255         return true;
1256     }
1257 
1258     // disable Transfer delay - cannot be reenabled
1259     function disableTransferDelay() external onlyOwner returns (bool) {
1260         transferDelayEnabled = false;
1261         return true;
1262     }
1263 
1264     // change the minimum amount of tokens to sell from fees
1265     function updateSwapTokensAtAmount(uint256 newAmount)
1266         external
1267         onlyOwner
1268         returns (bool)
1269     {
1270         require(
1271             newAmount >= (totalSupply() * 1) / 100000,
1272             "Swap amount cannot be lower than 0.001% total supply."
1273         );
1274         require(
1275             newAmount <= (totalSupply() * 5) / 1000,
1276             "Swap amount cannot be higher than 0.5% total supply."
1277         );
1278         swapTokensAtAmount = newAmount;
1279         return true;
1280     }
1281 
1282     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1283         require(
1284             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1285             "Cannot set maxTransactionAmount lower than 0.1%"
1286         );
1287         maxTransactionAmount = newNum * (10**18);
1288     }
1289 
1290     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1291         require(
1292             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1293             "Cannot set maxWallet lower than 0.5%"
1294         );
1295         maxWallet = newNum * (10**18);
1296     }
1297 
1298     function excludeFromMaxTransaction(address updAds, bool isEx)
1299         public
1300         onlyOwner
1301     {
1302         _isExcludedMaxTransactionAmount[updAds] = isEx;
1303     }
1304 
1305     // only use to disable contract sales if absolutely necessary (emergency use only)
1306     function updateSwapEnabled(bool enabled) external onlyOwner {
1307         swapEnabled = enabled;
1308     }
1309 
1310     function updateBuyFees(
1311         uint256 _marketingFee,
1312         uint256 _liquidityFee,
1313         uint256 _devFee
1314     ) external onlyOwner {
1315         buyMarketingFee = _marketingFee;
1316         buyLiquidityFee = _liquidityFee;
1317         buyDevFee = _devFee;
1318         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1319         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1320     }
1321 
1322     function updateSellFees(
1323         uint256 _marketingFee,
1324         uint256 _liquidityFee,
1325         uint256 _devFee
1326     ) external onlyOwner {
1327         sellMarketingFee = _marketingFee;
1328         sellLiquidityFee = _liquidityFee;
1329         sellDevFee = _devFee;
1330         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1331         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
1332     }
1333 
1334     function excludeFromFees(address account, bool excluded) public onlyOwner {
1335         _isExcludedFromFees[account] = excluded;
1336         emit ExcludeFromFees(account, excluded);
1337     }
1338 
1339     function blacklistAccounts(address[] memory accounts) public onlyOwner {
1340         for (uint i = 0; i < accounts.length; i++) {
1341             _blacklist[accounts[i]] = true;
1342         }
1343     }
1344 
1345     function unBlacklistAccounts(address[] memory accounts) public onlyOwner {
1346         for (uint i = 0; i < accounts.length; i++) {
1347             _blacklist[accounts[i]] = false;
1348         }
1349     }
1350 
1351     function setAutomatedMarketMakerPair(address pair, bool value)
1352         public
1353         onlyOwner
1354     {
1355         require(
1356             pair != uniswapV2Pair,
1357             "The pair cannot be removed from automatedMarketMakerPairs"
1358         );
1359 
1360         _setAutomatedMarketMakerPair(pair, value);
1361     }
1362 
1363     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1364         automatedMarketMakerPairs[pair] = value;
1365 
1366         emit SetAutomatedMarketMakerPair(pair, value);
1367     }
1368 
1369     function updateMarketingWallet(address newMarketingWallet)
1370         external
1371         onlyOwner
1372     {
1373         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1374         marketingWallet = newMarketingWallet;
1375     }
1376 
1377     function updateDevWallet(address newWallet) external onlyOwner {
1378         emit devWalletUpdated(newWallet, devWallet);
1379         devWallet = newWallet;
1380     }
1381 
1382     function isExcludedFromFees(address account) public view returns (bool) {
1383         return _isExcludedFromFees[account];
1384     }
1385 
1386     function _transfer(
1387         address from,
1388         address to,
1389         uint256 amount
1390     ) internal override {
1391         require(from != address(0), "ERC20: transfer from the zero address");
1392         require(to != address(0), "ERC20: transfer to the zero address");
1393         require(!_blacklist[to] && !_blacklist[from], "You have been blacklisted from transfering tokens");
1394 
1395         if (amount == 0) {
1396             super._transfer(from, to, 0);
1397             return;
1398         }
1399 
1400         if (limitsInEffect) {
1401             if (
1402                 from != owner() &&
1403                 to != owner() &&
1404                 to != address(0) &&
1405                 to != address(0xdead) &&
1406                 !swapping
1407             ) {
1408                 if (!tradingActive) {
1409                     require(
1410                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1411                         "Trading is not active."
1412                     );
1413                 }
1414 
1415                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1416                 if (transferDelayEnabled) {
1417                     if (
1418                         to != owner() &&
1419                         to != address(uniswapV2Router) &&
1420                         to != address(uniswapV2Pair)
1421                     ) {
1422                         require(
1423                             _holderLastTransferTimestamp[tx.origin] <
1424                                 block.number,
1425                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1426                         );
1427                         _holderLastTransferTimestamp[tx.origin] = block.number;
1428                     }
1429                 }
1430 
1431                 //when buy
1432                 if (
1433                     automatedMarketMakerPairs[from] &&
1434                     !_isExcludedMaxTransactionAmount[to]
1435                 ) {
1436                     require(
1437                         amount <= maxTransactionAmount,
1438                         "Buy transfer amount exceeds the maxTransactionAmount."
1439                     );
1440                     require(
1441                         amount + balanceOf(to) <= maxWallet,
1442                         "Max wallet exceeded"
1443                     );
1444                 }
1445                 //when sell
1446                 else if (
1447                     automatedMarketMakerPairs[to] &&
1448                     !_isExcludedMaxTransactionAmount[from]
1449                 ) {
1450                     require(
1451                         amount <= maxTransactionAmount,
1452                         "Sell transfer amount exceeds the maxTransactionAmount."
1453                     );
1454                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1455                     require(
1456                         amount + balanceOf(to) <= maxWallet,
1457                         "Max wallet exceeded"
1458                     );
1459                 }
1460             }
1461         }
1462 
1463         // anti bot logic
1464         if (block.number <= (launchedAt + 2) &&
1465                 to != uniswapV2Pair && 
1466                 to != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1467             ) { 
1468             _blacklist[to] = true;
1469         }
1470 
1471         uint256 contractTokenBalance = balanceOf(address(this));
1472 
1473         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1474 
1475         if (
1476             canSwap &&
1477             swapEnabled &&
1478             !swapping &&
1479             !automatedMarketMakerPairs[from] &&
1480             !_isExcludedFromFees[from] &&
1481             !_isExcludedFromFees[to]
1482         ) {
1483             swapping = true;
1484 
1485             swapBack();
1486 
1487             swapping = false;
1488         }
1489 
1490         bool takeFee = !swapping;
1491 
1492         // if any account belongs to _isExcludedFromFee account then remove the fee
1493         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1494             takeFee = false;
1495         }
1496 
1497         uint256 fees = 0;
1498         // only take fees on buys/sells, do not take on wallet transfers
1499         if (takeFee) {
1500             // on sell
1501             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1502                 fees = amount.mul(sellTotalFees).div(100);
1503                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1504                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1505                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1506             }
1507             // on buy
1508             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1509                 fees = amount.mul(buyTotalFees).div(100);
1510                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1511                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1512                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1513             }
1514 
1515             if (fees > 0) {
1516                 super._transfer(from, address(this), fees);
1517             }
1518 
1519             amount -= fees;
1520         }
1521 
1522         super._transfer(from, to, amount);
1523     }
1524 
1525     function swapTokensForEth(uint256 tokenAmount) private {
1526         // generate the uniswap pair path of token -> weth
1527         address[] memory path = new address[](2);
1528         path[0] = address(this);
1529         path[1] = uniswapV2Router.WETH();
1530 
1531         _approve(address(this), address(uniswapV2Router), tokenAmount);
1532 
1533         // make the swap
1534         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1535             tokenAmount,
1536             0, // accept any amount of ETH
1537             path,
1538             address(this),
1539             block.timestamp
1540         );
1541     }
1542 
1543     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1544         // approve token transfer to cover all possible scenarios
1545         _approve(address(this), address(uniswapV2Router), tokenAmount);
1546 
1547         // add the liquidity
1548         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1549             address(this),
1550             tokenAmount,
1551             0, // slippage is unavoidable
1552             0, // slippage is unavoidable
1553             deadAddress,
1554             block.timestamp
1555         );
1556     }
1557 
1558     function swapBack() private {
1559         uint256 contractBalance = balanceOf(address(this));
1560         uint256 totalTokensToSwap = tokensForLiquidity +
1561             tokensForMarketing +
1562             tokensForDev;
1563         bool success;
1564 
1565         if (contractBalance == 0 || totalTokensToSwap == 0) {
1566             return;
1567         }
1568 
1569         if (contractBalance > swapTokensAtAmount * 20) {
1570             contractBalance = swapTokensAtAmount * 20;
1571         }
1572 
1573         // Halve the amount of liquidity tokens
1574         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1575             totalTokensToSwap /
1576             2;
1577         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1578 
1579         uint256 initialETHBalance = address(this).balance;
1580 
1581         swapTokensForEth(amountToSwapForETH);
1582 
1583         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1584 
1585         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1586             totalTokensToSwap
1587         );
1588         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1589 
1590         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1591 
1592         tokensForLiquidity = 0;
1593         tokensForMarketing = 0;
1594         tokensForDev = 0;
1595 
1596         (success, ) = address(devWallet).call{value: ethForDev}("");
1597 
1598         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1599             addLiquidity(liquidityTokens, ethForLiquidity);
1600             emit SwapAndLiquify(
1601                 amountToSwapForETH,
1602                 ethForLiquidity,
1603                 tokensForLiquidity
1604             );
1605         }
1606 
1607         (success, ) = address(marketingWallet).call{
1608             value: address(this).balance
1609         }("");
1610     }
1611 }