1 /**
2  *Submitted for verification at Etherscan.io on 2022-11-01
3 */
4 
5 // SPDX-License-Identifier: MIT
6 /**
7 ██████  ██       ██████   ██████ ██   ██ ██████  ███████ ██████  ██  █████  
8 ██   ██ ██      ██    ██ ██      ██  ██  ██   ██ ██      ██   ██ ██ ██   ██ 
9 ██████  ██      ██    ██ ██      █████   ██████  █████   ██   ██ ██ ███████ 
10 ██   ██ ██      ██    ██ ██      ██  ██  ██      ██      ██   ██ ██ ██   ██ 
11 ██████  ███████  ██████   ██████ ██   ██ ██      ███████ ██████  ██ ██   ██ 
12 
13 Discover the encyclopedia of the DeFi world
14 With Blockpedia dApp, you will never again invest blindly     
15 Join our community and learn more about the project
16 
17 Telegram: t.me/blockpediaportal
18 Website: www.blockpedia-dapp.com/
19 Twitter: https://twitter.com/blockpedia_dapp
20 Medium: https://medium.com/@blockpediaofficial/blockpedia-9ddb69c80b68
21 https://linktr.ee/blockpedia
22 
23 Distribution:
24 - 4% Marketing
25 - 1% Dev
26 
27 **/
28 pragma solidity 0.8.17;
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
85 contract Ownable is Context {
86     address private _owner;
87     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
88 
89     constructor () {
90         address msgSender = _msgSender();
91         _owner = msgSender;
92         emit OwnershipTransferred(address(0), msgSender);
93     }
94 
95     function owner() public view returns (address) {
96         return _owner;
97     }
98 
99     modifier onlyOwner() {
100         require(_owner == _msgSender(), "Ownable: caller is not the owner");
101         _;
102     }
103 
104     function renounceOwnership() public virtual onlyOwner {
105         emit OwnershipTransferred(_owner, address(0));
106         _owner = address(0);
107     }
108 
109 }
110 
111 interface IUniswapV2Factory {
112     function createPair(address tokenA, address tokenB) external returns (address pair);
113 }
114 
115 interface IUniswapV2Router02 {
116     function swapExactTokensForETHSupportingFeeOnTransferTokens(
117         uint amountIn,
118         uint amountOutMin,
119         address[] calldata path,
120         address to,
121         uint deadline
122     ) external;
123     function factory() external pure returns (address);
124     function WETH() external pure returns (address);
125     function addLiquidityETH(
126         address token,
127         uint amountTokenDesired,
128         uint amountTokenMin,
129         uint amountETHMin,
130         address to,
131         uint deadline
132     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
133 }
134 
135 contract BPEDIA is Context, IERC20, Ownable {
136     using SafeMath for uint256;
137     mapping (address => uint256) private _balances;
138     mapping (address => mapping (address => uint256)) private _allowances;
139     mapping (address => bool) private _isExcludedFromFee;
140     mapping (address => bool) private bots;
141     address payable private _taxWallet;
142     address payable private _devWallet;
143 
144     uint256 private _initialTax=12;
145     uint256 private _finalTax=5;
146     uint256 private _reduceTaxCountdown=35;
147     uint256 private _preventSwapBefore=35;
148 
149     uint8 private constant _decimals = 8;
150     uint256 private constant _tTotal = 1_000_000 * 10**_decimals;
151     string private constant _name = "Blockpedia";
152     string private constant _symbol = "BPEDIA";
153     uint256 public _maxTxAmount = 20_000 * 10**_decimals;
154     uint256 public _maxWalletSize = 20_000 * 10**_decimals;
155     uint256 public _taxSwap=4_500 * 10**_decimals;
156 
157     IUniswapV2Router02 private uniswapV2Router;
158     address private uniswapV2Pair;
159     bool private tradingOpen;
160     bool private inSwap = false;
161     bool private swapEnabled = false;
162 
163     event MaxTxAmountUpdated(uint _maxTxAmount);
164     modifier lockTheSwap {
165         inSwap = true;
166         _;
167         inSwap = false;
168     }
169 
170     constructor () {
171         _taxWallet = payable(_msgSender());
172         _devWallet = payable(0xEc49E8CfFA73596AB6094eDaE1EFab5Cc5a484f8);
173         _balances[_msgSender()] = _tTotal;
174         _isExcludedFromFee[owner()] = true;
175         _isExcludedFromFee[address(this)] = true;
176         _isExcludedFromFee[_taxWallet] = true;
177         _isExcludedFromFee[_devWallet] = true;
178 
179         emit Transfer(address(0), _msgSender(), _tTotal);
180     }
181 
182     function name() public pure returns (string memory) {
183         return _name;
184     }
185 
186     function symbol() public pure returns (string memory) {
187         return _symbol;
188     }
189 
190     function decimals() public pure returns (uint8) {
191         return _decimals;
192     }
193 
194     function totalSupply() public pure override returns (uint256) {
195         return _tTotal;
196     }
197 
198     function balanceOf(address account) public view override returns (uint256) {
199         return _balances[account];
200     }
201 
202     function transfer(address recipient, uint256 amount) public override returns (bool) {
203         _transfer(_msgSender(), recipient, amount);
204         return true;
205     }
206 
207     function allowance(address owner, address spender) public view override returns (uint256) {
208         return _allowances[owner][spender];
209     }
210 
211     function approve(address spender, uint256 amount) public override returns (bool) {
212         _approve(_msgSender(), spender, amount);
213         return true;
214     }
215 
216     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
217         _transfer(sender, recipient, amount);
218         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
219         return true;
220     }
221 
222     function _approve(address owner, address spender, uint256 amount) private {
223         require(owner != address(0), "ERC20: approve from the zero address");
224         require(spender != address(0), "ERC20: approve to the zero address");
225         _allowances[owner][spender] = amount;
226         emit Approval(owner, spender, amount);
227     }
228 
229     function _transfer(address from, address to, uint256 amount) private {
230         require(from != address(0), "ERC20: transfer from the zero address");
231         require(to != address(0), "ERC20: transfer to the zero address");
232         require(amount > 0, "Transfer amount must be greater than zero");
233         uint256 taxAmount=0;
234         if (from != owner() && to != owner()) {
235             require(!bots[from] && !bots[to]);
236 
237             taxAmount = amount.mul((_reduceTaxCountdown==0)?_finalTax:_initialTax).div(100);
238             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
239                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
240                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
241                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
242             }
243 
244             uint256 contractTokenBalance = balanceOf(address(this));
245             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwap && _reduceTaxCountdown<=_preventSwapBefore) {
246                 swapTokensForEth(_taxSwap);
247                 uint256 contractETHBalance = address(this).balance;
248                 if(contractETHBalance > 0) {
249                     sendETHToFee(address(this).balance);
250                 }
251             }
252         }
253 
254         _balances[from]=_balances[from].sub(amount);
255         _balances[to]=_balances[to].add(amount.sub(taxAmount));
256         emit Transfer(from, to, amount.sub(taxAmount));
257         if(taxAmount>0){
258           _balances[address(this)]=_balances[address(this)].add(taxAmount);
259           emit Transfer(from, address(this),taxAmount);
260         }
261     }
262 
263     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
264         address[] memory path = new address[](2);
265         path[0] = address(this);
266         path[1] = uniswapV2Router.WETH();
267         _approve(address(this), address(uniswapV2Router), tokenAmount);
268         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
269             tokenAmount,
270             0,
271             path,
272             address(this),
273             block.timestamp
274         );
275     }
276 
277     function removeLimits() external onlyOwner{
278         _maxTxAmount = _tTotal;
279         _maxWalletSize = _tTotal;
280         emit MaxTxAmountUpdated(_tTotal);
281     }
282 
283     function sendETHToFee(uint256 amount) private {
284         _taxWallet.transfer(amount.mul(83).div(100));
285         _devWallet.transfer(amount.mul(17).div(100));
286     }
287 
288     function addBots(address[] memory bots_) public onlyOwner {
289         for (uint i = 0; i < bots_.length; i++) {
290             bots[bots_[i]] = true;
291         }
292     }
293 
294     function delBots(address[] memory notbot) public onlyOwner {
295       for (uint i = 0; i < notbot.length; i++) {
296           bots[notbot[i]] = false;
297       }
298     }
299 
300     function openTrading() external onlyOwner() {
301         require(!tradingOpen,"trading is already open");
302         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
303         _approve(address(this), address(uniswapV2Router), _tTotal);
304         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
305         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
306         swapEnabled = true;
307         tradingOpen = true;
308         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
309     }
310 
311     receive() external payable {}
312 
313     function manualswap() external {
314         swapTokensForEth(balanceOf(address(this)));
315     }
316 
317     function manualsend() external {
318         sendETHToFee(address(this).balance);
319     }
320 }