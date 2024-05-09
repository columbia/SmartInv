1 // SPDX-License-Identifier: MIXED
2 
3 // File @boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol@v1.2.2
4 // License-Identifier: MIT
5 pragma solidity 0.6.12;
6 
7 /// @notice A library for performing overflow-/underflow-safe math,
8 /// updated with awesomeness from of DappHub (https://github.com/dapphub/ds-math).
9 library BoringMath {
10     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
11         require((c = a + b) >= b, "BoringMath: Add Overflow");
12     }
13 
14     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
15         require((c = a - b) <= a, "BoringMath: Underflow");
16     }
17 
18     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
19         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
20     }
21 
22     function to128(uint256 a) internal pure returns (uint128 c) {
23         require(a <= uint128(-1), "BoringMath: uint128 Overflow");
24         c = uint128(a);
25     }
26 
27     function to64(uint256 a) internal pure returns (uint64 c) {
28         require(a <= uint64(-1), "BoringMath: uint64 Overflow");
29         c = uint64(a);
30     }
31 
32     function to32(uint256 a) internal pure returns (uint32 c) {
33         require(a <= uint32(-1), "BoringMath: uint32 Overflow");
34         c = uint32(a);
35     }
36 }
37 
38 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint128.
39 library BoringMath128 {
40     function add(uint128 a, uint128 b) internal pure returns (uint128 c) {
41         require((c = a + b) >= b, "BoringMath: Add Overflow");
42     }
43 
44     function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {
45         require((c = a - b) <= a, "BoringMath: Underflow");
46     }
47 }
48 
49 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint64.
50 library BoringMath64 {
51     function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
52         require((c = a + b) >= b, "BoringMath: Add Overflow");
53     }
54 
55     function sub(uint64 a, uint64 b) internal pure returns (uint64 c) {
56         require((c = a - b) <= a, "BoringMath: Underflow");
57     }
58 }
59 
60 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.
61 library BoringMath32 {
62     function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
63         require((c = a + b) >= b, "BoringMath: Add Overflow");
64     }
65 
66     function sub(uint32 a, uint32 b) internal pure returns (uint32 c) {
67         require((c = a - b) <= a, "BoringMath: Underflow");
68     }
69 }
70 
71 // File @boringcrypto/boring-solidity/contracts/BoringOwnable.sol@v1.2.2
72 // License-Identifier: MIT
73 pragma solidity 0.6.12;
74 
75 // Audit on 5-Jan-2021 by Keno and BoringCrypto
76 // Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol + Claimable.sol
77 // Edited by BoringCrypto
78 
79 contract BoringOwnableData {
80     address public owner;
81     address public pendingOwner;
82 }
83 
84 contract BoringOwnable is BoringOwnableData {
85     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
86 
87     /// @notice `owner` defaults to msg.sender on construction.
88     constructor() public {
89         owner = msg.sender;
90         emit OwnershipTransferred(address(0), msg.sender);
91     }
92 
93     /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.
94     /// Can only be invoked by the current `owner`.
95     /// @param newOwner Address of the new owner.
96     /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.
97     /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.
98     function transferOwnership(
99         address newOwner,
100         bool direct,
101         bool renounce
102     ) public onlyOwner {
103         if (direct) {
104             // Checks
105             require(newOwner != address(0) || renounce, "Ownable: zero address");
106 
107             // Effects
108             emit OwnershipTransferred(owner, newOwner);
109             owner = newOwner;
110             pendingOwner = address(0);
111         } else {
112             // Effects
113             pendingOwner = newOwner;
114         }
115     }
116 
117     /// @notice Needs to be called by `pendingOwner` to claim ownership.
118     function claimOwnership() public {
119         address _pendingOwner = pendingOwner;
120 
121         // Checks
122         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
123 
124         // Effects
125         emit OwnershipTransferred(owner, _pendingOwner);
126         owner = _pendingOwner;
127         pendingOwner = address(0);
128     }
129 
130     /// @notice Only allows the `owner` to execute the function.
131     modifier onlyOwner() {
132         require(msg.sender == owner, "Ownable: caller is not the owner");
133         _;
134     }
135 }
136 
137 // File @boringcrypto/boring-solidity/contracts/interfaces/IERC20.sol@v1.2.2
138 // License-Identifier: MIT
139 pragma solidity 0.6.12;
140 
141 interface IERC20 {
142     function totalSupply() external view returns (uint256);
143 
144     function balanceOf(address account) external view returns (uint256);
145 
146     function allowance(address owner, address spender) external view returns (uint256);
147 
148     function approve(address spender, uint256 amount) external returns (bool);
149 
150     event Transfer(address indexed from, address indexed to, uint256 value);
151     event Approval(address indexed owner, address indexed spender, uint256 value);
152 
153     /// @notice EIP 2612
154     function permit(
155         address owner,
156         address spender,
157         uint256 value,
158         uint256 deadline,
159         uint8 v,
160         bytes32 r,
161         bytes32 s
162     ) external;
163 }
164 
165 // File @boringcrypto/boring-solidity/contracts/Domain.sol@v1.2.2
166 // License-Identifier: MIT
167 // Based on code and smartness by Ross Campbell and Keno
168 // Uses immutable to store the domain separator to reduce gas usage
169 // If the chain id changes due to a fork, the forked chain will calculate on the fly.
170 pragma solidity 0.6.12;
171 
172 // solhint-disable no-inline-assembly
173 
174 contract Domain {
175     bytes32 private constant DOMAIN_SEPARATOR_SIGNATURE_HASH = keccak256("EIP712Domain(uint256 chainId,address verifyingContract)");
176     // See https://eips.ethereum.org/EIPS/eip-191
177     string private constant EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA = "\x19\x01";
178 
179     // solhint-disable var-name-mixedcase
180     bytes32 private immutable _DOMAIN_SEPARATOR;
181     uint256 private immutable DOMAIN_SEPARATOR_CHAIN_ID;    
182 
183     /// @dev Calculate the DOMAIN_SEPARATOR
184     function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32) {
185         return keccak256(
186             abi.encode(
187                 DOMAIN_SEPARATOR_SIGNATURE_HASH,
188                 chainId,
189                 address(this)
190             )
191         );
192     }
193 
194     constructor() public {
195         uint256 chainId; assembly {chainId := chainid()}
196         _DOMAIN_SEPARATOR = _calculateDomainSeparator(DOMAIN_SEPARATOR_CHAIN_ID = chainId);
197     }
198 
199     /// @dev Return the DOMAIN_SEPARATOR
200     // It's named internal to allow making it public from the contract that uses it by creating a simple view function
201     // with the desired public name, such as DOMAIN_SEPARATOR or domainSeparator.
202     // solhint-disable-next-line func-name-mixedcase
203     function _domainSeparator() internal view returns (bytes32) {
204         uint256 chainId; assembly {chainId := chainid()}
205         return chainId == DOMAIN_SEPARATOR_CHAIN_ID ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId);
206     }
207 
208     function _getDigest(bytes32 dataHash) internal view returns (bytes32 digest) {
209         digest =
210             keccak256(
211                 abi.encodePacked(
212                     EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA,
213                     _domainSeparator(),
214                     dataHash
215                 )
216             );
217     }
218 }
219 
220 // File @boringcrypto/boring-solidity/contracts/ERC20.sol@v1.2.2
221 // License-Identifier: MIT
222 pragma solidity 0.6.12;
223 
224 
225 // solhint-disable no-inline-assembly
226 // solhint-disable not-rely-on-time
227 
228 // Data part taken out for building of contracts that receive delegate calls
229 contract ERC20Data {
230     /// @notice owner > balance mapping.
231     mapping(address => uint256) public balanceOf;
232     /// @notice owner > spender > allowance mapping.
233     mapping(address => mapping(address => uint256)) public allowance;
234     /// @notice owner > nonce mapping. Used in `permit`.
235     mapping(address => uint256) public nonces;
236 }
237 
238 abstract contract ERC20 is IERC20, Domain {
239     /// @notice owner > balance mapping.
240     mapping(address => uint256) public override balanceOf;
241     /// @notice owner > spender > allowance mapping.
242     mapping(address => mapping(address => uint256)) public override allowance;
243     /// @notice owner > nonce mapping. Used in `permit`.
244     mapping(address => uint256) public nonces;
245 
246     event Transfer(address indexed _from, address indexed _to, uint256 _value);
247     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
248 
249     /// @notice Transfers `amount` tokens from `msg.sender` to `to`.
250     /// @param to The address to move the tokens.
251     /// @param amount of the tokens to move.
252     /// @return (bool) Returns True if succeeded.
253     function transfer(address to, uint256 amount) public returns (bool) {
254         // If `amount` is 0, or `msg.sender` is `to` nothing happens
255         if (amount != 0 || msg.sender == to) {
256             uint256 srcBalance = balanceOf[msg.sender];
257             require(srcBalance >= amount, "ERC20: balance too low");
258             if (msg.sender != to) {
259                 require(to != address(0), "ERC20: no zero address"); // Moved down so low balance calls safe some gas
260 
261                 balanceOf[msg.sender] = srcBalance - amount; // Underflow is checked
262                 balanceOf[to] += amount;
263             }
264         }
265         emit Transfer(msg.sender, to, amount);
266         return true;
267     }
268 
269     /// @notice Transfers `amount` tokens from `from` to `to`. Caller needs approval for `from`.
270     /// @param from Address to draw tokens from.
271     /// @param to The address to move the tokens.
272     /// @param amount The token amount to move.
273     /// @return (bool) Returns True if succeeded.
274     function transferFrom(
275         address from,
276         address to,
277         uint256 amount
278     ) public returns (bool) {
279         // If `amount` is 0, or `from` is `to` nothing happens
280         if (amount != 0) {
281             uint256 srcBalance = balanceOf[from];
282             require(srcBalance >= amount, "ERC20: balance too low");
283 
284             if (from != to) {
285                 uint256 spenderAllowance = allowance[from][msg.sender];
286                 // If allowance is infinite, don't decrease it to save on gas (breaks with EIP-20).
287                 if (spenderAllowance != type(uint256).max) {
288                     require(spenderAllowance >= amount, "ERC20: allowance too low");
289                     allowance[from][msg.sender] = spenderAllowance - amount; // Underflow is checked
290                 }
291                 require(to != address(0), "ERC20: no zero address"); // Moved down so other failed calls safe some gas
292 
293                 balanceOf[from] = srcBalance - amount; // Underflow is checked
294                 balanceOf[to] += amount;
295             }
296         }
297         emit Transfer(from, to, amount);
298         return true;
299     }
300 
301     /// @notice Approves `amount` from sender to be spend by `spender`.
302     /// @param spender Address of the party that can draw from msg.sender's account.
303     /// @param amount The maximum collective amount that `spender` can draw.
304     /// @return (bool) Returns True if approved.
305     function approve(address spender, uint256 amount) public override returns (bool) {
306         allowance[msg.sender][spender] = amount;
307         emit Approval(msg.sender, spender, amount);
308         return true;
309     }
310 
311     // solhint-disable-next-line func-name-mixedcase
312     function DOMAIN_SEPARATOR() external view returns (bytes32) {
313         return _domainSeparator();
314     }
315 
316     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
317     bytes32 private constant PERMIT_SIGNATURE_HASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
318 
319     /// @notice Approves `value` from `owner_` to be spend by `spender`.
320     /// @param owner_ Address of the owner.
321     /// @param spender The address of the spender that gets approved to draw from `owner_`.
322     /// @param value The maximum collective amount that `spender` can draw.
323     /// @param deadline This permit must be redeemed before this deadline (UTC timestamp in seconds).
324     function permit(
325         address owner_,
326         address spender,
327         uint256 value,
328         uint256 deadline,
329         uint8 v,
330         bytes32 r,
331         bytes32 s
332     ) external override {
333         require(owner_ != address(0), "ERC20: Owner cannot be 0");
334         require(block.timestamp < deadline, "ERC20: Expired");
335         require(
336             ecrecover(_getDigest(keccak256(abi.encode(PERMIT_SIGNATURE_HASH, owner_, spender, value, nonces[owner_]++, deadline))), v, r, s) ==
337                 owner_,
338             "ERC20: Invalid Signature"
339         );
340         allowance[owner_][spender] = value;
341         emit Approval(owner_, spender, value);
342     }
343 }
344 
345 contract ERC20WithSupply is IERC20, ERC20 {
346     uint256 public override totalSupply;
347 
348     function _mint(address user, uint256 amount) private {
349         uint256 newTotalSupply = totalSupply + amount;
350         require(newTotalSupply >= totalSupply, "Mint overflow");
351         totalSupply = newTotalSupply;
352         balanceOf[user] += amount;
353     }
354 
355     function _burn(address user, uint256 amount) private {
356         require(balanceOf[user] >= amount, "Burn too much");
357         totalSupply -= amount;
358         balanceOf[user] -= amount;
359     }
360 }
361 
362 // File @boringcrypto/boring-solidity/contracts/interfaces/IMasterContract.sol@v1.2.2
363 // License-Identifier: MIT
364 pragma solidity 0.6.12;
365 
366 interface IMasterContract {
367     /// @notice Init function that gets called from `BoringFactory.deploy`.
368     /// Also kown as the constructor for cloned contracts.
369     /// Any ETH send to `BoringFactory.deploy` ends up here.
370     /// @param data Can be abi encoded arguments or anything else.
371     function init(bytes calldata data) external payable;
372 }
373 
374 // File @boringcrypto/boring-solidity/contracts/libraries/BoringRebase.sol@v1.2.2
375 // License-Identifier: MIT
376 pragma solidity 0.6.12;
377 
378 struct Rebase {
379     uint128 elastic;
380     uint128 base;
381 }
382 
383 /// @notice A rebasing library using overflow-/underflow-safe math.
384 library RebaseLibrary {
385     using BoringMath for uint256;
386     using BoringMath128 for uint128;
387 
388     /// @notice Calculates the base value in relationship to `elastic` and `total`.
389     function toBase(
390         Rebase memory total,
391         uint256 elastic,
392         bool roundUp
393     ) internal pure returns (uint256 base) {
394         if (total.elastic == 0) {
395             base = elastic;
396         } else {
397             base = elastic.mul(total.base) / total.elastic;
398             if (roundUp && base.mul(total.elastic) / total.base < elastic) {
399                 base = base.add(1);
400             }
401         }
402     }
403 
404     /// @notice Calculates the elastic value in relationship to `base` and `total`.
405     function toElastic(
406         Rebase memory total,
407         uint256 base,
408         bool roundUp
409     ) internal pure returns (uint256 elastic) {
410         if (total.base == 0) {
411             elastic = base;
412         } else {
413             elastic = base.mul(total.elastic) / total.base;
414             if (roundUp && elastic.mul(total.base) / total.elastic < base) {
415                 elastic = elastic.add(1);
416             }
417         }
418     }
419 
420     /// @notice Add `elastic` to `total` and doubles `total.base`.
421     /// @return (Rebase) The new total.
422     /// @return base in relationship to `elastic`.
423     function add(
424         Rebase memory total,
425         uint256 elastic,
426         bool roundUp
427     ) internal pure returns (Rebase memory, uint256 base) {
428         base = toBase(total, elastic, roundUp);
429         total.elastic = total.elastic.add(elastic.to128());
430         total.base = total.base.add(base.to128());
431         return (total, base);
432     }
433 
434     /// @notice Sub `base` from `total` and update `total.elastic`.
435     /// @return (Rebase) The new total.
436     /// @return elastic in relationship to `base`.
437     function sub(
438         Rebase memory total,
439         uint256 base,
440         bool roundUp
441     ) internal pure returns (Rebase memory, uint256 elastic) {
442         elastic = toElastic(total, base, roundUp);
443         total.elastic = total.elastic.sub(elastic.to128());
444         total.base = total.base.sub(base.to128());
445         return (total, elastic);
446     }
447 
448     /// @notice Add `elastic` and `base` to `total`.
449     function add(
450         Rebase memory total,
451         uint256 elastic,
452         uint256 base
453     ) internal pure returns (Rebase memory) {
454         total.elastic = total.elastic.add(elastic.to128());
455         total.base = total.base.add(base.to128());
456         return total;
457     }
458 
459     /// @notice Subtract `elastic` and `base` to `total`.
460     function sub(
461         Rebase memory total,
462         uint256 elastic,
463         uint256 base
464     ) internal pure returns (Rebase memory) {
465         total.elastic = total.elastic.sub(elastic.to128());
466         total.base = total.base.sub(base.to128());
467         return total;
468     }
469 
470     /// @notice Add `elastic` to `total` and update storage.
471     /// @return newElastic Returns updated `elastic`.
472     function addElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {
473         newElastic = total.elastic = total.elastic.add(elastic.to128());
474     }
475 
476     /// @notice Subtract `elastic` from `total` and update storage.
477     /// @return newElastic Returns updated `elastic`.
478     function subElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {
479         newElastic = total.elastic = total.elastic.sub(elastic.to128());
480     }
481 }
482 
483 // File @boringcrypto/boring-solidity/contracts/libraries/BoringERC20.sol@v1.2.2
484 // License-Identifier: MIT
485 pragma solidity 0.6.12;
486 
487 // solhint-disable avoid-low-level-calls
488 
489 library BoringERC20 {
490     bytes4 private constant SIG_SYMBOL = 0x95d89b41; // symbol()
491     bytes4 private constant SIG_NAME = 0x06fdde03; // name()
492     bytes4 private constant SIG_DECIMALS = 0x313ce567; // decimals()
493     bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)
494     bytes4 private constant SIG_TRANSFER_FROM = 0x23b872dd; // transferFrom(address,address,uint256)
495 
496     function returnDataToString(bytes memory data) internal pure returns (string memory) {
497         if (data.length >= 64) {
498             return abi.decode(data, (string));
499         } else if (data.length == 32) {
500             uint8 i = 0;
501             while(i < 32 && data[i] != 0) {
502                 i++;
503             }
504             bytes memory bytesArray = new bytes(i);
505             for (i = 0; i < 32 && data[i] != 0; i++) {
506                 bytesArray[i] = data[i];
507             }
508             return string(bytesArray);
509         } else {
510             return "???";
511         }
512     }
513 
514     /// @notice Provides a safe ERC20.symbol version which returns '???' as fallback string.
515     /// @param token The address of the ERC-20 token contract.
516     /// @return (string) Token symbol.
517     function safeSymbol(IERC20 token) internal view returns (string memory) {
518         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_SYMBOL));
519         return success ? returnDataToString(data) : "???";
520     }
521 
522     /// @notice Provides a safe ERC20.name version which returns '???' as fallback string.
523     /// @param token The address of the ERC-20 token contract.
524     /// @return (string) Token name.
525     function safeName(IERC20 token) internal view returns (string memory) {
526         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_NAME));
527         return success ? returnDataToString(data) : "???";
528     }
529 
530     /// @notice Provides a safe ERC20.decimals version which returns '18' as fallback value.
531     /// @param token The address of the ERC-20 token contract.
532     /// @return (uint8) Token decimals.
533     function safeDecimals(IERC20 token) internal view returns (uint8) {
534         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_DECIMALS));
535         return success && data.length == 32 ? abi.decode(data, (uint8)) : 18;
536     }
537 
538     /// @notice Provides a safe ERC20.transfer version for different ERC-20 implementations.
539     /// Reverts on a failed transfer.
540     /// @param token The address of the ERC-20 token.
541     /// @param to Transfer tokens to.
542     /// @param amount The token amount.
543     function safeTransfer(
544         IERC20 token,
545         address to,
546         uint256 amount
547     ) internal {
548         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER, to, amount));
549         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: Transfer failed");
550     }
551 
552     /// @notice Provides a safe ERC20.transferFrom version for different ERC-20 implementations.
553     /// Reverts on a failed transfer.
554     /// @param token The address of the ERC-20 token.
555     /// @param from Transfer tokens from.
556     /// @param to Transfer tokens to.
557     /// @param amount The token amount.
558     function safeTransferFrom(
559         IERC20 token,
560         address from,
561         address to,
562         uint256 amount
563     ) internal {
564         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER_FROM, from, to, amount));
565         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: TransferFrom failed");
566     }
567 }
568 
569 // File @sushiswap/bentobox-sdk/contracts/IBatchFlashBorrower.sol@v1.0.2
570 // License-Identifier: MIT
571 pragma solidity 0.6.12;
572 
573 interface IBatchFlashBorrower {
574     function onBatchFlashLoan(
575         address sender,
576         IERC20[] calldata tokens,
577         uint256[] calldata amounts,
578         uint256[] calldata fees,
579         bytes calldata data
580     ) external;
581 }
582 
583 // File @sushiswap/bentobox-sdk/contracts/IFlashBorrower.sol@v1.0.2
584 // License-Identifier: MIT
585 pragma solidity 0.6.12;
586 
587 interface IFlashBorrower {
588     function onFlashLoan(
589         address sender,
590         IERC20 token,
591         uint256 amount,
592         uint256 fee,
593         bytes calldata data
594     ) external;
595 }
596 
597 // File @sushiswap/bentobox-sdk/contracts/IStrategy.sol@v1.0.2
598 // License-Identifier: MIT
599 pragma solidity 0.6.12;
600 
601 interface IStrategy {
602     // Send the assets to the Strategy and call skim to invest them
603     function skim(uint256 amount) external;
604 
605     // Harvest any profits made converted to the asset and pass them to the caller
606     function harvest(uint256 balance, address sender) external returns (int256 amountAdded);
607 
608     // Withdraw assets. The returned amount can differ from the requested amount due to rounding.
609     // The actualAmount should be very close to the amount. The difference should NOT be used to report a loss. That's what harvest is for.
610     function withdraw(uint256 amount) external returns (uint256 actualAmount);
611 
612     // Withdraw all assets in the safest way possible. This shouldn't fail.
613     function exit(uint256 balance) external returns (int256 amountAdded);
614 }
615 
616 // File @sushiswap/bentobox-sdk/contracts/IBentoBoxV1.sol@v1.0.2
617 // License-Identifier: MIT
618 pragma solidity 0.6.12;
619 pragma experimental ABIEncoderV2;
620 
621 
622 
623 
624 
625 interface IBentoBoxV1 {
626     event LogDeploy(address indexed masterContract, bytes data, address indexed cloneAddress);
627     event LogDeposit(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);
628     event LogFlashLoan(address indexed borrower, address indexed token, uint256 amount, uint256 feeAmount, address indexed receiver);
629     event LogRegisterProtocol(address indexed protocol);
630     event LogSetMasterContractApproval(address indexed masterContract, address indexed user, bool approved);
631     event LogStrategyDivest(address indexed token, uint256 amount);
632     event LogStrategyInvest(address indexed token, uint256 amount);
633     event LogStrategyLoss(address indexed token, uint256 amount);
634     event LogStrategyProfit(address indexed token, uint256 amount);
635     event LogStrategyQueued(address indexed token, address indexed strategy);
636     event LogStrategySet(address indexed token, address indexed strategy);
637     event LogStrategyTargetPercentage(address indexed token, uint256 targetPercentage);
638     event LogTransfer(address indexed token, address indexed from, address indexed to, uint256 share);
639     event LogWhiteListMasterContract(address indexed masterContract, bool approved);
640     event LogWithdraw(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);
641     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
642     function balanceOf(IERC20, address) external view returns (uint256);
643     function batch(bytes[] calldata calls, bool revertOnFail) external payable returns (bool[] memory successes, bytes[] memory results);
644     function batchFlashLoan(IBatchFlashBorrower borrower, address[] calldata receivers, IERC20[] calldata tokens, uint256[] calldata amounts, bytes calldata data) external;
645     function claimOwnership() external;
646     function deploy(address masterContract, bytes calldata data, bool useCreate2) external payable;
647     function deposit(IERC20 token_, address from, address to, uint256 amount, uint256 share) external payable returns (uint256 amountOut, uint256 shareOut);
648     function flashLoan(IFlashBorrower borrower, address receiver, IERC20 token, uint256 amount, bytes calldata data) external;
649     function harvest(IERC20 token, bool balance, uint256 maxChangeAmount) external;
650     function masterContractApproved(address, address) external view returns (bool);
651     function masterContractOf(address) external view returns (address);
652     function nonces(address) external view returns (uint256);
653     function owner() external view returns (address);
654     function pendingOwner() external view returns (address);
655     function pendingStrategy(IERC20) external view returns (IStrategy);
656     function permitToken(IERC20 token, address from, address to, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
657     function registerProtocol() external;
658     function setMasterContractApproval(address user, address masterContract, bool approved, uint8 v, bytes32 r, bytes32 s) external;
659     function setStrategy(IERC20 token, IStrategy newStrategy) external;
660     function setStrategyTargetPercentage(IERC20 token, uint64 targetPercentage_) external;
661     function strategy(IERC20) external view returns (IStrategy);
662     function strategyData(IERC20) external view returns (uint64 strategyStartDate, uint64 targetPercentage, uint128 balance);
663     function toAmount(IERC20 token, uint256 share, bool roundUp) external view returns (uint256 amount);
664     function toShare(IERC20 token, uint256 amount, bool roundUp) external view returns (uint256 share);
665     function totals(IERC20) external view returns (Rebase memory totals_);
666     function transfer(IERC20 token, address from, address to, uint256 share) external;
667     function transferMultiple(IERC20 token, address from, address[] calldata tos, uint256[] calldata shares) external;
668     function transferOwnership(address newOwner, bool direct, bool renounce) external;
669     function whitelistMasterContract(address masterContract, bool approved) external;
670     function whitelistedMasterContracts(address) external view returns (bool);
671     function withdraw(IERC20 token_, address from, address to, uint256 amount, uint256 share) external returns (uint256 amountOut, uint256 shareOut);
672 }
673 
674 // File contracts/MagicInternetMoney.sol
675 // License-Identifier: MIT
676 
677 // Magic Internet Money
678 
679 // ███╗   ███╗██╗███╗   ███╗
680 // ████╗ ████║██║████╗ ████║
681 // ██╔████╔██║██║██╔████╔██║
682 // ██║╚██╔╝██║██║██║╚██╔╝██║
683 // ██║ ╚═╝ ██║██║██║ ╚═╝ ██║
684 // ╚═╝     ╚═╝╚═╝╚═╝     ╚═╝
685 
686 // BoringCrypto, 0xMerlin
687 
688 pragma solidity 0.6.12;
689 /// @title Cauldron
690 /// @dev This contract allows contract calls to any contract (except BentoBox)
691 /// from arbitrary callers thus, don't trust calls from this contract in any circumstances.
692 contract MagicInternetMoney is ERC20, BoringOwnable {
693     using BoringMath for uint256;
694     // ERC20 'variables'
695     string public constant symbol = "MIM";
696     string public constant name = "Magic Internet Money";
697     uint8 public constant decimals = 18;
698     uint256 public override totalSupply;
699 
700     struct Minting {
701         uint128 time;
702         uint128 amount;
703     }
704 
705     Minting public lastMint;
706     uint256 private constant MINTING_PERIOD = 24 hours;
707     uint256 private constant MINTING_INCREASE = 15000;
708     uint256 private constant MINTING_PRECISION = 1e5;
709 
710     function mint(address to, uint256 amount) public onlyOwner {
711         require(to != address(0), "MIM: no mint to zero address");
712 
713         // Limits the amount minted per period to a convergence function, with the period duration restarting on every mint
714         uint256 totalMintedAmount = uint256(lastMint.time < block.timestamp - MINTING_PERIOD ? 0 : lastMint.amount).add(amount);
715         require(totalSupply == 0 || totalSupply.mul(MINTING_INCREASE) / MINTING_PRECISION >= totalMintedAmount);
716 
717         lastMint.time = block.timestamp.to128();
718         lastMint.amount = totalMintedAmount.to128();
719 
720         totalSupply = totalSupply + amount;
721         balanceOf[to] += amount;
722         emit Transfer(address(0), to, amount);
723     }
724 
725     function mintToBentoBox(address clone, uint256 amount, IBentoBoxV1 bentoBox) public onlyOwner {
726         mint(address(bentoBox), amount);
727         bentoBox.deposit(IERC20(address(this)), address(bentoBox), clone, amount, 0);
728     }
729 
730     function burn(uint256 amount) public {
731         require(amount <= balanceOf[msg.sender], "MIM: not enough");
732 
733         balanceOf[msg.sender] -= amount;
734         totalSupply -= amount;
735         emit Transfer(msg.sender, address(0), amount);
736     }
737 }
738 
739 // File contracts/interfaces/IOracle.sol
740 // License-Identifier: MIT
741 pragma solidity 0.6.12;
742 
743 interface IOracle {
744     /// @notice Get the latest exchange rate.
745     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
746     /// For example:
747     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
748     /// @return success if no valid (recent) rate is available, return false else true.
749     /// @return rate The rate of the requested asset / pair / pool.
750     function get(bytes calldata data) external returns (bool success, uint256 rate);
751 
752     /// @notice Check the last exchange rate without any state changes.
753     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
754     /// For example:
755     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
756     /// @return success if no valid (recent) rate is available, return false else true.
757     /// @return rate The rate of the requested asset / pair / pool.
758     function peek(bytes calldata data) external view returns (bool success, uint256 rate);
759 
760     /// @notice Check the current spot exchange rate without any state changes. For oracles like TWAP this will be different from peek().
761     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
762     /// For example:
763     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
764     /// @return rate The rate of the requested asset / pair / pool.
765     function peekSpot(bytes calldata data) external view returns (uint256 rate);
766 
767     /// @notice Returns a human readable (short) name about this oracle.
768     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
769     /// For example:
770     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
771     /// @return (string) A human readable symbol name about this oracle.
772     function symbol(bytes calldata data) external view returns (string memory);
773 
774     /// @notice Returns a human readable name about this oracle.
775     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
776     /// For example:
777     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
778     /// @return (string) A human readable name about this oracle.
779     function name(bytes calldata data) external view returns (string memory);
780 }
781 
782 // File contracts/interfaces/ISwapper.sol
783 // License-Identifier: MIT
784 pragma solidity 0.6.12;
785 
786 interface ISwapper {
787     /// @notice Withdraws 'amountFrom' of token 'from' from the BentoBox account for this swapper.
788     /// Swaps it for at least 'amountToMin' of token 'to'.
789     /// Transfers the swapped tokens of 'to' into the BentoBox using a plain ERC20 transfer.
790     /// Returns the amount of tokens 'to' transferred to BentoBox.
791     /// (The BentoBox skim function will be used by the caller to get the swapped funds).
792     function swap(
793         IERC20 fromToken,
794         IERC20 toToken,
795         address recipient,
796         uint256 shareToMin,
797         uint256 shareFrom
798     ) external returns (uint256 extraShare, uint256 shareReturned);
799 
800     /// @notice Calculates the amount of token 'from' needed to complete the swap (amountFrom),
801     /// this should be less than or equal to amountFromMax.
802     /// Withdraws 'amountFrom' of token 'from' from the BentoBox account for this swapper.
803     /// Swaps it for exactly 'exactAmountTo' of token 'to'.
804     /// Transfers the swapped tokens of 'to' into the BentoBox using a plain ERC20 transfer.
805     /// Transfers allocated, but unused 'from' tokens within the BentoBox to 'refundTo' (amountFromMax - amountFrom).
806     /// Returns the amount of 'from' tokens withdrawn from BentoBox (amountFrom).
807     /// (The BentoBox skim function will be used by the caller to get the swapped funds).
808     function swapExact(
809         IERC20 fromToken,
810         IERC20 toToken,
811         address recipient,
812         address refundTo,
813         uint256 shareFromSupplied,
814         uint256 shareToExact
815     ) external returns (uint256 shareUsed, uint256 shareReturned);
816 }
817 
818 // File contracts/CauldronV2.sol
819 // License-Identifier: UNLICENSED
820 
821 // Cauldron
822 
823 //    (                (   (
824 //    )\      )    (   )\  )\ )  (
825 //  (((_)  ( /(   ))\ ((_)(()/(  )(    (    (
826 //  )\___  )(_)) /((_) _   ((_))(()\   )\   )\ )
827 // ((/ __|((_)_ (_))( | |  _| |  ((_) ((_) _(_/(
828 //  | (__ / _` || || || |/ _` | | '_|/ _ \| ' \))
829 //   \___|\__,_| \_,_||_|\__,_| |_|  \___/|_||_|
830 
831 // Copyright (c) 2021 BoringCrypto - All rights reserved
832 // Twitter: @Boring_Crypto
833 
834 // Special thanks to:
835 // @0xKeno - for all his invaluable contributions
836 // @burger_crypto - for the idea of trying to let the LPs benefit from liquidations
837 
838 pragma solidity 0.6.12;
839 // solhint-disable avoid-low-level-calls
840 // solhint-disable no-inline-assembly
841 
842 /// @title Cauldron
843 /// @dev This contract allows contract calls to any contract (except BentoBox)
844 /// from arbitrary callers thus, don't trust calls from this contract in any circumstances.
845 contract CauldronV2Flat is BoringOwnable, IMasterContract {
846     using BoringMath for uint256;
847     using BoringMath128 for uint128;
848     using RebaseLibrary for Rebase;
849     using BoringERC20 for IERC20;
850 
851     event LogExchangeRate(uint256 rate);
852     event LogAccrue(uint128 accruedAmount);
853     event LogAddCollateral(address indexed from, address indexed to, uint256 share);
854     event LogRemoveCollateral(address indexed from, address indexed to, uint256 share);
855     event LogBorrow(address indexed from, address indexed to, uint256 amount, uint256 part);
856     event LogRepay(address indexed from, address indexed to, uint256 amount, uint256 part);
857     event LogFeeTo(address indexed newFeeTo);
858     event LogWithdrawFees(address indexed feeTo, uint256 feesEarnedFraction);
859 
860     // Immutables (for MasterContract and all clones)
861     IBentoBoxV1 public immutable bentoBox;
862     CauldronV2Flat public immutable masterContract;
863     IERC20 public immutable magicInternetMoney;
864 
865     // MasterContract variables
866     address public feeTo;
867 
868     // Per clone variables
869     // Clone init settings
870     IERC20 public collateral;
871     IOracle public oracle;
872     bytes public oracleData;
873 
874     // Total amounts
875     uint256 public totalCollateralShare; // Total collateral supplied
876     Rebase public totalBorrow; // elastic = Total token amount to be repayed by borrowers, base = Total parts of the debt held by borrowers
877 
878     // User balances
879     mapping(address => uint256) public userCollateralShare;
880     mapping(address => uint256) public userBorrowPart;
881 
882     /// @notice Exchange and interest rate tracking.
883     /// This is 'cached' here because calls to Oracles can be very expensive.
884     uint256 public exchangeRate;
885 
886     struct AccrueInfo {
887         uint64 lastAccrued;
888         uint128 feesEarned;
889         uint64 INTEREST_PER_SECOND;
890     }
891 
892     AccrueInfo public accrueInfo;
893 
894     // Settings
895     uint256 public COLLATERIZATION_RATE;
896     uint256 private constant COLLATERIZATION_RATE_PRECISION = 1e5; // Must be less than EXCHANGE_RATE_PRECISION (due to optimization in math)
897 
898     uint256 private constant EXCHANGE_RATE_PRECISION = 1e18;
899 
900     uint256 public LIQUIDATION_MULTIPLIER; 
901     uint256 private constant LIQUIDATION_MULTIPLIER_PRECISION = 1e5;
902 
903     uint256 public BORROW_OPENING_FEE;
904     uint256 private constant BORROW_OPENING_FEE_PRECISION = 1e5;
905 
906     uint256 private constant DISTRIBUTION_PART = 10;
907     uint256 private constant DISTRIBUTION_PRECISION = 100;
908 
909     /// @notice The constructor is only used for the initial master contract. Subsequent clones are initialised via `init`.
910     constructor(IBentoBoxV1 bentoBox_, IERC20 magicInternetMoney_) public {
911         bentoBox = bentoBox_;
912         magicInternetMoney = magicInternetMoney_;
913         masterContract = this;
914     }
915 
916     /// @notice Serves as the constructor for clones, as clones can't have a regular constructor
917     /// @dev `data` is abi encoded in the format: (IERC20 collateral, IERC20 asset, IOracle oracle, bytes oracleData)
918     function init(bytes calldata data) public payable override {
919         require(address(collateral) == address(0), "Cauldron: already initialized");
920         (collateral, oracle, oracleData, accrueInfo.INTEREST_PER_SECOND, LIQUIDATION_MULTIPLIER, COLLATERIZATION_RATE, BORROW_OPENING_FEE) = abi.decode(data, (IERC20, IOracle, bytes, uint64, uint256, uint256, uint256));
921         require(address(collateral) != address(0), "Cauldron: bad pair");
922     }
923 
924     /// @notice Accrues the interest on the borrowed tokens and handles the accumulation of fees.
925     function accrue() public {
926         AccrueInfo memory _accrueInfo = accrueInfo;
927         // Number of seconds since accrue was called
928         uint256 elapsedTime = block.timestamp - _accrueInfo.lastAccrued;
929         if (elapsedTime == 0) {
930             return;
931         }
932         _accrueInfo.lastAccrued = uint64(block.timestamp);
933 
934         Rebase memory _totalBorrow = totalBorrow;
935         if (_totalBorrow.base == 0) {
936             accrueInfo = _accrueInfo;
937             return;
938         }
939 
940         // Accrue interest
941         uint128 extraAmount = (uint256(_totalBorrow.elastic).mul(_accrueInfo.INTEREST_PER_SECOND).mul(elapsedTime) / 1e18).to128();
942         _totalBorrow.elastic = _totalBorrow.elastic.add(extraAmount);
943 
944         _accrueInfo.feesEarned = _accrueInfo.feesEarned.add(extraAmount);
945         totalBorrow = _totalBorrow;
946         accrueInfo = _accrueInfo;
947 
948         emit LogAccrue(extraAmount);
949     }
950 
951     /// @notice Concrete implementation of `isSolvent`. Includes a third parameter to allow caching `exchangeRate`.
952     /// @param _exchangeRate The exchange rate. Used to cache the `exchangeRate` between calls.
953     function _isSolvent(address user, uint256 _exchangeRate) internal view returns (bool) {
954         // accrue must have already been called!
955         uint256 borrowPart = userBorrowPart[user];
956         if (borrowPart == 0) return true;
957         uint256 collateralShare = userCollateralShare[user];
958         if (collateralShare == 0) return false;
959 
960         Rebase memory _totalBorrow = totalBorrow;
961 
962         return
963             bentoBox.toAmount(
964                 collateral,
965                 collateralShare.mul(EXCHANGE_RATE_PRECISION / COLLATERIZATION_RATE_PRECISION).mul(COLLATERIZATION_RATE),
966                 false
967             ) >=
968             // Moved exchangeRate here instead of dividing the other side to preserve more precision
969             borrowPart.mul(_totalBorrow.elastic).mul(_exchangeRate) / _totalBorrow.base;
970     }
971 
972     /// @dev Checks if the user is solvent in the closed liquidation case at the end of the function body.
973     modifier solvent() {
974         _;
975         require(_isSolvent(msg.sender, exchangeRate), "Cauldron: user insolvent");
976     }
977 
978     /// @notice Gets the exchange rate. I.e how much collateral to buy 1e18 asset.
979     /// This function is supposed to be invoked if needed because Oracle queries can be expensive.
980     /// @return updated True if `exchangeRate` was updated.
981     /// @return rate The new exchange rate.
982     function updateExchangeRate() public returns (bool updated, uint256 rate) {
983         (updated, rate) = oracle.get(oracleData);
984 
985         if (updated) {
986             exchangeRate = rate;
987             emit LogExchangeRate(rate);
988         } else {
989             // Return the old rate if fetching wasn't successful
990             rate = exchangeRate;
991         }
992     }
993 
994     /// @dev Helper function to move tokens.
995     /// @param token The ERC-20 token.
996     /// @param share The amount in shares to add.
997     /// @param total Grand total amount to deduct from this contract's balance. Only applicable if `skim` is True.
998     /// Only used for accounting checks.
999     /// @param skim If True, only does a balance check on this contract.
1000     /// False if tokens from msg.sender in `bentoBox` should be transferred.
1001     function _addTokens(
1002         IERC20 token,
1003         uint256 share,
1004         uint256 total,
1005         bool skim
1006     ) internal {
1007         if (skim) {
1008             require(share <= bentoBox.balanceOf(token, address(this)).sub(total), "Cauldron: Skim too much");
1009         } else {
1010             bentoBox.transfer(token, msg.sender, address(this), share);
1011         }
1012     }
1013 
1014     /// @notice Adds `collateral` from msg.sender to the account `to`.
1015     /// @param to The receiver of the tokens.
1016     /// @param skim True if the amount should be skimmed from the deposit balance of msg.sender.x
1017     /// False if tokens from msg.sender in `bentoBox` should be transferred.
1018     /// @param share The amount of shares to add for `to`.
1019     function addCollateral(
1020         address to,
1021         bool skim,
1022         uint256 share
1023     ) public {
1024         userCollateralShare[to] = userCollateralShare[to].add(share);
1025         uint256 oldTotalCollateralShare = totalCollateralShare;
1026         totalCollateralShare = oldTotalCollateralShare.add(share);
1027         _addTokens(collateral, share, oldTotalCollateralShare, skim);
1028         emit LogAddCollateral(skim ? address(bentoBox) : msg.sender, to, share);
1029     }
1030 
1031     /// @dev Concrete implementation of `removeCollateral`.
1032     function _removeCollateral(address to, uint256 share) internal {
1033         userCollateralShare[msg.sender] = userCollateralShare[msg.sender].sub(share);
1034         totalCollateralShare = totalCollateralShare.sub(share);
1035         emit LogRemoveCollateral(msg.sender, to, share);
1036         bentoBox.transfer(collateral, address(this), to, share);
1037     }
1038 
1039     /// @notice Removes `share` amount of collateral and transfers it to `to`.
1040     /// @param to The receiver of the shares.
1041     /// @param share Amount of shares to remove.
1042     function removeCollateral(address to, uint256 share) public solvent {
1043         // accrue must be called because we check solvency
1044         accrue();
1045         _removeCollateral(to, share);
1046     }
1047 
1048     /// @dev Concrete implementation of `borrow`.
1049     function _borrow(address to, uint256 amount) internal returns (uint256 part, uint256 share) {
1050         uint256 feeAmount = amount.mul(BORROW_OPENING_FEE) / BORROW_OPENING_FEE_PRECISION; // A flat % fee is charged for any borrow
1051         (totalBorrow, part) = totalBorrow.add(amount.add(feeAmount), true);
1052         accrueInfo.feesEarned = accrueInfo.feesEarned.add(uint128(feeAmount));
1053         userBorrowPart[msg.sender] = userBorrowPart[msg.sender].add(part);
1054 
1055         // As long as there are tokens on this contract you can 'mint'... this enables limiting borrows
1056         share = bentoBox.toShare(magicInternetMoney, amount, false);
1057         bentoBox.transfer(magicInternetMoney, address(this), to, share);
1058 
1059         emit LogBorrow(msg.sender, to, amount.add(feeAmount), part);
1060     }
1061 
1062     /// @notice Sender borrows `amount` and transfers it to `to`.
1063     /// @return part Total part of the debt held by borrowers.
1064     /// @return share Total amount in shares borrowed.
1065     function borrow(address to, uint256 amount) public solvent returns (uint256 part, uint256 share) {
1066         accrue();
1067         (part, share) = _borrow(to, amount);
1068     }
1069 
1070     /// @dev Concrete implementation of `repay`.
1071     function _repay(
1072         address to,
1073         bool skim,
1074         uint256 part
1075     ) internal returns (uint256 amount) {
1076         (totalBorrow, amount) = totalBorrow.sub(part, true);
1077         userBorrowPart[to] = userBorrowPart[to].sub(part);
1078 
1079         uint256 share = bentoBox.toShare(magicInternetMoney, amount, true);
1080         bentoBox.transfer(magicInternetMoney, skim ? address(bentoBox) : msg.sender, address(this), share);
1081         emit LogRepay(skim ? address(bentoBox) : msg.sender, to, amount, part);
1082     }
1083 
1084     /// @notice Repays a loan.
1085     /// @param to Address of the user this payment should go.
1086     /// @param skim True if the amount should be skimmed from the deposit balance of msg.sender.
1087     /// False if tokens from msg.sender in `bentoBox` should be transferred.
1088     /// @param part The amount to repay. See `userBorrowPart`.
1089     /// @return amount The total amount repayed.
1090     function repay(
1091         address to,
1092         bool skim,
1093         uint256 part
1094     ) public returns (uint256 amount) {
1095         accrue();
1096         amount = _repay(to, skim, part);
1097     }
1098 
1099     // Functions that need accrue to be called
1100     uint8 internal constant ACTION_REPAY = 2;
1101     uint8 internal constant ACTION_REMOVE_COLLATERAL = 4;
1102     uint8 internal constant ACTION_BORROW = 5;
1103     uint8 internal constant ACTION_GET_REPAY_SHARE = 6;
1104     uint8 internal constant ACTION_GET_REPAY_PART = 7;
1105     uint8 internal constant ACTION_ACCRUE = 8;
1106 
1107     // Functions that don't need accrue to be called
1108     uint8 internal constant ACTION_ADD_COLLATERAL = 10;
1109     uint8 internal constant ACTION_UPDATE_EXCHANGE_RATE = 11;
1110 
1111     // Function on BentoBox
1112     uint8 internal constant ACTION_BENTO_DEPOSIT = 20;
1113     uint8 internal constant ACTION_BENTO_WITHDRAW = 21;
1114     uint8 internal constant ACTION_BENTO_TRANSFER = 22;
1115     uint8 internal constant ACTION_BENTO_TRANSFER_MULTIPLE = 23;
1116     uint8 internal constant ACTION_BENTO_SETAPPROVAL = 24;
1117 
1118     // Any external call (except to BentoBox)
1119     uint8 internal constant ACTION_CALL = 30;
1120 
1121     int256 internal constant USE_VALUE1 = -1;
1122     int256 internal constant USE_VALUE2 = -2;
1123 
1124     /// @dev Helper function for choosing the correct value (`value1` or `value2`) depending on `inNum`.
1125     function _num(
1126         int256 inNum,
1127         uint256 value1,
1128         uint256 value2
1129     ) internal pure returns (uint256 outNum) {
1130         outNum = inNum >= 0 ? uint256(inNum) : (inNum == USE_VALUE1 ? value1 : value2);
1131     }
1132 
1133     /// @dev Helper function for depositing into `bentoBox`.
1134     function _bentoDeposit(
1135         bytes memory data,
1136         uint256 value,
1137         uint256 value1,
1138         uint256 value2
1139     ) internal returns (uint256, uint256) {
1140         (IERC20 token, address to, int256 amount, int256 share) = abi.decode(data, (IERC20, address, int256, int256));
1141         amount = int256(_num(amount, value1, value2)); // Done this way to avoid stack too deep errors
1142         share = int256(_num(share, value1, value2));
1143         return bentoBox.deposit{value: value}(token, msg.sender, to, uint256(amount), uint256(share));
1144     }
1145 
1146     /// @dev Helper function to withdraw from the `bentoBox`.
1147     function _bentoWithdraw(
1148         bytes memory data,
1149         uint256 value1,
1150         uint256 value2
1151     ) internal returns (uint256, uint256) {
1152         (IERC20 token, address to, int256 amount, int256 share) = abi.decode(data, (IERC20, address, int256, int256));
1153         return bentoBox.withdraw(token, msg.sender, to, _num(amount, value1, value2), _num(share, value1, value2));
1154     }
1155 
1156     /// @dev Helper function to perform a contract call and eventually extracting revert messages on failure.
1157     /// Calls to `bentoBox` are not allowed for obvious security reasons.
1158     /// This also means that calls made from this contract shall *not* be trusted.
1159     function _call(
1160         uint256 value,
1161         bytes memory data,
1162         uint256 value1,
1163         uint256 value2
1164     ) internal returns (bytes memory, uint8) {
1165         (address callee, bytes memory callData, bool useValue1, bool useValue2, uint8 returnValues) =
1166             abi.decode(data, (address, bytes, bool, bool, uint8));
1167 
1168         if (useValue1 && !useValue2) {
1169             callData = abi.encodePacked(callData, value1);
1170         } else if (!useValue1 && useValue2) {
1171             callData = abi.encodePacked(callData, value2);
1172         } else if (useValue1 && useValue2) {
1173             callData = abi.encodePacked(callData, value1, value2);
1174         }
1175 
1176         require(callee != address(bentoBox) && callee != address(this), "Cauldron: can't call");
1177 
1178         (bool success, bytes memory returnData) = callee.call{value: value}(callData);
1179         require(success, "Cauldron: call failed");
1180         return (returnData, returnValues);
1181     }
1182 
1183     struct CookStatus {
1184         bool needsSolvencyCheck;
1185         bool hasAccrued;
1186     }
1187 
1188     /// @notice Executes a set of actions and allows composability (contract calls) to other contracts.
1189     /// @param actions An array with a sequence of actions to execute (see ACTION_ declarations).
1190     /// @param values A one-to-one mapped array to `actions`. ETH amounts to send along with the actions.
1191     /// Only applicable to `ACTION_CALL`, `ACTION_BENTO_DEPOSIT`.
1192     /// @param datas A one-to-one mapped array to `actions`. Contains abi encoded data of function arguments.
1193     /// @return value1 May contain the first positioned return value of the last executed action (if applicable).
1194     /// @return value2 May contain the second positioned return value of the last executed action which returns 2 values (if applicable).
1195     function cook(
1196         uint8[] calldata actions,
1197         uint256[] calldata values,
1198         bytes[] calldata datas
1199     ) external payable returns (uint256 value1, uint256 value2) {
1200         CookStatus memory status;
1201         for (uint256 i = 0; i < actions.length; i++) {
1202             uint8 action = actions[i];
1203             if (!status.hasAccrued && action < 10) {
1204                 accrue();
1205                 status.hasAccrued = true;
1206             }
1207             if (action == ACTION_ADD_COLLATERAL) {
1208                 (int256 share, address to, bool skim) = abi.decode(datas[i], (int256, address, bool));
1209                 addCollateral(to, skim, _num(share, value1, value2));
1210             } else if (action == ACTION_REPAY) {
1211                 (int256 part, address to, bool skim) = abi.decode(datas[i], (int256, address, bool));
1212                 _repay(to, skim, _num(part, value1, value2));
1213             } else if (action == ACTION_REMOVE_COLLATERAL) {
1214                 (int256 share, address to) = abi.decode(datas[i], (int256, address));
1215                 _removeCollateral(to, _num(share, value1, value2));
1216                 status.needsSolvencyCheck = true;
1217             } else if (action == ACTION_BORROW) {
1218                 (int256 amount, address to) = abi.decode(datas[i], (int256, address));
1219                 (value1, value2) = _borrow(to, _num(amount, value1, value2));
1220                 status.needsSolvencyCheck = true;
1221             } else if (action == ACTION_UPDATE_EXCHANGE_RATE) {
1222                 (bool must_update, uint256 minRate, uint256 maxRate) = abi.decode(datas[i], (bool, uint256, uint256));
1223                 (bool updated, uint256 rate) = updateExchangeRate();
1224                 require((!must_update || updated) && rate > minRate && (maxRate == 0 || rate > maxRate), "Cauldron: rate not ok");
1225             } else if (action == ACTION_BENTO_SETAPPROVAL) {
1226                 (address user, address _masterContract, bool approved, uint8 v, bytes32 r, bytes32 s) =
1227                     abi.decode(datas[i], (address, address, bool, uint8, bytes32, bytes32));
1228                 bentoBox.setMasterContractApproval(user, _masterContract, approved, v, r, s);
1229             } else if (action == ACTION_BENTO_DEPOSIT) {
1230                 (value1, value2) = _bentoDeposit(datas[i], values[i], value1, value2);
1231             } else if (action == ACTION_BENTO_WITHDRAW) {
1232                 (value1, value2) = _bentoWithdraw(datas[i], value1, value2);
1233             } else if (action == ACTION_BENTO_TRANSFER) {
1234                 (IERC20 token, address to, int256 share) = abi.decode(datas[i], (IERC20, address, int256));
1235                 bentoBox.transfer(token, msg.sender, to, _num(share, value1, value2));
1236             } else if (action == ACTION_BENTO_TRANSFER_MULTIPLE) {
1237                 (IERC20 token, address[] memory tos, uint256[] memory shares) = abi.decode(datas[i], (IERC20, address[], uint256[]));
1238                 bentoBox.transferMultiple(token, msg.sender, tos, shares);
1239             } else if (action == ACTION_CALL) {
1240                 (bytes memory returnData, uint8 returnValues) = _call(values[i], datas[i], value1, value2);
1241 
1242                 if (returnValues == 1) {
1243                     (value1) = abi.decode(returnData, (uint256));
1244                 } else if (returnValues == 2) {
1245                     (value1, value2) = abi.decode(returnData, (uint256, uint256));
1246                 }
1247             } else if (action == ACTION_GET_REPAY_SHARE) {
1248                 int256 part = abi.decode(datas[i], (int256));
1249                 value1 = bentoBox.toShare(magicInternetMoney, totalBorrow.toElastic(_num(part, value1, value2), true), true);
1250             } else if (action == ACTION_GET_REPAY_PART) {
1251                 int256 amount = abi.decode(datas[i], (int256));
1252                 value1 = totalBorrow.toBase(_num(amount, value1, value2), false);
1253             }
1254         }
1255 
1256         if (status.needsSolvencyCheck) {
1257             require(_isSolvent(msg.sender, exchangeRate), "Cauldron: user insolvent");
1258         }
1259     }
1260 
1261     /// @notice Handles the liquidation of users' balances, once the users' amount of collateral is too low.
1262     /// @param users An array of user addresses.
1263     /// @param maxBorrowParts A one-to-one mapping to `users`, contains maximum (partial) borrow amounts (to liquidate) of the respective user.
1264     /// @param to Address of the receiver in open liquidations if `swapper` is zero.
1265     function liquidate(
1266         address[] calldata users,
1267         uint256[] calldata maxBorrowParts,
1268         address to,
1269         ISwapper swapper
1270     ) public {
1271         // Oracle can fail but we still need to allow liquidations
1272         (, uint256 _exchangeRate) = updateExchangeRate();
1273         accrue();
1274 
1275         uint256 allCollateralShare;
1276         uint256 allBorrowAmount;
1277         uint256 allBorrowPart;
1278         Rebase memory _totalBorrow = totalBorrow;
1279         Rebase memory bentoBoxTotals = bentoBox.totals(collateral);
1280         for (uint256 i = 0; i < users.length; i++) {
1281             address user = users[i];
1282             if (!_isSolvent(user, _exchangeRate)) {
1283                 uint256 borrowPart;
1284                 {
1285                     uint256 availableBorrowPart = userBorrowPart[user];
1286                     borrowPart = maxBorrowParts[i] > availableBorrowPart ? availableBorrowPart : maxBorrowParts[i];
1287                     userBorrowPart[user] = availableBorrowPart.sub(borrowPart);
1288                 }
1289                 uint256 borrowAmount = _totalBorrow.toElastic(borrowPart, false);
1290                 uint256 collateralShare =
1291                     bentoBoxTotals.toBase(
1292                         borrowAmount.mul(LIQUIDATION_MULTIPLIER).mul(_exchangeRate) /
1293                             (LIQUIDATION_MULTIPLIER_PRECISION * EXCHANGE_RATE_PRECISION),
1294                         false
1295                     );
1296 
1297                 userCollateralShare[user] = userCollateralShare[user].sub(collateralShare);
1298                 emit LogRemoveCollateral(user, to, collateralShare);
1299                 emit LogRepay(msg.sender, user, borrowAmount, borrowPart);
1300 
1301                 // Keep totals
1302                 allCollateralShare = allCollateralShare.add(collateralShare);
1303                 allBorrowAmount = allBorrowAmount.add(borrowAmount);
1304                 allBorrowPart = allBorrowPart.add(borrowPart);
1305             }
1306         }
1307         require(allBorrowAmount != 0, "Cauldron: all are solvent");
1308         _totalBorrow.elastic = _totalBorrow.elastic.sub(allBorrowAmount.to128());
1309         _totalBorrow.base = _totalBorrow.base.sub(allBorrowPart.to128());
1310         totalBorrow = _totalBorrow;
1311         totalCollateralShare = totalCollateralShare.sub(allCollateralShare);
1312 
1313         // Apply a percentual fee share to sSpell holders
1314         
1315         {
1316             uint256 distributionAmount = (allBorrowAmount.mul(LIQUIDATION_MULTIPLIER) / LIQUIDATION_MULTIPLIER_PRECISION).sub(allBorrowAmount).mul(DISTRIBUTION_PART) / DISTRIBUTION_PRECISION; // Distribution Amount
1317             allBorrowAmount = allBorrowAmount.add(distributionAmount);
1318             accrueInfo.feesEarned = accrueInfo.feesEarned.add(distributionAmount.to128());
1319         }
1320 
1321         uint256 allBorrowShare = bentoBox.toShare(magicInternetMoney, allBorrowAmount, true);
1322 
1323         // Swap using a swapper freely chosen by the caller
1324         // Open (flash) liquidation: get proceeds first and provide the borrow after
1325         bentoBox.transfer(collateral, address(this), to, allCollateralShare);
1326         if (swapper != ISwapper(0)) {
1327             swapper.swap(collateral, magicInternetMoney, msg.sender, allBorrowShare, allCollateralShare);
1328         }
1329 
1330         bentoBox.transfer(magicInternetMoney, msg.sender, address(this), allBorrowShare);
1331     }
1332 
1333     /// @notice Withdraws the fees accumulated.
1334     function withdrawFees() public {
1335         accrue();
1336         address _feeTo = masterContract.feeTo();
1337         uint256 _feesEarned = accrueInfo.feesEarned;
1338         uint256 share = bentoBox.toShare(magicInternetMoney, _feesEarned, false);
1339         bentoBox.transfer(magicInternetMoney, address(this), _feeTo, share);
1340         accrueInfo.feesEarned = 0;
1341 
1342         emit LogWithdrawFees(_feeTo, _feesEarned);
1343     }
1344 
1345     /// @notice Sets the beneficiary of interest accrued.
1346     /// MasterContract Only Admin function.
1347     /// @param newFeeTo The address of the receiver.
1348     function setFeeTo(address newFeeTo) public onlyOwner {
1349         feeTo = newFeeTo;
1350         emit LogFeeTo(newFeeTo);
1351     }
1352 
1353     /// @notice reduces the supply of MIM
1354     /// @param amount amount to reduce supply by
1355     function reduceSupply(uint256 amount) public {
1356         require(msg.sender == masterContract.owner(), "Caller is not the owner");
1357         bentoBox.withdraw(magicInternetMoney, address(this), address(this), amount, 0);
1358         MagicInternetMoney(address(magicInternetMoney)).burn(amount);
1359     }
1360 }