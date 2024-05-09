1 /**
2  *Submitted for verification at Etherscan.io on 2020-09-04
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2020-08-13
7 */
8 
9 pragma solidity ^0.5.16;
10 
11 interface IERC20 {
12     function totalSupply() external view returns (uint256);
13     function balanceOf(address account) external view returns (uint256);
14     function transfer(address recipient, uint256 amount) external returns (bool);
15     function allowance(address owner, address spender) external view returns (uint256);
16     function approve(address spender, uint256 amount) external returns (bool);
17     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 contract Context {
23     constructor () internal { }
24     // solhint-disable-previous-line no-empty-blocks
25 
26     function _msgSender() internal view returns (address payable) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view returns (bytes memory) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40     constructor () internal {
41         _owner = _msgSender();
42         emit OwnershipTransferred(address(0), _owner);
43     }
44     function owner() public view returns (address) {
45         return _owner;
46     }
47     modifier onlyOwner() {
48         require(isOwner(), "Ownable: caller is not the owner");
49         _;
50     }
51     function isOwner() public view returns (bool) {
52         return _msgSender() == _owner;
53     }
54     function renounceOwnership() public onlyOwner {
55         emit OwnershipTransferred(_owner, address(0));
56         _owner = address(0);
57     }
58     function transferOwnership(address newOwner) public onlyOwner {
59         _transferOwnership(newOwner);
60     }
61     function _transferOwnership(address newOwner) internal {
62         require(newOwner != address(0), "Ownable: new owner is the zero address");
63         emit OwnershipTransferred(_owner, newOwner);
64         _owner = newOwner;
65     }
66 }
67 
68 contract ERC20 is Context, IERC20 {
69     using SafeMath for uint256;
70 
71     mapping (address => uint256) private _balances;
72 
73     mapping (address => mapping (address => uint256)) private _allowances;
74 
75     uint256 private _totalSupply;
76     function totalSupply() public view returns (uint256) {
77         return _totalSupply;
78     }
79     function balanceOf(address account) public view returns (uint256) {
80         return _balances[account];
81     }
82     function transfer(address recipient, uint256 amount) public returns (bool) {
83         _transfer(_msgSender(), recipient, amount);
84         return true;
85     }
86     function allowance(address owner, address spender) public view returns (uint256) {
87         return _allowances[owner][spender];
88     }
89     function approve(address spender, uint256 amount) public returns (bool) {
90         _approve(_msgSender(), spender, amount);
91         return true;
92     }
93     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
94         _transfer(sender, recipient, amount);
95         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
96         return true;
97     }
98     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
99         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
100         return true;
101     }
102     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
103         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
104         return true;
105     }
106     function _transfer(address sender, address recipient, uint256 amount) internal {
107         require(sender != address(0), "ERC20: transfer from the zero address");
108         require(recipient != address(0), "ERC20: transfer to the zero address");
109 
110         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
111         _balances[recipient] = _balances[recipient].add(amount);
112         emit Transfer(sender, recipient, amount);
113     }
114     function _mint(address account, uint256 amount) internal {
115         require(account != address(0), "ERC20: mint to the zero address");
116 
117         _totalSupply = _totalSupply.add(amount);
118         _balances[account] = _balances[account].add(amount);
119         emit Transfer(address(0), account, amount);
120     }
121     function _burn(address account, uint256 amount) internal {
122         require(account != address(0), "ERC20: burn from the zero address");
123 
124         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
125         _totalSupply = _totalSupply.sub(amount);
126         emit Transfer(account, address(0), amount);
127     }
128     function _approve(address owner, address spender, uint256 amount) internal {
129         require(owner != address(0), "ERC20: approve from the zero address");
130         require(spender != address(0), "ERC20: approve to the zero address");
131 
132         _allowances[owner][spender] = amount;
133         emit Approval(owner, spender, amount);
134     }
135     function _burnFrom(address account, uint256 amount) internal {
136         _burn(account, amount);
137         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
138     }
139 }
140 
141 contract ERC20Detailed is IERC20 {
142     string private _name;
143     string private _symbol;
144     uint8 private _decimals;
145 
146     constructor (string memory name, string memory symbol, uint8 decimals) public {
147         _name = name;
148         _symbol = symbol;
149         _decimals = decimals;
150     }
151     function name() public view returns (string memory) {
152         return _name;
153     }
154     function symbol() public view returns (string memory) {
155         return _symbol;
156     }
157     function decimals() public view returns (uint8) {
158         return _decimals;
159     }
160 }
161 
162 library SafeMath {
163     function add(uint256 a, uint256 b) internal pure returns (uint256) {
164         uint256 c = a + b;
165         require(c >= a, "SafeMath: addition overflow");
166 
167         return c;
168     }
169     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
170         return sub(a, b, "SafeMath: subtraction overflow");
171     }
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         uint256 c = a - b;
175 
176         return c;
177     }
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         if (a == 0) {
180             return 0;
181         }
182 
183         uint256 c = a * b;
184         require(c / a == b, "SafeMath: multiplication overflow");
185 
186         return c;
187     }
188     function div(uint256 a, uint256 b) internal pure returns (uint256) {
189         return div(a, b, "SafeMath: division by zero");
190     }
191     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
192         // Solidity only automatically asserts when dividing by 0
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195 
196         return c;
197     }
198     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
199         return mod(a, b, "SafeMath: modulo by zero");
200     }
201     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
202         require(b != 0, errorMessage);
203         return a % b;
204     }
205 }
206 
207 library Address {
208     function isContract(address account) internal view returns (bool) {
209         bytes32 codehash;
210         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
211         // solhint-disable-next-line no-inline-assembly
212         assembly { codehash := extcodehash(account) }
213         return (codehash != 0x0 && codehash != accountHash);
214     }
215     function toPayable(address account) internal pure returns (address payable) {
216         return address(uint160(account));
217     }
218     function sendValue(address payable recipient, uint256 amount) internal {
219         require(address(this).balance >= amount, "Address: insufficient balance");
220 
221         // solhint-disable-next-line avoid-call-value
222         (bool success, ) = recipient.call.value(amount)("");
223         require(success, "Address: unable to send value, recipient may have reverted");
224     }
225 }
226 
227 library SafeERC20 {
228     using SafeMath for uint256;
229     using Address for address;
230 
231     function safeTransfer(IERC20 token, address to, uint256 value) internal {
232         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
233     }
234 
235     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
236         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
237     }
238 
239     function safeApprove(IERC20 token, address spender, uint256 value) internal {
240         require((value == 0) || (token.allowance(address(this), spender) == 0),
241             "SafeERC20: approve from non-zero to non-zero allowance"
242         );
243         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
244     }
245 
246     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
247         uint256 newAllowance = token.allowance(address(this), spender).add(value);
248         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
249     }
250 
251     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
252         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
253         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
254     }
255     function callOptionalReturn(IERC20 token, bytes memory data) private {
256         require(address(token).isContract(), "SafeERC20: call to non-contract");
257 
258         // solhint-disable-next-line avoid-low-level-calls
259         (bool success, bytes memory returndata) = address(token).call(data);
260         require(success, "SafeERC20: low-level call failed");
261 
262         if (returndata.length > 0) { // Return data is optional
263             // solhint-disable-next-line max-line-length
264             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
265         }
266     }
267 }
268 
269 interface Controller {
270     function withdraw(address, uint) external;
271     function balanceOf(address) external view returns (uint);
272     function earn(address, uint) external;
273 }
274 
275 contract iVault is ERC20, ERC20Detailed {
276     using SafeERC20 for IERC20;
277     using Address for address;
278     using SafeMath for uint256;
279     
280     IERC20 public token;
281     
282     uint public min = 9500;
283     uint public constant max = 10000;
284     uint public earnLowerlimit; //池内空余资金到这个值就自动earn
285     
286     address public governance;
287     address public controller;
288     
289     constructor (address _token,uint _earnLowerlimit) public ERC20Detailed(
290         string(abi.encodePacked("yfii ", ERC20Detailed(_token).name())),
291         string(abi.encodePacked("i", ERC20Detailed(_token).symbol())),
292         ERC20Detailed(_token).decimals()
293     ) {
294         token = IERC20(_token);
295         governance = tx.origin;
296         controller = 0x8C2a19108d8F6aEC72867E9cfb1bF517601b515f;
297         earnLowerlimit = _earnLowerlimit;
298     }
299     
300     function balance() public view returns (uint) {
301         return token.balanceOf(address(this))
302                 .add(Controller(controller).balanceOf(address(token)));
303     }
304     
305     function setMin(uint _min) external {
306         require(msg.sender == governance, "!governance");
307         min = _min;
308     }
309     
310     function setGovernance(address _governance) public {
311         require(msg.sender == governance, "!governance");
312         governance = _governance;
313     }
314     
315     function setController(address _controller) public {
316         require(msg.sender == governance, "!governance");
317         controller = _controller;
318     }
319     function setEarnLowerlimit(uint256 _earnLowerlimit) public{
320       require(msg.sender == governance, "!governance");
321       earnLowerlimit = _earnLowerlimit;
322   }
323     
324     // Custom logic in here for how much the vault allows to be borrowed
325     // Sets minimum required on-hand to keep small withdrawals cheap
326     function available() public view returns (uint) {
327         return token.balanceOf(address(this)).mul(min).div(max);
328     }
329     
330     function earn() public {
331         uint _bal = available();
332         token.safeTransfer(controller, _bal);
333         Controller(controller).earn(address(token), _bal);
334     }
335     
336     function depositAll() external {
337         deposit(token.balanceOf(msg.sender));
338     }
339     
340     function deposit(uint _amount) public {
341         uint _pool = balance();
342         uint _before = token.balanceOf(address(this));
343         token.safeTransferFrom(msg.sender, address(this), _amount);
344         uint _after = token.balanceOf(address(this));
345         _amount = _after.sub(_before); // Additional check for deflationary tokens
346         uint shares = 0;
347         if (totalSupply() == 0) {
348             shares = _amount;
349         } else {
350             shares = (_amount.mul(totalSupply())).div(_pool);
351         }
352         _mint(msg.sender, shares);
353         if (token.balanceOf(address(this))>earnLowerlimit){
354           earn();
355         }
356     }
357     
358     function withdrawAll() external {
359         withdraw(balanceOf(msg.sender));
360     }
361     
362     
363     
364     // No rebalance implementation for lower fees and faster swaps
365     function withdraw(uint _shares) public {
366         uint r = (balance().mul(_shares)).div(totalSupply());
367         _burn(msg.sender, _shares);
368         
369         // Check balance
370         uint b = token.balanceOf(address(this));
371         if (b < r) {
372             uint _withdraw = r.sub(b);
373             Controller(controller).withdraw(address(token), _withdraw);
374             uint _after = token.balanceOf(address(this));
375             uint _diff = _after.sub(b);
376             if (_diff < _withdraw) {
377                 r = b.add(_diff);
378             }
379         }
380         
381         token.safeTransfer(msg.sender, r);
382     }
383     
384     function getPricePerFullShare() public view returns (uint) {
385         return balance().mul(1e18).div(totalSupply());
386     }
387 }