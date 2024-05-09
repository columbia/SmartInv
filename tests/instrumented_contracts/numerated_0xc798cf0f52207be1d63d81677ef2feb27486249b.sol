1 // Created By BitDNS.vip
2 // contact : CORN Token
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.5.8;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint);
9     function balanceOf(address account) external view returns (uint);
10     function transfer(address recipient, uint amount) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint);
12     function approve(address spender, uint amount) external returns (bool);
13     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
14     event Transfer(address indexed from, address indexed to, uint value);
15     event Approval(address indexed owner, address indexed spender, uint value);
16 }
17 
18 contract Context {
19     constructor () internal { }
20     // solhint-disable-previous-line no-empty-blocks
21 
22     function _msgSender() internal view returns (address payable) {
23         return msg.sender;
24     }
25 }
26 
27 contract ERC20 is Context, IERC20 {
28     using SafeMath for uint;
29 
30     mapping (address => uint) private _balances;
31 
32     mapping (address => mapping (address => uint)) private _allowances;
33 
34     uint private _totalSupply;
35     function totalSupply() public view returns (uint) {
36         return _totalSupply;
37     }
38     function balanceOf(address account) public view returns (uint) {
39         return _balances[account];
40     }
41     function transfer(address recipient, uint amount) public returns (bool) {
42         _transfer(_msgSender(), recipient, amount);
43         return true;
44     }
45     function allowance(address owner, address spender) public view returns (uint) {
46         return _allowances[owner][spender];
47     }
48     function approve(address spender, uint amount) public returns (bool) {
49         require((_allowances[_msgSender()][spender] == 0) || (amount == 0), "ERC20: use increaseAllowance or decreaseAllowance instead");
50         _approve(_msgSender(), spender, amount);
51         return true;
52     }
53     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
54         _transfer(sender, recipient, amount);
55         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
56         return true;
57     }
58     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
59         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
60         return true;
61     }
62     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
63         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
64         return true;
65     }
66     function _transfer(address sender, address recipient, uint amount) internal {
67         require(sender != address(0), "ERC20: transfer from the zero address");
68         require(recipient != address(0), "ERC20: transfer to the zero address");
69 
70         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
71         _balances[recipient] = _balances[recipient].add(amount);
72         emit Transfer(sender, recipient, amount);
73     }
74     function _mint(address account, uint amount) internal {
75         require(account != address(0), "ERC20: mint to the zero address");
76 
77         _totalSupply = _totalSupply.add(amount);
78         _balances[account] = _balances[account].add(amount);
79         emit Transfer(address(0), account, amount);
80     }
81     function _burn(address account, uint amount) internal {
82         require(account != address(0), "ERC20: burn from the zero address");
83 
84         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
85         _totalSupply = _totalSupply.sub(amount);
86         emit Transfer(account, address(0), amount);
87     }
88     function _approve(address owner, address spender, uint amount) internal {
89         require(owner != address(0), "ERC20: approve from the zero address");
90         require(spender != address(0), "ERC20: approve to the zero address");
91 
92         _allowances[owner][spender] = amount;
93         emit Approval(owner, spender, amount);
94     }
95 }
96 
97 contract ERC20Detailed is IERC20 {
98     string private _name;
99     string private _symbol;
100     uint8 private _decimals;
101 
102     constructor (string memory name, string memory symbol, uint8 decimals) public {
103         _name = name;
104         _symbol = symbol;
105         _decimals = decimals;
106     }
107     function name() public view returns (string memory) {
108         return _name;
109     }
110     function symbol() public view returns (string memory) {
111         return _symbol;
112     }
113     function decimals() public view returns (uint8) {
114         return _decimals;
115     }
116 }
117 
118 library SafeMath {
119     function add(uint a, uint b) internal pure returns (uint) {
120         uint c = a + b;
121         require(c >= a, "SafeMath: addition overflow");
122 
123         return c;
124     }
125     function sub(uint a, uint b) internal pure returns (uint) {
126         return sub(a, b, "SafeMath: subtraction overflow");
127     }
128     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
129         require(b <= a, errorMessage);
130         uint c = a - b;
131 
132         return c;
133     }
134     function mul(uint a, uint b) internal pure returns (uint) {
135         if (a == 0) {
136             return 0;
137         }
138 
139         uint c = a * b;
140         require(c / a == b, "SafeMath: multiplication overflow");
141 
142         return c;
143     }
144     function div(uint a, uint b) internal pure returns (uint) {
145         return div(a, b, "SafeMath: division by zero");
146     }
147     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
148         // Solidity only automatically asserts when dividing by 0
149         require(b > 0, errorMessage);
150         uint c = a / b;
151 
152         return c;
153     }
154 }
155 
156 library Address {
157     function isContract(address account) internal view returns (bool) {
158         // This method relies in extcodesize, which returns 0 for contracts in
159         // construction, since the code is only stored at the end of the
160         // constructor execution.
161 
162         uint256 size;
163         // solhint-disable-next-line no-inline-assembly
164         assembly { size := extcodesize(account) }
165         return size > 0;
166     }
167 }
168 
169 contract RewordToken is ERC20, ERC20Detailed {
170     using SafeMath for uint;
171 
172     uint256 constant MAX_TOTAL_SUPPLY = 100000 ether;
173     address private governance;
174     mapping (address => bool) private minters;
175 
176     constructor () public ERC20Detailed("Corn.BitDNS", "CORN", 18) {
177         governance = msg.sender;
178     }
179 
180     modifier onlyOwner() {
181         require(msg.sender == governance, "!governance");
182         _;
183     }
184 
185     function setGovernance(address _governance) public onlyOwner {
186         governance = _governance;
187     }
188 
189     function mint(address account, uint amount) public {
190         require(totalSupply() + amount <= MAX_TOTAL_SUPPLY, "totalSupply must be less than MAX_TOTAL_SUPPLY!");
191         require(minters[msg.sender], "!minter");
192         _mint(account, amount);
193     }
194 
195     function addMinter(address _minter) public onlyOwner {
196         minters[_minter] = true;
197     }
198 
199     function removeMinter(address _minter) public onlyOwner {
200         minters[_minter] = false;
201     }
202 }