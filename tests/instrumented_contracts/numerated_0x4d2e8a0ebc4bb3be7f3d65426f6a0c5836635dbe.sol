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
33 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
34 
35 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
36 
37 /**
38  * @dev Provides information about the current execution context, including the
39  * sender of the transaction and its data. While these are generally available
40  * via msg.sender and msg.data, they should not be accessed in such a direct
41  * manner, since when dealing with meta-transactions the account sending and
42  * paying for execution may not be the actual sender (as far as an application
43  * is concerned).
44  *
45  * This contract is only required for intermediate, library-like contracts.
46  */
47 abstract contract Context {
48     function _msgSender() internal view virtual returns (address) {
49         return msg.sender;
50     }
51 
52     function _msgData() internal view virtual returns (bytes calldata) {
53         return msg.data;
54     }
55 }
56 
57 /**
58  * @dev Contract module which provides a basic access control mechanism, where
59  * there is an account (an owner) that can be granted exclusive access to
60  * specific functions.
61  *
62  * By default, the owner account will be the one that deploys the contract. This
63  * can later be changed with {transferOwnership}.
64  *
65  * This module is used through inheritance. It will make available the modifier
66  * `onlyOwner`, which can be applied to your functions to restrict their use to
67  * the owner.
68  */
69 abstract contract Ownable is Context {
70     address private _owner;
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74     /**
75      * @dev Initializes the contract setting the deployer as the initial owner.
76      */
77     constructor() {
78         _transferOwnership(_msgSender());
79     }
80 
81     /**
82      * @dev Throws if called by any account other than the owner.
83      */
84     modifier onlyOwner() {
85         _checkOwner();
86         _;
87     }
88 
89     /**
90      * @dev Returns the address of the current owner.
91      */
92     function owner() public view virtual returns (address) {
93         return _owner;
94     }
95 
96     /**
97      * @dev Throws if the sender is not the owner.
98      */
99     function _checkOwner() internal view virtual {
100         require(owner() == _msgSender(), "Ownable: caller is not the owner");
101     }
102 
103     /**
104      * @dev Leaves the contract without owner. It will not be possible to call
105      * `onlyOwner` functions anymore. Can only be called by the current owner.
106      *
107      * NOTE: Renouncing ownership will leave the contract without an owner,
108      * thereby removing any functionality that is only available to the owner.
109      */
110     function renounceOwnership() public virtual onlyOwner {
111         _transferOwnership(address(0));
112     }
113 
114     /**
115      * @dev Transfers ownership of the contract to a new account (`newOwner`).
116      * Can only be called by the current owner.
117      */
118     function transferOwnership(address newOwner) public virtual onlyOwner {
119         require(newOwner != address(0), "Ownable: new owner is the zero address");
120         _transferOwnership(newOwner);
121     }
122 
123     /**
124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
125      * Internal function without access restriction.
126      */
127     function _transferOwnership(address newOwner) internal virtual {
128         address oldOwner = _owner;
129         _owner = newOwner;
130         emit OwnershipTransferred(oldOwner, newOwner);
131     }
132 }
133 
134 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
135 
136 /**
137  * @dev Interface of the ERC20 standard as defined in the EIP.
138  */
139 interface IERC20 {
140     /**
141      * @dev Emitted when `value` tokens are moved from one account (`from`) to
142      * another (`to`).
143      *
144      * Note that `value` may be zero.
145      */
146     event Transfer(address indexed from, address indexed to, uint256 value);
147 
148     /**
149      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
150      * a call to {approve}. `value` is the new allowance.
151      */
152     event Approval(address indexed owner, address indexed spender, uint256 value);
153 
154     /**
155      * @dev Returns the amount of tokens in existence.
156      */
157     function totalSupply() external view returns (uint256);
158 
159     /**
160      * @dev Returns the amount of tokens owned by `account`.
161      */
162     function balanceOf(address account) external view returns (uint256);
163 
164     /**
165      * @dev Moves `amount` tokens from the caller's account to `to`.
166      *
167      * Returns a boolean value indicating whether the operation succeeded.
168      *
169      * Emits a {Transfer} event.
170      */
171     function transfer(address to, uint256 amount) external returns (bool);
172 
173     /**
174      * @dev Returns the remaining number of tokens that `spender` will be
175      * allowed to spend on behalf of `owner` through {transferFrom}. This is
176      * zero by default.
177      *
178      * This value changes when {approve} or {transferFrom} are called.
179      */
180     function allowance(address owner, address spender) external view returns (uint256);
181 
182     /**
183      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
184      *
185      * Returns a boolean value indicating whether the operation succeeded.
186      *
187      * IMPORTANT: Beware that changing an allowance with this method brings the risk
188      * that someone may use both the old and the new allowance by unfortunate
189      * transaction ordering. One possible solution to mitigate this race
190      * condition is to first reduce the spender's allowance to 0 and set the
191      * desired value afterwards:
192      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
193      *
194      * Emits an {Approval} event.
195      */
196     function approve(address spender, uint256 amount) external returns (bool);
197 
198     /**
199      * @dev Moves `amount` tokens from `from` to `to` using the
200      * allowance mechanism. `amount` is then deducted from the caller's
201      * allowance.
202      *
203      * Returns a boolean value indicating whether the operation succeeded.
204      *
205      * Emits a {Transfer} event.
206      */
207     function transferFrom(
208         address from,
209         address to,
210         uint256 amount
211     ) external returns (bool);
212 }
213 
214 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
215 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
216 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
217 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
218 abstract contract ERC20 {
219     /*//////////////////////////////////////////////////////////////
220                                  EVENTS
221     //////////////////////////////////////////////////////////////*/
222 
223     event Transfer(address indexed from, address indexed to, uint256 amount);
224 
225     event Approval(address indexed owner, address indexed spender, uint256 amount);
226 
227     /*//////////////////////////////////////////////////////////////
228                             METADATA STORAGE
229     //////////////////////////////////////////////////////////////*/
230 
231     string public name;
232 
233     string public symbol;
234 
235     uint8 public immutable decimals;
236 
237     /*//////////////////////////////////////////////////////////////
238                               ERC20 STORAGE
239     //////////////////////////////////////////////////////////////*/
240 
241     uint256 public totalSupply;
242 
243     mapping(address => uint256) public balanceOf;
244 
245     mapping(address => mapping(address => uint256)) public allowance;
246 
247     /*//////////////////////////////////////////////////////////////
248                             EIP-2612 STORAGE
249     //////////////////////////////////////////////////////////////*/
250 
251     uint256 internal immutable INITIAL_CHAIN_ID;
252 
253     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
254 
255     mapping(address => uint256) public nonces;
256 
257     /*//////////////////////////////////////////////////////////////
258                                CONSTRUCTOR
259     //////////////////////////////////////////////////////////////*/
260 
261     constructor(
262         string memory _name,
263         string memory _symbol,
264         uint8 _decimals
265     ) {
266         name = _name;
267         symbol = _symbol;
268         decimals = _decimals;
269 
270         INITIAL_CHAIN_ID = block.chainid;
271         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
272     }
273 
274     /*//////////////////////////////////////////////////////////////
275                                ERC20 LOGIC
276     //////////////////////////////////////////////////////////////*/
277 
278     function approve(address spender, uint256 amount) public virtual returns (bool) {
279         allowance[msg.sender][spender] = amount;
280 
281         emit Approval(msg.sender, spender, amount);
282 
283         return true;
284     }
285 
286     function transfer(address to, uint256 amount) public virtual returns (bool) {
287         balanceOf[msg.sender] -= amount;
288 
289         // Cannot overflow because the sum of all user
290         // balances can't exceed the max uint256 value.
291         unchecked {
292             balanceOf[to] += amount;
293         }
294 
295         emit Transfer(msg.sender, to, amount);
296 
297         return true;
298     }
299 
300     function transferFrom(
301         address from,
302         address to,
303         uint256 amount
304     ) public virtual returns (bool) {
305         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
306 
307         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
308 
309         balanceOf[from] -= amount;
310 
311         // Cannot overflow because the sum of all user
312         // balances can't exceed the max uint256 value.
313         unchecked {
314             balanceOf[to] += amount;
315         }
316 
317         emit Transfer(from, to, amount);
318 
319         return true;
320     }
321 
322     /*//////////////////////////////////////////////////////////////
323                              EIP-2612 LOGIC
324     //////////////////////////////////////////////////////////////*/
325 
326     function permit(
327         address owner,
328         address spender,
329         uint256 value,
330         uint256 deadline,
331         uint8 v,
332         bytes32 r,
333         bytes32 s
334     ) public virtual {
335         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
336 
337         // Unchecked because the only math done is incrementing
338         // the owner's nonce which cannot realistically overflow.
339         unchecked {
340             address recoveredAddress = ecrecover(
341                 keccak256(
342                     abi.encodePacked(
343                         "\x19\x01",
344                         DOMAIN_SEPARATOR(),
345                         keccak256(
346                             abi.encode(
347                                 keccak256(
348                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
349                                 ),
350                                 owner,
351                                 spender,
352                                 value,
353                                 nonces[owner]++,
354                                 deadline
355                             )
356                         )
357                     )
358                 ),
359                 v,
360                 r,
361                 s
362             );
363 
364             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
365 
366             allowance[recoveredAddress][spender] = value;
367         }
368 
369         emit Approval(owner, spender, value);
370     }
371 
372     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
373         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
374     }
375 
376     function computeDomainSeparator() internal view virtual returns (bytes32) {
377         return
378             keccak256(
379                 abi.encode(
380                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
381                     keccak256(bytes(name)),
382                     keccak256("1"),
383                     block.chainid,
384                     address(this)
385                 )
386             );
387     }
388 
389     /*//////////////////////////////////////////////////////////////
390                         INTERNAL MINT/BURN LOGIC
391     //////////////////////////////////////////////////////////////*/
392 
393     function _mint(address to, uint256 amount) internal virtual {
394         totalSupply += amount;
395 
396         // Cannot overflow because the sum of all user
397         // balances can't exceed the max uint256 value.
398         unchecked {
399             balanceOf[to] += amount;
400         }
401 
402         emit Transfer(address(0), to, amount);
403     }
404 
405     function _burn(address from, uint256 amount) internal virtual {
406         balanceOf[from] -= amount;
407 
408         // Cannot underflow because a user's balance
409         // will never be larger than the total supply.
410         unchecked {
411             totalSupply -= amount;
412         }
413 
414         emit Transfer(from, address(0), amount);
415     }
416 }
417 
418 interface IUniswapV2Factory {
419     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
420 
421     function feeTo() external view returns (address);
422     function feeToSetter() external view returns (address);
423 
424     function getPair(address tokenA, address tokenB) external view returns (address pair);
425     function allPairs(uint) external view returns (address pair);
426     function allPairsLength() external view returns (uint);
427 
428     function createPair(address tokenA, address tokenB) external returns (address pair);
429 
430     function setFeeTo(address) external;
431     function setFeeToSetter(address) external;
432 }
433 
434 interface IUniswapV2Pair {
435     event Approval(address indexed owner, address indexed spender, uint value);
436     event Transfer(address indexed from, address indexed to, uint value);
437 
438     function name() external pure returns (string memory);
439     function symbol() external pure returns (string memory);
440     function decimals() external pure returns (uint8);
441     function totalSupply() external view returns (uint);
442     function balanceOf(address owner) external view returns (uint);
443     function allowance(address owner, address spender) external view returns (uint);
444 
445     function approve(address spender, uint value) external returns (bool);
446     function transfer(address to, uint value) external returns (bool);
447     function transferFrom(address from, address to, uint value) external returns (bool);
448 
449     function DOMAIN_SEPARATOR() external view returns (bytes32);
450     function PERMIT_TYPEHASH() external pure returns (bytes32);
451     function nonces(address owner) external view returns (uint);
452 
453     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
454 
455     event Mint(address indexed sender, uint amount0, uint amount1);
456     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
457     event Swap(
458         address indexed sender,
459         uint amount0In,
460         uint amount1In,
461         uint amount0Out,
462         uint amount1Out,
463         address indexed to
464     );
465     event Sync(uint112 reserve0, uint112 reserve1);
466 
467     function MINIMUM_LIQUIDITY() external pure returns (uint);
468     function factory() external view returns (address);
469     function token0() external view returns (address);
470     function token1() external view returns (address);
471     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
472     function price0CumulativeLast() external view returns (uint);
473     function price1CumulativeLast() external view returns (uint);
474     function kLast() external view returns (uint);
475 
476     function mint(address to) external returns (uint liquidity);
477     function burn(address to) external returns (uint amount0, uint amount1);
478     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
479     function skim(address to) external;
480     function sync() external;
481 
482     function initialize(address, address) external;
483 }
484 
485 interface IUniswapV2Router01 {
486     function factory() external pure returns (address);
487     function WETH() external pure returns (address);
488 
489     function addLiquidity(
490         address tokenA,
491         address tokenB,
492         uint amountADesired,
493         uint amountBDesired,
494         uint amountAMin,
495         uint amountBMin,
496         address to,
497         uint deadline
498     ) external returns (uint amountA, uint amountB, uint liquidity);
499     function addLiquidityETH(
500         address token,
501         uint amountTokenDesired,
502         uint amountTokenMin,
503         uint amountETHMin,
504         address to,
505         uint deadline
506     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
507     function removeLiquidity(
508         address tokenA,
509         address tokenB,
510         uint liquidity,
511         uint amountAMin,
512         uint amountBMin,
513         address to,
514         uint deadline
515     ) external returns (uint amountA, uint amountB);
516     function removeLiquidityETH(
517         address token,
518         uint liquidity,
519         uint amountTokenMin,
520         uint amountETHMin,
521         address to,
522         uint deadline
523     ) external returns (uint amountToken, uint amountETH);
524     function removeLiquidityWithPermit(
525         address tokenA,
526         address tokenB,
527         uint liquidity,
528         uint amountAMin,
529         uint amountBMin,
530         address to,
531         uint deadline,
532         bool approveMax, uint8 v, bytes32 r, bytes32 s
533     ) external returns (uint amountA, uint amountB);
534     function removeLiquidityETHWithPermit(
535         address token,
536         uint liquidity,
537         uint amountTokenMin,
538         uint amountETHMin,
539         address to,
540         uint deadline,
541         bool approveMax, uint8 v, bytes32 r, bytes32 s
542     ) external returns (uint amountToken, uint amountETH);
543     function swapExactTokensForTokens(
544         uint amountIn,
545         uint amountOutMin,
546         address[] calldata path,
547         address to,
548         uint deadline
549     ) external returns (uint[] memory amounts);
550     function swapTokensForExactTokens(
551         uint amountOut,
552         uint amountInMax,
553         address[] calldata path,
554         address to,
555         uint deadline
556     ) external returns (uint[] memory amounts);
557     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
558         external
559         payable
560         returns (uint[] memory amounts);
561     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
562         external
563         returns (uint[] memory amounts);
564     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
565         external
566         returns (uint[] memory amounts);
567     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
568         external
569         payable
570         returns (uint[] memory amounts);
571 
572     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
573     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
574     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
575     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
576     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
577 }
578 
579 interface IUniswapV2Router02 is IUniswapV2Router01 {
580     function removeLiquidityETHSupportingFeeOnTransferTokens(
581         address token,
582         uint liquidity,
583         uint amountTokenMin,
584         uint amountETHMin,
585         address to,
586         uint deadline
587     ) external returns (uint amountETH);
588     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
589         address token,
590         uint liquidity,
591         uint amountTokenMin,
592         uint amountETHMin,
593         address to,
594         uint deadline,
595         bool approveMax, uint8 v, bytes32 r, bytes32 s
596     ) external returns (uint amountETH);
597 
598     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
599         uint amountIn,
600         uint amountOutMin,
601         address[] calldata path,
602         address to,
603         uint deadline
604     ) external;
605     function swapExactETHForTokensSupportingFeeOnTransferTokens(
606         uint amountOutMin,
607         address[] calldata path,
608         address to,
609         uint deadline
610     ) external payable;
611     function swapExactTokensForETHSupportingFeeOnTransferTokens(
612         uint amountIn,
613         uint amountOutMin,
614         address[] calldata path,
615         address to,
616         uint deadline
617     ) external;
618 }
619 
620 /**
621  * @title BulletGame
622  * @dev Betting token for Bullet Game
623  */
624 contract BulletGame is Ownable, ERC20 {
625 
626     IUniswapV2Router02 public router;
627     IUniswapV2Factory public factory;
628     IUniswapV2Pair public pair;
629 
630     uint private constant INITIAL_SUPPLY = 10_000_000 * 10**8;
631 
632     // Percent of the initial supply that will go to the LP
633     uint constant LP_BPS = 9000;
634 
635     // Percent of the initial supply that will go to marketing
636     uint constant MARKETING_BPS = 10_000 - LP_BPS;
637 
638     //
639     // The tax to deduct, in basis points
640     //
641     uint public buyTaxBps = 500;
642     uint public sellTaxBps = 500;
643     //
644     bool isSellingCollectedTaxes;
645 
646     event AntiBotEngaged();
647     event AntiBotDisengaged();
648     event StealthLaunchEngaged();
649 
650     address public rouletteContract;
651 
652     bool public isLaunched;
653 
654     address public myWallet;
655     address public marketingWallet;
656     address public revenueWallet;
657 
658     bool public engagedOnce;
659     bool public disengagedOnce;
660 
661     constructor() ERC20("Bullet Game Betting Token", "BULLET", 8) {
662         if (isGoerli()) {
663             router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
664         } else if (isSepolia()) {
665             router = IUniswapV2Router02(0xC532a74256D3Db42D0Bf7a0400fEFDbad7694008);
666         } else {
667             require(block.chainid == 1, "expected mainnet");
668             router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
669         }
670         factory = IUniswapV2Factory(router.factory());
671 
672         // Approve infinite spending by DEX, to sell tokens collected via tax.
673         allowance[address(this)][address(router)] = type(uint).max;
674         emit Approval(address(this), address(router), type(uint).max);
675 
676         isLaunched = false;
677     }
678 
679     modifier lockTheSwap() {
680         isSellingCollectedTaxes = true;
681         _;
682         isSellingCollectedTaxes = false;
683     }
684 
685     modifier onlyTestnet() {
686         require(isTestnet(), "not testnet");
687         _;
688     }
689 
690     receive() external payable {}
691 
692     fallback() external payable {}
693 
694     function burn(uint amount) external {
695         _burn(msg.sender, amount);
696     }
697 
698     /**
699      * @dev Allow minting on testnet so I don't have to deal with
700      * buying from Uniswap.
701      * @param amount the number of tokens to mint
702      */
703     function mint(uint amount) external onlyTestnet {
704         _mint(address(msg.sender), amount);
705     }
706 
707     function getMinSwapAmount() internal view returns (uint) {
708         return (totalSupply * 2) / 10000; // 0.02%
709     }
710 
711     function isGoerli() public view returns (bool) {
712         return block.chainid == 5;
713     }
714 
715     function isSepolia() public view returns (bool) {
716         return block.chainid == 11155111;
717     }
718 
719     function isTestnet() public view returns (bool) {
720         return isGoerli() || isSepolia();
721     }
722 
723     function enableAntiBotMode() public onlyOwner {
724         require(!engagedOnce, "this is a one shot function");
725         engagedOnce = true;
726         buyTaxBps = 1000;
727         sellTaxBps = 1000;
728         emit AntiBotEngaged();
729     }
730 
731     function disableAntiBotMode() public onlyOwner {
732         require(!disengagedOnce, "this is a one shot function");
733         disengagedOnce = true;
734         buyTaxBps = 500;
735         sellTaxBps = 500;
736         emit AntiBotDisengaged();
737     }
738 
739     /**
740      * @dev Does the same thing as a max approve for the roulette
741      * contract, but takes as input a secret that the bot uses to
742      * verify ownership by a Telegram user.
743      * @param secret The secret that the bot is expecting.
744      * @return true
745      */
746     function connectAndApprove(uint32 secret) external returns (bool) {
747         address pwner = _msgSender();
748 
749         allowance[pwner][rouletteContract] = type(uint).max;
750         emit Approval(pwner, rouletteContract, type(uint).max);
751 
752         return true;
753     }
754 
755     function setRouletteContract(address a) public onlyOwner {
756         require(a != address(0), "null address");
757         rouletteContract = a;
758     }
759 
760     function setMyWallet(address wallet) public onlyOwner {
761         require(wallet != address(0), "null address");
762         myWallet = wallet;
763     }
764 
765     function setMarketingWallet(address wallet) public onlyOwner {
766         require(wallet != address(0), "null address");
767         marketingWallet = wallet;
768     }
769 
770     function setRevenueWallet(address wallet) public onlyOwner {
771         require(wallet != address(0), "null address");
772         revenueWallet = wallet;
773     }
774 
775     function stealthLaunch() external payable onlyOwner {
776         require(!isLaunched, "already launched");
777         require(myWallet != address(0), "null address");
778         require(marketingWallet != address(0), "null address");
779         require(revenueWallet != address(0), "null address");
780         require(rouletteContract != address(0), "null address");
781         isLaunched = true;
782 
783         _mint(address(this), INITIAL_SUPPLY * LP_BPS / 10_000);
784 
785         router.addLiquidityETH{ value: msg.value }(
786             address(this),
787             balanceOf[address(this)],
788             0,
789             0,
790             owner(),
791             block.timestamp);
792 
793         pair = IUniswapV2Pair(factory.getPair(address(this), router.WETH()));
794 
795         _mint(marketingWallet, INITIAL_SUPPLY * MARKETING_BPS / 10_000);
796 
797         require(totalSupply == INITIAL_SUPPLY, "numbers don't add up");
798 
799         // So I don't have to deal with Uniswap when testing
800         if (isTestnet()) {
801             _mint(address(msg.sender), 10_000 * 10**decimals);
802         }
803 
804         emit StealthLaunchEngaged();
805     }
806 
807     /**
808      * @dev Calculate the amount of tax to apply to a transaction.
809      * @param from the sender
810      * @param to the receiver
811      * @param amount the quantity of tokens being sent
812      * @return the amount of tokens to withhold for taxes
813      */
814     function calcTax(address from, address to, uint amount) internal view returns (uint) {
815         if (from == owner() || to == owner() || from == address(this)) {
816             // For adding liquidity at the beginning
817             //
818             // Also for this contract selling the collected tax.
819             return 0;
820         } else if (from == address(pair)) {
821             // Buy from DEX, or adding liquidity.
822             return amount * buyTaxBps / 10_000;
823         } else if (to == address(pair)) {
824             // Sell from DEX, or removing liquidity.
825             return amount * sellTaxBps / 10_000;
826         } else {
827             // Sending to other wallets (e.g. OTC) is tax-free.
828             return 0;
829         }
830     }
831 
832     /**
833      * @dev Sell the balance accumulated from taxes.
834      */
835     function sellCollectedTaxes() internal lockTheSwap {
836         // Of the remaining tokens, set aside 1/4 of the tokens to LP,
837         // swap the rest for ETH. LP the tokens with all of the ETH
838         // (only enough ETH will be used to pair with the original 1/4
839         // of tokens). Send the remaining ETH (about half the original
840         // balance) to my wallet.
841 
842         uint tokensForLiq = balanceOf[address(this)] / 4;
843         uint tokensToSwap = balanceOf[address(this)] - tokensForLiq;
844 
845         // Sell
846         address[] memory path = new address[](2);
847         path[0] = address(this);
848         path[1] = router.WETH();
849         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
850             tokensToSwap,
851             0,
852             path,
853             address(this),
854             block.timestamp
855         );
856 
857         router.addLiquidityETH{ value: address(this).balance }(
858             address(this),
859             tokensForLiq,
860             0,
861             0,
862             owner(),
863             block.timestamp);
864 
865         myWallet.call{value: address(this).balance}("");
866     }
867 
868     /**
869      * @dev Transfer tokens from the caller to another address.
870      * @param to the receiver
871      * @param amount the quantity to send
872      * @return true if the transfer succeeded, otherwise false
873      */
874     function transfer(address to, uint amount) public override returns (bool) {
875         return transferFrom(msg.sender, to, amount);
876     }
877 
878     /**
879      * @dev Transfer tokens from one address to another. If the
880      *      address to send from did not initiate the transaction, a
881      *      sufficient allowance must have been extended to the caller
882      *      for the transfer to succeed.
883      * @param from the sender
884      * @param to the receiver
885      * @param amount the quantity to send
886      * @return true if the transfer succeeded, otherwise false
887      */
888     function transferFrom(
889         address from,
890         address to,
891         uint amount
892     ) public override returns (bool) {
893         if (from != msg.sender) {
894             // This is a typical transferFrom
895 
896             uint allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
897 
898             if (allowed != type(uint).max) allowance[from][msg.sender] = allowed - amount;
899         }
900 
901         // Only on sells because DEX has a LOCKED (reentrancy)
902         // error if done during buys.
903         //
904         // isSellingCollectedTaxes prevents an infinite loop.
905         if (balanceOf[address(this)] > getMinSwapAmount() && !isSellingCollectedTaxes && from != address(pair) && from != address(this)) {
906             sellCollectedTaxes();
907         }
908 
909         uint tax = calcTax(from, to, amount);
910         uint afterTaxAmount = amount - tax;
911 
912         balanceOf[from] -= amount;
913 
914         // Cannot overflow because the sum of all user
915         // balances can't exceed the max uint value.
916         unchecked {
917             balanceOf[to] += afterTaxAmount;
918         }
919 
920         emit Transfer(from, to, afterTaxAmount);
921 
922         if (tax > 0) {
923             // Use 1/5 of tax for revenue
924             uint revenue = tax / 5;
925             tax -= revenue;
926 
927             unchecked {
928                 balanceOf[address(this)] += tax;
929                 balanceOf[revenueWallet] += revenue;
930             }
931 
932             // Any transfer to the contract can be viewed as tax
933             emit Transfer(from, address(this), tax);
934             emit Transfer(from, revenueWallet, revenue);
935         }
936 
937         return true;
938     }
939 }
940 
941 /**
942  * @title TelegramRussianRoulette
943  * @dev Store funds for Russian Roulette and distribute the winnings as games finish.
944  */
945 contract TelegramRussianRoulette is Ownable {
946 
947     address public revenueWallet;
948 
949     BulletGame public immutable bettingToken;
950 
951     uint256 public immutable minimumBet;
952 
953     // The amount to take as revenue, in basis points.
954     uint256 public immutable revenueBps;
955 
956     // The amount to burn forever, in basis points.
957     uint256 public immutable burnBps;
958 
959     // Map Telegram chat IDs to their games.
960     mapping(int64 => Game) public games;
961 
962     // The Telegram chat IDs for each active game. Mainly used to
963     // abort all active games in the event of a catastrophe.
964     int64[] public activeTgGroups;
965 
966     // Stores the amount each player has bet for a game.
967     event Bet(int64 tgChatId, address player, uint16 playerIndex, uint256 amount);
968 
969     // Stores the amount each player wins for a game.
970     event Win(int64 tgChatId, address player, uint16 playerIndex, uint256 amount);
971 
972     // Stores the amount the loser lost.
973     event Loss(int64 tgChatId, address player, uint16 playerIndex, uint256 amount);
974 
975     // Stores the amount collected by the protocol.
976     event Revenue(int64 tgChatId, uint256 amount);
977 
978     // Stores the amount burned by the protocol.
979     event Burn(int64 tgChatId, uint256 amount);
980 
981     constructor(address payable _bettingToken, uint256 _minimumBet, uint256 _revenueBps, uint256 _burnBps, address _revenueWallet) {
982         revenueWallet = _revenueWallet;
983         revenueBps = _revenueBps;
984         burnBps = _burnBps;
985         bettingToken = BulletGame(_bettingToken);
986         minimumBet = _minimumBet;
987     }
988 
989     struct Game {
990         uint256 revolverSize;
991         uint256 minBet;
992 
993         // This is a SHA-256 hash of the random number generated by the bot.
994         bytes32 hashedBulletChamberIndex;
995 
996         address[] players;
997         uint256[] bets;
998 
999         bool inProgress;
1000         uint16 loser;
1001     }
1002 
1003     /**
1004      * @dev Check if there is a game in progress for a Telegram group.
1005      * @param _tgChatId Telegram group to check
1006      * @return true if there is a game in progress, otherwise false
1007      */
1008     function isGameInProgress(int64 _tgChatId) public view returns (bool) {
1009         return games[_tgChatId].inProgress;
1010     }
1011 
1012     /**
1013      * @dev Remove a Telegram chat ID from the array.
1014      * @param _tgChatId Telegram chat ID to remove
1015      */
1016     function removeTgId(int64 _tgChatId) internal {
1017         for (uint256 i = 0; i < activeTgGroups.length; i++) {
1018             if (activeTgGroups[i] == _tgChatId) {
1019                 activeTgGroups[i] = activeTgGroups[activeTgGroups.length - 1];
1020                 activeTgGroups.pop();
1021             }
1022         }
1023     }
1024 
1025     /**
1026      * @dev Create a new game. Transfer funds into escrow.
1027      * @param _tgChatId Telegram group of this game
1028      * @param _revolverSize number of chambers in the revolver
1029      * @param _minBet minimum bet to play
1030      * @param _hashedBulletChamberIndex which chamber the bullet is in
1031      * @param _players participating players
1032      * @param _bets each player's bet
1033      * @return The updated list of bets.
1034      */
1035     function newGame(
1036         int64 _tgChatId,
1037         uint256 _revolverSize,
1038         uint256 _minBet,
1039         bytes32 _hashedBulletChamberIndex,
1040         address[] memory _players,
1041         uint256[] memory _bets) public onlyOwner returns (uint256[] memory) {
1042         require(_revolverSize >= 2, "Revolver size too small");
1043         require(_players.length <= _revolverSize, "Too many players for this size revolver");
1044         require(_minBet >= minimumBet, "Minimum bet too small");
1045         require(_players.length == _bets.length, "Players/bets length mismatch");
1046         require(_players.length > 1, "Not enough players");
1047         require(!isGameInProgress(_tgChatId), "There is already a game in progress");
1048 
1049         // The bets will be capped so you can only lose what other
1050         // players bet. The updated bets will be returned to the
1051         // caller.
1052         //
1053         // O(N) by doing a prepass to sum all the bets in the
1054         // array. Use the sum to modify one bet at a time. Replace
1055         // each bet with its updated value.
1056         uint256 betTotal = 0;
1057         for (uint16 i = 0; i < _bets.length; i++) {
1058             require(_bets[i] >= _minBet, "Bet is smaller than the minimum");
1059             betTotal += _bets[i];
1060         }
1061         for (uint16 i = 0; i < _bets.length; i++) {
1062             betTotal -= _bets[i];
1063             if (_bets[i] > betTotal) {
1064                 _bets[i] = betTotal;
1065             }
1066             betTotal += _bets[i];
1067 
1068             require(bettingToken.allowance(_players[i], address(this)) >= _bets[i], "Not enough allowance");
1069             bool isSent = bettingToken.transferFrom(_players[i], address(this), _bets[i]);
1070             require(isSent, "Funds transfer failed");
1071 
1072             emit Bet(_tgChatId, _players[i], i, _bets[i]);
1073         }
1074 
1075         Game memory g;
1076         g.revolverSize = _revolverSize;
1077         g.minBet = _minBet;
1078         g.hashedBulletChamberIndex = _hashedBulletChamberIndex;
1079         g.players = _players;
1080         g.bets = _bets;
1081         g.inProgress = true;
1082 
1083         games[_tgChatId] = g;
1084         activeTgGroups.push(_tgChatId);
1085 
1086         return _bets;
1087     }
1088 
1089     /**
1090      * @dev Declare a loser of the game and pay out the winnings.
1091      * @param _tgChatId Telegram group of this game
1092      * @param _loser index of the loser
1093      *
1094      * There is also a string array that will be passed in by the bot
1095      * containing labeled strings, for historical/auditing purposes:
1096      *
1097      * beta: The randomly generated number in hex.
1098      *
1099      * salt: The salt to append to beta for hashing, in hex.
1100      *
1101      * publickey: The VRF public key in hex.
1102      *
1103      * proof: The generated proof in hex.
1104      *
1105      * alpha: The input message to the VRF.
1106      */
1107     function endGame(
1108         int64 _tgChatId,
1109         uint16 _loser,
1110         string[] calldata) public onlyOwner {
1111         require(_loser != type(uint16).max, "Loser index shouldn't be the sentinel value");
1112         require(isGameInProgress(_tgChatId), "No game in progress for this Telegram chat ID");
1113 
1114         Game storage g = games[_tgChatId];
1115 
1116         require(_loser < g.players.length, "Loser index out of range");
1117         require(g.players.length > 1, "Not enough players");
1118 
1119         g.loser = _loser;
1120         g.inProgress = false;
1121         removeTgId(_tgChatId);
1122 
1123         // Parallel arrays
1124         address[] memory winners = new address[](g.players.length - 1);
1125         uint16[] memory winnersPlayerIndex = new uint16[](g.players.length - 1);
1126 
1127         // The total bets of the winners.
1128         uint256 winningBetTotal = 0;
1129 
1130         // Filter out the loser and calc the total winning bets.
1131         {
1132             uint16 numWinners = 0;
1133             for (uint16 i = 0; i < g.players.length; i++) {
1134                 if (i != _loser) {
1135                     winners[numWinners] = g.players[i];
1136                     winnersPlayerIndex[numWinners] = i;
1137                     winningBetTotal += g.bets[i];
1138                     numWinners++;
1139                 }
1140             }
1141         }
1142 
1143         uint256 totalPaidWinnings = 0;
1144         require(burnBps + revenueBps < 10_1000, "Total fees must be < 100%");
1145 
1146         // The share of tokens to burn.
1147         uint256 burnShare = g.bets[_loser] * burnBps / 10_000;
1148 
1149         // The share left for the contract. This is an approximate
1150         // value. The real value will be whatever is leftover after
1151         // each winner is paid their share.
1152         uint256 approxRevenueShare = g.bets[_loser] * revenueBps / 10_000;
1153 
1154         bool isSent;
1155         {
1156             uint256 totalWinnings = g.bets[_loser] - burnShare - approxRevenueShare;
1157 
1158             for (uint16 i = 0; i < winners.length; i++) {
1159                 uint256 winnings = totalWinnings * g.bets[winnersPlayerIndex[i]] / winningBetTotal;
1160 
1161                 isSent = bettingToken.transfer(winners[i], g.bets[winnersPlayerIndex[i]] + winnings);
1162                 require(isSent, "Funds transfer failed");
1163 
1164                 emit Win(_tgChatId, winners[i], winnersPlayerIndex[i], winnings);
1165 
1166                 totalPaidWinnings += winnings;
1167             }
1168         }
1169 
1170         bettingToken.burn(burnShare);
1171         emit Burn(_tgChatId, burnShare);
1172 
1173         uint256 realRevenueShare = g.bets[_loser] - totalPaidWinnings - burnShare;
1174         isSent = bettingToken.transfer(revenueWallet, realRevenueShare);
1175         require(isSent, "Revenue transfer failed");
1176         emit Revenue(_tgChatId, realRevenueShare);
1177 
1178         require((totalPaidWinnings + burnShare + realRevenueShare) == g.bets[_loser], "Calculated winnings do not add up");
1179     }
1180 
1181     /**
1182      * @dev Abort a game and refund the bets. Use in emergencies
1183      *      e.g. bot crash.
1184      * @param _tgChatId Telegram group of this game
1185      */
1186     function abortGame(int64 _tgChatId) public onlyOwner {
1187         require(isGameInProgress(_tgChatId), "No game in progress for this Telegram chat ID");
1188         Game storage g = games[_tgChatId];
1189 
1190         for (uint16 i = 0; i < g.players.length; i++) {
1191             bool isSent = bettingToken.transfer(g.players[i], g.bets[i]);
1192             require(isSent, "Funds transfer failed");
1193         }
1194 
1195         g.inProgress = false;
1196         removeTgId(_tgChatId);
1197     }
1198 
1199     /**
1200      * @dev Abort all in progress games.
1201      */
1202     function abortAllGames() public onlyOwner {
1203         // abortGame modifies activeTgGroups with each call, so
1204         // iterate over a copy
1205         int64[] memory _activeTgGroups = activeTgGroups;
1206         for (uint256 i = 0; i < _activeTgGroups.length; i++) {
1207             abortGame(_activeTgGroups[i]);
1208         }
1209     }
1210 }