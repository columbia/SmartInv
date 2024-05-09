1 /**
2  *
3  *            https://ulu.finance
4  *
5  *       $$\   $$\ $$\      $$\   $$\
6  *       $$ |  $$ |$$ |     $$ |  $$ |
7  *       $$ |  $$ |$$ |     $$ |  $$ |
8  *       $$ |  $$ |$$ |     $$ |  $$ |
9  *       $$ |  $$ |$$ |     $$ |  $$ |
10  *       $$ |  $$ |$$ |     $$ |  $$ |
11  *       \$$$$$$  |$$$$$$$$\\$$$$$$  |
12  *        \______/ \________|\______/
13  *
14  *         Universal Liquidity Union
15  *
16  *            https://ulu.finance
17  *
18  **/
19 
20 pragma solidity ^0.5.16;
21 
22 interface IERC20 {
23     function totalSupply() external view returns (uint);
24     function balanceOf(address account) external view returns (uint);
25     function transfer(address recipient, uint amount) external returns (bool);
26     function allowance(address owner, address spender) external view returns (uint);
27     function approve(address spender, uint amount) external returns (bool);
28     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
29     event Transfer(address indexed from, address indexed to, uint value);
30     event Approval(address indexed owner, address indexed spender, uint value);
31 }
32 
33 contract Context {
34     constructor () internal { }
35     // solhint-disable-previous-line no-empty-blocks
36 
37     function _msgSender() internal view returns (address payable) {
38         return msg.sender;
39     }
40 }
41 
42 contract ERC20 is Context, IERC20 {
43     using SafeMath for uint;
44 
45     mapping (address => uint) private _balances;
46 
47     mapping (address => mapping (address => uint)) private _allowances;
48 
49     uint private _totalSupply;
50     function totalSupply() public view returns (uint) {
51         return _totalSupply;
52     }
53     function balanceOf(address account) public view returns (uint) {
54         return _balances[account];
55     }
56     function transfer(address recipient, uint amount) public returns (bool) {
57         _transfer(_msgSender(), recipient, amount);
58         return true;
59     }
60     function allowance(address owner, address spender) public view returns (uint) {
61         return _allowances[owner][spender];
62     }
63     function approve(address spender, uint amount) public returns (bool) {
64         _approve(_msgSender(), spender, amount);
65         return true;
66     }
67     function transferFrom(address sender, address recipient, uint amount) public returns (bool) {
68         _transfer(sender, recipient, amount);
69         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
70         return true;
71     }
72     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
73         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
74         return true;
75     }
76     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
77         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
78         return true;
79     }
80     function _transfer(address sender, address recipient, uint amount) internal {
81         require(sender != address(0), "ERC20: transfer from the zero address");
82         require(recipient != address(0), "ERC20: transfer to the zero address");
83 
84         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
85         _balances[recipient] = _balances[recipient].add(amount);
86         emit Transfer(sender, recipient, amount);
87     }
88     function _mint(address account, uint amount) internal {
89         require(account != address(0), "ERC20: mint to the zero address");
90 
91         _totalSupply = _totalSupply.add(amount);
92         _balances[account] = _balances[account].add(amount);
93         emit Transfer(address(0), account, amount);
94     }
95     function _burn(address account, uint amount) internal {
96         require(account != address(0), "ERC20: burn from the zero address");
97 
98         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
99         _totalSupply = _totalSupply.sub(amount);
100         emit Transfer(account, address(0), amount);
101     }
102     function _approve(address owner, address spender, uint amount) internal {
103         require(owner != address(0), "ERC20: approve from the zero address");
104         require(spender != address(0), "ERC20: approve to the zero address");
105 
106         _allowances[owner][spender] = amount;
107         emit Approval(owner, spender, amount);
108     }
109 }
110 
111 contract ERC20Detailed is IERC20 {
112     string private _name;
113     string private _symbol;
114     uint8 private _decimals;
115 
116     constructor (string memory name, string memory symbol, uint8 decimals) public {
117         _name = name;
118         _symbol = symbol;
119         _decimals = decimals;
120     }
121     function name() public view returns (string memory) {
122         return _name;
123     }
124     function symbol() public view returns (string memory) {
125         return _symbol;
126     }
127     function decimals() public view returns (uint8) {
128         return _decimals;
129     }
130 }
131 
132 library SafeMath {
133     function add(uint a, uint b) internal pure returns (uint) {
134         uint c = a + b;
135         require(c >= a, "SafeMath: addition overflow");
136 
137         return c;
138     }
139     function sub(uint a, uint b) internal pure returns (uint) {
140         return sub(a, b, "SafeMath: subtraction overflow");
141     }
142     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
143         require(b <= a, errorMessage);
144         uint c = a - b;
145 
146         return c;
147     }
148     function mul(uint a, uint b) internal pure returns (uint) {
149         if (a == 0) {
150             return 0;
151         }
152 
153         uint c = a * b;
154         require(c / a == b, "SafeMath: multiplication overflow");
155 
156         return c;
157     }
158     function div(uint a, uint b) internal pure returns (uint) {
159         return div(a, b, "SafeMath: division by zero");
160     }
161     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
162         // Solidity only automatically asserts when dividing by 0
163         require(b > 0, errorMessage);
164         uint c = a / b;
165 
166         return c;
167     }
168 }
169 
170 library Address {
171     function isContract(address account) internal view returns (bool) {
172         bytes32 codehash;
173         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
174         // solhint-disable-next-line no-inline-assembly
175         assembly { codehash := extcodehash(account) }
176         return (codehash != 0x0 && codehash != accountHash);
177     }
178 }
179 
180 library SafeERC20 {
181     using SafeMath for uint;
182     using Address for address;
183 
184     function safeTransfer(IERC20 token, address to, uint value) internal {
185         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
186     }
187 
188     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
189         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
190     }
191 
192     function safeApprove(IERC20 token, address spender, uint value) internal {
193         require((value == 0) || (token.allowance(address(this), spender) == 0),
194             "SafeERC20: approve from non-zero to non-zero allowance"
195         );
196         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
197     }
198     function callOptionalReturn(IERC20 token, bytes memory data) private {
199         require(address(token).isContract(), "SafeERC20: call to non-contract");
200 
201         // solhint-disable-next-line avoid-low-level-calls
202         (bool success, bytes memory returndata) = address(token).call(data);
203         require(success, "SafeERC20: low-level call failed");
204 
205         if (returndata.length > 0) { // Return data is optional
206             // solhint-disable-next-line max-line-length
207             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
208         }
209     }
210 }
211 
212 contract ULU is ERC20, ERC20Detailed {
213     using SafeERC20 for IERC20;
214     using Address for address;
215     using SafeMath for uint;
216 
217     address public governance;
218     mapping (address => bool) public minters;
219 
220     uint public constant GRACE_PERIOD = 2 days;
221     mapping (address => uint) public pendingAddMinters;
222 
223     constructor () public ERC20Detailed("Universal Liquidity Union", "ULU", 18) {
224         governance = msg.sender;
225     }
226 
227     function mint(address account, uint256 amount) public {
228         require(minters[msg.sender], "!minter");
229         _mint(account, amount);
230     }
231 
232     function burn(uint256 amount) public {
233         _burn(msg.sender, amount);
234     }
235 
236     function setGovernance(address _governance) public {
237         require(msg.sender == governance, "!governance");
238         governance = _governance;
239     }
240 
241     function addMinter(address _minter) public {
242         require(msg.sender == governance, "!governance");
243         // this function will be disabled after Friday, September 4, 2020 11:00:00 PM (GMT+0)
244         require(block.timestamp < 1599217200);
245         minters[_minter] = true;
246     }
247 
248     function pendingAddMinter(address _minter) public {
249         require(msg.sender == governance, "!governance");
250         pendingAddMinters[_minter] = block.timestamp;
251     }
252 
253     function cancelAddMinter(address _minter) public {
254         require(msg.sender == governance, "!governance");
255         pendingAddMinters[_minter] = 0;
256     }
257 
258     function executeAddMinter(address _minter) public {
259         require(msg.sender == governance, "!governance");
260         require(pendingAddMinters[_minter] != 0 && now > pendingAddMinters[_minter] + GRACE_PERIOD);
261         minters[_minter] = true;
262         pendingAddMinters[_minter] = 0;
263     }
264 
265     function removeMinter(address _minter) public {
266         require(msg.sender == governance, "!governance");
267         minters[_minter] = false;
268     }
269 }