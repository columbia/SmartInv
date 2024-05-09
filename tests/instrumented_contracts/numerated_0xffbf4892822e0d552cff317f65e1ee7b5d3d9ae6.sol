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
72 // File @boringcrypto/boring-solidity/contracts/BoringOwnable.sol@v1.2.2
73 // License-Identifier: MIT
74 // Audit on 5-Jan-2021 by Keno and BoringCrypto
75 // Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol + Claimable.sol
76 // Edited by BoringCrypto
77 
78 contract BoringOwnableData {
79     address public owner;
80     address public pendingOwner;
81 }
82 
83 contract BoringOwnable is BoringOwnableData {
84     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
85 
86     /// @notice `owner` defaults to msg.sender on construction.
87     constructor() public {
88         owner = msg.sender;
89         emit OwnershipTransferred(address(0), msg.sender);
90     }
91 
92     /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.
93     /// Can only be invoked by the current `owner`.
94     /// @param newOwner Address of the new owner.
95     /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.
96     /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.
97     function transferOwnership(
98         address newOwner,
99         bool direct,
100         bool renounce
101     ) public onlyOwner {
102         if (direct) {
103             // Checks
104             require(newOwner != address(0) || renounce, "Ownable: zero address");
105 
106             // Effects
107             emit OwnershipTransferred(owner, newOwner);
108             owner = newOwner;
109             pendingOwner = address(0);
110         } else {
111             // Effects
112             pendingOwner = newOwner;
113         }
114     }
115 
116     /// @notice Needs to be called by `pendingOwner` to claim ownership.
117     function claimOwnership() public {
118         address _pendingOwner = pendingOwner;
119 
120         // Checks
121         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
122 
123         // Effects
124         emit OwnershipTransferred(owner, _pendingOwner);
125         owner = _pendingOwner;
126         pendingOwner = address(0);
127     }
128 
129     /// @notice Only allows the `owner` to execute the function.
130     modifier onlyOwner() {
131         require(msg.sender == owner, "Ownable: caller is not the owner");
132         _;
133     }
134 }
135 
136 // File @boringcrypto/boring-solidity/contracts/interfaces/IERC20.sol@v1.2.2
137 // License-Identifier: MIT
138 interface IERC20 {
139     function totalSupply() external view returns (uint256);
140 
141     function balanceOf(address account) external view returns (uint256);
142 
143     function allowance(address owner, address spender) external view returns (uint256);
144 
145     function approve(address spender, uint256 amount) external returns (bool);
146 
147     event Transfer(address indexed from, address indexed to, uint256 value);
148     event Approval(address indexed owner, address indexed spender, uint256 value);
149 
150     /// @notice EIP 2612
151     function permit(
152         address owner,
153         address spender,
154         uint256 value,
155         uint256 deadline,
156         uint8 v,
157         bytes32 r,
158         bytes32 s
159     ) external;
160 }
161 
162 // File @boringcrypto/boring-solidity/contracts/Domain.sol@v1.2.2
163 // License-Identifier: MIT
164 // Based on code and smartness by Ross Campbell and Keno
165 // Uses immutable to store the domain separator to reduce gas usage
166 // If the chain id changes due to a fork, the forked chain will calculate on the fly.
167 
168 // solhint-disable no-inline-assembly
169 
170 contract Domain {
171     bytes32 private constant DOMAIN_SEPARATOR_SIGNATURE_HASH = keccak256("EIP712Domain(uint256 chainId,address verifyingContract)");
172     // See https://eips.ethereum.org/EIPS/eip-191
173     string private constant EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA = "\x19\x01";
174 
175     // solhint-disable var-name-mixedcase
176     bytes32 private immutable _DOMAIN_SEPARATOR;
177     uint256 private immutable DOMAIN_SEPARATOR_CHAIN_ID;
178 
179     /// @dev Calculate the DOMAIN_SEPARATOR
180     function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32) {
181         return keccak256(abi.encode(DOMAIN_SEPARATOR_SIGNATURE_HASH, chainId, address(this)));
182     }
183 
184     constructor() public {
185         uint256 chainId;
186         assembly {
187             chainId := chainid()
188         }
189         _DOMAIN_SEPARATOR = _calculateDomainSeparator(DOMAIN_SEPARATOR_CHAIN_ID = chainId);
190     }
191 
192     /// @dev Return the DOMAIN_SEPARATOR
193     // It's named internal to allow making it public from the contract that uses it by creating a simple view function
194     // with the desired public name, such as DOMAIN_SEPARATOR or domainSeparator.
195     // solhint-disable-next-line func-name-mixedcase
196     function _domainSeparator() internal view returns (bytes32) {
197         uint256 chainId;
198         assembly {
199             chainId := chainid()
200         }
201         return chainId == DOMAIN_SEPARATOR_CHAIN_ID ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId);
202     }
203 
204     function _getDigest(bytes32 dataHash) internal view returns (bytes32 digest) {
205         digest = keccak256(abi.encodePacked(EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA, _domainSeparator(), dataHash));
206     }
207 }
208 
209 // File @boringcrypto/boring-solidity/contracts/ERC20.sol@v1.2.2
210 // License-Identifier: MIT
211 
212 // solhint-disable no-inline-assembly
213 // solhint-disable not-rely-on-time
214 
215 // Data part taken out for building of contracts that receive delegate calls
216 contract ERC20Data {
217     /// @notice owner > balance mapping.
218     mapping(address => uint256) public balanceOf;
219     /// @notice owner > spender > allowance mapping.
220     mapping(address => mapping(address => uint256)) public allowance;
221     /// @notice owner > nonce mapping. Used in `permit`.
222     mapping(address => uint256) public nonces;
223 }
224 
225 abstract contract ERC20 is IERC20, Domain {
226     /// @notice owner > balance mapping.
227     mapping(address => uint256) public override balanceOf;
228     /// @notice owner > spender > allowance mapping.
229     mapping(address => mapping(address => uint256)) public override allowance;
230     /// @notice owner > nonce mapping. Used in `permit`.
231     mapping(address => uint256) public nonces;
232 
233     event Transfer(address indexed _from, address indexed _to, uint256 _value);
234     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
235 
236     /// @notice Transfers `amount` tokens from `msg.sender` to `to`.
237     /// @param to The address to move the tokens.
238     /// @param amount of the tokens to move.
239     /// @return (bool) Returns True if succeeded.
240     function transfer(address to, uint256 amount) public returns (bool) {
241         // If `amount` is 0, or `msg.sender` is `to` nothing happens
242         if (amount != 0 || msg.sender == to) {
243             uint256 srcBalance = balanceOf[msg.sender];
244             require(srcBalance >= amount, "ERC20: balance too low");
245             if (msg.sender != to) {
246                 require(to != address(0), "ERC20: no zero address"); // Moved down so low balance calls safe some gas
247 
248                 balanceOf[msg.sender] = srcBalance - amount; // Underflow is checked
249                 balanceOf[to] += amount;
250             }
251         }
252         emit Transfer(msg.sender, to, amount);
253         return true;
254     }
255 
256     /// @notice Transfers `amount` tokens from `from` to `to`. Caller needs approval for `from`.
257     /// @param from Address to draw tokens from.
258     /// @param to The address to move the tokens.
259     /// @param amount The token amount to move.
260     /// @return (bool) Returns True if succeeded.
261     function transferFrom(
262         address from,
263         address to,
264         uint256 amount
265     ) public returns (bool) {
266         // If `amount` is 0, or `from` is `to` nothing happens
267         if (amount != 0) {
268             uint256 srcBalance = balanceOf[from];
269             require(srcBalance >= amount, "ERC20: balance too low");
270 
271             if (from != to) {
272                 uint256 spenderAllowance = allowance[from][msg.sender];
273                 // If allowance is infinite, don't decrease it to save on gas (breaks with EIP-20).
274                 if (spenderAllowance != type(uint256).max) {
275                     require(spenderAllowance >= amount, "ERC20: allowance too low");
276                     allowance[from][msg.sender] = spenderAllowance - amount; // Underflow is checked
277                 }
278                 require(to != address(0), "ERC20: no zero address"); // Moved down so other failed calls safe some gas
279 
280                 balanceOf[from] = srcBalance - amount; // Underflow is checked
281                 balanceOf[to] += amount;
282             }
283         }
284         emit Transfer(from, to, amount);
285         return true;
286     }
287 
288     /// @notice Approves `amount` from sender to be spend by `spender`.
289     /// @param spender Address of the party that can draw from msg.sender's account.
290     /// @param amount The maximum collective amount that `spender` can draw.
291     /// @return (bool) Returns True if approved.
292     function approve(address spender, uint256 amount) public override returns (bool) {
293         allowance[msg.sender][spender] = amount;
294         emit Approval(msg.sender, spender, amount);
295         return true;
296     }
297 
298     // solhint-disable-next-line func-name-mixedcase
299     function DOMAIN_SEPARATOR() external view returns (bytes32) {
300         return _domainSeparator();
301     }
302 
303     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
304     bytes32 private constant PERMIT_SIGNATURE_HASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
305 
306     /// @notice Approves `value` from `owner_` to be spend by `spender`.
307     /// @param owner_ Address of the owner.
308     /// @param spender The address of the spender that gets approved to draw from `owner_`.
309     /// @param value The maximum collective amount that `spender` can draw.
310     /// @param deadline This permit must be redeemed before this deadline (UTC timestamp in seconds).
311     function permit(
312         address owner_,
313         address spender,
314         uint256 value,
315         uint256 deadline,
316         uint8 v,
317         bytes32 r,
318         bytes32 s
319     ) external override {
320         require(owner_ != address(0), "ERC20: Owner cannot be 0");
321         require(block.timestamp < deadline, "ERC20: Expired");
322         require(
323             ecrecover(_getDigest(keccak256(abi.encode(PERMIT_SIGNATURE_HASH, owner_, spender, value, nonces[owner_]++, deadline))), v, r, s) ==
324                 owner_,
325             "ERC20: Invalid Signature"
326         );
327         allowance[owner_][spender] = value;
328         emit Approval(owner_, spender, value);
329     }
330 }
331 
332 contract ERC20WithSupply is IERC20, ERC20 {
333     uint256 public override totalSupply;
334 
335     function _mint(address user, uint256 amount) private {
336         uint256 newTotalSupply = totalSupply + amount;
337         require(newTotalSupply >= totalSupply, "Mint overflow");
338         totalSupply = newTotalSupply;
339         balanceOf[user] += amount;
340     }
341 
342     function _burn(address user, uint256 amount) private {
343         require(balanceOf[user] >= amount, "Burn too much");
344         totalSupply -= amount;
345         balanceOf[user] -= amount;
346     }
347 }
348 
349 // File @boringcrypto/boring-solidity/contracts/interfaces/IMasterContract.sol@v1.2.2
350 // License-Identifier: MIT
351 
352 interface IMasterContract {
353     /// @notice Init function that gets called from `BoringFactory.deploy`.
354     /// Also kown as the constructor for cloned contracts.
355     /// Any ETH send to `BoringFactory.deploy` ends up here.
356     /// @param data Can be abi encoded arguments or anything else.
357     function init(bytes calldata data) external payable;
358 }
359 
360 // File @boringcrypto/boring-solidity/contracts/libraries/BoringRebase.sol@v1.2.2
361 // License-Identifier: MIT
362 
363 struct Rebase {
364     uint128 elastic;
365     uint128 base;
366 }
367 
368 /// @notice A rebasing library using overflow-/underflow-safe math.
369 library RebaseLibrary {
370     using BoringMath for uint256;
371     using BoringMath128 for uint128;
372 
373     /// @notice Calculates the base value in relationship to `elastic` and `total`.
374     function toBase(
375         Rebase memory total,
376         uint256 elastic,
377         bool roundUp
378     ) internal pure returns (uint256 base) {
379         if (total.elastic == 0) {
380             base = elastic;
381         } else {
382             base = elastic.mul(total.base) / total.elastic;
383             if (roundUp && base.mul(total.elastic) / total.base < elastic) {
384                 base = base.add(1);
385             }
386         }
387     }
388 
389     /// @notice Calculates the elastic value in relationship to `base` and `total`.
390     function toElastic(
391         Rebase memory total,
392         uint256 base,
393         bool roundUp
394     ) internal pure returns (uint256 elastic) {
395         if (total.base == 0) {
396             elastic = base;
397         } else {
398             elastic = base.mul(total.elastic) / total.base;
399             if (roundUp && elastic.mul(total.base) / total.elastic < base) {
400                 elastic = elastic.add(1);
401             }
402         }
403     }
404 
405     /// @notice Add `elastic` to `total` and doubles `total.base`.
406     /// @return (Rebase) The new total.
407     /// @return base in relationship to `elastic`.
408     function add(
409         Rebase memory total,
410         uint256 elastic,
411         bool roundUp
412     ) internal pure returns (Rebase memory, uint256 base) {
413         base = toBase(total, elastic, roundUp);
414         total.elastic = total.elastic.add(elastic.to128());
415         total.base = total.base.add(base.to128());
416         return (total, base);
417     }
418 
419     /// @notice Sub `base` from `total` and update `total.elastic`.
420     /// @return (Rebase) The new total.
421     /// @return elastic in relationship to `base`.
422     function sub(
423         Rebase memory total,
424         uint256 base,
425         bool roundUp
426     ) internal pure returns (Rebase memory, uint256 elastic) {
427         elastic = toElastic(total, base, roundUp);
428         total.elastic = total.elastic.sub(elastic.to128());
429         total.base = total.base.sub(base.to128());
430         return (total, elastic);
431     }
432 
433     /// @notice Add `elastic` and `base` to `total`.
434     function add(
435         Rebase memory total,
436         uint256 elastic,
437         uint256 base
438     ) internal pure returns (Rebase memory) {
439         total.elastic = total.elastic.add(elastic.to128());
440         total.base = total.base.add(base.to128());
441         return total;
442     }
443 
444     /// @notice Subtract `elastic` and `base` to `total`.
445     function sub(
446         Rebase memory total,
447         uint256 elastic,
448         uint256 base
449     ) internal pure returns (Rebase memory) {
450         total.elastic = total.elastic.sub(elastic.to128());
451         total.base = total.base.sub(base.to128());
452         return total;
453     }
454 
455     /// @notice Add `elastic` to `total` and update storage.
456     /// @return newElastic Returns updated `elastic`.
457     function addElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {
458         newElastic = total.elastic = total.elastic.add(elastic.to128());
459     }
460 
461     /// @notice Subtract `elastic` from `total` and update storage.
462     /// @return newElastic Returns updated `elastic`.
463     function subElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {
464         newElastic = total.elastic = total.elastic.sub(elastic.to128());
465     }
466 }
467 
468 // File @boringcrypto/boring-solidity/contracts/libraries/BoringERC20.sol@v1.2.2
469 // License-Identifier: MIT
470 
471 // solhint-disable avoid-low-level-calls
472 
473 library BoringERC20 {
474     bytes4 private constant SIG_SYMBOL = 0x95d89b41; // symbol()
475     bytes4 private constant SIG_NAME = 0x06fdde03; // name()
476     bytes4 private constant SIG_DECIMALS = 0x313ce567; // decimals()
477     bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)
478     bytes4 private constant SIG_TRANSFER_FROM = 0x23b872dd; // transferFrom(address,address,uint256)
479 
480     function returnDataToString(bytes memory data) internal pure returns (string memory) {
481         if (data.length >= 64) {
482             return abi.decode(data, (string));
483         } else if (data.length == 32) {
484             uint8 i = 0;
485             while (i < 32 && data[i] != 0) {
486                 i++;
487             }
488             bytes memory bytesArray = new bytes(i);
489             for (i = 0; i < 32 && data[i] != 0; i++) {
490                 bytesArray[i] = data[i];
491             }
492             return string(bytesArray);
493         } else {
494             return "???";
495         }
496     }
497 
498     /// @notice Provides a safe ERC20.symbol version which returns '???' as fallback string.
499     /// @param token The address of the ERC-20 token contract.
500     /// @return (string) Token symbol.
501     function safeSymbol(IERC20 token) internal view returns (string memory) {
502         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_SYMBOL));
503         return success ? returnDataToString(data) : "???";
504     }
505 
506     /// @notice Provides a safe ERC20.name version which returns '???' as fallback string.
507     /// @param token The address of the ERC-20 token contract.
508     /// @return (string) Token name.
509     function safeName(IERC20 token) internal view returns (string memory) {
510         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_NAME));
511         return success ? returnDataToString(data) : "???";
512     }
513 
514     /// @notice Provides a safe ERC20.decimals version which returns '18' as fallback value.
515     /// @param token The address of the ERC-20 token contract.
516     /// @return (uint8) Token decimals.
517     function safeDecimals(IERC20 token) internal view returns (uint8) {
518         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_DECIMALS));
519         return success && data.length == 32 ? abi.decode(data, (uint8)) : 18;
520     }
521 
522     /// @notice Provides a safe ERC20.transfer version for different ERC-20 implementations.
523     /// Reverts on a failed transfer.
524     /// @param token The address of the ERC-20 token.
525     /// @param to Transfer tokens to.
526     /// @param amount The token amount.
527     function safeTransfer(
528         IERC20 token,
529         address to,
530         uint256 amount
531     ) internal {
532         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER, to, amount));
533         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: Transfer failed");
534     }
535 
536     /// @notice Provides a safe ERC20.transferFrom version for different ERC-20 implementations.
537     /// Reverts on a failed transfer.
538     /// @param token The address of the ERC-20 token.
539     /// @param from Transfer tokens from.
540     /// @param to Transfer tokens to.
541     /// @param amount The token amount.
542     function safeTransferFrom(
543         IERC20 token,
544         address from,
545         address to,
546         uint256 amount
547     ) internal {
548         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER_FROM, from, to, amount));
549         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: TransferFrom failed");
550     }
551 }
552 
553 // File @sushiswap/bentobox-sdk/contracts/IBatchFlashBorrower.sol@v1.0.2
554 // License-Identifier: MIT
555 
556 interface IBatchFlashBorrower {
557     function onBatchFlashLoan(
558         address sender,
559         IERC20[] calldata tokens,
560         uint256[] calldata amounts,
561         uint256[] calldata fees,
562         bytes calldata data
563     ) external;
564 }
565 
566 // File @sushiswap/bentobox-sdk/contracts/IFlashBorrower.sol@v1.0.2
567 // License-Identifier: MIT
568 
569 interface IFlashBorrower {
570     function onFlashLoan(
571         address sender,
572         IERC20 token,
573         uint256 amount,
574         uint256 fee,
575         bytes calldata data
576     ) external;
577 }
578 
579 // File @sushiswap/bentobox-sdk/contracts/IStrategy.sol@v1.0.2
580 // License-Identifier: MIT
581 
582 interface IStrategy {
583     // Send the assets to the Strategy and call skim to invest them
584     function skim(uint256 amount) external;
585 
586     // Harvest any profits made converted to the asset and pass them to the caller
587     function harvest(uint256 balance, address sender) external returns (int256 amountAdded);
588 
589     // Withdraw assets. The returned amount can differ from the requested amount due to rounding.
590     // The actualAmount should be very close to the amount. The difference should NOT be used to report a loss. That's what harvest is for.
591     function withdraw(uint256 amount) external returns (uint256 actualAmount);
592 
593     // Withdraw all assets in the safest way possible. This shouldn't fail.
594     function exit(uint256 balance) external returns (int256 amountAdded);
595 }
596 
597 // File @sushiswap/bentobox-sdk/contracts/IBentoBoxV1.sol@v1.0.2
598 // License-Identifier: MIT
599 
600 interface IBentoBoxV1 {
601     event LogDeploy(address indexed masterContract, bytes data, address indexed cloneAddress);
602     event LogDeposit(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);
603     event LogFlashLoan(address indexed borrower, address indexed token, uint256 amount, uint256 feeAmount, address indexed receiver);
604     event LogRegisterProtocol(address indexed protocol);
605     event LogSetMasterContractApproval(address indexed masterContract, address indexed user, bool approved);
606     event LogStrategyDivest(address indexed token, uint256 amount);
607     event LogStrategyInvest(address indexed token, uint256 amount);
608     event LogStrategyLoss(address indexed token, uint256 amount);
609     event LogStrategyProfit(address indexed token, uint256 amount);
610     event LogStrategyQueued(address indexed token, address indexed strategy);
611     event LogStrategySet(address indexed token, address indexed strategy);
612     event LogStrategyTargetPercentage(address indexed token, uint256 targetPercentage);
613     event LogTransfer(address indexed token, address indexed from, address indexed to, uint256 share);
614     event LogWhiteListMasterContract(address indexed masterContract, bool approved);
615     event LogWithdraw(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);
616     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
617 
618     function balanceOf(IERC20, address) external view returns (uint256);
619 
620     function batch(bytes[] calldata calls, bool revertOnFail) external payable returns (bool[] memory successes, bytes[] memory results);
621 
622     function batchFlashLoan(
623         IBatchFlashBorrower borrower,
624         address[] calldata receivers,
625         IERC20[] calldata tokens,
626         uint256[] calldata amounts,
627         bytes calldata data
628     ) external;
629 
630     function claimOwnership() external;
631 
632     function deploy(
633         address masterContract,
634         bytes calldata data,
635         bool useCreate2
636     ) external payable;
637 
638     function deposit(
639         IERC20 token_,
640         address from,
641         address to,
642         uint256 amount,
643         uint256 share
644     ) external payable returns (uint256 amountOut, uint256 shareOut);
645 
646     function flashLoan(
647         IFlashBorrower borrower,
648         address receiver,
649         IERC20 token,
650         uint256 amount,
651         bytes calldata data
652     ) external;
653 
654     function harvest(
655         IERC20 token,
656         bool balance,
657         uint256 maxChangeAmount
658     ) external;
659 
660     function masterContractApproved(address, address) external view returns (bool);
661 
662     function masterContractOf(address) external view returns (address);
663 
664     function nonces(address) external view returns (uint256);
665 
666     function owner() external view returns (address);
667 
668     function pendingOwner() external view returns (address);
669 
670     function pendingStrategy(IERC20) external view returns (IStrategy);
671 
672     function permitToken(
673         IERC20 token,
674         address from,
675         address to,
676         uint256 amount,
677         uint256 deadline,
678         uint8 v,
679         bytes32 r,
680         bytes32 s
681     ) external;
682 
683     function registerProtocol() external;
684 
685     function setMasterContractApproval(
686         address user,
687         address masterContract,
688         bool approved,
689         uint8 v,
690         bytes32 r,
691         bytes32 s
692     ) external;
693 
694     function setStrategy(IERC20 token, IStrategy newStrategy) external;
695 
696     function setStrategyTargetPercentage(IERC20 token, uint64 targetPercentage_) external;
697 
698     function strategy(IERC20) external view returns (IStrategy);
699 
700     function strategyData(IERC20)
701         external
702         view
703         returns (
704             uint64 strategyStartDate,
705             uint64 targetPercentage,
706             uint128 balance
707         );
708 
709     function toAmount(
710         IERC20 token,
711         uint256 share,
712         bool roundUp
713     ) external view returns (uint256 amount);
714 
715     function toShare(
716         IERC20 token,
717         uint256 amount,
718         bool roundUp
719     ) external view returns (uint256 share);
720 
721     function totals(IERC20) external view returns (Rebase memory totals_);
722 
723     function transfer(
724         IERC20 token,
725         address from,
726         address to,
727         uint256 share
728     ) external;
729 
730     function transferMultiple(
731         IERC20 token,
732         address from,
733         address[] calldata tos,
734         uint256[] calldata shares
735     ) external;
736 
737     function transferOwnership(
738         address newOwner,
739         bool direct,
740         bool renounce
741     ) external;
742 
743     function whitelistMasterContract(address masterContract, bool approved) external;
744 
745     function whitelistedMasterContracts(address) external view returns (bool);
746 
747     function withdraw(
748         IERC20 token_,
749         address from,
750         address to,
751         uint256 amount,
752         uint256 share
753     ) external returns (uint256 amountOut, uint256 shareOut);
754 }
755 
756 // File contracts/MagicInternetMoney.sol
757 // License-Identifier: MIT
758 
759 // Magic Internet Money
760 
761 // ███╗   ███╗██╗███╗   ███╗
762 // ████╗ ████║██║████╗ ████║
763 // ██╔████╔██║██║██╔████╔██║
764 // ██║╚██╔╝██║██║██║╚██╔╝██║
765 // ██║ ╚═╝ ██║██║██║ ╚═╝ ██║
766 // ╚═╝     ╚═╝╚═╝╚═╝     ╚═╝
767 
768 // BoringCrypto, 0xMerlin
769 
770 /// @title Cauldron
771 /// @dev This contract allows contract calls to any contract (except BentoBox)
772 /// from arbitrary callers thus, don't trust calls from this contract in any circumstances.
773 contract MagicInternetMoney is ERC20, BoringOwnable {
774     using BoringMath for uint256;
775     // ERC20 'variables'
776     string public constant symbol = "MIM";
777     string public constant name = "Magic Internet Money";
778     uint8 public constant decimals = 18;
779     uint256 public override totalSupply;
780 
781     struct Minting {
782         uint128 time;
783         uint128 amount;
784     }
785 
786     Minting public lastMint;
787     uint256 private constant MINTING_PERIOD = 24 hours;
788     uint256 private constant MINTING_INCREASE = 15000;
789     uint256 private constant MINTING_PRECISION = 1e5;
790 
791     function mint(address to, uint256 amount) public onlyOwner {
792         require(to != address(0), "MIM: no mint to zero address");
793 
794         // Limits the amount minted per period to a convergence function, with the period duration restarting on every mint
795         uint256 totalMintedAmount = uint256(lastMint.time < block.timestamp - MINTING_PERIOD ? 0 : lastMint.amount).add(amount);
796         require(totalSupply == 0 || totalSupply.mul(MINTING_INCREASE) / MINTING_PRECISION >= totalMintedAmount);
797 
798         lastMint.time = block.timestamp.to128();
799         lastMint.amount = totalMintedAmount.to128();
800 
801         totalSupply = totalSupply + amount;
802         balanceOf[to] += amount;
803         emit Transfer(address(0), to, amount);
804     }
805 
806     function mintToBentoBox(address clone, uint256 amount, IBentoBoxV1 bentoBox) public onlyOwner {
807         mint(address(bentoBox), amount);
808         bentoBox.deposit(IERC20(address(this)), address(bentoBox), clone, amount, 0);
809     }
810 
811     function burn(uint256 amount) public {
812         require(amount <= balanceOf[msg.sender], "MIM: not enough");
813 
814         balanceOf[msg.sender] -= amount;
815         totalSupply -= amount;
816         emit Transfer(msg.sender, address(0), amount);
817     }
818 }
819 
820 // File contracts/interfaces/IOracle.sol
821 // License-Identifier: MIT
822 
823 interface IOracle {
824     /// @notice Get the latest exchange rate.
825     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
826     /// For example:
827     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
828     /// @return success if no valid (recent) rate is available, return false else true.
829     /// @return rate The rate of the requested asset / pair / pool.
830     function get(bytes calldata data) external returns (bool success, uint256 rate);
831 
832     /// @notice Check the last exchange rate without any state changes.
833     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
834     /// For example:
835     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
836     /// @return success if no valid (recent) rate is available, return false else true.
837     /// @return rate The rate of the requested asset / pair / pool.
838     function peek(bytes calldata data) external view returns (bool success, uint256 rate);
839 
840     /// @notice Check the current spot exchange rate without any state changes. For oracles like TWAP this will be different from peek().
841     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
842     /// For example:
843     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
844     /// @return rate The rate of the requested asset / pair / pool.
845     function peekSpot(bytes calldata data) external view returns (uint256 rate);
846 
847     /// @notice Returns a human readable (short) name about this oracle.
848     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
849     /// For example:
850     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
851     /// @return (string) A human readable symbol name about this oracle.
852     function symbol(bytes calldata data) external view returns (string memory);
853 
854     /// @notice Returns a human readable name about this oracle.
855     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
856     /// For example:
857     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
858     /// @return (string) A human readable name about this oracle.
859     function name(bytes calldata data) external view returns (string memory);
860 }
861 
862 // File contracts/interfaces/ISwapper.sol
863 // License-Identifier: MIT
864 interface ISwapper {
865     /// @notice Withdraws 'amountFrom' of token 'from' from the BentoBox account for this swapper.
866     /// Swaps it for at least 'amountToMin' of token 'to'.
867     /// Transfers the swapped tokens of 'to' into the BentoBox using a plain ERC20 transfer.
868     /// Returns the amount of tokens 'to' transferred to BentoBox.
869     /// (The BentoBox skim function will be used by the caller to get the swapped funds).
870     function swap(
871         IERC20 fromToken,
872         IERC20 toToken,
873         address recipient,
874         uint256 shareToMin,
875         uint256 shareFrom
876     ) external returns (uint256 extraShare, uint256 shareReturned);
877 
878     /// @notice Calculates the amount of token 'from' needed to complete the swap (amountFrom),
879     /// this should be less than or equal to amountFromMax.
880     /// Withdraws 'amountFrom' of token 'from' from the BentoBox account for this swapper.
881     /// Swaps it for exactly 'exactAmountTo' of token 'to'.
882     /// Transfers the swapped tokens of 'to' into the BentoBox using a plain ERC20 transfer.
883     /// Transfers allocated, but unused 'from' tokens within the BentoBox to 'refundTo' (amountFromMax - amountFrom).
884     /// Returns the amount of 'from' tokens withdrawn from BentoBox (amountFrom).
885     /// (The BentoBox skim function will be used by the caller to get the swapped funds).
886     function swapExact(
887         IERC20 fromToken,
888         IERC20 toToken,
889         address recipient,
890         address refundTo,
891         uint256 shareFromSupplied,
892         uint256 shareToExact
893     ) external returns (uint256 shareUsed, uint256 shareReturned);
894 }
895 
896 // File contracts/Cauldron.sol
897 // License-Identifier: UNLICENSED
898 
899 // Cauldron
900 
901 //    (                (   (
902 //    )\      )    (   )\  )\ )  (
903 //  (((_)  ( /(   ))\ ((_)(()/(  )(    (    (
904 //  )\___  )(_)) /((_) _   ((_))(()\   )\   )\ )
905 // ((/ __|((_)_ (_))( | |  _| |  ((_) ((_) _(_/(
906 //  | (__ / _` || || || |/ _` | | '_|/ _ \| ' \))
907 //   \___|\__,_| \_,_||_|\__,_| |_|  \___/|_||_|
908 
909 // Copyright (c) 2021 BoringCrypto - All rights reserved
910 // Twitter: @Boring_Crypto
911 
912 // Special thanks to:
913 // @0xKeno - for all his invaluable contributions
914 // @burger_crypto - for the idea of trying to let the LPs benefit from liquidations
915 
916 // solhint-disable avoid-low-level-calls
917 // solhint-disable no-inline-assembly
918 
919 /// @title Cauldron
920 /// @dev This contract allows contract calls to any contract (except BentoBox)
921 /// from arbitrary callers thus, don't trust calls from this contract in any circumstances.
922 contract CauldronMediumRiskV1 is BoringOwnable, IMasterContract {
923     using BoringMath for uint256;
924     using BoringMath128 for uint128;
925     using RebaseLibrary for Rebase;
926     using BoringERC20 for IERC20;
927 
928     event LogExchangeRate(uint256 rate);
929     event LogAccrue(uint128 accruedAmount);
930     event LogAddCollateral(address indexed from, address indexed to, uint256 share);
931     event LogRemoveCollateral(address indexed from, address indexed to, uint256 share);
932     event LogBorrow(address indexed from, address indexed to, uint256 amount, uint256 part);
933     event LogRepay(address indexed from, address indexed to, uint256 amount, uint256 part);
934     event LogFeeTo(address indexed newFeeTo);
935     event LogWithdrawFees(address indexed feeTo, uint256 feesEarnedFraction);
936 
937     // Immutables (for MasterContract and all clones)
938     IBentoBoxV1 public immutable bentoBox;
939     CauldronMediumRiskV1 public immutable masterContract;
940     IERC20 public immutable magicInternetMoney;
941 
942     // MasterContract variables
943     address public feeTo;
944 
945     // Per clone variables
946     // Clone init settings
947     IERC20 public collateral;
948     IOracle public oracle;
949     bytes public oracleData;
950 
951     // Total amounts
952     uint256 public totalCollateralShare; // Total collateral supplied
953     Rebase public totalBorrow; // elastic = Total token amount to be repayed by borrowers, base = Total parts of the debt held by borrowers
954 
955     // User balances
956     mapping(address => uint256) public userCollateralShare;
957     mapping(address => uint256) public userBorrowPart;
958 
959     /// @notice Exchange and interest rate tracking.
960     /// This is 'cached' here because calls to Oracles can be very expensive.
961     uint256 public exchangeRate;
962 
963     struct AccrueInfo {
964         uint64 lastAccrued;
965         uint128 feesEarned;
966     }
967 
968     AccrueInfo public accrueInfo;
969 
970     // Settings
971     uint256 private constant INTEREST_PER_SECOND = 475331078; // 1.5% p.a.
972 
973     uint256 private constant COLLATERIZATION_RATE = 75000; // 75%
974     uint256 private constant COLLATERIZATION_RATE_PRECISION = 1e5; // Must be less than EXCHANGE_RATE_PRECISION (due to optimization in math)
975 
976     uint256 private constant EXCHANGE_RATE_PRECISION = 1e18;
977 
978     uint256 private constant LIQUIDATION_MULTIPLIER = 112500; // add 12%
979     uint256 private constant LIQUIDATION_MULTIPLIER_PRECISION = 1e5;
980 
981     uint256 private constant BORROW_OPENING_FEE = 50; // 0.05%
982     uint256 private constant BORROW_OPENING_FEE_PRECISION = 1e5;
983 
984     /// @notice The constructor is only used for the initial master contract. Subsequent clones are initialised via `init`.
985     constructor(IBentoBoxV1 bentoBox_, IERC20 magicInternetMoney_) public {
986         bentoBox = bentoBox_;
987         magicInternetMoney = magicInternetMoney_;
988         masterContract = this;
989     }
990 
991     /// @notice Serves as the constructor for clones, as clones can't have a regular constructor
992     /// @dev `data` is abi encoded in the format: (IERC20 collateral, IERC20 asset, IOracle oracle, bytes oracleData)
993     function init(bytes calldata data) public payable override {
994         require(address(collateral) == address(0), "Cauldron: already initialized");
995         (collateral, oracle, oracleData) = abi.decode(data, (IERC20, IOracle, bytes));
996         require(address(collateral) != address(0), "Cauldron: bad pair");
997     }
998 
999     /// @notice Accrues the interest on the borrowed tokens and handles the accumulation of fees.
1000     function accrue() public {
1001         AccrueInfo memory _accrueInfo = accrueInfo;
1002         // Number of seconds since accrue was called
1003         uint256 elapsedTime = block.timestamp - _accrueInfo.lastAccrued;
1004         if (elapsedTime == 0) {
1005             return;
1006         }
1007         _accrueInfo.lastAccrued = uint64(block.timestamp);
1008 
1009         Rebase memory _totalBorrow = totalBorrow;
1010         if (_totalBorrow.base == 0) {
1011             accrueInfo = _accrueInfo;
1012             return;
1013         }
1014 
1015         // Accrue interest
1016         uint128 extraAmount = (uint256(_totalBorrow.elastic).mul(INTEREST_PER_SECOND).mul(elapsedTime) / 1e18).to128();
1017         _totalBorrow.elastic = _totalBorrow.elastic.add(extraAmount);
1018 
1019         _accrueInfo.feesEarned = _accrueInfo.feesEarned.add(extraAmount);
1020         totalBorrow = _totalBorrow;
1021         accrueInfo = _accrueInfo;
1022 
1023         emit LogAccrue(extraAmount);
1024     }
1025 
1026     /// @notice Concrete implementation of `isSolvent`. Includes a third parameter to allow caching `exchangeRate`.
1027     /// @param _exchangeRate The exchange rate. Used to cache the `exchangeRate` between calls.
1028     function _isSolvent(address user, uint256 _exchangeRate) internal view returns (bool) {
1029         // accrue must have already been called!
1030         uint256 borrowPart = userBorrowPart[user];
1031         if (borrowPart == 0) return true;
1032         uint256 collateralShare = userCollateralShare[user];
1033         if (collateralShare == 0) return false;
1034 
1035         Rebase memory _totalBorrow = totalBorrow;
1036 
1037         return
1038             bentoBox.toAmount(
1039                 collateral,
1040                 collateralShare.mul(EXCHANGE_RATE_PRECISION / COLLATERIZATION_RATE_PRECISION).mul(COLLATERIZATION_RATE),
1041                 false
1042             ) >=
1043             // Moved exchangeRate here instead of dividing the other side to preserve more precision
1044             borrowPart.mul(_totalBorrow.elastic).mul(_exchangeRate) / _totalBorrow.base;
1045     }
1046 
1047     /// @dev Checks if the user is solvent in the closed liquidation case at the end of the function body.
1048     modifier solvent() {
1049         _;
1050         require(_isSolvent(msg.sender, exchangeRate), "Cauldron: user insolvent");
1051     }
1052 
1053     /// @notice Gets the exchange rate. I.e how much collateral to buy 1e18 asset.
1054     /// This function is supposed to be invoked if needed because Oracle queries can be expensive.
1055     /// @return updated True if `exchangeRate` was updated.
1056     /// @return rate The new exchange rate.
1057     function updateExchangeRate() public returns (bool updated, uint256 rate) {
1058         (updated, rate) = oracle.get(oracleData);
1059 
1060         if (updated) {
1061             exchangeRate = rate;
1062             emit LogExchangeRate(rate);
1063         } else {
1064             // Return the old rate if fetching wasn't successful
1065             rate = exchangeRate;
1066         }
1067     }
1068 
1069     /// @dev Helper function to move tokens.
1070     /// @param token The ERC-20 token.
1071     /// @param share The amount in shares to add.
1072     /// @param total Grand total amount to deduct from this contract's balance. Only applicable if `skim` is True.
1073     /// Only used for accounting checks.
1074     /// @param skim If True, only does a balance check on this contract.
1075     /// False if tokens from msg.sender in `bentoBox` should be transferred.
1076     function _addTokens(
1077         IERC20 token,
1078         uint256 share,
1079         uint256 total,
1080         bool skim
1081     ) internal {
1082         if (skim) {
1083             require(share <= bentoBox.balanceOf(token, address(this)).sub(total), "Cauldron: Skim too much");
1084         } else {
1085             bentoBox.transfer(token, msg.sender, address(this), share);
1086         }
1087     }
1088 
1089     /// @notice Adds `collateral` from msg.sender to the account `to`.
1090     /// @param to The receiver of the tokens.
1091     /// @param skim True if the amount should be skimmed from the deposit balance of msg.sender.x
1092     /// False if tokens from msg.sender in `bentoBox` should be transferred.
1093     /// @param share The amount of shares to add for `to`.
1094     function addCollateral(
1095         address to,
1096         bool skim,
1097         uint256 share
1098     ) public {
1099         userCollateralShare[to] = userCollateralShare[to].add(share);
1100         uint256 oldTotalCollateralShare = totalCollateralShare;
1101         totalCollateralShare = oldTotalCollateralShare.add(share);
1102         _addTokens(collateral, share, oldTotalCollateralShare, skim);
1103         emit LogAddCollateral(skim ? address(bentoBox) : msg.sender, to, share);
1104     }
1105 
1106     /// @dev Concrete implementation of `removeCollateral`.
1107     function _removeCollateral(address to, uint256 share) internal {
1108         userCollateralShare[msg.sender] = userCollateralShare[msg.sender].sub(share);
1109         totalCollateralShare = totalCollateralShare.sub(share);
1110         emit LogRemoveCollateral(msg.sender, to, share);
1111         bentoBox.transfer(collateral, address(this), to, share);
1112     }
1113 
1114     /// @notice Removes `share` amount of collateral and transfers it to `to`.
1115     /// @param to The receiver of the shares.
1116     /// @param share Amount of shares to remove.
1117     function removeCollateral(address to, uint256 share) public solvent {
1118         // accrue must be called because we check solvency
1119         accrue();
1120         _removeCollateral(to, share);
1121     }
1122 
1123     /// @dev Concrete implementation of `borrow`.
1124     function _borrow(address to, uint256 amount) internal returns (uint256 part, uint256 share) {
1125         uint256 feeAmount = amount.mul(BORROW_OPENING_FEE) / BORROW_OPENING_FEE_PRECISION; // A flat % fee is charged for any borrow
1126         (totalBorrow, part) = totalBorrow.add(amount.add(feeAmount), true);
1127         userBorrowPart[msg.sender] = userBorrowPart[msg.sender].add(part);
1128 
1129         // As long as there are tokens on this contract you can 'mint'... this enables limiting borrows
1130         share = bentoBox.toShare(magicInternetMoney, amount, false);
1131         bentoBox.transfer(magicInternetMoney, address(this), to, share);
1132 
1133         emit LogBorrow(msg.sender, to, amount.add(feeAmount), part);
1134     }
1135 
1136     /// @notice Sender borrows `amount` and transfers it to `to`.
1137     /// @return part Total part of the debt held by borrowers.
1138     /// @return share Total amount in shares borrowed.
1139     function borrow(address to, uint256 amount) public solvent returns (uint256 part, uint256 share) {
1140         accrue();
1141         (part, share) = _borrow(to, amount);
1142     }
1143 
1144     /// @dev Concrete implementation of `repay`.
1145     function _repay(
1146         address to,
1147         bool skim,
1148         uint256 part
1149     ) internal returns (uint256 amount) {
1150         (totalBorrow, amount) = totalBorrow.sub(part, true);
1151         userBorrowPart[to] = userBorrowPart[to].sub(part);
1152 
1153         uint256 share = bentoBox.toShare(magicInternetMoney, amount, true);
1154         bentoBox.transfer(magicInternetMoney, skim ? address(bentoBox) : msg.sender, address(this), share);
1155         emit LogRepay(skim ? address(bentoBox) : msg.sender, to, amount, part);
1156     }
1157 
1158     /// @notice Repays a loan.
1159     /// @param to Address of the user this payment should go.
1160     /// @param skim True if the amount should be skimmed from the deposit balance of msg.sender.
1161     /// False if tokens from msg.sender in `bentoBox` should be transferred.
1162     /// @param part The amount to repay. See `userBorrowPart`.
1163     /// @return amount The total amount repayed.
1164     function repay(
1165         address to,
1166         bool skim,
1167         uint256 part
1168     ) public returns (uint256 amount) {
1169         accrue();
1170         amount = _repay(to, skim, part);
1171     }
1172 
1173     // Functions that need accrue to be called
1174     uint8 internal constant ACTION_REPAY = 2;
1175     uint8 internal constant ACTION_REMOVE_COLLATERAL = 4;
1176     uint8 internal constant ACTION_BORROW = 5;
1177     uint8 internal constant ACTION_GET_REPAY_SHARE = 6;
1178     uint8 internal constant ACTION_GET_REPAY_PART = 7;
1179     uint8 internal constant ACTION_ACCRUE = 8;
1180 
1181     // Functions that don't need accrue to be called
1182     uint8 internal constant ACTION_ADD_COLLATERAL = 10;
1183     uint8 internal constant ACTION_UPDATE_EXCHANGE_RATE = 11;
1184 
1185     // Function on BentoBox
1186     uint8 internal constant ACTION_BENTO_DEPOSIT = 20;
1187     uint8 internal constant ACTION_BENTO_WITHDRAW = 21;
1188     uint8 internal constant ACTION_BENTO_TRANSFER = 22;
1189     uint8 internal constant ACTION_BENTO_TRANSFER_MULTIPLE = 23;
1190     uint8 internal constant ACTION_BENTO_SETAPPROVAL = 24;
1191 
1192     // Any external call (except to BentoBox)
1193     uint8 internal constant ACTION_CALL = 30;
1194 
1195     int256 internal constant USE_VALUE1 = -1;
1196     int256 internal constant USE_VALUE2 = -2;
1197 
1198     /// @dev Helper function for choosing the correct value (`value1` or `value2`) depending on `inNum`.
1199     function _num(
1200         int256 inNum,
1201         uint256 value1,
1202         uint256 value2
1203     ) internal pure returns (uint256 outNum) {
1204         outNum = inNum >= 0 ? uint256(inNum) : (inNum == USE_VALUE1 ? value1 : value2);
1205     }
1206 
1207     /// @dev Helper function for depositing into `bentoBox`.
1208     function _bentoDeposit(
1209         bytes memory data,
1210         uint256 value,
1211         uint256 value1,
1212         uint256 value2
1213     ) internal returns (uint256, uint256) {
1214         (IERC20 token, address to, int256 amount, int256 share) = abi.decode(data, (IERC20, address, int256, int256));
1215         amount = int256(_num(amount, value1, value2)); // Done this way to avoid stack too deep errors
1216         share = int256(_num(share, value1, value2));
1217         return bentoBox.deposit{value: value}(token, msg.sender, to, uint256(amount), uint256(share));
1218     }
1219 
1220     /// @dev Helper function to withdraw from the `bentoBox`.
1221     function _bentoWithdraw(
1222         bytes memory data,
1223         uint256 value1,
1224         uint256 value2
1225     ) internal returns (uint256, uint256) {
1226         (IERC20 token, address to, int256 amount, int256 share) = abi.decode(data, (IERC20, address, int256, int256));
1227         return bentoBox.withdraw(token, msg.sender, to, _num(amount, value1, value2), _num(share, value1, value2));
1228     }
1229 
1230     /// @dev Helper function to perform a contract call and eventually extracting revert messages on failure.
1231     /// Calls to `bentoBox` are not allowed for obvious security reasons.
1232     /// This also means that calls made from this contract shall *not* be trusted.
1233     function _call(
1234         uint256 value,
1235         bytes memory data,
1236         uint256 value1,
1237         uint256 value2
1238     ) internal returns (bytes memory, uint8) {
1239         (address callee, bytes memory callData, bool useValue1, bool useValue2, uint8 returnValues) =
1240             abi.decode(data, (address, bytes, bool, bool, uint8));
1241 
1242         if (useValue1 && !useValue2) {
1243             callData = abi.encodePacked(callData, value1);
1244         } else if (!useValue1 && useValue2) {
1245             callData = abi.encodePacked(callData, value2);
1246         } else if (useValue1 && useValue2) {
1247             callData = abi.encodePacked(callData, value1, value2);
1248         }
1249 
1250         require(callee != address(bentoBox) && callee != address(this), "Cauldron: can't call");
1251 
1252         (bool success, bytes memory returnData) = callee.call{value: value}(callData);
1253         require(success, "Cauldron: call failed");
1254         return (returnData, returnValues);
1255     }
1256 
1257     struct CookStatus {
1258         bool needsSolvencyCheck;
1259         bool hasAccrued;
1260     }
1261 
1262     /// @notice Executes a set of actions and allows composability (contract calls) to other contracts.
1263     /// @param actions An array with a sequence of actions to execute (see ACTION_ declarations).
1264     /// @param values A one-to-one mapped array to `actions`. ETH amounts to send along with the actions.
1265     /// Only applicable to `ACTION_CALL`, `ACTION_BENTO_DEPOSIT`.
1266     /// @param datas A one-to-one mapped array to `actions`. Contains abi encoded data of function arguments.
1267     /// @return value1 May contain the first positioned return value of the last executed action (if applicable).
1268     /// @return value2 May contain the second positioned return value of the last executed action which returns 2 values (if applicable).
1269     function cook(
1270         uint8[] calldata actions,
1271         uint256[] calldata values,
1272         bytes[] calldata datas
1273     ) external payable returns (uint256 value1, uint256 value2) {
1274         CookStatus memory status;
1275         for (uint256 i = 0; i < actions.length; i++) {
1276             uint8 action = actions[i];
1277             if (!status.hasAccrued && action < 10) {
1278                 accrue();
1279                 status.hasAccrued = true;
1280             }
1281             if (action == ACTION_ADD_COLLATERAL) {
1282                 (int256 share, address to, bool skim) = abi.decode(datas[i], (int256, address, bool));
1283                 addCollateral(to, skim, _num(share, value1, value2));
1284             } else if (action == ACTION_REPAY) {
1285                 (int256 part, address to, bool skim) = abi.decode(datas[i], (int256, address, bool));
1286                 _repay(to, skim, _num(part, value1, value2));
1287             } else if (action == ACTION_REMOVE_COLLATERAL) {
1288                 (int256 share, address to) = abi.decode(datas[i], (int256, address));
1289                 _removeCollateral(to, _num(share, value1, value2));
1290                 status.needsSolvencyCheck = true;
1291             } else if (action == ACTION_BORROW) {
1292                 (int256 amount, address to) = abi.decode(datas[i], (int256, address));
1293                 (value1, value2) = _borrow(to, _num(amount, value1, value2));
1294                 status.needsSolvencyCheck = true;
1295             } else if (action == ACTION_UPDATE_EXCHANGE_RATE) {
1296                 (bool must_update, uint256 minRate, uint256 maxRate) = abi.decode(datas[i], (bool, uint256, uint256));
1297                 (bool updated, uint256 rate) = updateExchangeRate();
1298                 require((!must_update || updated) && rate > minRate && (maxRate == 0 || rate > maxRate), "Cauldron: rate not ok");
1299             } else if (action == ACTION_BENTO_SETAPPROVAL) {
1300                 (address user, address _masterContract, bool approved, uint8 v, bytes32 r, bytes32 s) =
1301                     abi.decode(datas[i], (address, address, bool, uint8, bytes32, bytes32));
1302                 bentoBox.setMasterContractApproval(user, _masterContract, approved, v, r, s);
1303             } else if (action == ACTION_BENTO_DEPOSIT) {
1304                 (value1, value2) = _bentoDeposit(datas[i], values[i], value1, value2);
1305             } else if (action == ACTION_BENTO_WITHDRAW) {
1306                 (value1, value2) = _bentoWithdraw(datas[i], value1, value2);
1307             } else if (action == ACTION_BENTO_TRANSFER) {
1308                 (IERC20 token, address to, int256 share) = abi.decode(datas[i], (IERC20, address, int256));
1309                 bentoBox.transfer(token, msg.sender, to, _num(share, value1, value2));
1310             } else if (action == ACTION_BENTO_TRANSFER_MULTIPLE) {
1311                 (IERC20 token, address[] memory tos, uint256[] memory shares) = abi.decode(datas[i], (IERC20, address[], uint256[]));
1312                 bentoBox.transferMultiple(token, msg.sender, tos, shares);
1313             } else if (action == ACTION_CALL) {
1314                 (bytes memory returnData, uint8 returnValues) = _call(values[i], datas[i], value1, value2);
1315 
1316                 if (returnValues == 1) {
1317                     (value1) = abi.decode(returnData, (uint256));
1318                 } else if (returnValues == 2) {
1319                     (value1, value2) = abi.decode(returnData, (uint256, uint256));
1320                 }
1321             } else if (action == ACTION_GET_REPAY_SHARE) {
1322                 int256 part = abi.decode(datas[i], (int256));
1323                 value1 = bentoBox.toShare(magicInternetMoney, totalBorrow.toElastic(_num(part, value1, value2), true), true);
1324             } else if (action == ACTION_GET_REPAY_PART) {
1325                 int256 amount = abi.decode(datas[i], (int256));
1326                 value1 = totalBorrow.toBase(_num(amount, value1, value2), false);
1327             }
1328         }
1329 
1330         if (status.needsSolvencyCheck) {
1331             require(_isSolvent(msg.sender, exchangeRate), "Cauldron: user insolvent");
1332         }
1333     }
1334 
1335     /// @notice Handles the liquidation of users' balances, once the users' amount of collateral is too low.
1336     /// @param users An array of user addresses.
1337     /// @param maxBorrowParts A one-to-one mapping to `users`, contains maximum (partial) borrow amounts (to liquidate) of the respective user.
1338     /// @param to Address of the receiver in open liquidations if `swapper` is zero.
1339     function liquidate(
1340         address[] calldata users,
1341         uint256[] calldata maxBorrowParts,
1342         address to,
1343         ISwapper swapper
1344     ) public {
1345         // Oracle can fail but we still need to allow liquidations
1346         (, uint256 _exchangeRate) = updateExchangeRate();
1347         accrue();
1348 
1349         uint256 allCollateralShare;
1350         uint256 allBorrowAmount;
1351         uint256 allBorrowPart;
1352         Rebase memory _totalBorrow = totalBorrow;
1353         Rebase memory bentoBoxTotals = bentoBox.totals(collateral);
1354         for (uint256 i = 0; i < users.length; i++) {
1355             address user = users[i];
1356             if (!_isSolvent(user, _exchangeRate)) {
1357                 uint256 borrowPart;
1358                 {
1359                     uint256 availableBorrowPart = userBorrowPart[user];
1360                     borrowPart = maxBorrowParts[i] > availableBorrowPart ? availableBorrowPart : maxBorrowParts[i];
1361                     userBorrowPart[user] = availableBorrowPart.sub(borrowPart);
1362                 }
1363                 uint256 borrowAmount = _totalBorrow.toElastic(borrowPart, false);
1364                 uint256 collateralShare =
1365                     bentoBoxTotals.toBase(
1366                         borrowAmount.mul(LIQUIDATION_MULTIPLIER).mul(_exchangeRate) /
1367                             (LIQUIDATION_MULTIPLIER_PRECISION * EXCHANGE_RATE_PRECISION),
1368                         false
1369                     );
1370 
1371                 userCollateralShare[user] = userCollateralShare[user].sub(collateralShare);
1372                 emit LogRemoveCollateral(user, to, collateralShare);
1373                 emit LogRepay(msg.sender, user, borrowAmount, borrowPart);
1374 
1375                 // Keep totals
1376                 allCollateralShare = allCollateralShare.add(collateralShare);
1377                 allBorrowAmount = allBorrowAmount.add(borrowAmount);
1378                 allBorrowPart = allBorrowPart.add(borrowPart);
1379             }
1380         }
1381         require(allBorrowAmount != 0, "Cauldron: all are solvent");
1382         _totalBorrow.elastic = _totalBorrow.elastic.sub(allBorrowAmount.to128());
1383         _totalBorrow.base = _totalBorrow.base.sub(allBorrowPart.to128());
1384         totalBorrow = _totalBorrow;
1385         totalCollateralShare = totalCollateralShare.sub(allCollateralShare);
1386 
1387         uint256 allBorrowShare = bentoBox.toShare(magicInternetMoney, allBorrowAmount, true);
1388 
1389         // Swap using a swapper freely chosen by the caller
1390         // Open (flash) liquidation: get proceeds first and provide the borrow after
1391         bentoBox.transfer(collateral, address(this), to, allCollateralShare);
1392         if (swapper != ISwapper(0)) {
1393             swapper.swap(collateral, magicInternetMoney, msg.sender, allBorrowShare, allCollateralShare);
1394         }
1395 
1396         bentoBox.transfer(magicInternetMoney, msg.sender, address(this), allBorrowShare);
1397     }
1398 
1399     /// @notice Withdraws the fees accumulated.
1400     function withdrawFees() public {
1401         accrue();
1402         address _feeTo = masterContract.feeTo();
1403         uint256 _feesEarned = accrueInfo.feesEarned;
1404         uint256 share = bentoBox.toShare(magicInternetMoney, _feesEarned, false);
1405         bentoBox.transfer(magicInternetMoney, address(this), _feeTo, share);
1406         accrueInfo.feesEarned = 0;
1407 
1408         emit LogWithdrawFees(_feeTo, _feesEarned);
1409     }
1410 
1411     /// @notice Sets the beneficiary of interest accrued.
1412     /// MasterContract Only Admin function.
1413     /// @param newFeeTo The address of the receiver.
1414     function setFeeTo(address newFeeTo) public onlyOwner {
1415         feeTo = newFeeTo;
1416         emit LogFeeTo(newFeeTo);
1417     }
1418 
1419     /// @notice reduces the supply of MIM
1420     /// @param amount amount to reduce supply by
1421     function reduceSupply(uint256 amount) public {
1422         require(msg.sender == masterContract.owner(), "Caller is not the owner");
1423         bentoBox.withdraw(magicInternetMoney, address(this), address(this), amount, 0);
1424         MagicInternetMoney(address(magicInternetMoney)).burn(amount);
1425     }
1426 }