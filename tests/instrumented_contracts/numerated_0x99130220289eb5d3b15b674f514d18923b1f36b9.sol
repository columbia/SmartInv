1 //
2 //  TWITTER: https://twitter.com/DouyinERC
3 //
4 
5 // SPDX-License-Identifier: MIT
6 pragma solidity 0.8.17;
7 
8 abstract contract Context {
9     function _msgSender() internal view virtual returns (address) {
10         return msg.sender;
11     }
12 }
13 
14 interface IERC20 {
15     function totalSupply() external view returns (uint256);
16     function balanceOf(address account) external view returns (uint256);
17     function transfer(address recipient, uint256 amount) external returns (bool);
18     function allowance(address owner, address spender) external view returns (uint256);
19     function approve(address spender, uint256 amount) external returns (bool);
20     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
21     event Transfer(address indexed from, address indexed to, uint256 value);
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 library SafeMath {
26     function add(uint256 a, uint256 b) internal pure returns (uint256) {
27         uint256 c = a + b;
28         require(c >= a, "SafeMath: addition overflow");
29         return c;
30     }
31 
32     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
33         return sub(a, b, "SafeMath: subtraction overflow");
34     }
35 
36     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b <= a, errorMessage);
38         uint256 c = a - b;
39         return c;
40     }
41 
42     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
43         if (a == 0) {
44             return 0;
45         }
46         uint256 c = a * b;
47         require(c / a == b, "SafeMath: multiplication overflow");
48         return c;
49     }
50 
51     function div(uint256 a, uint256 b) internal pure returns (uint256) {
52         return div(a, b, "SafeMath: division by zero");
53     }
54 
55     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58         return c;
59     }
60 
61 }
62 
63 contract Ownable is Context {
64     address private _owner;
65     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
66 
67     constructor () {
68         address msgSender = _msgSender();
69         _owner = msgSender;
70         emit OwnershipTransferred(address(0), msgSender);
71     }
72 
73     function owner() public view returns (address) {
74         return _owner;
75     }
76 
77     modifier onlyOwner() {
78         require(_owner == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87 }
88 
89 interface IUniswapV2Factory {
90     function createPair(address tokenA, address tokenB) external returns (address pair);
91 }
92 
93 interface IUniswapV2Router02 {
94     function swapExactTokensForETHSupportingFeeOnTransferTokens(
95         uint amountIn,
96         uint amountOutMin,
97         address[] calldata path,
98         address to,
99         uint deadline
100     ) external;
101     function factory() external pure returns (address);
102     function WETH() external pure returns (address);
103 }
104 
105 contract Douyin is Context , IERC20, Ownable {
106     using SafeMath for uint256;
107 
108     string private constant _name = "DOUYIN";
109     string private constant _symbol = "TIKTOK";
110     mapping (address => uint256) private _balances;
111     mapping (address => mapping (address => uint256)) private _allowances;
112     mapping (address => bool) private _isExcludedFromFee;
113     mapping (address => bool) private bots;
114     address payable private _mktWallet;
115 
116     uint256 private _buyTax = 25;
117     uint256 private _sellTax = 35;
118 
119     uint8 private constant _decimals = 9;
120     uint256 private constant _tTotal = 360000000000000 * 10**_decimals;
121     uint256 public _maxTxAmount = 2 * (_tTotal/100);
122     uint256 public _maxWalletSize = 2 * (_tTotal/100);
123     uint256 public _taxSwapThreshold = 5 * (_tTotal/1000);
124 
125     IUniswapV2Router02 public uniswapV2Router;
126     address public uniswapV2Pair;
127     bool private tradingOpen = true;
128     bool private inSwap = false;
129     bool private swapEnabled = true;
130 
131     event MaxTxAmountUpdated(uint _maxTxAmount);
132     modifier lockTheSwap {
133         inSwap = true;
134         _;
135         inSwap = false;
136     }
137 
138     constructor () {
139         _balances[_msgSender()] = _tTotal;
140 
141         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
142         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
143         
144         _mktWallet = payable(_msgSender());
145         _isExcludedFromFee[owner()] = true;
146         _isExcludedFromFee[address(this)] = true;
147         _isExcludedFromFee[_mktWallet] = true;
148 
149         emit Transfer(address(0), _msgSender(), _tTotal);
150     }
151 
152     function name() public pure returns (string memory) {
153         return _name;
154     }
155 
156     function symbol() public pure returns (string memory) {
157         return _symbol;
158     }
159 
160     function decimals() public pure returns (uint8) {
161         return _decimals;
162     }
163 
164     function totalSupply() public pure override returns (uint256) {
165         return _tTotal;
166     }
167 
168     function balanceOf(address account) public view override returns (uint256) {
169         return _balances[account];
170     }
171 
172     function transfer(address recipient, uint256 amount) public override returns (bool) {
173         _transfer(_msgSender(), recipient, amount);
174         return true;
175     }
176 
177     function allowance(address owner, address spender) public view override returns (uint256) {
178         return _allowances[owner][spender];
179     }
180 
181     function approve(address spender, uint256 amount) public override returns (bool) {
182         _approve(_msgSender(), spender, amount);
183         return true;
184     }
185 
186     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
187         _transfer(sender, recipient, amount);
188         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
189         return true;
190     }
191 
192     function _approve(address owner, address spender, uint256 amount) private {
193         require(owner != address(0), "ERC20: approve from the zero address");
194         require(spender != address(0), "ERC20: approve to the zero address");
195         _allowances[owner][spender] = amount;
196         emit Approval(owner, spender, amount);
197     }
198 
199     function _transfer(address from, address to, uint256 amount) private {
200         require(from != address(0), "ERC20: transfer from the zero address");
201         require(to != address(0), "ERC20: transfer to the zero address");
202         require(amount > 0, "Transfer amount must be greater than zero");
203         uint256 taxAmount=0;
204         if (from != owner() && to != owner()) {
205             require(tradingOpen == true, "ERC20: This account cannot send tokens until trading is enabled");
206             require(!bots[from] && !bots[to], "ERC20: Wallet is blacklist!");
207             taxAmount = amount.mul(_buyTax).div(100);
208 
209             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
210                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
211                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
212             }
213 
214             if(to == uniswapV2Pair && from!= address(this) ){
215                 taxAmount = amount.mul(_sellTax).div(100);
216             }
217 
218             uint256 contractTokenBalance = balanceOf(address(this));
219             if(contractTokenBalance >= _maxTxAmount) {
220                 contractTokenBalance = _maxTxAmount;
221             }
222             if (!inSwap && to  == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
223                 swapTokensForEth(contractTokenBalance);
224                 uint256 contractETHBalance = address(this).balance;
225                 if(contractETHBalance > 0) {
226                     sendETHToFee(address(this).balance);
227                 }
228             }
229         }
230 
231         if(taxAmount>0){
232           _balances[address(this)]=_balances[address(this)].add(taxAmount);
233           emit Transfer(from, address(this),taxAmount);
234         }
235         _balances[from]=_balances[from].sub(amount);
236         _balances[to]=_balances[to].add(amount.sub(taxAmount));
237         emit Transfer(from, to, amount.sub(taxAmount));
238     }
239 
240     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
241         address[] memory path = new address[](2);
242         path[0] = address(this);
243         path[1] = uniswapV2Router.WETH();
244         _approve(address(this), address(uniswapV2Router), tokenAmount);
245         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
246             tokenAmount,
247             0,
248             path,
249             address(this),
250             block.timestamp
251         );
252     }
253 
254     function removeMax() external onlyOwner {
255         _maxTxAmount = _tTotal;
256         _maxWalletSize=_tTotal;
257         emit MaxTxAmountUpdated(_tTotal);
258     }
259 
260     function sendETHToFee(uint256 amount) private {
261         _mktWallet.transfer(amount);
262     }
263 
264     function openTrading() external onlyOwner {
265         require(tradingOpen == false, "Trading is enabled!");
266         tradingOpen = true;
267     }
268     
269     function reduceFee(uint256 _buy, uint256 _sell ) external onlyOwner {
270       _buyTax = _buy;
271       _sellTax = _sell;
272     }
273 
274     receive() external payable {}
275 
276     function manualSwap() external {
277         require(_msgSender()==_mktWallet);
278         uint256 tokenBalance=balanceOf(address(this));
279         if(tokenBalance>0){
280           swapTokensForEth(tokenBalance);
281         }
282         uint256 ethBalance=address(this).balance;
283         if(ethBalance>0){
284           sendETHToFee(ethBalance);
285         }
286     }
287 }