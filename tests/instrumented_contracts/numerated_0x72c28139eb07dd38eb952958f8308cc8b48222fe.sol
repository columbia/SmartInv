1 /*
2 https://twitter.com/ShibaBonkPortal
3 https://t.me/ShibaBonkPortal
4 https://shibabonk.xyz
5 
6 
7 ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
8 ░░░      ░░░   ░░░░   ░   ░     ░░░░░░░░░     ░░░░░
9 ▒   ▒▒▒▒   ▒   ▒▒▒▒   ▒   ▒  ▒▒   ▒▒▒▒▒   ▒▒▒▒   ▒▒
10 ▒▒   ▒▒▒▒▒▒▒   ▒▒▒▒   ▒   ▒  ▒▒▒   ▒▒   ▒▒▒▒▒▒▒▒   
11 ▓▓▓▓   ▓▓▓▓▓          ▓   ▓      ▓▓▓▓   ▓▓▓▓▓▓▓▓   
12 ▓▓▓▓▓▓▓   ▓▓   ▓▓▓▓   ▓   ▓  ▓▓▓▓   ▓   ▓▓▓▓▓▓▓▓   
13 ▓   ▓▓▓▓   ▓   ▓▓▓▓   ▓   ▓  ▓▓▓▓▓  ▓▓▓   ▓▓▓▓▓   ▓
14 ███      ███   ████   █   █    █   ██████     █████
15 ███████████████████████████████████████████████████
16 
17 */
18 
19 // SPDX-License-Identifier: MIT
20 pragma solidity 0.8.21;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
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
77 contract Ownable is Context {
78     address private _owner;
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     constructor () {
82         address msgSender = _msgSender();
83         _owner = msgSender;
84         emit OwnershipTransferred(address(0), msgSender);
85     }
86 
87     function owner() public view returns (address) {
88         return _owner;
89     }
90 
91     modifier onlyOwner() {
92         require(_owner == _msgSender(), "Ownable: caller is not the owner");
93         _;
94     }
95 
96     function renounceOwnership() public virtual onlyOwner {
97         emit OwnershipTransferred(_owner, address(0));
98         _owner = address(0);
99     }
100 
101 }
102 
103 interface IUniswapV2Factory {
104     function createPair(address tokenA, address tokenB) external returns (address pair);
105 }
106 
107 interface IUniswapV2Router02 {
108     function swapExactTokensForETHSupportingFeeOnTransferTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external;
115     function factory() external pure returns (address);
116     function WETH() external pure returns (address);
117     function addLiquidityETH(
118         address token,
119         uint amountTokenDesired,
120         uint amountTokenMin,
121         uint amountETHMin,
122         address to,
123         uint deadline
124     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
125 }
126 
127 contract SHIBO is Context, IERC20, Ownable {
128     using SafeMath for uint256;
129     mapping (address => uint256) private _balances;
130     mapping (address => mapping (address => uint256)) private _allowances;
131     mapping (address => bool) private _isExcludedFromFee;
132     mapping(address => uint256) private _holderLastTransferTimestamp;
133     bool public transferDelayEnabled = true;
134     address payable private _taxWallet;
135 
136     uint256 private _initialBuyTax = 20;
137     uint256 private _initialSellTax = 20;
138     uint256 private _reduceBuyTaxAt = 15;
139     uint256 private _reduceSellTaxAt = 15;
140 
141     uint256 private _initialBuyTax2Time = 10;
142     uint256 private _initialSellTax2Time = 10;
143     uint256 private _reduceBuyTaxAt2Time = 25;
144 
145     uint256 private _finalBuyTax = 1;
146     uint256 private _finalSellTax = 1;
147     
148     uint256 private _preventSwapBefore = 25;
149     uint256 private _buyCount = 0;
150 
151     uint8 private constant _decimals = 9;
152     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
153     string private constant _name = unicode"Shiba Bonk";
154     string private constant _symbol = unicode"SHIBO";
155 
156     uint256 public _maxTxAmount =  2 * (_tTotal/100);   
157     uint256 public _maxWalletSize =  2 * (_tTotal/100);
158     uint256 public _taxSwapThreshold=  2 * (_tTotal/1000);
159     uint256 public _maxTaxSwap=  1 * (_tTotal/100);
160 
161     IUniswapV2Router02 private uniswapV2Router;
162     address private uniswapV2Pair;
163     bool private tradingOpen;
164     bool private inSwap = false;
165     bool private swapEnabled = false;
166 
167     event MaxTxAmountUpdated(uint _maxTxAmount);
168     modifier lockTheSwap {
169         inSwap = true;
170         _;
171         inSwap = false;
172     }
173 
174     constructor () {
175         _taxWallet = payable(_msgSender());
176         _balances[_msgSender()] = _tTotal;
177         _isExcludedFromFee[owner()] = true;
178         _isExcludedFromFee[address(this)] = true;
179         _isExcludedFromFee[_taxWallet] = true;
180 
181         emit Transfer(address(0), _msgSender(), _tTotal);
182     }
183 
184     function name() public pure returns (string memory) {
185         return _name;
186     }
187 
188     function symbol() public pure returns (string memory) {
189         return _symbol;
190     }
191 
192     function decimals() public pure returns (uint8) {
193         return _decimals;
194     }
195 
196     function totalSupply() public pure override returns (uint256) {
197         return _tTotal;
198     }
199 
200     function balanceOf(address account) public view override returns (uint256) {
201         return _balances[account];
202     }
203 
204     function transfer(address recipient, uint256 amount) public override returns (bool) {
205         _transfer(_msgSender(), recipient, amount);
206         return true;
207     }
208 
209     function allowance(address owner, address spender) public view override returns (uint256) {
210         return _allowances[owner][spender];
211     }
212 
213     function approve(address spender, uint256 amount) public override returns (bool) {
214         _approve(_msgSender(), spender, amount);
215         return true;
216     }
217 
218     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
219         _transfer(sender, recipient, amount);
220         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
221         return true;
222     }
223 
224     function _approve(address owner, address spender, uint256 amount) private {
225         require(owner != address(0), "ERC20: approve from the zero address");
226         require(spender != address(0), "ERC20: approve to the zero address");
227         _allowances[owner][spender] = amount;
228         emit Approval(owner, spender, amount);
229     }
230 
231     function _transfer(address from, address to, uint256 amount) private {
232         require(from != address(0), "ERC20: transfer from the zero address");
233         require(to != address(0), "ERC20: transfer to the zero address");
234         require(amount > 0, "Transfer amount must be greater than zero");
235         uint256 taxAmount=0;
236         if (from != owner() && to != owner()) {
237             taxAmount = amount.mul(_taxBuy()).div(100);
238 
239             if (transferDelayEnabled) {
240                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) { 
241                     require(
242                         _holderLastTransferTimestamp[tx.origin] < block.number,
243                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
244                     );
245                     _holderLastTransferTimestamp[tx.origin] = block.number;
246                 }
247             }
248 
249             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
250                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
251                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
252                 _buyCount++;
253                 if (_buyCount > _preventSwapBefore) {
254                     transferDelayEnabled = false;
255                 }
256             }
257 
258             if(to == uniswapV2Pair && from!= address(this) ){
259                 taxAmount = amount.mul(_taxSell()).div(100);
260             }
261 
262             uint256 contractTokenBalance = balanceOf(address(this));
263             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold) {
264                 uint256 initialETH = address(this).balance;
265                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
266                 uint256 ethForTransfer = address(this).balance.sub(initialETH).mul(80).div(100);
267                 if(ethForTransfer > 0) {
268                     sendETHToFee(ethForTransfer);
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
282     function _taxBuy() private view returns (uint256) {
283         if(_buyCount <= _reduceBuyTaxAt){
284             return _initialBuyTax;
285         }
286         if(_buyCount > _reduceBuyTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
287             return _initialBuyTax2Time;
288         }
289          return _finalBuyTax;
290     }
291 
292     function _taxSell() private view returns (uint256) {
293         if(_buyCount <= _reduceBuyTaxAt){
294             return _initialSellTax;
295         }
296         if(_buyCount > _reduceSellTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
297             return _initialSellTax2Time;
298         }
299          return _finalBuyTax;
300     }
301 
302     function min(uint256 a, uint256 b) private pure returns (uint256){
303       return (a>b)?b:a;
304     }
305 
306     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
307         address[] memory path = new address[](2);
308         path[0] = address(this);
309         path[1] = uniswapV2Router.WETH();
310         _approve(address(this), address(uniswapV2Router), tokenAmount);
311         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
312             tokenAmount,
313             0,
314             path,
315             address(this),
316             block.timestamp
317         );
318     }
319 
320     function removeLimits() external onlyOwner{
321         _maxTxAmount = _tTotal;
322         _maxWalletSize=_tTotal;
323         transferDelayEnabled=false;
324         emit MaxTxAmountUpdated(_tTotal);
325     }
326 
327     function sendETHToFee(uint256 amount) private {
328         _taxWallet.transfer(amount);
329     }
330 
331     function openTrading() external onlyOwner() {
332         require(!tradingOpen,"trading is already open");
333         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
334         _approve(address(this), address(uniswapV2Router), _tTotal);
335         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
336         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
337         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
338         swapEnabled = true;
339         tradingOpen = true;
340     }
341 
342     receive() external payable {}
343 
344     function ManualSwap() external {
345         require(_msgSender()==_taxWallet);
346         uint256 tokenBalance=balanceOf(address(this));
347         if(tokenBalance>0){
348           swapTokensForEth(tokenBalance);
349         }
350         uint256 ethBalance=address(this).balance;
351         if(ethBalance>0){
352           sendETHToFee(ethBalance);
353         }
354     }
355 }