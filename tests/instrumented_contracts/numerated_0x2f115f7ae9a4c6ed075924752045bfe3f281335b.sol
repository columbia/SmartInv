1 pragma solidity ^0.6.0;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return msg.sender;
6     }
7     function _msgData() internal view virtual returns (bytes memory) {
8         this;
9         return msg.data;
10     }
11 }
12 
13 library SafeMath {
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17         return c;
18     }
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         return sub(a, b, "SafeMath: subtraction overflow");
21     }
22     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
23         require(b <= a, errorMessage);
24         uint256 c = a - b;
25         return c;
26     }
27     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
28         if (a == 0) {
29             return 0;
30         }
31         uint256 c = a * b;
32         require(c / a == b, "SafeMath: multiplication overflow");
33         return c;
34     }
35     function div(uint256 a, uint256 b) internal pure returns (uint256) {
36         return div(a, b, "SafeMath: division by zero");
37     }
38     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
39         require(b > 0, errorMessage);
40         uint256 c = a / b;
41         return c;
42     }
43     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
44         return mod(a, b, "SafeMath: modulo by zero");
45     }
46     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
47         require(b != 0, errorMessage);
48         return a % b;
49     }
50 }
51 
52 interface IERC20 {
53     function totalSupply() external view returns (uint256);
54     function balanceOf(address account) external view returns (uint256);
55     function transfer(address recipient, uint256 amount) external returns (bool);
56     function allowance(address owner, address spender) external view returns (uint256);
57     function approve(address spender, uint256 amount) external returns (bool);
58     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59     event Transfer(address indexed from, address indexed to, uint256 value);
60     event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 
63 contract RIT is Context, IERC20 {
64     using SafeMath for uint256;
65     mapping (address => uint256) private _balances;
66     mapping (address => mapping (address => uint256)) private _allowances;
67     uint256 private _totalSupply;
68     string private _name;
69     string private _symbol;
70     uint8 private _decimals;
71     constructor () public {
72         _name = 'Real Estate Investment Token';
73         _symbol = 'RIT 2.0';
74         _totalSupply = 500000000e18;
75         _decimals = 18;
76         _balances[0xAAFcDafb6B00d7d5B801847b6569c16EbBe09496] = _totalSupply;
77         emit Transfer(address(0), 0xAAFcDafb6B00d7d5B801847b6569c16EbBe09496, _totalSupply);
78     }
79     function name() public view returns (string memory) {
80         return _name;
81     }
82     function symbol() public view returns (string memory) {
83         return _symbol;
84     }
85     function decimals() public view returns (uint8) {
86         return _decimals;
87     }
88     function totalSupply() public view override returns (uint256) {
89         return _totalSupply;
90     }
91     function balanceOf(address account) public view override returns (uint256) {
92         return _balances[account];
93     }
94     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
95         _transfer(_msgSender(), recipient, amount);
96         return true;
97     }
98     function allowance(address owner, address spender) public view virtual override returns (uint256) {
99         return _allowances[owner][spender];
100     }
101     function approve(address spender, uint256 amount) public virtual override returns (bool) {
102         _approve(_msgSender(), spender, amount);
103         return true;
104     }
105     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
106         _transfer(sender, recipient, amount);
107         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
108         return true;
109     }
110     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
111         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
112         return true;
113     }
114     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
115         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
116         return true;
117     }
118     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
119         require(sender != address(0), "ERC20: transfer from the zero address");
120         require(recipient != address(0), "ERC20: transfer to the zero address");
121         _beforeTokenTransfer(sender, recipient, amount);
122         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
123         _balances[recipient] = _balances[recipient].add(amount);
124         emit Transfer(sender, recipient, amount);
125     }
126     function _mint(address account, uint256 amount) internal virtual {
127         require(account != address(0), "ERC20: mint to the zero address");
128         _beforeTokenTransfer(address(0), account, amount);
129         _totalSupply = _totalSupply.add(amount);
130         _balances[account] = _balances[account].add(amount);
131         emit Transfer(address(0), account, amount);
132     }
133     function _burn(address account, uint256 amount) internal virtual {
134         require(account != address(0), "ERC20: burn from the zero address");
135         _beforeTokenTransfer(account, address(0), amount);
136         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
137         _totalSupply = _totalSupply.sub(amount);
138         emit Transfer(account, address(0), amount);
139     }
140     function _approve(address owner, address spender, uint256 amount) internal virtual {
141         require(owner != address(0), "ERC20: approve from the zero address");
142         require(spender != address(0), "ERC20: approve to the zero address");
143         _allowances[owner][spender] = amount;
144         emit Approval(owner, spender, amount);
145     }
146     function _setupDecimals(uint8 decimals_) internal {
147         _decimals = decimals_;
148     }
149     function _burn(uint256 amount) public virtual {
150         _burn(_msgSender(), amount);
151     }
152     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
153 }