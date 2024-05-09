1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-27
3 */
4 
5 pragma solidity 0.8.19;
6 
7 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
8 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
9 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
10 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
11 abstract contract ERC20 {
12     /*//////////////////////////////////////////////////////////////
13                                  EVENTS
14     //////////////////////////////////////////////////////////////*/
15 
16     event Transfer(address indexed from, address indexed to, uint256 amount);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 amount);
19 
20     /*//////////////////////////////////////////////////////////////
21                             METADATA STORAGE
22     //////////////////////////////////////////////////////////////*/
23 
24     string public name;
25 
26     string public symbol;
27 
28     uint8 public immutable decimals;
29 
30     /*//////////////////////////////////////////////////////////////
31                               ERC20 STORAGE
32     //////////////////////////////////////////////////////////////*/
33 
34     uint256 public totalSupply;
35 
36     mapping(address => uint256) public balanceOf;
37 
38     mapping(address => mapping(address => uint256)) public allowance;
39 
40     /*//////////////////////////////////////////////////////////////
41                             EIP-2612 STORAGE
42     //////////////////////////////////////////////////////////////*/
43 
44     uint256 internal immutable INITIAL_CHAIN_ID;
45 
46     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
47 
48     mapping(address => uint256) public nonces;
49 
50     /*//////////////////////////////////////////////////////////////
51                                CONSTRUCTOR
52     //////////////////////////////////////////////////////////////*/
53 
54     constructor(
55         string memory _name,
56         string memory _symbol,
57         uint8 _decimals
58     ) {
59         name = _name;
60         symbol = _symbol;
61         decimals = _decimals;
62 
63         INITIAL_CHAIN_ID = block.chainid;
64         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
65     }
66 
67     /*//////////////////////////////////////////////////////////////
68                                ERC20 LOGIC
69     //////////////////////////////////////////////////////////////*/
70 
71     function approve(address spender, uint256 amount) public virtual returns (bool) {
72         allowance[msg.sender][spender] = amount;
73 
74         emit Approval(msg.sender, spender, amount);
75 
76         return true;
77     }
78 
79     function transfer(address to, uint256 amount) public virtual returns (bool) {
80         balanceOf[msg.sender] -= amount;
81 
82         // Cannot overflow because the sum of all user
83         // balances can't exceed the max uint256 value.
84         unchecked {
85             balanceOf[to] += amount;
86         }
87 
88         emit Transfer(msg.sender, to, amount);
89 
90         return true;
91     }
92 
93     function transferFrom(
94         address from,
95         address to,
96         uint256 amount
97     ) public virtual returns (bool) {
98         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
99 
100         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
101 
102         balanceOf[from] -= amount;
103 
104         // Cannot overflow because the sum of all user
105         // balances can't exceed the max uint256 value.
106         unchecked {
107             balanceOf[to] += amount;
108         }
109 
110         emit Transfer(from, to, amount);
111 
112         return true;
113     }
114 
115     /*//////////////////////////////////////////////////////////////
116                              EIP-2612 LOGIC
117     //////////////////////////////////////////////////////////////*/
118 
119     function permit(
120         address owner,
121         address spender,
122         uint256 value,
123         uint256 deadline,
124         uint8 v,
125         bytes32 r,
126         bytes32 s
127     ) public virtual {
128         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
129 
130         // Unchecked because the only math done is incrementing
131         // the owner's nonce which cannot realistically overflow.
132         unchecked {
133             address recoveredAddress = ecrecover(
134                 keccak256(
135                     abi.encodePacked(
136                         "\x19\x01",
137                         DOMAIN_SEPARATOR(),
138                         keccak256(
139                             abi.encode(
140                                 keccak256(
141                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
142                                 ),
143                                 owner,
144                                 spender,
145                                 value,
146                                 nonces[owner]++,
147                                 deadline
148                             )
149                         )
150                     )
151                 ),
152                 v,
153                 r,
154                 s
155             );
156 
157             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
158 
159             allowance[recoveredAddress][spender] = value;
160         }
161 
162         emit Approval(owner, spender, value);
163     }
164 
165     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
166         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
167     }
168 
169     function computeDomainSeparator() internal view virtual returns (bytes32) {
170         return
171             keccak256(
172                 abi.encode(
173                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
174                     keccak256(bytes(name)),
175                     keccak256("1"),
176                     block.chainid,
177                     address(this)
178                 )
179             );
180     }
181 
182     /*//////////////////////////////////////////////////////////////
183                         INTERNAL MINT/BURN LOGIC
184     //////////////////////////////////////////////////////////////*/
185 
186     function _mint(address to, uint256 amount) internal virtual {
187         totalSupply += amount;
188 
189         // Cannot overflow because the sum of all user
190         // balances can't exceed the max uint256 value.
191         unchecked {
192             balanceOf[to] += amount;
193         }
194 
195         emit Transfer(address(0), to, amount);
196     }
197 
198     function _burn(address from, uint256 amount) internal virtual {
199         balanceOf[from] -= amount;
200 
201         // Cannot underflow because a user's balance
202         // will never be larger than the total supply.
203         unchecked {
204             totalSupply -= amount;
205         }
206 
207         emit Transfer(from, address(0), amount);
208     }
209 }
210 
211 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
212 
213 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
214 
215 /**
216  * @dev Provides information about the current execution context, including the
217  * sender of the transaction and its data. While these are generally available
218  * via msg.sender and msg.data, they should not be accessed in such a direct
219  * manner, since when dealing with meta-transactions the account sending and
220  * paying for execution may not be the actual sender (as far as an application
221  * is concerned).
222  *
223  * This contract is only required for intermediate, library-like contracts.
224  */
225 abstract contract Context {
226     function _msgSender() internal view virtual returns (address) {
227         return msg.sender;
228     }
229 
230     function _msgData() internal view virtual returns (bytes calldata) {
231         return msg.data;
232     }
233 }
234 
235 /**
236  * @dev Contract module which provides a basic access control mechanism, where
237  * there is an account (an owner) that can be granted exclusive access to
238  * specific functions.
239  *
240  * By default, the owner account will be the one that deploys the contract. This
241  * can later be changed with {transferOwnership}.
242  *
243  * This module is used through inheritance. It will make available the modifier
244  * `onlyOwner`, which can be applied to your functions to restrict their use to
245  * the owner.
246  */
247 abstract contract Ownable is Context {
248     address private _owner;
249 
250     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
251 
252     /**
253      * @dev Initializes the contract setting the deployer as the initial owner.
254      */
255     constructor() {
256         _transferOwnership(_msgSender());
257     }
258 
259     /**
260      * @dev Throws if called by any account other than the owner.
261      */
262     modifier onlyOwner() {
263         _checkOwner();
264         _;
265     }
266 
267     /**
268      * @dev Returns the address of the current owner.
269      */
270     function owner() public view virtual returns (address) {
271         return _owner;
272     }
273 
274     /**
275      * @dev Throws if the sender is not the owner.
276      */
277     function _checkOwner() internal view virtual {
278         require(owner() == _msgSender(), "Ownable: caller is not the owner");
279     }
280 
281     /**
282      * @dev Leaves the contract without owner. It will not be possible to call
283      * `onlyOwner` functions anymore. Can only be called by the current owner.
284      *
285      * NOTE: Renouncing ownership will leave the contract without an owner,
286      * thereby removing any functionality that is only available to the owner.
287      */
288     function renounceOwnership() public virtual onlyOwner {
289         _transferOwnership(address(0));
290     }
291 
292     /**
293      * @dev Transfers ownership of the contract to a new account (`newOwner`).
294      * Can only be called by the current owner.
295      */
296     function transferOwnership(address newOwner) public virtual onlyOwner {
297         require(newOwner != address(0), "Ownable: new owner is the zero address");
298         _transferOwnership(newOwner);
299     }
300 
301     /**
302      * @dev Transfers ownership of the contract to a new account (`newOwner`).
303      * Internal function without access restriction.
304      */
305     function _transferOwnership(address newOwner) internal virtual {
306         address oldOwner = _owner;
307         _owner = newOwner;
308         emit OwnershipTransferred(oldOwner, newOwner);
309     }
310 }
311 
312 interface IUniswapV2Factory {
313     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
314 
315     function feeTo() external view returns (address);
316     function feeToSetter() external view returns (address);
317 
318     function getPair(address tokenA, address tokenB) external view returns (address pair);
319     function allPairs(uint) external view returns (address pair);
320     function allPairsLength() external view returns (uint);
321 
322     function createPair(address tokenA, address tokenB) external returns (address pair);
323 
324     function setFeeTo(address) external;
325     function setFeeToSetter(address) external;
326 }
327 
328 interface IUniswapV2Pair {
329     event Approval(address indexed owner, address indexed spender, uint value);
330     event Transfer(address indexed from, address indexed to, uint value);
331 
332     function name() external pure returns (string memory);
333     function symbol() external pure returns (string memory);
334     function decimals() external pure returns (uint8);
335     function totalSupply() external view returns (uint);
336     function balanceOf(address owner) external view returns (uint);
337     function allowance(address owner, address spender) external view returns (uint);
338 
339     function approve(address spender, uint value) external returns (bool);
340     function transfer(address to, uint value) external returns (bool);
341     function transferFrom(address from, address to, uint value) external returns (bool);
342 
343     function DOMAIN_SEPARATOR() external view returns (bytes32);
344     function PERMIT_TYPEHASH() external pure returns (bytes32);
345     function nonces(address owner) external view returns (uint);
346 
347     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
348 
349     event Mint(address indexed sender, uint amount0, uint amount1);
350     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
351     event Swap(
352         address indexed sender,
353         uint amount0In,
354         uint amount1In,
355         uint amount0Out,
356         uint amount1Out,
357         address indexed to
358     );
359     event Sync(uint112 reserve0, uint112 reserve1);
360 
361     function MINIMUM_LIQUIDITY() external pure returns (uint);
362     function factory() external view returns (address);
363     function token0() external view returns (address);
364     function token1() external view returns (address);
365     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
366     function price0CumulativeLast() external view returns (uint);
367     function price1CumulativeLast() external view returns (uint);
368     function kLast() external view returns (uint);
369 
370     function mint(address to) external returns (uint liquidity);
371     function burn(address to) external returns (uint amount0, uint amount1);
372     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
373     function skim(address to) external;
374     function sync() external;
375 
376     function initialize(address, address) external;
377 }
378 
379 interface IUniswapV2Router01 {
380     function factory() external pure returns (address);
381     function WETH() external pure returns (address);
382 
383     function addLiquidity(
384         address tokenA,
385         address tokenB,
386         uint amountADesired,
387         uint amountBDesired,
388         uint amountAMin,
389         uint amountBMin,
390         address to,
391         uint deadline
392     ) external returns (uint amountA, uint amountB, uint liquidity);
393     function addLiquidityETH(
394         address token,
395         uint amountTokenDesired,
396         uint amountTokenMin,
397         uint amountETHMin,
398         address to,
399         uint deadline
400     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
401     function removeLiquidity(
402         address tokenA,
403         address tokenB,
404         uint liquidity,
405         uint amountAMin,
406         uint amountBMin,
407         address to,
408         uint deadline
409     ) external returns (uint amountA, uint amountB);
410     function removeLiquidityETH(
411         address token,
412         uint liquidity,
413         uint amountTokenMin,
414         uint amountETHMin,
415         address to,
416         uint deadline
417     ) external returns (uint amountToken, uint amountETH);
418     function removeLiquidityWithPermit(
419         address tokenA,
420         address tokenB,
421         uint liquidity,
422         uint amountAMin,
423         uint amountBMin,
424         address to,
425         uint deadline,
426         bool approveMax, uint8 v, bytes32 r, bytes32 s
427     ) external returns (uint amountA, uint amountB);
428     function removeLiquidityETHWithPermit(
429         address token,
430         uint liquidity,
431         uint amountTokenMin,
432         uint amountETHMin,
433         address to,
434         uint deadline,
435         bool approveMax, uint8 v, bytes32 r, bytes32 s
436     ) external returns (uint amountToken, uint amountETH);
437     function swapExactTokensForTokens(
438         uint amountIn,
439         uint amountOutMin,
440         address[] calldata path,
441         address to,
442         uint deadline
443     ) external returns (uint[] memory amounts);
444     function swapTokensForExactTokens(
445         uint amountOut,
446         uint amountInMax,
447         address[] calldata path,
448         address to,
449         uint deadline
450     ) external returns (uint[] memory amounts);
451     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
452         external
453         payable
454         returns (uint[] memory amounts);
455     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
456         external
457         returns (uint[] memory amounts);
458     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
459         external
460         returns (uint[] memory amounts);
461     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
462         external
463         payable
464         returns (uint[] memory amounts);
465 
466     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
467     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
468     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
469     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
470     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
471 }
472 
473 interface IUniswapV2Router02 is IUniswapV2Router01 {
474     function removeLiquidityETHSupportingFeeOnTransferTokens(
475         address token,
476         uint liquidity,
477         uint amountTokenMin,
478         uint amountETHMin,
479         address to,
480         uint deadline
481     ) external returns (uint amountETH);
482     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
483         address token,
484         uint liquidity,
485         uint amountTokenMin,
486         uint amountETHMin,
487         address to,
488         uint deadline,
489         bool approveMax, uint8 v, bytes32 r, bytes32 s
490     ) external returns (uint amountETH);
491 
492     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
493         uint amountIn,
494         uint amountOutMin,
495         address[] calldata path,
496         address to,
497         uint deadline
498     ) external;
499     function swapExactETHForTokensSupportingFeeOnTransferTokens(
500         uint amountOutMin,
501         address[] calldata path,
502         address to,
503         uint deadline
504     ) external payable;
505     function swapExactTokensForETHSupportingFeeOnTransferTokens(
506         uint amountIn,
507         uint amountOutMin,
508         address[] calldata path,
509         address to,
510         uint deadline
511     ) external;
512 }
513 
514 /**
515  * @title Milkfriendtech
516  * @dev Token for Milkfriendtech
517  */
518 contract Milkfriendtech is Ownable, ERC20 {
519 
520     IUniswapV2Router02 public router;
521     IUniswapV2Factory public factory;
522     IUniswapV2Pair public pair;
523 
524     uint private constant INITIAL_SUPPLY = 100_000_000 * 10**18;
525 
526     //
527     // The tax to deduct, in basis points
528     //
529     uint public buyTaxBps = 500;
530     uint public sellTaxBps = 500;
531     uint public maxbuy = 0; 
532     //
533     bool isSellingCollectedTaxes;
534 
535     event AntiBotEngaged();
536     event AntiBotDisengaged();
537 
538     address public revenueWallet;
539 
540     bool public engagedOnce;
541     bool public disengagedOnce;
542 
543     constructor() ERC20("Milkfriendtech", "MILKER", 18) {
544 
545         router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
546         factory = IUniswapV2Factory(router.factory());
547         _mint(msg.sender, INITIAL_SUPPLY);
548 
549         // Approve infinite spending by DEX, to sell tokens collected via tax.
550         allowance[address(this)][address(router)] = type(uint).max;
551         emit Approval(address(this), address(router), type(uint).max);
552         pair = IUniswapV2Pair(factory.createPair(address(this), router.WETH()));
553     }
554 
555     modifier lockTheSwap() {
556         isSellingCollectedTaxes = true;
557         _;
558         isSellingCollectedTaxes = false;
559     }
560 
561     receive() external payable {}
562 
563     fallback() external payable {}
564 
565     function burn(uint amount) external {
566         _burn(msg.sender, amount);
567     }
568 
569     function getMinSwapAmount() internal view returns (uint) {
570         return (totalSupply * 2) / 10000; // 0.02%
571     }
572 
573 
574     function enableAntiSnipe() public onlyOwner {
575         require(!engagedOnce, "this is a one shot function");
576         engagedOnce = true;
577         buyTaxBps = 2500;
578         sellTaxBps = 2500;
579         emit AntiBotEngaged();
580     }
581 
582     function disableAntiSnipe() public onlyOwner {
583         require(!disengagedOnce, "this is a one shot function");
584         disengagedOnce = true;
585         buyTaxBps = 500;
586         sellTaxBps = 500;
587         emit AntiBotDisengaged();
588     }
589 
590     function setRevenueWallet(address wallet) public onlyOwner {
591         require(wallet != address(0), "null address");
592         revenueWallet = wallet;
593     }
594 
595     function setMaxBuy(uint _maxbuy) public onlyOwner {
596         require(_maxbuy > 0, "Max buy is zero");
597         maxbuy = _maxbuy;
598     }
599 
600 
601     /**
602      * @dev Calculate the amount of tax to apply to a transaction.
603      * @param from the sender
604      * @param to the receiver
605      * @param amount the quantity of tokens being sent
606      * @return the amount of tokens to withhold for taxes
607      */
608     function calcTax(address from, address to, uint amount) internal view returns (uint) {
609         if (from == owner() || to == owner() || from == address(this)) {
610             // For adding liquidity at the beginning
611             //
612             // Also for this contract selling the collected tax.
613             return 0;
614         } else if (from == address(pair)) {
615             // Buy from DEX, or adding liquidity.
616             return amount * buyTaxBps / 10_000;
617         } else if (to == address(pair)) {
618             // Sell from DEX, or removing liquidity.
619             return amount * sellTaxBps / 10_000;
620         } else {
621             // Sending to other wallets (e.g. OTC) is tax-free.
622             return 0;
623         }
624     }
625 
626     /**
627      * @dev Sell the balance accumulated from taxes.
628      */
629     function sellCollectedTaxes() internal lockTheSwap {
630 
631         uint tokensToSwap = balanceOf[address(this)];
632 
633         // Sell
634         address[] memory path = new address[](2);
635         path[0] = address(this);
636         path[1] = router.WETH();
637 
638         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
639             tokensToSwap,
640             0,
641             path,
642             address(this),
643             block.timestamp
644         );
645 
646         revenueWallet.call{value: (address(this).balance)}("");
647 
648     }
649 
650     /**
651      * @dev Transfer tokens from the caller to another address.
652      * @param to the receiver
653      * @param amount the quantity to send
654      * @return true if the transfer succeeded, otherwise false
655      */
656     function transfer(address to, uint amount) public override returns (bool) {
657         return transferFrom(msg.sender, to, amount);
658     }
659 
660     /**
661      * @dev Transfer tokens from one address to another. If the
662      *      address to send from did not initiate the transaction, a
663      *      sufficient allowance must have been extended to the caller
664      *      for the transfer to succeed.
665      * @param from the sender
666      * @param to the receiver
667      * @param amount the quantity to send
668      * @return true if the transfer succeeded, otherwise false
669      */
670     function transferFrom(
671         address from,
672         address to,
673         uint amount
674     ) public override returns (bool) {
675         if (from != msg.sender) {
676             // This is a typical transferFrom
677 
678             uint allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
679 
680             if (allowed != type(uint).max) allowance[from][msg.sender] = allowed - amount;
681         }
682 
683 
684 
685         if(to != owner() && from != owner() && to != address(router) && to != address(pair)){
686             uint256 maxHolding = (totalSupply * maxbuy) / 10000; // 1.5% in basis points
687             require(balanceOf[to] + amount <= maxHolding, "Recipient holding exceeds maximum allowed");
688         }
689 
690         // Only on sells because DEX has a LOCKED (reentrancy)
691         // error if done during buys.
692         //
693         // isSellingCollectedTaxes prevents an infinite loop.
694         if (balanceOf[address(this)] > getMinSwapAmount() && !isSellingCollectedTaxes && from != address(pair) && from != address(this)) {
695             sellCollectedTaxes();
696         }
697 
698         uint tax = calcTax(from, to, amount);
699         uint afterTaxAmount = amount - tax;
700 
701         balanceOf[from] -= amount;
702 
703         // Cannot overflow because the sum of all user
704         // balances can't exceed the max uint value.
705         unchecked {
706             balanceOf[to] += afterTaxAmount;
707         }
708 
709         emit Transfer(from, to, afterTaxAmount);
710 
711         if (tax > 0) {
712             
713             unchecked {
714                 balanceOf[address(this)] += tax;
715             }
716 
717             // Any transfer to the contract can be viewed as tax
718             emit Transfer(from, address(this), tax);
719         }
720 
721         return true;
722     }
723 }