1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.7.0 <0.8.0;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address) {
6         return msg.sender;
7     }
8 }
9 
10 interface IERC20 {
11     function totalSupply() external view returns (uint256);
12     function balanceOf(address account) external view returns (uint256);
13     function transfer(address recipient, uint256 amount) external returns (bool);
14     function allowance(address owner, address spender) external view returns (uint256);
15     function approve(address spender, uint256 amount) external returns (bool);
16     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
17     event Transfer(address indexed from, address indexed to, uint256 value);
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 library SafeMath {
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25         return c;
26     }
27 
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31 
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35         return c;
36     }
37 
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44         return c;
45     }
46 
47     function div(uint256 a, uint256 b) internal pure returns (uint256) {
48         return div(a, b, "SafeMath: division by zero");
49     }
50 
51     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b > 0, errorMessage);
53         uint256 c = a / b;
54         return c;
55     }
56 }
57 
58 contract Ownable is Context {
59     address private _owner;
60     address private _previousOwner;
61     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
62 
63     constructor() {
64         address msgSender = _msgSender();
65         _owner = msgSender;
66         emit OwnershipTransferred(address(0), msgSender);
67     }
68 
69     function owner() public view returns (address) {
70         return _owner;
71     }
72 
73     modifier onlyOwner() {
74         require(_owner == _msgSender(), "Ownable: caller is not the owner");
75         _;
76     }
77 
78     function renounceOwnership() public virtual onlyOwner {
79         emit OwnershipTransferred(_owner, address(0));
80         _owner = address(0);
81     }
82 }
83 
84 interface IUniswapV2Factory {
85     function createPair(address tokenA, address tokenB) external returns (address pair);
86 }
87 
88 interface IUniswapV2Router02 {
89     function swapExactETHForTokensSupportingFeeOnTransferTokens(
90         uint amountOutMin,
91         address[] calldata path,
92         address to,
93         uint deadline
94     ) external payable;
95     function swapExactTokensForETHSupportingFeeOnTransferTokens(
96         uint256 amountIn,
97         uint256 amountOutMin,
98         address[] calldata path,
99         address to,
100         uint256 deadline
101     ) external;
102     function factory() external pure returns (address);
103     function WETH() external pure returns (address);
104     function addLiquidityETH(
105         address token,
106         uint256 amountTokenDesired,
107         uint256 amountTokenMin,
108         uint256 amountETHMin,
109         address to,
110         uint256 deadline
111     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
112 }
113 
114 contract KYUBIWORLD is Context, IERC20, Ownable {
115     using SafeMath for uint256;
116     string private constant _name = unicode"Kyūbi World";
117     string private constant _symbol = unicode"Kyūbi";
118     uint8 private constant _decimals = 9;
119 
120     mapping(address => uint256) private _rOwned;
121     mapping(address => uint256) private _tOwned;    
122     uint256 private constant MAX = ~uint256(0);
123     uint256 private _tTotal = 33000000000000 * 10**9;
124     uint256 private _rTotal = (MAX - (MAX % _tTotal));
125     uint256 private _tFeeTotal;
126     uint256 public _kyubiBurned;
127 
128     mapping(address => mapping(address => uint256)) private _allowances;
129     mapping(address => bool) private _isExcludedFromFee;
130 
131     mapping(address => uint256) private buycooldown;
132     mapping(address => uint256) private sellcooldown;
133     mapping(address => uint256) private firstsell;
134     mapping(address => uint256) private sellnumber;
135     
136     address private eViral = 0x7CeC018CEEF82339ee583Fd95446334f2685d24f; 
137     address private burnAddress = 0x000000000000000000000000000000000000dEaD;
138     address payable private _teamAddress;
139     address payable private _marketingFunds;
140     address payable private _developmentFunds1;
141     address payable private _developmentFunds2;
142     IUniswapV2Router02 private uniswapV2Router;
143     address public uniswapV2Pair;
144     
145     bool public tradeAllowed = false;
146     bool private liquidityAdded = false;
147     bool private inSwap = false;
148     bool public swapEnabled = false;
149     
150     uint256 private _maxTxAmount = _tTotal;     
151     uint256 private _reflection = 5;
152     uint256 private _teamFee = 7;
153     uint256 private _kyubiBurn = 5;
154 
155     event MaxTxAmountUpdated(uint256 _maxTxAmount);
156     modifier lockTheSwap {
157         inSwap = true;
158         _;
159         inSwap = false;
160     }
161     constructor(address payable addr1, address payable addr2, address payable addr3, address payable addr4) {
162         _teamAddress = addr1;
163         _marketingFunds = addr2;
164         _developmentFunds1 = addr3;
165         _developmentFunds2 = addr4;
166         _rOwned[_msgSender()] = _rTotal;
167         _isExcludedFromFee[owner()] = true;
168         _isExcludedFromFee[address(this)] = true;
169         _isExcludedFromFee[_teamAddress] = true;
170         _isExcludedFromFee[_marketingFunds] = true;
171         _isExcludedFromFee[_developmentFunds1] = true;
172         _isExcludedFromFee[_developmentFunds2] = true;
173         emit Transfer(address(0), _msgSender(), _tTotal);
174     }
175     
176     function name() public pure returns (string memory) {
177         return _name;
178     }
179 
180     function symbol() public pure returns (string memory) {
181         return _symbol;
182     }
183 
184     function decimals() public pure returns (uint8) {
185         return _decimals;
186     }
187 
188     function totalSupply() public view override returns (uint256) {
189         return _tTotal;
190     }
191 
192     function balanceOf(address account) public view override returns (uint256) {
193         return tokenFromReflection(_rOwned[account]);
194     }
195 
196     function transfer(address recipient, uint256 amount) public override returns (bool) {
197         _transfer(_msgSender(), recipient, amount);
198         return true;
199     }
200 
201     function allowance(address owner, address spender) public view override returns (uint256) {
202         return _allowances[owner][spender];
203     }
204 
205     function approve(address spender, uint256 amount) public override returns (bool) {
206         _approve(_msgSender(), spender, amount);
207         return true;
208     }
209 
210     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
211         _transfer(sender, recipient, amount);
212         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
213         return true;
214     }
215 
216     function releaseKyubi() public onlyOwner {
217         require(liquidityAdded);
218         tradeAllowed = true;
219     }
220     
221     
222     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
223         require(maxTxPercent > 0, "Amount must be greater than 0");
224         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
225         emit MaxTxAmountUpdated(_maxTxAmount);
226     }
227 
228     function addLiquidity() external onlyOwner() {
229         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
230         uniswapV2Router = _uniswapV2Router;
231         _approve(address(this), address(uniswapV2Router), _tTotal);
232         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
233         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
234         swapEnabled = true;
235         liquidityAdded = true;
236         _maxTxAmount = 99000000000 * 10**9;
237         IERC20(uniswapV2Pair).approve(address(uniswapV2Router),type(uint256).max);
238     }
239 
240     function manualswap() external onlyOwner() {
241         uint256 contractBalance = balanceOf(address(this));
242         swapTokensForEth(contractBalance);
243     }
244 
245     function manualsend() external onlyOwner() {
246         uint256 contractETHBalance = address(this).balance;
247         sendETHToFee(contractETHBalance);
248     }
249 
250     function tokenFromReflection(uint256 rAmount) private view returns (uint256) {
251         require(rAmount <= _rTotal,"Amount must be less than total reflections");
252         uint256 currentRate = _getRate();
253         return rAmount.div(currentRate);
254     }
255 
256     function _approve(address owner, address spender, uint256 amount) private {
257         require(owner != address(0), "ERC20: approve from the zero address");
258         require(spender != address(0), "ERC20: approve to the zero address");
259         _allowances[owner][spender] = amount;
260         emit Approval(owner, spender, amount);
261     }
262 
263     function _transfer(address from, address to, uint256 amount) private {
264         require(from != address(0), "ERC20: transfer from the zero address");
265         require(to != address(0), "ERC20: transfer to the zero address");
266         require(amount > 0, "Transfer amount must be greater than zero");
267 
268         if (from != owner() && to != owner()) {
269             
270             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
271                 require(tradeAllowed);
272                 require(buycooldown[to] < block.timestamp);
273                 uint walletBalance = balanceOf(address(to));
274                 require(amount.add(walletBalance) <= _tTotal.div(100));
275                 require(amount <= _maxTxAmount);
276                 buycooldown[to] = block.timestamp + (45 seconds);
277                 _teamFee = 7;
278                 _reflection = 3;
279                 _kyubiBurn = 0;
280                 uint contractETHBalance = address(this).balance;
281                 if (contractETHBalance > 0) {
282                     swapETHForEViral(address(this).balance);
283                 }
284                 
285             }
286             uint256 contractTokenBalance = balanceOf(address(this));
287             if (!inSwap && from != uniswapV2Pair && swapEnabled && !_isExcludedFromFee[to] && !_isExcludedFromFee[from]) {
288                 require(amount <= balanceOf(uniswapV2Pair).mul(33).div(1000));
289                 require(sellcooldown[from] < block.timestamp);
290                 if(firstsell[from] + (1 days) < block.timestamp){
291                     sellnumber[from] = 0;
292                 }
293                 if (sellnumber[from] == 0) {
294                     sellnumber[from]++;
295                     firstsell[from] = block.timestamp;
296                     sellcooldown[from] = block.timestamp + (1 hours);
297                 }
298                 else if (sellnumber[from] == 1) {
299                     sellnumber[from]++;
300                     sellcooldown[from] = block.timestamp + (3 hours);
301                 }
302                 else if (sellnumber[from] == 2) {
303                     sellnumber[from]++;
304                     sellcooldown[from] = firstsell[from] + (1 days);
305                 }
306                 uint initialBalance = address(this).balance;
307                 swapTokensForEth(contractTokenBalance);
308                 uint newBalance = address(this).balance;
309                 uint distributeETHBalance = newBalance.sub(initialBalance);
310                 if (distributeETHBalance > 0) {
311                     sendETHToFee(distributeETHBalance);
312                 }
313                 setFee(sellnumber[from]);
314             }
315         }
316         bool takeFee = true;
317         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
318             takeFee = false;
319             if ( to != uniswapV2Pair && to!= address(uniswapV2Router)) {
320                 takeFee = false;
321             }
322         }
323         _tokenTransfer(from, to, amount, takeFee);
324         restoreAllFee;
325     }
326     
327 
328     function removeAllFee() private {
329         if (_reflection == 0 && _teamFee == 0 && _kyubiBurn == 0) return;
330         _reflection = 0;
331         _teamFee = 0;
332         _kyubiBurn = 0;
333     }
334 
335     function restoreAllFee() private {
336         _reflection = 5;
337         _teamFee = 7;
338         _kyubiBurn = 5;
339     }
340     
341     function setFee(uint256 multiplier) private {
342         _reflection = _reflection.mul(multiplier);
343         _kyubiBurn = _kyubiBurn.mul(multiplier);
344         _teamFee = _teamFee.add(multiplier);       
345     }
346 
347     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
348         if (!takeFee) removeAllFee();
349         _transferStandard(sender, recipient, amount);
350         if (!takeFee) restoreAllFee();
351     }
352     function _transferStandard(address sender, address recipient, uint256 amount) private {
353         (uint256 tAmount, uint256 tBurn) = _kyubiTokenBurn(amount);
354         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount, tBurn);
355         _rOwned[sender] = _rOwned[sender].sub(rAmount);
356         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
357         _takeTeam(tTeam);
358         _reflectFee(rFee, tFee);
359         emit Transfer(sender, recipient, tTransferAmount);
360     }
361 
362     function _takeTeam(uint256 tTeam) private {
363         uint256 currentRate = _getRate();
364         uint256 rTeam = tTeam.mul(currentRate);
365         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
366     }
367 
368     function _kyubiTokenBurn(uint amount) private returns (uint, uint) {  
369         uint orgAmount = amount;
370         uint256 currentRate = _getRate();
371         uint256 tBurn = amount.mul(_kyubiBurn).div(100);
372         uint256 rBurn = tBurn.mul(currentRate);
373         _tTotal = _tTotal.sub(tBurn);
374         _rTotal = _rTotal.sub(rBurn);
375         _kyubiBurned = _kyubiBurned.add(tBurn);
376         return (orgAmount, tBurn);
377     }
378     
379     function _reflectFee(uint256 rFee, uint256 tFee) private {
380         _rTotal = _rTotal.sub(rFee);
381         _tFeeTotal = _tFeeTotal.add(tFee);
382     }
383 
384     function _getValues(uint256 tAmount, uint256 tBurn) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
385         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _reflection, _teamFee, tBurn);
386         uint256 currentRate = _getRate();
387         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
388         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
389     }
390 
391     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 teamFee, uint256 tBurn) private pure returns (uint256, uint256, uint256) {
392         uint256 tFee = tAmount.mul(taxFee).div(100);
393         uint256 tTeam = tAmount.mul(teamFee).div(100);
394         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam).sub(tBurn);
395         return (tTransferAmount, tFee, tTeam);
396     }
397 
398     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
399         uint256 rAmount = tAmount.mul(currentRate);
400         uint256 rFee = tFee.mul(currentRate);
401         uint256 rTeam = tTeam.mul(currentRate);
402         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
403         return (rAmount, rTransferAmount, rFee);
404     }
405 
406     function _getRate() private view returns (uint256) {
407         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
408         return rSupply.div(tSupply);
409     }
410 
411     function _getCurrentSupply() private view returns (uint256, uint256) {
412         uint256 rSupply = _rTotal;
413         uint256 tSupply = _tTotal;
414         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
415         return (rSupply, tSupply);
416     }
417 
418     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
419         address[] memory path = new address[](2);
420         path[0] = address(this);
421         path[1] = uniswapV2Router.WETH();
422         _approve(address(this), address(uniswapV2Router), tokenAmount);
423         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
424     }
425     
426      function swapETHForEViral(uint ethAmount) private {
427         address[] memory path = new address[](2);
428         path[0] = uniswapV2Router.WETH();
429         path[1] = address(eViral);
430 
431         _approve(address(this), address(uniswapV2Router), ethAmount);
432         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(ethAmount,path,address(burnAddress),block.timestamp);
433     }
434 
435     function sendETHToFee(uint256 amount) private {
436             uint oneEigth = amount.div(8);
437             _teamAddress.transfer(amount.div(16).mul(5));
438             _marketingFunds.transfer(oneEigth);
439             _developmentFunds1.transfer(oneEigth);
440             _developmentFunds2.transfer(oneEigth);
441     }
442 
443     receive() external payable {}
444 }