1 /*
2 I'm No one.
3 I'm fair, but I don't exist.
4 I will push the limits.
5 I will secure the funds.
6 After I am done, I will disappear.
7 You are the chosen one, my legacy is in your hands.
8 
9 Initial buy limit: 1% = 10,000,000,000
10 Buy limit will be lifted every 5 minutes
11 Stealthiest launch ever
12 */
13 
14 // SPDX-License-Identifier: Unlicensed
15 pragma solidity ^0.6.12;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this;
24         return msg.data;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30     function balanceOf(address account) external view returns (uint256);
31     function transfer(address recipient, uint256 amount) external returns (bool);
32     function allowance(address owner, address spender) external view returns (uint256);
33     function approve(address spender, uint256 amount) external returns (bool);
34     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 library SafeMath {
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53         return c;
54     }
55 
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         if (a == 0) {
58             return 0;
59         }
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62         return c;
63     }
64 
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b > 0, errorMessage);
71         uint256 c = a / b;
72         return c;
73     }
74 
75     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
76         return mod(a, b, "SafeMath: modulo by zero");
77     }
78 
79     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b != 0, errorMessage);
81         return a % b;
82     }
83 }
84 
85 library Address {
86     function isContract(address account) internal view returns (bool) {
87         bytes32 codehash;
88         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
89         assembly { codehash := extcodehash(account) }
90         return (codehash != accountHash && codehash != 0x0);
91     }
92 
93     function sendValue(address payable recipient, uint256 amount) internal {
94         require(address(this).balance >= amount, "Address: insufficient balance");
95         (bool success, ) = recipient.call{ value: amount }("");
96         require(success, "Address: unable to send value, recipient may have reverted");
97     }
98 
99     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
100         return functionCall(target, data, "Address: low-level call failed");
101     }
102 
103     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
104         return _functionCallWithValue(target, data, 0, errorMessage);
105     }
106 
107     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
108         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
109     }
110 
111     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
112         require(address(this).balance >= value, "Address: insufficient balance for call");
113         return _functionCallWithValue(target, data, value, errorMessage);
114     }
115 
116     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
117         require(isContract(target), "Address: call to non-contract");
118         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
119         if (success) {
120             return returndata;
121         } else {
122             if (returndata.length > 0) {
123                 assembly {
124                     let returndata_size := mload(returndata)
125                     revert(add(32, returndata), returndata_size)
126                 }
127             } else {
128                 revert(errorMessage);
129             }
130         }
131     }
132 }
133 
134 contract Ownable is Context {
135     address private _owner;
136     address private _previousOwner;
137     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
138 
139     constructor () internal {
140         address msgSender = _msgSender();
141         _owner = msgSender;
142         emit OwnershipTransferred(address(0), msgSender);
143     }
144 
145     function owner() public view returns (address) {
146         return _owner;
147     }
148 
149     modifier onlyOwner() {
150         require(_owner == _msgSender(), "Ownable: caller is not the owner");
151         _;
152     }
153 
154     function renounceOwnership() public virtual onlyOwner {
155         emit OwnershipTransferred(_owner, address(0));
156         _owner = address(0);
157     }
158 
159 }  
160 
161 interface IUniswapV2Factory {
162     function createPair(address tokenA, address tokenB) external returns (address pair);
163 }
164 
165 interface IUniswapV2Router02 {
166     function swapExactTokensForETHSupportingFeeOnTransferTokens(
167         uint amountIn,
168         uint amountOutMin,
169         address[] calldata path,
170         address to,
171         uint deadline
172     ) external;
173     function factory() external pure returns (address);
174     function WETH() external pure returns (address);
175     function addLiquidityETH(
176         address token,
177         uint amountTokenDesired,
178         uint amountTokenMin,
179         uint amountETHMin,
180         address to,
181         uint deadline
182     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
183 }
184 
185 contract NOONE is Context, IERC20, Ownable {
186     using SafeMath for uint256;
187     using Address for address;
188     mapping (address => uint256) private _rOwned;
189     mapping (address => uint256) private _tOwned;
190     mapping (address => mapping (address => uint256)) private _allowances;
191     mapping (address => bool) private _isExcludedFromFee;
192     mapping (address => bool) private _isExcluded;
193     mapping (address => bool) private bots;
194     mapping (address => uint) private cooldown;
195     address[] private _excluded;
196     uint256 private constant MAX = ~uint256(0);
197     uint256 private constant _tTotal = 1000000000000 * 10**9;
198     uint256 private _rTotal = (MAX - (MAX % _tTotal));
199     uint256 private _tFeeTotal;
200     string private constant _name = "No One ️";
201     string private constant _symbol = 'NOONE';
202     uint8 private constant _decimals = 9;
203     uint256 private _taxFee = 1;
204     uint256 private _teamFee = 9;
205     uint256 private _previousTaxFee = _taxFee;
206     uint256 private _previousteamFee = _teamFee;
207     address payable private _FeeAddress;
208     IUniswapV2Router02 private uniswapV2Router;
209     address private uniswapV2Pair;
210     bool private tradingOpen;
211     bool private inSwap = false;
212     bool private swapEnabled = false;
213     bool private cooldownEnabled = false;
214     uint256 private _maxTxAmount = _tTotal;
215     event MaxTxAmountUpdated(uint _maxTxAmount);
216     modifier lockTheSwap {
217         inSwap = true;
218         _;
219         inSwap = false;
220     }
221     constructor (address payable FeeAddress) public {
222         _FeeAddress = FeeAddress;
223         _rOwned[_msgSender()] = _rTotal;
224         _isExcludedFromFee[owner()] = true;
225         _isExcludedFromFee[address(this)] = true;
226         _isExcludedFromFee[FeeAddress] = true;
227         emit Transfer(address(0), _msgSender(), _tTotal);
228     }
229 
230     function name() public pure returns (string memory) {
231         return _name;
232     }
233 
234     function symbol() public pure returns (string memory) {
235         return _symbol;
236     }
237 
238     function decimals() public pure returns (uint8) {
239         return _decimals;
240     }
241 
242     function totalSupply() public view override returns (uint256) {
243         return _tTotal;
244     }
245 
246     function balanceOf(address account) public view override returns (uint256) {
247         if (_isExcluded[account]) return _tOwned[account];
248         return tokenFromReflection(_rOwned[account]);
249     }
250 
251     function transfer(address recipient, uint256 amount) public override returns (bool) {
252         _transfer(_msgSender(), recipient, amount);
253         return true;
254     }
255 
256     function allowance(address owner, address spender) public view override returns (uint256) {
257         return _allowances[owner][spender];
258     }
259 
260     function approve(address spender, uint256 amount) public override returns (bool) {
261         _approve(_msgSender(), spender, amount);
262         return true;
263     }
264 
265     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
266         _transfer(sender, recipient, amount);
267         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
268         return true;
269     }
270 
271     function setCooldownEnabled(bool onoff) external onlyOwner() {
272         cooldownEnabled = onoff;
273     }
274 
275     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
276         require(rAmount <= _rTotal, "Amount must be less than total reflections");
277         uint256 currentRate =  _getRate();
278         return rAmount.div(currentRate);
279     }
280 
281     function removeAllFee() private {
282         if(_taxFee == 0 && _teamFee == 0) return;
283         _previousTaxFee = _taxFee;
284         _previousteamFee = _teamFee;
285         _taxFee = 0;
286         _teamFee = 0;
287     }
288     
289     function restoreAllFee() private {
290         _taxFee = _previousTaxFee;
291         _teamFee = _previousteamFee;
292     }
293 
294     function _approve(address owner, address spender, uint256 amount) private {
295         require(owner != address(0), "ERC20: approve from the zero address");
296         require(spender != address(0), "ERC20: approve to the zero address");
297         _allowances[owner][spender] = amount;
298         emit Approval(owner, spender, amount);
299     }
300 
301     function _transfer(address from, address to, uint256 amount) private {
302         require(from != address(0), "ERC20: transfer from the zero address");
303         require(to != address(0), "ERC20: transfer to the zero address");
304         require(amount > 0, "Transfer amount must be greater than zero");
305         
306         if (from != owner() && to != owner()) {
307             if (cooldownEnabled) {
308                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
309                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Uniswap only");
310                 }
311             }
312             require(amount <= _maxTxAmount);
313             require(!bots[from] && !bots[to]);
314             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
315                 require(cooldown[to] < block.timestamp);
316                 cooldown[to] = block.timestamp + (30 seconds);
317             }
318             uint256 contractTokenBalance = balanceOf(address(this));
319             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
320                 swapTokensForEth(contractTokenBalance);
321                 uint256 contractETHBalance = address(this).balance;
322                 if(contractETHBalance > 0) {
323                     sendETHToFee(address(this).balance);
324                 }
325             }
326         }
327         bool takeFee = true;
328 
329         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
330             takeFee = false;
331         }
332 		
333         _tokenTransfer(from,to,amount,takeFee);
334     }
335 
336     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
337         address[] memory path = new address[](2);
338         path[0] = address(this);
339         path[1] = uniswapV2Router.WETH();
340         _approve(address(this), address(uniswapV2Router), tokenAmount);
341         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
342             tokenAmount,
343             0,
344             path,
345             address(this),
346             block.timestamp
347         );
348     }
349         
350     function sendETHToFee(uint256 amount) private {
351         _FeeAddress.transfer(amount);
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
375         _maxTxAmount = 10000000000 * 10**9;
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