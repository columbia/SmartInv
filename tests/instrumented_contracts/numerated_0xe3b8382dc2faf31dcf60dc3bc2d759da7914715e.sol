1 // File: contracts\GFarmTokenInterface.sol
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity 0.7.5;
5 
6 interface GFarmTokenInterface{
7 	function balanceOf(address account) external view returns (uint256);
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9     function transfer(address to, uint256 value) external returns (bool);
10     function approve(address spender, uint256 value) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint256);
12     function burn(address from, uint256 amount) external;
13     function mint(address to, uint256 amount) external;
14 }
15 
16 // File: contracts\GFarmNFTInterface.sol
17 
18 pragma solidity 0.7.5;
19 
20 interface GFarmNFTInterface{
21     function balanceOf(address owner) external view returns (uint256 balance);
22     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
23     function getLeverageFromID(uint id) external view returns(uint16);
24     function leverageID(uint16 _leverage) external pure returns(uint16);
25 }
26 
27 // File: @openzeppelin\contracts\math\SafeMath.sol
28 
29 pragma solidity ^0.7.0;
30 
31 /**
32  * @dev Wrappers over Solidity's arithmetic operations with added overflow
33  * checks.
34  *
35  * Arithmetic operations in Solidity wrap on overflow. This can easily result
36  * in bugs, because programmers usually assume that an overflow raises an
37  * error, which is the standard behavior in high level programming languages.
38  * `SafeMath` restores this intuition by reverting the transaction when an
39  * operation overflows.
40  *
41  * Using this library instead of the unchecked operations eliminates an entire
42  * class of bugs, so it's recommended to use it always.
43  */
44 library SafeMath {
45     /**
46      * @dev Returns the addition of two unsigned integers, reverting on
47      * overflow.
48      *
49      * Counterpart to Solidity's `+` operator.
50      *
51      * Requirements:
52      *
53      * - Addition cannot overflow.
54      */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58 
59         return c;
60     }
61 
62     /**
63      * @dev Returns the subtraction of two unsigned integers, reverting on
64      * overflow (when the result is negative).
65      *
66      * Counterpart to Solidity's `-` operator.
67      *
68      * Requirements:
69      *
70      * - Subtraction cannot overflow.
71      */
72     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
73         return sub(a, b, "SafeMath: subtraction overflow");
74     }
75 
76     /**
77      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
78      * overflow (when the result is negative).
79      *
80      * Counterpart to Solidity's `-` operator.
81      *
82      * Requirements:
83      *
84      * - Subtraction cannot overflow.
85      */
86     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89 
90         return c;
91     }
92 
93     /**
94      * @dev Returns the multiplication of two unsigned integers, reverting on
95      * overflow.
96      *
97      * Counterpart to Solidity's `*` operator.
98      *
99      * Requirements:
100      *
101      * - Multiplication cannot overflow.
102      */
103     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
104         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
105         // benefit is lost if 'b' is also tested.
106         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
107         if (a == 0) {
108             return 0;
109         }
110 
111         uint256 c = a * b;
112         require(c / a == b, "SafeMath: multiplication overflow");
113 
114         return c;
115     }
116 
117     /**
118      * @dev Returns the integer division of two unsigned integers. Reverts on
119      * division by zero. The result is rounded towards zero.
120      *
121      * Counterpart to Solidity's `/` operator. Note: this function uses a
122      * `revert` opcode (which leaves remaining gas untouched) while Solidity
123      * uses an invalid opcode to revert (consuming all remaining gas).
124      *
125      * Requirements:
126      *
127      * - The divisor cannot be zero.
128      */
129     function div(uint256 a, uint256 b) internal pure returns (uint256) {
130         return div(a, b, "SafeMath: division by zero");
131     }
132 
133     /**
134      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
135      * division by zero. The result is rounded towards zero.
136      *
137      * Counterpart to Solidity's `/` operator. Note: this function uses a
138      * `revert` opcode (which leaves remaining gas untouched) while Solidity
139      * uses an invalid opcode to revert (consuming all remaining gas).
140      *
141      * Requirements:
142      *
143      * - The divisor cannot be zero.
144      */
145     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b > 0, errorMessage);
147         uint256 c = a / b;
148         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
155      * Reverts when dividing by zero.
156      *
157      * Counterpart to Solidity's `%` operator. This function uses a `revert`
158      * opcode (which leaves remaining gas untouched) while Solidity uses an
159      * invalid opcode to revert (consuming all remaining gas).
160      *
161      * Requirements:
162      *
163      * - The divisor cannot be zero.
164      */
165     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
166         return mod(a, b, "SafeMath: modulo by zero");
167     }
168 
169     /**
170      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
171      * Reverts with custom message when dividing by zero.
172      *
173      * Counterpart to Solidity's `%` operator. This function uses a `revert`
174      * opcode (which leaves remaining gas untouched) while Solidity uses an
175      * invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b != 0, errorMessage);
183         return a % b;
184     }
185 }
186 
187 // File: @uniswap\v2-core\contracts\interfaces\IUniswapV2Pair.sol
188 
189 pragma solidity >=0.5.0;
190 
191 interface IUniswapV2Pair {
192     event Approval(address indexed owner, address indexed spender, uint value);
193     event Transfer(address indexed from, address indexed to, uint value);
194 
195     function name() external pure returns (string memory);
196     function symbol() external pure returns (string memory);
197     function decimals() external pure returns (uint8);
198     function totalSupply() external view returns (uint);
199     function balanceOf(address owner) external view returns (uint);
200     function allowance(address owner, address spender) external view returns (uint);
201 
202     function approve(address spender, uint value) external returns (bool);
203     function transfer(address to, uint value) external returns (bool);
204     function transferFrom(address from, address to, uint value) external returns (bool);
205 
206     function DOMAIN_SEPARATOR() external view returns (bytes32);
207     function PERMIT_TYPEHASH() external pure returns (bytes32);
208     function nonces(address owner) external view returns (uint);
209 
210     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
211 
212     event Mint(address indexed sender, uint amount0, uint amount1);
213     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
214     event Swap(
215         address indexed sender,
216         uint amount0In,
217         uint amount1In,
218         uint amount0Out,
219         uint amount1Out,
220         address indexed to
221     );
222     event Sync(uint112 reserve0, uint112 reserve1);
223 
224     function MINIMUM_LIQUIDITY() external pure returns (uint);
225     function factory() external view returns (address);
226     function token0() external view returns (address);
227     function token1() external view returns (address);
228     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
229     function price0CumulativeLast() external view returns (uint);
230     function price1CumulativeLast() external view returns (uint);
231     function kLast() external view returns (uint);
232 
233     function mint(address to) external returns (uint liquidity);
234     function burn(address to) external returns (uint amount0, uint amount1);
235     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
236     function skim(address to) external;
237     function sync() external;
238 
239     function initialize(address, address) external;
240 }
241 
242 // File: contracts\GFarmTrading.sol
243 
244 pragma solidity 0.7.5;
245 
246 
247 
248 
249 
250 contract GFarmTrading{
251 
252     using SafeMath for uint;
253 
254     // Tokens
255     GFarmTokenInterface immutable token;
256     IUniswapV2Pair immutable gfarmEthPair;
257     GFarmNFTInterface immutable nft;
258 
259     // Trading
260     uint constant MAX_GAIN_P = 900; // 10x
261     uint constant STOP_LOSS_P = 90; // liquidated when -90% => 10% reward
262     uint constant PRECISION = 1e5;  // computations decimals
263 
264     // Important uniswap addresses / pairs
265 	address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
266     IUniswapV2Pair constant ethDaiPair = IUniswapV2Pair(0xA478c2975Ab1Ea89e8196811F51A7B7Ade33eB11);
267     IUniswapV2Pair constant ethUsdtPair = IUniswapV2Pair(0x0d4a11d5EEaaC28EC3F61d100daF4d40471f1852);
268     IUniswapV2Pair constant ethUsdcPair = IUniswapV2Pair(0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc);
269 
270     // Dev fund
271     address public immutable DEV_FUND;
272     uint constant DEV_FUND_FEE_P = 1;
273 
274     // Info about each trade
275     struct Trade{
276         uint openBlock;
277         address initiator;
278         bool buy; // True = up, False = down
279         uint openPrice; // divide by PRECISION for real price
280         uint ethPositionSize; // in wei
281         uint16 leverage; // Used for custom leverage if user has the corresponding NFT
282     }
283     mapping(address => Trade) public trades;
284 
285     // Info about each user gains
286     struct Gains{
287         uint value; // Divide by PRECISION for real value
288         uint lastTradeClosed;
289     }
290     mapping(address => Gains) public gains;
291 
292     // Useful to list open trades & trades that can be liquidated
293     address[] public addressesTradeOpen;
294     mapping(address => uint) private addressTradeOpenID;
295 
296     /*uint public fakeEthDaiPrice = 200*PRECISION;
297     uint public fakeEthDaiReserve = 100*1e18;
298     uint public fakeEthUsdtPrice = 300*PRECISION;
299     uint public fakeEthUsdtReserve = 200*1e18;
300     uint public fakeEthUsdcPrice = 400*PRECISION;
301     uint public fakeEthUsdcReserve = 300*1e18;
302     uint public fakeGFarmEthPrice = 10000;
303     uint public fakeBlockNumber; // REPLACE EVERYWHERE BY BLOCK.NUMBER*/
304 
305     constructor(
306         GFarmTokenInterface _token,
307         IUniswapV2Pair _gfarmEthPair,
308         GFarmNFTInterface _nft){
309 
310         token = _token;
311         gfarmEthPair = _gfarmEthPair;
312         nft = _nft;
313         DEV_FUND = msg.sender;
314 
315         //fakeBlockNumber = block.number;
316     }
317 
318     /*function increaseBlock(uint b) external { fakeBlockNumber += b; }
319     function decreaseBlock(uint b) external { fakeBlockNumber -= b; }
320     function setFakeEthDaiInfo(uint p, uint r) external { fakeEthDaiPrice = p; fakeEthDaiReserve = r; }
321     function setFakeEthUsdtInfo(uint p, uint r) external { fakeEthUsdtPrice = p; fakeEthUsdtReserve = r; }
322     function setFakeEthUsdcInfo(uint p, uint r) external { fakeEthUsdcPrice = p; fakeEthUsdcReserve = r; }
323     function setFakeGFarmEthPrice(uint p) external { fakeGFarmEthPrice = p; }*/
324     
325     // PRICING FUNCTIONS
326 
327     // Get current ETH price from ETH/DAI pool and current ETH reserve
328     // Divide price by PRECISION for real value
329     function pairInfoDAI() private view returns(uint, uint){
330         (uint112 reserves0, uint112 reserves1, ) = ethDaiPair.getReserves();
331         uint reserveDAI;
332         uint reserveETH;
333         if(WETH == ethDaiPair.token0()){
334             reserveETH = reserves0;
335             reserveDAI = reserves1;
336         }else{
337             reserveDAI = reserves0;
338             reserveETH = reserves1;
339         }
340         // Divide number of DAI by number of ETH
341         return (reserveDAI.mul(PRECISION).div(reserveETH), reserveETH);
342         
343         //return (fakeEthDaiPrice, fakeEthDaiReserve);
344     }
345     // Get current ETH price from ETH/USDT pool and current ETH reserve
346     // Divide price by PRECISION for real value
347     function pairInfoUSDT() private view returns(uint, uint){
348         (uint112 reserves0, uint112 reserves1, ) = ethUsdtPair.getReserves();
349         uint reserveUSDT;
350         uint reserveETH;
351         if(WETH == ethUsdtPair.token0()){
352             reserveETH = reserves0;
353             reserveUSDT = reserves1;
354         }else{
355             reserveUSDT = reserves0;
356             reserveETH = reserves1;
357         }
358         // Divide number of USDT by number of ETH
359         // we multiply by 1e12 because USDT only has 6 decimals
360         return (reserveUSDT.mul(1e12).mul(PRECISION).div(reserveETH), reserveETH);
361     
362         //return (fakeEthUsdtPrice, fakeEthUsdtReserve);
363     }
364     // Get current ETH price from ETH/USDC pool and current ETH reserve
365     // Divide price by PRECISION for real value
366     function pairInfoUSDC() private view returns(uint, uint){
367         (uint112 reserves0, uint112 reserves1, ) = ethUsdcPair.getReserves();
368         uint reserveUSDC;
369         uint reserveETH;
370         if(WETH == ethUsdcPair.token0()){
371             reserveETH = reserves0;
372             reserveUSDC = reserves1;
373         }else{
374             reserveUSDC = reserves0;
375             reserveETH = reserves1;
376         }
377         // Divide number of USDC by number of ETH
378         // we multiply by 1e12 because USDC only has 6 decimals
379         return (reserveUSDC.mul(1e12).mul(PRECISION).div(reserveETH), reserveETH);
380     
381         //return (fakeEthUsdcPrice, fakeEthUsdcReserve);
382     }
383     // Get current Ethereum price as a weighted average of the 3 pools based on liquidity
384     // Divide by PRECISION for real value
385     function getEthPrice() public view returns(uint){
386         (uint priceEthDAI, uint reserveEthDAI) = pairInfoDAI();
387         (uint priceEthUSDT, uint reserveEthUSDT) = pairInfoUSDT();
388         (uint priceEthUSDC, uint reserveEthUSDC) = pairInfoUSDC();
389 
390         uint reserveEth = reserveEthDAI.add(reserveEthUSDT).add(reserveEthUSDC);
391 
392     	return (
393                 priceEthDAI.mul(reserveEthDAI).add(
394                     priceEthUSDT.mul(reserveEthUSDT)
395                 ).add(
396                     priceEthUSDC.mul(reserveEthUSDC)
397                 )
398             ).div(reserveEth);
399     }
400     // Get current GFarm price in ETH from the Uniswap pool
401     // Divide by precision for real value
402     function getGFarmPriceEth() private view returns(uint){
403         (uint112 reserves0, uint112 reserves1, ) = gfarmEthPair.getReserves();
404 
405         uint reserveETH;
406         uint reserveGFARM;
407 
408         if(WETH == gfarmEthPair.token0()){
409             reserveETH = reserves0;
410             reserveGFARM = reserves1;
411         }else{
412             reserveGFARM = reserves0;
413             reserveETH = reserves1;
414         }
415 
416         // Divide number of ETH by number of GFARM
417         return reserveETH.mul(PRECISION).div(reserveGFARM);
418 
419         //return fakeGFarmEthPrice;
420     }
421 
422     // MAX GFARM POS (important for security)
423 
424     // Maximum position size in GFARM
425     function getMaxPosGFARM() public view returns(uint){
426         (, uint reserveEthDAI) = pairInfoDAI();
427         (, uint reserveEthUSDT) = pairInfoUSDT();
428         (, uint reserveEthUSDC) = pairInfoUSDC();
429 
430         uint totalReserveETH = reserveEthDAI.add(reserveEthUSDT).add(reserveEthUSDC);
431         uint sqrt10 = 3162277660168379331; // 1e18 precision
432 
433         return totalReserveETH.mul(sqrt10).sub(totalReserveETH.mul(1e18)).div(getGFarmPriceEth().mul(750000)).div(1e18/PRECISION);
434     }
435 
436     // PRIVATE FUNCTIONS
437     
438     // Divide by PRECISION for real value
439     function percentDiff(uint a, uint b) private pure returns(int){
440         return (int(b) - int(a))*100*int(PRECISION)/int(a);
441     }
442     // Divide by PRECISION for real value
443     function currentPercentProfit(uint _openPrice, uint _currentPrice, bool _buy, uint16 _leverage) private pure returns(int p){
444         if(_buy){
445             p = percentDiff(_openPrice, _currentPrice)*int(_leverage);
446         }else{
447         	p = percentDiff(_openPrice, _currentPrice)*(-1)*int(_leverage);
448         }
449         int maxLossPercentage = -100 * int(PRECISION);
450         int maxGainPercentage = int(MAX_GAIN_P * PRECISION);
451         if(p < maxLossPercentage){
452             p = maxLossPercentage;
453         }else if(p > maxGainPercentage){
454         	p = maxGainPercentage;
455         }
456     }
457     function canLiquidatePure(uint _openPrice, uint _currentPrice, bool _buy, uint16 _leverage) private pure returns(bool){
458         if(_buy){
459             return currentPercentProfit(_openPrice, _currentPrice, _buy, _leverage) <= (-1)*int(STOP_LOSS_P*PRECISION);
460         }else{
461             return currentPercentProfit(_openPrice, _currentPrice, _buy, _leverage) <= (-1)*int(STOP_LOSS_P*PRECISION);
462         }
463     }
464     // Remove trade from list of open trades (useful to list liquidations)
465     function unregisterOpenTrade(address a) private{
466         delete trades[a];
467 
468         if(addressesTradeOpen.length > 1){
469             addressesTradeOpen[addressTradeOpenID[a]] = addressesTradeOpen[addressesTradeOpen.length - 1];
470             addressTradeOpenID[addressesTradeOpen[addressesTradeOpen.length - 1]] = addressTradeOpenID[a];
471         }
472 
473         addressesTradeOpen.pop();
474         delete addressTradeOpenID[a];
475     }
476 
477     // PUBLIC FUNCTIONS (used internally and externally)
478 
479     function hasOpenTrade(address a) public view returns(bool){
480         return trades[a].openBlock != 0;
481     }
482     function canLiquidate(address a) public view returns(bool){
483         require(hasOpenTrade(a), "This address has no open trade.");
484         Trade memory t = trades[a];
485         return canLiquidatePure(t.openPrice, getEthPrice(), t.buy, t.leverage);
486     }
487     // Compute position size in GFARM based on GFARM/ETH price and ETH position size
488     function positionSizeGFARM(address a) public view returns(uint){
489         return trades[a].ethPositionSize.mul(PRECISION).div(getGFarmPriceEth());
490     }
491     // Token PNL in GFARM
492     function myTokenPNL() public view returns(int){
493         if(!hasOpenTrade(msg.sender)){ return 0; }
494         Trade memory t = trades[msg.sender];
495         return int(positionSizeGFARM(msg.sender)) * currentPercentProfit(t.openPrice, getEthPrice(), t.buy, t.leverage) / int(100*PRECISION);
496     }
497     // Amount you get when liquidating trade open by an address (GFARM)
498     function liquidateAmountGFARM(address a) public view returns(uint){
499         return positionSizeGFARM(a).mul((100 - STOP_LOSS_P)).div(100);
500     }
501     function myNftsCount() public view returns(uint){
502         return nft.balanceOf(msg.sender);
503     }
504 
505     // EXTERNAL TRADING FUNCTIONS
506     
507     function openTrade(bool _buy, uint _positionSize, uint16 _leverage) external{
508         require(!hasOpenTrade(msg.sender), "You can only have 1 trade open at a time.");
509         require(_positionSize > 0, "Opening a trade with 0 tokens.");
510         require(_positionSize <= getMaxPosGFARM(), "Your position size exceeds the max authorized position size.");
511 
512         if(_leverage > 50){
513             uint nftCount = myNftsCount();
514             require(nftCount > 0, "You don't own any GFarm NFT.");
515 
516             bool hasCorrespondingNFT = false;
517 
518             for(uint i = 0; i < nftCount; i++){
519                 uint nftID = nft.tokenOfOwnerByIndex(msg.sender, i);
520                 uint correspondingLeverage = nft.getLeverageFromID(nftID);
521                 if(correspondingLeverage == _leverage){
522                     hasCorrespondingNFT = true;
523                     break;
524                 }
525             }
526             
527             require(hasCorrespondingNFT, "You don't own the corresponding NFT for this leverage.");            
528         }
529         
530         token.transferFrom(msg.sender, address(this), _positionSize);
531         token.burn(address(this), _positionSize);
532 
533         uint DEV_FUND_fee = _positionSize.mul(DEV_FUND_FEE_P).div(100);
534         uint positionSizeMinusFee = _positionSize.sub(DEV_FUND_fee);
535 
536         token.mint(DEV_FUND, DEV_FUND_fee);
537 
538         uint ethPosSize = positionSizeMinusFee.mul(getGFarmPriceEth()).div(PRECISION);
539 
540         trades[msg.sender] = Trade(block.number, msg.sender, _buy, getEthPrice(), ethPosSize, _leverage);
541         addressesTradeOpen.push(msg.sender);
542         addressTradeOpenID[msg.sender] = addressesTradeOpen.length.sub(1);
543     }
544     function closeTrade() external{
545         require(hasOpenTrade(msg.sender), "You have no open trade.");
546         Trade memory t = trades[msg.sender];
547         require(block.number >= t.openBlock.add(3), "Trade must be open for at least 3 blocks.");
548 
549         if(!canLiquidate(msg.sender)){
550             uint tokensBack = positionSizeGFARM(msg.sender);
551             int pnl = myTokenPNL();
552 
553             // Gain
554             if(pnl > 0){ 
555                 Gains storage userGains = gains[msg.sender];
556                 userGains.value = userGains.value.add(uint(pnl));
557                 userGains.lastTradeClosed = block.number;
558             // Loss
559             }else if(pnl < 0){
560                 tokensBack = tokensBack.sub(uint(pnl*(-1)));
561             }
562 
563             token.mint(msg.sender, tokensBack);
564         }
565 
566         unregisterOpenTrade(msg.sender);
567     }
568     function liquidate(address a) external{
569         require(canLiquidate(a), "No trade to liquidate for this address.");
570         require(myNftsCount() > 0 || msg.sender == DEV_FUND, "You don't own any GFarm NFT.");
571 
572         token.mint(msg.sender, liquidateAmountGFARM(a));
573         unregisterOpenTrade(a);
574     }
575     function claimGains() external{
576         Gains storage userGains = gains[msg.sender];
577         require(block.number.sub(userGains.lastTradeClosed) >= 3, "You must wait 3 block after you close a trade.");
578         token.mint(msg.sender, userGains.value);
579         userGains.value = 0;
580     }
581 
582     // UI VIEW FUNCTIONS (READ-ONLY)
583 
584     function myGains() external view returns(uint){
585         return gains[msg.sender].value;
586     }
587     function canClaimGains() external view returns(bool){
588         return block.number.sub(gains[msg.sender].lastTradeClosed) >= 3 && gains[msg.sender].value > 0;
589     }
590     // Divide by PRECISION for real value
591     function myPercentPNL() external view returns(int){
592         if(!hasOpenTrade(msg.sender)){ return 0; }
593 
594         Trade memory t = trades[msg.sender];
595         return currentPercentProfit(t.openPrice, getEthPrice(), t.buy, t.leverage);
596     }
597     function myOpenPrice() external view returns(uint){
598         return trades[msg.sender].openPrice;
599     }
600     function myPositionSizeETH() external view returns(uint){
601         return trades[msg.sender].ethPositionSize;
602     }
603     function myPositionSizeGFARM() external view returns(uint){
604         return positionSizeGFARM(msg.sender);
605     }
606     function myDirection() external view returns(string memory){
607         if(trades[msg.sender].buy){ return 'Buy'; }
608         return 'Sell';
609     }
610     function myLeverage() external view returns(uint){
611         return trades[msg.sender].leverage;
612     }
613     function tradeOpenSinceThreeBlocks() external view returns(bool){
614         Trade memory t = trades[msg.sender];
615         if(!hasOpenTrade(msg.sender) || block.number < t.openBlock){ return false; }
616         return block.number.sub(t.openBlock) >= 3;
617     }
618     function getAddressesTradeOpen() external view returns(address[] memory){
619         return addressesTradeOpen;
620     }
621     function unlockedLeverages() external view returns(uint16[8] memory leverages){
622         for(uint i = 0; i < myNftsCount(); i++){
623             uint16 leverage = nft.getLeverageFromID(nft.tokenOfOwnerByIndex(msg.sender, i));
624             uint id = nft.leverageID(leverage);
625             leverages[id] = leverage;
626         }
627     }
628 }