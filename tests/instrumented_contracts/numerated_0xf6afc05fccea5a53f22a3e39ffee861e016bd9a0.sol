1 /*
2                                                                                                                                                                                                                                                                                                                                            
3                                                                        dddddddd                                                                                    
4 LLLLLLLLLLL                                                            d::::::d                                                       lllllll    ffffffffffffffff  
5 L:::::::::L                                                            d::::::d                                                       l:::::l   f::::::::::::::::f 
6 L:::::::::L                                                            d::::::d                                                       l:::::l  f::::::::::::::::::f
7 LL:::::::LL                                                            d:::::d                                                        l:::::l  f::::::fffffff:::::f
8   L:::::L                 aaaaaaaaaaaaa  nnnn  nnnnnnnn        ddddddddd:::::dwwwwwww           wwwww           wwwwwww ooooooooooo    l::::l  f:::::f       ffffff
9   L:::::L                 a::::::::::::a n:::nn::::::::nn    dd::::::::::::::d w:::::w         w:::::w         w:::::woo:::::::::::oo  l::::l  f:::::f             
10   L:::::L                 aaaaaaaaa:::::an::::::::::::::nn  d::::::::::::::::d  w:::::w       w:::::::w       w:::::wo:::::::::::::::o l::::l f:::::::ffffff       
11   L:::::L                          a::::ann:::::::::::::::nd:::::::ddddd:::::d   w:::::w     w:::::::::w     w:::::w o:::::ooooo:::::o l::::l f::::::::::::f       
12   L:::::L                   aaaaaaa:::::a  n:::::nnnn:::::nd::::::d    d:::::d    w:::::w   w:::::w:::::w   w:::::w  o::::o     o::::o l::::l f::::::::::::f       
13   L:::::L                 aa::::::::::::a  n::::n    n::::nd:::::d     d:::::d     w:::::w w:::::w w:::::w w:::::w   o::::o     o::::o l::::l f:::::::ffffff       
14   L:::::L                a::::aaaa::::::a  n::::n    n::::nd:::::d     d:::::d      w:::::w:::::w   w:::::w:::::w    o::::o     o::::o l::::l  f:::::f             
15   L:::::L         LLLLLLa::::a    a:::::a  n::::n    n::::nd:::::d     d:::::d       w:::::::::w     w:::::::::w     o::::o     o::::o l::::l  f:::::f             
16 LL:::::::LLLLLLLLL:::::La::::a    a:::::a  n::::n    n::::nd::::::ddddd::::::dd       w:::::::w       w:::::::w      o:::::ooooo:::::ol::::::lf:::::::f            
17 L::::::::::::::::::::::La:::::aaaa::::::a  n::::n    n::::n d:::::::::::::::::d        w:::::w         w:::::w       o:::::::::::::::ol::::::lf:::::::f            
18 L::::::::::::::::::::::L a::::::::::aa:::a n::::n    n::::n  d:::::::::ddd::::d         w:::w           w:::w         oo:::::::::::oo l::::::lf:::::::f            
19 LLLLLLLLLLLLLLLLLLLLLLLL  aaaaaaaaaa  aaaa nnnnnn    nnnnnn   ddddddddd   ddddd          www             www            ooooooooooo   llllllllfffffffff            
20 
21 Website: https://landwolfeth.com/
22 Telegram: https://t.me/landwolferc
23 Twitter: https://twitter.com/LandWolfToken                                                                                                                                                                                                                                                                                                                                    
24 */
25 // SPDX-License-Identifier: MIT
26 pragma solidity 0.8.10;
27 pragma experimental ABIEncoderV2;
28 
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
39 contract Ownable is Context {
40     address private _owner;
41 
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46 
47     /**
48      * @dev Initializes the contract setting the deployer as the initial owner.
49      */
50     constructor() {
51         _transferOwnership(_msgSender());
52     }
53 
54     /**
55      * @dev Returns the address of the current owner.
56      */
57     function owner() public view virtual returns (address) {
58         return _owner;
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         require(owner() == _msgSender(), "Ownable: caller is not the owner");
66         _;
67     }
68 
69     function renounceOwnership() public virtual onlyOwner {
70         _transferOwnership(address(0));
71     }
72 
73     /**
74      * @dev Transfers ownership of the contract to a new account (`newOwner`).
75      * Can only be called by the current owner.
76      */
77     function transferOwnership(address newOwner) public virtual onlyOwner {
78         require(
79             newOwner != address(0),
80             "Ownable: new owner is the zero address"
81         );
82         _transferOwnership(newOwner);
83     }
84 
85     /**
86      * @dev Transfers ownership of the contract to a new account (`newOwner`).
87      * Internal function without access restriction.
88      */
89     function _transferOwnership(address newOwner) internal virtual {
90         address oldOwner = _owner;
91         _owner = newOwner;
92         emit OwnershipTransferred(oldOwner, newOwner);
93     }
94 }
95 
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
114     function transfer(
115         address recipient,
116         uint256 amount
117     ) external returns (bool);
118 
119     function allowance(
120         address owner,
121         address spender
122     ) external view returns (uint256);
123 
124     function approve(address spender, uint256 amount) external returns (bool);
125 
126     function transferFrom(
127         address sender,
128         address recipient,
129         uint256 amount
130     ) external returns (bool);
131 
132     /**
133      * @dev Emitted when `value` tokens are moved from one account (`from`) to
134      * another (`to`).
135      *
136      * Note that `value` may be zero.
137      */
138     event Transfer(address indexed from, address indexed to, uint256 value);
139 
140     /**
141      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
142      * a call to {approve}. `value` is the new allowance.
143      */
144     event Approval(
145         address indexed owner,
146         address indexed spender,
147         uint256 value
148     );
149 }
150 
151 interface IERC20Metadata is IERC20 {
152     /**
153      * @dev Returns the name of the token.
154      */
155     function name() external view returns (string memory);
156 
157     /**
158      * @dev Returns the symbol of the token.
159      */
160     function symbol() external view returns (string memory);
161 
162     /**
163      * @dev Returns the decimals places of the token.
164      */
165     function decimals() external view returns (uint8);
166 }
167 
168 contract ERC20 is Context, IERC20, IERC20Metadata {
169     mapping(address => uint256) private _balances;
170 
171     mapping(address => mapping(address => uint256)) private _allowances;
172 
173     uint256 private _totalSupply;
174 
175     string private _name;
176     string private _symbol;
177 
178     /**
179      * @dev Sets the values for {name} and {symbol}.
180      *
181      * The default value of {decimals} is 18. To select a different value for
182      * {decimals} you should overload it.
183      *
184      * All two of these values are immutable: they can only be set once during
185      * construction.
186      */
187     constructor(string memory name_, string memory symbol_) {
188         _name = name_;
189         _symbol = symbol_;
190     }
191 
192     /**
193      * @dev Returns the name of the token.
194      */
195     function name() public view virtual override returns (string memory) {
196         return _name;
197     }
198 
199     /**
200      * @dev Returns the symbol of the token, usually a shorter version of the
201      * name.
202      */
203     function symbol() public view virtual override returns (string memory) {
204         return _symbol;
205     }
206 
207     function decimals() public view virtual override returns (uint8) {
208         return 18;
209     }
210 
211     /**
212      * @dev See {IERC20-totalSupply}.
213      */
214     function totalSupply() public view virtual override returns (uint256) {
215         return _totalSupply;
216     }
217 
218     /**
219      * @dev See {IERC20-balanceOf}.
220      */
221     function balanceOf(
222         address account
223     ) public view virtual override returns (uint256) {
224         return _balances[account];
225     }
226 
227     function transfer(
228         address recipient,
229         uint256 amount
230     ) public virtual override returns (bool) {
231         _transfer(_msgSender(), recipient, amount);
232         return true;
233     }
234 
235     /**
236      * @dev See {IERC20-allowance}.
237      */
238     function allowance(
239         address owner,
240         address spender
241     ) public view virtual override returns (uint256) {
242         return _allowances[owner][spender];
243     }
244 
245     /**
246      * @dev See {IERC20-approve}.
247      *
248      * Requirements:
249      *
250      * - `spender` cannot be the zero address.
251      */
252     function approve(
253         address spender,
254         uint256 amount
255     ) public virtual override returns (bool) {
256         _approve(_msgSender(), spender, amount);
257         return true;
258     }
259 
260     function transferFrom(
261         address sender,
262         address recipient,
263         uint256 amount
264     ) public virtual override returns (bool) {
265         _transfer(sender, recipient, amount);
266 
267         uint256 currentAllowance = _allowances[sender][_msgSender()];
268         require(
269             currentAllowance >= amount,
270             "ERC20: transfer amount exceeds allowance"
271         );
272         unchecked {
273             _approve(sender, _msgSender(), currentAllowance - amount);
274         }
275 
276         return true;
277     }
278 
279     function increaseAllowance(
280         address spender,
281         uint256 addedValue
282     ) public virtual returns (bool) {
283         _approve(
284             _msgSender(),
285             spender,
286             _allowances[_msgSender()][spender] + addedValue
287         );
288         return true;
289     }
290 
291     function decreaseAllowance(
292         address spender,
293         uint256 subtractedValue
294     ) public virtual returns (bool) {
295         uint256 currentAllowance = _allowances[_msgSender()][spender];
296         require(
297             currentAllowance >= subtractedValue,
298             "ERC20: decreased allowance below zero"
299         );
300         unchecked {
301             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
302         }
303 
304         return true;
305     }
306 
307     function _transfer(
308         address sender,
309         address recipient,
310         uint256 amount
311     ) internal virtual {
312         require(sender != address(0), "ERC20: transfer from the zero address");
313         require(recipient != address(0), "ERC20: transfer to the zero address");
314 
315         _beforeTokenTransfer(sender, recipient, amount);
316 
317         uint256 senderBalance = _balances[sender];
318         require(
319             senderBalance >= amount,
320             "ERC20: transfer amount exceeds balance"
321         );
322         unchecked {
323             _balances[sender] = senderBalance - amount;
324         }
325         _balances[recipient] += amount;
326 
327         emit Transfer(sender, recipient, amount);
328 
329         _afterTokenTransfer(sender, recipient, amount);
330     }
331 
332     function _mint(address account, uint256 amount) internal virtual {
333         require(account != address(0), "ERC20: mint to the zero address");
334 
335         _beforeTokenTransfer(address(0), account, amount);
336 
337         _totalSupply += amount;
338         _balances[account] += amount;
339         emit Transfer(address(0), account, amount);
340 
341         _afterTokenTransfer(address(0), account, amount);
342     }
343 
344     function _burn(address account, uint256 amount) internal virtual {
345         require(account != address(0), "ERC20: burn from the zero address");
346 
347         _beforeTokenTransfer(account, address(0), amount);
348 
349         uint256 accountBalance = _balances[account];
350         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
351         unchecked {
352             _balances[account] = accountBalance - amount;
353         }
354         _totalSupply -= amount;
355 
356         emit Transfer(account, address(0), amount);
357 
358         _afterTokenTransfer(account, address(0), amount);
359     }
360 
361     function _approve(
362         address owner,
363         address spender,
364         uint256 amount
365     ) internal virtual {
366         require(owner != address(0), "ERC20: approve from the zero address");
367         require(spender != address(0), "ERC20: approve to the zero address");
368 
369         _allowances[owner][spender] = amount;
370         emit Approval(owner, spender, amount);
371     }
372 
373     function _beforeTokenTransfer(
374         address from,
375         address to,
376         uint256 amount
377     ) internal virtual {}
378 
379     function _afterTokenTransfer(
380         address from,
381         address to,
382         uint256 amount
383     ) internal virtual {}
384 }
385 
386 library SafeMath {
387     /**
388      * @dev Returns the addition of two unsigned integers, with an overflow flag.
389      *
390      * _Available since v3.4._
391      */
392     function tryAdd(
393         uint256 a,
394         uint256 b
395     ) internal pure returns (bool, uint256) {
396         unchecked {
397             uint256 c = a + b;
398             if (c < a) return (false, 0);
399             return (true, c);
400         }
401     }
402 
403     /**
404      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
405      *
406      * _Available since v3.4._
407      */
408     function trySub(
409         uint256 a,
410         uint256 b
411     ) internal pure returns (bool, uint256) {
412         unchecked {
413             if (b > a) return (false, 0);
414             return (true, a - b);
415         }
416     }
417 
418     /**
419      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
420      *
421      * _Available since v3.4._
422      */
423     function tryMul(
424         uint256 a,
425         uint256 b
426     ) internal pure returns (bool, uint256) {
427         unchecked {
428             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
429             // benefit is lost if 'b' is also tested.
430             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
431             if (a == 0) return (true, 0);
432             uint256 c = a * b;
433             if (c / a != b) return (false, 0);
434             return (true, c);
435         }
436     }
437 
438     /**
439      * @dev Returns the division of two unsigned integers, with a division by zero flag.
440      *
441      * _Available since v3.4._
442      */
443     function tryDiv(
444         uint256 a,
445         uint256 b
446     ) internal pure returns (bool, uint256) {
447         unchecked {
448             if (b == 0) return (false, 0);
449             return (true, a / b);
450         }
451     }
452 
453     /**
454      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
455      *
456      * _Available since v3.4._
457      */
458     function tryMod(
459         uint256 a,
460         uint256 b
461     ) internal pure returns (bool, uint256) {
462         unchecked {
463             if (b == 0) return (false, 0);
464             return (true, a % b);
465         }
466     }
467 
468     function add(uint256 a, uint256 b) internal pure returns (uint256) {
469         return a + b;
470     }
471 
472     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
473         return a - b;
474     }
475 
476     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
477         return a * b;
478     }
479 
480     function div(uint256 a, uint256 b) internal pure returns (uint256) {
481         return a / b;
482     }
483 
484     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
485         return a % b;
486     }
487 
488     function sub(
489         uint256 a,
490         uint256 b,
491         string memory errorMessage
492     ) internal pure returns (uint256) {
493         unchecked {
494             require(b <= a, errorMessage);
495             return a - b;
496         }
497     }
498 
499     function div(
500         uint256 a,
501         uint256 b,
502         string memory errorMessage
503     ) internal pure returns (uint256) {
504         unchecked {
505             require(b > 0, errorMessage);
506             return a / b;
507         }
508     }
509 
510     function mod(
511         uint256 a,
512         uint256 b,
513         string memory errorMessage
514     ) internal pure returns (uint256) {
515         unchecked {
516             require(b > 0, errorMessage);
517             return a % b;
518         }
519     }
520 }
521 
522 interface IUniswapV2Factory {
523     event PairCreated(
524         address indexed token0,
525         address indexed token1,
526         address pair,
527         uint256
528     );
529 
530     function feeTo() external view returns (address);
531 
532     function feeToSetter() external view returns (address);
533 
534     function getPair(
535         address tokenA,
536         address tokenB
537     ) external view returns (address pair);
538 
539     function allPairs(uint256) external view returns (address pair);
540 
541     function allPairsLength() external view returns (uint256);
542 
543     function createPair(
544         address tokenA,
545         address tokenB
546     ) external returns (address pair);
547 
548     function setFeeTo(address) external;
549 
550     function setFeeToSetter(address) external;
551 }
552 
553 interface IUniswapV2Pair {
554     event Approval(
555         address indexed owner,
556         address indexed spender,
557         uint256 value
558     );
559     event Transfer(address indexed from, address indexed to, uint256 value);
560 
561     function name() external pure returns (string memory);
562 
563     function symbol() external pure returns (string memory);
564 
565     function decimals() external pure returns (uint8);
566 
567     function totalSupply() external view returns (uint256);
568 
569     function balanceOf(address owner) external view returns (uint256);
570 
571     function allowance(
572         address owner,
573         address spender
574     ) external view returns (uint256);
575 
576     function approve(address spender, uint256 value) external returns (bool);
577 
578     function transfer(address to, uint256 value) external returns (bool);
579 
580     function transferFrom(
581         address from,
582         address to,
583         uint256 value
584     ) external returns (bool);
585 
586     function DOMAIN_SEPARATOR() external view returns (bytes32);
587 
588     function PERMIT_TYPEHASH() external pure returns (bytes32);
589 
590     function nonces(address owner) external view returns (uint256);
591 
592     function permit(
593         address owner,
594         address spender,
595         uint256 value,
596         uint256 deadline,
597         uint8 v,
598         bytes32 r,
599         bytes32 s
600     ) external;
601 
602     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
603     event Burn(
604         address indexed sender,
605         uint256 amount0,
606         uint256 amount1,
607         address indexed to
608     );
609     event Swap(
610         address indexed sender,
611         uint256 amount0In,
612         uint256 amount1In,
613         uint256 amount0Out,
614         uint256 amount1Out,
615         address indexed to
616     );
617     event Sync(uint112 reserve0, uint112 reserve1);
618 
619     function MINIMUM_LIQUIDITY() external pure returns (uint256);
620 
621     function factory() external view returns (address);
622 
623     function token0() external view returns (address);
624 
625     function token1() external view returns (address);
626 
627     function getReserves()
628         external
629         view
630         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
631 
632     function price0CumulativeLast() external view returns (uint256);
633 
634     function price1CumulativeLast() external view returns (uint256);
635 
636     function kLast() external view returns (uint256);
637 
638     function mint(address to) external returns (uint256 liquidity);
639 
640     function burn(
641         address to
642     ) external returns (uint256 amount0, uint256 amount1);
643 
644     function swap(
645         uint256 amount0Out,
646         uint256 amount1Out,
647         address to,
648         bytes calldata data
649     ) external;
650 
651     function skim(address to) external;
652 
653     function sync() external;
654 
655     function initialize(address, address) external;
656 }
657 
658 interface IUniswapV2Router02 {
659     function factory() external pure returns (address);
660 
661     function WETH() external pure returns (address);
662 
663     function addLiquidity(
664         address tokenA,
665         address tokenB,
666         uint256 amountADesired,
667         uint256 amountBDesired,
668         uint256 amountAMin,
669         uint256 amountBMin,
670         address to,
671         uint256 deadline
672     ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);
673 
674     function addLiquidityETH(
675         address token,
676         uint256 amountTokenDesired,
677         uint256 amountTokenMin,
678         uint256 amountETHMin,
679         address to,
680         uint256 deadline
681     )
682         external
683         payable
684         returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
685 
686     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
687         uint256 amountIn,
688         uint256 amountOutMin,
689         address[] calldata path,
690         address to,
691         uint256 deadline
692     ) external;
693 
694     function swapExactETHForTokensSupportingFeeOnTransferTokens(
695         uint256 amountOutMin,
696         address[] calldata path,
697         address to,
698         uint256 deadline
699     ) external payable;
700 
701     function swapExactTokensForETHSupportingFeeOnTransferTokens(
702         uint256 amountIn,
703         uint256 amountOutMin,
704         address[] calldata path,
705         address to,
706         uint256 deadline
707     ) external;
708 }
709 
710 contract Landwolf is ERC20, Ownable {
711     using SafeMath for uint256;
712 
713     IUniswapV2Router02 public immutable uniswapV2Router;
714     address public immutable uniswapV2Pair;
715     address public constant deadAddress = address(0xdead);
716 
717     bool private swapping;
718 
719     address public marketingWallet;
720     address public devWallet;
721 
722     uint256 public maxTransactionAmount;
723     uint256 public swapTokensAtAmount;
724     uint256 public maxWallet;
725 
726     bool public limitsInEffect = true;
727     bool public tradingActive = false;
728     bool public swapEnabled = false;
729 
730     uint256 public launchedAt;
731     uint256 public launchedAtTimestamp;
732 
733     uint256 public buyTotalFees = 90;
734     uint256 public buyMarketingFee = 90;
735     uint256 public buyDevFee = 0;
736 
737     uint256 public sellTotalFees = 90;
738     uint256 public sellMarketingFee = 90;
739     uint256 public sellDevFee = 0;
740 
741     uint256 public tokensForMarketing;
742     uint256 public tokensForDev;
743 
744     /******************/
745 
746     // exlcude from fees and max transaction amount
747     mapping(address => bool) private _isExcludedFromFees;
748     mapping(address => bool) public _isExcludedMaxTransactionAmount;
749     mapping(address => bool) public isSniper;
750 
751     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
752     // could be subject to a maximum transfer amount
753     mapping(address => bool) public automatedMarketMakerPairs;
754 
755     event UpdateUniswapV2Router(
756         address indexed newAddress,
757         address indexed oldAddress
758     );
759 
760     event ExcludeFromFees(address indexed account, bool isExcluded);
761 
762     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
763 
764     event marketingWalletUpdated(
765         address indexed newWallet,
766         address indexed oldWallet
767     );
768 
769     event devWalletUpdated(
770         address indexed newWallet,
771         address indexed oldWallet
772     );
773     event SwapAndLiquify(
774         uint256 tokensSwapped,
775         uint256 ethReceived,
776         uint256 tokensIntoLiquidity
777     );
778 
779     constructor() ERC20("Landwolf", "Wolf") {
780         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
781             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
782         );
783 
784         excludeFromMaxTransaction(address(_uniswapV2Router), true);
785         uniswapV2Router = _uniswapV2Router;
786 
787         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
788             .createPair(address(this), _uniswapV2Router.WETH());
789         excludeFromMaxTransaction(address(uniswapV2Pair), true);
790         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
791 
792         uint256 totalSupply = 420_690_000 * 1e18;
793 
794         maxTransactionAmount = totalSupply / 100; // 1% from total supply maxTransactionAmountTxn
795         maxWallet = totalSupply.mul(3) / 100; // 3% from total supply maxWallet
796         swapTokensAtAmount = totalSupply / 1000;
797 
798         marketingWallet = address(msg.sender); // set as marketing wallet
799         devWallet = address(msg.sender); // set as Dev wallet
800 
801         // exclude from paying fees or having max transaction amount
802         excludeFromFees(owner(), true);
803         excludeFromFees(address(this), true);
804         excludeFromFees(address(0xdead), true);
805 
806         excludeFromMaxTransaction(owner(), true);
807         excludeFromMaxTransaction(address(this), true);
808         excludeFromMaxTransaction(address(0xdead), true);
809         /*
810             _mint is an internal function in ERC20.sol that is only called here,
811             and CANNOT be called ever again
812         */
813         _mint(owner(), totalSupply);
814     }
815 
816     receive() external payable {}
817 
818     function launched() internal view returns (bool) {
819         return launchedAt != 0;
820     }
821 
822     function launch() public onlyOwner {
823         require(launchedAt == 0, "Already launched boi");
824         launchedAt = block.number;
825         launchedAtTimestamp = block.timestamp;
826         tradingActive = true;
827         swapEnabled = true;
828     }
829 
830     // remove limits after token is stable
831     function removeLimits() external onlyOwner returns (bool) {
832         limitsInEffect = false;
833         return true;
834     }
835 
836     // change the minimum amount of tokens to sell from fees
837     function updateSwapTokensAtAmount(
838         uint256 newAmount
839     ) external onlyOwner returns (bool) {
840         swapTokensAtAmount = newAmount * (10 ** 18);
841         return true;
842     }
843 
844     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
845         maxTransactionAmount = newNum * (10 ** 18);
846     }
847 
848     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
849         maxWallet = newNum * (10 ** 18);
850     }
851 
852     function excludeFromMaxTransaction(
853         address updAds,
854         bool isEx
855     ) public onlyOwner {
856         _isExcludedMaxTransactionAmount[updAds] = isEx;
857     }
858 
859     // only use to disable contract sales if absolutely necessary (emergency use only)
860     function updateSwapEnabled(bool enabled) external onlyOwner {
861         swapEnabled = enabled;
862     }
863 
864     function updateBuyFees(
865         uint256 _marketingFee,
866         uint256 _devFee
867     ) external onlyOwner {
868         buyMarketingFee = _marketingFee;
869         buyDevFee = _devFee;
870         buyTotalFees = buyMarketingFee + buyDevFee;
871     }
872 
873     function updateSellFees(
874         uint256 _marketingFee,
875         uint256 _devFee
876     ) external onlyOwner {
877         sellMarketingFee = _marketingFee;
878         sellDevFee = _devFee;
879         sellTotalFees = sellMarketingFee + sellDevFee;
880     }
881 
882     function excludeFromFees(address account, bool excluded) public onlyOwner {
883         _isExcludedFromFees[account] = excluded;
884         emit ExcludeFromFees(account, excluded);
885     }
886 
887     function setAutomatedMarketMakerPair(
888         address pair,
889         bool value
890     ) public onlyOwner {
891         require(
892             pair != uniswapV2Pair,
893             "The pair cannot be removed from automatedMarketMakerPairs"
894         );
895 
896         _setAutomatedMarketMakerPair(pair, value);
897     }
898 
899     function _setAutomatedMarketMakerPair(address pair, bool value) private {
900         automatedMarketMakerPairs[pair] = value;
901 
902         emit SetAutomatedMarketMakerPair(pair, value);
903     }
904 
905     function updateMarketingWallet(
906         address newMarketingWallet
907     ) external onlyOwner {
908         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
909         marketingWallet = newMarketingWallet;
910     }
911 
912     function updateDevWallet(address newWallet) external onlyOwner {
913         emit devWalletUpdated(newWallet, devWallet);
914         devWallet = newWallet;
915     }
916 
917     function isExcludedFromFees(address account) public view returns (bool) {
918         return _isExcludedFromFees[account];
919     }
920 
921     function addSniperInList(address _account) external onlyOwner {
922         require(
923             _account != address(uniswapV2Router),
924             "We can not blacklist router"
925         );
926         require(!isSniper[_account], "Sniper already exist");
927         isSniper[_account] = true;
928     }
929 
930     function removeSniperFromList(address _account) external onlyOwner {
931         require(isSniper[_account], "Not a sniper");
932         isSniper[_account] = false;
933     }
934 
935     function _transfer(
936         address from,
937         address to,
938         uint256 amount
939     ) internal override {
940         require(from != address(0), "ERC20: transfer from the zero address");
941         require(to != address(0), "ERC20: transfer to the zero address");
942         require(!isSniper[to], "Sniper detected");
943         require(!isSniper[from], "Sniper detected");
944 
945         if (amount == 0) {
946             super._transfer(from, to, 0);
947             return;
948         }
949 
950         if (limitsInEffect) {
951             if (
952                 from != owner() &&
953                 to != owner() &&
954                 to != address(0) &&
955                 to != address(0xdead) &&
956                 !swapping
957             ) {
958                 if (!tradingActive) {
959                     require(
960                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
961                         "Trading is not active."
962                     );
963                 }
964                 //when buy
965                 if (
966                     automatedMarketMakerPairs[from] &&
967                     !_isExcludedMaxTransactionAmount[to]
968                 ) {
969                     require(
970                         amount <= maxTransactionAmount,
971                         "Buy transfer amount exceeds the maxTransactionAmount."
972                     );
973                     require(
974                         amount + balanceOf(to) <= maxWallet,
975                         "Max wallet exceeded"
976                     );
977                 }
978                 //when sell
979                 else if (
980                     automatedMarketMakerPairs[to] &&
981                     !_isExcludedMaxTransactionAmount[from]
982                 ) {
983                     require(
984                         amount <= maxTransactionAmount,
985                         "Sell transfer amount exceeds the maxTransactionAmount."
986                     );
987                 } else if (!_isExcludedMaxTransactionAmount[to]) {
988                     require(
989                         amount + balanceOf(to) <= maxWallet,
990                         "Max wallet exceeded"
991                     );
992                 }
993             }
994         }
995 
996         uint256 contractTokenBalance = balanceOf(address(this));
997 
998         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
999 
1000         if (
1001             canSwap &&
1002             swapEnabled &&
1003             !swapping &&
1004             !automatedMarketMakerPairs[from] &&
1005             !_isExcludedFromFees[from] &&
1006             !_isExcludedFromFees[to]
1007         ) {
1008             swapping = true;
1009 
1010             swapBack();
1011 
1012             swapping = false;
1013         }
1014 
1015         bool takeFee = !swapping;
1016 
1017         // if any account belongs to _isExcludedFromFee account then remove the fee
1018         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1019             takeFee = false;
1020         }
1021 
1022         uint256 fees = 0;
1023         // only take fees on buys/sells, do not take on wallet transfers
1024         if (takeFee) {
1025             // on sell
1026             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1027                 fees = amount.mul(sellTotalFees).div(100);
1028                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1029                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1030             }
1031             // on buy
1032             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1033                 fees = amount.mul(buyTotalFees).div(100);
1034                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1035                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1036             }
1037 
1038             if (fees > 0) {
1039                 super._transfer(from, address(this), fees);
1040             }
1041 
1042             amount -= fees;
1043         }
1044 
1045         super._transfer(from, to, amount);
1046     }
1047 
1048     function swapTokensForEth(uint256 tokenAmount) private {
1049         // generate the uniswap pair path of token -> weth
1050         address[] memory path = new address[](2);
1051         path[0] = address(this);
1052         path[1] = uniswapV2Router.WETH();
1053 
1054         _approve(address(this), address(uniswapV2Router), tokenAmount);
1055 
1056         // make the swap
1057         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1058             tokenAmount,
1059             0, // accept any amount of ETH
1060             path,
1061             address(this),
1062             block.timestamp
1063         );
1064     }
1065 
1066     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1067         // approve token transfer to cover all possible scenarios
1068         _approve(address(this), address(uniswapV2Router), tokenAmount);
1069 
1070         // add the liquidity
1071         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1072             address(this),
1073             tokenAmount,
1074             0, // slippage is unavoidable
1075             0, // slippage is unavoidable
1076             deadAddress,
1077             block.timestamp
1078         );
1079     }
1080 
1081     function swapBack() private {
1082         uint256 contractBalance = balanceOf(address(this));
1083         uint256 totalTokensToSwap = tokensForMarketing + tokensForDev;
1084         bool success;
1085 
1086         if (contractBalance == 0 || totalTokensToSwap == 0) {
1087             return;
1088         }
1089 
1090         if (contractBalance > swapTokensAtAmount) {
1091             contractBalance = swapTokensAtAmount;
1092         }
1093 
1094         uint256 amountToSwapForETH = contractBalance;
1095 
1096         swapTokensForEth(amountToSwapForETH);
1097 
1098         uint256 ethBalance = address(this).balance;
1099 
1100         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1101             totalTokensToSwap
1102         );
1103 
1104         tokensForMarketing = 0;
1105         tokensForDev = 0;
1106 
1107         (success, ) = address(marketingWallet).call{value: ethForMarketing}("");
1108         (success, ) = address(devWallet).call{value: address(this).balance}("");
1109     }
1110 
1111     // TO transfer tokens to multi users through single transaction
1112     function airdrop(
1113         address[] calldata addresses,
1114         uint256[] calldata amounts
1115     ) external onlyOwner {
1116         require(
1117             addresses.length == amounts.length,
1118             "Array sizes must be equal"
1119         );
1120         uint256 i = 0;
1121         while (i < addresses.length) {
1122             uint256 _amount = amounts[i].mul(1e18);
1123             _transfer(msg.sender, addresses[i], _amount);
1124             i += 1;
1125         }
1126     }
1127 
1128     // to withdarw ETH from contract
1129     function withdrawETH(uint256 _amount) external onlyOwner {
1130         require(address(this).balance >= _amount, "Invalid Amount");
1131         payable(msg.sender).transfer(_amount);
1132     }
1133 
1134     // to withdraw ERC20 tokens from contract
1135     function withdrawToken(IERC20 _token, uint256 _amount) external onlyOwner {
1136         require(_token.balanceOf(address(this)) >= _amount, "Invalid Amount");
1137         _token.transfer(msg.sender, _amount);
1138     }
1139 }