1 pragma solidity ^0.5.0;
2 
3 
4 contract Context {
5     constructor () internal { }
6 
7     function _msgSender() internal view returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view returns (bytes memory) {
12         this;
13         return msg.data;
14     }
15 }
16 
17 library SafeMath {
18 
19     function add(uint256 a, uint256 b) internal pure returns (uint256) {
20         uint256 c = a + b;
21         require(c >= a, "SafeMath: addition overflow");
22 
23         return c;
24     }
25 
26 
27     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
28         return sub(a, b, "SafeMath: subtraction overflow");
29     }
30 
31 
32     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
33         require(b <= a, errorMessage);
34         uint256 c = a - b;
35 
36         return c;
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
40         if (a == 0) {
41             return 0;
42         }
43 
44         uint256 c = a * b;
45         require(c / a == b, "SafeMath: multiplication overflow");
46 
47         return c;
48     }
49 
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         return div(a, b, "SafeMath: division by zero");
52     }
53 
54     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
55 
56         require(b > 0, errorMessage);
57         uint256 c = a / b;
58 
59         return c;
60     }
61 
62     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
63         return mod(a, b, "SafeMath: modulo by zero");
64     }
65 
66     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
67         require(b != 0, errorMessage);
68         return a % b;
69     }
70 }
71 
72 interface IERC20 {
73     function totalSupply() external view returns (uint256);
74 
75     function balanceOf(address account) external view returns (uint256);
76 
77     function transfer(address recipient, uint256 amount) external returns (bool);
78 
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 contract ERC20Detailed {
91     string private _name;
92     string private _symbol;
93     uint8 private _decimals;
94 
95     constructor (string memory name, string memory symbol, uint8 decimals) public {
96         _name = name;
97         _symbol = symbol;
98         _decimals = decimals;
99     }
100 
101     function name() public view returns (string memory) {
102         return _name;
103     }
104 
105     function symbol() public view returns (string memory) {
106         return _symbol;
107     }
108 
109     function decimals() public view returns (uint8) {
110         return _decimals;
111     }
112 }
113 
114 contract SlashToken is Context, IERC20, ERC20Detailed("Slash Token", "SLAT", 18) {
115     using SafeMath for uint256;
116 
117     mapping (address => uint256) private _balances;
118 
119     mapping (address => mapping (address => uint256)) private _allowances;
120 
121     uint256 private _totalSupply;
122 
123     constructor(address founder) public{
124         _totalSupply = 1e10 * 10 ** uint256(decimals());
125         _balances[founder] = _totalSupply;
126     }
127 
128     function totalSupply() public view returns (uint256) {
129         return _totalSupply;
130     }
131 
132     function balanceOf(address account) public view returns (uint256) {
133         return _balances[account];
134     }
135 
136     function transfer(address recipient, uint256 amount) public returns (bool) {
137         _transfer(_msgSender(), recipient, amount);
138         return true;
139     }
140 
141     function allowance(address owner, address spender) public view returns (uint256) {
142         return _allowances[owner][spender];
143     }
144 
145     function approve(address spender, uint256 amount) public returns (bool) {
146         require((amount == 0) || (_allowances[_msgSender()][spender] == 0));
147         _approve(_msgSender(), spender, amount);
148         return true;
149     }
150 
151     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
152         _transfer(sender, recipient, amount);
153         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
154         return true;
155     }
156 
157     function _transfer(address sender, address recipient, uint256 amount) internal {
158         require(sender != address(0), "ERC20: transfer from the zero address");
159         require(recipient != address(0), "ERC20: transfer to the zero address");
160 
161         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
162         _balances[recipient] = _balances[recipient].add(amount);
163         emit Transfer(sender, recipient, amount);
164     }
165 
166     function _approve(address owner, address spender, uint256 amount) internal {
167         require(owner != address(0), "ERC20: approve from the zero address");
168         require(spender != address(0), "ERC20: approve to the zero address");
169         
170         _allowances[owner][spender] = amount;
171         emit Approval(owner, spender, amount);
172     }
173 
174 }