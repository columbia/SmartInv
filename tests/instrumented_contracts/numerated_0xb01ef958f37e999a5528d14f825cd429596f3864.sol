1 // File: contracts\interfaces\IAVN.sol
2 
3 // SPDX-License-Identifier: MIT
4 pragma solidity 0.8.11;
5 
6 interface IAVN {
7   event LogAuthorisationUpdated(address indexed contractAddress, bool status);
8   event LogQuorumUpdated(uint256[2] quorum);
9   event LogValidatorFunctionsAreEnabled(bool status);
10   event LogLiftingIsEnabled(bool status);
11   event LogLoweringIsEnabled(bool status);
12   event LogLowerCallUpdated(bytes2 callId, uint256 numBytes);
13 
14   event LogValidatorRegistered(bytes32 indexed t1PublicKeyLHS, bytes32 t1PublicKeyRHS, bytes32 indexed t2PublicKey,
15       uint256 indexed t2TransactionId);
16   event LogValidatorDeregistered(bytes32 indexed t1PublicKeyLHS, bytes32 t1PublicKeyRHS, bytes32 indexed t2PublicKey,
17       uint256 indexed t2TransactionId);
18   event LogRootPublished(bytes32 indexed rootHash, uint256 indexed t2TransactionId);
19 
20   event LogLifted(address indexed token, address indexed t1Address, bytes32 indexed t2PublicKey, uint256 amount);
21   event LogLowered(address indexed token, address indexed t1Address, bytes32 indexed t2PublicKey, uint256 amount);
22 
23   // Owner only
24   function transferValidators() external;
25   function setAuthorisationStatus(address contractAddress, bool status) external;
26   function setQuorum(uint256[2] memory quorum) external;
27   function disableValidatorFunctions() external;
28   function enableValidatorFunctions() external;
29   function disableLifting() external;
30   function enableLifting() external;
31   function disableLowering() external;
32   function enableLowering() external;
33   function updateLowerCall(bytes2 callId, uint256 numBytes) external;
34   function recoverERC777TokensFromLegacyTreasury(address erc777Address) external;
35   function recoverERC20TokensFromLegacyTreasury(address erc20Address) external;
36   function liftLegacyStakes(bytes calldata t2PublicKey, uint256 amount) external;
37 
38   // Validator only
39   function registerValidator(bytes memory t1PublicKey, bytes32 t2PublicKey, uint256 t2TransactionId,
40       bytes calldata confirmations) external;
41   function deregisterValidator(bytes memory t1PublicKey, bytes32 t2PublicKey, uint256 t2TransactionId,
42       bytes calldata confirmations) external;
43   function publishRoot(bytes32 rootHash, uint256 t2TransactionId, bytes calldata confirmations) external;
44 
45   // Authorised contract only
46   function storeT2TransactionId(uint256 t2TransactionId) external;
47   function storeRootHash(bytes32 rootHash) external;
48   function storeLiftProofHash(bytes32 proofHash) external;
49   function storeLoweredLeafHash(bytes32 leafHash) external;
50   function unlockETH(address payable recipient, uint256 amount) external;
51   function unlockERC777Tokens(address erc777Address, address recipient, uint256 amount) external;
52   function unlockERC20Tokens(address erc20Address, address recipient, uint256 amount) external;
53 
54   // Public
55   function getAuthorisedContracts() external view returns (address[] memory);
56   function getIsPublishedRootHash(bytes32 rootHash) external view returns (bool);
57   function lift(address erc20Address, bytes calldata t2PublicKey, uint256 amount) external;
58   function proxyLift(address erc20Address, bytes calldata t2PublicKey, uint256 amount, address approver, uint256 proofNonce,
59       bytes calldata proof) external;
60   function liftETH(bytes calldata t2PublicKey) external payable;
61   function lower(bytes memory leaf, bytes32[] calldata merklePath) external;
62   function confirmAvnTransaction(bytes32 leafHash, bytes32[] memory merklePath) external view returns (bool);
63 }
64 
65 // File: contracts\interfaces\IERC20.sol
66 
67 
68 pragma solidity 0.8.11;
69 
70 // As described in https://eips.ethereum.org/EIPS/eip-20
71 interface IERC20 {
72   event Transfer(address indexed from, address indexed to, uint256 value);
73   event Approval(address indexed owner, address indexed spender, uint256 value);
74 
75   function name() external view returns (string memory); // optional method - see eip spec
76   function symbol() external view returns (string memory); // optional method - see eip spec
77   function decimals() external view returns (uint8); // optional method - see eip spec
78   function totalSupply() external view returns (uint256);
79   function balanceOf(address owner) external view returns (uint256);
80   function transfer(address to, uint256 value) external returns (bool);
81   function transferFrom(address from, address to, uint256 value) external returns (bool);
82   function approve(address spender, uint256 value) external returns (bool);
83   function allowance(address owner, address spender) external view returns (uint256);
84 }
85 
86 // File: contracts\interfaces\IERC777.sol
87 
88 
89 pragma solidity 0.8.11;
90 
91 // As defined in https://eips.ethereum.org/EIPS/eip-777
92 interface IERC777 {
93   event Sent(address indexed operator, address indexed from, address indexed to, uint256 amount, bytes data,
94       bytes operatorData);
95   event Minted(address indexed operator, address indexed to, uint256 amount, bytes data, bytes operatorData);
96   event Burned(address indexed operator, address indexed from, uint256 amount, bytes data, bytes operatorData);
97   event AuthorizedOperator(address indexed operator,address indexed holder);
98   event RevokedOperator(address indexed operator, address indexed holder);
99 
100   function name() external view returns (string memory);
101   function symbol() external view returns (string memory);
102   function totalSupply() external view returns (uint256);
103   function balanceOf(address holder) external view returns (uint256);
104   function granularity() external view returns (uint256);
105   function defaultOperators() external view returns (address[] memory);
106   function isOperatorFor(address operator, address holder) external view returns (bool);
107   function authorizeOperator(address operator) external;
108   function revokeOperator(address operator) external;
109   function send(address to, uint256 amount, bytes calldata data) external;
110   function operatorSend(address from, address to, uint256 amount, bytes calldata data, bytes calldata operatorData) external;
111   function burn(uint256 amount, bytes calldata data) external;
112   function operatorBurn( address from, uint256 amount, bytes calldata data, bytes calldata operatorData) external;
113 }
114 
115 // File: contracts\interfaces\IERC777Recipient.sol
116 
117 
118 pragma solidity 0.8.11;
119 
120 // As defined in the 'ERC777TokensRecipient And The tokensReceived Hook' section of https://eips.ethereum.org/EIPS/eip-777
121 interface IERC777Recipient {
122   function tokensReceived(address operator, address from, address to, uint256 amount, bytes calldata data,
123       bytes calldata operatorData) external;
124 }
125 
126 // File: contracts\interfaces\IAvnFTTreasury.sol
127 
128 
129 pragma solidity 0.8.11;
130 
131 interface IAvnFTTreasury {
132   event LogFTTreasuryPermissionUpdated(address indexed treasurer, bool status);
133 
134   function setTreasurerPermission(address treasurer, bool status) external;
135   function getTreasurers() external view returns(address[] memory);
136   function unlockERC777Tokens(address token, uint256 amount, bytes calldata data) external;
137   function unlockERC20Tokens(address token, uint256 amount) external;
138 }
139 
140 // File: contracts\thirdParty\interfaces\IERC1820Registry.sol
141 
142 
143 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC1820Registry.sol)
144 
145 pragma solidity ^0.8.0;
146 
147 /**
148  * @dev Interface of the global ERC1820 Registry, as defined in the
149  * https://eips.ethereum.org/EIPS/eip-1820[EIP]. Accounts may register
150  * implementers for interfaces in this registry, as well as query support.
151  *
152  * Implementers may be shared by multiple accounts, and can also implement more
153  * than a single interface for each account. Contracts can implement interfaces
154  * for themselves, but externally-owned accounts (EOA) must delegate this to a
155  * contract.
156  *
157  * {IERC165} interfaces can also be queried via the registry.
158  *
159  * For an in-depth explanation and source code analysis, see the EIP text.
160  */
161 interface IERC1820Registry {
162     /**
163      * @dev Sets `newManager` as the manager for `account`. A manager of an
164      * account is able to set interface implementers for it.
165      *
166      * By default, each account is its own manager. Passing a value of `0x0` in
167      * `newManager` will reset the manager to this initial state.
168      *
169      * Emits a {ManagerChanged} event.
170      *
171      * Requirements:
172      *
173      * - the caller must be the current manager for `account`.
174      */
175     function setManager(address account, address newManager) external;
176 
177     /**
178      * @dev Returns the manager for `account`.
179      *
180      * See {setManager}.
181      */
182     function getManager(address account) external view returns (address);
183 
184     /**
185      * @dev Sets the `implementer` contract as ``account``'s implementer for
186      * `interfaceHash`.
187      *
188      * `account` being the zero address is an alias for the caller's address.
189      * The zero address can also be used in `implementer` to remove an old one.
190      *
191      * See {interfaceHash} to learn how these are created.
192      *
193      * Emits an {InterfaceImplementerSet} event.
194      *
195      * Requirements:
196      *
197      * - the caller must be the current manager for `account`.
198      * - `interfaceHash` must not be an {IERC165} interface id (i.e. it must not
199      * end in 28 zeroes).
200      * - `implementer` must implement {IERC1820Implementer} and return true when
201      * queried for support, unless `implementer` is the caller. See
202      * {IERC1820Implementer-canImplementInterfaceForAddress}.
203      */
204     function setInterfaceImplementer(
205         address account,
206         bytes32 _interfaceHash,
207         address implementer
208     ) external;
209 
210     /**
211      * @dev Returns the implementer of `interfaceHash` for `account`. If no such
212      * implementer is registered, returns the zero address.
213      *
214      * If `interfaceHash` is an {IERC165} interface id (i.e. it ends with 28
215      * zeroes), `account` will be queried for support of it.
216      *
217      * `account` being the zero address is an alias for the caller's address.
218      */
219     function getInterfaceImplementer(address account, bytes32 _interfaceHash) external view returns (address);
220 
221     /**
222      * @dev Returns the interface hash for an `interfaceName`, as defined in the
223      * corresponding
224      * https://eips.ethereum.org/EIPS/eip-1820#interface-name[section of the EIP].
225      */
226     function interfaceHash(string calldata interfaceName) external pure returns (bytes32);
227 
228     /**
229      * @notice Updates the cache with whether the contract implements an ERC165 interface or not.
230      * @param account Address of the contract for which to update the cache.
231      * @param interfaceId ERC165 interface for which to update the cache.
232      */
233     function updateERC165Cache(address account, bytes4 interfaceId) external;
234 
235     /**
236      * @notice Checks whether a contract implements an ERC165 interface or not.
237      * If the result is not cached a direct lookup on the contract address is performed.
238      * If the result is not cached or the cached value is out-of-date, the cache MUST be updated manually by calling
239      * {updateERC165Cache} with the contract address.
240      * @param account Address of the contract to check.
241      * @param interfaceId ERC165 interface to check.
242      * @return True if `account` implements `interfaceId`, false otherwise.
243      */
244     function implementsERC165Interface(address account, bytes4 interfaceId) external view returns (bool);
245 
246     /**
247      * @notice Checks whether a contract implements an ERC165 interface or not without using nor updating the cache.
248      * @param account Address of the contract to check.
249      * @param interfaceId ERC165 interface to check.
250      * @return True if `account` implements `interfaceId`, false otherwise.
251      */
252     function implementsERC165InterfaceNoCache(address account, bytes4 interfaceId) external view returns (bool);
253 
254     event InterfaceImplementerSet(address indexed account, bytes32 indexed interfaceHash, address indexed implementer);
255 
256     event ManagerChanged(address indexed account, address indexed newManager);
257 }
258 
259 // File: contracts\Owned.sol
260 
261 
262 pragma solidity 0.8.11;
263 
264 contract Owned {
265 
266   address public owner = msg.sender;
267 
268   event LogOwnershipTransferred(address indexed owner, address indexed newOwner);
269 
270   modifier onlyOwner {
271     require(msg.sender == owner, "Only owner");
272     _;
273   }
274 
275   function setOwner(address _owner)
276     external
277     onlyOwner
278   {
279     require(_owner != address(0), "Owner cannot be zero address");
280     emit LogOwnershipTransferred(owner, _owner);
281     owner = _owner;
282   }
283 }
284 
285 // File: ..\contracts\AVN.sol
286 
287 
288 pragma solidity 0.8.11;
289 
290 
291 
292 
293 
294 
295 
296 
297 contract LegacyValidatorsManager {
298   uint256 public numActiveValidators;
299   uint256 public validatorIdNum;
300   mapping (uint256 => address) public t1Address;
301   mapping (uint256 => bytes32) public t2PublicKey;
302 }
303 
304 contract AVN is IAVN, IERC777Recipient, Owned {
305   // Universal address as defined in Registry Contract Address section of https://eips.ethereum.org/EIPS/eip-1820
306   IERC1820Registry constant internal ERC1820_REGISTRY = IERC1820Registry(0x1820a4B7618BdE71Dce8cdc73aAB6C95905faD24);
307   // keccak256("ERC777Token")
308   bytes32 constant internal ERC777_TOKEN_HASH = 0xac7fbab5f54a3ca8194167523c6753bfeb96a445279294b6125b68cce2177054;
309   // keccak256("ERC777TokensRecipient")
310   bytes32 constant internal ERC777_TOKENS_RECIPIENT_HASH = 0xb281fc8c12954d22544db45de3159a39272895b169a852b314f9cc762e44c53b;
311   uint256 constant internal SIGNATURE_LENGTH = 65;
312   uint256 constant internal LIFT_LIMIT = type(uint128).max;
313   address constant internal PSEUDO_ETH_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
314   IAvnFTTreasury immutable internal LEGACY_AVN_TREASURY;
315   LegacyValidatorsManager immutable internal LEGACY_AVN_VALIDATORS_MANAGER;
316 
317   mapping (uint256 => bool) public isRegisteredValidator;
318   mapping (uint256 => bool) public isActiveValidator;
319   mapping (address => uint256) public t1AddressToId;
320   mapping (bytes32 => uint256) public t2PublicKeyToId;
321   mapping (uint256 => address) public idToT1Address;
322   mapping (uint256 => bytes32) public idToT2PublicKey;
323   mapping (bytes2 => uint256) public numBytesToLowerData;
324   mapping (address => bool) public isAuthorisedContract;
325   mapping (bytes32 => bool) public isPublishedRootHash;
326   mapping (uint256 => bool) public isUsedT2TransactionId;
327   mapping (bytes32 => bool) public hasLowered;
328   mapping (bytes32 => bool) public hasLifted;
329 
330   address[] public authorisedContracts;
331   uint256[2] public quorum;
332 
333   uint256 public numActiveValidators;
334   uint256 public nextValidatorId;
335   uint256 public unliftedLegacyStakes;
336   bool public validatorFunctionsAreEnabled;
337   bool public liftingIsEnabled;
338   bool public loweringIsEnabled;
339   bool public validatorsTransferred;
340 
341   address immutable public avtAddress;
342 
343   constructor(address avt, LegacyValidatorsManager avnValidatorsManager, IAvnFTTreasury avnFTTreasury)
344   {
345     ERC1820_REGISTRY.setInterfaceImplementer(address(this), ERC777_TOKENS_RECIPIENT_HASH, address(this));
346     avtAddress = avt;
347     LEGACY_AVN_VALIDATORS_MANAGER = avnValidatorsManager;
348     LEGACY_AVN_TREASURY = avnFTTreasury;
349     numBytesToLowerData[0x2d00] = 133; // callID (2 bytes) + proof (2 prefix + 32 relayer + 32 signer + 1 prefix + 64 signature)
350     numBytesToLowerData[0x2700] = 133; // callID (2 bytes) + proof (2 prefix + 32 relayer + 32 signer + 1 prefix + 64 signature)
351     numBytesToLowerData[0x2702] = 2;   // callID (2 bytes)
352     validatorFunctionsAreEnabled = true;
353     liftingIsEnabled = true;
354     loweringIsEnabled = true;
355     nextValidatorId = 1;
356     quorum[0] = 2;
357     quorum[1] = 3;
358     unliftedLegacyStakes = 2500000000000000000000000; // 2,500,000 AVT in full atto AVT
359   }
360 
361   modifier onlyAuthorisedContract() {
362     require(isAuthorisedContract[msg.sender], "Access denied");
363     _;
364   }
365 
366   modifier onlyWhenLiftingIsEnabled() {
367     require(liftingIsEnabled, "Lifting currently disabled");
368     _;
369   }
370 
371   modifier onlyWhenValidatorFunctionsAreEnabled() {
372     require(validatorFunctionsAreEnabled, "Function currently disabled");
373     _;
374   }
375 
376   function transferValidators()
377     onlyOwner
378     external
379   {
380     require(validatorsTransferred == false, "Validators already transferred");
381     numActiveValidators = LEGACY_AVN_VALIDATORS_MANAGER.numActiveValidators();
382     nextValidatorId = LEGACY_AVN_VALIDATORS_MANAGER.validatorIdNum();
383 
384     for (uint256 id = 1; id < nextValidatorId; id++) {
385       idToT1Address[id] = LEGACY_AVN_VALIDATORS_MANAGER.t1Address(id);
386       idToT2PublicKey[id] = LEGACY_AVN_VALIDATORS_MANAGER.t2PublicKey(id);
387       t1AddressToId[idToT1Address[id]] = id;
388       t2PublicKeyToId[idToT2PublicKey[id]] = id;
389       isRegisteredValidator[id] = true;
390       isActiveValidator[id] = true;
391     }
392 
393     validatorsTransferred = true;
394   }
395 
396   function setAuthorisationStatus(address contractAddress, bool status)
397     onlyOwner
398     external
399   {
400     uint256 size;
401 
402     assembly {
403       size := extcodesize(contractAddress)
404     }
405 
406     require(size > 0, "Only contracts");
407 
408     if (status == isAuthorisedContract[contractAddress]) {
409       return;
410     } else if (status) {
411       isAuthorisedContract[contractAddress] = true;
412       authorisedContracts.push(contractAddress);
413     } else {
414       isAuthorisedContract[contractAddress] = false;
415       uint256 endContractAddress = authorisedContracts.length - 1;
416       for (uint256 i; i < endContractAddress; i++) {
417         if (authorisedContracts[i] == contractAddress) {
418           authorisedContracts[i] = authorisedContracts[endContractAddress];
419           break;
420         }
421       }
422       authorisedContracts.pop();
423     }
424     emit LogAuthorisationUpdated(contractAddress, status);
425   }
426 
427   function setQuorum(uint256[2] memory _quorum)
428     onlyOwner
429     public
430   {
431     require(_quorum[1] != 0, "Invalid: div by zero");
432     require(_quorum[0] <= _quorum[1], "Invalid: above 100%");
433     quorum = _quorum;
434     emit LogQuorumUpdated(quorum);
435   }
436 
437   function disableValidatorFunctions()
438     onlyOwner
439     external
440   {
441     validatorFunctionsAreEnabled = false;
442     emit LogValidatorFunctionsAreEnabled(false);
443   }
444 
445   function enableValidatorFunctions()
446     onlyOwner
447     external
448   {
449     validatorFunctionsAreEnabled = true;
450     emit LogValidatorFunctionsAreEnabled(true);
451   }
452 
453   function disableLifting()
454     onlyOwner
455     external
456   {
457     liftingIsEnabled = false;
458     emit LogLiftingIsEnabled(false);
459   }
460 
461   function enableLifting()
462     onlyOwner
463     external
464   {
465     liftingIsEnabled = true;
466     emit LogLiftingIsEnabled(true);
467   }
468 
469   function disableLowering()
470     onlyOwner
471     external
472   {
473     loweringIsEnabled = false;
474     emit LogLoweringIsEnabled(false);
475   }
476 
477   function enableLowering()
478     onlyOwner
479     external
480   {
481     loweringIsEnabled = true;
482     emit LogLoweringIsEnabled(true);
483   }
484 
485   function updateLowerCall(bytes2 callId, uint256 numBytes)
486     onlyOwner
487     external
488   {
489     numBytesToLowerData[callId] = numBytes;
490     emit LogLowerCallUpdated(callId, numBytes);
491   }
492 
493   function recoverERC777TokensFromLegacyTreasury(address erc777Address)
494     onlyOwner
495     external
496   {
497     uint256 lockedBalance = IERC777(erc777Address).balanceOf(address(LEGACY_AVN_TREASURY));
498     LEGACY_AVN_TREASURY.unlockERC777Tokens(erc777Address, lockedBalance, "");
499   }
500 
501   function recoverERC20TokensFromLegacyTreasury(address erc20Address)
502     onlyOwner
503     external
504   {
505     uint256 lockedBalance = IERC20(erc20Address).balanceOf(address(LEGACY_AVN_TREASURY));
506     LEGACY_AVN_TREASURY.unlockERC20Tokens(erc20Address, lockedBalance);
507   }
508 
509   function liftLegacyStakes(bytes calldata t2PublicKey, uint256 amount)
510     onlyOwner
511     external
512   {
513     require(amount <= unliftedLegacyStakes, "Not enough stake remaining");
514     bytes32 checkedT2PublicKey = checkT2PublicKey(t2PublicKey);
515     unliftedLegacyStakes = unliftedLegacyStakes - amount;
516     emit LogLifted(avtAddress, address(this), checkedT2PublicKey, amount);
517   }
518 
519   function registerValidator(bytes memory t1PublicKey, bytes32 t2PublicKey, uint256 t2TransactionId,
520       bytes calldata confirmations)
521     onlyWhenValidatorFunctionsAreEnabled
522     external
523   {
524     require(t1PublicKey.length == 64, "T1 public key must be 64 bytes");
525     address t1Address = address(uint160(uint256(keccak256(t1PublicKey))));
526     uint256 id = t1AddressToId[t1Address];
527     require(isRegisteredValidator[id] == false, "Validator is already registered");
528 
529     // The order of the elements is the reverse of the deregisterValidatorHash
530     bytes32 registerValidatorHash = keccak256(abi.encodePacked(t1PublicKey, t2PublicKey));
531     verifyConfirmations(toConfirmationHash(registerValidatorHash, t2TransactionId), confirmations);
532     doStoreT2TransactionId(t2TransactionId);
533 
534     if (id == 0) {
535       require(t2PublicKeyToId[t2PublicKey] == 0, "T2 public key already in use");
536       id = nextValidatorId;
537       idToT1Address[id] = t1Address;
538       t1AddressToId[t1Address] = id;
539       idToT2PublicKey[id] = t2PublicKey;
540       t2PublicKeyToId[t2PublicKey] = id;
541       nextValidatorId++;
542     } else {
543       require(idToT2PublicKey[id] == t2PublicKey, "Cannot change T2 public key");
544     }
545 
546     isRegisteredValidator[id] = true;
547 
548     bytes32 t1PublicKeyLHS;
549     bytes32 t1PublicKeyRHS;
550     assembly {
551       t1PublicKeyLHS := mload(add(t1PublicKey, 0x20))
552       t1PublicKeyRHS := mload(add(t1PublicKey, 0x40))
553     }
554 
555     emit LogValidatorRegistered(t1PublicKeyLHS, t1PublicKeyRHS, t2PublicKey, t2TransactionId);
556   }
557 
558   function deregisterValidator(bytes memory t1PublicKey, bytes32 t2PublicKey, uint256 t2TransactionId,
559       bytes calldata confirmations)
560     onlyWhenValidatorFunctionsAreEnabled
561     external
562   {
563     uint256 id = t2PublicKeyToId[t2PublicKey];
564     require(isRegisteredValidator[id], "Validator is not registered");
565 
566     // The order of the elements is the reverse of the registerValidatorHash
567     bytes32 deregisterValidatorHash = keccak256(abi.encodePacked(t2PublicKey, t1PublicKey));
568     verifyConfirmations(toConfirmationHash(deregisterValidatorHash, t2TransactionId), confirmations);
569     doStoreT2TransactionId(t2TransactionId);
570 
571     isRegisteredValidator[id] = false;
572     isActiveValidator[id] = false;
573     numActiveValidators--;
574 
575     bytes32 t1PublicKeyLHS;
576     bytes32 t1PublicKeyRHS;
577     assembly {
578       t1PublicKeyLHS := mload(add(t1PublicKey, 0x20))
579       t1PublicKeyRHS := mload(add(t1PublicKey, 0x40))
580     }
581 
582     emit LogValidatorDeregistered(t1PublicKeyLHS, t1PublicKeyRHS, t2PublicKey, t2TransactionId);
583   }
584 
585   function publishRoot(bytes32 rootHash, uint256 t2TransactionId, bytes calldata confirmations)
586     onlyWhenValidatorFunctionsAreEnabled
587     external
588   {
589     verifyConfirmations(toConfirmationHash(rootHash, t2TransactionId), confirmations);
590     doStoreT2TransactionId(t2TransactionId);
591     doStoreRootHash(rootHash);
592     emit LogRootPublished(rootHash, t2TransactionId);
593   }
594 
595   function storeT2TransactionId(uint256 t2TransactionId)
596     onlyAuthorisedContract
597     external
598   {
599     doStoreT2TransactionId(t2TransactionId);
600   }
601 
602   function storeRootHash(bytes32 rootHash)
603     onlyAuthorisedContract
604     external
605   {
606     doStoreRootHash(rootHash);
607   }
608 
609   function storeLiftProofHash(bytes32 proofHash)
610     onlyAuthorisedContract
611     external
612   {
613     doStoreLiftProofHash(proofHash);
614   }
615 
616   function storeLoweredLeafHash(bytes32 leafHash)
617     onlyAuthorisedContract
618     external
619   {
620     doStoreLoweredLeafHash(leafHash);
621   }
622 
623   function unlockETH(address payable recipient, uint256 amount)
624     onlyAuthorisedContract
625     external
626   {
627     (bool success, ) = recipient.call{value: amount}("");
628     require(success, "ETH transfer failed");
629   }
630 
631   function unlockERC777Tokens(address erc777Address, address recipient, uint256 amount)
632     onlyAuthorisedContract
633     external
634   {
635     IERC777(erc777Address).send(recipient, amount, "");
636   }
637 
638   function unlockERC20Tokens(address erc20Address, address recipient, uint256 amount)
639     onlyAuthorisedContract
640     external
641   {
642     assert(IERC20(erc20Address).transfer(recipient, amount));
643   }
644 
645   function getAuthorisedContracts()
646     external
647     view
648     returns (address[] memory)
649   {
650     return authorisedContracts;
651   }
652 
653   function getIsPublishedRootHash(bytes32 rootHash)
654     external
655     view
656     returns (bool)
657   {
658     return isPublishedRootHash[rootHash];
659   }
660 
661   function lift(address erc20Address, bytes calldata t2PublicKey, uint256 amount)
662     onlyWhenLiftingIsEnabled
663     external
664   {
665     doLift(erc20Address, msg.sender, t2PublicKey, amount);
666   }
667 
668   function proxyLift(address erc20Address, bytes calldata t2PublicKey, uint256 amount, address approver, uint256 proofNonce,
669       bytes calldata proof)
670     onlyWhenLiftingIsEnabled
671     external
672   {
673     if (msg.sender != approver) {
674       doStoreLiftProofHash(keccak256(proof));
675       bytes32 msgHash = keccak256(abi.encodePacked(erc20Address, t2PublicKey, amount, proofNonce));
676       address signer = recoverSigner(keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", msgHash)), proof);
677       require(signer == approver, "Lift proof invalid");
678     }
679     doLift(erc20Address, approver, t2PublicKey, amount);
680   }
681 
682   function liftETH(bytes calldata t2PublicKey)
683     payable
684     onlyWhenLiftingIsEnabled
685     external
686   {
687     bytes32 checkedT2PublicKey = checkT2PublicKey(t2PublicKey);
688     require(msg.value > 0, "Cannot lift zero ETH");
689     emit LogLifted(PSEUDO_ETH_ADDRESS, msg.sender, checkedT2PublicKey, msg.value);
690   }
691 
692   // ERC-777 automatic lifting
693   function tokensReceived(address /* operator */, address from, address to, uint256 amount, bytes calldata data,
694       bytes calldata /* operatorData */)
695     onlyWhenLiftingIsEnabled
696     external
697   {
698     if (from == address(LEGACY_AVN_TREASURY)) return; // recovering funds from the legacy treasury so we don't lift here
699     require(to == address(this), "Tokens must be sent to this contract");
700     require(amount > 0, "Cannot lift zero ERC777 tokens");
701     bytes32 checkedT2PublicKey = checkT2PublicKey(data);
702     require(ERC1820_REGISTRY.getInterfaceImplementer(msg.sender, ERC777_TOKEN_HASH) == msg.sender, "Token must be registered");
703     IERC777 erc777Contract = IERC777(msg.sender);
704     require(erc777Contract.balanceOf(address(this)) <= LIFT_LIMIT, "Exceeds ERC777 lift limit");
705     emit LogLifted(msg.sender, from, checkedT2PublicKey, amount);
706   }
707 
708   function lower(bytes memory leaf, bytes32[] calldata merklePath)
709     external
710   {
711     require(loweringIsEnabled, "Lowering currently disabled");
712     bytes32 leafHash = keccak256(leaf);
713     require(confirmAvnTransaction(leafHash, merklePath), "Leaf or path invalid");
714     doStoreLoweredLeafHash(leafHash);
715 
716     uint256 ptr;
717     ptr += getCompactIntegerByteSize(leaf[ptr]); // add number of bytes encoding the leaf length
718     require(uint8(leaf[ptr]) & 128 != 0, "Unsigned transaction"); // bitwise version check to ensure leaf is signed transaction
719     ptr += 99; // version (1 byte) + multiAddress type (1 byte) + sender (32 bytes) + curve type (1 byte) + signature (64 bytes)
720     ptr += leaf[ptr] == 0x00 ? 1 : 2; // add number of era bytes (immortal is 1, otherwise 2)
721     ptr += getCompactIntegerByteSize(leaf[ptr]); // add number of bytes encoding the nonce
722     ptr += getCompactIntegerByteSize(leaf[ptr]); // add number of bytes encoding the tip
723     ptr += 32; // account for the first 32 EVM bytes holding the leaf's length
724 
725     bytes2 callId;
726 
727     assembly {
728       callId := mload(add(leaf, ptr))
729     }
730 
731     require(numBytesToLowerData[callId] != 0, "Not a lower leaf");
732     ptr += numBytesToLowerData[callId];
733     bytes32 t2PublicKey;
734     address token;
735     uint128 amount;
736     address t1Address;
737 
738     assembly {
739       t2PublicKey := mload(add(leaf, ptr)) // load next 32 bytes into 32 byte type starting at ptr
740       token := mload(add(add(leaf, 20), ptr)) // load leftmost 20 of next 32 bytes into 20 byte type starting at ptr + 20
741       amount := mload(add(add(leaf, 36), ptr)) // load leftmost 16 of next 32 bytes into 16 byte type starting at ptr + 20 + 16
742       t1Address := mload(add(add(leaf, 56), ptr)) // load leftmost 20 of next 32 bytes type starting at ptr + 20 + 16 + 20
743     }
744 
745     // amount was encoded in little endian so we need to reverse to big endian:
746     amount = ((amount & 0xFF00FF00FF00FF00FF00FF00FF00FF00) >> 8) | ((amount & 0x00FF00FF00FF00FF00FF00FF00FF00FF) << 8);
747     amount = ((amount & 0xFFFF0000FFFF0000FFFF0000FFFF0000) >> 16) | ((amount & 0x0000FFFF0000FFFF0000FFFF0000FFFF) << 16);
748     amount = ((amount & 0xFFFFFFFF00000000FFFFFFFF00000000) >> 32) | ((amount & 0x00000000FFFFFFFF00000000FFFFFFFF) << 32);
749     amount = (amount >> 64) | (amount << 64);
750 
751     if (token == PSEUDO_ETH_ADDRESS) {
752       (bool success, ) = payable(t1Address).call{value: amount}("");
753       require(success, "ETH transfer failed");
754     } else if (ERC1820_REGISTRY.getInterfaceImplementer(token, ERC777_TOKEN_HASH) == token) {
755       IERC777(token).send(t1Address, amount, "");
756     } else {
757       assert(IERC20(token).transfer(t1Address, amount));
758     }
759 
760     emit LogLowered(token, t1Address, t2PublicKey, amount);
761   }
762 
763   function confirmAvnTransaction(bytes32 leafHash, bytes32[] memory merklePath)
764     public
765     view
766     returns (bool)
767   {
768     bytes32 rootHash = leafHash;
769 
770     for (uint256 i; i < merklePath.length; i++) {
771       bytes32 node = merklePath[i];
772       if (rootHash < node)
773         rootHash = keccak256(abi.encode(rootHash, node));
774       else
775         rootHash = keccak256(abi.encode(node, rootHash));
776     }
777 
778     return isPublishedRootHash[rootHash];
779   }
780 
781   // reference: https://docs.substrate.io/v3/advanced/scale-codec/#compactgeneral-integers
782   function getCompactIntegerByteSize(bytes1 checkByte)
783     private
784     pure
785     returns (uint256 byteLength)
786   {
787     uint8 mode = uint8(checkByte) & 3; // the 2 least significant bits encode the byte mode so we do a bitwise AND on them
788 
789     if (mode == 0) { // single-byte mode
790       byteLength = 1;
791     } else if (mode == 1) { // two-byte mode
792       byteLength = 2;
793     } else if (mode == 2) { // four-byte mode
794       byteLength = 4;
795     } else {
796       byteLength = uint8(checkByte >> 2) + 5; // upper 6 bits + 4 are the number of bytes following + 1 for the checkbyte itself
797     }
798   }
799 
800   function toConfirmationHash(bytes32 data, uint256 t2TransactionId)
801     private
802     view
803     returns (bytes32)
804   {
805     return keccak256(abi.encode(data, t2TransactionId, idToT2PublicKey[t1AddressToId[msg.sender]]));
806   }
807 
808   function verifyConfirmations(bytes32 msgHash, bytes memory confirmations)
809     private
810   {
811     bytes32 ethSignedPrefixMsgHash = keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", msgHash));
812     uint256 numConfirmations = confirmations.length / SIGNATURE_LENGTH;
813     uint256 requiredConfirmations = numActiveValidators * quorum[0] / quorum[1] + 1;
814     uint256 validConfirmations;
815     uint256 id;
816     bytes32 r;
817     bytes32 s;
818     uint8 v;
819     bool[] memory confirmed = new bool[](nextValidatorId);
820 
821     for (uint256 i; i < numConfirmations; i++) {
822       assembly {
823         let offset := mul(i, SIGNATURE_LENGTH)
824         r := mload(add(confirmations, add(0x20, offset)))
825         s := mload(add(confirmations, add(0x40, offset)))
826         v := byte(0, mload(add(confirmations, add(0x60, offset))))
827       }
828       if (v < 27) v += 27;
829       if (v != 27 && v != 28 || uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
830         continue;
831       } else {
832         id = t1AddressToId[ecrecover(ethSignedPrefixMsgHash, v, r, s)];
833 
834         if (isActiveValidator[id] == false) {
835           if (isRegisteredValidator[id]) {
836             // Here we activate any previously registered but as yet unactivated validators
837             isActiveValidator[id] = true;
838             numActiveValidators++;
839             validConfirmations++;
840             confirmed[id] = true;
841           }
842         } else if (confirmed[id] == false) {
843           validConfirmations++;
844           confirmed[id] = true;
845         }
846       }
847       if (validConfirmations == requiredConfirmations) break;
848     }
849 
850     require(validConfirmations == requiredConfirmations, "Invalid confirmations");
851   }
852 
853   function doStoreT2TransactionId(uint256 t2TransactionId)
854     private
855   {
856     require(isUsedT2TransactionId[t2TransactionId] == false, "T2 transaction must be unique");
857     isUsedT2TransactionId[t2TransactionId] = true;
858   }
859 
860   function doStoreRootHash(bytes32 rootHash)
861     private
862   {
863     require(isPublishedRootHash[rootHash] == false, "Root already exists");
864     isPublishedRootHash[rootHash] = true;
865   }
866 
867   function doStoreLiftProofHash(bytes32 proofHash)
868     private
869   {
870     require(hasLifted[proofHash] == false, "Lift proof already used");
871     hasLifted[proofHash] = true;
872   }
873 
874   function doStoreLoweredLeafHash(bytes32 leafHash)
875     private
876   {
877     require(hasLowered[leafHash] == false, "Already lowered");
878     hasLowered[leafHash] = true;
879   }
880 
881   function doLift(address erc20Address, address approver, bytes memory t2PublicKey, uint256 amount)
882     private
883   {
884     require(ERC1820_REGISTRY.getInterfaceImplementer(erc20Address, ERC777_TOKEN_HASH) == address(0), "ERC20 lift only");
885     require(amount > 0, "Cannot lift zero ERC20 tokens");
886     bytes32 checkedT2PublicKey = checkT2PublicKey(t2PublicKey);
887     IERC20 erc20Contract = IERC20(erc20Address);
888     uint256 currentBalance = erc20Contract.balanceOf(address(this));
889     assert(erc20Contract.transferFrom(approver, address(this), amount));
890     uint256 newBalance = erc20Contract.balanceOf(address(this));
891     require(newBalance <= LIFT_LIMIT, "Exceeds ERC20 lift limit");
892     emit LogLifted(erc20Address, approver, checkedT2PublicKey, newBalance - currentBalance);
893   }
894 
895   function checkT2PublicKey(bytes memory t2PublicKey)
896     private
897     pure
898     returns (bytes32 checkedT2PublicKey)
899   {
900     require(t2PublicKey.length == 32, "Bad T2 public key");
901     checkedT2PublicKey = bytes32(t2PublicKey);
902   }
903 
904   function recoverSigner(bytes32 hash, bytes memory signature)
905     private
906     pure
907     returns (address)
908   {
909     if (signature.length != 65) return address(0);
910 
911     bytes32 r;
912     bytes32 s;
913     uint8 v;
914 
915     assembly {
916       r := mload(add(signature, 0x20))
917       s := mload(add(signature, 0x40))
918       v := byte(0, mload(add(signature, 0x60)))
919     }
920 
921     if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) return address(0);
922     if (v < 27) v += 27;
923     if (v != 27 && v != 28) return address(0);
924 
925     return ecrecover(hash, v, r, s);
926   }
927 }
