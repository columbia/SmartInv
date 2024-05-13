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
115 contract AnyswapV3ERC20 is IAnyswapV3ERC20 {
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
148 
149     function changeVault(address newVault) external onlyVault returns (bool) {
150         require(newVault != address(0), "AnyswapV3ERC20: address(0x0)");
151         _oldVault = vault();
152         _newVault = newVault;
153         _newVaultEffectiveTime = block.timestamp + 2*24*3600;
154         emit LogChangeVault(_oldVault, _newVault, _newVaultEffectiveTime);
155         return true;
156     }
157 
158     function mint(address to, uint256 amount) external onlyVault returns (bool) {
159         _mint(to, amount);
160         return true;
161     }
162 
163     function burn(address from, uint256 amount) external onlyVault returns (bool) {
164         require(from != address(0), "AnyswapV3ERC20: address(0x0)");
165         _burn(from, amount);
166         return true;
167     }
168 
169     /// @dev Records current ERC2612 nonce for account. This value must be included whenever signature is generated for {permit}.
170     /// Every successful call to {permit} increases account's nonce by one. This prevents signature from being used multiple times.
171     mapping (address => uint256) public override nonces;
172 
173     /// @dev Records number of AnyswapV3ERC20 token that account (second) will be allowed to spend on behalf of another account (first) through {transferFrom}.
174     mapping (address => mapping (address => uint256)) public override allowance;
175 
176     event LogChangeVault(address indexed oldVault, address indexed newVault, uint indexed effectiveTime);
177 
178     constructor(string memory _name, string memory _symbol, uint8 _decimals, address _underlying, address _vault) {
179         name = _name;
180         symbol = _symbol;
181         decimals = _decimals;
182         underlying = _underlying;
183         if (_underlying != address(0x0)) {
184             require(_decimals == IERC20(_underlying).decimals());
185         }
186 
187         _newVault = _vault;
188         _newVaultEffectiveTime = block.timestamp;
189 
190         uint256 chainId;
191         assembly {chainId := chainid()}
192         DOMAIN_SEPARATOR = keccak256(
193             abi.encode(
194                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
195                 keccak256(bytes(name)),
196                 keccak256(bytes("1")),
197                 chainId,
198                 address(this)));
199     }
200 
201     /// @dev Returns the total supply of AnyswapV3ERC20 token as the ETH held in this contract.
202     function totalSupply() external view override returns (uint256) {
203         return _totalSupply;
204     }
205 
206     function depositWithPermit(address target, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s, address to) external returns (uint) {
207         IERC20(underlying).permit(target, address(this), value, deadline, v, r, s);
208         IERC20(underlying).safeTransferFrom(target, address(this), value);
209         return _deposit(value, to);
210     }
211 
212     function depositWithTransferPermit(address target, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s, address to) external returns (uint) {
213         IERC20(underlying).transferWithPermit(target, address(this), value, deadline, v, r, s);
214         return _deposit(value, to);
215     }
216 
217     function deposit() external returns (uint) {
218         uint _amount = IERC20(underlying).balanceOf(msg.sender);
219         IERC20(underlying).safeTransferFrom(msg.sender, address(this), _amount);
220         return _deposit(_amount, msg.sender);
221     }
222 
223     function deposit(uint amount) external returns (uint) {
224         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
225         return _deposit(amount, msg.sender);
226     }
227 
228     function deposit(uint amount, address to) external returns (uint) {
229         IERC20(underlying).safeTransferFrom(msg.sender, address(this), amount);
230         return _deposit(amount, to);
231     }
232 
233     function depositVault(uint amount, address to) external onlyVault returns (uint) {
234         return _deposit(amount, to);
235     }
236 
237     function _deposit(uint amount, address to) internal returns (uint) {
238         require(underlying != address(0x0) && underlying != address(this));
239         _mint(to, amount);
240         return amount;
241     }
242 
243     function withdraw() external returns (uint) {
244         return _withdraw(msg.sender, balanceOf[msg.sender], msg.sender);
245     }
246 
247     function withdraw(uint amount) external returns (uint) {
248         return _withdraw(msg.sender, amount, msg.sender);
249     }
250 
251     function withdraw(uint amount, address to) external returns (uint) {
252         return _withdraw(msg.sender, amount, to);
253     }
254 
255     function withdrawVault(address from, uint amount, address to) external onlyVault returns (uint) {
256         return _withdraw(from, amount, to);
257     }
258 
259     function _withdraw(address from, uint amount, address to) internal returns (uint) {
260         _burn(from, amount);
261         IERC20(underlying).safeTransfer(to, amount);
262         return amount;
263     }
264 
265     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
266      * the total supply.
267      *
268      * Emits a {Transfer} event with `from` set to the zero address.
269      *
270      * Requirements
271      *
272      * - `to` cannot be the zero address.
273      */
274     function _mint(address account, uint256 amount) internal {
275         require(account != address(0), "ERC20: mint to the zero address");
276 
277         _totalSupply += amount;
278         balanceOf[account] += amount;
279         emit Transfer(address(0), account, amount);
280     }
281 
282     /**
283      * @dev Destroys `amount` tokens from `account`, reducing the
284      * total supply.
285      *
286      * Emits a {Transfer} event with `to` set to the zero address.
287      *
288      * Requirements
289      *
290      * - `account` cannot be the zero address.
291      * - `account` must have at least `amount` tokens.
292      */
293     function _burn(address account, uint256 amount) internal {
294         require(account != address(0), "ERC20: burn from the zero address");
295 
296         balanceOf[account] -= amount;
297         _totalSupply -= amount;
298         emit Transfer(account, address(0), amount);
299     }
300 
301     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token.
302     /// Emits {Approval} event.
303     /// Returns boolean value indicating whether operation succeeded.
304     function approve(address spender, uint256 value) external override returns (bool) {
305         // _approve(msg.sender, spender, value);
306         allowance[msg.sender][spender] = value;
307         emit Approval(msg.sender, spender, value);
308 
309         return true;
310     }
311 
312     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token,
313     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
314     /// Emits {Approval} event.
315     /// Returns boolean value indicating whether operation succeeded.
316     /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.
317     function approveAndCall(address spender, uint256 value, bytes calldata data) external override returns (bool) {
318         // _approve(msg.sender, spender, value);
319         allowance[msg.sender][spender] = value;
320         emit Approval(msg.sender, spender, value);
321 
322         return IApprovalReceiver(spender).onTokenApproval(msg.sender, value, data);
323     }
324 
325     /// @dev Sets `value` as allowance of `spender` account over `owner` account's AnyswapV3ERC20 token, given `owner` account's signed approval.
326     /// Emits {Approval} event.
327     /// Requirements:
328     ///   - `deadline` must be timestamp in future.
329     ///   - `v`, `r` and `s` must be valid `secp256k1` signature from `owner` account over EIP712-formatted function arguments.
330     ///   - the signature must use `owner` account's current nonce (see {nonces}).
331     ///   - the signer cannot be zero address and must be `owner` account.
332     /// For more information on signature format, see https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP section].
333     /// AnyswapV3ERC20 token implementation adapted from https://github.com/albertocuestacanada/ERC20Permit/blob/master/contracts/ERC20Permit.sol.
334     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override {
335         require(block.timestamp <= deadline, "AnyswapV3ERC20: Expired permit");
336 
337         bytes32 hashStruct = keccak256(
338             abi.encode(
339                 PERMIT_TYPEHASH,
340                 target,
341                 spender,
342                 value,
343                 nonces[target]++,
344                 deadline));
345 
346         require(verifyEIP712(target, hashStruct, v, r, s) || verifyPersonalSign(target, hashStruct, v, r, s));
347 
348         // _approve(owner, spender, value);
349         allowance[target][spender] = value;
350         emit Approval(target, spender, value);
351     }
352 
353     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override returns (bool) {
354         require(block.timestamp <= deadline, "AnyswapV3ERC20: Expired permit");
355 
356         bytes32 hashStruct = keccak256(
357             abi.encode(
358                 TRANSFER_TYPEHASH,
359                 target,
360                 to,
361                 value,
362                 nonces[target]++,
363                 deadline));
364 
365         require(verifyEIP712(target, hashStruct, v, r, s) || verifyPersonalSign(target, hashStruct, v, r, s));
366 
367         require(to != address(0) || to != address(this));
368 
369         uint256 balance = balanceOf[target];
370         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
371 
372         balanceOf[target] = balance - value;
373         balanceOf[to] += value;
374         emit Transfer(target, to, value);
375 
376         return true;
377     }
378 
379     function verifyEIP712(address target, bytes32 hashStruct, uint8 v, bytes32 r, bytes32 s) internal view returns (bool) {
380         bytes32 hash = keccak256(
381             abi.encodePacked(
382                 "\x19\x01",
383                 DOMAIN_SEPARATOR,
384                 hashStruct));
385         address signer = ecrecover(hash, v, r, s);
386         return (signer != address(0) && signer == target);
387     }
388 
389     function verifyPersonalSign(address target, bytes32 hashStruct, uint8 v, bytes32 r, bytes32 s) internal pure returns (bool) {
390         bytes32 hash = prefixed(hashStruct);
391         address signer = ecrecover(hash, v, r, s);
392         return (signer != address(0) && signer == target);
393     }
394 
395     // Builds a prefixed hash to mimic the behavior of eth_sign.
396     function prefixed(bytes32 hash) internal pure returns (bytes32) {
397         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
398     }
399 
400     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`).
401     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
402     /// Emits {Transfer} event.
403     /// Returns boolean value indicating whether operation succeeded.
404     /// Requirements:
405     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
406     function transfer(address to, uint256 value) external override returns (bool) {
407         require(to != address(0) || to != address(this));
408         uint256 balance = balanceOf[msg.sender];
409         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
410 
411         balanceOf[msg.sender] = balance - value;
412         balanceOf[to] += value;
413         emit Transfer(msg.sender, to, value);
414 
415         return true;
416     }
417 
418     /// @dev Moves `value` AnyswapV3ERC20 token from account (`from`) to account (`to`) using allowance mechanism.
419     /// `value` is then deducted from caller account's allowance, unless set to `type(uint256).max`.
420     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
421     /// Emits {Approval} event to reflect reduced allowance `value` for caller account to spend from account (`from`),
422     /// unless allowance is set to `type(uint256).max`
423     /// Emits {Transfer} event.
424     /// Returns boolean value indicating whether operation succeeded.
425     /// Requirements:
426     ///   - `from` account must have at least `value` balance of AnyswapV3ERC20 token.
427     ///   - `from` account must have approved caller to spend at least `value` of AnyswapV3ERC20 token, unless `from` and caller are the same account.
428     function transferFrom(address from, address to, uint256 value) external override returns (bool) {
429         require(to != address(0) || to != address(this));
430         if (from != msg.sender) {
431             // _decreaseAllowance(from, msg.sender, value);
432             uint256 allowed = allowance[from][msg.sender];
433             if (allowed != type(uint256).max) {
434                 require(allowed >= value, "AnyswapV3ERC20: request exceeds allowance");
435                 uint256 reduced = allowed - value;
436                 allowance[from][msg.sender] = reduced;
437                 emit Approval(from, msg.sender, reduced);
438             }
439         }
440 
441         uint256 balance = balanceOf[from];
442         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
443 
444         balanceOf[from] = balance - value;
445         balanceOf[to] += value;
446         emit Transfer(from, to, value);
447 
448         return true;
449     }
450 
451     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`),
452     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
453     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
454     /// Emits {Transfer} event.
455     /// Returns boolean value indicating whether operation succeeded.
456     /// Requirements:
457     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
458     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
459     function transferAndCall(address to, uint value, bytes calldata data) external override returns (bool) {
460         require(to != address(0) || to != address(this));
461 
462         uint256 balance = balanceOf[msg.sender];
463         require(balance >= value, "AnyswapV3ERC20: transfer amount exceeds balance");
464 
465         balanceOf[msg.sender] = balance - value;
466         balanceOf[to] += value;
467         emit Transfer(msg.sender, to, value);
468 
469         return ITransferReceiver(to).onTokenTransfer(msg.sender, value, data);
470     }
471 }
