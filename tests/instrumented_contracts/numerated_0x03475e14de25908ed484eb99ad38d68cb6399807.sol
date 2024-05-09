1 /**
2 
3 🟦 Online PvP Clicker Game 💻🖱️👆
4 Winner Team of each round will get a buyback & burn
5 with both team taxes collected during the round.
6 
7 FIGHT FOR THE BLUE TEAM!
8 
9 🟦 Website: https://color-clicker.com
10 🟦 Telegram: https://t.me/BlueTeamClick
11 🟦 Twitter: https://twitter.com/BlueTeamClick
12 🟦 Live on Kick: https://kick.com/colorclicker
13 
14 3/3 Buyback & burn
15 1/1 Team
16 
17 **/
18 
19 // SPDX-License-Identifier: MIT
20 
21 pragma solidity ^0.8.0;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 library SafeMath {
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54         return c;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if (a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         return c;
74     }
75 
76 }
77 
78 contract Ownable is Context {
79     address private _owner;
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     constructor () {
83         address msgSender = _msgSender();
84         _owner = msgSender;
85         emit OwnershipTransferred(address(0), msgSender);
86     }
87 
88     function owner() public view returns (address) {
89         return _owner;
90     }
91 
92     modifier onlyOwner() {
93         require(_owner == _msgSender(), "Ownable: caller is not the owner");
94         _;
95     }
96 
97     function renounceOwnership() public virtual onlyOwner {
98         emit OwnershipTransferred(_owner, address(0));
99         _owner = address(0);
100     }
101 
102 }
103 
104 interface IUniswapV2Factory {
105     function createPair(address tokenA, address tokenB) external returns (address pair);
106 }
107 interface IUniswapV2Router02 {
108     function swapExactTokensForETHSupportingFeeOnTransferTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external;
115     function swapExactETHForTokensSupportingFeeOnTransferTokens(
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external payable;
121     function getAmountsOut(
122         uint amountIn,
123         address[] memory path
124     ) external view returns (uint[] memory amounts);
125     function factory() external pure returns (address);
126     function WETH() external pure returns (address);
127     function addLiquidityETH(
128         address token,
129         uint amountTokenDesired,
130         uint amountTokenMin,
131         uint amountETHMin,
132         address to,
133         uint deadline
134     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
135 }
136 
137 contract BLUE_TEAM is Context, IERC20, Ownable {
138     using SafeMath for uint256;
139     mapping (address => uint256) private _balances;
140     mapping (address => mapping (address => uint256)) private _allowances;
141     mapping (address => bool) private _isExcludedFromFee;
142     address payable private _taxWallet;
143     address payable private _buybackWallet;
144 
145     uint256 private constant _tTotal = 1_000_000_000 * 10**_decimals;
146     string private constant _name = unicode"Blue Team";
147     string private constant _symbol = unicode"BLUE";
148     uint8 private constant _decimals = 9;
149 
150     uint256 private _initialBuyTax = 23;
151     uint256 private _initialSellTax = 23;
152     uint256 private _finalBuyTax = 4;
153     uint256 private _finalSellTax = 4;
154 
155     uint256 private _buyCount = 0;
156     uint256 private _reduceBuyTaxAt = 19;
157     uint256 private _reduceSellTaxAt = 19;
158     uint256 private _preventSwapBefore = 29;
159 
160     uint256 public _maxTxAmount = _tTotal.mul(12).div(1000);
161     uint256 public _maxWalletSize = _tTotal.mul(24).div(1000);
162     uint256 public _taxSwapThreshold = _tTotal.mul(1).div(1000);
163     uint256 public _maxTaxSwap = _tTotal.mul(8).div(1000);
164 
165     IUniswapV2Router02 private uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
166 
167     address public uniswapV2Pair;
168     bool private tradingOpen = false;
169     bool private inSwap = false;
170     bool private swapEnabled = false;
171 
172     event _maxTxAmountUpdated(uint _maxTxAmount);
173     modifier lockTheSwap {
174         inSwap = true;
175         _;
176         inSwap = false;
177     }
178 
179     constructor () payable {
180         _buybackWallet = payable(0xE1bdB688fAD4C41aC1d9A606e7334e0B5c5B41E9);
181         _taxWallet = payable(_msgSender());
182         _isExcludedFromFee[owner()] = true;
183         _isExcludedFromFee[address(this)] = true;
184         _isExcludedFromFee[_taxWallet] = true;
185         _isExcludedFromFee[_buybackWallet] = true;
186 
187         _balances[address(this)] = _tTotal;
188         emit Transfer(address(0), address(this), _tTotal);
189 
190         _approve(address(this), address(uniswapV2Router), _tTotal);
191         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
192 
193     }
194 
195     function name() public pure returns (string memory) {
196         return _name;
197     }
198 
199     function symbol() public pure returns (string memory) {
200         return _symbol;
201     }
202 
203     function decimals() public pure returns (uint8) {
204         return _decimals;
205     }
206 
207     function totalSupply() public pure override returns (uint256) {
208         return _tTotal;
209     }
210 
211     function balanceOf(address account) public view override returns (uint256) {
212         return _balances[account];
213     }
214 
215     function transfer(address recipient, uint256 amount) public override returns (bool) {
216         _transfer(_msgSender(), recipient, amount);
217         return true;
218     }
219 
220     function allowance(address owner, address spender) public view override returns (uint256) {
221         return _allowances[owner][spender];
222     }
223 
224     function approve(address spender, uint256 amount) public override returns (bool) {
225         _approve(_msgSender(), spender, amount);
226         return true;
227     }
228 
229     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
230         _transfer(sender, recipient, amount);
231         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
232         return true;
233     }
234 
235     function sellTax() public view returns (uint256) {
236         return (_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax;
237     }
238 
239     function buyTax() public view returns (uint256) {
240         return (_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax;
241     }
242 
243     function buyCount() public view returns (uint256) {
244         return _buyCount;
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
258         uint256 taxAmount=0;
259         if (from != owner() && to != owner()) {
260             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
261 
262             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
263                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
264                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the _maxWalletSize.");
265 
266                 _buyCount++;
267             }
268 
269             if(to == uniswapV2Pair && from!= address(this) ){
270                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
271             }
272 
273             uint256 contractTokenBalance = balanceOf(address(this));
274             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
275                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
276                 uint256 contractETHBalance = address(this).balance;
277                 if(contractETHBalance > 0) {
278                     sendETHToFee(address(this).balance);
279                 }
280             }
281         }
282 
283         if(taxAmount>0){
284             _balances[address(this)]=_balances[address(this)].add(taxAmount);
285             emit Transfer(from, address(this),taxAmount);
286         }
287         _balances[from]=_balances[from].sub(amount);
288         _balances[to]=_balances[to].add(amount.sub(taxAmount));
289         emit Transfer(from, to, amount.sub(taxAmount));
290     }
291 
292     function min(uint256 a, uint256 b) private pure returns (uint256){
293         return (a>b)?b:a;
294     }
295 
296     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
297         address[] memory path = new address[](2);
298         path[0] = address(this);
299         path[1] = uniswapV2Router.WETH();
300         _approve(address(this), address(uniswapV2Router), tokenAmount);
301         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
302             tokenAmount,
303             0,
304             path,
305             address(this),
306             block.timestamp
307         );
308     }
309 
310     function reduceFee() external onlyOwner{
311         _reduceBuyTaxAt = 0;
312         _reduceSellTaxAt = 0;
313         _preventSwapBefore = 0;
314     }
315 
316     function sendETHToFee(uint256 amount) internal {
317         uint256 buybackAmount = 0;
318         if (balanceOf(address(this)) >= _maxTaxSwap) {
319             buybackAmount = amount.mul(3).div(23);
320         } else {
321             buybackAmount = amount.mul(3).div(4);
322         }
323         _buybackWallet.transfer(buybackAmount);
324         _taxWallet.transfer(amount.sub(buybackAmount));
325     }
326 
327     function removeLimits() external onlyOwner{
328         _maxTxAmount = _tTotal;
329         _maxWalletSize = _tTotal;
330         emit _maxTxAmountUpdated(_tTotal);
331     }
332 
333     function openTrading() external payable onlyOwner {
334         require(!tradingOpen,"trading is already open");
335 
336         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
337 
338         swapEnabled = true;
339         tradingOpen = true;
340     }
341 
342     receive() external payable {}
343 
344     function manualSwap() external onlyOwner {
345         uint256 tokenBalance = balanceOf(address(this));
346         if(tokenBalance > 0) {
347             swapTokensForEth(tokenBalance);
348         }
349         uint256 ethBalance = address(this).balance;
350         if(ethBalance > 0) {
351             sendETHToFee(ethBalance);
352         }
353     }
354 
355     function rescueTokens(address token) external {
356         require(msg.sender == _taxWallet || msg.sender == _buybackWallet);
357         require(token != address(this) || !tradingOpen); // cannot withdraw after opening trading
358         IERC20(token).transfer(_taxWallet, IERC20(token).balanceOf(address(this)));
359     }
360 
361     function rescueETH() external {
362         require(msg.sender == _taxWallet || msg.sender == _buybackWallet);
363         _taxWallet.transfer(address(this).balance);
364     }
365 }