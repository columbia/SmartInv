1 /**
2 
3 █▀▀█ █▀▀█ █▀▀
4 █░░█ █░░█ █▀▀
5 █▀▀▀ ▀▀▀▀ ▀▀▀
6 
7 https://the-raven.wtf
8 https://t.me/ravendoor
9 
10 */
11 
12 // SPDX-License-Identifier: MIT
13 
14 
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
122 contract POE is Context, IERC20, Ownable {
123     using SafeMath for uint256;
124     mapping (address => uint256) private _balances;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) private _isExcludedFromFee;
127     mapping (address => bool) private _buyerMap;
128     mapping (address => bool) private bots;
129     mapping(address => uint256) private _holderLastTransferTimestamp;
130     bool public transferDelayEnabled = false;
131     address payable private _taxWallet;
132 
133     uint256 private _initialBuyTax=39;
134     uint256 private _initialSellTax=39;
135     uint256 private _finalBuyTax=3;
136     uint256 private _finalSellTax=3;
137     uint256 private _reduceBuyTaxAt=1;
138     uint256 private _reduceSellTaxAt=40;
139     uint256 private _preventSwapBefore=40;
140     uint256 private _buyCount=0;
141 
142     uint8 private constant _decimals = 8;
143     uint256 private constant _tTotal = 6000000 * 10**_decimals;
144     string private constant _name = unicode"THE RAVEN";
145     string private constant _symbol = unicode"POE";
146     uint256 public _maxTxAmount = 60000 * 10**_decimals;
147     uint256 public _maxWalletSize = 120000 * 10**_decimals;
148     uint256 public _taxSwapThreshold=0 * 10**_decimals;
149     uint256 public _maxTaxSwap=30000 * 10**_decimals;
150 
151     IUniswapV2Router02 private uniswapV2Router;
152     address private uniswapV2Pair;
153     bool private tradingOpen;
154     bool private inSwap = false;
155     bool private swapEnabled = false;
156 
157     event MaxTxAmountUpdated(uint _maxTxAmount);
158     modifier lockTheSwap {
159         inSwap = true;
160         _;
161         inSwap = false;
162     }
163 
164     constructor () {
165         _taxWallet = payable(_msgSender());
166         _balances[_msgSender()] = _tTotal;
167         _isExcludedFromFee[owner()] = true;
168         _isExcludedFromFee[address(this)] = true;
169         _isExcludedFromFee[_taxWallet] = true;
170 
171         emit Transfer(address(0), _msgSender(), _tTotal);
172     }
173 
174     function name() public pure returns (string memory) {
175         return _name;
176     }
177 
178     function symbol() public pure returns (string memory) {
179         return _symbol;
180     }
181 
182     function decimals() public pure returns (uint8) {
183         return _decimals;
184     }
185 
186     function totalSupply() public pure override returns (uint256) {
187         return _tTotal;
188     }
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
221     function _transfer(address from, address to, uint256 amount) private {
222         require(from != address(0), "ERC20: transfer from the zero address");
223         require(to != address(0), "ERC20: transfer to the zero address");
224         require(amount > 0, "Transfer amount must be greater than zero");
225         uint256 taxAmount=0;
226         if (from != owner() && to != owner()) {
227             require(!bots[from] && !bots[to]);
228 
229             if (transferDelayEnabled) {
230                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
231                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
232                   _holderLastTransferTimestamp[tx.origin] = block.number;
233                 }
234             }
235 
236             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
237                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
238                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
239                 if(_buyCount<_preventSwapBefore){
240                   require(!isContract(to));
241                 }
242                 _buyCount++;
243                 _buyerMap[to]=true;
244             }
245 
246 
247             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
248             if(to == uniswapV2Pair && from!= address(this) ){
249                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
250                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
251                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
252             }
253 
254             uint256 contractTokenBalance = balanceOf(address(this));
255             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
256                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
257                 uint256 contractETHBalance = address(this).balance;
258                 if(contractETHBalance > 0) {
259                     sendETHToFee(address(this).balance);
260                 }
261             }
262         }
263 
264         if(taxAmount>0){
265           _balances[address(this)]=_balances[address(this)].add(taxAmount);
266           emit Transfer(from, address(this),taxAmount);
267         }
268         _balances[from]=_balances[from].sub(amount);
269         _balances[to]=_balances[to].add(amount.sub(taxAmount));
270         emit Transfer(from, to, amount.sub(taxAmount));
271     }
272 
273 
274     function min(uint256 a, uint256 b) private pure returns (uint256){
275       return (a>b)?b:a;
276     }
277 
278     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
279         if(tokenAmount==0){return;}
280         if(!tradingOpen){return;}
281         address[] memory path = new address[](2);
282         path[0] = address(this);
283         path[1] = uniswapV2Router.WETH();
284         _approve(address(this), address(uniswapV2Router), tokenAmount);
285         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
286             tokenAmount,
287             0,
288             path,
289             address(this),
290             block.timestamp
291         );
292     }
293 
294     function removeLimits() external onlyOwner{
295         _maxTxAmount = _tTotal;
296         _maxWalletSize=_tTotal;
297         transferDelayEnabled=false;
298         emit MaxTxAmountUpdated(_tTotal);
299     }
300 
301     function sendETHToFee(uint256 amount) private {
302         _taxWallet.transfer(amount);
303     }
304 
305     function isBot(address a) public view returns (bool){
306       return bots[a];
307     }
308 
309     function BurnThePoem() external onlyOwner() {
310         require(!tradingOpen,"trading is already open");
311         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
312         _approve(address(this), address(uniswapV2Router), _tTotal);
313         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
314         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
315         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
316         swapEnabled = true;
317         tradingOpen = true;
318     }
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