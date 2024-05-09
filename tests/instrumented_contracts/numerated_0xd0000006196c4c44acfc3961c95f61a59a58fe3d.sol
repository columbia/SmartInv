1 // SPDX-License-Identifier: MIT
2 //      _ __  __ __  __ __  __     _
3 //     | |  \/  |  \/  |  \/  |   (_)
4 //   __| | \  / | \  / | \  / |    _  ___
5 //  / _` | |\/| | |\/| | |\/| |   | |/ _ \
6 // | (_| | |  | | |  | | |  | |  _| | (_) |
7 //  \__,_|_|  |_|_|  |_|_|  |_| (_)_|\___/
8 
9 // dMMM dApp: https://dMMM.io
10 // Official Website: http://d-mmm.github.io/
11 // Telegram Channel:  https://t.me/dMMM2020
12 // Github: https://github.com/d-mmm
13 // WhitePaper: https://dMMM.io/whitepaper
14 
15 pragma solidity >=0.6.0;
16 
17 /**
18  * @dev Interface of the ERC20 standard as defined in the EIP.
19  */
20 interface IERC20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
90 // SPDX-License-Identifier: MIT
91 
92 
93 
94 interface IMaster {
95     function isOwner(address _addr) external view returns (bool);
96 
97     function payableOwner() external view returns (address payable);
98 
99     function isInternal(address _addr) external view returns (bool);
100 
101     function getLatestAddress(bytes2 _contractName)
102         external
103         view
104         returns (address contractAddress);
105 }
106 // SPDX-License-Identifier: MIT
107 
108 
109 
110 interface IDeFiLogic {
111     function onTokenReceived(
112         address token,
113         address operator,
114         address msgSender,
115         address to,
116         uint256 amount,
117         bytes calldata userData,
118         bytes calldata operatorData
119     ) external;
120 
121     function getOriginalAccountQuota()
122         external
123         view
124         returns (
125             uint256,
126             uint256,
127             uint256
128         );
129 
130     function register(
131         address msgSender,
132         uint256 msgValue,
133         bytes32 inviteCode,
134         bool purchaseOriginAccount
135     ) external;
136 
137     function claimROI(address msgSender) external;
138 
139     function deposit(
140         address msgSender,
141         uint256 poolID,
142         uint256 tokenAmt
143     ) external;
144 }
145 // SPDX-License-Identifier: MIT
146 
147 
148 
149 interface IDeFiStorage {
150     enum ConfigType {
151         InvestAmt,
152         StaticIncomeAmt,
153         DynamicIncomePercent,
154         ClaimFeePercent,
155         UpgradeRequiredInviteValidPlayerCount,
156         UpgradeRequiredMarketPerformance,
157         UpgradeRequiredSelfInvestCount
158     }
159     enum InvestType {Newbie, Open, PreOrder}
160     enum GlobalStatus {Pending, Started, Bankruptcy, Ended}
161     event GlobalBlocks(uint256 indexed eventID, uint256[3] blocks);
162 
163     // public
164     function getCurrentRoundID(bool enableCurrentBlock)
165         external
166         view
167         returns (uint256);
168 
169     function getAvailableRoundID(bool isNewUser, bool enableCurrentBlock)
170         external
171         view
172         returns (uint256 id, InvestType investType);
173 
174     function getInvestGear(uint256 usdAmt) external view returns (uint256);
175 
176     function U2T(uint256 usdAmt) external view returns (uint256);
177 
178     function U2E(uint256 usdAmt) external view returns (uint256);
179 
180     function T2U(uint256 tokenAmt) external view returns (uint256);
181 
182     function E2U(uint256 etherAmt) external view returns (uint256);
183 
184     function T2E(uint256 tokenAmt) external view returns (uint256);
185 
186     function E2T(uint256 etherAmt) external view returns (uint256);
187 
188     function getGlobalStatus() external view returns (GlobalStatus);
189 
190     function last100() external view returns (uint256[100] memory);
191 
192     function getGlobalBlocks() external view returns (uint256[3] memory);
193 
194     function getDeFiAccounts() external view returns (uint256[5] memory);
195 
196     function getPoolSplitStats() external view returns (uint256[3] memory);
197 
198     function getPoolSplitPercent(uint256 roundID) external view returns (uint256[6] memory splitPrcent, uint256[2] memory nodeCount);
199 
200     // internal
201     function isLast100AndLabel(uint256 userID) external returns (bool);
202 
203     function increaseRoundData(
204         uint256 roundID,
205         uint256 dataID,
206         uint256 num
207     ) external;
208 
209     function getNodePerformance(
210         uint256 roundID,
211         uint256 nodeID,
212         bool isSuperNode
213     ) external view returns (uint256);
214 
215     function increaseUserData(
216         uint256 userID,
217         uint256 dataID,
218         uint256 num,
219         bool isSub,
220         bool isSet
221     ) external;
222 
223     function checkRoundAvailableAndUpdate(
224         bool isNewUser,
225         uint256 roundID,
226         uint256 usdAmt,
227         uint256 tokenAmt
228     ) external returns (bool success);
229 
230     function increaseDeFiAccount(
231         uint256 accountID,
232         uint256 num,
233         bool isSub
234     ) external returns (bool);
235 
236     function getUser(uint256 userID)
237         external
238         view
239         returns (
240             bool[2] memory userBoolArray,
241             uint256[21] memory userUint256Array
242         );
243 
244     function getUserUint256Data(uint256 userID, uint256 dataID)
245         external
246         view
247         returns (uint256);
248 
249     function setDeFiAccounts(uint256[5] calldata data) external;
250 
251     function splitDone() external;
252 
253     function getSelfInvestCount(uint256 userID)
254         external
255         view
256         returns (uint256[5] memory selfInvestCount);
257 
258     function setSelfInvestCount(
259         uint256 userID,
260         uint256[5] calldata selfInvestCount
261     ) external;
262 
263     function pushToInvestQueue(uint256 userID) external;
264 
265     function effectReferrals(
266         uint256 userID,
267         uint256 roundID,
268         uint256 usdAmt,
269         bool isNewUser
270     ) external;
271 
272     function getLevelConfig(uint256 level, ConfigType configType)
273         external
274         view
275         returns (uint256);
276 
277     function getUserFatherIDs(uint256 userID)
278         external
279         view
280         returns (uint256[7] memory fathers);
281 
282     function getUserFatherActiveInfo(uint256 userID)
283         external
284         view
285         returns (
286             uint256[7] memory fathers,
287             uint256[7] memory roundID,
288             uint256[7] memory lastActive,
289             address[7] memory addrs
290         );
291 
292     function getUserFatherAddrs(uint256 userID)
293         external
294         view
295         returns (address[7] memory fathers);
296 
297     function setGlobalBlocks(uint256[3] calldata blocks) external;
298 
299     function getGlobalNodeCount(uint256 roundID)
300         external
301         view
302         returns (uint256[2] memory nodeCount);
303 
304     function getToken() external view returns (address);
305 
306     function setToken(address token) external;
307 
308     function getPlatformAddress() external view returns (address payable);
309 
310     function setPlatformAddress(address payable platformAddress) external;
311 
312     function getIDByAddr(address addr) external view returns (uint256);
313 
314     function getAddrByID(uint256 id) external view returns (address);
315 
316     function setUserAddr(uint256 id, address addr) external;
317 
318     function getIDByInviteCode(bytes32 inviteCode)
319         external
320         view
321         returns (uint256);
322 
323     function getInviteCodeByID(uint256 id) external view returns (bytes32);
324 
325     function setUserInviteCode(uint256 id, bytes32 inviteCode) external;
326 
327     function issueUserID(address addr) external returns (uint256);
328 
329     function issueEventIndex() external returns (uint256);
330 
331     function setUser(
332         uint256 userID,
333         bool[2] calldata userBoolArry,
334         uint256[21] calldata userUint256Array
335     ) external;
336 
337     function deactivateUser(uint256 id) external;
338 
339     function getRound(uint256 roundID)
340         external
341         view
342         returns (uint256[4] memory roundUint256Vars);
343 
344     function setRound(uint256 roundID, uint256[4] calldata roundUint256Vars)
345         external;
346 
347     function setE2U(uint256 e2u) external;
348 
349     function setT2U(uint256 t2u) external;
350 
351     function setRoundLimit(uint256[] calldata roundID, uint256[] calldata limit)
352         external;
353 }
354 // SPDX-License-Identifier: MIT
355 
356 
357 
358 interface IDeFi {
359     function sendToken(address to, uint256 amt) external;
360 
361     function sendETH(address payable to, uint256 amt) external;
362 }
363 // SPDX-License-Identifier: MIT
364 //      _ __  __ __  __ __  __     _
365 //     | |  \/  |  \/  |  \/  |   (_)
366 //   __| | \  / | \  / | \  / |    _  ___
367 //  / _` | |\/| | |\/| | |\/| |   | |/ _ \
368 // | (_| | |  | | |  | | |  | |  _| | (_) |
369 //  \__,_|_|  |_|_|  |_|_|  |_| (_)_|\___/
370 
371 // dMMM dApp: https://dMMM.io
372 // Official Website: http://d-mmm.github.io/
373 // Telegram Channel:  https://t.me/dMMM2020
374 // Github: https://github.com/d-mmm
375 // WhitePaper: https://dMMM.io/whitepaper
376 
377 
378 
379 
380 
381 
382 // SPDX-License-Identifier: MIT
383 
384 
385 
386 /**
387  * @dev Interface of the ERC777TokensRecipient standard as defined in the EIP.
388  *
389  * Accounts can be notified of {IERC777} tokens being sent to them by having a
390  * contract implement this interface (contract holders can be their own
391  * implementer) and registering it on the
392  * https://eips.ethereum.org/EIPS/eip-1820[ERC1820 global registry].
393  *
394  * See {IERC1820Registry} and {ERC1820Implementer}.
395  */
396 interface IERC777Recipient {
397     /**
398      * @dev Called by an {IERC777} token contract whenever tokens are being
399      * moved or created into a registered account (`to`). The type of operation
400      * is conveyed by `from` being the zero address or not.
401      *
402      * This call occurs _after_ the token contract's state is updated, so
403      * {IERC777-balanceOf}, etc., can be used to query the post-operation state.
404      *
405      * This function may revert to prevent the operation from being executed.
406      */
407     function tokensReceived(
408         address operator,
409         address from,
410         address to,
411         uint256 amount,
412         bytes calldata userData,
413         bytes calldata operatorData
414     ) external;
415 }
416 
417 // SPDX-License-Identifier: MIT
418 
419 
420 
421 /**
422  * @dev Interface of the global ERC1820 Registry, as defined in the
423  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
424  * implementers for interfaces in this registry, as well as query support.
425  *
426  * Implementers may be shared by multiple accounts, and can also implement more
427  * than a single interface for each account. Contracts can implement interfaces
428  * for themselves, but externally-owned accounts (EOA) must delegate this to a
429  * contract.
430  *
431  * {IERC165} interfaces can also be queried via the registry.
432  *
433  * For an in-depth explanation and source code analysis, see the EIP text.
434  */
435 interface IERC1820Registry {
436     /**
437      * @dev Sets `newManager` as the manager for `account`. A manager of an
438      * account is able to set interface implementers for it.
439      *
440      * By default, each account is its own manager. Passing a value of `0x0` in
441      * `newManager` will reset the manager to this initial state.
442      *
443      * Emits a {ManagerChanged} event.
444      *
445      * Requirements:
446      *
447      * - the caller must be the current manager for `account`.
448      */
449     function setManager(address account, address newManager) external;
450 
451     /**
452      * @dev Returns the manager for `account`.
453      *
454      * See {setManager}.
455      */
456     function getManager(address account) external view returns (address);
457 
458     /**
459      * @dev Sets the `implementer` contract as ``account``'s implementer for
460      * `interfaceHash`.
461      *
462      * `account` being the zero address is an alias for the caller's address.
463      * The zero address can also be used in `implementer` to remove an old one.
464      *
465      * See {interfaceHash} to learn how these are created.
466      *
467      * Emits an {InterfaceImplementerSet} event.
468      *
469      * Requirements:
470      *
471      * - the caller must be the current manager for `account`.
472      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
473      * end in 28 zeroes).
474      * - `implementer` must implement {IERC1820Implementer} and return true when
475      * queried for support, unless `implementer` is the caller. See
476      * {IERC1820Implementer-canImplementInterfaceForAddress}.
477      */
478     function setInterfaceImplementer(address account, bytes32 interfaceHash, address implementer) external;
479 
480     /**
481      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
482      * implementer is registered, returns the zero address.
483      *
484      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
485      * zeroes), `account` will be queried for support of it.
486      *
487      * `account` being the zero address is an alias for the caller's address.
488      */
489     function getInterfaceImplementer(address account, bytes32 interfaceHash) external view returns (address);
490 
491     /**
492      * @dev Returns the interface hash for an `interfaceName`, as defined in the
493      * corresponding
494      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
495      */
496     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
497 
498     /**
499      *  @notice Updates the cache with whether the contract implements an ERC165 interface or not.
500      *  @param account Address of the contract for which to update the cache.
501      *  @param interfaceId ERC165 interface for which to update the cache.
502      */
503     function updateERC165Cache(address account, bytes4 interfaceId) external;
504 
505     /**
506      *  @notice Checks whether a contract implements an ERC165 interface or not.
507      *  If the result is not cached a direct lookup on the contract address is performed.
508      *  If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
509      *  {updateERC165Cache} with the contract address.
510      *  @param account Address of the contract to check.
511      *  @param interfaceId ERC165 interface to check.
512      *  @return True if `account` implements `interfaceId`, false otherwise.
513      */
514     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
515 
516     /**
517      *  @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
518      *  @param account Address of the contract to check.
519      *  @param interfaceId ERC165 interface to check.
520      *  @return True if `account` implements `interfaceId`, false otherwise.
521      */
522     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
523 
524     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
525 
526     event ManagerChanged(address indexed account, address indexed newManager);
527 }
528 
529 
530 // SPDX-License-Identifier: MIT
531 
532 
533 
534 
535 // SPDX-License-Identifier: MIT
536 
537 
538 
539 /**
540  * @dev Collection of functions related to the address type
541  */
542 library Address {
543     /**
544      * @dev Returns true if `account` is a contract.
545      *
546      * [IMPORTANT]
547      * ====
548      * It is unsafe to assume that an address for which this function returns
549      * false is an externally-owned account (EOA) and not a contract.
550      *
551      * Among others, `isContract` will return false for the following
552      * types of addresses:
553      *
554      *  - an externally-owned account
555      *  - a contract in construction
556      *  - an address where a contract will be created
557      *  - an address where a contract lived, but was destroyed
558      * ====
559      */
560     function isContract(address account) internal view returns (bool) {
561         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
562         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
563         // for accounts without code, i.e. `keccak256('')`
564         bytes32 codehash;
565         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
566         // solhint-disable-next-line no-inline-assembly
567         assembly { codehash := extcodehash(account) }
568         return (codehash != accountHash && codehash != 0x0);
569     }
570 
571     /**
572      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
573      * `recipient`, forwarding all available gas and reverting on errors.
574      *
575      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
576      * of certain opcodes, possibly making contracts go over the 2300 gas limit
577      * imposed by `transfer`, making them unable to receive funds via
578      * `transfer`. {sendValue} removes this limitation.
579      *
580      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
581      *
582      * IMPORTANT: because control is transferred to `recipient`, care must be
583      * taken to not create reentrancy vulnerabilities. Consider using
584      * {ReentrancyGuard} or the
585      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
586      */
587     function sendValue(address payable recipient, uint256 amount) internal {
588         require(address(this).balance >= amount, "Address: insufficient balance");
589 
590         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
591         (bool success, ) = recipient.call{ value: amount }("");
592         require(success, "Address: unable to send value, recipient may have reverted");
593     }
594 
595     /**
596      * @dev Performs a Solidity function call using a low level `call`. A
597      * plain`call` is an unsafe replacement for a function call: use this
598      * function instead.
599      *
600      * If `target` reverts with a revert reason, it is bubbled up by this
601      * function (like regular Solidity function calls).
602      *
603      * Returns the raw returned data. To convert to the expected return value,
604      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
605      *
606      * Requirements:
607      *
608      * - `target` must be a contract.
609      * - calling `target` with `data` must not revert.
610      *
611      * _Available since v3.1._
612      */
613     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
614       return functionCall(target, data, "Address: low-level call failed");
615     }
616 
617     /**
618      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
619      * `errorMessage` as a fallback revert reason when `target` reverts.
620      *
621      * _Available since v3.1._
622      */
623     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
624         return _functionCallWithValue(target, data, 0, errorMessage);
625     }
626 
627     /**
628      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
629      * but also transferring `value` wei to `target`.
630      *
631      * Requirements:
632      *
633      * - the calling contract must have an ETH balance of at least `value`.
634      * - the called Solidity function must be `payable`.
635      *
636      * _Available since v3.1._
637      */
638     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
639         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
644      * with `errorMessage` as a fallback revert reason when `target` reverts.
645      *
646      * _Available since v3.1._
647      */
648     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
649         require(address(this).balance >= value, "Address: insufficient balance for call");
650         return _functionCallWithValue(target, data, value, errorMessage);
651     }
652 
653     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
654         require(isContract(target), "Address: call to non-contract");
655 
656         // solhint-disable-next-line avoid-low-level-calls
657         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
658         if (success) {
659             return returndata;
660         } else {
661             // Look for revert reason and bubble it up if present
662             if (returndata.length > 0) {
663                 // The easiest way to bubble the revert reason is using memory via assembly
664 
665                 // solhint-disable-next-line no-inline-assembly
666                 assembly {
667                     let returndata_size := mload(returndata)
668                     revert(add(32, returndata), returndata_size)
669                 }
670             } else {
671                 revert(errorMessage);
672             }
673         }
674     }
675 }
676 
677 
678 abstract contract IUpgradable {
679     IMaster public master;
680 
681     modifier onlyInternal {
682         assert(master.isInternal(msg.sender));
683         _;
684     }
685 
686     modifier onlyOwner {
687         assert(master.isOwner(msg.sender));
688         _;
689     }
690 
691     modifier onlyMaster {
692         assert(address(master) == msg.sender);
693         _;
694     }
695 
696     /**
697      * @dev IUpgradable Interface to update dependent contract address
698      */
699     function changeDependentContractAddress() public virtual;
700 
701     /**
702      * @dev change master address
703      * @param addr is the new address
704      */
705     function changeMasterAddress(address addr) public {
706         assert(Address.isContract(addr));
707         assert(address(master) == address(0) || address(master) == msg.sender);
708         master = IMaster(addr);
709     }
710 }
711 
712 // SPDX-License-Identifier: MIT
713 
714 
715 
716 
717 // SPDX-License-Identifier: MIT
718 
719 
720 
721 /**
722  * @dev Wrappers over Solidity's arithmetic operations with added overflow
723  * checks.
724  *
725  * Arithmetic operations in Solidity wrap on overflow. This can easily result
726  * in bugs, because programmers usually assume that an overflow raises an
727  * error, which is the standard behavior in high level programming languages.
728  * `SafeMath` restores this intuition by reverting the transaction when an
729  * operation overflows.
730  *
731  * Using this library instead of the unchecked operations eliminates an entire
732  * class of bugs, so it's recommended to use it always.
733  */
734 library SafeMath {
735     /**
736      * @dev Returns the addition of two unsigned integers, reverting on
737      * overflow.
738      *
739      * Counterpart to Solidity's `+` operator.
740      *
741      * Requirements:
742      *
743      * - Addition cannot overflow.
744      */
745     function add(uint256 a, uint256 b) internal pure returns (uint256) {
746         uint256 c = a + b;
747         require(c >= a, "SafeMath: addition overflow");
748 
749         return c;
750     }
751 
752     /**
753      * @dev Returns the subtraction of two unsigned integers, reverting on
754      * overflow (when the result is negative).
755      *
756      * Counterpart to Solidity's `-` operator.
757      *
758      * Requirements:
759      *
760      * - Subtraction cannot overflow.
761      */
762     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
763         return sub(a, b, "SafeMath: subtraction overflow");
764     }
765 
766     /**
767      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
768      * overflow (when the result is negative).
769      *
770      * Counterpart to Solidity's `-` operator.
771      *
772      * Requirements:
773      *
774      * - Subtraction cannot overflow.
775      */
776     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
777         require(b <= a, errorMessage);
778         uint256 c = a - b;
779 
780         return c;
781     }
782 
783     /**
784      * @dev Returns the multiplication of two unsigned integers, reverting on
785      * overflow.
786      *
787      * Counterpart to Solidity's `*` operator.
788      *
789      * Requirements:
790      *
791      * - Multiplication cannot overflow.
792      */
793     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
794         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
795         // benefit is lost if 'b' is also tested.
796         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
797         if (a == 0) {
798             return 0;
799         }
800 
801         uint256 c = a * b;
802         require(c / a == b, "SafeMath: multiplication overflow");
803 
804         return c;
805     }
806 
807     /**
808      * @dev Returns the integer division of two unsigned integers. Reverts on
809      * division by zero. The result is rounded towards zero.
810      *
811      * Counterpart to Solidity's `/` operator. Note: this function uses a
812      * `revert` opcode (which leaves remaining gas untouched) while Solidity
813      * uses an invalid opcode to revert (consuming all remaining gas).
814      *
815      * Requirements:
816      *
817      * - The divisor cannot be zero.
818      */
819     function div(uint256 a, uint256 b) internal pure returns (uint256) {
820         return div(a, b, "SafeMath: division by zero");
821     }
822 
823     /**
824      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
825      * division by zero. The result is rounded towards zero.
826      *
827      * Counterpart to Solidity's `/` operator. Note: this function uses a
828      * `revert` opcode (which leaves remaining gas untouched) while Solidity
829      * uses an invalid opcode to revert (consuming all remaining gas).
830      *
831      * Requirements:
832      *
833      * - The divisor cannot be zero.
834      */
835     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
836         require(b > 0, errorMessage);
837         uint256 c = a / b;
838         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
839 
840         return c;
841     }
842 
843     /**
844      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
845      * Reverts when dividing by zero.
846      *
847      * Counterpart to Solidity's `%` operator. This function uses a `revert`
848      * opcode (which leaves remaining gas untouched) while Solidity uses an
849      * invalid opcode to revert (consuming all remaining gas).
850      *
851      * Requirements:
852      *
853      * - The divisor cannot be zero.
854      */
855     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
856         return mod(a, b, "SafeMath: modulo by zero");
857     }
858 
859     /**
860      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
861      * Reverts with custom message when dividing by zero.
862      *
863      * Counterpart to Solidity's `%` operator. This function uses a `revert`
864      * opcode (which leaves remaining gas untouched) while Solidity uses an
865      * invalid opcode to revert (consuming all remaining gas).
866      *
867      * Requirements:
868      *
869      * - The divisor cannot be zero.
870      */
871     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
872         require(b != 0, errorMessage);
873         return a % b;
874     }
875 
876     function per(uint256 a, uint256 base, uint256 percent) internal pure returns (uint256) {
877         return div(mul(a,percent),base);
878     }
879 }
880 
881 
882 
883 /**
884  * @title SafeERC20
885  * @dev Wrappers around ERC20 operations that throw on failure (when the token
886  * contract returns false). Tokens that return no value (and instead revert or
887  * throw on failure) are also supported, non-reverting calls are assumed to be
888  * successful.
889  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
890  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
891  */
892 library SafeERC20 {
893     using SafeMath for uint256;
894     using Address for address;
895 
896     function safeTransfer(IERC20 token, address to, uint256 value) internal {
897         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
898     }
899 
900     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
901         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
902     }
903 
904     /**
905      * @dev Deprecated. This function has issues similar to the ones found in
906      * {IERC20-approve}, and its usage is discouraged.
907      *
908      * Whenever possible, use {safeIncreaseAllowance} and
909      * {safeDecreaseAllowance} instead.
910      */
911     function safeApprove(IERC20 token, address spender, uint256 value) internal {
912         // safeApprove should only be called when setting an initial allowance,
913         // or when resetting it to zero. To increase and decrease it, use
914         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
915         // solhint-disable-next-line max-line-length
916         require((value == 0) || (token.allowance(address(this), spender) == 0),
917             "SafeERC20: approve from non-zero to non-zero allowance"
918         );
919         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
920     }
921 
922     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
923         uint256 newAllowance = token.allowance(address(this), spender).add(value);
924         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
925     }
926 
927     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
928         uint256 newAllowance = token.allowance(address(this), spender).sub(value, "SafeERC20: decreased allowance below zero");
929         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
930     }
931 
932     /**
933      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
934      * on the return value: the return value is optional (but if data is returned, it must not be false).
935      * @param token The token targeted by the call.
936      * @param data The call data (encoded using abi.encode or one of its variants).
937      */
938     function _callOptionalReturn(IERC20 token, bytes memory data) private {
939         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
940         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
941         // the target address contains contract code and also asserts for success in the low-level call.
942 
943         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
944         if (returndata.length > 0) { // Return data is optional
945             // solhint-disable-next-line max-line-length
946             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
947         }
948     }
949 }
950 
951 // SPDX-License-Identifier: MIT
952 
953 
954 
955 /**
956  * @dev Contract module that helps prevent reentrant calls to a function.
957  *
958  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
959  * available, which can be applied to functions to make sure there are no nested
960  * (reentrant) calls to them.
961  *
962  * Note that because there is a single `nonReentrant` guard, functions marked as
963  * `nonReentrant` may not call one another. This can be worked around by making
964  * those functions `private`, and then adding `external` `nonReentrant` entry
965  * points to them.
966  *
967  * TIP: If you would like to learn more about reentrancy and alternative ways
968  * to protect against it, check out our blog post
969  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
970  */
971 contract ReentrancyGuard {
972     // Booleans are more expensive than uint256 or any type that takes up a full
973     // word because each write operation emits an extra SLOAD to first read the
974     // slot's contents, replace the bits taken up by the boolean, and then write
975     // back. This is the compiler's defense against contract upgrades and
976     // pointer aliasing, and it cannot be disabled.
977 
978     // The values being non-zero value makes deployment a bit more expensive,
979     // but in exchange the refund on every call to nonReentrant will be lower in
980     // amount. Since refunds are capped to a percentage of the total
981     // transaction's gas, it is best to keep them low in cases like this one, to
982     // increase the likelihood of the full refund coming into effect.
983     uint256 private constant _NOT_ENTERED = 1;
984     uint256 private constant _ENTERED = 2;
985 
986     uint256 private _status;
987 
988     constructor () internal {
989         _status = _NOT_ENTERED;
990     }
991 
992     /**
993      * @dev Prevents a contract from calling itself, directly or indirectly.
994      * Calling a `nonReentrant` function from another `nonReentrant`
995      * function is not supported. It is possible to prevent this from happening
996      * by making the `nonReentrant` function external, and make it call a
997      * `private` function that does the actual work.
998      */
999     modifier nonReentrant() {
1000         // On the first call to nonReentrant, _notEntered will be true
1001         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1002 
1003         // Any calls to nonReentrant after this point will fail
1004         _status = _ENTERED;
1005 
1006         _;
1007 
1008         // By storing the original value once again, a refund is triggered (see
1009         // https://eips.ethereum.org/EIPS/eip-2200)
1010         _status = _NOT_ENTERED;
1011     }
1012 }
1013 
1014 
1015 
1016 contract DeFi is IUpgradable, IDeFi, IERC777Recipient, ReentrancyGuard {
1017     using SafeERC20 for IERC20;
1018 
1019     bytes32 internal constant TOKENS_RECIPIENT_INTERFACE_HASH = keccak256(
1020         "ERC777TokensRecipient"
1021     );
1022     IERC1820Registry internal ERC1820 = IERC1820Registry(
1023         0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24
1024     );
1025     IDeFiStorage _fs;
1026     IDeFiLogic _dl;
1027 
1028     constructor() public {
1029         ERC1820.setInterfaceImplementer(
1030             address(this),
1031             TOKENS_RECIPIENT_INTERFACE_HASH,
1032             address(this)
1033         );
1034     }
1035 
1036     /// fallback
1037     function tokensReceived(
1038         address operator,
1039         address from,
1040         address to,
1041         uint256 amount,
1042         bytes memory userData,
1043         bytes memory operatorData
1044     ) public override {
1045         _dl.onTokenReceived(
1046             msg.sender,
1047             operator,
1048             from,
1049             to,
1050             amount,
1051             userData,
1052             operatorData
1053         );
1054     }
1055 
1056     /// public functions
1057     function getOriginalAccountQuota()
1058         public
1059         view
1060         returns (
1061             uint256,
1062             uint256,
1063             uint256
1064         )
1065     {
1066         return _dl.getOriginalAccountQuota();
1067     }
1068 
1069     function register(bytes32 inviteCode, bool purchaseOriginAccount)
1070         public
1071         payable
1072     {
1073         _dl.register(msg.sender, msg.value, inviteCode, purchaseOriginAccount);
1074     }
1075 
1076     function claimROI() public {
1077         _dl.claimROI(msg.sender);
1078     }
1079 
1080     function deposit(uint256 poolID, uint256 tokenAmt) public {
1081         IERC20(_fs.getToken()).safeTransferFrom(
1082             msg.sender,
1083             address(this),
1084             tokenAmt
1085         );
1086         _dl.deposit(msg.sender, poolID, tokenAmt);
1087     }
1088 
1089     function sendToken(address to, uint256 amt)
1090         public
1091         override
1092         onlyInternal
1093         nonReentrant
1094     {
1095         IERC20(_fs.getToken()).safeTransfer(to, amt);
1096     }
1097 
1098     function sendETH(address payable to, uint256 amt)
1099         public
1100         override
1101         onlyInternal
1102         nonReentrant
1103     {
1104         to.transfer(amt);
1105     }
1106 
1107     /// implements functions
1108     function changeDependentContractAddress() public override {
1109         _fs = IDeFiStorage(master.getLatestAddress("FS"));
1110         _dl = IDeFiLogic(master.getLatestAddress("DL"));
1111     }
1112 }