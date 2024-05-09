1 pragma solidity ^0.5.16;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint);
5     function balanceOf(address account) external view returns (uint);
6     function transfer(address recipient, uint amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint);
8     function approve(address spender, uint amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint value);
11     event Approval(address indexed owner, address indexed spender, uint value);
12 }
13 contract Context {
14     constructor () internal { }
15     function _msgSender() internal view returns (address payable) {
16         return msg.sender;
17     }
18 }
19 
20 contract ERC20 is Context, IERC20 {
21     using SafeMath for uint;
22     mapping (address => uint) private _balances;
23     mapping (address => mapping (address => uint)) private _allowances;
24     uint private _totalSupply;
25     function totalSupply() public view returns (uint) {
26         return _totalSupply;
27     }
28     function balanceOf(address account) public view returns (uint) {
29         return _balances[account];
30     }
31     function transfer(address recipient, uint amount) public returns (bool) {
32         _transfer(_msgSender(), recipient, amount);
33         return true;
34     }
35     function allowance(address owner, address spender) public view returns (uint) {
36         return _allowances[owner][spender];
37     }
38     function approve(address spender, uint amount) public returns (bool) {
39         _approve(_msgSender(), spender, amount);
40         return true;
41     }
42     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
43         _transfer(sender, recipient, amount);
44         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
45         return true;
46     }
47     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
48         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
49         return true;
50     }
51     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
52         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
53         return true;
54     }
55     function _transfer(address sender, address recipient, uint amount) internal {
56         require(sender != address(0), "ERC20: transfer from the zero address");
57         require(recipient != address(0), "ERC20: transfer to the zero address");
58         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
59         _balances[recipient] = _balances[recipient].add(amount);
60         emit Transfer(sender, recipient, amount);
61     }
62     function _mint(address account, uint amount) internal {
63         require(account != address(0), "ERC20: mint to the zero address");
64         _totalSupply = _totalSupply.add(amount);
65         _balances[account] = _balances[account].add(amount);
66         emit Transfer(address(0), account, amount);
67     }
68     function _burn(address account, uint amount) internal {
69         require(account != address(0), "ERC20: burn from the zero address");
70         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
71         _totalSupply = _totalSupply.sub(amount);
72         emit Transfer(account, address(0), amount);
73     }
74     function _approve(address owner, address spender, uint amount) internal {
75         require(owner != address(0), "ERC20: approve from the zero address");
76         require(spender != address(0), "ERC20: approve to the zero address");
77         _allowances[owner][spender] = amount;
78         emit Approval(owner, spender, amount);
79     }
80 }
81 
82 contract ERC20Detailed is IERC20 {
83     string private _name;
84     string private _symbol;
85     uint8 private _decimals;
86 
87     constructor (string memory name, string memory symbol, uint8 decimals) public {
88         _name = name;
89         _symbol = symbol;
90         _decimals = decimals;
91     }
92     function name() public view returns (string memory) {
93         return _name;
94     }
95     function symbol() public view returns (string memory) {
96         return _symbol;
97     }
98     function decimals() public view returns (uint8) {
99         return _decimals;
100     }
101 }
102 
103 library SafeMath {
104     function add(uint a, uint b) internal pure returns (uint) {
105         uint c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107         return c;
108     }
109     function sub(uint a, uint b) internal pure returns (uint) {
110         return sub(a, b, "SafeMath: subtraction overflow");
111     }
112     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
113         require(b <= a, errorMessage);
114         uint c = a - b;
115         return c;
116     }
117     function mul(uint a, uint b) internal pure returns (uint) {
118         if (a == 0) {
119             return 0;
120         }
121         uint c = a * b;
122         require(c / a == b, "SafeMath: multiplication overflow");
123         return c;
124     }
125     function div(uint a, uint b) internal pure returns (uint) {
126         return div(a, b, "SafeMath: division by zero");
127     }
128     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
129         require(b > 0, errorMessage);
130         uint c = a / b;
131         return c;
132     }
133 }
134 
135 contract SnippFinance is ERC20, ERC20Detailed {
136   using SafeMath for uint;
137   uint256 _total = 10000;
138   constructor () public ERC20Detailed("Snipp Finance", "SNIPP", 18) {
139       _mint( msg.sender, _total*10**uint(decimals()) );
140   }
141 }