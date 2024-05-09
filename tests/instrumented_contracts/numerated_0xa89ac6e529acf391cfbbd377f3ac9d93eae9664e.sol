1 /* Keep4r – kp4r.network 2020 */
2 
3 pragma solidity ^0.6.6;
4 
5 interface IERC20 {
6     function totalSupply() external view returns (uint);
7     function balanceOf(address account) external view returns (uint);
8     function transfer(address recipient, uint amount) external returns (bool);
9     function allowance(address owner, address spender) external view returns (uint);
10     function approve(address spender, uint amount) external returns (bool);
11     function transferFrom(address sender, address recipient, uint amount) external returns (bool);
12     event Transfer(address indexed from, address indexed to, uint value);
13     event Approval(address indexed owner, address indexed spender, uint value);
14 }
15 
16 contract Context {
17     constructor () internal { }
18     // solhint-disable-previous-line no-empty-blocks
19 
20     function _msgSender() internal view returns (address payable) {
21         return msg.sender;
22     }
23 }
24 
25 contract ERC20 is Context, IERC20 {
26     using SafeMath for uint;
27 
28     mapping (address => uint) private _balances;
29 
30     mapping (address => mapping (address => uint)) private _allowances;
31 
32     uint private _totalSupply;
33     function totalSupply() public view override returns (uint) {
34         return _totalSupply;
35     }
36     function balanceOf(address account) public view override returns (uint) {
37         return _balances[account];
38     }
39     function transfer(address recipient, uint amount) public override returns (bool) {
40         _transfer(_msgSender(), recipient, amount);
41         return true;
42     }
43     function allowance(address owner, address spender) public view override returns (uint) {
44         return _allowances[owner][spender];
45     }
46     function approve(address spender, uint amount) public override returns (bool) {
47         _approve(_msgSender(), spender, amount);
48         return true;
49     }
50     function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
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
94 abstract contract ERC20Detailed is IERC20 {
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
114 
115 library SafeMath {
116     function add(uint a, uint b) internal pure returns (uint) {
117         uint c = a + b;
118         require(c >= a, "SafeMath: addition overflow");
119 
120         return c;
121     }
122     function sub(uint a, uint b) internal pure returns (uint) {
123         return sub(a, b, "SafeMath: subtraction overflow");
124     }
125     function sub(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
126         require(b <= a, errorMessage);
127         uint c = a - b;
128 
129         return c;
130     }
131     function mul(uint a, uint b) internal pure returns (uint) {
132         if (a == 0) {
133             return 0;
134         }
135 
136         uint c = a * b;
137         require(c / a == b, "SafeMath: multiplication overflow");
138 
139         return c;
140     }
141     function div(uint a, uint b) internal pure returns (uint) {
142         return div(a, b, "SafeMath: division by zero");
143     }
144     function div(uint a, uint b, string memory errorMessage) internal pure returns (uint) {
145         // Solidity only automatically asserts when dividing by 0
146         require(b > 0, errorMessage);
147         uint c = a / b;
148 
149         return c;
150     }
151 }
152 
153 library Address {
154     function isContract(address account) internal view returns (bool) {
155         bytes32 codehash;
156         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
157         // solhint-disable-next-line no-inline-assembly
158         assembly { codehash := extcodehash(account) }
159         return (codehash != 0x0 && codehash != accountHash);
160     }
161 }
162 
163 library SafeERC20 {
164     using SafeMath for uint;
165     using Address for address;
166 
167     function safeTransfer(IERC20 token, address to, uint value) internal {
168         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
169     }
170 
171     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
172         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
173     }
174 
175     function safeApprove(IERC20 token, address spender, uint value) internal {
176         require((value == 0) || (token.allowance(address(this), spender) == 0),
177             "SafeERC20: approve from non-zero to non-zero allowance"
178         );
179         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
180     }
181     function callOptionalReturn(IERC20 token, bytes memory data) private {
182         require(address(token).isContract(), "SafeERC20: call to non-contract");
183 
184         // solhint-disable-next-line avoid-low-level-calls
185         (bool success, bytes memory returndata) = address(token).call(data);
186         require(success, "SafeERC20: low-level call failed");
187 
188         if (returndata.length > 0) { // Return data is optional
189             // solhint-disable-next-line max-line-length
190             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
191         }
192     }
193 }
194 
195 /* Keep4r – kp4r.network */
196 contract Keep4rToken is ERC20, ERC20Detailed {
197     using SafeERC20 for IERC20;
198     using Address for address;
199     using SafeMath for uint;
200 
201     address public governance;
202     address public governancePending;
203     mapping (address => bool) public minters;
204 
205     /** @notice The keeper logic and governance token: KP4R (this contract),
206       * have been decoupled. Seperating the keeper/jobs logic and governance logic,
207       * from the token. Allows greater flexibility and room for further innovation 
208       * and improvment on the Keeper/Jobs and democratic protocols. 
209      */
210     constructor () public ERC20Detailed("Keep4r", "KP4R", 18) {
211         governance = msg.sender;
212         _mint(msg.sender, 100000e18); 
213     }
214 
215     /** @notice governance, via token holders, can decide to mint more tokens. */
216     function mint(address account, uint amount) public {
217         require(minters[msg.sender], "only minter");
218         _mint(account, amount);
219     }
220 
221     /** @notice governance, via token holders, can decide to burn tokens. */
222     function burn(uint amount) public {
223          require(msg.sender == governance, "only governance");
224          // limitation on power:
225          // token can only be burnt from the governance account.
226         _burn(msg.sender, amount);
227     }
228 
229     /** @notice safely begin the governance transfer process. The new governance
230       * address, must accept the transfer. */
231     function transferGovernance(address _governance) public {
232         require(msg.sender == governance, "!governance");
233         governancePending = _governance;
234     }
235 
236     /** @notice to complete the governance transfer process new governance
237      * address, must accept the transfer. */
238     function acceptGovernance() public {
239         require(msg.sender == governancePending, "!governancePending");
240         governance = governancePending;
241     }
242 
243     /** @notice governance can add new minters */
244     function addMinter(address _minter) public {
245         require(msg.sender == governance, "!governance");
246         minters[_minter] = true;
247     }
248 
249     /** @notice governance can remove minters */
250     function removeMinter(address _minter) public {
251         require(msg.sender == governance, "!governance");
252         minters[_minter] = false;
253     }
254 
255 }