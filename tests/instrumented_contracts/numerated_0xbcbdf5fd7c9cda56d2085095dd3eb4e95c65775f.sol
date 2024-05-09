1 /**
2  *Submitted for verification at Etherscan.io on 2021-05-27
3 */
4 
5 /*
6 Earth To Moon
7 https://t.me/earthtomoon_official
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
181 contract ETM is Context, IERC20, Ownable {
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
197     string private constant _name = "Earth To Moon";
198     string private constant _symbol = 'ETM';
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
215     event MaxTxAmountUpdated(uint _maxTxAmount);
216 
217     modifier lockTheSwap {
218         inSwap = true;
219         _;
220         inSwap = false;
221     }
222     
223     constructor (address payable FeeAddress, address payable marketingWalletAddress, address payable buybackWalletAddress) public {
224         _FeeAddress = FeeAddress;
225         _marketingWalletAddress = marketingWalletAddress;
226         _buybackWalletAddress = buybackWalletAddress;
227 
228         _rOwned[_msgSender()] = _rTotal;
229         _isExcludedFromFee[owner()] = true;
230         _isExcludedFromFee[address(this)] = true;
231         _isExcludedFromFee[FeeAddress] = true;
232         _isExcludedFromFee[marketingWalletAddress] = true;
233         _isExcludedFromFee[buybackWalletAddress] = true;
234         emit Transfer(address(0), _msgSender(), _tTotal);
235     }
236 
237     function name() public pure returns (string memory) {
238         return _name;
239     }
240 
241     function symbol() public pure returns (string memory) {
242         return _symbol;
243     }
244 
245     function decimals() public pure returns (uint8) {
246         return _decimals;
247     }
248 
249     function totalSupply() public view override returns (uint256) {
250         return _tTotal;
251     }
252 
253     function balanceOf(address account) public view override returns (uint256) {
254         if (_isExcluded[account]) return _tOwned[account];
255         return tokenFromReflection(_rOwned[account]);
256     }
257 
258     function transfer(address recipient, uint256 amount) public override returns (bool) {
259         _transfer(_msgSender(), recipient, amount);
260         return true;
261     }
262 
263     function allowance(address owner, address spender) public view override returns (uint256) {
264         return _allowances[owner][spender];
265     }
266 
267     function approve(address spender, uint256 amount) public override returns (bool) {
268         _approve(_msgSender(), spender, amount);
269         return true;
270     }
271 
272     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
273         _transfer(sender, recipient, amount);
274         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
275         return true;
276     }
277 
278     function setCooldownEnabled(bool onoff) external onlyOwner() {
279         cooldownEnabled = onoff;
280     }
281 
282     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
283         require(rAmount <= _rTotal, "Amount must be less than total reflections");
284         uint256 currentRate =  _getRate();
285         return rAmount.div(currentRate);
286     }
287 
288     function removeAllFee() private {
289         if(_taxFee == 0 && _teamFee == 0) return;
290         _previousTaxFee = _taxFee;
291         _previousteamFee = _teamFee;
292         _taxFee = 0;
293         _teamFee = 0;
294     }
295 
296     function reduceFee() private {
297         if(_taxFee == 0 && _teamFee == 6) return;
298         _previousTaxFee = _taxFee;
299         _previousteamFee = _teamFee;
300         _taxFee = 0;
301         _teamFee = 6;
302     }
303     
304     function restoreAllFee() private {
305         _taxFee = _previousTaxFee;
306         _teamFee = _previousteamFee;
307     }
308 
309     function _approve(address owner, address spender, uint256 amount) private {
310         require(owner != address(0), "ERC20: approve from the zero address");
311         require(spender != address(0), "ERC20: approve to the zero address");
312         _allowances[owner][spender] = amount;
313         emit Approval(owner, spender, amount);
314     }
315 
316     function _transfer(address from, address to, uint256 amount) private {
317         require(from != address(0), "ERC20: transfer from the zero address");
318         require(to != address(0), "ERC20: transfer to the zero address");
319         require(amount > 0, "Transfer amount must be greater than zero");
320         
321         if (from != owner() && to != owner()) {
322             if (cooldownEnabled) {
323                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
324                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Uniswap only");
325                 }
326             }
327             require(amount <= _maxTxAmount);
328             require(!bots[from] && !bots[to]);
329             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
330                 require(cooldown[to] < block.timestamp);
331                 cooldown[to] = block.timestamp + (30 seconds);
332             }
333             uint256 contractTokenBalance = balanceOf(address(this));
334             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
335                 swapTokensForEth(contractTokenBalance);
336                 uint256 contractETHBalance = address(this).balance;
337                 if(contractETHBalance > 0) {
338                     sendETHToFee(address(this).balance);
339                 }
340             }
341         }
342         bool takeFee = true;
343         bool smallFee = false;
344 
345         if(_isExcludedFromFee[from] || _isExcludedFromFee[to] || _isSmallFee[to]){
346             takeFee = false;
347         }
348 
349         if(_isSmallFee[from]) {
350             smallFee = true;
351         }
352 		
353         _tokenTransfer(from,to,amount,takeFee,smallFee);
354     }
355 
356     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
357         if (tokenAmount == 0) {
358             return;
359         }
360         
361         address[] memory path = new address[](2);
362         path[0] = address(this);
363         path[1] = uniswapV2Router.WETH();
364         _approve(address(this), address(uniswapV2Router), tokenAmount);
365         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
366             tokenAmount,
367             0,
368             path,
369             address(this),
370             block.timestamp
371         );
372     }
373         
374     function sendETHToFee(uint256 amount) private {
375         _FeeAddress.transfer(amount.div(3));
376         _marketingWalletAddress.transfer(amount.div(3));
377         _buybackWalletAddress.transfer(amount.div(3));
378     }
379     
380     function manualswap() external {
381         require(_msgSender() == _FeeAddress);
382         uint256 contractBalance = balanceOf(address(this));
383         swapTokensForEth(contractBalance);
384     }
385     
386     function manualsend() external {
387         require(_msgSender() == _FeeAddress);
388         uint256 contractETHBalance = address(this).balance;
389         sendETHToFee(contractETHBalance);
390     }
391         
392     function openTrading() external onlyOwner() {
393         require(!tradingOpen,"trading is already open");
394         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
395         uniswapV2Router = _uniswapV2Router;
396         _approve(address(this), address(uniswapV2Router), _tTotal);
397         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
398         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
399         swapEnabled = true;
400         cooldownEnabled = true;
401         _maxTxAmount = 2500000000 * 10**9;
402         tradingOpen = true;
403         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
404     }
405     
406     function setBots(address[] memory bots_) public onlyOwner {
407         for (uint i = 0; i < bots_.length; i++) {
408             bots[bots_[i]] = true;
409         }
410     }
411     
412     function delBot(address notbot) public onlyOwner {
413         bots[notbot] = false;
414     }
415         
416     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee, bool smallFee) private {
417         if(!takeFee)
418             removeAllFee();
419         else if (smallFee)
420             reduceFee();
421         if (_isExcluded[sender] && !_isExcluded[recipient]) {
422             _transferFromExcluded(sender, recipient, amount);
423         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
424             _transferToExcluded(sender, recipient, amount);
425         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
426             _transferBothExcluded(sender, recipient, amount);
427         } else {
428             _transferStandard(sender, recipient, amount);
429         }
430         if(!takeFee || !smallFee)
431             restoreAllFee();
432     }
433 
434     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
435         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
436         _rOwned[sender] = _rOwned[sender].sub(rAmount);
437         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
438         _takeTeam(tTeam); 
439         _reflectFee(rFee, tFee);
440         emit Transfer(sender, recipient, tTransferAmount);
441     }
442 
443     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
444         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
445         _rOwned[sender] = _rOwned[sender].sub(rAmount);
446         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
447         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
448         _takeTeam(tTeam);           
449         _reflectFee(rFee, tFee);
450         emit Transfer(sender, recipient, tTransferAmount);
451     }
452 
453     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
454         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
455         _tOwned[sender] = _tOwned[sender].sub(tAmount);
456         _rOwned[sender] = _rOwned[sender].sub(rAmount);
457         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
458         _takeTeam(tTeam);   
459         _reflectFee(rFee, tFee);
460         emit Transfer(sender, recipient, tTransferAmount);
461     }
462 
463     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
464         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
465         _tOwned[sender] = _tOwned[sender].sub(tAmount);
466         _rOwned[sender] = _rOwned[sender].sub(rAmount);
467         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
468         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
469         _takeTeam(tTeam);         
470         _reflectFee(rFee, tFee);
471         emit Transfer(sender, recipient, tTransferAmount);
472     }
473 
474     function _takeTeam(uint256 tTeam) private {
475         uint256 currentRate =  _getRate();
476         uint256 rTeam = tTeam.mul(currentRate);
477         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
478         if(_isExcluded[address(this)])
479             _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
480     }
481 
482     function _reflectFee(uint256 rFee, uint256 tFee) private {
483         _rTotal = _rTotal.sub(rFee);
484         _tFeeTotal = _tFeeTotal.add(tFee);
485     }
486 
487     receive() external payable {}
488 
489     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
490         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
491         uint256 currentRate =  _getRate();
492         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
493         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
494     }
495 
496     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
497         uint256 tFee = tAmount.mul(taxFee).div(100);
498         uint256 tTeam = tAmount.mul(TeamFee).div(100);
499         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
500         return (tTransferAmount, tFee, tTeam);
501     }
502 
503     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
504         uint256 rAmount = tAmount.mul(currentRate);
505         uint256 rFee = tFee.mul(currentRate);
506         uint256 rTeam = tTeam.mul(currentRate);
507         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
508         return (rAmount, rTransferAmount, rFee);
509     }
510 
511     function _getRate() private view returns(uint256) {
512         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
513         return rSupply.div(tSupply);
514     }
515 
516     function _getCurrentSupply() private view returns(uint256, uint256) {
517         uint256 rSupply = _rTotal;
518         uint256 tSupply = _tTotal;      
519         for (uint256 i = 0; i < _excluded.length; i++) {
520             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
521             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
522             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
523         }
524         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
525         return (rSupply, tSupply);
526     }
527         
528     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
529         require(maxTxPercent > 0, "Amount must be greater than 0");
530         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
531         emit MaxTxAmountUpdated(_maxTxAmount);
532     }
533 }