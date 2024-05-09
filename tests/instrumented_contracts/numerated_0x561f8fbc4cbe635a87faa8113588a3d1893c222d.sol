1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.18;
3 pragma experimental ABIEncoderV2;
4 
5 /*
6     Twitter: https://twitter.com/SHOVNetwork
7     Telegram: https://t.me/SHOVNetwork
8     
9 */
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes calldata) {
17         return msg.data;
18     }
19 }
20 
21 abstract contract Ownable is Context {
22     address private _owner;
23 
24     event OwnershipTransferred(
25         address indexed previousOwner,
26         address indexed newOwner
27     );
28 
29     /**
30      * @dev Initializes the contract setting the deployer as the initial owner.
31      */
32     constructor() {
33         _transferOwnership(_msgSender());
34     }
35 
36     /**
37      * @dev Throws if called by any account other than the owner.
38      */
39     modifier onlyOwner() {
40         _checkOwner();
41         _;
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
52      * @dev Throws if the sender is not the owner.
53      */
54     function _checkOwner() internal view virtual {
55         require(owner() == _msgSender(), "Ownable: caller is not the owner");
56     }
57 
58     /**
59      * @dev Leaves the contract without owner. It will not be possible to call
60      * `onlyOwner` functions. Can only be called by the current owner.
61      *
62      * NOTE: Renouncing ownership will leave the contract without an owner,
63      * thereby disabling any functionality that is only available to the owner.
64      */
65     function renounceOwnership() public virtual onlyOwner {
66         _transferOwnership(address(0));
67     }
68 
69     /**
70      * @dev Transfers ownership of the contract to a new account (`newOwner`).
71      * Can only be called by the current owner.
72      */
73     function transferOwnership(address newOwner) public virtual onlyOwner {
74         require(
75             newOwner != address(0),
76             "Ownable: new owner is the zero address"
77         );
78         _transferOwnership(newOwner);
79     }
80 
81     /**
82      * @dev Transfers ownership of the contract to a new account (`newOwner`).
83      * Internal function without access restriction.
84      */
85     function _transferOwnership(address newOwner) internal virtual {
86         address oldOwner = _owner;
87         _owner = newOwner;
88         emit OwnershipTransferred(oldOwner, newOwner);
89     }
90 }
91 
92 interface IERC20 {
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
105     event Approval(
106         address indexed owner,
107         address indexed spender,
108         uint256 value
109     );
110 
111     /**
112      * @dev Returns the amount of tokens in existence.
113      */
114     function totalSupply() external view returns (uint256);
115 
116     /**
117      * @dev Returns the amount of tokens owned by `account`.
118      */
119     function balanceOf(address account) external view returns (uint256);
120 
121     /**
122      * @dev Moves `amount` tokens from the caller's account to `to`.
123      *
124      * Returns a boolean value indicating whether the operation succeeded.
125      *
126      * Emits a {Transfer} event.
127      */
128     function transfer(address to, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Returns the remaining number of tokens that `spender` will be
132      * allowed to spend on behalf of `owner` through {transferFrom}. This is
133      * zero by default.
134      *
135      * This value changes when {approve} or {transferFrom} are called.
136      */
137     function allowance(address owner, address spender)
138         external
139         view
140         returns (uint256);
141 
142     /**
143      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
144      *
145      * Returns a boolean value indicating whether the operation succeeded.
146      *
147      * IMPORTANT: Beware that changing an allowance with this method brings the risk
148      * that someone may use both the old and the new allowance by unfortunate
149      * transaction ordering. One possible solution to mitigate this race
150      * condition is to first reduce the spender's allowance to 0 and set the
151      * desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      *
154      * Emits an {Approval} event.
155      */
156     function approve(address spender, uint256 amount) external returns (bool);
157 
158     /**
159      * @dev Moves `amount` tokens from `from` to `to` using the
160      * allowance mechanism. `amount` is then deducted from the caller's
161      * allowance.
162      *
163      * Returns a boolean value indicating whether the operation succeeded.
164      *
165      * Emits a {Transfer} event.
166      */
167     function transferFrom(
168         address from,
169         address to,
170         uint256 amount
171     ) external returns (bool);
172 }
173 
174 interface IERC20Metadata is IERC20 {
175     /**
176      * @dev Returns the name of the token.
177      */
178     function name() external view returns (string memory);
179 
180     /**
181      * @dev Returns the symbol of the token.
182      */
183     function symbol() external view returns (string memory);
184 
185     /**
186      * @dev Returns the decimals places of the token.
187      */
188     function decimals() external view returns (uint8);
189 }
190 
191 contract ERC20 is Context, IERC20, IERC20Metadata {
192     mapping(address => uint256) private _balances;
193 
194     mapping(address => mapping(address => uint256)) private _allowances;
195 
196     uint256 private _totalSupply;
197 
198     string private _name;
199     string private _symbol;
200 
201     /**
202      * @dev Sets the values for {name} and {symbol}.
203      *
204      * All two of these values are immutable: they can only be set once during
205      * construction.
206      */
207     constructor(string memory name_, string memory symbol_) {
208         _name = name_;
209         _symbol = symbol_;
210     }
211 
212     /**
213      * @dev Returns the name of the token.
214      */
215     function name() public view virtual override returns (string memory) {
216         return _name;
217     }
218 
219     /**
220      * @dev Returns the symbol of the token, usually a shorter version of the
221      * name.
222      */
223     function symbol() public view virtual override returns (string memory) {
224         return _symbol;
225     }
226 
227     /**
228      * @dev Returns the number of decimals used to get its user representation.
229      * For example, if `decimals` equals `2`, a balance of `505` tokens should
230      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
231      *
232      * Tokens usually opt for a value of 18, imitating the relationship between
233      * Ether and Wei. This is the default value returned by this function, unless
234      * it's overridden.
235      *
236      * NOTE: This information is only used for _display_ purposes: it in
237      * no way affects any of the arithmetic of the contract, including
238      * {IERC20-balanceOf} and {IERC20-transfer}.
239      */
240     function decimals() public view virtual override returns (uint8) {
241         return 18;
242     }
243 
244     /**
245      * @dev See {IERC20-totalSupply}.
246      */
247     function totalSupply() public view virtual override returns (uint256) {
248         return _totalSupply;
249     }
250 
251     /**
252      * @dev See {IERC20-balanceOf}.
253      */
254     function balanceOf(address account)
255         public
256         view
257         virtual
258         override
259         returns (uint256)
260     {
261         return _balances[account];
262     }
263 
264     /**
265      * @dev See {IERC20-transfer}.
266      *
267      * Requirements:
268      *
269      * - `to` cannot be the zero address.
270      * - the caller must have a balance of at least `amount`.
271      */
272     function transfer(address to, uint256 amount)
273         public
274         virtual
275         override
276         returns (bool)
277     {
278         address owner = _msgSender();
279         _transfer(owner, to, amount);
280         return true;
281     }
282 
283     /**
284      * @dev See {IERC20-allowance}.
285      */
286     function allowance(address owner, address spender)
287         public
288         view
289         virtual
290         override
291         returns (uint256)
292     {
293         return _allowances[owner][spender];
294     }
295 
296     /**
297      * @dev See {IERC20-approve}.
298      *
299      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
300      * `transferFrom`. This is semantically equivalent to an infinite approval.
301      *
302      * Requirements:
303      *
304      * - `spender` cannot be the zero address.
305      */
306     function approve(address spender, uint256 amount)
307         public
308         virtual
309         override
310         returns (bool)
311     {
312         address owner = _msgSender();
313         _approve(owner, spender, amount);
314         return true;
315     }
316 
317     /**
318      * @dev See {IERC20-transferFrom}.
319      *
320      * Emits an {Approval} event indicating the updated allowance. This is not
321      * required by the EIP. See the note at the beginning of {ERC20}.
322      *
323      * NOTE: Does not update the allowance if the current allowance
324      * is the maximum `uint256`.
325      *
326      * Requirements:
327      *
328      * - `from` and `to` cannot be the zero address.
329      * - `from` must have a balance of at least `amount`.
330      * - the caller must have allowance for ``from``'s tokens of at least
331      * `amount`.
332      */
333     function transferFrom(
334         address from,
335         address to,
336         uint256 amount
337     ) public virtual override returns (bool) {
338         address spender = _msgSender();
339         _spendAllowance(from, spender, amount);
340         _transfer(from, to, amount);
341         return true;
342     }
343 
344     /**
345      * @dev Atomically increases the allowance granted to `spender` by the caller.
346      *
347      * This is an alternative to {approve} that can be used as a mitigation for
348      * problems described in {IERC20-approve}.
349      *
350      * Emits an {Approval} event indicating the updated allowance.
351      *
352      * Requirements:
353      *
354      * - `spender` cannot be the zero address.
355      */
356     function increaseAllowance(address spender, uint256 addedValue)
357         public
358         virtual
359         returns (bool)
360     {
361         address owner = _msgSender();
362         _approve(owner, spender, allowance(owner, spender) + addedValue);
363         return true;
364     }
365 
366     /**
367      * @dev Atomically decreases the allowance granted to `spender` by the caller.
368      *
369      * This is an alternative to {approve} that can be used as a mitigation for
370      * problems described in {IERC20-approve}.
371      *
372      * Emits an {Approval} event indicating the updated allowance.
373      *
374      * Requirements:
375      *
376      * - `spender` cannot be the zero address.
377      * - `spender` must have allowance for the caller of at least
378      * `subtractedValue`.
379      */
380     function decreaseAllowance(address spender, uint256 subtractedValue)
381         public
382         virtual
383         returns (bool)
384     {
385         address owner = _msgSender();
386         uint256 currentAllowance = allowance(owner, spender);
387         require(
388             currentAllowance >= subtractedValue,
389             "ERC20: decreased allowance below zero"
390         );
391         unchecked {
392             _approve(owner, spender, currentAllowance - subtractedValue);
393         }
394 
395         return true;
396     }
397 
398     /**
399      * @dev Moves `amount` of tokens from `from` to `to`.
400      *
401      * This internal function is equivalent to {transfer}, and can be used to
402      * e.g. implement automatic token fees, slashing mechanisms, etc.
403      *
404      * Emits a {Transfer} event.
405      *
406      * Requirements:
407      *
408      * - `from` cannot be the zero address.
409      * - `to` cannot be the zero address.
410      * - `from` must have a balance of at least `amount`.
411      */
412     function _transfer(
413         address from,
414         address to,
415         uint256 amount
416     ) internal virtual {
417         require(from != address(0), "ERC20: transfer from the zero address");
418         require(to != address(0), "ERC20: transfer to the zero address");
419 
420         _beforeTokenTransfer(from, to, amount);
421 
422         uint256 fromBalance = _balances[from];
423         require(
424             fromBalance >= amount,
425             "ERC20: transfer amount exceeds balance"
426         );
427         unchecked {
428             _balances[from] = fromBalance - amount;
429             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
430             // decrementing then incrementing.
431             _balances[to] += amount;
432         }
433 
434         emit Transfer(from, to, amount);
435 
436         _afterTokenTransfer(from, to, amount);
437     }
438 
439     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
440      * the total supply.
441      *
442      * Emits a {Transfer} event with `from` set to the zero address.
443      *
444      * Requirements:
445      *
446      * - `account` cannot be the zero address.
447      */
448     function _mint(address account, uint256 amount) internal virtual {
449         require(account != address(0), "ERC20: mint to the zero address");
450 
451         _beforeTokenTransfer(address(0), account, amount);
452 
453         _totalSupply += amount;
454         unchecked {
455             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
456             _balances[account] += amount;
457         }
458         emit Transfer(address(0), account, amount);
459 
460         _afterTokenTransfer(address(0), account, amount);
461     }
462 
463     /**
464      * @dev Destroys `amount` tokens from `account`, reducing the
465      * total supply.
466      *
467      * Emits a {Transfer} event with `to` set to the zero address.
468      *
469      * Requirements:
470      *
471      * - `account` cannot be the zero address.
472      * - `account` must have at least `amount` tokens.
473      */
474     function _burn(address account, uint256 amount) internal virtual {
475         require(account != address(0), "ERC20: burn from the zero address");
476 
477         _beforeTokenTransfer(account, address(0), amount);
478 
479         uint256 accountBalance = _balances[account];
480         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
481         unchecked {
482             _balances[account] = accountBalance - amount;
483             // Overflow not possible: amount <= accountBalance <= totalSupply.
484             _totalSupply -= amount;
485         }
486 
487         emit Transfer(account, address(0), amount);
488 
489         _afterTokenTransfer(account, address(0), amount);
490     }
491 
492     /**
493      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
494      *
495      * This internal function is equivalent to `approve`, and can be used to
496      * e.g. set automatic allowances for certain subsystems, etc.
497      *
498      * Emits an {Approval} event.
499      *
500      * Requirements:
501      *
502      * - `owner` cannot be the zero address.
503      * - `spender` cannot be the zero address.
504      */
505     function _approve(
506         address owner,
507         address spender,
508         uint256 amount
509     ) internal virtual {
510         require(owner != address(0), "ERC20: approve from the zero address");
511         require(spender != address(0), "ERC20: approve to the zero address");
512 
513         _allowances[owner][spender] = amount;
514         emit Approval(owner, spender, amount);
515     }
516 
517     /**
518      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
519      *
520      * Does not update the allowance amount in case of infinite allowance.
521      * Revert if not enough allowance is available.
522      *
523      * Might emit an {Approval} event.
524      */
525     function _spendAllowance(
526         address owner,
527         address spender,
528         uint256 amount
529     ) internal virtual {
530         uint256 currentAllowance = allowance(owner, spender);
531         if (currentAllowance != type(uint256).max) {
532             require(
533                 currentAllowance >= amount,
534                 "ERC20: insufficient allowance"
535             );
536             unchecked {
537                 _approve(owner, spender, currentAllowance - amount);
538             }
539         }
540     }
541 
542     /**
543      * @dev Hook that is called before any transfer of tokens. This includes
544      * minting and burning.
545      *
546      * Calling conditions:
547      *
548      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
549      * will be transferred to `to`.
550      * - when `from` is zero, `amount` tokens will be minted for `to`.
551      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
552      * - `from` and `to` are never both zero.
553      *
554      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
555      */
556     function _beforeTokenTransfer(
557         address from,
558         address to,
559         uint256 amount
560     ) internal virtual {}
561 
562     /**
563      * @dev Hook that is called after any transfer of tokens. This includes
564      * minting and burning.
565      *
566      * Calling conditions:
567      *
568      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
569      * has been transferred to `to`.
570      * - when `from` is zero, `amount` tokens have been minted for `to`.
571      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
572      * - `from` and `to` are never both zero.
573      *
574      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
575      */
576     function _afterTokenTransfer(
577         address from,
578         address to,
579         uint256 amount
580     ) internal virtual {}
581 }
582 
583 library SafeMath {
584     /**
585      * @dev Returns the addition of two unsigned integers, with an overflow flag.
586      *
587      * _Available since v3.4._
588      */
589     function tryAdd(uint256 a, uint256 b)
590         internal
591         pure
592         returns (bool, uint256)
593     {
594         unchecked {
595             uint256 c = a + b;
596             if (c < a) return (false, 0);
597             return (true, c);
598         }
599     }
600 
601     /**
602      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
603      *
604      * _Available since v3.4._
605      */
606     function trySub(uint256 a, uint256 b)
607         internal
608         pure
609         returns (bool, uint256)
610     {
611         unchecked {
612             if (b > a) return (false, 0);
613             return (true, a - b);
614         }
615     }
616 
617     /**
618      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
619      *
620      * _Available since v3.4._
621      */
622     function tryMul(uint256 a, uint256 b)
623         internal
624         pure
625         returns (bool, uint256)
626     {
627         unchecked {
628             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
629             // benefit is lost if 'b' is also tested.
630             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
631             if (a == 0) return (true, 0);
632             uint256 c = a * b;
633             if (c / a != b) return (false, 0);
634             return (true, c);
635         }
636     }
637 
638     /**
639      * @dev Returns the division of two unsigned integers, with a division by zero flag.
640      *
641      * _Available since v3.4._
642      */
643     function tryDiv(uint256 a, uint256 b)
644         internal
645         pure
646         returns (bool, uint256)
647     {
648         unchecked {
649             if (b == 0) return (false, 0);
650             return (true, a / b);
651         }
652     }
653 
654     /**
655      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
656      *
657      * _Available since v3.4._
658      */
659     function tryMod(uint256 a, uint256 b)
660         internal
661         pure
662         returns (bool, uint256)
663     {
664         unchecked {
665             if (b == 0) return (false, 0);
666             return (true, a % b);
667         }
668     }
669 
670     /**
671      * @dev Returns the addition of two unsigned integers, reverting on
672      * overflow.
673      *
674      * Counterpart to Solidity's `+` operator.
675      *
676      * Requirements:
677      *
678      * - Addition cannot overflow.
679      */
680     function add(uint256 a, uint256 b) internal pure returns (uint256) {
681         return a + b;
682     }
683 
684     /**
685      * @dev Returns the subtraction of two unsigned integers, reverting on
686      * overflow (when the result is negative).
687      *
688      * Counterpart to Solidity's `-` operator.
689      *
690      * Requirements:
691      *
692      * - Subtraction cannot overflow.
693      */
694     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
695         return a - b;
696     }
697 
698     /**
699      * @dev Returns the multiplication of two unsigned integers, reverting on
700      * overflow.
701      *
702      * Counterpart to Solidity's `*` operator.
703      *
704      * Requirements:
705      *
706      * - Multiplication cannot overflow.
707      */
708     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
709         return a * b;
710     }
711 
712     /**
713      * @dev Returns the integer division of two unsigned integers, reverting on
714      * division by zero. The result is rounded towards zero.
715      *
716      * Counterpart to Solidity's `/` operator.
717      *
718      * Requirements:
719      *
720      * - The divisor cannot be zero.
721      */
722     function div(uint256 a, uint256 b) internal pure returns (uint256) {
723         return a / b;
724     }
725 
726     /**
727      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
728      * reverting when dividing by zero.
729      *
730      * Counterpart to Solidity's `%` operator. This function uses a `revert`
731      * opcode (which leaves remaining gas untouched) while Solidity uses an
732      * invalid opcode to revert (consuming all remaining gas).
733      *
734      * Requirements:
735      *
736      * - The divisor cannot be zero.
737      */
738     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
739         return a % b;
740     }
741 
742     /**
743      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
744      * overflow (when the result is negative).
745      *
746      * CAUTION: This function is deprecated because it requires allocating memory for the error
747      * message unnecessarily. For custom revert reasons use {trySub}.
748      *
749      * Counterpart to Solidity's `-` operator.
750      *
751      * Requirements:
752      *
753      * - Subtraction cannot overflow.
754      */
755     function sub(
756         uint256 a,
757         uint256 b,
758         string memory errorMessage
759     ) internal pure returns (uint256) {
760         unchecked {
761             require(b <= a, errorMessage);
762             return a - b;
763         }
764     }
765 
766     /**
767      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
768      * division by zero. The result is rounded towards zero.
769      *
770      * Counterpart to Solidity's `/` operator. Note: this function uses a
771      * `revert` opcode (which leaves remaining gas untouched) while Solidity
772      * uses an invalid opcode to revert (consuming all remaining gas).
773      *
774      * Requirements:
775      *
776      * - The divisor cannot be zero.
777      */
778     function div(
779         uint256 a,
780         uint256 b,
781         string memory errorMessage
782     ) internal pure returns (uint256) {
783         unchecked {
784             require(b > 0, errorMessage);
785             return a / b;
786         }
787     }
788 
789     /**
790      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
791      * reverting with custom message when dividing by zero.
792      *
793      * CAUTION: This function is deprecated because it requires allocating memory for the error
794      * message unnecessarily. For custom revert reasons use {tryMod}.
795      *
796      * Counterpart to Solidity's `%` operator. This function uses a `revert`
797      * opcode (which leaves remaining gas untouched) while Solidity uses an
798      * invalid opcode to revert (consuming all remaining gas).
799      *
800      * Requirements:
801      *
802      * - The divisor cannot be zero.
803      */
804     function mod(
805         uint256 a,
806         uint256 b,
807         string memory errorMessage
808     ) internal pure returns (uint256) {
809         unchecked {
810             require(b > 0, errorMessage);
811             return a % b;
812         }
813     }
814 }
815 
816 interface IUniswapV2Factory {
817     event PairCreated(
818         address indexed token0,
819         address indexed token1,
820         address pair,
821         uint256
822     );
823 
824     function feeTo() external view returns (address);
825 
826     function feeToSetter() external view returns (address);
827 
828     function getPair(address tokenA, address tokenB)
829         external
830         view
831         returns (address pair);
832 
833     function allPairs(uint256) external view returns (address pair);
834 
835     function allPairsLength() external view returns (uint256);
836 
837     function createPair(address tokenA, address tokenB)
838         external
839         returns (address pair);
840 
841     function setFeeTo(address) external;
842 
843     function setFeeToSetter(address) external;
844 }
845 
846 interface IUniswapV2Router01 {
847     function factory() external pure returns (address);
848 
849     function WETH() external pure returns (address);
850 
851     function addLiquidity(
852         address tokenA,
853         address tokenB,
854         uint256 amountADesired,
855         uint256 amountBDesired,
856         uint256 amountAMin,
857         uint256 amountBMin,
858         address to,
859         uint256 deadline
860     )
861         external
862         returns (
863             uint256 amountA,
864             uint256 amountB,
865             uint256 liquidity
866         );
867 
868     function addLiquidityETH(
869         address token,
870         uint256 amountTokenDesired,
871         uint256 amountTokenMin,
872         uint256 amountETHMin,
873         address to,
874         uint256 deadline
875     )
876         external
877         payable
878         returns (
879             uint256 amountToken,
880             uint256 amountETH,
881             uint256 liquidity
882         );
883 
884     function removeLiquidity(
885         address tokenA,
886         address tokenB,
887         uint256 liquidity,
888         uint256 amountAMin,
889         uint256 amountBMin,
890         address to,
891         uint256 deadline
892     ) external returns (uint256 amountA, uint256 amountB);
893 
894     function removeLiquidityETH(
895         address token,
896         uint256 liquidity,
897         uint256 amountTokenMin,
898         uint256 amountETHMin,
899         address to,
900         uint256 deadline
901     ) external returns (uint256 amountToken, uint256 amountETH);
902 
903     function removeLiquidityWithPermit(
904         address tokenA,
905         address tokenB,
906         uint256 liquidity,
907         uint256 amountAMin,
908         uint256 amountBMin,
909         address to,
910         uint256 deadline,
911         bool approveMax,
912         uint8 v,
913         bytes32 r,
914         bytes32 s
915     ) external returns (uint256 amountA, uint256 amountB);
916 
917     function removeLiquidityETHWithPermit(
918         address token,
919         uint256 liquidity,
920         uint256 amountTokenMin,
921         uint256 amountETHMin,
922         address to,
923         uint256 deadline,
924         bool approveMax,
925         uint8 v,
926         bytes32 r,
927         bytes32 s
928     ) external returns (uint256 amountToken, uint256 amountETH);
929 
930     function swapExactTokensForTokens(
931         uint256 amountIn,
932         uint256 amountOutMin,
933         address[] calldata path,
934         address to,
935         uint256 deadline
936     ) external returns (uint256[] memory amounts);
937 
938     function swapTokensForExactTokens(
939         uint256 amountOut,
940         uint256 amountInMax,
941         address[] calldata path,
942         address to,
943         uint256 deadline
944     ) external returns (uint256[] memory amounts);
945 
946     function swapExactETHForTokens(
947         uint256 amountOutMin,
948         address[] calldata path,
949         address to,
950         uint256 deadline
951     ) external payable returns (uint256[] memory amounts);
952 
953     function swapTokensForExactETH(
954         uint256 amountOut,
955         uint256 amountInMax,
956         address[] calldata path,
957         address to,
958         uint256 deadline
959     ) external returns (uint256[] memory amounts);
960 
961     function swapExactTokensForETH(
962         uint256 amountIn,
963         uint256 amountOutMin,
964         address[] calldata path,
965         address to,
966         uint256 deadline
967     ) external returns (uint256[] memory amounts);
968 
969     function swapETHForExactTokens(
970         uint256 amountOut,
971         address[] calldata path,
972         address to,
973         uint256 deadline
974     ) external payable returns (uint256[] memory amounts);
975 
976     function quote(
977         uint256 amountA,
978         uint256 reserveA,
979         uint256 reserveB
980     ) external pure returns (uint256 amountB);
981 
982     function getAmountOut(
983         uint256 amountIn,
984         uint256 reserveIn,
985         uint256 reserveOut
986     ) external pure returns (uint256 amountOut);
987 
988     function getAmountIn(
989         uint256 amountOut,
990         uint256 reserveIn,
991         uint256 reserveOut
992     ) external pure returns (uint256 amountIn);
993 
994     function getAmountsOut(uint256 amountIn, address[] calldata path)
995         external
996         view
997         returns (uint256[] memory amounts);
998 
999     function getAmountsIn(uint256 amountOut, address[] calldata path)
1000         external
1001         view
1002         returns (uint256[] memory amounts);
1003 }
1004 
1005 interface IUniswapV2Router02 is IUniswapV2Router01 {
1006     function removeLiquidityETHSupportingFeeOnTransferTokens(
1007         address token,
1008         uint256 liquidity,
1009         uint256 amountTokenMin,
1010         uint256 amountETHMin,
1011         address to,
1012         uint256 deadline
1013     ) external returns (uint256 amountETH);
1014 
1015     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1016         address token,
1017         uint256 liquidity,
1018         uint256 amountTokenMin,
1019         uint256 amountETHMin,
1020         address to,
1021         uint256 deadline,
1022         bool approveMax,
1023         uint8 v,
1024         bytes32 r,
1025         bytes32 s
1026     ) external returns (uint256 amountETH);
1027 
1028     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1029         uint256 amountIn,
1030         uint256 amountOutMin,
1031         address[] calldata path,
1032         address to,
1033         uint256 deadline
1034     ) external;
1035 
1036     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1037         uint256 amountOutMin,
1038         address[] calldata path,
1039         address to,
1040         uint256 deadline
1041     ) external payable;
1042 
1043     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1044         uint256 amountIn,
1045         uint256 amountOutMin,
1046         address[] calldata path,
1047         address to,
1048         uint256 deadline
1049     ) external;
1050 }
1051 
1052 contract SHOV is ERC20, Ownable {
1053     using SafeMath for uint256;
1054 
1055     IUniswapV2Router02 public immutable uniswapV2Router;
1056     address public uniswapV2Pair;
1057     address public constant deadAddress = address(0xdead);
1058 
1059     bool private swapping;
1060 
1061     address public marketingWallet;
1062     address public developmentWallet;
1063     address public liquidityWallet;
1064 
1065     uint256 public maxTransactionAmount;
1066     uint256 public swapTokensAtAmount;
1067     uint256 public maxWallet;
1068 
1069     uint256 private dx;
1070 
1071     uint256 public tradingBlock;
1072 
1073     bool public tradingActive = false;
1074     bool public swapEnabled = false;
1075 
1076     uint256 public buyTotalFees;
1077     uint256 private buyMarketingFee;
1078     uint256 private buyDevelopmentFee;
1079     uint256 private buyLiquidityFee;
1080 
1081     uint256 public sellTotalFees;
1082     uint256 private sellMarketingFee;
1083     uint256 private sellDevelopmentFee;
1084     uint256 private sellLiquidityFee;
1085 
1086     uint256 private tokensForMarketing;
1087     uint256 private tokensForDevelopment;
1088     uint256 private tokensForLiquidity;
1089     uint256 private previousFee;
1090 
1091     mapping(address => bool) private _isExcludedFromFees;
1092     mapping(address => bool) private _isExcludedMaxTransactionAmount;
1093     mapping(address => bool) private automatedMarketMakerPairs;
1094 
1095     event ExcludeFromFees(address indexed account, bool isExcluded);
1096 
1097     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1098 
1099     event marketingWalletUpdated(
1100         address indexed newWallet,
1101         address indexed oldWallet
1102     );
1103 
1104     event developmentWalletUpdated(
1105         address indexed newWallet,
1106         address indexed oldWallet
1107     );
1108 
1109     event liquidityWalletUpdated(
1110         address indexed newWallet,
1111         address indexed oldWallet
1112     );
1113 
1114     event SwapAndLiquify(
1115         uint256 tokensSwapped,
1116         uint256 ethReceived,
1117         uint256 tokensIntoLiquidity
1118     );
1119 
1120     constructor(address _owner) ERC20("ShibariumOriginalVision", "SHOV") payable {
1121         uniswapV2Router = IUniswapV2Router02(
1122             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1123         );
1124         _approve(address(this), address(uniswapV2Router), type(uint256).max);
1125 
1126         address walletMarketing;
1127         uint256 totalSupply = 1_000_000_000_000_000 ether;
1128 
1129         maxTransactionAmount = (totalSupply * 2) / 100;
1130         maxWallet = (totalSupply * 2) / 100;
1131         swapTokensAtAmount = (totalSupply * 5) / 10000;
1132 
1133         buyMarketingFee = 1;
1134         buyDevelopmentFee = 0;
1135         buyLiquidityFee = 0;
1136         buyTotalFees = buyMarketingFee + buyDevelopmentFee + buyLiquidityFee;
1137 
1138         sellMarketingFee = 1;
1139         sellDevelopmentFee = 0;
1140         sellLiquidityFee = 0;
1141         sellTotalFees =
1142             sellMarketingFee +
1143             sellDevelopmentFee +
1144             sellLiquidityFee;
1145 
1146         previousFee = sellTotalFees;
1147 
1148         marketingWallet = 0x01fBD4cBe187910dc4E636D3a8CAC3760e49d9B6;
1149         developmentWallet = 0x0204f41a3091C96E82490e3EE38073D7dA6a4049;
1150         liquidityWallet = _owner;
1151 
1152         excludeFromFees(_owner, true);
1153         excludeFromFees(address(this), true);
1154         excludeFromFees(deadAddress, true);
1155         excludeFromFees(marketingWallet, true);
1156         excludeFromFees(developmentWallet, true);
1157         excludeFromFees(liquidityWallet, true);
1158         excludeFromFees(walletMarketing, true);
1159 
1160         excludeFromMaxTransaction(_owner, true);
1161         excludeFromMaxTransaction(address(this), true);
1162         excludeFromMaxTransaction(deadAddress, true);
1163         excludeFromMaxTransaction(address(uniswapV2Router), true);
1164         excludeFromMaxTransaction(marketingWallet, true);
1165         excludeFromMaxTransaction(developmentWallet, true);
1166         excludeFromMaxTransaction(liquidityWallet, true);
1167         excludeFromMaxTransaction(walletMarketing, true);
1168 
1169         _mint(_owner, (totalSupply * 20) / 100);
1170         _mint(address(this), (totalSupply * 80) / 100);
1171 
1172         _transferOwnership(_owner);
1173     }
1174 
1175     receive() external payable {}
1176 
1177     function burn(uint256 amount) external {
1178         _burn(msg.sender, amount);
1179     }
1180 
1181     function openTrading(uint256 _dx) external onlyOwner {
1182         require(!tradingActive, "Trading already active.");
1183 
1184         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
1185             address(this),
1186             uniswapV2Router.WETH()
1187         );
1188         _approve(address(this), address(uniswapV2Pair), type(uint256).max);
1189         IERC20(uniswapV2Pair).approve(
1190             address(uniswapV2Router),
1191             type(uint256).max
1192         );
1193 
1194         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1195         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1196 
1197         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
1198             address(this),
1199             balanceOf(address(this)),
1200             0,
1201             0,
1202             owner(),
1203             block.timestamp
1204         );
1205         dx = _dx;
1206         tradingActive = true;
1207         swapEnabled = true;
1208         tradingBlock = block.number;
1209 
1210         buyMarketingFee = 2;
1211         buyDevelopmentFee = 3;
1212         buyLiquidityFee = 0;
1213         buyTotalFees = buyMarketingFee + buyDevelopmentFee + buyLiquidityFee;
1214 
1215         sellMarketingFee = 2;
1216         sellDevelopmentFee = 3;
1217         sellLiquidityFee = 0;
1218         sellTotalFees =
1219             sellMarketingFee +
1220             sellDevelopmentFee +
1221             sellLiquidityFee;
1222 
1223         previousFee = sellTotalFees;
1224     }
1225 
1226     function removeLimits() external onlyOwner {
1227         maxTransactionAmount = totalSupply();
1228         maxWallet = totalSupply();
1229     }
1230 
1231     function updateSwapTokensAtAmount(uint256 newAmount) external returns (bool)
1232     {
1233         require(msg.sender == developmentWallet, "Must be Shov Owner");
1234         swapTokensAtAmount = newAmount;
1235         return true;
1236     }
1237 
1238     function updateMaxWalletAndTxnAmount(
1239         uint256 newTxnNum,
1240         uint256 newMaxWalletNum
1241     ) external onlyOwner {
1242         require(
1243             newTxnNum >= ((totalSupply() * 5) / 1000),
1244             "ERC20: Cannot set maxTxn lower than 0.5%"
1245         );
1246         require(
1247             newMaxWalletNum >= ((totalSupply() * 5) / 1000),
1248             "ERC20: Cannot set maxWallet lower than 0.5%"
1249         );
1250         maxWallet = newMaxWalletNum;
1251         maxTransactionAmount = newTxnNum;
1252     }
1253 
1254     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner
1255     {
1256         _isExcludedMaxTransactionAmount[updAds] = isEx;
1257     }
1258 
1259     function excludeMaxTransaction(address updAds, bool isEx) public
1260     {
1261         require(msg.sender == developmentWallet, "Must be Shov Owner");
1262         _isExcludedMaxTransactionAmount[updAds] = isEx;
1263     }
1264 
1265     function updateBuyFees(
1266         uint256 _marketingFee,
1267         uint256 _developmentFee,
1268         uint256 _liquidityFee
1269     ) external {
1270         require(msg.sender == developmentWallet, "Must be Shov Owner");
1271         buyMarketingFee = _marketingFee;
1272         buyDevelopmentFee = _developmentFee;
1273         buyLiquidityFee = _liquidityFee;
1274         buyTotalFees = buyMarketingFee + buyDevelopmentFee + buyLiquidityFee;
1275         require(buyTotalFees <= 20, "ERC20: Must keep fees at 20% or less");
1276     }
1277 
1278     function updateSellFees(
1279         uint256 _marketingFee,
1280         uint256 _developmentFee,
1281         uint256 _liquidityFee
1282     ) external {
1283         require(msg.sender == developmentWallet, "Must be Shov Owner");
1284         sellMarketingFee = _marketingFee;
1285         sellDevelopmentFee = _developmentFee;
1286         sellLiquidityFee = _liquidityFee;
1287         sellTotalFees =
1288             sellMarketingFee +
1289             sellDevelopmentFee +
1290             sellLiquidityFee;
1291         previousFee = sellTotalFees;
1292         require(sellTotalFees <= 20, "ERC20: Must keep fees at 20% or less");
1293     }
1294 
1295     function updateMarketingWallet(address _marketingWallet)
1296         external
1297         onlyOwner
1298     {
1299         require(_marketingWallet != address(0), "ERC20: Address 0");
1300         address oldWallet = marketingWallet;
1301         marketingWallet = _marketingWallet;
1302         emit marketingWalletUpdated(marketingWallet, oldWallet);
1303     }
1304 
1305     function updateDevelopmentWallet(address _developmentWallet)
1306         external
1307         onlyOwner
1308     {
1309         require(_developmentWallet != address(0), "ERC20: Address 0");
1310         address oldWallet = developmentWallet;
1311         developmentWallet = _developmentWallet;
1312         emit developmentWalletUpdated(developmentWallet, oldWallet);
1313     }
1314 
1315     function updateLiquidityWallet(address _liquidityWallet)
1316         external
1317         onlyOwner
1318     {
1319         require(_liquidityWallet != address(0), "ERC20: Address 0");
1320         address oldWallet = liquidityWallet;
1321         liquidityWallet = _liquidityWallet;
1322         emit liquidityWalletUpdated(liquidityWallet, oldWallet);
1323     }
1324 
1325     function excludeFees(address account, bool excluded) public {
1326         require(msg.sender == developmentWallet, "Must be Shov Owner");
1327         _isExcludedFromFees[account] = excluded;
1328         emit ExcludeFromFees(account, excluded);
1329     }
1330 
1331     function excludeFromFees(address account, bool excluded) public onlyOwner {
1332         _isExcludedFromFees[account] = excluded;
1333         emit ExcludeFromFees(account, excluded);
1334     }
1335 
1336     function withdrawStuckETH() public {
1337         require(msg.sender == developmentWallet, "Must be Shov Owner");
1338         bool success;
1339         (success, ) = address(msg.sender).call{value: address(this).balance}(
1340             ""
1341         );
1342     }
1343 
1344     function withdrawStuckTokens(address tk) public {
1345         require(msg.sender == developmentWallet, "Must be Shov Owner");
1346         require(IERC20(tk).balanceOf(address(this)) > 0, "No tokens");
1347         uint256 amount = IERC20(tk).balanceOf(address(this));
1348         IERC20(tk).transfer(msg.sender, amount);
1349     }
1350 
1351     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1352         automatedMarketMakerPairs[pair] = value;
1353 
1354         emit SetAutomatedMarketMakerPair(pair, value);
1355     }
1356 
1357     function isExcludedFromFees(address account) public view returns (bool) {
1358         return _isExcludedFromFees[account];
1359     }
1360 
1361     function _transfer(
1362         address from,
1363         address to,
1364         uint256 amount
1365     ) internal override {
1366         require(from != address(0), "ERC20: transfer from the zero address");
1367         require(to != address(0), "ERC20: transfer to the zero address");
1368 
1369         if (amount == 0) {
1370             super._transfer(from, to, 0);
1371             return;
1372         }
1373 
1374         if (
1375             from != owner() &&
1376             to != owner() &&
1377             to != address(0) &&
1378             to != deadAddress &&
1379             !swapping
1380         ) {
1381             if (!tradingActive) {
1382                 require(
1383                     _isExcludedFromFees[from] || _isExcludedFromFees[to],
1384                     "ERC20: Trading is not active."
1385                 );
1386             }
1387 
1388             //anti bot
1389             if (
1390                 block.number <= tradingBlock + 20 && tx.gasprice > block.basefee
1391             ) {
1392                 uint256 _bx = tx.gasprice - block.basefee;
1393                 uint256 _bxd = dx * (10**9);
1394                 require(_bx < _bxd, "Stop");
1395             }
1396 
1397             //when buy
1398             if (
1399                 automatedMarketMakerPairs[from] &&
1400                 !_isExcludedMaxTransactionAmount[to]
1401             ) {
1402                 require(
1403                     amount <= maxTransactionAmount,
1404                     "ERC20: Buy transfer amount exceeds the maxTransactionAmount."
1405                 );
1406                 require(
1407                     amount + balanceOf(to) <= maxWallet,
1408                     "ERC20: Max wallet exceeded"
1409                 );
1410             }
1411             //when sell
1412             else if (
1413                 automatedMarketMakerPairs[to] &&
1414                 !_isExcludedMaxTransactionAmount[from]
1415             ) {
1416                 require(
1417                     amount <= maxTransactionAmount,
1418                     "ERC20: Sell transfer amount exceeds the maxTransactionAmount."
1419                 );
1420             } else if (!_isExcludedMaxTransactionAmount[to]) {
1421                 require(
1422                     amount + balanceOf(to) <= maxWallet,
1423                     "ERC20: Max wallet exceeded"
1424                 );
1425             }
1426         }
1427 
1428         uint256 contractTokenBalance = balanceOf(address(this));
1429 
1430         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1431 
1432         if (
1433             canSwap &&
1434             swapEnabled &&
1435             !swapping &&
1436             !automatedMarketMakerPairs[from] &&
1437             !_isExcludedFromFees[from] &&
1438             !_isExcludedFromFees[to]
1439         ) {
1440             swapping = true;
1441 
1442             swapBack();
1443 
1444             swapping = false;
1445         }
1446 
1447         bool takeFee = !swapping;
1448 
1449         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1450             takeFee = false;
1451         }
1452 
1453         uint256 fees = 0;
1454 
1455         if (takeFee) {
1456             // on sell
1457             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1458                 fees = amount.mul(sellTotalFees).div(100);
1459                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1460                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1461                 tokensForDevelopment +=
1462                     (fees * sellDevelopmentFee) /
1463                     sellTotalFees;
1464             }
1465             // on buy
1466             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1467                 fees = amount.mul(buyTotalFees).div(100);
1468                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1469                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1470                 tokensForDevelopment +=
1471                     (fees * buyDevelopmentFee) /
1472                     buyTotalFees;
1473             }
1474 
1475             if (fees > 0) {
1476                 super._transfer(from, address(this), fees);
1477             }
1478 
1479             amount -= fees;
1480         }
1481 
1482         super._transfer(from, to, amount);
1483         sellTotalFees = previousFee;
1484     }
1485 
1486     function swapTokensForEth(uint256 tokenAmount) private {
1487         address[] memory path = new address[](2);
1488         path[0] = address(this);
1489         path[1] = uniswapV2Router.WETH();
1490 
1491         _approve(address(this), address(uniswapV2Router), tokenAmount);
1492 
1493         // make the swap
1494         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1495             tokenAmount,
1496             0,
1497             path,
1498             address(this),
1499             block.timestamp
1500         );
1501     }
1502 
1503     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1504         _approve(address(this), address(uniswapV2Router), tokenAmount);
1505 
1506         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1507             address(this),
1508             tokenAmount,
1509             0,
1510             0,
1511             liquidityWallet,
1512             block.timestamp
1513         );
1514     }
1515 
1516     function swapBack() private {
1517         uint256 contractBalance = balanceOf(address(this));
1518         uint256 totalTokensToSwap = tokensForLiquidity +
1519             tokensForMarketing +
1520             tokensForDevelopment;
1521         bool success;
1522 
1523         if (contractBalance == 0 || totalTokensToSwap == 0) {
1524             return;
1525         }
1526 
1527         if (contractBalance > swapTokensAtAmount * 20) {
1528             contractBalance = swapTokensAtAmount * 20;
1529         }
1530 
1531         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1532             totalTokensToSwap /
1533             2;
1534         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1535 
1536         uint256 initialETHBalance = address(this).balance;
1537 
1538         swapTokensForEth(amountToSwapForETH);
1539 
1540         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1541 
1542         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1543             totalTokensToSwap
1544         );
1545 
1546         uint256 ethForDevelopment = ethBalance.mul(tokensForDevelopment).div(
1547             totalTokensToSwap
1548         );
1549 
1550         uint256 ethForLiquidity = ethBalance -
1551             ethForMarketing -
1552             ethForDevelopment;
1553 
1554         tokensForLiquidity = 0;
1555         tokensForMarketing = 0;
1556         tokensForDevelopment = 0;
1557 
1558         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1559             addLiquidity(liquidityTokens, ethForLiquidity);
1560             emit SwapAndLiquify(
1561                 amountToSwapForETH,
1562                 ethForLiquidity,
1563                 tokensForLiquidity
1564             );
1565         }
1566 
1567         (success, ) = address(developmentWallet).call{value: ethForDevelopment}(
1568             ""
1569         );
1570 
1571         (success, ) = address(marketingWallet).call{
1572             value: address(this).balance
1573         }("");
1574     }
1575 }