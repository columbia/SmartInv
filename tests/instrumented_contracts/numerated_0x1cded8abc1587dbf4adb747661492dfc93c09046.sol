1 // SPDX-License-Identifier: SimPL-2.0
2 pragma solidity ^0.6.9;
3 
4 interface IERC20 {
5     function totalSupply() external view returns (uint256);
6     function balanceOf(address account) external view returns (uint256);
7     function transfer(address recipient, uint256 amount) external returns (bool);
8     function allowance(address owner, address spender) external view returns (uint256);
9     function approve(address spender, uint256 amount) external returns (bool);
10     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
11 
12     function mint(address account, uint amount) external;
13     function burn(address account, uint amount) external;
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 }
18 
19 contract Context {
20     constructor () internal { }
21     // solhint-disable-previous-line no-empty-blocks
22 
23     function _msgSender() internal view returns (address payable) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view returns (bytes memory) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 contract Ownable is Context {
34     address private _owner;
35 
36     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
37     constructor () internal {
38         _owner = _msgSender();
39         emit OwnershipTransferred(address(0), _owner);
40     }
41     function owner() public view returns (address) {
42         return _owner;
43     }
44     modifier onlyOwner() {
45         require(isOwner(), "Ownable: caller is not the owner");
46         _;
47     }
48     function isOwner() public view returns (bool) {
49         return _msgSender() == _owner;
50     }
51     function renounceOwnership() public onlyOwner {
52         emit OwnershipTransferred(_owner, address(0));
53         _owner = address(0);
54     }
55     function transferOwnership(address newOwner) public onlyOwner {
56         _transferOwnership(newOwner);
57     }
58     function _transferOwnership(address newOwner) internal {
59         require(newOwner != address(0), "Ownable: new owner is the zero address");
60         emit OwnershipTransferred(_owner, newOwner);
61         _owner = newOwner;
62     }
63 }
64 
65 abstract contract ERC20 is Context, IERC20 {
66     using SafeMath for uint256;
67 
68     mapping (address => uint256) private _balances;
69 
70     mapping (address => mapping (address => uint256)) private _allowances;
71 
72     uint256 private _totalSupply;
73     function totalSupply() public override view returns (uint256) {
74         return _totalSupply;
75     }
76     function balanceOf(address account) public override view returns (uint256) {
77         return _balances[account];
78     }
79     function transfer(address recipient, uint256 amount) public override returns (bool) {
80         _transfer(_msgSender(), recipient, amount);
81         return true;
82     }
83     function allowance(address owner, address spender) public override view returns (uint256) {
84         return _allowances[owner][spender];
85     }
86     function approve(address spender, uint256 amount) public override returns (bool) {
87         _approve(_msgSender(), spender, amount);
88         return true;
89     }
90     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
91         _transfer(sender, recipient, amount);
92         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
93         return true;
94     }
95     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
96         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
97         return true;
98     }
99     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
100         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
101         return true;
102     }
103     function _transfer(address sender, address recipient, uint256 amount) internal {
104         require(sender != address(0), "ERC20: transfer from the zero address");
105         require(recipient != address(0), "ERC20: transfer to the zero address");
106 
107         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
108         _balances[recipient] = _balances[recipient].add(amount);
109         emit Transfer(sender, recipient, amount);
110     }
111     function _mint(address account, uint256 amount) internal {
112         require(account != address(0), "ERC20: mint to the zero address");
113 
114         _totalSupply = _totalSupply.add(amount);
115         _balances[account] = _balances[account].add(amount);
116         emit Transfer(address(0), account, amount);
117     }
118     function _burn(address account, uint256 amount) internal {
119         require(account != address(0), "ERC20: burn from the zero address");
120 
121         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
122         _totalSupply = _totalSupply.sub(amount);
123         emit Transfer(account, address(0), amount);
124     }
125     function _approve(address owner, address spender, uint256 amount) internal {
126         require(owner != address(0), "ERC20: approve from the zero address");
127         require(spender != address(0), "ERC20: approve to the zero address");
128 
129         _allowances[owner][spender] = amount;
130         emit Approval(owner, spender, amount);
131     }
132     function _burnFrom(address account, uint256 amount) internal {
133         _burn(account, amount);
134         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
135     }
136 }
137 
138 
139 library SafeMath {
140     function add(uint256 a, uint256 b) internal pure returns (uint256) {
141         uint256 c = a + b;
142         require(c >= a, "SafeMath: addition overflow");
143 
144         return c;
145     }
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b <= a, errorMessage);
151         uint256 c = a - b;
152 
153         return c;
154     }
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165     function div(uint256 a, uint256 b) internal pure returns (uint256) {
166         return div(a, b, "SafeMath: division by zero");
167     }
168     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         // Solidity only automatically asserts when dividing by 0
170         require(b > 0, errorMessage);
171         uint256 c = a / b;
172 
173         return c;
174     }
175     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
176         return mod(a, b, "SafeMath: modulo by zero");
177     }
178     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
179         require(b != 0, errorMessage);
180         return a % b;
181     }
182 }
183 
184 library Address {
185     function isContract(address account) internal view returns (bool) {
186         bytes32 codehash;
187         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
188         // solhint-disable-next-line no-inline-assembly
189         assembly { codehash := extcodehash(account) }
190         return (codehash != 0x0 && codehash != accountHash);
191     }
192     function toPayable(address account) internal pure returns (address payable) {
193         return address(uint160(account));
194     }
195     
196     function sendValue(address payable recipient, uint256 amount) internal {
197         require(address(this).balance >= amount, "Address: insufficient balance");
198 
199         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
200         (bool success, ) = recipient.call{ value: amount }("");
201         require(success, "Address: unable to send value, recipient may have reverted");
202     }
203 }
204 
205 library SafeERC20 {
206     using SafeMath for uint256;
207     using Address for address;
208 
209     function safeTransfer(IERC20 token, address to, uint256 value) internal {
210         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
211     }
212 
213     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
214         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
215     }
216 
217     function safeApprove(IERC20 token, address spender, uint256 value) internal {
218         require((value == 0) || (token.allowance(address(this), spender) == 0),
219             "SafeERC20: approve from non-zero to non-zero allowance"
220         );
221         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
222     }
223 
224     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
225         uint256 newAllowance = token.allowance(address(this), spender).add(value);
226         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
227     }
228 
229     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
230         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
231         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
232     }
233     function callOptionalReturn(IERC20 token, bytes memory data) private {
234         require(address(token).isContract(), "SafeERC20: call to non-contract");
235 
236         // solhint-disable-next-line avoid-low-level-calls
237         (bool success, bytes memory returndata) = address(token).call(data);
238         require(success, "SafeERC20: low-level call failed");
239 
240         if (returndata.length > 0) { // Return data is optional
241             // solhint-disable-next-line max-line-length
242             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
243         }
244     }
245 }
246 
247 contract RewardPool is Ownable {
248     using SafeERC20 for IERC20;
249     using Address for address;
250     using SafeMath for uint256;
251     
252     event Deposit(address indexed user, address indexed lpToken, uint256 indexed pid, uint256 amount);
253     event Withdraw(address indexed user, address indexed lpToken, uint256 indexed pid, uint256 amount);
254 
255     struct UserInfo {
256         uint256 amount;
257     }
258 
259     struct PoolInfo {
260         IERC20 lpToken;
261         IERC20 yToken;
262     }
263     
264     PoolInfo[] public poolInfo;
265     mapping (uint256 => mapping (address => UserInfo)) public userInfo;
266 
267 
268     function add(IERC20 _lpToken, IERC20 _yToken) public onlyOwner {
269         poolInfo.push(PoolInfo({
270             lpToken: _lpToken,
271             yToken: _yToken
272         }));
273     }
274 
275 
276     function deposit(uint256 _pid, uint256 _amount) public {
277         require(_amount > 0, "not zero");
278 
279         poolInfo[_pid].lpToken.safeTransferFrom(address(msg.sender), address(this), _amount);
280         userInfo[_pid][msg.sender].amount = userInfo[_pid][msg.sender].amount.add(_amount);
281 
282         poolInfo[_pid].yToken.mint(msg.sender, _amount);
283 
284         emit Deposit(msg.sender, address(poolInfo[_pid].lpToken), _pid, _amount);
285     }
286 
287     function withdraw(uint256 _pid, uint256 _amount) public {    
288         require(_amount > 0, "not zero");    
289         require(userInfo[_pid][msg.sender].amount >= _amount, "withdraw: not good");
290   
291         poolInfo[_pid].yToken.burn(msg.sender, _amount);
292 
293         userInfo[_pid][msg.sender].amount = userInfo[_pid][msg.sender].amount.sub(_amount);
294         poolInfo[_pid].lpToken.safeTransfer(address(msg.sender), _amount);
295 
296         emit Withdraw(msg.sender, address(poolInfo[_pid].lpToken), _pid, _amount);
297     }
298     
299     function depositAll(uint256 _pid) external {
300         deposit(_pid, poolInfo[_pid].lpToken.balanceOf(msg.sender));
301     }
302 
303     function withdrawAll(uint256 _pid) external {
304         withdraw(_pid, userInfo[_pid][msg.sender].amount);
305     }
306 
307     function poolLength() external view returns (uint256) {
308         return poolInfo.length;
309     }
310 }
311 
