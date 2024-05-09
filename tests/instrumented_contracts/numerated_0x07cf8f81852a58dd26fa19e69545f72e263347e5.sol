1 pragma solidity 0.5.9; // optimization enabled, runs: 10000, evm: constantinople
2 
3 
4 /**
5  * @title HomeWork Interface (version 1) - EIP165 ID 0xe5399799
6  * @author 0age
7  * @notice Homework is a utility to find, share, and reuse "home" addresses for
8  * contracts. Anyone can work to find a new home address by searching for keys,
9  * a 32-byte value with the first 20 bytes equal to the finder's calling address
10  * (or derived by hashing an arbitrary 32-byte salt and the caller's address),
11  * and can then deploy any contract they like (even one with a constructor) to
12  * the address, or mint an ERC721 token that the owner can redeem that will then
13  * allow them to do the same. Also, if the contract is `SELFDESTRUCT`ed, a new
14  * contract can be redeployed by the current controller to the same address!
15  * @dev This contract allows contract addresses to be located ahead of time, and
16  * for arbitrary bytecode to be deployed (and redeployed if so desired, i.e.
17  * metamorphic contracts) to the located address by a designated controller. To
18  * enable this, the contract first deploys an "initialization-code-in-runtime"
19  * contract, with the creation code of the contract you want to deploy stored in
20  * RUNTIME code. Then, to deploy the actual contract, it retrieves the address
21  * of the storage contract and `DELEGATECALL`s into it to execute the init code
22  * and, if successful, retrieves and returns the contract runtime code. Rather
23  * than using a located address directly, you can also lock it in the contract
24  * and mint and ERC721 token for it, which can then be redeemed in order to gain
25  * control over deployment to the address (note that tokens may not be minted if
26  * the contract they control currently has a deployed contract at that address).
27  * Once a contract undergoes metamorphosis, all existing storage will be deleted
28  * and any existing contract code will be replaced with the deployed contract
29  * code of the new implementation contract. The mechanisms behind this contract 
30  * are highly experimental - proceed with caution and please share any exploits
31  * or optimizations you discover.
32  */
33 interface IHomeWork {
34   // Fires when a contract is deployed or redeployed to a given home address.
35   event NewResident(
36     address indexed homeAddress,
37     bytes32 key,
38     bytes32 runtimeCodeHash
39   );
40 
41   // Fires when a new runtime storage contract is deployed.
42   event NewRuntimeStorageContract(
43     address runtimeStorageContract,
44     bytes32 runtimeCodeHash
45   );
46 
47   // Fires when a controller is changed from the default controller.
48   event NewController(bytes32 indexed key, address newController);
49 
50   // Fires when a new high score is submitted.
51   event NewHighScore(bytes32 key, address submitter, uint256 score);
52 
53   // Track total contract deploys and current controller for each home address.
54   struct HomeAddress {
55     bool exists;
56     address controller;
57     uint88 deploys;
58   }
59 
60   // Track derivation of key for a given home address based on salt & submitter.
61   struct KeyInformation {
62     bytes32 key;
63     bytes32 salt;
64     address submitter;
65   }
66 
67   /**
68    * @notice Deploy a new contract with the desired initialization code to the
69    * home address corresponding to a given key. Two conditions must be met: the
70    * submitter must be designated as the controller of the home address (with
71    * the initial controller set to the address corresponding to the first twenty
72    * bytes of the key), and there must not be a contract currently deployed at
73    * the home address. These conditions can be checked by calling
74    * `getHomeAddressInformation` and `isDeployable` with the same key.
75    * @param key bytes32 The unique value used to derive the home address.
76    * @param initializationCode bytes The contract creation code that will be
77    * used to deploy the contract to the home address.
78    * @return The home address of the deployed contract.
79    * @dev In order to deploy the contract to the home address, a new contract
80    * will be deployed with runtime code set to the initialization code of the
81    * contract that will be deployed to the home address. Then, metamorphic
82    * initialization code will retrieve that initialization code and use it to
83    * set up and deploy the desired contract to the home address. Bear in mind
84    * that the deployed contract will interpret msg.sender as the address of THIS
85    * contract, and not the address of the submitter - if the constructor of the
86    * deployed contract uses msg.sender to set up ownership or other variables,
87    * you must modify it to accept a constructor argument with the appropriate
88    * address, or alternately to hard-code the intended address. Also, if your
89    * contract DOES have constructor arguments, remember to include them as
90    * ABI-encoded arguments at the end of the initialization code, just as you
91    * would when performing a standard deploy. You may also want to provide the
92    * key to `setReverseLookup` in order to find it again using only the home
93    * address to prevent accidentally losing the key.
94    */
95   function deploy(bytes32 key, bytes calldata initializationCode)
96     external
97     payable
98     returns (address homeAddress, bytes32 runtimeCodeHash);
99 
100   /**
101    * @notice Mint an ERC721 token to the supplied owner that can be redeemed in
102    * order to gain control of a home address corresponding to a given key. Two
103    * conditions must be met: the submitter must be designated as the controller
104    * of the home address (with the initial controller set to the address
105    * corresponding to the first 20 bytes of the key), and there must not be a
106    * contract currently deployed at the home address. These conditions can be
107    * checked by calling `getHomeAddressInformation` and `isDeployable` with the
108    * same key.
109    * @param key bytes32 The unique value used to derive the home address.
110    * @param owner address The account that will be granted ownership of the
111    * ERC721 token.
112    * @dev In order to mint an ERC721 token, the assocated home address cannot be
113    * in use, or else the token will not be able to deploy to the home address.
114    * The controller is set to this contract until the token is redeemed, at
115    * which point the redeemer designates a new controller for the home address.
116    * The key of the home address and the tokenID of the ERC721 token are the
117    * same value, but different types (bytes32 vs. uint256).
118    */
119   function lock(bytes32 key, address owner) external;
120 
121   /**
122    * @notice Burn an ERC721 token to allow the supplied controller to gain the
123    * ability to deploy to the home address corresponding to the key matching the
124    * burned token. The submitter must be designated as either the owner of the
125    * token or as an approved spender.
126    * @param tokenId uint256 The ID of the ERC721 token to redeem.
127    * @param controller address The account that will be granted control of the
128    * home address corresponding to the given token.
129    * @dev The controller cannot be designated as the address of this contract,
130    * the null address, or the home address (the restriction on setting the home
131    * address as the controller is due to the fact that the home address will not
132    * be able to deploy to itself, as it needs to be empty before a contract can
133    * be deployed to it).
134    */
135   function redeem(uint256 tokenId, address controller) external;
136 
137   /**
138    * @notice Transfer control over deployment to the home address corresponding
139    * to a given key. The caller must be designated as the current controller of
140    * the home address (with the initial controller set to the address
141    * corresponding to the first 20 bytes of the key) - This condition can be
142    * checked by calling `getHomeAddressInformation` with the same key.
143    * @param key bytes32 The unique value used to derive the home address.
144    * @param controller address The account that will be granted control of the
145    * home address corresponding to the given key.
146    * @dev The controller cannot be designated as the address of this contract,
147    * the null address, or the home address (the restriction on setting the home
148    * address as the controller is due to the fact that the home address will not
149    * be able to deploy to itself, as it needs to be empty before a contract can
150    * be deployed to it).
151    */
152   function assignController(bytes32 key, address controller) external;
153 
154   /**
155    * @notice Transfer control over deployment to the home address corresponding
156    * to a given key to the null address, which will prevent it from being
157    * deployed to again in the future. The caller must be designated as the
158    * current controller of the corresponding home address (with the initial
159    * controller set to the address corresponding to the first 20 bytes of the
160    * key) - This condition can be checked by calling `getHomeAddressInformation`
161    * with the same key.
162    * @param key bytes32 The unique value used to derive the home address.
163    */
164   function relinquishControl(bytes32 key) external;
165 
166   /**
167    * @notice Burn an ERC721 token, set a supplied controller, and deploy a new
168    * contract with the supplied initialization code to the corresponding home
169    * address for the given token. The submitter must be designated as either the
170    * owner of the token or as an approved spender.
171    * @param tokenId uint256 The ID of the ERC721 token to redeem.
172    * @param controller address The account that will be granted control of the
173    * home address corresponding to the given token.
174    * @param initializationCode bytes The contract creation code that will be
175    * used to deploy the contract to the home address.
176    * @return The home address and runtime code hash of the deployed contract.
177    * @dev In order to deploy the contract to the home address, a new contract
178    * will be deployed with runtime code set to the initialization code of the
179    * contract that will be deployed to the home address. Then, metamorphic
180    * initialization code will retrieve that initialization code and use it to
181    * set up and deploy the desired contract to the home address. Bear in mind
182    * that the deployed contract will interpret msg.sender as the address of THIS
183    * contract, and not the address of the submitter - if the constructor of the
184    * deployed contract uses msg.sender to set up ownership or other variables,
185    * you must modify it to accept a constructor argument with the appropriate
186    * address, or alternately to hard-code the intended address. Also, if your
187    * contract DOES have constructor arguments, remember to include them as
188    * ABI-encoded arguments at the end of the initialization code, just as you
189    * would when performing a standard deploy. You may also want to provide the
190    * key to `setReverseLookup` in order to find it again using only the home
191    * address to prevent accidentally losing the key. The controller cannot be
192    * designated as the address of this contract, the null address, or the home
193    * address (the restriction on setting the home address as the controller is
194    * due to the fact that the home address will not be able to deploy to itself,
195    * as it needs to be empty before a contract can be deployed to it). Also,
196    * checks on the contract at the home address being empty or not having the
197    * correct controller are unnecessary, as they are performed when minting the
198    * token and cannot be altered until the token is redeemed.
199    */
200   function redeemAndDeploy(
201     uint256 tokenId,
202     address controller,
203     bytes calldata initializationCode
204   )
205     external
206     payable
207     returns (address homeAddress, bytes32 runtimeCodeHash);
208 
209   /**
210    * @notice Derive a new key by concatenating an arbitrary 32-byte salt value
211    * and the address of the caller and performing a keccak256 hash. This allows
212    * for the creation of keys with additional entropy where desired while also
213    * preventing collisions with standard keys. The caller will be set as the
214    * controller of the derived key.
215    * @param salt bytes32 The desired salt value to use (along with the address
216    * of the caller) when deriving the resultant key and corresponding home
217    * address.
218    * @return The derived key.
219    * @dev Home addresses from derived keys will take longer to "mine" or locate,
220    * as an additional hash must be performed when computing the corresponding
221    * home address for each given salt input. Each caller will derive a different
222    * key even if they are supplying the same salt value.
223    */
224   function deriveKey(bytes32 salt) external returns (bytes32 key);
225 
226   /**
227    * @notice Mint an ERC721 token to the supplied owner that can be redeemed in
228    * order to gain control of a home address corresponding to a given derived
229    * key. Two conditions must be met: the submitter must be designated as the
230    * current controller of the home address, and there must not be a contract
231    * currently deployed at the home address. These conditions can be checked by
232    * calling `getHomeAddressInformation` and `isDeployable` with the key
233    * determined by calling `getDerivedKey`.
234    * @param salt bytes32 The salt value that is used to derive the key.
235    * @param owner address The account that will be granted ownership of the
236    * ERC721 token.
237    * @return The derived key.
238    * @dev In order to mint an ERC721 token, the assocated home address cannot be
239    * in use, or else the token will not be able to deploy to the home address.
240    * The controller is set to this contract until the token is redeemed, at
241    * which point the redeemer designates a new controller for the home address.
242    * The key of the home address and the tokenID of the ERC721 token are the
243    * same value, but different types (bytes32 vs. uint256).
244    */
245   function deriveKeyAndLock(bytes32 salt, address owner)
246     external
247     returns (bytes32 key);
248 
249   /**
250    * @notice Transfer control over deployment to the home address corresponding
251    * to a given derived key. The caller must be designated as the current
252    * controller of the home address - This condition can be checked by calling
253    * `getHomeAddressInformation` with the key obtained via `getDerivedKey`.
254    * @param salt bytes32 The salt value that is used to derive the key.
255    * @param controller address The account that will be granted control of the
256    * home address corresponding to the given derived key.
257    * @return The derived key.
258    * @dev The controller cannot be designated as the address of this contract,
259    * the null address, or the home address (the restriction on setting the home
260    * address as the controller is due to the fact that the home address will not
261    * be able to deploy to itself, as it needs to be empty before a contract can
262    * be deployed to it).
263    */
264   function deriveKeyAndAssignController(bytes32 salt, address controller)
265     external
266     returns (bytes32 key);
267 
268   /**
269    * @notice Transfer control over deployment to the home address corresponding
270    * to a given derived key to the null address, which will prevent it from
271    * being deployed to again in the future. The caller must be designated as the
272    * current controller of the home address - This condition can be checked by
273    * calling `getHomeAddressInformation` with the key determined by calling
274    * `getDerivedKey`.
275    * @param salt bytes32 The salt value that is used to derive the key.
276    * @return The derived key.
277    */
278   function deriveKeyAndRelinquishControl(bytes32 salt)
279     external
280     returns (bytes32 key);
281 
282   /**
283    * @notice Record a key that corresponds to a given home address by supplying
284    * said key and using it to derive the address. This enables reverse lookup
285    * of a key using only the home address in question. This method may be called
286    * by anyone - control of the key is not required.
287    * @param key bytes32 The unique value used to derive the home address.
288    * @dev This does not set the salt or submitter fields, as those apply only to
289    * derived keys (although a derived key may also be set with this method, just
290    * without the derived fields).
291    */
292   function setReverseLookup(bytes32 key) external;
293 
294   /**
295    * @notice Record the derived key that corresponds to a given home address by
296    * supplying the salt and submitter that were used to derive the key. This
297    * facititates reverse lookup of the derivation method of a key using only the
298    * home address in question. This method may be called by anyone - control of
299    * the derived key is not required.
300    * @param salt bytes32 The salt value that is used to derive the key.
301    * @param submitter address The account that submits the salt that is used to
302    * derive the key.
303    */
304   function setDerivedReverseLookup(bytes32 salt, address submitter) external;
305 
306   /**
307    * @notice Deploy a new storage contract with the supplied code as runtime
308    * code without deploying a contract to a home address. This can be used to
309    * store the contract creation code for use in future deployments of contracts
310    * to home addresses.
311    * @param codePayload bytes The code to set as the runtime code of the
312    * deployed contract.
313    * @return The address of the deployed storage contract.
314    * @dev Consider placing adequate protections on the storage contract to
315    * prevent unwanted callers from modifying or destroying it. Also, if you are
316    * placing contract contract creation code into the runtime storage contract,
317    * remember to include any constructor parameters as ABI-encoded arguments at
318    * the end of the contract creation code, similar to how you would perform a
319    * standard deployment.
320    */
321   function deployRuntimeStorageContract(bytes calldata codePayload)
322     external
323     returns (address runtimeStorageContract);
324 
325   /**
326    * @notice Deploy a new contract with the initialization code stored in the
327    * runtime code at the specified initialization runtime storage contract to
328    * the home address corresponding to a given key. Two conditions must be met:
329    * the submitter must be designated as the controller of the home address
330    * (with the initial controller set to the address corresponding to the first
331    * 20 bytes of the key), and there must not be a contract currently deployed
332    * at the home address. These conditions can be checked by calling
333    * `getHomeAddressInformation` and `isDeployable` with the same key.
334    * @param key bytes32 The unique value used to derive the home address.
335    * @param initializationRuntimeStorageContract address The storage contract
336    * with runtime code equal to the contract creation code that will be used to
337    * deploy the contract to the home address.
338    * @return The home address and runtime code hash of the deployed contract.
339    * @dev When deploying a contract to a home address via this method, the
340    * metamorphic initialization code will retrieve whatever initialization code
341    * currently resides at the specified address and use it to set up and deploy
342    * the desired contract to the home address. Bear in mind that the deployed
343    * contract will interpret msg.sender as the address of THIS contract, and not
344    * the address of the submitter - if the constructor of the deployed contract
345    * uses msg.sender to set up ownership or other variables, you must modify it
346    * to accept a constructor argument with the appropriate address, or
347    * alternately to hard-code the intended address. Also, if your contract DOES
348    * have constructor arguments, remember to include them as ABI-encoded
349    * arguments at the end of the initialization code, just as you would when
350    * performing a standard deploy. You may also want to provide the key to
351    * `setReverseLookup` in order to find it again using only the home address to
352    * prevent accidentally losing the key.
353    */
354   function deployViaExistingRuntimeStorageContract(
355     bytes32 key,
356     address initializationRuntimeStorageContract
357   )
358     external
359     payable
360     returns (address homeAddress, bytes32 runtimeCodeHash);
361 
362   /**
363    * @notice Burn an ERC721 token, set a supplied controller, and deploy a new
364    * contract with the initialization code stored in the runtime code at the
365    * specified initialization runtime storage contract to the home address
366    * corresponding to a given key. The submitter must be designated as either
367    * the owner of the token or as an approved spender.
368    * @param tokenId uint256 The ID of the ERC721 token to redeem.
369    * @param controller address The account that will be granted control of the
370    * home address corresponding to the given token.
371    * @param initializationRuntimeStorageContract address The storage contract
372    * with runtime code equal to the contract creation code that will be used to
373    * deploy the contract to the home address.
374    * @return The home address and runtime code hash of the deployed contract.
375    * @dev When deploying a contract to a home address via this method, the
376    * metamorphic initialization code will retrieve whatever initialization code
377    * currently resides at the specified address and use it to set up and deploy
378    * the desired contract to the home address. Bear in mind that the deployed
379    * contract will interpret msg.sender as the address of THIS contract, and not
380    * the address of the submitter - if the constructor of the deployed contract
381    * uses msg.sender to set up ownership or other variables, you must modify it
382    * to accept a constructor argument with the appropriate address, or
383    * alternately to hard-code the intended address. Also, if your contract DOES
384    * have constructor arguments, remember to include them as ABI-encoded
385    * arguments at the end of the initialization code, just as you would when
386    * performing a standard deploy. You may also want to provide the key to
387    * `setReverseLookup` in order to find it again using only the home address to
388    * prevent accidentally losing the key. The controller cannot be designated as
389    * the address of this contract, the null address, or the home address (the
390    * restriction on setting the home address as the controller is due to the
391    * fact that the home address will not be able to deploy to itself, as it
392    * needs to be empty before a contract can be deployed to it). Also, checks on
393    * the contract at the home address being empty or not having the correct
394    * controller are unnecessary, as they are performed when minting the token
395    * and cannot be altered until the token is redeemed.
396    */
397   function redeemAndDeployViaExistingRuntimeStorageContract(
398     uint256 tokenId,
399     address controller,
400     address initializationRuntimeStorageContract
401   )
402     external
403     payable
404     returns (address homeAddress, bytes32 runtimeCodeHash);
405 
406   /**
407    * @notice Deploy a new contract with the desired initialization code to the
408    * home address corresponding to a given derived key. Two conditions must be
409    * met: the submitter must be designated as the controller of the home
410    * address, and there must not be a contract currently deployed at the home
411    * address. These conditions can be checked by calling
412    * `getHomeAddressInformation` and `isDeployable` with the key obtained by
413    * calling `getDerivedKey`.
414    * @param salt bytes32 The salt value that is used to derive the key.
415    * @param initializationCode bytes The contract creation code that will be
416    * used to deploy the contract to the home address.
417    * @return The home address, derived key, and runtime code hash of the
418    * deployed contract.
419    * @dev In order to deploy the contract to the home address, a new contract
420    * will be deployed with runtime code set to the initialization code of the
421    * contract that will be deployed to the home address. Then, metamorphic
422    * initialization code will retrieve that initialization code and use it to
423    * set up and deploy the desired contract to the home address. Bear in mind
424    * that the deployed contract will interpret msg.sender as the address of THIS
425    * contract, and not the address of the submitter - if the constructor of the
426    * deployed contract uses msg.sender to set up ownership or other variables,
427    * you must modify it to accept a constructor argument with the appropriate
428    * address, or alternately to hard-code the intended address. Also, if your
429    * contract DOES have constructor arguments, remember to include them as
430    * ABI-encoded arguments at the end of the initialization code, just as you
431    * would when performing a standard deploy. You may want to provide the salt
432    * and submitter to `setDerivedReverseLookup` in order to find the salt,
433    * submitter, and derived key using only the home address to prevent
434    * accidentally losing them.
435    */
436   function deriveKeyAndDeploy(bytes32 salt, bytes calldata initializationCode)
437     external
438     payable
439     returns (address homeAddress, bytes32 key, bytes32 runtimeCodeHash);
440 
441   /**
442    * @notice Deploy a new contract with the initialization code stored in the
443    * runtime code at the specified initialization runtime storage contract to
444    * the home address corresponding to a given derived key. Two conditions must
445    * be met: the submitter must be designated as the controller of the home
446    * address, and there must not be a contract currently deployed at the home
447    * address. These conditions can be checked by calling
448    * `getHomeAddressInformation` and `isDeployable` with the key obtained by
449    * calling `getDerivedKey`.
450    * @param salt bytes32 The salt value that is used to derive the key.
451    * @param initializationRuntimeStorageContract address The storage contract
452    * with runtime code equal to the contract creation code that will be used to
453    * deploy the contract to the home address.
454    * @return The home address, derived key, and runtime code hash of the
455    * deployed contract.
456    * @dev When deploying a contract to a home address via this method, the
457    * metamorphic initialization code will retrieve whatever initialization code
458    * currently resides at the specified address and use it to set up and deploy
459    * the desired contract to the home address. Bear in mind that the deployed
460    * contract will interpret msg.sender as the address of THIS contract, and not
461    * the address of the submitter - if the constructor of the deployed contract
462    * uses msg.sender to set up ownership or other variables, you must modify it
463    * to accept a constructor argument with the appropriate address, or
464    * alternately to hard-code the intended address. Also, if your contract DOES
465    * have constructor arguments, remember to include them as ABI-encoded
466    * arguments at the end of the initialization code, just as you would when
467    * performing a standard deploy. You may want to provide the salt and
468    * submitter to `setDerivedReverseLookup` in order to find the salt,
469    * submitter, and derived key using only the home address to prevent
470    * accidentally losing them.
471    */
472   function deriveKeyAndDeployViaExistingRuntimeStorageContract(
473     bytes32 salt,
474     address initializationRuntimeStorageContract
475   )
476     external
477     payable
478     returns (address homeAddress, bytes32 key, bytes32 runtimeCodeHash);
479 
480   /**
481    * @notice Mint multiple ERC721 tokens, designated by their keys, to the
482    * specified owner. Keys that aren't controlled, or that point to home
483    * addresses that are currently deployed, will be skipped.
484    * @param owner address The account that will be granted ownership of the
485    * ERC721 tokens.
486    * @param keys bytes32[] An array of values used to derive each home address.
487    * @dev If you plan to use this method regularly or want to keep gas costs to
488    * an absolute minimum, and are willing to go without standard ABI encoding,
489    * see `batchLock_63efZf` for a more efficient (and unforgiving)
490    * implementation. For batch token minting with *derived* keys, see
491    * `deriveKeysAndBatchLock`.
492    */
493   function batchLock(address owner, bytes32[] calldata keys) external;
494 
495   /**
496    * @notice Mint multiple ERC721 tokens, designated by salts that are hashed
497    * with the caller's address to derive each key, to the specified owner.
498    * Derived keys that aren't controlled, or that point to home addresses that
499    * are currently deployed, will be skipped.
500    * @param owner address The account that will be granted ownership of the
501    * ERC721 tokens.
502    * @param salts bytes32[] An array of values used to derive each key and
503    * corresponding home address.
504    * @dev See `batchLock` for batch token minting with standard, non-derived
505    * keys.
506    */
507   function deriveKeysAndBatchLock(address owner, bytes32[] calldata salts)
508     external;
509 
510   /**
511    * @notice Efficient version of `batchLock` that uses less gas. The first 20
512    * bytes of each key are automatically populated using msg.sender, and the
513    * remaining key segments are passed in as a packed byte array, using twelve
514    * bytes per segment, with a function selector of 0x00000000 followed by a
515    * twenty-byte segment for the desired owner of the minted ERC721 tokens. Note
516    * that an attempt to lock a key that is not controlled or with its contract
517    * already deployed will cause the entire batch to revert. Checks on whether
518    * the owner is a valid ERC721 receiver are also skipped, similar to using
519    * `transferFrom` instead of `safeTransferFrom`.
520    */
521   function batchLock_63efZf(/* packed owner and key segments */) external;
522 
523   /**
524    * @notice Submit a key to claim the "high score" - the lower the uint160
525    * value of the key's home address, the higher the score. The high score
526    * holder has the exclusive right to recover lost ether and tokens on this
527    * contract.
528    * @param key bytes32 The unique value used to derive the home address that
529    * will determine the resultant score.
530    * @dev The high score must be claimed by a direct key (one that is submitted
531    * by setting the first 20 bytes of the key to the address of the submitter)
532    * and not by a derived key, and is non-transferrable. If you want to help
533    * people recover their lost tokens, you might consider deploying a contract
534    * to the high score address (probably a metamorphic one so that you can use
535    * the home address later) with your contact information.
536    */
537   function claimHighScore(bytes32 key) external;
538 
539   /**
540    * @notice Transfer any ether or ERC20 tokens that have somehow ended up at
541    * this contract by specifying a token address (set to the null address for
542    * ether) as well as a recipient address. Only the high score holder can
543    * recover lost ether and tokens on this contract.
544    * @param token address The contract address of the ERC20 token to recover, or
545    * the null address for recovering Ether.
546    * @param recipient address payable The account where recovered funds should
547    * be transferred.
548    * @dev If you are trying to recover funds that were accidentally sent into
549    * this contract, see if you can contact the holder of the current high score,
550    * found by calling `getHighScore`. Better yet, try to find a new high score
551    * yourself!
552    */
553   function recover(IERC20 token, address payable recipient) external;
554 
555   /**
556    * @notice "View" function to determine if a contract can currently be
557    * deployed to a home address given the corresponding key. A contract is only
558    * deployable if no account currently exists at the address - any existing
559    * contract must be destroyed via `SELFDESTRUCT` before a new contract can be
560    * deployed to a home address. This method does not modify state but is
561    * inaccessible via staticcall.
562    * @param key bytes32 The unique value used to derive the home address.
563    * @return A boolean signifying if a contract can be deployed to the home
564    * address that corresponds to the provided key.
565    * @dev This will not detect if a contract is not deployable due control
566    * having been relinquished on the key.
567    */
568   function isDeployable(bytes32 key)
569     external
570     /* view */
571     returns (bool deployable);
572 
573   /**
574    * @notice View function to get the current "high score", or the lowest
575    * uint160 value of a home address of all keys submitted. The high score
576    * holder has the exclusive right to recover lost ether and tokens on this
577    * contract.
578    * @return The current high score holder, their score, and the submitted key.
579    */
580   function getHighScore()
581     external
582     view
583     returns (address holder, uint256 score, bytes32 key);
584 
585   /**
586    * @notice View function to get information on a home address given the
587    * corresponding key.
588    * @param key bytes32 The unique value used to derive the home address.
589    * @return The home address, the current controller of the address, the number
590    * of times the home address has been deployed to, and the code hash of the
591    * runtime currently found at the home address, if any.
592    * @dev There is also an `isDeployable` method for determining if a contract
593    * can be deployed to the address, but in extreme cases it must actually
594    * perform a dry-run to determine if the contract is deployable, which means
595    * that it does not support staticcalls. There is also a convenience method,
596    * `hasNeverBeenDeployed`, but the information it conveys can be determined
597    * from this method alone as well.
598    */
599   function getHomeAddressInformation(bytes32 key)
600     external
601     view
602     returns (
603       address homeAddress,
604       address controller,
605       uint256 deploys,
606       bytes32 currentRuntimeCodeHash
607     );
608 
609   /**
610    * @notice View function to determine if no contract has ever been deployed to
611    * a home address given the corresponding key. This can be used to ensure that
612    * a given key or corresponding token is "new" or not.
613    * @param key bytes32 The unique value used to derive the home address.
614    * @return A boolean signifying if a contract has never been deployed using
615    * the supplied key before.
616    */
617   function hasNeverBeenDeployed(bytes32 key)
618     external
619     view
620     returns (bool neverBeenDeployed);
621 
622   /**
623    * @notice View function to search for a known key, salt, and/or submitter
624    * given a supplied home address. Keys can be controlled directly by an
625    * address that matches the first 20 bytes of the key, or they can be derived
626    * from a salt and a submitter - if the key is not a derived key, the salt and
627    * submitter fields will both have a value of zero.
628    * @param homeAddress address The home address to check for key information.
629    * @return The key, salt, and/or submitter used to deploy to the home address,
630    * assuming they have been submitted to the reverse lookup.
631    * @dev To populate these values, call `setReverseLookup` for cases where keys
632    * are used directly or are the only value known, or `setDerivedReverseLookup`
633    * for cases where keys are derived from a known salt and submitter.
634    */
635   function reverseLookup(address homeAddress)
636     external
637     view
638     returns (bytes32 key, bytes32 salt, address submitter);
639 
640   /**
641    * @notice Pure function to determine the key that is derived from a given
642    * salt and submitting address.
643    * @param salt bytes32 The salt value that is used to derive the key.
644    * @param submitter address The submitter of the salt value used to derive the
645    * key.
646    * @return The derived key.
647    */
648   function getDerivedKey(bytes32 salt, address submitter)
649     external
650     pure
651     returns (bytes32 key);
652 
653   /**
654    * @notice Pure function to determine the home address that corresponds to
655    * a given key.
656    * @param key bytes32 The unique value used to derive the home address.
657    * @return The home address.
658    */
659   function getHomeAddress(bytes32 key)
660     external
661     pure
662     returns (address homeAddress);
663 
664   /**
665    * @notice Pure function for retrieving the metamorphic initialization code
666    * used to deploy arbitrary contracts to home addresses. Provided for easy
667    * verification and for use in other applications.
668    * @return The 32-byte metamorphic initialization code.
669    * @dev This metamorphic init code works via the "metamorphic delegator"
670    * mechanism, which is explained in greater detail at `_deployToHomeAddress`.
671    */
672   function getMetamorphicDelegatorInitializationCode()
673     external
674     pure
675     returns (bytes32 metamorphicDelegatorInitializationCode);
676 
677   /**
678    * @notice Pure function for retrieving the keccak256 of the metamorphic
679    * initialization code used to deploy arbitrary contracts to home addresses.
680    * This is the value that you should use, along with this contract's address
681    * and a caller address that you control, to mine for an partucular type of
682    * home address (such as one at a compact or gas-efficient address).
683    * @return The keccak256 hash of the metamorphic initialization code.
684    */
685   function getMetamorphicDelegatorInitializationCodeHash()
686     external
687     pure
688     returns (bytes32 metamorphicDelegatorInitializationCodeHash);
689 
690   /**
691    * @notice Pure function for retrieving the prelude that will be inserted
692    * ahead of the code payload in order to deploy a runtime storage contract.
693    * @return The 11-byte "arbitrary runtime" prelude.
694    */
695   function getArbitraryRuntimeCodePrelude()
696     external
697     pure
698     returns (bytes11 prelude);
699 }
700 
701 
702 /**
703  * @title ERC721 Non-Fungible Token Standard basic interface
704  * @dev see https://eips.ethereum.org/EIPS/eip-721
705  */
706 interface IERC721 {
707     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
708     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
709     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
710 
711     function balanceOf(address owner) external view returns (uint256 balance);
712     function ownerOf(uint256 tokenId) external view returns (address owner);
713 
714     function approve(address to, uint256 tokenId) external;
715     function getApproved(uint256 tokenId) external view returns (address operator);
716 
717     function setApprovalForAll(address operator, bool _approved) external;
718     function isApprovedForAll(address owner, address operator) external view returns (bool);
719 
720     function transferFrom(address from, address to, uint256 tokenId) external;
721     function safeTransferFrom(address from, address to, uint256 tokenId) external;
722 
723     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
724 }
725 
726 
727 /**
728  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
729  * @dev See https://eips.ethereum.org/EIPS/eip-721
730  */
731 interface IERC721Enumerable {
732     function totalSupply() external view returns (uint256);
733     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
734     function tokenByIndex(uint256 index) external view returns (uint256);
735 }
736 
737 
738 /**
739  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
740  * @dev See https://eips.ethereum.org/EIPS/eip-721
741  */
742 interface IERC721Metadata {
743     function name() external pure returns (string memory);
744     function symbol() external pure returns (string memory);
745     function tokenURI(uint256 tokenId) external view returns (string memory);
746 }
747 
748 
749 /**
750  * @title ERC721 token receiver interface
751  * @dev Interface for any contract that wants to support safeTransfers
752  * from ERC721 asset contracts.
753  */
754 interface IERC721Receiver {
755     /**
756      * @notice Handle the receipt of an NFT
757      * @dev The ERC721 smart contract calls this function on the recipient
758      * after a `safeTransfer`. This function MUST return the function selector,
759      * otherwise the caller will revert the transaction. The selector to be
760      * returned can be obtained as `this.onERC721Received.selector`. This
761      * function MAY throw to revert and reject the transfer.
762      * Note: the ERC721 contract address is always the message sender.
763      * @param operator The address which called `safeTransferFrom` function
764      * @param from The address which previously owned the token
765      * @param tokenId The NFT identifier which is being transferred
766      * @param data Additional data with no specified format
767      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
768      */
769     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data)
770       external
771       returns (bytes4);
772 }
773 
774 
775 /**
776  * @title ERC1412 Batch Transfers For Non-Fungible Tokens
777  * @dev the ERC-165 identifier for this interface is 0x2b89bcaa
778  */
779 interface IERC1412 {
780   /// @notice Transfers the ownership of multiple NFTs from one address to another address
781   /// @param _from The current owner of the NFT
782   /// @param _to The new owner
783   /// @param _tokenIds The NFTs to transfer
784   /// @param _data Additional data with no specified format, sent in call to `_to`  
785   function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _tokenIds, bytes calldata _data) external;
786   
787   /// @notice Transfers the ownership of multiple NFTs from one address to another address
788   /// @param _from The current owner of the NFT
789   /// @param _to The new owner
790   /// @param _tokenIds The NFTs to transfer  
791   function safeBatchTransferFrom(address _from, address _to, uint256[] calldata _tokenIds) external; 
792 }
793 
794 
795 /**
796  * @title IERC165
797  * @dev https://eips.ethereum.org/EIPS/eip-165
798  */
799 interface IERC165 {
800     /**
801      * @notice Query if a contract implements an interface
802      * @param interfaceId The interface identifier, as specified in ERC-165
803      * @dev Interface identification is specified in ERC-165. This function
804      * uses less than 30,000 gas.
805      */
806     function supportsInterface(bytes4 interfaceId) external view returns (bool);
807 }
808 
809 
810 /**
811  * @title ERC20 interface
812  * @dev see https://eips.ethereum.org/EIPS/eip-20
813  */
814 interface IERC20 {
815     function transfer(address to, uint256 value) external returns (bool);
816 
817     function approve(address spender, uint256 value) external returns (bool);
818 
819     function transferFrom(address from, address to, uint256 value) external returns (bool);
820 
821     function totalSupply() external view returns (uint256);
822 
823     function balanceOf(address who) external view returns (uint256);
824 
825     function allowance(address owner, address spender) external view returns (uint256);
826 
827     event Transfer(address indexed from, address indexed to, uint256 value);
828 
829     event Approval(address indexed owner, address indexed spender, uint256 value);
830 }
831 
832 
833 /**
834  * @dev Wrappers over Solidity's arithmetic operations with added overflow
835  * checks.
836  *
837  * Arithmetic operations in Solidity wrap on overflow. This can easily result
838  * in bugs, because programmers usually assume that an overflow raises an
839  * error, which is the standard behavior in high level programming languages.
840  * `SafeMath` restores this intuition by reverting the transaction when an
841  * operation overflows.
842  *
843  * Using this library instead of the unchecked operations eliminates an entire
844  * class of bugs, so it's recommended to use it always.
845  */
846 library SafeMath {
847     /**
848      * @dev Returns the addition of two unsigned integers, reverting on
849      * overflow.
850      *
851      * Counterpart to Solidity's `+` operator.
852      *
853      * Requirements:
854      * - Addition cannot overflow.
855      */
856     function add(uint256 a, uint256 b) internal pure returns (uint256) {
857         uint256 c = a + b;
858         require(c >= a, "SafeMath: addition overflow");
859 
860         return c;
861     }
862 
863     /**
864      * @dev Returns the subtraction of two unsigned integers, reverting on
865      * overflow (when the result is negative).
866      *
867      * Counterpart to Solidity's `-` operator.
868      *
869      * Requirements:
870      * - Subtraction cannot overflow.
871      */
872     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
873         require(b <= a, "SafeMath: subtraction overflow");
874         uint256 c = a - b;
875 
876         return c;
877     }
878 
879     /**
880      * @dev Returns the multiplication of two unsigned integers, reverting on
881      * overflow.
882      *
883      * Counterpart to Solidity's `*` operator.
884      *
885      * Requirements:
886      * - Multiplication cannot overflow.
887      */
888     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
889         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
890         // benefit is lost if 'b' is also tested.
891         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
892         if (a == 0) {
893             return 0;
894         }
895 
896         uint256 c = a * b;
897         require(c / a == b, "SafeMath: multiplication overflow");
898 
899         return c;
900     }
901 
902     /**
903      * @dev Returns the integer division of two unsigned integers. Reverts on
904      * division by zero. The result is rounded towards zero.
905      *
906      * Counterpart to Solidity's `/` operator. Note: this function uses a
907      * `revert` opcode (which leaves remaining gas untouched) while Solidity
908      * uses an invalid opcode to revert (consuming all remaining gas).
909      *
910      * Requirements:
911      * - The divisor cannot be zero.
912      */
913     function div(uint256 a, uint256 b) internal pure returns (uint256) {
914         // Solidity only automatically asserts when dividing by 0
915         require(b > 0, "SafeMath: division by zero");
916         uint256 c = a / b;
917         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
918 
919         return c;
920     }
921 
922     /**
923      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
924      * Reverts when dividing by zero.
925      *
926      * Counterpart to Solidity's `%` operator. This function uses a `revert`
927      * opcode (which leaves remaining gas untouched) while Solidity uses an
928      * invalid opcode to revert (consuming all remaining gas).
929      *
930      * Requirements:
931      * - The divisor cannot be zero.
932      */
933     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
934         require(b != 0, "SafeMath: modulo by zero");
935         return a % b;
936     }
937 }
938 
939 
940 /**
941  * Utility library of inline functions on addresses
942  */
943 library Address {
944     /**
945      * Returns whether the target address is a contract
946      * @dev This function will return false if invoked during the constructor of a contract,
947      * as the code is not actually created until after the constructor finishes.
948      * @param account address of the account to check
949      * @return whether the target address is a contract
950      */
951     function isContract(address account) internal view returns (bool) {
952         uint256 size;
953         // XXX Currently there is no better way to check if there is a contract in an address
954         // than to check the size of the code at that address.
955         // See https://ethereum.stackexchange.com/a/14016/36603
956         // for more details about how this works.
957         // TODO Check this again before the Serenity release, because all addresses will be
958         // contracts then.
959         // solhint-disable-next-line no-inline-assembly
960         assembly { size := extcodesize(account) }
961         return size > 0;
962     }
963 }
964 
965 
966 /**
967  * @title Counters
968  * @author Matt Condon (@shrugs)
969  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
970  * of elements in a mapping, issuing ERC721 ids, or counting request ids
971  *
972  * Include with `using Counters for Counters.Counter;`
973  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
974  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
975  * directly accessed.
976  */
977 library Counters {
978     using SafeMath for uint256;
979 
980     struct Counter {
981         // This variable should never be directly accessed by users of the library: interactions must be restricted to
982         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
983         // this feature: see https://github.com/ethereum/solidity/issues/4637
984         uint256 _value; // default: 0
985     }
986 
987     function current(Counter storage counter) internal view returns (uint256) {
988         return counter._value;
989     }
990 
991     function increment(Counter storage counter) internal {
992         counter._value += 1;
993     }
994 
995     function decrement(Counter storage counter) internal {
996         counter._value = counter._value.sub(1);
997     }
998 }
999 
1000 
1001 /**
1002  * @dev Implementation of the `IERC165` interface.
1003  *
1004  * Contracts may inherit from this and call `_registerInterface` to declare
1005  * their support of an interface.
1006  */
1007 contract ERC165 is IERC165 {
1008     /*
1009      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
1010      */
1011     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
1012 
1013     /**
1014      * @dev Mapping of interface ids to whether or not it's supported.
1015      */
1016     mapping(bytes4 => bool) private _supportedInterfaces;
1017 
1018     constructor () internal {
1019         // Derived contracts need only register support for their own interfaces,
1020         // we register support for ERC165 itself here
1021         _registerInterface(_INTERFACE_ID_ERC165);
1022     }
1023 
1024     /**
1025      * @dev See `IERC165.supportsInterface`.
1026      *
1027      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
1028      */
1029     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
1030         return _supportedInterfaces[interfaceId];
1031     }
1032 
1033     /**
1034      * @dev Registers the contract as an implementer of the interface defined by
1035      * `interfaceId`. Support of the actual ERC165 interface is automatic and
1036      * registering its interface id is not required.
1037      *
1038      * See `IERC165.supportsInterface`.
1039      *
1040      * Requirements:
1041      *
1042      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
1043      */
1044     function _registerInterface(bytes4 interfaceId) internal {
1045         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
1046         _supportedInterfaces[interfaceId] = true;
1047     }
1048 }
1049 
1050 
1051 /**
1052  * @title ERC721 Non-Fungible Token Standard basic implementation
1053  * @dev see https://eips.ethereum.org/EIPS/eip-721
1054  */
1055 contract ERC721 is ERC165, IERC721 {
1056     using SafeMath for uint256;
1057     using Address for address;
1058     using Counters for Counters.Counter;
1059 
1060     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1061     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1062     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1063 
1064     // Mapping from token ID to owner
1065     mapping (uint256 => address) private _tokenOwner;
1066 
1067     // Mapping from token ID to approved address
1068     mapping (uint256 => address) private _tokenApprovals;
1069 
1070     // Mapping from owner to number of owned token
1071     mapping (address => Counters.Counter) private _ownedTokensCount;
1072 
1073     // Mapping from owner to operator approvals
1074     mapping (address => mapping (address => bool)) private _operatorApprovals;
1075 
1076     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1077     /*
1078      * 0x80ac58cd ===
1079      *     bytes4(keccak256('balanceOf(address)')) ^
1080      *     bytes4(keccak256('ownerOf(uint256)')) ^
1081      *     bytes4(keccak256('approve(address,uint256)')) ^
1082      *     bytes4(keccak256('getApproved(uint256)')) ^
1083      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
1084      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
1085      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
1086      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
1087      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
1088      */
1089 
1090     constructor () public {
1091         // register the supported interfaces to conform to ERC721 via ERC165
1092         _registerInterface(_INTERFACE_ID_ERC721);
1093     }
1094 
1095     /**
1096      * @dev Gets the balance of the specified address
1097      * @param owner address to query the balance of
1098      * @return uint256 representing the amount owned by the passed address
1099      */
1100     function balanceOf(address owner) public view returns (uint256) {
1101         require(owner != address(0));
1102         return _ownedTokensCount[owner].current();
1103     }
1104 
1105     /**
1106      * @dev Gets the owner of the specified token ID
1107      * @param tokenId uint256 ID of the token to query the owner of
1108      * @return address currently marked as the owner of the given token ID
1109      */
1110     function ownerOf(uint256 tokenId) public view returns (address) {
1111         address owner = _tokenOwner[tokenId];
1112         require(owner != address(0));
1113         return owner;
1114     }
1115 
1116     /**
1117      * @dev Approves another address to transfer the given token ID
1118      * The zero address indicates there is no approved address.
1119      * There can only be one approved address per token at a given time.
1120      * Can only be called by the token owner or an approved operator.
1121      * @param to address to be approved for the given token ID
1122      * @param tokenId uint256 ID of the token to be approved
1123      */
1124     function approve(address to, uint256 tokenId) public {
1125         address owner = ownerOf(tokenId);
1126         require(to != owner);
1127         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
1128 
1129         _tokenApprovals[tokenId] = to;
1130         emit Approval(owner, to, tokenId);
1131     }
1132 
1133     /**
1134      * @dev Gets the approved address for a token ID, or zero if no address set
1135      * Reverts if the token ID does not exist.
1136      * @param tokenId uint256 ID of the token to query the approval of
1137      * @return address currently approved for the given token ID
1138      */
1139     function getApproved(uint256 tokenId) public view returns (address) {
1140         require(_exists(tokenId));
1141         return _tokenApprovals[tokenId];
1142     }
1143 
1144     /**
1145      * @dev Sets or unsets the approval of a given operator
1146      * An operator is allowed to transfer all tokens of the sender on their behalf
1147      * @param to operator address to set the approval
1148      * @param approved representing the status of the approval to be set
1149      */
1150     function setApprovalForAll(address to, bool approved) public {
1151         require(to != msg.sender);
1152         _operatorApprovals[msg.sender][to] = approved;
1153         emit ApprovalForAll(msg.sender, to, approved);
1154     }
1155 
1156     /**
1157      * @dev Tells whether an operator is approved by a given owner
1158      * @param owner owner address which you want to query the approval of
1159      * @param operator operator address which you want to query the approval of
1160      * @return bool whether the given operator is approved by the given owner
1161      */
1162     function isApprovedForAll(address owner, address operator) public view returns (bool) {
1163         return _operatorApprovals[owner][operator];
1164     }
1165 
1166     /**
1167      * @dev Transfers the ownership of a given token ID to another address
1168      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
1169      * Requires the msg.sender to be the owner, approved, or operator
1170      * @param from current owner of the token
1171      * @param to address to receive the ownership of the given token ID
1172      * @param tokenId uint256 ID of the token to be transferred
1173      */
1174     function transferFrom(address from, address to, uint256 tokenId) public {
1175         require(_isApprovedOrOwner(msg.sender, tokenId));
1176 
1177         _transferFrom(from, to, tokenId);
1178     }
1179 
1180     /**
1181      * @dev Safely transfers the ownership of a given token ID to another address
1182      * If the target address is a contract, it must implement `onERC721Received`,
1183      * which is called upon a safe transfer, and return the magic value
1184      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1185      * the transfer is reverted.
1186      * Requires the msg.sender to be the owner, approved, or operator
1187      * @param from current owner of the token
1188      * @param to address to receive the ownership of the given token ID
1189      * @param tokenId uint256 ID of the token to be transferred
1190      */
1191     function safeTransferFrom(address from, address to, uint256 tokenId) public {
1192         safeTransferFrom(from, to, tokenId, "");
1193     }
1194 
1195     /**
1196      * @dev Safely transfers the ownership of a given token ID to another address
1197      * If the target address is a contract, it must implement `onERC721Received`,
1198      * which is called upon a safe transfer, and return the magic value
1199      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
1200      * the transfer is reverted.
1201      * Requires the msg.sender to be the owner, approved, or operator
1202      * @param from current owner of the token
1203      * @param to address to receive the ownership of the given token ID
1204      * @param tokenId uint256 ID of the token to be transferred
1205      * @param _data bytes data to send along with a safe transfer check
1206      */
1207     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
1208         transferFrom(from, to, tokenId);
1209         require(_checkOnERC721Received(from, to, tokenId, _data));
1210     }
1211 
1212     /**
1213      * @dev Returns whether the specified token exists
1214      * @param tokenId uint256 ID of the token to query the existence of
1215      * @return bool whether the token exists
1216      */
1217     function _exists(uint256 tokenId) internal view returns (bool) {
1218         address owner = _tokenOwner[tokenId];
1219         return owner != address(0);
1220     }
1221 
1222     /**
1223      * @dev Returns whether the given spender can transfer a given token ID
1224      * @param spender address of the spender to query
1225      * @param tokenId uint256 ID of the token to be transferred
1226      * @return bool whether the msg.sender is approved for the given token ID,
1227      * is an operator of the owner, or is the owner of the token
1228      */
1229     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
1230         address owner = ownerOf(tokenId);
1231         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1232     }
1233 
1234     /**
1235      * @dev Internal function to mint a new token
1236      * Reverts if the given token ID already exists
1237      * @param to The address that will own the minted token
1238      * @param tokenId uint256 ID of the token to be minted
1239      */
1240     function _mint(address to, uint256 tokenId) internal {
1241         require(to != address(0));
1242         require(!_exists(tokenId));
1243 
1244         _tokenOwner[tokenId] = to;
1245         _ownedTokensCount[to].increment();
1246 
1247         emit Transfer(address(0), to, tokenId);
1248     }
1249 
1250     /**
1251      * @dev Internal function to burn a specific token
1252      * Reverts if the token does not exist
1253      * Deprecated, use _burn(uint256) instead.
1254      * @param owner owner of the token to burn
1255      * @param tokenId uint256 ID of the token being burned
1256      */
1257     function _burn(address owner, uint256 tokenId) internal {
1258         require(ownerOf(tokenId) == owner);
1259 
1260         _clearApproval(tokenId);
1261 
1262         _ownedTokensCount[owner].decrement();
1263         _tokenOwner[tokenId] = address(0);
1264 
1265         emit Transfer(owner, address(0), tokenId);
1266     }
1267 
1268     /**
1269      * @dev Internal function to burn a specific token
1270      * Reverts if the token does not exist
1271      * @param tokenId uint256 ID of the token being burned
1272      */
1273     function _burn(uint256 tokenId) internal {
1274         _burn(ownerOf(tokenId), tokenId);
1275     }
1276 
1277     /**
1278      * @dev Internal function to transfer ownership of a given token ID to another address.
1279      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1280      * @param from current owner of the token
1281      * @param to address to receive the ownership of the given token ID
1282      * @param tokenId uint256 ID of the token to be transferred
1283      */
1284     function _transferFrom(address from, address to, uint256 tokenId) internal {
1285         require(ownerOf(tokenId) == from);
1286         require(to != address(0));
1287 
1288         _clearApproval(tokenId);
1289 
1290         _ownedTokensCount[from].decrement();
1291         _ownedTokensCount[to].increment();
1292 
1293         _tokenOwner[tokenId] = to;
1294 
1295         emit Transfer(from, to, tokenId);
1296     }
1297 
1298     /**
1299      * @dev Internal function to invoke `onERC721Received` on a target address
1300      * The call is not executed if the target address is not a contract
1301      * @param from address representing the previous owner of the given token ID
1302      * @param to target address that will receive the tokens
1303      * @param tokenId uint256 ID of the token to be transferred
1304      * @param _data bytes optional data to send along with the call
1305      * @return bool whether the call correctly returned the expected magic value
1306      */
1307     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1308         internal returns (bool)
1309     {
1310         if (!to.isContract()) {
1311             return true;
1312         }
1313 
1314         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
1315         return (retval == _ERC721_RECEIVED);
1316     }
1317 
1318     /**
1319      * @dev Private function to clear current approval of a given token ID
1320      * @param tokenId uint256 ID of the token to be transferred
1321      */
1322     function _clearApproval(uint256 tokenId) private {
1323         if (_tokenApprovals[tokenId] != address(0)) {
1324             _tokenApprovals[tokenId] = address(0);
1325         }
1326     }
1327 }
1328 
1329 
1330 /**
1331  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
1332  * @dev See https://eips.ethereum.org/EIPS/eip-721
1333  */
1334 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
1335     // Mapping from owner to list of owned token IDs
1336     mapping(address => uint256[]) private _ownedTokens;
1337 
1338     // Mapping from token ID to index of the owner tokens list
1339     mapping(uint256 => uint256) private _ownedTokensIndex;
1340 
1341     // Array with all token ids, used for enumeration
1342     uint256[] private _allTokens;
1343 
1344     // Mapping from token id to position in the allTokens array
1345     mapping(uint256 => uint256) private _allTokensIndex;
1346 
1347     /*
1348      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1349      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1350      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1351      *
1352      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1353      */
1354     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1355 
1356     /**
1357      * @dev Constructor function.
1358      */
1359     constructor () public {
1360         // register the supported interface to conform to ERC721Enumerable via ERC165
1361         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1362     }
1363 
1364     /**
1365      * @dev Gets the token ID at a given index of the tokens list of the requested owner.
1366      * @param owner address owning the tokens list to be accessed
1367      * @param index uint256 representing the index to be accessed of the requested tokens list
1368      * @return uint256 token ID at the given index of the tokens list owned by the requested address
1369      */
1370     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
1371         require(index < balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1372         return _ownedTokens[owner][index];
1373     }
1374 
1375     /**
1376      * @dev Gets the total amount of tokens stored by the contract.
1377      * @return uint256 representing the total amount of tokens
1378      */
1379     function totalSupply() public view returns (uint256) {
1380         return _allTokens.length;
1381     }
1382 
1383     /**
1384      * @dev Gets the token ID at a given index of all the tokens in this contract
1385      * Reverts if the index is greater or equal to the total number of tokens.
1386      * @param index uint256 representing the index to be accessed of the tokens list
1387      * @return uint256 token ID at the given index of the tokens list
1388      */
1389     function tokenByIndex(uint256 index) public view returns (uint256) {
1390         require(index < totalSupply(), "ERC721Enumerable: global index out of bounds");
1391         return _allTokens[index];
1392     }
1393 
1394     /**
1395      * @dev Internal function to transfer ownership of a given token ID to another address.
1396      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
1397      * @param from current owner of the token
1398      * @param to address to receive the ownership of the given token ID
1399      * @param tokenId uint256 ID of the token to be transferred
1400      */
1401     function _transferFrom(address from, address to, uint256 tokenId) internal {
1402         super._transferFrom(from, to, tokenId);
1403 
1404         _removeTokenFromOwnerEnumeration(from, tokenId);
1405 
1406         _addTokenToOwnerEnumeration(to, tokenId);
1407     }
1408 
1409     /**
1410      * @dev Internal function to mint a new token.
1411      * Reverts if the given token ID already exists.
1412      * @param to address the beneficiary that will own the minted token
1413      * @param tokenId uint256 ID of the token to be minted
1414      */
1415     function _mint(address to, uint256 tokenId) internal {
1416         super._mint(to, tokenId);
1417 
1418         _addTokenToOwnerEnumeration(to, tokenId);
1419 
1420         _addTokenToAllTokensEnumeration(tokenId);
1421     }
1422 
1423     /**
1424      * @dev Internal function to burn a specific token.
1425      * Reverts if the token does not exist.
1426      * Deprecated, use _burn(uint256) instead.
1427      * @param owner owner of the token to burn
1428      * @param tokenId uint256 ID of the token being burned
1429      */
1430     function _burn(address owner, uint256 tokenId) internal {
1431         super._burn(owner, tokenId);
1432 
1433         _removeTokenFromOwnerEnumeration(owner, tokenId);
1434         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
1435         _ownedTokensIndex[tokenId] = 0;
1436 
1437         _removeTokenFromAllTokensEnumeration(tokenId);
1438     }
1439 
1440     /**
1441      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1442      * @param to address representing the new owner of the given token ID
1443      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1444      */
1445     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1446         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
1447         _ownedTokens[to].push(tokenId);
1448     }
1449 
1450     /**
1451      * @dev Private function to add a token to this extension's token tracking data structures.
1452      * @param tokenId uint256 ID of the token to be added to the tokens list
1453      */
1454     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1455         _allTokensIndex[tokenId] = _allTokens.length;
1456         _allTokens.push(tokenId);
1457     }
1458 
1459     /**
1460      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1461      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
1462      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1463      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1464      * @param from address representing the previous owner of the given token ID
1465      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1466      */
1467     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1468         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1469         // then delete the last slot (swap and pop).
1470 
1471         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
1472         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1473 
1474         // When the token to delete is the last token, the swap operation is unnecessary
1475         if (tokenIndex != lastTokenIndex) {
1476             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1477 
1478             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1479             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1480         }
1481 
1482         // This also deletes the contents at the last position of the array
1483         _ownedTokens[from].length--;
1484 
1485         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
1486         // lastTokenId, or just over the end of the array if the token was the last one).
1487     }
1488 
1489     /**
1490      * @dev Private function to remove a token from this extension's token tracking data structures.
1491      * This has O(1) time complexity, but alters the order of the _allTokens array.
1492      * @param tokenId uint256 ID of the token to be removed from the tokens list
1493      */
1494     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1495         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1496         // then delete the last slot (swap and pop).
1497 
1498         uint256 lastTokenIndex = _allTokens.length.sub(1);
1499         uint256 tokenIndex = _allTokensIndex[tokenId];
1500 
1501         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1502         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1503         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1504         uint256 lastTokenId = _allTokens[lastTokenIndex];
1505 
1506         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1507         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1508 
1509         // This also deletes the contents at the last position of the array
1510         _allTokens.length--;
1511         _allTokensIndex[tokenId] = 0;
1512     }
1513 }
1514 
1515 
1516 /**
1517  * @title HomeWork (version 1)
1518  * @author 0age
1519  * @notice Homework is a utility to find, share, and reuse "home" addresses for
1520  * contracts. Anyone can work to find a new home address by searching for keys,
1521  * a 32-byte value with the first 20 bytes equal to the finder's calling address
1522  * (or derived by hashing an arbitrary 32-byte salt and the caller's address),
1523  * and can then deploy any contract they like (even one with a constructor) to
1524  * the address, or mint an ERC721 token that the owner can redeem that will then
1525  * allow them to do the same. Also, if the contract is `SELFDESTRUCT`ed, a new
1526  * contract can be redeployed by the current controller to the same address!
1527  * @dev This contract allows contract addresses to be located ahead of time, and
1528  * for arbitrary bytecode to be deployed (and redeployed if so desired, i.e.
1529  * metamorphic contracts) to the located address by a designated controller. To
1530  * enable this, the contract first deploys an "initialization-code-in-runtime"
1531  * contract, with the creation code of the contract you want to deploy stored in
1532  * RUNTIME code. Then, to deploy the actual contract, it retrieves the address
1533  * of the storage contract and `DELEGATECALL`s into it to execute the init code
1534  * and, if successful, retrieves and returns the contract runtime code. Rather
1535  * than using a located address directly, you can also lock it in the contract
1536  * and mint and ERC721 token for it, which can then be redeemed in order to gain
1537  * control over deployment to the address (note that tokens may not be minted if
1538  * the contract they control currently has a deployed contract at that address).
1539  * Once a contract undergoes metamorphosis, all existing storage will be deleted
1540  * and any existing contract code will be replaced with the deployed contract
1541  * code of the new implementation contract. The mechanisms behind this contract 
1542  * are highly experimental - proceed with caution and please share any exploits
1543  * or optimizations you discover.
1544  */
1545 contract HomeWork is IHomeWork, ERC721Enumerable, IERC721Metadata, IERC1412 {
1546   // Allocate storage to track the current initialization-in-runtime contract.
1547   address private _initializationRuntimeStorageContract;
1548 
1549   // Finder of home address with lowest uint256 value can recover lost funds.
1550   bytes32 private _highScoreKey;
1551 
1552   // Track information on the Home address corresponding to each key.
1553   mapping (bytes32 => HomeAddress) private _home;
1554 
1555   // Provide optional reverse-lookup for key derivation of a given home address.
1556   mapping (address => KeyInformation) private _key;
1557 
1558   // Set 0xff + address(this) as a constant to use when deriving home addresses.
1559   bytes21 private constant _FF_AND_THIS_CONTRACT = bytes21(
1560     0xff0000000000001b84b1cb32787B0D64758d019317
1561   );
1562 
1563   // Set the address of the tokenURI runtime storage contract as a constant.
1564   address private constant _URI_END_SEGMENT_STORAGE = address(
1565     0x000000000071C1c84915c17BF21728BfE4Dac3f3
1566   );
1567 
1568   // Deploy arbitrary contracts to home addresses using metamorphic init code.
1569   bytes32 private constant _HOME_INIT_CODE = bytes32(
1570     0x5859385958601c335a585952fa1582838382515af43d3d93833e601e57fd5bf3
1571   );
1572 
1573   // Compute hash of above metamorphic init code in order to compute addresses.
1574   bytes32 private constant _HOME_INIT_CODE_HASH = bytes32(
1575     0x7816562e7f85866cae07183593075f3b5ec32aeff914a0693e20aaf39672babc
1576   );
1577 
1578   // Write arbitrary code to a contract's runtime using the following prelude.
1579   bytes11 private constant _ARBITRARY_RUNTIME_PRELUDE = bytes11(
1580     0x600b5981380380925939f3
1581   );
1582 
1583   // Set EIP165 interface IDs as constants (already set 165 and 721+enumerable).
1584   bytes4 private constant _INTERFACE_ID_HOMEWORK = 0xe5399799;
1585   /* this.deploy.selector ^ this.lock.selector ^ this.redeem.selector ^
1586      this.assignController.selector ^ this.relinquishControl.selector ^
1587      this.redeemAndDeploy.selector ^ this.deriveKey.selector ^
1588      this.deriveKeyAndLock.selector ^
1589      this.deriveKeyAndAssignController.selector ^
1590      this.deriveKeyAndRelinquishControl.selector ^
1591      this.setReverseLookup.selector ^ this.setDerivedReverseLookup.selector ^
1592      this.deployRuntimeStorageContract.selector ^
1593      this.deployViaExistingRuntimeStorageContract.selector ^
1594      this.redeemAndDeployViaExistingRuntimeStorageContract.selector ^
1595      this.deriveKeyAndDeploy.selector ^
1596      this.deriveKeyAndDeployViaExistingRuntimeStorageContract.selector ^
1597      this.batchLock.selector ^ this.deriveKeysAndBatchLock.selector ^
1598      this.batchLock_63efZf.selector ^ this.claimHighScore.selector ^
1599      this.recover.selector ^ this.isDeployable.selector ^
1600      this.getHighScore.selector ^ this.getHomeAddressInformation.selector ^
1601      this.hasNeverBeenDeployed.selector ^ this.reverseLookup.selector ^
1602      this.getDerivedKey.selector ^ this.getHomeAddress.selector ^
1603      this.getMetamorphicDelegatorInitializationCode.selector ^
1604      this.getMetamorphicDelegatorInitializationCodeHash.selector ^
1605      this.getArbitraryRuntimeCodePrelude.selector == 0xe5399799
1606   */
1607 
1608   bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1609 
1610   bytes4 private constant _INTERFACE_ID_ERC1412_BATCH_TRANSFERS = 0x2b89bcaa;
1611 
1612   // Set name of this contract as a constant (hex encoding is to support emoji).
1613   string private constant _NAME = (
1614     hex"486f6d65576f726b20f09f8fa0f09f9ba0efb88f"
1615   );
1616 
1617   // Set symbol of this contract as a constant.
1618   string private constant _SYMBOL = "HWK";
1619 
1620   // Set the start of each token URI for issued ERC721 tokens as a constant.
1621   bytes private constant _URI_START_SEGMENT = abi.encodePacked(
1622     hex"646174613a6170706c69636174696f6e2f6a736f6e2c7b226e616d65223a22486f6d65",
1623     hex"253230416464726573732532302d2532303078"
1624   ); /* data:application/json,{"name":"Home%20Address%20-%200x */
1625 
1626   // Store reused revert messages as constants.
1627   string private constant _ACCOUNT_EXISTS = string(
1628     "Only non-existent accounts can be deployed or used to mint tokens."
1629   );
1630 
1631   string private constant _ONLY_CONTROLLER = string(
1632     "Only the designated controller can call this function."
1633   );
1634 
1635   string private constant _NO_INIT_CODE_SUPPLIED = string(
1636     "Cannot deploy a contract with no initialization code supplied."
1637   );
1638 
1639   /**
1640    * @notice In the constructor, verify that deployment addresses are correct
1641    * and that supplied constant hash value of the contract creation code used to
1642    * deploy arbitrary contracts to home addresses is valid, and set an initial
1643    * high score key with the null address as the high score "holder". ERC165
1644    * supported interfaces are all registered during initizialization as well.
1645    */
1646   constructor() public {
1647     // Verify that the deployment address is set correctly as a constant.
1648     assert(address(this) == address(uint160(uint168(_FF_AND_THIS_CONTRACT))));
1649 
1650     // Verify the derivation of the deployment address.
1651     bytes32 initialDeployKey = bytes32(
1652       0x486f6d65576f726b20f09f8fa0f09f9ba0efb88faa3c548a76f9bd3c000c0000
1653     );    
1654     assert(address(this) == address(
1655       uint160(                      // Downcast to match the address type.
1656         uint256(                    // Convert to uint to truncate upper digits.
1657           keccak256(                // Compute the CREATE2 hash using 4 inputs.
1658             abi.encodePacked(       // Pack all inputs to the hash together.
1659               bytes1(0xff),         // Start with 0xff to distinguish from RLP.
1660               msg.sender,           // The deployer will be the caller.
1661               initialDeployKey,     // Pass in the supplied key as the salt.
1662               _HOME_INIT_CODE_HASH  // The metamorphic initialization code hash.
1663             )
1664           )
1665         )
1666       )
1667     ));
1668 
1669     // Verify the derivation of the tokenURI runtime storage address.
1670     bytes32 uriDeployKey = bytes32(
1671       0x486f6d65576f726b202d20746f6b656e55524920c21352fee5a62228db000000
1672     );
1673     bytes32 uriInitCodeHash = bytes32(
1674       0xdea98294867e3fdc48eb5975ecc53a79e2e1ea6e7e794137a9c34c4dd1565ba2
1675     );
1676     assert(_URI_END_SEGMENT_STORAGE == address(
1677       uint160(                      // Downcast to match the address type.
1678         uint256(                    // Convert to uint to truncate upper digits.
1679           keccak256(                // Compute the CREATE2 hash using 4 inputs.
1680             abi.encodePacked(       // Pack all inputs to the hash together.
1681               bytes1(0xff),         // Start with 0xff to distinguish from RLP.
1682               msg.sender,           // The deployer will be the caller.
1683               uriDeployKey,         // Pass in the supplied key as the salt.
1684               uriInitCodeHash       // The storage contract init code hash.
1685             )
1686           )
1687         )
1688       )
1689     ));
1690 
1691     // Verify that the correct runtime code is at the tokenURI storage contract.
1692     bytes32 expectedRuntimeStorageHash = bytes32(
1693       0x8834602968080bb1df9c44c9834c0a93533b72bbfa3865ee2c5be6a0c4125fc3
1694     );
1695     address runtimeStorage = _URI_END_SEGMENT_STORAGE;
1696     bytes32 runtimeStorageHash;
1697     assembly { runtimeStorageHash := extcodehash(runtimeStorage) }
1698     assert(runtimeStorageHash == expectedRuntimeStorageHash);
1699 
1700     // Verify that the supplied hash for the metamorphic init code is valid.
1701     assert(keccak256(abi.encode(_HOME_INIT_CODE)) == _HOME_INIT_CODE_HASH);
1702 
1703     // Set an initial high score key with the null address as the submitter.
1704     _highScoreKey = bytes32(
1705       0x0000000000000000000000000000000000000000ffffffffffffffffffffffff
1706     );
1707 
1708     // Register EIP165 interface for HomeWork.
1709     _registerInterface(_INTERFACE_ID_HOMEWORK);
1710 
1711     // Register EIP165 interface for ERC721 metadata.
1712     _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1713 
1714     // Register EIP165 interface for ERC1412 (batch transfers).
1715     _registerInterface(_INTERFACE_ID_ERC1412_BATCH_TRANSFERS);
1716   }
1717 
1718   /**
1719    * @notice Deploy a new contract with the desired initialization code to the
1720    * home address corresponding to a given key. Two conditions must be met: the
1721    * submitter must be designated as the controller of the home address (with
1722    * the initial controller set to the address corresponding to the first twenty
1723    * bytes of the key), and there must not be a contract currently deployed at
1724    * the home address. These conditions can be checked by calling
1725    * `getHomeAddressInformation` and `isDeployable` with the same key.
1726    * @param key bytes32 The unique value used to derive the home address.
1727    * @param initializationCode bytes The contract creation code that will be
1728    * used to deploy the contract to the home address.
1729    * @return The home address of the deployed contract.
1730    * @dev In order to deploy the contract to the home address, a new contract
1731    * will be deployed with runtime code set to the initialization code of the
1732    * contract that will be deployed to the home address. Then, metamorphic
1733    * initialization code will retrieve that initialization code and use it to
1734    * set up and deploy the desired contract to the home address. Bear in mind
1735    * that the deployed contract will interpret msg.sender as the address of THIS
1736    * contract, and not the address of the submitter - if the constructor of the
1737    * deployed contract uses msg.sender to set up ownership or other variables,
1738    * you must modify it to accept a constructor argument with the appropriate
1739    * address, or alternately to hard-code the intended address. Also, if your
1740    * contract DOES have constructor arguments, remember to include them as
1741    * ABI-encoded arguments at the end of the initialization code, just as you
1742    * would when performing a standard deploy. You may also want to provide the
1743    * key to `setReverseLookup` in order to find it again using only the home
1744    * address to prevent accidentally losing the key.
1745    */
1746   function deploy(bytes32 key, bytes calldata initializationCode)
1747     external
1748     payable
1749     onlyEmpty(key)
1750     onlyControllerDeployer(key)
1751     returns (address homeAddress, bytes32 runtimeCodeHash)
1752   {
1753     // Ensure that initialization code was supplied.
1754     require(initializationCode.length > 0, _NO_INIT_CODE_SUPPLIED);
1755 
1756     // Deploy the initialization storage contract and set address in storage.
1757     _initializationRuntimeStorageContract = _deployRuntimeStorageContract(
1758       initializationCode
1759     );
1760 
1761     // Use metamorphic initialization code to deploy contract to home address.
1762     (homeAddress, runtimeCodeHash) = _deployToHomeAddress(key);
1763   }
1764 
1765   /**
1766    * @notice Mint an ERC721 token to the supplied owner that can be redeemed in
1767    * order to gain control of a home address corresponding to a given key. Two
1768    * conditions must be met: the submitter must be designated as the controller
1769    * of the home address (with the initial controller set to the address
1770    * corresponding to the first 20 bytes of the key), and there must not be a
1771    * contract currently deployed at the home address. These conditions can be
1772    * checked by calling `getHomeAddressInformation` and `isDeployable` with the
1773    * same key.
1774    * @param key bytes32 The unique value used to derive the home address.
1775    * @param owner address The account that will be granted ownership of the
1776    * ERC721 token.
1777    * @dev In order to mint an ERC721 token, the assocated home address cannot be
1778    * in use, or else the token will not be able to deploy to the home address.
1779    * The controller is set to this contract until the token is redeemed, at
1780    * which point the redeemer designates a new controller for the home address.
1781    * The key of the home address and the tokenID of the ERC721 token are the
1782    * same value, but different types (bytes32 vs. uint256).
1783    */
1784   function lock(bytes32 key, address owner)
1785     external
1786     onlyEmpty(key)
1787     onlyController(key)
1788   {
1789     // Ensure that the specified owner is a valid ERC721 receiver.
1790     _validateOwner(owner, key);
1791 
1792     // Get the HomeAddress storage struct from the mapping using supplied key.
1793     HomeAddress storage home = _home[key];
1794 
1795     // Set the exists flag to true and the controller to this contract.
1796     home.exists = true;
1797     home.controller = address(this);
1798 
1799     // Emit an event signifying that this contract is now the controller. 
1800     emit NewController(key, address(this));
1801 
1802     // Mint the ERC721 token to the designated owner.
1803     _mint(owner, uint256(key));
1804   }
1805 
1806   /**
1807    * @notice Burn an ERC721 token to allow the supplied controller to gain the
1808    * ability to deploy to the home address corresponding to the key matching the
1809    * burned token. The submitter must be designated as either the owner of the
1810    * token or as an approved spender.
1811    * @param tokenId uint256 The ID of the ERC721 token to redeem.
1812    * @param controller address The account that will be granted control of the
1813    * home address corresponding to the given token.
1814    * @dev The controller cannot be designated as the address of this contract,
1815    * the null address, or the home address (the restriction on setting the home
1816    * address as the controller is due to the fact that the home address will not
1817    * be able to deploy to itself, as it needs to be empty before a contract can
1818    * be deployed to it).
1819    */
1820   function redeem(uint256 tokenId, address controller)
1821     external
1822     onlyTokenOwnerOrApprovedSpender(tokenId)
1823   {
1824     // Convert the token ID to a bytes32 key.
1825     bytes32 key = bytes32(tokenId);
1826 
1827     // Prevent the controller from being set to prohibited account values.
1828     _validateController(controller, key);
1829 
1830     // Burn the ERC721 token in question.
1831     _burn(tokenId);
1832 
1833     // Assign the new controller to the corresponding home address.
1834     _home[key].controller = controller;
1835 
1836     // Emit an event with the new controller. 
1837     emit NewController(key, controller);
1838   }
1839 
1840   /**
1841    * @notice Transfer control over deployment to the home address corresponding
1842    * to a given key. The caller must be designated as the current controller of
1843    * the home address (with the initial controller set to the address
1844    * corresponding to the first 20 bytes of the key) - This condition can be
1845    * checked by calling `getHomeAddressInformation` with the same key.
1846    * @param key bytes32 The unique value used to derive the home address.
1847    * @param controller address The account that will be granted control of the
1848    * home address corresponding to the given key.
1849    * @dev The controller cannot be designated as the address of this contract,
1850    * the null address, or the home address (the restriction on setting the home
1851    * address as the controller is due to the fact that the home address will not
1852    * be able to deploy to itself, as it needs to be empty before a contract can
1853    * be deployed to it).
1854    */
1855   function assignController(bytes32 key, address controller)
1856     external
1857     onlyController(key)
1858   {
1859     // Prevent the controller from being set to prohibited account values.
1860     _validateController(controller, key);
1861 
1862     // Assign the new controller to the corresponding home address.
1863     HomeAddress storage home = _home[key];
1864     home.exists = true;
1865     home.controller = controller;
1866 
1867     // Emit an event with the new controller. 
1868     emit NewController(key, controller);
1869   }
1870 
1871   /**
1872    * @notice Transfer control over deployment to the home address corresponding
1873    * to a given key to the null address, which will prevent it from being
1874    * deployed to again in the future. The caller must be designated as the
1875    * current controller of the corresponding home address (with the initial
1876    * controller set to the address corresponding to the first 20 bytes of the
1877    * key) - This condition can be checked by calling `getHomeAddressInformation`
1878    * with the same key.
1879    * @param key bytes32 The unique value used to derive the home address.
1880    */
1881   function relinquishControl(bytes32 key)
1882     external
1883     onlyController(key)
1884   {
1885     // Assign the null address as the controller of the given key.
1886     HomeAddress storage home = _home[key];
1887     home.exists = true;
1888     home.controller = address(0);
1889 
1890     // Emit an event with the null address as the controller. 
1891     emit NewController(key, address(0));
1892   }
1893 
1894   /**
1895    * @notice Burn an ERC721 token, set a supplied controller, and deploy a new
1896    * contract with the supplied initialization code to the corresponding home
1897    * address for the given token. The submitter must be designated as either the
1898    * owner of the token or as an approved spender.
1899    * @param tokenId uint256 The ID of the ERC721 token to redeem.
1900    * @param controller address The account that will be granted control of the
1901    * home address corresponding to the given token.
1902    * @param initializationCode bytes The contract creation code that will be
1903    * used to deploy the contract to the home address.
1904    * @return The home address and runtime code hash of the deployed contract.
1905    * @dev In order to deploy the contract to the home address, a new contract
1906    * will be deployed with runtime code set to the initialization code of the
1907    * contract that will be deployed to the home address. Then, metamorphic
1908    * initialization code will retrieve that initialization code and use it to
1909    * set up and deploy the desired contract to the home address. Bear in mind
1910    * that the deployed contract will interpret msg.sender as the address of THIS
1911    * contract, and not the address of the submitter - if the constructor of the
1912    * deployed contract uses msg.sender to set up ownership or other variables,
1913    * you must modify it to accept a constructor argument with the appropriate
1914    * address, or alternately to hard-code the intended address. Also, if your
1915    * contract DOES have constructor arguments, remember to include them as
1916    * ABI-encoded arguments at the end of the initialization code, just as you
1917    * would when performing a standard deploy. You may also want to provide the
1918    * key to `setReverseLookup` in order to find it again using only the home
1919    * address to prevent accidentally losing the key. The controller cannot be
1920    * designated as the address of this contract, the null address, or the home
1921    * address (the restriction on setting the home address as the controller is
1922    * due to the fact that the home address will not be able to deploy to itself,
1923    * as it needs to be empty before a contract can be deployed to it). Also,
1924    * checks on the contract at the home address being empty or not having the
1925    * correct controller are unnecessary, as they are performed when minting the
1926    * token and cannot be altered until the token is redeemed.
1927    */
1928   function redeemAndDeploy(
1929     uint256 tokenId,
1930     address controller,
1931     bytes calldata initializationCode
1932   )
1933     external
1934     payable
1935     onlyTokenOwnerOrApprovedSpender(tokenId)
1936     returns (address homeAddress, bytes32 runtimeCodeHash)
1937   {
1938     // Ensure that initialization code was supplied.
1939     require(initializationCode.length > 0, _NO_INIT_CODE_SUPPLIED);
1940 
1941     // Convert the token ID to a bytes32 key.
1942     bytes32 key = bytes32(tokenId);
1943 
1944     // Prevent the controller from being set to prohibited account values.
1945     _validateController(controller, key);
1946 
1947     // Burn the ERC721 token in question.
1948     _burn(tokenId);
1949 
1950     // Deploy the initialization storage contract and set address in storage.
1951     _initializationRuntimeStorageContract = _deployRuntimeStorageContract(
1952       initializationCode
1953     );
1954 
1955     // Set provided controller and increment contract deploy count at once.
1956     HomeAddress storage home = _home[key];
1957     home.exists = true;
1958     home.controller = controller;
1959     home.deploys += 1;
1960 
1961     // Emit an event with the new controller. 
1962     emit NewController(key, controller);
1963 
1964     // Use metamorphic initialization code to deploy contract to home address.
1965     (homeAddress, runtimeCodeHash) = _deployToHomeAddress(key);
1966   }
1967 
1968   /**
1969    * @notice Derive a new key by concatenating an arbitrary 32-byte salt value
1970    * and the address of the caller and performing a keccak256 hash. This allows
1971    * for the creation of keys with additional entropy where desired while also
1972    * preventing collisions with standard keys. The caller will be set as the
1973    * controller of the derived key.
1974    * @param salt bytes32 The desired salt value to use (along with the address
1975    * of the caller) when deriving the resultant key and corresponding home
1976    * address.
1977    * @return The derived key.
1978    * @dev Home addresses from derived keys will take longer to "mine" or locate,
1979    * as an additional hash must be performed when computing the corresponding
1980    * home address for each given salt input. Each caller will derive a different
1981    * key even if they are supplying the same salt value.
1982    */
1983   function deriveKey(bytes32 salt) external returns (bytes32 key) {
1984     // Derive the key using the supplied salt and the calling address.
1985     key = _deriveKey(salt, msg.sender);
1986 
1987     // Register key and set caller as controller if it is not yet registered.
1988     HomeAddress storage home = _home[key];
1989     if (!home.exists) {
1990       home.exists = true;
1991       home.controller = msg.sender;
1992 
1993       // Emit an event with the sender as the new controller. 
1994       emit NewController(key, msg.sender);
1995     }
1996   }
1997 
1998   /**
1999    * @notice Mint an ERC721 token to the supplied owner that can be redeemed in
2000    * order to gain control of a home address corresponding to a given derived
2001    * key. Two conditions must be met: the submitter must be designated as the
2002    * current controller of the home address, and there must not be a contract
2003    * currently deployed at the home address. These conditions can be checked by
2004    * calling `getHomeAddressInformation` and `isDeployable` with the key
2005    * determined by calling `getDerivedKey`.
2006    * @param salt bytes32 The salt value that is used to derive the key.
2007    * @param owner address The account that will be granted ownership of the
2008    * ERC721 token.
2009    * @return The derived key.
2010    * @dev In order to mint an ERC721 token, the assocated home address cannot be
2011    * in use, or else the token will not be able to deploy to the home address.
2012    * The controller is set to this contract until the token is redeemed, at
2013    * which point the redeemer designates a new controller for the home address.
2014    * The key of the home address and the tokenID of the ERC721 token are the
2015    * same value, but different types (bytes32 vs. uint256).
2016    */
2017   function deriveKeyAndLock(bytes32 salt, address owner)
2018     external
2019     returns (bytes32 key)
2020   {
2021     // Derive the key using the supplied salt and the calling address.
2022     key = _deriveKey(salt, msg.sender);
2023 
2024     // Ensure that the specified owner is a valid ERC721 receiver.
2025     _validateOwner(owner, key);
2026 
2027     // Ensure that a contract is not currently deployed to the home address.
2028     require(_isNotDeployed(key), _ACCOUNT_EXISTS);
2029 
2030     // Ensure that the caller is the controller of the derived key.
2031     HomeAddress storage home = _home[key];
2032     if (home.exists) {
2033       require(home.controller == msg.sender, _ONLY_CONTROLLER);
2034     }
2035 
2036     // Set the exists flag to true and the controller to this contract.
2037     home.exists = true;
2038     home.controller = address(this);
2039 
2040     // Mint the ERC721 token to the designated owner.
2041     _mint(owner, uint256(key));
2042 
2043     // Emit an event signifying that this contract is now the controller. 
2044     emit NewController(key, address(this));
2045   }
2046 
2047   /**
2048    * @notice Transfer control over deployment to the home address corresponding
2049    * to a given derived key. The caller must be designated as the current
2050    * controller of the home address - This condition can be checked by calling
2051    * `getHomeAddressInformation` with the key obtained via `getDerivedKey`.
2052    * @param salt bytes32 The salt value that is used to derive the key.
2053    * @param controller address The account that will be granted control of the
2054    * home address corresponding to the given derived key.
2055    * @return The derived key.
2056    * @dev The controller cannot be designated as the address of this contract,
2057    * the null address, or the home address (the restriction on setting the home
2058    * address as the controller is due to the fact that the home address will not
2059    * be able to deploy to itself, as it needs to be empty before a contract can
2060    * be deployed to it).
2061    */
2062   function deriveKeyAndAssignController(bytes32 salt, address controller)
2063     external
2064     returns (bytes32 key)
2065   {
2066     // Derive the key using the supplied salt and the calling address.
2067     key = _deriveKey(salt, msg.sender);
2068 
2069     // Prevent the controller from being set to prohibited account values.
2070     _validateController(controller, key);
2071 
2072     // Ensure that the caller is the controller of the derived key.
2073     HomeAddress storage home = _home[key];
2074     if (home.exists) {
2075       require(home.controller == msg.sender, _ONLY_CONTROLLER);
2076     }
2077 
2078     // Assign the new controller to the corresponding home address.
2079     home.exists = true;
2080     home.controller = controller;
2081 
2082     // Emit an event with the new controller. 
2083     emit NewController(key, controller);
2084   }
2085 
2086   /**
2087    * @notice Transfer control over deployment to the home address corresponding
2088    * to a given derived key to the null address, which will prevent it from
2089    * being deployed to again in the future. The caller must be designated as the
2090    * current controller of the home address - This condition can be checked by
2091    * calling `getHomeAddressInformation` with the key determined by calling
2092    * `getDerivedKey`.
2093    * @param salt bytes32 The salt value that is used to derive the key.
2094    * @return The derived key.
2095    */
2096   function deriveKeyAndRelinquishControl(bytes32 salt)
2097     external
2098     returns (bytes32 key)
2099   {
2100     // Derive the key using the supplied salt and the calling address.
2101     key = _deriveKey(salt, msg.sender);
2102 
2103     // Ensure that the caller is the controller of the derived key.
2104     HomeAddress storage home = _home[key];
2105     if (home.exists) {
2106       require(home.controller == msg.sender, _ONLY_CONTROLLER);
2107     }
2108 
2109     // Assign the null address as the controller of the given derived key.
2110     home.exists = true;
2111     home.controller = address(0);
2112 
2113     // Emit an event with the null address as the controller. 
2114     emit NewController(key, address(0));
2115   }
2116 
2117   /**
2118    * @notice Record a key that corresponds to a given home address by supplying
2119    * said key and using it to derive the address. This enables reverse lookup
2120    * of a key using only the home address in question. This method may be called
2121    * by anyone - control of the key is not required.
2122    * @param key bytes32 The unique value used to derive the home address.
2123    * @dev This does not set the salt or submitter fields, as those apply only to
2124    * derived keys (although a derived key may also be set with this method, just
2125    * without the derived fields).
2126    */
2127   function setReverseLookup(bytes32 key) external {
2128     // Derive home address of given key and set home address and key in mapping.
2129     _key[_getHomeAddress(key)].key = key;
2130   }
2131 
2132   /**
2133    * @notice Record the derived key that corresponds to a given home address by
2134    * supplying the salt and submitter that were used to derive the key. This
2135    * facititates reverse lookup of the derivation method of a key using only the
2136    * home address in question. This method may be called by anyone - control of
2137    * the derived key is not required.
2138    * @param salt bytes32 The salt value that is used to derive the key.
2139    * @param submitter address The account that submits the salt that is used to
2140    * derive the key.
2141    */
2142   function setDerivedReverseLookup(bytes32 salt, address submitter) external {
2143     // Derive the key using the supplied salt and submitter.
2144     bytes32 key = _deriveKey(salt, submitter);
2145 
2146     // Derive home address and set it along with all other relevant information.
2147     _key[_getHomeAddress(key)] = KeyInformation({
2148       key: key,
2149       salt: salt,
2150       submitter: submitter
2151     });
2152   }
2153 
2154   /**
2155    * @notice Deploy a new storage contract with the supplied code as runtime
2156    * code without deploying a contract to a home address. This can be used to
2157    * store the contract creation code for use in future deployments of contracts
2158    * to home addresses.
2159    * @param codePayload bytes The code to set as the runtime code of the
2160    * deployed contract.
2161    * @return The address of the deployed storage contract.
2162    * @dev Consider placing adequate protections on the storage contract to
2163    * prevent unwanted callers from modifying or destroying it. Also, if you are
2164    * placing contract contract creation code into the runtime storage contract,
2165    * remember to include any constructor parameters as ABI-encoded arguments at
2166    * the end of the contract creation code, similar to how you would perform a
2167    * standard deployment.
2168    */
2169   function deployRuntimeStorageContract(bytes calldata codePayload)
2170     external
2171     returns (address runtimeStorageContract)
2172   {
2173     // Ensure that a code payload was supplied.
2174     require(codePayload.length > 0, "No runtime code payload supplied.");
2175 
2176     // Deploy payload to the runtime storage contract and return the address.
2177     runtimeStorageContract = _deployRuntimeStorageContract(codePayload);
2178   }
2179 
2180   /**
2181    * @notice Deploy a new contract with the initialization code stored in the
2182    * runtime code at the specified initialization runtime storage contract to
2183    * the home address corresponding to a given key. Two conditions must be met:
2184    * the submitter must be designated as the controller of the home address
2185    * (with the initial controller set to the address corresponding to the first
2186    * 20 bytes of the key), and there must not be a contract currently deployed
2187    * at the home address. These conditions can be checked by calling
2188    * `getHomeAddressInformation` and `isDeployable` with the same key.
2189    * @param key bytes32 The unique value used to derive the home address.
2190    * @param initializationRuntimeStorageContract address The storage contract
2191    * with runtime code equal to the contract creation code that will be used to
2192    * deploy the contract to the home address.
2193    * @return The home address and runtime code hash of the deployed contract.
2194    * @dev When deploying a contract to a home address via this method, the
2195    * metamorphic initialization code will retrieve whatever initialization code
2196    * currently resides at the specified address and use it to set up and deploy
2197    * the desired contract to the home address. Bear in mind that the deployed
2198    * contract will interpret msg.sender as the address of THIS contract, and not
2199    * the address of the submitter - if the constructor of the deployed contract
2200    * uses msg.sender to set up ownership or other variables, you must modify it
2201    * to accept a constructor argument with the appropriate address, or
2202    * alternately to hard-code the intended address. Also, if your contract DOES
2203    * have constructor arguments, remember to include them as ABI-encoded
2204    * arguments at the end of the initialization code, just as you would when
2205    * performing a standard deploy. You may also want to provide the key to
2206    * `setReverseLookup` in order to find it again using only the home address to
2207    * prevent accidentally losing the key.
2208    */
2209   function deployViaExistingRuntimeStorageContract(
2210     bytes32 key,
2211     address initializationRuntimeStorageContract
2212   )
2213     external
2214     payable
2215     onlyEmpty(key)
2216     onlyControllerDeployer(key)
2217     returns (address homeAddress, bytes32 runtimeCodeHash)
2218   {
2219     // Ensure that the supplied runtime storage contract is not empty.
2220     _validateRuntimeStorageIsNotEmpty(initializationRuntimeStorageContract);
2221 
2222     // Set initialization runtime storage contract address in contract storage.
2223     _initializationRuntimeStorageContract = initializationRuntimeStorageContract;
2224 
2225     // Use metamorphic initialization code to deploy contract to home address.
2226     (homeAddress, runtimeCodeHash) = _deployToHomeAddress(key);
2227   }
2228 
2229   /**
2230    * @notice Burn an ERC721 token, set a supplied controller, and deploy a new
2231    * contract with the initialization code stored in the runtime code at the
2232    * specified initialization runtime storage contract to the home address
2233    * corresponding to a given key. The submitter must be designated as either
2234    * the owner of the token or as an approved spender.
2235    * @param tokenId uint256 The ID of the ERC721 token to redeem.
2236    * @param controller address The account that will be granted control of the
2237    * home address corresponding to the given token.
2238    * @param initializationRuntimeStorageContract address The storage contract
2239    * with runtime code equal to the contract creation code that will be used to
2240    * deploy the contract to the home address.
2241    * @return The home address and runtime code hash of the deployed contract.
2242    * @dev When deploying a contract to a home address via this method, the
2243    * metamorphic initialization code will retrieve whatever initialization code
2244    * currently resides at the specified address and use it to set up and deploy
2245    * the desired contract to the home address. Bear in mind that the deployed
2246    * contract will interpret msg.sender as the address of THIS contract, and not
2247    * the address of the submitter - if the constructor of the deployed contract
2248    * uses msg.sender to set up ownership or other variables, you must modify it
2249    * to accept a constructor argument with the appropriate address, or
2250    * alternately to hard-code the intended address. Also, if your contract DOES
2251    * have constructor arguments, remember to include them as ABI-encoded
2252    * arguments at the end of the initialization code, just as you would when
2253    * performing a standard deploy. You may also want to provide the key to
2254    * `setReverseLookup` in order to find it again using only the home address to
2255    * prevent accidentally losing the key. The controller cannot be designated as
2256    * the address of this contract, the null address, or the home address (the
2257    * restriction on setting the home address as the controller is due to the
2258    * fact that the home address will not be able to deploy to itself, as it
2259    * needs to be empty before a contract can be deployed to it). Also, checks on
2260    * the contract at the home address being empty or not having the correct
2261    * controller are unnecessary, as they are performed when minting the token
2262    * and cannot be altered until the token is redeemed.
2263    */
2264   function redeemAndDeployViaExistingRuntimeStorageContract(
2265     uint256 tokenId,
2266     address controller,
2267     address initializationRuntimeStorageContract
2268   )
2269     external
2270     payable
2271     onlyTokenOwnerOrApprovedSpender(tokenId)
2272     returns (address homeAddress, bytes32 runtimeCodeHash)
2273   {
2274     // Ensure that the supplied runtime storage contract is not empty.
2275     _validateRuntimeStorageIsNotEmpty(initializationRuntimeStorageContract);
2276 
2277     // Convert the token ID to a bytes32 key.
2278     bytes32 key = bytes32(tokenId);
2279 
2280     // Prevent the controller from being set to prohibited account values.
2281     _validateController(controller, key);
2282 
2283     // Burn the ERC721 token in question.
2284     _burn(tokenId);
2285 
2286     // Set initialization runtime storage contract address in contract storage.
2287     _initializationRuntimeStorageContract = initializationRuntimeStorageContract;
2288 
2289     // Set provided controller and increment contract deploy count at once.
2290     HomeAddress storage home = _home[key];
2291     home.exists = true;
2292     home.controller = controller;
2293     home.deploys += 1;
2294 
2295     // Emit an event with the new controller. 
2296     emit NewController(key, controller);
2297 
2298     // Use metamorphic initialization code to deploy contract to home address.
2299     (homeAddress, runtimeCodeHash) = _deployToHomeAddress(key);
2300   }
2301 
2302   /**
2303    * @notice Deploy a new contract with the desired initialization code to the
2304    * home address corresponding to a given derived key. Two conditions must be
2305    * met: the submitter must be designated as the controller of the home
2306    * address, and there must not be a contract currently deployed at the home
2307    * address. These conditions can be checked by calling
2308    * `getHomeAddressInformation` and `isDeployable` with the key obtained by
2309    * calling `getDerivedKey`.
2310    * @param salt bytes32 The salt value that is used to derive the key.
2311    * @param initializationCode bytes The contract creation code that will be
2312    * used to deploy the contract to the home address.
2313    * @return The home address, derived key, and runtime code hash of the
2314    * deployed contract.
2315    * @dev In order to deploy the contract to the home address, a new contract
2316    * will be deployed with runtime code set to the initialization code of the
2317    * contract that will be deployed to the home address. Then, metamorphic
2318    * initialization code will retrieve that initialization code and use it to
2319    * set up and deploy the desired contract to the home address. Bear in mind
2320    * that the deployed contract will interpret msg.sender as the address of THIS
2321    * contract, and not the address of the submitter - if the constructor of the
2322    * deployed contract uses msg.sender to set up ownership or other variables,
2323    * you must modify it to accept a constructor argument with the appropriate
2324    * address, or alternately to hard-code the intended address. Also, if your
2325    * contract DOES have constructor arguments, remember to include them as
2326    * ABI-encoded arguments at the end of the initialization code, just as you
2327    * would when performing a standard deploy. You may want to provide the salt
2328    * and submitter to `setDerivedReverseLookup` in order to find the salt,
2329    * submitter, and derived key using only the home address to prevent
2330    * accidentally losing them.
2331    */
2332   function deriveKeyAndDeploy(bytes32 salt, bytes calldata initializationCode)
2333     external
2334     payable
2335     returns (address homeAddress, bytes32 key, bytes32 runtimeCodeHash)
2336   {
2337     // Ensure that initialization code was supplied.
2338     require(initializationCode.length > 0, _NO_INIT_CODE_SUPPLIED);
2339 
2340     // Derive key and prepare to deploy using supplied salt and calling address.
2341     key = _deriveKeyAndPrepareToDeploy(salt);
2342 
2343     // Deploy the initialization storage contract and set address in storage.
2344     _initializationRuntimeStorageContract = _deployRuntimeStorageContract(
2345       initializationCode
2346     );
2347 
2348     // Use metamorphic initialization code to deploy contract to home address.
2349     (homeAddress, runtimeCodeHash) = _deployToHomeAddress(key);
2350   }
2351 
2352   /**
2353    * @notice Deploy a new contract with the initialization code stored in the
2354    * runtime code at the specified initialization runtime storage contract to
2355    * the home address corresponding to a given derived key. Two conditions must
2356    * be met: the submitter must be designated as the controller of the home
2357    * address, and there must not be a contract currently deployed at the home
2358    * address. These conditions can be checked by calling
2359    * `getHomeAddressInformation` and `isDeployable` with the key obtained by
2360    * calling `getDerivedKey`.
2361    * @param salt bytes32 The salt value that is used to derive the key.
2362    * @param initializationRuntimeStorageContract address The storage contract
2363    * with runtime code equal to the contract creation code that will be used to
2364    * deploy the contract to the home address.
2365    * @return The home address, derived key, and runtime code hash of the
2366    * deployed contract.
2367    * @dev When deploying a contract to a home address via this method, the
2368    * metamorphic initialization code will retrieve whatever initialization code
2369    * currently resides at the specified address and use it to set up and deploy
2370    * the desired contract to the home address. Bear in mind that the deployed
2371    * contract will interpret msg.sender as the address of THIS contract, and not
2372    * the address of the submitter - if the constructor of the deployed contract
2373    * uses msg.sender to set up ownership or other variables, you must modify it
2374    * to accept a constructor argument with the appropriate address, or
2375    * alternately to hard-code the intended address. Also, if your contract DOES
2376    * have constructor arguments, remember to include them as ABI-encoded
2377    * arguments at the end of the initialization code, just as you would when
2378    * performing a standard deploy. You may want to provide the salt and
2379    * submitter to `setDerivedReverseLookup` in order to find the salt,
2380    * submitter, and derived key using only the home address to prevent
2381    * accidentally losing them.
2382    */
2383   function deriveKeyAndDeployViaExistingRuntimeStorageContract(
2384     bytes32 salt,
2385     address initializationRuntimeStorageContract
2386   )
2387     external
2388     payable
2389     returns (address homeAddress, bytes32 key, bytes32 runtimeCodeHash)
2390   {
2391     // Ensure that the supplied runtime storage contract is not empty.
2392     _validateRuntimeStorageIsNotEmpty(initializationRuntimeStorageContract);
2393 
2394     // Derive key and prepare to deploy using supplied salt and calling address.
2395     key = _deriveKeyAndPrepareToDeploy(salt);
2396 
2397     // Set the initialization runtime storage contract in contract storage.
2398     _initializationRuntimeStorageContract = initializationRuntimeStorageContract;
2399 
2400     // Use metamorphic initialization code to deploy contract to home address.
2401     (homeAddress, runtimeCodeHash) = _deployToHomeAddress(key);
2402   }
2403 
2404   /**
2405    * @notice Mint multiple ERC721 tokens, designated by their keys, to the
2406    * specified owner. Keys that aren't controlled, or that point to home
2407    * addresses that are currently deployed, will be skipped.
2408    * @param owner address The account that will be granted ownership of the
2409    * ERC721 tokens.
2410    * @param keys bytes32[] An array of values used to derive each home address.
2411    * @dev If you plan to use this method regularly or want to keep gas costs to
2412    * an absolute minimum, and are willing to go without standard ABI encoding,
2413    * see `batchLock_63efZf` for a more efficient (and unforgiving)
2414    * implementation. For batch token minting with *derived* keys, see
2415    * `deriveKeysAndBatchLock`.
2416    */
2417   function batchLock(address owner, bytes32[] calldata keys) external {
2418     // Track each key in the array of keys.
2419     bytes32 key;
2420 
2421     // Ensure that the specified owner is a valid ERC721 receiver.
2422     if (keys.length > 0) {
2423       _validateOwner(owner, keys[0]);
2424     }
2425 
2426     // Iterate through each provided key argument.
2427     for (uint256 i; i < keys.length; i++) {
2428       key = keys[i];
2429 
2430       // Skip if the key currently has a contract deployed to its home address.
2431       if (!_isNotDeployed(key)) {
2432         continue;
2433       }
2434 
2435       // Skip if the caller is not the controller.
2436       if (_getController(key) != msg.sender) {
2437         continue;
2438       }
2439 
2440       // Set the exists flag to true and the controller to this contract.
2441       HomeAddress storage home = _home[key];
2442       home.exists = true;
2443       home.controller = address(this);
2444 
2445       // Emit an event signifying that this contract is now the controller. 
2446       emit NewController(key, address(this));
2447 
2448       // Mint the ERC721 token to the designated owner.
2449       _mint(owner, uint256(key));
2450     }
2451   }
2452 
2453   /**
2454    * @notice Mint multiple ERC721 tokens, designated by salts that are hashed
2455    * with the caller's address to derive each key, to the specified owner.
2456    * Derived keys that aren't controlled, or that point to home addresses that
2457    * are currently deployed, will be skipped.
2458    * @param owner address The account that will be granted ownership of the
2459    * ERC721 tokens.
2460    * @param salts bytes32[] An array of values used to derive each key and
2461    * corresponding home address.
2462    * @dev See `batchLock` for batch token minting with standard, non-derived
2463    * keys.
2464    */
2465   function deriveKeysAndBatchLock(address owner, bytes32[] calldata salts)
2466     external
2467   {
2468     // Track each key derived from the array of salts.
2469     bytes32 key;
2470 
2471     // Ensure that the specified owner is a valid ERC721 receiver.
2472     if (salts.length > 0) {
2473       _validateOwner(owner, _deriveKey(salts[0], msg.sender));
2474     }
2475 
2476     // Iterate through each provided salt argument.
2477     for (uint256 i; i < salts.length; i++) {
2478       // Derive the key using the supplied salt and the calling address.
2479       key = _deriveKey(salts[i], msg.sender);
2480 
2481       // Skip if the key currently has a contract deployed to its home address.
2482       if (!_isNotDeployed(key)) {
2483         continue;
2484       }
2485 
2486       // Skip if the caller is not the controller.
2487       HomeAddress storage home = _home[key];
2488       if (home.exists && home.controller != msg.sender) {
2489         continue;
2490       }
2491 
2492       // Set the exists flag to true and the controller to this contract.
2493       home.exists = true;
2494       home.controller = address(this);
2495 
2496       // Emit an event signifying that this contract is now the controller. 
2497       emit NewController(key, address(this));
2498 
2499       // Mint the ERC721 token to the designated owner.
2500       _mint(owner, uint256(key));
2501     }
2502   }
2503 
2504   /**
2505    * @notice Safely transfers the ownership of a group of token IDs to another
2506    * address in a batch. If the target address is a contract, it must implement
2507    * `onERC721Received`, called upon a safe transfer, and return the magic value
2508    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`;
2509    * otherwise, or if another error occurs, the entire batch is reverted.
2510    * Requires msg.sender to be the owner, approved, or operator of the tokens.
2511    * @param from address The current owner of the tokens.
2512    * @param to address The account to receive ownership of the given tokens.
2513    * @param tokenIds uint256[] ID of the tokens to be transferred.
2514    */
2515   function safeBatchTransferFrom(
2516     address from,
2517     address to,
2518     uint256[] calldata tokenIds
2519   )
2520     external
2521   {
2522     // Track each token ID in the batch.
2523     uint256 tokenId;
2524 
2525     // Iterate over each supplied token ID.
2526     for (uint256 i = 0; i < tokenIds.length; i++) {
2527       // Set the current token ID.
2528       tokenId = tokenIds[i];
2529 
2530       // Perform the token transfer.
2531       safeTransferFrom(from, to, tokenId);
2532     }
2533   }
2534 
2535   /**
2536    * @notice Safely transfers the ownership of a group of token IDs to another
2537    * address in a batch. If the target address is a contract, it must implement
2538    * `onERC721Received`, called upon a safe transfer, and return the magic value
2539    * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`;
2540    * otherwise, or if another error occurs, the entire batch is reverted.
2541    * Requires msg.sender to be the owner, approved, or operator of the tokens.
2542    * @param from address The current owner of the tokens.
2543    * @param to address The account to receive ownership of the given tokens.
2544    * @param tokenIds uint256[] ID of the tokens to be transferred.
2545    * @param data bytes A data payload to include with each transfer.   
2546    */
2547   function safeBatchTransferFrom(
2548     address from,
2549     address to,
2550     uint256[] calldata tokenIds,
2551     bytes calldata data
2552   )
2553     external
2554   {
2555     // Track each token ID in the batch.
2556     uint256 tokenId;
2557 
2558     // Iterate over each supplied token ID.
2559     for (uint256 i = 0; i < tokenIds.length; i++) {
2560       // Set the current token ID.
2561       tokenId = tokenIds[i];
2562 
2563       // Perform the token transfer.
2564       safeTransferFrom(from, to, tokenId, data);
2565     }
2566   }
2567 
2568   /**
2569    * @notice Efficient version of `batchLock` that uses less gas. The first 20
2570    * bytes of each key are automatically populated using msg.sender, and the
2571    * remaining key segments are passed in as a packed byte array, using twelve
2572    * bytes per segment, with a function selector of 0x00000000 followed by a
2573    * twenty-byte segment for the desired owner of the minted ERC721 tokens. Note
2574    * that an attempt to lock a key that is not controlled or with its contract
2575    * already deployed will cause the entire batch to revert. Checks on whether
2576    * the owner is a valid ERC721 receiver are also skipped, similar to using
2577    * `transferFrom` instead of `safeTransferFrom`.
2578    */
2579   function batchLock_63efZf(/* packed owner and key segments */) external {
2580     // Get the owner from calldata, located at bytes 4-23 (sig is bytes 0-3).
2581     address owner;
2582 
2583     // Determine number of 12-byte key segments in calldata from byte 24 on.
2584     uint256 passedSaltSegments;
2585 
2586     // Get the owner and calculate the total number of key segments.
2587     assembly {
2588       owner := shr(0x60, calldataload(4))                  // comes after sig
2589       passedSaltSegments := div(sub(calldatasize, 24), 12) // after sig & owner
2590     }
2591 
2592     // Track each key, located at each 12-byte segment from byte 24 on.
2593     bytes32 key;
2594 
2595     // Iterate through each provided key segment argument.
2596     for (uint256 i; i < passedSaltSegments; i++) {
2597       // Construct keys by concatenating msg.sender with each key segment.
2598       assembly {
2599         key := add(                   // Combine msg.sender & provided key.
2600           shl(0x60, caller),          // Place msg.sender at start of word.
2601           shr(0xa0, calldataload(add(24, mul(i, 12))))   // Segment at end.
2602         )
2603       }
2604 
2605       // Ensure that the key does not currently have a deployed contract.
2606       require(_isNotDeployed(key), _ACCOUNT_EXISTS);
2607 
2608       // Ensure that the caller is the controller of the key.
2609       HomeAddress storage home = _home[key];
2610       if (home.exists) {
2611         require(home.controller == msg.sender, _ONLY_CONTROLLER);
2612       }
2613 
2614       // Set the exists flag to true and the controller to this contract.
2615       home.exists = true;
2616       home.controller = address(this);
2617 
2618       // Emit an event signifying that this contract is now the controller. 
2619       emit NewController(key, address(this));
2620 
2621       // Mint the ERC721 token to the designated owner.
2622       _mint(owner, uint256(key));
2623     }
2624   }
2625 
2626   /**
2627    * @notice Perform a dry-run of the deployment of a contract using a given key
2628    * and revert on successful deployment. It cannot be called from outside the
2629    * contract (even though it is marked as external).
2630    * @param key bytes32 The unique value used to derive the home address.
2631    * @dev This contract is called by `_isNotDeployable` in extreme cases where
2632    * the deployability of the contract cannot be determined conclusively.
2633    */
2634   function staticCreate2Check(bytes32 key) external {
2635     require(
2636       msg.sender == address(this),
2637       "This function can only be called by this contract."
2638     );
2639 
2640     assembly {
2641       // Write the 32-byte metamorphic initialization code to scratch space.
2642       mstore(
2643         0,
2644         0x5859385958601c335a585952fa1582838382515af43d3d93833e601e57fd5bf3
2645       )
2646 
2647       // Call `CREATE2` using metamorphic init code with supplied key as salt.
2648       let deploymentAddress := create2(0, 0, 32, key)
2649 
2650       // Revert and return the metamorphic init code on successful deployment.
2651       if deploymentAddress {        
2652         revert(0, 32)
2653       }
2654     }
2655   }
2656 
2657   /**
2658    * @notice Submit a key to claim the "high score" - the lower the uint160
2659    * value of the key's home address, the higher the score. The high score
2660    * holder has the exclusive right to recover lost ether and tokens on this
2661    * contract.
2662    * @param key bytes32 The unique value used to derive the home address that
2663    * will determine the resultant score.
2664    * @dev The high score must be claimed by a direct key (one that is submitted
2665    * by setting the first 20 bytes of the key to the address of the submitter)
2666    * and not by a derived key, and is non-transferrable. If you want to help
2667    * people recover their lost tokens, you might consider deploying a contract
2668    * to the high score address (probably a metamorphic one so that you can use
2669    * the home address later) with your contact information.
2670    */
2671   function claimHighScore(bytes32 key) external {
2672     require(
2673       msg.sender == address(bytes20(key)),
2674       "Only submitters directly encoded in a given key may claim a high score."
2675     );
2676 
2677     // Derive the "home address" of the current high score key.
2678     address currentHighScore = _getHomeAddress(_highScoreKey);
2679 
2680     // Derive the "home address" of the new high score key.
2681     address newHighScore = _getHomeAddress(key);
2682 
2683     // Use addresses to ensure that supplied key is in fact a new high score.
2684     require(
2685       uint160(newHighScore) < uint160(currentHighScore),
2686       "Submitted high score is not better than the current high score."
2687     );
2688 
2689     // Set the new high score to the supplied key.
2690     _highScoreKey = key;
2691 
2692     // The score is equal to (2^160 - 1) - ("home address" of high score key).
2693     uint256 score = uint256(uint160(-1) - uint160(newHighScore));
2694 
2695     // Emit an event to signify that a new high score has been reached.
2696     emit NewHighScore(key, msg.sender, score);
2697   }
2698 
2699   /**
2700    * @notice Transfer any ether or ERC20 tokens that have somehow ended up at
2701    * this contract by specifying a token address (set to the null address for
2702    * ether) as well as a recipient address. Only the high score holder can
2703    * recover lost ether and tokens on this contract.
2704    * @param token address The contract address of the ERC20 token to recover, or
2705    * the null address for recovering Ether.
2706    * @param recipient address payable The account where recovered funds should
2707    * be transferred.
2708    * @dev If you are trying to recover funds that were accidentally sent into
2709    * this contract, see if you can contact the holder of the current high score,
2710    * found by calling `getHighScore`. Better yet, try to find a new high score
2711    * yourself!
2712    */
2713   function recover(IERC20 token, address payable recipient) external {
2714     require(
2715       msg.sender == address(bytes20(_highScoreKey)),
2716       "Only the current high score holder may recover tokens."
2717     );
2718 
2719     if (address(token) == address(0)) {
2720       // Recover ETH if the token's contract address is set to the null address.
2721       recipient.transfer(address(this).balance);
2722     } else {
2723       // Determine the given ERC20 token balance and transfer to the recipient.
2724       uint256 balance = token.balanceOf(address(this));
2725       token.transfer(recipient, balance);
2726     }
2727   }
2728 
2729   /**
2730    * @notice "View" function to determine if a contract can currently be
2731    * deployed to a home address given the corresponding key. A contract is only
2732    * deployable if no account currently exists at the address - any existing
2733    * contract must be destroyed via `SELFDESTRUCT` before a new contract can be
2734    * deployed to a home address. This method does not modify state but is
2735    * inaccessible via staticcall.
2736    * @param key bytes32 The unique value used to derive the home address.
2737    * @return A boolean signifying if a contract can be deployed to the home
2738    * address that corresponds to the provided key.
2739    * @dev This will not detect if a contract is not deployable due control
2740    * having been relinquished on the key.
2741    */
2742   function isDeployable(bytes32 key)
2743     external
2744     /* view */
2745     returns (bool deployable)
2746   {
2747     deployable = _isNotDeployed(key);
2748   }
2749 
2750   /**
2751    * @notice View function to get the current "high score", or the lowest
2752    * uint160 value of a home address of all keys submitted. The high score
2753    * holder has the exclusive right to recover lost ether and tokens on this
2754    * contract.
2755    * @return The current high score holder, their score, and the submitted key.
2756    */
2757   function getHighScore()
2758     external
2759     view
2760     returns (address holder, uint256 score, bytes32 key)
2761   {
2762     // Get the key and subbmitter holding the current high score.
2763     key = _highScoreKey;
2764     holder = address(bytes20(key));
2765 
2766     // The score is equal to (2^160 - 1) - ("home address" of high score key).
2767     score = uint256(uint160(-1) - uint160(_getHomeAddress(key)));
2768   }
2769 
2770   /**
2771    * @notice View function to get information on a home address given the
2772    * corresponding key.
2773    * @param key bytes32 The unique value used to derive the home address.
2774    * @return The home address, the current controller of the address, the number
2775    * of times the home address has been deployed to, and the code hash of the
2776    * runtime currently found at the home address, if any.
2777    * @dev There is also an `isDeployable` method for determining if a contract
2778    * can be deployed to the address, but in extreme cases it must actually
2779    * perform a dry-run to determine if the contract is deployable, which means
2780    * that it does not support staticcalls. There is also a convenience method,
2781    * `hasNeverBeenDeployed`, but the information it conveys can be determined
2782    * from this method alone as well.
2783    */
2784   function getHomeAddressInformation(bytes32 key)
2785     external
2786     view
2787     returns (
2788       address homeAddress,
2789       address controller,
2790       uint256 deploys,
2791       bytes32 currentRuntimeCodeHash
2792     )
2793   {
2794     // Derive home address and retrieve other information using supplied key.
2795     homeAddress = _getHomeAddress(key);
2796     HomeAddress memory home = _home[key];
2797 
2798     // If the home address has not been seen before, use the default controller.
2799     if (!home.exists) {
2800       controller = address(bytes20(key));
2801     } else {
2802       controller = home.controller;
2803     }
2804 
2805     // Retrieve the count of total deploys to the home address.
2806     deploys = home.deploys;
2807 
2808     // Retrieve keccak256 hash of runtime code currently at the home address.
2809     assembly { currentRuntimeCodeHash := extcodehash(homeAddress) }
2810   }
2811 
2812   /**
2813    * @notice View function to determine if no contract has ever been deployed to
2814    * a home address given the corresponding key. This can be used to ensure that
2815    * a given key or corresponding token is "new" or not.
2816    * @param key bytes32 The unique value used to derive the home address.
2817    * @return A boolean signifying if a contract has never been deployed using
2818    * the supplied key before.
2819    */
2820   function hasNeverBeenDeployed(bytes32 key)
2821     external
2822     view
2823     returns (bool neverBeenDeployed)
2824   {
2825     neverBeenDeployed = (_home[key].deploys == 0);
2826   }
2827 
2828   /**
2829    * @notice View function to search for a known key, salt, and/or submitter
2830    * given a supplied home address. Keys can be controlled directly by an
2831    * address that matches the first 20 bytes of the key, or they can be derived
2832    * from a salt and a submitter - if the key is not a derived key, the salt and
2833    * submitter fields will both have a value of zero.
2834    * @param homeAddress address The home address to check for key information.
2835    * @return The key, salt, and/or submitter used to deploy to the home address,
2836    * assuming they have been submitted to the reverse lookup.
2837    * @dev To populate these values, call `setReverseLookup` for cases where keys
2838    * are used directly or are the only value known, or `setDerivedReverseLookup`
2839    * for cases where keys are derived from a known salt and submitter.
2840    */
2841   function reverseLookup(address homeAddress)
2842     external
2843     view
2844     returns (bytes32 key, bytes32 salt, address submitter)
2845   {
2846     KeyInformation memory keyInformation = _key[homeAddress];
2847     key = keyInformation.key;
2848     salt = keyInformation.salt;
2849     submitter = keyInformation.submitter;
2850   }
2851 
2852   /**
2853    * @notice View function used by the metamorphic initialization code when
2854    * deploying a contract to a home address. It returns the address of the
2855    * runtime storage contract that holds the contract creation code, which the
2856    * metamorphic creation code then `DELEGATECALL`s into in order to set up the
2857    * contract and deploy the target runtime code.
2858    * @return The current runtime storage contract that contains the target
2859    * contract creation code.
2860    * @dev This method is not meant to be part of the user-facing contract API,
2861    * but is rather a mechanism for enabling the deployment of arbitrary code via
2862    * fixed initialization code. The odd naming is chosen so that function
2863    * selector will be 0x00000009 - that way, the metamorphic contract can simply
2864    * use the `PC` opcode in order to push the selector to the stack.
2865    */
2866   function getInitializationCodeFromContractRuntime_6CLUNS()
2867     external
2868     view
2869     returns (address initializationRuntimeStorageContract)
2870   {
2871     // Return address of contract with initialization code set as runtime code.
2872     initializationRuntimeStorageContract = _initializationRuntimeStorageContract;
2873   }
2874 
2875   /**
2876    * @notice View function to return an URI for a given token ID. Throws if the
2877    * token ID does not exist.
2878    * @param tokenId uint256 ID of the token to query.
2879    * @return String representing the URI data encoding of JSON metadata.
2880    * @dev The URI returned by this method takes the following form (with all
2881    * returns and initial whitespace removed - it's just here for clarity):
2882    *
2883    * data:application/json,{
2884    *   "name":"Home%20Address%20-%200x********************",
2885    *   "description":"< ... HomeWork NFT desription ... >",
2886    *   "image":"data:image/svg+xml;charset=utf-8;base64,< ... Image ... >"}
2887    *
2888    * where ******************** represents the checksummed home address that the
2889    * token confers control over.
2890    */
2891   function tokenURI(uint256 tokenId)
2892     external
2893     view
2894     returns (string memory)
2895   {
2896     // Only return a URI for tokens that exist.
2897     require(_exists(tokenId), "A token with the given ID does not exist.");
2898 
2899     // Get the home address that the given tokenId corresponds to.
2900     address homeAddress = _getHomeAddress(bytes32(tokenId));
2901 
2902     // Get the checksummed, ascii-encoded representation of the home address.
2903     string memory asciiHomeAddress = _toChecksummedAsciiString(homeAddress);
2904     
2905     bytes memory uriEndSegment = _getTokenURIStorageRuntime();
2906 
2907     // Insert checksummed address into URI in name and image fields and return.
2908     return string(
2909       abi.encodePacked(      // Concatenate all the string segments together.
2910         _URI_START_SEGMENT,  // Data URI ID and initial formatting is constant.
2911         asciiHomeAddress,    // Checksummed home address is in the name field.
2912         uriEndSegment        // Description, image, and formatting is constant.
2913       )
2914     );
2915   }
2916 
2917   /**
2918    * @notice Pure function to get the token name.
2919    * @return String representing the token name.
2920    */
2921   function name() external pure returns (string memory) {
2922     return _NAME;
2923   }
2924 
2925   /**
2926    * @notice Pure function to get the token symbol.
2927    * @return String representing the token symbol.
2928    */
2929   function symbol() external pure returns (string memory) {
2930     return _SYMBOL;
2931   }
2932 
2933   /**
2934    * @notice Pure function to determine the key that is derived from a given
2935    * salt and submitting address.
2936    * @param salt bytes32 The salt value that is used to derive the key.
2937    * @param submitter address The submitter of the salt value used to derive the
2938    * key.
2939    * @return The derived key.
2940    */
2941   function getDerivedKey(bytes32 salt, address submitter)
2942     external
2943     pure
2944     returns (bytes32 key)
2945   {
2946     // Derive the key using the supplied salt and submitter.
2947     key = _deriveKey(salt, submitter);
2948   }
2949 
2950   /**
2951    * @notice Pure function to determine the home address that corresponds to
2952    * a given key.
2953    * @param key bytes32 The unique value used to derive the home address.
2954    * @return The home address.
2955    */
2956   function getHomeAddress(bytes32 key)
2957     external
2958     pure
2959     returns (address homeAddress)
2960   {
2961     // Derive the home address using the supplied key.
2962     homeAddress = _getHomeAddress(key);
2963   }
2964 
2965   /**
2966    * @notice Pure function for retrieving the metamorphic initialization code
2967    * used to deploy arbitrary contracts to home addresses. Provided for easy
2968    * verification and for use in other applications.
2969    * @return The 32-byte metamorphic initialization code.
2970    * @dev This metamorphic init code works via the "metamorphic delegator"
2971    * mechanism, which is explained in greater detail at `_deployToHomeAddress`.
2972    */
2973   function getMetamorphicDelegatorInitializationCode()
2974     external
2975     pure
2976     returns (bytes32 metamorphicDelegatorInitializationCode)
2977   {
2978     metamorphicDelegatorInitializationCode = _HOME_INIT_CODE;
2979   }
2980 
2981   /**
2982    * @notice Pure function for retrieving the keccak256 of the metamorphic
2983    * initialization code used to deploy arbitrary contracts to home addresses.
2984    * This is the value that you should use, along with this contract's address
2985    * and a caller address that you control, to mine for an partucular type of
2986    * home address (such as one at a compact or gas-efficient address).
2987    * @return The keccak256 hash of the metamorphic initialization code.
2988    */
2989   function getMetamorphicDelegatorInitializationCodeHash()
2990     external
2991     pure
2992     returns (bytes32 metamorphicDelegatorInitializationCodeHash)
2993   {
2994     metamorphicDelegatorInitializationCodeHash = _HOME_INIT_CODE_HASH;
2995   }
2996 
2997   /**
2998    * @notice Pure function for retrieving the prelude that will be inserted
2999    * ahead of the code payload in order to deploy a runtime storage contract.
3000    * @return The 11-byte "arbitrary runtime" prelude.
3001    */
3002   function getArbitraryRuntimeCodePrelude()
3003     external
3004     pure
3005     returns (bytes11 prelude)
3006   {
3007     prelude = _ARBITRARY_RUNTIME_PRELUDE;
3008   }
3009 
3010   /**
3011    * @notice Internal function for deploying a runtime storage contract given a
3012    * particular payload.
3013    * @return The address of the runtime storage contract.
3014    * @dev To take the provided code payload and deploy a contract with that
3015    * payload as its runtime code, use the following prelude:
3016    *
3017    * 0x600b5981380380925939f3...
3018    *
3019    * 00  60  push1 0b      [11 -> offset]
3020    * 02  59  msize         [offset, 0]
3021    * 03  81  dup2          [offset, 0, offset]
3022    * 04  38  codesize      [offset, 0, offset, codesize]
3023    * 05  03  sub           [offset, 0, codesize - offset]
3024    * 06  80  dup1          [offset, 0, codesize - offset, codesize - offset]
3025    * 07  92  swap3         [codesize - offset, 0, codesize - offset, offset]
3026    * 08  59  msize         [codesize - offset, 0, codesize - offset, offset, 0]
3027    * 09  39  codecopy      [codesize - offset, 0] <init_code_in_runtime>
3028    * 10  f3  return        [] *init_code_in_runtime*
3029    * ... init_code
3030    */
3031   function _deployRuntimeStorageContract(bytes memory payload)
3032     internal
3033     returns (address runtimeStorageContract)
3034   {
3035     // Construct the contract creation code using the prelude and the payload.
3036     bytes memory runtimeStorageContractCreationCode = abi.encodePacked(
3037       _ARBITRARY_RUNTIME_PRELUDE,
3038       payload
3039     );
3040 
3041     assembly {
3042       // Get the location and length of the newly-constructed creation code.
3043       let encoded_data := add(0x20, runtimeStorageContractCreationCode)
3044       let encoded_size := mload(runtimeStorageContractCreationCode)
3045 
3046       // Deploy the runtime storage contract via standard `CREATE`.
3047       runtimeStorageContract := create(0, encoded_data, encoded_size)
3048 
3049       // Pass along revert message if the contract did not deploy successfully.
3050       if iszero(runtimeStorageContract) {
3051         returndatacopy(0, 0, returndatasize)
3052         revert(0, returndatasize)
3053       }
3054     }
3055 
3056     // Emit an event with address of newly-deployed runtime storage contract.
3057     emit NewRuntimeStorageContract(runtimeStorageContract, keccak256(payload));
3058   }
3059 
3060   /**
3061    * @notice Internal function for deploying arbitrary contract code to the home
3062    * address corresponding to a suppied key via metamorphic initialization code.
3063    * @return The home address and the hash of the deployed runtime code.
3064    * @dev This deployment method uses the "metamorphic delegator" pattern, where
3065    * it will retrieve the address of the contract that contains the target
3066    * initialization code, then delegatecall into it, which executes the
3067    * initialization code stored there and returns the runtime code (or reverts).
3068    * Then, the runtime code returned by the delegatecall is returned, and since
3069    * we are still in the initialization context, it will be set as the runtime
3070    * code of the metamorphic contract. The 32-byte metamorphic initialization
3071    * code is as follows:
3072    *
3073    * 0x5859385958601c335a585952fa1582838382515af43d3d93833e601e57fd5bf3
3074    *
3075    * 00  58  PC               [0]
3076    * 01  59  MSIZE            [0, 0]
3077    * 02  38  CODESIZE         [0, 0, codesize -> 32]
3078    * returndatac03  59  MSIZE            [0, 0, 32, 0]
3079    * 04  58  PC               [0, 0, 32, 0, 4]
3080    * 05  60  PUSH1 0x1c       [0, 0, 32, 0, 4, 28]
3081    * 07  33  CALLER           [0, 0, 32, 0, 4, 28, caller]
3082    * 08  5a  GAS              [0, 0, 32, 0, 4, 28, caller, gas]
3083    * 09  58  PC               [0, 0, 32, 0, 4, 28, caller, gas, 9 -> selector]
3084    * 10  59  MSIZE            [0, 0, 32, 0, 4, 28, caller, gas, selector, 0]
3085    * 11  52  MSTORE           [0, 0, 32, 0, 4, 28, caller, gas] <selector>
3086    * 12  fa  STATICCALL       [0, 0, 1 => success] <init_in_runtime_address>
3087    * 13  15  ISZERO           [0, 0, 0]
3088    * 14  82  DUP3             [0, 0, 0, 0]
3089    * 15  83  DUP4             [0, 0, 0, 0, 0]
3090    * 16  83  DUP4             [0, 0, 0, 0, 0, 0]
3091    * 17  82  DUP3             [0, 0, 0, 0, 0, 0, 0]
3092    * 18  51  MLOAD            [0, 0, 0, 0, 0, 0, init_in_runtime_address]
3093    * 19  5a  GAS              [0, 0, 0, 0, 0, 0, init_in_runtime_address, gas]
3094    * 20  f4  DELEGATECALL     [0, 0, 1 => success] {runtime_code}
3095    * 21  3d  RETURNDATASIZE   [0, 0, 1 => success, size]
3096    * 22  3d  RETURNDATASIZE   [0, 0, 1 => success, size, size]
3097    * 23  93  SWAP4            [size, 0, 1 => success, size, 0]
3098    * 24  83  DUP4             [size, 0, 1 => success, size, 0, 0]
3099    * 25  3e  RETURNDATACOPY   [size, 0, 1 => success] <runtime_code>
3100    * 26  60  PUSH1 0x1e       [size, 0, 1 => success, 30]
3101    * 28  57  JUMPI            [size, 0]
3102    * 29  fd  REVERT           [] *runtime_code*
3103    * 30  5b  JUMPDEST         [size, 0]
3104    * 31  f3  RETURN           []
3105    */
3106   function _deployToHomeAddress(bytes32 key)
3107     internal
3108     returns (address homeAddress, bytes32 runtimeCodeHash)
3109   {    
3110     assembly {
3111       // Write the 32-byte metamorphic initialization code to scratch space.
3112       mstore(
3113         0,
3114         0x5859385958601c335a585952fa1582838382515af43d3d93833e601e57fd5bf3
3115       )
3116 
3117       // Call `CREATE2` using above init code with the supplied key as the salt.
3118       homeAddress := create2(callvalue, 0, 32, key)
3119 
3120       // Pass along revert message if the contract did not deploy successfully.
3121       if iszero(homeAddress) {
3122         returndatacopy(0, 0, returndatasize)
3123         revert(0, returndatasize)
3124       }
3125 
3126       // Get the runtime hash of the deployed contract.
3127       runtimeCodeHash := extcodehash(homeAddress)
3128     }
3129 
3130     // Clear the address of the runtime storage contract from storage.
3131     delete _initializationRuntimeStorageContract;
3132 
3133     // Emit an event with home address, key, and runtime hash of new contract.
3134     emit NewResident(homeAddress, key, runtimeCodeHash);
3135   }
3136 
3137   /**
3138    * @notice Internal function for deriving a key given a particular salt and
3139    * caller and for performing verifications of, and modifications to, the
3140    * information set on that key.
3141    * @param salt bytes32 The value used to derive the key.
3142    * @return The derived key.
3143    */
3144   function _deriveKeyAndPrepareToDeploy(bytes32 salt)
3145     internal
3146     returns (bytes32 key)
3147   {
3148     // Derive the key using the supplied salt and the calling address.
3149     key = _deriveKey(salt, msg.sender);
3150 
3151     // Ensure that a contract is not currently deployed to the home address.
3152     require(_isNotDeployed(key), _ACCOUNT_EXISTS);
3153 
3154     // Set appropriate controller and increment contract deploy count at once.
3155     HomeAddress storage home = _home[key];
3156     if (!home.exists) {
3157       home.exists = true;
3158       home.controller = msg.sender;
3159       home.deploys += 1;
3160 
3161       // Emit an event signifying that this contract is now the controller. 
3162       emit NewController(key, msg.sender);
3163     
3164     } else {
3165       home.deploys += 1;
3166     }
3167 
3168     // Ensure that the caller is the designated controller before proceeding.
3169     require(home.controller == msg.sender, _ONLY_CONTROLLER);
3170   }
3171 
3172   /**
3173    * @notice Internal function for verifying that an owner that cannot accept
3174    * ERC721 tokens has not been supplied.
3175    * @param owner address The specified owner.
3176    * @param key bytes32 The unique value used to derive the home address.
3177    */
3178   function _validateOwner(address owner, bytes32 key) internal {
3179     // Ensure that the specified owner is a valid ERC721 receiver.
3180     require(
3181       _checkOnERC721Received(address(0), owner, uint256(key), bytes("")),
3182       "Owner must be an EOA or a contract that implements `onERC721Received`."
3183     );
3184   }
3185 
3186   /**
3187    * @notice Internal "view" function for determining if a contract currently
3188    * exists at a given home address corresponding to a particular key.
3189    * @param key bytes32 The unique value used to derive the home address.
3190    * @return A boolean signifying whether the home address has a contract
3191    * deployed or not.
3192    */
3193   function _isNotDeployed(bytes32 key)
3194     internal
3195     /* view */
3196     returns (bool notDeployed)
3197   {
3198     // Derive the home address using the supplied key.
3199     address homeAddress = _getHomeAddress(key);
3200 
3201     // Check whether account at home address is non-existent using EXTCODEHASH.
3202     bytes32 hash;
3203     assembly { hash := extcodehash(homeAddress) }
3204 
3205     // Account does not exist, and contract is not deployed, if hash equals 0.
3206     if (hash == bytes32(0)) {
3207       return true;
3208     }
3209 
3210     // Contract is deployed (notDeployed = false) if codesize is greater than 0.
3211     uint256 size;
3212     assembly { size := extcodesize(homeAddress) }
3213     if (size > 0) {
3214       return false;
3215     }
3216 
3217     // Declare variable to move current runtime storage from storage to memory.
3218     address currentStorage;
3219 
3220     // Set runtime storage contract to null address temporarily if necessary.
3221     if (_initializationRuntimeStorageContract != address(0)) {
3222       // Place the current runtime storage contract address in memory.
3223       currentStorage = _initializationRuntimeStorageContract;
3224       
3225       // Remove the existing runtime storage contract address from storage.
3226       delete _initializationRuntimeStorageContract;
3227     }
3228 
3229     // Set gas to use when performing dry-run deployment (future-proof a bit).
3230     uint256 checkGas = 27000 + (block.gaslimit / 1000);
3231     
3232     // As a last resort, deploy a contract to the address and revert on success.
3233     (bool contractExists, bytes memory code) = address(this).call.gas(checkGas)(
3234       abi.encodeWithSelector(this.staticCreate2Check.selector, key)
3235     );
3236 
3237     // Place runtime storage contract back in storage if necessary.
3238     if (currentStorage != address(0)) {
3239       _initializationRuntimeStorageContract = currentStorage;
3240     }
3241 
3242     // Check revert string to ensure failure is due to successful deployment.
3243     bytes32 revertMessage;
3244     assembly { revertMessage := mload(add(code, 32)) }
3245 
3246     // Contract is not deployed if `staticCreate2Check` reverted with message.
3247     notDeployed = !contractExists && revertMessage == _HOME_INIT_CODE;
3248   }
3249 
3250   /**
3251    * @notice Internal view function for verifying that a restricted controller
3252    * has not been supplied.
3253    * @param controller address The specified controller.
3254    * @param key bytes32 The unique value used to derive the home address.
3255    */
3256   function _validateController(address controller, bytes32 key) internal view {
3257     // Prevent the controller from being set to prohibited account values.
3258     require(
3259       controller != address(0),
3260       "The null address may not be set as the controller using this function."
3261     );
3262     require(
3263       controller != address(this),
3264       "This contract may not be set as the controller using this function."
3265     );
3266     require(
3267       controller != _getHomeAddress(key),
3268       "Home addresses cannot be set as the controller of themselves."
3269     );
3270   }
3271 
3272   /**
3273    * @notice Internal view function for verifying that a supplied runtime
3274    * storage contract is not empty.
3275    * @param target address The runtime storage contract.
3276    */
3277   function _validateRuntimeStorageIsNotEmpty(address target) internal view {
3278     // Ensure that the runtime storage contract is not empty.
3279     require(
3280       target.isContract(),
3281       "No runtime code found at the supplied runtime storage address."
3282     );
3283   }
3284 
3285   /**
3286    * @notice Internal view function for retrieving the controller of a home
3287    * address corresponding to a particular key.
3288    * @param key bytes32 The unique value used to derive the home address.
3289    * @return The controller of the home address corresponding to the supplied
3290    * key.
3291    */
3292   function _getController(bytes32 key)
3293     internal
3294     view
3295     returns (address controller)
3296   {
3297     // Get controller from mapping, defaulting to first 20 bytes of the key.
3298     HomeAddress memory home = _home[key];
3299     if (!home.exists) {
3300       controller = address(bytes20(key));
3301     } else {
3302       controller = home.controller;
3303     }
3304   }
3305 
3306   /**
3307    * @notice Internal view function for getting the runtime code at the tokenURI
3308    * data storage address.
3309    * @return The runtime code at the tokenURI storage address.
3310    */
3311   function _getTokenURIStorageRuntime()
3312     internal
3313     view
3314     returns (bytes memory runtime)
3315   {
3316     // Bring the tokenURI storage address into memory for use in assembly block.
3317     address target = _URI_END_SEGMENT_STORAGE;
3318     
3319     assembly {
3320       // Retrieve the size of the external code.
3321       let size := extcodesize(target)
3322       
3323       // Allocate output byte array.
3324       runtime := mload(0x40)
3325       
3326       // Set new "memory end" including padding.
3327       mstore(0x40, add(runtime, and(add(size, 0x3f), not(0x1f))))
3328       
3329       // Store length in memory.
3330       mstore(runtime, size)
3331       
3332       // Get the code using extcodecopy.
3333       extcodecopy(target, add(runtime, 0x20), 0, size)
3334     }
3335   }
3336 
3337   /**
3338    * @notice Internal pure function for calculating a home address given a
3339    * particular key.
3340    * @param key bytes32 The unique value used to derive the home address.
3341    * @return The home address corresponding to the supplied key.
3342    */
3343   function _getHomeAddress(bytes32 key)
3344     internal
3345     pure
3346     returns (address homeAddress)
3347   {
3348     // Determine the home address by replicating CREATE2 logic.
3349     homeAddress = address(
3350       uint160(                       // Downcast to match the address type.
3351         uint256(                     // Cast to uint to truncate upper digits.
3352           keccak256(                 // Compute CREATE2 hash using 4 inputs.
3353             abi.encodePacked(        // Pack all inputs to the hash together.
3354               _FF_AND_THIS_CONTRACT, // This contract will be the caller.
3355               key,                   // Pass in the supplied key as the salt.
3356               _HOME_INIT_CODE_HASH   // The metamorphic init code hash.
3357             )
3358           )
3359         )
3360       )
3361     );
3362   }
3363 
3364   /**
3365    * @notice Internal pure function for deriving a key given a particular salt
3366    * and caller.
3367    * @param salt bytes32 The value used to derive the key.
3368    * @param submitter address The submitter of the salt used to derive the key.
3369    * @return The derived key.
3370    */
3371   function _deriveKey(bytes32 salt, address submitter)
3372     internal
3373     pure
3374     returns (bytes32 key)
3375   {
3376     // Set the key as the keccak256 hash of the salt and submitter.
3377     key = keccak256(abi.encodePacked(salt, submitter));
3378   }
3379 
3380   /**
3381    * @notice Internal pure function for converting the bytes representation of
3382    * an address to an ASCII string. This function is derived from the function
3383    * at https://ethereum.stackexchange.com/a/56499/48410
3384    * @param data bytes20 The account address to be converted.
3385    * @return The account string in ASCII format. Note that leading "0x" is not
3386    * included.
3387    */
3388   function _toAsciiString(bytes20 data)
3389     internal
3390     pure
3391     returns (string memory asciiString)
3392   {
3393     // Create an in-memory fixed-size bytes array.
3394     bytes memory asciiBytes = new bytes(40);
3395 
3396     // Declare variable types.
3397     uint8 oneByte;
3398     uint8 leftNibble;
3399     uint8 rightNibble;
3400 
3401     // Iterate over bytes, processing left and right nibble in each iteration.
3402     for (uint256 i = 0; i < data.length; i++) {
3403       // locate the byte and extract each nibble.
3404       oneByte = uint8(uint160(data) / (2 ** (8 * (19 - i))));
3405       leftNibble = oneByte / 16;
3406       rightNibble = oneByte - 16 * leftNibble;
3407 
3408       // To convert to ascii characters, add 48 to 0-9 and 87 to a-f.
3409       asciiBytes[2 * i] = byte(leftNibble + (leftNibble < 10 ? 48 : 87));
3410       asciiBytes[2 * i + 1] = byte(rightNibble + (rightNibble < 10 ? 48 : 87));
3411     }
3412 
3413     asciiString = string(asciiBytes);
3414   }
3415 
3416   /**
3417    * @notice Internal pure function for getting a fixed-size array of whether or
3418    * not each character in an account will be capitalized in the checksum.
3419    * @param account address The account to get the checksum capitalization
3420    * information for.
3421    * @return A fixed-size array of booleans that signify if each character or
3422    * "nibble" of the hex encoding of the address will be capitalized by the
3423    * checksum.
3424    */
3425   function _getChecksumCapitalizedCharacters(address account)
3426     internal
3427     pure
3428     returns (bool[40] memory characterIsCapitalized)
3429   {
3430     // Convert the address to bytes.
3431     bytes20 addressBytes = bytes20(account);
3432 
3433     // Hash the address (used to calculate checksum).
3434     bytes32 hash = keccak256(abi.encodePacked(_toAsciiString(addressBytes)));
3435 
3436     // Declare variable types.
3437     uint8 leftNibbleAddress;
3438     uint8 rightNibbleAddress;
3439     uint8 leftNibbleHash;
3440     uint8 rightNibbleHash;
3441 
3442     // Iterate over bytes, processing left and right nibble in each iteration.
3443     for (uint256 i; i < addressBytes.length; i++) {
3444       // locate the byte and extract each nibble for the address and the hash.
3445       rightNibbleAddress = uint8(addressBytes[i]) % 16;
3446       leftNibbleAddress = (uint8(addressBytes[i]) - rightNibbleAddress) / 16;
3447       rightNibbleHash = uint8(hash[i]) % 16;
3448       leftNibbleHash = (uint8(hash[i]) - rightNibbleHash) / 16;
3449 
3450       // Set the capitalization flags based on the characters and the checksums.
3451       characterIsCapitalized[2 * i] = (
3452         leftNibbleAddress > 9 &&
3453         leftNibbleHash > 7
3454       );
3455       characterIsCapitalized[2 * i + 1] = (
3456         rightNibbleAddress > 9 &&
3457         rightNibbleHash > 7
3458       );
3459     }
3460   }
3461 
3462   /**
3463    * @notice Internal pure function for converting the bytes representation of
3464    * an address to a checksummed ASCII string.
3465    * @param account address The account address to be converted.
3466    * @return The checksummed account string in ASCII format. Note that leading
3467    * "0x" is not included.
3468    */
3469   function _toChecksummedAsciiString(address account)
3470     internal
3471     pure
3472     returns (string memory checksummedAsciiString)
3473   {
3474     // Get capitalized characters in the checksum.
3475     bool[40] memory caps = _getChecksumCapitalizedCharacters(account);
3476 
3477     // Create an in-memory fixed-size bytes array.
3478     bytes memory asciiBytes = new bytes(40);
3479 
3480     // Declare variable types.
3481     uint8 oneByte;
3482     uint8 leftNibble;
3483     uint8 rightNibble;
3484     uint8 leftNibbleOffset;
3485     uint8 rightNibbleOffset;
3486 
3487     // Convert account to bytes20.
3488     bytes20 data = bytes20(account);
3489 
3490     // Iterate over bytes, processing left and right nibble in each iteration.
3491     for (uint256 i = 0; i < data.length; i++) {
3492       // locate the byte and extract each nibble.
3493       oneByte = uint8(uint160(data) / (2 ** (8 * (19 - i))));
3494       leftNibble = oneByte / 16;
3495       rightNibble = oneByte - 16 * leftNibble;
3496 
3497       // To convert to ascii characters, add 48 to 0-9, 55 to A-F, & 87 to a-f.
3498       if (leftNibble < 10) {
3499         leftNibbleOffset = 48;
3500       } else if (caps[i * 2]) {
3501         leftNibbleOffset = 55;
3502       } else {
3503         leftNibbleOffset = 87;
3504       }
3505 
3506       if (rightNibble < 10) {
3507         rightNibbleOffset = 48;
3508       } else {
3509         rightNibbleOffset = caps[(i * 2) + 1] ? 55 : 87; // instrumentation fix
3510       }
3511 
3512       asciiBytes[2 * i] = byte(leftNibble + leftNibbleOffset);
3513       asciiBytes[2 * i + 1] = byte(rightNibble + rightNibbleOffset);
3514     }
3515 
3516     checksummedAsciiString = string(asciiBytes);
3517   }
3518 
3519   /**
3520    * @notice Modifier to ensure that a contract is not currently deployed to the
3521    * home address corresponding to a given key on the decorated function.
3522    * @param key bytes32 The unique value used to derive the home address.
3523    */
3524   modifier onlyEmpty(bytes32 key) {
3525     require(_isNotDeployed(key), _ACCOUNT_EXISTS);
3526     _;
3527   }
3528 
3529   /**
3530    * @notice Modifier to ensure that the caller of the decorated function is the
3531    * controller of the home address corresponding to a given key.
3532    * @param key bytes32 The unique value used to derive the home address.
3533    */
3534   modifier onlyController(bytes32 key) {
3535     require(_getController(key) == msg.sender, _ONLY_CONTROLLER);
3536     _;
3537   }
3538 
3539   /**
3540    * @notice Modifier to track initial controllers and to count deploys, and to
3541    * validate that only the designated controller has access to the decorated
3542    * function.
3543    * @param key bytes32 The unique value used to derive the home address.
3544    */
3545   modifier onlyControllerDeployer(bytes32 key) {
3546     HomeAddress storage home = _home[key];
3547 
3548     // Set appropriate controller and increment contract deploy count at once.
3549     if (!home.exists) {
3550       home.exists = true;
3551       home.controller = address(bytes20(key));
3552       home.deploys += 1;
3553     } else {
3554       home.deploys += 1;
3555     }
3556 
3557     require(home.controller == msg.sender, _ONLY_CONTROLLER);
3558     _;
3559   }
3560 
3561   /**
3562    * @notice Modifier to ensure that only the owner of the supplied ERC721
3563    * token, or an approved spender, can access the decorated function.
3564    * @param tokenId uint256 The ID of the ERC721 token.
3565    */
3566   modifier onlyTokenOwnerOrApprovedSpender(uint256 tokenId) {
3567     require(
3568       _isApprovedOrOwner(msg.sender, tokenId),
3569       "Only the token owner or an approved spender may call this function."
3570     );
3571     _;
3572   }
3573 }
3574 
3575 /**
3576  * @title HomeWork Deployer (alpha version)
3577  * @author 0age
3578  * @notice This contract is a stripped-down version of HomeWork that is used to
3579  * deploy HomeWork itself.
3580  *   HomeWork Deploy code at runtime: 0x7Cf7708ab4A064B14B02F34aecBd2511f3605395
3581  *   HomeWork Runtime code at:        0x0000000000001b84b1cb32787b0d64758d019317
3582  */
3583 contract HomeWorkDeployer {
3584   // Fires when HomeWork has been deployed.
3585   event HomeWorkDeployment(address homeAddress, bytes32 key);
3586 
3587   // Fires HomeWork's initialization-in-runtime storage contract is deployed.
3588   event StorageContractDeployment(address runtimeStorageContract);
3589 
3590   // Allocate storage to track the current initialization-in-runtime contract.
3591   address private _initializationRuntimeStorageContract;
3592 
3593   // Once HomeWork has been deployed, disable this contract.
3594   bool private _disabled;
3595 
3596   // Write arbitrary code to a contract's runtime using the following prelude.
3597   bytes11 private constant _ARBITRARY_RUNTIME_PRELUDE = bytes11(
3598     0x600b5981380380925939f3
3599   );
3600 
3601   /**
3602    * @notice Perform phase one of the deployment.
3603    * @param code bytes The contract creation code for HomeWork.
3604    */
3605   function phaseOne(bytes calldata code) external onlyUntilDisabled {
3606     // Deploy payload to the runtime storage contract and set the address.
3607     _initializationRuntimeStorageContract = _deployRuntimeStorageContract(
3608       bytes32(0),
3609       code
3610     );
3611   }
3612 
3613   /**
3614    * @notice Perform phase two of the deployment (tokenURI data).
3615    * @param key bytes32 The salt to provide to create2.
3616    */
3617   function phaseTwo(bytes32 key) external onlyUntilDisabled {
3618     // Deploy runtime storage contract with the string used to construct end of
3619     // token URI for issued ERC721s (data URI with a base64-encoded jpeg image).    
3620     bytes memory code = abi.encodePacked(
3621       hex"222c226465736372697074696f6e223a22546869732532304e465425323063616e25",
3622       hex"3230626525323072656465656d65642532306f6e253230486f6d65576f726b253230",
3623       hex"746f2532306772616e7425323061253230636f6e74726f6c6c657225323074686525",
3624       hex"32306578636c75736976652532307269676874253230746f2532306465706c6f7925",
3625       hex"3230636f6e7472616374732532307769746825323061726269747261727925323062",
3626       hex"797465636f6465253230746f25323074686525323064657369676e61746564253230",
3627       hex"686f6d65253230616464726573732e222c22696d616765223a22646174613a696d61",
3628       hex"67652f7376672b786d6c3b636861727365743d7574662d383b6261736536342c5048",
3629       hex"4e325a79423462577875637a30696148523063446f764c336433647935334d793576",
3630       hex"636d63764d6a41774d43397a646d636949485a705a58644362336739496a41674d43",
3631       hex"41784e4451674e7a4969506a787a64486c735a543438495674445245465551567375",
3632       hex"516e747a64484a766132557462476c755a57707661573436636d3931626d52394c6b",
3633       hex"4e37633352796232746c4c5731706447567962476c74615851364d5442394c6b5237",
3634       hex"633352796232746c4c5864705a48526f4f6a4a394c6b56375a6d6c7362446f6a4f57",
3635       hex"4935596a6c686653354765334e30636d39725a5331736157356c593246774f6e4a76",
3636       hex"6457356b66563164506a7776633352356247552b5047636764484a68626e4e6d6233",
3637       hex"4a7450534a74595852796158676f4d5334774d694177494441674d5334774d694134",
3638       hex"4c6a45674d436b69506a78775958526f49475a706247773949694e6d5a6d59694947",
3639       hex"5139496b30784f53417a4d6d677a4e4859794e4567784f586f694c7a34385a79427a",
3640       hex"64484a766132553949694d774d44416949474e7359584e7a50534a4349454d675243",
3641       hex"492b50484268644767675a6d6c7362443069493245314e7a6b7a4f5349675a443069",
3642       hex"545449314944517761446c324d545a6f4c546c364969382b50484268644767675a6d",
3643       hex"6c7362443069497a6b795a444e6d4e5349675a443069545451774944517761446832",
3644       hex"4e3267744f486f694c7a3438634746306143426d615778735053496a5a5745315954",
3645       hex"51334969426b50534a4e4e544d674d7a4a494d546c324c5446734d5459744d545967",
3646       hex"4d5467674d545a364969382b50484268644767675a6d6c7362443069626d39755a53",
3647       hex"49675a4430695454453549444d7961444d30646a49305344453565694976506a7877",
3648       hex"5958526f49475a706247773949694e6c595456684e44636949475139496b30794f53",
3649       hex"41794d5777744e53413164693035614456364969382b5043396e506a77765a7a3438",
3650       hex"5a794230636d467563325a76636d3039496d316864484a70654367754f4451674d43",
3651       hex"4177494334344e4341324e5341314b53492b50484268644767675a44306954546b75",
3652       hex"4e5341794d693435624451754f4341324c6a52684d7934784d69417a4c6a45794944",
3653       hex"41674d4341784c544d674d693479624330304c6a67744e6934305979347a4c544575",
3654       hex"4e4341784c6a59744d69343049444d744d693479656949675a6d6c73624430694932",
3655       hex"517759325a6a5a534976506a78775958526f49475a706247773949694d774d544178",
3656       hex"4d44456949475139496b30304d53343349444d344c6a56734e5334784c5459754e53",
3657       hex"4976506a78775958526f49475139496b30304d693435494449334c6a684d4d546775",
3658       hex"4e4341314f4334784944493049445979624449784c6a67744d6a63754d7941794c6a",
3659       hex"4d744d693434656949675932786863334d39496b55694c7a3438634746306143426d",
3660       hex"615778735053496a4d4445774d5441784969426b50534a4e4e444d754e4341794f53",
3661       hex"347a624330304c6a63674e5334344969382b50484268644767675a44306954545132",
3662       hex"4c6a67674d7a4a6a4d793479494449754e6941344c6a63674d533479494445794c6a",
3663       hex"45744d793479637a4d754e6930354c6a6b754d7930784d693431624330314c6a4567",
3664       hex"4e6934314c5449754f4330754d5330754e7930794c6a63674e5334784c5459754e57",
3665       hex"4d744d7934794c5449754e6930344c6a63744d5334794c5445794c6a45674d793479",
3666       hex"6379307a4c6a59674f5334354c53347a494445794c6a556949474e7359584e7a5053",
3667       hex"4a464969382b50484268644767675a6d6c7362443069493245314e7a6b7a4f534967",
3668       hex"5a443069545449334c6a4d674d6a5a734d5445754f4341784e53343349444d754e43",
3669       hex"41794c6a51674f533478494445304c6a51744d793479494449754d79307849433433",
3670       hex"4c5445774c6a49744d544d754e6930784c6a4d744d7934354c5445784c6a67744d54",
3671       hex"55754e336f694c7a3438634746306143426b50534a4e4d5449674d546b754f577731",
3672       hex"4c6a6b674e793435494445774c6a49744e7934324c544d754e4330304c6a567a4e69",
3673       hex"34344c5455754d5341784d4334334c5451754e574d77494441744e6934324c544d74",
3674       hex"4d544d754d7941784c6a46544d5449674d546b754f5341784d6941784f5334356569",
3675       hex"49675932786863334d39496b55694c7a34385a79426d6157787350534a756232356c",
3676       hex"4969427a64484a766132553949694d774d44416949474e7359584e7a50534a434945",
3677       hex"4d675243492b50484268644767675a44306954545579494455344c6a6c4d4e444175",
3678       hex"4f5341304d7934796243307a4c6a45744d69347a4c5445774c6a59744d5451754e79",
3679       hex"30794c6a6b674d693479494445774c6a59674d5451754e7941784c6a45674d793432",
3680       hex"494445784c6a55674d5455754e58704e4d5449754e5341784f533434624455754f43",
3681       hex"4134494445774c6a4d744e7934304c544d754d7930304c6a5a7a4e6934354c545567",
3682       hex"4d5441754f4330304c6a4e6a4d4341774c5459754e69307a4c6a45744d544d754d79",
3683       hex"3435637930784d43347a494463754e4330784d43347a494463754e4870744c544975",
3684       hex"4e6941794c6a6c734e433433494459754e574d744c6a55674d53347a4c5445754e79",
3685       hex"41794c6a45744d7941794c6a4a734c5451754e7930324c6a566a4c6a4d744d533430",
3686       hex"494445754e6930794c6a51674d7930794c6a4a364969382b50484268644767675a44",
3687       hex"3069545451784c6a4d674d7a67754e5777314c6a45744e6934316253307a4c6a5574",
3688       hex"4d693433624330304c6a59674e533434625467754d53307a4c6a466a4d7934794944",
3689       hex"49754e6941344c6a63674d533479494445794c6a45744d793479637a4d754e693035",
3690       hex"4c6a6b754d7930784d693431624330314c6a45674e6934314c5449754f4330754d53",
3691       hex"30754f4330794c6a63674e5334784c5459754e574d744d7934794c5449754e693034",
3692       hex"4c6a63744d5334794c5445794c6a45674d7934794c544d754e4341304c6a4d744d79",
3693       hex"343249446b754f5330754d7941784d6934314969426a6247467a637a306952694976",
3694       hex"506a78775958526f49475139496b307a4d433434494451304c6a524d4d546b674e54",
3695       hex"67754f57773049444d674d5441744d5449754e7949675932786863334d39496b5969",
3696       hex"4c7a34384c32632b5043396e506a777663335a6e50673d3d227d"
3697     ); /* ","description":"This%20NFT%20can%20be%20redeemed%20on%20HomeWork%20
3698           to%20grant%20a%20controller%20the%20exclusive%20right%20to%20deploy%20
3699           contracts%20with%20arbitrary%20bytecode%20to%20the%20designated%20home
3700           %20address.","image":"data:image/svg+xml;charset=utf-8;base64,..."} */
3701 
3702     // Deploy payload to the runtime storage contract.
3703     _deployRuntimeStorageContract(key, code);
3704   }
3705 
3706   /**
3707    * @notice Perform phase three of the deployment and disable this contract.
3708    * @param key bytes32 The salt to provide to create2.
3709    */
3710   function phaseThree(bytes32 key) external onlyUntilDisabled {
3711     // Use metamorphic initialization code to deploy contract to home address.
3712     _deployToHomeAddress(key);
3713 
3714     // Disable this contract from here on out - use HomeWork itself instead.
3715     _disabled = true;
3716   }
3717 
3718   /**
3719    * @notice View function used by the metamorphic initialization code when
3720    * deploying a contract to a home address. It returns the address of the
3721    * runtime storage contract that holds the contract creation code, which the
3722    * metamorphic creation code then `DELEGATECALL`s into in order to set up the
3723    * contract and deploy the target runtime code.
3724    * @return The current runtime storage contract that contains the target
3725    * contract creation code.
3726    * @dev This method is not meant to be part of the user-facing contract API,
3727    * but is rather a mechanism for enabling the deployment of arbitrary code via
3728    * fixed initialization code. The odd naming is chosen so that function
3729    * selector will be 0x00000009 - that way, the metamorphic contract can simply
3730    * use the `PC` opcode in order to push the selector to the stack.
3731    */
3732   function getInitializationCodeFromContractRuntime_6CLUNS()
3733     external
3734     view
3735     returns (address initializationRuntimeStorageContract)
3736   {
3737     // Return address of contract with initialization code set as runtime code.
3738     initializationRuntimeStorageContract = _initializationRuntimeStorageContract;
3739   }
3740 
3741   /**
3742    * @notice Internal function for deploying a runtime storage contract given a
3743    * particular payload.
3744    * @dev To take the provided code payload and deploy a contract with that
3745    * payload as its runtime code, use the following prelude:
3746    *
3747    * 0x600b5981380380925939f3...
3748    *
3749    * 00  60  push1 0b      [11 -> offset]
3750    * 02  59  msize         [offset, 0]
3751    * 03  81  dup2          [offset, 0, offset]
3752    * 04  38  codesize      [offset, 0, offset, codesize]
3753    * 05  03  sub           [offset, 0, codesize - offset]
3754    * 06  80  dup1          [offset, 0, codesize - offset, codesize - offset]
3755    * 07  92  swap3         [codesize - offset, 0, codesize - offset, offset]
3756    * 08  59  msize         [codesize - offset, 0, codesize - offset, offset, 0]
3757    * 09  39  codecopy      [codesize - offset, 0] <init_code_in_runtime>
3758    * 10  f3  return        [] *init_code_in_runtime*
3759    * ... init_code
3760    */
3761   function _deployRuntimeStorageContract(bytes32 key, bytes memory payload)
3762     internal
3763     returns (address runtimeStorageContract)
3764   {
3765     // Construct the contract creation code using the prelude and the payload.
3766     bytes memory runtimeStorageContractCreationCode = abi.encodePacked(
3767       _ARBITRARY_RUNTIME_PRELUDE,
3768       payload
3769     );
3770 
3771     assembly {
3772       // Get the location and length of the newly-constructed creation code.
3773       let encoded_data := add(0x20, runtimeStorageContractCreationCode)
3774       let encoded_size := mload(runtimeStorageContractCreationCode)
3775 
3776       // Deploy the runtime storage contract via `CREATE2`.
3777       runtimeStorageContract := create2(0, encoded_data, encoded_size, key)
3778 
3779       // Pass along revert message if the contract did not deploy successfully.
3780       if iszero(runtimeStorageContract) {
3781         returndatacopy(0, 0, returndatasize)
3782         revert(0, returndatasize)
3783       }
3784     }
3785 
3786     // Emit an event with address of newly-deployed runtime storage contract.
3787     emit StorageContractDeployment(runtimeStorageContract);
3788   }
3789 
3790   /**
3791    * @notice Internal function for deploying arbitrary contract code to the home
3792    * address corresponding to a suppied key via metamorphic initialization code.
3793    * @dev This deployment method uses the "metamorphic delegator" pattern, where
3794    * it will retrieve the address of the contract that contains the target
3795    * initialization code, then delegatecall into it, which executes the
3796    * initialization code stored there and returns the runtime code (or reverts).
3797    * Then, the runtime code returned by the delegatecall is returned, and since
3798    * we are still in the initialization context, it will be set as the runtime
3799    * code of the metamorphic contract. The 32-byte metamorphic initialization
3800    * code is as follows:
3801    *
3802    * 0x5859385958601c335a585952fa1582838382515af43d3d93833e601e57fd5bf3
3803    *
3804    * 00  58  PC               [0]
3805    * 01  59  MSIZE            [0, 0]
3806    * 02  38  CODESIZE         [0, 0, codesize -> 32]
3807    * returndatac03  59  MSIZE            [0, 0, 32, 0]
3808    * 04  58  PC               [0, 0, 32, 0, 4]
3809    * 05  60  PUSH1 0x1c       [0, 0, 32, 0, 4, 28]
3810    * 07  33  CALLER           [0, 0, 32, 0, 4, 28, caller]
3811    * 08  5a  GAS              [0, 0, 32, 0, 4, 28, caller, gas]
3812    * 09  58  PC               [0, 0, 32, 0, 4, 28, caller, gas, 9 -> selector]
3813    * 10  59  MSIZE            [0, 0, 32, 0, 4, 28, caller, gas, selector, 0]
3814    * 11  52  MSTORE           [0, 0, 32, 0, 4, 28, caller, gas] <selector>
3815    * 12  fa  STATICCALL       [0, 0, 1 => success] <init_in_runtime_address>
3816    * 13  15  ISZERO           [0, 0, 0]
3817    * 14  82  DUP3             [0, 0, 0, 0]
3818    * 15  83  DUP4             [0, 0, 0, 0, 0]
3819    * 16  83  DUP4             [0, 0, 0, 0, 0, 0]
3820    * 17  82  DUP3             [0, 0, 0, 0, 0, 0, 0]
3821    * 18  51  MLOAD            [0, 0, 0, 0, 0, 0, init_in_runtime_address]
3822    * 19  5a  GAS              [0, 0, 0, 0, 0, 0, init_in_runtime_address, gas]
3823    * 20  f4  DELEGATECALL     [0, 0, 1 => success] {runtime_code}
3824    * 21  3d  RETURNDATASIZE   [0, 0, 1 => success, size]
3825    * 22  3d  RETURNDATASIZE   [0, 0, 1 => success, size, size]
3826    * 23  93  SWAP4            [size, 0, 1 => success, size, 0]
3827    * 24  83  DUP4             [size, 0, 1 => success, size, 0, 0]
3828    * 25  3e  RETURNDATACOPY   [size, 0, 1 => success] <runtime_code>
3829    * 26  60  PUSH1 0x1e       [size, 0, 1 => success, 30]
3830    * 28  57  JUMPI            [size, 0]
3831    * 29  fd  REVERT           [] *runtime_code*
3832    * 30  5b  JUMPDEST         [size, 0]
3833    * 31  f3  RETURN           []
3834    */
3835   function _deployToHomeAddress(bytes32 key) internal {
3836     // Declare a variable for the home address.
3837     address homeAddress;
3838 
3839     assembly {
3840       // Write the 32-byte metamorphic initialization code to scratch space.
3841       mstore(
3842         0,
3843         0x5859385958601c335a585952fa1582838382515af43d3d93833e601e57fd5bf3
3844       )
3845 
3846       // Call `CREATE2` using above init code with the supplied key as the salt.
3847       homeAddress := create2(callvalue, 0, 32, key)
3848 
3849       // Pass along revert message if the contract did not deploy successfully.
3850       if iszero(homeAddress) {
3851         returndatacopy(0, 0, returndatasize)
3852         revert(0, returndatasize)
3853       }
3854     }
3855 
3856     // Clear the address of the runtime storage contract from storage.
3857     delete _initializationRuntimeStorageContract;
3858 
3859     // Emit an event with home address and key for the newly-deployed contract.
3860     emit HomeWorkDeployment(homeAddress, key);
3861   }
3862 
3863   /**
3864    * @notice Modifier to disable the contract once deployment is complete.
3865    */
3866   modifier onlyUntilDisabled() {
3867     require(!_disabled, "Contract is disabled.");
3868     _;
3869   }
3870 }