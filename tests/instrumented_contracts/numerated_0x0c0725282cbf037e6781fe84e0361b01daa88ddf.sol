1 pragma solidity 0.8.19;
2 
3 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
4 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
5 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
6 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
7 abstract contract ERC20 {
8     /*//////////////////////////////////////////////////////////////
9                                  EVENTS
10     //////////////////////////////////////////////////////////////*/
11 
12     event Transfer(address indexed from, address indexed to, uint256 amount);
13 
14     event Approval(address indexed owner, address indexed spender, uint256 amount);
15 
16     /*//////////////////////////////////////////////////////////////
17                             METADATA STORAGE
18     //////////////////////////////////////////////////////////////*/
19 
20     string public name;
21 
22     string public symbol;
23 
24     uint8 public immutable decimals;
25 
26     /*//////////////////////////////////////////////////////////////
27                               ERC20 STORAGE
28     //////////////////////////////////////////////////////////////*/
29 
30     uint256 public totalSupply;
31 
32     mapping(address => uint256) public balanceOf;
33 
34     mapping(address => mapping(address => uint256)) public allowance;
35 
36     /*//////////////////////////////////////////////////////////////
37                             EIP-2612 STORAGE
38     //////////////////////////////////////////////////////////////*/
39 
40     uint256 internal immutable INITIAL_CHAIN_ID;
41 
42     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
43 
44     mapping(address => uint256) public nonces;
45 
46     /*//////////////////////////////////////////////////////////////
47                                CONSTRUCTOR
48     //////////////////////////////////////////////////////////////*/
49 
50     constructor(
51         string memory _name,
52         string memory _symbol,
53         uint8 _decimals
54     ) {
55         name = _name;
56         symbol = _symbol;
57         decimals = _decimals;
58 
59         INITIAL_CHAIN_ID = block.chainid;
60         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
61     }
62 
63     /*//////////////////////////////////////////////////////////////
64                                ERC20 LOGIC
65     //////////////////////////////////////////////////////////////*/
66 
67     function approve(address spender, uint256 amount) public virtual returns (bool) {
68         allowance[msg.sender][spender] = amount;
69 
70         emit Approval(msg.sender, spender, amount);
71 
72         return true;
73     }
74 
75     function transfer(address to, uint256 amount) public virtual returns (bool) {
76         balanceOf[msg.sender] -= amount;
77 
78         // Cannot overflow because the sum of all user
79         // balances can't exceed the max uint256 value.
80         unchecked {
81             balanceOf[to] += amount;
82         }
83 
84         emit Transfer(msg.sender, to, amount);
85 
86         return true;
87     }
88 
89     function transferFrom(
90         address from,
91         address to,
92         uint256 amount
93     ) public virtual returns (bool) {
94         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
95 
96         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
97 
98         balanceOf[from] -= amount;
99 
100         // Cannot overflow because the sum of all user
101         // balances can't exceed the max uint256 value.
102         unchecked {
103             balanceOf[to] += amount;
104         }
105 
106         emit Transfer(from, to, amount);
107 
108         return true;
109     }
110 
111     /*//////////////////////////////////////////////////////////////
112                              EIP-2612 LOGIC
113     //////////////////////////////////////////////////////////////*/
114 
115     function permit(
116         address owner,
117         address spender,
118         uint256 value,
119         uint256 deadline,
120         uint8 v,
121         bytes32 r,
122         bytes32 s
123     ) public virtual {
124         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
125 
126         // Unchecked because the only math done is incrementing
127         // the owner's nonce which cannot realistically overflow.
128         unchecked {
129             address recoveredAddress = ecrecover(
130                 keccak256(
131                     abi.encodePacked(
132                         "\x19\x01",
133                         DOMAIN_SEPARATOR(),
134                         keccak256(
135                             abi.encode(
136                                 keccak256(
137                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
138                                 ),
139                                 owner,
140                                 spender,
141                                 value,
142                                 nonces[owner]++,
143                                 deadline
144                             )
145                         )
146                     )
147                 ),
148                 v,
149                 r,
150                 s
151             );
152 
153             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
154 
155             allowance[recoveredAddress][spender] = value;
156         }
157 
158         emit Approval(owner, spender, value);
159     }
160 
161     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
162         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
163     }
164 
165     function computeDomainSeparator() internal view virtual returns (bytes32) {
166         return
167             keccak256(
168                 abi.encode(
169                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
170                     keccak256(bytes(name)),
171                     keccak256("1"),
172                     block.chainid,
173                     address(this)
174                 )
175             );
176     }
177 
178     /*//////////////////////////////////////////////////////////////
179                         INTERNAL MINT/BURN LOGIC
180     //////////////////////////////////////////////////////////////*/
181 
182     function _mint(address to, uint256 amount) internal virtual {
183         totalSupply += amount;
184 
185         // Cannot overflow because the sum of all user
186         // balances can't exceed the max uint256 value.
187         unchecked {
188             balanceOf[to] += amount;
189         }
190 
191         emit Transfer(address(0), to, amount);
192     }
193 
194     function _burn(address from, uint256 amount) internal virtual {
195         balanceOf[from] -= amount;
196 
197         // Cannot underflow because a user's balance
198         // will never be larger than the total supply.
199         unchecked {
200             totalSupply -= amount;
201         }
202 
203         emit Transfer(from, address(0), amount);
204     }
205 }
206 
207 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
208 
209 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
210 
211 /**
212  * @dev Provides information about the current execution context, including the
213  * sender of the transaction and its data. While these are generally available
214  * via msg.sender and msg.data, they should not be accessed in such a direct
215  * manner, since when dealing with meta-transactions the account sending and
216  * paying for execution may not be the actual sender (as far as an application
217  * is concerned).
218  *
219  * This contract is only required for intermediate, library-like contracts.
220  */
221 abstract contract Context {
222     function _msgSender() internal view virtual returns (address) {
223         return msg.sender;
224     }
225 
226     function _msgData() internal view virtual returns (bytes calldata) {
227         return msg.data;
228     }
229 }
230 
231 /**
232  * @dev Contract module which provides a basic access control mechanism, where
233  * there is an account (an owner) that can be granted exclusive access to
234  * specific functions.
235  *
236  * By default, the owner account will be the one that deploys the contract. This
237  * can later be changed with {transferOwnership}.
238  *
239  * This module is used through inheritance. It will make available the modifier
240  * `onlyOwner`, which can be applied to your functions to restrict their use to
241  * the owner.
242  */
243 abstract contract Ownable is Context {
244     address private _owner;
245 
246     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
247 
248     /**
249      * @dev Initializes the contract setting the deployer as the initial owner.
250      */
251     constructor() {
252         _transferOwnership(_msgSender());
253     }
254 
255     /**
256      * @dev Throws if called by any account other than the owner.
257      */
258     modifier onlyOwner() {
259         _checkOwner();
260         _;
261     }
262 
263     /**
264      * @dev Returns the address of the current owner.
265      */
266     function owner() public view virtual returns (address) {
267         return _owner;
268     }
269 
270     /**
271      * @dev Throws if the sender is not the owner.
272      */
273     function _checkOwner() internal view virtual {
274         require(owner() == _msgSender(), "Ownable: caller is not the owner");
275     }
276 
277     /**
278      * @dev Leaves the contract without owner. It will not be possible to call
279      * `onlyOwner` functions anymore. Can only be called by the current owner.
280      *
281      * NOTE: Renouncing ownership will leave the contract without an owner,
282      * thereby removing any functionality that is only available to the owner.
283      */
284     function renounceOwnership() public virtual onlyOwner {
285         _transferOwnership(address(0));
286     }
287 
288     /**
289      * @dev Transfers ownership of the contract to a new account (`newOwner`).
290      * Can only be called by the current owner.
291      */
292     function transferOwnership(address newOwner) public virtual onlyOwner {
293         require(newOwner != address(0), "Ownable: new owner is the zero address");
294         _transferOwnership(newOwner);
295     }
296 
297     /**
298      * @dev Transfers ownership of the contract to a new account (`newOwner`).
299      * Internal function without access restriction.
300      */
301     function _transferOwnership(address newOwner) internal virtual {
302         address oldOwner = _owner;
303         _owner = newOwner;
304         emit OwnershipTransferred(oldOwner, newOwner);
305     }
306 }
307 
308 interface IUniswapV2Factory {
309     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
310 
311     function feeTo() external view returns (address);
312     function feeToSetter() external view returns (address);
313 
314     function getPair(address tokenA, address tokenB) external view returns (address pair);
315     function allPairs(uint) external view returns (address pair);
316     function allPairsLength() external view returns (uint);
317 
318     function createPair(address tokenA, address tokenB) external returns (address pair);
319 
320     function setFeeTo(address) external;
321     function setFeeToSetter(address) external;
322 }
323 
324 interface IUniswapV2Pair {
325     event Approval(address indexed owner, address indexed spender, uint value);
326     event Transfer(address indexed from, address indexed to, uint value);
327 
328     function name() external pure returns (string memory);
329     function symbol() external pure returns (string memory);
330     function decimals() external pure returns (uint8);
331     function totalSupply() external view returns (uint);
332     function balanceOf(address owner) external view returns (uint);
333     function allowance(address owner, address spender) external view returns (uint);
334 
335     function approve(address spender, uint value) external returns (bool);
336     function transfer(address to, uint value) external returns (bool);
337     function transferFrom(address from, address to, uint value) external returns (bool);
338 
339     function DOMAIN_SEPARATOR() external view returns (bytes32);
340     function PERMIT_TYPEHASH() external pure returns (bytes32);
341     function nonces(address owner) external view returns (uint);
342 
343     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
344 
345     event Mint(address indexed sender, uint amount0, uint amount1);
346     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
347     event Swap(
348         address indexed sender,
349         uint amount0In,
350         uint amount1In,
351         uint amount0Out,
352         uint amount1Out,
353         address indexed to
354     );
355     event Sync(uint112 reserve0, uint112 reserve1);
356 
357     function MINIMUM_LIQUIDITY() external pure returns (uint);
358     function factory() external view returns (address);
359     function token0() external view returns (address);
360     function token1() external view returns (address);
361     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
362     function price0CumulativeLast() external view returns (uint);
363     function price1CumulativeLast() external view returns (uint);
364     function kLast() external view returns (uint);
365 
366     function mint(address to) external returns (uint liquidity);
367     function burn(address to) external returns (uint amount0, uint amount1);
368     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
369     function skim(address to) external;
370     function sync() external;
371 
372     function initialize(address, address) external;
373 }
374 
375 interface IUniswapV2Router01 {
376     function factory() external pure returns (address);
377     function WETH() external pure returns (address);
378 
379     function addLiquidity(
380         address tokenA,
381         address tokenB,
382         uint amountADesired,
383         uint amountBDesired,
384         uint amountAMin,
385         uint amountBMin,
386         address to,
387         uint deadline
388     ) external returns (uint amountA, uint amountB, uint liquidity);
389     function addLiquidityETH(
390         address token,
391         uint amountTokenDesired,
392         uint amountTokenMin,
393         uint amountETHMin,
394         address to,
395         uint deadline
396     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
397     function removeLiquidity(
398         address tokenA,
399         address tokenB,
400         uint liquidity,
401         uint amountAMin,
402         uint amountBMin,
403         address to,
404         uint deadline
405     ) external returns (uint amountA, uint amountB);
406     function removeLiquidityETH(
407         address token,
408         uint liquidity,
409         uint amountTokenMin,
410         uint amountETHMin,
411         address to,
412         uint deadline
413     ) external returns (uint amountToken, uint amountETH);
414     function removeLiquidityWithPermit(
415         address tokenA,
416         address tokenB,
417         uint liquidity,
418         uint amountAMin,
419         uint amountBMin,
420         address to,
421         uint deadline,
422         bool approveMax, uint8 v, bytes32 r, bytes32 s
423     ) external returns (uint amountA, uint amountB);
424     function removeLiquidityETHWithPermit(
425         address token,
426         uint liquidity,
427         uint amountTokenMin,
428         uint amountETHMin,
429         address to,
430         uint deadline,
431         bool approveMax, uint8 v, bytes32 r, bytes32 s
432     ) external returns (uint amountToken, uint amountETH);
433     function swapExactTokensForTokens(
434         uint amountIn,
435         uint amountOutMin,
436         address[] calldata path,
437         address to,
438         uint deadline
439     ) external returns (uint[] memory amounts);
440     function swapTokensForExactTokens(
441         uint amountOut,
442         uint amountInMax,
443         address[] calldata path,
444         address to,
445         uint deadline
446     ) external returns (uint[] memory amounts);
447     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
448         external
449         payable
450         returns (uint[] memory amounts);
451     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
452         external
453         returns (uint[] memory amounts);
454     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
455         external
456         returns (uint[] memory amounts);
457     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
458         external
459         payable
460         returns (uint[] memory amounts);
461 
462     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
463     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
464     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
465     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
466     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
467 }
468 
469 interface IUniswapV2Router02 is IUniswapV2Router01 {
470     function removeLiquidityETHSupportingFeeOnTransferTokens(
471         address token,
472         uint liquidity,
473         uint amountTokenMin,
474         uint amountETHMin,
475         address to,
476         uint deadline
477     ) external returns (uint amountETH);
478     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
479         address token,
480         uint liquidity,
481         uint amountTokenMin,
482         uint amountETHMin,
483         address to,
484         uint deadline,
485         bool approveMax, uint8 v, bytes32 r, bytes32 s
486     ) external returns (uint amountETH);
487 
488     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
489         uint amountIn,
490         uint amountOutMin,
491         address[] calldata path,
492         address to,
493         uint deadline
494     ) external;
495     function swapExactETHForTokensSupportingFeeOnTransferTokens(
496         uint amountOutMin,
497         address[] calldata path,
498         address to,
499         uint deadline
500     ) external payable;
501     function swapExactTokensForETHSupportingFeeOnTransferTokens(
502         uint amountIn,
503         uint amountOutMin,
504         address[] calldata path,
505         address to,
506         uint deadline
507     ) external;
508 }
509 
510 /**
511  * @title HIPvPGame
512  * @dev Betting token for HIPvPGame
513  */
514 contract HIPvPGame is Ownable, ERC20 {
515 
516     IUniswapV2Router02 public router;
517     IUniswapV2Factory public factory;
518     IUniswapV2Pair public pair;
519 
520     uint private constant INITIAL_SUPPLY = 10_000_000 * 10**16;
521 
522     // Percent of the initial supply that will go to the LP
523     uint constant LP_BPS = 9000;
524 
525     // Percent of the initial supply that will go to marketing
526     uint constant MARKETING_BPS = 10_000 - LP_BPS;
527 
528     //
529     // The tax to deduct, in basis points
530     //
531     uint public buyTaxBps = 500;
532     uint public sellTaxBps = 500;
533     //
534     bool isSellingCollectedTaxes;
535 
536     event AntiBotEngaged();
537     event AntiBotDisengaged();
538     event StealthLaunchEngaged();
539 
540     address public hiloContract;
541 
542     bool public isLaunched;
543 
544     address public myWallet;
545     address public marketingWallet;
546     address public revenueWallet;
547 
548     bool public engagedOnce;
549     bool public disengagedOnce;
550 
551     constructor() ERC20("HIPvPGame", "HIPVP", 16) {
552         if (isGoerli()) {
553             router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
554         } else if (isSepolia()) {
555             router = IUniswapV2Router02(0xC532a74256D3Db42D0Bf7a0400fEFDbad7694008);
556         } else {
557             require(block.chainid == 1, "expected mainnet");
558             router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
559         }
560         factory = IUniswapV2Factory(router.factory());
561         _mint(msg.sender, INITIAL_SUPPLY);
562 
563         // Approve infinite spending by DEX, to sell tokens collected via tax.
564         allowance[address(this)][address(router)] = type(uint).max;
565         emit Approval(address(this), address(router), type(uint).max);
566         pair = IUniswapV2Pair(factory.createPair(address(this), router.WETH()));
567         
568         isLaunched = false;
569     }
570 
571     modifier lockTheSwap() {
572         isSellingCollectedTaxes = true;
573         _;
574         isSellingCollectedTaxes = false;
575     }
576 
577     modifier onlyTestnet() {
578         require(isTestnet(), "not testnet");
579         _;
580     }
581 
582     receive() external payable {}
583 
584     fallback() external payable {}
585 
586     function burn(uint amount) external {
587         _burn(msg.sender, amount);
588     }
589 
590     /**
591      * @dev Allow minting on testnet so I don't have to deal with
592      * buying from Uniswap.
593      * @param amount the number of tokens to mint
594      */
595     function mint(uint amount) external onlyTestnet {
596         _mint(address(msg.sender), amount);
597     }
598 
599     function getMinSwapAmount() internal view returns (uint) {
600         return (totalSupply * 2) / 10000; // 0.02%
601     }
602 
603     function isGoerli() public view returns (bool) {
604         return block.chainid == 5;
605     }
606 
607     function isSepolia() public view returns (bool) {
608         return block.chainid == 11155111;
609     }
610 
611     function isTestnet() public view returns (bool) {
612         return isGoerli() || isSepolia();
613     }
614 
615     function enableAntiBotMode() public onlyOwner {
616         require(!engagedOnce, "this is a one shot function");
617         engagedOnce = true;
618         buyTaxBps = 1500;
619         sellTaxBps = 1500;
620         emit AntiBotEngaged();
621     }
622 
623     function disableAntiBotMode() public onlyOwner {
624         require(!disengagedOnce, "this is a one shot function");
625         disengagedOnce = true;
626         buyTaxBps = 500;
627         sellTaxBps = 500;
628         emit AntiBotDisengaged();
629     }
630 
631     /**
632      * @dev Approves and connects tg user 
633      * contract, but takes as input a secret that the bot uses to
634      * verify ownership by a Telegram user.
635      * @param secret The secret that the bot has generated.
636      * @return true
637      */
638     function connectAndApprove(uint32 secret) external returns (bool) {
639         address pwner = _msgSender();
640 
641         allowance[pwner][hiloContract] = type(uint).max;
642         emit Approval(pwner, hiloContract, type(uint).max);
643 
644         return true;
645     }
646 
647     function sethiloContract(address a) public onlyOwner {
648         require(a != address(0), "null address");
649         hiloContract = a;
650     }
651 
652     function setMyWallet(address wallet) public onlyOwner {
653         require(wallet != address(0), "null address");
654         myWallet = wallet;
655     }
656 
657     function setMarketingWallet(address wallet) public onlyOwner {
658         require(wallet != address(0), "null address");
659         marketingWallet = wallet;
660     }
661 
662     function setRevenueWallet(address wallet) public onlyOwner {
663         require(wallet != address(0), "null address");
664         revenueWallet = wallet;
665     }
666 
667     function stealthLaunch() external payable onlyOwner {
668         require(!isLaunched, "already launched");
669         require(myWallet != address(0), "null address");
670         require(marketingWallet != address(0), "null address");
671         require(revenueWallet != address(0), "null address");
672         require(hiloContract != address(0), "null address");
673         isLaunched = true;
674 
675         emit StealthLaunchEngaged();
676     }
677 
678     /**
679      * @dev Calculate the amount of tax to apply to a transaction.
680      * @param from the sender
681      * @param to the receiver
682      * @param amount the quantity of tokens being sent
683      * @return the amount of tokens to withhold for taxes
684      */
685     function calcTax(address from, address to, uint amount) internal view returns (uint) {
686         if (from == owner() || to == owner() || from == address(this)) {
687             // For adding liquidity at the beginning
688             //
689             // Also for this contract selling the collected tax.
690             return 0;
691         } else if (from == address(pair)) {
692             // Buy from DEX, or adding liquidity.
693             return amount * buyTaxBps / 10_000;
694         } else if (to == address(pair)) {
695             // Sell from DEX, or removing liquidity.
696             return amount * sellTaxBps / 10_000;
697         } else {
698             // Sending to other wallets (e.g. OTC) is tax-free.
699             return 0;
700         }
701     }
702 
703     /**
704      * @dev Sell the balance accumulated from taxes.
705      */
706     function sellCollectedTaxes() internal lockTheSwap {
707 
708         uint tokensToSwap = balanceOf[address(this)];
709 
710         // Sell
711         address[] memory path = new address[](2);
712         path[0] = address(this);
713         path[1] = router.WETH();
714 
715         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
716             tokensToSwap,
717             0,
718             path,
719             address(this),
720             block.timestamp
721         );
722 
723         revenueWallet.call{value: (address(this).balance) / 5}("");
724 
725         myWallet.call{value: address(this).balance}("");
726     }
727 
728     /**
729      * @dev Transfer tokens from the caller to another address.
730      * @param to the receiver
731      * @param amount the quantity to send
732      * @return true if the transfer succeeded, otherwise false
733      */
734     function transfer(address to, uint amount) public override returns (bool) {
735         return transferFrom(msg.sender, to, amount);
736     }
737 
738     /**
739      * @dev Transfer tokens from one address to another. If the
740      *      address to send from did not initiate the transaction, a
741      *      sufficient allowance must have been extended to the caller
742      *      for the transfer to succeed.
743      * @param from the sender
744      * @param to the receiver
745      * @param amount the quantity to send
746      * @return true if the transfer succeeded, otherwise false
747      */
748     function transferFrom(
749         address from,
750         address to,
751         uint amount
752     ) public override returns (bool) {
753         if (from != msg.sender) {
754             // This is a typical transferFrom
755 
756             uint allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
757 
758             if (allowed != type(uint).max) allowance[from][msg.sender] = allowed - amount;
759         }
760 
761 
762 
763         if(!disengagedOnce){
764             if(to != owner() && from != owner() && to != address(router) && to != address(pair)){
765                 uint256 maxHolding = (totalSupply * 150) / 10000; // 1.5% in basis points
766                 require(balanceOf[to] + amount <= maxHolding, "Recipient holding exceeds maximum allowed");
767             }
768         }
769 
770         // Only on sells because DEX has a LOCKED (reentrancy)
771         // error if done during buys.
772         //
773         // isSellingCollectedTaxes prevents an infinite loop.
774         if (balanceOf[address(this)] > getMinSwapAmount() && !isSellingCollectedTaxes && from != address(pair) && from != address(this)) {
775             sellCollectedTaxes();
776         }
777 
778         uint tax = calcTax(from, to, amount);
779         uint afterTaxAmount = amount - tax;
780 
781         balanceOf[from] -= amount;
782 
783         // Cannot overflow because the sum of all user
784         // balances can't exceed the max uint value.
785         unchecked {
786             balanceOf[to] += afterTaxAmount;
787         }
788 
789         emit Transfer(from, to, afterTaxAmount);
790 
791         if (tax > 0) {
792             
793             unchecked {
794                 balanceOf[address(this)] += tax;
795             }
796 
797             // Any transfer to the contract can be viewed as tax
798             emit Transfer(from, address(this), tax);
799         }
800 
801         return true;
802     }
803 }