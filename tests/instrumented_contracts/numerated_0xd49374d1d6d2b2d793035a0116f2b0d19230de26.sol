1 /*
2  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------. 
3 | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
4 | |   ______     | || |     _____    | || |    _______   | || |  ____  ____  | || | _____  _____ | || |  _________   | || |     _____    | |
5 | |  |_   _ \    | || |    |_   _|   | || |   /  ___  |  | || | |_   ||   _| | || ||_   _||_   _|| || | |_   ___  |  | || |    |_   _|   | |
6 | |    | |_) |   | || |      | |     | || |  |  (__ \_|  | || |   | |__| |   | || |  | |    | |  | || |   | |_  \_|  | || |      | |     | |
7 | |    |  __'.   | || |      | |     | || |   '.___`-.   | || |   |  __  |   | || |  | '    ' |  | || |   |  _|      | || |      | |     | |
8 | |   _| |__) |  | || |     _| |_    | || |  |`\____) |  | || |  _| |  | |_  | || |   \ `--' /   | || |  _| |_       | || |     _| |_    | |
9 | |  |_______/   | || |    |_____|   | || |  |_______.'  | || | |____||____| | || |    `.__.'    | || | |_____|      | || |    |_____|   | |
10 | |              | || |              | || |              | || |              | || |              | || |              | || |              | |
11 | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
12  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 
13 */
14 /* SPDX-License-Identifier: Unlicensed */
15 pragma solidity ^0.8.6;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Team(address indexed from, address indexed to, uint256 value);
32     event Charity(address indexed from, address indexed to, uint256 value);
33     event Burn(address indexed from, address indexed to, uint256 value);
34     event DistributedFee(address indexed from, string msg, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 library SafeMath {
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61         return c;
62     }
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         return div(a, b, "SafeMath: division by zero");
66     }
67 
68     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b > 0, errorMessage);
70         uint256 c = a / b;
71         return c;
72     }
73 }
74 
75 contract Ownable is Context {
76     address private _owner;
77     address private _previousOwner;
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     constructor() {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99 }
100 
101 interface IUniswapV2Factory {
102     function createPair(address tokenA, address tokenB) external returns (address pair);
103 }
104 
105 interface IUniswapV2Router02 {
106     function swapExactTokensForETHSupportingFeeOnTransferTokens(
107         uint256 amountIn,
108         uint256 amountOutMin,
109         address[] calldata path,
110         address to,
111         uint256 deadline
112     ) external;
113     function factory() external pure returns (address);
114     function WETH() external pure returns (address);
115     function addLiquidityETH(
116         address token,
117         uint256 amountTokenDesired,
118         uint256 amountTokenMin,
119         uint256 amountETHMin,
120         address to,
121         uint256 deadline
122     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
123 }
124 
125 contract BishuFinance is Context, IERC20, Ownable {
126     using SafeMath for uint256;
127     string private constant _name = unicode"Bishu Finance";
128     string private constant _symbol = "BishuFi";
129     uint8 private constant _decimals = 9;
130     mapping(address => uint256) private _rOwned;
131     mapping(address => uint256) private _tOwned;
132     mapping(address => mapping(address => uint256)) private _allowances;
133     mapping(address => bool) public _isExcludedFromFee;
134     uint256 private constant MAX = ~uint256(0);
135     uint256 private constant _tTotal = 1000000000000 * 10**9;
136     uint256 private _rTotal = (MAX - (MAX % _tTotal));
137     uint256 private _tFeeTotal;
138     uint256 private _taxFee = 2;
139     uint256 private _teamFee = 2;
140     // 0.5% fee will be calculated later, number 1 is set because variable cannot store floating point
141     uint256 private _charityFee = 1;
142     // 0.5% fee will be calculated later, number 1 is set because variable cannot store floating point
143     uint256 private _burnFee = 1;
144     mapping(address => bool) private bots;
145     mapping(address => uint256) public buycooldown;
146     mapping(address => uint256) public sellcooldown;
147     mapping(address => uint256) public firstsell;
148     mapping(address => uint256) public sellnumber;
149     // made public for transparency
150     address payable public _teamAddress;
151     address payable public _charityAddress;
152     address public _routerAddress;
153     address payable public _burnAddress = payable(0x000000000000000000000000000000000000dEaD);
154     //
155     IUniswapV2Router02 private uniswapV2Router;
156     address private uniswapV2Pair;
157     bool public tradingOpen = false;
158     bool public liquidityAdded = false;
159     bool private inSwap = false;
160     bool public swapEnabled = false;
161     bool public cooldownEnabled = false;
162     uint256 public _maxTxAmount = _tTotal;
163     event MaxTxAmountUpdated(uint256 _maxTxAmount);
164     modifier lockTheSwap {
165         inSwap = true;
166         _;
167         inSwap = false;
168     }
169     constructor(address payable addr1, address payable addr2, address addr3) {
170         _teamAddress = addr1;
171         _charityAddress = addr2;
172         _routerAddress = addr3;
173         _rOwned[_msgSender()] = _rTotal;
174         _isExcludedFromFee[owner()] = true;
175         _isExcludedFromFee[address(this)] = true;
176         _isExcludedFromFee[_teamAddress] = true;
177         _isExcludedFromFee[_charityAddress] = true;
178         _isExcludedFromFee[_burnAddress] = true;
179         emit Transfer(address(0), _msgSender(), _tTotal);
180     }
181 
182     function name() public pure returns (string memory) {
183         return _name;
184     }
185 
186     function symbol() public pure returns (string memory) {
187         return _symbol;
188     }
189 
190     function decimals() public pure returns (uint8) {
191         return _decimals;
192     }
193 
194     function totalSupply() public pure override returns (uint256) {
195         return _tTotal;
196     }
197 
198     function balanceOf(address account) public view override returns (uint256) {
199         return tokenFromReflection(_rOwned[account]);
200     }
201 
202     function transfer(address recipient, uint256 amount) public override returns (bool) {
203         _transfer(_msgSender(), recipient, amount);
204         return true;
205     }
206 
207     function allowance(address owner, address spender) public view override returns (uint256) {
208         return _allowances[owner][spender];
209     }
210 
211     function approve(address spender, uint256 amount) public override returns (bool) {
212         _approve(_msgSender(), spender, amount);
213         return true;
214     }
215 
216     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
217         _transfer(sender, recipient, amount);
218         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
219         return true;
220     }
221 
222     function setCooldownEnabled(bool onoff) external onlyOwner() {
223         cooldownEnabled = onoff;
224     }    
225 
226     function setIsExcludedFromFee(address _address,bool _isExcluded) external onlyOwner() {
227         _isExcludedFromFee[_address] = _isExcluded;
228     }    
229 
230     function setTeamAddress(address payable _address) external onlyOwner() {
231         _teamAddress = _address;
232     }
233 
234     function setCharityAddress(address payable _address) external onlyOwner() {
235         _charityAddress = _address;
236     }
237 
238     function setRouterAddress(address _address) external onlyOwner() {
239         _routerAddress = _address;
240     }
241 
242     function tokenFromReflection(uint256 rAmount) private view returns (uint256) {
243         require(rAmount <= _rTotal,"Amount must be less than total reflections");
244         uint256 currentRate = _getRate();
245         return rAmount.div(currentRate);
246     }
247 
248     function removeAllFee() private {
249         if (_taxFee == 0 && _teamFee == 0) return;
250         _taxFee = 0;
251         _teamFee = 0;
252         _charityFee = 0;
253         _burnFee = 0;
254     }
255 
256     function restoreAllFee() private {
257         _taxFee = 2;
258         _teamFee = 2;
259         // 0.5% fee will be calculated later, number 1 is set because variable cannot store floating point
260         _charityFee = 1;
261         // 0.5% fee will be calculated later, number 1 is set because variable cannot store floating point
262         _burnFee = 1;
263     }
264 
265     function setRemoveAllFee() external onlyOwner {
266         if (_taxFee == 0 && _teamFee == 0) return;
267         _taxFee = 0;
268         _teamFee = 0;
269         _charityFee = 0;
270         _burnFee = 0;
271     }
272 
273     function setRestoreAllFee() external onlyOwner {
274         _taxFee = 2;
275         _teamFee = 2;
276         // 0.5% fee will be calculated later, number 1 is set because variable cannot store floating point
277         _charityFee = 1;
278         // 0.5% fee will be calculated later, number 1 is set because variable cannot store floating point
279         _burnFee = 1;
280     }
281     
282     function setFee(uint256 multiplier) private {
283         if (multiplier == 0) {
284             uint256 tfeeWhole = 3;
285             _taxFee = tfeeWhole;
286         }
287         else if (multiplier == 1) {
288             uint256 tfeeWhole = 6;
289             _taxFee = tfeeWhole;
290 
291         }
292         else if (multiplier == 2) {
293             uint256 tfeeWhole = 17;
294             _taxFee = tfeeWhole;
295 
296         }
297         else if (multiplier == 3) {
298             uint256 tfeeWhole = 24;
299             _taxFee = tfeeWhole;
300 
301         }
302     }
303 
304     function _approve(address owner, address spender, uint256 amount) private {
305         require(owner != address(0), "ERC20: approve from the zero address");
306         require(spender != address(0), "ERC20: approve to the zero address");
307         _allowances[owner][spender] = amount;
308         emit Approval(owner, spender, amount);
309     }
310 
311     function _transfer(address from, address to, uint256 amount) private {
312         require(from != address(0), "ERC20: transfer from the zero address");
313         require(to != address(0), "ERC20: transfer to the zero address");
314         require(amount > 0, "Transfer amount must be greater than zero");
315         bool takeFee = false;
316 
317         if (from != owner() && to != owner()) {
318             require(!bots[from] && !bots[to], "You are a bot!");
319             
320             // cooldown buy handler
321             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to] && cooldownEnabled) {
322                 require(tradingOpen, "Trading is not open!");
323                 require(amount <= _maxTxAmount, "Amount larger than max tx amount!");
324                 require(buycooldown[to] < block.timestamp, "Wait for buy cooldown!");
325                 buycooldown[to] = block.timestamp + (30 seconds);
326                 takeFee = true;
327             }
328 
329             // sell handler
330             if (!inSwap && to == uniswapV2Pair && from != address(uniswapV2Router) && swapEnabled) {
331                 require(amount <= balanceOf(uniswapV2Pair).mul(3).div(100) && amount <= _maxTxAmount, "Slippage is over 2.9% or over MaxTxAmount!");
332                 require(sellcooldown[from] < block.timestamp, "Wait for sell cooldown!");
333                 if(firstsell[from] + (1 days) < block.timestamp){
334                     sellnumber[from] = 0;
335                 }
336                 if (sellnumber[from] == 0) {
337                     firstsell[from] = block.timestamp;
338                     sellcooldown[from] = block.timestamp + (1 hours);
339                 }
340                 else if (sellnumber[from] == 1) {
341                     sellcooldown[from] = block.timestamp + (2 hours);
342                 }
343                 else if (sellnumber[from] == 2) {
344                     sellcooldown[from] = block.timestamp + (6 hours);
345                 }
346                 else if (sellnumber[from] == 3) {
347                     sellcooldown[from] = firstsell[from] + (1 days);
348                 }
349                 setFee(sellnumber[from]);
350                 sellnumber[from]++;
351                 takeFee = true;
352             }
353 
354             // block transfer if sell cooldown
355             if (to != uniswapV2Pair) {
356                require(sellcooldown[from] < block.timestamp, "Wait for sell cooldown!"); 
357             }
358         }
359         
360         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
361             takeFee = false;
362         }
363 
364         _tokenTransfer(from, to, amount, takeFee);
365         restoreAllFee();
366     }
367 
368     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
369         address[] memory path = new address[](2);
370         path[0] = address(this);
371         path[1] = uniswapV2Router.WETH();
372         _approve(address(this), address(uniswapV2Router), tokenAmount);
373         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
374     }
375 
376     function sendETHToFee(uint256 amount) private {
377         _teamAddress.transfer(amount.div(2));
378         _charityAddress.transfer(amount.div(2));
379     }
380     
381     function openTrading() public onlyOwner {
382         require(liquidityAdded);
383         tradingOpen = true;
384     }
385 
386     function addLiquidity() external onlyOwner() {
387         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(_routerAddress);
388         uniswapV2Router = _uniswapV2Router;
389         _approve(address(this), address(uniswapV2Router), _tTotal);
390         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
391         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
392         swapEnabled = true;
393         cooldownEnabled = true;
394         liquidityAdded = true;
395         _maxTxAmount = 3000000000 * 10**9;
396         IERC20(uniswapV2Pair).approve(address(uniswapV2Router),type(uint256).max);
397     }
398 
399     function manualswap() external onlyOwner {
400         uint256 contractBalance = balanceOf(address(this));
401         swapTokensForEth(contractBalance);
402     }
403 
404     function manualsend() external onlyOwner {
405         uint256 contractETHBalance = address(this).balance;
406         sendETHToFee(contractETHBalance);
407     }
408 
409     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
410         if (!takeFee) removeAllFee();
411         _transferStandard(sender, recipient, amount);
412         if (!takeFee) restoreAllFee();
413     }
414 
415     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
416         // moved fuction above to reduce stack
417         // _getValues //
418             // _getTValues
419             uint256 tFee = tAmount.mul(_taxFee).div(100);
420             uint256 tTeam = tAmount.mul(_teamFee).div(100);
421             // 0.5% fee by dividing by 200
422             uint256 tCharity = tAmount.mul(_charityFee).div(200);
423             uint256 tBurn = tAmount.mul(_burnFee).div(200);
424             //
425             uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam).sub(tCharity).sub(tBurn);
426             // _getRValues
427             uint256 currentRate = _getRate();
428             uint256 rAmount = tAmount.mul(currentRate);
429             uint256 rFee = tFee.mul(currentRate);
430             uint256 rTeam = tTeam.mul(currentRate);
431             uint256 rCharity = tCharity.mul(currentRate);
432             uint256 rBurn = tBurn.mul(currentRate);
433             uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam).sub(rCharity).sub(rBurn);
434         //
435         _calculateReflectTransfer(sender,recipient,rAmount,rTransferAmount);
436         _takeTeam(tTeam);
437         _takeCharity(tCharity);
438         _takeBurn(tBurn);
439         _reflectFee(rFee, tFee);
440         emit Transfer(sender, recipient, tTransferAmount);
441         emit Team(sender, _teamAddress, tTeam);
442         emit Charity(sender, _charityAddress, tCharity);
443         emit DistributedFee(sender, "Fee split between all holders!", tFee);
444         emit Burn(sender, _burnAddress, tBurn);
445     }
446 
447     function _takeTeam(uint256 tTeam) private {
448         uint256 currentRate = _getRate();
449         uint256 rTeam = tTeam.mul(currentRate);
450         _rOwned[_teamAddress] = _rOwned[_teamAddress].add(rTeam);
451     }
452     // added charity
453     function _takeCharity(uint256 tCharity) private {
454         uint256 currentRate = _getRate();
455         uint256 rCharity = tCharity.mul(currentRate);
456         _rOwned[_charityAddress] = _rOwned[_charityAddress].add(rCharity);
457     }
458     // added burn
459     function _takeBurn(uint256 tBurn) private {
460         uint256 currentRate = _getRate();
461         uint256 rBurn = tBurn.mul(currentRate);
462         _rOwned[_burnAddress] = _rOwned[_burnAddress].add(rBurn);
463     }
464 
465     function _reflectFee(uint256 rFee, uint256 tFee) private {
466         _rTotal = _rTotal.sub(rFee);
467         _tFeeTotal = _tFeeTotal.add(tFee);
468     }
469 
470     // added to reduce stack
471     function _calculateReflectTransfer(address sender, address recipient, uint256 rAmount, uint256 rTransferAmount) private {
472         
473        _rOwned[sender] = _rOwned[sender].sub(rAmount);
474        _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
475     }
476 
477     // allow contract to receive deposits
478     receive() external payable {}
479 
480     function _getRate() private view returns (uint256) {
481         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
482         return rSupply.div(tSupply);
483     }
484 
485     function _getCurrentSupply() private view returns (uint256, uint256) {
486         uint256 rSupply = _rTotal;
487         uint256 tSupply = _tTotal;
488         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
489         return (rSupply, tSupply);
490     }
491 
492     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
493         require(maxTxPercent > 0, "Amount must be greater than 0");
494         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
495         emit MaxTxAmountUpdated(_maxTxAmount);
496     }
497 }