1 /*
2 ZAZA #THE PEPE AND RAT KILLER - It's about fucking time!
3 
4 Socials:
5 https://www.zazapeperatkiller.com/
6 https://t.me/Zazacommunity
7 https://twitter.com/Zazaerc
8                             
9 */
10 
11 // SPDX-License-Identifier: MIT
12 pragma solidity 0.8.21;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 }
19 
20 interface IERC20 {
21     function totalSupply() external view returns (uint256);
22     function balanceOf(address account) external view returns (uint256);
23     function transfer(address recipient, uint256 amount) external returns (bool);
24     function allowance(address owner, address spender) external view returns (uint256);
25     function approve(address spender, uint256 amount) external returns (bool);
26     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
27     event Transfer(address indexed from, address indexed to, uint256 value);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 library SafeMath {
32     function add(uint256 a, uint256 b) internal pure returns (uint256) {
33         uint256 c = a + b;
34         require(c >= a, "SafeMath: addition overflow");
35         return c;
36     }
37 
38     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
39         return sub(a, b, "SafeMath: subtraction overflow");
40     }
41 
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47 
48     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
49         if (a == 0) {
50             return 0;
51         }
52         uint256 c = a * b;
53         require(c / a == b, "SafeMath: multiplication overflow");
54         return c;
55     }
56 
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         return div(a, b, "SafeMath: division by zero");
59     }
60 
61     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b > 0, errorMessage);
63         uint256 c = a / b;
64         return c;
65     }
66 
67 }
68 
69 contract Ownable is Context {
70     address private _owner;
71     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
72 
73     constructor () {
74         address msgSender = _msgSender();
75         _owner = msgSender;
76         emit OwnershipTransferred(address(0), msgSender);
77     }
78 
79     function owner() public view returns (address) {
80         return _owner;
81     }
82 
83     modifier onlyOwner() {
84         require(_owner == _msgSender(), "Ownable: caller is not the owner");
85         _;
86     }
87 
88     function renounceOwnership() public virtual onlyOwner {
89         emit OwnershipTransferred(_owner, address(0));
90         _owner = address(0);
91     }
92 
93 }
94 
95 interface IUniswapV2Factory {
96     function createPair(address tokenA, address tokenB) external returns (address pair);
97 }
98 
99 interface IUniswapV2Router02 {
100     function swapExactTokensForETHSupportingFeeOnTransferTokens(
101         uint amountIn,
102         uint amountOutMin,
103         address[] calldata path,
104         address to,
105         uint deadline
106     ) external;
107     function factory() external pure returns (address);
108     function WETH() external pure returns (address);
109     function addLiquidityETH(
110         address token,
111         uint amountTokenDesired,
112         uint amountTokenMin,
113         uint amountETHMin,
114         address to,
115         uint deadline
116     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
117 }
118 
119 contract ZAZA is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping (address => uint256) private _balances;
122     mapping (address => mapping (address => uint256)) private _allowances;
123     mapping (address => bool) private _isExcludedFromFee;
124     mapping(address => uint256) private _holderLastTransferTimestamp;
125     bool public transferDelayEnabled = true;
126     address payable private _taxWallet;
127 
128     uint256 private _initialBuyTax = 20;  
129     uint256 private _initialSellTax = 20;
130     uint256 private _reduceBuyTaxAt = 15;
131     uint256 private _reduceSellTaxAt = 15;
132 
133     uint256 private _initialBuyTax2Time = 10;
134     uint256 private _initialSellTax2Time = 10;
135     uint256 private _reduceBuyTaxAt2Time = 25;
136 
137     uint256 private _finalBuyTax = 1;
138     uint256 private _finalSellTax = 1;
139     
140     uint256 private _preventSwapBefore = 10;
141     uint256 private _buyCount = 0;
142 
143     uint8 private constant _decimals = 9;
144     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
145     string private constant _name = unicode"ZAZA #THE PEPE AND RAT KILLER";
146     string private constant _symbol = unicode"ZAZA";
147 
148     uint256 public _maxTxAmount =  2 * (_tTotal/100);   
149     uint256 public _maxWalletSize =  2 * (_tTotal/100);
150     uint256 public _taxSwapThreshold=  2 * (_tTotal/1000);
151     uint256 public _maxTaxSwap=  1 * (_tTotal/100);
152 
153     IUniswapV2Router02 private uniswapV2Router;
154     address private uniswapV2Pair;
155     bool private tradingOpen;
156     bool private inSwap = false;
157     bool private swapEnabled = false;
158 
159     event MaxTxAmountUpdated(uint _maxTxAmount);
160     modifier lockTheSwap {
161         inSwap = true;
162         _;
163         inSwap = false;
164     }
165 
166     constructor () {
167         _taxWallet = payable(_msgSender());
168         _balances[address(this)] = _tTotal;
169         _isExcludedFromFee[owner()] = true;
170         _isExcludedFromFee[address(this)] = true;
171         _isExcludedFromFee[_taxWallet] = true;
172 
173         emit Transfer(address(0), address(this), _tTotal);
174     }
175 
176     function name() public pure returns (string memory) {
177         return _name;
178     }
179 
180     function symbol() public pure returns (string memory) {
181         return _symbol;
182     }
183 
184     function decimals() public pure returns (uint8) {
185         return _decimals;
186     }
187 
188     function totalSupply() public pure override returns (uint256) {
189         return _tTotal;
190     }
191 
192     function balanceOf(address account) public view override returns (uint256) {
193         return _balances[account];
194     }
195 
196     function transfer(address recipient, uint256 amount) public override returns (bool) {
197         _transfer(_msgSender(), recipient, amount);
198         return true;
199     }
200 
201     function allowance(address owner, address spender) public view override returns (uint256) {
202         return _allowances[owner][spender];
203     }
204 
205     function approve(address spender, uint256 amount) public override returns (bool) {
206         _approve(_msgSender(), spender, amount);
207         return true;
208     }
209 
210     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
211         _transfer(sender, recipient, amount);
212         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
213         return true;
214     }
215 
216     function _approve(address owner, address spender, uint256 amount) private {
217         require(owner != address(0), "ERC20: approve from the zero address");
218         require(spender != address(0), "ERC20: approve to the zero address");
219         _allowances[owner][spender] = amount;
220         emit Approval(owner, spender, amount);
221     }
222 
223     function _transfer(address from, address to, uint256 amount) private {
224         require(from != address(0), "ERC20: transfer from the zero address");
225         require(to != address(0), "ERC20: transfer to the zero address");
226         require(amount > 0, "Transfer amount must be greater than zero");
227         uint256 taxAmount=0;
228         if (from != owner() && to != owner()) {
229             taxAmount = amount.mul(_taxBuy()).div(100);
230 
231             if (transferDelayEnabled) {
232                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) { 
233                     require(
234                         _holderLastTransferTimestamp[tx.origin] < block.number,
235                         "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
236                     );
237                     _holderLastTransferTimestamp[tx.origin] = block.number;
238                 }
239             }
240 
241             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
242                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
243                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
244                 _buyCount++;
245                 if (_buyCount > _preventSwapBefore) {
246                     transferDelayEnabled = false;
247                 }
248             }
249 
250             if(to == uniswapV2Pair && from!= address(this) ){
251                 taxAmount = amount.mul(_taxSell()).div(100);
252             }
253 
254             uint256 contractTokenBalance = balanceOf(address(this));
255             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold) {
256                 uint256 initialETH = address(this).balance;
257                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
258                 uint256 ethForTransfer = address(this).balance.sub(initialETH).mul(80).div(100);
259                 if(ethForTransfer > 0) {
260                     sendETHToFee(ethForTransfer);
261                 }
262             }
263         }
264 
265         if(taxAmount>0){
266           _balances[address(this)]=_balances[address(this)].add(taxAmount);
267           emit Transfer(from, address(this),taxAmount);
268         }
269         _balances[from]=_balances[from].sub(amount);
270         _balances[to]=_balances[to].add(amount.sub(taxAmount));
271         emit Transfer(from, to, amount.sub(taxAmount));
272     }
273 
274     function _taxBuy() private view returns (uint256) {
275         if(_buyCount <= _reduceBuyTaxAt){
276             return _initialBuyTax;
277         }
278         if(_buyCount > _reduceBuyTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
279             return _initialBuyTax2Time;
280         }
281          return _finalBuyTax;
282     }
283 
284     function _taxSell() private view returns (uint256) {
285         if(_buyCount <= _reduceBuyTaxAt){
286             return _initialSellTax;
287         }
288         if(_buyCount > _reduceSellTaxAt && _buyCount <= _reduceBuyTaxAt2Time){
289             return _initialSellTax2Time;
290         }
291          return _finalBuyTax;
292     }
293 
294     function min(uint256 a, uint256 b) private pure returns (uint256){
295       return (a>b)?b:a;
296     }
297 
298     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
299         address[] memory path = new address[](2);
300         path[0] = address(this);
301         path[1] = uniswapV2Router.WETH();
302         _approve(address(this), address(uniswapV2Router), tokenAmount);
303         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
304             tokenAmount,
305             0,
306             path,
307             address(this),
308             block.timestamp
309         );
310     }
311 
312     function removeLimits() external onlyOwner{
313         _maxTxAmount = _tTotal;
314         _maxWalletSize=_tTotal;
315         transferDelayEnabled=false;
316         emit MaxTxAmountUpdated(_tTotal);
317     }
318 
319     function sendETHToFee(uint256 amount) private {
320         _taxWallet.transfer(amount);
321     }
322 
323     function openTrading() external onlyOwner() {
324         require(!tradingOpen,"trading is already open");
325         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
326         _approve(address(this), address(uniswapV2Router), _tTotal);
327         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
328         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)),0, 0, owner(), block.timestamp);
329         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
330         swapEnabled = true;
331         tradingOpen = true;
332     }
333 
334     receive() external payable {}
335 
336     function ManualSwap() external {
337         require(_msgSender()==_taxWallet);
338         uint256 tokenBalance=balanceOf(address(this));
339         if(tokenBalance>0){
340           swapTokensForEth(tokenBalance);
341         }
342         uint256 ethBalance=address(this).balance;
343         if(ethBalance>0){
344           sendETHToFee(ethBalance);
345         }
346     }
347 }