1 // SPDX-License-Identifier: UNLICENSED
2 // The BentoBox
3 
4 //  ▄▄▄▄· ▄▄▄ . ▐ ▄ ▄▄▄▄▄      ▄▄▄▄·       ▐▄• ▄
5 //  ▐█ ▀█▪▀▄.▀·█▌▐█•██  ▪     ▐█ ▀█▪▪      █▌█▌▪
6 //  ▐█▀▀█▄▐▀▀▪▄▐█▐▐▌ ▐█.▪ ▄█▀▄ ▐█▀▀█▄ ▄█▀▄  ·██·
7 //  ██▄▪▐█▐█▄▄▌██▐█▌ ▐█▌·▐█▌.▐▌██▄▪▐█▐█▌.▐▌▪▐█·█▌
8 //  ·▀▀▀▀  ▀▀▀ ▀▀ █▪ ▀▀▀  ▀█▄▀▪·▀▀▀▀  ▀█▄▀▪•▀▀ ▀▀
9 
10 // This contract stores funds, handles their transfers, supports flash loans and strategies.
11 
12 // Copyright (c) 2021 BoringCrypto - All rights reserved
13 // Twitter: @Boring_Crypto
14 
15 // Special thanks to Keno for all his hard work and support
16 
17 // Version 22-Mar-2021
18 
19 pragma solidity 0.6.12;
20 pragma experimental ABIEncoderV2;
21 
22 // solhint-disable avoid-low-level-calls
23 // solhint-disable not-rely-on-time
24 // solhint-disable no-inline-assembly
25 
26 // File @boringcrypto/boring-solidity/contracts/interfaces/IERC20.sol@v1.2.0
27 // License-Identifier: MIT
28 
29 interface IERC20 {
30     function totalSupply() external view returns (uint256);
31 
32     function balanceOf(address account) external view returns (uint256);
33 
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     function approve(address spender, uint256 amount) external returns (bool);
37 
38     event Transfer(address indexed from, address indexed to, uint256 value);
39     event Approval(address indexed owner, address indexed spender, uint256 value);
40 
41     /// @notice EIP 2612
42     function permit(
43         address owner,
44         address spender,
45         uint256 value,
46         uint256 deadline,
47         uint8 v,
48         bytes32 r,
49         bytes32 s
50     ) external;
51 }
52 
53 // File contracts/interfaces/IFlashLoan.sol
54 // License-Identifier: MIT
55 
56 interface IFlashBorrower {
57     /// @notice The flashloan callback. `amount` + `fee` needs to repayed to msg.sender before this call returns.
58     /// @param sender The address of the invoker of this flashloan.
59     /// @param token The address of the token that is loaned.
60     /// @param amount of the `token` that is loaned.
61     /// @param fee The fee that needs to be paid on top for this loan. Needs to be the same as `token`.
62     /// @param data Additional data that was passed to the flashloan function.
63     function onFlashLoan(
64         address sender,
65         IERC20 token,
66         uint256 amount,
67         uint256 fee,
68         bytes calldata data
69     ) external;
70 }
71 
72 interface IBatchFlashBorrower {
73     /// @notice The callback for batched flashloans. Every amount + fee needs to repayed to msg.sender before this call returns.
74     /// @param sender The address of the invoker of this flashloan.
75     /// @param tokens Array of addresses for ERC-20 tokens that is loaned.
76     /// @param amounts A one-to-one map to `tokens` that is loaned.
77     /// @param fees A one-to-one map to `tokens` that needs to be paid on top for each loan. Needs to be the same token.
78     /// @param data Additional data that was passed to the flashloan function.
79     function onBatchFlashLoan(
80         address sender,
81         IERC20[] calldata tokens,
82         uint256[] calldata amounts,
83         uint256[] calldata fees,
84         bytes calldata data
85     ) external;
86 }
87 
88 // File contracts/interfaces/IWETH.sol
89 // License-Identifier: MIT
90 
91 interface IWETH {
92     function deposit() external payable;
93 
94     function withdraw(uint256) external;
95 }
96 
97 // File contracts/interfaces/IStrategy.sol
98 // License-Identifier: MIT
99 
100 interface IStrategy {
101     /// @notice Send the assets to the Strategy and call skim to invest them.
102     /// @param amount The amount of tokens to invest.
103     function skim(uint256 amount) external;
104 
105     /// @notice Harvest any profits made converted to the asset and pass them to the caller.
106     /// @param balance The amount of tokens the caller thinks it has invested.
107     /// @param sender The address of the initiator of this transaction. Can be used for reimbursements, etc.
108     /// @return amountAdded The delta (+profit or -loss) that occured in contrast to `balance`.
109     function harvest(uint256 balance, address sender) external returns (int256 amountAdded);
110 
111     /// @notice Withdraw assets. The returned amount can differ from the requested amount due to rounding.
112     /// @dev The `actualAmount` should be very close to the amount.
113     /// The difference should NOT be used to report a loss. That's what harvest is for.
114     /// @param amount The requested amount the caller wants to withdraw.
115     /// @return actualAmount The real amount that is withdrawn.
116     function withdraw(uint256 amount) external returns (uint256 actualAmount);
117 
118     /// @notice Withdraw all assets in the safest way possible. This shouldn't fail.
119     /// @param balance The amount of tokens the caller thinks it has invested.
120     /// @return amountAdded The delta (+profit or -loss) that occured in contrast to `balance`.
121     function exit(uint256 balance) external returns (int256 amountAdded);
122 }
123 
124 // File @boringcrypto/boring-solidity/contracts/libraries/BoringERC20.sol@v1.2.0
125 // License-Identifier: MIT
126 
127 library BoringERC20 {
128     bytes4 private constant SIG_SYMBOL = 0x95d89b41; // symbol()
129     bytes4 private constant SIG_NAME = 0x06fdde03; // name()
130     bytes4 private constant SIG_DECIMALS = 0x313ce567; // decimals()
131     bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)
132     bytes4 private constant SIG_TRANSFER_FROM = 0x23b872dd; // transferFrom(address,address,uint256)
133 
134     /// @notice Provides a safe ERC20.transfer version for different ERC-20 implementations.
135     /// Reverts on a failed transfer.
136     /// @param token The address of the ERC-20 token.
137     /// @param to Transfer tokens to.
138     /// @param amount The token amount.
139     function safeTransfer(
140         IERC20 token,
141         address to,
142         uint256 amount
143     ) internal {
144         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER, to, amount));
145         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: Transfer failed");
146     }
147 
148     /// @notice Provides a safe ERC20.transferFrom version for different ERC-20 implementations.
149     /// Reverts on a failed transfer.
150     /// @param token The address of the ERC-20 token.
151     /// @param from Transfer tokens from.
152     /// @param to Transfer tokens to.
153     /// @param amount The token amount.
154     function safeTransferFrom(
155         IERC20 token,
156         address from,
157         address to,
158         uint256 amount
159     ) internal {
160         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER_FROM, from, to, amount));
161         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: TransferFrom failed");
162     }
163 }
164 
165 // File @boringcrypto/boring-solidity/contracts/libraries/BoringMath.sol@v1.2.0
166 // License-Identifier: MIT
167 
168 /// @notice A library for performing overflow-/underflow-safe math,
169 /// updated with awesomeness from of DappHub (https://github.com/dapphub/ds-math).
170 library BoringMath {
171     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
172         require((c = a + b) >= b, "BoringMath: Add Overflow");
173     }
174 
175     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
176         require((c = a - b) <= a, "BoringMath: Underflow");
177     }
178 
179     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
180         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
181     }
182 
183     function to128(uint256 a) internal pure returns (uint128 c) {
184         require(a <= uint128(-1), "BoringMath: uint128 Overflow");
185         c = uint128(a);
186     }
187 
188     function to64(uint256 a) internal pure returns (uint64 c) {
189         require(a <= uint64(-1), "BoringMath: uint64 Overflow");
190         c = uint64(a);
191     }
192 
193     function to32(uint256 a) internal pure returns (uint32 c) {
194         require(a <= uint32(-1), "BoringMath: uint32 Overflow");
195         c = uint32(a);
196     }
197 }
198 
199 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint128.
200 library BoringMath128 {
201     function add(uint128 a, uint128 b) internal pure returns (uint128 c) {
202         require((c = a + b) >= b, "BoringMath: Add Overflow");
203     }
204 
205     function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {
206         require((c = a - b) <= a, "BoringMath: Underflow");
207     }
208 }
209 
210 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint64.
211 library BoringMath64 {
212     function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
213         require((c = a + b) >= b, "BoringMath: Add Overflow");
214     }
215 
216     function sub(uint64 a, uint64 b) internal pure returns (uint64 c) {
217         require((c = a - b) <= a, "BoringMath: Underflow");
218     }
219 }
220 
221 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.
222 library BoringMath32 {
223     function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
224         require((c = a + b) >= b, "BoringMath: Add Overflow");
225     }
226 
227     function sub(uint32 a, uint32 b) internal pure returns (uint32 c) {
228         require((c = a - b) <= a, "BoringMath: Underflow");
229     }
230 }
231 
232 // File @boringcrypto/boring-solidity/contracts/libraries/BoringRebase.sol@v1.2.0
233 // License-Identifier: MIT
234 
235 struct Rebase {
236     uint128 elastic;
237     uint128 base;
238 }
239 
240 /// @notice A rebasing library using overflow-/underflow-safe math.
241 library RebaseLibrary {
242     using BoringMath for uint256;
243     using BoringMath128 for uint128;
244 
245     /// @notice Calculates the base value in relationship to `elastic` and `total`.
246     function toBase(
247         Rebase memory total,
248         uint256 elastic,
249         bool roundUp
250     ) internal pure returns (uint256 base) {
251         if (total.elastic == 0) {
252             base = elastic;
253         } else {
254             base = elastic.mul(total.base) / total.elastic;
255             if (roundUp && base.mul(total.elastic) / total.base < elastic) {
256                 base = base.add(1);
257             }
258         }
259     }
260 
261     /// @notice Calculates the elastic value in relationship to `base` and `total`.
262     function toElastic(
263         Rebase memory total,
264         uint256 base,
265         bool roundUp
266     ) internal pure returns (uint256 elastic) {
267         if (total.base == 0) {
268             elastic = base;
269         } else {
270             elastic = base.mul(total.elastic) / total.base;
271             if (roundUp && elastic.mul(total.base) / total.elastic < base) {
272                 elastic = elastic.add(1);
273             }
274         }
275     }
276 
277     /// @notice Add `elastic` to `total` and doubles `total.base`.
278     /// @return (Rebase) The new total.
279     /// @return base in relationship to `elastic`.
280     function add(
281         Rebase memory total,
282         uint256 elastic,
283         bool roundUp
284     ) internal pure returns (Rebase memory, uint256 base) {
285         base = toBase(total, elastic, roundUp);
286         total.elastic = total.elastic.add(elastic.to128());
287         total.base = total.base.add(base.to128());
288         return (total, base);
289     }
290 
291     /// @notice Sub `base` from `total` and update `total.elastic`.
292     /// @return (Rebase) The new total.
293     /// @return elastic in relationship to `base`.
294     function sub(
295         Rebase memory total,
296         uint256 base,
297         bool roundUp
298     ) internal pure returns (Rebase memory, uint256 elastic) {
299         elastic = toElastic(total, base, roundUp);
300         total.elastic = total.elastic.sub(elastic.to128());
301         total.base = total.base.sub(base.to128());
302         return (total, elastic);
303     }
304 
305     /// @notice Add `elastic` and `base` to `total`.
306     function add(
307         Rebase memory total,
308         uint256 elastic,
309         uint256 base
310     ) internal pure returns (Rebase memory) {
311         total.elastic = total.elastic.add(elastic.to128());
312         total.base = total.base.add(base.to128());
313         return total;
314     }
315 
316     /// @notice Subtract `elastic` and `base` to `total`.
317     function sub(
318         Rebase memory total,
319         uint256 elastic,
320         uint256 base
321     ) internal pure returns (Rebase memory) {
322         total.elastic = total.elastic.sub(elastic.to128());
323         total.base = total.base.sub(base.to128());
324         return total;
325     }
326 
327     /// @notice Add `elastic` to `total` and update storage.
328     /// @return newElastic Returns updated `elastic`.
329     function addElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {
330         newElastic = total.elastic = total.elastic.add(elastic.to128());
331     }
332 
333     /// @notice Subtract `elastic` from `total` and update storage.
334     /// @return newElastic Returns updated `elastic`.
335     function subElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {
336         newElastic = total.elastic = total.elastic.sub(elastic.to128());
337     }
338 }
339 
340 // File @boringcrypto/boring-solidity/contracts/BoringOwnable.sol@v1.2.0
341 // License-Identifier: MIT
342 
343 // Source: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol + Claimable.sol
344 // Edited by BoringCrypto
345 
346 contract BoringOwnableData {
347     address public owner;
348     address public pendingOwner;
349 }
350 
351 contract BoringOwnable is BoringOwnableData {
352     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
353 
354     /// @notice `owner` defaults to msg.sender on construction.
355     constructor() public {
356         owner = msg.sender;
357         emit OwnershipTransferred(address(0), msg.sender);
358     }
359 
360     /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.
361     /// Can only be invoked by the current `owner`.
362     /// @param newOwner Address of the new owner.
363     /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.
364     /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.
365     function transferOwnership(
366         address newOwner,
367         bool direct,
368         bool renounce
369     ) public onlyOwner {
370         if (direct) {
371             // Checks
372             require(newOwner != address(0) || renounce, "Ownable: zero address");
373 
374             // Effects
375             emit OwnershipTransferred(owner, newOwner);
376             owner = newOwner;
377             pendingOwner = address(0);
378         } else {
379             // Effects
380             pendingOwner = newOwner;
381         }
382     }
383 
384     /// @notice Needs to be called by `pendingOwner` to claim ownership.
385     function claimOwnership() public {
386         address _pendingOwner = pendingOwner;
387 
388         // Checks
389         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
390 
391         // Effects
392         emit OwnershipTransferred(owner, _pendingOwner);
393         owner = _pendingOwner;
394         pendingOwner = address(0);
395     }
396 
397     /// @notice Only allows the `owner` to execute the function.
398     modifier onlyOwner() {
399         require(msg.sender == owner, "Ownable: caller is not the owner");
400         _;
401     }
402 }
403 
404 // File @boringcrypto/boring-solidity/contracts/interfaces/IMasterContract.sol@v1.2.0
405 // License-Identifier: MIT
406 
407 interface IMasterContract {
408     /// @notice Init function that gets called from `BoringFactory.deploy`.
409     /// Also kown as the constructor for cloned contracts.
410     /// Any ETH send to `BoringFactory.deploy` ends up here.
411     /// @param data Can be abi encoded arguments or anything else.
412     function init(bytes calldata data) external payable;
413 }
414 
415 // File @boringcrypto/boring-solidity/contracts/BoringFactory.sol@v1.2.0
416 // License-Identifier: MIT
417 
418 contract BoringFactory {
419     event LogDeploy(address indexed masterContract, bytes data, address indexed cloneAddress);
420 
421     /// @notice Mapping from clone contracts to their masterContract.
422     mapping(address => address) public masterContractOf;
423 
424     /// @notice Deploys a given master Contract as a clone.
425     /// Any ETH transferred with this call is forwarded to the new clone.
426     /// Emits `LogDeploy`.
427     /// @param masterContract The address of the contract to clone.
428     /// @param data Additional abi encoded calldata that is passed to the new clone via `IMasterContract.init`.
429     /// @param useCreate2 Creates the clone by using the CREATE2 opcode, in this case `data` will be used as salt.
430     /// @return cloneAddress Address of the created clone contract.
431     function deploy(
432         address masterContract,
433         bytes calldata data,
434         bool useCreate2
435     ) public payable returns (address cloneAddress) {
436         require(masterContract != address(0), "BoringFactory: No masterContract");
437         bytes20 targetBytes = bytes20(masterContract); // Takes the first 20 bytes of the masterContract's address
438 
439         if (useCreate2) {
440             // each masterContract has different code already. So clones are distinguished by their data only.
441             bytes32 salt = keccak256(data);
442 
443             // Creates clone, more info here: https://blog.openzeppelin.com/deep-dive-into-the-minimal-proxy-contract/
444             assembly {
445                 let clone := mload(0x40)
446                 mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
447                 mstore(add(clone, 0x14), targetBytes)
448                 mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
449                 cloneAddress := create2(0, clone, 0x37, salt)
450             }
451         } else {
452             assembly {
453                 let clone := mload(0x40)
454                 mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
455                 mstore(add(clone, 0x14), targetBytes)
456                 mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
457                 cloneAddress := create(0, clone, 0x37)
458             }
459         }
460         masterContractOf[cloneAddress] = masterContract;
461 
462         IMasterContract(cloneAddress).init{value: msg.value}(data);
463 
464         emit LogDeploy(masterContract, data, cloneAddress);
465     }
466 }
467 
468 // File contracts/MasterContractManager.sol
469 // License-Identifier: UNLICENSED
470 
471 contract MasterContractManager is BoringOwnable, BoringFactory {
472     event LogWhiteListMasterContract(address indexed masterContract, bool approved);
473     event LogSetMasterContractApproval(address indexed masterContract, address indexed user, bool approved);
474     event LogRegisterProtocol(address indexed protocol);
475 
476     /// @notice masterContract to user to approval state
477     mapping(address => mapping(address => bool)) public masterContractApproved;
478     /// @notice masterContract to whitelisted state for approval without signed message
479     mapping(address => bool) public whitelistedMasterContracts;
480     /// @notice user nonces for masterContract approvals
481     mapping(address => uint256) public nonces;
482 
483     bytes32 private constant DOMAIN_SEPARATOR_SIGNATURE_HASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
484     // See https://eips.ethereum.org/EIPS/eip-191
485     string private constant EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA = "\x19\x01";
486     bytes32 private constant APPROVAL_SIGNATURE_HASH =
487         keccak256("SetMasterContractApproval(string warning,address user,address masterContract,bool approved,uint256 nonce)");
488 
489     // solhint-disable-next-line var-name-mixedcase
490     bytes32 private immutable _DOMAIN_SEPARATOR;
491     // solhint-disable-next-line var-name-mixedcase
492     uint256 private immutable DOMAIN_SEPARATOR_CHAIN_ID;
493 
494     constructor() public {
495         uint256 chainId;
496         assembly {
497             chainId := chainid()
498         }
499         _DOMAIN_SEPARATOR = _calculateDomainSeparator(DOMAIN_SEPARATOR_CHAIN_ID = chainId);
500     }
501 
502     function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32) {
503         return keccak256(abi.encode(DOMAIN_SEPARATOR_SIGNATURE_HASH, keccak256("BentoBox V1"), chainId, address(this)));
504     }
505 
506     // solhint-disable-next-line func-name-mixedcase
507     function DOMAIN_SEPARATOR() public view returns (bytes32) {
508         uint256 chainId;
509         assembly {
510             chainId := chainid()
511         }
512         return chainId == DOMAIN_SEPARATOR_CHAIN_ID ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId);
513     }
514 
515     /// @notice Other contracts need to register with this master contract so that users can approve them for the BentoBox.
516     function registerProtocol() public {
517         masterContractOf[msg.sender] = msg.sender;
518         emit LogRegisterProtocol(msg.sender);
519     }
520 
521     /// @notice Enables or disables a contract for approval without signed message.
522     function whitelistMasterContract(address masterContract, bool approved) public onlyOwner {
523         // Checks
524         require(masterContract != address(0), "MasterCMgr: Cannot approve 0");
525 
526         // Effects
527         whitelistedMasterContracts[masterContract] = approved;
528         emit LogWhiteListMasterContract(masterContract, approved);
529     }
530 
531     /// @notice Approves or revokes a `masterContract` access to `user` funds.
532     /// @param user The address of the user that approves or revokes access.
533     /// @param masterContract The address who gains or loses access.
534     /// @param approved If True approves access. If False revokes access.
535     /// @param v Part of the signature. (See EIP-191)
536     /// @param r Part of the signature. (See EIP-191)
537     /// @param s Part of the signature. (See EIP-191)
538     // F4 - Check behaviour for all function arguments when wrong or extreme
539     // F4: Don't allow masterContract 0 to be approved. Unknown contracts will have a masterContract of 0.
540     // F4: User can't be 0 for signed approvals because the recoveredAddress will be 0 if ecrecover fails
541     function setMasterContractApproval(
542         address user,
543         address masterContract,
544         bool approved,
545         uint8 v,
546         bytes32 r,
547         bytes32 s
548     ) public {
549         // Checks
550         require(masterContract != address(0), "MasterCMgr: masterC not set"); // Important for security
551 
552         // If no signature is provided, the fallback is executed
553         if (r == 0 && s == 0 && v == 0) {
554             require(user == msg.sender, "MasterCMgr: user not sender");
555             require(masterContractOf[user] == address(0), "MasterCMgr: user is clone");
556             require(whitelistedMasterContracts[masterContract], "MasterCMgr: not whitelisted");
557         } else {
558             // Important for security - any address without masterContract has address(0) as masterContract
559             // So approving address(0) would approve every address, leading to full loss of funds
560             // Also, ecrecover returns address(0) on failure. So we check this:
561             require(user != address(0), "MasterCMgr: User cannot be 0");
562 
563             // C10 - Protect signatures against replay, use nonce and chainId (SWC-121)
564             // C10: nonce + chainId are used to prevent replays
565             // C11 - All signatures strictly EIP-712 (SWC-117 SWC-122)
566             // C11: signature is EIP-712 compliant
567             // C12 - abi.encodePacked can't contain variable length user input (SWC-133)
568             // C12: abi.encodePacked has fixed length parameters
569             bytes32 digest =
570                 keccak256(
571                     abi.encodePacked(
572                         EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA,
573                         DOMAIN_SEPARATOR(),
574                         keccak256(
575                             abi.encode(
576                                 APPROVAL_SIGNATURE_HASH,
577                                 approved
578                                     ? keccak256("Give FULL access to funds in (and approved to) BentoBox?")
579                                     : keccak256("Revoke access to BentoBox?"),
580                                 user,
581                                 masterContract,
582                                 approved,
583                                 nonces[user]++
584                             )
585                         )
586                     )
587                 );
588             address recoveredAddress = ecrecover(digest, v, r, s);
589             require(recoveredAddress == user, "MasterCMgr: Invalid Signature");
590         }
591 
592         // Effects
593         masterContractApproved[masterContract][user] = approved;
594         emit LogSetMasterContractApproval(masterContract, user, approved);
595     }
596 }
597 
598 // File @boringcrypto/boring-solidity/contracts/BoringBatchable.sol@v1.2.0
599 // License-Identifier: MIT
600 
601 contract BaseBoringBatchable {
602     /// @dev Helper function to extract a useful revert message from a failed call.
603     /// If the returned data is malformed or not correctly abi encoded then this call can fail itself.
604     function _getRevertMsg(bytes memory _returnData) internal pure returns (string memory) {
605         // If the _res length is less than 68, then the transaction failed silently (without a revert message)
606         if (_returnData.length < 68) return "Transaction reverted silently";
607 
608         assembly {
609             // Slice the sighash.
610             _returnData := add(_returnData, 0x04)
611         }
612         return abi.decode(_returnData, (string)); // All that remains is the revert string
613     }
614 
615     /// @notice Allows batched call to self (this contract).
616     /// @param calls An array of inputs for each call.
617     /// @param revertOnFail If True then reverts after a failed call and stops doing further calls.
618     /// @return successes An array indicating the success of a call, mapped one-to-one to `calls`.
619     /// @return results An array with the returned data of each function call, mapped one-to-one to `calls`.
620     // F1: External is ok here because this is the batch function, adding it to a batch makes no sense
621     // F2: Calls in the batch may be payable, delegatecall operates in the same context, so each call in the batch has access to msg.value
622     // C3: The length of the loop is fully under user control, so can't be exploited
623     // C7: Delegatecall is only used on the same contract, so it's safe
624     function batch(bytes[] calldata calls, bool revertOnFail) external payable returns (bool[] memory successes, bytes[] memory results) {
625         successes = new bool[](calls.length);
626         results = new bytes[](calls.length);
627         for (uint256 i = 0; i < calls.length; i++) {
628             (bool success, bytes memory result) = address(this).delegatecall(calls[i]);
629             require(success || !revertOnFail, _getRevertMsg(result));
630             successes[i] = success;
631             results[i] = result;
632         }
633     }
634 }
635 
636 contract BoringBatchable is BaseBoringBatchable {
637     /// @notice Call wrapper that performs `ERC20.permit` on `token`.
638     /// Lookup `IERC20.permit`.
639     // F6: Parameters can be used front-run the permit and the user's permit will fail (due to nonce or other revert)
640     //     if part of a batch this could be used to grief once as the second call would not need the permit
641     function permitToken(
642         IERC20 token,
643         address from,
644         address to,
645         uint256 amount,
646         uint256 deadline,
647         uint8 v,
648         bytes32 r,
649         bytes32 s
650     ) public {
651         token.permit(from, to, amount, deadline, v, r, s);
652     }
653 }
654 
655 // File contracts/BentoBox.sol
656 // License-Identifier: UNLICENSED
657 
658 /// @title BentoBox
659 /// @author BoringCrypto, Keno
660 /// @notice The BentoBox is a vault for tokens. The stored tokens can be flash loaned and used in strategies.
661 /// Yield from this will go to the token depositors.
662 /// Rebasing tokens ARE NOT supported and WILL cause loss of funds.
663 /// Any funds transfered directly onto the BentoBox will be lost, use the deposit function instead.
664 contract BentoBoxV1 is MasterContractManager, BoringBatchable {
665     using BoringMath for uint256;
666     using BoringMath128 for uint128;
667     using BoringERC20 for IERC20;
668     using RebaseLibrary for Rebase;
669 
670     // ************** //
671     // *** EVENTS *** //
672     // ************** //
673 
674     event LogDeposit(IERC20 indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);
675     event LogWithdraw(IERC20 indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);
676     event LogTransfer(IERC20 indexed token, address indexed from, address indexed to, uint256 share);
677 
678     event LogFlashLoan(address indexed borrower, IERC20 indexed token, uint256 amount, uint256 feeAmount, address indexed receiver);
679 
680     event LogStrategyTargetPercentage(IERC20 indexed token, uint256 targetPercentage);
681     event LogStrategyQueued(IERC20 indexed token, IStrategy indexed strategy);
682     event LogStrategySet(IERC20 indexed token, IStrategy indexed strategy);
683     event LogStrategyInvest(IERC20 indexed token, uint256 amount);
684     event LogStrategyDivest(IERC20 indexed token, uint256 amount);
685     event LogStrategyProfit(IERC20 indexed token, uint256 amount);
686     event LogStrategyLoss(IERC20 indexed token, uint256 amount);
687 
688     // *************** //
689     // *** STRUCTS *** //
690     // *************** //
691 
692     struct StrategyData {
693         uint64 strategyStartDate;
694         uint64 targetPercentage;
695         uint128 balance; // the balance of the strategy that BentoBox thinks is in there
696     }
697 
698     // ******************************** //
699     // *** CONSTANTS AND IMMUTABLES *** //
700     // ******************************** //
701 
702     // V2 - Can they be private?
703     // V2: Private to save gas, to verify it's correct, check the constructor arguments
704     IERC20 private immutable wethToken;
705 
706     IERC20 private constant USE_ETHEREUM = IERC20(0);
707     uint256 private constant FLASH_LOAN_FEE = 50; // 0.05%
708     uint256 private constant FLASH_LOAN_FEE_PRECISION = 1e5;
709     uint256 private constant STRATEGY_DELAY = 2 weeks;
710     uint256 private constant MAX_TARGET_PERCENTAGE = 95; // 95%
711     uint256 private constant MINIMUM_SHARE_BALANCE = 1000; // To prevent the ratio going off
712 
713     // ***************** //
714     // *** VARIABLES *** //
715     // ***************** //
716 
717     // Balance per token per address/contract in shares
718     mapping(IERC20 => mapping(address => uint256)) public balanceOf;
719 
720     // Rebase from amount to share
721     mapping(IERC20 => Rebase) public totals;
722 
723     mapping(IERC20 => IStrategy) public strategy;
724     mapping(IERC20 => IStrategy) public pendingStrategy;
725     mapping(IERC20 => StrategyData) public strategyData;
726 
727     // ******************* //
728     // *** CONSTRUCTOR *** //
729     // ******************* //
730 
731     constructor(IERC20 wethToken_) public {
732         wethToken = wethToken_;
733     }
734 
735     // ***************** //
736     // *** MODIFIERS *** //
737     // ***************** //
738 
739     /// Modifier to check if the msg.sender is allowed to use funds belonging to the 'from' address.
740     /// If 'from' is msg.sender, it's allowed.
741     /// If 'from' is the BentoBox itself, it's allowed. Any ETH, token balances (above the known balances) or BentoBox balances
742     /// can be taken by anyone.
743     /// This is to enable skimming, not just for deposits, but also for withdrawals or transfers, enabling better composability.
744     /// If 'from' is a clone of a masterContract AND the 'from' address has approved that masterContract, it's allowed.
745     modifier allowed(address from) {
746         if (from != msg.sender && from != address(this)) {
747             // From is sender or you are skimming
748             address masterContract = masterContractOf[msg.sender];
749             require(masterContract != address(0), "BentoBox: no masterContract");
750             require(masterContractApproved[masterContract][from], "BentoBox: Transfer not approved");
751         }
752         _;
753     }
754 
755     // ************************** //
756     // *** INTERNAL FUNCTIONS *** //
757     // ************************** //
758 
759     /// @dev Returns the total balance of `token` this contracts holds,
760     /// plus the total amount this contract thinks the strategy holds.
761     function _tokenBalanceOf(IERC20 token) internal view returns (uint256 amount) {
762         amount = token.balanceOf(address(this)).add(strategyData[token].balance);
763     }
764 
765     // ************************ //
766     // *** PUBLIC FUNCTIONS *** //
767     // ************************ //
768 
769     /// @dev Helper function to represent an `amount` of `token` in shares.
770     /// @param token The ERC-20 token.
771     /// @param amount The `token` amount.
772     /// @param roundUp If the result `share` should be rounded up.
773     /// @return share The token amount represented in shares.
774     function toShare(
775         IERC20 token,
776         uint256 amount,
777         bool roundUp
778     ) external view returns (uint256 share) {
779         share = totals[token].toBase(amount, roundUp);
780     }
781 
782     /// @dev Helper function represent shares back into the `token` amount.
783     /// @param token The ERC-20 token.
784     /// @param share The amount of shares.
785     /// @param roundUp If the result should be rounded up.
786     /// @return amount The share amount back into native representation.
787     function toAmount(
788         IERC20 token,
789         uint256 share,
790         bool roundUp
791     ) external view returns (uint256 amount) {
792         amount = totals[token].toElastic(share, roundUp);
793     }
794 
795     /// @notice Deposit an amount of `token` represented in either `amount` or `share`.
796     /// @param token_ The ERC-20 token to deposit.
797     /// @param from which account to pull the tokens.
798     /// @param to which account to push the tokens.
799     /// @param amount Token amount in native representation to deposit.
800     /// @param share Token amount represented in shares to deposit. Takes precedence over `amount`.
801     /// @return amountOut The amount deposited.
802     /// @return shareOut The deposited amount repesented in shares.
803     function deposit(
804         IERC20 token_,
805         address from,
806         address to,
807         uint256 amount,
808         uint256 share
809     ) public payable allowed(from) returns (uint256 amountOut, uint256 shareOut) {
810         // Checks
811         require(to != address(0), "BentoBox: to not set"); // To avoid a bad UI from burning funds
812 
813         // Effects
814         IERC20 token = token_ == USE_ETHEREUM ? wethToken : token_;
815         Rebase memory total = totals[token];
816 
817         // If a new token gets added, the tokenSupply call checks that this is a deployed contract. Needed for security.
818         require(total.elastic != 0 || token.totalSupply() > 0, "BentoBox: No tokens");
819         if (share == 0) {
820             // value of the share may be lower than the amount due to rounding, that's ok
821             share = total.toBase(amount, false);
822             // Any deposit should lead to at least the minimum share balance, otherwise it's ignored (no amount taken)
823             if (total.base.add(share.to128()) < MINIMUM_SHARE_BALANCE) {
824                 return (0, 0);
825             }
826         } else {
827             // amount may be lower than the value of share due to rounding, in that case, add 1 to amount (Always round up)
828             amount = total.toElastic(share, true);
829         }
830 
831         // In case of skimming, check that only the skimmable amount is taken.
832         // For ETH, the full balance is available, so no need to check.
833         // During flashloans the _tokenBalanceOf is lower than 'reality', so skimming deposits will mostly fail during a flashloan.
834         require(
835             from != address(this) || token_ == USE_ETHEREUM || amount <= _tokenBalanceOf(token).sub(total.elastic),
836             "BentoBox: Skim too much"
837         );
838 
839         balanceOf[token][to] = balanceOf[token][to].add(share);
840         total.base = total.base.add(share.to128());
841         total.elastic = total.elastic.add(amount.to128());
842         totals[token] = total;
843 
844         // Interactions
845         // During the first deposit, we check that this token is 'real'
846         if (token_ == USE_ETHEREUM) {
847             // X2 - If there is an error, could it cause a DoS. Like balanceOf causing revert. (SWC-113)
848             // X2: If the WETH implementation is faulty or malicious, it will block adding ETH (but we know the WETH implementation)
849             IWETH(address(wethToken)).deposit{value: amount}();
850         } else if (from != address(this)) {
851             // X2 - If there is an error, could it cause a DoS. Like balanceOf causing revert. (SWC-113)
852             // X2: If the token implementation is faulty or malicious, it may block adding tokens. Good.
853             token.safeTransferFrom(from, address(this), amount);
854         }
855         emit LogDeposit(token, from, to, amount, share);
856         amountOut = amount;
857         shareOut = share;
858     }
859 
860     /// @notice Withdraws an amount of `token` from a user account.
861     /// @param token_ The ERC-20 token to withdraw.
862     /// @param from which user to pull the tokens.
863     /// @param to which user to push the tokens.
864     /// @param amount of tokens. Either one of `amount` or `share` needs to be supplied.
865     /// @param share Like above, but `share` takes precedence over `amount`.
866     function withdraw(
867         IERC20 token_,
868         address from,
869         address to,
870         uint256 amount,
871         uint256 share
872     ) public allowed(from) returns (uint256 amountOut, uint256 shareOut) {
873         // Checks
874         require(to != address(0), "BentoBox: to not set"); // To avoid a bad UI from burning funds
875 
876         // Effects
877         IERC20 token = token_ == USE_ETHEREUM ? wethToken : token_;
878         Rebase memory total = totals[token];
879         if (share == 0) {
880             // value of the share paid could be lower than the amount paid due to rounding, in that case, add a share (Always round up)
881             share = total.toBase(amount, true);
882         } else {
883             // amount may be lower than the value of share due to rounding, that's ok
884             amount = total.toElastic(share, false);
885         }
886 
887         balanceOf[token][from] = balanceOf[token][from].sub(share);
888         total.elastic = total.elastic.sub(amount.to128());
889         total.base = total.base.sub(share.to128());
890         // There have to be at least 1000 shares left to prevent reseting the share/amount ratio (unless it's fully emptied)
891         require(total.base >= MINIMUM_SHARE_BALANCE || total.base == 0, "BentoBox: cannot empty");
892         totals[token] = total;
893 
894         // Interactions
895         if (token_ == USE_ETHEREUM) {
896             // X2, X3: A revert or big gas usage in the WETH contract could block withdrawals, but WETH9 is fine.
897             IWETH(address(wethToken)).withdraw(amount);
898             // X2, X3: A revert or big gas usage could block, however, the to address is under control of the caller.
899             (bool success, ) = to.call{value: amount}("");
900             require(success, "BentoBox: ETH transfer failed");
901         } else {
902             // X2, X3: A malicious token could block withdrawal of just THAT token.
903             //         masterContracts may want to take care not to rely on withdraw always succeeding.
904             token.safeTransfer(to, amount);
905         }
906         emit LogWithdraw(token, from, to, amount, share);
907         amountOut = amount;
908         shareOut = share;
909     }
910 
911     /// @notice Transfer shares from a user account to another one.
912     /// @param token The ERC-20 token to transfer.
913     /// @param from which user to pull the tokens.
914     /// @param to which user to push the tokens.
915     /// @param share The amount of `token` in shares.
916     // Clones of master contracts can transfer from any account that has approved them
917     // F3 - Can it be combined with another similar function?
918     // F3: This isn't combined with transferMultiple for gas optimization
919     function transfer(
920         IERC20 token,
921         address from,
922         address to,
923         uint256 share
924     ) public allowed(from) {
925         // Checks
926         require(to != address(0), "BentoBox: to not set"); // To avoid a bad UI from burning funds
927 
928         // Effects
929         balanceOf[token][from] = balanceOf[token][from].sub(share);
930         balanceOf[token][to] = balanceOf[token][to].add(share);
931 
932         emit LogTransfer(token, from, to, share);
933     }
934 
935     /// @notice Transfer shares from a user account to multiple other ones.
936     /// @param token The ERC-20 token to transfer.
937     /// @param from which user to pull the tokens.
938     /// @param tos The receivers of the tokens.
939     /// @param shares The amount of `token` in shares for each receiver in `tos`.
940     // F3 - Can it be combined with another similar function?
941     // F3: This isn't combined with transfer for gas optimization
942     function transferMultiple(
943         IERC20 token,
944         address from,
945         address[] calldata tos,
946         uint256[] calldata shares
947     ) public allowed(from) {
948         // Checks
949         require(tos[0] != address(0), "BentoBox: to[0] not set"); // To avoid a bad UI from burning funds
950 
951         // Effects
952         uint256 totalAmount;
953         uint256 len = tos.length;
954         for (uint256 i = 0; i < len; i++) {
955             address to = tos[i];
956             balanceOf[token][to] = balanceOf[token][to].add(shares[i]);
957             totalAmount = totalAmount.add(shares[i]);
958             emit LogTransfer(token, from, to, shares[i]);
959         }
960         balanceOf[token][from] = balanceOf[token][from].sub(totalAmount);
961     }
962 
963     /// @notice Flashloan ability.
964     /// @param borrower The address of the contract that implements and conforms to `IFlashBorrower` and handles the flashloan.
965     /// @param receiver Address of the token receiver.
966     /// @param token The address of the token to receive.
967     /// @param amount of the tokens to receive.
968     /// @param data The calldata to pass to the `borrower` contract.
969     // F5 - Checks-Effects-Interactions pattern followed? (SWC-107)
970     // F5: Not possible to follow this here, reentrancy has been reviewed
971     // F6 - Check for front-running possibilities, such as the approve function (SWC-114)
972     // F6: Slight grieving possible by withdrawing an amount before someone tries to flashloan close to the full amount.
973     function flashLoan(
974         IFlashBorrower borrower,
975         address receiver,
976         IERC20 token,
977         uint256 amount,
978         bytes calldata data
979     ) public {
980         uint256 fee = amount.mul(FLASH_LOAN_FEE) / FLASH_LOAN_FEE_PRECISION;
981         token.safeTransfer(receiver, amount);
982 
983         borrower.onFlashLoan(msg.sender, token, amount, fee, data);
984 
985         require(_tokenBalanceOf(token) >= totals[token].addElastic(fee.to128()), "BentoBox: Wrong amount");
986         emit LogFlashLoan(address(borrower), token, amount, fee, receiver);
987     }
988 
989     /// @notice Support for batched flashloans. Useful to request multiple different `tokens` in a single transaction.
990     /// @param borrower The address of the contract that implements and conforms to `IBatchFlashBorrower` and handles the flashloan.
991     /// @param receivers An array of the token receivers. A one-to-one mapping with `tokens` and `amounts`.
992     /// @param tokens The addresses of the tokens.
993     /// @param amounts of the tokens for each receiver.
994     /// @param data The calldata to pass to the `borrower` contract.
995     // F5 - Checks-Effects-Interactions pattern followed? (SWC-107)
996     // F5: Not possible to follow this here, reentrancy has been reviewed
997     // F6 - Check for front-running possibilities, such as the approve function (SWC-114)
998     // F6: Slight grieving possible by withdrawing an amount before someone tries to flashloan close to the full amount.
999     function batchFlashLoan(
1000         IBatchFlashBorrower borrower,
1001         address[] calldata receivers,
1002         IERC20[] calldata tokens,
1003         uint256[] calldata amounts,
1004         bytes calldata data
1005     ) public {
1006         uint256[] memory fees = new uint256[](tokens.length);
1007 
1008         uint256 len = tokens.length;
1009         for (uint256 i = 0; i < len; i++) {
1010             uint256 amount = amounts[i];
1011             fees[i] = amount.mul(FLASH_LOAN_FEE) / FLASH_LOAN_FEE_PRECISION;
1012 
1013             tokens[i].safeTransfer(receivers[i], amounts[i]);
1014         }
1015 
1016         borrower.onBatchFlashLoan(msg.sender, tokens, amounts, fees, data);
1017 
1018         for (uint256 i = 0; i < len; i++) {
1019             IERC20 token = tokens[i];
1020             require(_tokenBalanceOf(token) >= totals[token].addElastic(fees[i].to128()), "BentoBox: Wrong amount");
1021             emit LogFlashLoan(address(borrower), token, amounts[i], fees[i], receivers[i]);
1022         }
1023     }
1024 
1025     /// @notice Sets the target percentage of the strategy for `token`.
1026     /// @dev Only the owner of this contract is allowed to change this.
1027     /// @param token The address of the token that maps to a strategy to change.
1028     /// @param targetPercentage_ The new target in percent. Must be lesser or equal to `MAX_TARGET_PERCENTAGE`.
1029     function setStrategyTargetPercentage(IERC20 token, uint64 targetPercentage_) public onlyOwner {
1030         // Checks
1031         require(targetPercentage_ <= MAX_TARGET_PERCENTAGE, "StrategyManager: Target too high");
1032 
1033         // Effects
1034         strategyData[token].targetPercentage = targetPercentage_;
1035         emit LogStrategyTargetPercentage(token, targetPercentage_);
1036     }
1037 
1038     /// @notice Sets the contract address of a new strategy that conforms to `IStrategy` for `token`.
1039     /// Must be called twice with the same arguments.
1040     /// A new strategy becomes pending first and can be activated once `STRATEGY_DELAY` is over.
1041     /// @dev Only the owner of this contract is allowed to change this.
1042     /// @param token The address of the token that maps to a strategy to change.
1043     /// @param newStrategy The address of the contract that conforms to `IStrategy`.
1044     // F5 - Checks-Effects-Interactions pattern followed? (SWC-107)
1045     // F5: Total amount is updated AFTER interaction. But strategy is under our control.
1046     // C4 - Use block.timestamp only for long intervals (SWC-116)
1047     // C4: block.timestamp is used for a period of 2 weeks, which is long enough
1048     function setStrategy(IERC20 token, IStrategy newStrategy) public onlyOwner {
1049         StrategyData memory data = strategyData[token];
1050         IStrategy pending = pendingStrategy[token];
1051         if (data.strategyStartDate == 0 || pending != newStrategy) {
1052             pendingStrategy[token] = newStrategy;
1053             // C1 - All math done through BoringMath (SWC-101)
1054             // C1: Our sun will swallow the earth well before this overflows
1055             data.strategyStartDate = (block.timestamp + STRATEGY_DELAY).to64();
1056             emit LogStrategyQueued(token, newStrategy);
1057         } else {
1058             require(data.strategyStartDate != 0 && block.timestamp >= data.strategyStartDate, "StrategyManager: Too early");
1059             if (address(strategy[token]) != address(0)) {
1060                 int256 balanceChange = strategy[token].exit(data.balance);
1061                 // Effects
1062                 if (balanceChange > 0) {
1063                     uint256 add = uint256(balanceChange);
1064                     totals[token].addElastic(add);
1065                     emit LogStrategyProfit(token, add);
1066                 } else if (balanceChange < 0) {
1067                     uint256 sub = uint256(-balanceChange);
1068                     totals[token].subElastic(sub);
1069                     emit LogStrategyLoss(token, sub);
1070                 }
1071 
1072                 emit LogStrategyDivest(token, data.balance);
1073             }
1074             strategy[token] = pending;
1075             data.strategyStartDate = 0;
1076             data.balance = 0;
1077             pendingStrategy[token] = IStrategy(0);
1078             emit LogStrategySet(token, newStrategy);
1079         }
1080         strategyData[token] = data;
1081     }
1082 
1083     /// @notice The actual process of yield farming. Executes the strategy of `token`.
1084     /// Optionally does housekeeping if `balance` is true.
1085     /// `maxChangeAmount` is relevant for skimming or withdrawing if `balance` is true.
1086     /// @param token The address of the token for which a strategy is deployed.
1087     /// @param balance True if housekeeping should be done.
1088     /// @param maxChangeAmount The maximum amount for either pulling or pushing from/to the `IStrategy` contract.
1089     // F5 - Checks-Effects-Interactions pattern followed? (SWC-107)
1090     // F5: Total amount is updated AFTER interaction. But strategy is under our control.
1091     // F5: Not followed to prevent reentrancy issues with flashloans and BentoBox skims?
1092     function harvest(
1093         IERC20 token,
1094         bool balance,
1095         uint256 maxChangeAmount
1096     ) public {
1097         StrategyData memory data = strategyData[token];
1098         IStrategy _strategy = strategy[token];
1099         int256 balanceChange = _strategy.harvest(data.balance, msg.sender);
1100         if (balanceChange == 0 && !balance) {
1101             return;
1102         }
1103 
1104         uint256 totalElastic = totals[token].elastic;
1105 
1106         if (balanceChange > 0) {
1107             uint256 add = uint256(balanceChange);
1108             totalElastic = totalElastic.add(add);
1109             totals[token].elastic = totalElastic.to128();
1110             emit LogStrategyProfit(token, add);
1111         } else if (balanceChange < 0) {
1112             // C1 - All math done through BoringMath (SWC-101)
1113             // C1: balanceChange could overflow if it's max negative int128.
1114             // But tokens with balances that large are not supported by the BentoBox.
1115             uint256 sub = uint256(-balanceChange);
1116             totalElastic = totalElastic.sub(sub);
1117             totals[token].elastic = totalElastic.to128();
1118             data.balance = data.balance.sub(sub.to128());
1119             emit LogStrategyLoss(token, sub);
1120         }
1121 
1122         if (balance) {
1123             uint256 targetBalance = totalElastic.mul(data.targetPercentage) / 100;
1124             // if data.balance == targetBalance there is nothing to update
1125             if (data.balance < targetBalance) {
1126                 uint256 amountOut = targetBalance.sub(data.balance);
1127                 if (maxChangeAmount != 0 && amountOut > maxChangeAmount) {
1128                     amountOut = maxChangeAmount;
1129                 }
1130                 token.safeTransfer(address(_strategy), amountOut);
1131                 data.balance = data.balance.add(amountOut.to128());
1132                 _strategy.skim(amountOut);
1133                 emit LogStrategyInvest(token, amountOut);
1134             } else if (data.balance > targetBalance) {
1135                 uint256 amountIn = data.balance.sub(targetBalance.to128());
1136                 if (maxChangeAmount != 0 && amountIn > maxChangeAmount) {
1137                     amountIn = maxChangeAmount;
1138                 }
1139 
1140                 uint256 actualAmountIn = _strategy.withdraw(amountIn);
1141 
1142                 data.balance = data.balance.sub(actualAmountIn.to128());
1143                 emit LogStrategyDivest(token, actualAmountIn);
1144             }
1145         }
1146 
1147         strategyData[token] = data;
1148     }
1149 
1150     // Contract should be able to receive ETH deposits to support deposit & skim
1151     // solhint-disable-next-line no-empty-blocks
1152     receive() external payable {}
1153 }
