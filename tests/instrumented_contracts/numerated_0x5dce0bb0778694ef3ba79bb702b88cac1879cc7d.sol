1 // SPDX-License-Identifier: VPL - VIRAL PUBLIC LICENSE
2 pragma solidity ^0.8.13;
3 
4 /*
5 *  bbbbbbbb                                                                              
6 *  b::::::b                                                  
7 *  b::::::b                                                
8 *  b::::::b                                               
9 *   b:::::b                                               
10 *   b:::::bbbbbbbbb       ooooooooooo   nnnn  nnnnnnnn      
11 *   b::::::::::::::bb   oo:::::::::::oo n:::nn::::::::nn    
12 *   b::::::::::::::::b o:::::::::::::::on::::::::::::::nn    
13 *   b:::::bbbbb:::::::bo:::::ooooo:::::onn:::::::::::::::n    
14 *   b:::::b    b::::::bo::::o     o::::o  n:::::nnnn:::::n      
15 *   b:::::b     b:::::bo::::o     o::::o  n::::n    n::::n  
16 *   b:::::b     b:::::bo::::o     o::::o  n::::n    n::::n  
17 *   b:::::b     b:::::bo::::o     o::::o  n::::n    n::::n
18 *   b:::::bbbbbb::::::bo:::::ooooo:::::o  n::::n    n::::n
19 *   b::::::::::::::::b o:::::::::::::::o  n::::n    n::::n
20 *   b:::::::::::::::b   oo:::::::::::oo   n::::n    n::::n
21 *   bbbbbbbbbbbbbbbb      ooooooooooo     nnnnnn    nnnnnn
22 *                         SSSSSSSSSSSSSSS              AAA               IIIIIIIIII
23 *                       SS:::::::::::::::S            A:::A              I::::::::I
24 *                      S:::::SSSSSS::::::S           A:::::A             I::::::::I
25 *                      S:::::S     SSSSSSS          A:::::::A            II::::::II
26 *                      S:::::S                     A:::::::::A             I::::I  
27 *                      S:::::S                    A:::::A:::::A            I::::I  
28 *                       S::::SSSS                A:::::A A:::::A           I::::I  
29 *                        SS::::::SSSSS          A:::::A   A:::::A          I::::I  
30 *                          SSS::::::::SS       A:::::A     A:::::A         I::::I  
31 *                             SSSSSS::::S     A:::::AAAAAAAAA:::::A        I::::I  
32 *                                  S:::::S   A:::::::::::::::::::::A       I::::I  
33 *                                  S:::::S  A:::::AAAAAAAAAAAAA:::::A      I::::I  
34 *                      SSSSSSS     S:::::S A:::::A             A:::::A   II::::::II
35 *                      S::::::SSSSSS:::::SA:::::A               A:::::A  I::::::::I
36 *                      S:::::::::::::::SSA:::::A                 A:::::A I::::::::I
37 *                       SSSSSSSSSSSSSSS AAAAAAA                   AAAAAAAIIIIIIIIII
38 *
39 *
40 *   Living Collectibles
41 *
42 *   The first dispatch from NO_SIDE
43 *    
44 *    
45 *                                            @@@@                                    
46 *                                       ,@@@@@@@@%,@@@@@                             
47 *                                     /@@@@@@@@@@@@@@@@@@@.                          
48 *                                    @@@@@@@@@@@@@@@@@@@@@@&                         
49 *                                   @@@@@@@@@@@@@@@@@@@@@@@@*                        
50 *                                  @@@@@@@@@@@@@@@@@@@@@@@@@@                        
51 *                                  @@@@@@@@@@@@@@@@@@@@@@@@@@                        
52 *         *%@@@@@@@@@@@@%          @@@@@@@@@@@@@@@@@@@@@@@@@@                        
53 *       @@@@@@@@@@@@@@@@@@@@@*     @@@@@@@@@@@@@@@@@@@@@@@@@*                        
54 *         @@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@&                         
55 *    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(@@@@@@@@@@@@@@@@@@@@@@@       ((%@@@(((          
56 *    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&%@@@@@@@@@@@@@@@@@@@@@%    
57 *    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
58 *     &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@&    &@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@. 
59 *       @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(  .@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(
60 *         (@@@@@@@@@@@@@@@@@@@@@@@@.   /@@@@@@@@.    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
61 *             *@@@@@@@@@@@@@@@@@@@@/   @@@@@@@@@@  ,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ 
62 *                       %%%@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@(  
63 *                   .&@@@@@@@@@@@@@@@     @@@@    @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@*    
64 *               ,@@@@@@@@@@@@@@@@@@@@@%*@@@@@@.  ,@@@@@@@@@@@@@@@@@@@@@@@@@@,        
65 *             @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                      
66 *           @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@,                   
67 *         ,@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@/                 
68 *         @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@                
69 *        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@  @@@@@@@@@@@@@@@@@@@@@@@@@@@@               
70 *        @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@   @@@@@@@@@@@@@@@@@@@@@@@@@@@@#              
71 *        @@@@@@@@@@@@@@@@@@@@@@@@@@@@      @@@@@@@@@@@@@@@@@@@@@@@@@@@@              
72 *         ,,, &@@@@@@@@@@@@@@@@@@@@         @@@@@@@@@@@@@@@@@@@@@@@@@@@              
73 *            &@@@@@@@@@@@@@@@@@/              @@@@@@@@@@@@@@@@@@@@@@@@(              
74 *               ,%@@@@@@@%                      @@@@@@@@@@@@@@@@@@@@@@               
75 *                                                 *@@@@@@@@@@@@@/(@@%                
76 *                                                     .@@@@@@@@@                     
77 *    
78 *    
79 *        
80 * bonSAI Living Collectibles is a limited, generative art collection living entirely "in-chain". 
81 * Each piece requires a prescribed amount of care to reach its full potential. 
82 *
83 * Mint your bonSAI via the payable external
84 *
85 *     `mint(address to)` 
86 *
87 * function including ETH value as a multiple of PRICE_PER_TOKEN = 0.0721 ether. This multiple
88 * determines the quantity minted and is capped by MAX_QTY.
89 * 
90 * Both bots and humans can mint these pieces, however the humans have access to a greater 
91 * range of plants with rarer qualities.
92 *
93 * There is a `freeMint` available for a limited run. Read the smart contract for details.
94 *
95 * The bonSAI is best viewed on https://www.nftviewer.xyz/ or https://opensea.io.
96 * Note: The bonSAI's appearance changes as it grows, with about 36 new sprouts per day. 
97 *   At this rate, changes are noticeable after about a day. To view changes from 
98 *   this growth, you may need to click "refresh metadata" on the OpenSea 
99 *   profile of your bonsai.
100 * 
101 * Once minted, the bonSAI must be watered weekly until about 6 weeks when it reaches 
102 * maturity, otherwise it will dry out and die.
103 * 
104 *   - To water a bonSAI call the `water(uint256 tokenId)` external function.
105 *     The caller only pays for gas. See etherscan history for idea of watering gas cost.
106 * 
107 * The form, ratio, and growth steps, are unique to each bonSAI where some may even grow blossoms. 
108 * At any point, a bonSAI owner can influence their piece by pruning to varying degrees.
109 * Of course, pruning is not necessary if you are satisfied with the original growth pattern 
110 * of your plant.
111 * Pruning changes the growth steps which can give more aesthetic branching, body, and may 
112 * even induce blossoming. Note that pruning extends the watering and maturation period 
113 * proportionally. Also pruning is restricted to the range above and cannot affect the 
114 * trunk or first layer of branching. These caveats aside, a plain bonSAI can be sculpted 
115 * to a striking beauty with just a few clips.
116 *
117 * The PRUNE_COST_PER_DEGREE is PRICE_PER_TOKEN/4, aka 0.018025 ether.  
118 *   - To prune a bonSAI call the `prune(uint256 tokenId)` payable external function with eth value
119 *       1 * PRUNE_COST_PER_DEGREE for LOW
120 *       2 * PRUNE_COST_PER_DEGREE for MEDIUM
121 *       3 * PRUNE_COST_PER_DEGREE for HIGH PruningDegrees
122 * 
123 * Your bonSAI's latest growth is rendered "in-chain" in real-time via the standard 
124 * 
125 *     `tokenURI(uint256 tokenId)` 
126 * 
127 * external view function returning a JSON array with latest attributes and svg image. 
128 * 
129 * Be sure to call this `tokenURI` view function using `callStatic`.
130 * 
131 * Keep posted for other upcoming projects from our group.
132 * 
133 *     - NO_SIDE
134 * 
135 **/
136 
137 /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
138 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
139 abstract contract ERC721 {
140     /*//////////////////////////////////////////////////////////////
141                                  EVENTS
142     //////////////////////////////////////////////////////////////*/
143 
144     event Transfer(address indexed from, address indexed to, uint256 indexed id);
145 
146     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
147 
148     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
149 
150     /*//////////////////////////////////////////////////////////////
151                          METADATA STORAGE/LOGIC
152     //////////////////////////////////////////////////////////////*/
153 
154     string public name;
155 
156     string public symbol;
157 
158     function tokenURI(uint256 id) public view virtual returns (string memory);
159 
160     /*//////////////////////////////////////////////////////////////
161                       ERC721 BALANCE/OWNER STORAGE
162     //////////////////////////////////////////////////////////////*/
163 
164     mapping(uint256 => address) internal _ownerOf;
165 
166     mapping(address => uint256) internal _balanceOf;
167 
168     function ownerOf(uint256 id) public view virtual returns (address owner) {
169         require((owner = _ownerOf[id]) != address(0), "NOT_MINTED");
170     }
171 
172     function balanceOf(address owner) public view virtual returns (uint256) {
173         require(owner != address(0), "ZERO_ADDRESS");
174 
175         return _balanceOf[owner];
176     }
177 
178     /*//////////////////////////////////////////////////////////////
179                          ERC721 APPROVAL STORAGE
180     //////////////////////////////////////////////////////////////*/
181 
182     mapping(uint256 => address) public getApproved;
183 
184     mapping(address => mapping(address => bool)) public isApprovedForAll;
185 
186     /*//////////////////////////////////////////////////////////////
187                                CONSTRUCTOR
188     //////////////////////////////////////////////////////////////*/
189 
190     constructor(string memory _name, string memory _symbol) {
191         name = _name;
192         symbol = _symbol;
193     }
194 
195     /*//////////////////////////////////////////////////////////////
196                               ERC721 LOGIC
197     //////////////////////////////////////////////////////////////*/
198 
199     function approve(address spender, uint256 id) public virtual {
200         address owner = _ownerOf[id];
201 
202         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
203 
204         getApproved[id] = spender;
205 
206         emit Approval(owner, spender, id);
207     }
208 
209     function setApprovalForAll(address operator, bool approved) public virtual {
210         isApprovedForAll[msg.sender][operator] = approved;
211 
212         emit ApprovalForAll(msg.sender, operator, approved);
213     }
214 
215     function transferFrom(
216         address from,
217         address to,
218         uint256 id
219     ) public virtual {
220         require(from == _ownerOf[id], "WRONG_FROM");
221 
222         require(to != address(0), "INVALID_RECIPIENT");
223 
224         require(
225             msg.sender == from || isApprovedForAll[from][msg.sender] || msg.sender == getApproved[id],
226             "NOT_AUTHORIZED"
227         );
228 
229         // Underflow of the sender's balance is impossible because we check for
230         // ownership above and the recipient's balance can't realistically overflow.
231         unchecked {
232             _balanceOf[from]--;
233 
234             _balanceOf[to]++;
235         }
236 
237         _ownerOf[id] = to;
238 
239         delete getApproved[id];
240 
241         emit Transfer(from, to, id);
242     }
243 
244     function safeTransferFrom(
245         address from,
246         address to,
247         uint256 id
248     ) public virtual {
249         transferFrom(from, to, id);
250 
251         require(
252             to.code.length == 0 ||
253                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
254                 ERC721TokenReceiver.onERC721Received.selector,
255             "UNSAFE_RECIPIENT"
256         );
257     }
258 
259     function safeTransferFrom(
260         address from,
261         address to,
262         uint256 id,
263         bytes calldata data
264     ) public virtual {
265         transferFrom(from, to, id);
266 
267         require(
268             to.code.length == 0 ||
269                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
270                 ERC721TokenReceiver.onERC721Received.selector,
271             "UNSAFE_RECIPIENT"
272         );
273     }
274 
275     /*//////////////////////////////////////////////////////////////
276                               ERC165 LOGIC
277     //////////////////////////////////////////////////////////////*/
278 
279     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
280         return
281             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
282             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
283             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
284     }
285 
286     /*//////////////////////////////////////////////////////////////
287                         INTERNAL MINT/BURN LOGIC
288     //////////////////////////////////////////////////////////////*/
289 
290     function _mint(address to, uint256 id) internal virtual {
291         require(to != address(0), "INVALID_RECIPIENT");
292 
293         require(_ownerOf[id] == address(0), "ALREADY_MINTED");
294 
295         // Counter overflow is incredibly unrealistic.
296         unchecked {
297             _balanceOf[to]++;
298         }
299 
300         _ownerOf[id] = to;
301 
302         emit Transfer(address(0), to, id);
303     }
304 
305     function _burn(uint256 id) internal virtual {
306         address owner = _ownerOf[id];
307 
308         require(owner != address(0), "NOT_MINTED");
309 
310         // Ownership check above ensures no underflow.
311         unchecked {
312             _balanceOf[owner]--;
313         }
314 
315         delete _ownerOf[id];
316 
317         delete getApproved[id];
318 
319         emit Transfer(owner, address(0), id);
320     }
321 
322     /*//////////////////////////////////////////////////////////////
323                         INTERNAL SAFE MINT LOGIC
324     //////////////////////////////////////////////////////////////*/
325 
326     function _safeMint(address to, uint256 id) internal virtual {
327         _mint(to, id);
328 
329         require(
330             to.code.length == 0 ||
331                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
332                 ERC721TokenReceiver.onERC721Received.selector,
333             "UNSAFE_RECIPIENT"
334         );
335     }
336 
337     function _safeMint(
338         address to,
339         uint256 id,
340         bytes memory data
341     ) internal virtual {
342         _mint(to, id);
343 
344         require(
345             to.code.length == 0 ||
346                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
347                 ERC721TokenReceiver.onERC721Received.selector,
348             "UNSAFE_RECIPIENT"
349         );
350     }
351 }
352 
353 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
354 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
355 abstract contract ERC721TokenReceiver {
356     function onERC721Received(
357         address,
358         address,
359         uint256,
360         bytes calldata
361     ) external virtual returns (bytes4) {
362         return ERC721TokenReceiver.onERC721Received.selector;
363     }
364 }
365 
366 interface IOperatorFilterRegistry {
367     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
368     function register(address registrant) external;
369     function registerAndSubscribe(address registrant, address subscription) external;
370     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
371     function unregister(address addr) external;
372     function updateOperator(address registrant, address operator, bool filtered) external;
373     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
374     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
375     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
376     function subscribe(address registrant, address registrantToSubscribe) external;
377     function unsubscribe(address registrant, bool copyExistingEntries) external;
378     function subscriptionOf(address addr) external returns (address registrant);
379     function subscribers(address registrant) external returns (address[] memory);
380     function subscriberAt(address registrant, uint256 index) external returns (address);
381     function copyEntriesOf(address registrant, address registrantToCopy) external;
382     function isOperatorFiltered(address registrant, address operator) external returns (bool);
383     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
384     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
385     function filteredOperators(address addr) external returns (address[] memory);
386     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
387     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
388     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
389     function isRegistered(address addr) external returns (bool);
390     function codeHashOf(address addr) external returns (bytes32);
391 }
392 
393 /**
394  * @title  OperatorFilterer
395  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
396  *         registrant's entries in the OperatorFilterRegistry.
397  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
398  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
399  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
400  */
401 abstract contract OperatorFilterer {
402     error OperatorNotAllowed(address operator);
403 
404     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
405         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
406 
407     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
408         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
409         // will not revert, but the contract will need to be registered with the registry once it is deployed in
410         // order for the modifier to filter addresses.
411         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
412             if (subscribe) {
413                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
414             } else {
415                 if (subscriptionOrRegistrantToCopy != address(0)) {
416                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
417                 } else {
418                     OPERATOR_FILTER_REGISTRY.register(address(this));
419                 }
420             }
421         }
422     }
423 
424     modifier onlyAllowedOperator(address from) virtual {
425         // Allow spending tokens from addresses with balance
426         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
427         // from an EOA.
428         if (from != msg.sender) {
429             _checkFilterOperator(msg.sender);
430         }
431         _;
432     }
433 
434     modifier onlyAllowedOperatorApproval(address operator) virtual {
435         _checkFilterOperator(operator);
436         _;
437     }
438 
439     function _checkFilterOperator(address operator) internal view virtual {
440         // Check registry code length to facilitate testing in environments without a deployed registry.
441         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
442             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
443                 revert OperatorNotAllowed(operator);
444             }
445         }
446     }
447 }
448 
449 /**
450  * @title  DefaultOperatorFilterer
451  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
452  */
453 abstract contract DefaultOperatorFilterer is OperatorFilterer {
454     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
455 
456     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
457 }
458 
459 abstract contract OperatorFilteredERC721 is ERC721, DefaultOperatorFilterer {
460 
461     constructor(
462         string memory name_,
463         string memory symbol_
464     ) ERC721(name_, symbol_) {}
465 
466     // overrides for DefaultOperatorFilterer, which enables creator fees on opensea
467 
468     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
469         super.setApprovalForAll(operator, approved);
470     }
471 
472     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
473         super.approve(operator, tokenId);
474     }
475 
476     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
477         super.transferFrom(from, to, tokenId);
478     }
479 
480     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
481         super.safeTransferFrom(from, to, tokenId);
482     }
483 
484     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data)
485         public
486         override
487         onlyAllowedOperator(from)
488     {
489         super.safeTransferFrom(from, to, tokenId, data);
490     }
491 }
492 
493 enum PruneDegrees {NONE, LOW, MEDIUM, HIGH}
494 
495 enum HealthStatus {OK, DRY, DEAD}
496 
497 struct BonsaiProfile {
498     uint256 modifiedSteps;
499 
500     uint64 adjustedStartTime;
501     uint64 ratio;
502     uint32 seed;
503     uint8 trunkSVGNumber;
504 
505     uint64 lastWatered;
506 }
507 
508 struct WateringStatus {
509     uint64 lastWatered; 
510     HealthStatus healthStatus;
511     string status;
512 }
513 
514 struct Vars {
515     uint256 layer;
516     uint256 strokeWidth;
517     bytes32[12] gradients;
518 }
519 
520 struct RawAttributes {
521     bytes32 backgroundColor;
522     bytes32 blossomColor;
523     bytes32 wateringStatus;
524 
525     uint32 seed;
526     uint64 ratio;
527     uint64 adjustedStartTime;
528     uint64 lastWatered;
529     uint8 trunkSVGNumber;
530     HealthStatus healthStatus;
531 
532     uint256[] modifiedSteps;
533 }
534 
535 interface IBonsaiRenderer {
536     function numTrunks() external view returns(uint256);
537     function renderForHumans(uint256 tokenId) external view returns(string memory);
538     function renderForRobots(uint256 tokenId) external view returns(RawAttributes memory);
539 }
540 
541 interface IBonsaiState {
542     function getBonsaiProfile(uint256 tokenId) external view returns(BonsaiProfile memory);
543     function initializeBonsai(uint256 tokenId, bool mayBeBot) external;
544     function water(uint256 tokenId) external returns(WateringStatus memory);
545     function wateringStatus(uint256 tokenId) external view returns(WateringStatus memory);
546     function wateringStatusForRender(uint64 lastWatered, uint64 adjustedStartTime, bool watering) external view returns(WateringStatus memory ws);
547     function prune(uint256 tokenId, PruneDegrees degree) external;
548 }
549 
550 /// @notice Library to encode strings in Base64.
551 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/Base64.sol)
552 /// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/Base64.sol)
553 /// @author Modified from (https://github.com/Brechtpd/base64/blob/main/base64.sol) by Brecht Devos - <brecht@loopring.org>.
554 library Base64 {
555     /// @dev Encodes `data` using the base64 encoding described in RFC 4648.
556     /// See: https://datatracker.ietf.org/doc/html/rfc4648
557     /// @param fileSafe  Whether to replace '+' with '-' and '/' with '_'.
558     /// @param noPadding Whether to strip away the padding.
559     function encode(bytes memory data, bool fileSafe, bool noPadding)
560         internal
561         pure
562         returns (string memory result)
563     {
564         /// @solidity memory-safe-assembly
565         assembly {
566             let dataLength := mload(data)
567 
568             if dataLength {
569                 // Multiply by 4/3 rounded up.
570                 // The `shl(2, ...)` is equivalent to multiplying by 4.
571                 let encodedLength := shl(2, div(add(dataLength, 2), 3))
572 
573                 // Set `result` to point to the start of the free memory.
574                 result := mload(0x40)
575 
576                 // Store the table into the scratch space.
577                 // Offsetted by -1 byte so that the `mload` will load the character.
578                 // We will rewrite the free memory pointer at `0x40` later with
579                 // the allocated size.
580                 // The magic constant 0x0230 will translate "-_" + "+/".
581                 mstore(0x1f, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdef")
582                 mstore(0x3f, sub("ghijklmnopqrstuvwxyz0123456789-_", mul(iszero(fileSafe), 0x0230)))
583 
584                 // Skip the first slot, which stores the length.
585                 let ptr := add(result, 0x20)
586                 let end := add(ptr, encodedLength)
587 
588                 // Run over the input, 3 bytes at a time.
589                 for {} 1 {} {
590                     data := add(data, 3) // Advance 3 bytes.
591                     let input := mload(data)
592 
593                     // Write 4 bytes. Optimized for fewer stack operations.
594                     mstore8(ptr, mload(and(shr(18, input), 0x3F)))
595                     mstore8(add(ptr, 1), mload(and(shr(12, input), 0x3F)))
596                     mstore8(add(ptr, 2), mload(and(shr(6, input), 0x3F)))
597                     mstore8(add(ptr, 3), mload(and(input, 0x3F)))
598 
599                     ptr := add(ptr, 4) // Advance 4 bytes.
600 
601                     if iszero(lt(ptr, end)) { break }
602                 }
603 
604                 let r := mod(dataLength, 3)
605 
606                 switch noPadding
607                 case 0 {
608                     // Offset `ptr` and pad with '='. We can simply write over the end.
609                     mstore8(sub(ptr, iszero(iszero(r))), 0x3d) // Pad at `ptr - 1` if `r > 0`.
610                     mstore8(sub(ptr, shl(1, eq(r, 1))), 0x3d) // Pad at `ptr - 2` if `r == 1`.
611                     // Write the length of the string.
612                     mstore(result, encodedLength)
613                 }
614                 default {
615                     // Write the length of the string.
616                     mstore(result, sub(encodedLength, add(iszero(iszero(r)), eq(r, 1))))
617                 }
618 
619                 // Allocate the memory for the string.
620                 // Add 31 and mask with `not(31)` to round the
621                 // free memory pointer up the next multiple of 32.
622                 mstore(0x40, and(add(end, 31), not(31)))
623             }
624         }
625     }
626 
627     /// @dev Encodes `data` using the base64 encoding described in RFC 4648.
628     /// Equivalent to `encode(data, false, false)`.
629     function encode(bytes memory data) internal pure returns (string memory result) {
630         result = encode(data, false, false);
631     }
632 
633     /// @dev Encodes `data` using the base64 encoding described in RFC 4648.
634     /// Equivalent to `encode(data, fileSafe, false)`.
635     function encode(bytes memory data, bool fileSafe)
636         internal
637         pure
638         returns (string memory result)
639     {
640         result = encode(data, fileSafe, false);
641     }
642 
643     /// @dev Encodes base64 encoded `data`.
644     ///
645     /// Supports:
646     /// - RFC 4648 (both standard and file-safe mode).
647     /// - RFC 3501 (63: ',').
648     ///
649     /// Does not support:
650     /// - Line breaks.
651     ///
652     /// Note: For performance reasons,
653     /// this function will NOT revert on invalid `data` inputs.
654     /// Outputs for invalid inputs will simply be undefined behaviour.
655     /// It is the user's responsibility to ensure that the `data`
656     /// is a valid base64 encoded string.
657     function decode(string memory data) internal pure returns (bytes memory result) {
658         /// @solidity memory-safe-assembly
659         assembly {
660             let dataLength := mload(data)
661 
662             if dataLength {
663                 let end := add(data, dataLength)
664                 let decodedLength := mul(shr(2, dataLength), 3)
665 
666                 switch and(dataLength, 3)
667                 case 0 {
668                     // If padded.
669                     // forgefmt: disable-next-item
670                     decodedLength := sub(
671                         decodedLength,
672                         add(eq(and(mload(end), 0xFF), 0x3d), eq(and(mload(end), 0xFFFF), 0x3d3d))
673                     )
674                 }
675                 default {
676                     // If non-padded.
677                     decodedLength := add(decodedLength, sub(and(dataLength, 3), 1))
678                 }
679 
680                 result := mload(0x40)
681 
682                 // Write the length of the string.
683                 mstore(result, decodedLength)
684 
685                 // Skip the first slot, which stores the length.
686                 let ptr := add(result, 0x20)
687 
688                 // Load the table into the scratch space.
689                 // Constants are optimized for smaller bytecode with zero gas overhead.
690                 // `m` also doubles as the mask of the upper 6 bits.
691                 let m := 0xfc000000fc00686c7074787c8084888c9094989ca0a4a8acb0b4b8bcc0c4c8cc
692                 mstore(0x5b, m)
693                 mstore(0x3b, 0x04080c1014181c2024282c3034383c4044484c5054585c6064)
694                 mstore(0x1a, 0xf8fcf800fcd0d4d8dce0e4e8ecf0f4)
695 
696                 for {} 1 {} {
697                     // Read 4 bytes.
698                     data := add(data, 4)
699                     let input := mload(data)
700 
701                     // Write 3 bytes.
702                     // forgefmt: disable-next-item
703                     mstore(ptr, or(
704                         and(m, mload(byte(28, input))),
705                         shr(6, or(
706                             and(m, mload(byte(29, input))),
707                             shr(6, or(
708                                 and(m, mload(byte(30, input))),
709                                 shr(6, mload(byte(31, input)))
710                             ))
711                         ))
712                     ))
713 
714                     ptr := add(ptr, 3)
715 
716                     if iszero(lt(data, end)) { break }
717                 }
718 
719                 // Allocate the memory for the string.
720                 // Add 32 + 31 and mask with `not(31)` to round the
721                 // free memory pointer up the next multiple of 32.
722                 mstore(0x40, and(add(add(result, decodedLength), 63), not(31)))
723 
724                 // Restore the zero slot.
725                 mstore(0x60, 0)
726             }
727         }
728     }
729 }
730 
731 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
732 
733 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
734 
735 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
736 
737 /**
738  * @dev Interface of the ERC165 standard, as defined in the
739  * https://eips.ethereum.org/EIPS/eip-165[EIP].
740  *
741  * Implementers can declare support of contract interfaces, which can then be
742  * queried by others ({ERC165Checker}).
743  *
744  * For an implementation, see {ERC165}.
745  */
746 interface IERC165 {
747     /**
748      * @dev Returns true if this contract implements the interface defined by
749      * `interfaceId`. See the corresponding
750      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
751      * to learn more about how these ids are created.
752      *
753      * This function call must use less than 30 000 gas.
754      */
755     function supportsInterface(bytes4 interfaceId) external view returns (bool);
756 }
757 
758 /**
759  * @dev Interface for the NFT Royalty Standard.
760  *
761  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
762  * support for royalty payments across all NFT marketplaces and ecosystem participants.
763  *
764  * _Available since v4.5._
765  */
766 interface IERC2981 is IERC165 {
767     /**
768      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
769      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
770      */
771     function royaltyInfo(uint256 tokenId, uint256 salePrice)
772         external
773         view
774         returns (address receiver, uint256 royaltyAmount);
775 }
776 
777 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
778 
779 /**
780  * @dev Implementation of the {IERC165} interface.
781  *
782  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
783  * for the additional interface id that will be supported. For example:
784  *
785  * ```solidity
786  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
787  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
788  * }
789  * ```
790  *
791  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
792  */
793 abstract contract ERC165 is IERC165 {
794     /**
795      * @dev See {IERC165-supportsInterface}.
796      */
797     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
798         return interfaceId == type(IERC165).interfaceId;
799     }
800 }
801 
802 /**
803  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
804  *
805  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
806  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
807  *
808  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
809  * fee is specified in basis points by default.
810  *
811  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
812  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
813  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
814  *
815  * _Available since v4.5._
816  */
817 abstract contract ERC2981 is IERC2981, ERC165 {
818     struct RoyaltyInfo {
819         address receiver;
820         uint96 royaltyFraction;
821     }
822 
823     RoyaltyInfo private _defaultRoyaltyInfo;
824     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
825 
826     /**
827      * @dev See {IERC165-supportsInterface}.
828      */
829     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
830         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
831     }
832 
833     /**
834      * @inheritdoc IERC2981
835      */
836     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
837         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
838 
839         if (royalty.receiver == address(0)) {
840             royalty = _defaultRoyaltyInfo;
841         }
842 
843         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
844 
845         return (royalty.receiver, royaltyAmount);
846     }
847 
848     /**
849      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
850      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
851      * override.
852      */
853     function _feeDenominator() internal pure virtual returns (uint96) {
854         return 10000;
855     }
856 
857     /**
858      * @dev Sets the royalty information that all ids in this contract will default to.
859      *
860      * Requirements:
861      *
862      * - `receiver` cannot be the zero address.
863      * - `feeNumerator` cannot be greater than the fee denominator.
864      */
865     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
866         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
867         require(receiver != address(0), "ERC2981: invalid receiver");
868 
869         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
870     }
871 
872     /**
873      * @dev Removes default royalty information.
874      */
875     function _deleteDefaultRoyalty() internal virtual {
876         delete _defaultRoyaltyInfo;
877     }
878 
879     /**
880      * @dev Sets the royalty information for a specific token id, overriding the global default.
881      *
882      * Requirements:
883      *
884      * - `receiver` cannot be the zero address.
885      * - `feeNumerator` cannot be greater than the fee denominator.
886      */
887     function _setTokenRoyalty(
888         uint256 tokenId,
889         address receiver,
890         uint96 feeNumerator
891     ) internal virtual {
892         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
893         require(receiver != address(0), "ERC2981: Invalid parameters");
894 
895         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
896     }
897 
898     /**
899      * @dev Resets royalty information for the token id back to the global default.
900      */
901     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
902         delete _tokenRoyaltyInfo[tokenId];
903     }
904 }
905 
906 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
907 
908 // OpenZeppelin Contracts (last updated v4.7.0) (utils/math/Math.sol)
909 
910 /**
911  * @dev Standard math utilities missing in the Solidity language.
912  */
913 library Math {
914     enum Rounding {
915         Down, // Toward negative infinity
916         Up, // Toward infinity
917         Zero // Toward zero
918     }
919 
920     /**
921      * @dev Returns the largest of two numbers.
922      */
923     function max(uint256 a, uint256 b) internal pure returns (uint256) {
924         return a > b ? a : b;
925     }
926 
927     /**
928      * @dev Returns the smallest of two numbers.
929      */
930     function min(uint256 a, uint256 b) internal pure returns (uint256) {
931         return a < b ? a : b;
932     }
933 
934     /**
935      * @dev Returns the average of two numbers. The result is rounded towards
936      * zero.
937      */
938     function average(uint256 a, uint256 b) internal pure returns (uint256) {
939         // (a + b) / 2 can overflow.
940         return (a & b) + (a ^ b) / 2;
941     }
942 
943     /**
944      * @dev Returns the ceiling of the division of two numbers.
945      *
946      * This differs from standard division with `/` in that it rounds up instead
947      * of rounding down.
948      */
949     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
950         // (a + b - 1) / b can overflow on addition, so we distribute.
951         return a == 0 ? 0 : (a - 1) / b + 1;
952     }
953 
954     /**
955      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
956      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
957      * with further edits by Uniswap Labs also under MIT license.
958      */
959     function mulDiv(
960         uint256 x,
961         uint256 y,
962         uint256 denominator
963     ) internal pure returns (uint256 result) {
964         unchecked {
965             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
966             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
967             // variables such that product = prod1 * 2^256 + prod0.
968             uint256 prod0; // Least significant 256 bits of the product
969             uint256 prod1; // Most significant 256 bits of the product
970             assembly {
971                 let mm := mulmod(x, y, not(0))
972                 prod0 := mul(x, y)
973                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
974             }
975 
976             // Handle non-overflow cases, 256 by 256 division.
977             if (prod1 == 0) {
978                 return prod0 / denominator;
979             }
980 
981             // Make sure the result is less than 2^256. Also prevents denominator == 0.
982             require(denominator > prod1);
983 
984             ///////////////////////////////////////////////
985             // 512 by 256 division.
986             ///////////////////////////////////////////////
987 
988             // Make division exact by subtracting the remainder from [prod1 prod0].
989             uint256 remainder;
990             assembly {
991                 // Compute remainder using mulmod.
992                 remainder := mulmod(x, y, denominator)
993 
994                 // Subtract 256 bit number from 512 bit number.
995                 prod1 := sub(prod1, gt(remainder, prod0))
996                 prod0 := sub(prod0, remainder)
997             }
998 
999             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1000             // See https://cs.stackexchange.com/q/138556/92363.
1001 
1002             // Does not overflow because the denominator cannot be zero at this stage in the function.
1003             uint256 twos = denominator & (~denominator + 1);
1004             assembly {
1005                 // Divide denominator by twos.
1006                 denominator := div(denominator, twos)
1007 
1008                 // Divide [prod1 prod0] by twos.
1009                 prod0 := div(prod0, twos)
1010 
1011                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1012                 twos := add(div(sub(0, twos), twos), 1)
1013             }
1014 
1015             // Shift in bits from prod1 into prod0.
1016             prod0 |= prod1 * twos;
1017 
1018             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1019             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1020             // four bits. That is, denominator * inv = 1 mod 2^4.
1021             uint256 inverse = (3 * denominator) ^ 2;
1022 
1023             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1024             // in modular arithmetic, doubling the correct bits in each step.
1025             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1026             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1027             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1028             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1029             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1030             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1031 
1032             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1033             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1034             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1035             // is no longer required.
1036             result = prod0 * inverse;
1037             return result;
1038         }
1039     }
1040 
1041     /**
1042      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1043      */
1044     function mulDiv(
1045         uint256 x,
1046         uint256 y,
1047         uint256 denominator,
1048         Rounding rounding
1049     ) internal pure returns (uint256) {
1050         uint256 result = mulDiv(x, y, denominator);
1051         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1052             result += 1;
1053         }
1054         return result;
1055     }
1056 
1057     /**
1058      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
1059      *
1060      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1061      */
1062     function sqrt(uint256 a) internal pure returns (uint256) {
1063         if (a == 0) {
1064             return 0;
1065         }
1066 
1067         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1068         //
1069         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1070         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
1071         //
1072         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
1073         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
1074         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
1075         //
1076         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
1077         uint256 result = 1 << (log2(a) >> 1);
1078 
1079         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1080         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1081         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1082         // into the expected uint128 result.
1083         unchecked {
1084             result = (result + a / result) >> 1;
1085             result = (result + a / result) >> 1;
1086             result = (result + a / result) >> 1;
1087             result = (result + a / result) >> 1;
1088             result = (result + a / result) >> 1;
1089             result = (result + a / result) >> 1;
1090             result = (result + a / result) >> 1;
1091             return min(result, a / result);
1092         }
1093     }
1094 
1095     /**
1096      * @notice Calculates sqrt(a), following the selected rounding direction.
1097      */
1098     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1099         unchecked {
1100             uint256 result = sqrt(a);
1101             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
1102         }
1103     }
1104 
1105     /**
1106      * @dev Return the log in base 2, rounded down, of a positive value.
1107      * Returns 0 if given 0.
1108      */
1109     function log2(uint256 value) internal pure returns (uint256) {
1110         uint256 result = 0;
1111         unchecked {
1112             if (value >> 128 > 0) {
1113                 value >>= 128;
1114                 result += 128;
1115             }
1116             if (value >> 64 > 0) {
1117                 value >>= 64;
1118                 result += 64;
1119             }
1120             if (value >> 32 > 0) {
1121                 value >>= 32;
1122                 result += 32;
1123             }
1124             if (value >> 16 > 0) {
1125                 value >>= 16;
1126                 result += 16;
1127             }
1128             if (value >> 8 > 0) {
1129                 value >>= 8;
1130                 result += 8;
1131             }
1132             if (value >> 4 > 0) {
1133                 value >>= 4;
1134                 result += 4;
1135             }
1136             if (value >> 2 > 0) {
1137                 value >>= 2;
1138                 result += 2;
1139             }
1140             if (value >> 1 > 0) {
1141                 result += 1;
1142             }
1143         }
1144         return result;
1145     }
1146 
1147     /**
1148      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1149      * Returns 0 if given 0.
1150      */
1151     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1152         unchecked {
1153             uint256 result = log2(value);
1154             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1155         }
1156     }
1157 
1158     /**
1159      * @dev Return the log in base 10, rounded down, of a positive value.
1160      * Returns 0 if given 0.
1161      */
1162     function log10(uint256 value) internal pure returns (uint256) {
1163         uint256 result = 0;
1164         unchecked {
1165             if (value >= 10**64) {
1166                 value /= 10**64;
1167                 result += 64;
1168             }
1169             if (value >= 10**32) {
1170                 value /= 10**32;
1171                 result += 32;
1172             }
1173             if (value >= 10**16) {
1174                 value /= 10**16;
1175                 result += 16;
1176             }
1177             if (value >= 10**8) {
1178                 value /= 10**8;
1179                 result += 8;
1180             }
1181             if (value >= 10**4) {
1182                 value /= 10**4;
1183                 result += 4;
1184             }
1185             if (value >= 10**2) {
1186                 value /= 10**2;
1187                 result += 2;
1188             }
1189             if (value >= 10**1) {
1190                 result += 1;
1191             }
1192         }
1193         return result;
1194     }
1195 
1196     /**
1197      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1198      * Returns 0 if given 0.
1199      */
1200     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1201         unchecked {
1202             uint256 result = log10(value);
1203             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1204         }
1205     }
1206 
1207     /**
1208      * @dev Return the log in base 256, rounded down, of a positive value.
1209      * Returns 0 if given 0.
1210      *
1211      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1212      */
1213     function log256(uint256 value) internal pure returns (uint256) {
1214         uint256 result = 0;
1215         unchecked {
1216             if (value >> 128 > 0) {
1217                 value >>= 128;
1218                 result += 16;
1219             }
1220             if (value >> 64 > 0) {
1221                 value >>= 64;
1222                 result += 8;
1223             }
1224             if (value >> 32 > 0) {
1225                 value >>= 32;
1226                 result += 4;
1227             }
1228             if (value >> 16 > 0) {
1229                 value >>= 16;
1230                 result += 2;
1231             }
1232             if (value >> 8 > 0) {
1233                 result += 1;
1234             }
1235         }
1236         return result;
1237     }
1238 
1239     /**
1240      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1241      * Returns 0 if given 0.
1242      */
1243     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1244         unchecked {
1245             uint256 result = log256(value);
1246             return result + (rounding == Rounding.Up && 1 << (result << 3) < value ? 1 : 0);
1247         }
1248     }
1249 }
1250 
1251 /**
1252  * @dev String operations.
1253  */
1254 library Strings {
1255     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1256     uint8 private constant _ADDRESS_LENGTH = 20;
1257 
1258     /**
1259      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1260      */
1261     function toString(uint256 value) internal pure returns (string memory) {
1262         unchecked {
1263             uint256 length = Math.log10(value) + 1;
1264             string memory buffer = new string(length);
1265             uint256 ptr;
1266             /// @solidity memory-safe-assembly
1267             assembly {
1268                 ptr := add(buffer, add(32, length))
1269             }
1270             while (true) {
1271                 ptr--;
1272                 /// @solidity memory-safe-assembly
1273                 assembly {
1274                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1275                 }
1276                 value /= 10;
1277                 if (value == 0) break;
1278             }
1279             return buffer;
1280         }
1281     }
1282 
1283     /**
1284      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1285      */
1286     function toHexString(uint256 value) internal pure returns (string memory) {
1287         unchecked {
1288             return toHexString(value, Math.log256(value) + 1);
1289         }
1290     }
1291 
1292     /**
1293      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1294      */
1295     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1296         bytes memory buffer = new bytes(2 * length + 2);
1297         buffer[0] = "0";
1298         buffer[1] = "x";
1299         for (uint256 i = 2 * length + 1; i > 1; --i) {
1300             buffer[i] = _SYMBOLS[value & 0xf];
1301             value >>= 4;
1302         }
1303         require(value == 0, "Strings: hex length insufficient");
1304         return string(buffer);
1305     }
1306 
1307     /**
1308      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1309      */
1310     function toHexString(address addr) internal pure returns (string memory) {
1311         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1312     }
1313 }
1314 
1315 /// @notice Read and write to persistent storage at a fraction of the cost.
1316 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/SSTORE2.sol)
1317 /// @author Modified from 0xSequence (https://github.com/0xSequence/sstore2/blob/master/contracts/SSTORE2.sol)
1318 library SSTORE2 {
1319     uint256 internal constant DATA_OFFSET = 1; // We skip the first byte as it's a STOP opcode to ensure the contract can't be called.
1320 
1321     /*//////////////////////////////////////////////////////////////
1322                                WRITE LOGIC
1323     //////////////////////////////////////////////////////////////*/
1324 
1325     function write(bytes memory data) internal returns (address pointer) {
1326         // Prefix the bytecode with a STOP opcode to ensure it cannot be called.
1327         bytes memory runtimeCode = abi.encodePacked(hex"00", data);
1328 
1329         bytes memory creationCode = abi.encodePacked(
1330             //---------------------------------------------------------------------------------------------------------------//
1331             // Opcode  | Opcode + Arguments  | Description  | Stack View                                                     //
1332             //---------------------------------------------------------------------------------------------------------------//
1333             // 0x60    |  0x600B             | PUSH1 11     | codeOffset                                                     //
1334             // 0x59    |  0x59               | MSIZE        | 0 codeOffset                                                   //
1335             // 0x81    |  0x81               | DUP2         | codeOffset 0 codeOffset                                        //
1336             // 0x38    |  0x38               | CODESIZE     | codeSize codeOffset 0 codeOffset                               //
1337             // 0x03    |  0x03               | SUB          | (codeSize - codeOffset) 0 codeOffset                           //
1338             // 0x80    |  0x80               | DUP          | (codeSize - codeOffset) (codeSize - codeOffset) 0 codeOffset   //
1339             // 0x92    |  0x92               | SWAP3        | codeOffset (codeSize - codeOffset) 0 (codeSize - codeOffset)   //
1340             // 0x59    |  0x59               | MSIZE        | 0 codeOffset (codeSize - codeOffset) 0 (codeSize - codeOffset) //
1341             // 0x39    |  0x39               | CODECOPY     | 0 (codeSize - codeOffset)                                      //
1342             // 0xf3    |  0xf3               | RETURN       |                                                                //
1343             //---------------------------------------------------------------------------------------------------------------//
1344             hex"60_0B_59_81_38_03_80_92_59_39_F3", // Returns all code in the contract except for the first 11 (0B in hex) bytes.
1345             runtimeCode // The bytecode we want the contract to have after deployment. Capped at 1 byte less than the code size limit.
1346         );
1347 
1348         /// @solidity memory-safe-assembly
1349         assembly {
1350             // Deploy a new contract with the generated creation code.
1351             // We start 32 bytes into the code to avoid copying the byte length.
1352             pointer := create(0, add(creationCode, 32), mload(creationCode))
1353         }
1354 
1355         require(pointer != address(0), "DEPLOYMENT_FAILED");
1356     }
1357 
1358     /*//////////////////////////////////////////////////////////////
1359                                READ LOGIC
1360     //////////////////////////////////////////////////////////////*/
1361 
1362     function read(address pointer) internal view returns (bytes memory) {
1363         return readBytecode(pointer, DATA_OFFSET, pointer.code.length - DATA_OFFSET);
1364     }
1365 
1366     function read(address pointer, uint256 start) internal view returns (bytes memory) {
1367         start += DATA_OFFSET;
1368 
1369         return readBytecode(pointer, start, pointer.code.length - start);
1370     }
1371 
1372     function read(
1373         address pointer,
1374         uint256 start,
1375         uint256 end
1376     ) internal view returns (bytes memory) {
1377         start += DATA_OFFSET;
1378         end += DATA_OFFSET;
1379 
1380         require(pointer.code.length >= end, "OUT_OF_BOUNDS");
1381 
1382         return readBytecode(pointer, start, end - start);
1383     }
1384 
1385     /*//////////////////////////////////////////////////////////////
1386                           INTERNAL HELPER LOGIC
1387     //////////////////////////////////////////////////////////////*/
1388 
1389     function readBytecode(
1390         address pointer,
1391         uint256 start,
1392         uint256 size
1393     ) private view returns (bytes memory data) {
1394         /// @solidity memory-safe-assembly
1395         assembly {
1396             // Get a pointer to some free memory.
1397             data := mload(0x40)
1398 
1399             // Update the free memory pointer to prevent overriding our data.
1400             // We use and(x, not(31)) as a cheaper equivalent to sub(x, mod(x, 32)).
1401             // Adding 31 to size and running the result through the logic above ensures
1402             // the memory pointer remains word-aligned, following the Solidity convention.
1403             mstore(0x40, add(data, and(add(add(size, 32), 31), not(31))))
1404 
1405             // Store the size of the data in the first 32 byte chunk of free memory.
1406             mstore(data, size)
1407 
1408             // Copy the code into memory right after the 32 bytes we used to store the size.
1409             extcodecopy(pointer, add(data, 32), start, size)
1410         }
1411     }
1412 }
1413 
1414 abstract contract MarketWares is ERC2981 {
1415 
1416     address public immutable OWNER;
1417     address public immutable SECURITY_ADVISOR;
1418 
1419     address private _logoPointer;
1420 
1421     constructor(address owner_, address securityAdvisor_) {
1422         // assumption: admin addresses are auditted contracts or verified to be EOA's
1423         OWNER = owner_;
1424         SECURITY_ADVISOR = securityAdvisor_;
1425 
1426         _setDefaultRoyalty(OWNER, 100); // ERC2981 1% royalty on secondary sales
1427     }
1428       
1429     // needed for opensea
1430     function contractURI() public view returns(string memory) {
1431         return string(abi.encodePacked(
1432                   "data:application/json;base64,", 
1433                   Base64.encode(abi.encodePacked("{\"name\": \"bonSAI\","
1434                        " \"description\": \"Limited, generative art collection living entirely 'in-chain'.\","
1435                        " \"image\": \"", 
1436                        "data:image/svg+xml;base64,",
1437                        Base64.encode(SSTORE2.read(_logoPointer)), 
1438                        "\",",
1439                        " \"seller_fee_basis_points:\": \"100\","
1440                        " \"fee_recipient\": \"", Strings.toHexString(OWNER) ,"\"}"))));
1441     }
1442 
1443     function sendETH() external {
1444         // assumption: admin addresses are auditted contracts or verified to be EOA's
1445         (bool success,) = SECURITY_ADVISOR.call{value: address(this).balance/10}("");
1446         require(success, "call0: breaks EOA assumption.");
1447         (success,) = OWNER.call{value: address(this).balance}("");
1448         require(success, "call1: breaks EOA assumption.");
1449     }
1450 
1451     function setLogo(string memory logo) external {
1452         require(msg.sender == OWNER, "not owner.");
1453         _logoPointer = SSTORE2.write(bytes(logo));
1454     }
1455 }
1456 
1457 contract BonsaiMaker is OperatorFilteredERC721, MarketWares {
1458 
1459     uint256 constant public PRICE_PER_TOKEN = 0.0721 ether;
1460     uint256 constant public MAX_TOKENS = 10_000;
1461     uint256 constant public MAX_QTY = 70;
1462     uint256 constant public FREE_MINT = 100;
1463 
1464     uint256 constant public PRUNE_COST_PER_DEGREE = PRICE_PER_TOKEN / 4; 
1465 
1466     uint256 public totalSupply;
1467 
1468     IBonsaiState public bonsaiState;
1469     IBonsaiRenderer public bonsaiRenderer;
1470 
1471     mapping(address => uint256) private _freeMintedTime;
1472     mapping(address => uint256) private _numMinted;
1473 
1474     constructor(
1475         address owner_, 
1476         // security advisement was provided by Nomoi Web3 Hacker Collective, nomoi.xyz
1477         address securityAdvisor_, 
1478         address bonsaiState_,
1479         address bonsaiRenderer_
1480     ) OperatorFilteredERC721("BonSAIMaker", "bMKR") MarketWares(owner_, securityAdvisor_) { // see `MarketWares` for royalty stuffs
1481 
1482         bonsaiState = IBonsaiState(bonsaiState_);
1483         bonsaiRenderer = IBonsaiRenderer(bonsaiRenderer_);
1484     }
1485 
1486     function _mayBeBot() internal view returns(bool) {
1487         return tx.origin != msg.sender;
1488     }
1489 
1490     // minting
1491 
1492     function mintFree(address to) external returns(uint256 tokenId) {
1493         unchecked{
1494         if (msg.sender != OWNER) {
1495             require(!_mayBeBot(), "no freebies for bots.");
1496             require(totalSupply < FREE_MINT, "no more free mints.");
1497             require(block.timestamp > _freeMintedTime[tx.origin] + 1 days, "1 free mint /EOA /day.");
1498             _freeMintedTime[msg.sender] = block.timestamp; // since !_mayBeBot
1499         }
1500         tokenId = ++totalSupply;
1501         _mint(to, tokenId);
1502         bonsaiState.initializeBonsai({tokenId: tokenId, mayBeBot: false});
1503         }//uc
1504     }
1505 
1506     function mint(address to) external payable returns(uint256 lastTokenId) {
1507         unchecked{
1508         require(msg.value % PRICE_PER_TOKEN == 0, "msg.value != n * price.");
1509         uint256 qty = msg.value / PRICE_PER_TOKEN;
1510         require(qty > 0, "call mint with n * PRICE_PER_TOKEN.");
1511         require(_numMinted[msg.sender] + qty <= MAX_QTY, "minting too many.");
1512         _numMinted[msg.sender] += qty;
1513         uint256 tokenId = totalSupply;
1514         require(tokenId + qty <= MAX_TOKENS, "new tokens exceed max.");
1515 
1516         bool mayBeBot = _mayBeBot(); // bots ok but they get limited options
1517         for (uint256 i; i < qty; ++i) {
1518             _mint(to, ++tokenId); 
1519             bonsaiState.initializeBonsai(tokenId, mayBeBot);
1520         }
1521         lastTokenId = tokenId;
1522         totalSupply = lastTokenId;
1523         }//uc
1524     }
1525 
1526     // enjoyment
1527 
1528     // viewing
1529 
1530     function tokenURI(uint256 tokenId) public view override returns(string memory) {
1531         require(_ownerOf[tokenId] != address(0), "Bonsai dne.");
1532         return bonsaiRenderer.renderForHumans(tokenId);
1533     }
1534 
1535     function tokenURIForRobots(uint256 tokenId) public view returns(RawAttributes memory) {
1536         require(_ownerOf[tokenId] != address(0), "Bonsai dne.");
1537         return bonsaiRenderer.renderForRobots(tokenId);
1538     }
1539 
1540     // bonsai care
1541 
1542     // watering
1543 
1544     event Watered(uint256 indexed tokenId, string indexed status);
1545 
1546     // anyone can water :)
1547     function water(uint256 tokenId) external returns(WateringStatus memory ws) {
1548         require(_ownerOf[tokenId] != address(0), "Bonsai dne.");
1549         ws = bonsaiState.water(tokenId);    
1550         emit Watered(tokenId, ws.status);
1551     }
1552 
1553     function wateringStatus(uint256 tokenId) external view returns(WateringStatus memory) {
1554         require(_ownerOf[tokenId] != address(0), "Bonsai dne.");
1555         return bonsaiState.wateringStatus(tokenId);
1556     }
1557 
1558     // pruning
1559 
1560     event Pruned(uint256 indexed tokenId, PruneDegrees indexed degree);
1561 
1562     function prune(uint256 tokenId) external payable {
1563         require(msg.sender == _ownerOf[tokenId], "you don't mow another man's lawn.");
1564         require(msg.value % PRUNE_COST_PER_DEGREE == 0, "incongruent pruning payment.");
1565         uint256 degreeNumber = (msg.value / PRUNE_COST_PER_DEGREE);
1566         require(degreeNumber > 0, "call prune with value n * PRUNE_COST_PER_DEGREE.");
1567         require(degreeNumber < 4, "max prune degree is 3 (HIGH)");
1568         PruneDegrees degree = PruneDegrees(degreeNumber);
1569         bonsaiState.prune(tokenId, degree);
1570         emit Pruned(tokenId, degree);
1571     }
1572 
1573     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
1574         return interfaceId == type(IERC2981).interfaceId || 
1575                interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
1576                interfaceId == 0x5b5e139f || // ERC165 Interface ID for ERC721Metadata
1577                super.supportsInterface(interfaceId);
1578     }
1579 }