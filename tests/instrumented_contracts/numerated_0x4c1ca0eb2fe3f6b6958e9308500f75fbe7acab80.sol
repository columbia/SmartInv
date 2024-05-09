1 /**
2 */
3 
4 // SPDX-License-Identifier: MIT
5 
6 /**
7 
8 XIAO BAO GOU - XIAO
9 
10 China’s secret 1960s mission!
11 
12 It’s 1966 and at a secret military base in southeast China, a small dog called Little Leopard is about to be sent into space.
13 
14 Xiao Bao "Little Leopard" who defied the odds and triumphantly returned to Earth, embodying the spirit of resilience and triumph.
15 
16 
17 https://t.me/XIAO_ERC20
18 https://twitter.com/XIAOBAOERC20
19 https://xiaobaogoucoin.com/
20 
21 **/
22 
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
131 contract XIAO is Context, IERC20, Ownable {
132     using SafeMath for uint256;
133     mapping (address => uint256) private _balances;
134     mapping (address => mapping (address => uint256)) private _allowances;
135     mapping (address => bool) private _isExcludedFromFee;
136     mapping (address => bool) private bots;
137     address payable private _taxWallet;
138     uint256 firstBlock;
139 
140     uint256 private _initialBuyTax=24;
141     uint256 private _initialSellTax=28;
142     uint256 private _finalBuyTax=0;
143     uint256 private _finalSellTax=0;
144     uint256 private _reduceBuyTaxAt=17;
145     uint256 private _reduceSellTaxAt=28;
146     uint256 private _preventSwapBefore=30;
147     uint256 private _buyCount=0;
148 
149     uint8 private constant _decimals = 9;
150     uint256 private constant _tTotal = 19660000 * 10**_decimals;
151     string private constant _name = unicode"XIAO BAO GOU";
152     string private constant _symbol = unicode"XIAO";
153     uint256 public _maxTxAmount = 393200 * 10**_decimals;
154     uint256 public _maxWalletSize = 393200 * 10**_decimals;
155     uint256 public _taxSwapThreshold= 196600 * 10**_decimals;
156     uint256 public _maxTaxSwap= 196600 * 10**_decimals;
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
172         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
173         _approve(address(this), address(uniswapV2Router), _tTotal);
174         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
175 
176         _taxWallet = payable(_msgSender());
177         _balances[_msgSender()] = _tTotal;
178         _isExcludedFromFee[owner()] = true;
179         _isExcludedFromFee[address(this)] = true;
180         _isExcludedFromFee[_taxWallet] = true;
181 
182         emit Transfer(address(0), _msgSender(), _tTotal);
183     }
184 
185     function name() public pure returns (string memory) {
186         return _name;
187     }
188 
189     function symbol() public pure returns (string memory) {
190         return _symbol;
191     }
192 
193     function decimals() public pure returns (uint8) {
194         return _decimals;
195     }
196 
197     function totalSupply() public pure override returns (uint256) {
198         return _tTotal;
199     }
200 
201     function balanceOf(address account) public view override returns (uint256) {
202         return _balances[account];
203     }
204 
205     function transfer(address recipient, uint256 amount) public override returns (bool) {
206         _transfer(_msgSender(), recipient, amount);
207         return true;
208     }
209 
210     function allowance(address owner, address spender) public view override returns (uint256) {
211         return _allowances[owner][spender];
212     }
213 
214     function approve(address spender, uint256 amount) public override returns (bool) {
215         _approve(_msgSender(), spender, amount);
216         return true;
217     }
218 
219     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
220         _transfer(sender, recipient, amount);
221         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
222         return true;
223     }
224 
225     function _approve(address owner, address spender, uint256 amount) private {
226         require(owner != address(0), "ERC20: approve from the zero address");
227         require(spender != address(0), "ERC20: approve to the zero address");
228         _allowances[owner][spender] = amount;
229         emit Approval(owner, spender, amount);
230     }
231 
232     function _transfer(address from, address to, uint256 amount) private {
233         require(from != address(0), "ERC20: transfer from the zero address");
234         require(to != address(0), "ERC20: transfer to the zero address");
235         require(amount > 0, "Transfer amount must be greater than zero");
236         uint256 taxAmount=0;
237         if (from != owner() && to != owner()) {
238             require(!bots[from] && !bots[to]);
239             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
240 
241             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
242                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
243                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
244 
245                 if (firstBlock + 1  > block.number) {
246                     require(!isContract(to));
247                 }
248                 _buyCount++;
249             }
250 
251             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
252                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
253             }
254 
255             if(to == uniswapV2Pair && from!= address(this) ){
256                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
257             }
258 
259             uint256 contractTokenBalance = balanceOf(address(this));
260             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
261                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
262                 uint256 contractETHBalance = address(this).balance;
263                 if(contractETHBalance > 0) {
264                     sendETHToFee(address(this).balance);
265                 }
266             }
267         }
268 
269         if(taxAmount>0){
270           _balances[address(this)]=_balances[address(this)].add(taxAmount);
271           emit Transfer(from, address(this),taxAmount);
272         }
273         _balances[from]=_balances[from].sub(amount);
274         _balances[to]=_balances[to].add(amount.sub(taxAmount));
275         emit Transfer(from, to, amount.sub(taxAmount));
276     }
277 
278 
279     function min(uint256 a, uint256 b) private pure returns (uint256){
280       return (a>b)?b:a;
281     }
282 
283     function isContract(address account) private view returns (bool) {
284         uint256 size;
285         assembly {
286             size := extcodesize(account)
287         }
288         return size > 0;
289     }
290 
291     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
292         address[] memory path = new address[](2);
293         path[0] = address(this);
294         path[1] = uniswapV2Router.WETH();
295         _approve(address(this), address(uniswapV2Router), tokenAmount);
296         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
297             tokenAmount,
298             0,
299             path,
300             address(this),
301             block.timestamp
302         );
303     }
304 
305     function removeLimits() external onlyOwner{
306         _maxTxAmount = _tTotal;
307         _maxWalletSize=_tTotal;
308         emit MaxTxAmountUpdated(_tTotal);
309     }
310 
311     function sendETHToFee(uint256 amount) private {
312         _taxWallet.transfer(amount);
313     }
314 
315     function addBots(address[] memory bots_) public onlyOwner {
316         for (uint i = 0; i < bots_.length; i++) {
317             bots[bots_[i]] = true;
318         }
319     }
320 
321     function delBots(address[] memory notbot) public onlyOwner {
322       for (uint i = 0; i < notbot.length; i++) {
323           bots[notbot[i]] = false;
324       }
325     }
326 
327     function isBot(address a) public view returns (bool){
328       return bots[a];
329     }
330 
331     function openTrading() external onlyOwner() {
332         require(!tradingOpen,"trading is already open");
333         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
334         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
335         swapEnabled = true;
336         tradingOpen = true;
337         firstBlock = block.number;
338     }
339 
340     
341     function reduceFee(uint256 _newFee) external{
342       require(_msgSender()==_taxWallet);
343       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
344       _finalBuyTax=_newFee;
345       _finalSellTax=_newFee;
346     }
347 
348     receive() external payable {}
349 
350     function manualSwap() external {
351         require(_msgSender()==_taxWallet);
352         uint256 tokenBalance=balanceOf(address(this));
353         if(tokenBalance>0){
354           swapTokensForEth(tokenBalance);
355         }
356         uint256 ethBalance=address(this).balance;
357         if(ethBalance>0){
358           sendETHToFee(ethBalance);
359         }
360     }
361 }