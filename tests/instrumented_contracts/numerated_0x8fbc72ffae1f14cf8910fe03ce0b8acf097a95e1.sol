1 /**
2  *Submitted for verification at Etherscan.io on 2021-05-27
3 */
4 
5 /*
6 Chief Shiba
7 https://t.me/chiefshiba
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
181 contract CSHIB is Context, IERC20, Ownable {
182     using SafeMath for uint256;
183     using Address for address;
184     mapping (address => uint256) private _rOwned;
185     mapping (address => uint256) private _tOwned;
186     mapping (address => mapping (address => uint256)) private _allowances;
187     mapping (address => bool) private _isExcludedFromFee;
188     mapping (address => bool) private _isExcluded;
189     mapping (address => bool) private bots;
190     mapping (address => uint) private cooldown;
191     address[] private _excluded;
192     uint256 private constant MAX = ~uint256(0);
193     uint256 private constant _tTotal = 1000000000000 * 10**9;
194     uint256 private _rTotal = (MAX - (MAX % _tTotal));
195     uint256 private _tFeeTotal;
196     string private constant _name = "Chief Shiba";
197     string private constant _symbol = 'CSHIB';
198     uint8 private constant _decimals = 9;
199     uint256 private _taxFee = 5;
200     uint256 private _teamFee = 10;
201     uint256 private _previousTaxFee = _taxFee;
202     uint256 private _previousteamFee = _teamFee;
203     address payable private _FeeAddress;
204     address payable private _marketingWalletAddress;
205     IUniswapV2Router02 private uniswapV2Router;
206     address private uniswapV2Pair;
207     bool private tradingOpen;
208     bool private inSwap = false;
209     bool private swapEnabled = false;
210     bool private cooldownEnabled = false;
211     uint256 private _maxTxAmount = _tTotal;
212     event MaxTxAmountUpdated(uint _maxTxAmount);
213     modifier lockTheSwap {
214         inSwap = true;
215         _;
216         inSwap = false;
217     }
218     constructor (address payable FeeAddress, address payable marketingWalletAddress) public {
219         _FeeAddress = FeeAddress;
220         _marketingWalletAddress = marketingWalletAddress;
221         _rOwned[_msgSender()] = _rTotal;
222         _isExcludedFromFee[owner()] = true;
223         _isExcludedFromFee[address(this)] = true;
224         _isExcludedFromFee[FeeAddress] = true;
225         _isExcludedFromFee[marketingWalletAddress] = true;
226         emit Transfer(address(0), _msgSender(), _tTotal);
227     }
228 
229     function name() public pure returns (string memory) {
230         return _name;
231     }
232 
233     function symbol() public pure returns (string memory) {
234         return _symbol;
235     }
236 
237     function decimals() public pure returns (uint8) {
238         return _decimals;
239     }
240 
241     function totalSupply() public view override returns (uint256) {
242         return _tTotal;
243     }
244 
245     function balanceOf(address account) public view override returns (uint256) {
246         if (_isExcluded[account]) return _tOwned[account];
247         return tokenFromReflection(_rOwned[account]);
248     }
249 
250     function transfer(address recipient, uint256 amount) public override returns (bool) {
251         _transfer(_msgSender(), recipient, amount);
252         return true;
253     }
254 
255     function allowance(address owner, address spender) public view override returns (uint256) {
256         return _allowances[owner][spender];
257     }
258 
259     function approve(address spender, uint256 amount) public override returns (bool) {
260         _approve(_msgSender(), spender, amount);
261         return true;
262     }
263 
264     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
265         _transfer(sender, recipient, amount);
266         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
267         return true;
268     }
269 
270     function setCooldownEnabled(bool onoff) external onlyOwner() {
271         cooldownEnabled = onoff;
272     }
273 
274     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
275         require(rAmount <= _rTotal, "Amount must be less than total reflections");
276         uint256 currentRate =  _getRate();
277         return rAmount.div(currentRate);
278     }
279 
280     function removeAllFee() private {
281         if(_taxFee == 0 && _teamFee == 0) return;
282         _previousTaxFee = _taxFee;
283         _previousteamFee = _teamFee;
284         _taxFee = 0;
285         _teamFee = 0;
286     }
287     
288     function restoreAllFee() private {
289         _taxFee = _previousTaxFee;
290         _teamFee = _previousteamFee;
291     }
292 
293     function _approve(address owner, address spender, uint256 amount) private {
294         require(owner != address(0), "ERC20: approve from the zero address");
295         require(spender != address(0), "ERC20: approve to the zero address");
296         _allowances[owner][spender] = amount;
297         emit Approval(owner, spender, amount);
298     }
299 
300     function _transfer(address from, address to, uint256 amount) private {
301         require(from != address(0), "ERC20: transfer from the zero address");
302         require(to != address(0), "ERC20: transfer to the zero address");
303         require(amount > 0, "Transfer amount must be greater than zero");
304         
305         if (from != owner() && to != owner()) {
306             if (cooldownEnabled) {
307                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
308                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Uniswap only");
309                 }
310             }
311             require(amount <= _maxTxAmount);
312             require(!bots[from] && !bots[to]);
313             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
314                 require(cooldown[to] < block.timestamp);
315                 cooldown[to] = block.timestamp + (30 seconds);
316             }
317             uint256 contractTokenBalance = balanceOf(address(this));
318             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
319                 swapTokensForEth(contractTokenBalance);
320                 uint256 contractETHBalance = address(this).balance;
321                 if(contractETHBalance > 0) {
322                     sendETHToFee(address(this).balance);
323                 }
324             }
325         }
326         bool takeFee = true;
327 
328         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
329             takeFee = false;
330         }
331 		
332         _tokenTransfer(from,to,amount,takeFee);
333     }
334 
335     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
336         address[] memory path = new address[](2);
337         path[0] = address(this);
338         path[1] = uniswapV2Router.WETH();
339         _approve(address(this), address(uniswapV2Router), tokenAmount);
340         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
341             tokenAmount,
342             0,
343             path,
344             address(this),
345             block.timestamp
346         );
347     }
348         
349     function sendETHToFee(uint256 amount) private {
350         _FeeAddress.transfer(amount.div(2));
351         _marketingWalletAddress.transfer(amount.div(2));
352     }
353     
354     function manualswap() external {
355         require(_msgSender() == _FeeAddress);
356         uint256 contractBalance = balanceOf(address(this));
357         swapTokensForEth(contractBalance);
358     }
359     
360     function manualsend() external {
361         require(_msgSender() == _FeeAddress);
362         uint256 contractETHBalance = address(this).balance;
363         sendETHToFee(contractETHBalance);
364     }
365         
366     function openTrading() external onlyOwner() {
367         require(!tradingOpen,"trading is already open");
368         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
369         uniswapV2Router = _uniswapV2Router;
370         _approve(address(this), address(uniswapV2Router), _tTotal);
371         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
372         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
373         swapEnabled = true;
374         cooldownEnabled = true;
375         _maxTxAmount = 4250000000 * 10**9;
376         tradingOpen = true;
377         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
378     }
379     
380     function setBots(address[] memory bots_) public onlyOwner {
381         for (uint i = 0; i < bots_.length; i++) {
382             bots[bots_[i]] = true;
383         }
384     }
385     
386     function delBot(address notbot) public onlyOwner {
387         bots[notbot] = false;
388     }
389         
390     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
391         if(!takeFee)
392             removeAllFee();
393         if (_isExcluded[sender] && !_isExcluded[recipient]) {
394             _transferFromExcluded(sender, recipient, amount);
395         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
396             _transferToExcluded(sender, recipient, amount);
397         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
398             _transferBothExcluded(sender, recipient, amount);
399         } else {
400             _transferStandard(sender, recipient, amount);
401         }
402         if(!takeFee)
403             restoreAllFee();
404     }
405 
406     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
407         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
408         _rOwned[sender] = _rOwned[sender].sub(rAmount);
409         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
410         _takeTeam(tTeam); 
411         _reflectFee(rFee, tFee);
412         emit Transfer(sender, recipient, tTransferAmount);
413     }
414 
415     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
416         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
417         _rOwned[sender] = _rOwned[sender].sub(rAmount);
418         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
419         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
420         _takeTeam(tTeam);           
421         _reflectFee(rFee, tFee);
422         emit Transfer(sender, recipient, tTransferAmount);
423     }
424 
425     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
426         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
427         _tOwned[sender] = _tOwned[sender].sub(tAmount);
428         _rOwned[sender] = _rOwned[sender].sub(rAmount);
429         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
430         _takeTeam(tTeam);   
431         _reflectFee(rFee, tFee);
432         emit Transfer(sender, recipient, tTransferAmount);
433     }
434 
435     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
436         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
437         _tOwned[sender] = _tOwned[sender].sub(tAmount);
438         _rOwned[sender] = _rOwned[sender].sub(rAmount);
439         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
440         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
441         _takeTeam(tTeam);         
442         _reflectFee(rFee, tFee);
443         emit Transfer(sender, recipient, tTransferAmount);
444     }
445 
446     function _takeTeam(uint256 tTeam) private {
447         uint256 currentRate =  _getRate();
448         uint256 rTeam = tTeam.mul(currentRate);
449         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
450         if(_isExcluded[address(this)])
451             _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
452     }
453 
454     function _reflectFee(uint256 rFee, uint256 tFee) private {
455         _rTotal = _rTotal.sub(rFee);
456         _tFeeTotal = _tFeeTotal.add(tFee);
457     }
458 
459     receive() external payable {}
460 
461     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
462         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
463         uint256 currentRate =  _getRate();
464         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
465         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
466     }
467 
468     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
469         uint256 tFee = tAmount.mul(taxFee).div(100);
470         uint256 tTeam = tAmount.mul(TeamFee).div(100);
471         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
472         return (tTransferAmount, tFee, tTeam);
473     }
474 
475     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
476         uint256 rAmount = tAmount.mul(currentRate);
477         uint256 rFee = tFee.mul(currentRate);
478         uint256 rTeam = tTeam.mul(currentRate);
479         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
480         return (rAmount, rTransferAmount, rFee);
481     }
482 
483     function _getRate() private view returns(uint256) {
484         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
485         return rSupply.div(tSupply);
486     }
487 
488     function _getCurrentSupply() private view returns(uint256, uint256) {
489         uint256 rSupply = _rTotal;
490         uint256 tSupply = _tTotal;      
491         for (uint256 i = 0; i < _excluded.length; i++) {
492             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
493             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
494             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
495         }
496         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
497         return (rSupply, tSupply);
498     }
499         
500     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
501         require(maxTxPercent > 0, "Amount must be greater than 0");
502         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
503         emit MaxTxAmountUpdated(_maxTxAmount);
504     }
505 }