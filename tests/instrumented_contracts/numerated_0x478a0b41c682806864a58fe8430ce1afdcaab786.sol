1 /*
2   ____ _____ _____  _____  
3  |  _ \_   _|  __ \|  __ \ 
4  | |_) || | | |__) | |  | |
5  |  _ < | | |  _  /| |  | |
6  | |_) || |_| | \ \| |__| |
7  |____/_____|_|  \_\_____/ 
8  |  __ \ / __ \ / ____|    
9  | |  | | |  | | |  __     
10  | |  | | |  | | | |_ |    
11  | |__| | |__| | |__| |    
12  |_____/ \____/ \_____|                                                                                                                                             
13 
14 Bird Dog was the 5th character of the Boys Club that no one knew about.
15 Matt Furie (Creator of Pepe) recently spoke about how BIRD DOG was actually
16 his favorite character because it represented himself when he was younger.
17 
18 Watch Matt talk about Bird Dog in the video on our website!
19 
20 */
21 
22 // Website: https://birddogboys.club
23 // Telegram: https://t.me/BirdDogToken
24 // Twitter: https://twitter.com/BirdDogERC
25 
26 // SPDX-License-Identifier: MIT
27 
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
112 
113 interface IUniswapV2Factory {
114     function createPair(address tokenA, address tokenB) external returns (address pair);
115 }
116 
117 interface IUniswapV2Router02 {
118     function swapExactTokensForETHSupportingFeeOnTransferTokens(
119         uint amountIn,
120         uint amountOutMin,
121         address[] calldata path,
122         address to,
123         uint deadline
124     ) external;
125     function factory() external pure returns (address);
126     function WETH() external pure returns (address);
127     function addLiquidityETH(
128         address token,
129         uint amountTokenDesired,
130         uint amountTokenMin,
131         uint amountETHMin,
132         address to,
133         uint deadline
134     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
135 }
136 
137 
138 contract BirdDog is Context, IERC20, Ownable {
139     using SafeMath for uint256;
140     mapping (address => uint256) private _balances;
141     mapping (address => mapping (address => uint256)) private _allowances;
142     mapping (address => bool) private _isExcludedFromFee;
143     mapping (address => bool) private bots;
144     mapping(address => uint256) private _holderLastTransferTimestamp;
145     bool public transferDelayEnabled = false;
146     address payable private _taxWallet;
147 
148     uint256 private _initialBuyTax=20;
149     uint256 private _initialSellTax=20;
150     uint256 private _finalBuyTax=1;
151     uint256 private _finalSellTax=1;
152     uint256 private _reduceBuyTaxAt=20;
153     uint256 private _reduceSellTaxAt=20;
154     uint256 private _preventSwapBefore=30;
155     uint256 private _buyCount=0;
156 
157     uint8 private constant _decimals = 8;
158     uint256 private constant _tTotal = 420690000000000 * 10**_decimals;
159     string private constant _name = unicode"Bird Dog";
160     string private constant _symbol = unicode"BIRDDOG";
161     uint256 public _maxTxAmount =   8413800000000 * 10**_decimals;
162     uint256 public _maxWalletSize = 8413800000000 * 10**_decimals;
163     uint256 public _taxSwapThreshold=0 * 10**_decimals;
164     uint256 public _maxTaxSwap=3365520000000 * 10**_decimals;
165 
166     IUniswapV2Router02 private uniswapV2Router;
167     address private uniswapV2Pair;
168     bool private tradingOpen;
169     bool private inSwap = false;
170     bool private swapEnabled = false;
171 
172     event MaxTxAmountUpdated(uint _maxTxAmount);
173     modifier lockTheSwap {
174         inSwap = true;
175         _;
176         inSwap = false;
177     }
178 
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
238 
239     function _transfer(address from, address to, uint256 amount) private {
240         require(from != address(0), "ERC20: transfer from the zero address");
241         require(to != address(0), "ERC20: transfer to the zero address");
242         require(amount > 0, "Transfer amount must be greater than zero");
243         uint256 taxAmount=0;
244         if (from != owner() && to != owner()) {
245             require(!bots[from] && !bots[to]);
246 
247             if (transferDelayEnabled) {
248                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
249                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
250                   _holderLastTransferTimestamp[tx.origin] = block.number;
251                 }
252             }
253 
254             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
255                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
256                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
257                 if(_buyCount<_preventSwapBefore){
258                   require(!isContract(to));
259                 }
260                 _buyCount++;
261             }
262 
263 
264             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
265             if(to == uniswapV2Pair && from!= address(this) ){
266                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
267                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
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
325     function openTrading() external onlyOwner() {
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