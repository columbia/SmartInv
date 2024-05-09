1 /**
2  *Submitted for verification at BscScan.com on 2021-11-21
3 */
4 
5 // Dependency file: @openzeppelin/contracts/token/ERC20/IERC20.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 // pragma solidity ^0.8.0;
10 
11 /**
12  * @dev Interface of the ERC20 standard as defined in the EIP.
13  */
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(
69         address sender,
70         address recipient,
71         uint256 amount
72     ) external returns (bool);
73 
74     /**
75      * @dev Emitted when `value` tokens are moved from one account (`from`) to
76      * another (`to`).
77      *
78      * Note that `value` may be zero.
79      */
80     event Transfer(address indexed from, address indexed to, uint256 value);
81 
82     /**
83      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
84      * a call to {approve}. `value` is the new allowance.
85      */
86     event Approval(address indexed owner, address indexed spender, uint256 value);
87 }
88 
89 
90 // Dependency file: @openzeppelin/contracts/utils/Context.sol
91 
92 
93 // pragma solidity ^0.8.0;
94 
95 /**
96  * @dev Provides information about the current execution context, including the
97  * sender of the transaction and its data. While these are generally available
98  * via msg.sender and msg.data, they should not be accessed in such a direct
99  * manner, since when dealing with meta-transactions the account sending and
100  * paying for execution may not be the actual sender (as far as an application
101  * is concerned).
102  *
103  * This contract is only required for intermediate, library-like contracts.
104  */
105 abstract contract Context {
106     function _msgSender() internal view virtual returns (address) {
107         return msg.sender;
108     }
109 
110     function _msgData() internal view virtual returns (bytes calldata) {
111         return msg.data;
112     }
113 }
114 
115 
116 // Dependency file: @openzeppelin/contracts/access/Ownable.sol
117 
118 
119 // pragma solidity ^0.8.0;
120 
121 // import "@openzeppelin/contracts/utils/Context.sol";
122 
123 /**
124  * @dev Contract module which provides a basic access control mechanism, where
125  * there is an account (an owner) that can be granted exclusive access to
126  * specific functions.
127  *
128  * By default, the owner account will be the one that deploys the contract. This
129  * can later be changed with {transferOwnership}.
130  *
131  * This module is used through inheritance. It will make available the modifier
132  * `onlyOwner`, which can be applied to your functions to restrict their use to
133  * the owner.
134  */
135 abstract contract Ownable is Context {
136     address private _owner;
137 
138     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
139 
140     /**
141      * @dev Initializes the contract setting the deployer as the initial owner.
142      */
143     constructor() {
144         _setOwner(_msgSender());
145     }
146 
147     /**
148      * @dev Returns the address of the current owner.
149      */
150     function owner() public view virtual returns (address) {
151         return _owner;
152     }
153 
154     /**
155      * @dev Throws if called by any account other than the owner.
156      */
157     modifier onlyOwner() {
158         require(owner() == _msgSender(), "Ownable: caller is not the owner");
159         _;
160     }
161 
162     /**
163      * @dev Leaves the contract without owner. It will not be possible to call
164      * `onlyOwner` functions anymore. Can only be called by the current owner.
165      *
166      * NOTE: Renouncing ownership will leave the contract without an owner,
167      * thereby removing any functionality that is only available to the owner.
168      */
169     function renounceOwnership() public virtual onlyOwner {
170         _setOwner(address(0));
171     }
172 
173     /**
174      * @dev Transfers ownership of the contract to a new account (`newOwner`).
175      * Can only be called by the current owner.
176      */
177     function transferOwnership(address newOwner) public virtual onlyOwner {
178         require(newOwner != address(0), "Ownable: new owner is the zero address");
179         _setOwner(newOwner);
180     }
181 
182     function _setOwner(address newOwner) private {
183         address oldOwner = _owner;
184         _owner = newOwner;
185         emit OwnershipTransferred(oldOwner, newOwner);
186     }
187 }
188 
189 
190 // Dependency file: @openzeppelin/contracts/utils/math/SafeMath.sol
191 
192 
193 // pragma solidity ^0.8.0;
194 
195 // CAUTION
196 // This version of SafeMath should only be used with Solidity 0.8 or later,
197 // because it relies on the compiler's built in overflow checks.
198 
199 /**
200  * @dev Wrappers over Solidity's arithmetic operations.
201  *
202  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
203  * now has built in overflow checking.
204  */
205 library SafeMath {
206     /**
207      * @dev Returns the addition of two unsigned integers, with an overflow flag.
208      *
209      * _Available since v3.4._
210      */
211     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
212         unchecked {
213             uint256 c = a + b;
214             if (c < a) return (false, 0);
215             return (true, c);
216         }
217     }
218 
219     /**
220      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
221      *
222      * _Available since v3.4._
223      */
224     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
225         unchecked {
226             if (b > a) return (false, 0);
227             return (true, a - b);
228         }
229     }
230 
231     /**
232      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
233      *
234      * _Available since v3.4._
235      */
236     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
237         unchecked {
238             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
239             // benefit is lost if 'b' is also tested.
240             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
241             if (a == 0) return (true, 0);
242             uint256 c = a * b;
243             if (c / a != b) return (false, 0);
244             return (true, c);
245         }
246     }
247 
248     /**
249      * @dev Returns the division of two unsigned integers, with a division by zero flag.
250      *
251      * _Available since v3.4._
252      */
253     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
254         unchecked {
255             if (b == 0) return (false, 0);
256             return (true, a / b);
257         }
258     }
259 
260     /**
261      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
262      *
263      * _Available since v3.4._
264      */
265     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
266         unchecked {
267             if (b == 0) return (false, 0);
268             return (true, a % b);
269         }
270     }
271 
272     /**
273      * @dev Returns the addition of two unsigned integers, reverting on
274      * overflow.
275      *
276      * Counterpart to Solidity's `+` operator.
277      *
278      * Requirements:
279      *
280      * - Addition cannot overflow.
281      */
282     function add(uint256 a, uint256 b) internal pure returns (uint256) {
283         return a + b;
284     }
285 
286     /**
287      * @dev Returns the subtraction of two unsigned integers, reverting on
288      * overflow (when the result is negative).
289      *
290      * Counterpart to Solidity's `-` operator.
291      *
292      * Requirements:
293      *
294      * - Subtraction cannot overflow.
295      */
296     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
297         return a - b;
298     }
299 
300     /**
301      * @dev Returns the multiplication of two unsigned integers, reverting on
302      * overflow.
303      *
304      * Counterpart to Solidity's `*` operator.
305      *
306      * Requirements:
307      *
308      * - Multiplication cannot overflow.
309      */
310     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
311         return a * b;
312     }
313 
314     /**
315      * @dev Returns the integer division of two unsigned integers, reverting on
316      * division by zero. The result is rounded towards zero.
317      *
318      * Counterpart to Solidity's `/` operator.
319      *
320      * Requirements:
321      *
322      * - The divisor cannot be zero.
323      */
324     function div(uint256 a, uint256 b) internal pure returns (uint256) {
325         return a / b;
326     }
327 
328     /**
329      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
330      * reverting when dividing by zero.
331      *
332      * Counterpart to Solidity's `%` operator. This function uses a `revert`
333      * opcode (which leaves remaining gas untouched) while Solidity uses an
334      * invalid opcode to revert (consuming all remaining gas).
335      *
336      * Requirements:
337      *
338      * - The divisor cannot be zero.
339      */
340     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
341         return a % b;
342     }
343 
344     /**
345      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
346      * overflow (when the result is negative).
347      *
348      * CAUTION: This function is deprecated because it requires allocating memory for the error
349      * message unnecessarily. For custom revert reasons use {trySub}.
350      *
351      * Counterpart to Solidity's `-` operator.
352      *
353      * Requirements:
354      *
355      * - Subtraction cannot overflow.
356      */
357     function sub(
358         uint256 a,
359         uint256 b,
360         string memory errorMessage
361     ) internal pure returns (uint256) {
362         unchecked {
363             require(b <= a, errorMessage);
364             return a - b;
365         }
366     }
367 
368     /**
369      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
370      * division by zero. The result is rounded towards zero.
371      *
372      * Counterpart to Solidity's `/` operator. Note: this function uses a
373      * `revert` opcode (which leaves remaining gas untouched) while Solidity
374      * uses an invalid opcode to revert (consuming all remaining gas).
375      *
376      * Requirements:
377      *
378      * - The divisor cannot be zero.
379      */
380     function div(
381         uint256 a,
382         uint256 b,
383         string memory errorMessage
384     ) internal pure returns (uint256) {
385         unchecked {
386             require(b > 0, errorMessage);
387             return a / b;
388         }
389     }
390 
391     /**
392      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
393      * reverting with custom message when dividing by zero.
394      *
395      * CAUTION: This function is deprecated because it requires allocating memory for the error
396      * message unnecessarily. For custom revert reasons use {tryMod}.
397      *
398      * Counterpart to Solidity's `%` operator. This function uses a `revert`
399      * opcode (which leaves remaining gas untouched) while Solidity uses an
400      * invalid opcode to revert (consuming all remaining gas).
401      *
402      * Requirements:
403      *
404      * - The divisor cannot be zero.
405      */
406     function mod(
407         uint256 a,
408         uint256 b,
409         string memory errorMessage
410     ) internal pure returns (uint256) {
411         unchecked {
412             require(b > 0, errorMessage);
413             return a % b;
414         }
415     }
416 }
417 
418 
419 // Dependency file: contracts/interfaces/IPinkAntiBot.sol
420 
421 // pragma solidity >=0.5.0;
422 
423 interface IPinkAntiBot {
424   function setTokenOwner(address owner) external;
425 
426   function onPreTransferCheck(
427     address from,
428     address to,
429     uint256 amount
430   ) external;
431 }
432 
433 
434 // Dependency file: contracts/BaseToken.sol
435 
436 // pragma solidity =0.8.4;
437 
438 enum TokenType {
439     standard,
440     antiBotStandard,
441     liquidityGenerator,
442     antiBotLiquidityGenerator,
443     baby,
444     antiBotBaby,
445     buybackBaby,
446     antiBotBuybackBaby
447 }
448 
449 abstract contract BaseToken {
450     event TokenCreated(
451         address indexed owner,
452         address indexed token,
453         TokenType tokenType,
454         uint256 version
455     );
456 }
457 
458 
459 // Root file: contracts/standard/AntiBotStandardToken.sol
460 
461 pragma solidity =0.8.4;
462 
463 // import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
464 // import "@openzeppelin/contracts/access/Ownable.sol";
465 // import "@openzeppelin/contracts/utils/math/SafeMath.sol";
466 // import "contracts/interfaces/IPinkAntiBot.sol";
467 // import "contracts/BaseToken.sol";
468 
469 contract AntiBotStandardToken is IERC20, Ownable, BaseToken {
470     using SafeMath for uint256;
471 
472     uint256 public constant VERSION = 1;
473 
474     mapping(address => uint256) private _balances;
475     mapping(address => mapping(address => uint256)) private _allowances;
476 
477     string private _name;
478     string private _symbol;
479     uint8 private _decimals;
480     uint256 private _totalSupply;
481 
482     IPinkAntiBot public pinkAntiBot;
483     bool public enableAntiBot;
484 
485     constructor(
486         string memory name_,
487         string memory symbol_,
488         uint8 decimals_,
489         uint256 totalSupply_,
490         address pinkAntiBot_,
491         address serviceFeeReceiver_,
492         uint256 serviceFee_
493     ) payable {
494         _name = name_;
495         _symbol = symbol_;
496         _decimals = decimals_;
497         _mint(owner(), totalSupply_);
498 
499         pinkAntiBot = IPinkAntiBot(pinkAntiBot_);
500         pinkAntiBot.setTokenOwner(owner());
501         enableAntiBot = true;
502 
503         emit TokenCreated(
504             owner(),
505             address(this),
506             TokenType.antiBotStandard,
507             VERSION
508         );
509 
510         payable(serviceFeeReceiver_).transfer(serviceFee_);
511     }
512 
513     function setEnableAntiBot(bool _enable) external onlyOwner {
514         enableAntiBot = _enable;
515     }
516 
517     /**
518      * @dev Returns the name of the token.
519      */
520     function name() public view virtual returns (string memory) {
521         return _name;
522     }
523 
524     /**
525      * @dev Returns the symbol of the token, usually a shorter version of the
526      * name.
527      */
528     function symbol() public view virtual returns (string memory) {
529         return _symbol;
530     }
531 
532     /**
533      * @dev Returns the number of decimals used to get its user representation.
534      * For example, if `decimals` equals `2`, a balance of `505` tokens should
535      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
536      *
537      * Tokens usually opt for a value of 18, imitating the relationship between
538      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
539      * called.
540      *
541      * NOTE: This information is only used for _display_ purposes: it in
542      * no way affects any of the arithmetic of the contract, including
543      * {IERC20-balanceOf} and {IERC20-transfer}.
544      */
545     function decimals() public view virtual returns (uint8) {
546         return _decimals;
547     }
548 
549     /**
550      * @dev See {IERC20-totalSupply}.
551      */
552     function totalSupply() public view virtual override returns (uint256) {
553         return _totalSupply;
554     }
555 
556     /**
557      * @dev See {IERC20-balanceOf}.
558      */
559     function balanceOf(address account)
560         public
561         view
562         virtual
563         override
564         returns (uint256)
565     {
566         return _balances[account];
567     }
568 
569     /**
570      * @dev See {IERC20-transfer}.
571      *
572      * Requirements:
573      *
574      * - `recipient` cannot be the zero address.
575      * - the caller must have a balance of at least `amount`.
576      */
577     function transfer(address recipient, uint256 amount)
578         public
579         virtual
580         override
581         returns (bool)
582     {
583         _transfer(_msgSender(), recipient, amount);
584         return true;
585     }
586 
587     /**
588      * @dev See {IERC20-allowance}.
589      */
590     function allowance(address owner, address spender)
591         public
592         view
593         virtual
594         override
595         returns (uint256)
596     {
597         return _allowances[owner][spender];
598     }
599 
600     /**
601      * @dev See {IERC20-approve}.
602      *
603      * Requirements:
604      *
605      * - `spender` cannot be the zero address.
606      */
607     function approve(address spender, uint256 amount)
608         public
609         virtual
610         override
611         returns (bool)
612     {
613         _approve(_msgSender(), spender, amount);
614         return true;
615     }
616 
617     /**
618      * @dev See {IERC20-transferFrom}.
619      *
620      * Emits an {Approval} event indicating the updated allowance. This is not
621      * required by the EIP. See the note at the beginning of {ERC20}.
622      *
623      * Requirements:
624      *
625      * - `sender` and `recipient` cannot be the zero address.
626      * - `sender` must have a balance of at least `amount`.
627      * - the caller must have allowance for ``sender``'s tokens of at least
628      * `amount`.
629      */
630     function transferFrom(
631         address sender,
632         address recipient,
633         uint256 amount
634     ) public virtual override returns (bool) {
635         _transfer(sender, recipient, amount);
636         _approve(
637             sender,
638             _msgSender(),
639             _allowances[sender][_msgSender()].sub(
640                 amount,
641                 "ERC20: transfer amount exceeds allowance"
642             )
643         );
644         return true;
645     }
646 
647     /**
648      * @dev Atomically increases the allowance granted to `spender` by the caller.
649      *
650      * This is an alternative to {approve} that can be used as a mitigation for
651      * problems described in {IERC20-approve}.
652      *
653      * Emits an {Approval} event indicating the updated allowance.
654      *
655      * Requirements:
656      *
657      * - `spender` cannot be the zero address.
658      */
659     function increaseAllowance(address spender, uint256 addedValue)
660         public
661         virtual
662         returns (bool)
663     {
664         _approve(
665             _msgSender(),
666             spender,
667             _allowances[_msgSender()][spender].add(addedValue)
668         );
669         return true;
670     }
671 
672     /**
673      * @dev Atomically decreases the allowance granted to `spender` by the caller.
674      *
675      * This is an alternative to {approve} that can be used as a mitigation for
676      * problems described in {IERC20-approve}.
677      *
678      * Emits an {Approval} event indicating the updated allowance.
679      *
680      * Requirements:
681      *
682      * - `spender` cannot be the zero address.
683      * - `spender` must have allowance for the caller of at least
684      * `subtractedValue`.
685      */
686     function decreaseAllowance(address spender, uint256 subtractedValue)
687         public
688         virtual
689         returns (bool)
690     {
691         _approve(
692             _msgSender(),
693             spender,
694             _allowances[_msgSender()][spender].sub(
695                 subtractedValue,
696                 "ERC20: decreased allowance below zero"
697             )
698         );
699         return true;
700     }
701 
702     /**
703      * @dev Moves tokens `amount` from `sender` to `recipient`.
704      *
705      * This is internal function is equivalent to {transfer}, and can be used to
706      * e.g. implement automatic token fees, slashing mechanisms, etc.
707      *
708      * Emits a {Transfer} event.
709      *
710      * Requirements:
711      *
712      * - `sender` cannot be the zero address.
713      * - `recipient` cannot be the zero address.
714      * - `sender` must have a balance of at least `amount`.
715      */
716     function _transfer(
717         address sender,
718         address recipient,
719         uint256 amount
720     ) internal virtual {
721         require(sender != address(0), "ERC20: transfer from the zero address");
722         require(recipient != address(0), "ERC20: transfer to the zero address");
723 
724         if (enableAntiBot) {
725             pinkAntiBot.onPreTransferCheck(sender, recipient, amount);
726         }
727 
728         _beforeTokenTransfer(sender, recipient, amount);
729 
730         _balances[sender] = _balances[sender].sub(
731             amount,
732             "ERC20: transfer amount exceeds balance"
733         );
734         _balances[recipient] = _balances[recipient].add(amount);
735         emit Transfer(sender, recipient, amount);
736     }
737 
738     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
739      * the total supply.
740      *
741      * Emits a {Transfer} event with `from` set to the zero address.
742      *
743      * Requirements:
744      *
745      * - `to` cannot be the zero address.
746      */
747     function _mint(address account, uint256 amount) internal virtual {
748         require(account != address(0), "ERC20: mint to the zero address");
749 
750         _beforeTokenTransfer(address(0), account, amount);
751 
752         _totalSupply = _totalSupply.add(amount);
753         _balances[account] = _balances[account].add(amount);
754         emit Transfer(address(0), account, amount);
755     }
756 
757     /**
758      * @dev Destroys `amount` tokens from `account`, reducing the
759      * total supply.
760      *
761      * Emits a {Transfer} event with `to` set to the zero address.
762      *
763      * Requirements:
764      *
765      * - `account` cannot be the zero address.
766      * - `account` must have at least `amount` tokens.
767      */
768     function _burn(address account, uint256 amount) internal virtual {
769         require(account != address(0), "ERC20: burn from the zero address");
770 
771         _beforeTokenTransfer(account, address(0), amount);
772 
773         _balances[account] = _balances[account].sub(
774             amount,
775             "ERC20: burn amount exceeds balance"
776         );
777         _totalSupply = _totalSupply.sub(amount);
778         emit Transfer(account, address(0), amount);
779     }
780 
781     /**
782      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
783      *
784      * This internal function is equivalent to `approve`, and can be used to
785      * e.g. set automatic allowances for certain subsystems, etc.
786      *
787      * Emits an {Approval} event.
788      *
789      * Requirements:
790      *
791      * - `owner` cannot be the zero address.
792      * - `spender` cannot be the zero address.
793      */
794     function _approve(
795         address owner,
796         address spender,
797         uint256 amount
798     ) internal virtual {
799         require(owner != address(0), "ERC20: approve from the zero address");
800         require(spender != address(0), "ERC20: approve to the zero address");
801 
802         _allowances[owner][spender] = amount;
803         emit Approval(owner, spender, amount);
804     }
805 
806     /**
807      * @dev Sets {decimals} to a value other than the default one of 18.
808      *
809      * WARNING: This function should only be called from the constructor. Most
810      * applications that interact with token contracts will not expect
811      * {decimals} to ever change, and may work incorrectly if it does.
812      */
813     function _setupDecimals(uint8 decimals_) internal virtual {
814         _decimals = decimals_;
815     }
816 
817     /**
818      * @dev Hook that is called before any transfer of tokens. This includes
819      * minting and burning.
820      *
821      * Calling conditions:
822      *
823      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
824      * will be to transferred to `to`.
825      * - when `from` is zero, `amount` tokens will be minted for `to`.
826      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
827      * - `from` and `to` are never both zero.
828      *
829      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
830      */
831     function _beforeTokenTransfer(
832         address from,
833         address to,
834         uint256 amount
835     ) internal virtual {}
836 }