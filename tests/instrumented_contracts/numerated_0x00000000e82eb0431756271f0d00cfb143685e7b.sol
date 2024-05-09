1 pragma solidity 0.5.6;
2 
3 
4 /**
5  * @title Metamorphic Contract Factory
6  * @author 0age
7  * @notice This contract creates metamorphic contracts, or contracts that can be
8  * redeployed with new code to the same address. It does so by deploying a
9  * contract with fixed, non-deterministic initialization code via the CREATE2
10  * opcode. This contract clones the implementation contract in its constructor.
11  * Once a contract undergoes metamorphosis, all existing storage will be deleted
12  * and any existing contract code will be replaced with the deployed contract
13  * code of the new implementation contract.
14  * @dev CREATE2 will not be available on mainnet until (at least) block
15  * 7,280,000. This contract has not yet been fully tested or audited - proceed
16  * with caution and please share any exploits or optimizations you discover.
17  */
18 contract MetamorphicContractFactory {
19   // fires when a metamorphic contract is deployed by cloning another contract.
20   event Metamorphosed(address metamorphicContract, address newImplementation);
21   
22   // fires when a metamorphic contract is deployed through a transient contract.
23   event MetamorphosedWithConstructor(
24     address metamorphicContract,
25     address transientContract
26   );
27 
28   // store the initialization code for metamorphic contracts.
29   bytes private _metamorphicContractInitializationCode;
30 
31   // store hash of the initialization code for metamorphic contracts as well.
32   bytes32 private _metamorphicContractInitializationCodeHash;
33 
34   // store init code for transient contracts that deploy metamorphic contracts.
35   bytes private _transientContractInitializationCode;
36 
37   // store the hash of the initialization code for transient contracts as well.
38   bytes32 private _transientContractInitializationCodeHash;
39 
40   // maintain a mapping of metamorphic contracts to metamorphic implementations.
41   mapping(address => address) private _implementations;
42 
43   // maintain a mapping of transient contracts to metamorphic init codes.
44   mapping(address => bytes) private _initCodes;
45 
46   /**
47    * @dev In the constructor, set up the initialization code for metamorphic
48    * contracts as well as the keccak256 hash of the given initialization code.
49    * @param transientContractInitializationCode bytes The initialization code
50    * that will be used to deploy any transient contracts, which will deploy any
51    * metamorphic contracts that require the use of a constructor.
52    * 
53    * Metamorphic contract initialization code (29 bytes): 
54    *
55    *       0x5860208158601c335a63aaf10f428752fa158151803b80938091923cf3
56    *
57    * Description:
58    *
59    * pc|op|name         | [stack]                                | <memory>
60    *
61    * ** set the first stack item to zero - used later **
62    * 00 58 getpc          [0]                                       <>
63    *
64    * ** set second stack item to 32, length of word returned from staticcall **
65    * 01 60 push1
66    * 02 20 outsize        [0, 32]                                   <>
67    *
68    * ** set third stack item to 0, position of word returned from staticcall **
69    * 03 81 dup2           [0, 32, 0]                                <>
70    *
71    * ** set fourth stack item to 4, length of selector given to staticcall **
72    * 04 58 getpc          [0, 32, 0, 4]                             <>
73    *
74    * ** set fifth stack item to 28, position of selector given to staticcall **
75    * 05 60 push1
76    * 06 1c inpos          [0, 32, 0, 4, 28]                         <>
77    *
78    * ** set the sixth stack item to msg.sender, target address for staticcall **
79    * 07 33 caller         [0, 32, 0, 4, 28, caller]                 <>
80    *
81    * ** set the seventh stack item to msg.gas, gas to forward for staticcall **
82    * 08 5a gas            [0, 32, 0, 4, 28, caller, gas]            <>
83    *
84    * ** set the eighth stack item to selector, "what" to store via mstore **
85    * 09 63 push4
86    * 10 aaf10f42 selector [0, 32, 0, 4, 28, caller, gas, 0xaaf10f42]    <>
87    *
88    * ** set the ninth stack item to 0, "where" to store via mstore ***
89    * 11 87 dup8           [0, 32, 0, 4, 28, caller, gas, 0xaaf10f42, 0] <>
90    *
91    * ** call mstore, consume 8 and 9 from the stack, place selector in memory **
92    * 12 52 mstore         [0, 32, 0, 4, 0, caller, gas]             <0xaaf10f42>
93    *
94    * ** call staticcall, consume items 2 through 7, place address in memory **
95    * 13 fa staticcall     [0, 1 (if successful)]                    <address>
96    *
97    * ** flip success bit in second stack item to set to 0 **
98    * 14 15 iszero         [0, 0]                                    <address>
99    *
100    * ** push a third 0 to the stack, position of address in memory **
101    * 15 81 dup2           [0, 0, 0]                                 <address>
102    *
103    * ** place address from position in memory onto third stack item **
104    * 16 51 mload          [0, 0, address]                           <>
105    *
106    * ** place address to fourth stack item for extcodesize to consume **
107    * 17 80 dup1           [0, 0, address, address]                  <>
108    *
109    * ** get extcodesize on fourth stack item for extcodecopy **
110    * 18 3b extcodesize    [0, 0, address, size]                     <>
111    *
112    * ** dup and swap size for use by return at end of init code **
113    * 19 80 dup1           [0, 0, address, size, size]               <> 
114    * 20 93 swap4          [size, 0, address, size, 0]               <>
115    *
116    * ** push code position 0 to stack and reorder stack items for extcodecopy **
117    * 21 80 dup1           [size, 0, address, size, 0, 0]            <>
118    * 22 91 swap2          [size, 0, address, 0, 0, size]            <>
119    * 23 92 swap3          [size, 0, size, 0, 0, address]            <>
120    *
121    * ** call extcodecopy, consume four items, clone runtime code to memory **
122    * 24 3c extcodecopy    [size, 0]                                 <code>
123    *
124    * ** return to deploy final code in memory **
125    * 25 f3 return         []                                        *deployed!*
126    *
127    *
128    * Transient contract initialization code derived from TransientContract.sol.
129    */
130   constructor(bytes memory transientContractInitializationCode) public {
131     // assign the initialization code for the metamorphic contract.
132     _metamorphicContractInitializationCode = (
133       hex"5860208158601c335a63aaf10f428752fa158151803b80938091923cf3"
134     );
135 
136     // calculate and assign keccak256 hash of metamorphic initialization code.
137     _metamorphicContractInitializationCodeHash = keccak256(
138       abi.encodePacked(
139         _metamorphicContractInitializationCode
140       )
141     );
142 
143     // store the initialization code for the transient contract.
144     _transientContractInitializationCode = transientContractInitializationCode;
145 
146     // calculate and assign keccak256 hash of transient initialization code.
147     _transientContractInitializationCodeHash = keccak256(
148       abi.encodePacked(
149         _transientContractInitializationCode
150       )
151     );
152   }
153 
154   /* solhint-disable function-max-lines */
155   /**
156    * @dev Deploy a metamorphic contract by submitting a given salt or nonce
157    * along with the initialization code for the metamorphic contract, and
158    * optionally provide calldata for initializing the new metamorphic contract.
159    * To replace the contract, first selfdestruct the current contract, then call
160    * with the same salt value and new initialization code (be aware that all
161    * existing state will be wiped from the existing contract). Also note that
162    * the first 20 bytes of the salt must match the calling address, which
163    * prevents contracts from being created by unintended parties.
164    * @param salt bytes32 The nonce that will be passed into the CREATE2 call and
165    * thus will determine the resulant address of the metamorphic contract.
166    * @param implementationContractInitializationCode bytes The initialization
167    * code for the implementation contract for the metamorphic contract. It will
168    * be used to deploy a new contract that the metamorphic contract will then
169    * clone in its constructor.
170    * @param metamorphicContractInitializationCalldata bytes An optional data
171    * parameter that can be used to atomically initialize the metamorphic
172    * contract.
173    * @return Address of the metamorphic contract that will be created.
174    */
175   function deployMetamorphicContract(
176     bytes32 salt,
177     bytes calldata implementationContractInitializationCode,
178     bytes calldata metamorphicContractInitializationCalldata
179   ) external payable containsCaller(salt) returns (
180     address metamorphicContractAddress
181   ) {
182     // move implementation init code and initialization calldata to memory.
183     bytes memory implInitCode = implementationContractInitializationCode;
184     bytes memory data = metamorphicContractInitializationCalldata;
185 
186     // move the initialization code from storage to memory.
187     bytes memory initCode = _metamorphicContractInitializationCode;
188 
189     // declare variable to verify successful metamorphic contract deployment.
190     address deployedMetamorphicContract;
191 
192     // determine the address of the metamorphic contract.
193     metamorphicContractAddress = _getMetamorphicContractAddress(salt);
194 
195     // declare a variable for the address of the implementation contract.
196     address implementationContract;
197 
198     // load implementation init code and length, then deploy via CREATE.
199     /* solhint-disable no-inline-assembly */
200     assembly {
201       let encoded_data := add(0x20, implInitCode) // load initialization code.
202       let encoded_size := mload(implInitCode)     // load init code's length.
203       implementationContract := create(       // call CREATE with 3 arguments.
204         0,                                    // do not forward any endowment.
205         encoded_data,                         // pass in initialization code.
206         encoded_size                          // pass in init code's length.
207       )
208     } /* solhint-enable no-inline-assembly */
209 
210     require(
211       implementationContract != address(0),
212       "Could not deploy implementation."
213     );
214 
215     // store the implementation to be retrieved by the metamorphic contract.
216     _implementations[metamorphicContractAddress] = implementationContract;
217 
218     // load metamorphic contract data and length of data and deploy via CREATE2.
219     /* solhint-disable no-inline-assembly */
220     assembly {
221       let encoded_data := add(0x20, initCode) // load initialization code.
222       let encoded_size := mload(initCode)     // load the init code's length.
223       deployedMetamorphicContract := create2( // call CREATE2 with 4 arguments.
224         0,                                    // do not forward any endowment.
225         encoded_data,                         // pass in initialization code.
226         encoded_size,                         // pass in init code's length.
227         salt                                  // pass in the salt value.
228       )
229     } /* solhint-enable no-inline-assembly */
230 
231     // ensure that the contracts were successfully deployed.
232     require(
233       deployedMetamorphicContract == metamorphicContractAddress,
234       "Failed to deploy the new metamorphic contract."
235     );
236 
237     // initialize the new metamorphic contract if any data or value is provided.
238     if (data.length > 0 || msg.value > 0) {
239       /* solhint-disable avoid-call-value */
240       (bool success,) = deployedMetamorphicContract.call.value(msg.value)(data);
241       /* solhint-enable avoid-call-value */
242 
243       require(success, "Failed to initialize the new metamorphic contract.");
244     }
245 
246     emit Metamorphosed(deployedMetamorphicContract, implementationContract);
247   } /* solhint-enable function-max-lines */
248 
249   /**
250    * @dev Deploy a metamorphic contract by submitting a given salt or nonce
251    * along with the address of an existing implementation contract to clone, and
252    * optionally provide calldata for initializing the new metamorphic contract.
253    * To replace the contract, first selfdestruct the current contract, then call
254    * with the same salt value and a new implementation address (be aware that
255    * all existing state will be wiped from the existing contract). Also note
256    * that the first 20 bytes of the salt must match the calling address, which
257    * prevents contracts from being created by unintended parties.
258    * @param salt bytes32 The nonce that will be passed into the CREATE2 call and
259    * thus will determine the resulant address of the metamorphic contract.
260    * @param implementationContract address The address of the existing
261    * implementation contract to clone.
262    * @param metamorphicContractInitializationCalldata bytes An optional data
263    * parameter that can be used to atomically initialize the metamorphic
264    * contract.
265    * @return Address of the metamorphic contract that will be created.
266    */
267   function deployMetamorphicContractFromExistingImplementation(
268     bytes32 salt,
269     address implementationContract,
270     bytes calldata metamorphicContractInitializationCalldata
271   ) external payable containsCaller(salt) returns (
272     address metamorphicContractAddress
273   ) {
274     // move initialization calldata to memory.
275     bytes memory data = metamorphicContractInitializationCalldata;
276 
277     // move the initialization code from storage to memory.
278     bytes memory initCode = _metamorphicContractInitializationCode;
279 
280     // declare variable to verify successful metamorphic contract deployment.
281     address deployedMetamorphicContract;
282 
283     // determine the address of the metamorphic contract.
284     metamorphicContractAddress = _getMetamorphicContractAddress(salt);
285 
286     // store the implementation to be retrieved by the metamorphic contract.
287     _implementations[metamorphicContractAddress] = implementationContract;
288 
289     // using inline assembly: load data and length of data, then call CREATE2.
290     /* solhint-disable no-inline-assembly */
291     assembly {
292       let encoded_data := add(0x20, initCode) // load initialization code.
293       let encoded_size := mload(initCode)     // load the init code's length.
294       deployedMetamorphicContract := create2( // call CREATE2 with 4 arguments.
295         0,                                    // do not forward any endowment.
296         encoded_data,                         // pass in initialization code.
297         encoded_size,                         // pass in init code's length.
298         salt                                  // pass in the salt value.
299       )
300     } /* solhint-enable no-inline-assembly */
301 
302     // ensure that the contracts were successfully deployed.
303     require(
304       deployedMetamorphicContract == metamorphicContractAddress,
305       "Failed to deploy the new metamorphic contract."
306     );
307 
308     // initialize the new metamorphic contract if any data or value is provided.
309     if (data.length > 0 || msg.value > 0) {
310       /* solhint-disable avoid-call-value */
311       (bool success,) = metamorphicContractAddress.call.value(msg.value)(data);
312       /* solhint-enable avoid-call-value */
313 
314       require(success, "Failed to initialize the new metamorphic contract.");
315     }
316 
317     emit Metamorphosed(deployedMetamorphicContract, implementationContract);
318   }
319 
320   /* solhint-disable function-max-lines */
321   /**
322    * @dev Deploy a metamorphic contract by submitting a given salt or nonce
323    * along with the initialization code to a transient contract which will then
324    * deploy the metamorphic contract before immediately selfdestructing. To
325    * replace the metamorphic contract, first selfdestruct the current contract,
326    * then call with the same salt value and new initialization code (be aware
327    * that all existing state will be wiped from the existing contract). Also
328    * note that the first 20 bytes of the salt must match the calling address,
329    * which prevents contracts from being created by unintended parties.
330    * @param salt bytes32 The nonce that will be passed into the CREATE2 call and
331    * thus will determine the resulant address of the metamorphic contract.
332    * @param initializationCode bytes The initialization code for the metamorphic
333    * contract that will be deployed by the transient contract.
334    * @return Address of the metamorphic contract that will be created.
335    */
336   function deployMetamorphicContractWithConstructor(
337     bytes32 salt,
338     bytes calldata initializationCode
339   ) external payable containsCaller(salt) returns (
340     address metamorphicContractAddress
341   ) {
342     // move transient contract initialization code from storage to memory.
343     bytes memory initCode = _transientContractInitializationCode;
344 
345     // declare variable to verify successful transient contract deployment.
346     address deployedTransientContract;
347 
348     // determine the address of the transient contract.
349     address transientContractAddress = _getTransientContractAddress(salt);
350 
351     // store the initialization code to be retrieved by the transient contract.
352     _initCodes[transientContractAddress] = initializationCode;
353 
354     // load transient contract data and length of data, then deploy via CREATE2.
355     /* solhint-disable no-inline-assembly */
356     assembly {
357       let encoded_data := add(0x20, initCode) // load initialization code.
358       let encoded_size := mload(initCode)     // load the init code's length.
359       deployedTransientContract := create2(   // call CREATE2 with 4 arguments.
360         callvalue,                            // forward any supplied endowment.
361         encoded_data,                         // pass in initialization code.
362         encoded_size,                         // pass in init code's length.
363         salt                                  // pass in the salt value.
364       )
365     } /* solhint-enable no-inline-assembly */
366 
367     // ensure that the contracts were successfully deployed.
368     require(
369       deployedTransientContract == transientContractAddress,
370       "Failed to deploy metamorphic contract using given salt and init code."
371     );
372 
373     metamorphicContractAddress = _getMetamorphicContractAddressWithConstructor(
374       transientContractAddress
375     );
376 
377     emit MetamorphosedWithConstructor(
378       metamorphicContractAddress,
379       transientContractAddress
380     );
381   } /* solhint-enable function-max-lines */
382 
383   /**
384    * @dev View function for retrieving the address of the implementation
385    * contract to clone. Called by the constructor of each metamorphic contract.
386    */
387   function getImplementation() external view returns (address implementation) {
388     return _implementations[msg.sender];
389   }
390 
391   /**
392    * @dev View function for retrieving the initialization code for a given
393    * metamorphic contract to deploy via a transient contract. Called by the
394    * constructor of each transient contract.
395    * @return The initialization code to use to deploy the metamorphic contract.
396    */
397   function getInitializationCode() external view returns (
398     bytes memory initializationCode
399   ) {
400     return _initCodes[msg.sender];
401   }
402 
403   /**
404    * @dev View function for retrieving the address of the current implementation
405    * contract of a given metamorphic contract, where the address of the contract
406    * is supplied as an argument. Be aware that the implementation contract has
407    * an independent state and may have been altered or selfdestructed from when
408    * it was last cloned by the metamorphic contract.
409    * @param metamorphicContractAddress address The address of the metamorphic
410    * contract.
411    * @return Address of the corresponding implementation contract.
412    */
413   function getImplementationContractAddress(
414     address metamorphicContractAddress
415   ) external view returns (address implementationContractAddress) {
416     return _implementations[metamorphicContractAddress];
417   }
418 
419   /**
420    * @dev View function for retrieving the initialization code for a given
421    * metamorphic contract instance deployed via a transient contract, where the address
422    * of the transient contract is supplied as an argument.
423    * @param transientContractAddress address The address of the transient
424    * contract that deployed the metamorphic contract.
425    * @return The initialization code used to deploy the metamorphic contract.
426    */
427   function getMetamorphicContractInstanceInitializationCode(
428     address transientContractAddress
429   ) external view returns (bytes memory initializationCode) {
430     return _initCodes[transientContractAddress];
431   }
432 
433   /**
434    * @dev Compute the address of the metamorphic contract that will be created
435    * upon submitting a given salt to the contract.
436    * @param salt bytes32 The nonce passed into CREATE2 by metamorphic contract.
437    * @return Address of the corresponding metamorphic contract.
438    */
439   function findMetamorphicContractAddress(
440     bytes32 salt
441   ) external view returns (address metamorphicContractAddress) {
442     // determine the address where the metamorphic contract will be deployed.
443     metamorphicContractAddress = _getMetamorphicContractAddress(salt);
444   }
445 
446   /**
447    * @dev Compute the address of the transient contract that will be created
448    * upon submitting a given salt to the contract.
449    * @param salt bytes32 The nonce passed into CREATE2 when deploying the
450    * transient contract.
451    * @return Address of the corresponding transient contract.
452    */
453   function findTransientContractAddress(
454     bytes32 salt
455   ) external view returns (address transientContractAddress) {
456     // determine the address where the transient contract will be deployed.
457     transientContractAddress = _getTransientContractAddress(salt);
458   }
459 
460   /**
461    * @dev Compute the address of the metamorphic contract that will be created
462    * by the transient contract upon submitting a given salt to the contract.
463    * @param salt bytes32 The nonce passed into CREATE2 when deploying the
464    * transient contract.
465    * @return Address of the corresponding metamorphic contract.
466    */
467   function findMetamorphicContractAddressWithConstructor(
468     bytes32 salt
469   ) external view returns (address metamorphicContractAddress) {
470     // determine the address of the metamorphic contract.
471     metamorphicContractAddress = _getMetamorphicContractAddressWithConstructor(
472       _getTransientContractAddress(salt)
473     );
474   }
475 
476   /**
477    * @dev View function for retrieving the initialization code of metamorphic
478    * contracts for purposes of verification.
479    */
480   function getMetamorphicContractInitializationCode() external view returns (
481     bytes memory metamorphicContractInitializationCode
482   ) {
483     return _metamorphicContractInitializationCode;
484   }
485 
486   /**
487    * @dev View function for retrieving the keccak256 hash of the initialization
488    * code of metamorphic contracts for purposes of verification.
489    */
490   function getMetamorphicContractInitializationCodeHash() external view returns (
491     bytes32 metamorphicContractInitializationCodeHash
492   ) {
493     return _metamorphicContractInitializationCodeHash;
494   }
495 
496   /**
497    * @dev View function for retrieving the initialization code of transient
498    * contracts for purposes of verification.
499    */
500   function getTransientContractInitializationCode() external view returns (
501     bytes memory transientContractInitializationCode
502   ) {
503     return _transientContractInitializationCode;
504   }
505 
506   /**
507    * @dev View function for retrieving the keccak256 hash of the initialization
508    * code of transient contracts for purposes of verification.
509    */
510   function getTransientContractInitializationCodeHash() external view returns (
511     bytes32 transientContractInitializationCodeHash
512   ) {
513     return _transientContractInitializationCodeHash;
514   }
515 
516   /**
517    * @dev Internal view function for calculating a metamorphic contract address
518    * given a particular salt.
519    */
520   function _getMetamorphicContractAddress(
521     bytes32 salt
522   ) internal view returns (address) {
523     // determine the address of the metamorphic contract.
524     return address(
525       uint160(                      // downcast to match the address type.
526         uint256(                    // convert to uint to truncate upper digits.
527           keccak256(                // compute the CREATE2 hash using 4 inputs.
528             abi.encodePacked(       // pack all inputs to the hash together.
529               hex"ff",              // start with 0xff to distinguish from RLP.
530               address(this),        // this contract will be the caller.
531               salt,                 // pass in the supplied salt value.
532               _metamorphicContractInitializationCodeHash // the init code hash.
533             )
534           )
535         )
536       )
537     );
538   }
539 
540   /**
541    * @dev Internal view function for calculating a transient contract address
542    * given a particular salt.
543    */
544   function _getTransientContractAddress(
545     bytes32 salt
546   ) internal view returns (address) {
547     // determine the address of the transient contract.
548     return address(
549       uint160(                      // downcast to match the address type.
550         uint256(                    // convert to uint to truncate upper digits.
551           keccak256(                // compute the CREATE2 hash using 4 inputs.
552             abi.encodePacked(       // pack all inputs to the hash together.
553               hex"ff",              // start with 0xff to distinguish from RLP.
554               address(this),        // this contract will be the caller.
555               salt,                 // pass in the supplied salt value.
556               _transientContractInitializationCodeHash // supply init code hash.
557             )
558           )
559         )
560       )
561     );
562   }
563 
564   /**
565    * @dev Internal view function for calculating a metamorphic contract address
566    * that has been deployed via a transient contract given the address of the
567    * transient contract.
568    */
569   function _getMetamorphicContractAddressWithConstructor(
570     address transientContractAddress
571   ) internal pure returns (address) { 
572     // determine the address of the metamorphic contract.
573     return address(
574       uint160(                          // downcast to match the address type.
575         uint256(                        // set to uint to truncate upper digits.
576           keccak256(                    // compute CREATE hash via RLP encoding.
577             abi.encodePacked(           // pack all inputs to the hash together.
578               byte(0xd6),               // first RLP byte.
579               byte(0x94),               // second RLP byte.
580               transientContractAddress, // called by the transient contract.
581               byte(0x01)                // nonce begins at 1 for contracts.
582             )
583           )
584         )
585       )
586     );
587   }
588 
589   /**
590    * @dev Modifier to ensure that the first 20 bytes of a submitted salt match
591    * those of the calling account. This provides protection against the salt
592    * being stolen by frontrunners or other attackers.
593    * @param salt bytes32 The salt value to check against the calling address.
594    */
595   modifier containsCaller(bytes32 salt) {
596     // prevent contract submissions from being stolen from tx.pool by requiring
597     // that the first 20 bytes of the submitted salt match msg.sender.
598     require(
599       address(bytes20(salt)) == msg.sender,
600       "Invalid salt - first 20 bytes of the salt must match calling address."
601     );
602     _;
603   }
604 }