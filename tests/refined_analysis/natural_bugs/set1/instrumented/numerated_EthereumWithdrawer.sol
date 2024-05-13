1 // SPDX-License-Identifier: MIXED
2 pragma solidity 0.8.10;
3 
4 import "@uniswap/v3-core/contracts/interfaces/IUniswapV3Pool.sol";
5 import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
6 import "@sushiswap/core/contracts/uniswapv2/interfaces/IUniswapV2Pair.sol";
7 import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
8 
9 // Audit on 5-Jan-2021 by Keno and BoringCrypto
10 // Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol + Claimable.sol
11 // Edited by BoringCrypto
12 
13 contract BoringOwnableData {
14     address public owner;
15     address public pendingOwner;
16 }
17 
18 contract BoringOwnable is BoringOwnableData {
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /// @notice `owner` defaults to msg.sender on construction.
22     constructor() {
23         owner = msg.sender;
24         emit OwnershipTransferred(address(0), msg.sender);
25     }
26 
27     /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.
28     /// Can only be invoked by the current `owner`.
29     /// @param newOwner Address of the new owner.
30     /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.
31     /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.
32     function transferOwnership(
33         address newOwner,
34         bool direct,
35         bool renounce
36     ) public onlyOwner {
37         if (direct) {
38             // Checks
39             require(newOwner != address(0) || renounce, "Ownable: zero address");
40 
41             // Effects
42             emit OwnershipTransferred(owner, newOwner);
43             owner = newOwner;
44             pendingOwner = address(0);
45         } else {
46             // Effects
47             pendingOwner = newOwner;
48         }
49     }
50 
51     /// @notice Needs to be called by `pendingOwner` to claim ownership.
52     function claimOwnership() public {
53         address _pendingOwner = pendingOwner;
54 
55         // Checks
56         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
57 
58         // Effects
59         emit OwnershipTransferred(owner, _pendingOwner);
60         owner = _pendingOwner;
61         pendingOwner = address(0);
62     }
63 
64     /// @notice Only allows the `owner` to execute the function.
65     modifier onlyOwner() {
66         require(msg.sender == owner, "Ownable: caller is not the owner");
67         _;
68     }
69 }
70 
71 interface IBentoBoxV1 {
72     function balanceOf(IERC20 token, address user) external view returns (uint256 share);
73 
74     function deposit(
75         IERC20 token_,
76         address from,
77         address to,
78         uint256 amount,
79         uint256 share
80     ) external payable returns (uint256 amountOut, uint256 shareOut);
81 
82     function toAmount(
83         IERC20 token,
84         uint256 share,
85         bool roundUp
86     ) external view returns (uint256 amount);
87 
88     function toShare(
89         IERC20 token,
90         uint256 amount,
91         bool roundUp
92     ) external view returns (uint256 share);
93 
94     function transfer(
95         IERC20 token,
96         address from,
97         address to,
98         uint256 share
99     ) external;
100 
101     function withdraw(
102         IERC20 token_,
103         address from,
104         address to,
105         uint256 amount,
106         uint256 share
107     ) external returns (uint256 amountOut, uint256 shareOut);
108 }
109 
110 // License-Identifier: MIT
111 
112 interface Cauldron {
113     function accrue() external;
114 
115     function withdrawFees() external;
116 
117     function accrueInfo()
118         external
119         view
120         returns (
121             uint64,
122             uint128,
123             uint64
124         );
125 
126     function bentoBox() external returns (address);
127 
128     function setFeeTo(address newFeeTo) external;
129 
130     function feeTo() external returns (address);
131 
132     function masterContract() external returns (Cauldron);
133 }
134 
135 interface CauldronV1 {
136     function accrue() external;
137 
138     function withdrawFees() external;
139 
140     function accrueInfo() external view returns (uint64, uint128);
141 
142     function setFeeTo(address newFeeTo) external;
143 
144     function feeTo() external returns (address);
145 
146     function masterContract() external returns (CauldronV1);
147 }
148 
149 interface AnyswapRouter {
150     function anySwapOutUnderlying(
151         address token,
152         address to,
153         uint256 amount,
154         uint256 toChainID
155     ) external;
156 }
157 
158 interface CurvePool {
159     function exchange(
160         uint256 i,
161         uint256 j,
162         uint256 dx,
163         uint256 min_dy
164     ) external;
165 
166     function exchange_underlying(
167         int128 i,
168         int128 j,
169         uint256 dx,
170         uint256 min_dy,
171         address receiver
172     ) external returns (uint256);
173 }
174 
175 contract EthereumWithdrawer is BoringOwnable {
176     using SafeERC20 for IERC20;
177 
178     event SwappedMimToSpell(uint256 amountSushiswap, uint256 amountUniswap, uint256 total);
179     event MimWithdrawn(uint256 bentoxBoxAmount, uint256 degenBoxAmount, uint256 total);
180 
181     bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)
182     CurvePool public constant MIM3POOL = CurvePool(0x5a6A4D54456819380173272A5E8E9B9904BdF41B);
183     CurvePool public constant THREECRYPTO = CurvePool(0xD51a44d3FaE010294C616388b506AcdA1bfAAE46);
184     IBentoBoxV1 public constant BENTOBOX = IBentoBoxV1(0xF5BCE5077908a1b7370B9ae04AdC565EBd643966);
185     IBentoBoxV1 public constant DEGENBOX = IBentoBoxV1(0xd96f48665a1410C0cd669A88898ecA36B9Fc2cce);
186 
187     IERC20 public constant MIM = IERC20(0x99D8a9C45b2ecA8864373A26D1459e3Dff1e17F3);
188     IERC20 public constant USDT = IERC20(0xdAC17F958D2ee523a2206206994597C13D831ec7);
189     IERC20 public constant WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
190 
191     address public constant SPELL = 0x090185f2135308BaD17527004364eBcC2D37e5F6;
192     address public constant sSPELL = 0x26FA3fFFB6EfE8c1E69103aCb4044C26B9A106a9;
193 
194     address public constant MIM_PROVIDER = 0x5f0DeE98360d8200b20812e174d139A1a633EDd2;
195     address public constant TREASURY = 0x5A7C5505f3CFB9a0D9A8493EC41bf27EE48c406D;
196 
197     // Sushiswap
198     IUniswapV2Pair private constant SUSHI_SPELL_WETH = IUniswapV2Pair(0xb5De0C3753b6E1B4dBA616Db82767F17513E6d4E);
199 
200     // Uniswap V3
201     ISwapRouter private constant SWAPROUTER = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
202 
203     CauldronV1[] public bentoBoxCauldronsV1;
204     Cauldron[] public bentoBoxCauldronsV2;
205     Cauldron[] public degenBoxCauldrons;
206 
207     uint256 public treasuryShare;
208 
209     mapping(address => bool) public verified;
210 
211     constructor(
212         Cauldron[] memory bentoBoxCauldronsV2_,
213         CauldronV1[] memory bentoBoxCauldronsV1_,
214         Cauldron[] memory degenBoxCauldrons_
215     ) {
216         bentoBoxCauldronsV2 = bentoBoxCauldronsV2_;
217         bentoBoxCauldronsV1 = bentoBoxCauldronsV1_;
218         degenBoxCauldrons = degenBoxCauldrons_;
219 
220         MIM.approve(address(MIM3POOL), type(uint256).max);
221         WETH.approve(address(SWAPROUTER), type(uint256).max);
222         USDT.safeApprove(address(THREECRYPTO), type(uint256).max);
223         verified[msg.sender] = true;
224         treasuryShare = 25;
225     }
226 
227     modifier onlyVerified() {
228         require(verified[msg.sender], "Only verified operators");
229         _;
230     }
231 
232     function withdraw() public {
233         uint256 length = bentoBoxCauldronsV2.length;
234         for (uint256 i = 0; i < length; i++) {
235             require(bentoBoxCauldronsV2[i].masterContract().feeTo() == address(this), "wrong feeTo");
236 
237             bentoBoxCauldronsV2[i].accrue();
238             (, uint256 feesEarned, ) = bentoBoxCauldronsV2[i].accrueInfo();
239             if (feesEarned > (BENTOBOX.toAmount(MIM, BENTOBOX.balanceOf(MIM, address(bentoBoxCauldronsV2[i])), false))) {
240                 MIM.transferFrom(MIM_PROVIDER, address(BENTOBOX), feesEarned);
241                 BENTOBOX.deposit(MIM, address(BENTOBOX), address(bentoBoxCauldronsV2[i]), feesEarned, 0);
242             }
243 
244             bentoBoxCauldronsV2[i].withdrawFees();
245         }
246 
247         length = bentoBoxCauldronsV1.length;
248         for (uint256 i = 0; i < length; i++) {
249             require(bentoBoxCauldronsV1[i].masterContract().feeTo() == address(this), "wrong feeTo");
250 
251             bentoBoxCauldronsV1[i].accrue();
252             (, uint256 feesEarned) = bentoBoxCauldronsV1[i].accrueInfo();
253             if (feesEarned > (BENTOBOX.toAmount(MIM, BENTOBOX.balanceOf(MIM, address(bentoBoxCauldronsV1[i])), false))) {
254                 MIM.transferFrom(MIM_PROVIDER, address(BENTOBOX), feesEarned);
255                 BENTOBOX.deposit(MIM, address(BENTOBOX), address(bentoBoxCauldronsV1[i]), feesEarned, 0);
256             }
257             bentoBoxCauldronsV1[i].withdrawFees();
258         }
259 
260         length = degenBoxCauldrons.length;
261         for (uint256 i = 0; i < length; i++) {
262             require(degenBoxCauldrons[i].masterContract().feeTo() == address(this), "wrong feeTo");
263 
264             degenBoxCauldrons[i].accrue();
265             (, uint256 feesEarned, ) = degenBoxCauldrons[i].accrueInfo();
266             if (feesEarned > (DEGENBOX.toAmount(MIM, DEGENBOX.balanceOf(MIM, address(degenBoxCauldrons[i])), false))) {
267                 MIM.transferFrom(MIM_PROVIDER, address(DEGENBOX), feesEarned);
268                 DEGENBOX.deposit(MIM, address(DEGENBOX), address(degenBoxCauldrons[i]), feesEarned, 0);
269             }
270             degenBoxCauldrons[i].withdrawFees();
271         }
272 
273         uint256 mimFromBentoBoxShare = BENTOBOX.balanceOf(MIM, address(this));
274         uint256 mimFromDegenBoxShare = DEGENBOX.balanceOf(MIM, address(this));
275         withdrawFromBentoBoxes(mimFromBentoBoxShare, mimFromDegenBoxShare);
276 
277         uint256 mimFromBentoBox = BENTOBOX.toAmount(MIM, mimFromBentoBoxShare, false);
278         uint256 mimFromDegenBox = DEGENBOX.toAmount(MIM, mimFromDegenBoxShare, false);
279         emit MimWithdrawn(mimFromBentoBox, mimFromDegenBox, mimFromBentoBox + mimFromDegenBox);
280     }
281 
282     function withdrawFromBentoBoxes(uint256 amountBentoboxShare, uint256 amountDegenBoxShare) public {
283         BENTOBOX.withdraw(MIM, address(this), address(this), 0, amountBentoboxShare);
284         DEGENBOX.withdraw(MIM, address(this), address(this), 0, amountDegenBoxShare);
285     }
286 
287     function rescueTokens(
288         IERC20 token,
289         address to,
290         uint256 amount
291     ) external onlyOwner {
292         token.safeTransfer(to, amount);
293     }
294 
295     function setTreasuryShare(uint256 share) external onlyOwner {
296         treasuryShare = share;
297     }
298 
299     function swapMimForSpell(
300         uint256 amountSwapOnSushi,
301         uint256 amountSwapOnUniswap,
302         uint256 minAmountOutOnSushi,
303         uint256 minAmountOutOnUniswap,
304         bool autoDepositToSSpell
305     ) external onlyVerified {
306         require(amountSwapOnSushi > 0 || amountSwapOnUniswap > 0, "nothing to swap");
307 
308         address recipient = autoDepositToSSpell ? sSPELL : address(this);
309         uint256 minAmountToSwap = _getAmountToSwap(amountSwapOnSushi + amountSwapOnUniswap);
310         uint256 amountUSDT = MIM3POOL.exchange_underlying(0, 3, minAmountToSwap, 0, address(this));
311         THREECRYPTO.exchange(0, 2, amountUSDT, 0);
312 
313         uint256 amountWETH = WETH.balanceOf(address(this));
314         uint256 percentSushi = (amountSwapOnSushi * 100) / (amountSwapOnSushi + amountSwapOnUniswap);
315         uint256 amountWETHSwapOnSushi = (amountWETH * percentSushi) / 100;
316         uint256 amountWETHSwapOnUniswap = amountWETH - amountWETHSwapOnSushi;
317         uint256 amountSpellOnSushi;
318         uint256 amountSpellOnUniswap;
319 
320         if (amountSwapOnSushi > 0) {
321             amountSpellOnSushi = _swapOnSushiswap(amountWETHSwapOnSushi, minAmountOutOnSushi, recipient);
322         }
323 
324         if (amountSwapOnUniswap > 0) {
325             amountSpellOnUniswap = _swapOnUniswap(amountWETHSwapOnUniswap, minAmountOutOnUniswap, recipient);
326         }
327 
328         emit SwappedMimToSpell(amountSpellOnSushi, amountSpellOnUniswap, amountSpellOnSushi + amountSpellOnUniswap);
329     }
330 
331     function swapMimForSpell1Inch(address inchrouter, bytes calldata data) external onlyOwner {
332         MIM.approve(inchrouter, type(uint256).max);
333         (bool success, ) = inchrouter.call(data);
334         require(success, "1inch swap unsucessful");
335         IERC20(SPELL).safeTransfer(address(sSPELL), IERC20(SPELL).balanceOf(address(this)));
336         MIM.approve(inchrouter, 0);
337     }
338 
339     function setVerified(address operator, bool status) external onlyOwner {
340         verified[operator] = status;
341     }
342 
343     function addPool(Cauldron pool) external onlyOwner {
344         _addPool(pool);
345     }
346 
347     function addPoolV1(CauldronV1 pool) external onlyOwner {
348         bentoBoxCauldronsV1.push(pool);
349     }
350 
351     function addPools(Cauldron[] memory pools) external onlyOwner {
352         for (uint256 i = 0; i < pools.length; i++) {
353             _addPool(pools[i]);
354         }
355     }
356 
357     function _addPool(Cauldron pool) internal onlyOwner {
358         require(address(pool) != address(0), "invalid cauldron");
359 
360         if (pool.bentoBox() == address(BENTOBOX)) {
361             for (uint256 i = 0; i < bentoBoxCauldronsV2.length; i++) {
362                 require(bentoBoxCauldronsV2[i] != pool, "already added");
363             }
364             bentoBoxCauldronsV2.push(pool);
365         } else if (pool.bentoBox() == address(DEGENBOX)) {
366             for (uint256 i = 0; i < degenBoxCauldrons.length; i++) {
367                 require(degenBoxCauldrons[i] != pool, "already added");
368             }
369             degenBoxCauldrons.push(pool);
370         }
371     }
372 
373     function _getAmountOut(
374         uint256 amountIn,
375         uint256 reserveIn,
376         uint256 reserveOut
377     ) private pure returns (uint256 amountOut) {
378         uint256 amountInWithFee = amountIn * 997;
379         uint256 numerator = amountInWithFee * reserveOut;
380         uint256 denominator = (reserveIn * 1000) + amountInWithFee;
381         amountOut = numerator / denominator;
382     }
383 
384     function _swapOnSushiswap(
385         uint256 amountWETH,
386         uint256 minAmountSpellOut,
387         address recipient
388     ) private returns (uint256) {
389         (uint256 reserve0, uint256 reserve1, ) = SUSHI_SPELL_WETH.getReserves();
390         uint256 amountSpellOut = _getAmountOut(amountWETH, reserve1, reserve0);
391 
392         require(amountSpellOut >= minAmountSpellOut, "Too little received");
393 
394         WETH.transfer(address(SUSHI_SPELL_WETH), amountWETH);
395         SUSHI_SPELL_WETH.swap(amountSpellOut, 0, recipient, "");
396 
397         return amountSpellOut;
398     }
399 
400     function _swapOnUniswap(
401         uint256 amountWETH,
402         uint256 minAmountSpellOut,
403         address recipient
404     ) private returns (uint256) {
405         ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
406             tokenIn: address(WETH),
407             tokenOut: SPELL,
408             fee: 3000,
409             recipient: recipient,
410             deadline: block.timestamp,
411             amountIn: amountWETH,
412             amountOutMinimum: minAmountSpellOut,
413             sqrtPriceLimitX96: 0
414         });
415 
416         uint256 amountOut = SWAPROUTER.exactInputSingle(params);
417         return amountOut;
418     }
419 
420     function _getAmountToSwap(uint256 amount) private returns (uint256) {
421         uint256 treasuryShareAmount = (amount * treasuryShare) / 100;
422         MIM.transfer(TREASURY, treasuryShareAmount);
423         return amount - treasuryShareAmount;
424     }
425 }
