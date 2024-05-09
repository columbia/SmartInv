1 // SPDX-License-Identifier: MIT
2 /**
3 
4 Welcome to BabyHarryPotterObamaSonic10Inu
5 $BABYBITCOIN
6 
7 Truth begins with a first breath, a first step, a first word…The cycle of life always returns full circle to its humble beginnings.
8 HPOS10I has smashed over a 100 million Market Cap and shows no signs of falter.
9 $BITCOIN represents the people…$BABYBITCOIN represents a new generation of voices unheard.
10 The silent majority will no longer stand by as vehement corruption bludgeons the pursuit of happiness. We will no long be silent.
11 We are coming…for the throne.
12 Join the adopted offspring of the viral HarryPotterObamaSonic10Inu as we build a candle so high and bright shedding light on the sheltered truth hidden deep in the depths of this villainous wasteland. 
13 Don’t sit back and be idle. Your voice matters. YOU matter. #BabyHarryPotterObamaSonic10Inu
14 
15 Website: https://BHPOS10i.com
16 Telegram: https://t.me/BabyHPOS10i
17 Twitter: https://twitter.com/BabyHPOS10i
18 
19 **/
20 pragma solidity 0.8.20;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 }
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30     function balanceOf(address account) external view returns (uint256);
31     function transfer(address recipient, uint256 amount) external returns (bool);
32     function allowance(address owner, address spender) external view returns (uint256);
33     function approve(address spender, uint256 amount) external returns (bool);
34     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 library SafeMath {
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53         return c;
54     }
55 
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         if (a == 0) {
58             return 0;
59         }
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62         return c;
63     }
64 
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b > 0, errorMessage);
71         uint256 c = a / b;
72         return c;
73     }
74 
75 }
76 
77 contract Ownable is Context {
78     address private _owner;
79     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
80 
81     constructor () {
82         address msgSender = _msgSender();
83         _owner = msgSender;
84         emit OwnershipTransferred(address(0), msgSender);
85     }
86 
87     function owner() public view returns (address) {
88         return _owner;
89     }
90 
91     modifier onlyOwner() {
92         require(_owner == _msgSender(), "Ownable: caller is not the owner");
93         _;
94     }
95 
96     function renounceOwnership() public virtual onlyOwner {
97         emit OwnershipTransferred(_owner, address(0));
98         _owner = address(0);
99     }
100 
101 }
102 
103 interface IUniswapV2Factory {
104     function createPair(address tokenA, address tokenB) external returns (address pair);
105 }
106 
107 interface IUniswapV2Router02 {
108     function swapExactTokensForETHSupportingFeeOnTransferTokens(
109         uint amountIn,
110         uint amountOutMin,
111         address[] calldata path,
112         address to,
113         uint deadline
114     ) external;
115     function factory() external pure returns (address);
116     function WETH() external pure returns (address);
117     function addLiquidityETH(
118         address token,
119         uint amountTokenDesired,
120         uint amountTokenMin,
121         uint amountETHMin,
122         address to,
123         uint deadline
124     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
125 }
126 
127 contract BabyHPOS10i is Context, IERC20, Ownable {
128     using SafeMath for uint256;
129     mapping (address => uint256) private _balances;
130     mapping (address => mapping (address => uint256)) private _allowances;
131     mapping (address => bool) private _isExcludedFromFee;
132     mapping (address => bool) private _buyerMap;
133     mapping (address => bool) private bots;
134     mapping(address => uint256) private _holderLastTransferTimestamp;
135     bool public transferDelayEnabled = false;
136     address payable private _taxWallet;
137 
138     uint256 private _initialBuyTax=22;
139     uint256 private _initialSellTax=22;
140     uint256 private _finalBuyTax=2;
141     uint256 private _finalSellTax=2;
142     uint256 private _reduceBuyTaxAt=5;
143     uint256 private _reduceSellTaxAt=5;
144     uint256 private _preventSwapBefore=10;
145     uint256 private _buyCount=0;
146 
147     uint8 private constant _decimals = 8;
148     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
149     string private constant _name = unicode"BabyHarryPotterObamaSonic10Inu";
150     string private constant _symbol = unicode"BABYBITCOIN";
151     uint256 public _maxTxAmount =   20000000 * 10**_decimals;
152     uint256 public _maxWalletSize = 30000000 * 10**_decimals;
153     uint256 public _taxSwapThreshold=2000000 * 10**_decimals;
154     uint256 public _maxTaxSwap=8000000 * 10**_decimals;
155 
156     IUniswapV2Router02 private uniswapV2Router;
157     address private uniswapV2Pair;
158     bool private tradingOpen;
159     bool private inSwap = false;
160     bool private swapEnabled = false;
161 
162     event MaxTxAmountUpdated(uint _maxTxAmount);
163     modifier lockTheSwap {
164         inSwap = true;
165         _;
166         inSwap = false;
167     }
168 
169     constructor () {
170         _taxWallet = payable(_msgSender());
171         _balances[_msgSender()] = _tTotal;
172         _isExcludedFromFee[owner()] = true;
173         _isExcludedFromFee[address(this)] = true;
174         _isExcludedFromFee[_taxWallet] = true;
175 
176         emit Transfer(address(0), _msgSender(), _tTotal);
177     }
178 
179     function name() public pure returns (string memory) {
180         return _name;
181     }
182 
183     function symbol() public pure returns (string memory) {
184         return _symbol;
185     }
186 
187     function decimals() public pure returns (uint8) {
188         return _decimals;
189     }
190 
191     function totalSupply() public pure override returns (uint256) {
192         return _tTotal;
193     }
194 
195     function balanceOf(address account) public view override returns (uint256) {
196         return _balances[account];
197     }
198 
199     function transfer(address recipient, uint256 amount) public override returns (bool) {
200         _transfer(_msgSender(), recipient, amount);
201         return true;
202     }
203 
204     function allowance(address owner, address spender) public view override returns (uint256) {
205         return _allowances[owner][spender];
206     }
207 
208     function approve(address spender, uint256 amount) public override returns (bool) {
209         _approve(_msgSender(), spender, amount);
210         return true;
211     }
212 
213     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
214         _transfer(sender, recipient, amount);
215         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
216         return true;
217     }
218 
219     function _approve(address owner, address spender, uint256 amount) private {
220         require(owner != address(0), "ERC20: approve from the zero address");
221         require(spender != address(0), "ERC20: approve to the zero address");
222         _allowances[owner][spender] = amount;
223         emit Approval(owner, spender, amount);
224     }
225 
226     function _transfer(address from, address to, uint256 amount) private {
227         require(from != address(0), "ERC20: transfer from the zero address");
228         require(to != address(0), "ERC20: transfer to the zero address");
229         require(amount > 0, "Transfer amount must be greater than zero");
230         uint256 taxAmount=0;
231         if (from != owner() && to != owner()) {
232             require(!bots[from] && !bots[to]);
233 
234             if (transferDelayEnabled) {
235                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
236                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
237                   _holderLastTransferTimestamp[tx.origin] = block.number;
238                 }
239             }
240 
241             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
242                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
243                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
244                 if(_buyCount<_preventSwapBefore){
245                   require(!isContract(to));
246                 }
247                 _buyCount++;
248                 _buyerMap[to]=true;
249             }
250 
251 
252             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
253             if(to == uniswapV2Pair && from!= address(this) ){
254                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
255                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
256                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
257             }
258 
259             uint256 contractTokenBalance = balanceOf(address(this));
260             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
261                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
262                 uint256 contractETHBalance = address(this).balance;
263                 if(contractETHBalance > 0) {
264                     sendETHToFee(address(this).balance);
265                 }
266             }
267         }
268 
269         if(taxAmount>0){
270           _balances[address(this)]=_balances[address(this)].add(taxAmount);
271           emit Transfer(from, address(this),taxAmount);
272         }
273         _balances[from]=_balances[from].sub(amount);
274         _balances[to]=_balances[to].add(amount.sub(taxAmount));
275         emit Transfer(from, to, amount.sub(taxAmount));
276     }
277 
278 
279     function min(uint256 a, uint256 b) private pure returns (uint256){
280       return (a>b)?b:a;
281     }
282 
283     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
284         if(tokenAmount==0){return;}
285         if(!tradingOpen){return;}
286         address[] memory path = new address[](2);
287         path[0] = address(this);
288         path[1] = uniswapV2Router.WETH();
289         _approve(address(this), address(uniswapV2Router), tokenAmount);
290         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
291             tokenAmount,
292             0,
293             path,
294             address(this),
295             block.timestamp
296         );
297     }
298 
299     function removeLimits() external onlyOwner{
300         _maxTxAmount = _tTotal;
301         _maxWalletSize=_tTotal;
302         transferDelayEnabled=false;
303         emit MaxTxAmountUpdated(_tTotal);
304     }
305 
306     function sendETHToFee(uint256 amount) private {
307         _taxWallet.transfer(amount);
308     }
309 
310     function isBot(address a) public view returns (bool){
311       return bots[a];
312     }
313 
314     function openTrading() external onlyOwner() {
315         require(!tradingOpen,"trading is already open");
316         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
317         _approve(address(this), address(uniswapV2Router), _tTotal);
318         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
319         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
320         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
321         swapEnabled = true;
322         tradingOpen = true;
323     }
324 
325     receive() external payable {}
326 
327     function isContract(address account) private view returns (bool) {
328         uint256 size;
329         assembly {
330             size := extcodesize(account)
331         }
332         return size > 0;
333     }
334 
335     function manualSwap() external {
336         require(_msgSender()==_taxWallet);
337         uint256 tokenBalance=balanceOf(address(this));
338         if(tokenBalance>0){
339           swapTokensForEth(tokenBalance);
340         }
341         uint256 ethBalance=address(this).balance;
342         if(ethBalance>0){
343           sendETHToFee(ethBalance);
344         }
345     }
346 
347     
348     
349     
350 }