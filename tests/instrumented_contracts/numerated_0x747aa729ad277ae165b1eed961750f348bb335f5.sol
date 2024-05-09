1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11     event Transfer(address indexed from, address indexed to, uint256 value);
12     event Approval(address indexed owner, address indexed spender, uint256 value);
13 }
14 
15 library SafeMath {
16     function add(uint256 a, uint256 b) internal pure returns (uint256) {
17         uint256 c = a + b;
18         require(c >= a, "SafeMath: addition overflow");
19         return c;
20     }
21     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
22         return sub(a, b, "SafeMath: subtraction overflow");
23     }
24     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
25         require(b <= a, errorMessage);
26         uint256 c = a - b;
27         return c;
28     }
29     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
30         if (a == 0) {
31             return 0;
32         }
33         uint256 c = a * b;
34         require(c / a == b, "SafeMath: multiplication overflow");
35         return c;
36     }
37     function div(uint256 a, uint256 b) internal pure returns (uint256) {
38         return div(a, b, "SafeMath: division by zero");
39     }
40     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
41         require(b > 0, errorMessage);
42         uint256 c = a / b;
43         return c;
44     }
45     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
46         return mod(a, b, "SafeMath: modulo by zero");
47     }
48     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
49         require(b != 0, errorMessage);
50         return a % b;
51     }
52 }
53 
54 contract DOA is IERC20 {
55     using SafeMath for uint256;
56     mapping (address => uint256) private _balances;
57     mapping (address => mapping (address => uint256)) private _allowances;
58     uint256 private _totalSupply;
59     string private _name;
60     string private _symbol;
61     uint8 private _decimals;
62     constructor () public {
63         _name = "DOA";
64         _symbol = "DOA";
65         _decimals = 18;
66         _mint(msg.sender, 464324286000000000000000000);
67     }
68     function _msgSender() internal view virtual returns (address payable) {
69         return msg.sender;
70     }
71     function _msgData() internal view virtual returns (bytes memory) {
72         this;
73         return msg.data;
74     }
75     function name() public view returns (string memory) {
76         return _name;
77     }
78     function symbol() public view returns (string memory) {
79         return _symbol;
80     }
81     function decimals() public view returns (uint8) {
82         return _decimals;
83     }
84     function totalSupply() public view override returns (uint256) {
85         return _totalSupply;
86     }
87     function balanceOf(address account) public view override returns (uint256) {
88         return _balances[account];
89     }
90     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
91         _transfer(_msgSender(), recipient, amount);
92         return true;
93     }
94     function allowance(address owner, address spender) public view virtual override returns (uint256) {
95         return _allowances[owner][spender];
96     }
97     function approve(address spender, uint256 amount) public virtual override returns (bool) {
98         _approve(_msgSender(), spender, amount);
99         return true;
100     }
101     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
102         _transfer(sender, recipient, amount);
103         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
104         return true;
105     }
106     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
107         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
108         return true;
109     }
110     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
111         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
112         return true;
113     }
114     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
115         require(sender != address(0), "ERC20: transfer from the zero address");
116         require(recipient != address(0), "ERC20: transfer to the zero address");
117         _beforeTokenTransfer(sender, recipient, amount);
118         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
119         _balances[recipient] = _balances[recipient].add(amount);
120         emit Transfer(sender, recipient, amount);
121     }
122     function _mint(address account, uint256 amount) internal virtual {
123         require(account != address(0), "ERC20: mint to the zero address");
124         _beforeTokenTransfer(address(0), account, amount);
125         _totalSupply = _totalSupply.add(amount);
126         _balances[account] = _balances[account].add(amount);
127         emit Transfer(address(0), account, amount);
128     }
129     function _burn(address account, uint256 amount) internal virtual {
130         require(account != address(0), "ERC20: burn from the zero address");
131         _beforeTokenTransfer(account, address(0), amount);
132         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
133         _totalSupply = _totalSupply.sub(amount);
134         emit Transfer(account, address(0), amount);
135     }
136     function _approve(address owner, address spender, uint256 amount) internal virtual {
137         require(owner != address(0), "ERC20: approve from the zero address");
138         require(spender != address(0), "ERC20: approve to the zero address");
139         _allowances[owner][spender] = amount;
140         emit Approval(owner, spender, amount);
141     }
142     function _setupDecimals(uint8 decimals_) internal {
143         _decimals = decimals_;
144     }
145     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
146 }