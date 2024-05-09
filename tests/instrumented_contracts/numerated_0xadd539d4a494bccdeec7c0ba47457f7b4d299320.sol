1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.8.14;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 }
10 
11 interface IERC20 {
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
22     function transferFrom(
23         address sender,
24         address recipient,
25         uint256 amount
26     ) external returns (bool);
27 
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(
30         address indexed owner,
31         address indexed spender,
32         uint256 value
33     );
34 }
35 
36 contract Ownable is Context {
37     address private _owner;
38     event OwnershipTransferred(
39         address indexed previousOwner,
40         address indexed newOwner
41     );
42 
43     constructor() {
44         address msgSender = _msgSender();
45         _owner = msgSender;
46         emit OwnershipTransferred(address(0), msgSender);
47     }
48 
49     function owner() public view returns (address) {
50         return _owner;
51     }
52 
53     modifier onlyOwner() {
54         require(_owner == _msgSender(), "Ownable: caller is not the owner");
55         _;
56     }
57 
58     function renounceOwnership() public virtual onlyOwner {
59         emit OwnershipTransferred(_owner, address(0));
60         _owner = address(0);
61     }
62 
63     function transferOwnership(address newOwner) public virtual onlyOwner {
64         require(newOwner != address(0), "Ownable: new owner is the zero address");
65         emit OwnershipTransferred(_owner, newOwner);
66         _owner = newOwner;
67     }
68 
69 }
70 
71 library SafeMath {
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a, "SafeMath: addition overflow");
75         return c;
76     }
77 
78     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79         return sub(a, b, "SafeMath: subtraction overflow");
80     }
81 
82     function sub(
83         uint256 a,
84         uint256 b,
85         string memory errorMessage
86     ) internal pure returns (uint256) {
87         require(b <= a, errorMessage);
88         uint256 c = a - b;
89         return c;
90     }
91 
92     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
93         if (a == 0) {
94             return 0;
95         }
96         uint256 c = a * b;
97         require(c / a == b, "SafeMath: multiplication overflow");
98         return c;
99     }
100 
101     function div(uint256 a, uint256 b) internal pure returns (uint256) {
102         return div(a, b, "SafeMath: division by zero");
103     }
104 
105     function div(
106         uint256 a,
107         uint256 b,
108         string memory errorMessage
109     ) internal pure returns (uint256) {
110         require(b > 0, errorMessage);
111         uint256 c = a / b;
112         return c;
113     }
114 }
115 
116 interface IUniswapV2Factory {
117     function createPair(address tokenA, address tokenB)
118         external
119         returns (address pair);
120 }
121 
122 interface IUniswapV2Router02 {
123     function swapExactTokensForTokens(
124         uint amountIn,
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external returns (uint[] memory amounts);
130 
131     function factory() external pure returns (address);
132 
133     function addLiquidity(
134         address tokenA,
135         address tokenB,
136         uint amountADesired,
137         uint amountBDesired,
138         uint amountAMin,
139         uint amountBMin,
140         address to,
141         uint deadline
142     ) external returns (uint amountA, uint amountB, uint liquidity);
143 }
144 
145 contract Wind is Context, IERC20, Ownable {
146 
147     using SafeMath for uint256;
148 
149     string private constant _name = "The Wind Blows";
150     string private constant _symbol = "$WIND";
151     uint8 private constant _decimals = 18;
152 
153     mapping(address => uint256) private _rOwned;
154     mapping(address => uint256) private _tOwned;
155     mapping(address => mapping(address => uint256)) private _allowances;
156     mapping(address => bool) private _isExcludedFromFee;
157     uint256 private constant MAX = ~uint256(0);
158     uint256 private constant _tTotal = 20153897920192521 * 1e10;
159     uint256 private _rTotal = (MAX - (MAX % _tTotal));
160     uint256 private _tFeeTotal;
161     uint256 private _redisFeeOnBuy = 0;
162     uint256 private _taxFeeOnBuy = 66;      // 0.66 %
163     uint256 private _redisFeeOnSell = 0;
164     uint256 private _taxFeeOnSell = 66;     // 0.66 %
165 
166     //Original Fee
167     uint256 private _redisFee = _redisFeeOnSell;
168     uint256 private _taxFee = _taxFeeOnSell;
169 
170     uint256 private _previousredisFee = _redisFee;
171     uint256 private _previoustaxFee = _taxFee;
172     
173     IUniswapV2Router02 public uniswapV2Router;
174     address public uniswapV2Pair;
175     address public immutable usdc;
176     address public immutable dai;
177     address public immutable weth;
178     address public immutable caw;
179     address public immutable qom;
180     address public immutable o;
181     address private buybackwallet;
182     
183     bool private tradingOpen;
184     bool private inSwap = false;
185     bool private swapEnabled = true;
186 
187     uint256 private autoBuyToken;
188     
189     uint256 public _swapTokensAtAmount = 2 * 1e6 * 1e18;
190 
191     modifier lockTheSwap {
192         inSwap = true;
193         _;
194         inSwap = false;
195     }
196 
197     constructor() {
198 		usdc = address(0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48);
199         dai = address(0x6B175474E89094C44Da98b954EedeAC495271d0F);
200         weth = address(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
201         caw = address(0xf3b9569F82B18aEf890De263B84189bd33EBe452);
202         qom = address(0xa71d0588EAf47f12B13cF8eC750430d21DF04974);
203         o = address(0xb53ecF1345caBeE6eA1a65100Ebb153cEbcac40f);
204         
205         buybackwallet = address(0x89d1fC54F46Cb6A1dd0fac0D4DAc173578537874);
206 
207         autoBuyToken = 1; // 1 = CAW, 2 = O, 3 = QOM
208 
209         _rOwned[_msgSender()] = _rTotal;
210 
211         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
212         uniswapV2Router = _uniswapV2Router;
213         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
214             .createPair(address(this), usdc);
215 
216         _isExcludedFromFee[owner()] = true;
217         _isExcludedFromFee[address(this)] = true;
218         _isExcludedFromFee[buybackwallet] = true;
219       
220         emit Transfer(address(0), _msgSender(), _tTotal);
221     }
222 
223     function name() public pure returns (string memory) {
224         return _name;
225     }
226 
227     function symbol() public pure returns (string memory) {
228         return _symbol;
229     }
230 
231     function decimals() public pure returns (uint8) {
232         return _decimals;
233     }
234 
235     function totalSupply() public pure override returns (uint256) {
236         return _tTotal;
237     }
238 
239     function balanceOf(address account) public view override returns (uint256) {
240         return tokenFromReflection(_rOwned[account]);
241     }
242 
243     function transfer(address recipient, uint256 amount)
244         public
245         override
246         returns (bool)
247     {
248         _transfer(_msgSender(), recipient, amount);
249         return true;
250     }
251 
252     function allowance(address owner, address spender)
253         public
254         view
255         override
256         returns (uint256)
257     {
258         return _allowances[owner][spender];
259     }
260 
261     function approve(address spender, uint256 amount)
262         public
263         override
264         returns (bool)
265     {
266         _approve(_msgSender(), spender, amount);
267         return true;
268     }
269 
270     function transferFrom(
271         address sender,
272         address recipient,
273         uint256 amount
274     ) public override returns (bool) {
275         _transfer(sender, recipient, amount);
276         _approve(
277             sender,
278             _msgSender(),
279             _allowances[sender][_msgSender()].sub(
280                 amount,
281                 "ERC20: transfer amount exceeds allowance"
282             )
283         );
284         return true;
285     }
286 
287     function tokenFromReflection(uint256 rAmount)
288         private
289         view
290         returns (uint256)
291     {
292         require(
293             rAmount <= _rTotal,
294             "Amount must be less than total reflections"
295         );
296         uint256 currentRate = _getRate();
297         return rAmount.div(currentRate);
298     }
299 
300     function removeAllFee() private {
301         if (_redisFee == 0 && _taxFee == 0) return;
302 
303         _previousredisFee = _redisFee;
304         _previoustaxFee = _taxFee;
305 
306         _redisFee = 0;
307         _taxFee = 0;
308     }
309 
310     function restoreAllFee() private {
311         _redisFee = _previousredisFee;
312         _taxFee = _previoustaxFee;
313     }
314 
315     function _approve(
316         address owner,
317         address spender,
318         uint256 amount
319     ) private {
320         require(owner != address(0), "ERC20: approve from the zero address");
321         require(spender != address(0), "ERC20: approve to the zero address");
322         _allowances[owner][spender] = amount;
323         emit Approval(owner, spender, amount);
324     }
325 
326     function _transfer(
327         address from,
328         address to,
329         uint256 amount
330     ) private {
331         require(from != address(0), "ERC20: transfer from the zero address");
332         require(to != address(0), "ERC20: transfer to the zero address");
333         require(amount > 0, "Transfer amount must be greater than zero");
334 
335         if (from != owner() && to != owner()) {
336 
337             //Trading open check
338             if (!tradingOpen) {
339                 require(_isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading is not active.");
340             }
341 
342             uint256 contractTokenBalance = balanceOf(address(this));
343             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
344 
345             if(contractTokenBalance >= _swapTokensAtAmount * 20)
346             {
347                 contractTokenBalance = _swapTokensAtAmount * 20;
348             }
349 
350             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
351                 autoBuyBack(contractTokenBalance);
352             }
353         }
354 
355         bool takeFee = true;
356 
357         //Transfer Tokens
358         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
359             takeFee = false;
360         } else {
361 
362             //Set Fee for Buys
363             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
364                 _redisFee = _redisFeeOnBuy;
365                 _taxFee = _taxFeeOnBuy;
366             }
367 
368             //Set Fee for Sells
369             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
370                 _redisFee = _redisFeeOnSell;
371                 _taxFee = _taxFeeOnSell;
372             }
373 
374         }
375 
376         _tokenTransfer(from, to, amount, takeFee);
377     }
378 
379     function autoBuyBack(uint256 tokenAmount) private lockTheSwap {
380 
381         address[] memory path = new address[](5);
382 
383         // Define autobuyback path
384 
385         if (autoBuyToken == 1) {
386             // CAW buyback
387             path[0] = address(this);
388             path[1] = usdc;
389             path[2] = caw;
390         } else if (autoBuyToken == 2) {
391             // O buyback
392             path[0] = address(this);
393             path[1] = usdc;
394             path[2] = weth;
395             path[3] = dai;
396             path[4] = o;
397         } else if (autoBuyToken == 3) {
398             // QOM buyback
399             path[0] = address(this);
400             path[1] = usdc;
401             path[2] = weth;
402             path[3] = qom;
403         }
404 
405         _approve(address(this), address(uniswapV2Router), tokenAmount);
406 
407         uniswapV2Router.swapExactTokensForTokens(
408             tokenAmount,
409             0,
410             path,
411             buybackwallet,
412             block.timestamp
413         );
414     }
415 
416 	function openTrading() public onlyOwner {
417 		tradingOpen = true;
418 	}
419 	
420     function changeBuyBackToken(uint256 _autoBuyToken) public onlyOwner {
421         require((_autoBuyToken == 1  || _autoBuyToken == 2 || autoBuyToken == 3), "Wrong Input!");
422         autoBuyToken = _autoBuyToken;
423     }
424 
425     function _tokenTransfer(
426         address sender,
427         address recipient,
428         uint256 amount,
429         bool takeFee
430     ) private {
431         if (!takeFee) removeAllFee();
432         _transferStandard(sender, recipient, amount);
433         if (!takeFee) restoreAllFee();
434     }
435 
436     function _transferStandard(
437         address sender,
438         address recipient,
439         uint256 tAmount
440     ) private {
441         (
442             uint256 rAmount,
443             uint256 rTransferAmount,
444             uint256 rFee,
445             uint256 tTransferAmount,
446             uint256 tFee,
447             uint256 tTeam
448         ) = _getValues(tAmount);
449         _rOwned[sender] = _rOwned[sender].sub(rAmount);
450         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
451         _takeTeam(tTeam);
452         _reflectFee(rFee, tFee);
453         emit Transfer(sender, recipient, tTransferAmount);
454     }
455 
456     function _takeTeam(uint256 tTeam) private {
457         uint256 currentRate = _getRate();
458         uint256 rTeam = tTeam.mul(currentRate);
459         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
460     }
461 
462     function _reflectFee(uint256 rFee, uint256 tFee) private {
463         _rTotal = _rTotal.sub(rFee);
464         _tFeeTotal = _tFeeTotal.add(tFee);
465     }
466 
467     receive() external payable {
468     }
469 
470     function _getValues(uint256 tAmount)
471         private
472         view
473         returns (
474             uint256,
475             uint256,
476             uint256,
477             uint256,
478             uint256,
479             uint256
480         )
481     {
482         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
483             _getTValues(tAmount, _redisFee, _taxFee);
484         uint256 currentRate = _getRate();
485         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
486             _getRValues(tAmount, tFee, tTeam, currentRate);
487         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
488     }
489 
490     function _getTValues(
491         uint256 tAmount,
492         uint256 redisFee,
493         uint256 taxFee
494     )
495         private
496         pure
497         returns (
498             uint256,
499             uint256,
500             uint256
501         )
502     {
503         uint256 tFee = tAmount.mul(redisFee).div(10000);
504         uint256 tTeam = tAmount.mul(taxFee).div(10000);
505         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
506         return (tTransferAmount, tFee, tTeam);
507     }
508 
509     function _getRValues(
510         uint256 tAmount,
511         uint256 tFee,
512         uint256 tTeam,
513         uint256 currentRate
514     )
515         private
516         pure
517         returns (
518             uint256,
519             uint256,
520             uint256
521         )
522     {
523         uint256 rAmount = tAmount.mul(currentRate);
524         uint256 rFee = tFee.mul(currentRate);
525         uint256 rTeam = tTeam.mul(currentRate);
526         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
527         return (rAmount, rTransferAmount, rFee);
528     }
529 
530     function _getRate() private view returns (uint256) {
531         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
532         return rSupply.div(tSupply);
533     }
534 
535     function _getCurrentSupply() private view returns (uint256, uint256) {
536         uint256 rSupply = _rTotal;
537         uint256 tSupply = _tTotal;
538         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
539         return (rSupply, tSupply);
540     }
541 
542 }