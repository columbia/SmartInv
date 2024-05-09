1 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 // pragma solidity ^0.8.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(
65         address sender,
66         address recipient,
67         uint256 amount
68     ) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 
86 // Dependency file: @openzeppelin/contracts/utils/Context.sol
87 
88 
89 // pragma solidity ^0.8.0;
90 
91 /**
92  * @dev Provides information about the current execution context, including the
93  * sender of the transaction and its data. While these are generally available
94  * via msg.sender and msg.data, they should not be accessed in such a direct
95  * manner, since when dealing with meta-transactions the account sending and
96  * paying for execution may not be the actual sender (as far as an application
97  * is concerned).
98  *
99  * This contract is only required for intermediate, library-like contracts.
100  */
101 abstract contract Context {
102     function _msgSender() internal view virtual returns (address) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view virtual returns (bytes calldata) {
107         return msg.data;
108     }
109 }
110 
111 
112 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
113 
114 
115 // pragma solidity ^0.8.0;
116 
117 // import "@openzeppelin/contracts/utils/Context.sol";
118 
119 /**
120  * @dev Contract module which provides a basic access control mechanism, where
121  * there is an account (an owner) that can be granted exclusive access to
122  * specific functions.
123  *
124  * By default, the owner account will be the one that deploys the contract. This
125  * can later be changed with {transferOwnership}.
126  *
127  * This module is used through inheritance. It will make available the modifier
128  * `onlyOwner`, which can be applied to your functions to restrict their use to
129  * the owner.
130  */
131 abstract contract Ownable is Context {
132     address private _owner;
133 
134     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
135 
136     /**
137      * @dev Initializes the contract setting the deployer as the initial owner.
138      */
139     constructor() {
140         _setOwner(_msgSender());
141     }
142 
143     /**
144      * @dev Returns the address of the current owner.
145      */
146     function owner() public view virtual returns (address) {
147         return _owner;
148     }
149 
150     /**
151      * @dev Throws if called by any account other than the owner.
152      */
153     modifier onlyOwner() {
154         require(owner() == _msgSender(), "Ownable: caller is not the owner");
155         _;
156     }
157 
158     /**
159      * @dev Leaves the contract without owner. It will not be possible to call
160      * `onlyOwner` functions anymore. Can only be called by the current owner.
161      *
162      * NOTE: Renouncing ownership will leave the contract without an owner,
163      * thereby removing any functionality that is only available to the owner.
164      */
165     function renounceOwnership() public virtual onlyOwner {
166         _setOwner(address(0));
167     }
168 
169     /**
170      * @dev Transfers ownership of the contract to a new account (`newOwner`).
171      * Can only be called by the current owner.
172      */
173     function transferOwnership(address newOwner) public virtual onlyOwner {
174         require(newOwner != address(0), "Ownable: new owner is the zero address");
175         _setOwner(newOwner);
176     }
177 
178     function _setOwner(address newOwner) private {
179         address oldOwner = _owner;
180         _owner = newOwner;
181         emit OwnershipTransferred(oldOwner, newOwner);
182     }
183 }
184 
185 
186 // Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol
187 
188 
189 // pragma solidity ^0.8.0;
190 
191 // CAUTION
192 // This version of SafeMath should only be used with Solidity 0.8 or later,
193 // because it relies on the compiler's built in overflow checks.
194 
195 /**
196  * @dev Wrappers over Solidity's arithmetic operations.
197  *
198  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
199  * now has built in overflow checking.
200  */
201 library SafeMath {
202     /**
203      * @dev Returns the addition of two unsigned integers, with an overflow flag.
204      *
205      * _Available since v3.4._
206      */
207     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
208         unchecked {
209             uint256 c = a + b;
210             if (c < a) return (false, 0);
211             return (true, c);
212         }
213     }
214 
215     /**
216      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
217      *
218      * _Available since v3.4._
219      */
220     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
221         unchecked {
222             if (b > a) return (false, 0);
223             return (true, a - b);
224         }
225     }
226 
227     /**
228      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
229      *
230      * _Available since v3.4._
231      */
232     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
233         unchecked {
234             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
235             // benefit is lost if 'b' is also tested.
236             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
237             if (a == 0) return (true, 0);
238             uint256 c = a * b;
239             if (c / a != b) return (false, 0);
240             return (true, c);
241         }
242     }
243 
244     /**
245      * @dev Returns the division of two unsigned integers, with a division by zero flag.
246      *
247      * _Available since v3.4._
248      */
249     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
250         unchecked {
251             if (b == 0) return (false, 0);
252             return (true, a / b);
253         }
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
258      *
259      * _Available since v3.4._
260      */
261     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
262         unchecked {
263             if (b == 0) return (false, 0);
264             return (true, a % b);
265         }
266     }
267 
268     /**
269      * @dev Returns the addition of two unsigned integers, reverting on
270      * overflow.
271      *
272      * Counterpart to Solidity's `+` operator.
273      *
274      * Requirements:
275      *
276      * - Addition cannot overflow.
277      */
278     function add(uint256 a, uint256 b) internal pure returns (uint256) {
279         return a + b;
280     }
281 
282     /**
283      * @dev Returns the subtraction of two unsigned integers, reverting on
284      * overflow (when the result is negative).
285      *
286      * Counterpart to Solidity's `-` operator.
287      *
288      * Requirements:
289      *
290      * - Subtraction cannot overflow.
291      */
292     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
293         return a - b;
294     }
295 
296     /**
297      * @dev Returns the multiplication of two unsigned integers, reverting on
298      * overflow.
299      *
300      * Counterpart to Solidity's `*` operator.
301      *
302      * Requirements:
303      *
304      * - Multiplication cannot overflow.
305      */
306     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
307         return a * b;
308     }
309 
310     /**
311      * @dev Returns the integer division of two unsigned integers, reverting on
312      * division by zero. The result is rounded towards zero.
313      *
314      * Counterpart to Solidity's `/` operator.
315      *
316      * Requirements:
317      *
318      * - The divisor cannot be zero.
319      */
320     function div(uint256 a, uint256 b) internal pure returns (uint256) {
321         return a / b;
322     }
323 
324     /**
325      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
326      * reverting when dividing by zero.
327      *
328      * Counterpart to Solidity's `%` operator. This function uses a `revert`
329      * opcode (which leaves remaining gas untouched) while Solidity uses an
330      * invalid opcode to revert (consuming all remaining gas).
331      *
332      * Requirements:
333      *
334      * - The divisor cannot be zero.
335      */
336     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
337         return a % b;
338     }
339 
340     /**
341      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
342      * overflow (when the result is negative).
343      *
344      * CAUTION: This function is deprecated because it requires allocating memory for the error
345      * message unnecessarily. For custom revert reasons use {trySub}.
346      *
347      * Counterpart to Solidity's `-` operator.
348      *
349      * Requirements:
350      *
351      * - Subtraction cannot overflow.
352      */
353     function sub(
354         uint256 a,
355         uint256 b,
356         string memory errorMessage
357     ) internal pure returns (uint256) {
358         unchecked {
359             require(b <= a, errorMessage);
360             return a - b;
361         }
362     }
363 
364     /**
365      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
366      * division by zero. The result is rounded towards zero.
367      *
368      * Counterpart to Solidity's `/` operator. Note: this function uses a
369      * `revert` opcode (which leaves remaining gas untouched) while Solidity
370      * uses an invalid opcode to revert (consuming all remaining gas).
371      *
372      * Requirements:
373      *
374      * - The divisor cannot be zero.
375      */
376     function div(
377         uint256 a,
378         uint256 b,
379         string memory errorMessage
380     ) internal pure returns (uint256) {
381         unchecked {
382             require(b > 0, errorMessage);
383             return a / b;
384         }
385     }
386 
387     /**
388      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
389      * reverting with custom message when dividing by zero.
390      *
391      * CAUTION: This function is deprecated because it requires allocating memory for the error
392      * message unnecessarily. For custom revert reasons use {tryMod}.
393      *
394      * Counterpart to Solidity's `%` operator. This function uses a `revert`
395      * opcode (which leaves remaining gas untouched) while Solidity uses an
396      * invalid opcode to revert (consuming all remaining gas).
397      *
398      * Requirements:
399      *
400      * - The divisor cannot be zero.
401      */
402     function mod(
403         uint256 a,
404         uint256 b,
405         string memory errorMessage
406     ) internal pure returns (uint256) {
407         unchecked {
408             require(b > 0, errorMessage);
409             return a % b;
410         }
411     }
412 }
413 
414 
415 // Dependency file: contracts/BaseToken.sol
416 
417 // pragma solidity =0.8.4;
418 
419 enum TokenType {
420     standard,
421     antiBotStandard,
422     liquidityGenerator,
423     antiBotLiquidityGenerator,
424     baby,
425     antiBotBaby,
426     buybackBaby,
427     antiBotBuybackBaby
428 }
429 
430 abstract contract BaseToken {
431     event TokenCreated(
432         address indexed owner,
433         address indexed token,
434         TokenType tokenType,
435         uint256 version
436     );
437 }
438 
439 
440 // Root file: contracts/standard/StandardToken.sol
441 
442 pragma solidity =0.8.4;
443 
444 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
445 // import "@openzeppelin/contracts/access/Ownable.sol";
446 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
447 // import "contracts/BaseToken.sol";
448 
449 contract StandardToken is IERC20, Ownable, BaseToken {
450     using SafeMath for uint256;
451 
452     uint256 public constant VERSION = 1;
453 
454     mapping(address => uint256) private _balances;
455     mapping(address => mapping(address => uint256)) private _allowances;
456 
457     string private _name;
458     string private _symbol;
459     uint8 private _decimals;
460     uint256 private _totalSupply;
461 
462     constructor(
463         string memory name_,
464         string memory symbol_,
465         uint8 decimals_,
466         uint256 totalSupply_,
467         address serviceFeeReceiver_,
468         uint256 serviceFee_
469     ) payable {
470         _name = name_;
471         _symbol = symbol_;
472         _decimals = decimals_;
473         _mint(owner(), totalSupply_);
474 
475         emit TokenCreated(owner(), address(this), TokenType.standard, VERSION);
476 
477         payable(serviceFeeReceiver_).transfer(serviceFee_);
478     }
479 
480     /**
481      * @dev Returns the name of the token.
482      */
483     function name() public view virtual returns (string memory) {
484         return _name;
485     }
486 
487     /**
488      * @dev Returns the symbol of the token, usually a shorter version of the
489      * name.
490      */
491     function symbol() public view virtual returns (string memory) {
492         return _symbol;
493     }
494 
495     /**
496      * @dev Returns the number of decimals used to get its user representation.
497      * For example, if `decimals` equals `2`, a balance of `505` tokens should
498      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
499      *
500      * Tokens usually opt for a value of 18, imitating the relationship between
501      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
502      * called.
503      *
504      * NOTE: This information is only used for _display_ purposes: it in
505      * no way affects any of the arithmetic of the contract, including
506      * {IERC20-balanceOf} and {IERC20-transfer}.
507      */
508     function decimals() public view virtual returns (uint8) {
509         return _decimals;
510     }
511 
512     /**
513      * @dev See {IERC20-totalSupply}.
514      */
515     function totalSupply() public view virtual override returns (uint256) {
516         return _totalSupply;
517     }
518 
519     /**
520      * @dev See {IERC20-balanceOf}.
521      */
522     function balanceOf(address account)
523         public
524         view
525         virtual
526         override
527         returns (uint256)
528     {
529         return _balances[account];
530     }
531 
532     /**
533      * @dev See {IERC20-transfer}.
534      *
535      * Requirements:
536      *
537      * - `recipient` cannot be the zero address.
538      * - the caller must have a balance of at least `amount`.
539      */
540     function transfer(address recipient, uint256 amount)
541         public
542         virtual
543         override
544         returns (bool)
545     {
546         _transfer(_msgSender(), recipient, amount);
547         return true;
548     }
549 
550     /**
551      * @dev See {IERC20-allowance}.
552      */
553     function allowance(address owner, address spender)
554         public
555         view
556         virtual
557         override
558         returns (uint256)
559     {
560         return _allowances[owner][spender];
561     }
562 
563     /**
564      * @dev See {IERC20-approve}.
565      *
566      * Requirements:
567      *
568      * - `spender` cannot be the zero address.
569      */
570     function approve(address spender, uint256 amount)
571         public
572         virtual
573         override
574         returns (bool)
575     {
576         _approve(_msgSender(), spender, amount);
577         return true;
578     }
579 
580     /**
581      * @dev See {IERC20-transferFrom}.
582      *
583      * Emits an {Approval} event indicating the updated allowance. This is not
584      * required by the EIP. See the note at the beginning of {ERC20}.
585      *
586      * Requirements:
587      *
588      * - `sender` and `recipient` cannot be the zero address.
589      * - `sender` must have a balance of at least `amount`.
590      * - the caller must have allowance for ``sender``'s tokens of at least
591      * `amount`.
592      */
593     function transferFrom(
594         address sender,
595         address recipient,
596         uint256 amount
597     ) public virtual override returns (bool) {
598         _transfer(sender, recipient, amount);
599         _approve(
600             sender,
601             _msgSender(),
602             _allowances[sender][_msgSender()].sub(
603                 amount,
604                 "ERC20: transfer amount exceeds allowance"
605             )
606         );
607         return true;
608     }
609 
610     /**
611      * @dev Atomically increases the allowance granted to `spender` by the caller.
612      *
613      * This is an alternative to {approve} that can be used as a mitigation for
614      * problems described in {IERC20-approve}.
615      *
616      * Emits an {Approval} event indicating the updated allowance.
617      *
618      * Requirements:
619      *
620      * - `spender` cannot be the zero address.
621      */
622     function increaseAllowance(address spender, uint256 addedValue)
623         public
624         virtual
625         returns (bool)
626     {
627         _approve(
628             _msgSender(),
629             spender,
630             _allowances[_msgSender()][spender].add(addedValue)
631         );
632         return true;
633     }
634 
635     /**
636      * @dev Atomically decreases the allowance granted to `spender` by the caller.
637      *
638      * This is an alternative to {approve} that can be used as a mitigation for
639      * problems described in {IERC20-approve}.
640      *
641      * Emits an {Approval} event indicating the updated allowance.
642      *
643      * Requirements:
644      *
645      * - `spender` cannot be the zero address.
646      * - `spender` must have allowance for the caller of at least
647      * `subtractedValue`.
648      */
649     function decreaseAllowance(address spender, uint256 subtractedValue)
650         public
651         virtual
652         returns (bool)
653     {
654         _approve(
655             _msgSender(),
656             spender,
657             _allowances[_msgSender()][spender].sub(
658                 subtractedValue,
659                 "ERC20: decreased allowance below zero"
660             )
661         );
662         return true;
663     }
664 
665     /**
666      * @dev Moves tokens `amount` from `sender` to `recipient`.
667      *
668      * This is internal function is equivalent to {transfer}, and can be used to
669      * e.g. implement automatic token fees, slashing mechanisms, etc.
670      *
671      * Emits a {Transfer} event.
672      *
673      * Requirements:
674      *
675      * - `sender` cannot be the zero address.
676      * - `recipient` cannot be the zero address.
677      * - `sender` must have a balance of at least `amount`.
678      */
679     function _transfer(
680         address sender,
681         address recipient,
682         uint256 amount
683     ) internal virtual {
684         require(sender != address(0), "ERC20: transfer from the zero address");
685         require(recipient != address(0), "ERC20: transfer to the zero address");
686 
687         _beforeTokenTransfer(sender, recipient, amount);
688 
689         _balances[sender] = _balances[sender].sub(
690             amount,
691             "ERC20: transfer amount exceeds balance"
692         );
693         _balances[recipient] = _balances[recipient].add(amount);
694         emit Transfer(sender, recipient, amount);
695     }
696 
697     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
698      * the total supply.
699      *
700      * Emits a {Transfer} event with `from` set to the zero address.
701      *
702      * Requirements:
703      *
704      * - `to` cannot be the zero address.
705      */
706     function _mint(address account, uint256 amount) internal virtual {
707         require(account != address(0), "ERC20: mint to the zero address");
708 
709         _beforeTokenTransfer(address(0), account, amount);
710 
711         _totalSupply = _totalSupply.add(amount);
712         _balances[account] = _balances[account].add(amount);
713         emit Transfer(address(0), account, amount);
714     }
715 
716     /**
717      * @dev Destroys `amount` tokens from `account`, reducing the
718      * total supply.
719      *
720      * Emits a {Transfer} event with `to` set to the zero address.
721      *
722      * Requirements:
723      *
724      * - `account` cannot be the zero address.
725      * - `account` must have at least `amount` tokens.
726      */
727     function _burn(address account, uint256 amount) internal virtual {
728         require(account != address(0), "ERC20: burn from the zero address");
729 
730         _beforeTokenTransfer(account, address(0), amount);
731 
732         _balances[account] = _balances[account].sub(
733             amount,
734             "ERC20: burn amount exceeds balance"
735         );
736         _totalSupply = _totalSupply.sub(amount);
737         emit Transfer(account, address(0), amount);
738     }
739 
740     /**
741      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
742      *
743      * This internal function is equivalent to `approve`, and can be used to
744      * e.g. set automatic allowances for certain subsystems, etc.
745      *
746      * Emits an {Approval} event.
747      *
748      * Requirements:
749      *
750      * - `owner` cannot be the zero address.
751      * - `spender` cannot be the zero address.
752      */
753     function _approve(
754         address owner,
755         address spender,
756         uint256 amount
757     ) internal virtual {
758         require(owner != address(0), "ERC20: approve from the zero address");
759         require(spender != address(0), "ERC20: approve to the zero address");
760 
761         _allowances[owner][spender] = amount;
762         emit Approval(owner, spender, amount);
763     }
764 
765     /**
766      * @dev Sets {decimals} to a value other than the default one of 18.
767      *
768      * WARNING: This function should only be called from the constructor. Most
769      * applications that interact with token contracts will not expect
770      * {decimals} to ever change, and may work incorrectly if it does.
771      */
772     function _setupDecimals(uint8 decimals_) internal virtual {
773         _decimals = decimals_;
774     }
775 
776     /**
777      * @dev Hook that is called before any transfer of tokens. This includes
778      * minting and burning.
779      *
780      * Calling conditions:
781      *
782      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
783      * will be to transferred to `to`.
784      * - when `from` is zero, `amount` tokens will be minted for `to`.
785      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
786      * - `from` and `to` are never both zero.
787      *
788      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
789      */
790     function _beforeTokenTransfer(
791         address from,
792         address to,
793         uint256 amount
794     ) internal virtual {}
795 }