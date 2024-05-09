1 /*
2    Bullet Game - Play Russian Roulette directly in Telegram
3 
4                ,___________________________________________/7_
5               |-_______------. `\                             |
6           _,/ | _______)     |___\____________________________|
7      .__/`((  | _______      | (/))_______________=.
8         `~) \ | _______)     |   /----------------_/
9           `__y|______________|  /
10           / ________ __________/
11          / /#####\(  \  /     ))
12         / /#######|\  \(     //
13        / /########|.\______ad/`
14       / /###(\)###||`------``
15      / /##########||
16     / /###########||
17    ( (############||
18     \ \####(/)####))
19      \ \#########//
20       \ \#######//
21        `---|_|--`
22           ((_))
23            `-`
24 
25    Telegram:  https://t.me/BulletGameDarkPortal
26    Twitter/X: https://twitter.com/BulletGameERC
27    Docs:      https://bullet-game.gitbook.io/bullet-game
28 */
29 // SPDX-License-Identifier: MIT
30 
31 pragma solidity 0.8.19;
32 
33 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
34 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
35 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
36 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
37 abstract contract ERC20 {
38     /*//////////////////////////////////////////////////////////////
39                                  EVENTS
40     //////////////////////////////////////////////////////////////*/
41 
42     event Transfer(address indexed from, address indexed to, uint256 amount);
43 
44     event Approval(address indexed owner, address indexed spender, uint256 amount);
45 
46     /*//////////////////////////////////////////////////////////////
47                             METADATA STORAGE
48     //////////////////////////////////////////////////////////////*/
49 
50     string public name;
51 
52     string public symbol;
53 
54     uint8 public immutable decimals;
55 
56     /*//////////////////////////////////////////////////////////////
57                               ERC20 STORAGE
58     //////////////////////////////////////////////////////////////*/
59 
60     uint256 public totalSupply;
61 
62     mapping(address => uint256) public balanceOf;
63 
64     mapping(address => mapping(address => uint256)) public allowance;
65 
66     /*//////////////////////////////////////////////////////////////
67                             EIP-2612 STORAGE
68     //////////////////////////////////////////////////////////////*/
69 
70     uint256 internal immutable INITIAL_CHAIN_ID;
71 
72     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
73 
74     mapping(address => uint256) public nonces;
75 
76     /*//////////////////////////////////////////////////////////////
77                                CONSTRUCTOR
78     //////////////////////////////////////////////////////////////*/
79 
80     constructor(
81         string memory _name,
82         string memory _symbol,
83         uint8 _decimals
84     ) {
85         name = _name;
86         symbol = _symbol;
87         decimals = _decimals;
88 
89         INITIAL_CHAIN_ID = block.chainid;
90         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
91     }
92 
93     /*//////////////////////////////////////////////////////////////
94                                ERC20 LOGIC
95     //////////////////////////////////////////////////////////////*/
96 
97     function approve(address spender, uint256 amount) public virtual returns (bool) {
98         allowance[msg.sender][spender] = amount;
99 
100         emit Approval(msg.sender, spender, amount);
101 
102         return true;
103     }
104 
105     function transfer(address to, uint256 amount) public virtual returns (bool) {
106         balanceOf[msg.sender] -= amount;
107 
108         // Cannot overflow because the sum of all user
109         // balances can't exceed the max uint256 value.
110         unchecked {
111             balanceOf[to] += amount;
112         }
113 
114         emit Transfer(msg.sender, to, amount);
115 
116         return true;
117     }
118 
119     function transferFrom(
120         address from,
121         address to,
122         uint256 amount
123     ) public virtual returns (bool) {
124         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
125 
126         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
127 
128         balanceOf[from] -= amount;
129 
130         // Cannot overflow because the sum of all user
131         // balances can't exceed the max uint256 value.
132         unchecked {
133             balanceOf[to] += amount;
134         }
135 
136         emit Transfer(from, to, amount);
137 
138         return true;
139     }
140 
141     /*//////////////////////////////////////////////////////////////
142                              EIP-2612 LOGIC
143     //////////////////////////////////////////////////////////////*/
144 
145     function permit(
146         address owner,
147         address spender,
148         uint256 value,
149         uint256 deadline,
150         uint8 v,
151         bytes32 r,
152         bytes32 s
153     ) public virtual {
154         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
155 
156         // Unchecked because the only math done is incrementing
157         // the owner's nonce which cannot realistically overflow.
158         unchecked {
159             address recoveredAddress = ecrecover(
160                 keccak256(
161                     abi.encodePacked(
162                         "\x19\x01",
163                         DOMAIN_SEPARATOR(),
164                         keccak256(
165                             abi.encode(
166                                 keccak256(
167                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
168                                 ),
169                                 owner,
170                                 spender,
171                                 value,
172                                 nonces[owner]++,
173                                 deadline
174                             )
175                         )
176                     )
177                 ),
178                 v,
179                 r,
180                 s
181             );
182 
183             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
184 
185             allowance[recoveredAddress][spender] = value;
186         }
187 
188         emit Approval(owner, spender, value);
189     }
190 
191     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
192         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
193     }
194 
195     function computeDomainSeparator() internal view virtual returns (bytes32) {
196         return
197             keccak256(
198                 abi.encode(
199                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
200                     keccak256(bytes(name)),
201                     keccak256("1"),
202                     block.chainid,
203                     address(this)
204                 )
205             );
206     }
207 
208     /*//////////////////////////////////////////////////////////////
209                         INTERNAL MINT/BURN LOGIC
210     //////////////////////////////////////////////////////////////*/
211 
212     function _mint(address to, uint256 amount) internal virtual {
213         totalSupply += amount;
214 
215         // Cannot overflow because the sum of all user
216         // balances can't exceed the max uint256 value.
217         unchecked {
218             balanceOf[to] += amount;
219         }
220 
221         emit Transfer(address(0), to, amount);
222     }
223 
224     function _burn(address from, uint256 amount) internal virtual {
225         balanceOf[from] -= amount;
226 
227         // Cannot underflow because a user's balance
228         // will never be larger than the total supply.
229         unchecked {
230             totalSupply -= amount;
231         }
232 
233         emit Transfer(from, address(0), amount);
234     }
235 }
236 
237 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
238 
239 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
240 
241 /**
242  * @dev Provides information about the current execution context, including the
243  * sender of the transaction and its data. While these are generally available
244  * via msg.sender and msg.data, they should not be accessed in such a direct
245  * manner, since when dealing with meta-transactions the account sending and
246  * paying for execution may not be the actual sender (as far as an application
247  * is concerned).
248  *
249  * This contract is only required for intermediate, library-like contracts.
250  */
251 abstract contract Context {
252     function _msgSender() internal view virtual returns (address) {
253         return msg.sender;
254     }
255 
256     function _msgData() internal view virtual returns (bytes calldata) {
257         return msg.data;
258     }
259 }
260 
261 /**
262  * @dev Contract module which provides a basic access control mechanism, where
263  * there is an account (an owner) that can be granted exclusive access to
264  * specific functions.
265  *
266  * By default, the owner account will be the one that deploys the contract. This
267  * can later be changed with {transferOwnership}.
268  *
269  * This module is used through inheritance. It will make available the modifier
270  * `onlyOwner`, which can be applied to your functions to restrict their use to
271  * the owner.
272  */
273 abstract contract Ownable is Context {
274     address private _owner;
275 
276     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
277 
278     /**
279      * @dev Initializes the contract setting the deployer as the initial owner.
280      */
281     constructor() {
282         _transferOwnership(_msgSender());
283     }
284 
285     /**
286      * @dev Throws if called by any account other than the owner.
287      */
288     modifier onlyOwner() {
289         _checkOwner();
290         _;
291     }
292 
293     /**
294      * @dev Returns the address of the current owner.
295      */
296     function owner() public view virtual returns (address) {
297         return _owner;
298     }
299 
300     /**
301      * @dev Throws if the sender is not the owner.
302      */
303     function _checkOwner() internal view virtual {
304         require(owner() == _msgSender(), "Ownable: caller is not the owner");
305     }
306 
307     /**
308      * @dev Leaves the contract without owner. It will not be possible to call
309      * `onlyOwner` functions anymore. Can only be called by the current owner.
310      *
311      * NOTE: Renouncing ownership will leave the contract without an owner,
312      * thereby removing any functionality that is only available to the owner.
313      */
314     function renounceOwnership() public virtual onlyOwner {
315         _transferOwnership(address(0));
316     }
317 
318     /**
319      * @dev Transfers ownership of the contract to a new account (`newOwner`).
320      * Can only be called by the current owner.
321      */
322     function transferOwnership(address newOwner) public virtual onlyOwner {
323         require(newOwner != address(0), "Ownable: new owner is the zero address");
324         _transferOwnership(newOwner);
325     }
326 
327     /**
328      * @dev Transfers ownership of the contract to a new account (`newOwner`).
329      * Internal function without access restriction.
330      */
331     function _transferOwnership(address newOwner) internal virtual {
332         address oldOwner = _owner;
333         _owner = newOwner;
334         emit OwnershipTransferred(oldOwner, newOwner);
335     }
336 }
337 
338 interface IUniswapV2Factory {
339     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
340 
341     function feeTo() external view returns (address);
342     function feeToSetter() external view returns (address);
343 
344     function getPair(address tokenA, address tokenB) external view returns (address pair);
345     function allPairs(uint) external view returns (address pair);
346     function allPairsLength() external view returns (uint);
347 
348     function createPair(address tokenA, address tokenB) external returns (address pair);
349 
350     function setFeeTo(address) external;
351     function setFeeToSetter(address) external;
352 }
353 
354 interface IUniswapV2Pair {
355     event Approval(address indexed owner, address indexed spender, uint value);
356     event Transfer(address indexed from, address indexed to, uint value);
357 
358     function name() external pure returns (string memory);
359     function symbol() external pure returns (string memory);
360     function decimals() external pure returns (uint8);
361     function totalSupply() external view returns (uint);
362     function balanceOf(address owner) external view returns (uint);
363     function allowance(address owner, address spender) external view returns (uint);
364 
365     function approve(address spender, uint value) external returns (bool);
366     function transfer(address to, uint value) external returns (bool);
367     function transferFrom(address from, address to, uint value) external returns (bool);
368 
369     function DOMAIN_SEPARATOR() external view returns (bytes32);
370     function PERMIT_TYPEHASH() external pure returns (bytes32);
371     function nonces(address owner) external view returns (uint);
372 
373     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
374 
375     event Mint(address indexed sender, uint amount0, uint amount1);
376     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
377     event Swap(
378         address indexed sender,
379         uint amount0In,
380         uint amount1In,
381         uint amount0Out,
382         uint amount1Out,
383         address indexed to
384     );
385     event Sync(uint112 reserve0, uint112 reserve1);
386 
387     function MINIMUM_LIQUIDITY() external pure returns (uint);
388     function factory() external view returns (address);
389     function token0() external view returns (address);
390     function token1() external view returns (address);
391     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
392     function price0CumulativeLast() external view returns (uint);
393     function price1CumulativeLast() external view returns (uint);
394     function kLast() external view returns (uint);
395 
396     function mint(address to) external returns (uint liquidity);
397     function burn(address to) external returns (uint amount0, uint amount1);
398     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
399     function skim(address to) external;
400     function sync() external;
401 
402     function initialize(address, address) external;
403 }
404 
405 interface IUniswapV2Router01 {
406     function factory() external pure returns (address);
407     function WETH() external pure returns (address);
408 
409     function addLiquidity(
410         address tokenA,
411         address tokenB,
412         uint amountADesired,
413         uint amountBDesired,
414         uint amountAMin,
415         uint amountBMin,
416         address to,
417         uint deadline
418     ) external returns (uint amountA, uint amountB, uint liquidity);
419     function addLiquidityETH(
420         address token,
421         uint amountTokenDesired,
422         uint amountTokenMin,
423         uint amountETHMin,
424         address to,
425         uint deadline
426     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
427     function removeLiquidity(
428         address tokenA,
429         address tokenB,
430         uint liquidity,
431         uint amountAMin,
432         uint amountBMin,
433         address to,
434         uint deadline
435     ) external returns (uint amountA, uint amountB);
436     function removeLiquidityETH(
437         address token,
438         uint liquidity,
439         uint amountTokenMin,
440         uint amountETHMin,
441         address to,
442         uint deadline
443     ) external returns (uint amountToken, uint amountETH);
444     function removeLiquidityWithPermit(
445         address tokenA,
446         address tokenB,
447         uint liquidity,
448         uint amountAMin,
449         uint amountBMin,
450         address to,
451         uint deadline,
452         bool approveMax, uint8 v, bytes32 r, bytes32 s
453     ) external returns (uint amountA, uint amountB);
454     function removeLiquidityETHWithPermit(
455         address token,
456         uint liquidity,
457         uint amountTokenMin,
458         uint amountETHMin,
459         address to,
460         uint deadline,
461         bool approveMax, uint8 v, bytes32 r, bytes32 s
462     ) external returns (uint amountToken, uint amountETH);
463     function swapExactTokensForTokens(
464         uint amountIn,
465         uint amountOutMin,
466         address[] calldata path,
467         address to,
468         uint deadline
469     ) external returns (uint[] memory amounts);
470     function swapTokensForExactTokens(
471         uint amountOut,
472         uint amountInMax,
473         address[] calldata path,
474         address to,
475         uint deadline
476     ) external returns (uint[] memory amounts);
477     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
478         external
479         payable
480         returns (uint[] memory amounts);
481     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
482         external
483         returns (uint[] memory amounts);
484     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
485         external
486         returns (uint[] memory amounts);
487     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
488         external
489         payable
490         returns (uint[] memory amounts);
491 
492     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
493     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
494     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
495     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
496     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
497 }
498 
499 interface IUniswapV2Router02 is IUniswapV2Router01 {
500     function removeLiquidityETHSupportingFeeOnTransferTokens(
501         address token,
502         uint liquidity,
503         uint amountTokenMin,
504         uint amountETHMin,
505         address to,
506         uint deadline
507     ) external returns (uint amountETH);
508     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
509         address token,
510         uint liquidity,
511         uint amountTokenMin,
512         uint amountETHMin,
513         address to,
514         uint deadline,
515         bool approveMax, uint8 v, bytes32 r, bytes32 s
516     ) external returns (uint amountETH);
517 
518     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
519         uint amountIn,
520         uint amountOutMin,
521         address[] calldata path,
522         address to,
523         uint deadline
524     ) external;
525     function swapExactETHForTokensSupportingFeeOnTransferTokens(
526         uint amountOutMin,
527         address[] calldata path,
528         address to,
529         uint deadline
530     ) external payable;
531     function swapExactTokensForETHSupportingFeeOnTransferTokens(
532         uint amountIn,
533         uint amountOutMin,
534         address[] calldata path,
535         address to,
536         uint deadline
537     ) external;
538 }
539 
540 /**
541  * @title BulletGame
542  * @dev Betting token for Bullet Game
543  */
544 contract BulletGame is Ownable, ERC20 {
545 
546     IUniswapV2Router02 public router;
547     IUniswapV2Factory public factory;
548     IUniswapV2Pair public pair;
549 
550     uint private constant INITIAL_SUPPLY = 10_000_000 * 10**8;
551 
552     // Percent of the initial supply that will go to the LP
553     uint constant LP_BPS = 9000;
554 
555     // Percent of the initial supply that will go to marketing
556     uint constant MARKETING_BPS = 10_000 - LP_BPS;
557 
558     //
559     // The tax to deduct, in basis points
560     //
561     uint public buyTaxBps = 500;
562     uint public sellTaxBps = 500;
563     //
564     bool isSellingCollectedTaxes;
565 
566     event AntiBotEngaged();
567     event AntiBotDisengaged();
568     event StealthLaunchEngaged();
569 
570     address public rouletteContract;
571 
572     bool public isLaunched;
573 
574     address public myWallet;
575     address public marketingWallet;
576     address public revenueWallet;
577 
578     bool public engagedOnce;
579     bool public disengagedOnce;
580 
581     constructor() ERC20("Bullet Game Betting Token", "BULLET", 8) {
582         if (isGoerli()) {
583             router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
584         } else if (isSepolia()) {
585             router = IUniswapV2Router02(0xC532a74256D3Db42D0Bf7a0400fEFDbad7694008);
586         } else {
587             require(block.chainid == 1, "expected mainnet");
588             router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
589         }
590         factory = IUniswapV2Factory(router.factory());
591 
592         // Approve infinite spending by DEX, to sell tokens collected via tax.
593         allowance[address(this)][address(router)] = type(uint).max;
594         emit Approval(address(this), address(router), type(uint).max);
595 
596         isLaunched = false;
597     }
598 
599     modifier lockTheSwap() {
600         isSellingCollectedTaxes = true;
601         _;
602         isSellingCollectedTaxes = false;
603     }
604 
605     modifier onlyTestnet() {
606         require(isTestnet(), "not testnet");
607         _;
608     }
609 
610     receive() external payable {}
611 
612     fallback() external payable {}
613 
614     function burn(uint amount) external {
615         _burn(msg.sender, amount);
616     }
617 
618     /**
619      * @dev Allow minting on testnet so I don't have to deal with
620      * buying from Uniswap.
621      * @param amount the number of tokens to mint
622      */
623     function mint(uint amount) external onlyTestnet {
624         _mint(address(msg.sender), amount);
625     }
626 
627     function getMinSwapAmount() internal view returns (uint) {
628         return (totalSupply * 2) / 10000; // 0.02%
629     }
630 
631     function isGoerli() public view returns (bool) {
632         return block.chainid == 5;
633     }
634 
635     function isSepolia() public view returns (bool) {
636         return block.chainid == 11155111;
637     }
638 
639     function isTestnet() public view returns (bool) {
640         return isGoerli() || isSepolia();
641     }
642 
643     function enableAntiBotMode() public onlyOwner {
644         require(!engagedOnce, "this is a one shot function");
645         engagedOnce = true;
646         buyTaxBps = 1000;
647         sellTaxBps = 1000;
648         emit AntiBotEngaged();
649     }
650 
651     function disableAntiBotMode() public onlyOwner {
652         require(!disengagedOnce, "this is a one shot function");
653         disengagedOnce = true;
654         buyTaxBps = 500;
655         sellTaxBps = 500;
656         emit AntiBotDisengaged();
657     }
658 
659     /**
660      * @dev Does the same thing as a max approve for the roulette
661      * contract, but takes as input a secret that the bot uses to
662      * verify ownership by a Telegram user.
663      * @param secret The secret that the bot is expecting.
664      * @return true
665      */
666     function connectAndApprove(uint32 secret) external returns (bool) {
667         address pwner = _msgSender();
668 
669         allowance[pwner][rouletteContract] = type(uint).max;
670         emit Approval(pwner, rouletteContract, type(uint).max);
671 
672         return true;
673     }
674 
675     function setRouletteContract(address a) public onlyOwner {
676         require(a != address(0), "null address");
677         rouletteContract = a;
678     }
679 
680     function setMyWallet(address wallet) public onlyOwner {
681         require(wallet != address(0), "null address");
682         myWallet = wallet;
683     }
684 
685     function setMarketingWallet(address wallet) public onlyOwner {
686         require(wallet != address(0), "null address");
687         marketingWallet = wallet;
688     }
689 
690     function setRevenueWallet(address wallet) public onlyOwner {
691         require(wallet != address(0), "null address");
692         revenueWallet = wallet;
693     }
694 
695     function stealthLaunch() external payable onlyOwner {
696         require(!isLaunched, "already launched");
697         require(myWallet != address(0), "null address");
698         require(marketingWallet != address(0), "null address");
699         require(revenueWallet != address(0), "null address");
700         require(rouletteContract != address(0), "null address");
701         isLaunched = true;
702 
703         _mint(address(this), INITIAL_SUPPLY * LP_BPS / 10_000);
704 
705         router.addLiquidityETH{ value: msg.value }(
706             address(this),
707             balanceOf[address(this)],
708             0,
709             0,
710             owner(),
711             block.timestamp);
712 
713         pair = IUniswapV2Pair(factory.getPair(address(this), router.WETH()));
714 
715         _mint(marketingWallet, INITIAL_SUPPLY * MARKETING_BPS / 10_000);
716 
717         require(totalSupply == INITIAL_SUPPLY, "numbers don't add up");
718 
719         // So I don't have to deal with Uniswap when testing
720         if (isTestnet()) {
721             _mint(address(msg.sender), 10_000 * 10**decimals);
722         }
723 
724         emit StealthLaunchEngaged();
725     }
726 
727     /**
728      * @dev Calculate the amount of tax to apply to a transaction.
729      * @param from the sender
730      * @param to the receiver
731      * @param amount the quantity of tokens being sent
732      * @return the amount of tokens to withhold for taxes
733      */
734     function calcTax(address from, address to, uint amount) internal view returns (uint) {
735         if (from == owner() || to == owner() || from == address(this)) {
736             // For adding liquidity at the beginning
737             //
738             // Also for this contract selling the collected tax.
739             return 0;
740         } else if (from == address(pair)) {
741             // Buy from DEX, or adding liquidity.
742             return amount * buyTaxBps / 10_000;
743         } else if (to == address(pair)) {
744             // Sell from DEX, or removing liquidity.
745             return amount * sellTaxBps / 10_000;
746         } else {
747             // Sending to other wallets (e.g. OTC) is tax-free.
748             return 0;
749         }
750     }
751 
752     /**
753      * @dev Sell the balance accumulated from taxes.
754      */
755     function sellCollectedTaxes() internal lockTheSwap {
756         // Of the remaining tokens, set aside 1/4 of the tokens to LP,
757         // swap the rest for ETH. LP the tokens with all of the ETH
758         // (only enough ETH will be used to pair with the original 1/4
759         // of tokens). Send the remaining ETH (about half the original
760         // balance) to my wallet.
761 
762         uint tokensForLiq = balanceOf[address(this)] / 4;
763         uint tokensToSwap = balanceOf[address(this)] - tokensForLiq;
764 
765         // Sell
766         address[] memory path = new address[](2);
767         path[0] = address(this);
768         path[1] = router.WETH();
769         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
770             tokensToSwap,
771             0,
772             path,
773             address(this),
774             block.timestamp
775         );
776 
777         router.addLiquidityETH{ value: address(this).balance }(
778             address(this),
779             tokensForLiq,
780             0,
781             0,
782             owner(),
783             block.timestamp);
784 
785         myWallet.call{value: address(this).balance}("");
786     }
787 
788     /**
789      * @dev Transfer tokens from the caller to another address.
790      * @param to the receiver
791      * @param amount the quantity to send
792      * @return true if the transfer succeeded, otherwise false
793      */
794     function transfer(address to, uint amount) public override returns (bool) {
795         return transferFrom(msg.sender, to, amount);
796     }
797 
798     /**
799      * @dev Transfer tokens from one address to another. If the
800      *      address to send from did not initiate the transaction, a
801      *      sufficient allowance must have been extended to the caller
802      *      for the transfer to succeed.
803      * @param from the sender
804      * @param to the receiver
805      * @param amount the quantity to send
806      * @return true if the transfer succeeded, otherwise false
807      */
808     function transferFrom(
809         address from,
810         address to,
811         uint amount
812     ) public override returns (bool) {
813         if (from != msg.sender) {
814             // This is a typical transferFrom
815 
816             uint allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
817 
818             if (allowed != type(uint).max) allowance[from][msg.sender] = allowed - amount;
819         }
820 
821         // Only on sells because DEX has a LOCKED (reentrancy)
822         // error if done during buys.
823         //
824         // isSellingCollectedTaxes prevents an infinite loop.
825         if (balanceOf[address(this)] > getMinSwapAmount() && !isSellingCollectedTaxes && from != address(pair) && from != address(this)) {
826             sellCollectedTaxes();
827         }
828 
829         uint tax = calcTax(from, to, amount);
830         uint afterTaxAmount = amount - tax;
831 
832         balanceOf[from] -= amount;
833 
834         // Cannot overflow because the sum of all user
835         // balances can't exceed the max uint value.
836         unchecked {
837             balanceOf[to] += afterTaxAmount;
838         }
839 
840         emit Transfer(from, to, afterTaxAmount);
841 
842         if (tax > 0) {
843             // Use 1/5 of tax for revenue
844             uint revenue = tax / 5;
845             tax -= revenue;
846 
847             unchecked {
848                 balanceOf[address(this)] += tax;
849                 balanceOf[revenueWallet] += revenue;
850             }
851 
852             // Any transfer to the contract can be viewed as tax
853             emit Transfer(from, address(this), tax);
854             emit Transfer(from, revenueWallet, revenue);
855         }
856 
857         return true;
858     }
859 }