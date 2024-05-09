1 // SPDX-License-Identifier: Unlicensed
2 // 
3 // t.me/babydogeerc
4 //: Website coming soon 
5 //: BABY DOGE DOO
6 
7 pragma solidity ^0.6.12;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this;
16         return msg.data;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         return div(a, b, "SafeMath: division by zero");
59     }
60 
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 
67     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
68         return mod(a, b, "SafeMath: modulo by zero");
69     }
70 
71     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b != 0, errorMessage);
73         return a % b;
74     }
75 }
76 
77 library Address {
78     function isContract(address account) internal view returns (bool) {
79         bytes32 codehash;
80         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
81         assembly { codehash := extcodehash(account) }
82         return (codehash != accountHash && codehash != 0x0);
83     }
84 
85     function sendValue(address payable recipient, uint256 amount) internal {
86         require(address(this).balance >= amount, "Address: insufficient balance");
87         (bool success, ) = recipient.call{ value: amount }("");
88         require(success, "Address: unable to send value, recipient may have reverted");
89     }
90 
91     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
92         return functionCall(target, data, "Address: low-level call failed");
93     }
94 
95     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
96         return _functionCallWithValue(target, data, 0, errorMessage);
97     }
98 
99     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
100         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
101     }
102 
103     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
104         require(address(this).balance >= value, "Address: insufficient balance for call");
105         return _functionCallWithValue(target, data, value, errorMessage);
106     }
107 
108     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
109         require(isContract(target), "Address: call to non-contract");
110         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
111         if (success) {
112             return returndata;
113         } else {
114             if (returndata.length > 0) {
115                 assembly {
116                     let returndata_size := mload(returndata)
117                     revert(add(32, returndata), returndata_size)
118                 }
119             } else {
120                 revert(errorMessage);
121             }
122         }
123     }
124 }
125 
126 contract Ownable is Context {
127     address private _owner;
128     address private _previousOwner;
129     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
130 
131     constructor () internal {
132         address msgSender = _msgSender();
133         _owner = msgSender;
134         emit OwnershipTransferred(address(0), msgSender);
135     }
136 
137     function owner() public view returns (address) {
138         return _owner;
139     }
140 
141     modifier onlyOwner() {
142         require(_owner == _msgSender(), "Ownable: caller is not the owner");
143         _;
144     }
145 
146     function renounceOwnership() public virtual onlyOwner {
147         emit OwnershipTransferred(_owner, address(0));
148         _owner = address(0);
149     }
150 
151 }  
152 
153 interface IUniswapV2Factory {
154     function createPair(address tokenA, address tokenB) external returns (address pair);
155 }
156 
157 interface IUniswapV2Router02 {
158     function swapExactTokensForETHSupportingFeeOnTransferTokens(
159         uint amountIn,
160         uint amountOutMin,
161         address[] calldata path,
162         address to,
163         uint deadline
164     ) external;
165     function factory() external pure returns (address);
166     function WETH() external pure returns (address);
167     function addLiquidityETH(
168         address token,
169         uint amountTokenDesired,
170         uint amountTokenMin,
171         uint amountETHMin,
172         address to,
173         uint deadline
174     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
175 }
176 
177 contract BabyDogeDoo is Context, IERC20, Ownable {
178     using SafeMath for uint256;
179     using Address for address;
180     mapping (address => uint256) private _rOwned;
181     mapping (address => uint256) private _tOwned;
182     mapping (address => mapping (address => uint256)) private _allowances;
183     mapping (address => bool) private _isExcludedFromFee;
184     mapping (address => bool) private _isExcluded;
185     mapping (address => bool) private bots;
186     mapping (address => uint) private cooldown;
187     address[] private _excluded;
188     uint256 private constant MAX = ~uint256(0);
189     uint256 private constant _tTotal = 1000000000000 * 10**9;
190     uint256 private _rTotal = (MAX - (MAX % _tTotal));
191     uint256 private _tFeeTotal;
192     string public constant _name = "Baby Doge Doo";
193     string public constant _symbol = "BABBY";
194     uint8 private constant _decimals = 9;
195     uint256 private _taxFee = 5;
196     uint256 private _teamFee = 10;
197     uint256 private _previousTaxFee = _taxFee;
198     uint256 private _previousteamFee = _teamFee;
199     address payable private _FeeAddress;
200     address payable private _marketingWalletAddress;
201     IUniswapV2Router02 private uniswapV2Router;
202     address private uniswapV2Pair;
203     bool private tradingOpen;
204     bool private inSwap = false;
205     bool private swapEnabled = false;
206     bool private cooldownEnabled = false;
207     uint256 private _maxTxAmount = _tTotal;
208     event MaxTxAmountUpdated(uint _maxTxAmount);
209     modifier lockTheSwap {
210         inSwap = true;
211         _;
212         inSwap = false;
213     }
214     constructor (address payable FeeAddress, address payable marketingWalletAddress) public {
215         _FeeAddress = FeeAddress;
216         _marketingWalletAddress = marketingWalletAddress;
217         _rOwned[_msgSender()] = _rTotal;
218         _isExcludedFromFee[owner()] = true;
219         _isExcludedFromFee[address(this)] = true;
220         _isExcludedFromFee[FeeAddress] = true;
221         _isExcludedFromFee[marketingWalletAddress] = true;
222         emit Transfer(address(0), _msgSender(), _tTotal);
223     }
224 
225     function name() public pure returns (string memory) {
226         return _name;
227     }
228 
229     function symbol() public pure returns (string memory) {
230         return _symbol;
231     }
232 
233     function decimals() public pure returns (uint8) {
234         return _decimals;
235     }
236 
237     function totalSupply() public view override returns (uint256) {
238         return _tTotal;
239     }
240 
241     function balanceOf(address account) public view override returns (uint256) {
242         if (_isExcluded[account]) return _tOwned[account];
243         return tokenFromReflection(_rOwned[account]);
244     }
245 
246     function transfer(address recipient, uint256 amount) public override returns (bool) {
247         _transfer(_msgSender(), recipient, amount);
248         return true;
249     }
250 
251     function allowance(address owner, address spender) public view override returns (uint256) {
252         return _allowances[owner][spender];
253     }
254 
255     function approve(address spender, uint256 amount) public override returns (bool) {
256         _approve(_msgSender(), spender, amount);
257         return true;
258     }
259 
260     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
261         _transfer(sender, recipient, amount);
262         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
263         return true;
264     }
265 
266     function setCooldownEnabled(bool onoff) external onlyOwner() {
267         cooldownEnabled = onoff;
268     }
269 
270     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
271         require(rAmount <= _rTotal, "Amount must be less than total reflections");
272         uint256 currentRate =  _getRate();
273         return rAmount.div(currentRate);
274     }
275 
276     function removeAllFee() private {
277         if(_taxFee == 0 && _teamFee == 0) return;
278         _previousTaxFee = _taxFee;
279         _previousteamFee = _teamFee;
280         _taxFee = 0;
281         _teamFee = 0;
282     }
283     
284     function restoreAllFee() private {
285         _taxFee = _previousTaxFee;
286         _teamFee = _previousteamFee;
287     }
288 
289     function _approve(address owner, address spender, uint256 amount) private {
290         require(owner != address(0), "ERC20: approve from the zero address");
291         require(spender != address(0), "ERC20: approve to the zero address");
292         _allowances[owner][spender] = amount;
293         emit Approval(owner, spender, amount);
294     }
295 
296     function _transfer(address from, address to, uint256 amount) private {
297         require(from != address(0), "ERC20: transfer from the zero address");
298         require(to != address(0), "ERC20: transfer to the zero address");
299         require(amount > 0, "Transfer amount must be greater than zero");
300         
301         if (from != owner() && to != owner()) {
302             if (cooldownEnabled) {
303                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
304                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Uniswap only");
305                 }
306             }
307             if(from != address(this)){
308                 require(amount <= _maxTxAmount);
309                 require(!bots[from] && !bots[to]);
310             }
311             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
312                 require(cooldown[to] < block.timestamp);
313                 cooldown[to] = block.timestamp + (30 seconds);
314             }
315             uint256 contractTokenBalance = balanceOf(address(this));
316             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
317                 swapTokensForEth(contractTokenBalance);
318                 uint256 contractETHBalance = address(this).balance;
319                 if(contractETHBalance > 0) {
320                     sendETHToFee(address(this).balance);
321                 }
322             }
323         }
324         bool takeFee = true;
325 
326         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
327             takeFee = false;
328         }
329 		
330         _tokenTransfer(from,to,amount,takeFee);
331     }
332 
333     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
334         address[] memory path = new address[](2);
335         path[0] = address(this);
336         path[1] = uniswapV2Router.WETH();
337         _approve(address(this), address(uniswapV2Router), tokenAmount);
338         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
339             tokenAmount,
340             0,
341             path,
342             address(this),
343             block.timestamp
344         );
345     }
346         
347     function sendETHToFee(uint256 amount) private {
348         _FeeAddress.transfer(amount.div(2));
349         _marketingWalletAddress.transfer(amount.div(2));
350     }
351     
352     function manualswap() external {
353         require(_msgSender() == _FeeAddress);
354         uint256 contractBalance = balanceOf(address(this));
355         swapTokensForEth(contractBalance);
356     }
357     
358     function manualsend() external {
359         require(_msgSender() == _FeeAddress);
360         uint256 contractETHBalance = address(this).balance;
361         sendETHToFee(contractETHBalance);
362     }
363         
364     function openTrading() external onlyOwner() {
365         require(!tradingOpen,"trading is already open");
366         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
367         uniswapV2Router = _uniswapV2Router;
368         _approve(address(this), address(uniswapV2Router), _tTotal);
369         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
370         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
371         swapEnabled = true;
372         cooldownEnabled = false;
373         _maxTxAmount = 1 * 10**12 * 10**9;
374         tradingOpen = true;
375         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
376     }
377     
378     function setBots(address[] memory bots_) public onlyOwner {
379         for (uint i = 0; i < bots_.length; i++) {
380             bots[bots_[i]] = true;
381         }
382     }
383     
384     function delBot(address notbot) public onlyOwner {
385         bots[notbot] = false;
386     }
387         
388     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
389         if(!takeFee)
390             removeAllFee();
391         if (_isExcluded[sender] && !_isExcluded[recipient]) {
392             _transferFromExcluded(sender, recipient, amount);
393         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
394             _transferToExcluded(sender, recipient, amount);
395         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
396             _transferBothExcluded(sender, recipient, amount);
397         } else {
398             _transferStandard(sender, recipient, amount);
399         }
400         if(!takeFee)
401             restoreAllFee();
402     }
403 
404     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
405         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
406         _rOwned[sender] = _rOwned[sender].sub(rAmount);
407         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
408         _takeTeam(tTeam); 
409         _reflectFee(rFee, tFee);
410         emit Transfer(sender, recipient, tTransferAmount);
411     }
412 
413     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
414         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
415         _rOwned[sender] = _rOwned[sender].sub(rAmount);
416         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
417         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
418         _takeTeam(tTeam);           
419         _reflectFee(rFee, tFee);
420         emit Transfer(sender, recipient, tTransferAmount);
421     }
422 
423     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
424         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
425         _tOwned[sender] = _tOwned[sender].sub(tAmount);
426         _rOwned[sender] = _rOwned[sender].sub(rAmount);
427         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
428         _takeTeam(tTeam);   
429         _reflectFee(rFee, tFee);
430         emit Transfer(sender, recipient, tTransferAmount);
431     }
432 
433     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
434         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
435         _tOwned[sender] = _tOwned[sender].sub(tAmount);
436         _rOwned[sender] = _rOwned[sender].sub(rAmount);
437         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
438         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
439         _takeTeam(tTeam);         
440         _reflectFee(rFee, tFee);
441         emit Transfer(sender, recipient, tTransferAmount);
442     }
443 
444     function _takeTeam(uint256 tTeam) private {
445         uint256 currentRate =  _getRate();
446         uint256 rTeam = tTeam.mul(currentRate);
447         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
448         if(_isExcluded[address(this)])
449             _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
450     }
451 
452     function _reflectFee(uint256 rFee, uint256 tFee) private {
453         _rTotal = _rTotal.sub(rFee);
454         _tFeeTotal = _tFeeTotal.add(tFee);
455     }
456 
457     receive() external payable {}
458 
459     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
460         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
461         uint256 currentRate =  _getRate();
462         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
463         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
464     }
465 
466     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
467         uint256 tFee = tAmount.mul(taxFee).div(100);
468         uint256 tTeam = tAmount.mul(TeamFee).div(100);
469         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
470         return (tTransferAmount, tFee, tTeam);
471     }
472 
473     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
474         uint256 rAmount = tAmount.mul(currentRate);
475         uint256 rFee = tFee.mul(currentRate);
476         uint256 rTeam = tTeam.mul(currentRate);
477         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
478         return (rAmount, rTransferAmount, rFee);
479     }
480 
481     function _getRate() private view returns(uint256) {
482         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
483         return rSupply.div(tSupply);
484     }
485 
486     function _getCurrentSupply() private view returns(uint256, uint256) {
487         uint256 rSupply = _rTotal;
488         uint256 tSupply = _tTotal;      
489         for (uint256 i = 0; i < _excluded.length; i++) {
490             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
491             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
492             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
493         }
494         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
495         return (rSupply, tSupply);
496     }
497         
498     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
499         require(maxTxPercent > 0, "Amount must be greater than 0");
500         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
501         emit MaxTxAmountUpdated(_maxTxAmount);
502     }
503 }