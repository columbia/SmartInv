1 /*
2    Bang Bang Bang - Play Russian Roulette directly in Discord
3 
4    Twitter/X: https://twitter.com/BangERC20
5    Discord:  https://discord.gg/xUhxuzumE2
6    Telegram  https://t.me/BBBPortal
7 
8 */
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.21;
12 
13 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
14 
15 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
16 
17 /**
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         return msg.data;
34     }
35 }
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Throws if called by any account other than the owner.
63      */
64     modifier onlyOwner() {
65         _checkOwner();
66         _;
67     }
68 
69     /**
70      * @dev Returns the address of the current owner.
71      */
72     function owner() public view virtual returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if the sender is not the owner.
78      */
79     function _checkOwner() internal view virtual {
80         require(owner() == _msgSender(), "Ownable: caller is not the owner");
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
115 
116 /**
117  * @dev Interface of the ERC20 standard as defined in the EIP.
118  */
119 interface IERC20 {
120     /**
121      * @dev Emitted when `value` tokens are moved from one account (`from`) to
122      * another (`to`).
123      *
124      * Note that `value` may be zero.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 value);
127 
128     /**
129      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
130      * a call to {approve}. `value` is the new allowance.
131      */
132     event Approval(address indexed owner, address indexed spender, uint256 value);
133 
134     /**
135      * @dev Returns the amount of tokens in existence.
136      */
137     function totalSupply() external view returns (uint256);
138 
139     /**
140      * @dev Returns the amount of tokens owned by `account`.
141      */
142     function balanceOf(address account) external view returns (uint256);
143 
144     /**
145      * @dev Moves `amount` tokens from the caller's account to `to`.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transfer(address to, uint256 amount) external returns (bool);
152 
153     /**
154      * @dev Returns the remaining number of tokens that `spender` will be
155      * allowed to spend on behalf of `owner` through {transferFrom}. This is
156      * zero by default.
157      *
158      * This value changes when {approve} or {transferFrom} are called.
159      */
160     function allowance(address owner, address spender) external view returns (uint256);
161 
162     /**
163      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * IMPORTANT: Beware that changing an allowance with this method brings the risk
168      * that someone may use both the old and the new allowance by unfortunate
169      * transaction ordering. One possible solution to mitigate this race
170      * condition is to first reduce the spender's allowance to 0 and set the
171      * desired value afterwards:
172      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
173      *
174      * Emits an {Approval} event.
175      */
176     function approve(address spender, uint256 amount) external returns (bool);
177 
178     /**
179      * @dev Moves `amount` tokens from `from` to `to` using the
180      * allowance mechanism. `amount` is then deducted from the caller's
181      * allowance.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * Emits a {Transfer} event.
186      */
187     function transferFrom(
188         address from,
189         address to,
190         uint256 amount
191     ) external returns (bool);
192 }
193 
194 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
195 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
196 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
197 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
198 abstract contract ERC20 {
199     /*//////////////////////////////////////////////////////////////
200                                  EVENTS
201     //////////////////////////////////////////////////////////////*/
202 
203     event Transfer(address indexed from, address indexed to, uint256 amount);
204 
205     event Approval(address indexed owner, address indexed spender, uint256 amount);
206 
207     /*//////////////////////////////////////////////////////////////
208                             METADATA STORAGE
209     //////////////////////////////////////////////////////////////*/
210 
211     string public name;
212 
213     string public symbol;
214 
215     uint8 public immutable decimals;
216 
217     /*//////////////////////////////////////////////////////////////
218                               ERC20 STORAGE
219     //////////////////////////////////////////////////////////////*/
220 
221     uint256 public totalSupply;
222 
223     mapping(address => uint256) public balanceOf;
224 
225     mapping(address => mapping(address => uint256)) public allowance;
226 
227     /*//////////////////////////////////////////////////////////////
228                             EIP-2612 STORAGE
229     //////////////////////////////////////////////////////////////*/
230 
231     uint256 internal immutable INITIAL_CHAIN_ID;
232 
233     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
234 
235     mapping(address => uint256) public nonces;
236 
237     /*//////////////////////////////////////////////////////////////
238                                CONSTRUCTOR
239     //////////////////////////////////////////////////////////////*/
240 
241     constructor(
242         string memory _name,
243         string memory _symbol,
244         uint8 _decimals
245     ) {
246         name = _name;
247         symbol = _symbol;
248         decimals = _decimals;
249 
250         INITIAL_CHAIN_ID = block.chainid;
251         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
252     }
253 
254     /*//////////////////////////////////////////////////////////////
255                                ERC20 LOGIC
256     //////////////////////////////////////////////////////////////*/
257 
258     function approve(address spender, uint256 amount) public virtual returns (bool) {
259         allowance[msg.sender][spender] = amount;
260 
261         emit Approval(msg.sender, spender, amount);
262 
263         return true;
264     }
265 
266     function transfer(address to, uint256 amount) public virtual returns (bool) {
267         balanceOf[msg.sender] -= amount;
268 
269         // Cannot overflow because the sum of all user
270         // balances can't exceed the max uint256 value.
271         unchecked {
272             balanceOf[to] += amount;
273         }
274 
275         emit Transfer(msg.sender, to, amount);
276 
277         return true;
278     }
279 
280     function transferFrom(
281         address from,
282         address to,
283         uint256 amount
284     ) public virtual returns (bool) {
285         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
286 
287         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
288 
289         balanceOf[from] -= amount;
290 
291         // Cannot overflow because the sum of all user
292         // balances can't exceed the max uint256 value.
293         unchecked {
294             balanceOf[to] += amount;
295         }
296 
297         emit Transfer(from, to, amount);
298 
299         return true;
300     }
301 
302     /*//////////////////////////////////////////////////////////////
303                              EIP-2612 LOGIC
304     //////////////////////////////////////////////////////////////*/
305 
306     function permit(
307         address owner,
308         address spender,
309         uint256 value,
310         uint256 deadline,
311         uint8 v,
312         bytes32 r,
313         bytes32 s
314     ) public virtual {
315         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
316 
317         // Unchecked because the only math done is incrementing
318         // the owner's nonce which cannot realistically overflow.
319         unchecked {
320             address recoveredAddress = ecrecover(
321                 keccak256(
322                     abi.encodePacked(
323                         "\x19\x01",
324                         DOMAIN_SEPARATOR(),
325                         keccak256(
326                             abi.encode(
327                                 keccak256(
328                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
329                                 ),
330                                 owner,
331                                 spender,
332                                 value,
333                                 nonces[owner]++,
334                                 deadline
335                             )
336                         )
337                     )
338                 ),
339                 v,
340                 r,
341                 s
342             );
343 
344             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
345 
346             allowance[recoveredAddress][spender] = value;
347         }
348 
349         emit Approval(owner, spender, value);
350     }
351 
352     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
353         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
354     }
355 
356     function computeDomainSeparator() internal view virtual returns (bytes32) {
357         return
358             keccak256(
359                 abi.encode(
360                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
361                     keccak256(bytes(name)),
362                     keccak256("1"),
363                     block.chainid,
364                     address(this)
365                 )
366             );
367     }
368 
369     /*//////////////////////////////////////////////////////////////
370                         INTERNAL MINT/BURN LOGIC
371     //////////////////////////////////////////////////////////////*/
372 
373     function _mint(address to, uint256 amount) internal virtual {
374         totalSupply += amount;
375 
376         // Cannot overflow because the sum of all user
377         // balances can't exceed the max uint256 value.
378         unchecked {
379             balanceOf[to] += amount;
380         }
381 
382         emit Transfer(address(0), to, amount);
383     }
384 
385     function _burn(address from, uint256 amount) internal virtual {
386         balanceOf[from] -= amount;
387 
388         // Cannot underflow because a user's balance
389         // will never be larger than the total supply.
390         unchecked {
391             totalSupply -= amount;
392         }
393 
394         emit Transfer(from, address(0), amount);
395     }
396 }
397 
398 interface IUniswapV2Factory {
399     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
400 
401     function feeTo() external view returns (address);
402     function feeToSetter() external view returns (address);
403 
404     function getPair(address tokenA, address tokenB) external view returns (address pair);
405     function allPairs(uint) external view returns (address pair);
406     function allPairsLength() external view returns (uint);
407 
408     function createPair(address tokenA, address tokenB) external returns (address pair);
409 
410     function setFeeTo(address) external;
411     function setFeeToSetter(address) external;
412 }
413 
414 interface IUniswapV2Pair {
415     event Approval(address indexed owner, address indexed spender, uint value);
416     event Transfer(address indexed from, address indexed to, uint value);
417 
418     function name() external pure returns (string memory);
419     function symbol() external pure returns (string memory);
420     function decimals() external pure returns (uint8);
421     function totalSupply() external view returns (uint);
422     function balanceOf(address owner) external view returns (uint);
423     function allowance(address owner, address spender) external view returns (uint);
424 
425     function approve(address spender, uint value) external returns (bool);
426     function transfer(address to, uint value) external returns (bool);
427     function transferFrom(address from, address to, uint value) external returns (bool);
428 
429     function DOMAIN_SEPARATOR() external view returns (bytes32);
430     function PERMIT_TYPEHASH() external pure returns (bytes32);
431     function nonces(address owner) external view returns (uint);
432 
433     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
434 
435     event Mint(address indexed sender, uint amount0, uint amount1);
436     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
437     event Swap(
438         address indexed sender,
439         uint amount0In,
440         uint amount1In,
441         uint amount0Out,
442         uint amount1Out,
443         address indexed to
444     );
445     event Sync(uint112 reserve0, uint112 reserve1);
446 
447     function MINIMUM_LIQUIDITY() external pure returns (uint);
448     function factory() external view returns (address);
449     function token0() external view returns (address);
450     function token1() external view returns (address);
451     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
452     function price0CumulativeLast() external view returns (uint);
453     function price1CumulativeLast() external view returns (uint);
454     function kLast() external view returns (uint);
455 
456     function mint(address to) external returns (uint liquidity);
457     function burn(address to) external returns (uint amount0, uint amount1);
458     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
459     function skim(address to) external;
460     function sync() external;
461 
462     function initialize(address, address) external;
463 }
464 
465 interface IUniswapV2Router01 {
466     function factory() external pure returns (address);
467     function WETH() external pure returns (address);
468 
469     function addLiquidity(
470         address tokenA,
471         address tokenB,
472         uint amountADesired,
473         uint amountBDesired,
474         uint amountAMin,
475         uint amountBMin,
476         address to,
477         uint deadline
478     ) external returns (uint amountA, uint amountB, uint liquidity);
479     function addLiquidityETH(
480         address token,
481         uint amountTokenDesired,
482         uint amountTokenMin,
483         uint amountETHMin,
484         address to,
485         uint deadline
486     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
487     function removeLiquidity(
488         address tokenA,
489         address tokenB,
490         uint liquidity,
491         uint amountAMin,
492         uint amountBMin,
493         address to,
494         uint deadline
495     ) external returns (uint amountA, uint amountB);
496     function removeLiquidityETH(
497         address token,
498         uint liquidity,
499         uint amountTokenMin,
500         uint amountETHMin,
501         address to,
502         uint deadline
503     ) external returns (uint amountToken, uint amountETH);
504     function removeLiquidityWithPermit(
505         address tokenA,
506         address tokenB,
507         uint liquidity,
508         uint amountAMin,
509         uint amountBMin,
510         address to,
511         uint deadline,
512         bool approveMax, uint8 v, bytes32 r, bytes32 s
513     ) external returns (uint amountA, uint amountB);
514     function removeLiquidityETHWithPermit(
515         address token,
516         uint liquidity,
517         uint amountTokenMin,
518         uint amountETHMin,
519         address to,
520         uint deadline,
521         bool approveMax, uint8 v, bytes32 r, bytes32 s
522     ) external returns (uint amountToken, uint amountETH);
523     function swapExactTokensForTokens(
524         uint amountIn,
525         uint amountOutMin,
526         address[] calldata path,
527         address to,
528         uint deadline
529     ) external returns (uint[] memory amounts);
530     function swapTokensForExactTokens(
531         uint amountOut,
532         uint amountInMax,
533         address[] calldata path,
534         address to,
535         uint deadline
536     ) external returns (uint[] memory amounts);
537     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
538         external
539         payable
540         returns (uint[] memory amounts);
541     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
542         external
543         returns (uint[] memory amounts);
544     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
545         external
546         returns (uint[] memory amounts);
547     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
548         external
549         payable
550         returns (uint[] memory amounts);
551 
552     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
553     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
554     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
555     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
556     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
557 }
558 
559 interface IUniswapV2Router02 is IUniswapV2Router01 {
560     function removeLiquidityETHSupportingFeeOnTransferTokens(
561         address token,
562         uint liquidity,
563         uint amountTokenMin,
564         uint amountETHMin,
565         address to,
566         uint deadline
567     ) external returns (uint amountETH);
568     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
569         address token,
570         uint liquidity,
571         uint amountTokenMin,
572         uint amountETHMin,
573         address to,
574         uint deadline,
575         bool approveMax, uint8 v, bytes32 r, bytes32 s
576     ) external returns (uint amountETH);
577 
578     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
579         uint amountIn,
580         uint amountOutMin,
581         address[] calldata path,
582         address to,
583         uint deadline
584     ) external;
585     function swapExactETHForTokensSupportingFeeOnTransferTokens(
586         uint amountOutMin,
587         address[] calldata path,
588         address to,
589         uint deadline
590     ) external payable;
591     function swapExactTokensForETHSupportingFeeOnTransferTokens(
592         uint amountIn,
593         uint amountOutMin,
594         address[] calldata path,
595         address to,
596         uint deadline
597     ) external;
598 }
599 
600 contract BangBangBang is Ownable, ERC20 {
601 
602     IUniswapV2Router02 public router;
603     IUniswapV2Factory public factory;
604     IUniswapV2Pair public pair;
605 
606     uint private constant INITIAL_SUPPLY = 10_000_000 * 10**8;
607 
608     // Percent of the initial supply that will go to the LP
609     uint constant LP_BPS = 9000;
610 
611     // Percent of the initial supply that will go to marketing
612     uint constant MARKETING_BPS = 10_000 - LP_BPS;
613 
614     //
615     // The tax to deduct, in basis points
616     //
617     uint public buyTaxBps = 500;
618     uint public sellTaxBps = 500;
619     //
620     bool isSellingCollectedTaxes;
621 
622     event AntiBotEngaged();
623     event AntiBotDisengaged();
624     event StealthLaunchEngaged();
625 
626     address public rouletteContract;
627 
628     bool public isLaunched;
629 
630     address public myWallet;
631     address public marketingWallet;
632     address public revenueWallet;
633 
634     bool public engagedOnce;
635     bool public disengagedOnce;
636 
637     constructor() ERC20("Bang Bang Bang", "BBB", 8) {
638         if (isGoerli()) {
639             router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
640         } else if (isSepolia()) {
641             router = IUniswapV2Router02(0xC532a74256D3Db42D0Bf7a0400fEFDbad7694008);
642         } else {
643             require(block.chainid == 1, "expected mainnet");
644             router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
645         }
646         factory = IUniswapV2Factory(router.factory());
647 
648         // Approve infinite spending by DEX, to sell tokens collected via tax.
649         allowance[address(this)][address(router)] = type(uint).max;
650         emit Approval(address(this), address(router), type(uint).max);
651 
652         isLaunched = false;
653     }
654 
655     modifier lockTheSwap() {
656         isSellingCollectedTaxes = true;
657         _;
658         isSellingCollectedTaxes = false;
659     }
660 
661     modifier onlyTestnet() {
662         require(isTestnet(), "not testnet");
663         _;
664     }
665 
666     receive() external payable {}
667 
668     fallback() external payable {}
669 
670     function burn(uint amount) external {
671         _burn(msg.sender, amount);
672     }
673 
674     /**
675      * @dev Allow minting on testnet
676      * @param amount the number of tokens to mint
677      */
678     function mint(uint amount) external onlyTestnet {
679         _mint(address(msg.sender), amount);
680     }
681 
682     function getMinSwapAmount() internal view returns (uint) {
683         return (totalSupply * 2) / 10000; // 0.02%
684     }
685 
686     function isGoerli() public view returns (bool) {
687         return block.chainid == 5;
688     }
689 
690     function isSepolia() public view returns (bool) {
691         return block.chainid == 11155111;
692     }
693 
694     function isTestnet() public view returns (bool) {
695         return isGoerli() || isSepolia();
696     }
697 
698     function enableAntiBotMode() public onlyOwner {
699         require(!engagedOnce, "this is a one shot function");
700         engagedOnce = true;
701         buyTaxBps = 1000;
702         sellTaxBps = 1000;
703         emit AntiBotEngaged();
704     }
705 
706     function disableAntiBotMode() public onlyOwner {
707         require(!disengagedOnce, "this is a one shot function");
708         disengagedOnce = true;
709         buyTaxBps = 500;
710         sellTaxBps = 500;
711         emit AntiBotDisengaged();
712     }
713 
714     /**
715      * @dev Does the same thing as a max approve for the roulette
716      * contract, but takes as input a secret that the bot uses to
717      * verify ownership by a Discord user.
718      * @param secret The secret that the bot is expecting.
719      * @return true
720      */
721     function connectAndApprove(uint32 secret) external returns (bool) {
722         address pwner = _msgSender();
723 
724         allowance[pwner][rouletteContract] = type(uint).max;
725         emit Approval(pwner, rouletteContract, type(uint).max);
726 
727         return true;
728     }
729 
730     function setRouletteContract(address a) public onlyOwner {
731         require(a != address(0), "null address");
732         rouletteContract = a;
733     }
734 
735     function setMyWallet(address wallet) public onlyOwner {
736         require(wallet != address(0), "null address");
737         myWallet = wallet;
738     }
739 
740     function setMarketingWallet(address wallet) public onlyOwner {
741         require(wallet != address(0), "null address");
742         marketingWallet = wallet;
743     }
744 
745     function setRevenueWallet(address wallet) public onlyOwner {
746         require(wallet != address(0), "null address");
747         revenueWallet = wallet;
748     }
749 
750     function stealthLaunch() external payable onlyOwner {
751         require(!isLaunched, "already launched");
752         require(myWallet != address(0), "null address");
753         require(marketingWallet != address(0), "null address");
754         require(revenueWallet != address(0), "null address");
755         require(rouletteContract != address(0), "null address");
756         isLaunched = true;
757 
758         _mint(address(this), INITIAL_SUPPLY * LP_BPS / 10_000);
759 
760         router.addLiquidityETH{ value: msg.value }(
761             address(this),
762             balanceOf[address(this)],
763             0,
764             0,
765             owner(),
766             block.timestamp);
767 
768         pair = IUniswapV2Pair(factory.getPair(address(this), router.WETH()));
769 
770         _mint(marketingWallet, INITIAL_SUPPLY * MARKETING_BPS / 10_000);
771 
772         require(totalSupply == INITIAL_SUPPLY, "numbers don't add up");
773 
774         if (isTestnet()) {
775             _mint(address(msg.sender), 10_000 * 10**decimals);
776         }
777 
778         emit StealthLaunchEngaged();
779     }
780 
781     /**
782      * @dev Calculate the amount of tax to apply to a transaction.
783      * @param from the sender
784      * @param to the receiver
785      * @param amount the quantity of tokens being sent
786      * @return the amount of tokens to withhold for taxes
787      */
788     function calcTax(address from, address to, uint amount) internal view returns (uint) {
789         if (from == owner() || to == owner() || from == address(this)) {
790             // For adding liquidity at the beginning
791             //
792             // Also for this contract selling the collected tax.
793             return 0;
794         } else if (from == address(pair)) {
795             // Buy from DEX, or adding liquidity.
796             return amount * buyTaxBps / 10_000;
797         } else if (to == address(pair)) {
798             // Sell from DEX, or removing liquidity.
799             return amount * sellTaxBps / 10_000;
800         } else {
801             // Sending to other wallets (e.g. OTC) is tax-free.
802             return 0;
803         }
804     }
805 
806     /**
807      * @dev Sell the balance accumulated from taxes.
808      */
809     function sellCollectedTaxes() internal lockTheSwap {
810         // Of the remaining tokens, set aside 1/4 of the tokens to LP,
811         // swap the rest for ETH. LP the tokens with all of the ETH
812         // (only enough ETH will be used to pair with the original 1/4
813         // of tokens). Send the remaining ETH (about half the original
814         // balance) to my wallet.
815 
816         uint tokensForLiq = balanceOf[address(this)] / 4;
817         uint tokensToSwap = balanceOf[address(this)] - tokensForLiq;
818 
819         // Sell
820         address[] memory path = new address[](2);
821         path[0] = address(this);
822         path[1] = router.WETH();
823         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
824             tokensToSwap,
825             0,
826             path,
827             address(this),
828             block.timestamp
829         );
830 
831         router.addLiquidityETH{ value: address(this).balance }(
832             address(this),
833             tokensForLiq,
834             0,
835             0,
836             owner(),
837             block.timestamp);
838 
839         myWallet.call{value: address(this).balance}("");
840     }
841 
842     /**
843      * @dev Transfer tokens from the caller to another address.
844      * @param to the receiver
845      * @param amount the quantity to send
846      * @return true if the transfer succeeded, otherwise false
847      */
848     function transfer(address to, uint amount) public override returns (bool) {
849         return transferFrom(msg.sender, to, amount);
850     }
851 
852     /**
853      * @dev Transfer tokens from one address to another. If the
854      *      address to send from did not initiate the transaction, a
855      *      sufficient allowance must have been extended to the caller
856      *      for the transfer to succeed.
857      * @param from the sender
858      * @param to the receiver
859      * @param amount the quantity to send
860      * @return true if the transfer succeeded, otherwise false
861      */
862     function transferFrom(
863         address from,
864         address to,
865         uint amount
866     ) public override returns (bool) {
867         if (from != msg.sender) {
868             // This is a typical transferFrom
869 
870             uint allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
871 
872             if (allowed != type(uint).max) allowance[from][msg.sender] = allowed - amount;
873         }
874 
875         // Only on sells because DEX has a LOCKED (reentrancy)
876         // error if done during buys.
877         //
878         // isSellingCollectedTaxes prevents an infinite loop.
879         if (balanceOf[address(this)] > getMinSwapAmount() && !isSellingCollectedTaxes && from != address(pair) && from != address(this)) {
880             sellCollectedTaxes();
881         }
882 
883         uint tax = calcTax(from, to, amount);
884         uint afterTaxAmount = amount - tax;
885 
886         balanceOf[from] -= amount;
887 
888         // Cannot overflow because the sum of all user
889         // balances can't exceed the max uint value.
890         unchecked {
891             balanceOf[to] += afterTaxAmount;
892         }
893 
894         emit Transfer(from, to, afterTaxAmount);
895 
896         if (tax > 0) {
897             // Use 1/5 of tax for revenue
898             uint revenue = tax / 5;
899             tax -= revenue;
900 
901             unchecked {
902                 balanceOf[address(this)] += tax;
903                 balanceOf[revenueWallet] += revenue;
904             }
905 
906             // Any transfer to the contract can be viewed as tax
907             emit Transfer(from, address(this), tax);
908             emit Transfer(from, revenueWallet, revenue);
909         }
910 
911         return true;
912     }
913 
914 
915     function setTaxes(uint256 _buyTaxBps, uint256 _sellTaxBps) public onlyOwner {
916         buyTaxBps = _buyTaxBps;
917         sellTaxBps = _sellTaxBps;
918     }
919 }
920 
921 /**
922  * @title BangBangBangRoulette
923  * @dev Store funds for Roulette and distribute the winnings as games finish.
924  */
925 contract BangBangBangRoulette is Ownable {
926 
927     address public revenueWallet;
928 
929     BangBangBang public immutable bettingToken;
930 
931     uint256 public immutable minimumBet;
932 
933     // The amount to take as revenue, in basis points.
934     uint256 public immutable revenueBps;
935 
936     // The amount to burn forever, in basis points.
937     uint256 public immutable burnBps;
938 
939     // Map Discord channel IDs to their games.
940     mapping(int64 => Game) public games;
941 
942     // The Discord channel IDs for each active game. Mainly used to
943     // abort all active games in the event of a catastrophe.
944     int64[] public activeTgGroups;
945 
946     // Stores the amount each player has bet for a game.
947     event Bet(int64 tgChatId, address player, uint16 playerIndex, uint256 amount);
948 
949     // Stores the amount each player wins for a game.
950     event Win(int64 tgChatId, address player, uint16 playerIndex, uint256 amount);
951 
952     // Stores the amount the loser lost.
953     event Loss(int64 tgChatId, address player, uint16 playerIndex, uint256 amount);
954 
955     // Stores the amount collected by the protocol.
956     event Revenue(int64 tgChatId, uint256 amount);
957 
958     // Stores the amount burned by the protocol.
959     event Burn(int64 tgChatId, uint256 amount);
960 
961     constructor(address payable _bettingToken, uint256 _minimumBet, uint256 _revenueBps, uint256 _burnBps, address _revenueWallet) {
962         revenueWallet = _revenueWallet;
963         revenueBps = _revenueBps;
964         burnBps = _burnBps;
965         bettingToken = BangBangBang(_bettingToken);
966         minimumBet = _minimumBet;
967     }
968 
969     struct Game {
970         uint256 revolverSize;
971         uint256 minBet;
972 
973         // This is a SHA-256 hash of the random number generated by the bot.
974         bytes32 hashedBulletChamberIndex;
975 
976         address[] players;
977         uint256[] bets;
978 
979         bool inProgress;
980         uint16 loser;
981     }
982 
983     /**
984      * @dev Check if there is a game in progress for a Discord channel.
985      * @param _discordChannelId Discord channel to check
986      * @return true if there is a game in progress, otherwise false
987      */
988     function isGameInProgress(int64 _discordChannelId) public view returns (bool) {
989         return games[_discordChannelId].inProgress;
990     }
991 
992     /**
993      * @dev Remove a Discord channel ID from the array.
994      * @param _discordChannelId Discord channel ID to remove
995      */
996     function removeTgId(int64 _discordChannelId) internal {
997         for (uint256 i = 0; i < activeTgGroups.length; i++) {
998             if (activeTgGroups[i] == _discordChannelId) {
999                 activeTgGroups[i] = activeTgGroups[activeTgGroups.length - 1];
1000                 activeTgGroups.pop();
1001             }
1002         }
1003     }
1004 
1005     /**
1006      * @dev Create a new game. Transfer funds into escrow.
1007      * @param _discordChannelId Discord channel of this game
1008      * @param _revolverSize number of chambers in the revolver
1009      * @param _minBet minimum bet to play
1010      * @param _hashedBulletChamberIndex which chamber the bullet is in
1011      * @param _players participating players
1012      * @param _bets each player's bet
1013      * @return The updated list of bets.
1014      */
1015     function newGame(
1016         int64 _discordChannelId,
1017         uint256 _revolverSize,
1018         uint256 _minBet,
1019         bytes32 _hashedBulletChamberIndex,
1020         address[] memory _players,
1021         uint256[] memory _bets) public onlyOwner returns (uint256[] memory) {
1022         require(_revolverSize >= 2, "Revolver size too small");
1023         require(_players.length <= _revolverSize, "Too many players for this size revolver");
1024         require(_minBet >= minimumBet, "Minimum bet too small");
1025         require(_players.length == _bets.length, "Players/bets length mismatch");
1026         require(_players.length > 1, "Not enough players");
1027         require(!isGameInProgress(_discordChannelId), "There is already a game in progress");
1028 
1029         // The bets will be capped so you can only lose what other
1030         // players bet. The updated bets will be returned to the
1031         // caller.
1032         //
1033         // O(N) by doing a prepass to sum all the bets in the
1034         // array. Use the sum to modify one bet at a time. Replace
1035         // each bet with its updated value.
1036         uint256 betTotal = 0;
1037         for (uint16 i = 0; i < _bets.length; i++) {
1038             require(_bets[i] >= _minBet, "Bet is smaller than the minimum");
1039             betTotal += _bets[i];
1040         }
1041         for (uint16 i = 0; i < _bets.length; i++) {
1042             betTotal -= _bets[i];
1043             if (_bets[i] > betTotal) {
1044                 _bets[i] = betTotal;
1045             }
1046             betTotal += _bets[i];
1047 
1048             require(bettingToken.allowance(_players[i], address(this)) >= _bets[i], "Not enough allowance");
1049             bool isSent = bettingToken.transferFrom(_players[i], address(this), _bets[i]);
1050             require(isSent, "Funds transfer failed");
1051 
1052             emit Bet(_discordChannelId, _players[i], i, _bets[i]);
1053         }
1054 
1055         Game memory g;
1056         g.revolverSize = _revolverSize;
1057         g.minBet = _minBet;
1058         g.hashedBulletChamberIndex = _hashedBulletChamberIndex;
1059         g.players = _players;
1060         g.bets = _bets;
1061         g.inProgress = true;
1062 
1063         games[_discordChannelId] = g;
1064         activeTgGroups.push(_discordChannelId);
1065 
1066         return _bets;
1067     }
1068 
1069     /**
1070      * @dev Declare a loser of the game and pay out the winnings.
1071      * @param _discordChannelId Discord channel of this game
1072      * @param _loser index of the loser
1073      *
1074      * There is also a string array that will be passed in by the bot
1075      * containing labeled strings, for historical/auditing purposes:
1076      *
1077      * beta: The randomly generated number in hex.
1078      *
1079      * salt: The salt to append to beta for hashing, in hex.
1080      *
1081      * publickey: The VRF public key in hex.
1082      *
1083      * proof: The generated proof in hex.
1084      *
1085      * alpha: The input message to the VRF.
1086      */
1087     function endGame(
1088         int64 _discordChannelId,
1089         uint16 _loser,
1090         string[] calldata) public onlyOwner {
1091         require(_loser != type(uint16).max, "Loser index shouldn't be the sentinel value");
1092         require(isGameInProgress(_discordChannelId), "No game in progress for this Discord channel ID");
1093 
1094         Game storage g = games[_discordChannelId];
1095 
1096         require(_loser < g.players.length, "Loser index out of range");
1097         require(g.players.length > 1, "Not enough players");
1098 
1099         g.loser = _loser;
1100         g.inProgress = false;
1101         removeTgId(_discordChannelId);
1102 
1103         // Parallel arrays
1104         address[] memory winners = new address[](g.players.length - 1);
1105         uint16[] memory winnersPlayerIndex = new uint16[](g.players.length - 1);
1106 
1107         // The total bets of the winners.
1108         uint256 winningBetTotal = 0;
1109 
1110         // Filter out the loser and calc the total winning bets.
1111         {
1112             uint16 numWinners = 0;
1113             for (uint16 i = 0; i < g.players.length; i++) {
1114                 if (i != _loser) {
1115                     winners[numWinners] = g.players[i];
1116                     winnersPlayerIndex[numWinners] = i;
1117                     winningBetTotal += g.bets[i];
1118                     numWinners++;
1119                 }
1120             }
1121         }
1122 
1123         uint256 totalPaidWinnings = 0;
1124         require(burnBps + revenueBps < 10_1000, "Total fees must be < 100%");
1125 
1126         // The share of tokens to burn.
1127         uint256 burnShare = g.bets[_loser] * burnBps / 10_000;
1128 
1129         // The share left for the contract. This is an approximate
1130         // value. The real value will be whatever is leftover after
1131         // each winner is paid their share.
1132         uint256 approxRevenueShare = g.bets[_loser] * revenueBps / 10_000;
1133 
1134         bool isSent;
1135         {
1136             uint256 totalWinnings = g.bets[_loser] - burnShare - approxRevenueShare;
1137 
1138             for (uint16 i = 0; i < winners.length; i++) {
1139                 uint256 winnings = totalWinnings * g.bets[winnersPlayerIndex[i]] / winningBetTotal;
1140 
1141                 isSent = bettingToken.transfer(winners[i], g.bets[winnersPlayerIndex[i]] + winnings);
1142                 require(isSent, "Funds transfer failed");
1143 
1144                 emit Win(_discordChannelId, winners[i], winnersPlayerIndex[i], winnings);
1145 
1146                 totalPaidWinnings += winnings;
1147             }
1148         }
1149 
1150         bettingToken.burn(burnShare);
1151         emit Burn(_discordChannelId, burnShare);
1152 
1153         uint256 realRevenueShare = g.bets[_loser] - totalPaidWinnings - burnShare;
1154         isSent = bettingToken.transfer(revenueWallet, realRevenueShare);
1155         require(isSent, "Revenue transfer failed");
1156         emit Revenue(_discordChannelId, realRevenueShare);
1157 
1158         require((totalPaidWinnings + burnShare + realRevenueShare) == g.bets[_loser], "Calculated winnings do not add up");
1159     }
1160 
1161     /**
1162      * @dev Abort a game and refund the bets. Use in emergencies
1163      *      e.g. bot crash.
1164      * @param _discordChannelId Discord channel of this game
1165      */
1166     function abortGame(int64 _discordChannelId) public onlyOwner {
1167         require(isGameInProgress(_discordChannelId), "No game in progress for this Discord channel ID");
1168         Game storage g = games[_discordChannelId];
1169 
1170         for (uint16 i = 0; i < g.players.length; i++) {
1171             bool isSent = bettingToken.transfer(g.players[i], g.bets[i]);
1172             require(isSent, "Funds transfer failed");
1173         }
1174 
1175         g.inProgress = false;
1176         removeTgId(_discordChannelId);
1177     }
1178 
1179     /**
1180      * @dev Abort all in progress games.
1181      */
1182     function abortAllGames() public onlyOwner {
1183         // abortGame modifies activeTgGroups with each call, so
1184         // iterate over a copy
1185         int64[] memory _activeTgGroups = activeTgGroups;
1186         for (uint256 i = 0; i < _activeTgGroups.length; i++) {
1187             abortGame(_activeTgGroups[i]);
1188         }
1189     }
1190 }