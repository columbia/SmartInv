1 /**
2 
3 🎭 MuskCult 🎭
4 
5 🆕New trend meets biggest trend of all time,
6  what do you think that means?🆕
7 
8 🎭Say Hello to the biggest gem launched in 2022,
9 We will use the over growing hype of 
10 Elon and connect it with our new Cult🎭
11 
12  - Contract will be renounced + Lp locked
13 
14 Tg: https://t.me/MuskCult
15 
16  - 1% BuyTax and 4% SellTax,Reserve for listings/ Development
17 
18  - 1% MaxBuy + 3% MaxWallet for whale protection for first 10-30 mins
19 
20  Milestones:
21 
22  - If MC hits 500k LP extended to 1 year
23 
24 
25 */
26 
27 pragma solidity ^0.8.7;
28 // SPDX-License-Identifier: UNLICENSED
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address) {
31         return msg.sender;
32     }
33 }
34 
35 interface IERC20 {
36     function totalSupply() external view returns (uint256);
37     function balanceOf(address account) external view returns (uint256);
38     function transfer(address recipient, uint256 amount) external returns (bool);
39     function allowance(address owner, address spender) external view returns (uint256);
40     function approve(address spender, uint256 amount) external returns (bool);
41     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
42     event Transfer(address indexed from, address indexed to, uint256 value);
43     event Approval(address indexed owner, address indexed spender, uint256 value);
44 }
45 
46 library SafeMath {
47     function add(uint256 a, uint256 b) internal pure returns (uint256) {
48         uint256 c = a + b;
49         require(c >= a, "SafeMath: addition overflow");
50         return c;
51     }
52 
53     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
54         return sub(a, b, "SafeMath: subtraction overflow");
55     }
56 
57     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b <= a, errorMessage);
59         uint256 c = a - b;
60         return c;
61     }
62 
63     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
64         if (a == 0) {
65             return 0;
66         }
67         uint256 c = a * b;
68         require(c / a == b, "SafeMath: multiplication overflow");
69         return c;
70     }
71 
72     function div(uint256 a, uint256 b) internal pure returns (uint256) {
73         return div(a, b, "SafeMath: division by zero");
74     }
75 
76     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
77         require(b > 0, errorMessage);
78         uint256 c = a / b;
79         return c;
80     }
81 
82 }
83 
84 contract Ownable is Context {
85     address private _owner;
86     address private _previousOwner;
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89     constructor () {
90         address msgSender = _msgSender();
91         _owner = msgSender;
92         emit OwnershipTransferred(address(0), msgSender);
93     }
94 
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     modifier onlyOwner() {
100         require(_owner == _msgSender(), "Ownable: caller is not the owner");
101         _;
102     }
103 
104     function renounceOwnership() public virtual onlyOwner {
105         emit OwnershipTransferred(_owner, address(0));
106         _owner = address(0);
107     }
108 
109 }  
110 
111 interface IUniswapV2Factory {
112     function createPair(address tokenA, address tokenB) external returns (address pair);
113 }
114 
115 interface IUniswapV2Router02 {
116     function swapExactTokensForETHSupportingFeeOnTransferTokens(
117         uint amountIn,
118         uint amountOutMin,
119         address[] calldata path,
120         address to,
121         uint deadline
122     ) external;
123     function factory() external pure returns (address);
124     function WETH() external pure returns (address);
125     function addLiquidityETH(
126         address token,
127         uint amountTokenDesired,
128         uint amountTokenMin,
129         uint amountETHMin,
130         address to,
131         uint deadline
132     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
133 }
134 
135 contract MuskCult is Context, IERC20, Ownable {
136     using SafeMath for uint256;
137     mapping (address => uint256) private _rOwned;
138     mapping (address => uint256) private _tOwned;
139     mapping (address => mapping (address => uint256)) private _allowances;
140     mapping (address => bool) private _isExcludedFromFee;
141     mapping (address => bool) private bots;
142     mapping (address => uint) private cooldown;
143     uint256 private constant MAX = ~uint256(0);
144     uint256 private constant _tTotal = 100000000000 * 10**9;
145     uint256 private _rTotal = (MAX - (MAX % _tTotal));
146     uint256 private _tFeeTotal;
147     
148     uint256 private _feeAddr1;
149     uint256 private _feeAddr2;
150     address payable private _feeAddrWallet;
151     
152     string private constant _name = "MuskCult";
153     string private constant _symbol = "MuskCult";
154     uint8 private constant _decimals = 9;
155     
156     IUniswapV2Router02 private uniswapV2Router;
157     address private uniswapV2Pair;
158     bool private tradingOpen;
159     bool private inSwap = false;
160     bool private swapEnabled = false;
161     bool private cooldownEnabled = false;
162     uint256 private _maxTxAmount = _tTotal;
163     uint256 private _maxWalletSize = _tTotal;
164     event MaxTxAmountUpdated(uint _maxTxAmount);
165     modifier lockTheSwap {
166         inSwap = true;
167         _;
168         inSwap = false;
169     }
170 
171     constructor () {
172         _feeAddrWallet = payable(0x4aAFC831084f7D3cfb381075c1F8c8139611334c);
173         _rOwned[_msgSender()] = _rTotal;
174         _isExcludedFromFee[owner()] = true;
175         _isExcludedFromFee[address(this)] = true;
176         _isExcludedFromFee[_feeAddrWallet] = true;
177         emit Transfer(address(0), _msgSender(), _tTotal);
178     }
179 
180     function name() public pure returns (string memory) {
181         return _name;
182     }
183 
184     function symbol() public pure returns (string memory) {
185         return _symbol;
186     }
187 
188     function decimals() public pure returns (uint8) {
189         return _decimals;
190     }
191 
192     function totalSupply() public pure override returns (uint256) {
193         return _tTotal;
194     }
195 
196     function balanceOf(address account) public view override returns (uint256) {
197         return tokenFromReflection(_rOwned[account]);
198     }
199 
200     function transfer(address recipient, uint256 amount) public override returns (bool) {
201         _transfer(_msgSender(), recipient, amount);
202         return true;
203     }
204 
205     function allowance(address owner, address spender) public view override returns (uint256) {
206         return _allowances[owner][spender];
207     }
208 
209     function approve(address spender, uint256 amount) public override returns (bool) {
210         _approve(_msgSender(), spender, amount);
211         return true;
212     }
213 
214     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
215         _transfer(sender, recipient, amount);
216         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
217         return true;
218     }
219 
220     function setCooldownEnabled(bool onoff) external onlyOwner() {
221         cooldownEnabled = onoff;
222     }
223 
224     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
225         require(rAmount <= _rTotal, "Amount must be less than total reflections");
226         uint256 currentRate =  _getRate();
227         return rAmount.div(currentRate);
228     }
229 
230     function _approve(address owner, address spender, uint256 amount) private {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236 
237     function _transfer(address from, address to, uint256 amount) private {
238         require(from != address(0), "ERC20: transfer from the zero address");
239         require(to != address(0), "ERC20: transfer to the zero address");
240         require(amount > 0, "Transfer amount must be greater than zero");
241         _feeAddr1 = 0;
242         _feeAddr2 = 1;
243         if (from != owner() && to != owner()) {
244             require(!bots[from] && !bots[to]);
245             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] && cooldownEnabled) {
246                 // Cooldown
247                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
248                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
249                 require(cooldown[to] < block.timestamp);
250                 cooldown[to] = block.timestamp + (30 seconds);
251             }
252             
253             
254             if (to == uniswapV2Pair && from != address(uniswapV2Router) && ! _isExcludedFromFee[from]) {
255                 _feeAddr1 = 0;
256                 _feeAddr2 = 4;
257             }
258             uint256 contractTokenBalance = balanceOf(address(this));
259             if (!inSwap && from != uniswapV2Pair && swapEnabled) {
260                 swapTokensForEth(contractTokenBalance);
261                 uint256 contractETHBalance = address(this).balance;
262                 if(contractETHBalance > 0) {
263                     sendETHToFee(address(this).balance);
264                 }
265             }
266         }
267 		
268         _tokenTransfer(from,to,amount);
269     }
270 
271     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
272         address[] memory path = new address[](2);
273         path[0] = address(this);
274         path[1] = uniswapV2Router.WETH();
275         _approve(address(this), address(uniswapV2Router), tokenAmount);
276         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
277             tokenAmount,
278             0,
279             path,
280             address(this),
281             block.timestamp
282         );
283     }
284 
285     function removeLimits() external onlyOwner{
286         _maxTxAmount = _tTotal;
287         _maxWalletSize = _tTotal;
288     }
289 
290     function changeMaxTxAmount(uint256 percentage) external onlyOwner{
291         require(percentage>0);
292         _maxTxAmount = _tTotal.mul(percentage).div(100);
293     }
294 
295     function changeMaxWalletSize(uint256 percentage) external onlyOwner{
296         require(percentage>0);
297         _maxWalletSize = _tTotal.mul(percentage).div(100);
298     }
299         
300     function sendETHToFee(uint256 amount) private {
301         _feeAddrWallet.transfer(amount);
302     }  
303 
304     function openTrading() external onlyOwner() {
305         require(!tradingOpen,"trading is already open");
306         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
307         uniswapV2Router = _uniswapV2Router;
308         _approve(address(this), address(uniswapV2Router), _tTotal);
309         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
310         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
311         swapEnabled = true;
312         cooldownEnabled = true;
313         _maxTxAmount = 1000000000 * 10**9;
314         _maxWalletSize = 3000000000 * 10**9;
315         tradingOpen = true;
316         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
317     }
318     
319     function nonosquare(address[] memory bots_) public onlyOwner {
320         for (uint i = 0; i < bots_.length; i++) {
321             bots[bots_[i]] = true;
322         }
323     }
324     
325     function delBot(address notbot) public onlyOwner {
326         bots[notbot] = false;
327     }
328         
329     function _tokenTransfer(address sender, address recipient, uint256 amount) private {
330         _transferStandard(sender, recipient, amount);
331     }
332 
333     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
334         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getValues(tAmount);
335         _rOwned[sender] = _rOwned[sender].sub(rAmount);
336         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount); 
337         _takeTeam(tTeam);
338         _reflectFee(rFee, tFee);
339         emit Transfer(sender, recipient, tTransferAmount);
340     }
341 
342     function _takeTeam(uint256 tTeam) private {
343         uint256 currentRate =  _getRate();
344         uint256 rTeam = tTeam.mul(currentRate);
345         _rOwned[address(this)] = _rOwned[address(this)].add(rTeam);
346     }
347 
348     function _reflectFee(uint256 rFee, uint256 tFee) private {
349         _rTotal = _rTotal.sub(rFee);
350         _tFeeTotal = _tFeeTotal.add(tFee);
351     }
352 
353     receive() external payable {}
354     
355     function manualswap() external {
356         require(_msgSender() == _feeAddrWallet);
357         uint256 contractBalance = balanceOf(address(this));
358         swapTokensForEth(contractBalance);
359     }
360     
361     function manualsend() external {
362         require(_msgSender() == _feeAddrWallet);
363         uint256 contractETHBalance = address(this).balance;
364         sendETHToFee(contractETHBalance);
365     }
366     
367 
368     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
369         (uint256 tTransferAmount, uint256 tFee, uint256 tTeam) = _getTValues(tAmount, _feeAddr1, _feeAddr2);
370         uint256 currentRate =  _getRate();
371         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tTeam, currentRate);
372         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tTeam);
373     }
374 
375     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 TeamFee) private pure returns (uint256, uint256, uint256) {
376         uint256 tFee = tAmount.mul(taxFee).div(100);
377         uint256 tTeam = tAmount.mul(TeamFee).div(100);
378         uint256 tTransferAmount = tAmount.sub(tFee).sub(tTeam);
379         return (tTransferAmount, tFee, tTeam);
380     }
381 
382     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tTeam, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
383         uint256 rAmount = tAmount.mul(currentRate);
384         uint256 rFee = tFee.mul(currentRate);
385         uint256 rTeam = tTeam.mul(currentRate);
386         uint256 rTransferAmount = rAmount.sub(rFee).sub(rTeam);
387         return (rAmount, rTransferAmount, rFee);
388     }
389 
390 	function _getRate() private view returns(uint256) {
391         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
392         return rSupply.div(tSupply);
393     }
394 
395     function _getCurrentSupply() private view returns(uint256, uint256) {
396         uint256 rSupply = _rTotal;
397         uint256 tSupply = _tTotal;      
398         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
399         return (rSupply, tSupply);
400     }
401 }