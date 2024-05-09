1 // SPDX-License-Identifier: MIT
2 /**
3 
4 Welcome to $SOJ where the meme is the menu.
5 
6 Breakfast: https://t.me/SonOfJaredOnEth
7 
8 Lunch: https://twitter.com/Son_Of_Jared
9 
10 Dinner: https://sonofjared.com
11 
12 
13 **/
14 pragma solidity 0.8.20;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint256);
24     function balanceOf(address account) external view returns (uint256);
25     function transfer(address recipient, uint256 amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint256);
27     function approve(address spender, uint256 amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint256 value);
30     event Approval(address indexed owner, address indexed spender, uint256 value);
31 }
32 
33 library SafeMath {
34     function add(uint256 a, uint256 b) internal pure returns (uint256) {
35         uint256 c = a + b;
36         require(c >= a, "SafeMath: addition overflow");
37         return c;
38     }
39 
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         return sub(a, b, "SafeMath: subtraction overflow");
42     }
43 
44     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
45         require(b <= a, errorMessage);
46         uint256 c = a - b;
47         return c;
48     }
49 
50     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
51         if (a == 0) {
52             return 0;
53         }
54         uint256 c = a * b;
55         require(c / a == b, "SafeMath: multiplication overflow");
56         return c;
57     }
58 
59     function div(uint256 a, uint256 b) internal pure returns (uint256) {
60         return div(a, b, "SafeMath: division by zero");
61     }
62 
63     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
64         require(b > 0, errorMessage);
65         uint256 c = a / b;
66         return c;
67     }
68 
69 }
70 
71 contract Ownable is Context {
72     address private _owner;
73     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
74 
75     constructor () {
76         address msgSender = _msgSender();
77         _owner = msgSender;
78         emit OwnershipTransferred(address(0), msgSender);
79     }
80 
81     function owner() public view returns (address) {
82         return _owner;
83     }
84 
85     modifier onlyOwner() {
86         require(_owner == _msgSender(), "Ownable: caller is not the owner");
87         _;
88     }
89 
90     function renounceOwnership() public virtual onlyOwner {
91         emit OwnershipTransferred(_owner, address(0));
92         _owner = address(0);
93     }
94 
95 }
96 
97 interface IUniswapV2Factory {
98     function createPair(address tokenA, address tokenB) external returns (address pair);
99 }
100 
101 interface IUniswapV2Router02 {
102     function swapExactTokensForETHSupportingFeeOnTransferTokens(
103         uint amountIn,
104         uint amountOutMin,
105         address[] calldata path,
106         address to,
107         uint deadline
108     ) external;
109     function factory() external pure returns (address);
110     function WETH() external pure returns (address);
111     function addLiquidityETH(
112         address token,
113         uint amountTokenDesired,
114         uint amountTokenMin,
115         uint amountETHMin,
116         address to,
117         uint deadline
118     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
119 }
120 
121 contract SONOFJAREDFROMSUBWAY is Context, IERC20, Ownable {
122     using SafeMath for uint256;
123     mapping (address => uint256) private _balances;
124     mapping (address => mapping (address => uint256)) private _allowances;
125     mapping (address => bool) private _isExcludedFromFee;
126     mapping (address => bool) private bots;
127     mapping(address => uint256) private _holderLastTransferTimestamp;
128     bool public transferDelayEnabled = false;
129     address payable private _taxWallet;
130 
131     uint256 private _initialBuyTax=25;
132     uint256 private _initialSellTax=20;
133     uint256 private _finalBuyTax=2;
134     uint256 private _finalSellTax=2;
135     uint256 private _reduceBuyTaxAt=1;
136     uint256 private _reduceSellTaxAt=40;
137     uint256 private _preventSwapBefore=40;
138     uint256 private _buyCount=0;
139 
140     uint8 private constant _decimals = 8;
141     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
142     string private constant _name = unicode"SON OF JARED FROM SUBWAY";
143     string private constant _symbol = unicode"SOJ";
144     uint256 public _maxTxAmount =   10000000 * 10**_decimals;
145     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
146     uint256 public _taxSwapThreshold=0 * 10**_decimals;
147     uint256 public _maxTaxSwap=5000000 * 10**_decimals;
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
162     constructor () {
163         _taxWallet = payable(_msgSender());
164         _balances[_msgSender()] = _tTotal;
165         _isExcludedFromFee[owner()] = true;
166         _isExcludedFromFee[address(this)] = true;
167         _isExcludedFromFee[_taxWallet] = true;
168 
169         emit Transfer(address(0), _msgSender(), _tTotal);
170     }
171 
172     function name() public pure returns (string memory) {
173         return _name;
174     }
175 
176     function symbol() public pure returns (string memory) {
177         return _symbol;
178     }
179 
180     function decimals() public pure returns (uint8) {
181         return _decimals;
182     }
183 
184     function totalSupply() public pure override returns (uint256) {
185         return _tTotal;
186     }
187 
188     function balanceOf(address account) public view override returns (uint256) {
189         return _balances[account];
190     }
191 
192     function transfer(address recipient, uint256 amount) public override returns (bool) {
193         _transfer(_msgSender(), recipient, amount);
194         return true;
195     }
196 
197     function allowance(address owner, address spender) public view override returns (uint256) {
198         return _allowances[owner][spender];
199     }
200 
201     function approve(address spender, uint256 amount) public override returns (bool) {
202         _approve(_msgSender(), spender, amount);
203         return true;
204     }
205 
206     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
207         _transfer(sender, recipient, amount);
208         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
209         return true;
210     }
211 
212     function _approve(address owner, address spender, uint256 amount) private {
213         require(owner != address(0), "ERC20: approve from the zero address");
214         require(spender != address(0), "ERC20: approve to the zero address");
215         _allowances[owner][spender] = amount;
216         emit Approval(owner, spender, amount);
217     }
218 
219     function _transfer(address from, address to, uint256 amount) private {
220         require(from != address(0), "ERC20: transfer from the zero address");
221         require(to != address(0), "ERC20: transfer to the zero address");
222         require(amount > 0, "Transfer amount must be greater than zero");
223         uint256 taxAmount=0;
224         if (from != owner() && to != owner()) {
225             require(!bots[from] && !bots[to]);
226 
227             if (transferDelayEnabled) {
228                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
229                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
230                   _holderLastTransferTimestamp[tx.origin] = block.number;
231                 }
232             }
233 
234             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
235                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
236                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
237                 if(_buyCount<_preventSwapBefore){
238                   require(!isContract(to));
239                 }
240                 _buyCount++;
241             }
242 
243 
244             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
245             if(to == uniswapV2Pair && from!= address(this) ){
246                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
247                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
248             }
249 
250             uint256 contractTokenBalance = balanceOf(address(this));
251             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
252                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
253                 uint256 contractETHBalance = address(this).balance;
254                 if(contractETHBalance > 0) {
255                     sendETHToFee(address(this).balance);
256                 }
257             }
258         }
259 
260         if(taxAmount>0){
261           _balances[address(this)]=_balances[address(this)].add(taxAmount);
262           emit Transfer(from, address(this),taxAmount);
263         }
264         _balances[from]=_balances[from].sub(amount);
265         _balances[to]=_balances[to].add(amount.sub(taxAmount));
266         emit Transfer(from, to, amount.sub(taxAmount));
267     }
268 
269 
270     function min(uint256 a, uint256 b) private pure returns (uint256){
271       return (a>b)?b:a;
272     }
273 
274     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
275         if(tokenAmount==0){return;}
276         if(!tradingOpen){return;}
277         address[] memory path = new address[](2);
278         path[0] = address(this);
279         path[1] = uniswapV2Router.WETH();
280         _approve(address(this), address(uniswapV2Router), tokenAmount);
281         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
282             tokenAmount,
283             0,
284             path,
285             address(this),
286             block.timestamp
287         );
288     }
289 
290     function removeLimits() external onlyOwner{
291         _maxTxAmount = _tTotal;
292         _maxWalletSize=_tTotal;
293         transferDelayEnabled=false;
294         emit MaxTxAmountUpdated(_tTotal);
295     }
296 
297     function sendETHToFee(uint256 amount) private {
298         _taxWallet.transfer(amount);
299     }
300 
301     function isBot(address a) public view returns (bool){
302       return bots[a];
303     }
304 
305     function openTrading() external onlyOwner() {
306         require(!tradingOpen,"trading is already open");
307         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
308         _approve(address(this), address(uniswapV2Router), _tTotal);
309         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
310         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
311         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
312         swapEnabled = true;
313         tradingOpen = true;
314     }
315 
316     receive() external payable {}
317 
318     function isContract(address account) private view returns (bool) {
319         uint256 size;
320         assembly {
321             size := extcodesize(account)
322         }
323         return size > 0;
324     }
325 
326     function manualSwap() external {
327         require(_msgSender()==_taxWallet);
328         uint256 tokenBalance=balanceOf(address(this));
329         if(tokenBalance>0){
330           swapTokensForEth(tokenBalance);
331         }
332         uint256 ethBalance=address(this).balance;
333         if(ethBalance>0){
334           sendETHToFee(ethBalance);
335         }
336     }
337 
338     
339     
340     
341 }