1 /*
2 #################################################
3 ## Telegram: https://t.me/jointhevibes         ##
4 ## Twitter:  https://twitter.com/jointhevibes  ##
5 ## Website:  https://justvibes.xyz             ##
6 #################################################
7 */
8 
9 // SPDX-License-Identifier: Unlicensed
10 pragma solidity ^0.8.9;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17  
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20 
21     function balanceOf(address account) external view returns (uint256);
22 
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     function allowance(address owner, address spender) external view returns (uint256);
26 
27     function approve(address spender, uint256 amount) external returns (bool);
28 
29     function transferFrom(
30         address sender,
31         address recipient,
32         uint256 amount
33     ) external returns (bool);
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(
37         address indexed owner,
38         address indexed spender,
39         uint256 value
40     );  
41 }
42 
43 contract Ownable is Context {
44     address private _owner;
45     address private _previousOwner;
46     event OwnershipTransferred(
47         address indexed previousOwner,
48         address indexed newOwner
49     );
50 
51     constructor() {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         emit OwnershipTransferred(address(0), msgSender);
55     }
56 
57     function owner() public view returns (address) {
58         return _owner;
59     }
60 
61     modifier onlyOwner() {
62         require(_owner == _msgSender(), "Ownable: caller is not the owner");
63         _;
64     }
65 
66     function renounceOwnership() public virtual onlyOwner {
67         emit OwnershipTransferred(_owner, address(0));
68         _owner = address(0);
69     }
70 
71     function transferOwnership(address newOwner) public virtual onlyOwner {
72         require(newOwner != address(0), "Ownable: new owner is the zero address");
73         emit OwnershipTransferred(_owner, newOwner);
74         _owner = newOwner;
75     }
76 
77 }
78 
79 library SafeMath {
80     function add(uint256 a, uint256 b) internal pure returns (uint256) {
81         uint256 c = a + b;
82         require(c >= a, "SafeMath: addition overflow");
83         return c;
84     }
85 
86     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
87         return sub(a, b, "SafeMath: subtraction overflow");
88     }
89 
90     function sub(
91         uint256 a,
92         uint256 b,
93         string memory errorMessage
94     ) internal pure returns (uint256) {
95         require(b <= a, errorMessage);
96         uint256 c = a - b;
97         return c;
98     }
99 
100     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
101         if (a == 0) {
102             return 0;
103         }
104         uint256 c = a * b;
105         require(c / a == b, "SafeMath: multiplication overflow");
106         return c;
107     }
108 
109     function div(uint256 a, uint256 b) internal pure returns (uint256) {
110         return div(a, b, "SafeMath: division by zero");
111     }
112 
113     function div(
114         uint256 a,
115         uint256 b,
116         string memory errorMessage
117     ) internal pure returns (uint256) {
118         require(b > 0, errorMessage);
119         uint256 c = a / b;
120         return c;
121     }
122 }
123 
124 interface IUniswapV2Factory {
125     function createPair(address tokenA, address tokenB)
126         external
127         returns (address pair);
128 }
129 
130 interface IUniswapV2Router02 {
131     function swapExactTokensForETHSupportingFeeOnTransferTokens(
132         uint256 amountIn,
133         uint256 amountOutMin,
134         address[] calldata path,
135         address to,
136         address referrer,
137         uint256 deadline
138     ) external;
139 
140     function factory() external pure returns (address);
141 
142     function WETH() external pure returns (address);
143 }
144 
145 contract VIBES is Context, IERC20, Ownable {
146 
147     using SafeMath for uint256;
148 
149     string private constant _name = unicode"Vibes";
150     string private constant _symbol = unicode"VIBES";
151     uint8 private constant _decimals = 9;
152  
153     mapping(address => uint256) private _rOwned;
154     mapping(address => uint256) private _tOwned;
155     mapping(address => mapping(address => uint256)) private _allowances;
156     mapping(address => bool) private _isExcludedFromFee;
157     uint256 private constant MAX = ~uint256(0);
158     uint256 private constant _tTotal = 444_333_222_111 * 10**_decimals;
159     uint256 private _rTotal = (MAX - (MAX % _tTotal));
160     uint256 private _tFeeTotal;
161     uint256 private _redisFeeOnBuy = 0;
162     uint256 private _taxFeeOnBuy = 25;
163     uint256 private _redisFeeOnSell = 0;
164     uint256 private _taxFeeOnSell = 50;
165   
166     uint256 private _redisFee = _redisFeeOnSell;
167     uint256 private _taxFee = _taxFeeOnSell;
168 
169     uint256 private _previousredisFee = _redisFee;
170     uint256 private _previoustaxFee = _taxFee;
171 
172     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap;
173     address payable private _developmentAddress = payable(0x36519C9C2C2c9E512a5879141802b27f140C5cf4);
174     address payable private _marketingAddress = payable(0x36519C9C2C2c9E512a5879141802b27f140C5cf4);
175 
176     IUniswapV2Router02 public uniswapV2Router;
177     address public uniswapV2Pair;
178 
179     bool private tradingOpen = true;
180     bool private inSwap = false;
181     bool private swapEnabled = true;
182 
183     uint256 public _maxTxAmount =  3 * (_tTotal/100);
184     uint256 public _maxWalletSize = 9 * (_tTotal/100);
185     uint256 public _swapTokensAtAmount = 20 *(_tTotal/1000);
186 
187     event MaxTxAmountUpdated(uint256 _maxTxAmount);
188     modifier lockTheSwap {
189         inSwap = true;
190         _; 
191         inSwap = false;
192     }
193 
194     constructor() {
195         _rOwned[_msgSender()] = _rTotal;
196 
197         _isExcludedFromFee[owner()] = true;
198         _isExcludedFromFee[address(this)] = true;
199         _isExcludedFromFee[_developmentAddress] = true;
200         _isExcludedFromFee[_marketingAddress] = true;
201 
202         emit Transfer(address(0), _msgSender(), _tTotal);
203     }
204 
205     function name() public pure returns (string memory) {
206         return _name;
207     }
208 
209     function symbol() public pure returns (string memory) {
210         return _symbol;
211     }
212 
213     function decimals() public pure returns (uint8) {
214         return _decimals;
215     }
216 
217     function totalSupply() public pure override returns (uint256) {
218         return _tTotal;
219     }
220 
221     function balanceOf(address account) public view override returns (uint256) {
222         return tokenFromReflection(_rOwned[account]);
223     }
224 
225     function transfer(address recipient, uint256 amount)
226         public
227         override
228         returns (bool)
229     {
230         _transfer(_msgSender(), recipient, amount);
231         return true;
232     }
233 
234     function allowance(address owner, address spender)
235         public
236         view
237         override
238         returns (uint256)
239     {
240         return _allowances[owner][spender];
241     }
242 
243     function approve(address spender, uint256 amount)
244         public
245         override
246         returns (bool)
247     {
248         _approve(_msgSender(), spender, amount);
249         return true;
250     }
251 
252     function transferFrom(
253         address sender,
254         address recipient,
255         uint256 amount
256     ) public override returns (bool) {
257         _transfer(sender, recipient, amount);
258         _approve(
259             sender,
260             _msgSender(),
261             _allowances[sender][_msgSender()].sub(
262                 amount,
263                 "ERC20: transfer amount exceeds allowance"
264             )
265         );
266         return true;
267     }
268 
269     function tokenFromReflection(uint256 rAmount)
270         private
271         view
272         returns (uint256)
273     {
274         require(
275             rAmount <= _rTotal,
276             "Amount must be less than total reflections"
277         );
278         uint256 currentRate = _getRate();
279         return rAmount.div(currentRate);
280     }
281 
282     function removeAllFee() private {
283         if (_redisFee == 0 && _taxFee == 0) return;
284 
285         _previousredisFee = _redisFee;
286         _previoustaxFee = _taxFee;
287 
288         _redisFee = 0;
289         _taxFee = 0;
290     }
291 
292     function restoreAllFee() private {
293         _redisFee = _previousredisFee;
294         _taxFee = _previoustaxFee;
295     }
296 
297     function _approve(
298         address owner,
299         address spender,
300         uint256 amount
301     ) private {
302         require(owner != address(0), "ERC20: approve from the zero address");
303         require(spender != address(0), "ERC20: approve to the zero address");
304         _allowances[owner][spender] = amount;
305         emit Approval(owner, spender, amount);
306     }
307 
308     function _transfer(
309         address from,
310         address to,
311         uint256 amount
312     ) private {
313         require(from != address(0), "ERC20: transfer from the zero address");
314         require(to != address(0), "ERC20: transfer to the zero address");
315         require(amount > 0, "Transfer amount must be greater than zero");
316 
317         if (from != owner() && to != owner()) {
318 
319             //Trade start check
320             if (!tradingOpen) {
321                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
322             }
323 
324             require(amount <= _maxTxAmount, "TOKEN: Max Transaction Limit");
325             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
326 
327             if(to != uniswapV2Pair) {
328                 require(balanceOf(to) + amount < _maxWalletSize, "TOKEN: Balance exceeds wallet size!");
329             }
330 
331             uint256 contractTokenBalance = balanceOf(address(this));
332             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
333 
334             if(contractTokenBalance >= _maxTxAmount)
335             {
336                 contractTokenBalance = _maxTxAmount;
337             }
338 
339             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
340                 swapTokensForEth(contractTokenBalance);
341                 uint256 contractETHBalance = address(this).balance;
342                 if (contractETHBalance > 0) {
343                     sendETHToFee(address(this).balance);
344                 }
345             }
346         }
347 
348         bool takeFee = true;
349 
350         //Transfer Tokens
351         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
352             takeFee = false;
353         } else {
354 
355             //Set Fee for Buys
356             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
357                 _redisFee = _redisFeeOnBuy;
358                 _taxFee = _taxFeeOnBuy;
359             }
360 
361             //Set Fee for Sells
362             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
363                 _redisFee = _redisFeeOnSell;
364                 _taxFee = _taxFeeOnSell;
365             }
366 
367         }
368 
369         _tokenTransfer(from, to, amount, takeFee);
370     }
371 
372     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
373         address[] memory path = new address[](2);
374         path[0] = address(this);
375         path[1] = uniswapV2Router.WETH();
376         _approve(address(this), address(uniswapV2Router), tokenAmount);
377         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
378             tokenAmount,
379             0,
380             path,
381             address(this),
382             0x0000000000000000000000000000000000000000,
383             block.timestamp
384         );
385     }
386 
387     function sendETHToFee(uint256 amount) private {
388         _marketingAddress.transfer(amount);
389     }
390     //Camelot Dex Router 0xc873fEcbd354f5A56E00E710B90EF4201db2448d
391     function setTrading(bool _tradingOpen) public onlyOwner {
392         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
393         uniswapV2Router = _uniswapV2Router;
394         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
395             .createPair(address(this), _uniswapV2Router.WETH());
396         tradingOpen = _tradingOpen;
397     }
398 
399     function manualswap() external {
400         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
401         uint256 contractBalance = balanceOf(address(this));
402         swapTokensForEth(contractBalance);
403     }
404 
405     function manualsend() external {
406         require(_msgSender() == _developmentAddress || _msgSender() == _marketingAddress);
407         uint256 contractETHBalance = address(this).balance;
408         sendETHToFee(contractETHBalance);
409     }
410 
411     function _tokenTransfer(
412         address sender,
413         address recipient,
414         uint256 amount,
415         bool takeFee
416     ) private {
417         if (!takeFee) removeAllFee();
418         _transferStandard(sender, recipient, amount);
419         if (!takeFee) restoreAllFee();
420     }
421 
422     function _transferStandard(
423         address sender,
424         address recipient,
425         uint256 tAmount
426     ) private {
427         (
428             uint256 rAmount,
429             uint256 rTransferAmount,
430             uint256 rFee,
431             uint256 tTransferAmount,
432             uint256 tFee,
433             uint256 tTeam
434         ) = _getValues(tAmount);
435         _rOwned[sender] = _rOwned[sender].sub(rAmount);
436         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
437         _takeTeam(tTeam);
438         _reflectFee(rFee, tFee);
439         emit Transfer(sender, recipient, tTransferAmount);
440     }
441 
442     function _takeTeam(uint256 tTeam) private {
443         uint256 currentRate = _getRate();
444         uint256 rTeam = tTeam.mul(currentRate);
445         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
446     }
447 
448     function _reflectFee(uint256 rFee, uint256 tFee) private {
449         _rTotal = _rTotal.sub(rFee);
450         _tFeeTotal = _tFeeTotal.add(tFee);
451     }
452 
453     receive() external payable {}
454 
455     function _getValues(uint256 tAmount)
456         private
457         view
458         returns (
459             uint256,
460             uint256,
461             uint256,
462             uint256,
463             uint256,
464             uint256
465         )
466     {
467         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
468             _getTValues(tAmount, _redisFee, _taxFee);
469         uint256 currentRate = _getRate();
470         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
471             _getRValues(tAmount, tFee, tTeam, currentRate);
472         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
473     }
474 
475     function _getTValues(
476         uint256 tAmount,
477         uint256 redisFee,
478         uint256 taxFee
479     )
480         private
481         pure
482         returns (
483             uint256,
484             uint256,
485             uint256
486         )
487     {
488         uint256 tFee = tAmount.mul(redisFee).div(100);
489         uint256 tTeam = tAmount.mul(taxFee).div(100);
490         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
491         return (tTransferAmount, tFee, tTeam);
492     }
493 
494     function _getRValues(
495         uint256 tAmount,
496         uint256 tFee,
497         uint256 tTeam,
498         uint256 currentRate
499     )
500         private
501         pure
502         returns (
503             uint256,
504             uint256,
505             uint256
506         )
507     {
508         uint256 rAmount = tAmount.mul(currentRate);
509         uint256 rFee = tFee.mul(currentRate);
510         uint256 rTeam = tTeam.mul(currentRate);
511         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
512         return (rAmount, rTransferAmount, rFee);
513     }
514 
515     function _getRate() private view returns (uint256) {
516         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
517         return rSupply.div(tSupply);
518     }
519 
520     function _getCurrentSupply() private view returns (uint256, uint256) {
521         uint256 rSupply = _rTotal;
522         uint256 tSupply = _tTotal;
523         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
524         return (rSupply, tSupply);
525     }
526 
527     function setFee(uint256 redisFeeOnBuy, uint256 redisFeeOnSell, uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
528         _redisFeeOnBuy = redisFeeOnBuy;
529         _redisFeeOnSell = redisFeeOnSell;
530         _taxFeeOnBuy = taxFeeOnBuy;
531         _taxFeeOnSell = taxFeeOnSell;
532     }
533 
534     //Set minimum tokens required to swap.
535     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
536         _swapTokensAtAmount = swapTokensAtAmount;
537     }
538 
539     //Set minimum tokens required to swap.
540     function toggleSwap(bool _swapEnabled) public onlyOwner {
541         swapEnabled = _swapEnabled;
542     }
543 
544     //Set maximum transaction
545     function setMaxTxnAmount(uint256 maxTxAmount) public onlyOwner {
546         _maxTxAmount = maxTxAmount;
547     }
548 
549     function setMaxWalletSize(uint256 maxWalletSize) public onlyOwner {
550         _maxWalletSize = maxWalletSize;
551     }
552 
553     function setMaxAll() public onlyOwner {
554         _maxWalletSize = _tTotal;
555         _maxTxAmount = _tTotal;
556     }
557 }