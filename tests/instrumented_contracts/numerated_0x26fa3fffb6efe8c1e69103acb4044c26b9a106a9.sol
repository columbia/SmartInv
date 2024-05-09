1 // SPDX-License-Identifier: MIXED
2 
3 // File @boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol@v1.2.2
4 // License-Identifier: MIT
5 pragma solidity 0.6.12;
6 pragma experimental ABIEncoderV2;
7 
8 /// @notice A library for performing overflow-/underflow-safe math,
9 /// updated with awesomeness from of DappHub (https://github.com/dapphub/ds-math).
10 library BoringMath {
11     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
12         require((c = a + b) >= b, "BoringMath: Add Overflow");
13     }
14 
15     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
16         require((c = a - b) <= a, "BoringMath: Underflow");
17     }
18 
19     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
20         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
21     }
22 
23     function to128(uint256 a) internal pure returns (uint128 c) {
24         require(a <= uint128(-1), "BoringMath: uint128 Overflow");
25         c = uint128(a);
26     }
27 
28     function to64(uint256 a) internal pure returns (uint64 c) {
29         require(a <= uint64(-1), "BoringMath: uint64 Overflow");
30         c = uint64(a);
31     }
32 
33     function to32(uint256 a) internal pure returns (uint32 c) {
34         require(a <= uint32(-1), "BoringMath: uint32 Overflow");
35         c = uint32(a);
36     }
37 }
38 
39 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint128.
40 library BoringMath128 {
41     function add(uint128 a, uint128 b) internal pure returns (uint128 c) {
42         require((c = a + b) >= b, "BoringMath: Add Overflow");
43     }
44 
45     function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {
46         require((c = a - b) <= a, "BoringMath: Underflow");
47     }
48 }
49 
50 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint64.
51 library BoringMath64 {
52     function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
53         require((c = a + b) >= b, "BoringMath: Add Overflow");
54     }
55 
56     function sub(uint64 a, uint64 b) internal pure returns (uint64 c) {
57         require((c = a - b) <= a, "BoringMath: Underflow");
58     }
59 }
60 
61 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.
62 library BoringMath32 {
63     function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
64         require((c = a + b) >= b, "BoringMath: Add Overflow");
65     }
66 
67     function sub(uint32 a, uint32 b) internal pure returns (uint32 c) {
68         require((c = a - b) <= a, "BoringMath: Underflow");
69     }
70 }
71 
72 // File @boringcrypto/boring-solidity/contracts/interfaces/IERC20.sol@v1.2.2
73 // License-Identifier: MIT
74 
75 interface IERC20 {
76     function totalSupply() external view returns (uint256);
77 
78     function balanceOf(address account) external view returns (uint256);
79 
80     function allowance(address owner, address spender) external view returns (uint256);
81 
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     event Transfer(address indexed from, address indexed to, uint256 value);
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 
87     /// @notice EIP 2612
88     function permit(
89         address owner,
90         address spender,
91         uint256 value,
92         uint256 deadline,
93         uint8 v,
94         bytes32 r,
95         bytes32 s
96     ) external;
97 }
98 
99 // File @boringcrypto/boring-solidity/contracts/libraries/BoringERC20.sol@v1.2.2
100 // License-Identifier: MIT
101 
102 // solhint-disable avoid-low-level-calls
103 
104 library BoringERC20 {
105     bytes4 private constant SIG_SYMBOL = 0x95d89b41; // symbol()
106     bytes4 private constant SIG_NAME = 0x06fdde03; // name()
107     bytes4 private constant SIG_DECIMALS = 0x313ce567; // decimals()
108     bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)
109     bytes4 private constant SIG_TRANSFER_FROM = 0x23b872dd; // transferFrom(address,address,uint256)
110 
111     function returnDataToString(bytes memory data) internal pure returns (string memory) {
112         if (data.length >= 64) {
113             return abi.decode(data, (string));
114         } else if (data.length == 32) {
115             uint8 i = 0;
116             while(i < 32 && data[i] != 0) {
117                 i++;
118             }
119             bytes memory bytesArray = new bytes(i);
120             for (i = 0; i < 32 && data[i] != 0; i++) {
121                 bytesArray[i] = data[i];
122             }
123             return string(bytesArray);
124         } else {
125             return "???";
126         }
127     }
128 
129     /// @notice Provides a safe ERC20.symbol version which returns '???' as fallback string.
130     /// @param token The address of the ERC-20 token contract.
131     /// @return (string) Token symbol.
132     function safeSymbol(IERC20 token) internal view returns (string memory) {
133         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_SYMBOL));
134         return success ? returnDataToString(data) : "???";
135     }
136 
137     /// @notice Provides a safe ERC20.name version which returns '???' as fallback string.
138     /// @param token The address of the ERC-20 token contract.
139     /// @return (string) Token name.
140     function safeName(IERC20 token) internal view returns (string memory) {
141         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_NAME));
142         return success ? returnDataToString(data) : "???";
143     }
144 
145     /// @notice Provides a safe ERC20.decimals version which returns '18' as fallback value.
146     /// @param token The address of the ERC-20 token contract.
147     /// @return (uint8) Token decimals.
148     function safeDecimals(IERC20 token) internal view returns (uint8) {
149         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_DECIMALS));
150         return success && data.length == 32 ? abi.decode(data, (uint8)) : 18;
151     }
152 
153     /// @notice Provides a safe ERC20.transfer version for different ERC-20 implementations.
154     /// Reverts on a failed transfer.
155     /// @param token The address of the ERC-20 token.
156     /// @param to Transfer tokens to.
157     /// @param amount The token amount.
158     function safeTransfer(
159         IERC20 token,
160         address to,
161         uint256 amount
162     ) internal {
163         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER, to, amount));
164         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: Transfer failed");
165     }
166 
167     /// @notice Provides a safe ERC20.transferFrom version for different ERC-20 implementations.
168     /// Reverts on a failed transfer.
169     /// @param token The address of the ERC-20 token.
170     /// @param from Transfer tokens from.
171     /// @param to Transfer tokens to.
172     /// @param amount The token amount.
173     function safeTransferFrom(
174         IERC20 token,
175         address from,
176         address to,
177         uint256 amount
178     ) internal {
179         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER_FROM, from, to, amount));
180         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: TransferFrom failed");
181     }
182 }
183 
184 // File @boringcrypto/boring-solidity/contracts/Domain.sol@v1.2.2
185 // License-Identifier: MIT
186 // Based on code and smartness by Ross Campbell and Keno
187 // Uses immutable to store the domain separator to reduce gas usage
188 // If the chain id changes due to a fork, the forked chain will calculate on the fly.
189 
190 // solhint-disable no-inline-assembly
191 
192 contract Domain {
193     bytes32 private constant DOMAIN_SEPARATOR_SIGNATURE_HASH = keccak256("EIP712Domain(uint256 chainId,address verifyingContract)");
194     // See https://eips.ethereum.org/EIPS/eip-191
195     string private constant EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA = "\x19\x01";
196 
197     // solhint-disable var-name-mixedcase
198     bytes32 private immutable _DOMAIN_SEPARATOR;
199     uint256 private immutable DOMAIN_SEPARATOR_CHAIN_ID;    
200 
201     /// @dev Calculate the DOMAIN_SEPARATOR
202     function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32) {
203         return keccak256(
204             abi.encode(
205                 DOMAIN_SEPARATOR_SIGNATURE_HASH,
206                 chainId,
207                 address(this)
208             )
209         );
210     }
211 
212     constructor() public {
213         uint256 chainId; assembly {chainId := chainid()}
214         _DOMAIN_SEPARATOR = _calculateDomainSeparator(DOMAIN_SEPARATOR_CHAIN_ID = chainId);
215     }
216 
217     /// @dev Return the DOMAIN_SEPARATOR
218     // It's named internal to allow making it public from the contract that uses it by creating a simple view function
219     // with the desired public name, such as DOMAIN_SEPARATOR or domainSeparator.
220     // solhint-disable-next-line func-name-mixedcase
221     function _domainSeparator() internal view returns (bytes32) {
222         uint256 chainId; assembly {chainId := chainid()}
223         return chainId == DOMAIN_SEPARATOR_CHAIN_ID ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId);
224     }
225 
226     function _getDigest(bytes32 dataHash) internal view returns (bytes32 digest) {
227         digest =
228             keccak256(
229                 abi.encodePacked(
230                     EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA,
231                     _domainSeparator(),
232                     dataHash
233                 )
234             );
235     }
236 }
237 
238 // File @boringcrypto/boring-solidity/contracts/ERC20.sol@v1.2.2
239 // License-Identifier: MIT
240 
241 // solhint-disable no-inline-assembly
242 // solhint-disable not-rely-on-time
243 
244 // Data part taken out for building of contracts that receive delegate calls
245 contract ERC20Data {
246     /// @notice owner > balance mapping.
247     mapping(address => uint256) public balanceOf;
248     /// @notice owner > spender > allowance mapping.
249     mapping(address => mapping(address => uint256)) public allowance;
250     /// @notice owner > nonce mapping. Used in `permit`.
251     mapping(address => uint256) public nonces;
252 }
253 
254 abstract contract ERC20 is IERC20, Domain {
255     /// @notice owner > balance mapping.
256     mapping(address => uint256) public override balanceOf;
257     /// @notice owner > spender > allowance mapping.
258     mapping(address => mapping(address => uint256)) public override allowance;
259     /// @notice owner > nonce mapping. Used in `permit`.
260     mapping(address => uint256) public nonces;
261 
262     event Transfer(address indexed _from, address indexed _to, uint256 _value);
263     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
264 
265     /// @notice Transfers `amount` tokens from `msg.sender` to `to`.
266     /// @param to The address to move the tokens.
267     /// @param amount of the tokens to move.
268     /// @return (bool) Returns True if succeeded.
269     function transfer(address to, uint256 amount) public returns (bool) {
270         // If `amount` is 0, or `msg.sender` is `to` nothing happens
271         if (amount != 0 || msg.sender == to) {
272             uint256 srcBalance = balanceOf[msg.sender];
273             require(srcBalance >= amount, "ERC20: balance too low");
274             if (msg.sender != to) {
275                 require(to != address(0), "ERC20: no zero address"); // Moved down so low balance calls safe some gas
276 
277                 balanceOf[msg.sender] = srcBalance - amount; // Underflow is checked
278                 balanceOf[to] += amount;
279             }
280         }
281         emit Transfer(msg.sender, to, amount);
282         return true;
283     }
284 
285     /// @notice Transfers `amount` tokens from `from` to `to`. Caller needs approval for `from`.
286     /// @param from Address to draw tokens from.
287     /// @param to The address to move the tokens.
288     /// @param amount The token amount to move.
289     /// @return (bool) Returns True if succeeded.
290     function transferFrom(
291         address from,
292         address to,
293         uint256 amount
294     ) public returns (bool) {
295         // If `amount` is 0, or `from` is `to` nothing happens
296         if (amount != 0) {
297             uint256 srcBalance = balanceOf[from];
298             require(srcBalance >= amount, "ERC20: balance too low");
299 
300             if (from != to) {
301                 uint256 spenderAllowance = allowance[from][msg.sender];
302                 // If allowance is infinite, don't decrease it to save on gas (breaks with EIP-20).
303                 if (spenderAllowance != type(uint256).max) {
304                     require(spenderAllowance >= amount, "ERC20: allowance too low");
305                     allowance[from][msg.sender] = spenderAllowance - amount; // Underflow is checked
306                 }
307                 require(to != address(0), "ERC20: no zero address"); // Moved down so other failed calls safe some gas
308 
309                 balanceOf[from] = srcBalance - amount; // Underflow is checked
310                 balanceOf[to] += amount;
311             }
312         }
313         emit Transfer(from, to, amount);
314         return true;
315     }
316 
317     /// @notice Approves `amount` from sender to be spend by `spender`.
318     /// @param spender Address of the party that can draw from msg.sender's account.
319     /// @param amount The maximum collective amount that `spender` can draw.
320     /// @return (bool) Returns True if approved.
321     function approve(address spender, uint256 amount) public override returns (bool) {
322         allowance[msg.sender][spender] = amount;
323         emit Approval(msg.sender, spender, amount);
324         return true;
325     }
326 
327     // solhint-disable-next-line func-name-mixedcase
328     function DOMAIN_SEPARATOR() external view returns (bytes32) {
329         return _domainSeparator();
330     }
331 
332     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
333     bytes32 private constant PERMIT_SIGNATURE_HASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
334 
335     /// @notice Approves `value` from `owner_` to be spend by `spender`.
336     /// @param owner_ Address of the owner.
337     /// @param spender The address of the spender that gets approved to draw from `owner_`.
338     /// @param value The maximum collective amount that `spender` can draw.
339     /// @param deadline This permit must be redeemed before this deadline (UTC timestamp in seconds).
340     function permit(
341         address owner_,
342         address spender,
343         uint256 value,
344         uint256 deadline,
345         uint8 v,
346         bytes32 r,
347         bytes32 s
348     ) external override {
349         require(owner_ != address(0), "ERC20: Owner cannot be 0");
350         require(block.timestamp < deadline, "ERC20: Expired");
351         require(
352             ecrecover(_getDigest(keccak256(abi.encode(PERMIT_SIGNATURE_HASH, owner_, spender, value, nonces[owner_]++, deadline))), v, r, s) ==
353                 owner_,
354             "ERC20: Invalid Signature"
355         );
356         allowance[owner_][spender] = value;
357         emit Approval(owner_, spender, value);
358     }
359 }
360 
361 contract ERC20WithSupply is IERC20, ERC20 {
362     uint256 public override totalSupply;
363 
364     function _mint(address user, uint256 amount) private {
365         uint256 newTotalSupply = totalSupply + amount;
366         require(newTotalSupply >= totalSupply, "Mint overflow");
367         totalSupply = newTotalSupply;
368         balanceOf[user] += amount;
369     }
370 
371     function _burn(address user, uint256 amount) private {
372         require(balanceOf[user] >= amount, "Burn too much");
373         totalSupply -= amount;
374         balanceOf[user] -= amount;
375     }
376 }
377 
378 // File @boringcrypto/boring-solidity/contracts/BoringBatchable.sol@v1.2.2
379 // License-Identifier: MIT
380 
381 // solhint-disable avoid-low-level-calls
382 // solhint-disable no-inline-assembly
383 
384 // Audit on 5-Jan-2021 by Keno and BoringCrypto
385 
386 contract BaseBoringBatchable {
387     /// @dev Helper function to extract a useful revert message from a failed call.
388     /// If the returned data is malformed or not correctly abi encoded then this call can fail itself.
389     function _getRevertMsg(bytes memory _returnData) internal pure returns (string memory) {
390         // If the _res length is less than 68, then the transaction failed silently (without a revert message)
391         if (_returnData.length < 68) return "Transaction reverted silently";
392 
393         assembly {
394             // Slice the sighash.
395             _returnData := add(_returnData, 0x04)
396         }
397         return abi.decode(_returnData, (string)); // All that remains is the revert string
398     }
399 
400     /// @notice Allows batched call to self (this contract).
401     /// @param calls An array of inputs for each call.
402     /// @param revertOnFail If True then reverts after a failed call and stops doing further calls.
403     // F1: External is ok here because this is the batch function, adding it to a batch makes no sense
404     // F2: Calls in the batch may be payable, delegatecall operates in the same context, so each call in the batch has access to msg.value
405     // C3: The length of the loop is fully under user control, so can't be exploited
406     // C7: Delegatecall is only used on the same contract, so it's safe
407     function batch(bytes[] calldata calls, bool revertOnFail) external payable {
408         for (uint256 i = 0; i < calls.length; i++) {
409             (bool success, bytes memory result) = address(this).delegatecall(calls[i]);
410             if (!success && revertOnFail) {
411                 revert(_getRevertMsg(result));
412             }
413         }
414     }
415 }
416 
417 contract BoringBatchable is BaseBoringBatchable {
418     /// @notice Call wrapper that performs `ERC20.permit` on `token`.
419     /// Lookup `IERC20.permit`.
420     // F6: Parameters can be used front-run the permit and the user's permit will fail (due to nonce or other revert)
421     //     if part of a batch this could be used to grief once as the second call would not need the permit
422     function permitToken(
423         IERC20 token,
424         address from,
425         address to,
426         uint256 amount,
427         uint256 deadline,
428         uint8 v,
429         bytes32 r,
430         bytes32 s
431     ) public {
432         token.permit(from, to, amount, deadline, v, r, s);
433     }
434 }
435 
436 // File contracts/sSpell.sol
437 //License-Identifier: MIT
438 
439 // Staking in sSpell inspired by Chef Nomi's SushiBar - MIT license (originally WTFPL)
440 // modified by BoringCrypto for DictatorDAO
441 
442 contract sSpellV1 is IERC20, Domain {
443     using BoringMath for uint256;
444     using BoringMath128 for uint128;
445     using BoringERC20 for IERC20;
446 
447     string public constant symbol = "sSPELL";
448     string public constant name = "Staked Spell Tokens";
449     uint8 public constant decimals = 18;
450     uint256 public override totalSupply;
451     uint256 private constant LOCK_TIME = 24 hours;
452 
453     IERC20 public immutable token;
454 
455     constructor(IERC20 _token) public {
456         token = _token;
457     }
458 
459     struct User {
460         uint128 balance;
461         uint128 lockedUntil;
462     }
463 
464     /// @notice owner > balance mapping.
465     mapping(address => User) public users;
466     /// @notice owner > spender > allowance mapping.
467     mapping(address => mapping(address => uint256)) public override allowance;
468     /// @notice owner > nonce mapping. Used in `permit`.
469     mapping(address => uint256) public nonces;
470 
471     event Transfer(address indexed _from, address indexed _to, uint256 _value);
472     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
473 
474     function balanceOf(address user) public view override returns (uint256 balance) {
475         return users[user].balance;
476     }
477 
478     function _transfer(
479         address from,
480         address to,
481         uint256 shares
482     ) internal {
483         User memory fromUser = users[from];
484         require(block.timestamp >= fromUser.lockedUntil, "Locked");
485         if (shares != 0) {
486             require(fromUser.balance >= shares, "Low balance");
487             if (from != to) {
488                 require(to != address(0), "Zero address"); // Moved down so other failed calls safe some gas
489                 User memory toUser = users[to];
490                 users[from].balance = fromUser.balance - shares.to128(); // Underflow is checked
491                 users[to].balance = toUser.balance + shares.to128(); // Can't overflow because totalSupply would be greater than 2^128-1;
492             }
493         }
494         emit Transfer(from, to, shares);
495     }
496 
497     function _useAllowance(address from, uint256 shares) internal {
498         if (msg.sender == from) {
499             return;
500         }
501         uint256 spenderAllowance = allowance[from][msg.sender];
502         // If allowance is infinite, don't decrease it to save on gas (breaks with EIP-20).
503         if (spenderAllowance != type(uint256).max) {
504             require(spenderAllowance >= shares, "Low allowance");
505             allowance[from][msg.sender] = spenderAllowance - shares; // Underflow is checked
506         }
507     }
508 
509     /// @notice Transfers `shares` tokens from `msg.sender` to `to`.
510     /// @param to The address to move the tokens.
511     /// @param shares of the tokens to move.
512     /// @return (bool) Returns True if succeeded.
513     function transfer(address to, uint256 shares) public returns (bool) {
514         _transfer(msg.sender, to, shares);
515         return true;
516     }
517 
518     /// @notice Transfers `shares` tokens from `from` to `to`. Caller needs approval for `from`.
519     /// @param from Address to draw tokens from.
520     /// @param to The address to move the tokens.
521     /// @param shares The token shares to move.
522     /// @return (bool) Returns True if succeeded.
523     function transferFrom(
524         address from,
525         address to,
526         uint256 shares
527     ) public returns (bool) {
528         _useAllowance(from, shares);
529         _transfer(from, to, shares);
530         return true;
531     }
532 
533     /// @notice Approves `amount` from sender to be spend by `spender`.
534     /// @param spender Address of the party that can draw from msg.sender's account.
535     /// @param amount The maximum collective amount that `spender` can draw.
536     /// @return (bool) Returns True if approved.
537     function approve(address spender, uint256 amount) public override returns (bool) {
538         allowance[msg.sender][spender] = amount;
539         emit Approval(msg.sender, spender, amount);
540         return true;
541     }
542 
543     // solhint-disable-next-line func-name-mixedcase
544     function DOMAIN_SEPARATOR() external view returns (bytes32) {
545         return _domainSeparator();
546     }
547 
548     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
549     bytes32 private constant PERMIT_SIGNATURE_HASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
550 
551     /// @notice Approves `value` from `owner_` to be spend by `spender`.
552     /// @param owner_ Address of the owner.
553     /// @param spender The address of the spender that gets approved to draw from `owner_`.
554     /// @param value The maximum collective amount that `spender` can draw.
555     /// @param deadline This permit must be redeemed before this deadline (UTC timestamp in seconds).
556     function permit(
557         address owner_,
558         address spender,
559         uint256 value,
560         uint256 deadline,
561         uint8 v,
562         bytes32 r,
563         bytes32 s
564     ) external override {
565         require(owner_ != address(0), "Zero owner");
566         require(block.timestamp < deadline, "Expired");
567         require(
568             ecrecover(_getDigest(keccak256(abi.encode(PERMIT_SIGNATURE_HASH, owner_, spender, value, nonces[owner_]++, deadline))), v, r, s) ==
569                 owner_,
570             "Invalid Sig"
571         );
572         allowance[owner_][spender] = value;
573         emit Approval(owner_, spender, value);
574     }
575 
576     /// math is ok, because amount, totalSupply and shares is always 0 <= amount <= 100.000.000 * 10^18
577     /// theoretically you can grow the amount/share ratio, but it's not practical and useless
578     function mint(uint256 amount) public returns (bool) {
579         require(msg.sender != address(0), "Zero address");
580         User memory user = users[msg.sender];
581 
582         uint256 totalTokens = token.balanceOf(address(this));
583         uint256 shares = totalSupply == 0 ? amount : (amount * totalSupply) / totalTokens;
584         user.balance += shares.to128();
585         user.lockedUntil = (block.timestamp + LOCK_TIME).to128();
586         users[msg.sender] = user;
587         totalSupply += shares;
588 
589         token.safeTransferFrom(msg.sender, address(this), amount);
590 
591         emit Transfer(address(0), msg.sender, shares);
592         return true;
593     }
594 
595     function _burn(
596         address from,
597         address to,
598         uint256 shares
599     ) internal {
600         require(to != address(0), "Zero address");
601         User memory user = users[from];
602         require(block.timestamp >= user.lockedUntil, "Locked");
603         uint256 amount = (shares * token.balanceOf(address(this))) / totalSupply;
604         users[from].balance = user.balance.sub(shares.to128()); // Must check underflow
605         totalSupply -= shares;
606 
607         token.safeTransfer(to, amount);
608 
609         emit Transfer(from, address(0), shares);
610     }
611 
612     function burn(address to, uint256 shares) public returns (bool) {
613         _burn(msg.sender, to, shares);
614         return true;
615     }
616 
617     function burnFrom(
618         address from,
619         address to,
620         uint256 shares
621     ) public returns (bool) {
622         _useAllowance(from, shares);
623         _burn(from, to, shares);
624         return true;
625     }
626 }