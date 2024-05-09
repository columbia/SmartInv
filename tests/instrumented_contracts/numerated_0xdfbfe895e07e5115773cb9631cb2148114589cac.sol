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
357 // File: contracts/gluon/GluonExtension.sol
358 
359 pragma solidity 0.5.12;
360 
361 
362 
363 
364 /**
365   * @title the essentials of a side-chain app participating in Gluon-Plasma
366   * @dev both Logic & Data (if exists) contracts should inherit this contract
367   */
368 contract GluonExtension is Validating, GluonCentric {
369     address[] public extensions;
370     mapping(address => bool) public isExtension;
371 
372     event ExtensionAdded(address indexed extension);
373     event ExtensionRemoved(address indexed extension);
374 
375     /// @param id_ index of the app within gluon
376     /// @param gluon_ address of the Gluon contract
377     constructor(uint32 id_, address gluon_, address[] memory extensions_) GluonCentric(id_, gluon_) public {
378         for (uint i = 0; i < extensions_.length; i++) addExtension_(extensions_[i]);
379     }
380 
381     /// @notice requires the sender must be gluon or extension
382     modifier onlyGluonWallet {
383         require(gluon == msg.sender || isExtension[msg.sender], "invalid sender; must be gluon contract or one of the extension");
384         _;
385     }
386 
387     /// @notice add a extension
388     function addExtension(address extension) external onlyOwner {addExtension_(extension);}
389 
390     function addExtension_(address extension) private validAddress(extension) {
391         if (!isExtension[extension]) {
392             isExtension[extension] = true;
393             extensions.push(extension);
394             emit ExtensionAdded(extension);
395         }
396     }
397 
398     function getExtensions() public view returns (address[] memory){return extensions;}
399 }
400 
401 // File: contracts/gluon/Upgrading.sol
402 
403 pragma solidity 0.5.12;
404 
405 
406 
407 
408 contract Upgrading {
409   address public upgradeOperator;
410 
411   modifier onlyOwner { require(false, "modifier onlyOwner must be implemented"); _; }
412   modifier onlyUpgradeOperator { require(upgradeOperator == msg.sender, "invalid sender; must be upgrade operator"); _; }
413   function setUpgradeOperator(address upgradeOperator_) external onlyOwner { upgradeOperator = upgradeOperator_; }
414   function upgrade_(AppGovernance appGovernance, uint32 id) internal {
415     appGovernance.activate(id);
416     delete upgradeOperator;
417   }
418 }
419 
420 // File: contracts/apps_history/registry/OldRegistry.sol
421 
422 pragma solidity 0.5.12;
423 
424 
425 interface OldRegistry {
426   function contains(address apiKey) external view returns (bool);
427   function register(address apiKey) external;
428   function registerWithUserAgreement(address apiKey, bytes32 userAgreement) external;
429   function translate(address apiKey) external view returns (address);
430 }
431 
432 // File: contracts/apps/registry/RegistryData.sol
433 
434 pragma solidity 0.5.12;
435 
436 
437 
438 contract RegistryData is GluonCentric {
439 
440   mapping(address => address) public accounts;
441 
442   constructor(address gluon) GluonCentric(REGISTRY_INDEX, gluon) public { }
443 
444   function addKey(address apiKey, address account) external onlyCurrentLogic {
445     accounts[apiKey] = account;
446   }
447 
448 }
449 
450 // File: contracts/apps/registry/RegistryLogic.sol
451 
452 pragma solidity 0.5.12;
453 
454 
455 
456 
457 
458 
459 
460 
461 
462 
463 /**
464   * @title enabling Zero Knowledge API Keys as described in: https://blog.leverj.io/zero-knowledge-api-keys-43280cc93647
465   * @notice the Registry app consists of the RegistryLogic & RegistryData contracts.
466   * api-key registrations are held within RegistryData for an easier upgrade path.
467   * @dev although Registry enable account-based apps needing log-less logins, no app is required to use it.
468   */
469 contract RegistryLogic is Upgrading, Validating, AppLogic, AppState, GluonCentric {
470 
471   RegistryData public data;
472   OldRegistry public old;
473 
474   event Registered(address apiKey, address indexed account);
475 
476   constructor(address gluon, address old_, address data_) GluonCentric(REGISTRY_INDEX, gluon) public {
477     data = RegistryData(data_);
478     old = OldRegistry(old_);
479   }
480 
481   modifier isAbsent(address apiKey) { require(translate(apiKey) == address (0x0), "api key already in use"); _; }
482 
483   /// @notice register an api-key on behalf of the sender
484   /// @dev irreversible operation; the apiKey->sender association cannot be broken or overwritten
485   /// (but further apiKey->sender associations can be provided)
486   ///
487   /// @param apiKey the account to be used to stand-in for the registering sender
488   function register(address apiKey) external whenOn validAddress(apiKey) isAbsent(apiKey) {
489     data.addKey(apiKey, msg.sender);
490     emit Registered(apiKey, msg.sender);
491   }
492 
493   /// @notice retrieve the stand-in-for account
494   ///
495   /// @param apiKey the account to be used to stand-in for the registering sender
496   function translate(address apiKey) public view returns (address) {
497     address account = data.accounts(apiKey);
498     if (account == address(0x0)) account = old.translate(apiKey);
499     return account;
500   }
501 
502   /**************************************************** AppLogic ****************************************************/
503 
504   /// @notice upgrade the app to a new version; the approved proposal.
505   /// by the end of this call the approved proposal would be the current and active version of the app.
506   function upgrade() external onlyUpgradeOperator {
507     retire_();
508     upgrade_(AppGovernance(gluon), id);
509   }
510 
511   function credit(address, address, uint) external { revert("not supported"); }
512 
513   function debit(address, bytes calldata) external returns (address, uint) { revert("not supported"); }
514 
515   /***************************************************** AppState *****************************************************/
516 
517   /// @notice halt the app. this action is irreversible.
518   /// (the only option at this point is have a proposal that will get to approval, then activated.)
519   /// should be called by an app-owner when the app has been compromised.
520   ///
521   /// Note the constraint that all apps but Registry & Stake must be halted first!
522   function switchOff() external onlyOwner {
523     uint32 totalAppsCount = GluonView(gluon).totalAppsCount();
524     for (uint32 i = 2; i < totalAppsCount; i++) {
525       AppState appState = AppState(GluonView(gluon).current(i));
526       require(!appState.isOn(), "One of the apps is still ON");
527     }
528     switchOff_();
529   }
530 
531   /********************************************************************************************************************/
532 }
533 
534 // File: contracts/common/EvmTypes.sol
535 
536 pragma solidity 0.5.12;
537 
538 
539 contract EvmTypes {
540   uint constant internal ADDRESS = 20;
541   uint constant internal UINT8 = 1;
542   uint constant internal UINT32 = 4;
543   uint constant internal UINT64 = 8;
544   uint constant internal UINT128 = 16;
545   uint constant internal UINT256 = 32;
546   uint constant internal BYTES32 = 32;
547   uint constant internal SIGNATURE_BYTES = 65;
548 }
549 
550 // File: contracts/external/BytesLib.sol
551 
552 /*
553  * @title Solidity Bytes Arrays Utils
554  * @author Gonçalo Sá <goncalo.sa@consensys.net>
555  *
556  * @dev Bytes tightly packed arrays utility library for ethereum contracts written in Solidity.
557  *      The library lets you concatenate, slice and type cast bytes arrays both in memory and storage.
558  */
559 
560 pragma solidity 0.5.12;
561 
562 
563 library BytesLib {
564     function concat(
565         bytes memory _preBytes,
566         bytes memory _postBytes
567     )
568         internal
569         pure
570         returns (bytes memory)
571     {
572         bytes memory tempBytes;
573 
574         assembly {
575             // Get a location of some free memory and store it in tempBytes as
576             // Solidity does for memory variables.
577             tempBytes := mload(0x40)
578 
579             // Store the length of the first bytes array at the beginning of
580             // the memory for tempBytes.
581             let length := mload(_preBytes)
582             mstore(tempBytes, length)
583 
584             // Maintain a memory counter for the current write location in the
585             // temp bytes array by adding the 32 bytes for the array length to
586             // the starting location.
587             let mc := add(tempBytes, 0x20)
588             // Stop copying when the memory counter reaches the length of the
589             // first bytes array.
590             let end := add(mc, length)
591 
592             for {
593                 // Initialize a copy counter to the start of the _preBytes data,
594                 // 32 bytes into its memory.
595                 let cc := add(_preBytes, 0x20)
596             } lt(mc, end) {
597                 // Increase both counters by 32 bytes each iteration.
598                 mc := add(mc, 0x20)
599                 cc := add(cc, 0x20)
600             } {
601                 // Write the _preBytes data into the tempBytes memory 32 bytes
602                 // at a time.
603                 mstore(mc, mload(cc))
604             }
605 
606             // Add the length of _postBytes to the current length of tempBytes
607             // and store it as the new length in the first 32 bytes of the
608             // tempBytes memory.
609             length := mload(_postBytes)
610             mstore(tempBytes, add(length, mload(tempBytes)))
611 
612             // Move the memory counter back from a multiple of 0x20 to the
613             // actual end of the _preBytes data.
614             mc := end
615             // Stop copying when the memory counter reaches the new combined
616             // length of the arrays.
617             end := add(mc, length)
618 
619             for {
620                 let cc := add(_postBytes, 0x20)
621             } lt(mc, end) {
622                 mc := add(mc, 0x20)
623                 cc := add(cc, 0x20)
624             } {
625                 mstore(mc, mload(cc))
626             }
627 
628             // Update the free-memory pointer by padding our last write location
629             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
630             // next 32 byte block, then round down to the nearest multiple of
631             // 32. If the sum of the length of the two arrays is zero then add
632             // one before rounding down to leave a blank 32 bytes (the length block with 0).
633             mstore(0x40, and(
634               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
635               not(31) // Round down to the nearest 32 bytes.
636             ))
637         }
638 
639         return tempBytes;
640     }
641 
642     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
643         assembly {
644             // Read the first 32 bytes of _preBytes storage, which is the length
645             // of the array. (We don't need to use the offset into the slot
646             // because arrays use the entire slot.)
647             let fslot := sload(_preBytes_slot)
648             // Arrays of 31 bytes or less have an even value in their slot,
649             // while longer arrays have an odd value. The actual length is
650             // the slot divided by two for odd values, and the lowest order
651             // byte divided by two for even values.
652             // If the slot is even, bitwise and the slot with 255 and divide by
653             // two to get the length. If the slot is odd, bitwise and the slot
654             // with -1 and divide by two.
655             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
656             let mlength := mload(_postBytes)
657             let newlength := add(slength, mlength)
658             // slength can contain both the length and contents of the array
659             // if length < 32 bytes so let's prepare for that
660             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
661             switch add(lt(slength, 32), lt(newlength, 32))
662             case 2 {
663                 // Since the new array still fits in the slot, we just need to
664                 // update the contents of the slot.
665                 // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
666                 sstore(
667                     _preBytes_slot,
668                     // all the modifications to the slot are inside this
669                     // next block
670                     add(
671                         // we can just add to the slot contents because the
672                         // bytes we want to change are the LSBs
673                         fslot,
674                         add(
675                             mul(
676                                 div(
677                                     // load the bytes from memory
678                                     mload(add(_postBytes, 0x20)),
679                                     // zero all bytes to the right
680                                     exp(0x100, sub(32, mlength))
681                                 ),
682                                 // and now shift left the number of bytes to
683                                 // leave space for the length in the slot
684                                 exp(0x100, sub(32, newlength))
685                             ),
686                             // increase length by the double of the memory
687                             // bytes length
688                             mul(mlength, 2)
689                         )
690                     )
691                 )
692             }
693             case 1 {
694                 // The stored value fits in the slot, but the combined value
695                 // will exceed it.
696                 // get the keccak hash to get the contents of the array
697                 mstore(0x0, _preBytes_slot)
698                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
699 
700                 // save new length
701                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
702 
703                 // The contents of the _postBytes array start 32 bytes into
704                 // the structure. Our first read should obtain the `submod`
705                 // bytes that can fit into the unused space in the last word
706                 // of the stored array. To get this, we read 32 bytes starting
707                 // from `submod`, so the data we read overlaps with the array
708                 // contents by `submod` bytes. Masking the lowest-order
709                 // `submod` bytes allows us to add that value directly to the
710                 // stored value.
711 
712                 let submod := sub(32, slength)
713                 let mc := add(_postBytes, submod)
714                 let end := add(_postBytes, mlength)
715                 let mask := sub(exp(0x100, submod), 1)
716 
717                 sstore(
718                     sc,
719                     add(
720                         and(
721                             fslot,
722                             0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
723                         ),
724                         and(mload(mc), mask)
725                     )
726                 )
727 
728                 for {
729                     mc := add(mc, 0x20)
730                     sc := add(sc, 1)
731                 } lt(mc, end) {
732                     sc := add(sc, 1)
733                     mc := add(mc, 0x20)
734                 } {
735                     sstore(sc, mload(mc))
736                 }
737 
738                 mask := exp(0x100, sub(mc, end))
739 
740                 sstore(sc, mul(div(mload(mc), mask), mask))
741             }
742             default {
743                 // get the keccak hash to get the contents of the array
744                 mstore(0x0, _preBytes_slot)
745                 // Start copying to the last used word of the stored array.
746                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
747 
748                 // save new length
749                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
750 
751                 // Copy over the first `submod` bytes of the new data as in
752                 // case 1 above.
753                 let slengthmod := mod(slength, 32)
754                 let mlengthmod := mod(mlength, 32)
755                 let submod := sub(32, slengthmod)
756                 let mc := add(_postBytes, submod)
757                 let end := add(_postBytes, mlength)
758                 let mask := sub(exp(0x100, submod), 1)
759 
760                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
761 
762                 for {
763                     sc := add(sc, 1)
764                     mc := add(mc, 0x20)
765                 } lt(mc, end) {
766                     sc := add(sc, 1)
767                     mc := add(mc, 0x20)
768                 } {
769                     sstore(sc, mload(mc))
770                 }
771 
772                 mask := exp(0x100, sub(mc, end))
773 
774                 sstore(sc, mul(div(mload(mc), mask), mask))
775             }
776         }
777     }
778 
779     function slice(
780         bytes memory _bytes,
781         uint _start,
782         uint _length
783     ) internal pure returns (bytes memory)
784     {
785         require(_bytes.length >= (_start + _length));
786 
787         bytes memory tempBytes;
788 
789         assembly {
790             switch iszero(_length)
791             case 0 {
792             // Get a location of some free memory and store it in tempBytes as
793             // Solidity does for memory variables.
794                 tempBytes := mload(0x40)
795 
796             // The first word of the slice result is potentially a partial
797             // word read from the original array. To read it, we calculate
798             // the length of that partial word and start copying that many
799             // bytes into the array. The first word we copy will start with
800             // data we don't care about, but the last `lengthmod` bytes will
801             // land at the beginning of the contents of the new array. When
802             // we're done copying, we overwrite the full first word with
803             // the actual length of the slice.
804                 let lengthmod := and(_length, 31)
805 
806             // The multiplication in the next line is necessary
807             // because when slicing multiples of 32 bytes (lengthmod == 0)
808             // the following copy loop was copying the origin's length
809             // and then ending prematurely not copying everything it should.
810                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
811                 let end := add(mc, _length)
812 
813                 for {
814                 // The multiplication in the next line has the same exact purpose
815                 // as the one above.
816                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
817                 } lt(mc, end) {
818                     mc := add(mc, 0x20)
819                     cc := add(cc, 0x20)
820                 } {
821                     mstore(mc, mload(cc))
822                 }
823 
824                 mstore(tempBytes, _length)
825 
826             // update free-memory pointer
827             // allocating the array padded to 32 bytes like the compiler does now
828                 mstore(0x40, and(add(mc, 31), not(31)))
829             }
830             // if we want a zero-length slice let's just return a zero-length array
831             default {
832                 tempBytes := mload(0x40)
833 
834                 mstore(0x40, add(tempBytes, 0x20))
835             }
836         }
837 
838         return tempBytes;
839     }
840 
841     function toAddress(bytes memory _bytes, uint _start) internal  pure returns (address) {
842         require(_bytes.length >= (_start + 20));
843         address tempAddress;
844         assembly {
845             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
846         }
847         return tempAddress;
848     }
849 
850     function toUint8(bytes memory _bytes, uint _start) internal  pure returns (uint8) {
851         require(_bytes.length >= (_start + 1));
852         uint8 tempUint;
853         assembly {
854             tempUint := mload(add(add(_bytes, 0x1), _start))
855         }
856         return tempUint;
857     }
858 
859     function toUint16(bytes memory _bytes, uint _start) internal  pure returns (uint16) {
860         require(_bytes.length >= (_start + 2));
861         uint16 tempUint;
862         assembly {
863             tempUint := mload(add(add(_bytes, 0x2), _start))
864         }
865         return tempUint;
866     }
867 
868     function toUint32(bytes memory _bytes, uint _start) internal  pure returns (uint32) {
869         require(_bytes.length >= (_start + 4));
870         uint32 tempUint;
871         assembly {
872             tempUint := mload(add(add(_bytes, 0x4), _start))
873         }
874         return tempUint;
875     }
876 
877     function toUint64(bytes memory _bytes, uint _start) internal  pure returns (uint64) {
878         require(_bytes.length >= (_start + 8));
879         uint64 tempUint;
880         assembly {
881             tempUint := mload(add(add(_bytes, 0x8), _start))
882         }
883         return tempUint;
884     }
885 
886     function toUint96(bytes memory _bytes, uint _start) internal  pure returns (uint96) {
887         require(_bytes.length >= (_start + 12));
888         uint96 tempUint;
889         assembly {
890             tempUint := mload(add(add(_bytes, 0xc), _start))
891         }
892         return tempUint;
893     }
894 
895     function toUint128(bytes memory _bytes, uint _start) internal  pure returns (uint128) {
896         require(_bytes.length >= (_start + 16));
897         uint128 tempUint;
898         assembly {
899             tempUint := mload(add(add(_bytes, 0x10), _start))
900         }
901         return tempUint;
902     }
903 
904     function toUint(bytes memory _bytes, uint _start) internal  pure returns (uint256) {
905         require(_bytes.length >= (_start + 32));
906         uint256 tempUint;
907         assembly {
908             tempUint := mload(add(add(_bytes, 0x20), _start))
909         }
910         return tempUint;
911     }
912 
913     function toBytes32(bytes memory _bytes, uint _start) internal  pure returns (bytes32) {
914         require(_bytes.length >= (_start + 32));
915         bytes32 tempBytes32;
916         assembly {
917             tempBytes32 := mload(add(add(_bytes, 0x20), _start))
918         }
919         return tempBytes32;
920     }
921 
922     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
923         bool success = true;
924 
925         assembly {
926             let length := mload(_preBytes)
927 
928             // if lengths don't match the arrays are not equal
929             switch eq(length, mload(_postBytes))
930             case 1 {
931                 // cb is a circuit breaker in the for loop since there's
932                 //  no said feature for inline assembly loops
933                 // cb = 1 - don't breaker
934                 // cb = 0 - break
935                 let cb := 1
936 
937                 let mc := add(_preBytes, 0x20)
938                 let end := add(mc, length)
939 
940                 for {
941                     let cc := add(_postBytes, 0x20)
942                 // the next line is the loop condition:
943                 // while(uint(mc < end) + cb == 2)
944                 } eq(add(lt(mc, end), cb), 2) {
945                     mc := add(mc, 0x20)
946                     cc := add(cc, 0x20)
947                 } {
948                     // if any of these checks fails then arrays are not equal
949                     if iszero(eq(mload(mc), mload(cc))) {
950                         // unsuccess:
951                         success := 0
952                         cb := 0
953                     }
954                 }
955             }
956             default {
957                 // unsuccess:
958                 success := 0
959             }
960         }
961 
962         return success;
963     }
964 
965     function equalStorage(
966         bytes storage _preBytes,
967         bytes memory _postBytes
968     )
969         internal
970         view
971         returns (bool)
972     {
973         bool success = true;
974 
975         assembly {
976             // we know _preBytes_offset is 0
977             let fslot := sload(_preBytes_slot)
978             // Decode the length of the stored array like in concatStorage().
979             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
980             let mlength := mload(_postBytes)
981 
982             // if lengths don't match the arrays are not equal
983             switch eq(slength, mlength)
984             case 1 {
985                 // slength can contain both the length and contents of the array
986                 // if length < 32 bytes so let's prepare for that
987                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
988                 if iszero(iszero(slength)) {
989                     switch lt(slength, 32)
990                     case 1 {
991                         // blank the last byte which is the length
992                         fslot := mul(div(fslot, 0x100), 0x100)
993 
994                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
995                             // unsuccess:
996                             success := 0
997                         }
998                     }
999                     default {
1000                         // cb is a circuit breaker in the for loop since there's
1001                         //  no said feature for inline assembly loops
1002                         // cb = 1 - don't breaker
1003                         // cb = 0 - break
1004                         let cb := 1
1005 
1006                         // get the keccak hash to get the contents of the array
1007                         mstore(0x0, _preBytes_slot)
1008                         let sc := keccak256(0x0, 0x20)
1009 
1010                         let mc := add(_postBytes, 0x20)
1011                         let end := add(mc, mlength)
1012 
1013                         // the next line is the loop condition:
1014                         // while(uint(mc < end) + cb == 2)
1015                         for {} eq(add(lt(mc, end), cb), 2) {
1016                             sc := add(sc, 1)
1017                             mc := add(mc, 0x20)
1018                         } {
1019                             if iszero(eq(sload(sc), mload(mc))) {
1020                                 // unsuccess:
1021                                 success := 0
1022                                 cb := 0
1023                             }
1024                         }
1025                     }
1026                 }
1027             }
1028             default {
1029                 // unsuccess:
1030                 success := 0
1031             }
1032         }
1033 
1034         return success;
1035     }
1036 }
1037 
1038 // File: contracts/external/Cryptography.sol
1039 
1040 pragma solidity 0.5.12;
1041 
1042 
1043 contract Cryptography {
1044 
1045   /**
1046   * @dev Recover signer address from a message by using their signature
1047   * @param hash message, the hash is the signed message. What is recovered is the signer address.
1048   * @param signature generated using web3.eth.account.sign().signature
1049   *
1050   * Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
1051   * TODO: Remove this library once solidity supports passing a signature to ecrecover.
1052   * See https://github.com/ethereum/solidity/issues/864
1053   */
1054   function recover(bytes32 hash, bytes memory signature) public pure returns (address) {
1055     bytes32 r;
1056     bytes32 s;
1057     uint8 v;
1058     if (signature.length != 65) return (address(0x0));
1059     // Check the signature length
1060 
1061     // Divide the signature into r, s and v variables
1062     assembly {
1063       r := mload(add(signature, 32))
1064       s := mload(add(signature, 64))
1065       v := byte(0, mload(add(signature, 96)))
1066     }
1067 
1068     // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
1069     if (v < 27) v += 27;
1070 
1071     // If the version is correct return the signer address
1072     return (v != 27 && v != 28) ? (address(0)) : ecrecover(hash, v, r, s);
1073   }
1074 
1075 }
1076 
1077 // File: contracts/apps/derivatives/WithEntry.sol
1078 
1079 pragma solidity 0.5.12;
1080 
1081 
1082 
1083 
1084 
1085 /// @title unpacking ledger Entry from bytes
1086 contract WithEntry is EvmTypes, Cryptography {
1087   using BytesLib for bytes;
1088 
1089   struct Entry {
1090     uint32 ledgerId;
1091     address account;
1092     address asset;
1093     uint32 instrument;
1094     EntryType entryType;
1095     uint8 action;
1096     uint timestamp;
1097     uint quantity;
1098     uint balance;
1099     Position position;
1100     uint notional;
1101     uint instrumentMargin;
1102     uint margin;
1103     uint128 previous;
1104     uint128 instrumentPrevious;
1105     uint32 gblockNumber;
1106     bytes32 hash;
1107     bytes32 dataHash;
1108     bytes signature;
1109     address signer;
1110     bytes dataBytes;
1111   }
1112 
1113   struct Position {
1114     uint8 sign;
1115     uint64 numerator;
1116     uint64 denominator;
1117   }
1118 
1119   uint constant private VERSION = 0;
1120   uint constant private LEDGER_ID = VERSION + UINT8;
1121   uint constant private ACCOUNT = LEDGER_ID + UINT32;
1122   uint constant private ASSET = ACCOUNT + ADDRESS;
1123   uint constant private INSTRUMENT = ASSET + ADDRESS;
1124   uint constant private ENTRY_TYPE = INSTRUMENT + UINT32;
1125   uint constant private ACTION = ENTRY_TYPE + UINT8;
1126   uint constant private TIMESTAMP = ACTION + UINT8;
1127   uint constant private QUANTITY = TIMESTAMP + UINT64;
1128   uint constant private BALANCE = QUANTITY + UINT256;
1129   uint constant private NOTIONAL = BALANCE + UINT256;
1130   uint constant private INSTRUMENT_MARGIN = NOTIONAL + UINT256;
1131   uint constant private MARGIN = INSTRUMENT_MARGIN + UINT256;
1132   uint constant private PREVIOUS = MARGIN + UINT256;
1133   uint constant private INSTRUMENT_PREVIOUS = PREVIOUS + UINT128;
1134   uint constant private GBLOCK_NUMBER = INSTRUMENT_PREVIOUS + UINT128;
1135   uint constant private SIGN = GBLOCK_NUMBER + UINT32;
1136   uint constant private NUMERATOR = SIGN + UINT8;
1137   uint constant private DENOMINATOR = NUMERATOR + UINT64;
1138   uint constant private DATA_HASH = DENOMINATOR + UINT64;
1139   uint constant private ENTRY_LENGTH = DATA_HASH + BYTES32;
1140 
1141   enum EntryType {Unknown, Origin, Deposit, Withdrawal, Exited, Trade, Fee, Margin, Liquidation, Deleverage, Funding, RedeemMargin, Transfer}
1142 
1143   function parseEntry(bytes memory parameters, bytes memory signature) internal pure returns (Entry memory result) {
1144     result.ledgerId = parameters.toUint32(LEDGER_ID);
1145     result.account = parameters.toAddress(ACCOUNT);
1146     result.asset = parameters.toAddress(ASSET);
1147     result.instrument = parameters.toUint32(INSTRUMENT);
1148     result.entryType = EntryType(parameters.toUint8(ENTRY_TYPE));
1149     result.action = parameters.toUint8(ACTION);
1150     result.timestamp = parameters.toUint64(TIMESTAMP);
1151     result.quantity = parameters.toUint(QUANTITY);
1152     result.balance = parameters.toUint(BALANCE);
1153     result.notional = parameters.toUint(NOTIONAL);
1154     result.instrumentMargin = parameters.toUint(INSTRUMENT_MARGIN);
1155     result.margin = parameters.toUint(MARGIN);
1156     result.previous = parameters.toUint128(PREVIOUS);
1157     result.instrumentPrevious = parameters.toUint128(INSTRUMENT_PREVIOUS);
1158     result.gblockNumber = parameters.toUint32(GBLOCK_NUMBER);
1159     result.dataHash = parameters.toBytes32(DATA_HASH);
1160     result.position = Position(parameters.toUint8(SIGN), parameters.toUint64(NUMERATOR), parameters.toUint64(DENOMINATOR));
1161     bytes memory entryBytes = parameters;
1162     if (parameters.length > ENTRY_LENGTH) {
1163       result.dataBytes = parameters.slice(ENTRY_LENGTH, parameters.length - ENTRY_LENGTH);
1164       require(result.dataHash == keccak256(result.dataBytes), "data hash mismatch");
1165       entryBytes = parameters.slice(0, ENTRY_LENGTH);
1166     }
1167     result.hash = keccak256(entryBytes);
1168     result.signer = recover(result.hash, signature);
1169   }
1170 
1171 }
1172 
1173 // File: contracts/apps/derivatives/DerivativesData.sol
1174 
1175 pragma solidity 0.5.12;
1176 
1177 
1178 
1179 contract DerivativesData is GluonCentric {
1180 
1181   struct Gblock {
1182     bytes32 withdrawalsRoot;
1183     bytes32 depositsRoot;
1184     bytes32 balancesRoot;
1185   }
1186 
1187   uint public constant name = uint(keccak256("DerivativesData"));
1188   uint32 public nonce = 0;
1189   uint32 public currentGblockNumber;
1190   uint public submissionBlock = block.number;
1191   mapping(uint32 => Gblock) public gblocksByNumber;
1192   mapping(bytes32 => bool) public deposits;
1193   mapping(bytes32 => bool) public withdrawn;
1194   mapping(bytes32 => uint) public exitClaims; // exit entry hash => confirmationThreshold
1195   mapping(address => mapping(address => bool)) public exited; // account => asset => has exited
1196 
1197   constructor(uint32 id, address gluon) GluonCentric(id, gluon) public { }
1198 
1199   function deposit(bytes32 hash) external onlyCurrentLogic { deposits[hash] = true; }
1200 
1201   function deleteDeposit(bytes32 hash) external onlyCurrentLogic {
1202     require(deposits[hash], "unknown deposit");
1203     delete deposits[hash];
1204   }
1205 
1206   function nextNonce() external onlyCurrentLogic returns (uint32) { return ++nonce; }
1207 
1208   function markExited(address account, address asset) external onlyCurrentLogic { exited[account][asset] = true; }
1209 
1210   function markWithdrawn(bytes32 hash) external onlyCurrentLogic {withdrawn[hash] = true;}
1211 
1212   function hasExited(address account, address asset) external view returns (bool) { return exited[account][asset]; }
1213 
1214   function hasWithdrawn(bytes32 hash) external view returns (bool) { return withdrawn[hash]; }
1215 
1216   function markExitClaim(bytes32 hash, uint confirmationThreshold) external onlyCurrentLogic { exitClaims[hash] = confirmationThreshold; }
1217 
1218   function deleteExitClaim(bytes32 hash) external onlyCurrentLogic { delete exitClaims[hash]; }
1219 
1220   function submit(uint32 gblockNumber, bytes32 withdrawalsRoot, bytes32 depositsRoot, bytes32 balancesRoot, uint submissionInterval) external onlyCurrentLogic {
1221     Gblock memory gblock = Gblock(withdrawalsRoot, depositsRoot, balancesRoot);
1222     gblocksByNumber[gblockNumber] = gblock;
1223     currentGblockNumber = gblockNumber;
1224     submissionBlock = block.number + submissionInterval;
1225   }
1226 
1227   function updateSubmissionBlock(uint submissionBlock_) external onlyCurrentLogic { submissionBlock = submissionBlock_; }
1228 
1229   function depositsRoot(uint32 gblockNumber) external view returns (bytes32) { return gblocksByNumber[gblockNumber].depositsRoot; }
1230 
1231   function withdrawalsRoot(uint32 gblockNumber) external view returns (bytes32) { return gblocksByNumber[gblockNumber].withdrawalsRoot; }
1232 
1233   function balancesRoot(uint32 gblockNumber) external view returns (bytes32) { return gblocksByNumber[gblockNumber].balancesRoot; }
1234 
1235   function isConfirmedGblock(uint32 gblockNumber) external view returns (bool) { return gblockNumber > 0 && gblockNumber < currentGblockNumber; }
1236 
1237 }
1238 
1239 // File: contracts/apps/common/WithDepositCommitmentRecord.sol
1240 
1241 pragma solidity 0.5.12;
1242 
1243 
1244 
1245 
1246 /// @title unpacking DepositCommitmentRecord from bytes
1247 contract WithDepositCommitmentRecord is EvmTypes {
1248   using BytesLib for bytes;
1249 
1250   struct DepositCommitmentRecord {
1251     uint32 ledgerId;
1252     address account;
1253     address asset;
1254     uint quantity;
1255     uint32 nonce;
1256     uint32 designatedGblock;
1257     bytes32 hash;
1258   }
1259 
1260   uint constant private LEDGER_ID = 0;
1261   uint constant private ACCOUNT = LEDGER_ID + UINT32;
1262   uint constant private ASSET = ACCOUNT + ADDRESS;
1263   uint constant private QUANTITY = ASSET + ADDRESS;
1264   uint constant private NONCE = QUANTITY + UINT256;
1265   uint constant private DESIGNATED_GBLOCK = NONCE + UINT32;
1266 
1267   function parseDepositCommitmentRecord(bytes memory parameters) internal pure returns (DepositCommitmentRecord memory result) {
1268     result.ledgerId = parameters.toUint32(LEDGER_ID);
1269     result.account = parameters.toAddress(ACCOUNT);
1270     result.asset = parameters.toAddress(ASSET);
1271     result.quantity = parameters.toUint(QUANTITY);
1272     result.nonce = parameters.toUint32(NONCE);
1273     result.designatedGblock = parameters.toUint32(DESIGNATED_GBLOCK);
1274     result.hash = keccak256(encodePackedDeposit(result.ledgerId, result.account, result.asset, result.quantity, result.nonce, result.designatedGblock));
1275   }
1276 
1277   function encodePackedDeposit(uint32 ledgerId, address account, address asset, uint quantity, uint32 nonce, uint32 designatedGblock) public pure returns(bytes memory) {
1278     return abi.encodePacked(ledgerId, account, asset, quantity, nonce, designatedGblock);
1279   }
1280 }
1281 
1282 // File: contracts/apps/derivatives/DerivativesLogic.sol
1283 
1284 pragma solidity 0.5.12;
1285 
1286 
1287 
1288 
1289 
1290 
1291 
1292 
1293 
1294 
1295 
1296 
1297 
1298 
1299 
1300 
1301 /**
1302   * @title enabling the Leverj Derivatives DEX
1303   * @notice the Spot app consists of the DerivativesLogic & DerivativesData contracts
1304   * Gblocks related data and withdrawals tracking data are held within DerivativesData for an easier upgrade path.
1305   *
1306   * the Stake app enables:
1307   * - account/asset based bookkeeping via an off-chain ledger
1308   * - periodic submission of merkle-tree roots of the off-chain ledger
1309   * - fraud-proofs based security of account/asset withdrawals
1310   * - account based AML
1311   * in-depth details and reasoning are detailed in: https://leverj.io/GluonPlasma.pdf
1312   */
1313 contract DerivativesLogic is Upgrading, Validating, MerkleProof, AppLogic, AppState, GluonExtension, WithDepositCommitmentRecord, WithEntry, SubChain {
1314   using SafeMath for uint;
1315 
1316   struct ProofOfInclusionAtIndex {
1317     bytes32 leaf;
1318     uint index;
1319     bytes proof;
1320   }
1321 
1322   struct ProofOfExclusionOfDeposit {
1323     ProofOfInclusionAtIndex predecessor;
1324     ProofOfInclusionAtIndex successor;
1325   }
1326 
1327   uint8 public constant confirmationDelay = 5;
1328   uint8 public constant visibilityDelay = 1;
1329   uint32 public constant nullInstrument = 0;
1330   uint private constant ASSISTED_WITHDRAW = 1;
1331   uint private constant RECLAIM_DEPOSIT = 2;
1332   uint private constant CLAIM_EXIT = 3;
1333   uint private constant EXIT = 4;
1334   uint private constant EXIT_ON_HALT = 5;
1335   uint private constant RECLAIM_DEPOSIT_ON_HALT = 6;
1336   uint private constant MAX_EXIT_COUNT = 100;
1337   uint public constant name = uint(keccak256("DerivativesLogic"));
1338 
1339   DerivativesData public data;
1340   address public operator;
1341   uint public submissionInterval;
1342   uint public abandonPoint;
1343   uint32 public exitCounts = 0;
1344 
1345   event Deposited(address indexed account, address indexed asset, uint quantity, uint32 nonce, uint32 designatedGblock);
1346   event DepositReclaimed(address indexed account, address indexed asset, uint quantity, uint32 nonce);
1347   event ExitClaimed(bytes32 hash, address indexed account, address indexed asset, uint confirmationThreshold);
1348   event Exited(address indexed account, address indexed asset, uint quantity);
1349   event Withdrawn(bytes32 hash, address indexed account, address indexed asset, uint quantity);
1350   event Submitted(uint32 gblockNumber, bytes32 withdrawalsRoot, bytes32 depositsRoot, bytes32 balancesRoot);
1351 
1352   constructor(uint32 id, address gluon, address data_, address operator_, uint submissionInterval_, uint abandonPoint_, address[] memory extensions) GluonExtension(id, gluon, extensions) public validAddress(gluon) validAddress(operator_) {
1353     operator = operator_;
1354     submissionInterval = submissionInterval_;
1355     data = DerivativesData(data_);
1356     abandonPoint = abandonPoint_;
1357   }
1358 
1359   /**************************************************** AppLogic ****************************************************/
1360 
1361   function upgrade() external whenOn onlyUpgradeOperator {
1362     require(canSubmit(), "cannot upgrade yet");
1363     (, address proposal,) = GluonView(gluon).app(id);
1364     address[] memory logics = GluonView(gluon).history(id);
1365     require(proposal != address(this), "can not be the same contract");
1366     require(DerivativesLogic(proposal).id() == id, "invalid app id");
1367     for (uint i = 0; i < logics.length; i++) {
1368       require(proposal != logics[i], "can not be old contract");
1369     }
1370     require(DerivativesLogic(proposal).name() == name, "proposal name is different");
1371     retire_();
1372     upgrade_(AppGovernance(gluon), id);
1373   }
1374 
1375   function credit(address account, address asset, uint quantity) external whenOn onlyGluonWallet {
1376     require(!data.hasExited(account, asset), "previously exited");
1377     uint32 nonce = data.nextNonce();
1378     uint32 designatedGblock = data.currentGblockNumber() + visibilityDelay;
1379     bytes32 hash = keccak256(abi.encodePacked(id, account, asset, quantity, nonce, designatedGblock));
1380     data.deposit(hash);
1381     emit Deposited(account, asset, quantity, nonce, designatedGblock);
1382   }
1383 
1384   function debit(address account, bytes calldata parameters) external onlyGluonWallet returns (address asset, uint quantity) {
1385     uint action = parameters.toUint(0);
1386     if (action == ASSISTED_WITHDRAW) return assistedWithdraw(account, parameters);
1387     else if (action == RECLAIM_DEPOSIT) return reclaimDeposit(account, parameters);
1388     else if (action == CLAIM_EXIT) return claimExit(account, parameters);
1389     else if (action == EXIT) return exit(account, parameters);
1390     else if (action == EXIT_ON_HALT) return exitOnHalt(account, parameters);
1391     else if (action == RECLAIM_DEPOSIT_ON_HALT) return reclaimDepositOnHalt(account, parameters);
1392     else revert("invalid action");
1393   }
1394 
1395   /**************************************************** Depositing ****************************************************/
1396 
1397   /// @notice if a Deposit is not included in the Ledger, reclaim it using a proof-of-exclusion
1398   /// @dev Deposited events must be listened to, and a corresponding Deposit entry should be created with the event's data as the witness
1399   ///
1400   /// @param account the claimant
1401   /// @param parameters packed proof-of-exclusion of deposit
1402   function reclaimDeposit(address account, bytes memory parameters) private whenOn returns (address asset, uint quantity) {
1403     (, bytes memory recordParameters, bytes memory proofBytes1, bytes memory proofBytes2) = abi.decode(parameters, (uint, bytes, bytes, bytes));
1404     DepositCommitmentRecord memory record = parseAndValidateDepositCommitmentRecord(account, recordParameters);
1405     require(data.currentGblockNumber() > record.designatedGblock + 1 && record.designatedGblock != 0, "designated gblock is unconfirmed or unknown");
1406     require(proveIsExcludedFromDeposits(record, data.depositsRoot(record.designatedGblock), proofBytes1), "failed to proof exclusion of deposit");
1407     require(proveIsExcludedFromDeposits(record, data.depositsRoot(record.designatedGblock + 1), proofBytes2), "failed to proof exclusion of deposit");
1408     return reclaimDeposit_(record);
1409   }
1410 
1411   function parseAndValidateDepositCommitmentRecord(address account, bytes memory commitmentRecord) private view returns (DepositCommitmentRecord memory record){
1412     record = parseDepositCommitmentRecord(commitmentRecord);
1413     require(record.ledgerId == id, "not from current ledger");
1414     require(record.account == account, "claimant must be the original depositor");
1415   }
1416 
1417   function proveIsExcludedFromDeposits(DepositCommitmentRecord memory record, bytes32 root, bytes memory proofBytes) private pure returns (bool) {
1418     ProofOfExclusionOfDeposit memory proof = extractProofOfExclusionOfDeposit(proofBytes);
1419     return proof.successor.index == proof.predecessor.index + 1 && // predecessor & successor must be consecutive
1420     proof.successor.leaf > record.hash &&
1421     proof.predecessor.leaf < record.hash &&
1422     verifyIncludedAtIndex(proof.predecessor.proof, root, proof.predecessor.leaf, proof.predecessor.index) &&
1423     verifyIncludedAtIndex(proof.successor.proof, root, proof.successor.leaf, proof.successor.index);
1424   }
1425 
1426   function reclaimDepositOnHalt(address account, bytes memory parameters) private whenOff returns (address asset, uint quantity) {
1427     (, bytes memory commitmentRecord, bytes memory proofBytes1, bytes memory proofBytes2) = abi.decode(parameters, (uint, bytes, bytes, bytes));
1428     DepositCommitmentRecord memory record = parseAndValidateDepositCommitmentRecord(account, commitmentRecord);
1429     if (data.currentGblockNumber() > record.designatedGblock) {
1430       require(proveIsExcludedFromDeposits(record, data.depositsRoot(record.designatedGblock), proofBytes1), "failed to proof exclusion of deposit");
1431     }
1432     if (data.currentGblockNumber() > record.designatedGblock + 1) {
1433       require(proveIsExcludedFromDeposits(record, data.depositsRoot(record.designatedGblock + 1), proofBytes2), "failed to proof exclusion of deposit");
1434     }
1435     return reclaimDeposit_(record);
1436   }
1437 
1438   function encodedDepositOnHaltParameters(address account, address asset, uint quantity, uint32 nonce, uint32 designatedGblock) external view returns (bytes memory) {
1439     bytes memory encodedPackedDeposit = encodePackedDeposit(id, account, asset, quantity, nonce, designatedGblock);
1440     return abi.encode(RECLAIM_DEPOSIT_ON_HALT, encodedPackedDeposit);
1441   }
1442 
1443   function reclaimDeposit_(DepositCommitmentRecord memory record) private returns (address asset, uint quantity) {
1444     data.deleteDeposit(record.hash);
1445     emit DepositReclaimed(record.account, record.asset, record.quantity, record.nonce);
1446     return (record.asset, record.quantity);
1447   }
1448 
1449   function extractProofOfExclusionOfDeposit(bytes memory proofBytes) private pure returns (ProofOfExclusionOfDeposit memory result) {
1450     (bytes32[] memory leaves, uint[] memory indexes, bytes memory predecessor, bytes memory successor) = abi.decode(proofBytes, (bytes32[], uint[], bytes, bytes));
1451     result = ProofOfExclusionOfDeposit(ProofOfInclusionAtIndex(leaves[0], indexes[0], predecessor), ProofOfInclusionAtIndex(leaves[1], indexes[1], successor));
1452   }
1453 
1454   /**************************************************** Withdrawing ***************************************************/
1455 
1456   function assistedWithdraw(address account, bytes memory parameters) private returns (address asset, uint quantity) {
1457     (, bytes memory entryBytes, bytes memory signature, bytes memory proof) = abi.decode(parameters, (uint, bytes, bytes, bytes));
1458     Entry memory entry = parseAndValidateEntry(entryBytes, signature, account);
1459     require(entry.entryType == EntryType.Withdrawal, "entry must be of type Withdrawal");
1460     require(proveInConfirmedWithdrawals(proof, entry.gblockNumber, entry.hash), "invalid entry proof");
1461     require(!data.hasWithdrawn(entry.hash), "entry already withdrawn");
1462     data.markWithdrawn(entry.hash);
1463     emit Withdrawn(entry.hash, entry.account, entry.asset, entry.quantity);
1464     return (entry.asset, entry.quantity);
1465   }
1466 
1467   function claimExit(address account, bytes memory parameters) private whenOn returns (address asset, uint quantity) {
1468     require(!isSubChain[account], 'subChain prohibited');
1469     (, address asset_) = abi.decode(parameters, (uint, address));
1470     require(!hasExited(account, asset_), "previously exited");
1471     bytes32 hash = keccak256(abi.encodePacked(account, asset_));
1472     require(data.exitClaims(hash) == 0, "previously claimed exit");
1473     require(exitCounts < MAX_EXIT_COUNT, 'MAX_EXIT EXCEEDED');
1474     exitCounts = exitCounts + 1;
1475     uint confirmationThreshold = data.currentGblockNumber() + confirmationDelay;
1476     data.markExitClaim(hash, confirmationThreshold);
1477     emit ExitClaimed(hash, account, asset_, confirmationThreshold);
1478     return (asset, 0);
1479   }
1480 
1481   function exit(address account, bytes memory parameters) private whenOn returns (address asset, uint quantity) {
1482     require(!isSubChain[account], 'subChain prohibited');
1483     (, bytes memory entry_, bytes memory signature, bytes memory proof, uint32 gblockNumber) = abi.decode(parameters, (uint, bytes, bytes, bytes, uint32));
1484     Entry memory entry = parseAndValidateEntry(entry_, signature, account);
1485     require(!hasExited(entry.account, entry.asset), "previously exited");
1486     bytes32 hash = keccak256(abi.encodePacked(entry.account, entry.asset));
1487     require(canExit(hash, gblockNumber), "no prior claim found to withdraw OR balances are yet to be confirmed");
1488     require(verifyIncluded(proof, data.balancesRoot(gblockNumber), entry.hash), "invalid balance proof");
1489     if (entry.margin == 0) {
1490       data.deleteExitClaim(hash);
1491       data.markExited(entry.account, entry.asset);
1492       emit Exited(entry.account, entry.asset, entry.balance);
1493       return (entry.asset, entry.balance);
1494     } else {
1495       switchOff_();
1496       return (entry.asset, 0);
1497     }
1498   }
1499 
1500   function exitOnHalt(address account, bytes memory parameters) private whenOff returns (address asset, uint quantity) {
1501     (, bytes memory entry_, bytes memory signature, bytes memory proof) = abi.decode(parameters, (uint, bytes, bytes, bytes));
1502     Entry memory entry = parseAndValidateEntry(entry_, signature, account);
1503     require(!hasExited(entry.account, entry.asset), "previously exited");
1504     require(proveInConfirmedBalances(proof, entry.hash), "invalid balance proof");
1505     data.markExited(entry.account, entry.asset);
1506     uint balance = entry.balance.plus(entry.margin);
1507     emit Exited(entry.account, entry.asset, balance);
1508     return (entry.asset, balance);
1509   }
1510 
1511   /// @notice has the account/asset pair already claimed and exited?
1512   ///
1513   /// @param account the account in question
1514   /// @param asset the asset in question
1515   function hasExited(address account, address asset) public view returns (bool) {return data.hasExited(account, asset);}
1516 
1517   /// @notice can the entry represented by hash be used to exit?
1518   ///
1519   /// @param hash the hash of the entry to be used to exit?
1520   /// (account/asset pair is implicitly represented within hash)
1521   function canExit(bytes32 hash, uint32 gblock) public view returns (bool) {
1522     uint confirmationThreshold = data.exitClaims(hash);
1523     uint unconfirmedGblock = data.currentGblockNumber();
1524     return confirmationThreshold != 0 && unconfirmedGblock > confirmationThreshold && gblock >= confirmationThreshold && gblock < unconfirmedGblock;
1525   }
1526 
1527   /**************************************************** FraudProof ****************************************************/
1528 
1529   /// @notice can we submit a new gblock?
1530   function canSubmit() public view returns (bool) {return block.number > data.submissionBlock();}
1531 
1532   /// @notice submit a new gblock
1533   ///
1534   /// @param gblockNumber index of new gblockNumber
1535   /// @param withdrawalsRoot the gblock's withdrawals root
1536   /// @param depositsRoot the gblock's deposits root
1537   /// @param balancesRoot the gblock's balances root
1538   function submit(uint32 gblockNumber, bytes32 withdrawalsRoot, bytes32 depositsRoot, bytes32 balancesRoot) public whenOn {
1539     require(canSubmit(), "cannot submit yet");
1540     exitCounts = 0;
1541     require(msg.sender == operator, "submitter must be the operator");
1542     require(gblockNumber == data.currentGblockNumber() + 1, "gblock must be the next in sequence");
1543     data.submit(gblockNumber, withdrawalsRoot, depositsRoot, balancesRoot, submissionInterval);
1544     emit Submitted(gblockNumber, withdrawalsRoot, depositsRoot, balancesRoot);
1545   }
1546 
1547   /// @notice prove a withdrawal entry is included in a confirmed withdrawals root
1548   ///
1549   /// @param proof proof-of-inclusion for entryHash
1550   /// @param gblockNumber index of including gblock
1551   /// @param entryHash hash of entry asserted to be included
1552   function proveInConfirmedWithdrawals(bytes memory proof, uint32 gblockNumber, bytes32 entryHash) public view returns (bool) {
1553     return data.isConfirmedGblock(gblockNumber) && verifyIncluded(proof, data.withdrawalsRoot(gblockNumber), entryHash);
1554   }
1555 
1556   /// @notice prove an entry is included in the latest confirmed balances root
1557   ///
1558   /// @param proof proof-of-inclusion for entryHash
1559   /// @param entryHash hash of entry asserted to be included
1560   function proveInConfirmedBalances(bytes memory proof, bytes32 entryHash) public view returns (bool) {
1561     uint32 gblockNumber = data.currentGblockNumber() - 1;
1562     return verifyIncluded(proof, data.balancesRoot(gblockNumber), entryHash);
1563   }
1564 
1565   function parseAndValidateEntry(bytes memory entryBytes, bytes memory signature, address account) private view returns (Entry memory entry) {
1566     entry = parseEntry(entryBytes, signature);
1567     require(entry.ledgerId == id, "entry is not from current ledger");
1568     require(entry.signer == operator, "failed to verify signature");
1569     require(entry.account == account, "entry account mismatch");
1570   }
1571 
1572   /****************************************************** halting ******************************************************/
1573 
1574   /// @notice if the operator stops creating blocks for a very long time, the app is said to be abandoned
1575   function hasBeenAbandoned() public view returns (bool) {
1576     return block.number > data.submissionBlock() + abandonPoint;
1577   }
1578 
1579   /// @notice if the app is abandoned, anyone can halt the app, thus allowing everyone to transfer funds back to the main chain.
1580   function abandon() external {
1581     require(hasBeenAbandoned(), "chain has not yet abandoned");
1582     switchOff_();
1583   }
1584 
1585   function switchOff() external onlyOwner {
1586     switchOff_();
1587   }
1588 
1589   /********************************************************************************************************************/
1590 }
