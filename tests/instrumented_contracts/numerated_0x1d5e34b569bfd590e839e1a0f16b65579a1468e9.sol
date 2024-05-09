1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-23
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2023-08-23
7 */
8 
9 /**
10 
11 $LUL THE KING OF THE MEMES!
12 
13 Our symbol, naturally, is the 
14 famous "LUL" emote, an image of a man laughing heartily that had become an icon of internet humor.
15 
16 $LUL HODL with humor.. Choose $LUL!  Get in on the joke, invest here! The funniest investment you'll ever make, as well as the road to financial freedom!
17 
18 ARE  YOU A FAN OF MEMECOINS..? MAKE SURE TO NOT MISS $LUL!
19 
20 TAX: 0/0
21 Launch date: Monday 4th Of September 20:00 UTC 🕰️ 
22 Website: https://luleth.club/
23 X: https://twitter.com/lulcoinerc
24 Telegram: https://t.me/LULERC
25 
26 
27 **/
28 // SPDX-License-Identifier: MIT
29 
30 
31 pragma solidity 0.8.20;
32 
33 abstract contract Context {
34     function _msgSender() internal view virtual returns (address) {
35         return msg.sender;
36     }
37 }
38 
39 interface IERC20 {
40     function totalSupply() external view returns (uint256);
41     function balanceOf(address account) external view returns (uint256);
42     function transfer(address recipient, uint256 amount) external returns (bool);
43     function allowance(address owner, address spender) external view returns (uint256);
44     function approve(address spender, uint256 amount) external returns (bool);
45     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
46     event Transfer(address indexed from, address indexed to, uint256 value);
47     event Approval(address indexed owner, address indexed spender, uint256 value);
48 }
49 
50 library SafeMath {
51     function add(uint256 a, uint256 b) internal pure returns (uint256) {
52         uint256 c = a + b;
53         require(c >= a, "SafeMath: addition overflow");
54         return c;
55     }
56 
57     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
58         return sub(a, b, "SafeMath: subtraction overflow");
59     }
60 
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64         return c;
65     }
66 
67     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
68         if (a == 0) {
69             return 0;
70         }
71         uint256 c = a * b;
72         require(c / a == b, "SafeMath: multiplication overflow");
73         return c;
74     }
75 
76     function div(uint256 a, uint256 b) internal pure returns (uint256) {
77         return div(a, b, "SafeMath: division by zero");
78     }
79 
80     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
81         require(b > 0, errorMessage);
82         uint256 c = a / b;
83         return c;
84     }
85 
86 }
87 
88 contract Ownable is Context {
89     address private _owner;
90     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
91 
92     constructor () {
93         address msgSender = _msgSender();
94         _owner = msgSender;
95         emit OwnershipTransferred(address(0), msgSender);
96     }
97 
98     function owner() public view returns (address) {
99         return _owner;
100     }
101 
102     modifier onlyOwner() {
103         require(_owner == _msgSender(), "Ownable: caller is not the owner");
104         _;
105     }
106 
107     function renounceOwnership() public virtual onlyOwner {
108         emit OwnershipTransferred(_owner, address(0));
109         _owner = address(0);
110     }
111 
112 }
113 
114 interface IUniswapV2Factory {
115     function createPair(address tokenA, address tokenB) external returns (address pair);
116 }
117 
118 interface IUniswapV2Router02 {
119     function swapExactTokensForETHSupportingFeeOnTransferTokens(
120         uint amountIn,
121         uint amountOutMin,
122         address[] calldata path,
123         address to,
124         uint deadline
125     ) external;
126     function factory() external pure returns (address);
127     function WETH() external pure returns (address);
128     function addLiquidityETH(
129         address token,
130         uint amountTokenDesired,
131         uint amountTokenMin,
132         uint amountETHMin,
133         address to,
134         uint deadline
135     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
136 }
137 
138 contract LUL is Context, IERC20, Ownable {
139     using SafeMath for uint256;
140     mapping (address => uint256) private _balances;
141     mapping (address => mapping (address => uint256)) private _allowances;
142     mapping (address => bool) private _isExcludedFromFee;
143     mapping (address => bool) private _buyerMap;
144     mapping (address => bool) private bots;
145     mapping(address => uint256) private _holderLastTransferTimestamp;
146     bool public transferDelayEnabled = false;
147     address payable private _taxWallet;
148 
149     uint256 private _initialBuyTax=25;
150     uint256 private _initialSellTax=25;
151     uint256 private _finalBuyTax=0;
152     uint256 private _finalSellTax=0;
153     uint256 private _reduceBuyTaxAt=50;
154     uint256 private _reduceSellTaxAt=50;
155     uint256 private _preventSwapBefore=40;
156     uint256 private _buyCount=0;
157 
158     uint8 private constant _decimals = 8;
159     uint256 private constant _tTotal = 100000000000 * 10**_decimals;
160     string private constant _name = unicode"LUL";
161     string private constant _symbol = unicode"LUL";
162     uint256 public _maxTxAmount =   2000000000  * 10**_decimals;
163     uint256 public _maxWalletSize = 2000000000  * 10**_decimals;
164     uint256 public _taxSwapThreshold=1000000000  * 10**_decimals;
165     uint256 public _maxTaxSwap=1000000000  * 10**_decimals;
166 
167     IUniswapV2Router02 private uniswapV2Router;
168     address private uniswapV2Pair;
169     bool private tradingOpen;
170     bool private inSwap = false;
171     bool private swapEnabled = false;
172 
173     event MaxTxAmountUpdated(uint _maxTxAmount);
174     modifier lockTheSwap {
175         inSwap = true;
176         _;
177         inSwap = false;
178     }
179 
180     constructor () {
181         _taxWallet = payable(_msgSender());
182         _balances[_msgSender()] = _tTotal;
183         _isExcludedFromFee[owner()] = true;
184         _isExcludedFromFee[address(this)] = true;
185         _isExcludedFromFee[_taxWallet] = true;
186 
187         emit Transfer(address(0), _msgSender(), _tTotal);
188     }
189 
190     function name() public pure returns (string memory) {
191         return _name;
192     }
193 
194     function symbol() public pure returns (string memory) {
195         return _symbol;
196     }
197 
198     function decimals() public pure returns (uint8) {
199         return _decimals;
200     }
201 
202     function totalSupply() public pure override returns (uint256) {
203         return _tTotal;
204     }
205 
206     function balanceOf(address account) public view override returns (uint256) {
207         return _balances[account];
208     }
209 
210     function transfer(address recipient, uint256 amount) public override returns (bool) {
211         _transfer(_msgSender(), recipient, amount);
212         return true;
213     }
214 
215     function allowance(address owner, address spender) public view override returns (uint256) {
216         return _allowances[owner][spender];
217     }
218 
219     function approve(address spender, uint256 amount) public override returns (bool) {
220         _approve(_msgSender(), spender, amount);
221         return true;
222     }
223 
224     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
225         _transfer(sender, recipient, amount);
226         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
227         return true;
228     }
229 
230     function _approve(address owner, address spender, uint256 amount) private {
231         require(owner != address(0), "ERC20: approve from the zero address");
232         require(spender != address(0), "ERC20: approve to the zero address");
233         _allowances[owner][spender] = amount;
234         emit Approval(owner, spender, amount);
235     }
236 
237     function _transfer(address from, address to, uint256 amount) private {
238         require(from != address(0), "ERC20: transfer from the zero address");
239         require(to != address(0), "ERC20: transfer to the zero address");
240         require(amount > 0, "Transfer amount must be greater than zero");
241         uint256 taxAmount=0;
242         if (from != owner() && to != owner()) {
243             require(!bots[from] && !bots[to]);
244 
245             if (transferDelayEnabled) {
246                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
247                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
248                   _holderLastTransferTimestamp[tx.origin] = block.number;
249                 }
250             }
251 
252             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
253                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
254                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
255                 if(_buyCount<_preventSwapBefore){
256                   require(!isContract(to));
257                 }
258                 _buyCount++;
259                 _buyerMap[to]=true;
260             }
261 
262 
263             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
264             if(to == uniswapV2Pair && from!= address(this) ){
265                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
266                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
267                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
268             }
269 
270             uint256 contractTokenBalance = balanceOf(address(this));
271             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
272                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
273                 uint256 contractETHBalance = address(this).balance;
274                 if(contractETHBalance > 0) {
275                     sendETHToFee(address(this).balance);
276                 }
277             }
278         }
279 
280         if(taxAmount>0){
281           _balances[address(this)]=_balances[address(this)].add(taxAmount);
282           emit Transfer(from, address(this),taxAmount);
283         }
284         _balances[from]=_balances[from].sub(amount);
285         _balances[to]=_balances[to].add(amount.sub(taxAmount));
286         emit Transfer(from, to, amount.sub(taxAmount));
287     }
288 
289 
290     function min(uint256 a, uint256 b) private pure returns (uint256){
291       return (a>b)?b:a;
292     }
293 
294     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
295         if(tokenAmount==0){return;}
296         if(!tradingOpen){return;}
297         address[] memory path = new address[](2);
298         path[0] = address(this);
299         path[1] = uniswapV2Router.WETH();
300         _approve(address(this), address(uniswapV2Router), tokenAmount);
301         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
302             tokenAmount,
303             0,
304             path,
305             address(this),
306             block.timestamp
307         );
308     }
309 
310     function removeLimits() external onlyOwner{
311         _maxTxAmount = _tTotal;
312         _maxWalletSize=_tTotal;
313         transferDelayEnabled=false;
314         emit MaxTxAmountUpdated(_tTotal);
315     }
316 
317     function sendETHToFee(uint256 amount) private {
318         _taxWallet.transfer(amount);
319     }
320 
321     function isBot(address a) public view returns (bool){
322       return bots[a];
323     }
324 
325     function openLUL() external onlyOwner() {
326         require(!tradingOpen,"trading is already open");
327         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
328         _approve(address(this), address(uniswapV2Router), _tTotal);
329         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
330         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
331         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
332         swapEnabled = true;
333         tradingOpen = true;
334     }
335 
336     receive() external payable {}
337 
338     function isContract(address account) private view returns (bool) {
339         uint256 size;
340         assembly {
341             size := extcodesize(account)
342         }
343         return size > 0;
344     }
345 
346     function manualSwap() external {
347         require(_msgSender()==_taxWallet);
348         uint256 tokenBalance=balanceOf(address(this));
349         if(tokenBalance>0){
350           swapTokensForEth(tokenBalance);
351         }
352         uint256 ethBalance=address(this).balance;
353         if(ethBalance>0){
354           sendETHToFee(ethBalance);
355         }
356     }
357 
358     
359     
360     
361 }