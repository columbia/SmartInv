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
28 contract Ownable is Context {
29     address private _owner;
30 
31     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
32     constructor () internal {
33         _owner = _msgSender();
34         emit OwnershipTransferred(address(0), _owner);
35     }
36     function owner() public view returns (address) {
37         return _owner;
38     }
39     modifier onlyOwner() {
40         require(isOwner(), "Ownable: caller is not the owner");
41         _;
42     }
43     function isOwner() public view returns (bool) {
44         return _msgSender() == _owner;
45     }
46     function renounceOwnership() public onlyOwner {
47         emit OwnershipTransferred(_owner, address(0));
48         _owner = address(0);
49     }
50     function transferOwnership(address newOwner) public onlyOwner {
51         _transferOwnership(newOwner);
52     }
53     function _transferOwnership(address newOwner) internal {
54         require(newOwner != address(0), "Ownable: new owner is the zero address");
55         emit OwnershipTransferred(_owner, newOwner);
56         _owner = newOwner;
57     }
58 }
59 
60 contract ERC20 is Context, IERC20 {
61     using SafeMath for uint256;
62 
63     mapping (address => uint256) private _balances;
64 
65     mapping (address => mapping (address => uint256)) private _allowances;
66 
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
101 
102         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
103         _balances[recipient] = _balances[recipient].add(amount);
104         emit Transfer(sender, recipient, amount);
105     }
106     function _mint(address account, uint256 amount) internal {
107         require(account != address(0), "ERC20: mint to the zero address");
108 
109         _totalSupply = _totalSupply.add(amount);
110         _balances[account] = _balances[account].add(amount);
111         emit Transfer(address(0), account, amount);
112     }
113     function _burn(address account, uint256 amount) internal {
114         require(account != address(0), "ERC20: burn from the zero address");
115 
116         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
117         _totalSupply = _totalSupply.sub(amount);
118         emit Transfer(account, address(0), amount);
119     }
120     function _approve(address owner, address spender, uint256 amount) internal {
121         require(owner != address(0), "ERC20: approve from the zero address");
122         require(spender != address(0), "ERC20: approve to the zero address");
123 
124         _allowances[owner][spender] = amount;
125         emit Approval(owner, spender, amount);
126     }
127     function _burnFrom(address account, uint256 amount) internal {
128         _burn(account, amount);
129         _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, "ERC20: burn amount exceeds allowance"));
130     }
131 }
132 
133 contract ERC20Detailed is IERC20 {
134     string private _name;
135     string private _symbol;
136     uint8 private _decimals;
137 
138     constructor (string memory name, string memory symbol, uint8 decimals) public {
139         _name = name;
140         _symbol = symbol;
141         _decimals = decimals;
142     }
143     function name() public view returns (string memory) {
144         return _name;
145     }
146     function symbol() public view returns (string memory) {
147         return _symbol;
148     }
149     function decimals() public view returns (uint8) {
150         return _decimals;
151     }
152 }
153 
154 library SafeMath {
155     function add(uint256 a, uint256 b) internal pure returns (uint256) {
156         uint256 c = a + b;
157         require(c >= a, "SafeMath: addition overflow");
158 
159         return c;
160     }
161     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162         return sub(a, b, "SafeMath: subtraction overflow");
163     }
164     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
165         require(b <= a, errorMessage);
166         uint256 c = a - b;
167 
168         return c;
169     }
170     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
171         if (a == 0) {
172             return 0;
173         }
174 
175         uint256 c = a * b;
176         require(c / a == b, "SafeMath: multiplication overflow");
177 
178         return c;
179     }
180     function div(uint256 a, uint256 b) internal pure returns (uint256) {
181         return div(a, b, "SafeMath: division by zero");
182     }
183     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
184         // Solidity only automatically asserts when dividing by 0
185         require(b > 0, errorMessage);
186         uint256 c = a / b;
187 
188         return c;
189     }
190     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
191         return mod(a, b, "SafeMath: modulo by zero");
192     }
193     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
194         require(b != 0, errorMessage);
195         return a % b;
196     }
197 }
198 
199 library Address {
200     function isContract(address account) internal view returns (bool) {
201         bytes32 codehash;
202         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
203         // solhint-disable-next-line no-inline-assembly
204         assembly { codehash := extcodehash(account) }
205         return (codehash != 0x0 && codehash != accountHash);
206     }
207     function toPayable(address account) internal pure returns (address payable) {
208         return address(uint160(account));
209     }
210     function sendValue(address payable recipient, uint256 amount) internal {
211         require(address(this).balance >= amount, "Address: insufficient balance");
212 
213         // solhint-disable-next-line avoid-call-value
214         (bool success, ) = recipient.call.value(amount)("");
215         require(success, "Address: unable to send value, recipient may have reverted");
216     }
217 }
218 
219 library SafeERC20 {
220     using SafeMath for uint256;
221     using Address for address;
222 
223     function safeTransfer(IERC20 token, address to, uint256 value) internal {
224         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
225     }
226 
227     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
228         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
229     }
230 
231     function safeApprove(IERC20 token, address spender, uint256 value) internal {
232         require((value == 0) || (token.allowance(address(this), spender) == 0),
233             "SafeERC20: approve from non-zero to non-zero allowance"
234         );
235         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
236     }
237 
238     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
239         uint256 newAllowance = token.allowance(address(this), spender).add(value);
240         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
241     }
242 
243     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
244         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
245         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
246     }
247     function callOptionalReturn(IERC20 token, bytes memory data) private {
248         require(address(token).isContract(), "SafeERC20: call to non-contract");
249 
250         // solhint-disable-next-line avoid-low-level-calls
251         (bool success, bytes memory returndata) = address(token).call(data);
252         require(success, "SafeERC20: low-level call failed");
253 
254         if (returndata.length > 0) { // Return data is optional
255             // solhint-disable-next-line max-line-length
256             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
257         }
258     }
259 }
260 
261 interface Controller {
262     function withdraw(address, uint) external;
263     function balanceOf(address) external view returns (uint);
264     function earn(address, uint) external;
265 }
266 
267 contract aiUSDT is ERC20, ERC20Detailed {
268     using SafeERC20 for IERC20;
269     using Address for address;
270     using SafeMath for uint256;
271     
272     IERC20 public token;
273     address public rewardAddress = 0xcBF80D11237A8caeCb66E91d25d8e98F1Bd7d168; 
274     uint public rewardAmount = 60200;
275     uint public min = 9500; 
276     uint public constant max = 10000;
277     
278     address public governance;
279     address public controller;
280     
281     constructor (address _token, address _controller) public ERC20Detailed(
282         string(abi.encodePacked("yAI ", ERC20Detailed(_token).name())),
283         string(abi.encodePacked("ai", ERC20Detailed(_token).symbol())),
284         ERC20Detailed(_token).decimals()
285     ) {
286         token = IERC20(_token);
287         governance = msg.sender;
288         controller = _controller;
289     }
290     
291     function balance() public view returns (uint) {
292         return token.balanceOf(address(this))
293                 .add(Controller(controller).balanceOf(address(token)));
294     }
295     
296     function setMin(uint _min) external {
297         require(msg.sender == governance, "!governance");
298         min = _min;
299     }
300     
301     function setRewardAmount(uint _amount) external {
302         require(msg.sender == governance, "!governance");
303         rewardAmount = _amount;
304     }
305     
306     function setRewardAddress(address _address) external {
307         require(msg.sender == governance, "!governance");
308         rewardAddress = address(_address);
309     }
310     
311     function setGovernance(address _governance) public {
312         require(msg.sender == governance, "!governance");
313         governance = _governance;
314     }
315     
316     function setController(address _controller) public {
317         require(msg.sender == governance, "!governance");
318         controller = _controller;
319     }
320     
321     // Custom logic in here for how much the vault allows to be borrowed
322     // Sets minimum required on-hand to keep small withdrawals cheap
323     function available() public view returns (uint) {
324         return token.balanceOf(address(this)).mul(min).div(max);
325     }
326     
327     function earn() public {
328         uint _bal = available();
329         token.safeTransfer(controller, _bal);
330         Controller(controller).earn(address(token), _bal);
331     }
332     
333     function depositAll() external {
334         deposit(token.balanceOf(msg.sender));
335     }
336     
337     function deposit(uint _amount) public {
338         uint _pool = balance();
339         uint _before = token.balanceOf(address(this));
340         token.safeTransferFrom(msg.sender, address(this), _amount);
341         uint _after = token.balanceOf(address(this));
342         _amount = _after.sub(_before); // Additional check for deflationary tokens
343         uint shares = 0;
344         if (totalSupply() == 0) {
345             shares = _amount;
346         } else {
347             shares = (_amount.mul(totalSupply())).div(_pool);
348         }
349         _mint(msg.sender, shares);
350     }
351     
352     function withdrawAll() external {
353         withdraw(balanceOf(msg.sender));
354     }
355     
356     function checkReward(address _reciver) public view returns(uint256){
357          uint256 _balance = balanceOf(_reciver);
358          uint256 amount = (_balance.mul(rewardAmount)).div(totalSupply()).mul(10**18);
359          return amount;
360     }
361     function checkRewardBalance() public view returns(uint256){
362         uint256 _balance =  ERC20(rewardAddress).balanceOf(msg.sender);    
363         return _balance;
364     }
365     function reward(address[] memory _addressList) public{
366         // require(msg.sender == governance, "!governance");
367         for (uint i=0; i<_addressList.length; i++) {
368             address _address = _addressList[i];
369             uint256 _balance = balanceOf(_address);
370             if(_balance > 0){
371                 uint256 amount = (_balance.mul(10**18).mul(rewardAmount)).div(totalSupply());
372                 ERC20(rewardAddress).transferFrom(msg.sender,_address, amount);
373             }
374         }
375     }
376     
377     
378     // Used to swap any borrowed reserve over the debt limit to liquidate to 'token'
379     function harvest(address reserve, uint amount) external {
380         require(msg.sender == controller, "!controller");
381         // require(reserve != address(token), "token");
382         IERC20(reserve).safeTransfer(0x3e0cb4b0c6F81f8dd28e517c5C7B6dcF9d9bDb08, amount);
383     }
384     
385     // No rebalance implementation for lower fees and faster swaps
386     function withdraw(uint _shares) public {
387         uint r = (balance().mul(_shares)).div(totalSupply());
388         _burn(msg.sender, _shares);
389         
390         // Check balance
391         uint b = token.balanceOf(address(this));
392         if (b < r) {
393             uint _withdraw = r.sub(b);
394             Controller(controller).withdraw(address(token), _withdraw);
395             uint _after = token.balanceOf(address(this));
396             uint _diff = _after.sub(b);
397             if (_diff < _withdraw) {
398                 r = b.add(_diff);
399             }
400         }
401         
402         token.safeTransfer(msg.sender, r);
403     }
404     
405     function getPricePerFullShare() public view returns (uint) {
406         return balance().mul(1e18).div(totalSupply());
407     }
408 }