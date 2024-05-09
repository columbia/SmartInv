1 // SPDX-License-Identifier: NONE
2 
3 /** This file's constructs, patterns, and usages are proprietary.
4     No licenses are granted for any use without the
5     written permission of Todd Andrew Durica (@MooncoHodlings).
6     Any unlicensed use will be followed up by a law suit.
7 */
8 //  ███████╗██████╗  ██████╗  ██████╗ ███████╗██╗  ██╗
9 //  ██╔════╝██╔══██╗██╔═══██╗██╔════╝ ██╔════╝╚██╗██╔╝
10 //  █████╗  ██████╔╝██║   ██║██║  ███╗█████╗   ╚███╔╝
11 //  ██╔══╝  ██╔══██╗██║   ██║██║   ██║██╔══╝   ██╔██╗
12 //  ██║     ██║  ██║╚██████╔╝╚██████╔╝███████╗██╔╝ ██╗
13 //  ╚═╝     ╚═╝  ╚═╝ ╚═════╝  ╚═════╝ ╚══════╝╚═╝  ╚═╝
14 //    A (far) more efficient ETH Reflection ERC20!
15 //              Save our rainforests,
16 //                our biodiversity!
17 //                Froge revolution.
18 
19 pragma solidity 0.8.10;
20 
21 interface IWETH {
22   function deposit() external payable;
23   function transfer(address to, uint value) external returns (bool);
24   function withdraw(uint) external;
25 }
26 interface IERC20 {
27   function balanceOf(address owner) external view returns (uint);
28 }
29 interface IUniV2Factory {
30   event PairCreated(address indexed token0, address indexed token1, address pair, uint);
31   function getPair(address tokenA, address tokenB) external view returns (address pair);
32   function createPair(address tokenA, address tokenB) external returns (address pair);
33 }
34 interface IUniV2Pair {
35   event Approval(address indexed owner, address indexed spender, uint value);
36   event Transfer(address indexed from, address indexed to, uint value);
37   function name() external pure returns (string memory);
38   function symbol() external pure returns (string memory);
39   function decimals() external pure returns (uint8);
40   function totalSupply() external view returns (uint);
41   function balanceOf(address owner) external view returns (uint);
42   function allowance(address owner, address spender) external view returns (uint);
43   function approve(address spender, uint value) external returns (bool);
44   function transfer(address to, uint value) external returns (bool);
45   function transferFrom(address from, address to, uint value) external returns (bool);
46   function nonces(address owner) external view returns (uint);
47   function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
48   event Mint(address indexed sender, uint amount0, uint amount1);
49   event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
50   event Swap(address indexed sender,uint amount0In,uint amount1In,uint amount0Out,uint amount1Out,address indexed to);
51   event Sync(uint112 reserve0, uint112 reserve1);
52   function factory() external view returns (address);
53   function token0() external view returns (address);
54   function token1() external view returns (address);
55   function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
56   function mint(address to) external returns (uint liquidity);
57   function burn(address to) external returns (uint amount0, uint amount1);
58   function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
59   function initialize(address, address) external;
60 }
61 interface IUniV2Router {
62   function factory() external pure returns (address);
63   function WETH() external pure returns (address);
64   function addLiquidity(address tokenA, address tokenB, uint amountADesired, uint amountBDesired, uint amountAMin, uint amountBMin, address to, uint deadline) external returns (uint amountA, uint amountB, uint liquidity);
65   function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
66   function removeLiquidityETH(address token, uint liquidity, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external returns (uint amountToken, uint amountETH);
67   function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external returns (uint[] memory amounts);
68   /*END 01, BEGIN 02*/
69   function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
70 }
71 
72 interface IFrogeX {
73   event Transfer(address indexed from, address indexed to, uint256 value);
74   event Approval(address indexed owner, address indexed spender, uint256 value);
75   event HopEvt(uint256 indexed fxOut,uint256 indexed weiIn);
76   event LqtyEvt(uint256 indexed fxOut,uint256 indexed weiOut);
77   event MktgEvt(uint256 indexed weiOut);
78   event ChtyEvt(uint256 indexed weiOut);
79   event SetFees(
80     uint16 indexed _ttlFeePctBuys,
81     uint16 indexed _ttlFeePctSells,
82     uint8 _ethPtnChty,
83     uint8 _ethPtnMktg,
84     uint8 _tknPtnLqty,
85     uint8 _ethPtnLqty,
86     uint8 _ethPtnRwds
87   );
88   event ExcludeFromFees(address indexed account);
89   event ExcludeFromRewards(address indexed account);
90   event SetBlacklist(address indexed account, bool indexed toggle);
91   event SetLockerUnlockDate(uint32 indexed oldUnlockDate,uint32 indexed newUnlockDate);
92   event SetMinClaimableDivs(uint64 indexed newMinClaimableDivs);
93   event LockerExternalAddLiquidityETH(uint256 indexed fxTokenAmount);
94   event LockerExternalRemoveLiquidityETH(uint256 indexed lpTokenAmount);
95   event XClaim(address indexed user, uint256 indexed amount);
96   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
97   function name() external view returns (string memory);
98   function symbol() external view returns (string memory);
99   function decimals() external view returns (uint8);
100   function balanceOf(address account) external view returns (uint256);
101   function totalSupply() external view returns (uint72);
102   function xTotalSupply() external view returns (uint72);
103   function transfer(address recipient, uint256 amount) external returns (bool);
104   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
105   function approve(address spender, uint256 amount) external returns (bool);
106   function allowance(address owner_, address spender_) external view returns (uint256);
107   function increaseAllowance(address spender, uint256 addedValue) external returns (bool);
108   function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool);
109   function getUniV2Pair() external view returns (address);
110   function getUniV2Router() external view returns (address);
111   function getFXSwap() external view returns (address);
112   function getConfig() external view returns (
113     uint64 _hopThreshold, uint64 _lqtyThreshold, uint32 _lockerUnlockDate,
114     uint16 _xGasForClaim, uint64 _xMinClaimableDivs, bool   _tradingEnabled,
115     uint16 _ttlFeePctBuys, uint16 _ttlFeePctSells,
116     uint16 _ethPtnChty, uint16 _ethPtnMktg, uint16 _tknPtnLqty,
117     uint16 _ethPtnLqty, uint16 _ethPtnRwds
118   );
119   function getAccount(address account) external view returns (
120     uint256 _balance, uint256 _xDivsAvailable, uint256 _xDivsEarnedToDate, uint256 _xDivsWithdrawnToDate,
121     bool _isAMMPair, bool _isBlackListedBot, bool _isExcludedFromRwds, bool _isExcludedFromFees
122   );
123   function xGetDivsAvailable(address acct) external view returns (uint256);
124   function xGetDivsEarnedToDate(address acct) external view returns (uint256);
125   function xGetDivsWithdrawnToDate(address account) external view returns (uint88);
126   function xGetDivsGlobalTotalDist() external view returns (uint88);
127   function withdrawCharityFunds(address payable charityBeneficiary) external;
128   function withdrawMarketingFunds(address payable marketingBeneficiary) external;
129   function lockerAdvanceLock(uint32 nSeconds) external;
130   function lockerExternalAddLiquidityETH(uint256 fxTokenAmount) external payable;
131   function lockerExternalRemoveLiquidityETH(uint256 lpTokenAmount) external;
132   function activate() external;
133   function setHopThreshold(uint64 tokenAmt) external;
134   function setLqtyThreshold(uint64 weiAmt) external;
135   function setAutomatedMarketMakerPair(address pairAddr, bool toggle) external;
136   function excludeFromFees(address account) external;
137   function excludeFromRewards(address account) external;
138   function setBlackList(address account, bool toggle) external;
139   function setGasForClaim(uint16 newGasForClaim) external;
140   function burnOwnerTokens(uint256 amount) external;
141   function renounceOwnership() external;
142   function transferOwnership(address newOwner) external;
143   function xClaim() external;
144   function fxAddAirdrop (
145     address[] calldata accts, uint256[] calldata addAmts,
146     uint256 tsIncrease, uint256 xtsIncrease
147   ) external;
148   function fxSubAirdrop (
149     address[] calldata accts, uint256[] calldata subAmts,
150     uint256 tsDecrease, uint256 xtsDecrease
151   ) external;
152 }
153 //interface IFXSwap {
154 //  function swapExactTokensForETHSFOTT(uint amountIn) external;
155 //  function lockerExternalRemoveLiquidityETHReceiver(uint256 lpTokenAmount, address _owner) external;
156 //}
157 contract FXSwap {
158   IFrogeX private FX;
159   IUniV2Router private UniV2Router;
160   IUniV2Pair private UniV2Pair;
161   IWETH private WETH;
162   bool immutable private orderIsFxWeth;//always sort to FX,WETH
163   modifier onlyFX(){require(msg.sender == address(FX), "FXSwap: caller must be FX"); _;}
164   constructor(address _FX,address _UniV2Router,address _UniV2Pair,address _WETH){
165     FX = IFrogeX(_FX);
166     UniV2Router = IUniV2Router(_UniV2Router);
167     UniV2Pair = IUniV2Pair(_UniV2Pair);
168     WETH = IWETH(_WETH);
169     orderIsFxWeth = _FX<_WETH?true:false;
170   }
171   receive() external payable {
172     require(msg.sender == address(WETH), "FXSwap only accepts WETHs ETH");
173   }
174 
175   // fetches and sorts the reserves for a pair
176   function getReserves() private view returns (uint reserveA, uint reserveB) {
177     (reserveA, reserveB,) = UniV2Pair.getReserves();
178     if(!orderIsFxWeth){(reserveA, reserveB)=(reserveB, reserveA);}
179   }
180 
181   // given an input amount of an asset and pair reserves, returns the maximum output amount of the other asset
182   function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) private pure returns (uint amountOut) {
183     require(amountIn > 0, "FXSwap: INSUFFICIENT_INPUT_AMOUNT");
184     require(reserveIn > 0 && reserveOut > 0, "FXSwap: INSUFFICIENT_LIQUIDITY");
185     uint amountInWithFee = (amountIn * 997);
186     uint numerator = amountInWithFee * reserveOut;
187     uint denominator = (reserveIn * 1000) + amountInWithFee;
188     amountOut = numerator / denominator;
189   }
190 
191   function swapExactTokensForETHSFOTT() external onlyFX returns(uint amountOut){
192     (uint reserveInput, uint reserveOutput) = getReserves();
193     uint amountInput = FX.balanceOf(address(UniV2Pair)) - reserveInput;
194     uint amountOutput = getAmountOut(amountInput, reserveInput, reserveOutput);
195     UniV2Pair.swap(uint(0), amountOutput, address(this), new bytes(0));
196     amountOut = IERC20(address(WETH)).balanceOf(address(this));
197     WETH.withdraw(amountOut);
198     require(address(this).balance >= amountOut, "FXSwap:sendValue: insuff.bal");
199     (bool success,) = address(FX).call{value:amountOut}("");
200     require(success, "FXSwap:ETH_TRANSFER_FAILED");
201   }
202 
203   function lockerExternalRemoveLiquidityETHReceiver(uint256 lpTokenAmount, address _owner) external onlyFX {
204     require(UniV2Pair.balanceOf(address(FX)) >= lpTokenAmount, "FXSwap: insuff. lpt bal");
205     UniV2Pair.transferFrom(address(FX),address(UniV2Pair), lpTokenAmount);
206     //pair.burn() here sends both tokens to this contract (contrast nonETH direct to caller)
207     (uint amt0, uint amt1) = UniV2Pair.burn(address(this));
208     (uint amtFX, uint amtETH) = address(this) < address(WETH) ? (amt0, amt1) : (amt1, amt0);
209     require(FX.balanceOf(address(this)) >= amtFX, "FXSwap: insuff. frogex tokens");
210     FX.transfer(_owner,  amtFX);
211     WETH.withdraw(amtETH);
212     require(address(this).balance >= amtETH, "FXSwap:sendValue: insuff.bal");
213     (bool success,) = _owner.call{value:amtETH}("");
214     require(success, "FXSwap:ETH_TRANSFER_FAILED");
215   }
216 
217 }
218 
219 
220 /*
221   2**8     0:               256.0
222   2**16    0:            65_536.0  (65.5k)
223   2**24    0:        16_777_216.0  (16.7mn)
224   2**32    0:     4_294_967_296.0  (4.2bn)
225 
226   2**32   -9:                 4.294967296
227   2**32  -18:                 0.000000004294967296
228   2**48   -9:           281_474.976710656
229   2**48  -18:                 0.000281474976710656
230   2**56   -9:        72_057_594.037927936
231   2**56  -18:                 0.072057594037927936
232   2**64   -9:    18_446_744_073.709551616         (18.4bn)
233   2**64  -18:                18.446744073709551616
234   2**72   -9: 4_722_366_482_869.645213696         (4.7tr)
235           338824521750836606685 000000000
236   2**72  -18:             4_722.366482869645213696
237 
238   2**80   -9:                   1_208_925_819_614_629.174706176           (1.2 quadrillion)
239   2**80  -18:                               1_208_925.819614629174706176
240   2**88   -9:                 309_485_009_821_345_068.724781056           (309 quadrillion)
241   2**88  -18:                             309_485_009.821345068724781056  (309.4mn)
242   2**96   -9:              79_228_162_514_264_337_593.543950336           (79.2 quintillion)
243   2**96  -18:                          79_228_162_514.264337593543950336  (79.2bn)
244   2**128  -9: 340_282_366_920_938_463_463_374_607_431.768211456           (some crazy number)
245   2**128 -18:             340_282_366_920_938_463_463.374607431768211456  (340 quintillion)
246   2**256 115792089237316195423570985008687907853269984665640564039457584007913129639935
247 */
248 
249 contract FrogeX is IFrogeX {
250   struct AcctInfo {
251     uint128 _balance;
252     uint88 xDivsWithdrawnToDate;
253     bool isAMMPair;
254     bool isBlackListedBot;
255     bool isExcludedFromRwds;
256     bool isExcludedFromFees;//also exempts max sell limit
257     //^^ 248
258   }
259   struct Config {
260     uint64 hopThreshold;
261     uint64 lqtyThreshold;
262     uint32 lockerUnlockDate;
263     uint16 xGasForClaim;//65536 max
264     uint64 xMinClaimableDivs;//18.4 ETH max setting
265     bool tradingEnabled;// u8
266     //^^ 248
267 
268     uint16 ttlFeePctBuys;  // 500
269     uint16 ttlFeePctSells; // 800
270     uint8 ethPtnChty;    // 200
271     uint8 ethPtnMktg;    // 100
272     uint8 tknPtnLqty; // 40
273     uint8 ethPtnLqty;    // 100
274     uint8 ethPtnRwds;    // 400
275     //^^ 112
276   }
277   uint256 private xDivsPerShare;
278 
279   uint72 private _totalSupply;//must be 72+
280   uint72 private _xTotalSupply;//must be 72+
281   uint88 private xDivsGlobalTotalDist;//needs 80 or higher
282   uint8 private constant _FALSE = 1;
283   uint8 private constant _TRUE = 2;
284   uint8 private sellEvtEntrancy;
285   //^^ 256
286 
287   uint136 private constant xMagnitude = 2**128;
288   uint48 private constant xMinForDivs = 100000 * (10**9);//100k fx, u48~281_474 max
289   uint72 private pond_HOPPING_POWER;
290   //^^ 256
291 
292   uint72 private pond_ES_CHTY_LILY;
293   uint72 private pond_ES_MKTG_LILY;
294   uint72 private pond_ES_LQTY_LILY;//can be 64 if certain never over 18.4eth
295   //^^ 216
296 
297   uint64 private pond_TS_LQTY_LILY;
298   address private _owner;
299   //^^ 224
300 
301   IUniV2Router private UniV2Router;
302   IUniV2Pair private UniV2Pair;
303   IWETH private WETH;
304   FXSwap private FxSwap;
305 
306   Config private config;
307 
308   mapping(address=>AcctInfo) private _a;
309   mapping(address => mapping(address => uint256)) private _allowances;
310   mapping(address => int256) private xDivsCorrections;
311 
312   modifier onlyOwner(){require(_owner == msg.sender,"onlyOwner"); _;}
313 
314   constructor (address routerAddress, uint72 initLqtyAmt) {
315     _transferOwnership(msg.sender);
316     sellEvtEntrancy = _FALSE;
317     unchecked{config.hopThreshold = 100_000_000 * (10**9);}//100mn fx
318     unchecked{config.lqtyThreshold = 25 * (10**16);}//.25 eth
319     //to be advanced upon successful launch
320     config.lockerUnlockDate = uint32(block.timestamp);
321     config.xGasForClaim = 3000;
322     config.xMinClaimableDivs = 600_000_000_000_000;//about 5.5 USD at time of deployment
323     config.ttlFeePctBuys  =  500;
324     config.ttlFeePctSells = 800;
325 
326     config.ethPtnChty     = 20;
327     config.ethPtnMktg     = 10;
328     config.tknPtnLqty     = 6;
329     config.ethPtnLqty     = 9;
330     config.ethPtnRwds     = 40;
331 
332     IUniV2Router _uniswapV2Router = IUniV2Router(routerAddress);
333     UniV2Router = _uniswapV2Router;
334     address wethAddr = _uniswapV2Router.WETH();
335     WETH = IWETH(wethAddr);
336 
337     // Create uniswap pair
338     address pairAddr = IUniV2Factory(_uniswapV2Router.factory()).createPair(address(this), wethAddr);
339     UniV2Pair = IUniV2Pair(pairAddr);
340     _a[pairAddr].isAMMPair = true;
341 
342     FxSwap = new FXSwap(address(this),routerAddress,pairAddr,wethAddr);
343 
344     // exclude from receiving dividends
345     _a[pairAddr].isExcludedFromRwds = true;
346     _a[address(this)].isExcludedFromRwds = true;
347     _a[address(FxSwap)].isExcludedFromRwds = true;
348     _a[address(_uniswapV2Router)].isExcludedFromRwds = true;
349     _a[address(0x000000000000000000000000000000000000dEaD)].isExcludedFromRwds = true;
350     _a[address(0)].isExcludedFromRwds = true;
351 
352     // exclude from paying fees or having max transaction amount
353     _a[address(this)].isExcludedFromFees = true;
354     _a[address(FxSwap)].isExcludedFromFees = true;
355     /* _mint for liquidity pool, after which _owner tokens are burned */
356     unchecked{_totalSupply += initLqtyAmt;}
357     unchecked{_a[_owner]._balance += uint128(initLqtyAmt);}
358   }
359 
360   function withdrawCharityFunds(address payable charityBeneficiary) external onlyOwner{
361     require(charityBeneficiary != address(0), "zero address disallowed");
362     emit ChtyEvt(pond_ES_CHTY_LILY);
363     (bool success,) = charityBeneficiary.call{value: pond_ES_CHTY_LILY}("");
364     require(success, "call to beneficiary failed");
365     pond_ES_CHTY_LILY = 0;
366   }
367   function withdrawMarketingFunds(address payable marketingBeneficiary) external onlyOwner{
368     require(marketingBeneficiary != address(0), "zero address disallowed");
369     emit MktgEvt(pond_ES_MKTG_LILY);
370     (bool success,) = marketingBeneficiary.call{value: pond_ES_MKTG_LILY}("");
371     require(success, "call to beneficiary failed");
372     pond_ES_MKTG_LILY = 0;
373   }
374 
375   function _transfer(address from, address to, uint256 amount) internal {
376     require(_a[from]._balance >= amount, "insuff. balance for transfer");
377 
378     Config memory c = config;
379     require(amount > 0,"amount must be above zero");
380     require(from != address(0),"from cannot be zero address");
381     require(to != address(0),"to cannot be zero address");
382     require(!_a[to].isBlackListedBot, "nobots");
383     require(!_a[msg.sender].isBlackListedBot, "nobots");
384     require(!_a[from].isBlackListedBot, "nobots");
385 
386     // 0:buys, 1: sells, 2: xfers
387     uint txType = _a[from].isAMMPair ? 0 : _a[to].isAMMPair ? 1 : 2;
388 
389     //hardstop check
390     require(c.tradingEnabled || msg.sender == _owner, "tradingEnabled hardstop");
391 
392     // HOP / ADDLIQUIDITY
393     if(txType==1 && sellEvtEntrancy != _TRUE){
394       sellEvtEntrancy = _TRUE;
395       if(pond_ES_LQTY_LILY >= c.lqtyThreshold){
396         uint _pond_TS_LQTY = pond_TS_LQTY_LILY;
397         uint _pond_ES_LQTY = pond_ES_LQTY_LILY;
398         if(_pond_TS_LQTY == 0){
399           pond_ES_MKTG_LILY += uint72(_pond_ES_LQTY);
400           pond_ES_LQTY_LILY = 0;
401         }else{
402           lockerInternalAddLiquidityETHBlind(_pond_TS_LQTY,_pond_ES_LQTY);
403           pond_TS_LQTY_LILY = 0;
404           pond_ES_LQTY_LILY = 0;
405           emit LqtyEvt(_pond_TS_LQTY, _pond_ES_LQTY);
406         }
407       }
408       // FROGE HOP EVENT
409       else {
410         uint HOPPING_POWER = pond_HOPPING_POWER;
411         if (HOPPING_POWER >= c.hopThreshold) {
412           uint _ethPtnTotal;
413           uint _ovlPtnTotal;
414         unchecked{_ethPtnTotal = c.ethPtnChty + c.ethPtnMktg + c.ethPtnLqty + c.ethPtnRwds;}
415         unchecked{_ovlPtnTotal = _ethPtnTotal + c.tknPtnLqty;}
416           /* Set aside some tokens for liquidity.*/
417           uint magLqTknPct = (uint(c.tknPtnLqty) * 10000) / _ovlPtnTotal;
418           uint lqtyTokenAside = (HOPPING_POWER * magLqTknPct) / 10000;
419           pond_TS_LQTY_LILY += uint64(lqtyTokenAside);
420 
421           // contract itself sells its tokens and recieves ETH,
422           _transferSuper(address(this), address(UniV2Pair), (HOPPING_POWER - lqtyTokenAside));
423           uint createdEth = FxSwap.swapExactTokensForETHSFOTT();
424           emit HopEvt(HOPPING_POWER, createdEth);
425 
426           uint pond_ES_CHTY = (createdEth * c.ethPtnChty) / _ethPtnTotal;
427           uint pond_ES_MKTG = (createdEth * c.ethPtnMktg) / _ethPtnTotal;
428           uint pond_ES_LQTY = (createdEth * c.ethPtnLqty) / _ethPtnTotal;
429           uint pond_ES_RWDS = createdEth - pond_ES_CHTY - pond_ES_MKTG - pond_ES_LQTY;
430 
431           //rewards has no LILY - we assign the ETH immediately
432           xDivsPerShare += ((pond_ES_RWDS * xMagnitude) / _xTotalSupply);
433           xDivsGlobalTotalDist += uint88(pond_ES_RWDS);
434 
435           pond_ES_CHTY_LILY += uint72(pond_ES_CHTY);
436           pond_ES_MKTG_LILY += uint72(pond_ES_MKTG);
437           pond_ES_LQTY_LILY += uint72(pond_ES_LQTY);
438 
439           pond_HOPPING_POWER = 0;
440         }
441       }
442       // END: FROGE HOP EVENT
443       sellEvtEntrancy = _FALSE;
444     }
445     // SEND
446 
447     /* fees are collected as tokens held by the contract until a threshold is met.
448        fees are only split into portions during the liquidation*/
449     if (txType!=2//no fees on simple transfers
450     && !_a[from].isExcludedFromFees
451     && !_a[to].isExcludedFromFees) {
452       uint feePct = txType==0 ? c.ttlFeePctBuys : c.ttlFeePctSells;
453       uint feesAmount = (amount * feePct)/10000;
454       amount -= feesAmount;
455       pond_HOPPING_POWER += uint72(feesAmount);
456       //xTotalSupply may or may not be adjusted here
457       // depending on rewards eligibility for "from" address
458       //No xmint - contract is always excluded from rewards
459       xBurn(from, feesAmount);
460       //give our contract some tokens as a fee
461       _transferSuper(from, address(this), feesAmount);
462     }
463 
464     //perform the intended transfer, where amount may or may not have been modified via applyFees
465     xBurn(from, amount);
466     xMint(to, amount);
467     _transferSuper(from, to, amount);
468 
469     xProcessAccount(payable(from));
470     xProcessAccount(payable(to));
471   }
472   /* END transfer() */
473 
474   /* BEGIN LOCKER & LIQUIDITY OPS  */
475   function lockerAdvanceLock(uint32 nSeconds) external onlyOwner {
476     //Maximum setting: 4294967296 (February 7, 2106 6:28:16 AM)
477     uint32 oldUnlockDate = config.lockerUnlockDate;
478     uint32 newUnlockDate = oldUnlockDate + nSeconds;
479     config.lockerUnlockDate = newUnlockDate;
480     emit SetLockerUnlockDate(oldUnlockDate, newUnlockDate);
481   }
482   function lockerExternalAddLiquidityETH(uint256 fxTokenAmount) external payable onlyOwner{
483     require(fxTokenAmount>0 && msg.value>0,"must supply both fx and eth");
484     _transferSuper(_owner, address(this), fxTokenAmount);
485     lockerInternalAddLiquidityETHOptimal(fxTokenAmount,msg.value);
486     emit LockerExternalAddLiquidityETH(fxTokenAmount);
487   }
488   function lockerExternalRemoveLiquidityETH(uint256 lpTokenAmount) external onlyOwner {
489     require(config.lockerUnlockDate < block.timestamp,"unlockDate not yet reached");
490     require(UniV2Pair.balanceOf(address(this)) >= lpTokenAmount,"not enough lpt held by contract");
491     // address(this) approves FxSwap to transit to the pair contract
492     //  the specified PairToken Amount it currently holds
493     UniV2Pair.approve(address(FxSwap), lpTokenAmount /*~uint256(0)*/);
494     FxSwap.lockerExternalRemoveLiquidityETHReceiver(lpTokenAmount, _owner);
495     emit LockerExternalRemoveLiquidityETH(lpTokenAmount);
496   }
497 
498   function lockerInternalAddLiquidityETHOptimal(uint256 fxTokenAmount,uint256 weiAmount) private{
499     address addrWETH = address(WETH);
500     address addrFlowx = address(this);
501     (uint rsvFX, uint rsvETH,) = UniV2Pair.getReserves();
502     if(addrFlowx>addrWETH){(rsvFX,rsvETH)=(rsvETH,rsvFX);}
503     uint amountA;
504     uint amountB;
505     if (rsvFX == 0 && rsvETH == 0) {
506       (amountA, amountB) = (fxTokenAmount, weiAmount);
507     } else {
508       uint amountADesired = fxTokenAmount;
509       uint amountBDesired = weiAmount;
510       uint amountBOptimal = (amountADesired * rsvETH) / rsvFX;//require(amountA > 0)
511       if (amountBOptimal <= amountBDesired) {
512         (amountA, amountB) = (amountADesired, amountBOptimal);
513       }
514       else {
515         uint amountAOptimal = (amountBDesired * rsvFX) / rsvETH;//require(amountA > 0)
516         require(amountAOptimal <= amountADesired, "optimal liquidity calc failed");
517         (amountA, amountB) = (amountAOptimal, amountBDesired);
518       }
519     }
520     lockerInternalAddLiquidityETHBlind(amountA, amountB);
521   }
522   function lockerInternalAddLiquidityETHBlind(uint256 fxTokenAmount,uint256 weiAmount) private{
523     address addrPair = address(UniV2Pair);
524     address addrFlowx = address(this);
525     _transferSuper(addrFlowx,addrPair,fxTokenAmount);
526     WETH.deposit{value: weiAmount}();
527     require(WETH.transfer(addrPair, weiAmount), "failed WETH xfer to lp contract");//(address to, uint value)
528     UniV2Pair.mint(addrFlowx);
529   }
530 
531   /* END LOCKER & LIQUIDITY OPS */
532 
533   /* BEGIN FX GENERAL CONTROLS */
534   function activate() external onlyOwner {
535     config.tradingEnabled = true;}
536   function setHopThreshold(uint64 tokenAmt) external onlyOwner {
537     require(tokenAmt>=(10 * (10**9)), "out of accepted range");
538     require(tokenAmt<=(2_000_000_000 * (10**9)), "out of accepted range");
539     config.hopThreshold = tokenAmt;
540   }
541   function setLqtyThreshold(uint64 weiAmt) external onlyOwner {
542     require(weiAmt>=100, "out of accepted range");
543     config.lqtyThreshold = weiAmt;
544   }
545   function setFees (uint16 _ttlFeePctBuys, uint16 _ttlFeePctSells,
546     uint8 _ethPtnChty, uint8 _ethPtnMktg, uint8 _tknPtnLqty, uint8 _ethPtnLqty, uint8 _ethPtnRwds
547   ) external onlyOwner {
548     require(
549       _ttlFeePctBuys>=10 && _ttlFeePctBuys<=1000
550       && _ttlFeePctSells>=10 && _ttlFeePctSells<=1600,
551       "Fee pcts out of accepted range"
552     );
553     require(
554       ((_tknPtnLqty>0 && _ethPtnLqty>0)||(_tknPtnLqty==0 && _ethPtnLqty==0))
555       && _ethPtnChty<=100
556       && _ethPtnMktg<=100
557       && _tknPtnLqty<=100
558       && _ethPtnLqty<=100
559       && _ethPtnRwds<=100,
560       "Portions outside accepted range"
561     );
562     config.ttlFeePctBuys  = _ttlFeePctBuys;
563     config.ttlFeePctSells = _ttlFeePctSells;
564     config.ethPtnChty = _ethPtnChty;
565     config.ethPtnMktg = _ethPtnMktg;
566     config.tknPtnLqty = _tknPtnLqty;
567     config.ethPtnLqty = _ethPtnLqty;
568     config.ethPtnRwds = _ethPtnRwds;
569     emit SetFees(_ttlFeePctBuys, _ttlFeePctSells, _ethPtnChty, _ethPtnMktg, _tknPtnLqty, _ethPtnLqty, _ethPtnRwds);
570   }
571   function setAutomatedMarketMakerPair(address pairAddr, bool toggle) external onlyOwner {
572     require(pairAddr != address(UniV2Pair),"original pair is constant");
573     require(_a[pairAddr].isAMMPair != toggle,"setting already exists");
574     _a[pairAddr].isAMMPair = toggle;
575     if(toggle && !_a[pairAddr].isExcludedFromRwds){
576       _excludeFromRewards(pairAddr);
577     }
578   }
579   function excludeFromFees(address account) external onlyOwner {
580     require(!_a[account].isExcludedFromFees,"already excluded");
581     _a[account].isExcludedFromFees = true;
582     emit ExcludeFromFees(account);
583   }
584   function excludeFromRewards(address account) external onlyOwner {
585     _excludeFromRewards(account);
586   }
587   function _excludeFromRewards(address account) private onlyOwner {
588     //irreversibly and completely removes from rewards mechanism
589     require(!_a[account].isExcludedFromRwds,"already excluded");
590     _a[account].isExcludedFromRwds = true;
591     xProcessAccount(payable(account));
592     if(_a[account]._balance>xMinForDivs){
593       _xTotalSupply -= uint72(_a[account]._balance);
594       delete xDivsCorrections[account];
595     }
596     emit ExcludeFromRewards(account);
597   }
598   function setBlackList(address account, bool toggle) external onlyOwner {
599     if(toggle) {
600       require(account != address(UniV2Router)
601       && account != address(UniV2Pair)
602       && account != address(FxSwap)
603       && account != address(_owner)
604       ,"ineligible for blacklist");
605       _a[account].isBlackListedBot = true;
606     }else{_a[account].isBlackListedBot = false;}
607     emit SetBlacklist(account, toggle);
608   }
609   function setGasForClaim(uint16 newGasForClaim) external onlyOwner {
610     require(newGasForClaim>3000,"not enough gasForClaim");
611     config.xGasForClaim = uint16(newGasForClaim);
612   }
613   function setMinClaimableDivs(uint64 newMinClaimableDivs) external onlyOwner {
614     require(newMinClaimableDivs>0,"out of accepted range");
615     config.xMinClaimableDivs = newMinClaimableDivs;
616     emit SetMinClaimableDivs(newMinClaimableDivs);
617   }
618   function getConfig() external view returns (
619     uint64 _hopThreshold, uint64 _lqtyThreshold, uint32 _lockerUnlockDate,
620     uint16 _xGasForClaim, uint64 _xMinClaimableDivs, bool   _tradingEnabled,
621     uint16 _ttlFeePctBuys, uint16 _ttlFeePctSells,
622     uint16 _ethPtnChty, uint16 _ethPtnMktg, uint16 _tknPtnLqty,
623     uint16 _ethPtnLqty, uint16 _ethPtnRwds
624   ) {
625     Config memory c = config;
626     _hopThreshold = c.hopThreshold;
627     _lqtyThreshold = c.lqtyThreshold;
628     _lockerUnlockDate = c.lockerUnlockDate;
629     _xGasForClaim = c.xGasForClaim;
630     _xMinClaimableDivs = c.xMinClaimableDivs;
631     _tradingEnabled = c.tradingEnabled;
632     _ttlFeePctBuys = c.ttlFeePctBuys;
633     _ttlFeePctSells = c.ttlFeePctSells;
634     _ethPtnChty = c.ethPtnChty;
635     _ethPtnMktg = c.ethPtnMktg;
636     _tknPtnLqty = c.tknPtnLqty;
637     _ethPtnLqty = c.ethPtnLqty;
638     _ethPtnRwds = c.ethPtnRwds;
639   }
640   function getAccount(address account) external view returns (
641     uint256 _balance, uint256 _xDivsAvailable, uint256 _xDivsEarnedToDate, uint256 _xDivsWithdrawnToDate,
642     bool _isAMMPair, bool _isBlackListedBot, bool _isExcludedFromRwds, bool _isExcludedFromFees
643   ){
644     _balance = _a[account]._balance;
645     _xDivsAvailable = xDivsAvailable(account);
646     _xDivsEarnedToDate = xDivsEarnedToDate(account);
647     _xDivsWithdrawnToDate = _a[account].xDivsWithdrawnToDate;
648     _isAMMPair = _a[account].isAMMPair;
649     _isBlackListedBot = _a[account].isBlackListedBot;
650     _isExcludedFromRwds = _a[account].isExcludedFromRwds;
651     _isExcludedFromFees = _a[account].isExcludedFromFees;
652   }
653   function xGetDivsAvailable(address acct) external view returns (uint256){
654     return xDivsAvailable(acct);
655   }
656   function xGetDivsEarnedToDate(address acct) external view returns (uint256){
657     return xDivsEarnedToDate(acct);
658   }
659   function xGetDivsWithdrawnToDate(address account) external view returns (uint88){
660     return _a[account].xDivsWithdrawnToDate;
661   }
662   function xGetDivsGlobalTotalDist() external view returns (uint88){
663     return xDivsGlobalTotalDist;
664   }
665   function getUniV2Pair() external view returns (address){return address(UniV2Pair);}
666   function getUniV2Router() external view returns (address){return address(UniV2Router);}
667   function getFXSwap() external view returns (address){return address(FxSwap);}
668 
669   function burnOwnerTokens(uint256 amount) external onlyOwner {
670     _burn(msg.sender, amount);
671   }
672   /*********BEGIN ERC20**********/
673   function name() external pure returns (string memory) {return "FrogeX";}
674   function symbol() external pure returns (string memory) {return "FROGEX";}
675   function decimals() external pure returns (uint8) {return 9;}
676   function owner() external view returns (address) {return _owner;}
677   function totalSupply() external view returns (uint72) {return _totalSupply;}
678   function xTotalSupply() external view returns (uint72) {return _xTotalSupply;}
679   function balanceOf(address account) external view returns (uint256) {
680     return uint256(_a[account]._balance);
681   }
682   function transfer(address recipient, uint256 amount) external returns (bool) {
683     _transfer(msg.sender, recipient, amount); return true;
684   }
685   function allowance(address owner_, address spender_) external view returns (uint256) {
686     return _allowances[owner_][spender_];
687   }
688   function approve(address spender, uint256 amount) external returns (bool) {
689     _approve(msg.sender, spender, amount); return true;
690   }
691   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool) {
692     _transfer(sender, recipient, amount);
693     uint256 currentAllowance = _allowances[sender][msg.sender];
694     require(currentAllowance >= amount, "amount exceeds allowance");
695   unchecked {
696     _approve(sender, msg.sender, currentAllowance - amount);
697   }
698     return true;
699   }
700   function increaseAllowance(address spender, uint256 addedValue) external returns (bool) {
701     _approve(msg.sender, spender, _allowances[msg.sender][spender] + addedValue);
702     return true;
703   }
704   function decreaseAllowance(address spender, uint256 subtractedValue) external returns (bool) {
705     uint256 currentAllowance = _allowances[msg.sender][spender];
706     require(currentAllowance >= subtractedValue, "decreased allowance below zero");
707   unchecked {
708     _approve(msg.sender, spender, currentAllowance - subtractedValue);
709   }
710     return true;
711   }
712   function _transferSuper(address sender, address recipient, uint256 amount) private {
713     require(sender != address(0), "transfer from the zero address");
714     require(recipient != address(0), "transfer to the zero address");
715     uint256 senderBalance = _a[sender]._balance;
716     require(senderBalance >= amount, "transfer amount exceeds balance");
717   unchecked {
718     _a[sender]._balance = uint128(senderBalance - amount);
719   }
720     _a[recipient]._balance += uint128(amount);
721     emit Transfer(sender, recipient, amount);
722   }
723   function _burn(address account, uint256 amount) private {
724     require(account != address(0), "burn from the zero address");
725     uint256 accountBalance = _a[account]._balance;
726     require(accountBalance >= amount, "burn amount exceeds balance");
727   unchecked {
728     _a[account]._balance = uint128(accountBalance - amount);
729   }
730     _totalSupply -= uint72(amount);
731     emit Transfer(account, address(0), amount);
732   }
733   function _approve(address owner_, address spender_, uint256 amount) private {
734     require(owner_ != address(0), "approve from zero address");
735     require(spender_ != address(0), "approve to zero address");
736     _allowances[owner_][spender_] = amount;
737     emit Approval(owner_, spender_, amount);
738   }
739   /*********END ERC20**********/
740 
741   /*********BEGIN OWNABLE**********/
742   function renounceOwnership() external onlyOwner {
743     _transferOwnership(address(0));
744   }
745   function transferOwnership(address newOwner) external onlyOwner {
746     require(newOwner != address(0), "FxOwn: no zero address");
747     require(newOwner != address(_owner), "FxOwn: already owner");
748     _transferOwnership(newOwner);
749   }
750   function _transferOwnership(address newOwner) private {
751     address oldOwner = _owner;
752     _a[newOwner].isExcludedFromRwds = true;
753     _a[newOwner].isExcludedFromFees = true;
754     _owner = newOwner;
755     emit OwnershipTransferred(oldOwner, newOwner);
756   }
757   /*********END OWNABLE**********/
758 
759   /*********REWARDS FUNCTIONALITY**********/
760 
761   receive() external payable {
762     require(_xTotalSupply > 0,"X GON GIVE IT TO YA");
763     if (msg.value > 0 && msg.sender != address(FxSwap) && msg.sender != address(UniV2Router)) {
764       xDivsPerShare = xDivsPerShare + ((msg.value * xMagnitude) / _xTotalSupply);
765       xDivsGlobalTotalDist += uint88(msg.value);
766     }
767   }
768 
769   function xDivsAvailable(address acct) private view returns (uint256){
770     return xDivsEarnedToDate(acct) - uint256(_a[acct].xDivsWithdrawnToDate);
771   }
772   function xDivsEarnedToDate(address acct) private view returns (uint256){
773     uint256 currShare =
774     (_a[acct].isExcludedFromRwds||_a[acct]._balance<xMinForDivs)
775         ?0:_a[acct]._balance;
776     return uint256(
777       int256(xDivsPerShare * currShare) +
778       xDivsCorrections[acct]
779     ) / xMagnitude;
780   }
781 
782   //xMint MUST be called BEFORE intended updates to balances
783   function xMint(address acct, uint256 mintAmt) private {
784     if(!_a[acct].isExcludedFromRwds){
785       uint256 acctSrcBal = _a[acct]._balance;
786       if((acctSrcBal + mintAmt) > xMinForDivs){
787         mintAmt += (acctSrcBal<xMinForDivs)?acctSrcBal:0;
788         _xTotalSupply += uint72(mintAmt);
789         xDivsCorrections[acct] -= int256(xDivsPerShare * mintAmt);
790       }
791     }
792   }
793   //xBurn MUST be called BEFORE intended updates to balances
794   function xBurn(address acct, uint256 burnAmt) private {
795     if(!_a[acct].isExcludedFromRwds){
796       uint256 acctSrcBal = _a[acct]._balance;
797       if(acctSrcBal > xMinForDivs){
798         uint256 acctDestBal = acctSrcBal - burnAmt;
799         burnAmt += (acctDestBal<xMinForDivs)?acctDestBal:0;
800         _xTotalSupply -= uint72(burnAmt);
801         xDivsCorrections[acct] += int256(xDivsPerShare * burnAmt);
802       }
803     }
804   }
805 
806   function xProcessAccount(address payable account) private returns (bool successful){
807     uint256 _divsAvailable = xDivsAvailable(account);
808     if (_divsAvailable > config.xMinClaimableDivs) {
809       _a[account].xDivsWithdrawnToDate = uint88(_a[account].xDivsWithdrawnToDate + _divsAvailable);
810       emit XClaim(account, _divsAvailable);
811       (bool success,) = account.call{value: _divsAvailable, gas: config.xGasForClaim}("");
812       if (success) {
813         return true;
814       }else{
815         _a[account].xDivsWithdrawnToDate = uint88(_a[account].xDivsWithdrawnToDate - _divsAvailable);
816         return false;
817       }
818     }else{return false;}
819   }
820   function xClaim() external {
821     xProcessAccount(payable(msg.sender));
822   }
823 
824   function fxAddAirdrop (
825     address[] calldata accts, uint256[] calldata addAmts,
826     uint256 tsIncrease, uint256 xtsIncrease
827   ) external {
828     require(_owner == msg.sender && !config.tradingEnabled,"onlyOwner and pre-launch");
829     for (uint i; i < accts.length; i++) {
830       unchecked{_a[accts[i]]._balance += uint128(addAmts[i]);}
831     }
832     unchecked{_totalSupply += uint72(tsIncrease);}
833     unchecked{_xTotalSupply += uint72(xtsIncrease);}
834   }
835   function fxSubAirdrop (
836     address[] calldata accts, uint256[] calldata subAmts,
837     uint256 tsDecrease, uint256 xtsDecrease
838   ) external {
839     require(_owner == msg.sender && !config.tradingEnabled,"onlyOwner and pre-launch");
840     for (uint i; i < accts.length; i++) {
841       unchecked{_a[accts[i]]._balance -= uint128(subAmts[i]);}
842     }
843     unchecked{_totalSupply -= uint72(tsDecrease);}
844     unchecked{_xTotalSupply -= uint72(xtsDecrease);}
845   }
846 
847 }