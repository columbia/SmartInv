1 // https://twitter.com/TMNPBOT
2 //  https://tmnpbot.live
3 // t.me/TMNPerc
4 // SPDX-License-Identifier: Unlicensed
5 
6 pragma solidity ^0.8.7;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 
61 }
62 
63 contract Ownable is Context {
64     address private _owner;
65     address private _previousOwner;
66     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
67 
68     constructor () {
69         address msgSender = _msgSender();
70         _owner = msgSender;
71         emit OwnershipTransferred(address(0), msgSender);
72     }
73 
74     function owner() public view returns (address) {
75         return _owner;
76     }
77 
78     modifier onlyOwner() {
79         require(_owner == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     function transferOwnership(address _newOwner) public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, _newOwner);
85         _owner = _newOwner;
86         
87     }
88 
89     function renounceOwnership() public virtual onlyOwner {
90         emit OwnershipTransferred(_owner, address(0));
91         _owner = address(0);
92     }
93 
94 }  
95 
96 interface IUniswapV2Factory {
97     function createPair(address tokenA, address tokenB) external returns (address pair);
98 }
99 
100 interface IUniswapV2Router02 {
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint amountIn,
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external;
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110     function addLiquidityETH(
111         address token,
112         uint amountTokenDesired,
113         uint amountTokenMin,
114         uint amountETHMin,
115         address to,
116         uint deadline
117     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
118 }
119 
120 contract TMNP is Context, IERC20, Ownable {
121     using SafeMath for uint256;
122 
123     mapping (address => uint256) private _balOwned;
124     mapping (address => mapping (address => uint256)) private _allowances;
125 
126     mapping (address => bool) private _isOutFromFee;
127     mapping (address => bool) private isBlacklisted;
128 
129     uint256 private time;
130     uint256 private bTime;
131 
132     uint256 private _totalSupply = 5 * 10**6 * 10**18;
133 
134     struct TaxStructure {
135         uint256 totalPc;
136         uint256 pcMarketing;
137         uint256 pcCharity;
138         uint256 pcLP;
139     }
140     TaxStructure private sellTax = TaxStructure(70,50,10,10);
141     TaxStructure private buyTax = TaxStructure(200,180,10,10);
142     TaxStructure private ZERO = TaxStructure(0,0,0,0);
143     TaxStructure private initialTax = TaxStructure(990,990,0,0);
144     TaxStructure private initialSellTax = TaxStructure(600,600,0,0);
145 
146     string private constant _name = unicode"TEENAGE MUTANT NINJA PEPES";
147     string private constant _symbol = unicode"TMNP";
148     uint8 private constant _decimals = 18;
149 
150     uint256 private _maxTxAmount = _totalSupply.div(100);
151     uint256 private _maxWalletAmount = _totalSupply.div(50);
152     uint256 private liquidityParkedTokens = 0;
153     uint256 private marketingParkedTokens = 0;
154     uint256 private charityParkedTokens = 0;
155     uint256 private minBalance = _totalSupply.div(10000);
156 
157     address payable private _marketingWallet;
158     address payable private _charityWallet;
159 
160     IUniswapV2Router02 private uniswapV2Router;
161 
162     address private uniswapV2PairAddress;
163 
164     bool private tradingOpen;
165     bool private inSwap = false;
166     bool private swapEnabled = false;
167 
168     modifier lockTheSwap {
169         inSwap = true;
170         _;
171         inSwap = false;
172     }
173     constructor () payable {
174         _marketingWallet = payable(0x93D8ccD7738d9f4E7DCd5f514216cD2812Cc57Bc);
175         _charityWallet = payable(0x93D8ccD7738d9f4E7DCd5f514216cD2812Cc57Bc);
176         _balOwned[owner()] = _totalSupply;
177 
178         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
179         uniswapV2PairAddress = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
180 
181         _isOutFromFee[owner()] = true;
182         _isOutFromFee[address(this)] = true;
183         _isOutFromFee[uniswapV2PairAddress] = true;
184 
185 
186         emit Transfer(address(0),address(this),_totalSupply);
187     }
188 
189     function name() public pure returns (string memory) {
190         return _name;
191     }
192 
193     function symbol() public pure returns (string memory) {
194         return _symbol;
195     }
196 
197     function decimals() public pure returns (uint8) {
198         return _decimals;
199     }
200 
201     function totalSupply() public view override returns (uint256) {
202         return _totalSupply;
203     }
204 
205     function balanceOf(address account) public view override returns (uint256) {
206         return _balOwned[account];
207     }
208 
209     function transfer(address recipient, uint256 amount) public override returns (bool) {
210         _transfer(_msgSender(), recipient, amount);
211         return true;
212     }
213 
214     function allowance(address owner, address spender) public view override returns (uint256) {
215         return _allowances[owner][spender];
216     }
217 
218     function approve(address spender, uint256 amount) public override returns (bool) {
219         _approve(_msgSender(), spender, amount);
220         return true;
221     }
222 
223     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
224         _transfer(sender, recipient, amount);
225         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ROSAI: transfer amount exceeds allowance"));
226         return true;
227     }
228 
229   
230 
231     function updateBuyTax(uint256 _marketing,uint256 _charity,uint256 _lp) external onlyOwner {
232         buyTax.pcLP = _lp;
233         buyTax.pcMarketing = _marketing;
234         buyTax.pcCharity = _charity;
235         buyTax.totalPc = _marketing.add(_lp).add(_charity);
236         require(buyTax.totalPc < 100,"TMNP: Buy tax can not greater than 10%");
237     }
238     function updateSellTax(uint256 _marketing,uint256 _charity,uint256 _lp) external onlyOwner {
239         sellTax.pcLP = _lp;
240         sellTax.pcMarketing = _marketing;
241         sellTax.pcCharity = _charity;
242         sellTax.totalPc = _marketing.add(_lp).add(_charity);
243         require(sellTax.totalPc < 100,"TMNP: Sell tax can not greater than 10%");
244     }
245 
246     function updateLimits(uint256 maxTransactionPer,uint256 maxWaleltPer) external onlyOwner {
247         require(maxTransactionPer > 1 && maxWaleltPer > 1,"TMNP: Max wallet and max transction limits should be greater than 1%");
248         _maxTxAmount = _totalSupply.mul(maxTransactionPer).div(100);
249         _maxWalletAmount = _totalSupply.mul(maxWaleltPer).div(100);
250     }
251 
252     function removeLimits() external onlyOwner{
253         _maxTxAmount = _totalSupply;
254     }
255 
256 
257     function excludeFromFees(address[] calldata target) external onlyOwner{
258         for(uint i=0;i<target.length;i++)
259             _isOutFromFee[target[i]] = true;
260     }
261 
262    
263     function _approve(address owner, address spender, uint256 amount) private {
264         require(owner != address(0), "ROSAI: Approving from the zero address");
265         require(spender != address(0), "ROSAI: Approving to the zero address");
266         _allowances[owner][spender] = amount;
267         emit Approval(owner, spender, amount);
268     }
269 
270     function _transfer(address from, address to, uint256 amount) private {
271         require(from != address(0), "TMNP: Transfer from the zero address");
272         require(to != address(0), "TMNP: Transfer to the zero address");
273 
274         if (from != owner() && to != owner()) {
275             require(tradingOpen,"TMNP: trading != true");
276             require(!isBlacklisted[from] && !isBlacklisted[to]);
277 
278             TaxStructure storage _tax = ZERO;
279             if(!_isOutFromFee[to]){
280                 require((_balOwned[to] + amount) <= _maxWalletAmount,"TMNP: Max Wallet Limit");
281                 require(amount <= _maxTxAmount,"TMNP: Max TxAmount Limit");
282                 if (from == uniswapV2PairAddress && to != address(uniswapV2Router)){
283                     _tax = buyTax;
284                 }
285                 if(bTime > block.number){
286                     _tax = initialTax;
287                 }
288             }
289 
290             else if (to == uniswapV2PairAddress && from != address(uniswapV2Router) && ! _isOutFromFee[from]) {
291                 if(block.timestamp > time){
292                     _tax = sellTax;
293                 }else{
294                     _tax = initialSellTax;
295                 }
296             }
297             
298             
299             if (!inSwap && from != uniswapV2PairAddress && swapEnabled && !_isOutFromFee[from] && balanceOf(address(this)) > minBalance) {
300                     swapBack();
301             }
302 
303             if(_tax.totalPc>0){
304                 uint256 txTax = amount.mul(_tax.totalPc).div(1000);
305                 amount = amount.sub(txTax);
306                 liquidityParkedTokens = liquidityParkedTokens.add(txTax.mul(_tax.pcLP).div(_tax.totalPc));
307                 marketingParkedTokens = marketingParkedTokens.add(txTax.mul(_tax.pcMarketing).div(_tax.totalPc));
308                 charityParkedTokens = charityParkedTokens.add(txTax.mul(_tax.pcCharity).div(_tax.totalPc));
309                 _transferStandard(from,address(this),txTax);
310             }
311         }
312         		
313         _transferStandard(from,to,amount);
314     }
315 
316     function swapTokensForEth(uint256 tokenAmount) private {
317         address[] memory path = new address[](2);
318         path[0] = address(this);
319         path[1] = uniswapV2Router.WETH();
320         _approve(address(this), address(uniswapV2Router), tokenAmount);
321         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
322             tokenAmount,
323             0,
324             path,
325             address(this),
326             block.timestamp
327         );
328     }
329     
330 
331     function addLiquidity(uint256 tokenAmount,uint256 ethValue) private {
332         _approve(address(this),address(uniswapV2Router),tokenAmount);
333         uniswapV2Router.addLiquidityETH{value: ethValue}(address(this),tokenAmount,0,0,address(0xdEaD),block.timestamp);
334     }
335 
336     function swapBack() private lockTheSwap {
337         uint256 contractTokenBalance = balanceOf(address(this));
338         uint256 totalTokensToSwap = liquidityParkedTokens + marketingParkedTokens + charityParkedTokens;
339         bool success;
340 
341         if (contractTokenBalance == 0 || totalTokensToSwap == 0) {
342             return;
343         }
344 
345         if (contractTokenBalance > minBalance * 20) {
346             contractTokenBalance = minBalance * 20;
347         }
348 
349         // Halve the amount of liquidity tokens
350         uint256 liquidityTokens = (contractTokenBalance * liquidityParkedTokens) / totalTokensToSwap / 2;
351         uint256 amountToSwapForETH = contractTokenBalance.sub(liquidityTokens);
352 
353         uint256 initialETHBalance = address(this).balance;
354 
355         swapTokensForEth(amountToSwapForETH);
356 
357         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
358 
359         uint256 ethForMarketing = ethBalance.mul(marketingParkedTokens).div(totalTokensToSwap);
360 
361         uint256 ethForCharity = ethBalance.mul(charityParkedTokens).div(totalTokensToSwap);
362 
363         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForCharity;
364 
365         liquidityParkedTokens = 0;
366         marketingParkedTokens = 0;
367         charityParkedTokens = 0;
368 
369         (success, ) = address(_charityWallet).call{value: ethForCharity}("");
370 
371         if (liquidityTokens > 0 && ethForLiquidity > 0) {
372             addLiquidity(liquidityTokens, ethForLiquidity);
373         }
374 
375         (success, ) = address(_marketingWallet).call{
376             value: address(this).balance
377         }("");
378 
379     }
380     
381 
382     
383     function enableTrading() external onlyOwner {
384         require(!tradingOpen,"trading is already open");
385         swapEnabled = true;
386         tradingOpen = true;
387         time = block.timestamp + (10 minutes);
388         bTime = block.number + 2;
389     }
390     
391     function setBlacklist(address[] memory _isBlacklisted) public onlyOwner {
392         for (uint i = 0; i < _isBlacklisted.length; i++) {
393             isBlacklisted[_isBlacklisted[i]] = true;
394         }
395     }
396     
397     function removeBlacklist(address[] memory notbot) public onlyOwner {
398         for(uint i=0;i<notbot.length;i++){isBlacklisted[notbot[i]] = false;}
399     }
400 
401     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
402         _balOwned[sender] = _balOwned[sender].sub(tAmount);
403         _balOwned[recipient] = _balOwned[recipient].add(tAmount); 
404         emit Transfer(sender, recipient, tAmount);
405     }
406 
407     receive() external payable {}
408     
409     function manualSwap() external onlyOwner{
410         swapBack();
411     }
412 
413     function recoverTokens(address tokenAddress) external onlyOwner {
414         require(tokenAddress != uniswapV2PairAddress);
415         IERC20 _token = IERC20(tokenAddress);
416         _token.transfer(msg.sender,_token.balanceOf(address(this)));
417     }
418 
419 
420 }