1 //Telegram: https://t.me/gyozatoken
2 //Website:  https://gyoza.wtf
3 //Twitter:  https://twitter.com/Gyoza_erc20
4 
5 // SPDX-License-Identifier: Unlicensed
6 pragma solidity ^0.8.9;
7  
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13  
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16  
17     function balanceOf(address account) external view returns (uint256);
18  
19     function transfer(address recipient, uint256 amount) external returns (bool);
20  
21     function allowance(address owner, address spender) external view returns (uint256);
22  
23     function approve(address spender, uint256 amount) external returns (bool);
24  
25     function transferFrom(
26         address sender,
27         address recipient,
28         uint256 amount
29     ) external returns (bool);
30  
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(
33         address indexed owner,
34         address indexed spender,
35         uint256 value
36     );
37 }
38  
39 contract Ownable is Context {
40     address private _owner;
41     address private _previousOwner;
42     event OwnershipTransferred(
43         address indexed previousOwner,
44         address indexed newOwner
45     );
46  
47     constructor() {
48         address msgSender = _msgSender();
49         _owner = msgSender;
50         emit OwnershipTransferred(address(0), msgSender);
51     }
52  
53     function owner() public view returns (address) {
54         return _owner;
55     }
56  
57     modifier onlyOwner() {
58         require(_owner == _msgSender(), "Ownable: caller is not the owner");
59         _;
60     }
61  
62     function transferOwnership(address newOwner) public virtual onlyOwner {
63         require(newOwner != address(0), "Ownable: new owner is the zero address");
64         emit OwnershipTransferred(_owner, newOwner);
65         _owner = newOwner;
66     }
67  
68 }
69  
70 library SafeMath {
71     function add(uint256 a, uint256 b) internal pure returns (uint256) {
72         uint256 c = a + b;
73         require(c >= a, "SafeMath: addition overflow");
74         return c;
75     }
76  
77     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78         return sub(a, b, "SafeMath: subtraction overflow");
79     }
80  
81     function sub(
82         uint256 a,
83         uint256 b,
84         string memory errorMessage
85     ) internal pure returns (uint256) {
86         require(b <= a, errorMessage);
87         uint256 c = a - b;
88         return c;
89     }
90  
91     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
92         if (a == 0) {
93             return 0;
94         }
95         uint256 c = a * b;
96         require(c / a == b, "SafeMath: multiplication overflow");
97         return c;
98     }
99  
100     function div(uint256 a, uint256 b) internal pure returns (uint256) {
101         return div(a, b, "SafeMath: division by zero");
102     }
103  
104     function div(
105         uint256 a,
106         uint256 b,
107         string memory errorMessage
108     ) internal pure returns (uint256) {
109         require(b > 0, errorMessage);
110         uint256 c = a / b;
111         return c;
112     }
113 }
114  
115 interface IUniswapV2Factory {
116     function createPair(address tokenA, address tokenB)
117         external
118         returns (address pair);
119 }
120  
121 interface IUniswapV2Router02 {
122     function swapExactTokensForETHSupportingFeeOnTransferTokens(
123         uint256 amountIn,
124         uint256 amountOutMin,
125         address[] calldata path,
126         address to,
127         uint256 deadline
128     ) external;
129  
130     function factory() external pure returns (address);
131  
132     function WETH() external pure returns (address);
133  
134     function addLiquidityETH(
135         address token,
136         uint256 amountTokenDesired,
137         uint256 amountTokenMin,
138         uint256 amountETHMin,
139         address to,
140         uint256 deadline
141     )
142         external
143         payable
144         returns (
145             uint256 amountToken,
146             uint256 amountETH,
147             uint256 liquidity
148         );
149 }
150  
151 contract GYOZA is Context, IERC20, Ownable {
152  
153     using SafeMath for uint256;
154  
155     string private constant _name = "GYOZA";
156     string private constant _symbol = "GYOZA";
157     uint8 private constant _decimals = 9;
158  
159     mapping(address => uint256) private _rOwned;
160     mapping(address => uint256) private _tOwned;
161     mapping(address => mapping(address => uint256)) private _allowances;
162     mapping(address => bool) private _isExcludedFromFee;
163     uint256 private constant MAX = ~uint256(0);
164     uint256 private constant _tTotal = 1000000000 * 10**9;
165     uint256 private _rTotal = (MAX - (MAX % _tTotal));
166     uint256 private _tFeeTotal;
167     uint256 private _redisFeeOnBuy = 0;  
168     uint256 public _taxFeeOnBuy = 2;  
169     uint256 private _redisFeeOnSell = 0;  
170     uint256 public _taxFeeOnSell = 5;
171     uint256 private _feeRate = 3;
172     //Original Fee
173     uint256 private _redisFee = _redisFeeOnSell;
174     uint256 private _taxFee = _taxFeeOnSell;
175  
176     uint256 private _previousredisFee = _redisFee;
177     uint256 private _previoustaxFee = _taxFee;
178  
179     mapping(address => bool) public bots; mapping (address => uint256) public _buyMap; 
180     address payable private _deployerAddress = payable(0xf3CaC4B2e41b40d00B6D4787b09587940d825fED); 
181     address payable private _operationsAddress = payable(0x8EB18C7dA05A62b527D15c3c31Eb722A99840887);
182     address payable private _devAddress = payable(0x5198bf4f833FDfe43eD8Fc31Bf265e0684D6351c);
183 
184     IUniswapV2Router02 public uniswapV2Router;
185     address public uniswapV2Pair;
186  
187     bool private tradingOpen;
188     bool private inSwap = false;
189     bool private swapEnabled = true;
190  
191     uint256 public _swapTokensAtAmount = 200000 * 10**9;
192  
193    
194     modifier lockTheSwap {
195         inSwap = true;
196         _;
197         inSwap = false;
198     }
199  
200     constructor() {
201  
202         _rOwned[_msgSender()] = _rTotal;
203  
204         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);//
205         uniswapV2Router = _uniswapV2Router;
206         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
207             .createPair(address(this), _uniswapV2Router.WETH());
208  
209         _isExcludedFromFee[owner()] = true;
210         _isExcludedFromFee[address(this)] = true;
211         _isExcludedFromFee[_deployerAddress] = true;
212         _isExcludedFromFee[_operationsAddress] = true;
213         _isExcludedFromFee[_devAddress] = true;
214  
215         emit Transfer(address(0), _msgSender(), _tTotal);
216     }
217  
218     function name() public pure returns (string memory) {
219         return _name;
220     }
221  
222     function symbol() public pure returns (string memory) {
223         return _symbol;
224     }
225  
226     function decimals() public pure returns (uint8) {
227         return _decimals;
228     }
229  
230     function totalSupply() public pure override returns (uint256) {
231         return _tTotal;
232     }
233  
234     function balanceOf(address account) public view override returns (uint256) {
235         return tokenFromReflection(_rOwned[account]);
236     }
237  
238     function transfer(address recipient, uint256 amount)
239         public
240         override
241         returns (bool)
242     {
243         _transfer(_msgSender(), recipient, amount);
244         return true;
245     }
246  
247     function allowance(address owner, address spender)
248         public
249         view
250         override
251         returns (uint256)
252     {
253         return _allowances[owner][spender];
254     }
255  
256     function approve(address spender, uint256 amount)
257         public
258         override
259         returns (bool)
260     {
261         _approve(_msgSender(), spender, amount);
262         return true;
263     }
264  
265     function transferFrom(
266         address sender,
267         address recipient,
268         uint256 amount
269     ) public override returns (bool) {
270         _transfer(sender, recipient, amount);
271         _approve(
272             sender,
273             _msgSender(),
274             _allowances[sender][_msgSender()].sub(
275                 amount,
276                 "ERC20: transfer amount exceeds allowance"
277             )
278         );
279         return true;
280     }
281  
282     function tokenFromReflection(uint256 rAmount)
283         private
284         view
285         returns (uint256)
286     {
287         require(
288             rAmount <= _rTotal,
289             "Amount must be less than total reflections"
290         );
291         uint256 currentRate = _getRate();
292         return rAmount.div(currentRate);
293     }
294  
295     function removeAllFee() private {
296         if (_redisFee == 0 && _taxFee == 0) return;
297  
298         _previousredisFee = _redisFee;
299         _previoustaxFee = _taxFee;
300  
301         _redisFee = 0;
302         _taxFee = 0;
303     }
304  
305     function restoreAllFee() private {
306         _redisFee = _previousredisFee;
307         _taxFee = _previoustaxFee;
308     }
309  
310     function _approve(
311         address owner,
312         address spender,
313         uint256 amount
314     ) private {
315         require(owner != address(0), "ERC20: approve from the zero address");
316         require(spender != address(0), "ERC20: approve to the zero address");
317         _allowances[owner][spender] = amount;
318         emit Approval(owner, spender, amount);
319     }
320  
321     function _transfer(
322         address from,
323         address to,
324         uint256 amount
325     ) private {
326         require(from != address(0), "ERC20: transfer from the zero address");
327         require(to != address(0), "ERC20: transfer to the zero address");
328         require(amount > 0, "Transfer amount must be greater than zero");
329  
330         if (from != owner() && to != owner()) {
331  
332             //Trade start check
333             if (!tradingOpen) {
334                 require(from == owner(), "TOKEN: This account cannot send tokens until trading is enabled");
335             }
336  
337             
338             require(!bots[from] && !bots[to], "TOKEN: Your account is blacklisted!");
339  
340             uint256 contractTokenBalance = balanceOf(address(this));
341             bool canSwap = contractTokenBalance >= _swapTokensAtAmount;
342  
343             
344  
345             if (canSwap && !inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[from] && !_isExcludedFromFee[to]) {
346                     if(contractTokenBalance > balanceOf(uniswapV2Pair).mul(_feeRate).div(100)) {
347                         contractTokenBalance = balanceOf(uniswapV2Pair).mul(_feeRate).div(100);
348                     }
349                     swapTokensForEth(contractTokenBalance);
350                 
351                 uint256 contractETHBalance = address(this).balance;
352                 if (contractETHBalance > 0) {
353                     sendETHToFee(address(this).balance);
354                 }
355             }
356         }
357  
358         bool takeFee = true;
359  
360         //Transfer Tokens
361         if ((_isExcludedFromFee[from] || _isExcludedFromFee[to]) || (from != uniswapV2Pair && to != uniswapV2Pair)) {
362             takeFee = false;
363         } else {
364  
365             //Set Fee for Buys
366             if(from == uniswapV2Pair && to != address(uniswapV2Router)) {
367                 _redisFee = _redisFeeOnBuy;
368                 _taxFee = _taxFeeOnBuy;
369             }
370  
371             //Set Fee for Sells
372             if (to == uniswapV2Pair && from != address(uniswapV2Router)) {
373                 _redisFee = _redisFeeOnSell;
374                 _taxFee = _taxFeeOnSell;
375             }
376  
377         }
378  
379         _tokenTransfer(from, to, amount, takeFee);
380     }
381  
382     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
383         address[] memory path = new address[](2);
384         path[0] = address(this);
385         path[1] = uniswapV2Router.WETH();
386         _approve(address(this), address(uniswapV2Router), tokenAmount);
387         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
388             tokenAmount,
389             0,
390             path,
391             address(this),
392             block.timestamp
393         );
394     }
395  
396     function sendETHToFee(uint256 amount) private {
397         _deployerAddress.transfer(amount.mul(1).div(10));  
398         _operationsAddress.transfer(amount.mul(6).div(10));
399         _devAddress.transfer(amount.mul(3).div(10));
400     }
401  
402     function setTrading(bool _tradingOpen) public onlyOwner {
403         tradingOpen = _tradingOpen;
404     }
405  
406     function manualswap() external {
407         require(_msgSender() == _operationsAddress || _msgSender() == _deployerAddress);
408         uint256 contractBalance = balanceOf(address(this));
409         swapTokensForEth(contractBalance);
410     }
411  
412     function manualsend() external {
413         require(_msgSender() == _operationsAddress || _msgSender() == _deployerAddress);
414         uint256 contractETHBalance = address(this).balance;
415         sendETHToFee(contractETHBalance);
416     }
417  
418     function blacklist(address[] memory bots_) public onlyOwner {
419         for (uint256 i = 0; i < bots_.length; i++) {
420             bots[bots_[i]] = true;
421         }
422     }
423  
424     function removeBlacklist(address notbot) public onlyOwner {
425         bots[notbot] = false;
426     }
427  
428     function _tokenTransfer(
429         address sender,
430         address recipient,
431         uint256 amount,
432         bool takeFee
433     ) private {
434         if (!takeFee) removeAllFee();
435         _transferStandard(sender, recipient, amount);
436         if (!takeFee) restoreAllFee();
437     }
438  
439     function _transferStandard(
440         address sender,
441         address recipient,
442         uint256 tAmount
443     ) private {
444         (
445             uint256 rAmount,
446             uint256 rTransferAmount,
447             uint256 rFee,
448             uint256 tTransferAmount,
449             uint256 tFee,
450             uint256 tTeam
451         ) = _getValues(tAmount);
452         _rOwned[sender] = _rOwned[sender].sub(rAmount);
453         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
454         _takeTeam(tTeam);
455         _reflectFee(rFee, tFee);
456         emit Transfer(sender, recipient, tTransferAmount);
457     }
458  
459     function _takeTeam(uint256 tTeam) private {
460         uint256 currentRate = _getRate();
461         uint256 rTeam = tTeam.mul(currentRate);
462         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
463     }
464  
465     function _reflectFee(uint256 rFee, uint256 tFee) private {
466         _rTotal = _rTotal.sub(rFee);
467         _tFeeTotal = _tFeeTotal.add(tFee);
468     }
469  
470     receive() external payable {}
471  
472     function _getValues(uint256 tAmount)
473         private
474         view
475         returns (
476             uint256,
477             uint256,
478             uint256,
479             uint256,
480             uint256,
481             uint256
482         )
483     {
484         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) =
485             _getTValues(tAmount, _redisFee, _taxFee);
486         uint256 currentRate = _getRate();
487         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) =
488             _getRValues(tAmount, tFee, tTeam, currentRate);
489         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
490     }
491  
492     function _getTValues(
493         uint256 tAmount,
494         uint256 redisFee,
495         uint256 taxFee
496     )
497         private
498         pure
499         returns (
500             uint256,
501             uint256,
502             uint256
503         )
504     {
505         uint256 tFee = tAmount.mul(redisFee).div(100);
506         uint256 tTeam = tAmount.mul(taxFee).div(100);
507         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
508         return (tTransferAmount, tFee, tTeam);
509     }
510  
511     function _getRValues(
512         uint256 tAmount,
513         uint256 tFee,
514         uint256 tTeam,
515         uint256 currentRate
516     )
517         private
518         pure
519         returns (
520             uint256,
521             uint256,
522             uint256
523         )
524     {
525         uint256 rAmount = tAmount.mul(currentRate);
526         uint256 rFee = tFee.mul(currentRate);
527         uint256 rTeam = tTeam.mul(currentRate);
528         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
529         return (rAmount, rTransferAmount, rFee);
530     }
531  
532     function _getRate() private view returns (uint256) {
533         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
534         return rSupply.div(tSupply);
535     }
536  
537     function _getCurrentSupply() private view returns (uint256, uint256) {
538         uint256 rSupply = _rTotal;
539         uint256 tSupply = _tTotal;
540         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
541         return (rSupply, tSupply);
542     }
543  
544     function setFee(uint256 taxFeeOnBuy, uint256 taxFeeOnSell) public onlyOwner {
545         require(taxFeeOnBuy >= 0 && taxFeeOnBuy <= 20, "Buy tax must be between 0% and 20%");
546         require(taxFeeOnSell >= 0 && taxFeeOnSell <= 20, "Sell tax must be between 0% and 20%");
547         _taxFeeOnBuy = taxFeeOnBuy;
548         _taxFeeOnSell = taxFeeOnSell;
549 
550     }
551  
552     //Set minimum tokens required to swap.
553     function setMinSwapTokensThreshold(uint256 swapTokensAtAmount) public onlyOwner {
554         _swapTokensAtAmount = swapTokensAtAmount;
555     }
556     //Toggle contract sells
557     function toggleSwap(bool _swapEnabled) public onlyOwner {
558         swapEnabled = _swapEnabled;
559     }
560  
561     function manageExcludedFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
562         for(uint256 i = 0; i < accounts.length; i++) {
563             _isExcludedFromFee[accounts[i]] = excluded;
564         }
565     }
566 
567     function setFeeRate(uint256 rate) public onlyOwner {
568          require(rate < 30, "Rate can't exceed 30%");
569         _feeRate = rate;
570         
571     }
572 
573 }