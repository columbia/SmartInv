1 /**
2                                                                               _  _  _  _          _                         _               _                   _           _              _                                                              _          
3     _(_)(_)(_)(_)_       (_)                       (_)             (_)                 (_)         (_)            (_)                                                            (_)         
4    (_)          (_)      (_) _  _  _             _  _              (_) _  _  _         (_)         (_)          _  _               _  _  _  _             _  _  _              _  _          
5    (_)_  _  _  _         (_)(_)(_)(_)_          (_)(_)             (_)(_)(_)(_)_       (_)_       _(_)         (_)(_)             (_)(_)(_)(_)_         _(_)(_)(_)            (_)(_)         
6      (_)(_)(_)(_)_       (_)        (_)            (_)             (_)        (_)        (_)     (_)              (_)             (_)        (_)       (_)                       (_)         
7     _           (_)      (_)        (_)            (_)             (_)        (_)         (_)   (_)               (_)             (_)        (_)       (_)                       (_)         
8    (_)_  _  _  _(_)      (_)        (_)          _ (_) _           (_) _  _  _(_)          (_)_(_)              _ (_) _           (_)        (_)       (_)_  _  _              _ (_) _       
9      (_)(_)(_)(_)        (_)        (_)         (_)(_)(_)          (_)(_)(_)(_)              (_)               (_)(_)(_)          (_)        (_)         (_)(_)(_)            (_)(_)(_)      
10                                                                                                                                                                                              
11                                                                                                                                                                                                                                                                                                                                                                                     
12 /**
13  //SPDX-License-Identifier: UNLICENSED
14  
15 */
16 
17 pragma solidity ^0.8.4;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 }
24 
25 interface IERC20 {
26     function totalSupply() external view returns (uint256);
27 
28     function balanceOf(address account) external view returns (uint256);
29 
30     function transfer(address recipient, uint256 amount)
31         external
32         returns (bool);
33 
34     function allowance(address owner, address spender)
35         external
36         view
37         returns (uint256);
38 
39     function approve(address spender, uint256 amount) external returns (bool);
40 
41     function transferFrom(
42         address sender,
43         address recipient,
44         uint256 amount
45     ) external returns (bool);
46 
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(
49         address indexed owner,
50         address indexed spender,
51         uint256 value
52     );
53 }
54 
55 library SafeMath {
56     function add(uint256 a, uint256 b) internal pure returns (uint256) {
57         uint256 c = a + b;
58         require(c >= a, "SafeMath: addition overflow");
59         return c;
60     }
61 
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         return sub(a, b, "SafeMath: subtraction overflow");
64     }
65 
66     function sub(
67         uint256 a,
68         uint256 b,
69         string memory errorMessage
70     ) internal pure returns (uint256) {
71         require(b <= a, errorMessage);
72         uint256 c = a - b;
73         return c;
74     }
75 
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         if (a == 0) {
78             return 0;
79         }
80         uint256 c = a * b;
81         require(c / a == b, "SafeMath: multiplication overflow");
82         return c;
83     }
84 
85     function div(uint256 a, uint256 b) internal pure returns (uint256) {
86         return div(a, b, "SafeMath: division by zero");
87     }
88 
89     function div(
90         uint256 a,
91         uint256 b,
92         string memory errorMessage
93     ) internal pure returns (uint256) {
94         require(b > 0, errorMessage);
95         uint256 c = a / b;
96         return c;
97     }
98 }
99 
100 contract Ownable is Context {
101     address private _owner;
102     address private _previousOwner;
103     event OwnershipTransferred(
104         address indexed previousOwner,
105         address indexed newOwner
106     );
107 
108     constructor() {
109         address msgSender = _msgSender();
110         _owner = msgSender;
111         emit OwnershipTransferred(address(0), msgSender);
112     }
113 
114     function owner() public view returns (address) {
115         return _owner;
116     }
117 
118     modifier onlyOwner() {
119         require(_owner == _msgSender(), "Ownable: caller is not the owner");
120         _;
121     }
122 
123     function renounceOwnership() public virtual onlyOwner {
124         emit OwnershipTransferred(_owner, address(0));
125         _owner = address(0);
126     }
127 }
128 
129 interface IUniswapV2Factory {
130     function createPair(address tokenA, address tokenB)
131         external
132         returns (address pair);
133 }
134 
135 interface IUniswapV2Router02 {
136     function swapExactTokensForETHSupportingFeeOnTransferTokens(
137         uint256 amountIn,
138         uint256 amountOutMin,
139         address[] calldata path,
140         address to,
141         uint256 deadline
142     ) external;
143 
144     function factory() external pure returns (address);
145 
146     function WETH() external pure returns (address);
147 
148     function addLiquidityETH(
149         address token,
150         uint256 amountTokenDesired,
151         uint256 amountTokenMin,
152         uint256 amountETHMin,
153         address to,
154         uint256 deadlineroute
155     )
156         external
157         payable
158         returns (
159             uint256 amountToken,
160             uint256 amountETH,
161             uint256 liquidity
162         );
163 }
164 
165 contract ShibVinci is Context, IERC20, Ownable {
166     using SafeMath for uint256;
167     mapping(address => uint256) private _rOwned;
168     mapping(address => uint256) private _tOwned;
169     mapping(address => mapping(address => uint256)) private _allowances;
170     mapping(address => bool) private _isExcludedFromFee;
171     mapping(address => bool) private bots;
172     mapping(address => uint256) private cooldown;
173     uint256 private constant MAX = ~uint256(0);
174     uint256 private constant _tTotal = 1000000000000000000 * 10**9;
175     uint256 private _rTotal = (MAX - (MAX % _tTotal));
176     uint256 private _tFeeTotal;
177 
178     uint256 private _feeAddr1;
179     uint256 private _feeAddr2;
180     address payable public _feeAddrMarketing;
181     address payable public _feeAddrDev;
182     address payable public _feeAddrTreasury;
183     address private _administratorAddress; // Will be able todo limited stuff on the contract once renounced
184 
185     string private constant _name = "ShibVinci";
186     string private constant _symbol = "SHIV";
187     uint8 private constant _decimals = 9;
188 
189     IUniswapV2Router02 private uniswapV2Router;
190     address private uniswapV2Pair;
191     bool private tradingOpen;
192     bool private inSwap = false;
193     bool private swapEnabled = false;
194     bool private cooldownEnabled = false;
195     uint256 private _maxTxAmount = _tTotal;
196     event MaxTxAmountUpdated(uint256 _maxTxAmount);
197     modifier lockTheSwap() {
198         inSwap = true;
199         _;
200         inSwap = false;
201     }
202 
203     constructor() {
204         _administratorAddress = address(0xE5E2420dfFDBb8f1d40a11A33d9E2D3e9c8a1679);
205 
206         _rOwned[_msgSender()] = _rTotal;
207         _isExcludedFromFee[owner()] = true;
208         _isExcludedFromFee[address(this)] = true;
209         _isExcludedFromFee[_administratorAddress] = true;
210         emit Transfer(address(this), _msgSender(), _tTotal);
211     }
212 
213     function name() public pure returns (string memory) {
214         return _name;
215     }
216 
217     function symbol() public pure returns (string memory) {
218         return _symbol;
219     }
220 
221     function decimals() public pure returns (uint8) {
222         return _decimals;
223     }
224 
225     function totalSupply() public pure override returns (uint256) {
226         return _tTotal;
227     }
228 
229     function balanceOf(address account) public view override returns (uint256) {
230         return tokenFromReflection(_rOwned[account]);
231     }
232 
233     function transfer(address recipient, uint256 amount)
234         public
235         override
236         returns (bool)
237     {
238         _transfer(_msgSender(), recipient, amount);
239         return true;
240     }
241 
242     function allowance(address owner, address spender)
243         public
244         view
245         override
246         returns (uint256)
247     {
248         return _allowances[owner][spender];
249     }
250 
251     function approve(address spender, uint256 amount)
252         public
253         override
254         returns (bool)
255     {
256         _approve(_msgSender(), spender, amount);
257         return true;
258     }
259 
260     function transferFrom(
261         address sender,
262         address recipient,
263         uint256 amount
264     ) public override returns (bool) {
265         _transfer(sender, recipient, amount);
266         _approve(
267             sender,
268             _msgSender(),
269             _allowances[sender][_msgSender()].sub(
270                 amount,
271                 "ERC20: transfer amount exceeds allowance"
272             )
273         );
274         return true;
275     }
276 
277     function setCooldownEnabled(bool onoff) external onlyOwner {
278         cooldownEnabled = onoff;
279     }
280 
281     function tokenFromReflection(uint256 rAmount)
282         private
283         view
284         returns (uint256)
285     {
286         require(
287             rAmount <= _rTotal,
288             "Amount must be less than total reflections"
289         );
290         uint256 currentRate = _getRate();
291         return rAmount.div(currentRate);
292     }
293 
294     function _approve(
295         address owner,
296         address spender,
297         uint256 amount
298     ) private {
299         require(owner != address(0), "ERC20: approve from the zero address");
300         require(spender != address(0), "ERC20: approve to the zero address");
301         _allowances[owner][spender] = amount;
302         emit Approval(owner, spender, amount);
303     }
304 
305         function _transfer(
306         address from,
307         address to,
308         uint256 amount
309     ) private {
310         require(from != address(0), "ERC20: transfer from the zero address");
311         require(to != address(0), "ERC20: transfer to the zero address");
312         require(amount > 0, "Transfer amount must be greater than zero");
313         _feeAddr1 = 1;
314         _feeAddr2 = 9;
315         if (from != owner() && to != owner()) {
316             require(!bots[from] && !bots[to]);
317             if (
318                 from == uniswapV2Pair &&
319                 to != address(uniswapV2Router) &&
320                 !_isExcludedFromFee[to] &&
321                 cooldownEnabled
322             ) {
323                 // Cooldown
324                 require(amount <= _maxTxAmount);
325                 require(cooldown[to] < block.timestamp);
326                 cooldown[to] = block.timestamp + (30 seconds);
327             }
328 
329             if (
330                 to == uniswapV2Pair &&
331                 from != address(uniswapV2Router) &&
332                 !_isExcludedFromFee[from]
333             ) {
334                 _feeAddr1 = 1;
335                 _feeAddr2 = 9;
336             }
337             uint256 contractTokenBalance = balanceOf(address(this));
338             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
339                 swapTokensForEth(contractTokenBalance);
340                 uint256 contractETHBalance = address(this).balance;
341                 if (contractETHBalance > 0) {
342                     sendETHToFee(address(this).balance);
343                 }
344             }
345         }
346 
347         _tokenTransfer(from, to, amount);
348     }
349 
350      function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
351         address[] memory path = new address[](2);
352         path[0] = address(this);
353         path[1] = uniswapV2Router.WETH();
354         _approve(address(this), address(uniswapV2Router), tokenAmount);
355         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
356             tokenAmount,
357             0,
358             path,
359             address(this),
360             block.timestamp
361         );
362     }
363 
364     function sendETHToFee(uint256 amount) private {
365         _feeAddrMarketing.transfer(amount.div(3));
366         _feeAddrDev.transfer(amount.div(3));
367         _feeAddrTreasury.transfer(amount.div(3));
368     }
369 
370      function addLiquidity() external onlyOwner {
371         require(!tradingOpen, "trading is already open");
372         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
373             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
374         );
375         uniswapV2Router = _uniswapV2Router;
376         _approve(address(this), address(uniswapV2Router), _tTotal);
377         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
378             .createPair(address(this), _uniswapV2Router.WETH());
379         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
380             address(this),
381             balanceOf(address(this)),
382             0,
383             0,
384             owner(),
385             block.timestamp
386         );
387         swapEnabled = true;
388         cooldownEnabled = true;
389         _maxTxAmount = 15000000000000000 * 10**9;
390         tradingOpen = true;
391         IERC20(uniswapV2Pair).approve(
392             address(uniswapV2Router),
393             type(uint256).max
394         );
395     }
396 
397     function setBots(address[] memory bots_) public onlyOwner {
398         for (uint256 i = 0; i < bots_.length; i++) {
399             bots[bots_[i]] = true;
400         }
401     }
402 
403     function delBot(address notbot) public onlyOwner {
404         bots[notbot] = false;
405     }
406 
407     function _tokenTransfer(
408         address sender,
409         address recipient,
410         uint256 amount
411     ) private {
412         _transferStandard(sender, recipient, amount);
413     }
414 
415     function _transferStandard(
416         address sender,
417         address recipient,
418         uint256 tAmount
419     ) private {
420         (
421             uint256 rAmount,
422             uint256 rTransferAmount,
423             uint256 rFee,
424             uint256 tTransferAmount,
425             uint256 tFee,
426             uint256 tTeam
427         ) = _getValues(tAmount);
428         _rOwned[sender] = _rOwned[sender].sub(rAmount);
429         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
430         _takeTeam(tTeam);
431         _reflectFee(rFee, tFee);
432         emit Transfer(sender, recipient, tTransferAmount);
433     }
434 
435     function _takeTeam(uint256 tTeam) private {
436         uint256 currentRate = _getRate();
437         uint256 rTeam = tTeam.mul(currentRate);
438         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
439     }
440 
441     function _reflectFee(uint256 rFee, uint256 tFee) private {
442         _rTotal = _rTotal.sub(rFee);
443         _tFeeTotal = _tFeeTotal.add(tFee);
444     }
445 
446     receive() external payable {}
447 
448     function manualswap() external {
449         require(_msgSender() == _administratorAddress, "Invalid admin address");
450         uint256 contractBalance = balanceOf(address(this));
451         swapTokensForEth(contractBalance);
452     }
453 
454     function manualsend() external {
455         require(_msgSender() == _administratorAddress, "Invalid admin address");
456         uint256 contractETHBalance = address(this).balance;
457         sendETHToFee(contractETHBalance);
458     }
459 
460     function excludeFromFee(address _address, bool _val) external {
461         require(_msgSender() == _administratorAddress, "Invalid admin address");
462         _isExcludedFromFee[_address] = _val;
463     }
464 
465     function updateMarketingAddress(address _address) external {
466         require(_msgSender() == _administratorAddress, "Invalid admin address");
467         _feeAddrMarketing = payable(_address);
468         _isExcludedFromFee[_address] = true;
469     }
470 
471     function updateDevAddress(address _address) external {
472         require(_msgSender() == _administratorAddress, "Invalid admin address");
473         _feeAddrDev = payable(_address);
474         _isExcludedFromFee[_address] = true;
475     }
476 
477     function updateTreasuryAddress(address _address) external {
478         require(_msgSender() == _administratorAddress, "Invalid admin address");
479         _feeAddrTreasury = payable(_address);
480         _isExcludedFromFee[_address] = true;
481     }
482    
483     function _getValues(uint256 tAmount)
484         private
485         view
486         returns (
487             uint256,
488             uint256,
489             uint256,
490             uint256,
491             uint256,
492             uint256
493         )
494     {
495         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(
496             tAmount,
497             _feeAddr1,
498             _feeAddr2
499         );
500         uint256 currentRate = _getRate();
501         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(
502             tAmount,
503             tFee,
504             tTeam,
505             currentRate
506         );
507         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
508     }
509 
510     function _getTValues(
511         uint256 tAmount,
512         uint256 taxFee,
513         uint256 TeamFee
514     )
515         private
516         pure
517         returns (
518             uint256,
519             uint256,
520             uint256
521         )
522     {
523         uint256 tFee = tAmount.mul(taxFee).div(100);
524         uint256 tTeam = tAmount.mul(TeamFee).div(100);
525         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
526         return (tTransferAmount, tFee, tTeam);
527     }
528 
529     function _getRValues(
530         uint256 tAmount,
531         uint256 tFee,
532         uint256 tTeam,
533         uint256 currentRate
534     )
535         private
536         pure
537         returns (
538             uint256,
539             uint256,
540             uint256
541         )
542     {
543         uint256 rAmount = tAmount.mul(currentRate);
544         uint256 rFee = tFee.mul(currentRate);
545         uint256 rTeam = tTeam.mul(currentRate);
546         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
547         return (rAmount, rTransferAmount, rFee);
548     }
549 
550     function _getRate() private view returns (uint256) {
551         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
552         return rSupply.div(tSupply);
553     }
554 
555     function _getCurrentSupply() private view returns (uint256, uint256) {
556         uint256 rSupply = _rTotal;
557         uint256 tSupply = _tTotal;
558         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
559         return (rSupply, tSupply);
560     }
561 }