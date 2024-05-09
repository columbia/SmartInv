1 pragma solidity ^0.7.6;
2 
3 interface IERC20 {
4     function totalSupply() external view returns (uint256);
5     function balanceOf(address account) external view returns (uint256);
6     function transfer(address recipient, uint256 amount) external returns (bool);
7     function allowance(address owner, address spender) external view returns (uint256);
8     function approve(address spender, uint256 amount) external returns (bool);
9     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
10     event Transfer(address indexed from, address indexed to, uint256 value);
11     event Approval(address indexed owner, address indexed spender, uint256 value);
12 }
13 
14 contract Context {
15     constructor () { }
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
31     
32     function totalSupply() public view override returns (uint) {
33         return _totalSupply;
34     }
35     
36     function balanceOf(address account) public view override returns (uint) {
37         return _balances[account];
38     }
39     
40     function transfer(address recipient, uint amount) public override returns (bool) {
41         _transfer(_msgSender(), recipient, amount);
42         return true;
43     }
44     
45     function allowance(address owner, address spender) public view override returns (uint) {
46         return _allowances[owner][spender];
47     }
48     
49     function approve(address spender, uint amount) public override returns (bool) {
50         _approve(_msgSender(), spender, amount);
51         return true;
52     }
53     
54     function transferFrom(address sender, address recipient, uint amount) public override returns (bool) {
55         _transfer(sender, recipient, amount);
56         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
57         return true;
58     }
59     
60     function increaseAllowance(address spender, uint addedValue) public returns (bool) {
61         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
62         return true;
63     }
64     
65     function decreaseAllowance(address spender, uint subtractedValue) public returns (bool) {
66         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
67         return true;
68     }
69     
70     function _transfer(address sender, address recipient, uint amount) internal {
71         require(sender != address(0), "ERC20: transfer from the zero address");
72         require(recipient != address(0), "ERC20: transfer to the zero address");
73 
74         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
75         _balances[recipient] = _balances[recipient].add(amount);
76         emit Transfer(sender, recipient, amount);
77     }
78     
79     function _mint(address account, uint amount) internal {
80         require(account != address(0), "ERC20: mint to the zero address");
81 
82         _totalSupply = _totalSupply.add(amount);
83         _balances[account] = _balances[account].add(amount);
84         emit Transfer(address(0), account, amount);
85     }
86     
87     function _burn(address account, uint amount) internal {
88         require(account != address(0), "ERC20: burn from the zero address");
89 
90         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
91         _totalSupply = _totalSupply.sub(amount);
92         emit Transfer(account, address(0), amount);
93     }
94     
95     function _approve(address owner, address spender, uint amount) internal {
96         require(owner != address(0), "ERC20: approve from the zero address");
97         require(spender != address(0), "ERC20: approve to the zero address");
98 
99         _allowances[owner][spender] = amount;
100         emit Approval(owner, spender, amount);
101     }
102 }
103 
104 abstract contract ERC20Detailed is IERC20 {
105     string private _name;
106     string private _symbol;
107     uint8 private _decimals;
108 
109     constructor (string memory name_, string memory symbol_, uint8 decimals_) {
110         _name = name_;
111         _symbol = symbol_;
112         _decimals = decimals_;
113     }
114     
115     function name() public view returns (string memory) {
116         return _name;
117     }
118     
119     function symbol() public view returns (string memory) {
120         return _symbol;
121     }
122     
123     function decimals() public view returns (uint8) {
124         return _decimals;
125     }
126 }
127 
128 library SafeMath {
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
137         return sub(a, b, "SafeMath: subtraction overflow");
138     }
139 
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146     
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         if (a == 0) {
149             return 0;
150         }
151 
152         uint256 c = a * b;
153         require(c / a == b, "SafeMath: multiplication overflow");
154 
155         return c;
156     }
157 
158     
159     function div(uint256 a, uint256 b) internal pure returns (uint256) {
160         return div(a, b, "SafeMath: division by zero");
161     }
162 
163     
164     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         // Solidity only automatically asserts when dividing by 0
166         require(b > 0, errorMessage);
167         uint256 c = a / b;
168 
169         return c;
170     }
171 }
172 
173 
174 library Address {
175     function isContract(address account) internal view returns (bool) {
176         bytes32 codehash;
177         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
178         // solhint-disable-next-line no-inline-assembly
179         assembly { codehash := extcodehash(account) }
180         return (codehash != 0x0 && codehash != accountHash);
181     }
182 }
183 
184 library SafeERC20 {
185     using SafeMath for uint256;
186     using Address for address;
187 
188     function safeTransfer(IERC20 token, address to, uint256 value) internal {
189         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
190     }
191 
192     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
193         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
194     }
195 
196     function safeApprove(IERC20 token, address spender, uint256 value) internal {
197         require((value == 0) || (token.allowance(address(this), spender) == 0),
198             "SafeERC20: approve from non-zero to non-zero allowance"
199         );
200         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
201     }
202 
203     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
204         uint256 newAllowance = token.allowance(address(this), spender).add(value);
205         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
206     }
207 
208     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
209         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
210         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
211     }
212     
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
227 contract ISLAND is ERC20, ERC20Detailed {
228     using SafeERC20 for IERC20;
229     using Address for address;
230     using SafeMath for uint;
231     
232     address public governance;
233     mapping (address => bool) public minters;
234     
235     constructor () ERC20Detailed("Defiville Island Token", "ISLA", 18) {
236         governance = msg.sender;
237     }
238     
239     function mint(address account, uint amount) public {
240         require(minters[msg.sender], "!minter");
241         _mint(account, amount);
242     }
243     
244     function setGovernance(address _governance) public {
245         require(msg.sender == governance, "!governance");
246         governance = _governance;
247     }
248     
249     function addMinter(address _minter) public {
250         require(msg.sender == governance, "!governance");
251         minters[_minter] = true;
252     }
253     
254     function removeMinter(address _minter) public {
255         require(msg.sender == governance, "!governance");
256         minters[_minter] = false;
257     }
258 }