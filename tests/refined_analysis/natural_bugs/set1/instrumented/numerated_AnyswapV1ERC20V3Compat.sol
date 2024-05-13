1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity 0.8.1;
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
16     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
17     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external returns (bool);
18     event Transfer(address indexed from, address indexed to, uint256 value);
19     event Approval(address indexed owner, address indexed spender, uint256 value);
20 }
21 
22 /**
23  * @dev Interface of the ERC2612 standard as defined in the EIP.
24  *
25  * Adds the {permit} method, which can be used to change one's
26  * {IERC20-allowance} without having to send a transaction, by signing a
27  * message. This allows users to spend tokens without having to hold Ether.
28  *
29  * See https://eips.ethereum.org/EIPS/eip-2612.
30  */
31 interface IERC2612 {
32 
33     /**
34      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
35      * included whenever a signature is generated for {permit}.
36      *
37      * Every successful call to {permit} increases ``owner``'s nonce by one. This
38      * prevents a signature from being used multiple times.
39      */
40     function nonces(address owner) external view returns (uint256);
41 }
42 
43 /// @dev Wrapped ERC-20 v10 (AnyswapV3ERC20) is an ERC-20 ERC-20 wrapper. You can `deposit` ERC-20 and obtain an AnyswapV3ERC20 balance which can then be operated as an ERC-20 token. You can
44 /// `withdraw` ERC-20 from AnyswapV3ERC20, which will then burn AnyswapV3ERC20 token in your wallet. The amount of AnyswapV3ERC20 token in any wallet is always identical to the
45 /// balance of ERC-20 deposited minus the ERC-20 withdrawn with that specific wallet.
46 interface IAnyswapV3ERC20 is IERC20, IERC2612 {
47 
48     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token,
49     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
50     /// Emits {Approval} event.
51     /// Returns boolean value indicating whether operation succeeded.
52     /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.
53     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
54 
55     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`),
56     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
57     /// A transfer to `address(0)` triggers an ERC-20 withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
58     /// Emits {Transfer} event.
59     /// Returns boolean value indicating whether operation succeeded.
60     /// Requirements:
61     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
62     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
63     function transferAndCall(address to, uint value, bytes calldata data) external returns (bool);
64 }
65 
66 interface ITransferReceiver {
67     function onTokenTransfer(address, uint, bytes calldata) external returns (bool);
68 }
69 
70 interface IApprovalReceiver {
71     function onTokenApproval(address, uint, bytes calldata) external returns (bool);
72 }
73 
74 library Address {
75     function isContract(address account) internal view returns (bool) {
76         bytes32 codehash;
77         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
78         // solhint-disable-next-line no-inline-assembly
79         assembly { codehash := extcodehash(account) }
80         return (codehash != 0x0 && codehash != accountHash);
81     }
82 }
83 
84 library SafeERC20 {
85     using Address for address;
86 
87     function safeTransfer(IERC20 token, address to, uint value) internal {
88         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
89     }
90 
91     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
92         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
93     }
94 
95     function safeApprove(IERC20 token, address spender, uint value) internal {
96         require((value == 0) || (token.allowance(address(this), spender) == 0),
97             "SafeERC20: approve from non-zero to non-zero allowance"
98         );
99         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
100     }
101     function callOptionalReturn(IERC20 token, bytes memory data) private {
102         require(address(token).isContract(), "SafeERC20: call to non-contract");
103 
104         // solhint-disable-next-line avoid-low-level-calls
105         (bool success, bytes memory returndata) = address(token).call(data);
106         require(success, "SafeERC20: low-level call failed");
107 
108         if (returndata.length > 0) { // Return data is optional
109             // solhint-disable-next-line max-line-length
110             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
111         }
112     }
113 }
114 
115 contract AnyswapV1ERC20 is IAnyswapV3ERC20 {
116     using SafeERC20 for IERC20;
117     string public name;
118     string public symbol;
119     uint8  public immutable override decimals;
120 
121     address public immutable underlying;
122 
123     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
124     bytes32 public constant TRANSFER_TYPEHASH = keccak256("Transfer(address owner,address to,uint256 value,uint256 nonce,uint256 deadline)");
125     bytes32 public immutable DOMAIN_SEPARATOR;
126 
127     /// @dev Records amount of AnyswapV3ERC20 token owned by account.
128     mapping (address => uint256) public override balanceOf;
129     uint256 private _totalSupply;
130 
131     address private _oldVault;
132     address private _newVault;
133     uint256 private _newVaultEffectiveTime;
134 
135 
136     modifier onlyVault() {
137         require(msg.sender == vault(), "AnyswapV3ERC20: FORBIDDEN");
138         _;
139     }
140 
141     function vault() public view returns (address) {
142         if (block.timestamp >= _newVaultEffectiveTime) {
143             return _newVault;
144         }
145         return _oldVault;
146     }
147 
148     function owner() public view returns (address) {
149         return vault();
150     }
151 
152 
153     function changeVault(address newVault) external onlyVault returns (bool) {
154         require(newVault != address(0), "AnyswapV3ERC20: address(0x0)");
155         _oldVault = vault();
156         _newVault = newVault;
157         _newVaultEffectiveTime = block.timestamp + 2*24*3600;
158         emit LogChangeVault(_oldVault, _newVault, _newVaultEffectiveTime);
159         return true;
160     }
161 
162     function changeMPCOwner(address newVault) public onlyVault returns (bool) {
163         require(newVault != address(0), "AnyswapV3ERC20: address(0x0)");
164         _oldVault = vault();
165         _newVault = newVault;
166         _newVaultEffectiveTime = block.timestamp + 2*24*3600;
167         emit LogChangeMPCOwner(_oldVault, _newVault, _newVaultEffectiveTime);
168         return true;
169     }
170 
171     function mint(address to, uint256 amount) external onlyVault returns (bool) {
172         _mint(to, amount);
173         return true;
174     }
175 
176     function burn(address from, uint256 amount) external onlyVault returns (bool) {
177         require(from != address(0), "AnyswapV3ERC20: address(0x0)");
178         _burn(from, amount);
179         return true;
180     }
181 
182     function Swapin(bytes32 txhash, address account, uint256 amount) public onlyVault returns (bool) {
183         _mint(account, amount);
184         emit LogSwapin(txhash, account, amount);
185         return true;
186     }
187 
188     function Swapout(uint256 amount, address bindaddr) public returns (bool) {
189         require(bindaddr != address(0), "AnyswapV3ERC20: address(0x0)");
190         _burn(msg.sender, amount);
191         emit LogSwapout(msg.sender, bindaddr, amount);
192         return true;
193     }
194 
195     /// @dev Records current ERC2612 nonce for account. This value must be included whenever signature is generated for {permit}.
196     /// Every successful call to {permit} increases account's nonce by one. This prevents signature from being used multiple times.
197     mapping (address => uint256) public override nonces;
198 
199     /// @dev Records number of AnyswapV3ERC20 token that account (second) will be allowed to spend on behalf of another account (first) through {transferFrom}.
200     mapping (address => mapping (address => uint256)) public override allowance;
201 
202     event LogChangeVault(address indexed oldVault, address indexed newVault, uint indexed effectiveTime);
203     event LogChangeMPCOwner(address indexed oldOwner, address indexed newOwner, uint indexed effectiveHeight);
204     event LogSwapin(bytes32 indexed txhash, address indexed account, uint amount);
205     event LogSwapout(address indexed account, address indexed bindaddr, uint amount);
206 
207     constructor(string memory _name, string memory _symbol, uint8 _decimals, address _underlying, address _vault) {
208         name = _name;
209         symbol = _symbol;
210         decimals = _decimals;
211         underlying = _underlying;
212         if (_underlying != address(0x0)) {
213             require(_decimals == IERC20(_underlying).decimals());
214         }
215 
216         _newVault = _vault;
217         _newVaultEffectiveTime = block.timestamp;
218 
219         uint256 chainId;
220         assembly {chainId := chainid()}
221         DOMAIN_SEPARATOR = keccak256(
222             abi.encode(
223                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
224                 keccak256(bytes(name)),
225                 keccak256(bytes("1")),
226                 chainId,
227                 address(this)));
228     }
229 
230     /// @dev Returns the total supply of AnyswapV3ERC20 token as the ETH held in this contract.
231     function totalSupply() external view override returns (uint256) {
232         return _totalSupply;
233     }
234 
235     function depositWithPermit(address target, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s, address to) external returns (uint) {
236         IERC20(underlying).permit(target, address(this), value, deadline, v, r, s);
237         IERC20(underlying).safeTransferFrom(target, address(this), value);
238         return _deposit(value, to);
239     }
240 
241     function depositWithTransferPermit(address target, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s, address to) external returns (uint) {
242         IERC20(underlying).transferWithPermit(target, address(this), value, deadline, v, r, s);
243         return _deposit(value, to);
244     }
245 
246     function deposit() external returns (uint) {
247         uint _amount = IERC20(underlying).balanceOf(msg.sender);
248         IERC20(underlying).safeTransferFrom(msg.sender, address(this), _amount);
249         return _deposit(_amount, msg.sender);
250     }
251 
252     function deposit(uint amount) external returns (uint) {
253         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
254         return _deposit(amount, msg.sender);
255     }
256 
257     function deposit(uint amount, address to) external returns (uint) {
258         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
259         return _deposit(amount, to);
260     }
261 
262     function depositVault(uint amount, address to) external onlyVault returns (uint) {
263         return _deposit(amount, to);
264     }
265 
266     function _deposit(uint amount, address to) internal returns (uint) {
267         require(underlying != address(0x0) && underlying != address(this));
268         _mint(to, amount);
269         return amount;
270     }
271 
272     function withdraw() external returns (uint) {
273         return _withdraw(msg.sender, balanceOf[msg.sender], msg.sender);
274     }
275 
276     function withdraw(uint amount) external returns (uint) {
277         return _withdraw(msg.sender, amount, msg.sender);
278     }
279 
280     function withdraw(uint amount, address to) external returns (uint) {
281         return _withdraw(msg.sender, amount, to);
282     }
283 
284     function withdrawVault(address from, uint amount, address to) external onlyVault returns (uint) {
285         return _withdraw(from, amount, to);
286     }
287 
288     function _withdraw(address from, uint amount, address to) internal returns (uint) {
289         _burn(from, amount);
290         IERC20(underlying).safeTransfer(to, amount);
291         return amount;
292     }
293 
294     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
295      * the total supply.
296      *
297      * Emits a {Transfer} event with `from` set to the zero address.
298      *
299      * Requirements
300      *
301      * - `to` cannot be the zero address.
302      */
303     function _mint(address account, uint256 amount) internal {
304         require(account != address(0), "ERC20: mint to the zero address");
305 
306         _totalSupply += amount;
307         balanceOf[account] += amount;
308         emit Transfer(address(0), account, amount);
309     }
310 
311     /**
312      * @dev Destroys `amount` tokens from `account`, reducing the
313      * total supply.
314      *
315      * Emits a {Transfer} event with `to` set to the zero address.
316      *
317      * Requirements
318      *
319      * - `account` cannot be the zero address.
320      * - `account` must have at least `amount` tokens.
321      */
322     function _burn(address account, uint256 amount) internal {
323         require(account != address(0), "ERC20: burn from the zero address");
324 
325         balanceOf[account] -= amount;
326         _totalSupply -= amount;
327         emit Transfer(account, address(0), amount);
328     }
329 
330     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token.
331     /// Emits {Approval} event.
332     /// Returns boolean value indicating whether operation succeeded.
333     function approve(address spender, uint256 value) external override returns (bool) {
334         // _approve(msg.sender, spender, value);
335         allowance[msg.sender][spender] = value;
336         emit Approval(msg.sender, spender, value);
337 
338         return true;
339     }
340 
341     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token,
342     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
343     /// Emits {Approval} event.
344     /// Returns boolean value indicating whether operation succeeded.
345     /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.
346     function approveAndCall(address spender, uint256 value, bytes calldata data) external override returns (bool) {
347         // _approve(msg.sender, spender, value);
348         allowance[msg.sender][spender] = value;
349         emit Approval(msg.sender, spender, value);
350 
351         return IApprovalReceiver(spender).onTokenApproval(msg.sender, value, data);
352     }
353 
354     /// @dev Sets `value` as allowance of `spender` account over `owner` account's AnyswapV3ERC20 token, given `owner` account's signed approval.
355     /// Emits {Approval} event.
356     /// Requirements:
357     ///   - `deadline` must be timestamp in future.
358     ///   - `v`, `r` and `s` must be valid `secp256k1` signature from `owner` account over EIP712-formatted function arguments.
359     ///   - the signature must use `owner` account's current nonce (see {nonces}).
360     ///   - the signer cannot be zero address and must be `owner` account.
361     /// For more information on signature format, see https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP section].
362     /// AnyswapV3ERC20 token implementation adapted from https://github.com/albertocuestacanada/ERC20Permit/blob/master/contracts/ERC20Permit.sol.
363     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override {
364         require(block.timestamp <= deadline, "AnyswapV3ERC20: Expired permit");
365 
366         bytes32 hashStruct = keccak256(
367             abi.encode(
368                 PERMIT_TYPEHASH,
369                 target,
370                 spender,
371                 value,
372                 nonces[target]++,
373                 deadline));
374 
375         require(verifyEIP712(target, hashStruct, v, r, s) || verifyPersonalSign(target, hashStruct, v, r, s));
376 
377         // _approve(owner, spender, value);
378         allowance[target][spender] = value;
379         emit Approval(target, spender, value);
380     }
381 
382     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override returns (bool) {
383         require(block.timestamp <= deadline, "AnyswapV3ERC20: Expired permit");
384 
385         bytes32 hashStruct = keccak256(
386             abi.encode(
387                 TRANSFER_TYPEHASH,
388                 target,
389                 to,
390                 value,
391                 nonces[target]++,
392                 deadline));
393 
394         require(verifyEIP712(target, hashStruct, v, r, s) || verifyPersonalSign(target, hashStruct, v, r, s));
395 
396         require(to != address(0) || to != address(this));
397 
398         uint256 balance = balanceOf[target];
399         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
400 
401         balanceOf[target] = balance - value;
402         balanceOf[to] += value;
403         emit Transfer(target, to, value);
404 
405         return true;
406     }
407 
408     function verifyEIP712(address target, bytes32 hashStruct, uint8 v, bytes32 r, bytes32 s) internal view returns (bool) {
409         bytes32 hash = keccak256(
410             abi.encodePacked(
411                 "\x19\x01",
412                 DOMAIN_SEPARATOR,
413                 hashStruct));
414         address signer = ecrecover(hash, v, r, s);
415         return (signer != address(0) && signer == target);
416     }
417 
418     function verifyPersonalSign(address target, bytes32 hashStruct, uint8 v, bytes32 r, bytes32 s) internal pure returns (bool) {
419         bytes32 hash = prefixed(hashStruct);
420         address signer = ecrecover(hash, v, r, s);
421         return (signer != address(0) && signer == target);
422     }
423 
424     // Builds a prefixed hash to mimic the behavior of eth_sign.
425     function prefixed(bytes32 hash) internal pure returns (bytes32) {
426         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
427     }
428 
429     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`).
430     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
431     /// Emits {Transfer} event.
432     /// Returns boolean value indicating whether operation succeeded.
433     /// Requirements:
434     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
435     function transfer(address to, uint256 value) external override returns (bool) {
436         require(to != address(0) || to != address(this));
437         uint256 balance = balanceOf[msg.sender];
438         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
439 
440         balanceOf[msg.sender] = balance - value;
441         balanceOf[to] += value;
442         emit Transfer(msg.sender, to, value);
443 
444         return true;
445     }
446 
447     /// @dev Moves `value` AnyswapV3ERC20 token from account (`from`) to account (`to`) using allowance mechanism.
448     /// `value` is then deducted from caller account's allowance, unless set to `type(uint256).max`.
449     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
450     /// Emits {Approval} event to reflect reduced allowance `value` for caller account to spend from account (`from`),
451     /// unless allowance is set to `type(uint256).max`
452     /// Emits {Transfer} event.
453     /// Returns boolean value indicating whether operation succeeded.
454     /// Requirements:
455     ///   - `from` account must have at least `value` balance of AnyswapV3ERC20 token.
456     ///   - `from` account must have approved caller to spend at least `value` of AnyswapV3ERC20 token, unless `from` and caller are the same account.
457     function transferFrom(address from, address to, uint256 value) external override returns (bool) {
458         require(to != address(0) || to != address(this));
459         if (from != msg.sender) {
460             // _decreaseAllowance(from, msg.sender, value);
461             uint256 allowed = allowance[from][msg.sender];
462             if (allowed != type(uint256).max) {
463                 require(allowed >= value, "AnyswapV3ERC20: request exceeds allowance");
464                 uint256 reduced = allowed - value;
465                 allowance[from][msg.sender] = reduced;
466                 emit Approval(from, msg.sender, reduced);
467             }
468         }
469 
470         uint256 balance = balanceOf[from];
471         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
472 
473         balanceOf[from] = balance - value;
474         balanceOf[to] += value;
475         emit Transfer(from, to, value);
476 
477         return true;
478     }
479 
480     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`),
481     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
482     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
483     /// Emits {Transfer} event.
484     /// Returns boolean value indicating whether operation succeeded.
485     /// Requirements:
486     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
487     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
488     function transferAndCall(address to, uint value, bytes calldata data) external override returns (bool) {
489         require(to != address(0) || to != address(this));
490 
491         uint256 balance = balanceOf[msg.sender];
492         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
493 
494         balanceOf[msg.sender] = balance - value;
495         balanceOf[to] += value;
496         emit Transfer(msg.sender, to, value);
497 
498         return ITransferReceiver(to).onTokenTransfer(msg.sender, value, data);
499     }
500 }
