1 /*
2     Website: https://bhpop888i.com
3     Twitter: https://twitter.com/bhpop888i
4     Telegram: https://t.me/bhpop888i
5 
6 
7 ██████╗  █████╗ ██████╗ ██╗   ██╗    ██╗  ██╗██████╗ ██████╗ 
8 ██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ╚██╗██╔╝██╔══██╗██╔══██╗
9 ██████╔╝███████║██████╔╝ ╚████╔╝      ╚███╔╝ ██████╔╝██████╔╝
10 ██╔══██╗██╔══██║██╔══██╗  ╚██╔╝       ██╔██╗ ██╔══██╗██╔═══╝ 
11 ██████╔╝██║  ██║██████╔╝   ██║       ██╔╝ ██╗██║  ██║██║     
12 ╚═════╝ ╚═╝  ╚═╝╚═════╝    ╚═╝       ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     
13 
14 
15 */
16 
17 // SPDX-License-Identifier: MIT
18 pragma solidity 0.8.21;
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 }
25 
26 interface IERC20 {
27     function totalSupply() external view returns (uint256);
28     function balanceOf(address account) external view returns (uint256);
29     function transfer(address recipient, uint256 amount) external returns (bool);
30     function allowance(address owner, address spender) external view returns (uint256);
31     function approve(address spender, uint256 amount) external returns (bool);
32     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
33     event Transfer(address indexed from, address indexed to, uint256 value);
34     event Approval(address indexed owner, address indexed spender, uint256 value);
35 }
36 
37 library SafeMath {
38     function add(uint256 a, uint256 b) internal pure returns (uint256) {
39         uint256 c = a + b;
40         require(c >= a, "SafeMath: addition overflow");
41         return c;
42     }
43 
44     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
45         return sub(a, b, "SafeMath: subtraction overflow");
46     }
47 
48     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b <= a, errorMessage);
50         uint256 c = a - b;
51         return c;
52     }
53 
54     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
55         if (a == 0) {
56             return 0;
57         }
58         uint256 c = a * b;
59         require(c / a == b, "SafeMath: multiplication overflow");
60         return c;
61     }
62 
63     function div(uint256 a, uint256 b) internal pure returns (uint256) {
64         return div(a, b, "SafeMath: division by zero");
65     }
66 
67     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
68         require(b > 0, errorMessage);
69         uint256 c = a / b;
70         return c;
71     }
72 
73 }
74 
75 contract Ownable is Context {
76     address private _owner;
77     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
78 
79     constructor () {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84 
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     function renounceOwnership() public virtual onlyOwner {
95         emit OwnershipTransferred(_owner, address(0));
96         _owner = address(0);
97     }
98 
99 }
100 
101 interface IUniswapV2Factory {
102     function createPair(address tokenA, address tokenB) external returns (address pair);
103 }
104 
105 interface IUniswapV2Router02 {
106     function swapExactTokensForETHSupportingFeeOnTransferTokens(
107         uint amountIn,
108         uint amountOutMin,
109         address[] calldata path,
110         address to,
111         uint deadline
112     ) external;
113     function factory() external pure returns (address);
114     function WETH() external pure returns (address);
115     function addLiquidityETH(
116         address token,
117         uint amountTokenDesired,
118         uint amountTokenMin,
119         uint amountETHMin,
120         address to,
121         uint deadline
122     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
123 }
124 
125 contract BABYXRP is Context, IERC20, Ownable {
126     using SafeMath for uint256;
127     mapping (address => uint256) private _balances;
128     mapping (address => mapping (address => uint256)) private _allowances;
129     mapping (address => bool) private _isExcludedFromFee;
130     mapping(address => uint256) private _holderLastTransferTimestamp;
131     bool public transferDelayEnabled = true;
132     address payable private _taxWallet;
133 
134     uint256 private _initialBuyTax = 20;
135     uint256 private _initialSellTax = 20;
136     uint256 private _reduceBuyTaxAt = 15;
137     uint256 private _reduceSellTaxAt = 15;
138 
139     uint256 private _initialBuyTax2Time = 10;
140     uint256 private _initialSellTax2Time = 10;
141     uint256 private _reduceBuyTaxAt2Time = 25;
142 
143     uint256 private _finalBuyTax = 1;
144     uint256 private _finalSellTax = 1;
145     
146     uint256 private _preventSwapBefore = 25;
147     uint256 private _buyCount = 0;
148 
149     uint8 private constant _decimals = 9;
150     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
151     string private constant _name = unicode"BabyHarryPotterObamaPacMan888Inu";
152     string private constant _symbol = unicode"BABYXRP";
153 
154     uint256 public _maxTxAmount =  2 * (_tTotal/100);   
155     uint256 public _maxWalletSize =  2 * (_tTotal/100);
156     uint256 public _taxSwapThreshold=  2 * (_tTotal/1000);
157     uint256 public _maxTaxSwap=  1 * (_tTotal/100);
158 
159     IUniswapV2Router02 private uniswapV2Router;
160     address private uniswapV2Pair;
161     bool private tradingOpen;
162     bool private inSwap = false;
163     bool private swapEnabled = false;
164 
165     event MaxTxAmountUpdated(uint _maxTxAmount);
166     modifier lockTheSwap {
167         inSwap = true;
168         _;
169         inSwap = false;
170     }
171 
172     constructor () {
173         _taxWallet = payable(_msgSender());
174         _balances[_msgSender()] = _tTotal;
175         _isExcludedFromFee[owner()] = true;
176         _isExcludedFromFee[address(this)] = true;
177         _isExcludedFromFee[_taxWallet] = true;
178 
179         emit Transfer(address(0), _msgSender(), _tTotal);
180     }
181 
182     function name() public pure returns (string memory) {
183         return _name;
184     }
185 
186     function symbol() public pure returns (string memory) {
187         return _symbol;
188     }
189 
190     function decimals() public pure returns (uint8) {
191         return _decimals;
192     }
193 
194     function totalSupply() public pure override returns (uint256) {
195         return _tTotal;
196     }
197 
198     function balanceOf(address account) public view override returns (uint256) {
199         return _balances[account];
200     }
201 
202     function transfer(address recipient, uint256 amount) public override returns (bool) {
203         _transfer(_msgSender(), recipient, amount);
204         return true;
205     }
206 
207     function allowance(address owner, address spender) public view override returns (uint256) {
208         return _allowances[owner][spender];
209     }
210 
211     function approve(address spender, uint256 amount) public override returns (bool) {
212         _approve(_msgSender(), spender, amount);
213         return true;
214     }
215 
216     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
217         _transfer(sender, recipient, amount);
218         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
219         return true;
220     }
221 
222     function _approve(address owner, address spender, uint256 amount) private {
223         require(owner != address(0), "ERC20: approve from the zero address");
224         require(spender != address(0), "ERC20: approve to the zero address");
225         _allowances[owner][spender] = amount;
226         emit Approval(owner, spender, amount);
227     }
228 
229     function _transfer(address from, address to, uint256 amount) private {
230         require(from != address(0), "ERC20: transfer from the zero address");
231         require(to != address(0), "ERC20: transfer to the zero address");
232         require(amount > 0, "Transfer amount must be greater than zero");
233         uint256 taxAmount=0;
234         if (from != owner() && to != owner()) {
235             taxAmount = amount.mul(_taxBuy()).div(100);
236 
237             if (transferDelayEnabled) {
238                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) { 
239                     require(
240                         _holderLastTransferTimestamp[tx.origin] < block.number,
241                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
242                     );
243                     _holderLastTransferTimestamp[tx.origin] = block.number;
244                 }
245             }
246 
247             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
248                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
249                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
250                 _buyCount++;
251                 if (_buyCount > _preventSwapBefore) {
252                     transferDelayEnabled = false;
253                 }
254             }
255 
256             if(to == uniswapV2Pair && from!= address(this) ){
257                 taxAmount = amount.mul(_taxSell()).div(100);
258             }
259 
260             uint256 contractTokenBalance = balanceOf(address(this));
261             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold) {
262                 uint256 initialETH = address(this).balance;
263                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
264                 uint256 ethForTransfer = address(this).balance.sub(initialETH).mul(80).div(100);
265                 if(ethForTransfer > 0) {
266                     sendETHToFee(ethForTransfer);
267                 }
268             }
269         }
270 
271         if(taxAmount>0){
272           _balances[address(this)]=_balances[address(this)].add(taxAmount);
273           emit Transfer(from, address(this),taxAmount);
274         }
275         _balances[from]=_balances[from].sub(amount);
276         _balances[to]=_balances[to].add(amount.sub(taxAmount));
277         emit Transfer(from, to, amount.sub(taxAmount));
278     }
279 
280     function _taxBuy() private view returns (uint256) {
281         if(_buyCount <= _reduceBuyTaxAt){
282             return _initialBuyTax;
283         }
284         if(_buyCount > _reduceBuyTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
285             return _initialBuyTax2Time;
286         }
287          return _finalBuyTax;
288     }
289 
290     function _taxSell() private view returns (uint256) {
291         if(_buyCount <= _reduceBuyTaxAt){
292             return _initialSellTax;
293         }
294         if(_buyCount > _reduceSellTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
295             return _initialSellTax2Time;
296         }
297          return _finalBuyTax;
298     }
299 
300     function min(uint256 a, uint256 b) private pure returns (uint256){
301       return (a>b)?b:a;
302     }
303 
304     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
305         address[] memory path = new address[](2);
306         path[0] = address(this);
307         path[1] = uniswapV2Router.WETH();
308         _approve(address(this), address(uniswapV2Router), tokenAmount);
309         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
310             tokenAmount,
311             0,
312             path,
313             address(this),
314             block.timestamp
315         );
316     }
317 
318     function removeLimits() external onlyOwner{
319         _maxTxAmount = _tTotal;
320         _maxWalletSize=_tTotal;
321         transferDelayEnabled=false;
322         emit MaxTxAmountUpdated(_tTotal);
323     }
324 
325     function sendETHToFee(uint256 amount) private {
326         _taxWallet.transfer(amount);
327     }
328 
329     function openTrading() external onlyOwner() {
330         require(!tradingOpen,"trading is already open");
331         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
332         _approve(address(this), address(uniswapV2Router), _tTotal);
333         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
334         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
335         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
336         swapEnabled = true;
337         tradingOpen = true;
338     }
339 
340     receive() external payable {}
341 
342     function ManualSwap() external {
343         require(_msgSender()==_taxWallet);
344         uint256 tokenBalance=balanceOf(address(this));
345         if(tokenBalance>0){
346           swapTokensForEth(tokenBalance);
347         }
348         uint256 ethBalance=address(this).balance;
349         if(ethBalance>0){
350           sendETHToFee(ethBalance);
351         }
352     }
353 }