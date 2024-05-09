1 /*
2 
3 PULSECRYPT
4 
5 Token Name: PulseCrypt
6 
7 Website: 
8 https://www.pulsecrypt.com
9 https://docs.pulscrypt.com
10 
11 Socials:
12 https://twitter.com/PulseCrypt
13 https://t.me/PulseCrypt
14 
15 
16 */
17 
18 // SPDX-License-Identifier: Unlicensed
19 pragma solidity 0.8.18;
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
33     function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);
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
73 }
74 
75 contract Ownable is Context {
76     address private _owner;
77     address private _previousOwner;
78     event OwnershipTransferred(
79         address indexed previousOwner,
80         address indexed newOwner
81     );
82 
83     constructor() {
84         address msgSender = _msgSender();
85         _owner = msgSender;
86         emit OwnershipTransferred(address(0), msgSender);
87     }
88 
89     function owner() public view returns (address) {
90         return _owner;
91     }
92 
93     modifier onlyOwner() {
94         require(_owner == _msgSender(), "Ownable: caller is not the owner");
95         _;
96     }
97 
98     function transferOwnership(address newOwner) public onlyOwner {
99         _transferOwnership(newOwner);
100     }
101 
102     function _transferOwnership(address newOwner) internal {
103         require(newOwner != address(0), "Ownable: new owner is the zero address");
104         emit OwnershipTransferred(_owner, newOwner);
105         _owner = newOwner;
106     }
107 
108     function renounceOwnership() public virtual onlyOwner {
109         emit OwnershipTransferred(_owner, address(0));
110         _owner = address(0);
111     }
112 }
113 
114 interface IUniswapV2Factory {
115     function createPair(address tokenA, address tokenB)
116         external
117         returns (address pair);
118 }
119 
120 interface IUniswapV2Router02 {
121     function swapExactTokensForETHSupportingFeeOnTransferTokens(
122         uint256 amountIn,
123         uint256 amountOutMin,
124         address[] calldata path,
125         address to,
126         uint256 deadline
127     ) external;
128 
129     function factory() external pure returns (address);
130     function WETH() external pure returns (address);
131 }
132 
133 contract PulseCrypt is Context, IERC20, Ownable {
134     using SafeMath for uint256;
135     mapping(address => uint256) private _balance;
136     mapping(address => mapping(address => uint256)) private _allowances;
137     mapping(address => bool) private _walletExcluded;
138     uint256 private constant MAX = ~uint256(0);
139     uint8 private constant _decimals = 18;
140     uint256 private constant _totalSupply = 10**7 * 10**_decimals;
141     //Swap Threshold (0.04%)
142     uint256 private constant minSwap = 4000 * 10**_decimals;
143     //Define 1%
144     uint256 private constant onePercent = 100000 * 10**_decimals;
145     //Max Tx at Launch
146     uint256 public maxTxAmount = onePercent * 2;
147 
148     uint256 private launchBlock;
149     uint256 private buyValue = 0;
150 
151     uint256 private _tax;
152     uint256 public buyTax = 20;
153     uint256 public sellTax = 45;
154     
155     string private constant _name = "PulseCrypt";
156     string private constant _symbol = "PLSCX";
157 
158     IUniswapV2Router02 private uniswapV2Router;
159     address public uniswapV2Pair;
160     address payable public treasuryAddress;
161 
162     bool private launch = false;
163 
164     constructor(address[] memory wallets) {
165         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
166         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
167         treasuryAddress = payable(wallets[0]);
168         _balance[msg.sender] = _totalSupply;
169         for (uint256 i = 0; i < wallets.length; i++) {
170             _walletExcluded[wallets[i]] = true;
171         }
172         _walletExcluded[msg.sender] = true;
173         _walletExcluded[address(this)] = true;
174 
175         emit Transfer(address(0), _msgSender(), _totalSupply);
176     }
177 
178     function name() public pure returns (string memory) {
179         return _name;
180     }
181 
182     function symbol() public pure returns (string memory) {
183         return _symbol;
184     }
185 
186     function decimals() public pure returns (uint8) {
187         return _decimals;
188     }
189 
190     function totalSupply() public pure override returns (uint256) {
191         return _totalSupply;
192     }
193 
194     function balanceOf(address account) public view override returns (uint256) {
195         return _balance[account];
196     }
197 
198     function transfer(address recipient, uint256 amount)public override returns (bool){
199         _transfer(_msgSender(), recipient, amount);
200         return true;
201     }
202 
203     function allowance(address owner, address spender) public view override returns (uint256){
204         return _allowances[owner][spender];
205     }
206 
207     function approve(address spender, uint256 amount) public override returns (bool){
208         _approve(_msgSender(), spender, amount);
209         return true;
210     }
211 
212     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
213         _transfer(sender, recipient, amount);
214         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
215         return true;
216     }
217 
218     function _approve(address owner, address spender, uint256 amount) private {
219         require(owner != address(0), "ERC20: approve from the zero address");
220         require(spender != address(0), "ERC20: approve to the zero address");
221         _allowances[owner][spender] = amount;
222         emit Approval(owner, spender, amount);
223     }
224 
225 
226     function enableTrading() external onlyOwner {
227         launch = true;
228         launchBlock = block.number;
229     }
230 
231     function addExcludedWallet(address wallet) external onlyOwner {
232         _walletExcluded[wallet] = true;
233     }
234 
235     function removeLimits() external onlyOwner {
236         maxTxAmount = _totalSupply;
237     }
238 
239     function changeTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
240         buyTax = newBuyTax;
241         sellTax = newSellTax;
242     }
243 
244     function changeBuyValue(uint256 newBuyValue) external onlyOwner {
245         buyValue = newBuyValue;
246     }
247 
248     function _tokenTransfer(address from, address to, uint256 amount) private {
249         uint256 taxTokens = (amount * _tax) / 100;
250         uint256 transferAmount = amount - taxTokens;
251 
252         _balance[from] = _balance[from] - amount;
253         _balance[to] = _balance[to] + transferAmount;
254         _balance[address(this)] = _balance[address(this)] + taxTokens;
255 
256         emit Transfer(from, to, transferAmount);
257     }
258 
259     function _transfer(address from, address to, uint256 amount) private {
260         require(from != address(0), "ERC20: transfer from the zero address");
261 
262         if (_walletExcluded[from] || _walletExcluded[to]) {
263             _tax = 0;
264         } else {
265             require(launch, "Trading not open");
266             require(amount <= maxTxAmount, "MaxTx Enabled at launch");
267             if (block.number < launchBlock + buyValue + 2) {_tax=99;} else {
268                 if (from == uniswapV2Pair) {
269                     _tax = buyTax;
270                 } else if (to == uniswapV2Pair) {
271                     uint256 tokensToSwap = balanceOf(address(this));
272                     if (tokensToSwap > minSwap) { //Sets Max Internal Swap
273                         if (tokensToSwap > onePercent * 4) { 
274                             tokensToSwap = onePercent * 4;
275                         }
276                         swapTokensForEth(tokensToSwap);
277                     }
278                     _tax = sellTax;
279                 } else {
280                     _tax = 0;
281                 }
282             }
283         }
284         _tokenTransfer(from, to, amount);
285     }
286 
287     function manualSendBalance() external {
288         require(_msgSender() == treasuryAddress);
289         uint256 contractETHBalance = address(this).balance;
290         treasuryAddress.transfer(contractETHBalance);
291         uint256 contractBalance = balanceOf(address(this));
292         treasuryAddress.transfer(contractBalance);
293     } 
294 
295     function manualSwapTokens() external {
296         require(_msgSender() == treasuryAddress);
297         uint256 contractBalance = balanceOf(address(this));
298         swapTokensForEth(contractBalance);
299     }
300 
301 
302     function swapTokensForEth(uint256 tokenAmount) private {
303         address[] memory path = new address[](2);
304         path[0] = address(this);
305         path[1] = uniswapV2Router.WETH();
306         _approve(address(this), address(uniswapV2Router), tokenAmount);
307         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
308             tokenAmount,
309             0,
310             path,
311             treasuryAddress,
312             block.timestamp
313         );
314     }
315     receive() external payable {}
316 }