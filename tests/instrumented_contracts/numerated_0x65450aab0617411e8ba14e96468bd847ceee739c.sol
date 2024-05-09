1 pragma solidity ^0.5.0;
2 
3 interface IERC20 {
4     function transfer(address to, uint256 value) external returns (bool);
5 
6     function approve(address spender, uint256 value) external returns (bool);
7 
8     function transferFrom(address from, address to, uint256 value) external returns (bool);
9 
10     function totalSupply() external view returns (uint256);
11 
12     function balanceOf(address who) external view returns (uint256);
13 
14     function allowance(address owner, address spender) external view returns (uint256);
15 
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 
18     event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 contract ERC20 is IERC20 {
22     using SafeMath for uint256;
23 
24     mapping (address => uint256) private _balances;
25 
26     mapping (address => mapping (address => uint256)) private _allowances;
27 
28     uint256 private _totalSupply;
29 
30     function totalSupply() public view returns (uint256) {
31         return _totalSupply;
32     }
33 
34     function balanceOf(address owner) public view returns (uint256) {
35         return _balances[owner];
36     }
37 
38     function allowance(address owner, address spender) public view returns (uint256) {
39         return _allowances[owner][spender];
40     }
41 
42     function transfer(address to, uint256 value) public returns (bool) {
43         _transfer(msg.sender, to, value);
44         return true;
45     }
46 
47     function approve(address spender, uint256 value) public returns (bool) {
48         _approve(msg.sender, spender, value);
49         return true;
50     }
51 
52     function transferFrom(address from, address to, uint256 value) public returns (bool) {
53         _transfer(from, to, value);
54         _approve(from, msg.sender, _allowances[from][msg.sender].sub(value));
55         return true;
56     }
57 
58     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
59         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
60         return true;
61     }
62 
63     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
64         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
65         return true;
66     }
67 
68     function _transfer(address from, address to, uint256 value) internal {
69         require(from != address(0), "ERC20: transfer from the zero address");
70         require(to != address(0), "ERC20: transfer to the zero address");
71 
72         _balances[from] = _balances[from].sub(value);
73         _balances[to] = _balances[to].add(value);
74         emit Transfer(from, to, value);
75     }
76 
77     function _mint(address account, uint256 value) internal {
78         require(account != address(0), "ERC20: mint to the zero address");
79 
80         _totalSupply = _totalSupply.add(value);
81         _balances[account] = _balances[account].add(value);
82         emit Transfer(address(0), account, value);
83     }
84 
85     function _burn(address account, uint256 value) internal {
86         require(account != address(0), "ERC20: burn from the zero address");
87 
88         _totalSupply = _totalSupply.sub(value);
89         _balances[account] = _balances[account].sub(value);
90         emit Transfer(account, address(0), value);
91     }
92 
93     function _approve(address owner, address spender, uint256 value) internal {
94         require(owner != address(0), "ERC20: approve from the zero address");
95         require(spender != address(0), "ERC20: approve to the zero address");
96 
97         _allowances[owner][spender] = value;
98         emit Approval(owner, spender, value);
99     }
100 
101     function _burnFrom(address account, uint256 value) internal {
102         _burn(account, value);
103         _approve(account, msg.sender, _allowances[account][msg.sender].sub(value));
104     }
105 }
106 
107 contract ERC20Detailed is IERC20 {
108     string private _name;
109     string private _symbol;
110     uint8 private _decimals;
111 
112     constructor (string memory name, string memory symbol, uint8 decimals) public {
113         _name = name;
114         _symbol = symbol;
115         _decimals = decimals;
116     }
117 
118     function name() public view returns (string memory) {
119         return _name;
120     }
121 
122     function symbol() public view returns (string memory) {
123         return _symbol;
124     }
125 
126     function decimals() public view returns (uint8) {
127         return _decimals;
128     }
129 }
130 
131 contract CPIToken is ERC20, ERC20Detailed {
132     uint8 public constant DECIMALS = 2;
133     uint256 public constant INITIAL_SUPPLY = 100000000 * (10 ** uint256(DECIMALS));
134 
135     constructor () public ERC20Detailed("Portfolio Investment Club Token", "CPI", DECIMALS) {
136         _mint(msg.sender, INITIAL_SUPPLY);
137     }
138 }
139 
140 library SafeMath {
141     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
142         if (a == 0) {
143             return 0;
144         }
145 
146         uint256 c = a * b;
147         require(c / a == b, "SafeMath: multiplication overflow");
148 
149         return c;
150     }
151 
152     function div(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b > 0, "SafeMath: division by zero");
154         uint256 c = a / b;
155 
156         return c;
157     }
158 
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         require(b <= a, "SafeMath: subtraction overflow");
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     function add(uint256 a, uint256 b) internal pure returns (uint256) {
167         uint256 c = a + b;
168         require(c >= a, "SafeMath: addition overflow");
169 
170         return c;
171     }
172 
173     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
174         require(b != 0, "SafeMath: modulo by zero");
175         return a % b;
176     }
177 }