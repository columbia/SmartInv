1 pragma solidity 0.5.11; // optimization runs: 200, evm version: petersburg
2 
3 
4 interface DharmaKeyRingFactoryV2Interface {
5   // Fires an event when a new key ring is deployed and initialized.
6   event KeyRingDeployed(address keyRing, address userSigningKey);
7 
8   function newKeyRing(
9     address userSigningKey, address targetKeyRing
10   ) external returns (address keyRing);
11 
12   function newKeyRingAndAdditionalKey(
13     address userSigningKey,
14     address targetKeyRing,
15     address additionalSigningKey,
16     bytes calldata signature
17   ) external returns (address keyRing);
18 
19   function newKeyRingAndDaiWithdrawal(
20     address userSigningKey,
21     address targetKeyRing,
22     address smartWallet,
23     uint256 amount,
24     address recipient,
25     uint256 minimumActionGas,
26     bytes calldata userSignature,
27     bytes calldata dharmaSignature
28   ) external returns (address keyRing, bool withdrawalSuccess);
29 
30   function newKeyRingAndUSDCWithdrawal(
31     address userSigningKey,
32     address targetKeyRing,
33     address smartWallet,
34     uint256 amount,
35     address recipient,
36     uint256 minimumActionGas,
37     bytes calldata userSignature,
38     bytes calldata dharmaSignature
39   ) external returns (address keyRing, bool withdrawalSuccess);
40 
41   function getNextKeyRing(
42     address userSigningKey
43   ) external view returns (address targetKeyRing);
44 
45   function getFirstKeyRingAdminActionID(
46     address keyRing, address additionalUserSigningKey
47   ) external view returns (bytes32 adminActionID);
48 }
49 
50 
51 interface DharmaKeyRingImplementationV0Interface {
52   enum AdminActionType {
53     AddStandardKey,
54     RemoveStandardKey,
55     SetStandardThreshold,
56     AddAdminKey,
57     RemoveAdminKey,
58     SetAdminThreshold,
59     AddDualKey,
60     RemoveDualKey,
61     SetDualThreshold
62   }
63 
64   function takeAdminAction(
65     AdminActionType adminActionType, uint160 argument, bytes calldata signatures
66   ) external;
67 
68   function getVersion() external view returns (uint256 version);
69 }
70 
71 
72 interface DharmaSmartWalletImplementationV0Interface {
73   function withdrawDai(
74     uint256 amount,
75     address recipient,
76     uint256 minimumActionGas,
77     bytes calldata userSignature,
78     bytes calldata dharmaSignature
79   ) external returns (bool ok);
80 
81   function withdrawUSDC(
82     uint256 amount,
83     address recipient,
84     uint256 minimumActionGas,
85     bytes calldata userSignature,
86     bytes calldata dharmaSignature
87   ) external returns (bool ok);
88 }
89 
90 
91 interface DharmaKeyRingInitializer {
92   function initialize(
93     uint128 adminThreshold,
94     uint128 executorThreshold,
95     address[] calldata keys,
96     uint8[] calldata keyTypes
97   ) external;
98 }
99 
100 
101 /**
102  * @title KeyRingUpgradeBeaconProxyV1
103  * @author 0age
104  * @notice This contract delegates all logic, including initialization, to a key
105  * ring implementation contract specified by a hard-coded "upgrade beacon". Note
106  * that this implementation can be reduced in size by stripping out the metadata
107  * hash, or even more significantly by using a minimal upgrade beacon proxy
108  * implemented using raw EVM opcodes.
109  */
110 contract KeyRingUpgradeBeaconProxyV1 {
111   // Set upgrade beacon address as a constant (i.e. not in contract storage).
112   address private constant _KEY_RING_UPGRADE_BEACON = address(
113     0x0000000000BDA2152794ac8c76B2dc86cbA57cad
114   );
115 
116   /**
117    * @notice In the constructor, perform initialization via delegatecall to the
118    * implementation set on the key ring upgrade beacon, supplying initialization
119    * calldata as a constructor argument. The deployment will revert and pass
120    * along the revert reason if the initialization delegatecall reverts.
121    * @param initializationCalldata Calldata to supply when performing the
122    * initialization delegatecall.
123    */
124   constructor(bytes memory initializationCalldata) public payable {
125     // Delegatecall into the implementation, supplying initialization calldata.
126     (bool ok, ) = _implementation().delegatecall(initializationCalldata);
127     
128     // Revert and include revert data if delegatecall to implementation reverts.
129     if (!ok) {
130       assembly {
131         returndatacopy(0, 0, returndatasize)
132         revert(0, returndatasize)
133       }
134     }
135   }
136 
137   /**
138    * @notice In the fallback, delegate execution to the implementation set on
139    * the key ring upgrade beacon.
140    */
141   function () external payable {
142     // Delegate execution to implementation contract provided by upgrade beacon.
143     _delegate(_implementation());
144   }
145 
146   /**
147    * @notice Private view function to get the current implementation from the
148    * key ring upgrade beacon. This is accomplished via a staticcall to the key
149    * ring upgrade beacon with no data, and the beacon will return an abi-encoded
150    * implementation address.
151    * @return implementation Address of the implementation.
152    */
153   function _implementation() private view returns (address implementation) {
154     // Get the current implementation address from the upgrade beacon.
155     (bool ok, bytes memory returnData) = _KEY_RING_UPGRADE_BEACON.staticcall("");
156     
157     // Revert and pass along revert message if call to upgrade beacon reverts.
158     require(ok, string(returnData));
159 
160     // Set the implementation to the address returned from the upgrade beacon.
161     implementation = abi.decode(returnData, (address));
162   }
163 
164   /**
165    * @notice Private function that delegates execution to an implementation
166    * contract. This is a low level function that doesn't return to its internal
167    * call site. It will return whatever is returned by the implementation to the
168    * external caller, reverting and returning the revert data if implementation
169    * reverts.
170    * @param implementation Address to delegate.
171    */
172   function _delegate(address implementation) private {
173     assembly {
174       // Copy msg.data. We take full control of memory in this inline assembly
175       // block because it will not return to Solidity code. We overwrite the
176       // Solidity scratch pad at memory position 0.
177       calldatacopy(0, 0, calldatasize)
178 
179       // Delegatecall to the implementation, supplying calldata and gas.
180       // Out and outsize are set to zero - instead, use the return buffer.
181       let result := delegatecall(gas, implementation, 0, calldatasize, 0, 0)
182 
183       // Copy the returned data from the return buffer.
184       returndatacopy(0, 0, returndatasize)
185 
186       switch result
187       // Delegatecall returns 0 on error.
188       case 0 { revert(0, returndatasize) }
189       default { return(0, returndatasize) }
190     }
191   }
192 }
193 
194 
195 /**
196  * @title DharmaKeyRingFactoryV2
197  * @author 0age
198  * @notice This contract deploys new Dharma Key Ring instances as "Upgrade
199  * Beacon" proxies that reference a shared implementation contract specified by
200  * the Dharma Key Ring Upgrade Beacon contract. It also supplies methods for
201  * performing additional operations post-deployment, including setting a second
202  * signing key on the keyring and making a withdrawal from the associated smart
203  * wallet. Note that the batch operations may fail, or be applied to the wrong
204  * keyring, if another caller frontruns them by deploying a keyring to the
205  * intended address first. If this becomes an issue, a future version of this
206  * factory can remedy this by passing the target deployment address as an
207  * additional argument and checking for existence of a contract at that address.
208  * This factory builds on V1 by additionally including a helper function for
209  * deriving adminActionIDs for keyrings that have not yet been deployed in order
210  * to support creation of the signature parameter provided as part of calls to
211  * `newKeyRingAndAdditionalKey`.
212  */
213 contract DharmaKeyRingFactoryV2 is DharmaKeyRingFactoryV2Interface {
214   // Use DharmaKeyRing initialize selector to construct initialization calldata.
215   bytes4 private constant _INITIALIZE_SELECTOR = bytes4(0x30fc201f);
216 
217   // The keyring upgrade beacon is used in order to get the current version.
218   address private constant _KEY_RING_UPGRADE_BEACON = address(
219     0x0000000000BDA2152794ac8c76B2dc86cbA57cad
220   );
221 
222   /**
223    * @notice In the constructor, ensure that the initialize selector constant is
224    * correct.
225    */
226   constructor() public {
227     DharmaKeyRingInitializer initializer;
228     require(
229       initializer.initialize.selector == _INITIALIZE_SELECTOR,
230       "Incorrect initializer selector supplied."
231     );
232   }
233 
234   /**
235    * @notice Deploy a new key ring contract using the provided user signing key.
236    * @param userSigningKey address The user signing key, supplied as a
237    * constructor argument.
238    * @param targetKeyRing address The expected counterfactual address of the new
239    * keyring - if a contract is already deployed to this address, the deployment
240    * step will be skipped (supply the null address for this argument to force a
241    * deployment of a new key ring).
242    * @return The address of the new key ring.
243    */
244   function newKeyRing(
245     address userSigningKey, address targetKeyRing
246   ) external returns (address keyRing) {
247     // Deploy and initialize a keyring if needed and emit a corresponding event.
248     keyRing = _deployNewKeyRingIfNeeded(userSigningKey, targetKeyRing);
249   }
250 
251   /**
252    * @notice Deploy a new key ring contract using the provided user signing key
253    * and immediately add a second signing key to the key ring.
254    * @param userSigningKey address The user signing key, supplied as a
255    * constructor argument.
256    * @param targetKeyRing address The expected counterfactual address of the new
257    * keyring - if a contract is already deployed to this address, the deployment
258    * step will be skipped and the supplied address will be used for all
259    * subsequent steps.
260    * @param additionalSigningKey address The second user signing key, supplied
261    * as an argument to `takeAdminAction` on the newly-deployed keyring.
262    * @param signature bytes A signature approving the addition of the second key
263    * that has been signed by the first key.
264    * @return The address of the new key ring.
265    */
266   function newKeyRingAndAdditionalKey(
267     address userSigningKey,
268     address targetKeyRing,
269     address additionalSigningKey,
270     bytes calldata signature
271   ) external returns (address keyRing) {
272     // Deploy and initialize a keyring if needed and emit a corresponding event.
273     keyRing = _deployNewKeyRingIfNeeded(userSigningKey, targetKeyRing);
274 
275     // Set the additional key on the newly-deployed keyring.
276     DharmaKeyRingImplementationV0Interface(keyRing).takeAdminAction(
277       DharmaKeyRingImplementationV0Interface.AdminActionType.AddDualKey,
278       uint160(additionalSigningKey),
279       signature
280     );
281   }
282 
283   /**
284    * @notice Deploy a new key ring contract using the provided user signing key
285    * and immediately make a Dai withdrawal from the supplied smart wallet.
286    * @param userSigningKey address The user signing key, supplied as a
287    * constructor argument.
288    * @param targetKeyRing address The expected counterfactual address of the new
289    * keyring - if a contract is already deployed to this address, the deployment
290    * step will be skipped and the supplied address will be used for all
291    * subsequent steps.
292    * @param smartWallet address The smart wallet to make the withdrawal from and
293    * that has the keyring to be deployed set as its user singing address.
294    * @param amount uint256 The amount of Dai to withdraw.
295    * @param recipient address The account to transfer the withdrawn Dai to.
296    * @param minimumActionGas uint256 The minimum amount of gas that must be
297    * provided to the call to the smart wallet - be aware that additional gas
298    * must still be included to account for the cost of overhead incurred up
299    * until the start of the function call.
300    * @param userSignature bytes A signature that resolves to userSigningKey set
301    * on the keyring and resolved using ERC1271. A unique hash returned from
302    * `getCustomActionID` on the smart wallet is prefixed and hashed to create
303    * the message hash for the signature.
304    * @param dharmaSignature bytes A signature that resolves to the public key
305    * returned for the smart wallet from the Dharma Key Registry. A unique hash
306    * returned from `getCustomActionID` on the smart wallet is prefixed and
307    * hashed to create the signed message.
308    * @return The address of the new key ring and the success status of the
309    * withdrawal.
310    */
311   function newKeyRingAndDaiWithdrawal(
312     address userSigningKey,
313     address targetKeyRing,
314     address smartWallet,
315     uint256 amount,
316     address recipient,
317     uint256 minimumActionGas,
318     bytes calldata userSignature,
319     bytes calldata dharmaSignature
320   ) external returns (address keyRing, bool withdrawalSuccess) {
321     // Deploy and initialize a keyring if needed and emit a corresponding event.
322     keyRing = _deployNewKeyRingIfNeeded(userSigningKey, targetKeyRing);
323 
324     // Attempt to withdraw Dai from the provided smart wallet.
325     withdrawalSuccess = DharmaSmartWalletImplementationV0Interface(
326       smartWallet
327     ).withdrawDai(
328       amount, recipient, minimumActionGas, userSignature, dharmaSignature
329     );
330   }
331 
332   /**
333    * @notice Deploy a new key ring contract using the provided user signing key
334    * and immediately make a USDC withdrawal from the supplied smart wallet.
335    * @param userSigningKey address The user signing key, supplied as a
336    * constructor argument.
337    * @param targetKeyRing address The expected counterfactual address of the new
338    * keyring - if a contract is already deployed to this address, the deployment
339    * step will be skipped and the supplied address will be used for all
340    * subsequent steps.
341    * @param smartWallet address The smart wallet to make the withdrawal from and
342    * that has the keyring to be deployed set as its user singing address.
343    * @param amount uint256 The amount of USDC to withdraw.
344    * @param recipient address The account to transfer the withdrawn USDC to.
345    * @param minimumActionGas uint256 The minimum amount of gas that must be
346    * provided to the call to the smart wallet - be aware that additional gas
347    * must still be included to account for the cost of overhead incurred up
348    * until the start of the function call.
349    * @param userSignature bytes A signature that resolves to userSigningKey set
350    * on the keyring and resolved using ERC1271. A unique hash returned from
351    * `getCustomActionID` on the smart wallet is prefixed and hashed to create
352    * the message hash for the signature.
353    * @param dharmaSignature bytes A signature that resolves to the public key
354    * returned for the smart wallet from the Dharma Key Registry. A unique hash
355    * returned from `getCustomActionID` on the smart wallet is prefixed and
356    * hashed to create the signed message.
357    * @return The address of the new key ring and the success status of the
358    * withdrawal.
359    */
360   function newKeyRingAndUSDCWithdrawal(
361     address userSigningKey,
362     address targetKeyRing,
363     address smartWallet,
364     uint256 amount,
365     address recipient,
366     uint256 minimumActionGas,
367     bytes calldata userSignature,
368     bytes calldata dharmaSignature
369   ) external returns (address keyRing, bool withdrawalSuccess) {
370     // Deploy and initialize a keyring if needed and emit a corresponding event.
371     keyRing = _deployNewKeyRingIfNeeded(userSigningKey, targetKeyRing);
372 
373     // Attempt to withdraw USDC from the provided smart wallet.
374     withdrawalSuccess = DharmaSmartWalletImplementationV0Interface(
375       smartWallet
376     ).withdrawUSDC(
377       amount, recipient, minimumActionGas, userSignature, dharmaSignature
378     );
379   }
380 
381   /**
382    * @notice View function to find the address of the next key ring address that
383    * will be deployed for a given user signing key. Note that a new value will
384    * be returned if a particular user signing key has been used before.
385    * @param userSigningKey address The user signing key, supplied as a
386    * constructor argument.
387    * @return The future address of the next key ring.
388    */
389   function getNextKeyRing(
390     address userSigningKey
391   ) external view returns (address targetKeyRing) {
392     // Ensure that a user signing key has been provided.
393     require(userSigningKey != address(0), "No user signing key supplied.");
394 
395     // Get initialization calldata using the initial user signing key.
396     bytes memory initializationCalldata = _constructInitializationCalldata(
397       userSigningKey
398     );
399 
400     // Determine target key ring address based on the user signing key.
401     targetKeyRing = _computeNextAddress(initializationCalldata);
402   }
403 
404   /**
405    * @notice View function for deriving the adminActionID that must be signed in
406    * order to add a new key to a given key ring that has not yet been deployed
407    * based on given parameters.
408    * @param keyRing address The yet-to-be-deployed keyring address.
409    * @param additionalUserSigningKey address The additional user signing key to
410    * add.
411    * @return The adminActionID that will be prefixed, hashed, and signed.
412    */
413   function getFirstKeyRingAdminActionID(
414     address keyRing, address additionalUserSigningKey
415   ) external view returns (bytes32 adminActionID) {
416     adminActionID = keccak256(
417       abi.encodePacked(
418         keyRing, _getKeyRingVersion(), uint256(0), additionalUserSigningKey
419       )
420     );
421   }
422 
423   /**
424    * @notice Internal function to deploy a new key ring contract if needed using
425    * the provided user signing key. The expected keyring address is supplied as
426    * an argument, and if a contract is already deployed to that address then the
427    * deployment will be skipped and the supplied address will be returned.
428    * @param userSigningKey address The user signing key, supplied as a
429    * constructor argument during deployment.
430    * @return The address of the new key ring, or of the supplied key ring if a
431    * contract already exists at the supplied address.
432    */
433   function _deployNewKeyRingIfNeeded(
434     address userSigningKey, address expectedKeyRing
435   ) internal returns (address keyRing) {
436     // Only deploy if a key ring doesn't already exist at the expected address.
437     uint256 size;
438     assembly { size := extcodesize(expectedKeyRing) }
439     if (size == 0) {
440       // Get initialization calldata using the initial user signing key.
441       bytes memory initializationCalldata = _constructInitializationCalldata(
442         userSigningKey
443       );
444 
445       // Deploy and initialize new user key ring as an Upgrade Beacon proxy.
446       keyRing = _deployUpgradeBeaconProxyInstance(initializationCalldata);
447 
448       // Emit an event to signal the creation of the new key ring contract.
449       emit KeyRingDeployed(keyRing, userSigningKey);
450     } else {
451       // Note: specifying an address that was not returned from `getNextKeyRing`
452       // will cause this assumption to fail. Furthermore, the key ring at the
453       // expected address may have been modified so that the supplied user
454       // signing key is no longer a valid key - therefore, treat this helper as
455       // a way to protect against race conditions, not as a primary mechanism
456       // for interacting with key ring contracts.
457       keyRing = expectedKeyRing;
458     }
459   }
460 
461   /**
462    * @notice Private function to deploy an upgrade beacon proxy via `CREATE2`.
463    * @param initializationCalldata bytes The calldata that will be supplied to
464    * the `DELEGATECALL` from the deployed contract to the implementation set on
465    * the upgrade beacon during contract creation.
466    * @return The address of the newly-deployed upgrade beacon proxy.
467    */
468   function _deployUpgradeBeaconProxyInstance(
469     bytes memory initializationCalldata
470   ) private returns (address upgradeBeaconProxyInstance) {
471     // Place creation code and constructor args of new proxy instance in memory.
472     bytes memory initCode = abi.encodePacked(
473       type(KeyRingUpgradeBeaconProxyV1).creationCode,
474       abi.encode(initializationCalldata)
475     );
476 
477     // Get salt to use during deployment using the supplied initialization code.
478     (uint256 salt, ) = _getSaltAndTarget(initCode);
479 
480     // Deploy the new upgrade beacon proxy contract using `CREATE2`.
481     assembly {
482       let encoded_data := add(0x20, initCode) // load initialization code.
483       let encoded_size := mload(initCode)     // load the init code's length.
484       upgradeBeaconProxyInstance := create2(  // call `CREATE2` w/ 4 arguments.
485         callvalue,                            // forward any supplied endowment.
486         encoded_data,                         // pass in initialization code.
487         encoded_size,                         // pass in init code's length.
488         salt                                  // pass in the salt value.
489       )
490 
491       // Pass along failure message and revert if contract deployment fails.
492       if iszero(upgradeBeaconProxyInstance) {
493         returndatacopy(0, 0, returndatasize)
494         revert(0, returndatasize)
495       }
496     }
497   }
498 
499   function _constructInitializationCalldata(
500     address userSigningKey
501   ) private pure returns (bytes memory initializationCalldata) {
502     address[] memory keys = new address[](1);
503     keys[0] = userSigningKey;
504 
505     uint8[] memory keyTypes = new uint8[](1);
506     keyTypes[0] = uint8(3); // Dual key type
507 
508     // Get initialization calldata from initialize selector & arguments.
509     initializationCalldata = abi.encodeWithSelector(
510       _INITIALIZE_SELECTOR, 1, 1, keys, keyTypes
511     );
512   }
513 
514   /**
515    * @notice Private view function for finding the address of the next upgrade
516    * beacon proxy that will be deployed, given a particular initialization
517    * calldata payload.
518    * @param initializationCalldata bytes The calldata that will be supplied to
519    * the `DELEGATECALL` from the deployed contract to the implementation set on
520    * the upgrade beacon during contract creation.
521    * @return The address of the next upgrade beacon proxy contract with the
522    * given initialization calldata.
523    */
524   function _computeNextAddress(
525     bytes memory initializationCalldata
526   ) private view returns (address target) {
527     // Place creation code and constructor args of the proxy instance in memory.
528     bytes memory initCode = abi.encodePacked(
529       type(KeyRingUpgradeBeaconProxyV1).creationCode,
530       abi.encode(initializationCalldata)
531     );
532 
533     // Get target address using the constructed initialization code.
534     (, target) = _getSaltAndTarget(initCode);
535   }
536 
537   /**
538    * @notice Private function for determining the salt and the target deployment
539    * address for the next deployed contract (using `CREATE2`) based on the
540    * contract creation code.
541    */
542   function _getSaltAndTarget(
543     bytes memory initCode
544   ) private view returns (uint256 nonce, address target) {
545     // Get the keccak256 hash of the init code for address derivation.
546     bytes32 initCodeHash = keccak256(initCode);
547 
548     // Set the initial nonce to be provided when constructing the salt.
549     nonce = 0;
550 
551     // Declare variable for code size of derived address.
552     uint256 codeSize;
553 
554     // Loop until an contract deployment address with no code has been found.
555     while (true) {
556       target = address(            // derive the target deployment address.
557         uint160(                   // downcast to match the address type.
558           uint256(                 // cast to uint to truncate upper digits.
559             keccak256(             // compute CREATE2 hash using 4 inputs.
560               abi.encodePacked(    // pack all inputs to the hash together.
561                 bytes1(0xff),      // pass in the control character.
562                 address(this),     // pass in the address of this contract.
563                 nonce,              // pass in the salt from above.
564                 initCodeHash       // pass in hash of contract creation code.
565               )
566             )
567           )
568         )
569       );
570 
571       // Determine if a contract is already deployed to the target address.
572       assembly { codeSize := extcodesize(target) }
573 
574       // Exit the loop if no contract is deployed to the target address.
575       if (codeSize == 0) {
576         break;
577       }
578 
579       // Otherwise, increment the nonce and derive a new salt.
580       nonce++;
581     }
582   }
583 
584   /**
585    * @notice Private function for getting the version of the current key ring
586    * implementation by using the upgrade beacon to determine the implementation
587    * and then calling into the returned implementation contract directly.
588    */
589   function _getKeyRingVersion() private view returns (uint256 version) {
590     // Perform the staticcall into the key ring upgrade beacon.
591     (bool ok, bytes memory data) = _KEY_RING_UPGRADE_BEACON.staticcall("");
592 
593     // Revert if underlying staticcall reverts, passing along revert message.
594     require(ok, string(data));
595 
596     // Ensure that the data returned from the beacon is the correct length.
597     require(data.length == 32, "Return data must be exactly 32 bytes.");
598 
599     // Decode the implementation address from the returned data.
600     address implementation = abi.decode(data, (address));
601 
602     // Call into the implementation address directly to get the version.
603     version = DharmaKeyRingImplementationV0Interface(
604       implementation
605     ).getVersion();
606   }
607 }