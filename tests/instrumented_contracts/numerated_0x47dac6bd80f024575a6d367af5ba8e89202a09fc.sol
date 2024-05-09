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
114     function add(uint a, uint b) internal pure returns (uint) {
115         uint c = a + b;
116         require(c >= a, "SafeMath: addition overflow");
117 
118         return c;
119     }
120     function sub(uint a, uint b) internal pure returns (uint) {
121         return sub(a, b, "SafeMath: subtraction overflow");
122     }
123     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
124         require(b <= a, errorMessage);
125         uint c = a - b;
126 
127         return c;
128     }
129     function mul(uint a, uint b) internal pure returns (uint) {
130         if (a == 0) {
131             return 0;
132         }
133 
134         uint c = a * b;
135         require(c / a == b, "SafeMath: multiplication overflow");
136 
137         return c;
138     }
139     function div(uint a, uint b) internal pure returns (uint) {
140         return div(a, b, "SafeMath: division by zero");
141     }
142     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
143         // Solidity only automatically asserts when dividing by 0
144         require(b > 0, errorMessage);
145         uint c = a / b;
146 
147         return c;
148     }
149 }
150 
151 library Address {
152     function isContract(address account) internal view returns (bool) {
153         bytes32 codehash;
154         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
155         // solhint-disable-next-line no-inline-assembly
156         assembly { codehash := extcodehash(account) }
157         return (codehash != 0x0 && codehash != accountHash);
158     }
159 }
160 
161 library SafeERC20 {
162     using SafeMath for uint;
163     using Address for address;
164 
165     function safeTransfer(IERC20 token, address to, uint value) internal {
166         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
167     }
168 
169     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
170         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
171     }
172 
173     function safeApprove(IERC20 token, address spender, uint value) internal {
174         require((value == 0) || (token.allowance(address(this), spender) == 0),
175             "SafeERC20: approve from non-zero to non-zero allowance"
176         );
177         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
178     }
179     function callOptionalReturn(IERC20 token, bytes memory data) private {
180         require(address(token).isContract(), "SafeERC20: call to non-contract");
181 
182         // solhint-disable-next-line avoid-low-level-calls
183         (bool success, bytes memory returndata) = address(token).call(data);
184         require(success, "SafeERC20: low-level call failed");
185 
186         if (returndata.length > 0) { // Return data is optional
187             // solhint-disable-next-line max-line-length
188             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
189         }
190     }
191 }
192 
193 contract oXoFarm  is ERC20, ERC20Detailed {
194   using SafeERC20 for IERC20;
195   using Address for address;
196   using SafeMath for uint;
197   
198   
199   address public governance;
200   mapping (address => bool) public minters;
201 
202   constructor () public ERC20Detailed("OXO.Farm", "OXO", 18) {
203       governance = msg.sender;
204   }
205 
206   function mint(address account, uint amount) public {
207       require(minters[msg.sender], "!minter");
208       _mint(account, amount);
209   }
210   
211   function setGovernance(address _governance) public {
212       require(msg.sender == governance, "!governance");
213       governance = _governance;
214   }
215   
216   function addMinter(address _minter) public {
217       require(msg.sender == governance, "!governance");
218       minters[_minter] = true;
219   }
220   
221   function removeMinter(address _minter) public {
222       require(msg.sender == governance, "!governance");
223       minters[_minter] = false;
224   }
225 }