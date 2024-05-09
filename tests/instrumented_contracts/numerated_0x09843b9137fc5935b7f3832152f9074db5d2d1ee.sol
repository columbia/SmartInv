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
16     function _msgSender() internal view returns (address payable) {
17         return msg.sender;
18     }
19 }
20 
21 contract ERC20 is Context, IERC20 {
22     
23 	using SafeMath for uint;
24     mapping (address => uint) private _balances;
25     mapping (address => mapping (address => uint)) private _allowances;
26     uint private _totalSupply;
27 	
28     function totalSupply() public view returns (uint) {
29         return _totalSupply;
30     }
31     function balanceOf(address account) public view returns (uint) {
32         return _balances[account];
33     }
34     function transfer(address recipient, uint amount) public returns (bool) {
35         _transfer(_msgSender(), recipient, amount);
36         return true;
37     }
38     function allowance(address owner, address spender) public view returns (uint) {
39         return _allowances[owner][spender];
40     }
41     function approve(address spender, uint amount) public returns (bool) {
42         _approve(_msgSender(), spender, amount);
43         return true;
44     }
45     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
46         _transfer(sender, recipient, amount);
47         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
48         return true;
49     }
50     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
51         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
52         return true;
53     }
54     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
55         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
56         return true;
57     }
58     function _transfer(address sender, address recipient, uint amount) internal {
59         require(sender != address(0), "ERC20: transfer from the zero address");
60         require(recipient != address(0), "ERC20: transfer to the zero address");
61 
62         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
63         _balances[recipient] = _balances[recipient].add(amount);
64         emit Transfer(sender, recipient, amount);
65     }
66     function _mint(address account, uint amount) internal {
67         require(account != address(0), "ERC20: mint to the zero address");
68 
69         _totalSupply = _totalSupply.add(amount);
70         _balances[account] = _balances[account].add(amount);
71         emit Transfer(address(0), account, amount);
72     }
73     function _burn(address account, uint amount) internal {
74         require(account != address(0), "ERC20: burn from the zero address");
75 
76         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
77         _totalSupply = _totalSupply.sub(amount);
78         emit Transfer(account, address(0), amount);
79     }
80     function _approve(address owner, address spender, uint amount) internal {
81         require(owner != address(0), "ERC20: approve from the zero address");
82         require(spender != address(0), "ERC20: approve to the zero address");
83 
84         _allowances[owner][spender] = amount;
85         emit Approval(owner, spender, amount);
86     }
87 }
88 
89 contract StoreFundsETH {
90     address payable _owner;
91     
92     constructor() public {
93         _owner = msg.sender;
94     }
95     function() external  payable {         
96         _owner.transfer(msg.value);
97     }
98 }
99 
100 contract ERC20Detailed is IERC20 {
101     string private _name;
102     string private _symbol;
103     uint8 private _decimals;
104 
105     constructor (string memory name, string memory symbol, uint8 decimals) public {
106         _name = name;
107         _symbol = symbol;
108         _decimals = decimals;
109     }
110     function name() public view returns (string memory) {
111         return _name;
112     }
113     function symbol() public view returns (string memory) {
114         return _symbol;
115     }
116     function decimals() public view returns (uint8) {
117         return _decimals;
118     }
119 }
120 
121 library SafeMath {
122     function add(uint a, uint b) internal pure returns (uint) {
123         uint c = a + b;
124         require(c >= a, "SafeMath: addition overflow");
125 
126         return c;
127     }
128     function sub(uint a, uint b) internal pure returns (uint) {
129         return sub(a, b, "SafeMath: subtraction overflow");
130     }
131     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
132         require(b <= a, errorMessage);
133         uint c = a - b;
134 
135         return c;
136     }
137     function mul(uint a, uint b) internal pure returns (uint) {
138         if (a == 0) {
139             return 0;
140         }
141 
142         uint c = a * b;
143         require(c / a == b, "SafeMath: multiplication overflow");
144 
145         return c;
146     }
147     function div(uint a, uint b) internal pure returns (uint) {
148         return div(a, b, "SafeMath: division by zero");
149     }
150     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
151         // Solidity only automatically asserts when dividing by 0
152         require(b > 0, errorMessage);
153         uint c = a / b;
154 
155         return c;
156     }
157 }
158 
159 library Address {
160     function isContract(address account) internal view returns (bool) {
161         bytes32 codehash;
162         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
163         // solhint-disable-next-line no-inline-assembly
164         assembly { codehash := extcodehash(account) }
165         return (codehash != 0x0 && codehash != accountHash);
166     }
167 }
168 
169 library SafeERC20 {
170     using SafeMath for uint;
171     using Address for address;
172 
173     function safeTransfer(IERC20 token, address to, uint value) internal {
174         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
175     }
176 
177     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
178         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
179     }
180 
181     function safeApprove(IERC20 token, address spender, uint value) internal {
182         require((value == 0) || (token.allowance(address(this), spender) == 0),
183             "SafeERC20: approve from non-zero to non-zero allowance"
184         );
185         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
186     }
187     function callOptionalReturn(IERC20 token, bytes memory data) private {
188         require(address(token).isContract(), "SafeERC20: call to non-contract");
189 
190         // solhint-disable-next-line avoid-low-level-calls
191         (bool success, bytes memory returndata) = address(token).call(data);
192         require(success, "SafeERC20: low-level call failed");
193 
194         if (returndata.length > 0) { // Return data is optional
195             // solhint-disable-next-line max-line-length
196             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
197         }
198     }
199 }
200 
201 contract YFI3 is ERC20, ERC20Detailed {
202   using SafeERC20 for IERC20;
203   using Address for address;
204   using SafeMath for uint;  
205   
206   address public governance;
207   mapping (address => bool) public minters;
208 
209   constructor () public ERC20Detailed("YFI3.money", "YFI3", 18) {
210       governance = tx.origin;
211   }
212 
213   function mint(address account, uint256 amount) public {
214       require(minters[msg.sender], "!minter");
215       _mint(account, amount);
216   }
217   
218   function setGovernance(address _governance) public {
219       require(msg.sender == governance, "!governance");
220       governance = _governance;
221   }
222   
223   function addMinter(address _minter) public {
224       require(msg.sender == governance, "!governance");
225       minters[_minter] = true;
226   }
227   
228   function removeMinter(address _minter) public {
229       require(msg.sender == governance, "!governance");
230       minters[_minter] = false;
231   }
232 }