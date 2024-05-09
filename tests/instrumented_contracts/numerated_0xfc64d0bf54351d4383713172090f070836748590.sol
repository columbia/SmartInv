1 /**
2  *Submitted for verification at Etherscan.io on 2020-07-26
3 */
4 
5 pragma solidity ^0.5.16;
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
32 contract Ownable is Context {
33     address private _owner;
34 
35     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
36     constructor () internal {
37         _owner = _msgSender();
38         emit OwnershipTransferred(address(0), _owner);
39     }
40     function owner() public view returns (address) {
41         return _owner;
42     }
43     modifier onlyOwner() {
44         require(isOwner(), "Ownable: caller is not the owner");
45         _;
46     }
47     function isOwner() public view returns (bool) {
48         return _msgSender() == _owner;
49     }
50     function renounceOwnership() public onlyOwner {
51         emit OwnershipTransferred(_owner, address(0));
52         _owner = address(0);
53     }
54     function transferOwnership(address newOwner) public onlyOwner {
55         _transferOwnership(newOwner);
56     }
57     function _transferOwnership(address newOwner) internal {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         emit OwnershipTransferred(_owner, newOwner);
60         _owner = newOwner;
61     }
62 }
63 
64 contract ERC20 is Context, IERC20 {
65     using SafeMath for uint256;
66 
67     mapping (address => uint256) private _balances;
68 
69     mapping (address => mapping (address => uint256)) private _allowances;
70 
71     uint256 private _totalSupply;
72     function totalSupply() public view returns (uint256) {
73         return _totalSupply;
74     }
75     function balanceOf(address account) public view returns (uint256) {
76         return _balances[account];
77     }
78     function transfer(address recipient, uint256 amount) public returns (bool) {
79         _transfer(_msgSender(), recipient, amount);
80         return true;
81     }
82     function allowance(address owner, address spender) public view returns (uint256) {
83         return _allowances[owner][spender];
84     }
85     function approve(address spender, uint256 amount) public returns (bool) {
86         _approve(_msgSender(), spender, amount);
87         return true;
88     }
89     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
90         _transfer(sender, recipient, amount);
91         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
92         return true;
93     }
94     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
95         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
96         return true;
97     }
98     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
99         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
100         return true;
101     }
102     function _transfer(address sender, address recipient, uint256 amount) internal {
103         require(sender != address(0), "ERC20: transfer from the zero address");
104         require(recipient != address(0), "ERC20: transfer to the zero address");
105 
106         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
107         _balances[recipient] = _balances[recipient].add(amount);
108         emit Transfer(sender, recipient, amount);
109     }
110     function _mint(address account, uint256 amount) internal {
111         require(account != address(0), "ERC20: mint to the zero address");
112 
113         _totalSupply = _totalSupply.add(amount);
114         _balances[account] = _balances[account].add(amount);
115         emit Transfer(address(0), account, amount);
116     }
117     function _burn(address account, uint256 amount) internal {
118         require(account != address(0), "ERC20: burn from the zero address");
119 
120         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
121         _totalSupply = _totalSupply.sub(amount);
122         emit Transfer(account, address(0), amount);
123     }
124     function _approve(address owner, address spender, uint256 amount) internal {
125         require(owner != address(0), "ERC20: approve from the zero address");
126         require(spender != address(0), "ERC20: approve to the zero address");
127 
128         _allowances[owner][spender] = amount;
129         emit Approval(owner, spender, amount);
130     }
131     function _burnFrom(address account, uint256 amount) internal {
132         _burn(account, amount);
133         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
134     }
135 }
136 
137 contract ERC20Detailed is IERC20 {
138     string private _name;
139     string private _symbol;
140     uint8 private _decimals;
141 
142     constructor (string memory name, string memory symbol, uint8 decimals) public {
143         _name = name;
144         _symbol = symbol;
145         _decimals = decimals;
146     }
147     function name() public view returns (string memory) {
148         return _name;
149     }
150     function symbol() public view returns (string memory) {
151         return _symbol;
152     }
153     function decimals() public view returns (uint8) {
154         return _decimals;
155     }
156 }
157 
158 library SafeMath {
159     function add(uint256 a, uint256 b) internal pure returns (uint256) {
160         uint256 c = a + b;
161         require(c >= a, "SafeMath: addition overflow");
162 
163         return c;
164     }
165     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
166         return sub(a, b, "SafeMath: subtraction overflow");
167     }
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
175         if (a == 0) {
176             return 0;
177         }
178 
179         uint256 c = a * b;
180         require(c / a == b, "SafeMath: multiplication overflow");
181 
182         return c;
183     }
184     function div(uint256 a, uint256 b) internal pure returns (uint256) {
185         return div(a, b, "SafeMath: division by zero");
186     }
187     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188         // Solidity only automatically asserts when dividing by 0
189         require(b > 0, errorMessage);
190         uint256 c = a / b;
191 
192         return c;
193     }
194     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
195         return mod(a, b, "SafeMath: modulo by zero");
196     }
197     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b != 0, errorMessage);
199         return a % b;
200     }
201 }
202 
203 library Address {
204     function isContract(address account) internal view returns (bool) {
205         bytes32 codehash;
206         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
207         // solhint-disable-next-line no-inline-assembly
208         assembly { codehash := extcodehash(account) }
209         return (codehash != 0x0 && codehash != accountHash);
210     }
211     function toPayable(address account) internal pure returns (address payable) {
212         return address(uint160(account));
213     }
214     function sendValue(address payable recipient, uint256 amount) internal {
215         require(address(this).balance >= amount, "Address: insufficient balance");
216 
217         // solhint-disable-next-line avoid-call-value
218         (bool success, ) = recipient.call.value(amount)("");
219         require(success, "Address: unable to send value, recipient may have reverted");
220     }
221 }
222 
223 library SafeERC20 {
224     using SafeMath for uint256;
225     using Address for address;
226 
227     function safeTransfer(IERC20 token, address to, uint256 value) internal {
228         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
229     }
230 
231     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
232         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
233     }
234 
235     function safeApprove(IERC20 token, address spender, uint256 value) internal {
236         require((value == 0) || (token.allowance(address(this), spender) == 0),
237             "SafeERC20: approve from non-zero to non-zero allowance"
238         );
239         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
240     }
241 
242     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
243         uint256 newAllowance = token.allowance(address(this), spender).add(value);
244         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
245     }
246 
247     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
248         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
249         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
250     }
251     function callOptionalReturn(IERC20 token, bytes memory data) private {
252         require(address(token).isContract(), "SafeERC20: call to non-contract");
253 
254         // solhint-disable-next-line avoid-low-level-calls
255         (bool success, bytes memory returndata) = address(token).call(data);
256         require(success, "SafeERC20: low-level call failed");
257 
258         if (returndata.length > 0) { // Return data is optional
259             // solhint-disable-next-line max-line-length
260             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
261         }
262     }
263 }
264 
265 interface Controller {
266     function withdraw(address, uint) external;
267     function balanceOf(address) external view returns (uint);
268     function earn(address, uint) external;
269 }
270 
271 contract afiVault is ERC20, ERC20Detailed {
272   using SafeERC20 for IERC20;
273   using Address for address;
274   using SafeMath for uint256;
275 
276   IERC20 public token;
277   
278   uint public min = 9500;
279   uint public constant max = 10000;
280   
281   address public governance;
282   address public controller;
283 
284   constructor (address _token, address _controller) public ERC20Detailed(
285       string(abi.encodePacked("afi ", ERC20Detailed(_token).name())),
286       string(abi.encodePacked("afi", ERC20Detailed(_token).symbol())),
287       ERC20Detailed(_token).decimals()
288   ) {
289       token = IERC20(_token);
290       governance = msg.sender;
291       controller = _controller;
292   }
293   
294   function balance() public view returns (uint) {
295       return token.balanceOf(address(this))
296              .add(Controller(controller).balanceOf(address(token)));
297   }
298   
299   function setMin(uint _min) external {
300       require(msg.sender == governance, "!governance");
301       min = _min;
302   }
303   
304   function setGovernance(address _governance) public {
305       require(msg.sender == governance, "!governance");
306       governance = _governance;
307   }
308   
309   function setController(address _controller) public {
310       require(msg.sender == governance, "!governance");
311       controller = _controller;
312   }
313   
314   // Custom logic in here for how much the vault allows to be borrowed
315   // Sets minimum required on-hand to keep small withdrawals cheap
316   function available() public view returns (uint) {
317       return token.balanceOf(address(this)).mul(min).div(max);
318   }
319   
320   function earn() public {
321       uint _bal = available();
322       token.safeTransfer(controller, _bal);
323       Controller(controller).earn(address(token), _bal);
324   }
325 
326   function deposit(uint _amount) external {
327       uint _pool = balance();
328       token.safeTransferFrom(msg.sender, address(this), _amount);
329       uint shares = 0;
330       if (_pool == 0) {
331         shares = _amount;
332       } else {
333         shares = (_amount.mul(totalSupply())).div(_pool);
334       }
335       _mint(msg.sender, shares);
336   }
337 
338   // No rebalance implementation for lower fees and faster swaps
339   function withdraw(uint _shares) external {
340       uint r = (balance().mul(_shares)).div(totalSupply());
341       _burn(msg.sender, _shares);
342 
343       // Check balance
344       uint b = token.balanceOf(address(this));
345       if (b < r) {
346           uint _withdraw = r.sub(b);
347           Controller(controller).withdraw(address(token), _withdraw);
348           uint _after = token.balanceOf(address(this));
349           uint _diff = _after.sub(b);
350           if (_diff < _withdraw) {
351               r = b.add(_diff);
352           }
353       }
354       
355       token.safeTransfer(msg.sender, r);
356   }
357 
358   function getPricePerFullShare() public view returns (uint) {
359     return balance().mul(1e18).div(totalSupply());
360   }
361 }