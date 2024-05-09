1 /**
2   Telegram: t.me/ShibariumPad
3   Website: https://ShibariumPad.finance
4   Twitter: twitter.com/ShibariumPadETH
5  */
6 
7 // SPDX-License-Identifier: Unlicensed
8 pragma solidity 0.8.18;
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
22     function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);
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
62 }
63 
64 contract Ownable is Context {
65     address private _owner;
66     address private _previousOwner;
67     event OwnershipTransferred(
68         address indexed previousOwner,
69         address indexed newOwner
70     );
71 
72     constructor() {
73         address msgSender = _msgSender();
74         _owner = msgSender;
75         emit OwnershipTransferred(address(0), msgSender);
76     }
77 
78     function owner() public view returns (address) {
79         return _owner;
80     }
81 
82     modifier onlyOwner() {
83         require(_owner == _msgSender(), "Ownable: caller is not the owner");
84         _;
85     }
86 
87     function transferOwnership(address newOwner) public onlyOwner {
88         _transferOwnership(newOwner);
89     }
90 
91     function _transferOwnership(address newOwner) internal {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 
97     function renounceOwnership() public virtual onlyOwner {
98         emit OwnershipTransferred(_owner, address(0));
99         _owner = address(0);
100     }
101 }
102 
103 interface IUniswapV2Factory {
104     function createPair(address tokenA, address tokenB)
105         external
106         returns (address pair);
107 }
108 
109 interface IUniswapV2Router02 {
110     function swapExactTokensForETHSupportingFeeOnTransferTokens(
111         uint256 amountIn,
112         uint256 amountOutMin,
113         address[] calldata path,
114         address to,
115         uint256 deadline
116     ) external;
117 
118     function factory() external pure returns (address);
119     function WETH() external pure returns (address);
120 }
121 
122 contract ShibariumPad is Context, IERC20, Ownable {
123     using SafeMath for uint256;
124     mapping(address => uint256) private _balance;
125     mapping(address => mapping(address => uint256)) private _allowances;
126     mapping(address => bool) private _isExcludedFromFeeWallet;
127     uint256 private constant MAX = ~uint256(0);
128     uint8 private constant _decimals = 18;
129     uint256 private constant _totalSupply = 10**7 * 10**_decimals;
130     uint256 private constant minSwap = 900 * 10**_decimals; //0.03% from (supply - burn 70%)
131     uint256 private constant onePercent = 30000 * 10**_decimals; //1% from (supply - burn 70%)
132     uint256 public maxTxAmount = onePercent * 2; //max Tx for first mins after launch
133 
134     uint256 private _tax;
135     uint256 public buyTax = 3;
136     uint256 public sellTax = 3;
137     
138     uint256 private launchBlock;
139     uint256 private blockDelay = 2;
140 
141     string private constant _name = "Shibarium Pad";
142     string private constant _symbol = "$SHIBP";
143 
144     IUniswapV2Router02 private uniswapV2Router;
145     address public uniswapV2Pair;
146     address payable public marketingWallet;
147 
148     bool private launch = false;
149 
150     constructor(address[] memory wallets) {
151         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
152         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
153         marketingWallet = payable(wallets[0]);
154         _balance[msg.sender] = _totalSupply;
155         for (uint256 i = 0; i < wallets.length; i++) {
156             _isExcludedFromFeeWallet[wallets[i]] = true;
157         }
158         _isExcludedFromFeeWallet[msg.sender] = true;
159         _isExcludedFromFeeWallet[address(this)] = true;
160 
161         emit Transfer(address(0), _msgSender(), _totalSupply);
162     }
163 
164     function name() public pure returns (string memory) {
165         return _name;
166     }
167 
168     function symbol() public pure returns (string memory) {
169         return _symbol;
170     }
171 
172     function decimals() public pure returns (uint8) {
173         return _decimals;
174     }
175 
176     function totalSupply() public pure override returns (uint256) {
177         return _totalSupply;
178     }
179 
180     function balanceOf(address account) public view override returns (uint256) {
181         return _balance[account];
182     }
183 
184     function transfer(address recipient, uint256 amount)public override returns (bool){
185         _transfer(_msgSender(), recipient, amount);
186         return true;
187     }
188 
189     function allowance(address owner, address spender) public view override returns (uint256){
190         return _allowances[owner][spender];
191     }
192 
193     function approve(address spender, uint256 amount) public override returns (bool){
194         _approve(_msgSender(), spender, amount);
195         return true;
196     }
197 
198     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
199         _transfer(sender, recipient, amount);
200         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance"));
201         return true;
202     }
203 
204     function _approve(address owner, address spender, uint256 amount) private {
205         require(owner != address(0), "ERC20: approve from the zero address");
206         require(spender != address(0), "ERC20: approve to the zero address");
207         _allowances[owner][spender] = amount;
208         emit Approval(owner, spender, amount);
209     }
210 
211     function enableTrading() external onlyOwner {
212         launch = true;
213         launchBlock = block.number;
214     }
215 
216     function addExcludedWallet(address wallet) external onlyOwner {
217         _isExcludedFromFeeWallet[wallet] = true;
218     }
219 
220     function removeLimits() external onlyOwner {
221         maxTxAmount = _totalSupply;
222     }
223 
224     function newBlockDelay(uint256 number) external onlyOwner {
225         blockDelay = number;
226     }
227 
228     function changeTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
229         buyTax = newBuyTax;
230         sellTax = newSellTax;
231     }
232     
233     function _tokenTransfer(address from, address to, uint256 amount) private {
234         uint256 taxTokens = (amount * _tax) / 100;
235         uint256 transferAmount = amount - taxTokens;
236 
237         _balance[from] = _balance[from] - amount;
238         _balance[to] = _balance[to] + transferAmount;
239         _balance[address(this)] = _balance[address(this)] + taxTokens;
240 
241         emit Transfer(from, to, transferAmount);
242     }
243 
244     function _transfer(address from, address to, uint256 amount) private {
245         require(from != address(0), "ERC20: transfer from the zero address");
246 
247         if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
248             _tax = 0;
249         } else {
250             require(launch, "Wait till launch");
251             require(amount <= maxTxAmount, "Max TxAmount 2% at launch");
252             if (block.number < launchBlock + blockDelay) {_tax=99;} else {
253                 if (from == uniswapV2Pair) {
254                     _tax = buyTax;
255                 } else if (to == uniswapV2Pair) {
256                     uint256 tokensToSwap = balanceOf(address(this));
257                     if (tokensToSwap > minSwap) {
258                         if (tokensToSwap > onePercent) {
259                             tokensToSwap = onePercent;
260                         }
261                         swapTokensForEth(tokensToSwap);
262                     }
263                     _tax = sellTax;
264                 } else {
265                     _tax = 0;
266                 }
267             }
268         }
269         _tokenTransfer(from, to, amount);
270     }
271 
272     function swapTokensForEth(uint256 tokenAmount) private {
273         address[] memory path = new address[](2);
274         path[0] = address(this);
275         path[1] = uniswapV2Router.WETH();
276         _approve(address(this), address(uniswapV2Router), tokenAmount);
277         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
278             tokenAmount,
279             0,
280             path,
281             marketingWallet,
282             block.timestamp
283         );
284     }
285     receive() external payable {}
286 }