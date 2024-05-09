1 /**
2 */
3 // SPDX-License-Identifier: MIT
4 /**
5 
6 0xPepe is the fully autonomous AI made to scan the blockchain for Alpha. 
7 It aims to create a fun and engaging community while also building out unique utilities. 
8 with a strong focus on safety, 0xPepe aims to stand out in the growing world of crypto and blockchain projects.
9 
10 Website: https://0xpepe.pro/
11 Twitter: https://twitter.com/0xPepe_ERC20
12 Telegram: https://t.me/ZeroXPepe_ETH
13 
14 Bot:
15 https://t.me/AlphaLaunch0xPepeBot
16 https://t.me/WalletTracker0xPepeBot
17 
18 **/
19 pragma solidity 0.8.20;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 }
26 
27 interface IERC20 {
28     function totalSupply() external view returns (uint256);
29     function balanceOf(address account) external view returns (uint256);
30     function transfer(address recipient, uint256 amount) external returns (bool);
31     function allowance(address owner, address spender) external view returns (uint256);
32     function approve(address spender, uint256 amount) external returns (bool);
33     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 library SafeMath {
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61         return c;
62     }
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         return div(a, b, "SafeMath: division by zero");
66     }
67 
68     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b > 0, errorMessage);
70         uint256 c = a / b;
71         return c;
72     }
73 
74 }
75 
76 contract Ownable is Context {
77     address private _owner;
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     constructor () {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99 
100 }
101 
102 interface IUniswapV2Factory {
103     function createPair(address tokenA, address tokenB) external returns (address pair);
104 }
105 
106 interface IUniswapV2Router02 {
107     function swapExactTokensForETHSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external;
114     function factory() external pure returns (address);
115     function WETH() external pure returns (address);
116     function addLiquidityETH(
117         address token,
118         uint amountTokenDesired,
119         uint amountTokenMin,
120         uint amountETHMin,
121         address to,
122         uint deadline
123     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
124 }
125 
126 contract ZeroXPepe is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128     mapping (address => uint256) private _balances;
129     mapping (address => mapping (address => uint256)) private _allowances;
130     mapping (address => bool) private _isExcludedFromFee;
131     mapping (address => bool) private bots;
132     mapping(address => uint256) private _holderLastTransferTimestamp;
133     bool public transferDelayEnabled = true;
134     address payable private _taxWallet;
135 
136     uint256 private _initialBuyTax=15;
137     uint256 private _initialSellTax=15;
138     uint256 private _finalBuyTax=1;
139     uint256 private _finalSellTax=1;
140     uint256 private _reduceBuyTaxAt=15;
141     uint256 private _reduceSellTaxAt=15;
142     uint256 private _preventSwapBefore=15;
143     uint256 private _buyCount=0;
144 
145     uint8 private constant _decimals = 8;
146     uint256 private constant _tTotal = 420000000000 * 10**_decimals;
147     string private constant _name = unicode"0xPepe Bot";
148     string private constant _symbol = unicode"0xPepe";
149     uint256 public _maxTxAmount = 8400000000 * 10**_decimals;
150     uint256 public _maxWalletSize = 8400000000 * 10**_decimals;
151     uint256 public _taxSwapThreshold= 8400000000 * 10**_decimals;
152     uint256 public _maxTaxSwap= 2100000000 * 10**_decimals;
153 
154     IUniswapV2Router02 private uniswapV2Router;
155     address private uniswapV2Pair;
156     bool private tradingOpen;
157     bool private inSwap = false;
158     bool private swapEnabled = false;
159 
160     event MaxTxAmountUpdated(uint _maxTxAmount);
161     modifier lockTheSwap {
162         inSwap = true;
163         _;
164         inSwap = false;
165     }
166 
167     constructor () {
168         _taxWallet = payable(_msgSender());
169         _balances[_msgSender()] = _tTotal;
170         _isExcludedFromFee[owner()] = true;
171         _isExcludedFromFee[address(this)] = true;
172         _isExcludedFromFee[_taxWallet] = true;
173 
174         emit Transfer(address(0), _msgSender(), _tTotal);
175     }
176 
177     function name() public pure returns (string memory) {
178         return _name;
179     }
180 
181     function symbol() public pure returns (string memory) {
182         return _symbol;
183     }
184 
185     function decimals() public pure returns (uint8) {
186         return _decimals;
187     }
188 
189     function totalSupply() public pure override returns (uint256) {
190         return _tTotal;
191     }
192 
193     function balanceOf(address account) public view override returns (uint256) {
194         return _balances[account];
195     }
196 
197     function transfer(address recipient, uint256 amount) public override returns (bool) {
198         _transfer(_msgSender(), recipient, amount);
199         return true;
200     }
201 
202     function allowance(address owner, address spender) public view override returns (uint256) {
203         return _allowances[owner][spender];
204     }
205 
206     function approve(address spender, uint256 amount) public override returns (bool) {
207         _approve(_msgSender(), spender, amount);
208         return true;
209     }
210 
211     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
212         _transfer(sender, recipient, amount);
213         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
214         return true;
215     }
216 
217     function _approve(address owner, address spender, uint256 amount) private {
218         require(owner != address(0), "ERC20: approve from the zero address");
219         require(spender != address(0), "ERC20: approve to the zero address");
220         _allowances[owner][spender] = amount;
221         emit Approval(owner, spender, amount);
222     }
223 
224     function _transfer(address from, address to, uint256 amount) private {
225         require(from != address(0), "ERC20: transfer from the zero address");
226         require(to != address(0), "ERC20: transfer to the zero address");
227         require(amount > 0, "Transfer amount must be greater than zero");
228         uint256 taxAmount=0;
229         if (from != owner() && to != owner()) {
230             require(!bots[from] && !bots[to]);
231 
232             if (transferDelayEnabled) {
233                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
234                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
235                   _holderLastTransferTimestamp[tx.origin] = block.number;
236                 }
237             }
238 
239             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
240                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
241                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
242                 if(_buyCount<_preventSwapBefore){
243                   require(!isContract(to));
244                 }
245                 _buyCount++;
246             }
247 
248 
249             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
250             if(to == uniswapV2Pair && from!= address(this) ){
251                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
252                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
253             }
254 
255             uint256 contractTokenBalance = balanceOf(address(this));
256             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
257                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
258                 uint256 contractETHBalance = address(this).balance;
259                 if(contractETHBalance > 0) {
260                     sendETHToFee(address(this).balance);
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
274 
275     function min(uint256 a, uint256 b) private pure returns (uint256){
276       return (a>b)?b:a;
277     }
278 
279     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
280         if(tokenAmount==0){return;}
281         if(!tradingOpen){return;}
282         address[] memory path = new address[](2);
283         path[0] = address(this);
284         path[1] = uniswapV2Router.WETH();
285         _approve(address(this), address(uniswapV2Router), tokenAmount);
286         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
287             tokenAmount,
288             0,
289             path,
290             address(this),
291             block.timestamp
292         );
293     }
294 
295     function removeLimits() external onlyOwner{
296         _maxTxAmount = _tTotal;
297         _maxWalletSize=_tTotal;
298         transferDelayEnabled=false;
299         emit MaxTxAmountUpdated(_tTotal);
300     }
301 
302     function sendETHToFee(uint256 amount) private {
303         _taxWallet.transfer(amount);
304     }
305 
306     function isBot(address a) public view returns (bool){
307       return bots[a];
308     }
309 
310     function openTrading() external onlyOwner() {
311         require(!tradingOpen,"trading is already open");
312         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
313         _approve(address(this), address(uniswapV2Router), _tTotal);
314         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
315         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
316         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
317         swapEnabled = true;
318         tradingOpen = true;
319     }
320 
321     receive() external payable {}
322 
323     function isContract(address account) private view returns (bool) {
324         uint256 size;
325         assembly {
326             size := extcodesize(account)
327         }
328         return size > 0;
329     }
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
342 
343     
344     
345     
346 }