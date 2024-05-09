1 pragma solidity ^0.5.11;
2 
3 library SafeMath {
4     function add(uint256 a, uint256 b) internal pure returns (uint256) {
5         uint256 c = a + b;
6         require(c >= a, "SafeMath: addition overflow");
7         return c;
8     }
9     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
10         return sub(a, b, "SafeMath: subtraction overflow");
11     }
12     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
13         require(b <= a, errorMessage);
14         uint256 c = a - b;
15         return c;
16     }
17     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18         if (a == 0) {
19             return 0;
20         }
21         uint256 c = a * b;
22         require(c / a == b, "SafeMath: multiplication overflow");
23         return c;
24     }
25     function div(uint256 a, uint256 b) internal pure returns (uint256) {
26         return div(a, b, "SafeMath: division by zero");
27     }
28     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
29         require(b > 0, errorMessage);
30         uint256 c = a / b;
31         return c;
32     }
33     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
34         return mod(a, b, "SafeMath: modulo by zero");
35     }
36     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
37         require(b != 0, errorMessage);
38         return a % b;
39     }
40 }
41 
42 contract Context {
43     constructor () internal { }
44     function _msgSender() internal view returns (address) {
45         return msg.sender;
46     }
47     function _msgData() internal view returns (bytes memory) {
48         this;
49         return msg.data;
50     }
51 }
52 
53 interface IERC20 {
54     function totalSupply() external view returns (uint256);
55     function balanceOf(address account) external view returns (uint256);
56     function transfer(address recipient, uint256 amount) external returns (bool);
57     function allowance(address owner, address spender) external view returns (uint256);
58     function approve(address spender, uint256 amount) external returns (bool);
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60     event Transfer(address indexed from, address indexed to, uint256 value);
61     event Approval(address indexed owner, address indexed spender, uint256 value);
62 }
63 
64 contract ERC20 is Context, IERC20 {
65     using SafeMath for uint256;
66     mapping (address => uint256) private _balances;
67     mapping (address => mapping (address => uint256)) private _allowances;
68     uint256 private _totalSupply;
69     function totalSupply() public view returns (uint256) {
70         return _totalSupply;
71     }
72     function balanceOf(address account) public view returns (uint256) {
73         return _balances[account];
74     }
75     function transfer(address recipient, uint256 amount) public returns (bool) {
76         _transfer(_msgSender(), recipient, amount);
77         return true;
78     }
79     function allowance(address owner, address spender) public view returns (uint256) {
80         return _allowances[owner][spender];
81     }
82     function approve(address spender, uint256 value) public returns (bool) {
83         _approve(_msgSender(), spender, value);
84         return true;
85     }
86     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
87         _transfer(sender, recipient, amount);
88         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
89         return true;
90     }
91     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
92         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
93         return true;
94     }
95     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
96         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
97         return true;
98     }
99     function _transfer(address sender, address recipient, uint256 amount) internal {
100         require(sender != address(0), "ERC20: transfer from the zero address");
101         require(recipient != address(0), "ERC20: transfer to the zero address");
102 
103         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
104         _balances[recipient] = _balances[recipient].add(amount);
105         emit Transfer(sender, recipient, amount);
106     }
107     function _mint(address account, uint256 amount) internal {
108         require(account != address(0), "ERC20: mint to the zero address");
109 
110         _totalSupply = _totalSupply.add(amount);
111         _balances[account] = _balances[account].add(amount);
112         emit Transfer(address(0), account, amount);
113     }
114     function _burn(address account, uint256 value) internal {
115         require(account != address(0), "ERC20: burn from the zero address");
116 
117         _balances[account] = _balances[account].sub(value, "ERC20: burn amount exceeds balance");
118         _totalSupply = _totalSupply.sub(value);
119         emit Transfer(account, address(0), value);
120     }
121     function _approve(address owner, address spender, uint256 value) internal {
122         require(owner != address(0), "ERC20: approve from the zero address");
123         require(spender != address(0), "ERC20: approve to the zero address");
124 
125         _allowances[owner][spender] = value;
126         emit Approval(owner, spender, value);
127     }
128     function _burnFrom(address account, uint256 amount) internal {
129         _burn(account, amount);
130         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
131     }
132 }
133 
134 contract ERC20Detailed is IERC20 {
135     string private _name;
136     string private _symbol;
137     uint8 private _decimals;
138     constructor (string memory name, string memory symbol, uint8 decimals) public {
139         _name = name;
140         _symbol = symbol;
141         _decimals = decimals;
142     }
143     function name() public view returns (string memory) {
144         return _name;
145     }
146     function symbol() public view returns (string memory) {
147         return _symbol;
148     }
149     function decimals() public view returns (uint8) {
150         return _decimals;
151     }
152 }
153 
154 contract RAYAX is Context, ERC20, ERC20Detailed {
155     constructor () public ERC20Detailed("RAYAX", "RAYAX", 18) {
156         _mint(_msgSender(), 500000000 * (10 ** uint256(decimals())));
157     }
158 }