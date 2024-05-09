1 // File: openzeppelin-solidity/contracts/token/ERC20/IERC20.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /**
8  * @dev Interface of the ERC20 standard as defined in the EIP.
9  */
10 interface IERC20 {
11     /**
12      * @dev Returns the amount of tokens in existence.
13      */
14     function totalSupply() external view returns (uint256);
15 
16     /**
17      * @dev Returns the amount of tokens owned by `account`.
18      */
19     function balanceOf(address account) external view returns (uint256);
20 
21     /**
22      * @dev Moves `amount` tokens from the caller's account to `recipient`.
23      *
24      * Returns a boolean value indicating whether the operation succeeded.
25      *
26      * Emits a {Transfer} event.
27      */
28     function transfer(address recipient, uint256 amount) external returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender) external view returns (uint256);
38 
39     /**
40      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * IMPORTANT: Beware that changing an allowance with this method brings the risk
45      * that someone may use both the old and the new allowance by unfortunate
46      * transaction ordering. One possible solution to mitigate this race
47      * condition is to first reduce the spender's allowance to 0 and set the
48      * desired value afterwards:
49      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
50      *
51      * Emits an {Approval} event.
52      */
53     function approve(address spender, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Moves `amount` tokens from `sender` to `recipient` using the
57      * allowance mechanism. `amount` is then deducted from the caller's
58      * allowance.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Emitted when `value` tokens are moved from one account (`from`) to
68      * another (`to`).
69      *
70      * Note that `value` may be zero.
71      */
72     event Transfer(address indexed from, address indexed to, uint256 value);
73 
74     /**
75      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
76      * a call to {approve}. `value` is the new allowance.
77      */
78     event Approval(address indexed owner, address indexed spender, uint256 value);
79 }
80 
81 // File: @onchain-id/solidity/contracts/IERC734.sol
82 
83 pragma solidity ^0.6.2;
84 
85 /**
86  * @dev Interface of the ERC734 (Key Holder) standard as defined in the EIP.
87  */
88 interface IERC734 {
89     /**
90      * @dev Definition of the structure of a Key.
91      *
92      * Specification: Keys are cryptographic public keys, or contract addresses associated with this identity.
93      * The structure should be as follows:
94      *   - key: A public key owned by this identity
95      *      - purposes: uint256[] Array of the key purposes, like 1 = MANAGEMENT, 2 = EXECUTION
96      *      - keyType: The type of key used, which would be a uint256 for different key types. e.g. 1 = ECDSA, 2 = RSA, etc.
97      *      - key: bytes32 The public key. // Its the Keccak256 hash of the key
98      */
99     struct Key {
100         uint256[] purposes;
101         uint256 keyType;
102         bytes32 key;
103     }
104 
105     /**
106      * @dev Emitted when an execution request was approved.
107      *
108      * Specification: MUST be triggered when approve was successfully called.
109      */
110     event Approved(uint256 indexed executionId, bool approved);
111 
112     /**
113      * @dev Emitted when an execute operation was approved and successfully performed.
114      *
115      * Specification: MUST be triggered when approve was called and the execution was successfully approved.
116      */
117     event Executed(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
118 
119     /**
120      * @dev Emitted when an execution request was performed via `execute`.
121      *
122      * Specification: MUST be triggered when execute was successfully called.
123      */
124     event ExecutionRequested(uint256 indexed executionId, address indexed to, uint256 indexed value, bytes data);
125 
126     /**
127      * @dev Emitted when a key was added to the Identity.
128      *
129      * Specification: MUST be triggered when addKey was successfully called.
130      */
131     event KeyAdded(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
132 
133     /**
134      * @dev Emitted when a key was removed from the Identity.
135      *
136      * Specification: MUST be triggered when removeKey was successfully called.
137      */
138     event KeyRemoved(bytes32 indexed key, uint256 indexed purpose, uint256 indexed keyType);
139 
140     /**
141      * @dev Emitted when the list of required keys to perform an action was updated.
142      *
143      * Specification: MUST be triggered when changeKeysRequired was successfully called.
144      */
145     event KeysRequiredChanged(uint256 purpose, uint256 number);
146 
147 
148     /**
149      * @dev Adds a _key to the identity. The _purpose specifies the purpose of the key.
150      *
151      * Triggers Event: `KeyAdded`
152      *
153      * Specification: MUST only be done by keys of purpose 1, or the identity itself. If it's the identity itself, the approval process will determine its approval.
154      */
155     function addKey(bytes32 _key, uint256 _purpose, uint256 _keyType) external returns (bool success);
156 
157     /**
158     * @dev Approves an execution or claim addition.
159     *
160     * Triggers Event: `Approved`, `Executed`
161     *
162     * Specification:
163     * This SHOULD require n of m approvals of keys purpose 1, if the _to of the execution is the identity contract itself, to successfully approve an execution.
164     * And COULD require n of m approvals of keys purpose 2, if the _to of the execution is another contract, to successfully approve an execution.
165     */
166     function approve(uint256 _id, bool _approve) external returns (bool success);
167 
168     /**
169      * @dev Passes an execution instruction to an ERC725 identity.
170      *
171      * Triggers Event: `ExecutionRequested`, `Executed`
172      *
173      * Specification:
174      * SHOULD require approve to be called with one or more keys of purpose 1 or 2 to approve this execution.
175      * Execute COULD be used as the only accessor for `addKey` and `removeKey`.
176      */
177     function execute(address _to, uint256 _value, bytes calldata _data) external payable returns (uint256 executionId);
178 
179     /**
180      * @dev Returns the full key data, if present in the identity.
181      */
182     function getKey(bytes32 _key) external view returns (uint256[] memory purposes, uint256 keyType, bytes32 key);
183 
184     /**
185      * @dev Returns the list of purposes associated with a key.
186      */
187     function getKeyPurposes(bytes32 _key) external view returns(uint256[] memory _purposes);
188 
189     /**
190      * @dev Returns an array of public key bytes32 held by this identity.
191      */
192     function getKeysByPurpose(uint256 _purpose) external view returns (bytes32[] memory keys);
193 
194     /**
195      * @dev Returns TRUE if a key is present and has the given purpose. If the key is not present it returns FALSE.
196      */
197     function keyHasPurpose(bytes32 _key, uint256 _purpose) external view returns (bool exists);
198 
199     /**
200      * @dev Removes _purpose for _key from the identity.
201      *
202      * Triggers Event: `KeyRemoved`
203      *
204      * Specification: MUST only be done by keys of purpose 1, or the identity itself. If it's the identity itself, the approval process will determine its approval.
205      */
206     function removeKey(bytes32 _key, uint256 _purpose) external returns (bool success);
207 }
208 
209 // File: @onchain-id/solidity/contracts/IERC735.sol
210 
211 pragma solidity ^0.6.2;
212 
213 /**
214  * @dev Interface of the ERC735 (Claim Holder) standard as defined in the EIP.
215  */
216 interface IERC735 {
217 
218     /**
219      * @dev Emitted when a claim request was performed.
220      *
221      * Specification: Is not clear
222      */
223     event ClaimRequested(uint256 indexed claimRequestId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
224 
225     /**
226      * @dev Emitted when a claim was added.
227      *
228      * Specification: MUST be triggered when a claim was successfully added.
229      */
230     event ClaimAdded(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
231 
232     /**
233      * @dev Emitted when a claim was removed.
234      *
235      * Specification: MUST be triggered when removeClaim was successfully called.
236      */
237     event ClaimRemoved(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
238 
239     /**
240      * @dev Emitted when a claim was changed.
241      *
242      * Specification: MUST be triggered when changeClaim was successfully called.
243      */
244     event ClaimChanged(bytes32 indexed claimId, uint256 indexed topic, uint256 scheme, address indexed issuer, bytes signature, bytes data, string uri);
245 
246     /**
247      * @dev Definition of the structure of a Claim.
248      *
249      * Specification: Claims are information an issuer has about the identity holder.
250      * The structure should be as follows:
251      *   - claim: A claim published for the Identity.
252      *      - topic: A uint256 number which represents the topic of the claim. (e.g. 1 biometric, 2 residence (ToBeDefined: number schemes, sub topics based on number ranges??))
253      *      - scheme : The scheme with which this claim SHOULD be verified or how it should be processed. Its a uint256 for different schemes. E.g. could 3 mean contract verification, where the data will be call data, and the issuer a contract address to call (ToBeDefined). Those can also mean different key types e.g. 1 = ECDSA, 2 = RSA, etc. (ToBeDefined)
254      *      - issuer: The issuers identity contract address, or the address used to sign the above signature. If an identity contract, it should hold the key with which the above message was signed, if the key is not present anymore, the claim SHOULD be treated as invalid. The issuer can also be a contract address itself, at which the claim can be verified using the call data.
255      *      - signature: Signature which is the proof that the claim issuer issued a claim of topic for this identity. it MUST be a signed message of the following structure: `keccak256(abi.encode(identityHolder_address, topic, data))`
256      *      - data: The hash of the claim data, sitting in another location, a bit-mask, call data, or actual data based on the claim scheme.
257      *      - uri: The location of the claim, this can be HTTP links, swarm hashes, IPFS hashes, and such.
258      */
259     struct Claim {
260         uint256 topic;
261         uint256 scheme;
262         address issuer;
263         bytes signature;
264         bytes data;
265         string uri;
266     }
267 
268     /**
269      * @dev Get a claim by its ID.
270      *
271      * Claim IDs are generated using `keccak256(abi.encode(address issuer_address, uint256 topic))`.
272      */
273     function getClaim(bytes32 _claimId) external view returns(uint256 topic, uint256 scheme, address issuer, bytes memory signature, bytes memory data, string memory uri);
274 
275     /**
276      * @dev Returns an array of claim IDs by topic.
277      */
278     function getClaimIdsByTopic(uint256 _topic) external view returns(bytes32[] memory claimIds);
279 
280     /**
281      * @dev Add or update a claim.
282      *
283      * Triggers Event: `ClaimRequested`, `ClaimAdded`, `ClaimChanged`
284      *
285      * Specification: Requests the ADDITION or the CHANGE of a claim from an issuer.
286      * Claims can requested to be added by anybody, including the claim holder itself (self issued).
287      *
288      * _signature is a signed message of the following structure: `keccak256(abi.encode(address identityHolder_address, uint256 topic, bytes data))`.
289      * Claim IDs are generated using `keccak256(abi.encode(address issuer_address + uint256 topic))`.
290      *
291      * This COULD implement an approval process for pending claims, or add them right away.
292      * MUST return a claimRequestId (use claim ID) that COULD be sent to the approve function.
293      */
294     function addClaim(uint256 _topic, uint256 _scheme, address issuer, bytes calldata _signature, bytes calldata _data, string calldata _uri) external returns (bytes32 claimRequestId);
295 
296     /**
297      * @dev Removes a claim.
298      *
299      * Triggers Event: `ClaimRemoved`
300      *
301      * Claim IDs are generated using `keccak256(abi.encode(address issuer_address, uint256 topic))`.
302      */
303     function removeClaim(bytes32 _claimId) external returns (bool success);
304 }
305 
306 // File: @onchain-id/solidity/contracts/IIdentity.sol
307 
308 pragma solidity ^0.6.2;
309 
310 
311 
312 interface IIdentity is IERC734, IERC735 {}
313 
314 // File: @onchain-id/solidity/contracts/IClaimIssuer.sol
315 
316 pragma solidity ^0.6.2;
317 
318 
319 interface IClaimIssuer is IIdentity {
320     function revokeClaim(bytes32 _claimId, address _identity) external returns(bool);
321     function getRecoveredAddress(bytes calldata sig, bytes32 dataHash) external pure returns (address);
322     function isClaimRevoked(bytes calldata _sig) external view returns (bool);
323     function isClaimValid(IIdentity _identity, uint256 claimTopic, bytes calldata sig, bytes calldata data) external view returns (bool);
324 }
325 
326 // File: contracts/registry/ITrustedIssuersRegistry.sol
327 
328 /**
329  *     NOTICE
330  *
331  *     The T-REX software is licensed under a proprietary license or the GPL v.3.
332  *     If you choose to receive it under the GPL v.3 license, the following applies:
333  *     T-REX is a suite of smart contracts developed by Tokeny to manage and transfer financial assets on the ethereum blockchain
334  *
335  *     Copyright (C) 2019, Tokeny sàrl.
336  *
337  *     This program is free software: you can redistribute it and/or modify
338  *     it under the terms of the GNU General Public License as published by
339  *     the Free Software Foundation, either version 3 of the License, or
340  *     (at your option) any later version.
341  *
342  *     This program is distributed in the hope that it will be useful,
343  *     but WITHOUT ANY WARRANTY; without even the implied warranty of
344  *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
345  *     GNU General Public License for more details.
346  *
347  *     You should have received a copy of the GNU General Public License
348  *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
349  */
350 
351 pragma solidity 0.6.2;
352 
353 
354 interface ITrustedIssuersRegistry {
355 
356    /**
357     *  this event is emitted when a trusted issuer is added in the registry.
358     *  the event is emitted by the addTrustedIssuer function
359     *  `trustedIssuer` is the address of the trusted issuer's ClaimIssuer contract
360     *  `claimTopics` is the set of claims that the trusted issuer is allowed to emit
361     */
362     event TrustedIssuerAdded(IClaimIssuer indexed trustedIssuer, uint[] claimTopics);
363 
364    /**
365     *  this event is emitted when a trusted issuer is removed from the registry.
366     *  the event is emitted by the removeTrustedIssuer function
367     *  `trustedIssuer` is the address of the trusted issuer's ClaimIssuer contract
368     */
369     event TrustedIssuerRemoved(IClaimIssuer indexed trustedIssuer);
370 
371    /**
372     *  this event is emitted when the set of claim topics is changed for a given trusted issuer.
373     *  the event is emitted by the updateIssuerClaimTopics function
374     *  `trustedIssuer` is the address of the trusted issuer's ClaimIssuer contract
375     *  `claimTopics` is the set of claims that the trusted issuer is allowed to emit
376     */
377     event ClaimTopicsUpdated(IClaimIssuer indexed trustedIssuer, uint[] claimTopics);
378 
379    /**
380     *  @dev registers a ClaimIssuer contract as trusted claim issuer.
381     *  Requires that a ClaimIssuer contract doesn't already exist
382     *  Requires that the claimTopics set is not empty
383     *  @param _trustedIssuer The ClaimIssuer contract address of the trusted claim issuer.
384     *  @param _claimTopics the set of claim topics that the trusted issuer is allowed to emit
385     *  This function can only be called by the owner of the Trusted Issuers Registry contract
386     *  emits a `TrustedIssuerAdded` event
387     */
388     function addTrustedIssuer(IClaimIssuer _trustedIssuer, uint[] calldata _claimTopics) external;
389 
390    /**
391     *  @dev Removes the ClaimIssuer contract of a trusted claim issuer.
392     *  Requires that the claim issuer contract to be registered first
393     *  @param _trustedIssuer the claim issuer to remove.
394     *  This function can only be called by the owner of the Trusted Issuers Registry contract
395     *  emits a `TrustedIssuerRemoved` event
396     */
397     function removeTrustedIssuer(IClaimIssuer _trustedIssuer) external;
398 
399    /**
400     *  @dev Updates the set of claim topics that a trusted issuer is allowed to emit.
401     *  Requires that this ClaimIssuer contract already exists in the registry
402     *  Requires that the provided claimTopics set is not empty
403     *  @param _trustedIssuer the claim issuer to update.
404     *  @param _claimTopics the set of claim topics that the trusted issuer is allowed to emit
405     *  This function can only be called by the owner of the Trusted Issuers Registry contract
406     *  emits a `ClaimTopicsUpdated` event
407     */
408     function updateIssuerClaimTopics(IClaimIssuer _trustedIssuer, uint[] calldata _claimTopics) external;
409 
410    /**
411     *  @dev Function for getting all the trusted claim issuers stored.
412     *  @return array of all claim issuers registered.
413     */
414     function getTrustedIssuers() external view returns (IClaimIssuer[] memory);
415 
416    /**
417     *  @dev Checks if the ClaimIssuer contract is trusted
418     *  @param _issuer the address of the ClaimIssuer contract
419     *  @return true if the issuer is trusted, false otherwise.
420     */
421     function isTrustedIssuer(address _issuer) external view returns(bool);
422 
423    /**
424     *  @dev Function for getting all the claim topic of trusted claim issuer
425     *  Requires the provided ClaimIssuer contract to be registered in the trusted issuers registry.
426     *  @param _trustedIssuer the trusted issuer concerned.
427     *  @return The set of claim topics that the trusted issuer is allowed to emit
428     */
429     function getTrustedIssuerClaimTopics(IClaimIssuer _trustedIssuer) external view returns(uint[] memory);
430 
431    /**
432     *  @dev Function for checking if the trusted claim issuer is allowed
433     *  to emit a certain claim topic
434     *  @param _issuer the address of the trusted issuer's ClaimIssuer contract
435     *  @param _claimTopic the Claim Topic that has to be checked to know if the `issuer` is allowed to emit it
436     *  @return true if the issuer is trusted for this claim topic.
437     */
438     function hasClaimTopic(address _issuer, uint _claimTopic) external view returns(bool);
439 
440    /**
441     *  @dev Transfers the Ownership of TrustedIssuersRegistry to a new Owner.
442     *  @param _newOwner The new owner of this contract.
443     *  This function can only be called by the owner of the Trusted Issuers Registry contract
444     *  emits an `OwnershipTransferred` event
445     */
446     function transferOwnershipOnIssuersRegistryContract(address _newOwner) external;
447 }
448 
449 // File: contracts/registry/IClaimTopicsRegistry.sol
450 
451 /**
452  *     NOTICE
453  *
454  *     The T-REX software is licensed under a proprietary license or the GPL v.3.
455  *     If you choose to receive it under the GPL v.3 license, the following applies:
456  *     T-REX is a suite of smart contracts developed by Tokeny to manage and transfer financial assets on the ethereum blockchain
457  *
458  *     Copyright (C) 2019, Tokeny sàrl.
459  *
460  *     This program is free software: you can redistribute it and/or modify
461  *     it under the terms of the GNU General Public License as published by
462  *     the Free Software Foundation, either version 3 of the License, or
463  *     (at your option) any later version.
464  *
465  *     This program is distributed in the hope that it will be useful,
466  *     but WITHOUT ANY WARRANTY; without even the implied warranty of
467  *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
468  *     GNU General Public License for more details.
469  *
470  *     You should have received a copy of the GNU General Public License
471  *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
472  */
473 
474 pragma solidity 0.6.2;
475 
476 interface IClaimTopicsRegistry {
477 
478    /**
479     *  this event is emitted when a claim topic has been added to the ClaimTopicsRegistry
480     *  the event is emitted by the 'addClaimTopic' function
481     *  `claimTopic` is the required claim added to the Claim Topics Registry
482     */
483     event ClaimTopicAdded(uint256 indexed claimTopic);
484 
485    /**
486     *  this event is emitted when a claim topic has been removed from the ClaimTopicsRegistry
487     *  the event is emitted by the 'removeClaimTopic' function
488     *  `claimTopic` is the required claim removed from the Claim Topics Registry
489     */
490     event ClaimTopicRemoved(uint256 indexed claimTopic);
491 
492    /**
493     * @dev Add a trusted claim topic (For example: KYC=1, AML=2).
494     * Only owner can call.
495     * emits `ClaimTopicAdded` event
496     * @param _claimTopic The claim topic index
497     */
498     function addClaimTopic(uint256 _claimTopic) external;
499 
500    /**
501     *  @dev Remove a trusted claim topic (For example: KYC=1, AML=2).
502     *  Only owner can call.
503     *  emits `ClaimTopicRemoved` event
504     *  @param _claimTopic The claim topic index
505     */
506     function removeClaimTopic(uint256 _claimTopic) external;
507 
508    /**
509     *  @dev Get the trusted claim topics for the security token
510     *  @return Array of trusted claim topics
511     */
512     function getClaimTopics() external view returns (uint256[] memory);
513 
514    /**
515     *  @dev Transfers the Ownership of ClaimTopics to a new Owner.
516     *  Only owner can call.
517     *  @param _newOwner The new owner of this contract.
518     */
519     function transferOwnershipOnClaimTopicsRegistryContract(address _newOwner) external;
520 }
521 
522 // File: contracts/registry/IIdentityRegistryStorage.sol
523 
524 /**
525  *     NOTICE
526  *
527  *     The T-REX software is licensed under a proprietary license or the GPL v.3.
528  *     If you choose to receive it under the GPL v.3 license, the following applies:
529  *     T-REX is a suite of smart contracts developed by Tokeny to manage and transfer financial assets on the ethereum blockchain
530  *
531  *     Copyright (C) 2019, Tokeny sàrl.
532  *
533  *     This program is free software: you can redistribute it and/or modify
534  *     it under the terms of the GNU General Public License as published by
535  *     the Free Software Foundation, either version 3 of the License, or
536  *     (at your option) any later version.
537  *
538  *     This program is distributed in the hope that it will be useful,
539  *     but WITHOUT ANY WARRANTY; without even the implied warranty of
540  *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
541  *     GNU General Public License for more details.
542  *
543  *     You should have received a copy of the GNU General Public License
544  *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
545  */
546 
547 pragma solidity 0.6.2;
548 
549 
550 interface IIdentityRegistryStorage {
551 
552    /**
553     *  this event is emitted when an Identity is registered into the storage contract.
554     *  the event is emitted by the 'registerIdentity' function
555     *  `investorAddress` is the address of the investor's wallet
556     *  `identity` is the address of the Identity smart contract (onchainID)
557     */
558     event IdentityStored(address indexed investorAddress, IIdentity indexed identity);
559 
560    /**
561     *  this event is emitted when an Identity is removed from the storage contract.
562     *  the event is emitted by the 'deleteIdentity' function
563     *  `investorAddress` is the address of the investor's wallet
564     *  `identity` is the address of the Identity smart contract (onchainID)
565     */
566     event IdentityUnstored(address indexed investorAddress, IIdentity indexed identity);
567 
568    /**
569     *  this event is emitted when an Identity has been updated
570     *  the event is emitted by the 'updateIdentity' function
571     *  `oldIdentity` is the old Identity contract's address to update
572     *  `newIdentity` is the new Identity contract's
573     */
574     event IdentityModified(IIdentity indexed oldIdentity, IIdentity indexed newIdentity);
575 
576    /**
577     *  this event is emitted when an Identity's country has been updated
578     *  the event is emitted by the 'updateCountry' function
579     *  `investorAddress` is the address on which the country has been updated
580     *  `country` is the numeric code (ISO 3166-1) of the new country
581     */
582     event CountryModified(address indexed investorAddress, uint16 indexed country);
583 
584    /**
585     *  this event is emitted when an Identity Registry is bound to the storage contract
586     *  the event is emitted by the 'addIdentityRegistry' function
587     *  `identityRegistry` is the address of the identity registry added
588     */
589     event IdentityRegistryBound(address indexed identityRegistry);
590 
591    /**
592     *  this event is emitted when an Identity Registry is unbound from the storage contract
593     *  the event is emitted by the 'removeIdentityRegistry' function
594     *  `identityRegistry` is the address of the identity registry removed
595     */
596     event IdentityRegistryUnbound(address indexed identityRegistry);
597 
598    /**
599     *  @dev Returns the identity registries linked to the storage contract
600     */
601     function linkedIdentityRegistries() external view returns (address[] memory);
602 
603    /**
604     *  @dev Returns the onchainID of an investor.
605     *  @param _userAddress The wallet of the investor
606     */
607     function storedIdentity(address _userAddress) external view returns (IIdentity);
608 
609    /**
610     *  @dev Returns the country code of an investor.
611     *  @param _userAddress The wallet of the investor
612     */
613     function storedInvestorCountry(address _userAddress) external view returns (uint16);
614 
615    /**
616     *  @dev adds an identity contract corresponding to a user address in the storage.
617     *  Requires that the user doesn't have an identity contract already registered.
618     *  This function can only be called by an address set as agent of the smart contract
619     *  @param _userAddress The address of the user
620     *  @param _identity The address of the user's identity contract
621     *  @param _country The country of the investor
622     *  emits `IdentityStored` event
623     */
624     function addIdentityToStorage(address _userAddress, IIdentity _identity, uint16 _country) external;
625 
626    /**
627     *  @dev Removes an user from the storage.
628     *  Requires that the user have an identity contract already deployed that will be deleted.
629     *  This function can only be called by an address set as agent of the smart contract
630     *  @param _userAddress The address of the user to be removed
631     *  emits `IdentityUnstored` event
632     */
633     function removeIdentityFromStorage(address _userAddress) external;
634 
635    /**
636     *  @dev Updates the country corresponding to a user address.
637     *  Requires that the user should have an identity contract already deployed that will be replaced.
638     *  This function can only be called by an address set as agent of the smart contract
639     *  @param _userAddress The address of the user
640     *  @param _country The new country of the user
641     *  emits `CountryModified` event
642     */
643     function modifyStoredInvestorCountry(address _userAddress, uint16 _country) external;
644 
645    /**
646     *  @dev Updates an identity contract corresponding to a user address.
647     *  Requires that the user address should be the owner of the identity contract.
648     *  Requires that the user should have an identity contract already deployed that will be replaced.
649     *  This function can only be called by an address set as agent of the smart contract
650     *  @param _userAddress The address of the user
651     *  @param _identity The address of the user's new identity contract
652     *  emits `IdentityModified` event
653     */
654     function modifyStoredIdentity(address _userAddress, IIdentity _identity) external;
655 
656    /**
657     *  @notice Transfers the Ownership of the Identity Registry Storage to a new Owner.
658     *  This function can only be called by the wallet set as owner of the smart contract
659     *  @param _newOwner The new owner of this contract.
660     */
661     function transferOwnershipOnIdentityRegistryStorage(address _newOwner) external;
662 
663    /**
664     *  @notice Adds an identity registry as agent of the Identity Registry Storage Contract.
665     *  This function can only be called by the wallet set as owner of the smart contract
666     *  This function adds the identity registry to the list of identityRegistries linked to the storage contract
667     *  @param _identityRegistry The identity registry address to add.
668     */
669     function bindIdentityRegistry(address _identityRegistry) external;
670 
671    /**
672     *  @notice Removes an identity registry from being agent of the Identity Registry Storage Contract.
673     *  This function can only be called by the wallet set as owner of the smart contract
674     *  This function removes the identity registry from the list of identityRegistries linked to the storage contract
675     *  @param _identityRegistry The identity registry address to remove.
676     */
677     function unbindIdentityRegistry(address _identityRegistry) external;
678 }
679 
680 // File: contracts/registry/IIdentityRegistry.sol
681 
682 /**
683  *     NOTICE
684  *
685  *     The T-REX software is licensed under a proprietary license or the GPL v.3.
686  *     If you choose to receive it under the GPL v.3 license, the following applies:
687  *     T-REX is a suite of smart contracts developed by Tokeny to manage and transfer financial assets on the ethereum blockchain
688  *
689  *     Copyright (C) 2019, Tokeny sàrl.
690  *
691  *     This program is free software: you can redistribute it and/or modify
692  *     it under the terms of the GNU General Public License as published by
693  *     the Free Software Foundation, either version 3 of the License, or
694  *     (at your option) any later version.
695  *
696  *     This program is distributed in the hope that it will be useful,
697  *     but WITHOUT ANY WARRANTY; without even the implied warranty of
698  *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
699  *     GNU General Public License for more details.
700  *
701  *     You should have received a copy of the GNU General Public License
702  *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
703  */
704 
705 pragma solidity 0.6.2;
706 
707 
708 
709 
710 
711 
712 interface IIdentityRegistry {
713 
714    /**
715     *  this event is emitted when the ClaimTopicsRegistry has been set for the IdentityRegistry
716     *  the event is emitted by the IdentityRegistry constructor
717     *  `claimTopicsRegistry` is the address of the Claim Topics Registry contract
718     */
719     event ClaimTopicsRegistrySet(address indexed claimTopicsRegistry);
720 
721    /**
722     *  this event is emitted when the IdentityRegistryStorage has been set for the IdentityRegistry
723     *  the event is emitted by the IdentityRegistry constructor
724     *  `identityStorage` is the address of the Identity Registry Storage contract
725     */
726     event IdentityStorageSet(address indexed identityStorage);
727 
728    /**
729     *  this event is emitted when the ClaimTopicsRegistry has been set for the IdentityRegistry
730     *  the event is emitted by the IdentityRegistry constructor
731     *  `trustedIssuersRegistry` is the address of the Trusted Issuers Registry contract
732     */
733     event TrustedIssuersRegistrySet(address indexed trustedIssuersRegistry);
734 
735    /**
736     *  this event is emitted when an Identity is registered into the Identity Registry.
737     *  the event is emitted by the 'registerIdentity' function
738     *  `investorAddress` is the address of the investor's wallet
739     *  `identity` is the address of the Identity smart contract (onchainID)
740     */
741     event IdentityRegistered(address indexed investorAddress, IIdentity indexed identity);
742 
743    /**
744     *  this event is emitted when an Identity is removed from the Identity Registry.
745     *  the event is emitted by the 'deleteIdentity' function
746     *  `investorAddress` is the address of the investor's wallet
747     *  `identity` is the address of the Identity smart contract (onchainID)
748     */
749     event IdentityRemoved(address indexed investorAddress, IIdentity indexed identity);
750 
751    /**
752     *  this event is emitted when an Identity has been updated
753     *  the event is emitted by the 'updateIdentity' function
754     *  `oldIdentity` is the old Identity contract's address to update
755     *  `newIdentity` is the new Identity contract's
756     */
757     event IdentityUpdated(IIdentity indexed oldIdentity, IIdentity indexed newIdentity);
758 
759    /**
760     *  this event is emitted when an Identity's country has been updated
761     *  the event is emitted by the 'updateCountry' function
762     *  `investorAddress` is the address on which the country has been updated
763     *  `country` is the numeric code (ISO 3166-1) of the new country
764     */
765     event CountryUpdated(address indexed investorAddress, uint16 indexed country);
766 
767    /**
768     *  @dev Register an identity contract corresponding to a user address.
769     *  Requires that the user doesn't have an identity contract already registered.
770     *  This function can only be called by a wallet set as agent of the smart contract
771     *  @param _userAddress The address of the user
772     *  @param _identity The address of the user's identity contract
773     *  @param _country The country of the investor
774     *  emits `IdentityRegistered` event
775     */
776     function registerIdentity(address _userAddress, IIdentity _identity, uint16 _country) external;
777 
778    /**
779     *  @dev Removes an user from the identity registry.
780     *  Requires that the user have an identity contract already deployed that will be deleted.
781     *  This function can only be called by a wallet set as agent of the smart contract
782     *  @param _userAddress The address of the user to be removed
783     *  emits `IdentityRemoved` event
784     */
785     function deleteIdentity(address _userAddress) external;
786 
787    /**
788     *  @dev Replace the actual identityRegistryStorage contract with a new one.
789     *  This function can only be called by the wallet set as owner of the smart contract
790     *  @param _identityRegistryStorage The address of the new Identity Registry Storage
791     *  emits `IdentityStorageSet` event
792     */
793     function setIdentityRegistryStorage(address _identityRegistryStorage) external;
794 
795    /**
796     *  @dev Replace the actual claimTopicsRegistry contract with a new one.
797     *  This function can only be called by the wallet set as owner of the smart contract
798     *  @param _claimTopicsRegistry The address of the new claim Topics Registry
799     *  emits `ClaimTopicsRegistrySet` event
800     */
801     function setClaimTopicsRegistry(address _claimTopicsRegistry) external;
802 
803    /**
804     *  @dev Replace the actual trustedIssuersRegistry contract with a new one.
805     *  This function can only be called by the wallet set as owner of the smart contract
806     *  @param _trustedIssuersRegistry The address of the new Trusted Issuers Registry
807     *  emits `TrustedIssuersRegistrySet` event
808     */
809     function setTrustedIssuersRegistry(address _trustedIssuersRegistry) external;
810 
811    /**
812     *  @dev Updates the country corresponding to a user address.
813     *  Requires that the user should have an identity contract already deployed that will be replaced.
814     *  This function can only be called by a wallet set as agent of the smart contract
815     *  @param _userAddress The address of the user
816     *  @param _country The new country of the user
817     *  emits `CountryUpdated` event
818     */
819     function updateCountry(address _userAddress, uint16 _country) external;
820 
821    /**
822     *  @dev Updates an identity contract corresponding to a user address.
823     *  Requires that the user address should be the owner of the identity contract.
824     *  Requires that the user should have an identity contract already deployed that will be replaced.
825     *  This function can only be called by a wallet set as agent of the smart contract
826     *  @param _userAddress The address of the user
827     *  @param _identity The address of the user's new identity contract
828     *  emits `IdentityUpdated` event
829     */
830     function updateIdentity(address _userAddress, IIdentity _identity) external;
831 
832    /**
833     *  @dev function allowing to register identities in batch
834     *  This function can only be called by a wallet set as agent of the smart contract
835     *  Requires that none of the users has an identity contract already registered.
836     *  IMPORTANT : THIS TRANSACTION COULD EXCEED GAS LIMIT IF `_userAddresses.length` IS TOO HIGH,
837     *  USE WITH CARE OR YOU COULD LOSE TX FEES WITH AN "OUT OF GAS" TRANSACTION
838     *  @param _userAddresses The addresses of the users
839     *  @param _identities The addresses of the corresponding identity contracts
840     *  @param _countries The countries of the corresponding investors
841     *  emits _userAddresses.length `IdentityRegistered` events
842     */
843     function batchRegisterIdentity(address[] calldata _userAddresses, IIdentity[] calldata _identities, uint16[] calldata _countries) external;
844 
845    /**
846     *  @dev This functions checks whether a wallet has its Identity registered or not
847     *  in the Identity Registry.
848     *  @param _userAddress The address of the user to be checked.
849     *  @return 'True' if the address is contained in the Identity Registry, 'false' if not.
850     */
851     function contains(address _userAddress) external view returns (bool);
852 
853    /**
854     *  @dev This functions checks whether an identity contract
855     *  corresponding to the provided user address has the required claims or not based
856     *  on the data fetched from trusted issuers registry and from the claim topics registry
857     *  @param _userAddress The address of the user to be verified.
858     *  @return 'True' if the address is verified, 'false' if not.
859     */
860     function isVerified(address _userAddress) external view returns (bool);
861 
862    /**
863     *  @dev Returns the onchainID of an investor.
864     *  @param _userAddress The wallet of the investor
865     */
866     function identity(address _userAddress) external view returns (IIdentity);
867 
868    /**
869     *  @dev Returns the country code of an investor.
870     *  @param _userAddress The wallet of the investor
871     */
872     function investorCountry(address _userAddress) external view returns (uint16);
873 
874    /**
875     *  @dev Returns the IdentityRegistryStorage linked to the current IdentityRegistry.
876     */
877     function identityStorage() external view returns (IIdentityRegistryStorage);
878 
879    /**
880     *  @dev Returns the TrustedIssuersRegistry linked to the current IdentityRegistry.
881     */
882     function issuersRegistry() external view returns (ITrustedIssuersRegistry);
883 
884    /**
885     *  @dev Returns the ClaimTopicsRegistry linked to the current IdentityRegistry.
886     */
887     function topicsRegistry() external view returns (IClaimTopicsRegistry);
888 
889    /**
890     *  @notice Transfers the Ownership of the Identity Registry to a new Owner.
891     *  This function can only be called by the wallet set as owner of the smart contract
892     *  @param _newOwner The new owner of this contract.
893     */
894     function transferOwnershipOnIdentityRegistryContract(address _newOwner) external;
895 
896    /**
897     *  @notice Adds an address as _agent of the Identity Registry Contract.
898     *  This function can only be called by the wallet set as owner of the smart contract
899     *  @param _agent The _agent's address to add.
900     */
901     function addAgentOnIdentityRegistryContract(address _agent) external;
902 
903    /**
904     *  @notice Removes an address from being _agent of the Identity Registry Contract.
905     *  This function can only be called by the wallet set as owner of the smart contract
906     *  @param _agent The _agent's address to remove.
907     */
908     function removeAgentOnIdentityRegistryContract(address _agent) external;
909 }
910 
911 // File: contracts/compliance/ICompliance.sol
912 
913 /**
914  *     NOTICE
915  *
916  *     The T-REX software is licensed under a proprietary license or the GPL v.3.
917  *     If you choose to receive it under the GPL v.3 license, the following applies:
918  *     T-REX is a suite of smart contracts developed by Tokeny to manage and transfer financial assets on the ethereum blockchain
919  *
920  *     Copyright (C) 2019, Tokeny sàrl.
921  *
922  *     This program is free software: you can redistribute it and/or modify
923  *     it under the terms of the GNU General Public License as published by
924  *     the Free Software Foundation, either version 3 of the License, or
925  *     (at your option) any later version.
926  *
927  *     This program is distributed in the hope that it will be useful,
928  *     but WITHOUT ANY WARRANTY; without even the implied warranty of
929  *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
930  *     GNU General Public License for more details.
931  *
932  *     You should have received a copy of the GNU General Public License
933  *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
934  */
935 
936 pragma solidity 0.6.2;
937 
938 interface ICompliance {
939 
940     /**
941     *  this event is emitted when the Agent has been added on the allowedList of this Compliance.
942     *  the event is emitted by the Compliance constructor and by the addTokenAgent function
943     *  `_agentAddress` is the address of the Agent to add
944     */
945     event TokenAgentAdded(address _agentAddress);
946 
947     /**
948     *  this event is emitted when the Agent has been removed from the agent list of this Compliance.
949     *  the event is emitted by the Compliance constructor and by the removeTokenAgent function
950     *  `_agentAddress` is the address of the Agent to remove
951     */
952     event TokenAgentRemoved(address _agentAddress);
953 
954     /**
955     *  this event is emitted when a token has been bound to the compliance contract
956     *  the event is emitted by the bindToken function
957     *  `_token` is the address of the token to bind
958     */
959     event TokenBound(address _token);
960 
961     /**
962     *  this event is emitted when a token has been unbound from the compliance contract
963     *  the event is emitted by the unbindToken function
964     *  `_token` is the address of the token to unbind
965     */
966     event TokenUnbound(address _token);
967 
968     /**
969     *  @dev Returns true if the Address is in the list of token agents
970     *  @param _agentAddress address of this agent
971     */
972     function isTokenAgent(address _agentAddress) external view returns (bool);
973 
974     /**
975     *  @dev Returns true if the address given corresponds to a token that is bound with the Compliance contract
976     *  @param _token address of the token
977     */
978     function isTokenBound(address _token) external view returns (bool);
979 
980     /**
981      *  @dev adds an agent to the list of token agents
982      *  @param _agentAddress address of the agent to be added
983      *  Emits a TokenAgentAdded event
984      */
985     function addTokenAgent(address _agentAddress) external;
986 
987     /**
988     *  @dev remove Agent from the list of token agents
989     *  @param _agentAddress address of the agent to be removed (must be added first)
990     *  Emits a TokenAgentRemoved event
991     */
992     function removeTokenAgent(address _agentAddress) external;
993 
994     /**
995      *  @dev binds a token to the compliance contract
996      *  @param _token address of the token to bind
997      *  Emits a TokenBound event
998      */
999     function bindToken(address _token) external;
1000 
1001     /**
1002     *  @dev unbinds a token from the compliance contract
1003     *  @param _token address of the token to unbind
1004     *  Emits a TokenUnbound event
1005     */
1006     function unbindToken(address _token) external;
1007 
1008 
1009    /**
1010     *  @dev checks that the transfer is compliant.
1011     *  default compliance always returns true
1012     *  READ ONLY FUNCTION, this function cannot be used to increment
1013     *  counters, emit events, ...
1014     *  @param _from The address of the sender
1015     *  @param _to The address of the receiver
1016     *  @param _amount The amount of tokens involved in the transfer
1017     */
1018     function canTransfer(address _from, address _to, uint256 _amount) external view returns (bool);
1019 
1020    /**
1021     *  @dev function called whenever tokens are transferred
1022     *  from one wallet to another
1023     *  this function can update state variables in the compliance contract
1024     *  these state variables being used by `canTransfer` to decide if a transfer
1025     *  is compliant or not depending on the values stored in these state variables and on
1026     *  the parameters of the compliance smart contract
1027     *  @param _from The address of the sender
1028     *  @param _to The address of the receiver
1029     *  @param _amount The amount of tokens involved in the transfer
1030     */
1031     function transferred(address _from, address _to, uint256 _amount) external;
1032 
1033    /**
1034     *  @dev function called whenever tokens are created
1035     *  on a wallet
1036     *  this function can update state variables in the compliance contract
1037     *  these state variables being used by `canTransfer` to decide if a transfer
1038     *  is compliant or not depending on the values stored in these state variables and on
1039     *  the parameters of the compliance smart contract
1040     *  @param _to The address of the receiver
1041     *  @param _amount The amount of tokens involved in the transfer
1042     */
1043     function created(address _to, uint256 _amount) external;
1044 
1045    /**
1046     *  @dev function called whenever tokens are destroyed
1047     *  this function can update state variables in the compliance contract
1048     *  these state variables being used by `canTransfer` to decide if a transfer
1049     *  is compliant or not depending on the values stored in these state variables and on
1050     *  the parameters of the compliance smart contract
1051     *  @param _from The address of the receiver
1052     *  @param _amount The amount of tokens involved in the transfer
1053     */
1054     function destroyed(address _from, uint256 _amount) external;
1055 
1056    /**
1057     *  @dev function used to transfer the ownership of the compliance contract
1058     *  to a new owner, giving him access to the `OnlyOwner` functions implemented on the contract
1059     *  @param newOwner The address of the new owner of the compliance contract
1060     *  This function can only be called by the owner of the compliance contract
1061     *  emits an `OwnershipTransferred` event
1062     */
1063     function transferOwnershipOnComplianceContract(address newOwner) external;
1064 }
1065 
1066 // File: contracts/token/IToken.sol
1067 
1068 /**
1069  *     NOTICE
1070  *
1071  *     The T-REX software is licensed under a proprietary license or the GPL v.3.
1072  *     If you choose to receive it under the GPL v.3 license, the following applies:
1073  *     T-REX is a suite of smart contracts developed by Tokeny to manage and transfer financial assets on the ethereum blockchain
1074  *
1075  *     Copyright (C) 2019, Tokeny sàrl.
1076  *
1077  *     This program is free software: you can redistribute it and/or modify
1078  *     it under the terms of the GNU General Public License as published by
1079  *     the Free Software Foundation, either version 3 of the License, or
1080  *     (at your option) any later version.
1081  *
1082  *     This program is distributed in the hope that it will be useful,
1083  *     but WITHOUT ANY WARRANTY; without even the implied warranty of
1084  *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1085  *     GNU General Public License for more details.
1086  *
1087  *     You should have received a copy of the GNU General Public License
1088  *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
1089  */
1090 
1091 pragma solidity 0.6.2;
1092 
1093 
1094 
1095 
1096 ///interface
1097 interface IToken is IERC20 {
1098 
1099    /**
1100     *  this event is emitted when the token information is updated.
1101     *  the event is emitted by the token constructor and by the setTokenInformation function
1102     *  `_newName` is the name of the token
1103     *  `_newSymbol` is the symbol of the token
1104     *  `_newDecimals` is the decimals of the token
1105     *  `_newVersion` is the version of the token, current version is 3.0
1106     *  `_newOnchainID` is the address of the onchainID of the token
1107     */
1108     event UpdatedTokenInformation(string _newName, string _newSymbol, uint8 _newDecimals, string _newVersion, address _newOnchainID);
1109 
1110    /**
1111     *  this event is emitted when the IdentityRegistry has been set for the token
1112     *  the event is emitted by the token constructor and by the setIdentityRegistry function
1113     *  `_identityRegistry` is the address of the Identity Registry of the token
1114     */
1115     event IdentityRegistryAdded(address indexed _identityRegistry);
1116 
1117    /**
1118     *  this event is emitted when the Compliance has been set for the token
1119     *  the event is emitted by the token constructor and by the setCompliance function
1120     *  `_compliance` is the address of the Compliance contract of the token
1121     */
1122     event ComplianceAdded(address indexed _compliance);
1123 
1124    /**
1125     *  this event is emitted when an investor successfully recovers his tokens
1126     *  the event is emitted by the recoveryAddress function
1127     *  `_lostWallet` is the address of the wallet that the investor lost access to
1128     *  `_newWallet` is the address of the wallet that the investor provided for the recovery
1129     *  `_investorOnchainID` is the address of the onchainID of the investor who asked for a recovery
1130     */
1131     event RecoverySuccess(address _lostWallet, address _newWallet, address _investorOnchainID);
1132 
1133    /**
1134     *  this event is emitted when the wallet of an investor is frozen or unfrozen
1135     *  the event is emitted by setAddressFrozen and batchSetAddressFrozen functions
1136     *  `_userAddress` is the wallet of the investor that is concerned by the freezing status
1137     *  `_isFrozen` is the freezing status of the wallet
1138     *  if `_isFrozen` equals `true` the wallet is frozen after emission of the event
1139     *  if `_isFrozen` equals `false` the wallet is unfrozen after emission of the event
1140     *  `_owner` is the address of the agent who called the function to freeze the wallet
1141     */
1142     event AddressFrozen(address indexed _userAddress, bool indexed _isFrozen, address indexed _owner);
1143 
1144    /**
1145     *  this event is emitted when a certain amount of tokens is frozen on a wallet
1146     *  the event is emitted by freezePartialTokens and batchFreezePartialTokens functions
1147     *  `_userAddress` is the wallet of the investor that is concerned by the freezing status
1148     *  `_amount` is the amount of tokens that are frozen
1149     */
1150     event TokensFrozen(address indexed _userAddress, uint256 _amount);
1151 
1152    /**
1153     *  this event is emitted when a certain amount of tokens is unfrozen on a wallet
1154     *  the event is emitted by unfreezePartialTokens and batchUnfreezePartialTokens functions
1155     *  `_userAddress` is the wallet of the investor that is concerned by the freezing status
1156     *  `_amount` is the amount of tokens that are unfrozen
1157     */
1158     event TokensUnfrozen(address indexed _userAddress, uint256 _amount);
1159 
1160    /**
1161     *  this event is emitted when the token is paused
1162     *  the event is emitted by the pause function
1163     *  `_userAddress` is the address of the wallet that called the pause function
1164     */
1165     event Paused(address _userAddress);
1166 
1167    /**
1168     *  this event is emitted when the token is unpaused
1169     *  the event is emitted by the unpause function
1170     *  `_userAddress` is the address of the wallet that called the unpause function
1171     */
1172     event Unpaused(address _userAddress);
1173 
1174    /**
1175     * @dev Returns the number of decimals used to get its user representation.
1176     * For example, if `decimals` equals `2`, a balance of `505` tokens should
1177     * be displayed to a user as `5,05` (`505 / 1 ** 2`).
1178     *
1179     * Tokens usually opt for a value of 18, imitating the relationship between
1180     * Ether and Wei.
1181     *
1182     * NOTE: This information is only used for _display_ purposes: it in
1183     * no way affects any of the arithmetic of the contract, including
1184     * balanceOf() and transfer().
1185     */
1186     function decimals() external view returns (uint8);
1187 
1188    /**
1189     * @dev Returns the name of the token.
1190     */
1191     function name() external view returns (string memory);
1192 
1193    /**
1194     * @dev Returns the address of the onchainID of the token.
1195     * the onchainID of the token gives all the information available
1196     * about the token and is managed by the token issuer or his agent.
1197     */
1198     function onchainID() external view returns (address);
1199 
1200    /**
1201     * @dev Returns the symbol of the token, usually a shorter version of the
1202     * name.
1203     */
1204     function symbol() external view returns (string memory);
1205 
1206    /**
1207     * @dev Returns the TREX version of the token.
1208     * current version is 3.0.0
1209     */
1210     function version() external view returns (string memory);
1211 
1212    /**
1213     *  @dev Returns the Identity Registry linked to the token
1214     */
1215     function identityRegistry() external view returns (IIdentityRegistry);
1216 
1217    /**
1218     *  @dev Returns the Compliance contract linked to the token
1219     */
1220     function compliance() external view returns (ICompliance);
1221 
1222    /**
1223     * @dev Returns true if the contract is paused, and false otherwise.
1224     */
1225     function paused() external view returns (bool);
1226 
1227    /**
1228     *  @dev Returns the freezing status of a wallet
1229     *  if isFrozen returns `true` the wallet is frozen
1230     *  if isFrozen returns `false` the wallet is not frozen
1231     *  isFrozen returning `true` doesn't mean that the balance is free, tokens could be blocked by
1232     *  a partial freeze or the whole token could be blocked by pause
1233     *  @param _userAddress the address of the wallet on which isFrozen is called
1234     */
1235     function isFrozen(address _userAddress) external view returns (bool);
1236 
1237    /**
1238     *  @dev Returns the amount of tokens that are partially frozen on a wallet
1239     *  the amount of frozen tokens is always <= to the total balance of the wallet
1240     *  @param _userAddress the address of the wallet on which getFrozenTokens is called
1241     */
1242     function getFrozenTokens(address _userAddress) external view returns (uint256);
1243 
1244    /**
1245     *  @dev sets the token name
1246     *  @param _name the name of token to set
1247     *  Only the owner of the token smart contract can call this function
1248     *  emits a `UpdatedTokenInformation` event
1249     */
1250     function setName(string calldata _name) external;
1251 
1252    /**
1253     *  @dev sets the token symbol
1254     *  @param _symbol the token symbol to set
1255     *  Only the owner of the token smart contract can call this function
1256     *  emits a `UpdatedTokenInformation` event
1257     */
1258     function setSymbol(string calldata _symbol) external;
1259 
1260    /**
1261     *  @dev sets the onchain ID of the token
1262     *  @param _onchainID the address of the onchain ID to set
1263     *  Only the owner of the token smart contract can call this function
1264     *  emits a `UpdatedTokenInformation` event
1265     */
1266     function setOnchainID(address _onchainID) external;
1267 
1268    /**
1269     *  @dev pauses the token contract, when contract is paused investors cannot transfer tokens anymore
1270     *  This function can only be called by a wallet set as agent of the token
1271     *  emits a `Paused` event
1272     */
1273     function pause() external;
1274 
1275    /**
1276     *  @dev unpauses the token contract, when contract is unpaused investors can transfer tokens
1277     *  if their wallet is not blocked & if the amount to transfer is <= to the amount of free tokens
1278     *  This function can only be called by a wallet set as agent of the token
1279     *  emits an `Unpaused` event
1280     */
1281     function unpause() external;
1282 
1283    /**
1284     *  @dev sets an address frozen status for this token.
1285     *  @param _userAddress The address for which to update frozen status
1286     *  @param _freeze Frozen status of the address
1287     *  This function can only be called by a wallet set as agent of the token
1288     *  emits an `AddressFrozen` event
1289     */
1290     function setAddressFrozen(address _userAddress, bool _freeze) external;
1291 
1292    /**
1293     *  @dev freezes token amount specified for given address.
1294     *  @param _userAddress The address for which to update frozen tokens
1295     *  @param _amount Amount of Tokens to be frozen
1296     *  This function can only be called by a wallet set as agent of the token
1297     *  emits a `TokensFrozen` event
1298     */
1299     function freezePartialTokens(address _userAddress, uint256 _amount) external;
1300 
1301    /**
1302     *  @dev unfreezes token amount specified for given address
1303     *  @param _userAddress The address for which to update frozen tokens
1304     *  @param _amount Amount of Tokens to be unfrozen
1305     *  This function can only be called by a wallet set as agent of the token
1306     *  emits a `TokensUnfrozen` event
1307     */
1308     function unfreezePartialTokens(address _userAddress, uint256 _amount) external;
1309 
1310    /**
1311     *  @dev sets the Identity Registry for the token
1312     *  @param _identityRegistry the address of the Identity Registry to set
1313     *  Only the owner of the token smart contract can call this function
1314     *  emits an `IdentityRegistryAdded` event
1315     */
1316     function setIdentityRegistry(address _identityRegistry) external;
1317 
1318    /**
1319     *  @dev sets the compliance contract of the token
1320     *  @param _compliance the address of the compliance contract to set
1321     *  Only the owner of the token smart contract can call this function
1322     *  emits a `ComplianceAdded` event
1323     */
1324     function setCompliance(address _compliance) external;
1325 
1326    /**
1327     *  @dev force a transfer of tokens between 2 whitelisted wallets
1328     *  In case the `from` address has not enough free tokens (unfrozen tokens)
1329     *  but has a total balance higher or equal to the `amount`
1330     *  the amount of frozen tokens is reduced in order to have enough free tokens
1331     *  to proceed the transfer, in such a case, the remaining balance on the `from`
1332     *  account is 100% composed of frozen tokens post-transfer.
1333     *  Require that the `to` address is a verified address,
1334     *  @param _from The address of the sender
1335     *  @param _to The address of the receiver
1336     *  @param _amount The number of tokens to transfer
1337     *  @return `true` if successful and revert if unsuccessful
1338     *  This function can only be called by a wallet set as agent of the token
1339     *  emits a `TokensUnfrozen` event if `_amount` is higher than the free balance of `_from`
1340     *  emits a `Transfer` event
1341     */
1342     function forcedTransfer(address _from, address _to, uint256 _amount) external returns (bool);
1343 
1344    /**
1345     *  @dev mint tokens on a wallet
1346     *  Improved version of default mint method. Tokens can be minted
1347     *  to an address if only it is a verified address as per the security token.
1348     *  @param _to Address to mint the tokens to.
1349     *  @param _amount Amount of tokens to mint.
1350     *  This function can only be called by a wallet set as agent of the token
1351     *  emits a `Transfer` event
1352     */
1353     function mint(address _to, uint256 _amount) external;
1354 
1355    /**
1356     *  @dev burn tokens on a wallet
1357     *  In case the `account` address has not enough free tokens (unfrozen tokens)
1358     *  but has a total balance higher or equal to the `value` amount
1359     *  the amount of frozen tokens is reduced in order to have enough free tokens
1360     *  to proceed the burn, in such a case, the remaining balance on the `account`
1361     *  is 100% composed of frozen tokens post-transaction.
1362     *  @param _userAddress Address to burn the tokens from.
1363     *  @param _amount Amount of tokens to burn.
1364     *  This function can only be called by a wallet set as agent of the token
1365     *  emits a `TokensUnfrozen` event if `_amount` is higher than the free balance of `_userAddress`
1366     *  emits a `Transfer` event
1367     */
1368     function burn(address _userAddress, uint256 _amount) external;
1369 
1370    /**
1371     *  @dev recovery function used to force transfer tokens from a
1372     *  lost wallet to a new wallet for an investor.
1373     *  @param _lostWallet the wallet that the investor lost
1374     *  @param _newWallet the newly provided wallet on which tokens have to be transferred
1375     *  @param _investorOnchainID the onchainID of the investor asking for a recovery
1376     *  This function can only be called by a wallet set as agent of the token
1377     *  emits a `TokensUnfrozen` event if there is some frozen tokens on the lost wallet if the recovery process is successful
1378     *  emits a `Transfer` event if the recovery process is successful
1379     *  emits a `RecoverySuccess` event if the recovery process is successful
1380     *  emits a `RecoveryFails` event if the recovery process fails
1381     */
1382     function recoveryAddress(address _lostWallet, address _newWallet, address _investorOnchainID) external returns (bool);
1383 
1384    /**
1385     *  @dev function allowing to issue transfers in batch
1386     *  Require that the msg.sender and `to` addresses are not frozen.
1387     *  Require that the total value should not exceed available balance.
1388     *  Require that the `to` addresses are all verified addresses,
1389     *  IMPORTANT : THIS TRANSACTION COULD EXCEED GAS LIMIT IF `_toList.length` IS TOO HIGH,
1390     *  USE WITH CARE OR YOU COULD LOSE TX FEES WITH AN "OUT OF GAS" TRANSACTION
1391     *  @param _toList The addresses of the receivers
1392     *  @param _amounts The number of tokens to transfer to the corresponding receiver
1393     *  emits _toList.length `Transfer` events
1394     */
1395     function batchTransfer(address[] calldata _toList, uint256[] calldata _amounts) external;
1396 
1397    /**
1398     *  @dev function allowing to issue forced transfers in batch
1399     *  Require that `_amounts[i]` should not exceed available balance of `_fromList[i]`.
1400     *  Require that the `_toList` addresses are all verified addresses
1401     *  IMPORTANT : THIS TRANSACTION COULD EXCEED GAS LIMIT IF `_fromList.length` IS TOO HIGH,
1402     *  USE WITH CARE OR YOU COULD LOSE TX FEES WITH AN "OUT OF GAS" TRANSACTION
1403     *  @param _fromList The addresses of the senders
1404     *  @param _toList The addresses of the receivers
1405     *  @param _amounts The number of tokens to transfer to the corresponding receiver
1406     *  This function can only be called by a wallet set as agent of the token
1407     *  emits `TokensUnfrozen` events if `_amounts[i]` is higher than the free balance of `_fromList[i]`
1408     *  emits _fromList.length `Transfer` events
1409     */
1410     function batchForcedTransfer(address[] calldata _fromList, address[] calldata _toList, uint256[] calldata _amounts) external;
1411 
1412    /**
1413     *  @dev function allowing to mint tokens in batch
1414     *  Require that the `_toList` addresses are all verified addresses
1415     *  IMPORTANT : THIS TRANSACTION COULD EXCEED GAS LIMIT IF `_toList.length` IS TOO HIGH,
1416     *  USE WITH CARE OR YOU COULD LOSE TX FEES WITH AN "OUT OF GAS" TRANSACTION
1417     *  @param _toList The addresses of the receivers
1418     *  @param _amounts The number of tokens to mint to the corresponding receiver
1419     *  This function can only be called by a wallet set as agent of the token
1420     *  emits _toList.length `Transfer` events
1421     */
1422     function batchMint(address[] calldata _toList, uint256[] calldata _amounts) external;
1423 
1424    /**
1425     *  @dev function allowing to burn tokens in batch
1426     *  Require that the `_userAddresses` addresses are all verified addresses
1427     *  IMPORTANT : THIS TRANSACTION COULD EXCEED GAS LIMIT IF `_userAddresses.length` IS TOO HIGH,
1428     *  USE WITH CARE OR YOU COULD LOSE TX FEES WITH AN "OUT OF GAS" TRANSACTION
1429     *  @param _userAddresses The addresses of the wallets concerned by the burn
1430     *  @param _amounts The number of tokens to burn from the corresponding wallets
1431     *  This function can only be called by a wallet set as agent of the token
1432     *  emits _userAddresses.length `Transfer` events
1433     */
1434     function batchBurn(address[] calldata _userAddresses, uint256[] calldata _amounts) external;
1435 
1436    /**
1437     *  @dev function allowing to set frozen addresses in batch
1438     *  IMPORTANT : THIS TRANSACTION COULD EXCEED GAS LIMIT IF `_userAddresses.length` IS TOO HIGH,
1439     *  USE WITH CARE OR YOU COULD LOSE TX FEES WITH AN "OUT OF GAS" TRANSACTION
1440     *  @param _userAddresses The addresses for which to update frozen status
1441     *  @param _freeze Frozen status of the corresponding address
1442     *  This function can only be called by a wallet set as agent of the token
1443     *  emits _userAddresses.length `AddressFrozen` events
1444     */
1445     function batchSetAddressFrozen(address[] calldata _userAddresses, bool[] calldata _freeze) external;
1446 
1447    /**
1448     *  @dev function allowing to freeze tokens partially in batch
1449     *  IMPORTANT : THIS TRANSACTION COULD EXCEED GAS LIMIT IF `_userAddresses.length` IS TOO HIGH,
1450     *  USE WITH CARE OR YOU COULD LOSE TX FEES WITH AN "OUT OF GAS" TRANSACTION
1451     *  @param _userAddresses The addresses on which tokens need to be frozen
1452     *  @param _amounts the amount of tokens to freeze on the corresponding address
1453     *  This function can only be called by a wallet set as agent of the token
1454     *  emits _userAddresses.length `TokensFrozen` events
1455     */
1456     function batchFreezePartialTokens(address[] calldata _userAddresses, uint256[] calldata _amounts) external;
1457 
1458    /**
1459     *  @dev function allowing to unfreeze tokens partially in batch
1460     *  IMPORTANT : THIS TRANSACTION COULD EXCEED GAS LIMIT IF `_userAddresses.length` IS TOO HIGH,
1461     *  USE WITH CARE OR YOU COULD LOSE TX FEES WITH AN "OUT OF GAS" TRANSACTION
1462     *  @param _userAddresses The addresses on which tokens need to be unfrozen
1463     *  @param _amounts the amount of tokens to unfreeze on the corresponding address
1464     *  This function can only be called by a wallet set as agent of the token
1465     *  emits _userAddresses.length `TokensUnfrozen` events
1466     */
1467     function batchUnfreezePartialTokens(address[] calldata _userAddresses, uint256[] calldata _amounts) external;
1468 
1469    /**
1470     *  @dev transfers the ownership of the token smart contract
1471     *  @param _newOwner the address of the new token smart contract owner
1472     *  This function can only be called by the owner of the token
1473     *  emits an `OwnershipTransferred` event
1474     */
1475     function transferOwnershipOnTokenContract(address _newOwner) external;
1476 
1477    /**
1478     *  @dev adds an agent to the token smart contract
1479     *  @param _agent the address of the new agent of the token smart contract
1480     *  This function can only be called by the owner of the token
1481     *  emits an `AgentAdded` event
1482     */
1483     function addAgentOnTokenContract(address _agent) external;
1484 
1485    /**
1486     *  @dev remove an agent from the token smart contract
1487     *  @param _agent the address of the agent to remove
1488     *  This function can only be called by the owner of the token
1489     *  emits an `AgentRemoved` event
1490     */
1491     function removeAgentOnTokenContract(address _agent) external;
1492 
1493 }
1494 
1495 // File: contracts/roles/Roles.sol
1496 
1497 pragma solidity 0.6.2;
1498 
1499 /**
1500  * @title Roles
1501  * @dev Library for managing addresses assigned to a Role.
1502  */
1503 library Roles {
1504     struct Role {
1505         mapping (address => bool) bearer;
1506     }
1507 
1508     /**
1509      * @dev Give an account access to this role.
1510      */
1511     function add(Role storage role, address account) internal {
1512         require(!has(role, account), "Roles: account already has role");
1513         role.bearer[account] = true;
1514     }
1515 
1516     /**
1517      * @dev Remove an account's access to this role.
1518      */
1519     function remove(Role storage role, address account) internal {
1520         require(has(role, account), "Roles: account does not have role");
1521         role.bearer[account] = false;
1522     }
1523 
1524     /**
1525      * @dev Check if an account has this role.
1526      * @return bool
1527      */
1528     function has(Role storage role, address account) internal view returns (bool) {
1529         require(account != address(0), "Roles: account is the zero address");
1530         return role.bearer[account];
1531     }
1532 }
1533 
1534 // File: openzeppelin-solidity/contracts/GSN/Context.sol
1535 
1536 // SPDX-License-Identifier: MIT
1537 
1538 pragma solidity ^0.6.0;
1539 
1540 /*
1541  * @dev Provides information about the current execution context, including the
1542  * sender of the transaction and its data. While these are generally available
1543  * via msg.sender and msg.data, they should not be accessed in such a direct
1544  * manner, since when dealing with GSN meta-transactions the account sending and
1545  * paying for execution may not be the actual sender (as far as an application
1546  * is concerned).
1547  *
1548  * This contract is only required for intermediate, library-like contracts.
1549  */
1550 contract Context {
1551     // Empty internal constructor, to prevent people from mistakenly deploying
1552     // an instance of this contract, which should be used via inheritance.
1553     constructor () internal { }
1554 
1555     function _msgSender() internal view virtual returns (address payable) {
1556         return msg.sender;
1557     }
1558 
1559     function _msgData() internal view virtual returns (bytes memory) {
1560         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
1561         return msg.data;
1562     }
1563 }
1564 
1565 // File: contracts/roles/Ownable.sol
1566 
1567 pragma solidity 0.6.2;
1568 
1569 
1570 /**
1571  * @dev Contract module which provides a basic access control mechanism, where
1572  * there is an account (an owner) that can be granted exclusive access to
1573  * specific functions.
1574  *
1575  * This module is used through inheritance. It will make available the modifier
1576  * `onlyOwner`, which can be applied to your functions to restrict their use to
1577  * the owner.
1578  */
1579 contract Ownable is Context {
1580     address private _owner;
1581 
1582     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1583 
1584     /**
1585      * @dev Initializes the contract setting the deployer as the initial owner.
1586      */
1587     constructor () internal {
1588         address msgSender = _msgSender();
1589         _owner = msgSender;
1590         emit OwnershipTransferred(address(0), msgSender);
1591     }
1592 
1593     /**
1594      * @dev Returns the address of the current owner.
1595      */
1596     function owner() external view returns (address) {
1597         return _owner;
1598     }
1599 
1600     /**
1601      * @dev Throws if called by any account other than the owner.
1602      */
1603     modifier onlyOwner() {
1604         require(isOwner(), "Ownable: caller is not the owner");
1605         _;
1606     }
1607 
1608     /**
1609      * @dev Returns true if the caller is the current owner.
1610      */
1611     function isOwner() public view returns (bool) {
1612         return _msgSender() == _owner;
1613     }
1614 
1615     /**
1616      * @dev Leaves the contract without owner. It will not be possible to call
1617      * `onlyOwner` functions anymore. Can only be called by the current owner.
1618      *
1619      * NOTE: Renouncing ownership will leave the contract without an owner,
1620      * thereby removing any functionality that is only available to the owner.
1621      */
1622     function renounceOwnership() external virtual onlyOwner {
1623         emit OwnershipTransferred(_owner, address(0));
1624         _owner = address(0);
1625     }
1626 
1627     /**
1628      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1629      * Can only be called by the current owner.
1630      */
1631     function transferOwnership(address newOwner) public virtual onlyOwner {
1632         _transferOwnership(newOwner);
1633     }
1634 
1635     /**
1636      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1637      */
1638     function _transferOwnership(address newOwner) internal virtual {
1639         require(newOwner != address(0), "Ownable: new owner is the zero address");
1640         emit OwnershipTransferred(_owner, newOwner);
1641         _owner = newOwner;
1642     }
1643 }
1644 
1645 // File: contracts/roles/AgentRole.sol
1646 
1647 /**
1648  *     NOTICE
1649  *
1650  *     The T-REX software is licensed under a proprietary license or the GPL v.3.
1651  *     If you choose to receive it under the GPL v.3 license, the following applies:
1652  *     T-REX is a suite of smart contracts developed by Tokeny to manage and transfer financial assets on the ethereum blockchain
1653  *
1654  *     Copyright (C) 2019, Tokeny sàrl.
1655  *
1656  *     This program is free software: you can redistribute it and/or modify
1657  *     it under the terms of the GNU General Public License as published by
1658  *     the Free Software Foundation, either version 3 of the License, or
1659  *     (at your option) any later version.
1660  *
1661  *     This program is distributed in the hope that it will be useful,
1662  *     but WITHOUT ANY WARRANTY; without even the implied warranty of
1663  *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1664  *     GNU General Public License for more details.
1665  *
1666  *     You should have received a copy of the GNU General Public License
1667  *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
1668  */
1669 
1670 pragma solidity 0.6.2;
1671 
1672 
1673 
1674 contract AgentRole is Ownable {
1675     using Roles for Roles.Role;
1676 
1677     event AgentAdded(address indexed _agent);
1678     event AgentRemoved(address indexed _agent);
1679 
1680     Roles.Role private _agents;
1681 
1682     modifier onlyAgent() {
1683         require(isAgent(msg.sender), "AgentRole: caller does not have the Agent role");
1684         _;
1685     }
1686 
1687     function isAgent(address _agent) public view returns (bool) {
1688         return _agents.has(_agent);
1689     }
1690 
1691     function addAgent(address _agent) public onlyOwner {
1692         _agents.add(_agent);
1693         emit AgentAdded(_agent);
1694     }
1695 
1696     function removeAgent(address _agent) public onlyOwner {
1697         _agents.remove(_agent);
1698         emit AgentRemoved(_agent);
1699     }
1700 }
1701 
1702 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
1703 
1704 // SPDX-License-Identifier: MIT
1705 
1706 pragma solidity ^0.6.0;
1707 
1708 /**
1709  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1710  * checks.
1711  *
1712  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1713  * in bugs, because programmers usually assume that an overflow raises an
1714  * error, which is the standard behavior in high level programming languages.
1715  * `SafeMath` restores this intuition by reverting the transaction when an
1716  * operation overflows.
1717  *
1718  * Using this library instead of the unchecked operations eliminates an entire
1719  * class of bugs, so it's recommended to use it always.
1720  */
1721 library SafeMath {
1722     /**
1723      * @dev Returns the addition of two unsigned integers, reverting on
1724      * overflow.
1725      *
1726      * Counterpart to Solidity's `+` operator.
1727      *
1728      * Requirements:
1729      * - Addition cannot overflow.
1730      */
1731     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1732         uint256 c = a + b;
1733         require(c >= a, "SafeMath: addition overflow");
1734 
1735         return c;
1736     }
1737 
1738     /**
1739      * @dev Returns the subtraction of two unsigned integers, reverting on
1740      * overflow (when the result is negative).
1741      *
1742      * Counterpart to Solidity's `-` operator.
1743      *
1744      * Requirements:
1745      * - Subtraction cannot overflow.
1746      */
1747     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1748         return sub(a, b, "SafeMath: subtraction overflow");
1749     }
1750 
1751     /**
1752      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1753      * overflow (when the result is negative).
1754      *
1755      * Counterpart to Solidity's `-` operator.
1756      *
1757      * Requirements:
1758      * - Subtraction cannot overflow.
1759      */
1760     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1761         require(b <= a, errorMessage);
1762         uint256 c = a - b;
1763 
1764         return c;
1765     }
1766 
1767     /**
1768      * @dev Returns the multiplication of two unsigned integers, reverting on
1769      * overflow.
1770      *
1771      * Counterpart to Solidity's `*` operator.
1772      *
1773      * Requirements:
1774      * - Multiplication cannot overflow.
1775      */
1776     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1777         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1778         // benefit is lost if 'b' is also tested.
1779         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1780         if (a == 0) {
1781             return 0;
1782         }
1783 
1784         uint256 c = a * b;
1785         require(c / a == b, "SafeMath: multiplication overflow");
1786 
1787         return c;
1788     }
1789 
1790     /**
1791      * @dev Returns the integer division of two unsigned integers. Reverts on
1792      * division by zero. The result is rounded towards zero.
1793      *
1794      * Counterpart to Solidity's `/` operator. Note: this function uses a
1795      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1796      * uses an invalid opcode to revert (consuming all remaining gas).
1797      *
1798      * Requirements:
1799      * - The divisor cannot be zero.
1800      */
1801     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1802         return div(a, b, "SafeMath: division by zero");
1803     }
1804 
1805     /**
1806      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1807      * division by zero. The result is rounded towards zero.
1808      *
1809      * Counterpart to Solidity's `/` operator. Note: this function uses a
1810      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1811      * uses an invalid opcode to revert (consuming all remaining gas).
1812      *
1813      * Requirements:
1814      * - The divisor cannot be zero.
1815      */
1816     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1817         // Solidity only automatically asserts when dividing by 0
1818         require(b > 0, errorMessage);
1819         uint256 c = a / b;
1820         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1821 
1822         return c;
1823     }
1824 
1825     /**
1826      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1827      * Reverts when dividing by zero.
1828      *
1829      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1830      * opcode (which leaves remaining gas untouched) while Solidity uses an
1831      * invalid opcode to revert (consuming all remaining gas).
1832      *
1833      * Requirements:
1834      * - The divisor cannot be zero.
1835      */
1836     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1837         return mod(a, b, "SafeMath: modulo by zero");
1838     }
1839 
1840     /**
1841      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1842      * Reverts with custom message when dividing by zero.
1843      *
1844      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1845      * opcode (which leaves remaining gas untouched) while Solidity uses an
1846      * invalid opcode to revert (consuming all remaining gas).
1847      *
1848      * Requirements:
1849      * - The divisor cannot be zero.
1850      */
1851     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1852         require(b != 0, errorMessage);
1853         return a % b;
1854     }
1855 }
1856 
1857 // File: contracts/token/Token.sol
1858 
1859 /**
1860  *     NOTICE
1861  *
1862  *     The T-REX software is licensed under a proprietary license or the GPL v.3.
1863  *     If you choose to receive it under the GPL v.3 license, the following applies:
1864  *     T-REX is a suite of smart contracts developed by Tokeny to manage and transfer financial assets on the ethereum blockchain
1865  *
1866  *     Copyright (C) 2019, Tokeny sàrl.
1867  *
1868  *     This program is free software: you can redistribute it and/or modify
1869  *     it under the terms of the GNU General Public License as published by
1870  *     the Free Software Foundation, either version 3 of the License, or
1871  *     (at your option) any later version.
1872  *
1873  *     This program is distributed in the hope that it will be useful,
1874  *     but WITHOUT ANY WARRANTY; without even the implied warranty of
1875  *     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
1876  *     GNU General Public License for more details.
1877  *
1878  *     You should have received a copy of the GNU General Public License
1879  *     along with this program.  If not, see <https://www.gnu.org/licenses/>.
1880  */
1881 
1882 pragma solidity 0.6.2;
1883 
1884 
1885 
1886 
1887 
1888 
1889 
1890 
1891 
1892 
1893 
1894 contract Token is IToken, AgentRole {
1895     using SafeMath for uint256;
1896 
1897     /// ERC20 basic variables
1898     mapping(address => uint256) private _balances;
1899     mapping(address => mapping(address => uint256)) private _allowances;
1900     uint256 private _totalSupply;
1901 
1902     /// Token information
1903     string private tokenName;
1904     string private tokenSymbol;
1905     uint8 private tokenDecimals;
1906     address private tokenOnchainID;
1907     string constant private TOKEN_VERSION = "3.2.0";
1908 
1909     /// Variables of freeze and pause functions
1910     mapping(address => bool) private frozen;
1911     mapping(address => uint256) private frozenTokens;
1912 
1913     bool private tokenPaused = false;
1914 
1915     /// Identity Registry contract used by the onchain validator system
1916     IIdentityRegistry private tokenIdentityRegistry;
1917 
1918     /// Compliance contract linked to the onchain validator system
1919     ICompliance private tokenCompliance;
1920 
1921    /**
1922     *  @dev the constructor initiates the token contract
1923     *  msg.sender is set automatically as the owner of the smart contract
1924     *  @param _identityRegistry the address of the Identity registry linked to the token
1925     *  @param _compliance the address of the compliance contract linked to the token
1926     *  @param _name the name of the token
1927     *  @param _symbol the symbol of the token
1928     *  @param _decimals the decimals of the token
1929     *  @param _onchainID the address of the onchainID of the token
1930     *  emits an `UpdatedTokenInformation` event
1931     *  emits an `IdentityRegistryAdded` event
1932     *  emits a `ComplianceAdded` event
1933     */
1934     constructor(
1935         address _identityRegistry,
1936         address _compliance,
1937         string memory _name,
1938         string memory _symbol,
1939         uint8 _decimals,
1940         address _onchainID
1941         )
1942     public {
1943         tokenName = _name;
1944         tokenSymbol = _symbol;
1945         tokenDecimals = _decimals;
1946         tokenOnchainID = _onchainID;
1947         tokenIdentityRegistry = IIdentityRegistry(_identityRegistry);
1948         emit IdentityRegistryAdded(_identityRegistry);
1949         tokenCompliance = ICompliance(_compliance);
1950         emit ComplianceAdded(_compliance);
1951         emit UpdatedTokenInformation(tokenName, tokenSymbol, tokenDecimals, TOKEN_VERSION, tokenOnchainID);
1952     }
1953 
1954     /// Modifier to make a function callable only when the contract is not paused.
1955     modifier whenNotPaused() {
1956         require(!tokenPaused, "Pausable: paused");
1957         _;
1958     }
1959 
1960     /// Modifier to make a function callable only when the contract is paused.
1961     modifier whenPaused() {
1962         require(tokenPaused, "Pausable: not paused");
1963         _;
1964     }
1965 
1966    /**
1967     *  @dev See {IERC20-totalSupply}.
1968     */
1969     function totalSupply() external override view returns (uint256) {
1970         return _totalSupply;
1971     }
1972 
1973    /**
1974     *  @dev See {IERC20-balanceOf}.
1975     */
1976     function balanceOf(address _userAddress) public override view returns (uint256) {
1977         return _balances[_userAddress];
1978     }
1979 
1980    /**
1981     *  @dev See {IERC20-allowance}.
1982     */
1983     function allowance(address _owner, address _spender) external override view virtual returns (uint256) {
1984         return _allowances[_owner][_spender];
1985     }
1986 
1987    /**
1988     *  @dev See {IERC20-approve}.
1989     */
1990     function approve(address _spender, uint256 _amount) external override virtual returns (bool) {
1991         _approve(msg.sender, _spender, _amount);
1992         return true;
1993     }
1994 
1995    /**
1996     *  @dev See {ERC20-increaseAllowance}.
1997     */
1998     function increaseAllowance(address _spender, uint256 _addedValue) external virtual returns (bool) {
1999         _approve(msg.sender, _spender, _allowances[msg.sender][_spender].add(_addedValue));
2000         return true;
2001     }
2002 
2003    /**
2004     *  @dev See {ERC20-decreaseAllowance}.
2005     */
2006     function decreaseAllowance(address _spender, uint256 _subtractedValue) external virtual returns (bool) {
2007         _approve(msg.sender, _spender, _allowances[msg.sender][_spender].sub(_subtractedValue, "ERC20: decreased allowance below zero"));
2008         return true;
2009     }
2010 
2011    /**
2012     *  @dev See {ERC20-_mint}.
2013     */
2014     function _transfer(address _from, address _to, uint256 _amount) internal virtual {
2015         require(_from != address(0), "ERC20: transfer from the zero address");
2016         require(_to != address(0), "ERC20: transfer to the zero address");
2017 
2018         _beforeTokenTransfer(_from, _to, _amount);
2019 
2020         _balances[_from] = _balances[_from].sub(_amount, "ERC20: transfer amount exceeds balance");
2021         _balances[_to] = _balances[_to].add(_amount);
2022         emit Transfer(_from, _to, _amount);
2023     }
2024 
2025    /**
2026     *  @dev See {ERC20-_mint}.
2027     */
2028     function _mint(address _userAddress, uint256 _amount) internal virtual {
2029         require(_userAddress != address(0), "ERC20: mint to the zero address");
2030 
2031         _beforeTokenTransfer(address(0), _userAddress, _amount);
2032 
2033         _totalSupply = _totalSupply.add(_amount);
2034         _balances[_userAddress] = _balances[_userAddress].add(_amount);
2035         emit Transfer(address(0), _userAddress, _amount);
2036     }
2037 
2038    /**
2039     *  @dev See {ERC20-_burn}.
2040     */
2041     function _burn(address _userAddress, uint256 _amount) internal virtual {
2042         require(_userAddress != address(0), "ERC20: burn from the zero address");
2043 
2044         _beforeTokenTransfer(_userAddress, address(0), _amount);
2045 
2046         _balances[_userAddress] = _balances[_userAddress].sub(_amount, "ERC20: burn amount exceeds balance");
2047         _totalSupply = _totalSupply.sub(_amount);
2048         emit Transfer(_userAddress, address(0), _amount);
2049     }
2050 
2051    /**
2052     *  @dev See {ERC20-_approve}.
2053     */
2054     function _approve(address _owner, address _spender, uint256 _amount) internal virtual {
2055         require(_owner != address(0), "ERC20: approve from the zero address");
2056         require(_spender != address(0), "ERC20: approve to the zero address");
2057 
2058         _allowances[_owner][_spender] = _amount;
2059         emit Approval(_owner, _spender, _amount);
2060     }
2061 
2062    /**
2063     *  @dev See {ERC20-_beforeTokenTransfer}.
2064     */
2065     function _beforeTokenTransfer(address _from, address _to, uint256 _amount) internal virtual { }
2066 
2067 
2068    /**
2069     *  @dev See {IToken-decimals}.
2070     */
2071     function decimals() external override view returns (uint8){
2072         return tokenDecimals;
2073     }
2074 
2075    /**
2076     *  @dev See {IToken-name}.
2077     */
2078     function name() external override view returns (string memory){
2079         return tokenName;
2080     }
2081 
2082    /**
2083     *  @dev See {IToken-onchainID}.
2084     */
2085     function onchainID() external override view returns (address){
2086         return tokenOnchainID;
2087     }
2088 
2089    /**
2090     *  @dev See {IToken-symbol}.
2091     */
2092     function symbol() external override view returns (string memory){
2093         return tokenSymbol;
2094     }
2095 
2096    /**
2097     *  @dev See {IToken-version}.
2098     */
2099     function version() external override view returns (string memory){
2100         return TOKEN_VERSION;
2101     }
2102 
2103    /**
2104     *  @dev See {IToken-setName}.
2105     */
2106     function setName(string calldata _name) external override onlyOwner {
2107         tokenName = _name;
2108         emit UpdatedTokenInformation(tokenName, tokenSymbol, tokenDecimals, TOKEN_VERSION, tokenOnchainID);
2109     }
2110 
2111    /**
2112     *  @dev See {IToken-setSymbol}.
2113     */
2114     function setSymbol(string calldata _symbol) external override onlyOwner {
2115         tokenSymbol = _symbol;
2116         emit UpdatedTokenInformation(tokenName, tokenSymbol, tokenDecimals, TOKEN_VERSION, tokenOnchainID);
2117     }
2118 
2119    /**
2120     *  @dev See {IToken-setOnchainID}.
2121     */
2122     function setOnchainID(address _onchainID) external override onlyOwner {
2123         tokenOnchainID = _onchainID;
2124         emit UpdatedTokenInformation(tokenName, tokenSymbol, tokenDecimals, TOKEN_VERSION, tokenOnchainID);
2125     }
2126 
2127    /**
2128     *  @dev See {IToken-paused}.
2129     */
2130     function paused() external override view returns (bool) {
2131         return tokenPaused;
2132     }
2133 
2134    /**
2135     *  @dev See {IToken-isFrozen}.
2136     */
2137     function isFrozen(address _userAddress) external override view returns (bool) {
2138         return frozen[_userAddress];
2139     }
2140 
2141    /**
2142     *  @dev See {IToken-getFrozenTokens}.
2143     */
2144     function getFrozenTokens(address _userAddress) external override view returns (uint256) {
2145         return frozenTokens[_userAddress];
2146     }
2147 
2148    /**
2149     *  @notice ERC-20 overridden function that include logic to check for trade validity.
2150     *  Require that the msg.sender and to addresses are not frozen.
2151     *  Require that the value should not exceed available balance .
2152     *  Require that the to address is a verified address
2153     *  @param _to The address of the receiver
2154     *  @param _amount The number of tokens to transfer
2155     *  @return `true` if successful and revert if unsuccessful
2156     */
2157     function transfer(address _to, uint256 _amount) public override whenNotPaused returns (bool) {
2158         require(!frozen[_to] && !frozen[msg.sender], "wallet is frozen");
2159         require(_amount <= balanceOf(msg.sender).sub(frozenTokens[msg.sender]), "Insufficient Balance");
2160         if (tokenIdentityRegistry.isVerified(_to) && tokenCompliance.canTransfer(msg.sender, _to, _amount)) {
2161             tokenCompliance.transferred(msg.sender, _to, _amount);
2162             _transfer(msg.sender, _to, _amount);
2163             return true;
2164         }
2165         revert("Transfer not possible");
2166     }
2167 
2168    /**
2169     *  @dev See {IToken-pause}.
2170     */
2171     function pause() external override onlyAgent whenNotPaused {
2172         tokenPaused = true;
2173         emit Paused(msg.sender);
2174     }
2175 
2176    /**
2177     *  @dev See {IToken-unpause}.
2178     */
2179     function unpause() external override onlyAgent whenPaused {
2180         tokenPaused = false;
2181         emit Unpaused(msg.sender);
2182     }
2183 
2184    /**
2185     *  @dev See {IToken-identityRegistry}.
2186     */
2187     function identityRegistry() external override view returns (IIdentityRegistry) {
2188         return tokenIdentityRegistry;
2189     }
2190 
2191    /**
2192     *  @dev See {IToken-compliance}.
2193     */
2194     function compliance() external override view returns (ICompliance) {
2195         return tokenCompliance;
2196     }
2197 
2198    /**
2199     *  @dev See {IToken-batchTransfer}.
2200     */
2201     function batchTransfer(address[] calldata _toList, uint256[] calldata _amounts) external override {
2202         for (uint256 i = 0; i < _toList.length; i++) {
2203             transfer(_toList[i], _amounts[i]);
2204         }
2205     }
2206 
2207    /**
2208     *  @notice ERC-20 overridden function that include logic to check for trade validity.
2209     *  Require that the from and to addresses are not frozen.
2210     *  Require that the value should not exceed available balance .
2211     *  Require that the to address is a verified address
2212     *  @param _from The address of the sender
2213     *  @param _to The address of the receiver
2214     *  @param _amount The number of tokens to transfer
2215     *  @return `true` if successful and revert if unsuccessful
2216     */
2217     function transferFrom(address _from, address _to, uint256 _amount) external override whenNotPaused returns (bool) {
2218         require(!frozen[_to] && !frozen[_from], "wallet is frozen");
2219         require(_amount <= balanceOf(_from).sub(frozenTokens[_from]), "Insufficient Balance");
2220         if (tokenIdentityRegistry.isVerified(_to) && tokenCompliance.canTransfer(_from, _to, _amount)) {
2221             tokenCompliance.transferred(_from, _to, _amount);
2222             _transfer(_from, _to, _amount);
2223             _approve(_from, msg.sender, _allowances[_from][msg.sender].sub(_amount, "TREX: transfer amount exceeds allowance"));
2224             return true;
2225         }
2226 
2227         revert("Transfer not possible");
2228     }
2229 
2230    /**
2231     *  @dev See {IToken-forcedTransfer}.
2232     */
2233     function forcedTransfer(address _from, address _to, uint256 _amount) public override onlyAgent returns (bool) {
2234         uint256 freeBalance = balanceOf(_from).sub(frozenTokens[_from]);
2235         if (_amount > freeBalance) {
2236             uint256 tokensToUnfreeze = _amount.sub(freeBalance);
2237             frozenTokens[_from] = frozenTokens[_from].sub(tokensToUnfreeze);
2238             emit TokensUnfrozen(_from, tokensToUnfreeze);
2239         }
2240         if (tokenIdentityRegistry.isVerified(_to)) {
2241             tokenCompliance.transferred(_from, _to, _amount);
2242             _transfer(_from, _to, _amount);
2243             return true;
2244         }
2245         revert("Transfer not possible");
2246     }
2247 
2248    /**
2249     *  @dev See {IToken-batchForcedTransfer}.
2250     */
2251     function batchForcedTransfer(address[] calldata _fromList, address[] calldata _toList, uint256[] calldata _amounts) external override {
2252         for (uint256 i = 0; i < _fromList.length; i++) {
2253             forcedTransfer(_fromList[i], _toList[i], _amounts[i]);
2254         }
2255     }
2256 
2257    /**
2258     *  @dev See {IToken-mint}.
2259     */
2260     function mint(address _to, uint256 _amount) public override onlyAgent {
2261         require(tokenIdentityRegistry.isVerified(_to), "Identity is not verified.");
2262         require(tokenCompliance.canTransfer(msg.sender, _to, _amount), "Compliance not followed");
2263         _mint(_to, _amount);
2264         tokenCompliance.created(_to, _amount);
2265     }
2266 
2267    /**
2268     *  @dev See {IToken-batchMint}.
2269     */
2270     function batchMint(address[] calldata _toList, uint256[] calldata _amounts) external override {
2271         for (uint256 i = 0; i < _toList.length; i++) {
2272             mint(_toList[i], _amounts[i]);
2273         }
2274     }
2275 
2276    /**
2277     *  @dev See {IToken-burn}.
2278     */
2279     function burn(address _userAddress, uint256 _amount) public override onlyAgent {
2280         uint256 freeBalance = balanceOf(_userAddress) - frozenTokens[_userAddress];
2281         if (_amount > freeBalance) {
2282             uint256 tokensToUnfreeze = _amount.sub(freeBalance);
2283             frozenTokens[_userAddress] = frozenTokens[_userAddress].sub(tokensToUnfreeze);
2284             emit TokensUnfrozen(_userAddress, tokensToUnfreeze);
2285         }
2286         _burn(_userAddress, _amount);
2287         tokenCompliance.destroyed(_userAddress, _amount);
2288     }
2289 
2290    /**
2291     *  @dev See {IToken-batchBurn}.
2292     */
2293     function batchBurn(address[] calldata _userAddresses, uint256[] calldata _amounts) external override {
2294         for (uint256 i = 0; i < _userAddresses.length; i++) {
2295             burn(_userAddresses[i], _amounts[i]);
2296         }
2297     }
2298 
2299    /**
2300     *  @dev See {IToken-setAddressFrozen}.
2301     */
2302     function setAddressFrozen(address _userAddress, bool _freeze) public override onlyAgent {
2303         frozen[_userAddress] = _freeze;
2304 
2305         emit AddressFrozen(_userAddress, _freeze, msg.sender);
2306     }
2307 
2308    /**
2309     *  @dev See {IToken-batchSetAddressFrozen}.
2310     */
2311     function batchSetAddressFrozen(address[] calldata _userAddresses, bool[] calldata _freeze) external override {
2312         for (uint256 i = 0; i < _userAddresses.length; i++) {
2313             setAddressFrozen(_userAddresses[i], _freeze[i]);
2314         }
2315     }
2316 
2317    /**
2318     *  @dev See {IToken-freezePartialTokens}.
2319     */
2320     function freezePartialTokens(address _userAddress, uint256 _amount) public override onlyAgent {
2321         uint256 balance = balanceOf(_userAddress);
2322         require(balance >= frozenTokens[_userAddress] + _amount, "Amount exceeds available balance");
2323         frozenTokens[_userAddress] = frozenTokens[_userAddress].add(_amount);
2324         emit TokensFrozen(_userAddress, _amount);
2325     }
2326 
2327    /**
2328     *  @dev See {IToken-batchFreezePartialTokens}.
2329     */
2330     function batchFreezePartialTokens(address[] calldata _userAddresses, uint256[] calldata _amounts) external override {
2331         for (uint256 i = 0; i < _userAddresses.length; i++) {
2332             freezePartialTokens(_userAddresses[i], _amounts[i]);
2333         }
2334     }
2335 
2336    /**
2337     *  @dev See {IToken-unfreezePartialTokens}.
2338     */
2339     function unfreezePartialTokens(address _userAddress, uint256 _amount) public override onlyAgent {
2340         require(frozenTokens[_userAddress] >= _amount, "Amount should be less than or equal to frozen tokens");
2341         frozenTokens[_userAddress] = frozenTokens[_userAddress].sub(_amount);
2342         emit TokensUnfrozen(_userAddress, _amount);
2343     }
2344 
2345    /**
2346     *  @dev See {IToken-batchUnfreezePartialTokens}.
2347     */
2348     function batchUnfreezePartialTokens(address[] calldata _userAddresses, uint256[] calldata _amounts) external override {
2349         for (uint256 i = 0; i < _userAddresses.length; i++) {
2350             unfreezePartialTokens(_userAddresses[i], _amounts[i]);
2351         }
2352     }
2353 
2354    /**
2355     *  @dev See {IToken-setIdentityRegistry}.
2356     */
2357     function setIdentityRegistry(address _identityRegistry) external override onlyOwner {
2358         tokenIdentityRegistry = IIdentityRegistry(_identityRegistry);
2359         emit IdentityRegistryAdded(_identityRegistry);
2360     }
2361 
2362    /**
2363     *  @dev See {IToken-setCompliance}.
2364     */
2365     function setCompliance(address _compliance) external override onlyOwner {
2366         tokenCompliance = ICompliance(_compliance);
2367         emit ComplianceAdded(_compliance);
2368     }
2369 
2370    /**
2371     *  @dev See {IToken-recoveryAddress}.
2372     */
2373     function recoveryAddress(address _lostWallet, address _newWallet, address _investorOnchainID) external override onlyAgent returns (bool){
2374         require(balanceOf(_lostWallet) != 0, "no tokens to recover");
2375         IIdentity _onchainID = IIdentity(_investorOnchainID);
2376         bytes32 _key = keccak256(abi.encode(_newWallet));
2377         if (_onchainID.keyHasPurpose(_key, 1)) {
2378             uint investorTokens = balanceOf(_lostWallet);
2379             uint _frozenTokens = frozenTokens[_lostWallet];
2380             tokenIdentityRegistry.registerIdentity(_newWallet, _onchainID, tokenIdentityRegistry.investorCountry(_lostWallet));
2381             tokenIdentityRegistry.deleteIdentity(_lostWallet);
2382             forcedTransfer(_lostWallet, _newWallet, investorTokens);
2383             if (_frozenTokens > 0) {
2384                 freezePartialTokens(_newWallet, _frozenTokens);
2385             }
2386             if (frozen[_lostWallet] == true) {
2387                 setAddressFrozen(_newWallet, true);
2388             }
2389             emit RecoverySuccess(_lostWallet, _newWallet, _investorOnchainID);
2390             return true;
2391         }
2392         revert("Recovery not possible");
2393     }
2394 
2395    /**
2396     *  @dev See {IToken-transferOwnershipOnTokenContract}.
2397     */
2398     function transferOwnershipOnTokenContract(address _newOwner) external onlyOwner override {
2399         transferOwnership(_newOwner);
2400     }
2401 
2402    /**
2403     *  @dev See {IToken-addAgentOnTokenContract}.
2404     */
2405     function addAgentOnTokenContract(address _agent) external override {
2406         addAgent(_agent);
2407     }
2408 
2409    /**
2410     *  @dev See {IToken-removeAgentOnTokenContract}.
2411     */
2412     function removeAgentOnTokenContract(address _agent) external override {
2413         removeAgent(_agent);
2414     }
2415 }