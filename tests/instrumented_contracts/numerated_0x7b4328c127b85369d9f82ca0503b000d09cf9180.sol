1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity ^0.8.2;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10     function decimals() external view returns (uint8);
11     function balanceOf(address account) external view returns (uint256);
12     function transfer(address recipient, uint256 amount) external returns (bool);
13     function allowance(address owner, address spender) external view returns (uint256);
14     function approve(address spender, uint256 amount) external returns (bool);
15     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17     event Approval(address indexed owner, address indexed spender, uint256 value);
18 }
19 
20 library Address {
21     function isContract(address account) internal view returns (bool) {
22         bytes32 codehash;
23         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
24         // solhint-disable-next-line no-inline-assembly
25         assembly { codehash := extcodehash(account) }
26         return (codehash != 0x0 && codehash != accountHash);
27     }
28 }
29 
30 library SafeERC20 {
31     using Address for address;
32 
33     function safeTransfer(IERC20 token, address to, uint value) internal {
34         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
35     }
36 
37     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
38         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
39     }
40 
41     function safeApprove(IERC20 token, address spender, uint value) internal {
42         require((value == 0) || (token.allowance(address(this), spender) == 0),
43             "SafeERC20: approve from non-zero to non-zero allowance"
44         );
45         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
46     }
47     function callOptionalReturn(IERC20 token, bytes memory data) private {
48         require(address(token).isContract(), "SafeERC20: call to non-contract");
49 
50         // solhint-disable-next-line avoid-low-level-calls
51         (bool success, bytes memory returndata) = address(token).call(data);
52         require(success, "SafeERC20: low-level call failed");
53 
54         if (returndata.length > 0) { // Return data is optional
55             // solhint-disable-next-line max-line-length
56             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
57         }
58     }
59 }
60 
61 contract AnyswapV6ERC20 is IERC20 {
62     using SafeERC20 for IERC20;
63     string public name;
64     string public symbol;
65     uint8  public immutable override decimals;
66 
67     address public immutable underlying;
68     bool public constant underlyingIsMinted = false;
69 
70     /// @dev Records amount of AnyswapV6ERC20 token owned by account.
71     mapping (address => uint256) public override balanceOf;
72     uint256 private _totalSupply;
73 
74     // init flag for setting immediate vault, needed for CREATE2 support
75     bool private _init;
76 
77     // flag to enable/disable swapout vs vault.burn so multiple events are triggered
78     bool private _vaultOnly;
79 
80     // delay for timelock functions
81     uint public constant DELAY = 2 days;
82 
83     // set of minters, can be this bridge or other bridges
84     mapping(address => bool) public isMinter;
85     address[] public minters;
86 
87     // primary controller of the token contract
88     address public vault;
89 
90     address public pendingMinter;
91     uint public delayMinter;
92 
93     address public pendingVault;
94     uint public delayVault;
95 
96     modifier onlyAuth() {
97         require(isMinter[msg.sender], "AnyswapV6ERC20: FORBIDDEN");
98         _;
99     }
100 
101     modifier onlyVault() {
102         require(msg.sender == vault, "AnyswapV6ERC20: FORBIDDEN");
103         _;
104     }
105 
106     function owner() external view returns (address) {
107         return vault;
108     }
109 
110     function mpc() external view returns (address) {
111         return vault;
112     }
113 
114     function setVaultOnly(bool enabled) external onlyVault {
115         _vaultOnly = enabled;
116     }
117 
118     function initVault(address _vault) external onlyVault {
119         require(_init);
120         _init = false;
121         vault = _vault;
122         isMinter[_vault] = true;
123         minters.push(_vault);
124     }
125 
126     function setVault(address _vault) external onlyVault {
127         require(_vault != address(0), "AnyswapV6ERC20: address(0)");
128         pendingVault = _vault;
129         delayVault = block.timestamp + DELAY;
130     }
131 
132     function applyVault() external onlyVault {
133         require(pendingVault != address(0) && block.timestamp >= delayVault);
134         vault = pendingVault;
135 
136         pendingVault = address(0);
137         delayVault = 0;
138     }
139 
140     function setMinter(address _auth) external onlyVault {
141         require(_auth != address(0), "AnyswapV6ERC20: address(0)");
142         pendingMinter = _auth;
143         delayMinter = block.timestamp + DELAY;
144     }
145 
146     function applyMinter() external onlyVault {
147         require(pendingMinter != address(0) && block.timestamp >= delayMinter);
148         isMinter[pendingMinter] = true;
149         minters.push(pendingMinter);
150 
151         pendingMinter = address(0);
152         delayMinter = 0;
153     }
154 
155     // No time delay revoke minter emergency function
156     function revokeMinter(address _auth) external onlyVault {
157         isMinter[_auth] = false;
158     }
159 
160     function getAllMinters() external view returns (address[] memory) {
161         return minters;
162     }
163 
164     function changeVault(address newVault) external onlyVault returns (bool) {
165         require(newVault != address(0), "AnyswapV6ERC20: address(0)");
166         emit LogChangeVault(vault, newVault, block.timestamp);
167         vault = newVault;
168         pendingVault = address(0);
169         delayVault = 0;
170         return true;
171     }
172 
173     function mint(address to, uint256 amount) external onlyAuth returns (bool) {
174         _mint(to, amount);
175         return true;
176     }
177 
178     function burn(address from, uint256 amount) external onlyAuth returns (bool) {
179         _burn(from, amount);
180         return true;
181     }
182 
183     function Swapin(bytes32 txhash, address account, uint256 amount) external onlyAuth returns (bool) {
184         if (underlying != address(0) && IERC20(underlying).balanceOf(address(this)) >= amount) {
185             IERC20(underlying).safeTransfer(account, amount);
186         } else {
187             _mint(account, amount);
188         }
189         emit LogSwapin(txhash, account, amount);
190         return true;
191     }
192 
193     function Swapout(uint256 amount, address bindaddr) external returns (bool) {
194         require(!_vaultOnly, "AnyswapV6ERC20: vaultOnly");
195         require(bindaddr != address(0), "AnyswapV6ERC20: address(0)");
196         if (underlying != address(0) && balanceOf[msg.sender] < amount) {
197             IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
198         } else {
199             _burn(msg.sender, amount);
200         }
201         emit LogSwapout(msg.sender, bindaddr, amount);
202         return true;
203     }
204 
205     /// @dev Records number of AnyswapV6ERC20 token that account (second) will be allowed to spend on behalf of another account (first) through {transferFrom}.
206     mapping (address => mapping (address => uint256)) public override allowance;
207 
208     event LogChangeVault(address indexed oldVault, address indexed newVault, uint indexed effectiveTime);
209     event LogSwapin(bytes32 indexed txhash, address indexed account, uint amount);
210     event LogSwapout(address indexed account, address indexed bindaddr, uint amount);
211 
212     constructor(string memory _name, string memory _symbol, uint8 _decimals, address _underlying, address _vault) {
213         name = _name;
214         symbol = _symbol;
215         decimals = _decimals;
216         underlying = _underlying;
217         if (_underlying != address(0)) {
218             require(_decimals == IERC20(_underlying).decimals());
219         }
220 
221         // Use init to allow for CREATE2 accross all chains
222         _init = true;
223 
224         // Disable/Enable swapout for v1 tokens vs mint/burn for v3 tokens
225         _vaultOnly = false;
226 
227         vault = _vault;
228     }
229 
230     /// @dev Returns the total supply of AnyswapV6ERC20 token as the ETH held in this contract.
231     function totalSupply() external view override returns (uint256) {
232         return _totalSupply;
233     }
234 
235     function deposit() external returns (uint) {
236         uint _amount = IERC20(underlying).balanceOf(msg.sender);
237         IERC20(underlying).safeTransferFrom(msg.sender, address(this), _amount);
238         return _deposit(_amount, msg.sender);
239     }
240 
241     function deposit(uint amount) external returns (uint) {
242         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
243         return _deposit(amount, msg.sender);
244     }
245 
246     function deposit(uint amount, address to) external returns (uint) {
247         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
248         return _deposit(amount, to);
249     }
250 
251     function depositVault(uint amount, address to) external onlyVault returns (uint) {
252         return _deposit(amount, to);
253     }
254 
255     function _deposit(uint amount, address to) internal returns (uint) {
256         require(!underlyingIsMinted);
257         require(underlying != address(0) && underlying != address(this));
258         _mint(to, amount);
259         return amount;
260     }
261 
262     function withdraw() external returns (uint) {
263         return _withdraw(msg.sender, balanceOf[msg.sender], msg.sender);
264     }
265 
266     function withdraw(uint amount) external returns (uint) {
267         return _withdraw(msg.sender, amount, msg.sender);
268     }
269 
270     function withdraw(uint amount, address to) external returns (uint) {
271         return _withdraw(msg.sender, amount, to);
272     }
273 
274     function withdrawVault(address from, uint amount, address to) external onlyVault returns (uint) {
275         return _withdraw(from, amount, to);
276     }
277 
278     function _withdraw(address from, uint amount, address to) internal returns (uint) {
279         require(!underlyingIsMinted);
280         require(underlying != address(0) && underlying != address(this));
281         _burn(from, amount);
282         IERC20(underlying).safeTransfer(to, amount);
283         return amount;
284     }
285 
286     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
287      * the total supply.
288      *
289      * Emits a {Transfer} event with `from` set to the zero address.
290      *
291      * Requirements
292      *
293      * - `to` cannot be the zero address.
294      */
295     function _mint(address account, uint256 amount) internal {
296         require(account != address(0), "ERC20: mint to the zero address");
297 
298         _totalSupply += amount;
299         balanceOf[account] += amount;
300         emit Transfer(address(0), account, amount);
301     }
302 
303     /**
304      * @dev Destroys `amount` tokens from `account`, reducing the
305      * total supply.
306      *
307      * Emits a {Transfer} event with `to` set to the zero address.
308      *
309      * Requirements
310      *
311      * - `account` cannot be the zero address.
312      * - `account` must have at least `amount` tokens.
313      */
314     function _burn(address account, uint256 amount) internal {
315         require(account != address(0), "ERC20: burn from the zero address");
316 
317         uint256 balance = balanceOf[account];
318         require(balance >= amount, "ERC20: burn amount exceeds balance");
319 
320         balanceOf[account] = balance - amount;
321         _totalSupply -= amount;
322         emit Transfer(account, address(0), amount);
323     }
324 
325     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV6ERC20 token.
326     /// Emits {Approval} event.
327     /// Returns boolean value indicating whether operation succeeded.
328     function approve(address spender, uint256 value) external override returns (bool) {
329         allowance[msg.sender][spender] = value;
330         emit Approval(msg.sender, spender, value);
331 
332         return true;
333     }
334 
335     /// @dev Moves `value` AnyswapV6ERC20 token from caller's account to account (`to`).
336     /// Emits {Transfer} event.
337     /// Returns boolean value indicating whether operation succeeded.
338     /// Requirements:
339     ///   - caller account must have at least `value` AnyswapV6ERC20 token.
340     function transfer(address to, uint256 value) external override returns (bool) {
341         require(to != address(0) && to != address(this));
342         uint256 balance = balanceOf[msg.sender];
343         require(balance >= value, "AnyswapV6ERC20: transfer amount exceeds balance");
344 
345         balanceOf[msg.sender] = balance - value;
346         balanceOf[to] += value;
347         emit Transfer(msg.sender, to, value);
348 
349         return true;
350     }
351 
352     /// @dev Moves `value` AnyswapV6ERC20 token from account (`from`) to account (`to`) using allowance mechanism.
353     /// `value` is then deducted from caller account's allowance, unless set to `type(uint256).max`.
354     /// Emits {Approval} event to reflect reduced allowance `value` for caller account to spend from account (`from`),
355     /// unless allowance is set to `type(uint256).max`
356     /// Emits {Transfer} event.
357     /// Returns boolean value indicating whether operation succeeded.
358     /// Requirements:
359     ///   - `from` account must have at least `value` balance of AnyswapV6ERC20 token.
360     ///   - `from` account must have approved caller to spend at least `value` of AnyswapV6ERC20 token, unless `from` and caller are the same account.
361     function transferFrom(address from, address to, uint256 value) external override returns (bool) {
362         require(to != address(0) && to != address(this));
363         if (from != msg.sender) {
364             uint256 allowed = allowance[from][msg.sender];
365             if (allowed != type(uint256).max) {
366                 require(allowed >= value, "AnyswapV6ERC20: request exceeds allowance");
367                 uint256 reduced = allowed - value;
368                 allowance[from][msg.sender] = reduced;
369                 emit Approval(from, msg.sender, reduced);
370             }
371         }
372 
373         uint256 balance = balanceOf[from];
374         require(balance >= value, "AnyswapV6ERC20: transfer amount exceeds balance");
375 
376         balanceOf[from] = balance - value;
377         balanceOf[to] += value;
378         emit Transfer(from, to, value);
379 
380         return true;
381     }
382 }