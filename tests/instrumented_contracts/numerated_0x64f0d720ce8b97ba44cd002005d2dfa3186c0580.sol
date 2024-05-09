1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-26
3 */
4 
5 pragma solidity ^0.5.16;
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
49         _approve(_msgSender(), spender, amount);
50         return true;
51     }
52     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
53         _transfer(sender, recipient, amount);
54         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
55         return true;
56     }
57     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
58         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
59         return true;
60     }
61     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
62         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
63         return true;
64     }
65     function _transfer(address sender, address recipient, uint amount) internal {
66         require(sender != address(0), "ERC20: transfer from the zero address");
67         require(recipient != address(0), "ERC20: transfer to the zero address");
68 
69         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
70         _balances[recipient] = _balances[recipient].add(amount);
71         emit Transfer(sender, recipient, amount);
72     }
73     function _mint(address account, uint amount) internal {
74         require(account != address(0), "ERC20: mint to the zero address");
75 
76         _totalSupply = _totalSupply.add(amount);
77         _balances[account] = _balances[account].add(amount);
78         emit Transfer(address(0), account, amount);
79     }
80     function _burn(address account, uint amount) internal {
81         require(account != address(0), "ERC20: burn from the zero address");
82 
83         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
84         _totalSupply = _totalSupply.sub(amount);
85         emit Transfer(account, address(0), amount);
86     }
87     function _approve(address owner, address spender, uint amount) internal {
88         require(owner != address(0), "ERC20: approve from the zero address");
89         require(spender != address(0), "ERC20: approve to the zero address");
90 
91         _allowances[owner][spender] = amount;
92         emit Approval(owner, spender, amount);
93     }
94 }
95 
96 contract ERC20Detailed is IERC20 {
97     string private _name;
98     string private _symbol;
99     uint8 private _decimals;
100 
101     constructor (string memory name, string memory symbol, uint8 decimals) public {
102         _name = name;
103         _symbol = symbol;
104         _decimals = decimals;
105     }
106     function name() public view returns (string memory) {
107         return _name;
108     }
109     function symbol() public view returns (string memory) {
110         return _symbol;
111     }
112     function decimals() public view returns (uint8) {
113         return _decimals;
114     }
115 }
116 
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
197 contract YYFI is ERC20, ERC20Detailed {
198   using SafeERC20 for IERC20;
199   using Address for address;
200   using SafeMath for uint;
201   
202   
203   address public governance;
204   mapping (address => bool) public minters;
205 
206   constructor () public ERC20Detailed("YYFI.finance", "YYFI", 18) {
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