1 //  TWITTER: https://twitter.com/WechatETH
2 
3 
4 // SPDX-License-Identifier: MIT
5 pragma solidity 0.8.17;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 }
12 
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28         return c;
29     }
30 
31     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
32         return sub(a, b, "SafeMath: subtraction overflow");
33     }
34 
35     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
36         require(b <= a, errorMessage);
37         uint256 c = a - b;
38         return c;
39     }
40 
41     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
42         if (a == 0) {
43             return 0;
44         }
45         uint256 c = a * b;
46         require(c / a == b, "SafeMath: multiplication overflow");
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         return div(a, b, "SafeMath: division by zero");
52     }
53 
54     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55         require(b > 0, errorMessage);
56         uint256 c = a / b;
57         return c;
58     }
59 
60 }
61 
62 contract Ownable is Context {
63     address private _owner;
64     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
65 
66     constructor () {
67         address msgSender = _msgSender();
68         _owner = msgSender;
69         emit OwnershipTransferred(address(0), msgSender);
70     }
71 
72     function owner() public view returns (address) {
73         return _owner;
74     }
75 
76     modifier onlyOwner() {
77         require(_owner == _msgSender(), "Ownable: caller is not the owner");
78         _;
79     }
80 
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86 }
87 
88 interface IUniswapV2Factory {
89     function createPair(address tokenA, address tokenB) external returns (address pair);
90 }
91 
92 interface IUniswapV2Router02 {
93     function swapExactTokensForETHSupportingFeeOnTransferTokens(
94         uint amountIn,
95         uint amountOutMin,
96         address[] calldata path,
97         address to,
98         uint deadline
99     ) external;
100     function factory() external pure returns (address);
101     function WETH() external pure returns (address);
102 }
103 
104 contract Wechat is Context , IERC20, Ownable {
105     using SafeMath for uint256;
106 
107     string private constant _name = "Wechat";
108     string private constant _symbol = "WECHAT";
109     mapping (address => uint256) private _balances;
110     mapping (address => mapping (address => uint256)) private _allowances;
111     mapping (address => bool) private _isExcludedFromFee;
112     mapping (address => bool) private bots;
113     address payable private _taxWallet;
114 
115     uint256 private _buyTax = 20;
116     uint256 private _sellTax = 35;
117 
118     uint8 private constant _decimals = 9;
119     uint256 private constant _tTotal = 211_201_100_000_000 * 10**_decimals;
120     uint256 public _maxTxAmount = 2 * (_tTotal/100);
121     uint256 public _maxWalletSize = 2 * (_tTotal/100);
122     uint256 public _taxSwapThreshold = 3 * (_tTotal/1000);
123 
124     IUniswapV2Router02 public uniswapV2Router;
125     address public uniswapV2Pair;
126     bool private tradingOpen = true;
127     bool private inSwap = false;
128     bool private swapEnabled = true;
129 
130     event MaxTxAmountUpdated(uint _maxTxAmount);
131     modifier lockTheSwap {
132         inSwap = true;
133         _;
134         inSwap = false;
135     }
136 
137     constructor () {
138         _balances[_msgSender()] = _tTotal;
139 
140         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
141         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
142         
143         _taxWallet = payable(_msgSender());
144         _isExcludedFromFee[owner()] = true;
145         _isExcludedFromFee[address(this)] = true;
146         _isExcludedFromFee[_taxWallet] = true;
147 
148         emit Transfer(address(0), _msgSender(), _tTotal);
149     }
150 
151     function name() public pure returns (string memory) {
152         return _name;
153     }
154 
155     function symbol() public pure returns (string memory) {
156         return _symbol;
157     }
158 
159     function decimals() public pure returns (uint8) {
160         return _decimals;
161     }
162 
163     function totalSupply() public pure override returns (uint256) {
164         return _tTotal;
165     }
166 
167     function balanceOf(address account) public view override returns (uint256) {
168         return _balances[account];
169     }
170 
171     function transfer(address recipient, uint256 amount) public override returns (bool) {
172         _transfer(_msgSender(), recipient, amount);
173         return true;
174     }
175 
176     function allowance(address owner, address spender) public view override returns (uint256) {
177         return _allowances[owner][spender];
178     }
179 
180     function approve(address spender, uint256 amount) public override returns (bool) {
181         _approve(_msgSender(), spender, amount);
182         return true;
183     }
184 
185     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
186         _transfer(sender, recipient, amount);
187         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
188         return true;
189     }
190 
191     function _approve(address owner, address spender, uint256 amount) private {
192         require(owner != address(0), "ERC20: approve from the zero address");
193         require(spender != address(0), "ERC20: approve to the zero address");
194         _allowances[owner][spender] = amount;
195         emit Approval(owner, spender, amount);
196     }
197 
198     function _transfer(address from, address to, uint256 amount) private {
199         require(from != address(0), "ERC20: transfer from the zero address");
200         require(to != address(0), "ERC20: transfer to the zero address");
201         require(amount > 0, "Transfer amount must be greater than zero");
202         uint256 taxAmount=0;
203         if (from != owner() && to != owner()) {
204             require(tradingOpen == true, "ERC20: This account cannot send tokens until trading is enabled");
205             require(!bots[from] && !bots[to], "ERC20: Wallet is blacklist!");
206             taxAmount = amount.mul(_buyTax).div(100);
207 
208             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
209                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
210                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
211             }
212 
213             if(to == uniswapV2Pair && from!= address(this) ){
214                 taxAmount = amount.mul(_sellTax).div(100);
215             }
216 
217             uint256 contractTokenBalance = balanceOf(address(this));
218             if(contractTokenBalance >= _maxTxAmount) {
219                 contractTokenBalance = _maxTxAmount;
220             }
221             if (!inSwap && to  == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
222                 swapTokensForEth(contractTokenBalance);
223                 uint256 contractETHBalance = address(this).balance;
224                 if(contractETHBalance > 0) {
225                     sendETHToFee(address(this).balance);
226                 }
227             }
228         }
229 
230         if(taxAmount>0){
231           _balances[address(this)]=_balances[address(this)].add(taxAmount);
232           emit Transfer(from, address(this),taxAmount);
233         }
234         _balances[from]=_balances[from].sub(amount);
235         _balances[to]=_balances[to].add(amount.sub(taxAmount));
236         emit Transfer(from, to, amount.sub(taxAmount));
237     }
238 
239     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
240         address[] memory path = new address[](2);
241         path[0] = address(this);
242         path[1] = uniswapV2Router.WETH();
243         _approve(address(this), address(uniswapV2Router), tokenAmount);
244         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
245             tokenAmount,
246             0,
247             path,
248             address(this),
249             block.timestamp
250         );
251     }
252 
253     function removeLimits() external onlyOwner {
254         _maxTxAmount = _tTotal;
255         _maxWalletSize=_tTotal;
256         emit MaxTxAmountUpdated(_tTotal);
257     }
258 
259     function sendETHToFee(uint256 amount) private {
260         _taxWallet.transfer(amount);
261     }
262 
263     function openTrading() external onlyOwner {
264         require(tradingOpen == false, "Trading is enabled!");
265         tradingOpen = true;
266     }
267     
268     function setFee(uint256 _buy, uint256 _sell ) external onlyOwner {
269       _buyTax = _buy;
270       _sellTax = _sell;
271     }
272 
273     receive() external payable {}
274 
275     function manualSwap() external {
276         require(_msgSender()==_taxWallet);
277         uint256 tokenBalance=balanceOf(address(this));
278         if(tokenBalance>0){
279           swapTokensForEth(tokenBalance);
280         }
281         uint256 ethBalance=address(this).balance;
282         if(ethBalance>0){
283           sendETHToFee(ethBalance);
284         }
285     }
286 }