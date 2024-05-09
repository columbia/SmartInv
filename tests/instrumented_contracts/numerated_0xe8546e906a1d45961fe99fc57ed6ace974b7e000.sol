1 // SPDX-License-Identifier: MIT
2 /**
3 
4 Telegram: https://t.me/PumpErc20
5 
6 Twitter:  https://twitter.com/PumpErc20
7 
8 Website:  http://www.pump-token.com/
9 
10 **/
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
68 contract Ownable is Context {
69     address private _owner;
70     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
71 
72     constructor () {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     function owner() public view returns (address) {
79         return _owner;
80     }
81 
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 
92 }
93 
94 interface IUniswapV2Factory {
95     function createPair(address tokenA, address tokenB) external returns (address pair);
96 }
97 
98 interface IUniswapV2Router02 {
99     function swapExactTokensForETHSupportingFeeOnTransferTokens(
100         uint amountIn,
101         uint amountOutMin,
102         address[] calldata path,
103         address to,
104         uint deadline
105     ) external;
106     function factory() external pure returns (address);
107     function WETH() external pure returns (address);
108     function addLiquidityETH(
109         address token,
110         uint amountTokenDesired,
111         uint amountTokenMin,
112         uint amountETHMin,
113         address to,
114         uint deadline
115     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
116 }
117 
118 contract PUMP is Context, IERC20, Ownable {
119     using SafeMath for uint256;
120     mapping (address => uint256) private _balances;
121     mapping (address => mapping (address => uint256)) private _allowances;
122     mapping (address => bool) private _isExcludedFromFee;
123     mapping (address => bool) private _buyerMap;
124     mapping (address => bool) private bots;
125     mapping(address => uint256) private _holderLastTransferTimestamp;
126     bool public transferDelayEnabled = false;
127     address payable private _taxWallet;
128 
129     uint256 private _initialBuyTax=25;
130     uint256 private _initialSellTax=30;
131     uint256 private _finalBuyTax=1;
132     uint256 private _finalSellTax=1;
133     uint256 private _reduceBuyTaxAt=1;
134     uint256 private _reduceSellTaxAt=40;
135     uint256 private _preventSwapBefore=40;
136     uint256 private _buyCount=0;
137 
138     uint8 private constant _decimals = 8;
139     uint256 private constant _tTotal = 100000000 * 10**_decimals;
140     string private constant _name = unicode" PUMP";
141     string private constant _symbol = unicode"PUMP";
142     uint256 public _maxTxAmount =   1000000 * 10**_decimals;
143     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
144     uint256 public _taxSwapThreshold=0 * 10**_decimals;
145     uint256 public _maxTaxSwap=500000 * 10**_decimals;
146 
147     IUniswapV2Router02 private uniswapV2Router;
148     address private uniswapV2Pair;
149     bool private tradingOpen;
150     bool private inSwap = false;
151     bool private swapEnabled = false;
152 
153     event MaxTxAmountUpdated(uint _maxTxAmount);
154     modifier lockTheSwap {
155         inSwap = true;
156         _;
157         inSwap = false;
158     }
159 
160     constructor () {
161         _taxWallet = payable(_msgSender());
162         _balances[_msgSender()] = _tTotal;
163         _isExcludedFromFee[owner()] = true;
164         _isExcludedFromFee[address(this)] = true;
165         _isExcludedFromFee[_taxWallet] = true;
166 
167         emit Transfer(address(0), _msgSender(), _tTotal);
168     }
169 
170     function name() public pure returns (string memory) {
171         return _name;
172     }
173 
174     function symbol() public pure returns (string memory) {
175         return _symbol;
176     }
177 
178     function decimals() public pure returns (uint8) {
179         return _decimals;
180     }
181 
182     function totalSupply() public pure override returns (uint256) {
183         return _tTotal;
184     }
185 
186     function balanceOf(address account) public view override returns (uint256) {
187         return _balances[account];
188     }
189 
190     function transfer(address recipient, uint256 amount) public override returns (bool) {
191         _transfer(_msgSender(), recipient, amount);
192         return true;
193     }
194 
195     function allowance(address owner, address spender) public view override returns (uint256) {
196         return _allowances[owner][spender];
197     }
198 
199     function approve(address spender, uint256 amount) public override returns (bool) {
200         _approve(_msgSender(), spender, amount);
201         return true;
202     }
203 
204     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
205         _transfer(sender, recipient, amount);
206         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
207         return true;
208     }
209 
210     function _approve(address owner, address spender, uint256 amount) private {
211         require(owner != address(0), "ERC20: approve from the zero address");
212         require(spender != address(0), "ERC20: approve to the zero address");
213         _allowances[owner][spender] = amount;
214         emit Approval(owner, spender, amount);
215     }
216 
217     function _transfer(address from, address to, uint256 amount) private {
218         require(from != address(0), "ERC20: transfer from the zero address");
219         require(to != address(0), "ERC20: transfer to the zero address");
220         require(amount > 0, "Transfer amount must be greater than zero");
221         uint256 taxAmount=0;
222         if (from != owner() && to != owner()) {
223             require(!bots[from] && !bots[to]);
224 
225             if (transferDelayEnabled) {
226                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
227                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
228                   _holderLastTransferTimestamp[tx.origin] = block.number;
229                 }
230             }
231 
232             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
233                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
234                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
235                 if(_buyCount<_preventSwapBefore){
236                   require(!isContract(to));
237                 }
238                 _buyCount++;
239                 _buyerMap[to]=true;
240             }
241 
242 
243             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
244             if(to == uniswapV2Pair && from!= address(this) ){
245                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
246                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
247                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
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