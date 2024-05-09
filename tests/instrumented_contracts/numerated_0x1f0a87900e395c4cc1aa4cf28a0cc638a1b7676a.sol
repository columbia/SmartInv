1 pragma solidity ^0.5.4;
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
27     mapping (address => uint) private _balances;
28 
29     mapping (address => mapping (address => uint)) private _allowances;
30 
31     uint private _totalSupply;
32     function totalSupply() public view returns (uint) {
33         return _totalSupply;
34     }
35     function balanceOf(address account) public view returns (uint) {
36         return _balances[account];
37     }
38     function transfer(address recipient, uint amount) public returns (bool) {
39         _transfer(_msgSender(), recipient, amount);
40         return true;
41     }
42     function allowance(address owner, address spender) public view returns (uint) {
43         return _allowances[owner][spender];
44     }
45     function approve(address spender, uint amount) public returns (bool) {
46         _approve(_msgSender(), spender, amount);
47         return true;
48     }
49     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
50         _transfer(sender, recipient, amount);
51         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
52         return true;
53     }
54     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
55         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
56         return true;
57     }
58     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
59         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
60         return true;
61     }
62     function _transfer(address sender, address recipient, uint amount) internal {
63         require(sender != address(0), "ERC20: transfer from the zero address");
64         require(recipient != address(0), "ERC20: transfer to the zero address");
65 
66         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
67         _balances[recipient] = _balances[recipient].add(amount);
68         emit Transfer(sender, recipient, amount);
69     }
70     function _mint(address account, uint amount) internal {
71         require(account != address(0), "ERC20: mint to the zero address");
72 
73         _totalSupply = _totalSupply.add(amount);
74         _balances[account] = _balances[account].add(amount);
75         emit Transfer(address(0), account, amount);
76     }
77     function _burn(address account, uint amount) internal {
78         require(account != address(0), "ERC20: burn from the zero address");
79 
80         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
81         _totalSupply = _totalSupply.sub(amount);
82         emit Transfer(account, address(0), amount);
83     }
84     function _approve(address owner, address spender, uint amount) internal {
85         require(owner != address(0), "ERC20: approve from the zero address");
86         require(spender != address(0), "ERC20: approve to the zero address");
87 
88         _allowances[owner][spender] = amount;
89         emit Approval(owner, spender, amount);
90     }
91 }
92 
93 
94 contract ERC20Detailed is IERC20 {
95     string private _name;
96     string private _symbol;
97     uint8 private _decimals;
98 
99     constructor (string memory name, string memory symbol, uint8 decimals) public {
100         _name = name;
101         _symbol = symbol;
102         _decimals = decimals;
103     }
104     
105     function name() public view returns (string memory) {
106         return _name;
107     }
108 
109     function symbol() public view returns (string memory) {
110         return _symbol;
111     }
112 
113     function decimals() public view returns (uint8) {
114         return _decimals;
115     }
116 }
117 
118 
119 library SafeMath {
120     function add(uint a, uint b) internal pure returns (uint) {
121         uint c = a + b;
122         require(c >= a, "SafeMath: addition overflow");
123 
124         return c;
125     }
126 
127     function sub(uint a, uint b) internal pure returns (uint) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130 
131     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
132         require(b <= a, errorMessage);
133         uint c = a - b;
134 
135         return c;
136     }
137 
138     function mul(uint a, uint b) internal pure returns (uint) {
139         if (a == 0) {
140             return 0;
141         }
142 
143         uint c = a * b;
144         require(c / a == b, "SafeMath: multiplication overflow");
145 
146         return c;
147     }
148 
149     function div(uint a, uint b) internal pure returns (uint) {
150         return div(a, b, "SafeMath: division by zero");
151     }
152 
153     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
154         require(b > 0, errorMessage);
155         uint c = a / b;
156 
157         return c;
158     }
159 }
160 
161 
162 library Address {
163     function isContract(address account) internal view returns (bool) {
164         bytes32 codehash;
165         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
166         assembly { codehash := extcodehash(account) }
167         return (codehash != 0x0 && codehash != accountHash);
168     }
169 }
170 
171 
172 library SafeERC20 {
173     using SafeMath for uint;
174     using Address for address;
175 
176     function safeTransfer(IERC20 token, address to, uint value) internal {
177         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
178     }
179 
180     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
181         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
182     }
183 
184     function safeApprove(IERC20 token, address spender, uint value) internal {
185         require((value == 0) || (token.allowance(address(this), spender) == 0),
186             "SafeERC20: approve from non-zero to non-zero allowance"
187         );
188         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
189     }
190 
191     function callOptionalReturn(IERC20 token, bytes memory data) private {
192         require(address(token).isContract(), "SafeERC20: call to non-contract");
193 
194         (bool success, bytes memory returndata) = address(token).call(data);
195         require(success, "SafeERC20: low-level call failed");
196 
197         if (returndata.length > 0) {
198             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
199         }
200     }
201 }
202 
203 
204 contract PIOP is ERC20, ERC20Detailed {
205     using SafeERC20 for IERC20;
206     using Address for address;
207     using SafeMath for uint;
208 
209     address public governance;
210     mapping (address => bool) public minters;
211 
212     constructor () public ERC20Detailed("PIOP", "PIOP", 18) {
213         governance = msg.sender;
214     }
215 
216     function mint(address account, uint amount) public {
217         require(minters[msg.sender], "!minter");
218         _mint(account, amount);
219     }
220 
221     function setGovernance(address _governance) public {
222         require(msg.sender == governance, "!governance");
223         governance = _governance;
224     }
225 
226     function addMinter(address _minter) public {
227         require(msg.sender == governance, "!governance");
228         minters[_minter] = true;
229     }
230 
231     function removeMinter(address _minter) public {
232         require(msg.sender == governance, "!governance");
233         minters[_minter] = false;
234     }
235 }