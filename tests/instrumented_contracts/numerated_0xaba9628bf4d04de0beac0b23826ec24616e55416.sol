1 pragma experimental ABIEncoderV2;
2 // File: contracts/modules/common/Utils.sol
3 // Copyright (C) 2020  Argent Labs Ltd. <https://argent.xyz>
4 // This program is free software: you can redistribute it and/or modify
5 // it under the terms of the GNU General Public License as published by
6 // the Free Software Foundation, either version 3 of the License, or
7 // (at your option) any later version.
8 // This program is distributed in the hope that it will be useful,
9 // but WITHOUT ANY WARRANTY; without even the implied warranty of
10 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
11 // GNU General Public License for more details.
12 // You should have received a copy of the GNU General Public License
13 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
14 // SPDX-License-Identifier: GPL-3.0-only
15 /**
16  * @title Utils
17  * @notice Common utility methods used by modules.
18  */
19 library Utils {
20     /**
21     * @notice Helper method to recover the signer at a given position from a list of concatenated signatures.
22     * @param _signedHash The signed hash
23     * @param _signatures The concatenated signatures.
24     * @param _index The index of the signature to recover.
25     */
26     function recoverSigner(bytes32 _signedHash, bytes memory _signatures, uint _index) internal pure returns (address) {
27         uint8 v;
28         bytes32 r;
29         bytes32 s;
30         // we jump 32 (0x20) as the first slot of bytes contains the length
31         // we jump 65 (0x41) per signature
32         // for v we load 32 bytes ending with v (the first 31 come from s) then apply a mask
33         // solhint-disable-next-line no-inline-assembly
34         assembly {
35             r := mload(add(_signatures, add(0x20,mul(0x41,_index))))
36             s := mload(add(_signatures, add(0x40,mul(0x41,_index))))
37             v := and(mload(add(_signatures, add(0x41,mul(0x41,_index)))), 0xff)
38         }
39         require(v == 27 || v == 28);
40         address recoveredAddress = ecrecover(_signedHash, v, r, s);
41         require(recoveredAddress != address(0), "Utils: ecrecover returned 0");
42         return recoveredAddress;
43     }
44     /**
45     * @notice Helper method to parse data and extract the method signature.
46     */
47     function functionPrefix(bytes memory _data) internal pure returns (bytes4 prefix) {
48         require(_data.length >= 4, "RM: Invalid functionPrefix");
49         // solhint-disable-next-line no-inline-assembly
50         assembly {
51             prefix := mload(add(_data, 0x20))
52         }
53     }
54     /**
55     * @notice Returns ceil(a / b).
56     */
57     function ceil(uint256 a, uint256 b) internal pure returns (uint256) {
58         uint256 c = a / b;
59         if (a % b == 0) {
60             return c;
61         } else {
62             return c + 1;
63         }
64     }
65     function min(uint256 a, uint256 b) internal pure returns (uint256) {
66         if (a < b) {
67             return a;
68         }
69         return b;
70     }
71 }
72 // File: @openzeppelin/contracts/math/SafeMath.sol
73 /**
74  * @dev Wrappers over Solidity's arithmetic operations with added overflow
75  * checks.
76  *
77  * Arithmetic operations in Solidity wrap on overflow. This can easily result
78  * in bugs, because programmers usually assume that an overflow raises an
79  * error, which is the standard behavior in high level programming languages.
80  * `SafeMath` restores this intuition by reverting the transaction when an
81  * operation overflows.
82  *
83  * Using this library instead of the unchecked operations eliminates an entire
84  * class of bugs, so it's recommended to use it always.
85  */
86 library SafeMath {
87     /**
88      * @dev Returns the addition of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `+` operator.
92      *
93      * Requirements:
94      * - Addition cannot overflow.
95      */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         require(c >= a, "SafeMath: addition overflow");
99         return c;
100     }
101     /**
102      * @dev Returns the subtraction of two unsigned integers, reverting on
103      * overflow (when the result is negative).
104      *
105      * Counterpart to Solidity's `-` operator.
106      *
107      * Requirements:
108      * - Subtraction cannot overflow.
109      */
110     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
111         return sub(a, b, "SafeMath: subtraction overflow");
112     }
113     /**
114      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
115      * overflow (when the result is negative).
116      *
117      * Counterpart to Solidity's `-` operator.
118      *
119      * Requirements:
120      * - Subtraction cannot overflow.
121      */
122     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
123         require(b <= a, errorMessage);
124         uint256 c = a - b;
125         return c;
126     }
127     /**
128      * @dev Returns the multiplication of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `*` operator.
132      *
133      * Requirements:
134      * - Multiplication cannot overflow.
135      */
136     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
137         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
138         // benefit is lost if 'b' is also tested.
139         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
140         if (a == 0) {
141             return 0;
142         }
143         uint256 c = a * b;
144         require(c / a == b, "SafeMath: multiplication overflow");
145         return c;
146     }
147     /**
148      * @dev Returns the integer division of two unsigned integers. Reverts on
149      * division by zero. The result is rounded towards zero.
150      *
151      * Counterpart to Solidity's `/` operator. Note: this function uses a
152      * `revert` opcode (which leaves remaining gas untouched) while Solidity
153      * uses an invalid opcode to revert (consuming all remaining gas).
154      *
155      * Requirements:
156      * - The divisor cannot be zero.
157      */
158     function div(uint256 a, uint256 b) internal pure returns (uint256) {
159         return div(a, b, "SafeMath: division by zero");
160     }
161     /**
162      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
163      * division by zero. The result is rounded towards zero.
164      *
165      * Counterpart to Solidity's `/` operator. Note: this function uses a
166      * `revert` opcode (which leaves remaining gas untouched) while Solidity
167      * uses an invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      * - The divisor cannot be zero.
171      */
172     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
173         // Solidity only automatically asserts when dividing by 0
174         require(b > 0, errorMessage);
175         uint256 c = a / b;
176         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
177         return c;
178     }
179     /**
180      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
181      * Reverts when dividing by zero.
182      *
183      * Counterpart to Solidity's `%` operator. This function uses a `revert`
184      * opcode (which leaves remaining gas untouched) while Solidity uses an
185      * invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      * - The divisor cannot be zero.
189      */
190     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
191         return mod(a, b, "SafeMath: modulo by zero");
192     }
193     /**
194      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
195      * Reverts with custom message when dividing by zero.
196      *
197      * Counterpart to Solidity's `%` operator. This function uses a `revert`
198      * opcode (which leaves remaining gas untouched) while Solidity uses an
199      * invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      * - The divisor cannot be zero.
203      */
204     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         require(b != 0, errorMessage);
206         return a % b;
207     }
208 }
209 // File: contracts/wallet/IWallet.sol
210 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
211 // This program is free software: you can redistribute it and/or modify
212 // it under the terms of the GNU General Public License as published by
213 // the Free Software Foundation, either version 3 of the License, or
214 // (at your option) any later version.
215 // This program is distributed in the hope that it will be useful,
216 // but WITHOUT ANY WARRANTY; without even the implied warranty of
217 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
218 // GNU General Public License for more details.
219 // You should have received a copy of the GNU General Public License
220 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
221  
222 pragma solidity >=0.5.4 <0.7.0;
223 /**
224  * @title IWallet
225  * @notice Interface for the BaseWallet
226  */
227 interface IWallet {
228     /**
229      * @notice Returns the wallet owner.
230      * @return The wallet owner address.
231      */
232     function owner() external view returns (address);
233     /**
234      * @notice Returns the number of authorised modules.
235      * @return The number of authorised modules.
236      */
237     function modules() external view returns (uint);
238     /**
239      * @notice Sets a new owner for the wallet.
240      * @param _newOwner The new owner.
241      */
242     function setOwner(address _newOwner) external;
243     /**
244      * @notice Checks if a module is authorised on the wallet.
245      * @param _module The module address to check.
246      * @return `true` if the module is authorised, otherwise `false`.
247      */
248     function authorised(address _module) external view returns (bool);
249     /**
250      * @notice Returns the module responsible for a static call redirection.
251      * @param _sig The signature of the static call.
252      * @return the module doing the redirection
253      */
254     function enabled(bytes4 _sig) external view returns (address);
255     /**
256      * @notice Enables/Disables a module.
257      * @param _module The target module.
258      * @param _value Set to `true` to authorise the module.
259      */
260     function authoriseModule(address _module, bool _value) external;
261     /**
262     * @notice Enables a static method by specifying the target module to which the call must be delegated.
263     * @param _module The target module.
264     * @param _method The static method signature.
265     */
266     function enableStaticCall(address _module, bytes4 _method) external;
267 }
268 // File: contracts/infrastructure/IModuleRegistry.sol
269 // Copyright (C) 2020  Argent Labs Ltd. <https://argent.xyz>
270 // This program is free software: you can redistribute it and/or modify
271 // it under the terms of the GNU General Public License as published by
272 // the Free Software Foundation, either version 3 of the License, or
273 // (at your option) any later version.
274 // This program is distributed in the hope that it will be useful,
275 // but WITHOUT ANY WARRANTY; without even the implied warranty of
276 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
277 // GNU General Public License for more details.
278 // You should have received a copy of the GNU General Public License
279 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
280  
281 pragma solidity >=0.5.4 <0.7.0;
282 /**
283  * @title IModuleRegistry
284  * @notice Interface for the registry of authorised modules.
285  */
286 interface IModuleRegistry {
287     function registerModule(address _module, bytes32 _name) external;
288     function deregisterModule(address _module) external;
289     function registerUpgrader(address _upgrader, bytes32 _name) external;
290     function deregisterUpgrader(address _upgrader) external;
291     function recoverToken(address _token) external;
292     function moduleInfo(address _module) external view returns (bytes32);
293     function upgraderInfo(address _upgrader) external view returns (bytes32);
294     function isRegisteredModule(address _module) external view returns (bool);
295     function isRegisteredModule(address[] calldata _modules) external view returns (bool);
296     function isRegisteredUpgrader(address _upgrader) external view returns (bool);
297 }
298 // File: contracts/infrastructure/storage/ILockStorage.sol
299 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
300 // This program is free software: you can redistribute it and/or modify
301 // it under the terms of the GNU General Public License as published by
302 // the Free Software Foundation, either version 3 of the License, or
303 // (at your option) any later version.
304 // This program is distributed in the hope that it will be useful,
305 // but WITHOUT ANY WARRANTY; without even the implied warranty of
306 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
307 // GNU General Public License for more details.
308 // You should have received a copy of the GNU General Public License
309 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
310  
311 pragma solidity >=0.5.4 <0.7.0;
312 interface ILockStorage {
313     function isLocked(address _wallet) external view returns (bool);
314     function getLock(address _wallet) external view returns (uint256);
315     function getLocker(address _wallet) external view returns (address);
316     function setLock(address _wallet, address _locker, uint256 _releaseAfter) external;
317 }
318 // File: contracts/modules/common/IFeature.sol
319 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
320 // This program is free software: you can redistribute it and/or modify
321 // it under the terms of the GNU General Public License as published by
322 // the Free Software Foundation, either version 3 of the License, or
323 // (at your option) any later version.
324 // This program is distributed in the hope that it will be useful,
325 // but WITHOUT ANY WARRANTY; without even the implied warranty of
326 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
327 // GNU General Public License for more details.
328 // You should have received a copy of the GNU General Public License
329 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
330  
331 pragma solidity >=0.5.4 <0.7.0;
332 /**
333  * @title IFeature
334  * @notice Interface for a Feature.
335  * @author Julien Niset - <julien@argent.xyz>, Olivier VDB - <olivier@argent.xyz>
336  */
337 interface IFeature {
338     enum OwnerSignature {
339         Anyone,             // Anyone
340         Required,           // Owner required
341         Optional,           // Owner and/or guardians
342         Disallowed          // guardians only
343     }
344     /**
345     * @notice Utility method to recover any ERC20 token that was sent to the Feature by mistake.
346     * @param _token The token to recover.
347     */
348     function recoverToken(address _token) external;
349     /**
350      * @notice Inits a Feature for a wallet by e.g. setting some wallet specific parameters in storage.
351      * @param _wallet The wallet.
352      */
353     function init(address _wallet) external;
354     /**
355      * @notice Helper method to check if an address is an authorised feature of a target wallet.
356      * @param _wallet The target wallet.
357      * @param _feature The address.
358      */
359     function isFeatureAuthorisedInVersionManager(address _wallet, address _feature) external view returns (bool);
360     /**
361     * @notice Gets the number of valid signatures that must be provided to execute a
362     * specific relayed transaction.
363     * @param _wallet The target wallet.
364     * @param _data The data of the relayed transaction.
365     * @return The number of required signatures and the wallet owner signature requirement.
366     */
367     function getRequiredSignatures(address _wallet, bytes calldata _data) external view returns (uint256, OwnerSignature);
368     /**
369     * @notice Gets the list of static call signatures that this feature responds to on behalf of wallets
370     */
371     function getStaticCallSignatures() external view returns (bytes4[] memory);
372 }
373 // File: lib/other/ERC20.sol
374 pragma solidity >=0.5.4 <0.7.0;
375 /**
376  * ERC20 contract interface.
377  */
378 interface ERC20 {
379     function totalSupply() external view returns (uint);
380     function decimals() external view returns (uint);
381     function balanceOf(address tokenOwner) external view returns (uint balance);
382     function allowance(address tokenOwner, address spender) external view returns (uint remaining);
383     function transfer(address to, uint tokens) external returns (bool success);
384     function approve(address spender, uint tokens) external returns (bool success);
385     function transferFrom(address from, address to, uint tokens) external returns (bool success);
386 }
387 // File: contracts/infrastructure/storage/ILimitStorage.sol
388 // This program is free software: you can redistribute it and/or modify
389 // it under the terms of the GNU General Public License as published by
390 // the Free Software Foundation, either version 3 of the License, or
391 // (at your option) any later version.
392 // This program is distributed in the hope that it will be useful,
393 // but WITHOUT ANY WARRANTY; without even the implied warranty of
394 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
395 // GNU General Public License for more details.
396 // You should have received a copy of the GNU General Public License
397 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
398  
399 /**
400  * @title ILimitStorage
401  * @notice LimitStorage interface
402  */
403 interface ILimitStorage {
404     struct Limit {
405         // the current limit
406         uint128 current;
407         // the pending limit if any
408         uint128 pending;
409         // when the pending limit becomes the current limit
410         uint64 changeAfter;
411     }
412     struct DailySpent {
413         // The amount already spent during the current period
414         uint128 alreadySpent;
415         // The end of the current period
416         uint64 periodEnd;
417     }
418     function setLimit(address _wallet, Limit memory _limit) external;
419     function getLimit(address _wallet) external view returns (Limit memory _limit);
420     function setDailySpent(address _wallet, DailySpent memory _dailySpent) external;
421     function getDailySpent(address _wallet) external view returns (DailySpent memory _dailySpent);
422     function setLimitAndDailySpent(address _wallet, Limit memory _limit, DailySpent memory _dailySpent) external;
423     function getLimitAndDailySpent(address _wallet) external view returns (Limit memory _limit, DailySpent memory _dailySpent);
424 }
425 // File: contracts/modules/common/IVersionManager.sol
426 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
427 // This program is free software: you can redistribute it and/or modify
428 // it under the terms of the GNU General Public License as published by
429 // the Free Software Foundation, either version 3 of the License, or
430 // (at your option) any later version.
431 // This program is distributed in the hope that it will be useful,
432 // but WITHOUT ANY WARRANTY; without even the implied warranty of
433 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
434 // GNU General Public License for more details.
435 // You should have received a copy of the GNU General Public License
436 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
437  
438 pragma solidity >=0.5.4 <0.7.0;
439 /**
440  * @title IVersionManager
441  * @notice Interface for the VersionManager module.
442  * @author Olivier VDB - <olivier@argent.xyz>
443  */
444 interface IVersionManager {
445     /**
446      * @notice Returns true if the feature is authorised for the wallet
447      * @param _wallet The target wallet.
448      * @param _feature The feature.
449      */
450     function isFeatureAuthorised(address _wallet, address _feature) external view returns (bool);
451     /**
452      * @notice Lets a feature (caller) invoke a wallet.
453      * @param _wallet The target wallet.
454      * @param _to The target address for the transaction.
455      * @param _value The value of the transaction.
456      * @param _data The data of the transaction.
457      */
458     function checkAuthorisedFeatureAndInvokeWallet(
459         address _wallet,
460         address _to,
461         uint256 _value,
462         bytes calldata _data
463     ) external returns (bytes memory _res);
464     /* ******* Backward Compatibility with old Storages and BaseWallet *************** */
465     /**
466      * @notice Sets a new owner for the wallet.
467      * @param _newOwner The new owner.
468      */
469     function setOwner(address _wallet, address _newOwner) external;
470     /**
471      * @notice Lets a feature write data to a storage contract.
472      * @param _wallet The target wallet.
473      * @param _storage The storage contract.
474      * @param _data The data of the call
475      */
476     function invokeStorage(address _wallet, address _storage, bytes calldata _data) external;
477     /**
478      * @notice Upgrade a wallet to a new version.
479      * @param _wallet the wallet to upgrade
480      * @param _toVersion the new version
481      */
482     function upgradeWallet(address _wallet, uint256 _toVersion) external;
483 }
484 // File: contracts/modules/common/BaseFeature.sol
485 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
486 // This program is free software: you can redistribute it and/or modify
487 // it under the terms of the GNU General Public License as published by
488 // the Free Software Foundation, either version 3 of the License, or
489 // (at your option) any later version.
490 // This program is distributed in the hope that it will be useful,
491 // but WITHOUT ANY WARRANTY; without even the implied warranty of
492 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
493 // GNU General Public License for more details.s
494 // You should have received a copy of the GNU General Public License
495 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
496  
497 /**
498  * @title BaseFeature
499  * @notice Base Feature contract that contains methods common to all Feature contracts.
500  * @author Julien Niset - <julien@argent.xyz>, Olivier VDB - <olivier@argent.xyz>
501  */
502 contract BaseFeature is IFeature {
503     // Empty calldata
504     bytes constant internal EMPTY_BYTES = "";
505     // Mock token address for ETH
506     address constant internal ETH_TOKEN = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
507     // The address of the Lock storage
508     ILockStorage internal lockStorage;
509     // The address of the Version Manager
510     IVersionManager internal versionManager;
511     event FeatureCreated(bytes32 name);
512     /**
513      * @notice Throws if the wallet is locked.
514      */
515     modifier onlyWhenUnlocked(address _wallet) {
516         require(!lockStorage.isLocked(_wallet), "BF: wallet locked");
517         _;
518     }
519     /**
520      * @notice Throws if the sender is not the VersionManager.
521      */
522     modifier onlyVersionManager() {
523         require(msg.sender == address(versionManager), "BF: caller must be VersionManager");
524         _;
525     }
526     /**
527      * @notice Throws if the sender is not the owner of the target wallet.
528      */
529     modifier onlyWalletOwner(address _wallet) {
530         require(isOwner(_wallet, msg.sender), "BF: must be wallet owner");
531         _;
532     }
533     /**
534      * @notice Throws if the sender is not an authorised feature of the target wallet.
535      */
536     modifier onlyWalletFeature(address _wallet) {
537         require(versionManager.isFeatureAuthorised(_wallet, msg.sender), "BF: must be a wallet feature");
538         _;
539     }
540     /**
541      * @notice Throws if the sender is not the owner of the target wallet or the feature itself.
542      */
543     modifier onlyWalletOwnerOrFeature(address _wallet) {
544         // Wrapping in an internal method reduces deployment cost by avoiding duplication of inlined code
545         verifyOwnerOrAuthorisedFeature(_wallet, msg.sender);
546         _;
547     }
548     constructor(
549         ILockStorage _lockStorage,
550         IVersionManager _versionManager,
551         bytes32 _name
552     ) public {
553         lockStorage = _lockStorage;
554         versionManager = _versionManager;
555         emit FeatureCreated(_name);
556     }
557     /**
558     * @inheritdoc IFeature
559     */
560     function recoverToken(address _token) external virtual override {
561         uint total = ERC20(_token).balanceOf(address(this));
562         _token.call(abi.encodeWithSelector(ERC20(_token).transfer.selector, address(versionManager), total));
563     }
564     /**
565      * @notice Inits the feature for a wallet by doing nothing.
566      * @dev !! Overriding methods need make sure `init()` can only be called by the VersionManager !!
567      * @param _wallet The wallet.
568      */
569     function init(address _wallet) external virtual override  {}
570     /**
571      * @inheritdoc IFeature
572      */
573     function getRequiredSignatures(address, bytes calldata) external virtual view override returns (uint256, OwnerSignature) {
574         revert("BF: disabled method");
575     }
576     /**
577      * @inheritdoc IFeature
578      */
579     function getStaticCallSignatures() external virtual override view returns (bytes4[] memory _sigs) {}
580     /**
581      * @inheritdoc IFeature
582      */
583     function isFeatureAuthorisedInVersionManager(address _wallet, address _feature) public override view returns (bool) {
584         return versionManager.isFeatureAuthorised(_wallet, _feature);
585     }
586     /**
587     * @notice Checks that the wallet address provided as the first parameter of _data matches _wallet
588     * @return false if the addresses are different.
589     */
590     function verifyData(address _wallet, bytes calldata _data) internal pure returns (bool) {
591         require(_data.length >= 36, "RM: Invalid dataWallet");
592         address dataWallet = abi.decode(_data[4:], (address));
593         return dataWallet == _wallet;
594     }
595      /**
596      * @notice Helper method to check if an address is the owner of a target wallet.
597      * @param _wallet The target wallet.
598      * @param _addr The address.
599      */
600     function isOwner(address _wallet, address _addr) internal view returns (bool) {
601         return IWallet(_wallet).owner() == _addr;
602     }
603     /**
604      * @notice Verify that the caller is an authorised feature or the wallet owner.
605      * @param _wallet The target wallet.
606      * @param _sender The caller.
607      */
608     function verifyOwnerOrAuthorisedFeature(address _wallet, address _sender) internal view {
609         require(isFeatureAuthorisedInVersionManager(_wallet, _sender) || isOwner(_wallet, _sender), "BF: must be owner or feature");
610     }
611     /**
612      * @notice Helper method to invoke a wallet.
613      * @param _wallet The target wallet.
614      * @param _to The target address for the transaction.
615      * @param _value The value of the transaction.
616      * @param _data The data of the transaction.
617      */
618     function invokeWallet(address _wallet, address _to, uint256 _value, bytes memory _data)
619         internal
620         returns (bytes memory _res) 
621     {
622         _res = versionManager.checkAuthorisedFeatureAndInvokeWallet(_wallet, _to, _value, _data);
623     }
624 }
625 // File: contracts/modules/common/GuardianUtils.sol
626 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
627 // This program is free software: you can redistribute it and/or modify
628 // it under the terms of the GNU General Public License as published by
629 // the Free Software Foundation, either version 3 of the License, or
630 // (at your option) any later version.
631 // This program is distributed in the hope that it will be useful,
632 // but WITHOUT ANY WARRANTY; without even the implied warranty of
633 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
634 // GNU General Public License for more details.
635 // You should have received a copy of the GNU General Public License
636 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
637  
638 /**
639  * @title GuardianUtils
640  * @notice Bundles guardian read logic.
641  */
642 library GuardianUtils {
643     /**
644     * @notice Checks if an address is a guardian or an account authorised to sign on behalf of a smart-contract guardian
645     * given a list of guardians.
646     * @param _guardians the list of guardians
647     * @param _guardian the address to test
648     * @return true and the list of guardians minus the found guardian upon success, false and the original list of guardians if not found.
649     */
650     function isGuardianOrGuardianSigner(address[] memory _guardians, address _guardian) internal view returns (bool, address[] memory) {
651         if (_guardians.length == 0 || _guardian == address(0)) {
652             return (false, _guardians);
653         }
654         bool isFound = false;
655         address[] memory updatedGuardians = new address[](_guardians.length - 1);
656         uint256 index = 0;
657         for (uint256 i = 0; i < _guardians.length; i++) {
658             if (!isFound) {
659                 // check if _guardian is an account guardian
660                 if (_guardian == _guardians[i]) {
661                     isFound = true;
662                     continue;
663                 }
664                 // check if _guardian is the owner of a smart contract guardian
665                 if (isContract(_guardians[i]) && isGuardianOwner(_guardians[i], _guardian)) {
666                     isFound = true;
667                     continue;
668                 }
669             }
670             if (index < updatedGuardians.length) {
671                 updatedGuardians[index] = _guardians[i];
672                 index++;
673             }
674         }
675         return isFound ? (true, updatedGuardians) : (false, _guardians);
676     }
677    /**
678     * @notice Checks if an address is a contract.
679     * @param _addr The address.
680     */
681     function isContract(address _addr) internal view returns (bool) {
682         uint32 size;
683         // solhint-disable-next-line no-inline-assembly
684         assembly {
685             size := extcodesize(_addr)
686         }
687         return (size > 0);
688     }
689     /**
690     * @notice Checks if an address is the owner of a guardian contract.
691     * The method does not revert if the call to the owner() method consumes more then 5000 gas.
692     * @param _guardian The guardian contract
693     * @param _owner The owner to verify.
694     */
695     function isGuardianOwner(address _guardian, address _owner) internal view returns (bool) {
696         address owner = address(0);
697         bytes4 sig = bytes4(keccak256("owner()"));
698         // solhint-disable-next-line no-inline-assembly
699         assembly {
700             let ptr := mload(0x40)
701             mstore(ptr,sig)
702             let result := staticcall(5000, _guardian, ptr, 0x20, ptr, 0x20)
703             if eq(result, 1) {
704                 owner := mload(ptr)
705             }
706         }
707         return owner == _owner;
708     }
709 }
710 // File: contracts/infrastructure/ITokenPriceRegistry.sol
711 // This program is free software: you can redistribute it and/or modify
712 // it under the terms of the GNU General Public License as published by
713 // the Free Software Foundation, either version 3 of the License, or
714 // (at your option) any later version.
715 // This program is distributed in the hope that it will be useful,
716 // but WITHOUT ANY WARRANTY; without even the implied warranty of
717 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
718 // GNU General Public License for more details.
719 // You should have received a copy of the GNU General Public License
720 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
721  
722 /**
723  * @title ITokenPriceRegistry
724  * @notice TokenPriceRegistry interface
725  */
726 interface ITokenPriceRegistry {
727     function getTokenPrice(address _token) external view returns (uint184 _price);
728     function isTokenTradable(address _token) external view returns (bool _isTradable);
729 }
730 // File: contracts/modules/common/LimitUtils.sol
731 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
732 // This program is free software: you can redistribute it and/or modify
733 // it under the terms of the GNU General Public License as published by
734 // the Free Software Foundation, either version 3 of the License, or
735 // (at your option) any later version.
736 // This program is distributed in the hope that it will be useful,
737 // but WITHOUT ANY WARRANTY; without even the implied warranty of
738 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
739 // GNU General Public License for more details.
740 // You should have received a copy of the GNU General Public License
741 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
742  
743 /**
744  * @title LimitUtils
745  * @notice Helper library to manage the daily limit and interact with a contract implementing the ILimitStorage interface.
746  * @author Julien Niset - <julien@argent.xyz>
747  */
748 library LimitUtils {
749     // large limit when the limit can be considered disabled
750     uint128 constant internal LIMIT_DISABLED = uint128(-1);
751     using SafeMath for uint256;
752     // *************** Internal Functions ********************* //
753     /**
754      * @notice Changes the daily limit (expressed in ETH).
755      * Decreasing the limit is immediate while increasing the limit is pending for the security period.
756      * @param _lStorage The storage contract.
757      * @param _versionManager The version manager.
758      * @param _wallet The target wallet.
759      * @param _targetLimit The target limit.
760      * @param _securityPeriod The security period.
761      */
762     function changeLimit(
763         ILimitStorage _lStorage,
764         IVersionManager _versionManager,
765         address _wallet,
766         uint256 _targetLimit,
767         uint256 _securityPeriod
768     )
769         internal
770         returns (ILimitStorage.Limit memory)
771     {
772         ILimitStorage.Limit memory limit = _lStorage.getLimit(_wallet);
773         uint256 currentLimit = currentLimit(limit);
774         ILimitStorage.Limit memory newLimit;
775         if (_targetLimit <= currentLimit) {
776             uint128 targetLimit = safe128(_targetLimit);
777             newLimit = ILimitStorage.Limit(targetLimit, targetLimit, safe64(block.timestamp));
778         } else {
779             newLimit = ILimitStorage.Limit(safe128(currentLimit), safe128(_targetLimit), safe64(block.timestamp.add(_securityPeriod)));
780         }
781         setLimit(_versionManager, _lStorage, _wallet, newLimit);
782         return newLimit;
783     }
784      /**
785      * @notice Disable the daily limit.
786      * The change is pending for the security period.
787      * @param _lStorage The storage contract.
788      * @param _versionManager The version manager.
789      * @param _wallet The target wallet.
790      * @param _securityPeriod The security period.
791      */
792     function disableLimit(
793         ILimitStorage _lStorage,
794         IVersionManager _versionManager,
795         address _wallet,
796         uint256 _securityPeriod
797     )
798         internal
799     {
800         changeLimit(_lStorage, _versionManager, _wallet, LIMIT_DISABLED, _securityPeriod);
801     }
802     /**
803     * @notice Returns whether the daily limit is disabled for a wallet.
804     * @param _wallet The target wallet.
805     * @return _limitDisabled true if the daily limit is disabled, false otherwise.
806     */
807     function isLimitDisabled(ILimitStorage _lStorage, address _wallet) internal view returns (bool) {
808         ILimitStorage.Limit memory limit = _lStorage.getLimit(_wallet);
809         uint256 currentLimit = currentLimit(limit);
810         return (currentLimit == LIMIT_DISABLED);
811     }
812     /**
813     * @notice Checks if a transfer is within the limit. If yes the daily spent is updated.
814     * @param _lStorage The storage contract.
815     * @param _versionManager The Version Manager.
816     * @param _wallet The target wallet.
817     * @param _amount The amount for the transfer
818     * @return true if the transfer is withing the daily limit.
819     */
820     function checkAndUpdateDailySpent(
821         ILimitStorage _lStorage,
822         IVersionManager _versionManager,
823         address _wallet,
824         uint256 _amount
825     )
826         internal
827         returns (bool)
828     {
829         (ILimitStorage.Limit memory limit, ILimitStorage.DailySpent memory dailySpent) = _lStorage.getLimitAndDailySpent(_wallet);
830         uint256 currentLimit = currentLimit(limit);
831         if (_amount == 0 || currentLimit == LIMIT_DISABLED) {
832             return true;
833         }
834         ILimitStorage.DailySpent memory newDailySpent;
835         if (dailySpent.periodEnd <= block.timestamp && _amount <= currentLimit) {
836             newDailySpent = ILimitStorage.DailySpent(safe128(_amount), safe64(block.timestamp + 24 hours));
837             setDailySpent(_versionManager, _lStorage, _wallet, newDailySpent);
838             return true;
839         } else if (dailySpent.periodEnd > block.timestamp && _amount.add(dailySpent.alreadySpent) <= currentLimit) {
840             newDailySpent = ILimitStorage.DailySpent(safe128(_amount.add(dailySpent.alreadySpent)), safe64(dailySpent.periodEnd));
841             setDailySpent(_versionManager, _lStorage, _wallet, newDailySpent);
842             return true;
843         }
844         return false;
845     }
846     /**
847     * @notice Helper method to Reset the daily consumption.
848     * @param _versionManager The Version Manager.
849     * @param _wallet The target wallet.
850     */
851     function resetDailySpent(IVersionManager _versionManager, ILimitStorage limitStorage, address _wallet) internal {
852         setDailySpent(_versionManager, limitStorage, _wallet, ILimitStorage.DailySpent(uint128(0), uint64(0)));
853     }
854     /**
855     * @notice Helper method to get the ether value equivalent of a token amount.
856     * @notice For low value amounts of tokens we accept this to return zero as these are small enough to disregard.
857     * Note that the price stored for tokens = price for 1 token (in ETH wei) * 10^(18-token decimals).
858     * @param _amount The token amount.
859     * @param _token The address of the token.
860     * @return The ether value for _amount of _token.
861     */
862     function getEtherValue(ITokenPriceRegistry _priceRegistry, uint256 _amount, address _token) internal view returns (uint256) {
863         uint256 price = _priceRegistry.getTokenPrice(_token);
864         uint256 etherValue = price.mul(_amount).div(10**18);
865         return etherValue;
866     }
867     /**
868     * @notice Helper method to get the current limit from a Limit struct.
869     * @param _limit The limit struct
870     */
871     function currentLimit(ILimitStorage.Limit memory _limit) internal view returns (uint256) {
872         if (_limit.changeAfter > 0 && _limit.changeAfter < block.timestamp) {
873             return _limit.pending;
874         }
875         return _limit.current;
876     }
877     function safe128(uint256 _num) internal pure returns (uint128) {
878         require(_num < 2**128, "LU: more then 128 bits");
879         return uint128(_num);
880     }
881     function safe64(uint256 _num) internal pure returns (uint64) {
882         require(_num < 2**64, "LU: more then 64 bits");
883         return uint64(_num);
884     }
885     // *************** Storage invocations in VersionManager ********************* //
886     function setLimit(
887         IVersionManager _versionManager,
888         ILimitStorage _lStorage,
889         address _wallet, 
890         ILimitStorage.Limit memory _limit
891     ) internal {
892         _versionManager.invokeStorage(
893             _wallet,
894             address(_lStorage),
895             abi.encodeWithSelector(_lStorage.setLimit.selector, _wallet, _limit)
896         );
897     }
898     function setDailySpent(
899         IVersionManager _versionManager,
900         ILimitStorage _lStorage,
901         address _wallet, 
902         ILimitStorage.DailySpent memory _dailySpent
903     ) private {
904         _versionManager.invokeStorage(
905             _wallet,
906             address(_lStorage),
907             abi.encodeWithSelector(_lStorage.setDailySpent.selector, _wallet, _dailySpent)
908         );
909     }
910 }
911 // File: contracts/infrastructure/storage/IGuardianStorage.sol
912 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
913 // This program is free software: you can redistribute it and/or modify
914 // it under the terms of the GNU General Public License as published by
915 // the Free Software Foundation, either version 3 of the License, or
916 // (at your option) any later version.
917 // This program is distributed in the hope that it will be useful,
918 // but WITHOUT ANY WARRANTY; without even the implied warranty of
919 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
920 // GNU General Public License for more details.
921 // You should have received a copy of the GNU General Public License
922 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
923  
924 pragma solidity >=0.5.4 <0.7.0;
925 interface IGuardianStorage {
926     /**
927      * @notice Lets an authorised module add a guardian to a wallet.
928      * @param _wallet The target wallet.
929      * @param _guardian The guardian to add.
930      */
931     function addGuardian(address _wallet, address _guardian) external;
932     /**
933      * @notice Lets an authorised module revoke a guardian from a wallet.
934      * @param _wallet The target wallet.
935      * @param _guardian The guardian to revoke.
936      */
937     function revokeGuardian(address _wallet, address _guardian) external;
938     /**
939      * @notice Checks if an account is a guardian for a wallet.
940      * @param _wallet The target wallet.
941      * @param _guardian The account.
942      * @return true if the account is a guardian for a wallet.
943      */
944     function isGuardian(address _wallet, address _guardian) external view returns (bool);
945     function isLocked(address _wallet) external view returns (bool);
946     function getLock(address _wallet) external view returns (uint256);
947     function getLocker(address _wallet) external view returns (address);
948     function setLock(address _wallet, uint256 _releaseAfter) external;
949     function getGuardians(address _wallet) external view returns (address[] memory);
950     function guardianCount(address _wallet) external view returns (uint256);
951 }
952 // File: modules/RelayerManager.sol
953 // Copyright (C) 2018  Argent Labs Ltd. <https://argent.xyz>
954 // This program is free software: you can redistribute it and/or modify
955 // it under the terms of the GNU General Public License as published by
956 // the Free Software Foundation, either version 3 of the License, or
957 // (at your option) any later version.
958 // This program is distributed in the hope that it will be useful,
959 // but WITHOUT ANY WARRANTY; without even the implied warranty of
960 // MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
961 // GNU General Public License for more details.
962 // You should have received a copy of the GNU General Public License
963 // along with this program.  If not, see <http://www.gnu.org/licenses/>.
964  
965 /**
966  * @title RelayerManager
967  * @notice Feature to execute transactions signed by ETH-less accounts and sent by a relayer.
968  * @author Julien Niset <julien@argent.xyz>, Olivier VDB <olivier@argent.xyz>
969  */
970 contract RelayerManager is BaseFeature {
971     bytes32 constant NAME = "RelayerManager";
972     uint256 constant internal BLOCKBOUND = 10000;
973     using SafeMath for uint256;
974     mapping (address => RelayerConfig) public relayer;
975     // The storage of the limit
976     ILimitStorage public limitStorage;
977     // The Token price storage
978     ITokenPriceRegistry public tokenPriceRegistry;
979     // The Guardian storage
980     IGuardianStorage public guardianStorage;
981     struct RelayerConfig {
982         uint256 nonce;
983         mapping (bytes32 => bool) executedTx;
984     }
985     // Used to avoid stack too deep error
986     struct StackExtension {
987         uint256 requiredSignatures;
988         OwnerSignature ownerSignatureRequirement;
989         bytes32 signHash;
990         bool success;
991         bytes returnData;
992     }
993     event TransactionExecuted(address indexed wallet, bool indexed success, bytes returnData, bytes32 signedHash);
994     event Refund(address indexed wallet, address indexed refundAddress, address refundToken, uint256 refundAmount);
995     /* ***************** External methods ************************* */
996     constructor(
997         ILockStorage _lockStorage,
998         IGuardianStorage _guardianStorage,
999         ILimitStorage _limitStorage,
1000         ITokenPriceRegistry _tokenPriceRegistry,
1001         IVersionManager _versionManager
1002     )
1003         BaseFeature(_lockStorage, _versionManager, NAME)
1004         public
1005     {
1006         limitStorage = _limitStorage;
1007         tokenPriceRegistry = _tokenPriceRegistry;
1008         guardianStorage = _guardianStorage;
1009     }
1010     /**
1011     * @notice Executes a relayed transaction.
1012     * @param _wallet The target wallet.
1013     * @param _feature The target feature.
1014     * @param _data The data for the relayed transaction
1015     * @param _nonce The nonce used to prevent replay attacks.
1016     * @param _signatures The signatures as a concatenated byte array.
1017     * @param _gasPrice The gas price to use for the gas refund.
1018     * @param _gasLimit The gas limit to use for the gas refund.
1019     * @param _refundToken The token to use for the gas refund.
1020     * @param _refundAddress The address refunded to prevent front-running.
1021     */
1022     function execute(
1023         address _wallet,
1024         address _feature,
1025         bytes calldata _data,
1026         uint256 _nonce,
1027         bytes calldata _signatures,
1028         uint256 _gasPrice,
1029         uint256 _gasLimit,
1030         address _refundToken,
1031         address _refundAddress
1032     )
1033         external
1034         returns (bool)
1035     {
1036         uint startGas = gasleft();
1037         require(startGas >= _gasLimit, "RM: not enough gas provided");
1038         require(verifyData(_wallet, _data), "RM: Target of _data != _wallet");
1039         require(isFeatureAuthorisedInVersionManager(_wallet, _feature), "RM: feature not authorised");
1040         StackExtension memory stack;
1041         (stack.requiredSignatures, stack.ownerSignatureRequirement) = IFeature(_feature).getRequiredSignatures(_wallet, _data);
1042         require(stack.requiredSignatures > 0 || stack.ownerSignatureRequirement == OwnerSignature.Anyone, "RM: Wrong signature requirement");
1043         require(stack.requiredSignatures * 65 == _signatures.length, "RM: Wrong number of signatures");
1044         stack.signHash = getSignHash(
1045             address(this),
1046             _feature,
1047             0,
1048             _data,
1049             _nonce,
1050             _gasPrice,
1051             _gasLimit,
1052             _refundToken,
1053             _refundAddress);
1054         require(checkAndUpdateUniqueness(
1055             _wallet,
1056             _nonce,
1057             stack.signHash,
1058             stack.requiredSignatures,
1059             stack.ownerSignatureRequirement), "RM: Duplicate request");
1060         require(validateSignatures(_wallet, stack.signHash, _signatures, stack.ownerSignatureRequirement), "RM: Invalid signatures");
1061         (stack.success, stack.returnData) = _feature.call(_data);
1062         // only refund when approved by owner and positive gas price
1063         if (_gasPrice > 0 && stack.ownerSignatureRequirement == OwnerSignature.Required) {
1064             refund(
1065                 _wallet,
1066                 startGas,
1067                 _gasPrice,
1068                 _gasLimit,
1069                 _refundToken,
1070                 _refundAddress,
1071                 stack.requiredSignatures);
1072         }
1073         emit TransactionExecuted(_wallet, stack.success, stack.returnData, stack.signHash);
1074         return stack.success;
1075     }
1076     /**
1077     * @notice Gets the current nonce for a wallet.
1078     * @param _wallet The target wallet.
1079     */
1080     function getNonce(address _wallet) external view returns (uint256 nonce) {
1081         return relayer[_wallet].nonce;
1082     }
1083     /**
1084     * @notice Checks if a transaction identified by its sign hash has already been executed.
1085     * @param _wallet The target wallet.
1086     * @param _signHash The sign hash of the transaction.
1087     */
1088     function isExecutedTx(address _wallet, bytes32 _signHash) external view returns (bool executed) {
1089         return relayer[_wallet].executedTx[_signHash];
1090     }
1091     /* ***************** Internal & Private methods ************************* */
1092     /**
1093     * @notice Generates the signed hash of a relayed transaction according to ERC 1077.
1094     * @param _from The starting address for the relayed transaction (should be the relayer module)
1095     * @param _to The destination address for the relayed transaction (should be the target module)
1096     * @param _value The value for the relayed transaction.
1097     * @param _data The data for the relayed transaction which includes the wallet address.
1098     * @param _nonce The nonce used to prevent replay attacks.
1099     * @param _gasPrice The gas price to use for the gas refund.
1100     * @param _gasLimit The gas limit to use for the gas refund.
1101     * @param _refundToken The token to use for the gas refund.
1102     * @param _refundAddress The address refunded to prevent front-running.
1103     */
1104     function getSignHash(
1105         address _from,
1106         address _to,
1107         uint256 _value,
1108         bytes memory _data,
1109         uint256 _nonce,
1110         uint256 _gasPrice,
1111         uint256 _gasLimit,
1112         address _refundToken,
1113         address _refundAddress
1114     )
1115         internal
1116         pure
1117         returns (bytes32)
1118     {
1119         return keccak256(
1120             abi.encodePacked(
1121                 "\x19Ethereum Signed Message:\n32",
1122                 keccak256(abi.encodePacked(
1123                     byte(0x19),
1124                     byte(0),
1125                     _from,
1126                     _to,
1127                     _value,
1128                     _data,
1129                     getChainId(),
1130                     _nonce,
1131                     _gasPrice,
1132                     _gasLimit,
1133                     _refundToken,
1134                     _refundAddress))
1135         ));
1136     }
1137     /**
1138     * @notice Checks if the relayed transaction is unique. If yes the state is updated.
1139     * For actions requiring 1 signature by the owner we use the incremental nonce.
1140     * For all other actions we check/store the signHash in a mapping.
1141     * @param _wallet The target wallet.
1142     * @param _nonce The nonce.
1143     * @param _signHash The signed hash of the transaction.
1144     * @param requiredSignatures The number of signatures required.
1145     * @param ownerSignatureRequirement The wallet owner signature requirement.
1146     * @return true if the transaction is unique.
1147     */
1148     function checkAndUpdateUniqueness(
1149         address _wallet,
1150         uint256 _nonce,
1151         bytes32 _signHash,
1152         uint256 requiredSignatures,
1153         OwnerSignature ownerSignatureRequirement
1154     )
1155         internal
1156         returns (bool)
1157     {
1158         if (requiredSignatures == 1 && ownerSignatureRequirement == OwnerSignature.Required) {
1159             // use the incremental nonce
1160             if (_nonce <= relayer[_wallet].nonce) {
1161                 return false;
1162             }
1163             uint256 nonceBlock = (_nonce & 0xffffffffffffffffffffffffffffffff00000000000000000000000000000000) >> 128;
1164             if (nonceBlock > block.number + BLOCKBOUND) {
1165                 return false;
1166             }
1167             relayer[_wallet].nonce = _nonce;
1168             return true;
1169         } else {
1170             // use the txHash map
1171             if (relayer[_wallet].executedTx[_signHash] == true) {
1172                 return false;
1173             }
1174             relayer[_wallet].executedTx[_signHash] = true;
1175             return true;
1176         }
1177     }
1178     /**
1179     * @notice Validates the signatures provided with a relayed transaction.
1180     * The method MUST throw if one or more signatures are not valid.
1181     * @param _wallet The target wallet.
1182     * @param _signHash The signed hash representing the relayed transaction.
1183     * @param _signatures The signatures as a concatenated byte array.
1184     * @param _option An enum indicating whether the owner is required, optional or disallowed.
1185     * @return A boolean indicating whether the signatures are valid.
1186     */
1187     function validateSignatures(
1188         address _wallet,
1189         bytes32 _signHash,
1190         bytes memory _signatures,
1191         OwnerSignature _option
1192     )
1193         internal
1194         view
1195         returns (bool)
1196     {
1197         if (_signatures.length == 0) {
1198             return true;
1199         }
1200         address lastSigner = address(0);
1201         address[] memory guardians;
1202         if (_option != OwnerSignature.Required || _signatures.length > 65) {
1203             guardians = guardianStorage.getGuardians(_wallet); // guardians are only read if they may be needed
1204         }
1205         bool isGuardian;
1206         for (uint256 i = 0; i < _signatures.length / 65; i++) {
1207             address signer = Utils.recoverSigner(_signHash, _signatures, i);
1208             if (i == 0) {
1209                 if (_option == OwnerSignature.Required) {
1210                     // First signer must be owner
1211                     if (isOwner(_wallet, signer)) {
1212                         continue;
1213                     }
1214                     return false;
1215                 } else if (_option == OwnerSignature.Optional) {
1216                     // First signer can be owner
1217                     if (isOwner(_wallet, signer)) {
1218                         continue;
1219                     }
1220                 }
1221             }
1222             if (signer <= lastSigner) {
1223                 return false; // Signers must be different
1224             }
1225             lastSigner = signer;
1226             (isGuardian, guardians) = GuardianUtils.isGuardianOrGuardianSigner(guardians, signer);
1227             if (!isGuardian) {
1228                 return false;
1229             }
1230         }
1231         return true;
1232     }
1233     /**
1234     * @notice Refunds the gas used to the Relayer.
1235     * @param _wallet The target wallet.
1236     * @param _startGas The gas provided at the start of the execution.
1237     * @param _gasPrice The gas price for the refund.
1238     * @param _gasLimit The gas limit for the refund.
1239     * @param _refundToken The token to use for the gas refund.
1240     * @param _refundAddress The address refunded to prevent front-running.
1241     * @param _requiredSignatures The number of signatures required.
1242     */
1243     function refund(
1244         address _wallet,
1245         uint _startGas,
1246         uint _gasPrice,
1247         uint _gasLimit,
1248         address _refundToken,
1249         address _refundAddress,
1250         uint256 _requiredSignatures
1251     )
1252         internal
1253     {
1254         address refundAddress = _refundAddress == address(0) ? msg.sender : _refundAddress;
1255         uint256 refundAmount;
1256         // skip daily limit when approved by guardians (and signed by owner)
1257         if (_requiredSignatures > 1) {
1258             uint256 gasConsumed = _startGas.sub(gasleft()).add(30000);
1259             refundAmount = Utils.min(gasConsumed, _gasLimit).mul(_gasPrice);
1260         } else {
1261             uint256 gasConsumed = _startGas.sub(gasleft()).add(40000);
1262             refundAmount = Utils.min(gasConsumed, _gasLimit).mul(_gasPrice);
1263             uint256 ethAmount = (_refundToken == ETH_TOKEN) ? refundAmount : LimitUtils.getEtherValue(tokenPriceRegistry, refundAmount, _refundToken);
1264             require(LimitUtils.checkAndUpdateDailySpent(limitStorage, versionManager, _wallet, ethAmount), "RM: refund is above daily limit");
1265         }
1266         // refund in ETH or ERC20
1267         if (_refundToken == ETH_TOKEN) {
1268             invokeWallet(_wallet, refundAddress, refundAmount, EMPTY_BYTES);
1269         } else {
1270             bytes memory methodData = abi.encodeWithSignature("transfer(address,uint256)", refundAddress, refundAmount);
1271 		    bytes memory transferSuccessBytes = invokeWallet(_wallet, _refundToken, 0, methodData);
1272             // Check token refund is successful, when `transfer` returns a success bool result
1273             if (transferSuccessBytes.length > 0) {
1274                 require(abi.decode(transferSuccessBytes, (bool)), "RM: Refund transfer failed");
1275             }
1276         }
1277         emit Refund(_wallet, refundAddress, _refundToken, refundAmount);
1278     }
1279    /**
1280     * @notice Returns the current chainId
1281     * @return chainId the chainId
1282     */
1283     function getChainId() private pure returns (uint256 chainId) {
1284         // solhint-disable-next-line no-inline-assembly
1285         assembly { chainId := chainid() }
1286     }
1287 }