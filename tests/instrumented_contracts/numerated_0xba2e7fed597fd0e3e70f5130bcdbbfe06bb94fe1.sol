1 pragma solidity ^0.5.16;
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
15     constructor () internal { }
16     // solhint-disable-previous-line no-empty-blocks
17 
18     function _msgSender() internal view returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 contract ERC20 is Context, IERC20 {
29     using SafeMath for uint256;
30 
31     mapping (address => uint256) private _balances;
32 
33     mapping (address => mapping (address => uint256)) private _allowances;
34 
35     uint256 private _totalSupply;
36     function totalSupply() public view returns (uint256) {
37         return _totalSupply;
38     }
39     function balanceOf(address account) public view returns (uint256) {
40         return _balances[account];
41     }
42     function transfer(address recipient, uint256 amount) public returns (bool) {
43         _transfer(_msgSender(), recipient, amount);
44         return true;
45     }
46     function allowance(address owner, address spender) public view returns (uint256) {
47         return _allowances[owner][spender];
48     }
49     function approve(address spender, uint256 amount) public returns (bool) {
50         _approve(_msgSender(), spender, amount);
51         return true;
52     }
53     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
54         _transfer(sender, recipient, amount);
55         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
56         return true;
57     }
58     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
59         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
60         return true;
61     }
62     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
63         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
64         return true;
65     }
66     function _transfer(address sender, address recipient, uint256 amount) internal {
67         require(sender != address(0), "ERC20: transfer from the zero address");
68         require(recipient != address(0), "ERC20: transfer to the zero address");
69 
70         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
71         _balances[recipient] = _balances[recipient].add(amount);
72         emit Transfer(sender, recipient, amount);
73     }
74     function _mint(address account, uint256 amount) internal {
75         require(account != address(0), "ERC20: mint to the zero address");
76 
77         _totalSupply = _totalSupply.add(amount);
78         _balances[account] = _balances[account].add(amount);
79         emit Transfer(address(0), account, amount);
80     }
81     function _burn(address account, uint256 amount) internal {
82         require(account != address(0), "ERC20: burn from the zero address");
83 
84         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
85         _totalSupply = _totalSupply.sub(amount);
86         emit Transfer(account, address(0), amount);
87     }
88     function _approve(address owner, address spender, uint256 amount) internal {
89         require(owner != address(0), "ERC20: approve from the zero address");
90         require(spender != address(0), "ERC20: approve to the zero address");
91 
92         _allowances[owner][spender] = amount;
93         emit Approval(owner, spender, amount);
94     }
95     function _burnFrom(address account, uint256 amount) internal {
96         _burn(account, amount);
97         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
98     }
99 }
100 
101 contract ERC20Detailed is IERC20 {
102     string private _name;
103     string private _symbol;
104     uint8 private _decimals;
105 
106     constructor (string memory name, string memory symbol, uint8 decimals) public {
107         _name = name;
108         _symbol = symbol;
109         _decimals = decimals;
110     }
111     function name() public view returns (string memory) {
112         return _name;
113     }
114     function symbol() public view returns (string memory) {
115         return _symbol;
116     }
117     function decimals() public view returns (uint8) {
118         return _decimals;
119     }
120 }
121 
122 library SafeMath {
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a, "SafeMath: addition overflow");
126 
127         return c;
128     }
129     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
130         return sub(a, b, "SafeMath: subtraction overflow");
131     }
132     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
133         require(b <= a, errorMessage);
134         uint256 c = a - b;
135 
136         return c;
137     }
138     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
139         if (a == 0) {
140             return 0;
141         }
142 
143         uint256 c = a * b;
144         require(c / a == b, "SafeMath: multiplication overflow");
145 
146         return c;
147     }
148     function div(uint256 a, uint256 b) internal pure returns (uint256) {
149         return div(a, b, "SafeMath: division by zero");
150     }
151     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         // Solidity only automatically asserts when dividing by 0
153         require(b > 0, errorMessage);
154         uint256 c = a / b;
155 
156         return c;
157     }
158     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
159         return mod(a, b, "SafeMath: modulo by zero");
160     }
161     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b != 0, errorMessage);
163         return a % b;
164     }
165 }
166 
167 library Address {
168     function isContract(address account) internal view returns (bool) {
169         bytes32 codehash;
170         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
171         // solhint-disable-next-line no-inline-assembly
172         assembly { codehash := extcodehash(account) }
173         return (codehash != 0x0 && codehash != accountHash);
174     }
175     function toPayable(address account) internal pure returns (address payable) {
176         return address(uint160(account));
177     }
178     function sendValue(address payable recipient, uint256 amount) internal {
179         require(address(this).balance >= amount, "Address: insufficient balance");
180 
181         // solhint-disable-next-line avoid-call-value
182         (bool success, ) = recipient.call.value(amount)("");
183         require(success, "Address: unable to send value, recipient may have reverted");
184     }
185 }
186 
187 library SafeERC20 {
188     using SafeMath for uint256;
189     using Address for address;
190 
191     function safeTransfer(IERC20 token, address to, uint256 value) internal {
192         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
193     }
194 
195     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
196         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
197     }
198 
199     function safeApprove(IERC20 token, address spender, uint256 value) internal {
200         require((value == 0) || (token.allowance(address(this), spender) == 0),
201             "SafeERC20: approve from non-zero to non-zero allowance"
202         );
203         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
204     }
205 
206     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
207         uint256 newAllowance = token.allowance(address(this), spender).add(value);
208         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
209     }
210 
211     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
212         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
213         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
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
229 interface Controller {
230     function withdraw(address, uint) external;
231     function balanceOf(address) external view returns (uint);
232     function earn(address, uint) external;
233 }
234 
235 contract yVault is ERC20, ERC20Detailed {
236     using SafeERC20 for IERC20;
237     using Address for address;
238     using SafeMath for uint256;
239     
240     IERC20 public token;
241     
242     uint public min = 9500;
243     uint public constant max = 10000;
244     
245     address public governance;
246     address public controller;
247     
248     constructor (address _token, address _controller) public ERC20Detailed(
249         string(abi.encodePacked("yearn ", ERC20Detailed(_token).name())),
250         string(abi.encodePacked("y", ERC20Detailed(_token).symbol())),
251         ERC20Detailed(_token).decimals()
252     ) {
253         token = IERC20(_token);
254         governance = msg.sender;
255         controller = _controller;
256     }
257     
258     function balance() public view returns (uint) {
259         return token.balanceOf(address(this))
260                 .add(Controller(controller).balanceOf(address(token)));
261     }
262     
263     function setMin(uint _min) external {
264         require(msg.sender == governance, "!governance");
265         min = _min;
266     }
267     
268     function setGovernance(address _governance) public {
269         require(msg.sender == governance, "!governance");
270         governance = _governance;
271     }
272     
273     function setController(address _controller) public {
274         require(msg.sender == governance, "!governance");
275         controller = _controller;
276     }
277     
278     // Custom logic in here for how much the vault allows to be borrowed
279     // Sets minimum required on-hand to keep small withdrawals cheap
280     function available() public view returns (uint) {
281         return token.balanceOf(address(this)).mul(min).div(max);
282     }
283     
284     function earn() public {
285         uint _bal = available();
286         token.safeTransfer(controller, _bal);
287         Controller(controller).earn(address(token), _bal);
288     }
289     
290     function depositAll() external {
291         deposit(token.balanceOf(msg.sender));
292     }
293     
294     function deposit(uint _amount) public {
295         uint _pool = balance();
296         uint _before = token.balanceOf(address(this));
297         token.safeTransferFrom(msg.sender, address(this), _amount);
298         uint _after = token.balanceOf(address(this));
299         _amount = _after.sub(_before); // Additional check for deflationary tokens
300         uint shares = 0;
301         if (totalSupply() == 0) {
302             shares = _amount;
303         } else {
304             shares = (_amount.mul(totalSupply())).div(_pool);
305         }
306         _mint(msg.sender, shares);
307     }
308     
309     function withdrawAll() external {
310         withdraw(balanceOf(msg.sender));
311     }
312     
313     
314     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
315     function harvest(address reserve, uint amount) external {
316         require(msg.sender == controller, "!controller");
317         require(reserve != address(token), "token");
318         IERC20(reserve).safeTransfer(controller, amount);
319     }
320     
321     // No rebalance implementation for lower fees and faster swaps
322     function withdraw(uint _shares) public {
323         uint r = (balance().mul(_shares)).div(totalSupply());
324         _burn(msg.sender, _shares);
325         
326         // Check balance
327         uint b = token.balanceOf(address(this));
328         if (b < r) {
329             uint _withdraw = r.sub(b);
330             Controller(controller).withdraw(address(token), _withdraw);
331             uint _after = token.balanceOf(address(this));
332             uint _diff = _after.sub(b);
333             if (_diff < _withdraw) {
334                 r = b.add(_diff);
335             }
336         }
337         
338         token.safeTransfer(msg.sender, r);
339     }
340     
341     function getPricePerFullShare() public view returns (uint) {
342         return balance().mul(1e18).div(totalSupply());
343     }
344 }