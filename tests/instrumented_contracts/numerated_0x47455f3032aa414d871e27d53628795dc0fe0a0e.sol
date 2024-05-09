1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.6.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this;
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     function totalSupply() external view returns (uint256);
17     function balanceOf(address account) external view returns (uint256);
18     function transfer(address recipient, uint256 amount) external returns (bool);
19     function allowance(address owner, address spender) external view returns (uint256);
20     function approve(address spender, uint256 amount) external returns (bool);
21     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
22     event Transfer(address indexed from, address indexed to, uint256 value);
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24 }
25 
26 library SafeMath {
27     function add(uint256 a, uint256 b) internal pure returns (uint256) {
28         uint256 c = a + b;
29         require(c >= a, "SafeMath: addition overflow");
30         return c;
31     }
32 
33     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
34         return sub(a, b, "SafeMath: subtraction overflow");
35     }
36 
37     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
38         require(b <= a, errorMessage);
39         uint256 c = a - b;
40         return c;
41     }
42 
43     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
44         if (a == 0) {
45             return 0;
46         }
47         uint256 c = a * b;
48         require(c / a == b, "SafeMath: multiplication overflow");
49         return c;
50     }
51 
52     function div(uint256 a, uint256 b) internal pure returns (uint256) {
53         return div(a, b, "SafeMath: division by zero");
54     }
55 
56     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
57         require(b > 0, errorMessage);
58         uint256 c = a / b;
59         return c;
60     }
61 
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         return mod(a, b, "SafeMath: modulo by zero");
64     }
65 
66     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b != 0, errorMessage);
68         return a % b;
69     }
70 }
71 
72 library Address {
73     function isContract(address account) internal view returns (bool) {
74         bytes32 codehash;
75         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
76         assembly { codehash := extcodehash(account) }
77         return (codehash != accountHash && codehash != 0x0);
78     }
79 
80     function sendValue(address payable recipient, uint256 amount) internal {
81         require(address(this).balance >= amount, "Address: insufficient balance");
82         (bool success, ) = recipient.call{ value: amount }("");
83         require(success, "Address: unable to send value, recipient may have reverted");
84     }
85 
86     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
87         return functionCall(target, data, "Address: low-level call failed");
88     }
89 
90     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
91         return _functionCallWithValue(target, data, 0, errorMessage);
92     }
93 
94     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
95         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
96     }
97 
98     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
99         require(address(this).balance >= value, "Address: insufficient balance for call");
100         return _functionCallWithValue(target, data, value, errorMessage);
101     }
102 
103     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
104         require(isContract(target), "Address: call to non-contract");
105         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
106         if (success) {
107             return returndata;
108         } else {
109             if (returndata.length > 0) {
110                 assembly {
111                     let returndata_size := mload(returndata)
112                     revert(add(32, returndata), returndata_size)
113                 }
114             } else {
115                 revert(errorMessage);
116             }
117         }
118     }
119 }
120 
121 contract Ownable is Context {
122     address private _owner;
123     address private _previousOwner;
124     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
125 
126     constructor () internal {
127         address msgSender = _msgSender();
128         _owner = msgSender;
129         emit OwnershipTransferred(address(0), msgSender);
130     }
131 
132     function owner() public view returns (address) {
133         return _owner;
134     }
135 
136     modifier onlyOwner() {
137         require(_owner == _msgSender(), "Ownable: caller is not the owner");
138         _;
139     }
140 
141     function renounceOwnership() public virtual onlyOwner {
142         emit OwnershipTransferred(_owner, address(0));
143         _owner = address(0);
144     }
145 
146 }  
147 
148 interface IUniswapV2Factory {
149     function createPair(address tokenA, address tokenB) external returns (address pair);
150 }
151 
152 interface IUniswapV2Router02 {
153     function swapExactTokensForETHSupportingFeeOnTransferTokens(
154         uint amountIn,
155         uint amountOutMin,
156         address[] calldata path,
157         address to,
158         uint deadline
159     ) external;
160     function factory() external pure returns (address);
161     function WETH() external pure returns (address);
162     function addLiquidityETH(
163         address token,
164         uint amountTokenDesired,
165         uint amountTokenMin,
166         uint amountETHMin,
167         address to,
168         uint deadline
169     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
170 }
171 
172 contract ETHXSHIB is Context, IERC20, Ownable {
173     using SafeMath for uint256;
174     using Address for address;
175     mapping (address => uint256) private _rOwned;
176     mapping (address => uint256) private _tOwned;
177     mapping (address => mapping (address => uint256)) private _allowances;
178     mapping (address => bool) private _isExcludedFromFee;
179     mapping (address => bool) private _isExcluded;
180     mapping (address => bool) private bots;
181     mapping (address => uint) private cooldown;
182     address[] private _excluded;
183     uint256 private constant MAX = ~uint256(0);
184     uint256 private constant _tTotal = 1000000000000 * 10**9;
185     uint256 private _rTotal = (MAX - (MAX % _tTotal));
186     uint256 private _tFeeTotal;
187     string private constant _name = "Ethereum X Shiba";
188     string private constant _symbol = 'ETHXSHIB';
189     uint8 private constant _decimals = 9;
190     uint256 private _taxFee = 3;
191     uint256 private _teamFee = 7;
192     uint256 private _previousTaxFee = _taxFee;
193     uint256 private _previousteamFee = _teamFee;
194     address payable private _FeeAddress;
195     address payable private _marketingWalletAddress;
196     IUniswapV2Router02 private uniswapV2Router;
197     address private uniswapV2Pair;
198     bool private tradingOpen;
199     bool private inSwap = false;
200     bool private swapEnabled = false;
201     bool private cooldownEnabled = false;
202     uint256 private _maxTxAmount = _tTotal;
203     event MaxTxAmountUpdated(uint _maxTxAmount);
204     modifier lockTheSwap {
205         inSwap = true;
206         _;
207         inSwap = false;
208     }
209     constructor (address payable FeeAddress, address payable marketingWalletAddress) public {
210         _FeeAddress = FeeAddress;
211         _marketingWalletAddress = marketingWalletAddress;
212         _rOwned[_msgSender()] = _rTotal;
213         _isExcludedFromFee[owner()] = true;
214         _isExcludedFromFee[address(this)] = true;
215         _isExcludedFromFee[FeeAddress] = true;
216         _isExcludedFromFee[marketingWalletAddress] = true;
217         emit Transfer(address(0), _msgSender(), _tTotal);
218     }
219 
220     function name() public pure returns (string memory) {
221         return _name;
222     }
223 
224     function symbol() public pure returns (string memory) {
225         return _symbol;
226     }
227 
228     function decimals() public pure returns (uint8) {
229         return _decimals;
230     }
231 
232     function totalSupply() public view override returns (uint256) {
233         return _tTotal;
234     }
235 
236     function balanceOf(address account) public view override returns (uint256) {
237         if (_isExcluded[account]) return _tOwned[account];
238         return tokenFromReflection(_rOwned[account]);
239     }
240 
241     function transfer(address recipient, uint256 amount) public override returns (bool) {
242         _transfer(_msgSender(), recipient, amount);
243         return true;
244     }
245 
246     function allowance(address owner, address spender) public view override returns (uint256) {
247         return _allowances[owner][spender];
248     }
249 
250     function approve(address spender, uint256 amount) public override returns (bool) {
251         _approve(_msgSender(), spender, amount);
252         return true;
253     }
254 
255     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
256         _transfer(sender, recipient, amount);
257         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
258         return true;
259     }
260 
261     function setCooldownEnabled(bool onoff) external onlyOwner() {
262         cooldownEnabled = onoff;
263     }
264 
265     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
266         require(rAmount <= _rTotal, "Amount must be less than total reflections");
267         uint256 currentRate =  _getRate();
268         return rAmount.div(currentRate);
269     }
270 
271     function removeAllFee() private {
272         if(_taxFee == 0 && _teamFee == 0) return;
273         _previousTaxFee = _taxFee;
274         _previousteamFee = _teamFee;
275         _taxFee = 0;
276         _teamFee = 0;
277     }
278     
279     function restoreAllFee() private {
280         _taxFee = _previousTaxFee;
281         _teamFee = _previousteamFee;
282     }
283 
284     function _approve(address owner, address spender, uint256 amount) private {
285         require(owner != address(0), "ERC20: approve from the zero address");
286         require(spender != address(0), "ERC20: approve to the zero address");
287         _allowances[owner][spender] = amount;
288         emit Approval(owner, spender, amount);
289     }
290 
291     function _transfer(address from, address to, uint256 amount) private {
292         require(from != address(0), "ERC20: transfer from the zero address");
293         require(to != address(0), "ERC20: transfer to the zero address");
294         require(amount > 0, "Transfer amount must be greater than zero");
295         
296         if (from != owner() && to != owner()) {
297             if (cooldownEnabled) {
298                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
299                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Uniswap only");
300                 }
301             }
302             if(from != address(this)){
303                 require(amount <= _maxTxAmount);
304                 require(!bots[from] && !bots[to]);
305             }
306             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
307                 require(cooldown[to] < block.timestamp);
308                 cooldown[to] = block.timestamp + (30 seconds);
309             }
310             uint256 contractTokenBalance = balanceOf(address(this));
311             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
312                 swapTokensForEth(contractTokenBalance);
313                 uint256 contractETHBalance = address(this).balance;
314                 if(contractETHBalance > 0) {
315                     sendETHToFee(address(this).balance);
316                 }
317             }
318         }
319         bool takeFee = true;
320 
321         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
322             takeFee = false;
323         }
324 		
325         _tokenTransfer(from,to,amount,takeFee);
326     }
327 
328     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
329         address[] memory path = new address[](2);
330         path[0] = address(this);
331         path[1] = uniswapV2Router.WETH();
332         _approve(address(this), address(uniswapV2Router), tokenAmount);
333         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
334             tokenAmount,
335             0,
336             path,
337             address(this),
338             block.timestamp
339         );
340     }
341         
342     function sendETHToFee(uint256 amount) private {
343         _FeeAddress.transfer(amount.div(2));
344         _marketingWalletAddress.transfer(amount.div(2));
345     }
346     
347     function manualswap() external {
348         require(_msgSender() == _FeeAddress);
349         uint256 contractBalance = balanceOf(address(this));
350         swapTokensForEth(contractBalance);
351     }
352     
353     function manualsend() external {
354         require(_msgSender() == _FeeAddress);
355         uint256 contractETHBalance = address(this).balance;
356         sendETHToFee(contractETHBalance);
357     }
358         
359     function openTrading() external onlyOwner() {
360         require(!tradingOpen,"trading is already open");
361         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
362         uniswapV2Router = _uniswapV2Router;
363         _approve(address(this), address(uniswapV2Router), _tTotal);
364         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
365         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
366         swapEnabled = true;
367         cooldownEnabled = true;
368         _maxTxAmount = 5000000000 * 10**9;
369         tradingOpen = true;
370         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
371     }
372     
373     function setBots(address[] memory bots_) public onlyOwner {
374         for (uint i = 0; i < bots_.length; i++) {
375             bots[bots_[i]] = true;
376         }
377     }
378     
379     function delBot(address notbot) public onlyOwner {
380         bots[notbot] = false;
381     }
382         
383     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
384         if(!takeFee)
385             removeAllFee();
386         if (_isExcluded[sender] && !_isExcluded[recipient]) {
387             _transferFromExcluded(sender, recipient, amount);
388         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
389             _transferToExcluded(sender, recipient, amount);
390         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
391             _transferBothExcluded(sender, recipient, amount);
392         } else {
393             _transferStandard(sender, recipient, amount);
394         }
395         if(!takeFee)
396             restoreAllFee();
397     }
398 
399     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
400         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
401         _rOwned[sender] = _rOwned[sender].sub(rAmount);
402         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
403         _takeTeam(tTeam); 
404         _reflectFee(rFee, tFee);
405         emit Transfer(sender, recipient, tTransferAmount);
406     }
407 
408     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
409         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
410         _rOwned[sender] = _rOwned[sender].sub(rAmount);
411         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
412         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
413         _takeTeam(tTeam);           
414         _reflectFee(rFee, tFee);
415         emit Transfer(sender, recipient, tTransferAmount);
416     }
417 
418     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
419         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
420         _tOwned[sender] = _tOwned[sender].sub(tAmount);
421         _rOwned[sender] = _rOwned[sender].sub(rAmount);
422         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
423         _takeTeam(tTeam);   
424         _reflectFee(rFee, tFee);
425         emit Transfer(sender, recipient, tTransferAmount);
426     }
427 
428     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
429         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
430         _tOwned[sender] = _tOwned[sender].sub(tAmount);
431         _rOwned[sender] = _rOwned[sender].sub(rAmount);
432         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
433         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
434         _takeTeam(tTeam);         
435         _reflectFee(rFee, tFee);
436         emit Transfer(sender, recipient, tTransferAmount);
437     }
438 
439     function _takeTeam(uint256 tTeam) private {
440         uint256 currentRate =  _getRate();
441         uint256 rTeam = tTeam.mul(currentRate);
442         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
443         if(_isExcluded[address(this)])
444             _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
445     }
446 
447     function _reflectFee(uint256 rFee, uint256 tFee) private {
448         _rTotal = _rTotal.sub(rFee);
449         _tFeeTotal = _tFeeTotal.add(tFee);
450     }
451 
452     receive() external payable {}
453 
454     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
455         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
456         uint256 currentRate =  _getRate();
457         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
458         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
459     }
460 
461     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
462         uint256 tFee = tAmount.mul(taxFee).div(100);
463         uint256 tTeam = tAmount.mul(TeamFee).div(100);
464         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
465         return (tTransferAmount, tFee, tTeam);
466     }
467 
468     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
469         uint256 rAmount = tAmount.mul(currentRate);
470         uint256 rFee = tFee.mul(currentRate);
471         uint256 rTeam = tTeam.mul(currentRate);
472         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
473         return (rAmount, rTransferAmount, rFee);
474     }
475 
476     function _getRate() private view returns(uint256) {
477         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
478         return rSupply.div(tSupply);
479     }
480 
481     function _getCurrentSupply() private view returns(uint256, uint256) {
482         uint256 rSupply = _rTotal;
483         uint256 tSupply = _tTotal;      
484         for (uint256 i = 0; i < _excluded.length; i++) {
485             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
486             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
487             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
488         }
489         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
490         return (rSupply, tSupply);
491     }
492         
493     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
494         require(maxTxPercent > 0, "Amount must be greater than 0");
495         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
496         emit MaxTxAmountUpdated(_maxTxAmount);
497     }
498 }