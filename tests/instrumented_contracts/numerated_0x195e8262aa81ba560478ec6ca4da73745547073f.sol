1 // SPDX-License-Identifier: GPL-2.0
2 /*
3 ▄▄█    ▄   ██   █▄▄▄▄ ▄█ 
4 ██     █  █ █  █  ▄▀ ██ 
5 ██ ██   █ █▄▄█ █▀▀▌  ██ 
6 ▐█ █ █  █ █  █ █  █  ▐█ 
7  ▐ █  █ █    █   █    ▐ 
8    █   ██   █   ▀   
9            ▀          */
10 /// 🦊🌾 Special thanks to Keno / Boring / Gonpachi / Karbon for review and continued inspiration.
11 pragma solidity 0.7.6;
12 pragma experimental ABIEncoderV2;
13 
14 /// @notice Minimal erc20 interface (with EIP 2612) to aid other interfaces. 
15 interface IERC20 {
16     function permit(
17         address owner,
18         address spender,
19         uint256 value,
20         uint256 deadline,
21         uint8 v,
22         bytes32 r,
23         bytes32 s
24     ) external;
25 }
26 
27 /// @notice Interface for Dai Stablecoin (DAI) `permit()` primitive.
28 interface IDaiPermit {
29     function permit(
30         address holder,
31         address spender,
32         uint256 nonce,
33         uint256 expiry,
34         bool allowed,
35         uint8 v,
36         bytes32 r,
37         bytes32 s
38     ) external;
39 }
40 
41 // File @boringcrypto/boring-solidity/contracts/libraries/BoringERC20.sol@v1.2.0
42 /// License-Identifier: MIT
43 /// @dev Adapted for Inari.
44 library BoringERC20 {
45     bytes4 private constant SIG_BALANCE_OF = 0x70a08231; // balanceOf(address)
46     bytes4 private constant SIG_APPROVE = 0x095ea7b3; // approve(address,uint256)
47     bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)
48     bytes4 private constant SIG_TRANSFER_FROM = 0x23b872dd; // transferFrom(address,address,uint256)
49 
50     /// @notice Provides a gas-optimized balance check on this contract to avoid a redundant extcodesize check in addition to the returndatasize check.
51     /// @param token The address of the ERC-20 token.
52     /// @return amount The token amount.
53     function safeBalanceOfSelf(IERC20 token) internal view returns (uint256 amount) {
54         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_BALANCE_OF, address(this)));
55         require(success && data.length >= 32, "BoringERC20: BalanceOf failed");
56         amount = abi.decode(data, (uint256));
57     }
58     
59     /// @notice Provides a safe ERC20.approve version for different ERC-20 implementations.
60     /// @param token The address of the ERC-20 token.
61     /// @param to The address of the user to grant spending right.
62     /// @param amount The token amount to grant spending right over.
63     function safeApprove(
64         IERC20 token, 
65         address to, 
66         uint256 amount
67     ) internal {
68         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_APPROVE, to, amount));
69         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: Approve failed");
70     }
71 
72     /// @notice Provides a safe ERC20.transfer version for different ERC-20 implementations.
73     /// Reverts on a failed transfer.
74     /// @param token The address of the ERC-20 token.
75     /// @param to Transfer tokens to.
76     /// @param amount The token amount.
77     function safeTransfer(
78         IERC20 token,
79         address to,
80         uint256 amount
81     ) internal {
82         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER, to, amount));
83         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: Transfer failed");
84     }
85 
86     /// @notice Provides a safe ERC20.transferFrom version for different ERC-20 implementations.
87     /// Reverts on a failed transfer.
88     /// @param token The address of the ERC-20 token.
89     /// @param from Transfer tokens from.
90     /// @param to Transfer tokens to.
91     /// @param amount The token amount.
92     function safeTransferFrom(
93         IERC20 token,
94         address from,
95         address to,
96         uint256 amount
97     ) internal {
98         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER_FROM, from, to, amount));
99         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: TransferFrom failed");
100     }
101 }
102 
103 // File @boringcrypto/boring-solidity/contracts/BoringBatchable.sol@v1.2.0
104 /// License-Identifier: MIT
105 /// @dev Adapted for Inari.
106 contract BaseBoringBatchable {
107     /// @dev Helper function to extract a useful revert message from a failed call.
108     /// If the returned data is malformed or not correctly abi encoded then this call can fail itself.
109     function _getRevertMsg(bytes memory _returnData) internal pure returns (string memory) {
110         // If the _res length is less than 68, then the transaction failed silently (without a revert message)
111         if (_returnData.length < 68) return "Transaction reverted silently";
112 
113         assembly {
114             // Slice the sighash.
115             _returnData := add(_returnData, 0x04)
116         }
117         return abi.decode(_returnData, (string)); // All that remains is the revert string
118     }
119 
120     /// @notice Allows batched call to self (this contract).
121     /// @param calls An array of inputs for each call.
122     /// @param revertOnFail If True then reverts after a failed call and stops doing further calls.
123     function batch(bytes[] calldata calls, bool revertOnFail) external payable {
124         for (uint256 i = 0; i < calls.length; i++) {
125             (bool success, bytes memory result) = address(this).delegatecall(calls[i]);
126             if (!success && revertOnFail) {
127                 revert(_getRevertMsg(result));
128             }
129         }
130     }
131 }
132 
133 /// @notice Extends `BoringBatchable` with DAI `permit()`.
134 contract BoringBatchableWithDai is BaseBoringBatchable {
135     /// @notice Call wrapper that performs `ERC20.permit` using EIP 2612 primitive.
136     /// Lookup `IDaiPermit.permit`.
137     function permitDai(
138         IDaiPermit token,
139         address holder,
140         address spender,
141         uint256 nonce,
142         uint256 expiry,
143         bool allowed,
144         uint8 v,
145         bytes32 r,
146         bytes32 s
147     ) public {
148         token.permit(holder, spender, nonce, expiry, allowed, v, r, s);
149     }
150     
151     /// @notice Call wrapper that performs `ERC20.permit` on `token`.
152     /// Lookup `IERC20.permit`.
153     function permitToken(
154         IERC20 token,
155         address from,
156         address to,
157         uint256 amount,
158         uint256 deadline,
159         uint8 v,
160         bytes32 r,
161         bytes32 s
162     ) public {
163         token.permit(from, to, amount, deadline, v, r, s);
164     }
165 }
166 
167 /// @notice Babylonian method (https://en.wikipedia.org/wiki/Methods_of_computing_square_roots#Babylonian_method).
168 library Babylonian {
169     // computes square roots using the babylonian method
170     // credit for this implementation goes to
171     // https://github.com/abdk-consulting/abdk-libraries-solidity/blob/master/ABDKMath64x64.sol#L687
172     function sqrt(uint256 x) internal pure returns (uint256) {
173         if (x == 0) return 0;
174         // this block is equivalent to r = uint256(1) << (BitMath.mostSignificantBit(x) / 2);
175         // however that code costs significantly more gas
176         uint256 xx = x;
177         uint256 r = 1;
178         if (xx >= 0x100000000000000000000000000000000) {
179             xx >>= 128;
180             r <<= 64;
181         }
182         if (xx >= 0x10000000000000000) {
183             xx >>= 64;
184             r <<= 32;
185         }
186         if (xx >= 0x100000000) {
187             xx >>= 32;
188             r <<= 16;
189         }
190         if (xx >= 0x10000) {
191             xx >>= 16;
192             r <<= 8;
193         }
194         if (xx >= 0x100) {
195             xx >>= 8;
196             r <<= 4;
197         }
198         if (xx >= 0x10) {
199             xx >>= 4;
200             r <<= 2;
201         }
202         if (xx >= 0x8) {
203             r <<= 1;
204         }
205         r = (r + x / r) >> 1;
206         r = (r + x / r) >> 1;
207         r = (r + x / r) >> 1;
208         r = (r + x / r) >> 1;
209         r = (r + x / r) >> 1;
210         r = (r + x / r) >> 1;
211         r = (r + x / r) >> 1; // Seven iterations should be enough
212         uint256 r1 = x / r;
213         return (r < r1 ? r : r1);
214     }
215 }
216 
217 /// @notice Interface for SushiSwap.
218 interface ISushiSwap {
219     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
220     function token0() external pure returns (address);
221     function token1() external pure returns (address);
222     function burn(address to) external returns (uint amount0, uint amount1);
223     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
224     
225     function addLiquidity(
226         address tokenA,
227         address tokenB,
228         uint256 amountADesired,
229         uint256 amountBDesired,
230         uint256 amountAMin,
231         uint256 amountBMin,
232         address to,
233         uint256 deadline
234     )
235         external
236         returns (
237             uint256 amountA,
238             uint256 amountB,
239             uint256 liquidity
240         );
241 
242     function swapExactTokensForTokens(
243         uint256 amountIn,
244         uint256 amountOutMin,
245         address[] calldata path,
246         address to,
247         uint256 deadline
248     ) external returns (uint256[] memory amounts);
249 }
250 
251 /// @notice Interface for wrapped ether v9.
252 interface IWETH {
253     function deposit() external payable;
254 }
255 
256 /// @notice Library for performing overflow-safe math, courtesy of DappHub (https://github.com/dapphub/ds-math).
257 library SafeMath {
258     function add(uint x, uint y) internal pure returns (uint z) {
259         require((z = x + y) >= x, 'ds-math-add-overflow');
260     }
261 
262     function sub(uint x, uint y) internal pure returns (uint z) {
263         require((z = x - y) <= x, 'ds-math-sub-underflow');
264     }
265 
266     function mul(uint x, uint y) internal pure returns (uint z) {
267         require(y == 0 || (z = x * y) / y == x, 'ds-math-mul-overflow');
268     }
269 }
270 
271 // Copyright (C) 2020-2021 zapper
272 // License-Identifier: GPL-2.0
273 /// @notice SushiSwap liquidity zaps based on awesomeness from zapper.fi (0xcff6eF0B9916682B37D80c19cFF8949bc1886bC2/0x5abfbE56553a5d794330EACCF556Ca1d2a55647C).
274 contract SushiZap {
275     using SafeMath for uint256;
276     using BoringERC20 for IERC20; 
277     
278     address public governor; // SushiZap governance address for approving `_swapTarget` inputs
279     address constant sushiSwapFactory = 0xC0AEe478e3658e2610c5F7A4A2E1777cE9e4f2Ac; // SushiSwap factory contract
280     address constant wETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2; // ETH wrapper contract v9
281     ISushiSwap constant sushiSwapRouter = ISushiSwap(0xd9e1cE17f2641f24aE83637ab66a2cca9C378B9F); // SushiSwap router contract
282     uint256 constant deadline = 0xf000000000000000000000000000000000000000000000000000000000000000; // ~ placeholder for swap deadline
283     bytes32 constant pairCodeHash = 0xe18a34eb0e04b04f7a0ac29a6e80748dca96319b42c54d679cb821dca90c6303; // SushiSwap pair code hash
284     
285     /// @dev swapTarget => approval status.
286     mapping(address => bool) public approvedTargets;
287 
288     event ZapIn(address sender, address pool, uint256 tokensRec);
289     
290     constructor() {
291         governor = msg.sender;
292         approvedTargets[wETH] = true;
293     }
294     
295     /// @dev This function whitelists `_swapTarget`s - cf. `Sushiswap_ZapIn_V4` (C) 2021 zapper.
296     function setApprovedTargets(address[] calldata targets, bool[] calldata isApproved) external {
297         require(msg.sender == governor, '!governor');
298         require(targets.length == isApproved.length, 'Invalid Input length');
299         for (uint256 i = 0; i < targets.length; i++) {
300             approvedTargets[targets[i]] = isApproved[i];
301         }
302     }
303     
304     /// @dev This function transfers `governor` role.
305     function transferGovernance(address account) external {
306         require(msg.sender == governor, '!governor');
307         governor = account;
308     }
309 
310     /**
311      @notice This function is used to invest in given SushiSwap pair through ETH/ERC20 Tokens.
312      @param to Address to receive LP tokens.
313      @param _FromTokenContractAddress The ERC20 token used for investment (address(0x00) if ether).
314      @param _pairAddress The SushiSwap pair address.
315      @param _amount The amount of fromToken to invest.
316      @param _minPoolTokens Reverts if less tokens received than this.
317      @param _swapTarget Excecution target for the first swap.
318      @param swapData Dex quote data.
319      @return Amount of LP bought.
320      */
321     function zapIn(
322         address to,
323         address _FromTokenContractAddress,
324         address _pairAddress,
325         uint256 _amount,
326         uint256 _minPoolTokens,
327         address _swapTarget,
328         bytes calldata swapData
329     ) external payable returns (uint256) {
330         uint256 toInvest = _pullTokens(
331             _FromTokenContractAddress,
332             _amount
333         );
334         uint256 LPBought = _performZapIn(
335             _FromTokenContractAddress,
336             _pairAddress,
337             toInvest,
338             _swapTarget,
339             swapData
340         );
341         require(LPBought >= _minPoolTokens, 'ERR: High Slippage');
342         emit ZapIn(to, _pairAddress, LPBought);
343         IERC20(_pairAddress).safeTransfer(to, LPBought);
344         return LPBought;
345     }
346 
347     function _getPairTokens(address _pairAddress) private pure returns (address token0, address token1)
348     {
349         ISushiSwap sushiPair = ISushiSwap(_pairAddress);
350         token0 = sushiPair.token0();
351         token1 = sushiPair.token1();
352     }
353 
354     function _pullTokens(address token, uint256 amount) internal returns (uint256 value) {
355         if (token == address(0)) {
356             require(msg.value > 0, 'No eth sent');
357             return msg.value;
358         }
359         require(amount > 0, 'Invalid token amount');
360         require(msg.value == 0, 'Eth sent with token');
361         // transfer token
362         IERC20(token).safeTransferFrom(msg.sender, address(this), amount);
363         return amount;
364     }
365 
366     function _performZapIn(
367         address _FromTokenContractAddress,
368         address _pairAddress,
369         uint256 _amount,
370         address _swapTarget,
371         bytes memory swapData
372     ) internal returns (uint256) {
373         uint256 intermediateAmt;
374         address intermediateToken;
375         (
376             address _ToSushipoolToken0,
377             address _ToSushipoolToken1
378         ) = _getPairTokens(_pairAddress);
379         if (
380             _FromTokenContractAddress != _ToSushipoolToken0 &&
381             _FromTokenContractAddress != _ToSushipoolToken1
382         ) {
383             // swap to intermediate
384             (intermediateAmt, intermediateToken) = _fillQuote(
385                 _FromTokenContractAddress,
386                 _pairAddress,
387                 _amount,
388                 _swapTarget,
389                 swapData
390             );
391         } else {
392             intermediateToken = _FromTokenContractAddress;
393             intermediateAmt = _amount;
394         }
395         // divide intermediate into appropriate amount to add liquidity
396         (uint256 token0Bought, uint256 token1Bought) = _swapIntermediate(
397             intermediateToken,
398             _ToSushipoolToken0,
399             _ToSushipoolToken1,
400             intermediateAmt
401         );
402         return
403             _sushiDeposit(
404                 _ToSushipoolToken0,
405                 _ToSushipoolToken1,
406                 token0Bought,
407                 token1Bought
408             );
409     }
410 
411     function _sushiDeposit(
412         address _ToUnipoolToken0,
413         address _ToUnipoolToken1,
414         uint256 token0Bought,
415         uint256 token1Bought
416     ) private returns (uint256) {
417         IERC20(_ToUnipoolToken0).safeApprove(address(sushiSwapRouter), 0);
418         IERC20(_ToUnipoolToken1).safeApprove(address(sushiSwapRouter), 0);
419         IERC20(_ToUnipoolToken0).safeApprove(
420             address(sushiSwapRouter),
421             token0Bought
422         );
423         IERC20(_ToUnipoolToken1).safeApprove(
424             address(sushiSwapRouter),
425             token1Bought
426         );
427         (uint256 amountA, uint256 amountB, uint256 LP) = sushiSwapRouter
428             .addLiquidity(
429             _ToUnipoolToken0,
430             _ToUnipoolToken1,
431             token0Bought,
432             token1Bought,
433             1,
434             1,
435             address(this),
436             deadline
437         );
438             // returning residue in token0, if any
439             if (token0Bought.sub(amountA) > 0) {
440                 IERC20(_ToUnipoolToken0).safeTransfer(
441                     msg.sender,
442                     token0Bought.sub(amountA)
443                 );
444             }
445             // returning residue in token1, if any
446             if (token1Bought.sub(amountB) > 0) {
447                 IERC20(_ToUnipoolToken1).safeTransfer(
448                     msg.sender,
449                     token1Bought.sub(amountB)
450                 );
451             }
452         return LP;
453     }
454 
455     function _fillQuote(
456         address _fromTokenAddress,
457         address _pairAddress,
458         uint256 _amount,
459         address _swapTarget,
460         bytes memory swapCallData
461     ) private returns (uint256 amountBought, address intermediateToken) {
462         uint256 valueToSend;
463         if (_fromTokenAddress == address(0)) {
464             valueToSend = _amount;
465         } else {
466             IERC20 fromToken = IERC20(_fromTokenAddress);
467             fromToken.safeApprove(address(_swapTarget), 0);
468             fromToken.safeApprove(address(_swapTarget), _amount);
469         }
470         (address _token0, address _token1) = _getPairTokens(_pairAddress);
471         IERC20 token0 = IERC20(_token0);
472         IERC20 token1 = IERC20(_token1);
473         uint256 initialBalance0 = token0.safeBalanceOfSelf();
474         uint256 initialBalance1 = token1.safeBalanceOfSelf();
475         require(approvedTargets[_swapTarget], 'Target not Authorized');
476         (bool success, ) = _swapTarget.call{value: valueToSend}(swapCallData);
477         require(success, 'Error Swapping Tokens 1');
478         uint256 finalBalance0 = token0.safeBalanceOfSelf().sub(
479             initialBalance0
480         );
481         uint256 finalBalance1 = token1.safeBalanceOfSelf().sub(
482             initialBalance1
483         );
484         if (finalBalance0 > finalBalance1) {
485             amountBought = finalBalance0;
486             intermediateToken = _token0;
487         } else {
488             amountBought = finalBalance1;
489             intermediateToken = _token1;
490         }
491         require(amountBought > 0, 'Swapped to Invalid Intermediate');
492     }
493 
494     function _swapIntermediate(
495         address _toContractAddress,
496         address _ToSushipoolToken0,
497         address _ToSushipoolToken1,
498         uint256 _amount
499     ) private returns (uint256 token0Bought, uint256 token1Bought) {
500         (address token0, address token1) = _ToSushipoolToken0 < _ToSushipoolToken1 ? (_ToSushipoolToken0, _ToSushipoolToken1) : (_ToSushipoolToken1, _ToSushipoolToken0);
501         ISushiSwap pair =
502             ISushiSwap(
503                 uint256(
504                     keccak256(abi.encodePacked(hex"ff", sushiSwapFactory, keccak256(abi.encodePacked(token0, token1)), pairCodeHash))
505                 )
506             );
507         (uint256 res0, uint256 res1, ) = pair.getReserves();
508         if (_toContractAddress == _ToSushipoolToken0) {
509             uint256 amountToSwap = calculateSwapInAmount(res0, _amount);
510             // if no reserve or a new pair is created
511             if (amountToSwap <= 0) amountToSwap = _amount / 2;
512             token1Bought = _token2Token(
513                 _toContractAddress,
514                 _ToSushipoolToken1,
515                 amountToSwap
516             );
517             token0Bought = _amount.sub(amountToSwap);
518         } else {
519             uint256 amountToSwap = calculateSwapInAmount(res1, _amount);
520             // if no reserve or a new pair is created
521             if (amountToSwap <= 0) amountToSwap = _amount / 2;
522             token0Bought = _token2Token(
523                 _toContractAddress,
524                 _ToSushipoolToken0,
525                 amountToSwap
526             );
527             token1Bought = _amount.sub(amountToSwap);
528         }
529     }
530 
531     function calculateSwapInAmount(uint256 reserveIn, uint256 userIn) private pure returns (uint256)
532     {
533         return
534             Babylonian
535                 .sqrt(
536                 reserveIn.mul(userIn.mul(3988000) + reserveIn.mul(3988009))
537             )
538                 .sub(reserveIn.mul(1997)) / 1994;
539     }
540 
541     /**
542      @notice This function is used to swap ERC20 <> ERC20.
543      @param _FromTokenContractAddress The token address to swap from.
544      @param _ToTokenContractAddress The token address to swap to. 
545      @param tokens2Trade The amount of tokens to swap.
546      @return tokenBought The quantity of tokens bought.
547     */
548     function _token2Token(
549         address _FromTokenContractAddress,
550         address _ToTokenContractAddress,
551         uint256 tokens2Trade
552     ) private returns (uint256 tokenBought) {
553         if (_FromTokenContractAddress == _ToTokenContractAddress) {
554             return tokens2Trade;
555         }
556         IERC20(_FromTokenContractAddress).safeApprove(
557             address(sushiSwapRouter),
558             0
559         );
560         IERC20(_FromTokenContractAddress).safeApprove(
561             address(sushiSwapRouter),
562             tokens2Trade
563         );
564         (address token0, address token1) = _FromTokenContractAddress < _ToTokenContractAddress ? (_FromTokenContractAddress, _ToTokenContractAddress) : (_ToTokenContractAddress, _FromTokenContractAddress);
565         address pair =
566             address(
567                 uint256(
568                     keccak256(abi.encodePacked(hex"ff", sushiSwapFactory, keccak256(abi.encodePacked(token0, token1)), pairCodeHash))
569                 )
570             );
571         require(pair != address(0), 'No Swap Available');
572         address[] memory path = new address[](2);
573         path[0] = _FromTokenContractAddress;
574         path[1] = _ToTokenContractAddress;
575         tokenBought = sushiSwapRouter.swapExactTokensForTokens(
576             tokens2Trade,
577             1,
578             path,
579             address(this),
580             deadline
581         )[path.length - 1];
582         require(tokenBought > 0, 'Error Swapping Tokens 2');
583     }
584     
585     function zapOut(
586         address pair,
587         address to,
588         uint256 amount
589     ) external returns (uint256 amount0, uint256 amount1) {
590         IERC20(pair).safeTransferFrom(msg.sender, pair, amount); // pull `amount` to `pair`
591         (amount0, amount1) = ISushiSwap(pair).burn(to); // trigger burn to redeem liquidity for `to`
592     }
593     
594     function zapOutBalance(
595         address pair,
596         address to
597     ) external returns (uint256 amount0, uint256 amount1) {
598         IERC20(pair).safeTransfer(pair, IERC20(pair).safeBalanceOfSelf()); // transfer local balance to `pair`
599         (amount0, amount1) = ISushiSwap(pair).burn(to); // trigger burn to redeem liquidity for `to`
600     }
601 }
602 
603 /// @notice Interface for depositing into and withdrawing from Aave lending pool.
604 interface IAaveBridge {
605     function UNDERLYING_ASSET_ADDRESS() external view returns (address);
606 
607     function deposit( 
608         address asset, 
609         uint256 amount, 
610         address onBehalfOf, 
611         uint16 referralCode
612     ) external;
613 
614     function withdraw( 
615         address token, 
616         uint256 amount, 
617         address destination
618     ) external;
619 }
620 
621 /// @notice Interface for depositing into and withdrawing from BentoBox vault.
622 interface IBentoBridge {
623     function registerProtocol() external;
624     
625     function setMasterContractApproval(
626         address user,
627         address masterContract,
628         bool approved,
629         uint8 v,
630         bytes32 r,
631         bytes32 s
632     ) external;
633 
634     function deposit( 
635         IERC20 token_,
636         address from,
637         address to,
638         uint256 amount,
639         uint256 share
640     ) external payable returns (uint256 amountOut, uint256 shareOut);
641 
642     function withdraw(
643         IERC20 token_,
644         address from,
645         address to,
646         uint256 amount,
647         uint256 share
648     ) external returns (uint256 amountOut, uint256 shareOut);
649 }
650 
651 /// @notice Interface for depositing into and withdrawing from Compound finance protocol.
652 interface ICompoundBridge {
653     function underlying() external view returns (address);
654     function mint(uint mintAmount) external returns (uint);
655     function redeem(uint redeemTokens) external returns (uint);
656 }
657 
658 /// @notice Interface for depositing and withdrawing assets from KASHI.
659 interface IKashiBridge {
660     function asset() external returns (IERC20);
661     
662     function addAsset(
663         address to,
664         bool skim,
665         uint256 share
666     ) external returns (uint256 fraction);
667     
668     function removeAsset(address to, uint256 fraction) external returns (uint256 share);
669 }
670 
671 /// @notice Interface for depositing into and withdrawing from SushiBar.
672 interface ISushiBarBridge { 
673     function enter(uint256 amount) external;
674     function leave(uint256 share) external;
675 }
676 
677 /// @notice Interface for SUSHI MasterChef v2.
678 interface IMasterChefV2 {
679     function lpToken(uint256 pid) external view returns (IERC20);
680     function deposit(uint256 pid, uint256 amount, address to) external;
681 }
682 
683 /// @notice Contract that batches SUSHI staking and DeFi strategies - V1 'iroirona'.
684 contract InariV1 is BoringBatchableWithDai, SushiZap {
685     using SafeMath for uint256;
686     using BoringERC20 for IERC20;
687     
688     IERC20 constant sushiToken = IERC20(0x6B3595068778DD592e39A122f4f5a5cF09C90fE2); // SUSHI token contract
689     address constant sushiBar = 0x8798249c2E607446EfB7Ad49eC89dD1865Ff4272; // xSUSHI staking contract for SUSHI
690     ISushiSwap constant sushiSwapSushiETHPair = ISushiSwap(0x795065dCc9f64b5614C407a6EFDC400DA6221FB0); // SUSHI/ETH pair on SushiSwap
691     IMasterChefV2 constant masterChefv2 = IMasterChefV2(0xEF0881eC094552b2e128Cf945EF17a6752B4Ec5d); // SUSHI MasterChef v2 contract
692     IAaveBridge constant aave = IAaveBridge(0x7d2768dE32b0b80b7a3454c06BdAc94A69DDc7A9); // AAVE lending pool contract for xSUSHI staking into aXSUSHI
693     IERC20 constant aaveSushiToken = IERC20(0xF256CC7847E919FAc9B808cC216cAc87CCF2f47a); // aXSUSHI staking contract for xSUSHI
694     IBentoBridge constant bento = IBentoBridge(0xF5BCE5077908a1b7370B9ae04AdC565EBd643966); // BENTO vault contract
695     address constant crSushiToken = 0x338286C0BC081891A4Bda39C7667ae150bf5D206; // crSUSHI staking contract for SUSHI
696     address constant crXSushiToken = 0x228619CCa194Fbe3Ebeb2f835eC1eA5080DaFbb2; // crXSUSHI staking contract for xSUSHI
697     
698     /// @notice Initialize this Inari contract.
699     constructor() {
700         bento.registerProtocol(); // register this contract with BENTO
701     }
702     
703     /// @notice Helper function to approve this contract to spend tokens and enable strategies.
704     function bridgeToken(IERC20[] calldata token, address[] calldata to) external {
705         for (uint256 i = 0; i < token.length; i++) {
706             token[i].safeApprove(to[i], type(uint256).max); // max approve `to` spender to pull `token` from this contract
707         }
708     }
709 
710     /**********
711     TKN HELPERS 
712     **********/
713     function withdrawToken(IERC20 token, address to, uint256 amount) external {
714         token.safeTransfer(to, amount); 
715     }
716     
717     function withdrawTokenBalance(IERC20 token, address to) external {
718         token.safeTransfer(to, token.safeBalanceOfSelf()); 
719     }
720 
721     /***********
722     CHEF HELPERS 
723     ***********/
724     function depositToMasterChefv2(uint256 pid, uint256 amount, address to) external {
725         masterChefv2.deposit(pid, amount, to);
726     }
727     
728     function balanceToMasterChefv2(uint256 pid, address to) external {
729         IERC20 lpToken = masterChefv2.lpToken(pid);
730         masterChefv2.deposit(pid, lpToken.safeBalanceOfSelf(), to);
731     }
732     
733     /// @notice Liquidity zap into CHEF.
734     function zapToMasterChef(
735         address to,
736         address _FromTokenContractAddress,
737         uint256 _amount,
738         uint256 _minPoolTokens,
739         uint256 pid,
740         address _swapTarget,
741         bytes calldata swapData
742     ) external payable returns (uint256 LPBought) {
743         uint256 toInvest = _pullTokens(
744             _FromTokenContractAddress,
745             _amount
746         );
747         IERC20 _pairAddress = masterChefv2.lpToken(pid);
748         LPBought = _performZapIn(
749             _FromTokenContractAddress,
750             address(_pairAddress),
751             toInvest,
752             _swapTarget,
753             swapData
754         );
755         require(LPBought >= _minPoolTokens, "ERR: High Slippage");
756         emit ZapIn(to, address(_pairAddress), LPBought);
757         masterChefv2.deposit(pid, LPBought, to);
758     }
759     
760     /************
761     KASHI HELPERS 
762     ************/
763     function assetToKashi(IKashiBridge kashiPair, address to, uint256 amount) external returns (uint256 fraction) {
764         IERC20 asset = kashiPair.asset();
765         asset.safeTransferFrom(msg.sender, address(bento), amount);
766         IBentoBridge(bento).deposit(asset, address(bento), address(kashiPair), amount, 0); 
767         fraction = kashiPair.addAsset(to, true, amount);
768     }
769     
770     function assetToKashiChef(uint256 pid, uint256 amount, address to) external returns (uint256 fraction) {
771         address kashiPair = address(masterChefv2.lpToken(pid));
772         IERC20 asset = IKashiBridge(kashiPair).asset();
773         asset.safeTransferFrom(msg.sender, address(bento), amount);
774         IBentoBridge(bento).deposit(asset, address(bento), address(kashiPair), amount, 0); 
775         fraction = IKashiBridge(kashiPair).addAsset(address(this), true, amount);
776         masterChefv2.deposit(pid, fraction, to);
777     }
778     
779     function assetBalanceToKashi(IKashiBridge kashiPair, address to) external returns (uint256 fraction) {
780         IERC20 asset = kashiPair.asset();
781         uint256 balance = asset.safeBalanceOfSelf();
782         IBentoBridge(bento).deposit(asset, address(bento), address(kashiPair), balance, 0); 
783         fraction = kashiPair.addAsset(to, true, balance);
784     }
785     
786     function assetBalanceToKashiChef(uint256 pid, address to) external returns (uint256 fraction) {
787         address kashiPair = address(masterChefv2.lpToken(pid));
788         IERC20 asset = IKashiBridge(kashiPair).asset();
789         uint256 balance = asset.safeBalanceOfSelf();
790         IBentoBridge(bento).deposit(asset, address(bento), address(kashiPair), balance, 0); 
791         fraction = IKashiBridge(kashiPair).addAsset(address(this), true, balance);
792         masterChefv2.deposit(pid, fraction, to);
793     }
794 
795     function assetBalanceFromKashi(address kashiPair, address to) external returns (uint256 share) {
796         share = IKashiBridge(kashiPair).removeAsset(to, IERC20(kashiPair).safeBalanceOfSelf());
797     }
798     
799     /// @notice Liquidity zap into KASHI.
800     function zapToKashi(
801         address to,
802         address _FromTokenContractAddress,
803         IKashiBridge kashiPair,
804         uint256 _amount,
805         uint256 _minPoolTokens,
806         address _swapTarget,
807         bytes calldata swapData
808     ) external payable returns (uint256 fraction) {
809         uint256 toInvest = _pullTokens(
810             _FromTokenContractAddress,
811             _amount
812         );
813         IERC20 _pairAddress = kashiPair.asset();
814         uint256 LPBought = _performZapIn(
815             _FromTokenContractAddress,
816             address(_pairAddress),
817             toInvest,
818             _swapTarget,
819             swapData
820         );
821         require(LPBought >= _minPoolTokens, "ERR: High Slippage");
822         emit ZapIn(to, address(_pairAddress), LPBought);
823         _pairAddress.safeTransfer(address(bento), LPBought);
824         IBentoBridge(bento).deposit(_pairAddress, address(bento), address(kashiPair), LPBought, 0); 
825         fraction = kashiPair.addAsset(to, true, LPBought);
826     }
827 /*
828 ██   ██       ▄   ▄███▄   
829 █ █  █ █       █  █▀   ▀  
830 █▄▄█ █▄▄█ █     █ ██▄▄    
831 █  █ █  █  █    █ █▄   ▄▀ 
832    █    █   █  █  ▀███▀   
833   █    █     █▐           
834  ▀    ▀      ▐         */
835     
836     /***********
837     AAVE HELPERS 
838     ***********/
839     function balanceToAave(address underlying, address to) external {
840         aave.deposit(underlying, IERC20(underlying).safeBalanceOfSelf(), to, 0); 
841     }
842 
843     function balanceFromAave(address aToken, address to) external {
844         address underlying = IAaveBridge(aToken).UNDERLYING_ASSET_ADDRESS(); // sanity check for `underlying` token
845         aave.withdraw(underlying, IERC20(aToken).safeBalanceOfSelf(), to); 
846     }
847     
848     /**************************
849     AAVE -> UNDERLYING -> BENTO 
850     **************************/
851     /// @notice Migrate AAVE `aToken` underlying `amount` into BENTO for benefit of `to` by batching calls to `aave` and `bento`.
852     function aaveToBento(address aToken, address to, uint256 amount) external returns (uint256 amountOut, uint256 shareOut) {
853         IERC20(aToken).safeTransferFrom(msg.sender, address(this), amount); // deposit `msg.sender` `aToken` `amount` into this contract
854         address underlying = IAaveBridge(aToken).UNDERLYING_ASSET_ADDRESS(); // sanity check for `underlying` token
855         aave.withdraw(underlying, amount, address(bento)); // burn deposited `aToken` from `aave` into `underlying`
856         (amountOut, shareOut) = bento.deposit(IERC20(underlying), address(bento), to, amount, 0); // stake `underlying` into BENTO for `to`
857     }
858 
859     /**************************
860     BENTO -> UNDERLYING -> AAVE 
861     **************************/
862     /// @notice Migrate `underlying` `amount` from BENTO into AAVE for benefit of `to` by batching calls to `bento` and `aave`.
863     function bentoToAave(IERC20 underlying, address to, uint256 amount) external {
864         bento.withdraw(underlying, msg.sender, address(this), amount, 0); // withdraw `amount` of `underlying` from BENTO into this contract
865         aave.deposit(address(underlying), amount, to, 0); // stake `underlying` into `aave` for `to`
866     }
867     
868     /*************************
869     AAVE -> UNDERLYING -> COMP 
870     *************************/
871     /// @notice Migrate AAVE `aToken` underlying `amount` into COMP/CREAM `cToken` for benefit of `to` by batching calls to `aave` and `cToken`.
872     function aaveToCompound(address aToken, address cToken, address to, uint256 amount) external {
873         IERC20(aToken).safeTransferFrom(msg.sender, address(this), amount); // deposit `msg.sender` `aToken` `amount` into this contract
874         address underlying = IAaveBridge(aToken).UNDERLYING_ASSET_ADDRESS(); // sanity check for `underlying` token
875         aave.withdraw(underlying, amount, address(this)); // burn deposited `aToken` from `aave` into `underlying`
876         ICompoundBridge(cToken).mint(amount); // stake `underlying` into `cToken`
877         IERC20(cToken).safeTransfer(to, IERC20(cToken).safeBalanceOfSelf()); // transfer resulting `cToken` to `to`
878     }
879     
880     /*************************
881     COMP -> UNDERLYING -> AAVE 
882     *************************/
883     /// @notice Migrate COMP/CREAM `cToken` underlying `amount` into AAVE for benefit of `to` by batching calls to `cToken` and `aave`.
884     function compoundToAave(address cToken, address to, uint256 amount) external {
885         IERC20(cToken).safeTransferFrom(msg.sender, address(this), amount); // deposit `msg.sender` `cToken` `amount` into this contract
886         ICompoundBridge(cToken).redeem(amount); // burn deposited `cToken` into `underlying`
887         address underlying = ICompoundBridge(cToken).underlying(); // sanity check for `underlying` token
888         aave.deposit(underlying, IERC20(underlying).safeBalanceOfSelf(), to, 0); // stake resulting `underlying` into `aave` for `to`
889     }
890     
891     /**********************
892     SUSHI -> XSUSHI -> AAVE 
893     **********************/
894     /// @notice Stake SUSHI `amount` into aXSUSHI for benefit of `to` by batching calls to `sushiBar` and `aave`.
895     function stakeSushiToAave(address to, uint256 amount) external { // SAAVE
896         sushiToken.safeTransferFrom(msg.sender, address(this), amount); // deposit `msg.sender` SUSHI `amount` into this contract
897         ISushiBarBridge(sushiBar).enter(amount); // stake deposited SUSHI into `sushiBar` xSUSHI
898         aave.deposit(sushiBar, IERC20(sushiBar).safeBalanceOfSelf(), to, 0); // stake resulting xSUSHI into `aave` aXSUSHI for `to`
899     }
900     
901     /**********************
902     AAVE -> XSUSHI -> SUSHI 
903     **********************/
904     /// @notice Unstake aXSUSHI `amount` into SUSHI for benefit of `to` by batching calls to `aave` and `sushiBar`.
905     function unstakeSushiFromAave(address to, uint256 amount) external {
906         aaveSushiToken.safeTransferFrom(msg.sender, address(this), amount); // deposit `msg.sender` aXSUSHI `amount` into this contract
907         aave.withdraw(sushiBar, amount, address(this)); // burn deposited aXSUSHI from `aave` into xSUSHI
908         ISushiBarBridge(sushiBar).leave(amount); // burn resulting xSUSHI from `sushiBar` into SUSHI
909         sushiToken.safeTransfer(to, sushiToken.safeBalanceOfSelf()); // transfer resulting SUSHI to `to`
910     }
911 /*
912 ███   ▄███▄      ▄     ▄▄▄▄▀ ████▄ 
913 █  █  █▀   ▀      █ ▀▀▀ █    █   █ 
914 █ ▀ ▄ ██▄▄    ██   █    █    █   █ 
915 █  ▄▀ █▄   ▄▀ █ █  █   █     ▀████ 
916 ███   ▀███▀   █  █ █  ▀            
917               █   ██            */ 
918     /************
919     BENTO HELPERS 
920     ************/
921     function balanceToBento(IERC20 token, address to) external returns (uint256 amountOut, uint256 shareOut) {
922         (amountOut, shareOut) = bento.deposit(token, address(this), to, token.safeBalanceOfSelf(), 0); 
923     }
924     
925     /// @dev Included to be able to approve `bento` in the same transaction (using `batch()`).
926     function setBentoApproval(
927         address user,
928         address masterContract,
929         bool approved,
930         uint8 v,
931         bytes32 r,
932         bytes32 s
933     ) external {
934         bento.setMasterContractApproval(user, masterContract, approved, v, r, s);
935     }
936     
937     /// @notice Liquidity zap into BENTO.
938     function zapToBento(
939         address to,
940         address _FromTokenContractAddress,
941         address _pairAddress,
942         uint256 _amount,
943         uint256 _minPoolTokens,
944         address _swapTarget,
945         bytes calldata swapData
946     ) external payable returns (uint256 LPBought) {
947         uint256 toInvest = _pullTokens(
948             _FromTokenContractAddress,
949             _amount
950         );
951         LPBought = _performZapIn(
952             _FromTokenContractAddress,
953             _pairAddress,
954             toInvest,
955             _swapTarget,
956             swapData
957         );
958         require(LPBought >= _minPoolTokens, "ERR: High Slippage");
959         emit ZapIn(to, _pairAddress, LPBought);
960         bento.deposit(IERC20(_pairAddress), address(this), to, LPBought, 0); 
961     }
962 
963     /// @notice Liquidity unzap from BENTO.
964     function zapFromBento(
965         address pair,
966         address to,
967         uint256 amount
968     ) external returns (uint256 amount0, uint256 amount1) {
969         bento.withdraw(IERC20(pair), msg.sender, pair, amount, 0); // withdraw `amount` to `pair` from BENTO
970         (amount0, amount1) = ISushiSwap(pair).burn(to); // trigger burn to redeem liquidity for `to`
971     }
972 
973     /***********************
974     SUSHI -> XSUSHI -> BENTO 
975     ***********************/
976     /// @notice Stake SUSHI `amount` into BENTO xSUSHI for benefit of `to` by batching calls to `sushiBar` and `bento`.
977     function stakeSushiToBento(address to, uint256 amount) external returns (uint256 amountOut, uint256 shareOut) {
978         sushiToken.safeTransferFrom(msg.sender, address(this), amount); // deposit `msg.sender` SUSHI `amount` into this contract
979         ISushiBarBridge(sushiBar).enter(amount); // stake deposited SUSHI into `sushiBar` xSUSHI
980         (amountOut, shareOut) = bento.deposit(IERC20(sushiBar), address(this), to, IERC20(sushiBar).safeBalanceOfSelf(), 0); // stake resulting xSUSHI into BENTO for `to`
981     }
982     
983     /***********************
984     BENTO -> XSUSHI -> SUSHI 
985     ***********************/
986     /// @notice Unstake xSUSHI `amount` from BENTO into SUSHI for benefit of `to` by batching calls to `bento` and `sushiBar`.
987     function unstakeSushiFromBento(address to, uint256 amount) external {
988         bento.withdraw(IERC20(sushiBar), msg.sender, address(this), amount, 0); // withdraw `amount` of xSUSHI from BENTO into this contract
989         ISushiBarBridge(sushiBar).leave(amount); // burn withdrawn xSUSHI from `sushiBar` into SUSHI
990         sushiToken.safeTransfer(to, sushiToken.safeBalanceOfSelf()); // transfer resulting SUSHI to `to`
991     }
992 /*    
993 ▄█▄    █▄▄▄▄ ▄███▄   ██   █▀▄▀█ 
994 █▀ ▀▄  █  ▄▀ █▀   ▀  █ █  █ █ █ 
995 █   ▀  █▀▀▌  ██▄▄    █▄▄█ █ ▄ █ 
996 █▄  ▄▀ █  █  █▄   ▄▀ █  █ █   █ 
997 ▀███▀    █   ▀███▀      █    █  
998         ▀              █    ▀  
999                       ▀      */
1000 // - COMPOUND - //
1001     /***********
1002     COMP HELPERS 
1003     ***********/
1004     function balanceToCompound(ICompoundBridge cToken) external {
1005         IERC20 underlying = IERC20(ICompoundBridge(cToken).underlying()); // sanity check for `underlying` token
1006         cToken.mint(underlying.safeBalanceOfSelf());
1007     }
1008 
1009     function balanceFromCompound(address cToken) external {
1010         ICompoundBridge(cToken).redeem(IERC20(cToken).safeBalanceOfSelf());
1011     }
1012     
1013     /**************************
1014     COMP -> UNDERLYING -> BENTO 
1015     **************************/
1016     /// @notice Migrate COMP/CREAM `cToken` `cTokenAmount` into underlying and BENTO for benefit of `to` by batching calls to `cToken` and `bento`.
1017     function compoundToBento(address cToken, address to, uint256 cTokenAmount) external returns (uint256 amountOut, uint256 shareOut) {
1018         IERC20(cToken).safeTransferFrom(msg.sender, address(this), cTokenAmount); // deposit `msg.sender` `cToken` `cTokenAmount` into this contract
1019         ICompoundBridge(cToken).redeem(cTokenAmount); // burn deposited `cToken` into `underlying`
1020         IERC20 underlying = IERC20(ICompoundBridge(cToken).underlying()); // sanity check for `underlying` token
1021         (amountOut, shareOut) = bento.deposit(underlying, address(this), to, underlying.safeBalanceOfSelf(), 0); // stake resulting `underlying` into BENTO for `to`
1022     }
1023     
1024     /**************************
1025     BENTO -> UNDERLYING -> COMP 
1026     **************************/
1027     /// @notice Migrate `cToken` `underlyingAmount` from BENTO into COMP/CREAM for benefit of `to` by batching calls to `bento` and `cToken`.
1028     function bentoToCompound(address cToken, address to, uint256 underlyingAmount) external {
1029         IERC20 underlying = IERC20(ICompoundBridge(cToken).underlying()); // sanity check for `underlying` token
1030         bento.withdraw(underlying, msg.sender, address(this), underlyingAmount, 0); // withdraw `underlyingAmount` of `underlying` from BENTO into this contract
1031         ICompoundBridge(cToken).mint(underlyingAmount); // stake `underlying` into `cToken`
1032         IERC20(cToken).safeTransfer(to, IERC20(cToken).safeBalanceOfSelf()); // transfer resulting `cToken` to `to`
1033     }
1034     
1035     /**********************
1036     SUSHI -> CREAM -> BENTO 
1037     **********************/
1038     /// @notice Stake SUSHI `amount` into crSUSHI and BENTO for benefit of `to` by batching calls to `crSushiToken` and `bento`.
1039     function sushiToCreamToBento(address to, uint256 amount) external returns (uint256 amountOut, uint256 shareOut) {
1040         sushiToken.safeTransferFrom(msg.sender, address(this), amount); // deposit `msg.sender` SUSHI `amount` into this contract
1041         ICompoundBridge(crSushiToken).mint(amount); // stake deposited SUSHI into crSUSHI
1042         (amountOut, shareOut) = bento.deposit(IERC20(crSushiToken), address(this), to, IERC20(crSushiToken).safeBalanceOfSelf(), 0); // stake resulting crSUSHI into BENTO for `to`
1043     }
1044     
1045     /**********************
1046     BENTO -> CREAM -> SUSHI 
1047     **********************/
1048     /// @notice Unstake crSUSHI `cTokenAmount` into SUSHI from BENTO for benefit of `to` by batching calls to `bento` and `crSushiToken`.
1049     function sushiFromCreamFromBento(address to, uint256 cTokenAmount) external {
1050         bento.withdraw(IERC20(crSushiToken), msg.sender, address(this), cTokenAmount, 0); // withdraw `cTokenAmount` of `crSushiToken` from BENTO into this contract
1051         ICompoundBridge(crSushiToken).redeem(cTokenAmount); // burn deposited `crSushiToken` into SUSHI
1052         sushiToken.safeTransfer(to, sushiToken.safeBalanceOfSelf()); // transfer resulting SUSHI to `to`
1053     }
1054     
1055     /***********************
1056     SUSHI -> XSUSHI -> CREAM 
1057     ***********************/
1058     /// @notice Stake SUSHI `amount` into crXSUSHI for benefit of `to` by batching calls to `sushiBar` and `crXSushiToken`.
1059     function stakeSushiToCream(address to, uint256 amount) external { // SCREAM
1060         sushiToken.safeTransferFrom(msg.sender, address(this), amount); // deposit `msg.sender` SUSHI `amount` into this contract
1061         ISushiBarBridge(sushiBar).enter(amount); // stake deposited SUSHI `amount` into `sushiBar` xSUSHI
1062         ICompoundBridge(crXSushiToken).mint(IERC20(sushiBar).safeBalanceOfSelf()); // stake resulting xSUSHI into crXSUSHI
1063         IERC20(crXSushiToken).safeTransfer(to, IERC20(crXSushiToken).safeBalanceOfSelf()); // transfer resulting crXSUSHI to `to`
1064     }
1065     
1066     /***********************
1067     CREAM -> XSUSHI -> SUSHI 
1068     ***********************/
1069     /// @notice Unstake crXSUSHI `cTokenAmount` into SUSHI for benefit of `to` by batching calls to `crXSushiToken` and `sushiBar`.
1070     function unstakeSushiFromCream(address to, uint256 cTokenAmount) external {
1071         IERC20(crXSushiToken).safeTransferFrom(msg.sender, address(this), cTokenAmount); // deposit `msg.sender` `crXSushiToken` `cTokenAmount` into this contract
1072         ICompoundBridge(crXSushiToken).redeem(cTokenAmount); // burn deposited `crXSushiToken` `cTokenAmount` into xSUSHI
1073         ISushiBarBridge(sushiBar).leave(IERC20(sushiBar).safeBalanceOfSelf()); // burn resulting xSUSHI `amount` from `sushiBar` into SUSHI
1074         sushiToken.safeTransfer(to, sushiToken.safeBalanceOfSelf()); // transfer resulting SUSHI to `to`
1075     }
1076     
1077     /********************************
1078     SUSHI -> XSUSHI -> CREAM -> BENTO 
1079     ********************************/
1080     /// @notice Stake SUSHI `amount` into crXSUSHI and BENTO for benefit of `to` by batching calls to `sushiBar`, `crXSushiToken` and `bento`.
1081     function stakeSushiToCreamToBento(address to, uint256 amount) external returns (uint256 amountOut, uint256 shareOut) {
1082         sushiToken.safeTransferFrom(msg.sender, address(this), amount); // deposit `msg.sender` SUSHI `amount` into this contract
1083         ISushiBarBridge(sushiBar).enter(amount); // stake deposited SUSHI `amount` into `sushiBar` xSUSHI
1084         ICompoundBridge(crXSushiToken).mint(IERC20(sushiBar).safeBalanceOfSelf()); // stake resulting xSUSHI into crXSUSHI
1085         (amountOut, shareOut) = bento.deposit(IERC20(crXSushiToken), address(this), to, IERC20(crXSushiToken).safeBalanceOfSelf(), 0); // stake resulting crXSUSHI into BENTO for `to`
1086     }
1087     
1088     /********************************
1089     BENTO -> CREAM -> XSUSHI -> SUSHI 
1090     ********************************/
1091     /// @notice Unstake crXSUSHI `cTokenAmount` into SUSHI from BENTO for benefit of `to` by batching calls to `bento`, `crXSushiToken` and `sushiBar`.
1092     function unstakeSushiFromCreamFromBento(address to, uint256 cTokenAmount) external {
1093         bento.withdraw(IERC20(crXSushiToken), msg.sender, address(this), cTokenAmount, 0); // withdraw `cTokenAmount` of `crXSushiToken` from BENTO into this contract
1094         ICompoundBridge(crXSushiToken).redeem(cTokenAmount); // burn deposited `crXSushiToken` `cTokenAmount` into xSUSHI
1095         ISushiBarBridge(sushiBar).leave(IERC20(sushiBar).safeBalanceOfSelf()); // burn resulting xSUSHI from `sushiBar` into SUSHI
1096         sushiToken.safeTransfer(to, sushiToken.safeBalanceOfSelf()); // transfer resulting SUSHI to `to`
1097     }
1098 /*
1099    ▄▄▄▄▄    ▄ ▄   ██   █ ▄▄      
1100   █     ▀▄ █   █  █ █  █   █     
1101 ▄  ▀▀▀▀▄  █ ▄   █ █▄▄█ █▀▀▀      
1102  ▀▄▄▄▄▀   █  █  █ █  █ █         
1103            █ █ █     █  █        
1104             ▀ ▀     █    ▀       
1105                    ▀     */
1106     /// @notice Fallback for received ETH - SushiSwap ETH to stake SUSHI into xSUSHI and BENTO for benefit of `to`.
1107     receive() external payable { // INARIZUSHI
1108         (uint256 reserve0, uint256 reserve1, ) = sushiSwapSushiETHPair.getReserves();
1109         uint256 amountInWithFee = msg.value.mul(997);
1110         uint256 out =
1111             amountInWithFee.mul(reserve0) /
1112             reserve1.mul(1000).add(amountInWithFee);
1113         IWETH(wETH).deposit{value: msg.value}();
1114         IERC20(wETH).safeTransfer(address(sushiSwapSushiETHPair), msg.value);
1115         sushiSwapSushiETHPair.swap(out, 0, address(this), "");
1116         ISushiBarBridge(sushiBar).enter(sushiToken.safeBalanceOfSelf()); // stake resulting SUSHI into `sushiBar` xSUSHI
1117         bento.deposit(IERC20(sushiBar), address(this), msg.sender, IERC20(sushiBar).safeBalanceOfSelf(), 0); // stake resulting xSUSHI into BENTO for `to`
1118     }
1119     
1120     /// @notice SushiSwap ETH to stake SUSHI into xSUSHI and BENTO for benefit of `to`. 
1121     function inariZushi(address to) external payable returns (uint256 amountOut, uint256 shareOut) {
1122         (uint256 reserve0, uint256 reserve1, ) = sushiSwapSushiETHPair.getReserves();
1123         uint256 amountInWithFee = msg.value.mul(997);
1124         uint256 out =
1125             amountInWithFee.mul(reserve0) /
1126             reserve1.mul(1000).add(amountInWithFee);
1127         IWETH(wETH).deposit{value: msg.value}();
1128         IERC20(wETH).safeTransfer(address(sushiSwapSushiETHPair), msg.value);
1129         sushiSwapSushiETHPair.swap(out, 0, address(this), "");
1130         ISushiBarBridge(sushiBar).enter(sushiToken.safeBalanceOfSelf()); // stake resulting SUSHI into `sushiBar` xSUSHI
1131         (amountOut, shareOut) = bento.deposit(IERC20(sushiBar), address(this), to, IERC20(sushiBar).safeBalanceOfSelf(), 0); // stake resulting xSUSHI into BENTO for `to`
1132     }
1133     
1134     /// @notice Simple SushiSwap `fromToken` `amountIn` to `toToken` for benefit of `to`.
1135     function swap(address fromToken, address toToken, address to, uint256 amountIn) external returns (uint256 amountOut) {
1136         (address token0, address token1) = fromToken < toToken ? (fromToken, toToken) : (toToken, fromToken);
1137         ISushiSwap pair =
1138             ISushiSwap(
1139                 uint256(
1140                     keccak256(abi.encodePacked(hex"ff", sushiSwapFactory, keccak256(abi.encodePacked(token0, token1)), pairCodeHash))
1141                 )
1142             );
1143         (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
1144         uint256 amountInWithFee = amountIn.mul(997);
1145         IERC20(fromToken).safeTransferFrom(msg.sender, address(pair), amountIn);
1146         if (toToken > fromToken) {
1147             amountOut =
1148                 amountInWithFee.mul(reserve1) /
1149                 reserve0.mul(1000).add(amountInWithFee);
1150             pair.swap(0, amountOut, to, "");
1151         } else {
1152             amountOut =
1153                 amountInWithFee.mul(reserve0) /
1154                 reserve1.mul(1000).add(amountInWithFee);
1155             pair.swap(amountOut, 0, to, "");
1156         }
1157     }
1158 
1159     /// @notice Simple SushiSwap local `fromToken` balance in this contract to `toToken` for benefit of `to`.
1160     function swapBalance(address fromToken, address toToken, address to) external returns (uint256 amountOut) {
1161         (address token0, address token1) = fromToken < toToken ? (fromToken, toToken) : (toToken, fromToken);
1162         ISushiSwap pair =
1163             ISushiSwap(
1164                 uint256(
1165                     keccak256(abi.encodePacked(hex"ff", sushiSwapFactory, keccak256(abi.encodePacked(token0, token1)), pairCodeHash))
1166                 )
1167             );
1168         uint256 amountIn = IERC20(fromToken).safeBalanceOfSelf();
1169         (uint256 reserve0, uint256 reserve1, ) = pair.getReserves();
1170         uint256 amountInWithFee = amountIn.mul(997);
1171         IERC20(fromToken).safeTransfer(address(pair), amountIn);
1172         if (toToken > fromToken) {
1173             amountOut =
1174                 amountInWithFee.mul(reserve1) /
1175                 reserve0.mul(1000).add(amountInWithFee);
1176             pair.swap(0, amountOut, to, "");
1177         } else {
1178             amountOut =
1179                 amountInWithFee.mul(reserve0) /
1180                 reserve1.mul(1000).add(amountInWithFee);
1181             pair.swap(amountOut, 0, to, "");
1182         }
1183     }
1184 }