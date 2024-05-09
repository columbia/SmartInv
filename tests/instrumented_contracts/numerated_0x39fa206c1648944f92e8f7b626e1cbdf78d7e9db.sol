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
24     using SafeMath for uint;
25 
26     mapping (address => uint) private _balances;
27 
28     mapping (address => mapping (address => uint)) private _allowances;
29 
30     uint private _totalSupply;
31     function totalSupply() public view returns (uint) {
32         return _totalSupply;
33     }
34     function balanceOf(address account) public view returns (uint) {
35         return _balances[account];
36     }
37     function transfer(address recipient, uint amount) public returns (bool) {
38         _transfer(_msgSender(), recipient, amount);
39         return true;
40     }
41     function allowance(address owner, address spender) public view returns (uint) {
42         return _allowances[owner][spender];
43     }
44     function approve(address spender, uint amount) public returns (bool) {
45         _approve(_msgSender(), spender, amount);
46         return true;
47     }
48     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
49         _transfer(sender, recipient, amount);
50         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
51         return true;
52     }
53     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
54         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
55         return true;
56     }
57     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
58         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
59         return true;
60     }
61     function _transfer(address sender, address recipient, uint amount) internal {
62         require(sender != address(0), "ERC20: transfer from the zero address");
63         require(recipient != address(0), "ERC20: transfer to the zero address");
64 
65         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
66         _balances[recipient] = _balances[recipient].add(amount);
67         emit Transfer(sender, recipient, amount);
68     }
69     function _mint(address account, uint amount) internal {
70         require(account != address(0), "ERC20: mint to the zero address");
71 
72         _totalSupply = _totalSupply.add(amount);
73         _balances[account] = _balances[account].add(amount);
74         emit Transfer(address(0), account, amount);
75     }
76     function _burn(address account, uint amount) internal {
77         require(account != address(0), "ERC20: burn from the zero address");
78 
79         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
80         _totalSupply = _totalSupply.sub(amount);
81         emit Transfer(account, address(0), amount);
82     }
83     function _approve(address owner, address spender, uint amount) internal {
84         require(owner != address(0), "ERC20: approve from the zero address");
85         require(spender != address(0), "ERC20: approve to the zero address");
86 
87         _allowances[owner][spender] = amount;
88         emit Approval(owner, spender, amount);
89     }
90 }
91 
92 
93 contract ERC20Detailed is IERC20 {
94     string private _name;
95     string private _symbol;
96     uint8 private _decimals;
97     uint256 private  TokenmaxSupply = 30000*10**18;
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
113     
114      function maxSupply() public view returns (uint256) {
115         return TokenmaxSupply;
116     }
117 }
118 
119 
120 library SafeMath {
121     function add(uint a, uint b) internal pure returns (uint) {
122         uint c = a + b;
123         require(c >= a, "SafeMath: addition overflow");
124 
125         return c;
126     }
127     function sub(uint a, uint b) internal pure returns (uint) {
128         return sub(a, b, "SafeMath: subtraction overflow");
129     }
130     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
131         require(b <= a, errorMessage);
132         uint c = a - b;
133 
134         return c;
135     }
136     function mul(uint a, uint b) internal pure returns (uint) {
137         if (a == 0) {
138             return 0;
139         }
140 
141         uint c = a * b;
142         require(c / a == b, "SafeMath: multiplication overflow");
143 
144         return c;
145     }
146     function div(uint a, uint b) internal pure returns (uint) {
147         return div(a, b, "SafeMath: division by zero");
148     }
149     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
150         // Solidity only automatically asserts when dividing by 0
151         require(b > 0, errorMessage);
152         uint c = a / b;
153 
154         return c;
155     }
156 }
157 
158 library Address {
159     function isContract(address account) internal view returns (bool) {
160         bytes32 codehash;
161         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
162         // solhint-disable-next-line no-inline-assembly
163         assembly { codehash := extcodehash(account) }
164         return (codehash != 0x0 && codehash != accountHash);
165     }
166 }
167 
168 library SafeERC20 {
169     using SafeMath for uint;
170     using Address for address;
171 
172     function safeTransfer(IERC20 token, address to, uint value) internal {
173         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
174     }
175 
176     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
177         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
178     }
179 
180     function safeApprove(IERC20 token, address spender, uint value) internal {
181         require((value == 0) || (token.allowance(address(this), spender) == 0),
182             "SafeERC20: approve from non-zero to non-zero allowance"
183         );
184         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
185     }
186     function callOptionalReturn(IERC20 token, bytes memory data) private {
187         require(address(token).isContract(), "SafeERC20: call to non-contract");
188 
189         // solhint-disable-next-line avoid-low-level-calls
190         (bool success, bytes memory returndata) = address(token).call(data);
191         require(success, "SafeERC20: low-level call failed");
192 
193         if (returndata.length > 0) { // Return data is optional
194             // solhint-disable-next-line max-line-length
195             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
196         }
197     }
198 }
199 
200 contract DXY is ERC20, ERC20Detailed {
201   using SafeERC20 for IERC20;
202   using Address for address;
203   using SafeMath for uint;
204   
205   
206   address public governance;
207   mapping (address => bool) public minters;
208 
209   constructor () public ERC20Detailed("DXY.FINANCE", "DXY", 18) {
210       governance = tx.origin;
211   }
212 
213   function mint(address account, uint256 amount) public {
214       
215       require(totalSupply() + amount <= maxSupply(), "Supply Max Reached");
216       require(minters[msg.sender], "!minter");
217       _mint(account, amount);
218   }
219   
220 
221   function burn(uint256 amount) external {
222         require(amount != 0, "you cannot burn zero amount");
223        _burn(msg.sender, amount);
224   }
225     
226   
227   function setGovernance(address _governance) public {
228       require(msg.sender == governance, "!governance");
229       governance = _governance;
230   }
231   
232   function addMinter(address _minter) public {
233       require(msg.sender == governance, "!governance");
234       minters[_minter] = true;
235   }
236   
237   function removeMinter(address _minter) public {
238       require(msg.sender == governance, "!governance");
239       minters[_minter] = false;
240   }
241 }