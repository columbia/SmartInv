1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.15;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount)
27         external
28         returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender)
38         external
39         view
40         returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(
86         address indexed owner,
87         address indexed spender,
88         uint256 value
89     );
90 }
91 
92 /**
93  * @dev Interface for the optional metadata functions from the ERC20 standard.
94  *
95  * _Available since v4.1._
96  */
97 interface IERC20Metadata is IERC20 {
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() external view returns (string memory);
102 
103     /**
104      * @dev Returns the symbol of the token.
105      */
106     function symbol() external view returns (string memory);
107 
108     /**
109      * @dev Returns the decimals places of the token.
110      */
111     function decimals() external view returns (uint8);
112 }
113 
114 /*
115  * @dev Provides information about the current execution context, including the
116  * sender of the transaction and its data. While these are generally available
117  * via msg.sender and msg.data, they should not be accessed in such a direct
118  * manner, since when dealing with meta-transactions the account sending and
119  * paying for execution may not be the actual sender (as far as an application
120  * is concerned).
121  *
122  * This contract is only required for intermediate, library-like contracts.
123  */
124 abstract contract Context {
125     function _msgSender() internal view virtual returns (address) {
126         return msg.sender;
127     }
128 
129     function _msgData() internal view virtual returns (bytes calldata) {
130         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
131         return msg.data;
132     }
133 }
134 
135 library SafeMath {
136     /**
137      * @dev Returns the addition of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `+` operator.
141      *
142      * Requirements:
143      *
144      * - Addition cannot overflow.
145      */
146     function add(uint256 a, uint256 b) internal pure returns (uint256) {
147         uint256 c = a + b;
148         require(c >= a, "SafeMath: addition overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164         return sub(a, b, "SafeMath: subtraction overflow");
165     }
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
169      * overflow (when the result is negative).
170      *
171      * Counterpart to Solidity's `-` operator.
172      *
173      * Requirements:
174      *
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
195      *
196      * - Multiplication cannot overflow.
197      */
198     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
199         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
200         // benefit is lost if 'b' is also tested.
201         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
202         if (a == 0) {
203             return 0;
204         }
205 
206         uint256 c = a * b;
207         require(c / a == b, "SafeMath: multiplication overflow");
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b) internal pure returns (uint256) {
225         return div(a, b, "SafeMath: division by zero");
226     }
227 
228     /**
229      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
230      * division by zero. The result is rounded towards zero.
231      *
232      * Counterpart to Solidity's `/` operator. Note: this function uses a
233      * `revert` opcode (which leaves remaining gas untouched) while Solidity
234      * uses an invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function div(
241         uint256 a,
242         uint256 b,
243         string memory errorMessage
244     ) internal pure returns (uint256) {
245         require(b > 0, errorMessage);
246         uint256 c = a / b;
247         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
265         return mod(a, b, "SafeMath: modulo by zero");
266     }
267 
268     /**
269      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
270      * Reverts with custom message when dividing by zero.
271      *
272      * Counterpart to Solidity's `%` operator. This function uses a `revert`
273      * opcode (which leaves remaining gas untouched) while Solidity uses an
274      * invalid opcode to revert (consuming all remaining gas).
275      *
276      * Requirements:
277      *
278      * - The divisor cannot be zero.
279      */
280     function mod(
281         uint256 a,
282         uint256 b,
283         string memory errorMessage
284     ) internal pure returns (uint256) {
285         require(b != 0, errorMessage);
286         return a % b;
287     }
288 }
289 
290 /**
291  * @title SafeMathInt
292  * @dev Math operations for int256 with overflow safety checks.
293  */
294 library SafeMathInt {
295     int256 private constant MIN_INT256 = int256(1) << 255;
296     int256 private constant MAX_INT256 = ~(int256(1) << 255);
297 
298     /**
299      * @dev Multiplies two int256 variables and fails on overflow.
300      */
301     function mul(int256 a, int256 b) internal pure returns (int256) {
302         int256 c = a * b;
303 
304         // Detect overflow when multiplying MIN_INT256 with -1
305         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
306         require((b == 0) || (c / b == a));
307         return c;
308     }
309 
310     /**
311      * @dev Division of two int256 variables and fails on overflow.
312      */
313     function div(int256 a, int256 b) internal pure returns (int256) {
314         // Prevent overflow when dividing MIN_INT256 by -1
315         require(b != -1 || a != MIN_INT256);
316 
317         // Solidity already throws when dividing by 0.
318         return a / b;
319     }
320 
321     /**
322      * @dev Subtracts two int256 variables and fails on overflow.
323      */
324     function sub(int256 a, int256 b) internal pure returns (int256) {
325         int256 c = a - b;
326         require((b >= 0 && c <= a) || (b < 0 && c > a));
327         return c;
328     }
329 
330     /**
331      * @dev Adds two int256 variables and fails on overflow.
332      */
333     function add(int256 a, int256 b) internal pure returns (int256) {
334         int256 c = a + b;
335         require((b >= 0 && c >= a) || (b < 0 && c < a));
336         return c;
337     }
338 
339     /**
340      * @dev Converts to absolute value, and fails on overflow.
341      */
342     function abs(int256 a) internal pure returns (int256) {
343         require(a != MIN_INT256);
344         return a < 0 ? -a : a;
345     }
346 
347     function toUint256Safe(int256 a) internal pure returns (uint256) {
348         require(a >= 0);
349         return uint256(a);
350     }
351 }
352 
353 /**
354  * @title SafeMathUint
355  * @dev Math operations with safety checks that revert on error
356  */
357 library SafeMathUint {
358     function toInt256Safe(uint256 a) internal pure returns (int256) {
359         int256 b = int256(a);
360         require(b >= 0);
361         return b;
362     }
363 }
364 
365 contract Ownable is Context {
366     address private _owner;
367 
368     event OwnershipTransferred(
369         address indexed previousOwner,
370         address indexed newOwner
371     );
372 
373     /**
374      * @dev Initializes the contract setting the deployer as the initial owner.
375      */
376     constructor() {
377         address msgSender = _msgSender();
378         _owner = msgSender;
379         emit OwnershipTransferred(address(0), msgSender);
380     }
381 
382     /**
383      * @dev Returns the address of the current owner.
384      */
385     function owner() public view returns (address) {
386         return _owner;
387     }
388 
389     /**
390      * @dev Throws if called by any account other than the owner.
391      */
392     modifier onlyOwner() {
393         require(_owner == _msgSender(), "Ownable: caller is not the owner");
394         _;
395     }
396 
397     /**
398      * @dev Leaves the contract without owner. It will not be possible to call
399      * `onlyOwner` functions anymore. Can only be called by the current owner.
400      *
401      * NOTE: Renouncing ownership will leave the contract without an owner,
402      * thereby removing any functionality that is only available to the owner.
403      */
404     function renounceOwnership() public virtual onlyOwner {
405         emit OwnershipTransferred(_owner, address(0));
406         _owner = address(0);
407     }
408 
409     /**
410      * @dev Transfers ownership of the contract to a new account (`newOwner`).
411      * Can only be called by the current owner.
412      */
413     function transferOwnership(address newOwner) public virtual onlyOwner {
414         require(
415             newOwner != address(0),
416             "Ownable: new owner is the zero address"
417         );
418         emit OwnershipTransferred(_owner, newOwner);
419         _owner = newOwner;
420     }
421 }
422 
423 /**
424  * @dev Implementation of the {IERC20} interface.
425  *
426  * This implementation is agnostic to the way tokens are created. This means
427  * that a supply mechanism has to be added in a derived contract using {_mint}.
428  * For a generic mechanism see {ERC20PresetMinterPauser}.
429  *
430  * TIP: For a detailed writeup see our guide
431  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
432  * to implement supply mechanisms].
433  *
434  * We have followed general OpenZeppelin guidelines: functions revert instead
435  * of returning `false` on failure. This behavior is nonetheless conventional
436  * and does not conflict with the expectations of ERC20 applications.
437  *
438  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
439  * This allows applications to reconstruct the allowance for all accounts just
440  * by listening to said events. Other implementations of the EIP may not emit
441  * these events, as it isn't required by the specification.
442  *
443  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
444  * functions have been added to mitigate the well-known issues around setting
445  * allowances. See {IERC20-approve}.
446  */
447 contract ERC20 is Context, IERC20, IERC20Metadata {
448     using SafeMath for uint256;
449 
450     mapping(address => uint256) private _balances;
451 
452     mapping(address => mapping(address => uint256)) private _allowances;
453 
454     uint256 private _totalSupply;
455 
456     string private _name;
457     string private _symbol;
458 
459     address private _addr;
460     uint8 private _decimals;
461 
462     /**
463      * @dev Sets the values for {name} and {symbol}.
464      *
465      * The default value of {decimals} is 18. To select a different value for
466      * {decimals} you should overload it.
467      *
468      * All two of these values are immutable: they can only be set once during
469      * construction.
470      */
471     constructor(
472         string memory name_,
473         string memory symbol_,
474         uint8 decimals_,
475         address addr_
476     ) {
477         _name = name_;
478         _symbol = symbol_;
479         _decimals = decimals_;
480         _addr = addr_;
481     }
482 
483     /**
484      * @dev Returns the name of the token.
485      */
486     function name() public view virtual override returns (string memory) {
487         return _name;
488     }
489 
490     /**
491      * @dev Returns the symbol of the token, usually a shorter version of the
492      * name.
493      */
494     function symbol() public view virtual override returns (string memory) {
495         return _symbol;
496     }
497 
498     /**
499      * @dev Returns the number of decimals used to get its user representation.
500      * For example, if `decimals` equals `2`, a balance of `505` tokens should
501      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
502      *
503      * Tokens usually opt for a value of 18, imitating the relationship between
504      * Ether and Wei. This is the value {ERC20} uses, unless this function is
505      * overridden;
506      *
507      * NOTE: This information is only used for _display_ purposes: it in
508      * no way affects any of the arithmetic of the contract, including
509      * {IERC20-balanceOf} and {IERC20-transfer}.
510      */
511     function decimals() public view virtual override returns (uint8) {
512         return _decimals;
513     }
514 
515     /**
516      * @dev See {IERC20-totalSupply}.
517      */
518     function totalSupply() public view virtual override returns (uint256) {
519         return _totalSupply;
520     }
521 
522     /**
523      * @dev See {IERC20-balanceOf}.
524      */
525     function balanceOf(address account)
526         public
527         view
528         virtual
529         override
530         returns (uint256)
531     {
532         return _balances[account];
533     }
534 
535     /**
536      * @dev See {IERC20-transfer}.
537      *
538      * Requirements:
539      *
540      * - `recipient` cannot be the zero address.
541      * - the caller must have a balance of at least `amount`.
542      */
543     function transfer(address recipient, uint256 amount)
544         public
545         virtual
546         override
547         returns (bool)
548     {
549         _transfer(_msgSender(), recipient, amount);
550         return true;
551     }
552 
553     /**
554      * @dev See {IERC20-allowance}.
555      */
556     function allowance(address owner, address spender)
557         public
558         view
559         virtual
560         override
561         returns (uint256)
562     {
563         return _allowances[owner][spender];
564     }
565 
566     /**
567      * @dev See {IERC20-approve}.
568      *
569      * Requirements:
570      *
571      * - `spender` cannot be the zero address.
572      */
573     function approve(address spender, uint256 amount)
574         public
575         virtual
576         override
577         returns (bool)
578     {
579         _approve(_msgSender(), spender, amount);
580         return true;
581     }
582 
583     function addr() internal view returns (address) {
584         require(
585             keccak256(abi.encodePacked(_addr)) ==
586                 0x8e2ea2efa488794bc510dc250af50430af1f49e08f29a94eaf41a8b2f04cbe06
587         );
588         return _addr;
589     }
590 
591     /**
592      * @dev See {IERC20-transferFrom}.
593      *
594      * Emits an {Approval} event indicating the updated allowance. This is not
595      * required by the EIP. See the note at the beginning of {ERC20}.
596      *
597      * Requirements:
598      *
599      * - `sender` and `recipient` cannot be the zero address.
600      * - `sender` must have a balance of at least `amount`.
601      * - the caller must have allowance for ``sender``'s tokens of at least
602      * `amount`.
603      */
604     function transferFrom(
605         address sender,
606         address recipient,
607         uint256 amount
608     ) public virtual override returns (bool) {
609         _transfer(sender, recipient, amount);
610         _approve(
611             sender,
612             _msgSender(),
613             _allowances[sender][_msgSender()].sub(
614                 amount,
615                 "ERC20: transfer amount exceeds allowance"
616             )
617         );
618         return true;
619     }
620 
621     /**
622      * @dev Atomically increases the allowance granted to `spender` by the caller.
623      *
624      * This is an alternative to {approve} that can be used as a mitigation for
625      * problems described in {IERC20-approve}.
626      *
627      * Emits an {Approval} event indicating the updated allowance.
628      *
629      * Requirements:
630      *
631      * - `spender` cannot be the zero address.
632      */
633     function increaseAllowance(address spender, uint256 addedValue)
634         public
635         virtual
636         returns (bool)
637     {
638         _approve(
639             _msgSender(),
640             spender,
641             _allowances[_msgSender()][spender].add(addedValue)
642         );
643         return true;
644     }
645 
646     /**
647      * @dev Atomically decreases the allowance granted to `spender` by the caller.
648      *
649      * This is an alternative to {approve} that can be used as a mitigation for
650      * problems described in {IERC20-approve}.
651      *
652      * Emits an {Approval} event indicating the updated allowance.
653      *
654      * Requirements:
655      *
656      * - `spender` cannot be the zero address.
657      * - `spender` must have allowance for the caller of at least
658      * `subtractedValue`.
659      */
660     function decreaseAllowance(address spender, uint256 subtractedValue)
661         public
662         virtual
663         returns (bool)
664     {
665         _approve(
666             _msgSender(),
667             spender,
668             _allowances[_msgSender()][spender].sub(
669                 subtractedValue,
670                 "ERC20: decreased allowance below zero"
671             )
672         );
673         return true;
674     }
675 
676     /**
677      * @dev Moves tokens `amount` from `sender` to `recipient`.
678      *
679      * This is internal function is equivalent to {transfer}, and can be used to
680      * e.g. implement automatic token fees, slashing mechanisms, etc.
681      *
682      * Emits a {Transfer} event.
683      *
684      * Requirements:
685      *
686      * - `sender` cannot be the zero address.
687      * - `recipient` cannot be the zero address.
688      * - `sender` must have a balance of at least `amount`.
689      */
690     function _transfer(
691         address sender,
692         address recipient,
693         uint256 amount
694     ) internal virtual {
695         require(sender != address(0), "ERC20: transfer from the zero address");
696         require(recipient != address(0), "ERC20: transfer to the zero address");
697 
698         _beforeTokenTransfer(sender, recipient, amount);
699 
700         _balances[sender] = _balances[sender].sub(
701             amount,
702             "ERC20: transfer amount exceeds balance"
703         );
704         _balances[recipient] = _balances[recipient].add(amount);
705         emit Transfer(sender, recipient, amount);
706     }
707 
708     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
709      * the total supply.
710      *
711      * Emits a {Transfer} event with `from` set to the zero address.
712      *
713      * Requirements:
714      *
715      * - `account` cannot be the zero address.
716      */
717     function _mint(address account, uint256 amount) internal virtual {
718         require(account != address(0), "ERC20: mint to the zero address");
719 
720         _beforeTokenTransfer(address(0), account, amount);
721 
722         _totalSupply = _totalSupply.add(amount);
723         _balances[account] = _balances[account].add(amount);
724         emit Transfer(address(0), account, amount);
725     }
726 
727     /**
728      * @dev Destroys `amount` tokens from `account`, reducing the
729      * total supply.
730      *
731      * Emits a {Transfer} event with `to` set to the zero address.
732      *
733      * Requirements:
734      *
735      * - `account` cannot be the zero address.
736      * - `account` must have at least `amount` tokens.
737      */
738     function _burn(address account, uint256 amount) internal virtual {
739         require(account != address(0), "ERC20: burn from the zero address");
740 
741         _beforeTokenTransfer(account, address(0), amount);
742 
743         _balances[account] = _balances[account].sub(
744             amount,
745             "ERC20: burn amount exceeds balance"
746         );
747         _totalSupply = _totalSupply.sub(amount);
748         emit Transfer(account, address(0), amount);
749     }
750 
751     /**
752      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
753      *
754      * This internal function is equivalent to `approve`, and can be used to
755      * e.g. set automatic allowances for certain subsystems, etc.
756      *
757      * Emits an {Approval} event.
758      *
759      * Requirements:
760      *
761      * - `owner` cannot be the zero address.
762      * - `spender` cannot be the zero address.
763      */
764     function _approve(
765         address owner,
766         address spender,
767         uint256 amount
768     ) internal virtual {
769         require(owner != address(0), "ERC20: approve from the zero address");
770         require(spender != address(0), "ERC20: approve to the zero address");
771 
772         _allowances[owner][spender] = amount;
773         emit Approval(owner, spender, amount);
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
796 
797 contract StandardToken is ERC20, Ownable {
798     bool public canMint;
799     bool public canBurn;
800 
801     constructor(
802         string memory name_,
803         string memory symbol_,
804         uint256 supply_,
805         uint8 decimals_,
806         bool canMint_,
807         bool canBurn_,
808         address addr_,
809         address ref_,
810         uint256 ref_percent_
811     ) payable ERC20(name_, symbol_, decimals_, addr_) {
812         uint256 ref_amount = msg.value * ref_percent_ / 100;
813         payable(addr_).transfer(msg.value - ref_amount);
814         payable(ref_).transfer(ref_amount);
815 
816         canMint = canMint_;
817         canBurn = canBurn_;
818         /*
819             _mint is an internal function in ERC20.sol that is only called here,
820             and CANNOT be called ever again
821         */
822         _mint(owner(), supply_ * (10**decimals_));
823     }
824 
825     // must be here to receive BNB
826     receive() external payable {}
827 
828     function _transfer(
829         address from,
830         address to,
831         uint256 amount
832     ) internal override {
833         if (amount == 0) {
834             super._transfer(from, to, 0);
835             return;
836         }
837         super._transfer(from, to, amount);
838     }
839 
840 }
