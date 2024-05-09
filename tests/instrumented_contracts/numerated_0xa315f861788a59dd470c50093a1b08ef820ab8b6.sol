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
201         uint256 size;
202         // solhint-disable-next-line no-inline-assembly
203         assembly { size := extcodesize(account) }
204         return size > 0;
205     }
206     function toPayable(address account) internal pure returns (address payable) {
207         return address(uint160(account));
208     }
209     function sendValue(address payable recipient, uint256 amount) internal {
210         require(address(this).balance >= amount, "Address: insufficient balance");
211 
212         // solhint-disable-next-line avoid-call-value
213         (bool success, ) = recipient.call.value(amount)("");
214         require(success, "Address: unable to send value, recipient may have reverted");
215     }
216 }
217 
218 library SafeERC20 {
219     using SafeMath for uint256;
220     using Address for address;
221 
222     function safeTransfer(IERC20 token, address to, uint256 value) internal {
223         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
224     }
225 
226     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
227         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
228     }
229 
230     function safeApprove(IERC20 token, address spender, uint256 value) internal {
231         require((value == 0) || (token.allowance(address(this), spender) == 0),
232             "SafeERC20: approve from non-zero to non-zero allowance"
233         );
234         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
235     }
236 
237     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
238         uint256 newAllowance = token.allowance(address(this), spender).add(value);
239         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
240     }
241 
242     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
243         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
244         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
245     }
246     function callOptionalReturn(IERC20 token, bytes memory data) private {
247         require(address(token).isContract(), "SafeERC20: call to non-contract");
248 
249         // solhint-disable-next-line avoid-low-level-calls
250         (bool success, bytes memory returndata) = address(token).call(data);
251         require(success, "SafeERC20: low-level call failed");
252 
253         if (returndata.length > 0) { // Return data is optional
254             // solhint-disable-next-line max-line-length
255             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
256         }
257     }
258 }
259 
260 interface IVault {
261     function token() external view returns (address);
262     function deposit(uint) external;
263     function withdraw(uint) external;
264     function balanceOf(address) external view returns (uint);
265 }
266 
267 contract YFVault is ERC20, ERC20Detailed, Ownable {
268     using SafeERC20 for IERC20;
269     using Address for address;
270     using SafeMath for uint256;
271 
272     string private constant NAME = "yfBETA Tether USD";
273     string private constant SYMBOL = "yfUSDT";
274     uint8 private constant DECIMALS = 6;
275     address private constant ADDRESS_TOKEN = 0xdAC17F958D2ee523a2206206994597C13D831ec7;    // USDT
276     address private constant ADDRESS_VAULT = 0x2f08119C6f07c006695E079AAFc638b8789FAf18;    // yearn USDT vault
277 
278     IERC20 public token;
279     IVault public vault;
280 
281     mapping(address => uint256) public balancesToken;
282     mapping(address => uint256) public balancesVault;
283 
284     address public governance;
285     address public pool;
286     bool public lockedDeposit = true;
287 
288     modifier onlyGovernance() {
289         require(msg.sender == governance, "!governance");
290         _;
291     }
292 
293     constructor () public
294     ERC20Detailed(NAME, SYMBOL, DECIMALS) {
295         token = IERC20(ADDRESS_TOKEN);
296         vault = IVault(ADDRESS_VAULT);
297         governance = msg.sender;
298     }
299 
300 
301 
302     function balanceToken() public view returns (uint) {
303         return token.balanceOf(address(this));
304     }
305     function balanceVault() public view returns (uint) {
306         return vault.balanceOf(address(this));
307     }
308 
309 
310 
311     function depositAll() external {
312         deposit(token.balanceOf(msg.sender));
313     }
314 
315     function deposit(uint _amount) public {
316         require(lockedDeposit == false, 'Deposits are locked');
317 
318         uint256 _totalVaultBalanceBefore = vault.balanceOf(address(this));
319         token.safeTransferFrom(msg.sender, address(this), _amount);
320         token.safeApprove(address(vault), _amount);
321         vault.deposit(_amount);
322         uint256 _totalVaultBalanceAfter = vault.balanceOf(address(this));
323 
324         uint256 _amountInVaultShares = _totalVaultBalanceAfter.sub(_totalVaultBalanceBefore);
325 
326         balancesToken[msg.sender] = balancesToken[msg.sender].add(_amount);
327         balancesVault[msg.sender] = balancesVault[msg.sender].add(_amountInVaultShares);
328 
329         _mint(msg.sender, _amountInVaultShares);
330     }
331 
332     function withdrawAll() external {
333         withdraw(balanceOf(msg.sender));
334     }
335 
336     function withdraw(uint _shares) public {
337         _burn(msg.sender, _shares);
338 
339         uint256 _totalTokenBalanceBefore = token.balanceOf(address(this));
340         vault.withdraw(_shares);
341         uint256 _totalTokenBalanceAfter = token.balanceOf(address(this));
342 
343         uint256 _tokensTransfered = _totalTokenBalanceAfter.sub(_totalTokenBalanceBefore);
344 
345         uint256 _tokensToUser = _shares.mul(balancesToken[msg.sender]).div(balancesVault[msg.sender]);
346 
347         if(_tokensToUser > _tokensTransfered) {
348             _tokensToUser = _tokensTransfered;
349         }
350         if(_tokensToUser > balancesToken[msg.sender]) {
351             _tokensToUser = balancesToken[msg.sender];
352         }
353 
354         balancesToken[msg.sender] = balancesToken[msg.sender].sub(_tokensToUser);
355         balancesVault[msg.sender] = balancesVault[msg.sender].sub(_shares);
356 
357         token.safeTransfer(msg.sender, _tokensToUser);
358     }
359 
360 
361 
362     function transfer(address _recipient, uint256 _amount) public returns (bool) {
363         address _sender = _msgSender();
364 
365         _transfer(_msgSender(), _recipient, _amount);
366         if(msg.sender != pool) {
367             uint256 _amountInToken = _amount.mul(balancesToken[_sender]).div(balancesVault[_sender]);
368 
369             balancesVault[_sender] = balancesVault[_sender].sub(_amount, "Vault: transfer amount exceeds balance");
370             balancesVault[_recipient] = balancesVault[_recipient].add(_amount);
371 
372             balancesToken[_sender] = balancesToken[_sender].sub(_amountInToken, "Vault: transfer amount exceeds balance");
373             balancesToken[_recipient] = balancesToken[_recipient].add(_amountInToken);
374         }
375 
376         return true;
377     }
378 
379 
380 
381     function setPool(address _pool) public onlyGovernance {
382         pool = _pool;
383     }
384 
385     function setGovernance(address _governance) public onlyGovernance {
386         governance = _governance;
387     }
388 
389     function withdrawProfits() public onlyGovernance {
390         token.safeTransfer(governance, balanceToken());
391     }
392 
393     function withdrawTokenProfits(address _token) public onlyGovernance {
394         require(_token != address(token), 'You can only withdraw reward token.');
395         IERC20 _rewardToken = IERC20(_token);
396         _rewardToken.safeTransfer(governance, _rewardToken.balanceOf(address(this)));
397     }
398 
399     function lockDeposits() public onlyGovernance {
400         require(lockedDeposit == false, 'Deposits are already locked');
401         lockedDeposit = true;
402     }
403     function unlockDeposits() public onlyGovernance {
404         require(lockedDeposit == true, 'Deposits are already unlocked');
405         lockedDeposit = false;
406     }
407     function depositIsLocked() public view returns (bool) {
408         return lockedDeposit;
409     }
410 }