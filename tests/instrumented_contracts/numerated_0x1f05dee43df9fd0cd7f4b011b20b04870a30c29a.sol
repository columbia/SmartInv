1 /**
2   Telegram: https://t.me/ShibWalletERC
3   Website: http://www.shibwallet.app
4   Twitter: https://twitter.com/ShibWalletERC
5   WhitePaper: https://shibwallet.gitbook.io/shibwallet
6  */
7 
8 // SPDX-License-Identifier: Unlicensed
9 pragma solidity 0.8.18;
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address) {
13         return msg.sender;
14     }
15 }
16 
17 interface IERC20 {
18     function totalSupply() external view returns (uint256);
19     function balanceOf(address account) external view returns (uint256);
20     function transfer(address recipient, uint256 amount) external returns (bool);
21     function allowance(address owner, address spender) external view returns (uint256);
22     function approve(address spender, uint256 amount) external returns (bool);
23     function transferFrom( address sender, address recipient, uint256 amount) external returns (bool);
24     event Transfer(address indexed from, address indexed to, uint256 value);
25     event Approval(address indexed owner, address indexed spender, uint256 value);
26 }
27 
28 contract Ownable is Context {
29     address private _owner;
30     address private _previousOwner;
31     event OwnershipTransferred(
32         address indexed previousOwner,
33         address indexed newOwner
34     );
35 
36     constructor() {
37         address msgSender = _msgSender();
38         _owner = msgSender;
39         emit OwnershipTransferred(address(0), msgSender);
40     }
41 
42     function owner() public view returns (address) {
43         return _owner;
44     }
45 
46     modifier onlyOwner() {
47         require(_owner == _msgSender(), "Ownable: caller is not the owner");
48         _;
49     }
50 
51     function transferOwnership(address newOwner) public onlyOwner {
52         _transferOwnership(newOwner);
53     }
54 
55     function _transferOwnership(address newOwner) internal {
56         require(newOwner != address(0), "Ownable: new owner is the zero address");
57         emit OwnershipTransferred(_owner, newOwner);
58         _owner = newOwner;
59     }
60 
61     function renounceOwnership() public virtual onlyOwner {
62         emit OwnershipTransferred(_owner, address(0));
63         _owner = address(0);
64     }
65 }
66 
67 interface IUniswapV2Factory {
68     function createPair(address tokenA, address tokenB)
69         external
70         returns (address pair);
71 }
72 
73 interface IUniswapV2Router02 {
74     function swapExactTokensForETHSupportingFeeOnTransferTokens(
75         uint256 amountIn,
76         uint256 amountOutMin,
77         address[] calldata path,
78         address to,
79         uint256 deadline
80     ) external;
81 
82     function factory() external pure returns (address);
83     function WETH() external pure returns (address);
84 }
85 
86 contract ShibWallet is Context, IERC20, Ownable {
87     mapping(address => uint256) private _balance;
88     mapping(address => mapping(address => uint256)) private _allowances;
89     mapping(address => bool) private _isExcludedFromFeeWallet;
90     uint256 private constant MAX = ~uint256(0);
91     uint8 private constant _decimals = 18;
92     uint256 private constant _totalSupply = 10**7 * 10**_decimals;
93     uint256 private constant minSwap = 3000 * 10**_decimals; //0.03% from supply
94     uint256 private constant maxSwap = 50000 * 10**_decimals; //0.5% from supply
95     uint256 public maxTxAmount = maxSwap * 2; //max Tx for first mins after launch
96 
97     uint256 private _tax;
98     uint256 public buyTax = 4;
99     uint256 public sellTax = 4;
100     
101     uint256 private launchBlock;
102     uint256 private blockDelay = 2;
103 
104     string private constant _name = "ShibWallet";
105     string private constant _symbol = "SWT";
106 
107     IUniswapV2Router02 private uniswapV2Router;
108     address public uniswapV2Pair;
109     address payable public marketingWallet;
110 
111     bool private launch = false;
112 
113     constructor() {
114         uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
115         uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
116         marketingWallet = payable(0xab6d56d688e6727c20B25BB1f6D52acd3627b72D);
117         _balance[msg.sender] = _totalSupply;
118 
119         _isExcludedFromFeeWallet[msg.sender] = true;
120         _isExcludedFromFeeWallet[0xab6d56d688e6727c20B25BB1f6D52acd3627b72D] = true;
121         _isExcludedFromFeeWallet[address(this)] = true;
122 
123         emit Transfer(address(0), _msgSender(), _totalSupply);
124     }
125 
126     function name() public pure returns (string memory) {
127         return _name;
128     }
129 
130     function symbol() public pure returns (string memory) {
131         return _symbol;
132     }
133 
134     function decimals() public pure returns (uint8) {
135         return _decimals;
136     }
137 
138     function totalSupply() public pure override returns (uint256) {
139         return _totalSupply;
140     }
141 
142     function balanceOf(address account) public view override returns (uint256) {
143         return _balance[account];
144     }
145 
146     function transfer(address recipient, uint256 amount)public override returns (bool){
147         _transfer(_msgSender(), recipient, amount);
148         return true;
149     }
150 
151     function allowance(address owner, address spender) public view override returns (uint256){
152         return _allowances[owner][spender];
153     }
154 
155     function approve(address spender, uint256 amount) public override returns (bool){
156         _approve(_msgSender(), spender, amount);
157         return true;
158     }
159 
160     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
161         _transfer(sender, recipient, amount);
162         _approve(sender,_msgSender(),_allowances[sender][_msgSender()] - amount);
163         return true;
164     }
165 
166     function _approve(address owner, address spender, uint256 amount) private {
167         require(owner != address(0), "ERC20: approve from the zero address");
168         require(spender != address(0), "ERC20: approve to the zero address");
169         _allowances[owner][spender] = amount;
170         emit Approval(owner, spender, amount);
171     }
172 
173     function enableTrading() external onlyOwner {
174         launch = true;
175         launchBlock = block.number;
176     }
177 
178     function addExcludedWallet(address wallet) external onlyOwner {
179         _isExcludedFromFeeWallet[wallet] = true;
180     }
181 
182     function removeLimits() external onlyOwner {
183         maxTxAmount = _totalSupply;
184     }
185 
186     function newBlockDelay(uint256 number) external onlyOwner {
187         blockDelay = number;
188     }
189 
190     function changeTax(uint256 newBuyTax, uint256 newSellTax) external onlyOwner {
191         require(newBuyTax <= 10 && newSellTax <= 10, "ERC20: wrong tax value!");
192         buyTax = newBuyTax;
193         sellTax = newSellTax;
194     }
195     
196       function setMarketingWallet(address _marketingWallet) external onlyOwner {
197         marketingWallet = payable(_marketingWallet);
198     }
199     
200     function _tokenTransfer(address from, address to, uint256 amount) private {
201         uint256 taxTokens = (amount * _tax) / 100;
202         uint256 transferAmount = amount - taxTokens;
203 
204         _balance[from] = _balance[from] - amount;
205         _balance[to] = _balance[to] + transferAmount;
206         _balance[address(this)] = _balance[address(this)] + taxTokens;
207 
208         emit Transfer(from, to, transferAmount);
209     }
210 
211     function _transfer(address from, address to, uint256 amount) private {
212         require(from != address(0), "ERC20: transfer from the zero address");
213 
214         if (_isExcludedFromFeeWallet[from] || _isExcludedFromFeeWallet[to]) {
215             _tax = 0;
216         } else {
217             require(launch, "Wait till launch");
218             require(amount <= maxTxAmount, "Max TxAmount 2% at launch");
219             if (block.number < launchBlock + blockDelay) {_tax=99;} else {
220                 if (from == uniswapV2Pair) {
221                     _tax = buyTax;
222                 } else if (to == uniswapV2Pair) {
223                     uint256 tokensToSwap = balanceOf(address(this));
224                     if (tokensToSwap > minSwap) {
225                         if (tokensToSwap > maxSwap) {
226                             tokensToSwap = maxSwap;
227                         }
228                         swapTokensForEth(tokensToSwap);
229                     }
230                     _tax = sellTax;
231                 } else {
232                     _tax = 0;
233                 }
234             }
235         }
236         _tokenTransfer(from, to, amount);
237     }
238 
239     function swapTokensForEth(uint256 tokenAmount) private {
240         address[] memory path = new address[](2);
241         path[0] = address(this);
242         path[1] = uniswapV2Router.WETH();
243         _approve(address(this), address(uniswapV2Router), tokenAmount);
244         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
245             tokenAmount,
246             0,
247             path,
248             marketingWallet,
249             block.timestamp
250         );
251     }
252     receive() external payable {}
253 }