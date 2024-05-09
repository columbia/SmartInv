1 pragma solidity ^0.5.17;
2 
3 interface IERC20 {
4 
5     function totalSupply() external view returns (uint256);
6 
7     function balanceOf(address account) external view returns (uint256);
8 
9     function transfer(address recipient, uint256 amount) external returns (bool);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16 
17     event Transfer(address indexed from, address indexed to, uint256 value);
18 
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 
23 contract ERC20Detailed is IERC20 {
24     string private _name;
25     string private _symbol;
26     uint8 private _decimals;
27 
28     constructor (string memory name, string memory symbol, uint8 decimals) public {
29         _name = name;
30         _symbol = symbol;
31         _decimals = decimals;
32     }
33 
34     function name() public view returns (string memory) {
35         return _name;
36     }
37 
38     function symbol() public view returns (string memory) {
39         return _symbol;
40     }
41 
42     function decimals() public view returns (uint8) {
43         return _decimals;
44     }
45 }
46 
47 library SafeMath {
48  
49     function add(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a + b;
51         require(c >= a, "SafeMath: addition overflow");
52         return c;
53     }
54 
55     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
56         return sub(a, b, "SafeMath: subtraction overflow");
57     }
58 
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62         return c;
63     }
64 
65     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
66         if (a == 0) {
67             return 0;
68         }
69 
70         uint256 c = a * b;
71         require(c / a == b, "SafeMath: multiplication overflow");
72         return c;
73     }
74 
75     function div(uint256 a, uint256 b) internal pure returns (uint256) {
76         return div(a, b, "SafeMath: division by zero");
77     }
78 
79     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
80         require(b > 0, errorMessage);
81         uint256 c = a / b;
82         return c;
83     }
84 }
85 
86 
87 contract Context {
88  
89     constructor () internal { }
90    
91 
92     function _msgSender() internal view returns (address payable) {
93         return msg.sender;
94     }
95 
96     function _msgData() internal view returns (bytes memory) {
97         this; 
98         return msg.data;
99     }
100 }
101 
102 
103 contract ERC20 is Context, IERC20 {
104     using SafeMath for uint256;
105 
106     address Owner;
107 
108     mapping (address => uint256) private _balances;
109 
110     mapping (address => mapping (address => uint256)) private _allowances;
111     
112     mapping (address => bool) private _lock;
113 
114     uint256 private _totalSupply;
115     
116     modifier onlyOwner() {
117         require (Owner == _msgSender(),"you don't have access to block");
118         _;
119     }
120 
121     function totalSupply() public view returns (uint256) {
122         return _totalSupply;
123     }
124 
125     function balanceOf(address account) public view returns (uint256) {
126         return _balances[account];
127     }
128 
129     function transfer(address recipient, uint256 amount) public returns (bool) {
130        
131         _transfer(_msgSender(), recipient, amount);
132         return true;
133     }
134 
135 
136     function allowance(address owner, address spender) public view returns (uint256) {
137         return _allowances[owner][spender];
138     }
139 
140     function approve(address spender, uint256 amount) public returns (bool) {
141         require(!_lock[spender],"ERC20: spender is blocked");
142         _approve(_msgSender(), spender, amount);
143         return true;
144     }
145 
146     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
147         require(!_lock[sender],"ERC20: sender is blocked");
148         require(!_lock[recipient],"ERC20: recipient is blocked");
149         _transfer(sender, recipient, amount);
150         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
151         return true;
152     }
153     
154     function lock (address addr) public onlyOwner returns(bool) {
155         _lock[addr] = true;
156         return _lock[addr];
157     }
158     
159     function Unlock (address addr) public onlyOwner returns(bool) {
160         _lock[addr] = false;
161         return _lock[addr];
162     }
163     
164     function accountStatus (address addr) public view returns (bool) {
165         return _lock[addr];
166     }
167 
168     function _transfer(address sender, address recipient, uint256 amount) internal {
169         require(!_lock[sender],"ERC20: sender is blocked");
170         require(!_lock[recipient],"ERC20: recipient is blocked");
171         require(sender != address(0), "ERC20: transfer from the zero address");
172         require(recipient != address(0), "ERC20: transfer to the zero address");
173 
174         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
175         _balances[recipient] = _balances[recipient].add(amount);
176         emit Transfer(sender, recipient, amount);
177     }
178 
179     function _mint(address account, uint256 amount) internal {
180         require(account != address(0), "ERC20: mint to the zero address");
181         Owner = account;
182         _totalSupply = _totalSupply.add(amount);
183         _balances[account] = _balances[account].add(amount);
184         emit Transfer(address(0), account, amount);
185     }
186 
187     function _approve(address owner, address spender, uint256 amount) internal {
188         require(owner != address(0), "ERC20: approve from the zero address");
189         require(spender != address(0), "ERC20: approve to the zero address");
190 
191         _allowances[owner][spender] = amount;
192         emit Approval(owner, spender, amount);
193     }
194 }
195 
196 contract DELETOSSOOCIAL is ERC20, ERC20Detailed {
197     constructor() ERC20Detailed("DELETOS SOOCIAL", "DLTS", 0) public {
198         _mint(msg.sender, 200000000);
199     }
200 }