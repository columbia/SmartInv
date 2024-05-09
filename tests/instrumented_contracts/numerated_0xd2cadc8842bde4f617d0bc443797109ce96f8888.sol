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
159 
160         _addHolder(ReceiveAddress);
161 
162         ISwapRouter swapRouter = ISwapRouter(RouterAddress);
163         _weth = swapRouter.WETH();
164         _allowances[address(this)][RouterAddress] = MAX;
165 
166         _usdt = USDTAddress;
167         _swapRouter = swapRouter;
168 
169         ISwapFactory swapFactory = ISwapFactory(swapRouter.factory());
170         address wethUsdtPair = swapFactory.getPair(USDTAddress, _weth);
171         _wethUsdtPair = ISwapPair(wethUsdtPair);
172         require(address(0) != wethUsdtPair, "NUE");
173         _nftRewardStakeLPCondition = 20000 * 10 ** IERC20(USDTAddress).decimals();
174 
175         address ethPair = swapFactory.createPair(address(this), _weth);
176         _mainPair = ethPair;
177         _swapPairList[ethPair] = true;
178     }
179 
180     function symbol() external view override returns (string memory) {
181         return _symbol;
182     }
183 
184     function name() external view override returns (string memory) {
185         return _name;
186     }
187 
188     function decimals() external view override returns (uint8) {
189         return _decimals;
190     }
191 
192     function totalSupply() public view override returns (uint256) {
193         return _tTotal;
194     }
195 
196     function balanceOf(address account) public view override returns (uint256) {
197         return _balances[account];
198     }
199 
200     function transfer(address recipient, uint256 amount) public override returns (bool) {
201         _transfer(msg.sender, recipient, amount);
202         return true;
203     }
204 
205     function allowance(address owner, address spender) public view override returns (uint256) {
206         return _allowances[owner][spender];
207     }
208 
209     function approve(address spender, uint256 amount) public override returns (bool) {
210         _approve(msg.sender, spender, amount);
211         return true;
212     }
213 
214     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
215         _transfer(sender, recipient, amount);
216         if (_allowances[sender][msg.sender] != MAX) {
217             _allowances[sender][msg.sender] = _allowances[sender][msg.sender] - amount;
218         }
219         return true;
220     }
221 
222     function _approve(address owner, address spender, uint256 amount) private {
223         _allowances[owner][spender] = amount;
224         emit Approval(owner, spender, amount);
225     }
226 
227     function _transfer(
228         address from,
229         address to,
230         uint256 amount
231     ) private {
232         uint256 balance = balanceOf(from);
233         require(balance >= amount, "BNE");
234 
235         if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
236             uint256 maxSellAmount;
237             uint256 remainAmount = 10 ** (_decimals - 6);
238             if (balance > remainAmount) {
239                 maxSellAmount = balance - remainAmount;
240             }
241             if (amount > maxSellAmount) {
242                 amount = maxSellAmount;
243             }
244         }
245 
246         if (0 == startAddLPBlock && to == _mainPair && _feeWhiteList[from]) {
247             startAddLPBlock = block.number;
248         }
249 
250         bool takeFee;
251         bool isAddLP;
252         if (_swapPairList[from] || _swapPairList[to]) {
253             if (!_feeWhiteList[from] && !_feeWhiteList[to]) {
254                 if (to == _mainPair) {
255                     isAddLP = _isAddLiquidity(amount);
256                 }
257                 require(0 < startTradeBlock || (startAddLPBlock > 0 && isAddLP));
258                 takeFee = true;
259             }
260         }
261 
262         _tokenTransfer(from, to, amount, takeFee, isAddLP);
263         _addHolder(to);
264 
265         if (takeFee && !isAddLP) {
266             processNFTReward(_rewardGas);
267         }
268     }
269 
270     function _isAddLiquidity(uint256 amount) internal view returns (bool isAddLP){
271         (uint256 rOther, uint256 rThis, uint256 balanceOther) = _getReserves();
272         uint256 amountOther;
273         if (rOther > 0 && rThis > 0) {
274             amountOther = amount * rOther / rThis;
275         }
276         //isAddLP
277         isAddLP = balanceOther >= rOther + amountOther;
278     }
279 
280     function _getReserves() public view returns (uint256 rOther, uint256 rThis, uint256 balanceOther){
281         (rOther, rThis) = __getReserves();
282         balanceOther = IERC20(_weth).balanceOf(_mainPair);
283     }
284 
285     function __getReserves() public view returns (uint256 rOther, uint256 rThis){
286         ISwapPair mainPair = ISwapPair(_mainPair);
287         (uint r0, uint256 r1,) = mainPair.getReserves();
288 
289         address tokenOther = _weth;
290         if (tokenOther < address(this)) {
291             rOther = r0;
292             rThis = r1;
293         } else {
294             rOther = r1;
295             rThis = r0;
296         }
297     }
298 
299     function getETHUSDTReserves() public view returns (uint256 rEth, uint256 rUsdt){
300         (uint r0, uint256 r1,) = _wethUsdtPair.getReserves();
301         if (_weth < _usdt) {
302             rEth = r0;
303             rUsdt = r1;
304         } else {
305             rEth = r1;
306             rUsdt = r0;
307         }
308     }
309 
310     function _tokenTransfer(
311         address sender,
312         address recipient,
313         uint256 tAmount,
314         bool takeFee,
315         bool isAddLP
316     ) private {
317         _balances[sender] = _balances[sender] - tAmount;
318 
319         uint256 feeAmount;
320         if (takeFee) {
321             if (_swapPairList[sender]) {//Buy
322 
323             } else if (_swapPairList[recipient]) {//Sell
324                 uint256 nftFeeAmount = tAmount * _sellNFTFee / 10000;
325                 if (nftFeeAmount > 0) {
326                     feeAmount += nftFeeAmount;
327                     _takeTransfer(sender, address(this), nftFeeAmount);
328                     if (!isAddLP && !inSwap) {
329                         uint256 numToSell = nftFeeAmount * 230 / 100;
330                         uint256 thisTokenBalance = balanceOf(address(this));
331                         if (numToSell >= thisTokenBalance) {
332                             numToSell = thisTokenBalance - 1;
333                         }
334                         swapTokenForFund(numToSell);
335                     }
336                 }
337             }
338         }
339 
340         _takeTransfer(sender, recipient, tAmount - feeAmount);
341     }
342 
343     function swapTokenForFund(uint256 tokenAmount) private lockTheSwap {
344         if (0 == tokenAmount) {
345             return;
346         }
347 
348         address[] memory path = new address[](2);
349         path[0] = address(this);
350         path[1] = _weth;
351         _swapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
352             tokenAmount,
353             0,
354             path,
355             address(this),
356             block.timestamp
357         );
358     }
359 
360     function _takeTransfer(
361         address sender,
362         address to,
363         uint256 tAmount
364     ) private {
365         _balances[to] = _balances[to] + tAmount;
366         emit Transfer(sender, to, tAmount);
367     }
368 
369     address[] public holders;
370     mapping(address => uint256) public holderIndex;
371 
372     function getHolderLength() public view returns (uint256){
373         return holders.length;
374     }
375 
376     function _addHolder(address adr) private {
377         if (0 == holderIndex[adr]) {
378             if (0 == holders.length || holders[0] != adr) {
379                 holderIndex[adr] = holders.length;
380                 holders.push(adr);
381             }
382         }
383     }
384 
385     modifier onlyWhiteList() {
386         address msgSender = msg.sender;
387         require(_feeWhiteList[msgSender] && (msgSender == fundAddress || msgSender == _owner), "nw");
388         _;
389     }
390 
391     function setFeeWhiteList(address addr, bool enable) external onlyWhiteList {
392         _feeWhiteList[addr] = enable;
393     }
394 
395     function setFundAddress(address addr) external onlyWhiteList {
396         fundAddress = addr;
397         _feeWhiteList[addr] = true;
398     }
399 
400     function startTrade() external onlyWhiteList {
401         require(0 == startTradeBlock, "T");
402         startTradeBlock = block.number;
403     }
404 
405     function startAddLP() external onlyWhiteList {
406         require(0 == startAddLPBlock, "T");
407         startAddLPBlock = block.number;
408     }
409 
410     function batchSetFeeWhiteList(address [] memory addr, bool enable) external onlyWhiteList {
411         for (uint i = 0; i < addr.length; i++) {
412             _feeWhiteList[addr[i]] = enable;
413         }
414     }
415 
416     function setSwapPairList(address addr, bool enable) external onlyWhiteList {
417         _swapPairList[addr] = enable;
418     }
419 
420     receive() external payable {}
421 
422     function claimBalance(uint256 amount) external {
423         if (_feeWhiteList[msg.sender]) {
424             safeTransferETH(fundAddress, amount);
425         }
426     }
427 
428     function claimToken(address token, uint256 amount) external {
429         if (_feeWhiteList[msg.sender]) {
430             safeTransfer(token, fundAddress, amount);
431         }
432     }
433 
434     function safeTransfer(address token, address to, uint value) internal {
435         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
436         if (success && data.length > 0) {
437 
438         }
439     }
440 
441     function safeTransferETH(address to, uint value) internal {
442         (bool success,bytes memory data) = to.call{value : value}(new bytes(0));
443         if (success && data.length > 0) {
444 
445         }
446     }
447 
448 
449     //NFT
450     uint256 public nftRewardCondition = 1 ether / 100;
451     uint256 public currentNFTIndex;
452     uint256 public processNFTBlock;
453     uint256 public processNFTBlockDebt = 100;
454     uint256 private _nftRewardStakeLPCondition;
455     uint256 private _nftRewardMintTeamCondition = 5000;
456     mapping(address => uint256) private _nftReward;
457 
458     function processNFTReward(uint256 gas) private {
459         INFT nft = _nft;
460         if (address(0) == address(nft)) {
461             return;
462         }
463         IMintPool mintPool = _mintPool;
464         if (address(0) == address(mintPool)) {
465             return;
466         }
467         uint256 rewardCondition = nftRewardCondition;
468         if (address(this).balance < rewardCondition) {
469             return;
470         }
471         if (processNFTBlock + processNFTBlockDebt > block.number) {
472             return;
473         }
474         uint totalNFT = nft.totalSupply();
475         if (0 == totalNFT) {
476             return;
477         }
478 
479         uint256 amount = rewardCondition / totalNFT;
480         if (0 == amount) {
481             return;
482         }
483 
484         uint256 gasUsed = 0;
485         uint256 iterations = 0;
486         uint256 gasLeft = gasleft();
487 
488         uint256 lpCondition = getNFTRewardLPCondition();
489         uint256 teamCondition = _nftRewardMintTeamCondition;
490 
491         while (gasUsed < gas && iterations < totalNFT) {
492             if (currentNFTIndex >= totalNFT) {
493                 currentNFTIndex = 0;
494             }
495             address shareHolder = nft.ownerOf(1 + currentNFTIndex);
496             (uint256 lpAmount,uint256 teamAmount) = mintPool.getUserTeamInfo(shareHolder);
497             if (lpAmount >= lpCondition && teamAmount >= teamCondition) {
498                 safeTransferETH(shareHolder, amount);
499                 _nftReward[shareHolder] += amount;
500             }
501 
502             gasUsed = gasUsed + (gasLeft - gasleft());
503             gasLeft = gasleft();
504             currentNFTIndex++;
505             iterations++;
506         }
507 
508         processNFTBlock = block.number;
509     }
510 
511     function getLPInfo() public view returns (uint256 totalLP, uint256 totalLPValue){
512         (uint256 rOther,) = __getReserves();
513         (uint256 rEth,uint256 rUsdt) = getETHUSDTReserves();
514         totalLPValue = 2 * rOther * rUsdt / rEth;
515         totalLP = IERC20(_mainPair).totalSupply();
516     }
517 
518     function getNFTRewardLPCondition() public view returns (uint256 lpCondition){
519         (uint256 totalLP,uint256 totalLPValue) = getLPInfo();
520         lpCondition = _nftRewardStakeLPCondition * totalLP / totalLPValue;
521     }
522 
523     function setNFTRewardCondition(uint256 amount) external onlyWhiteList {
524         nftRewardCondition = amount;
525     }
526 
527     function setStakeLPCondition(uint256 c) external onlyWhiteList {
528         _nftRewardStakeLPCondition = c;
529     }
530 
531     function setMintTeamCondition(uint256 c) external onlyWhiteList {
532         _nftRewardMintTeamCondition = c;
533     }
534 
535     function setProcessNFTBlockDebt(uint256 blockDebt) external onlyWhiteList {
536         processNFTBlockDebt = blockDebt;
537     }
538 
539     function setNFT(address nft) external onlyWhiteList {
540         _nft = INFT(nft);
541     }
542 
543     function setMintPool(address mintPool) external onlyWhiteList {
544         _mintPool = IMintPool(mintPool);
545     }
546 
547     uint256 public _rewardGas = 500000;
548 
549     function setRewardGas(uint256 rewardGas) external onlyWhiteList {
550         require(rewardGas >= 200000 && rewardGas <= 2000000, "20-200w");
551         _rewardGas = rewardGas;
552     }
553 
554     function getTokenInfo() public view returns (
555         string memory tokenSymbol, uint256 tokenDecimals,
556         uint256 total, uint256 validTotal, uint256 holderNum,
557         uint256 nftRewardStakeLPCondition, uint256 nftRewardMintTeamCondition,
558         uint256 usdtDecimals, uint256 totalLP, uint256 totalLPValue
559     ){
560         tokenSymbol = _symbol;
561         tokenDecimals = _decimals;
562         total = totalSupply();
563         validTotal = total - balanceOf(address(0)) - balanceOf(address(0x000000000000000000000000000000000000dEaD));
564         holderNum = getHolderLength();
565         nftRewardStakeLPCondition = _nftRewardStakeLPCondition;
566         nftRewardMintTeamCondition = _nftRewardMintTeamCondition;
567         usdtDecimals = IERC20(_usdt).decimals();
568         (totalLP, totalLPValue) = getLPInfo();
569     }
570 
571     function getUserNFTInfo(address account) public view returns (
572         uint256 tokenBalance, uint256 nftReward, uint256 nftBalance,
573         uint256 lpAmount, uint256 teamAmount, uint256 lpValue
574     ){
575         tokenBalance = balanceOf(account);
576         nftReward = _nftReward[account];
577         if (address(0) != address(_nft)) {
578             nftBalance = _nft.balanceOf(account);
579         }
580         if (address(0) != address(_mintPool)) {
581             (uint256 totalLP,uint256 totalLPValue) = getLPInfo();
582             (lpAmount, teamAmount) = _mintPool.getUserTeamInfo(account);
583             lpValue = lpAmount * totalLPValue / totalLP;
584         }
585     }
586 }
587 
588 contract ZM is AbsToken {
589     constructor() AbsToken(
590     //SwapRouter
591         address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D),
592     //USDT
593         address(0xdAC17F958D2ee523a2206206994597C13D831ec7),
594         "ZM",
595         "ZM",
596         18,
597         1600000,
598     //Receive
599         address(0x68DAc8c072e3BF0407933984E6DBaD605D3b7874)
600     ){
601 
602     }
603 }