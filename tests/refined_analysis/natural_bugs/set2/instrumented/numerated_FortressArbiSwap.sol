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
17 //  _____         _                   _____     _   _ _____               
18 // |   __|___ ___| |_ ___ ___ ___ ___|  _  |___| |_|_|   __|_ _ _ ___ ___ 
19 // |   __| . |  _|  _|  _| -_|_ -|_ -|     |  _| . | |__   | | | | .'| . |
20 // |__|  |___|_| |_| |_| |___|___|___|__|__|_| |___|_|_____|_____|__,|  _|
21 //                                                                   |_|  
22 
23 // Github - https://github.com/FortressFinance
24 
25 import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
26 import {SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
27 import {ReentrancyGuard} from "lib/openzeppelin-contracts/contracts/security/ReentrancyGuard.sol";
28 import {SafeCast} from "lib/openzeppelin-contracts/contracts/utils/math/SafeCast.sol";
29 import {Address} from "lib/openzeppelin-contracts/contracts/utils/Address.sol";
30 
31 import {IFortressSwap} from "src/shared/fortress-interfaces/IFortressSwap.sol";
32 
33 import {IUniswapV3RouterArbi} from "src/arbitrum/interfaces/IUniswapV3RouterArbi.sol";
34 import {IGMXRouter} from "src/arbitrum/interfaces/IGMXRouter.sol";
35 import {IWETH} from "src/shared/interfaces/IWETH.sol";
36 import {ICurvePool} from "src/shared/interfaces/ICurvePool.sol";
37 import {ICurveCryptoETHV2Pool} from "src/shared/interfaces/ICurveCryptoETHV2Pool.sol";
38 import {ICurveSBTCPool} from "src/shared/interfaces/ICurveSBTCPool.sol";
39 import {ICurveCryptoV2Pool} from "src/shared/interfaces/ICurveCryptoV2Pool.sol";
40 import {ICurve3Pool} from "src/shared/interfaces/ICurve3Pool.sol";
41 import {ICurvesUSD4Pool} from "src/shared/interfaces/ICurvesUSD4Pool.sol";
42 import {ICurveBase3Pool} from "src/shared/interfaces/ICurveBase3Pool.sol";
43 import {ICurvePlainPool} from "src/shared/interfaces/ICurvePlainPool.sol";
44 import {ICurveCRVMeta} from "src/shared/interfaces/ICurveCRVMeta.sol";
45 import {ICurveFraxMeta} from "src/shared/interfaces/ICurveFraxMeta.sol";
46 import {ICurveFraxCryptoMeta} from "src/shared/interfaces/ICurveFraxCryptoMeta.sol";
47 import {IUniswapV3Pool} from "src/shared/interfaces/IUniswapV3Pool.sol";
48 import {IUniswapV2Router} from "src/shared/interfaces/IUniswapV2Router.sol";
49 import {IBalancerVault} from "src/shared/interfaces/IBalancerVault.sol";
50 import {IBalancerPool} from "src/shared/interfaces/IBalancerPool.sol";
51 
52 contract FortressArbiSwap is ReentrancyGuard, IFortressSwap {
53 
54     using SafeERC20 for IERC20;
55     using SafeCast for int256;
56     using Address for address payable;
57 
58     /// @notice The address of WETH token (Arbitrum)
59     address private constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
60     /// @notice The address representing native ETH.
61     address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
62     /// @notice The address of Uniswap V3 Router (Arbitrum).
63     address private constant UNIV3_ROUTER = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;
64     /// @notice The address of Balancer vault (Arbitrum).
65     address constant BALANCER_VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
66     // The address of Sushi Swap Router (Arbitrum).
67     address constant SUSHI_ARB_ROUTER = 0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506;
68     /// @notice The address of Fraxswap Uniswap V2 Router Arbitrum (https://docs.frax.finance/smart-contracts/fraxswap#arbitrum-1).
69     address private constant FRAXSWAP_UNIV2_ROUTER = 0xc2544A32872A91F4A553b404C6950e89De901fdb;
70     /// @notice The address of GMX Swap Router.
71     address constant GMX_ROUTER = 0xaBBc5F99639c9B6bCb58544ddf04EFA6802F4064;
72 
73     struct Route {
74         // pool type -->
75         // 0: UniswapV3
76         // 1: Fraxswap
77         // 2: Curve2AssetPool
78         // 3: _swapCurveCryptoV2
79         // 4: Curve3AssetPool
80         // 5: CurveETHV2Pool
81         // 6: CurveCRVMeta - N/A
82         // 7: CurveFraxMeta - N/A
83         // 8: CurveBase3Pool
84         // 9: CurveSBTCPool
85         // 10: Curve4Pool
86         // 11: FraxCryptoMeta - N/A
87         // 12: BalancerSingleSwap
88         // 13: SushiSwap
89         // 14: GMXSwap
90         
91         /// @notice The internal pool type.
92         uint256[] poolType;
93         /// @notice The pool addresses.
94         address[] poolAddress;
95         /// @notice The addresses of the token to swap from.
96         address[] tokenIn;
97         /// @notice The addresses of the token to swap to.
98         address[] tokenOut;
99     }
100 
101     /// @notice The swap routes.
102     mapping(address => mapping(address => Route)) private routes;
103     
104     /// @notice The address of the owner.
105     address public owner;
106 
107     /********************************** View Functions **********************************/
108 
109     /// @dev Check if a certain swap route is available.
110     /// @param _fromToken - The address of the input token.
111     /// @param _toToken - The address of the output token.
112     /// @return - Whether the route exist.
113     function routeExists(address _fromToken, address _toToken) external view returns (bool) {
114         return routes[_fromToken][_toToken].poolAddress.length > 0;
115     }
116 
117     /********************************** Constructor **********************************/
118 
119     constructor(address _owner) {
120         if (_owner == address(0)) revert ZeroInput();
121          
122         owner = _owner;
123     }
124 
125     /********************************** Mutated Functions **********************************/
126 
127     /// @dev Swap from one token to another.
128     /// @param _fromToken - The address of the input token.
129     /// @param _toToken - The address of the output token.
130     /// @param _amount - The amount of input token.
131     /// @return - The amount of output token.
132     function swap(address _fromToken, address _toToken, uint256 _amount) external payable nonReentrant returns (uint256) {
133         Route storage _route = routes[_fromToken][_toToken];
134         if (_route.poolAddress.length == 0) revert RouteUnavailable();
135         
136         if (msg.value > 0) {
137             if (msg.value != _amount) revert AmountMismatch();
138             if (_fromToken != ETH) revert TokenMismatch();
139         } else {
140             if (_fromToken == ETH) revert TokenMismatch();
141             IERC20(_fromToken).safeTransferFrom(msg.sender, address(this), _amount);
142         }
143         
144         uint256 _poolType;
145         address _poolAddress;
146         address _tokenIn;
147         address _tokenOut;
148         for(uint256 i = 0; i < _route.poolAddress.length; i++) {
149             _poolType = _route.poolType[i];
150             _poolAddress = _route.poolAddress[i];
151             _tokenIn = _route.tokenIn[i];
152             _tokenOut = _route.tokenOut[i];
153             
154             if (_poolType == 0) {
155                 _amount = _swapUniV3(_tokenIn, _tokenOut, _amount, _poolAddress);
156             } else if (_poolType == 1) {
157                 _amount = _swapFraxswapUniV2(_tokenIn, _tokenOut, _amount);
158             } else if (_poolType == 2) {
159                 _amount = _swapCurve2Asset(_tokenIn, _tokenOut, _amount, _poolAddress);
160             } else if (_poolType == 3) {
161                 _amount = _swapCurveCryptoV2(_tokenIn, _tokenOut, _amount, _poolAddress);
162             } else if (_poolType == 4) {
163                 _amount = _swapCurve3Asset(_tokenIn, _tokenOut, _amount, _poolAddress);
164             } else if (_poolType == 5) {
165                 _amount = _swapCurveETHV2(_tokenIn, _tokenOut, _amount, _poolAddress);
166             } else if (_poolType == 8) {
167                 _amount = _swapCurveBase3Pool(_tokenIn, _tokenOut, _amount, _poolAddress);
168             } else if (_poolType == 9) {
169                 _amount = _swapCurveSBTCPool(_tokenIn, _tokenOut, _amount, _poolAddress);
170             } else if (_poolType == 10) {
171                 _amount = _swapCurve4Pool(_tokenIn, _tokenOut, _amount, _poolAddress);
172             } else if (_poolType == 12) {
173                 _amount = _swapBalancerPoolSingle(_tokenIn, _tokenOut, _amount, _poolAddress);
174             } else if (_poolType == 13) {
175                 _amount = _swapSushiPool(_tokenIn, _tokenOut, _amount);
176             } else if (_poolType == 14) {
177                 _amount = _swapGMX(_tokenIn, _tokenOut, _amount);
178             } else {
179                 revert UnsupportedPoolType();
180             }
181         }
182         
183         if (_toToken == ETH) {
184             payable(msg.sender).sendValue(_amount);
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
259         payable(_recipient).sendValue(address(this).balance);
260 
261         emit RescueETH(_recipient);
262     }
263 
264     /********************************** Internal Functions **********************************/
265 
266     function _swapGMX(address _fromToken, address _toToken, uint256 _amount) internal returns (uint256) {
267 
268         bool _toETH = false;
269         if (_fromToken == ETH) {
270             _wrapETH(_amount);
271             _fromToken = WETH;
272         } else if (_toToken == ETH) {
273             _toToken = WETH;
274             _toETH = true;
275         }
276 
277         address _router = GMX_ROUTER;
278         _approve(_fromToken, _router, _amount);
279 
280         address[] memory _path = new address[](2);
281         _path[0] = _fromToken;
282         _path[1] = _toToken; 
283 
284         uint256 _before = IERC20(_toToken).balanceOf(address(this));
285         IGMXRouter(_router).swap(_path, _amount, 0, address(this));
286         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
287 
288         if (_toETH) {
289             _unwrapETH(_amount);
290         }
291         
292         return _amount;
293     }
294 
295     function _swapUniV3(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
296         
297         bool _toETH = false;
298         if (_fromToken == ETH) {
299             _wrapETH(_amount);
300             _fromToken = WETH;
301         } else if (_toToken == ETH) {
302             _toToken = WETH;
303             _toETH = true;
304         }
305         
306         address _router = UNIV3_ROUTER;
307         _approve(_fromToken, _router, _amount);
308 
309         uint24 _fee = IUniswapV3Pool(_poolAddress).fee();
310         
311         uint256 _before = IERC20(_toToken).balanceOf(address(this));
312         IUniswapV3RouterArbi.ExactInputSingleParams memory _params = IUniswapV3RouterArbi.ExactInputSingleParams(
313             _fromToken,
314             _toToken,
315             _fee, 
316             address(this), 
317             _amount,
318             0,
319             0
320         );
321 
322         IUniswapV3RouterArbi(_router).exactInputSingle(_params);
323         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
324 
325         if (_toETH) {
326             _unwrapETH(_amount);
327         }
328         
329         return _amount;
330     }
331 
332     function _swapFraxswapUniV2(address _fromToken, address _toToken, uint256 _amount) internal returns (uint256) {
333         
334         bool _toETH = false;
335         if (_fromToken == ETH) {
336             _wrapETH(_amount);
337             _fromToken = WETH;
338         } else if (_toToken == ETH) {
339             _toToken = WETH;
340             _toETH = true;
341         }
342 
343         _approve(_fromToken, FRAXSWAP_UNIV2_ROUTER, _amount);
344 
345         address[] memory path = new address[](2);
346         path[0] = _fromToken;
347         path[1] = _toToken;
348 
349         // uint256[] memory _amounts;
350         uint256 _before = IERC20(_toToken).balanceOf(address(this));
351         IUniswapV2Router(FRAXSWAP_UNIV2_ROUTER).swapExactTokensForTokens(_amount, 0, path, address(this), block.timestamp);
352         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
353 
354         if (_toETH) {
355             _unwrapETH(_amount);
356         } 
357 
358         // return _amounts[1];
359         return _amount;
360     }
361 
362     function _swapBalancerPoolSingle(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
363         bytes32 _poolId = IBalancerPool(_poolAddress).getPoolId();
364         
365         bool _toETH = false;
366         if (_fromToken == ETH) {
367             _wrapETH(_amount);
368             _fromToken = WETH;
369         } else if (_toToken == ETH) {
370             _toToken = WETH;
371             _toETH = true;
372         }
373         
374         _approve(_fromToken, BALANCER_VAULT, _amount);
375         uint256 _before = IERC20(_toToken).balanceOf(address(this));
376         IBalancerVault(BALANCER_VAULT).swap(
377             IBalancerVault.SingleSwap({
378             poolId: _poolId,
379             kind: IBalancerVault.SwapKind.GIVEN_IN,
380             assetIn: _fromToken,
381             assetOut: _toToken,
382             amount: _amount,
383             userData: new bytes(0)
384             }),
385             IBalancerVault.FundManagement({
386             sender: address(this),
387             fromInternalBalance: false,
388             recipient: payable(address(this)),
389             toInternalBalance: false
390             }),
391             0,
392             block.timestamp
393         );
394 
395         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
396 
397         if (_toETH) {
398             _unwrapETH(_amount);
399         }
400 
401         return _amount;
402     }
403 
404     // ICurvePlainPool
405     // ICurveETHPool
406     function _swapCurve2Asset(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
407         ICurvePool _pool = ICurvePool(_poolAddress);
408         
409         int128 _to = 0;
410         int128 _from = 0;
411         if (_fromToken == _pool.coins(0) && _toToken == _pool.coins(1)) {
412             _from = 0;
413             _to = 1;
414         } else if (_fromToken == _pool.coins(1) && _toToken == _pool.coins(0)) {
415             _from = 1;
416             _to = 0;
417         } else {
418             revert InvalidTokens();
419         }
420         
421         uint256 _before = _toToken == ETH ? address(this).balance : IERC20(_toToken).balanceOf(address(this));
422 
423         if (_fromToken == ETH) {
424             payable(address(_pool)).functionCallWithValue(abi.encodeWithSignature("exchange(address,address,uint256,uint256)", _from, _to, _amount, 0), _amount);
425         } else {
426             _approve(_fromToken, _poolAddress, _amount);
427             _pool.exchange(_from, _to, _amount, 0);
428         }
429         return _toToken == ETH ? address(this).balance - _before : IERC20(_toToken).balanceOf(address(this)) - _before;
430     }
431 
432     // ICurveCryptoV2Pool
433     function _swapCurveCryptoV2(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
434         ICurveCryptoV2Pool _pool = ICurveCryptoV2Pool(_poolAddress);
435         
436         uint256 _to = 0;
437         uint256 _from = 0;
438         if (_fromToken == _pool.coins(0) && _toToken == _pool.coins(1)) {
439             _from = 0;
440             _to = 1;
441         } else if (_fromToken == _pool.coins(1) && _toToken == _pool.coins(0)) {
442             _from = 1;
443             _to = 0;
444         } else {
445             revert InvalidTokens();
446         }
447         
448         uint256 _before = _toToken == ETH ? address(this).balance : IERC20(_toToken).balanceOf(address(this));
449 
450         if (_pool.coins(_from) == ETH) {
451             payable(address(_pool)).functionCallWithValue(abi.encodeWithSignature("exchange(address,address,uint256,uint256)", _from, _to, _amount, 0), _amount);
452         } else {
453             _approve(_fromToken, _poolAddress, _amount);
454             _pool.exchange(_from, _to, _amount, 0);
455         }
456         return _toToken == ETH ? address(this).balance - _before : IERC20(_toToken).balanceOf(address(this)) - _before;
457     }
458 
459     // ICurveBase3Pool
460     function _swapCurveBase3Pool(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
461         ICurveBase3Pool _pool = ICurveBase3Pool(_poolAddress);
462         
463         int256 _to = 0;
464         int256 _from = 0;
465         for(int256 i = 0; i < 3; i++) {
466             if (_fromToken == _pool.coins(i.toUint256())) {
467                 _from = i;
468             } else if (_toToken == _pool.coins(i.toUint256())) {
469                 _to = i;
470             }
471         }
472 
473         _approve(_fromToken, _poolAddress, _amount);
474         
475         uint256 _before = IERC20(_toToken).balanceOf(address(this));
476         _pool.exchange(_from.toInt128(), _to.toInt128(), _amount, 0);
477         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
478         
479         return _amount;
480     }
481 
482     // ICurve3Pool
483     function _swapCurve3Asset(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
484         ICurve3Pool _pool = ICurve3Pool(_poolAddress);
485 
486         bool _toETH = false;
487         if (_fromToken == ETH) {
488             _wrapETH(_amount);
489             _fromToken = WETH;
490         } else if (_toToken == ETH) {
491             _toToken = WETH;
492             _toETH = true;
493         }
494 
495         uint256 _to = 0;
496         uint256 _from = 0;
497         for(uint256 i = 0; i < 3; i++) {
498             if (_fromToken == _pool.coins(i)) {
499                 _from = i;
500             } else if (_toToken == _pool.coins(i)) {
501                 _to = i;
502             }
503         }
504 
505         _approve(_fromToken, _poolAddress, _amount);
506         
507         uint256 _before = IERC20(_toToken).balanceOf(address(this));
508         _pool.exchange(_from, _to, _amount, 0);
509         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
510         
511         if (_toETH) {
512             _unwrapETH(_amount);
513         }
514         return _amount;
515     }
516 
517     function _swapCurve4Pool(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
518         ICurvesUSD4Pool _pool = ICurvesUSD4Pool(_poolAddress);
519 
520         int128 _to = 0;
521         int128 _from = 0;
522         for(int128 i = 0; i < 4; i++) {
523             if (_fromToken == _pool.coins(i)) {
524                 _from = i;
525             } else if (_toToken == _pool.coins(i)) {
526                 _to = i;
527             }
528         }
529 
530         _approve(_fromToken, _poolAddress, _amount);
531         
532         uint256 _before = IERC20(_toToken).balanceOf(address(this));
533         _pool.exchange(_from, _to, _amount, 0);
534         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
535         
536         return _amount;
537     }
538     
539     // ICurveSBTCPool
540     function _swapCurveSBTCPool(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
541         ICurveSBTCPool _pool = ICurveSBTCPool(_poolAddress);
542 
543         int128 _to = 0;
544         int128 _from = 0;
545         for(int128 i = 0; i < 3; i++) {
546             if (_fromToken == _pool.coins(i)) {
547                 _from = i;
548             } else if (_toToken == _pool.coins(i)) {
549                 _to = i;
550             }
551         }
552 
553         _approve(_fromToken, _poolAddress, _amount);
554         
555         uint256 _before = IERC20(_toToken).balanceOf(address(this));
556         _pool.exchange(_from, _to, _amount, 0);
557         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
558         
559         return _amount;
560     }
561 
562     // ICurveCryptoETHV2Pool
563     function _swapCurveETHV2(address _fromToken, address _toToken, uint256 _amount, address _poolAddress) internal returns (uint256) {
564         ICurveCryptoETHV2Pool _pool = ICurveCryptoETHV2Pool(_poolAddress);
565         
566         bool _toETH = false;
567         if (_fromToken == ETH) {
568             _wrapETH(_amount);
569             _fromToken = WETH;
570         } else if (_toToken == ETH) {
571             _toToken = WETH;
572             _toETH = true;
573         }
574 
575         _approve(_fromToken, _poolAddress, _amount);
576 
577         uint256 _to = 0;
578         uint256 _from = 0;
579         if (_fromToken == _pool.coins(0) && _toToken == _pool.coins(1)) {
580             _from = 0;
581             _to = 1;
582         } else if (_fromToken == _pool.coins(1) && _toToken == _pool.coins(0)) {
583             _from = 1;
584             _to = 0;
585         } else {
586             revert InvalidTokens();
587         }
588         
589         uint256 _before = IERC20(_toToken).balanceOf(address(this));
590         _pool.exchange(_from, _to, _amount, 0, false);
591         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
592 
593         if (_toETH) {
594             _unwrapETH(_amount);
595         }
596         return _amount;
597     }
598 
599     // SushiPool
600     function _swapSushiPool(address _fromToken, address _toToken, uint256 _amount) internal returns (uint256) {
601         
602         bool _toETH = false;
603         if (_fromToken == ETH) {
604             _wrapETH(_amount);
605             _fromToken = WETH;
606         } else if (_toToken == ETH) {
607             _toToken = WETH;
608             _toETH = true;
609         }
610         
611         address _router = SUSHI_ARB_ROUTER;
612         _approve(_fromToken, _router, _amount);
613 
614         address[] memory path = new address[](2);
615         path[0] = _fromToken;
616         path[1] = _toToken;
617 
618         uint256 _before = IERC20(_toToken).balanceOf(address(this));
619         IUniswapV2Router(_router).swapExactTokensForTokens(_amount, 0, path, address(this), block.timestamp);
620         _amount = IERC20(_toToken).balanceOf(address(this)) - _before;
621 
622         if (_toETH) {
623             _unwrapETH(_amount);
624         }
625 
626         return _amount;
627     }
628 
629     function _wrapETH(uint256 _amount) internal {
630         payable(WETH).functionCallWithValue(abi.encodeWithSignature("deposit()"), _amount);
631     }
632 
633     function _unwrapETH(uint256 _amount) internal {
634         IWETH(WETH).withdraw(_amount);
635     }
636 
637     function _approve(address _token, address _spender, uint256 _amount) internal {
638         IERC20(_token).safeApprove(_spender, 0);
639         IERC20(_token).safeApprove(_spender, _amount);
640     }
641 
642     receive() external payable {}
643 }