1 // SPDX-License-Identifier: MIT
2 // https://twitter.com/BabyPepe_er20
3 
4 pragma solidity ^0.8.0;
5 
6 library SafeMath {
7     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) { unchecked { uint256 c = a + b; if (c < a) return (false, 0); return (true, c); } }
8     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) { unchecked { if (b > a) return (false, 0); return (true, a - b); } }
9     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) { unchecked { if (a == 0) return (true, 0); uint256 c = a * b; if (c / a != b) return (false, 0); return (true, c); } }
10     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) { unchecked { if (b == 0) return (false, 0); return (true, a / b); } }
11     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) { unchecked { if (b == 0) return (false, 0); return (true, a % b); } }
12     function add(uint256 a, uint256 b) internal pure returns (uint256) { return a + b; }
13     function sub(uint256 a, uint256 b) internal pure returns (uint256) { return a - b; }
14     function mul(uint256 a, uint256 b) internal pure returns (uint256) { return a * b; }
15     function div(uint256 a, uint256 b) internal pure returns (uint256) { return a / b; }
16     function mod(uint256 a, uint256 b) internal pure returns (uint256) { return a % b; }
17     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) { unchecked { require(b <= a, errorMessage); return a - b; } }
18     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) { unchecked { require(b > 0, errorMessage); return a / b; } }
19     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) { unchecked { require(b > 0, errorMessage); return a % b; } }
20 }
21 
22 interface IERC20 {
23     event Transfer(address indexed from, address indexed to, uint256 value);
24     event Approval(address indexed owner, address indexed spender, uint256 value);
25     function name() external view returns (string memory);
26     function symbol() external view returns (string memory);
27     function decimals() external view returns (uint8);
28     function totalSupply() external view returns (uint256);
29     function balanceOf(address account) external view returns (uint256);
30     function transfer(address to, uint256 amount) external returns (bool);
31     function allowance(address owner, address spender) external view returns (uint256);
32     function approve(address spender, uint256 amount) external returns (bool);
33     function transferFrom(address from, address to, uint256 amount) external returns (bool);
34 }
35 
36 interface IFactory {
37     function createPair(address tokenA, address tokenB) external returns (address pair);
38 }
39 
40 interface IRouter {
41     function factory() external view returns (address);
42     function WETH() external view returns (address);
43     function swapExactTokensForETH(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
44     function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] calldata path, address to, uint256 deadline) external;
45 }
46 
47 abstract contract Context {
48     function _msgSender() internal view virtual returns (address) { return msg.sender; }
49     function _msgData() internal view virtual returns (bytes calldata) { return msg.data; }
50 }
51 
52 abstract contract Ownable is Context {
53     address private _owner;
54     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
55     constructor() { _transferOwnership(_msgSender()); }
56     modifier onlyOwner() { _checkOwner(); _; }
57     function owner() public view virtual returns (address) { return _owner; }
58     function _checkOwner() internal view virtual { require(owner() == _msgSender(), "Ownable: caller is not the owner"); }
59     function renounceOwnership() public virtual onlyOwner { _transferOwnership(address(0)); }
60     function transferOwnership(address newOwner) public virtual onlyOwner { require(newOwner != address(0), "Ownable: new owner is the zero address"); _transferOwnership(newOwner); }
61     function _transferOwnership(address newOwner) internal virtual { address oldOwner = _owner; _owner = newOwner; emit OwnershipTransferred(oldOwner, newOwner); }
62 }
63 
64 abstract contract ERC20 is Context, IERC20 {
65     mapping(address => uint256) private _balances;
66     mapping(address => mapping(address => uint256)) private _allowances;
67     uint256 private _totalSupply;
68     uint8 private _decimals;
69     string private _name;
70     string private _symbol;
71 
72     constructor(string memory name_, string memory symbol_, uint8 decimals_) { _name = name_; _symbol = symbol_; _decimals = decimals_; }
73     function name() public view virtual override returns (string memory) { return _name; }
74     function symbol() public view virtual override returns (string memory) { return _symbol; }
75     function decimals() public view virtual override returns (uint8) { return _decimals; }
76     function totalSupply() public view virtual override returns (uint256) { return _totalSupply; }
77     function balanceOf(address account) public view virtual override returns (uint256) { return _balances[account]; }
78     function transfer(address to, uint256 amount) public virtual override returns (bool) { address owner = _msgSender(); _transfer(owner, to, amount); return true; }
79     function allowance(address owner, address spender) public view virtual override returns (uint256) { return _allowances[owner][spender]; }
80     function approve(address spender, uint256 amount) public virtual override returns (bool) { address owner = _msgSender(); _approve(owner, spender, amount); return true; }
81     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) { address spender = _msgSender(); _spendAllowance(from, spender, amount); _transfer(from, to, amount); return true; }
82     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) { address owner = _msgSender(); _approve(owner, spender, allowance(owner, spender) + addedValue); return true; }
83     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
84         address owner = _msgSender();
85         uint256 currentAllowance = allowance(owner, spender);
86         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
87         unchecked { _approve(owner, spender, currentAllowance - subtractedValue); }
88         return true;
89     }
90     function _transfer(address from, address to, uint256 amount) internal virtual {
91         require(from != address(0), "ERC20: transfer from the zero address");
92         require(to != address(0), "ERC20: transfer to the zero address");
93         _beforeTokenTransfer(from, to, amount);
94         uint256 fromBalance = _balances[from];
95         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
96         unchecked { _balances[from] = fromBalance - amount; _balances[to] += amount; }
97         emit Transfer(from, to, amount);
98         _afterTokenTransfer(from, to, amount);
99     }
100     function _mint(address account, uint256 amount) internal virtual {
101         require(account != address(0), "ERC20: mint to the zero address");
102         _beforeTokenTransfer(address(0), account, amount);
103         _totalSupply += amount;
104         unchecked { _balances[account] += amount; }
105         emit Transfer(address(0), account, amount);
106         _afterTokenTransfer(address(0), account, amount);
107     }
108     function _burn(address account, uint256 amount) internal virtual {
109         require(account != address(0), "ERC20: burn from the zero address");
110         _beforeTokenTransfer(account, address(0), amount);
111         uint256 accountBalance = _balances[account];
112         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
113         unchecked { _balances[account] = accountBalance - amount; _totalSupply -= amount; }
114         emit Transfer(account, address(0), amount);
115         _afterTokenTransfer(account, address(0), amount);
116     }
117     function _approve(address owner, address spender, uint256 amount) internal virtual {
118         require(owner != address(0), "ERC20: approve from the zero address");
119         require(spender != address(0), "ERC20: approve to the zero address");
120         _allowances[owner][spender] = amount;
121         emit Approval(owner, spender, amount);
122     }
123     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
124         uint256 currentAllowance = allowance(owner, spender);
125         if (currentAllowance != type(uint256).max) {
126             require(currentAllowance >= amount, "ERC20: insufficient allowance");
127             unchecked { _approve(owner, spender, currentAllowance - amount); }
128         }
129     }
130     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
131     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
132 }
133 
134 contract BABYPEPE is ERC20, Ownable {
135     using SafeMath for uint256;
136 
137     address public weth;
138     address public mainpair;
139     address public routerAddr = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
140     address public marketingAddr = 0x6C7094F44655Cc1860c4eD7Ea239934720a386f2;
141 
142     bool public launched;
143 
144     uint256 public fee = 1;
145 
146     bool    private _swapping;
147     uint256 private _swapAmount;
148     uint256 private constant _totalSupply = 42 * 10000 * 10000 * (10**18);
149 
150     mapping(address => bool) private _isExcludedFromFees;
151 
152     event Launched(uint256 blockNumber);
153 
154     constructor() ERC20("BABYPEPE", "BABYPEPE", 18) {
155         weth = IRouter(routerAddr).WETH();
156         mainpair = IFactory(IRouter(routerAddr).factory()).createPair(weth, address(this));
157 
158         _swapAmount = _totalSupply.div(1000);
159 
160         excludeFromFees(address(this), true);
161         excludeFromFees(marketingAddr, true);
162         excludeFromFees(msg.sender, true);
163 
164         _mint(msg.sender, _totalSupply);
165         _approve(address(this), routerAddr, ~uint256(0));
166     }
167 
168     receive() external payable {}
169 
170     function launch() external onlyOwner {
171         require(!launched, "Already launched");
172         launched = true;
173         emit Launched(block.number);
174     }
175 
176     function excludeFromFees(address account, bool excluded) public onlyOwner { _isExcludedFromFees[account] = excluded; }
177 
178     function _transfer(address from, address to, uint256 amount) internal override {
179         require(from != address(0));
180         require(to != address(0));
181         require(amount != 0);
182         require(launched || _isExcludedFromFees[from] || _isExcludedFromFees[to]);
183 
184         if (!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
185             if (to == mainpair && !_swapping && balanceOf(address(this)) >= _swapAmount) {
186                 _swapping = true;
187                 _swap(balanceOf(address(this)), marketingAddr);
188                 _swapping = false;
189             }
190 
191             if (!_swapping) {
192                 uint256 _fee = from == mainpair || to == mainpair ? fee : 0;
193                 uint256 feeAmount = amount.mul(_fee).div(100);
194                 if (feeAmount > 0) { amount = amount.sub(feeAmount); super._transfer(from, address(this), feeAmount); }
195                 if (amount > 1) amount = amount.sub(1);
196             }
197         }
198 
199         super._transfer(from, to, amount);
200     }
201 
202     function _swap(uint256 amount, address to) internal {
203         if (amount == 0) return;
204         address[] memory path = new address[](2);
205         path[0] = address(this);
206         path[1] = weth;
207         IRouter(routerAddr).swapExactTokensForTokens(amount, 0, path, to, block.timestamp);
208     }
209 }