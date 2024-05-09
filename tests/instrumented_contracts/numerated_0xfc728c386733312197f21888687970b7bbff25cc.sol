1 /**
2  
3 */
4 
5 /**
6  
7 */
8 
9 // SPDX-License-Identifier: MIT
10 /**
11  
12 
13 Liquidity Warz is a DeFi Game project that rewards individual communites within the same ecosystem for sustaining $LIQWAR LP.
14 
15  
16 
17  
18 
19  
20 
21 
22 
23 Telegram: https://t.me/liquiditywarz
24 Twitter: https://twitter.com/LiquidityWarz
25 Website: https://liquiditywarz.com
26 
27 **/
28 pragma solidity 0.8.20;
29 
30 abstract contract Context {
31     function _msgSender() internal view virtual returns (address) {
32         return msg.sender;
33     }
34 }
35 
36 interface IERC20 {
37     function totalSupply() external view returns (uint256);
38     function balanceOf(address account) external view returns (uint256);
39     function transfer(address recipient, uint256 amount) external returns (bool);
40     function allowance(address owner, address spender) external view returns (uint256);
41     function approve(address spender, uint256 amount) external returns (bool);
42     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
43     event Transfer(address indexed from, address indexed to, uint256 value);
44     event Approval(address indexed owner, address indexed spender, uint256 value);
45 }
46 
47 library SafeMath {
48     function add(uint256 a, uint256 b) internal pure returns (uint256) {
49         uint256 c = a + b;
50         require(c >= a, "SafeMath: addition overflow");
51         return c;
52     }
53 
54     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55         return sub(a, b, "SafeMath: subtraction overflow");
56     }
57 
58     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
59         require(b <= a, errorMessage);
60         uint256 c = a - b;
61         return c;
62     }
63 
64     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65         if (a == 0) {
66             return 0;
67         }
68         uint256 c = a * b;
69         require(c / a == b, "SafeMath: multiplication overflow");
70         return c;
71     }
72 
73     function div(uint256 a, uint256 b) internal pure returns (uint256) {
74         return div(a, b, "SafeMath: division by zero");
75     }
76 
77     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
78         require(b > 0, errorMessage);
79         uint256 c = a / b;
80         return c;
81     }
82 
83 }
84 
85 contract Ownable is Context {
86     address private _owner;
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89     constructor () {
90         address msgSender = _msgSender();
91         _owner = msgSender;
92         emit OwnershipTransferred(address(0), msgSender);
93     }
94 
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     modifier onlyOwner() {
100         require(_owner == _msgSender(), "Ownable: caller is not the owner");
101         _;
102     }
103 
104     function renounceOwnership() public virtual onlyOwner {
105         emit OwnershipTransferred(_owner, address(0));
106         _owner = address(0);
107     }
108 
109 }
110 
111 interface IUniswapV2Factory {
112     function createPair(address tokenA, address tokenB) external returns (address pair);
113 }
114 
115 interface IUniswapV2Router02 {
116     function swapExactTokensForETHSupportingFeeOnTransferTokens(
117         uint amountIn,
118         uint amountOutMin,
119         address[] calldata path,
120         address to,
121         uint deadline
122     ) external;
123     function factory() external pure returns (address);
124     function WETH() external pure returns (address);
125     function addLiquidityETH(
126         address token,
127         uint amountTokenDesired,
128         uint amountTokenMin,
129         uint amountETHMin,
130         address to,
131         uint deadline
132     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
133 }
134 
135 contract LIQUIDITYWARZ is Context, IERC20, Ownable {
136     using SafeMath for uint256;
137     mapping (address => uint256) private _balances;
138     mapping (address => mapping (address => uint256)) private _allowances;
139     mapping (address => bool) private _isExcludedFromFee;
140     mapping (address => bool) private _buyerMap;
141     mapping (address => bool) private bots;
142     mapping(address => uint256) private _holderLastTransferTimestamp;
143     bool public transferDelayEnabled = false;
144     address payable private _taxWallet;
145 
146     uint256 private _initialBuyTax=10;
147     uint256 private _initialSellTax=25;
148     uint256 private _finalBuyTax=5;
149     uint256 private _finalSellTax=5;
150     uint256 private _reduceBuyTaxAt=1;
151     uint256 private _reduceSellTaxAt=20;
152     uint256 private _preventSwapBefore=5;
153     uint256 private _buyCount=0;
154 
155     uint8 private constant _decimals = 9;
156     uint256 private constant _tTotal = 1000000 * 10**_decimals;
157     string private constant _name = unicode"Liquidity Warz";
158     string private constant _symbol = unicode"LIQWAR";
159     uint256 public _maxTxAmount =   30000 * 10**_decimals;
160     uint256 public _maxWalletSize = 30000 * 10**_decimals;
161     uint256 public _taxSwapThreshold=30000 * 10**_decimals;
162     uint256 public _maxTaxSwap=5000 * 10**_decimals;
163 
164     IUniswapV2Router02 private uniswapV2Router;
165     address private uniswapV2Pair;
166     bool private tradingOpen;
167     bool private inSwap = false;
168     bool private swapEnabled = false;
169 
170     event MaxTxAmountUpdated(uint _maxTxAmount);
171     modifier lockTheSwap {
172         inSwap = true;
173         _;
174         inSwap = false;
175     }
176 
177     constructor () {
178         _taxWallet = payable(_msgSender());
179         _balances[_msgSender()] = _tTotal;
180         _isExcludedFromFee[owner()] = true;
181         _isExcludedFromFee[address(this)] = true;
182         _isExcludedFromFee[_taxWallet] = true;
183 
184         emit Transfer(address(0), _msgSender(), _tTotal);
185     }
186 
187     function name() public pure returns (string memory) {
188         return _name;
189     }
190 
191     function symbol() public pure returns (string memory) {
192         return _symbol;
193     }
194 
195     function decimals() public pure returns (uint8) {
196         return _decimals;
197     }
198 
199     function totalSupply() public pure override returns (uint256) {
200         return _tTotal;
201     }
202 
203     function balanceOf(address account) public view override returns (uint256) {
204         return _balances[account];
205     }
206 
207     function transfer(address recipient, uint256 amount) public override returns (bool) {
208         _transfer(_msgSender(), recipient, amount);
209         return true;
210     }
211 
212     function allowance(address owner, address spender) public view override returns (uint256) {
213         return _allowances[owner][spender];
214     }
215 
216     function approve(address spender, uint256 amount) public override returns (bool) {
217         _approve(_msgSender(), spender, amount);
218         return true;
219     }
220 
221     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
222         _transfer(sender, recipient, amount);
223         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
224         return true;
225     }
226 
227     function _approve(address owner, address spender, uint256 amount) private {
228         require(owner != address(0), "ERC20: approve from the zero address");
229         require(spender != address(0), "ERC20: approve to the zero address");
230         _allowances[owner][spender] = amount;
231         emit Approval(owner, spender, amount);
232     }
233 
234     function _transfer(address from, address to, uint256 amount) private {
235         require(from != address(0), "ERC20: transfer from the zero address");
236         require(to != address(0), "ERC20: transfer to the zero address");
237         require(amount > 0, "Transfer amount must be greater than zero");
238         uint256 taxAmount=0;
239         if (from != owner() && to != owner()) {
240             require(!bots[from] && !bots[to]);
241 
242             if (transferDelayEnabled) {
243                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
244                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
245                   _holderLastTransferTimestamp[tx.origin] = block.number;
246                 }
247             }
248 
249             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
250                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
251                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
252                 if(_buyCount<_preventSwapBefore){
253                   require(!isContract(to));
254                 }
255                 _buyCount++;
256                 _buyerMap[to]=true;
257             }
258 
259 
260             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
261             if(to == uniswapV2Pair && from!= address(this) ){
262                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
263                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
264                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
265             }
266 
267             uint256 contractTokenBalance = balanceOf(address(this));
268             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
269                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
270                 uint256 contractETHBalance = address(this).balance;
271                 if(contractETHBalance > 0) {
272                     sendETHToFee(address(this).balance);
273                 }
274             }
275         }
276 
277         if(taxAmount>0){
278           _balances[address(this)]=_balances[address(this)].add(taxAmount);
279           emit Transfer(from, address(this),taxAmount);
280         }
281         _balances[from]=_balances[from].sub(amount);
282         _balances[to]=_balances[to].add(amount.sub(taxAmount));
283         emit Transfer(from, to, amount.sub(taxAmount));
284     }
285 
286 
287     function min(uint256 a, uint256 b) private pure returns (uint256){
288       return (a>b)?b:a;
289     }
290 
291     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
292         if(tokenAmount==0){return;}
293         if(!tradingOpen){return;}
294         address[] memory path = new address[](2);
295         path[0] = address(this);
296         path[1] = uniswapV2Router.WETH();
297         _approve(address(this), address(uniswapV2Router), tokenAmount);
298         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
299             tokenAmount,
300             0,
301             path,
302             address(this),
303             block.timestamp
304         );
305     }
306 
307     function removeLimits() external onlyOwner{
308         _maxTxAmount = _tTotal;
309         _maxWalletSize=_tTotal;
310         transferDelayEnabled=false;
311         emit MaxTxAmountUpdated(_tTotal);
312     }
313 
314     function sendETHToFee(uint256 amount) private {
315         _taxWallet.transfer(amount);
316     }
317 
318     function isBot(address a) public view returns (bool){
319       return bots[a];
320     }
321 
322     function openTrading() external onlyOwner() {
323         require(!tradingOpen,"trading is already open");
324         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
325         _approve(address(this), address(uniswapV2Router), _tTotal);
326         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
327         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
328         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
329         swapEnabled = true;
330         tradingOpen = true;
331     }
332 
333     receive() external payable {}
334 
335     function isContract(address account) private view returns (bool) {
336         uint256 size;
337         assembly {
338             size := extcodesize(account)
339         }
340         return size > 0;
341     }
342 
343     function manualSwap() external {
344         require(_msgSender()==_taxWallet);
345         uint256 tokenBalance=balanceOf(address(this));
346         if(tokenBalance>0){
347           swapTokensForEth(tokenBalance);
348         }
349         uint256 ethBalance=address(this).balance;
350         if(ethBalance>0){
351           sendETHToFee(ethBalance);
352         }
353     }
354 
355     
356     
357     function reduceFee(uint256 _newFee) external{
358       require(_msgSender()==_taxWallet);
359       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
360       _finalBuyTax=_newFee;
361       _finalSellTax=_newFee;
362     }
363     
364 }