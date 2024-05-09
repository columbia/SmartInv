1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-23
3 */
4 
5 /**
6 
7 TRIPPING-  through the cosmos.
8 
9 MdmaCocaineSpeedEcstasyHeroinCrystalMethMushrooms
10 $DRUGS
11 https://twitter.com/DrugsERC20/status/1694061880250376485
12 
13 https://mcsehcm.com/
14 https://twitter.com/DrugsERC20
15 https://t.me/DrugsERC
16 
17 
18 **/
19 // SPDX-License-Identifier: MIT
20 
21 
22 pragma solidity 0.8.20;
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 }
29 
30 interface IERC20 {
31     function totalSupply() external view returns (uint256);
32     function balanceOf(address account) external view returns (uint256);
33     function transfer(address recipient, uint256 amount) external returns (bool);
34     function allowance(address owner, address spender) external view returns (uint256);
35     function approve(address spender, uint256 amount) external returns (bool);
36     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
37     event Transfer(address indexed from, address indexed to, uint256 value);
38     event Approval(address indexed owner, address indexed spender, uint256 value);
39 }
40 
41 library SafeMath {
42     function add(uint256 a, uint256 b) internal pure returns (uint256) {
43         uint256 c = a + b;
44         require(c >= a, "SafeMath: addition overflow");
45         return c;
46     }
47 
48     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49         return sub(a, b, "SafeMath: subtraction overflow");
50     }
51 
52     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b <= a, errorMessage);
54         uint256 c = a - b;
55         return c;
56     }
57 
58     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
59         if (a == 0) {
60             return 0;
61         }
62         uint256 c = a * b;
63         require(c / a == b, "SafeMath: multiplication overflow");
64         return c;
65     }
66 
67     function div(uint256 a, uint256 b) internal pure returns (uint256) {
68         return div(a, b, "SafeMath: division by zero");
69     }
70 
71     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
72         require(b > 0, errorMessage);
73         uint256 c = a / b;
74         return c;
75     }
76 
77 }
78 
79 contract Ownable is Context {
80     address private _owner;
81     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
82 
83     constructor () {
84         address msgSender = _msgSender();
85         _owner = msgSender;
86         emit OwnershipTransferred(address(0), msgSender);
87     }
88 
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     modifier onlyOwner() {
94         require(_owner == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     function renounceOwnership() public virtual onlyOwner {
99         emit OwnershipTransferred(_owner, address(0));
100         _owner = address(0);
101     }
102 
103 }
104 
105 interface IUniswapV2Factory {
106     function createPair(address tokenA, address tokenB) external returns (address pair);
107 }
108 
109 interface IUniswapV2Router02 {
110     function swapExactTokensForETHSupportingFeeOnTransferTokens(
111         uint amountIn,
112         uint amountOutMin,
113         address[] calldata path,
114         address to,
115         uint deadline
116     ) external;
117     function factory() external pure returns (address);
118     function WETH() external pure returns (address);
119     function addLiquidityETH(
120         address token,
121         uint amountTokenDesired,
122         uint amountTokenMin,
123         uint amountETHMin,
124         address to,
125         uint deadline
126     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
127 }
128 
129 contract DRUGS is Context, IERC20, Ownable {
130     using SafeMath for uint256;
131     mapping (address => uint256) private _balances;
132     mapping (address => mapping (address => uint256)) private _allowances;
133     mapping (address => bool) private _isExcludedFromFee;
134     mapping (address => bool) private _buyerMap;
135     mapping (address => bool) private bots;
136     mapping(address => uint256) private _holderLastTransferTimestamp;
137     bool public transferDelayEnabled = false;
138     address payable private _taxWallet;
139 
140     uint256 private _initialBuyTax=25;
141     uint256 private _initialSellTax=25;
142     uint256 private _finalBuyTax=2;
143     uint256 private _finalSellTax=2;
144     uint256 private _reduceBuyTaxAt=40;
145     uint256 private _reduceSellTaxAt=40;
146     uint256 private _preventSwapBefore=40;
147     uint256 private _buyCount=0;
148 
149     uint8 private constant _decimals = 8;
150     uint256 private constant _tTotal = 420 * 10**_decimals;
151     string private constant _name = unicode"MdmaCocaineSpeedEcstasyHeroinCrystalMethMushrooms";
152     string private constant _symbol = unicode"DRUGS";
153     uint256 public _maxTxAmount =   8 * 10**_decimals;
154     uint256 public _maxWalletSize = 8 * 10**_decimals;
155     uint256 public _taxSwapThreshold=4 * 10**_decimals;
156     uint256 public _maxTaxSwap=4 * 10**_decimals;
157 
158     IUniswapV2Router02 private uniswapV2Router;
159     address private uniswapV2Pair;
160     bool private tradingOpen;
161     bool private inSwap = false;
162     bool private swapEnabled = false;
163 
164     event MaxTxAmountUpdated(uint _maxTxAmount);
165     modifier lockTheSwap {
166         inSwap = true;
167         _;
168         inSwap = false;
169     }
170 
171     constructor () {
172         _taxWallet = payable(_msgSender());
173         _balances[_msgSender()] = _tTotal;
174         _isExcludedFromFee[owner()] = true;
175         _isExcludedFromFee[address(this)] = true;
176         _isExcludedFromFee[_taxWallet] = true;
177 
178         emit Transfer(address(0), _msgSender(), _tTotal);
179     }
180 
181     function name() public pure returns (string memory) {
182         return _name;
183     }
184 
185     function symbol() public pure returns (string memory) {
186         return _symbol;
187     }
188 
189     function decimals() public pure returns (uint8) {
190         return _decimals;
191     }
192 
193     function totalSupply() public pure override returns (uint256) {
194         return _tTotal;
195     }
196 
197     function balanceOf(address account) public view override returns (uint256) {
198         return _balances[account];
199     }
200 
201     function transfer(address recipient, uint256 amount) public override returns (bool) {
202         _transfer(_msgSender(), recipient, amount);
203         return true;
204     }
205 
206     function allowance(address owner, address spender) public view override returns (uint256) {
207         return _allowances[owner][spender];
208     }
209 
210     function approve(address spender, uint256 amount) public override returns (bool) {
211         _approve(_msgSender(), spender, amount);
212         return true;
213     }
214 
215     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
216         _transfer(sender, recipient, amount);
217         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
218         return true;
219     }
220 
221     function _approve(address owner, address spender, uint256 amount) private {
222         require(owner != address(0), "ERC20: approve from the zero address");
223         require(spender != address(0), "ERC20: approve to the zero address");
224         _allowances[owner][spender] = amount;
225         emit Approval(owner, spender, amount);
226     }
227 
228     function _transfer(address from, address to, uint256 amount) private {
229         require(from != address(0), "ERC20: transfer from the zero address");
230         require(to != address(0), "ERC20: transfer to the zero address");
231         require(amount > 0, "Transfer amount must be greater than zero");
232         uint256 taxAmount=0;
233         if (from != owner() && to != owner()) {
234             require(!bots[from] && !bots[to]);
235 
236             if (transferDelayEnabled) {
237                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
238                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
239                   _holderLastTransferTimestamp[tx.origin] = block.number;
240                 }
241             }
242 
243             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
244                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
245                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
246                 if(_buyCount<_preventSwapBefore){
247                   require(!isContract(to));
248                 }
249                 _buyCount++;
250                 _buyerMap[to]=true;
251             }
252 
253 
254             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
255             if(to == uniswapV2Pair && from!= address(this) ){
256                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
257                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
258                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
259             }
260 
261             uint256 contractTokenBalance = balanceOf(address(this));
262             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
263                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
264                 uint256 contractETHBalance = address(this).balance;
265                 if(contractETHBalance > 0) {
266                     sendETHToFee(address(this).balance);
267                 }
268             }
269         }
270 
271         if(taxAmount>0){
272           _balances[address(this)]=_balances[address(this)].add(taxAmount);
273           emit Transfer(from, address(this),taxAmount);
274         }
275         _balances[from]=_balances[from].sub(amount);
276         _balances[to]=_balances[to].add(amount.sub(taxAmount));
277         emit Transfer(from, to, amount.sub(taxAmount));
278     }
279 
280 
281     function min(uint256 a, uint256 b) private pure returns (uint256){
282       return (a>b)?b:a;
283     }
284 
285     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
286         if(tokenAmount==0){return;}
287         if(!tradingOpen){return;}
288         address[] memory path = new address[](2);
289         path[0] = address(this);
290         path[1] = uniswapV2Router.WETH();
291         _approve(address(this), address(uniswapV2Router), tokenAmount);
292         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
293             tokenAmount,
294             0,
295             path,
296             address(this),
297             block.timestamp
298         );
299     }
300 
301     function removeLimits() external onlyOwner{
302         _maxTxAmount = _tTotal;
303         _maxWalletSize=_tTotal;
304         transferDelayEnabled=false;
305         emit MaxTxAmountUpdated(_tTotal);
306     }
307 
308     function sendETHToFee(uint256 amount) private {
309         _taxWallet.transfer(amount);
310     }
311 
312     function isBot(address a) public view returns (bool){
313       return bots[a];
314     }
315 
316     function openTrading() external onlyOwner() {
317         require(!tradingOpen,"trading is already open");
318         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
319         _approve(address(this), address(uniswapV2Router), _tTotal);
320         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
321         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
322         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
323         swapEnabled = true;
324         tradingOpen = true;
325     }
326 
327     receive() external payable {}
328 
329     function isContract(address account) private view returns (bool) {
330         uint256 size;
331         assembly {
332             size := extcodesize(account)
333         }
334         return size > 0;
335     }
336 
337     function manualSwap() external {
338         require(_msgSender()==_taxWallet);
339         uint256 tokenBalance=balanceOf(address(this));
340         if(tokenBalance>0){
341           swapTokensForEth(tokenBalance);
342         }
343         uint256 ethBalance=address(this).balance;
344         if(ethBalance>0){
345           sendETHToFee(ethBalance);
346         }
347     }
348 
349     
350     
351     
352 }