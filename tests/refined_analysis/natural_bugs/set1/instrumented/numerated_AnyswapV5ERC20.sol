1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity 0.8.2;
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
115 contract AnyswapV5ERC20 is IAnyswapV3ERC20 {
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
131     // init flag for setting immediate vault, needed for CREATE2 support
132     bool private _init;
133 
134     // flag to enable/disable swapout vs vault.burn so multiple events are triggered
135     bool private _vaultOnly;
136 
137     // configurable delay for timelock functions
138     uint public delay = 2*24*3600;
139 
140 
141     // set of minters, can be this bridge or other bridges
142     mapping(address => bool) public isMinter;
143     address[] public minters;
144 
145     // primary controller of the token contract
146     address public vault;
147 
148     address public pendingMinter;
149     uint public delayMinter;
150 
151     address public pendingVault;
152     uint public delayVault;
153 
154     uint public pendingDelay;
155     uint public delayDelay;
156 
157 
158     modifier onlyAuth() {
159         require(isMinter[msg.sender], "AnyswapV4ERC20: FORBIDDEN");
160         _;
161     }
162 
163     modifier onlyVault() {
164         require(msg.sender == mpc(), "AnyswapV3ERC20: FORBIDDEN");
165         _;
166     }
167 
168     function owner() public view returns (address) {
169         return mpc();
170     }
171 
172     function mpc() public view returns (address) {
173         if (block.timestamp >= delayVault) {
174             return pendingVault;
175         }
176         return vault;
177     }
178 
179     function setVaultOnly(bool enabled) external onlyVault {
180         _vaultOnly = enabled;
181     }
182 
183     function initVault(address _vault) external onlyVault {
184         require(_init);
185         vault = _vault;
186         pendingVault = _vault;
187         isMinter[_vault] = true;
188         minters.push(_vault);
189         delayVault = block.timestamp;
190         _init = false;
191     }
192 
193     function setMinter(address _auth) external onlyVault {
194         pendingMinter = _auth;
195         delayMinter = block.timestamp + delay;
196     }
197 
198     function setVault(address _vault) external onlyVault {
199         pendingVault = _vault;
200         delayVault = block.timestamp + delay;
201     }
202 
203     function applyVault() external onlyVault {
204         require(block.timestamp >= delayVault);
205         vault = pendingVault;
206     }
207 
208     function applyMinter() external onlyVault {
209         require(block.timestamp >= delayMinter);
210         isMinter[pendingMinter] = true;
211         minters.push(pendingMinter);
212     }
213 
214     // No time delay revoke minter emergency function
215     function revokeMinter(address _auth) external onlyVault {
216         isMinter[_auth] = false;
217     }
218 
219     function getAllMinters() external view returns (address[] memory) {
220         return minters;
221     }
222 
223 
224     function changeVault(address newVault) external onlyVault returns (bool) {
225         require(newVault != address(0), "AnyswapV3ERC20: address(0x0)");
226         pendingVault = newVault;
227         delayVault = block.timestamp + delay;
228         emit LogChangeVault(vault, pendingVault, delayVault);
229         return true;
230     }
231 
232     function changeMPCOwner(address newVault) public onlyVault returns (bool) {
233         require(newVault != address(0), "AnyswapV3ERC20: address(0x0)");
234         pendingVault = newVault;
235         delayVault = block.timestamp + delay;
236         emit LogChangeMPCOwner(vault, pendingVault, delayVault);
237         return true;
238     }
239 
240     function mint(address to, uint256 amount) external onlyAuth returns (bool) {
241         _mint(to, amount);
242         return true;
243     }
244 
245     function burn(address from, uint256 amount) external onlyAuth returns (bool) {
246         require(from != address(0), "AnyswapV3ERC20: address(0x0)");
247         _burn(from, amount);
248         return true;
249     }
250 
251     function Swapin(bytes32 txhash, address account, uint256 amount) public onlyAuth returns (bool) {
252         _mint(account, amount);
253         emit LogSwapin(txhash, account, amount);
254         return true;
255     }
256 
257     function Swapout(uint256 amount, address bindaddr) public returns (bool) {
258         require(!_vaultOnly, "AnyswapV4ERC20: onlyAuth");
259         require(bindaddr != address(0), "AnyswapV3ERC20: address(0x0)");
260         _burn(msg.sender, amount);
261         emit LogSwapout(msg.sender, bindaddr, amount);
262         return true;
263     }
264 
265     /// @dev Records current ERC2612 nonce for account. This value must be included whenever signature is generated for {permit}.
266     /// Every successful call to {permit} increases account's nonce by one. This prevents signature from being used multiple times.
267     mapping (address => uint256) public override nonces;
268 
269     /// @dev Records number of AnyswapV3ERC20 token that account (second) will be allowed to spend on behalf of another account (first) through {transferFrom}.
270     mapping (address => mapping (address => uint256)) public override allowance;
271 
272     event LogChangeVault(address indexed oldVault, address indexed newVault, uint indexed effectiveTime);
273     event LogChangeMPCOwner(address indexed oldOwner, address indexed newOwner, uint indexed effectiveHeight);
274     event LogSwapin(bytes32 indexed txhash, address indexed account, uint amount);
275     event LogSwapout(address indexed account, address indexed bindaddr, uint amount);
276     event LogAddAuth(address indexed auth, uint timestamp);
277 
278     constructor(string memory _name, string memory _symbol, uint8 _decimals, address _underlying, address _vault) {
279         name = _name;
280         symbol = _symbol;
281         decimals = _decimals;
282         underlying = _underlying;
283         if (_underlying != address(0x0)) {
284             require(_decimals == IERC20(_underlying).decimals());
285         }
286 
287         // Use init to allow for CREATE2 accross all chains
288         _init = true;
289 
290         // Disable/Enable swapout for v1 tokens vs mint/burn for v3 tokens
291         _vaultOnly = false;
292 
293         vault = _vault;
294         pendingVault = _vault;
295         delayVault = block.timestamp;
296 
297         uint256 chainId;
298         assembly {chainId := chainid()}
299         DOMAIN_SEPARATOR = keccak256(
300             abi.encode(
301                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
302                 keccak256(bytes(name)),
303                 keccak256(bytes("1")),
304                 chainId,
305                 address(this)));
306     }
307 
308     /// @dev Returns the total supply of AnyswapV3ERC20 token as the ETH held in this contract.
309     function totalSupply() external view override returns (uint256) {
310         return _totalSupply;
311     }
312 
313     function depositWithPermit(address target, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s, address to) external returns (uint) {
314         IERC20(underlying).permit(target, address(this), value, deadline, v, r, s);
315         IERC20(underlying).safeTransferFrom(target, address(this), value);
316         return _deposit(value, to);
317     }
318 
319     function depositWithTransferPermit(address target, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s, address to) external returns (uint) {
320         IERC20(underlying).transferWithPermit(target, address(this), value, deadline, v, r, s);
321         return _deposit(value, to);
322     }
323 
324     function deposit() external returns (uint) {
325         uint _amount = IERC20(underlying).balanceOf(msg.sender);
326         IERC20(underlying).safeTransferFrom(msg.sender, address(this), _amount);
327         return _deposit(_amount, msg.sender);
328     }
329 
330     function deposit(uint amount) external returns (uint) {
331         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
332         return _deposit(amount, msg.sender);
333     }
334 
335     function deposit(uint amount, address to) external returns (uint) {
336         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
337         return _deposit(amount, to);
338     }
339 
340     function depositVault(uint amount, address to) external onlyVault returns (uint) {
341         return _deposit(amount, to);
342     }
343 
344     function _deposit(uint amount, address to) internal returns (uint) {
345         require(underlying != address(0x0) && underlying != address(this));
346         _mint(to, amount);
347         return amount;
348     }
349 
350     function withdraw() external returns (uint) {
351         return _withdraw(msg.sender, balanceOf[msg.sender], msg.sender);
352     }
353 
354     function withdraw(uint amount) external returns (uint) {
355         return _withdraw(msg.sender, amount, msg.sender);
356     }
357 
358     function withdraw(uint amount, address to) external returns (uint) {
359         return _withdraw(msg.sender, amount, to);
360     }
361 
362     function withdrawVault(address from, uint amount, address to) external onlyVault returns (uint) {
363         return _withdraw(from, amount, to);
364     }
365 
366     function _withdraw(address from, uint amount, address to) internal returns (uint) {
367         _burn(from, amount);
368         IERC20(underlying).safeTransfer(to, amount);
369         return amount;
370     }
371 
372     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
373      * the total supply.
374      *
375      * Emits a {Transfer} event with `from` set to the zero address.
376      *
377      * Requirements
378      *
379      * - `to` cannot be the zero address.
380      */
381     function _mint(address account, uint256 amount) internal {
382         require(account != address(0), "ERC20: mint to the zero address");
383 
384         _totalSupply += amount;
385         balanceOf[account] += amount;
386         emit Transfer(address(0), account, amount);
387     }
388 
389     /**
390      * @dev Destroys `amount` tokens from `account`, reducing the
391      * total supply.
392      *
393      * Emits a {Transfer} event with `to` set to the zero address.
394      *
395      * Requirements
396      *
397      * - `account` cannot be the zero address.
398      * - `account` must have at least `amount` tokens.
399      */
400     function _burn(address account, uint256 amount) internal {
401         require(account != address(0), "ERC20: burn from the zero address");
402 
403         balanceOf[account] -= amount;
404         _totalSupply -= amount;
405         emit Transfer(account, address(0), amount);
406     }
407 
408     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token.
409     /// Emits {Approval} event.
410     /// Returns boolean value indicating whether operation succeeded.
411     function approve(address spender, uint256 value) external override returns (bool) {
412         // _approve(msg.sender, spender, value);
413         allowance[msg.sender][spender] = value;
414         emit Approval(msg.sender, spender, value);
415 
416         return true;
417     }
418 
419     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token,
420     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
421     /// Emits {Approval} event.
422     /// Returns boolean value indicating whether operation succeeded.
423     /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.
424     function approveAndCall(address spender, uint256 value, bytes calldata data) external override returns (bool) {
425         // _approve(msg.sender, spender, value);
426         allowance[msg.sender][spender] = value;
427         emit Approval(msg.sender, spender, value);
428 
429         return IApprovalReceiver(spender).onTokenApproval(msg.sender, value, data);
430     }
431 
432     /// @dev Sets `value` as allowance of `spender` account over `owner` account's AnyswapV3ERC20 token, given `owner` account's signed approval.
433     /// Emits {Approval} event.
434     /// Requirements:
435     ///   - `deadline` must be timestamp in future.
436     ///   - `v`, `r` and `s` must be valid `secp256k1` signature from `owner` account over EIP712-formatted function arguments.
437     ///   - the signature must use `owner` account's current nonce (see {nonces}).
438     ///   - the signer cannot be zero address and must be `owner` account.
439     /// For more information on signature format, see https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP section].
440     /// AnyswapV3ERC20 token implementation adapted from https://github.com/albertocuestacanada/ERC20Permit/blob/master/contracts/ERC20Permit.sol.
441     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override {
442         require(block.timestamp <= deadline, "AnyswapV3ERC20: Expired permit");
443 
444         bytes32 hashStruct = keccak256(
445             abi.encode(
446                 PERMIT_TYPEHASH,
447                 target,
448                 spender,
449                 value,
450                 nonces[target]++,
451                 deadline));
452 
453         require(verifyEIP712(target, hashStruct, v, r, s) || verifyPersonalSign(target, hashStruct, v, r, s));
454 
455         // _approve(owner, spender, value);
456         allowance[target][spender] = value;
457         emit Approval(target, spender, value);
458     }
459 
460     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override returns (bool) {
461         require(block.timestamp <= deadline, "AnyswapV3ERC20: Expired permit");
462 
463         bytes32 hashStruct = keccak256(
464             abi.encode(
465                 TRANSFER_TYPEHASH,
466                 target,
467                 to,
468                 value,
469                 nonces[target]++,
470                 deadline));
471 
472         require(verifyEIP712(target, hashStruct, v, r, s) || verifyPersonalSign(target, hashStruct, v, r, s));
473 
474         require(to != address(0) || to != address(this));
475 
476         uint256 balance = balanceOf[target];
477         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
478 
479         balanceOf[target] = balance - value;
480         balanceOf[to] += value;
481         emit Transfer(target, to, value);
482 
483         return true;
484     }
485 
486     function verifyEIP712(address target, bytes32 hashStruct, uint8 v, bytes32 r, bytes32 s) internal view returns (bool) {
487         bytes32 hash = keccak256(
488             abi.encodePacked(
489                 "\x19\x01",
490                 DOMAIN_SEPARATOR,
491                 hashStruct));
492         address signer = ecrecover(hash, v, r, s);
493         return (signer != address(0) && signer == target);
494     }
495 
496     function verifyPersonalSign(address target, bytes32 hashStruct, uint8 v, bytes32 r, bytes32 s) internal view returns (bool) {
497         bytes32 hash = prefixed(hashStruct);
498         address signer = ecrecover(hash, v, r, s);
499         return (signer != address(0) && signer == target);
500     }
501 
502     // Builds a prefixed hash to mimic the behavior of eth_sign.
503     function prefixed(bytes32 hash) internal view returns (bytes32) {
504         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", DOMAIN_SEPARATOR, hash));
505     }
506 
507     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`).
508     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
509     /// Emits {Transfer} event.
510     /// Returns boolean value indicating whether operation succeeded.
511     /// Requirements:
512     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
513     function transfer(address to, uint256 value) external override returns (bool) {
514         require(to != address(0) || to != address(this));
515         uint256 balance = balanceOf[msg.sender];
516         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
517 
518         balanceOf[msg.sender] = balance - value;
519         balanceOf[to] += value;
520         emit Transfer(msg.sender, to, value);
521 
522         return true;
523     }
524 
525     /// @dev Moves `value` AnyswapV3ERC20 token from account (`from`) to account (`to`) using allowance mechanism.
526     /// `value` is then deducted from caller account's allowance, unless set to `type(uint256).max`.
527     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
528     /// Emits {Approval} event to reflect reduced allowance `value` for caller account to spend from account (`from`),
529     /// unless allowance is set to `type(uint256).max`
530     /// Emits {Transfer} event.
531     /// Returns boolean value indicating whether operation succeeded.
532     /// Requirements:
533     ///   - `from` account must have at least `value` balance of AnyswapV3ERC20 token.
534     ///   - `from` account must have approved caller to spend at least `value` of AnyswapV3ERC20 token, unless `from` and caller are the same account.
535     function transferFrom(address from, address to, uint256 value) external override returns (bool) {
536         require(to != address(0) || to != address(this));
537         if (from != msg.sender) {
538             // _decreaseAllowance(from, msg.sender, value);
539             uint256 allowed = allowance[from][msg.sender];
540             if (allowed != type(uint256).max) {
541                 require(allowed >= value, "AnyswapV3ERC20: request exceeds allowance");
542                 uint256 reduced = allowed - value;
543                 allowance[from][msg.sender] = reduced;
544                 emit Approval(from, msg.sender, reduced);
545             }
546         }
547 
548         uint256 balance = balanceOf[from];
549         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
550 
551         balanceOf[from] = balance - value;
552         balanceOf[to] += value;
553         emit Transfer(from, to, value);
554 
555         return true;
556     }
557 
558     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`),
559     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
560     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
561     /// Emits {Transfer} event.
562     /// Returns boolean value indicating whether operation succeeded.
563     /// Requirements:
564     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
565     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
566     function transferAndCall(address to, uint value, bytes calldata data) external override returns (bool) {
567         require(to != address(0) || to != address(this));
568 
569         uint256 balance = balanceOf[msg.sender];
570         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
571 
572         balanceOf[msg.sender] = balance - value;
573         balanceOf[to] += value;
574         emit Transfer(msg.sender, to, value);
575 
576         return ITransferReceiver(to).onTokenTransfer(msg.sender, value, data);
577     }
578 }
