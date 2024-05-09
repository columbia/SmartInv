1 /**
2 Website: https://hotbet.gg/
3 Telegram: https://t.me/hotbetgg
4 Twitter: https://twitter.com/hotbetgg
5 Whitepaper: https://hotbetgg.gitbook.io/whitepaper/
6 **/
7 
8 // SPDX-License-Identifier: UNLICENSED
9 
10 pragma solidity 0.8.21;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 
17     function _msgData() internal view virtual returns (bytes calldata) {
18         return msg.data;
19     }
20 }
21 
22 interface IERC20 {
23 
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 contract Ownable is Context {
35     address private _owner;
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37 
38     constructor () {
39         address msgSender = _msgSender();
40         _owner = msgSender;
41         emit OwnershipTransferred(address(0), msgSender);
42     }
43 
44     function owner() public view returns (address) {
45         return _owner;
46     }
47 
48     modifier onlyOwner() {
49         require(_owner == _msgSender(), "Ownable: caller is not the owner");
50         _;
51     }
52 
53     function renounceOwnership() public virtual onlyOwner {
54         emit OwnershipTransferred(_owner, address(0));
55         _owner = address(0);
56     }
57 
58 }
59 
60 interface ILpPair {
61     function mint(address to) external returns (uint liquidity);
62     function sync() external;
63 }
64 
65 interface IWETH {
66     function deposit() external payable;
67     function transfer(address to, uint value) external returns (bool);
68     function withdraw(uint) external;
69 }
70 
71 interface IUniswapV2Factory {
72     function createPair(address tokenA, address tokenB) external returns (address pair);
73 
74         function getPair(address tokenA, address tokenB) external view returns (address pair);
75 }
76 
77 interface IUniswapV2Router02 {
78     function swapExactTokensForETHSupportingFeeOnTransferTokens(
79         uint amountIn,
80         uint amountOutMin,
81         address[] calldata path,
82         address to,
83         uint deadline
84     ) external;
85     function factory() external pure returns (address);
86     function WETH() external pure returns (address);
87     function addLiquidityETH(
88         address token,
89         uint amountTokenDesired,
90         uint amountTokenMin,
91         uint amountETHMin,
92         address to,
93         uint deadline
94     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
95 }
96 
97 library SafeMath {
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a, "SafeMath: addition overflow");
101         return c;
102     }
103 
104     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
105         return sub(a, b, "SafeMath: subtraction overflow");
106     }
107 
108     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
109         require(b <= a, errorMessage);
110         uint256 c = a - b;
111         return c;
112     }
113 
114     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
115         if (a == 0) {
116             return 0;
117         }
118         uint256 c = a * b;
119         require(c / a == b, "SafeMath: multiplication overflow");
120         return c;
121     }
122 
123     function div(uint256 a, uint256 b) internal pure returns (uint256) {
124         return div(a, b, "SafeMath: division by zero");
125     }
126 
127     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
128         require(b > 0, errorMessage);
129         uint256 c = a / b;
130         return c;
131     }
132 
133 }
134 
135 contract Hotbet is Context, IERC20, Ownable {
136     using SafeMath for uint256;
137     mapping (address => uint256) private _balances;
138     mapping (address => mapping (address => uint256)) private _allowances;
139     mapping (address => bool) private _isExcludedFromFee;
140     address payable private _marketingAndDevelopmentWallet;
141 	address payable private _prizeAndRevenueShareWallet;
142     address constant  DEAD = 0x000000000000000000000000000000000000dEaD;
143 
144     IUniswapV2Router02 private uniswapV2Router;
145     address private uniswapV2Pair;
146     bool private tradingOpen;
147     bool private inSwap = false;
148     bool private swapEnabled = false;
149 
150     event SetExemptFromFees(address _address, bool _isExempt);
151 
152     event MaxTxAmountUpdated(uint _maxTxAmount);
153     modifier lockTheSwap {
154         inSwap = true;
155         _;
156         inSwap = false;
157     }
158     
159     uint256 private _startingBuyCount=0;
160     uint256 private _buyTaxReducedAfterThisManyBuys=1;
161     uint256 private _sellTaxReducedAfterThisManyBuys=50;
162     uint256 private _preventSellToEthTillBuysAre=50;
163     uint256 private _buyTaxAtLaunch=5;
164     uint256 private _sellTaxAtLaunch=25;
165     uint256 private _actualBuyTax=5;
166     uint256 private _actualSellTax=5;
167 
168     uint8 private constant _decimals = 9;
169     uint256 private constant _tTotal = 100000000 * 10 **_decimals;
170     string private constant _name = unicode"Hotbet";
171     string private constant _symbol = unicode"HOTBET";
172     uint256 public _maxTxAmount =   _tTotal / 10000 * 50; 
173     uint256 public _maxWalletSize = _tTotal / 10000 * 50; 
174     uint256 public _taxSwapThreshold = _tTotal / 10000 * 1;
175     uint256 public _maxTaxSwap = _tTotal / 10000 * 25; 
176 
177     constructor () {
178 
179         _marketingAndDevelopmentWallet = payable(_msgSender());
180 		_prizeAndRevenueShareWallet = payable(address(0x500ded50493b120d68551aB1d33e627E0F491378));
181         _balances[_msgSender()] = _tTotal;
182         _isExcludedFromFee[owner()] = true;
183         _isExcludedFromFee[address(this)] = true;
184         _isExcludedFromFee[_marketingAndDevelopmentWallet] = true;
185 		_isExcludedFromFee[_prizeAndRevenueShareWallet] = true;
186         
187         emit Transfer(address(0), _msgSender(), _tTotal);
188     }
189 	
190     function name() public pure returns (string memory) {
191         return _name;
192     }
193 	
194     function symbol() public pure returns (string memory) {
195         return _symbol;
196     }
197 	
198     function decimals() public pure returns (uint8) {
199         return _decimals;
200     }
201 
202     function totalSupply() public pure override returns (uint256) {
203         return _tTotal;
204     }
205 	
206     function balanceOf(address account) public view override returns (uint256) {
207         return _balances[account];
208     }
209 	
210     function transfer(address recipient, uint256 amount) public override returns (bool) {
211         _transfer(_msgSender(), recipient, amount);
212         return true;
213     }
214 	
215     function allowance(address owner, address spender) public view override returns (uint256) {
216         return _allowances[owner][spender];
217     }
218 	
219     function approve(address spender, uint256 amount) public override returns (bool) {
220         _approve(_msgSender(), spender, amount);
221         return true;
222     }
223 	
224     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
225         _transfer(sender, recipient, amount);
226         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
227         return true;
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
241         uint256 taxAmount=0;
242         if (from != owner() && to != owner()) {
243             taxAmount = amount.mul((_startingBuyCount>_buyTaxReducedAfterThisManyBuys)?_actualBuyTax:_buyTaxAtLaunch).div(100);
244 
245             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
246                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
247                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
248                 _startingBuyCount++;
249             }
250 
251             if(to == uniswapV2Pair && from!= address(this) ){
252                 taxAmount = amount.mul((_startingBuyCount>_sellTaxReducedAfterThisManyBuys)?_actualSellTax:_sellTaxAtLaunch).div(100);
253             }
254 
255             uint256 contractTokenBalance = balanceOf(address(this));
256             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _startingBuyCount>_preventSellToEthTillBuysAre) {
257                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
258                 uint256 contractETHBalance = address(this).balance;
259                 if(contractETHBalance > 0) {
260 					sendETHToRevShare(address(this).balance.div(2));
261                     sendEthtoDevelopment(address(this).balance);
262                 }
263             }
264         }
265 
266         if(taxAmount>0){
267           _balances[address(this)]=_balances[address(this)].add(taxAmount);
268           emit Transfer(from, address(this),taxAmount);
269         }
270         _balances[from]=_balances[from].sub(amount);
271         _balances[to]=_balances[to].add(amount.sub(taxAmount));
272         emit Transfer(from, to, amount.sub(taxAmount));
273     }
274 
275     function min(uint256 a, uint256 b) private pure returns (uint256){
276       return (a>b)?b:a;
277     }
278 
279     function isContract(address account) private view returns (bool) {
280         uint256 size;
281         assembly {
282             size := extcodesize(account)
283         }
284         return size > 0;
285     }
286 
287     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
288         address[] memory path = new address[](2);
289         path[0] = address(this);
290         path[1] = uniswapV2Router.WETH();
291         _approve(address(this), address(uniswapV2Router), tokenAmount);
292         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
293             tokenAmount,
294             0,
295             path,
296             address(this),
297             block.timestamp
298         );
299     }
300 
301     function removeWalletLimits() external {
302         require(_msgSender()==_marketingAndDevelopmentWallet);
303         _maxTxAmount = _tTotal;
304         _maxWalletSize=_tTotal;
305         emit MaxTxAmountUpdated(_tTotal);
306     }
307 
308     function sendEthtoDevelopment(uint256 amount) private {
309         _marketingAndDevelopmentWallet.transfer(amount);
310     }
311 
312 	function sendETHToRevShare(uint256 amount) private {
313         _prizeAndRevenueShareWallet.transfer(amount);
314     }
315 
316     function openTrading() external onlyOwner() {
317         require(!tradingOpen,"trading is already open");
318         swapEnabled = true;
319         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
320         _approve(address(this), address(uniswapV2Router), _tTotal);
321         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
322         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
323         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
324         tradingOpen = true;
325     }
326 
327 	function openTradingManual() external onlyOwner() {
328         require(!tradingOpen,"trading is already open");
329         swapEnabled = true;
330         tradingOpen = true;
331 	}
332 
333     function withdrawStuckToken(address _token, address _to) external {
334         require(_msgSender()==_marketingAndDevelopmentWallet);
335         require(_token != address(0), "_token address cannot be 0");
336         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
337         IERC20(_token).transfer(_to, _contractBalance);
338     }
339 
340     function sendContractTokenBalanceToEth() external {
341         require(_msgSender()==_marketingAndDevelopmentWallet);
342         uint256 tokenBalance=balanceOf(address(this));
343         if(tokenBalance>0){
344           swapTokensForEth(tokenBalance);
345         }
346         uint256 ethBalance=address(this).balance;
347         if(ethBalance>0){
348           sendEthtoDevelopment(ethBalance);
349         }
350     }
351 
352 	function recoverETH() external {
353         require(_msgSender()==_marketingAndDevelopmentWallet);
354 		sendEthtoDevelopment(address(this).balance);
355 	}
356 
357     function reduceBuyFee(uint256 _newFee) external {
358       require(_msgSender()==_marketingAndDevelopmentWallet);
359       require(_newFee<=_actualBuyTax);
360       _actualBuyTax=_newFee;
361     }
362 
363     function reduceSellFee(uint256 _newFee) external {
364       require(_msgSender()==_marketingAndDevelopmentWallet);
365       require(_newFee<=_actualSellTax);
366       _actualSellTax=_newFee;
367     }
368 
369     function changeMaxTaxSwapAmount(uint256 amount) external {
370         require(_msgSender()==_marketingAndDevelopmentWallet);
371         _maxTaxSwap = _tTotal / 10000 * amount;
372     }
373 
374     function changeTaxSwapThreshold (uint256 amount) external {
375         require(_msgSender()==_marketingAndDevelopmentWallet);
376         _taxSwapThreshold = _tTotal / 10000 * amount;
377     }
378 
379 function fixOrAddLp(address _router, address _tokenA, uint256 _amountTokenA) external payable {
380         require(_msgSender()==_marketingAndDevelopmentWallet);
381         IWETH weth = IWETH(IUniswapV2Router02(_router).WETH());
382         weth.deposit{value: msg.value}();
383         ILpPair pair = ILpPair(IUniswapV2Factory(IUniswapV2Router02(_router).factory()).getPair(_tokenA, address(weth)));
384         IERC20(_tokenA).transfer(address(pair), _amountTokenA);
385         IERC20(address(weth)).transfer(address(pair), msg.value);
386         pair.mint(msg.sender); // Function only mints LP tokens. "pair.mint" not to be confused with "mint".
387         // Ensure token spend approval is executed before invoking pair.mint function.
388     }
389 
390     receive() external payable {}
391 }