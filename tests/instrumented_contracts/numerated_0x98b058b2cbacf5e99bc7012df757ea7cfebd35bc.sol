1 pragma solidity ^0.5.17;
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
14 interface IDetailed {
15     function name() external view returns (string memory);
16     function symbol() external view returns (string memory);
17     function decimals() external view returns (uint8);
18 }
19 
20 contract Context {
21     constructor () internal { }
22     // solhint-disable-previous-line no-empty-blocks
23 
24     function _msgSender() internal view returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 contract ERC20 is Context, IERC20 {
35     using SafeMath for uint256;
36 
37     mapping (address => uint256) private _balances;
38 
39     mapping (address => mapping (address => uint256)) private _allowances;
40 
41     uint256 private _totalSupply;
42     function totalSupply() public view returns (uint256) {
43         return _totalSupply;
44     }
45     function balanceOf(address account) public view returns (uint256) {
46         return _balances[account];
47     }
48     function transfer(address recipient, uint256 amount) public returns (bool) {
49         _transfer(_msgSender(), recipient, amount);
50         return true;
51     }
52     function allowance(address owner, address spender) public view returns (uint256) {
53         return _allowances[owner][spender];
54     }
55     function approve(address spender, uint256 amount) public returns (bool) {
56         _approve(_msgSender(), spender, amount);
57         return true;
58     }
59     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
60         _transfer(sender, recipient, amount);
61         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
62         return true;
63     }
64     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
65         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
66         return true;
67     }
68     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
69         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
70         return true;
71     }
72     function _transfer(address sender, address recipient, uint256 amount) internal {
73         require(sender != address(0), "ERC20: transfer from the zero address");
74         require(recipient != address(0), "ERC20: transfer to the zero address");
75 
76         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
77         _balances[recipient] = _balances[recipient].add(amount);
78         emit Transfer(sender, recipient, amount);
79     }
80     function _mint(address account, uint256 amount) internal {
81         require(account != address(0), "ERC20: mint to the zero address");
82 
83         _totalSupply = _totalSupply.add(amount);
84         _balances[account] = _balances[account].add(amount);
85         emit Transfer(address(0), account, amount);
86     }
87     function _burn(address account, uint256 amount) internal {
88         require(account != address(0), "ERC20: burn from the zero address");
89 
90         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
91         _totalSupply = _totalSupply.sub(amount);
92         emit Transfer(account, address(0), amount);
93     }
94     function _approve(address owner, address spender, uint256 amount) internal {
95         require(owner != address(0), "ERC20: approve from the zero address");
96         require(spender != address(0), "ERC20: approve to the zero address");
97 
98         _allowances[owner][spender] = amount;
99         emit Approval(owner, spender, amount);
100     }
101     function _burnFrom(address account, uint256 amount) internal {
102         _burn(account, amount);
103         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
104     }
105 }
106 
107 library SafeMath {
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111 
112         return c;
113     }
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         return sub(a, b, "SafeMath: subtraction overflow");
116     }
117     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
118         require(b <= a, errorMessage);
119         uint256 c = a - b;
120 
121         return c;
122     }
123     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
124         if (a == 0) {
125             return 0;
126         }
127 
128         uint256 c = a * b;
129         require(c / a == b, "SafeMath: multiplication overflow");
130 
131         return c;
132     }
133     function div(uint256 a, uint256 b) internal pure returns (uint256) {
134         return div(a, b, "SafeMath: division by zero");
135     }
136     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
137         // Solidity only automatically asserts when dividing by 0
138         require(b > 0, errorMessage);
139         uint256 c = a / b;
140 
141         return c;
142     }
143     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
144         return mod(a, b, "SafeMath: modulo by zero");
145     }
146     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b != 0, errorMessage);
148         return a % b;
149     }
150 }
151 
152 library Address {
153     function isContract(address account) internal view returns (bool) {
154         bytes32 codehash;
155         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
156         // solhint-disable-next-line no-inline-assembly
157         assembly { codehash := extcodehash(account) }
158         return (codehash != 0x0 && codehash != accountHash);
159     }
160     function toPayable(address account) internal pure returns (address payable) {
161         return address(uint160(account));
162     }
163     function sendValue(address payable recipient, uint256 amount) internal {
164         require(address(this).balance >= amount, "Address: insufficient balance");
165 
166         // solhint-disable-next-line avoid-call-value
167         (bool success, ) = recipient.call.value(amount)("");
168         require(success, "Address: unable to send value, recipient may have reverted");
169     }
170 }
171 
172 library SafeERC20 {
173     using SafeMath for uint256;
174     using Address for address;
175 
176     function safeTransfer(IERC20 token, address to, uint256 value) internal {
177         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
178     }
179 
180     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
181         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
182     }
183 
184     function safeApprove(IERC20 token, address spender, uint256 value) internal {
185         require((value == 0) || (token.allowance(address(this), spender) == 0),
186             "SafeERC20: approve from non-zero to non-zero allowance"
187         );
188         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
189     }
190 
191     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
192         uint256 newAllowance = token.allowance(address(this), spender).add(value);
193         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
194     }
195 
196     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
197         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
198         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
199     }
200     function callOptionalReturn(IERC20 token, bytes memory data) private {
201         require(address(token).isContract(), "SafeERC20: call to non-contract");
202 
203         // solhint-disable-next-line avoid-low-level-calls
204         (bool success, bytes memory returndata) = address(token).call(data);
205         require(success, "SafeERC20: low-level call failed");
206 
207         if (returndata.length > 0) { // Return data is optional
208             // solhint-disable-next-line max-line-length
209             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
210         }
211     }
212 }
213 
214 interface Controller {
215     function withdraw(address, uint) external;
216     function balanceOf(address) external view returns (uint);
217     function earn(address, uint) external;
218 }
219 
220 contract yVault is ERC20 {
221     using SafeERC20 for IERC20;
222     using Address for address;
223     using SafeMath for uint256;
224 
225     IERC20 public token;
226 
227     uint public min = 9990;
228     uint public constant max = 10000;
229 
230     address public governance;
231     address public controller;
232     
233     string public name;
234     string public symbol;
235     uint8 public decimals;
236 
237     constructor (address _token, address _controller) public {
238         name = string(abi.encodePacked("yearn ", IDetailed(_token).name()));
239         symbol = string(abi.encodePacked("yv", IDetailed(_token).symbol()));
240         decimals = IDetailed(_token).decimals();
241         
242         token = IERC20(_token);
243         governance = msg.sender;
244         controller = _controller;
245     }
246     
247     function setName(string calldata _name) external {
248         require(msg.sender == governance, "!governance");
249         name = _name;
250     }
251     
252     function setSymbol(string calldata _symbol) external {
253         require(msg.sender == governance, "!governance");
254         symbol = _symbol;
255     }
256 
257     function balance() public view returns (uint) {
258         return token.balanceOf(address(this))
259                 .add(Controller(controller).balanceOf(address(token)));
260     }
261 
262     function setMin(uint _min) external {
263         require(msg.sender == governance, "!governance");
264         min = _min;
265     }
266 
267     function setGovernance(address _governance) public {
268         require(msg.sender == governance, "!governance");
269         governance = _governance;
270     }
271 
272     function setController(address _controller) public {
273         require(msg.sender == governance, "!governance");
274         controller = _controller;
275     }
276 
277     // Custom logic in here for how much the vault allows to be borrowed
278     // Sets minimum required on-hand to keep small withdrawals cheap
279     function available() public view returns (uint) {
280         return token.balanceOf(address(this)).mul(min).div(max);
281     }
282 
283     function earn() public {
284         uint _bal = available();
285         token.safeTransfer(controller, _bal);
286         Controller(controller).earn(address(token), _bal);
287     }
288 
289     function depositAll() external {
290         deposit(token.balanceOf(msg.sender));
291     }
292 
293     function deposit(uint _amount) public {
294         uint _pool = balance();
295         uint _before = token.balanceOf(address(this));
296         token.safeTransferFrom(msg.sender, address(this), _amount);
297         uint _after = token.balanceOf(address(this));
298         _amount = _after.sub(_before); // Additional check for deflationary tokens
299         uint shares = 0;
300         if (totalSupply() == 0) {
301             shares = _amount;
302         } else {
303             shares = (_amount.mul(totalSupply())).div(_pool);
304         }
305         _mint(msg.sender, shares);
306     }
307 
308     function withdrawAll() external {
309         withdraw(balanceOf(msg.sender));
310     }
311 
312     // No rebalance implementation for lower fees and faster swaps
313     function withdraw(uint _shares) public {
314         uint r = (balance().mul(_shares)).div(totalSupply());
315         _burn(msg.sender, _shares);
316 
317         // Check balance
318         uint b = token.balanceOf(address(this));
319         if (b < r) {
320             uint _withdraw = r.sub(b);
321             Controller(controller).withdraw(address(token), _withdraw);
322             uint _after = token.balanceOf(address(this));
323             uint _diff = _after.sub(b);
324             if (_diff < _withdraw) {
325                 r = b.add(_diff);
326             }
327         }
328 
329         token.safeTransfer(msg.sender, r);
330     }
331 
332     function getPricePerFullShare() public view returns (uint) {
333         return balance().mul(1e18).div(totalSupply());
334     }
335 }