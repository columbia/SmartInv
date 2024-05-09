1 // LUFFY ETH
2 // Version: V3
3 // Website: www.luffytoken.com
4 // Twitter: https://twitter.com/luffyinutoken (@luffyinutoken)
5 // TG: https://t.me/luffytokenchannel
6 // Facebook: https://www.facebook.com/groups/luffytoken/
7 // Instagram: https://www.instagram.com/luffytoken/
8 // Reddit: https://www.reddit.com/r/luffy_inu/
9 // Discord: https://discord.com/invite/erqwUsSssf
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity 0.8.9;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 interface IUniswapV2Pair {
27     event Approval(
28         address indexed owner,
29         address indexed spender,
30         uint256 value
31     );
32     event Transfer(address indexed from, address indexed to, uint256 value);
33 
34     function name() external pure returns (string memory);
35 
36     function symbol() external pure returns (string memory);
37 
38     function decimals() external pure returns (uint8);
39 
40     function totalSupply() external view returns (uint256);
41 
42     function balanceOf(address owner) external view returns (uint256);
43 
44     function allowance(address owner, address spender)
45         external
46         view
47         returns (uint256);
48 
49     function approve(address spender, uint256 value) external returns (bool);
50 
51     function transfer(address to, uint256 value) external returns (bool);
52 
53     function transferFrom(
54         address from,
55         address to,
56         uint256 value
57     ) external returns (bool);
58 
59     function DOMAIN_SEPARATOR() external view returns (bytes32);
60 
61     function PERMIT_TYPEHASH() external pure returns (bytes32);
62 
63     function nonces(address owner) external view returns (uint256);
64 
65     function permit(
66         address owner,
67         address spender,
68         uint256 value,
69         uint256 deadline,
70         uint8 v,
71         bytes32 r,
72         bytes32 s
73     ) external;
74 
75     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
76     event Burn(
77         address indexed sender,
78         uint256 amount0,
79         uint256 amount1,
80         address indexed to
81     );
82     event Swap(
83         address indexed sender,
84         uint256 amount0In,
85         uint256 amount1In,
86         uint256 amount0Out,
87         uint256 amount1Out,
88         address indexed to
89     );
90     event Sync(uint112 reserve0, uint112 reserve1);
91 
92     function MINIMUM_LIQUIDITY() external pure returns (uint256);
93 
94     function factory() external view returns (address);
95 
96     function token0() external view returns (address);
97 
98     function token1() external view returns (address);
99 
100     function getReserves()
101         external
102         view
103         returns (
104             uint112 reserve0,
105             uint112 reserve1,
106             uint32 blockTimestampLast
107         );
108 
109     function price0CumulativeLast() external view returns (uint256);
110 
111     function price1CumulativeLast() external view returns (uint256);
112 
113     function kLast() external view returns (uint256);
114 
115     function mint(address to) external returns (uint256 liquidity);
116 
117     function burn(address to)
118         external
119         returns (uint256 amount0, uint256 amount1);
120 
121     function swap(
122         uint256 amount0Out,
123         uint256 amount1Out,
124         address to,
125         bytes calldata data
126     ) external;
127 
128     function skim(address to) external;
129 
130     function sync() external;
131 
132     function initialize(address, address) external;
133 }
134 
135 interface IUniswapV2Factory {
136     event PairCreated(
137         address indexed token0,
138         address indexed token1,
139         address pair,
140         uint256
141     );
142 
143     function feeTo() external view returns (address);
144 
145     function feeToSetter() external view returns (address);
146 
147     function getPair(address tokenA, address tokenB)
148         external
149         view
150         returns (address pair);
151 
152     function allPairs(uint256) external view returns (address pair);
153 
154     function allPairsLength() external view returns (uint256);
155 
156     function createPair(address tokenA, address tokenB)
157         external
158         returns (address pair);
159 
160     function setFeeTo(address) external;
161 
162     function setFeeToSetter(address) external;
163 }
164 
165 interface IERC20 {
166     /**
167      * @dev Returns the amount of tokens in existence.
168      */
169     function totalSupply() external view returns (uint256);
170 
171     /**
172      * @dev Returns the amount of tokens owned by `account`.
173      */
174     function balanceOf(address account) external view returns (uint256);
175 
176     /**
177      * @dev Moves `amount` tokens from the caller's account to `recipient`.
178      *
179      * Returns a boolean value indicating whether the operation succeeded.
180      *
181      * Emits a {Transfer} event.
182      */
183     function transfer(address recipient, uint256 amount)
184         external
185         returns (bool);
186 
187     /**
188      * @dev Returns the remaining number of tokens that `spender` will be
189      * allowed to spend on behalf of `owner` through {transferFrom}. This is
190      * zero by default.
191      *
192      * This value changes when {approve} or {transferFrom} are called.
193      */
194     function allowance(address owner, address spender)
195         external
196         view
197         returns (uint256);
198 
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * IMPORTANT: Beware that changing an allowance with this method brings the risk
205      * that someone may use both the old and the new allowance by unfortunate
206      * transaction ordering. One possible solution to mitigate this race
207      * condition is to first reduce the spender's allowance to 0 and set the
208      * desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address spender, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Moves `amount` tokens from `sender` to `recipient` using the
217      * allowance mechanism. `amount` is then deducted from the caller's
218      * allowance.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(
225         address sender,
226         address recipient,
227         uint256 amount
228     ) external returns (bool);
229 
230     /**
231      * @dev Emitted when `value` tokens are moved from one account (`from`) to
232      * another (`to`).
233      *
234      * Note that `value` may be zero.
235      */
236     event Transfer(address indexed from, address indexed to, uint256 value);
237 
238     /**
239      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
240      * a call to {approve}. `value` is the new allowance.
241      */
242     event Approval(
243         address indexed owner,
244         address indexed spender,
245         uint256 value
246     );
247 }
248 
249 interface IERC20Metadata is IERC20 {
250     /**
251      * @dev Returns the name of the token.
252      */
253     function name() external view returns (string memory);
254 
255     /**
256      * @dev Returns the symbol of the token.
257      */
258     function symbol() external view returns (string memory);
259 
260     /**
261      * @dev Returns the decimals places of the token.
262      */
263     function decimals() external view returns (uint8);
264 }
265 
266 contract ERC20 is Context, IERC20, IERC20Metadata {
267     using SafeMath for uint256;
268 
269     mapping(address => uint256) private _balances;
270 
271     mapping(address => mapping(address => uint256)) private _allowances;
272 
273     uint256 private _totalSupply;
274 
275     string private _name;
276     string private _symbol;
277 
278     /**
279      * @dev Sets the values for {name} and {symbol}.
280      *
281      * The default value of {decimals} is 9. To select a different value for
282      * {decimals} you should overload it.
283      *
284      * All two of these values are immutable: they can only be set once during
285      * construction.
286      */
287     constructor(string memory name_, string memory symbol_) {
288         _name = name_;
289         _symbol = symbol_;
290     }
291 
292     /**
293      * @dev Returns the name of the token.
294      */
295     function name() public view virtual override returns (string memory) {
296         return _name;
297     }
298 
299     /**
300      * @dev Returns the symbol of the token, usually a shorter version of the
301      * name.
302      */
303     function symbol() public view virtual override returns (string memory) {
304         return _symbol;
305     }
306 
307     /**
308      * @dev Returns the number of decimals used to get its user representation.
309      * For example, if `decimals` equals `2`, a balance of `505` tokens should
310      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
311      *
312      * Tokens usually opt for a value of 18, imitating the relationship between
313      * Ether and Wei. This is the value {ERC20} uses, unless this function is
314      * overridden;
315      *
316      * NOTE: This information is only used for _display_ purposes: it in
317      * no way affects any of the arithmetic of the contract, including
318      * {IERC20-balanceOf} and {IERC20-transfer}.
319      */
320     function decimals() public view virtual override returns (uint8) {
321         return 9;
322     }
323 
324     /**
325      * @dev See {IERC20-totalSupply}.
326      */
327     function totalSupply() public view virtual override returns (uint256) {
328         return _totalSupply;
329     }
330 
331     /**
332      * @dev See {IERC20-balanceOf}.
333      */
334     function balanceOf(address account)
335         public
336         view
337         virtual
338         override
339         returns (uint256)
340     {
341         return _balances[account];
342     }
343 
344     /**
345      * @dev See {IERC20-transfer}.
346      *
347      * Requirements:
348      *
349      * - `recipient` cannot be the zero address.
350      * - the caller must have a balance of at least `amount`.
351      */
352     function transfer(address recipient, uint256 amount)
353         public
354         virtual
355         override
356         returns (bool)
357     {
358         _transfer(_msgSender(), recipient, amount);
359         return true;
360     }
361 
362     /**
363      * @dev See {IERC20-allowance}.
364      */
365     function allowance(address owner, address spender)
366         public
367         view
368         virtual
369         override
370         returns (uint256)
371     {
372         return _allowances[owner][spender];
373     }
374 
375     /**
376      * @dev See {IERC20-approve}.
377      *
378      * Requirements:
379      *
380      * - `spender` cannot be the zero address.
381      */
382     function approve(address spender, uint256 amount)
383         public
384         virtual
385         override
386         returns (bool)
387     {
388         _approve(_msgSender(), spender, amount);
389         return true;
390     }
391 
392     /**
393      * @dev See {IERC20-transferFrom}.
394      *
395      * Emits an {Approval} event indicating the updated allowance. This is not
396      * required by the EIP. See the note at the beginning of {ERC20}.
397      *
398      * Requirements:
399      *
400      * - `sender` and `recipient` cannot be the zero address.
401      * - `sender` must have a balance of at least `amount`.
402      * - the caller must have allowance for ``sender``'s tokens of at least
403      * `amount`.
404      */
405     function transferFrom(
406         address sender,
407         address recipient,
408         uint256 amount
409     ) public virtual override returns (bool) {
410         _transfer(sender, recipient, amount);
411         _approve(
412             sender,
413             _msgSender(),
414             _allowances[sender][_msgSender()].sub(
415                 amount,
416                 "ERC20: transfer amount exceeds allowance"
417             )
418         );
419         return true;
420     }
421 
422     /**
423      * @dev Atomically increases the allowance granted to `spender` by the caller.
424      *
425      * This is an alternative to {approve} that can be used as a mitigation for
426      * problems described in {IERC20-approve}.
427      *
428      * Emits an {Approval} event indicating the updated allowance.
429      *
430      * Requirements:
431      *
432      * - `spender` cannot be the zero address.
433      */
434     function increaseAllowance(address spender, uint256 addedValue)
435         public
436         virtual
437         returns (bool)
438     {
439         _approve(
440             _msgSender(),
441             spender,
442             _allowances[_msgSender()][spender].add(addedValue)
443         );
444         return true;
445     }
446 
447     /**
448      * @dev Atomically decreases the allowance granted to `spender` by the caller.
449      *
450      * This is an alternative to {approve} that can be used as a mitigation for
451      * problems described in {IERC20-approve}.
452      *
453      * Emits an {Approval} event indicating the updated allowance.
454      *
455      * Requirements:
456      *
457      * - `spender` cannot be the zero address.
458      * - `spender` must have allowance for the caller of at least
459      * `subtractedValue`.
460      */
461     function decreaseAllowance(address spender, uint256 subtractedValue)
462         public
463         virtual
464         returns (bool)
465     {
466         _approve(
467             _msgSender(),
468             spender,
469             _allowances[_msgSender()][spender].sub(
470                 subtractedValue,
471                 "ERC20: decreased allowance below zero"
472             )
473         );
474         return true;
475     }
476 
477     /**
478      * @dev Moves tokens `amount` from `sender` to `recipient`.
479      *
480      * This is internal function is equivalent to {transfer}, and can be used to
481      * e.g. implement automatic token fees, slashing mechanisms, etc.
482      *
483      * Emits a {Transfer} event.
484      *
485      * Requirements:
486      *
487      * - `sender` cannot be the zero address.
488      * - `recipient` cannot be the zero address.
489      * - `sender` must have a balance of at least `amount`.
490      */
491     function _transfer(
492         address sender,
493         address recipient,
494         uint256 amount
495     ) internal virtual {
496         require(sender != address(0), "ERC20: transfer from the zero address");
497         require(recipient != address(0), "ERC20: transfer to the zero address");
498 
499         _beforeTokenTransfer(sender, recipient, amount);
500 
501         _balances[sender] = _balances[sender].sub(
502             amount,
503             "ERC20: transfer amount exceeds balance"
504         );
505         _balances[recipient] = _balances[recipient].add(amount);
506         emit Transfer(sender, recipient, amount);
507     }
508 
509     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
510      * the total supply.
511      *
512      * Emits a {Transfer} event with `from` set to the zero address.
513      *
514      * Requirements:
515      *
516      * - `account` cannot be the zero address.
517      */
518     function _mint(address account, uint256 amount) internal virtual {
519         require(account != address(0), "ERC20: mint to the zero address");
520 
521         _beforeTokenTransfer(address(0), account, amount);
522 
523         _totalSupply = _totalSupply.add(amount);
524         _balances[account] = _balances[account].add(amount);
525         emit Transfer(address(0), account, amount);
526     }
527 
528     /**
529      * @dev Destroys `amount` tokens from `account`, reducing the
530      * total supply.
531      *
532      * Emits a {Transfer} event with `to` set to the zero address.
533      *
534      * Requirements:
535      *
536      * - `account` cannot be the zero address.
537      * - `account` must have at least `amount` tokens.
538      */
539     function _burn(address account, uint256 amount) internal virtual {
540         require(account != address(0), "ERC20: burn from the zero address");
541 
542         _beforeTokenTransfer(account, address(0), amount);
543 
544         _balances[account] = _balances[account].sub(
545             amount,
546             "ERC20: burn amount exceeds balance"
547         );
548         _totalSupply = _totalSupply.sub(amount);
549         emit Transfer(account, address(0), amount);
550     }
551 
552     /**
553      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
554      *
555      * This internal function is equivalent to `approve`, and can be used to
556      * e.g. set automatic allowances for certain subsystems, etc.
557      *
558      * Emits an {Approval} event.
559      *
560      * Requirements:
561      *
562      * - `owner` cannot be the zero address.
563      * - `spender` cannot be the zero address.
564      */
565     function _approve(
566         address owner,
567         address spender,
568         uint256 amount
569     ) internal virtual {
570         require(owner != address(0), "ERC20: approve from the zero address");
571         require(spender != address(0), "ERC20: approve to the zero address");
572 
573         _allowances[owner][spender] = amount;
574         emit Approval(owner, spender, amount);
575     }
576 
577     /**
578      * @dev Hook that is called before any transfer of tokens. This includes
579      * minting and burning.
580      *
581      * Calling conditions:
582      *
583      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
584      * will be to transferred to `to`.
585      * - when `from` is zero, `amount` tokens will be minted for `to`.
586      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
587      * - `from` and `to` are never both zero.
588      *
589      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
590      */
591     function _beforeTokenTransfer(
592         address from,
593         address to,
594         uint256 amount
595     ) internal virtual {}
596 }
597 
598 library SafeMath {
599     /**
600      * @dev Returns the addition of two unsigned integers, reverting on
601      * overflow.
602      *
603      * Counterpart to Solidity's `+` operator.
604      *
605      * Requirements:
606      *
607      * - Addition cannot overflow.
608      */
609     function add(uint256 a, uint256 b) internal pure returns (uint256) {
610         uint256 c = a + b;
611         require(c >= a, "SafeMath: addition overflow");
612 
613         return c;
614     }
615 
616     /**
617      * @dev Returns the subtraction of two unsigned integers, reverting on
618      * overflow (when the result is negative).
619      *
620      * Counterpart to Solidity's `-` operator.
621      *
622      * Requirements:
623      *
624      * - Subtraction cannot overflow.
625      */
626     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
627         return sub(a, b, "SafeMath: subtraction overflow");
628     }
629 
630     /**
631      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
632      * overflow (when the result is negative).
633      *
634      * Counterpart to Solidity's `-` operator.
635      *
636      * Requirements:
637      *
638      * - Subtraction cannot overflow.
639      */
640     function sub(
641         uint256 a,
642         uint256 b,
643         string memory errorMessage
644     ) internal pure returns (uint256) {
645         require(b <= a, errorMessage);
646         uint256 c = a - b;
647 
648         return c;
649     }
650 
651     /**
652      * @dev Returns the multiplication of two unsigned integers, reverting on
653      * overflow.
654      *
655      * Counterpart to Solidity's `*` operator.
656      *
657      * Requirements:
658      *
659      * - Multiplication cannot overflow.
660      */
661     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
662         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
663         // benefit is lost if 'b' is also tested.
664         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
665         if (a == 0) {
666             return 0;
667         }
668 
669         uint256 c = a * b;
670         require(c / a == b, "SafeMath: multiplication overflow");
671 
672         return c;
673     }
674 
675     /**
676      * @dev Returns the integer division of two unsigned integers. Reverts on
677      * division by zero. The result is rounded towards zero.
678      *
679      * Counterpart to Solidity's `/` operator. Note: this function uses a
680      * `revert` opcode (which leaves remaining gas untouched) while Solidity
681      * uses an invalid opcode to revert (consuming all remaining gas).
682      *
683      * Requirements:
684      *
685      * - The divisor cannot be zero.
686      */
687     function div(uint256 a, uint256 b) internal pure returns (uint256) {
688         return div(a, b, "SafeMath: division by zero");
689     }
690 
691     /**
692      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
693      * division by zero. The result is rounded towards zero.
694      *
695      * Counterpart to Solidity's `/` operator. Note: this function uses a
696      * `revert` opcode (which leaves remaining gas untouched) while Solidity
697      * uses an invalid opcode to revert (consuming all remaining gas).
698      *
699      * Requirements:
700      *
701      * - The divisor cannot be zero.
702      */
703     function div(
704         uint256 a,
705         uint256 b,
706         string memory errorMessage
707     ) internal pure returns (uint256) {
708         require(b > 0, errorMessage);
709         uint256 c = a / b;
710 
711         return c;
712     }
713 
714     /**
715      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
716      * Reverts when dividing by zero.
717      *
718      * Counterpart to Solidity's `%` operator. This function uses a `revert`
719      * opcode (which leaves remaining gas untouched) while Solidity uses an
720      * invalid opcode to revert (consuming all remaining gas).
721      *
722      * Requirements:
723      *
724      * - The divisor cannot be zero.
725      */
726     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
727         return mod(a, b, "SafeMath: modulo by zero");
728     }
729 
730     /**
731      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
732      * Reverts with custom message when dividing by zero.
733      *
734      * Counterpart to Solidity's `%` operator. This function uses a `revert`
735      * opcode (which leaves remaining gas untouched) while Solidity uses an
736      * invalid opcode to revert (consuming all remaining gas).
737      *
738      * Requirements:
739      *
740      * - The divisor cannot be zero.
741      */
742     function mod(
743         uint256 a,
744         uint256 b,
745         string memory errorMessage
746     ) internal pure returns (uint256) {
747         require(b != 0, errorMessage);
748         return a % b;
749     }
750 }
751 
752 contract Ownable is Context {
753     address private _owner;
754 
755     event OwnershipTransferred(
756         address indexed previousOwner,
757         address indexed newOwner
758     );
759 
760     /**
761      * @dev Initializes the contract setting the deployer as the initial owner.
762      */
763     constructor() {
764         address msgSender = _msgSender();
765         _owner = msgSender;
766         emit OwnershipTransferred(address(0), msgSender);
767     }
768 
769     /**
770      * @dev Returns the address of the current owner.
771      */
772     function owner() public view returns (address) {
773         return _owner;
774     }
775 
776     /**
777      * @dev Throws if called by any account other than the owner.
778      */
779     modifier onlyOwner() {
780         require(_owner == _msgSender(), "Ownable: caller is not the owner");
781         _;
782     }
783 
784     /**
785      * @dev Leaves the contract without owner. It will not be possible to call
786      * `onlyOwner` functions anymore. Can only be called by the current owner.
787      *
788      * NOTE: Renouncing ownership will leave the contract without an owner,
789      * thereby removing any functionality that is only available to the owner.
790      */
791     function renounceOwnership() public virtual onlyOwner {
792         emit OwnershipTransferred(_owner, address(0));
793         _owner = address(0);
794     }
795 
796     /**
797      * @dev Transfers ownership of the contract to a new account (`newOwner`).
798      * Can only be called by the current owner.
799      */
800     function transferOwnership(address newOwner) public virtual onlyOwner {
801         require(
802             newOwner != address(0),
803             "Ownable: new owner is the zero address"
804         );
805         emit OwnershipTransferred(_owner, newOwner);
806         _owner = newOwner;
807     }
808 }
809 
810 
811 abstract contract ReentrancyGuard {
812     // Booleans are more expensive than uint256 or any type that takes up a full
813     // word because each write operation emits an extra SLOAD to first read the
814     // slot's contents, replace the bits taken up by the boolean, and then write
815     // back. This is the compiler's defense against contract upgrades and
816     // pointer aliasing, and it cannot be disabled.
817 
818     // The values being non-zero value makes deployment a bit more expensive,
819     // but in exchange the refund on every call to nonReentrant will be lower in
820     // amount. Since refunds are capped to a percentage of the total
821     // transaction's gas, it is best to keep them low in cases like this one, to
822     // increase the likelihood of the full refund coming into effect.
823     uint256 private constant _NOT_ENTERED = 1;
824     uint256 private constant _ENTERED = 2;
825 
826     uint256 private _status;
827 
828     constructor() {
829         _status = _NOT_ENTERED;
830     }
831 
832     /**
833      * @dev Prevents a contract from calling itself, directly or indirectly.
834      * Calling a `nonReentrant` function from another `nonReentrant`
835      * function is not supported. It is possible to prevent this from happening
836      * by making the `nonReentrant` function external, and making it call a
837      * `private` function that does the actual work.
838      */
839     modifier nonReentrant() {
840         _nonReentrantBefore();
841         _;
842         _nonReentrantAfter();
843     }
844 
845     function _nonReentrantBefore() private {
846         // On the first call to nonReentrant, _status will be _NOT_ENTERED
847         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
848 
849         // Any calls to nonReentrant after this point will fail
850         _status = _ENTERED;
851     }
852 
853     function _nonReentrantAfter() private {
854         // By storing the original value once again, a refund is triggered (see
855         // https://eips.ethereum.org/EIPS/eip-2200)
856         _status = _NOT_ENTERED;
857     }
858 }
859 
860 interface IUniswapV2Router01 {
861     function factory() external pure returns (address);
862 
863     function WETH() external pure returns (address);
864 
865     function addLiquidity(
866         address tokenA,
867         address tokenB,
868         uint256 amountADesired,
869         uint256 amountBDesired,
870         uint256 amountAMin,
871         uint256 amountBMin,
872         address to,
873         uint256 deadline
874     )
875         external
876         returns (
877             uint256 amountA,
878             uint256 amountB,
879             uint256 liquidity
880         );
881 
882     function addLiquidityETH(
883         address token,
884         uint256 amountTokenDesired,
885         uint256 amountTokenMin,
886         uint256 amountETHMin,
887         address to,
888         uint256 deadline
889     )
890         external
891         payable
892         returns (
893             uint256 amountToken,
894             uint256 amountETH,
895             uint256 liquidity
896         );
897 
898     function removeLiquidity(
899         address tokenA,
900         address tokenB,
901         uint256 liquidity,
902         uint256 amountAMin,
903         uint256 amountBMin,
904         address to,
905         uint256 deadline
906     ) external returns (uint256 amountA, uint256 amountB);
907 
908     function removeLiquidityETH(
909         address token,
910         uint256 liquidity,
911         uint256 amountTokenMin,
912         uint256 amountETHMin,
913         address to,
914         uint256 deadline
915     ) external returns (uint256 amountToken, uint256 amountETH);
916 
917     function removeLiquidityWithPermit(
918         address tokenA,
919         address tokenB,
920         uint256 liquidity,
921         uint256 amountAMin,
922         uint256 amountBMin,
923         address to,
924         uint256 deadline,
925         bool approveMax,
926         uint8 v,
927         bytes32 r,
928         bytes32 s
929     ) external returns (uint256 amountA, uint256 amountB);
930 
931     function removeLiquidityETHWithPermit(
932         address token,
933         uint256 liquidity,
934         uint256 amountTokenMin,
935         uint256 amountETHMin,
936         address to,
937         uint256 deadline,
938         bool approveMax,
939         uint8 v,
940         bytes32 r,
941         bytes32 s
942     ) external returns (uint256 amountToken, uint256 amountETH);
943 
944     function swapExactTokensForTokens(
945         uint256 amountIn,
946         uint256 amountOutMin,
947         address[] calldata path,
948         address to,
949         uint256 deadline
950     ) external returns (uint256[] memory amounts);
951 
952     function swapTokensForExactTokens(
953         uint256 amountOut,
954         uint256 amountInMax,
955         address[] calldata path,
956         address to,
957         uint256 deadline
958     ) external returns (uint256[] memory amounts);
959 
960     function swapExactETHForTokens(
961         uint256 amountOutMin,
962         address[] calldata path,
963         address to,
964         uint256 deadline
965     ) external payable returns (uint256[] memory amounts);
966 
967     function swapTokensForExactETH(
968         uint256 amountOut,
969         uint256 amountInMax,
970         address[] calldata path,
971         address to,
972         uint256 deadline
973     ) external returns (uint256[] memory amounts);
974 
975     function swapExactTokensForETH(
976         uint256 amountIn,
977         uint256 amountOutMin,
978         address[] calldata path,
979         address to,
980         uint256 deadline
981     ) external returns (uint256[] memory amounts);
982 
983     function swapETHForExactTokens(
984         uint256 amountOut,
985         address[] calldata path,
986         address to,
987         uint256 deadline
988     ) external payable returns (uint256[] memory amounts);
989 
990     function quote(
991         uint256 amountA,
992         uint256 reserveA,
993         uint256 reserveB
994     ) external pure returns (uint256 amountB);
995 
996     function getAmountOut(
997         uint256 amountIn,
998         uint256 reserveIn,
999         uint256 reserveOut
1000     ) external pure returns (uint256 amountOut);
1001 
1002     function getAmountIn(
1003         uint256 amountOut,
1004         uint256 reserveIn,
1005         uint256 reserveOut
1006     ) external pure returns (uint256 amountIn);
1007 
1008     function getAmountsOut(uint256 amountIn, address[] calldata path)
1009         external
1010         view
1011         returns (uint256[] memory amounts);
1012 
1013     function getAmountsIn(uint256 amountOut, address[] calldata path)
1014         external
1015         view
1016         returns (uint256[] memory amounts);
1017 }
1018 
1019 interface IUniswapV2Router02 is IUniswapV2Router01 {
1020     function removeLiquidityETHSupportingFeeOnTransferTokens(
1021         address token,
1022         uint256 liquidity,
1023         uint256 amountTokenMin,
1024         uint256 amountETHMin,
1025         address to,
1026         uint256 deadline
1027     ) external returns (uint256 amountETH);
1028 
1029     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1030         address token,
1031         uint256 liquidity,
1032         uint256 amountTokenMin,
1033         uint256 amountETHMin,
1034         address to,
1035         uint256 deadline,
1036         bool approveMax,
1037         uint8 v,
1038         bytes32 r,
1039         bytes32 s
1040     ) external returns (uint256 amountETH);
1041 
1042     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1043         uint256 amountIn,
1044         uint256 amountOutMin,
1045         address[] calldata path,
1046         address to,
1047         uint256 deadline
1048     ) external;
1049 
1050     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1051         uint256 amountOutMin,
1052         address[] calldata path,
1053         address to,
1054         uint256 deadline
1055     ) external payable;
1056 
1057     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1058         uint256 amountIn,
1059         uint256 amountOutMin,
1060         address[] calldata path,
1061         address to,
1062         uint256 deadline
1063     ) external;
1064 }
1065 
1066 contract LuffyToken is ERC20, Ownable, ReentrancyGuard {
1067     using SafeMath for uint256;
1068 
1069     IUniswapV2Router02 public immutable uniswapV2Router;
1070     address public immutable uniswapV2Pair;
1071     address public constant deadAddress = address(0xdead);
1072 
1073     bool private swapping;
1074 
1075     address public marketingWallet;
1076 
1077     uint256 public maxTransactionAmount;
1078     uint256 public swapTokensAtAmount;
1079     uint256 public maxWallet;
1080 
1081     uint256 public MaxWalletValue;
1082     uint256 public percentForLPBurn = 25; // 25 = .25%
1083     bool public lpBurnEnabled = true;
1084     uint256 public lpBurnFrequency = 3600 / 12;
1085     uint256 public lastLpBurnTime;
1086 
1087     uint256 public manualBurnFrequency = 180000 / 12;
1088     uint256 public lastManualLpBurnTime;
1089 
1090     bool public limitsInEffect = true;
1091     bool public tradingActive = false;
1092     bool public swapEnabled = false;
1093     mapping(address => bool) public BlackList;
1094     // Anti-bot and anti-whale mappings and variables
1095     bool private minEnabled = true;
1096     bool private transferTaxEnabled = true;
1097 
1098     uint256 public buyTotalFees;
1099     // uint256 public buytax;
1100     uint256 public buyMarketingFee;
1101     uint256 public buyLiquidityFee;
1102     uint256 public buyBurnFee;
1103 
1104     uint256 public sellTotalFees;
1105     //uint256 public selltax;
1106     uint256 public sellMarketingFee;
1107     uint256 public sellLiquidityFee;
1108     uint256 public sellBurnFee;
1109 
1110     uint256 public tokensForMarketing;
1111     uint256 public tokensForLiquidity;
1112     uint256 public tokenForBurn;
1113 
1114     uint256 constant MAX = ~uint256(0);
1115     uint256 public _rTotal;
1116     uint256 public tTotal;
1117     uint256 public _tFeeTal;
1118 
1119     address[] public _exclud;
1120     mapping(address => uint256) private _rOwned;
1121     mapping(address => uint256) private _tOwned;
1122 
1123     // exlcude from fees and max transaction amount
1124     mapping(address => bool) private _isExcludedFromFees;
1125     mapping(address => bool) public _isExcludedMaxTransactionAmount;
1126     mapping(address => uint8) public _transferTax;
1127 
1128     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1129     // could be subject to a maximum transfer amount
1130     mapping(address => bool) public automatedMarketMakerPairs;
1131 
1132     event UpdateUniswapV2Router(
1133         address indexed newAddress,
1134         address indexed oldAddress
1135     );
1136 
1137     event ExcludeFromFees(address indexed account, bool isExcluded);
1138 
1139     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1140 
1141     event marketingWalletUpdated(
1142         address indexed newWallet,
1143         address indexed oldWallet
1144     );
1145 
1146     event devWalletUpdated(
1147         address indexed newWallet,
1148         address indexed oldWallet
1149     );
1150 
1151     event SwapAndLiquify(
1152         uint256 tokensSwapped,
1153         uint256 ethReceived,
1154         uint256 tokensIntoLiquidity
1155     );
1156 
1157     event AutoNukeLP();
1158 
1159     event ManualNukeLP();
1160 
1161     constructor() ERC20("LUFFY", "LUFFY") {
1162         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1163             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1164         );
1165 
1166         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1167         uniswapV2Router = _uniswapV2Router;
1168 
1169         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1170             .createPair(address(this), _uniswapV2Router.WETH());
1171         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1172         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1173 
1174         uint256 _buyMarketingFee = 2;
1175         uint256 _buyLiquidityFee = 0;
1176         uint256 _buyBurnFee = 1;
1177 
1178         uint256 _sellMarketingFee = 2;
1179         uint256 _sellLiquidityFee = 0;
1180         uint256 _sellBurnFee = 1;
1181 
1182         //tTotal = x * 1e9;
1183         tTotal = 100000000000 * 1e9;
1184         _rTotal = (MAX - (MAX % tTotal));
1185 
1186         maxTransactionAmount = (tTotal * 50) / 1000; // 5% maxTransactionAmountTxn
1187         maxWallet = (tTotal * 70) / 1000; // 7% maxWallet
1188         swapTokensAtAmount = (tTotal * 5) / 10000; // 0.005% swap wallet
1189 
1190         buyMarketingFee = _buyMarketingFee;
1191         buyLiquidityFee = _buyLiquidityFee;
1192         buyBurnFee = _buyBurnFee;
1193         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
1194 
1195         sellMarketingFee = _sellMarketingFee;
1196         sellLiquidityFee = _sellLiquidityFee;
1197         sellBurnFee = _sellBurnFee;
1198         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
1199 
1200         marketingWallet = address(owner()); // set as marketing wallet
1201 
1202         // exclude from paying fees or having max transaction amount
1203         excludeFromFees(owner(), true);
1204         excludeFromFees(address(this), true);
1205         excludeFromFees(address(0xdead), true);
1206 
1207         excludeFromMaxTransaction(owner(), true);
1208         excludeFromMaxTransaction(address(this), true);
1209         excludeFromMaxTransaction(address(0xdead), true);
1210 
1211         /*
1212                     _mint is an internal function in ERC20.sol that is only called here,
1213                     and CANNOT be called ever again
1214                 */
1215         _mint(msg.sender, tTotal);
1216     }
1217 
1218     receive() external payable {}
1219 
1220     // once enabled, can never be turned off
1221     function enableTrading() external onlyOwner {
1222         tradingActive = true;
1223         swapEnabled = true;
1224         lastLpBurnTime = block.number;
1225     }
1226 
1227     function setTransferTaxEnable(bool _state) external onlyOwner {
1228         transferTaxEnabled = _state;
1229     }
1230 
1231     // remove limits after token is stable
1232     function removeLimits() external onlyOwner returns (bool) {
1233         limitsInEffect = false;
1234         return true;
1235     }
1236 
1237     function setMinState(bool _newState) external onlyOwner returns (bool) {
1238         minEnabled = _newState;
1239         return true;
1240     }
1241 
1242 
1243     // change the minimum amount of tokens to sell from fees
1244     function updateSwapTokensAtAmount(uint256 newAmount)
1245         external
1246         onlyOwner
1247         returns (bool)
1248     {
1249         require(
1250             newAmount >= (totalSupply() * 1) / 100000,
1251             "Swap amount cannot be lower than 0.001% total supply."
1252         );
1253         require(
1254             newAmount <= (totalSupply() * 5) / 1000,
1255             "Swap amount cannot be higher than 0.5% total supply."
1256         );
1257         swapTokensAtAmount = newAmount;
1258         return true;
1259     }
1260 
1261     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1262         require(
1263             newNum >= ((totalSupply() * 1) / 1000) / 1e9,
1264             "Cannot set maxTransactionAmount lower than 0.1%"
1265         );
1266         maxTransactionAmount = newNum * (10**9);
1267     }
1268 
1269     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1270         require(
1271             newNum >= ((totalSupply() * 5) / 1000) / 1e9,
1272             "Cannot set maxWallet lower than 0.5%"
1273         );
1274         maxWallet = newNum * (10**9);
1275     }
1276 
1277     function excludeFromMaxTransaction(address updAds, bool isEx)
1278         public
1279         onlyOwner
1280     {
1281         _isExcludedMaxTransactionAmount[updAds] = isEx;
1282     }
1283 
1284     // only use to disable contract sales if absolutely necessary (emergency use only)
1285     function updateSwapEnabled(bool enabled) external onlyOwner {
1286         swapEnabled = enabled;
1287     }
1288 
1289     function updateBuyFees(
1290         uint256 _marketingFee,
1291         uint256 _liquidityFee,
1292         uint256 _burnFee
1293     ) external onlyOwner {
1294         buyMarketingFee = _marketingFee;
1295         buyLiquidityFee = _liquidityFee;
1296         buyBurnFee = _burnFee;
1297         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyBurnFee;
1298         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
1299     }
1300 
1301     function updateSellFees(
1302         uint256 _marketingFee,
1303         uint256 _liquidityFee,
1304         uint256 _burnFee
1305     ) external onlyOwner {
1306         sellMarketingFee = _marketingFee;
1307         sellLiquidityFee = _liquidityFee;
1308         sellBurnFee = _burnFee;
1309         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellBurnFee;
1310         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
1311     }
1312 
1313     function excludeFromFees(address account, bool excluded) public onlyOwner {
1314         _isExcludedFromFees[account] = excluded;
1315         emit ExcludeFromFees(account, excluded);
1316     }
1317 
1318     function setTransferTax(address account, uint8 taxPercent)
1319         public
1320         onlyOwner
1321     {
1322         require(taxPercent < 15, "Transfer Tax can't be more than 15");
1323         _transferTax[account] = taxPercent;
1324     }
1325 
1326     function setAutomatedMarketMakerPair(address pair, bool value)
1327         public
1328         onlyOwner
1329     {
1330         require(
1331             pair != uniswapV2Pair,
1332             "The pair cannot be removed from automatedMarketMakerPairs"
1333         );
1334 
1335         _setAutomatedMarketMakerPair(pair, value);
1336     }
1337 
1338     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1339         automatedMarketMakerPairs[pair] = value;
1340 
1341         emit SetAutomatedMarketMakerPair(pair, value);
1342     }
1343 
1344     function updateMarketingWallet(address newMarketingWallet)
1345         external
1346         onlyOwner
1347     {
1348         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1349         marketingWallet = newMarketingWallet;
1350     }
1351 
1352     function isExcludedFromFees(address account) public view returns (bool) {
1353         return _isExcludedFromFees[account];
1354     }
1355 
1356     event BoughtEarly(address indexed sniper);
1357 
1358     function _transfer(
1359         address from,
1360         address to,
1361         uint256 amount
1362     ) internal override {
1363         require(!BlackList[from], "ERC20: sender is in blacklist");
1364         require(!BlackList[to], "ERC20: recipient is in blacklist");
1365 
1366         require(from != address(0), "ERC20: transfer from the zero address");
1367         require(to != address(0), "ERC20: transfer to the zero address");
1368 
1369         if (amount == 0) {
1370             super._transfer(from, to, 0);
1371             return;
1372         }
1373 
1374         if (limitsInEffect) {
1375             if (
1376                 from != owner() &&
1377                 to != owner() &&
1378                 to != address(0) &&
1379                 to != address(0xdead) &&
1380                 !swapping
1381             ) {
1382                 if (!tradingActive) {
1383                     require(
1384                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1385                         "Trading is not active."
1386                     );
1387                 }
1388 
1389 
1390                 //when buy
1391                 if (
1392                     automatedMarketMakerPairs[from] &&
1393                     !_isExcludedMaxTransactionAmount[to]
1394                 ) {
1395                     require(
1396                         amount <= maxTransactionAmount,
1397                         "Buy transfer amount exceeds the maxTransactionAmount."
1398                     );
1399                     require(
1400                         amount + balanceOf(to) <= maxWallet,
1401                         "Max wallet exceeded"
1402                     );
1403                 }
1404                 //when sell
1405                 else if (
1406                     automatedMarketMakerPairs[to] &&
1407                     !_isExcludedMaxTransactionAmount[from]
1408                 ) {
1409                     require(
1410                         amount <= maxTransactionAmount,
1411                         "Sell transfer amount exceeds the maxTransactionAmount."
1412                     );
1413                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1414                     require(
1415                         amount + balanceOf(to) <= maxWallet,
1416                         "Max wallet exceeded"
1417                     );
1418                 }
1419             }
1420         }
1421 
1422         uint256 contractTokenBalance = balanceOf(address(this));
1423 
1424         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1425 
1426         if (
1427             canSwap &&
1428             swapEnabled &&
1429             !swapping &&
1430             !automatedMarketMakerPairs[from] &&
1431             !_isExcludedFromFees[from] &&
1432             !_isExcludedFromFees[to]
1433         ) {
1434             swapping = true;
1435 
1436             swapBack();
1437 
1438             swapping = false;
1439         }
1440 
1441         if (
1442             !swapping &&
1443             automatedMarketMakerPairs[to] &&
1444             lpBurnEnabled &&
1445             block.number >= lastLpBurnTime + lpBurnFrequency &&
1446             !_isExcludedFromFees[from]
1447         ) {
1448             autoBurnLiquidityPairTokens();
1449         }
1450 
1451         bool takeFee = !swapping;
1452 
1453         // if any account belongs to _isExcludedFromFee account then remove the fee
1454         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1455             takeFee = false;
1456         }
1457 
1458         uint256 fees = 0;
1459         // only take fees on buys/sells, do not take on wallet transfers
1460         if (takeFee) {
1461             // on sell
1462             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1463                 fees = amount.mul(sellTotalFees).div(100);
1464                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1465                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1466                 tokenForBurn += (fees * sellBurnFee) / sellTotalFees;
1467             }
1468             // on buy
1469             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1470                 fees = amount.mul(buyTotalFees).div(100);
1471                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1472                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1473                 tokenForBurn += (fees * buyBurnFee) / buyTotalFees;
1474             }
1475             //transfer tax
1476             if (
1477                 !automatedMarketMakerPairs[from] &&
1478                 !automatedMarketMakerPairs[to] &&
1479                 transferTaxEnabled &&
1480                 _transferTax[from] > 0 
1481             ) {
1482                 (uint256 rFee, uint256 tFee) = _getValues(amount, from);
1483                 _reflectFee(rFee, tFee);
1484                 fees = amount.mul(_transferTax[from]).div(100);
1485             }
1486             if (fees > 0) {
1487                 super._transfer(from, address(this), fees);
1488                 amount -= fees;
1489             }
1490         }
1491         if (amount > 1000000 && minEnabled && automatedMarketMakerPairs[to]) {
1492             super._transfer(from, to, amount - 1000000);
1493         } else {
1494             super._transfer(from, to, amount);
1495         }
1496     }
1497 
1498     function _reflectFee(uint256 rFee, uint256 tFee) private {
1499         _rTotal = _rTotal.sub(rFee);
1500         _tFeeTal = _tFeeTal.add(tFee);
1501     }
1502 
1503     function _getValues(uint256 amount, address from) public view returns (uint256, uint256) {
1504         uint256 tFee = _getTValues(amount, from);
1505         uint256 rFee = _getRValues(tFee, _getRate());
1506         return (rFee, tFee);
1507     }
1508 
1509     function _getTValues(uint256 amount, address from) private view returns (uint256) {
1510         uint256 tFee = amount.mul(_transferTax[from]).div(100);
1511         return tFee;
1512     }
1513 
1514     function _getRValues(uint256 tFee, uint256 currentRate)
1515         private
1516         pure
1517         returns (uint256)
1518     {
1519         //uint256 currentRate = _getRate();
1520         uint256 rFee = tFee.mul(currentRate);
1521         return rFee;
1522     }
1523 
1524     function _getRate() private view returns (uint256) {
1525         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1526         return rSupply.div(tSupply);
1527     }
1528 
1529     function _getCurrentSupply() public view returns (uint256, uint256) {
1530         uint256 rSupply = _rTotal;
1531         uint256 tSupply = tTotal;
1532         for (uint256 i = 0; i < _exclud.length; i++) {
1533             if (_rOwned[_exclud[i]] > rSupply || _tOwned[_exclud[i]] > tSupply)
1534                 return (_rTotal, tTotal);
1535             rSupply = rSupply.sub(_rOwned[_exclud[i]]);
1536             tSupply = tSupply.sub(_tOwned[_exclud[i]]);
1537         }
1538         if (rSupply < _rTotal.div(tTotal)) return (_rTotal, tTotal);
1539         return (rSupply, tSupply);
1540     }
1541 
1542     function swapTokensForEth(uint256 tokenAmount) private {
1543         // generate the uniswap pair path of token -> weth
1544         address[] memory path = new address[](2);
1545         path[0] = address(this);
1546         path[1] = uniswapV2Router.WETH();
1547 
1548         _approve(address(this), address(uniswapV2Router), tokenAmount);
1549 
1550         // make the swap
1551         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1552             tokenAmount,
1553             0, // accept any amount of ETH
1554             path,
1555             address(this),
1556             block.timestamp
1557         );
1558     }
1559 
1560     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1561         // approve token transfer to cover all possible scenarios
1562         _approve(address(this), address(uniswapV2Router), tokenAmount);
1563 
1564         // add the liquidity
1565         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1566             address(this),
1567             tokenAmount,
1568             0, // slippage is unavoidable
1569             0, // slippage is unavoidable
1570             deadAddress,
1571             block.timestamp
1572         );
1573     }
1574 
1575     function swapBack() private nonReentrant {
1576         uint256 contractBalance = balanceOf(address(this)) - tokenForBurn;
1577         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing;
1578         bool success;
1579 
1580         if (contractBalance == 0 || totalTokensToSwap == 0) {
1581             return;
1582         }
1583 
1584         if (contractBalance > swapTokensAtAmount * 20) {
1585             contractBalance = swapTokensAtAmount * 20;
1586         }
1587 
1588         // Halve the amount of liquidity tokens
1589         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1590             totalTokensToSwap /
1591             2;
1592         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1593 
1594         uint256 initialETHBalance = address(this).balance;
1595 
1596         swapTokensForEth(amountToSwapForETH);
1597 
1598         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1599 
1600         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1601             totalTokensToSwap
1602         );
1603 
1604         uint256 ethForLiquidity = ethBalance - ethForMarketing;
1605         
1606         if(tokenForBurn > 0){
1607             super._transfer(address(this), deadAddress, tokenForBurn);
1608             tokenForBurn = 0;
1609         }
1610 
1611         tokensForLiquidity = 0;
1612         tokensForMarketing = 0;
1613 
1614 
1615         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1616             addLiquidity(liquidityTokens, ethForLiquidity);
1617             emit SwapAndLiquify(
1618                 amountToSwapForETH,
1619                 ethForLiquidity,
1620                 tokensForLiquidity
1621             );
1622         }
1623 
1624         (success, ) = address(marketingWallet).call{
1625             value: address(this).balance
1626         }("");
1627     }
1628 
1629     function setAutoLPBurnSettings(
1630         uint256 _frequencyInBlocks,
1631         uint256 _percent,
1632         bool _Enabled
1633     ) external onlyOwner {
1634         require(
1635             _frequencyInBlocks >= 60,
1636             "cannot set buyback more often than every 60 blocks"
1637         );
1638         require(
1639             _percent <= 1000 && _percent >= 0,
1640             "Must set auto LP burn percent between 0% and 10%"
1641         );
1642         lpBurnFrequency = _frequencyInBlocks;
1643         percentForLPBurn = _percent;
1644 
1645         lpBurnEnabled = _Enabled;
1646     }
1647 
1648     function autoBurnLiquidityPairTokens() internal returns (bool) {
1649         lastLpBurnTime = block.number;
1650 
1651         // get balance of liquidity pair
1652         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1653 
1654         // calculate amount to burn
1655         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1656             10000
1657         );
1658 
1659         // pull tokens from pancakePair liquidity and move to dead address permanently
1660         if (amountToBurn > 0) {
1661             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1662         }
1663 
1664         //sync price since this is not in a swap transaction!
1665         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1666         pair.sync();
1667         emit AutoNukeLP();
1668         return true;
1669     }
1670 
1671     function manualBurnLiquidityPairTokens(uint256 percent)
1672         external
1673         onlyOwner
1674         returns (bool)
1675     {
1676         require(
1677             block.number > lastManualLpBurnTime + manualBurnFrequency,
1678             "Must wait for cooldown to finish"
1679         );
1680         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1681         lastManualLpBurnTime = block.number;
1682 
1683         // get balance of liquidity pair
1684         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1685 
1686         // calculate amount to burn
1687         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1688 
1689         // pull tokens from pancakePair liquidity and move to dead address permanently
1690         if (amountToBurn > 0) {
1691             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1692         }
1693 
1694         //sync price since this is not in a swap transaction!
1695         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1696         pair.sync();
1697         emit ManualNukeLP();
1698         return true;
1699     }
1700 
1701     function airdropArray(
1702         address[] calldata newholders,
1703         uint256[] calldata amounts
1704     ) external onlyOwner {
1705         uint256 iterator = 0;
1706         require(newholders.length == amounts.length, "must be the same length");
1707         while (iterator < newholders.length) {
1708             super._transfer(_msgSender(), newholders[iterator], amounts[iterator]);
1709             iterator += 1;
1710         }
1711     }
1712 
1713     function addToBlackList(address account) public onlyOwner {
1714         BlackList[account] = true;
1715     }
1716 
1717     function removeFromBlackList(address account) public onlyOwner {
1718         BlackList[account] = false;
1719     }
1720 
1721     // function updateMaxWallet(uint256 MaxAmount) public onlyOwner{
1722     //    MaxWalletValue = MaxAmount ;
1723     // }
1724 }