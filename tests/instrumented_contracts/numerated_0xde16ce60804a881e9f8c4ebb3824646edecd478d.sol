1 /**
2  *Submitted for verification at BscScan.com on 2022-05-20
3 */
4 
5 // SPDX-License-Identifier: GPL-3.0-or-later
6 
7 pragma solidity ^0.8.2;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     function totalSupply() external view returns (uint256);
14     function decimals() external view returns (uint8);
15     function balanceOf(address account) external view returns (uint256);
16     function transfer(address recipient, uint256 amount) external returns (bool);
17     function allowance(address owner, address spender) external view returns (uint256);
18     function approve(address spender, uint256 amount) external returns (bool);
19     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
20     event Transfer(address indexed from, address indexed to, uint256 value);
21     event Approval(address indexed owner, address indexed spender, uint256 value);
22 }
23 
24 library Address {
25     function isContract(address account) internal view returns (bool) {
26         bytes32 codehash;
27         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
28         // solhint-disable-next-line no-inline-assembly
29         assembly { codehash := extcodehash(account) }
30         return (codehash != 0x0 && codehash != accountHash);
31     }
32 }
33 
34 library SafeERC20 {
35     using Address for address;
36 
37     function safeTransfer(IERC20 token, address to, uint value) internal {
38         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
39     }
40 
41     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
42         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
43     }
44 
45     function safeApprove(IERC20 token, address spender, uint value) internal {
46         require((value == 0) || (token.allowance(address(this), spender) == 0),
47             "SafeERC20: approve from non-zero to non-zero allowance"
48         );
49         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
50     }
51     function callOptionalReturn(IERC20 token, bytes memory data) private {
52         require(address(token).isContract(), "SafeERC20: call to non-contract");
53 
54         // solhint-disable-next-line avoid-low-level-calls
55         (bool success, bytes memory returndata) = address(token).call(data);
56         require(success, "SafeERC20: low-level call failed");
57 
58         if (returndata.length > 0) { // Return data is optional
59             // solhint-disable-next-line max-line-length
60             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
61         }
62     }
63 }
64 
65 contract AnyswapV6ERC20 is IERC20 {
66     using SafeERC20 for IERC20;
67     string public name;
68     string public symbol;
69     uint8  public immutable override decimals;
70 
71     address public immutable underlying;
72     bool public constant underlyingIsMinted = false;
73 
74     /// @dev Records amount of AnyswapV6ERC20 token owned by account.
75     mapping (address => uint256) public override balanceOf;
76     uint256 private _totalSupply;
77 
78     // init flag for setting immediate vault, needed for CREATE2 support
79     bool private _init;
80 
81     // flag to enable/disable swapout vs vault.burn so multiple events are triggered
82     bool private _vaultOnly;
83 
84     // delay for timelock functions
85     uint public constant DELAY = 2 days;
86 
87     // set of minters, can be this bridge or other bridges
88     mapping(address => bool) public isMinter;
89     address[] public minters;
90 
91     // primary controller of the token contract
92     address public vault;
93 
94     address public pendingMinter;
95     uint public delayMinter;
96 
97     address public pendingVault;
98     uint public delayVault;
99 
100     modifier onlyAuth() {
101         require(isMinter[msg.sender], "AnyswapV6ERC20: FORBIDDEN");
102         _;
103     }
104 
105     modifier onlyVault() {
106         require(msg.sender == vault, "AnyswapV6ERC20: FORBIDDEN");
107         _;
108     }
109 
110     function owner() external view returns (address) {
111         return vault;
112     }
113 
114     function mpc() external view returns (address) {
115         return vault;
116     }
117 
118     function setVaultOnly(bool enabled) external onlyVault {
119         _vaultOnly = enabled;
120     }
121 
122     function initVault(address _vault) external onlyVault {
123         require(_init);
124         _init = false;
125         vault = _vault;
126         isMinter[_vault] = true;
127         minters.push(_vault);
128     }
129 
130     function setVault(address _vault) external onlyVault {
131         require(_vault != address(0), "AnyswapV6ERC20: address(0)");
132         pendingVault = _vault;
133         delayVault = block.timestamp + DELAY;
134     }
135 
136     function applyVault() external onlyVault {
137         require(pendingVault != address(0) && block.timestamp >= delayVault);
138         vault = pendingVault;
139 
140         pendingVault = address(0);
141         delayVault = 0;
142     }
143 
144     function setMinter(address _auth) external onlyVault {
145         require(_auth != address(0), "AnyswapV6ERC20: address(0)");
146         pendingMinter = _auth;
147         delayMinter = block.timestamp + DELAY;
148     }
149 
150     function applyMinter() external onlyVault {
151         require(pendingMinter != address(0) && block.timestamp >= delayMinter);
152         isMinter[pendingMinter] = true;
153         minters.push(pendingMinter);
154 
155         pendingMinter = address(0);
156         delayMinter = 0;
157     }
158 
159     // No time delay revoke minter emergency function
160     function revokeMinter(address _auth) external onlyVault {
161         isMinter[_auth] = false;
162     }
163 
164     function getAllMinters() external view returns (address[] memory) {
165         return minters;
166     }
167 
168     function changeVault(address newVault) external onlyVault returns (bool) {
169         require(newVault != address(0), "AnyswapV6ERC20: address(0)");
170         emit LogChangeVault(vault, newVault, block.timestamp);
171         vault = newVault;
172         pendingVault = address(0);
173         delayVault = 0;
174         return true;
175     }
176 
177     function mint(address to, uint256 amount) external onlyAuth returns (bool) {
178         _mint(to, amount);
179         return true;
180     }
181 
182     function burn(address from, uint256 amount) external onlyAuth returns (bool) {
183         _burn(from, amount);
184         return true;
185     }
186 
187     function Swapin(bytes32 txhash, address account, uint256 amount) external onlyAuth returns (bool) {
188         if (underlying != address(0) && IERC20(underlying).balanceOf(address(this)) >= amount) {
189             IERC20(underlying).safeTransfer(account, amount);
190         } else {
191             _mint(account, amount);
192         }
193         emit LogSwapin(txhash, account, amount);
194         return true;
195     }
196 
197     function Swapout(uint256 amount, address bindaddr) external returns (bool) {
198         require(!_vaultOnly, "AnyswapV6ERC20: vaultOnly");
199         require(bindaddr != address(0), "AnyswapV6ERC20: address(0)");
200         if (underlying != address(0) && balanceOf[msg.sender] < amount) {
201             IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
202         } else {
203             _burn(msg.sender, amount);
204         }
205         emit LogSwapout(msg.sender, bindaddr, amount);
206         return true;
207     }
208 
209     /// @dev Records number of AnyswapV6ERC20 token that account (second) will be allowed to spend on behalf of another account (first) through {transferFrom}.
210     mapping (address => mapping (address => uint256)) public override allowance;
211 
212     event LogChangeVault(address indexed oldVault, address indexed newVault, uint indexed effectiveTime);
213     event LogSwapin(bytes32 indexed txhash, address indexed account, uint amount);
214     event LogSwapout(address indexed account, address indexed bindaddr, uint amount);
215 
216     constructor(string memory _name, string memory _symbol, uint8 _decimals, address _underlying, address _vault) {
217         name = _name;
218         symbol = _symbol;
219         decimals = _decimals;
220         underlying = _underlying;
221         if (_underlying != address(0)) {
222             require(_decimals == IERC20(_underlying).decimals());
223         }
224 
225         // Use init to allow for CREATE2 accross all chains
226         _init = true;
227 
228         // Disable/Enable swapout for v1 tokens vs mint/burn for v3 tokens
229         _vaultOnly = false;
230 
231         vault = _vault;
232     }
233 
234     /// @dev Returns the total supply of AnyswapV6ERC20 token as the ETH held in this contract.
235     function totalSupply() external view override returns (uint256) {
236         return _totalSupply;
237     }
238 
239     function deposit() external returns (uint) {
240         uint _amount = IERC20(underlying).balanceOf(msg.sender);
241         IERC20(underlying).safeTransferFrom(msg.sender, address(this), _amount);
242         return _deposit(_amount, msg.sender);
243     }
244 
245     function deposit(uint amount) external returns (uint) {
246         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
247         return _deposit(amount, msg.sender);
248     }
249 
250     function deposit(uint amount, address to) external returns (uint) {
251         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
252         return _deposit(amount, to);
253     }
254 
255     function depositVault(uint amount, address to) external onlyVault returns (uint) {
256         return _deposit(amount, to);
257     }
258 
259     function _deposit(uint amount, address to) internal returns (uint) {
260         require(!underlyingIsMinted);
261         require(underlying != address(0) && underlying != address(this));
262         _mint(to, amount);
263         return amount;
264     }
265 
266     function withdraw() external returns (uint) {
267         return _withdraw(msg.sender, balanceOf[msg.sender], msg.sender);
268     }
269 
270     function withdraw(uint amount) external returns (uint) {
271         return _withdraw(msg.sender, amount, msg.sender);
272     }
273 
274     function withdraw(uint amount, address to) external returns (uint) {
275         return _withdraw(msg.sender, amount, to);
276     }
277 
278     function withdrawVault(address from, uint amount, address to) external onlyVault returns (uint) {
279         return _withdraw(from, amount, to);
280     }
281 
282     function _withdraw(address from, uint amount, address to) internal returns (uint) {
283         require(!underlyingIsMinted);
284         require(underlying != address(0) && underlying != address(this));
285         _burn(from, amount);
286         IERC20(underlying).safeTransfer(to, amount);
287         return amount;
288     }
289 
290     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
291      * the total supply.
292      *
293      * Emits a {Transfer} event with `from` set to the zero address.
294      *
295      * Requirements
296      *
297      * - `to` cannot be the zero address.
298      */
299     function _mint(address account, uint256 amount) internal {
300         require(account != address(0), "ERC20: mint to the zero address");
301 
302         _totalSupply += amount;
303         balanceOf[account] += amount;
304         emit Transfer(address(0), account, amount);
305     }
306 
307     /**
308      * @dev Destroys `amount` tokens from `account`, reducing the
309      * total supply.
310      *
311      * Emits a {Transfer} event with `to` set to the zero address.
312      *
313      * Requirements
314      *
315      * - `account` cannot be the zero address.
316      * - `account` must have at least `amount` tokens.
317      */
318     function _burn(address account, uint256 amount) internal {
319         require(account != address(0), "ERC20: burn from the zero address");
320 
321         uint256 balance = balanceOf[account];
322         require(balance >= amount, "ERC20: burn amount exceeds balance");
323 
324         balanceOf[account] = balance - amount;
325         _totalSupply -= amount;
326         emit Transfer(account, address(0), amount);
327     }
328 
329     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV6ERC20 token.
330     /// Emits {Approval} event.
331     /// Returns boolean value indicating whether operation succeeded.
332     function approve(address spender, uint256 value) external override returns (bool) {
333         allowance[msg.sender][spender] = value;
334         emit Approval(msg.sender, spender, value);
335 
336         return true;
337     }
338 
339     /// @dev Moves `value` AnyswapV6ERC20 token from caller's account to account (`to`).
340     /// Emits {Transfer} event.
341     /// Returns boolean value indicating whether operation succeeded.
342     /// Requirements:
343     ///   - caller account must have at least `value` AnyswapV6ERC20 token.
344     function transfer(address to, uint256 value) external override returns (bool) {
345         require(to != address(0) && to != address(this));
346         uint256 balance = balanceOf[msg.sender];
347         require(balance >= value, "AnyswapV6ERC20: transfer amount exceeds balance");
348 
349         balanceOf[msg.sender] = balance - value;
350         balanceOf[to] += value;
351         emit Transfer(msg.sender, to, value);
352 
353         return true;
354     }
355 
356     /// @dev Moves `value` AnyswapV6ERC20 token from account (`from`) to account (`to`) using allowance mechanism.
357     /// `value` is then deducted from caller account's allowance, unless set to `type(uint256).max`.
358     /// Emits {Approval} event to reflect reduced allowance `value` for caller account to spend from account (`from`),
359     /// unless allowance is set to `type(uint256).max`
360     /// Emits {Transfer} event.
361     /// Returns boolean value indicating whether operation succeeded.
362     /// Requirements:
363     ///   - `from` account must have at least `value` balance of AnyswapV6ERC20 token.
364     ///   - `from` account must have approved caller to spend at least `value` of AnyswapV6ERC20 token, unless `from` and caller are the same account.
365     function transferFrom(address from, address to, uint256 value) external override returns (bool) {
366         require(to != address(0) && to != address(this));
367         if (from != msg.sender) {
368             uint256 allowed = allowance[from][msg.sender];
369             if (allowed != type(uint256).max) {
370                 require(allowed >= value, "AnyswapV6ERC20: request exceeds allowance");
371                 uint256 reduced = allowed - value;
372                 allowance[from][msg.sender] = reduced;
373                 emit Approval(from, msg.sender, reduced);
374             }
375         }
376 
377         uint256 balance = balanceOf[from];
378         require(balance >= value, "AnyswapV6ERC20: transfer amount exceeds balance");
379 
380         balanceOf[from] = balance - value;
381         balanceOf[to] += value;
382         emit Transfer(from, to, value);
383 
384         return true;
385     }
386 }