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
229 
230 
231 interface WETH {
232     function deposit() external payable;
233     function withdraw(uint wad) external;
234     event Deposit(address indexed dst, uint wad);
235     event Withdrawal(address indexed src, uint wad);
236 }
237 
238 interface Controller {
239     function withdraw(address, uint) external;
240     function balanceOf(address) external view returns (uint);
241     function earn(address, uint) external;
242 }
243 
244 contract yVault is ERC20, ERC20Detailed {
245     using SafeERC20 for IERC20;
246     using Address for address;
247     using SafeMath for uint256;
248 
249     IERC20 public token;
250 
251     uint public min = 9990;
252     uint public constant max = 10000;
253 
254     address public governance;
255     address public controller;
256 
257     constructor (address _token, address _controller) public ERC20Detailed(
258         string(abi.encodePacked("yearn ", ERC20Detailed(_token).name())),
259         string(abi.encodePacked("y", ERC20Detailed(_token).symbol())),
260         ERC20Detailed(_token).decimals()
261     ) {
262         token = IERC20(_token);
263         governance = msg.sender;
264         controller = _controller;
265     }
266 
267     function balance() public view returns (uint) {
268         return token.balanceOf(address(this))
269                 .add(Controller(controller).balanceOf(address(token)));
270     }
271 
272     function setMin(uint _min) external {
273         require(msg.sender == governance, "!governance");
274         min = _min;
275     }
276 
277     function setGovernance(address _governance) public {
278         require(msg.sender == governance, "!governance");
279         governance = _governance;
280     }
281 
282     function setController(address _controller) public {
283         require(msg.sender == governance, "!governance");
284         controller = _controller;
285     }
286 
287     // Custom logic in here for how much the vault allows to be borrowed
288     // Sets minimum required on-hand to keep small withdrawals cheap
289     function available() public view returns (uint) {
290         return token.balanceOf(address(this)).mul(min).div(max);
291     }
292 
293     function earn() public {
294         uint _bal = available();
295         token.safeTransfer(controller, _bal);
296         Controller(controller).earn(address(token), _bal);
297     }
298 
299     function depositAll() external {
300         deposit(token.balanceOf(msg.sender));
301     }
302 
303     function deposit(uint _amount) public {
304         uint _pool = balance();
305         uint _before = token.balanceOf(address(this));
306         token.safeTransferFrom(msg.sender, address(this), _amount);
307         uint _after = token.balanceOf(address(this));
308         _amount = _after.sub(_before); // Additional check for deflationary tokens
309         uint shares = 0;
310         if (totalSupply() == 0) {
311             shares = _amount;
312         } else {
313             shares = (_amount.mul(totalSupply())).div(_pool);
314         }
315         _mint(msg.sender, shares);
316     }
317 
318     function depositETH() public payable {
319         uint _pool = balance();
320         uint _before = token.balanceOf(address(this));
321         uint _amount = msg.value;
322         WETH(address(token)).deposit.value(_amount)();
323         uint _after = token.balanceOf(address(this));
324         _amount = _after.sub(_before); // Additional check for deflationary tokens
325         uint shares = 0;
326         if (totalSupply() == 0) {
327             shares = _amount;
328         } else {
329             shares = (_amount.mul(totalSupply())).div(_pool);
330         }
331         _mint(msg.sender, shares);
332     }
333 
334     function withdrawAll() external {
335         withdraw(balanceOf(msg.sender));
336     }
337 
338     function withdrawAllETH() external {
339         withdrawETH(balanceOf(msg.sender));
340     }
341 
342 
343     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
344     function harvest(address reserve, uint amount) external {
345         require(msg.sender == controller, "!controller");
346         require(reserve != address(token), "token");
347         IERC20(reserve).safeTransfer(controller, amount);
348     }
349 
350     // No rebalance implementation for lower fees and faster swaps
351     function withdraw(uint _shares) public {
352         uint r = (balance().mul(_shares)).div(totalSupply());
353         _burn(msg.sender, _shares);
354 
355         // Check balance
356         uint b = token.balanceOf(address(this));
357         if (b < r) {
358             uint _withdraw = r.sub(b);
359             Controller(controller).withdraw(address(token), _withdraw);
360             uint _after = token.balanceOf(address(this));
361             uint _diff = _after.sub(b);
362             if (_diff < _withdraw) {
363                 r = b.add(_diff);
364             }
365         }
366 
367         token.safeTransfer(msg.sender, r);
368     }
369 
370     // No rebalance implementation for lower fees and faster swaps
371     function withdrawETH(uint _shares) public {
372         uint r = (balance().mul(_shares)).div(totalSupply());
373         _burn(msg.sender, _shares);
374 
375         // Check balance
376         uint b = token.balanceOf(address(this));
377         if (b < r) {
378             uint _withdraw = r.sub(b);
379             Controller(controller).withdraw(address(token), _withdraw);
380             uint _after = token.balanceOf(address(this));
381             uint _diff = _after.sub(b);
382             if (_diff < _withdraw) {
383                 r = b.add(_diff);
384             }
385         }
386 
387         WETH(address(token)).withdraw(r);
388         address(msg.sender).transfer(r);
389     }
390 
391     function getPricePerFullShare() public view returns (uint) {
392         return balance().mul(1e18).div(totalSupply());
393     }
394     
395     function () external payable {
396         if (msg.sender != address(token)) {
397             depositETH();
398         }
399     }
400 }