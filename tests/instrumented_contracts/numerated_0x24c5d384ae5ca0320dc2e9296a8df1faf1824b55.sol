1 /**
2 // SPDX-License-Identifier: UNLICENSED
3 
4 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
5 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
6 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
7 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
8 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
9 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
10 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
11 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
12 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
13 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
14 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
15 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
16 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
17 ππππππππππππππππππππππππhttps://t.me/Token_314159ππππππππππππππππππππππππππππππππππ
18 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
19 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
20 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
21 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
22 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
23 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
24 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
25 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
26 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
27 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
28 πππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππππ
29 
30 */
31 pragma solidity 0.8.18;
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
137 contract Token is Context, IERC20, Ownable {
138     using SafeMath for uint256;
139     mapping (address => uint256) private _balances;
140     mapping (address => mapping (address => uint256)) private _allowances;
141     mapping (address => bool) private _isExcludedFromFee;
142     mapping (address => bool) private bots;
143     mapping(address => uint256) private _holderLastTransferTimestamp;
144     bool public transferDelayEnabled = true;
145     address payable private _taxWallet;
146 
147     uint256 private _initialBuyTax=20;
148     uint256 private _initialSellTax=20;
149     uint256 private _finalBuyTax=1;
150     uint256 private _finalSellTax=1;
151     uint256 private _reduceBuyTaxAt=20;
152     uint256 private _reduceSellTaxAt=20;
153     uint256 private _preventSwapBefore=20;
154     uint256 private _buyCount=0;
155 
156     uint8 private constant _decimals = 9;
157     uint256 private constant _tTotal = 314159265358979 * 10**_decimals;
158     string private constant _name = unicode"3.14159265358979323846264338327950288419";
159     string private constant _symbol = unicode"π";
160     uint256 public _maxTxAmount = 6283185307179 * 10**_decimals;
161     uint256 public _maxWalletSize = 6283185307179 * 10**_decimals;
162     uint256 public _taxSwapThreshold= 3141592653589 * 10**_decimals;
163     uint256 public _maxTaxSwap= 3141592653589 * 10**_decimals;
164 
165     IUniswapV2Router02 private uniswapV2Router;
166     address private uniswapV2Pair;
167     bool private tradingOpen;
168     bool private inSwap = false;
169     bool private swapEnabled = false;
170 
171     event MaxTxAmountUpdated(uint _maxTxAmount);
172     modifier lockTheSwap {
173         inSwap = true;
174         _;
175         inSwap = false;
176     }
177 
178     constructor () {
179         _taxWallet = payable(_msgSender());
180         _balances[_msgSender()] = _tTotal;
181         _isExcludedFromFee[owner()] = true;
182         _isExcludedFromFee[address(this)] = true;
183         _isExcludedFromFee[_taxWallet] = true;
184 
185         emit Transfer(address(0), _msgSender(), _tTotal);
186     }
187 
188     function name() public pure returns (string memory) {
189         return _name;
190     }
191 
192     function symbol() public pure returns (string memory) {
193         return _symbol;
194     }
195 
196     function decimals() public pure returns (uint8) {
197         return _decimals;
198     }
199 
200     function totalSupply() public pure override returns (uint256) {
201         return _tTotal;
202     }
203 
204     function balanceOf(address account) public view override returns (uint256) {
205         return _balances[account];
206     }
207 
208     function transfer(address recipient, uint256 amount) public override returns (bool) {
209         _transfer(_msgSender(), recipient, amount);
210         return true;
211     }
212 
213     function allowance(address owner, address spender) public view override returns (uint256) {
214         return _allowances[owner][spender];
215     }
216 
217     function approve(address spender, uint256 amount) public override returns (bool) {
218         _approve(_msgSender(), spender, amount);
219         return true;
220     }
221 
222     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
223         _transfer(sender, recipient, amount);
224         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
225         return true;
226     }
227 
228     function _approve(address owner, address spender, uint256 amount) private {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231         _allowances[owner][spender] = amount;
232         emit Approval(owner, spender, amount);
233     }
234 
235     function _transfer(address from, address to, uint256 amount) private {
236         require(from != address(0), "ERC20: transfer from the zero address");
237         require(to != address(0), "ERC20: transfer to the zero address");
238         require(amount > 0, "Transfer amount must be greater than zero");
239         uint256 taxAmount=0;
240         if (from != owner() && to != owner()) {
241             require(!bots[from] && !bots[to]);
242             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
243 
244             if (transferDelayEnabled) {
245                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
246                       require(
247                           _holderLastTransferTimestamp[tx.origin] <
248                               block.number,
249                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
250                       );
251                       _holderLastTransferTimestamp[tx.origin] = block.number;
252                   }
253               }
254 
255             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
256                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
257                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
258                 _buyCount++;
259             }
260 
261             if(to == uniswapV2Pair && from!= address(this) ){
262                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
263             }
264 
265             uint256 contractTokenBalance = balanceOf(address(this));
266             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
267                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
268                 uint256 contractETHBalance = address(this).balance;
269                 if(contractETHBalance > 0) {
270                     sendETHToFee(address(this).balance);
271                 }
272             }
273         }
274 
275         if(taxAmount>0){
276           _balances[address(this)]=_balances[address(this)].add(taxAmount);
277           emit Transfer(from, address(this),taxAmount);
278         }
279         _balances[from]=_balances[from].sub(amount);
280         _balances[to]=_balances[to].add(amount.sub(taxAmount));
281         emit Transfer(from, to, amount.sub(taxAmount));
282     }
283 
284 
285     function min(uint256 a, uint256 b) private pure returns (uint256){
286       return (a>b)?b:a;
287     }
288 
289     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
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
314     function addBots(address[] memory bots_) public onlyOwner {
315         for (uint i = 0; i < bots_.length; i++) {
316             bots[bots_[i]] = true;
317         }
318     }
319 
320     function delBots(address[] memory notbot) public onlyOwner {
321       for (uint i = 0; i < notbot.length; i++) {
322           bots[notbot[i]] = false;
323       }
324     }
325 
326     function isBot(address a) public view returns (bool){
327       return bots[a];
328     }
329 
330     function openTrading() external onlyOwner() {
331         require(!tradingOpen,"trading is already open");
332         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
333         _approve(address(this), address(uniswapV2Router), _tTotal);
334         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
335         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
336         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
337         swapEnabled = true;
338         tradingOpen = true;
339     }
340 
341     
342     function reduceFee(uint256 _newFee) external{
343       require(_msgSender()==_taxWallet);
344       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
345       _finalBuyTax=_newFee;
346       _finalSellTax=_newFee;
347     }
348 
349     receive() external payable {}
350 
351     function manualSwap() external {
352         require(_msgSender()==_taxWallet);
353         uint256 tokenBalance=balanceOf(address(this));
354         if(tokenBalance>0){
355           swapTokensForEth(tokenBalance);
356         }
357         uint256 ethBalance=address(this).balance;
358         if(ethBalance>0){
359           sendETHToFee(ethBalance);
360         }
361     }
362 }