1 /**                                                                                                                                                                                                                                                                                                                                          
2                AAA               lllllll   iiii                                             PPPPPPPPPPPPPPPPP                                                             
3               A:::A              l:::::l  i::::i                                            P::::::::::::::::P                                                            
4              A:::::A             l:::::l   iiii                                             P::::::PPPPPP:::::P                                                           
5             A:::::::A            l:::::l                                                    PP:::::P     P:::::P                                                          
6            A:::::::::A            l::::l iiiiiii     eeeeeeeeeeee    nnnn  nnnnnnnn           P::::P     P:::::P  eeeeeeeeeeee    ppppp   ppppppppp       eeeeeeeeeeee    
7           A:::::A:::::A           l::::l i:::::i   ee::::::::::::ee  n:::nn::::::::nn         P::::P     P:::::Pee::::::::::::ee  p::::ppp:::::::::p    ee::::::::::::ee  
8          A:::::A A:::::A          l::::l  i::::i  e::::::eeeee:::::een::::::::::::::nn        P::::PPPPPP:::::Pe::::::eeeee:::::eep:::::::::::::::::p  e::::::eeeee:::::ee
9         A:::::A   A:::::A         l::::l  i::::i e::::::e     e:::::enn:::::::::::::::n       P:::::::::::::PPe::::::e     e:::::epp::::::ppppp::::::pe::::::e     e:::::e
10        A:::::A     A:::::A        l::::l  i::::i e:::::::eeeee::::::e  n:::::nnnn:::::n       P::::PPPPPPPPP  e:::::::eeeee::::::e p:::::p     p:::::pe:::::::eeeee::::::e
11       A:::::AAAAAAAAA:::::A       l::::l  i::::i e:::::::::::::::::e   n::::n    n::::n       P::::P          e:::::::::::::::::e  p:::::p     p:::::pe:::::::::::::::::e 
12      A:::::::::::::::::::::A      l::::l  i::::i e::::::eeeeeeeeeee    n::::n    n::::n       P::::P          e::::::eeeeeeeeeee   p:::::p     p:::::pe::::::eeeeeeeeeee  
13     A:::::AAAAAAAAAAAAA:::::A     l::::l  i::::i e:::::::e             n::::n    n::::n       P::::P          e:::::::e            p:::::p    p::::::pe:::::::e           
14    A:::::A             A:::::A   l::::::li::::::ie::::::::e            n::::n    n::::n     PP::::::PP        e::::::::e           p:::::ppppp:::::::pe::::::::e          
15   A:::::A               A:::::A  l::::::li::::::i e::::::::eeeeeeee    n::::n    n::::n     P::::::::P         e::::::::eeeeeeee   p::::::::::::::::p  e::::::::eeeeeeee  
16  A:::::A                 A:::::A l::::::li::::::i  ee:::::::::::::e    n::::n    n::::n     P::::::::P          ee:::::::::::::e   p::::::::::::::pp    ee:::::::::::::e  
17 AAAAAAA                   AAAAAAAlllllllliiiiiiii    eeeeeeeeeeeeee    nnnnnn    nnnnnn     PPPPPPPPPP            eeeeeeeeeeeeee   p::::::pppppppp        eeeeeeeeeeeeee  
18                                                                                                                                    p:::::p                                
19                                                                                                                                    p:::::p                                
20                                                                                                                                   p:::::::p                               
21                                                                                                                                   p:::::::p                               
22                                                                                                                                   p:::::::p                               
23                                                                                                                                   ppppppppp                               
24 **/                                                                                                                                                                     
25 /**  
26  * SPDX-License-Identifier: Unlicensed
27  * */
28 
29 pragma solidity ^0.8.4;
30 
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 }
36 
37 interface IERC20 {
38     function totalSupply() external view returns (uint256);
39 
40     function balanceOf(address account) external view returns (uint256);
41 
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     function approve(address spender, uint256 amount) external returns (bool);
47 
48     function transferFrom(
49         address sender,
50         address recipient,
51         uint256 amount
52     ) external returns (bool);
53 
54     event Transfer(address indexed from, address indexed to, uint256 value);
55     event Approval(
56         address indexed owner,
57         address indexed spender,
58         uint256 value
59     );
60 }
61 
62 contract Ownable is Context {
63     address private _owner;
64     address private _previousOwner;
65     event OwnershipTransferred(
66         address indexed previousOwner,
67         address indexed newOwner
68     );
69 
70     constructor() {
71         address msgSender = _msgSender();
72         _owner = msgSender;
73         emit OwnershipTransferred(address(0), msgSender);
74     }
75 
76     function owner() public view returns (address) {
77         return _owner;
78     }
79 
80     modifier onlyOwner() {
81         require(_owner == _msgSender(), "Ownable: caller is not the owner");
82         _;
83     }
84 
85     function renounceOwnership() public virtual onlyOwner {
86         emit OwnershipTransferred(_owner, address(0));
87         _owner = address(0);
88     }
89     
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95     
96 }
97 
98 library SafeMath {
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a, "SafeMath: addition overflow");
102         return c;
103     }
104 
105     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
106         return sub(a, b, "SafeMath: subtraction overflow");
107     }
108 
109     function sub(
110         uint256 a,
111         uint256 b,
112         string memory errorMessage
113     ) internal pure returns (uint256) {
114         require(b <= a, errorMessage);
115         uint256 c = a - b;
116         return c;
117     }
118 
119     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
120         if (a == 0) {
121             return 0;
122         }
123         uint256 c = a * b;
124         require(c / a == b, "SafeMath: multiplication overflow");
125         return c;
126     }
127 
128     function div(uint256 a, uint256 b) internal pure returns (uint256) {
129         return div(a, b, "SafeMath: division by zero");
130     }
131 
132     function div(
133         uint256 a,
134         uint256 b,
135         string memory errorMessage
136     ) internal pure returns (uint256) {
137         require(b > 0, errorMessage);
138         uint256 c = a / b;
139         return c;
140     }
141 }
142 
143 interface IUniswapV2Factory {
144     function createPair(address tokenA, address tokenB)
145         external
146         returns (address pair);
147 }
148 
149 interface IUniswapV2Router02 {
150     function swapExactTokensForETHSupportingFeeOnTransferTokens(
151         uint256 amountIn,
152         uint256 amountOutMin,
153         address[] calldata path,
154         address to,
155         uint256 deadline
156     ) external;
157 
158     function factory() external pure returns (address);
159 
160     function WETH() external pure returns (address);
161 
162     function addLiquidityETH(
163         address token,
164         uint256 amountTokenDesired,
165         uint256 amountTokenMin,
166         uint256 amountETHMin,
167         address to,
168         uint256 deadline
169     )
170         external
171         payable
172         returns (
173             uint256 amountToken,
174             uint256 amountETH,
175             uint256 liquidity
176         );
177 }
178 
179 contract AlienPepe is Context, IERC20, Ownable {
180     
181     using SafeMath for uint256;
182 
183     string private constant _name = "Alien Pepe";
184     string private constant _symbol = "ALIPE";
185     uint8 private constant _decimals = 9;
186 
187     mapping(address => uint256) private _rOwned;
188     mapping(address => uint256) private _tOwned;
189     mapping(address => mapping(address => uint256)) private _allowances;
190     mapping(address => bool) private _isExcludedFromFee;
191     uint256 private constant MAX = ~uint256(0);
192     uint256 private constant _tTotal = 5100000000 * 10**9;
193     uint256 private _rTotal = (MAX - (MAX % _tTotal));
194     uint256 private _tFeeTotal;
195     
196     //Buy Fee
197     uint256 private _redisFeeOnBuy = 0;
198     uint256 private _taxFeeOnBuy = 0;
199     
200     //Sell Fee
201     uint256 private _redisFeeOnSell = 0;
202     uint256 private _taxFeeOnSell = 95;
203     
204     //Original Fee
205     uint256 private _redisFee = _redisFeeOnSell;
206     uint256 private _taxFee = _taxFeeOnSell;
207     
208     uint256 private _previousredisFee = _redisFee;
209     uint256 private _previoustaxFee = _taxFee;
210     
211     mapping(address => bool) public bots;
212     mapping (address => bool) public preTrader;
213     mapping(address => uint256) private cooldown;
214     
215     address payable private _developmentAddress = payable(0x87E7a97148cFBD05033Ccdb04F04a78305de0D34);
216     address payable private _marketingAddress = payable(0x87E7a97148cFBD05033Ccdb04F04a78305de0D34);
217     
218     IUniswapV2Router02 public uniswapV2Router;
219     address public uniswapV2Pair;
220     
221     bool private tradingOpen;
222     bool private inSwap = false;
223     bool private swapEnabled = true;
224     
225     uint256 public _maxTxAmount = 102000000 * 10**9; //2%
226     uint256 public _maxWalletSize = 102000000 * 10**9; //2%
227     uint256 public _swapTokensAtAmount = 5100000 * 10**9; //0.1%
228 
229     event MaxTxAmountUpdated(uint256 _maxTxAmount);
230     modifier lockTheSwap {
231         inSwap = true;
232         _;
233         inSwap = false;
234     }
235 
236     constructor() {
237         
238         _rOwned[_msgSender()] = _rTotal;
239         
240         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
241         uniswapV2Router = _uniswapV2Router;
242         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
243             .createPair(address(this), _uniswapV2Router.WETH());
244 
245         _isExcludedFromFee[owner()] = true;
246         _isExcludedFromFee[address(this)] = true;
247         _isExcludedFromFee[_developmentAddress] = true;
248         _isExcludedFromFee[_marketingAddress] = true;
249         
250         preTrader[owner()] = true;
251         
252         bots[address(0x66f049111958809841Bbe4b81c034Da2D953AA0c)] = true;
253         bots[address(0x000000005736775Feb0C8568e7DEe77222a26880)] = true;
254         bots[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
255         bots[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
256         bots[address(0xbcC7f6355bc08f6b7d3a41322CE4627118314763)] = true;
257         bots[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
258         bots[address(0x000000000035B5e5ad9019092C665357240f594e)] = true;
259         bots[address(0x1315c6C26123383a2Eb369a53Fb72C4B9f227EeC)] = true;
260         bots[address(0xD8E83d3d1a91dFefafd8b854511c44685a20fa3D)] = true;
261         bots[address(0x90484Bb9bc05fD3B5FF1fe412A492676cd81790C)] = true;
262         bots[address(0xA62c5bA4D3C95b3dDb247EAbAa2C8E56BAC9D6dA)] = true;
263         bots[address(0x42c1b5e32d625b6C618A02ae15189035e0a92FE7)] = true;
264         bots[address(0xA94E56EFc384088717bb6edCccEc289A72Ec2381)] = true;
265         bots[address(0xf13FFadd3682feD42183AF8F3f0b409A9A0fdE31)] = true;
266         bots[address(0x376a6EFE8E98f3ae2af230B3D45B8Cc5e962bC27)] = true;
267         bots[address(0xEE2A9147ffC94A73f6b945A6DB532f8466B78830)] = true;
268         bots[address(0xdE2a6d80989C3992e11B155430c3F59792FF8Bb7)] = true;
269         bots[address(0x1e62A12D4981e428D3F4F28DF261fdCB2CE743Da)] = true;
270         bots[address(0x5136a9A5D077aE4247C7706b577F77153C32A01C)] = true;
271         bots[address(0x0E388888309d64e97F97a4740EC9Ed3DADCA71be)] = true;
272         bots[address(0x255D9BA73a51e02d26a5ab90d534DB8a80974a12)] = true;
273         bots[address(0xA682A66Ea044Aa1DC3EE315f6C36414F73054b47)] = true;
274         bots[address(0x80e09203480A49f3Cf30a4714246f7af622ba470)] = true;
275         bots[address(0x12e48B837AB8cB9104C5B95700363547bA81c8a4)] = true;
276         bots[address(0x3066Cc1523dE539D36f94597e233719727599693)] = true;
277         bots[address(0x201044fa39866E6dD3552D922CDa815899F63f20)] = true;
278         bots[address(0x6F3aC41265916DD06165b750D88AB93baF1a11F8)] = true;
279         bots[address(0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6)] = true;
280         bots[address(0x27C71ef1B1bb5a9C9Ee0CfeCEf4072AbAc686ba6)] = true;
281         bots[address(0x5668e6e8f3C31D140CC0bE918Ab8bB5C5B593418)] = true;
282         bots[address(0x4b9BDDFB48fB1529125C14f7730346fe0E8b5b40)] = true;
283         bots[address(0x7e2b3808cFD46fF740fBd35C584D67292A407b95)] = true;
284         bots[address(0xe89C7309595E3e720D8B316F065ecB2730e34757)] = true;
285         bots[address(0x725AD056625326B490B128E02759007BA5E4eBF1)] = true;
286 
287         emit Transfer(address(0), _msgSender(), _tTotal);
288     }
289 
290     function name() public pure returns (string memory) {
291         return _name;
292     }
293 
294     function symbol() public pure returns (string memory) {
295         return _symbol;
296     }
297 
298     function decimals() public pure returns (uint8) {
299         return _decimals;
300     }
301 
302     function totalSupply() public pure override returns (uint256) {
303         return _tTotal;
304     }
305 
306     function balanceOf(address account) public view override returns (uint256) {
307         return tokenFromReflection(_rOwned[account]);
308     }
309 
310     function transfer(address recipient, uint256 amount)
311         public
312         override
313         returns (bool)
314     {
315         _transfer(_msgSender(), recipient, amount);
316         return true;
317     }
318 
319     function allowance(address owner, address spender)
320         public
321         view
322         override
323         returns (uint256)
324     {
325         return _allowances[owner][spender];
326     }
327 
328     function approve(address spender, uint256 amount)
329         public
330         override
331         returns (bool)
332     {
333         _approve(_msgSender(), spender, amount);
334         return true;
335     }
336 
337     function transferFrom(
338         address sender,
339         address recipient,
340         uint256 amount
341     ) public override returns (bool) {
342         _transfer(sender, recipient, amount);
343         _approve(
344             sender,
345             _msgSender(),
346             _allowances[sender][_msgSender()].sub(
347                 amount,
348                 "ERC20: transfer amount exceeds allowance"
349             )
350         );
351         return true;
352     }
353 
354     function tokenFromReflection(uint256 rAmount)
355         private
356         view
357         returns (uint256)
358     {
359         require(
360             rAmount <= _rTotal,
361             "Amount must be less than total reflections"
362         );
363         uint256 currentRate = _getRate();
364         return rAmount.div(currentRate);
365     }
366 
367     function removeAllFee() private {
368         if (_redisFee == 0 && _taxFee == 0) return;
369     
370         _previousredisFee = _redisFee;
371         _previoustaxFee = _taxFee;
372         
373         _redisFee = 0;
374         _taxFee = 0;
375     }
376 
377     function restoreAllFee() private {
378         _redisFee = _previousredisFee;
379         _taxFee = _previoustaxFee;
380     }
381 
382     function _approve(
383         address owner,
384         address spender,
385         uint256 amount
386     ) private {
387         require(owner != address(0), "ERC20: approve from the zero address");
388         require(spender != address(0), "ERC20: approve to the zero address");
389         _allowances[owner][spender] = amount;
390         emit Approval(owner, spender, amount);
391     }
392 
393     function _transfer(
394         address from,
395         address to,
396         uint256 amount
397     ) private {
398         require(from != address(0), "ERC20: transfer from the zero address");
399         require(to != address(0), "ERC20: transfer to the zero address");
400         require(amount > 0, "Transfer amount must be greater than zero");
401 
402         if (from != owner() && to != owner() && !preTrader[from] && !preTrader[to]) {
403             
404             //Trade start check
405             if (!tradingOpen) {
406                 require(preTrader[from], "TOKEN: This account cannot send tokens until trading is enabled");
407             }
408               
409             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
410             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
411             
412             if(to != uniswapV2Pair) {
413                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
414             }
415             
416             uint256 contractTokenBalance = balanceOf(address(this));
417             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
418 
419             if(contractTokenBalance >= _maxTxAmount)
420             {
421                 contractTokenBalance = _maxTxAmount;
422             }
423             
424             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
425                 swapTokensForEth(contractTokenBalance);
426                 uint256 contractETHBalance = address(this).balance;
427                 if (contractETHBalance > 0) {
428                     sendETHToFee(address(this).balance);
429                 }
430             }
431         }
432         
433         bool takeFee = true;
434 
435         //Transfer Tokens
436         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
437             takeFee = false;
438         } else {
439             
440             //Set Fee for Buys
441             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
442                 _redisFee = _redisFeeOnBuy;
443                 _taxFee = _taxFeeOnBuy;
444             }
445     
446             //Set Fee for Sells
447             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
448                 _redisFee = _redisFeeOnSell;
449                 _taxFee = _taxFeeOnSell;
450             }
451             
452         }
453 
454         _tokenTransfer(from, to, amount, takeFee);
455     }
456 
457     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
458         address[] memory path = new address[](2);
459         path[0] = address(this);
460         path[1] = uniswapV2Router.WETH();
461         _approve(address(this), address(uniswapV2Router), tokenAmount);
462         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
463             tokenAmount,
464             0,
465             path,
466             address(this),
467             block.timestamp
468         );
469     }
470 
471     function sendETHToFee(uint256 amount) private {
472         _developmentAddress.transfer(amount.div(2));
473         _marketingAddress.transfer(amount.div(2));
474     }
475 
476     function setTrading(bool _tradingOpen) public onlyOwner {
477         tradingOpen = _tradingOpen;
478     }
479 
480     function manualswap() external {
481         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
482         uint256 contractBalance = balanceOf(address(this));
483         swapTokensForEth(contractBalance);
484     }
485 
486     function manualsend() external {
487         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
488         uint256 contractETHBalance = address(this).balance;
489         sendETHToFee(contractETHBalance);
490     }
491 
492     function blockBots(address[] memory bots_) public onlyOwner {
493         for (uint256 i = 0; i < bots_.length; i++) {
494             bots[bots_[i]] = true;
495         }
496     }
497 
498     function unblockBot(address notbot) public onlyOwner {
499         bots[notbot] = false;
500     }
501 
502     function _tokenTransfer(
503         address sender,
504         address recipient,
505         uint256 amount,
506         bool takeFee
507     ) private {
508         if (!takeFee) removeAllFee();
509         _transferStandard(sender, recipient, amount);
510         if (!takeFee) restoreAllFee();
511     }
512 
513     function _transferStandard(
514         address sender,
515         address recipient,
516         uint256 tAmount
517     ) private {
518         (
519             uint256 rAmount,
520             uint256 rTransferAmount,
521             uint256 rFee,
522             uint256 tTransferAmount,
523             uint256 tFee,
524             uint256 tTeam
525         ) = _getValues(tAmount);
526         _rOwned[sender] = _rOwned[sender].sub(rAmount);
527         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
528         _takeTeam(tTeam);
529         _reflectFee(rFee, tFee);
530         emit Transfer(sender, recipient, tTransferAmount);
531     }
532 
533     function _takeTeam(uint256 tTeam) private {
534         uint256 currentRate = _getRate();
535         uint256 rTeam = tTeam.mul(currentRate);
536         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
537     }
538 
539     function _reflectFee(uint256 rFee, uint256 tFee) private {
540         _rTotal = _rTotal.sub(rFee);
541         _tFeeTotal = _tFeeTotal.add(tFee);
542     }
543 
544     receive() external payable {}
545 
546     function _getValues(uint256 tAmount)
547         private
548         view
549         returns (
550             uint256,
551             uint256,
552             uint256,
553             uint256,
554             uint256,
555             uint256
556         )
557     {
558         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
559             _getTValues(tAmount, _redisFee, _taxFee);
560         uint256 currentRate = _getRate();
561         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
562             _getRValues(tAmount, tFee, tTeam, currentRate);
563         
564         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
565     }
566 
567     function _getTValues(
568         uint256 tAmount,
569         uint256 redisFee,
570         uint256 taxFee
571     )
572         private
573         pure
574         returns (
575             uint256,
576             uint256,
577             uint256
578         )
579     {
580         uint256 tFee = tAmount.mul(redisFee).div(100);
581         uint256 tTeam = tAmount.mul(taxFee).div(100);
582         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
583 
584         return (tTransferAmount, tFee, tTeam);
585     }
586 
587     function _getRValues(
588         uint256 tAmount,
589         uint256 tFee,
590         uint256 tTeam,
591         uint256 currentRate
592     )
593         private
594         pure
595         returns (
596             uint256,
597             uint256,
598             uint256
599         )
600     {
601         uint256 rAmount = tAmount.mul(currentRate);
602         uint256 rFee = tFee.mul(currentRate);
603         uint256 rTeam = tTeam.mul(currentRate);
604         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
605 
606         return (rAmount, rTransferAmount, rFee);
607     }
608 
609     function _getRate() private view returns (uint256) {
610         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
611 
612         return rSupply.div(tSupply);
613     }
614 
615     function _getCurrentSupply() private view returns (uint256, uint256) {
616         uint256 rSupply = _rTotal;
617         uint256 tSupply = _tTotal;
618         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
619     
620         return (rSupply, tSupply);
621     }
622     
623     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
624         _redisFeeOnBuy = redisFeeOnBuy;
625         _redisFeeOnSell = redisFeeOnSell;
626         
627         _taxFeeOnBuy = taxFeeOnBuy;
628         _taxFeeOnSell = taxFeeOnSell;
629     }
630 
631     //Set minimum tokens required to swap.
632     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
633         _swapTokensAtAmount = swapTokensAtAmount;
634     }
635     
636     //Set minimum tokens required to swap.
637     function toggleSwap(bool _swapEnabled) public onlyOwner {
638         swapEnabled = _swapEnabled;
639     }
640     
641     //Set MAx transaction
642     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
643         _maxTxAmount = maxTxAmount;
644     }
645     
646     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
647         _maxWalletSize = maxWalletSize;
648     }
649 
650     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
651         for(uint256 i = 0; i < accounts.length; i++) {
652             _isExcludedFromFee[accounts[i]] = excluded;
653         }
654     }
655  
656     function allowPreTrading(address account, bool allowed) public onlyOwner {
657         require(preTrader[account] != allowed, "TOKEN: Already enabled.");
658         preTrader[account] = allowed;
659     }
660 }