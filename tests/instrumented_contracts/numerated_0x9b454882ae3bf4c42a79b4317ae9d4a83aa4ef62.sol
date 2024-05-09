1 pragma solidity ^0.5.0;
2 contract Context {
3     constructor () internal { }
4     function _msgSender() internal view returns (address payable) {
5         return msg.sender;
6     }
7     function _msgData() internal view returns (bytes memory) {
8         this;
9         return msg.data;
10     }
11 }
12 pragma solidity ^0.5.0;
13 interface IERC20 {
14     function totalSupply() external view returns (uint256);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 pragma solidity ^0.5.0;
24 library SafeMath {
25     function add(uint256 a, uint256 b) internal pure returns (uint256) {
26         uint256 c = a + b;
27         require(c >= a, "SafeMath: addition overflow");
28         return c;
29     }
30     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
31         return sub(a, b, "SafeMath: subtraction overflow");
32     }
33     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
34         require(b <= a, errorMessage);
35         uint256 c = a - b;
36         return c;
37     }
38     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
39         if (a == 0) {
40             return 0;
41         }
42         uint256 c = a * b;
43         require(c / a == b, "SafeMath: multiplication overflow");
44         return c;
45     }
46     function div(uint256 a, uint256 b) internal pure returns (uint256) {
47         return div(a, b, "SafeMath: division by zero");
48     }
49     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
50         require(b > 0, errorMessage);
51         uint256 c = a / b;
52         return c;
53     }
54     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
55         return mod(a, b, "SafeMath: modulo by zero");
56     }
57     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
58         require(b != 0, errorMessage);
59         return a % b;
60     }
61 }
62 pragma solidity ^0.5.0;
63 contract ERC20 is Context, IERC20 {
64     using SafeMath for uint256;
65     mapping (address => uint256) private _balances;
66     mapping (address => mapping (address => uint256)) private _allowances;
67     uint256 private _totalSupply;
68     function totalSupply() public view returns (uint256) {
69         return _totalSupply;
70     }
71     function balanceOf(address account) public view returns (uint256) {
72         return _balances[account];
73     }
74     function transfer(address recipient, uint256 amount) public returns (bool) {
75         _transfer(_msgSender(), recipient, amount);
76         return true;
77     }
78     function allowance(address owner, address spender) public view returns (uint256) {
79         return _allowances[owner][spender];
80     }
81     function approve(address spender, uint256 amount) public returns (bool) {
82         _approve(_msgSender(), spender, amount);
83         return true;
84     }
85     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
86         _transfer(sender, recipient, amount);
87         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
88         return true;
89     }
90     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
91         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
92         return true;
93     }
94     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
95         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
96         return true;
97     }
98     function _transfer(address sender, address recipient, uint256 amount) internal {
99         require(sender != address(0), "ERC20: transfer from the zero address");
100         require(recipient != address(0), "ERC20: transfer to the zero address");
101         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
102         _balances[recipient] = _balances[recipient].add(amount);
103         emit Transfer(sender, recipient, amount);
104     }
105     function _mint(address account, uint256 amount) internal {
106         require(account != address(0), "ERC20: mint to the zero address");
107         _totalSupply = _totalSupply.add(amount);
108         _balances[account] = _balances[account].add(amount);
109         emit Transfer(address(0), account, amount);
110     }
111     function _burn(address account, uint256 amount) internal {
112         require(account != address(0), "ERC20: burn from the zero address");
113         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
114         _totalSupply = _totalSupply.sub(amount);
115         emit Transfer(account, address(0), amount);
116     }
117     function _approve(address owner, address spender, uint256 amount) internal {
118         require(owner != address(0), "ERC20: approve from the zero address");
119         require(spender != address(0), "ERC20: approve to the zero address");
120         _allowances[owner][spender] = amount;
121         emit Approval(owner, spender, amount);
122     }
123     function _burnFrom(address account, uint256 amount) internal {
124         _burn(account, amount);
125         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
126     }
127 }
128 pragma solidity ^0.5.0;
129 library Roles {
130     struct Role {
131         mapping (address => bool) bearer;
132     }
133     function add(Role storage role, address account) internal {
134         require(!has(role, account), "Roles: account already has role");
135         role.bearer[account] = true;
136     }
137     function remove(Role storage role, address account) internal {
138         require(has(role, account), "Roles: account does not have role");
139         role.bearer[account] = false;
140     }
141     function has(Role storage role, address account) internal view returns (bool) {
142         require(account != address(0), "Roles: account is the zero address");
143         return role.bearer[account];
144     }
145 }
146 pragma solidity ^0.5.0;
147 contract PauserRole is Context {
148     using Roles for Roles.Role;
149     event PauserAdded(address indexed account);
150     event PauserRemoved(address indexed account);
151     Roles.Role private _pausers;
152     constructor () internal {
153         _addPauser(_msgSender());
154     }
155     modifier onlyPauser() {
156         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
157         _;
158     }
159     function isPauser(address account) public view returns (bool) {
160         return _pausers.has(account);
161     }
162     function addPauser(address account) public onlyPauser {
163         _addPauser(account);
164     }
165     function renouncePauser() public {
166         _removePauser(_msgSender());
167     }
168     function _addPauser(address account) internal {
169         _pausers.add(account);
170         emit PauserAdded(account);
171     }
172     function _removePauser(address account) internal {
173         _pausers.remove(account);
174         emit PauserRemoved(account);
175     }
176 }
177 pragma solidity ^0.5.0;
178 contract Pausable is Context, PauserRole {
179     event Paused(address account);
180     event Unpaused(address account);
181     bool private _paused;
182     constructor () internal {
183         _paused = false;
184     }
185     function paused() public view returns (bool) {
186         return _paused;
187     }
188     modifier whenNotPaused() {
189         require(!_paused, "Pausable: paused");
190         _;
191     }
192     modifier whenPaused() {
193         require(_paused, "Pausable: not paused");
194         _;
195     }
196     function pause() public onlyPauser whenNotPaused {
197         _paused = true;
198         emit Paused(_msgSender());
199     }
200     function unpause() public onlyPauser whenPaused {
201         _paused = false;
202         emit Unpaused(_msgSender());
203     }
204 }
205 pragma solidity ^0.5.0;
206 contract ERC20Pausable is ERC20, Pausable {
207     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
208         return super.transfer(to, value);
209     }
210     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
211         return super.transferFrom(from, to, value);
212     }
213     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
214         return super.approve(spender, value);
215     }
216     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
217         return super.increaseAllowance(spender, addedValue);
218     }
219     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
220         return super.decreaseAllowance(spender, subtractedValue);
221     }
222 }
223 pragma solidity ^0.5.0;
224 contract Ownable is Context {
225     address private _owner;
226     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
227     constructor () internal {
228         address msgSender = _msgSender();
229         _owner = msgSender;
230         emit OwnershipTransferred(address(0), msgSender);
231     }
232     function owner() public view returns (address) {
233         return _owner;
234     }
235     modifier onlyOwner() {
236         require(isOwner(), "Ownable: caller is not the owner");
237         _;
238     }
239     function isOwner() public view returns (bool) {
240         return _msgSender() == _owner;
241     }
242     function renounceOwnership() public onlyOwner {
243         emit OwnershipTransferred(_owner, address(0));
244         _owner = address(0);
245     }
246     function transferOwnership(address newOwner) public onlyOwner {
247         _transferOwnership(newOwner);
248     }
249     function _transferOwnership(address newOwner) internal {
250         require(newOwner != address(0), "Ownable: new owner is the zero address");
251         emit OwnershipTransferred(_owner, newOwner);
252         _owner = newOwner;
253     }
254 }
255 pragma solidity ^0.5.5;
256 library Address {
257     function isContract(address account) internal view returns (bool) {
258         bytes32 codehash;
259         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
260         assembly { codehash := extcodehash(account) }
261         return (codehash != accountHash && codehash != 0x0);
262     }
263     function toPayable(address account) internal pure returns (address payable) {
264         return address(uint160(account));
265     }
266     function sendValue(address payable recipient, uint256 amount) internal {
267         require(address(this).balance >= amount, "Address: insufficient balance");
268         (bool success, ) = recipient.call.value(amount)("");
269         require(success, "Address: unable to send value, recipient may have reverted");
270     }
271 }
272 pragma solidity ^0.5.0;
273 library SafeERC20 {
274     using SafeMath for uint256;
275     using Address for address;
276     function safeTransfer(IERC20 token, address to, uint256 value) internal {
277         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
278     }
279     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
280         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
281     }
282     function safeApprove(IERC20 token, address spender, uint256 value) internal {
283         require((value == 0) || (token.allowance(address(this), spender) == 0),
284             "SafeERC20: approve from non-zero to non-zero allowance"
285         );
286         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
287     }
288     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
289         uint256 newAllowance = token.allowance(address(this), spender).add(value);
290         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
291     }
292     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
293         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
294         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
295     }
296     function callOptionalReturn(IERC20 token, bytes memory data) private {
297         require(address(token).isContract(), "SafeERC20: call to non-contract");
298         (bool success, bytes memory returndata) = address(token).call(data);
299         require(success, "SafeERC20: low-level call failed");
300         if (returndata.length > 0) { // Return data is optional
301             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
302         }
303     }
304 }
305 pragma solidity ^0.5.2;
306 contract TokenLock {
307   using SafeERC20 for IERC20;
308   IERC20 private _token;
309   address private _beneficiary;
310   uint256 private _releaseTime;
311   address private _owner;
312   bool private _ownable;
313   event UnLock(address _receiver, uint256 _amount);
314   event Retrieve(address _receiver, uint256 _amount);
315   modifier onlyOwner() {
316     require(isOwnable());
317     require(msg.sender == _owner);
318     _;
319   }
320   constructor(IERC20 token, address beneficiary, address owner, uint256 releaseTime, bool ownable) public {
321     _owner = owner;
322     _token = token;
323     _beneficiary = beneficiary;
324     _releaseTime = releaseTime;
325     _ownable = ownable;
326   }
327   function isOwnable() public view returns (bool) {
328     return _ownable;
329   }
330   function owner() public view returns (address) {
331     return _owner;
332   }
333   function token() public view returns (IERC20) {
334     return _token;
335   }
336   function beneficiary() public view returns (address) {
337     return _beneficiary;
338   }
339   function releaseTime() public view returns (uint256) {
340     return _releaseTime;
341   }
342   function release() public {
343     require(block.timestamp >= _releaseTime);
344     uint256 amount = _token.balanceOf(address(this));
345     require(amount > 0);
346     _token.safeTransfer(_beneficiary, amount);
347     emit UnLock(_beneficiary, amount);
348   }
349   function retrieve() onlyOwner public {
350     uint256 amount = _token.balanceOf(address(this));
351     require(amount > 0);
352     _token.safeTransfer(_owner, amount);
353     emit Retrieve(_owner, amount);
354   }
355 }
356 pragma solidity ^0.5.2;
357 contract CBDJ is ERC20Pausable, Ownable {
358   string public constant name = "CBDJ Coin";
359   string public constant symbol = "CBDJ";
360   uint public constant decimals = 18;
361   uint public constant INITIAL_SUPPLY = 1000000000 * (10 ** decimals);
362   mapping (address => address) public lockStatus;
363   event Lock(address _receiver, uint256 _amount);
364   constructor() public {
365     _mint(msg.sender, INITIAL_SUPPLY);
366   }
367   function lockToken(address beneficiary, uint256 amount, uint256 releaseTime, bool isOwnable) onlyOwner public {
368     TokenLock lockContract = new TokenLock(this, beneficiary, msg.sender, releaseTime, isOwnable);
369     transfer(address(lockContract), amount);
370     lockStatus[beneficiary] = address(lockContract);
371     emit Lock(beneficiary, amount);
372   }
373 }