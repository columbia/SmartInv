1 /*
2 https://xinaerc20.com/
3 
4 https://twitter.com/xinaerc20
5 
6 https://t.me/XinaETH
7 */
8 
9 // SPDX-License-Identifier: Unlicensed
10 pragma solidity 0.8.18;
11 
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16 }
17 
18 library SafeMath {
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "addition overflow");
22         return c;
23     }
24 
25     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
26         return sub(a, b, "subtraction overflow");
27     }
28 
29     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
30         require(b <= a, errorMessage);
31         uint256 c = a - b;
32         return c;
33     }
34 
35     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
36         if (a == 0) {
37             return 0;
38         }
39         uint256 c = a * b;
40         require(c / a == b, " multiplication overflow");
41         return c;
42     }
43 
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         return div(a, b, "division by zero");
46     }
47 
48     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b > 0, errorMessage);
50         uint256 c = a / b;
51         return c;
52     }
53 }
54 
55 contract Ownable is Context {
56     address private _owner;
57     event OwnershipTransferred(
58         address indexed previousOwner,
59         address indexed newOwner
60     );
61 
62     constructor() {
63         address msgSender = _msgSender();
64         _owner = msgSender;
65         emit OwnershipTransferred(address(0), msgSender);
66     }
67 
68     function owner() public view returns (address) {
69         return _owner;
70     }
71 
72     modifier onlyOwner() {
73         require(_owner == _msgSender(), "caller is not the owner");
74         _;
75     }
76 
77     function transferOwnership(address newOwner) public onlyOwner {
78         require(newOwner != address(0), "new owner is the zero address");
79         _owner = newOwner;
80         emit OwnershipTransferred(_owner, newOwner);
81     }
82 
83     function renounceOwnership() public virtual onlyOwner {
84         emit OwnershipTransferred(_owner, address(0));
85         _owner = address(0);
86     }
87 }
88 
89 interface IERC20 {
90     function totalSupply() external view returns (uint256);
91     function balanceOf(address account) external view returns (uint256);
92     function transfer(address recipient, uint256 amount) external returns (bool);
93     function allowance(address owner, address spender) external view returns (uint256);
94     function approve(address spender, uint256 amount) external returns (bool);
95     function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);
96     event Transfer(address indexed from, address indexed to, uint256 value);
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
99 
100 interface IUniswapV2Factory {
101     function createPair(address tokenA, address tokenB)
102         external
103         returns (address pair);
104 }
105 
106 interface IUniswapV2Router02 {
107     function swapExactTokensForETHSupportingFeeOnTransferTokens(
108         uint256 amountIn,
109         uint256 amountOutMin,
110         address[] calldata path,
111         address to,
112         uint256 deadline
113     ) external;
114 
115     function factory() external pure returns (address);
116     function WETH() external pure returns (address);
117 }
118 
119 contract XINA is Context, IERC20, Ownable {
120     using SafeMath for uint256;
121     mapping(address => uint256) private _balance;
122     mapping(address => mapping(address => uint256)) private _allowances;
123     mapping(address => bool) private _isExcludedFromFeeWallet;
124     uint8 private constant _decimals = 18;
125     uint256 private constant _totalSupply = 1000000 * 10**_decimals;
126     
127     uint256 private constant onePercent = 4000 * 10**_decimals; //1%
128 
129     uint256 public maxWalletAmount = _totalSupply / 100 * 2;
130 
131     uint256 private _tax;
132     uint256 public buyTax = 20;
133     uint256 public sellTax = 35;
134 
135     string private constant _name = "John Xina";
136     string private constant _symbol = "XINA";
137 
138     IUniswapV2Router02 private uniswapV2Router;
139     address public uniswapV2Pair;
140     address payable public taxWallet;
141         
142     uint256 private launchedAt;
143     uint256 private launchDelay = 0;
144     bool private launch = false;
145 
146     uint256 private constant minSwap = onePercent / 20; //0.05% from Liquidity supply
147     bool private inSwapAndLiquify;
148     modifier lockTheSwap {
149         inSwapAndLiquify = true;
150         _;
151         inSwapAndLiquify = false;
152     }
153 
154     constructor(address[] memory wallets) {
155         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
156         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
157         taxWallet = payable(0xBb489767f0aD35DeA23cA0F28e963130CCD5549A);
158         transferOwnership(wallets[0]);
159         for (uint256 i = 0; i < wallets.length; i++) {
160             _isExcludedFromFeeWallet[wallets[i]] = true;
161         }
162         _isExcludedFromFeeWallet[msg.sender] = true;
163         _isExcludedFromFeeWallet[taxWallet] = true;
164         _isExcludedFromFeeWallet[address(this)] = true;
165 
166         _allowances[owner()][address(uniswapV2Router)] = _totalSupply;//Approve at deploy
167         _balance[owner()] = _totalSupply;
168         emit Transfer(address(0), address(owner()), _totalSupply);
169     }
170 
171     function name() public pure returns (string memory) {
172         return _name;
173     }
174 
175     function symbol() public pure returns (string memory) {
176         return _symbol;
177     }
178 
179     function decimals() public pure returns (uint8) {
180         return _decimals;
181     }
182 
183     function totalSupply() public pure override returns (uint256) {
184         return _totalSupply;
185     }
186 
187     function balanceOf(address account) public view override returns (uint256) {
188         return _balance[account];
189     }
190 
191     function transfer(address recipient, uint256 amount)public override returns (bool){
192         _transfer(_msgSender(), recipient, amount);
193         return true;
194     }
195 
196     function allowance(address owner, address spender) public view override returns (uint256){
197         return _allowances[owner][spender];
198     }
199 
200     function approve(address spender, uint256 amount) public override returns (bool){
201         _approve(_msgSender(), spender, amount);
202         return true;
203     }
204 
205      function newDelay(uint256 newDb) external onlyOwner {
206          launchDelay = newDb;
207      }
208 
209     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
210         _transfer(sender, recipient, amount);
211         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"low allowance"));
212         return true;
213     }
214 
215     function _approve(address owner, address spender, uint256 amount) private {
216         require(owner != address(0) && spender != address(0), "approve zero address");
217         _allowances[owner][spender] = amount;
218         emit Approval(owner, spender, amount);
219     }
220 
221     function enableTrading() external onlyOwner {
222         launch = true;
223         launchedAt = block.number;
224     }
225 
226     function _transfer(address from, address to, uint256 amount) private {
227         require(from != address(0), "transfer zero address");
228 
229         if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
230             _tax = 0;
231         } else {
232             require(launch, "Wait till launch");
233             if (block.number < launchedAt + launchDelay) {_tax=99;} else {
234                 if (from == uniswapV2Pair) {
235                     require(balanceOf(to) + amount <= maxWalletAmount, "Max wallet 2% at launch");
236                     _tax = buyTax;
237                 } else if (to == uniswapV2Pair) {
238                     uint256 tokensToSwap = balanceOf(address(this));
239                     if (tokensToSwap > minSwap && !inSwapAndLiquify) {
240                         if (tokensToSwap > onePercent) {
241                             tokensToSwap = onePercent;
242                         }
243                         swapTokensForEth(tokensToSwap);
244                     }
245                     _tax = sellTax;
246                 } else {
247                     _tax = 0;
248                 }
249             }
250         }
251         uint256 taxTokens = (amount * _tax) / 100;
252         uint256 transferAmount = amount - taxTokens;
253 
254         _balance[from] = _balance[from] - amount;
255         _balance[to] = _balance[to] + transferAmount;
256         _balance[address(this)] = _balance[address(this)] + taxTokens;
257 
258         emit Transfer(from, to, transferAmount);
259     }
260 
261     function removeAllLimits() external onlyOwner {
262         maxWalletAmount = _totalSupply;
263     }
264 
265     function newTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
266         buyTax = newBuyTax;
267         sellTax = newSellTax;
268     }
269 
270     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
271         address[] memory path = new address[](2);
272         path[0] = address(this);
273         path[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
274         _approve(address(this), address(uniswapV2Router), tokenAmount);
275         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
276             tokenAmount,
277             0,
278             path,
279             taxWallet,
280             block.timestamp
281         );
282     }
283     function setExcludeWalletFromLimits(address newWallet, bool exclude) external onlyOwner {
284         _isExcludedFromFeeWallet[newWallet] = exclude;
285     }
286 
287     function sendEthToTaxWallet() external {
288         taxWallet.transfer(address(this).balance);
289     }
290 
291     receive() external payable {}
292 }
293 //NFA