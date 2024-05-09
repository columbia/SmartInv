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
13 
14 contract Context {
15     constructor () internal { }
16     // solhint-disable-previous-line no-empty-blocks
17 
18     function _msgSender() internal view returns (address payable) {
19         return msg.sender;
20     }
21 }
22 
23 contract ERC20 is Context, IERC20 {
24     using SafeMath for uint256;
25 
26     mapping (address => uint256) private _balances;
27 
28     mapping (address => mapping (address => uint256)) private _allowances;
29 
30     uint256 private _totalSupply;
31     function totalSupply() public view returns (uint256) {
32         return _totalSupply;
33     }
34     function balanceOf(address account) public view returns (uint256) {
35         return _balances[account];
36     }
37     function transfer(address recipient, uint256 amount) public returns (bool) {
38         _transfer(_msgSender(), recipient, amount);
39         return true;
40     }
41     function allowance(address owner, address spender) public view returns (uint256) {
42         return _allowances[owner][spender];
43     }
44     function approve(address spender, uint256 amount) public returns (bool) {
45         _approve(_msgSender(), spender, amount);
46         return true;
47     }
48     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
49         _transfer(sender, recipient, amount);
50         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
51         return true;
52     }
53     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
54         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
55         return true;
56     }
57     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
58         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
59         return true;
60     }
61     function _transfer(address sender, address recipient, uint256 amount) internal {
62         require(sender != address(0), "ERC20: transfer from the zero address");
63         require(recipient != address(0), "ERC20: transfer to the zero address");
64 
65         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
66         _balances[recipient] = _balances[recipient].add(amount);
67         emit Transfer(sender, recipient, amount);
68     }
69     function _mint(address account, uint256 amount) internal {
70         require(account != address(0), "ERC20: mint to the zero address");
71 
72         _totalSupply = _totalSupply.add(amount);
73         _balances[account] = _balances[account].add(amount);
74         emit Transfer(address(0), account, amount);
75     }
76     function _burn(address account, uint256 amount) internal {
77         require(account != address(0), "ERC20: burn from the zero address");
78 
79         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
80         _totalSupply = _totalSupply.sub(amount);
81         emit Transfer(account, address(0), amount);
82     }
83     function _approve(address owner, address spender, uint256 amount) internal {
84         require(owner != address(0), "ERC20: approve from the zero address");
85         require(spender != address(0), "ERC20: approve to the zero address");
86 
87         _allowances[owner][spender] = amount;
88         emit Approval(owner, spender, amount);
89     }
90 }
91 
92 contract ERC20Detailed is IERC20 {
93     string private _name;
94     string private _symbol;
95     uint8 private _decimals;
96 
97     constructor (string memory name, string memory symbol, uint8 decimals) public {
98         _name = name;
99         _symbol = symbol;
100         _decimals = decimals;
101     }
102     function name() public view returns (string memory) {
103         return _name;
104     }
105     function symbol() public view returns (string memory) {
106         return _symbol;
107     }
108     function decimals() public view returns (uint8) {
109         return _decimals;
110     }
111 }
112 
113 library SafeMath {
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a + b;
116         require(c >= a, "SafeMath: addition overflow");
117 
118         return c;
119     }
120     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
124         require(b <= a, errorMessage);
125         uint256 c = a - b;
126 
127         return c;
128     }
129     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
130         if (a == 0) {
131             return 0;
132         }
133 
134         uint256 c = a * b;
135         require(c / a == b, "SafeMath: multiplication overflow");
136 
137         return c;
138     }
139     function div(uint256 a, uint256 b) internal pure returns (uint256) {
140         return div(a, b, "SafeMath: division by zero");
141     }
142     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
143         // Solidity only automatically asserts when dividing by 0
144         require(b > 0, errorMessage);
145         uint256 c = a / b;
146 
147         return c;
148     }
149 }
150 
151 contract EDC is ERC20, ERC20Detailed {
152     using SafeMath for uint256;
153 
154     address public governance;
155     mapping (address => bool) public minters;
156 
157     constructor () public ERC20Detailed("EarnDefiCoin", "EDC", 18) {
158         governance = msg.sender;
159         _mint(msg.sender, 2100000 ether);
160     }
161 
162     function mint(address account, uint256 amount) public {
163         require(minters[msg.sender], "!minter");
164         _mint(account, amount);
165     }
166 
167     function burn(uint256 amount) public {
168         _burn(msg.sender, amount);
169     }
170 
171     function setGovernance(address _governance) public {
172         require(msg.sender == governance, "!governance");
173         governance = _governance;
174     }
175 
176     function addMinter(address _minter) public {
177         require(msg.sender == governance, "!governance");
178         minters[_minter] = true;
179     }
180 
181     function removeMinter(address _minter) public {
182         require(msg.sender == governance, "!governance");
183         minters[_minter] = false;
184     }
185 }