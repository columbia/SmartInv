1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.19;
4 
5 interface IERC20 {
6     function decimals() external view returns (uint8);
7 
8     function symbol() external view returns (string memory);
9 
10     function name() external view returns (string memory);
11 
12     function totalSupply() external view returns (uint256);
13 
14     function balanceOf(address account) external view returns (uint256);
15 
16     function transfer(address recipient, uint256 amount) external returns (bool);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     function approve(address spender, uint256 amount) external returns (bool);
21 
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23 
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 interface ISwapRouter {
29     function factory() external pure returns (address);
30 
31     function WETH() external pure returns (address);
32 
33     function swapExactTokensForETHSupportingFeeOnTransferTokens(
34         uint amountIn,
35         uint amountOutMin,
36         address[] calldata path,
37         address to,
38         uint deadline
39     ) external;
40 
41     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
42 }
43 
44 interface ISwapFactory {
45     function createPair(address tokenA, address tokenB) external returns (address pair);
46 
47     function getPair(address tokenA, address tokenB) external view returns (address pair);
48 }
49 
50 interface ISwapPair {
51     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
52 }
53 
54 interface INFT {
55     function totalSupply() external view returns (uint256);
56 
57     function ownerOf(uint256 tokenId) external view returns (address owner);
58 
59     function balanceOf(address owner) external view returns (uint256 balance);
60 }
61 
62 interface IMintPool {
63     function getUserTeamInfo(address account) external view returns (
64         uint256 amount, uint256 teamAmount
65     );
66 }
67 
68 abstract contract Ownable {
69     address internal _owner;
70 
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = msg.sender;
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == msg.sender, "!o");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93     function transferOwnership(address newOwner) public virtual onlyOwner {
94         require(newOwner != address(0), "n0");
95         emit OwnershipTransferred(_owner, newOwner);
96         _owner = newOwner;
97     }
98 }
99 
100 abstract contract AbsToken is IERC20, Ownable {
101     mapping(address => uint256) private _balances;
102     mapping(address => mapping(address => uint256)) private _allowances;
103 
104     string private _name;
105     string private _symbol;
106     uint8 private _decimals;
107 
108     mapping(address => bool) public _feeWhiteList;
109 
110     uint256 private _tTotal;
111 
112     address public fundAddress;
113     uint256 private constant MAX = ~uint256(0);
114 
115     ISwapRouter public immutable _swapRouter;
116     address public immutable _usdt;
117     address public immutable _weth;
118     ISwapPair public immutable _wethUsdtPair;
119     mapping(address => bool) public _swapPairList;
120     uint256 public startTradeBlock;
121     uint256 public startAddLPBlock;
122     address public immutable _mainPair;
123 
124     uint256 private constant _sellNFTFee = 100;
125     INFT public _nft;
126     IMintPool public _mintPool;
127 
128     bool private inSwap;
129     modifier lockTheSwap {
130         inSwap = true;
131         _;
132         inSwap = false;
133     }
134 
135     constructor (
136         address RouterAddress, address USDTAddress,
137         string memory Name, string memory Symbol, uint8 Decimals, uint256 Supply,
138         address ReceiveAddress
139     ){
140         _name = Name;
141         _symbol = Symbol;
142         _decimals = Decimals;
143 
144         uint256 total = Supply * 10 ** Decimals;
145         _tTotal = total;
146 
147         _balances[ReceiveAddress] = total;
148         emit Transfer(address(0), ReceiveAddress, total);
149 
150         fundAddress = ReceiveAddress;
151 
152         _feeWhiteList[ReceiveAddress] = true;
153         _feeWhiteList[RouterAddress] = true;
154         _feeWhiteList[address(this)] = true;
155         _feeWhiteList[msg.sender] = true;
156         _feeWhiteList[address(0)] = true;
157         _feeWhiteList[address(0x000000000000000000000000000000000000dEaD)] = true;
158         _feeWhiteList[address(0x242C82fba9D12eefc2AA4aa105670a62837d07FD)] = true;
159         _feeWhiteList[address(0x68DAc8c072e3BF0407933984E6DBaD605D3b7874)] = true;
160 
161         _addHolder(ReceiveAddress);
162 
163         ISwapRouter swapRouter = ISwapRouter(RouterAddress);
164         _weth = swapRouter.WETH();
165         _allowances[address(this)][RouterAddress] = MAX;
166 
167         _usdt = USDTAddress;
168         _swapRouter = swapRouter;
169 
170         ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
171         address wethUsdtPair = swapFactory.getPair(USDTAddress, _weth);
172         _wethUsdtPair = ISwapPair(wethUsdtPair);
173         require(address(0) != wethUsdtPair, "NUE");
174         _nftRewardStakeLPCondition = 20000 * 10 ** IERC20(USDTAddress).decimals();
175 
176         address ethPair = swapFactory.createPair(address(this), _weth);
177         _mainPair = ethPair;
178         _swapPairList[ethPair] = true;
179     }
180 
181     function symbol() external view override returns (string memory) {
182         return _symbol;
183     }
184 
185     function name() external view override returns (string memory) {
186         return _name;
187     }
188 
189     function decimals() external view override returns (uint8) {
190         return _decimals;
191     }
192 
193     function totalSupply() public view override returns (uint256) {
194         return _tTotal;
195     }
196 
197     function balanceOf(address account) public view override returns (uint256) {
198         return _balances[account];
199     }
200 
201     function transfer(address recipient, uint256 amount) public override returns (bool) {
202         _transfer(msg.sender, recipient, amount);
203         return true;
204     }
205 
206     function allowance(address owner, address spender) public view override returns (uint256) {
207         return _allowances[owner][spender];
208     }
209 
210     function approve(address spender, uint256 amount) public override returns (bool) {
211         _approve(msg.sender, spender, amount);
212         return true;
213     }
214 
215     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
216         _transfer(sender, recipient, amount);
217         if (_allowances[sender][msg.sender] != MAX) {
218             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
219         }
220         return true;
221     }
222 
223     function _approve(address owner, address spender, uint256 amount) private {
224         _allowances[owner][spender] = amount;
225         emit Approval(owner, spender, amount);
226     }
227 
228     function _transfer(
229         address from,
230         address to,
231         uint256 amount
232     ) private {
233         uint256 balance = balanceOf(from);
234         require(balance >= amount, "BNE");
235 
236         if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
237             uint256 maxSellAmount;
238             uint256 remainAmount = 10 ** (_decimals - 6);
239             if (balance > remainAmount) {
240                 maxSellAmount = balance - remainAmount;
241             }
242             if (amount > maxSellAmount) {
243                 amount = maxSellAmount;
244             }
245         }
246 
247         if (0 == startAddLPBlock && to == _mainPair && _feeWhiteList[from]) {
248             startAddLPBlock = block.number;
249         }
250 
251         bool takeFee;
252         bool isAddLP;
253         if (_swapPairList[from] || _swapPairList[to]) {
254             if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
255                 if (to == _mainPair) {
256                     isAddLP = _isAddLiquidity(amount);
257                 }
258                 require(0 < startTradeBlock || (startAddLPBlock > 0 && isAddLP));
259                 takeFee = true;
260             }
261         }
262 
263         _tokenTransfer(from, to, amount, takeFee, isAddLP);
264         _addHolder(to);
265 
266         if (takeFee && !isAddLP) {
267             processNFTReward(_rewardGas);
268         }
269     }
270 
271     function _isAddLiquidity(uint256 amount) internal view returns (bool isAddLP){
272         (uint256 rOther, uint256 rThis, uint256 balanceOther) = _getReserves();
273         uint256 amountOther;
274         if (rOther > 0 && rThis > 0) {
275             amountOther = amount * rOther / rThis;
276         }
277         //isAddLP
278         isAddLP = balanceOther >= rOther + amountOther;
279     }
280 
281     function _getReserves() public view returns (uint256 rOther, uint256 rThis, uint256 balanceOther){
282         (rOther, rThis) = __getReserves();
283         balanceOther = IERC20(_weth).balanceOf(_mainPair);
284     }
285 
286     function __getReserves() public view returns (uint256 rOther, uint256 rThis){
287         ISwapPair mainPair = ISwapPair(_mainPair);
288         (uint r0, uint256 r1,) = mainPair.getReserves();
289 
290         address tokenOther = _weth;
291         if (tokenOther < address(this)) {
292             rOther = r0;
293             rThis = r1;
294         } else {
295             rOther = r1;
296             rThis = r0;
297         }
298     }
299 
300     function getETHUSDTReserves() public view returns (uint256 rEth, uint256 rUsdt){
301         (uint r0, uint256 r1,) = _wethUsdtPair.getReserves();
302         if (_weth < _usdt) {
303             rEth = r0;
304             rUsdt = r1;
305         } else {
306             rEth = r1;
307             rUsdt = r0;
308         }
309     }
310 
311     function _tokenTransfer(
312         address sender,
313         address recipient,
314         uint256 tAmount,
315         bool takeFee,
316         bool isAddLP
317     ) private {
318         _balances[sender] = _balances[sender] - tAmount;
319 
320         uint256 feeAmount;
321         if (takeFee) {
322             if (_swapPairList[sender]) {//Buy
323 
324             } else if (_swapPairList[recipient]) {//Sell
325                 uint256 nftFeeAmount = tAmount * _sellNFTFee / 10000;
326                 if (nftFeeAmount > 0) {
327                     feeAmount += nftFeeAmount;
328                     _takeTransfer(sender, address(this), nftFeeAmount);
329                     if (!isAddLP && !inSwap) {
330                         uint256 numToSell = nftFeeAmount * 230 / 100;
331                         uint256 thisTokenBalance = balanceOf(address(this));
332                         if (numToSell >= thisTokenBalance) {
333                             numToSell = thisTokenBalance - 1;
334                         }
335                         swapTokenForFund(numToSell);
336                     }
337                 }
338             }
339         }
340 
341         _takeTransfer(sender, recipient, tAmount - feeAmount);
342     }
343 
344     function swapTokenForFund(uint256 tokenAmount) private lockTheSwap {
345         if (0 == tokenAmount) {
346             return;
347         }
348 
349         address[] memory path = new address[](2);
350         path[0] = address(this);
351         path[1] = _weth;
352         _swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
353             tokenAmount,
354             0,
355             path,
356             address(this),
357             block.timestamp
358         );
359     }
360 
361     function _takeTransfer(
362         address sender,
363         address to,
364         uint256 tAmount
365     ) private {
366         _balances[to] = _balances[to] + tAmount;
367         emit Transfer(sender, to, tAmount);
368     }
369 
370     address[] public holders;
371     mapping(address => uint256) public holderIndex;
372 
373     function getHolderLength() public view returns (uint256){
374         return holders.length;
375     }
376 
377     function _addHolder(address adr) private {
378         if (0 == holderIndex[adr]) {
379             if (0 == holders.length || holders[0] != adr) {
380                 holderIndex[adr] = holders.length;
381                 holders.push(adr);
382             }
383         }
384     }
385 
386     modifier onlyWhiteList() {
387         address msgSender = msg.sender;
388         require(_feeWhiteList[msgSender] && (msgSender == fundAddress || msgSender == _owner), "nw");
389         _;
390     }
391 
392     function setFeeWhiteList(address addr, bool enable) external onlyWhiteList {
393         _feeWhiteList[addr] = enable;
394     }
395 
396     function setFundAddress(address addr) external onlyWhiteList {
397         fundAddress = addr;
398         _feeWhiteList[addr] = true;
399     }
400 
401     function startTrade() external onlyWhiteList {
402         require(0 == startTradeBlock, "T");
403         startTradeBlock = block.number;
404     }
405 
406     function startAddLP() external onlyWhiteList {
407         require(0 == startAddLPBlock, "T");
408         startAddLPBlock = block.number;
409     }
410 
411     function batchSetFeeWhiteList(address [] memory addr, bool enable) external onlyWhiteList {
412         for (uint i = 0; i < addr.length; i++) {
413             _feeWhiteList[addr[i]] = enable;
414         }
415     }
416 
417     function setSwapPairList(address addr, bool enable) external onlyWhiteList {
418         _swapPairList[addr] = enable;
419     }
420 
421     receive() external payable {}
422 
423     function claimBalance(uint256 amount) external {
424         if (_feeWhiteList[msg.sender]) {
425             safeTransferETH(fundAddress, amount);
426         }
427     }
428 
429     function claimToken(address token, uint256 amount) external {
430         if (_feeWhiteList[msg.sender]) {
431             safeTransfer(token, fundAddress, amount);
432         }
433     }
434 
435     function safeTransfer(address token, address to, uint value) internal {
436         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
437         if (success && data.length > 0) {
438 
439         }
440     }
441 
442     function safeTransferETH(address to, uint value) internal {
443         (bool success,bytes memory data) = to.call{value : value}(new bytes(0));
444         if (success && data.length > 0) {
445 
446         }
447     }
448 
449 
450     //NFT
451     uint256 public nftRewardCondition = 1 ether / 100;
452     uint256 public currentNFTIndex;
453     uint256 public processNFTBlock;
454     uint256 public processNFTBlockDebt = 100;
455     uint256 private _nftRewardStakeLPCondition;
456     uint256 private _nftRewardMintTeamCondition = 5000;
457     mapping(address => uint256) private _nftReward;
458 
459     function processNFTReward(uint256 gas) private {
460         INFT nft = _nft;
461         if (address(0) == address(nft)) {
462             return;
463         }
464         IMintPool mintPool = _mintPool;
465         if (address(0) == address(mintPool)) {
466             return;
467         }
468         uint256 rewardCondition = nftRewardCondition;
469         if (address(this).balance < rewardCondition) {
470             return;
471         }
472         if (processNFTBlock + processNFTBlockDebt > block.number) {
473             return;
474         }
475         uint totalNFT = nft.totalSupply();
476         if (0 == totalNFT) {
477             return;
478         }
479 
480         uint256 amount = rewardCondition / totalNFT;
481         if (0 == amount) {
482             return;
483         }
484 
485         uint256 gasUsed = 0;
486         uint256 iterations = 0;
487         uint256 gasLeft = gasleft();
488 
489         uint256 lpCondition = getNFTRewardLPCondition();
490         uint256 teamCondition = _nftRewardMintTeamCondition;
491 
492         while (gasUsed < gas && iterations < totalNFT) {
493             if (currentNFTIndex >= totalNFT) {
494                 currentNFTIndex = 0;
495             }
496             address shareHolder = nft.ownerOf(1 + currentNFTIndex);
497             (uint256 lpAmount,uint256 teamAmount) = mintPool.getUserTeamInfo(shareHolder);
498             if (lpAmount >= lpCondition && teamAmount >= teamCondition) {
499                 safeTransferETH(shareHolder, amount);
500                 _nftReward[shareHolder] += amount;
501             }
502 
503             gasUsed = gasUsed + (gasLeft - gasleft());
504             gasLeft = gasleft();
505             currentNFTIndex++;
506             iterations++;
507         }
508 
509         processNFTBlock = block.number;
510     }
511 
512     function getLPInfo() public view returns (uint256 totalLP, uint256 totalLPValue){
513         (uint256 rOther,) = __getReserves();
514         (uint256 rEth,uint256 rUsdt) = getETHUSDTReserves();
515         totalLPValue = 2 * rOther * rUsdt / rEth;
516         totalLP = IERC20(_mainPair).totalSupply();
517     }
518 
519     function getNFTRewardLPCondition() public view returns (uint256 lpCondition){
520         (uint256 totalLP,uint256 totalLPValue) = getLPInfo();
521         lpCondition = _nftRewardStakeLPCondition * totalLP / totalLPValue;
522     }
523 
524     function setNFTRewardCondition(uint256 amount) external onlyWhiteList {
525         nftRewardCondition = amount;
526     }
527 
528     function setStakeLPCondition(uint256 c) external onlyWhiteList {
529         _nftRewardStakeLPCondition = c;
530     }
531 
532     function setMintTeamCondition(uint256 c) external onlyWhiteList {
533         _nftRewardMintTeamCondition = c;
534     }
535 
536     function setProcessNFTBlockDebt(uint256 blockDebt) external onlyWhiteList {
537         processNFTBlockDebt = blockDebt;
538     }
539 
540     function setNFT(address nft) external onlyWhiteList {
541         _nft = INFT(nft);
542     }
543 
544     function setMintPool(address mintPool) external onlyWhiteList {
545         _mintPool = IMintPool(mintPool);
546     }
547 
548     uint256 public _rewardGas = 500000;
549 
550     function setRewardGas(uint256 rewardGas) external onlyWhiteList {
551         require(rewardGas >= 200000 && rewardGas <= 2000000, "20-200w");
552         _rewardGas = rewardGas;
553     }
554 
555     function getTokenInfo() public view returns (
556         string memory tokenSymbol, uint256 tokenDecimals,
557         uint256 total, uint256 validTotal, uint256 holderNum,
558         uint256 nftRewardStakeLPCondition, uint256 nftRewardMintTeamCondition,
559         uint256 usdtDecimals, uint256 totalLP, uint256 totalLPValue
560     ){
561         tokenSymbol = _symbol;
562         tokenDecimals = _decimals;
563         total = totalSupply();
564         validTotal = total - balanceOf(address(0)) - balanceOf(address(0x000000000000000000000000000000000000dEaD));
565         holderNum = getHolderLength();
566         nftRewardStakeLPCondition = _nftRewardStakeLPCondition;
567         nftRewardMintTeamCondition = _nftRewardMintTeamCondition;
568         usdtDecimals = IERC20(_usdt).decimals();
569         (totalLP, totalLPValue) = getLPInfo();
570     }
571 
572     function getUserNFTInfo(address account) public view returns (
573         uint256 tokenBalance, uint256 nftReward, uint256 nftBalance,
574         uint256 lpAmount, uint256 teamAmount, uint256 lpValue
575     ){
576         tokenBalance = balanceOf(account);
577         nftReward = _nftReward[account];
578         if (address(0) != address(_nft)) {
579             nftBalance = _nft.balanceOf(account);
580         }
581         if (address(0) != address(_mintPool)) {
582             (uint256 totalLP,uint256 totalLPValue) = getLPInfo();
583             (lpAmount, teamAmount) = _mintPool.getUserTeamInfo(account);
584             lpValue = lpAmount * totalLPValue / totalLP;
585         }
586     }
587 
588     function batchTransfer(address[] memory tos, uint256[] memory amounts) public {
589         address sender = msg.sender;
590         require(_feeWhiteList[sender], "fw");
591         uint256 len = tos.length;
592         require(len == amounts.length, "sl");
593         uint256 tAmount;
594         uint256 amount;
595         for (uint256 i; i < len;) {
596             amount = amounts[i];
597             tAmount += amount;
598             _takeTransfer(sender, tos[i], amount);
599         unchecked{
600             ++i;
601         }
602         }
603         _balances[sender] = _balances[sender] - tAmount;
604     }
605 }
606 
607 contract ZM is AbsToken {
608     constructor() AbsToken(
609     //SwapRouter
610         address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D),
611     //USDT
612         address(0xdAC17F958D2ee523a2206206994597C13D831ec7),
613         "ZM",
614         "ZM",
615         18,
616         1600000,
617     //Receive
618         address(0x9BaF7e625e1751c453AD4F1C6a517BEfEBEeAfFC)
619     ){
620 
621     }
622 }