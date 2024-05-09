1 // ZYTH
2 
3 pragma solidity ^0.5.0;
4 contract Context {
5 constructor () internal { }
6 function _msgSender() internal view returns (address payable) {
7 return msg.sender;
8 }
9 function _msgData() internal view returns (bytes memory) {
10 this;
11 return msg.data;
12 }
13 }
14 library SafeMath {
15 function add(uint256 a, uint256 b) internal pure returns (uint256) {
16 uint256 c = a + b;
17 require(c >= a, "SafeMath: addition overflow");
18 return c;
19 }
20 function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21 return sub(a, b, "SafeMath: subtraction overflow");
22 }
23 function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
24 require(b <= a, errorMessage);
25 uint256 c = a - b;
26 return c;
27 }
28 function mul(uint256 a, uint256 b) internal pure returns (uint256) {
29 if (a == 0) {
30 return 0;
31 }
32 uint256 c = a * b;
33 require(c / a == b, "SafeMath: multiplication overflow");
34 return c;
35 }
36 function div(uint256 a, uint256 b) internal pure returns (uint256) {
37 return div(a, b, "SafeMath: division by zero");
38 }
39 function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
40 require(b > 0, errorMessage);
41 uint256 c = a / b;
42 return c;
43 }
44 function mod(uint256 a, uint256 b) internal pure returns (uint256) {
45 return mod(a, b, "SafeMath: modulo by zero");
46 }
47 function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48 require(b != 0, errorMessage);
49 return a % b;
50 }
51 }
52 interface IERC20 {
53 function totalSupply() external view returns (uint256);
54 function balanceOf(address account) external view returns (uint256);
55 function transfer(address recipient, uint256 amount) external returns (bool);
56 function allowance(address owner, address spender) external view returns (uint256);
57 function approve(address spender, uint256 amount) external returns (bool);
58 function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
59 event Transfer(address indexed from, address indexed to, uint256 value);
60 event Approval(address indexed owner, address indexed spender, uint256 value);
61 }
62 contract ZYTH is Context, IERC20 {
63 using SafeMath for uint256;
64 mapping (address => uint256) private _balances;
65 mapping (address => mapping (address => uint256)) private _allowances;
66 string public ticker = "ZYTH";
67 string public name = "ZYTH";
68 uint8 public decimals = 18;
69 uint256 public _totalSupply;
70 
71         
72 constructor(uint256 _totalSupply) public {
73     _totalSupply = 25000000 * 10**uint(decimals);
74     _mint(msg.sender, _totalSupply);
75 }
76 
77 function totalSupply() public view returns (uint256) {
78 return _totalSupply;
79 }
80 function balanceOf(address account) public view returns (uint256) {
81 return _balances[account];
82 }
83 function transfer(address recipient, uint256 amount) public returns (bool) {
84 _transfer(_msgSender(), recipient, amount);
85 return true;
86 }
87 function allowance(address owner, address spender) public view returns (uint256) {
88 return _allowances[owner][spender];
89 }
90 function approve(address spender, uint256 amount) public returns (bool) {
91 _approve(_msgSender(), spender, amount);
92 return true;
93 }
94 function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
95 _transfer(sender, recipient, amount);
96 _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
97 return true;
98 }
99 function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
100 _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
101 return true;
102 }
103 function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
104 _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
105 return true;
106 }
107 function _transfer(address sender, address recipient, uint256 amount) internal {
108 require(sender != address(0), "ERC20: transfer from the zero address");
109 require(recipient != address(0), "ERC20: transfer to the zero address");
110 _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
111 _balances[recipient] = _balances[recipient].add(amount);
112 emit Transfer(sender, recipient, amount);
113 }
114 function _mint(address account, uint256 amount) internal {
115 require(account != address(0), "ERC20: mint to the zero address");
116 _totalSupply = _totalSupply.add(amount);
117 _balances[account] = _balances[account].add(amount);
118 emit Transfer(address(0), account, amount);
119 }
120 function _burn(address account, uint256 amount) internal {
121 require(account != address(0), "ERC20: burn from the zero address");
122 _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
123 _totalSupply = _totalSupply.sub(amount);
124 emit Transfer(account, address(0), amount);
125 }
126 function _approve(address owner, address spender, uint256 amount) internal {
127 require(owner != address(0), "ERC20: approve from the zero address");
128 require(spender != address(0), "ERC20: approve to the zero address");
129 _allowances[owner][spender] = amount;
130 emit Approval(owner, spender, amount);
131 }
132 function _burnFrom(address account, uint256 amount) internal {
133 _burn(account, amount);
134 _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
135 }
136 }