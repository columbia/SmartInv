1 //◅ △ ▽ ▻ ◣ ◥ ◤ ◢ ◂ ▴◅ △ ▽ ▻ ◣ ◥ ◤ ◢ ◂ ◅ △ ▽ ▻ ◣ 
2 // SPDX-License-Identifier: MIT
3 // △ ▽ All your memes are belong to us.△ ▽
4 //◅ △ ▽ ▻ ◣ ◥ ◤ ◢ ◂ ▴◅ △ ▽ ▻ ◣ ◥ ◤ ◢ ◂ ◅ △ ▽ ▻ ◣ 
5 // TG: http://t.me/PepePonziETH
6 // TWITTER: https://twitter.com/pepeponziETH
7 // WEBSITE: https://pepeponzi.finance/
8 //◅ △ ▽ ▻ ◣ ◥ ◤ ◢ ◂ ▴◅ △ ▽ ▻ ◣ ◥ ◤ ◢ ◂ ◅ △ ▽ ▻ ◣ 
9 
10 //  ⠀⢀⣠⣾⠷⠊⠉⠉⠉⠉⠉⠙⠗⠉⠉⠉⠓⠻⠿⢿⣤⡀⠀⠀⠀⠀⠀⠀⠀⠀
11 //  ⣴⡿⠊⠀⣤⣒⣒⣒⣶⠒⡦⠀⠀⢠⣶⣒⣒⣲⣦⠀⠉⠓⢦⠀⠀⠀⠀⠀⠀⠀
12 //  ⠟⠀⠀⠀⠉⠉⠉⣉⣉⣩⡥⠤⠤⠤⢤⠬⠥⠬⠥⠤⠤⠤⣴⣇⠀⠀⠀⠀⠀⠀
13 //  ⠀⠀⣴⡞⣋⣉⣉⣥⠄⡐⠒⠒⠒⢒⣒⡒⠒⠒⠒⠒⠒⠒⠛⣻⡄⠀⠀⠀⠀⠀
14 //  ⠀⠀⠻⠽⠟⠚⠛⠋⠉⠉⠉⠉⠉⠛⠛⠛⠒⠒⠒⠒⠒⠚⠋⠉⠻⣤⡀⠀⠀⠀
15 //  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⡷⡀⠀⠀
16 //  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣀⣀⣀⣤⢤⠤⠤⣴⠤⠤⢤⡀⠀⠹⡵⠀⠀
17 //  ⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⠞⠁⠀⣤⣶⣖⣒⣒⣒⣺⣍⡆⠀⠀⢹⡄⠀⠹⣤⠀
18 //  ⠀⠀⠀⠀⠀⠀⠀⠀⢠⠏⠀⠀⠀⢀⡤⠴⠒⠈⠉⠉⠉⣿⠀⠀⠈⡇⠀⠀⢳⢖
19 //  ⠀⠀⠀⠀⠀⠀⠀⠀⣾⠀⠀⠀⠀⢘⣛⣉⣉⣉⣉⣉⣀⣨⣧⡀⠀⣇⠀⠀⠈⣦
20 //  ⠀⠀⠀⠀⠀⠀⠀⢀⡇⠀⠀⣴⠛⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⢳⡀⢻⡄⠀⠀⡯
21 //  ⠀⠀⠀⠀⠀⠀⠀⡾⠀⠀⢀⡏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢧⠈⣧⠀⠀⢳
22 //  ⠀⠀⠀⠀⠀⠀⢸⠇⠀⢀⡼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⡀⠘⡇⠀⢸
23 //  ⠀⠀⠀⠀⠀⠀⡼⠀⠀⡼⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣧⠀⣧⠀⢸
24 //  ⠀⠀⠀⠀⠀⢠⠇⠀⢰⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⠀⣟⠀⢸
25 //◅ △ ▽ ▻ ◣ ◥ ◤ ◢ ◂ ▴◅ △ ▽ ▻ ◣ ◥ ◤ ◢ ◂ ◅ △ ▽ ▻ ◣ 
26 
27 pragma solidity 0.8.20;
28 
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
86     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
87 
88     constructor () {
89         address msgSender = _msgSender();
90         _owner = msgSender;
91         emit OwnershipTransferred(address(0), msgSender);
92     }
93 
94     function owner() public view returns (address) {
95         return _owner;
96     }
97 
98     modifier onlyOwner() {
99         require(_owner == _msgSender(), "Ownable: caller is not the owner");
100         _;
101     }
102 
103     function renounceOwnership() public virtual onlyOwner {
104         emit OwnershipTransferred(_owner, address(0));
105         _owner = address(0);
106     }
107 
108 }
109 
110 interface IUniswapV2Factory {
111     function createPair(address tokenA, address tokenB) external returns (address pair);
112 }
113 
114 interface IUniswapV2Router02 {
115     function swapExactTokensForETHSupportingFeeOnTransferTokens(
116         uint amountIn,
117         uint amountOutMin,
118         address[] calldata path,
119         address to,
120         uint deadline
121     ) external;
122     function factory() external pure returns (address);
123     function WETH() external pure returns (address);
124     function addLiquidityETH(
125         address token,
126         uint amountTokenDesired,
127         uint amountTokenMin,
128         uint amountETHMin,
129         address to,
130         uint deadline
131     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
132 }
133 
134 contract PEPEP is Context, IERC20, Ownable {
135     using SafeMath for uint256;
136     mapping (address => uint256) private _balances;
137     mapping (address => mapping (address => uint256)) private _allowances;
138     mapping (address => bool) private _isExcludedFromFee;
139     mapping (address => bool) private bots;
140     mapping(address => uint256) private _holderLastTransferTimestamp;
141     bool public transferDelayEnabled = false;
142     address payable private _taxWallet;
143 
144     uint256 private _initialBuyTax=25;
145     uint256 private _initialSellTax=20;
146     uint256 private _finalBuyTax=1;
147     uint256 private _finalSellTax=1;
148     uint256 private _reduceBuyTaxAt=1;
149     uint256 private _reduceSellTaxAt=40;
150     uint256 private _preventSwapBefore=40;
151     uint256 private _buyCount=0;
152 
153     uint8 private constant _decimals = 8;
154     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
155     string private constant _name = unicode"PepePonzi";
156     string private constant _symbol = unicode"PEPEP";
157     uint256 public _maxTxAmount =   1000000000 * 10**_decimals;
158     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
159     uint256 public _taxSwapThreshold=0 * 10**_decimals;
160     uint256 public _maxTaxSwap=5000000 * 10**_decimals;
161 
162     IUniswapV2Router02 private uniswapV2Router;
163     address private uniswapV2Pair;
164     bool private tradingOpen;
165     bool private inSwap = false;
166     bool private swapEnabled = false;
167 
168     event MaxTxAmountUpdated(uint _maxTxAmount);
169     modifier lockTheSwap {
170         inSwap = true;
171         _;
172         inSwap = false;
173     }
174 
175     constructor () {
176         _taxWallet = payable(_msgSender());
177         _balances[_msgSender()] = _tTotal;
178         _isExcludedFromFee[owner()] = true;
179         _isExcludedFromFee[address(this)] = true;
180         _isExcludedFromFee[_taxWallet] = true;
181 
182         emit Transfer(address(0), _msgSender(), _tTotal);
183     }
184 
185     function name() public pure returns (string memory) {
186         return _name;
187     }
188 
189     function symbol() public pure returns (string memory) {
190         return _symbol;
191     }
192 
193     function decimals() public pure returns (uint8) {
194         return _decimals;
195     }
196 
197     function totalSupply() public pure override returns (uint256) {
198         return _tTotal;
199     }
200 
201     function balanceOf(address account) public view override returns (uint256) {
202         return _balances[account];
203     }
204 
205     function transfer(address recipient, uint256 amount) public override returns (bool) {
206         _transfer(_msgSender(), recipient, amount);
207         return true;
208     }
209 
210     function allowance(address owner, address spender) public view override returns (uint256) {
211         return _allowances[owner][spender];
212     }
213 
214     function approve(address spender, uint256 amount) public override returns (bool) {
215         _approve(_msgSender(), spender, amount);
216         return true;
217     }
218 
219     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
220         _transfer(sender, recipient, amount);
221         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
222         return true;
223     }
224 
225     function _approve(address owner, address spender, uint256 amount) private {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231 
232     function _transfer(address from, address to, uint256 amount) private {
233         require(from != address(0), "ERC20: transfer from the zero address");
234         require(to != address(0), "ERC20: transfer to the zero address");
235         require(amount > 0, "Transfer amount must be greater than zero");
236         uint256 taxAmount=0;
237         if (from != owner() && to != owner()) {
238             require(!bots[from] && !bots[to]);
239 
240             if (transferDelayEnabled) {
241                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
242                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
243                   _holderLastTransferTimestamp[tx.origin] = block.number;
244                 }
245             }
246 
247             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
248                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
249                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
250                 if(_buyCount<_preventSwapBefore){
251                   require(!isContract(to));
252                 }
253                 _buyCount++;
254             }
255 
256 
257             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
258             if(to == uniswapV2Pair && from!= address(this) ){
259                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
260                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
261             }
262 
263             uint256 contractTokenBalance = balanceOf(address(this));
264             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
265                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
266                 uint256 contractETHBalance = address(this).balance;
267                 if(contractETHBalance > 0) {
268                     sendETHToFee(address(this).balance);
269                 }
270             }
271         }
272 
273         if(taxAmount>0){
274           _balances[address(this)]=_balances[address(this)].add(taxAmount);
275           emit Transfer(from, address(this),taxAmount);
276         }
277         _balances[from]=_balances[from].sub(amount);
278         _balances[to]=_balances[to].add(amount.sub(taxAmount));
279         emit Transfer(from, to, amount.sub(taxAmount));
280     }
281 
282 
283     function min(uint256 a, uint256 b) private pure returns (uint256){
284       return (a>b)?b:a;
285     }
286 
287     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
288         if(tokenAmount==0){return;}
289         if(!tradingOpen){return;}
290         address[] memory path = new address[](2);
291         path[0] = address(this);
292         path[1] = uniswapV2Router.WETH();
293         _approve(address(this), address(uniswapV2Router), tokenAmount);
294         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
295             tokenAmount,
296             0,
297             path,
298             address(this),
299             block.timestamp
300         );
301     }
302 
303     function removeLimits() external onlyOwner{
304         _maxTxAmount = _tTotal;
305         _maxWalletSize=_tTotal;
306         transferDelayEnabled=false;
307         emit MaxTxAmountUpdated(_tTotal);
308     }
309 
310     function sendETHToFee(uint256 amount) private {
311         _taxWallet.transfer(amount);
312     }
313 
314     function isBot(address a) public view returns (bool){
315       return bots[a];
316     }
317 
318     function openTrading() external onlyOwner() {
319         require(!tradingOpen,"trading is already open");
320         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
321         _approve(address(this), address(uniswapV2Router), _tTotal);
322         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
323         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
324         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
325         swapEnabled = true;
326         tradingOpen = true;
327     }
328 
329     receive() external payable {}
330 
331     function isContract(address account) private view returns (bool) {
332         uint256 size;
333         assembly {
334             size := extcodesize(account)
335         }
336         return size > 0;
337     }
338 
339     function manualSwap() external {
340         require(_msgSender()==_taxWallet);
341         uint256 tokenBalance=balanceOf(address(this));
342         if(tokenBalance>0){
343           swapTokensForEth(tokenBalance);
344         }
345         uint256 ethBalance=address(this).balance;
346         if(ethBalance>0){
347           sendETHToFee(ethBalance);
348         }
349     }
350 
351     
352     
353     
354 }