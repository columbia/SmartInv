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
22 // ----------------------------------------------------------------------------
23 // ERC Token #20 Interface
24 // ----------------------------------------------------------------------------
25 contract ERC20 is Context, IERC20 {
26     using SafeMath for uint;
27 
28     mapping (address => uint) private _balances;
29 
30     mapping (address => mapping (address => uint)) private _allowances;
31 
32     uint private _totalSupply;
33     function totalSupply() public view returns (uint) {
34         return _totalSupply;
35     }
36     function balanceOf(address account) public view returns (uint) {
37         return _balances[account];
38     }
39     function transfer(address recipient, uint amount) public returns (bool) {
40         _transfer(_msgSender(), recipient, amount);
41         return true;
42     }
43     function allowance(address owner, address spender) public view returns (uint) {
44         return _allowances[owner][spender];
45     }
46     function approve(address spender, uint amount) public returns (bool) {
47         _approve(_msgSender(), spender, amount);
48         return true;
49     }
50     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
51         _transfer(sender, recipient, amount);
52         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
53         return true;
54     }
55     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
56         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
57         return true;
58     }
59     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
60         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
61         return true;
62     }
63     function _transfer(address sender, address recipient, uint amount) internal {
64         require(sender != address(0), "ERC20: transfer from the zero address");
65         require(recipient != address(0), "ERC20: transfer to the zero address");
66 
67         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
68         _balances[recipient] = _balances[recipient].add(amount);
69         emit Transfer(sender, recipient, amount);
70     }
71     function _mint(address account, uint amount) internal {
72         require(account != address(0), "ERC20: mint to the zero address");
73 
74         _totalSupply = _totalSupply.add(amount);
75         _balances[account] = _balances[account].add(amount);
76         emit Transfer(address(0), account, amount);
77     }
78     function _burn(address account, uint amount) internal {
79         require(account != address(0), "ERC20: burn from the zero address");
80 
81         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
82         _totalSupply = _totalSupply.sub(amount);
83         emit Transfer(account, address(0), amount);
84     }
85     function _approve(address owner, address spender, uint amount) internal {
86         require(owner != address(0), "ERC20: approve from the zero address");
87         require(spender != address(0), "ERC20: approve to the zero address");
88 
89         _allowances[owner][spender] = amount;
90         emit Approval(owner, spender, amount);
91     }
92 }
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
114 // ----------------------------------------------------------------------------
115 // ERC Token SafeMath
116 // ----------------------------------------------------------------------------
117 library SafeMath {
118     function add(uint a, uint b) internal pure returns (uint) {
119         uint c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121 
122         return c;
123     }
124     function sub(uint a, uint b) internal pure returns (uint) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
128         require(b <= a, errorMessage);
129         uint c = a - b;
130 
131         return c;
132     }
133     function mul(uint a, uint b) internal pure returns (uint) {
134         if (a == 0) {
135             return 0;
136         }
137 
138         uint c = a * b;
139         require(c / a == b, "SafeMath: multiplication overflow");
140 
141         return c;
142     }
143     function div(uint a, uint b) internal pure returns (uint) {
144         return div(a, b, "SafeMath: division by zero");
145     }
146     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
147         // Solidity only automatically asserts when dividing by 0
148         require(b > 0, errorMessage);
149         uint c = a / b;
150 
151         return c;
152     }
153 }
154 
155 library Address {
156     function isContract(address account) internal view returns (bool) {
157         bytes32 codehash;
158         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
159         // solhint-disable-next-line no-inline-assembly
160         assembly { codehash := extcodehash(account) }
161         return (codehash != 0x0 && codehash != accountHash);
162     }
163 }
164 
165 library SafeERC20 {
166     using SafeMath for uint;
167     using Address for address;
168 
169     function safeTransfer(IERC20 token, address to, uint value) internal {
170         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
171     }
172 
173     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
174         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
175     }
176 
177     function safeApprove(IERC20 token, address spender, uint value) internal {
178         require((value == 0) || (token.allowance(address(this), spender) == 0),
179             "SafeERC20: approve from non-zero to non-zero allowance"
180         );
181         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
182     }
183     function callOptionalReturn(IERC20 token, bytes memory data) private {
184         require(address(token).isContract(), "SafeERC20: call to non-contract");
185 
186         // solhint-disable-next-line avoid-low-level-calls
187         (bool success, bytes memory returndata) = address(token).call(data);
188         require(success, "SafeERC20: low-level call failed");
189 
190         if (returndata.length > 0) { // Return data is optional
191             // solhint-disable-next-line max-line-length
192             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
193         }
194     }
195 }
196 
197 contract YFFToken is ERC20, ERC20Detailed {
198   using SafeERC20 for IERC20;
199   using Address for address;
200   using SafeMath for uint;
201   
202   
203   address public governance;
204   mapping (address => bool) public minters;
205 
206   constructor () public ERC20Detailed("yff.finance", "YFF", 18) {
207       governance = tx.origin;
208   }
209 
210   function mint(address account, uint256 amount) public {
211       require(minters[msg.sender], "!minter");
212       _mint(account, amount);
213   }
214   
215   function setGovernance(address _governance) public {
216       require(msg.sender == governance, "!governance");
217       governance = _governance;
218   }
219   
220   function addMinter(address _minter) public {
221       require(msg.sender == governance, "!governance");
222       minters[_minter] = true;
223   }
224   
225   function removeMinter(address _minter) public {
226       require(msg.sender == governance, "!governance");
227       minters[_minter] = false;
228   }
229 }