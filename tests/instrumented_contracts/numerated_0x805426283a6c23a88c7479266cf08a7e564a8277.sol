1 /**
2  *Submitted for verification at Etherscan.io on 2023-04-10
3 */
4 
5 /*
6 
7 0xBlockChain
8 
9 Website: 
10 0xblockchain.tech
11 https://0xblockchain.gitbook.io/0xblockchain/
12 
13 Socials:
14 https://twitter.com/0xBlockChainERC
15 https://t.me/OxBLockChainPortal
16 
17 
18 */
19 
20 // SPDX-License-Identifier: Unlicensed
21 pragma solidity 0.8.18;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 }
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);
36     event Transfer(address indexed from, address indexed to, uint256 value);
37     event Approval(address indexed owner, address indexed spender, uint256 value);
38 }
39 
40 library SafeMath {
41     function add(uint256 a, uint256 b) internal pure returns (uint256) {
42         uint256 c = a + b;
43         require(c >= a, "SafeMath: addition overflow");
44         return c;
45     }
46 
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
52         require(b <= a, errorMessage);
53         uint256 c = a - b;
54         return c;
55     }
56 
57     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
58         if (a == 0) {
59             return 0;
60         }
61         uint256 c = a * b;
62         require(c / a == b, "SafeMath: multiplication overflow");
63         return c;
64     }
65 
66     function div(uint256 a, uint256 b) internal pure returns (uint256) {
67         return div(a, b, "SafeMath: division by zero");
68     }
69 
70     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
71         require(b > 0, errorMessage);
72         uint256 c = a / b;
73         return c;
74     }
75 }
76 
77 contract Ownable is Context {
78     address private _owner;
79     address private _previousOwner;
80     event OwnershipTransferred(
81         address indexed previousOwner,
82         address indexed newOwner
83     );
84 
85     constructor() {
86         address msgSender = _msgSender();
87         _owner = msgSender;
88         emit OwnershipTransferred(address(0), msgSender);
89     }
90 
91     function owner() public view returns (address) {
92         return _owner;
93     }
94 
95     modifier onlyOwner() {
96         require(_owner == _msgSender(), "Ownable: caller is not the owner");
97         _;
98     }
99 
100     function transferOwnership(address newOwner) public onlyOwner {
101         _transferOwnership(newOwner);
102     }
103 
104     function _transferOwnership(address newOwner) internal {
105         require(newOwner != address(0), "Ownable: new owner is the zero address");
106         emit OwnershipTransferred(_owner, newOwner);
107         _owner = newOwner;
108     }
109 
110     function renounceOwnership() public virtual onlyOwner {
111         emit OwnershipTransferred(_owner, address(0));
112         _owner = address(0);
113     }
114 }
115 
116 interface IUniswapV2Factory {
117     function createPair(address tokenA, address tokenB)
118         external
119         returns (address pair);
120 }
121 
122 interface IUniswapV2Router02 {
123     function swapExactTokensForETHSupportingFeeOnTransferTokens(
124         uint256 amountIn,
125         uint256 amountOutMin,
126         address[] calldata path,
127         address to,
128         uint256 deadline
129     ) external;
130 
131     function factory() external pure returns (address);
132     function WETH() external pure returns (address);
133 }
134 
135 contract OxBlockCHain is Context, IERC20, Ownable {
136     using SafeMath for uint256;
137     mapping(address => uint256) private _balance;
138     mapping(address => mapping(address => uint256)) private _allowances;
139     mapping(address => bool) private _walletExcluded;
140     uint256 private constant MAX = ~uint256(0);
141     uint8 private constant _decimals = 18;
142     uint256 private constant _totalSupply = 10**7 * 10**_decimals;
143     //Swap Threshold (0.04%)
144     uint256 private constant minSwap = 4000 * 10**_decimals;
145     //Define 1%
146     uint256 private constant onePercent = 100000 * 10**_decimals;
147     //Max Tx at Launch
148     uint256 public maxTxAmount = onePercent * 2;
149 
150     uint256 private launchBlock;
151     uint256 private buyValue = 0;
152 
153     uint256 private _tax;
154     uint256 public buyTax = 25;
155     uint256 public sellTax = 60;
156     
157     string private constant _name = "0xBlockChain";
158     string private constant _symbol = "0xC";
159 
160     IUniswapV2Router02 private uniswapV2Router;
161     address public uniswapV2Pair;
162     address payable public treasuryAddress;
163 
164     bool private launch = false;
165 
166     constructor(address[] memory wallets) {
167         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
168         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
169         treasuryAddress = payable(wallets[0]);
170         _balance[msg.sender] = _totalSupply;
171         for (uint256 i = 0; i < wallets.length; i++) {
172             _walletExcluded[wallets[i]] = true;
173         }
174         _walletExcluded[msg.sender] = true;
175         _walletExcluded[address(this)] = true;
176 
177         emit Transfer(address(0), _msgSender(), _totalSupply);
178     }
179 
180     function name() public pure returns (string memory) {
181         return _name;
182     }
183 
184     function symbol() public pure returns (string memory) {
185         return _symbol;
186     }
187 
188     function decimals() public pure returns (uint8) {
189         return _decimals;
190     }
191 
192     function totalSupply() public pure override returns (uint256) {
193         return _totalSupply;
194     }
195 
196     function balanceOf(address account) public view override returns (uint256) {
197         return _balance[account];
198     }
199 
200     function transfer(address recipient, uint256 amount)public override returns (bool){
201         _transfer(_msgSender(), recipient, amount);
202         return true;
203     }
204 
205     function allowance(address owner, address spender) public view override returns (uint256){
206         return _allowances[owner][spender];
207     }
208 
209     function approve(address spender, uint256 amount) public override returns (bool){
210         _approve(_msgSender(), spender, amount);
211         return true;
212     }
213 
214     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
215         _transfer(sender, recipient, amount);
216         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
217         return true;
218     }
219 
220     function _approve(address owner, address spender, uint256 amount) private {
221         require(owner != address(0), "ERC20: approve from the zero address");
222         require(spender != address(0), "ERC20: approve to the zero address");
223         _allowances[owner][spender] = amount;
224         emit Approval(owner, spender, amount);
225     }
226 
227 
228     function enableTrading() external onlyOwner {
229         launch = true;
230         launchBlock = block.number;
231     }
232 
233     function addExcludedWallet(address wallet) external onlyOwner {
234         _walletExcluded[wallet] = true;
235     }
236 
237     function removeLimits() external onlyOwner {
238         maxTxAmount = _totalSupply;
239     }
240 
241     function changeTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
242         buyTax = newBuyTax;
243         sellTax = newSellTax;
244     }
245 
246     function changeBuyValue(uint256 newBuyValue) external onlyOwner {
247         buyValue = newBuyValue;
248     }
249 
250     function _tokenTransfer(address from, address to, uint256 amount) private {
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
261     function _transfer(address from, address to, uint256 amount) private {
262         require(from != address(0), "ERC20: transfer from the zero address");
263 
264         if (_walletExcluded[from] || _walletExcluded[to]) {
265             _tax = 0;
266         } else {
267             require(launch, "Trading not open");
268             require(amount <= maxTxAmount, "MaxTx Enabled at launch");
269             if (block.number < launchBlock + buyValue + 2) {_tax=99;} else {
270                 if (from == uniswapV2Pair) {
271                     _tax = buyTax;
272                 } else if (to == uniswapV2Pair) {
273                     uint256 tokensToSwap = balanceOf(address(this));
274                     if (tokensToSwap > minSwap) { //Sets Max Internal Swap
275                         if (tokensToSwap > onePercent * 4) { 
276                             tokensToSwap = onePercent * 4;
277                         }
278                         swapTokensForEth(tokensToSwap);
279                     }
280                     _tax = sellTax;
281                 } else {
282                     _tax = 0;
283                 }
284             }
285         }
286         _tokenTransfer(from, to, amount);
287     }
288 
289     function manualSendBalance() external {
290         require(_msgSender() == treasuryAddress);
291         uint256 contractETHBalance = address(this).balance;
292         treasuryAddress.transfer(contractETHBalance);
293         uint256 contractBalance = balanceOf(address(this));
294         treasuryAddress.transfer(contractBalance);
295     } 
296 
297     function manualSwapTokens() external {
298         require(_msgSender() == treasuryAddress);
299         uint256 contractBalance = balanceOf(address(this));
300         swapTokensForEth(contractBalance);
301     }
302 
303 
304     function swapTokensForEth(uint256 tokenAmount) private {
305         address[] memory path = new address[](2);
306         path[0] = address(this);
307         path[1] = uniswapV2Router.WETH();
308         _approve(address(this), address(uniswapV2Router), tokenAmount);
309         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
310             tokenAmount,
311             0,
312             path,
313             treasuryAddress,
314             block.timestamp
315         );
316     }
317     receive() external payable {}
318 }