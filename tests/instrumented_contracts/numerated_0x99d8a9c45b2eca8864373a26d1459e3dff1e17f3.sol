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
71 // File @boringcrypto/boring-solidity/contracts/interfaces/IERC20.sol@v1.2.2
72 // License-Identifier: MIT
73 pragma solidity 0.6.12;
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
99 // File @boringcrypto/boring-solidity/contracts/Domain.sol@v1.2.2
100 // License-Identifier: MIT
101 // Based on code and smartness by Ross Campbell and Keno
102 // Uses immutable to store the domain separator to reduce gas usage
103 // If the chain id changes due to a fork, the forked chain will calculate on the fly.
104 pragma solidity 0.6.12;
105 
106 // solhint-disable no-inline-assembly
107 
108 contract Domain {
109     bytes32 private constant DOMAIN_SEPARATOR_SIGNATURE_HASH = keccak256("EIP712Domain(uint256 chainId,address verifyingContract)");
110     // See https://eips.ethereum.org/EIPS/eip-191
111     string private constant EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA = "\x19\x01";
112 
113     // solhint-disable var-name-mixedcase
114     bytes32 private immutable _DOMAIN_SEPARATOR;
115     uint256 private immutable DOMAIN_SEPARATOR_CHAIN_ID;
116 
117     /// @dev Calculate the DOMAIN_SEPARATOR
118     function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32) {
119         return keccak256(abi.encode(DOMAIN_SEPARATOR_SIGNATURE_HASH, chainId, address(this)));
120     }
121 
122     constructor() public {
123         uint256 chainId;
124         assembly {
125             chainId := chainid()
126         }
127         _DOMAIN_SEPARATOR = _calculateDomainSeparator(DOMAIN_SEPARATOR_CHAIN_ID = chainId);
128     }
129 
130     /// @dev Return the DOMAIN_SEPARATOR
131     // It's named internal to allow making it public from the contract that uses it by creating a simple view function
132     // with the desired public name, such as DOMAIN_SEPARATOR or domainSeparator.
133     // solhint-disable-next-line func-name-mixedcase
134     function _domainSeparator() internal view returns (bytes32) {
135         uint256 chainId;
136         assembly {
137             chainId := chainid()
138         }
139         return chainId == DOMAIN_SEPARATOR_CHAIN_ID ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId);
140     }
141 
142     function _getDigest(bytes32 dataHash) internal view returns (bytes32 digest) {
143         digest = keccak256(abi.encodePacked(EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA, _domainSeparator(), dataHash));
144     }
145 }
146 
147 // File @boringcrypto/boring-solidity/contracts/ERC20.sol@v1.2.2
148 // License-Identifier: MIT
149 pragma solidity 0.6.12;
150 
151 // solhint-disable no-inline-assembly
152 // solhint-disable not-rely-on-time
153 
154 // Data part taken out for building of contracts that receive delegate calls
155 contract ERC20Data {
156     /// @notice owner > balance mapping.
157     mapping(address => uint256) public balanceOf;
158     /// @notice owner > spender > allowance mapping.
159     mapping(address => mapping(address => uint256)) public allowance;
160     /// @notice owner > nonce mapping. Used in `permit`.
161     mapping(address => uint256) public nonces;
162 }
163 
164 abstract contract ERC20 is IERC20, Domain {
165     /// @notice owner > balance mapping.
166     mapping(address => uint256) public override balanceOf;
167     /// @notice owner > spender > allowance mapping.
168     mapping(address => mapping(address => uint256)) public override allowance;
169     /// @notice owner > nonce mapping. Used in `permit`.
170     mapping(address => uint256) public nonces;
171 
172     event Transfer(address indexed _from, address indexed _to, uint256 _value);
173     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
174 
175     /// @notice Transfers `amount` tokens from `msg.sender` to `to`.
176     /// @param to The address to move the tokens.
177     /// @param amount of the tokens to move.
178     /// @return (bool) Returns True if succeeded.
179     function transfer(address to, uint256 amount) public returns (bool) {
180         // If `amount` is 0, or `msg.sender` is `to` nothing happens
181         if (amount != 0 || msg.sender == to) {
182             uint256 srcBalance = balanceOf[msg.sender];
183             require(srcBalance >= amount, "ERC20: balance too low");
184             if (msg.sender != to) {
185                 require(to != address(0), "ERC20: no zero address"); // Moved down so low balance calls safe some gas
186 
187                 balanceOf[msg.sender] = srcBalance - amount; // Underflow is checked
188                 balanceOf[to] += amount;
189             }
190         }
191         emit Transfer(msg.sender, to, amount);
192         return true;
193     }
194 
195     /// @notice Transfers `amount` tokens from `from` to `to`. Caller needs approval for `from`.
196     /// @param from Address to draw tokens from.
197     /// @param to The address to move the tokens.
198     /// @param amount The token amount to move.
199     /// @return (bool) Returns True if succeeded.
200     function transferFrom(
201         address from,
202         address to,
203         uint256 amount
204     ) public returns (bool) {
205         // If `amount` is 0, or `from` is `to` nothing happens
206         if (amount != 0) {
207             uint256 srcBalance = balanceOf[from];
208             require(srcBalance >= amount, "ERC20: balance too low");
209 
210             if (from != to) {
211                 uint256 spenderAllowance = allowance[from][msg.sender];
212                 // If allowance is infinite, don't decrease it to save on gas (breaks with EIP-20).
213                 if (spenderAllowance != type(uint256).max) {
214                     require(spenderAllowance >= amount, "ERC20: allowance too low");
215                     allowance[from][msg.sender] = spenderAllowance - amount; // Underflow is checked
216                 }
217                 require(to != address(0), "ERC20: no zero address"); // Moved down so other failed calls safe some gas
218 
219                 balanceOf[from] = srcBalance - amount; // Underflow is checked
220                 balanceOf[to] += amount;
221             }
222         }
223         emit Transfer(from, to, amount);
224         return true;
225     }
226 
227     /// @notice Approves `amount` from sender to be spend by `spender`.
228     /// @param spender Address of the party that can draw from msg.sender's account.
229     /// @param amount The maximum collective amount that `spender` can draw.
230     /// @return (bool) Returns True if approved.
231     function approve(address spender, uint256 amount) public override returns (bool) {
232         allowance[msg.sender][spender] = amount;
233         emit Approval(msg.sender, spender, amount);
234         return true;
235     }
236 
237     // solhint-disable-next-line func-name-mixedcase
238     function DOMAIN_SEPARATOR() external view returns (bytes32) {
239         return _domainSeparator();
240     }
241 
242     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
243     bytes32 private constant PERMIT_SIGNATURE_HASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
244 
245     /// @notice Approves `value` from `owner_` to be spend by `spender`.
246     /// @param owner_ Address of the owner.
247     /// @param spender The address of the spender that gets approved to draw from `owner_`.
248     /// @param value The maximum collective amount that `spender` can draw.
249     /// @param deadline This permit must be redeemed before this deadline (UTC timestamp in seconds).
250     function permit(
251         address owner_,
252         address spender,
253         uint256 value,
254         uint256 deadline,
255         uint8 v,
256         bytes32 r,
257         bytes32 s
258     ) external override {
259         require(owner_ != address(0), "ERC20: Owner cannot be 0");
260         require(block.timestamp < deadline, "ERC20: Expired");
261         require(
262             ecrecover(_getDigest(keccak256(abi.encode(PERMIT_SIGNATURE_HASH, owner_, spender, value, nonces[owner_]++, deadline))), v, r, s) ==
263                 owner_,
264             "ERC20: Invalid Signature"
265         );
266         allowance[owner_][spender] = value;
267         emit Approval(owner_, spender, value);
268     }
269 }
270 
271 contract ERC20WithSupply is IERC20, ERC20 {
272     uint256 public override totalSupply;
273 
274     function _mint(address user, uint256 amount) private {
275         uint256 newTotalSupply = totalSupply + amount;
276         require(newTotalSupply >= totalSupply, "Mint overflow");
277         totalSupply = newTotalSupply;
278         balanceOf[user] += amount;
279     }
280 
281     function _burn(address user, uint256 amount) private {
282         require(balanceOf[user] >= amount, "Burn too much");
283         totalSupply -= amount;
284         balanceOf[user] -= amount;
285     }
286 }
287 
288 // File @boringcrypto/boring-solidity/contracts/libraries/BoringRebase.sol@v1.2.2
289 // License-Identifier: MIT
290 pragma solidity 0.6.12;
291 
292 struct Rebase {
293     uint128 elastic;
294     uint128 base;
295 }
296 
297 /// @notice A rebasing library using overflow-/underflow-safe math.
298 library RebaseLibrary {
299     using BoringMath for uint256;
300     using BoringMath128 for uint128;
301 
302     /// @notice Calculates the base value in relationship to `elastic` and `total`.
303     function toBase(
304         Rebase memory total,
305         uint256 elastic,
306         bool roundUp
307     ) internal pure returns (uint256 base) {
308         if (total.elastic == 0) {
309             base = elastic;
310         } else {
311             base = elastic.mul(total.base) / total.elastic;
312             if (roundUp && base.mul(total.elastic) / total.base < elastic) {
313                 base = base.add(1);
314             }
315         }
316     }
317 
318     /// @notice Calculates the elastic value in relationship to `base` and `total`.
319     function toElastic(
320         Rebase memory total,
321         uint256 base,
322         bool roundUp
323     ) internal pure returns (uint256 elastic) {
324         if (total.base == 0) {
325             elastic = base;
326         } else {
327             elastic = base.mul(total.elastic) / total.base;
328             if (roundUp && elastic.mul(total.base) / total.elastic < base) {
329                 elastic = elastic.add(1);
330             }
331         }
332     }
333 
334     /// @notice Add `elastic` to `total` and doubles `total.base`.
335     /// @return (Rebase) The new total.
336     /// @return base in relationship to `elastic`.
337     function add(
338         Rebase memory total,
339         uint256 elastic,
340         bool roundUp
341     ) internal pure returns (Rebase memory, uint256 base) {
342         base = toBase(total, elastic, roundUp);
343         total.elastic = total.elastic.add(elastic.to128());
344         total.base = total.base.add(base.to128());
345         return (total, base);
346     }
347 
348     /// @notice Sub `base` from `total` and update `total.elastic`.
349     /// @return (Rebase) The new total.
350     /// @return elastic in relationship to `base`.
351     function sub(
352         Rebase memory total,
353         uint256 base,
354         bool roundUp
355     ) internal pure returns (Rebase memory, uint256 elastic) {
356         elastic = toElastic(total, base, roundUp);
357         total.elastic = total.elastic.sub(elastic.to128());
358         total.base = total.base.sub(base.to128());
359         return (total, elastic);
360     }
361 
362     /// @notice Add `elastic` and `base` to `total`.
363     function add(
364         Rebase memory total,
365         uint256 elastic,
366         uint256 base
367     ) internal pure returns (Rebase memory) {
368         total.elastic = total.elastic.add(elastic.to128());
369         total.base = total.base.add(base.to128());
370         return total;
371     }
372 
373     /// @notice Subtract `elastic` and `base` to `total`.
374     function sub(
375         Rebase memory total,
376         uint256 elastic,
377         uint256 base
378     ) internal pure returns (Rebase memory) {
379         total.elastic = total.elastic.sub(elastic.to128());
380         total.base = total.base.sub(base.to128());
381         return total;
382     }
383 
384     /// @notice Add `elastic` to `total` and update storage.
385     /// @return newElastic Returns updated `elastic`.
386     function addElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {
387         newElastic = total.elastic = total.elastic.add(elastic.to128());
388     }
389 
390     /// @notice Subtract `elastic` from `total` and update storage.
391     /// @return newElastic Returns updated `elastic`.
392     function subElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {
393         newElastic = total.elastic = total.elastic.sub(elastic.to128());
394     }
395 }
396 
397 // File @sushiswap/bentobox-sdk/contracts/IBatchFlashBorrower.sol@v1.0.2
398 // License-Identifier: MIT
399 pragma solidity 0.6.12;
400 
401 interface IBatchFlashBorrower {
402     function onBatchFlashLoan(
403         address sender,
404         IERC20[] calldata tokens,
405         uint256[] calldata amounts,
406         uint256[] calldata fees,
407         bytes calldata data
408     ) external;
409 }
410 
411 // File @sushiswap/bentobox-sdk/contracts/IFlashBorrower.sol@v1.0.2
412 // License-Identifier: MIT
413 pragma solidity 0.6.12;
414 
415 interface IFlashBorrower {
416     function onFlashLoan(
417         address sender,
418         IERC20 token,
419         uint256 amount,
420         uint256 fee,
421         bytes calldata data
422     ) external;
423 }
424 
425 // File @sushiswap/bentobox-sdk/contracts/IStrategy.sol@v1.0.2
426 // License-Identifier: MIT
427 pragma solidity 0.6.12;
428 
429 interface IStrategy {
430     // Send the assets to the Strategy and call skim to invest them
431     function skim(uint256 amount) external;
432 
433     // Harvest any profits made converted to the asset and pass them to the caller
434     function harvest(uint256 balance, address sender) external returns (int256 amountAdded);
435 
436     // Withdraw assets. The returned amount can differ from the requested amount due to rounding.
437     // The actualAmount should be very close to the amount. The difference should NOT be used to report a loss. That's what harvest is for.
438     function withdraw(uint256 amount) external returns (uint256 actualAmount);
439 
440     // Withdraw all assets in the safest way possible. This shouldn't fail.
441     function exit(uint256 balance) external returns (int256 amountAdded);
442 }
443 
444 // File @sushiswap/bentobox-sdk/contracts/IBentoBoxV1.sol@v1.0.2
445 // License-Identifier: MIT
446 pragma solidity 0.6.12;
447 pragma experimental ABIEncoderV2;
448 
449 interface IBentoBoxV1 {
450     event LogDeploy(address indexed masterContract, bytes data, address indexed cloneAddress);
451     event LogDeposit(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);
452     event LogFlashLoan(address indexed borrower, address indexed token, uint256 amount, uint256 feeAmount, address indexed receiver);
453     event LogRegisterProtocol(address indexed protocol);
454     event LogSetMasterContractApproval(address indexed masterContract, address indexed user, bool approved);
455     event LogStrategyDivest(address indexed token, uint256 amount);
456     event LogStrategyInvest(address indexed token, uint256 amount);
457     event LogStrategyLoss(address indexed token, uint256 amount);
458     event LogStrategyProfit(address indexed token, uint256 amount);
459     event LogStrategyQueued(address indexed token, address indexed strategy);
460     event LogStrategySet(address indexed token, address indexed strategy);
461     event LogStrategyTargetPercentage(address indexed token, uint256 targetPercentage);
462     event LogTransfer(address indexed token, address indexed from, address indexed to, uint256 share);
463     event LogWhiteListMasterContract(address indexed masterContract, bool approved);
464     event LogWithdraw(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);
465     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
466 
467     function balanceOf(IERC20, address) external view returns (uint256);
468 
469     function batch(bytes[] calldata calls, bool revertOnFail) external payable returns (bool[] memory successes, bytes[] memory results);
470 
471     function batchFlashLoan(
472         IBatchFlashBorrower borrower,
473         address[] calldata receivers,
474         IERC20[] calldata tokens,
475         uint256[] calldata amounts,
476         bytes calldata data
477     ) external;
478 
479     function claimOwnership() external;
480 
481     function deploy(
482         address masterContract,
483         bytes calldata data,
484         bool useCreate2
485     ) external payable;
486 
487     function deposit(
488         IERC20 token_,
489         address from,
490         address to,
491         uint256 amount,
492         uint256 share
493     ) external payable returns (uint256 amountOut, uint256 shareOut);
494 
495     function flashLoan(
496         IFlashBorrower borrower,
497         address receiver,
498         IERC20 token,
499         uint256 amount,
500         bytes calldata data
501     ) external;
502 
503     function harvest(
504         IERC20 token,
505         bool balance,
506         uint256 maxChangeAmount
507     ) external;
508 
509     function masterContractApproved(address, address) external view returns (bool);
510 
511     function masterContractOf(address) external view returns (address);
512 
513     function nonces(address) external view returns (uint256);
514 
515     function owner() external view returns (address);
516 
517     function pendingOwner() external view returns (address);
518 
519     function pendingStrategy(IERC20) external view returns (IStrategy);
520 
521     function permitToken(
522         IERC20 token,
523         address from,
524         address to,
525         uint256 amount,
526         uint256 deadline,
527         uint8 v,
528         bytes32 r,
529         bytes32 s
530     ) external;
531 
532     function registerProtocol() external;
533 
534     function setMasterContractApproval(
535         address user,
536         address masterContract,
537         bool approved,
538         uint8 v,
539         bytes32 r,
540         bytes32 s
541     ) external;
542 
543     function setStrategy(IERC20 token, IStrategy newStrategy) external;
544 
545     function setStrategyTargetPercentage(IERC20 token, uint64 targetPercentage_) external;
546 
547     function strategy(IERC20) external view returns (IStrategy);
548 
549     function strategyData(IERC20)
550         external
551         view
552         returns (
553             uint64 strategyStartDate,
554             uint64 targetPercentage,
555             uint128 balance
556         );
557 
558     function toAmount(
559         IERC20 token,
560         uint256 share,
561         bool roundUp
562     ) external view returns (uint256 amount);
563 
564     function toShare(
565         IERC20 token,
566         uint256 amount,
567         bool roundUp
568     ) external view returns (uint256 share);
569 
570     function totals(IERC20) external view returns (Rebase memory totals_);
571 
572     function transfer(
573         IERC20 token,
574         address from,
575         address to,
576         uint256 share
577     ) external;
578 
579     function transferMultiple(
580         IERC20 token,
581         address from,
582         address[] calldata tos,
583         uint256[] calldata shares
584     ) external;
585 
586     function transferOwnership(
587         address newOwner,
588         bool direct,
589         bool renounce
590     ) external;
591 
592     function whitelistMasterContract(address masterContract, bool approved) external;
593 
594     function whitelistedMasterContracts(address) external view returns (bool);
595 
596     function withdraw(
597         IERC20 token_,
598         address from,
599         address to,
600         uint256 amount,
601         uint256 share
602     ) external returns (uint256 amountOut, uint256 shareOut);
603 }
604 
605 // File @boringcrypto/boring-solidity/contracts/BoringOwnable.sol@v1.2.2
606 // License-Identifier: MIT
607 pragma solidity 0.6.12;
608 
609 // Audit on 5-Jan-2021 by Keno and BoringCrypto
610 // Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol + Claimable.sol
611 // Edited by BoringCrypto
612 
613 contract BoringOwnableData {
614     address public owner;
615     address public pendingOwner;
616 }
617 
618 contract BoringOwnable is BoringOwnableData {
619     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
620 
621     /// @notice `owner` defaults to msg.sender on construction.
622     constructor() public {
623         owner = msg.sender;
624         emit OwnershipTransferred(address(0), msg.sender);
625     }
626 
627     /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.
628     /// Can only be invoked by the current `owner`.
629     /// @param newOwner Address of the new owner.
630     /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.
631     /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.
632     function transferOwnership(
633         address newOwner,
634         bool direct,
635         bool renounce
636     ) public onlyOwner {
637         if (direct) {
638             // Checks
639             require(newOwner != address(0) || renounce, "Ownable: zero address");
640 
641             // Effects
642             emit OwnershipTransferred(owner, newOwner);
643             owner = newOwner;
644             pendingOwner = address(0);
645         } else {
646             // Effects
647             pendingOwner = newOwner;
648         }
649     }
650 
651     /// @notice Needs to be called by `pendingOwner` to claim ownership.
652     function claimOwnership() public {
653         address _pendingOwner = pendingOwner;
654 
655         // Checks
656         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
657 
658         // Effects
659         emit OwnershipTransferred(owner, _pendingOwner);
660         owner = _pendingOwner;
661         pendingOwner = address(0);
662     }
663 
664     /// @notice Only allows the `owner` to execute the function.
665     modifier onlyOwner() {
666         require(msg.sender == owner, "Ownable: caller is not the owner");
667         _;
668     }
669 }
670 
671 // File contracts/MagicInternetMoney.sol
672 // License-Identifier: MIT
673 
674 // Magic Internet Money
675 
676 // ███╗   ███╗██╗███╗   ███╗
677 // ████╗ ████║██║████╗ ████║
678 // ██╔████╔██║██║██╔████╔██║
679 // ██║╚██╔╝██║██║██║╚██╔╝██║
680 // ██║ ╚═╝ ██║██║██║ ╚═╝ ██║
681 // ╚═╝     ╚═╝╚═╝╚═╝     ╚═╝
682 
683 // BoringCrypto, 0xMerlin
684 
685 pragma solidity 0.6.12;
686 
687 /// @title Cauldron
688 /// @dev This contract allows contract calls to any contract (except BentoBox)
689 /// from arbitrary callers thus, don't trust calls from this contract in any circumstances.
690 contract MagicInternetMoneyV1 is ERC20, BoringOwnable {
691     using BoringMath for uint256;
692     // ERC20 'variables'
693     string public constant symbol = "MIM";
694     string public constant name = "Magic Internet Money";
695     uint8 public constant decimals = 18;
696     uint256 public override totalSupply;
697 
698     struct Minting {
699         uint128 time;
700         uint128 amount;
701     }
702 
703     Minting public lastMint;
704     uint256 private constant MINTING_PERIOD = 24 hours;
705     uint256 private constant MINTING_INCREASE = 15000;
706     uint256 private constant MINTING_PRECISION = 1e5;
707 
708     function mint(address to, uint256 amount) public onlyOwner {
709         require(to != address(0), "MIM: no mint to zero address");
710 
711         // Limits the amount minted per period to a convergence function, with the period duration restarting on every mint
712         uint256 totalMintedAmount = uint256(lastMint.time < block.timestamp - MINTING_PERIOD ? 0 : lastMint.amount).add(amount);
713         require(totalSupply == 0 || totalSupply.mul(MINTING_INCREASE) / MINTING_PRECISION >= totalMintedAmount);
714 
715         lastMint.time = block.timestamp.to128();
716         lastMint.amount = totalMintedAmount.to128();
717 
718         totalSupply = totalSupply + amount;
719         balanceOf[to] += amount;
720         emit Transfer(address(0), to, amount);
721     }
722 
723     function mintToBentoBox(
724         address clone,
725         uint256 amount,
726         IBentoBoxV1 bentoBox
727     ) public onlyOwner {
728         mint(address(bentoBox), amount);
729         bentoBox.deposit(IERC20(address(this)), address(bentoBox), clone, amount, 0);
730     }
731 
732     function burn(uint256 amount) public {
733         require(amount <= balanceOf[msg.sender], "MIM: not enough");
734 
735         balanceOf[msg.sender] -= amount;
736         totalSupply -= amount;
737         emit Transfer(msg.sender, address(0), amount);
738     }
739 }