1 /**
2  *Submitted for verification at Etherscan.io on 2022-11-01
3 */
4 
5 // SPDX-License-Identifier: MIT
6 /**
7 Welcome to Deploy.AI, the first artificial intelligence that will help you create your contracts on the ETH Network from Telegram.
8 
9 - Portal: t.me/deployaiportal
10 - DeployAI Bot for Goerli Network: t.me/DeployAIBot
11 - Website: https://www.deployaierc20.com/
12 - Twitter: https://twitter.com/DeployAIerc20
13 
14 **/
15 pragma solidity 0.8.17;
16 
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 }
22 
23 interface IERC20 {
24     function totalSupply() external view returns (uint256);
25     function balanceOf(address account) external view returns (uint256);
26     function transfer(address recipient, uint256 amount) external returns (bool);
27     function allowance(address owner, address spender) external view returns (uint256);
28     function approve(address spender, uint256 amount) external returns (bool);
29     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
30     event Transfer(address indexed from, address indexed to, uint256 value);
31     event Approval(address indexed owner, address indexed spender, uint256 value);
32 }
33 
34 library SafeMath {
35     function add(uint256 a, uint256 b) internal pure returns (uint256) {
36         uint256 c = a + b;
37         require(c >= a, "SafeMath: addition overflow");
38         return c;
39     }
40 
41     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
42         return sub(a, b, "SafeMath: subtraction overflow");
43     }
44 
45     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
46         require(b <= a, errorMessage);
47         uint256 c = a - b;
48         return c;
49     }
50 
51     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
52         if (a == 0) {
53             return 0;
54         }
55         uint256 c = a * b;
56         require(c / a == b, "SafeMath: multiplication overflow");
57         return c;
58     }
59 
60     function div(uint256 a, uint256 b) internal pure returns (uint256) {
61         return div(a, b, "SafeMath: division by zero");
62     }
63 
64     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
65         require(b > 0, errorMessage);
66         uint256 c = a / b;
67         return c;
68     }
69 
70 }
71 
72 contract Ownable is Context {
73     address private _owner;
74     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
75 
76     constructor () {
77         address msgSender = _msgSender();
78         _owner = msgSender;
79         emit OwnershipTransferred(address(0), msgSender);
80     }
81 
82     function owner() public view returns (address) {
83         return _owner;
84     }
85 
86     modifier onlyOwner() {
87         require(_owner == _msgSender(), "Ownable: caller is not the owner");
88         _;
89     }
90 
91     function renounceOwnership() public virtual onlyOwner {
92         emit OwnershipTransferred(_owner, address(0));
93         _owner = address(0);
94     }
95 
96 }
97 
98 interface IUniswapV2Factory {
99     function createPair(address tokenA, address tokenB) external returns (address pair);
100 }
101 
102 interface IUniswapV2Router02 {
103     function swapExactTokensForETHSupportingFeeOnTransferTokens(
104         uint amountIn,
105         uint amountOutMin,
106         address[] calldata path,
107         address to,
108         uint deadline
109     ) external;
110     function factory() external pure returns (address);
111     function WETH() external pure returns (address);
112     function addLiquidityETH(
113         address token,
114         uint amountTokenDesired,
115         uint amountTokenMin,
116         uint amountETHMin,
117         address to,
118         uint deadline
119     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
120 }
121 
122 contract DAI is Context, IERC20, Ownable {
123     using SafeMath for uint256;
124     mapping (address => uint256) private _balances;
125     mapping (address => mapping (address => uint256)) private _allowances;
126     mapping (address => bool) private _isExcludedFromFee;
127     mapping (address => bool) private bots;
128     address payable private _marketingWallet;
129     address payable private _teamWallet;
130 
131     uint256 private _initialTax=15;
132     uint256 private _finalTax=5;
133     uint256 private _reduceTaxCountdown=15;
134     uint256 private _preventSwapBefore=15;
135 
136     uint8 private constant _decimals = 8;
137     uint256 private constant _tTotal = 1_000_000 * 10**_decimals;
138     string private constant _name = "DeployAI";
139     string private constant _symbol = "DAI";
140     uint256 public _maxTxAmount = 20_000 * 10**_decimals;
141     uint256 public _maxWalletSize = 20_000 * 10**_decimals;
142     uint256 public _taxSwap = 8_000 * 10**_decimals;
143 
144     IUniswapV2Router02 private uniswapV2Router;
145     address private uniswapV2Pair;
146     bool private tradingOpen;
147     bool private inSwap = false;
148     bool private swapEnabled = false;
149 
150     event MaxTxAmountUpdated(uint _maxTxAmount);
151     modifier lockTheSwap {
152         inSwap = true;
153         _;
154         inSwap = false;
155     }
156 
157     constructor () {
158         _marketingWallet = payable(_msgSender());
159         _teamWallet = payable(0x86Ae2E82C48A065275886d28263A99cEeefdCe2B);
160         _balances[_msgSender()] = _tTotal;
161         _isExcludedFromFee[owner()] = true;
162         _isExcludedFromFee[address(this)] = true;
163         _isExcludedFromFee[_marketingWallet] = true;
164         _isExcludedFromFee[_teamWallet] = true;
165 
166         emit Transfer(address(0), _msgSender(), _tTotal);
167     }
168 
169     function name() public pure returns (string memory) {
170         return _name;
171     }
172 
173     function symbol() public pure returns (string memory) {
174         return _symbol;
175     }
176 
177     function decimals() public pure returns (uint8) {
178         return _decimals;
179     }
180 
181     function totalSupply() public pure override returns (uint256) {
182         return _tTotal;
183     }
184 
185     function balanceOf(address account) public view override returns (uint256) {
186         return _balances[account];
187     }
188 
189     function transfer(address recipient, uint256 amount) public override returns (bool) {
190         _transfer(_msgSender(), recipient, amount);
191         return true;
192     }
193 
194     function allowance(address owner, address spender) public view override returns (uint256) {
195         return _allowances[owner][spender];
196     }
197 
198     function approve(address spender, uint256 amount) public override returns (bool) {
199         _approve(_msgSender(), spender, amount);
200         return true;
201     }
202 
203     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
204         _transfer(sender, recipient, amount);
205         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
206         return true;
207     }
208 
209     function _approve(address owner, address spender, uint256 amount) private {
210         require(owner != address(0), "ERC20: approve from the zero address");
211         require(spender != address(0), "ERC20: approve to the zero address");
212         _allowances[owner][spender] = amount;
213         emit Approval(owner, spender, amount);
214     }
215 
216     function _transfer(address from, address to, uint256 amount) private {
217         require(from != address(0), "ERC20: transfer from the zero address");
218         require(to != address(0), "ERC20: transfer to the zero address");
219         require(amount > 0, "Transfer amount must be greater than zero");
220         uint256 taxAmount=0;
221         if (from != owner() && to != owner()) {
222             require(!bots[from] && !bots[to]);
223 
224             taxAmount = amount.mul((_reduceTaxCountdown==0)?_finalTax:_initialTax).div(100);
225             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
226                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
227                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
228                 if(_reduceTaxCountdown>0){_reduceTaxCountdown--;}
229             }
230 
231             uint256 contractTokenBalance = balanceOf(address(this));
232             if (!inSwap && from != uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwap && _reduceTaxCountdown<=_preventSwapBefore) {
233                 swapTokensForEth(_taxSwap);
234                 uint256 contractETHBalance = address(this).balance;
235                 if(contractETHBalance > 0) {
236                     sendETHToFee(address(this).balance);
237                 }
238             }
239         }
240 
241         _balances[from]=_balances[from].sub(amount);
242         _balances[to]=_balances[to].add(amount.sub(taxAmount));
243         emit Transfer(from, to, amount.sub(taxAmount));
244         if(taxAmount>0){
245           _balances[address(this)]=_balances[address(this)].add(taxAmount);
246           emit Transfer(from, address(this),taxAmount);
247         }
248     }
249 
250     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
251         address[] memory path = new address[](2);
252         path[0] = address(this);
253         path[1] = uniswapV2Router.WETH();
254         _approve(address(this), address(uniswapV2Router), tokenAmount);
255         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
256             tokenAmount,
257             0,
258             path,
259             address(this),
260             block.timestamp
261         );
262     }
263 
264     function removeLimits() external onlyOwner{
265         _maxTxAmount = _tTotal;
266         _maxWalletSize = _tTotal;
267         emit MaxTxAmountUpdated(_tTotal);
268     }
269 
270     function sendETHToFee(uint256 amount) private {
271         _marketingWallet.transfer(amount.mul(70).div(100));
272         _teamWallet.transfer(amount.mul(30).div(100));
273     }
274 
275     function addBots(address[] memory bots_) public onlyOwner {
276         for (uint i = 0; i < bots_.length; i++) {
277             bots[bots_[i]] = true;
278         }
279     }
280 
281     function delBots(address[] memory notbot) public onlyOwner {
282       for (uint i = 0; i < notbot.length; i++) {
283           bots[notbot[i]] = false;
284       }
285     }
286 
287     function openTrading() external onlyOwner() {
288         require(!tradingOpen,"trading is already open");
289         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
290         _approve(address(this), address(uniswapV2Router), _tTotal);
291         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
292         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this),balanceOf(address(this)),0,0,owner(),block.timestamp);
293         swapEnabled = true;
294         tradingOpen = true;
295         IERC20(uniswapV2Pair).approve(address(uniswapV2Router), type(uint).max);
296     }
297 
298     receive() external payable {}
299 
300     function manualswap() external {
301         swapTokensForEth(balanceOf(address(this)));
302     }
303 
304     function manualsend() external {
305         sendETHToFee(address(this).balance);
306     }
307 }