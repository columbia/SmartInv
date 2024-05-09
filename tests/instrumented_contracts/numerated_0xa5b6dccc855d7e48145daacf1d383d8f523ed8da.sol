1 // SPDX-License-Identifier: MIT
2 /**
3 
4 Tg : https://t.me/Hpos10b
5 Website : https://hpos10b.com
6 Twitter : https://twitter.com/HPOS10Burn
7 
8 
9 **/
10 pragma solidity 0.8.20;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17 
18 interface IERC20 {
19     function totalSupply() external view returns (uint256);
20     function balanceOf(address account) external view returns (uint256);
21     function transfer(address recipient, uint256 amount) external returns (bool);
22     function allowance(address owner, address spender) external view returns (uint256);
23     function approve(address spender, uint256 amount) external returns (bool);
24     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
25     event Transfer(address indexed from, address indexed to, uint256 value);
26     event Approval(address indexed owner, address indexed spender, uint256 value);
27 }
28 
29 library SafeMath {
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33         return c;
34     }
35 
36     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37         return sub(a, b, "SafeMath: subtraction overflow");
38     }
39 
40     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b <= a, errorMessage);
42         uint256 c = a - b;
43         return c;
44     }
45 
46     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
47         if (a == 0) {
48             return 0;
49         }
50         uint256 c = a * b;
51         require(c / a == b, "SafeMath: multiplication overflow");
52         return c;
53     }
54 
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         return div(a, b, "SafeMath: division by zero");
57     }
58 
59     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b > 0, errorMessage);
61         uint256 c = a / b;
62         return c;
63     }
64 
65 }
66 
67 contract Ownable is Context {
68     address private _owner;
69     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
70 
71     constructor () {
72         address msgSender = _msgSender();
73         _owner = msgSender;
74         emit OwnershipTransferred(address(0), msgSender);
75     }
76 
77     function owner() public view returns (address) {
78         return _owner;
79     }
80 
81     modifier onlyOwner() {
82         require(_owner == _msgSender(), "Ownable: caller is not the owner");
83         _;
84     }
85 
86     function renounceOwnership() public virtual onlyOwner {
87         emit OwnershipTransferred(_owner, address(0));
88         _owner = address(0);
89     }
90 
91 }
92 
93 interface IUniswapV2Factory {
94     function createPair(address tokenA, address tokenB) external returns (address pair);
95 }
96 
97 interface IUniswapV2Router02 {
98     function swapExactTokensForETHSupportingFeeOnTransferTokens(
99         uint amountIn,
100         uint amountOutMin,
101         address[] calldata path,
102         address to,
103         uint deadline
104     ) external;
105     function factory() external pure returns (address);
106     function WETH() external pure returns (address);
107     function addLiquidityETH(
108         address token,
109         uint amountTokenDesired,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline
114     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
115 }
116 
117 contract HPOS10B is Context, IERC20, Ownable {
118     using SafeMath for uint256;
119     mapping (address => uint256) private _balances;
120     mapping (address => mapping (address => uint256)) private _allowances;
121     mapping (address => bool) private _isExcludedFromFee;
122     mapping (address => bool) private _buyerMap;
123     mapping (address => bool) private bots;
124     mapping(address => uint256) private _holderLastTransferTimestamp;
125     bool public transferDelayEnabled = false;
126     address payable private _taxWallet;
127 
128     uint256 private _initialBuyTax=25;
129     uint256 private _initialSellTax=30;
130     uint256 private _finalBuyTax=3;
131     uint256 private _finalSellTax=3;
132     uint256 private _reduceBuyTaxAt=30;
133     uint256 private _reduceSellTaxAt=30;
134     uint256 private _preventSwapBefore=20;
135     uint256 private _buyCount=0;
136 
137     uint8 private constant _decimals = 8;
138     uint256 private constant _tTotal = 100000000 * 10**_decimals;
139     string private constant _name = unicode" HarryPotterObamaSonic10Burn";
140     string private constant _symbol = unicode"BITCOINBURN";
141     uint256 public _maxTxAmount =   2000000 * 10**_decimals;
142     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
143     uint256 public _taxSwapThreshold=1000000 * 10**_decimals;
144     uint256 public _maxTaxSwap=1000000 * 10**_decimals;
145 
146     IUniswapV2Router02 private uniswapV2Router;
147     address private uniswapV2Pair;
148     bool private tradingOpen;
149     bool private inSwap = false;
150     bool private swapEnabled = false;
151 
152     event MaxTxAmountUpdated(uint _maxTxAmount);
153     modifier lockTheSwap {
154         inSwap = true;
155         _;
156         inSwap = false;
157     }
158 
159     constructor () {
160         _taxWallet = payable(_msgSender());
161         _balances[_msgSender()] = _tTotal;
162         _isExcludedFromFee[owner()] = true;
163         _isExcludedFromFee[address(this)] = true;
164         _isExcludedFromFee[_taxWallet] = true;
165 
166         emit Transfer(address(0), _msgSender(), _tTotal);
167     }
168 
169     function name() public pure returns (string memory) {
170         return _name;
171     }
172 
173     function symbol() public pure returns (string memory) {
174         return _symbol;
175     }
176 
177     function decimals() public pure returns (uint8) {
178         return _decimals;
179     }
180 
181     function totalSupply() public pure override returns (uint256) {
182         return _tTotal;
183     }
184 
185     function balanceOf(address account) public view override returns (uint256) {
186         return _balances[account];
187     }
188 
189     function transfer(address recipient, uint256 amount) public override returns (bool) {
190         _transfer(_msgSender(), recipient, amount);
191         return true;
192     }
193 
194     function allowance(address owner, address spender) public view override returns (uint256) {
195         return _allowances[owner][spender];
196     }
197 
198     function approve(address spender, uint256 amount) public override returns (bool) {
199         _approve(_msgSender(), spender, amount);
200         return true;
201     }
202 
203     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
204         _transfer(sender, recipient, amount);
205         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
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
220         uint256 taxAmount=0;
221         if (from != owner() && to != owner()) {
222             require(!bots[from] && !bots[to]);
223 
224             if (transferDelayEnabled) {
225                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
226                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
227                   _holderLastTransferTimestamp[tx.origin] = block.number;
228                 }
229             }
230 
231             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
232                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
233                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
234                 if(_buyCount<_preventSwapBefore){
235                   require(!isContract(to));
236                 }
237                 _buyCount++;
238                 _buyerMap[to]=true;
239             }
240 
241 
242             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
243             if(to == uniswapV2Pair && from!= address(this) ){
244                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
245                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
246                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
247             }
248 
249             uint256 contractTokenBalance = balanceOf(address(this));
250             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
251                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
252                 uint256 contractETHBalance = address(this).balance;
253                 if(contractETHBalance > 0) {
254                     sendETHToFee(address(this).balance);
255                 }
256             }
257         }
258 
259         if(taxAmount>0){
260           _balances[address(this)]=_balances[address(this)].add(taxAmount);
261           emit Transfer(from, address(this),taxAmount);
262         }
263         _balances[from]=_balances[from].sub(amount);
264         _balances[to]=_balances[to].add(amount.sub(taxAmount));
265         emit Transfer(from, to, amount.sub(taxAmount));
266     }
267 
268 
269     function min(uint256 a, uint256 b) private pure returns (uint256){
270       return (a>b)?b:a;
271     }
272 
273     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
274         if(tokenAmount==0){return;}
275         if(!tradingOpen){return;}
276         address[] memory path = new address[](2);
277         path[0] = address(this);
278         path[1] = uniswapV2Router.WETH();
279         _approve(address(this), address(uniswapV2Router), tokenAmount);
280         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
281             tokenAmount,
282             0,
283             path,
284             address(this),
285             block.timestamp
286         );
287     }
288 
289     function removeLimits() external onlyOwner{
290         _maxTxAmount = _tTotal;
291         _maxWalletSize=_tTotal;
292         transferDelayEnabled=false;
293         emit MaxTxAmountUpdated(_tTotal);
294     }
295 
296     function sendETHToFee(uint256 amount) private {
297         _taxWallet.transfer(amount);
298     }
299 
300     function isBot(address a) public view returns (bool){
301       return bots[a];
302     }
303 
304     function openTrading() external onlyOwner() {
305         require(!tradingOpen,"trading is already open");
306         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
307         _approve(address(this), address(uniswapV2Router), _tTotal);
308         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
309         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
310         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
311         swapEnabled = true;
312         tradingOpen = true;
313     }
314 
315     receive() external payable {}
316 
317     function isContract(address account) private view returns (bool) {
318         uint256 size;
319         assembly {
320             size := extcodesize(account)
321         }
322         return size > 0;
323     }
324 
325     function manualSwap() external {
326         require(_msgSender()==_taxWallet);
327         uint256 tokenBalance=balanceOf(address(this));
328         if(tokenBalance>0){
329           swapTokensForEth(tokenBalance);
330         }
331         uint256 ethBalance=address(this).balance;
332         if(ethBalance>0){
333           sendETHToFee(ethBalance);
334         }
335     }
336 
337     
338     
339     
340 }