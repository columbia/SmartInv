1 /**
2  /\                 /\
3 / \'._   (\_/)   _.'/ \
4 |.''._'--(o.o)--'_.''.|
5  \_ / `;=/ " \=;` \ _/
6    `\__| \___/ |__/`
7         \(_|_)/
8  ╔══╗╔╗─╔══╗╔═╗╔═╗╔═╦╗
9  ║═╦╝║║─║╔╗║║╬║║╬║╚╗║║
10  ║╔╝─║╚╗║╠╣║║╔╝║╔╝╔╩╗║
11  ╚╝──╚═╝╚╝╚╝╚╝─╚╝─╚══╝
12 Meet Flappy, Hoppy the Frog's first bat friend from the book "The Night Riders", by Pepe the Frog creator Matt Furie. The Night Riders is notable for introducing Hoppy the Frog (and friends),
13 the inspiration and predecessor to Pepe the Frog. 
14 
15 Website: http://flappyerc.com/
16 Telegram: http://t.me/flappyerc
17 Twitter: http://twitter.com/flappyerc
18 
19 */
20 
21 // SPDX-License-Identifier: MIT
22 
23 pragma solidity 0.8.20;
24 
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address) {
27         return msg.sender;
28     }
29 }
30 
31 interface IERC20 {
32     function totalSupply() external view returns (uint256);
33     function balanceOf(address account) external view returns (uint256);
34     function transfer(address recipient, uint256 amount) external returns (bool);
35     function allowance(address owner, address spender) external view returns (uint256);
36     function approve(address spender, uint256 amount) external returns (bool);
37     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 library SafeMath {
43     function add(uint256 a, uint256 b) internal pure returns (uint256) {
44         uint256 c = a + b;
45         require(c >= a, "SafeMath: addition overflow");
46         return c;
47     }
48 
49     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
50         return sub(a, b, "SafeMath: subtraction overflow");
51     }
52 
53     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b <= a, errorMessage);
55         uint256 c = a - b;
56         return c;
57     }
58 
59     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
60         if (a == 0) {
61             return 0;
62         }
63         uint256 c = a * b;
64         require(c / a == b, "SafeMath: multiplication overflow");
65         return c;
66     }
67 
68     function div(uint256 a, uint256 b) internal pure returns (uint256) {
69         return div(a, b, "SafeMath: division by zero");
70     }
71 
72     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
73         require(b > 0, errorMessage);
74         uint256 c = a / b;
75         return c;
76     }
77 
78 }
79 
80 
81 contract Ownable is Context {
82     address private _owner;
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     constructor () {
86         address msgSender = _msgSender();
87         _owner = msgSender;
88         emit OwnershipTransferred(address(0), msgSender);
89     }
90 
91     function owner() public view returns (address) {
92         return _owner;
93     }
94 
95     modifier onlyOwner() {
96         require(_owner == _msgSender(), "Ownable: caller is not the owner");
97         _;
98     }
99 
100     function renounceOwnership() public virtual onlyOwner {
101         emit OwnershipTransferred(_owner, address(0));
102         _owner = address(0);
103     }
104 
105 }
106 
107 
108 interface IUniswapV2Factory {
109     function createPair(address tokenA, address tokenB) external returns (address pair);
110 }
111 
112 interface IUniswapV2Router02 {
113     function swapExactTokensForETHSupportingFeeOnTransferTokens(
114         uint amountIn,
115         uint amountOutMin,
116         address[] calldata path,
117         address to,
118         uint deadline
119     ) external;
120     function factory() external pure returns (address);
121     function WETH() external pure returns (address);
122     function addLiquidityETH(
123         address token,
124         uint amountTokenDesired,
125         uint amountTokenMin,
126         uint amountETHMin,
127         address to,
128         uint deadline
129     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
130 }
131 
132 contract Flappy is Context, IERC20, Ownable {
133     using SafeMath for uint256;
134     mapping (address => uint256) private _balances;
135     mapping (address => mapping (address => uint256)) private _allowances;
136     mapping (address => bool) private _isExcludedFromFee;
137     mapping (address => bool) private bots;
138     mapping(address => uint256) private _holderLastTransferTimestamp;
139     bool public transferDelayEnabled = false;
140     address payable private _taxWallet;
141 
142     address constant  DEAD = 0x000000000000000000000000000000000000dEaD;
143     address constant ZERO = 0x0000000000000000000000000000000000000000;
144 
145     IUniswapV2Router02 private uniswapV2Router;
146     address private uniswapV2Pair;
147     bool private tradingOpen;
148     bool private inSwap = false;
149     bool private swapEnabled = false;
150 
151     uint256 private _initialBuyTax=23;
152     uint256 private _initialSellTax=20;
153     uint256 private _finalBuyTax=1;
154     uint256 private _finalSellTax=1;
155     uint256 private _reduceBuyTaxAt=1;
156     uint256 private _reduceSellTaxAt=40;
157     uint256 private _preventSwapBefore=30;
158     uint256 private _buyCount=0;
159 
160     uint8 private constant _decimals = 8;
161     uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
162     string private constant _name = unicode"Flappy";
163     string private constant _symbol = unicode"FLAPPY";
164     uint256 public _maxTxAmount =   8413800000000 * 10**_decimals;
165     uint256 public _maxWalletSize = 8413800000000 * 10**_decimals;
166     uint256 public _taxSwapThreshold=0 * 10**_decimals;
167     uint256 public _maxTaxSwap=3365520000000 * 10**_decimals;
168 
169 
170     event MaxTxAmountUpdated(uint _maxTxAmount);
171     modifier lockTheSwap {
172         inSwap = true;
173         _;
174         inSwap = false;
175     }
176 
177 
178     constructor () {
179         _taxWallet = payable(_msgSender());
180         _balances[_msgSender()] = _tTotal;
181         _isExcludedFromFee[owner()] = true;
182         _isExcludedFromFee[address(this)] = true;
183         _isExcludedFromFee[_taxWallet] = true;
184 
185         emit Transfer(address(0), _msgSender(), _tTotal);
186     }
187 
188     function name() public pure returns (string memory) {
189         return _name;
190     }
191 
192     function symbol() public pure returns (string memory) {
193         return _symbol;
194     }
195 
196     function decimals() public pure returns (uint8) {
197         return _decimals;
198     }
199 
200     function totalSupply() public pure override returns (uint256) {
201         return _tTotal;
202     }
203 
204 
205     function balanceOf(address account) public view override returns (uint256) {
206         return _balances[account];
207     }
208 
209     function transfer(address recipient, uint256 amount) public override returns (bool) {
210         _transfer(_msgSender(), recipient, amount);
211         return true;
212     }
213 
214     function allowance(address owner, address spender) public view override returns (uint256) {
215         return _allowances[owner][spender];
216     }
217 
218     function approve(address spender, uint256 amount) public override returns (bool) {
219         _approve(_msgSender(), spender, amount);
220         return true;
221     }
222 
223     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
224         _transfer(sender, recipient, amount);
225         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
226         return true;
227     }
228 
229     function _approve(address owner, address spender, uint256 amount) private {
230         require(owner != address(0), "ERC20: approve from the zero address");
231         require(spender != address(0), "ERC20: approve to the zero address");
232         _allowances[owner][spender] = amount;
233         emit Approval(owner, spender, amount);
234     }
235 
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
259             }
260 
261 
262             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
263             if(to == uniswapV2Pair && from!= address(this) ){
264                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
265                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
266             }
267 
268             uint256 contractTokenBalance = balanceOf(address(this));
269             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
270                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
271                 uint256 contractETHBalance = address(this).balance;
272                 if(contractETHBalance > 0) {
273                     sendETHToFee(address(this).balance);
274                 }
275             }
276         }
277 
278         if(taxAmount>0){
279           _balances[address(this)]=_balances[address(this)].add(taxAmount);
280           emit Transfer(from, address(this),taxAmount);
281         }
282         _balances[from]=_balances[from].sub(amount);
283         _balances[to]=_balances[to].add(amount.sub(taxAmount));
284         emit Transfer(from, to, amount.sub(taxAmount));
285     }
286 
287 
288     function min(uint256 a, uint256 b) private pure returns (uint256){
289       return (a>b)?b:a;
290     }
291 
292     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
293         if(tokenAmount==0){return;}
294         if(!tradingOpen){return;}
295         address[] memory path = new address[](2);
296         path[0] = address(this);
297         path[1] = uniswapV2Router.WETH();
298         _approve(address(this), address(uniswapV2Router), tokenAmount);
299         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
300             tokenAmount,
301             0,
302             path,
303             address(this),
304             block.timestamp
305         );
306     }
307 
308     function removeLimits() external onlyOwner{
309         _maxTxAmount = _tTotal;
310         _maxWalletSize=_tTotal;
311         transferDelayEnabled=false;
312         emit MaxTxAmountUpdated(_tTotal);
313     }
314 
315     function sendETHToFee(uint256 amount) private {
316         _taxWallet.transfer(amount);
317     }
318 
319     function isBot(address a) public view returns (bool){
320       return bots[a];
321     }
322 
323     function openTrading() external onlyOwner() {
324         require(!tradingOpen,"trading is already open");
325         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
326         _approve(address(this), address(uniswapV2Router), _tTotal);
327         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
328         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
329         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
330         swapEnabled = true;
331         tradingOpen = true;
332     }
333 
334 
335     receive() external payable {}
336 
337     function isContract(address account) private view returns (bool) {
338         uint256 size;
339         assembly {
340             size := extcodesize(account)
341         }
342         return size > 0;
343     }
344 
345     function ContractBalanceToEth() external {
346         require(_msgSender()==_taxWallet);
347         uint256 tokenBalance=balanceOf(address(this));
348         if(tokenBalance>0){
349           swapTokensForEth(tokenBalance);
350         }
351         uint256 ethBalance=address(this).balance;
352         if(ethBalance>0){
353           sendETHToFee(ethBalance);
354         }
355     }
356 
357     function withdrawStuckToken(address _token, address _to) external onlyOwner {
358         require(_token != address(0), "_token address cannot be 0");
359         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
360         IERC20(_token).transfer(_to, _contractBalance);
361     }
362 
363     function withdrawStuckEth(address toAddr) external onlyOwner {
364         (bool success, ) = toAddr.call{
365             value: address(this).balance
366         } ("");
367         require(success);
368     }
369     
370 }