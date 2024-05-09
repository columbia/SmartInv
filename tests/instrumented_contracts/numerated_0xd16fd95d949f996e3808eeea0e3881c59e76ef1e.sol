1 // ** TEST CONTRACT - LIQUIDITY WILL BE REMOVED ** DO NOT BUY **
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity 0.8.10;
5 pragma experimental ABIEncoderV2;
6 
7 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
8 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
9 
10 /* pragma solidity ^0.8.0; */
11 
12 /**
13  * @dev Provides information about the current execution context, including the
14  * sender of the transaction and its data. While these are generally available
15  * via msg.sender and msg.data, they should not be accessed in such a direct
16  * manner, since when dealing with meta-transactions the account sending and
17  * paying for execution may not be the actual sender (as far as an application
18  * is concerned).
19  *
20  * This contract is only required for intermediate, library-like contracts.
21  */
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         return msg.data;
29     }
30 }
31 
32 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
33 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
34 
35 /* pragma solidity ^0.8.0; */
36 
37 /* import "../utils/Context.sol"; */
38 
39 /**
40  * @dev Contract module which provides a basic access control mechanism, where
41  * there is an account (an owner) that can be granted exclusive access to
42  * specific functions.
43  *
44  * By default, the owner account will be the one that deploys the contract. This
45  * can later be changed with {transferOwnership}.
46  *
47  * This module is used through inheritance. It will make available the modifier
48  * `onlyOwner`, which can be applied to your functions to restrict their use to
49  * the owner.
50  */
51 abstract contract Ownable is Context {
52     address private _owner;
53 
54     event OwnershipTransferred(
55         address indexed previousOwner,
56         address indexed newOwner
57     );
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Returns the address of the current owner.
68      */
69     function owner() public view virtual returns (address) {
70         return _owner;
71     }
72 
73     /**
74      * @dev Throws if called by any account other than the owner.
75      */
76     modifier onlyOwner() {
77         require(owner() == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     /**
82      * @dev Leaves the contract without owner. It will not be possible to call
83      * `onlyOwner` functions anymore. Can only be called by the current owner.
84      *
85      * NOTE: Renouncing ownership will leave the contract without an owner,
86      * thereby removing any functionality that is only available to the owner.
87      */
88     function renounceOwnership() external virtual onlyOwner {
89         _transferOwnership(address(0));
90     }
91 
92     /**
93      * @dev Transfers ownership of the contract to a new account (`newOwner`).
94      * Can only be called by the current owner.
95      */
96     function transferOwnership(address newOwner) external virtual onlyOwner {
97         require(
98             newOwner != address(0),
99             "Ownable: new owner is the zero address"
100         );
101         _transferOwnership(newOwner);
102     }
103 
104     /**
105      * @dev Transfers ownership of the contract to a new account (`newOwner`).
106      * Internal function without access restriction.
107      */
108     function _transferOwnership(address newOwner) internal virtual {
109         address oldOwner = _owner;
110         _owner = newOwner;
111         emit OwnershipTransferred(oldOwner, newOwner);
112     }
113 }
114 
115 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
116 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
117 
118 /* pragma solidity ^0.8.0; */
119 
120 /**
121  * @dev Interface of the ERC20 standard as defined in the EIP.
122  */
123 interface IERC20 {
124     /**
125      * @dev Returns the amount of tokens in existence.
126      */
127     function totalSupply() external view returns (uint256);
128 
129     /**
130      * @dev Returns the amount of tokens owned by `account`.
131      */
132     function balanceOf(address account) external view returns (uint256);
133 
134     /**
135      * @dev Moves `amount` tokens from the caller's account to `recipient`.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transfer(address recipient, uint256 amount)
142         external
143         returns (bool);
144 
145     /**
146      * @dev Returns the remaining number of tokens that `spender` will be
147      * allowed to spend on behalf of `owner` through {transferFrom}. This is
148      * zero by default.
149      *
150      * This value changes when {approve} or {transferFrom} are called.
151      */
152     function allowance(address owner, address spender)
153         external
154         view
155         returns (uint256);
156 
157     /**
158      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * IMPORTANT: Beware that changing an allowance with this method brings the risk
163      * that someone may use both the old and the new allowance by unfortunate
164      * transaction ordering. One possible solution to mitigate this race
165      * condition is to first reduce the spender's allowance to 0 and set the
166      * desired value afterwards:
167      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168      *
169      * Emits an {Approval} event.
170      */
171     function approve(address spender, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Moves `amount` tokens from `sender` to `recipient` using the
175      * allowance mechanism. `amount` is then deducted from the caller's
176      * allowance.
177      *
178      * Returns a boolean value indicating whether the operation succeeded.
179      *
180      * Emits a {Transfer} event.
181      */
182     function transferFrom(
183         address sender,
184         address recipient,
185         uint256 amount
186     ) external returns (bool);
187 
188     /**
189      * @dev Emitted when `value` tokens are moved from one account (`from`) to
190      * another (`to`).
191      *
192      * Note that `value` may be zero.
193      */
194     event Transfer(address indexed from, address indexed to, uint256 value);
195 
196     /**
197      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
198      * a call to {approve}. `value` is the new allowance.
199      */
200     event Approval(
201         address indexed owner,
202         address indexed spender,
203         uint256 value
204     );
205 }
206 
207 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
208 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
209 
210 /* pragma solidity ^0.8.0; */
211 
212 /* import "../IERC20.sol"; */
213 
214 /**
215  * @dev Interface for the optional metadata functions from the ERC20 standard.
216  *
217  * _Available since v4.1._
218  */
219 interface IERC20Metadata is IERC20 {
220     /**
221      * @dev Returns the name of the token.
222      */
223     function name() external view returns (string memory);
224 
225     /**
226      * @dev Returns the symbol of the token.
227      */
228     function symbol() external view returns (string memory);
229 
230     /**
231      * @dev Returns the decimals places of the token.
232      */
233     function decimals() external view returns (uint8);
234 }
235 
236 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
237 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
238 
239 /* pragma solidity ^0.8.0; */
240 
241 /* import "./IERC20.sol"; */
242 /* import "./extensions/IERC20Metadata.sol"; */
243 /* import "../../utils/Context.sol"; */
244 
245 /**
246  * @dev Implementation of the {IERC20} interface.
247  *
248  * This implementation is agnostic to the way tokens are created. This means
249  * that a supply mechanism has to be added in a derived contract using {_mint}.
250  * For a generic mechanism see {ERC20PresetMinterPauser}.
251  *
252  * TIP: For a detailed writeup see our guide
253  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
254  * to implement supply mechanisms].
255  *
256  * We have followed general OpenZeppelin Contracts guidelines: functions revert
257  * instead returning `false` on failure. This behavior is nonetheless
258  * conventional and does not conflict with the expectations of ERC20
259  * applications.
260  *
261  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
262  * This allows applications to reconstruct the allowance for all accounts just
263  * by listening to said events. Other implementations of the EIP may not emit
264  * these events, as it isn't required by the specification.
265  *
266  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
267  * functions have been added to mitigate the well-known issues around setting
268  * allowances. See {IERC20-approve}.
269  */
270 contract ERC20 is Context, IERC20, IERC20Metadata {
271     mapping(address => uint256) private _balances;
272 
273     mapping(address => mapping(address => uint256)) private _allowances;
274 
275     uint256 private _totalSupply;
276 
277     string private _name;
278     string private _symbol;
279 
280     /**
281      * @dev Sets the values for {name} and {symbol}.
282      *
283      * The default value of {decimals} is 18. To select a different value for
284      * {decimals} you should overload it.
285      *
286      * All two of these values are immutable: they can only be set once during
287      * construction.
288      */
289     constructor(string memory name_, string memory symbol_) {
290         _name = name_;
291         _symbol = symbol_;
292     }
293 
294     /**
295      * @dev Returns the name of the token.
296      */
297     function name() external view virtual override returns (string memory) {
298         return _name;
299     }
300 
301     /**
302      * @dev Returns the symbol of the token, usually a shorter version of the
303      * name.
304      */
305     function symbol() external view virtual override returns (string memory) {
306         return _symbol;
307     }
308 
309     /**
310      * @dev Returns the number of decimals used to get its user representation.
311      * For example, if `decimals` equals `2`, a balance of `505` tokens should
312      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
313      *
314      * Tokens usually opt for a value of 18, imitating the relationship between
315      * Ether and Wei. This is the value {ERC20} uses, unless this function is
316      * overridden;
317      *
318      * NOTE: This information is only used for _display_ purposes: it in
319      * no way affects any of the arithmetic of the contract, including
320      * {IERC20-balanceOf} and {IERC20-transfer}.
321      */
322     function decimals() external view virtual override returns (uint8) {
323         return 18;
324     }
325 
326     /**
327      * @dev See {IERC20-totalSupply}.
328      */
329     function totalSupply() public view virtual override returns (uint256) {
330         return _totalSupply;
331     }
332 
333     /**
334      * @dev See {IERC20-balanceOf}.
335      */
336     function balanceOf(address account)
337         public
338         view
339         virtual
340         override
341         returns (uint256)
342     {
343         return _balances[account];
344     }
345 
346     /**
347      * @dev See {IERC20-transfer}.
348      *
349      * Requirements:
350      *
351      * - `recipient` cannot be the zero address.
352      * - the caller must have a balance of at least `amount`.
353      */
354     function transfer(address recipient, uint256 amount)
355         external
356         virtual
357         override
358         returns (bool)
359     {
360         _transfer(_msgSender(), recipient, amount);
361         return true;
362     }
363 
364     /**
365      * @dev See {IERC20-allowance}.
366      */
367     function allowance(address owner, address spender)
368         external
369         view
370         virtual
371         override
372         returns (uint256)
373     {
374         return _allowances[owner][spender];
375     }
376 
377     /**
378      * @dev See {IERC20-approve}.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      */
384     function approve(address spender, uint256 amount)
385         external
386         virtual
387         override
388         returns (bool)
389     {
390         _approve(_msgSender(), spender, amount);
391         return true;
392     }
393 
394     /**
395      * @dev See {IERC20-transferFrom}.
396      *
397      * Emits an {Approval} event indicating the updated allowance. This is not
398      * required by the EIP. See the note at the beginning of {ERC20}.
399      *
400      * Requirements:
401      *
402      * - `sender` and `recipient` cannot be the zero address.
403      * - `sender` must have a balance of at least `amount`.
404      * - the caller must have allowance for ``sender``'s tokens of at least
405      * `amount`.
406      */
407     function transferFrom(
408         address sender,
409         address recipient,
410         uint256 amount
411     ) external virtual override returns (bool) {
412         _transfer(sender, recipient, amount);
413 
414         uint256 currentAllowance = _allowances[sender][_msgSender()];
415         require(
416             currentAllowance >= amount,
417             "ERC20: transfer amount exceeds allowance"
418         );
419         unchecked {
420             _approve(sender, _msgSender(), currentAllowance - amount);
421         }
422 
423         return true;
424     }
425 
426     /**
427      * @dev Atomically increases the allowance granted to `spender` by the caller.
428      *
429      * This is an alternative to {approve} that can be used as a mitigation for
430      * problems described in {IERC20-approve}.
431      *
432      * Emits an {Approval} event indicating the updated allowance.
433      *
434      * Requirements:
435      *
436      * - `spender` cannot be the zero address.
437      */
438     function increaseAllowance(address spender, uint256 addedValue)
439         external
440         virtual
441         returns (bool)
442     {
443         _approve(
444             _msgSender(),
445             spender,
446             _allowances[_msgSender()][spender] + addedValue
447         );
448         return true;
449     }
450 
451     /**
452      * @dev Atomically decreases the allowance granted to `spender` by the caller.
453      *
454      * This is an alternative to {approve} that can be used as a mitigation for
455      * problems described in {IERC20-approve}.
456      *
457      * Emits an {Approval} event indicating the updated allowance.
458      *
459      * Requirements:
460      *
461      * - `spender` cannot be the zero address.
462      * - `spender` must have allowance for the caller of at least
463      * `subtractedValue`.
464      */
465     function decreaseAllowance(address spender, uint256 subtractedValue)
466         external
467         virtual
468         returns (bool)
469     {
470         uint256 currentAllowance = _allowances[_msgSender()][spender];
471         require(
472             currentAllowance >= subtractedValue,
473             "ERC20: decreased allowance below zero"
474         );
475         unchecked {
476             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
477         }
478 
479         return true;
480     }
481 
482     /**
483      * @dev Moves `amount` of tokens from `sender` to `recipient`.
484      *
485      * This internal function is equivalent to {transfer}, and can be used to
486      * e.g. implement automatic token fees, slashing mechanisms, etc.
487      *
488      * Emits a {Transfer} event.
489      *
490      * Requirements:
491      *
492      * - `sender` cannot be the zero address.
493      * - `recipient` cannot be the zero address.
494      * - `sender` must have a balance of at least `amount`.
495      */
496     function _transfer(
497         address sender,
498         address recipient,
499         uint256 amount
500     ) internal virtual {
501         require(sender != address(0), "ERC20: transfer from the zero address");
502         require(recipient != address(0), "ERC20: transfer to the zero address");
503 
504         _beforeTokenTransfer(sender, recipient, amount);
505 
506         uint256 senderBalance = _balances[sender];
507         require(
508             senderBalance >= amount,
509             "ERC20: transfer amount exceeds balance"
510         );
511         unchecked {
512             _balances[sender] = senderBalance - amount;
513         }
514         _balances[recipient] += amount;
515 
516         emit Transfer(sender, recipient, amount);
517 
518         _afterTokenTransfer(sender, recipient, amount);
519     }
520 
521     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
522      * the total supply.
523      *
524      * Emits a {Transfer} event with `from` set to the zero address.
525      *
526      * Requirements:
527      *
528      * - `account` cannot be the zero address.
529      */
530     function _mint(address account, uint256 amount) internal virtual {
531         require(account != address(0), "ERC20: mint to the zero address");
532 
533         _beforeTokenTransfer(address(0), account, amount);
534 
535         _totalSupply += amount;
536         _balances[account] += amount;
537         emit Transfer(address(0), account, amount);
538 
539         _afterTokenTransfer(address(0), account, amount);
540     }
541 
542     /**
543      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
544      *
545      * This internal function is equivalent to `approve`, and can be used to
546      * e.g. set automatic allowances for certain subsystems, etc.
547      *
548      * Emits an {Approval} event.
549      *
550      * Requirements:
551      *
552      * - `owner` cannot be the zero address.
553      * - `spender` cannot be the zero address.
554      */
555     function _approve(
556         address owner,
557         address spender,
558         uint256 amount
559     ) internal virtual {
560         require(owner != address(0), "ERC20: approve from the zero address");
561         require(spender != address(0), "ERC20: approve to the zero address");
562 
563         _allowances[owner][spender] = amount;
564         emit Approval(owner, spender, amount);
565     }
566 
567     /**
568      * @dev Hook that is called before any transfer of tokens. This includes
569      * minting and burning.
570      *
571      * Calling conditions:
572      *
573      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
574      * will be transferred to `to`.
575      * - when `from` is zero, `amount` tokens will be minted for `to`.
576      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
577      * - `from` and `to` are never both zero.
578      *
579      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
580      */
581     function _beforeTokenTransfer(
582         address from,
583         address to,
584         uint256 amount
585     ) internal virtual {}
586 
587     /**
588      * @dev Hook that is called after any transfer of tokens. This includes
589      * minting and burning.
590      *
591      * Calling conditions:
592      *
593      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
594      * has been transferred to `to`.
595      * - when `from` is zero, `amount` tokens have been minted for `to`.
596      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
597      * - `from` and `to` are never both zero.
598      *
599      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
600      */
601     function _afterTokenTransfer(
602         address from,
603         address to,
604         uint256 amount
605     ) internal virtual {}
606 }
607 
608 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
609 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
610 
611 /* pragma solidity ^0.8.0; */
612 
613 // CAUTION
614 // This version of SafeMath should only be used with Solidity 0.8 or later,
615 // because it relies on the compiler's built in overflow checks.
616 
617 /**
618  * @dev Wrappers over Solidity's arithmetic operations.
619  *
620  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
621  * now has built in overflow checking.
622  */
623 library SafeMath {
624     /**
625      * @dev Returns the addition of two unsigned integers, with an overflow flag.
626      *
627      * _Available since v3.4._
628      */
629     function tryAdd(uint256 a, uint256 b)
630         internal
631         pure
632         returns (bool, uint256)
633     {
634         unchecked {
635             uint256 c = a + b;
636             if (c < a) return (false, 0);
637             return (true, c);
638         }
639     }
640 
641     /**
642      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
643      *
644      * _Available since v3.4._
645      */
646     function trySub(uint256 a, uint256 b)
647         internal
648         pure
649         returns (bool, uint256)
650     {
651         unchecked {
652             if (b > a) return (false, 0);
653             return (true, a - b);
654         }
655     }
656 
657     /**
658      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
659      *
660      * _Available since v3.4._
661      */
662     function tryMul(uint256 a, uint256 b)
663         internal
664         pure
665         returns (bool, uint256)
666     {
667         unchecked {
668             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
669             // benefit is lost if 'b' is also tested.
670             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
671             if (a == 0) return (true, 0);
672             uint256 c = a * b;
673             if (c / a != b) return (false, 0);
674             return (true, c);
675         }
676     }
677 
678     /**
679      * @dev Returns the division of two unsigned integers, with a division by zero flag.
680      *
681      * _Available since v3.4._
682      */
683     function tryDiv(uint256 a, uint256 b)
684         internal
685         pure
686         returns (bool, uint256)
687     {
688         unchecked {
689             if (b == 0) return (false, 0);
690             return (true, a / b);
691         }
692     }
693 
694     /**
695      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
696      *
697      * _Available since v3.4._
698      */
699     function tryMod(uint256 a, uint256 b)
700         internal
701         pure
702         returns (bool, uint256)
703     {
704         unchecked {
705             if (b == 0) return (false, 0);
706             return (true, a % b);
707         }
708     }
709 
710     /**
711      * @dev Returns the addition of two unsigned integers, reverting on
712      * overflow.
713      *
714      * Counterpart to Solidity's `+` operator.
715      *
716      * Requirements:
717      *
718      * - Addition cannot overflow.
719      */
720     function add(uint256 a, uint256 b) internal pure returns (uint256) {
721         return a + b;
722     }
723 
724     /**
725      * @dev Returns the subtraction of two unsigned integers, reverting on
726      * overflow (when the result is negative).
727      *
728      * Counterpart to Solidity's `-` operator.
729      *
730      * Requirements:
731      *
732      * - Subtraction cannot overflow.
733      */
734     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
735         return a - b;
736     }
737 
738     /**
739      * @dev Returns the multiplication of two unsigned integers, reverting on
740      * overflow.
741      *
742      * Counterpart to Solidity's `*` operator.
743      *
744      * Requirements:
745      *
746      * - Multiplication cannot overflow.
747      */
748     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
749         return a * b;
750     }
751 
752     /**
753      * @dev Returns the integer division of two unsigned integers, reverting on
754      * division by zero. The result is rounded towards zero.
755      *
756      * Counterpart to Solidity's `/` operator.
757      *
758      * Requirements:
759      *
760      * - The divisor cannot be zero.
761      */
762     function div(uint256 a, uint256 b) internal pure returns (uint256) {
763         return a / b;
764     }
765 
766     /**
767      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
768      * reverting when dividing by zero.
769      *
770      * Counterpart to Solidity's `%` operator. This function uses a `revert`
771      * opcode (which leaves remaining gas untouched) while Solidity uses an
772      * invalid opcode to revert (consuming all remaining gas).
773      *
774      * Requirements:
775      *
776      * - The divisor cannot be zero.
777      */
778     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
779         return a % b;
780     }
781 
782     /**
783      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
784      * overflow (when the result is negative).
785      *
786      * CAUTION: This function is deprecated because it requires allocating memory for the error
787      * message unnecessarily. For custom revert reasons use {trySub}.
788      *
789      * Counterpart to Solidity's `-` operator.
790      *
791      * Requirements:
792      *
793      * - Subtraction cannot overflow.
794      */
795     function sub(
796         uint256 a,
797         uint256 b,
798         string memory errorMessage
799     ) internal pure returns (uint256) {
800         unchecked {
801             require(b <= a, errorMessage);
802             return a - b;
803         }
804     }
805 
806     /**
807      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
808      * division by zero. The result is rounded towards zero.
809      *
810      * Counterpart to Solidity's `/` operator. Note: this function uses a
811      * `revert` opcode (which leaves remaining gas untouched) while Solidity
812      * uses an invalid opcode to revert (consuming all remaining gas).
813      *
814      * Requirements:
815      *
816      * - The divisor cannot be zero.
817      */
818     function div(
819         uint256 a,
820         uint256 b,
821         string memory errorMessage
822     ) internal pure returns (uint256) {
823         unchecked {
824             require(b > 0, errorMessage);
825             return a / b;
826         }
827     }
828 
829     /**
830      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
831      * reverting with custom message when dividing by zero.
832      *
833      * CAUTION: This function is deprecated because it requires allocating memory for the error
834      * message unnecessarily. For custom revert reasons use {tryMod}.
835      *
836      * Counterpart to Solidity's `%` operator. This function uses a `revert`
837      * opcode (which leaves remaining gas untouched) while Solidity uses an
838      * invalid opcode to revert (consuming all remaining gas).
839      *
840      * Requirements:
841      *
842      * - The divisor cannot be zero.
843      */
844     function mod(
845         uint256 a,
846         uint256 b,
847         string memory errorMessage
848     ) internal pure returns (uint256) {
849         unchecked {
850             require(b > 0, errorMessage);
851             return a % b;
852         }
853     }
854 }
855 
856 ////// src/IUniswapV2Factory.sol
857 /* pragma solidity 0.8.10; */
858 /* pragma experimental ABIEncoderV2; */
859 
860 interface IUniswapV2Factory {
861     event PairCreated(
862         address indexed token0,
863         address indexed token1,
864         address pair,
865         uint256
866     );
867 
868     function feeTo() external view returns (address);
869 
870     function feeToSetter() external view returns (address);
871 
872     function getPair(address tokenA, address tokenB)
873         external
874         view
875         returns (address pair);
876 
877     function allPairs(uint256) external view returns (address pair);
878 
879     function allPairsLength() external view returns (uint256);
880 
881     function createPair(address tokenA, address tokenB)
882         external
883         returns (address pair);
884 
885     function setFeeTo(address) external;
886 
887     function setFeeToSetter(address) external;
888 }
889 
890 ////// src/IUniswapV2Pair.sol
891 /* pragma solidity 0.8.10; */
892 /* pragma experimental ABIEncoderV2; */
893 
894 interface IUniswapV2Pair {
895     event Approval(
896         address indexed owner,
897         address indexed spender,
898         uint256 value
899     );
900     event Transfer(address indexed from, address indexed to, uint256 value);
901 
902     function name() external pure returns (string memory);
903 
904     function symbol() external pure returns (string memory);
905 
906     function decimals() external pure returns (uint8);
907 
908     function totalSupply() external view returns (uint256);
909 
910     function balanceOf(address owner) external view returns (uint256);
911 
912     function allowance(address owner, address spender)
913         external
914         view
915         returns (uint256);
916 
917     function approve(address spender, uint256 value) external returns (bool);
918 
919     function transfer(address to, uint256 value) external returns (bool);
920 
921     function transferFrom(
922         address from,
923         address to,
924         uint256 value
925     ) external returns (bool);
926 
927     function DOMAIN_SEPARATOR() external view returns (bytes32);
928 
929     function PERMIT_TYPEHASH() external pure returns (bytes32);
930 
931     function nonces(address owner) external view returns (uint256);
932 
933     function permit(
934         address owner,
935         address spender,
936         uint256 value,
937         uint256 deadline,
938         uint8 v,
939         bytes32 r,
940         bytes32 s
941     ) external;
942 
943     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
944     event Burn(
945         address indexed sender,
946         uint256 amount0,
947         uint256 amount1,
948         address indexed to
949     );
950     event Swap(
951         address indexed sender,
952         uint256 amount0In,
953         uint256 amount1In,
954         uint256 amount0Out,
955         uint256 amount1Out,
956         address indexed to
957     );
958     event Sync(uint112 reserve0, uint112 reserve1);
959 
960     function MINIMUM_LIQUIDITY() external pure returns (uint256);
961 
962     function factory() external view returns (address);
963 
964     function token0() external view returns (address);
965 
966     function token1() external view returns (address);
967 
968     function getReserves()
969         external
970         view
971         returns (
972             uint112 reserve0,
973             uint112 reserve1,
974             uint32 blockTimestampLast
975         );
976 
977     function price0CumulativeLast() external view returns (uint256);
978 
979     function price1CumulativeLast() external view returns (uint256);
980 
981     function kLast() external view returns (uint256);
982 
983     function mint(address to) external returns (uint256 liquidity);
984 
985     function burn(address to)
986         external
987         returns (uint256 amount0, uint256 amount1);
988 
989     function swap(
990         uint256 amount0Out,
991         uint256 amount1Out,
992         address to,
993         bytes calldata data
994     ) external;
995 
996     function skim(address to) external;
997 
998     function sync() external;
999 
1000     function initialize(address, address) external;
1001 }
1002 
1003 ////// src/IUniswapV2Router02.sol
1004 /* pragma solidity 0.8.10; */
1005 /* pragma experimental ABIEncoderV2; */
1006 
1007 interface IUniswapV2Router02 {
1008     function factory() external pure returns (address);
1009 
1010     function WETH() external pure returns (address);
1011 
1012     function addLiquidity(
1013         address tokenA,
1014         address tokenB,
1015         uint256 amountADesired,
1016         uint256 amountBDesired,
1017         uint256 amountAMin,
1018         uint256 amountBMin,
1019         address to,
1020         uint256 deadline
1021     )
1022         external
1023         returns (
1024             uint256 amountA,
1025             uint256 amountB,
1026             uint256 liquidity
1027         );
1028 
1029     function addLiquidityETH(
1030         address token,
1031         uint256 amountTokenDesired,
1032         uint256 amountTokenMin,
1033         uint256 amountETHMin,
1034         address to,
1035         uint256 deadline
1036     )
1037         external
1038         payable
1039         returns (
1040             uint256 amountToken,
1041             uint256 amountETH,
1042             uint256 liquidity
1043         );
1044 
1045     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1046         uint256 amountIn,
1047         uint256 amountOutMin,
1048         address[] calldata path,
1049         address to,
1050         uint256 deadline
1051     ) external;
1052 
1053     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1054         uint256 amountOutMin,
1055         address[] calldata path,
1056         address to,
1057         uint256 deadline
1058     ) external payable;
1059 
1060     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1061         uint256 amountIn,
1062         uint256 amountOutMin,
1063         address[] calldata path,
1064         address to,
1065         uint256 deadline
1066     ) external;
1067 }
1068 
1069 /* pragma solidity >=0.8.10; */
1070 
1071 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1072 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1073 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1074 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1075 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1076 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1077 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1078 
1079 contract ParaWerx is ERC20, Ownable {
1080     using SafeMath for uint256;
1081 
1082     IUniswapV2Router02 public immutable uniswapV2Router;
1083     address public immutable uniswapV2Pair;
1084     address public constant deadAddress = address(0xdead);
1085 
1086     bool private swapping;
1087     address public taxWallet;
1088 
1089     uint256 public maxTransactionAmount;
1090     uint256 public swapTokensAtAmount;
1091     uint256 public maxWallet;
1092 
1093     uint256 public percentForLPBurn = 25; // 25 = .25%
1094     bool public lpBurnEnabled;
1095     uint256 public lpBurnFrequency = 3600 seconds;
1096     uint256 public lastLpBurnTime;
1097 
1098     uint256 public constant manualBurnFrequency = 30 minutes;
1099     uint256 public lastManualLpBurnTime;
1100 
1101     bool public limitsInEffect = true;
1102     bool public tradingActive;
1103     bool public swapEnabled;
1104 
1105     // Anti-bot and anti-whale mappings and variables
1106     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
1107     bool public transferDelayEnabled;
1108 
1109     uint256 public buyTotalFees;
1110     uint256 public buyLiquidityFee;
1111     uint256 public buyTaxFee;
1112 
1113     uint256 public sellTotalFees;
1114     uint256 public sellLiquidityFee;
1115     uint256 public sellTaxFee;
1116 
1117     uint256 public tokensForLiquidity;
1118     uint256 public tokensForTax;
1119 
1120     /******************/
1121 
1122     // exlcude from fees and max transaction amount
1123     mapping(address => bool) private _isExcludedFromFees;
1124     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1125 
1126     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1127     // could be subject to a maximum transfer amount
1128     mapping(address => bool) public automatedMarketMakerPairs;
1129 
1130     // bot wallet
1131     mapping(address => bool) public botWallets;
1132 
1133     event UpdateUniswapV2Router(
1134         address indexed newAddress,
1135         address indexed oldAddress
1136     );
1137 
1138     event ExcludeFromFees(address indexed account, bool isExcluded);
1139 
1140     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1141 
1142     event TaxWalletUpdated(
1143         address indexed newWallet,
1144         address indexed oldWallet
1145     );
1146 
1147     event SwapAndLiquify(
1148         uint256 tokensSwapped,
1149         uint256 ethReceived,
1150         uint256 tokensIntoLiquidity
1151     );
1152 
1153     event AutoNukeLP();
1154 
1155     event ManualNukeLP();
1156 
1157     constructor(address _uniswapV2RouterAddress, address _taxwallet) ERC20("ParaWerx", "PARA") {
1158         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1159             _uniswapV2RouterAddress
1160         );
1161 
1162         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1163         uniswapV2Router = _uniswapV2Router;
1164 
1165         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1166             .createPair(address(this), _uniswapV2Router.WETH());
1167         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1168         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1169 
1170         uint256 _buyLiquidityFee = 2;
1171         uint256 _buyTaxFee = 5;
1172 
1173         uint256 _sellLiquidityFee = 2;
1174         uint256 _sellTaxFee = 5;
1175 
1176         uint256 totalSupply = 5e10 * 1e18; // 100 Billion
1177 
1178         maxTransactionAmount = 1e9 * 1e18; // 1% from total supply maxTransactionAmountTxn: i.e 1 Billion
1179         maxWallet = 2 * 1e9 * 1e18; // 2% from total supply maxWallet: i.e 2 Billion
1180         swapTokensAtAmount = (totalSupply * 5) / 1e4; // 0.05% swap wallet
1181 
1182         buyLiquidityFee = _buyLiquidityFee;
1183         buyTaxFee = _buyTaxFee;
1184         buyTotalFees = buyLiquidityFee + buyTaxFee;
1185 
1186         sellLiquidityFee = _sellLiquidityFee;
1187         sellTaxFee = _sellTaxFee;
1188         sellTotalFees = sellLiquidityFee + sellTaxFee;
1189 
1190         taxWallet = address(_taxwallet); // set as tax wallet
1191 
1192         // exclude from paying fees or having max transaction amount
1193         excludeFromFees(owner(), true);
1194         excludeFromFees(address(this), true);
1195         excludeFromFees(address(0xdead), true);
1196 
1197         excludeFromMaxTransaction(owner(), true);
1198         excludeFromMaxTransaction(address(this), true);
1199         excludeFromMaxTransaction(address(0xdead), true);
1200 
1201         /*\
1202             _mint is an internal function in ERC20.sol that is only called here,
1203             and CANNOT be called ever again
1204         */
1205         _mint(msg.sender, totalSupply);
1206     }
1207 
1208     receive() external payable {}
1209 
1210     event TradingEnabled();
1211 
1212     // once enabled, can never be turned off
1213     function enableTrading() external onlyOwner {
1214         tradingActive = true;
1215         swapEnabled = true;
1216         lastLpBurnTime = block.timestamp;
1217         emit TradingEnabled();
1218     }
1219 
1220     // remove limits after token is stable
1221     function removeLimits() external onlyOwner{
1222         limitsInEffect = false;
1223     }
1224 
1225     // disable Transfer delay
1226     function setTransferDelay() external onlyOwner {
1227         if(transferDelayEnabled)
1228         {
1229         transferDelayEnabled = false;
1230         }
1231         else{
1232             transferDelayEnabled = true;
1233         }
1234     }
1235 
1236     // change the minimum amount of tokens to sell from fees
1237     function updateSwapTokensAtAmount(uint256 newAmount)
1238         external
1239         onlyOwner
1240         returns (bool)
1241     {
1242         
1243         swapTokensAtAmount = newAmount;
1244         return true;
1245     }
1246 
1247     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1248         require(
1249             newNum >= ((totalSupply() * 1) / 1e8) / 1e18,
1250             "Cannot set maxTransactionAmount lower than 0.000001%"
1251         );
1252         maxTransactionAmount = newNum * (10**18);
1253     }
1254 
1255     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1256         require(
1257             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1258             "Cannot set maxWallet lower than 0.5%"
1259         );
1260         maxWallet = newNum * (10**18);
1261     }
1262 
1263     function excludeFromMaxTransaction(address updAds, bool isEx)
1264         public
1265         onlyOwner
1266     {
1267         _isExcludedMaxTransactionAmount[updAds] = isEx;
1268     }
1269 
1270     // only use to disable contract sales if absolutely necessary (emergency use only)
1271     function updateSwapEnabled(bool enabled) external onlyOwner {
1272         swapEnabled = enabled;
1273     }
1274 
1275     function updateBuyFees(uint256 _liquidityFee, uint256 _taxFee)
1276         external
1277         onlyOwner
1278     {
1279         buyLiquidityFee = _liquidityFee;
1280         buyTaxFee = _taxFee;
1281         buyTotalFees = buyLiquidityFee + buyTaxFee;
1282         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1283     }
1284 
1285     function updateSellFees(uint256 _liquidityFee, uint256 _taxFee)
1286         external
1287         onlyOwner
1288     {
1289         sellLiquidityFee = _liquidityFee;
1290         sellTaxFee = _taxFee;
1291         sellTotalFees = sellLiquidityFee + sellTaxFee;
1292         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1293     }
1294 
1295     function excludeFromFees(address account, bool excluded) public onlyOwner {
1296         _isExcludedFromFees[account] = excluded;
1297         emit ExcludeFromFees(account, excluded);
1298     }
1299 
1300     function setAutomatedMarketMakerPair(address pair, bool value)
1301         external
1302         onlyOwner
1303     {
1304         require(
1305             pair != uniswapV2Pair,
1306             "The pair cannot be removed from automatedMarketMakerPairs"
1307         );
1308 
1309         _setAutomatedMarketMakerPair(pair, value);
1310     }
1311 
1312     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1313         automatedMarketMakerPairs[pair] = value;
1314 
1315         emit SetAutomatedMarketMakerPair(pair, value);
1316     }
1317 
1318     function updateTaxWallet(address newTaxWallet) external onlyOwner {
1319         emit TaxWalletUpdated(newTaxWallet, taxWallet);
1320         taxWallet = newTaxWallet;
1321     }
1322 
1323     function isExcludedFromFees(address account) external view returns (bool) {
1324         return _isExcludedFromFees[account];
1325     }
1326 
1327     function isExcludedMaxTransactionAmount(address account)
1328         external
1329         view
1330         returns (bool)
1331     {
1332         return _isExcludedMaxTransactionAmount[account];
1333     }
1334 
1335     event BoughtEarly(address indexed sniper);
1336 
1337     function _transfer(
1338         address from,
1339         address to,
1340         uint256 amount
1341     ) internal override {
1342         require(from != address(0), "ERC20: transfer from the zero address");
1343         require(to != address(0), "ERC20: transfer to the zero address");
1344         require(!botWallets[from], "Sender Cannot be bot");
1345         require(!botWallets[to], "Recipient Cannot be bot");
1346 
1347         if (amount == 0) {
1348             super._transfer(from, to, 0);
1349             return;
1350         }
1351 
1352         if (limitsInEffect) {
1353             if (
1354                 from != owner() &&
1355                 to != owner() &&
1356                 to != address(0) &&
1357                 to != address(0xdead) &&
1358                 !swapping
1359             ) {
1360                 if (!tradingActive) {
1361                     require(
1362                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1363                         "Trading is not active."
1364                     );
1365                 }
1366 
1367                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1368                 if (transferDelayEnabled) {
1369                     if (
1370                         to != owner() &&
1371                         to != address(uniswapV2Router) &&
1372                         to != address(uniswapV2Pair)
1373                     ) {
1374                         require(
1375                             _holderLastTransferTimestamp[tx.origin] <
1376                                 block.number,
1377                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1378                         );
1379                         _holderLastTransferTimestamp[tx.origin] = block.number;
1380                     }
1381                 }
1382 
1383                 //when buy
1384                 if (
1385                     automatedMarketMakerPairs[from] &&
1386                     !_isExcludedMaxTransactionAmount[to]
1387                 ) {
1388                     require(
1389                         amount <= maxTransactionAmount,
1390                         "Buy transfer amount exceeds the maxTransactionAmount."
1391                     );
1392                     require(
1393                         amount + balanceOf(to) <= maxWallet,
1394                         "Max wallet exceeded"
1395                     );
1396                 }
1397                 //when sell
1398                 else if (
1399                     automatedMarketMakerPairs[to] &&
1400                     !_isExcludedMaxTransactionAmount[from]
1401                 ) {
1402                     require(
1403                         amount <= maxTransactionAmount,
1404                         "Sell transfer amount exceeds the maxTransactionAmount."
1405                     );
1406                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1407                     require(
1408                         amount + balanceOf(to) <= maxWallet,
1409                         "Max wallet exceeded"
1410                     );
1411                 }
1412             }
1413         }
1414 
1415         uint256 contractTokenBalance = balanceOf(address(this));
1416 
1417         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1418 
1419         if (
1420             canSwap &&
1421             swapEnabled &&
1422             !swapping &&
1423             !automatedMarketMakerPairs[from] &&
1424             !_isExcludedFromFees[from] &&
1425             !_isExcludedFromFees[to]
1426         ) {
1427             swapping = true;
1428 
1429             swapBack();
1430 
1431             swapping = false;
1432         }
1433 
1434         if (
1435             !swapping &&
1436             automatedMarketMakerPairs[to] &&
1437             lpBurnEnabled &&
1438             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1439             !_isExcludedFromFees[from]
1440         ) {
1441             autoBurnLiquidityPairTokens();
1442         }
1443 
1444         bool takeFee = !swapping;
1445 
1446         // if any account belongs to _isExcludedFromFee account then remove the fee
1447         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1448             takeFee = false;
1449         }
1450 
1451         uint256 fees = 0;
1452         // only take fees on buys/sells, do not take on wallet transfers
1453         if (takeFee) {
1454             // on sell
1455             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1456                 fees = amount.mul(sellTotalFees).div(100);
1457                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1458                 tokensForTax += (fees * sellTaxFee) / sellTotalFees;
1459             }
1460             // on buy
1461             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1462                 fees = amount.mul(buyTotalFees).div(100);
1463                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1464                 tokensForTax += (fees * buyTaxFee) / buyTotalFees;
1465             }
1466 
1467             if (fees > 0) {
1468                 super._transfer(from, address(this), fees);
1469             }
1470 
1471             amount -= fees;
1472         }
1473 
1474         super._transfer(from, to, amount);
1475     }
1476 
1477     function swapTokensForEth(uint256 tokenAmount) private {
1478         // generate the uniswap pair path of token -> weth
1479         address[] memory path = new address[](2);
1480         path[0] = address(this);
1481         path[1] = uniswapV2Router.WETH();
1482 
1483         _approve(address(this), address(uniswapV2Router), tokenAmount);
1484 
1485         // make the swap
1486         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1487             tokenAmount,
1488             0, // accept any amount of ETH
1489             path,
1490             address(this),
1491             block.timestamp
1492         );
1493     }
1494 
1495     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1496         // approve token transfer to cover all possible scenarios
1497         _approve(address(this), address(uniswapV2Router), tokenAmount);
1498 
1499         // add the liquidity
1500         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1501             address(this),
1502             tokenAmount,
1503             0, // slippage is unavoidable
1504             0, // slippage is unavoidable
1505             owner(),
1506             block.timestamp
1507         );
1508     }
1509 
1510     function swapBack() private {
1511         uint256 contractBalance = balanceOf(address(this));
1512         uint256 totalTokensToSwap = tokensForLiquidity + tokensForTax;
1513         bool success;
1514 
1515         if (contractBalance == 0 || totalTokensToSwap == 0) {
1516             return;
1517         }
1518 
1519         if (contractBalance > swapTokensAtAmount * 20) {
1520             contractBalance = swapTokensAtAmount * 20;
1521         }
1522 
1523 
1524         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1525             totalTokensToSwap;
1526         // except half of liquidity amount
1527         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens.div(2));
1528 
1529         uint256 initialETHBalance = address(this).balance;
1530 
1531         swapTokensForEth(amountToSwapForETH);
1532 
1533         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1534         // tax amount + half of liquidity 
1535         uint256 ethForTax = ethBalance.mul(tokensForTax).div(tokensForTax + tokensForLiquidity.div(2));
1536 
1537         uint256 ethForLiquidity = ethBalance - ethForTax;
1538 
1539         tokensForLiquidity = 0;
1540         tokensForTax = 0;
1541 
1542         (success, ) = address(taxWallet).call{value: ethForTax}("");
1543 
1544         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1545             addLiquidity(liquidityTokens, ethForLiquidity);
1546             emit SwapAndLiquify(
1547                 amountToSwapForETH,
1548                 ethForLiquidity,
1549                 tokensForLiquidity
1550             );
1551         }
1552     }
1553 
1554     function setAutoLPBurnSettings(
1555         uint256 _frequencyInSeconds,
1556         uint256 _percent,
1557         bool _Enabled
1558     ) external onlyOwner {
1559         require(
1560             _frequencyInSeconds >= 600,
1561             "cannot set buyback more often than every 10 minutes"
1562         );
1563         require(
1564             _percent <= 1000 && _percent >= 0,
1565             "Must set auto LP burn percent between 0% and 10%"
1566         );
1567         lpBurnFrequency = _frequencyInSeconds;
1568         percentForLPBurn = _percent;
1569         lpBurnEnabled = _Enabled;
1570     }
1571 
1572     function autoBurnLiquidityPairTokens() internal returns (bool) {
1573         lastLpBurnTime = block.timestamp;
1574 
1575         // get balance of liquidity pair
1576         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1577 
1578         // calculate amount to burn
1579         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1580             10000
1581         );
1582 
1583         // pull tokens from pancakePair liquidity and move to dead address permanently
1584         if (amountToBurn > 0) {
1585             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1586         }
1587 
1588         //sync price since this is not in a swap transaction!
1589         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1590         pair.sync();
1591         emit AutoNukeLP();
1592         return true;
1593     }
1594 
1595     function manualBurnLiquidityPairTokens(uint256 percent)
1596         external
1597         onlyOwner
1598         returns (bool)
1599     {
1600         require(
1601             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1602             "Must wait for cooldown to finish"
1603         );
1604         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1605         lastManualLpBurnTime = block.timestamp;
1606 
1607         // get balance of liquidity pair
1608         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1609 
1610         // calculate amount to burn
1611         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1612 
1613         // pull tokens from pancakePair liquidity and move to dead address permanently
1614         if (amountToBurn > 0) {
1615             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1616         }
1617 
1618         //sync price since this is not in a swap transaction!
1619         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1620         pair.sync();
1621         emit ManualNukeLP();
1622         return true;
1623     }
1624 
1625     function withdraw() external payable onlyOwner {
1626         require(taxWallet != address(0), "Cannot be zero address");
1627         payable(taxWallet).transfer(address(this).balance);
1628     }
1629 
1630     function addOrRemoveBotWallet(address wallet, bool flag) external onlyOwner {
1631         require(wallet != address(0), "Cannot be zero address");
1632         botWallets[wallet] = flag;
1633     }
1634 
1635         function addOrRemoveBotWallet(address[] memory wallet, bool flag) external onlyOwner {
1636         for(uint i=0;i<wallet.length;i++)
1637         {
1638         botWallets[wallet[i]] = flag;
1639         }
1640       
1641     }
1642 }