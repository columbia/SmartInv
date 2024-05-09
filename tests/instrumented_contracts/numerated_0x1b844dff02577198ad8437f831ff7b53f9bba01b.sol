1 // SPDX-License-Identifier: MIT
2 /**
3 MISSOR
4 
5 "I watched as the price of Bitcoin soared. I could have bought in at $100, but I didn't. I thought it was too risky.
6 
7 I watched as Ethereum's price skyrocketed. I could have bought in at $10, but I didn't. I thought it was too late.
8 
9 I watched as Dogecoin's price went to the moon. I could have bought in at $0.001, but I didn't. I thought it was a joke.
10 
11 Now, I'm sitting here, watching everyone else get rich. I'm the one who missed out. I'm the one who's left behind.
12 
13 I'm not sure what to do. I'm not sure if I should buy in now, or if it's too late. I'm not sure if I should even try.
14 
15 But I know one thing. I don't want to miss out on the next big thing.
16 
17 I want to be a part of the future. I want to be a part of the revolution.
18 
19 I want to be a part of cryptocurrency.
20 
21 So I'm buying in. I'm buying in now. I'm buying in with everything I've got.
22 
23 I'm not going to miss out on this opportunity again.
24 
25 IM NOT GOING TO BE A MISSOR..."
26 
27 Socials:
28 Telegram: https://t.me/MissorETHOfficial
29 Website: https://missorerc.com/
30 Twitter: https://twitter.com/Missor_ETH
31 
32 **/
33 
34 
35 pragma solidity 0.8.20;
36 
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address) {
39         return msg.sender;
40     }
41 }
42 
43 interface IERC20 {
44     function totalSupply() external view returns (uint256);
45     function balanceOf(address account) external view returns (uint256);
46     function transfer(address recipient, uint256 amount) external returns (bool);
47     function allowance(address owner, address spender) external view returns (uint256);
48     function approve(address spender, uint256 amount) external returns (bool);
49     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
50     event Transfer(address indexed from, address indexed to, uint256 value);
51     event Approval(address indexed owner, address indexed spender, uint256 value);
52 }
53 
54 library SafeMath {
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a, "SafeMath: addition overflow");
58         return c;
59     }
60 
61     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
62         return sub(a, b, "SafeMath: subtraction overflow");
63     }
64 
65     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
66         require(b <= a, errorMessage);
67         uint256 c = a - b;
68         return c;
69     }
70 
71     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
72         if (a == 0) {
73             return 0;
74         }
75         uint256 c = a * b;
76         require(c / a == b, "SafeMath: multiplication overflow");
77         return c;
78     }
79 
80     function div(uint256 a, uint256 b) internal pure returns (uint256) {
81         return div(a, b, "SafeMath: division by zero");
82     }
83 
84     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         require(b > 0, errorMessage);
86         uint256 c = a / b;
87         return c;
88     }
89 
90 }
91 
92 contract Ownable is Context {
93     address private _owner;
94     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
95 
96     constructor () {
97         address msgSender = _msgSender();
98         _owner = msgSender;
99         emit OwnershipTransferred(address(0), msgSender);
100     }
101 
102     function owner() public view returns (address) {
103         return _owner;
104     }
105 
106     modifier onlyOwner() {
107         require(_owner == _msgSender(), "Ownable: caller is not the owner");
108         _;
109     }
110 
111     function renounceOwnership() public virtual onlyOwner {
112         emit OwnershipTransferred(_owner, address(0));
113         _owner = address(0);
114     }
115 
116 }
117 
118 interface IUniswapV2Factory {
119     function createPair(address tokenA, address tokenB) external returns (address pair);
120 }
121 
122 interface IUniswapV2Router02 {
123     function swapExactTokensForETHSupportingFeeOnTransferTokens(
124         uint amountIn,
125         uint amountOutMin,
126         address[] calldata path,
127         address to,
128         uint deadline
129     ) external;
130     function factory() external pure returns (address);
131     function WETH() external pure returns (address);
132     function addLiquidityETH(
133         address token,
134         uint amountTokenDesired,
135         uint amountTokenMin,
136         uint amountETHMin,
137         address to,
138         uint deadline
139     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
140 }
141 
142 contract MISSOR is Context, IERC20, Ownable {
143     using SafeMath for uint256;
144     mapping (address => uint256) private _balances;
145     mapping (address => mapping (address => uint256)) private _allowances;
146     mapping (address => bool) private _isExcludedFromFee;
147     mapping (address => bool) private bots;
148     mapping(address => uint256) private _holderLastTransferTimestamp;
149     bool public transferDelayEnabled = true;
150     address payable private _taxWallet;
151 
152     uint256 private _initialBuyTax=25;
153     uint256 private _initialSellTax=30;
154     uint256 private _finalBuyTax=0;
155     uint256 private _finalSellTax=0;
156     uint256 private _reduceBuyTaxAt=20;
157     uint256 private _reduceSellTaxAt=30;
158     uint256 private _preventSwapBefore=25;
159     uint256 private _buyCount=0;
160 
161     uint8 private constant _decimals = 9;
162     uint256 private constant _tTotal = 1000000000 * 10**_decimals;
163     string private constant _name = unicode"MISSOR";
164     string private constant _symbol = unicode"MISSOR";
165     uint256 public _maxTxAmount = 20000000 * 10**_decimals;
166     uint256 public _maxWalletSize = 20000000 * 10**_decimals;
167     uint256 public _taxSwapThreshold= 14000001 * 10**_decimals;
168     uint256 public _maxTaxSwap= 14000000 * 10**_decimals;
169 
170     IUniswapV2Router02 private uniswapV2Router;
171     address private uniswapV2Pair;
172     bool private tradingOpen;
173     bool private inSwap = false;
174     bool private swapEnabled = false;
175 
176     event MaxTxAmountUpdated(uint _maxTxAmount);
177     modifier lockTheSwap {
178         inSwap = true;
179         _;
180         inSwap = false;
181     }
182 
183     constructor () {
184         _taxWallet = payable(_msgSender());
185         _balances[_msgSender()] = _tTotal;
186         _isExcludedFromFee[owner()] = true;
187         _isExcludedFromFee[address(this)] = true;
188         _isExcludedFromFee[_taxWallet] = true;
189 
190         emit Transfer(address(0), _msgSender(), _tTotal);
191     }
192 
193     function name() public pure returns (string memory) {
194         return _name;
195     }
196 
197     function symbol() public pure returns (string memory) {
198         return _symbol;
199     }
200 
201     function decimals() public pure returns (uint8) {
202         return _decimals;
203     }
204 
205     function totalSupply() public pure override returns (uint256) {
206         return _tTotal;
207     }
208 
209     function balanceOf(address account) public view override returns (uint256) {
210         return _balances[account];
211     }
212 
213     function transfer(address recipient, uint256 amount) public override returns (bool) {
214         _transfer(_msgSender(), recipient, amount);
215         return true;
216     }
217 
218     function allowance(address owner, address spender) public view override returns (uint256) {
219         return _allowances[owner][spender];
220     }
221 
222     function approve(address spender, uint256 amount) public override returns (bool) {
223         _approve(_msgSender(), spender, amount);
224         return true;
225     }
226 
227     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
228         _transfer(sender, recipient, amount);
229         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
230         return true;
231     }
232 
233     function _approve(address owner, address spender, uint256 amount) private {
234         require(owner != address(0), "ERC20: approve from the zero address");
235         require(spender != address(0), "ERC20: approve to the zero address");
236         _allowances[owner][spender] = amount;
237         emit Approval(owner, spender, amount);
238     }
239 
240     function _transfer(address from, address to, uint256 amount) private {
241         require(from != address(0), "ERC20: transfer from the zero address");
242         require(to != address(0), "ERC20: transfer to the zero address");
243         require(amount > 0, "Transfer amount must be greater than zero");
244         uint256 taxAmount=0;
245         if (from != owner() && to != owner()) {
246             require(!bots[from] && !bots[to]);
247             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
248 
249             if (transferDelayEnabled) {
250                   if (to != address(uniswapV2Router) && to != address(uniswapV2Pair)) {
251                       require(
252                           _holderLastTransferTimestamp[tx.origin] <
253                               block.number,
254                           "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
255                       );
256                       _holderLastTransferTimestamp[tx.origin] = block.number;
257                   }
258               }
259 
260             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
261                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
262                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
263                 _buyCount++;
264             }
265 
266             if(to == uniswapV2Pair && from!= address(this) ){
267                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
268             }
269 
270             uint256 contractTokenBalance = balanceOf(address(this));
271             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
272                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
273                 uint256 contractETHBalance = address(this).balance;
274                 if(contractETHBalance > 50000000000000000) {
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
319     function addBots(address[] memory bots_) public onlyOwner {
320         for (uint i = 0; i < bots_.length; i++) {
321             bots[bots_[i]] = true;
322         }
323     }
324 
325     function delBots(address[] memory notbot) public onlyOwner {
326       for (uint i = 0; i < notbot.length; i++) {
327           bots[notbot[i]] = false;
328       }
329     }
330 
331     function isBot(address a) public view returns (bool){
332       return bots[a];
333     }
334 
335     function openTrading() external onlyOwner() {
336         require(!tradingOpen,"trading is already open");
337         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
338         _approve(address(this), address(uniswapV2Router), _tTotal);
339         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
340         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
341         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
342         swapEnabled = true;
343         tradingOpen = true;
344     }
345 
346     
347     function reduceFee(uint256 _newFee) external{
348       require(_msgSender()==_taxWallet);
349       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
350       _finalBuyTax=_newFee;
351       _finalSellTax=_newFee;
352     }
353 
354     receive() external payable {}
355 
356     function manualSwap() external {
357         require(_msgSender()==_taxWallet);
358         uint256 tokenBalance=balanceOf(address(this));
359         if(tokenBalance>0){
360           swapTokensForEth(tokenBalance);
361         }
362         uint256 ethBalance=address(this).balance;
363         if(ethBalance>0){
364           sendETHToFee(ethBalance);
365         }
366     }
367 }