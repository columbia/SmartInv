1 // SPDX-License-Identifier: UNLICENSED
2 // Kashi Lending Medium Risk
3 
4 //  __  __             __    __      _____                  __ __
5 // |  |/  .---.-.-----|  |--|__|    |     |_.-----.-----.--|  |__.-----.-----.
6 // |     <|  _  |__ --|     |  |    |       |  -__|     |  _  |  |     |  _  |
7 // |__|\__|___._|_____|__|__|__|    |_______|_____|__|__|_____|__|__|__|___  |
8 //                                                                     |_____|
9 
10 // Copyright (c) 2021 BoringCrypto - All rights reserved
11 // Twitter: @Boring_Crypto
12 
13 // Special thanks to:
14 // @0xKeno - for all his invaluable contributions
15 // @burger_crypto - for the idea of trying to let the LPs benefit from liquidations
16 
17 // Version: 22-Feb-2021
18 pragma solidity 0.6.12;
19 pragma experimental ABIEncoderV2;
20 
21 // solhint-disable avoid-low-level-calls
22 // solhint-disable no-inline-assembly
23 // solhint-disable not-rely-on-time
24 
25 // File @boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol@v1.2.0
26 // License-Identifier: MIT
27 
28 /// @notice A library for performing overflow-/underflow-safe math,
29 /// updated with awesomeness from of DappHub (https://github.com/dapphub/ds-math).
30 library BoringMath {
31     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
32         require((c = a + b) >= b, "BoringMath: Add Overflow");
33     }
34 
35     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
36         require((c = a - b) <= a, "BoringMath: Underflow");
37     }
38 
39     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
40         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
41     }
42 
43     function to128(uint256 a) internal pure returns (uint128 c) {
44         require(a <= uint128(-1), "BoringMath: uint128 Overflow");
45         c = uint128(a);
46     }
47 
48     function to64(uint256 a) internal pure returns (uint64 c) {
49         require(a <= uint64(-1), "BoringMath: uint64 Overflow");
50         c = uint64(a);
51     }
52 
53     function to32(uint256 a) internal pure returns (uint32 c) {
54         require(a <= uint32(-1), "BoringMath: uint32 Overflow");
55         c = uint32(a);
56     }
57 }
58 
59 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint128.
60 library BoringMath128 {
61     function add(uint128 a, uint128 b) internal pure returns (uint128 c) {
62         require((c = a + b) >= b, "BoringMath: Add Overflow");
63     }
64 
65     function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {
66         require((c = a - b) <= a, "BoringMath: Underflow");
67     }
68 }
69 
70 // File @boringcrypto/boring-solidity/contracts/BoringOwnable.sol@v1.2.0
71 // License-Identifier: MIT
72 
73 // Audit on 5-Jan-2021 by Keno and BoringCrypto
74 // Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol + Claimable.sol
75 // Edited by BoringCrypto
76 
77 contract BoringOwnableData {
78     address public owner;
79     address public pendingOwner;
80 }
81 
82 contract BoringOwnable is BoringOwnableData {
83     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
84 
85     /// @notice `owner` defaults to msg.sender on construction.
86     constructor() public {
87         owner = msg.sender;
88         emit OwnershipTransferred(address(0), msg.sender);
89     }
90 
91     /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.
92     /// Can only be invoked by the current `owner`.
93     /// @param newOwner Address of the new owner.
94     /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.
95     /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.
96     function transferOwnership(
97         address newOwner,
98         bool direct,
99         bool renounce
100     ) public onlyOwner {
101         if (direct) {
102             // Checks
103             require(newOwner != address(0) || renounce, "Ownable: zero address");
104 
105             // Effects
106             emit OwnershipTransferred(owner, newOwner);
107             owner = newOwner;
108             pendingOwner = address(0);
109         } else {
110             // Effects
111             pendingOwner = newOwner;
112         }
113     }
114 
115     /// @notice Needs to be called by `pendingOwner` to claim ownership.
116     function claimOwnership() public {
117         address _pendingOwner = pendingOwner;
118 
119         // Checks
120         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
121 
122         // Effects
123         emit OwnershipTransferred(owner, _pendingOwner);
124         owner = _pendingOwner;
125         pendingOwner = address(0);
126     }
127 
128     /// @notice Only allows the `owner` to execute the function.
129     modifier onlyOwner() {
130         require(msg.sender == owner, "Ownable: caller is not the owner");
131         _;
132     }
133 }
134 
135 // File @boringcrypto/boring-solidity/contracts/Domain.sol@v1.2.0
136 // License-Identifier: MIT
137 // Based on code and smartness by Ross Campbell and Keno
138 // Uses immutable to store the domain separator to reduce gas usage
139 // If the chain id changes due to a fork, the forked chain will calculate on the fly.
140 
141 contract Domain {
142     bytes32 private constant DOMAIN_SEPARATOR_SIGNATURE_HASH = keccak256("EIP712Domain(uint256 chainId,address verifyingContract)");
143     // See https://eips.ethereum.org/EIPS/eip-191
144     string private constant EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA = "\x19\x01";
145 
146     // solhint-disable var-name-mixedcase
147     bytes32 private immutable _DOMAIN_SEPARATOR;
148     uint256 private immutable DOMAIN_SEPARATOR_CHAIN_ID;
149 
150     /// @dev Calculate the DOMAIN_SEPARATOR
151     function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32) {
152         return keccak256(abi.encode(DOMAIN_SEPARATOR_SIGNATURE_HASH, chainId, address(this)));
153     }
154 
155     constructor() public {
156         uint256 chainId;
157         assembly {
158             chainId := chainid()
159         }
160         _DOMAIN_SEPARATOR = _calculateDomainSeparator(DOMAIN_SEPARATOR_CHAIN_ID = chainId);
161     }
162 
163     /// @dev Return the DOMAIN_SEPARATOR
164     // It's named internal to allow making it public from the contract that uses it by creating a simple view function
165     // with the desired public name, such as DOMAIN_SEPARATOR or domainSeparator.
166     // solhint-disable-next-line func-name-mixedcase
167     function DOMAIN_SEPARATOR() public view returns (bytes32) {
168         uint256 chainId;
169         assembly {
170             chainId := chainid()
171         }
172         return chainId == DOMAIN_SEPARATOR_CHAIN_ID ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId);
173     }
174 
175     function _getDigest(bytes32 dataHash) internal view returns (bytes32 digest) {
176         digest = keccak256(abi.encodePacked(EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA, DOMAIN_SEPARATOR(), dataHash));
177     }
178 }
179 
180 // File @boringcrypto/boring-solidity/contracts/ERC20.sol@v1.2.0
181 // License-Identifier: MIT
182 
183 // solhint-disable no-inline-assembly
184 // solhint-disable not-rely-on-time
185 
186 // Data part taken out for building of contracts that receive delegate calls
187 contract ERC20Data {
188     /// @notice owner > balance mapping.
189     mapping(address => uint256) public balanceOf;
190     /// @notice owner > spender > allowance mapping.
191     mapping(address => mapping(address => uint256)) public allowance;
192     /// @notice owner > nonce mapping. Used in `permit`.
193     mapping(address => uint256) public nonces;
194 }
195 
196 contract ERC20 is ERC20Data, Domain {
197     event Transfer(address indexed _from, address indexed _to, uint256 _value);
198     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
199 
200     /// @notice Transfers `amount` tokens from `msg.sender` to `to`.
201     /// @param to The address to move the tokens.
202     /// @param amount of the tokens to move.
203     /// @return (bool) Returns True if succeeded.
204     function transfer(address to, uint256 amount) public returns (bool) {
205         // If `amount` is 0, or `msg.sender` is `to` nothing happens
206         if (amount != 0) {
207             uint256 srcBalance = balanceOf[msg.sender];
208             require(srcBalance >= amount, "ERC20: balance too low");
209             if (msg.sender != to) {
210                 require(to != address(0), "ERC20: no zero address"); // Moved down so low balance calls safe some gas
211 
212                 balanceOf[msg.sender] = srcBalance - amount; // Underflow is checked
213                 balanceOf[to] += amount; // Can't overflow because totalSupply would be greater than 2^256-1
214             }
215         }
216         emit Transfer(msg.sender, to, amount);
217         return true;
218     }
219 
220     /// @notice Transfers `amount` tokens from `from` to `to`. Caller needs approval for `from`.
221     /// @param from Address to draw tokens from.
222     /// @param to The address to move the tokens.
223     /// @param amount The token amount to move.
224     /// @return (bool) Returns True if succeeded.
225     function transferFrom(
226         address from,
227         address to,
228         uint256 amount
229     ) public returns (bool) {
230         // If `amount` is 0, or `from` is `to` nothing happens
231         if (amount != 0) {
232             uint256 srcBalance = balanceOf[from];
233             require(srcBalance >= amount, "ERC20: balance too low");
234 
235             if (from != to) {
236                 uint256 spenderAllowance = allowance[from][msg.sender];
237                 // If allowance is infinite, don't decrease it to save on gas (breaks with EIP-20).
238                 if (spenderAllowance != type(uint256).max) {
239                     require(spenderAllowance >= amount, "ERC20: allowance too low");
240                     allowance[from][msg.sender] = spenderAllowance - amount; // Underflow is checked
241                 }
242                 require(to != address(0), "ERC20: no zero address"); // Moved down so other failed calls safe some gas
243 
244                 balanceOf[from] = srcBalance - amount; // Underflow is checked
245                 balanceOf[to] += amount; // Can't overflow because totalSupply would be greater than 2^256-1
246             }
247         }
248         emit Transfer(from, to, amount);
249         return true;
250     }
251 
252     /// @notice Approves `amount` from sender to be spend by `spender`.
253     /// @param spender Address of the party that can draw from msg.sender's account.
254     /// @param amount The maximum collective amount that `spender` can draw.
255     /// @return (bool) Returns True if approved.
256     function approve(address spender, uint256 amount) public returns (bool) {
257         allowance[msg.sender][spender] = amount;
258         emit Approval(msg.sender, spender, amount);
259         return true;
260     }
261 
262     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
263     bytes32 private constant PERMIT_SIGNATURE_HASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
264 
265     /// @notice Approves `value` from `owner_` to be spend by `spender`.
266     /// @param owner_ Address of the owner.
267     /// @param spender The address of the spender that gets approved to draw from `owner_`.
268     /// @param value The maximum collective amount that `spender` can draw.
269     /// @param deadline This permit must be redeemed before this deadline (UTC timestamp in seconds).
270     function permit(
271         address owner_,
272         address spender,
273         uint256 value,
274         uint256 deadline,
275         uint8 v,
276         bytes32 r,
277         bytes32 s
278     ) external {
279         require(owner_ != address(0), "ERC20: Owner cannot be 0");
280         require(block.timestamp < deadline, "ERC20: Expired");
281         require(
282             ecrecover(_getDigest(keccak256(abi.encode(PERMIT_SIGNATURE_HASH, owner_, spender, value, nonces[owner_]++, deadline))), v, r, s) ==
283                 owner_,
284             "ERC20: Invalid Signature"
285         );
286         allowance[owner_][spender] = value;
287         emit Approval(owner_, spender, value);
288     }
289 }
290 
291 // File @boringcrypto/boring-solidity/contracts/interfaces/IMasterContract.sol@v1.2.0
292 // License-Identifier: MIT
293 
294 interface IMasterContract {
295     /// @notice Init function that gets called from `BoringFactory.deploy`.
296     /// Also kown as the constructor for cloned contracts.
297     /// Any ETH send to `BoringFactory.deploy` ends up here.
298     /// @param data Can be abi encoded arguments or anything else.
299     function init(bytes calldata data) external payable;
300 }
301 
302 // File @boringcrypto/boring-solidity/contracts/libraries/BoringRebase.sol@v1.2.0
303 // License-Identifier: MIT
304 
305 struct Rebase {
306     uint128 elastic;
307     uint128 base;
308 }
309 
310 /// @notice A rebasing library using overflow-/underflow-safe math.
311 library RebaseLibrary {
312     using BoringMath for uint256;
313     using BoringMath128 for uint128;
314 
315     /// @notice Calculates the base value in relationship to `elastic` and `total`.
316     function toBase(
317         Rebase memory total,
318         uint256 elastic,
319         bool roundUp
320     ) internal pure returns (uint256 base) {
321         if (total.elastic == 0) {
322             base = elastic;
323         } else {
324             base = elastic.mul(total.base) / total.elastic;
325             if (roundUp && base.mul(total.elastic) / total.base < elastic) {
326                 base = base.add(1);
327             }
328         }
329     }
330 
331     /// @notice Calculates the elastic value in relationship to `base` and `total`.
332     function toElastic(
333         Rebase memory total,
334         uint256 base,
335         bool roundUp
336     ) internal pure returns (uint256 elastic) {
337         if (total.base == 0) {
338             elastic = base;
339         } else {
340             elastic = base.mul(total.elastic) / total.base;
341             if (roundUp && elastic.mul(total.base) / total.elastic < base) {
342                 elastic = elastic.add(1);
343             }
344         }
345     }
346 
347     /// @notice Add `elastic` to `total` and doubles `total.base`.
348     /// @return (Rebase) The new total.
349     /// @return base in relationship to `elastic`.
350     function add(
351         Rebase memory total,
352         uint256 elastic,
353         bool roundUp
354     ) internal pure returns (Rebase memory, uint256 base) {
355         base = toBase(total, elastic, roundUp);
356         total.elastic = total.elastic.add(elastic.to128());
357         total.base = total.base.add(base.to128());
358         return (total, base);
359     }
360 
361     /// @notice Sub `base` from `total` and update `total.elastic`.
362     /// @return (Rebase) The new total.
363     /// @return elastic in relationship to `base`.
364     function sub(
365         Rebase memory total,
366         uint256 base,
367         bool roundUp
368     ) internal pure returns (Rebase memory, uint256 elastic) {
369         elastic = toElastic(total, base, roundUp);
370         total.elastic = total.elastic.sub(elastic.to128());
371         total.base = total.base.sub(base.to128());
372         return (total, elastic);
373     }
374 
375     /// @notice Add `elastic` and `base` to `total`.
376     function add(
377         Rebase memory total,
378         uint256 elastic,
379         uint256 base
380     ) internal pure returns (Rebase memory) {
381         total.elastic = total.elastic.add(elastic.to128());
382         total.base = total.base.add(base.to128());
383         return total;
384     }
385 
386     /// @notice Subtract `elastic` and `base` to `total`.
387     function sub(
388         Rebase memory total,
389         uint256 elastic,
390         uint256 base
391     ) internal pure returns (Rebase memory) {
392         total.elastic = total.elastic.sub(elastic.to128());
393         total.base = total.base.sub(base.to128());
394         return total;
395     }
396 }
397 
398 // File @boringcrypto/boring-solidity/contracts/interfaces/IERC20.sol@v1.2.0
399 // License-Identifier: MIT
400 
401 interface IERC20 {
402     function totalSupply() external view returns (uint256);
403 
404     function balanceOf(address account) external view returns (uint256);
405 
406     function allowance(address owner, address spender) external view returns (uint256);
407 
408     function approve(address spender, uint256 amount) external returns (bool);
409 
410     event Transfer(address indexed from, address indexed to, uint256 value);
411     event Approval(address indexed owner, address indexed spender, uint256 value);
412 
413     /// @notice EIP 2612
414     function permit(
415         address owner,
416         address spender,
417         uint256 value,
418         uint256 deadline,
419         uint8 v,
420         bytes32 r,
421         bytes32 s
422     ) external;
423 }
424 
425 // File @boringcrypto/boring-solidity/contracts/libraries/BoringERC20.sol@v1.2.0
426 // License-Identifier: MIT
427 
428 library BoringERC20 {
429     bytes4 private constant SIG_SYMBOL = 0x95d89b41; // symbol()
430     bytes4 private constant SIG_NAME = 0x06fdde03; // name()
431     bytes4 private constant SIG_DECIMALS = 0x313ce567; // decimals()
432     bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)
433     bytes4 private constant SIG_TRANSFER_FROM = 0x23b872dd; // transferFrom(address,address,uint256)
434 
435     function returnDataToString(bytes memory data) internal pure returns (string memory) {
436         if (data.length >= 64) {
437             return abi.decode(data, (string));
438         } else if (data.length == 32) {
439             uint8 i = 0;
440             while (i < 32 && data[i] != 0) {
441                 i++;
442             }
443             bytes memory bytesArray = new bytes(i);
444             for (i = 0; i < 32 && data[i] != 0; i++) {
445                 bytesArray[i] = data[i];
446             }
447             return string(bytesArray);
448         } else {
449             return "???";
450         }
451     }
452 
453     /// @notice Provides a safe ERC20.symbol version which returns '???' as fallback string.
454     /// @param token The address of the ERC-20 token contract.
455     /// @return (string) Token symbol.
456     function safeSymbol(IERC20 token) internal view returns (string memory) {
457         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_SYMBOL));
458         return success ? returnDataToString(data) : "???";
459     }
460 
461     /// @notice Provides a safe ERC20.name version which returns '???' as fallback string.
462     /// @param token The address of the ERC-20 token contract.
463     /// @return (string) Token name.
464     function safeName(IERC20 token) internal view returns (string memory) {
465         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_NAME));
466         return success ? returnDataToString(data) : "???";
467     }
468 
469     /// @notice Provides a safe ERC20.decimals version which returns '18' as fallback value.
470     /// @param token The address of the ERC-20 token contract.
471     /// @return (uint8) Token decimals.
472     function safeDecimals(IERC20 token) internal view returns (uint8) {
473         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_DECIMALS));
474         return success && data.length == 32 ? abi.decode(data, (uint8)) : 18;
475     }
476 }
477 
478 // File @sushiswap/bentobox-sdk/contracts/IBatchFlashBorrower.sol@v1.0.1
479 // License-Identifier: MIT
480 
481 interface IBatchFlashBorrower {
482     function onBatchFlashLoan(
483         address sender,
484         IERC20[] calldata tokens,
485         uint256[] calldata amounts,
486         uint256[] calldata fees,
487         bytes calldata data
488     ) external;
489 }
490 
491 // File @sushiswap/bentobox-sdk/contracts/IFlashBorrower.sol@v1.0.1
492 // License-Identifier: MIT
493 
494 interface IFlashBorrower {
495     function onFlashLoan(
496         address sender,
497         IERC20 token,
498         uint256 amount,
499         uint256 fee,
500         bytes calldata data
501     ) external;
502 }
503 
504 // File @sushiswap/bentobox-sdk/contracts/IStrategy.sol@v1.0.1
505 // License-Identifier: MIT
506 
507 interface IStrategy {
508     // Send the assets to the Strategy and call skim to invest them
509     function skim(uint256 amount) external;
510 
511     // Harvest any profits made converted to the asset and pass them to the caller
512     function harvest(uint256 balance, address sender) external returns (int256 amountAdded);
513 
514     // Withdraw assets. The returned amount can differ from the requested amount due to rounding.
515     // The actualAmount should be very close to the amount. The difference should NOT be used to report a loss. That's what harvest is for.
516     function withdraw(uint256 amount) external returns (uint256 actualAmount);
517 
518     // Withdraw all assets in the safest way possible. This shouldn't fail.
519     function exit(uint256 balance) external returns (int256 amountAdded);
520 }
521 
522 // File @sushiswap/bentobox-sdk/contracts/IBentoBoxV1.sol@v1.0.1
523 // License-Identifier: MIT
524 
525 interface IBentoBoxV1 {
526     event LogDeploy(address indexed masterContract, bytes data, address indexed cloneAddress);
527     event LogDeposit(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);
528     event LogFlashLoan(address indexed borrower, address indexed token, uint256 amount, uint256 feeAmount, address indexed receiver);
529     event LogRegisterProtocol(address indexed protocol);
530     event LogSetMasterContractApproval(address indexed masterContract, address indexed user, bool approved);
531     event LogStrategyDivest(address indexed token, uint256 amount);
532     event LogStrategyInvest(address indexed token, uint256 amount);
533     event LogStrategyLoss(address indexed token, uint256 amount);
534     event LogStrategyProfit(address indexed token, uint256 amount);
535     event LogStrategyQueued(address indexed token, address indexed strategy);
536     event LogStrategySet(address indexed token, address indexed strategy);
537     event LogStrategyTargetPercentage(address indexed token, uint256 targetPercentage);
538     event LogTransfer(address indexed token, address indexed from, address indexed to, uint256 share);
539     event LogWhiteListMasterContract(address indexed masterContract, bool approved);
540     event LogWithdraw(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);
541     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
542 
543     function balanceOf(IERC20, address) external view returns (uint256);
544 
545     function batch(bytes[] calldata calls, bool revertOnFail) external payable returns (bool[] memory successes, bytes[] memory results);
546 
547     function batchFlashLoan(
548         IBatchFlashBorrower borrower,
549         address[] calldata receivers,
550         IERC20[] calldata tokens,
551         uint256[] calldata amounts,
552         bytes calldata data
553     ) external;
554 
555     function claimOwnership() external;
556 
557     function deploy(
558         address masterContract,
559         bytes calldata data,
560         bool useCreate2
561     ) external payable;
562 
563     function deposit(
564         IERC20 token_,
565         address from,
566         address to,
567         uint256 amount,
568         uint256 share
569     ) external payable returns (uint256 amountOut, uint256 shareOut);
570 
571     function flashLoan(
572         IFlashBorrower borrower,
573         address receiver,
574         IERC20 token,
575         uint256 amount,
576         bytes calldata data
577     ) external;
578 
579     function harvest(
580         IERC20 token,
581         bool balance,
582         uint256 maxChangeAmount
583     ) external;
584 
585     function masterContractApproved(address, address) external view returns (bool);
586 
587     function masterContractOf(address) external view returns (address);
588 
589     function nonces(address) external view returns (uint256);
590 
591     function owner() external view returns (address);
592 
593     function pendingOwner() external view returns (address);
594 
595     function pendingStrategy(IERC20) external view returns (IStrategy);
596 
597     function permitToken(
598         IERC20 token,
599         address from,
600         address to,
601         uint256 amount,
602         uint256 deadline,
603         uint8 v,
604         bytes32 r,
605         bytes32 s
606     ) external;
607 
608     function registerProtocol() external;
609 
610     function setMasterContractApproval(
611         address user,
612         address masterContract,
613         bool approved,
614         uint8 v,
615         bytes32 r,
616         bytes32 s
617     ) external;
618 
619     function setStrategy(IERC20 token, IStrategy newStrategy) external;
620 
621     function setStrategyTargetPercentage(IERC20 token, uint64 targetPercentage_) external;
622 
623     function strategy(IERC20) external view returns (IStrategy);
624 
625     function strategyData(IERC20)
626         external
627         view
628         returns (
629             uint64 strategyStartDate,
630             uint64 targetPercentage,
631             uint128 balance
632         );
633 
634     function toAmount(
635         IERC20 token,
636         uint256 share,
637         bool roundUp
638     ) external view returns (uint256 amount);
639 
640     function toShare(
641         IERC20 token,
642         uint256 amount,
643         bool roundUp
644     ) external view returns (uint256 share);
645 
646     function totals(IERC20) external view returns (Rebase memory totals_);
647 
648     function transfer(
649         IERC20 token,
650         address from,
651         address to,
652         uint256 share
653     ) external;
654 
655     function transferMultiple(
656         IERC20 token,
657         address from,
658         address[] calldata tos,
659         uint256[] calldata shares
660     ) external;
661 
662     function transferOwnership(
663         address newOwner,
664         bool direct,
665         bool renounce
666     ) external;
667 
668     function whitelistMasterContract(address masterContract, bool approved) external;
669 
670     function whitelistedMasterContracts(address) external view returns (bool);
671 
672     function withdraw(
673         IERC20 token_,
674         address from,
675         address to,
676         uint256 amount,
677         uint256 share
678     ) external returns (uint256 amountOut, uint256 shareOut);
679 }
680 
681 // File contracts/interfaces/IOracle.sol
682 // License-Identifier: MIT
683 
684 interface IOracle {
685     /// @notice Get the latest exchange rate.
686     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
687     /// For example:
688     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
689     /// @return success if no valid (recent) rate is available, return false else true.
690     /// @return rate The rate of the requested asset / pair / pool.
691     function get(bytes calldata data) external returns (bool success, uint256 rate);
692 
693     /// @notice Check the last exchange rate without any state changes.
694     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
695     /// For example:
696     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
697     /// @return success if no valid (recent) rate is available, return false else true.
698     /// @return rate The rate of the requested asset / pair / pool.
699     function peek(bytes calldata data) external view returns (bool success, uint256 rate);
700 
701     /// @notice Check the current spot exchange rate without any state changes. For oracles like TWAP this will be different from peek().
702     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
703     /// For example:
704     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
705     /// @return rate The rate of the requested asset / pair / pool.
706     function peekSpot(bytes calldata data) external view returns (uint256 rate);
707 
708     /// @notice Returns a human readable (short) name about this oracle.
709     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
710     /// For example:
711     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
712     /// @return (string) A human readable symbol name about this oracle.
713     function symbol(bytes calldata data) external view returns (string memory);
714 
715     /// @notice Returns a human readable name about this oracle.
716     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
717     /// For example:
718     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
719     /// @return (string) A human readable name about this oracle.
720     function name(bytes calldata data) external view returns (string memory);
721 }
722 
723 // File contracts/interfaces/ISwapper.sol
724 // License-Identifier: MIT
725 
726 interface ISwapper {
727     /// @notice Withdraws 'amountFrom' of token 'from' from the BentoBox account for this swapper.
728     /// Swaps it for at least 'amountToMin' of token 'to'.
729     /// Transfers the swapped tokens of 'to' into the BentoBox using a plain ERC20 transfer.
730     /// Returns the amount of tokens 'to' transferred to BentoBox.
731     /// (The BentoBox skim function will be used by the caller to get the swapped funds).
732     function swap(
733         IERC20 fromToken,
734         IERC20 toToken,
735         address recipient,
736         uint256 shareToMin,
737         uint256 shareFrom
738     ) external returns (uint256 extraShare, uint256 shareReturned);
739 
740     /// @notice Calculates the amount of token 'from' needed to complete the swap (amountFrom),
741     /// this should be less than or equal to amountFromMax.
742     /// Withdraws 'amountFrom' of token 'from' from the BentoBox account for this swapper.
743     /// Swaps it for exactly 'exactAmountTo' of token 'to'.
744     /// Transfers the swapped tokens of 'to' into the BentoBox using a plain ERC20 transfer.
745     /// Transfers allocated, but unused 'from' tokens within the BentoBox to 'refundTo' (amountFromMax - amountFrom).
746     /// Returns the amount of 'from' tokens withdrawn from BentoBox (amountFrom).
747     /// (The BentoBox skim function will be used by the caller to get the swapped funds).
748     function swapExact(
749         IERC20 fromToken,
750         IERC20 toToken,
751         address recipient,
752         address refundTo,
753         uint256 shareFromSupplied,
754         uint256 shareToExact
755     ) external returns (uint256 shareUsed, uint256 shareReturned);
756 }
757 
758 // File contracts/KashiPair.sol
759 // License-Identifier: UNLICENSED
760 // Kashi Lending Medium Risk
761 
762 /// @title KashiPair
763 /// @dev This contract allows contract calls to any contract (except BentoBox)
764 /// from arbitrary callers thus, don't trust calls from this contract in any circumstances.
765 contract KashiPairMediumRiskV1 is ERC20, BoringOwnable, IMasterContract {
766     using BoringMath for uint256;
767     using BoringMath128 for uint128;
768     using RebaseLibrary for Rebase;
769     using BoringERC20 for IERC20;
770 
771     event LogExchangeRate(uint256 rate);
772     event LogAccrue(uint256 accruedAmount, uint256 feeFraction, uint64 rate, uint256 utilization);
773     event LogAddCollateral(address indexed from, address indexed to, uint256 share);
774     event LogAddAsset(address indexed from, address indexed to, uint256 share, uint256 fraction);
775     event LogRemoveCollateral(address indexed from, address indexed to, uint256 share);
776     event LogRemoveAsset(address indexed from, address indexed to, uint256 share, uint256 fraction);
777     event LogBorrow(address indexed from, address indexed to, uint256 amount, uint256 feeAmount, uint256 part);
778     event LogRepay(address indexed from, address indexed to, uint256 amount, uint256 part);
779     event LogFeeTo(address indexed newFeeTo);
780     event LogWithdrawFees(address indexed feeTo, uint256 feesEarnedFraction);
781 
782     // Immutables (for MasterContract and all clones)
783     IBentoBoxV1 public immutable bentoBox;
784     KashiPairMediumRiskV1 public immutable masterContract;
785 
786     // MasterContract variables
787     address public feeTo;
788     mapping(ISwapper => bool) public swappers;
789 
790     // Per clone variables
791     // Clone init settings
792     IERC20 public collateral;
793     IERC20 public asset;
794     IOracle public oracle;
795     bytes public oracleData;
796 
797     // Total amounts
798     uint256 public totalCollateralShare; // Total collateral supplied
799     Rebase public totalAsset; // elastic = BentoBox shares held by the KashiPair, base = Total fractions held by asset suppliers
800     Rebase public totalBorrow; // elastic = Total token amount to be repayed by borrowers, base = Total parts of the debt held by borrowers
801 
802     // User balances
803     mapping(address => uint256) public userCollateralShare;
804     // userAssetFraction is called balanceOf for ERC20 compatibility (it's in ERC20.sol)
805     mapping(address => uint256) public userBorrowPart;
806 
807     /// @notice Exchange and interest rate tracking.
808     /// This is 'cached' here because calls to Oracles can be very expensive.
809     uint256 public exchangeRate;
810 
811     struct AccrueInfo {
812         uint64 interestPerSecond;
813         uint64 lastAccrued;
814         uint128 feesEarnedFraction;
815     }
816 
817     AccrueInfo public accrueInfo;
818 
819     // ERC20 'variables'
820     function symbol() external view returns (string memory) {
821         return string(abi.encodePacked("km", collateral.safeSymbol(), "/", asset.safeSymbol(), "-", oracle.symbol(oracleData)));
822     }
823 
824     function name() external view returns (string memory) {
825         return string(abi.encodePacked("Kashi Medium Risk ", collateral.safeName(), "/", asset.safeName(), "-", oracle.name(oracleData)));
826     }
827 
828     function decimals() external view returns (uint8) {
829         return asset.safeDecimals();
830     }
831 
832     // totalSupply for ERC20 compatibility
833     function totalSupply() public view returns (uint256) {
834         return totalAsset.base;
835     }
836 
837     // Settings for the Medium Risk KashiPair
838     uint256 private constant CLOSED_COLLATERIZATION_RATE = 75000; // 75%
839     uint256 private constant OPEN_COLLATERIZATION_RATE = 77000; // 77%
840     uint256 private constant COLLATERIZATION_RATE_PRECISION = 1e5; // Must be less than EXCHANGE_RATE_PRECISION (due to optimization in math)
841     uint256 private constant MINIMUM_TARGET_UTILIZATION = 7e17; // 70%
842     uint256 private constant MAXIMUM_TARGET_UTILIZATION = 8e17; // 80%
843     uint256 private constant UTILIZATION_PRECISION = 1e18;
844     uint256 private constant FULL_UTILIZATION = 1e18;
845     uint256 private constant FULL_UTILIZATION_MINUS_MAX = FULL_UTILIZATION - MAXIMUM_TARGET_UTILIZATION;
846     uint256 private constant FACTOR_PRECISION = 1e18;
847 
848     uint64 private constant STARTING_INTEREST_PER_SECOND = 317097920; // approx 1% APR
849     uint64 private constant MINIMUM_INTEREST_PER_SECOND = 79274480; // approx 0.25% APR
850     uint64 private constant MAXIMUM_INTEREST_PER_SECOND = 317097920000; // approx 1000% APR
851     uint256 private constant INTEREST_ELASTICITY = 28800e36; // Half or double in 28800 seconds (8 hours) if linear
852 
853     uint256 private constant EXCHANGE_RATE_PRECISION = 1e18;
854 
855     uint256 private constant LIQUIDATION_MULTIPLIER = 112000; // add 12%
856     uint256 private constant LIQUIDATION_MULTIPLIER_PRECISION = 1e5;
857 
858     // Fees
859     uint256 private constant PROTOCOL_FEE = 10000; // 10%
860     uint256 private constant PROTOCOL_FEE_DIVISOR = 1e5;
861     uint256 private constant BORROW_OPENING_FEE = 50; // 0.05%
862     uint256 private constant BORROW_OPENING_FEE_PRECISION = 1e5;
863 
864     /// @notice The constructor is only used for the initial master contract. Subsequent clones are initialised via `init`.
865     constructor(IBentoBoxV1 bentoBox_) public {
866         bentoBox = bentoBox_;
867         masterContract = this;
868     }
869 
870     /// @notice Serves as the constructor for clones, as clones can't have a regular constructor
871     /// @dev `data` is abi encoded in the format: (IERC20 collateral, IERC20 asset, IOracle oracle, bytes oracleData)
872     function init(bytes calldata data) public payable override {
873         require(address(collateral) == address(0), "KashiPair: already initialized");
874         (collateral, asset, oracle, oracleData) = abi.decode(data, (IERC20, IERC20, IOracle, bytes));
875         require(address(collateral) != address(0), "KashiPair: bad pair");
876 
877         accrueInfo.interestPerSecond = uint64(STARTING_INTEREST_PER_SECOND); // 1% APR, with 1e18 being 100%
878     }
879 
880     /// @notice Accrues the interest on the borrowed tokens and handles the accumulation of fees.
881     function accrue() public {
882         AccrueInfo memory _accrueInfo = accrueInfo;
883         // Number of seconds since accrue was called
884         uint256 elapsedTime = block.timestamp - _accrueInfo.lastAccrued;
885         if (elapsedTime == 0) {
886             return;
887         }
888         _accrueInfo.lastAccrued = uint64(block.timestamp);
889 
890         Rebase memory _totalBorrow = totalBorrow;
891         if (_totalBorrow.base == 0) {
892             // If there are no borrows, reset the interest rate
893             if (_accrueInfo.interestPerSecond != STARTING_INTEREST_PER_SECOND) {
894                 _accrueInfo.interestPerSecond = STARTING_INTEREST_PER_SECOND;
895                 emit LogAccrue(0, 0, STARTING_INTEREST_PER_SECOND, 0);
896             }
897             accrueInfo = _accrueInfo;
898             return;
899         }
900 
901         uint256 extraAmount = 0;
902         uint256 feeFraction = 0;
903         Rebase memory _totalAsset = totalAsset;
904 
905         // Accrue interest
906         extraAmount = uint256(_totalBorrow.elastic).mul(_accrueInfo.interestPerSecond).mul(elapsedTime) / 1e18;
907         _totalBorrow.elastic = _totalBorrow.elastic.add(extraAmount.to128());
908         uint256 fullAssetAmount = bentoBox.toAmount(asset, _totalAsset.elastic, false).add(_totalBorrow.elastic);
909 
910         uint256 feeAmount = extraAmount.mul(PROTOCOL_FEE) / PROTOCOL_FEE_DIVISOR; // % of interest paid goes to fee
911         feeFraction = feeAmount.mul(_totalAsset.base) / fullAssetAmount;
912         _accrueInfo.feesEarnedFraction = _accrueInfo.feesEarnedFraction.add(feeFraction.to128());
913         totalAsset.base = _totalAsset.base.add(feeFraction.to128());
914         totalBorrow = _totalBorrow;
915 
916         // Update interest rate
917         uint256 utilization = uint256(_totalBorrow.elastic).mul(UTILIZATION_PRECISION) / fullAssetAmount;
918         if (utilization < MINIMUM_TARGET_UTILIZATION) {
919             uint256 underFactor = MINIMUM_TARGET_UTILIZATION.sub(utilization).mul(FACTOR_PRECISION) / MINIMUM_TARGET_UTILIZATION;
920             uint256 scale = INTEREST_ELASTICITY.add(underFactor.mul(underFactor).mul(elapsedTime));
921             _accrueInfo.interestPerSecond = uint64(uint256(_accrueInfo.interestPerSecond).mul(INTEREST_ELASTICITY) / scale);
922 
923             if (_accrueInfo.interestPerSecond < MINIMUM_INTEREST_PER_SECOND) {
924                 _accrueInfo.interestPerSecond = MINIMUM_INTEREST_PER_SECOND; // 0.25% APR minimum
925             }
926         } else if (utilization > MAXIMUM_TARGET_UTILIZATION) {
927             uint256 overFactor = utilization.sub(MAXIMUM_TARGET_UTILIZATION).mul(FACTOR_PRECISION) / FULL_UTILIZATION_MINUS_MAX;
928             uint256 scale = INTEREST_ELASTICITY.add(overFactor.mul(overFactor).mul(elapsedTime));
929             uint256 newInterestPerSecond = uint256(_accrueInfo.interestPerSecond).mul(scale) / INTEREST_ELASTICITY;
930             if (newInterestPerSecond > MAXIMUM_INTEREST_PER_SECOND) {
931                 newInterestPerSecond = MAXIMUM_INTEREST_PER_SECOND; // 1000% APR maximum
932             }
933             _accrueInfo.interestPerSecond = uint64(newInterestPerSecond);
934         }
935 
936         emit LogAccrue(extraAmount, feeFraction, _accrueInfo.interestPerSecond, utilization);
937         accrueInfo = _accrueInfo;
938     }
939 
940     /// @notice Concrete implementation of `isSolvent`. Includes a third parameter to allow caching `exchangeRate`.
941     /// @param _exchangeRate The exchange rate. Used to cache the `exchangeRate` between calls.
942     function _isSolvent(
943         address user,
944         bool open,
945         uint256 _exchangeRate
946     ) internal view returns (bool) {
947         // accrue must have already been called!
948         uint256 borrowPart = userBorrowPart[user];
949         if (borrowPart == 0) return true;
950         uint256 collateralShare = userCollateralShare[user];
951         if (collateralShare == 0) return false;
952 
953         Rebase memory _totalBorrow = totalBorrow;
954 
955         return
956             bentoBox.toAmount(
957                 collateral,
958                 collateralShare.mul(EXCHANGE_RATE_PRECISION / COLLATERIZATION_RATE_PRECISION).mul(
959                     open ? OPEN_COLLATERIZATION_RATE : CLOSED_COLLATERIZATION_RATE
960                 ),
961                 false
962             ) >=
963             // Moved exchangeRate here instead of dividing the other side to preserve more precision
964             borrowPart.mul(_totalBorrow.elastic).mul(_exchangeRate) / _totalBorrow.base;
965     }
966 
967     /// @dev Checks if the user is solvent in the closed liquidation case at the end of the function body.
968     modifier solvent() {
969         _;
970         require(_isSolvent(msg.sender, false, exchangeRate), "KashiPair: user insolvent");
971     }
972 
973     /// @notice Gets the exchange rate. I.e how much collateral to buy 1e18 asset.
974     /// This function is supposed to be invoked if needed because Oracle queries can be expensive.
975     /// @return updated True if `exchangeRate` was updated.
976     /// @return rate The new exchange rate.
977     function updateExchangeRate() public returns (bool updated, uint256 rate) {
978         (updated, rate) = oracle.get(oracleData);
979 
980         if (updated) {
981             exchangeRate = rate;
982             emit LogExchangeRate(rate);
983         } else {
984             // Return the old rate if fetching wasn't successful
985             rate = exchangeRate;
986         }
987     }
988 
989     /// @dev Helper function to move tokens.
990     /// @param token The ERC-20 token.
991     /// @param share The amount in shares to add.
992     /// @param total Grand total amount to deduct from this contract's balance. Only applicable if `skim` is True.
993     /// Only used for accounting checks.
994     /// @param skim If True, only does a balance check on this contract.
995     /// False if tokens from msg.sender in `bentoBox` should be transferred.
996     function _addTokens(
997         IERC20 token,
998         uint256 share,
999         uint256 total,
1000         bool skim
1001     ) internal {
1002         if (skim) {
1003             require(share <= bentoBox.balanceOf(token, address(this)).sub(total), "KashiPair: Skim too much");
1004         } else {
1005             bentoBox.transfer(token, msg.sender, address(this), share);
1006         }
1007     }
1008 
1009     /// @notice Adds `collateral` from msg.sender to the account `to`.
1010     /// @param to The receiver of the tokens.
1011     /// @param skim True if the amount should be skimmed from the deposit balance of msg.sender.
1012     /// False if tokens from msg.sender in `bentoBox` should be transferred.
1013     /// @param share The amount of shares to add for `to`.
1014     function addCollateral(
1015         address to,
1016         bool skim,
1017         uint256 share
1018     ) public {
1019         userCollateralShare[to] = userCollateralShare[to].add(share);
1020         uint256 oldTotalCollateralShare = totalCollateralShare;
1021         totalCollateralShare = oldTotalCollateralShare.add(share);
1022         _addTokens(collateral, share, oldTotalCollateralShare, skim);
1023         emit LogAddCollateral(skim ? address(bentoBox) : msg.sender, to, share);
1024     }
1025 
1026     /// @dev Concrete implementation of `removeCollateral`.
1027     function _removeCollateral(address to, uint256 share) internal {
1028         userCollateralShare[msg.sender] = userCollateralShare[msg.sender].sub(share);
1029         totalCollateralShare = totalCollateralShare.sub(share);
1030         emit LogRemoveCollateral(msg.sender, to, share);
1031         bentoBox.transfer(collateral, address(this), to, share);
1032     }
1033 
1034     /// @notice Removes `share` amount of collateral and transfers it to `to`.
1035     /// @param to The receiver of the shares.
1036     /// @param share Amount of shares to remove.
1037     function removeCollateral(address to, uint256 share) public solvent {
1038         // accrue must be called because we check solvency
1039         accrue();
1040         _removeCollateral(to, share);
1041     }
1042 
1043     /// @dev Concrete implementation of `addAsset`.
1044     function _addAsset(
1045         address to,
1046         bool skim,
1047         uint256 share
1048     ) internal returns (uint256 fraction) {
1049         Rebase memory _totalAsset = totalAsset;
1050         uint256 totalAssetShare = _totalAsset.elastic;
1051         uint256 allShare = _totalAsset.elastic + bentoBox.toShare(asset, totalBorrow.elastic, true);
1052         fraction = allShare == 0 ? share : share.mul(_totalAsset.base) / allShare;
1053         if (_totalAsset.base.add(fraction.to128()) < 1000) {
1054             return 0;
1055         }
1056         totalAsset = _totalAsset.add(share, fraction);
1057         balanceOf[to] = balanceOf[to].add(fraction);
1058         emit Transfer(address(0), to, fraction);
1059         _addTokens(asset, share, totalAssetShare, skim);
1060         emit LogAddAsset(skim ? address(bentoBox) : msg.sender, to, share, fraction);
1061     }
1062 
1063     /// @notice Adds assets to the lending pair.
1064     /// @param to The address of the user to receive the assets.
1065     /// @param skim True if the amount should be skimmed from the deposit balance of msg.sender.
1066     /// False if tokens from msg.sender in `bentoBox` should be transferred.
1067     /// @param share The amount of shares to add.
1068     /// @return fraction Total fractions added.
1069     function addAsset(
1070         address to,
1071         bool skim,
1072         uint256 share
1073     ) public returns (uint256 fraction) {
1074         accrue();
1075         fraction = _addAsset(to, skim, share);
1076     }
1077 
1078     /// @dev Concrete implementation of `removeAsset`.
1079     function _removeAsset(address to, uint256 fraction) internal returns (uint256 share) {
1080         Rebase memory _totalAsset = totalAsset;
1081         uint256 allShare = _totalAsset.elastic + bentoBox.toShare(asset, totalBorrow.elastic, true);
1082         share = fraction.mul(allShare) / _totalAsset.base;
1083         balanceOf[msg.sender] = balanceOf[msg.sender].sub(fraction);
1084         emit Transfer(msg.sender, address(0), fraction);
1085         _totalAsset.elastic = _totalAsset.elastic.sub(share.to128());
1086         _totalAsset.base = _totalAsset.base.sub(fraction.to128());
1087         require(_totalAsset.base >= 1000, "Kashi: below minimum");
1088         totalAsset = _totalAsset;
1089         emit LogRemoveAsset(msg.sender, to, share, fraction);
1090         bentoBox.transfer(asset, address(this), to, share);
1091     }
1092 
1093     /// @notice Removes an asset from msg.sender and transfers it to `to`.
1094     /// @param to The user that receives the removed assets.
1095     /// @param fraction The amount/fraction of assets held to remove.
1096     /// @return share The amount of shares transferred to `to`.
1097     function removeAsset(address to, uint256 fraction) public returns (uint256 share) {
1098         accrue();
1099         share = _removeAsset(to, fraction);
1100     }
1101 
1102     /// @dev Concrete implementation of `borrow`.
1103     function _borrow(address to, uint256 amount) internal returns (uint256 part, uint256 share) {
1104         uint256 feeAmount = amount.mul(BORROW_OPENING_FEE) / BORROW_OPENING_FEE_PRECISION; // A flat % fee is charged for any borrow
1105 
1106         (totalBorrow, part) = totalBorrow.add(amount.add(feeAmount), true);
1107         userBorrowPart[msg.sender] = userBorrowPart[msg.sender].add(part);
1108         emit LogBorrow(msg.sender, to, amount, feeAmount, part);
1109 
1110         share = bentoBox.toShare(asset, amount, false);
1111         Rebase memory _totalAsset = totalAsset;
1112         require(_totalAsset.base >= 1000, "Kashi: below minimum");
1113         _totalAsset.elastic = _totalAsset.elastic.sub(share.to128());
1114         totalAsset = _totalAsset;
1115         bentoBox.transfer(asset, address(this), to, share);
1116     }
1117 
1118     /// @notice Sender borrows `amount` and transfers it to `to`.
1119     /// @return part Total part of the debt held by borrowers.
1120     /// @return share Total amount in shares borrowed.
1121     function borrow(address to, uint256 amount) public solvent returns (uint256 part, uint256 share) {
1122         accrue();
1123         (part, share) = _borrow(to, amount);
1124     }
1125 
1126     /// @dev Concrete implementation of `repay`.
1127     function _repay(
1128         address to,
1129         bool skim,
1130         uint256 part
1131     ) internal returns (uint256 amount) {
1132         (totalBorrow, amount) = totalBorrow.sub(part, true);
1133         userBorrowPart[to] = userBorrowPart[to].sub(part);
1134 
1135         uint256 share = bentoBox.toShare(asset, amount, true);
1136         uint128 totalShare = totalAsset.elastic;
1137         _addTokens(asset, share, uint256(totalShare), skim);
1138         totalAsset.elastic = totalShare.add(share.to128());
1139         emit LogRepay(skim ? address(bentoBox) : msg.sender, to, amount, part);
1140     }
1141 
1142     /// @notice Repays a loan.
1143     /// @param to Address of the user this payment should go.
1144     /// @param skim True if the amount should be skimmed from the deposit balance of msg.sender.
1145     /// False if tokens from msg.sender in `bentoBox` should be transferred.
1146     /// @param part The amount to repay. See `userBorrowPart`.
1147     /// @return amount The total amount repayed.
1148     function repay(
1149         address to,
1150         bool skim,
1151         uint256 part
1152     ) public returns (uint256 amount) {
1153         accrue();
1154         amount = _repay(to, skim, part);
1155     }
1156 
1157     // Functions that need accrue to be called
1158     uint8 internal constant ACTION_ADD_ASSET = 1;
1159     uint8 internal constant ACTION_REPAY = 2;
1160     uint8 internal constant ACTION_REMOVE_ASSET = 3;
1161     uint8 internal constant ACTION_REMOVE_COLLATERAL = 4;
1162     uint8 internal constant ACTION_BORROW = 5;
1163     uint8 internal constant ACTION_GET_REPAY_SHARE = 6;
1164     uint8 internal constant ACTION_GET_REPAY_PART = 7;
1165     uint8 internal constant ACTION_ACCRUE = 8;
1166 
1167     // Functions that don't need accrue to be called
1168     uint8 internal constant ACTION_ADD_COLLATERAL = 10;
1169     uint8 internal constant ACTION_UPDATE_EXCHANGE_RATE = 11;
1170 
1171     // Function on BentoBox
1172     uint8 internal constant ACTION_BENTO_DEPOSIT = 20;
1173     uint8 internal constant ACTION_BENTO_WITHDRAW = 21;
1174     uint8 internal constant ACTION_BENTO_TRANSFER = 22;
1175     uint8 internal constant ACTION_BENTO_TRANSFER_MULTIPLE = 23;
1176     uint8 internal constant ACTION_BENTO_SETAPPROVAL = 24;
1177 
1178     // Any external call (except to BentoBox)
1179     uint8 internal constant ACTION_CALL = 30;
1180 
1181     int256 internal constant USE_VALUE1 = -1;
1182     int256 internal constant USE_VALUE2 = -2;
1183 
1184     /// @dev Helper function for choosing the correct value (`value1` or `value2`) depending on `inNum`.
1185     function _num(
1186         int256 inNum,
1187         uint256 value1,
1188         uint256 value2
1189     ) internal pure returns (uint256 outNum) {
1190         outNum = inNum >= 0 ? uint256(inNum) : (inNum == USE_VALUE1 ? value1 : value2);
1191     }
1192 
1193     /// @dev Helper function for depositing into `bentoBox`.
1194     function _bentoDeposit(
1195         bytes memory data,
1196         uint256 value,
1197         uint256 value1,
1198         uint256 value2
1199     ) internal returns (uint256, uint256) {
1200         (IERC20 token, address to, int256 amount, int256 share) = abi.decode(data, (IERC20, address, int256, int256));
1201         amount = int256(_num(amount, value1, value2)); // Done this way to avoid stack too deep errors
1202         share = int256(_num(share, value1, value2));
1203         return bentoBox.deposit{value: value}(token, msg.sender, to, uint256(amount), uint256(share));
1204     }
1205 
1206     /// @dev Helper function to withdraw from the `bentoBox`.
1207     function _bentoWithdraw(
1208         bytes memory data,
1209         uint256 value1,
1210         uint256 value2
1211     ) internal returns (uint256, uint256) {
1212         (IERC20 token, address to, int256 amount, int256 share) = abi.decode(data, (IERC20, address, int256, int256));
1213         return bentoBox.withdraw(token, msg.sender, to, _num(amount, value1, value2), _num(share, value1, value2));
1214     }
1215 
1216     /// @dev Helper function to perform a contract call and eventually extracting revert messages on failure.
1217     /// Calls to `bentoBox` are not allowed for obvious security reasons.
1218     /// This also means that calls made from this contract shall *not* be trusted.
1219     function _call(
1220         uint256 value,
1221         bytes memory data,
1222         uint256 value1,
1223         uint256 value2
1224     ) internal returns (bytes memory, uint8) {
1225         (address callee, bytes memory callData, bool useValue1, bool useValue2, uint8 returnValues) =
1226             abi.decode(data, (address, bytes, bool, bool, uint8));
1227 
1228         if (useValue1 && !useValue2) {
1229             callData = abi.encodePacked(callData, value1);
1230         } else if (!useValue1 && useValue2) {
1231             callData = abi.encodePacked(callData, value2);
1232         } else if (useValue1 && useValue2) {
1233             callData = abi.encodePacked(callData, value1, value2);
1234         }
1235 
1236         require(callee != address(bentoBox) && callee != address(this), "KashiPair: can't call");
1237 
1238         (bool success, bytes memory returnData) = callee.call{value: value}(callData);
1239         require(success, "KashiPair: call failed");
1240         return (returnData, returnValues);
1241     }
1242 
1243     struct CookStatus {
1244         bool needsSolvencyCheck;
1245         bool hasAccrued;
1246     }
1247 
1248     /// @notice Executes a set of actions and allows composability (contract calls) to other contracts.
1249     /// @param actions An array with a sequence of actions to execute (see ACTION_ declarations).
1250     /// @param values A one-to-one mapped array to `actions`. ETH amounts to send along with the actions.
1251     /// Only applicable to `ACTION_CALL`, `ACTION_BENTO_DEPOSIT`.
1252     /// @param datas A one-to-one mapped array to `actions`. Contains abi encoded data of function arguments.
1253     /// @return value1 May contain the first positioned return value of the last executed action (if applicable).
1254     /// @return value2 May contain the second positioned return value of the last executed action which returns 2 values (if applicable).
1255     function cook(
1256         uint8[] calldata actions,
1257         uint256[] calldata values,
1258         bytes[] calldata datas
1259     ) external payable returns (uint256 value1, uint256 value2) {
1260         CookStatus memory status;
1261         for (uint256 i = 0; i < actions.length; i++) {
1262             uint8 action = actions[i];
1263             if (!status.hasAccrued && action < 10) {
1264                 accrue();
1265                 status.hasAccrued = true;
1266             }
1267             if (action == ACTION_ADD_COLLATERAL) {
1268                 (int256 share, address to, bool skim) = abi.decode(datas[i], (int256, address, bool));
1269                 addCollateral(to, skim, _num(share, value1, value2));
1270             } else if (action == ACTION_ADD_ASSET) {
1271                 (int256 share, address to, bool skim) = abi.decode(datas[i], (int256, address, bool));
1272                 value1 = _addAsset(to, skim, _num(share, value1, value2));
1273             } else if (action == ACTION_REPAY) {
1274                 (int256 part, address to, bool skim) = abi.decode(datas[i], (int256, address, bool));
1275                 _repay(to, skim, _num(part, value1, value2));
1276             } else if (action == ACTION_REMOVE_ASSET) {
1277                 (int256 fraction, address to) = abi.decode(datas[i], (int256, address));
1278                 value1 = _removeAsset(to, _num(fraction, value1, value2));
1279             } else if (action == ACTION_REMOVE_COLLATERAL) {
1280                 (int256 share, address to) = abi.decode(datas[i], (int256, address));
1281                 _removeCollateral(to, _num(share, value1, value2));
1282                 status.needsSolvencyCheck = true;
1283             } else if (action == ACTION_BORROW) {
1284                 (int256 amount, address to) = abi.decode(datas[i], (int256, address));
1285                 (value1, value2) = _borrow(to, _num(amount, value1, value2));
1286                 status.needsSolvencyCheck = true;
1287             } else if (action == ACTION_UPDATE_EXCHANGE_RATE) {
1288                 (bool must_update, uint256 minRate, uint256 maxRate) = abi.decode(datas[i], (bool, uint256, uint256));
1289                 (bool updated, uint256 rate) = updateExchangeRate();
1290                 require((!must_update || updated) && rate > minRate && (maxRate == 0 || rate > maxRate), "KashiPair: rate not ok");
1291             } else if (action == ACTION_BENTO_SETAPPROVAL) {
1292                 (address user, address _masterContract, bool approved, uint8 v, bytes32 r, bytes32 s) =
1293                     abi.decode(datas[i], (address, address, bool, uint8, bytes32, bytes32));
1294                 bentoBox.setMasterContractApproval(user, _masterContract, approved, v, r, s);
1295             } else if (action == ACTION_BENTO_DEPOSIT) {
1296                 (value1, value2) = _bentoDeposit(datas[i], values[i], value1, value2);
1297             } else if (action == ACTION_BENTO_WITHDRAW) {
1298                 (value1, value2) = _bentoWithdraw(datas[i], value1, value2);
1299             } else if (action == ACTION_BENTO_TRANSFER) {
1300                 (IERC20 token, address to, int256 share) = abi.decode(datas[i], (IERC20, address, int256));
1301                 bentoBox.transfer(token, msg.sender, to, _num(share, value1, value2));
1302             } else if (action == ACTION_BENTO_TRANSFER_MULTIPLE) {
1303                 (IERC20 token, address[] memory tos, uint256[] memory shares) = abi.decode(datas[i], (IERC20, address[], uint256[]));
1304                 bentoBox.transferMultiple(token, msg.sender, tos, shares);
1305             } else if (action == ACTION_CALL) {
1306                 (bytes memory returnData, uint8 returnValues) = _call(values[i], datas[i], value1, value2);
1307 
1308                 if (returnValues == 1) {
1309                     (value1) = abi.decode(returnData, (uint256));
1310                 } else if (returnValues == 2) {
1311                     (value1, value2) = abi.decode(returnData, (uint256, uint256));
1312                 }
1313             } else if (action == ACTION_GET_REPAY_SHARE) {
1314                 int256 part = abi.decode(datas[i], (int256));
1315                 value1 = bentoBox.toShare(asset, totalBorrow.toElastic(_num(part, value1, value2), true), true);
1316             } else if (action == ACTION_GET_REPAY_PART) {
1317                 int256 amount = abi.decode(datas[i], (int256));
1318                 value1 = totalBorrow.toBase(_num(amount, value1, value2), false);
1319             }
1320         }
1321 
1322         if (status.needsSolvencyCheck) {
1323             require(_isSolvent(msg.sender, false, exchangeRate), "KashiPair: user insolvent");
1324         }
1325     }
1326 
1327     /// @notice Handles the liquidation of users' balances, once the users' amount of collateral is too low.
1328     /// @param users An array of user addresses.
1329     /// @param maxBorrowParts A one-to-one mapping to `users`, contains maximum (partial) borrow amounts (to liquidate) of the respective user.
1330     /// @param to Address of the receiver in open liquidations if `swapper` is zero.
1331     /// @param swapper Contract address of the `ISwapper` implementation. Swappers are restricted for closed liquidations. See `setSwapper`.
1332     /// @param open True to perform a open liquidation else False.
1333     function liquidate(
1334         address[] calldata users,
1335         uint256[] calldata maxBorrowParts,
1336         address to,
1337         ISwapper swapper,
1338         bool open
1339     ) public {
1340         // Oracle can fail but we still need to allow liquidations
1341         (, uint256 _exchangeRate) = updateExchangeRate();
1342         accrue();
1343 
1344         uint256 allCollateralShare;
1345         uint256 allBorrowAmount;
1346         uint256 allBorrowPart;
1347         Rebase memory _totalBorrow = totalBorrow;
1348         Rebase memory bentoBoxTotals = bentoBox.totals(collateral);
1349         for (uint256 i = 0; i < users.length; i++) {
1350             address user = users[i];
1351             if (!_isSolvent(user, open, _exchangeRate)) {
1352                 uint256 borrowPart;
1353                 {
1354                     uint256 availableBorrowPart = userBorrowPart[user];
1355                     borrowPart = maxBorrowParts[i] > availableBorrowPart ? availableBorrowPart : maxBorrowParts[i];
1356                     userBorrowPart[user] = availableBorrowPart.sub(borrowPart);
1357                 }
1358                 uint256 borrowAmount = _totalBorrow.toElastic(borrowPart, false);
1359                 uint256 collateralShare =
1360                     bentoBoxTotals.toBase(
1361                         borrowAmount.mul(LIQUIDATION_MULTIPLIER).mul(_exchangeRate) /
1362                             (LIQUIDATION_MULTIPLIER_PRECISION * EXCHANGE_RATE_PRECISION),
1363                         false
1364                     );
1365 
1366                 userCollateralShare[user] = userCollateralShare[user].sub(collateralShare);
1367                 emit LogRemoveCollateral(user, swapper == ISwapper(0) ? to : address(swapper), collateralShare);
1368                 emit LogRepay(swapper == ISwapper(0) ? msg.sender : address(swapper), user, borrowAmount, borrowPart);
1369 
1370                 // Keep totals
1371                 allCollateralShare = allCollateralShare.add(collateralShare);
1372                 allBorrowAmount = allBorrowAmount.add(borrowAmount);
1373                 allBorrowPart = allBorrowPart.add(borrowPart);
1374             }
1375         }
1376         require(allBorrowAmount != 0, "KashiPair: all are solvent");
1377         _totalBorrow.elastic = _totalBorrow.elastic.sub(allBorrowAmount.to128());
1378         _totalBorrow.base = _totalBorrow.base.sub(allBorrowPart.to128());
1379         totalBorrow = _totalBorrow;
1380         totalCollateralShare = totalCollateralShare.sub(allCollateralShare);
1381 
1382         uint256 allBorrowShare = bentoBox.toShare(asset, allBorrowAmount, true);
1383 
1384         if (!open) {
1385             // Closed liquidation using a pre-approved swapper for the benefit of the LPs
1386             require(masterContract.swappers(swapper), "KashiPair: Invalid swapper");
1387 
1388             // Swaps the users' collateral for the borrowed asset
1389             bentoBox.transfer(collateral, address(this), address(swapper), allCollateralShare);
1390             swapper.swap(collateral, asset, address(this), allBorrowShare, allCollateralShare);
1391 
1392             uint256 returnedShare = bentoBox.balanceOf(asset, address(this)).sub(uint256(totalAsset.elastic));
1393             uint256 extraShare = returnedShare.sub(allBorrowShare);
1394             uint256 feeShare = extraShare.mul(PROTOCOL_FEE) / PROTOCOL_FEE_DIVISOR; // % of profit goes to fee
1395             // solhint-disable-next-line reentrancy
1396             bentoBox.transfer(asset, address(this), masterContract.feeTo(), feeShare);
1397             totalAsset.elastic = totalAsset.elastic.add(returnedShare.sub(feeShare).to128());
1398             emit LogAddAsset(address(swapper), address(this), extraShare.sub(feeShare), 0);
1399         } else {
1400             // Swap using a swapper freely chosen by the caller
1401             // Open (flash) liquidation: get proceeds first and provide the borrow after
1402             bentoBox.transfer(collateral, address(this), swapper == ISwapper(0) ? to : address(swapper), allCollateralShare);
1403             if (swapper != ISwapper(0)) {
1404                 swapper.swap(collateral, asset, msg.sender, allBorrowShare, allCollateralShare);
1405             }
1406 
1407             bentoBox.transfer(asset, msg.sender, address(this), allBorrowShare);
1408             totalAsset.elastic = totalAsset.elastic.add(allBorrowShare.to128());
1409         }
1410     }
1411 
1412     /// @notice Withdraws the fees accumulated.
1413     function withdrawFees() public {
1414         accrue();
1415         address _feeTo = masterContract.feeTo();
1416         uint256 _feesEarnedFraction = accrueInfo.feesEarnedFraction;
1417         balanceOf[_feeTo] = balanceOf[_feeTo].add(_feesEarnedFraction);
1418         emit Transfer(address(0), _feeTo, _feesEarnedFraction);
1419         accrueInfo.feesEarnedFraction = 0;
1420 
1421         emit LogWithdrawFees(_feeTo, _feesEarnedFraction);
1422     }
1423 
1424     /// @notice Used to register and enable or disable swapper contracts used in closed liquidations.
1425     /// MasterContract Only Admin function.
1426     /// @param swapper The address of the swapper contract that conforms to `ISwapper`.
1427     /// @param enable True to enable the swapper. To disable use False.
1428     function setSwapper(ISwapper swapper, bool enable) public onlyOwner {
1429         swappers[swapper] = enable;
1430     }
1431 
1432     /// @notice Sets the beneficiary of fees accrued in liquidations.
1433     /// MasterContract Only Admin function.
1434     /// @param newFeeTo The address of the receiver.
1435     function setFeeTo(address newFeeTo) public onlyOwner {
1436         feeTo = newFeeTo;
1437         emit LogFeeTo(newFeeTo);
1438     }
1439 }