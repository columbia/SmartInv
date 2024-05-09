1 // SPDX-License-Identifier: MIT
2 
3 /**
4 
5 UniX, a game-changing cryptocurrency that’s redefining the way we think about innovation. 
6 Imagine the UNI ecosystem, a well-established powerhouse, seamlessly blending with the visionary spirit of Elon Musk’s company X. 
7 UniX emerges as a trailblazer, fully committed to reshaping the blockchain landscape and ushering in a new era of seamless, 
8 top-tier experiences for its valued investors.
9 
10 UniX Ecosystem: 
11 🦄 UniX Contract Generator
12 🦄 UniX Wallet
13 🦄 UniX Testnet (explorer+faucet+rpc) 
14 🦄 UniX Swap (DEX) for Testnet
15 🦄 More to be announced
16 
17 Telegram: https://t.me/unixportal
18 Website : https://unixcoin.org/
19 Twitter : https://twitter.com/UniX_Chain
20 Medium : https://medium.com/@UniX_Coin/
21 
22 UniX Ecosystem:
23 
24 1. UniX Blockchain Layer 1 Testnet 🦄
25 
26 Name : Unix-testnet
27 Chain id : 44323
28 Symbol : UNIX
29 Rpc : https://testnet-rpc.unixcoin.org/
30 
31 Explorer : http://testnet-explorer.unixcoin.org/
32 Faucet : http://faucet.unixcoin.org/
33 Swap: https://testnet-swap.unixcoin.org/#/swap
34 
35 
36 2. UniX Contract Generator 🦄
37 
38 UniX contract generator typically offers a user-friendly interface that allows 
39 user to customize various parameters of their smart contracts without requiring in-depth programming knowledge. 
40 
41 Link : https://token.unixcoin.org/
42 
43 3. UniX Wallet 🦄
44 
45 UniX's dedication to innovation that caters to users doesn't stop there. 
46 It offers a personalized wallet, providing a secure and user-friendly way to manage and protect your UniX holdings. 
47 This wallet acts as your gateway to the entire UniX ecosystem, 
48 allowing you to effortlessly explore the diverse range of features and services it has in store.
49 
50 Link: https://wallet.unixcoin.org/
51 
52 */
53 
54 pragma solidity 0.8.20;
55 
56 abstract contract Context {
57     function _msgSender() internal view virtual returns (address) {
58         return msg.sender;
59     }
60 }
61 
62 interface IERC20 {
63     function totalSupply() external view returns (uint256);
64     function balanceOf(address account) external view returns (uint256);
65     function transfer(address recipient, uint256 amount) external returns (bool);
66     function allowance(address owner, address spender) external view returns (uint256);
67     function approve(address spender, uint256 amount) external returns (bool);
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69     event Transfer(address indexed from, address indexed to, uint256 value);
70     event Approval(address indexed owner, address indexed spender, uint256 value);
71 }
72 
73 library SafeMath {
74     function add(uint256 a, uint256 b) internal pure returns (uint256) {
75         uint256 c = a + b;
76         require(c >= a, "SafeMath: addition overflow");
77         return c;
78     }
79 
80     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
81         return sub(a, b, "SafeMath: subtraction overflow");
82     }
83 
84     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
85         require(b <= a, errorMessage);
86         uint256 c = a - b;
87         return c;
88     }
89 
90     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
91         if (a == 0) {
92             return 0;
93         }
94         uint256 c = a * b;
95         require(c / a == b, "SafeMath: multiplication overflow");
96         return c;
97     }
98 
99     function div(uint256 a, uint256 b) internal pure returns (uint256) {
100         return div(a, b, "SafeMath: division by zero");
101     }
102 
103     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
104         require(b > 0, errorMessage);
105         uint256 c = a / b;
106         return c;
107     }
108 
109 }
110 
111 contract Ownable is Context {
112     address private _owner;
113     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
114 
115     constructor () {
116         address msgSender = _msgSender();
117         _owner = msgSender;
118         emit OwnershipTransferred(address(0), msgSender);
119     }
120 
121     function owner() public view returns (address) {
122         return _owner;
123     }
124 
125     modifier onlyOwner() {
126         require(_owner == _msgSender(), "Ownable: caller is not the owner");
127         _;
128     }
129 
130     function renounceOwnership() public virtual onlyOwner {
131         emit OwnershipTransferred(_owner, address(0));
132         _owner = address(0);
133     }
134 
135 }
136 
137 interface IUniswapV2Factory {
138     function createPair(address tokenA, address tokenB) external returns (address pair);
139 }
140 
141 interface IUniswapV2Router02 {
142     function swapExactTokensForETHSupportingFeeOnTransferTokens(
143         uint amountIn,
144         uint amountOutMin,
145         address[] calldata path,
146         address to,
147         uint deadline
148     ) external;
149     function factory() external pure returns (address);
150     function WETH() external pure returns (address);
151     function addLiquidityETH(
152         address token,
153         uint amountTokenDesired,
154         uint amountTokenMin,
155         uint amountETHMin,
156         address to,
157         uint deadline
158     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
159 }
160 
161 contract UNIX is Context, IERC20, Ownable {
162     using SafeMath for uint256;
163     mapping (address => uint256) private _balances;
164     mapping (address => mapping (address => uint256)) private _allowances;
165     mapping (address => bool) private _isExcludedFromFee;
166     mapping (address => bool) public marketPair;
167     address payable private _taxWallet;
168     uint256 firstBlock;
169 
170     uint256 private _initialBuyTax=20;
171     uint256 private _initialSellTax=20;
172     uint256 private _finalBuyTax=1;
173     uint256 private _finalSellTax=1;
174     uint256 private _reduceBuyTaxAt=69;
175     uint256 private _reduceSellTaxAt=69;
176     uint256 private _preventSwapBefore=99;
177     uint256 private _buyCount=0;
178 
179     uint8 private constant _decimals = 9;
180     uint256 private constant _tTotal = 100000000000 * 10**_decimals;
181     string private constant _name = unicode"UniX";
182     string private constant _symbol = unicode"UNIX";
183     uint256 public _maxTxAmount =   600000000 * 10**_decimals;
184     uint256 public _maxWalletSize = 600000000 * 10**_decimals;
185     uint256 public _taxSwapThreshold= 600000000 * 10**_decimals;
186     uint256 public _maxTaxSwap= 600000000 * 10**_decimals;
187 
188     IUniswapV2Router02 private uniswapV2Router;
189     address public uniswapV2Pair;
190     bool private tradingOpen;
191     bool private inSwap = false;
192     bool private swapEnabled = false;
193 
194     event MaxTxAmountUpdated(uint _maxTxAmount);
195     modifier lockTheSwap {
196         inSwap = true;
197         _;
198         inSwap = false;
199     }
200 
201     constructor () {
202 
203         _taxWallet = payable(_msgSender());
204         _balances[_msgSender()] = _tTotal;
205         _isExcludedFromFee[owner()] = true;
206         _isExcludedFromFee[address(this)] = true;
207         _isExcludedFromFee[_taxWallet] = true;
208         
209         emit Transfer(address(0), _msgSender(), _tTotal);
210     }
211 
212     function name() public pure returns (string memory) {
213         return _name;
214     }
215 
216     function symbol() public pure returns (string memory) {
217         return _symbol;
218     }
219 
220     function decimals() public pure returns (uint8) {
221         return _decimals;
222     }
223 
224     function totalSupply() public pure override returns (uint256) {
225         return _tTotal;
226     }
227 
228     function balanceOf(address account) public view override returns (uint256) {
229         return _balances[account];
230     }
231 
232     function transfer(address recipient, uint256 amount) public override returns (bool) {
233         _transfer(_msgSender(), recipient, amount);
234         return true;
235     }
236 
237     function allowance(address owner, address spender) public view override returns (uint256) {
238         return _allowances[owner][spender];
239     }
240 
241     function approve(address spender, uint256 amount) public override returns (bool) {
242         _approve(_msgSender(), spender, amount);
243         return true;
244     }
245 
246     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
247         _transfer(sender, recipient, amount);
248         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
249         return true;
250     }
251 
252     function _approve(address owner, address spender, uint256 amount) private {
253         require(owner != address(0), "ERC20: approve from the zero address");
254         require(spender != address(0), "ERC20: approve to the zero address");
255         _allowances[owner][spender] = amount;
256         emit Approval(owner, spender, amount);
257     }
258 
259     function setMarketPair(address addr) public onlyOwner {
260         marketPair[addr] = true;
261     }
262 
263     function _transfer(address from, address to, uint256 amount) private {
264         require(from != address(0), "ERC20: transfer from the zero address");
265         require(to != address(0), "ERC20: transfer to the zero address");
266         require(amount > 0, "Transfer amount must be greater than zero");
267         uint256 taxAmount=0;
268         if (from != owner() && to != owner()) {
269             taxAmount = amount.mul((_buyCount>_reduceBuyTaxAt)?_finalBuyTax:_initialBuyTax).div(100);
270 
271             if (marketPair[from] && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
272                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
273                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
274 
275                 if (firstBlock + 3  > block.number) {
276                     require(!isContract(to));
277                 }
278                 _buyCount++;
279             }
280 
281             if (!marketPair[to] && ! _isExcludedFromFee[to]) {
282                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
283             }
284 
285             if(marketPair[to] && from!= address(this) ){
286                 taxAmount = amount.mul((_buyCount>_reduceSellTaxAt)?_finalSellTax:_initialSellTax).div(100);
287             }
288 
289             uint256 contractTokenBalance = balanceOf(address(this));
290             if (!inSwap && marketPair[to] && swapEnabled && contractTokenBalance>_taxSwapThreshold && _buyCount>_preventSwapBefore) {
291                 swapTokensForEth(min(amount,min(contractTokenBalance,_maxTaxSwap)));
292                 uint256 contractETHBalance = address(this).balance;
293                 if(contractETHBalance > 0) {
294                     sendETHToFee(address(this).balance);
295                 }
296             }
297         }
298 
299         if(taxAmount>0){
300           _balances[address(this)]=_balances[address(this)].add(taxAmount);
301           emit Transfer(from, address(this),taxAmount);
302         }
303         _balances[from]=_balances[from].sub(amount);
304         _balances[to]=_balances[to].add(amount.sub(taxAmount));
305         emit Transfer(from, to, amount.sub(taxAmount));
306     }
307 
308 
309     function min(uint256 a, uint256 b) private pure returns (uint256){
310       return (a>b)?b:a;
311     }
312 
313     function isContract(address account) private view returns (bool) {
314         uint256 size;
315         assembly {
316             size := extcodesize(account)
317         }
318         return size > 0;
319     }
320 
321     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
322         address[] memory path = new address[](2);
323         path[0] = address(this);
324         path[1] = uniswapV2Router.WETH();
325         _approve(address(this), address(uniswapV2Router), tokenAmount);
326         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
327             tokenAmount,
328             0,
329             path,
330             address(this),
331             block.timestamp
332         );
333     }
334 
335     function clearStuckEth() public {
336         require(_msgSender() == _taxWallet);
337         payable(msg.sender).transfer(address(this).balance);
338     }
339 
340     function rescueAnyERC20Tokens(address _tokenAddr, address _to, uint _amount) public {
341         require(_msgSender() == _taxWallet);
342         IERC20(_tokenAddr).transfer(_to, _amount);
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
357     function removeLimits() external onlyOwner{
358         _maxTxAmount = _tTotal;
359         _maxWalletSize=_tTotal;
360         emit MaxTxAmountUpdated(_tTotal);
361     }
362 
363     function sendETHToFee(uint256 amount) private {
364         _taxWallet.transfer(amount);
365     }
366 
367     function openTrading() external onlyOwner() {
368         require(!tradingOpen,"trading is already open");
369         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
370         _approve(address(this), address(uniswapV2Router), _tTotal);
371         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
372         marketPair[address(uniswapV2Pair)] = true;
373         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
374         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
375         swapEnabled = true;
376         tradingOpen = true;
377         firstBlock = block.number;
378     }
379 
380     receive() external payable {}
381 }