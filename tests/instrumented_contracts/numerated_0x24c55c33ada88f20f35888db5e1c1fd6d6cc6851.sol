1 // SPDX-License-Identifier: NONE
2 
3 // pepecash.io
4 
5 pragma solidity 0.8.19;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 }
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 }
61 
62 contract Ownable is Context {
63     address private _owner;
64 
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     constructor() {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 }
87 
88 interface IUniswapV2Factory {
89     function createPair(address tokenA, address tokenB) external returns (address pair);
90 }
91 
92 interface IUniswapV2Router02 {
93     function swapExactTokensForETHSupportingFeeOnTransferTokens(
94         uint256 amountIn,
95         uint256 amountOutMin,
96         address[] calldata path,
97         address to,
98         uint256 deadline
99     ) external;
100     function factory() external pure returns (address);
101     function WETH() external pure returns (address);
102     function addLiquidityETH(
103         address token,
104         uint256 amountTokenDesired,
105         uint256 amountTokenMin,
106         uint256 amountETHMin,
107         address to,
108         uint256 deadline
109     ) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);
110 }
111 
112 contract PepeCashToken is Context, IERC20, Ownable {
113     using SafeMath for uint256;
114 
115     mapping(address => uint256) private _balances;
116     mapping(address => mapping(address => uint256)) private _allowances;
117     mapping(address => bool) private _isExcludedFromFee;
118     mapping(address => bool) private bots;
119     mapping(address => uint256) private _holderLastTransferTimestamp;
120     bool public transferDelayEnabled = false;
121     address payable private _taxWallet;
122 
123     uint256 private _initialBuyTax = 0;
124     uint256 private _initialSellTax = 0;
125     uint256 private _finalBuyTax = 0;
126     uint256 private _finalSellTax = 0;
127     uint256 public _reduceBuyTaxAt = 0;
128     uint256 public _reduceSellTaxAt = 0;
129     uint256 private _preventSwapBefore = 30;
130     uint256 private _buyCount = 0;
131 
132     uint8 private constant _decimals = 18;
133     uint256 private constant _tTotal = 420690000000000 * 10 ** _decimals;
134     string private constant _name = unicode"PepeCash";
135     string private constant _symbol = unicode"PCH";
136     uint256 public _maxTxAmount = 841380000000 * 10 ** _decimals; // 0.2%
137     uint256 public _maxWalletSize = 841380000000 * 10 ** _decimals;
138     uint256 public _taxSwapThreshold = 210345000000 * 10 ** _decimals;
139     uint256 public _maxTaxSwap = 210345000000 * 10 ** _decimals;
140 
141     IUniswapV2Router02 private uniswapV2Router;
142     address private uniswapV2Pair;
143     bool private tradingOpen;
144     bool private inSwap = false;
145     bool private swapEnabled = false;
146 
147     event MaxTxAmountUpdated(uint256 _maxTxAmount);
148 
149     modifier lockTheSwap() {
150         inSwap = true;
151         _;
152         inSwap = false;
153     }
154 
155     constructor() {
156         _taxWallet = payable(_msgSender());
157         _balances[_msgSender()] = _tTotal;
158         _isExcludedFromFee[owner()] = true;
159         _isExcludedFromFee[address(this)] = true;
160         _isExcludedFromFee[_taxWallet] = true;
161 
162         emit Transfer(address(0), _msgSender(), _tTotal);
163     }
164 
165     function name() public pure returns (string memory) {
166         return _name;
167     }
168 
169     function symbol() public pure returns (string memory) {
170         return _symbol;
171     }
172 
173     function decimals() public pure returns (uint8) {
174         return _decimals;
175     }
176 
177     function totalSupply() public pure override returns (uint256) {
178         return _tTotal;
179     }
180 
181     function balanceOf(address account) public view override returns (uint256) {
182         return _balances[account];
183     }
184 
185     function transfer(address recipient, uint256 amount) public override returns (bool) {
186         _transfer(_msgSender(), recipient, amount);
187         return true;
188     }
189 
190     function allowance(address owner, address spender) public view override returns (uint256) {
191         return _allowances[owner][spender];
192     }
193 
194     function approve(address spender, uint256 amount) public override returns (bool) {
195         _approve(_msgSender(), spender, amount);
196         return true;
197     }
198 
199     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
200         _transfer(sender, recipient, amount);
201         _approve(
202             sender,
203             _msgSender(),
204             _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance")
205         );
206         return true;
207     }
208 
209     function _approve(address owner, address spender, uint256 amount) private {
210         require(owner != address(0), "ERC20: approve from the zero address");
211         require(spender != address(0), "ERC20: approve to the zero address");
212         _allowances[owner][spender] = amount;
213         emit Approval(owner, spender, amount);
214     }
215 
216     function _transfer(address from, address to, uint256 amount) private {
217         require(from != address(0), "ERC20: transfer from the zero address");
218         require(to != address(0), "ERC20: transfer to the zero address");
219         require(amount > 0, "Transfer amount must be greater than zero");
220         uint256 taxAmount = 0;
221         if (from != owner() && to != owner()) {
222             require(!bots[from] && !bots[to]);
223 
224             if (transferDelayEnabled) {
225                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
226                     require(
227                         _holderLastTransferTimestamp[tx.origin] < block.number, "Only one transfer per block allowed."
228                     );
229                     _holderLastTransferTimestamp[tx.origin] = block.number;
230                 }
231             }
232 
233             if (from == uniswapV2Pair && to != address(uniswapV2Router) && !_isExcludedFromFee[to]) {
234                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
235                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
236                 _buyCount++;
237             }
238 
239             taxAmount = amount.mul((_buyCount > _reduceBuyTaxAt) ? _finalBuyTax : _initialBuyTax).div(100);
240             if (to == uniswapV2Pair && from != address(this)) {
241                 taxAmount = amount.mul((_buyCount > _reduceSellTaxAt) ? _finalSellTax : _initialSellTax).div(100);
242             }
243 
244             uint256 contractTokenBalance = balanceOf(address(this));
245             if (
246                 !inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance > _taxSwapThreshold
247                     && _buyCount > _preventSwapBefore
248             ) {
249                 swapTokensForEth(min(amount, min(contractTokenBalance, _maxTaxSwap)));
250                 uint256 contractETHBalance = address(this).balance;
251                 if (contractETHBalance > 0) {
252                     sendETHToFee(address(this).balance);
253                 }
254             }
255         }
256 
257         if (taxAmount > 0) {
258             _balances[address(this)] = _balances[address(this)].add(taxAmount);
259             emit Transfer(from, address(this), taxAmount);
260         }
261         _balances[from] = _balances[from].sub(amount);
262         _balances[to] = _balances[to].add(amount.sub(taxAmount));
263         emit Transfer(from, to, amount.sub(taxAmount));
264     }
265 
266     function min(uint256 a, uint256 b) private pure returns (uint256) {
267         return (a > b) ? b : a;
268     }
269 
270     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
271         if (tokenAmount == 0) return;
272         if (!tradingOpen) return;
273         address[] memory path = new address[](2);
274         path[0] = address(this);
275         path[1] = uniswapV2Router.WETH();
276         _approve(address(this), address(uniswapV2Router), tokenAmount);
277         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
278             tokenAmount, 0, path, address(this), block.timestamp
279         );
280     }
281 
282     function removeLimits() external onlyOwner {
283         _maxTxAmount = _tTotal;
284         _maxWalletSize = _tTotal;
285         transferDelayEnabled = false;
286         emit MaxTxAmountUpdated(_tTotal);
287     }
288 
289     function sendETHToFee(uint256 amount) private {
290         _taxWallet.transfer(amount);
291     }
292 
293     function isBot(address a) public view returns (bool) {
294         return bots[a];
295     }
296 
297     function PepeCashBirth() external onlyOwner {
298         require(!tradingOpen, "trading is already open");
299         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
300         _approve(address(this), address(uniswapV2Router), _tTotal);
301         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
302         uniswapV2Router.addLiquidityETH{value: address(this).balance}(
303             address(this), balanceOf(address(this)), 0, 0, owner(), block.timestamp
304         );
305         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint256).max);
306         tradingOpen = true;
307     }
308 
309     receive() external payable {}
310 
311     function manualSwap() external {
312         require(_msgSender() == _taxWallet);
313         uint256 tokenBalance = balanceOf(address(this));
314         if (tokenBalance > 0) {
315             swapTokensForEth(tokenBalance);
316         }
317         uint256 ethBalance = address(this).balance;
318         if (ethBalance > 0) {
319             sendETHToFee(ethBalance);
320         }
321     }
322 
323     function setReduceSellTaxAt(uint256 value) public onlyOwner {
324     require(value >= 0, "Invalid value");
325     _reduceSellTaxAt = value;
326     }
327 
328     function setReduceBuyTaxAt(uint256 value) public onlyOwner {
329     require(value >= 0, "Invalid value");
330     _reduceBuyTaxAt = value;
331     }
332 
333     function addBots(address[] memory bots_) public onlyOwner {
334         for (uint256 i = 0; i < bots_.length; i++) {
335             bots[bots_[i]] = true;
336         }
337     }
338 
339     function enableSwap() public onlyOwner {
340          swapEnabled = true;
341     }
342 
343     function delBots(address[] memory notbot) public onlyOwner {
344         for (uint256 i = 0; i < notbot.length; i++) {
345             bots[notbot[i]] = false;
346         }
347     }
348 }