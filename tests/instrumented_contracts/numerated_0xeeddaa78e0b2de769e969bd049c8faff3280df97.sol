1 pragma solidity ^0.5.0;
2 
3 interface IERC20 { 
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 library SafeMath {    
14     function add(uint256 a, uint256 b) internal pure returns (uint256) {
15         uint256 c = a + b;
16         require(c >= a, "SafeMath: addition overflow");
17         return c;
18     }
19     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
20         require(b <= a, "SafeMath: subtraction overflow");
21         uint256 c = a - b;
22         return c;
23     }
24     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
25         if (a == 0) {
26             return 0;
27         }
28 
29         uint256 c = a * b;
30         require(c / a == b, "SafeMath: multiplication overflow");
31 
32         return c;
33     }
34     function div(uint256 a, uint256 b) internal pure returns (uint256) {
35         // Solidity only automatically asserts when dividing by 0
36         require(b > 0, "SafeMath: division by zero");
37         uint256 c = a / b;
38         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
39 
40         return c;
41     }
42 
43     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
44         require(b != 0, "SafeMath: modulo by zero");
45         return a % b;
46     }
47 }
48 
49 contract ERC20 is IERC20 {
50     using SafeMath for uint256;
51     mapping (address => uint256) private _balances;
52     mapping (address => mapping (address => uint256)) private _allowances;
53     uint256 private _totalSupply;
54 
55     function totalSupply() public view returns (uint256) {
56         return _totalSupply;
57     }
58 
59     function balanceOf(address account) public view returns (uint256) {
60         return _balances[account];
61     }
62 
63     function transfer(address recipient, uint256 amount) public returns (bool) {
64         _transfer(msg.sender, recipient, amount);
65         return true;
66     }
67 
68     function allowance(address owner, address spender) public view returns (uint256) {
69         return _allowances[owner][spender];
70     }
71 
72  
73     function approve(address spender, uint256 value) public returns (bool) {
74         _approve(msg.sender, spender, value);
75         return true;
76     }
77 
78     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
79         _transfer(sender, recipient, amount);
80         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
81         return true;
82     }
83 
84     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
85         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
86         return true;
87     }
88 
89     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
90         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
91         return true;
92     }
93 
94     function _transfer(address sender, address recipient, uint256 amount) internal {
95         require(sender != address(0), "ERC20: transfer from the zero address");
96         require(recipient != address(0), "ERC20: transfer to the zero address");
97 
98         _balances[sender] = _balances[sender].sub(amount);
99         _balances[recipient] = _balances[recipient].add(amount);
100         emit Transfer(sender, recipient, amount);
101     }
102 
103     function _mint(address account, uint256 amount) internal {
104         require(account != address(0), "ERC20: mint to the zero address");
105 
106         _totalSupply = _totalSupply.add(amount);
107         _balances[account] = _balances[account].add(amount);
108         emit Transfer(address(0), account, amount);
109     }
110 
111     function _burn(address account, uint256 value) internal {
112         require(account != address(0), "ERC20: burn from the zero address");
113 
114         _totalSupply = _totalSupply.sub(value);
115         _balances[account] = _balances[account].sub(value);
116         emit Transfer(account, address(0), value);
117     }
118 
119     function _approve(address owner, address spender, uint256 value) internal {
120         require(owner != address(0), "ERC20: approve from the zero address");
121         require(spender != address(0), "ERC20: approve to the zero address");
122 
123         _allowances[owner][spender] = value;
124         emit Approval(owner, spender, value);
125     }
126 
127     function _burnFrom(address account, uint256 amount) internal {
128         _burn(account, amount);
129         _approve(account, msg.sender, _allowances[account][msg.sender].sub(amount));
130     }
131 }
132 
133 contract ERC20Detailed is ERC20 {
134     string private _name;
135     string private _symbol;
136     uint8 private _decimals;
137     
138     constructor () public ERC20Detailed() {
139         _name="Gold Pressed Latinum";
140         _symbol="GPL";
141         _decimals=18;
142         _mint(msg.sender, 100000000 * (10 ** uint256(decimals())));
143     }
144     function name() public view returns (string memory) {
145         return _name;
146     }
147     function symbol() public view returns (string memory) {
148         return _symbol;
149     }
150     function decimals() public view returns (uint8) {
151         return _decimals;
152     }
153 }