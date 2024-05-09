1 /*
2 
3     TW: https://twitter.com/LuciferErc20
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity 0.8.17;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 }
15 
16 interface IERC20 {
17     function totalSupply() external view returns (uint256);
18     function balanceOf(address account) external view returns (uint256);
19     function transfer(address recipient, uint256 amount) external returns (bool);
20     function allowance(address owner, address spender) external view returns (uint256);
21     function approve(address spender, uint256 amount) external returns (bool);
22     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25 }
26 
27 library SafeMath {
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31         return c;
32     }
33 
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         return sub(a, b, "SafeMath: subtraction overflow");
36     }
37 
38     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b <= a, errorMessage);
40         uint256 c = a - b;
41         return c;
42     }
43 
44     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
45         if (a == 0) {
46             return 0;
47         }
48         uint256 c = a * b;
49         require(c / a == b, "SafeMath: multiplication overflow");
50         return c;
51     }
52 
53     function div(uint256 a, uint256 b) internal pure returns (uint256) {
54         return div(a, b, "SafeMath: division by zero");
55     }
56 
57     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b > 0, errorMessage);
59         uint256 c = a / b;
60         return c;
61     }
62 
63 }
64 
65 contract Ownable is Context {
66     address private _owner;
67     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
68 
69     constructor () {
70         address msgSender = _msgSender();
71         _owner = msgSender;
72         emit OwnershipTransferred(address(0), msgSender);
73     }
74 
75     function owner() public view returns (address) {
76         return _owner;
77     }
78 
79     modifier onlyOwner() {
80         require(_owner == _msgSender(), "Ownable: caller is not the owner");
81         _;
82     }
83 
84     function renounceOwnership() public virtual onlyOwner {
85         emit OwnershipTransferred(_owner, address(0));
86         _owner = address(0);
87     }
88 
89 }
90 
91 interface IUniswapV2Factory {
92     function createPair(address tokenA, address tokenB) external returns (address pair);
93 }
94 
95 interface IUniswapV2Router02 {
96     function swapExactTokensForETHSupportingFeeOnTransferTokens(
97         uint amountIn,
98         uint amountOutMin,
99         address[] calldata path,
100         address to,
101         uint deadline
102     ) external;
103     function factory() external pure returns (address);
104     function WETH() external pure returns (address);
105 }
106 
107 contract Lucifer is Context , IERC20, Ownable {
108     using SafeMath for uint256;
109     mapping (address => uint256) private _balances;
110     mapping (address => mapping (address => uint256)) private _allowances;
111     mapping (address => bool) private _isExcludedFromFee;
112     mapping (address => bool) private bots;
113     address payable private _marketingWallet;
114 
115     string private constant _name = unicode"Lucifer";
116     string private constant _symbol = unicode"LUCI";
117 
118     uint256 private _buyTax = 26;
119     uint256 private _sellTax = 36;
120 
121     uint8 private constant _decimals = 9;
122     uint256 private constant _tTotal = 666_666_666_666 * 10**_decimals;
123     uint256 public _maxTxAmount = 15 * (_tTotal / 1000);
124     uint256 public _maxWalletSize = 15 * (_tTotal / 1000);
125     uint256 public _taxSwapThreshold= 5 * (_tTotal / 1000);
126 
127     IUniswapV2Router02 private uniswapV2Router;
128     address private uniswapV2Pair;
129     bool private tradingOpen = true;
130     bool private inSwap = false;
131     bool private swapEnabled = true;
132 
133     event MaxTxAmountUpdated(uint _maxTxAmount);
134     modifier lockTheSwap {
135         inSwap = true;
136         _;
137         inSwap = false;
138     }
139 
140     constructor () {
141         _balances[_msgSender()] = _tTotal;
142 
143         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
144         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
145         
146         _marketingWallet = payable(_msgSender());
147         _isExcludedFromFee[owner()] = true;
148         _isExcludedFromFee[address(this)] = true;
149         _isExcludedFromFee[_marketingWallet] = true;
150 
151         emit Transfer(address(0), _msgSender(), _tTotal);
152     }
153 
154     function name() public pure returns (string memory) {
155         return _name;
156     }
157 
158     function symbol() public pure returns (string memory) {
159         return _symbol;
160     }
161 
162     function decimals() public pure returns (uint8) {
163         return _decimals;
164     }
165 
166     function totalSupply() public pure override returns (uint256) {
167         return _tTotal;
168     }
169 
170     function balanceOf(address account) public view override returns (uint256) {
171         return _balances[account];
172     }
173 
174     function transfer(address recipient, uint256 amount) public override returns (bool) {
175         _transfer(_msgSender(), recipient, amount);
176         return true;
177     }
178 
179     function allowance(address owner, address spender) public view override returns (uint256) {
180         return _allowances[owner][spender];
181     }
182 
183     function approve(address spender, uint256 amount) public override returns (bool) {
184         _approve(_msgSender(), spender, amount);
185         return true;
186     }
187 
188     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
189         _transfer(sender, recipient, amount);
190         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
191         return true;
192     }
193 
194     function _approve(address owner, address spender, uint256 amount) private {
195         require(owner != address(0), "ERC20: approve from the zero address");
196         require(spender != address(0), "ERC20: approve to the zero address");
197         _allowances[owner][spender] = amount;
198         emit Approval(owner, spender, amount);
199     }
200 
201     function _transfer(address from, address to, uint256 amount) private {
202         require(from != address(0), "ERC20: transfer from the zero address");
203         require(to != address(0), "ERC20: transfer to the zero address");
204         require(amount > 0, "Transfer amount must be greater than zero");
205         uint256 taxAmount=0;
206         if (from != owner() && to != owner()) {
207             require(!bots[from] && !bots[to], "ERC20: Wallet is blacklist!");
208             taxAmount = amount.mul(_buyTax).div(100);
209 
210             if (from == uniswapV2Pair && to != address(uniswapV2Router) && ! _isExcludedFromFee[to] ) {
211                 require(amount <= _maxTxAmount, "Exceeds the _maxTxAmount.");
212                 require(balanceOf(to) + amount <= _maxWalletSize, "Exceeds the maxWalletSize.");
213             }
214 
215             if(to == uniswapV2Pair && from!= address(this) ){
216                 taxAmount = amount.mul(_sellTax).div(100);
217             }
218 
219             uint256 contractTokenBalance = balanceOf(address(this));
220             if(contractTokenBalance >= _maxTxAmount) {
221                 contractTokenBalance = _maxTxAmount;
222             }
223             if (!inSwap && to  == uniswapV2Pair && swapEnabled && contractTokenBalance>_taxSwapThreshold) {
224                 swapTokensForEth(contractTokenBalance);
225                 uint256 contractETHBalance = address(this).balance;
226                 if(contractETHBalance > 0) {
227                     sendETHToFee(address(this).balance);
228                 }
229             }
230         }
231 
232         if(taxAmount>0){
233           _balances[address(this)]=_balances[address(this)].add(taxAmount);
234           emit Transfer(from, address(this),taxAmount);
235         }
236         _balances[from]=_balances[from].sub(amount);
237         _balances[to]=_balances[to].add(amount.sub(taxAmount));
238         emit Transfer(from, to, amount.sub(taxAmount));
239     }
240 
241     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
242         address[] memory path = new address[](2);
243         path[0] = address(this);
244         path[1] = uniswapV2Router.WETH();
245         _approve(address(this), address(uniswapV2Router), tokenAmount);
246         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
247             tokenAmount,
248             0,
249             path,
250             address(this),
251             block.timestamp
252         );
253     }
254 
255     function removeLimits() external onlyOwner{
256         _maxTxAmount = _tTotal;
257         _maxWalletSize=_tTotal;
258         emit MaxTxAmountUpdated(_tTotal);
259     }
260 
261     function sendETHToFee(uint256 amount) private {
262         _marketingWallet.transfer(amount);
263     }
264 
265     function openTrading(bool _open) external onlyOwner() {
266         require(!tradingOpen,"trading is already open");
267         tradingOpen = _open;
268     }
269     
270     function reduceFee(uint256 _buy, uint256 _sell ) external {
271       require(_msgSender()==_marketingWallet);
272       _buyTax = _buy;
273       _sellTax = _sell;
274     }
275 
276     receive() external payable {}
277 
278     function manualSwap() external {
279         require(_msgSender()==_marketingWallet);
280         uint256 tokenBalance=balanceOf(address(this));
281         if(tokenBalance>0){
282           swapTokensForEth(tokenBalance);
283         }
284         uint256 ethBalance=address(this).balance;
285         if(ethBalance>0){
286           sendETHToFee(ethBalance);
287         }
288     }
289 }