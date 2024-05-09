1 /*
2 We present to you.. the notorious... the fearless.. the chad of all Shibas:
3 DON SHIBA
4 http://t.me/donshibatoken
5 */
6 
7 // SPDX-License-Identifier: Unlicensed
8 pragma solidity ^0.6.12;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address payable) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes memory) {
16         this;
17         return msg.data;
18     }
19 }
20 
21 interface IERC20 {
22     function totalSupply() external view returns (uint256);
23     function balanceOf(address account) external view returns (uint256);
24     function transfer(address recipient, uint256 amount) external returns (bool);
25     function allowance(address owner, address spender) external view returns (uint256);
26     function approve(address spender, uint256 amount) external returns (bool);
27     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
28     event Transfer(address indexed from, address indexed to, uint256 value);
29     event Approval(address indexed owner, address indexed spender, uint256 value);
30 }
31 
32 library SafeMath {
33     function add(uint256 a, uint256 b) internal pure returns (uint256) {
34         uint256 c = a + b;
35         require(c >= a, "SafeMath: addition overflow");
36         return c;
37     }
38 
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42 
43     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
44         require(b <= a, errorMessage);
45         uint256 c = a - b;
46         return c;
47     }
48 
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         if (a == 0) {
51             return 0;
52         }
53         uint256 c = a * b;
54         require(c / a == b, "SafeMath: multiplication overflow");
55         return c;
56     }
57 
58     function div(uint256 a, uint256 b) internal pure returns (uint256) {
59         return div(a, b, "SafeMath: division by zero");
60     }
61 
62     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b > 0, errorMessage);
64         uint256 c = a / b;
65         return c;
66     }
67 
68     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
69         return mod(a, b, "SafeMath: modulo by zero");
70     }
71 
72     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b != 0, errorMessage);
74         return a % b;
75     }
76 }
77 
78 library Address {
79     function isContract(address account) internal view returns (bool) {
80         bytes32 codehash;
81         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
82         assembly { codehash := extcodehash(account) }
83         return (codehash != accountHash && codehash != 0x0);
84     }
85 
86     function sendValue(address payable recipient, uint256 amount) internal {
87         require(address(this).balance >= amount, "Address: insufficient balance");
88         (bool success, ) = recipient.call{ value: amount }("");
89         require(success, "Address: unable to send value, recipient may have reverted");
90     }
91 
92     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
93         return functionCall(target, data, "Address: low-level call failed");
94     }
95 
96     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
97         return _functionCallWithValue(target, data, 0, errorMessage);
98     }
99 
100     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
101         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
102     }
103 
104     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
105         require(address(this).balance >= value, "Address: insufficient balance for call");
106         return _functionCallWithValue(target, data, value, errorMessage);
107     }
108 
109     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
110         require(isContract(target), "Address: call to non-contract");
111         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
112         if (success) {
113             return returndata;
114         } else {
115             if (returndata.length > 0) {
116                 assembly {
117                     let returndata_size := mload(returndata)
118                     revert(add(32, returndata), returndata_size)
119                 }
120             } else {
121                 revert(errorMessage);
122             }
123         }
124     }
125 }
126 
127 contract Ownable is Context {
128     address private _owner;
129     address private _previousOwner;
130     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
131 
132     constructor () internal {
133         address msgSender = _msgSender();
134         _owner = msgSender;
135         emit OwnershipTransferred(address(0), msgSender);
136     }
137 
138     function owner() public view returns (address) {
139         return _owner;
140     }
141 
142     modifier onlyOwner() {
143         require(_owner == _msgSender(), "Ownable: caller is not the owner");
144         _;
145     }
146 
147     function renounceOwnership() public virtual onlyOwner {
148         emit OwnershipTransferred(_owner, address(0));
149         _owner = address(0);
150     }
151 
152 }  
153 
154 interface IUniswapV2Factory {
155     function createPair(address tokenA, address tokenB) external returns (address pair);
156 }
157 
158 interface IUniswapV2Router02 {
159     function swapExactTokensForETHSupportingFeeOnTransferTokens(
160         uint amountIn,
161         uint amountOutMin,
162         address[] calldata path,
163         address to,
164         uint deadline
165     ) external;
166     function factory() external pure returns (address);
167     function WETH() external pure returns (address);
168     function addLiquidityETH(
169         address token,
170         uint amountTokenDesired,
171         uint amountTokenMin,
172         uint amountETHMin,
173         address to,
174         uint deadline
175     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
176 }
177 
178 contract DONSHIBA is Context, IERC20, Ownable {
179     using SafeMath for uint256;
180     using Address for address;
181     mapping (address => uint256) private _rOwned;
182     mapping (address => uint256) private _tOwned;
183     mapping (address => mapping (address => uint256)) private _allowances;
184     mapping (address => bool) private _isExcludedFromFee;
185     mapping (address => bool) private _isExcluded;
186     mapping (address => bool) private bots;
187     mapping (address => uint) private cooldown;
188     address[] private _excluded;
189     uint256 private constant MAX = ~uint256(0);
190     uint256 private constant _tTotal = 1000000000000 * 10**9;
191     uint256 private _rTotal = (MAX - (MAX % _tTotal));
192     uint256 private _tFeeTotal;
193     string private constant _name = "Don Shiba\xf0\x9f\x94\xab\xf0\x9f\x95\xb6\xf0\x9f\x92\xb0\xf0\x9f\x96\x95";
194     string private constant _symbol = 'DONSHIBA';
195     uint8 private constant _decimals = 9;
196     uint256 private _taxFee = 5;
197     uint256 private _teamFee = 10;
198     uint256 private _previousTaxFee = _taxFee;
199     uint256 private _previousteamFee = _teamFee;
200     address payable private _FeeAddress;
201     address payable private _marketingWalletAddress;
202     IUniswapV2Router02 private uniswapV2Router;
203     address private uniswapV2Pair;
204     bool private tradingOpen;
205     bool private inSwap = false;
206     bool private swapEnabled = false;
207     bool private cooldownEnabled = false;
208     uint256 private _maxTxAmount = _tTotal;
209     event MaxTxAmountUpdated(uint _maxTxAmount);
210     modifier lockTheSwap {
211         inSwap = true;
212         _;
213         inSwap = false;
214     }
215     constructor (address payable FeeAddress, address payable marketingWalletAddress) public {
216         _FeeAddress = FeeAddress;
217         _marketingWalletAddress = marketingWalletAddress;
218         _rOwned[_msgSender()] = _rTotal;
219         _isExcludedFromFee[owner()] = true;
220         _isExcludedFromFee[address(this)] = true;
221         _isExcludedFromFee[FeeAddress] = true;
222         _isExcludedFromFee[marketingWalletAddress] = true;
223         emit Transfer(address(0), _msgSender(), _tTotal);
224     }
225 
226     function name() public pure returns (string memory) {
227         return _name;
228     }
229 
230     function symbol() public pure returns (string memory) {
231         return _symbol;
232     }
233 
234     function decimals() public pure returns (uint8) {
235         return _decimals;
236     }
237 
238     function totalSupply() public view override returns (uint256) {
239         return _tTotal;
240     }
241 
242     function balanceOf(address account) public view override returns (uint256) {
243         if (_isExcluded[account]) return _tOwned[account];
244         return tokenFromReflection(_rOwned[account]);
245     }
246 
247     function transfer(address recipient, uint256 amount) public override returns (bool) {
248         _transfer(_msgSender(), recipient, amount);
249         return true;
250     }
251 
252     function allowance(address owner, address spender) public view override returns (uint256) {
253         return _allowances[owner][spender];
254     }
255 
256     function approve(address spender, uint256 amount) public override returns (bool) {
257         _approve(_msgSender(), spender, amount);
258         return true;
259     }
260 
261     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
262         _transfer(sender, recipient, amount);
263         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
264         return true;
265     }
266 
267     function setCooldownEnabled(bool onoff) external onlyOwner() {
268         cooldownEnabled = onoff;
269     }
270 
271     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
272         require(rAmount <= _rTotal, "Amount must be less than total reflections");
273         uint256 currentRate =  _getRate();
274         return rAmount.div(currentRate);
275     }
276 
277     function removeAllFee() private {
278         if(_taxFee == 0 && _teamFee == 0) return;
279         _previousTaxFee = _taxFee;
280         _previousteamFee = _teamFee;
281         _taxFee = 0;
282         _teamFee = 0;
283     }
284     
285     function restoreAllFee() private {
286         _taxFee = _previousTaxFee;
287         _teamFee = _previousteamFee;
288     }
289 
290     function _approve(address owner, address spender, uint256 amount) private {
291         require(owner != address(0), "ERC20: approve from the zero address");
292         require(spender != address(0), "ERC20: approve to the zero address");
293         _allowances[owner][spender] = amount;
294         emit Approval(owner, spender, amount);
295     }
296 
297     function _transfer(address from, address to, uint256 amount) private {
298         require(from != address(0), "ERC20: transfer from the zero address");
299         require(to != address(0), "ERC20: transfer to the zero address");
300         require(amount > 0, "Transfer amount must be greater than zero");
301         
302         if (from != owner() && to != owner()) {
303             if (cooldownEnabled) {
304                 if (from != address(this) && to != address(this) && from != address(uniswapV2Router) && to != address(uniswapV2Router)) {
305                     require(_msgSender() == address(uniswapV2Router) || _msgSender() == uniswapV2Pair,"ERR: Uniswap only");
306                 }
307             }
308             require(amount <= _maxTxAmount);
309             require(!bots[from] && !bots[to]);
310             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
311                 require(cooldown[to] < block.timestamp);
312                 cooldown[to] = block.timestamp + (30 seconds);
313             }
314             uint256 contractTokenBalance = balanceOf(address(this));
315             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
316                 swapTokensForEth(contractTokenBalance);
317                 uint256 contractETHBalance = address(this).balance;
318                 if(contractETHBalance > 0) {
319                     sendETHToFee(address(this).balance);
320                 }
321             }
322         }
323         bool takeFee = true;
324 
325         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
326             takeFee = false;
327         }
328 		
329         _tokenTransfer(from,to,amount,takeFee);
330     }
331 
332     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
333         address[] memory path = new address[](2);
334         path[0] = address(this);
335         path[1] = uniswapV2Router.WETH();
336         _approve(address(this), address(uniswapV2Router), tokenAmount);
337         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
338             tokenAmount,
339             0,
340             path,
341             address(this),
342             block.timestamp
343         );
344     }
345         
346     function sendETHToFee(uint256 amount) private {
347         _FeeAddress.transfer(amount.div(2));
348         _marketingWalletAddress.transfer(amount.div(2));
349     }
350     
351     function manualswap() external {
352         require(_msgSender() == _FeeAddress);
353         uint256 contractBalance = balanceOf(address(this));
354         swapTokensForEth(contractBalance);
355     }
356     
357     function manualsend() external {
358         require(_msgSender() == _FeeAddress);
359         uint256 contractETHBalance = address(this).balance;
360         sendETHToFee(contractETHBalance);
361     }
362         
363     function openTrading() external onlyOwner() {
364         require(!tradingOpen,"trading is already open");
365         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
366         uniswapV2Router = _uniswapV2Router;
367         _approve(address(this), address(uniswapV2Router), _tTotal);
368         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
369         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
370         swapEnabled = true;
371         cooldownEnabled = true;
372         _maxTxAmount = 4250000000 * 10**9;
373         tradingOpen = true;
374         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
375     }
376     
377     function setBots(address[] memory bots_) public onlyOwner {
378         for (uint i = 0; i < bots_.length; i++) {
379             bots[bots_[i]] = true;
380         }
381     }
382     
383     function delBot(address notbot) public onlyOwner {
384         bots[notbot] = false;
385     }
386         
387     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
388         if(!takeFee)
389             removeAllFee();
390         if (_isExcluded[sender] && !_isExcluded[recipient]) {
391             _transferFromExcluded(sender, recipient, amount);
392         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
393             _transferToExcluded(sender, recipient, amount);
394         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
395             _transferBothExcluded(sender, recipient, amount);
396         } else {
397             _transferStandard(sender, recipient, amount);
398         }
399         if(!takeFee)
400             restoreAllFee();
401     }
402 
403     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
404         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
405         _rOwned[sender] = _rOwned[sender].sub(rAmount);
406         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
407         _takeTeam(tTeam); 
408         _reflectFee(rFee, tFee);
409         emit Transfer(sender, recipient, tTransferAmount);
410     }
411 
412     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
413         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
414         _rOwned[sender] = _rOwned[sender].sub(rAmount);
415         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
416         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
417         _takeTeam(tTeam);           
418         _reflectFee(rFee, tFee);
419         emit Transfer(sender, recipient, tTransferAmount);
420     }
421 
422     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
423         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
424         _tOwned[sender] = _tOwned[sender].sub(tAmount);
425         _rOwned[sender] = _rOwned[sender].sub(rAmount);
426         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
427         _takeTeam(tTeam);   
428         _reflectFee(rFee, tFee);
429         emit Transfer(sender, recipient, tTransferAmount);
430     }
431 
432     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
433         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
434         _tOwned[sender] = _tOwned[sender].sub(tAmount);
435         _rOwned[sender] = _rOwned[sender].sub(rAmount);
436         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
437         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
438         _takeTeam(tTeam);         
439         _reflectFee(rFee, tFee);
440         emit Transfer(sender, recipient, tTransferAmount);
441     }
442 
443     function _takeTeam(uint256 tTeam) private {
444         uint256 currentRate =  _getRate();
445         uint256 rTeam = tTeam.mul(currentRate);
446         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
447         if(_isExcluded[address(this)])
448             _tOwned[address(this)] = _tOwned[address(this)].add(tTeam);
449     }
450 
451     function _reflectFee(uint256 rFee, uint256 tFee) private {
452         _rTotal = _rTotal.sub(rFee);
453         _tFeeTotal = _tFeeTotal.add(tFee);
454     }
455 
456     receive() external payable {}
457 
458     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
459         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _taxFee, _teamFee);
460         uint256 currentRate =  _getRate();
461         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
462         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
463     }
464 
465     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
466         uint256 tFee = tAmount.mul(taxFee).div(100);
467         uint256 tTeam = tAmount.mul(TeamFee).div(100);
468         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
469         return (tTransferAmount, tFee, tTeam);
470     }
471 
472     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
473         uint256 rAmount = tAmount.mul(currentRate);
474         uint256 rFee = tFee.mul(currentRate);
475         uint256 rTeam = tTeam.mul(currentRate);
476         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
477         return (rAmount, rTransferAmount, rFee);
478     }
479 
480     function _getRate() private view returns(uint256) {
481         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
482         return rSupply.div(tSupply);
483     }
484 
485     function _getCurrentSupply() private view returns(uint256, uint256) {
486         uint256 rSupply = _rTotal;
487         uint256 tSupply = _tTotal;      
488         for (uint256 i = 0; i < _excluded.length; i++) {
489             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
490             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
491             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
492         }
493         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
494         return (rSupply, tSupply);
495     }
496         
497     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
498         require(maxTxPercent > 0, "Amount must be greater than 0");
499         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
500         emit MaxTxAmountUpdated(_maxTxAmount);
501     }
502 }