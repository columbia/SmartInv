1 // SPDX-License-Identifier: GPL-3.0-or-later
2 
3 pragma solidity 0.8.1;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount) external returns (bool);
27 
28     /**
29      * @dev Returns the remaining number of tokens that `spender` will be
30      * allowed to spend on behalf of `owner` through {transferFrom}. This is
31      * zero by default.
32      *
33      * This value changes when {approve} or {transferFrom} are called.
34      */
35     function allowance(address owner, address spender) external view returns (uint256);
36 
37     /**
38      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * IMPORTANT: Beware that changing an allowance with this method brings the risk
43      * that someone may use both the old and the new allowance by unfortunate
44      * transaction ordering. One possible solution to mitigate this race
45      * condition is to first reduce the spender's allowance to 0 and set the
46      * desired value afterwards:
47      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
48      *
49      * Emits an {Approval} event.
50      */
51     function approve(address spender, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Moves `amount` tokens from `sender` to `recipient` using the
55      * allowance mechanism. `amount` is then deducted from the caller's
56      * allowance.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * Emits a {Transfer} event.
61      */
62     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Emitted when `value` tokens are moved from one account (`from`) to
66      * another (`to`).
67      *
68      * Note that `value` may be zero.
69      */
70     event Transfer(address indexed from, address indexed to, uint256 value);
71 
72     /**
73      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
74      * a call to {approve}. `value` is the new allowance.
75      */
76     event Approval(address indexed owner, address indexed spender, uint256 value);
77 }
78 
79 /**
80  * @dev Interface of the ERC2612 standard as defined in the EIP.
81  *
82  * Adds the {permit} method, which can be used to change one's
83  * {IERC20-allowance} without having to send a transaction, by signing a
84  * message. This allows users to spend tokens without having to hold Ether.
85  *
86  * See https://eips.ethereum.org/EIPS/eip-2612.
87  */
88 interface IERC2612 {
89     /**
90      * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,
91      * given `owner`'s signed approval.
92      *
93      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
94      * ordering also apply here.
95      *
96      * Emits an {Approval} event.
97      *
98      * Requirements:
99      *
100      * - `owner` cannot be the zero address.
101      * - `spender` cannot be the zero address.
102      * - `deadline` must be a timestamp in the future.
103      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
104      * over the EIP712-formatted function arguments.
105      * - the signature must use ``owner``'s current nonce (see {nonces}).
106      *
107      * For more information on the signature format, see the
108      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
109      * section].
110      */
111     function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
112 
113     /**
114      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
115      * included whenever a signature is generated for {permit}.
116      *
117      * Every successful call to {permit} increases ``owner``'s nonce by one. This
118      * prevents a signature from being used multiple times.
119      */
120     function nonces(address owner) external view returns (uint256);
121 }
122 
123 /// @dev Wrapped ERC-20 v10 (WERC10) is an ERC-20 ERC-20 wrapper. You can `deposit` ERC-20 and obtain an WERC10 balance which can then be operated as an ERC-20 token. You can
124 /// `withdraw` ERC-20 from WERC10, which will then burn WERC10 token in your wallet. The amount of WERC10 token in any wallet is always identical to the
125 /// balance of ERC-20 deposited minus the ERC-20 withdrawn with that specific wallet.
126 interface IWERC10 is IERC20, IERC2612 {
127 
128     /// @dev Sets `value` as allowance of `spender` account over caller account's WERC10 token,
129     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
130     /// Emits {Approval} event.
131     /// Returns boolean value indicating whether operation succeeded.
132     /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.
133     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
134 
135     /// @dev Moves `value` WERC10 token from caller's account to account (`to`),
136     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
137     /// A transfer to `address(0)` triggers an ERC-20 withdraw matching the sent WERC10 token in favor of caller.
138     /// Emits {Transfer} event.
139     /// Returns boolean value indicating whether operation succeeded.
140     /// Requirements:
141     ///   - caller account must have at least `value` WERC10 token.
142     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
143     function transferAndCall(address to, uint value, bytes calldata data) external returns (bool);
144 }
145 
146 interface ITransferReceiver {
147     function onTokenTransfer(address, uint, bytes calldata) external returns (bool);
148 }
149 
150 interface IApprovalReceiver {
151     function onTokenApproval(address, uint, bytes calldata) external returns (bool);
152 }
153 
154 library Address {
155     function isContract(address account) internal view returns (bool) {
156         bytes32 codehash;
157         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
158         // solhint-disable-next-line no-inline-assembly
159         assembly { codehash := extcodehash(account) }
160         return (codehash != 0x0 && codehash != accountHash);
161     }
162 }
163 
164 library SafeERC20 {
165     using Address for address;
166 
167     function safeTransfer(IERC20 token, address to, uint value) internal {
168         callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
169     }
170 
171     function safeTransferFrom(IERC20 token, address from, address to, uint value) internal {
172         callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
173     }
174 
175     function safeApprove(IERC20 token, address spender, uint value) internal {
176         require((value == 0) || (token.allowance(address(this), spender) == 0),
177             "SafeERC20: approve from non-zero to non-zero allowance"
178         );
179         callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
180     }
181     function callOptionalReturn(IERC20 token, bytes memory data) private {
182         require(address(token).isContract(), "SafeERC20: call to non-contract");
183 
184         // solhint-disable-next-line avoid-low-level-calls
185         (bool success, bytes memory returndata) = address(token).call(data);
186         require(success, "SafeERC20: low-level call failed");
187 
188         if (returndata.length > 0) { // Return data is optional
189             // solhint-disable-next-line max-line-length
190             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
191         }
192     }
193 }
194 
195 /// @dev Wrapped Ether v10 (WERC10) is an Ether (ETH) ERC-20 wrapper. You can `deposit` ETH and obtain an WERC10 balance which can then be operated as an ERC-20 token. You can
196 /// `withdraw` ETH from WERC10, which will then burn WERC10 token in your wallet. The amount of WERC10 token in any wallet is always identical to the
197 /// balance of ETH deposited minus the ETH withdrawn with that specific wallet.
198 contract AnyswapV2ERC20 is IWERC10 {
199     using SafeERC20 for IERC20;
200     string public name;
201     string public symbol;
202     uint8  public immutable decimals;
203 
204     bytes32 public constant PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
205     bytes32 public constant TRANSFER_TYPEHASH = keccak256("Transfer(address owner,address to,uint256 value,uint256 nonce,uint256 deadline)");
206     bytes32 public immutable DOMAIN_SEPARATOR;
207 
208     /// @dev Records amount of WERC10 token owned by account.
209     mapping (address => uint256) public override balanceOf;
210     uint256 private _totalSupply;
211 
212     address private _oldOwner;
213     address private _newOwner;
214     uint256 private _newOwnerEffectiveTime;
215 
216 
217     modifier onlyOwner() {
218         require(msg.sender == owner(), "only owner");
219         _;
220     }
221 
222     function owner() public view returns (address) {
223         if (block.timestamp >= _newOwnerEffectiveTime) {
224             return _newOwner;
225         }
226         return _oldOwner;
227     }
228 
229 
230     function changeDCRMOwner(address newOwner) public onlyOwner returns (bool) {
231         require(newOwner != address(0), "new owner is the zero address");
232         _oldOwner = owner();
233         _newOwner = newOwner;
234         _newOwnerEffectiveTime = block.timestamp + 2*24*3600;
235         emit LogChangeDCRMOwner(_oldOwner, _newOwner, _newOwnerEffectiveTime);
236         return true;
237     }
238 
239     function Swapin(bytes32 txhash, address account, uint256 amount) public onlyOwner returns (bool) {
240         _mint(account, amount);
241         emit LogSwapin(txhash, account, amount);
242         return true;
243     }
244 
245     function Swapout(uint256 amount, address bindaddr) public returns (bool) {
246         require(bindaddr != address(0), "bind address is the zero address");
247         _burn(msg.sender, amount);
248         emit LogSwapout(msg.sender, bindaddr, amount);
249         return true;
250     }
251 
252     /// @dev Records current ERC2612 nonce for account. This value must be included whenever signature is generated for {permit}.
253     /// Every successful call to {permit} increases account's nonce by one. This prevents signature from being used multiple times.
254     mapping (address => uint256) public override nonces;
255 
256     /// @dev Records number of WERC10 token that account (second) will be allowed to spend on behalf of another account (first) through {transferFrom}.
257     mapping (address => mapping (address => uint256)) public override allowance;
258 
259     event LogChangeDCRMOwner(address indexed oldOwner, address indexed newOwner, uint indexed effectiveTime);
260     event LogSwapin(bytes32 indexed txhash, address indexed account, uint amount);
261     event LogSwapout(address indexed account, address indexed bindaddr, uint amount);
262 
263     constructor(string memory _name, string memory _symbol, uint8 _decimals, address _owner) {
264         name = _name;
265         symbol = _symbol;
266         decimals = _decimals;
267 
268         _newOwner = _owner;
269         _newOwnerEffectiveTime = block.timestamp;
270 
271         uint256 chainId;
272         assembly {chainId := chainid()}
273         DOMAIN_SEPARATOR = keccak256(
274             abi.encode(
275                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
276                 keccak256(bytes(name)),
277                 keccak256(bytes("1")),
278                 chainId,
279                 address(this)));
280     }
281 
282     /// @dev Returns the total supply of WERC10 token as the ETH held in this contract.
283     function totalSupply() external view override returns (uint256) {
284         return _totalSupply;
285     }
286 
287     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
288      * the total supply.
289      *
290      * Emits a {Transfer} event with `from` set to the zero address.
291      *
292      * Requirements
293      *
294      * - `to` cannot be the zero address.
295      */
296     function _mint(address account, uint256 amount) internal {
297         require(account != address(0), "ERC20: mint to the zero address");
298 
299         _totalSupply += amount;
300         balanceOf[account] += amount;
301         emit Transfer(address(0), account, amount);
302     }
303 
304     /**
305      * @dev Destroys `amount` tokens from `account`, reducing the
306      * total supply.
307      *
308      * Emits a {Transfer} event with `to` set to the zero address.
309      *
310      * Requirements
311      *
312      * - `account` cannot be the zero address.
313      * - `account` must have at least `amount` tokens.
314      */
315     function _burn(address account, uint256 amount) internal {
316         require(account != address(0), "ERC20: burn from the zero address");
317 
318         balanceOf[account] -= amount;
319         _totalSupply -= amount;
320         emit Transfer(account, address(0), amount);
321     }
322 
323     /// @dev Sets `value` as allowance of `spender` account over caller account's WERC10 token.
324     /// Emits {Approval} event.
325     /// Returns boolean value indicating whether operation succeeded.
326     function approve(address spender, uint256 value) external override returns (bool) {
327         // _approve(msg.sender, spender, value);
328         allowance[msg.sender][spender] = value;
329         emit Approval(msg.sender, spender, value);
330 
331         return true;
332     }
333 
334     /// @dev Sets `value` as allowance of `spender` account over caller account's WERC10 token,
335     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
336     /// Emits {Approval} event.
337     /// Returns boolean value indicating whether operation succeeded.
338     /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.
339     function approveAndCall(address spender, uint256 value, bytes calldata data) external override returns (bool) {
340         // _approve(msg.sender, spender, value);
341         allowance[msg.sender][spender] = value;
342         emit Approval(msg.sender, spender, value);
343 
344         return IApprovalReceiver(spender).onTokenApproval(msg.sender, value, data);
345     }
346 
347     /// @dev Sets `value` as allowance of `spender` account over `owner` account's WERC10 token, given `owner` account's signed approval.
348     /// Emits {Approval} event.
349     /// Requirements:
350     ///   - `deadline` must be timestamp in future.
351     ///   - `v`, `r` and `s` must be valid `secp256k1` signature from `owner` account over EIP712-formatted function arguments.
352     ///   - the signature must use `owner` account's current nonce (see {nonces}).
353     ///   - the signer cannot be zero address and must be `owner` account.
354     /// For more information on signature format, see https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP section].
355     /// WERC10 token implementation adapted from https://github.com/albertocuestacanada/ERC20Permit/blob/master/contracts/ERC20Permit.sol.
356     function permit(address target, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override {
357         require(block.timestamp <= deadline, "WERC10: Expired permit");
358 
359         bytes32 hashStruct = keccak256(
360             abi.encode(
361                 PERMIT_TYPEHASH,
362                 target,
363                 spender,
364                 value,
365                 nonces[target]++,
366                 deadline));
367 
368         require(verifyEIP712(target, hashStruct, v, r, s) || verifyPersonalSign(target, hashStruct, v, r, s));
369 
370         // _approve(owner, spender, value);
371         allowance[target][spender] = value;
372         emit Approval(target, spender, value);
373     }
374 
375     function transferWithPermit(address target, address to, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external returns (bool) {
376         require(block.timestamp <= deadline, "WERC10: Expired permit");
377 
378         bytes32 hashStruct = keccak256(
379             abi.encode(
380                 TRANSFER_TYPEHASH,
381                 target,
382                 to,
383                 value,
384                 nonces[target]++,
385                 deadline));
386 
387         require(verifyEIP712(target, hashStruct, v, r, s) || verifyPersonalSign(target, hashStruct, v, r, s));
388 
389         require(to != address(0) || to != address(this));
390 
391         uint256 balance = balanceOf[target];
392         require(balance >= value, "WERC10: transfer amount exceeds balance");
393 
394         balanceOf[target] = balance - value;
395         balanceOf[to] += value;
396         emit Transfer(target, to, value);
397 
398         return true;
399     }
400 
401     function verifyEIP712(address target, bytes32 hashStruct, uint8 v, bytes32 r, bytes32 s) internal view returns (bool) {
402         bytes32 hash = keccak256(
403             abi.encodePacked(
404                 "\x19\x01",
405                 DOMAIN_SEPARATOR,
406                 hashStruct));
407         address signer = ecrecover(hash, v, r, s);
408         return (signer != address(0) && signer == target);
409     }
410 
411     function verifyPersonalSign(address target, bytes32 hashStruct, uint8 v, bytes32 r, bytes32 s) internal pure returns (bool) {
412         bytes32 hash = prefixed(hashStruct);
413         address signer = ecrecover(hash, v, r, s);
414         return (signer != address(0) && signer == target);
415     }
416 
417     // Builds a prefixed hash to mimic the behavior of eth_sign.
418     function prefixed(bytes32 hash) internal pure returns (bytes32) {
419         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
420     }
421 
422     /// @dev Moves `value` WERC10 token from caller's account to account (`to`).
423     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent WERC10 token in favor of caller.
424     /// Emits {Transfer} event.
425     /// Returns boolean value indicating whether operation succeeded.
426     /// Requirements:
427     ///   - caller account must have at least `value` WERC10 token.
428     function transfer(address to, uint256 value) external override returns (bool) {
429         require(to != address(0) || to != address(this));
430         uint256 balance = balanceOf[msg.sender];
431         require(balance >= value, "WERC10: transfer amount exceeds balance");
432 
433         balanceOf[msg.sender] = balance - value;
434         balanceOf[to] += value;
435         emit Transfer(msg.sender, to, value);
436 
437         return true;
438     }
439 
440     /// @dev Moves `value` WERC10 token from account (`from`) to account (`to`) using allowance mechanism.
441     /// `value` is then deducted from caller account's allowance, unless set to `type(uint256).max`.
442     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent WERC10 token in favor of caller.
443     /// Emits {Approval} event to reflect reduced allowance `value` for caller account to spend from account (`from`),
444     /// unless allowance is set to `type(uint256).max`
445     /// Emits {Transfer} event.
446     /// Returns boolean value indicating whether operation succeeded.
447     /// Requirements:
448     ///   - `from` account must have at least `value` balance of WERC10 token.
449     ///   - `from` account must have approved caller to spend at least `value` of WERC10 token, unless `from` and caller are the same account.
450     function transferFrom(address from, address to, uint256 value) external override returns (bool) {
451         require(to != address(0) || to != address(this));
452         if (from != msg.sender) {
453             // _decreaseAllowance(from, msg.sender, value);
454             uint256 allowed = allowance[from][msg.sender];
455             if (allowed != type(uint256).max) {
456                 require(allowed >= value, "WERC10: request exceeds allowance");
457                 uint256 reduced = allowed - value;
458                 allowance[from][msg.sender] = reduced;
459                 emit Approval(from, msg.sender, reduced);
460             }
461         }
462 
463         uint256 balance = balanceOf[from];
464         require(balance >= value, "WERC10: transfer amount exceeds balance");
465 
466         balanceOf[from] = balance - value;
467         balanceOf[to] += value;
468         emit Transfer(from, to, value);
469 
470         return true;
471     }
472 
473     /// @dev Moves `value` WERC10 token from caller's account to account (`to`),
474     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
475     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent WERC10 token in favor of caller.
476     /// Emits {Transfer} event.
477     /// Returns boolean value indicating whether operation succeeded.
478     /// Requirements:
479     ///   - caller account must have at least `value` WERC10 token.
480     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
481     function transferAndCall(address to, uint value, bytes calldata data) external override returns (bool) {
482         require(to != address(0) || to != address(this));
483 
484         uint256 balance = balanceOf[msg.sender];
485         require(balance >= value, "WERC10: transfer amount exceeds balance");
486 
487         balanceOf[msg.sender] = balance - value;
488         balanceOf[to] += value;
489         emit Transfer(msg.sender, to, value);
490 
491         return ITransferReceiver(to).onTokenTransfer(msg.sender, value, data);
492     }
493 }
