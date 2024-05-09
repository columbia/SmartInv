1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-08
3 */
4 
5 pragma solidity ^0.5.17;
6 
7 /**
8  ********************************************************************
9  * 
10 
11  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------. 
12 | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
13 | |  ____  ____  | || |  _________   | || |      __      | || |  _______     | || | ____    ____ | || |  _________   | || |  _______     | |
14 | | |_  _||_  _| | || | |_   ___  |  | || |     /  \     | || | |_   __ \    | || ||_   \  /   _|| || | |_   ___  |  | || | |_   __ \    | |
15 | |   \ \  / /   | || |   | |_  \_|  | || |    / /\ \    | || |   | |__) |   | || |  |   \/   |  | || |   | |_  \_|  | || |   | |__) |   | |
16 | |    \ \/ /    | || |   |  _|      | || |   / ____ \   | || |   |  __ /    | || |  | |\  /| |  | || |   |  _|  _   | || |   |  __ /    | |
17 | |    _|  |_    | || |  _| |_       | || | _/ /    \ \_ | || |  _| |  \ \_  | || | _| |_\/_| |_ | || |  _| |___/ |  | || |  _| |  \ \_  | |
18 | |   |______|   | || | |_____|      | || ||____|  |____|| || | |____| |___| | || ||_____||_____|| || | |_________|  | || | |____| |___| | |
19 | |              | || |              | || |              | || |              | || |              | || |              | || |              | |
20 | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
21  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 
22 
23 
24  ********************************************************************
25  */
26 
27 interface IERC20 {
28     function totalSupply() external view returns (uint);
29     function balanceOf(address account) external view returns (uint);
30     function transfer(address recipient, uint amount) external returns (bool);
31     function allowance(address owner, address spender) external view returns (uint);
32     function approve(address spender, uint amount) external returns (bool);
33     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
34     event Transfer(address indexed from, address indexed to, uint value);
35     event Approval(address indexed owner, address indexed spender, uint value);
36 }
37 
38 contract Context {
39     constructor () internal { }
40     // solhint-disable-previous-line no-empty-blocks
41 
42     function _msgSender() internal view returns (address payable) {
43         return msg.sender;
44     }
45 }
46 
47 contract ERC20 is Context, IERC20 {
48     using SafeMath for uint;
49 
50     mapping (address => uint) private _balances;
51 
52     mapping (address => mapping (address => uint)) private _allowances;
53 
54     uint private _totalSupply;
55     function totalSupply() public view returns (uint) {
56         return _totalSupply;
57     }
58     function balanceOf(address account) public view returns (uint) {
59         return _balances[account];
60     }
61     function transfer(address recipient, uint amount) public returns (bool) {
62         _transfer(_msgSender(), recipient, amount);
63         return true;
64     }
65     function allowance(address owner, address spender) public view returns (uint) {
66         return _allowances[owner][spender];
67     }
68     function approve(address spender, uint amount) public returns (bool) {
69         _approve(_msgSender(), spender, amount);
70         return true;
71     }
72     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
73         _transfer(sender, recipient, amount);
74         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
75         return true;
76     }
77     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
78         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
79         return true;
80     }
81     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
82         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
83         return true;
84     }
85     function _transfer(address sender, address recipient, uint amount) internal {
86         require(sender != address(0), "ERC20: transfer from the zero address");
87         require(recipient != address(0), "ERC20: transfer to the zero address");
88 
89         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
90         _balances[recipient] = _balances[recipient].add(amount);
91         emit Transfer(sender, recipient, amount);
92     }
93     function _mint(address account, uint amount) internal {
94         require(account != address(0), "ERC20: mint to the zero address");
95 
96         _totalSupply = _totalSupply.add(amount);
97         _balances[account] = _balances[account].add(amount);
98         emit Transfer(address(0), account, amount);
99     }
100     function _burn(address account, uint amount) internal {
101         require(account != address(0), "ERC20: burn from the zero address");
102 
103         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
104         _totalSupply = _totalSupply.sub(amount);
105         emit Transfer(account, address(0), amount);
106     }
107     function _approve(address owner, address spender, uint amount) internal {
108         require(owner != address(0), "ERC20: approve from the zero address");
109         require(spender != address(0), "ERC20: approve to the zero address");
110 
111         _allowances[owner][spender] = amount;
112         emit Approval(owner, spender, amount);
113     }
114 }
115 
116 contract ERC20Detailed is IERC20 {
117     string private _name;
118     string private _symbol;
119     uint8 private _decimals;
120 
121     constructor (string memory name, string memory symbol, uint8 decimals) public {
122         _name = name;
123         _symbol = symbol;
124         _decimals = decimals;
125     }
126     function name() public view returns (string memory) {
127         return _name;
128     }
129     function symbol() public view returns (string memory) {
130         return _symbol;
131     }
132     function decimals() public view returns (uint8) {
133         return _decimals;
134     }
135 }
136 
137 library SafeMath {
138     function add(uint a, uint b) internal pure returns (uint) {
139         uint c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144     function sub(uint a, uint b) internal pure returns (uint) {
145         return sub(a, b, "SafeMath: subtraction overflow");
146     }
147     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
148         require(b <= a, errorMessage);
149         uint c = a - b;
150 
151         return c;
152     }
153     function mul(uint a, uint b) internal pure returns (uint) {
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163     function div(uint a, uint b) internal pure returns (uint) {
164         return div(a, b, "SafeMath: division by zero");
165     }
166     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
167         // Solidity only automatically asserts when dividing by 0
168         require(b > 0, errorMessage);
169         uint c = a / b;
170 
171         return c;
172     }
173 }
174 
175 library Address {
176     function isContract(address account) internal view returns (bool) {
177         bytes32 codehash;
178         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
179         // solhint-disable-next-line no-inline-assembly
180         assembly { codehash := extcodehash(account) }
181         return (codehash != 0x0 && codehash != accountHash);
182     }
183 }
184 
185 library SafeERC20 {
186     using SafeMath for uint;
187     using Address for address;
188 
189     function safeTransfer(IERC20 token, address to, uint value) internal {
190         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
191     }
192 
193     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
194         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
195     }
196 
197     function safeApprove(IERC20 token, address spender, uint value) internal {
198         require((value == 0) || (token.allowance(address(this), spender) == 0),
199             "SafeERC20: approve from non-zero to non-zero allowance"
200         );
201         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
202     }
203     function callOptionalReturn(IERC20 token, bytes memory data) private {
204         require(address(token).isContract(), "SafeERC20: call to non-contract");
205 
206         // solhint-disable-next-line avoid-low-level-calls
207         (bool success, bytes memory returndata) = address(token).call(data);
208         require(success, "SafeERC20: low-level call failed");
209 
210         if (returndata.length > 0) { // Return data is optional
211             // solhint-disable-next-line max-line-length
212             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
213         }
214     }
215 }
216 
217 contract YFARMER is ERC20, ERC20Detailed {
218   using SafeERC20 for IERC20;
219   using Address for address;
220   using SafeMath for uint;
221 
222 
223   address public governance;
224   mapping (address => bool) public minters;
225 
226   constructor (address newOwner) public ERC20Detailed("YFarmLand Token", "YFARMER", 18) {
227       governance = msg.sender;
228       _mint(newOwner,6000000000000000000000);
229       
230   }
231 
232   function mint(address account, uint256 amount) public {
233       require(minters[msg.sender], "!minter");
234       _mint(account, amount);
235   }
236 
237   function setGovernance(address _governance) public {
238       require(msg.sender == governance, "!governance");
239       governance = _governance;
240   }
241 
242   function addMinter(address _minter) public {
243       require(msg.sender == governance, "!governance");
244       minters[_minter] = true;
245   }
246 
247   function removeMinter(address _minter) public {
248       require(msg.sender == governance, "!governance");
249       minters[_minter] = false;
250   }
251 }