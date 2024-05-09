1 // SPDX-License-Identifier: MIT
2 
3 
4 pragma solidity 0.8.19;
5 
6 interface IERC20 {
7     function totalSupply() external view returns (uint256);
8     function balanceOf(address account) external view returns (uint256);
9     function transfer(address recipient, uint256 amount) external returns (bool);
10     function allowance(address owner, address spender) external view returns (uint256);
11     function approve(address spender, uint256 amount) external returns (bool);
12     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
13     event Transfer(address indexed from, address indexed to, uint256 value);
14     event Approval(address indexed owner, address indexed spender, uint256 value);
15 }
16 
17 interface IFactory {
18     function createPair(address tokenA, address tokenB) external returns (address pair);
19     function getPair(address tokenA, address tokenB) external view returns (address pair);
20 }
21 
22 interface IRouter {
23     function factory() external pure returns (address);
24     function WETH() external pure returns (address);
25 
26     function addLiquidityETH(
27             address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline
28             ) external payable returns (
29                 uint256 amountToken, uint256 amountETH, uint256 liquidity
30                 );
31 
32     function swapExactTokensForETHSupportingFeeOnTransferTokens(
33             uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline
34             ) external;
35 }
36 
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address) { return msg.sender; }
39 }
40 
41 contract Ownable is Context {
42     address private _owner;
43     constructor () {
44         address msgSender = _msgSender();
45         _owner = msgSender;
46     }
47     function owner() public view returns (address) { return _owner; }
48     modifier onlyOwner() {
49         require(_owner == _msgSender(), "Ownable: caller is not the owner.");
50         _;
51     }
52     function renounceOwnership() external virtual onlyOwner { _owner = address(0); }
53     function transferOwnership(address newOwner) external virtual onlyOwner {
54         require(newOwner != address(0), "Ownable: new owner is the zero address.");
55         _owner = newOwner;
56     }
57 }
58 
59 contract Pede is IERC20, Ownable {
60     IRouter public uniswapV2Router;
61     address public uniswapV2Pair;
62     string private constant _name =  "Pede";
63     string private constant _symbol = "Pede";
64     uint8 private constant _decimals = 18;
65     mapping (address => uint256) private balances;
66     mapping (address => mapping (address => uint256)) private _allowances;
67     uint256 private constant _totalSupply = 420690000000000 * 10**18;               // 
68     uint256 public constant maxWalletAmount = _totalSupply * 2 / 100;         //
69     mapping (address => bool) private _isExcludedFromMaxWalletLimit;
70     mapping (address => bool) private _isExcludedFromFee;
71     mapping (address => bool) private _isWhitelisted;
72     uint8 public buyTax = 10;
73     uint8 public sellTax = 10;
74     uint8 public lpRatio = 0;
75     uint8 public marketingRatio = 7;
76     uint8 public devRatio = 6;
77     address public constant deadWallet = 0x000000000000000000000000000000000000dEaD;
78     address public constant marketingWallet = payable(0x90dd09E88272e3AF868db622eeF36a2aB6DcB93c);
79     address public constant devWallet = payable(0x90dd09E88272e3AF868db622eeF36a2aB6DcB93c);
80     bool private tradingIsOpen = false;
81 
82     constructor() {
83         IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
84         uniswapV2Router = _uniswapV2Router;
85         uniswapV2Pair = IFactory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
86         _isExcludedFromFee[owner()] = true;
87         _isExcludedFromFee[address(this)] = true;
88         _isExcludedFromFee[marketingWallet] = true;
89         _isExcludedFromFee[devWallet] = true;
90         _isExcludedFromFee[deadWallet] = true;
91         _isExcludedFromMaxWalletLimit[owner()] = true;
92         _isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
93         _isExcludedFromMaxWalletLimit[uniswapV2Pair] = true;
94         _isExcludedFromMaxWalletLimit[address(this)] = true;
95         _isExcludedFromMaxWalletLimit[marketingWallet] = true;
96         _isExcludedFromMaxWalletLimit[devWallet] = true;
97         _isExcludedFromMaxWalletLimit[deadWallet] = true;
98         _isWhitelisted[owner()] = true;
99         balances[owner()] = _totalSupply;
100         emit Transfer(address(0), owner(), _totalSupply);
101     }
102 
103     receive() external payable {} // so the contract can receive eth
104 
105     function openTrading() external onlyOwner {
106         require(!tradingIsOpen, "trading is already open");   
107         tradingIsOpen = true;
108     }
109 
110     function setFees(uint8 newBuyTax, uint8 newSellTax) external onlyOwner {
111         require(newBuyTax <= 10 && newSellTax <= 10, "fees must be <=10%");
112         require(newBuyTax != buyTax || newSellTax != sellTax, "new fees cannot be the same as old fees");
113         buyTax = newBuyTax;
114         sellTax = newSellTax;
115     }
116 
117     function addWhitelist(address newAddress) external onlyOwner {
118         require(!_isWhitelisted[newAddress], "address already added");
119         _isWhitelisted[newAddress] = true;
120     }
121 
122     function setRatios(uint8 newLpRatio, uint8 newMarketingRatio, uint8 newDevRatio) external onlyOwner {
123         require(newLpRatio + newMarketingRatio + newDevRatio == buyTax + sellTax, "ratios must add up to total tax");
124         lpRatio = newLpRatio;
125         marketingRatio = newMarketingRatio;
126         devRatio = newDevRatio;
127     }
128 
129     function excludeFromMaxWalletLimit(address account) external onlyOwner {
130         require(!_isExcludedFromMaxWalletLimit[account], "address is already excluded from max wallet");
131         _isExcludedFromMaxWalletLimit[account] = true;
132     }
133 
134     function excludeFromFees(address account) external onlyOwner {
135         require(!_isExcludedFromFee[account], "address is already excluded from fees");
136         _isExcludedFromFee[account] = true;
137     }
138 
139     function withdrawStuckETH() external onlyOwner {
140         require(address(this).balance > 0, "cannot send more than contract balance");
141         (bool success,) = address(owner()).call{value: address(this).balance}("");
142         require(success, "error withdrawing ETH from contract");
143     }
144 
145     function transfer(address recipient, uint256 amount) external override returns (bool) {
146         _transfer(msg.sender, recipient, amount);
147         return true;
148     }
149 
150     function approve(address spender, uint256 amount) external override returns (bool) {
151         _approve(msg.sender, spender, amount);
152         return true;
153     }
154 
155     function transferFrom(address sender,address recipient,uint256 amount) external override returns (bool) {
156         _transfer(sender, recipient, amount);
157         require(amount <= _allowances[sender][msg.sender], "ERC20: transfer amount exceeds allowance.");
158         _approve(sender, msg.sender, _allowances[sender][msg.sender] - amount);
159         return true;
160     }
161 
162     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool){
163         _approve(msg.sender,spender,_allowances[msg.sender][spender] + addedValue);
164         return true;
165     }
166 
167     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
168         require(subtractedValue <= _allowances[msg.sender][spender], "ERC20: decreased allownace below zero.");
169         _approve(msg.sender,spender,_allowances[msg.sender][spender] - subtractedValue);
170         return true;
171     }
172 
173     function _approve(address owner, address spender,uint256 amount) private {
174         require(owner != address(0), "ERC20: approve from the zero address");
175         require(spender != address(0), "ERC20: approve to the zero address");
176         _allowances[owner][spender] = amount;
177     }
178 
179     function name() external pure returns (string memory) { return _name; }
180     function symbol() external pure returns (string memory) { return _symbol; }
181     function decimals() external view virtual returns (uint8) { return _decimals; }
182     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
183     function balanceOf(address account) public view override returns (uint256) { return balances[account]; }
184     function allowance(address owner, address spender) external view override returns (uint256) { return _allowances[owner][spender]; }
185 
186     function _transfer(address from, address to, uint256 amount) internal {
187         require(from != address(0), "cannot transfer from the zero address");
188         require(to != address(0), "cannot transfer to the zero address");
189         require(amount > 0, "transfer amount must be greater than zero");
190         require(amount <= balanceOf(from), "cannot transfer more than balance"); 
191         require(tradingIsOpen || _isWhitelisted[to] || _isWhitelisted[from], "trading is not open yet");
192         require(_isExcludedFromMaxWalletLimit[to] || balanceOf(to) + amount <= maxWalletAmount, "cannot exceed maxWalletAmount");
193         if (_isExcludedFromFee[from] || _isExcludedFromFee[to] || (from != uniswapV2Pair && to != uniswapV2Pair)) {
194             balances[from] -= amount;
195             balances[to] += amount;
196             emit Transfer(from, to, amount);
197         } else {
198             balances[from] -= amount;
199             if (from == uniswapV2Pair) { // buy
200                 if (buyTax > 0) { 
201                     balances[address(this)] += amount * buyTax / 100;
202                     emit Transfer(from, address(this), amount * buyTax / 100);
203                 }
204                 balances[to] += amount - (amount * buyTax / 100);
205                 emit Transfer(from, to, amount - (amount * buyTax / 100));
206             } else { // sell
207                 if (sellTax > 0) {
208                     balances[address(this)] += amount * sellTax / 100;         
209                     emit Transfer(from, address(this), amount * sellTax / 100); 
210                     if (balanceOf(address(this)) > _totalSupply / 4000) { // .025% threshold for swapping
211                         uint256 tokensForLp = balanceOf(address(this)) * lpRatio / (lpRatio + marketingRatio + devRatio) / 2;
212                         _swapTokensForETH(balanceOf(address(this)) - tokensForLp);
213                         bool success = false;
214                         if (lpRatio > 0) { 
215                             _addLiquidity(tokensForLp, address(this).balance * lpRatio / (lpRatio + marketingRatio + devRatio), deadWallet); 
216                         }
217                         if (marketingRatio > 0) { 
218                             (success,) = marketingWallet.call{value: address(this).balance * marketingRatio / (marketingRatio + devRatio), gas: 30000}(""); 
219                         }
220                         if (devRatio > 0) { 
221                             (success,) = devWallet.call{value: address(this).balance, gas: 30000}(""); 
222                         }
223                     }
224                 }
225                 balances[to] += amount - (amount * sellTax / 100);
226                 emit Transfer(from, to, amount - (amount * sellTax / 100));
227             }
228         }
229     }
230 
231     function _swapTokensForETH(uint256 tokenAmount) private {
232         address[] memory path = new address[](2);
233         path[0] = address(this);
234         path[1] = uniswapV2Router.WETH();
235         _approve(address(this), address(uniswapV2Router), tokenAmount);
236         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
237     }
238 
239     function _addLiquidity(uint256 tokenAmount, uint256 ethAmount, address lpRecipient) private {
240 		_approve(address(this), address(uniswapV2Router), tokenAmount);
241         uniswapV2Router.addLiquidityETH{value: ethAmount}(address(this), tokenAmount, 0, 0, lpRecipient, block.timestamp);
242     }
243 }