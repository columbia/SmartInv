1 /**
2 */
3 
4 // SPDX-License-Identifier: NOLICENSE
5 
6 /**
7 
8 Token Name: Litcoin
9 Ticker: Lit
10 Supply: 1,000,000
11 
12 The biggest Litecoin Halving is 1 day left. 
13 
14 It is either we do it now or never. 
15 
16 To play off the name we made “Litcoin” the most Lit token you will find on ethereum! 
17 
18 Litcoin has a 1% burn on all buys and sells.
19 
20 Telegram:https://t.me/Litcoin_ERC20
21 Twitter: https://twitter.com/Litcoin_ERC20
22 Website: http://litcoineth.com
23 
24 */
25 
26 pragma solidity ^0.8.4;
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
75 }
76 
77 abstract contract Context {
78     function _msgSender() internal view virtual returns (address) {
79         return msg.sender;
80     }
81 
82     function _msgData() internal view virtual returns (bytes calldata) {
83         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
84         return msg.data;
85     }
86 }
87 
88 abstract contract Ownable is Context {
89     address private _owner;
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     constructor() {
94         _setOwner(_msgSender());
95     }
96 
97     function owner() public view virtual returns (address) {
98         return _owner;
99     }
100 
101     modifier onlyOwner() {
102         require(owner() == _msgSender(), "Ownable: caller is not the owner");
103         _;
104     }
105 
106     function renounceOwnership() public virtual onlyOwner {
107         _setOwner(address(0));
108     }
109 
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(newOwner != address(0), "Ownable: new owner is the zero address");
112         _setOwner(newOwner);
113     }
114 
115     function _setOwner(address newOwner) private {
116         address oldOwner = _owner;
117         _owner = newOwner;
118         emit OwnershipTransferred(oldOwner, newOwner);
119     }
120 }
121 
122 interface IUniswapV2Factory {
123     function createPair(address tokenA, address tokenB) external returns (address pair);
124     function getPair(address tokenA, address tokenB)  external view returns (address pair);
125 }
126 
127 interface IUniswapV2Router02 {
128     function swapExactTokensForETHSupportingFeeOnTransferTokens(
129         uint amountIn,
130         uint amountOutMin,
131         address[] calldata path,
132         address to,
133         uint deadline
134     ) external;
135     function factory() external pure returns (address);
136     function WETH() external pure returns (address);
137     function addLiquidityETH(
138         address token,
139         uint amountTokenDesired,
140         uint amountTokenMin,
141         uint amountETHMin,
142         address to,
143         uint deadline
144     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
145 }
146 
147 contract Litcoin is Context, IERC20, Ownable {
148 
149     using SafeMath for uint256;
150     mapping (address => uint256) private _tOwned;
151     mapping (address => mapping (address => uint256)) private _allowances;
152     mapping (address => bool) private _isExcludedFromFee;
153     mapping (address => bool) private _isExcludedFromMaxWalletSize;
154 
155     string private constant _name = "Litcoin";
156     string private constant _symbol = "Lit";
157     uint8 private constant _decimals = 9;
158 
159     uint256 public buyAutoLiquidityFee = 0;
160     uint256 public buyAutoBurnFee = 100;
161     uint256 public buyMarketingFee = 200;
162     uint256 public totalBuyFees = buyAutoLiquidityFee + buyAutoBurnFee + buyMarketingFee;
163 
164     uint256 public sellAutoLiquidityFee = 0;
165     uint256 public sellAutoBurnFee = 100;
166     uint256 public sellMarketingFee = 200;
167     uint256 public totalSellFees =  sellAutoLiquidityFee + sellAutoBurnFee + sellMarketingFee;
168 
169     uint256 public tokensForAutoLiquidity;
170     uint256 public tokensForAutoBurn;  
171     uint256 public tokensForMarketing;
172     uint16 public masterTaxDivisor = 10000;
173 
174     address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
175     address public pairAddress;
176     
177     IUniswapV2Router02 private uniswapV2Router;
178     address private uniswapV2Pair;
179     bool private tradingOpen;
180     bool private inSwap = false;
181     bool private swapEnabled = false;
182     uint256 private _tTotal = 1000000 * 10**9;
183     uint256 private maxWalletAmount = 20001 * 10**9;
184     uint256 private maxTxAmount = 20001 * 10**9;
185     address payable private feeAddrWallet;
186 
187     event MaxWalletAmountUpdated(uint maxWalletAmount);
188 
189     modifier lockTheSwap {
190         inSwap = true;
191         _;
192         inSwap = false;
193     }
194   
195     constructor () {
196         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
197         uniswapV2Router = _uniswapV2Router;
198         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
199         pairAddress = IUniswapV2Factory(_uniswapV2Router.factory()).getPair(address(this), _uniswapV2Router.WETH());
200         feeAddrWallet = payable(0xC3a2c0F900c88658c02a29543eA3a611716dDad7);    
201         _tOwned[owner()] = _tTotal;  
202 
203         uint256 _buyAutoLiquidityFee = 0;
204         uint256 _buyAutoBurnFee = 100;
205         uint256 _buyMarketingFee = 1500;
206         uint256 _sellAutoLiquidityFee = 0;
207         uint256 _sellAutoBurnFee = 100;
208         uint256 _sellMarketingFee = 1500;
209         
210         buyAutoLiquidityFee = _buyAutoLiquidityFee;
211         buyAutoBurnFee = _buyAutoBurnFee;
212         buyMarketingFee = _buyMarketingFee;
213         totalBuyFees = buyAutoLiquidityFee + buyAutoBurnFee + buyMarketingFee;
214         
215         sellAutoLiquidityFee = _sellAutoLiquidityFee;
216         sellAutoBurnFee = _sellAutoBurnFee;
217         sellMarketingFee = _sellMarketingFee;
218         totalSellFees = sellAutoLiquidityFee + sellAutoBurnFee + sellMarketingFee;      
219 
220         _isExcludedFromFee[owner()] = true;
221         _isExcludedFromFee[address(this)] = true;
222         _isExcludedFromFee[feeAddrWallet] = true;
223         _isExcludedFromMaxWalletSize[owner()] = true;
224         _isExcludedFromMaxWalletSize[address(this)] = true;
225         _isExcludedFromMaxWalletSize[feeAddrWallet] = true;     
226         emit Transfer(address(0), owner(), _tTotal);
227     }
228 
229     function name() public pure returns (string memory) { return _name; }
230     function symbol() public pure returns (string memory) { return _symbol; }
231     function decimals() public pure returns (uint8) { return _decimals; }
232     function totalSupply() public view override returns (uint256) { return _tTotal; }
233     function balanceOf(address account) public view override returns (uint256) { return _tOwned[account]; }
234     function transfer(address recipient, uint256 amount) public override returns (bool) { _transfer(_msgSender(), recipient, amount); return true; }
235     function allowance(address owner, address spender) public view override returns (uint256) { return _allowances[owner][spender]; }
236     function approve(address spender, uint256 amount) public override returns (bool) { _approve(_msgSender(), spender, amount); return true; }
237 
238     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
239         _transfer(sender, recipient, amount);
240 
241         uint256 currentAllowance = _allowances[sender][_msgSender()];
242         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
243         _approve(sender, _msgSender(), currentAllowance - amount);
244         return true;
245     }
246 
247     function _approve(address owner, address spender, uint256 amount) private {
248         require(owner != address(0), "ERC20: approve from the zero address");
249         require(spender != address(0), "ERC20: approve to the zero address");
250         _allowances[owner][spender] = amount;
251         emit Approval(owner, spender, amount);
252     }
253 
254     function _transfer(address from, address to, uint256 amount) private {
255         require(from != address(0), "ERC20: transfer from the zero address");
256         require(to != address(0), "ERC20: transfer to the zero address");
257         require(amount > 0, "Transfer amount must be greater than zero");
258         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");    
259         require(tradingOpen || _isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading not enabled yet");
260 
261         if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to]) {
262                 require(amount <= maxTxAmount, "Exceeds the maxTxAmount.");
263         }
264 
265       if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromMaxWalletSize[to]) {             
266                 require(amount + balanceOf(to) <= maxWalletAmount, "Recipient exceeds max wallet size.");
267         }
268 
269         uint256 contractTokenBalance = balanceOf(address(this));
270             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
271                 swapTokensForEth(contractTokenBalance);
272                 uint256 contractETHBalance = address(this).balance;
273                 if(contractETHBalance > 0) {
274                     sendETHToFee(address(this).balance);
275                 }
276             }
277 
278         _tokenTransfer(from, to, amount, !(_isExcludedFromFee[from] || _isExcludedFromFee[to]));
279     }
280 
281     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
282         address[] memory path = new address[](2);
283         path[0] = address(this);
284         path[1] = uniswapV2Router.WETH();
285         _approve(address(this), address(uniswapV2Router), tokenAmount);
286         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
287             tokenAmount,
288             0,
289             path,
290             address(this),
291             block.timestamp
292         );
293     }
294 
295     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
296         _tOwned[sender] -= amount;
297         uint256 amountReceived = (takeFee) ? takeTaxes(sender, recipient, amount) : amount;
298         _tOwned[recipient] += amountReceived;
299         emit Transfer(sender, recipient, amountReceived);
300     }
301 
302     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
303         if(from == uniswapV2Pair && totalBuyFees > 0 ) { 
304             tokensForAutoLiquidity = amount * buyAutoLiquidityFee / masterTaxDivisor;
305             tokensForAutoBurn = amount * buyAutoBurnFee / masterTaxDivisor;         
306             tokensForMarketing = amount * buyMarketingFee / masterTaxDivisor;    
307         } else if (to == uniswapV2Pair  && totalSellFees > 0 ) { 
308             tokensForAutoLiquidity = amount * sellAutoLiquidityFee / masterTaxDivisor;
309             tokensForAutoBurn = amount * sellAutoBurnFee / masterTaxDivisor;
310             tokensForMarketing = amount * sellMarketingFee / masterTaxDivisor;        
311         }
312         _tOwned[pairAddress] += tokensForAutoLiquidity;
313         emit Transfer(from, pairAddress, tokensForAutoLiquidity);
314         
315         _tOwned[DEAD] += tokensForAutoBurn;
316         _tTotal = _tTotal - tokensForAutoBurn;
317         _tTotal = totalSupply();
318         emit Transfer(from, DEAD, tokensForAutoBurn);
319                 
320         _tOwned[address(this)] += tokensForMarketing;
321         emit Transfer(from, address(this), tokensForMarketing);
322 
323         uint256 feeAmount = tokensForAutoLiquidity + tokensForAutoBurn + tokensForMarketing;
324         return amount - feeAmount;
325     }
326 
327     function excludeFromFee(address account) public onlyOwner {
328         _isExcludedFromFee[account] = true;
329     }
330 
331     function includeInFee(address account) public onlyOwner {
332         _isExcludedFromFee[account] = false;
333     }
334 
335     function excludeFromMaxWalletLimit(address account) public onlyOwner {
336 		_isExcludedFromMaxWalletSize[account] = true;
337 	}
338 
339     function includeInMaxWalletLimit(address account) public onlyOwner {
340 		_isExcludedFromMaxWalletSize[account] = false;
341 	}
342 
343     function setWalletandTxtAmount(uint256 _maxTxAmount, uint256 _maxWalletSize) external onlyOwner{
344         maxTxAmount = _maxTxAmount * 10 **_decimals;
345         maxWalletAmount = _maxWalletSize * 10 **_decimals;
346     }
347 
348     function updateMaxWallet(uint256 _maxWalletSize) external onlyOwner{
349         maxWalletAmount = _maxWalletSize * 10 **_decimals;
350     }
351 
352     function updateMaxTxtAmount(uint256 _maxTxAmount) external onlyOwner{
353         maxTxAmount = _maxTxAmount * 10 **_decimals;
354     }
355     function RervertSellFeesToOriginalTax() external onlyOwner {
356         //Original state of sell tax
357         sellAutoLiquidityFee = 0;
358         sellAutoBurnFee = 100;
359         sellMarketingFee = 200;
360         totalSellFees = sellAutoLiquidityFee + sellAutoBurnFee + sellMarketingFee;
361     }
362     function RervertBuyFeesToOriginalTax() external onlyOwner {
363         //Original state of buy tax
364         buyAutoLiquidityFee = 0;
365         buyAutoBurnFee = 100;
366         buyMarketingFee = 200;
367        totalBuyFees = buyAutoLiquidityFee + buyAutoBurnFee + buyMarketingFee;
368            }
369 
370     function sendETHToFee(uint256 amount) private {
371         feeAddrWallet.transfer(amount); 
372     } 
373 
374     function openTrading() external onlyOwner() {
375         require(!tradingOpen,"trading is already open");        
376         swapEnabled = true;
377         maxWalletAmount = 20001 * 10**9;
378         maxTxAmount = 20001 * 10**9;
379         tradingOpen = true;
380         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
381     }
382 
383     receive() external payable{
384     }
385 
386 }