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
17 //  _____                 _____     _   _ _____                 _   _             
18 // |     |_ _ ___ _ _ ___|  _  |___| |_|_|     |___ ___ ___ ___| |_|_|___ ___ ___ 
19 // |   --| | |  _| | | -_|     |  _| . | |  |  | . | -_|  _| .'|  _| | . |   |_ -|
20 // |_____|___|_|  \_/|___|__|__|_| |___|_|_____|  _|___|_| |__,|_| |_|___|_|_|___|
21 //                                             |_|                                
22 
23 // Github - https://github.com/FortressFinance
24 
25 import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
26 import {SafeERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
27 import {Address} from "lib/openzeppelin-contracts/contracts/utils/Address.sol";
28 
29 import {ICurvePool} from "src/shared/interfaces/ICurvePool.sol";
30 import {ICurve3Pool} from "src/shared/interfaces/ICurve3Pool.sol";
31 import {ICurvesUSD4Pool} from "src/shared/interfaces/ICurvesUSD4Pool.sol";
32 import {ICurveETHPool} from "src/shared/interfaces/ICurveETHPool.sol";
33 import {ICurveCryptoETHV2Pool} from "src/shared/interfaces/ICurveCryptoETHV2Pool.sol";
34 import {ICurveCRVMeta} from "src/shared/interfaces/ICurveCRVMeta.sol";
35 import {ICurveFraxMeta} from "src/shared/interfaces/ICurveFraxMeta.sol";
36 import {ICurveBase3Pool} from "src/shared/interfaces/ICurveBase3Pool.sol";
37 import {ICurveFraxCryptoMeta} from "src/shared/interfaces/ICurveFraxCryptoMeta.sol";
38 import {ICurveCryptoV2Pool} from "src/shared/interfaces/ICurveCryptoV2Pool.sol";
39 import {ICurveMetaRegistry} from "src/shared/interfaces/ICurveMetaRegistry.sol";
40 import {IWETH} from "src/shared/interfaces/IWETH.sol";
41 
42 contract CurveArbiOperations {
43 
44     using SafeERC20 for IERC20;
45     using Address for address payable;
46 
47     /// @notice The address of Curve MetaRegistry
48     ICurveMetaRegistry internal immutable metaRegistry = ICurveMetaRegistry(0x445FE580eF8d70FF569aB36e80c647af338db351);
49 
50     /// @notice The address of the owner
51     address public owner;
52     
53     /// @notice The address of WETH token (Arbitrum)
54     address internal constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
55     /// @notice The address representing ETH in Curve V1
56     address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
57     /// @notice The address of CRV_3_CRYPTO LP token (Curve BP Arbitrum)
58     // address internal constant CRV_3_CRYPTO = 0x8e0B8c8BB9db49a46697F3a5Bb8A308e744821D2
59      /// @notice The address of Curve Base Pool (https://curve.fi/3pool)
60     address internal constant CURVE_BP = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;
61     /// @notice The address of Curve's Frax Base Pool (https://curve.fi/fraxusdc)
62     address internal constant FRAX_BP = 0xDcEF968d416a41Cdac0ED8702fAC8128A64241A2;
63     /// @notice The address of crvFRAX LP token (Frax BP)
64     address internal constant CRV_FRAX = 0x3175Df0976dFA876431C2E9eE6Bc45b65d3473CC;
65     /// @notice The address of 3CRV LP token (Curve BP)
66     address internal constant TRI_CRV = 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490;
67 
68     /// @notice The mapping of whitelisted addresses, which are Fortress Vaults
69     mapping(address => bool) public whitelist;
70 
71     /********************************** Constructor **********************************/
72 
73     constructor(address _owner) {
74         owner = _owner;
75     }
76 
77     /********************************** View Functions **********************************/
78 
79     function getPoolFromLpToken(address _lpToken) public view returns (address _pool) {
80         return metaRegistry.get_pool_from_lp_token(_lpToken);
81     }
82 
83     function getLpTokenFromPool(address _pool) public view returns (address _lpToken) {
84         return metaRegistry.get_lp_token(_pool);
85     }
86 
87 
88     /********************************** Restricted Functions **********************************/
89 
90     // The type of the pool:
91     // 0 - 3Pool
92     // 1 - PlainPool
93     // 2 - CryptoV2Pool
94     // 3 - CrvMetaPool
95     // 4 - FraxMetaPool
96     // 5 - ETHPool
97     // 6 - ETHV2Pool
98     // 7 - Base3Pool
99     // 8 - FraxCryptoMetaPool
100     // 9 - sUSD 4Pool
101     function addLiquidity(address _poolAddress, uint256 _poolType, address _token, uint256 _amount) external payable returns (uint256 _assets) {
102         if (!whitelist[msg.sender]) revert Unauthorized();
103 
104         address _lpToken = getLpTokenFromPool(_poolAddress);
105         
106         if (msg.value > 0) {
107             if (_token != ETH) revert InvalidAsset();
108             if (_amount > address(this).balance) revert InvalidAmount();
109         } else {
110             IERC20(_token).safeTransferFrom(msg.sender, address(this), _amount);
111         }
112 
113         uint256 _before = IERC20(_lpToken).balanceOf(address(this));
114         if (_poolType == 0) {
115             _addLiquidity3AssetPool(_poolAddress, _token, _amount);
116         } else if (_poolType == 1 || _poolType == 2) {
117             _addLiquidity2AssetPool(_poolAddress, _token, _amount);
118         } else if (_poolType == 3) {
119             _addLiquidityCrvMetaPool(_poolAddress, _token, _amount);
120         } else if (_poolType == 4) {
121             _addLiquidityFraxMetaPool(_poolAddress, _token, _amount);
122         } else if (_poolType == 5) {
123             _addLiquidityETHPool(_poolAddress, _token, _amount);
124         } else if (_poolType == 6) {
125             _addLiquidityETHV2Pool(_poolAddress, _token, _amount);
126         } else if (_poolType == 7) {
127             _addLiquidityCurveBase3Pool(_poolAddress, _token, _amount);
128         } else if (_poolType == 8) {
129             _addLiquidityFraxCryptoMetaPool(_poolAddress, _token, _amount);
130         } else if (_poolType == 9) {
131             _addLiquiditysUSD4Pool(_poolAddress, _token, _amount);
132         } else {
133             revert InvalidPoolType();
134         }
135 
136         _assets = IERC20(_lpToken).balanceOf(address(this)) - _before;
137         IERC20(_lpToken).safeTransfer(msg.sender, _assets);
138 
139         return _assets;
140     }
141 
142     // The type of the pool:
143     // 0 - 3Pool
144     // 1 - PlainPool
145     // 2 - CryptoV2Pool
146     // 3 - CrvMetaPool
147     // 4 - FraxMetaPool
148     // 5 - ETHPool
149     // 6 - ETHV2Pool
150     // 7 - Base3Pool
151     // 8 - FraxCryptoMetaPool
152     // 9 - sUSD 4Pool
153     function removeLiquidity(address _poolAddress, uint256 _poolType, address _token, uint256 _amount) external returns (uint256 _underlyingAmount) {
154         if (!whitelist[msg.sender]) revert Unauthorized();
155 
156         uint256 _before;
157         if (_token == ETH) {
158             _before = address(this).balance;
159         } else {
160             _before = IERC20(_token).balanceOf(address(this));
161         }
162 
163         address _lpToken = metaRegistry.get_lp_token(_poolAddress);
164         IERC20(_lpToken).safeTransferFrom(msg.sender, address(this), _amount);
165         
166         if (_poolType == 0) {
167             _removeLiquidity3AssetPool(_poolAddress, _token, _amount);
168         } else if (_poolType == 1 || _poolType == 5) {
169             _removeLiquidity2AssetPool(_poolAddress, _token, _amount);
170         } else if (_poolType == 2) {
171             _removeLiquidityCryptoV2Pool(_poolAddress, _token, _amount);
172         } else if (_poolType == 3) {
173             _removeLiquidityCrvMetaPool(_poolAddress, _token, _amount);
174         } else if (_poolType == 4) {
175             _removeLiquidityFraxMetaPool(_poolAddress, _token, _amount);
176         } else if (_poolType == 6) {
177             _removeLiquidityETHV2Pool(_poolAddress, _token, _amount);
178         } else if (_poolType == 7) {
179             _removeLiquidityBase3Pool(_poolAddress, _token, _amount);
180         } else if (_poolType == 8) {
181             _removeLiquidityFraxMetaCryptoPool(_poolAddress, _token, _amount);
182         } else if (_poolType == 9) {
183             _removeLiquiditysUSD4Pool(_poolAddress, _token, _amount);
184         } else {
185             revert InvalidPoolType();
186         }
187 
188         if (_token == ETH) {
189             _underlyingAmount = address(this).balance - _before;
190             payable(msg.sender).sendValue(_underlyingAmount);
191         } else {
192             _underlyingAmount = IERC20(_token).balanceOf(address(this)) - _before;
193             IERC20(_token).safeTransfer(msg.sender, _underlyingAmount);
194         }
195 
196         return _underlyingAmount;
197     }
198 
199     function updateWhitelist(address _vault, bool _whitelisted) external {
200         if (msg.sender != owner) revert OnlyOwner();
201 
202         whitelist[_vault] = _whitelisted;
203     }
204 
205     function updateOwner(address _owner) external {
206         if (msg.sender != owner) revert OnlyOwner();
207 
208         owner = _owner;
209     }
210 
211     /********************************** Internal Functions **********************************/
212 
213     // ICurvesUSD4Pool
214     function _addLiquiditysUSD4Pool(address _poolAddress, address _token, uint256 _amount) internal {
215         ICurvesUSD4Pool _pool = ICurvesUSD4Pool(_poolAddress);
216 
217         _approveOperations(_token, _poolAddress, _amount);
218 
219         if (_token == _pool.coins(0)) {
220             _pool.add_liquidity([_amount, 0, 0, 0], 0);
221         } else if (_token == _pool.coins(1)) {
222             _pool.add_liquidity([0, _amount, 0, 0], 0);
223         } else if (_token == _pool.coins(2)) {
224             _pool.add_liquidity([0, 0, _amount, 0], 0);
225         } else if (_token == _pool.coins(3)) {
226             _pool.add_liquidity([0, 0, 0, _amount], 0);
227         } else {
228             revert InvalidToken();
229         }
230     }
231 
232     // ICurveBase3Pool
233     function _addLiquidityCurveBase3Pool(address _poolAddress, address _token, uint256 _amount) internal {
234         ICurveBase3Pool _pool = ICurveBase3Pool(_poolAddress);
235 
236         _approveOperations(_token, _poolAddress, _amount);
237         
238         if (_token == _pool.coins(0)) {
239             _pool.add_liquidity([_amount, 0, 0], 0);
240         } else if (_token == _pool.coins(1)) {
241             _pool.add_liquidity([0, _amount, 0], 0);
242         } else if (_token == _pool.coins(2)) {
243             _pool.add_liquidity([0, 0, _amount], 0);
244         } else {
245             revert InvalidToken();
246         }
247     }
248 
249     // ICurve3Pool
250     // ICurveSBTCPool
251     function _addLiquidity3AssetPool(address _poolAddress, address _token, uint256 _amount) internal {
252         ICurve3Pool _pool = ICurve3Pool(_poolAddress);
253 
254         if (_token == ETH) {
255             _wrapETH(_amount);
256             _token = WETH;
257         }
258         _approveOperations(_token, _poolAddress, _amount);
259 
260         if (_token == _pool.coins(0)) {  
261             _pool.add_liquidity([_amount, 0, 0], 0);
262         } else if (_token == _pool.coins(1)) {
263             _pool.add_liquidity([0, _amount, 0], 0);
264         } else if (_token == _pool.coins(2)) {
265             _pool.add_liquidity([0, 0, _amount], 0);
266         } else {
267             revert InvalidToken();
268         }
269     }
270 
271     // ICurveCryptoV2Pool
272     // ICurvePlainPool
273     function _addLiquidity2AssetPool(address _poolAddress, address _token, uint256 _amount) internal {
274         ICurvePool _pool = ICurvePool(_poolAddress);
275         
276         _approveOperations(_token, _poolAddress, _amount);
277         if (_token == _pool.coins(0)) {
278             _pool.add_liquidity([_amount, 0], 0);
279         } else if (_token == _pool.coins(1)) {
280             _pool.add_liquidity([0, _amount], 0);
281         } else {
282             revert InvalidToken();
283         }
284     }
285 
286     // ICurveCRVMeta - CurveBP
287     function _addLiquidityCrvMetaPool(address _poolAddress, address _token, uint256 _amount) internal {
288         ICurveCRVMeta _pool = ICurveCRVMeta(_poolAddress);
289          
290         if (_token == _pool.coins(0)) {
291             _approveOperations(_token, _poolAddress, _amount);
292             _pool.add_liquidity([_amount, 0], 0);
293         } else {
294             _addLiquidityCurveBase3Pool(CURVE_BP, _token, _amount);
295             _amount = IERC20(TRI_CRV).balanceOf(address(this));
296             _approveOperations(TRI_CRV, _poolAddress, _amount);
297             _pool.add_liquidity([0, _amount], 0);
298         }
299     }
300 
301     // ICurveFraxMeta - FraxBP
302     function _addLiquidityFraxMetaPool(address _poolAddress, address _token, uint256 _amount) internal {
303         ICurveFraxMeta _pool = ICurveFraxMeta(_poolAddress);
304         
305         if (_token == _pool.coins(0)) {
306             _approveOperations(_token, _poolAddress, _amount);
307             _pool.add_liquidity([_amount, 0], 0);
308         } else {
309             _addLiquidity2AssetPool(FRAX_BP, _token, _amount);
310             _amount = IERC20(CRV_FRAX).balanceOf(address(this));
311             _approveOperations(CRV_FRAX, _poolAddress, _amount);
312             _pool.add_liquidity([0, _amount], 0);
313         }
314     }
315 
316     // ICurveFraxCryptoMeta - FraxBP/Crypto
317     function _addLiquidityFraxCryptoMetaPool(address _poolAddress, address _token, uint256 _amount) internal {
318         ICurveFraxCryptoMeta _pool = ICurveFraxCryptoMeta(_poolAddress);
319         
320         if (_token == _pool.coins(0)) {
321             _approveOperations(_token, _poolAddress, _amount);
322             _pool.add_liquidity([_amount, 0], 0);
323         } else {
324             _addLiquidity2AssetPool(FRAX_BP, _token, _amount);
325             _amount = IERC20(CRV_FRAX).balanceOf(address(this));
326             _approveOperations(CRV_FRAX, _poolAddress, _amount);
327             _pool.add_liquidity([0, _amount], 0);
328         }
329     }
330 
331     // ICurveETHPool
332     function _addLiquidityETHPool(address _poolAddress, address _token, uint256 _amount) internal {
333         ICurveETHPool _pool = ICurveETHPool(_poolAddress);
334 
335         if (_pool.coins(0) == _token) {
336             payable(address(_pool)).functionCallWithValue(abi.encodeWithSignature("add_liquidity(uint256[2],uint256)", [_amount, 0], 0), _amount);
337         } else if (_pool.coins(1) == _token) {
338             _approveOperations(_token, _poolAddress, _amount);
339             _pool.add_liquidity([0, _amount], 0);
340         } else {
341             revert InvalidToken();
342         }
343     }
344 
345     // ICurveCryptoETHV2Pool
346     function _addLiquidityETHV2Pool(address _poolAddress, address _token, uint256 _amount) internal {
347         ICurveCryptoETHV2Pool _pool = ICurveCryptoETHV2Pool(_poolAddress);
348 
349         if (_token == ETH) {
350             payable(address(_pool)).functionCallWithValue(abi.encodeWithSignature("add_liquidity(uint256[2],uint256,bool)", [_amount, 0], 0, true), _amount);
351         } else if (_token == _pool.coins(0)) {
352             _approveOperations(_token, _poolAddress, _amount);
353             _pool.add_liquidity([_amount, 0], 0, false);
354         } else if (_token == _pool.coins(1)) {
355             _approveOperations(_token, _poolAddress, _amount);
356             _pool.add_liquidity([0, _amount], 0, false);
357         } else {
358             revert InvalidToken();
359         }
360     }
361 
362     // ICurvesUSD4Pool
363     function _removeLiquiditysUSD4Pool(address _poolAddress, address _token, uint256 _amount) internal {
364         ICurvesUSD4Pool _poolWrapper = ICurvesUSD4Pool(address(0xFCBa3E75865d2d561BE8D220616520c171F12851));
365         ICurvesUSD4Pool _pool = ICurvesUSD4Pool(_poolAddress);
366 
367         _approveOperations(address(0xC25a3A3b969415c80451098fa907EC722572917F), address(_poolWrapper), _amount);
368         
369         if (_token == _pool.coins(0)) {
370             _poolWrapper.remove_liquidity_one_coin(_amount, 0, 0);
371         } else if (_token == _pool.coins(1)) {
372             _poolWrapper.remove_liquidity_one_coin(_amount, 1, 0);
373         } else if (_token == _pool.coins(2)) {
374             _poolWrapper.remove_liquidity_one_coin(_amount, 2, 0);
375         } else if (_token == _pool.coins(3)) {
376             _poolWrapper.remove_liquidity_one_coin(_amount, 3, 0);
377         } else {
378             revert InvalidToken();
379         }
380     }
381 
382     // ICurve3Pool
383     function _removeLiquidity3AssetPool(address _poolAddress, address _token, uint256 _amount) internal {
384         ICurve3Pool _pool = ICurve3Pool(_poolAddress);
385         
386         bool _isEth = false;
387         if (_token == ETH) {
388             _token = WETH;
389             _isEth = true;
390         }
391 
392         uint256 _before = IERC20(_token).balanceOf(address(this));
393         if (_token == _pool.coins(0)) {
394              _pool.remove_liquidity_one_coin(_amount, 0, 0);
395         } else if (_token == _pool.coins(1)) {
396             _pool.remove_liquidity_one_coin(_amount, 1, 0);
397         } else if (_token == _pool.coins(2)) {
398             _pool.remove_liquidity_one_coin(_amount, 2, 0);
399         } else {
400             revert InvalidToken();
401         }
402 
403         if (_isEth) {
404             _unwrapETH(IERC20(_token).balanceOf(address(this)) - _before);
405         }
406     }
407 
408     // ICurveBase3Pool
409     // ICurveSBTCPool
410     function _removeLiquidityBase3Pool(address _poolAddress, address _token, uint256 _amount) internal {
411         ICurveBase3Pool _pool = ICurveBase3Pool(_poolAddress);
412 
413         if (_token == _pool.coins(0)) {
414             _pool.remove_liquidity_one_coin(_amount, 0, 0);
415         } else if (_token == _pool.coins(1)) {
416             _pool.remove_liquidity_one_coin(_amount, 1, 0);
417         } else if (_token == _pool.coins(2)) {
418             _pool.remove_liquidity_one_coin(_amount, 2, 0);
419         } else {
420             revert InvalidToken();
421         }
422     }
423 
424     // ICurveETHPool
425     // ICurvePlainPool
426     function _removeLiquidity2AssetPool(address _poolAddress, address _token, uint256 _amount) internal {
427         ICurvePool _pool = ICurvePool(_poolAddress);
428 
429         if (_token == _pool.coins(0)) {
430             _pool.remove_liquidity_one_coin(_amount, 0, 0);
431         } else if (_token == _pool.coins(1)) {
432             _pool.remove_liquidity_one_coin(_amount, 1, 0);
433         } else {
434             revert InvalidToken();
435         }
436     }
437 
438     // ICurveCryptoV2Pool
439     function _removeLiquidityCryptoV2Pool(address _poolAddress, address _token, uint256 _amount) internal {
440         ICurveCryptoV2Pool _pool = ICurveCryptoV2Pool(_poolAddress);
441 
442         if (_token == _pool.coins(0)) {
443             _pool.remove_liquidity_one_coin(_amount, 0, 0);
444         } else if (_token == _pool.coins(1)) {
445             _pool.remove_liquidity_one_coin(_amount, 1, 0);
446         } else {
447             revert InvalidToken();
448         }
449     }
450 
451     // ICurveCryptoETHV2Pool
452     function _removeLiquidityETHV2Pool(address _poolAddress, address _token, uint256 _amount) internal {
453         ICurveCryptoETHV2Pool _pool = ICurveCryptoETHV2Pool(_poolAddress);
454         
455         if (_token == ETH) {
456             _pool.remove_liquidity_one_coin(_amount, 0, 0, true);
457         } else if (_token == _pool.coins(0)) {
458             _pool.remove_liquidity_one_coin(_amount, 0, 0, false);
459         } else if (_token == _pool.coins(1)) {
460             _pool.remove_liquidity_one_coin(_amount, 1, 0, false);
461         } else {
462             revert InvalidToken();
463         }
464     }
465 
466     // ICurveCRVMeta - CurveBP
467     function _removeLiquidityCrvMetaPool(address _poolAddress, address _token, uint256 _amount) internal {
468         ICurveCRVMeta _pool = ICurveCRVMeta(_poolAddress);
469         
470         if (_token == _pool.coins(0)) {
471             _pool.remove_liquidity_one_coin(_amount, 0, 0);
472         } else {
473             _amount = _pool.remove_liquidity_one_coin(_amount, 1, 0);
474             _removeLiquidityBase3Pool(CURVE_BP, _token, _amount);
475         }
476     }
477 
478     // ICurveFraxMeta - FraxBP/Stable
479     function _removeLiquidityFraxMetaPool(address _poolAddress, address _token, uint256 _amount) internal {
480         ICurveFraxMeta _pool = ICurveFraxMeta(_poolAddress);
481         
482         if (_token == _pool.coins(0)) {
483             _pool.remove_liquidity_one_coin(_amount, 0, 0);
484         } else {
485             _amount = _pool.remove_liquidity_one_coin(_amount, 1, 0);
486             _removeLiquidity2AssetPool(FRAX_BP, _token, _amount);
487         }
488     }
489 
490     // ICurveFraxCryptoMeta - FraxBP/Crypto
491     function _removeLiquidityFraxMetaCryptoPool(address _poolAddress, address _token, uint256 _amount) internal {
492         ICurveFraxCryptoMeta _pool = ICurveFraxCryptoMeta(_poolAddress);
493         
494         if (_token == _pool.coins(0)) {
495             _pool.remove_liquidity_one_coin(_amount, 0, 0);
496         } else {
497             _amount = _pool.remove_liquidity_one_coin(_amount, 1, 0);
498             _removeLiquidity2AssetPool(FRAX_BP, _token, _amount);
499         }
500     }
501 
502     function _wrapETH(uint256 _amount) internal {
503         payable(WETH).functionCallWithValue(abi.encodeWithSignature("deposit()"), _amount);
504     }
505 
506     function _unwrapETH(uint256 _amount) internal {
507         IWETH(WETH).withdraw(_amount);
508     }
509 
510     function _approveOperations(address _token, address _spender, uint256 _amount) internal virtual {
511         IERC20(_token).safeApprove(_spender, 0);
512         IERC20(_token).safeApprove(_spender, _amount);
513     }
514 
515     receive() external payable {}
516 
517     /********************************** Errors **********************************/
518 
519     error InvalidToken();
520     error InvalidAsset();
521     error InvalidAmount();
522     error InvalidPoolType();
523     error FailedToSendETH();
524     error OnlyOwner();
525     error Unauthorized();
526 }