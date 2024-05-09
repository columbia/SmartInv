1 // JOTARO TOKEN
2 // For All Anime Fans!
3 // Website: Jotarotoken.com
4 // https://t.me/JotaroToken
5 // Twitter: www.twitter.com/JotaroToken
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity 0.8.9;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 interface IUniswapV2Pair {
22     event Approval(
23         address indexed owner,
24         address indexed spender,
25         uint256 value
26     );
27     event Transfer(address indexed from, address indexed to, uint256 value);
28 
29     function name() external pure returns (string memory);
30 
31     function symbol() external pure returns (string memory);
32 
33     function decimals() external pure returns (uint8);
34 
35     function totalSupply() external view returns (uint256);
36 
37     function balanceOf(address owner) external view returns (uint256);
38 
39     function allowance(address owner, address spender)
40         external
41         view
42         returns (uint256);
43 
44     function approve(address spender, uint256 value) external returns (bool);
45 
46     function transfer(address to, uint256 value) external returns (bool);
47 
48     function transferFrom(
49         address from,
50         address to,
51         uint256 value
52     ) external returns (bool);
53 
54     function DOMAIN_SEPARATOR() external view returns (bytes32);
55 
56     function PERMIT_TYPEHASH() external pure returns (bytes32);
57 
58     function nonces(address owner) external view returns (uint256);
59 
60     function permit(
61         address owner,
62         address spender,
63         uint256 value,
64         uint256 deadline,
65         uint8 v,
66         bytes32 r,
67         bytes32 s
68     ) external;
69 
70     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
71     event Burn(
72         address indexed sender,
73         uint256 amount0,
74         uint256 amount1,
75         address indexed to
76     );
77     event Swap(
78         address indexed sender,
79         uint256 amount0In,
80         uint256 amount1In,
81         uint256 amount0Out,
82         uint256 amount1Out,
83         address indexed to
84     );
85     event Sync(uint112 reserve0, uint112 reserve1);
86 
87     function MINIMUM_LIQUIDITY() external pure returns (uint256);
88 
89     function factory() external view returns (address);
90 
91     function token0() external view returns (address);
92 
93     function token1() external view returns (address);
94 
95     function getReserves()
96         external
97         view
98         returns (
99             uint112 reserve0,
100             uint112 reserve1,
101             uint32 blockTimestampLast
102         );
103 
104     function price0CumulativeLast() external view returns (uint256);
105 
106     function price1CumulativeLast() external view returns (uint256);
107 
108     function kLast() external view returns (uint256);
109 
110     function mint(address to) external returns (uint256 liquidity);
111 
112     function burn(address to)
113         external
114         returns (uint256 amount0, uint256 amount1);
115 
116     function swap(
117         uint256 amount0Out,
118         uint256 amount1Out,
119         address to,
120         bytes calldata data
121     ) external;
122 
123     function skim(address to) external;
124 
125     function sync() external;
126 
127     function initialize(address, address) external;
128 }
129 
130 interface IUniswapV2Factory {
131     event PairCreated(
132         address indexed token0,
133         address indexed token1,
134         address pair,
135         uint256
136     );
137 
138     function feeTo() external view returns (address);
139 
140     function feeToSetter() external view returns (address);
141 
142     function getPair(address tokenA, address tokenB)
143         external
144         view
145         returns (address pair);
146 
147     function allPairs(uint256) external view returns (address pair);
148 
149     function allPairsLength() external view returns (uint256);
150 
151     function createPair(address tokenA, address tokenB)
152         external
153         returns (address pair);
154 
155     function setFeeTo(address) external;
156 
157     function setFeeToSetter(address) external;
158 }
159 
160 interface IERC20 {
161     /**
162      * @dev Returns the amount of tokens in existence.
163      */
164     function totalSupply() external view returns (uint256);
165 
166     /**
167      * @dev Returns the amount of tokens owned by `account`.
168      */
169     function balanceOf(address account) external view returns (uint256);
170 
171     /**
172      * @dev Moves `amount` tokens from the caller's account to `recipient`.
173      *
174      * Returns a boolean value indicating whether the operation succeeded.
175      *
176      * Emits a {Transfer} event.
177      */
178     function transfer(address recipient, uint256 amount)
179         external
180         returns (bool);
181 
182     /**
183      * @dev Returns the remaining number of tokens that `spender` will be
184      * allowed to spend on behalf of `owner` through {transferFrom}. This is
185      * zero by default.
186      *
187      * This value changes when {approve} or {transferFrom} are called.
188      */
189     function allowance(address owner, address spender)
190         external
191         view
192         returns (uint256);
193 
194     /**
195      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
196      *
197      * Returns a boolean value indicating whether the operation succeeded.
198      *
199      * IMPORTANT: Beware that changing an allowance with this method brings the risk
200      * that someone may use both the old and the new allowance by unfortunate
201      * transaction ordering. One possible solution to mitigate this race
202      * condition is to first reduce the spender's allowance to 0 and set the
203      * desired value afterwards:
204      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
205      *
206      * Emits an {Approval} event.
207      */
208     function approve(address spender, uint256 amount) external returns (bool);
209 
210     /**
211      * @dev Moves `amount` tokens from `sender` to `recipient` using the
212      * allowance mechanism. `amount` is then deducted from the caller's
213      * allowance.
214      *
215      * Returns a boolean value indicating whether the operation succeeded.
216      *
217      * Emits a {Transfer} event.
218      */
219     function transferFrom(
220         address sender,
221         address recipient,
222         uint256 amount
223     ) external returns (bool);
224 
225     /**
226      * @dev Emitted when `value` tokens are moved from one account (`from`) to
227      * another (`to`).
228      *
229      * Note that `value` may be zero.
230      */
231     event Transfer(address indexed from, address indexed to, uint256 value);
232 
233     /**
234      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
235      * a call to {approve}. `value` is the new allowance.
236      */
237     event Approval(
238         address indexed owner,
239         address indexed spender,
240         uint256 value
241     );
242 }
243 
244 interface IERC20Metadata is IERC20 {
245     /**
246      * @dev Returns the name of the token.
247      */
248     function name() external view returns (string memory);
249 
250     /**
251      * @dev Returns the symbol of the token.
252      */
253     function symbol() external view returns (string memory);
254 
255     /**
256      * @dev Returns the decimals places of the token.
257      */
258     function decimals() external view returns (uint8);
259 }
260 
261 contract ERC20 is Context, IERC20, IERC20Metadata {
262     using SafeMath for uint256;
263 
264     mapping(address => uint256) private _balances;
265 
266     mapping(address => mapping(address => uint256)) private _allowances;
267 
268     uint256 private _totalSupply;
269 
270     string private _name;
271     string private _symbol;
272 
273     /**
274      * @dev Sets the values for {name} and {symbol}.
275      *
276      * The default value of {decimals} is 9. To select a different value for
277      * {decimals} you should overload it.
278      *
279      * All two of these values are immutable: they can only be set once during
280      * construction.
281      */
282     constructor(string memory name_, string memory symbol_) {
283         _name = name_;
284         _symbol = symbol_;
285     }
286 
287     /**
288      * @dev Returns the name of the token.
289      */
290     function name() public view virtual override returns (string memory) {
291         return _name;
292     }
293 
294     /**
295      * @dev Returns the symbol of the token, usually a shorter version of the
296      * name.
297      */
298     function symbol() public view virtual override returns (string memory) {
299         return _symbol;
300     }
301 
302     /**
303      * @dev Returns the number of decimals used to get its user representation.
304      * For example, if `decimals` equals `2`, a balance of `505` tokens should
305      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
306      *
307      * Tokens usually opt for a value of 18, imitating the relationship between
308      * Ether and Wei. This is the value {ERC20} uses, unless this function is
309      * overridden;
310      *
311      * NOTE: This information is only used for _display_ purposes: it in
312      * no way affects any of the arithmetic of the contract, including
313      * {IERC20-balanceOf} and {IERC20-transfer}.
314      */
315     function decimals() public view virtual override returns (uint8) {
316         return 9;
317     }
318 
319     /**
320      * @dev See {IERC20-totalSupply}.
321      */
322     function totalSupply() public view virtual override returns (uint256) {
323         return _totalSupply;
324     }
325 
326     /**
327      * @dev See {IERC20-balanceOf}.
328      */
329     function balanceOf(address account)
330         public
331         view
332         virtual
333         override
334         returns (uint256)
335     {
336         return _balances[account];
337     }
338 
339     /**
340      * @dev See {IERC20-transfer}.
341      *
342      * Requirements:
343      *
344      * - `recipient` cannot be the zero address.
345      * - the caller must have a balance of at least `amount`.
346      */
347     function transfer(address recipient, uint256 amount)
348         public
349         virtual
350         override
351         returns (bool)
352     {
353         _transfer(_msgSender(), recipient, amount);
354         return true;
355     }
356 
357     /**
358      * @dev See {IERC20-allowance}.
359      */
360     function allowance(address owner, address spender)
361         public
362         view
363         virtual
364         override
365         returns (uint256)
366     {
367         return _allowances[owner][spender];
368     }
369 
370     /**
371      * @dev See {IERC20-approve}.
372      *
373      * Requirements:
374      *
375      * - `spender` cannot be the zero address.
376      */
377     function approve(address spender, uint256 amount)
378         public
379         virtual
380         override
381         returns (bool)
382     {
383         _approve(_msgSender(), spender, amount);
384         return true;
385     }
386 
387     /**
388      * @dev See {IERC20-transferFrom}.
389      *
390      * Emits an {Approval} event indicating the updated allowance. This is not
391      * required by the EIP. See the note at the beginning of {ERC20}.
392      *
393      * Requirements:
394      *
395      * - `sender` and `recipient` cannot be the zero address.
396      * - `sender` must have a balance of at least `amount`.
397      * - the caller must have allowance for ``sender``'s tokens of at least
398      * `amount`.
399      */
400     function transferFrom(
401         address sender,
402         address recipient,
403         uint256 amount
404     ) public virtual override returns (bool) {
405         _transfer(sender, recipient, amount);
406         _approve(
407             sender,
408             _msgSender(),
409             _allowances[sender][_msgSender()].sub(
410                 amount,
411                 "ERC20: transfer amount exceeds allowance"
412             )
413         );
414         return true;
415     }
416 
417     /**
418      * @dev Atomically increases the allowance granted to `spender` by the caller.
419      *
420      * This is an alternative to {approve} that can be used as a mitigation for
421      * problems described in {IERC20-approve}.
422      *
423      * Emits an {Approval} event indicating the updated allowance.
424      *
425      * Requirements:
426      *
427      * - `spender` cannot be the zero address.
428      */
429     function increaseAllowance(address spender, uint256 addedValue)
430         public
431         virtual
432         returns (bool)
433     {
434         _approve(
435             _msgSender(),
436             spender,
437             _allowances[_msgSender()][spender].add(addedValue)
438         );
439         return true;
440     }
441 
442     /**
443      * @dev Atomically decreases the allowance granted to `spender` by the caller.
444      *
445      * This is an alternative to {approve} that can be used as a mitigation for
446      * problems described in {IERC20-approve}.
447      *
448      * Emits an {Approval} event indicating the updated allowance.
449      *
450      * Requirements:
451      *
452      * - `spender` cannot be the zero address.
453      * - `spender` must have allowance for the caller of at least
454      * `subtractedValue`.
455      */
456     function decreaseAllowance(address spender, uint256 subtractedValue)
457         public
458         virtual
459         returns (bool)
460     {
461         _approve(
462             _msgSender(),
463             spender,
464             _allowances[_msgSender()][spender].sub(
465                 subtractedValue,
466                 "ERC20: decreased allowance below zero"
467             )
468         );
469         return true;
470     }
471 
472     /**
473      * @dev Moves tokens `amount` from `sender` to `recipient`.
474      *
475      * This is internal function is equivalent to {transfer}, and can be used to
476      * e.g. implement automatic token fees, slashing mechanisms, etc.
477      *
478      * Emits a {Transfer} event.
479      *
480      * Requirements:
481      *
482      * - `sender` cannot be the zero address.
483      * - `recipient` cannot be the zero address.
484      * - `sender` must have a balance of at least `amount`.
485      */
486     function _transfer(
487         address sender,
488         address recipient,
489         uint256 amount
490     ) internal virtual {
491         require(sender != address(0), "ERC20: transfer from the zero address");
492         require(recipient != address(0), "ERC20: transfer to the zero address");
493 
494         _beforeTokenTransfer(sender, recipient, amount);
495 
496         _balances[sender] = _balances[sender].sub(
497             amount,
498             "ERC20: transfer amount exceeds balance"
499         );
500         _balances[recipient] = _balances[recipient].add(amount);
501         emit Transfer(sender, recipient, amount);
502     }
503 
504     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
505      * the total supply.
506      *
507      * Emits a {Transfer} event with `from` set to the zero address.
508      *
509      * Requirements:
510      *
511      * - `account` cannot be the zero address.
512      */
513     function _mint(address account, uint256 amount) internal virtual {
514         require(account != address(0), "ERC20: mint to the zero address");
515 
516         _beforeTokenTransfer(address(0), account, amount);
517 
518         _totalSupply = _totalSupply.add(amount);
519         _balances[account] = _balances[account].add(amount);
520         emit Transfer(address(0), account, amount);
521     }
522 
523     /**
524      * @dev Destroys `amount` tokens from `account`, reducing the
525      * total supply.
526      *
527      * Emits a {Transfer} event with `to` set to the zero address.
528      *
529      * Requirements:
530      *
531      * - `account` cannot be the zero address.
532      * - `account` must have at least `amount` tokens.
533      */
534     function _burn(address account, uint256 amount) internal virtual {
535         require(account != address(0), "ERC20: burn from the zero address");
536 
537         _beforeTokenTransfer(account, address(0), amount);
538 
539         _balances[account] = _balances[account].sub(
540             amount,
541             "ERC20: burn amount exceeds balance"
542         );
543         _totalSupply = _totalSupply.sub(amount);
544         emit Transfer(account, address(0), amount);
545     }
546 
547     /**
548      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
549      *
550      * This internal function is equivalent to `approve`, and can be used to
551      * e.g. set automatic allowances for certain subsystems, etc.
552      *
553      * Emits an {Approval} event.
554      *
555      * Requirements:
556      *
557      * - `owner` cannot be the zero address.
558      * - `spender` cannot be the zero address.
559      */
560     function _approve(
561         address owner,
562         address spender,
563         uint256 amount
564     ) internal virtual {
565         require(owner != address(0), "ERC20: approve from the zero address");
566         require(spender != address(0), "ERC20: approve to the zero address");
567 
568         _allowances[owner][spender] = amount;
569         emit Approval(owner, spender, amount);
570     }
571 
572     /**
573      * @dev Hook that is called before any transfer of tokens. This includes
574      * minting and burning.
575      *
576      * Calling conditions:
577      *
578      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
579      * will be to transferred to `to`.
580      * - when `from` is zero, `amount` tokens will be minted for `to`.
581      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
582      * - `from` and `to` are never both zero.
583      *
584      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
585      */
586     function _beforeTokenTransfer(
587         address from,
588         address to,
589         uint256 amount
590     ) internal virtual {}
591 }
592 
593 library SafeMath {
594     /**
595      * @dev Returns the addition of two unsigned integers, reverting on
596      * overflow.
597      *
598      * Counterpart to Solidity's `+` operator.
599      *
600      * Requirements:
601      *
602      * - Addition cannot overflow.
603      */
604     function add(uint256 a, uint256 b) internal pure returns (uint256) {
605         uint256 c = a + b;
606         require(c >= a, "SafeMath: addition overflow");
607 
608         return c;
609     }
610 
611     /**
612      * @dev Returns the subtraction of two unsigned integers, reverting on
613      * overflow (when the result is negative).
614      *
615      * Counterpart to Solidity's `-` operator.
616      *
617      * Requirements:
618      *
619      * - Subtraction cannot overflow.
620      */
621     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
622         return sub(a, b, "SafeMath: subtraction overflow");
623     }
624 
625     /**
626      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
627      * overflow (when the result is negative).
628      *
629      * Counterpart to Solidity's `-` operator.
630      *
631      * Requirements:
632      *
633      * - Subtraction cannot overflow.
634      */
635     function sub(
636         uint256 a,
637         uint256 b,
638         string memory errorMessage
639     ) internal pure returns (uint256) {
640         require(b <= a, errorMessage);
641         uint256 c = a - b;
642 
643         return c;
644     }
645 
646     /**
647      * @dev Returns the multiplication of two unsigned integers, reverting on
648      * overflow.
649      *
650      * Counterpart to Solidity's `*` operator.
651      *
652      * Requirements:
653      *
654      * - Multiplication cannot overflow.
655      */
656     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
657         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
658         // benefit is lost if 'b' is also tested.
659         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
660         if (a == 0) {
661             return 0;
662         }
663 
664         uint256 c = a * b;
665         require(c / a == b, "SafeMath: multiplication overflow");
666 
667         return c;
668     }
669 
670     /**
671      * @dev Returns the integer division of two unsigned integers. Reverts on
672      * division by zero. The result is rounded towards zero.
673      *
674      * Counterpart to Solidity's `/` operator. Note: this function uses a
675      * `revert` opcode (which leaves remaining gas untouched) while Solidity
676      * uses an invalid opcode to revert (consuming all remaining gas).
677      *
678      * Requirements:
679      *
680      * - The divisor cannot be zero.
681      */
682     function div(uint256 a, uint256 b) internal pure returns (uint256) {
683         return div(a, b, "SafeMath: division by zero");
684     }
685 
686     /**
687      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
688      * division by zero. The result is rounded towards zero.
689      *
690      * Counterpart to Solidity's `/` operator. Note: this function uses a
691      * `revert` opcode (which leaves remaining gas untouched) while Solidity
692      * uses an invalid opcode to revert (consuming all remaining gas).
693      *
694      * Requirements:
695      *
696      * - The divisor cannot be zero.
697      */
698     function div(
699         uint256 a,
700         uint256 b,
701         string memory errorMessage
702     ) internal pure returns (uint256) {
703         require(b > 0, errorMessage);
704         uint256 c = a / b;
705 
706         return c;
707     }
708 
709     /**
710      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
711      * Reverts when dividing by zero.
712      *
713      * Counterpart to Solidity's `%` operator. This function uses a `revert`
714      * opcode (which leaves remaining gas untouched) while Solidity uses an
715      * invalid opcode to revert (consuming all remaining gas).
716      *
717      * Requirements:
718      *
719      * - The divisor cannot be zero.
720      */
721     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
722         return mod(a, b, "SafeMath: modulo by zero");
723     }
724 
725     /**
726      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
727      * Reverts with custom message when dividing by zero.
728      *
729      * Counterpart to Solidity's `%` operator. This function uses a `revert`
730      * opcode (which leaves remaining gas untouched) while Solidity uses an
731      * invalid opcode to revert (consuming all remaining gas).
732      *
733      * Requirements:
734      *
735      * - The divisor cannot be zero.
736      */
737     function mod(
738         uint256 a,
739         uint256 b,
740         string memory errorMessage
741     ) internal pure returns (uint256) {
742         require(b != 0, errorMessage);
743         return a % b;
744     }
745 }
746 
747 contract Ownable is Context {
748     address private _owner;
749 
750     event OwnershipTransferred(
751         address indexed previousOwner,
752         address indexed newOwner
753     );
754 
755     /**
756      * @dev Initializes the contract setting the deployer as the initial owner.
757      */
758     constructor() {
759         address msgSender = _msgSender();
760         _owner = msgSender;
761         emit OwnershipTransferred(address(0), msgSender);
762     }
763 
764     /**
765      * @dev Returns the address of the current owner.
766      */
767     function owner() public view returns (address) {
768         return _owner;
769     }
770 
771     /**
772      * @dev Throws if called by any account other than the owner.
773      */
774     modifier onlyOwner() {
775         require(_owner == _msgSender(), "Ownable: caller is not the owner");
776         _;
777     }
778 
779     /**
780      * @dev Leaves the contract without owner. It will not be possible to call
781      * `onlyOwner` functions anymore. Can only be called by the current owner.
782      *
783      * NOTE: Renouncing ownership will leave the contract without an owner,
784      * thereby removing any functionality that is only available to the owner.
785      */
786     function renounceOwnership() public virtual onlyOwner {
787         emit OwnershipTransferred(_owner, address(0));
788         _owner = address(0);
789     }
790 
791     /**
792      * @dev Transfers ownership of the contract to a new account (`newOwner`).
793      * Can only be called by the current owner.
794      */
795     function transferOwnership(address newOwner) public virtual onlyOwner {
796         require(
797             newOwner != address(0),
798             "Ownable: new owner is the zero address"
799         );
800         emit OwnershipTransferred(_owner, newOwner);
801         _owner = newOwner;
802     }
803 }
804 
805 
806 abstract contract ReentrancyGuard {
807     // Booleans are more expensive than uint256 or any type that takes up a full
808     // word because each write operation emits an extra SLOAD to first read the
809     // slot's contents, replace the bits taken up by the boolean, and then write
810     // back. This is the compiler's defense against contract upgrades and
811     // pointer aliasing, and it cannot be disabled.
812 
813     // The values being non-zero value makes deployment a bit more expensive,
814     // but in exchange the refund on every call to nonReentrant will be lower in
815     // amount. Since refunds are capped to a percentage of the total
816     // transaction's gas, it is best to keep them low in cases like this one, to
817     // increase the likelihood of the full refund coming into effect.
818     uint256 private constant _NOT_ENTERED = 1;
819     uint256 private constant _ENTERED = 2;
820 
821     uint256 private _status;
822 
823     constructor() {
824         _status = _NOT_ENTERED;
825     }
826 
827     /**
828      * @dev Prevents a contract from calling itself, directly or indirectly.
829      * Calling a `nonReentrant` function from another `nonReentrant`
830      * function is not supported. It is possible to prevent this from happening
831      * by making the `nonReentrant` function external, and making it call a
832      * `private` function that does the actual work.
833      */
834     modifier nonReentrant() {
835         _nonReentrantBefore();
836         _;
837         _nonReentrantAfter();
838     }
839 
840     function _nonReentrantBefore() private {
841         // On the first call to nonReentrant, _status will be _NOT_ENTERED
842         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
843 
844         // Any calls to nonReentrant after this point will fail
845         _status = _ENTERED;
846     }
847 
848     function _nonReentrantAfter() private {
849         // By storing the original value once again, a refund is triggered (see
850         // https://eips.ethereum.org/EIPS/eip-2200)
851         _status = _NOT_ENTERED;
852     }
853 }
854 
855 interface IUniswapV2Router01 {
856     function factory() external pure returns (address);
857 
858     function WETH() external pure returns (address);
859 
860     function addLiquidity(
861         address tokenA,
862         address tokenB,
863         uint256 amountADesired,
864         uint256 amountBDesired,
865         uint256 amountAMin,
866         uint256 amountBMin,
867         address to,
868         uint256 deadline
869     )
870         external
871         returns (
872             uint256 amountA,
873             uint256 amountB,
874             uint256 liquidity
875         );
876 
877     function addLiquidityETH(
878         address token,
879         uint256 amountTokenDesired,
880         uint256 amountTokenMin,
881         uint256 amountETHMin,
882         address to,
883         uint256 deadline
884     )
885         external
886         payable
887         returns (
888             uint256 amountToken,
889             uint256 amountETH,
890             uint256 liquidity
891         );
892 
893     function removeLiquidity(
894         address tokenA,
895         address tokenB,
896         uint256 liquidity,
897         uint256 amountAMin,
898         uint256 amountBMin,
899         address to,
900         uint256 deadline
901     ) external returns (uint256 amountA, uint256 amountB);
902 
903     function removeLiquidityETH(
904         address token,
905         uint256 liquidity,
906         uint256 amountTokenMin,
907         uint256 amountETHMin,
908         address to,
909         uint256 deadline
910     ) external returns (uint256 amountToken, uint256 amountETH);
911 
912     function removeLiquidityWithPermit(
913         address tokenA,
914         address tokenB,
915         uint256 liquidity,
916         uint256 amountAMin,
917         uint256 amountBMin,
918         address to,
919         uint256 deadline,
920         bool approveMax,
921         uint8 v,
922         bytes32 r,
923         bytes32 s
924     ) external returns (uint256 amountA, uint256 amountB);
925 
926     function removeLiquidityETHWithPermit(
927         address token,
928         uint256 liquidity,
929         uint256 amountTokenMin,
930         uint256 amountETHMin,
931         address to,
932         uint256 deadline,
933         bool approveMax,
934         uint8 v,
935         bytes32 r,
936         bytes32 s
937     ) external returns (uint256 amountToken, uint256 amountETH);
938 
939     function swapExactTokensForTokens(
940         uint256 amountIn,
941         uint256 amountOutMin,
942         address[] calldata path,
943         address to,
944         uint256 deadline
945     ) external returns (uint256[] memory amounts);
946 
947     function swapTokensForExactTokens(
948         uint256 amountOut,
949         uint256 amountInMax,
950         address[] calldata path,
951         address to,
952         uint256 deadline
953     ) external returns (uint256[] memory amounts);
954 
955     function swapExactETHForTokens(
956         uint256 amountOutMin,
957         address[] calldata path,
958         address to,
959         uint256 deadline
960     ) external payable returns (uint256[] memory amounts);
961 
962     function swapTokensForExactETH(
963         uint256 amountOut,
964         uint256 amountInMax,
965         address[] calldata path,
966         address to,
967         uint256 deadline
968     ) external returns (uint256[] memory amounts);
969 
970     function swapExactTokensForETH(
971         uint256 amountIn,
972         uint256 amountOutMin,
973         address[] calldata path,
974         address to,
975         uint256 deadline
976     ) external returns (uint256[] memory amounts);
977 
978     function swapETHForExactTokens(
979         uint256 amountOut,
980         address[] calldata path,
981         address to,
982         uint256 deadline
983     ) external payable returns (uint256[] memory amounts);
984 
985     function quote(
986         uint256 amountA,
987         uint256 reserveA,
988         uint256 reserveB
989     ) external pure returns (uint256 amountB);
990 
991     function getAmountOut(
992         uint256 amountIn,
993         uint256 reserveIn,
994         uint256 reserveOut
995     ) external pure returns (uint256 amountOut);
996 
997     function getAmountIn(
998         uint256 amountOut,
999         uint256 reserveIn,
1000         uint256 reserveOut
1001     ) external pure returns (uint256 amountIn);
1002 
1003     function getAmountsOut(uint256 amountIn, address[] calldata path)
1004         external
1005         view
1006         returns (uint256[] memory amounts);
1007 
1008     function getAmountsIn(uint256 amountOut, address[] calldata path)
1009         external
1010         view
1011         returns (uint256[] memory amounts);
1012 }
1013 
1014 interface IUniswapV2Router02 is IUniswapV2Router01 {
1015     function removeLiquidityETHSupportingFeeOnTransferTokens(
1016         address token,
1017         uint256 liquidity,
1018         uint256 amountTokenMin,
1019         uint256 amountETHMin,
1020         address to,
1021         uint256 deadline
1022     ) external returns (uint256 amountETH);
1023 
1024     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1025         address token,
1026         uint256 liquidity,
1027         uint256 amountTokenMin,
1028         uint256 amountETHMin,
1029         address to,
1030         uint256 deadline,
1031         bool approveMax,
1032         uint8 v,
1033         bytes32 r,
1034         bytes32 s
1035     ) external returns (uint256 amountETH);
1036 
1037     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1038         uint256 amountIn,
1039         uint256 amountOutMin,
1040         address[] calldata path,
1041         address to,
1042         uint256 deadline
1043     ) external;
1044 
1045     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1046         uint256 amountOutMin,
1047         address[] calldata path,
1048         address to,
1049         uint256 deadline
1050     ) external payable;
1051 
1052     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1053         uint256 amountIn,
1054         uint256 amountOutMin,
1055         address[] calldata path,
1056         address to,
1057         uint256 deadline
1058     ) external;
1059 }
1060 
1061 contract JotaroToken is ERC20, Ownable, ReentrancyGuard {
1062     using SafeMath for uint256;
1063 
1064     IUniswapV2Router02 public immutable uniswapV2Router;
1065     address public immutable uniswapV2Pair;
1066     address public constant deadAddress = address(0xdead);
1067 
1068     bool private swapping;
1069 
1070     address public marketingWallet;
1071 
1072     uint256 public maxTransactionAmount;
1073     uint256 public swapTokensAtAmount;
1074     uint256 public maxWallet;
1075 
1076     uint256 public MaxWalletValue;
1077     uint256 public percentForLPBurn = 25; // 25 = .25%
1078     bool public lpBurnEnabled = false;
1079     uint256 public lpBurnFrequency = 3600 / 12;
1080     uint256 public lastLpBurnTime;
1081 
1082     uint256 public manualBurnFrequency = 180000 / 12;
1083     uint256 public lastManualLpBurnTime;
1084 
1085     bool public limitsInEffect = true;
1086     bool public tradingActive = false;
1087     bool public swapEnabled = false;
1088     // Anti-bot and anti-whale mappings and variables
1089     bool private minEnabled = true;
1090     bool private transferTaxEnabled = true;
1091 
1092     uint256 public buyTotalFees;
1093     // uint256 public buytax;
1094     uint256 public buyMarketingFee;
1095     uint256 public buyLiquidityFee;
1096     uint256 public buyBurnFee;
1097 
1098     uint256 public sellTotalFees;
1099     //uint256 public selltax;
1100     uint256 public sellMarketingFee;
1101     uint256 public sellLiquidityFee;
1102     uint256 public sellBurnFee;
1103 
1104     uint256 public tokensForMarketing;
1105     uint256 public tokensForLiquidity;
1106     uint256 public tokenForBurn;
1107 
1108     uint256 constant MAX = ~uint256(0);
1109     uint256 public _rTotal;
1110     uint256 public tTotal;
1111     uint256 public _tFeeTal;
1112 
1113     address[] public _exclud;
1114     mapping(address => uint256) private _rOwned;
1115     mapping(address => uint256) private _tOwned;
1116 
1117     // exlcude from fees and max transaction amount
1118     mapping(address => bool) private _isExcludedFromFees;
1119     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1120     mapping(address => uint8) public _transferTax;
1121 
1122     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1123     // could be subject to a maximum transfer amount
1124     mapping(address => bool) public automatedMarketMakerPairs;
1125 
1126     event UpdateUniswapV2Router(
1127         address indexed newAddress,
1128         address indexed oldAddress
1129     );
1130 
1131     event ExcludeFromFees(address indexed account, bool isExcluded);
1132 
1133     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1134 
1135     event marketingWalletUpdated(
1136         address indexed newWallet,
1137         address indexed oldWallet
1138     );
1139 
1140     event devWalletUpdated(
1141         address indexed newWallet,
1142         address indexed oldWallet
1143     );
1144 
1145     event SwapAndLiquify(
1146         uint256 tokensSwapped,
1147         uint256 ethReceived,
1148         uint256 tokensIntoLiquidity
1149     );
1150 
1151     event AutoNukeLP();
1152 
1153     event ManualNukeLP();
1154 
1155     constructor() ERC20("Jotaro Token", "JOTARO") {
1156         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1157             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D 
1158         );
1159 
1160         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1161         uniswapV2Router = _uniswapV2Router;
1162 
1163         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1164             .createPair(address(this), _uniswapV2Router.WETH());
1165         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1166         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1167 
1168         uint256 _buyMarketingFee = 0;
1169         uint256 _buyLiquidityFee = 0;
1170         uint256 _buyBurnFee = 0;
1171 
1172         uint256 _sellMarketingFee = 0;
1173         uint256 _sellLiquidityFee = 0;
1174         uint256 _sellBurnFee = 0;
1175 
1176         //tTotal = x * 1e9;
1177         tTotal = 469000000000 * 1e9;
1178         _rTotal = (MAX - (MAX % tTotal));
1179 
1180         maxTransactionAmount = (tTotal * 50) / 1000; // 5% maxTransactionAmountTxn
1181         maxWallet = (tTotal * 70) / 1000; // 7% maxWallet
1182         swapTokensAtAmount = (tTotal * 5) / 10000; // 0.05% swap wallet
1183 
1184         buyMarketingFee = _buyMarketingFee;
1185         buyLiquidityFee = _buyLiquidityFee;
1186         buyBurnFee = _buyBurnFee;
1187         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
1188 
1189         sellMarketingFee = _sellMarketingFee;
1190         sellLiquidityFee = _sellLiquidityFee;
1191         sellBurnFee = _sellBurnFee;
1192         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
1193 
1194         marketingWallet = address(owner()); // set as marketing wallet
1195 
1196         // exclude from paying fees or having max transaction amount
1197         excludeFromFees(owner(), true);
1198         excludeFromFees(address(this), true);
1199         excludeFromFees(address(0xdead), true);
1200 
1201         excludeFromMaxTransaction(owner(), true);
1202         excludeFromMaxTransaction(address(this), true);
1203         excludeFromMaxTransaction(address(0xdead), true);
1204 
1205         /*
1206                     _mint is an internal function in ERC20.sol that is only called here,
1207                     and CANNOT be called ever again
1208                 */
1209         _mint(msg.sender, tTotal);
1210     }
1211 
1212     receive() external payable {}
1213 
1214     // once enabled, can never be turned off
1215     function enableTrading() external onlyOwner {
1216         tradingActive = true;
1217         swapEnabled = true;
1218         lastLpBurnTime = block.number;
1219     }
1220 
1221     function setTransferTaxEnable(bool _state) external onlyOwner {
1222         transferTaxEnabled = _state;
1223     }
1224 
1225     // remove limits after token is stable
1226     function removeLimits() external onlyOwner returns (bool) {
1227         limitsInEffect = false;
1228         return true;
1229     }
1230 
1231     function setMinState(bool _newState) external onlyOwner returns (bool) {
1232         minEnabled = _newState;
1233         return true;
1234     }
1235 
1236 
1237     // change the minimum amount of tokens to sell from fees
1238     function updateSwapTokensAtAmount(uint256 newAmount)
1239         external
1240         onlyOwner
1241         returns (bool)
1242     {
1243         require(
1244             newAmount >= (totalSupply() * 1) / 100000,
1245             "Swap amount cannot be lower than 0.001% total supply."
1246         );
1247         require(
1248             newAmount <= (totalSupply() * 5) / 1000,
1249             "Swap amount cannot be higher than 0.5% total supply."
1250         );
1251         swapTokensAtAmount = newAmount;
1252         return true;
1253     }
1254 
1255     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1256         require(
1257             newNum >= ((totalSupply() * 1) / 1000) / 1e9,
1258             "Cannot set maxTransactionAmount lower than 0.1%"
1259         );
1260         maxTransactionAmount = newNum * (10**9);
1261     }
1262 
1263     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1264         require(
1265             newNum >= ((totalSupply() * 5) / 1000) / 1e9,
1266             "Cannot set maxWallet lower than 0.5%"
1267         );
1268         maxWallet = newNum * (10**9);
1269     }
1270 
1271     function excludeFromMaxTransaction(address updAds, bool isEx)
1272         public
1273         onlyOwner
1274     {
1275         _isExcludedMaxTransactionAmount[updAds] = isEx;
1276     }
1277 
1278     function updateBuyFees(
1279         uint256 _marketingFee,
1280         uint256 _liquidityFee,
1281         uint256 _burnFee
1282     ) external onlyOwner {
1283         buyMarketingFee = _marketingFee;
1284         buyLiquidityFee = _liquidityFee;
1285         buyBurnFee = _burnFee;
1286         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
1287         require(buyTotalFees <= 3, "Must keep fees at 3% or less");
1288     }
1289 
1290     function updateSellFees(
1291         uint256 _marketingFee,
1292         uint256 _liquidityFee,
1293         uint256 _burnFee
1294     ) external onlyOwner {
1295         sellMarketingFee = _marketingFee;
1296         sellLiquidityFee = _liquidityFee;
1297         sellBurnFee = _burnFee;
1298         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
1299         require(sellTotalFees <= 6, "Must keep fees at 6% or less");
1300     }
1301 
1302     function excludeFromFees(address account, bool excluded) public onlyOwner {
1303         _isExcludedFromFees[account] = excluded;
1304         emit ExcludeFromFees(account, excluded);
1305     }
1306 
1307     function setTransferTax(address account, uint8 taxPercent)
1308         public
1309         onlyOwner
1310     {
1311         require(taxPercent < 10, "Transfer Tax can't be more than 10");
1312         _transferTax[account] = taxPercent;
1313     }
1314 
1315     function setAutomatedMarketMakerPair(address pair, bool value)
1316         public
1317         onlyOwner
1318     {
1319         require(
1320             pair != uniswapV2Pair,
1321             "The pair cannot be removed from automatedMarketMakerPairs"
1322         );
1323 
1324         _setAutomatedMarketMakerPair(pair, value);
1325     }
1326 
1327     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1328         automatedMarketMakerPairs[pair] = value;
1329 
1330         emit SetAutomatedMarketMakerPair(pair, value);
1331     }
1332 
1333     function updateMarketingWallet(address newMarketingWallet)
1334         external
1335         onlyOwner
1336     {
1337         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1338         marketingWallet = newMarketingWallet;
1339     }
1340 
1341     function isExcludedFromFees(address account) public view returns (bool) {
1342         return _isExcludedFromFees[account];
1343     }
1344 
1345     event BoughtEarly(address indexed sniper);
1346 
1347     function _transfer(
1348         address from,
1349         address to,
1350         uint256 amount
1351     ) internal override {
1352 
1353         require(from != address(0), "ERC20: transfer from the zero address");
1354         require(to != address(0), "ERC20: transfer to the zero address");
1355 
1356         if (amount == 0) {
1357             super._transfer(from, to, 0);
1358             return;
1359         }
1360 
1361         if (limitsInEffect) {
1362             if (
1363                 from != owner() &&
1364                 to != owner() &&
1365                 to != address(0) &&
1366                 to != address(0xdead) &&
1367                 !swapping
1368             ) {
1369                 if (!tradingActive) {
1370                     require(
1371                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1372                         "Trading is not active."
1373                     );
1374                 }
1375 
1376 
1377                 //when buy
1378                 if (
1379                     automatedMarketMakerPairs[from] &&
1380                     !_isExcludedMaxTransactionAmount[to]
1381                 ) {
1382                     require(
1383                         amount <= maxTransactionAmount,
1384                         "Buy transfer amount exceeds the maxTransactionAmount."
1385                     );
1386                     require(
1387                         amount + balanceOf(to) <= maxWallet,
1388                         "Max wallet exceeded"
1389                     );
1390                 }
1391                 //when sell
1392                 else if (
1393                     automatedMarketMakerPairs[to] &&
1394                     !_isExcludedMaxTransactionAmount[from]
1395                 ) {
1396                     require(
1397                         amount <= maxTransactionAmount,
1398                         "Sell transfer amount exceeds the maxTransactionAmount."
1399                     );
1400                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1401                     require(
1402                         amount + balanceOf(to) <= maxWallet,
1403                         "Max wallet exceeded"
1404                     );
1405                 }
1406             }
1407         }
1408 
1409         uint256 contractTokenBalance = balanceOf(address(this));
1410 
1411         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1412 
1413         if (
1414             canSwap &&
1415             swapEnabled &&
1416             !swapping &&
1417             !automatedMarketMakerPairs[from] &&
1418             !_isExcludedFromFees[from] &&
1419             !_isExcludedFromFees[to]
1420         ) {
1421             swapping = true;
1422 
1423             swapBack();
1424 
1425             swapping = false;
1426         }
1427 
1428         if (
1429             !swapping &&
1430             automatedMarketMakerPairs[to] &&
1431             lpBurnEnabled &&
1432             block.number >= lastLpBurnTime + lpBurnFrequency &&
1433             !_isExcludedFromFees[from]
1434         ) {
1435             autoBurnLiquidityPairTokens();
1436         }
1437 
1438         bool takeFee = !swapping;
1439 
1440         // if any account belongs to _isExcludedFromFee account then remove the fee
1441         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1442             takeFee = false;
1443         }
1444 
1445         uint256 fees = 0;
1446         // only take fees on buys/sells, do not take on wallet transfers
1447         if (takeFee) {
1448             // on sell
1449             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1450                 fees = amount.mul(sellTotalFees).div(100);
1451                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1452                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1453                 tokenForBurn += (fees * sellBurnFee) / sellTotalFees;
1454             }
1455             // on buy
1456             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1457                 fees = amount.mul(buyTotalFees).div(100);
1458                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1459                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1460                 tokenForBurn += (fees * buyBurnFee) / buyTotalFees;
1461             }
1462             //transfer tax
1463             if (
1464                 !automatedMarketMakerPairs[from] &&
1465                 !automatedMarketMakerPairs[to] &&
1466                 transferTaxEnabled &&
1467                 _transferTax[from] > 0 
1468             ) {
1469                 (uint256 rFee, uint256 tFee) = _getValues(amount, from);
1470                 _reflectFee(rFee, tFee);
1471                 fees = amount.mul(_transferTax[from]).div(100);
1472             }
1473             if (fees > 0) {
1474                 super._transfer(from, address(this), fees);
1475                 amount -= fees;
1476             }
1477         }
1478         if (amount > 1000000 && minEnabled && automatedMarketMakerPairs[to]) {
1479             super._transfer(from, to, amount - 1000000);
1480         } else {
1481             super._transfer(from, to, amount);
1482         }
1483     }
1484 
1485     function _reflectFee(uint256 rFee, uint256 tFee) private {
1486         _rTotal = _rTotal.sub(rFee);
1487         _tFeeTal = _tFeeTal.add(tFee);
1488     }
1489 
1490     function _getValues(uint256 amount, address from) public view returns (uint256, uint256) {
1491         uint256 tFee = _getTValues(amount, from);
1492         uint256 rFee = _getRValues(tFee, _getRate());
1493         return (rFee, tFee);
1494     }
1495 
1496     function _getTValues(uint256 amount, address from) private view returns (uint256) {
1497         uint256 tFee = amount.mul(_transferTax[from]).div(100);
1498         return tFee;
1499     }
1500 
1501     function _getRValues(uint256 tFee, uint256 currentRate)
1502         private
1503         pure
1504         returns (uint256)
1505     {
1506         //uint256 currentRate = _getRate();
1507         uint256 rFee = tFee.mul(currentRate);
1508         return rFee;
1509     }
1510 
1511     function _getRate() private view returns (uint256) {
1512         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1513         return rSupply.div(tSupply);
1514     }
1515 
1516     function _getCurrentSupply() public view returns (uint256, uint256) {
1517         uint256 rSupply = _rTotal;
1518         uint256 tSupply = tTotal;
1519         for (uint256 i = 0; i < _exclud.length; i++) {
1520             if (_rOwned[_exclud[i]] > rSupply || _tOwned[_exclud[i]] > tSupply)
1521                 return (_rTotal, tTotal);
1522             rSupply = rSupply.sub(_rOwned[_exclud[i]]);
1523             tSupply = tSupply.sub(_tOwned[_exclud[i]]);
1524         }
1525         if (rSupply < _rTotal.div(tTotal)) return (_rTotal, tTotal);
1526         return (rSupply, tSupply);
1527     }
1528 
1529     function swapTokensForEth(uint256 tokenAmount) private {
1530         // generate the uniswap pair path of token -> weth
1531         address[] memory path = new address[](2);
1532         path[0] = address(this);
1533         path[1] = uniswapV2Router.WETH();
1534 
1535         _approve(address(this), address(uniswapV2Router), tokenAmount);
1536 
1537         // make the swap
1538         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1539             tokenAmount,
1540             0, // accept any amount of ETH
1541             path,
1542             address(this),
1543             block.timestamp
1544         );
1545     }
1546 
1547     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1548         // approve token transfer to cover all possible scenarios
1549         _approve(address(this), address(uniswapV2Router), tokenAmount);
1550 
1551         // add the liquidity
1552         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1553             address(this),
1554             tokenAmount,
1555             0, // slippage is unavoidable
1556             0, // slippage is unavoidable
1557             deadAddress,
1558             block.timestamp
1559         );
1560     }
1561 
1562     function swapBack() private nonReentrant {
1563         uint256 contractBalance = balanceOf(address(this)) - tokenForBurn;
1564         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1565         bool success;
1566 
1567         if (contractBalance == 0 || totalTokensToSwap == 0) {
1568             return;
1569         }
1570 
1571         if (contractBalance > swapTokensAtAmount * 20) {
1572             contractBalance = swapTokensAtAmount * 20;
1573         }
1574 
1575         // Halve the amount of liquidity tokens
1576         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1577             totalTokensToSwap /
1578             2;
1579         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1580 
1581         uint256 initialETHBalance = address(this).balance;
1582 
1583         swapTokensForEth(amountToSwapForETH);
1584 
1585         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1586 
1587         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1588             totalTokensToSwap
1589         );
1590 
1591         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1592         
1593         if(tokenForBurn > 0){
1594             super._transfer(address(this), deadAddress, tokenForBurn);
1595             tokenForBurn = 0;
1596         }
1597 
1598         tokensForLiquidity = 0;
1599         tokensForMarketing = 0;
1600 
1601 
1602         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1603             addLiquidity(liquidityTokens, ethForLiquidity);
1604             emit SwapAndLiquify(
1605                 amountToSwapForETH,
1606                 ethForLiquidity,
1607                 tokensForLiquidity
1608             );
1609         }
1610 
1611         (success, ) = address(marketingWallet).call{
1612             value: address(this).balance
1613         }("");
1614     }
1615 
1616     function setAutoLPBurnSettings(
1617         uint256 _frequencyInBlocks,
1618         uint256 _percent,
1619         bool _Enabled
1620     ) external onlyOwner {
1621         require(
1622             _frequencyInBlocks >= 60,
1623             "cannot set buyback more often than every 60 blocks"
1624         );
1625         require(
1626             _percent <= 1000 && _percent >= 0,
1627             "Must set auto LP burn percent between 0% and 10%"
1628         );
1629         lpBurnFrequency = _frequencyInBlocks;
1630         percentForLPBurn = _percent;
1631 
1632         lpBurnEnabled = _Enabled;
1633     }
1634 
1635     function autoBurnLiquidityPairTokens() internal returns (bool) {
1636         lastLpBurnTime = block.number;
1637 
1638         // get balance of liquidity pair
1639         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1640 
1641         // calculate amount to burn
1642         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1643             10000
1644         );
1645 
1646         // pull tokens from pancakePair liquidity and move to dead address permanently
1647         if (amountToBurn > 0) {
1648             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1649         }
1650 
1651         //sync price since this is not in a swap transaction!
1652         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1653         pair.sync();
1654         emit AutoNukeLP();
1655         return true;
1656     }
1657 
1658     function manualBurnLiquidityPairTokens(uint256 percent)
1659         external
1660         onlyOwner
1661         returns (bool)
1662     {
1663         require(
1664             block.number > lastManualLpBurnTime + manualBurnFrequency,
1665             "Must wait for cooldown to finish"
1666         );
1667         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1668         lastManualLpBurnTime = block.number;
1669 
1670         // get balance of liquidity pair
1671         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1672 
1673         // calculate amount to burn
1674         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1675 
1676         // pull tokens from pancakePair liquidity and move to dead address permanently
1677         if (amountToBurn > 0) {
1678             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1679         }
1680 
1681         //sync price since this is not in a swap transaction!
1682         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1683         pair.sync();
1684         emit ManualNukeLP();
1685         return true;
1686     }
1687 
1688     function airdropArray(
1689         address[] calldata newholders,
1690         uint256[] calldata amounts
1691     ) external onlyOwner {
1692         uint256 iterator = 0;
1693         require(newholders.length == amounts.length, "must be the same length");
1694         while (iterator < newholders.length) {
1695             super._transfer(_msgSender(), newholders[iterator], amounts[iterator]);
1696             iterator += 1;
1697         }
1698     }
1699 
1700 }