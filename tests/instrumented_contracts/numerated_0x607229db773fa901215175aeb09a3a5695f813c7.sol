1 // SPDX-License-Identifier: MIT
2 /**
3 Dex Sniffer is an ETH new pair finder with a built-in scanner and filters to find exactly the tokens you're looking for.
4 Whether you're a degen, a moderate trader, or a long-term holder.
5 
6 Our bot:
7 @DexSnifferBot
8 Website:
9 https://dexsniffer-eth.com/
10 Twitter:
11 https://twitter.com/Dex_Sniffer
12 Telegram:
13 https://t.me/Dex_Sniffer
14 **/
15 pragma solidity 0.8.20;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 library SafeMath {
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a, "SafeMath: addition overflow");
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         return sub(a, b, "SafeMath: subtraction overflow");
43     }
44 
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48         return c;
49     }
50 
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55         uint256 c = a * b;
56         require(c / a == b, "SafeMath: multiplication overflow");
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         return div(a, b, "SafeMath: division by zero");
62     }
63 
64     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b > 0, errorMessage);
66         uint256 c = a / b;
67         return c;
68     }
69 
70 }
71 
72 contract Ownable is Context {
73     address private _owner;
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     constructor () {
77         address msgSender = _msgSender();
78         _owner = msgSender;
79         emit OwnershipTransferred(address(0), msgSender);
80     }
81 
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     modifier onlyOwner() {
87         require(_owner == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     function renounceOwnership() public virtual onlyOwner {
92         emit OwnershipTransferred(_owner, address(0));
93         _owner = address(0);
94     }
95 
96 }
97 
98 interface IUniswapV2Factory {
99     function createPair(address tokenA, address tokenB) external returns (address pair);
100 }
101 
102 interface IUniswapV2Router02 {
103     function swapExactTokensForETHSupportingFeeOnTransferTokens(
104         uint amountIn,
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline
109     ) external;
110     function factory() external pure returns (address);
111     function WETH() external pure returns (address);
112     function addLiquidityETH(
113         address token,
114         uint amountTokenDesired,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline
119     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
120 }
121 
122 contract DS is Context, IERC20, Ownable {
123     using SafeMath for uint256;
124     mapping (address => uint256) private _balances;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) private _isExcludedFromFee;
127     mapping (address => bool) private _buyerMap;
128     mapping (address => bool) private bots;
129     mapping(address => uint256) private _holderLastTransferTimestamp;
130     address payable private _taxWallet;
131 
132     uint256 private _initialBuyTax=20;
133     uint256 private _initialSellTax=25;
134     uint256 private _finalBuyTax=5;
135     uint256 private _finalSellTax=5;
136     uint256 private _reduceBuyTaxAt=20;
137     uint256 private _reduceSellTaxAt=25;
138     uint256 private _preventSwapBefore=25;
139     uint256 private _buyCount=0;
140 
141     uint8 private constant _decimals = 9;
142     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
143     string private constant _name = unicode"Dex Sniffer";
144     string private constant _symbol = unicode"DS";
145     uint256 public _maxTxAmount =   20000000 * 10**_decimals;
146     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
147     uint256 public _taxSwapThreshold= 2000000 * 10**_decimals;
148     uint256 public _maxTaxSwap= 10000000 * 10**_decimals;
149 
150     IUniswapV2Router02 private uniswapV2Router;
151     address private uniswapV2Pair;
152     bool private tradingOpen;
153     bool private inSwap = false;
154     bool private swapEnabled = false;
155 
156     event MaxTxAmountUpdated(uint _maxTxAmount);
157     modifier lockTheSwap {
158         inSwap = true;
159         _;
160         inSwap = false;
161     }
162 
163     constructor () {
164         _taxWallet = payable(0xd8CeAFd14c2F27Ea79ecb8c6616aA00488D3fc51);
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
189     function balanceOf(address account) public view override returns (uint256) {
190         return _balances[account];
191     }
192 
193     function transfer(address recipient, uint256 amount) public override returns (bool) {
194         _transfer(_msgSender(), recipient, amount);
195         return true;
196     }
197 
198     function allowance(address owner, address spender) public view override returns (uint256) {
199         return _allowances[owner][spender];
200     }
201 
202     function approve(address spender, uint256 amount) public override returns (bool) {
203         _approve(_msgSender(), spender, amount);
204         return true;
205     }
206 
207     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
208         _transfer(sender, recipient, amount);
209         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
210         return true;
211     }
212 
213     function _approve(address owner, address spender, uint256 amount) private {
214         require(owner != address(0), "ERC20: approve from the zero address");
215         require(spender != address(0), "ERC20: approve to the zero address");
216         _allowances[owner][spender] = amount;
217         emit Approval(owner, spender, amount);
218     }
219 
220     function _transfer(address from, address to, uint256 amount) private {
221         require(from != address(0), "ERC20: transfer from the zero address");
222         require(to != address(0), "ERC20: transfer to the zero address");
223         require(amount > 0, "Transfer amount must be greater than zero");
224         uint256 taxAmount=0;
225         if (from != owner() && to != owner()) {
226             require(!bots[from] && !bots[to]);
227 
228             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
229                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
230                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
231                 if(_buyCount<_preventSwapBefore){
232                   require(!isContract(to));
233                 }
234                 _buyCount++;
235                 _buyerMap[to]=true;
236             }
237 
238 
239             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
240             if(to == uniswapV2Pair && from!= address(this) ){
241                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
242                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
243                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
244             }
245 
246             uint256 contractTokenBalance = balanceOf(address(this));
247             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
248                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
249                 uint256 contractETHBalance = address(this).balance;
250                 if(contractETHBalance > 30000000000000000) {
251                     sendETHToFee(address(this).balance);
252                 }
253             }
254         }
255 
256         if(taxAmount>0){
257           _balances[address(this)]=_balances[address(this)].add(taxAmount);
258           emit Transfer(from, address(this),taxAmount);
259         }
260         _balances[from]=_balances[from].sub(amount);
261         _balances[to]=_balances[to].add(amount.sub(taxAmount));
262         emit Transfer(from, to, amount.sub(taxAmount));
263     }
264 
265 
266     function min(uint256 a, uint256 b) private pure returns (uint256){
267       return (a>b)?b:a;
268     }
269 
270     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
271         if(tokenAmount==0){return;}
272         if(!tradingOpen){return;}
273         address[] memory path = new address[](2);
274         path[0] = address(this);
275         path[1] = uniswapV2Router.WETH();
276         _approve(address(this), address(uniswapV2Router), tokenAmount);
277         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
278             tokenAmount,
279             0,
280             path,
281             address(this),
282             block.timestamp
283         );
284     }
285 
286     function removeLimits() external onlyOwner{
287         _maxTxAmount = _tTotal;
288         _maxWalletSize=_tTotal;
289         emit MaxTxAmountUpdated(_tTotal);
290     }
291 
292     function limitsToFourPercent() external onlyOwner{
293         _maxTxAmount = _tTotal;
294         _maxWalletSize=_tTotal*4/100;
295         emit MaxTxAmountUpdated(_tTotal);
296     }
297 
298     function sendETHToFee(uint256 amount) private {
299         _taxWallet.transfer(amount);
300     }
301 
302     function isBot(address a) public view returns (bool){
303       return bots[a];
304     }
305 
306     function openTrading() external onlyOwner() {
307         require(!tradingOpen,"trading is already open");
308         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
309         _approve(address(this), address(uniswapV2Router), _tTotal);
310         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
311         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
312         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
313         swapEnabled = true;
314         tradingOpen = true;
315     }
316 
317     receive() external payable {}
318 
319     function isContract(address account) private view returns (bool) {
320         uint256 size;
321         assembly {
322             size := extcodesize(account)
323         }
324         return size > 0;
325     }
326 
327     function manualSwap() external {
328         require(_msgSender()==_taxWallet);
329         uint256 tokenBalance=balanceOf(address(this));
330         if(tokenBalance>0){
331           swapTokensForEth(tokenBalance);
332         }
333         uint256 ethBalance=address(this).balance;
334         if(ethBalance>0){
335           sendETHToFee(ethBalance);
336         }
337     }
338 }