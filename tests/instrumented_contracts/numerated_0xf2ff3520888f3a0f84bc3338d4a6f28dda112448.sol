1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-03
3 */
4 
5 pragma experimental ABIEncoderV2;
6 // File: contracts/modules/common/Utils.sol
7 // Copyright (C) 2020  Argent Labs Ltd. <https://argent.xyz>
8 // This program is free software: you can redistribute it and/or modify
9 // it under the terms of the GNU General Public License as published by
10 // the Free Software Foundation, either version 3 of the License, or
11 // (at your option) any later version.
12 // This program is distributed in the hope that it will be useful,
13 // but WITHOUT ANY WARRANTY; without even the implied warranty of
14 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
15 // GNU General Public License for more details.
16 // You should have received a copy of the GNU General Public License
17 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
18 // SPDX-License-Identifier: GPL-3.0-only
19 /**
20  * @title Utils
21  * @notice Common utility methods used by modules.
22  */
23 library Utils {
24     /**
25     * @notice Helper method to recover the signer at a given position from a list of concatenated signatures.
26     * @param _signedHash The signed hash
27     * @param _signatures The concatenated signatures.
28     * @param _index The index of the signature to recover.
29     */
30     function recoverSigner(bytes32 _signedHash, bytes memory _signatures, uint _index) internal pure returns (address) {
31         uint8 v;
32         bytes32 r;
33         bytes32 s;
34         // we jump 32 (0x20) as the first slot of bytes contains the length
35         // we jump 65 (0x41) per signature
36         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
37         // solhint-disable-next-line no-inline-assembly
38         assembly {
39             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
40             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
41             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
42         }
43         require(v == 27 || v == 28);
44         address recoveredAddress = ecrecover(_signedHash, v, r, s);
45         require(recoveredAddress != address(0), "Utils: ecrecover returned 0");
46         return recoveredAddress;
47     }
48     /**
49     * @notice Helper method to parse data and extract the method signature.
50     */
51     function functionPrefix(bytes memory _data) internal pure returns (bytes4 prefix) {
52         require(_data.length >= 4, "RM: Invalid functionPrefix");
53         // solhint-disable-next-line no-inline-assembly
54         assembly {
55             prefix := mload(add(_data, 0x20))
56         }
57     }
58     /**
59     * @notice Returns ceil(a / b).
60     */
61     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
62         uint256 c = a / b;
63         if (a % b == 0) {
64             return c;
65         } else {
66             return c + 1;
67         }
68     }
69     function min(uint256 a, uint256 b) internal pure returns (uint256) {
70         if (a < b) {
71             return a;
72         }
73         return b;
74     }
75 }
76 // File: @openzeppelin/contracts/math/SafeMath.sol
77 /**
78  * @dev Wrappers over Solidity's arithmetic operations with added overflow
79  * checks.
80  *
81  * Arithmetic operations in Solidity wrap on overflow. This can easily result
82  * in bugs, because programmers usually assume that an overflow raises an
83  * error, which is the standard behavior in high level programming languages.
84  * `SafeMath` restores this intuition by reverting the transaction when an
85  * operation overflows.
86  *
87  * Using this library instead of the unchecked operations eliminates an entire
88  * class of bugs, so it's recommended to use it always.
89  */
90 library SafeMath {
91     /**
92      * @dev Returns the addition of two unsigned integers, reverting on
93      * overflow.
94      *
95      * Counterpart to Solidity's `+` operator.
96      *
97      * Requirements:
98      * - Addition cannot overflow.
99      */
100     function add(uint256 a, uint256 b) internal pure returns (uint256) {
101         uint256 c = a + b;
102         require(c >= a, "SafeMath: addition overflow");
103         return c;
104     }
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      * - Subtraction cannot overflow.
113      */
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         return sub(a, b, "SafeMath: subtraction overflow");
116     }
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
127         require(b <= a, errorMessage);
128         uint256 c = a - b;
129         return c;
130     }
131     /**
132      * @dev Returns the multiplication of two unsigned integers, reverting on
133      * overflow.
134      *
135      * Counterpart to Solidity's `*` operator.
136      *
137      * Requirements:
138      * - Multiplication cannot overflow.
139      */
140     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
141         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
142         // benefit is lost if 'b' is also tested.
143         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
144         if (a == 0) {
145             return 0;
146         }
147         uint256 c = a * b;
148         require(c / a == b, "SafeMath: multiplication overflow");
149         return c;
150     }
151     /**
152      * @dev Returns the integer division of two unsigned integers. Reverts on
153      * division by zero. The result is rounded towards zero.
154      *
155      * Counterpart to Solidity's `/` operator. Note: this function uses a
156      * `revert` opcode (which leaves remaining gas untouched) while Solidity
157      * uses an invalid opcode to revert (consuming all remaining gas).
158      *
159      * Requirements:
160      * - The divisor cannot be zero.
161      */
162     function div(uint256 a, uint256 b) internal pure returns (uint256) {
163         return div(a, b, "SafeMath: division by zero");
164     }
165     /**
166      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
167      * division by zero. The result is rounded towards zero.
168      *
169      * Counterpart to Solidity's `/` operator. Note: this function uses a
170      * `revert` opcode (which leaves remaining gas untouched) while Solidity
171      * uses an invalid opcode to revert (consuming all remaining gas).
172      *
173      * Requirements:
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
177         // Solidity only automatically asserts when dividing by 0
178         require(b > 0, errorMessage);
179         uint256 c = a / b;
180         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
181         return c;
182     }
183     /**
184      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
185      * Reverts when dividing by zero.
186      *
187      * Counterpart to Solidity's `%` operator. This function uses a `revert`
188      * opcode (which leaves remaining gas untouched) while Solidity uses an
189      * invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      * - The divisor cannot be zero.
193      */
194     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
195         return mod(a, b, "SafeMath: modulo by zero");
196     }
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * Reverts with custom message when dividing by zero.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
209         require(b != 0, errorMessage);
210         return a % b;
211     }
212 }
213 pragma solidity >=0.5.4 <0.7.0;
214 /**
215  * @title IWallet
216  * @notice Interface for the BaseWallet
217  */
218 interface IWallet {
219     /**
220      * @notice Returns the wallet owner.
221      * @return The wallet owner address.
222      */
223     function owner() external view returns (address);
224     /**
225      * @notice Returns the number of authorised modules.
226      * @return The number of authorised modules.
227      */
228     function modules() external view returns (uint);
229     /**
230      * @notice Sets a new owner for the wallet.
231      * @param _newOwner The new owner.
232      */
233     function setOwner(address _newOwner) external;
234     /**
235      * @notice Checks if a module is authorised on the wallet.
236      * @param _module The module address to check.
237      * @return `true` if the module is authorised, otherwise `false`.
238      */
239     function authorised(address _module) external view returns (bool);
240     /**
241      * @notice Returns the module responsible for a static call redirection.
242      * @param _sig The signature of the static call.
243      * @return the module doing the redirection
244      */
245     function enabled(bytes4 _sig) external view returns (address);
246     /**
247      * @notice Enables/Disables a module.
248      * @param _module The target module.
249      * @param _value Set to `true` to authorise the module.
250      */
251     function authoriseModule(address _module, bool _value) external;
252     /**
253     * @notice Enables a static method by specifying the target module to which the call must be delegated.
254     * @param _module The target module.
255     * @param _method The static method signature.
256     */
257     function enableStaticCall(address _module, bytes4 _method) external;
258 }
259 pragma solidity >=0.5.4 <0.7.0;
260 /**
261  * @title IModuleRegistry
262  * @notice Interface for the registry of authorised modules.
263  */
264 interface IModuleRegistry {
265     function registerModule(address _module, bytes32 _name) external;
266     function deregisterModule(address _module) external;
267     function registerUpgrader(address _upgrader, bytes32 _name) external;
268     function deregisterUpgrader(address _upgrader) external;
269     function recoverToken(address _token) external;
270     function moduleInfo(address _module) external view returns (bytes32);
271     function upgraderInfo(address _upgrader) external view returns (bytes32);
272     function isRegisteredModule(address _module) external view returns (bool);
273     function isRegisteredModule(address[] calldata _modules) external view returns (bool);
274     function isRegisteredUpgrader(address _upgrader) external view returns (bool);
275 }
276 pragma solidity >=0.5.4 <0.7.0;
277 interface ILockStorage {
278     function isLocked(address _wallet) external view returns (bool);
279     function getLock(address _wallet) external view returns (uint256);
280     function getLocker(address _wallet) external view returns (address);
281     function setLock(address _wallet, address _locker, uint256 _releaseAfter) external;
282 }
283 pragma solidity >=0.5.4 <0.7.0;
284 /**
285  * @title IFeature
286  * @notice Interface for a Feature.
287  * @author Julien Niset - <julien@argent.xyz>, Olivier VDB - <olivier@argent.xyz>
288  */
289 interface IFeature {
290     enum OwnerSignature {
291         Anyone,             // Anyone
292         Required,           // Owner required
293         Optional,           // Owner and/or guardians
294         Disallowed          // guardians only
295     }
296     /**
297     * @notice Utility method to recover any ERC20 token that was sent to the Feature by mistake.
298     * @param _token The token to recover.
299     */
300     function recoverToken(address _token) external;
301     /**
302      * @notice Inits a Feature for a wallet by e.g. setting some wallet specific parameters in storage.
303      * @param _wallet The wallet.
304      */
305     function init(address _wallet) external;
306     /**
307      * @notice Helper method to check if an address is an authorised feature of a target wallet.
308      * @param _wallet The target wallet.
309      * @param _feature The address.
310      */
311     function isFeatureAuthorisedInVersionManager(address _wallet, address _feature) external view returns (bool);
312     /**
313     * @notice Gets the number of valid signatures that must be provided to execute a
314     * specific relayed transaction.
315     * @param _wallet The target wallet.
316     * @param _data The data of the relayed transaction.
317     * @return The number of required signatures and the wallet owner signature requirement.
318     */
319     function getRequiredSignatures(address _wallet, bytes calldata _data) external view returns (uint256, OwnerSignature);
320     /**
321     * @notice Gets the list of static call signatures that this feature responds to on behalf of wallets
322     */
323     function getStaticCallSignatures() external view returns (bytes4[] memory);
324 }
325 // File: lib/other/ERC20.sol
326 pragma solidity >=0.5.4 <0.7.0;
327 /**
328  * ERC20 contract interface.
329  */
330 interface ERC20 {
331     function totalSupply() external view returns (uint);
332     function decimals() external view returns (uint);
333     function balanceOf(address tokenOwner) external view returns (uint balance);
334     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
335     function transfer(address to, uint tokens) external returns (bool success);
336     function approve(address spender, uint tokens) external returns (bool success);
337     function transferFrom(address from, address to, uint tokens) external returns (bool success);
338 }
339 /**
340  * @title ILimitStorage
341  * @notice LimitStorage interface
342  */
343 interface ILimitStorage {
344     struct Limit {
345         // the current limit
346         uint128 current;
347         // the pending limit if any
348         uint128 pending;
349         // when the pending limit becomes the current limit
350         uint64 changeAfter;
351     }
352     struct DailySpent {
353         // The amount already spent during the current period
354         uint128 alreadySpent;
355         // The end of the current period
356         uint64 periodEnd;
357     }
358     function setLimit(address _wallet, Limit memory _limit) external;
359     function getLimit(address _wallet) external view returns (Limit memory _limit);
360     function setDailySpent(address _wallet, DailySpent memory _dailySpent) external;
361     function getDailySpent(address _wallet) external view returns (DailySpent memory _dailySpent);
362     function setLimitAndDailySpent(address _wallet, Limit memory _limit, DailySpent memory _dailySpent) external;
363     function getLimitAndDailySpent(address _wallet) external view returns (Limit memory _limit, DailySpent memory _dailySpent);
364 }
365 pragma solidity >=0.5.4 <0.7.0;
366 /**
367  * @title IVersionManager
368  * @notice Interface for the VersionManager module.
369  * @author Olivier VDB - <olivier@argent.xyz>
370  */
371 interface IVersionManager {
372     /**
373      * @notice Returns true if the feature is authorised for the wallet
374      * @param _wallet The target wallet.
375      * @param _feature The feature.
376      */
377     function isFeatureAuthorised(address _wallet, address _feature) external view returns (bool);
378     /**
379      * @notice Lets a feature (caller) invoke a wallet.
380      * @param _wallet The target wallet.
381      * @param _to The target address for the transaction.
382      * @param _value The value of the transaction.
383      * @param _data The data of the transaction.
384      */
385     function checkAuthorisedFeatureAndInvokeWallet(
386         address _wallet,
387         address _to,
388         uint256 _value,
389         bytes calldata _data
390     ) external returns (bytes memory _res);
391     /* ******* Backward Compatibility with old Storages and BaseWallet *************** */
392     /**
393      * @notice Sets a new owner for the wallet.
394      * @param _newOwner The new owner.
395      */
396     function setOwner(address _wallet, address _newOwner) external;
397     /**
398      * @notice Lets a feature write data to a storage contract.
399      * @param _wallet The target wallet.
400      * @param _storage The storage contract.
401      * @param _data The data of the call
402      */
403     function invokeStorage(address _wallet, address _storage, bytes calldata _data) external;
404     /**
405      * @notice Upgrade a wallet to a new version.
406      * @param _wallet the wallet to upgrade
407      * @param _toVersion the new version
408      */
409     function upgradeWallet(address _wallet, uint256 _toVersion) external;
410 }
411 /**
412  * @title BaseFeature
413  * @notice Base Feature contract that contains methods common to all Feature contracts.
414  * @author Julien Niset - <julien@argent.xyz>, Olivier VDB - <olivier@argent.xyz>
415  */
416 contract BaseFeature is IFeature {
417     // Empty calldata
418     bytes constant internal EMPTY_BYTES = "";
419     // Mock token address for ETH
420     address constant internal ETH_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
421     // The address of the Lock storage
422     ILockStorage internal lockStorage;
423     // The address of the Version Manager
424     IVersionManager internal versionManager;
425     event FeatureCreated(bytes32 name);
426     /**
427      * @notice Throws if the wallet is locked.
428      */
429     modifier onlyWhenUnlocked(address _wallet) {
430         require(!lockStorage.isLocked(_wallet), "BF: wallet locked");
431         _;
432     }
433     /**
434      * @notice Throws if the sender is not the VersionManager.
435      */
436     modifier onlyVersionManager() {
437         require(msg.sender == address(versionManager), "BF: caller must be VersionManager");
438         _;
439     }
440     /**
441      * @notice Throws if the sender is not the owner of the target wallet.
442      */
443     modifier onlyWalletOwner(address _wallet) {
444         require(isOwner(_wallet, msg.sender), "BF: must be wallet owner");
445         _;
446     }
447     /**
448      * @notice Throws if the sender is not an authorised feature of the target wallet.
449      */
450     modifier onlyWalletFeature(address _wallet) {
451         require(versionManager.isFeatureAuthorised(_wallet, msg.sender), "BF: must be a wallet feature");
452         _;
453     }
454     /**
455      * @notice Throws if the sender is not the owner of the target wallet or the feature itself.
456      */
457     modifier onlyWalletOwnerOrFeature(address _wallet) {
458         // Wrapping in an internal method reduces deployment cost by avoiding duplication of inlined code
459         verifyOwnerOrAuthorisedFeature(_wallet, msg.sender);
460         _;
461     }
462     constructor(
463         ILockStorage _lockStorage,
464         IVersionManager _versionManager,
465         bytes32 _name
466     ) public {
467         lockStorage = _lockStorage;
468         versionManager = _versionManager;
469         emit FeatureCreated(_name);
470     }
471     /**
472     * @inheritdoc IFeature
473     */
474     function recoverToken(address _token) external virtual override {
475         uint total = ERC20(_token).balanceOf(address(this));
476         _token.call(abi.encodeWithSelector(ERC20(_token).transfer.selector, address(versionManager), total));
477     }
478     /**
479      * @notice Inits the feature for a wallet by doing nothing.
480      * @dev !! Overriding methods need make sure `init()` can only be called by the VersionManager !!
481      * @param _wallet The wallet.
482      */
483     function init(address _wallet) external virtual override  {}
484     /**
485      * @inheritdoc IFeature
486      */
487     function getRequiredSignatures(address, bytes calldata) external virtual view override returns (uint256, OwnerSignature) {
488         revert("BF: disabled method");
489     }
490     /**
491      * @inheritdoc IFeature
492      */
493     function getStaticCallSignatures() external virtual override view returns (bytes4[] memory _sigs) {}
494     /**
495      * @inheritdoc IFeature
496      */
497     function isFeatureAuthorisedInVersionManager(address _wallet, address _feature) public override view returns (bool) {
498         return versionManager.isFeatureAuthorised(_wallet, _feature);
499     }
500     /**
501     * @notice Checks that the wallet address provided as the first parameter of _data matches _wallet
502     * @return false if the addresses are different.
503     */
504     function verifyData(address _wallet, bytes calldata _data) internal pure returns (bool) {
505         require(_data.length >= 36, "RM: Invalid dataWallet");
506         address dataWallet = abi.decode(_data[4:], (address));
507         return dataWallet == _wallet;
508     }
509      /**
510      * @notice Helper method to check if an address is the owner of a target wallet.
511      * @param _wallet The target wallet.
512      * @param _addr The address.
513      */
514     function isOwner(address _wallet, address _addr) internal view returns (bool) {
515         return IWallet(_wallet).owner() == _addr;
516     }
517     /**
518      * @notice Verify that the caller is an authorised feature or the wallet owner.
519      * @param _wallet The target wallet.
520      * @param _sender The caller.
521      */
522     function verifyOwnerOrAuthorisedFeature(address _wallet, address _sender) internal view {
523         require(isFeatureAuthorisedInVersionManager(_wallet, _sender) || isOwner(_wallet, _sender), "BF: must be owner or feature");
524     }
525     /**
526      * @notice Helper method to invoke a wallet.
527      * @param _wallet The target wallet.
528      * @param _to The target address for the transaction.
529      * @param _value The value of the transaction.
530      * @param _data The data of the transaction.
531      */
532     function invokeWallet(address _wallet, address _to, uint256 _value, bytes memory _data)
533         internal
534         returns (bytes memory _res) 
535     {
536         _res = versionManager.checkAuthorisedFeatureAndInvokeWallet(_wallet, _to, _value, _data);
537     }
538 }
539 /**
540  * @title GuardianUtils
541  * @notice Bundles guardian read logic.
542  */
543 library GuardianUtils {
544     /**
545     * @notice Checks if an address is a guardian or an account authorised to sign on behalf of a smart-contract guardian
546     * given a list of guardians.
547     * @param _guardians the list of guardians
548     * @param _guardian the address to test
549     * @return true and the list of guardians minus the found guardian upon success, false and the original list of guardians if not found.
550     */
551     function isGuardianOrGuardianSigner(address[] memory _guardians, address _guardian) internal view returns (bool, address[] memory) {
552         if (_guardians.length == 0 || _guardian == address(0)) {
553             return (false, _guardians);
554         }
555         bool isFound = false;
556         address[] memory updatedGuardians = new address[](_guardians.length - 1);
557         uint256 index = 0;
558         for (uint256 i = 0; i < _guardians.length; i++) {
559             if (!isFound) {
560                 // check if _guardian is an account guardian
561                 if (_guardian == _guardians[i]) {
562                     isFound = true;
563                     continue;
564                 }
565                 // check if _guardian is the owner of a smart contract guardian
566                 if (isContract(_guardians[i]) && isGuardianOwner(_guardians[i], _guardian)) {
567                     isFound = true;
568                     continue;
569                 }
570             }
571             if (index < updatedGuardians.length) {
572                 updatedGuardians[index] = _guardians[i];
573                 index++;
574             }
575         }
576         return isFound ? (true, updatedGuardians) : (false, _guardians);
577     }
578    /**
579     * @notice Checks if an address is a contract.
580     * @param _addr The address.
581     */
582     function isContract(address _addr) internal view returns (bool) {
583         uint32 size;
584         // solhint-disable-next-line no-inline-assembly
585         assembly {
586             size := extcodesize(_addr)
587         }
588         return (size > 0);
589     }
590     /**
591     * @notice Checks if an address is the owner of a guardian contract.
592     * The method does not revert if the call to the owner() method consumes more then 5000 gas.
593     * @param _guardian The guardian contract
594     * @param _owner The owner to verify.
595     */
596     function isGuardianOwner(address _guardian, address _owner) internal view returns (bool) {
597         address owner = address(0);
598         bytes4 sig = bytes4(keccak256("owner()"));
599         // solhint-disable-next-line no-inline-assembly
600         assembly {
601             let ptr := mload(0x40)
602             mstore(ptr,sig)
603             let result := staticcall(5000, _guardian, ptr, 0x20, ptr, 0x20)
604             if eq(result, 1) {
605                 owner := mload(ptr)
606             }
607         }
608         return owner == _owner;
609     }
610 }
611 /**
612  * @title ITokenPriceRegistry
613  * @notice TokenPriceRegistry interface
614  */
615 interface ITokenPriceRegistry {
616     function getTokenPrice(address _token) external view returns (uint184 _price);
617     function isTokenTradable(address _token) external view returns (bool _isTradable);
618 }
619 /**
620  * @title LimitUtils
621  * @notice Helper library to manage the daily limit and interact with a contract implementing the ILimitStorage interface.
622  * @author Julien Niset - <julien@argent.xyz>
623  */
624 library LimitUtils {
625     // large limit when the limit can be considered disabled
626     uint128 constant internal LIMIT_DISABLED = uint128(-1);
627     using SafeMath for uint256;
628     // *************** Internal Functions ********************* //
629     /**
630      * @notice Changes the daily limit (expressed in ETH).
631      * Decreasing the limit is immediate while increasing the limit is pending for the security period.
632      * @param _lStorage The storage contract.
633      * @param _versionManager The version manager.
634      * @param _wallet The target wallet.
635      * @param _targetLimit The target limit.
636      * @param _securityPeriod The security period.
637      */
638     function changeLimit(
639         ILimitStorage _lStorage,
640         IVersionManager _versionManager,
641         address _wallet,
642         uint256 _targetLimit,
643         uint256 _securityPeriod
644     )
645         internal
646         returns (ILimitStorage.Limit memory)
647     {
648         ILimitStorage.Limit memory limit = _lStorage.getLimit(_wallet);
649         uint256 currentLimit = currentLimit(limit);
650         ILimitStorage.Limit memory newLimit;
651         if (_targetLimit <= currentLimit) {
652             uint128 targetLimit = safe128(_targetLimit);
653             newLimit = ILimitStorage.Limit(targetLimit, targetLimit, safe64(block.timestamp));
654         } else {
655             newLimit = ILimitStorage.Limit(safe128(currentLimit), safe128(_targetLimit), safe64(block.timestamp.add(_securityPeriod)));
656         }
657         setLimit(_versionManager, _lStorage, _wallet, newLimit);
658         return newLimit;
659     }
660      /**
661      * @notice Disable the daily limit.
662      * The change is pending for the security period.
663      * @param _lStorage The storage contract.
664      * @param _versionManager The version manager.
665      * @param _wallet The target wallet.
666      * @param _securityPeriod The security period.
667      */
668     function disableLimit(
669         ILimitStorage _lStorage,
670         IVersionManager _versionManager,
671         address _wallet,
672         uint256 _securityPeriod
673     )
674         internal
675     {
676         changeLimit(_lStorage, _versionManager, _wallet, LIMIT_DISABLED, _securityPeriod);
677     }
678     /**
679     * @notice Returns whether the daily limit is disabled for a wallet.
680     * @param _wallet The target wallet.
681     * @return _limitDisabled true if the daily limit is disabled, false otherwise.
682     */
683     function isLimitDisabled(ILimitStorage _lStorage, address _wallet) internal view returns (bool) {
684         ILimitStorage.Limit memory limit = _lStorage.getLimit(_wallet);
685         uint256 currentLimit = currentLimit(limit);
686         return (currentLimit == LIMIT_DISABLED);
687     }
688     /**
689     * @notice Checks if a transfer is within the limit. If yes the daily spent is updated.
690     * @param _lStorage The storage contract.
691     * @param _versionManager The Version Manager.
692     * @param _wallet The target wallet.
693     * @param _amount The amount for the transfer
694     * @return true if the transfer is withing the daily limit.
695     */
696     function checkAndUpdateDailySpent(
697         ILimitStorage _lStorage,
698         IVersionManager _versionManager,
699         address _wallet,
700         uint256 _amount
701     )
702         internal
703         returns (bool)
704     {
705         (ILimitStorage.Limit memory limit, ILimitStorage.DailySpent memory dailySpent) = _lStorage.getLimitAndDailySpent(_wallet);
706         uint256 currentLimit = currentLimit(limit);
707         if (_amount == 0 || currentLimit == LIMIT_DISABLED) {
708             return true;
709         }
710         ILimitStorage.DailySpent memory newDailySpent;
711         if (dailySpent.periodEnd <= block.timestamp && _amount <= currentLimit) {
712             newDailySpent = ILimitStorage.DailySpent(safe128(_amount), safe64(block.timestamp + 24 hours));
713             setDailySpent(_versionManager, _lStorage, _wallet, newDailySpent);
714             return true;
715         } else if (dailySpent.periodEnd > block.timestamp && _amount.add(dailySpent.alreadySpent) <= currentLimit) {
716             newDailySpent = ILimitStorage.DailySpent(safe128(_amount.add(dailySpent.alreadySpent)), safe64(dailySpent.periodEnd));
717             setDailySpent(_versionManager, _lStorage, _wallet, newDailySpent);
718             return true;
719         }
720         return false;
721     }
722     /**
723     * @notice Helper method to Reset the daily consumption.
724     * @param _versionManager The Version Manager.
725     * @param _wallet The target wallet.
726     */
727     function resetDailySpent(IVersionManager _versionManager, ILimitStorage limitStorage, address _wallet) internal {
728         setDailySpent(_versionManager, limitStorage, _wallet, ILimitStorage.DailySpent(uint128(0), uint64(0)));
729     }
730     /**
731     * @notice Helper method to get the ether value equivalent of a token amount.
732     * @notice For low value amounts of tokens we accept this to return zero as these are small enough to disregard.
733     * Note that the price stored for tokens = price for 1 token (in ETH wei) * 10^(18-token decimals).
734     * @param _amount The token amount.
735     * @param _token The address of the token.
736     * @return The ether value for _amount of _token.
737     */
738     function getEtherValue(ITokenPriceRegistry _priceRegistry, uint256 _amount, address _token) internal view returns (uint256) {
739         uint256 price = _priceRegistry.getTokenPrice(_token);
740         uint256 etherValue = price.mul(_amount).div(10**18);
741         return etherValue;
742     }
743     /**
744     * @notice Helper method to get the current limit from a Limit struct.
745     * @param _limit The limit struct
746     */
747     function currentLimit(ILimitStorage.Limit memory _limit) internal view returns (uint256) {
748         if (_limit.changeAfter > 0 && _limit.changeAfter < block.timestamp) {
749             return _limit.pending;
750         }
751         return _limit.current;
752     }
753     function safe128(uint256 _num) internal pure returns (uint128) {
754         require(_num < 2**128, "LU: more then 128 bits");
755         return uint128(_num);
756     }
757     function safe64(uint256 _num) internal pure returns (uint64) {
758         require(_num < 2**64, "LU: more then 64 bits");
759         return uint64(_num);
760     }
761     // *************** Storage invocations in VersionManager ********************* //
762     function setLimit(
763         IVersionManager _versionManager,
764         ILimitStorage _lStorage,
765         address _wallet, 
766         ILimitStorage.Limit memory _limit
767     ) internal {
768         _versionManager.invokeStorage(
769             _wallet,
770             address(_lStorage),
771             abi.encodeWithSelector(_lStorage.setLimit.selector, _wallet, _limit)
772         );
773     }
774     function setDailySpent(
775         IVersionManager _versionManager,
776         ILimitStorage _lStorage,
777         address _wallet, 
778         ILimitStorage.DailySpent memory _dailySpent
779     ) private {
780         _versionManager.invokeStorage(
781             _wallet,
782             address(_lStorage),
783             abi.encodeWithSelector(_lStorage.setDailySpent.selector, _wallet, _dailySpent)
784         );
785     }
786 }
787 pragma solidity >=0.5.4 <0.7.0;
788 interface IGuardianStorage {
789     /**
790      * @notice Lets an authorised module add a guardian to a wallet.
791      * @param _wallet The target wallet.
792      * @param _guardian The guardian to add.
793      */
794     function addGuardian(address _wallet, address _guardian) external;
795     /**
796      * @notice Lets an authorised module revoke a guardian from a wallet.
797      * @param _wallet The target wallet.
798      * @param _guardian The guardian to revoke.
799      */
800     function revokeGuardian(address _wallet, address _guardian) external;
801     /**
802      * @notice Checks if an account is a guardian for a wallet.
803      * @param _wallet The target wallet.
804      * @param _guardian The account.
805      * @return true if the account is a guardian for a wallet.
806      */
807     function isGuardian(address _wallet, address _guardian) external view returns (bool);
808     function isLocked(address _wallet) external view returns (bool);
809     function getLock(address _wallet) external view returns (uint256);
810     function getLocker(address _wallet) external view returns (address);
811     function setLock(address _wallet, uint256 _releaseAfter) external;
812     function getGuardians(address _wallet) external view returns (address[] memory);
813     function guardianCount(address _wallet) external view returns (uint256);
814 }
815 /**
816  * @title RelayerManager
817  * @notice Feature to execute transactions signed by ETH-less accounts and sent by a relayer.
818  * @author Julien Niset <julien@argent.xyz>, Olivier VDB <olivier@argent.xyz>
819  */
820 contract RelayerManager is BaseFeature {
821     bytes32 constant NAME = "RelayerManager";
822     uint256 constant internal BLOCKBOUND = 10000;
823     using SafeMath for uint256;
824     mapping (address => RelayerConfig) public relayer;
825     // The storage of the limit
826     ILimitStorage public limitStorage;
827     // The Token price storage
828     ITokenPriceRegistry public tokenPriceRegistry;
829     // The Guardian storage
830     IGuardianStorage public guardianStorage;
831     struct RelayerConfig {
832         uint256 nonce;
833         mapping (bytes32 => bool) executedTx;
834     }
835     // Used to avoid stack too deep error
836     struct StackExtension {
837         uint256 requiredSignatures;
838         OwnerSignature ownerSignatureRequirement;
839         bytes32 signHash;
840         bool success;
841         bytes returnData;
842     }
843     event TransactionExecuted(address indexed wallet, bool indexed success, bytes returnData, bytes32 signedHash);
844     event Refund(address indexed wallet, address indexed refundAddress, address refundToken, uint256 refundAmount);
845     /* ***************** External methods ************************* */
846     constructor(
847         ILockStorage _lockStorage,
848         IGuardianStorage _guardianStorage,
849         ILimitStorage _limitStorage,
850         ITokenPriceRegistry _tokenPriceRegistry,
851         IVersionManager _versionManager
852     )
853         BaseFeature(_lockStorage, _versionManager, NAME)
854         public
855     {
856         limitStorage = _limitStorage;
857         tokenPriceRegistry = _tokenPriceRegistry;
858         guardianStorage = _guardianStorage;
859     }
860     /**
861     * @notice Executes a relayed transaction.
862     * @param _wallet The target wallet.
863     * @param _feature The target feature.
864     * @param _data The data for the relayed transaction
865     * @param _nonce The nonce used to prevent replay attacks.
866     * @param _signatures The signatures as a concatenated byte array.
867     * @param _gasPrice The gas price to use for the gas refund.
868     * @param _gasLimit The gas limit to use for the gas refund.
869     * @param _refundToken The token to use for the gas refund.
870     * @param _refundAddress The address refunded to prevent front-running.
871     */
872     function execute(
873         address _wallet,
874         address _feature,
875         bytes calldata _data,
876         uint256 _nonce,
877         bytes calldata _signatures,
878         uint256 _gasPrice,
879         uint256 _gasLimit,
880         address _refundToken,
881         address _refundAddress
882     )
883         external
884         returns (bool)
885     {
886         uint startGas = gasleft();
887         require(startGas >= _gasLimit, "RM: not enough gas provided");
888         require(verifyData(_wallet, _data), "RM: Target of _data != _wallet");
889         require(isFeatureAuthorisedInVersionManager(_wallet, _feature), "RM: feature not authorised");
890         StackExtension memory stack;
891         (stack.requiredSignatures, stack.ownerSignatureRequirement) = IFeature(_feature).getRequiredSignatures(_wallet, _data);
892         require(stack.requiredSignatures > 0 || stack.ownerSignatureRequirement == OwnerSignature.Anyone, "RM: Wrong signature requirement");
893         require(stack.requiredSignatures * 65 == _signatures.length, "RM: Wrong number of signatures");
894         stack.signHash = getSignHash(
895             address(this),
896             _feature,
897             0,
898             _data,
899             _nonce,
900             _gasPrice,
901             _gasLimit,
902             _refundToken,
903             _refundAddress);
904         require(checkAndUpdateUniqueness(
905             _wallet,
906             _nonce,
907             stack.signHash,
908             stack.requiredSignatures,
909             stack.ownerSignatureRequirement), "RM: Duplicate request");
910         require(validateSignatures(_wallet, stack.signHash, _signatures, stack.ownerSignatureRequirement), "RM: Invalid signatures");
911         (stack.success, stack.returnData) = _feature.call(_data);
912         // only refund when approved by owner and positive gas price
913         if (_gasPrice > 0 && stack.ownerSignatureRequirement == OwnerSignature.Required) {
914             refund(
915                 _wallet,
916                 startGas,
917                 _gasPrice,
918                 _gasLimit,
919                 _refundToken,
920                 _refundAddress,
921                 stack.requiredSignatures);
922         }
923         emit TransactionExecuted(_wallet, stack.success, stack.returnData, stack.signHash);
924         return stack.success;
925     }
926     /**
927     * @notice Gets the current nonce for a wallet.
928     * @param _wallet The target wallet.
929     */
930     function getNonce(address _wallet) external view returns (uint256 nonce) {
931         return relayer[_wallet].nonce;
932     }
933     /**
934     * @notice Checks if a transaction identified by its sign hash has already been executed.
935     * @param _wallet The target wallet.
936     * @param _signHash The sign hash of the transaction.
937     */
938     function isExecutedTx(address _wallet, bytes32 _signHash) external view returns (bool executed) {
939         return relayer[_wallet].executedTx[_signHash];
940     }
941     /* ***************** Internal & Private methods ************************* */
942     /**
943     * @notice Generates the signed hash of a relayed transaction according to ERC 1077.
944     * @param _from The starting address for the relayed transaction (should be the relayer module)
945     * @param _to The destination address for the relayed transaction (should be the target module)
946     * @param _value The value for the relayed transaction.
947     * @param _data The data for the relayed transaction which includes the wallet address.
948     * @param _nonce The nonce used to prevent replay attacks.
949     * @param _gasPrice The gas price to use for the gas refund.
950     * @param _gasLimit The gas limit to use for the gas refund.
951     * @param _refundToken The token to use for the gas refund.
952     * @param _refundAddress The address refunded to prevent front-running.
953     */
954     function getSignHash(
955         address _from,
956         address _to,
957         uint256 _value,
958         bytes memory _data,
959         uint256 _nonce,
960         uint256 _gasPrice,
961         uint256 _gasLimit,
962         address _refundToken,
963         address _refundAddress
964     )
965         internal
966         pure
967         returns (bytes32)
968     {
969         return keccak256(
970             abi.encodePacked(
971                 "\x19Ethereum Signed Message:\n32",
972                 keccak256(abi.encodePacked(
973                     byte(0x19),
974                     byte(0),
975                     _from,
976                     _to,
977                     _value,
978                     _data,
979                     getChainId(),
980                     _nonce,
981                     _gasPrice,
982                     _gasLimit,
983                     _refundToken,
984                     _refundAddress))
985         ));
986     }
987     /**
988     * @notice Checks if the relayed transaction is unique. If yes the state is updated.
989     * For actions requiring 1 signature by the owner we use the incremental nonce.
990     * For all other actions we check/store the signHash in a mapping.
991     * @param _wallet The target wallet.
992     * @param _nonce The nonce.
993     * @param _signHash The signed hash of the transaction.
994     * @param requiredSignatures The number of signatures required.
995     * @param ownerSignatureRequirement The wallet owner signature requirement.
996     * @return true if the transaction is unique.
997     */
998     function checkAndUpdateUniqueness(
999         address _wallet,
1000         uint256 _nonce,
1001         bytes32 _signHash,
1002         uint256 requiredSignatures,
1003         OwnerSignature ownerSignatureRequirement
1004     )
1005         internal
1006         returns (bool)
1007     {
1008         if (requiredSignatures == 1 && ownerSignatureRequirement == OwnerSignature.Required) {
1009             // use the incremental nonce
1010             if (_nonce <= relayer[_wallet].nonce) {
1011                 return false;
1012             }
1013             uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
1014             if (nonceBlock > block.number + BLOCKBOUND) {
1015                 return false;
1016             }
1017             relayer[_wallet].nonce = _nonce;
1018             return true;
1019         } else {
1020             // use the txHash map
1021             if (relayer[_wallet].executedTx[_signHash] == true) {
1022                 return false;
1023             }
1024             relayer[_wallet].executedTx[_signHash] = true;
1025             return true;
1026         }
1027     }
1028     /**
1029     * @notice Validates the signatures provided with a relayed transaction.
1030     * The method MUST throw if one or more signatures are not valid.
1031     * @param _wallet The target wallet.
1032     * @param _signHash The signed hash representing the relayed transaction.
1033     * @param _signatures The signatures as a concatenated byte array.
1034     * @param _option An enum indicating whether the owner is required, optional or disallowed.
1035     * @return A boolean indicating whether the signatures are valid.
1036     */
1037     function validateSignatures(
1038         address _wallet,
1039         bytes32 _signHash,
1040         bytes memory _signatures,
1041         OwnerSignature _option
1042     )
1043         internal
1044         view
1045         returns (bool)
1046     {
1047         if (_signatures.length == 0) {
1048             return true;
1049         }
1050         address lastSigner = address(0);
1051         address[] memory guardians;
1052         if (_option != OwnerSignature.Required || _signatures.length > 65) {
1053             guardians = guardianStorage.getGuardians(_wallet); // guardians are only read if they may be needed
1054         }
1055         bool isGuardian;
1056         for (uint256 i = 0; i < _signatures.length / 65; i++) {
1057             address signer = Utils.recoverSigner(_signHash, _signatures, i);
1058             if (i == 0) {
1059                 if (_option == OwnerSignature.Required) {
1060                     // First signer must be owner
1061                     if (isOwner(_wallet, signer)) {
1062                         continue;
1063                     }
1064                     return false;
1065                 } else if (_option == OwnerSignature.Optional) {
1066                     // First signer can be owner
1067                     if (isOwner(_wallet, signer)) {
1068                         continue;
1069                     }
1070                 }
1071             }
1072             if (signer <= lastSigner) {
1073                 return false; // Signers must be different
1074             }
1075             lastSigner = signer;
1076             (isGuardian, guardians) = GuardianUtils.isGuardianOrGuardianSigner(guardians, signer);
1077             if (!isGuardian) {
1078                 return false;
1079             }
1080         }
1081         return true;
1082     }
1083     /**
1084     * @notice Refunds the gas used to the Relayer.
1085     * @param _wallet The target wallet.
1086     * @param _startGas The gas provided at the start of the execution.
1087     * @param _gasPrice The gas price for the refund.
1088     * @param _gasLimit The gas limit for the refund.
1089     * @param _refundToken The token to use for the gas refund.
1090     * @param _refundAddress The address refunded to prevent front-running.
1091     * @param _requiredSignatures The number of signatures required.
1092     */
1093     function refund(
1094         address _wallet,
1095         uint _startGas,
1096         uint _gasPrice,
1097         uint _gasLimit,
1098         address _refundToken,
1099         address _refundAddress,
1100         uint256 _requiredSignatures
1101     )
1102         internal
1103     {
1104         address refundAddress = _refundAddress == address(0) ? msg.sender : _refundAddress;
1105         uint256 refundAmount;
1106         // skip daily limit when approved by guardians (and signed by owner)
1107         if (_requiredSignatures > 1) {
1108             uint256 gasConsumed = _startGas.sub(gasleft()).add(30000);
1109             refundAmount = Utils.min(gasConsumed, _gasLimit).mul(_gasPrice);
1110         } else {
1111             uint256 gasConsumed = _startGas.sub(gasleft()).add(40000);
1112             refundAmount = Utils.min(gasConsumed, _gasLimit).mul(_gasPrice);
1113             uint256 ethAmount = (_refundToken == ETH_TOKEN) ? refundAmount : LimitUtils.getEtherValue(tokenPriceRegistry, refundAmount, _refundToken);
1114             require(LimitUtils.checkAndUpdateDailySpent(limitStorage, versionManager, _wallet, ethAmount), "RM: refund is above daily limit");
1115         }
1116         // refund in ETH or ERC20
1117         if (_refundToken == ETH_TOKEN) {
1118             invokeWallet(_wallet, refundAddress, refundAmount, EMPTY_BYTES);
1119         } else {
1120             bytes memory methodData = abi.encodeWithSignature("transfer(address,uint256)", refundAddress, refundAmount);
1121 		    bytes memory transferSuccessBytes = invokeWallet(_wallet, _refundToken, 0, methodData);
1122             // Check token refund is successful, when `transfer` returns a success bool result
1123             if (transferSuccessBytes.length > 0) {
1124                 require(abi.decode(transferSuccessBytes, (bool)), "RM: Refund transfer failed");
1125             }
1126         }
1127         emit Refund(_wallet, refundAddress, _refundToken, refundAmount);
1128     }
1129    /**
1130     * @notice Returns the current chainId
1131     * @return chainId the chainId
1132     */
1133     function getChainId() private pure returns (uint256 chainId) {
1134         // solhint-disable-next-line no-inline-assembly
1135         assembly { chainId := chainid() }
1136     }
1137 }