1 /**
2  *Submitted for verification at BscScan.com on 2022-02-11
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
24 /**
25  * @dev Interface of the ERC2612 standard as defined in the EIP.
26  *
27  * Adds the {permit} method, which can be used to change one's
28  * {IERC20-allowance} without having to send a transaction, by signing a
29  * message. This allows users to spend tokens without having to hold Ether.
30  *
31  * See https://eips.ethereum.org/EIPS/eip-2612.
32  */
33 interface IERC2612 {
34 
35     /**
36      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
37      * included whenever a signature is generated for {permit}.
38      *
39      * Every successful call to {permit} increases ``owner``'s nonce by one. This
40      * prevents a signature from being used multiple times.
41      */
42     function nonces(address owner) external view returns (uint256);
43     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
44     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external returns (bool);
45 
46 }
47 
48 /// @dev Wrapped ERC-20 v10 (AnyswapV3ERC20) is an ERC-20 ERC-20 wrapper. You can `deposit` ERC-20 and obtain an AnyswapV3ERC20 balance which can then be operated as an ERC-20 token. You can
49 /// `withdraw` ERC-20 from AnyswapV3ERC20, which will then burn AnyswapV3ERC20 token in your wallet. The amount of AnyswapV3ERC20 token in any wallet is always identical to the
50 /// balance of ERC-20 deposited minus the ERC-20 withdrawn with that specific wallet.
51 interface IAnyswapV3ERC20 is IERC20, IERC2612 {
52 
53     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token,
54     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
55     /// Emits {Approval} event.
56     /// Returns boolean value indicating whether operation succeeded.
57     /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.
58     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
59 
60     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`),
61     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
62     /// A transfer to `address(0)` triggers an ERC-20 withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
63     /// Emits {Transfer} event.
64     /// Returns boolean value indicating whether operation succeeded.
65     /// Requirements:
66     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
67     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
68     function transferAndCall(address to, uint value, bytes calldata data) external returns (bool);
69 }
70 
71 interface ITransferReceiver {
72     function onTokenTransfer(address, uint, bytes calldata) external returns (bool);
73 }
74 
75 interface IApprovalReceiver {
76     function onTokenApproval(address, uint, bytes calldata) external returns (bool);
77 }
78 
79 library Address {
80     function isContract(address account) internal view returns (bool) {
81         bytes32 codehash;
82         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
83         // solhint-disable-next-line no-inline-assembly
84         assembly { codehash := extcodehash(account) }
85         return (codehash != 0x0 && codehash != accountHash);
86     }
87 }
88 
89 library SafeERC20 {
90     using Address for address;
91 
92     function safeTransfer(IERC20 token, address to, uint value) internal {
93         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
94     }
95 
96     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
97         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
98     }
99 
100     function safeApprove(IERC20 token, address spender, uint value) internal {
101         require((value == 0) || (token.allowance(address(this), spender) == 0),
102             "SafeERC20: approve from non-zero to non-zero allowance"
103         );
104         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
105     }
106     function callOptionalReturn(IERC20 token, bytes memory data) private {
107         require(address(token).isContract(), "SafeERC20: call to non-contract");
108 
109         // solhint-disable-next-line avoid-low-level-calls
110         (bool success, bytes memory returndata) = address(token).call(data);
111         require(success, "SafeERC20: low-level call failed");
112 
113         if (returndata.length > 0) { // Return data is optional
114             // solhint-disable-next-line max-line-length
115             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
116         }
117     }
118 }
119 
120 contract AnyswapV6ERC20 is IAnyswapV3ERC20 {
121     using SafeERC20 for IERC20;
122     string public name;
123     string public symbol;
124     uint8  public immutable override decimals;
125 
126     address public immutable underlying;
127 
128     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
129     bytes32 public constant TRANSFER_TYPEHASH = keccak256("Transfer(address owner,address to,uint256 value,uint256 nonce,uint256 deadline)");
130     bytes32 public immutable DOMAIN_SEPARATOR;
131 
132     /// @dev Records amount of AnyswapV3ERC20 token owned by account.
133     mapping (address => uint256) public override balanceOf;
134     uint256 private _totalSupply;
135 
136     // init flag for setting immediate vault, needed for CREATE2 support
137     bool private _init;
138 
139     // flag to enable/disable swapout vs vault.burn so multiple events are triggered
140     bool private _vaultOnly;
141 
142     // configurable delay for timelock functions
143     uint public delay = 2*24*3600;
144 
145 
146     // set of minters, can be this bridge or other bridges
147     mapping(address => bool) public isMinter;
148     address[] public minters;
149 
150     // primary controller of the token contract
151     address public vault;
152 
153     address public pendingMinter;
154     uint public delayMinter;
155 
156     address public pendingVault;
157     uint public delayVault;
158 
159     modifier onlyAuth() {
160         require(isMinter[msg.sender], "AnyswapV4ERC20: FORBIDDEN");
161         _;
162     }
163 
164     modifier onlyVault() {
165         require(msg.sender == mpc(), "AnyswapV3ERC20: FORBIDDEN");
166         _;
167     }
168 
169     function owner() public view returns (address) {
170         return mpc();
171     }
172 
173     function mpc() public view returns (address) {
174         if (block.timestamp >= delayVault) {
175             return pendingVault;
176         }
177         return vault;
178     }
179 
180     function setVaultOnly(bool enabled) external onlyVault {
181         _vaultOnly = enabled;
182     }
183 
184     function initVault(address _vault) external onlyVault {
185         require(_init);
186         vault = _vault;
187         pendingVault = _vault;
188         isMinter[_vault] = true;
189         minters.push(_vault);
190         delayVault = block.timestamp;
191         _init = false;
192     }
193 
194     function setVault(address _vault) external onlyVault {
195         require(_vault != address(0), "AnyswapV3ERC20: address(0x0)");
196         pendingVault = _vault;
197         delayVault = block.timestamp + delay;
198     }
199 
200     function applyVault() external onlyVault {
201         require(block.timestamp >= delayVault);
202         vault = pendingVault;
203     }
204 
205     function setMinter(address _auth) external onlyVault {
206         require(_auth != address(0), "AnyswapV3ERC20: address(0x0)");
207         pendingMinter = _auth;
208         delayMinter = block.timestamp + delay;
209     }
210 
211     function applyMinter() external onlyVault {
212         require(block.timestamp >= delayMinter);
213         isMinter[pendingMinter] = true;
214         minters.push(pendingMinter);
215     }
216 
217     // No time delay revoke minter emergency function
218     function revokeMinter(address _auth) external onlyVault {
219         isMinter[_auth] = false;
220     }
221 
222     function getAllMinters() external view returns (address[] memory) {
223         return minters;
224     }
225 
226     function changeVault(address newVault) external onlyVault returns (bool) {
227         require(newVault != address(0), "AnyswapV3ERC20: address(0x0)");
228         vault = newVault;
229         pendingVault = newVault;
230         emit LogChangeVault(vault, pendingVault, block.timestamp);
231         return true;
232     }
233 
234     function mint(address to, uint256 amount) external onlyAuth returns (bool) {
235         _mint(to, amount);
236         return true;
237     }
238 
239     function burn(address from, uint256 amount) external onlyAuth returns (bool) {
240         require(from != address(0), "AnyswapV3ERC20: address(0x0)");
241         _burn(from, amount);
242         return true;
243     }
244 
245     function Swapin(bytes32 txhash, address account, uint256 amount) public onlyAuth returns (bool) {
246         _mint(account, amount);
247         emit LogSwapin(txhash, account, amount);
248         return true;
249     }
250 
251     function Swapout(uint256 amount, address bindaddr) public returns (bool) {
252         require(!_vaultOnly, "AnyswapV4ERC20: onlyAuth");
253         require(bindaddr != address(0), "AnyswapV3ERC20: address(0x0)");
254         _burn(msg.sender, amount);
255         emit LogSwapout(msg.sender, bindaddr, amount);
256         return true;
257     }
258 
259     /// @dev Records current ERC2612 nonce for account. This value must be included whenever signature is generated for {permit}.
260     /// Every successful call to {permit} increases account's nonce by one. This prevents signature from being used multiple times.
261     mapping (address => uint256) public override nonces;
262 
263     /// @dev Records number of AnyswapV3ERC20 token that account (second) will be allowed to spend on behalf of another account (first) through {transferFrom}.
264     mapping (address => mapping (address => uint256)) public override allowance;
265 
266     event LogChangeVault(address indexed oldVault, address indexed newVault, uint indexed effectiveTime);
267     event LogSwapin(bytes32 indexed txhash, address indexed account, uint amount);
268     event LogSwapout(address indexed account, address indexed bindaddr, uint amount);
269 
270     constructor(string memory _name, string memory _symbol, uint8 _decimals, address _underlying, address _vault) {
271         name = _name;
272         symbol = _symbol;
273         decimals = _decimals;
274         underlying = _underlying;
275         if (_underlying != address(0x0)) {
276             require(_decimals == IERC20(_underlying).decimals());
277         }
278 
279         // Use init to allow for CREATE2 accross all chains
280         _init = true;
281 
282         // Disable/Enable swapout for v1 tokens vs mint/burn for v3 tokens
283         _vaultOnly = false;
284 
285         vault = _vault;
286         pendingVault = _vault;
287         delayVault = block.timestamp;
288 
289         uint256 chainId;
290         assembly {chainId := chainid()}
291         DOMAIN_SEPARATOR = keccak256(
292             abi.encode(
293                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
294                 keccak256(bytes(name)),
295                 keccak256(bytes("1")),
296                 chainId,
297                 address(this)));
298     }
299 
300     /// @dev Returns the total supply of AnyswapV3ERC20 token as the ETH held in this contract.
301     function totalSupply() external view override returns (uint256) {
302         return _totalSupply;
303     }
304 
305     function deposit() external returns (uint) {
306         uint _amount = IERC20(underlying).balanceOf(msg.sender);
307         IERC20(underlying).safeTransferFrom(msg.sender, address(this), _amount);
308         return _deposit(_amount, msg.sender);
309     }
310 
311     function deposit(uint amount) external returns (uint) {
312         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
313         return _deposit(amount, msg.sender);
314     }
315 
316     function deposit(uint amount, address to) external returns (uint) {
317         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
318         return _deposit(amount, to);
319     }
320 
321     function depositVault(uint amount, address to) external onlyVault returns (uint) {
322         return _deposit(amount, to);
323     }
324 
325     function _deposit(uint amount, address to) internal returns (uint) {
326         require(underlying != address(0x0) && underlying != address(this));
327         _mint(to, amount);
328         return amount;
329     }
330 
331     function withdraw() external returns (uint) {
332         return _withdraw(msg.sender, balanceOf[msg.sender], msg.sender);
333     }
334 
335     function withdraw(uint amount) external returns (uint) {
336         return _withdraw(msg.sender, amount, msg.sender);
337     }
338 
339     function withdraw(uint amount, address to) external returns (uint) {
340         return _withdraw(msg.sender, amount, to);
341     }
342 
343     function withdrawVault(address from, uint amount, address to) external onlyVault returns (uint) {
344         return _withdraw(from, amount, to);
345     }
346 
347     function _withdraw(address from, uint amount, address to) internal returns (uint) {
348         _burn(from, amount);
349         IERC20(underlying).safeTransfer(to, amount);
350         return amount;
351     }
352 
353     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
354      * the total supply.
355      *
356      * Emits a {Transfer} event with `from` set to the zero address.
357      *
358      * Requirements
359      *
360      * - `to` cannot be the zero address.
361      */
362     function _mint(address account, uint256 amount) internal {
363         require(account != address(0), "ERC20: mint to the zero address");
364 
365         _totalSupply += amount;
366         balanceOf[account] += amount;
367         emit Transfer(address(0), account, amount);
368     }
369 
370     /**
371      * @dev Destroys `amount` tokens from `account`, reducing the
372      * total supply.
373      *
374      * Emits a {Transfer} event with `to` set to the zero address.
375      *
376      * Requirements
377      *
378      * - `account` cannot be the zero address.
379      * - `account` must have at least `amount` tokens.
380      */
381     function _burn(address account, uint256 amount) internal {
382         require(account != address(0), "ERC20: burn from the zero address");
383 
384         balanceOf[account] -= amount;
385         _totalSupply -= amount;
386         emit Transfer(account, address(0), amount);
387     }
388 
389     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token.
390     /// Emits {Approval} event.
391     /// Returns boolean value indicating whether operation succeeded.
392     function approve(address spender, uint256 value) external override returns (bool) {
393         // _approve(msg.sender, spender, value);
394         allowance[msg.sender][spender] = value;
395         emit Approval(msg.sender, spender, value);
396 
397         return true;
398     }
399 
400     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token,
401     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
402     /// Emits {Approval} event.
403     /// Returns boolean value indicating whether operation succeeded.
404     /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.
405     function approveAndCall(address spender, uint256 value, bytes calldata data) external override returns (bool) {
406         // _approve(msg.sender, spender, value);
407         allowance[msg.sender][spender] = value;
408         emit Approval(msg.sender, spender, value);
409 
410         return IApprovalReceiver(spender).onTokenApproval(msg.sender, value, data);
411     }
412 
413     /// @dev Sets `value` as allowance of `spender` account over `owner` account's AnyswapV3ERC20 token, given `owner` account's signed approval.
414     /// Emits {Approval} event.
415     /// Requirements:
416     ///   - `deadline` must be timestamp in future.
417     ///   - `v`, `r` and `s` must be valid `secp256k1` signature from `owner` account over EIP712-formatted function arguments.
418     ///   - the signature must use `owner` account's current nonce (see {nonces}).
419     ///   - the signer cannot be zero address and must be `owner` account.
420     /// For more information on signature format, see https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP section].
421     /// AnyswapV3ERC20 token implementation adapted from https://github.com/albertocuestacanada/ERC20Permit/blob/master/contracts/ERC20Permit.sol.
422     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override {
423         require(block.timestamp <= deadline, "AnyswapV3ERC20: Expired permit");
424 
425         bytes32 hashStruct = keccak256(
426             abi.encode(
427                 PERMIT_TYPEHASH,
428                 target,
429                 spender,
430                 value,
431                 nonces[target]++,
432                 deadline));
433 
434         require(verifyEIP712(target, hashStruct, v, r, s) || verifyPersonalSign(target, hashStruct, v, r, s));
435 
436         // _approve(owner, spender, value);
437         allowance[target][spender] = value;
438         emit Approval(target, spender, value);
439     }
440 
441     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override returns (bool) {
442         require(block.timestamp <= deadline, "AnyswapV3ERC20: Expired permit");
443 
444         bytes32 hashStruct = keccak256(
445             abi.encode(
446                 TRANSFER_TYPEHASH,
447                 target,
448                 to,
449                 value,
450                 nonces[target]++,
451                 deadline));
452 
453         require(verifyEIP712(target, hashStruct, v, r, s) || verifyPersonalSign(target, hashStruct, v, r, s));
454 
455         require(to != address(0) || to != address(this));
456 
457         uint256 balance = balanceOf[target];
458         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
459 
460         balanceOf[target] = balance - value;
461         balanceOf[to] += value;
462         emit Transfer(target, to, value);
463 
464         return true;
465     }
466 
467     function verifyEIP712(address target, bytes32 hashStruct, uint8 v, bytes32 r, bytes32 s) internal view returns (bool) {
468         bytes32 hash = keccak256(
469             abi.encodePacked(
470                 "\x19\x01",
471                 DOMAIN_SEPARATOR,
472                 hashStruct));
473         address signer = ecrecover(hash, v, r, s);
474         return (signer != address(0) && signer == target);
475     }
476 
477     function verifyPersonalSign(address target, bytes32 hashStruct, uint8 v, bytes32 r, bytes32 s) internal view returns (bool) {
478         bytes32 hash = keccak256(
479             abi.encodePacked(
480                 "\x19Ethereum Signed Message:\n32",
481                 DOMAIN_SEPARATOR,
482                 hashStruct));
483         address signer = ecrecover(hash, v, r, s);
484         return (signer != address(0) && signer == target);
485     }
486 
487     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`).
488     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
489     /// Emits {Transfer} event.
490     /// Returns boolean value indicating whether operation succeeded.
491     /// Requirements:
492     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
493     function transfer(address to, uint256 value) external override returns (bool) {
494         require(to != address(0) || to != address(this));
495         uint256 balance = balanceOf[msg.sender];
496         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
497 
498         balanceOf[msg.sender] = balance - value;
499         balanceOf[to] += value;
500         emit Transfer(msg.sender, to, value);
501 
502         return true;
503     }
504 
505     /// @dev Moves `value` AnyswapV3ERC20 token from account (`from`) to account (`to`) using allowance mechanism.
506     /// `value` is then deducted from caller account's allowance, unless set to `type(uint256).max`.
507     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
508     /// Emits {Approval} event to reflect reduced allowance `value` for caller account to spend from account (`from`),
509     /// unless allowance is set to `type(uint256).max`
510     /// Emits {Transfer} event.
511     /// Returns boolean value indicating whether operation succeeded.
512     /// Requirements:
513     ///   - `from` account must have at least `value` balance of AnyswapV3ERC20 token.
514     ///   - `from` account must have approved caller to spend at least `value` of AnyswapV3ERC20 token, unless `from` and caller are the same account.
515     function transferFrom(address from, address to, uint256 value) external override returns (bool) {
516         require(to != address(0) || to != address(this));
517         if (from != msg.sender) {
518             // _decreaseAllowance(from, msg.sender, value);
519             uint256 allowed = allowance[from][msg.sender];
520             if (allowed != type(uint256).max) {
521                 require(allowed >= value, "AnyswapV3ERC20: request exceeds allowance");
522                 uint256 reduced = allowed - value;
523                 allowance[from][msg.sender] = reduced;
524                 emit Approval(from, msg.sender, reduced);
525             }
526         }
527 
528         uint256 balance = balanceOf[from];
529         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
530 
531         balanceOf[from] = balance - value;
532         balanceOf[to] += value;
533         emit Transfer(from, to, value);
534 
535         return true;
536     }
537 
538     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`),
539     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
540     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
541     /// Emits {Transfer} event.
542     /// Returns boolean value indicating whether operation succeeded.
543     /// Requirements:
544     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
545     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
546     function transferAndCall(address to, uint value, bytes calldata data) external override returns (bool) {
547         require(to != address(0) || to != address(this));
548 
549         uint256 balance = balanceOf[msg.sender];
550         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
551 
552         balanceOf[msg.sender] = balance - value;
553         balanceOf[to] += value;
554         emit Transfer(msg.sender, to, value);
555 
556         return ITransferReceiver(to).onTokenTransfer(msg.sender, value, data);
557     }
558 }