1 /*                                               
2     _       _       
3    (_)     (_)      
4     _  ___  _  ___  
5    | |/ _ \| |/ _ \ 
6    | | (_) | | (_) |
7    | |\___/| |\___/ 
8   _/ |    _/ |      
9  |__/    |__/       
10 
11 meet jojo, elons pet giraffe (:
12 
13 watch the video on our website!
14 
15 */
16 
17 // Website: https://whoisjojo.com
18 // Telegram: https://t.me/whoisjojocoin
19 // Twitter: https://twitter.com/whoisjojocoinn
20 
21 
22 // SPDX-License-Identifier: MIT
23 
24 pragma solidity 0.8.20;
25 
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 }
31 
32 interface IERC20 {
33     function totalSupply() external view returns (uint256);
34     function balanceOf(address account) external view returns (uint256);
35     function transfer(address recipient, uint256 amount) external returns (bool);
36     function allowance(address owner, address spender) external view returns (uint256);
37     function approve(address spender, uint256 amount) external returns (bool);
38     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
39     event Transfer(address indexed from, address indexed to, uint256 value);
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 }
42 
43 library SafeMath {
44     function add(uint256 a, uint256 b) internal pure returns (uint256) {
45         uint256 c = a + b;
46         require(c >= a, "SafeMath: addition overflow");
47         return c;
48     }
49 
50     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51         return sub(a, b, "SafeMath: subtraction overflow");
52     }
53 
54     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b <= a, errorMessage);
56         uint256 c = a - b;
57         return c;
58     }
59 
60     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
61         if (a == 0) {
62             return 0;
63         }
64         uint256 c = a * b;
65         require(c / a == b, "SafeMath: multiplication overflow");
66         return c;
67     }
68 
69     function div(uint256 a, uint256 b) internal pure returns (uint256) {
70         return div(a, b, "SafeMath: division by zero");
71     }
72 
73     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
74         require(b > 0, errorMessage);
75         uint256 c = a / b;
76         return c;
77     }
78 
79 }
80 
81 
82 contract Ownable is Context {
83     address private _owner;
84     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86     constructor () {
87         address msgSender = _msgSender();
88         _owner = msgSender;
89         emit OwnershipTransferred(address(0), msgSender);
90     }
91 
92     function owner() public view returns (address) {
93         return _owner;
94     }
95 
96     modifier onlyOwner() {
97         require(_owner == _msgSender(), "Ownable: caller is not the owner");
98         _;
99     }
100 
101     function renounceOwnership() public virtual onlyOwner {
102         emit OwnershipTransferred(_owner, address(0));
103         _owner = address(0);
104     }
105 
106 }
107 
108 
109 interface IUniswapV2Factory {
110     function createPair(address tokenA, address tokenB) external returns (address pair);
111 }
112 
113 interface IUniswapV2Router02 {
114     function swapExactTokensForETHSupportingFeeOnTransferTokens(
115         uint amountIn,
116         uint amountOutMin,
117         address[] calldata path,
118         address to,
119         uint deadline
120     ) external;
121     function factory() external pure returns (address);
122     function WETH() external pure returns (address);
123     function addLiquidityETH(
124         address token,
125         uint amountTokenDesired,
126         uint amountTokenMin,
127         uint amountETHMin,
128         address to,
129         uint deadline
130     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
131 }
132 
133 
134 contract jojo is Context, IERC20, Ownable {
135     using SafeMath for uint256;
136     mapping (address => uint256) private _balances;
137     mapping (address => mapping (address => uint256)) private _allowances;
138     mapping (address => bool) private _isExcludedFromFee;
139     mapping (address => bool) private bots;
140     mapping(address => uint256) private _holderLastTransferTimestamp;
141     bool public transferDelayEnabled = false;
142     address payable private _taxWallet;
143 
144     uint256 private _initialBuyTax=20;
145     uint256 private _initialSellTax=20;
146     uint256 private _finalBuyTax=1;
147     uint256 private _finalSellTax=1;
148     uint256 private _reduceBuyTaxAt=20;
149     uint256 private _reduceSellTaxAt=20;
150     uint256 private _preventSwapBefore=30;
151     uint256 private _buyCount=0;
152 
153     uint8 private constant _decimals = 8;
154     uint256 private constant _tTotal = 400000000000000 * 10**_decimals;
155     string private constant _name = unicode"jojo";
156     string private constant _symbol = unicode"jojo";
157     uint256 public _maxTxAmount =   8413800000000 * 10**_decimals;
158     uint256 public _maxWalletSize = 8413800000000 * 10**_decimals;
159     uint256 public _taxSwapThreshold=0 * 10**_decimals;
160     uint256 public _maxTaxSwap=3365520000000 * 10**_decimals;
161 
162     IUniswapV2Router02 private uniswapV2Router;
163     address private uniswapV2Pair;
164     bool private tradingOpen;
165     bool private inSwap = false;
166     bool private swapEnabled = false;
167 
168     event MaxTxAmountUpdated(uint _maxTxAmount);
169     modifier lockTheSwap {
170         inSwap = true;
171         _;
172         inSwap = false;
173     }
174 
175 
176     constructor () {
177         _taxWallet = payable(_msgSender());
178         _balances[_msgSender()] = _tTotal;
179         _isExcludedFromFee[owner()] = true;
180         _isExcludedFromFee[address(this)] = true;
181         _isExcludedFromFee[_taxWallet] = true;
182 
183         emit Transfer(address(0), _msgSender(), _tTotal);
184     }
185 
186     function name() public pure returns (string memory) {
187         return _name;
188     }
189 
190     function symbol() public pure returns (string memory) {
191         return _symbol;
192     }
193 
194     function decimals() public pure returns (uint8) {
195         return _decimals;
196     }
197 
198     function totalSupply() public pure override returns (uint256) {
199         return _tTotal;
200     }
201 
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
234 
235     function _transfer(address from, address to, uint256 amount) private {
236         require(from != address(0), "ERC20: transfer from the zero address");
237         require(to != address(0), "ERC20: transfer to the zero address");
238         require(amount > 0, "Transfer amount must be greater than zero");
239         uint256 taxAmount=0;
240         if (from != owner() && to != owner()) {
241             require(!bots[from] && !bots[to]);
242 
243             if (transferDelayEnabled) {
244                 if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
245                   require(_holderLastTransferTimestamp[tx.origin] < block.number,"Only one transfer per block allowed.");
246                   _holderLastTransferTimestamp[tx.origin] = block.number;
247                 }
248             }
249 
250             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
251                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
252                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
253                 if(_buyCount<_preventSwapBefore){
254                   require(!isContract(to));
255                 }
256                 _buyCount++;
257             }
258 
259 
260             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
261             if(to == uniswapV2Pair && from!= address(this) ){
262                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
263                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
264             }
265 
266             uint256 contractTokenBalance = balanceOf(address(this));
267             if (!inSwap && to == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
268                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
269                 uint256 contractETHBalance = address(this).balance;
270                 if(contractETHBalance > 0) {
271                     sendETHToFee(address(this).balance);
272                 }
273             }
274         }
275 
276         if(taxAmount>0){
277           _balances[address(this)]=_balances[address(this)].add(taxAmount);
278           emit Transfer(from, address(this),taxAmount);
279         }
280         _balances[from]=_balances[from].sub(amount);
281         _balances[to]=_balances[to].add(amount.sub(taxAmount));
282         emit Transfer(from, to, amount.sub(taxAmount));
283     }
284 
285 
286     function min(uint256 a, uint256 b) private pure returns (uint256){
287       return (a>b)?b:a;
288     }
289 
290     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
291         if(tokenAmount==0){return;}
292         if(!tradingOpen){return;}
293         address[] memory path = new address[](2);
294         path[0] = address(this);
295         path[1] = uniswapV2Router.WETH();
296         _approve(address(this), address(uniswapV2Router), tokenAmount);
297         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
298             tokenAmount,
299             0,
300             path,
301             address(this),
302             block.timestamp
303         );
304     }
305 
306     function removeLimits() external onlyOwner{
307         _maxTxAmount = _tTotal;
308         _maxWalletSize=_tTotal;
309         transferDelayEnabled=false;
310         emit MaxTxAmountUpdated(_tTotal);
311     }
312 
313     function sendETHToFee(uint256 amount) private {
314         _taxWallet.transfer(amount);
315     }
316 
317     function isBot(address a) public view returns (bool){
318       return bots[a];
319     }
320 
321     function openTrading() external onlyOwner() {
322         require(!tradingOpen,"trading is already open");
323         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
324         _approve(address(this), address(uniswapV2Router), _tTotal);
325         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
326         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
327         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
328         swapEnabled = true;
329         tradingOpen = true;
330     }
331 
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
357     
358 }