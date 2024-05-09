1 /**
2  *Submitted for verification at Etherscan.io on 2020-10-10
3 */
4 
5 pragma solidity ^0.5.17;
6 
7 interface IERC20 {
8     function totalSupply() external view returns (uint256);
9     function balanceOf(address account) external view returns (uint256);
10     function transfer(address recipient, uint256 amount) external returns (bool);
11     function allowance(address owner, address spender) external view returns (uint256);
12     function approve(address spender, uint256 amount) external returns (bool);
13     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
14     event Transfer(address indexed from, address indexed to, uint256 value);
15     event Approval(address indexed owner, address indexed spender, uint256 value);
16 }
17 
18 contract Context {
19     constructor () internal { }
20     // solhint-disable-previous-line no-empty-blocks
21 
22     function _msgSender() internal view returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 contract ERC20 is Context, IERC20 {
33     using SafeMath for uint256;
34 
35     mapping (address => uint256) private _balances;
36 
37     mapping (address => mapping (address => uint256)) private _allowances;
38 
39     uint256 private _totalSupply;
40     function totalSupply() public view returns (uint256) {
41         return _totalSupply;
42     }
43     function balanceOf(address account) public view returns (uint256) {
44         return _balances[account];
45     }
46     function transfer(address recipient, uint256 amount) public returns (bool) {
47         _transfer(_msgSender(), recipient, amount);
48         return true;
49     }
50     function allowance(address owner, address spender) public view returns (uint256) {
51         return _allowances[owner][spender];
52     }
53     function approve(address spender, uint256 amount) public returns (bool) {
54         _approve(_msgSender(), spender, amount);
55         return true;
56     }
57     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
58         _transfer(sender, recipient, amount);
59         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
60         return true;
61     }
62     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
63         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
64         return true;
65     }
66     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
67         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
68         return true;
69     }
70     function _transfer(address sender, address recipient, uint256 amount) internal {
71         require(sender != address(0), "ERC20: transfer from the zero address");
72         require(recipient != address(0), "ERC20: transfer to the zero address");
73 
74         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
75         _balances[recipient] = _balances[recipient].add(amount);
76         emit Transfer(sender, recipient, amount);
77     }
78     function _mint(address account, uint256 amount) internal {
79         require(account != address(0), "ERC20: mint to the zero address");
80 
81         _totalSupply = _totalSupply.add(amount);
82         _balances[account] = _balances[account].add(amount);
83         emit Transfer(address(0), account, amount);
84     }
85     function _burn(address account, uint256 amount) internal {
86         require(account != address(0), "ERC20: burn from the zero address");
87 
88         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
89         _totalSupply = _totalSupply.sub(amount);
90         emit Transfer(account, address(0), amount);
91     }
92     function _approve(address owner, address spender, uint256 amount) internal {
93         require(owner != address(0), "ERC20: approve from the zero address");
94         require(spender != address(0), "ERC20: approve to the zero address");
95 
96         _allowances[owner][spender] = amount;
97         emit Approval(owner, spender, amount);
98     }
99     function _burnFrom(address account, uint256 amount) internal {
100         _burn(account, amount);
101         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
102     }
103 }
104 
105 contract ERC20Detailed is IERC20 {
106     string private _name;
107     string private _symbol;
108     uint8 private _decimals;
109 
110     constructor (string memory name, string memory symbol, uint8 decimals) public {
111         _name = name;
112         _symbol = symbol;
113         _decimals = decimals;
114     }
115     function name() public view returns (string memory) {
116         return _name;
117     }
118     function symbol() public view returns (string memory) {
119         return _symbol;
120     }
121     function decimals() public view returns (uint8) {
122         return _decimals;
123     }
124 }
125 
126 library SafeMath {
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, "SafeMath: addition overflow");
130 
131         return c;
132     }
133     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
134         return sub(a, b, "SafeMath: subtraction overflow");
135     }
136     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         require(b <= a, errorMessage);
138         uint256 c = a - b;
139 
140         return c;
141     }
142     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
143         if (a == 0) {
144             return 0;
145         }
146 
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149 
150         return c;
151     }
152     function div(uint256 a, uint256 b) internal pure returns (uint256) {
153         return div(a, b, "SafeMath: division by zero");
154     }
155     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         // Solidity only automatically asserts when dividing by 0
157         require(b > 0, errorMessage);
158         uint256 c = a / b;
159 
160         return c;
161     }
162     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
163         return mod(a, b, "SafeMath: modulo by zero");
164     }
165     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b != 0, errorMessage);
167         return a % b;
168     }
169 }
170 
171 library Address {
172     function isContract(address account) internal view returns (bool) {
173         bytes32 codehash;
174         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
175         // solhint-disable-next-line no-inline-assembly
176         assembly { codehash := extcodehash(account) }
177         return (codehash != 0x0 && codehash != accountHash);
178     }
179     function toPayable(address account) internal pure returns (address payable) {
180         return address(uint160(account));
181     }
182     function sendValue(address payable recipient, uint256 amount) internal {
183         require(address(this).balance >= amount, "Address: insufficient balance");
184 
185         // solhint-disable-next-line avoid-call-value
186         (bool success, ) = recipient.call.value(amount)("");
187         require(success, "Address: unable to send value, recipient may have reverted");
188     }
189 }
190 
191 library SafeERC20 {
192     using SafeMath for uint256;
193     using Address for address;
194 
195     function safeTransfer(IERC20 token, address to, uint256 value) internal {
196         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
197     }
198 
199     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
200         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
201     }
202 
203     function safeApprove(IERC20 token, address spender, uint256 value) internal {
204         require((value == 0) || (token.allowance(address(this), spender) == 0),
205             "SafeERC20: approve from non-zero to non-zero allowance"
206         );
207         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
208     }
209 
210     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
211         uint256 newAllowance = token.allowance(address(this), spender).add(value);
212         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
213     }
214 
215     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
216         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
217         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
218     }
219     function callOptionalReturn(IERC20 token, bytes memory data) private {
220         require(address(token).isContract(), "SafeERC20: call to non-contract");
221 
222         // solhint-disable-next-line avoid-low-level-calls
223         (bool success, bytes memory returndata) = address(token).call(data);
224         require(success, "SafeERC20: low-level call failed");
225 
226         if (returndata.length > 0) { // Return data is optional
227             // solhint-disable-next-line max-line-length
228             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
229         }
230     }
231 }
232 
233 interface Controller {
234     function withdraw(address, uint) external;
235     function balanceOf(address) external view returns (uint);
236     function earn(address, uint) external;
237 }
238 
239 contract yVault is ERC20, ERC20Detailed {
240     using SafeERC20 for IERC20;
241     using Address for address;
242     using SafeMath for uint256;
243 
244     IERC20 public token;
245 
246     uint public min = 9990;
247     uint public constant max = 10000;
248 
249     address public governance;
250     address public controller;
251 
252     constructor (address _token, address _controller) public ERC20Detailed(
253         string(abi.encodePacked("yearn ", ERC20Detailed(_token).name())),
254         string(abi.encodePacked("y", ERC20Detailed(_token).symbol())),
255         ERC20Detailed(_token).decimals()
256     ) {
257         token = IERC20(_token);
258         governance = msg.sender;
259         controller = _controller;
260     }
261 
262     function balance() public view returns (uint) {
263         return token.balanceOf(address(this))
264                 .add(Controller(controller).balanceOf(address(token)));
265     }
266 
267     function setMin(uint _min) external {
268         require(msg.sender == governance, "!governance");
269         min = _min;
270     }
271 
272     function setGovernance(address _governance) public {
273         require(msg.sender == governance, "!governance");
274         governance = _governance;
275     }
276 
277     function setController(address _controller) public {
278         require(msg.sender == governance, "!governance");
279         controller = _controller;
280     }
281 
282     // Custom logic in here for how much the vault allows to be borrowed
283     // Sets minimum required on-hand to keep small withdrawals cheap
284     function available() public view returns (uint) {
285         return token.balanceOf(address(this)).mul(min).div(max);
286     }
287 
288     function earn() public {
289         uint _bal = available();
290         token.safeTransfer(controller, _bal);
291         Controller(controller).earn(address(token), _bal);
292     }
293 
294     function depositAll() external {
295         deposit(token.balanceOf(msg.sender));
296     }
297 
298     function deposit(uint _amount) public {
299         uint _pool = balance();
300         uint _before = token.balanceOf(address(this));
301         token.safeTransferFrom(msg.sender, address(this), _amount);
302         uint _after = token.balanceOf(address(this));
303         _amount = _after.sub(_before); // Additional check for deflationary tokens
304         uint shares = 0;
305         if (totalSupply() == 0) {
306             shares = _amount;
307         } else {
308             shares = (_amount.mul(totalSupply())).div(_pool);
309         }
310         _mint(msg.sender, shares);
311     }
312 
313     function withdrawAll() external {
314         withdraw(balanceOf(msg.sender));
315     }
316 
317     // No rebalance implementation for lower fees and faster swaps
318     function withdraw(uint _shares) public {
319         uint r = (balance().mul(_shares)).div(totalSupply());
320         _burn(msg.sender, _shares);
321 
322         // Check balance
323         uint b = token.balanceOf(address(this));
324         if (b < r) {
325             uint _withdraw = r.sub(b);
326             Controller(controller).withdraw(address(token), _withdraw);
327             uint _after = token.balanceOf(address(this));
328             uint _diff = _after.sub(b);
329             if (_diff < _withdraw) {
330                 r = b.add(_diff);
331             }
332         }
333 
334         token.safeTransfer(msg.sender, r);
335     }
336 
337     function getPricePerFullShare() public view returns (uint) {
338         return balance().mul(1e18).div(totalSupply());
339     }
340 }