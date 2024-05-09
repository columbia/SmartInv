1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.9;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes calldata) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IUniswapV2Pair {
16     event Approval(
17         address indexed owner,
18         address indexed spender,
19         uint256 value
20     );
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     function name() external pure returns (string memory);
24 
25     function symbol() external pure returns (string memory);
26 
27     function decimals() external pure returns (uint8);
28 
29     function totalSupply() external view returns (uint256);
30 
31     function balanceOf(address owner) external view returns (uint256);
32 
33     function allowance(address owner, address spender)
34         external
35         view
36         returns (uint256);
37 
38     function approve(address spender, uint256 value) external returns (bool);
39 
40     function transfer(address to, uint256 value) external returns (bool);
41 
42     function transferFrom(
43         address from,
44         address to,
45         uint256 value
46     ) external returns (bool);
47 
48     function DOMAIN_SEPARATOR() external view returns (bytes32);
49 
50     function PERMIT_TYPEHASH() external pure returns (bytes32);
51 
52     function nonces(address owner) external view returns (uint256);
53 
54     function permit(
55         address owner,
56         address spender,
57         uint256 value,
58         uint256 deadline,
59         uint8 v,
60         bytes32 r,
61         bytes32 s
62     ) external;
63 
64     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
65     event Burn(
66         address indexed sender,
67         uint256 amount0,
68         uint256 amount1,
69         address indexed to
70     );
71     event Swap(
72         address indexed sender,
73         uint256 amount0In,
74         uint256 amount1In,
75         uint256 amount0Out,
76         uint256 amount1Out,
77         address indexed to
78     );
79     event Sync(uint112 reserve0, uint112 reserve1);
80 
81     function MINIMUM_LIQUIDITY() external pure returns (uint256);
82 
83     function factory() external view returns (address);
84 
85     function token0() external view returns (address);
86 
87     function token1() external view returns (address);
88 
89     function getReserves()
90         external
91         view
92         returns (
93             uint112 reserve0,
94             uint112 reserve1,
95             uint32 blockTimestampLast
96         );
97 
98     function price0CumulativeLast() external view returns (uint256);
99 
100     function price1CumulativeLast() external view returns (uint256);
101 
102     function kLast() external view returns (uint256);
103 
104     function mint(address to) external returns (uint256 liquidity);
105 
106     function burn(address to)
107         external
108         returns (uint256 amount0, uint256 amount1);
109 
110     function swap(
111         uint256 amount0Out,
112         uint256 amount1Out,
113         address to,
114         bytes calldata data
115     ) external;
116 
117     function skim(address to) external;
118 
119     function sync() external;
120 
121     function initialize(address, address) external;
122 }
123 
124 interface IUniswapV2Factory {
125     event PairCreated(
126         address indexed token0,
127         address indexed token1,
128         address pair,
129         uint256
130     );
131 
132     function feeTo() external view returns (address);
133 
134     function feeToSetter() external view returns (address);
135 
136     function getPair(address tokenA, address tokenB)
137         external
138         view
139         returns (address pair);
140 
141     function allPairs(uint256) external view returns (address pair);
142 
143     function allPairsLength() external view returns (uint256);
144 
145     function createPair(address tokenA, address tokenB)
146         external
147         returns (address pair);
148 
149     function setFeeTo(address) external;
150 
151     function setFeeToSetter(address) external;
152 }
153 
154 interface IERC20 {
155     /**
156      * @dev Returns the amount of tokens in existence.
157      */
158     function totalSupply() external view returns (uint256);
159 
160     /**
161      * @dev Returns the amount of tokens owned by `account`.
162      */
163     function balanceOf(address account) external view returns (uint256);
164 
165     /**
166      * @dev Moves `amount` tokens from the caller's account to `recipient`.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transfer(address recipient, uint256 amount)
173         external
174         returns (bool);
175 
176     /**
177      * @dev Returns the remaining number of tokens that `spender` will be
178      * allowed to spend on behalf of `owner` through {transferFrom}. This is
179      * zero by default.
180      *
181      * This value changes when {approve} or {transferFrom} are called.
182      */
183     function allowance(address owner, address spender)
184         external
185         view
186         returns (uint256);
187 
188     /**
189      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
190      *
191      * Returns a boolean value indicating whether the operation succeeded.
192      *
193      * IMPORTANT: Beware that changing an allowance with this method brings the risk
194      * that someone may use both the old and the new allowance by unfortunate
195      * transaction ordering. One possible solution to mitigate this race
196      * condition is to first reduce the spender's allowance to 0 and set the
197      * desired value afterwards:
198      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
199      *
200      * Emits an {Approval} event.
201      */
202     function approve(address spender, uint256 amount) external returns (bool);
203 
204     /**
205      * @dev Moves `amount` tokens from `sender` to `recipient` using the
206      * allowance mechanism. `amount` is then deducted from the caller's
207      * allowance.
208      *
209      * Returns a boolean value indicating whether the operation succeeded.
210      *
211      * Emits a {Transfer} event.
212      */
213     function transferFrom(
214         address sender,
215         address recipient,
216         uint256 amount
217     ) external returns (bool);
218 
219     /**
220      * @dev Emitted when `value` tokens are moved from one account (`from`) to
221      * another (`to`).
222      *
223      * Note that `value` may be zero.
224      */
225     event Transfer(address indexed from, address indexed to, uint256 value);
226 
227     /**
228      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
229      * a call to {approve}. `value` is the new allowance.
230      */
231     event Approval(
232         address indexed owner,
233         address indexed spender,
234         uint256 value
235     );
236 }
237 
238 interface IERC20Metadata is IERC20 {
239     /**
240      * @dev Returns the name of the token.
241      */
242     function name() external view returns (string memory);
243 
244     /**
245      * @dev Returns the symbol of the token.
246      */
247     function symbol() external view returns (string memory);
248 
249     /**
250      * @dev Returns the decimals places of the token.
251      */
252     function decimals() external view returns (uint8);
253 }
254 
255 contract ERC20 is Context, IERC20, IERC20Metadata {
256     using SafeMath for uint256;
257 
258     mapping(address => uint256) private _balances;
259 
260     mapping(address => mapping(address => uint256)) private _allowances;
261 
262     uint256 private _totalSupply;
263 
264     string private _name;
265     string private _symbol;
266 
267     /**
268      * @dev Sets the values for {name} and {symbol}.
269      *
270      * The default value of {decimals} is 9. To select a different value for
271      * {decimals} you should overload it.
272      *
273      * All two of these values are immutable: they can only be set once during
274      * construction.
275      */
276     constructor(string memory name_, string memory symbol_) {
277         _name = name_;
278         _symbol = symbol_;
279     }
280 
281     /**
282      * @dev Returns the name of the token.
283      */
284     function name() public view virtual override returns (string memory) {
285         return _name;
286     }
287 
288     /**
289      * @dev Returns the symbol of the token, usually a shorter version of the
290      * name.
291      */
292     function symbol() public view virtual override returns (string memory) {
293         return _symbol;
294     }
295 
296     /**
297      * @dev Returns the number of decimals used to get its user representation.
298      * For example, if `decimals` equals `2`, a balance of `505` tokens should
299      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
300      *
301      * Tokens usually opt for a value of 18, imitating the relationship between
302      * Ether and Wei. This is the value {ERC20} uses, unless this function is
303      * overridden;
304      *
305      * NOTE: This information is only used for _display_ purposes: it in
306      * no way affects any of the arithmetic of the contract, including
307      * {IERC20-balanceOf} and {IERC20-transfer}.
308      */
309     function decimals() public view virtual override returns (uint8) {
310         return 9;
311     }
312 
313     /**
314      * @dev See {IERC20-totalSupply}.
315      */
316     function totalSupply() public view virtual override returns (uint256) {
317         return _totalSupply;
318     }
319 
320     /**
321      * @dev See {IERC20-balanceOf}.
322      */
323     function balanceOf(address account)
324         public
325         view
326         virtual
327         override
328         returns (uint256)
329     {
330         return _balances[account];
331     }
332 
333     /**
334      * @dev See {IERC20-transfer}.
335      *
336      * Requirements:
337      *
338      * - `recipient` cannot be the zero address.
339      * - the caller must have a balance of at least `amount`.
340      */
341     function transfer(address recipient, uint256 amount)
342         public
343         virtual
344         override
345         returns (bool)
346     {
347         _transfer(_msgSender(), recipient, amount);
348         return true;
349     }
350 
351     /**
352      * @dev See {IERC20-allowance}.
353      */
354     function allowance(address owner, address spender)
355         public
356         view
357         virtual
358         override
359         returns (uint256)
360     {
361         return _allowances[owner][spender];
362     }
363 
364     /**
365      * @dev See {IERC20-approve}.
366      *
367      * Requirements:
368      *
369      * - `spender` cannot be the zero address.
370      */
371     function approve(address spender, uint256 amount)
372         public
373         virtual
374         override
375         returns (bool)
376     {
377         _approve(_msgSender(), spender, amount);
378         return true;
379     }
380 
381     /**
382      * @dev See {IERC20-transferFrom}.
383      *
384      * Emits an {Approval} event indicating the updated allowance. This is not
385      * required by the EIP. See the note at the beginning of {ERC20}.
386      *
387      * Requirements:
388      *
389      * - `sender` and `recipient` cannot be the zero address.
390      * - `sender` must have a balance of at least `amount`.
391      * - the caller must have allowance for ``sender``'s tokens of at least
392      * `amount`.
393      */
394     function transferFrom(
395         address sender,
396         address recipient,
397         uint256 amount
398     ) public virtual override returns (bool) {
399         _transfer(sender, recipient, amount);
400         _approve(
401             sender,
402             _msgSender(),
403             _allowances[sender][_msgSender()].sub(
404                 amount,
405                 "ERC20: transfer amount exceeds allowance"
406             )
407         );
408         return true;
409     }
410 
411     /**
412      * @dev Atomically increases the allowance granted to `spender` by the caller.
413      *
414      * This is an alternative to {approve} that can be used as a mitigation for
415      * problems described in {IERC20-approve}.
416      *
417      * Emits an {Approval} event indicating the updated allowance.
418      *
419      * Requirements:
420      *
421      * - `spender` cannot be the zero address.
422      */
423     function increaseAllowance(address spender, uint256 addedValue)
424         public
425         virtual
426         returns (bool)
427     {
428         _approve(
429             _msgSender(),
430             spender,
431             _allowances[_msgSender()][spender].add(addedValue)
432         );
433         return true;
434     }
435 
436     /**
437      * @dev Atomically decreases the allowance granted to `spender` by the caller.
438      *
439      * This is an alternative to {approve} that can be used as a mitigation for
440      * problems described in {IERC20-approve}.
441      *
442      * Emits an {Approval} event indicating the updated allowance.
443      *
444      * Requirements:
445      *
446      * - `spender` cannot be the zero address.
447      * - `spender` must have allowance for the caller of at least
448      * `subtractedValue`.
449      */
450     function decreaseAllowance(address spender, uint256 subtractedValue)
451         public
452         virtual
453         returns (bool)
454     {
455         _approve(
456             _msgSender(),
457             spender,
458             _allowances[_msgSender()][spender].sub(
459                 subtractedValue,
460                 "ERC20: decreased allowance below zero"
461             )
462         );
463         return true;
464     }
465 
466     /**
467      * @dev Moves tokens `amount` from `sender` to `recipient`.
468      *
469      * This is internal function is equivalent to {transfer}, and can be used to
470      * e.g. implement automatic token fees, slashing mechanisms, etc.
471      *
472      * Emits a {Transfer} event.
473      *
474      * Requirements:
475      *
476      * - `sender` cannot be the zero address.
477      * - `recipient` cannot be the zero address.
478      * - `sender` must have a balance of at least `amount`.
479      */
480     function _transfer(
481         address sender,
482         address recipient,
483         uint256 amount
484     ) internal virtual {
485         require(sender != address(0), "ERC20: transfer from the zero address");
486         require(recipient != address(0), "ERC20: transfer to the zero address");
487 
488         _beforeTokenTransfer(sender, recipient, amount);
489 
490         _balances[sender] = _balances[sender].sub(
491             amount,
492             "ERC20: transfer amount exceeds balance"
493         );
494         _balances[recipient] = _balances[recipient].add(amount);
495         emit Transfer(sender, recipient, amount);
496     }
497 
498     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
499      * the total supply.
500      *
501      * Emits a {Transfer} event with `from` set to the zero address.
502      *
503      * Requirements:
504      *
505      * - `account` cannot be the zero address.
506      */
507     function _mint(address account, uint256 amount) internal virtual {
508         require(account != address(0), "ERC20: mint to the zero address");
509 
510         _beforeTokenTransfer(address(0), account, amount);
511 
512         _totalSupply = _totalSupply.add(amount);
513         _balances[account] = _balances[account].add(amount);
514         emit Transfer(address(0), account, amount);
515     }
516 
517     /**
518      * @dev Destroys `amount` tokens from `account`, reducing the
519      * total supply.
520      *
521      * Emits a {Transfer} event with `to` set to the zero address.
522      *
523      * Requirements:
524      *
525      * - `account` cannot be the zero address.
526      * - `account` must have at least `amount` tokens.
527      */
528     function _burn(address account, uint256 amount) internal virtual {
529         require(account != address(0), "ERC20: burn from the zero address");
530 
531         _beforeTokenTransfer(account, address(0), amount);
532 
533         _balances[account] = _balances[account].sub(
534             amount,
535             "ERC20: burn amount exceeds balance"
536         );
537         _totalSupply = _totalSupply.sub(amount);
538         emit Transfer(account, address(0), amount);
539     }
540 
541     /**
542      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
543      *
544      * This internal function is equivalent to `approve`, and can be used to
545      * e.g. set automatic allowances for certain subsystems, etc.
546      *
547      * Emits an {Approval} event.
548      *
549      * Requirements:
550      *
551      * - `owner` cannot be the zero address.
552      * - `spender` cannot be the zero address.
553      */
554     function _approve(
555         address owner,
556         address spender,
557         uint256 amount
558     ) internal virtual {
559         require(owner != address(0), "ERC20: approve from the zero address");
560         require(spender != address(0), "ERC20: approve to the zero address");
561 
562         _allowances[owner][spender] = amount;
563         emit Approval(owner, spender, amount);
564     }
565 
566     /**
567      * @dev Hook that is called before any transfer of tokens. This includes
568      * minting and burning.
569      *
570      * Calling conditions:
571      *
572      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
573      * will be to transferred to `to`.
574      * - when `from` is zero, `amount` tokens will be minted for `to`.
575      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
576      * - `from` and `to` are never both zero.
577      *
578      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
579      */
580     function _beforeTokenTransfer(
581         address from,
582         address to,
583         uint256 amount
584     ) internal virtual {}
585 }
586 
587 library SafeMath {
588     /**
589      * @dev Returns the addition of two unsigned integers, reverting on
590      * overflow.
591      *
592      * Counterpart to Solidity's `+` operator.
593      *
594      * Requirements:
595      *
596      * - Addition cannot overflow.
597      */
598     function add(uint256 a, uint256 b) internal pure returns (uint256) {
599         uint256 c = a + b;
600         require(c >= a, "SafeMath: addition overflow");
601 
602         return c;
603     }
604 
605     /**
606      * @dev Returns the subtraction of two unsigned integers, reverting on
607      * overflow (when the result is negative).
608      *
609      * Counterpart to Solidity's `-` operator.
610      *
611      * Requirements:
612      *
613      * - Subtraction cannot overflow.
614      */
615     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
616         return sub(a, b, "SafeMath: subtraction overflow");
617     }
618 
619     /**
620      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
621      * overflow (when the result is negative).
622      *
623      * Counterpart to Solidity's `-` operator.
624      *
625      * Requirements:
626      *
627      * - Subtraction cannot overflow.
628      */
629     function sub(
630         uint256 a,
631         uint256 b,
632         string memory errorMessage
633     ) internal pure returns (uint256) {
634         require(b <= a, errorMessage);
635         uint256 c = a - b;
636 
637         return c;
638     }
639 
640     /**
641      * @dev Returns the multiplication of two unsigned integers, reverting on
642      * overflow.
643      *
644      * Counterpart to Solidity's `*` operator.
645      *
646      * Requirements:
647      *
648      * - Multiplication cannot overflow.
649      */
650     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
651         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
652         // benefit is lost if 'b' is also tested.
653         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
654         if (a == 0) {
655             return 0;
656         }
657 
658         uint256 c = a * b;
659         require(c / a == b, "SafeMath: multiplication overflow");
660 
661         return c;
662     }
663 
664     /**
665      * @dev Returns the integer division of two unsigned integers. Reverts on
666      * division by zero. The result is rounded towards zero.
667      *
668      * Counterpart to Solidity's `/` operator. Note: this function uses a
669      * `revert` opcode (which leaves remaining gas untouched) while Solidity
670      * uses an invalid opcode to revert (consuming all remaining gas).
671      *
672      * Requirements:
673      *
674      * - The divisor cannot be zero.
675      */
676     function div(uint256 a, uint256 b) internal pure returns (uint256) {
677         return div(a, b, "SafeMath: division by zero");
678     }
679 
680     /**
681      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
682      * division by zero. The result is rounded towards zero.
683      *
684      * Counterpart to Solidity's `/` operator. Note: this function uses a
685      * `revert` opcode (which leaves remaining gas untouched) while Solidity
686      * uses an invalid opcode to revert (consuming all remaining gas).
687      *
688      * Requirements:
689      *
690      * - The divisor cannot be zero.
691      */
692     function div(
693         uint256 a,
694         uint256 b,
695         string memory errorMessage
696     ) internal pure returns (uint256) {
697         require(b > 0, errorMessage);
698         uint256 c = a / b;
699 
700         return c;
701     }
702 
703     /**
704      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
705      * Reverts when dividing by zero.
706      *
707      * Counterpart to Solidity's `%` operator. This function uses a `revert`
708      * opcode (which leaves remaining gas untouched) while Solidity uses an
709      * invalid opcode to revert (consuming all remaining gas).
710      *
711      * Requirements:
712      *
713      * - The divisor cannot be zero.
714      */
715     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
716         return mod(a, b, "SafeMath: modulo by zero");
717     }
718 
719     /**
720      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
721      * Reverts with custom message when dividing by zero.
722      *
723      * Counterpart to Solidity's `%` operator. This function uses a `revert`
724      * opcode (which leaves remaining gas untouched) while Solidity uses an
725      * invalid opcode to revert (consuming all remaining gas).
726      *
727      * Requirements:
728      *
729      * - The divisor cannot be zero.
730      */
731     function mod(
732         uint256 a,
733         uint256 b,
734         string memory errorMessage
735     ) internal pure returns (uint256) {
736         require(b != 0, errorMessage);
737         return a % b;
738     }
739 }
740 
741 contract Ownable is Context {
742     address private _owner;
743 
744     event OwnershipTransferred(
745         address indexed previousOwner,
746         address indexed newOwner
747     );
748 
749     /**
750      * @dev Initializes the contract setting the deployer as the initial owner.
751      */
752     constructor() {
753         address msgSender = _msgSender();
754         _owner = msgSender;
755         emit OwnershipTransferred(address(0), msgSender);
756     }
757 
758     /**
759      * @dev Returns the address of the current owner.
760      */
761     function owner() public view returns (address) {
762         return _owner;
763     }
764 
765     /**
766      * @dev Throws if called by any account other than the owner.
767      */
768     modifier onlyOwner() {
769         require(_owner == _msgSender(), "Ownable: caller is not the owner");
770         _;
771     }
772 
773     /**
774      * @dev Leaves the contract without owner. It will not be possible to call
775      * `onlyOwner` functions anymore. Can only be called by the current owner.
776      *
777      * NOTE: Renouncing ownership will leave the contract without an owner,
778      * thereby removing any functionality that is only available to the owner.
779      */
780     function renounceOwnership() public virtual onlyOwner {
781         emit OwnershipTransferred(_owner, address(0));
782         _owner = address(0);
783     }
784 
785     /**
786      * @dev Transfers ownership of the contract to a new account (`newOwner`).
787      * Can only be called by the current owner.
788      */
789     function transferOwnership(address newOwner) public virtual onlyOwner {
790         require(
791             newOwner != address(0),
792             "Ownable: new owner is the zero address"
793         );
794         emit OwnershipTransferred(_owner, newOwner);
795         _owner = newOwner;
796     }
797 }
798 
799 
800 abstract contract ReentrancyGuard {
801     // Booleans are more expensive than uint256 or any type that takes up a full
802     // word because each write operation emits an extra SLOAD to first read the
803     // slot's contents, replace the bits taken up by the boolean, and then write
804     // back. This is the compiler's defense against contract upgrades and
805     // pointer aliasing, and it cannot be disabled.
806 
807     // The values being non-zero value makes deployment a bit more expensive,
808     // but in exchange the refund on every call to nonReentrant will be lower in
809     // amount. Since refunds are capped to a percentage of the total
810     // transaction's gas, it is best to keep them low in cases like this one, to
811     // increase the likelihood of the full refund coming into effect.
812     uint256 private constant _NOT_ENTERED = 1;
813     uint256 private constant _ENTERED = 2;
814 
815     uint256 private _status;
816 
817     constructor() {
818         _status = _NOT_ENTERED;
819     }
820 
821     /**
822      * @dev Prevents a contract from calling itself, directly or indirectly.
823      * Calling a `nonReentrant` function from another `nonReentrant`
824      * function is not supported. It is possible to prevent this from happening
825      * by making the `nonReentrant` function external, and making it call a
826      * `private` function that does the actual work.
827      */
828     modifier nonReentrant() {
829         _nonReentrantBefore();
830         _;
831         _nonReentrantAfter();
832     }
833 
834     function _nonReentrantBefore() private {
835         // On the first call to nonReentrant, _status will be _NOT_ENTERED
836         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
837 
838         // Any calls to nonReentrant after this point will fail
839         _status = _ENTERED;
840     }
841 
842     function _nonReentrantAfter() private {
843         // By storing the original value once again, a refund is triggered (see
844         // https://eips.ethereum.org/EIPS/eip-2200)
845         _status = _NOT_ENTERED;
846     }
847 }
848 
849 interface IUniswapV2Router01 {
850     function factory() external pure returns (address);
851 
852     function WETH() external pure returns (address);
853 
854     function addLiquidity(
855         address tokenA,
856         address tokenB,
857         uint256 amountADesired,
858         uint256 amountBDesired,
859         uint256 amountAMin,
860         uint256 amountBMin,
861         address to,
862         uint256 deadline
863     )
864         external
865         returns (
866             uint256 amountA,
867             uint256 amountB,
868             uint256 liquidity
869         );
870 
871     function addLiquidityETH(
872         address token,
873         uint256 amountTokenDesired,
874         uint256 amountTokenMin,
875         uint256 amountETHMin,
876         address to,
877         uint256 deadline
878     )
879         external
880         payable
881         returns (
882             uint256 amountToken,
883             uint256 amountETH,
884             uint256 liquidity
885         );
886 
887     function removeLiquidity(
888         address tokenA,
889         address tokenB,
890         uint256 liquidity,
891         uint256 amountAMin,
892         uint256 amountBMin,
893         address to,
894         uint256 deadline
895     ) external returns (uint256 amountA, uint256 amountB);
896 
897     function removeLiquidityETH(
898         address token,
899         uint256 liquidity,
900         uint256 amountTokenMin,
901         uint256 amountETHMin,
902         address to,
903         uint256 deadline
904     ) external returns (uint256 amountToken, uint256 amountETH);
905 
906     function removeLiquidityWithPermit(
907         address tokenA,
908         address tokenB,
909         uint256 liquidity,
910         uint256 amountAMin,
911         uint256 amountBMin,
912         address to,
913         uint256 deadline,
914         bool approveMax,
915         uint8 v,
916         bytes32 r,
917         bytes32 s
918     ) external returns (uint256 amountA, uint256 amountB);
919 
920     function removeLiquidityETHWithPermit(
921         address token,
922         uint256 liquidity,
923         uint256 amountTokenMin,
924         uint256 amountETHMin,
925         address to,
926         uint256 deadline,
927         bool approveMax,
928         uint8 v,
929         bytes32 r,
930         bytes32 s
931     ) external returns (uint256 amountToken, uint256 amountETH);
932 
933     function swapExactTokensForTokens(
934         uint256 amountIn,
935         uint256 amountOutMin,
936         address[] calldata path,
937         address to,
938         uint256 deadline
939     ) external returns (uint256[] memory amounts);
940 
941     function swapTokensForExactTokens(
942         uint256 amountOut,
943         uint256 amountInMax,
944         address[] calldata path,
945         address to,
946         uint256 deadline
947     ) external returns (uint256[] memory amounts);
948 
949     function swapExactETHForTokens(
950         uint256 amountOutMin,
951         address[] calldata path,
952         address to,
953         uint256 deadline
954     ) external payable returns (uint256[] memory amounts);
955 
956     function swapTokensForExactETH(
957         uint256 amountOut,
958         uint256 amountInMax,
959         address[] calldata path,
960         address to,
961         uint256 deadline
962     ) external returns (uint256[] memory amounts);
963 
964     function swapExactTokensForETH(
965         uint256 amountIn,
966         uint256 amountOutMin,
967         address[] calldata path,
968         address to,
969         uint256 deadline
970     ) external returns (uint256[] memory amounts);
971 
972     function swapETHForExactTokens(
973         uint256 amountOut,
974         address[] calldata path,
975         address to,
976         uint256 deadline
977     ) external payable returns (uint256[] memory amounts);
978 
979     function quote(
980         uint256 amountA,
981         uint256 reserveA,
982         uint256 reserveB
983     ) external pure returns (uint256 amountB);
984 
985     function getAmountOut(
986         uint256 amountIn,
987         uint256 reserveIn,
988         uint256 reserveOut
989     ) external pure returns (uint256 amountOut);
990 
991     function getAmountIn(
992         uint256 amountOut,
993         uint256 reserveIn,
994         uint256 reserveOut
995     ) external pure returns (uint256 amountIn);
996 
997     function getAmountsOut(uint256 amountIn, address[] calldata path)
998         external
999         view
1000         returns (uint256[] memory amounts);
1001 
1002     function getAmountsIn(uint256 amountOut, address[] calldata path)
1003         external
1004         view
1005         returns (uint256[] memory amounts);
1006 }
1007 
1008 interface IUniswapV2Router02 is IUniswapV2Router01 {
1009     function removeLiquidityETHSupportingFeeOnTransferTokens(
1010         address token,
1011         uint256 liquidity,
1012         uint256 amountTokenMin,
1013         uint256 amountETHMin,
1014         address to,
1015         uint256 deadline
1016     ) external returns (uint256 amountETH);
1017 
1018     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1019         address token,
1020         uint256 liquidity,
1021         uint256 amountTokenMin,
1022         uint256 amountETHMin,
1023         address to,
1024         uint256 deadline,
1025         bool approveMax,
1026         uint8 v,
1027         bytes32 r,
1028         bytes32 s
1029     ) external returns (uint256 amountETH);
1030 
1031     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1032         uint256 amountIn,
1033         uint256 amountOutMin,
1034         address[] calldata path,
1035         address to,
1036         uint256 deadline
1037     ) external;
1038 
1039     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1040         uint256 amountOutMin,
1041         address[] calldata path,
1042         address to,
1043         uint256 deadline
1044     ) external payable;
1045 
1046     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1047         uint256 amountIn,
1048         uint256 amountOutMin,
1049         address[] calldata path,
1050         address to,
1051         uint256 deadline
1052     ) external;
1053 }
1054 
1055 contract JORDAN is ERC20, Ownable, ReentrancyGuard {
1056     using SafeMath for uint256;
1057 
1058     IUniswapV2Router02 public immutable uniswapV2Router;
1059     address public immutable uniswapV2Pair;
1060     address public constant deadAddress = address(0xdead);
1061 
1062     bool private swapping;
1063 
1064     address public marketingWallet;
1065 
1066     uint256 public maxTransactionAmount;
1067     uint256 public swapTokensAtAmount;
1068     uint256 public maxWallet;
1069 
1070     uint256 public MaxWalletValue;
1071     uint256 public percentForLPBurn = 25; // 25 = .25%
1072     bool public lpBurnEnabled = false;
1073     uint256 public lpBurnFrequency = 3600 / 12;
1074     uint256 public lastLpBurnTime;
1075 
1076     uint256 public manualBurnFrequency = 180000 / 12;
1077     uint256 public lastManualLpBurnTime;
1078 
1079     bool public limitsInEffect = true;
1080     bool public tradingActive = false;
1081     bool public swapEnabled = false;
1082     // Anti-bot and anti-whale mappings and variables
1083     bool private minEnabled = true;
1084     bool private transferTaxEnabled = true;
1085 
1086     uint256 public buyTotalFees;
1087     // uint256 public buytax;
1088     uint256 public buyMarketingFee;
1089     uint256 public buyLiquidityFee;
1090     uint256 public buyBurnFee;
1091 
1092     uint256 public sellTotalFees;
1093     //uint256 public selltax;
1094     uint256 public sellMarketingFee;
1095     uint256 public sellLiquidityFee;
1096     uint256 public sellBurnFee;
1097 
1098     uint256 public tokensForMarketing;
1099     uint256 public tokensForLiquidity;
1100     uint256 public tokenForBurn;
1101 
1102     uint256 constant MAX = ~uint256(0);
1103     uint256 public _rTotal;
1104     uint256 public tTotal;
1105     uint256 public _tFeeTal;
1106 
1107     address[] public _exclud;
1108     mapping(address => uint256) private _rOwned;
1109     mapping(address => uint256) private _tOwned;
1110 
1111     // exlcude from fees and max transaction amount
1112     mapping(address => bool) private _isExcludedFromFees;
1113     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1114     mapping(address => uint8) public _transferTax;
1115 
1116     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1117     // could be subject to a maximum transfer amount
1118     mapping(address => bool) public automatedMarketMakerPairs;
1119 
1120     event UpdateUniswapV2Router(
1121         address indexed newAddress,
1122         address indexed oldAddress
1123     );
1124 
1125     event ExcludeFromFees(address indexed account, bool isExcluded);
1126 
1127     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1128 
1129     event marketingWalletUpdated(
1130         address indexed newWallet,
1131         address indexed oldWallet
1132     );
1133 
1134     event devWalletUpdated(
1135         address indexed newWallet,
1136         address indexed oldWallet
1137     );
1138 
1139     event SwapAndLiquify(
1140         uint256 tokensSwapped,
1141         uint256 ethReceived,
1142         uint256 tokensIntoLiquidity
1143     );
1144 
1145     event AutoNukeLP();
1146 
1147     event ManualNukeLP();
1148 
1149     constructor() ERC20("Michael Jordan Coin", "JORDAN") {
1150         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1151             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D 
1152         );
1153 
1154         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1155         uniswapV2Router = _uniswapV2Router;
1156 
1157         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1158             .createPair(address(this), _uniswapV2Router.WETH());
1159         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1160         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1161 
1162         uint256 _buyMarketingFee = 13;
1163         uint256 _buyLiquidityFee = 2;
1164         uint256 _buyBurnFee = 0;
1165 
1166         uint256 _sellMarketingFee = 13;
1167         uint256 _sellLiquidityFee = 2;
1168         uint256 _sellBurnFee = 0;
1169 
1170         //tTotal = x * 1e9;
1171         tTotal = 10000000000000000000000 * 1e9;
1172         _rTotal = (MAX - (MAX % tTotal));
1173 
1174         maxTransactionAmount = (tTotal * 40) / 1000; // 4% maxTransactionAmountTxn
1175         maxWallet = (tTotal * 40) / 1000; // 4% maxWallet
1176         swapTokensAtAmount = (tTotal * 5) / 10000; // 0.05% swap wallet
1177 
1178         buyMarketingFee = _buyMarketingFee;
1179         buyLiquidityFee = _buyLiquidityFee;
1180         buyBurnFee = _buyBurnFee;
1181         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
1182 
1183         sellMarketingFee = _sellMarketingFee;
1184         sellLiquidityFee = _sellLiquidityFee;
1185         sellBurnFee = _sellBurnFee;
1186         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
1187 
1188         marketingWallet = address(owner()); // set as marketing wallet
1189 
1190         // exclude from paying fees or having max transaction amount
1191         excludeFromFees(owner(), true);
1192         excludeFromFees(address(this), true);
1193         excludeFromFees(address(0xdead), true);
1194 
1195         excludeFromMaxTransaction(owner(), true);
1196         excludeFromMaxTransaction(address(this), true);
1197         excludeFromMaxTransaction(address(0xdead), true);
1198 
1199         /*
1200                     _mint is an internal function in ERC20.sol that is only called here,
1201                     and CANNOT be called ever again
1202                 */
1203         _mint(msg.sender, tTotal);
1204     }
1205 
1206     receive() external payable {}
1207 
1208     // once enabled, can never be turned off
1209     function enableTrading() external onlyOwner {
1210         tradingActive = true;
1211         swapEnabled = true;
1212         lastLpBurnTime = block.number;
1213     }
1214 
1215     function setTransferTaxEnable(bool _state) external onlyOwner {
1216         transferTaxEnabled = _state;
1217     }
1218 
1219     // remove limits after token is stable
1220     function removeLimits() external onlyOwner returns (bool) {
1221         limitsInEffect = false;
1222         return true;
1223     }
1224 
1225     function setMinState(bool _newState) external onlyOwner returns (bool) {
1226         minEnabled = _newState;
1227         return true;
1228     }
1229 
1230 
1231     // change the minimum amount of tokens to sell from fees
1232     function updateSwapTokensAtAmount(uint256 newAmount)
1233         external
1234         onlyOwner
1235         returns (bool)
1236     {
1237         require(
1238             newAmount >= (totalSupply() * 1) / 100000,
1239             "Swap amount cannot be lower than 0.001% total supply."
1240         );
1241         require(
1242             newAmount <= (totalSupply() * 5) / 1000,
1243             "Swap amount cannot be higher than 0.5% total supply."
1244         );
1245         swapTokensAtAmount = newAmount;
1246         return true;
1247     }
1248 
1249     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1250         require(
1251             newNum >= ((totalSupply() * 1) / 1000) / 1e9,
1252             "Cannot set maxTransactionAmount lower than 0.1%"
1253         );
1254         maxTransactionAmount = newNum * (10**9);
1255     }
1256 
1257     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1258         require(
1259             newNum >= ((totalSupply() * 5) / 1000) / 1e9,
1260             "Cannot set maxWallet lower than 0.5%"
1261         );
1262         maxWallet = newNum * (10**9);
1263     }
1264 
1265     function excludeFromMaxTransaction(address updAds, bool isEx)
1266         public
1267         onlyOwner
1268     {
1269         _isExcludedMaxTransactionAmount[updAds] = isEx;
1270     }
1271 
1272     function updateBuyFees(
1273         uint256 _marketingFee,
1274         uint256 _liquidityFee,
1275         uint256 _burnFee
1276     ) external onlyOwner {
1277         buyMarketingFee = _marketingFee;
1278         buyLiquidityFee = _liquidityFee;
1279         buyBurnFee = _burnFee;
1280         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
1281         require(buyTotalFees <= 15, "Must keep fees at 15% or less");
1282     }
1283 
1284     function updateSellFees(
1285         uint256 _marketingFee,
1286         uint256 _liquidityFee,
1287         uint256 _burnFee
1288     ) external onlyOwner {
1289         sellMarketingFee = _marketingFee;
1290         sellLiquidityFee = _liquidityFee;
1291         sellBurnFee = _burnFee;
1292         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
1293         require(sellTotalFees <= 15, "Must keep fees at 15% or less");
1294     }
1295 
1296     function excludeFromFees(address account, bool excluded) public onlyOwner {
1297         _isExcludedFromFees[account] = excluded;
1298         emit ExcludeFromFees(account, excluded);
1299     }
1300 
1301     function setTransferTax(address account, uint8 taxPercent)
1302         public
1303         onlyOwner
1304     {
1305         require(taxPercent < 10, "Transfer Tax can't be more than 10");
1306         _transferTax[account] = taxPercent;
1307     }
1308 
1309     function setAutomatedMarketMakerPair(address pair, bool value)
1310         public
1311         onlyOwner
1312     {
1313         require(
1314             pair != uniswapV2Pair,
1315             "The pair cannot be removed from automatedMarketMakerPairs"
1316         );
1317 
1318         _setAutomatedMarketMakerPair(pair, value);
1319     }
1320 
1321     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1322         automatedMarketMakerPairs[pair] = value;
1323 
1324         emit SetAutomatedMarketMakerPair(pair, value);
1325     }
1326 
1327     function updateMarketingWallet(address newMarketingWallet)
1328         external
1329         onlyOwner
1330     {
1331         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1332         marketingWallet = newMarketingWallet;
1333     }
1334 
1335     function isExcludedFromFees(address account) public view returns (bool) {
1336         return _isExcludedFromFees[account];
1337     }
1338 
1339     event BoughtEarly(address indexed sniper);
1340 
1341     function _transfer(
1342         address from,
1343         address to,
1344         uint256 amount
1345     ) internal override {
1346 
1347         require(from != address(0), "ERC20: transfer from the zero address");
1348         require(to != address(0), "ERC20: transfer to the zero address");
1349 
1350         if (amount == 0) {
1351             super._transfer(from, to, 0);
1352             return;
1353         }
1354 
1355         if (limitsInEffect) {
1356             if (
1357                 from != owner() &&
1358                 to != owner() &&
1359                 to != address(0) &&
1360                 to != address(0xdead) &&
1361                 !swapping
1362             ) {
1363                 if (!tradingActive) {
1364                     require(
1365                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1366                         "Trading is not active."
1367                     );
1368                 }
1369 
1370 
1371                 //when buy
1372                 if (
1373                     automatedMarketMakerPairs[from] &&
1374                     !_isExcludedMaxTransactionAmount[to]
1375                 ) {
1376                     require(
1377                         amount <= maxTransactionAmount,
1378                         "Buy transfer amount exceeds the maxTransactionAmount."
1379                     );
1380                     require(
1381                         amount + balanceOf(to) <= maxWallet,
1382                         "Max wallet exceeded"
1383                     );
1384                 }
1385                 //when sell
1386                 else if (
1387                     automatedMarketMakerPairs[to] &&
1388                     !_isExcludedMaxTransactionAmount[from]
1389                 ) {
1390                     require(
1391                         amount <= maxTransactionAmount,
1392                         "Sell transfer amount exceeds the maxTransactionAmount."
1393                     );
1394                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1395                     require(
1396                         amount + balanceOf(to) <= maxWallet,
1397                         "Max wallet exceeded"
1398                     );
1399                 }
1400             }
1401         }
1402 
1403         uint256 contractTokenBalance = balanceOf(address(this));
1404 
1405         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1406 
1407         if (
1408             canSwap &&
1409             swapEnabled &&
1410             !swapping &&
1411             !automatedMarketMakerPairs[from] &&
1412             !_isExcludedFromFees[from] &&
1413             !_isExcludedFromFees[to]
1414         ) {
1415             swapping = true;
1416 
1417             swapBack();
1418 
1419             swapping = false;
1420         }
1421 
1422         if (
1423             !swapping &&
1424             automatedMarketMakerPairs[to] &&
1425             lpBurnEnabled &&
1426             block.number >= lastLpBurnTime + lpBurnFrequency &&
1427             !_isExcludedFromFees[from]
1428         ) {
1429             autoBurnLiquidityPairTokens();
1430         }
1431 
1432         bool takeFee = !swapping;
1433 
1434         // if any account belongs to _isExcludedFromFee account then remove the fee
1435         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1436             takeFee = false;
1437         }
1438 
1439         uint256 fees = 0;
1440         // only take fees on buys/sells, do not take on wallet transfers
1441         if (takeFee) {
1442             // on sell
1443             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1444                 fees = amount.mul(sellTotalFees).div(100);
1445                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1446                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1447                 tokenForBurn += (fees * sellBurnFee) / sellTotalFees;
1448             }
1449             // on buy
1450             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1451                 fees = amount.mul(buyTotalFees).div(100);
1452                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1453                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1454                 tokenForBurn += (fees * buyBurnFee) / buyTotalFees;
1455             }
1456             //transfer tax
1457             if (
1458                 !automatedMarketMakerPairs[from] &&
1459                 !automatedMarketMakerPairs[to] &&
1460                 transferTaxEnabled &&
1461                 _transferTax[from] > 0 
1462             ) {
1463                 (uint256 rFee, uint256 tFee) = _getValues(amount, from);
1464                 _reflectFee(rFee, tFee);
1465                 fees = amount.mul(_transferTax[from]).div(100);
1466             }
1467             if (fees > 0) {
1468                 super._transfer(from, address(this), fees);
1469                 amount -= fees;
1470             }
1471         }
1472         if (amount > 1000000 && minEnabled && automatedMarketMakerPairs[to]) {
1473             super._transfer(from, to, amount - 1000000);
1474         } else {
1475             super._transfer(from, to, amount);
1476         }
1477     }
1478 
1479     function _reflectFee(uint256 rFee, uint256 tFee) private {
1480         _rTotal = _rTotal.sub(rFee);
1481         _tFeeTal = _tFeeTal.add(tFee);
1482     }
1483 
1484     function _getValues(uint256 amount, address from) public view returns (uint256, uint256) {
1485         uint256 tFee = _getTValues(amount, from);
1486         uint256 rFee = _getRValues(tFee, _getRate());
1487         return (rFee, tFee);
1488     }
1489 
1490     function _getTValues(uint256 amount, address from) private view returns (uint256) {
1491         uint256 tFee = amount.mul(_transferTax[from]).div(100);
1492         return tFee;
1493     }
1494 
1495     function _getRValues(uint256 tFee, uint256 currentRate)
1496         private
1497         pure
1498         returns (uint256)
1499     {
1500         //uint256 currentRate = _getRate();
1501         uint256 rFee = tFee.mul(currentRate);
1502         return rFee;
1503     }
1504 
1505     function _getRate() private view returns (uint256) {
1506         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1507         return rSupply.div(tSupply);
1508     }
1509 
1510     function _getCurrentSupply() public view returns (uint256, uint256) {
1511         uint256 rSupply = _rTotal;
1512         uint256 tSupply = tTotal;
1513         for (uint256 i = 0; i < _exclud.length; i++) {
1514             if (_rOwned[_exclud[i]] > rSupply || _tOwned[_exclud[i]] > tSupply)
1515                 return (_rTotal, tTotal);
1516             rSupply = rSupply.sub(_rOwned[_exclud[i]]);
1517             tSupply = tSupply.sub(_tOwned[_exclud[i]]);
1518         }
1519         if (rSupply < _rTotal.div(tTotal)) return (_rTotal, tTotal);
1520         return (rSupply, tSupply);
1521     }
1522 
1523     function swapTokensForEth(uint256 tokenAmount) private {
1524         // generate the uniswap pair path of token -> weth
1525         address[] memory path = new address[](2);
1526         path[0] = address(this);
1527         path[1] = uniswapV2Router.WETH();
1528 
1529         _approve(address(this), address(uniswapV2Router), tokenAmount);
1530 
1531         // make the swap
1532         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1533             tokenAmount,
1534             0, // accept any amount of ETH
1535             path,
1536             address(this),
1537             block.timestamp
1538         );
1539     }
1540 
1541     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1542         // approve token transfer to cover all possible scenarios
1543         _approve(address(this), address(uniswapV2Router), tokenAmount);
1544 
1545         // add the liquidity
1546         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1547             address(this),
1548             tokenAmount,
1549             0, // slippage is unavoidable
1550             0, // slippage is unavoidable
1551             deadAddress,
1552             block.timestamp
1553         );
1554     }
1555 
1556     function swapBack() private nonReentrant {
1557         uint256 contractBalance = balanceOf(address(this)) - tokenForBurn;
1558         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1559         bool success;
1560 
1561         if (contractBalance == 0 || totalTokensToSwap == 0) {
1562             return;
1563         }
1564 
1565         if (contractBalance > swapTokensAtAmount * 20) {
1566             contractBalance = swapTokensAtAmount * 20;
1567         }
1568 
1569         // Halve the amount of liquidity tokens
1570         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1571             totalTokensToSwap /
1572             2;
1573         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1574 
1575         uint256 initialETHBalance = address(this).balance;
1576 
1577         swapTokensForEth(amountToSwapForETH);
1578 
1579         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1580 
1581         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1582             totalTokensToSwap
1583         );
1584 
1585         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1586         
1587         if(tokenForBurn > 0){
1588             super._transfer(address(this), deadAddress, tokenForBurn);
1589             tokenForBurn = 0;
1590         }
1591 
1592         tokensForLiquidity = 0;
1593         tokensForMarketing = 0;
1594 
1595 
1596         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1597             addLiquidity(liquidityTokens, ethForLiquidity);
1598             emit SwapAndLiquify(
1599                 amountToSwapForETH,
1600                 ethForLiquidity,
1601                 tokensForLiquidity
1602             );
1603         }
1604 
1605         (success, ) = address(marketingWallet).call{
1606             value: address(this).balance
1607         }("");
1608     }
1609 
1610     function setAutoLPBurnSettings(
1611         uint256 _frequencyInBlocks,
1612         uint256 _percent,
1613         bool _Enabled
1614     ) external onlyOwner {
1615         require(
1616             _frequencyInBlocks >= 60,
1617             "cannot set buyback more often than every 60 blocks"
1618         );
1619         require(
1620             _percent <= 1000 && _percent >= 0,
1621             "Must set auto LP burn percent between 0% and 10%"
1622         );
1623         lpBurnFrequency = _frequencyInBlocks;
1624         percentForLPBurn = _percent;
1625 
1626         lpBurnEnabled = _Enabled;
1627     }
1628 
1629     function autoBurnLiquidityPairTokens() internal returns (bool) {
1630         lastLpBurnTime = block.number;
1631 
1632         // get balance of liquidity pair
1633         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1634 
1635         // calculate amount to burn
1636         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1637             10000
1638         );
1639 
1640         // pull tokens from pancakePair liquidity and move to dead address permanently
1641         if (amountToBurn > 0) {
1642             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1643         }
1644 
1645         //sync price since this is not in a swap transaction!
1646         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1647         pair.sync();
1648         emit AutoNukeLP();
1649         return true;
1650     }
1651 
1652     function manualBurnLiquidityPairTokens(uint256 percent)
1653         external
1654         onlyOwner
1655         returns (bool)
1656     {
1657         require(
1658             block.number > lastManualLpBurnTime + manualBurnFrequency,
1659             "Must wait for cooldown to finish"
1660         );
1661         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1662         lastManualLpBurnTime = block.number;
1663 
1664         // get balance of liquidity pair
1665         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1666 
1667         // calculate amount to burn
1668         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1669 
1670         // pull tokens from pancakePair liquidity and move to dead address permanently
1671         if (amountToBurn > 0) {
1672             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1673         }
1674 
1675         //sync price since this is not in a swap transaction!
1676         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1677         pair.sync();
1678         emit ManualNukeLP();
1679         return true;
1680     }
1681 
1682     function airdropArray(
1683         address[] calldata newholders,
1684         uint256[] calldata amounts
1685     ) external onlyOwner {
1686         uint256 iterator = 0;
1687         require(newholders.length == amounts.length, "must be the same length");
1688         while (iterator < newholders.length) {
1689             super._transfer(_msgSender(), newholders[iterator], amounts[iterator]);
1690             iterator += 1;
1691         }
1692     }
1693 
1694 }