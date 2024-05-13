1 // SPDX-License-Identifier: None
2 
3 pragma solidity 0.6.12;
4 pragma experimental ABIEncoderV2;
5 
6 /// @notice A library for performing overflow-/underflow-safe math,
7 library BoringMath {
8     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
9         require((c = a + b) >= b, "BoringMath: Add Overflow");
10     }
11 
12     function sub(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         require((c = a - b) <= a, "BoringMath: Underflow");
14     }
15 
16     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
17         require(b == 0 || (c = a * b) / b == a, "BoringMath: Mul Overflow");
18     }
19 
20     function to128(uint256 a) internal pure returns (uint128 c) {
21         require(a <= uint128(-1), "BoringMath: uint128 Overflow");
22         c = uint128(a);
23     }
24 
25     function to64(uint256 a) internal pure returns (uint64 c) {
26         require(a <= uint64(-1), "BoringMath: uint64 Overflow");
27         c = uint64(a);
28     }
29 
30     function to32(uint256 a) internal pure returns (uint32 c) {
31         require(a <= uint32(-1), "BoringMath: uint32 Overflow");
32         c = uint32(a);
33     }
34 }
35 
36 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint128.
37 library BoringMath128 {
38     function add(uint128 a, uint128 b) internal pure returns (uint128 c) {
39         require((c = a + b) >= b, "BoringMath: Add Overflow");
40     }
41 
42     function sub(uint128 a, uint128 b) internal pure returns (uint128 c) {
43         require((c = a - b) <= a, "BoringMath: Underflow");
44     }
45 }
46 
47 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint64.
48 library BoringMath64 {
49     function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
50         require((c = a + b) >= b, "BoringMath: Add Overflow");
51     }
52 
53     function sub(uint64 a, uint64 b) internal pure returns (uint64 c) {
54         require((c = a - b) <= a, "BoringMath: Underflow");
55     }
56 }
57 
58 /// @notice A library for performing overflow-/underflow-safe addition and subtraction on uint32.
59 library BoringMath32 {
60     function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
61         require((c = a + b) >= b, "BoringMath: Add Overflow");
62     }
63 
64     function sub(uint32 a, uint32 b) internal pure returns (uint32 c) {
65         require((c = a - b) <= a, "BoringMath: Underflow");
66     }
67 }
68 
69 contract BoringOwnableData {
70     address public owner;
71     address public pendingOwner;
72 }
73 
74 contract BoringOwnable is BoringOwnableData {
75     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
76 
77     /// @notice `owner` defaults to msg.sender on construction.
78     constructor() public {
79         owner = msg.sender;
80         emit OwnershipTransferred(address(0), msg.sender);
81     }
82 
83     /// @notice Transfers ownership to `newOwner`. Either directly or claimable by the new pending owner.
84     /// Can only be invoked by the current `owner`.
85     /// @param newOwner Address of the new owner.
86     /// @param direct True if `newOwner` should be set immediately. False if `newOwner` needs to use `claimOwnership`.
87     /// @param renounce Allows the `newOwner` to be `address(0)` if `direct` and `renounce` is True. Has no effect otherwise.
88     function transferOwnership(
89         address newOwner,
90         bool direct,
91         bool renounce
92     ) public onlyOwner {
93         if (direct) {
94             // Checks
95             require(newOwner != address(0) || renounce, "Ownable: zero address");
96 
97             // Effects
98             emit OwnershipTransferred(owner, newOwner);
99             owner = newOwner;
100             pendingOwner = address(0);
101         } else {
102             // Effects
103             pendingOwner = newOwner;
104         }
105     }
106 
107     /// @notice Needs to be called by `pendingOwner` to claim ownership.
108     function claimOwnership() public {
109         address _pendingOwner = pendingOwner;
110 
111         // Checks
112         require(msg.sender == _pendingOwner, "Ownable: caller != pending owner");
113 
114         // Effects
115         emit OwnershipTransferred(owner, _pendingOwner);
116         owner = _pendingOwner;
117         pendingOwner = address(0);
118     }
119 
120     /// @notice Only allows the `owner` to execute the function.
121     modifier onlyOwner() {
122         require(msg.sender == owner, "Ownable: caller is not the owner");
123         _;
124     }
125 }
126 
127 interface IERC20 {
128     function totalSupply() external view returns (uint256);
129 
130     function balanceOf(address account) external view returns (uint256);
131 
132     function allowance(address owner, address spender) external view returns (uint256);
133 
134     function approve(address spender, uint256 amount) external returns (bool);
135 
136     event Transfer(address indexed from, address indexed to, uint256 value);
137     event Approval(address indexed owner, address indexed spender, uint256 value);
138 
139     /// @notice EIP 2612
140     function permit(
141         address owner,
142         address spender,
143         uint256 value,
144         uint256 deadline,
145         uint8 v,
146         bytes32 r,
147         bytes32 s
148     ) external;
149 }
150 
151 contract Domain {
152     bytes32 private constant DOMAIN_SEPARATOR_SIGNATURE_HASH = keccak256("EIP712Domain(uint256 chainId,address verifyingContract)");
153     // See https://eips.ethereum.org/EIPS/eip-191
154     string private constant EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA = "\x19\x01";
155 
156     // solhint-disable var-name-mixedcase
157     bytes32 private immutable _DOMAIN_SEPARATOR;
158     uint256 private immutable DOMAIN_SEPARATOR_CHAIN_ID;    
159 
160     /// @dev Calculate the DOMAIN_SEPARATOR
161     function _calculateDomainSeparator(uint256 chainId) private view returns (bytes32) {
162         return keccak256(
163             abi.encode(
164                 DOMAIN_SEPARATOR_SIGNATURE_HASH,
165                 chainId,
166                 address(this)
167             )
168         );
169     }
170 
171     constructor() public {
172         uint256 chainId; assembly {chainId := chainid()}
173         _DOMAIN_SEPARATOR = _calculateDomainSeparator(DOMAIN_SEPARATOR_CHAIN_ID = chainId);
174     }
175 
176     /// @dev Return the DOMAIN_SEPARATOR
177     // It's named internal to allow making it public from the contract that uses it by creating a simple view function
178     // with the desired public name, such as DOMAIN_SEPARATOR or domainSeparator.
179     // solhint-disable-next-line func-name-mixedcase
180     function _domainSeparator() internal view returns (bytes32) {
181         uint256 chainId; assembly {chainId := chainid()}
182         return chainId == DOMAIN_SEPARATOR_CHAIN_ID ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId);
183     }
184 
185     function _getDigest(bytes32 dataHash) internal view returns (bytes32 digest) {
186         digest =
187             keccak256(
188                 abi.encodePacked(
189                     EIP191_PREFIX_FOR_EIP712_STRUCTURED_DATA,
190                     _domainSeparator(),
191                     dataHash
192                 )
193             );
194     }
195 }
196 
197 // Data part taken out for building of contracts that receive delegate calls
198 contract ERC20Data {
199     /// @notice owner > balance mapping.
200     mapping(address => uint256) public balanceOf;
201     /// @notice owner > spender > allowance mapping.
202     mapping(address => mapping(address => uint256)) public allowance;
203     /// @notice owner > nonce mapping. Used in `permit`.
204     mapping(address => uint256) public nonces;
205 }
206 
207 abstract contract ERC20 is IERC20, Domain {
208     /// @notice owner > balance mapping.
209     mapping(address => uint256) public override balanceOf;
210     /// @notice owner > spender > allowance mapping.
211     mapping(address => mapping(address => uint256)) public override allowance;
212     /// @notice owner > nonce mapping. Used in `permit`.
213     mapping(address => uint256) public nonces;
214 
215     event Transfer(address indexed _from, address indexed _to, uint256 _value);
216     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
217 
218     /// @notice Transfers `amount` tokens from `msg.sender` to `to`.
219     /// @param to The address to move the tokens.
220     /// @param amount of the tokens to move.
221     /// @return (bool) Returns True if succeeded.
222     function transfer(address to, uint256 amount) public returns (bool) {
223         // If `amount` is 0, or `msg.sender` is `to` nothing happens
224         if (amount != 0 || msg.sender == to) {
225             uint256 srcBalance = balanceOf[msg.sender];
226             require(srcBalance >= amount, "ERC20: balance too low");
227             if (msg.sender != to) {
228                 require(to != address(0), "ERC20: no zero address"); // Moved down so low balance calls safe some gas
229 
230                 balanceOf[msg.sender] = srcBalance - amount; // Underflow is checked
231                 balanceOf[to] += amount;
232             }
233         }
234         emit Transfer(msg.sender, to, amount);
235         return true;
236     }
237 
238     /// @notice Transfers `amount` tokens from `from` to `to`. Caller needs approval for `from`.
239     /// @param from Address to draw tokens from.
240     /// @param to The address to move the tokens.
241     /// @param amount The token amount to move.
242     /// @return (bool) Returns True if succeeded.
243     function transferFrom(
244         address from,
245         address to,
246         uint256 amount
247     ) public returns (bool) {
248         // If `amount` is 0, or `from` is `to` nothing happens
249         if (amount != 0) {
250             uint256 srcBalance = balanceOf[from];
251             require(srcBalance >= amount, "ERC20: balance too low");
252 
253             if (from != to) {
254                 uint256 spenderAllowance = allowance[from][msg.sender];
255                 // If allowance is infinite, don't decrease it to save on gas (breaks with EIP-20).
256                 if (spenderAllowance != type(uint256).max) {
257                     require(spenderAllowance >= amount, "ERC20: allowance too low");
258                     allowance[from][msg.sender] = spenderAllowance - amount; // Underflow is checked
259                 }
260                 require(to != address(0), "ERC20: no zero address"); // Moved down so other failed calls safe some gas
261 
262                 balanceOf[from] = srcBalance - amount; // Underflow is checked
263                 balanceOf[to] += amount;
264             }
265         }
266         emit Transfer(from, to, amount);
267         return true;
268     }
269 
270     /// @notice Approves `amount` from sender to be spend by `spender`.
271     /// @param spender Address of the party that can draw from msg.sender's account.
272     /// @param amount The maximum collective amount that `spender` can draw.
273     /// @return (bool) Returns True if approved.
274     function approve(address spender, uint256 amount) public override returns (bool) {
275         allowance[msg.sender][spender] = amount;
276         emit Approval(msg.sender, spender, amount);
277         return true;
278     }
279 
280     // solhint-disable-next-line func-name-mixedcase
281     function DOMAIN_SEPARATOR() external view returns (bytes32) {
282         return _domainSeparator();
283     }
284 
285     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)");
286     bytes32 private constant PERMIT_SIGNATURE_HASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
287 
288     /// @notice Approves `value` from `owner_` to be spend by `spender`.
289     /// @param owner_ Address of the owner.
290     /// @param spender The address of the spender that gets approved to draw from `owner_`.
291     /// @param value The maximum collective amount that `spender` can draw.
292     /// @param deadline This permit must be redeemed before this deadline (UTC timestamp in seconds).
293     function permit(
294         address owner_,
295         address spender,
296         uint256 value,
297         uint256 deadline,
298         uint8 v,
299         bytes32 r,
300         bytes32 s
301     ) external override {
302         require(owner_ != address(0), "ERC20: Owner cannot be 0");
303         require(block.timestamp < deadline, "ERC20: Expired");
304         require(
305             ecrecover(_getDigest(keccak256(abi.encode(PERMIT_SIGNATURE_HASH, owner_, spender, value, nonces[owner_]++, deadline))), v, r, s) ==
306                 owner_,
307             "ERC20: Invalid Signature"
308         );
309         allowance[owner_][spender] = value;
310         emit Approval(owner_, spender, value);
311     }
312 }
313 
314 contract ERC20WithSupply is IERC20, ERC20 {
315     uint256 public override totalSupply;
316 
317     function _mint(address user, uint256 amount) private {
318         uint256 newTotalSupply = totalSupply + amount;
319         require(newTotalSupply >= totalSupply, "Mint overflow");
320         totalSupply = newTotalSupply;
321         balanceOf[user] += amount;
322     }
323 
324     function _burn(address user, uint256 amount) private {
325         require(balanceOf[user] >= amount, "Burn too much");
326         totalSupply -= amount;
327         balanceOf[user] -= amount;
328     }
329 }
330 
331 interface IMasterContract {
332     /// @notice Init function that gets called from `BoringFactory.deploy`.
333     /// Also kown as the constructor for cloned contracts.
334     /// Any ETH send to `BoringFactory.deploy` ends up here.
335     /// @param data Can be abi encoded arguments or anything else.
336     function init(bytes calldata data) external payable;
337 }
338 
339 struct Rebase {
340     uint128 elastic;
341     uint128 base;
342 }
343 
344 /// @notice A rebasing library using overflow-/underflow-safe math.
345 library RebaseLibrary {
346     using BoringMath for uint256;
347     using BoringMath128 for uint128;
348 
349     /// @notice Calculates the base value in relationship to `elastic` and `total`.
350     function toBase(
351         Rebase memory total,
352         uint256 elastic,
353         bool roundUp
354     ) internal pure returns (uint256 base) {
355         if (total.elastic == 0) {
356             base = elastic;
357         } else {
358             base = elastic.mul(total.base) / total.elastic;
359             if (roundUp && base.mul(total.elastic) / total.base < elastic) {
360                 base = base.add(1);
361             }
362         }
363     }
364 
365     /// @notice Calculates the elastic value in relationship to `base` and `total`.
366     function toElastic(
367         Rebase memory total,
368         uint256 base,
369         bool roundUp
370     ) internal pure returns (uint256 elastic) {
371         if (total.base == 0) {
372             elastic = base;
373         } else {
374             elastic = base.mul(total.elastic) / total.base;
375             if (roundUp && elastic.mul(total.base) / total.elastic < base) {
376                 elastic = elastic.add(1);
377             }
378         }
379     }
380 
381     /// @notice Add `elastic` to `total` and doubles `total.base`.
382     /// @return (Rebase) The new total.
383     /// @return base in relationship to `elastic`.
384     function add(
385         Rebase memory total,
386         uint256 elastic,
387         bool roundUp
388     ) internal pure returns (Rebase memory, uint256 base) {
389         base = toBase(total, elastic, roundUp);
390         total.elastic = total.elastic.add(elastic.to128());
391         total.base = total.base.add(base.to128());
392         return (total, base);
393     }
394 
395     /// @notice Sub `base` from `total` and update `total.elastic`.
396     /// @return (Rebase) The new total.
397     /// @return elastic in relationship to `base`.
398     function sub(
399         Rebase memory total,
400         uint256 base,
401         bool roundUp
402     ) internal pure returns (Rebase memory, uint256 elastic) {
403         elastic = toElastic(total, base, roundUp);
404         total.elastic = total.elastic.sub(elastic.to128());
405         total.base = total.base.sub(base.to128());
406         return (total, elastic);
407     }
408 
409     /// @notice Add `elastic` and `base` to `total`.
410     function add(
411         Rebase memory total,
412         uint256 elastic,
413         uint256 base
414     ) internal pure returns (Rebase memory) {
415         total.elastic = total.elastic.add(elastic.to128());
416         total.base = total.base.add(base.to128());
417         return total;
418     }
419 
420     /// @notice Subtract `elastic` and `base` to `total`.
421     function sub(
422         Rebase memory total,
423         uint256 elastic,
424         uint256 base
425     ) internal pure returns (Rebase memory) {
426         total.elastic = total.elastic.sub(elastic.to128());
427         total.base = total.base.sub(base.to128());
428         return total;
429     }
430 
431     /// @notice Add `elastic` to `total` and update storage.
432     /// @return newElastic Returns updated `elastic`.
433     function addElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {
434         newElastic = total.elastic = total.elastic.add(elastic.to128());
435     }
436 
437     /// @notice Subtract `elastic` from `total` and update storage.
438     /// @return newElastic Returns updated `elastic`.
439     function subElastic(Rebase storage total, uint256 elastic) internal returns (uint256 newElastic) {
440         newElastic = total.elastic = total.elastic.sub(elastic.to128());
441     }
442 }
443 
444 library BoringERC20 {
445     bytes4 private constant SIG_SYMBOL = 0x95d89b41; // symbol()
446     bytes4 private constant SIG_NAME = 0x06fdde03; // name()
447     bytes4 private constant SIG_DECIMALS = 0x313ce567; // decimals()
448     bytes4 private constant SIG_TRANSFER = 0xa9059cbb; // transfer(address,uint256)
449     bytes4 private constant SIG_TRANSFER_FROM = 0x23b872dd; // transferFrom(address,address,uint256)
450 
451     function returnDataToString(bytes memory data) internal pure returns (string memory) {
452         if (data.length >= 64) {
453             return abi.decode(data, (string));
454         } else if (data.length == 32) {
455             uint8 i = 0;
456             while(i < 32 && data[i] != 0) {
457                 i++;
458             }
459             bytes memory bytesArray = new bytes(i);
460             for (i = 0; i < 32 && data[i] != 0; i++) {
461                 bytesArray[i] = data[i];
462             }
463             return string(bytesArray);
464         } else {
465             return "???";
466         }
467     }
468 
469     /// @notice Provides a safe ERC20.symbol version which returns '???' as fallback string.
470     /// @param token The address of the ERC-20 token contract.
471     /// @return (string) Token symbol.
472     function safeSymbol(IERC20 token) internal view returns (string memory) {
473         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_SYMBOL));
474         return success ? returnDataToString(data) : "???";
475     }
476 
477     /// @notice Provides a safe ERC20.name version which returns '???' as fallback string.
478     /// @param token The address of the ERC-20 token contract.
479     /// @return (string) Token name.
480     function safeName(IERC20 token) internal view returns (string memory) {
481         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_NAME));
482         return success ? returnDataToString(data) : "???";
483     }
484 
485     /// @notice Provides a safe ERC20.decimals version which returns '18' as fallback value.
486     /// @param token The address of the ERC-20 token contract.
487     /// @return (uint8) Token decimals.
488     function safeDecimals(IERC20 token) internal view returns (uint8) {
489         (bool success, bytes memory data) = address(token).staticcall(abi.encodeWithSelector(SIG_DECIMALS));
490         return success && data.length == 32 ? abi.decode(data, (uint8)) : 18;
491     }
492 
493     /// @notice Provides a safe ERC20.transfer version for different ERC-20 implementations.
494     /// Reverts on a failed transfer.
495     /// @param token The address of the ERC-20 token.
496     /// @param to Transfer tokens to.
497     /// @param amount The token amount.
498     function safeTransfer(
499         IERC20 token,
500         address to,
501         uint256 amount
502     ) internal {
503         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER, to, amount));
504         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: Transfer failed");
505     }
506 
507     /// @notice Provides a safe ERC20.transferFrom version for different ERC-20 implementations.
508     /// Reverts on a failed transfer.
509     /// @param token The address of the ERC-20 token.
510     /// @param from Transfer tokens from.
511     /// @param to Transfer tokens to.
512     /// @param amount The token amount.
513     function safeTransferFrom(
514         IERC20 token,
515         address from,
516         address to,
517         uint256 amount
518     ) internal {
519         (bool success, bytes memory data) = address(token).call(abi.encodeWithSelector(SIG_TRANSFER_FROM, from, to, amount));
520         require(success && (data.length == 0 || abi.decode(data, (bool))), "BoringERC20: TransferFrom failed");
521     }
522 }
523 
524 interface IBatchFlashBorrower {
525     function onBatchFlashLoan(
526         address sender,
527         IERC20[] calldata tokens,
528         uint256[] calldata amounts,
529         uint256[] calldata fees,
530         bytes calldata data
531     ) external;
532 }
533 
534 interface IFlashBorrower {
535     function onFlashLoan(
536         address sender,
537         IERC20 token,
538         uint256 amount,
539         uint256 fee,
540         bytes calldata data
541     ) external;
542 }
543 
544 interface IStrategy {
545     // Send the assets to the Strategy and call skim to invest them
546     function skim(uint256 amount) external;
547 
548     // Harvest any profits made converted to the asset and pass them to the caller
549     function harvest(uint256 balance, address sender) external returns (int256 amountAdded);
550 
551     // Withdraw assets. The returned amount can differ from the requested amount due to rounding.
552     // The actualAmount should be very close to the amount. The difference should NOT be used to report a loss. That's what harvest is for.
553     function withdraw(uint256 amount) external returns (uint256 actualAmount);
554 
555     // Withdraw all assets in the safest way possible. This shouldn't fail.
556     function exit(uint256 balance) external returns (int256 amountAdded);
557 }
558 
559 interface IBentoBoxV1 {
560     event LogDeploy(address indexed masterContract, bytes data, address indexed cloneAddress);
561     event LogDeposit(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);
562     event LogFlashLoan(address indexed borrower, address indexed token, uint256 amount, uint256 feeAmount, address indexed receiver);
563     event LogRegisterProtocol(address indexed protocol);
564     event LogSetMasterContractApproval(address indexed masterContract, address indexed user, bool approved);
565     event LogStrategyDivest(address indexed token, uint256 amount);
566     event LogStrategyInvest(address indexed token, uint256 amount);
567     event LogStrategyLoss(address indexed token, uint256 amount);
568     event LogStrategyProfit(address indexed token, uint256 amount);
569     event LogStrategyQueued(address indexed token, address indexed strategy);
570     event LogStrategySet(address indexed token, address indexed strategy);
571     event LogStrategyTargetPercentage(address indexed token, uint256 targetPercentage);
572     event LogTransfer(address indexed token, address indexed from, address indexed to, uint256 share);
573     event LogWhiteListMasterContract(address indexed masterContract, bool approved);
574     event LogWithdraw(address indexed token, address indexed from, address indexed to, uint256 amount, uint256 share);
575     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
576     function balanceOf(IERC20, address) external view returns (uint256);
577     function batch(bytes[] calldata calls, bool revertOnFail) external payable returns (bool[] memory successes, bytes[] memory results);
578     function batchFlashLoan(IBatchFlashBorrower borrower, address[] calldata receivers, IERC20[] calldata tokens, uint256[] calldata amounts, bytes calldata data) external;
579     function claimOwnership() external;
580     function deploy(address masterContract, bytes calldata data, bool useCreate2) external payable;
581     function deposit(IERC20 token_, address from, address to, uint256 amount, uint256 share) external payable returns (uint256 amountOut, uint256 shareOut);
582     function flashLoan(IFlashBorrower borrower, address receiver, IERC20 token, uint256 amount, bytes calldata data) external;
583     function harvest(IERC20 token, bool balance, uint256 maxChangeAmount) external;
584     function masterContractApproved(address, address) external view returns (bool);
585     function masterContractOf(address) external view returns (address);
586     function nonces(address) external view returns (uint256);
587     function owner() external view returns (address);
588     function pendingOwner() external view returns (address);
589     function pendingStrategy(IERC20) external view returns (IStrategy);
590     function permitToken(IERC20 token, address from, address to, uint256 amount, uint256 deadline, uint8 v, bytes32 r, bytes32 s) external;
591     function registerProtocol() external;
592     function setMasterContractApproval(address user, address masterContract, bool approved, uint8 v, bytes32 r, bytes32 s) external;
593     function setStrategy(IERC20 token, IStrategy newStrategy) external;
594     function setStrategyTargetPercentage(IERC20 token, uint64 targetPercentage_) external;
595     function strategy(IERC20) external view returns (IStrategy);
596     function strategyData(IERC20) external view returns (uint64 strategyStartDate, uint64 targetPercentage, uint128 balance);
597     function toAmount(IERC20 token, uint256 share, bool roundUp) external view returns (uint256 amount);
598     function toShare(IERC20 token, uint256 amount, bool roundUp) external view returns (uint256 share);
599     function totals(IERC20) external view returns (Rebase memory totals_);
600     function transfer(IERC20 token, address from, address to, uint256 share) external;
601     function transferMultiple(IERC20 token, address from, address[] calldata tos, uint256[] calldata shares) external;
602     function transferOwnership(address newOwner, bool direct, bool renounce) external;
603     function whitelistMasterContract(address masterContract, bool approved) external;
604     function whitelistedMasterContracts(address) external view returns (bool);
605     function withdraw(IERC20 token_, address from, address to, uint256 amount, uint256 share) external returns (uint256 amountOut, uint256 shareOut);
606 }
607 
608 /// @title Cauldron
609 /// @dev This contract allows contract calls to any contract (except BentoBox)
610 /// from arbitrary callers thus, don't trust calls from this contract in any circumstances.
611 contract NXUSD is ERC20, BoringOwnable {
612     using BoringMath for uint256;
613     // ERC20 'variables'
614     string public constant symbol = "NXUSD";
615     string public constant name = "NXUSD";
616     uint8 public constant decimals = 18;
617     uint256 public override totalSupply;
618 
619     struct Minting {
620         uint128 time;
621         uint128 amount;
622     }
623 
624     Minting public lastMint;
625     uint256 private constant MINTING_PERIOD = 24 hours;
626     uint256 private constant MINTING_INCREASE = 15000;
627     uint256 private constant MINTING_PRECISION = 1e5;
628 
629     function mint(address to, uint256 amount) public onlyOwner {
630         require(to != address(0), "NXUSD: no mint to zero address");
631 
632         // Limits the amount minted per period to a convergence function, with the period duration restarting on every mint
633         uint256 totalMintedAmount = uint256(lastMint.time < block.timestamp - MINTING_PERIOD ? 0 : lastMint.amount).add(amount);
634         require(totalSupply == 0 || totalSupply.mul(MINTING_INCREASE) / MINTING_PRECISION >= totalMintedAmount);
635 
636         lastMint.time = block.timestamp.to128();
637         lastMint.amount = totalMintedAmount.to128();
638 
639         totalSupply = totalSupply + amount;
640         balanceOf[to] += amount;
641         emit Transfer(address(0), to, amount);
642     }
643 
644     function mintToBentoBox(address clone, uint256 amount, IBentoBoxV1 bentoBox) public onlyOwner {
645         mint(address(bentoBox), amount);
646         bentoBox.deposit(IERC20(address(this)), address(bentoBox), clone, amount, 0);
647     }
648 
649     function burn(uint256 amount) public {
650         require(amount <= balanceOf[msg.sender], "NXUSD: not enough");
651 
652         balanceOf[msg.sender] -= amount;
653         totalSupply -= amount;
654         emit Transfer(msg.sender, address(0), amount);
655     }
656 }
657 
658 contract PermissionManager is BoringOwnable {
659     struct PermissionInfo {
660         uint index;
661         bool isAllowed;
662     }
663 
664     mapping(address => PermissionInfo) public info;
665     address[] public allowedAccounts;
666 
667     function permit(address _account) public onlyOwner {
668         if (info[_account].isAllowed) {
669             revert("Account is already permitted");
670         }
671         info[_account] = PermissionInfo({index: allowedAccounts.length, isAllowed: true});
672         allowedAccounts.push(_account);
673     }
674 
675     function revoke(address _account) public onlyOwner {
676         PermissionInfo memory accountInfo = info[_account];
677 
678         if (accountInfo.index != allowedAccounts.length-1) {
679             address last = allowedAccounts[allowedAccounts.length-1];
680             PermissionInfo storage infoLast = info[last];
681 
682             allowedAccounts[accountInfo.index] = last;
683             infoLast.index = accountInfo.index;
684         }
685 
686         delete info[_account];
687         allowedAccounts.pop();
688     }
689 
690     function getAllAccounts() public view returns (address[] memory) {
691         return allowedAccounts;
692     }
693 
694     modifier isAllowed() {
695         require(info[msg.sender].isAllowed, "sender is not allowed");
696         _;
697     }
698 }
699 
700 interface IOracle {
701     /// @notice Get the latest exchange rate.
702     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
703     /// For example:
704     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
705     /// @return success if no valid (recent) rate is available, return false else true.
706     /// @return rate The rate of the requested asset / pair / pool.
707     function get(bytes calldata data) external returns (bool success, uint256 rate);
708 
709     /// @notice Check the last exchange rate without any state changes.
710     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
711     /// For example:
712     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
713     /// @return success if no valid (recent) rate is available, return false else true.
714     /// @return rate The rate of the requested asset / pair / pool.
715     function peek(bytes calldata data) external view returns (bool success, uint256 rate);
716 
717     /// @notice Check the current spot exchange rate without any state changes. For oracles like TWAP this will be different from peek().
718     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
719     /// For example:
720     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
721     /// @return rate The rate of the requested asset / pair / pool.
722     function peekSpot(bytes calldata data) external view returns (uint256 rate);
723 
724     /// @notice Returns a human readable (short) name about this oracle.
725     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
726     /// For example:
727     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
728     /// @return (string) A human readable symbol name about this oracle.
729     function symbol(bytes calldata data) external view returns (string memory);
730 
731     /// @notice Returns a human readable name about this oracle.
732     /// @param data Usually abi encoded, implementation specific data that contains information and arguments to & about the oracle.
733     /// For example:
734     /// (string memory collateralSymbol, string memory assetSymbol, uint256 division) = abi.decode(data, (string, string, uint256));
735     /// @return (string) A human readable name about this oracle.
736     function name(bytes calldata data) external view returns (string memory);
737 }
738 
739 interface ISwapper {
740     /// @notice Withdraws 'amountFrom' of token 'from' from the BentoBox account for this swapper.
741     /// Swaps it for at least 'amountToMin' of token 'to'.
742     /// Transfers the swapped tokens of 'to' into the BentoBox using a plain ERC20 transfer.
743     /// Returns the amount of tokens 'to' transferred to BentoBox.
744     /// (The BentoBox skim function will be used by the caller to get the swapped funds).
745     function swap(
746         IERC20 fromToken,
747         IERC20 toToken,
748         address recipient,
749         uint256 shareToMin,
750         uint256 shareFrom
751     ) external returns (uint256 extraShare, uint256 shareReturned);
752 
753     /// @notice Calculates the amount of token 'from' needed to complete the swap (amountFrom),
754     /// this should be less than or equal to amountFromMax.
755     /// Withdraws 'amountFrom' of token 'from' from the BentoBox account for this swapper.
756     /// Swaps it for exactly 'exactAmountTo' of token 'to'.
757     /// Transfers the swapped tokens of 'to' into the BentoBox using a plain ERC20 transfer.
758     /// Transfers allocated, but unused 'from' tokens within the BentoBox to 'refundTo' (amountFromMax - amountFrom).
759     /// Returns the amount of 'from' tokens withdrawn from BentoBox (amountFrom).
760     /// (The BentoBox skim function will be used by the caller to get the swapped funds).
761     function swapExact(
762         IERC20 fromToken,
763         IERC20 toToken,
764         address recipient,
765         address refundTo,
766         uint256 shareFromSupplied,
767         uint256 shareToExact
768     ) external returns (uint256 shareUsed, uint256 shareReturned);
769 }
770 
771 /// @title Cauldron
772 /// @dev This contract allows contract calls to any contract (except BentoBox)
773 /// from arbitrary callers thus, don't trust calls from this contract in any circumstances.
774 contract CauldronV2 is BoringOwnable, IMasterContract {
775     using BoringMath for uint256;
776     using BoringMath128 for uint128;
777     using RebaseLibrary for Rebase;
778     using BoringERC20 for IERC20;
779 
780     event LogExchangeRate(uint256 rate);
781     event LogAccrue(uint128 accruedAmount, address collateral);
782     event LogAddCollateral(address indexed from, address indexed to, uint256 share, address collateral);
783     event LogRemoveCollateral(address indexed from, address indexed to, uint256 share, address collateral);
784     event LogBorrow(address indexed from, address indexed to, uint256 amount, uint256 part, address collateral);
785     event LogRepay(address indexed from, address indexed to, uint256 amount, uint256 part, address collateral);
786     event LogFeeTo(address indexed newFeeTo);
787     event LogWithdrawFees(address indexed feeTo, uint256 feesEarnedFraction);
788 
789     // Immutables (for MasterContract and all clones)
790     IBentoBoxV1 public immutable bentoBox;
791     CauldronV2 public immutable masterContract;
792     IERC20 public immutable nxusd;
793     PermissionManager public immutable liquidatorManager;
794 
795     // MasterContract variables
796     address public feeTo;
797 
798     // Per clone variables
799     // Clone init settings
800     IERC20 public collateral;
801     IOracle public oracle;
802     bytes public oracleData;
803 
804     // Total amounts
805     uint256 public totalCollateralShare; // Total collateral supplied
806     Rebase public totalBorrow; // elastic = Total token amount to be repayed by borrowers, base = Total parts of the debt held by borrowers
807 
808     // User balances
809     mapping(address => uint256) public userCollateralShare;
810     mapping(address => uint256) public userBorrowPart;
811 
812     /// @notice Exchange and interest rate tracking.
813     /// This is 'cached' here because calls to Oracles can be very expensive.
814     uint256 public exchangeRate;
815 
816     struct AccrueInfo {
817         uint64 lastAccrued;
818         uint128 feesEarned;
819         uint64 INTEREST_PER_SECOND;
820     }
821 
822     AccrueInfo public accrueInfo;
823 
824     // Settings
825     uint256 public COLLATERIZATION_RATE;
826     uint256 private constant COLLATERIZATION_RATE_PRECISION = 1e5; // Must be less than EXCHANGE_RATE_PRECISION (due to optimization in math)
827 
828     uint256 private constant EXCHANGE_RATE_PRECISION = 1e18;
829 
830     uint256 public LIQUIDATION_MULTIPLIER; 
831     uint256 private constant LIQUIDATION_MULTIPLIER_PRECISION = 1e5;
832 
833     uint256 public BORROW_OPENING_FEE;
834     uint256 private constant BORROW_OPENING_FEE_PRECISION = 1e5;
835 
836     uint256 private constant DISTRIBUTION_PART = 0;
837     uint256 private constant DISTRIBUTION_PRECISION = 100;
838 
839     /// @notice The constructor is only used for the initial master contract. Subsequent clones are initialised via `init`.
840     constructor(IBentoBoxV1 bentoBox_, IERC20 nxusd_, PermissionManager liquidatorManager_) public {
841         bentoBox = bentoBox_;
842         nxusd = nxusd_;
843         masterContract = this;
844         liquidatorManager = liquidatorManager_;
845     }
846 
847     /// @notice Serves as the constructor for clones, as clones can't have a regular constructor
848     /// @dev `data` is abi encoded in the format: (IERC20 collateral, IERC20 asset, IOracle oracle, bytes oracleData)
849     function init(bytes calldata data) public payable override {
850         require(address(collateral) == address(0), "Cauldron: already initialized");
851         (collateral, oracle, oracleData, accrueInfo.INTEREST_PER_SECOND, LIQUIDATION_MULTIPLIER, COLLATERIZATION_RATE, BORROW_OPENING_FEE) = abi.decode(data, (IERC20, IOracle, bytes, uint64, uint256, uint256, uint256));
852         require(address(collateral) != address(0), "Cauldron: bad pair");
853     }
854 
855     /// @notice Accrues the interest on the borrowed tokens and handles the accumulation of fees.
856     function accrue() public virtual {
857         AccrueInfo memory _accrueInfo = accrueInfo;
858         // Number of seconds since accrue was called
859         uint256 elapsedTime = block.timestamp - _accrueInfo.lastAccrued;
860         if (elapsedTime == 0) {
861             return;
862         }
863         _accrueInfo.lastAccrued = uint64(block.timestamp);
864 
865         Rebase memory _totalBorrow = totalBorrow;
866         if (_totalBorrow.base == 0) {
867             accrueInfo = _accrueInfo;
868             return;
869         }
870 
871         // Accrue interest
872         uint128 extraAmount = (uint256(_totalBorrow.elastic).mul(_accrueInfo.INTEREST_PER_SECOND).mul(elapsedTime) / 1e18).to128();
873         _totalBorrow.elastic = _totalBorrow.elastic.add(extraAmount);
874 
875         _accrueInfo.feesEarned = _accrueInfo.feesEarned.add(extraAmount);
876         totalBorrow = _totalBorrow;
877         accrueInfo = _accrueInfo;
878 
879         emit LogAccrue(extraAmount, address(collateral));
880     }
881 
882     /// @notice Concrete implementation of `isSolvent`. Includes a third parameter to allow caching `exchangeRate`.
883     /// @param _exchangeRate The exchange rate. Used to cache the `exchangeRate` between calls.
884     function _isSolvent(address user, uint256 _exchangeRate) internal view returns (bool) {
885         // accrue must have already been called!
886         uint256 borrowPart = userBorrowPart[user];
887         if (borrowPart == 0) return true;
888         uint256 collateralShare = userCollateralShare[user];
889         if (collateralShare == 0) return false;
890 
891         Rebase memory _totalBorrow = totalBorrow;
892 
893         return
894             bentoBox.toAmount(
895                 collateral,
896                 collateralShare.mul(EXCHANGE_RATE_PRECISION / COLLATERIZATION_RATE_PRECISION).mul(COLLATERIZATION_RATE),
897                 false
898             ) >=
899             // Moved exchangeRate here instead of dividing the other side to preserve more precision
900             borrowPart.mul(_totalBorrow.elastic).mul(_exchangeRate) / _totalBorrow.base;
901     }
902 
903     /// @dev Checks if the user is solvent in the closed liquidation case at the end of the function body.
904     modifier solvent() {
905         _;
906         require(_isSolvent(msg.sender, exchangeRate), "Cauldron: user insolvent");
907     }
908 
909     /// @notice Gets the exchange rate. I.e how much collateral to buy 1e18 asset.
910     /// This function is supposed to be invoked if needed because Oracle queries can be expensive.
911     /// @return updated True if `exchangeRate` was updated.
912     /// @return rate The new exchange rate.
913     function updateExchangeRate() public virtual returns (bool updated, uint256 rate) {
914         (updated, rate) = oracle.get(oracleData);
915 
916         if (updated) {
917             exchangeRate = rate;
918             emit LogExchangeRate(rate);
919         } else {
920             // Return the old rate if fetching wasn't successful
921             rate = exchangeRate;
922         }
923     }
924 
925     /// @dev Helper function to move tokens.
926     /// @param token The ERC-20 token.
927     /// @param share The amount in shares to add.
928     /// @param total Grand total amount to deduct from this contract's balance. Only applicable if `skim` is True.
929     /// Only used for accounting checks.
930     /// @param skim If True, only does a balance check on this contract.
931     /// False if tokens from msg.sender in `bentoBox` should be transferred.
932     function _addTokens(
933         IERC20 token,
934         uint256 share,
935         uint256 total,
936         bool skim
937     ) internal {
938         if (skim) {
939             require(share <= bentoBox.balanceOf(token, address(this)).sub(total), "Cauldron: Skim too much");
940         } else {
941             bentoBox.transfer(token, msg.sender, address(this), share);
942         }
943     }
944 
945     /// @notice Adds `collateral` from msg.sender to the account `to`.
946     /// @param to The receiver of the tokens.
947     /// @param skim True if the amount should be skimmed from the deposit balance of msg.sender.x
948     /// False if tokens from msg.sender in `bentoBox` should be transferred.
949     /// @param share The amount of shares to add for `to`.
950     function addCollateral(
951         address to,
952         bool skim,
953         uint256 share
954     ) public virtual {
955         userCollateralShare[to] = userCollateralShare[to].add(share);
956         uint256 oldTotalCollateralShare = totalCollateralShare;
957         totalCollateralShare = oldTotalCollateralShare.add(share);
958         _addTokens(collateral, share, oldTotalCollateralShare, skim);
959         emit LogAddCollateral(skim ? address(bentoBox) : msg.sender, to, share, address(collateral));
960     }
961 
962     /// @dev Concrete implementation of `removeCollateral`.
963     function _removeCollateral(address to, uint256 share) internal {
964         userCollateralShare[msg.sender] = userCollateralShare[msg.sender].sub(share);
965         totalCollateralShare = totalCollateralShare.sub(share);
966         emit LogRemoveCollateral(msg.sender, to, share, address(collateral));
967         bentoBox.transfer(collateral, address(this), to, share);
968     }
969 
970     /// @notice Removes `share` amount of collateral and transfers it to `to`.
971     /// @param to The receiver of the shares.
972     /// @param share Amount of shares to remove.
973     function removeCollateral(address to, uint256 share) public virtual solvent {
974         // accrue must be called because we check solvency
975         accrue();
976         _removeCollateral(to, share);
977     }
978 
979     /// @dev Concrete implementation of `borrow`.
980     function _borrow(address to, uint256 amount) internal returns (uint256 part, uint256 share) {
981         uint256 feeAmount = amount.mul(BORROW_OPENING_FEE) / BORROW_OPENING_FEE_PRECISION; // A flat % fee is charged for any borrow
982         (totalBorrow, part) = totalBorrow.add(amount.add(feeAmount), true);
983         accrueInfo.feesEarned = accrueInfo.feesEarned.add(uint128(feeAmount));
984         userBorrowPart[msg.sender] = userBorrowPart[msg.sender].add(part);
985 
986         // As long as there are tokens on this contract you can 'mint'... this enables limiting borrows
987         share = bentoBox.toShare(nxusd, amount, false);
988         bentoBox.transfer(nxusd, address(this), to, share);
989 
990         emit LogBorrow(msg.sender, to, amount.add(feeAmount), part, address(collateral));
991     }
992 
993     /// @notice Sender borrows `amount` and transfers it to `to`.
994     /// @return part Total part of the debt held by borrowers.
995     /// @return share Total amount in shares borrowed.
996     function borrow(address to, uint256 amount) public solvent virtual returns (uint256 part, uint256 share) {
997         accrue();
998         (part, share) = _borrow(to, amount);
999     }
1000 
1001     /// @dev Concrete implementation of `repay`.
1002     function _repay(
1003         address to,
1004         bool skim,
1005         uint256 part
1006     ) internal returns (uint256 amount) {
1007         (totalBorrow, amount) = totalBorrow.sub(part, true);
1008         userBorrowPart[to] = userBorrowPart[to].sub(part);
1009 
1010         uint256 share = bentoBox.toShare(nxusd, amount, true);
1011         bentoBox.transfer(nxusd, skim ? address(bentoBox) : msg.sender, address(this), share);
1012         emit LogRepay(skim ? address(bentoBox) : msg.sender, to, amount, part, address(collateral));
1013     }
1014 
1015     /// @notice Repays a loan.
1016     /// @param to Address of the user this payment should go.
1017     /// @param skim True if the amount should be skimmed from the deposit balance of msg.sender.
1018     /// False if tokens from msg.sender in `bentoBox` should be transferred.
1019     /// @param part The amount to repay. See `userBorrowPart`.
1020     /// @return amount The total amount repayed.
1021     function repay(
1022         address to,
1023         bool skim,
1024         uint256 part
1025     ) public virtual returns (uint256 amount) {
1026         accrue();
1027         amount = _repay(to, skim, part);
1028     }
1029 
1030     // Functions that need accrue to be called
1031     uint8 internal constant ACTION_REPAY = 2;
1032     uint8 internal constant ACTION_REMOVE_COLLATERAL = 4;
1033     uint8 internal constant ACTION_BORROW = 5;
1034     uint8 internal constant ACTION_GET_REPAY_SHARE = 6;
1035     uint8 internal constant ACTION_GET_REPAY_PART = 7;
1036     uint8 internal constant ACTION_ACCRUE = 8;
1037 
1038     // Functions that don't need accrue to be called
1039     uint8 internal constant ACTION_ADD_COLLATERAL = 10;
1040     uint8 internal constant ACTION_UPDATE_EXCHANGE_RATE = 11;
1041 
1042     // Function on BentoBox
1043     uint8 internal constant ACTION_BENTO_DEPOSIT = 20;
1044     uint8 internal constant ACTION_BENTO_WITHDRAW = 21;
1045     uint8 internal constant ACTION_BENTO_TRANSFER = 22;
1046     uint8 internal constant ACTION_BENTO_TRANSFER_MULTIPLE = 23;
1047     uint8 internal constant ACTION_BENTO_SETAPPROVAL = 24;
1048 
1049     // Any external call (except to BentoBox)
1050     uint8 internal constant ACTION_CALL = 30;
1051 
1052     int256 internal constant USE_VALUE1 = -1;
1053     int256 internal constant USE_VALUE2 = -2;
1054 
1055     /// @dev Helper function for choosing the correct value (`value1` or `value2`) depending on `inNum`.
1056     function _num(
1057         int256 inNum,
1058         uint256 value1,
1059         uint256 value2
1060     ) internal pure returns (uint256 outNum) {
1061         outNum = inNum >= 0 ? uint256(inNum) : (inNum == USE_VALUE1 ? value1 : value2);
1062     }
1063 
1064     /// @dev Helper function for depositing into `bentoBox`.
1065     function _bentoDeposit(
1066         bytes memory data,
1067         uint256 value,
1068         uint256 value1,
1069         uint256 value2
1070     ) internal returns (uint256, uint256) {
1071         (IERC20 token, address to, int256 amount, int256 share) = abi.decode(data, (IERC20, address, int256, int256));
1072         amount = int256(_num(amount, value1, value2)); // Done this way to avoid stack too deep errors
1073         share = int256(_num(share, value1, value2));
1074         return bentoBox.deposit{value: value}(token, msg.sender, to, uint256(amount), uint256(share));
1075     }
1076 
1077     /// @dev Helper function to withdraw from the `bentoBox`.
1078     function _bentoWithdraw(
1079         bytes memory data,
1080         uint256 value1,
1081         uint256 value2
1082     ) internal returns (uint256, uint256) {
1083         (IERC20 token, address to, int256 amount, int256 share) = abi.decode(data, (IERC20, address, int256, int256));
1084         return bentoBox.withdraw(token, msg.sender, to, _num(amount, value1, value2), _num(share, value1, value2));
1085     }
1086 
1087     /// @dev Helper function to perform a contract call and eventually extracting revert messages on failure.
1088     /// Calls to `bentoBox` are not allowed for obvious security reasons.
1089     /// This also means that calls made from this contract shall *not* be trusted.
1090     function _call(
1091         uint256 value,
1092         bytes memory data,
1093         uint256 value1,
1094         uint256 value2
1095     ) internal returns (bytes memory, uint8) {
1096         (address callee, bytes memory callData, bool useValue1, bool useValue2, uint8 returnValues) =
1097             abi.decode(data, (address, bytes, bool, bool, uint8));
1098 
1099         if (useValue1 && !useValue2) {
1100             callData = abi.encodePacked(callData, value1);
1101         } else if (!useValue1 && useValue2) {
1102             callData = abi.encodePacked(callData, value2);
1103         } else if (useValue1 && useValue2) {
1104             callData = abi.encodePacked(callData, value1, value2);
1105         }
1106 
1107         require(callee != address(bentoBox) && callee != address(this), "Cauldron: can't call");
1108 
1109         (bool success, bytes memory returnData) = callee.call{value: value}(callData);
1110         require(success, "Cauldron: call failed");
1111         return (returnData, returnValues);
1112     }
1113 
1114     struct CookStatus {
1115         bool needsSolvencyCheck;
1116         bool hasAccrued;
1117     }
1118 
1119     /// @notice Executes a set of actions and allows composability (contract calls) to other contracts.
1120     /// @param actions An array with a sequence of actions to execute (see ACTION_ declarations).
1121     /// @param values A one-to-one mapped array to `actions`. ETH amounts to send along with the actions.
1122     /// Only applicable to `ACTION_CALL`, `ACTION_BENTO_DEPOSIT`.
1123     /// @param datas A one-to-one mapped array to `actions`. Contains abi encoded data of function arguments.
1124     /// @return value1 May contain the first positioned return value of the last executed action (if applicable).
1125     /// @return value2 May contain the second positioned return value of the last executed action which returns 2 values (if applicable).
1126     function cook(
1127         uint8[] calldata actions,
1128         uint256[] calldata values,
1129         bytes[] calldata datas
1130     ) public virtual payable returns (uint256 value1, uint256 value2) {
1131         CookStatus memory status;
1132         for (uint256 i = 0; i < actions.length; i++) {
1133             uint8 action = actions[i];
1134             if (!status.hasAccrued && action < 10) {
1135                 accrue();
1136                 status.hasAccrued = true;
1137             }
1138             if (action == ACTION_ADD_COLLATERAL) {
1139                 (int256 share, address to, bool skim) = abi.decode(datas[i], (int256, address, bool));
1140                 addCollateral(to, skim, _num(share, value1, value2));
1141             } else if (action == ACTION_REPAY) {
1142                 (int256 part, address to, bool skim) = abi.decode(datas[i], (int256, address, bool));
1143                 _repay(to, skim, _num(part, value1, value2));
1144             } else if (action == ACTION_REMOVE_COLLATERAL) {
1145                 (int256 share, address to) = abi.decode(datas[i], (int256, address));
1146                 _removeCollateral(to, _num(share, value1, value2));
1147                 status.needsSolvencyCheck = true;
1148             } else if (action == ACTION_BORROW) {
1149                 (int256 amount, address to) = abi.decode(datas[i], (int256, address));
1150                 (value1, value2) = _borrow(to, _num(amount, value1, value2));
1151                 status.needsSolvencyCheck = true;
1152             } else if (action == ACTION_UPDATE_EXCHANGE_RATE) {
1153                 (bool must_update, uint256 minRate, uint256 maxRate) = abi.decode(datas[i], (bool, uint256, uint256));
1154                 (bool updated, uint256 rate) = updateExchangeRate();
1155                 require((!must_update || updated) && rate > minRate && (maxRate == 0 || rate > maxRate), "Cauldron: rate not ok");
1156             } else if (action == ACTION_BENTO_SETAPPROVAL) {
1157                 (address user, address _masterContract, bool approved, uint8 v, bytes32 r, bytes32 s) =
1158                     abi.decode(datas[i], (address, address, bool, uint8, bytes32, bytes32));
1159                 bentoBox.setMasterContractApproval(user, _masterContract, approved, v, r, s);
1160             } else if (action == ACTION_BENTO_DEPOSIT) {
1161                 (value1, value2) = _bentoDeposit(datas[i], values[i], value1, value2);
1162             } else if (action == ACTION_BENTO_WITHDRAW) {
1163                 (value1, value2) = _bentoWithdraw(datas[i], value1, value2);
1164             } else if (action == ACTION_BENTO_TRANSFER) {
1165                 (IERC20 token, address to, int256 share) = abi.decode(datas[i], (IERC20, address, int256));
1166                 bentoBox.transfer(token, msg.sender, to, _num(share, value1, value2));
1167             } else if (action == ACTION_BENTO_TRANSFER_MULTIPLE) {
1168                 (IERC20 token, address[] memory tos, uint256[] memory shares) = abi.decode(datas[i], (IERC20, address[], uint256[]));
1169                 bentoBox.transferMultiple(token, msg.sender, tos, shares);
1170             } else if (action == ACTION_CALL) {
1171                 (bytes memory returnData, uint8 returnValues) = _call(values[i], datas[i], value1, value2);
1172 
1173                 if (returnValues == 1) {
1174                     (value1) = abi.decode(returnData, (uint256));
1175                 } else if (returnValues == 2) {
1176                     (value1, value2) = abi.decode(returnData, (uint256, uint256));
1177                 }
1178             } else if (action == ACTION_GET_REPAY_SHARE) {
1179                 int256 part = abi.decode(datas[i], (int256));
1180                 value1 = bentoBox.toShare(nxusd, totalBorrow.toElastic(_num(part, value1, value2), true), true);
1181             } else if (action == ACTION_GET_REPAY_PART) {
1182                 int256 amount = abi.decode(datas[i], (int256));
1183                 value1 = totalBorrow.toBase(_num(amount, value1, value2), false);
1184             }
1185         }
1186 
1187         if (status.needsSolvencyCheck) {
1188             require(_isSolvent(msg.sender, exchangeRate), "Cauldron: user insolvent");
1189         }
1190     }
1191 
1192     /// @notice Handles the liquidation of users' balances, once the users' amount of collateral is too low.
1193     /// @param users An array of user addresses.
1194     /// @param maxBorrowParts A one-to-one mapping to `users`, contains maximum (partial) borrow amounts (to liquidate) of the respective user.
1195     /// @param to Address of the receiver in open liquidations if `swapper` is zero.
1196     function liquidate(
1197         address[] calldata users,
1198         uint256[] calldata maxBorrowParts,
1199         address to,
1200         ISwapper swapper
1201     ) public {
1202         (, bool isAllowed) = liquidatorManager.info(msg.sender);
1203         require(isAllowed, "sender is not approved as liquidator");
1204         // Oracle can fail but we still need to allow liquidations
1205         (, uint256 _exchangeRate) = updateExchangeRate();
1206         accrue();
1207 
1208         uint256 allCollateralShare;
1209         uint256 allBorrowAmount;
1210         uint256 allBorrowPart;
1211         Rebase memory _totalBorrow = totalBorrow;
1212         Rebase memory bentoBoxTotals = bentoBox.totals(collateral);
1213         for (uint256 i = 0; i < users.length; i++) {
1214             address user = users[i];
1215             if (!_isSolvent(user, _exchangeRate)) {
1216                 uint256 borrowPart;
1217                 {
1218                     uint256 availableBorrowPart = userBorrowPart[user];
1219                     borrowPart = maxBorrowParts[i] > availableBorrowPart ? availableBorrowPart : maxBorrowParts[i];
1220                     userBorrowPart[user] = availableBorrowPart.sub(borrowPart);
1221                 }
1222                 uint256 borrowAmount = _totalBorrow.toElastic(borrowPart, false);
1223                 uint256 collateralShare =
1224                     bentoBoxTotals.toBase(
1225                         borrowAmount.mul(LIQUIDATION_MULTIPLIER).mul(_exchangeRate) /
1226                             (LIQUIDATION_MULTIPLIER_PRECISION * EXCHANGE_RATE_PRECISION),
1227                         false
1228                     );
1229 
1230                 userCollateralShare[user] = userCollateralShare[user].sub(collateralShare);
1231                 emit LogRemoveCollateral(user, to, collateralShare, address(collateral));
1232                 emit LogRepay(msg.sender, user, borrowAmount, borrowPart, address(collateral));
1233 
1234                 // Keep totals
1235                 allCollateralShare = allCollateralShare.add(collateralShare);
1236                 allBorrowAmount = allBorrowAmount.add(borrowAmount);
1237                 allBorrowPart = allBorrowPart.add(borrowPart);
1238             }
1239         }
1240         require(allBorrowAmount != 0, "Cauldron: all are solvent");
1241         _totalBorrow.elastic = _totalBorrow.elastic.sub(allBorrowAmount.to128());
1242         _totalBorrow.base = _totalBorrow.base.sub(allBorrowPart.to128());
1243         totalBorrow = _totalBorrow;
1244         totalCollateralShare = totalCollateralShare.sub(allCollateralShare);
1245 
1246         // Apply a percentual fee share to sSpell holders
1247         
1248         {
1249             uint256 distributionAmount = (allBorrowAmount.mul(LIQUIDATION_MULTIPLIER) / LIQUIDATION_MULTIPLIER_PRECISION).sub(allBorrowAmount).mul(DISTRIBUTION_PART) / DISTRIBUTION_PRECISION; // Distribution Amount
1250             allBorrowAmount = allBorrowAmount.add(distributionAmount);
1251             accrueInfo.feesEarned = accrueInfo.feesEarned.add(distributionAmount.to128());
1252         }
1253 
1254         uint256 allBorrowShare = bentoBox.toShare(nxusd, allBorrowAmount, true);
1255 
1256         // Swap using a swapper freely chosen by the caller
1257         // Open (flash) liquidation: get proceeds first and provide the borrow after
1258         bentoBox.transfer(collateral, address(this), to, allCollateralShare);
1259         if (swapper != ISwapper(0)) {
1260             swapper.swap(collateral, nxusd, msg.sender, allBorrowShare, allCollateralShare);
1261         }
1262 
1263         bentoBox.transfer(nxusd, msg.sender, address(this), allBorrowShare);
1264     }
1265 
1266     /// @notice Withdraws the fees accumulated.
1267     function withdrawFees() public virtual {
1268         accrue();
1269         address _feeTo = masterContract.feeTo();
1270         uint256 _feesEarned = accrueInfo.feesEarned;
1271         uint256 share = bentoBox.toShare(nxusd, _feesEarned, false);
1272         bentoBox.transfer(nxusd, address(this), _feeTo, share);
1273         accrueInfo.feesEarned = 0;
1274 
1275         emit LogWithdrawFees(_feeTo, _feesEarned);
1276     }
1277 
1278     /// @notice Sets the beneficiary of interest accrued.
1279     /// MasterContract Only Admin function.
1280     /// @param newFeeTo The address of the receiver.
1281     function setFeeTo(address newFeeTo) public virtual onlyOwner {
1282         feeTo = newFeeTo;
1283         emit LogFeeTo(newFeeTo);
1284     }
1285 
1286     /// @notice reduces the supply of NXUSD
1287     /// @param amount amount to reduce supply by
1288     function reduceSupply(uint256 amount) public virtual {
1289         require(msg.sender == masterContract.owner(), "Caller is not the owner");
1290         bentoBox.withdraw(nxusd, address(this), address(this), amount, 0);
1291         NXUSD(address(nxusd)).burn(amount);
1292     }
1293 }
