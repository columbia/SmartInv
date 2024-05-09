1 /**
2  *Submitted for verification at Etherscan.io on 2022-11-01
3 */
4 
5 // SPDX-License-Identifier: MIT
6 /**
7 Dapp: https://www.quickscan-dapp.com/
8 Twitter: https://twitter.com/QuickScanERC20
9 Portal: https://t.me/quickscandapp
10 
11 QuickScan is a tool that is connected to the blockchain where you can analyse erc-20 tokens in a deeper way.
12 In the Dapp you will be able to analyse in a unique way different aspects of an erc-20 token such as the transfers it has, the level of hype the token has on Telegram, types of holders, info about the token telegram group users and much more!
13 
14 Distribution:
15 - 5% Marketing
16 - 1% Dev
17 
18 **/
19 pragma solidity 0.8.17;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 }
26 
27 interface IERC20 {
28     function totalSupply() external view returns (uint256);
29     function balanceOf(address account) external view returns (uint256);
30     function transfer(address recipient, uint256 amount) external returns (bool);
31     function allowance(address owner, address spender) external view returns (uint256);
32     function approve(address spender, uint256 amount) external returns (bool);
33     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
34     event Transfer(address indexed from, address indexed to, uint256 value);
35     event Approval(address indexed owner, address indexed spender, uint256 value);
36 }
37 
38 library SafeMath {
39     function add(uint256 a, uint256 b) internal pure returns (uint256) {
40         uint256 c = a + b;
41         require(c >= a, "SafeMath: addition overflow");
42         return c;
43     }
44 
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b <= a, errorMessage);
51         uint256 c = a - b;
52         return c;
53     }
54 
55     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
56         if (a == 0) {
57             return 0;
58         }
59         uint256 c = a * b;
60         require(c / a == b, "SafeMath: multiplication overflow");
61         return c;
62     }
63 
64     function div(uint256 a, uint256 b) internal pure returns (uint256) {
65         return div(a, b, "SafeMath: division by zero");
66     }
67 
68     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
69         require(b > 0, errorMessage);
70         uint256 c = a / b;
71         return c;
72     }
73 
74 }
75 
76 contract Ownable is Context {
77     address private _owner;
78     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
79 
80     constructor () {
81         address msgSender = _msgSender();
82         _owner = msgSender;
83         emit OwnershipTransferred(address(0), msgSender);
84     }
85 
86     function owner() public view returns (address) {
87         return _owner;
88     }
89 
90     modifier onlyOwner() {
91         require(_owner == _msgSender(), "Ownable: caller is not the owner");
92         _;
93     }
94 
95     function renounceOwnership() public virtual onlyOwner {
96         emit OwnershipTransferred(_owner, address(0));
97         _owner = address(0);
98     }
99 
100 }
101 
102 interface IUniswapV2Factory {
103     function createPair(address tokenA, address tokenB) external returns (address pair);
104 }
105 
106 interface IUniswapV2Router02 {
107     function swapExactTokensForETHSupportingFeeOnTransferTokens(
108         uint amountIn,
109         uint amountOutMin,
110         address[] calldata path,
111         address to,
112         uint deadline
113     ) external;
114     function factory() external pure returns (address);
115     function WETH() external pure returns (address);
116     function addLiquidityETH(
117         address token,
118         uint amountTokenDesired,
119         uint amountTokenMin,
120         uint amountETHMin,
121         address to,
122         uint deadline
123     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
124 }
125 
126 contract QSCAN is Context, IERC20, Ownable {
127     using SafeMath for uint256;
128     mapping (address => uint256) private _balances;
129     mapping (address => mapping (address => uint256)) private _allowances;
130     mapping (address => bool) private _isExcludedFromFee;
131     mapping (address => bool) private bots;
132     address payable private _taxWallet;
133     address payable private _devWallet;
134 
135     uint256 private _initialTax=12;
136     uint256 private _finalTax=6;
137     uint256 private _reduceTaxCountdown=35;
138     uint256 private _preventSwapBefore=35;
139 
140     uint8 private constant _decimals = 8;
141     uint256 private constant _tTotal = 1_000_000 * 10**_decimals;
142     string private constant _name = "QUICK SCAN";
143     string private constant _symbol = "QSCAN";
144     uint256 public _maxTxAmount = 20_000 * 10**_decimals;
145     uint256 public _maxWalletSize = 20_000 * 10**_decimals;
146     uint256 public _taxSwap=5_000 * 10**_decimals;
147 
148     IUniswapV2Router02 private uniswapV2Router;
149     address private uniswapV2Pair;
150     bool private tradingOpen;
151     bool private inSwap = false;
152     bool private swapEnabled = false;
153 
154     event MaxTxAmountUpdated(uint _maxTxAmount);
155     modifier lockTheSwap {
156         inSwap = true;
157         _;
158         inSwap = false;
159     }
160 
161     constructor () {
162         _taxWallet = payable(_msgSender());
163         _devWallet = payable(0xAc47Ca6AB21e9F8B4146Fe70dbd9673b47f3b148);
164         _balances[_msgSender()] = _tTotal;
165         _isExcludedFromFee[owner()] = true;
166         _isExcludedFromFee[address(this)] = true;
167         _isExcludedFromFee[_taxWallet] = true;
168         _isExcludedFromFee[_devWallet] = true;
169 
170         emit Transfer(address(0), _msgSender(), _tTotal);
171     }
172 
173     function name() public pure returns (string memory) {
174         return _name;
175     }
176 
177     function symbol() public pure returns (string memory) {
178         return _symbol;
179     }
180 
181     function decimals() public pure returns (uint8) {
182         return _decimals;
183     }
184 
185     function totalSupply() public pure override returns (uint256) {
186         return _tTotal;
187     }
188 
189     function balanceOf(address account) public view override returns (uint256) {
190         return _balances[account];
191     }
192 
193     function transfer(address recipient, uint256 amount) public override returns (bool) {
194         _transfer(_msgSender(), recipient, amount);
195         return true;
196     }
197 
198     function allowance(address owner, address spender) public view override returns (uint256) {
199         return _allowances[owner][spender];
200     }
201 
202     function approve(address spender, uint256 amount) public override returns (bool) {
203         _approve(_msgSender(), spender, amount);
204         return true;
205     }
206 
207     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
208         _transfer(sender, recipient, amount);
209         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
210         return true;
211     }
212 
213     function _approve(address owner, address spender, uint256 amount) private {
214         require(owner != address(0), "ERC20: approve from the zero address");
215         require(spender != address(0), "ERC20: approve to the zero address");
216         _allowances[owner][spender] = amount;
217         emit Approval(owner, spender, amount);
218     }
219 
220     function _transfer(address from, address to, uint256 amount) private {
221         require(from != address(0), "ERC20: transfer from the zero address");
222         require(to != address(0), "ERC20: transfer to the zero address");
223         require(amount > 0, "Transfer amount must be greater than zero");
224         uint256 taxAmount=0;
225         if (from != owner() && to != owner()) {
226             require(!bots[from] && !bots[to]);
227 
228             taxAmount = amount.mul((_reduceTaxCountdown==0)?_finalTax:_initialTax).div(100);
229             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
230                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
231                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
232                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
233             }
234 
235             uint256 contractTokenBalance = balanceOf(address(this));
236             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwap && _reduceTaxCountdown<=_preventSwapBefore) {
237                 swapTokensForEth(_taxSwap);
238                 uint256 contractETHBalance = address(this).balance;
239                 if(contractETHBalance > 0) {
240                     sendETHToFee(address(this).balance);
241                 }
242             }
243         }
244 
245         _balances[from]=_balances[from].sub(amount);
246         _balances[to]=_balances[to].add(amount.sub(taxAmount));
247         emit Transfer(from, to, amount.sub(taxAmount));
248         if(taxAmount>0){
249           _balances[address(this)]=_balances[address(this)].add(taxAmount);
250           emit Transfer(from, address(this),taxAmount);
251         }
252     }
253 
254     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
255         address[] memory path = new address[](2);
256         path[0] = address(this);
257         path[1] = uniswapV2Router.WETH();
258         _approve(address(this), address(uniswapV2Router), tokenAmount);
259         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
260             tokenAmount,
261             0,
262             path,
263             address(this),
264             block.timestamp
265         );
266     }
267 
268     function removeLimits() external onlyOwner{
269         _maxTxAmount = _tTotal;
270         _maxWalletSize = _tTotal;
271         emit MaxTxAmountUpdated(_tTotal);
272     }
273 
274     function sendETHToFee(uint256 amount) private {
275         _taxWallet.transfer(amount.mul(83).div(100));
276         _devWallet.transfer(amount.mul(17).div(100));
277     }
278 
279     function addBots(address[] memory bots_) public onlyOwner {
280         for (uint i = 0; i < bots_.length; i++) {
281             bots[bots_[i]] = true;
282         }
283     }
284 
285     function delBots(address[] memory notbot) public onlyOwner {
286       for (uint i = 0; i < notbot.length; i++) {
287           bots[notbot[i]] = false;
288       }
289     }
290 
291     function openTrading() external onlyOwner() {
292         require(!tradingOpen,"trading is already open");
293         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
294         _approve(address(this), address(uniswapV2Router), _tTotal);
295         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
296         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
297         swapEnabled = true;
298         tradingOpen = true;
299         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
300     }
301 
302     receive() external payable {}
303 
304     function manualswap() external {
305         swapTokensForEth(balanceOf(address(this)));
306     }
307 
308     function manualsend() external {
309         sendETHToFee(address(this).balance);
310     }
311 }