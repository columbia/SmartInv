1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 interface IERC20 {
7     function totalSupply() external view returns (uint256);
8 
9     function balanceOf(address account) external view returns (uint256);
10 
11     function allowance(address owner, address spender) external view returns (uint256);
12 
13     function approve(address spender, uint256 amount) external returns (bool);
14 
15     event Transfer(address indexed from, address indexed to, uint256 value);
16     event Approval(address indexed owner, address indexed spender, uint256 value);
17 
18     /// @notice EIP 2612
19     function permit(
20         address owner,
21         address spender,
22         uint256 value,
23         uint256 deadline,
24         uint8 v,
25         bytes32 r,
26         bytes32 s
27     ) external;
28 }
29 
30 interface IFlashBorrower {
31     /// @notice The flashloan callback. `amount` + `fee` needs to repayed to msg.sender before this call returns.
32     /// @param sender The address of the invoker of this flashloan.
33     /// @param token The address of the token that is loaned.
34     /// @param amount of the `token` that is loaned.
35     /// @param fee The fee that needs to be paid on top for this loan. Needs to be the same as `token`.
36     /// @param data Additional data that was passed to the flashloan function.
37     function onFlashLoan(
38         address sender,
39         IERC20 token,
40         uint256 amount,
41         uint256 fee,
42         bytes calldata data
43     ) external;
44 }
45 
46 interface IBatchFlashBorrower {
47     /// @notice The callback for batched flashloans. Every amount + fee needs to repayed to msg.sender before this call returns.
48     /// @param sender The address of the invoker of this flashloan.
49     /// @param tokens Array of addresses for ERC-20 tokens that is loaned.
50     /// @param amounts A one-to-one map to `tokens` that is loaned.
51     /// @param fees A one-to-one map to `tokens` that needs to be paid on top for each loan. Needs to be the same token.
52     /// @param data Additional data that was passed to the flashloan function.
53     function onBatchFlashLoan(
54         address sender,
55         IERC20[] calldata tokens,
56         uint256[] calldata amounts,
57         uint256[] calldata fees,
58         bytes calldata data
59     ) external;
60 }
61 
62 interface IWETH {
63     function deposit() external payable;
64 
65     function withdraw(uint256) external;
66 }
67 
68 interface IStrategy {
69     /// @notice Send the assets to the Strategy and call skim to invest them.
70     /// @param amount The amount of tokens to invest.
71     function skim(uint256 amount) external;
72 
73     /// @notice Harvest any profits made converted to the asset and pass them to the caller.
74     /// @param balance The amount of tokens the caller thinks it has invested.
75     /// @param sender The address of the initiator of this transaction. Can be used for reimbursements, etc.
76     /// @return amountAdded The delta (+profit or -loss) that occured in contrast to `balance`.
77     function harvest(uint256 balance, address sender) external returns (int256 amountAdded);
78 
79     /// @notice Withdraw assets. The returned amount can differ from the requested amount due to rounding.
80     /// @dev The `actualAmount` should be very close to the amount.
81     /// The difference should NOT be used to report a loss. That's what harvest is for.
82     /// @param amount The requested amount the caller wants to withdraw.
83     /// @return actualAmount The real amount that is withdrawn.
84     function withdraw(uint256 amount) external returns (uint256 actualAmount);
85 
86     /// @notice Withdraw all assets in the safest way possible. This shouldn't fail.
87     /// @param balance The amount of tokens the caller thinks it has invested.
88     /// @return amountAdded The delta (+profit or -loss) that occured in contrast to `balance`.
89     function exit(uint256 balance) external returns (int256 amountAdded);
90 }
91 
92 library BoringERC20 {
93     bytes4 private constant SIG_SYMBOL = 0x95d89b41; // symbol()
94     bytes4 private constant SIG_NAME = 0x06fdde03; // name()
95     bytes4 private constant SIG_DECIMALS = 0x313ce567; // decimals()
96     bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)
97     bytes4 private constant SIG_TRANSFER_FROM = 0x23b872dd; // transferFrom(address,address,uint256)
98 
99     /// @notice Provides a safe ERC20.transfer version for different ERC-20 implementations.
100     /// Reverts on a failed transfer.
101     /// @param token The address of the ERC-20 token.
102     /// @param to Transfer tokens to.
103     /// @param amount The token amount.
104     function safeTransfer(
105         IERC20 token,
106         address to,
107         uint256 amount
108     ) internal {
109         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER, to, amount));
110         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: Transfer failed");
111     }
112 
113     /// @notice Provides a safe ERC20.transferFrom version for different ERC-20 implementations.
114     /// Reverts on a failed transfer.
115     /// @param token The address of the ERC-20 token.
116     /// @param from Transfer tokens from.
117     /// @param to Transfer tokens to.
118     /// @param amount The token amount.
119     function safeTransferFrom(
120         IERC20 token,
121         address from,
122         address to,
123         uint256 amount
124     ) internal {
125         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER_FROM, from, to, amount));
126         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: TransferFrom failed");
127     }
128 }
129 
130 /// @notice A library for performing overflow-/underflow-safe math
131 library BoringMath {
132     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
133         require((c = a + b) >= b, "BoringMath: Add Overflow");
134     }
135 
136     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
137         require((c = a - b) <= a, "BoringMath: Underflow");
138     }
139 
140     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
141         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
142     }
143 
144     function to128(uint256 a) internal pure returns (uint128 c) {
145         require(a <= uint128(-1), "BoringMath: uint128 Overflow");
146         c = uint128(a);
147     }
148 
149     function to64(uint256 a) internal pure returns (uint64 c) {
150         require(a <= uint64(-1), "BoringMath: uint64 Overflow");
151         c = uint64(a);
152     }
153 
154     function to32(uint256 a) internal pure returns (uint32 c) {
155         require(a <= uint32(-1), "BoringMath: uint32 Overflow");
156         c = uint32(a);
157     }
158 }
159 
160 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint128.
161 library BoringMath128 {
162     function add(uint128 a, uint128 b) internal pure returns (uint128 c) {
163         require((c = a + b) >= b, "BoringMath: Add Overflow");
164     }
165 
166     function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {
167         require((c = a - b) <= a, "BoringMath: Underflow");
168     }
169 }
170 
171 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint64.
172 library BoringMath64 {
173     function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
174         require((c = a + b) >= b, "BoringMath: Add Overflow");
175     }
176 
177     function sub(uint64 a, uint64 b) internal pure returns (uint64 c) {
178         require((c = a - b) <= a, "BoringMath: Underflow");
179     }
180 }
181 
182 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.
183 library BoringMath32 {
184     function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
185         require((c = a + b) >= b, "BoringMath: Add Overflow");
186     }
187 
188     function sub(uint32 a, uint32 b) internal pure returns (uint32 c) {
189         require((c = a - b) <= a, "BoringMath: Underflow");
190     }
191 }
192 
193 struct Rebase {
194     uint128 elastic;
195     uint128 base;
196 }
197 
198 /// @notice A rebasing library using overflow-/underflow-safe math.
199 library RebaseLibrary {
200     using BoringMath for uint256;
201     using BoringMath128 for uint128;
202 
203     /// @notice Calculates the base value in relationship to `elastic` and `total`.
204     function toBase(
205         Rebase memory total,
206         uint256 elastic,
207         bool roundUp
208     ) internal pure returns (uint256 base) {
209         if (total.elastic == 0) {
210             base = elastic;
211         } else {
212             base = elastic.mul(total.base) / total.elastic;
213             if (roundUp && base.mul(total.elastic) / total.base < elastic) {
214                 base = base.add(1);
215             }
216         }
217     }
218 
219     /// @notice Calculates the elastic value in relationship to `base` and `total`.
220     function toElastic(
221         Rebase memory total,
222         uint256 base,
223         bool roundUp
224     ) internal pure returns (uint256 elastic) {
225         if (total.base == 0) {
226             elastic = base;
227         } else {
228             elastic = base.mul(total.elastic) / total.base;
229             if (roundUp && elastic.mul(total.base) / total.elastic < base) {
230                 elastic = elastic.add(1);
231             }
232         }
233     }
234 
235     /// @notice Add `elastic` to `total` and doubles `total.base`.
236     /// @return (Rebase) The new total.
237     /// @return base in relationship to `elastic`.
238     function add(
239         Rebase memory total,
240         uint256 elastic,
241         bool roundUp
242     ) internal pure returns (Rebase memory, uint256 base) {
243         base = toBase(total, elastic, roundUp);
244         total.elastic = total.elastic.add(elastic.to128());
245         total.base = total.base.add(base.to128());
246         return (total, base);
247     }
248 
249     /// @notice Sub `base` from `total` and update `total.elastic`.
250     /// @return (Rebase) The new total.
251     /// @return elastic in relationship to `base`.
252     function sub(
253         Rebase memory total,
254         uint256 base,
255         bool roundUp
256     ) internal pure returns (Rebase memory, uint256 elastic) {
257         elastic = toElastic(total, base, roundUp);
258         total.elastic = total.elastic.sub(elastic.to128());
259         total.base = total.base.sub(base.to128());
260         return (total, elastic);
261     }
262 
263     /// @notice Add `elastic` and `base` to `total`.
264     function add(
265         Rebase memory total,
266         uint256 elastic,
267         uint256 base
268     ) internal pure returns (Rebase memory) {
269         total.elastic = total.elastic.add(elastic.to128());
270         total.base = total.base.add(base.to128());
271         return total;
272     }
273 
274     /// @notice Subtract `elastic` and `base` to `total`.
275     function sub(
276         Rebase memory total,
277         uint256 elastic,
278         uint256 base
279     ) internal pure returns (Rebase memory) {
280         total.elastic = total.elastic.sub(elastic.to128());
281         total.base = total.base.sub(base.to128());
282         return total;
283     }
284 
285     /// @notice Add `elastic` to `total` and update storage.
286     /// @return newElastic Returns updated `elastic`.
287     function addElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {
288         newElastic = total.elastic = total.elastic.add(elastic.to128());
289     }
290 
291     /// @notice Subtract `elastic` from `total` and update storage.
292     /// @return newElastic Returns updated `elastic`.
293     function subElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {
294         newElastic = total.elastic = total.elastic.sub(elastic.to128());
295     }
296 }
297 
298 contract BoringOwnableData {
299     address public owner;
300     address public pendingOwner;
301 }
302 
303 contract BoringOwnable is BoringOwnableData {
304     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
305 
306     /// @notice `owner` defaults to msg.sender on construction.
307     constructor() public {
308         owner = msg.sender;
309         emit OwnershipTransferred(address(0), msg.sender);
310     }
311 
312     /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.
313     /// Can only be invoked by the current `owner`.
314     /// @param newOwner Address of the new owner.
315     /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.
316     /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.
317     function transferOwnership(
318         address newOwner,
319         bool direct,
320         bool renounce
321     ) public onlyOwner {
322         if (direct) {
323             // Checks
324             require(newOwner != address(0) || renounce, "Ownable: zero address");
325 
326             // Effects
327             emit OwnershipTransferred(owner, newOwner);
328             owner = newOwner;
329             pendingOwner = address(0);
330         } else {
331             // Effects
332             pendingOwner = newOwner;
333         }
334     }
335 
336     /// @notice Needs to be called by `pendingOwner` to claim ownership.
337     function claimOwnership() public {
338         address _pendingOwner = pendingOwner;
339 
340         // Checks
341         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
342 
343         // Effects
344         emit OwnershipTransferred(owner, _pendingOwner);
345         owner = _pendingOwner;
346         pendingOwner = address(0);
347     }
348 
349     /// @notice Only allows the `owner` to execute the function.
350     modifier onlyOwner() {
351         require(msg.sender == owner, "Ownable: caller is not the owner");
352         _;
353     }
354 }
355 
356 interface IMasterContract {
357     /// @notice Init function that gets called from `BoringFactory.deploy`.
358     /// Also kown as the constructor for cloned contracts.
359     /// Any ETH send to `BoringFactory.deploy` ends up here.
360     /// @param data Can be abi encoded arguments or anything else.
361     function init(bytes calldata data) external payable;
362 }
363 
364 contract BoringFactory {
365     event LogDeploy(address indexed masterContract, bytes data, address indexed cloneAddress);
366 
367     /// @notice Mapping from clone contracts to their masterContract.
368     mapping(address => address) public masterContractOf;
369 
370     /// @notice List of deployed pools.
371     address[] public pools;
372 
373     /// @notice Deploys a given master Contract as a clone.
374     /// Any ETH transferred with this call is forwarded to the new clone.
375     /// Emits `LogDeploy`.
376     /// @param masterContract The address of the contract to clone.
377     /// @param data Additional abi encoded calldata that is passed to the new clone via `IMasterContract.init`.
378     /// @param useCreate2 Creates the clone by using the CREATE2 opcode, in this case `data` will be used as salt.
379     /// @return cloneAddress Address of the created clone contract.
380     function deploy(
381         address masterContract,
382         bytes calldata data,
383         bool useCreate2
384     ) public payable returns (address cloneAddress) {
385         require(masterContract != address(0), "BoringFactory: No masterContract");
386         bytes20 targetBytes = bytes20(masterContract); // Takes the first 20 bytes of the masterContract's address
387 
388         if (useCreate2) {
389             // each masterContract has different code already. So clones are distinguished by their data only.
390             bytes32 salt = keccak256(data);
391 
392             // Creates clone, more info here: https://blog.openzeppelin.com/deep-dive-into-the-minimal-proxy-contract/
393             assembly {
394                 let clone := mload(0x40)
395                 mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
396                 mstore(add(clone, 0x14), targetBytes)
397                 mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
398                 cloneAddress := create2(0, clone, 0x37, salt)
399             }
400         } else {
401             assembly {
402                 let clone := mload(0x40)
403                 mstore(clone, 0x3d602d80600a3d3981f3363d3d373d3d3d363d73000000000000000000000000)
404                 mstore(add(clone, 0x14), targetBytes)
405                 mstore(add(clone, 0x28), 0x5af43d82803e903d91602b57fd5bf30000000000000000000000000000000000)
406                 cloneAddress := create(0, clone, 0x37)
407             }
408         }
409         masterContractOf[cloneAddress] = masterContract;
410         pools.push(cloneAddress);
411 
412         IMasterContract(cloneAddress).init{value: msg.value}(data);
413 
414         emit LogDeploy(masterContract, data, cloneAddress);
415     }
416 
417     /// @notice Returns all deployed pools.
418     /// @return Addresses of deployed pools.
419     function getAllPools() public view returns (address[] memory) {
420          return pools;
421      }
422 }
423 
424 contract MasterContractManager is BoringOwnable, BoringFactory {
425     event LogWhiteListMasterContract(address indexed masterContract, bool approved);
426     event LogSetMasterContractApproval(address indexed masterContract, address indexed user, bool approved);
427     event LogRegisterProtocol(address indexed protocol);
428 
429     /// @notice masterContract to user to approval state
430     mapping(address => mapping(address => bool)) public masterContractApproved;
431     /// @notice masterContract to whitelisted state for approval without signed message
432     mapping(address => bool) public whitelistedMasterContracts;
433     /// @notice user nonces for masterContract approvals
434     mapping(address => uint256) public nonces;
435 
436     bytes32 private constant DOMAIN_SEPARATOR_SIGNATURE_HASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
437     // See https://eips.ethereum.org/EIPS/eip-191
438     string private constant EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA = "\x19\x01";
439     bytes32 private constant APPROVAL_SIGNATURE_HASH =
440         keccak256("SetMasterContractApproval(string warning,address user,address masterContract,bool approved,uint256 nonce)");
441 
442     // solhint-disable-next-line var-name-mixedcase
443     bytes32 private immutable _DOMAIN_SEPARATOR;
444     // solhint-disable-next-line var-name-mixedcase
445     uint256 private immutable DOMAIN_SEPARATOR_CHAIN_ID;
446 
447     constructor() public {
448         uint256 chainId;
449         assembly {
450             chainId := chainid()
451         }
452         _DOMAIN_SEPARATOR = _calculateDomainSeparator(DOMAIN_SEPARATOR_CHAIN_ID = chainId);
453     }
454 
455     function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32) {
456         return keccak256(abi.encode(DOMAIN_SEPARATOR_SIGNATURE_HASH, keccak256("BentoBox V1"), chainId, address(this)));
457     }
458 
459     // solhint-disable-next-line func-name-mixedcase
460     function DOMAIN_SEPARATOR() public view returns (bytes32) {
461         uint256 chainId;
462         assembly {
463             chainId := chainid()
464         }
465         return chainId == DOMAIN_SEPARATOR_CHAIN_ID ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId);
466     }
467 
468     /// @notice Other contracts need to register with this master contract so that users can approve them for the BentoBox.
469     function registerProtocol() public {
470         masterContractOf[msg.sender] = msg.sender;
471         emit LogRegisterProtocol(msg.sender);
472     }
473 
474     /// @notice Enables or disables a contract for approval without signed message.
475     function whitelistMasterContract(address masterContract, bool approved) public onlyOwner {
476         // Checks
477         require(masterContract != address(0), "MasterCMgr: Cannot approve 0");
478 
479         // Effects
480         whitelistedMasterContracts[masterContract] = approved;
481         emit LogWhiteListMasterContract(masterContract, approved);
482     }
483 
484     /// @notice Approves or revokes a `masterContract` access to `user` funds.
485     /// @param user The address of the user that approves or revokes access.
486     /// @param masterContract The address who gains or loses access.
487     /// @param approved If True approves access. If False revokes access.
488     /// @param v Part of the signature. (See EIP-191)
489     /// @param r Part of the signature. (See EIP-191)
490     /// @param s Part of the signature. (See EIP-191)
491     // F4 - Check behaviour for all function arguments when wrong or extreme
492     // F4: Don't allow masterContract 0 to be approved. Unknown contracts will have a masterContract of 0.
493     // F4: User can't be 0 for signed approvals because the recoveredAddress will be 0 if ecrecover fails
494     function setMasterContractApproval(
495         address user,
496         address masterContract,
497         bool approved,
498         uint8 v,
499         bytes32 r,
500         bytes32 s
501     ) public {
502         // Checks
503         require(masterContract != address(0), "MasterCMgr: masterC not set"); // Important for security
504 
505         // If no signature is provided, the fallback is executed
506         if (r == 0 && s == 0 && v == 0) {
507             require(user == msg.sender, "MasterCMgr: user not sender");
508             require(masterContractOf[user] == address(0), "MasterCMgr: user is clone");
509             require(whitelistedMasterContracts[masterContract], "MasterCMgr: not whitelisted");
510         } else {
511             // Important for security - any address without masterContract has address(0) as masterContract
512             // So approving address(0) would approve every address, leading to full loss of funds
513             // Also, ecrecover returns address(0) on failure. So we check this:
514             require(user != address(0), "MasterCMgr: User cannot be 0");
515 
516             // C10 - Protect signatures against replay, use nonce and chainId (SWC-121)
517             // C10: nonce + chainId are used to prevent replays
518             // C11 - All signatures strictly EIP-712 (SWC-117 SWC-122)
519             // C11: signature is EIP-712 compliant
520             // C12 - abi.encodePacked can't contain variable length user input (SWC-133)
521             // C12: abi.encodePacked has fixed length parameters
522             bytes32 digest =
523                 keccak256(
524                     abi.encodePacked(
525                         EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA,
526                         DOMAIN_SEPARATOR(),
527                         keccak256(
528                             abi.encode(
529                                 APPROVAL_SIGNATURE_HASH,
530                                 approved
531                                     ? keccak256("Give FULL access to funds in (and approved to) BentoBox?")
532                                     : keccak256("Revoke access to BentoBox?"),
533                                 user,
534                                 masterContract,
535                                 approved,
536                                 nonces[user]++
537                             )
538                         )
539                     )
540                 );
541             address recoveredAddress = ecrecover(digest, v, r, s);
542             require(recoveredAddress == user, "MasterCMgr: Invalid Signature");
543         }
544 
545         // Effects
546         masterContractApproved[masterContract][user] = approved;
547         emit LogSetMasterContractApproval(masterContract, user, approved);
548     }
549 }
550 
551 contract BaseBoringBatchable {
552     /// @dev Helper function to extract a useful revert message from a failed call.
553     /// If the returned data is malformed or not correctly abi encoded then this call can fail itself.
554     function _getRevertMsg(bytes memory _returnData) internal pure returns (string memory) {
555         // If the _res length is less than 68, then the transaction failed silently (without a revert message)
556         if (_returnData.length < 68) return "Transaction reverted silently";
557 
558         assembly {
559             // Slice the sighash.
560             _returnData := add(_returnData, 0x04)
561         }
562         return abi.decode(_returnData, (string)); // All that remains is the revert string
563     }
564 
565     /// @notice Allows batched call to self (this contract).
566     /// @param calls An array of inputs for each call.
567     /// @param revertOnFail If True then reverts after a failed call and stops doing further calls.
568     /// @return successes An array indicating the success of a call, mapped one-to-one to `calls`.
569     /// @return results An array with the returned data of each function call, mapped one-to-one to `calls`.
570     // F1: External is ok here because this is the batch function, adding it to a batch makes no sense
571     // F2: Calls in the batch may be payable, delegatecall operates in the same context, so each call in the batch has access to msg.value
572     // C3: The length of the loop is fully under user control, so can't be exploited
573     // C7: Delegatecall is only used on the same contract, so it's safe
574     function batch(bytes[] calldata calls, bool revertOnFail) external payable returns (bool[] memory successes, bytes[] memory results) {
575         successes = new bool[](calls.length);
576         results = new bytes[](calls.length);
577         for (uint256 i = 0; i < calls.length; i++) {
578             (bool success, bytes memory result) = address(this).delegatecall(calls[i]);
579             require(success || !revertOnFail, _getRevertMsg(result));
580             successes[i] = success;
581             results[i] = result;
582         }
583     }
584 }
585 
586 contract BoringBatchable is BaseBoringBatchable {
587     /// @notice Call wrapper that performs `ERC20.permit` on `token`.
588     /// Lookup `IERC20.permit`.
589     // F6: Parameters can be used front-run the permit and the user's permit will fail (due to nonce or other revert)
590     //     if part of a batch this could be used to grief once as the second call would not need the permit
591     function permitToken(
592         IERC20 token,
593         address from,
594         address to,
595         uint256 amount,
596         uint256 deadline,
597         uint8 v,
598         bytes32 r,
599         bytes32 s
600     ) public {
601         token.permit(from, to, amount, deadline, v, r, s);
602     }
603 }
604 
605 /// Yield from this will go to the token depositors.
606 /// Rebasing tokens ARE NOT supported and WILL cause loss of funds.
607 /// Any funds transfered directly onto the BentoBox will be lost, use the deposit function instead.
608 contract DegenBox is MasterContractManager, BoringBatchable {
609     using BoringMath for uint256;
610     using BoringMath128 for uint128;
611     using BoringERC20 for IERC20;
612     using RebaseLibrary for Rebase;
613 
614     // ************** //
615     // *** EVENTS *** //
616     // ************** //
617 
618     event LogDeposit(IERC20 indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);
619     event LogWithdraw(IERC20 indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);
620     event LogTransfer(IERC20 indexed token, address indexed from, address indexed to, uint256 share);
621 
622     event LogFlashLoan(address indexed borrower, IERC20 indexed token, uint256 amount, uint256 feeAmount, address indexed receiver);
623 
624     event LogStrategyTargetPercentage(IERC20 indexed token, uint256 targetPercentage);
625     event LogStrategyQueued(IERC20 indexed token, IStrategy indexed strategy);
626     event LogStrategySet(IERC20 indexed token, IStrategy indexed strategy);
627     event LogStrategyInvest(IERC20 indexed token, uint256 amount);
628     event LogStrategyDivest(IERC20 indexed token, uint256 amount);
629     event LogStrategyProfit(IERC20 indexed token, uint256 amount);
630     event LogStrategyLoss(IERC20 indexed token, uint256 amount);
631 
632     // *************** //
633     // *** STRUCTS *** //
634     // *************** //
635 
636     struct StrategyData {
637         uint64 strategyStartDate;
638         uint64 targetPercentage;
639         uint128 balance; // the balance of the strategy that BentoBox thinks is in there
640     }
641 
642     // ******************************** //
643     // *** CONSTANTS AND IMMUTABLES *** //
644     // ******************************** //
645 
646     // V2 - Can they be private?
647     // V2: Private to save gas, to verify it's correct, check the constructor arguments
648     IERC20 private immutable wethToken;
649 
650     IERC20 private constant USE_ETHEREUM = IERC20(0);
651     uint256 private constant FLASH_LOAN_FEE = 50; // 0.05%
652     uint256 private constant FLASH_LOAN_FEE_PRECISION = 1e5;
653     uint256 private constant STRATEGY_DELAY = 3 days;
654     uint256 private constant MAX_TARGET_PERCENTAGE = 95; // 95%
655     uint256 private constant MINIMUM_SHARE_BALANCE = 1000; // To prevent the ratio going off
656 
657     // ***************** //
658     // *** VARIABLES *** //
659     // ***************** //
660 
661     // Balance per token per address/contract in shares
662     mapping(IERC20 => mapping(address => uint256)) public balanceOf;
663 
664     // Rebase from amount to share
665     mapping(IERC20 => Rebase) public totals;
666 
667     mapping(IERC20 => IStrategy) public strategy;
668     mapping(IERC20 => IStrategy) public pendingStrategy;
669     mapping(IERC20 => StrategyData) public strategyData;
670 
671     // ******************* //
672     // *** CONSTRUCTOR *** //
673     // ******************* //
674 
675     constructor(IERC20 wethToken_) public {
676         wethToken = wethToken_;
677     }
678 
679     // ***************** //
680     // *** MODIFIERS *** //
681     // ***************** //
682 
683     /// Modifier to check if the msg.sender is allowed to use funds belonging to the 'from' address.
684     /// If 'from' is msg.sender, it's allowed.
685     /// If 'from' is the BentoBox itself, it's allowed. Any ETH, token balances (above the known balances) or BentoBox balances
686     /// can be taken by anyone.
687     /// This is to enable skimming, not just for deposits, but also for withdrawals or transfers, enabling better composability.
688     /// If 'from' is a clone of a masterContract AND the 'from' address has approved that masterContract, it's allowed.
689     modifier allowed(address from) {
690         if (from != msg.sender && from != address(this)) {
691             // From is sender or you are skimming
692             address masterContract = masterContractOf[msg.sender];
693             require(masterContract != address(0), "BentoBox: no masterContract");
694             require(masterContractApproved[masterContract][from], "BentoBox: Transfer not approved");
695         }
696         _;
697     }
698 
699     // ************************** //
700     // *** INTERNAL FUNCTIONS *** //
701     // ************************** //
702 
703     /// @dev Returns the total balance of `token` this contracts holds,
704     /// plus the total amount this contract thinks the strategy holds.
705     function _tokenBalanceOf(IERC20 token) internal view returns (uint256 amount) {
706         amount = token.balanceOf(address(this)).add(strategyData[token].balance);
707     }
708 
709     // ************************ //
710     // *** PUBLIC FUNCTIONS *** //
711     // ************************ //
712 
713     /// @dev Helper function to represent an `amount` of `token` in shares.
714     /// @param token The ERC-20 token.
715     /// @param amount The `token` amount.
716     /// @param roundUp If the result `share` should be rounded up.
717     /// @return share The token amount represented in shares.
718     function toShare(
719         IERC20 token,
720         uint256 amount,
721         bool roundUp
722     ) external view returns (uint256 share) {
723         share = totals[token].toBase(amount, roundUp);
724     }
725 
726     /// @dev Helper function represent shares back into the `token` amount.
727     /// @param token The ERC-20 token.
728     /// @param share The amount of shares.
729     /// @param roundUp If the result should be rounded up.
730     /// @return amount The share amount back into native representation.
731     function toAmount(
732         IERC20 token,
733         uint256 share,
734         bool roundUp
735     ) external view returns (uint256 amount) {
736         amount = totals[token].toElastic(share, roundUp);
737     }
738 
739     /// @notice Deposit an amount of `token` represented in either `amount` or `share`.
740     /// @param token_ The ERC-20 token to deposit.
741     /// @param from which account to pull the tokens.
742     /// @param to which account to push the tokens.
743     /// @param amount Token amount in native representation to deposit.
744     /// @param share Token amount represented in shares to deposit. Takes precedence over `amount`.
745     /// @return amountOut The amount deposited.
746     /// @return shareOut The deposited amount repesented in shares.
747     function deposit(
748         IERC20 token_,
749         address from,
750         address to,
751         uint256 amount,
752         uint256 share
753     ) public payable allowed(from) returns (uint256 amountOut, uint256 shareOut) {
754         // Checks
755         require(to != address(0), "BentoBox: to not set"); // To avoid a bad UI from burning funds
756 
757         // Effects
758         IERC20 token = token_ == USE_ETHEREUM ? wethToken : token_;
759         Rebase memory total = totals[token];
760 
761         // If a new token gets added, the tokenSupply call checks that this is a deployed contract. Needed for security.
762         require(total.elastic != 0 || token.totalSupply() > 0, "BentoBox: No tokens");
763         if (share == 0) {
764             // value of the share may be lower than the amount due to rounding, that's ok
765             share = total.toBase(amount, false);
766             // Any deposit should lead to at least the minimum share balance, otherwise it's ignored (no amount taken)
767             if (total.base.add(share.to128()) < MINIMUM_SHARE_BALANCE) {
768                 return (0, 0);
769             }
770         } else {
771             // amount may be lower than the value of share due to rounding, in that case, add 1 to amount (Always round up)
772             amount = total.toElastic(share, true);
773         }
774 
775         // In case of skimming, check that only the skimmable amount is taken.
776         // For ETH, the full balance is available, so no need to check.
777         // During flashloans the _tokenBalanceOf is lower than 'reality', so skimming deposits will mostly fail during a flashloan.
778         require(
779             from != address(this) || token_ == USE_ETHEREUM || amount <= _tokenBalanceOf(token).sub(total.elastic),
780             "BentoBox: Skim too much"
781         );
782 
783         balanceOf[token][to] = balanceOf[token][to].add(share);
784         total.base = total.base.add(share.to128());
785         total.elastic = total.elastic.add(amount.to128());
786         totals[token] = total;
787 
788         // Interactions
789         // During the first deposit, we check that this token is 'real'
790         if (token_ == USE_ETHEREUM) {
791             // X2 - If there is an error, could it cause a DoS. Like balanceOf causing revert. (SWC-113)
792             // X2: If the WETH implementation is faulty or malicious, it will block adding ETH (but we know the WETH implementation)
793             IWETH(address(wethToken)).deposit{value: amount}();
794         } else if (from != address(this)) {
795             // X2 - If there is an error, could it cause a DoS. Like balanceOf causing revert. (SWC-113)
796             // X2: If the token implementation is faulty or malicious, it may block adding tokens. Good.
797             token.safeTransferFrom(from, address(this), amount);
798         }
799         emit LogDeposit(token, from, to, amount, share);
800         amountOut = amount;
801         shareOut = share;
802     }
803 
804     /// @notice Withdraws an amount of `token` from a user account.
805     /// @param token_ The ERC-20 token to withdraw.
806     /// @param from which user to pull the tokens.
807     /// @param to which user to push the tokens.
808     /// @param amount of tokens. Either one of `amount` or `share` needs to be supplied.
809     /// @param share Like above, but `share` takes precedence over `amount`.
810     function withdraw(
811         IERC20 token_,
812         address from,
813         address to,
814         uint256 amount,
815         uint256 share
816     ) public allowed(from) returns (uint256 amountOut, uint256 shareOut) {
817         // Checks
818         require(to != address(0), "BentoBox: to not set"); // To avoid a bad UI from burning funds
819 
820         // Effects
821         IERC20 token = token_ == USE_ETHEREUM ? wethToken : token_;
822         Rebase memory total = totals[token];
823         if (share == 0) {
824             // value of the share paid could be lower than the amount paid due to rounding, in that case, add a share (Always round up)
825             share = total.toBase(amount, true);
826         } else {
827             // amount may be lower than the value of share due to rounding, that's ok
828             amount = total.toElastic(share, false);
829         }
830 
831         balanceOf[token][from] = balanceOf[token][from].sub(share);
832         total.elastic = total.elastic.sub(amount.to128());
833         total.base = total.base.sub(share.to128());
834         // There have to be at least 1000 shares left to prevent reseting the share/amount ratio (unless it's fully emptied)
835         require(total.base >= MINIMUM_SHARE_BALANCE || total.base == 0, "BentoBox: cannot empty");
836         totals[token] = total;
837 
838         // Interactions
839         if (token_ == USE_ETHEREUM) {
840             // X2, X3: A revert or big gas usage in the WETH contract could block withdrawals, but WETH9 is fine.
841             IWETH(address(wethToken)).withdraw(amount);
842             // X2, X3: A revert or big gas usage could block, however, the to address is under control of the caller.
843             (bool success, ) = to.call{value: amount}("");
844             require(success, "BentoBox: ETH transfer failed");
845         } else {
846             // X2, X3: A malicious token could block withdrawal of just THAT token.
847             //         masterContracts may want to take care not to rely on withdraw always succeeding.
848             token.safeTransfer(to, amount);
849         }
850         emit LogWithdraw(token, from, to, amount, share);
851         amountOut = amount;
852         shareOut = share;
853     }
854 
855     /// @notice Transfer shares from a user account to another one.
856     /// @param token The ERC-20 token to transfer.
857     /// @param from which user to pull the tokens.
858     /// @param to which user to push the tokens.
859     /// @param share The amount of `token` in shares.
860     // Clones of master contracts can transfer from any account that has approved them
861     // F3 - Can it be combined with another similar function?
862     // F3: This isn't combined with transferMultiple for gas optimization
863     function transfer(
864         IERC20 token,
865         address from,
866         address to,
867         uint256 share
868     ) public allowed(from) {
869         // Checks
870         require(to != address(0), "BentoBox: to not set"); // To avoid a bad UI from burning funds
871 
872         // Effects
873         balanceOf[token][from] = balanceOf[token][from].sub(share);
874         balanceOf[token][to] = balanceOf[token][to].add(share);
875 
876         emit LogTransfer(token, from, to, share);
877     }
878 
879     /// @notice Transfer shares from a user account to multiple other ones.
880     /// @param token The ERC-20 token to transfer.
881     /// @param from which user to pull the tokens.
882     /// @param tos The receivers of the tokens.
883     /// @param shares The amount of `token` in shares for each receiver in `tos`.
884     // F3 - Can it be combined with another similar function?
885     // F3: This isn't combined with transfer for gas optimization
886     function transferMultiple(
887         IERC20 token,
888         address from,
889         address[] calldata tos,
890         uint256[] calldata shares
891     ) public allowed(from) {
892         // Checks
893         require(tos[0] != address(0), "BentoBox: to[0] not set"); // To avoid a bad UI from burning funds
894 
895         // Effects
896         uint256 totalAmount;
897         uint256 len = tos.length;
898         for (uint256 i = 0; i < len; i++) {
899             address to = tos[i];
900             balanceOf[token][to] = balanceOf[token][to].add(shares[i]);
901             totalAmount = totalAmount.add(shares[i]);
902             emit LogTransfer(token, from, to, shares[i]);
903         }
904         balanceOf[token][from] = balanceOf[token][from].sub(totalAmount);
905     }
906 
907     /// @notice Flashloan ability.
908     /// @param borrower The address of the contract that implements and conforms to `IFlashBorrower` and handles the flashloan.
909     /// @param receiver Address of the token receiver.
910     /// @param token The address of the token to receive.
911     /// @param amount of the tokens to receive.
912     /// @param data The calldata to pass to the `borrower` contract.
913     // F5 - Checks-Effects-Interactions pattern followed? (SWC-107)
914     // F5: Not possible to follow this here, reentrancy has been reviewed
915     // F6 - Check for front-running possibilities, such as the approve function (SWC-114)
916     // F6: Slight grieving possible by withdrawing an amount before someone tries to flashloan close to the full amount.
917     function flashLoan(
918         IFlashBorrower borrower,
919         address receiver,
920         IERC20 token,
921         uint256 amount,
922         bytes calldata data
923     ) public {
924         uint256 fee = amount.mul(FLASH_LOAN_FEE) / FLASH_LOAN_FEE_PRECISION;
925         token.safeTransfer(receiver, amount);
926 
927         borrower.onFlashLoan(msg.sender, token, amount, fee, data);
928 
929         require(_tokenBalanceOf(token) >= totals[token].addElastic(fee.to128()), "BentoBox: Wrong amount");
930         emit LogFlashLoan(address(borrower), token, amount, fee, receiver);
931     }
932 
933     /// @notice Support for batched flashloans. Useful to request multiple different `tokens` in a single transaction.
934     /// @param borrower The address of the contract that implements and conforms to `IBatchFlashBorrower` and handles the flashloan.
935     /// @param receivers An array of the token receivers. A one-to-one mapping with `tokens` and `amounts`.
936     /// @param tokens The addresses of the tokens.
937     /// @param amounts of the tokens for each receiver.
938     /// @param data The calldata to pass to the `borrower` contract.
939     // F5 - Checks-Effects-Interactions pattern followed? (SWC-107)
940     // F5: Not possible to follow this here, reentrancy has been reviewed
941     // F6 - Check for front-running possibilities, such as the approve function (SWC-114)
942     // F6: Slight grieving possible by withdrawing an amount before someone tries to flashloan close to the full amount.
943     function batchFlashLoan(
944         IBatchFlashBorrower borrower,
945         address[] calldata receivers,
946         IERC20[] calldata tokens,
947         uint256[] calldata amounts,
948         bytes calldata data
949     ) public {
950         uint256[] memory fees = new uint256[](tokens.length);
951 
952         uint256 len = tokens.length;
953         for (uint256 i = 0; i < len; i++) {
954             uint256 amount = amounts[i];
955             fees[i] = amount.mul(FLASH_LOAN_FEE) / FLASH_LOAN_FEE_PRECISION;
956 
957             tokens[i].safeTransfer(receivers[i], amounts[i]);
958         }
959 
960         borrower.onBatchFlashLoan(msg.sender, tokens, amounts, fees, data);
961 
962         for (uint256 i = 0; i < len; i++) {
963             IERC20 token = tokens[i];
964             require(_tokenBalanceOf(token) >= totals[token].addElastic(fees[i].to128()), "BentoBox: Wrong amount");
965             emit LogFlashLoan(address(borrower), token, amounts[i], fees[i], receivers[i]);
966         }
967     }
968 
969     /// @notice Sets the target percentage of the strategy for `token`.
970     /// @dev Only the owner of this contract is allowed to change this.
971     /// @param token The address of the token that maps to a strategy to change.
972     /// @param targetPercentage_ The new target in percent. Must be lesser or equal to `MAX_TARGET_PERCENTAGE`.
973     function setStrategyTargetPercentage(IERC20 token, uint64 targetPercentage_) public onlyOwner {
974         // Checks
975         require(targetPercentage_ <= MAX_TARGET_PERCENTAGE, "StrategyManager: Target too high");
976 
977         // Effects
978         strategyData[token].targetPercentage = targetPercentage_;
979         emit LogStrategyTargetPercentage(token, targetPercentage_);
980     }
981 
982     /// @notice Sets the contract address of a new strategy that conforms to `IStrategy` for `token`.
983     /// Must be called twice with the same arguments.
984     /// A new strategy becomes pending first and can be activated once `STRATEGY_DELAY` is over.
985     /// @dev Only the owner of this contract is allowed to change this.
986     /// @param token The address of the token that maps to a strategy to change.
987     /// @param newStrategy The address of the contract that conforms to `IStrategy`.
988     // F5 - Checks-Effects-Interactions pattern followed? (SWC-107)
989     // F5: Total amount is updated AFTER interaction. But strategy is under our control.
990     // C4 - Use block.timestamp only for long intervals (SWC-116)
991     // C4: block.timestamp is used for a period of 2 weeks, which is long enough
992     function setStrategy(IERC20 token, IStrategy newStrategy) public onlyOwner {
993         StrategyData memory data = strategyData[token];
994         IStrategy pending = pendingStrategy[token];
995         if (data.strategyStartDate == 0 || pending != newStrategy) {
996             pendingStrategy[token] = newStrategy;
997             // C1 - All math done through BoringMath (SWC-101)
998             // C1: Our sun will swallow the earth well before this overflows
999             data.strategyStartDate = (block.timestamp + STRATEGY_DELAY).to64();
1000             emit LogStrategyQueued(token, newStrategy);
1001         } else {
1002             require(data.strategyStartDate != 0 && block.timestamp >= data.strategyStartDate, "StrategyManager: Too early");
1003             if (address(strategy[token]) != address(0)) {
1004                 int256 balanceChange = strategy[token].exit(data.balance);
1005                 // Effects
1006                 if (balanceChange > 0) {
1007                     uint256 add = uint256(balanceChange);
1008                     totals[token].addElastic(add);
1009                     emit LogStrategyProfit(token, add);
1010                 } else if (balanceChange < 0) {
1011                     uint256 sub = uint256(-balanceChange);
1012                     totals[token].subElastic(sub);
1013                     emit LogStrategyLoss(token, sub);
1014                 }
1015 
1016                 emit LogStrategyDivest(token, data.balance);
1017             }
1018             strategy[token] = pending;
1019             data.strategyStartDate = 0;
1020             data.balance = 0;
1021             pendingStrategy[token] = IStrategy(0);
1022             emit LogStrategySet(token, newStrategy);
1023         }
1024         strategyData[token] = data;
1025     }
1026 
1027     /// @notice The actual process of yield farming. Executes the strategy of `token`.
1028     /// Optionally does housekeeping if `balance` is true.
1029     /// `maxChangeAmount` is relevant for skimming or withdrawing if `balance` is true.
1030     /// @param token The address of the token for which a strategy is deployed.
1031     /// @param balance True if housekeeping should be done.
1032     /// @param maxChangeAmount The maximum amount for either pulling or pushing from/to the `IStrategy` contract.
1033     // F5 - Checks-Effects-Interactions pattern followed? (SWC-107)
1034     // F5: Total amount is updated AFTER interaction. But strategy is under our control.
1035     // F5: Not followed to prevent reentrancy issues with flashloans and BentoBox skims?
1036     function harvest(
1037         IERC20 token,
1038         bool balance,
1039         uint256 maxChangeAmount
1040     ) public {
1041         StrategyData memory data = strategyData[token];
1042         IStrategy _strategy = strategy[token];
1043         int256 balanceChange = _strategy.harvest(data.balance, msg.sender);
1044         if (balanceChange == 0 && !balance) {
1045             return;
1046         }
1047 
1048         uint256 totalElastic = totals[token].elastic;
1049 
1050         if (balanceChange > 0) {
1051             uint256 add = uint256(balanceChange);
1052             totalElastic = totalElastic.add(add);
1053             totals[token].elastic = totalElastic.to128();
1054             emit LogStrategyProfit(token, add);
1055         } else if (balanceChange < 0) {
1056             // C1 - All math done through BoringMath (SWC-101)
1057             // C1: balanceChange could overflow if it's max negative int128.
1058             // But tokens with balances that large are not supported by the BentoBox.
1059             uint256 sub = uint256(-balanceChange);
1060             totalElastic = totalElastic.sub(sub);
1061             totals[token].elastic = totalElastic.to128();
1062             data.balance = data.balance.sub(sub.to128());
1063             emit LogStrategyLoss(token, sub);
1064         }
1065 
1066         if (balance) {
1067             uint256 targetBalance = totalElastic.mul(data.targetPercentage) / 100;
1068             // if data.balance == targetBalance there is nothing to update
1069             if (data.balance < targetBalance) {
1070                 uint256 amountOut = targetBalance.sub(data.balance);
1071                 if (maxChangeAmount != 0 && amountOut > maxChangeAmount) {
1072                     amountOut = maxChangeAmount;
1073                 }
1074                 token.safeTransfer(address(_strategy), amountOut);
1075                 data.balance = data.balance.add(amountOut.to128());
1076                 _strategy.skim(amountOut);
1077                 emit LogStrategyInvest(token, amountOut);
1078             } else if (data.balance > targetBalance) {
1079                 uint256 amountIn = data.balance.sub(targetBalance.to128());
1080                 if (maxChangeAmount != 0 && amountIn > maxChangeAmount) {
1081                     amountIn = maxChangeAmount;
1082                 }
1083 
1084                 uint256 actualAmountIn = _strategy.withdraw(amountIn);
1085 
1086                 data.balance = data.balance.sub(actualAmountIn.to128());
1087                 emit LogStrategyDivest(token, actualAmountIn);
1088             }
1089         }
1090 
1091         strategyData[token] = data;
1092     }
1093 
1094     // Contract should be able to receive ETH deposits to support deposit & skim
1095     // solhint-disable-next-line no-empty-blocks
1096     receive() external payable {}
1097 }