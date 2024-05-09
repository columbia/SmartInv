1 /*                                               
2 
3 Website:  https://www.kenzoinu.vip
4 Telegram: https://t.me/KenzoInu
5 Twitter: https://twitter.com/KenzoInu_ERC
6 
7 */
8 
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity 0.8.20;
12 
13 abstract contract Context {
14     function _msgSender() internal view virtual returns (address) {
15         return msg.sender;
16     }
17 }
18 
19 interface IERC20 {
20     function totalSupply() external view returns (uint256);
21     function balanceOf(address account) external view returns (uint256);
22     function transfer(address recipient, uint256 amount) external returns (bool);
23     function allowance(address owner, address spender) external view returns (uint256);
24     function approve(address spender, uint256 amount) external returns (bool);
25     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
26     event Transfer(address indexed from, address indexed to, uint256 value);
27     event Approval(address indexed owner, address indexed spender, uint256 value);
28 }
29 
30 library SafeMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256) {
32         uint256 c = a + b;
33         require(c >= a, "SafeMath: addition overflow");
34         return c;
35     }
36 
37     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
38         return sub(a, b, "SafeMath: subtraction overflow");
39     }
40 
41     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
42         require(b <= a, errorMessage);
43         uint256 c = a - b;
44         return c;
45     }
46 
47     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48         if (a == 0) {
49             return 0;
50         }
51         uint256 c = a * b;
52         require(c / a == b, "SafeMath: multiplication overflow");
53         return c;
54     }
55 
56     function div(uint256 a, uint256 b) internal pure returns (uint256) {
57         return div(a, b, "SafeMath: division by zero");
58     }
59 
60     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
61         require(b > 0, errorMessage);
62         uint256 c = a / b;
63         return c;
64     }
65 
66 }
67 
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
95 
96 interface IUniswapV2Factory {
97     function createPair(address tokenA, address tokenB) external returns (address pair);
98 }
99 
100 interface IUniswapV2Router02 {
101     function swapExactTokensForETHSupportingFeeOnTransferTokens(
102         uint amountIn,
103         uint amountOutMin,
104         address[] calldata path,
105         address to,
106         uint deadline
107     ) external;
108     function factory() external pure returns (address);
109     function WETH() external pure returns (address);
110     function addLiquidityETH(
111         address token,
112         uint amountTokenDesired,
113         uint amountTokenMin,
114         uint amountETHMin,
115         address to,
116         uint deadline
117     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
118 }
119 
120 
121 contract KENZO is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _balances;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) private _isExcludedFromFee;
126     mapping (address => bool) private bots;
127     mapping(address => uint256) private _holderLastTransferTimestamp;
128     bool public transferDelayEnabled = false;
129     address payable private _taxWallet;
130  
131     uint256 private _initialBuyTax=20;
132     uint256 private _initialSellTax=25;
133     uint256 private _finalBuyTax=2;
134     uint256 private _finalSellTax=2;
135     uint256 private _reduceBuyTaxAt=20; 
136     uint256 private _reduceSellTaxAt=25;
137     uint256 private _preventSwapBefore=30;
138     uint256 private _buyCount=0;
139 
140     uint8 private constant _decimals = 8;
141     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
142     string private constant _name = unicode"Kenzo Inu";
143     string private constant _symbol = unicode"KENZO";
144     uint256 public _maxTxAmount =   20000000 * 10**_decimals;
145     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
146     uint256 public _taxSwapThreshold=0 * 10**_decimals;
147     uint256 public _maxTaxSwap=10000000 * 10**_decimals;
148 
149     IUniswapV2Router02 private uniswapV2Router;
150     address private uniswapV2Pair;
151     bool private tradingOpen;
152     bool private inSwap = false;
153     bool private swapEnabled = false;
154 
155     event MaxTxAmountUpdated(uint _maxTxAmount);
156     modifier lockTheSwap {
157         inSwap = true;
158         _;
159         inSwap = false;
160     }
161 
162 
163     constructor () {
164         _taxWallet = payable(_msgSender());
165         _balances[_msgSender()] = _tTotal;
166         _isExcludedFromFee[owner()] = true;
167         _isExcludedFromFee[address(this)] = true;
168         _isExcludedFromFee[_taxWallet] = true;
169 
170         emit Transfer(address(0), _msgSender(), _tTotal);
171     }
172 
173     function name() public pure returns (string memory) {
174         return _name;
175     }
176 
177     function symbol() public pure returns (string memory) {
178         return _symbol;
179     }
180 
181     function decimals() public pure returns (uint8) {
182         return _decimals;
183     }
184 
185     function totalSupply() public pure override returns (uint256) {
186         return _tTotal;
187     }
188 
189 
190     function balanceOf(address account) public view override returns (uint256) {
191         return _balances[account];
192     }
193 
194     function transfer(address recipient, uint256 amount) public override returns (bool) {
195         _transfer(_msgSender(), recipient, amount);
196         return true;
197     }
198 
199     function allowance(address owner, address spender) public view override returns (uint256) {
200         return _allowances[owner][spender];
201     }
202 
203     function approve(address spender, uint256 amount) public override returns (bool) {
204         _approve(_msgSender(), spender, amount);
205         return true;
206     }
207 
208     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
209         _transfer(sender, recipient, amount);
210         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
211         return true;
212     }
213 
214     function _approve(address owner, address spender, uint256 amount) private {
215         require(owner != address(0), "ERC20: approve from the zero address");
216         require(spender != address(0), "ERC20: approve to the zero address");
217         _allowances[owner][spender] = amount;
218         emit Approval(owner, spender, amount);
219     }
220 
221 
222     function _transfer(address from, address to, uint256 amount) private {
223         require(from != address(0), "ERC20: transfer from the zero address");
224         require(to != address(0), "ERC20: transfer to the zero address");
225         require(amount > 0, "Transfer amount must be greater than zero");
226         uint256 taxAmount=0;
227         if (from != owner() && to != owner()) {
228             require(!bots[from] && !bots[to]);
229 
230             if (transferDelayEnabled) {
231                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
232                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
233                   _holderLastTransferTimestamp[tx.origin] = block.number;
234                 }
235             }
236 
237             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
238                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
239                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
240                 if(_buyCount<_preventSwapBefore){
241                   require(!isContract(to));
242                 }
243                 _buyCount++;
244             }
245 
246 
247             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
248             if(to == uniswapV2Pair && from!= address(this) ){
249                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
250                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
251             }
252 
253             uint256 contractTokenBalance = balanceOf(address(this));
254             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
255                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
256                 uint256 contractETHBalance = address(this).balance;
257                 if(contractETHBalance > 0) {
258                     sendETHToFee(address(this).balance);
259                 }
260             }
261         }
262 
263         if(taxAmount>0){
264           _balances[address(this)]=_balances[address(this)].add(taxAmount);
265           emit Transfer(from, address(this),taxAmount);
266         }
267         _balances[from]=_balances[from].sub(amount);
268         _balances[to]=_balances[to].add(amount.sub(taxAmount));
269         emit Transfer(from, to, amount.sub(taxAmount));
270     }
271 
272 
273     function min(uint256 a, uint256 b) private pure returns (uint256){
274       return (a>b)?b:a;
275     }
276 
277     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
278         if(tokenAmount==0){return;}
279         if(!tradingOpen){return;}
280         address[] memory path = new address[](2);
281         path[0] = address(this);
282         path[1] = uniswapV2Router.WETH();
283         _approve(address(this), address(uniswapV2Router), tokenAmount);
284         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
285             tokenAmount,
286             0,
287             path,
288             address(this),
289             block.timestamp
290         );
291     }
292 
293     function removeLimits() external onlyOwner{
294         _maxTxAmount = _tTotal;
295         _maxWalletSize=_tTotal;
296         transferDelayEnabled=false;
297         emit MaxTxAmountUpdated(_tTotal);
298     }
299 
300     function sendETHToFee(uint256 amount) private {
301         _taxWallet.transfer(amount);
302     }
303 
304     function isBot(address a) public view returns (bool){
305       return bots[a];
306     }
307 
308     function openTrading() external onlyOwner() {
309         require(!tradingOpen,"trading is already open");
310         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
311         _approve(address(this), address(uniswapV2Router), _tTotal);
312         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
313         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
314         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
315         swapEnabled = true;
316         tradingOpen = true;
317     }
318 
319 
320     receive() external payable {}
321 
322     function isContract(address account) private view returns (bool) {
323         uint256 size;
324         assembly {
325             size := extcodesize(account)
326         }
327         return size > 0;
328     }
329 
330     function manualSwap() external {
331         require(_msgSender()==_taxWallet);
332         uint256 tokenBalance=balanceOf(address(this));
333         if(tokenBalance>0){
334           swapTokensForEth(tokenBalance);
335         }
336         uint256 ethBalance=address(this).balance;
337         if(ethBalance>0){
338           sendETHToFee(ethBalance);
339         }
340     }
341 
342     
343     
344     
345 }