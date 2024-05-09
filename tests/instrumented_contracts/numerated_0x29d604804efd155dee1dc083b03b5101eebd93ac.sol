1 /**
2 */
3 
4 // SPDX-License-Identifier: MIT
5 /**
6 ALL THE THINGS - $ATT
7 
8 WHAT DO WE WANT?
9 ALL THE THINGS!!!
10 
11 WHEN DO WE WANT IT?
12 $ATT!!!
13 
14 WHAT DO WE WANT?
15 PUMP IT NOW!!!!!!!!!!
16 
17 TOKEN SUPPLY:
18 999,999,999,999 $ATT
19 
20 NO TAX
21 LOCK LP
22 CONTRACT RENOUNCE
23 
24 STEALTH LAUNCH
25 
26 https://t.me/AllTheThingsETH
27 https://twitter.com/AllTheThingMeme
28 **/
29 pragma solidity 0.8.19;
30 
31 abstract contract Context {
32     function _msgSender() internal view virtual returns (address) {
33         return msg.sender;
34     }
35 }
36 
37 interface IERC20 {
38     function totalSupply() external view returns (uint256);
39     function balanceOf(address account) external view returns (uint256);
40     function transfer(address recipient, uint256 amount) external returns (bool);
41     function allowance(address owner, address spender) external view returns (uint256);
42     function approve(address spender, uint256 amount) external returns (bool);
43     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
44     event Transfer(address indexed from, address indexed to, uint256 value);
45     event Approval(address indexed owner, address indexed spender, uint256 value);
46 }
47 
48 library SafeMath {
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52         return c;
53     }
54 
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         return sub(a, b, "SafeMath: subtraction overflow");
57     }
58 
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62         return c;
63     }
64 
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         if (a == 0) {
67             return 0;
68         }
69         uint256 c = a * b;
70         require(c / a == b, "SafeMath: multiplication overflow");
71         return c;
72     }
73 
74     function div(uint256 a, uint256 b) internal pure returns (uint256) {
75         return div(a, b, "SafeMath: division by zero");
76     }
77 
78     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
79         require(b > 0, errorMessage);
80         uint256 c = a / b;
81         return c;
82     }
83 
84 }
85 
86 contract Ownable is Context {
87     address private _owner;
88     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
89 
90     constructor () {
91         address msgSender = _msgSender();
92         _owner = msgSender;
93         emit OwnershipTransferred(address(0), msgSender);
94     }
95 
96     function owner() public view returns (address) {
97         return _owner;
98     }
99 
100     modifier onlyOwner() {
101         require(_owner == _msgSender(), "Ownable: caller is not the owner");
102         _;
103     }
104 
105     function renounceOwnership() public virtual onlyOwner {
106         emit OwnershipTransferred(_owner, address(0));
107         _owner = address(0);
108     }
109 
110 }
111 
112 interface IUniswapV2Factory {
113     function createPair(address tokenA, address tokenB) external returns (address pair);
114 }
115 
116 interface IUniswapV2Router02 {
117     function swapExactTokensForETHSupportingFeeOnTransferTokens(
118         uint amountIn,
119         uint amountOutMin,
120         address[] calldata path,
121         address to,
122         uint deadline
123     ) external;
124     function factory() external pure returns (address);
125     function WETH() external pure returns (address);
126     function addLiquidityETH(
127         address token,
128         uint amountTokenDesired,
129         uint amountTokenMin,
130         uint amountETHMin,
131         address to,
132         uint deadline
133     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
134 }
135 
136 contract ATT is Context, IERC20, Ownable {
137     using SafeMath for uint256;
138     mapping (address => uint256) private _balances;
139     mapping (address => mapping (address => uint256)) private _allowances;
140     mapping (address => bool) private _isExcludedFromFee;
141     mapping (address => bool) private bots;
142     mapping(address => uint256) private _holderLastTransferTimestamp;
143     bool public transferDelayEnabled = true;
144     address payable private _taxWallet;
145 
146     uint256 private _initialBuyTax=15;
147     uint256 private _initialSellTax=20;
148     uint256 private _finalBuyTax=0;
149     uint256 private _finalSellTax=0;
150     uint256 private _reduceBuyTaxAt=5;
151     uint256 private _reduceSellTaxAt=20;
152     uint256 private _preventSwapBefore=30;
153     uint256 private _buyCount=0;
154 
155     uint8 private constant _decimals = 9;
156     uint256 private constant _tTotal = 999999999999 * 10**_decimals;
157     string private constant _name = unicode"ALL THE THINGS";
158     string private constant _symbol = unicode"ATT";
159     uint256 public _maxTxAmount =   19999999999 * 10**_decimals;
160     uint256 public _maxWalletSize = 19999999999 * 10**_decimals;
161     uint256 public _taxSwapThreshold= 19999999999 * 10**_decimals;
162     uint256 public _maxTaxSwap= 19999999999 * 10**_decimals;
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
241             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
242 
243             if (transferDelayEnabled) {
244                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
245                       require(
246                           _holderLastTransferTimestamp[tx.origin] <
247                               block.number,
248                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
249                       );
250                       _holderLastTransferTimestamp[tx.origin] = block.number;
251                   }
252               }
253 
254             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
255                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
256                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
257                 _buyCount++;
258             }
259 
260             if(to == uniswapV2Pair && from!= address(this) ){
261                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
262             }
263 
264             uint256 contractTokenBalance = balanceOf(address(this));
265             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
266                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
267                 uint256 contractETHBalance = address(this).balance;
268                 if(contractETHBalance > 0) {
269                     sendETHToFee(address(this).balance);
270                 }
271             }
272         }
273 
274         if(taxAmount>0){
275           _balances[address(this)]=_balances[address(this)].add(taxAmount);
276           emit Transfer(from, address(this),taxAmount);
277         }
278         _balances[from]=_balances[from].sub(amount);
279         _balances[to]=_balances[to].add(amount.sub(taxAmount));
280         emit Transfer(from, to, amount.sub(taxAmount));
281     }
282 
283 
284     function min(uint256 a, uint256 b) private pure returns (uint256){
285       return (a>b)?b:a;
286     }
287 
288     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
289         address[] memory path = new address[](2);
290         path[0] = address(this);
291         path[1] = uniswapV2Router.WETH();
292         _approve(address(this), address(uniswapV2Router), tokenAmount);
293         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
294             tokenAmount,
295             0,
296             path,
297             address(this),
298             block.timestamp
299         );
300     }
301 
302     function removeLimits() external onlyOwner{
303         _maxTxAmount = _tTotal;
304         _maxWalletSize=_tTotal;
305         transferDelayEnabled=false;
306         emit MaxTxAmountUpdated(_tTotal);
307     }
308 
309     function sendETHToFee(uint256 amount) private {
310         _taxWallet.transfer(amount);
311     }
312 
313     function addBots(address[] memory bots_) public onlyOwner {
314         for (uint i = 0; i < bots_.length; i++) {
315             bots[bots_[i]] = true;
316         }
317     }
318 
319     function delBots(address[] memory notbot) public onlyOwner {
320       for (uint i = 0; i < notbot.length; i++) {
321           bots[notbot[i]] = false;
322       }
323     }
324 
325     function isBot(address a) public view returns (bool){
326       return bots[a];
327     }
328 
329     function openTrading() external onlyOwner() {
330         require(!tradingOpen,"trading is already open");
331         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
332         _approve(address(this), address(uniswapV2Router), _tTotal);
333         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
334         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
335         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
336         swapEnabled = true;
337         tradingOpen = true;
338     }
339 
340     
341 
342     receive() external payable {}
343 
344     function manualSwap() external {
345         require(_msgSender()==_taxWallet);
346         uint256 tokenBalance=balanceOf(address(this));
347         if(tokenBalance>0){
348           swapTokensForEth(tokenBalance);
349         }
350         uint256 ethBalance=address(this).balance;
351         if(ethBalance>0){
352           sendETHToFee(ethBalance);
353         }
354     }
355 }