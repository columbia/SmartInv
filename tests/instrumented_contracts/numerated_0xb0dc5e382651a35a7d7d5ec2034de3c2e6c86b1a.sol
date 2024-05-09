1 
2 // File: contracts/common/Validating.sol
3 
4 pragma solidity 0.5.12;
5 
6 
7 interface Validating {
8   modifier notZero(uint number) { require(number > 0, "invalid 0 value"); _; }
9   modifier notEmpty(string memory text) { require(bytes(text).length > 0, "invalid empty string"); _; }
10   modifier validAddress(address value) { require(value != address(0x0), "invalid address"); _; }
11 }
12 
13 // File: contracts/common/SubChain.sol
14 
15 pragma solidity 0.5.12;
16 
17 /// @notice providing an sub chain mechanism
18 contract SubChain {
19 
20   address[] public subChains;
21   mapping(address => bool) public isSubChain;
22 
23   event SubChainAdded(address indexed subChain);
24 
25   constructor() public {}
26 
27   /// @notice list all sub chains
28   function getSubChains() public view returns (address[] memory) {return subChains;}
29 
30   /// @notice add a sub chain
31   function addSubChain() external {
32     isSubChain[msg.sender] = true;
33     subChains.push(msg.sender);
34     emit SubChainAdded(msg.sender);
35   }
36 }
37 
38 // File: contracts/external/MerkleProof.sol
39 
40 pragma solidity 0.5.12;
41 
42 
43 /// @notice can use a deployed https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/cryptography/MerkleProof.sol
44 contract MerkleProof {
45 
46   /**
47    * Verifies the inclusion of a leaf in a Merkle tree using a Merkle proof.
48    * Based on https://github.com/ameensol/merkle-tree-solidity/src/MerkleProof.sol
49    */
50   function checkProof(bytes memory proof, bytes32 root, bytes32 leaf) public pure returns (bool) {
51     if (proof.length % 32 != 0) return false; // Check if proof is made of bytes32 slices
52 
53     bytes memory elements = proof;
54     bytes32 element;
55     bytes32 hash = leaf;
56     for (uint i = 32; i <= proof.length; i += 32) {
57       assembly {
58       // Load the current element of the proofOfInclusion (optimal way to get a bytes32 slice)
59         element := mload(add(elements, i))
60       }
61       hash = keccak256(abi.encodePacked(hash < element ? abi.encodePacked(hash, element) : abi.encodePacked(element, hash)));
62     }
63     return hash == root;
64   }
65 
66   // from StorJ -- https://github.com/nginnever/storj-audit-verifier/contracts/MerkleVerifyv3.sol
67   function checkProofOrdered(bytes memory proof, bytes32 root, bytes32 leaf, uint index) public pure returns (bool) {
68     if (proof.length % 32 != 0) return false; // Check if proof is made of bytes32 slices
69 
70     // use the index to determine the node ordering (index ranges 1 to n)
71     bytes32 element;
72     bytes32 hash = leaf;
73     uint remaining;
74     for (uint j = 32; j <= proof.length; j += 32) {
75       assembly {
76         element := mload(add(proof, j))
77       }
78 
79       // calculate remaining elements in proof
80       remaining = (proof.length - j + 32) / 32;
81 
82       // we don't assume that the tree is padded to a power of 2
83       // if the index is odd then the proof will start with a hash at a higher layer,
84       // so we have to adjust the index to be the index at that layer
85       while (remaining > 0 && index % 2 == 1 && index > 2 ** remaining) {
86         index = uint(index) / 2 + 1;
87       }
88 
89       if (index % 2 == 0) {
90         hash = keccak256(abi.encodePacked(abi.encodePacked(element, hash)));
91         index = index / 2;
92       } else {
93         hash = keccak256(abi.encodePacked(abi.encodePacked(hash, element)));
94         index = uint(index) / 2 + 1;
95       }
96     }
97     return hash == root;
98   }
99 
100   /** Verifies the inclusion of a leaf in a Merkle tree using a Merkle proof */
101   function verifyIncluded(bytes memory proof, bytes32 root, bytes32 leaf) public pure returns (bool) {
102     return checkProof(proof, root, leaf);
103   }
104 
105   /** Verifies the inclusion of a leaf is at a specific place in an ordered Merkle tree using a Merkle proof */
106   function verifyIncludedAtIndex(bytes memory proof, bytes32 root, bytes32 leaf, uint index) public pure returns (bool) {
107     return checkProofOrdered(proof, root, leaf, index);
108   }
109 }
110 
111 // File: contracts/external/Token.sol
112 
113 pragma solidity 0.5.12;
114 
115 
116 /*
117  * Abstract contract for the full ERC 20 Token standard
118  * https://github.com/ethereum/EIPs/issues/20
119  */
120 contract Token {
121   /** This is a slight change to the ERC20 base standard.
122   function totalSupply() view returns (uint supply);
123   is replaced map:
124   uint public totalSupply;
125   This automatically creates a getter function for the totalSupply.
126   This is moved to the base contract since public getter functions are not
127   currently recognised as an implementation of the matching abstract
128   function by the compiler.
129   */
130   /// total amount of tokens
131   uint public totalSupply;
132 
133   /// @param _owner The address from which the balance will be retrieved
134   /// @return The balance
135   function balanceOf(address _owner) public view returns (uint balance);
136 
137   /// @notice send `_value` token to `_to` from `msg.sender`
138   /// @param _to The address of the recipient
139   /// @param _value The amount of token to be transferred
140   /// @return Whether the transfer was successful or not
141   function transfer(address _to, uint _value) public returns (bool success);
142 
143   /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
144   /// @param _from The address of the sender
145   /// @param _to The address of the recipient
146   /// @param _value The amount of token to be transferred
147   /// @return Whether the transfer was successful or not
148   function transferFrom(address _from, address _to, uint _value) public returns (bool success);
149 
150   /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
151   /// @param _spender The address of the account able to transfer the tokens
152   /// @param _value The amount of tokens to be approved for transfer
153   /// @return Whether the approval was successful or not
154   function approve(address _spender, uint _value) public returns (bool success);
155 
156   /// @param _owner The address of the account owning tokens
157   /// @param _spender The address of the account able to transfer the tokens
158   /// @return Amount of remaining tokens allowed to spent
159   function allowance(address _owner, address _spender) public view returns (uint remaining);
160 
161   event Transfer(address indexed _from, address indexed _to, uint _value);
162   event Approval(address indexed _owner, address indexed _spender, uint _value);
163 }
164 
165 // File: contracts/external/SafeMath.sol
166 
167 pragma solidity 0.5.12;
168 
169 
170 /**
171  * @title Math provides arithmetic functions for uint type pairs.
172  * You can safely `plus`, `minus`, `times`, and `divide` uint numbers without fear of integer overflow.
173  * You can also find the `min` and `max` of two numbers.
174  */
175 library SafeMath {
176 
177   function min(uint x, uint y) internal pure returns (uint) { return x <= y ? x : y; }
178   function max(uint x, uint y) internal pure returns (uint) { return x >= y ? x : y; }
179 
180 
181   /** @dev adds two numbers, reverts on overflow */
182   function plus(uint x, uint y) internal pure returns (uint z) { require((z = x + y) >= x, "bad addition"); }
183 
184   /** @dev subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend) */
185   function minus(uint x, uint y) internal pure returns (uint z) { require((z = x - y) <= x, "bad subtraction"); }
186 
187 
188   /** @dev multiplies two numbers, reverts on overflow */
189   function times(uint x, uint y) internal pure returns (uint z) { require(y == 0 || (z = x * y) / y == x, "bad multiplication"); }
190 
191   /** @dev divides two numbers and returns the remainder (unsigned integer modulo), reverts when dividing by zero */
192   function mod(uint x, uint y) internal pure returns (uint z) {
193     require(y != 0, "bad modulo; using 0 as divisor");
194     z = x % y;
195   }
196 
197   /** @dev Integer division of two numbers truncating the quotient, reverts on division by zero */
198   function div(uint a, uint b) internal pure returns (uint c) {
199     // assert(b > 0); // Solidity automatically throws when dividing by 0
200     c = a / b;
201     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202   }
203 
204 }
205 
206 // File: contracts/gluon/AppGovernance.sol
207 
208 pragma solidity 0.5.12;
209 
210 
211 interface AppGovernance {
212   function approve(uint32 id) external;
213   function disapprove(uint32 id) external;
214   function activate(uint32 id) external;
215 }
216 
217 // File: contracts/gluon/AppLogic.sol
218 
219 pragma solidity 0.5.12;
220 
221 
222 /**
223   * @notice representing an app's in-and-out transfers of assets
224   * @dev an account/asset based app should implement its own bookkeeping
225   */
226 interface AppLogic {
227 
228   /// @notice when an app proposal has been activated, Gluon will call this method on the previously active app version
229   /// @dev each app must implement, providing a future upgrade path, and call retire_() at the very end.
230   /// this is the chance for the previously active app version to migrate to the new version
231   /// i.e.: migrating data, deprecate prior behavior, releasing resources, etc.
232   function upgrade() external;
233 
234   /// @dev once an asset has been deposited into the app's safe within Gluon, the app is given the chance to do
235   /// it's own per account/asset bookkeeping
236   ///
237   /// @param account any Ethereum address
238   /// @param asset any ERC20 token or ETH (represented by address 0x0)
239   /// @param quantity quantity of asset
240   function credit(address account, address asset, uint quantity) external;
241 
242   /// @dev before an asset can be withdrawn from the app's safe within Gluon, the quantity and asset to withdraw must be
243   /// derived from `parameters`. if the app is account/asset based, it should take this opportunity to:
244   /// - also derive the owning account from `parameters`
245   /// - prove that the owning account indeed has the derived quantity of the derived asset
246   /// - do it's own per account/asset bookkeeping
247   /// notice that the derived account is not necessarily the same as the provided account; a classic usage example is
248   /// an account transfers assets across app (in which case the provided account would be the target app)
249   ///
250   /// @param account any Ethereum address to which `quantity` of `asset` would be transferred to
251   /// @param parameters a bytes-marshalled record containing all data needed for the app-specific logic
252   /// @return asset any ERC20 token or ETH (represented by address 0x0)
253   /// @return quantity quantity of asset
254   function debit(address account, bytes calldata parameters) external returns (address asset, uint quantity);
255 }
256 
257 // File: contracts/gluon/AppState.sol
258 
259 pragma solidity 0.5.12;
260 
261 /**
262   * @title representing an app's life-cycle
263   * @notice an app's life-cycle starts in the ON state, then it is either move to the final OFF state,
264   * or to the RETIRED state when it upgrades itself to its successor version.
265   */
266 contract AppState {
267 
268   enum State { OFF, ON, RETIRED }
269   State public state = State.ON;
270   event Off();
271   event Retired();
272 
273   /// @notice app must be active (when current)
274   modifier whenOn() { require(state == State.ON, "must be on"); _; }
275 
276   /// @notice app must be halted
277   modifier whenOff() { require(state == State.OFF, "must be off"); _; }
278 
279   /// @notice app must be retired (when no longer current, after being upgraded)
280   modifier whenRetired() { require(state == State.RETIRED, "must be retired"); _; }
281 
282   /// @dev retire the app. this action is irreversible.
283   /// called during a normal upgrade operation. by the end of this call the approved proposal would be active.
284   function retire_() internal whenOn {
285     state = State.RETIRED;
286     emit Retired();
287   }
288 
289   /// @notice halt the app. this action is irreversible.
290   /// (the only option at this point is have a proposal that will get to approval, then activated.)
291   /// should be called by an app-owner when the app has been compromised.
292   function switchOff_() internal whenOn {
293     state = State.OFF;
294     emit Off();
295   }
296 
297   /// @notice app state is active, i.e: current & active
298   function isOn() external view returns (bool) { return state == State.ON; }
299 
300 }
301 
302 // File: contracts/gluon/GluonView.sol
303 
304 pragma solidity 0.5.12;
305 
306 
307 interface GluonView {
308   function app(uint32 id) external view returns (address current, address proposal, uint activationBlock);
309   function current(uint32 id) external view returns (address);
310   function history(uint32 id) external view returns (address[] memory);
311   function getBalance(uint32 id, address asset) external view returns (uint);
312   function isAnyLogic(uint32 id, address logic) external view returns (bool);
313   function isAppOwner(uint32 id, address appOwner) external view returns (bool);
314   function proposals(address logic) external view returns (bool);
315   function totalAppsCount() external view returns(uint32);
316 }
317 
318 // File: contracts/gluon/GluonCentric.sol
319 
320 pragma solidity 0.5.12;
321 
322 
323 
324 /**
325   * @title the essentials of a side-chain app participating in Gluon-Plasma
326   * @dev both Logic & Data (if exists) contracts should inherit this contract
327   */
328 contract GluonCentric {
329 
330   uint32 internal constant REGISTRY_INDEX = 0;
331   uint32 internal constant STAKE_INDEX = 1;
332 
333   uint32 public id;
334   address public gluon;
335 
336   /// @param id_ index of the app within gluon
337   /// @param gluon_ address of the Gluon contract
338   constructor(uint32 id_, address gluon_) public {
339     id = id_;
340     gluon = gluon_;
341   }
342 
343   /// @notice requires the sender to be the currently active (latest) version of me (the app contract)
344   modifier onlyCurrentLogic { require(currentLogic() == msg.sender, "invalid sender; must be current logic contract"); _; }
345 
346   /// @notice requires the sender must be gluon contract
347   modifier onlyGluon { require(gluon == msg.sender, "invalid sender; must be gluon contract"); _; }
348 
349   /// @notice requires the sender must be my app owner
350   modifier onlyOwner { require(GluonView(gluon).isAppOwner(id, msg.sender), "invalid sender; must be app owner"); _; }
351 
352   /// @return address the address of currently active (latest) version of me (the app contract)
353   function currentLogic() public view returns (address) { return GluonView(gluon).current(id); }
354 
355 }
356 
357 // File: contracts/gluon/Upgrading.sol
358 
359 pragma solidity 0.5.12;
360 
361 
362 
363 
364 contract Upgrading {
365   address public upgradeOperator;
366 
367   modifier onlyOwner { require(false, "modifier onlyOwner must be implemented"); _; }
368   modifier onlyUpgradeOperator { require(upgradeOperator == msg.sender, "invalid sender; must be upgrade operator"); _; }
369   function setUpgradeOperator(address upgradeOperator_) external onlyOwner { upgradeOperator = upgradeOperator_; }
370   function upgrade_(AppGovernance appGovernance, uint32 id) internal {
371     appGovernance.activate(id);
372     delete upgradeOperator;
373   }
374 }
375 
376 // File: contracts/apps_history/registry/OldRegistry.sol
377 
378 pragma solidity 0.5.12;
379 
380 
381 interface OldRegistry {
382   function contains(address apiKey) external view returns (bool);
383   function register(address apiKey) external;
384   function registerWithUserAgreement(address apiKey, bytes32 userAgreement) external;
385   function translate(address apiKey) external view returns (address);
386 }
387 
388 // File: contracts/apps/registry/RegistryData.sol
389 
390 pragma solidity 0.5.12;
391 
392 
393 
394 contract RegistryData is GluonCentric {
395 
396   mapping(address => address) public accounts;
397 
398   constructor(address gluon) GluonCentric(REGISTRY_INDEX, gluon) public { }
399 
400   function addKey(address apiKey, address account) external onlyCurrentLogic {
401     accounts[apiKey] = account;
402   }
403 
404 }
405 
406 // File: contracts/apps/registry/RegistryLogic.sol
407 
408 pragma solidity 0.5.12;
409 
410 
411 
412 
413 
414 
415 
416 
417 
418 
419 /**
420   * @title enabling Zero Knowledge API Keys as described in: https://blog.leverj.io/zero-knowledge-api-keys-43280cc93647
421   * @notice the Registry app consists of the RegistryLogic & RegistryData contracts.
422   * api-key registrations are held within RegistryData for an easier upgrade path.
423   * @dev although Registry enable account-based apps needing log-less logins, no app is required to use it.
424   */
425 contract RegistryLogic is Upgrading, Validating, AppLogic, AppState, GluonCentric {
426 
427   RegistryData public data;
428   OldRegistry public old;
429 
430   event Registered(address apiKey, address indexed account);
431 
432   constructor(address gluon, address old_, address data_) GluonCentric(REGISTRY_INDEX, gluon) public {
433     data = RegistryData(data_);
434     old = OldRegistry(old_);
435   }
436 
437   modifier isAbsent(address apiKey) { require(translate(apiKey) == address (0x0), "api key already in use"); _; }
438 
439   /// @notice register an api-key on behalf of the sender
440   /// @dev irreversible operation; the apiKey->sender association cannot be broken or overwritten
441   /// (but further apiKey->sender associations can be provided)
442   ///
443   /// @param apiKey the account to be used to stand-in for the registering sender
444   function register(address apiKey) external whenOn validAddress(apiKey) isAbsent(apiKey) {
445     data.addKey(apiKey, msg.sender);
446     emit Registered(apiKey, msg.sender);
447   }
448 
449   /// @notice retrieve the stand-in-for account
450   ///
451   /// @param apiKey the account to be used to stand-in for the registering sender
452   function translate(address apiKey) public view returns (address) {
453     address account = data.accounts(apiKey);
454     if (account == address(0x0)) account = old.translate(apiKey);
455     return account;
456   }
457 
458   /**************************************************** AppLogic ****************************************************/
459 
460   /// @notice upgrade the app to a new version; the approved proposal.
461   /// by the end of this call the approved proposal would be the current and active version of the app.
462   function upgrade() external onlyUpgradeOperator {
463     retire_();
464     upgrade_(AppGovernance(gluon), id);
465   }
466 
467   function credit(address, address, uint) external { revert("not supported"); }
468 
469   function debit(address, bytes calldata) external returns (address, uint) { revert("not supported"); }
470 
471   /***************************************************** AppState *****************************************************/
472 
473   /// @notice halt the app. this action is irreversible.
474   /// (the only option at this point is have a proposal that will get to approval, then activated.)
475   /// should be called by an app-owner when the app has been compromised.
476   ///
477   /// Note the constraint that all apps but Registry & Stake must be halted first!
478   function switchOff() external onlyOwner {
479     uint32 totalAppsCount = GluonView(gluon).totalAppsCount();
480     for (uint32 i = 2; i < totalAppsCount; i++) {
481       AppState appState = AppState(GluonView(gluon).current(i));
482       require(!appState.isOn(), "One of the apps is still ON");
483     }
484     switchOff_();
485   }
486 
487   /********************************************************************************************************************/
488 }
489 
490 // File: contracts/common/EvmTypes.sol
491 
492 pragma solidity 0.5.12;
493 
494 
495 contract EvmTypes {
496   uint constant internal ADDRESS = 20;
497   uint constant internal UINT8 = 1;
498   uint constant internal UINT32 = 4;
499   uint constant internal UINT64 = 8;
500   uint constant internal UINT128 = 16;
501   uint constant internal UINT256 = 32;
502   uint constant internal BYTES32 = 32;
503   uint constant internal SIGNATURE_BYTES = 65;
504 }
505 
506 // File: contracts/external/BytesLib.sol
507 
508 /*
509  * @title Solidity Bytes Arrays Utils
510  * @author Gonçalo Sá <goncalo.sa@consensys.net>
511  *
512  * @dev Bytes tightly packed arrays utility library for ethereum contracts written in Solidity.
513  *      The library lets you concatenate, slice and type cast bytes arrays both in memory and storage.
514  */
515 
516 pragma solidity 0.5.12;
517 
518 
519 library BytesLib {
520     function concat(
521         bytes memory _preBytes,
522         bytes memory _postBytes
523     )
524         internal
525         pure
526         returns (bytes memory)
527     {
528         bytes memory tempBytes;
529 
530         assembly {
531             // Get a location of some free memory and store it in tempBytes as
532             // Solidity does for memory variables.
533             tempBytes := mload(0x40)
534 
535             // Store the length of the first bytes array at the beginning of
536             // the memory for tempBytes.
537             let length := mload(_preBytes)
538             mstore(tempBytes, length)
539 
540             // Maintain a memory counter for the current write location in the
541             // temp bytes array by adding the 32 bytes for the array length to
542             // the starting location.
543             let mc := add(tempBytes, 0x20)
544             // Stop copying when the memory counter reaches the length of the
545             // first bytes array.
546             let end := add(mc, length)
547 
548             for {
549                 // Initialize a copy counter to the start of the _preBytes data,
550                 // 32 bytes into its memory.
551                 let cc := add(_preBytes, 0x20)
552             } lt(mc, end) {
553                 // Increase both counters by 32 bytes each iteration.
554                 mc := add(mc, 0x20)
555                 cc := add(cc, 0x20)
556             } {
557                 // Write the _preBytes data into the tempBytes memory 32 bytes
558                 // at a time.
559                 mstore(mc, mload(cc))
560             }
561 
562             // Add the length of _postBytes to the current length of tempBytes
563             // and store it as the new length in the first 32 bytes of the
564             // tempBytes memory.
565             length := mload(_postBytes)
566             mstore(tempBytes, add(length, mload(tempBytes)))
567 
568             // Move the memory counter back from a multiple of 0x20 to the
569             // actual end of the _preBytes data.
570             mc := end
571             // Stop copying when the memory counter reaches the new combined
572             // length of the arrays.
573             end := add(mc, length)
574 
575             for {
576                 let cc := add(_postBytes, 0x20)
577             } lt(mc, end) {
578                 mc := add(mc, 0x20)
579                 cc := add(cc, 0x20)
580             } {
581                 mstore(mc, mload(cc))
582             }
583 
584             // Update the free-memory pointer by padding our last write location
585             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
586             // next 32 byte block, then round down to the nearest multiple of
587             // 32. If the sum of the length of the two arrays is zero then add
588             // one before rounding down to leave a blank 32 bytes (the length block with 0).
589             mstore(0x40, and(
590               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
591               not(31) // Round down to the nearest 32 bytes.
592             ))
593         }
594 
595         return tempBytes;
596     }
597 
598     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
599         assembly {
600             // Read the first 32 bytes of _preBytes storage, which is the length
601             // of the array. (We don't need to use the offset into the slot
602             // because arrays use the entire slot.)
603             let fslot := sload(_preBytes_slot)
604             // Arrays of 31 bytes or less have an even value in their slot,
605             // while longer arrays have an odd value. The actual length is
606             // the slot divided by two for odd values, and the lowest order
607             // byte divided by two for even values.
608             // If the slot is even, bitwise and the slot with 255 and divide by
609             // two to get the length. If the slot is odd, bitwise and the slot
610             // with -1 and divide by two.
611             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
612             let mlength := mload(_postBytes)
613             let newlength := add(slength, mlength)
614             // slength can contain both the length and contents of the array
615             // if length < 32 bytes so let's prepare for that
616             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
617             switch add(lt(slength, 32), lt(newlength, 32))
618             case 2 {
619                 // Since the new array still fits in the slot, we just need to
620                 // update the contents of the slot.
621                 // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
622                 sstore(
623                     _preBytes_slot,
624                     // all the modifications to the slot are inside this
625                     // next block
626                     add(
627                         // we can just add to the slot contents because the
628                         // bytes we want to change are the LSBs
629                         fslot,
630                         add(
631                             mul(
632                                 div(
633                                     // load the bytes from memory
634                                     mload(add(_postBytes, 0x20)),
635                                     // zero all bytes to the right
636                                     exp(0x100, sub(32, mlength))
637                                 ),
638                                 // and now shift left the number of bytes to
639                                 // leave space for the length in the slot
640                                 exp(0x100, sub(32, newlength))
641                             ),
642                             // increase length by the double of the memory
643                             // bytes length
644                             mul(mlength, 2)
645                         )
646                     )
647                 )
648             }
649             case 1 {
650                 // The stored value fits in the slot, but the combined value
651                 // will exceed it.
652                 // get the keccak hash to get the contents of the array
653                 mstore(0x0, _preBytes_slot)
654                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
655 
656                 // save new length
657                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
658 
659                 // The contents of the _postBytes array start 32 bytes into
660                 // the structure. Our first read should obtain the `submod`
661                 // bytes that can fit into the unused space in the last word
662                 // of the stored array. To get this, we read 32 bytes starting
663                 // from `submod`, so the data we read overlaps with the array
664                 // contents by `submod` bytes. Masking the lowest-order
665                 // `submod` bytes allows us to add that value directly to the
666                 // stored value.
667 
668                 let submod := sub(32, slength)
669                 let mc := add(_postBytes, submod)
670                 let end := add(_postBytes, mlength)
671                 let mask := sub(exp(0x100, submod), 1)
672 
673                 sstore(
674                     sc,
675                     add(
676                         and(
677                             fslot,
678                             0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
679                         ),
680                         and(mload(mc), mask)
681                     )
682                 )
683 
684                 for {
685                     mc := add(mc, 0x20)
686                     sc := add(sc, 1)
687                 } lt(mc, end) {
688                     sc := add(sc, 1)
689                     mc := add(mc, 0x20)
690                 } {
691                     sstore(sc, mload(mc))
692                 }
693 
694                 mask := exp(0x100, sub(mc, end))
695 
696                 sstore(sc, mul(div(mload(mc), mask), mask))
697             }
698             default {
699                 // get the keccak hash to get the contents of the array
700                 mstore(0x0, _preBytes_slot)
701                 // Start copying to the last used word of the stored array.
702                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
703 
704                 // save new length
705                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
706 
707                 // Copy over the first `submod` bytes of the new data as in
708                 // case 1 above.
709                 let slengthmod := mod(slength, 32)
710                 let mlengthmod := mod(mlength, 32)
711                 let submod := sub(32, slengthmod)
712                 let mc := add(_postBytes, submod)
713                 let end := add(_postBytes, mlength)
714                 let mask := sub(exp(0x100, submod), 1)
715 
716                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
717 
718                 for {
719                     sc := add(sc, 1)
720                     mc := add(mc, 0x20)
721                 } lt(mc, end) {
722                     sc := add(sc, 1)
723                     mc := add(mc, 0x20)
724                 } {
725                     sstore(sc, mload(mc))
726                 }
727 
728                 mask := exp(0x100, sub(mc, end))
729 
730                 sstore(sc, mul(div(mload(mc), mask), mask))
731             }
732         }
733     }
734 
735     function slice(
736         bytes memory _bytes,
737         uint _start,
738         uint _length
739     ) internal pure returns (bytes memory)
740     {
741         require(_bytes.length >= (_start + _length));
742 
743         bytes memory tempBytes;
744 
745         assembly {
746             switch iszero(_length)
747             case 0 {
748             // Get a location of some free memory and store it in tempBytes as
749             // Solidity does for memory variables.
750                 tempBytes := mload(0x40)
751 
752             // The first word of the slice result is potentially a partial
753             // word read from the original array. To read it, we calculate
754             // the length of that partial word and start copying that many
755             // bytes into the array. The first word we copy will start with
756             // data we don't care about, but the last `lengthmod` bytes will
757             // land at the beginning of the contents of the new array. When
758             // we're done copying, we overwrite the full first word with
759             // the actual length of the slice.
760                 let lengthmod := and(_length, 31)
761 
762             // The multiplication in the next line is necessary
763             // because when slicing multiples of 32 bytes (lengthmod == 0)
764             // the following copy loop was copying the origin's length
765             // and then ending prematurely not copying everything it should.
766                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
767                 let end := add(mc, _length)
768 
769                 for {
770                 // The multiplication in the next line has the same exact purpose
771                 // as the one above.
772                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
773                 } lt(mc, end) {
774                     mc := add(mc, 0x20)
775                     cc := add(cc, 0x20)
776                 } {
777                     mstore(mc, mload(cc))
778                 }
779 
780                 mstore(tempBytes, _length)
781 
782             // update free-memory pointer
783             // allocating the array padded to 32 bytes like the compiler does now
784                 mstore(0x40, and(add(mc, 31), not(31)))
785             }
786             // if we want a zero-length slice let's just return a zero-length array
787             default {
788                 tempBytes := mload(0x40)
789 
790                 mstore(0x40, add(tempBytes, 0x20))
791             }
792         }
793 
794         return tempBytes;
795     }
796 
797     function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
798         require(_bytes.length >= (_start + 20));
799         address tempAddress;
800         assembly {
801             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
802         }
803         return tempAddress;
804     }
805 
806     function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
807         require(_bytes.length >= (_start + 1));
808         uint8 tempUint;
809         assembly {
810             tempUint := mload(add(add(_bytes, 0x1), _start))
811         }
812         return tempUint;
813     }
814 
815     function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
816         require(_bytes.length >= (_start + 2));
817         uint16 tempUint;
818         assembly {
819             tempUint := mload(add(add(_bytes, 0x2), _start))
820         }
821         return tempUint;
822     }
823 
824     function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
825         require(_bytes.length >= (_start + 4));
826         uint32 tempUint;
827         assembly {
828             tempUint := mload(add(add(_bytes, 0x4), _start))
829         }
830         return tempUint;
831     }
832 
833     function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
834         require(_bytes.length >= (_start + 8));
835         uint64 tempUint;
836         assembly {
837             tempUint := mload(add(add(_bytes, 0x8), _start))
838         }
839         return tempUint;
840     }
841 
842     function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
843         require(_bytes.length >= (_start + 12));
844         uint96 tempUint;
845         assembly {
846             tempUint := mload(add(add(_bytes, 0xc), _start))
847         }
848         return tempUint;
849     }
850 
851     function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
852         require(_bytes.length >= (_start + 16));
853         uint128 tempUint;
854         assembly {
855             tempUint := mload(add(add(_bytes, 0x10), _start))
856         }
857         return tempUint;
858     }
859 
860     function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
861         require(_bytes.length >= (_start + 32));
862         uint256 tempUint;
863         assembly {
864             tempUint := mload(add(add(_bytes, 0x20), _start))
865         }
866         return tempUint;
867     }
868 
869     function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
870         require(_bytes.length >= (_start + 32));
871         bytes32 tempBytes32;
872         assembly {
873             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
874         }
875         return tempBytes32;
876     }
877 
878     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
879         bool success = true;
880 
881         assembly {
882             let length := mload(_preBytes)
883 
884             // if lengths don't match the arrays are not equal
885             switch eq(length, mload(_postBytes))
886             case 1 {
887                 // cb is a circuit breaker in the for loop since there's
888                 //  no said feature for inline assembly loops
889                 // cb = 1 - don't breaker
890                 // cb = 0 - break
891                 let cb := 1
892 
893                 let mc := add(_preBytes, 0x20)
894                 let end := add(mc, length)
895 
896                 for {
897                     let cc := add(_postBytes, 0x20)
898                 // the next line is the loop condition:
899                 // while(uint(mc < end) + cb == 2)
900                 } eq(add(lt(mc, end), cb), 2) {
901                     mc := add(mc, 0x20)
902                     cc := add(cc, 0x20)
903                 } {
904                     // if any of these checks fails then arrays are not equal
905                     if iszero(eq(mload(mc), mload(cc))) {
906                         // unsuccess:
907                         success := 0
908                         cb := 0
909                     }
910                 }
911             }
912             default {
913                 // unsuccess:
914                 success := 0
915             }
916         }
917 
918         return success;
919     }
920 
921     function equalStorage(
922         bytes storage _preBytes,
923         bytes memory _postBytes
924     )
925         internal
926         view
927         returns (bool)
928     {
929         bool success = true;
930 
931         assembly {
932             // we know _preBytes_offset is 0
933             let fslot := sload(_preBytes_slot)
934             // Decode the length of the stored array like in concatStorage().
935             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
936             let mlength := mload(_postBytes)
937 
938             // if lengths don't match the arrays are not equal
939             switch eq(slength, mlength)
940             case 1 {
941                 // slength can contain both the length and contents of the array
942                 // if length < 32 bytes so let's prepare for that
943                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
944                 if iszero(iszero(slength)) {
945                     switch lt(slength, 32)
946                     case 1 {
947                         // blank the last byte which is the length
948                         fslot := mul(div(fslot, 0x100), 0x100)
949 
950                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
951                             // unsuccess:
952                             success := 0
953                         }
954                     }
955                     default {
956                         // cb is a circuit breaker in the for loop since there's
957                         //  no said feature for inline assembly loops
958                         // cb = 1 - don't breaker
959                         // cb = 0 - break
960                         let cb := 1
961 
962                         // get the keccak hash to get the contents of the array
963                         mstore(0x0, _preBytes_slot)
964                         let sc := keccak256(0x0, 0x20)
965 
966                         let mc := add(_postBytes, 0x20)
967                         let end := add(mc, mlength)
968 
969                         // the next line is the loop condition:
970                         // while(uint(mc < end) + cb == 2)
971                         for {} eq(add(lt(mc, end), cb), 2) {
972                             sc := add(sc, 1)
973                             mc := add(mc, 0x20)
974                         } {
975                             if iszero(eq(sload(sc), mload(mc))) {
976                                 // unsuccess:
977                                 success := 0
978                                 cb := 0
979                             }
980                         }
981                     }
982                 }
983             }
984             default {
985                 // unsuccess:
986                 success := 0
987             }
988         }
989 
990         return success;
991     }
992 }
993 
994 // File: contracts/external/Cryptography.sol
995 
996 pragma solidity 0.5.12;
997 
998 
999 contract Cryptography {
1000 
1001   /**
1002   * @dev Recover signer address from a message by using their signature
1003   * @param hash message, the hash is the signed message. What is recovered is the signer address.
1004   * @param signature generated using web3.eth.account.sign().signature
1005   *
1006   * Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
1007   * TODO: Remove this library once solidity supports passing a signature to ecrecover.
1008   * See https://github.com/ethereum/solidity/issues/864
1009   */
1010   function recover(bytes32 hash, bytes memory signature) public pure returns (address) {
1011     bytes32 r;
1012     bytes32 s;
1013     uint8 v;
1014     if (signature.length != 65) return (address(0x0));
1015     // Check the signature length
1016 
1017     // Divide the signature into r, s and v variables
1018     assembly {
1019       r := mload(add(signature, 32))
1020       s := mload(add(signature, 64))
1021       v := byte(0, mload(add(signature, 96)))
1022     }
1023 
1024     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
1025     if (v < 27) v += 27;
1026 
1027     // If the version is correct return the signer address
1028     return (v != 27 && v != 28) ? (address(0)) : ecrecover(hash, v, r, s);
1029   }
1030 
1031 }
1032 
1033 // File: contracts/apps/derivatives/WithEntry.sol
1034 
1035 pragma solidity 0.5.12;
1036 
1037 
1038 
1039 
1040 
1041 /// @title unpacking ledger Entry from bytes
1042 contract WithEntry is EvmTypes, Cryptography {
1043   using BytesLib for bytes;
1044 
1045   struct Entry {
1046     uint32 ledgerId;
1047     address account;
1048     address asset;
1049     uint32 instrument;
1050     EntryType entryType;
1051     uint8 action;
1052     uint timestamp;
1053     uint quantity;
1054     uint balance;
1055     Position position;
1056     uint notional;
1057     uint instrumentMargin;
1058     uint margin;
1059     uint128 previous;
1060     uint128 instrumentPrevious;
1061     uint32 gblockNumber;
1062     bytes32 hash;
1063     bytes32 dataHash;
1064     bytes signature;
1065     address signer;
1066     bytes dataBytes;
1067   }
1068 
1069   struct Position {
1070     uint8 sign;
1071     uint64 numerator;
1072     uint64 denominator;
1073   }
1074 
1075   uint constant private VERSION = 0;
1076   uint constant private LEDGER_ID = VERSION + UINT8;
1077   uint constant private ACCOUNT = LEDGER_ID + UINT32;
1078   uint constant private ASSET = ACCOUNT + ADDRESS;
1079   uint constant private INSTRUMENT = ASSET + ADDRESS;
1080   uint constant private ENTRY_TYPE = INSTRUMENT + UINT32;
1081   uint constant private ACTION = ENTRY_TYPE + UINT8;
1082   uint constant private TIMESTAMP = ACTION + UINT8;
1083   uint constant private QUANTITY = TIMESTAMP + UINT64;
1084   uint constant private BALANCE = QUANTITY + UINT256;
1085   uint constant private NOTIONAL = BALANCE + UINT256;
1086   uint constant private INSTRUMENT_MARGIN = NOTIONAL + UINT256;
1087   uint constant private MARGIN = INSTRUMENT_MARGIN + UINT256;
1088   uint constant private PREVIOUS = MARGIN + UINT256;
1089   uint constant private INSTRUMENT_PREVIOUS = PREVIOUS + UINT128;
1090   uint constant private GBLOCK_NUMBER = INSTRUMENT_PREVIOUS + UINT128;
1091   uint constant private SIGN = GBLOCK_NUMBER + UINT32;
1092   uint constant private NUMERATOR = SIGN + UINT8;
1093   uint constant private DENOMINATOR = NUMERATOR + UINT64;
1094   uint constant private DATA_HASH = DENOMINATOR + UINT64;
1095   uint constant private ENTRY_LENGTH = DATA_HASH + BYTES32;
1096 
1097   enum EntryType {Unknown, Origin, Deposit, Withdrawal, Exited, Trade, Fee, Margin, Liquidation, Deleverage, Funding, RedeemMargin, Transfer}
1098 
1099   function parseEntry(bytes memory parameters, bytes memory signature) internal pure returns (Entry memory result) {
1100     result.ledgerId = parameters.toUint32(LEDGER_ID);
1101     result.account = parameters.toAddress(ACCOUNT);
1102     result.asset = parameters.toAddress(ASSET);
1103     result.instrument = parameters.toUint32(INSTRUMENT);
1104     result.entryType = EntryType(parameters.toUint8(ENTRY_TYPE));
1105     result.action = parameters.toUint8(ACTION);
1106     result.timestamp = parameters.toUint64(TIMESTAMP);
1107     result.quantity = parameters.toUint(QUANTITY);
1108     result.balance = parameters.toUint(BALANCE);
1109     result.notional = parameters.toUint(NOTIONAL);
1110     result.instrumentMargin = parameters.toUint(INSTRUMENT_MARGIN);
1111     result.margin = parameters.toUint(MARGIN);
1112     result.previous = parameters.toUint128(PREVIOUS);
1113     result.instrumentPrevious = parameters.toUint128(INSTRUMENT_PREVIOUS);
1114     result.gblockNumber = parameters.toUint32(GBLOCK_NUMBER);
1115     result.dataHash = parameters.toBytes32(DATA_HASH);
1116     result.position = Position(parameters.toUint8(SIGN), parameters.toUint64(NUMERATOR), parameters.toUint64(DENOMINATOR));
1117     bytes memory entryBytes = parameters;
1118     if (parameters.length > ENTRY_LENGTH) {
1119       result.dataBytes = parameters.slice(ENTRY_LENGTH, parameters.length - ENTRY_LENGTH);
1120       require(result.dataHash == keccak256(result.dataBytes), "data hash mismatch");
1121       entryBytes = parameters.slice(0, ENTRY_LENGTH);
1122     }
1123     result.hash = keccak256(entryBytes);
1124     result.signer = recover(result.hash, signature);
1125   }
1126 
1127 }
1128 
1129 // File: contracts/apps/derivatives/DerivativesData.sol
1130 
1131 pragma solidity 0.5.12;
1132 
1133 
1134 
1135 contract DerivativesData is GluonCentric {
1136 
1137   struct Gblock {
1138     bytes32 withdrawalsRoot;
1139     bytes32 depositsRoot;
1140     bytes32 balancesRoot;
1141   }
1142 
1143   uint public constant name = uint(keccak256("DerivativesData"));
1144   uint32 public nonce = 0;
1145   uint32 public currentGblockNumber;
1146   uint public submissionBlock = block.number;
1147   mapping(uint32 => Gblock) public gblocksByNumber;
1148   mapping(bytes32 => bool) public deposits;
1149   mapping(bytes32 => bool) public withdrawn;
1150   mapping(bytes32 => uint) public exitClaims; // exit entry hash => confirmationThreshold
1151   mapping(address => mapping(address => bool)) public exited; // account => asset => has exited
1152 
1153   constructor(uint32 id, address gluon) GluonCentric(id, gluon) public { }
1154 
1155   function deposit(bytes32 hash) external onlyCurrentLogic { deposits[hash] = true; }
1156 
1157   function deleteDeposit(bytes32 hash) external onlyCurrentLogic {
1158     require(deposits[hash], "unknown deposit");
1159     delete deposits[hash];
1160   }
1161 
1162   function nextNonce() external onlyCurrentLogic returns (uint32) { return ++nonce; }
1163 
1164   function markExited(address account, address asset) external onlyCurrentLogic { exited[account][asset] = true; }
1165 
1166   function markWithdrawn(bytes32 hash) external onlyCurrentLogic {withdrawn[hash] = true;}
1167 
1168   function hasExited(address account, address asset) external view returns (bool) { return exited[account][asset]; }
1169 
1170   function hasWithdrawn(bytes32 hash) external view returns (bool) { return withdrawn[hash]; }
1171 
1172   function markExitClaim(bytes32 hash, uint confirmationThreshold) external onlyCurrentLogic { exitClaims[hash] = confirmationThreshold; }
1173 
1174   function deleteExitClaim(bytes32 hash) external onlyCurrentLogic { delete exitClaims[hash]; }
1175 
1176   function submit(uint32 gblockNumber, bytes32 withdrawalsRoot, bytes32 depositsRoot, bytes32 balancesRoot, uint submissionInterval) external onlyCurrentLogic {
1177     Gblock memory gblock = Gblock(withdrawalsRoot, depositsRoot, balancesRoot);
1178     gblocksByNumber[gblockNumber] = gblock;
1179     currentGblockNumber = gblockNumber;
1180     submissionBlock = block.number + submissionInterval;
1181   }
1182 
1183   function updateSubmissionBlock(uint submissionBlock_) external onlyCurrentLogic { submissionBlock = submissionBlock_; }
1184 
1185   function depositsRoot(uint32 gblockNumber) external view returns (bytes32) { return gblocksByNumber[gblockNumber].depositsRoot; }
1186 
1187   function withdrawalsRoot(uint32 gblockNumber) external view returns (bytes32) { return gblocksByNumber[gblockNumber].withdrawalsRoot; }
1188 
1189   function balancesRoot(uint32 gblockNumber) external view returns (bytes32) { return gblocksByNumber[gblockNumber].balancesRoot; }
1190 
1191   function isConfirmedGblock(uint32 gblockNumber) external view returns (bool) { return gblockNumber > 0 && gblockNumber < currentGblockNumber; }
1192 
1193 }
1194 
1195 // File: contracts/apps/common/WithDepositCommitmentRecord.sol
1196 
1197 pragma solidity 0.5.12;
1198 
1199 
1200 
1201 
1202 /// @title unpacking DepositCommitmentRecord from bytes
1203 contract WithDepositCommitmentRecord is EvmTypes {
1204   using BytesLib for bytes;
1205 
1206   struct DepositCommitmentRecord {
1207     uint32 ledgerId;
1208     address account;
1209     address asset;
1210     uint quantity;
1211     uint32 nonce;
1212     uint32 designatedGblock;
1213     bytes32 hash;
1214   }
1215 
1216   uint constant private LEDGER_ID = 0;
1217   uint constant private ACCOUNT = LEDGER_ID + UINT32;
1218   uint constant private ASSET = ACCOUNT + ADDRESS;
1219   uint constant private QUANTITY = ASSET + ADDRESS;
1220   uint constant private NONCE = QUANTITY + UINT256;
1221   uint constant private DESIGNATED_GBLOCK = NONCE + UINT32;
1222 
1223   function parseDepositCommitmentRecord(bytes memory parameters) internal pure returns (DepositCommitmentRecord memory result) {
1224     result.ledgerId = parameters.toUint32(LEDGER_ID);
1225     result.account = parameters.toAddress(ACCOUNT);
1226     result.asset = parameters.toAddress(ASSET);
1227     result.quantity = parameters.toUint(QUANTITY);
1228     result.nonce = parameters.toUint32(NONCE);
1229     result.designatedGblock = parameters.toUint32(DESIGNATED_GBLOCK);
1230     result.hash = keccak256(encodePackedDeposit(result.ledgerId, result.account, result.asset, result.quantity, result.nonce, result.designatedGblock));
1231   }
1232 
1233   function encodePackedDeposit(uint32 ledgerId, address account, address asset, uint quantity, uint32 nonce, uint32 designatedGblock) public pure returns(bytes memory) {
1234     return abi.encodePacked(ledgerId, account, asset, quantity, nonce, designatedGblock);
1235   }
1236 }
1237 
1238 // File: contracts/apps/derivatives/DerivativesLogic.sol
1239 
1240 pragma solidity 0.5.12;
1241 
1242 
1243 
1244 
1245 
1246 
1247 
1248 
1249 
1250 
1251 
1252 
1253 
1254 
1255 
1256 
1257 /**
1258   * @title enabling the Leverj Derivatives DEX
1259   * @notice the Spot app consists of the DerivativesLogic & DerivativesData contracts
1260   * Gblocks related data and withdrawals tracking data are held within DerivativesData for an easier upgrade path.
1261   *
1262   * the Stake app enables:
1263   * - account/asset based bookkeeping via an off-chain ledger
1264   * - periodic submission of merkle-tree roots of the off-chain ledger
1265   * - fraud-proofs based security of account/asset withdrawals
1266   * - account based AML
1267   * in-depth details and reasoning are detailed in: https://leverj.io/GluonPlasma.pdf
1268   */
1269 contract DerivativesLogic is Upgrading, Validating, MerkleProof, AppLogic, AppState, GluonCentric, WithDepositCommitmentRecord, WithEntry, SubChain {
1270   using SafeMath for uint;
1271 
1272   struct ProofOfInclusionAtIndex {
1273     bytes32 leaf;
1274     uint index;
1275     bytes proof;
1276   }
1277 
1278   struct ProofOfExclusionOfDeposit {
1279     ProofOfInclusionAtIndex predecessor;
1280     ProofOfInclusionAtIndex successor;
1281   }
1282 
1283   uint8 public constant confirmationDelay = 5;
1284   uint8 public constant visibilityDelay = 1;
1285   uint32 public constant nullInstrument = 0;
1286   uint private constant ASSISTED_WITHDRAW = 1;
1287   uint private constant RECLAIM_DEPOSIT = 2;
1288   uint private constant CLAIM_EXIT = 3;
1289   uint private constant EXIT = 4;
1290   uint private constant EXIT_ON_HALT = 5;
1291   uint private constant RECLAIM_DEPOSIT_ON_HALT = 6;
1292   uint private constant MAX_EXIT_COUNT = 100;
1293   uint public constant name = uint(keccak256("DerivativesLogic"));
1294 
1295   DerivativesData public data;
1296   address public operator;
1297   uint public submissionInterval;
1298   uint public abandonPoint;
1299   uint32 public exitCounts = 0;
1300 
1301   event Deposited(address indexed account, address indexed asset, uint quantity, uint32 nonce, uint32 designatedGblock);
1302   event DepositReclaimed(address indexed account, address indexed asset, uint quantity, uint32 nonce);
1303   event ExitClaimed(bytes32 hash, address indexed account, address indexed asset, uint confirmationThreshold);
1304   event Exited(address indexed account, address indexed asset, uint quantity);
1305   event Withdrawn(bytes32 hash, address indexed account, address indexed asset, uint quantity);
1306   event Submitted(uint32 gblockNumber, bytes32 withdrawalsRoot, bytes32 depositsRoot, bytes32 balancesRoot);
1307 
1308   constructor(uint32 id, address gluon, address data_, address operator_, uint submissionInterval_, uint abandonPoint_) GluonCentric(id, gluon) public validAddress(gluon) validAddress(operator_) {
1309     operator = operator_;
1310     submissionInterval = submissionInterval_;
1311     data = DerivativesData(data_);
1312     abandonPoint = abandonPoint_;
1313   }
1314 
1315   /**************************************************** AppLogic ****************************************************/
1316 
1317   function upgrade() external whenOn onlyUpgradeOperator {
1318     require(canSubmit(), "cannot upgrade yet");
1319     (, address proposal,) = GluonView(gluon).app(id);
1320     address[] memory logics = GluonView(gluon).history(id);
1321     require(proposal != address(this), "can not be the same contract");
1322     require(DerivativesLogic(proposal).id() == id, "invalid app id");
1323     for (uint i = 0; i < logics.length; i++) {
1324       require(proposal != logics[i], "can not be old contract");
1325     }
1326     require(DerivativesLogic(proposal).name() == name, "proposal name is different");
1327     retire_();
1328     upgrade_(AppGovernance(gluon), id);
1329   }
1330 
1331   function credit(address account, address asset, uint quantity) external whenOn onlyGluon {
1332     require(!data.hasExited(account, asset), "previously exited");
1333     uint32 nonce = data.nextNonce();
1334     uint32 designatedGblock = data.currentGblockNumber() + visibilityDelay;
1335     bytes32 hash = keccak256(abi.encodePacked(id, account, asset, quantity, nonce, designatedGblock));
1336     data.deposit(hash);
1337     emit Deposited(account, asset, quantity, nonce, designatedGblock);
1338   }
1339 
1340   function debit(address account, bytes calldata parameters) external onlyGluon returns (address asset, uint quantity) {
1341     uint action = parameters.toUint(0);
1342     if (action == ASSISTED_WITHDRAW) return assistedWithdraw(account, parameters);
1343     else if (action == RECLAIM_DEPOSIT) return reclaimDeposit(account, parameters);
1344     else if (action == CLAIM_EXIT) return claimExit(account, parameters);
1345     else if (action == EXIT) return exit(account, parameters);
1346     else if (action == EXIT_ON_HALT) return exitOnHalt(account, parameters);
1347     else if (action == RECLAIM_DEPOSIT_ON_HALT) return reclaimDepositOnHalt(account, parameters);
1348     else revert("invalid action");
1349   }
1350 
1351   /**************************************************** Depositing ****************************************************/
1352 
1353   /// @notice if a Deposit is not included in the Ledger, reclaim it using a proof-of-exclusion
1354   /// @dev Deposited events must be listened to, and a corresponding Deposit entry should be created with the event's data as the witness
1355   ///
1356   /// @param account the claimant
1357   /// @param parameters packed proof-of-exclusion of deposit
1358   function reclaimDeposit(address account, bytes memory parameters) private whenOn returns (address asset, uint quantity) {
1359     (, bytes memory recordParameters, bytes memory proofBytes1, bytes memory proofBytes2) = abi.decode(parameters, (uint, bytes, bytes, bytes));
1360     DepositCommitmentRecord memory record = parseAndValidateDepositCommitmentRecord(account, recordParameters);
1361     require(data.currentGblockNumber() > record.designatedGblock + 1 && record.designatedGblock != 0, "designated gblock is unconfirmed or unknown");
1362     require(proveIsExcludedFromDeposits(record, data.depositsRoot(record.designatedGblock), proofBytes1), "failed to proof exclusion of deposit");
1363     require(proveIsExcludedFromDeposits(record, data.depositsRoot(record.designatedGblock + 1), proofBytes2), "failed to proof exclusion of deposit");
1364     return reclaimDeposit_(record);
1365   }
1366 
1367   function parseAndValidateDepositCommitmentRecord(address account, bytes memory commitmentRecord) private view returns (DepositCommitmentRecord memory record){
1368     record = parseDepositCommitmentRecord(commitmentRecord);
1369     require(record.ledgerId == id, "not from current ledger");
1370     require(record.account == account, "claimant must be the original depositor");
1371   }
1372 
1373   function proveIsExcludedFromDeposits(DepositCommitmentRecord memory record, bytes32 root, bytes memory proofBytes) private pure returns (bool) {
1374     ProofOfExclusionOfDeposit memory proof = extractProofOfExclusionOfDeposit(proofBytes);
1375     return proof.successor.index == proof.predecessor.index + 1 && // predecessor & successor must be consecutive
1376     proof.successor.leaf > record.hash &&
1377     proof.predecessor.leaf < record.hash &&
1378     verifyIncludedAtIndex(proof.predecessor.proof, root, proof.predecessor.leaf, proof.predecessor.index) &&
1379     verifyIncludedAtIndex(proof.successor.proof, root, proof.successor.leaf, proof.successor.index);
1380   }
1381 
1382   function reclaimDepositOnHalt(address account, bytes memory parameters) private whenOff returns (address asset, uint quantity) {
1383     (, bytes memory commitmentRecord, bytes memory proofBytes1, bytes memory proofBytes2) = abi.decode(parameters, (uint, bytes, bytes, bytes));
1384     DepositCommitmentRecord memory record = parseAndValidateDepositCommitmentRecord(account, commitmentRecord);
1385     if (data.currentGblockNumber() > record.designatedGblock) {
1386       require(proveIsExcludedFromDeposits(record, data.depositsRoot(record.designatedGblock), proofBytes1), "failed to proof exclusion of deposit");
1387     }
1388     if (data.currentGblockNumber() > record.designatedGblock + 1) {
1389       require(proveIsExcludedFromDeposits(record, data.depositsRoot(record.designatedGblock + 1), proofBytes2), "failed to proof exclusion of deposit");
1390     }
1391     return reclaimDeposit_(record);
1392   }
1393 
1394   function encodedDepositOnHaltParameters(address account, address asset, uint quantity, uint32 nonce, uint32 designatedGblock) external view returns (bytes memory) {
1395     bytes memory encodedPackedDeposit = encodePackedDeposit(id, account, asset, quantity, nonce, designatedGblock);
1396     return abi.encode(RECLAIM_DEPOSIT_ON_HALT, encodedPackedDeposit);
1397   }
1398 
1399   function reclaimDeposit_(DepositCommitmentRecord memory record) private returns (address asset, uint quantity) {
1400     data.deleteDeposit(record.hash);
1401     emit DepositReclaimed(record.account, record.asset, record.quantity, record.nonce);
1402     return (record.asset, record.quantity);
1403   }
1404 
1405   function extractProofOfExclusionOfDeposit(bytes memory proofBytes) private pure returns (ProofOfExclusionOfDeposit memory result) {
1406     (bytes32[] memory leaves, uint[] memory indexes, bytes memory predecessor, bytes memory successor) = abi.decode(proofBytes, (bytes32[], uint[], bytes, bytes));
1407     result = ProofOfExclusionOfDeposit(ProofOfInclusionAtIndex(leaves[0], indexes[0], predecessor), ProofOfInclusionAtIndex(leaves[1], indexes[1], successor));
1408   }
1409 
1410   /**************************************************** Withdrawing ***************************************************/
1411 
1412   function assistedWithdraw(address account, bytes memory parameters) private returns (address asset, uint quantity) {
1413     (, bytes memory entryBytes, bytes memory signature, bytes memory proof) = abi.decode(parameters, (uint, bytes, bytes, bytes));
1414     Entry memory entry = parseAndValidateEntry(entryBytes, signature, account);
1415     require(entry.entryType == EntryType.Withdrawal, "entry must be of type Withdrawal");
1416     require(proveInConfirmedWithdrawals(proof, entry.gblockNumber, entry.hash), "invalid entry proof");
1417     require(!data.hasWithdrawn(entry.hash), "entry already withdrawn");
1418     data.markWithdrawn(entry.hash);
1419     emit Withdrawn(entry.hash, entry.account, entry.asset, entry.quantity);
1420     return (entry.asset, entry.quantity);
1421   }
1422 
1423   function claimExit(address account, bytes memory parameters) private whenOn returns (address asset, uint quantity) {
1424     require(!isSubChain[account], 'subChain prohibited');
1425     (, address asset_) = abi.decode(parameters, (uint, address));
1426     require(!hasExited(account, asset_), "previously exited");
1427     bytes32 hash = keccak256(abi.encodePacked(account, asset_));
1428     require(data.exitClaims(hash) == 0, "previously claimed exit");
1429     require(exitCounts < MAX_EXIT_COUNT, 'MAX_EXIT EXCEEDED');
1430     exitCounts = exitCounts + 1;
1431     uint confirmationThreshold = data.currentGblockNumber() + confirmationDelay;
1432     data.markExitClaim(hash, confirmationThreshold);
1433     emit ExitClaimed(hash, account, asset_, confirmationThreshold);
1434     return (asset, 0);
1435   }
1436 
1437   function exit(address account, bytes memory parameters) private whenOn returns (address asset, uint quantity) {
1438     require(!isSubChain[account], 'subChain prohibited');
1439     (, bytes memory entry_, bytes memory signature, bytes memory proof, uint32 gblockNumber) = abi.decode(parameters, (uint, bytes, bytes, bytes, uint32));
1440     Entry memory entry = parseAndValidateEntry(entry_, signature, account);
1441     require(!hasExited(entry.account, entry.asset), "previously exited");
1442     bytes32 hash = keccak256(abi.encodePacked(entry.account, entry.asset));
1443     require(canExit(hash, gblockNumber), "no prior claim found to withdraw OR balances are yet to be confirmed");
1444     require(verifyIncluded(proof, data.balancesRoot(gblockNumber), entry.hash), "invalid balance proof");
1445     if (entry.margin == 0) {
1446       data.deleteExitClaim(hash);
1447       data.markExited(entry.account, entry.asset);
1448       emit Exited(entry.account, entry.asset, entry.balance);
1449       return (entry.asset, entry.balance);
1450     } else {
1451       switchOff_();
1452       return (entry.asset, 0);
1453     }
1454   }
1455 
1456   function exitOnHalt(address account, bytes memory parameters) private whenOff returns (address asset, uint quantity) {
1457     (, bytes memory entry_, bytes memory signature, bytes memory proof) = abi.decode(parameters, (uint, bytes, bytes, bytes));
1458     Entry memory entry = parseAndValidateEntry(entry_, signature, account);
1459     require(!hasExited(entry.account, entry.asset), "previously exited");
1460     require(proveInConfirmedBalances(proof, entry.hash), "invalid balance proof");
1461     data.markExited(entry.account, entry.asset);
1462     uint balance = entry.balance.plus(entry.margin);
1463     emit Exited(entry.account, entry.asset, balance);
1464     return (entry.asset, balance);
1465   }
1466 
1467   /// @notice has the account/asset pair already claimed and exited?
1468   ///
1469   /// @param account the account in question
1470   /// @param asset the asset in question
1471   function hasExited(address account, address asset) public view returns (bool) {return data.hasExited(account, asset);}
1472 
1473   /// @notice can the entry represented by hash be used to exit?
1474   ///
1475   /// @param hash the hash of the entry to be used to exit?
1476   /// (account/asset pair is implicitly represented within hash)
1477   function canExit(bytes32 hash, uint32 gblock) public view returns (bool) {
1478     uint confirmationThreshold = data.exitClaims(hash);
1479     uint unconfirmedGblock = data.currentGblockNumber();
1480     return confirmationThreshold != 0 && unconfirmedGblock > confirmationThreshold && gblock >= confirmationThreshold && gblock < unconfirmedGblock;
1481   }
1482 
1483   /**************************************************** FraudProof ****************************************************/
1484 
1485   /// @notice can we submit a new gblock?
1486   function canSubmit() public view returns (bool) {return block.number > data.submissionBlock();}
1487 
1488   /// @notice submit a new gblock
1489   ///
1490   /// @param gblockNumber index of new gblockNumber
1491   /// @param withdrawalsRoot the gblock's withdrawals root
1492   /// @param depositsRoot the gblock's deposits root
1493   /// @param balancesRoot the gblock's balances root
1494   function submit(uint32 gblockNumber, bytes32 withdrawalsRoot, bytes32 depositsRoot, bytes32 balancesRoot) public whenOn {
1495     require(canSubmit(), "cannot submit yet");
1496     exitCounts = 0;
1497     require(msg.sender == operator, "submitter must be the operator");
1498     require(gblockNumber == data.currentGblockNumber() + 1, "gblock must be the next in sequence");
1499     data.submit(gblockNumber, withdrawalsRoot, depositsRoot, balancesRoot, submissionInterval);
1500     emit Submitted(gblockNumber, withdrawalsRoot, depositsRoot, balancesRoot);
1501   }
1502 
1503   /// @notice prove a withdrawal entry is included in a confirmed withdrawals root
1504   ///
1505   /// @param proof proof-of-inclusion for entryHash
1506   /// @param gblockNumber index of including gblock
1507   /// @param entryHash hash of entry asserted to be included
1508   function proveInConfirmedWithdrawals(bytes memory proof, uint32 gblockNumber, bytes32 entryHash) public view returns (bool) {
1509     return data.isConfirmedGblock(gblockNumber) && verifyIncluded(proof, data.withdrawalsRoot(gblockNumber), entryHash);
1510   }
1511 
1512   /// @notice prove an entry is included in the latest confirmed balances root
1513   ///
1514   /// @param proof proof-of-inclusion for entryHash
1515   /// @param entryHash hash of entry asserted to be included
1516   function proveInConfirmedBalances(bytes memory proof, bytes32 entryHash) public view returns (bool) {
1517     uint32 gblockNumber = data.currentGblockNumber() - 1;
1518     return verifyIncluded(proof, data.balancesRoot(gblockNumber), entryHash);
1519   }
1520 
1521   function parseAndValidateEntry(bytes memory entryBytes, bytes memory signature, address account) private view returns (Entry memory entry) {
1522     entry = parseEntry(entryBytes, signature);
1523     require(entry.ledgerId == id, "entry is not from current ledger");
1524     require(entry.signer == operator, "failed to verify signature");
1525     require(entry.account == account, "entry account mismatch");
1526   }
1527 
1528   /****************************************************** halting ******************************************************/
1529 
1530   /// @notice if the operator stops creating blocks for a very long time, the app is said to be abandoned
1531   function hasBeenAbandoned() public view returns (bool) {
1532     return block.number > data.submissionBlock() + abandonPoint;
1533   }
1534 
1535   /// @notice if the app is abandoned, anyone can halt the app, thus allowing everyone to transfer funds back to the main chain.
1536   function abandon() external {
1537     require(hasBeenAbandoned(), "chain has not yet abandoned");
1538     switchOff_();
1539   }
1540 
1541   function switchOff() external onlyOwner {
1542     switchOff_();
1543   }
1544 
1545   /********************************************************************************************************************/
1546 }
