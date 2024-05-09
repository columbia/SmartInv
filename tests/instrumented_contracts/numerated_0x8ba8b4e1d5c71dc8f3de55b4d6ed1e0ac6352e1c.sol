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
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function balanceOf(address account) external view returns (uint256);
15     function transfer(address recipient, uint256 amount) external returns (bool);
16     function allowance(address owner, address spender) external view returns (uint256);
17     function approve(address spender, uint256 amount) external returns (bool);
18     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
19     event Transfer(address indexed from, address indexed to, uint256 value);
20     event Approval(address indexed owner, address indexed spender, uint256 value);
21 }
22 library SafeMath {
23     function add(uint256 a, uint256 b) internal pure returns (uint256) {
24         uint256 c = a + b;
25         require(c >= a, "SafeMath: addition overflow");
26         return c;
27     }
28     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
29         return sub(a, b, "SafeMath: subtraction overflow");
30     }
31     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
32         require(b <= a, errorMessage);
33         uint256 c = a - b;
34         return c;
35     }
36     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
37         if (a == 0) {
38             return 0;
39         }
40         uint256 c = a * b;
41         require(c / a == b, "SafeMath: multiplication overflow");
42         return c;
43     }
44     function div(uint256 a, uint256 b) internal pure returns (uint256) {
45         return div(a, b, "SafeMath: division by zero");
46     }
47     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
48         require(b > 0, errorMessage);
49         uint256 c = a / b;
50         return c;
51     }
52     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
53         return mod(a, b, "SafeMath: modulo by zero");
54     }
55     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
56         require(b != 0, errorMessage);
57         return a % b;
58     }
59 }
60 contract ERC20 is Context, IERC20 {
61     using SafeMath for uint256;
62     mapping (address => uint256) private _balances;
63     mapping (address => mapping (address => uint256)) private _allowances;
64     uint256 private _totalSupply;
65     function totalSupply() public view returns (uint256) {
66         return _totalSupply;
67     }
68     function balanceOf(address account) public view returns (uint256) {
69         return _balances[account];
70     }
71     function transfer(address recipient, uint256 amount) public returns (bool) {
72         _transfer(_msgSender(), recipient, amount);
73         return true;
74     }
75     function allowance(address owner, address spender) public view returns (uint256) {
76         return _allowances[owner][spender];
77     }
78     function approve(address spender, uint256 amount) public returns (bool) {
79         _approve(_msgSender(), spender, amount);
80         return true;
81     }
82     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
83         _transfer(sender, recipient, amount);
84         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
85         return true;
86     }
87     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
88         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
89         return true;
90     }
91     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
92         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
93         return true;
94     }
95     function _transfer(address sender, address recipient, uint256 amount) internal {
96         require(sender != address(0), "ERC20: transfer from the zero address");
97         require(recipient != address(0), "ERC20: transfer to the zero address");
98         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
99         _balances[recipient] = _balances[recipient].add(amount);
100         emit Transfer(sender, recipient, amount);
101     }
102     function _mint(address account, uint256 amount) internal {
103         require(account != address(0), "ERC20: mint to the zero address");
104         _totalSupply = _totalSupply.add(amount);
105         _balances[account] = _balances[account].add(amount);
106         emit Transfer(address(0), account, amount);
107     }
108     function _burn(address account, uint256 amount) internal {
109         require(account != address(0), "ERC20: burn from the zero address");
110 
111         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
112         _totalSupply = _totalSupply.sub(amount);
113         emit Transfer(account, address(0), amount);
114     }
115     function _approve(address owner, address spender, uint256 amount) internal {
116         require(owner != address(0), "ERC20: approve from the zero address");
117         require(spender != address(0), "ERC20: approve to the zero address");
118 
119         _allowances[owner][spender] = amount;
120         emit Approval(owner, spender, amount);
121     }
122     function _burnFrom(address account, uint256 amount) internal {
123         _burn(account, amount);
124         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
125     }
126 }
127 library Roles {
128     struct Role {
129         mapping (address => bool) bearer;
130     }
131     function add(Role storage role, address account) internal {
132         require(!has(role, account), "Roles: account already has role");
133         role.bearer[account] = true;
134     }
135     function remove(Role storage role, address account) internal {
136         require(has(role, account), "Roles: account does not have role");
137         role.bearer[account] = false;
138     }
139     function has(Role storage role, address account) internal view returns (bool) {
140         require(account != address(0), "Roles: account is the zero address");
141         return role.bearer[account];
142     }
143 }
144 contract PauserRole is Context {
145     using Roles for Roles.Role;
146     event PauserAdded(address indexed account);
147     event PauserRemoved(address indexed account);
148     Roles.Role private _pausers;
149     constructor () internal {
150         _addPauser(_msgSender());
151     }
152     modifier onlyPauser() {
153         require(isPauser(_msgSender()), "PauserRole: caller does not have the Pauser role");
154         _;
155     }
156     function isPauser(address account) public view returns (bool) {
157         return _pausers.has(account);
158     }
159     function addPauser(address account) public onlyPauser {
160         _addPauser(account);
161     }
162     function renouncePauser() public {
163         _removePauser(_msgSender());
164     }
165     function _addPauser(address account) internal {
166         _pausers.add(account);
167         emit PauserAdded(account);
168     }
169     function _removePauser(address account) internal {
170         _pausers.remove(account);
171         emit PauserRemoved(account);
172     }
173 }
174 contract Pausable is Context, PauserRole {
175     event Paused(address account);
176     event Unpaused(address account);
177     bool private _paused;
178     constructor () internal {
179         _paused = false;
180     }
181     function paused() public view returns (bool) {
182         return _paused;
183     }
184     modifier whenNotPaused() {
185         require(!_paused, "Pausable: paused");
186         _;
187     }
188     modifier whenPaused() {
189         require(_paused, "Pausable: not paused");
190         _;
191     }
192     function pause() public onlyPauser whenNotPaused {
193         _paused = true;
194         emit Paused(_msgSender());
195     }
196     function unpause() public onlyPauser whenPaused {
197         _paused = false;
198         emit Unpaused(_msgSender());
199     }
200 }
201 contract ERC20Pausable is ERC20, Pausable {
202     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
203         return super.transfer(to, value);
204     }
205     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
206         return super.transferFrom(from, to, value);
207     }
208     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
209         return super.approve(spender, value);
210     }
211     function increaseAllowance(address spender, uint256 addedValue) public whenNotPaused returns (bool) {
212         return super.increaseAllowance(spender, addedValue);
213     }
214     function decreaseAllowance(address spender, uint256 subtractedValue) public whenNotPaused returns (bool) {
215         return super.decreaseAllowance(spender, subtractedValue);
216     }
217 }
218 contract Ownable is Context {
219     address private _owner;
220     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
221     constructor () internal {
222         address msgSender = _msgSender();
223         _owner = msgSender;
224         emit OwnershipTransferred(address(0), msgSender);
225     }
226     function owner() public view returns (address) {
227         return _owner;
228     }
229     modifier onlyOwner() {
230         require(isOwner(), "Ownable: caller is not the owner");
231         _;
232     }
233     function isOwner() public view returns (bool) {
234         return _msgSender() == _owner;
235     }
236     function renounceOwnership() public onlyOwner {
237         emit OwnershipTransferred(_owner, address(0));
238         _owner = address(0);
239     }
240     function transferOwnership(address newOwner) public onlyOwner {
241         _transferOwnership(newOwner);
242     }
243     function _transferOwnership(address newOwner) internal {
244         require(newOwner != address(0), "Ownable: new owner is the zero address");
245         emit OwnershipTransferred(_owner, newOwner);
246         _owner = newOwner;
247     }
248 }
249 library Address {
250     function isContract(address account) internal view returns (bool) {
251         bytes32 codehash;
252         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
253         assembly { codehash := extcodehash(account) }
254         return (codehash != accountHash && codehash != 0x0);
255     }
256     function toPayable(address account) internal pure returns (address payable) {
257         return address(uint160(account));
258     }
259     function sendValue(address payable recipient, uint256 amount) internal {
260         require(address(this).balance >= amount, "Address: insufficient balance");
261         (bool success, ) = recipient.call.value(amount)("");
262         require(success, "Address: unable to send value, recipient may have reverted");
263     }
264 }
265 library SafeERC20 {
266     using SafeMath for uint256;
267     using Address for address;
268     function safeTransfer(IERC20 token, address to, uint256 value) internal {
269         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
270     }
271     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
272         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
273     }
274     function safeApprove(IERC20 token, address spender, uint256 value) internal {
275         require((value == 0) || (token.allowance(address(this), spender) == 0),
276             "SafeERC20: approve from non-zero to non-zero allowance"
277         );
278         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
279     }
280     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
281         uint256 newAllowance = token.allowance(address(this), spender).add(value);
282         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
283     }
284     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
285         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
286         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
287     }
288     function callOptionalReturn(IERC20 token, bytes memory data) private {
289         require(address(token).isContract(), "SafeERC20: call to non-contract");
290         (bool success, bytes memory returndata) = address(token).call(data);
291         require(success, "SafeERC20: low-level call failed");
292         if (returndata.length > 0) {
293             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
294         }
295     }
296 }
297 
298 pragma solidity ^0.5.2;
299 contract TokenLock {
300   using SafeERC20 for IERC20;
301   IERC20 private _token;
302   address private _beneficiary;
303   uint256 private _releaseTime;
304   address private _owner;
305   bool private _ownable;
306   event UnLock(address _receiver, uint256 _amount);
307   event Retrieve(address _receiver, uint256 _amount);
308   modifier onlyOwner() {
309     require(isOwnable());
310     require(msg.sender == _owner);
311     _;
312   }
313   constructor(IERC20 token, address beneficiary, address owner, uint256 releaseTime, bool ownable) public {
314     _owner = owner;
315     _token = token;
316     _beneficiary = beneficiary;
317     _releaseTime = releaseTime;
318     _ownable = ownable;
319   }
320   function isOwnable() public view returns (bool) {
321     return _ownable;
322   }
323   function owner() public view returns (address) {
324     return _owner;
325   }
326   function token() public view returns (IERC20) {
327     return _token;
328   }
329   function beneficiary() public view returns (address) {
330     return _beneficiary;
331   }
332   function releaseTime() public view returns (uint256) {
333     return _releaseTime;
334   }
335   function release() public {
336     require(block.timestamp >= _releaseTime);
337     uint256 amount = _token.balanceOf(address(this));
338     require(amount > 0);
339     _token.safeTransfer(_beneficiary, amount);
340     emit UnLock(_beneficiary, amount);
341   }
342   function retrieve() onlyOwner public {
343     uint256 amount = _token.balanceOf(address(this));
344     require(amount > 0);
345     _token.safeTransfer(_owner, amount);
346     emit Retrieve(_owner, amount);
347   }
348 }
349 contract IPC is ERC20Pausable, Ownable {
350   string public constant name = "Index Protocol Coin";
351   string public constant symbol = "IPC";
352   uint public constant decimals = 18;
353   uint public constant INITIAL_SUPPLY = 5000000000 * (10 ** decimals);
354   mapping (address => address) public lockStatus;
355   event Lock(address _receiver, uint256 _amount);
356   constructor() public {
357     _mint(msg.sender, INITIAL_SUPPLY);
358   }
359   function lockToken(address beneficiary, uint256 amount, uint256 releaseTime, bool isOwnable) onlyOwner public {
360     TokenLock lockContract = new TokenLock(this, beneficiary, msg.sender, releaseTime, isOwnable);
361 
362     transfer(address(lockContract), amount);
363     lockStatus[beneficiary] = address(lockContract);
364     emit Lock(beneficiary, amount);
365   }
366 }