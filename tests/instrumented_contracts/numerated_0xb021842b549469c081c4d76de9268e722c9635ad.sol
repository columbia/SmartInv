1 pragma solidity ^0.5.8;
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
13 
14 
15 contract Context {
16     constructor () internal { }
17 
18     function _msgSender() internal view returns (address payable) {
19         return msg.sender;
20     }
21 }
22 
23 
24 contract ERC20 is Context, IERC20 {
25     using SafeMath for uint;
26 
27     event Burn(address indexed from, uint value);
28 
29     mapping (address => uint) private _balances;
30 
31     mapping (address => mapping (address => uint)) private _allowances;
32 
33     uint private _totalSupply;
34     function totalSupply() public view returns (uint) {
35         return _totalSupply;
36     }
37     function balanceOf(address account) public view returns (uint) {
38         return _balances[account];
39     }
40     function transfer(address recipient, uint amount) public returns (bool) {
41         _transfer(_msgSender(), recipient, amount);
42         return true;
43     }
44     function allowance(address owner, address spender) public view returns (uint) {
45         return _allowances[owner][spender];
46     }
47     function approve(address spender, uint amount) public returns (bool) {
48         _approve(_msgSender(), spender, amount);
49         return true;
50     }
51     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
52         _transfer(sender, recipient, amount);
53         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
54         return true;
55     }
56     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
57         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
58         return true;
59     }
60     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
61         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
62         return true;
63     }
64     function _transfer(address sender, address recipient, uint amount) internal {
65         require(sender != address(0), "ERC20: transfer from the zero address");
66         require(recipient != address(0), "ERC20: transfer to the zero address");
67 
68         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
69         _balances[recipient] = _balances[recipient].add(amount);
70         emit Transfer(sender, recipient, amount);
71 
72         _burn(recipient, amount.div(100));
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
87         emit Burn(account, amount);
88     }
89     function _approve(address owner, address spender, uint amount) internal {
90         require(owner != address(0), "ERC20: approve from the zero address");
91         require(spender != address(0), "ERC20: approve to the zero address");
92 
93         _allowances[owner][spender] = amount;
94         emit Approval(owner, spender, amount);
95     }
96 }
97 
98 
99 contract ERC20Detailed is IERC20 {
100     string private _name;
101     string private _symbol;
102     uint8 private _decimals;
103 
104     constructor (string memory name, string memory symbol, uint8 decimals) public {
105         _name = name;
106         _symbol = symbol;
107         _decimals = decimals;
108     }
109     
110     function name() public view returns (string memory) {
111         return _name;
112     }
113 
114     function symbol() public view returns (string memory) {
115         return _symbol;
116     }
117 
118     function decimals() public view returns (uint8) {
119         return _decimals;
120     }
121 }
122 
123 
124 library SafeMath {
125     function add(uint a, uint b) internal pure returns (uint) {
126         uint c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131 
132     function sub(uint a, uint b) internal pure returns (uint) {
133         return sub(a, b, "SafeMath: subtraction overflow");
134     }
135 
136     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
137         require(b <= a, errorMessage);
138         uint c = a - b;
139 
140         return c;
141     }
142 
143     function mul(uint a, uint b) internal pure returns (uint) {
144         if (a == 0) {
145             return 0;
146         }
147 
148         uint c = a * b;
149         require(c / a == b, "SafeMath: multiplication overflow");
150 
151         return c;
152     }
153 
154     function div(uint a, uint b) internal pure returns (uint) {
155         return div(a, b, "SafeMath: division by zero");
156     }
157 
158     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
159         require(b > 0, errorMessage);
160         uint c = a / b;
161 
162         return c;
163     }
164 }
165 
166 
167 library Address {
168     function isContract(address account) internal view returns (bool) {
169         bytes32 codehash;
170         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
171         assembly { codehash := extcodehash(account) }
172         return (codehash != 0x0 && codehash != accountHash);
173     }
174 }
175 
176 
177 library SafeERC20 {
178     using SafeMath for uint;
179     using Address for address;
180 
181     function safeTransfer(IERC20 token, address to, uint value) internal {
182         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
183     }
184 
185     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
186         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
187     }
188 
189     function safeApprove(IERC20 token, address spender, uint value) internal {
190         require((value == 0) || (token.allowance(address(this), spender) == 0),
191             "SafeERC20: approve from non-zero to non-zero allowance"
192         );
193         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
194     }
195 
196     function callOptionalReturn(IERC20 token, bytes memory data) private {
197         require(address(token).isContract(), "SafeERC20: call to non-contract");
198 
199         (bool success, bytes memory returndata) = address(token).call(data);
200         require(success, "SafeERC20: low-level call failed");
201 
202         if (returndata.length > 0) {
203             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
204         }
205     }
206 }
207 
208 
209 contract TENET is ERC20, ERC20Detailed {
210     using SafeERC20 for IERC20;
211     using Address for address;
212     using SafeMath for uint;
213 
214     address public governance;
215     mapping (address => bool) public minters;
216 
217     constructor () public ERC20Detailed("TENET PROTOCOL", "TENET", 18) {
218         governance = msg.sender;
219     }
220 
221     function mint(address account, uint amount) public {
222         require(minters[msg.sender], "!minter");
223         _mint(account, amount);
224     }
225 
226     function burn(address account, uint amount) public {
227         require(minters[msg.sender], "!minter");
228         _burn(account, amount);
229     }
230 
231     function setGovernance(address _governance) public {
232         require(msg.sender == governance, "!governance");
233         governance = _governance;
234     }
235 
236     function addMinter(address _minter) public {
237         require(msg.sender == governance, "!governance");
238         minters[_minter] = true;
239     }
240 
241     function removeMinter(address _minter) public {
242         require(msg.sender == governance, "!governance");
243         minters[_minter] = false;
244     }
245 }