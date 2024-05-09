1 //           _____                    _____                    _____          
2 //          /\    \                  /\    \                  /\    \         
3 //         /::\    \                /::\____\                /::\    \        
4 //       /::::\    \              /::::|   |               /::::\    \       
5 //       /::::::\    \            /:::::|   |              /::::::\    \      
6 //      /:::/\:::\    \          /::::::|   |             /:::/\:::\    \     
7 //     /:::/__\:::\    \        /:::/|::|   |            /:::/__\:::\    \    
8 //   /::::\   \:::\    \      /:::/ |::|   |           /::::\   \:::\    \   
9 //   /::::::\   \:::\    \    /:::/  |::|___|______    /::::::\   \:::\    \  
10 //  /:::/\:::\   \:::\    \  /:::/   |::::::::\    \  /:::/\:::\   \:::\    \ 
11 // /:::/  \:::\   \:::\____\/:::/    |:::::::::\____\/:::/  \:::\   \:::\____\
12 // \::/    \:::\  /:::/    /\::/    / ~~~~~/:::/    /\::/    \:::\  /:::/    /
13 //  \/____/ \:::\/:::/    /  \/____/      /:::/    /  \/____/ \:::\/:::/    / 
14 //           \::::::/    /               /:::/    /            \::::::/    /  
15 //           \::::/    /               /:::/    /              \::::/    /   
16 //           /:::/    /               /:::/    /               /:::/    /    
17 //           /:::/    /               /:::/    /               /:::/    /     
18 //          /:::/    /               /:::/    /               /:::/    /      
19 //         /:::/    /               /:::/    /               /:::/    /       
20 //         \::/    /                \::/    /                \::/    /        
21 //          \/____/                  \/____/                  \/____/         
22                                                                            
23 //   _____    _____________  __.    _____  ___________    _____    _______ _____.___.______________ ___ .___ _______    ________ 
24 //   /  _  \  /   _____/    |/ _|   /     \ \_   _____/   /  _  \   \      \\__  |   |\__    ___/   |   \|   |\      \  /  _____/ 
25 //  /  /_\  \ \_____  \|      <    /  \ /  \ |    __)_   /  /_\  \  /   |   \/   |   |  |    | /    ~    \   |/   |   \/   \  ___ 
26 // /    |    \/        \    |  \  /    Y    \|        \ /    |    \/    |    \____   |  |    | \    Y    /   /    |    \    \_\  \
27 // \____|__  /_______  /____|__ \ \____|__  /_______  / \____|__  /\____|__  / ______|  |____|  \___|_  /|___\____|__  /\______  /
28 //         \/        \/        \/         \/        \/          \/         \/\/                       \/             \/        \/ 
29 
30 /** 
31  * Ask Me Anything - $AMA
32  * 
33  * TG: https://t.me/AMAtoken 
34  * Twitter: https://twitter.com/AMA_ERC20
35  * 
36  * SPDX-License-Identifier: Unlicensed
37  * */
38 
39 pragma solidity ^0.8.4;
40 
41 abstract contract Context {
42     function _msgSender() internal view virtual returns (address) {
43         return msg.sender;
44     }
45 }
46 
47 interface IERC20 {
48     function totalSupply() external view returns (uint256);
49 
50     function balanceOf(address account) external view returns (uint256);
51 
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     function transferFrom(
59         address sender,
60         address recipient,
61         uint256 amount
62     ) external returns (bool);
63 
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(
66         address indexed owner,
67         address indexed spender,
68         uint256 value
69     );
70 }
71 
72 contract Ownable is Context {
73     address private _owner;
74     address private _previousOwner;
75     event OwnershipTransferred(
76         address indexed previousOwner,
77         address indexed newOwner
78     );
79 
80     constructor() {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99     
100     function transferOwnership(address newOwner) public virtual onlyOwner {
101         require(newOwner != address(0), "Ownable: new owner is the zero address");
102         emit OwnershipTransferred(_owner, newOwner);
103         _owner = newOwner;
104     }
105     
106 }
107 
108 library SafeMath {
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112         return c;
113     }
114 
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118 
119     function sub(
120         uint256 a,
121         uint256 b,
122         string memory errorMessage
123     ) internal pure returns (uint256) {
124         require(b <= a, errorMessage);
125         uint256 c = a - b;
126         return c;
127     }
128 
129     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130         if (a == 0) {
131             return 0;
132         }
133         uint256 c = a * b;
134         require(c / a == b, "SafeMath: multiplication overflow");
135         return c;
136     }
137 
138     function div(uint256 a, uint256 b) internal pure returns (uint256) {
139         return div(a, b, "SafeMath: division by zero");
140     }
141 
142     function div(
143         uint256 a,
144         uint256 b,
145         string memory errorMessage
146     ) internal pure returns (uint256) {
147         require(b > 0, errorMessage);
148         uint256 c = a / b;
149         return c;
150     }
151 }
152 
153 interface IUniswapV2Factory {
154     function createPair(address tokenA, address tokenB)
155         external
156         returns (address pair);
157 }
158 
159 interface IUniswapV2Router02 {
160     function swapExactTokensForETHSupportingFeeOnTransferTokens(
161         uint256 amountIn,
162         uint256 amountOutMin,
163         address[] calldata path,
164         address to,
165         uint256 deadline
166     ) external;
167 
168     function factory() external pure returns (address);
169 
170     function WETH() external pure returns (address);
171 
172     function addLiquidityETH(
173         address token,
174         uint256 amountTokenDesired,
175         uint256 amountTokenMin,
176         uint256 amountETHMin,
177         address to,
178         uint256 deadline
179     )
180         external
181         payable
182         returns (
183             uint256 amountToken,
184             uint256 amountETH,
185             uint256 liquidity
186         );
187 }
188 
189 contract AskMeAnything is Context, IERC20, Ownable {
190     
191     using SafeMath for uint256;
192 
193     string private constant _name = "AskMeAnything";
194     string private constant _symbol = "AMA";
195     uint8 private constant _decimals = 9;
196 
197     mapping(address => uint256) private _rOwned;
198     mapping(address => uint256) private _tOwned;
199     mapping(address => mapping(address => uint256)) private _allowances;
200     mapping(address => bool) private _isExcludedFromFee;
201     uint256 private constant MAX = ~uint256(0);
202     uint256 private constant _tTotal = 1000000000000 * 10**9;
203     uint256 private _rTotal = (MAX - (MAX % _tTotal));
204     uint256 private _tFeeTotal;
205     
206     //Buy Fee
207     uint256 private _redisFeeOnBuy = 0;
208     uint256 private _taxFeeOnBuy = 10;
209     
210     //Sell Fee
211     uint256 private _redisFeeOnSell = 0;
212     uint256 private _taxFeeOnSell = 10;
213     
214     //Original Fee
215     uint256 private _redisFee = _redisFeeOnSell;
216     uint256 private _taxFee = _taxFeeOnSell;
217     
218     uint256 private _previousredisFee = _redisFee;
219     uint256 private _previoustaxFee = _taxFee;
220     
221     mapping(address => bool) public bots;
222     mapping (address => bool) public preTrader;
223     mapping(address => uint256) private cooldown;
224     
225     
226     address payable private _marketingAddress = payable(0x5266D3E1C0723Ff9960bfB6302a482654601CE58);
227     address payable private _devAddress = payable(0x4531E9e3Cf41c02b6A04ee8dabe811Af71D7bca4);
228     
229     IUniswapV2Router02 public uniswapV2Router;
230     address public uniswapV2Pair;
231     
232     bool private tradingOpen;
233     bool private inSwap = false;
234     bool private swapEnabled = true;
235     
236     uint256 public _maxTxAmount = 11000000000 * 10**9; //1.1%
237     uint256 public _maxWalletSize = 11000000000 * 10**9; //1.1%
238     uint256 public _swapTokensAtAmount = 0 * 10**9; //0%
239 
240     event MaxTxAmountUpdated(uint256 _maxTxAmount);
241     modifier lockTheSwap {
242         inSwap = true;
243         _;
244         inSwap = false;
245     }
246 
247     constructor() {
248         
249         _rOwned[_msgSender()] = _rTotal;
250         
251         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
252         uniswapV2Router = _uniswapV2Router;
253         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
254             .createPair(address(this), _uniswapV2Router.WETH());
255 
256         _isExcludedFromFee[owner()] = true;
257         _isExcludedFromFee[address(this)] = true;
258         _isExcludedFromFee[_marketingAddress] = true;
259         _isExcludedFromFee[_devAddress] = true;
260 
261         
262         preTrader[owner()] = true;
263         
264         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
265         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
266         bots[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
267         bots[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
268         bots[address(0xbcC7f6355bc08f6b7d3a41322CE4627118314763)] = true;
269         bots[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
270         bots[address(0x000000000035B5e5ad9019092C665357240f594e)] = true;
271         bots[address(0x1315c6C26123383a2Eb369a53Fb72C4B9f227EeC)] = true;
272         bots[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
273         bots[address(0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C)] = true;
274         bots[address(0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA)] = true;
275         bots[address(0x42c1b5e32d625b6C618A02ae15189035e0a92FE7)] = true;
276         bots[address(0xA94E56EFc384088717bb6edCccEc289A72Ec2381)] = true;
277         bots[address(0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31)] = true;
278         bots[address(0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27)] = true;
279         bots[address(0xEE2A9147ffC94A73f6b945A6DB532f8466B78830)] = true;
280         bots[address(0xdE2a6d80989C3992e11B155430c3F59792FF8Bb7)] = true;
281         bots[address(0x1e62A12D4981e428D3F4F28DF261fdCB2CE743Da)] = true;
282         bots[address(0x5136a9A5D077aE4247C7706b577F77153C32A01C)] = true;
283         bots[address(0x0E388888309d64e97F97a4740EC9Ed3DADCA71be)] = true;
284         bots[address(0x255D9BA73a51e02d26a5ab90d534DB8a80974a12)] = true;
285         bots[address(0xA682A66Ea044Aa1DC3EE315f6C36414F73054b47)] = true;
286         bots[address(0x80e09203480A49f3Cf30a4714246f7af622ba470)] = true;
287         bots[address(0x12e48B837AB8cB9104C5B95700363547bA81c8a4)] = true;
288         bots[address(0x3066Cc1523dE539D36f94597e233719727599693)] = true;
289         bots[address(0x201044fa39866E6dD3552D922CDa815899F63f20)] = true;
290         bots[address(0x6F3aC41265916DD06165b750D88AB93baF1a11F8)] = true;
291         bots[address(0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6)] = true;
292         bots[address(0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6)] = true;
293         bots[address(0x5668e6e8f3C31D140CC0bE918Ab8bB5C5B593418)] = true;
294         bots[address(0x4b9BDDFB48fB1529125C14f7730346fe0E8b5b40)] = true;
295         bots[address(0x7e2b3808cFD46fF740fBd35C584D67292A407b95)] = true;
296         bots[address(0xe89C7309595E3e720D8B316F065ecB2730e34757)] = true;
297         bots[address(0x725AD056625326B490B128E02759007BA5E4eBF1)] = true;
298 
299         emit Transfer(address(0), _msgSender(), _tTotal);
300     }
301 
302     function name() external pure returns (string memory) {
303         return _name;
304     }
305 
306     function symbol() external pure returns (string memory) {
307         return _symbol;
308     }
309 
310     function decimals() external pure returns (uint8) {
311         return _decimals;
312     }
313 
314     function totalSupply() external pure override returns (uint256) {
315         return _tTotal;
316     }
317 
318     function balanceOf(address account) public view override returns (uint256) {
319         return tokenFromReflection(_rOwned[account]);
320     }
321 
322     function transfer(address recipient, uint256 amount)
323         public
324         override
325         returns (bool)
326     {
327         _transfer(_msgSender(), recipient, amount);
328         return true;
329     }
330 
331     function allowance(address owner, address spender)
332         public
333         view
334         override
335         returns (uint256)
336     {
337         return _allowances[owner][spender];
338     }
339 
340     function approve(address spender, uint256 amount)
341         public
342         override
343         returns (bool)
344     {
345         _approve(_msgSender(), spender, amount);
346         return true;
347     }
348 
349     function transferFrom(
350         address sender,
351         address recipient,
352         uint256 amount
353     ) public override returns (bool) {
354         _transfer(sender, recipient, amount);
355         _approve(
356             sender,
357             _msgSender(),
358             _allowances[sender][_msgSender()].sub(
359                 amount,
360                 "ERC20: transfer amount exceeds allowance"
361             )
362         );
363         return true;
364     }
365 
366     function tokenFromReflection(uint256 rAmount)
367         private
368         view
369         returns (uint256)
370     {
371         require(
372             rAmount <= _rTotal,
373             "Amount must be less than total reflections"
374         );
375         uint256 currentRate = _getRate();
376         return rAmount.div(currentRate);
377     }
378 
379     function removeAllFee() private {
380         if (_redisFee == 0 && _taxFee == 0) return;
381     
382         _previousredisFee = _redisFee;
383         _previoustaxFee = _taxFee;
384         
385         _redisFee = 0;
386         _taxFee = 0;
387     }
388 
389     function restoreAllFee() private {
390         _redisFee = _previousredisFee;
391         _taxFee = _previoustaxFee;
392     }
393 
394     function _approve(
395         address owner,
396         address spender,
397         uint256 amount
398     ) private {
399         require(owner != address(0), "ERC20: approve from the zero address");
400         require(spender != address(0), "ERC20: approve to the zero address");
401         _allowances[owner][spender] = amount;
402         emit Approval(owner, spender, amount);
403     }
404 
405     function _transfer(
406         address from,
407         address to,
408         uint256 amount
409     ) private {
410         require(from != address(0), "ERC20: transfer from the zero address");
411         require(to != address(0), "ERC20: transfer to the zero address");
412         require(amount > 0, "Transfer amount must be greater than zero");
413 
414         if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
415             
416             //Trade start check
417             if (!tradingOpen) {
418                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
419             }
420               
421             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
422             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
423             
424             if(to != uniswapV2Pair) {
425                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
426             }
427             
428             uint256 contractTokenBalance = balanceOf(address(this));
429             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
430 
431             if(contractTokenBalance >= _maxTxAmount)
432             {
433                 contractTokenBalance = _maxTxAmount;
434             }
435             
436             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
437                 swapTokensForEth(contractTokenBalance);
438                 uint256 contractETHBalance = address(this).balance;
439                 if (contractETHBalance > 0) {
440                     sendETHToFee(address(this).balance);
441                 }
442             }
443         }
444         
445         bool takeFee = true;
446 
447         //Transfer Tokens
448         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
449             takeFee = false;
450         } else {
451             
452             //Set Fee for Buys
453             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
454                 _redisFee = _redisFeeOnBuy;
455                 _taxFee = _taxFeeOnBuy;
456             }
457     
458             //Set Fee for Sells
459             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
460                 _redisFee = _redisFeeOnSell;
461                 _taxFee = _taxFeeOnSell;
462             }
463             
464         }
465 
466         _tokenTransfer(from, to, amount, takeFee);
467     }
468 
469     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
470         address[] memory path = new address[](2);
471         path[0] = address(this);
472         path[1] = uniswapV2Router.WETH();
473         _approve(address(this), address(uniswapV2Router), tokenAmount);
474         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
475             tokenAmount,
476             0,
477             path,
478             address(this),
479             block.timestamp
480         );
481     }
482 
483     function sendETHToFee(uint256 amount) private {
484         _marketingAddress.transfer(amount.div(2));
485         _devAddress.transfer(amount.div(2));
486 
487     }
488 
489     function setTrading(bool _tradingOpen) public onlyOwner {
490         tradingOpen = _tradingOpen;
491     }
492 
493     function manualswap() external {
494         require(_msgSender() == _marketingAddress || _msgSender() == _devAddress);
495         uint256 contractBalance = balanceOf(address(this));
496         swapTokensForEth(contractBalance);
497     }
498 
499     function manualsend() external {
500         require(_msgSender() == _marketingAddress || _msgSender() == _devAddress);
501         uint256 contractETHBalance = address(this).balance;
502         sendETHToFee(contractETHBalance);
503     }
504 
505     function blockBots(address[] memory bots_) public onlyOwner {
506         for (uint256 i = 0; i < bots_.length; i++) {
507             bots[bots_[i]] = true;
508         }
509     }
510 
511     function unblockBot(address notbot) public onlyOwner {
512         bots[notbot] = false;
513     }
514 
515     function _tokenTransfer(
516         address sender,
517         address recipient,
518         uint256 amount,
519         bool takeFee
520     ) private {
521         if (!takeFee) removeAllFee();
522         _transferStandard(sender, recipient, amount);
523         if (!takeFee) restoreAllFee();
524     }
525 
526     function _transferStandard(
527         address sender,
528         address recipient,
529         uint256 tAmount
530     ) private {
531         (
532             uint256 rAmount,
533             uint256 rTransferAmount,
534             uint256 rFee,
535             uint256 tTransferAmount,
536             uint256 tFee,
537             uint256 tTeam
538         ) = _getValues(tAmount);
539         _rOwned[sender] = _rOwned[sender].sub(rAmount);
540         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
541         _takeTeam(tTeam);
542         _reflectFee(rFee, tFee);
543         emit Transfer(sender, recipient, tTransferAmount);
544     }
545 
546     function _takeTeam(uint256 tTeam) private {
547         uint256 currentRate = _getRate();
548         uint256 rTeam = tTeam.mul(currentRate);
549         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
550     }
551 
552     function _reflectFee(uint256 rFee, uint256 tFee) private {
553         _rTotal = _rTotal.sub(rFee);
554         _tFeeTotal = _tFeeTotal.add(tFee);
555     }
556 
557     receive() external payable {}
558 
559     function _getValues(uint256 tAmount)
560         private
561         view
562         returns (
563             uint256,
564             uint256,
565             uint256,
566             uint256,
567             uint256,
568             uint256
569         )
570     {
571         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
572             _getTValues(tAmount, _redisFee, _taxFee);
573         uint256 currentRate = _getRate();
574         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
575             _getRValues(tAmount, tFee, tTeam, currentRate);
576         
577         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
578     }
579 
580     function _getTValues(
581         uint256 tAmount,
582         uint256 redisFee,
583         uint256 taxFee
584     )
585         private
586         pure
587         returns (
588             uint256,
589             uint256,
590             uint256
591         )
592     {
593         uint256 tFee = tAmount.mul(redisFee).div(100);
594         uint256 tTeam = tAmount.mul(taxFee).div(100);
595         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
596 
597         return (tTransferAmount, tFee, tTeam);
598     }
599 
600     function _getRValues(
601         uint256 tAmount,
602         uint256 tFee,
603         uint256 tTeam,
604         uint256 currentRate
605     )
606         private
607         pure
608         returns (
609             uint256,
610             uint256,
611             uint256
612         )
613     {
614         uint256 rAmount = tAmount.mul(currentRate);
615         uint256 rFee = tFee.mul(currentRate);
616         uint256 rTeam = tTeam.mul(currentRate);
617         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
618 
619         return (rAmount, rTransferAmount, rFee);
620     }
621 
622     function _getRate() private view returns (uint256) {
623         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
624 
625         return rSupply.div(tSupply);
626     }
627 
628     function _getCurrentSupply() private view returns (uint256, uint256) {
629         uint256 rSupply = _rTotal;
630         uint256 tSupply = _tTotal;
631         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
632     
633         return (rSupply, tSupply);
634     }
635     
636     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
637         _redisFeeOnBuy = redisFeeOnBuy;
638         _redisFeeOnSell = redisFeeOnSell;
639         
640         _taxFeeOnBuy = taxFeeOnBuy;
641         _taxFeeOnSell = taxFeeOnSell;
642     }
643 
644     //Set minimum tokens required to swap.
645     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
646         _swapTokensAtAmount = swapTokensAtAmount;
647     }
648     
649     //Enable swap.
650     function toggleSwap(bool _swapEnabled) public onlyOwner {
651         swapEnabled = _swapEnabled;
652     }
653     
654     
655     //Set MAx transaction
656     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
657         _maxTxAmount = maxTxAmount;
658     }
659     
660     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
661         _maxWalletSize = maxWalletSize;
662     }
663 
664     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
665         for(uint256 i = 0; i < accounts.length; i++) {
666             _isExcludedFromFee[accounts[i]] = excluded;
667         }
668     }
669  
670     function allowPreTrading(address account, bool allowed) public onlyOwner {
671         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
672         preTrader[account] = allowed;
673     }
674 }