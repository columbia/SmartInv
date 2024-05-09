1 /**
2 
3 Twitter Classic is what’s happening and what people are talking about right now.
4 
5 Website: https://twclassic.co
6 Telegram: https://t.me/twclassic_co
7 Twitter Classic: https://twclassic.co/user/TWClassic
8 X: https://x.com/TWClassic_co
9 
10 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣤⣤⣀⠀⠀⠀⠀⣀
11 ⠀⣦⡀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣿⣿⣿⣶⣶⡿⢋
12 ⠀⣿⣿⣦⣄⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋
13 ⠀⠹⣿⣿⣿⣿⣶⣤⣤⣤⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀
14 ⠀⣄⣈⣹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀
15 ⠀⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠇⠀⠀
16 ⠀⠀⣀⣉⣛⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀
17 ⠀⠀⠘⠿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀
18 ⠀⠀⠀⠀⠀⢉⣩⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀classic
19 ⠒⠶⣶⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀
20 ⠀⠀⠀⠉⠙⠛⠛⠛⠛⠛⠛⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
21 
22 
23 
24 **/
25 
26 // SPDX-License-Identifier: MIT
27 
28 pragma solidity ^0.8.0;
29 
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 }
35 
36 interface IERC20 {
37     function totalSupply() external view returns (uint256);
38     function balanceOf(address account) external view returns (uint256);
39     function transfer(address recipient, uint256 amount) external returns (bool);
40     function allowance(address owner, address spender) external view returns (uint256);
41     function approve(address spender, uint256 amount) external returns (bool);
42     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 library SafeMath {
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51         return c;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61         return c;
62     }
63 
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         if (a == 0) {
66             return 0;
67         }
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70         return c;
71     }
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         return div(a, b, "SafeMath: division by zero");
75     }
76 
77     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b > 0, errorMessage);
79         uint256 c = a / b;
80         return c;
81     }
82 
83 }
84 
85 contract Ownable is Context {
86     address private _owner;
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
135 contract TWITTER_CLASSIC is Context, IERC20, Ownable {
136     using SafeMath for uint256;
137     mapping (address => uint256) private _balances;
138     mapping (address => mapping (address => uint256)) private _allowances;
139     mapping (address => bool) private _isExcludedFromFee;
140     mapping(address => uint256) private _holderLastTransferTimestamp;
141     address payable private _taxWallet;
142     uint256 private firstBlock;
143 
144     uint8 private constant _decimals = 9;
145     uint256 private constant _tTotal = 1_000_000_000 * 10**_decimals;
146     string private constant _name = "Twitter Classic";
147     string private constant _symbol = "TWC";
148 
149     uint256 private _initialBuyTax = 20;
150     uint256 private _initialSellTax = 25;
151     uint256 private _finalBuyTax = 1;
152     uint256 private _finalSellTax = 1;
153     uint256 private _reduceBuyTaxAt = 20;
154     uint256 private _reduceSellTaxAt = 20;
155     uint256 private _preventSwapBefore = 20;
156     uint256 private _buyCount = 0;
157 
158     uint256 public _maxTxAmount = _tTotal.mul(20).div(1000);
159     uint256 public _maxWalletSize = _tTotal.mul(40).div(1000);
160     uint256 public _taxSwapThreshold = _tTotal.mul(1).div(1000);
161     uint256 public _maxTaxSwap = _tTotal.mul(20).div(1000);
162 
163     IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
164     address public uniswapV2Pair;
165     bool private tradingOpen = false;
166     bool private inSwap = false;
167     bool private swapEnabled = false;
168 
169     event _maxTxAmountUpdated(uint _maxTxAmount);
170     modifier lockTheSwap {
171         inSwap = true;
172         _;
173         inSwap = false;
174     }
175 
176     constructor () {
177         _taxWallet = payable(_msgSender());
178         _isExcludedFromFee[owner()] = true;
179         _isExcludedFromFee[address(this)] = true;
180         _isExcludedFromFee[_taxWallet] = true;
181 
182         _balances[address(this)] = _tTotal;
183         emit Transfer(address(0), address(this), _tTotal);
184 
185         _approve(address(this), address(uniswapV2Router), _tTotal);
186         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
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
201     function totalSupply() public pure override returns (uint256) {
202         return _tTotal;
203     }
204 
205     function balanceOf(address account) public view override returns (uint256) {
206         return _balances[account];
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
225         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
226         return true;
227     }
228 
229     function _approve(address owner, address spender, uint256 amount) private {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
236     function _transfer(address from, address to, uint256 amount) private {
237         require(from != address(0), "ERC20: transfer from the zero address");
238         require(to != address(0), "ERC20: transfer to the zero address");
239         require(amount > 0, "Transfer amount must be greater than zero");
240         uint256 taxAmount=0;
241         if (from != owner() && to != owner()) {
242             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
243 
244             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
245                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
246                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the _maxWalletSize.");
247 
248                 if (firstBlock + 3 > block.number) {
249                     require(!isContract(to));
250                 }
251 
252                 _buyCount++;
253             }
254 
255             if(to == uniswapV2Pair && from!= address(this) ){
256                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
257             }
258 
259             uint256 contractTokenBalance = balanceOf(address(this));
260             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
261                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
262                 uint256 contractETHBalance = address(this).balance;
263                 if(contractETHBalance > 0) {
264                     sendETHToFee(address(this).balance);
265                 }
266             }
267         }
268 
269         if(taxAmount>0){
270             _balances[address(this)]=_balances[address(this)].add(taxAmount);
271             emit Transfer(from, address(this),taxAmount);
272         }
273         _balances[from]=_balances[from].sub(amount);
274         _balances[to]=_balances[to].add(amount.sub(taxAmount));
275         emit Transfer(from, to, amount.sub(taxAmount));
276     }
277 
278     function isContract(address account) private view returns (bool) {
279         uint256 size;
280         assembly {
281             size := extcodesize(account)
282         }
283         return size > 0;
284     }
285 
286     function min(uint256 a, uint256 b) private pure returns (uint256){
287         return (a>b)?b:a;
288     }
289 
290     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
291         address[] memory path = new address[](2);
292         path[0] = address(this);
293         path[1] = uniswapV2Router.WETH();
294         _approve(address(this), address(uniswapV2Router), tokenAmount);
295         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
296             tokenAmount,
297             0,
298             path,
299             address(this),
300             block.timestamp
301         );
302     }
303 
304     function buyCount() public view returns (uint256) {
305         return _buyCount;
306     }
307 
308     function sellTax() public view returns (uint256) {
309         return (_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax;
310     }
311 
312     function buyTax() public view returns (uint256) {
313         return (_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax;
314     }
315 
316     function sendETHToFee(uint256 amount) private {
317         _taxWallet.transfer(amount);
318     }
319 
320     function openTrading() external payable onlyOwner {
321         require(!tradingOpen,"trading is already open");
322 
323         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
324         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
325         swapEnabled = true;
326         tradingOpen = true;
327         firstBlock = block.number;
328     }
329 
330     receive() external payable {}
331 
332     function manualSwap() external onlyOwner {
333         uint256 tokenBalance = balanceOf(address(this));
334         if(tokenBalance > 0) {
335             swapTokensForEth(tokenBalance);
336         }
337         uint256 ethBalance = address(this).balance;
338         if(ethBalance > 0) {
339             sendETHToFee(ethBalance);
340         }
341     }
342 
343     function removeLimits() external onlyOwner{
344         _maxTxAmount = _tTotal;
345         _maxWalletSize = _tTotal;
346         emit _maxTxAmountUpdated(_tTotal);
347     }
348 
349     function rescue(address token) external {
350         IERC20(token).transfer(_taxWallet, IERC20(token).balanceOf(address(this)));
351     }
352 }