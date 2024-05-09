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
11 WELCOME TO UNIFROG 
12 
13 Unicorns are awesome and frogs are born as princes 
14 
15 PEPE is the definition of pre historic. When 2 worlds collide a new dominant species is born.
16 
17 The only autismo coin you'll ever need, is HERE to demonstrate Darwin’s theory of evolution.
18 
19 Hop in and hold your dick tight in your hands.
20 
21 Tax: 2/2 
22 
23 Telegram : https://t.me/unifrogportal
24 Twitter : https://x.com/unifrogerc20
25 Website : https://unifrog.xyz/ 
26 
27 
28 **/
29 // SPDX-License-Identifier: MIT
30 
31 
32 pragma solidity 0.8.20;
33 
34 abstract contract Context {
35     function _msgSender() internal view virtual returns (address) {
36         return msg.sender;
37     }
38 }
39 
40 interface IERC20 {
41     function totalSupply() external view returns (uint256);
42     function balanceOf(address account) external view returns (uint256);
43     function transfer(address recipient, uint256 amount) external returns (bool);
44     function allowance(address owner, address spender) external view returns (uint256);
45     function approve(address spender, uint256 amount) external returns (bool);
46     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
47     event Transfer(address indexed from, address indexed to, uint256 value);
48     event Approval(address indexed owner, address indexed spender, uint256 value);
49 }
50 
51 library SafeMath {
52     function add(uint256 a, uint256 b) internal pure returns (uint256) {
53         uint256 c = a + b;
54         require(c >= a, "SafeMath: addition overflow");
55         return c;
56     }
57 
58     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
59         return sub(a, b, "SafeMath: subtraction overflow");
60     }
61 
62     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
63         require(b <= a, errorMessage);
64         uint256 c = a - b;
65         return c;
66     }
67 
68     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
69         if (a == 0) {
70             return 0;
71         }
72         uint256 c = a * b;
73         require(c / a == b, "SafeMath: multiplication overflow");
74         return c;
75     }
76 
77     function div(uint256 a, uint256 b) internal pure returns (uint256) {
78         return div(a, b, "SafeMath: division by zero");
79     }
80 
81     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
82         require(b > 0, errorMessage);
83         uint256 c = a / b;
84         return c;
85     }
86 
87 }
88 
89 contract Ownable is Context {
90     address private _owner;
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     constructor () {
94         address msgSender = _msgSender();
95         _owner = msgSender;
96         emit OwnershipTransferred(address(0), msgSender);
97     }
98 
99     function owner() public view returns (address) {
100         return _owner;
101     }
102 
103     modifier onlyOwner() {
104         require(_owner == _msgSender(), "Ownable: caller is not the owner");
105         _;
106     }
107 
108     function renounceOwnership() public virtual onlyOwner {
109         emit OwnershipTransferred(_owner, address(0));
110         _owner = address(0);
111     }
112 
113 }
114 
115 interface IUniswapV2Factory {
116     function createPair(address tokenA, address tokenB) external returns (address pair);
117 }
118 
119 interface IUniswapV2Router02 {
120     function swapExactTokensForETHSupportingFeeOnTransferTokens(
121         uint amountIn,
122         uint amountOutMin,
123         address[] calldata path,
124         address to,
125         uint deadline
126     ) external;
127     function factory() external pure returns (address);
128     function WETH() external pure returns (address);
129     function addLiquidityETH(
130         address token,
131         uint amountTokenDesired,
132         uint amountTokenMin,
133         uint amountETHMin,
134         address to,
135         uint deadline
136     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
137 }
138 
139 contract UNIFROG is Context, IERC20, Ownable {
140     using SafeMath for uint256;
141     mapping (address => uint256) private _balances;
142     mapping (address => mapping (address => uint256)) private _allowances;
143     mapping (address => bool) private _isExcludedFromFee;
144     mapping (address => bool) private _buyerMap;
145     mapping (address => bool) private bots;
146     mapping(address => uint256) private _holderLastTransferTimestamp;
147     bool public transferDelayEnabled = false;
148     address payable private _taxWallet;
149 
150     uint256 private _initialBuyTax=25;
151     uint256 private _initialSellTax=25;
152     uint256 private _finalBuyTax=0;
153     uint256 private _finalSellTax=0;
154     uint256 private _reduceBuyTaxAt=50;
155     uint256 private _reduceSellTaxAt=50;
156     uint256 private _preventSwapBefore=40;
157     uint256 private _buyCount=0;
158 
159     uint8 private constant _decimals = 8;
160     uint256 private constant _tTotal = 69696969 * 10**_decimals;
161     string private constant _name = unicode"UNIFROG";
162     string private constant _symbol = unicode"UNIFROG";
163     uint256 public _maxTxAmount =   1393939  * 10**_decimals;
164     uint256 public _maxWalletSize = 1393939  * 10**_decimals;
165     uint256 public _taxSwapThreshold=696969  * 10**_decimals;
166     uint256 public _maxTaxSwap=696969  * 10**_decimals;
167 
168     IUniswapV2Router02 private uniswapV2Router;
169     address private uniswapV2Pair;
170     bool private tradingOpen;
171     bool private inSwap = false;
172     bool private swapEnabled = false;
173 
174     event MaxTxAmountUpdated(uint _maxTxAmount);
175     modifier lockTheSwap {
176         inSwap = true;
177         _;
178         inSwap = false;
179     }
180 
181     constructor () {
182         _taxWallet = payable(_msgSender());
183         _balances[_msgSender()] = _tTotal;
184         _isExcludedFromFee[owner()] = true;
185         _isExcludedFromFee[address(this)] = true;
186         _isExcludedFromFee[_taxWallet] = true;
187 
188         emit Transfer(address(0), _msgSender(), _tTotal);
189     }
190 
191     function name() public pure returns (string memory) {
192         return _name;
193     }
194 
195     function symbol() public pure returns (string memory) {
196         return _symbol;
197     }
198 
199     function decimals() public pure returns (uint8) {
200         return _decimals;
201     }
202 
203     function totalSupply() public pure override returns (uint256) {
204         return _tTotal;
205     }
206 
207     function balanceOf(address account) public view override returns (uint256) {
208         return _balances[account];
209     }
210 
211     function transfer(address recipient, uint256 amount) public override returns (bool) {
212         _transfer(_msgSender(), recipient, amount);
213         return true;
214     }
215 
216     function allowance(address owner, address spender) public view override returns (uint256) {
217         return _allowances[owner][spender];
218     }
219 
220     function approve(address spender, uint256 amount) public override returns (bool) {
221         _approve(_msgSender(), spender, amount);
222         return true;
223     }
224 
225     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
226         _transfer(sender, recipient, amount);
227         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
228         return true;
229     }
230 
231     function _approve(address owner, address spender, uint256 amount) private {
232         require(owner != address(0), "ERC20: approve from the zero address");
233         require(spender != address(0), "ERC20: approve to the zero address");
234         _allowances[owner][spender] = amount;
235         emit Approval(owner, spender, amount);
236     }
237 
238     function _transfer(address from, address to, uint256 amount) private {
239         require(from != address(0), "ERC20: transfer from the zero address");
240         require(to != address(0), "ERC20: transfer to the zero address");
241         require(amount > 0, "Transfer amount must be greater than zero");
242         uint256 taxAmount=0;
243         if (from != owner() && to != owner()) {
244             require(!bots[from] && !bots[to]);
245 
246             if (transferDelayEnabled) {
247                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
248                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
249                   _holderLastTransferTimestamp[tx.origin] = block.number;
250                 }
251             }
252 
253             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
254                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
255                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
256                 if(_buyCount<_preventSwapBefore){
257                   require(!isContract(to));
258                 }
259                 _buyCount++;
260                 _buyerMap[to]=true;
261             }
262 
263 
264             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
265             if(to == uniswapV2Pair && from!= address(this) ){
266                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
267                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
268                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
269             }
270 
271             uint256 contractTokenBalance = balanceOf(address(this));
272             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
273                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
274                 uint256 contractETHBalance = address(this).balance;
275                 if(contractETHBalance > 0) {
276                     sendETHToFee(address(this).balance);
277                 }
278             }
279         }
280 
281         if(taxAmount>0){
282           _balances[address(this)]=_balances[address(this)].add(taxAmount);
283           emit Transfer(from, address(this),taxAmount);
284         }
285         _balances[from]=_balances[from].sub(amount);
286         _balances[to]=_balances[to].add(amount.sub(taxAmount));
287         emit Transfer(from, to, amount.sub(taxAmount));
288     }
289 
290 
291     function min(uint256 a, uint256 b) private pure returns (uint256){
292       return (a>b)?b:a;
293     }
294 
295     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
296         if(tokenAmount==0){return;}
297         if(!tradingOpen){return;}
298         address[] memory path = new address[](2);
299         path[0] = address(this);
300         path[1] = uniswapV2Router.WETH();
301         _approve(address(this), address(uniswapV2Router), tokenAmount);
302         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
303             tokenAmount,
304             0,
305             path,
306             address(this),
307             block.timestamp
308         );
309     }
310 
311     function removeLimits() external onlyOwner{
312         _maxTxAmount = _tTotal;
313         _maxWalletSize=_tTotal;
314         transferDelayEnabled=false;
315         emit MaxTxAmountUpdated(_tTotal);
316     }
317 
318     function sendETHToFee(uint256 amount) private {
319         _taxWallet.transfer(amount);
320     }
321 
322     function isBot(address a) public view returns (bool){
323       return bots[a];
324     }
325 
326     function openTheUnifrog() external onlyOwner() {
327         require(!tradingOpen,"trading is already open");
328         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
329         _approve(address(this), address(uniswapV2Router), _tTotal);
330         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
331         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
332         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
333         swapEnabled = true;
334         tradingOpen = true;
335     }
336 
337     receive() external payable {}
338 
339     function isContract(address account) private view returns (bool) {
340         uint256 size;
341         assembly {
342             size := extcodesize(account)
343         }
344         return size > 0;
345     }
346 
347     function manualSwap() external {
348         require(_msgSender()==_taxWallet);
349         uint256 tokenBalance=balanceOf(address(this));
350         if(tokenBalance>0){
351           swapTokensForEth(tokenBalance);
352         }
353         uint256 ethBalance=address(this).balance;
354         if(ethBalance>0){
355           sendETHToFee(ethBalance);
356         }
357     }
358 
359     
360     
361     
362 }