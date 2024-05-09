1 /**
2  *Submitted for verification at Etherscan.io on 2022-07-27
3 */
4 
5 // SPDX-License-Identifier: NOLICENSE
6 
7 /**
8 
9 WELCOME TO DUSTSWAP
10 
11 DO YOU HAVE A WALLET FULL OF DUST OR PUMP N DUMP COINS THAT WOULD'NT BE 
12 PROFITABLE TO TRADE OVER THE GAS FEES?
13 
14 DUSTSWAP PLANS TO SOLVE THIS PROBLEM WITH DUST SWAP.
15 
16 SEND YOUR NON PROFITABLE TOKEN THROUGH THE DAPP (SENDING IS WAAAAAY CHEAPER THAN SWAPPING)
17 AND LET US SELL WHEN WE HAVE GATHERED ENOUGH TOKENS TO MAKE A PROFITABLE SWAP
18 
19 NOT ALL TOKENS SENT WILL BE ABLE TO SELL FOR PROFIT
20 THE MORE YOU SEND, THE HIGHER YOUR TIER, THE HIGHER YOUR REWARDS
21 
22 TG HTTPS://T.ME/DUSTSWAP
23 
24 
25 */
26 pragma solidity ^0.8.4;
27 
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30     function balanceOf(address account) external view returns (uint256);
31     function transfer(address recipient, uint256 amount) external returns (bool);
32     function allowance(address owner, address spender) external view returns (uint256);
33     function approve(address spender, uint256 amount) external returns (bool);
34     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 }
38 
39 library SafeMath {
40     function add(uint256 a, uint256 b) internal pure returns (uint256) {
41         uint256 c = a + b;
42         require(c >= a, "SafeMath: addition overflow");
43         return c;
44     }
45 
46     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
47         return sub(a, b, "SafeMath: subtraction overflow");
48     }
49 
50     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
51         require(b <= a, errorMessage);
52         uint256 c = a - b;
53         return c;
54     }
55 
56     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
57         if (a == 0) {
58             return 0;
59         }
60         uint256 c = a * b;
61         require(c / a == b, "SafeMath: multiplication overflow");
62         return c;
63     }
64 
65     function div(uint256 a, uint256 b) internal pure returns (uint256) {
66         return div(a, b, "SafeMath: division by zero");
67     }
68 
69     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
70         require(b > 0, errorMessage);
71         uint256 c = a / b;
72         return c;
73     }
74 
75 }
76 
77 abstract contract Context {
78     function _msgSender() internal view virtual returns (address) {
79         return msg.sender;
80     }
81 
82     function _msgData() internal view virtual returns (bytes calldata) {
83         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
84         return msg.data;
85     }
86 }
87 
88 abstract contract Ownable is Context {
89     address private _owner;
90 
91     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
92 
93     constructor() {
94         _setOwner(_msgSender());
95     }
96 
97     function owner() public view virtual returns (address) {
98         return _owner;
99     }
100 
101     modifier onlyOwner() {
102         require(owner() == _msgSender(), "Ownable: caller is not the owner");
103         _;
104     }
105 
106     function renounceOwnership() public virtual onlyOwner {
107         _setOwner(address(0));
108     }
109 
110     function transferOwnership(address newOwner) public virtual onlyOwner {
111         require(newOwner != address(0), "Ownable: new owner is the zero address");
112         _setOwner(newOwner);
113     }
114 
115     function _setOwner(address newOwner) private {
116         address oldOwner = _owner;
117         _owner = newOwner;
118         emit OwnershipTransferred(oldOwner, newOwner);
119     }
120 }
121 
122 interface IUniswapV2Factory {
123     function createPair(address tokenA, address tokenB) external returns (address pair);
124 }
125 
126 interface IUniswapV2Router02 {
127     function swapExactTokensForETHSupportingFeeOnTransferTokens(
128         uint amountIn,
129         uint amountOutMin,
130         address[] calldata path,
131         address to,
132         uint deadline
133     ) external;
134     function factory() external pure returns (address);
135     function WETH() external pure returns (address);
136     function addLiquidityETH(
137         address token,
138         uint amountTokenDesired,
139         uint amountTokenMin,
140         uint amountETHMin,
141         address to,
142         uint deadline
143     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
144 }
145 
146 contract DUST is Context, IERC20, Ownable {
147 
148     using SafeMath for uint256;
149     mapping (address => uint256) private _tOwned;
150     mapping (address => mapping (address => uint256)) private _allowances;
151     mapping (address => bool) private _isExcludedFromFee;
152 
153     string private constant _name = "DUST";
154     string private constant _symbol = "DustSwap";
155     uint8 private constant _decimals = 9;
156 
157     uint256 public buyAutoBurnFee = 100;
158     uint256 public buyMarketingFee = 400;
159     uint256 public totalBuyFees = buyMarketingFee + buyMarketingFee;
160 
161     uint256 public sellAutoBurnFee = 100;
162     uint256 public sellMarketingFee = 400;
163     uint256 public totalsellFees = sellMarketingFee + sellMarketingFee;
164 
165     uint256 public tokensForAutoBurn;
166     uint256 public tokensForMarketing;
167     uint16 public masterTaxDivisor = 10000;
168 
169     address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
170     
171     IUniswapV2Router02 private uniswapV2Router;
172     address private uniswapV2Pair;
173     bool private tradingOpen;
174     bool private inSwap = false;
175     bool private swapEnabled = false;
176     uint256 private constant _tTotal = 1000000 * 10**9;
177     uint256 private maxWalletAmount = 1098 * 10**9;
178     uint256 private maxTxAmount = 1098 * 10**9;
179     address payable private feeAddrWallet;
180 
181     event MaxWalletAmountUpdated(uint maxWalletAmount);
182 
183     modifier lockTheSwap {
184         inSwap = true;
185         _;
186         inSwap = false;
187     }
188   
189     constructor () {
190         require(!tradingOpen,"trading is already open");
191         
192         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
193         uniswapV2Router = _uniswapV2Router;
194         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
195         feeAddrWallet = payable(0x4dbFD7AEe8d308eC1d08E3CcDB38B05CD450196A); 
196         _tOwned[owner()] = _tTotal;
197         _isExcludedFromFee[owner()] = true;
198         _isExcludedFromFee[address(this)] = true;
199         _isExcludedFromFee[feeAddrWallet] = true;
200         uint256 _buyAutoBurnFee = 100;
201         uint256 _buyMarketingFee = 400;
202         uint256 _sellAutoBurnFee = 100;
203         uint256 _sellMarketingFee = 400;
204         buyAutoBurnFee = _buyAutoBurnFee;
205         buyMarketingFee = _buyMarketingFee;
206         totalBuyFees = buyMarketingFee + buyMarketingFee;
207         sellAutoBurnFee = _sellAutoBurnFee;
208         sellMarketingFee = _sellMarketingFee;
209         totalsellFees = sellMarketingFee + sellMarketingFee;
210         swapEnabled = true;
211         maxTxAmount = 5001 * 10**9;
212         maxWalletAmount = 5001 * 10**9;
213         tradingOpen = true;
214         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
215         emit Transfer(address(0), owner(), _tTotal);
216     }
217 
218     function name() public pure returns (string memory) { return _name; }
219     function symbol() public pure returns (string memory) { return _symbol; }
220     function decimals() public pure returns (uint8) { return _decimals; }
221     function totalSupply() public pure override returns (uint256) { return _tTotal; }
222     function balanceOf(address account) public view override returns (uint256) { return _tOwned[account]; }
223     function transfer(address recipient, uint256 amount) public override returns (bool) { _transfer(_msgSender(), recipient, amount); return true; }
224     function allowance(address owner, address spender) public view override returns (uint256) { return _allowances[owner][spender]; }
225     function approve(address spender, uint256 amount) public override returns (bool) { _approve(_msgSender(), spender, amount); return true; }
226 
227     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
228         _transfer(sender, recipient, amount);
229 
230         uint256 currentAllowance = _allowances[sender][_msgSender()];
231         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
232         _approve(sender, _msgSender(), currentAllowance - amount);
233         return true;
234     }
235 
236     function _approve(address owner, address spender, uint256 amount) private {
237         require(owner != address(0), "ERC20: approve from the zero address");
238         require(spender != address(0), "ERC20: approve to the zero address");
239         _allowances[owner][spender] = amount;
240         emit Approval(owner, spender, amount);
241     }
242 
243     function _transfer(address from, address to, uint256 amount) private {
244         require(from != address(0), "ERC20: transfer from the zero address");
245         require(to != address(0), "ERC20: transfer to the zero address");
246         require(amount > 0, "Transfer amount must be greater than zero");
247         require(amount <= balanceOf(from),"You are trying to transfer more than your balance");    
248         require(tradingOpen || _isExcludedFromFee[from] || _isExcludedFromFee[to], "Trading not enabled yet");
249 
250         if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to]) {
251                 require(amount <= maxTxAmount, "Exceeds the _maxTxAmount.");
252                 require(balanceOf(to) + amount <= maxWalletAmount, "Exceeds the maxWalletSize.");
253         }
254 
255         uint256 contractTokenBalance = balanceOf(address(this));
256             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>0) {
257                 swapTokensForEth(contractTokenBalance);
258                 uint256 contractETHBalance = address(this).balance;
259                 if(contractETHBalance > 0) {
260                     sendETHToFee(address(this).balance);
261                 }
262             }
263 
264         _tokenTransfer(from, to, amount, !(_isExcludedFromFee[from] || _isExcludedFromFee[to]));
265     }
266 
267     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
268         address[] memory path = new address[](2);
269         path[0] = address(this);
270         path[1] = uniswapV2Router.WETH();
271         _approve(address(this), address(uniswapV2Router), tokenAmount);
272         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
273             tokenAmount,
274             0,
275             path,
276             address(this),
277             block.timestamp
278         );
279     }
280 
281     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
282         _tOwned[sender] -= amount;
283         uint256 amountReceived = (takeFee) ? takeTaxes(sender, recipient, amount) : amount;
284         _tOwned[recipient] += amountReceived;
285         emit Transfer(sender, recipient, amountReceived);
286     }
287 
288     function takeTaxes(address from, address to, uint256 amount) internal returns (uint256) {
289         if(from == uniswapV2Pair) { 
290             //buy
291             tokensForAutoBurn = amount * buyAutoBurnFee / masterTaxDivisor;
292             tokensForMarketing = amount * buyMarketingFee / masterTaxDivisor;   
293         } else if (to == uniswapV2Pair) { 
294             // sell
295             tokensForAutoBurn = amount * sellAutoBurnFee / masterTaxDivisor;
296             tokensForMarketing = amount * sellMarketingFee / masterTaxDivisor;
297         }
298 
299         _tOwned[DEAD] += tokensForAutoBurn;
300         emit Transfer(from, DEAD, tokensForAutoBurn);
301 
302         _tOwned[address(this)] += tokensForMarketing;
303         emit Transfer(from, address(this), tokensForMarketing);
304         
305         uint256 feeAmount = tokensForAutoBurn + tokensForMarketing;
306         return amount - feeAmount;
307     }
308 
309     function excludeFromFee(address account) public onlyOwner {
310         _isExcludedFromFee[account] = true;
311     }
312 
313     function includeInFee(address account) public onlyOwner {
314         _isExcludedFromFee[account] = false;
315     }
316 
317     function updateMaxTxAmt(uint256 amount) external onlyOwner{
318         maxTxAmount = amount * 10 **_decimals;
319     }
320 
321     function updateMaxWalletAmount(uint256 amount) external onlyOwner {
322         maxWalletAmount = amount * 10 **_decimals;
323     }
324 
325     function SetWalletandTxtAmount(uint256 _maxTxAmount, uint256 _maxWalletSize) external onlyOwner{
326         maxTxAmount = _maxTxAmount * 10 **_decimals;
327         maxWalletAmount = _maxWalletSize * 10 **_decimals;
328     }
329 
330     function updateBuyFees(uint256 _buyAutoBurnFee, uint256 _buyMarketingFee) external onlyOwner {
331         buyAutoBurnFee = _buyAutoBurnFee;
332         buyMarketingFee = _buyMarketingFee;
333         totalBuyFees = buyAutoBurnFee + buyMarketingFee;
334         require(totalBuyFees <= 5, "Must keep fees at 5% or less");
335     }
336     
337     function updateSellFees(uint256 _sellAutoBurnFee, uint256 _sellMarketingFee) external onlyOwner {
338         sellAutoBurnFee = _sellAutoBurnFee;
339         sellMarketingFee = _sellMarketingFee;
340         totalBuyFees = sellAutoBurnFee +sellMarketingFee;
341         require(totalBuyFees <= 5, "Must keep fees at 5% or less");
342     }
343 
344     function sendETHToFee(uint256 amount) private {
345         feeAddrWallet.transfer(amount);
346     } 
347 
348     receive() external payable{
349     }
350 }