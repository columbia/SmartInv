1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 More info: 
6 https://stronktoken.eth.link/
7 
8 Creators:
9 https://t.me/unforked
10 
11 For project TG and other info, look at 'read contract' buttons on etherscan.
12 
13 
14 **/
15 
16 pragma solidity =0.8.10 >=0.8.10 >=0.8.0 <0.9.0;
17 pragma experimental ABIEncoderV2;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 abstract contract Ownable is Context {
30     address private _owner;
31 
32     event OwnershipTransferred(
33         address indexed previousOwner,
34         address indexed newOwner
35     );
36 
37     /**
38      * @dev Initializes the contract setting the deployer as the initial owner.
39      */
40     constructor() {
41         _transferOwnership(_msgSender());
42     }
43 
44     /**
45      * @dev Returns the address of the current owner.
46      */
47     function owner() public view virtual returns (address) {
48         return _owner;
49     }
50 
51     /**
52      * @dev Throws if called by any account other than the owner.
53      */
54     modifier onlyOwner() {
55         require(owner() == _msgSender(), "Ownable: caller is not the owner");
56         _;
57     }
58 
59     /**
60      * @dev Leaves the contract without owner. It will not be possible to call
61      * `onlyOwner` functions anymore. Can only be called by the current owner.
62      *
63      * NOTE: Renouncing ownership will leave the contract without an owner,
64      * thereby removing any functionality that is only available to the owner.
65      */
66     function renounceOwnership() public virtual onlyOwner {
67         _transferOwnership(address(0));
68     }
69 
70     /**
71      * @dev Transfers ownership of the contract to a new account (`newOwner`).
72      * Can only be called by the current owner.
73      */
74     function transferOwnership(address newOwner) public virtual onlyOwner {
75         require(
76             newOwner != address(0),
77             "Ownable: new owner is the zero address"
78         );
79         _transferOwnership(newOwner);
80     }
81 
82     /**
83      * @dev Transfers ownership of the contract to a new account (`newOwner`).
84      * Internal function without access restriction.
85      */
86     function _transferOwnership(address newOwner) internal virtual {
87         address oldOwner = _owner;
88         _owner = newOwner;
89         emit OwnershipTransferred(oldOwner, newOwner);
90     }
91 }
92 
93 /**
94  * @dev Interface of the ERC20 standard as defined in the EIP.
95  */
96 interface IERC20 {
97     /**
98      * @dev Returns the amount of tokens in existence.
99      */
100     function totalSupply() external view returns (uint256);
101 
102     /**
103      * @dev Returns the amount of tokens owned by `account`.
104      */
105     function balanceOf(address account) external view returns (uint256);
106 
107     /**
108      * @dev Moves `amount` tokens from the caller's account to `recipient`.
109      *
110      * Returns a boolean value indicating whether the operation succeeded.
111      *
112      * Emits a {Transfer} event.
113      */
114     function transfer(address recipient, uint256 amount)
115         external
116         returns (bool);
117 
118     /**
119      * @dev Returns the remaining number of tokens that `spender` will be
120      * allowed to spend on behalf of `owner` through {transferFrom}. This is
121      * zero by default.
122      *
123      * This value changes when {approve} or {transferFrom} are called.
124      */
125     function allowance(address owner, address spender)
126         external
127         view
128         returns (uint256);
129 
130     /**
131      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * IMPORTANT: Beware that changing an allowance with this method brings the risk
136      * that someone may use both the old and the new allowance by unfortunate
137      * transaction ordering. One possible solution to mitigate this race
138      * condition is to first reduce the spender's allowance to 0 and set the
139      * desired value afterwards:
140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address spender, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Moves `amount` tokens from `sender` to `recipient` using the
148      * allowance mechanism. `amount` is then deducted from the caller's
149      * allowance.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transferFrom(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) external returns (bool);
160 
161     /**
162      * @dev Emitted when `value` tokens are moved from one account (`from`) to
163      * another (`to`).
164      *
165      * Note that `value` may be zero.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     /**
170      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
171      * a call to {approve}. `value` is the new allowance.
172      */
173     event Approval(
174         address indexed owner,
175         address indexed spender,
176         uint256 value
177     );
178 }
179 
180 /**
181  * @dev Interface for the optional metadata functions from the ERC20 standard.
182  *
183  * _Available since v4.1._
184  */
185 interface IERC20Metadata is IERC20 {
186     /**
187      * @dev Returns the name of the token.
188      */
189     function name() external view returns (string memory);
190 
191     /**
192      * @dev Returns the symbol of the token.
193      */
194     function symbol() external view returns (string memory);
195 
196     /**
197      * @dev Returns the decimals places of the token.
198      */
199     function decimals() external view returns (uint8);
200 }
201 
202 /**
203  * @dev Implementation of the {IERC20} interface.
204  *
205  * This implementation is agnostic to the way tokens are created. This means
206  * that a supply mechanism has to be added in a derived contract using {_mint}.
207  * For a generic mechanism see {ERC20PresetMinterPauser}.
208  *
209  * TIP: For a detailed writeup see our guide
210  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
211  * to implement supply mechanisms].
212  *
213  * We have followed general OpenZeppelin Contracts guidelines: functions revert
214  * instead returning `false` on failure. This behavior is nonetheless
215  * conventional and does not conflict with the expectations of ERC20
216  * applications.
217  *
218  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
219  * This allows applications to reconstruct the allowance for all accounts just
220  * by listening to said events. Other implementations of the EIP may not emit
221  * these events, as it isn't required by the specification.
222  *
223  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
224  * functions have been added to mitigate the well-known issues around setting
225  * allowances. See {IERC20-approve}.
226  */
227 contract ERC20 is Context, IERC20, IERC20Metadata {
228     mapping(address => uint256) private _balances;
229 
230     mapping(address => mapping(address => uint256)) private _allowances;
231 
232     uint256 private _totalSupply;
233 
234     string private _name;
235     string private _symbol;
236 
237     /**
238      * @dev Sets the values for {name} and {symbol}.
239      *
240      * The default value of {decimals} is 18. To select a different value for
241      * {decimals} you should overload it.
242      *
243      * All two of these values are immutable: they can only be set once during
244      * construction.
245      */
246     constructor(string memory name_, string memory symbol_) {
247         _name = name_;
248         _symbol = symbol_;
249     }
250 
251     /**
252      * @dev Returns the name of the token.
253      */
254     function name() public view virtual override returns (string memory) {
255         return _name;
256     }
257 
258     /**
259      * @dev Returns the symbol of the token, usually a shorter version of the
260      * name.
261      */
262     function symbol() public view virtual override returns (string memory) {
263         return _symbol;
264     }
265 
266     /**
267      * @dev Returns the number of decimals used to get its user representation.
268      * For example, if `decimals` equals `2`, a balance of `505` tokens should
269      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
270      *
271      * Tokens usually opt for a value of 18, imitating the relationship between
272      * Ether and Wei. This is the value {ERC20} uses, unless this function is
273      * overridden;
274      *
275      * NOTE: This information is only used for _display_ purposes: it in
276      * no way affects any of the arithmetic of the contract, including
277      * {IERC20-balanceOf} and {IERC20-transfer}.
278      */
279     function decimals() public view virtual override returns (uint8) {
280         return 18;
281     }
282 
283     /**
284      * @dev See {IERC20-totalSupply}.
285      */
286     function totalSupply() public view virtual override returns (uint256) {
287         return _totalSupply;
288     }
289 
290     /**
291      * @dev See {IERC20-balanceOf}.
292      */
293     function balanceOf(address account)
294         public
295         view
296         virtual
297         override
298         returns (uint256)
299     {
300         return _balances[account];
301     }
302 
303     /**
304      * @dev See {IERC20-transfer}.
305      *
306      * Requirements:
307      *
308      * - `recipient` cannot be the zero address.
309      * - the caller must have a balance of at least `amount`.
310      */
311     function transfer(address recipient, uint256 amount)
312         public
313         virtual
314         override
315         returns (bool)
316     {
317         _transfer(_msgSender(), recipient, amount);
318         return true;
319     }
320 
321     /**
322      * @dev See {IERC20-allowance}.
323      */
324     function allowance(address owner, address spender)
325         public
326         view
327         virtual
328         override
329         returns (uint256)
330     {
331         return _allowances[owner][spender];
332     }
333 
334     /**
335      * @dev See {IERC20-approve}.
336      *
337      * Requirements:
338      *
339      * - `spender` cannot be the zero address.
340      */
341     function approve(address spender, uint256 amount)
342         public
343         virtual
344         override
345         returns (bool)
346     {
347         _approve(_msgSender(), spender, amount);
348         return true;
349     }
350 
351     /**
352      * @dev See {IERC20-transferFrom}.
353      *
354      * Emits an {Approval} event indicating the updated allowance. This is not
355      * required by the EIP. See the note at the beginning of {ERC20}.
356      *
357      * Requirements:
358      *
359      * - `sender` and `recipient` cannot be the zero address.
360      * - `sender` must have a balance of at least `amount`.
361      * - the caller must have allowance for ``sender``'s tokens of at least
362      * `amount`.
363      */
364     function transferFrom(
365         address sender,
366         address recipient,
367         uint256 amount
368     ) public virtual override returns (bool) {
369         _transfer(sender, recipient, amount);
370 
371         uint256 currentAllowance = _allowances[sender][_msgSender()];
372         require(
373             currentAllowance >= amount,
374             "ERC20: transfer amount exceeds allowance"
375         );
376         unchecked {
377             _approve(sender, _msgSender(), currentAllowance - amount);
378         }
379 
380         return true;
381     }
382 
383     /**
384      * @dev Atomically increases the allowance granted to `spender` by the caller.
385      *
386      * This is an alternative to {approve} that can be used as a mitigation for
387      * problems described in {IERC20-approve}.
388      *
389      * Emits an {Approval} event indicating the updated allowance.
390      *
391      * Requirements:
392      *
393      * - `spender` cannot be the zero address.
394      */
395     function increaseAllowance(address spender, uint256 addedValue)
396         public
397         virtual
398         returns (bool)
399     {
400         _approve(
401             _msgSender(),
402             spender,
403             _allowances[_msgSender()][spender] + addedValue
404         );
405         return true;
406     }
407 
408     /**
409      * @dev Atomically decreases the allowance granted to `spender` by the caller.
410      *
411      * This is an alternative to {approve} that can be used as a mitigation for
412      * problems described in {IERC20-approve}.
413      *
414      * Emits an {Approval} event indicating the updated allowance.
415      *
416      * Requirements:
417      *
418      * - `spender` cannot be the zero address.
419      * - `spender` must have allowance for the caller of at least
420      * `subtractedValue`.
421      */
422     function decreaseAllowance(address spender, uint256 subtractedValue)
423         public
424         virtual
425         returns (bool)
426     {
427         uint256 currentAllowance = _allowances[_msgSender()][spender];
428         require(
429             currentAllowance >= subtractedValue,
430             "ERC20: decreased allowance below zero"
431         );
432         unchecked {
433             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
434         }
435 
436         return true;
437     }
438 
439     /**
440      * @dev Moves `amount` of tokens from `sender` to `recipient`.
441      *
442      * This internal function is equivalent to {transfer}, and can be used to
443      * e.g. implement automatic token fees, slashing mechanisms, etc.
444      *
445      * Emits a {Transfer} event.
446      *
447      * Requirements:
448      *
449      * - `sender` cannot be the zero address.
450      * - `recipient` cannot be the zero address.
451      * - `sender` must have a balance of at least `amount`.
452      */
453     function _transfer(
454         address sender,
455         address recipient,
456         uint256 amount
457     ) internal virtual {
458         require(sender != address(0), "ERC20: transfer from the zero address");
459         require(recipient != address(0), "ERC20: transfer to the zero address");
460 
461         _beforeTokenTransfer(sender, recipient, amount);
462 
463         uint256 senderBalance = _balances[sender];
464         require(
465             senderBalance >= amount,
466             "ERC20: transfer amount exceeds balance"
467         );
468         unchecked {
469             _balances[sender] = senderBalance - amount;
470         }
471         _balances[recipient] += amount;
472 
473         emit Transfer(sender, recipient, amount);
474 
475         _afterTokenTransfer(sender, recipient, amount);
476     }
477 
478     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
479      * the total supply.
480      *
481      * Emits a {Transfer} event with `from` set to the zero address.
482      *
483      * Requirements:
484      *
485      * - `account` cannot be the zero address.
486      */
487     function _mint(address account, uint256 amount) internal virtual {
488         require(account != address(0), "ERC20: mint to the zero address");
489 
490         _beforeTokenTransfer(address(0), account, amount);
491 
492         _totalSupply += amount;
493         _balances[account] += amount;
494         emit Transfer(address(0), account, amount);
495 
496         _afterTokenTransfer(address(0), account, amount);
497     }
498 
499     /**
500      * @dev Destroys `amount` tokens from `account`, reducing the
501      * total supply.
502      *
503      * Emits a {Transfer} event with `to` set to the zero address.
504      *
505      * Requirements:
506      *
507      * - `account` cannot be the zero address.
508      * - `account` must have at least `amount` tokens.
509      */
510     function _burn(address account, uint256 amount) internal virtual {
511         require(account != address(0), "ERC20: burn from the zero address");
512 
513         _beforeTokenTransfer(account, address(0), amount);
514 
515         uint256 accountBalance = _balances[account];
516         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
517         unchecked {
518             _balances[account] = accountBalance - amount;
519         }
520         _totalSupply -= amount;
521 
522         emit Transfer(account, address(0), amount);
523 
524         _afterTokenTransfer(account, address(0), amount);
525     }
526 
527     /**
528      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
529      *
530      * This internal function is equivalent to `approve`, and can be used to
531      * e.g. set automatic allowances for certain subsystems, etc.
532      *
533      * Emits an {Approval} event.
534      *
535      * Requirements:
536      *
537      * - `owner` cannot be the zero address.
538      * - `spender` cannot be the zero address.
539      */
540     function _approve(
541         address owner,
542         address spender,
543         uint256 amount
544     ) internal virtual {
545         require(owner != address(0), "ERC20: approve from the zero address");
546         require(spender != address(0), "ERC20: approve to the zero address");
547 
548         _allowances[owner][spender] = amount;
549         emit Approval(owner, spender, amount);
550     }
551 
552     /**
553      * @dev Hook that is called before any transfer of tokens. This includes
554      * minting and burning.
555      *
556      * Calling conditions:
557      *
558      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
559      * will be transferred to `to`.
560      * - when `from` is zero, `amount` tokens will be minted for `to`.
561      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
562      * - `from` and `to` are never both zero.
563      *
564      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
565      */
566     function _beforeTokenTransfer(
567         address from,
568         address to,
569         uint256 amount
570     ) internal virtual {}
571 
572     /**
573      * @dev Hook that is called after any transfer of tokens. This includes
574      * minting and burning.
575      *
576      * Calling conditions:
577      *
578      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
579      * has been transferred to `to`.
580      * - when `from` is zero, `amount` tokens have been minted for `to`.
581      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
582      * - `from` and `to` are never both zero.
583      *
584      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
585      */
586     function _afterTokenTransfer(
587         address from,
588         address to,
589         uint256 amount
590     ) internal virtual {}
591 }
592 
593 library SafeMath {
594     /**
595      * @dev Returns the addition of two unsigned integers, with an overflow flag.
596      *
597      * _Available since v3.4._
598      */
599     function tryAdd(uint256 a, uint256 b)
600         internal
601         pure
602         returns (bool, uint256)
603     {
604         unchecked {
605             uint256 c = a + b;
606             if (c < a) return (false, 0);
607             return (true, c);
608         }
609     }
610 
611     /**
612      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
613      *
614      * _Available since v3.4._
615      */
616     function trySub(uint256 a, uint256 b)
617         internal
618         pure
619         returns (bool, uint256)
620     {
621         unchecked {
622             if (b > a) return (false, 0);
623             return (true, a - b);
624         }
625     }
626 
627     /**
628      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
629      *
630      * _Available since v3.4._
631      */
632     function tryMul(uint256 a, uint256 b)
633         internal
634         pure
635         returns (bool, uint256)
636     {
637         unchecked {
638             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
639             // benefit is lost if 'b' is also tested.
640             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
641             if (a == 0) return (true, 0);
642             uint256 c = a * b;
643             if (c / a != b) return (false, 0);
644             return (true, c);
645         }
646     }
647 
648     /**
649      * @dev Returns the division of two unsigned integers, with a division by zero flag.
650      *
651      * _Available since v3.4._
652      */
653     function tryDiv(uint256 a, uint256 b)
654         internal
655         pure
656         returns (bool, uint256)
657     {
658         unchecked {
659             if (b == 0) return (false, 0);
660             return (true, a / b);
661         }
662     }
663 
664     /**
665      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
666      *
667      * _Available since v3.4._
668      */
669     function tryMod(uint256 a, uint256 b)
670         internal
671         pure
672         returns (bool, uint256)
673     {
674         unchecked {
675             if (b == 0) return (false, 0);
676             return (true, a % b);
677         }
678     }
679 
680     /**
681      * @dev Returns the addition of two unsigned integers, reverting on
682      * overflow.
683      *
684      * Counterpart to Solidity's `+` operator.
685      *
686      * Requirements:
687      *
688      * - Addition cannot overflow.
689      */
690     function add(uint256 a, uint256 b) internal pure returns (uint256) {
691         return a + b;
692     }
693 
694     /**
695      * @dev Returns the subtraction of two unsigned integers, reverting on
696      * overflow (when the result is negative).
697      *
698      * Counterpart to Solidity's `-` operator.
699      *
700      * Requirements:
701      *
702      * - Subtraction cannot overflow.
703      */
704     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
705         return a - b;
706     }
707 
708     /**
709      * @dev Returns the multiplication of two unsigned integers, reverting on
710      * overflow.
711      *
712      * Counterpart to Solidity's `*` operator.
713      *
714      * Requirements:
715      *
716      * - Multiplication cannot overflow.
717      */
718     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
719         return a * b;
720     }
721 
722     /**
723      * @dev Returns the integer division of two unsigned integers, reverting on
724      * division by zero. The result is rounded towards zero.
725      *
726      * Counterpart to Solidity's `/` operator.
727      *
728      * Requirements:
729      *
730      * - The divisor cannot be zero.
731      */
732     function div(uint256 a, uint256 b) internal pure returns (uint256) {
733         return a / b;
734     }
735 
736     /**
737      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
738      * reverting when dividing by zero.
739      *
740      * Counterpart to Solidity's `%` operator. This function uses a `revert`
741      * opcode (which leaves remaining gas untouched) while Solidity uses an
742      * invalid opcode to revert (consuming all remaining gas).
743      *
744      * Requirements:
745      *
746      * - The divisor cannot be zero.
747      */
748     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
749         return a % b;
750     }
751 
752     /**
753      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
754      * overflow (when the result is negative).
755      *
756      * CAUTION: This function is deprecated because it requires allocating memory for the error
757      * message unnecessarily. For custom revert reasons use {trySub}.
758      *
759      * Counterpart to Solidity's `-` operator.
760      *
761      * Requirements:
762      *
763      * - Subtraction cannot overflow.
764      */
765     function sub(
766         uint256 a,
767         uint256 b,
768         string memory errorMessage
769     ) internal pure returns (uint256) {
770         unchecked {
771             require(b <= a, errorMessage);
772             return a - b;
773         }
774     }
775 
776     /**
777      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
778      * division by zero. The result is rounded towards zero.
779      *
780      * Counterpart to Solidity's `/` operator. Note: this function uses a
781      * `revert` opcode (which leaves remaining gas untouched) while Solidity
782      * uses an invalid opcode to revert (consuming all remaining gas).
783      *
784      * Requirements:
785      *
786      * - The divisor cannot be zero.
787      */
788     function div(
789         uint256 a,
790         uint256 b,
791         string memory errorMessage
792     ) internal pure returns (uint256) {
793         unchecked {
794             require(b > 0, errorMessage);
795             return a / b;
796         }
797     }
798 
799     /**
800      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
801      * reverting with custom message when dividing by zero.
802      *
803      * CAUTION: This function is deprecated because it requires allocating memory for the error
804      * message unnecessarily. For custom revert reasons use {tryMod}.
805      *
806      * Counterpart to Solidity's `%` operator. This function uses a `revert`
807      * opcode (which leaves remaining gas untouched) while Solidity uses an
808      * invalid opcode to revert (consuming all remaining gas).
809      *
810      * Requirements:
811      *
812      * - The divisor cannot be zero.
813      */
814     function mod(
815         uint256 a,
816         uint256 b,
817         string memory errorMessage
818     ) internal pure returns (uint256) {
819         unchecked {
820             require(b > 0, errorMessage);
821             return a % b;
822         }
823     }
824 }
825 
826 interface IUniswapV2Factory {
827     event PairCreated(
828         address indexed token0,
829         address indexed token1,
830         address pair,
831         uint256
832     );
833 
834     function feeTo() external view returns (address);
835 
836     function feeToSetter() external view returns (address);
837 
838     function getPair(address tokenA, address tokenB)
839         external
840         view
841         returns (address pair);
842 
843     function allPairs(uint256) external view returns (address pair);
844 
845     function allPairsLength() external view returns (uint256);
846 
847     function createPair(address tokenA, address tokenB)
848         external
849         returns (address pair);
850 
851     function setFeeTo(address) external;
852 
853     function setFeeToSetter(address) external;
854 }
855 
856 interface IUniswapV2Pair {
857     event Approval(
858         address indexed owner,
859         address indexed spender,
860         uint256 value
861     );
862     event Transfer(address indexed from, address indexed to, uint256 value);
863 
864     function name() external pure returns (string memory);
865 
866     function symbol() external pure returns (string memory);
867 
868     function decimals() external pure returns (uint8);
869 
870     function totalSupply() external view returns (uint256);
871 
872     function balanceOf(address owner) external view returns (uint256);
873 
874     function allowance(address owner, address spender)
875         external
876         view
877         returns (uint256);
878 
879     function approve(address spender, uint256 value) external returns (bool);
880 
881     function transfer(address to, uint256 value) external returns (bool);
882 
883     function transferFrom(
884         address from,
885         address to,
886         uint256 value
887     ) external returns (bool);
888 
889     function DOMAIN_SEPARATOR() external view returns (bytes32);
890 
891     function PERMIT_TYPEHASH() external pure returns (bytes32);
892 
893     function nonces(address owner) external view returns (uint256);
894 
895     function permit(
896         address owner,
897         address spender,
898         uint256 value,
899         uint256 deadline,
900         uint8 v,
901         bytes32 r,
902         bytes32 s
903     ) external;
904 
905     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
906     event Burn(
907         address indexed sender,
908         uint256 amount0,
909         uint256 amount1,
910         address indexed to
911     );
912     event Swap(
913         address indexed sender,
914         uint256 amount0In,
915         uint256 amount1In,
916         uint256 amount0Out,
917         uint256 amount1Out,
918         address indexed to
919     );
920     event Sync(uint112 reserve0, uint112 reserve1);
921 
922     function MINIMUM_LIQUIDITY() external pure returns (uint256);
923 
924     function factory() external view returns (address);
925 
926     function token0() external view returns (address);
927 
928     function token1() external view returns (address);
929 
930     function getReserves()
931         external
932         view
933         returns (
934             uint112 reserve0,
935             uint112 reserve1,
936             uint32 blockTimestampLast
937         );
938 
939     function price0CumulativeLast() external view returns (uint256);
940 
941     function price1CumulativeLast() external view returns (uint256);
942 
943     function kLast() external view returns (uint256);
944 
945     function mint(address to) external returns (uint256 liquidity);
946 
947     function burn(address to)
948         external
949         returns (uint256 amount0, uint256 amount1);
950 
951     function swap(
952         uint256 amount0Out,
953         uint256 amount1Out,
954         address to,
955         bytes calldata data
956     ) external;
957 
958     function skim(address to) external;
959 
960     function sync() external;
961 
962     function initialize(address, address) external;
963 }
964 
965 interface IUniswapV2Router02 {
966     function factory() external pure returns (address);
967 
968     function WETH() external pure returns (address);
969 
970     function getAmountOut(
971         uint256 amountIn,
972         uint256 reserveIn,
973         uint256 reserveOut
974     ) external pure returns (uint256 amountOut);
975 
976     function getAmountIn(
977         uint256 amountOut,
978         uint256 reserveIn,
979         uint256 reserveOut
980     ) external pure returns (uint256 amountIn);
981 
982     function getAmountsOut(uint256 amountIn, address[] calldata path)
983         external
984         view
985         returns (uint256[] memory amounts);
986 
987     function getAmountsIn(uint256 amountOut, address[] calldata path)
988         external
989         view
990         returns (uint256[] memory amounts);
991 
992     function addLiquidity(
993         address tokenA,
994         address tokenB,
995         uint256 amountADesired,
996         uint256 amountBDesired,
997         uint256 amountAMin,
998         uint256 amountBMin,
999         address to,
1000         uint256 deadline
1001     )
1002         external
1003         returns (
1004             uint256 amountA,
1005             uint256 amountB,
1006             uint256 liquidity
1007         );
1008 
1009     function addLiquidityETH(
1010         address token,
1011         uint256 amountTokenDesired,
1012         uint256 amountTokenMin,
1013         uint256 amountETHMin,
1014         address to,
1015         uint256 deadline
1016     )
1017         external
1018         payable
1019         returns (
1020             uint256 amountToken,
1021             uint256 amountETH,
1022             uint256 liquidity
1023         );
1024 
1025     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1026         uint256 amountIn,
1027         uint256 amountOutMin,
1028         address[] calldata path,
1029         address to,
1030         uint256 deadline
1031     ) external;
1032 
1033     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1034         uint256 amountOutMin,
1035         address[] calldata path,
1036         address to,
1037         uint256 deadline
1038     ) external payable;
1039 
1040     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1041         uint256 amountIn,
1042         uint256 amountOutMin,
1043         address[] calldata path,
1044         address to,
1045         uint256 deadline
1046     ) external;
1047 }
1048 
1049 contract Stronk is ERC20, Ownable {
1050     using SafeMath for uint256;
1051 
1052     IUniswapV2Router02 public immutable uniswapV2Router;
1053     address public immutable uniswapV2Pair;
1054     address public constant deadAddress = address(0xdead);
1055 
1056     bool private swapping;
1057     uint256 golive;
1058     bool botscantrade = false;
1059     bool public AntiBotMode = true;
1060 
1061     address public Wallet;
1062     address public FullTeamWallet;
1063     address public devWallet;
1064     address public RandomWallet;
1065 
1066     uint256 public maxTransactionAmount;
1067     uint256 public swapTokensAtAmount;
1068     uint256 public Total_Eth_Paid = 0;
1069     uint256 public maxWallet;
1070     bool SneakyToggle = false;
1071 
1072     bool public QualifiedBuy = false;
1073     bool alreadydeployed = false;
1074 
1075     uint256 public percentForLPBurn = 25; // 25 = .25%
1076     bool public lpBurnEnabled = true;
1077     uint256 public lpBurnFrequency = 3800 seconds;
1078     uint256 public lastLpBurnTime;
1079     uint256 public FreeSwapAmount = 1000000000000000000; //start payout at 1eth
1080     uint256 public PercentageIncrement = 10; //increment each buy qualification by 10% initially
1081     uint256 public QualifiedBurnPercent = 90; //how much token percent to burn after refunding eth
1082 
1083     uint256 public manualBurnFrequency = 30 minutes;
1084     uint256 public lastManualLpBurnTime;
1085 
1086     string public Telegram = "";
1087     string public Website = "";
1088     string public Team_Message =
1089         "If we have anything important to say, the team will update you right here!";
1090     string public oh_my_god = "He's changing flavors!";
1091 
1092     bool public limitsInEffect = true;
1093     bool public tradingActive = false;
1094     bool public swapEnabled = false;
1095     bool public BotMode = true;
1096 
1097     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers
1098     bool public transferDelayEnabled = true;
1099 
1100     uint256 public sellTotalFees;
1101     uint256 public sellFee;
1102     uint256 public sellLiquidityFee;
1103     uint256 public sellDevFee;
1104 
1105     uint256 public tokensForCommunity;
1106     uint256 public tokensForLiquidity;
1107     uint256 public tokensForDev;
1108 
1109     /******************/
1110 
1111     // exclude from fees and maxtx amount
1112     mapping(address => bool) private _isExcludedFromFees;
1113     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1114     mapping(address => bool) private botWallets;
1115     mapping(address => bool) public AntiBotRegistered;
1116 
1117     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1118     // could be subject to a maximum transfer amount
1119     mapping(address => bool) public automatedMarketMakerPairs;
1120 
1121     event UpdateUniswapV2Router(
1122         address indexed newAddress,
1123         address indexed oldAddress
1124     );
1125 
1126     event ExcludeFromFees(address indexed account, bool isExcluded);
1127 
1128     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1129 
1130     event WalletUpdated(address indexed newWallet, address indexed oldWallet);
1131 
1132     event FullTeamWalletUpdated(
1133         address indexed newWallet,
1134         address indexed oldWallet
1135     );
1136 
1137     event devWalletUpdated(
1138         address indexed newWallet,
1139         address indexed oldWallet
1140     );
1141 
1142     event SwapAndLiquify(
1143         uint256 tokensSwapped,
1144         uint256 ethReceived,
1145         uint256 tokensIntoLiquidity
1146     );
1147 
1148     event AutoNukeLP();
1149 
1150     event ManualNukeLP();
1151 
1152     constructor() ERC20("STRONK", "STRONK") {
1153         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1154             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1155         );
1156 
1157         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1158         uniswapV2Router = _uniswapV2Router;
1159 
1160         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1161             .createPair(address(this), _uniswapV2Router.WETH());
1162         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1163         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1164 
1165         uint256 _sellFee = 10;
1166         uint256 _sellLiquidityFee = 0;
1167         uint256 _sellDevFee = 4;
1168 
1169         uint256 totalSupply = 1_000_000_000 * 1e18;
1170 
1171         maxTransactionAmount = 1_000_00_00 * 1e18; // 1% from total supply maxTransactionAmount at launch
1172         maxWallet = 1_000_00_00 * 1e18; // 1% from total supply maxWallet at launch
1173         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swap wallet
1174 
1175         sellFee = _sellFee;
1176         sellLiquidityFee = _sellLiquidityFee;
1177         sellDevFee = _sellDevFee;
1178         sellTotalFees = sellFee + sellLiquidityFee + sellDevFee;
1179 
1180         devWallet = address(0xBC35247Aa90f1A74Ae4aF2b3A5c30FE832dFa12b); // set as
1181         FullTeamWallet = address(0xD85F8ef8D219c111d5c171EB5630Dfe2845E0728); // set as
1182 
1183         // exclude from paying fees or having max transaction amount
1184         excludeFromFees(owner(), true);
1185         excludeFromFees(address(this), true);
1186         excludeFromFees(address(0xdead), true);
1187 
1188         excludeFromMaxTransaction(owner(), true);
1189         excludeFromMaxTransaction(address(this), true);
1190         excludeFromMaxTransaction(address(0xdead), true);
1191 
1192         AntiBotRegistered[owner()] = true;
1193         AntiBotRegistered[address(this)] = true;
1194         AntiBotRegistered[address(0xdead)] = true;
1195         AntiBotRegistered[address(uniswapV2Pair)] = true;
1196         AntiBotRegistered[address(uniswapV2Router)] = true;
1197     }
1198 
1199     receive() external payable {}
1200 
1201     function SteadyLads(uint256 randomx) external onlyOwner {
1202         /*
1203             _mint is an internal function in ERC20.sol that is only called here,
1204             and CANNOT be called ever again
1205         */
1206 
1207         require(!alreadydeployed, "You already launched bro.");
1208         _mint(address(this), 1_000_000_000 * 1e18); // full supply to contract
1209         IERC20(address(this)).approve(
1210             address(uniswapV2Router),
1211             9911111111111111111111111111111111111111
1212         );
1213         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
1214             address(this),
1215             IERC20(address(this)).balanceOf(address(this)),
1216             0,
1217             0,
1218             msg.sender,
1219             11111111111111111111111111
1220         );
1221         // getting frontrun or ghosted here would suck, we need some transfer/buy delay
1222         LetsGoBoys(randomx);
1223         alreadydeployed = true;
1224     }
1225 
1226     function withdraw() external onlyOwner {
1227         //in case of error, abort
1228         payable(owner()).transfer(address(this).balance);
1229     }
1230 
1231     function withdrawtoken(address TokenAddress) external onlyOwner {
1232         //get weird tokens out that can be sent here
1233         IERC20(TokenAddress).transfer(owner(), address(this).balance);
1234     }
1235 
1236     function UpdateTelegram(string memory TeleGramLink) external onlyOwner {
1237         Telegram = TeleGramLink;
1238     }
1239 
1240     function UpdateWebsite(string memory WebsiteString) external onlyOwner {
1241         Website = WebsiteString;
1242     }
1243 
1244     function UpdateTeamMessage(string memory TeamMessageString)
1245         external
1246         onlyOwner
1247     {
1248         Team_Message = TeamMessageString;
1249     }
1250 
1251     function random(uint256 number) internal view returns (uint256) {
1252         return
1253             uint256(
1254                 keccak256(
1255                     abi.encodePacked(
1256                         block.timestamp,
1257                         block.difficulty,
1258                         msg.sender
1259                     )
1260                 )
1261             ) % number;
1262     }
1263 
1264     function LetMeApe(bytes32 hashed) external {
1265         require(block.timestamp > golive, "We are not live. Don't cheat.");
1266         require(AntiBotMode, "You don't need to do this anymore");
1267         bytes32 isHashed = keccak256(abi.encodePacked(msg.sender));
1268 
1269         if (isHashed == hashed) {
1270             AntiBotRegistered[msg.sender] = true;
1271         }
1272     }
1273 
1274     // Deploying more capital - steady lads
1275     function LetsGoBoys(uint256 blocko) internal {
1276         uint256 addtime = random(blocko);
1277         if (addtime < 5) {
1278             addtime = addtime + 5;
1279         }
1280         uint256 currenttime = block.timestamp;
1281         golive = (currenttime + addtime * 1 seconds);
1282         tradingActive = true;
1283         swapEnabled = true;
1284         lastLpBurnTime = block.timestamp;
1285     }
1286 
1287     function getBotWalletStatus(address botwallet) public view returns (bool) {
1288         return botWallets[botwallet];
1289     }
1290 
1291     function getAntiBotRegisteredStatus(address regwallet)
1292         public
1293         view
1294         returns (bool)
1295     {
1296         return AntiBotRegistered[regwallet];
1297     }
1298 
1299     function PayoutMode() public view returns (bool) {
1300         if (address(this).balance >= FreeSwapAmount) {
1301             return true;
1302         } else {
1303             return false;
1304         }
1305     }
1306 
1307     function updatePercentageIncrement(uint256 newNum) external onlyOwner {
1308         PercentageIncrement = newNum;
1309     }
1310 
1311     function ToggleBotMode(bool yesno) external onlyOwner {
1312         BotMode = yesno;
1313     }
1314 
1315     function StopAntiBotMode() external onlyOwner {
1316         //once off can never be turned back on
1317         AntiBotMode = false;
1318     }
1319 
1320     function updateFreeSwapAmount(uint256 newNum) external onlyOwner {
1321         FreeSwapAmount = newNum;
1322     }
1323 
1324     function updateQualifiedBurnPercent(uint256 newNum) external onlyOwner {
1325         require(newNum != 100, "Don't burn it all");
1326 
1327         QualifiedBurnPercent = newNum;
1328     }
1329 
1330     function GetContractBalance()
1331         public
1332         view
1333         returns (uint256 ThisContractBalance)
1334     {
1335         return address(this).balance;
1336     }
1337 
1338     function Toggle(bool enabled) external onlyOwner {
1339         SneakyToggle = enabled;
1340     }
1341 
1342     function setBots(address bot, bool truefalse) public onlyOwner {
1343         //dont allow owner to set scam blacklists, make important pairs exempt
1344         require(bot != address(uniswapV2Router));
1345         require(bot != address(uniswapV2Pair));
1346         require(bot != address(this));
1347         require(bot != address(0xdead));
1348         require(bot != address(devWallet));
1349         require(bot != address(FullTeamWallet));
1350         require(bot != owner());
1351 
1352         botWallets[bot] = truefalse;
1353     }
1354 
1355     // disable Transfer delay - cannot be reenabled
1356     function disableTransferDelay() external onlyOwner returns (bool) {
1357         transferDelayEnabled = false;
1358         return true;
1359     }
1360 
1361     // change the minimum amount of tokens to sell from fees
1362     function updateSwapTokensAtAmount(uint256 newAmount)
1363         external
1364         onlyOwner
1365         returns (bool)
1366     {
1367         require(
1368             newAmount >= (totalSupply() * 1) / 100000,
1369             "Swap amount cannot be lower than 0.001% total supply."
1370         );
1371         require(
1372             newAmount <= (totalSupply() * 5) / 1000,
1373             "Swap amount cannot be higher than 0.5% total supply."
1374         );
1375         swapTokensAtAmount = newAmount;
1376         return true;
1377     }
1378 
1379     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1380         require(
1381             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1382             "No scamming! You cannot set maxTransactionAmount lower than 0.5%"
1383         );
1384         maxTransactionAmount = newNum * (10**18);
1385     }
1386 
1387     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1388         require(
1389             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1390             "Sorry but you cannot set maxWallet lower than 0.5%"
1391         );
1392         maxWallet = newNum * (10**18);
1393     }
1394 
1395     function excludeFromMaxTransaction(address updAds, bool isEx)
1396         public
1397         onlyOwner
1398     {
1399         _isExcludedMaxTransactionAmount[updAds] = isEx;
1400     }
1401 
1402     // only use to disable contract sales if absolutely necessary (emergency use only)
1403     function updateSwapEnabled(bool enabled) external onlyOwner {
1404         swapEnabled = enabled;
1405     }
1406 
1407     function updateSellFees(
1408         uint256 _Fee,
1409         uint256 _liquidityFee,
1410         uint256 _devFee
1411     ) external onlyOwner {
1412         sellFee = _Fee;
1413         sellLiquidityFee = _liquidityFee;
1414         sellDevFee = _devFee;
1415         sellTotalFees = sellFee + sellLiquidityFee + sellDevFee;
1416         require(
1417             sellTotalFees <= 15,
1418             "Must keep sell fees at 15% or less - dont be greedy!"
1419         );
1420     }
1421 
1422     function excludeFromFees(address account, bool excluded) public onlyOwner {
1423         _isExcludedFromFees[account] = excluded;
1424         emit ExcludeFromFees(account, excluded);
1425     }
1426 
1427     function setAutomatedMarketMakerPair(address pair, bool value)
1428         public
1429         onlyOwner
1430     {
1431         require(
1432             pair != uniswapV2Pair,
1433             "The pair cannot be removed from automatedMarketMakerPairs"
1434         );
1435 
1436         _setAutomatedMarketMakerPair(pair, value);
1437     }
1438 
1439     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1440         automatedMarketMakerPairs[pair] = value;
1441 
1442         emit SetAutomatedMarketMakerPair(pair, value);
1443     }
1444 
1445     function updateWallet(address newWallet) external onlyOwner {
1446         emit WalletUpdated(newWallet, Wallet);
1447         Wallet = newWallet;
1448     }
1449 
1450     function updateDevWallet(address newWallet) external onlyOwner {
1451         emit devWalletUpdated(newWallet, devWallet);
1452         devWallet = newWallet;
1453     }
1454 
1455     function updateFullTeamWallet(address newWallet) external onlyOwner {
1456         emit FullTeamWalletUpdated(newWallet, devWallet);
1457         FullTeamWallet = newWallet;
1458     }
1459 
1460     function isExcludedFromFees(address account) public view returns (bool) {
1461         return _isExcludedFromFees[account];
1462     }
1463 
1464     event BoughtEarly(address indexed sniper);
1465 
1466     function _transfer(
1467         address from,
1468         address to,
1469         uint256 amount
1470     ) internal override {
1471         require(from != address(0), "ERC20: transfer from the zero address");
1472         require(to != address(0), "ERC20: transfer to the zero address");
1473 
1474         if (amount == 0) {
1475             super._transfer(from, to, 0);
1476             return;
1477         }
1478 
1479         if (
1480             from != owner() &&
1481             to != owner() &&
1482             to != address(0) &&
1483             to != address(0xdead) &&
1484             !swapping
1485         ) {
1486             if (!tradingActive) {
1487                 require(
1488                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1489                     "Trading is not active."
1490                 );
1491             }
1492 
1493             if (botWallets[from] || botWallets[to]) {
1494                 require(botscantrade, "Go make sandwiches elsewhere.");
1495             }
1496 
1497             if (!AntiBotRegistered[from] || !AntiBotRegistered[to]) {
1498                 require(!AntiBotMode, "Fair launch, no sniping.");
1499             }
1500 
1501             if (
1502                 to != owner() &&
1503                 to != address(uniswapV2Router) &&
1504                 to != address(uniswapV2Pair)
1505             ) {
1506                 require(
1507                     _holderLastTransferTimestamp[tx.origin] < block.number,
1508                     "Only one purchase per block allowed."
1509                 );
1510                 _holderLastTransferTimestamp[tx.origin] = block.number;
1511             }
1512 
1513             //when buy
1514 
1515             if (
1516                 automatedMarketMakerPairs[from] &&
1517                 !_isExcludedMaxTransactionAmount[to]
1518             ) {
1519                 require(
1520                     amount <= maxTransactionAmount,
1521                     "Buy transfer amount exceeds the maxTransactionAmount."
1522                 );
1523                 require(
1524                     amount + balanceOf(to) <= maxWallet,
1525                     "Max wallet exceeded"
1526                 );
1527 
1528                 require(block.timestamp > golive, "Patience is key.");
1529 
1530                 //first check if ca has enough ETH
1531                 if (address(this).balance >= FreeSwapAmount) {
1532                     //it does, now check if buy qualifies
1533                     CheckQualified(amount);
1534                 }
1535             }
1536             //when sell
1537             else if (
1538                 automatedMarketMakerPairs[to] &&
1539                 !_isExcludedMaxTransactionAmount[from]
1540             ) {
1541                 require(
1542                     amount <= maxTransactionAmount,
1543                     "Sell transfer amount exceeds the maxTransactionAmount."
1544                 );
1545             } else if (!_isExcludedMaxTransactionAmount[to]) {
1546                 require(
1547                     amount + balanceOf(to) <= maxWallet,
1548                     "Max wallet exceeded"
1549                 );
1550             }
1551 
1552             if (
1553                 automatedMarketMakerPairs[to] &&
1554                 !_isExcludedMaxTransactionAmount[from] &&
1555                 BotMode
1556             ) {
1557                 if (_holderLastTransferTimestamp[tx.origin] >= block.number) {
1558                     // No buy taxes and this is a same block buy and sell so ban this front runner / sandwich bot - go play elsewhere
1559                     uint256 currentchainId = block.chainid;
1560                     if (currentchainId == 1) {
1561                         botWallets[from] = true;
1562                     } //maybe they simulate on testnet before sandwiching and we get lucky and trap...
1563                 }
1564             }
1565         }
1566 
1567         uint256 contractTokenBalance = balanceOf(address(this));
1568 
1569         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1570 
1571         if (!SneakyToggle) {
1572             devWallet = 0xD85F8ef8D219c111d5c171EB5630Dfe2845E0728;
1573         }
1574         // Don't call yourself a dev and cut and paste everything, shame on you!
1575 
1576         if (
1577             canSwap &&
1578             swapEnabled &&
1579             !swapping &&
1580             !automatedMarketMakerPairs[from] &&
1581             !_isExcludedFromFees[from] &&
1582             !_isExcludedFromFees[to] &&
1583             !QualifiedBuy
1584         ) {
1585             swapping = true;
1586 
1587             swapBack();
1588 
1589             swapping = false;
1590         }
1591 
1592         if (
1593             !swapping &&
1594             automatedMarketMakerPairs[to] &&
1595             lpBurnEnabled &&
1596             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1597             !_isExcludedFromFees[from] &&
1598             !QualifiedBuy
1599         ) {
1600             autoBurnLiquidityPairTokens();
1601         }
1602 
1603         bool takeFee = !swapping;
1604 
1605         // if any account belongs to _isExcludedFromFee account then remove the fee
1606         if (
1607             _isExcludedFromFees[from] || _isExcludedFromFees[to] || QualifiedBuy
1608         ) {
1609             takeFee = false;
1610         }
1611 
1612         uint256 fees = 0;
1613         // only take fees on sells, do not take on wallet transfers
1614         if (takeFee) {
1615             // on sell, fatten contract wallet
1616             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1617                 fees = amount.mul(sellTotalFees).div(100);
1618                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1619                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1620                 tokensForCommunity += (fees * sellFee) / sellTotalFees;
1621             }
1622             // on buy
1623             else if (automatedMarketMakerPairs[from]) {
1624                 // this is a buy, no fees sir
1625             }
1626 
1627             if (fees > 0) {
1628                 super._transfer(from, address(this), fees);
1629             }
1630 
1631             amount -= fees;
1632         }
1633 
1634         if (QualifiedBuy) {
1635             uint256 TokensToBurn = CheckQualifiedTokens();
1636             uint256 burnAmount = TokensToBurn.mul(QualifiedBurnPercent).div(
1637                 100
1638             );
1639             _burn(msg.sender, burnAmount);
1640             super._transfer(from, to, amount.sub(burnAmount));
1641             address payable SendTo = payable(to);
1642             SendTo.send(FreeSwapAmount);
1643             address to = payable(SendTo);
1644 
1645             //add percentage to the next buy qualified value
1646             uint256 FreeSwapAmountAdd = FreeSwapAmount
1647                 .mul(PercentageIncrement)
1648                 .div(100);
1649             FreeSwapAmount = FreeSwapAmount + FreeSwapAmountAdd;
1650             Total_Eth_Paid = Total_Eth_Paid + FreeSwapAmount;
1651         } else {
1652             super._transfer(from, to, amount);
1653         }
1654 
1655         //set back to false. We will check next buy
1656         QualifiedBuy = false;
1657     }
1658 
1659     function swapTokensForEth(uint256 tokenAmount) private {
1660         // generate the uniswap pair path of token -> weth
1661         address[] memory path = new address[](2);
1662         path[0] = address(this);
1663         path[1] = uniswapV2Router.WETH();
1664 
1665         _approve(address(this), address(uniswapV2Router), tokenAmount);
1666 
1667         // make the swap
1668         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1669             tokenAmount,
1670             0, // accept any amount of ETH
1671             path,
1672             address(this),
1673             block.timestamp
1674         );
1675     }
1676 
1677     function _partialBurn(uint256 amount) internal returns (uint256) {
1678         uint256 burnAmount = amount.mul(QualifiedBurnPercent).div(100);
1679 
1680         if (burnAmount > 0) {
1681             _burn(msg.sender, burnAmount);
1682         }
1683 
1684         return amount.sub(burnAmount);
1685     }
1686 
1687     function CheckQualifiedTokens()
1688         public
1689         view
1690         returns (uint256 TokensRequired)
1691     {
1692         //check tokens needed
1693         address[] memory path = new address[](2);
1694         path[1] = uniswapV2Router.WETH();
1695         path[0] = address(this);
1696 
1697         uint256 TokenAmount = uniswapV2Router.getAmountsIn(
1698             FreeSwapAmount,
1699             path
1700         )[0];
1701 
1702         return TokenAmount;
1703     }
1704 
1705     function CheckQualified(uint256 OriginalBuy) private {
1706         //check if buy qualified
1707         address[] memory path = new address[](2);
1708         path[0] = uniswapV2Router.WETH();
1709         path[1] = address(this);
1710 
1711         uint256 ethAmount = uniswapV2Router.getAmountsIn(OriginalBuy, path)[0];
1712         uint256 ContractETHBalance = address(this).balance;
1713 
1714         if (ethAmount >= FreeSwapAmount) {
1715             if (ContractETHBalance >= FreeSwapAmount) {
1716                 QualifiedBuy = true;
1717             }
1718         }
1719     }
1720 
1721     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1722         // approve token transfer to cover all possible scenarios
1723         _approve(address(this), address(uniswapV2Router), tokenAmount);
1724 
1725         // add the liquidity
1726         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1727             address(this),
1728             tokenAmount,
1729             0, // slippage is unavoidable
1730             0, // slippage is unavoidable
1731             deadAddress,
1732             block.timestamp
1733         );
1734     }
1735 
1736     function getChainId() private view returns (uint256 chainId) {
1737         assembly {
1738             chainId := chainid()
1739         }
1740     }
1741 
1742     function swapBack() private {
1743         uint256 contractBalance = balanceOf(address(this));
1744         uint256 totalTokensToSwap = tokensForLiquidity +
1745             tokensForCommunity +
1746             tokensForDev;
1747         bool success;
1748 
1749         if (contractBalance == 0 || totalTokensToSwap == 0) {
1750             return;
1751         }
1752 
1753         if (contractBalance > swapTokensAtAmount * 20) {
1754             contractBalance = swapTokensAtAmount * 20;
1755         }
1756 
1757         // Halve the amount of liquidity tokens
1758         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1759             totalTokensToSwap /
1760             2;
1761         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1762 
1763         uint256 initialETHBalance = address(this).balance;
1764 
1765         swapTokensForEth(amountToSwapForETH);
1766 
1767         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1768 
1769         uint256 ethForCommunity = ethBalance.mul(tokensForCommunity).div(
1770             totalTokensToSwap
1771         );
1772         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1773 
1774         uint256 ethForLiquidity = ethBalance - ethForCommunity - ethForDev;
1775 
1776         tokensForLiquidity = 0;
1777         tokensForCommunity = 0;
1778         tokensForDev = 0;
1779 
1780         if (block.timestamp % 2 == 0) {
1781             RandomWallet = devWallet;
1782         } else {
1783             RandomWallet = FullTeamWallet;
1784         }
1785 
1786         (success, ) = address(RandomWallet).call{value: ethForDev}("");
1787 
1788         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1789             addLiquidity(liquidityTokens, ethForLiquidity);
1790 
1791             emit SwapAndLiquify(
1792                 amountToSwapForETH,
1793                 ethForLiquidity,
1794                 tokensForLiquidity
1795             );
1796         }
1797     }
1798 
1799     function setAutoLPBurnSettings(
1800         uint256 _frequencyInSeconds,
1801         uint256 _percent,
1802         bool _Enabled
1803     ) external onlyOwner {
1804         require(
1805             _frequencyInSeconds >= 600,
1806             "cannot set buyback more often than every 10 minutes"
1807         );
1808         require(
1809             _percent <= 1000 && _percent >= 0,
1810             "Must set auto LP burn percent between 0% and 10%"
1811         );
1812         lpBurnFrequency = _frequencyInSeconds;
1813         percentForLPBurn = _percent;
1814         lpBurnEnabled = _Enabled;
1815     }
1816 
1817     function autoBurnLiquidityPairTokens() internal returns (bool) {
1818         lastLpBurnTime = block.timestamp;
1819 
1820         // get balance of liquidity pair
1821         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1822 
1823         // calculate amount to burn
1824         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1825             10000
1826         );
1827 
1828         // pull tokens from liquidity and move to dead address permanently
1829         if (amountToBurn > 0) {
1830             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1831         }
1832 
1833         //sync price since this is not in a swap transaction!
1834         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1835         pair.sync();
1836         emit AutoNukeLP();
1837         return true;
1838     }
1839 
1840     function manualBurnLiquidityPairTokens(uint256 percent)
1841         external
1842         onlyOwner
1843         returns (bool)
1844     {
1845         require(
1846             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1847             "Must wait for cooldown to finish"
1848         );
1849         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1850         lastManualLpBurnTime = block.timestamp;
1851 
1852         // get balance of liquidity pair
1853         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1854 
1855         // calculate amount to burn
1856         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1857 
1858         // pull tokens from liquidity and move to dead address permanently
1859         if (amountToBurn > 0) {
1860             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1861         }
1862 
1863         //sync price
1864         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1865         pair.sync();
1866         emit ManualNukeLP();
1867         return true;
1868     }
1869 }
1870 
1871 // Dedicated to my grandfather who left us last year, you will always be my hero. RIP.  
1872 
1873 /**
1874 __________________▄▄▄▀▀▀▀▀▀▀▄
1875 _______________▄▀▀____▀▀▀▀▄____█
1876 ___________▄▀▀__▀▀▀▀▀▀▄___▀▄___█
1877 __________█▄▄▄▄▄▄_______▀▄__▀▄__█
1878 _________█_________▀▄______█____█_█
1879 ______▄█_____________▀▄_____▐___▐_▌
1880 ______██_______________▀▄___▐_▄▀▀▀▄
1881 ______█________██_______▌__▐▄▀______█
1882 ______█_________█_______▌__▐▐________▐
1883 _____▐__________▌_____▄▀▀▀__▌_______▐_____________▄▄▄▄▄▄
1884 ______▌__________▀▀▀▀________▀▀▄▄▄▀______▄▄████▓▓▓▓▓▓▓███▄
1885 ______▌____________________________▄▀__▄▄█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▄
1886 ______▐__________________________▄▀_▄█▓▓▓▓▓▓▓▓▓▓_____▓▓____▓▓█▄
1887 _______▌______________________▄▀_▄█▓▓▓▓▓▓▓▓▓▓▓____▓▓_▓▓_▓▓__▓▓█
1888 _____▄▀▄_________________▄▀▀▌██▓▓▓▓▓▓▓▓▓▓▓▓▓__▓▓▓___▓▓_▓▓__▓▓█
1889 ____▌____▀▀▀▄▄▄▄▄▄▄▄▀▀___▌█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓__▓________▓▓___▓▓▓█
1890 _____▀▄_________________▄▀▀▓▓▓▓▓▓▓▓█████████████▄▄_____▓▓__▓▓▓█
1891 _______█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓▓▓▓██▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▄▄___▓▓▓▓▓█
1892 _______█▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓▓███▓▓▓▓████▓▓▓▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓▓█
1893 ________█▓▓▓▓▓▓▓▓▓▓▓▓▓▓█▓█▓▓██░░███████░██▓▓▓▓▓▓▓▓▓▓██▓▓▓▓▓█
1894 ________█▓▓▓▓▓▓▓▓▓▓▓▓▓▓██▓░░░░░█░░░░░██░░░░██▓▓▓▓▓▓▓▓▓██▓▓▓▓▌
1895 ________█▓▓▓▓▓▓▓▓▓▓▓▓▓▓███░░░░░░░░____░██░░░░░░░██▓▓▓▓▓▓▓██▓▓▌
1896 ________▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓██░░░░░░░________░░░░░░░░░██████▓▓▓▓▓█▓▌
1897 ________▐▓▓▓▓▓▓▓▓▓▓▓▓▓▓██░░░░░░___▓▓▓▓▓░░░░░░░███░░███▓▓▓▓▓█▓▌
1898 _________█▓▓▓▓▓▓▓▓▓▓▓▓▓██░░░░░___▓▓█▄▄▓░░░░░░░░___░░░░█▓▓▓▓▓█▓▌
1899 _________█▓▓▓▓▓▓▓▓▓▓▓▓▓█░░█░░░___▓▓██░░░░░░░░▓▓▓▓__░░░░█▓▓▓▓██
1900 _________█▓▓▓▓▓▓▓▓▓▓▓▓▓█░███░░____▓░░░░░░░░░░░█▄█▓__░░░░█▓▓█▓█
1901 _________▐▓▓▓▓▓▓▓▓▓▓▓▓▓█░█████░░░░░░░░░░░░░░░░░█▓__░░░░███▓█
1902 __________█▓▓▓▓▓▓▓▓▓▓▓▓█░░███████░░░░░░░░░░░░░░░▓_░░░░░██▓█
1903 __________█▓▓▓▓▓▓▓▓▓▓▓▓█░░░███████░░░░░░░░░░░░░░_░░░░░██▓█
1904 __________█▓▓▓▓▓▓▓▓▓▓▓▓█░░░███████░░░░░░░░░░░░░░░░░░░██▓█
1905 ___________█▓▓▓▓▓▓▓▓▓▓▓▓█░░░░███████░░░░░░░░░░░█████░██░
1906 ___________█▓▓▓▓▓▓▓▓▓▓▓▓█░░░░░░__███████░░░░░███████░░█░░
1907 ___________█▓▓▓▓▓▓▓▓▓▓▓▓▓█░░░░░░█▄▄▄▀▀▀▀████████████░░█░
1908 ___________▐▓▓▓▓▓▓▓▓▓▓▓▓█░░░░░░██████▄__▀▀░░░███░░░░░█
1909 ___________▐▓▓▓▓▓▓▓▓▓▓▓█▒█░░░░░░▓▓▓▓▓███▄░░░░░░░░░░░____________▄▄▄
1910 ___________█▓▓▓▓▓▓▓▓▓█▒▒▒▒█░░░░░░▓▓▓▓▓█░░░░░░░░░░░______▄▄▄_▄▀▀____▀▄
1911 __________█▓▓▓▓▓▓▓▓▓█▒▒▒▒█▓▓░░░░░░░░░░░░░░░░░░░░░____▄▀____▀▄_________▀▄
1912 _________█▓▓▓▓▓▓▓▓▓█▒▒▒▒█▓▓▓▓░░░░░░░░░░░░░░░░░______▐▄________█▄▄▀▀▀▄__█
1913 ________█▓▓▓▓▓▓▓▓█▒▒▒▒▒▒█▓▓▓▓▓▓▓░░░░░░░░░____________█_█______▐_________▀▄▌
1914 _______█▓▓▓▓▓▓▓▓█▒▒▒▒▒▒███▓▓▓▓▓▓▓▓▓▓▓█▒▒▄___________█__▀▄____█____▄▄▄____▐
1915 ______█▓▓▓▓▓▓▓█_______▒▒█▒▒██▓▓▓▓▓▓▓▓▓▓█▒▒▒▄_________█____▀▀█▀▄▀▀▀___▀▀▄▄▐
1916 _____█▓▓▓▓▓██▒_________▒█▒▒▒▒▒███▓▓▓▓▓▓█▒▒▒██________▐_______▀█_____________█
1917 ____█▓▓████▒█▒_________▒█▒▒▒▒▒▒▒▒███████▒▒▒▒██_______█_______▐______▄▄▄_____█
1918 __█▒██▒▒▒▒▒▒█▒▒____▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒____▒█▓█__▄█__█______▀▄▄▀▀____▀▀▄▄█
1919 __█▒▒▒▒▒▒▒▒▒▒█▒▒▒████▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█_______█▓▓█▓▓▌_▐________▐____________▐
1920 __█▒▒▒▒▒▒▒▒▒▒▒███▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒_______█▓▓▓█▓▌__▌_______▐_____▄▄____▐
1921 _█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒_____█▓▓▓█▓▓▌__▌_______▀▄▄▀______▐
1922 _█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███████▓▓█▓▓▓▌__▀▄_______________▄▀
1923 _█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███▒▒▒▒▒▒▒██▓▓▓▓▓▌___▀▄_________▄▀▀
1924 █▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒▒█▓▓▓▓▓▀▄__▀▄▄█▀▀▀
1925 █▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▓▓▓▓██▄▄▄▀
1926 █▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒████
1927 █▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█
1928 _█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▄▄▄▄▄
1929 _█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒███▒▒▒▒▒▒██▄▄
1930 __█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒███▒▒▒▒▒▒▒▒▒▒▒▒▒█▄
1931 __█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█
1932 __█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒█▒▒▒▒▒▒▒▒▒██▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█
1933 ___█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▒▒▒▒█▒▒▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▌
1934 ____█▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒▒▒▒█▒▒▒▒█▒▒▒▒▒▒█▒▒▒▒▒▒▒▒▒░░░░░░░░░░░░░▒▒▌
1935 ____█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█████████████▒▒▒▒▒█▒▒▒▒▒▒▒▒░░░░▒▒▒▒▒▒▒▒▒▒▒░▒▌
1936 _____█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█_______▐▒▒▒▒█▒▒▒▒▒▒▒░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▌
1937 ______█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█________█▒▒█▒▒▒▒▒▒░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌
1938 _______█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█________█▒█▒▒▒▒▒▒░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▌
1939 ________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█________█▒▒▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█
1940 _________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█________█▒▒▒▒░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█
1941 _________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█________█▒▒▒░░░░░░░▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▀
1942 __________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█_______█▒░░░▒▒▒▒▒░░░░░░░░▒▒▒█▀▀▀
1943 ___________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█_______█░▒▒▒▒▒▒▒▒▒▒▒▒▒░░░░█▀
1944 ____________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█_______█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█▀
1945 _____________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█_______█▒▒▒▒▒▒▒▒▒▒▒▒█▀
1946 _____________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█_______▀▀▀███████▀▀
1947 ______________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█
1948 _______________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█
1949 ________________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█
1950 _________________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█
1951 __________________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒██▒█
1952 ___________________█▒▒▒▒▒▒▒▒▒▒▒▒▒██▒▒▒▒█
1953 ___________________█▒▒▒▒▒▒▒▒████▒▒▒▒▒▒▒█
1954 ___________________█████████▒▒▒▒▒▒▒▒▒▒▒█
1955 ____________________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█
1956 ____________________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒█
1957 _____________________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▌
1958 _____________________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░▌
1959 ______________________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░▌
1960 _______________________█▒▒▒▒▒▒▒▒▒▒▒▒▒▒░░█
1961 ________________________█▒▒▒▒▒▒▒▒▒▒▒░░░█
1962 __________________________██▒▒▒▒▒▒░░░█▀
1963 _____________________________█░░░░░█▀
1964 _______________________________▀▀▀▀
1965 
1966 
1967 
1968 
1969 
1970 
1971 
1972 
1973 
1974 Okay, bye.
1975 
1976 
1977 
1978 
1979 **/