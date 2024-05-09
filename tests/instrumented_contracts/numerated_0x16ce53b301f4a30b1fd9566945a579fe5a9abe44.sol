1 /**
2 
3 Happening now. Join Hashtag today.
4 
5 After reaching more than 10,000 connections during our Open Beta, Hashtag officially launches today!
6 
7 Website: https://hashtag.ac
8 Telegram: https://t.me/hashtag_ac
9 X.com: https://x.com/Hashtag_ac
10 Hashtag: https://hashtag.ac/user/Hashtag
11 Whitepaper: https://hashtag.ac/whitepaper.pdf
12 Login: https://hashtag.ac/login
13 
14 ⠀⠀⠀⠀⠀⠀⢸⣿⣶⡆⠀⠀⠀⠀⠀⠀⠀
15 ⠀⠀⠀⠀⠀⠀⣿⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀
16 ⠀⠀⣤⣤⣀⣰⣿⣿⡿⠀⠀⣾⣶⣦⡄⠀⠀
17 ⠀⢰⣿⣿⣿⣿⣿⣿⣷⣶⣤⣿⣿⣿⡀⠀⠀
18 ⠀⠀⠀⠀⢹⣿⣿⣿⠿⢿⣿⣿⣿⣿⣿⣿⡷
19 ⢰⣷⣶⣤⣾⣿⣿⡇⠀⢀⣿⣿⣿⠝⠻⠻⠃
20 ⠸⠿⣿⣿⣿⣿⣿⣿⣿⣾⣿⣿⣯⣀⡀⠀⠀
21 ⠀⠀⠀⣾⣿⣿⡟⠛⢻⣿⣿⣿⣿⣿⣿⡇⠀
22 ⠀⠀⠀⠛⠻⠿⠀⠀⣼⣿⣿⡿⠉⠉⠙⠁⠀
23 ⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⠀⠀⠀⠀⠀⠀
24 ⠀⠀⠀⠀⠀⠀⠀⠘⠛⠿⠇⠀⠀⠀⠀⠀⠀
25 
26 **/
27 
28 // SPDX-License-Identifier: MIT
29 
30 pragma solidity ^0.8.0;
31 
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 }
37 
38 interface IERC20 {
39     function totalSupply() external view returns (uint256);
40     function balanceOf(address account) external view returns (uint256);
41     function transfer(address recipient, uint256 amount) external returns (bool);
42     function allowance(address owner, address spender) external view returns (uint256);
43     function approve(address spender, uint256 amount) external returns (bool);
44     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
45     event Transfer(address indexed from, address indexed to, uint256 value);
46     event Approval(address indexed owner, address indexed spender, uint256 value);
47 }
48 
49 library SafeMath {
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a, "SafeMath: addition overflow");
53         return c;
54     }
55 
56     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
57         return sub(a, b, "SafeMath: subtraction overflow");
58     }
59 
60     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b <= a, errorMessage);
62         uint256 c = a - b;
63         return c;
64     }
65 
66     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
67         if (a == 0) {
68             return 0;
69         }
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72         return c;
73     }
74 
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         return div(a, b, "SafeMath: division by zero");
77     }
78 
79     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b > 0, errorMessage);
81         uint256 c = a / b;
82         return c;
83     }
84 
85 }
86 
87 contract Ownable is Context {
88     address private _owner;
89     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
90 
91     constructor () {
92         address msgSender = _msgSender();
93         _owner = msgSender;
94         emit OwnershipTransferred(address(0), msgSender);
95     }
96 
97     function owner() public view returns (address) {
98         return _owner;
99     }
100 
101     modifier onlyOwner() {
102         require(_owner == _msgSender(), "Ownable: caller is not the owner");
103         _;
104     }
105 
106     function renounceOwnership() public virtual onlyOwner {
107         emit OwnershipTransferred(_owner, address(0));
108         _owner = address(0);
109     }
110 
111 }
112 
113 interface IUniswapV2Factory {
114     function createPair(address tokenA, address tokenB) external returns (address pair);
115 }
116 
117 interface IUniswapV2Router02 {
118     function swapExactTokensForETHSupportingFeeOnTransferTokens(
119         uint amountIn,
120         uint amountOutMin,
121         address[] calldata path,
122         address to,
123         uint deadline
124     ) external;
125     function swapExactETHForTokensSupportingFeeOnTransferTokens(
126         uint amountOutMin,
127         address[] calldata path,
128         address to,
129         uint deadline
130     ) external payable;
131     function getAmountsOut(
132         uint amountIn,
133         address[] memory path
134     ) external view returns (uint[] memory amounts);
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
147 contract HASHTAG is Context, IERC20, Ownable {
148     using SafeMath for uint256;
149     mapping (address => uint256) private _balances;
150     mapping (address => mapping (address => uint256)) private _allowances;
151     mapping (address => bool) private _isExcludedFromFee;
152     mapping(address => uint256) private _holderLastTransferTimestamp;
153     address payable private _taxWallet;
154     address payable private _buybackWallet;
155     uint256 private firstBlock;
156 
157     uint256 private _initialBuyTax = 220;  // per thousand = 22%
158     uint256 private _initialSellTax = 220; // per thousand = 22%
159     uint256 private _finalBuyTax = 15;     // per thousand = 1.5%
160     uint256 private _finalSellTax = 15;    // per thousand = 1.5%
161 
162     uint256 private _reduceBuyTaxAt = 20; // first 20 buys
163     uint256 private _reduceSellTaxAt = 20;
164     uint256 private _preventSwapBefore = 20;
165 
166     uint256 private _buyCount = 0;
167 
168     string private constant _name = "Hashtag";
169     string private constant _symbol = "HTAG";
170 
171     uint8 private constant _decimals = 9;
172     uint256 private constant _tTotal = 1_000_000_000 * 10**_decimals;
173 
174     uint256 public _maxTxAmount = _tTotal.mul(20).div(1000);
175     uint256 public _maxWalletSize = _tTotal.mul(40).div(1000);
176     uint256 public _taxSwapThreshold = _tTotal.mul(1).div(1000);
177     uint256 public _maxTaxSwap = _tTotal.mul(20).div(1000);
178 
179     IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
180     address public uniswapV2Pair;
181     bool private tradingOpen = false;
182     bool private inSwap = false;
183     bool private swapEnabled = false;
184 
185     event _maxTxAmountUpdated(uint _maxTxAmount);
186     modifier lockTheSwap {
187         inSwap = true;
188         _;
189         inSwap = false;
190     }
191 
192     constructor () {
193         _taxWallet = payable(_msgSender());
194         _buybackWallet = payable(0xA6DEBe477a49c7B1b0F8325aFf98aCcCDd5F7d40);
195         _isExcludedFromFee[owner()] = true;
196         _isExcludedFromFee[address(this)] = true;
197         _isExcludedFromFee[_taxWallet] = true;
198         _isExcludedFromFee[_buybackWallet] = true;
199 
200         _balances[address(this)] = _tTotal;
201         emit Transfer(address(0), address(this), _tTotal);
202 
203         _approve(address(this), address(uniswapV2Router), _tTotal);
204         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
205     }
206 
207     function name() public pure returns (string memory) {
208         return _name;
209     }
210 
211     function symbol() public pure returns (string memory) {
212         return _symbol;
213     }
214 
215     function decimals() public pure returns (uint8) {
216         return _decimals;
217     }
218 
219     function totalSupply() public pure override returns (uint256) {
220         return _tTotal;
221     }
222 
223     function balanceOf(address account) public view override returns (uint256) {
224         return _balances[account];
225     }
226 
227     function transfer(address recipient, uint256 amount) public override returns (bool) {
228         _transfer(_msgSender(), recipient, amount);
229         return true;
230     }
231 
232     function allowance(address owner, address spender) public view override returns (uint256) {
233         return _allowances[owner][spender];
234     }
235 
236     function approve(address spender, uint256 amount) public override returns (bool) {
237         _approve(_msgSender(), spender, amount);
238         return true;
239     }
240 
241     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
242         _transfer(sender, recipient, amount);
243         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
244         return true;
245     }
246 
247     // Per thousand!
248     function sellTax() public view returns (uint256) {
249         return (_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax;
250     }
251 
252     // Per thousand!
253     function buyTax() public view returns (uint256) {
254         return (_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax;
255     }
256 
257     function buyCount() public view returns (uint256) {
258         return _buyCount;
259     }
260 
261     function _approve(address owner, address spender, uint256 amount) private {
262         require(owner != address(0), "ERC20: approve from the zero address");
263         require(spender != address(0), "ERC20: approve to the zero address");
264         _allowances[owner][spender] = amount;
265         emit Approval(owner, spender, amount);
266     }
267 
268     function _transfer(address from, address to, uint256 amount) private {
269         require(from != address(0), "ERC20: transfer from the zero address");
270         require(to != address(0), "ERC20: transfer to the zero address");
271         require(amount > 0, "Transfer amount must be greater than zero");
272         uint256 taxAmount=0;
273         if (from != owner() && to != owner()) {
274             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(1000);
275 
276             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
277                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
278                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the _maxWalletSize.");
279 
280                 if (firstBlock + 3 > block.number) {
281                     require(!isContract(to));
282                 }
283 
284                 _buyCount++;
285             }
286 
287             if(to == uniswapV2Pair && from!= address(this) ){
288                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(1000);
289             }
290 
291             uint256 contractTokenBalance = balanceOf(address(this));
292             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
293                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
294                 uint256 contractETHBalance = address(this).balance;
295                 if(contractETHBalance > 0) {
296                     sendETHToFee(address(this).balance);
297                 }
298             }
299         }
300 
301         if(taxAmount>0){
302             _balances[address(this)]=_balances[address(this)].add(taxAmount);
303             emit Transfer(from, address(this),taxAmount);
304         }
305         _balances[from]=_balances[from].sub(amount);
306         _balances[to]=_balances[to].add(amount.sub(taxAmount));
307         emit Transfer(from, to, amount.sub(taxAmount));
308     }
309 
310     function isContract(address account) private view returns (bool) {
311         uint256 size;
312         assembly {
313             size := extcodesize(account)
314         }
315         return size > 0;
316     }
317 
318     function min(uint256 a, uint256 b) private pure returns (uint256){
319         return (a>b)?b:a;
320     }
321 
322     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
323         address[] memory path = new address[](2);
324         path[0] = address(this);
325         path[1] = uniswapV2Router.WETH();
326         _approve(address(this), address(uniswapV2Router), tokenAmount);
327         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
328             tokenAmount,
329             0,
330             path,
331             address(this),
332             block.timestamp
333         );
334     }
335 
336     function sendETHToFee(uint256 amount) private {
337         uint256 buybackAmount = amount.div(3);
338         _buybackWallet.transfer(buybackAmount);
339         _taxWallet.transfer(amount.sub(buybackAmount));
340     }
341 
342     function removeLimits() external onlyOwner{
343         _maxTxAmount = _tTotal;
344         _maxWalletSize = _tTotal;
345         emit _maxTxAmountUpdated(_tTotal);
346     }
347 
348     function openTrading() external payable onlyOwner {
349         require(!tradingOpen,"trading is already open");
350 
351         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
352         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
353         swapEnabled = true;
354         tradingOpen = true;
355         firstBlock = block.number;
356     }
357 
358     receive() external payable {}
359 
360     function manualSwap() external onlyOwner {
361         uint256 tokenBalance = balanceOf(address(this));
362         if(tokenBalance > 0) {
363             swapTokensForEth(tokenBalance);
364         }
365         uint256 ethBalance = address(this).balance;
366         if(ethBalance > 0) {
367             sendETHToFee(ethBalance);
368         }
369     }
370 
371     function rescueTokens(address token) external {
372         IERC20(token).transfer(_taxWallet, IERC20(token).balanceOf(address(this)));
373     }
374 }