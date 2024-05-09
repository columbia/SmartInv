1 /**
2  *Submitted for verification at Etherscan.io on 2022-04-21
3 */
4 
5 /**
6  *Submitted for verification at snowtrace.io on 2022-04-13
7 */
8 
9 /**
10  *Submitted for verification at Arbiscan on 2022-04-01
11 */
12 
13 /**
14  *Submitted for verification at Arbiscan on 2022-04-01
15 */
16 
17 /**
18  *Submitted for verification at Arbiscan on 2022-03-24
19 */
20 
21 /**
22  *Submitted for verification at BscScan.com on 2022-03-22
23 */
24 
25 /**
26  *Submitted for verification at FtmScan.com on 2022-03-18
27 */
28 
29 /**
30  *Submitted for verification at BscScan.com on 2022-03-17
31 */
32 
33 /**
34  *Submitted for verification at BscScan.com on 2022-03-15
35 */
36 
37 /**
38  *Submitted for verification at BscScan.com on 2022-03-11
39 */
40 
41 /**
42  *Submitted for verification at BscScan.com on 2022-03-09
43 */
44 
45 /**
46  *Submitted for verification at BscScan.com on 2022-02-11
47 */
48 
49 // SPDX-License-Identifier: GPL-3.0-or-later
50 
51 pragma solidity ^0.8.2;
52 
53 /**
54  * @dev Interface of the ERC20 standard as defined in the EIP.
55  */
56 interface IERC20 {
57     function totalSupply() external view returns (uint256);
58     function decimals() external view returns (uint8);
59     function balanceOf(address account) external view returns (uint256);
60     function transfer(address recipient, uint256 amount) external returns (bool);
61     function allowance(address owner, address spender) external view returns (uint256);
62     function approve(address spender, uint256 amount) external returns (bool);
63     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
64     event Transfer(address indexed from, address indexed to, uint256 value);
65     event Approval(address indexed owner, address indexed spender, uint256 value);
66 }
67 
68 /**
69  * @dev Interface of the ERC2612 standard as defined in the EIP.
70  *
71  * Adds the {permit} method, which can be used to change one's
72  * {IERC20-allowance} without having to send a transaction, by signing a
73  * message. This allows users to spend tokens without having to hold Ether.
74  *
75  * See https://eips.ethereum.org/EIPS/eip-2612.
76  */
77 interface IERC2612 {
78 
79     /**
80      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
81      * included whenever a signature is generated for {permit}.
82      *
83      * Every successful call to {permit} increases ``owner``'s nonce by one. This
84      * prevents a signature from being used multiple times.
85      */
86     function nonces(address owner) external view returns (uint256);
87     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
88     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external returns (bool);
89 
90 }
91 
92 /// @dev Wrapped ERC-20 v10 (AnyswapV3ERC20) is an ERC-20 ERC-20 wrapper. You can `deposit` ERC-20 and obtain an AnyswapV3ERC20 balance which can then be operated as an ERC-20 token. You can
93 /// `withdraw` ERC-20 from AnyswapV3ERC20, which will then burn AnyswapV3ERC20 token in your wallet. The amount of AnyswapV3ERC20 token in any wallet is always identical to the
94 /// balance of ERC-20 deposited minus the ERC-20 withdrawn with that specific wallet.
95 interface IAnyswapV3ERC20 is IERC20, IERC2612 {
96 
97     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token,
98     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
99     /// Emits {Approval} event.
100     /// Returns boolean value indicating whether operation succeeded.
101     /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.
102     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
103 
104     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`),
105     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
106     /// A transfer to `address(0)` triggers an ERC-20 withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
107     /// Emits {Transfer} event.
108     /// Returns boolean value indicating whether operation succeeded.
109     /// Requirements:
110     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
111     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
112     function transferAndCall(address to, uint value, bytes calldata data) external returns (bool);
113 }
114 
115 interface ITransferReceiver {
116     function onTokenTransfer(address, uint, bytes calldata) external returns (bool);
117 }
118 
119 interface IApprovalReceiver {
120     function onTokenApproval(address, uint, bytes calldata) external returns (bool);
121 }
122 
123 library Address {
124     function isContract(address account) internal view returns (bool) {
125         bytes32 codehash;
126         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
127         // solhint-disable-next-line no-inline-assembly
128         assembly { codehash := extcodehash(account) }
129         return (codehash != 0x0 && codehash != accountHash);
130     }
131 }
132 
133 library SafeERC20 {
134     using Address for address;
135 
136     function safeTransfer(IERC20 token, address to, uint value) internal {
137         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
138     }
139 
140     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
141         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
142     }
143 
144     function safeApprove(IERC20 token, address spender, uint value) internal {
145         require((value == 0) || (token.allowance(address(this), spender) == 0),
146             "SafeERC20: approve from non-zero to non-zero allowance"
147         );
148         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
149     }
150     function callOptionalReturn(IERC20 token, bytes memory data) private {
151         require(address(token).isContract(), "SafeERC20: call to non-contract");
152 
153         // solhint-disable-next-line avoid-low-level-calls
154         (bool success, bytes memory returndata) = address(token).call(data);
155         require(success, "SafeERC20: low-level call failed");
156 
157         if (returndata.length > 0) { // Return data is optional
158             // solhint-disable-next-line max-line-length
159             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
160         }
161     }
162 }
163 
164 contract AnyswapV6ERC20 is IAnyswapV3ERC20 {
165     using SafeERC20 for IERC20;
166     string public name;
167     string public symbol;
168     uint8  public immutable override decimals;
169 
170     address public immutable underlying;
171 
172     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
173     bytes32 public constant TRANSFER_TYPEHASH = keccak256("Transfer(address owner,address to,uint256 value,uint256 nonce,uint256 deadline)");
174     bytes32 public immutable DOMAIN_SEPARATOR;
175 
176     /// @dev Records amount of AnyswapV3ERC20 token owned by account.
177     mapping (address => uint256) public override balanceOf;
178     uint256 private _totalSupply;
179 
180     // init flag for setting immediate vault, needed for CREATE2 support
181     bool private _init;
182 
183     // flag to enable/disable swapout vs vault.burn so multiple events are triggered
184     bool private _vaultOnly;
185 
186     // configurable delay for timelock functions
187     uint public delay = 2*24*3600;
188 
189 
190     // set of minters, can be this bridge or other bridges
191     mapping(address => bool) public isMinter;
192     address[] public minters;
193 
194     // primary controller of the token contract
195     address public vault;
196 
197     address public pendingMinter;
198     uint public delayMinter;
199 
200     address public pendingVault;
201     uint public delayVault;
202 
203     modifier onlyAuth() {
204         require(isMinter[msg.sender], "AnyswapV4ERC20: FORBIDDEN");
205         _;
206     }
207 
208     modifier onlyVault() {
209         require(msg.sender == mpc(), "AnyswapV3ERC20: FORBIDDEN");
210         _;
211     }
212 
213     function owner() public view returns (address) {
214         return mpc();
215     }
216 
217     function mpc() public view returns (address) {
218         if (block.timestamp >= delayVault) {
219             return pendingVault;
220         }
221         return vault;
222     }
223 
224     function setVaultOnly(bool enabled) external onlyVault {
225         _vaultOnly = enabled;
226     }
227 
228     function initVault(address _vault) external onlyVault {
229         require(_init);
230         vault = _vault;
231         pendingVault = _vault;
232         isMinter[_vault] = true;
233         minters.push(_vault);
234         delayVault = block.timestamp;
235         _init = false;
236     }
237 
238     function setVault(address _vault) external onlyVault {
239         require(_vault != address(0), "AnyswapV3ERC20: address(0x0)");
240         pendingVault = _vault;
241         delayVault = block.timestamp + delay;
242     }
243 
244     function applyVault() external onlyVault {
245         require(block.timestamp >= delayVault);
246         vault = pendingVault;
247     }
248 
249     function setMinter(address _auth) external onlyVault {
250         require(_auth != address(0), "AnyswapV3ERC20: address(0x0)");
251         pendingMinter = _auth;
252         delayMinter = block.timestamp + delay;
253     }
254 
255     function applyMinter() external onlyVault {
256         require(block.timestamp >= delayMinter);
257         isMinter[pendingMinter] = true;
258         minters.push(pendingMinter);
259     }
260 
261     // No time delay revoke minter emergency function
262     function revokeMinter(address _auth) external onlyVault {
263         isMinter[_auth] = false;
264     }
265 
266     function getAllMinters() external view returns (address[] memory) {
267         return minters;
268     }
269 
270     function changeVault(address newVault) external onlyVault returns (bool) {
271         require(newVault != address(0), "AnyswapV3ERC20: address(0x0)");
272         vault = newVault;
273         pendingVault = newVault;
274         emit LogChangeVault(vault, pendingVault, block.timestamp);
275         return true;
276     }
277 
278     function mint(address to, uint256 amount) external onlyAuth returns (bool) {
279         _mint(to, amount);
280         return true;
281     }
282 
283     function burn(address from, uint256 amount) external onlyAuth returns (bool) {
284         require(from != address(0), "AnyswapV3ERC20: address(0x0)");
285         _burn(from, amount);
286         return true;
287     }
288 
289     function Swapin(bytes32 txhash, address account, uint256 amount) public onlyAuth returns (bool) {
290         _mint(account, amount);
291         emit LogSwapin(txhash, account, amount);
292         return true;
293     }
294 
295     function Swapout(uint256 amount, address bindaddr) public returns (bool) {
296         require(!_vaultOnly, "AnyswapV4ERC20: onlyAuth");
297         require(bindaddr != address(0), "AnyswapV3ERC20: address(0x0)");
298         _burn(msg.sender, amount);
299         emit LogSwapout(msg.sender, bindaddr, amount);
300         return true;
301     }
302 
303     /// @dev Records current ERC2612 nonce for account. This value must be included whenever signature is generated for {permit}.
304     /// Every successful call to {permit} increases account's nonce by one. This prevents signature from being used multiple times.
305     mapping (address => uint256) public override nonces;
306 
307     /// @dev Records number of AnyswapV3ERC20 token that account (second) will be allowed to spend on behalf of another account (first) through {transferFrom}.
308     mapping (address => mapping (address => uint256)) public override allowance;
309 
310     event LogChangeVault(address indexed oldVault, address indexed newVault, uint indexed effectiveTime);
311     event LogSwapin(bytes32 indexed txhash, address indexed account, uint amount);
312     event LogSwapout(address indexed account, address indexed bindaddr, uint amount);
313 
314     constructor(string memory _name, string memory _symbol, uint8 _decimals, address _underlying, address _vault) {
315         name = _name;
316         symbol = _symbol;
317         decimals = _decimals;
318         underlying = _underlying;
319         if (_underlying != address(0x0)) {
320             require(_decimals == IERC20(_underlying).decimals());
321         }
322 
323         // Use init to allow for CREATE2 accross all chains
324         _init = true;
325 
326         // Disable/Enable swapout for v1 tokens vs mint/burn for v3 tokens
327         _vaultOnly = false;
328 
329         vault = _vault;
330         pendingVault = _vault;
331         delayVault = block.timestamp;
332 
333         uint256 chainId;
334         assembly {chainId := chainid()}
335         DOMAIN_SEPARATOR = keccak256(
336             abi.encode(
337                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
338                 keccak256(bytes(name)),
339                 keccak256(bytes("1")),
340                 chainId,
341                 address(this)));
342     }
343 
344     /// @dev Returns the total supply of AnyswapV3ERC20 token as the ETH held in this contract.
345     function totalSupply() external view override returns (uint256) {
346         return _totalSupply;
347     }
348 
349     function deposit() external returns (uint) {
350         uint _amount = IERC20(underlying).balanceOf(msg.sender);
351         IERC20(underlying).safeTransferFrom(msg.sender, address(this), _amount);
352         return _deposit(_amount, msg.sender);
353     }
354 
355     function deposit(uint amount) external returns (uint) {
356         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
357         return _deposit(amount, msg.sender);
358     }
359 
360     function deposit(uint amount, address to) external returns (uint) {
361         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
362         return _deposit(amount, to);
363     }
364 
365     function depositVault(uint amount, address to) external onlyVault returns (uint) {
366         return _deposit(amount, to);
367     }
368 
369     function _deposit(uint amount, address to) internal returns (uint) {
370         require(underlying != address(0x0) && underlying != address(this));
371         _mint(to, amount);
372         return amount;
373     }
374 
375     function withdraw() external returns (uint) {
376         return _withdraw(msg.sender, balanceOf[msg.sender], msg.sender);
377     }
378 
379     function withdraw(uint amount) external returns (uint) {
380         return _withdraw(msg.sender, amount, msg.sender);
381     }
382 
383     function withdraw(uint amount, address to) external returns (uint) {
384         return _withdraw(msg.sender, amount, to);
385     }
386 
387     function withdrawVault(address from, uint amount, address to) external onlyVault returns (uint) {
388         return _withdraw(from, amount, to);
389     }
390 
391     function _withdraw(address from, uint amount, address to) internal returns (uint) {
392         _burn(from, amount);
393         IERC20(underlying).safeTransfer(to, amount);
394         return amount;
395     }
396 
397     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
398      * the total supply.
399      *
400      * Emits a {Transfer} event with `from` set to the zero address.
401      *
402      * Requirements
403      *
404      * - `to` cannot be the zero address.
405      */
406     function _mint(address account, uint256 amount) internal {
407         require(account != address(0), "ERC20: mint to the zero address");
408 
409         _totalSupply += amount;
410         balanceOf[account] += amount;
411         emit Transfer(address(0), account, amount);
412     }
413 
414     /**
415      * @dev Destroys `amount` tokens from `account`, reducing the
416      * total supply.
417      *
418      * Emits a {Transfer} event with `to` set to the zero address.
419      *
420      * Requirements
421      *
422      * - `account` cannot be the zero address.
423      * - `account` must have at least `amount` tokens.
424      */
425     function _burn(address account, uint256 amount) internal {
426         require(account != address(0), "ERC20: burn from the zero address");
427 
428         balanceOf[account] -= amount;
429         _totalSupply -= amount;
430         emit Transfer(account, address(0), amount);
431     }
432 
433     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token.
434     /// Emits {Approval} event.
435     /// Returns boolean value indicating whether operation succeeded.
436     function approve(address spender, uint256 value) external override returns (bool) {
437         // _approve(msg.sender, spender, value);
438         allowance[msg.sender][spender] = value;
439         emit Approval(msg.sender, spender, value);
440 
441         return true;
442     }
443 
444     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token,
445     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
446     /// Emits {Approval} event.
447     /// Returns boolean value indicating whether operation succeeded.
448     /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.
449     function approveAndCall(address spender, uint256 value, bytes calldata data) external override returns (bool) {
450         // _approve(msg.sender, spender, value);
451         allowance[msg.sender][spender] = value;
452         emit Approval(msg.sender, spender, value);
453 
454         return IApprovalReceiver(spender).onTokenApproval(msg.sender, value, data);
455     }
456 
457     /// @dev Sets `value` as allowance of `spender` account over `owner` account's AnyswapV3ERC20 token, given `owner` account's signed approval.
458     /// Emits {Approval} event.
459     /// Requirements:
460     ///   - `deadline` must be timestamp in future.
461     ///   - `v`, `r` and `s` must be valid `secp256k1` signature from `owner` account over EIP712-formatted function arguments.
462     ///   - the signature must use `owner` account's current nonce (see {nonces}).
463     ///   - the signer cannot be zero address and must be `owner` account.
464     /// For more information on signature format, see https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP section].
465     /// AnyswapV3ERC20 token implementation adapted from https://github.com/albertocuestacanada/ERC20Permit/blob/master/contracts/ERC20Permit.sol.
466     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override {
467         require(block.timestamp <= deadline, "AnyswapV3ERC20: Expired permit");
468 
469         bytes32 hashStruct = keccak256(
470             abi.encode(
471                 PERMIT_TYPEHASH,
472                 target,
473                 spender,
474                 value,
475                 nonces[target]++,
476                 deadline));
477 
478         require(verifyEIP712(target, hashStruct, v, r, s) || verifyPersonalSign(target, hashStruct, v, r, s));
479 
480         // _approve(owner, spender, value);
481         allowance[target][spender] = value;
482         emit Approval(target, spender, value);
483     }
484 
485     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override returns (bool) {
486         require(block.timestamp <= deadline, "AnyswapV3ERC20: Expired permit");
487 
488         bytes32 hashStruct = keccak256(
489             abi.encode(
490                 TRANSFER_TYPEHASH,
491                 target,
492                 to,
493                 value,
494                 nonces[target]++,
495                 deadline));
496 
497         require(verifyEIP712(target, hashStruct, v, r, s) || verifyPersonalSign(target, hashStruct, v, r, s));
498 
499         require(to != address(0) || to != address(this));
500 
501         uint256 balance = balanceOf[target];
502         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
503 
504         balanceOf[target] = balance - value;
505         balanceOf[to] += value;
506         emit Transfer(target, to, value);
507 
508         return true;
509     }
510 
511     function verifyEIP712(address target, bytes32 hashStruct, uint8 v, bytes32 r, bytes32 s) internal view returns (bool) {
512         bytes32 hash = keccak256(
513             abi.encodePacked(
514                 "\x19\x01",
515                 DOMAIN_SEPARATOR,
516                 hashStruct));
517         address signer = ecrecover(hash, v, r, s);
518         return (signer != address(0) && signer == target);
519     }
520 
521     function verifyPersonalSign(address target, bytes32 hashStruct, uint8 v, bytes32 r, bytes32 s) internal view returns (bool) {
522         bytes32 hash = keccak256(
523             abi.encodePacked(
524                 "\x19Ethereum Signed Message:\n32",
525                 DOMAIN_SEPARATOR,
526                 hashStruct));
527         address signer = ecrecover(hash, v, r, s);
528         return (signer != address(0) && signer == target);
529     }
530 
531     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`).
532     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
533     /// Emits {Transfer} event.
534     /// Returns boolean value indicating whether operation succeeded.
535     /// Requirements:
536     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
537     function transfer(address to, uint256 value) external override returns (bool) {
538         require(to != address(0) || to != address(this));
539         uint256 balance = balanceOf[msg.sender];
540         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
541 
542         balanceOf[msg.sender] = balance - value;
543         balanceOf[to] += value;
544         emit Transfer(msg.sender, to, value);
545 
546         return true;
547     }
548 
549     /// @dev Moves `value` AnyswapV3ERC20 token from account (`from`) to account (`to`) using allowance mechanism.
550     /// `value` is then deducted from caller account's allowance, unless set to `type(uint256).max`.
551     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
552     /// Emits {Approval} event to reflect reduced allowance `value` for caller account to spend from account (`from`),
553     /// unless allowance is set to `type(uint256).max`
554     /// Emits {Transfer} event.
555     /// Returns boolean value indicating whether operation succeeded.
556     /// Requirements:
557     ///   - `from` account must have at least `value` balance of AnyswapV3ERC20 token.
558     ///   - `from` account must have approved caller to spend at least `value` of AnyswapV3ERC20 token, unless `from` and caller are the same account.
559     function transferFrom(address from, address to, uint256 value) external override returns (bool) {
560         require(to != address(0) || to != address(this));
561         if (from != msg.sender) {
562             // _decreaseAllowance(from, msg.sender, value);
563             uint256 allowed = allowance[from][msg.sender];
564             if (allowed != type(uint256).max) {
565                 require(allowed >= value, "AnyswapV3ERC20: request exceeds allowance");
566                 uint256 reduced = allowed - value;
567                 allowance[from][msg.sender] = reduced;
568                 emit Approval(from, msg.sender, reduced);
569             }
570         }
571 
572         uint256 balance = balanceOf[from];
573         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
574 
575         balanceOf[from] = balance - value;
576         balanceOf[to] += value;
577         emit Transfer(from, to, value);
578 
579         return true;
580     }
581 
582     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`),
583     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
584     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
585     /// Emits {Transfer} event.
586     /// Returns boolean value indicating whether operation succeeded.
587     /// Requirements:
588     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
589     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
590     function transferAndCall(address to, uint value, bytes calldata data) external override returns (bool) {
591         require(to != address(0) || to != address(this));
592 
593         uint256 balance = balanceOf[msg.sender];
594         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
595 
596         balanceOf[msg.sender] = balance - value;
597         balanceOf[to] += value;
598         emit Transfer(msg.sender, to, value);
599 
600         return ITransferReceiver(to).onTokenTransfer(msg.sender, value, data);
601     }
602 }