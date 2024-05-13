1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.8.17;
3 
4 // ███████╗░█████╗░██████╗░████████╗██████╗░███████╗░██████╗░██████╗
5 // ██╔════╝██╔══██╗██╔══██╗╚══██╔══╝██╔══██╗██╔════╝██╔════╝██╔════╝
6 // █████╗░░██║░░██║██████╔╝░░░██║░░░██████╔╝█████╗░░╚█████╗░╚█████╗░
7 // ██╔══╝░░██║░░██║██╔══██╗░░░██║░░░██╔══██╗██╔══╝░░░╚═══██╗░╚═══██╗
8 // ██║░░░░░╚█████╔╝██║░░██║░░░██║░░░██║░░██║███████╗██████╔╝██████╔╝
9 // ╚═╝░░░░░░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
10 // ███████╗██╗███╗░░██╗░█████╗░███╗░░██╗░█████╗░███████╗
11 // ██╔════╝██║████╗░██║██╔══██╗████╗░██║██╔══██╗██╔════╝
12 // █████╗░░██║██╔██╗██║███████║██╔██╗██║██║░░╚═╝█████╗░░
13 // ██╔══╝░░██║██║╚████║██╔══██║██║╚████║██║░░██╗██╔══╝░░
14 // ██║░░░░░██║██║░╚███║██║░░██║██║░╚███║╚█████╔╝███████╗
15 // ╚═╝░░░░░╚═╝╚═╝░░╚══╝╚═╝░░╚═╝╚═╝░░╚══╝░╚════╝░╚══════╝
16 
17 //  _____         _                   _____               
18 // |   __|___ ___| |_ ___ ___ ___ ___|   __|_ _ _ ___ ___ 
19 // |   __| . |  _|  _|  _| -_|_ -|_ -|__   | | | | .'| . |
20 // |__|  |___|_| |_| |_| |___|___|___|_____|_____|__,|  _|
21 //                                                   |_|  
22 
23 // Github - https://github.com/FortressFinance
24 
25 import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
26 import "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
27 import "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
28 import "lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol";
29 
30 import "src/shared/fortress-interfaces/IFortressSwap.sol";
31 
32 import "src/shared/interfaces/IWETH.sol";
33 import "src/shared/interfaces/ICurvePool.sol";
34 import "src/shared/interfaces/ICurveCryptoETHV2Pool.sol";
35 import "src/shared/interfaces/ICurveSBTCPool.sol";
36 import "src/shared/interfaces/ICurveCryptoV2Pool.sol";
37 import "src/shared/interfaces/ICurve3Pool.sol";
38 import "src/shared/interfaces/ICurvesUSD4Pool.sol";
39 import "src/shared/interfaces/ICurveBase3Pool.sol";
40 import "src/shared/interfaces/ICurvePlainPool.sol";
41 import "src/shared/interfaces/ICurveCRVMeta.sol";
42 import "src/shared/interfaces/ICurveFraxMeta.sol";
43 import "src/shared/interfaces/ICurveFraxCryptoMeta.sol";
44 import "src/shared/interfaces/IUniswapV3Router.sol";
45 import "src/shared/interfaces/IUniswapV3Pool.sol";
46 import "src/shared/interfaces/IUniswapV2Router.sol";
47 import "src/shared/interfaces/IBalancerVault.sol";
48 import "src/shared/interfaces/IBalancerPool.sol";
49 
50 contract FortressSwap is ReentrancyGuard, IFortressSwap {
51 
52     using SafeERC20 for IERC20;
53     using SafeCast for int256;
54 
55     /// @notice The address of WETH token.
56     address private constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
57     /// @notice The address representing native ETH.
58     address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
59     /// @notice The address of Uniswap V3 Router.
60     address private constant UNIV3_ROUTER = 0xE592427A0AEce92De3Edee1F18E0157C05861564;
61     /// @notice The address of Fraxswap Uniswap V2 Router (https://docs.frax.finance/smart-contracts/fraxswap#ethereum).
62     address private constant FRAXSWAP_UNIV2_ROUTER = 0x1C6cA5DEe97C8C368Ca559892CCce2454c8C35C7;
63     /// @notice The address of Curve Base Pool (https://curve.fi/3pool).
64     address private constant CURVE_BP = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;
65     /// @notice The address of Curve Frax Base Pool (https://curve.fi/fraxusdc).
66     address private constant FRAX_BP = 0xDcEF968d416a41Cdac0ED8702fAC8128A64241A2;
67     /// @notice The address of Curve Frax Base Pool LP tokens (https://etherscan.io/address/0x3175Df0976dFA876431C2E9eE6Bc45b65d3473CC).
68     address constant crvFRAX = 0x3175Df0976dFA876431C2E9eE6Bc45b65d3473CC;
69     /// @notice The address of Balancer vault.
70     address constant BALANCER_VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
71 
72     struct Route {
73         // pool type -->
74         // 0: UniswapV3
75         // 1: Fraxswap
76         // 2: Curve2AssetPool
77         // 3: _swapCurveCryptoV2
78         // 4: Curve3AssetPool
79         // 5: CurveETHV2Pool
80         // 6: CurveCRVMeta
81         // 7: CurveFraxMeta
82         // 8: CurveBase3Pool
83         // 9: CurveSBTCPool
84         // 10: Curve4Pool
85         // 11: FraxCryptoMeta
86         // 12: BalancerSingleSwap
87         /// @notice The internal pool type.
88         uint256[] poolType;
89         /// @notice The pool addresses.
90         address[] poolAddress;
91         /// @notice The addresses of the token to swap from.
92         address[] tokenIn;
93         /// @notice The addresses of the token to swap to.
94         address[] tokenOut;
95     }
96 
97     /// @notice The swap routes.
98     mapping(address => mapping(address => Route)) private routes;
99     
100     /// @notice The address of the owner.
101     address public owner;
102 
103     /********************************** View Functions **********************************/
104 
105     /// @dev Check if a certain swap route is available.
106     /// @param _fromToken - The address of the input token.
107     /// @param _toToken - The address of the output token.
108     /// @return - Whether the route exist.
109     function routeExists(address _fromToken, address _toToken) external view returns (bool) {
110         return routes[_fromToken][_toToken].poolAddress.length > 0;
111     }
112 
113     /********************************** Constructor **********************************/
114 
115     constructor(address _owner) {
116         if (_owner == address(0)) revert ZeroInput();
117          
118         owner = _owner;
119     }
120 
121     /********************************** Mutated Functions **********************************/
122 
123     /// @dev Swap from one token to another.
124     /// @param _fromToken - The address of the input token.
125     /// @param _toToken - The address of the output token.
126     /// @param _amount - The amount of input token.
127     /// @return - The amount of output token.
128     function swap(address _fromToken, address _toToken, uint256 _amount) external payable nonReentrant returns (uint256) {
129         Route storage _route = routes[_fromToken][_toToken];
130         if (_route.poolAddress.length == 0) revert RouteUnavailable();
131         
132         if (msg.value > 0) {
133             if (msg.value != _amount) revert AmountMismatch();
134             if (_fromToken != ETH) revert TokenMismatch();
135         } else {
136             if (_fromToken == ETH) revert TokenMismatch();
137             IERC20(_fromToken).safeTransferFrom(msg.sender, address(this), _amount);
138         }
139         
140         uint256 _poolType;
141         address _poolAddress;
142         address _tokenIn;
143         address _tokenOut;
144         for(uint256 i = 0; i < _route.poolAddress.length; i++) {
145             _poolType = _route.poolType[i];
146             _poolAddress = _route.poolAddress[i];
147             _tokenIn = _route.tokenIn[i];
148             _tokenOut = _route.tokenOut[i];
149             
150             if (_poolType == 0) {
151                 _amount = _swapUniV3(_tokenIn, _tokenOut, _amount, _poolAddress);
152             } else if (_poolType == 1) {
153                 _amount = _swapFraxswapUniV2(_tokenIn, _tokenOut, _amount);
154             } else if (_poolType == 2) {
155                 _amount = _swapCurve2Asset(_tokenIn, _tokenOut, _amount, _poolAddress);
156             } else if (_poolType == 3) {
157                 _amount = _swapCurveCryptoV2(_tokenIn, _tokenOut, _amount, _poolAddress);
158             } else if (_poolType == 4) {
159                 _amount = _swapCurve3Asset(_tokenIn, _tokenOut, _amount, _poolAddress);
160             } else if (_poolType == 5) {
161                 _amount = _swapCurveETHV2(_tokenIn, _tokenOut, _amount, _poolAddress);
162             } else if (_poolType == 6) {
163                 _amount = _swapCurveCRVMeta(_tokenIn, _tokenOut, _amount, _poolAddress);
164             } else if (_poolType == 7) {
165                 _amount = _swapCurveFraxMeta(_tokenIn, _tokenOut, _amount, _poolAddress);
166             } else if (_poolType == 8) {
167                 _amount = _swapCurveBase3Pool(_tokenIn, _tokenOut, _amount, _poolAddress);
168             } else if (_poolType == 9) {
169                 _amount = _swapCurveSBTCPool(_tokenIn, _tokenOut, _amount, _poolAddress);
170             } else if (_poolType == 10) {
171                 _amount = _swapCurve4Pool(_tokenIn, _tokenOut, _amount, _poolAddress);
172             } else if (_poolType == 11) {
173                 _amount = _swapFraxCryptoMeta(_tokenIn, _tokenOut, _amount, _poolAddress);
174             } else if (_poolType == 12) {
175                 _amount = _swapBalancerPoolSingle(_tokenIn, _tokenOut, _amount, _poolAddress);
176             } else {
177                 revert UnsupportedPoolType();
178             }
179         }
180         
181         if (_toToken == ETH) {
182             // slither-disable-next-line arbitrary-send-eth
183             (bool sent,) = msg.sender.call{value: _amount}("");
184             if (!sent) revert FailedToSendETH();
185         } else {
186             IERC20(_toToken).safeTransfer(msg.sender, _amount);
187         }
188         
189         emit Swap(_fromToken, _toToken, _amount);
190         
191         return _amount;
192     }
193 
194     /********************************** Restricted Functions **********************************/
195 
196     /// @dev Add/Update a swap route.
197     /// @param _fromToken - The address of the input token.
198     /// @param _toToken - The address of the output token.
199     /// @param _poolType - The internal pool type.
200     /// @param _poolAddress - The pool addresses.
201     /// @param _fromList - The addresses of the input tokens.
202     /// @param _toList - The addresses of the output tokens.
203     function updateRoute(address _fromToken, address _toToken, uint256[] memory _poolType, address[] memory _poolAddress, address[] memory _fromList, address[] memory _toList) external {
204         if (msg.sender != owner) revert Unauthorized();
205         if (routes[_fromToken][_toToken].poolAddress.length != 0) revert RouteAlreadyExists();
206 
207         routes[_fromToken][_toToken] = Route(
208             _poolType,
209             _poolAddress,
210             _fromList,
211             _toList
212         );
213 
214         emit UpdateRoute(_fromToken, _toToken, _poolAddress);
215     }
216 
217     /// @dev Delete a swap route.
218     /// @param _fromToken - The address of the input token.
219     /// @param _toToken - The address of the output token.
220     function deleteRoute(address _fromToken, address _toToken) external {
221         if (msg.sender != owner) revert Unauthorized();
222 
223         delete routes[_fromToken][_toToken];
224 
225         emit DeleteRoute(_fromToken, _toToken);
226     }
227 
228     /// @dev Update the contract owner.
229     /// @param _newOwner - The address of the new owner.
230     function updateOwner(address _newOwner) external {
231         if (msg.sender != owner) revert Unauthorized();
232         if (_newOwner == address(0)) revert ZeroInput();
233 
234         owner = _newOwner;
235         
236         emit UpdateOwner(_newOwner);
237     }
238 
239     /// @dev Rescue stuck ERC20 tokens.
240     /// @param _tokens - The address of the tokens to rescue.
241     /// @param _recipient - The address of the recipient of rescued tokens.
242     function rescue(address[] memory _tokens, address _recipient) external {
243         if (msg.sender != owner) revert Unauthorized();
244         if (_recipient == address(0)) revert ZeroInput();
245 
246         for (uint256 i = 0; i < _tokens.length; i++) {
247             IERC20(_tokens[i]).safeTransfer(_recipient, IERC20(_tokens[i]).balanceOf(address(this)));
248         }
249 
250         emit Rescue(_tokens, _recipient);
251     }
252 
253     /// @dev Rescue stuck ETH.
254     /// @param _recipient - The address of the recipient of rescued ETH.
255     function rescueETH(address _recipient) external {
256         if (msg.sender != owner) revert Unauthorized();
257         if (_recipient == address(0)) revert ZeroInput();
258 
259         (bool sent,) = _recipient.call{value: address(this).balance}("");
260         if (!sent) revert FailedToSendETH();
261 
262         emit RescueETH(_recipient);
263     }
264 
265     /********************************** Internal Functions **********************************/
266 
267     function _swapUniV3(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
268         
269         bool _toETH = false;
270         if (_fromToken == ETH) {
271             _wrapETH(_amount);
272             _fromToken = WETH;
273         } else if (_toToken == ETH) {
274             _toToken = WETH;
275             _toETH = true;
276         }
277         
278         _approve(_fromToken, UNIV3_ROUTER, _amount);
279 
280         uint24 _fee = IUniswapV3Pool(_poolAddress).fee();
281         
282         uint256 _before = IERC20(_toToken).balanceOf(address(this));
283         IUniswapV3Router.ExactInputSingleParams memory _params = IUniswapV3Router.ExactInputSingleParams(
284             _fromToken,
285             _toToken,
286             _fee, 
287             address(this), 
288             block.timestamp,
289             _amount,
290             0,
291             0
292         );
293 
294         IUniswapV3Router(UNIV3_ROUTER).exactInputSingle(_params);
295         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
296 
297         if (_toETH) {
298             _unwrapETH(_amount);
299         }
300 
301         return _amount;
302     }
303 
304     function _swapFraxswapUniV2(address _fromToken, address _toToken, uint256 _amount) internal returns (uint256) {
305         
306         bool _toETH = false;
307         if (_fromToken == ETH) {
308             _wrapETH(_amount);
309             _fromToken = WETH;
310         } else if (_toToken == ETH) {
311             _toToken = WETH;
312             _toETH = true;
313         }
314 
315         _approve(_fromToken, FRAXSWAP_UNIV2_ROUTER, _amount);
316 
317         address[] memory path = new address[](2);
318         path[0] = _fromToken;
319         path[1] = _toToken;
320 
321         // uint256[] memory _amounts;
322         uint256 _before = IERC20(_toToken).balanceOf(address(this));
323         IUniswapV2Router(FRAXSWAP_UNIV2_ROUTER).swapExactTokensForTokens(_amount, 0, path, address(this), block.timestamp);
324         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
325 
326         if (_toETH) {
327             _unwrapETH(_amount);
328         } 
329 
330         // return _amounts[1];
331         return _amount;
332     }
333 
334     function _swapBalancerPoolSingle(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
335         bytes32 _poolId = IBalancerPool(_poolAddress).getPoolId();
336         
337         bool _toETH = false;
338         if (_fromToken == ETH) {
339             _wrapETH(_amount);
340             _fromToken = WETH;
341         } else if (_toToken == ETH) {
342             _toToken = WETH;
343             _toETH = true;
344         }
345         
346         _approve(_fromToken, BALANCER_VAULT, _amount);
347         uint256 _before = IERC20(_toToken).balanceOf(address(this));
348         IBalancerVault(BALANCER_VAULT).swap(
349             IBalancerVault.SingleSwap({
350             poolId: _poolId,
351             kind: IBalancerVault.SwapKind.GIVEN_IN,
352             assetIn: _fromToken,
353             assetOut: _toToken,
354             amount: _amount,
355             userData: new bytes(0)
356             }),
357             IBalancerVault.FundManagement({
358             sender: address(this),
359             fromInternalBalance: false,
360             recipient: payable(address(this)),
361             toInternalBalance: false
362             }),
363             0,
364             block.timestamp
365         );
366 
367         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
368 
369         if (_toETH) {
370             _unwrapETH(_amount);
371         }
372 
373         return _amount;
374     }
375 
376     // ICurvePlainPool
377     // ICurveETHPool
378     function _swapCurve2Asset(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
379         ICurvePool _pool = ICurvePool(_poolAddress);
380         
381         int128 _to = 0;
382         int128 _from = 0;
383         if (_fromToken == _pool.coins(0) && _toToken == _pool.coins(1)) {
384             _from = 0;
385             _to = 1;
386         } else if (_fromToken == _pool.coins(1) && _toToken == _pool.coins(0)) {
387             _from = 1;
388             _to = 0;
389         } else {
390             revert InvalidTokens();
391         }
392         
393         uint256 _before = _toToken == ETH ? address(this).balance : IERC20(_toToken).balanceOf(address(this));
394 
395         if (_fromToken == ETH) {
396             _pool.exchange{ value: _amount }(_from, _to, _amount, 0);    
397         } else {
398             _approve(_fromToken, _poolAddress, _amount);
399             _pool.exchange(_from, _to, _amount, 0);
400         }
401         return _toToken == ETH ? address(this).balance - _before : IERC20(_toToken).balanceOf(address(this)) - _before;
402     }
403 
404     // ICurveCryptoV2Pool
405     function _swapCurveCryptoV2(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
406         ICurveCryptoV2Pool _pool = ICurveCryptoV2Pool(_poolAddress);
407         
408         uint256 _to = 0;
409         uint256 _from = 0;
410         if (_fromToken == _pool.coins(0) && _toToken == _pool.coins(1)) {
411             _from = 0;
412             _to = 1;
413         } else if (_fromToken == _pool.coins(1) && _toToken == _pool.coins(0)) {
414             _from = 1;
415             _to = 0;
416         } else {
417             revert InvalidTokens();
418         }
419         
420         uint256 _before = _toToken == ETH ? address(this).balance : IERC20(_toToken).balanceOf(address(this));
421 
422         if (_pool.coins(_from) == ETH) {
423             _pool.exchange{ value: _amount }(_from, _to, _amount, 0);    
424         } else {
425             _approve(_fromToken, _poolAddress, _amount);
426             _pool.exchange(_from, _to, _amount, 0);
427         }
428         return _toToken == ETH ? address(this).balance - _before : IERC20(_toToken).balanceOf(address(this)) - _before;
429     }
430 
431     // ICurveBase3Pool
432     function _swapCurveBase3Pool(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
433         ICurveBase3Pool _pool = ICurveBase3Pool(_poolAddress);
434         
435         int256 _to = 0;
436         int256 _from = 0;
437         for(int256 i = 0; i < 3; i++) {
438             if (_fromToken == _pool.coins(i.toUint256())) {
439                 _from = i;
440             } else if (_toToken == _pool.coins(i.toUint256())) {
441                 _to = i;
442             }
443         }
444 
445         _approve(_fromToken, _poolAddress, _amount);
446         
447         uint256 _before = IERC20(_toToken).balanceOf(address(this));
448         _pool.exchange(_from.toInt128(), _to.toInt128(), _amount, 0);
449         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
450         
451         return _amount;
452     }
453 
454     // ICurve3Pool
455     function _swapCurve3Asset(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
456         ICurve3Pool _pool = ICurve3Pool(_poolAddress);
457 
458         bool _toETH = false;
459         if (_fromToken == ETH) {
460             _wrapETH(_amount);
461             _fromToken = WETH;
462         } else if (_toToken == ETH) {
463             _toToken = WETH;
464             _toETH = true;
465         }
466 
467         uint256 _to = 0;
468         uint256 _from = 0;
469         for(uint256 i = 0; i < 3; i++) {
470             if (_fromToken == _pool.coins(i)) {
471                 _from = i;
472             } else if (_toToken == _pool.coins(i)) {
473                 _to = i;
474             }
475         }
476 
477         _approve(_fromToken, _poolAddress, _amount);
478         
479         uint256 _before = IERC20(_toToken).balanceOf(address(this));
480         _pool.exchange(_from, _to, _amount, 0);
481         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
482         
483         if (_toETH) {
484             _unwrapETH(_amount);
485         }
486         return _amount;
487     }
488 
489     function _swapCurve4Pool(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
490         ICurvesUSD4Pool _pool = ICurvesUSD4Pool(_poolAddress);
491 
492         int128 _to = 0;
493         int128 _from = 0;
494         for(int128 i = 0; i < 4; i++) {
495             if (_fromToken == _pool.coins(i)) {
496                 _from = i;
497             } else if (_toToken == _pool.coins(i)) {
498                 _to = i;
499             }
500         }
501 
502         _approve(_fromToken, _poolAddress, _amount);
503         
504         uint256 _before = IERC20(_toToken).balanceOf(address(this));
505         _pool.exchange(_from, _to, _amount, 0);
506         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
507         
508         return _amount;
509     }
510     
511     // ICurveSBTCPool
512     function _swapCurveSBTCPool(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
513         ICurveSBTCPool _pool = ICurveSBTCPool(_poolAddress);
514 
515         int128 _to = 0;
516         int128 _from = 0;
517         for(int128 i = 0; i < 3; i++) {
518             if (_fromToken == _pool.coins(i)) {
519                 _from = i;
520             } else if (_toToken == _pool.coins(i)) {
521                 _to = i;
522             }
523         }
524 
525         _approve(_fromToken, _poolAddress, _amount);
526         
527         uint256 _before = IERC20(_toToken).balanceOf(address(this));
528         _pool.exchange(_from, _to, _amount, 0);
529         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
530         
531         return _amount;
532     }
533 
534     // ICurveCRVMeta
535     function _swapCurveCRVMeta(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
536         ICurveCRVMeta _pool = ICurveCRVMeta(_poolAddress);
537 
538         int128 _to = 0;
539         int128 _from = 0;
540         if (_fromToken == _pool.coins(0)) {
541             _approve(_fromToken, _poolAddress, _amount);
542             _from = 0;
543         } else if (_toToken == _pool.coins(0)) {
544             _to = 0;
545         } else {
546             revert InvalidTokens();
547         }
548         
549         ICurveBase3Pool _curveBP = ICurveBase3Pool(CURVE_BP);
550         for (int256 i = 0; i < 3; i++) {
551             if (_curveBP.coins(i.toUint256()) == _fromToken) {
552                 _approve(_fromToken, _poolAddress, _amount);
553                 _from = i.toInt128() + 1;
554             } else if (_curveBP.coins(i.toUint256()) == _toToken) {
555                 _to = i.toInt128() + 1;
556             }
557         }
558         uint256 _before = IERC20(_toToken).balanceOf(address(this));
559         _pool.exchange_underlying(_from, _to, _amount, 0);
560 
561         return IERC20(_toToken).balanceOf(address(this)) - _before;
562     }
563 
564     // ICurveFraxMeta
565     function _swapCurveFraxMeta(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
566         ICurveFraxMeta _pool = ICurveFraxMeta(_poolAddress);
567 
568         int128 _to = 0;
569         int128 _from = 0;
570         if (_fromToken == _pool.coins(0)) {
571             _approve(_fromToken, _poolAddress, _amount);
572             _from = 0;
573         } else if (_toToken == _pool.coins(0)) {
574             _to = 0;
575         } else {
576             revert InvalidTokens();
577         }
578 
579         ICurveFraxMeta _fraxBP = ICurveFraxMeta(FRAX_BP);
580         for (int256 i = 0; i < 2; i++) {
581             if (_fromToken == _fraxBP.coins(i.toUint256())) {
582                 _approve(_fromToken, _poolAddress, _amount);
583                 _from = i.toInt128() + 1;
584             } else if (_toToken == _fraxBP.coins(i.toUint256())) {
585                 _to = i.toInt128() + 1;
586             }
587         }
588         uint256 _before = IERC20(_toToken).balanceOf(address(this));
589         _pool.exchange_underlying(_from, _to, _amount, 0);
590 
591         return IERC20(_toToken).balanceOf(address(this)) - _before;
592     }
593 
594     // ICurveFraxCryptoMeta
595     function _swapFraxCryptoMeta(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
596         ICurveFraxCryptoMeta _pool = ICurveFraxCryptoMeta(_poolAddress);
597 
598         if (_fromToken == ETH) {
599             _wrapETH(_amount);
600             _fromToken = WETH;
601         } else if (_toToken == ETH) {
602             _toToken = WETH;
603         }
604 
605         ICurvePlainPool _fraxBP = ICurvePlainPool(FRAX_BP);
606         uint256 _lpTokens = 0;
607         int128 _to = 0;
608         if (_fromToken == _pool.coins(0)) {
609             _approve(_fromToken, _poolAddress, _amount);
610             _lpTokens = _pool.exchange(0, 1, _amount, 0);
611             if (_toToken == _fraxBP.coins(0)) {
612                 _to = 0;
613             } else if (_toToken == _fraxBP.coins(1)) {
614                 _to = 1;
615             }
616             _approve(crvFRAX, FRAX_BP, _lpTokens);
617             return _fraxBP.remove_liquidity_one_coin(_lpTokens, _to, 0);
618         
619         } else if (_toToken == _pool.coins(0)) {
620             _approve(_fromToken, FRAX_BP, _amount);
621             if (_fromToken == _fraxBP.coins(0)) {
622                 _lpTokens = _fraxBP.add_liquidity([_amount, 0], 0);
623             } else if (_fromToken == _fraxBP.coins(1)) {
624                 _lpTokens = _fraxBP.add_liquidity([0, _amount], 0);
625             }
626             _approve(crvFRAX, _poolAddress, _lpTokens);
627             return _pool.exchange(1, 0, _lpTokens, 0);
628         } else {
629             revert InvalidTokens();
630         }
631     }
632 
633     // ICurveCryptoETHV2Pool
634     function _swapCurveETHV2(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
635         ICurveCryptoETHV2Pool _pool = ICurveCryptoETHV2Pool(_poolAddress);
636         
637         bool _toETH = false;
638         if (_fromToken == ETH) {
639             _wrapETH(_amount);
640             _fromToken = WETH;
641         } else if (_toToken == ETH) {
642             _toToken = WETH;
643             _toETH = true;
644         }
645 
646         _approve(_fromToken, _poolAddress, _amount);
647 
648         uint256 _to = 0;
649         uint256 _from = 0;
650         if (_fromToken == _pool.coins(0) && _toToken == _pool.coins(1)) {
651             _from = 0;
652             _to = 1;
653         } else if (_fromToken == _pool.coins(1) && _toToken == _pool.coins(0)) {
654             _from = 1;
655             _to = 0;
656         } else {
657             revert InvalidTokens();
658         }
659         
660         uint256 _before = IERC20(_toToken).balanceOf(address(this));
661         _pool.exchange(_from, _to, _amount, 0, false);
662         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
663 
664         if (_toETH) {
665             _unwrapETH(_amount);
666         }
667         return _amount;
668     }
669 
670     function _wrapETH(uint256 _amount) internal {
671         IWETH(WETH).deposit{ value: _amount }();
672     }
673 
674     function _unwrapETH(uint256 _amount) internal {
675         IWETH(WETH).withdraw(_amount);
676     }
677 
678     function _approve(address _token, address _spender, uint256 _amount) internal {
679         IERC20(_token).safeApprove(_spender, 0);
680         IERC20(_token).safeApprove(_spender, _amount);
681     }
682 
683     receive() external payable {}
684 }