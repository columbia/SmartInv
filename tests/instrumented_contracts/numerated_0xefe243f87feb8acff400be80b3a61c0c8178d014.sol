1 // Twitter Tools [TTOOLS]
2 
3     /*  
4 
5     Official Telegram Chat: 
6         https://t.me/Twitter_Tools_ETH
7 
8     Twitter
9         https://twitter.com/TToolsAi
10 
11     Website 
12         https://www.twittertools.io
13 
14     Twitter Tools Assistant Bot
15         https://t.me/Twitter_TooIs_Bot
16 
17     Whitepaper
18         https://docs.twittertools.io/
19 
20     */
21 
22 // SPDX-License-Identifier: MIT
23 
24 
25 pragma solidity 0.8.20;
26 
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 }
32 
33 interface IERC20 {
34     function totalSupply() external view returns (uint256);
35     function balanceOf(address account) external view returns (uint256);
36     function transfer(address recipient, uint256 amount) external returns (bool);
37     function allowance(address owner, address spender) external view returns (uint256);
38     function approve(address spender, uint256 amount) external returns (bool);
39     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
40     event Transfer(address indexed from, address indexed to, uint256 value);
41     event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 library SafeMath {
45     function add(uint256 a, uint256 b) internal pure returns (uint256) {
46         uint256 c = a + b;
47         require(c >= a, "SafeMath: addition overflow");
48         return c;
49     }
50 
51     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
52         return sub(a, b, "SafeMath: subtraction overflow");
53     }
54 
55     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b <= a, errorMessage);
57         uint256 c = a - b;
58         return c;
59     }
60 
61     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
62         if (a == 0) {
63             return 0;
64         }
65         uint256 c = a * b;
66         require(c / a == b, "SafeMath: multiplication overflow");
67         return c;
68     }
69 
70     function div(uint256 a, uint256 b) internal pure returns (uint256) {
71         return div(a, b, "SafeMath: division by zero");
72     }
73 
74     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
75         require(b > 0, errorMessage);
76         uint256 c = a / b;
77         return c;
78     }
79 
80 }
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
132 contract TTOOLS is Context, IERC20, Ownable {
133     using SafeMath for uint256;
134     mapping (address => uint256) private _balances;
135     mapping (address => mapping (address => uint256)) private _allowances;
136     mapping (address => bool) private _isExcludedFromFee;
137     mapping (address => bool) private bots;
138     address payable private _taxWallet;
139     uint256 firstBlock;
140 
141     uint256 private _initialBuyTax=20;
142     uint256 private _initialSellTax=20;
143     uint256 private _finalBuyTax=3;
144     uint256 private _finalSellTax=3;
145     uint256 private _reduceBuyTaxAt=20;
146     uint256 private _reduceSellTaxAt=20;
147     uint256 private _preventSwapBefore=20;
148     uint256 private _buyCount=0;
149 
150     uint8 private constant _decimals = 9;
151     uint256 private constant _tTotal = 1000000 * 10**_decimals;
152     string private constant _name = unicode"Twitter Tools";
153     string private constant _symbol = unicode"TTOOLS";
154     uint256 public _maxTxAmount =   20000 * 10**_decimals;
155     uint256 public _maxWalletSize = 20000 * 10**_decimals;
156     uint256 public _taxSwapThreshold= 20000 * 10**_decimals;
157     uint256 public _maxTaxSwap= 10000 * 10**_decimals;
158 
159     IUniswapV2Router02 private uniswapV2Router;
160     address private uniswapV2Pair;
161     bool private tradingOpen;
162     bool private inSwap = false;
163     bool private swapEnabled = false;
164 
165     event MaxTxAmountUpdated(uint _maxTxAmount);
166     modifier lockTheSwap {
167         inSwap = true;
168         _;
169         inSwap = false;
170     }
171 
172     constructor () {
173 
174         _taxWallet = payable(_msgSender());
175         _balances[_msgSender()] = _tTotal;
176         _isExcludedFromFee[owner()] = true;
177         _isExcludedFromFee[address(this)] = true;
178         _isExcludedFromFee[_taxWallet] = true;
179 
180         emit Transfer(address(0), _msgSender(), _tTotal);
181     }
182 
183     function name() public pure returns (string memory) {
184         return _name;
185     }
186 
187     function symbol() public pure returns (string memory) {
188         return _symbol;
189     }
190 
191     function decimals() public pure returns (uint8) {
192         return _decimals;
193     }
194 
195     function totalSupply() public pure override returns (uint256) {
196         return _tTotal;
197     }
198 
199     function balanceOf(address account) public view override returns (uint256) {
200         return _balances[account];
201     }
202 
203     function transfer(address recipient, uint256 amount) public override returns (bool) {
204         _transfer(_msgSender(), recipient, amount);
205         return true;
206     }
207 
208     function allowance(address owner, address spender) public view override returns (uint256) {
209         return _allowances[owner][spender];
210     }
211 
212     function approve(address spender, uint256 amount) public override returns (bool) {
213         _approve(_msgSender(), spender, amount);
214         return true;
215     }
216 
217     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
218         _transfer(sender, recipient, amount);
219         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
220         return true;
221     }
222 
223     function _approve(address owner, address spender, uint256 amount) private {
224         require(owner != address(0), "ERC20: approve from the zero address");
225         require(spender != address(0), "ERC20: approve to the zero address");
226         _allowances[owner][spender] = amount;
227         emit Approval(owner, spender, amount);
228     }
229 
230     function _transfer(address from, address to, uint256 amount) private {
231         require(from != address(0), "ERC20: transfer from the zero address");
232         require(to != address(0), "ERC20: transfer to the zero address");
233         require(amount > 0, "Transfer amount must be greater than zero");
234         uint256 taxAmount=0;
235         if (from != owner() && to != owner()) {
236             require(!bots[from] && !bots[to]);
237             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
238 
239             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
240                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
241                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
242 
243                 if (firstBlock + 1  > block.number) {
244                     require(!isContract(to));
245                 }
246                 _buyCount++;
247             }
248 
249             if (to != uniswapV2Pair && ! _isExcludedFromFee[to]) {
250                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
251             }
252 
253             if(to == uniswapV2Pair && from!= address(this) ){
254                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
255             }
256 
257             uint256 contractTokenBalance = balanceOf(address(this));
258             if (!inSwap && to   == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
259                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
260                 uint256 contractETHBalance = address(this).balance;
261                 if(contractETHBalance > 0) {
262                     sendETHToFee(address(this).balance);
263                 }
264             }
265         }
266 
267         if(taxAmount>0){
268           _balances[address(this)]=_balances[address(this)].add(taxAmount);
269           emit Transfer(from, address(this),taxAmount);
270         }
271         _balances[from]=_balances[from].sub(amount);
272         _balances[to]=_balances[to].add(amount.sub(taxAmount));
273         emit Transfer(from, to, amount.sub(taxAmount));
274     }
275 
276 
277     function min(uint256 a, uint256 b) private pure returns (uint256){
278       return (a>b)?b:a;
279     }
280 
281     function isContract(address account) private view returns (bool) {
282         uint256 size;
283         assembly {
284             size := extcodesize(account)
285         }
286         return size > 0;
287     }
288 
289     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
290         address[] memory path = new address[](2);
291         path[0] = address(this);
292         path[1] = uniswapV2Router.WETH();
293         _approve(address(this), address(uniswapV2Router), tokenAmount);
294         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
295             tokenAmount,
296             0,
297             path,
298             address(this),
299             block.timestamp
300         );
301     }
302 
303     function removeLimits() external onlyOwner{
304         _maxTxAmount = _tTotal;
305         _maxWalletSize=_tTotal;
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
338         firstBlock = block.number;
339     }
340 
341     
342     function reduceFee(uint256 _newFee) external{
343       require(_msgSender()==_taxWallet);
344       require(_newFee<=_finalBuyTax && _newFee<=_finalSellTax);
345       _finalBuyTax=_newFee;
346       _finalSellTax=_newFee;
347     }
348 
349     receive() external payable {}
350 
351     function manualSwap() external {
352         require(_msgSender()==_taxWallet);
353         uint256 tokenBalance=balanceOf(address(this));
354         if(tokenBalance>0){
355           swapTokensForEth(tokenBalance);
356         }
357         uint256 ethBalance=address(this).balance;
358         if(ethBalance>0){
359           sendETHToFee(ethBalance);
360         }
361     }
362 }