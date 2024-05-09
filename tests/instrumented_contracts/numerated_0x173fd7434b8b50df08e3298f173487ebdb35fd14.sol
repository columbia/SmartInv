1 /**
2  *Submitted for verification at BscScan.com on 2021-06-15
3 */
4 
5 /**
6  *Submitted for verification at BscScan.com on 2021-06-11
7 */
8 
9 /**
10  *Submitted for verification at polygonscan.com on 2021-06-11
11 */
12 
13 /**
14  *Submitted for verification at Etherscan.io on 2021-06-08
15 */
16 
17 /**
18  *Submitted for verification at Etherscan.io on 2021-06-07
19 */
20 
21 // SPDX-License-Identifier: GPL-3.0-or-later
22 
23 pragma solidity 0.8.2;
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     function totalSupply() external view returns (uint256);
30     function decimals() external view returns (uint8);
31     function balanceOf(address account) external view returns (uint256);
32     function transfer(address recipient, uint256 amount) external returns (bool);
33     function allowance(address owner, address spender) external view returns (uint256);
34     function approve(address spender, uint256 amount) external returns (bool);
35     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
36     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
37     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external returns (bool);
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 }
41 
42 /**
43  * @dev Interface of the ERC2612 standard as defined in the EIP.
44  *
45  * Adds the {permit} method, which can be used to change one's
46  * {IERC20-allowance} without having to send a transaction, by signing a
47  * message. This allows users to spend tokens without having to hold Ether.
48  *
49  * See https://eips.ethereum.org/EIPS/eip-2612.
50  */
51 interface IERC2612 {
52 
53     /**
54      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
55      * included whenever a signature is generated for {permit}.
56      *
57      * Every successful call to {permit} increases ``owner``'s nonce by one. This
58      * prevents a signature from being used multiple times.
59      */
60     function nonces(address owner) external view returns (uint256);
61 }
62 
63 /// @dev Wrapped ERC-20 v10 (AnyswapV3ERC20) is an ERC-20 ERC-20 wrapper. You can `deposit` ERC-20 and obtain an AnyswapV3ERC20 balance which can then be operated as an ERC-20 token. You can
64 /// `withdraw` ERC-20 from AnyswapV3ERC20, which will then burn AnyswapV3ERC20 token in your wallet. The amount of AnyswapV3ERC20 token in any wallet is always identical to the
65 /// balance of ERC-20 deposited minus the ERC-20 withdrawn with that specific wallet.
66 interface IAnyswapV3ERC20 is IERC20, IERC2612 {
67 
68     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token,
69     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
70     /// Emits {Approval} event.
71     /// Returns boolean value indicating whether operation succeeded.
72     /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.
73     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
74 
75     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`),
76     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
77     /// A transfer to `address(0)` triggers an ERC-20 withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
78     /// Emits {Transfer} event.
79     /// Returns boolean value indicating whether operation succeeded.
80     /// Requirements:
81     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
82     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
83     function transferAndCall(address to, uint value, bytes calldata data) external returns (bool);
84 }
85 
86 interface ITransferReceiver {
87     function onTokenTransfer(address, uint, bytes calldata) external returns (bool);
88 }
89 
90 interface IApprovalReceiver {
91     function onTokenApproval(address, uint, bytes calldata) external returns (bool);
92 }
93 
94 library Address {
95     function isContract(address account) internal view returns (bool) {
96         bytes32 codehash;
97         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
98         // solhint-disable-next-line no-inline-assembly
99         assembly { codehash := extcodehash(account) }
100         return (codehash != 0x0 && codehash != accountHash);
101     }
102 }
103 
104 library SafeERC20 {
105     using Address for address;
106 
107     function safeTransfer(IERC20 token, address to, uint value) internal {
108         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
109     }
110 
111     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
112         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
113     }
114 
115     function safeApprove(IERC20 token, address spender, uint value) internal {
116         require((value == 0) || (token.allowance(address(this), spender) == 0),
117             "SafeERC20: approve from non-zero to non-zero allowance"
118         );
119         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
120     }
121     function callOptionalReturn(IERC20 token, bytes memory data) private {
122         require(address(token).isContract(), "SafeERC20: call to non-contract");
123 
124         // solhint-disable-next-line avoid-low-level-calls
125         (bool success, bytes memory returndata) = address(token).call(data);
126         require(success, "SafeERC20: low-level call failed");
127 
128         if (returndata.length > 0) { // Return data is optional
129             // solhint-disable-next-line max-line-length
130             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
131         }
132     }
133 }
134 
135 contract AnyswapV5ERC20 is IAnyswapV3ERC20 {
136     using SafeERC20 for IERC20;
137     string public name;
138     string public symbol;
139     uint8  public immutable override decimals;
140 
141     address public immutable underlying;
142 
143     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
144     bytes32 public constant TRANSFER_TYPEHASH = keccak256("Transfer(address owner,address to,uint256 value,uint256 nonce,uint256 deadline)");
145     bytes32 public immutable DOMAIN_SEPARATOR;
146 
147     /// @dev Records amount of AnyswapV3ERC20 token owned by account.
148     mapping (address => uint256) public override balanceOf;
149     uint256 private _totalSupply;
150 
151     // init flag for setting immediate vault, needed for CREATE2 support
152     bool private _init;
153 
154     // flag to enable/disable swapout vs vault.burn so multiple events are triggered
155     bool private _vaultOnly;
156 
157     // configurable delay for timelock functions
158     uint public delay = 2*24*3600;
159 
160 
161     // set of minters, can be this bridge or other bridges
162     mapping(address => bool) public isMinter;
163     address[] public minters;
164 
165     // primary controller of the token contract
166     address public vault;
167 
168     address public pendingMinter;
169     uint public delayMinter;
170 
171     address public pendingVault;
172     uint public delayVault;
173 
174     uint public pendingDelay;
175     uint public delayDelay;
176 
177 
178     modifier onlyAuth() {
179         require(isMinter[msg.sender], "AnyswapV4ERC20: FORBIDDEN");
180         _;
181     }
182 
183     modifier onlyVault() {
184         require(msg.sender == mpc(), "AnyswapV3ERC20: FORBIDDEN");
185         _;
186     }
187 
188     function owner() public view returns (address) {
189         return mpc();
190     }
191 
192     function mpc() public view returns (address) {
193         if (block.timestamp >= delayVault) {
194             return pendingVault;
195         }
196         return vault;
197     }
198 
199     function setVaultOnly(bool enabled) external onlyVault {
200         _vaultOnly = enabled;
201     }
202 
203     function initVault(address _vault) external onlyVault {
204         require(_init);
205         vault = _vault;
206         pendingVault = _vault;
207         isMinter[_vault] = true;
208         minters.push(_vault);
209         delayVault = block.timestamp;
210         _init = false;
211     }
212 
213     function setMinter(address _auth) external onlyVault {
214         pendingMinter = _auth;
215         delayMinter = block.timestamp + delay;
216     }
217 
218     function setVault(address _vault) external onlyVault {
219         pendingVault = _vault;
220         delayVault = block.timestamp + delay;
221     }
222 
223     function applyVault() external onlyVault {
224         require(block.timestamp >= delayVault);
225         vault = pendingVault;
226     }
227 
228     function applyMinter() external onlyVault {
229         require(block.timestamp >= delayMinter);
230         isMinter[pendingMinter] = true;
231         minters.push(pendingMinter);
232     }
233 
234     // No time delay revoke minter emergency function
235     function revokeMinter(address _auth) external onlyVault {
236         isMinter[_auth] = false;
237     }
238 
239     function getAllMinters() external view returns (address[] memory) {
240         return minters;
241     }
242 
243 
244     function changeVault(address newVault) external onlyVault returns (bool) {
245         require(newVault != address(0), "AnyswapV3ERC20: address(0x0)");
246         pendingVault = newVault;
247         delayVault = block.timestamp + delay;
248         emit LogChangeVault(vault, pendingVault, delayVault);
249         return true;
250     }
251 
252     function changeMPCOwner(address newVault) public onlyVault returns (bool) {
253         require(newVault != address(0), "AnyswapV3ERC20: address(0x0)");
254         pendingVault = newVault;
255         delayVault = block.timestamp + delay;
256         emit LogChangeMPCOwner(vault, pendingVault, delayVault);
257         return true;
258     }
259 
260     function mint(address to, uint256 amount) external onlyAuth returns (bool) {
261         _mint(to, amount);
262         return true;
263     }
264 
265     function burn(address from, uint256 amount) external onlyAuth returns (bool) {
266         require(from != address(0), "AnyswapV3ERC20: address(0x0)");
267         _burn(from, amount);
268         return true;
269     }
270 
271     function Swapin(bytes32 txhash, address account, uint256 amount) public onlyAuth returns (bool) {
272         _mint(account, amount);
273         emit LogSwapin(txhash, account, amount);
274         return true;
275     }
276 
277     function Swapout(uint256 amount, address bindaddr) public returns (bool) {
278         require(!_vaultOnly, "AnyswapV4ERC20: onlyAuth");
279         require(bindaddr != address(0), "AnyswapV3ERC20: address(0x0)");
280         _burn(msg.sender, amount);
281         emit LogSwapout(msg.sender, bindaddr, amount);
282         return true;
283     }
284 
285     /// @dev Records current ERC2612 nonce for account. This value must be included whenever signature is generated for {permit}.
286     /// Every successful call to {permit} increases account's nonce by one. This prevents signature from being used multiple times.
287     mapping (address => uint256) public override nonces;
288 
289     /// @dev Records number of AnyswapV3ERC20 token that account (second) will be allowed to spend on behalf of another account (first) through {transferFrom}.
290     mapping (address => mapping (address => uint256)) public override allowance;
291 
292     event LogChangeVault(address indexed oldVault, address indexed newVault, uint indexed effectiveTime);
293     event LogChangeMPCOwner(address indexed oldOwner, address indexed newOwner, uint indexed effectiveHeight);
294     event LogSwapin(bytes32 indexed txhash, address indexed account, uint amount);
295     event LogSwapout(address indexed account, address indexed bindaddr, uint amount);
296     event LogAddAuth(address indexed auth, uint timestamp);
297 
298     constructor(string memory _name, string memory _symbol, uint8 _decimals, address _underlying, address _vault) {
299         name = _name;
300         symbol = _symbol;
301         decimals = _decimals;
302         underlying = _underlying;
303         if (_underlying != address(0x0)) {
304             require(_decimals == IERC20(_underlying).decimals());
305         }
306 
307         // Use init to allow for CREATE2 accross all chains
308         _init = true;
309 
310         // Disable/Enable swapout for v1 tokens vs mint/burn for v3 tokens
311         _vaultOnly = false;
312 
313         vault = _vault;
314         pendingVault = _vault;
315         delayVault = block.timestamp;
316 
317         uint256 chainId;
318         assembly {chainId := chainid()}
319         DOMAIN_SEPARATOR = keccak256(
320             abi.encode(
321                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
322                 keccak256(bytes(name)),
323                 keccak256(bytes("1")),
324                 chainId,
325                 address(this)));
326     }
327 
328     /// @dev Returns the total supply of AnyswapV3ERC20 token as the ETH held in this contract.
329     function totalSupply() external view override returns (uint256) {
330         return _totalSupply;
331     }
332 
333     function depositWithPermit(address target, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s, address to) external returns (uint) {
334         IERC20(underlying).permit(target, address(this), value, deadline, v, r, s);
335         IERC20(underlying).safeTransferFrom(target, address(this), value);
336         return _deposit(value, to);
337     }
338 
339     function depositWithTransferPermit(address target, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s, address to) external returns (uint) {
340         IERC20(underlying).transferWithPermit(target, address(this), value, deadline, v, r, s);
341         return _deposit(value, to);
342     }
343 
344     function deposit() external returns (uint) {
345         uint _amount = IERC20(underlying).balanceOf(msg.sender);
346         IERC20(underlying).safeTransferFrom(msg.sender, address(this), _amount);
347         return _deposit(_amount, msg.sender);
348     }
349 
350     function deposit(uint amount) external returns (uint) {
351         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
352         return _deposit(amount, msg.sender);
353     }
354 
355     function deposit(uint amount, address to) external returns (uint) {
356         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
357         return _deposit(amount, to);
358     }
359 
360     function depositVault(uint amount, address to) external onlyVault returns (uint) {
361         return _deposit(amount, to);
362     }
363 
364     function _deposit(uint amount, address to) internal returns (uint) {
365         require(underlying != address(0x0) && underlying != address(this));
366         _mint(to, amount);
367         return amount;
368     }
369 
370     function withdraw() external returns (uint) {
371         return _withdraw(msg.sender, balanceOf[msg.sender], msg.sender);
372     }
373 
374     function withdraw(uint amount) external returns (uint) {
375         return _withdraw(msg.sender, amount, msg.sender);
376     }
377 
378     function withdraw(uint amount, address to) external returns (uint) {
379         return _withdraw(msg.sender, amount, to);
380     }
381 
382     function withdrawVault(address from, uint amount, address to) external onlyVault returns (uint) {
383         return _withdraw(from, amount, to);
384     }
385 
386     function _withdraw(address from, uint amount, address to) internal returns (uint) {
387         _burn(from, amount);
388         IERC20(underlying).safeTransfer(to, amount);
389         return amount;
390     }
391 
392     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
393      * the total supply.
394      *
395      * Emits a {Transfer} event with `from` set to the zero address.
396      *
397      * Requirements
398      *
399      * - `to` cannot be the zero address.
400      */
401     function _mint(address account, uint256 amount) internal {
402         require(account != address(0), "ERC20: mint to the zero address");
403 
404         _totalSupply += amount;
405         balanceOf[account] += amount;
406         emit Transfer(address(0), account, amount);
407     }
408 
409     /**
410      * @dev Destroys `amount` tokens from `account`, reducing the
411      * total supply.
412      *
413      * Emits a {Transfer} event with `to` set to the zero address.
414      *
415      * Requirements
416      *
417      * - `account` cannot be the zero address.
418      * - `account` must have at least `amount` tokens.
419      */
420     function _burn(address account, uint256 amount) internal {
421         require(account != address(0), "ERC20: burn from the zero address");
422 
423         balanceOf[account] -= amount;
424         _totalSupply -= amount;
425         emit Transfer(account, address(0), amount);
426     }
427 
428     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token.
429     /// Emits {Approval} event.
430     /// Returns boolean value indicating whether operation succeeded.
431     function approve(address spender, uint256 value) external override returns (bool) {
432         // _approve(msg.sender, spender, value);
433         allowance[msg.sender][spender] = value;
434         emit Approval(msg.sender, spender, value);
435 
436         return true;
437     }
438 
439     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token,
440     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
441     /// Emits {Approval} event.
442     /// Returns boolean value indicating whether operation succeeded.
443     /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.
444     function approveAndCall(address spender, uint256 value, bytes calldata data) external override returns (bool) {
445         // _approve(msg.sender, spender, value);
446         allowance[msg.sender][spender] = value;
447         emit Approval(msg.sender, spender, value);
448 
449         return IApprovalReceiver(spender).onTokenApproval(msg.sender, value, data);
450     }
451 
452     /// @dev Sets `value` as allowance of `spender` account over `owner` account's AnyswapV3ERC20 token, given `owner` account's signed approval.
453     /// Emits {Approval} event.
454     /// Requirements:
455     ///   - `deadline` must be timestamp in future.
456     ///   - `v`, `r` and `s` must be valid `secp256k1` signature from `owner` account over EIP712-formatted function arguments.
457     ///   - the signature must use `owner` account's current nonce (see {nonces}).
458     ///   - the signer cannot be zero address and must be `owner` account.
459     /// For more information on signature format, see https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP section].
460     /// AnyswapV3ERC20 token implementation adapted from https://github.com/albertocuestacanada/ERC20Permit/blob/master/contracts/ERC20Permit.sol.
461     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override {
462         require(block.timestamp <= deadline, "AnyswapV3ERC20: Expired permit");
463 
464         bytes32 hashStruct = keccak256(
465             abi.encode(
466                 PERMIT_TYPEHASH,
467                 target,
468                 spender,
469                 value,
470                 nonces[target]++,
471                 deadline));
472 
473         require(verifyEIP712(target, hashStruct, v, r, s) || verifyPersonalSign(target, hashStruct, v, r, s));
474 
475         // _approve(owner, spender, value);
476         allowance[target][spender] = value;
477         emit Approval(target, spender, value);
478     }
479 
480     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override returns (bool) {
481         require(block.timestamp <= deadline, "AnyswapV3ERC20: Expired permit");
482 
483         bytes32 hashStruct = keccak256(
484             abi.encode(
485                 TRANSFER_TYPEHASH,
486                 target,
487                 to,
488                 value,
489                 nonces[target]++,
490                 deadline));
491 
492         require(verifyEIP712(target, hashStruct, v, r, s) || verifyPersonalSign(target, hashStruct, v, r, s));
493 
494         require(to != address(0) || to != address(this));
495 
496         uint256 balance = balanceOf[target];
497         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
498 
499         balanceOf[target] = balance - value;
500         balanceOf[to] += value;
501         emit Transfer(target, to, value);
502 
503         return true;
504     }
505 
506     function verifyEIP712(address target, bytes32 hashStruct, uint8 v, bytes32 r, bytes32 s) internal view returns (bool) {
507         bytes32 hash = keccak256(
508             abi.encodePacked(
509                 "\x19\x01",
510                 DOMAIN_SEPARATOR,
511                 hashStruct));
512         address signer = ecrecover(hash, v, r, s);
513         return (signer != address(0) && signer == target);
514     }
515 
516     function verifyPersonalSign(address target, bytes32 hashStruct, uint8 v, bytes32 r, bytes32 s) internal view returns (bool) {
517         bytes32 hash = prefixed(hashStruct);
518         address signer = ecrecover(hash, v, r, s);
519         return (signer != address(0) && signer == target);
520     }
521 
522     // Builds a prefixed hash to mimic the behavior of eth_sign.
523     function prefixed(bytes32 hash) internal view returns (bytes32) {
524         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", DOMAIN_SEPARATOR, hash));
525     }
526 
527     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`).
528     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
529     /// Emits {Transfer} event.
530     /// Returns boolean value indicating whether operation succeeded.
531     /// Requirements:
532     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
533     function transfer(address to, uint256 value) external override returns (bool) {
534         require(to != address(0) || to != address(this));
535         uint256 balance = balanceOf[msg.sender];
536         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
537 
538         balanceOf[msg.sender] = balance - value;
539         balanceOf[to] += value;
540         emit Transfer(msg.sender, to, value);
541 
542         return true;
543     }
544 
545     /// @dev Moves `value` AnyswapV3ERC20 token from account (`from`) to account (`to`) using allowance mechanism.
546     /// `value` is then deducted from caller account's allowance, unless set to `type(uint256).max`.
547     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
548     /// Emits {Approval} event to reflect reduced allowance `value` for caller account to spend from account (`from`),
549     /// unless allowance is set to `type(uint256).max`
550     /// Emits {Transfer} event.
551     /// Returns boolean value indicating whether operation succeeded.
552     /// Requirements:
553     ///   - `from` account must have at least `value` balance of AnyswapV3ERC20 token.
554     ///   - `from` account must have approved caller to spend at least `value` of AnyswapV3ERC20 token, unless `from` and caller are the same account.
555     function transferFrom(address from, address to, uint256 value) external override returns (bool) {
556         require(to != address(0) || to != address(this));
557         if (from != msg.sender) {
558             // _decreaseAllowance(from, msg.sender, value);
559             uint256 allowed = allowance[from][msg.sender];
560             if (allowed != type(uint256).max) {
561                 require(allowed >= value, "AnyswapV3ERC20: request exceeds allowance");
562                 uint256 reduced = allowed - value;
563                 allowance[from][msg.sender] = reduced;
564                 emit Approval(from, msg.sender, reduced);
565             }
566         }
567 
568         uint256 balance = balanceOf[from];
569         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
570 
571         balanceOf[from] = balance - value;
572         balanceOf[to] += value;
573         emit Transfer(from, to, value);
574 
575         return true;
576     }
577 
578     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`),
579     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
580     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
581     /// Emits {Transfer} event.
582     /// Returns boolean value indicating whether operation succeeded.
583     /// Requirements:
584     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
585     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
586     function transferAndCall(address to, uint value, bytes calldata data) external override returns (bool) {
587         require(to != address(0) || to != address(this));
588 
589         uint256 balance = balanceOf[msg.sender];
590         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
591 
592         balanceOf[msg.sender] = balance - value;
593         balanceOf[to] += value;
594         emit Transfer(msg.sender, to, value);
595 
596         return ITransferReceiver(to).onTokenTransfer(msg.sender, value, data);
597     }
598 }