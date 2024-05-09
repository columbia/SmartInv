1 /**
2 
3 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣤⣤⣤⣀⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
4 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣶⣤⣀⢀⣠⣤⣴⣶⣶⣾⣾⣶⣶⣶⣦⣤⣤⣀⢀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
5 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣯⣯⣯⣯⣿⣿⣿⣯⣯⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀
6 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣯⣿⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣿⣿⣿⣿⣯⣯⣿⣿⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣿⣯⣧⠀⠀⠀⠀⠀⠀⠀⠀
7 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣯⣯⣯⣿⣯⣯⣯⠟⠛⠛⠛⠛⠛⠛⠻⢿⣯⣿⣯⣯⣿⣯⣿⣿⣯⣯⣿⣿⣿⣿⣿⣿⣯⣯⣿⣯⣄⠀⠀⠀⠀⠀⠀⠀
8 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣯⣯⣯⣿⠟⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢿⣿⣯⣯⣿⣿⣿⣿⣿⣯⠿⠛⠛⠛⠛⠛⠛⠻⢿⣿⣿⣦⠀⠀⠀
9 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣿⣯⣯⣯⠛⠀⠀⠀⠀⢀⣴⣾⠿⣿⣷⣦⣀⠀⠀⠀⠀⠀⠀⠉⢿⣿⣿⣿⠟⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣷⠀⠀
10 ⠀⠀⠀⠀⠀⠀⢠⣶⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⡀⠀⠀⢠⣿⣯⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⢿⡿⠁⠀⣠⣶⣾⣿⣷⣶⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠀
11 ⠀⠀⠀⠀⠀⣴⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣤⠈⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀⠀⠀⡎⠀⠀⣿⣯⣭⣿⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
12 ⠀⠀⠀⠀⣼⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣯⣯⣿⣿⣿⣿⣿⣿⣿⣭⣄⣤⣤⣤⣤⣤⣴⣧⣤⢀⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀
13 ⠀⠀⠀⢰⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣯⣿⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣿⣯⣯⣿⣯⣯⣿⣷⣿⣿⣿⣿⣿⣿⣯⣤⣤⣤⣤⣶⣶⣶⣿⠏⠀⠀
14 ⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣯⣯⣯⢯⢿⢯⣿⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣿⠏⠀⠀⠀⠀
15 ⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣟⠋⠉⠀⠀⠀⠀⠀⠀⠀⠈⠛⢿⣯⣯⣿⣿⣿⣿⣿⣿⣿⣿⡏⠀⠀⠀⠀⠀
16 ⠀⠀⠀⠘⣿⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣶⣿⣯⣿⣿⣿⣿⣿⣿⣿⡟⠀⠀⠀⠀⠀⠀
17 ⠀⠀⠀⠀⠈⣿⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣄⠀⠀⠀⠀⢀⣠⣾⣿⣯⣿⣿⣿⣿⣿⣿⣿⣿⠋⠀⠀⠀⠀⠀⠀⠀
18 ⠀⠀⢀⣶⣿⣏⣻⣿⣿⣯⣯⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣿⣿⣿⣯⣯⣯⣿⣿⣿⣯⣯⣯⣿⣿⣿⣯⣯⣿⣿⣯⣏⠀⠀⠀⠀⠀⠀⠀⠀⠀
19 ⢀⣾⣯⣯⣯⣯⣯⣯⣇⣏⣻⣿⣿⣿⣿⣿⣯⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣯⣯⣯⣯⣏⣇⣯⣯⣦⠀⠀⠀⠀⠀⠀⠀
20 ⣿⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣇⣏⣏⣏⣟⣟⣟⣿⣿⣿⣿⣿⣿⣯⣯⣯⣯⣯⣿⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣿⣿⣏⣏⣇⣯⣯⣯⣯⣯⣯⣿⣄⠀⠀⠀⠀⠀
21 ⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣧⣯⣯⣯⣯⣯⣦⠀⠀⠀⠀
22 ⣯⣯⣯⣯⣿⣇⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣯⣿⣯⣯⣯⣯⣯⣯⠀⠀⠀⠀
23 ⠛⠛⠛⠛⠋⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠛⠋⠛⠛⠛⠛⠛⠀⠀⠀⠀⠀
24 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
25 https://t.me/PEPEIIeth
26 https://pepell.vip/
27 https://twitter.com/pepecoinll
28 
29 */
30 
31 // SPDX-License-Identifier: MIT
32 
33 
34 pragma solidity 0.8.20;
35 
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address) {
38         return msg.sender;
39     }
40 }
41 
42 interface IERC20 {
43     function totalSupply() external view returns (uint256);
44     function balanceOf(address account) external view returns (uint256);
45     function transfer(address recipient, uint256 amount) external returns (bool);
46     function allowance(address owner, address spender) external view returns (uint256);
47     function approve(address spender, uint256 amount) external returns (bool);
48     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
49     event Transfer(address indexed from, address indexed to, uint256 value);
50     event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 library SafeMath {
54     function add(uint256 a, uint256 b) internal pure returns (uint256) {
55         uint256 c = a + b;
56         require(c >= a, "SafeMath: addition overflow");
57         return c;
58     }
59 
60     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
61         return sub(a, b, "SafeMath: subtraction overflow");
62     }
63 
64     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b <= a, errorMessage);
66         uint256 c = a - b;
67         return c;
68     }
69 
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         if (a == 0) {
72             return 0;
73         }
74         uint256 c = a * b;
75         require(c / a == b, "SafeMath: multiplication overflow");
76         return c;
77     }
78 
79     function div(uint256 a, uint256 b) internal pure returns (uint256) {
80         return div(a, b, "SafeMath: division by zero");
81     }
82 
83     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
84         require(b > 0, errorMessage);
85         uint256 c = a / b;
86         return c;
87     }
88 
89 }
90 
91 contract Ownable is Context {
92     address private _owner;
93     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
94 
95     constructor () {
96         address msgSender = _msgSender();
97         _owner = msgSender;
98         emit OwnershipTransferred(address(0), msgSender);
99     }
100 
101     function owner() public view returns (address) {
102         return _owner;
103     }
104 
105     modifier onlyOwner() {
106         require(_owner == _msgSender(), "Ownable: caller is not the owner");
107         _;
108     }
109 
110     function renounceOwnership() public virtual onlyOwner {
111         emit OwnershipTransferred(_owner, address(0));
112         _owner = address(0);
113     }
114 
115 }
116 
117 interface IUniswapV2Factory {
118     function createPair(address tokenA, address tokenB) external returns (address pair);
119 }
120 
121 interface IUniswapV2Router02 {
122     function swapExactTokensForETHSupportingFeeOnTransferTokens(
123         uint amountIn,
124         uint amountOutMin,
125         address[] calldata path,
126         address to,
127         uint deadline
128     ) external;
129     function factory() external pure returns (address);
130     function WETH() external pure returns (address);
131     function addLiquidityETH(
132         address token,
133         uint amountTokenDesired,
134         uint amountTokenMin,
135         uint amountETHMin,
136         address to,
137         uint deadline
138     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
139 }
140 
141 contract pepe is Context, IERC20, Ownable {
142     using SafeMath for uint256;
143     mapping (address => uint256) private _balances;
144     mapping (address => mapping (address => uint256)) private _allowances;
145     mapping (address => bool) private _isExcludedFromFee;
146     mapping (address => bool) private bots;
147     mapping(address => uint256) private _holderLastTransferTimestamp;
148     bool public transferDelayEnabled = true;
149     address payable private _taxWallet;
150 
151     uint256 private _initialBuyTax=20;
152     uint256 private _initialSellTax=20;
153     uint256 private _finalBuyTax=1;
154     uint256 private _finalSellTax=1;
155     uint256 private _reduceBuyTaxAt=22;
156     uint256 private _reduceSellTaxAt=22;
157     uint256 private _preventSwapBefore=22;
158     uint256 private _buyCount=0;
159 
160     uint8 private constant _decimals = 9;
161     uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
162     string private constant _name = unicode"PEPE II";
163     string private constant _symbol = unicode"PEPE";
164     uint256 public _maxTxAmount = 2524140000000 * 10**_decimals;
165     uint256 public _maxWalletSize = 2524140000000 * 10**_decimals;
166     uint256 public _taxSwapThreshold= 252414000000 * 10**_decimals;
167     uint256 public _maxTaxSwap= 4206900000000 * 10**_decimals;
168 
169     IUniswapV2Router02 private uniswapV2Router;
170     address private uniswapV2Pair;
171     bool private tradingOpen;
172     bool private inSwap = false;
173     bool private swapEnabled = false;
174 
175     event MaxTxAmountUpdated(uint _maxTxAmount);
176     modifier lockTheSwap {
177         inSwap = true;
178         _;
179         inSwap = false;
180     }
181 
182     constructor () {
183         _taxWallet = payable(_msgSender());
184         _balances[_msgSender()] = _tTotal;
185         _isExcludedFromFee[owner()] = true;
186         _isExcludedFromFee[address(this)] = true;
187         _isExcludedFromFee[_taxWallet] = true;
188 
189         emit Transfer(address(0), _msgSender(), _tTotal);
190     }
191 
192     function name() public pure returns (string memory) {
193         return _name;
194     }
195 
196     function symbol() public pure returns (string memory) {
197         return _symbol;
198     }
199 
200     function decimals() public pure returns (uint8) {
201         return _decimals;
202     }
203 
204     function totalSupply() public pure override returns (uint256) {
205         return _tTotal;
206     }
207 
208     function balanceOf(address account) public view override returns (uint256) {
209         return _balances[account];
210     }
211 
212     function transfer(address recipient, uint256 amount) public override returns (bool) {
213         _transfer(_msgSender(), recipient, amount);
214         return true;
215     }
216 
217     function allowance(address owner, address spender) public view override returns (uint256) {
218         return _allowances[owner][spender];
219     }
220 
221     function approve(address spender, uint256 amount) public override returns (bool) {
222         _approve(_msgSender(), spender, amount);
223         return true;
224     }
225 
226     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
227         _transfer(sender, recipient, amount);
228         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
229         return true;
230     }
231 
232     function _approve(address owner, address spender, uint256 amount) private {
233         require(owner != address(0), "ERC20: approve from the zero address");
234         require(spender != address(0), "ERC20: approve to the zero address");
235         _allowances[owner][spender] = amount;
236         emit Approval(owner, spender, amount);
237     }
238 
239     function _transfer(address from, address to, uint256 amount) private {
240         require(from != address(0), "ERC20: transfer from the zero address");
241         require(to != address(0), "ERC20: transfer to the zero address");
242         require(amount > 0, "Transfer amount must be greater than zero");
243         uint256 taxAmount=0;
244         if (from != owner() && to != owner()) {
245             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
246 
247             if (transferDelayEnabled) {
248                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
249                       require(
250                           _holderLastTransferTimestamp[tx.origin] <
251                               block.number,
252                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
253                       );
254                       _holderLastTransferTimestamp[tx.origin] = block.number;
255                   }
256               }
257 
258             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
259                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
260                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
261                 _buyCount++;
262             }
263 
264             if(to == uniswapV2Pair && from!= address(this) ){
265                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
266             }
267 
268             uint256 contractTokenBalance = balanceOf(address(this));
269             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
270                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
271                 uint256 contractETHBalance = address(this).balance;
272                 if(contractETHBalance > 50000000000000000) {
273                     sendETHToFee(address(this).balance);
274                 }
275             }
276         }
277 
278         if(taxAmount>0){
279           _balances[address(this)]=_balances[address(this)].add(taxAmount);
280           emit Transfer(from, address(this),taxAmount);
281         }
282         _balances[from]=_balances[from].sub(amount);
283         _balances[to]=_balances[to].add(amount.sub(taxAmount));
284         emit Transfer(from, to, amount.sub(taxAmount));
285     }
286 
287 
288     function min(uint256 a, uint256 b) private pure returns (uint256){
289       return (a>b)?b:a;
290     }
291 
292     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
293         address[] memory path = new address[](2);
294         path[0] = address(this);
295         path[1] = uniswapV2Router.WETH();
296         _approve(address(this), address(uniswapV2Router), tokenAmount);
297         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
298             tokenAmount,
299             0,
300             path,
301             address(this),
302             block.timestamp
303         );
304     }
305 
306     function removeLimits() external onlyOwner{
307         _maxTxAmount = _tTotal;
308         _maxWalletSize=_tTotal;
309         transferDelayEnabled=false;
310         emit MaxTxAmountUpdated(_tTotal);
311     }
312 
313     function sendETHToFee(uint256 amount) private {
314         _taxWallet.transfer(amount);
315     }
316 
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
331     function manualSwap() external {
332         require(_msgSender()==_taxWallet);
333         uint256 tokenBalance=balanceOf(address(this));
334         if(tokenBalance>0){
335           swapTokensForEth(tokenBalance);
336         }
337         uint256 ethBalance=address(this).balance;
338         if(ethBalance>0){
339           sendETHToFee(ethBalance);
340         }
341     }
342 }