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
17 //  _____                 _____                 _   _             
18 // |     |_ _ ___ _ _ ___|     |___ ___ ___ ___| |_|_|___ ___ ___ 
19 // |   --| | |  _| | | -_|  |  | . | -_|  _| .'|  _| | . |   |_ -|
20 // |_____|___|_|  \_/|___|_____|  _|___|_| |__,|_| |_|___|_|_|___|
21 //                             |_|                                
22 
23 // Github - https://github.com/FortressFinance
24 
25 import "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
26 import "lib/openzeppelin-contracts/contracts/token/ERC20/utils/SafeERC20.sol";
27 
28 import "src/shared/interfaces/IWETH.sol";
29 import "src/shared/interfaces/ICurvePool.sol";
30 import "src/shared/interfaces/ICurve3Pool.sol";
31 import "src/shared/interfaces/ICurvesUSD4Pool.sol";
32 import "src/shared/interfaces/ICurveETHPool.sol";
33 import "src/shared/interfaces/ICurveCryptoETHV2Pool.sol";
34 import "src/shared/interfaces/ICurveCRVMeta.sol";
35 import "src/shared/interfaces/ICurveFraxMeta.sol";
36 import "src/shared/interfaces/ICurveBase3Pool.sol";
37 import "src/shared/interfaces/ICurveFraxCryptoMeta.sol";
38 import "src/shared/interfaces/ICurveCryptoV2Pool.sol";
39 import "src/shared/interfaces/ICurveMetaRegistry.sol";
40 
41 contract CurveOperations {
42 
43     using SafeERC20 for IERC20;
44     
45     /// @notice The address of WETH token.
46     address internal constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
47     /// @notice The address representing ETH in Curve V1.
48     address private constant ETH = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
49     /// @notice The address of Curve Base Pool (https://curve.fi/3pool).
50     address internal constant CURVE_BP = 0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7;
51     /// @notice The address of Curve's Frax Base Pool (https://curve.fi/fraxusdc).
52     address internal constant FRAX_BP = 0xDcEF968d416a41Cdac0ED8702fAC8128A64241A2;
53     /// @notice The address of crvFRAX LP token (Frax BP).
54     address internal constant CRV_FRAX = 0x3175Df0976dFA876431C2E9eE6Bc45b65d3473CC;
55     /// @notice The address of 3CRV LP token (Curve BP).
56     address internal constant TRI_CRV = 0x6c3F90f043a72FA612cbac8115EE7e52BDe6E490;
57     
58     /// @notice The address of Curve MetaRegistry.
59     ICurveMetaRegistry internal immutable metaRegistry = ICurveMetaRegistry(0xF98B45FA17DE75FB1aD0e7aFD971b0ca00e379fC);
60     
61     // The type of the pool:
62     // 0 - 3Pool
63     // 1 - PlainPool
64     // 2 - CryptoV2Pool
65     // 3 - CrvMetaPool
66     // 4 - FraxMetaPool
67     // 5 - ETHPool
68     // 6 - ETHV2Pool
69     // 7 - Base3Pool
70     // 8 - FraxCryptoMetaPool
71     // 9 - sUSD 4Pool
72     function _addLiquidity(address _poolAddress, uint256 _poolType, address _token, uint256 _amount) internal returns (uint256) {
73         address _lpToken = metaRegistry.get_lp_token(_poolAddress);
74         uint256 _before = IERC20(_lpToken).balanceOf(address(this));
75         if (_poolType == 0) {
76             _addLiquidity3AssetPool(_poolAddress, _token, _amount);
77         } else if (_poolType == 1 || _poolType == 2) {
78             _addLiquidity2AssetPool(_poolAddress, _token, _amount);
79         } else if (_poolType == 3) {
80             _addLiquidityCrvMetaPool(_poolAddress, _token, _amount);
81         } else if (_poolType == 4) {
82             _addLiquidityFraxMetaPool(_poolAddress, _token, _amount);
83         } else if (_poolType == 5) {
84             _addLiquidityETHPool(_poolAddress, _token, _amount);
85         } else if (_poolType == 6) {
86             _addLiquidityETHV2Pool(_poolAddress, _token, _amount);
87         } else if (_poolType == 7) {
88             _addLiquidityCurveBase3Pool(_poolAddress, _token, _amount);
89         } else if (_poolType == 8) {
90             _addLiquidityFraxCryptoMetaPool(_poolAddress, _token, _amount);
91         } else if (_poolType == 9) {
92             _addLiquiditysUSD4Pool(_poolAddress, _token, _amount);
93         } else {
94             revert InvalidPoolType();
95         }
96         return (IERC20(_lpToken).balanceOf(address(this)) - _before);
97     }
98 
99     // ICurvesUSD4Pool
100     function _addLiquiditysUSD4Pool(address _poolAddress, address _token, uint256 _amount) internal {
101         ICurvesUSD4Pool _pool = ICurvesUSD4Pool(_poolAddress);
102 
103         _approveOperations(_token, _poolAddress, _amount);
104 
105         if (_token == _pool.coins(0)) {
106             _pool.add_liquidity([_amount, 0, 0, 0], 0);
107         } else if (_token == _pool.coins(1)) {
108             _pool.add_liquidity([0, _amount, 0, 0], 0);
109         } else if (_token == _pool.coins(2)) {
110             _pool.add_liquidity([0, 0, _amount, 0], 0);
111         } else if (_token == _pool.coins(3)) {
112             _pool.add_liquidity([0, 0, 0, _amount], 0);
113         } else {
114             revert InvalidToken();
115         }
116     }
117 
118     // ICurveBase3Pool
119     function _addLiquidityCurveBase3Pool(address _poolAddress, address _token, uint256 _amount) internal {
120         ICurveBase3Pool _pool = ICurveBase3Pool(_poolAddress);
121 
122         _approveOperations(_token, _poolAddress, _amount);
123         
124         if (_token == _pool.coins(0)) {
125             _pool.add_liquidity([_amount, 0, 0], 0);
126         } else if (_token == _pool.coins(1)) {
127             _pool.add_liquidity([0, _amount, 0], 0);
128         } else if (_token == _pool.coins(2)) {
129             _pool.add_liquidity([0, 0, _amount], 0);
130         } else {
131             revert InvalidToken();
132         }
133     }
134 
135     // ICurve3Pool
136     // ICurveSBTCPool
137     function _addLiquidity3AssetPool(address _poolAddress, address _token, uint256 _amount) internal {
138         ICurve3Pool _pool = ICurve3Pool(_poolAddress);
139 
140         if (_token == ETH) {
141             _wrapETH(_amount);
142             _token = WETH;
143         }
144         _approveOperations(_token, _poolAddress, _amount);
145 
146         if (_token == _pool.coins(0)) {  
147             _pool.add_liquidity([_amount, 0, 0], 0);
148         } else if (_token == _pool.coins(1)) {
149             _pool.add_liquidity([0, _amount, 0], 0);
150         } else if (_token == _pool.coins(2)) {
151             _pool.add_liquidity([0, 0, _amount], 0);
152         } else {
153             revert InvalidToken();
154         }
155     }
156 
157     // ICurveCryptoV2Pool
158     // ICurvePlainPool
159     function _addLiquidity2AssetPool(address _poolAddress, address _token, uint256 _amount) internal {
160         ICurvePool _pool = ICurvePool(_poolAddress);
161         
162         _approveOperations(_token, _poolAddress, _amount);
163         if (_token == _pool.coins(0)) {
164             _pool.add_liquidity([_amount, 0], 0);
165         } else if (_token == _pool.coins(1)) {
166             _pool.add_liquidity([0, _amount], 0);
167         } else {
168             revert InvalidToken();
169         }
170     }
171 
172     // ICurveCRVMeta - CurveBP
173     function _addLiquidityCrvMetaPool(address _poolAddress, address _token, uint256 _amount) internal {
174         ICurveCRVMeta _pool = ICurveCRVMeta(_poolAddress);
175          
176         if (_token == _pool.coins(0)) {
177             _approveOperations(_token, _poolAddress, _amount);
178             _pool.add_liquidity([_amount, 0], 0);
179         } else {
180             _addLiquidityCurveBase3Pool(CURVE_BP, _token, _amount);
181             _amount = IERC20(TRI_CRV).balanceOf(address(this));
182             _approveOperations(TRI_CRV, _poolAddress, _amount);
183             _pool.add_liquidity([0, _amount], 0);
184         }
185     }
186 
187     // ICurveFraxMeta - FraxBP
188     function _addLiquidityFraxMetaPool(address _poolAddress, address _token, uint256 _amount) internal {
189         ICurveFraxMeta _pool = ICurveFraxMeta(_poolAddress);
190         
191         if (_token == _pool.coins(0)) {
192             _approveOperations(_token, _poolAddress, _amount);
193             _pool.add_liquidity([_amount, 0], 0);
194         } else {
195             _addLiquidity2AssetPool(FRAX_BP, _token, _amount);
196             _amount = IERC20(CRV_FRAX).balanceOf(address(this));
197             _approveOperations(CRV_FRAX, _poolAddress, _amount);
198             _pool.add_liquidity([0, _amount], 0);
199         }
200     }
201 
202     // ICurveFraxCryptoMeta - FraxBP/Crypto
203     function _addLiquidityFraxCryptoMetaPool(address _poolAddress, address _token, uint256 _amount) internal {
204         ICurveFraxCryptoMeta _pool = ICurveFraxCryptoMeta(_poolAddress);
205         
206         if (_token == _pool.coins(0)) {
207             _approveOperations(_token, _poolAddress, _amount);
208             _pool.add_liquidity([_amount, 0], 0);
209         } else {
210             _addLiquidity2AssetPool(FRAX_BP, _token, _amount);
211             _amount = IERC20(CRV_FRAX).balanceOf(address(this));
212             _approveOperations(CRV_FRAX, _poolAddress, _amount);
213             _pool.add_liquidity([0, _amount], 0);
214         }
215     }
216 
217     // ICurveETHPool
218     function _addLiquidityETHPool(address _poolAddress, address _token, uint256 _amount) internal {
219         ICurveETHPool _pool = ICurveETHPool(_poolAddress);
220 
221         if (_pool.coins(0) == _token) {
222             _pool.add_liquidity{ value: _amount }([_amount, 0], 0);
223         } else if (_pool.coins(1) == _token) {
224             _approveOperations(_token, _poolAddress, _amount);
225             _pool.add_liquidity([0, _amount], 0);
226         } else {
227             revert InvalidToken();
228         }
229     }
230 
231     // ICurveCryptoETHV2Pool
232     function _addLiquidityETHV2Pool(address _poolAddress, address _token, uint256 _amount) internal {
233         ICurveCryptoETHV2Pool _pool = ICurveCryptoETHV2Pool(_poolAddress);
234 
235         if (_token == ETH) {
236             _pool.add_liquidity{ value: _amount }([_amount, 0], 0, true);
237         } else if (_token == _pool.coins(0)) {
238             _approveOperations(_token, _poolAddress, _amount);
239             _pool.add_liquidity([_amount, 0], 0, false);
240         } else if (_token == _pool.coins(1)) {
241             _approveOperations(_token, _poolAddress, _amount);
242             _pool.add_liquidity([0, _amount], 0, false);
243         } else {
244             revert InvalidToken();
245         }
246     }
247 
248     // The type of the pool:
249     // 0 - 3Pool
250     // 1 - PlainPool
251     // 2 - CryptoV2Pool
252     // 3 - CrvMetaPool
253     // 4 - FraxMetaPool
254     // 5 - ETHPool
255     // 6 - ETHV2Pool
256     // 7 - Base3Pool
257     // 8 - FraxCryptoMetaPool
258     // 9 - sUSD 4Pool
259     function _removeLiquidity(address _poolAddress, uint256 _poolType, address _token, uint256 _amount) internal returns (uint256) {
260         uint256 _before;
261         if (_token == ETH) {
262             _before = address(this).balance;
263         } else {
264             _before = IERC20(_token).balanceOf(address(this));
265         }
266         
267         if (_poolType == 0) {
268             _removeLiquidity3AssetPool(_poolAddress, _token, _amount);
269         } else if (_poolType == 1 || _poolType == 5) {
270             _removeLiquidity2AssetPool(_poolAddress, _token, _amount);
271         } else if (_poolType == 2) {
272             _removeLiquidityCryptoV2Pool(_poolAddress, _token, _amount);
273         } else if (_poolType == 3) {
274             _removeLiquidityCrvMetaPool(_poolAddress, _token, _amount);
275         } else if (_poolType == 4) {
276             _removeLiquidityFraxMetaPool(_poolAddress, _token, _amount);
277         } else if (_poolType == 6) {
278             _removeLiquidityETHV2Pool(_poolAddress, _token, _amount);
279         } else if (_poolType == 7) {
280             _removeLiquidityBase3Pool(_poolAddress, _token, _amount);
281         } else if (_poolType == 8) {
282             _removeLiquidityFraxMetaCryptoPool(_poolAddress, _token, _amount);
283         } else if (_poolType == 9) {
284             _removeLiquiditysUSD4Pool(_poolAddress, _token, _amount);
285         } else {
286             revert InvalidPoolType();
287         }
288 
289         if (_token == ETH) {
290             return address(this).balance - _before;
291         } else {
292             return IERC20(_token).balanceOf(address(this)) - _before;
293         }
294     }
295 
296     // ICurvesUSD4Pool
297     function _removeLiquiditysUSD4Pool(address _poolAddress, address _token, uint256 _amount) internal {
298         ICurvesUSD4Pool _poolWrapper = ICurvesUSD4Pool(address(0xFCBa3E75865d2d561BE8D220616520c171F12851));
299         ICurvesUSD4Pool _pool = ICurvesUSD4Pool(_poolAddress);
300 
301         _approveOperations(address(0xC25a3A3b969415c80451098fa907EC722572917F), address(_poolWrapper), _amount);
302         
303         if (_token == _pool.coins(0)) {
304             _poolWrapper.remove_liquidity_one_coin(_amount, 0, 0);
305         } else if (_token == _pool.coins(1)) {
306             _poolWrapper.remove_liquidity_one_coin(_amount, 1, 0);
307         } else if (_token == _pool.coins(2)) {
308             _poolWrapper.remove_liquidity_one_coin(_amount, 2, 0);
309         } else if (_token == _pool.coins(3)) {
310             _poolWrapper.remove_liquidity_one_coin(_amount, 3, 0);
311         } else {
312             revert InvalidToken();
313         }
314     }
315 
316     // ICurve3Pool
317     function _removeLiquidity3AssetPool(address _poolAddress, address _token, uint256 _amount) internal {
318         ICurve3Pool _pool = ICurve3Pool(_poolAddress);
319         
320         if (_token == ETH) {
321             _token = WETH;
322         }
323 
324         uint256 _before = IERC20(_token).balanceOf(address(this));
325         if (_token == _pool.coins(0)) {
326              _pool.remove_liquidity_one_coin(_amount, 0, 0);
327         } else if (_token == _pool.coins(1)) {
328             _pool.remove_liquidity_one_coin(_amount, 1, 0);
329         } else if (_token == _pool.coins(2)) {
330             _pool.remove_liquidity_one_coin(_amount, 2, 0);
331         } else {
332             revert InvalidToken();
333         }
334 
335         if (_token == WETH) {
336             _unwrapETH(IERC20(_token).balanceOf(address(this)) - _before);
337         }
338     }
339 
340     // ICurveBase3Pool
341     // ICurveSBTCPool
342     function _removeLiquidityBase3Pool(address _poolAddress, address _token, uint256 _amount) internal {
343         ICurveBase3Pool _pool = ICurveBase3Pool(_poolAddress);
344 
345         if (_token == _pool.coins(0)) {
346             _pool.remove_liquidity_one_coin(_amount, 0, 0);
347         } else if (_token == _pool.coins(1)) {
348             _pool.remove_liquidity_one_coin(_amount, 1, 0);
349         } else if (_token == _pool.coins(2)) {
350             _pool.remove_liquidity_one_coin(_amount, 2, 0);
351         } else {
352             revert InvalidToken();
353         }
354     }
355 
356     // ICurveETHPool
357     // ICurvePlainPool
358     function _removeLiquidity2AssetPool(address _poolAddress, address _token, uint256 _amount) internal {
359         ICurvePool _pool = ICurvePool(_poolAddress);
360 
361         if (_token == _pool.coins(0)) {
362             _pool.remove_liquidity_one_coin(_amount, 0, 0);
363         } else if (_token == _pool.coins(1)) {
364             _pool.remove_liquidity_one_coin(_amount, 1, 0);
365         } else {
366             revert InvalidToken();
367         }
368     }
369 
370     // ICurveCryptoV2Pool
371     function _removeLiquidityCryptoV2Pool(address _poolAddress, address _token, uint256 _amount) internal {
372         ICurveCryptoV2Pool _pool = ICurveCryptoV2Pool(_poolAddress);
373 
374         if (_token == _pool.coins(0)) {
375             _pool.remove_liquidity_one_coin(_amount, 0, 0);
376         } else if (_token == _pool.coins(1)) {
377             _pool.remove_liquidity_one_coin(_amount, 1, 0);
378         } else {
379             revert InvalidToken();
380         }
381     }
382 
383     // ICurveCryptoETHV2Pool
384     function _removeLiquidityETHV2Pool(address _poolAddress, address _token, uint256 _amount) internal {
385         ICurveCryptoETHV2Pool _pool = ICurveCryptoETHV2Pool(_poolAddress);
386         
387         if (_token == ETH) {
388             _pool.remove_liquidity_one_coin(_amount, 0, 0, true);
389         } else if (_token == _pool.coins(0)) {
390             _pool.remove_liquidity_one_coin(_amount, 0, 0, false);
391         } else if (_token == _pool.coins(1)) {
392             _pool.remove_liquidity_one_coin(_amount, 1, 0, false);
393         } else {
394             revert InvalidToken();
395         }
396     }
397 
398     // ICurveCRVMeta - CurveBP
399     function _removeLiquidityCrvMetaPool(address _poolAddress, address _token, uint256 _amount) internal {
400         ICurveCRVMeta _pool = ICurveCRVMeta(_poolAddress);
401         
402         if (_token == _pool.coins(0)) {
403             _pool.remove_liquidity_one_coin(_amount, 0, 0);
404         } else {
405             _amount = _pool.remove_liquidity_one_coin(_amount, 1, 0);
406             _removeLiquidityBase3Pool(CURVE_BP, _token, _amount);
407         }
408     }
409 
410     // ICurveFraxMeta - FraxBP/Stable
411     function _removeLiquidityFraxMetaPool(address _poolAddress, address _token, uint256 _amount) internal {
412         ICurveFraxMeta _pool = ICurveFraxMeta(_poolAddress);
413         
414         if (_token == _pool.coins(0)) {
415             _pool.remove_liquidity_one_coin(_amount, 0, 0);
416         } else {
417             _amount = _pool.remove_liquidity_one_coin(_amount, 1, 0);
418             _removeLiquidity2AssetPool(FRAX_BP, _token, _amount);
419         }
420     }
421 
422     // ICurveFraxCryptoMeta - FraxBP/Crypto
423     function _removeLiquidityFraxMetaCryptoPool(address _poolAddress, address _token, uint256 _amount) internal {
424         ICurveFraxCryptoMeta _pool = ICurveFraxCryptoMeta(_poolAddress);
425         
426         if (_token == _pool.coins(0)) {
427             _pool.remove_liquidity_one_coin(_amount, 0, 0);
428         } else {
429             _amount = _pool.remove_liquidity_one_coin(_amount, 1, 0);
430             _removeLiquidity2AssetPool(FRAX_BP, _token, _amount);
431         }
432     }
433 
434     function _wrapETH(uint256 _amount) internal {
435         IWETH(WETH).deposit{ value: _amount }();
436     }
437 
438     function _unwrapETH(uint256 _amount) internal {
439         IWETH(WETH).withdraw(_amount);
440     }
441 
442     function _approveOperations(address _token, address _spender, uint256 _amount) internal virtual {
443         IERC20(_token).safeApprove(_spender, 0);
444         IERC20(_token).safeApprove(_spender, _amount);
445     }
446 
447     /********************************** Errors **********************************/
448 
449     error InvalidToken();
450     error InvalidPoolType();
451 }