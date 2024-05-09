1 // SPDX-License-Identifier: GPL-3.0-or-later
2 // Copyright (C) 2015, 2016, 2017 Dapphub
3 // Adapted by Ethereum Community 2020
4 pragma solidity 0.7.6;
5 
6 
7 
8 interface IERC20 {
9     function totalSupply() external view returns (uint256);
10 
11     function balanceOf(address account) external view returns (uint256);
12 
13     function decimals() external returns (uint8);
14 
15     function transfer(address recipient, uint256 amount)
16         external
17         returns (bool);
18 
19     function allowance(address owner, address spender)
20         external
21         view
22         returns (uint256);
23 
24     function approve(address spender, uint256 amount) external returns (bool);
25 
26     function transferFrom(
27         address sender,
28         address recipient,
29         uint256 amount
30     ) external returns (bool);
31 
32     event Transfer(address indexed from, address indexed to, uint256 value);
33     event Approval(
34         address indexed owner,
35         address indexed spender,
36         uint256 value
37     );
38 }
39 
40 
41 
42 interface IERC2612 {
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over `owner`'s tokens,
45      * given `owner`'s signed approval.
46      *
47      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
48      * ordering also apply here.
49      *
50      * Emits an {Approval} event.
51      *
52      * Requirements:
53      *
54      * - `owner` cannot be the zero address.
55      * - `spender` cannot be the zero address.
56      * - `deadline` must be a timestamp in the future.
57      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
58      * over the EIP712-formatted function arguments.
59      * - the signature must use ``owner``'s current nonce (see {nonces}).
60      *
61      * For more information on the signature format, see the
62      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
63      * section].
64      */
65     function permit(address owner, address spender, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
66 
67     /**
68      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
69      * included whenever a signature is generated for {permit}.
70      *
71      * Every successful call to {permit} increases ``owner``'s nonce by one. This
72      * prevents a signature from being used multiple times.
73      */
74     function nonces(address owner) external view returns (uint256);
75 }
76 
77 interface IERC3156FlashBorrower {
78 
79     /**
80      * @dev Receive a flash loan.
81      * @param initiator The initiator of the loan.
82      * @param token The loan currency.
83      * @param amount The amount of tokens lent.
84      * @param fee The additional amount of tokens to repay.
85      * @param data Arbitrary data structure, intended to contain user-defined parameters.
86      * @return The keccak256 hash of "ERC3156FlashBorrower.onFlashLoan"
87      */
88     function onFlashLoan(
89         address initiator,
90         address token,
91         uint256 amount,
92         uint256 fee,
93         bytes calldata data
94     ) external returns (bytes32);
95 }
96 
97 
98 interface IERC3156FlashLender {
99 
100     /**
101      * @dev The amount of currency available to be lended.
102      * @param token The loan currency.
103      * @return The amount of `token` that can be borrowed.
104      */
105     function maxFlashLoan(
106         address token
107     ) external view returns (uint256);
108 
109     /**
110      * @dev The fee to be charged for a given loan.
111      * @param token The loan currency.
112      * @param amount The amount of tokens lent.
113      * @return The amount of `token` to be charged for the loan, on top of the returned principal.
114      */
115     function flashFee(
116         address token,
117         uint256 amount
118     ) external view returns (uint256);
119 
120     /**
121      * @dev Initiate a flash loan.
122      * @param receiver The receiver of the tokens in the loan, and the receiver of the callback.
123      * @param token The loan currency.
124      * @param amount The amount of tokens lent.
125      * @param data Arbitrary data structure, intended to contain user-defined parameters.
126      */
127     function flashLoan(
128         IERC3156FlashBorrower receiver,
129         address token,
130         uint256 amount,
131         bytes calldata data
132     ) external returns (bool);
133 }
134 
135 /// @dev Wrapped Ether v10 (WETH10) is an Ether (ETH) ERC-20 wrapper. You can `deposit` ETH and obtain an WETH10 balance which can then be operated as an ERC-20 token. You can
136 /// `withdraw` ETH from WETH10, which will then burn WETH10 token in your wallet. The amount of WETH10 token in any wallet is always identical to the
137 /// balance of ETH deposited minus the ETH withdrawn with that specific wallet.
138 interface IWETH10 is IERC20, IERC2612, IERC3156FlashLender {
139 
140     /// @dev Returns current amount of flash-minted WETH10 token.
141     function flashMinted() external view returns(uint256);
142 
143     /// @dev `msg.value` of ETH sent to this contract grants caller account a matching increase in WETH10 token balance.
144     /// Emits {Transfer} event to reflect WETH10 token mint of `msg.value` from zero address to caller account.
145     function deposit() external payable;
146 
147     /// @dev `msg.value` of ETH sent to this contract grants `to` account a matching increase in WETH10 token balance.
148     /// Emits {Transfer} event to reflect WETH10 token mint of `msg.value` from zero address to `to` account.
149     function depositTo(address to) external payable;
150 
151     /// @dev Burn `value` WETH10 token from caller account and withdraw matching ETH to the same.
152     /// Emits {Transfer} event to reflect WETH10 token burn of `value` to zero address from caller account. 
153     /// Requirements:
154     ///   - caller account must have at least `value` balance of WETH10 token.
155     function withdraw(uint256 value) external;
156 
157     /// @dev Burn `value` WETH10 token from caller account and withdraw matching ETH to account (`to`).
158     /// Emits {Transfer} event to reflect WETH10 token burn of `value` to zero address from caller account.
159     /// Requirements:
160     ///   - caller account must have at least `value` balance of WETH10 token.
161     function withdrawTo(address payable to, uint256 value) external;
162 
163     /// @dev Burn `value` WETH10 token from account (`from`) and withdraw matching ETH to account (`to`).
164     /// Emits {Approval} event to reflect reduced allowance `value` for caller account to spend from account (`from`),
165     /// unless allowance is set to `type(uint256).max`
166     /// Emits {Transfer} event to reflect WETH10 token burn of `value` to zero address from account (`from`).
167     /// Requirements:
168     ///   - `from` account must have at least `value` balance of WETH10 token.
169     ///   - `from` account must have approved caller to spend at least `value` of WETH10 token, unless `from` and caller are the same account.
170     function withdrawFrom(address from, address payable to, uint256 value) external;
171 
172     /// @dev `msg.value` of ETH sent to this contract grants `to` account a matching increase in WETH10 token balance,
173     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
174     /// Emits {Transfer} event.
175     /// Returns boolean value indicating whether operation succeeded.
176     /// For more information on *transferAndCall* format, see https://github.com/ethereum/EIPs/issues/677.
177     function depositToAndCall(address to, bytes calldata data) external payable returns (bool);
178 
179     /// @dev Sets `value` as allowance of `spender` account over caller account's WETH10 token,
180     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
181     /// Emits {Approval} event.
182     /// Returns boolean value indicating whether operation succeeded.
183     /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.
184     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
185 
186     /// @dev Moves `value` WETH10 token from caller's account to account (`to`), 
187     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
188     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent WETH10 token in favor of caller.
189     /// Emits {Transfer} event.
190     /// Returns boolean value indicating whether operation succeeded.
191     /// Requirements:
192     ///   - caller account must have at least `value` WETH10 token.
193     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
194     function transferAndCall(address to, uint value, bytes calldata data) external returns (bool);
195 }
196 
197 interface ITransferReceiver {
198     function onTokenTransfer(address, uint, bytes calldata) external returns (bool);
199 }
200 
201 interface IApprovalReceiver {
202     function onTokenApproval(address, uint, bytes calldata) external returns (bool);
203 }
204 
205 /// @dev Wrapped Ether v10 (WETH10) is an Ether (ETH) ERC-20 wrapper. You can `deposit` ETH and obtain an WETH10 balance which can then be operated as an ERC-20 token. You can
206 /// `withdraw` ETH from WETH10, which will then burn WETH10 token in your wallet. The amount of WETH10 token in any wallet is always identical to the
207 /// balance of ETH deposited minus the ETH withdrawn with that specific wallet.
208 contract WETH10 is IWETH10 {
209 
210     string public constant name = "WETH10";
211     string public constant symbol = "WETH10";
212     uint8  public override constant decimals = 18;
213 
214     bytes32 public immutable CALLBACK_SUCCESS = keccak256("ERC3156FlashBorrower.onFlashLoan");
215     bytes32 public immutable PERMIT_TYPEHASH = keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
216 
217     /// @dev Records amount of WETH10 token owned by account.
218     mapping (address => uint256) public override balanceOf;
219 
220     /// @dev Records current ERC2612 nonce for account. This value must be included whenever signature is generated for {permit}.
221     /// Every successful call to {permit} increases account's nonce by one. This prevents signature from being used multiple times.
222     mapping (address => uint256) public override nonces;
223 
224     /// @dev Records number of WETH10 token that account (second) will be allowed to spend on behalf of another account (first) through {transferFrom}.
225     mapping (address => mapping (address => uint256)) public override allowance;
226 
227     /// @dev Current amount of flash-minted WETH10 token.
228     uint256 public override flashMinted;
229     
230     /// @dev Returns the total supply of WETH10 token as the ETH held in this contract.
231     function totalSupply() external view override returns(uint256) {
232         return address(this).balance + flashMinted;
233     }
234 
235     /// @dev Fallback, `msg.value` of ETH sent to this contract grants caller account a matching increase in WETH10 token balance.
236     /// Emits {Transfer} event to reflect WETH10 token mint of `msg.value` from zero address to caller account.
237     receive() external payable {
238         // _mintTo(msg.sender, msg.value);
239         balanceOf[msg.sender] += msg.value;
240         emit Transfer(address(0), msg.sender, msg.value);
241     }
242 
243     /// @dev `msg.value` of ETH sent to this contract grants caller account a matching increase in WETH10 token balance.
244     /// Emits {Transfer} event to reflect WETH10 token mint of `msg.value` from zero address to caller account.
245     function deposit() external override payable {
246         // _mintTo(msg.sender, msg.value);
247         balanceOf[msg.sender] += msg.value;
248         emit Transfer(address(0), msg.sender, msg.value);
249     }
250 
251     /// @dev `msg.value` of ETH sent to this contract grants `to` account a matching increase in WETH10 token balance.
252     /// Emits {Transfer} event to reflect WETH10 token mint of `msg.value` from zero address to `to` account.
253     function depositTo(address to) external override payable {
254         // _mintTo(to, msg.value);
255         balanceOf[to] += msg.value;
256         emit Transfer(address(0), to, msg.value);
257     }
258 
259     /// @dev `msg.value` of ETH sent to this contract grants `to` account a matching increase in WETH10 token balance,
260     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
261     /// Emits {Transfer} event.
262     /// Returns boolean value indicating whether operation succeeded.
263     /// For more information on *transferAndCall* format, see https://github.com/ethereum/EIPs/issues/677.
264     function depositToAndCall(address to, bytes calldata data) external override payable returns (bool success) {
265         // _mintTo(to, msg.value);
266         balanceOf[to] += msg.value;
267         emit Transfer(address(0), to, msg.value);
268 
269         return ITransferReceiver(to).onTokenTransfer(msg.sender, msg.value, data);
270     }
271 
272     /// @dev Return the amount of WETH10 token that can be flash-lent.
273     function maxFlashLoan(address token) external view override returns (uint256) {
274         return token == address(this) ? type(uint112).max - flashMinted : 0; // Can't underflow
275     }
276 
277     /// @dev Return the fee (zero) for flash-lending an amount of WETH10 token.
278     function flashFee(address token, uint256) external view override returns (uint256) {
279         require(token == address(this), "WETH: flash mint only WETH10");
280         return 0;
281     }
282 
283     /// @dev Flash lends `value` WETH10 token to the receiver address.
284     /// By the end of the transaction, `value` WETH10 token will be burned from the receiver.
285     /// The flash-minted WETH10 token is not backed by real ETH, but can be withdrawn as such up to the ETH balance of this contract.
286     /// Arbitrary data can be passed as a bytes calldata parameter.
287     /// Emits {Approval} event to reflect reduced allowance `value` for this contract to spend from receiver account (`receiver`),
288     /// unless allowance is set to `type(uint256).max`
289     /// Emits two {Transfer} events for minting and burning of the flash-minted amount.
290     /// Returns boolean value indicating whether operation succeeded.
291     /// Requirements:
292     ///   - `value` must be less or equal to type(uint112).max.
293     ///   - The total of all flash loans in a tx must be less or equal to type(uint112).max.
294     function flashLoan(IERC3156FlashBorrower receiver, address token, uint256 value, bytes calldata data) external override returns(bool) {
295         require(token == address(this), "WETH: flash mint only WETH10");
296         require(value <= type(uint112).max, "WETH: individual loan limit exceeded");
297         flashMinted = flashMinted + value;
298         require(flashMinted <= type(uint112).max, "WETH: total loan limit exceeded");
299         
300         // _mintTo(address(receiver), value);
301         balanceOf[address(receiver)] += value;
302         emit Transfer(address(0), address(receiver), value);
303 
304         require(
305             receiver.onFlashLoan(msg.sender, address(this), value, 0, data) == CALLBACK_SUCCESS,
306             "WETH: flash loan failed"
307         );
308         
309         // _decreaseAllowance(address(receiver), address(this), value);
310         uint256 allowed = allowance[address(receiver)][address(this)];
311         if (allowed != type(uint256).max) {
312             require(allowed >= value, "WETH: request exceeds allowance");
313             uint256 reduced = allowed - value;
314             allowance[address(receiver)][address(this)] = reduced;
315             emit Approval(address(receiver), address(this), reduced);
316         }
317 
318         // _burnFrom(address(receiver), value);
319         uint256 balance = balanceOf[address(receiver)];
320         require(balance >= value, "WETH: burn amount exceeds balance");
321         balanceOf[address(receiver)] = balance - value;
322         emit Transfer(address(receiver), address(0), value);
323         
324         flashMinted = flashMinted - value;
325         return true;
326     }
327 
328     /// @dev Burn `value` WETH10 token from caller account and withdraw matching ETH to the same.
329     /// Emits {Transfer} event to reflect WETH10 token burn of `value` to zero address from caller account. 
330     /// Requirements:
331     ///   - caller account must have at least `value` balance of WETH10 token.
332     function withdraw(uint256 value) external override {
333         // _burnFrom(msg.sender, value);
334         uint256 balance = balanceOf[msg.sender];
335         require(balance >= value, "WETH: burn amount exceeds balance");
336         balanceOf[msg.sender] = balance - value;
337         emit Transfer(msg.sender, address(0), value);
338 
339         // _transferEther(msg.sender, value);        
340         (bool success, ) = msg.sender.call{value: value}("");
341         require(success, "WETH: ETH transfer failed");
342     }
343 
344     /// @dev Burn `value` WETH10 token from caller account and withdraw matching ETH to account (`to`).
345     /// Emits {Transfer} event to reflect WETH10 token burn of `value` to zero address from caller account.
346     /// Requirements:
347     ///   - caller account must have at least `value` balance of WETH10 token.
348     function withdrawTo(address payable to, uint256 value) external override {
349         // _burnFrom(msg.sender, value);
350         uint256 balance = balanceOf[msg.sender];
351         require(balance >= value, "WETH: burn amount exceeds balance");
352         balanceOf[msg.sender] = balance - value;
353         emit Transfer(msg.sender, address(0), value);
354 
355         // _transferEther(to, value);        
356         (bool success, ) = to.call{value: value}("");
357         require(success, "WETH: ETH transfer failed");
358     }
359 
360     /// @dev Burn `value` WETH10 token from account (`from`) and withdraw matching ETH to account (`to`).
361     /// Emits {Approval} event to reflect reduced allowance `value` for caller account to spend from account (`from`),
362     /// unless allowance is set to `type(uint256).max`
363     /// Emits {Transfer} event to reflect WETH10 token burn of `value` to zero address from account (`from`).
364     /// Requirements:
365     ///   - `from` account must have at least `value` balance of WETH10 token.
366     ///   - `from` account must have approved caller to spend at least `value` of WETH10 token, unless `from` and caller are the same account.
367     function withdrawFrom(address from, address payable to, uint256 value) external override {
368         if (from != msg.sender) {
369             // _decreaseAllowance(from, msg.sender, value);
370             uint256 allowed = allowance[from][msg.sender];
371             if (allowed != type(uint256).max) {
372                 require(allowed >= value, "WETH: request exceeds allowance");
373                 uint256 reduced = allowed - value;
374                 allowance[from][msg.sender] = reduced;
375                 emit Approval(from, msg.sender, reduced);
376             }
377         }
378         
379         // _burnFrom(from, value);
380         uint256 balance = balanceOf[from];
381         require(balance >= value, "WETH: burn amount exceeds balance");
382         balanceOf[from] = balance - value;
383         emit Transfer(from, address(0), value);
384 
385         // _transferEther(to, value);        
386         (bool success, ) = to.call{value: value}("");
387         require(success, "WETH: Ether transfer failed");
388     }
389 
390     /// @dev Sets `value` as allowance of `spender` account over caller account's WETH10 token.
391     /// Emits {Approval} event.
392     /// Returns boolean value indicating whether operation succeeded.
393     function approve(address spender, uint256 value) external override returns (bool) {
394         // _approve(msg.sender, spender, value);
395         allowance[msg.sender][spender] = value;
396         emit Approval(msg.sender, spender, value);
397 
398         return true;
399     }
400 
401     /// @dev Sets `value` as allowance of `spender` account over caller account's WETH10 token,
402     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
403     /// Emits {Approval} event.
404     /// Returns boolean value indicating whether operation succeeded.
405     /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.
406     function approveAndCall(address spender, uint256 value, bytes calldata data) external override returns (bool) {
407         // _approve(msg.sender, spender, value);
408         allowance[msg.sender][spender] = value;
409         emit Approval(msg.sender, spender, value);
410         
411         return IApprovalReceiver(spender).onTokenApproval(msg.sender, value, data);
412     }
413 
414     /// @dev Sets `value` as allowance of `spender` account over `owner` account's WETH10 token, given `owner` account's signed approval.
415     /// Emits {Approval} event.
416     /// Requirements:
417     ///   - `deadline` must be timestamp in future.
418     ///   - `v`, `r` and `s` must be valid `secp256k1` signature from `owner` account over EIP712-formatted function arguments.
419     ///   - the signature must use `owner` account's current nonce (see {nonces}).
420     ///   - the signer cannot be zero address and must be `owner` account.
421     /// For more information on signature format, see https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP section].
422     /// WETH10 token implementation adapted from https://github.com/albertocuestacanada/ERC20Permit/blob/master/contracts/ERC20Permit.sol.
423     function permit(address owner, address spender, uint256 value, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external override {
424         require(block.timestamp <= deadline, "WETH: Expired permit");
425 
426         uint256 chainId;
427         assembly {chainId := chainid()}
428         bytes32 DOMAIN_SEPARATOR = keccak256(
429             abi.encode(
430                 keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
431                 keccak256(bytes(name)),
432                 keccak256(bytes("1")),
433                 chainId,
434                 address(this)));
435 
436         bytes32 hashStruct = keccak256(
437             abi.encode(
438                 PERMIT_TYPEHASH,
439                 owner,
440                 spender,
441                 value,
442                 nonces[owner]++,
443                 deadline));
444 
445         bytes32 hash = keccak256(
446             abi.encodePacked(
447                 "\x19\x01",
448                 DOMAIN_SEPARATOR,
449                 hashStruct));
450 
451         address signer = ecrecover(hash, v, r, s);
452         require(signer != address(0) && signer == owner, "WETH: invalid permit");
453 
454         // _approve(owner, spender, value);
455         allowance[owner][spender] = value;
456         emit Approval(owner, spender, value);
457     }
458 
459     /// @dev Moves `value` WETH10 token from caller's account to account (`to`).
460     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent WETH10 token in favor of caller.
461     /// Emits {Transfer} event.
462     /// Returns boolean value indicating whether operation succeeded.
463     /// Requirements:
464     ///   - caller account must have at least `value` WETH10 token.
465     function transfer(address to, uint256 value) external override returns (bool) {
466         // _transferFrom(msg.sender, to, value);
467         if (to != address(0)) { // Transfer
468             uint256 balance = balanceOf[msg.sender];
469             require(balance >= value, "WETH: transfer amount exceeds balance");
470 
471             balanceOf[msg.sender] = balance - value;
472             balanceOf[to] += value;
473             emit Transfer(msg.sender, to, value);
474         } else { // Withdraw
475             uint256 balance = balanceOf[msg.sender];
476             require(balance >= value, "WETH: burn amount exceeds balance");
477             balanceOf[msg.sender] = balance - value;
478             emit Transfer(msg.sender, address(0), value);
479             
480             (bool success, ) = msg.sender.call{value: value}("");
481             require(success, "WETH: ETH transfer failed");
482         }
483         
484         return true;
485     }
486 
487     /// @dev Moves `value` WETH10 token from account (`from`) to account (`to`) using allowance mechanism.
488     /// `value` is then deducted from caller account's allowance, unless set to `type(uint256).max`.
489     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent WETH10 token in favor of caller.
490     /// Emits {Approval} event to reflect reduced allowance `value` for caller account to spend from account (`from`),
491     /// unless allowance is set to `type(uint256).max`
492     /// Emits {Transfer} event.
493     /// Returns boolean value indicating whether operation succeeded.
494     /// Requirements:
495     ///   - `from` account must have at least `value` balance of WETH10 token.
496     ///   - `from` account must have approved caller to spend at least `value` of WETH10 token, unless `from` and caller are the same account.
497     function transferFrom(address from, address to, uint256 value) external override returns (bool) {
498         if (from != msg.sender) {
499             // _decreaseAllowance(from, msg.sender, value);
500             uint256 allowed = allowance[from][msg.sender];
501             if (allowed != type(uint256).max) {
502                 require(allowed >= value, "WETH: request exceeds allowance");
503                 uint256 reduced = allowed - value;
504                 allowance[from][msg.sender] = reduced;
505                 emit Approval(from, msg.sender, reduced);
506             }
507         }
508         
509         // _transferFrom(from, to, value);
510         if (to != address(0)) { // Transfer
511             uint256 balance = balanceOf[from];
512             require(balance >= value, "WETH: transfer amount exceeds balance");
513 
514             balanceOf[from] = balance - value;
515             balanceOf[to] += value;
516             emit Transfer(from, to, value);
517         } else { // Withdraw
518             uint256 balance = balanceOf[from];
519             require(balance >= value, "WETH: burn amount exceeds balance");
520             balanceOf[from] = balance - value;
521             emit Transfer(from, address(0), value);
522         
523             (bool success, ) = msg.sender.call{value: value}("");
524             require(success, "WETH: ETH transfer failed");
525         }
526         
527         return true;
528     }
529 
530     /// @dev Moves `value` WETH10 token from caller's account to account (`to`), 
531     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
532     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent WETH10 token in favor of caller.
533     /// Emits {Transfer} event.
534     /// Returns boolean value indicating whether operation succeeded.
535     /// Requirements:
536     ///   - caller account must have at least `value` WETH10 token.
537     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
538     function transferAndCall(address to, uint value, bytes calldata data) external override returns (bool) {
539         // _transferFrom(msg.sender, to, value);
540         if (to != address(0)) { // Transfer
541             uint256 balance = balanceOf[msg.sender];
542             require(balance >= value, "WETH: transfer amount exceeds balance");
543 
544             balanceOf[msg.sender] = balance - value;
545             balanceOf[to] += value;
546             emit Transfer(msg.sender, to, value);
547         } else { // Withdraw
548             uint256 balance = balanceOf[msg.sender];
549             require(balance >= value, "WETH: burn amount exceeds balance");
550             balanceOf[msg.sender] = balance - value;
551             emit Transfer(msg.sender, address(0), value);
552         
553             (bool success, ) = msg.sender.call{value: value}("");
554             require(success, "WETH: ETH transfer failed");
555         }
556 
557         return ITransferReceiver(to).onTokenTransfer(msg.sender, value, data);
558     }
559 }