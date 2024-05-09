1 // SPDX-License-Identifier: MIT
2 
3 // Rise of the Apes (ROTA). Written by NiftyLabs (https://niftylabs.dev/).
4 
5 //                                                            .#%&&%                                                      
6 //                                                       /&&%%   &%/                                                      
7 //                                                     #&#        .%#                                                     
8 //                                                   %%*            #%%                                                   
9 //                                                %##                .*,&%%.                                              
10 //                                            #%%.                   .*    .#&%%.                                         
11 //                                        .%&(                       ./    .     %%%                                      
12 //                                     *%%,                          .*    .        (%%                                   
13 //                                    %%                             .*               &%                                  
14 //                                  ,%/         *%%%&,                /%%,     .%%#(##%%&&&&&&#.                          
15 //                                 %%,       *%&&%%&%%%%%.         ,& */         #  &.   %(  .&/,&                        
16 //                           *&%%%%%      #%%%%&%. ,%&%%&&%%&     &.%               ,.& %       % &                       
17 //                          (%    (      ,%%%%*        /%&%%%% ( % %                 * %%      #*/#                       
18 //                         #%            %%%.            (%%%%%( & /                 % &  .(#/ *%                         
19 //                        %%             #%%             ,&&&%&% %.#                 ,.%,%(# %.,%.                        
20 //                      .%(               %%%          #%%%%%%&%# &.#              ..,%.    # % /&                        
21 //                      *%              %%%%%%/   /&%%%%%%%%&%%%%% .%..(         % ,&       #%   &#                       
22 //                      *%            #%%%%%%%%%%%%%%%%%%&%%%%%%%%%%# .%&(     /%%.              &%                       
23 //                      /%            %%%%#%%%%%%%%%%%%%  #%&%%%%%/ .%&%%%* .                    &&                       
24 //                       %#           /%%%%%(  %%%%#%%%%%%%%%%%%%%%%%%%%%%%%%(*%                &&                        
25 //                        ,%%               (%#%%%%%%%%%%%%%%%%%%%%%%%#%%%&%%%%#%         /%/ (%#                         
26 //                          *%*            (%%%%%%%#%%%%%%%%%%%#%%%%%###%#%%%%%%%.#.      /%                              
27 //                           #%*          %%%%#%%%%#%%%%%%%%%%%%%%%%%#%%%%#%%%%%%%%%*.%,  #%                              
28 //                           (%         (%% %%##%%%##%%###%%%%%##%#%%%%%#%%#%%%%  #%/    ##.                              
29 //                           #*         /%%  * #%%%#%%%#%#%%%%%##%%%##%%%,#%%%    #%    %%                                
30 //                          ##(          %%    %%%/ #%%# /%%%%.(###% *%%# .%%     %%  ,%/                                 
31 //                              %#((     ##(    %%   ##   %%%(  ###*       %     ,#   %(                                  
32 //                                 ##    .%%     (                               %/  ##                                   
33 //                                 /%.    #%%                                   ##  *%                                    
34 //                                  *%*    %#%     .*                   ,,     (%   #*                                    
35 //                                    ##    #%#.   #%                   ##    #%   ##                                     
36 //                                     %#     %#%* #%/                 ,%# .##*   ##                                      
37 //                                      /#,     %%%#%%/             #% #####     #%                                       
38 //                                        %#      ,%#%%%### %%# #%#%%%##%       ##                                        
39 //                                         ,%%        (####%%##%###%%(        #%                                          
40 //                                            %#           ,(#%(.          .##                                            
41 //                                              ###                      /#(                                              
42 //                                                 ##/                 (#/                                                
43 //                                                    ###/        ./(##*                                                  
44 //                                                          ,*/*.                                                         
45 //      
46 
47 // File: operator-filter-registry/src/lib/Constants.sol
48 pragma solidity ^0.8.17;
49 
50 address constant CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS = 0x000000000000AAeB6D7670E522A718067333cd4E;
51 address constant CANONICAL_CORI_SUBSCRIPTION = 0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6;
52 
53 // File: operator-filter-registry/src/IOperatorFilterRegistry.sol
54 
55 
56 pragma solidity ^0.8.13;
57 
58 interface IOperatorFilterRegistry {
59     /**
60      * @notice Returns true if operator is not filtered for a given token, either by address or codeHash. Also returns
61      *         true if supplied registrant address is not registered.
62      */
63     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
64 
65     /**
66      * @notice Registers an address with the registry. May be called by address itself or by EIP-173 owner.
67      */
68     function register(address registrant) external;
69 
70     /**
71      * @notice Registers an address with the registry and "subscribes" to another address's filtered operators and codeHashes.
72      */
73     function registerAndSubscribe(address registrant, address subscription) external;
74 
75     /**
76      * @notice Registers an address with the registry and copies the filtered operators and codeHashes from another
77      *         address without subscribing.
78      */
79     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
80 
81     /**
82      * @notice Unregisters an address with the registry and removes its subscription. May be called by address itself or by EIP-173 owner.
83      *         Note that this does not remove any filtered addresses or codeHashes.
84      *         Also note that any subscriptions to this registrant will still be active and follow the existing filtered addresses and codehashes.
85      */
86     function unregister(address addr) external;
87 
88     /**
89      * @notice Update an operator address for a registered address - when filtered is true, the operator is filtered.
90      */
91     function updateOperator(address registrant, address operator, bool filtered) external;
92 
93     /**
94      * @notice Update multiple operators for a registered address - when filtered is true, the operators will be filtered. Reverts on duplicates.
95      */
96     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
97 
98     /**
99      * @notice Update a codeHash for a registered address - when filtered is true, the codeHash is filtered.
100      */
101     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
102 
103     /**
104      * @notice Update multiple codeHashes for a registered address - when filtered is true, the codeHashes will be filtered. Reverts on duplicates.
105      */
106     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
107 
108     /**
109      * @notice Subscribe an address to another registrant's filtered operators and codeHashes. Will remove previous
110      *         subscription if present.
111      *         Note that accounts with subscriptions may go on to subscribe to other accounts - in this case,
112      *         subscriptions will not be forwarded. Instead the former subscription's existing entries will still be
113      *         used.
114      */
115     function subscribe(address registrant, address registrantToSubscribe) external;
116 
117     /**
118      * @notice Unsubscribe an address from its current subscribed registrant, and optionally copy its filtered operators and codeHashes.
119      */
120     function unsubscribe(address registrant, bool copyExistingEntries) external;
121 
122     /**
123      * @notice Get the subscription address of a given registrant, if any.
124      */
125     function subscriptionOf(address addr) external returns (address registrant);
126 
127     /**
128      * @notice Get the set of addresses subscribed to a given registrant.
129      *         Note that order is not guaranteed as updates are made.
130      */
131     function subscribers(address registrant) external returns (address[] memory);
132 
133     /**
134      * @notice Get the subscriber at a given index in the set of addresses subscribed to a given registrant.
135      *         Note that order is not guaranteed as updates are made.
136      */
137     function subscriberAt(address registrant, uint256 index) external returns (address);
138 
139     /**
140      * @notice Copy filtered operators and codeHashes from a different registrantToCopy to addr.
141      */
142     function copyEntriesOf(address registrant, address registrantToCopy) external;
143 
144     /**
145      * @notice Returns true if operator is filtered by a given address or its subscription.
146      */
147     function isOperatorFiltered(address registrant, address operator) external returns (bool);
148 
149     /**
150      * @notice Returns true if the hash of an address's code is filtered by a given address or its subscription.
151      */
152     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
153 
154     /**
155      * @notice Returns true if a codeHash is filtered by a given address or its subscription.
156      */
157     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
158 
159     /**
160      * @notice Returns a list of filtered operators for a given address or its subscription.
161      */
162     function filteredOperators(address addr) external returns (address[] memory);
163 
164     /**
165      * @notice Returns the set of filtered codeHashes for a given address or its subscription.
166      *         Note that order is not guaranteed as updates are made.
167      */
168     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
169 
170     /**
171      * @notice Returns the filtered operator at the given index of the set of filtered operators for a given address or
172      *         its subscription.
173      *         Note that order is not guaranteed as updates are made.
174      */
175     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
176 
177     /**
178      * @notice Returns the filtered codeHash at the given index of the list of filtered codeHashes for a given address or
179      *         its subscription.
180      *         Note that order is not guaranteed as updates are made.
181      */
182     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
183 
184     /**
185      * @notice Returns true if an address has registered
186      */
187     function isRegistered(address addr) external returns (bool);
188 
189     /**
190      * @dev Convenience method to compute the code hash of an arbitrary contract
191      */
192     function codeHashOf(address addr) external returns (bytes32);
193 }
194 
195 // File: operator-filter-registry/src/UpdatableOperatorFilterer.sol
196 
197 
198 pragma solidity ^0.8.13;
199 
200 
201 /**
202  * @title  UpdatableOperatorFilterer
203  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
204  *         registrant's entries in the OperatorFilterRegistry. This contract allows the Owner to update the
205  *         OperatorFilterRegistry address via updateOperatorFilterRegistryAddress, including to the zero address,
206  *         which will bypass registry checks.
207  *         Note that OpenSea will still disable creator earnings enforcement if filtered operators begin fulfilling orders
208  *         on-chain, eg, if the registry is revoked or bypassed.
209  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
210  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
211  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
212  */
213 abstract contract UpdatableOperatorFilterer {
214     /// @dev Emitted when an operator is not allowed.
215     error OperatorNotAllowed(address operator);
216     /// @dev Emitted when someone other than the owner is trying to call an only owner function.
217     error OnlyOwner();
218 
219     event OperatorFilterRegistryAddressUpdated(address newRegistry);
220 
221     IOperatorFilterRegistry public operatorFilterRegistry;
222 
223     /// @dev The constructor that is called when the contract is being deployed.
224     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe) {
225         IOperatorFilterRegistry registry = IOperatorFilterRegistry(_registry);
226         operatorFilterRegistry = registry;
227         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
228         // will not revert, but the contract will need to be registered with the registry once it is deployed in
229         // order for the modifier to filter addresses.
230         if (address(registry).code.length > 0) {
231             if (subscribe) {
232                 registry.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
233             } else {
234                 if (subscriptionOrRegistrantToCopy != address(0)) {
235                     registry.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
236                 } else {
237                     registry.register(address(this));
238                 }
239             }
240         }
241     }
242 
243     /**
244      * @dev A helper function to check if the operator is allowed.
245      */
246     modifier onlyAllowedOperator(address from) virtual {
247         // Allow spending tokens from addresses with balance
248         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
249         // from an EOA.
250         if (from != msg.sender) {
251             _checkFilterOperator(msg.sender);
252         }
253         _;
254     }
255 
256     /**
257      * @dev A helper function to check if the operator approval is allowed.
258      */
259     modifier onlyAllowedOperatorApproval(address operator) virtual {
260         _checkFilterOperator(operator);
261         _;
262     }
263 
264     /**
265      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
266      *         address, checks will be bypassed. OnlyOwner.
267      */
268     function updateOperatorFilterRegistryAddress(address newRegistry) public virtual {
269         if (msg.sender != owner()) {
270             revert OnlyOwner();
271         }
272         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
273         emit OperatorFilterRegistryAddressUpdated(newRegistry);
274     }
275 
276     /**
277      * @dev Assume the contract has an owner, but leave specific Ownable implementation up to inheriting contract.
278      */
279     function owner() public view virtual returns (address);
280 
281     /**
282      * @dev A helper function to check if the operator is allowed.
283      */
284     function _checkFilterOperator(address operator) internal view virtual {
285         IOperatorFilterRegistry registry = operatorFilterRegistry;
286         // Check registry code length to facilitate testing in environments without a deployed registry.
287         if (address(registry) != address(0) && address(registry).code.length > 0) {
288             // under normal circumstances, this function will revert rather than return false, but inheriting contracts
289             // may specify their own OperatorFilterRegistry implementations, which may behave differently
290             if (!registry.isOperatorAllowed(address(this), operator)) {
291                 revert OperatorNotAllowed(operator);
292             }
293         }
294     }
295 }
296 
297 // File: operator-filter-registry/src/RevokableOperatorFilterer.sol
298 
299 
300 pragma solidity ^0.8.13;
301 
302 
303 
304 /**
305  * @title  RevokableOperatorFilterer
306  * @notice This contract is meant to allow contracts to permanently skip OperatorFilterRegistry checks if desired. The
307  *         Registry itself has an "unregister" function, but if the contract is ownable, the owner can re-register at
308  *         any point. As implemented, this abstract contract allows the contract owner to permanently skip the
309  *         OperatorFilterRegistry checks by calling revokeOperatorFilterRegistry. Once done, the registry
310  *         address cannot be further updated.
311  *         Note that OpenSea will still disable creator earnings enforcement if filtered operators begin fulfilling orders
312  *         on-chain, eg, if the registry is revoked or bypassed.
313  */
314 abstract contract RevokableOperatorFilterer is UpdatableOperatorFilterer {
315     /// @dev Emitted when the registry has already been revoked.
316     error RegistryHasBeenRevoked();
317     /// @dev Emitted when the initial registry address is attempted to be set to the zero address.
318     error InitialRegistryAddressCannotBeZeroAddress();
319 
320     event OperatorFilterRegistryRevoked();
321 
322     bool public isOperatorFilterRegistryRevoked;
323 
324     /// @dev The constructor that is called when the contract is being deployed.
325     constructor(address _registry, address subscriptionOrRegistrantToCopy, bool subscribe)
326         UpdatableOperatorFilterer(_registry, subscriptionOrRegistrantToCopy, subscribe)
327     {
328         // don't allow creating a contract with a permanently revoked registry
329         if (_registry == address(0)) {
330             revert InitialRegistryAddressCannotBeZeroAddress();
331         }
332     }
333 
334     /**
335      * @notice Update the address that the contract will make OperatorFilter checks against. When set to the zero
336      *         address, checks will be permanently bypassed, and the address cannot be updated again. OnlyOwner.
337      */
338     function updateOperatorFilterRegistryAddress(address newRegistry) public override {
339         if (msg.sender != owner()) {
340             revert OnlyOwner();
341         }
342         // if registry has been revoked, do not allow further updates
343         if (isOperatorFilterRegistryRevoked) {
344             revert RegistryHasBeenRevoked();
345         }
346 
347         operatorFilterRegistry = IOperatorFilterRegistry(newRegistry);
348         emit OperatorFilterRegistryAddressUpdated(newRegistry);
349     }
350 
351     /**
352      * @notice Revoke the OperatorFilterRegistry address, permanently bypassing checks. OnlyOwner.
353      */
354     function revokeOperatorFilterRegistry() public {
355         if (msg.sender != owner()) {
356             revert OnlyOwner();
357         }
358         // if registry has been revoked, do not allow further updates
359         if (isOperatorFilterRegistryRevoked) {
360             revert RegistryHasBeenRevoked();
361         }
362 
363         // set to zero address to bypass checks
364         operatorFilterRegistry = IOperatorFilterRegistry(address(0));
365         isOperatorFilterRegistryRevoked = true;
366         emit OperatorFilterRegistryRevoked();
367     }
368 }
369 
370 // File: operator-filter-registry/src/RevokableDefaultOperatorFilterer.sol
371 
372 
373 pragma solidity ^0.8.13;
374 
375 
376 /**
377  * @title  RevokableDefaultOperatorFilterer
378  * @notice Inherits from RevokableOperatorFilterer and automatically subscribes to the default OpenSea subscription.
379  *         Note that OpenSea will disable creator earnings enforcement if filtered operators begin fulfilling orders
380  *         on-chain, eg, if the registry is revoked or bypassed.
381  */
382 
383 abstract contract RevokableDefaultOperatorFilterer is RevokableOperatorFilterer {
384     /// @dev The constructor that is called when the contract is being deployed.
385     constructor()
386         RevokableOperatorFilterer(CANONICAL_OPERATOR_FILTER_REGISTRY_ADDRESS, CANONICAL_CORI_SUBSCRIPTION, true)
387     {}
388 }
389 
390 // File: @openzeppelin/contracts/utils/Address.sol
391 
392 
393 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Address.sol)
394 
395 pragma solidity ^0.8.1;
396 
397 /**
398  * @dev Collection of functions related to the address type
399  */
400 library Address {
401     /**
402      * @dev Returns true if `account` is a contract.
403      *
404      * [IMPORTANT]
405      * ====
406      * It is unsafe to assume that an address for which this function returns
407      * false is an externally-owned account (EOA) and not a contract.
408      *
409      * Among others, `isContract` will return false for the following
410      * types of addresses:
411      *
412      *  - an externally-owned account
413      *  - a contract in construction
414      *  - an address where a contract will be created
415      *  - an address where a contract lived, but was destroyed
416      * ====
417      *
418      * [IMPORTANT]
419      * ====
420      * You shouldn't rely on `isContract` to protect against flash loan attacks!
421      *
422      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
423      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
424      * constructor.
425      * ====
426      */
427     function isContract(address account) internal view returns (bool) {
428         // This method relies on extcodesize/address.code.length, which returns 0
429         // for contracts in construction, since the code is only stored at the end
430         // of the constructor execution.
431 
432         return account.code.length > 0;
433     }
434 
435     /**
436      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
437      * `recipient`, forwarding all available gas and reverting on errors.
438      *
439      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
440      * of certain opcodes, possibly making contracts go over the 2300 gas limit
441      * imposed by `transfer`, making them unable to receive funds via
442      * `transfer`. {sendValue} removes this limitation.
443      *
444      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
445      *
446      * IMPORTANT: because control is transferred to `recipient`, care must be
447      * taken to not create reentrancy vulnerabilities. Consider using
448      * {ReentrancyGuard} or the
449      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
450      */
451     function sendValue(address payable recipient, uint256 amount) internal {
452         require(address(this).balance >= amount, "Address: insufficient balance");
453 
454         (bool success, ) = recipient.call{value: amount}("");
455         require(success, "Address: unable to send value, recipient may have reverted");
456     }
457 
458     /**
459      * @dev Performs a Solidity function call using a low level `call`. A
460      * plain `call` is an unsafe replacement for a function call: use this
461      * function instead.
462      *
463      * If `target` reverts with a revert reason, it is bubbled up by this
464      * function (like regular Solidity function calls).
465      *
466      * Returns the raw returned data. To convert to the expected return value,
467      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
468      *
469      * Requirements:
470      *
471      * - `target` must be a contract.
472      * - calling `target` with `data` must not revert.
473      *
474      * _Available since v3.1._
475      */
476     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
477         return functionCallWithValue(target, data, 0, "Address: low-level call failed");
478     }
479 
480     /**
481      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
482      * `errorMessage` as a fallback revert reason when `target` reverts.
483      *
484      * _Available since v3.1._
485      */
486     function functionCall(
487         address target,
488         bytes memory data,
489         string memory errorMessage
490     ) internal returns (bytes memory) {
491         return functionCallWithValue(target, data, 0, errorMessage);
492     }
493 
494     /**
495      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
496      * but also transferring `value` wei to `target`.
497      *
498      * Requirements:
499      *
500      * - the calling contract must have an ETH balance of at least `value`.
501      * - the called Solidity function must be `payable`.
502      *
503      * _Available since v3.1._
504      */
505     function functionCallWithValue(
506         address target,
507         bytes memory data,
508         uint256 value
509     ) internal returns (bytes memory) {
510         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
511     }
512 
513     /**
514      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
515      * with `errorMessage` as a fallback revert reason when `target` reverts.
516      *
517      * _Available since v3.1._
518      */
519     function functionCallWithValue(
520         address target,
521         bytes memory data,
522         uint256 value,
523         string memory errorMessage
524     ) internal returns (bytes memory) {
525         require(address(this).balance >= value, "Address: insufficient balance for call");
526         (bool success, bytes memory returndata) = target.call{value: value}(data);
527         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
528     }
529 
530     /**
531      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
532      * but performing a static call.
533      *
534      * _Available since v3.3._
535      */
536     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
537         return functionStaticCall(target, data, "Address: low-level static call failed");
538     }
539 
540     /**
541      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
542      * but performing a static call.
543      *
544      * _Available since v3.3._
545      */
546     function functionStaticCall(
547         address target,
548         bytes memory data,
549         string memory errorMessage
550     ) internal view returns (bytes memory) {
551         (bool success, bytes memory returndata) = target.staticcall(data);
552         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
553     }
554 
555     /**
556      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
557      * but performing a delegate call.
558      *
559      * _Available since v3.4._
560      */
561     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
562         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
563     }
564 
565     /**
566      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
567      * but performing a delegate call.
568      *
569      * _Available since v3.4._
570      */
571     function functionDelegateCall(
572         address target,
573         bytes memory data,
574         string memory errorMessage
575     ) internal returns (bytes memory) {
576         (bool success, bytes memory returndata) = target.delegatecall(data);
577         return verifyCallResultFromTarget(target, success, returndata, errorMessage);
578     }
579 
580     /**
581      * @dev Tool to verify that a low level call to smart-contract was successful, and revert (either by bubbling
582      * the revert reason or using the provided one) in case of unsuccessful call or if target was not a contract.
583      *
584      * _Available since v4.8._
585      */
586     function verifyCallResultFromTarget(
587         address target,
588         bool success,
589         bytes memory returndata,
590         string memory errorMessage
591     ) internal view returns (bytes memory) {
592         if (success) {
593             if (returndata.length == 0) {
594                 // only check isContract if the call was successful and the return data is empty
595                 // otherwise we already know that it was a contract
596                 require(isContract(target), "Address: call to non-contract");
597             }
598             return returndata;
599         } else {
600             _revert(returndata, errorMessage);
601         }
602     }
603 
604     /**
605      * @dev Tool to verify that a low level call was successful, and revert if it wasn't, either by bubbling the
606      * revert reason or using the provided one.
607      *
608      * _Available since v4.3._
609      */
610     function verifyCallResult(
611         bool success,
612         bytes memory returndata,
613         string memory errorMessage
614     ) internal pure returns (bytes memory) {
615         if (success) {
616             return returndata;
617         } else {
618             _revert(returndata, errorMessage);
619         }
620     }
621 
622     function _revert(bytes memory returndata, string memory errorMessage) private pure {
623         // Look for revert reason and bubble it up if present
624         if (returndata.length > 0) {
625             // The easiest way to bubble the revert reason is using memory via assembly
626             /// @solidity memory-safe-assembly
627             assembly {
628                 let returndata_size := mload(returndata)
629                 revert(add(32, returndata), returndata_size)
630             }
631         } else {
632             revert(errorMessage);
633         }
634     }
635 }
636 
637 // File: @openzeppelin/contracts/token/ERC20/extensions/draft-IERC20Permit.sol
638 
639 
640 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/draft-IERC20Permit.sol)
641 
642 pragma solidity ^0.8.0;
643 
644 /**
645  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
646  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
647  *
648  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
649  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
650  * need to send a transaction, and thus is not required to hold Ether at all.
651  */
652 interface IERC20Permit {
653     /**
654      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
655      * given ``owner``'s signed approval.
656      *
657      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
658      * ordering also apply here.
659      *
660      * Emits an {Approval} event.
661      *
662      * Requirements:
663      *
664      * - `spender` cannot be the zero address.
665      * - `deadline` must be a timestamp in the future.
666      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
667      * over the EIP712-formatted function arguments.
668      * - the signature must use ``owner``'s current nonce (see {nonces}).
669      *
670      * For more information on the signature format, see the
671      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
672      * section].
673      */
674     function permit(
675         address owner,
676         address spender,
677         uint256 value,
678         uint256 deadline,
679         uint8 v,
680         bytes32 r,
681         bytes32 s
682     ) external;
683 
684     /**
685      * @dev Returns the current nonce for `owner`. This value must be
686      * included whenever a signature is generated for {permit}.
687      *
688      * Every successful call to {permit} increases ``owner``'s nonce by one. This
689      * prevents a signature from being used multiple times.
690      */
691     function nonces(address owner) external view returns (uint256);
692 
693     /**
694      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
695      */
696     // solhint-disable-next-line func-name-mixedcase
697     function DOMAIN_SEPARATOR() external view returns (bytes32);
698 }
699 
700 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
701 
702 
703 // OpenZeppelin Contracts (last updated v4.8.0) (security/ReentrancyGuard.sol)
704 
705 pragma solidity ^0.8.0;
706 
707 /**
708  * @dev Contract module that helps prevent reentrant calls to a function.
709  *
710  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
711  * available, which can be applied to functions to make sure there are no nested
712  * (reentrant) calls to them.
713  *
714  * Note that because there is a single `nonReentrant` guard, functions marked as
715  * `nonReentrant` may not call one another. This can be worked around by making
716  * those functions `private`, and then adding `external` `nonReentrant` entry
717  * points to them.
718  *
719  * TIP: If you would like to learn more about reentrancy and alternative ways
720  * to protect against it, check out our blog post
721  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
722  */
723 abstract contract ReentrancyGuard {
724     // Booleans are more expensive than uint256 or any type that takes up a full
725     // word because each write operation emits an extra SLOAD to first read the
726     // slot's contents, replace the bits taken up by the boolean, and then write
727     // back. This is the compiler's defense against contract upgrades and
728     // pointer aliasing, and it cannot be disabled.
729 
730     // The values being non-zero value makes deployment a bit more expensive,
731     // but in exchange the refund on every call to nonReentrant will be lower in
732     // amount. Since refunds are capped to a percentage of the total
733     // transaction's gas, it is best to keep them low in cases like this one, to
734     // increase the likelihood of the full refund coming into effect.
735     uint256 private constant _NOT_ENTERED = 1;
736     uint256 private constant _ENTERED = 2;
737 
738     uint256 private _status;
739 
740     constructor() {
741         _status = _NOT_ENTERED;
742     }
743 
744     /**
745      * @dev Prevents a contract from calling itself, directly or indirectly.
746      * Calling a `nonReentrant` function from another `nonReentrant`
747      * function is not supported. It is possible to prevent this from happening
748      * by making the `nonReentrant` function external, and making it call a
749      * `private` function that does the actual work.
750      */
751     modifier nonReentrant() {
752         _nonReentrantBefore();
753         _;
754         _nonReentrantAfter();
755     }
756 
757     function _nonReentrantBefore() private {
758         // On the first call to nonReentrant, _status will be _NOT_ENTERED
759         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
760 
761         // Any calls to nonReentrant after this point will fail
762         _status = _ENTERED;
763     }
764 
765     function _nonReentrantAfter() private {
766         // By storing the original value once again, a refund is triggered (see
767         // https://eips.ethereum.org/EIPS/eip-2200)
768         _status = _NOT_ENTERED;
769     }
770 }
771 
772 // File: erc721a/contracts/IERC721A.sol
773 
774 
775 // ERC721A Contracts v4.2.3
776 // Creator: Chiru Labs
777 
778 pragma solidity ^0.8.4;
779 
780 /**
781  * @dev Interface of ERC721A.
782  */
783 interface IERC721A {
784     /**
785      * The caller must own the token or be an approved operator.
786      */
787     error ApprovalCallerNotOwnerNorApproved();
788 
789     /**
790      * The token does not exist.
791      */
792     error ApprovalQueryForNonexistentToken();
793 
794     /**
795      * Cannot query the balance for the zero address.
796      */
797     error BalanceQueryForZeroAddress();
798 
799     /**
800      * Cannot mint to the zero address.
801      */
802     error MintToZeroAddress();
803 
804     /**
805      * The quantity of tokens minted must be more than zero.
806      */
807     error MintZeroQuantity();
808 
809     /**
810      * The token does not exist.
811      */
812     error OwnerQueryForNonexistentToken();
813 
814     /**
815      * The caller must own the token or be an approved operator.
816      */
817     error TransferCallerNotOwnerNorApproved();
818 
819     /**
820      * The token must be owned by `from`.
821      */
822     error TransferFromIncorrectOwner();
823 
824     /**
825      * Cannot safely transfer to a contract that does not implement the
826      * ERC721Receiver interface.
827      */
828     error TransferToNonERC721ReceiverImplementer();
829 
830     /**
831      * Cannot transfer to the zero address.
832      */
833     error TransferToZeroAddress();
834 
835     /**
836      * The token does not exist.
837      */
838     error URIQueryForNonexistentToken();
839 
840     /**
841      * The `quantity` minted with ERC2309 exceeds the safety limit.
842      */
843     error MintERC2309QuantityExceedsLimit();
844 
845     /**
846      * The `extraData` cannot be set on an unintialized ownership slot.
847      */
848     error OwnershipNotInitializedForExtraData();
849 
850     // =============================================================
851     //                            STRUCTS
852     // =============================================================
853 
854     struct TokenOwnership {
855         // The address of the owner.
856         address addr;
857         // Stores the start time of ownership with minimal overhead for tokenomics.
858         uint64 startTimestamp;
859         // Whether the token has been burned.
860         bool burned;
861         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
862         uint24 extraData;
863     }
864 
865     // =============================================================
866     //                         TOKEN COUNTERS
867     // =============================================================
868 
869     /**
870      * @dev Returns the total number of tokens in existence.
871      * Burned tokens will reduce the count.
872      * To get the total number of tokens minted, please see {_totalMinted}.
873      */
874     function totalSupply() external view returns (uint256);
875 
876     // =============================================================
877     //                            IERC165
878     // =============================================================
879 
880     /**
881      * @dev Returns true if this contract implements the interface defined by
882      * `interfaceId`. See the corresponding
883      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
884      * to learn more about how these ids are created.
885      *
886      * This function call must use less than 30000 gas.
887      */
888     function supportsInterface(bytes4 interfaceId) external view returns (bool);
889 
890     // =============================================================
891     //                            IERC721
892     // =============================================================
893 
894     /**
895      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
896      */
897     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
898 
899     /**
900      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
901      */
902     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
903 
904     /**
905      * @dev Emitted when `owner` enables or disables
906      * (`approved`) `operator` to manage all of its assets.
907      */
908     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
909 
910     /**
911      * @dev Returns the number of tokens in `owner`'s account.
912      */
913     function balanceOf(address owner) external view returns (uint256 balance);
914 
915     /**
916      * @dev Returns the owner of the `tokenId` token.
917      *
918      * Requirements:
919      *
920      * - `tokenId` must exist.
921      */
922     function ownerOf(uint256 tokenId) external view returns (address owner);
923 
924     /**
925      * @dev Safely transfers `tokenId` token from `from` to `to`,
926      * checking first that contract recipients are aware of the ERC721 protocol
927      * to prevent tokens from being forever locked.
928      *
929      * Requirements:
930      *
931      * - `from` cannot be the zero address.
932      * - `to` cannot be the zero address.
933      * - `tokenId` token must exist and be owned by `from`.
934      * - If the caller is not `from`, it must be have been allowed to move
935      * this token by either {approve} or {setApprovalForAll}.
936      * - If `to` refers to a smart contract, it must implement
937      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
938      *
939      * Emits a {Transfer} event.
940      */
941     function safeTransferFrom(
942         address from,
943         address to,
944         uint256 tokenId,
945         bytes calldata data
946     ) external payable;
947 
948     /**
949      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
950      */
951     function safeTransferFrom(
952         address from,
953         address to,
954         uint256 tokenId
955     ) external payable;
956 
957     /**
958      * @dev Transfers `tokenId` from `from` to `to`.
959      *
960      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
961      * whenever possible.
962      *
963      * Requirements:
964      *
965      * - `from` cannot be the zero address.
966      * - `to` cannot be the zero address.
967      * - `tokenId` token must be owned by `from`.
968      * - If the caller is not `from`, it must be approved to move this token
969      * by either {approve} or {setApprovalForAll}.
970      *
971      * Emits a {Transfer} event.
972      */
973     function transferFrom(
974         address from,
975         address to,
976         uint256 tokenId
977     ) external payable;
978 
979     /**
980      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
981      * The approval is cleared when the token is transferred.
982      *
983      * Only a single account can be approved at a time, so approving the
984      * zero address clears previous approvals.
985      *
986      * Requirements:
987      *
988      * - The caller must own the token or be an approved operator.
989      * - `tokenId` must exist.
990      *
991      * Emits an {Approval} event.
992      */
993     function approve(address to, uint256 tokenId) external payable;
994 
995     /**
996      * @dev Approve or remove `operator` as an operator for the caller.
997      * Operators can call {transferFrom} or {safeTransferFrom}
998      * for any token owned by the caller.
999      *
1000      * Requirements:
1001      *
1002      * - The `operator` cannot be the caller.
1003      *
1004      * Emits an {ApprovalForAll} event.
1005      */
1006     function setApprovalForAll(address operator, bool _approved) external;
1007 
1008     /**
1009      * @dev Returns the account approved for `tokenId` token.
1010      *
1011      * Requirements:
1012      *
1013      * - `tokenId` must exist.
1014      */
1015     function getApproved(uint256 tokenId) external view returns (address operator);
1016 
1017     /**
1018      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1019      *
1020      * See {setApprovalForAll}.
1021      */
1022     function isApprovedForAll(address owner, address operator) external view returns (bool);
1023 
1024     // =============================================================
1025     //                        IERC721Metadata
1026     // =============================================================
1027 
1028     /**
1029      * @dev Returns the token collection name.
1030      */
1031     function name() external view returns (string memory);
1032 
1033     /**
1034      * @dev Returns the token collection symbol.
1035      */
1036     function symbol() external view returns (string memory);
1037 
1038     /**
1039      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1040      */
1041     function tokenURI(uint256 tokenId) external view returns (string memory);
1042 
1043     // =============================================================
1044     //                           IERC2309
1045     // =============================================================
1046 
1047     /**
1048      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1049      * (inclusive) is transferred from `from` to `to`, as defined in the
1050      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1051      *
1052      * See {_mintERC2309} for more details.
1053      */
1054     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1055 }
1056 
1057 // File: erc721a/contracts/ERC721A.sol
1058 
1059 
1060 // ERC721A Contracts v4.2.3
1061 // Creator: Chiru Labs
1062 
1063 pragma solidity ^0.8.4;
1064 
1065 
1066 /**
1067  * @dev Interface of ERC721 token receiver.
1068  */
1069 interface ERC721A__IERC721Receiver {
1070     function onERC721Received(
1071         address operator,
1072         address from,
1073         uint256 tokenId,
1074         bytes calldata data
1075     ) external returns (bytes4);
1076 }
1077 
1078 /**
1079  * @title ERC721A
1080  *
1081  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1082  * Non-Fungible Token Standard, including the Metadata extension.
1083  * Optimized for lower gas during batch mints.
1084  *
1085  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1086  * starting from `_startTokenId()`.
1087  *
1088  * Assumptions:
1089  *
1090  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1091  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1092  */
1093 contract ERC721A is IERC721A {
1094     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1095     struct TokenApprovalRef {
1096         address value;
1097     }
1098 
1099     // =============================================================
1100     //                           CONSTANTS
1101     // =============================================================
1102 
1103     // Mask of an entry in packed address data.
1104     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1105 
1106     // The bit position of `numberMinted` in packed address data.
1107     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1108 
1109     // The bit position of `numberBurned` in packed address data.
1110     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1111 
1112     // The bit position of `aux` in packed address data.
1113     uint256 private constant _BITPOS_AUX = 192;
1114 
1115     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1116     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1117 
1118     // The bit position of `startTimestamp` in packed ownership.
1119     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1120 
1121     // The bit mask of the `burned` bit in packed ownership.
1122     uint256 private constant _BITMASK_BURNED = 1 << 224;
1123 
1124     // The bit position of the `nextInitialized` bit in packed ownership.
1125     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1126 
1127     // The bit mask of the `nextInitialized` bit in packed ownership.
1128     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1129 
1130     // The bit position of `extraData` in packed ownership.
1131     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1132 
1133     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1134     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1135 
1136     // The mask of the lower 160 bits for addresses.
1137     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1138 
1139     // The maximum `quantity` that can be minted with {_mintERC2309}.
1140     // This limit is to prevent overflows on the address data entries.
1141     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1142     // is required to cause an overflow, which is unrealistic.
1143     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1144 
1145     // The `Transfer` event signature is given by:
1146     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1147     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1148         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1149 
1150     // =============================================================
1151     //                            STORAGE
1152     // =============================================================
1153 
1154     // The next token ID to be minted.
1155     uint256 private _currentIndex;
1156 
1157     // The number of tokens burned.
1158     uint256 private _burnCounter;
1159 
1160     // Token name
1161     string private _name;
1162 
1163     // Token symbol
1164     string private _symbol;
1165 
1166     // Mapping from token ID to ownership details
1167     // An empty struct value does not necessarily mean the token is unowned.
1168     // See {_packedOwnershipOf} implementation for details.
1169     //
1170     // Bits Layout:
1171     // - [0..159]   `addr`
1172     // - [160..223] `startTimestamp`
1173     // - [224]      `burned`
1174     // - [225]      `nextInitialized`
1175     // - [232..255] `extraData`
1176     mapping(uint256 => uint256) private _packedOwnerships;
1177 
1178     // Mapping owner address to address data.
1179     //
1180     // Bits Layout:
1181     // - [0..63]    `balance`
1182     // - [64..127]  `numberMinted`
1183     // - [128..191] `numberBurned`
1184     // - [192..255] `aux`
1185     mapping(address => uint256) private _packedAddressData;
1186 
1187     // Mapping from token ID to approved address.
1188     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1189 
1190     // Mapping from owner to operator approvals
1191     mapping(address => mapping(address => bool)) private _operatorApprovals;
1192 
1193     // =============================================================
1194     //                          CONSTRUCTOR
1195     // =============================================================
1196 
1197     constructor(string memory name_, string memory symbol_) {
1198         _name = name_;
1199         _symbol = symbol_;
1200         _currentIndex = _startTokenId();
1201     }
1202 
1203     // =============================================================
1204     //                   TOKEN COUNTING OPERATIONS
1205     // =============================================================
1206 
1207     /**
1208      * @dev Returns the starting token ID.
1209      * To change the starting token ID, please override this function.
1210      */
1211     function _startTokenId() internal view virtual returns (uint256) {
1212         return 0;
1213     }
1214 
1215     /**
1216      * @dev Returns the next token ID to be minted.
1217      */
1218     function _nextTokenId() internal view virtual returns (uint256) {
1219         return _currentIndex;
1220     }
1221 
1222     /**
1223      * @dev Returns the total number of tokens in existence.
1224      * Burned tokens will reduce the count.
1225      * To get the total number of tokens minted, please see {_totalMinted}.
1226      */
1227     function totalSupply() public view virtual override returns (uint256) {
1228         // Counter underflow is impossible as _burnCounter cannot be incremented
1229         // more than `_currentIndex - _startTokenId()` times.
1230         unchecked {
1231             return _currentIndex - _burnCounter - _startTokenId();
1232         }
1233     }
1234 
1235     /**
1236      * @dev Returns the total amount of tokens minted in the contract.
1237      */
1238     function _totalMinted() internal view virtual returns (uint256) {
1239         // Counter underflow is impossible as `_currentIndex` does not decrement,
1240         // and it is initialized to `_startTokenId()`.
1241         unchecked {
1242             return _currentIndex - _startTokenId();
1243         }
1244     }
1245 
1246     /**
1247      * @dev Returns the total number of tokens burned.
1248      */
1249     function _totalBurned() internal view virtual returns (uint256) {
1250         return _burnCounter;
1251     }
1252 
1253     // =============================================================
1254     //                    ADDRESS DATA OPERATIONS
1255     // =============================================================
1256 
1257     /**
1258      * @dev Returns the number of tokens in `owner`'s account.
1259      */
1260     function balanceOf(address owner) public view virtual override returns (uint256) {
1261         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1262         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1263     }
1264 
1265     /**
1266      * Returns the number of tokens minted by `owner`.
1267      */
1268     function _numberMinted(address owner) internal view returns (uint256) {
1269         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1270     }
1271 
1272     /**
1273      * Returns the number of tokens burned by or on behalf of `owner`.
1274      */
1275     function _numberBurned(address owner) internal view returns (uint256) {
1276         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1277     }
1278 
1279     /**
1280      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1281      */
1282     function _getAux(address owner) internal view returns (uint64) {
1283         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1284     }
1285 
1286     /**
1287      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1288      * If there are multiple variables, please pack them into a uint64.
1289      */
1290     function _setAux(address owner, uint64 aux) internal virtual {
1291         uint256 packed = _packedAddressData[owner];
1292         uint256 auxCasted;
1293         // Cast `aux` with assembly to avoid redundant masking.
1294         assembly {
1295             auxCasted := aux
1296         }
1297         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1298         _packedAddressData[owner] = packed;
1299     }
1300 
1301     // =============================================================
1302     //                            IERC165
1303     // =============================================================
1304 
1305     /**
1306      * @dev Returns true if this contract implements the interface defined by
1307      * `interfaceId`. See the corresponding
1308      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1309      * to learn more about how these ids are created.
1310      *
1311      * This function call must use less than 30000 gas.
1312      */
1313     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1314         // The interface IDs are constants representing the first 4 bytes
1315         // of the XOR of all function selectors in the interface.
1316         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1317         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1318         return
1319             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1320             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1321             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1322     }
1323 
1324     // =============================================================
1325     //                        IERC721Metadata
1326     // =============================================================
1327 
1328     /**
1329      * @dev Returns the token collection name.
1330      */
1331     function name() public view virtual override returns (string memory) {
1332         return _name;
1333     }
1334 
1335     /**
1336      * @dev Returns the token collection symbol.
1337      */
1338     function symbol() public view virtual override returns (string memory) {
1339         return _symbol;
1340     }
1341 
1342     /**
1343      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1344      */
1345     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1346         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1347 
1348         string memory baseURI = _baseURI();
1349         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1350     }
1351 
1352     /**
1353      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1354      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1355      * by default, it can be overridden in child contracts.
1356      */
1357     function _baseURI() internal view virtual returns (string memory) {
1358         return '';
1359     }
1360 
1361     // =============================================================
1362     //                     OWNERSHIPS OPERATIONS
1363     // =============================================================
1364 
1365     /**
1366      * @dev Returns the owner of the `tokenId` token.
1367      *
1368      * Requirements:
1369      *
1370      * - `tokenId` must exist.
1371      */
1372     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1373         return address(uint160(_packedOwnershipOf(tokenId)));
1374     }
1375 
1376     /**
1377      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1378      * It gradually moves to O(1) as tokens get transferred around over time.
1379      */
1380     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1381         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1382     }
1383 
1384     /**
1385      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1386      */
1387     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1388         return _unpackedOwnership(_packedOwnerships[index]);
1389     }
1390 
1391     /**
1392      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1393      */
1394     function _initializeOwnershipAt(uint256 index) internal virtual {
1395         if (_packedOwnerships[index] == 0) {
1396             _packedOwnerships[index] = _packedOwnershipOf(index);
1397         }
1398     }
1399 
1400     /**
1401      * Returns the packed ownership data of `tokenId`.
1402      */
1403     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1404         uint256 curr = tokenId;
1405 
1406         unchecked {
1407             if (_startTokenId() <= curr)
1408                 if (curr < _currentIndex) {
1409                     uint256 packed = _packedOwnerships[curr];
1410                     // If not burned.
1411                     if (packed & _BITMASK_BURNED == 0) {
1412                         // Invariant:
1413                         // There will always be an initialized ownership slot
1414                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1415                         // before an unintialized ownership slot
1416                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1417                         // Hence, `curr` will not underflow.
1418                         //
1419                         // We can directly compare the packed value.
1420                         // If the address is zero, packed will be zero.
1421                         while (packed == 0) {
1422                             packed = _packedOwnerships[--curr];
1423                         }
1424                         return packed;
1425                     }
1426                 }
1427         }
1428         revert OwnerQueryForNonexistentToken();
1429     }
1430 
1431     /**
1432      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1433      */
1434     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1435         ownership.addr = address(uint160(packed));
1436         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1437         ownership.burned = packed & _BITMASK_BURNED != 0;
1438         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1439     }
1440 
1441     /**
1442      * @dev Packs ownership data into a single uint256.
1443      */
1444     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1445         assembly {
1446             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1447             owner := and(owner, _BITMASK_ADDRESS)
1448             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1449             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1450         }
1451     }
1452 
1453     /**
1454      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1455      */
1456     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1457         // For branchless setting of the `nextInitialized` flag.
1458         assembly {
1459             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1460             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1461         }
1462     }
1463 
1464     // =============================================================
1465     //                      APPROVAL OPERATIONS
1466     // =============================================================
1467 
1468     /**
1469      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1470      * The approval is cleared when the token is transferred.
1471      *
1472      * Only a single account can be approved at a time, so approving the
1473      * zero address clears previous approvals.
1474      *
1475      * Requirements:
1476      *
1477      * - The caller must own the token or be an approved operator.
1478      * - `tokenId` must exist.
1479      *
1480      * Emits an {Approval} event.
1481      */
1482     function approve(address to, uint256 tokenId) public payable virtual override {
1483         address owner = ownerOf(tokenId);
1484 
1485         if (_msgSenderERC721A() != owner)
1486             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1487                 revert ApprovalCallerNotOwnerNorApproved();
1488             }
1489 
1490         _tokenApprovals[tokenId].value = to;
1491         emit Approval(owner, to, tokenId);
1492     }
1493 
1494     /**
1495      * @dev Returns the account approved for `tokenId` token.
1496      *
1497      * Requirements:
1498      *
1499      * - `tokenId` must exist.
1500      */
1501     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1502         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1503 
1504         return _tokenApprovals[tokenId].value;
1505     }
1506 
1507     /**
1508      * @dev Approve or remove `operator` as an operator for the caller.
1509      * Operators can call {transferFrom} or {safeTransferFrom}
1510      * for any token owned by the caller.
1511      *
1512      * Requirements:
1513      *
1514      * - The `operator` cannot be the caller.
1515      *
1516      * Emits an {ApprovalForAll} event.
1517      */
1518     function setApprovalForAll(address operator, bool approved) public virtual override {
1519         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1520         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1521     }
1522 
1523     /**
1524      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1525      *
1526      * See {setApprovalForAll}.
1527      */
1528     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1529         return _operatorApprovals[owner][operator];
1530     }
1531 
1532     /**
1533      * @dev Returns whether `tokenId` exists.
1534      *
1535      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1536      *
1537      * Tokens start existing when they are minted. See {_mint}.
1538      */
1539     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1540         return
1541             _startTokenId() <= tokenId &&
1542             tokenId < _currentIndex && // If within bounds,
1543             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1544     }
1545 
1546     /**
1547      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1548      */
1549     function _isSenderApprovedOrOwner(
1550         address approvedAddress,
1551         address owner,
1552         address msgSender
1553     ) private pure returns (bool result) {
1554         assembly {
1555             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1556             owner := and(owner, _BITMASK_ADDRESS)
1557             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1558             msgSender := and(msgSender, _BITMASK_ADDRESS)
1559             // `msgSender == owner || msgSender == approvedAddress`.
1560             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1561         }
1562     }
1563 
1564     /**
1565      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1566      */
1567     function _getApprovedSlotAndAddress(uint256 tokenId)
1568         private
1569         view
1570         returns (uint256 approvedAddressSlot, address approvedAddress)
1571     {
1572         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1573         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1574         assembly {
1575             approvedAddressSlot := tokenApproval.slot
1576             approvedAddress := sload(approvedAddressSlot)
1577         }
1578     }
1579 
1580     // =============================================================
1581     //                      TRANSFER OPERATIONS
1582     // =============================================================
1583 
1584     /**
1585      * @dev Transfers `tokenId` from `from` to `to`.
1586      *
1587      * Requirements:
1588      *
1589      * - `from` cannot be the zero address.
1590      * - `to` cannot be the zero address.
1591      * - `tokenId` token must be owned by `from`.
1592      * - If the caller is not `from`, it must be approved to move this token
1593      * by either {approve} or {setApprovalForAll}.
1594      *
1595      * Emits a {Transfer} event.
1596      */
1597     function transferFrom(
1598         address from,
1599         address to,
1600         uint256 tokenId
1601     ) public payable virtual override {
1602         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1603 
1604         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1605 
1606         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1607 
1608         // The nested ifs save around 20+ gas over a compound boolean condition.
1609         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1610             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1611 
1612         if (to == address(0)) revert TransferToZeroAddress();
1613 
1614         _beforeTokenTransfers(from, to, tokenId, 1);
1615 
1616         // Clear approvals from the previous owner.
1617         assembly {
1618             if approvedAddress {
1619                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1620                 sstore(approvedAddressSlot, 0)
1621             }
1622         }
1623 
1624         // Underflow of the sender's balance is impossible because we check for
1625         // ownership above and the recipient's balance can't realistically overflow.
1626         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1627         unchecked {
1628             // We can directly increment and decrement the balances.
1629             --_packedAddressData[from]; // Updates: `balance -= 1`.
1630             ++_packedAddressData[to]; // Updates: `balance += 1`.
1631 
1632             // Updates:
1633             // - `address` to the next owner.
1634             // - `startTimestamp` to the timestamp of transfering.
1635             // - `burned` to `false`.
1636             // - `nextInitialized` to `true`.
1637             _packedOwnerships[tokenId] = _packOwnershipData(
1638                 to,
1639                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1640             );
1641 
1642             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1643             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1644                 uint256 nextTokenId = tokenId + 1;
1645                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1646                 if (_packedOwnerships[nextTokenId] == 0) {
1647                     // If the next slot is within bounds.
1648                     if (nextTokenId != _currentIndex) {
1649                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1650                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1651                     }
1652                 }
1653             }
1654         }
1655 
1656         emit Transfer(from, to, tokenId);
1657         _afterTokenTransfers(from, to, tokenId, 1);
1658     }
1659 
1660     /**
1661      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1662      */
1663     function safeTransferFrom(
1664         address from,
1665         address to,
1666         uint256 tokenId
1667     ) public payable virtual override {
1668         safeTransferFrom(from, to, tokenId, '');
1669     }
1670 
1671     /**
1672      * @dev Safely transfers `tokenId` token from `from` to `to`.
1673      *
1674      * Requirements:
1675      *
1676      * - `from` cannot be the zero address.
1677      * - `to` cannot be the zero address.
1678      * - `tokenId` token must exist and be owned by `from`.
1679      * - If the caller is not `from`, it must be approved to move this token
1680      * by either {approve} or {setApprovalForAll}.
1681      * - If `to` refers to a smart contract, it must implement
1682      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1683      *
1684      * Emits a {Transfer} event.
1685      */
1686     function safeTransferFrom(
1687         address from,
1688         address to,
1689         uint256 tokenId,
1690         bytes memory _data
1691     ) public payable virtual override {
1692         transferFrom(from, to, tokenId);
1693         if (to.code.length != 0)
1694             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1695                 revert TransferToNonERC721ReceiverImplementer();
1696             }
1697     }
1698 
1699     /**
1700      * @dev Hook that is called before a set of serially-ordered token IDs
1701      * are about to be transferred. This includes minting.
1702      * And also called before burning one token.
1703      *
1704      * `startTokenId` - the first token ID to be transferred.
1705      * `quantity` - the amount to be transferred.
1706      *
1707      * Calling conditions:
1708      *
1709      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1710      * transferred to `to`.
1711      * - When `from` is zero, `tokenId` will be minted for `to`.
1712      * - When `to` is zero, `tokenId` will be burned by `from`.
1713      * - `from` and `to` are never both zero.
1714      */
1715     function _beforeTokenTransfers(
1716         address from,
1717         address to,
1718         uint256 startTokenId,
1719         uint256 quantity
1720     ) internal virtual {}
1721 
1722     /**
1723      * @dev Hook that is called after a set of serially-ordered token IDs
1724      * have been transferred. This includes minting.
1725      * And also called after one token has been burned.
1726      *
1727      * `startTokenId` - the first token ID to be transferred.
1728      * `quantity` - the amount to be transferred.
1729      *
1730      * Calling conditions:
1731      *
1732      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1733      * transferred to `to`.
1734      * - When `from` is zero, `tokenId` has been minted for `to`.
1735      * - When `to` is zero, `tokenId` has been burned by `from`.
1736      * - `from` and `to` are never both zero.
1737      */
1738     function _afterTokenTransfers(
1739         address from,
1740         address to,
1741         uint256 startTokenId,
1742         uint256 quantity
1743     ) internal virtual {}
1744 
1745     /**
1746      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1747      *
1748      * `from` - Previous owner of the given token ID.
1749      * `to` - Target address that will receive the token.
1750      * `tokenId` - Token ID to be transferred.
1751      * `_data` - Optional data to send along with the call.
1752      *
1753      * Returns whether the call correctly returned the expected magic value.
1754      */
1755     function _checkContractOnERC721Received(
1756         address from,
1757         address to,
1758         uint256 tokenId,
1759         bytes memory _data
1760     ) private returns (bool) {
1761         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1762             bytes4 retval
1763         ) {
1764             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1765         } catch (bytes memory reason) {
1766             if (reason.length == 0) {
1767                 revert TransferToNonERC721ReceiverImplementer();
1768             } else {
1769                 assembly {
1770                     revert(add(32, reason), mload(reason))
1771                 }
1772             }
1773         }
1774     }
1775 
1776     // =============================================================
1777     //                        MINT OPERATIONS
1778     // =============================================================
1779 
1780     /**
1781      * @dev Mints `quantity` tokens and transfers them to `to`.
1782      *
1783      * Requirements:
1784      *
1785      * - `to` cannot be the zero address.
1786      * - `quantity` must be greater than 0.
1787      *
1788      * Emits a {Transfer} event for each mint.
1789      */
1790     function _mint(address to, uint256 quantity) internal virtual {
1791         uint256 startTokenId = _currentIndex;
1792         if (quantity == 0) revert MintZeroQuantity();
1793 
1794         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1795 
1796         // Overflows are incredibly unrealistic.
1797         // `balance` and `numberMinted` have a maximum limit of 2**64.
1798         // `tokenId` has a maximum limit of 2**256.
1799         unchecked {
1800             // Updates:
1801             // - `balance += quantity`.
1802             // - `numberMinted += quantity`.
1803             //
1804             // We can directly add to the `balance` and `numberMinted`.
1805             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1806 
1807             // Updates:
1808             // - `address` to the owner.
1809             // - `startTimestamp` to the timestamp of minting.
1810             // - `burned` to `false`.
1811             // - `nextInitialized` to `quantity == 1`.
1812             _packedOwnerships[startTokenId] = _packOwnershipData(
1813                 to,
1814                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1815             );
1816 
1817             uint256 toMasked;
1818             uint256 end = startTokenId + quantity;
1819 
1820             // Use assembly to loop and emit the `Transfer` event for gas savings.
1821             // The duplicated `log4` removes an extra check and reduces stack juggling.
1822             // The assembly, together with the surrounding Solidity code, have been
1823             // delicately arranged to nudge the compiler into producing optimized opcodes.
1824             assembly {
1825                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1826                 toMasked := and(to, _BITMASK_ADDRESS)
1827                 // Emit the `Transfer` event.
1828                 log4(
1829                     0, // Start of data (0, since no data).
1830                     0, // End of data (0, since no data).
1831                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1832                     0, // `address(0)`.
1833                     toMasked, // `to`.
1834                     startTokenId // `tokenId`.
1835                 )
1836 
1837                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1838                 // that overflows uint256 will make the loop run out of gas.
1839                 // The compiler will optimize the `iszero` away for performance.
1840                 for {
1841                     let tokenId := add(startTokenId, 1)
1842                 } iszero(eq(tokenId, end)) {
1843                     tokenId := add(tokenId, 1)
1844                 } {
1845                     // Emit the `Transfer` event. Similar to above.
1846                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1847                 }
1848             }
1849             if (toMasked == 0) revert MintToZeroAddress();
1850 
1851             _currentIndex = end;
1852         }
1853         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1854     }
1855 
1856     /**
1857      * @dev Mints `quantity` tokens and transfers them to `to`.
1858      *
1859      * This function is intended for efficient minting only during contract creation.
1860      *
1861      * It emits only one {ConsecutiveTransfer} as defined in
1862      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1863      * instead of a sequence of {Transfer} event(s).
1864      *
1865      * Calling this function outside of contract creation WILL make your contract
1866      * non-compliant with the ERC721 standard.
1867      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1868      * {ConsecutiveTransfer} event is only permissible during contract creation.
1869      *
1870      * Requirements:
1871      *
1872      * - `to` cannot be the zero address.
1873      * - `quantity` must be greater than 0.
1874      *
1875      * Emits a {ConsecutiveTransfer} event.
1876      */
1877     function _mintERC2309(address to, uint256 quantity) internal virtual {
1878         uint256 startTokenId = _currentIndex;
1879         if (to == address(0)) revert MintToZeroAddress();
1880         if (quantity == 0) revert MintZeroQuantity();
1881         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1882 
1883         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1884 
1885         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1886         unchecked {
1887             // Updates:
1888             // - `balance += quantity`.
1889             // - `numberMinted += quantity`.
1890             //
1891             // We can directly add to the `balance` and `numberMinted`.
1892             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1893 
1894             // Updates:
1895             // - `address` to the owner.
1896             // - `startTimestamp` to the timestamp of minting.
1897             // - `burned` to `false`.
1898             // - `nextInitialized` to `quantity == 1`.
1899             _packedOwnerships[startTokenId] = _packOwnershipData(
1900                 to,
1901                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1902             );
1903 
1904             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1905 
1906             _currentIndex = startTokenId + quantity;
1907         }
1908         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1909     }
1910 
1911     /**
1912      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1913      *
1914      * Requirements:
1915      *
1916      * - If `to` refers to a smart contract, it must implement
1917      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1918      * - `quantity` must be greater than 0.
1919      *
1920      * See {_mint}.
1921      *
1922      * Emits a {Transfer} event for each mint.
1923      */
1924     function _safeMint(
1925         address to,
1926         uint256 quantity,
1927         bytes memory _data
1928     ) internal virtual {
1929         _mint(to, quantity);
1930 
1931         unchecked {
1932             if (to.code.length != 0) {
1933                 uint256 end = _currentIndex;
1934                 uint256 index = end - quantity;
1935                 do {
1936                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1937                         revert TransferToNonERC721ReceiverImplementer();
1938                     }
1939                 } while (index < end);
1940                 // Reentrancy protection.
1941                 if (_currentIndex != end) revert();
1942             }
1943         }
1944     }
1945 
1946     /**
1947      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1948      */
1949     function _safeMint(address to, uint256 quantity) internal virtual {
1950         _safeMint(to, quantity, '');
1951     }
1952 
1953     // =============================================================
1954     //                        BURN OPERATIONS
1955     // =============================================================
1956 
1957     /**
1958      * @dev Equivalent to `_burn(tokenId, false)`.
1959      */
1960     function _burn(uint256 tokenId) internal virtual {
1961         _burn(tokenId, false);
1962     }
1963 
1964     /**
1965      * @dev Destroys `tokenId`.
1966      * The approval is cleared when the token is burned.
1967      *
1968      * Requirements:
1969      *
1970      * - `tokenId` must exist.
1971      *
1972      * Emits a {Transfer} event.
1973      */
1974     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1975         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1976 
1977         address from = address(uint160(prevOwnershipPacked));
1978 
1979         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1980 
1981         if (approvalCheck) {
1982             // The nested ifs save around 20+ gas over a compound boolean condition.
1983             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1984                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1985         }
1986 
1987         _beforeTokenTransfers(from, address(0), tokenId, 1);
1988 
1989         // Clear approvals from the previous owner.
1990         assembly {
1991             if approvedAddress {
1992                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1993                 sstore(approvedAddressSlot, 0)
1994             }
1995         }
1996 
1997         // Underflow of the sender's balance is impossible because we check for
1998         // ownership above and the recipient's balance can't realistically overflow.
1999         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2000         unchecked {
2001             // Updates:
2002             // - `balance -= 1`.
2003             // - `numberBurned += 1`.
2004             //
2005             // We can directly decrement the balance, and increment the number burned.
2006             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2007             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2008 
2009             // Updates:
2010             // - `address` to the last owner.
2011             // - `startTimestamp` to the timestamp of burning.
2012             // - `burned` to `true`.
2013             // - `nextInitialized` to `true`.
2014             _packedOwnerships[tokenId] = _packOwnershipData(
2015                 from,
2016                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2017             );
2018 
2019             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2020             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2021                 uint256 nextTokenId = tokenId + 1;
2022                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2023                 if (_packedOwnerships[nextTokenId] == 0) {
2024                     // If the next slot is within bounds.
2025                     if (nextTokenId != _currentIndex) {
2026                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2027                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2028                     }
2029                 }
2030             }
2031         }
2032 
2033         emit Transfer(from, address(0), tokenId);
2034         _afterTokenTransfers(from, address(0), tokenId, 1);
2035 
2036         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2037         unchecked {
2038             _burnCounter++;
2039         }
2040     }
2041 
2042     // =============================================================
2043     //                     EXTRA DATA OPERATIONS
2044     // =============================================================
2045 
2046     /**
2047      * @dev Directly sets the extra data for the ownership data `index`.
2048      */
2049     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2050         uint256 packed = _packedOwnerships[index];
2051         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2052         uint256 extraDataCasted;
2053         // Cast `extraData` with assembly to avoid redundant masking.
2054         assembly {
2055             extraDataCasted := extraData
2056         }
2057         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2058         _packedOwnerships[index] = packed;
2059     }
2060 
2061     /**
2062      * @dev Called during each token transfer to set the 24bit `extraData` field.
2063      * Intended to be overridden by the cosumer contract.
2064      *
2065      * `previousExtraData` - the value of `extraData` before transfer.
2066      *
2067      * Calling conditions:
2068      *
2069      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2070      * transferred to `to`.
2071      * - When `from` is zero, `tokenId` will be minted for `to`.
2072      * - When `to` is zero, `tokenId` will be burned by `from`.
2073      * - `from` and `to` are never both zero.
2074      */
2075     function _extraData(
2076         address from,
2077         address to,
2078         uint24 previousExtraData
2079     ) internal view virtual returns (uint24) {}
2080 
2081     /**
2082      * @dev Returns the next extra data for the packed ownership data.
2083      * The returned result is shifted into position.
2084      */
2085     function _nextExtraData(
2086         address from,
2087         address to,
2088         uint256 prevOwnershipPacked
2089     ) private view returns (uint256) {
2090         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2091         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2092     }
2093 
2094     // =============================================================
2095     //                       OTHER OPERATIONS
2096     // =============================================================
2097 
2098     /**
2099      * @dev Returns the message sender (defaults to `msg.sender`).
2100      *
2101      * If you are writing GSN compatible contracts, you need to override this function.
2102      */
2103     function _msgSenderERC721A() internal view virtual returns (address) {
2104         return msg.sender;
2105     }
2106 
2107     /**
2108      * @dev Converts a uint256 to its ASCII string decimal representation.
2109      */
2110     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2111         assembly {
2112             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2113             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2114             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2115             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2116             let m := add(mload(0x40), 0xa0)
2117             // Update the free memory pointer to allocate.
2118             mstore(0x40, m)
2119             // Assign the `str` to the end.
2120             str := sub(m, 0x20)
2121             // Zeroize the slot after the string.
2122             mstore(str, 0)
2123 
2124             // Cache the end of the memory to calculate the length later.
2125             let end := str
2126 
2127             // We write the string from rightmost digit to leftmost digit.
2128             // The following is essentially a do-while loop that also handles the zero case.
2129             // prettier-ignore
2130             for { let temp := value } 1 {} {
2131                 str := sub(str, 1)
2132                 // Write the character to the pointer.
2133                 // The ASCII index of the '0' character is 48.
2134                 mstore8(str, add(48, mod(temp, 10)))
2135                 // Keep dividing `temp` until zero.
2136                 temp := div(temp, 10)
2137                 // prettier-ignore
2138                 if iszero(temp) { break }
2139             }
2140 
2141             let length := sub(end, str)
2142             // Move the pointer 32 bytes leftwards to make room for the length.
2143             str := sub(str, 0x20)
2144             // Store the length.
2145             mstore(str, length)
2146         }
2147     }
2148 }
2149 
2150 // File: @openzeppelin/contracts/utils/Strings.sol
2151 
2152 
2153 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
2154 
2155 pragma solidity ^0.8.0;
2156 
2157 /**
2158  * @dev String operations.
2159  */
2160 library Strings {
2161     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
2162     uint8 private constant _ADDRESS_LENGTH = 20;
2163 
2164     /**
2165      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
2166      */
2167     function toString(uint256 value) internal pure returns (string memory) {
2168         // Inspired by OraclizeAPI's implementation - MIT licence
2169         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
2170 
2171         if (value == 0) {
2172             return "0";
2173         }
2174         uint256 temp = value;
2175         uint256 digits;
2176         while (temp != 0) {
2177             digits++;
2178             temp /= 10;
2179         }
2180         bytes memory buffer = new bytes(digits);
2181         while (value != 0) {
2182             digits -= 1;
2183             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
2184             value /= 10;
2185         }
2186         return string(buffer);
2187     }
2188 
2189     /**
2190      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
2191      */
2192     function toHexString(uint256 value) internal pure returns (string memory) {
2193         if (value == 0) {
2194             return "0x00";
2195         }
2196         uint256 temp = value;
2197         uint256 length = 0;
2198         while (temp != 0) {
2199             length++;
2200             temp >>= 8;
2201         }
2202         return toHexString(value, length);
2203     }
2204 
2205     /**
2206      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
2207      */
2208     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
2209         bytes memory buffer = new bytes(2 * length + 2);
2210         buffer[0] = "0";
2211         buffer[1] = "x";
2212         for (uint256 i = 2 * length + 1; i > 1; --i) {
2213             buffer[i] = _HEX_SYMBOLS[value & 0xf];
2214             value >>= 4;
2215         }
2216         require(value == 0, "Strings: hex length insufficient");
2217         return string(buffer);
2218     }
2219 
2220     /**
2221      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
2222      */
2223     function toHexString(address addr) internal pure returns (string memory) {
2224         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
2225     }
2226 }
2227 
2228 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
2229 
2230 
2231 // OpenZeppelin Contracts (last updated v4.7.3) (utils/cryptography/ECDSA.sol)
2232 
2233 pragma solidity ^0.8.0;
2234 
2235 
2236 /**
2237  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
2238  *
2239  * These functions can be used to verify that a message was signed by the holder
2240  * of the private keys of a given address.
2241  */
2242 library ECDSA {
2243     enum RecoverError {
2244         NoError,
2245         InvalidSignature,
2246         InvalidSignatureLength,
2247         InvalidSignatureS,
2248         InvalidSignatureV
2249     }
2250 
2251     function _throwError(RecoverError error) private pure {
2252         if (error == RecoverError.NoError) {
2253             return; // no error: do nothing
2254         } else if (error == RecoverError.InvalidSignature) {
2255             revert("ECDSA: invalid signature");
2256         } else if (error == RecoverError.InvalidSignatureLength) {
2257             revert("ECDSA: invalid signature length");
2258         } else if (error == RecoverError.InvalidSignatureS) {
2259             revert("ECDSA: invalid signature 's' value");
2260         } else if (error == RecoverError.InvalidSignatureV) {
2261             revert("ECDSA: invalid signature 'v' value");
2262         }
2263     }
2264 
2265     /**
2266      * @dev Returns the address that signed a hashed message (`hash`) with
2267      * `signature` or error string. This address can then be used for verification purposes.
2268      *
2269      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2270      * this function rejects them by requiring the `s` value to be in the lower
2271      * half order, and the `v` value to be either 27 or 28.
2272      *
2273      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2274      * verification to be secure: it is possible to craft signatures that
2275      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2276      * this is by receiving a hash of the original message (which may otherwise
2277      * be too long), and then calling {toEthSignedMessageHash} on it.
2278      *
2279      * Documentation for signature generation:
2280      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
2281      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
2282      *
2283      * _Available since v4.3._
2284      */
2285     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
2286         if (signature.length == 65) {
2287             bytes32 r;
2288             bytes32 s;
2289             uint8 v;
2290             // ecrecover takes the signature parameters, and the only way to get them
2291             // currently is to use assembly.
2292             /// @solidity memory-safe-assembly
2293             assembly {
2294                 r := mload(add(signature, 0x20))
2295                 s := mload(add(signature, 0x40))
2296                 v := byte(0, mload(add(signature, 0x60)))
2297             }
2298             return tryRecover(hash, v, r, s);
2299         } else {
2300             return (address(0), RecoverError.InvalidSignatureLength);
2301         }
2302     }
2303 
2304     /**
2305      * @dev Returns the address that signed a hashed message (`hash`) with
2306      * `signature`. This address can then be used for verification purposes.
2307      *
2308      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
2309      * this function rejects them by requiring the `s` value to be in the lower
2310      * half order, and the `v` value to be either 27 or 28.
2311      *
2312      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
2313      * verification to be secure: it is possible to craft signatures that
2314      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
2315      * this is by receiving a hash of the original message (which may otherwise
2316      * be too long), and then calling {toEthSignedMessageHash} on it.
2317      */
2318     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
2319         (address recovered, RecoverError error) = tryRecover(hash, signature);
2320         _throwError(error);
2321         return recovered;
2322     }
2323 
2324     /**
2325      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
2326      *
2327      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
2328      *
2329      * _Available since v4.3._
2330      */
2331     function tryRecover(
2332         bytes32 hash,
2333         bytes32 r,
2334         bytes32 vs
2335     ) internal pure returns (address, RecoverError) {
2336         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
2337         uint8 v = uint8((uint256(vs) >> 255) + 27);
2338         return tryRecover(hash, v, r, s);
2339     }
2340 
2341     /**
2342      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
2343      *
2344      * _Available since v4.2._
2345      */
2346     function recover(
2347         bytes32 hash,
2348         bytes32 r,
2349         bytes32 vs
2350     ) internal pure returns (address) {
2351         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
2352         _throwError(error);
2353         return recovered;
2354     }
2355 
2356     /**
2357      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
2358      * `r` and `s` signature fields separately.
2359      *
2360      * _Available since v4.3._
2361      */
2362     function tryRecover(
2363         bytes32 hash,
2364         uint8 v,
2365         bytes32 r,
2366         bytes32 s
2367     ) internal pure returns (address, RecoverError) {
2368         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
2369         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
2370         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
2371         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
2372         //
2373         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
2374         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
2375         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
2376         // these malleable signatures as well.
2377         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
2378             return (address(0), RecoverError.InvalidSignatureS);
2379         }
2380         if (v != 27 && v != 28) {
2381             return (address(0), RecoverError.InvalidSignatureV);
2382         }
2383 
2384         // If the signature is valid (and not malleable), return the signer address
2385         address signer = ecrecover(hash, v, r, s);
2386         if (signer == address(0)) {
2387             return (address(0), RecoverError.InvalidSignature);
2388         }
2389 
2390         return (signer, RecoverError.NoError);
2391     }
2392 
2393     /**
2394      * @dev Overload of {ECDSA-recover} that receives the `v`,
2395      * `r` and `s` signature fields separately.
2396      */
2397     function recover(
2398         bytes32 hash,
2399         uint8 v,
2400         bytes32 r,
2401         bytes32 s
2402     ) internal pure returns (address) {
2403         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
2404         _throwError(error);
2405         return recovered;
2406     }
2407 
2408     /**
2409      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
2410      * produces hash corresponding to the one signed with the
2411      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2412      * JSON-RPC method as part of EIP-191.
2413      *
2414      * See {recover}.
2415      */
2416     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
2417         // 32 is the length in bytes of hash,
2418         // enforced by the type signature above
2419         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
2420     }
2421 
2422     /**
2423      * @dev Returns an Ethereum Signed Message, created from `s`. This
2424      * produces hash corresponding to the one signed with the
2425      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
2426      * JSON-RPC method as part of EIP-191.
2427      *
2428      * See {recover}.
2429      */
2430     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
2431         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
2432     }
2433 
2434     /**
2435      * @dev Returns an Ethereum Signed Typed Data, created from a
2436      * `domainSeparator` and a `structHash`. This produces hash corresponding
2437      * to the one signed with the
2438      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
2439      * JSON-RPC method as part of EIP-712.
2440      *
2441      * See {recover}.
2442      */
2443     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
2444         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
2445     }
2446 }
2447 
2448 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2449 
2450 
2451 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
2452 
2453 pragma solidity ^0.8.0;
2454 
2455 /**
2456  * @dev Interface of the ERC165 standard, as defined in the
2457  * https://eips.ethereum.org/EIPS/eip-165[EIP].
2458  *
2459  * Implementers can declare support of contract interfaces, which can then be
2460  * queried by others ({ERC165Checker}).
2461  *
2462  * For an implementation, see {ERC165}.
2463  */
2464 interface IERC165 {
2465     /**
2466      * @dev Returns true if this contract implements the interface defined by
2467      * `interfaceId`. See the corresponding
2468      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
2469      * to learn more about how these ids are created.
2470      *
2471      * This function call must use less than 30 000 gas.
2472      */
2473     function supportsInterface(bytes4 interfaceId) external view returns (bool);
2474 }
2475 
2476 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
2477 
2478 
2479 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC1155/IERC1155.sol)
2480 
2481 pragma solidity ^0.8.0;
2482 
2483 
2484 /**
2485  * @dev Required interface of an ERC1155 compliant contract, as defined in the
2486  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
2487  *
2488  * _Available since v3.1._
2489  */
2490 interface IERC1155 is IERC165 {
2491     /**
2492      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
2493      */
2494     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
2495 
2496     /**
2497      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
2498      * transfers.
2499      */
2500     event TransferBatch(
2501         address indexed operator,
2502         address indexed from,
2503         address indexed to,
2504         uint256[] ids,
2505         uint256[] values
2506     );
2507 
2508     /**
2509      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
2510      * `approved`.
2511      */
2512     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
2513 
2514     /**
2515      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
2516      *
2517      * If an {URI} event was emitted for `id`, the standard
2518      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
2519      * returned by {IERC1155MetadataURI-uri}.
2520      */
2521     event URI(string value, uint256 indexed id);
2522 
2523     /**
2524      * @dev Returns the amount of tokens of token type `id` owned by `account`.
2525      *
2526      * Requirements:
2527      *
2528      * - `account` cannot be the zero address.
2529      */
2530     function balanceOf(address account, uint256 id) external view returns (uint256);
2531 
2532     /**
2533      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
2534      *
2535      * Requirements:
2536      *
2537      * - `accounts` and `ids` must have the same length.
2538      */
2539     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids)
2540         external
2541         view
2542         returns (uint256[] memory);
2543 
2544     /**
2545      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
2546      *
2547      * Emits an {ApprovalForAll} event.
2548      *
2549      * Requirements:
2550      *
2551      * - `operator` cannot be the caller.
2552      */
2553     function setApprovalForAll(address operator, bool approved) external;
2554 
2555     /**
2556      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
2557      *
2558      * See {setApprovalForAll}.
2559      */
2560     function isApprovedForAll(address account, address operator) external view returns (bool);
2561 
2562     /**
2563      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
2564      *
2565      * Emits a {TransferSingle} event.
2566      *
2567      * Requirements:
2568      *
2569      * - `to` cannot be the zero address.
2570      * - If the caller is not `from`, it must have been approved to spend ``from``'s tokens via {setApprovalForAll}.
2571      * - `from` must have a balance of tokens of type `id` of at least `amount`.
2572      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
2573      * acceptance magic value.
2574      */
2575     function safeTransferFrom(
2576         address from,
2577         address to,
2578         uint256 id,
2579         uint256 amount,
2580         bytes calldata data
2581     ) external;
2582 
2583     /**
2584      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
2585      *
2586      * Emits a {TransferBatch} event.
2587      *
2588      * Requirements:
2589      *
2590      * - `ids` and `amounts` must have the same length.
2591      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
2592      * acceptance magic value.
2593      */
2594     function safeBatchTransferFrom(
2595         address from,
2596         address to,
2597         uint256[] calldata ids,
2598         uint256[] calldata amounts,
2599         bytes calldata data
2600     ) external;
2601 }
2602 
2603 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
2604 
2605 
2606 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
2607 
2608 pragma solidity ^0.8.0;
2609 
2610 /**
2611  * @dev Interface of the ERC20 standard as defined in the EIP.
2612  */
2613 interface IERC20 {
2614     /**
2615      * @dev Emitted when `value` tokens are moved from one account (`from`) to
2616      * another (`to`).
2617      *
2618      * Note that `value` may be zero.
2619      */
2620     event Transfer(address indexed from, address indexed to, uint256 value);
2621 
2622     /**
2623      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
2624      * a call to {approve}. `value` is the new allowance.
2625      */
2626     event Approval(address indexed owner, address indexed spender, uint256 value);
2627 
2628     /**
2629      * @dev Returns the amount of tokens in existence.
2630      */
2631     function totalSupply() external view returns (uint256);
2632 
2633     /**
2634      * @dev Returns the amount of tokens owned by `account`.
2635      */
2636     function balanceOf(address account) external view returns (uint256);
2637 
2638     /**
2639      * @dev Moves `amount` tokens from the caller's account to `to`.
2640      *
2641      * Returns a boolean value indicating whether the operation succeeded.
2642      *
2643      * Emits a {Transfer} event.
2644      */
2645     function transfer(address to, uint256 amount) external returns (bool);
2646 
2647     /**
2648      * @dev Returns the remaining number of tokens that `spender` will be
2649      * allowed to spend on behalf of `owner` through {transferFrom}. This is
2650      * zero by default.
2651      *
2652      * This value changes when {approve} or {transferFrom} are called.
2653      */
2654     function allowance(address owner, address spender) external view returns (uint256);
2655 
2656     /**
2657      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
2658      *
2659      * Returns a boolean value indicating whether the operation succeeded.
2660      *
2661      * IMPORTANT: Beware that changing an allowance with this method brings the risk
2662      * that someone may use both the old and the new allowance by unfortunate
2663      * transaction ordering. One possible solution to mitigate this race
2664      * condition is to first reduce the spender's allowance to 0 and set the
2665      * desired value afterwards:
2666      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
2667      *
2668      * Emits an {Approval} event.
2669      */
2670     function approve(address spender, uint256 amount) external returns (bool);
2671 
2672     /**
2673      * @dev Moves `amount` tokens from `from` to `to` using the
2674      * allowance mechanism. `amount` is then deducted from the caller's
2675      * allowance.
2676      *
2677      * Returns a boolean value indicating whether the operation succeeded.
2678      *
2679      * Emits a {Transfer} event.
2680      */
2681     function transferFrom(
2682         address from,
2683         address to,
2684         uint256 amount
2685     ) external returns (bool);
2686 }
2687 
2688 // File: @openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol
2689 
2690 
2691 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC20/utils/SafeERC20.sol)
2692 
2693 pragma solidity ^0.8.0;
2694 
2695 
2696 
2697 
2698 /**
2699  * @title SafeERC20
2700  * @dev Wrappers around ERC20 operations that throw on failure (when the token
2701  * contract returns false). Tokens that return no value (and instead revert or
2702  * throw on failure) are also supported, non-reverting calls are assumed to be
2703  * successful.
2704  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
2705  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
2706  */
2707 library SafeERC20 {
2708     using Address for address;
2709 
2710     function safeTransfer(
2711         IERC20 token,
2712         address to,
2713         uint256 value
2714     ) internal {
2715         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
2716     }
2717 
2718     function safeTransferFrom(
2719         IERC20 token,
2720         address from,
2721         address to,
2722         uint256 value
2723     ) internal {
2724         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
2725     }
2726 
2727     /**
2728      * @dev Deprecated. This function has issues similar to the ones found in
2729      * {IERC20-approve}, and its usage is discouraged.
2730      *
2731      * Whenever possible, use {safeIncreaseAllowance} and
2732      * {safeDecreaseAllowance} instead.
2733      */
2734     function safeApprove(
2735         IERC20 token,
2736         address spender,
2737         uint256 value
2738     ) internal {
2739         // safeApprove should only be called when setting an initial allowance,
2740         // or when resetting it to zero. To increase and decrease it, use
2741         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
2742         require(
2743             (value == 0) || (token.allowance(address(this), spender) == 0),
2744             "SafeERC20: approve from non-zero to non-zero allowance"
2745         );
2746         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
2747     }
2748 
2749     function safeIncreaseAllowance(
2750         IERC20 token,
2751         address spender,
2752         uint256 value
2753     ) internal {
2754         uint256 newAllowance = token.allowance(address(this), spender) + value;
2755         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2756     }
2757 
2758     function safeDecreaseAllowance(
2759         IERC20 token,
2760         address spender,
2761         uint256 value
2762     ) internal {
2763         unchecked {
2764             uint256 oldAllowance = token.allowance(address(this), spender);
2765             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
2766             uint256 newAllowance = oldAllowance - value;
2767             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
2768         }
2769     }
2770 
2771     function safePermit(
2772         IERC20Permit token,
2773         address owner,
2774         address spender,
2775         uint256 value,
2776         uint256 deadline,
2777         uint8 v,
2778         bytes32 r,
2779         bytes32 s
2780     ) internal {
2781         uint256 nonceBefore = token.nonces(owner);
2782         token.permit(owner, spender, value, deadline, v, r, s);
2783         uint256 nonceAfter = token.nonces(owner);
2784         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
2785     }
2786 
2787     /**
2788      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
2789      * on the return value: the return value is optional (but if data is returned, it must not be false).
2790      * @param token The token targeted by the call.
2791      * @param data The call data (encoded using abi.encode or one of its variants).
2792      */
2793     function _callOptionalReturn(IERC20 token, bytes memory data) private {
2794         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
2795         // we're implementing it ourselves. We use {Address-functionCall} to perform this call, which verifies that
2796         // the target address contains contract code and also asserts for success in the low-level call.
2797 
2798         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
2799         if (returndata.length > 0) {
2800             // Return data is optional
2801             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
2802         }
2803     }
2804 }
2805 
2806 // File: @openzeppelin/contracts/utils/Context.sol
2807 
2808 
2809 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2810 
2811 pragma solidity ^0.8.0;
2812 
2813 /**
2814  * @dev Provides information about the current execution context, including the
2815  * sender of the transaction and its data. While these are generally available
2816  * via msg.sender and msg.data, they should not be accessed in such a direct
2817  * manner, since when dealing with meta-transactions the account sending and
2818  * paying for execution may not be the actual sender (as far as an application
2819  * is concerned).
2820  *
2821  * This contract is only required for intermediate, library-like contracts.
2822  */
2823 abstract contract Context {
2824     function _msgSender() internal view virtual returns (address) {
2825         return msg.sender;
2826     }
2827 
2828     function _msgData() internal view virtual returns (bytes calldata) {
2829         return msg.data;
2830     }
2831 }
2832 
2833 // File: @openzeppelin/contracts/finance/PaymentSplitter.sol
2834 
2835 
2836 // OpenZeppelin Contracts (last updated v4.8.0) (finance/PaymentSplitter.sol)
2837 
2838 pragma solidity ^0.8.0;
2839 
2840 
2841 
2842 
2843 /**
2844  * @title PaymentSplitter
2845  * @dev This contract allows to split Ether payments among a group of accounts. The sender does not need to be aware
2846  * that the Ether will be split in this way, since it is handled transparently by the contract.
2847  *
2848  * The split can be in equal parts or in any other arbitrary proportion. The way this is specified is by assigning each
2849  * account to a number of shares. Of all the Ether that this contract receives, each account will then be able to claim
2850  * an amount proportional to the percentage of total shares they were assigned. The distribution of shares is set at the
2851  * time of contract deployment and can't be updated thereafter.
2852  *
2853  * `PaymentSplitter` follows a _pull payment_ model. This means that payments are not automatically forwarded to the
2854  * accounts but kept in this contract, and the actual transfer is triggered as a separate step by calling the {release}
2855  * function.
2856  *
2857  * NOTE: This contract assumes that ERC20 tokens will behave similarly to native tokens (Ether). Rebasing tokens, and
2858  * tokens that apply fees during transfers, are likely to not be supported as expected. If in doubt, we encourage you
2859  * to run tests before sending real value to this contract.
2860  */
2861 contract PaymentSplitter is Context {
2862     event PayeeAdded(address account, uint256 shares);
2863     event PaymentReleased(address to, uint256 amount);
2864     event ERC20PaymentReleased(IERC20 indexed token, address to, uint256 amount);
2865     event PaymentReceived(address from, uint256 amount);
2866 
2867     uint256 private _totalShares;
2868     uint256 private _totalReleased;
2869 
2870     mapping(address => uint256) private _shares;
2871     mapping(address => uint256) private _released;
2872     address[] private _payees;
2873 
2874     mapping(IERC20 => uint256) private _erc20TotalReleased;
2875     mapping(IERC20 => mapping(address => uint256)) private _erc20Released;
2876 
2877     /**
2878      * @dev Creates an instance of `PaymentSplitter` where each account in `payees` is assigned the number of shares at
2879      * the matching position in the `shares` array.
2880      *
2881      * All addresses in `payees` must be non-zero. Both arrays must have the same non-zero length, and there must be no
2882      * duplicates in `payees`.
2883      */
2884     constructor(address[] memory payees, uint256[] memory shares_) payable {
2885         require(payees.length == shares_.length, "PaymentSplitter: payees and shares length mismatch");
2886         require(payees.length > 0, "PaymentSplitter: no payees");
2887 
2888         for (uint256 i = 0; i < payees.length; i++) {
2889             _addPayee(payees[i], shares_[i]);
2890         }
2891     }
2892 
2893     /**
2894      * @dev The Ether received will be logged with {PaymentReceived} events. Note that these events are not fully
2895      * reliable: it's possible for a contract to receive Ether without triggering this function. This only affects the
2896      * reliability of the events, and not the actual splitting of Ether.
2897      *
2898      * To learn more about this see the Solidity documentation for
2899      * https://solidity.readthedocs.io/en/latest/contracts.html#fallback-function[fallback
2900      * functions].
2901      */
2902     receive() external payable virtual {
2903         emit PaymentReceived(_msgSender(), msg.value);
2904     }
2905 
2906     /**
2907      * @dev Getter for the total shares held by payees.
2908      */
2909     function totalShares() public view returns (uint256) {
2910         return _totalShares;
2911     }
2912 
2913     /**
2914      * @dev Getter for the total amount of Ether already released.
2915      */
2916     function totalReleased() public view returns (uint256) {
2917         return _totalReleased;
2918     }
2919 
2920     /**
2921      * @dev Getter for the total amount of `token` already released. `token` should be the address of an IERC20
2922      * contract.
2923      */
2924     function totalReleased(IERC20 token) public view returns (uint256) {
2925         return _erc20TotalReleased[token];
2926     }
2927 
2928     /**
2929      * @dev Getter for the amount of shares held by an account.
2930      */
2931     function shares(address account) public view returns (uint256) {
2932         return _shares[account];
2933     }
2934 
2935     /**
2936      * @dev Getter for the amount of Ether already released to a payee.
2937      */
2938     function released(address account) public view returns (uint256) {
2939         return _released[account];
2940     }
2941 
2942     /**
2943      * @dev Getter for the amount of `token` tokens already released to a payee. `token` should be the address of an
2944      * IERC20 contract.
2945      */
2946     function released(IERC20 token, address account) public view returns (uint256) {
2947         return _erc20Released[token][account];
2948     }
2949 
2950     /**
2951      * @dev Getter for the address of the payee number `index`.
2952      */
2953     function payee(uint256 index) public view returns (address) {
2954         return _payees[index];
2955     }
2956 
2957     /**
2958      * @dev Getter for the amount of payee's releasable Ether.
2959      */
2960     function releasable(address account) public view returns (uint256) {
2961         uint256 totalReceived = address(this).balance + totalReleased();
2962         return _pendingPayment(account, totalReceived, released(account));
2963     }
2964 
2965     /**
2966      * @dev Getter for the amount of payee's releasable `token` tokens. `token` should be the address of an
2967      * IERC20 contract.
2968      */
2969     function releasable(IERC20 token, address account) public view returns (uint256) {
2970         uint256 totalReceived = token.balanceOf(address(this)) + totalReleased(token);
2971         return _pendingPayment(account, totalReceived, released(token, account));
2972     }
2973 
2974     /**
2975      * @dev Triggers a transfer to `account` of the amount of Ether they are owed, according to their percentage of the
2976      * total shares and their previous withdrawals.
2977      */
2978     function release(address payable account) public virtual {
2979         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
2980 
2981         uint256 payment = releasable(account);
2982 
2983         require(payment != 0, "PaymentSplitter: account is not due payment");
2984 
2985         // _totalReleased is the sum of all values in _released.
2986         // If "_totalReleased += payment" does not overflow, then "_released[account] += payment" cannot overflow.
2987         _totalReleased += payment;
2988         unchecked {
2989             _released[account] += payment;
2990         }
2991 
2992         Address.sendValue(account, payment);
2993         emit PaymentReleased(account, payment);
2994     }
2995 
2996     /**
2997      * @dev Triggers a transfer to `account` of the amount of `token` tokens they are owed, according to their
2998      * percentage of the total shares and their previous withdrawals. `token` must be the address of an IERC20
2999      * contract.
3000      */
3001     function release(IERC20 token, address account) public virtual {
3002         require(_shares[account] > 0, "PaymentSplitter: account has no shares");
3003 
3004         uint256 payment = releasable(token, account);
3005 
3006         require(payment != 0, "PaymentSplitter: account is not due payment");
3007 
3008         // _erc20TotalReleased[token] is the sum of all values in _erc20Released[token].
3009         // If "_erc20TotalReleased[token] += payment" does not overflow, then "_erc20Released[token][account] += payment"
3010         // cannot overflow.
3011         _erc20TotalReleased[token] += payment;
3012         unchecked {
3013             _erc20Released[token][account] += payment;
3014         }
3015 
3016         SafeERC20.safeTransfer(token, account, payment);
3017         emit ERC20PaymentReleased(token, account, payment);
3018     }
3019 
3020     /**
3021      * @dev internal logic for computing the pending payment of an `account` given the token historical balances and
3022      * already released amounts.
3023      */
3024     function _pendingPayment(
3025         address account,
3026         uint256 totalReceived,
3027         uint256 alreadyReleased
3028     ) private view returns (uint256) {
3029         return (totalReceived * _shares[account]) / _totalShares - alreadyReleased;
3030     }
3031 
3032     /**
3033      * @dev Add a new payee to the contract.
3034      * @param account The address of the payee to add.
3035      * @param shares_ The number of shares owned by the payee.
3036      */
3037     function _addPayee(address account, uint256 shares_) private {
3038         require(account != address(0), "PaymentSplitter: account is the zero address");
3039         require(shares_ > 0, "PaymentSplitter: shares are 0");
3040         require(_shares[account] == 0, "PaymentSplitter: account already has shares");
3041 
3042         _payees.push(account);
3043         _shares[account] = shares_;
3044         _totalShares = _totalShares + shares_;
3045         emit PayeeAdded(account, shares_);
3046     }
3047 }
3048 
3049 // File: @openzeppelin/contracts/access/Ownable.sol
3050 
3051 
3052 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
3053 
3054 pragma solidity ^0.8.0;
3055 
3056 
3057 /**
3058  * @dev Contract module which provides a basic access control mechanism, where
3059  * there is an account (an owner) that can be granted exclusive access to
3060  * specific functions.
3061  *
3062  * By default, the owner account will be the one that deploys the contract. This
3063  * can later be changed with {transferOwnership}.
3064  *
3065  * This module is used through inheritance. It will make available the modifier
3066  * `onlyOwner`, which can be applied to your functions to restrict their use to
3067  * the owner.
3068  */
3069 abstract contract Ownable is Context {
3070     address private _owner;
3071 
3072     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3073 
3074     /**
3075      * @dev Initializes the contract setting the deployer as the initial owner.
3076      */
3077     constructor() {
3078         _transferOwnership(_msgSender());
3079     }
3080 
3081     /**
3082      * @dev Throws if called by any account other than the owner.
3083      */
3084     modifier onlyOwner() {
3085         _checkOwner();
3086         _;
3087     }
3088 
3089     /**
3090      * @dev Returns the address of the current owner.
3091      */
3092     function owner() public view virtual returns (address) {
3093         return _owner;
3094     }
3095 
3096     /**
3097      * @dev Throws if the sender is not the owner.
3098      */
3099     function _checkOwner() internal view virtual {
3100         require(owner() == _msgSender(), "Ownable: caller is not the owner");
3101     }
3102 
3103     /**
3104      * @dev Leaves the contract without owner. It will not be possible to call
3105      * `onlyOwner` functions anymore. Can only be called by the current owner.
3106      *
3107      * NOTE: Renouncing ownership will leave the contract without an owner,
3108      * thereby removing any functionality that is only available to the owner.
3109      */
3110     function renounceOwnership() public virtual onlyOwner {
3111         _transferOwnership(address(0));
3112     }
3113 
3114     /**
3115      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3116      * Can only be called by the current owner.
3117      */
3118     function transferOwnership(address newOwner) public virtual onlyOwner {
3119         require(newOwner != address(0), "Ownable: new owner is the zero address");
3120         _transferOwnership(newOwner);
3121     }
3122 
3123     /**
3124      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3125      * Internal function without access restriction.
3126      */
3127     function _transferOwnership(address newOwner) internal virtual {
3128         address oldOwner = _owner;
3129         _owner = newOwner;
3130         emit OwnershipTransferred(oldOwner, newOwner);
3131     }
3132 }
3133 
3134 // File: ROTA.sol
3135 
3136 pragma solidity ^ 0.8.17;
3137 
3138 
3139 interface LookingGlass {
3140     function burnForAddress(uint256 _id, address _address) external;
3141 }
3142 
3143 interface MintPass1155 {
3144     function burnForAddress(uint256 _id, uint256 _quantity, address _address) external;
3145 }
3146 
3147 contract ROTA is ERC721A, Ownable, RevokableDefaultOperatorFilterer, PaymentSplitter, ReentrancyGuard {
3148 
3149     event NonMutationMint(uint256 tokenId, uint256 amount);
3150     event MutationMint(uint256 tokenId, uint16 genesisId, uint16 lookingGlassId);
3151     event TokenTypeUpdate(uint256 tokenId, uint16 newValue);
3152 
3153     enum MintType { PUBLIC, BRONZE, SILVER, GOLD }
3154 
3155     address private GENESIS_ATS = 0x7CB90567a118cd9F6CA326067A0813b289bdCb54;
3156     address private LOOKING_GLASS = 0x775D576F54901B4bf23CB66B21dD14343c8AF888;
3157     address private MINT_PASS = 0xa1656eB49E965084A8BF1B1E9c1eDB843395dD84;
3158 
3159     address private signer = 0xdD92ADeA037A7a6206A5e39644F26621D01CE4e4;
3160     address private crossMint = 0xdAb1a1854214684acE522439684a145E62505233;
3161     address public futureUtilityContract;
3162 
3163     string public _metadata;
3164 
3165     uint256 constant MAX_SUPPLY = 10108;
3166     uint256 constant MAX_ALLOWLIST_PUBLIC = 7000;
3167     uint256 constant MAX_MUTATIONS = 2331;
3168     uint256 constant MAX_RESERVED = 777;
3169 
3170     mapping(MintType => uint256) private mintCost;
3171     mapping(MintType => uint256) private mintMax;
3172 
3173     mapping(MintType => bool) private mintActive;
3174 
3175     mapping(MintType => mapping(address => uint256)) public typeToWalletMinted;
3176 
3177     bool public isBurnActive = false;
3178     bool public isReservedActive = false;
3179     bool public isMutationsActive = false;
3180 
3181     uint256 public nonMutatedMinted;
3182 
3183     mapping(uint16 => uint16) public tokenToType;
3184     mapping(uint16 => bool) public genesisMinted;
3185     
3186     /// @notice collection payouts
3187     address[] private addressList = [
3188         0x98eF98AfF49eA1b3e759d46715cc76620777685e,
3189         0xd72192822D7E8FF5707a80B63Df004B6c3817579,
3190         0x4778E346f9686218F071f250F6B493e30b1Ee510,
3191         0x9aB0FC7c84694780c298766e7574f763DD7968cE,
3192         0xa69B6935B0F38506b81224B4612d7Ea49A4B0aCC,
3193         0xfF745F093B4B32b6655AC66E57A7aF645F8f9e8f,
3194         0xFcFdc91CE1A75e397a963141D4e43bFD32D1848B,
3195         0x6E8c8B9E868dA7aC2a46403C7F530e565CbFB762,
3196         0xfca06e64f9Fea9d02c4a38D54347D4e628a1085F,
3197         0x178cb7c511B557e413f03e9A8A6fA7243d96c436,
3198         0x3978a70Acce93153f524e8fcdcBA1E3ace0aC05B 
3199     ];
3200     
3201     uint256[] private shareList = [
3202         20,
3203         15,
3204         15,
3205         7,
3206         5,
3207         2,
3208         2,
3209         1,
3210         1,
3211         1,
3212         31
3213     ];
3214 
3215     constructor() ERC721A("Rise of the Apes", "ROTA") PaymentSplitter(addressList, shareList) {
3216 
3217         mintCost[MintType.PUBLIC] = 0.059 ether;
3218         mintCost[MintType.BRONZE] = 0.059 ether;
3219         mintCost[MintType.SILVER] = 0.059 ether;
3220         mintCost[MintType.GOLD] = 0.049 ether;
3221 
3222         mintMax[MintType.PUBLIC] = 10;
3223         mintMax[MintType.BRONZE] = 5;
3224         mintMax[MintType.SILVER] = 5;
3225         mintMax[MintType.GOLD] = 2;
3226 
3227         mintActive[MintType.PUBLIC] = false;
3228         mintActive[MintType.BRONZE] = false;
3229         mintActive[MintType.SILVER] = false;
3230         mintActive[MintType.GOLD] = false;
3231 
3232     }
3233 
3234     function genesisMint(uint16 genesisId, uint16 lookingGlassId) public nonReentrant {
3235         require(isMutationsActive);
3236         require(_totalMinted() + 1 <= MAX_SUPPLY, "Minted out");
3237         require(msg.sender == tx.origin, "EOA only");
3238         
3239         _mutationMint(genesisId, lookingGlassId);
3240     }
3241 
3242     function _mutationMint(uint16 genesisId, uint16 lookingGlassId) internal {
3243         require(msg.sender == IERC721A(GENESIS_ATS).ownerOf(genesisId), "Not owner");
3244         require(!genesisMinted[genesisId], "Already minted");
3245 
3246         uint16 tokenId = uint16(_totalMinted());
3247 
3248         genesisMinted[genesisId] = true;
3249 
3250         LookingGlass(LOOKING_GLASS).burnForAddress(lookingGlassId, msg.sender);
3251         tokenToType[tokenId] = lookingGlassId;
3252 
3253         _mint(msg.sender, 1);
3254 
3255         emit MutationMint(tokenId, genesisId, lookingGlassId);
3256     }
3257 
3258     function reservedMint(uint256 amount) public nonReentrant {
3259         require(isReservedActive);
3260         require(msg.sender == tx.origin, "EOA only");
3261         require(_totalMinted() + amount <= MAX_SUPPLY, "Minted out");
3262 
3263         MintPass1155(MINT_PASS).burnForAddress(1, amount, msg.sender);
3264         
3265         _mint(msg.sender, amount);
3266 
3267         emit NonMutationMint(_totalMinted(), amount);
3268     }
3269 
3270     function mint(address wallet, bytes calldata voucher, uint256 amount, bool isCrossmint, MintType mintType) external payable nonReentrant {
3271 
3272         uint256 costPerMint = mintCost[mintType];
3273         uint256 maxToMint = mintMax[mintType];
3274 
3275         //Mint active also guards against non existant mint type.
3276         require(mintActive[mintType], "Mint type not active");
3277 
3278         require(msg.sender == tx.origin, "EOA only");
3279 
3280         //Supply checks
3281         require(_totalMinted() + amount <= MAX_SUPPLY, "Minted out");
3282         require(nonMutatedMinted + amount <= MAX_ALLOWLIST_PUBLIC, "Allowlist minted out");
3283 
3284         //Cost check
3285         require(msg.value >= costPerMint * amount, "Ether value sent is not correct");
3286 
3287         //Crossmint checks
3288         if(isCrossmint) require(msg.sender == crossMint, "Crossmint only");
3289         else require(msg.sender == wallet, "Not your voucher");
3290 
3291         require(typeToWalletMinted[mintType][wallet] + amount <= maxToMint, "Too many");
3292 
3293         if(mintType != MintType.PUBLIC) {
3294             bytes32 hash = keccak256(abi.encodePacked(wallet));
3295             require(_verifySignature(signer, hash, voucher), "Invalid voucher");
3296         }
3297 
3298         nonMutatedMinted += amount;
3299 
3300         typeToWalletMinted[mintType][wallet] += amount;
3301 
3302         _mint(wallet, amount);
3303 
3304         emit NonMutationMint(_totalMinted(), amount);
3305     }
3306 
3307     function mintAdmin(uint256 amount) external payable nonReentrant onlyOwner {
3308         require(_totalMinted() + amount <= MAX_SUPPLY, "Minted out");
3309 
3310         _mint(msg.sender, amount);
3311 
3312         emit NonMutationMint(_totalMinted(), amount);
3313     }
3314 
3315     function burn(uint256[] memory tokenIds) public nonReentrant {
3316         require(isBurnActive);
3317         for(uint i = 0; i < tokenIds.length; i++)
3318             _burn(tokenIds[i], true);
3319 
3320     }
3321 
3322     function _verifySignature(address _signer, bytes32 _hash, bytes memory _signature) internal pure returns (bool) {
3323         return _signer == ECDSA.recover(ECDSA.toEthSignedMessageHash(_hash), _signature);
3324     }
3325 
3326     function setSigner(address _signer) external onlyOwner {
3327         signer = _signer;
3328     }
3329 
3330     function setApprovalForAll(
3331         address operator,
3332         bool approved
3333     ) public override onlyAllowedOperatorApproval(operator) {
3334         super.setApprovalForAll(operator, approved);
3335     }
3336 
3337     function approve(
3338         address operator,
3339         uint256 tokenId
3340     ) public payable override onlyAllowedOperatorApproval(operator) {
3341         super.approve(operator, tokenId);
3342     }
3343 
3344     function transferFrom(
3345         address from,
3346         address to,
3347         uint256 tokenId
3348     ) public payable override onlyAllowedOperator(from) {
3349         super.transferFrom(from, to, tokenId);
3350     }
3351 
3352     function safeTransferFrom(
3353         address from,
3354         address to,
3355         uint256 tokenId
3356     ) public payable override onlyAllowedOperator(from) {
3357         super.safeTransferFrom(from, to, tokenId);
3358     }
3359 
3360     function safeTransferFrom(
3361         address from,
3362         address to,
3363         uint256 tokenId,
3364         bytes memory data
3365     ) public payable override onlyAllowedOperator(from) {
3366         super.safeTransferFrom(from, to, tokenId, data);
3367     }
3368 
3369     function setMetadata(string memory metadata) public onlyOwner {
3370         _metadata = metadata;
3371     }
3372 
3373     function _baseURI() internal view virtual override returns(string memory) {
3374         return _metadata;
3375     }
3376 
3377     function setMintActive(MintType mintType, bool state) public onlyOwner {
3378         mintActive[mintType] = state;
3379     }
3380 
3381     function setBurnActive() public onlyOwner {
3382         isBurnActive = !isBurnActive;
3383     }
3384 
3385     function setReservedActive() public onlyOwner {
3386         isReservedActive = !isReservedActive;
3387     }
3388 
3389     function setMutationsActive() public onlyOwner {
3390         isMutationsActive = !isMutationsActive;
3391     }
3392 
3393     function setMintCost(MintType mintType, uint256 newCost) public onlyOwner {
3394         mintCost[mintType] = newCost;
3395     }
3396 
3397     function setMintMax(MintType mintType, uint256 newMax) public onlyOwner {
3398         mintMax[mintType] = newMax;
3399     }
3400 
3401     function updateTokenType(uint16 tokenId, uint16 newValue) external onlyTypeChanger {
3402         tokenToType[tokenId] = newValue;
3403 
3404         emit TokenTypeUpdate(tokenId, newValue);
3405     }
3406 
3407     function setGenesisContract(address _contract) public onlyOwner {
3408         GENESIS_ATS = _contract;
3409     }
3410 
3411     function setLookingGlassContract(address _contract) public onlyOwner {
3412         LOOKING_GLASS = _contract;
3413     }
3414 
3415     function setMintPassContract(address _contract) public onlyOwner {
3416         MINT_PASS = _contract;
3417     }
3418 
3419     function emergencyWithdraw() public payable onlyOwner {
3420         (bool success, ) = payable(msg.sender).call {value: address(this).balance}("");
3421         require(success);
3422     }
3423   
3424     modifier onlyTypeChanger {
3425         require(msg.sender == owner() || msg.sender == futureUtilityContract);
3426         _;
3427     }
3428 
3429     function getAmountMintedPerType(MintType mintType, address _address) public view returns (uint256) {
3430         return typeToWalletMinted[mintType][_address];
3431     }
3432 
3433     function owner() public view override(Ownable, UpdatableOperatorFilterer) returns (address) {
3434         return Ownable.owner();
3435     }
3436 
3437 }