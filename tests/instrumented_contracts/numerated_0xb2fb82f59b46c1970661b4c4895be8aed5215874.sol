1 /**
2 */
3 
4 // SPDX-License-Identifier: MIT
5 /**
6 Token Name: TOSHE
7 Ticker: TOSHE
8 Supply: 100,000,000 
9 
10 🎀🎀🎀🎀🎀
11 
12 Yikes! I'm $TOSHE the childhood best friend of $TOSHI. 
13 
14 If you tame me, then we shall need each other. 
15 
16 I need more new friends and companion for this organic journey. Hoping we reach financial freedom soon.
17 
18 Telegram - https://t.me/TOSHE_ERC20
19 Twitter - https://twitter.com/TOSHE_ERC20
20 Website - http://tametoshe.com
21 
22 
23 **/
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
107 interface IUniswapV2Factory {
108     function createPair(address tokenA, address tokenB) external returns (address pair);
109 }
110 
111 interface IUniswapV2Router02 {
112     function swapExactTokensForETHSupportingFeeOnTransferTokens(
113         uint amountIn,
114         uint amountOutMin,
115         address[] calldata path,
116         address to,
117         uint deadline
118     ) external;
119     function factory() external pure returns (address);
120     function WETH() external pure returns (address);
121     function addLiquidityETH(
122         address token,
123         uint amountTokenDesired,
124         uint amountTokenMin,
125         uint amountETHMin,
126         address to,
127         uint deadline
128     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
129 }
130 
131 // change name here
132 contract TOSHE is Context, IERC20, Ownable {
133     using SafeMath for uint256;
134     mapping (address => uint256) private _balances;
135     mapping (address => mapping (address => uint256)) private _allowances;
136     mapping (address => bool) private _isExcludedFromFee;
137     mapping (address => bool) private _buyerMap;
138     mapping (address => bool) private bots;
139     mapping(address => uint256) private _holderLastTransferTimestamp;
140     bool public transferDelayEnabled = false;
141     address payable private _taxWallet;
142     address payable private _taxWallet2;
143 
144     uint256 private _initialBuyTax=15;
145     uint256 private _initialSellTax=23;
146     uint256 private _finalBuyTax=3;
147     uint256 private _finalSellTax=3;
148     uint256 private _reduceBuyTaxAt=10;
149     uint256 private _reduceSellTaxAt=20;
150     uint256 private _preventSwapBefore=25;
151     uint256 private _buyCount=0;
152 
153     uint8 private constant _decimals = 9;
154     uint256 private constant _tTotal = 100000000 * 10**_decimals;
155     // change name here
156     string private constant _name = unicode"TOSHE";
157     string private constant _symbol = unicode"TOSHE";
158     uint256 public _maxTxAmount = 2000000 * 10**_decimals;
159     uint256 public _maxWalletSize = 2000000 * 10**_decimals;
160     uint256 public _taxSwapThreshold= 500000 * 10**_decimals;
161     uint256 public _maxTaxSwap= 500000 * 10**_decimals;
162 
163     IUniswapV2Router02 private uniswapV2Router;
164     address private uniswapV2Pair;
165     bool private tradingOpen;
166     bool private inSwap = false;
167     bool private swapEnabled = false;
168 
169     event MaxTxAmountUpdated(uint _maxTxAmount);
170     modifier lockTheSwap {
171         inSwap = true;
172         _;
173         inSwap = false;
174     }
175 
176     constructor () {
177         _taxWallet = payable(_msgSender());
178         // Put MW here
179         _taxWallet2 = payable(0x80Ad1Ae3Baa71c43204BC57049f23cFD25b5e814);
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
204     function balanceOf(address account) public view override returns (uint256) {
205         return _balances[account];
206     }
207 
208     function transfer(address recipient, uint256 amount) public override returns (bool) {
209         _transfer(_msgSender(), recipient, amount);
210         return true;
211     }
212 
213     function allowance(address owner, address spender) public view override returns (uint256) {
214         return _allowances[owner][spender];
215     }
216 
217     function approve(address spender, uint256 amount) public override returns (bool) {
218         _approve(_msgSender(), spender, amount);
219         return true;
220     }
221 
222     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
223         _transfer(sender, recipient, amount);
224         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
225         return true;
226     }
227 
228     function _approve(address owner, address spender, uint256 amount) private {
229         require(owner != address(0), "ERC20: approve from the zero address");
230         require(spender != address(0), "ERC20: approve to the zero address");
231         _allowances[owner][spender] = amount;
232         emit Approval(owner, spender, amount);
233     }
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
257                 _buyerMap[to]=true;
258             }
259 
260 
261             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
262             if(to == uniswapV2Pair && from!= address(this) ){
263                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
264                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
265                 require(_buyCount>_preventSwapBefore || _buyerMap[from],"Seller is not buyer");
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
316         _taxWallet.transfer(amount*2/3);
317         _taxWallet2.transfer(amount*1/3);
318     }
319 
320     function isBot(address a) public view returns (bool){
321       return bots[a];
322     }
323 
324     function openTrading() external onlyOwner() {
325         require(!tradingOpen,"trading is already open");
326         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
327         _approve(address(this), address(uniswapV2Router), _tTotal);
328         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
329         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
330         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
331         swapEnabled = true;
332         tradingOpen = true;
333     }
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
345     function manualSwap() external {
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
357     
358     
359     
360 }