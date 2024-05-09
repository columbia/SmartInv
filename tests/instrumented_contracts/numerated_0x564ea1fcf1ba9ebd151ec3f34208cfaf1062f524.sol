1 //SPDX-License-Identifier: MIT
2 
3 /** 
4  * Contract: Surge Token
5  * Developed by: Heisenman
6  * Team: t.me/ALBINO_RHINOOO, t.me/Heisenman, t.me/STFGNZ 
7  * Trade without dex fees. $SURGE is the inception of the next generation of decentralized protocols.
8  * Socials:
9  * TG: https://t.me/SURGEPROTOCOL
10  * Website: https://surgeprotocol.io/
11  * Twitter: https://twitter.com/SURGEPROTOCOL
12  */
13 
14 pragma solidity ^0.8.17;
15 
16 abstract contract ReentrancyGuard {
17     uint256 private constant _NOT_ENTERED = 1;
18     uint256 private constant _ENTERED = 2;
19     uint256 private _status;
20     constructor () {
21         _status = _NOT_ENTERED;
22     }
23 
24     modifier nonReentrant() {
25         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
26         _status = _ENTERED;
27         _;
28         _status = _NOT_ENTERED;
29     }
30 }
31 
32 interface IPancakePair {
33     function token0() external view returns (address);
34     function token1() external view returns (address);
35     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
36 }
37 
38 interface IERC20 {
39     function totalSupply() external view returns (uint256);
40     function balanceOf(address account) external view returns (uint256);
41     function transfer(address recipient, uint256 amount) external returns (bool);
42     function allowance(address owner, address spender) external view returns (uint256);
43     function approve(address spender, uint256 amount) external returns (bool);
44     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47     function decimals() external view returns (uint8);
48 }
49 
50 abstract contract Context {
51     function _msgSender() internal view virtual returns (address payable) {
52         return payable(msg.sender);
53     }
54 
55     function _msgData() internal view virtual returns (bytes memory) {
56         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
57         return msg.data;
58     }
59 }
60 
61 contract Ownable is Context {
62     address private _owner;
63     address private _previousOwner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66     constructor () {
67         address msgSender = _msgSender();
68         _owner = msgSender;
69         emit OwnershipTransferred(address(0), msgSender);
70     }
71     function owner() public view returns (address) {
72         return _owner;
73     }
74     modifier onlyOwner() {
75         require(_owner == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82     function transferOwnership(address newOwner) public virtual onlyOwner {
83         require(newOwner != address(0), "Ownable: new owner is the zero address");
84         emit OwnershipTransferred(_owner, newOwner);
85         _owner = newOwner;
86     }
87 }
88 
89 contract SURGE is IERC20, Context, Ownable, ReentrancyGuard {
90 
91     event Bought(address indexed from, address indexed to,uint256 tokens, uint256 beans,uint256 dollarBuy);
92     event Sold(address indexed from, address indexed to,uint256 tokens, uint256 beans,uint256 dollarSell);
93 
94     // token data
95     string constant private _name = "SURGE";
96     string constant private  _symbol = "SURGE";
97     uint8 constant private _decimals = 9;
98     uint256 constant private _decMultiplier = 10**_decimals;
99 
100     // Total Supply
101     uint256 public _totalSupply = 10**8*_decMultiplier;
102 
103     // balances
104     mapping (address => uint256) public _balances;
105     mapping (address => mapping (address => uint256)) internal _allowances;
106 
107     //Fees
108     mapping (address => bool) public isFeeExempt;
109     uint256 public sellMul = 95;
110     uint256 public buyMul = 95;
111     uint256 public constant DIVISOR = 100;
112 
113     //Max bag requirements
114     mapping (address => bool) public isTxLimitExempt;
115     uint256 public maxBag = _totalSupply/100;
116     
117     //Tax collection
118     uint256 public taxBalance = 0;
119 
120     //Tax wallets
121     address public teamWallet = 0xDa17D158bC42f9C29E626b836d9231bB173bab06;
122     address public treasuryWallet = 0xF526A924c406D31d16a844FF04810b79E71804Ef ;
123 
124     // Tax Split
125     uint256 public teamShare = 40;
126     uint256 public treasuryShare = 60;
127     uint256 public shareDIVISOR = 100;
128 
129     //Known Wallets
130     address constant private DEAD = 0x000000000000000000000000000000000000dEaD;
131 
132     //trading parameters
133     uint256 public liquidity = 4 ether;
134     uint256 public liqConst= liquidity*_totalSupply;
135     uint256 public tradeOpenTime = 1673125200;
136 
137     //volume trackers
138     mapping (address => uint256) public indVol;
139     mapping (uint256 => uint256) public tVol;
140     uint256 public totalVolume = 0;
141 
142     //candlestick data
143     uint256 public totalTx;
144     mapping(uint256 => uint256) public txTimeStamp;
145 
146     struct candleStick{ 
147         uint256 time;
148         uint256 open;
149         uint256 close;
150         uint256 high;
151         uint256 low;
152     }
153 
154     mapping(uint256 => candleStick) public candleStickData;
155 
156     //Frontrun Gaurd
157     mapping(address => uint256) private lastBuyBlock;
158 
159     // initialize supply
160     constructor(
161     ) {
162         _balances[address(this)] = _totalSupply;
163 
164         isFeeExempt[msg.sender] = true;
165 
166         isTxLimitExempt[msg.sender] = true;
167         isTxLimitExempt[address(this)] = true;
168         isTxLimitExempt[DEAD] = true;
169         isTxLimitExempt[address(0)] = true;
170 
171         emit Transfer(address(0), address(this), _totalSupply);
172     }
173 
174     function totalSupply() external view override returns (uint256) { return _totalSupply; }
175     function balanceOf(address account) public view override returns (uint256) { return _balances[account]; }
176     function allowance(address holder, address spender) external view override returns (uint256) { return _allowances[holder][spender]; }
177     function name() public pure returns (string memory) {
178         return _name;
179     }
180 
181     function symbol() public pure returns (string memory) {
182         return _symbol;
183     }
184 
185     function decimals() public pure returns (uint8) {
186         return _decimals;
187     }
188 
189     function approve(address spender, uint256 amount) public override returns (bool) {
190         _allowances[msg.sender][spender] = amount;
191         emit Approval(msg.sender, spender, amount);
192         return true;
193     }
194 
195     function approveMax(address spender) external returns (bool) {
196         return approve(spender, type(uint).max);
197     }
198 
199     function getCirculatingSupply() public view returns (uint256) {
200         return _totalSupply-_balances[DEAD];
201     }
202 
203     function changeWalletLimit(uint256 newLimit) external onlyOwner {
204         require(newLimit >= _totalSupply/100);
205         maxBag  = newLimit;
206     }
207     
208     function changeIsFeeExempt(address holder, bool exempt) external onlyOwner {
209         isFeeExempt[holder] = exempt;
210     }
211 
212     function changeIsTxLimitExempt(address holder, bool exempt) external onlyOwner {
213         isTxLimitExempt[holder] = exempt;
214     }
215 
216     /** Transfer Function */
217     function transfer(address recipient, uint256 amount) external override returns (bool) {
218         return _transferFrom(msg.sender, recipient, amount);
219     }
220 
221     /** Transfer Function */
222     function transferFrom(address sender, address recipient, uint256 amount) external override returns (bool) {
223         require(sender == msg.sender);
224         return _transferFrom(sender, recipient, amount);
225     }
226     
227     /** Internal Transfer */
228     function _transferFrom(address sender, address recipient, uint256 amount) internal nonReentrant returns (bool) {
229         // make standard checks
230         require(recipient != address(0) && recipient != address(this), "transfer to the zero address");
231         require(amount > 0, "Transfer amount must be greater than zero");
232         require(isTxLimitExempt[recipient]||_balances[recipient] + amount <= maxBag);
233         // subtract from sender
234         _balances[sender] = _balances[sender] - amount;
235         // give reduced amount to receiver
236         _balances[recipient] = _balances[recipient] + amount;
237         // Transfer Event
238         emit Transfer(sender, recipient, amount);
239         return true;
240     }
241     
242     //tx timeout modifier
243     modifier ensure(uint deadline) {
244         require(deadline >= block.timestamp, "Deadline EXPIRED");
245         _;
246     }
247 
248     /** Purchases SURGE Tokens and Deposits Them in Sender's Address*/
249     function _buy(uint256 minTokenOut, uint256 deadline) public nonReentrant ensure(deadline) payable returns (bool) {
250         lastBuyBlock[msg.sender]=block.number;
251 
252         // liquidity is set and trade is open
253         require(liquidity > 0 && block.timestamp>= tradeOpenTime, "The token has no liquidity or trading not open");
254      
255         //remove the buy tax
256         uint256 bnbAmount = isFeeExempt[msg.sender] ? msg.value : msg.value * buyMul / DIVISOR;
257         
258         // how much they should purchase?
259         uint256 tokensToSend = _balances[address(this)]-(liqConst/(bnbAmount+liquidity));
260         
261         //revert for max bag
262         require(_balances[msg.sender] + tokensToSend <= maxBag || isTxLimitExempt[msg.sender],"Max wallet exceeded");
263 
264         // revert if under 1
265         require(tokensToSend > 1,'Must Buy more than 1 decimal of Surge');
266 
267         // revert for slippage
268         require(tokensToSend >= minTokenOut,'INSUFFICIENT OUTPUT AMOUNT');
269 
270         // transfer the tokens from CA to the buyer
271         buy(msg.sender, tokensToSend);
272 
273         //update available tax to extract and Liquidity
274         uint256 taxAmount = msg.value - bnbAmount;
275         taxBalance = taxBalance + taxAmount;
276         liquidity = liquidity + bnbAmount;
277 
278         //update volume
279         uint cTime = block.timestamp;
280         uint dollarBuy = msg.value*getBNBPrice();
281         totalVolume += dollarBuy;
282         indVol[msg.sender]+= dollarBuy;
283         tVol[cTime]+=dollarBuy;
284 
285         //update candleStickData
286         totalTx+=1;
287         txTimeStamp[totalTx]= cTime;
288         uint cPrice = calculatePrice()*getBNBPrice();
289         candleStickData[cTime].time= cTime;
290         if(candleStickData[cTime].open == 0){
291             if(totalTx==1)
292             {
293             candleStickData[cTime].open = (liquidity-bnbAmount)/(_totalSupply)*getBNBPrice();
294             }
295             else {candleStickData[cTime].open = candleStickData[txTimeStamp[totalTx-1]].close;}
296         }
297         candleStickData[cTime].close = cPrice;
298         
299         if(candleStickData[cTime].high < cPrice || candleStickData[cTime].high==0){
300             candleStickData[cTime].high = cPrice;
301         }
302 
303           if(candleStickData[cTime].low > cPrice || candleStickData[cTime].low==0){
304             candleStickData[cTime].low = cPrice;
305         }
306 
307         //emit transfer and buy events
308         emit Transfer(address(this), msg.sender, tokensToSend);
309         emit Bought(msg.sender, address(this), tokensToSend, msg.value,bnbAmount*getBNBPrice());
310         return true;
311     }
312     
313     /** Sends Tokens to the buyer Address */
314     function buy(address receiver, uint amount) internal {
315         _balances[receiver] = _balances[receiver] + amount;
316         _balances[address(this)] = _balances[address(this)] - amount;
317     }
318 
319     /** Sells SURGE Tokens And Deposits the BNB into Seller's Address */
320     function _sell(uint256 tokenAmount, uint256 deadline, uint256 minBNBOut) public nonReentrant ensure(deadline) payable returns (bool) {
321         require(lastBuyBlock[msg.sender]!=block.number);
322         require(msg.value == 0);
323         
324         address seller = msg.sender;
325         
326         // make sure seller has this balance
327         require(_balances[seller] >= tokenAmount, 'cannot sell above token amount');
328         
329         // get how much beans are the tokens worth
330         uint256 amountBNB = liquidity - (liqConst/(_balances[address(this)]+tokenAmount));
331         uint256 amountTax = amountBNB * (DIVISOR - sellMul)/DIVISOR;
332         uint256 BNBToSend = amountBNB - amountTax;
333         
334         //slippage revert
335         require(amountBNB >= minBNBOut);
336 
337         // send BNB to Seller
338         (bool successful,) = isFeeExempt[msg.sender] ? payable(seller).call{value: amountBNB, gas:40000}(""): payable(seller).call{value: BNBToSend, gas:40000}(""); 
339         require(successful);
340 
341         // subtract full amount from sender
342         _balances[seller] = _balances[seller] - tokenAmount;
343 
344         //add tax allowance to be withdrawn and remove from liq the amount of beans taken by the seller
345         taxBalance = isFeeExempt[msg.sender] ? taxBalance : taxBalance + amountTax;
346         liquidity = liquidity - amountBNB;
347 
348         // add tokens back into the contract
349         _balances[address(this)]=_balances[address(this)]+ tokenAmount;
350 
351         //update volume
352         uint cTime = block.timestamp;
353         uint dollarSell= amountBNB*getBNBPrice();
354         totalVolume += dollarSell;
355         indVol[msg.sender]+= dollarSell;
356         tVol[cTime]+=dollarSell;
357 
358         //update candleStickData
359         totalTx+=1;
360         txTimeStamp[totalTx]= cTime;
361         uint cPrice = calculatePrice()*getBNBPrice();
362         candleStickData[cTime].time= cTime;
363         if(candleStickData[cTime].open == 0){
364             candleStickData[cTime].open = candleStickData[txTimeStamp[totalTx-1]].close;
365         }
366         candleStickData[cTime].close = cPrice;
367         
368         if(candleStickData[cTime].high < cPrice || candleStickData[cTime].high==0){
369             candleStickData[cTime].high = cPrice;
370         }
371 
372           if(candleStickData[cTime].low > cPrice || candleStickData[cTime].low==0){
373             candleStickData[cTime].low = cPrice;
374         }
375 
376         // emit transfer and sell events
377         emit Transfer(seller, address(this), tokenAmount);
378         if(isFeeExempt[msg.sender]){
379             emit Sold(address(this), msg.sender,tokenAmount,amountBNB,dollarSell);
380         }
381         
382         else{ emit Sold(address(this), msg.sender,tokenAmount,BNBToSend,BNBToSend*getBNBPrice());}
383         return true;
384     }
385     
386     /** Amount of BNB in Contract */
387     function getLiquidity() public view returns(uint256){
388         return liquidity;
389     }
390 
391     /** Returns the value of your holdings before the sell fee */
392     function getValueOfHoldings(address holder) public view returns(uint256) {
393         return _balances[holder]*liquidity/_balances[address(this)]*getBNBPrice();
394     }
395 
396     function changeFees(uint256 newbuyMul, uint256 newsellMul) external onlyOwner {
397         require( newbuyMul >= 90 && newsellMul >= 90 && newbuyMul <=100 && newsellMul<= 100, 'Fees are too high');
398 
399         buyMul = newbuyMul;
400         sellMul = newsellMul;
401     }
402 
403     function changeTaxDistribution(uint newteamShare, uint newtreasuryShare) external onlyOwner {
404         require(newteamShare + newtreasuryShare == 100);
405 
406         teamShare = newteamShare;
407         treasuryShare = newtreasuryShare;
408     }
409 
410     function changeFeeReceivers(address newTeamWallet, address newTreasuryWallet) external onlyOwner {
411         teamWallet = newTeamWallet;
412         treasuryWallet = newTreasuryWallet;
413     }
414 
415     function withdrawTaxBalance() external nonReentrant() payable onlyOwner {
416         (bool temp1,)= payable(teamWallet).call{value:taxBalance*teamShare/shareDIVISOR}("");
417         (bool temp2,)= payable(treasuryWallet).call{value:taxBalance*treasuryShare/shareDIVISOR}("");
418         assert(temp1 && temp2);
419         taxBalance = 0; 
420     }
421 
422     function getTokenAmountOut(uint256 amountBNBIn) external view returns (uint256) {
423         uint256 amountAfter = liqConst/(liquidity-amountBNBIn);
424         uint256 amountBefore = liqConst/liquidity;
425         return amountAfter-amountBefore;
426     }
427 
428     function getBNBAmountOut(uint256 amountIn) public view returns (uint256) {
429         uint256 beansBefore = liqConst / _balances[address(this)];
430         uint256 beansAfter = liqConst / (_balances[address(this)] + amountIn);
431         return beansBefore-beansAfter;
432     }
433 
434     function addLiquidity() external onlyOwner payable {
435         uint256 tokensToAdd= _balances[address(this)]*msg.value/liquidity;
436         require(_balances[msg.sender]>= tokensToAdd);
437 
438         uint256 oldLiq = liquidity;
439         liquidity = liquidity+msg.value;
440         _balances[address(this)]+= tokensToAdd;
441         _balances[msg.sender]-= tokensToAdd;
442         liqConst= liqConst*liquidity/oldLiq;
443 
444         emit Transfer(msg.sender, address(this),tokensToAdd);
445     }
446 
447     function getMarketCap() external view returns(uint256){
448         return (getCirculatingSupply()*calculatePrice()*getBNBPrice());
449     }
450 
451     address private stablePairAddress = 0x7BeA39867e4169DBe237d55C8242a8f2fcDcc387;
452     address private stableAddress = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
453 
454     function changeStablePair(address newStablePair, address newStableAddress) external{
455         stablePairAddress = newStablePair;
456         stableAddress = newStableAddress;
457     }
458 
459    // calculate price based on pair reserves
460    function getBNBPrice() public view returns(uint)
461    {
462     IPancakePair pair = IPancakePair(stablePairAddress);
463     IERC20 token1 = pair.token0() == stableAddress? IERC20(pair.token1()):IERC20(pair.token0()); 
464     
465     (uint Res0, uint Res1,) = pair.getReserves();
466 
467     if(pair.token0() != stableAddress){(Res1,Res0,) = pair.getReserves();}
468     uint res0 = Res0*10**token1.decimals();
469     return(res0/Res1); // return amount of token0 needed to buy token1
470    }
471 
472     // Returns the Current Price of the Token in beans
473     function calculatePrice() public view returns (uint256) {
474         require(liquidity>0,'No Liquidity');
475         return liquidity/_balances[address(this)];
476     }
477 }