1 /**
2  *Submitted for verification at Etherscan.io on 2021-05-27
3 */
4 
5 /*
6 ICE DIAMOND
7 http://t.me/imond_official
8 */
9 
10 // SPDX-License-Identifier: Unlicensed
11 pragma solidity ^0.6.12;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address payable) {
15         return msg.sender;
16     }
17 
18     function _msgData() internal view virtual returns (bytes memory) {
19         this;
20         return msg.data;
21     }
22 }
23 
24 interface IERC20 {
25     function totalSupply() external view returns (uint256);
26     function balanceOf(address account) external view returns (uint256);
27     function transfer(address recipient, uint256 amount) external returns (bool);
28     function allowance(address owner, address spender) external view returns (uint256);
29     function approve(address spender, uint256 amount) external returns (bool);
30     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
31     event Transfer(address indexed from, address indexed to, uint256 value);
32     event Approval(address indexed owner, address indexed spender, uint256 value);
33 }
34 
35 library SafeMath {
36     function add(uint256 a, uint256 b) internal pure returns (uint256) {
37         uint256 c = a + b;
38         require(c >= a, "SafeMath: addition overflow");
39         return c;
40     }
41 
42     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
43         return sub(a, b, "SafeMath: subtraction overflow");
44     }
45 
46     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b <= a, errorMessage);
48         uint256 c = a - b;
49         return c;
50     }
51 
52     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53         if (a == 0) {
54             return 0;
55         }
56         uint256 c = a * b;
57         require(c / a == b, "SafeMath: multiplication overflow");
58         return c;
59     }
60 
61     function div(uint256 a, uint256 b) internal pure returns (uint256) {
62         return div(a, b, "SafeMath: division by zero");
63     }
64 
65     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b > 0, errorMessage);
67         uint256 c = a / b;
68         return c;
69     }
70 
71     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
72         return mod(a, b, "SafeMath: modulo by zero");
73     }
74 
75     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
76         require(b != 0, errorMessage);
77         return a % b;
78     }
79 }
80 
81 library Address {
82     function isContract(address account) internal view returns (bool) {
83         bytes32 codehash;
84         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
85         assembly { codehash := extcodehash(account) }
86         return (codehash != accountHash && codehash != 0x0);
87     }
88 
89     function sendValue(address payable recipient, uint256 amount) internal {
90         require(address(this).balance >= amount, "Address: insufficient balance");
91         (bool success, ) = recipient.call{ value: amount }("");
92         require(success, "Address: unable to send value, recipient may have reverted");
93     }
94 
95     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
96         return functionCall(target, data, "Address: low-level call failed");
97     }
98 
99     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
100         return _functionCallWithValue(target, data, 0, errorMessage);
101     }
102 
103     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
104         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
105     }
106 
107     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
108         require(address(this).balance >= value, "Address: insufficient balance for call");
109         return _functionCallWithValue(target, data, value, errorMessage);
110     }
111 
112     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
113         require(isContract(target), "Address: call to non-contract");
114         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
115         if (success) {
116             return returndata;
117         } else {
118             if (returndata.length > 0) {
119                 assembly {
120                     let returndata_size := mload(returndata)
121                     revert(add(32, returndata), returndata_size)
122                 }
123             } else {
124                 revert(errorMessage);
125             }
126         }
127     }
128 }
129 
130 contract Ownable is Context {
131     address private _owner;
132     address private _previousOwner;
133     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
134 
135     constructor () internal {
136         address msgSender = _msgSender();
137         _owner = msgSender;
138         emit OwnershipTransferred(address(0), msgSender);
139     }
140 
141     function owner() public view returns (address) {
142         return _owner;
143     }
144 
145     modifier onlyOwner() {
146         require(_owner == _msgSender(), "Ownable: caller is not the owner");
147         _;
148     }
149 
150     function renounceOwnership() public virtual onlyOwner {
151         emit OwnershipTransferred(_owner, address(0));
152         _owner = address(0);
153     }
154 
155 }  
156 
157 interface IUniswapV2Factory {
158     function createPair(address tokenA, address tokenB) external returns (address pair);
159 }
160 
161 interface IUniswapV2Router02 {
162     function swapExactTokensForETHSupportingFeeOnTransferTokens(
163         uint amountIn,
164         uint amountOutMin,
165         address[] calldata path,
166         address to,
167         uint deadline
168     ) external;
169     function factory() external pure returns (address);
170     function WETH() external pure returns (address);
171     function addLiquidityETH(
172         address token,
173         uint amountTokenDesired,
174         uint amountTokenMin,
175         uint amountETHMin,
176         address to,
177         uint deadline
178     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
179 }
180 
181 contract IMOND is Context, IERC20, Ownable {
182     using SafeMath for uint256;
183     using Address for address;
184     mapping (address => uint256) private _rOwned;
185     mapping (address => uint256) private _tOwned;
186     mapping (address => mapping (address => uint256)) private _allowances;
187     mapping (address => bool) private _isExcludedFromFee;
188     mapping (address => bool) private _isExcluded;
189     mapping (address => bool) private _isSmallFee;
190     mapping (address => bool) private bots;
191     mapping (address => uint) private cooldown;
192     address[] private _excluded;
193     uint256 private constant MAX = ~uint256(0);
194     uint256 private constant _tTotal = 1000000000000 * 10**9;
195     uint256 private _rTotal = (MAX - (MAX % _tTotal));
196     uint256 private _tFeeTotal;
197     string private constant _name = "Ice Diamond";
198     string private constant _symbol = 'IMOND \xF0\x9F\x92\xA0';
199     uint8 private constant _decimals = 9;
200     uint256 private _taxFee = 2;
201     uint256 private _teamFee = 12;
202     uint256 private _previousTaxFee = _taxFee;
203     uint256 private _previousteamFee = _teamFee;
204     address payable private _FeeAddress;
205     address payable private _marketingWalletAddress;
206     address payable private _buybackWalletAddress;
207     IUniswapV2Router02 private uniswapV2Router;
208     address private uniswapV2Pair;
209     bool private tradingOpen;
210     bool private inSwap = false;
211     bool private swapEnabled = false;
212     bool private cooldownEnabled = false;
213     uint256 private _maxTxAmount = _tTotal;
214 
215     address _feeChanger;
216 
217     event MaxTxAmountUpdated(uint _maxTxAmount);
218     event FeeChangershipRenounced();
219 
220     modifier lockTheSwap {
221         inSwap = true;
222         _;
223         inSwap = false;
224     }
225     modifier onlyFeeChanger() {
226         require(_msgSender() == _feeChanger, "Caller must be fee changer");
227         _;
228     }
229 
230     constructor (address payable FeeAddress, address payable marketingWalletAddress, address payable buybackWalletAddress) public {
231         _FeeAddress = FeeAddress;
232         _marketingWalletAddress = marketingWalletAddress;
233         _buybackWalletAddress = buybackWalletAddress;
234         _feeChanger = _msgSender();
235 
236         _rOwned[_msgSender()] = _rTotal;
237         _isExcludedFromFee[owner()] = true;
238         _isExcludedFromFee[address(this)] = true;
239         _isExcludedFromFee[FeeAddress] = true;
240         _isExcludedFromFee[marketingWalletAddress] = true;
241         _isExcludedFromFee[buybackWalletAddress] = true;
242         emit Transfer(address(0), _msgSender(), _tTotal);
243     }
244 
245     function name() public pure returns (string memory) {
246         return _name;
247     }
248 
249     function symbol() public pure returns (string memory) {
250         return _symbol;
251     }
252 
253     function decimals() public pure returns (uint8) {
254         return _decimals;
255     }
256 
257     function totalSupply() public view override returns (uint256) {
258         return _tTotal;
259     }
260 
261     function balanceOf(address account) public view override returns (uint256) {
262         if (_isExcluded[account]) return _tOwned[account];
263         return tokenFromReflection(_rOwned[account]);
264     }
265 
266     function transfer(address recipient, uint256 amount) public override returns (bool) {
267         _transfer(_msgSender(), recipient, amount);
268         return true;
269     }
270 
271     function allowance(address owner, address spender) public view override returns (uint256) {
272         return _allowances[owner][spender];
273     }
274 
275     function approve(address spender, uint256 amount) public override returns (bool) {
276         _approve(_msgSender(), spender, amount);
277         return true;
278     }
279 
280     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
281         _transfer(sender, recipient, amount);
282         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
283         return true;
284     }
285 
286     function addSmallFeeAddress(address _beneficiery) external onlyFeeChanger {
287         _isSmallFee[_beneficiery] = true;
288     }
289 
290     function removeFromSmallFeeAddress(address _beneficiery) external onlyFeeChanger {
291         _isSmallFee[_beneficiery] = false;
292     }
293 
294     function excludeFromFee(address _beneficiery) external onlyFeeChanger {
295         _isExcludedFromFee[_beneficiery] = true;
296     }
297 
298     function includeToFee(address _beneficiery) external onlyFeeChanger {
299         _isExcludedFromFee[_beneficiery] = false;
300     }
301 
302     function renounceFeeChangerShip() external onlyFeeChanger {
303         emit FeeChangershipRenounced();
304         _feeChanger = address(0);
305     }
306 
307     function setCooldownEnabled(bool onoff) external onlyOwner() {
308         cooldownEnabled = onoff;
309     }
310 
311     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
312         require(rAmount <= _rTotal, "Amount must be less than total reflections");
313         uint256 currentRate =  _getRate();
314         return rAmount.div(currentRate);
315     }
316 
317     function removeAllFee() private {
318         if(_taxFee == 0 && _teamFee == 0) return;
319         _previousTaxFee = _taxFee;
320         _previousteamFee = _teamFee;
321         _taxFee = 0;
322         _teamFee = 0;
323     }
324 
325     function reduceFee() private {
326         if(_taxFee == 0 && _teamFee == 6) return;
327         _previousTaxFee = _taxFee;
328         _previousteamFee = _teamFee;
329         _taxFee = 0;
330         _teamFee = 6;
331     }
332     
333     function restoreAllFee() private {
334         _taxFee = _previousTaxFee;
335         _teamFee = _previousteamFee;
336     }
337 
338     function _approve(address owner, address spender, uint256 amount) private {
339         require(owner != address(0), "ERC20: approve from the zero address");
340         require(spender != address(0), "ERC20: approve to the zero address");
341         _allowances[owner][spender] = amount;
342         emit Approval(owner, spender, amount);
343     }
344 
345     function _transfer(address from, address to, uint256 amount) private {
346         require(from != address(0), "ERC20: transfer from the zero address");
347         require(to != address(0), "ERC20: transfer to the zero address");
348         require(amount > 0, "Transfer amount must be greater than zero");
349         
350         if (from != owner() && to != owner()) {
351             if (cooldownEnabled) {
352                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
353                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Uniswap only");
354                 }
355             }
356             require(amount <= _maxTxAmount);
357             require(!bots[from] && !bots[to]);
358             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
359                 require(cooldown[to] < block.timestamp);
360                 cooldown[to] = block.timestamp + (1 minutes);
361             }
362             uint256 contractTokenBalance = balanceOf(address(this));
363             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
364                 swapTokensForEth(contractTokenBalance);
365                 uint256 contractETHBalance = address(this).balance;
366                 if(contractETHBalance > 0) {
367                     sendETHToFee(address(this).balance);
368                 }
369             }
370         }
371         bool takeFee = true;
372         bool smallFee = false;
373 
374         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || _isSmallFee[to]){
375             takeFee = false;
376         }
377 
378         if(_isSmallFee[from]) {
379             smallFee = true;
380         }
381 		
382         _tokenTransfer(from,to,amount,takeFee,smallFee);
383     }
384 
385     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
386         if (tokenAmount == 0) {
387             return;
388         }
389         
390         address[] memory path = new address[](2);
391         path[0] = address(this);
392         path[1] = uniswapV2Router.WETH();
393         _approve(address(this), address(uniswapV2Router), tokenAmount);
394         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
395             tokenAmount,
396             0,
397             path,
398             address(this),
399             block.timestamp
400         );
401     }
402         
403     function sendETHToFee(uint256 amount) private {
404         _FeeAddress.transfer(amount.div(3));
405         _marketingWalletAddress.transfer(amount.div(3));
406         _buybackWalletAddress.transfer(amount.div(3));
407     }
408     
409     function manualswap() external {
410         require(_msgSender() == _FeeAddress);
411         uint256 contractBalance = balanceOf(address(this));
412         swapTokensForEth(contractBalance);
413     }
414     
415     function manualsend() external {
416         require(_msgSender() == _FeeAddress);
417         uint256 contractETHBalance = address(this).balance;
418         sendETHToFee(contractETHBalance);
419     }
420         
421     function openTrading() external onlyOwner() {
422         require(!tradingOpen,"trading is already open");
423         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
424         uniswapV2Router = _uniswapV2Router;
425         _approve(address(this), address(uniswapV2Router), _tTotal);
426         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
427         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
428         swapEnabled = true;
429         cooldownEnabled = true;
430         _maxTxAmount = 2500000000 * 10**9;
431         tradingOpen = true;
432         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
433     }
434     
435     function setBots(address[] memory bots_) public onlyOwner {
436         for (uint i = 0; i < bots_.length; i++) {
437             bots[bots_[i]] = true;
438         }
439     }
440     
441     function delBot(address notbot) public onlyOwner {
442         bots[notbot] = false;
443     }
444         
445     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee, bool smallFee) private {
446         if(!takeFee)
447             removeAllFee();
448         else if (smallFee)
449             reduceFee();
450         if (_isExcluded[sender] && !_isExcluded[recipient]) {
451             _transferFromExcluded(sender, recipient, amount);
452         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
453             _transferToExcluded(sender, recipient, amount);
454         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
455             _transferBothExcluded(sender, recipient, amount);
456         } else {
457             _transferStandard(sender, recipient, amount);
458         }
459         if(!takeFee || !smallFee)
460             restoreAllFee();
461     }
462 
463     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
464         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
465         _rOwned[sender] = _rOwned[sender].sub(rAmount);
466         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
467         _takeTeam(tTeam); 
468         _reflectFee(rFee, tFee);
469         emit Transfer(sender, recipient, tTransferAmount);
470     }
471 
472     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
473         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
474         _rOwned[sender] = _rOwned[sender].sub(rAmount);
475         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
476         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
477         _takeTeam(tTeam);           
478         _reflectFee(rFee, tFee);
479         emit Transfer(sender, recipient, tTransferAmount);
480     }
481 
482     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
483         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
484         _tOwned[sender] = _tOwned[sender].sub(tAmount);
485         _rOwned[sender] = _rOwned[sender].sub(rAmount);
486         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
487         _takeTeam(tTeam);   
488         _reflectFee(rFee, tFee);
489         emit Transfer(sender, recipient, tTransferAmount);
490     }
491 
492     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
493         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
494         _tOwned[sender] = _tOwned[sender].sub(tAmount);
495         _rOwned[sender] = _rOwned[sender].sub(rAmount);
496         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
497         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
498         _takeTeam(tTeam);         
499         _reflectFee(rFee, tFee);
500         emit Transfer(sender, recipient, tTransferAmount);
501     }
502 
503     function _takeTeam(uint256 tTeam) private {
504         uint256 currentRate =  _getRate();
505         uint256 rTeam = tTeam.mul(currentRate);
506         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
507         if(_isExcluded[address(this)])
508             _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
509     }
510 
511     function _reflectFee(uint256 rFee, uint256 tFee) private {
512         _rTotal = _rTotal.sub(rFee);
513         _tFeeTotal = _tFeeTotal.add(tFee);
514     }
515 
516     receive() external payable {}
517 
518     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
519         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
520         uint256 currentRate =  _getRate();
521         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
522         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
523     }
524 
525     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
526         uint256 tFee = tAmount.mul(taxFee).div(100);
527         uint256 tTeam = tAmount.mul(TeamFee).div(100);
528         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
529         return (tTransferAmount, tFee, tTeam);
530     }
531 
532     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
533         uint256 rAmount = tAmount.mul(currentRate);
534         uint256 rFee = tFee.mul(currentRate);
535         uint256 rTeam = tTeam.mul(currentRate);
536         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
537         return (rAmount, rTransferAmount, rFee);
538     }
539 
540     function _getRate() private view returns(uint256) {
541         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
542         return rSupply.div(tSupply);
543     }
544 
545     function _getCurrentSupply() private view returns(uint256, uint256) {
546         uint256 rSupply = _rTotal;
547         uint256 tSupply = _tTotal;      
548         for (uint256 i = 0; i < _excluded.length; i++) {
549             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
550             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
551             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
552         }
553         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
554         return (rSupply, tSupply);
555     }
556         
557     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
558         require(maxTxPercent > 0, "Amount must be greater than 0");
559         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
560         emit MaxTxAmountUpdated(_maxTxAmount);
561     }
562 }