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
104     function name() public view returns (string memory) {
105         return _name;
106     }
107     function symbol() public view returns (string memory) {
108         return _symbol;
109     }
110     function decimals() public view returns (uint8) {
111         return _decimals;
112     }
113 }
114 
115 
116 library SafeMath {
117     function add(uint a, uint b) internal pure returns (uint) {
118         uint c = a + b;
119         require(c >= a, "SafeMath: addition overflow");
120 
121         return c;
122     }
123     function sub(uint a, uint b) internal pure returns (uint) {
124         return sub(a, b, "SafeMath: subtraction overflow");
125     }
126     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
127         require(b <= a, errorMessage);
128         uint c = a - b;
129 
130         return c;
131     }
132     function mul(uint a, uint b) internal pure returns (uint) {
133         if (a == 0) {
134             return 0;
135         }
136 
137         uint c = a * b;
138         require(c / a == b, "SafeMath: multiplication overflow");
139 
140         return c;
141     }
142     function div(uint a, uint b) internal pure returns (uint) {
143         return div(a, b, "SafeMath: division by zero");
144     }
145     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
146         require(b > 0, errorMessage);
147         uint c = a / b;
148 
149         return c;
150     }
151 }
152 
153 
154 library Address {
155     function isContract(address account) internal view returns (bool) {
156         bytes32 codehash;
157         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
158         assembly { codehash := extcodehash(account) }
159         return (codehash != 0x0 && codehash != accountHash);
160     }
161 }
162 
163 
164 library SafeERC20 {
165     using SafeMath for uint;
166     using Address for address;
167 
168     function safeTransfer(IERC20 token, address to, uint value) internal {
169         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
170     }
171 
172     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
173         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
174     }
175 
176     function safeApprove(IERC20 token, address spender, uint value) internal {
177         require((value == 0) || (token.allowance(address(this), spender) == 0),
178             "SafeERC20: approve from non-zero to non-zero allowance"
179         );
180         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
181     }
182     function callOptionalReturn(IERC20 token, bytes memory data) private {
183         require(address(token).isContract(), "SafeERC20: call to non-contract");
184 
185         (bool success, bytes memory returndata) = address(token).call(data);
186         require(success, "SafeERC20: low-level call failed");
187 
188         if (returndata.length > 0) {
189             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
190         }
191     }
192 }
193 
194 
195 contract MOONC is ERC20, ERC20Detailed {
196     using SafeERC20 for IERC20;
197     using Address for address;
198     using SafeMath for uint;
199 
200     address public governance;
201     mapping (address => bool) public minters;
202 
203     constructor () public ERC20Detailed("Ricer.Finance", "MOONC", 18) {
204         governance = msg.sender;
205     }
206 
207     function mint(address account, uint amount) public {
208         require(minters[msg.sender], "!minter");
209         _mint(account, amount);
210     }
211 
212     function setGovernance(address _governance) public {
213         require(msg.sender == governance, "!governance");
214         governance = _governance;
215     }
216 
217     function addMinter(address _minter) public {
218         require(msg.sender == governance, "!governance");
219         minters[_minter] = true;
220     }
221 
222     function removeMinter(address _minter) public {
223         require(msg.sender == governance, "!governance");
224         minters[_minter] = false;
225     }
226 }