1 pragma solidity ^0.4.24;
2 
3 // File: contracts/Genetic.sol
4 
5 // solhint-disable-next-line
6 pragma solidity ^0.4.23;
7 
8 
9 contract Genetic {
10 
11     // TODO mutations
12     // maximum number of random mutations per chromatid
13     uint8 public constant R = 5;
14 
15     // solhint-disable-next-line function-max-lines
16     function breed(uint256[2] mother, uint256[2] father, uint256 seed) internal view returns (uint256[2] memOffset) {
17         // Meiosis I: recombining alleles (Chromosomal crossovers)
18 
19         // Note about optimization I: no cell duplication,
20         //  producing 2 seeds/eggs per cell is enough, instead of 4 (like humans do)
21 
22         // Note about optimization II: crossovers happen,
23         //  but only 1 side of the result is computed,
24         //  as the other side will not affect anything.
25 
26         // solhint-disable-next-line no-inline-assembly
27         assembly {
28             // allocate output
29             // 1) get the pointer to our memory
30             memOffset := mload(0x40)
31             // 2) Change the free-memory pointer to keep our memory
32             //     (we will only use 64 bytes: 2 values of 256 bits)
33             mstore(0x40, add(memOffset, 64))
34 
35 
36             // Put seed in scratchpad 0
37             mstore(0x0, seed)
38             // Also use the timestamp, best we could do to increase randomness
39             //  without increasing costs dramatically. (Trade-off)
40             mstore(0x20, timestamp)
41 
42             // Hash it for a universally random bitstring.
43             let hash := keccak256(0, 64)
44 
45             // Byzantium VM does not support shift opcodes, will be introduced in Constantinople.
46             // Soldity itself, in non-assembly, also just uses other opcodes to simulate it.
47             // Optmizer should take care of inlining, just declare shiftR ourselves here.
48             // Where possible, better optimization is applied to make it cheaper.
49             function shiftR(value, offset) -> result {
50                 result := div(value, exp(2, offset))
51             }
52 
53             // solhint-disable max-line-length
54             // m_context << Instruction::SWAP1 << u256(2) << Instruction::EXP << Instruction::SWAP1 << (c_leftSigned ? Instruction::SDIV : Instruction::DIV);
55 
56             // optimization: although one side consists of multiple chromatids,
57             //  we handle them just as one long chromatid:
58             //  only difference is that a crossover in chromatid i affects chromatid i+1.
59             //  No big deal, order and location is random anyway
60             function processSide(fatherSrc, motherSrc, rngSrc) -> result {
61 
62                 {
63                     // initial rngSrc bit length: 254 bits
64 
65                     // Run the crossovers
66                     // =====================================================
67 
68                     // Pick some crossovers
69                     // Each crossover is spaced ~64 bits on average.
70                     // To achieve this, we get a random 7 bit number, [0, 128), for each crossover.
71 
72                     // 256 / 64 = 4, we need 4 crossovers,
73                     //  and will have 256 / 127 = 2 at least (rounded down).
74 
75                     // Get one bit determining if we should pick DNA from the father,
76                     //  or from the mother.
77                     // This changes every crossover. (by swapping father and mother)
78                     {
79                         if eq(and(rngSrc, 0x1), 0) {
80                             // Swap mother and father,
81                             // create a temporary variable (code golf XOR swap costs more in gas)
82                             let temp := fatherSrc
83                             fatherSrc := motherSrc
84                             motherSrc := temp
85                         }
86 
87                         // remove the bit from rng source, 253 rng bits left
88                         rngSrc := shiftR(rngSrc, 1)
89                     }
90 
91                     // Don't push/pop this all the time, we have just enough space on stack.
92                     let mask := 0
93 
94                     // Cap at 4 crossovers, no more than that.
95                     let cap := 0
96                     let crossoverLen := and(rngSrc, 0x7f) // bin: 1111111 (7 bits ON)
97                     // remove bits from hash, e.g. 254 - 7 = 247 left.
98                     rngSrc := shiftR(rngSrc, 7)
99                     let crossoverPos := crossoverLen
100 
101                     // optimization: instead of shifting with an opcode we don't have until Constantinople,
102                     //  keep track of the a shifted number, updated using multiplications.
103                     let crossoverPosLeading1 := 1
104 
105                     // solhint-disable-next-line no-empty-blocks
106                     for { } and(lt(crossoverPos, 256), lt(cap, 4)) {
107 
108                         crossoverLen := and(rngSrc, 0x7f) // bin: 1111111 (7 bits ON)
109                         // remove bits from hash, e.g. 254 - 7 = 247 left.
110                         rngSrc := shiftR(rngSrc, 7)
111 
112                         crossoverPos := add(crossoverPos, crossoverLen)
113 
114                         cap := add(cap, 1)
115                     } {
116 
117                         // Note: we go from right to left in the bit-string.
118 
119                         // Create a mask for this crossover.
120                         // Example:
121                         // 00000000000001111111111111111110000000000000000000000000000000000000000000000000000000000.....
122                         // |Prev. data ||Crossover here  ||remaining data .......
123                         //
124                         // The crossover part is copied from the mother/father to the child.
125 
126                         // Create the bit-mask
127                         // Create a bitstring that ignores the previous data:
128                         // 00000000000001111111111111111111111111111111111111111111111111111111111111111111111111111.....
129                         // First create a leading 1, just before the crossover, like:
130                         // 00000000000010000000000000000000000000000000000000000000000000000000000.....
131                         // Then substract 1, to get a long string of 1s
132                         // 00000000000001111111111111111111111111111111111111111111111111111111111111111111111111111.....
133                         // Now do the same for the remain part, and xor it.
134                         // leading 1
135                         // 00000000000000000000000000000010000000000000000000000000000000000000000000000000000000000.....
136                         // sub 1
137                         // 00000000000000000000000000000001111111111111111111111111111111111111111111111111111111111.....
138                         // xor with other
139                         // 00000000000001111111111111111111111111111111111111111111111111111111111111111111111111111.....
140                         // 00000000000000000000000000000001111111111111111111111111111111111111111111111111111111111.....
141                         // 00000000000001111111111111111110000000000000000000000000000000000000000000000000000000000.....
142 
143                         // Use the final shifted 1 of the previous crossover as the start marker
144                         mask := sub(crossoverPosLeading1, 1)
145 
146                         // update for this crossover, (and will be used as start for next crossover)
147                         crossoverPosLeading1 := mul(1, exp(2, crossoverPos))
148                         mask := xor(mask,
149                                     sub(crossoverPosLeading1, 1)
150                         )
151 
152                         // Now add the parent data to the child genotype
153                         // E.g.
154                         // Mask:         00000000000001111111111111111110000000000000000000000000000000000000000000000000000000000....
155                         // Parent:       10010111001000110101011111001010001011100000000000010011000001000100000001011101111000111....
156                         // Child (pre):  00000000000000000000000000000001111110100101111111000011001010000000101010100000110110110....
157                         // Child (post): 00000000000000110101011111001011111110100101111111000011001010000000101010100000110110110....
158 
159                         // To do this, we run: child_post = child_pre | (mask & father)
160                         result := or(result, and(mask, fatherSrc))
161 
162                         // Swap father and mother, next crossover will take a string from the other.
163                         let temp := fatherSrc
164                         fatherSrc := motherSrc
165                         motherSrc := temp
166                     }
167 
168                     // We still have a left-over part that was not copied yet
169                     // E.g., we have something like:
170                     // Father: |            xxxxxxxxxxxxxxxxxxx          xxxxxxxxxxxxxxxxxxxxxxxx            ....
171                     // Mother: |############                   xxxxxxxxxx                        xxxxxxxxxxxx....
172                     // Child:  |            xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx....
173                     // The ############ still needs to be applied to the child, also,
174                     //  this can be done cheaper than in the loop above,
175                     //  as we don't have to swap anything for the next crossover or something.
176 
177                     // At this point we have to assume 4 crossovers ran,
178                     //  and that we only have 127 - 1 - (4 * 7) = 98 bits of randomness left.
179                     // We stopped at the bit after the crossoverPos index, see "x":
180                     // 000000000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.....
181                     // now create a leading 1 at crossoverPos like:
182                     // 000000001000000000000000000000000000000000000000000000000000000000000000000.....
183                     // Sub 1, get the mask for what we had.
184                     // 000000000111111111111111111111111111111111111111111111111111111111111111111.....
185                     // Invert, and we have the final mask:
186                     // 111111111000000000000000000000000000000000000000000000000000000000000000000.....
187                     mask := not(sub(crossoverPosLeading1, 1))
188                     // Apply it to the result
189                     result := or(result, and(mask, fatherSrc))
190 
191                     // Random mutations
192                     // =====================================================
193 
194                     // random mutations
195                     // Put rng source in scratchpad 0
196                     mstore(0x0, rngSrc)
197                     // And some arbitrary padding in scratchpad 1,
198                     //  used to create different hashes based on input size changes
199                     mstore(0x20, 0x434f4c4c454354205045504553204f4e2043525950544f50455045532e494f21)
200                     // Hash it for a universally random bitstring.
201                     // Then reduce the number of 1s by AND-ing it with other *different* hashes.
202                     // Each bit in mutations has a probability of 0.5^5 = 0.03125 = 3.125% to be a 1
203                     let mutations := and(
204                             and(
205                                 and(keccak256(0, 32), keccak256(1, 33)),
206                                 and(keccak256(2, 34), keccak256(3, 35))
207                             ),
208                             keccak256(0, 36)
209                     )
210 
211                     result := xor(result, mutations)
212 
213                 }
214             }
215 
216 
217             {
218 
219                 // Get 1 bit of pseudo randomness that will
220                 //  determine if side #1 will come from the left, or right side.
221                 // Either 0 or 1, shift it by 5 bits to get either 0x0 or 0x20, cheaper later on.
222                 let relativeFatherSideLoc := mul(and(hash, 0x1), 0x20) // shift by 5 bits = mul by 2^5=32 (0x20)
223                 // Either 0 or 1, shift it by 5 bits to get either 0x0 or 0x20, cheaper later on.
224                 let relativeMotherSideLoc := mul(and(hash, 0x2), 0x10) // already shifted by 1, mul by 2^4=16 (0x10)
225 
226                 // Now remove the used 2 bits from the hash, 254 bits remaining now.
227                 hash := div(hash, 4)
228 
229                 // Process the side, load the relevant parent data that will be used.
230                 mstore(memOffset, processSide(
231                     mload(add(father, relativeFatherSideLoc)),
232                     mload(add(mother, relativeMotherSideLoc)),
233                     hash
234                 ))
235 
236                 // The other side will be the opposite index: 1 -> 0, 0 -> 1
237                 // Apply it to the location,
238                 //  which is either 0x20 (For index 1) or 0x0 for index 0.
239                 relativeFatherSideLoc := xor(relativeFatherSideLoc, 0x20)
240                 relativeMotherSideLoc := xor(relativeMotherSideLoc, 0x20)
241 
242                 mstore(0x0, seed)
243                 // Second argument will be inverse,
244                 //  resulting in a different second hash.
245                 mstore(0x20, not(timestamp))
246 
247                 // Now create another hash, for the other side
248                 hash := keccak256(0, 64)
249 
250                 // Process the other side
251                 mstore(add(memOffset, 0x20), processSide(
252                     mload(add(father, relativeFatherSideLoc)),
253                     mload(add(mother, relativeMotherSideLoc)),
254                     hash
255                 ))
256 
257             }
258 
259         }
260 
261         // Sample input:
262         // ["0xAAABBBBBBBBCCCCCCCCAAAAAAAAABBBBBBBBBBCCCCCCCCCAABBBBBBBCCCCCCCC","0x4444444455555555555555556666666666666644444444455555555555666666"]
263         //
264         // ["0x1111111111112222222223333311111111122222223333333331111112222222","0x7777788888888888999999999999977777777777788888888888999999997777"]
265 
266         // Expected results (or similar, depends on the seed):
267         // 0xAAABBBBBBBBCCCCCCCCAAAAAAAAABBBBBBBBBBCCCCCCCCCAABBBBBBBCCCCCCCC < Father side A
268         // 0x4444444455555555555555556666666666666644444444455555555555666666 < Father side B
269 
270         // 0x1111111111112222222223333311111111122222223333333331111112222222 < Mother side A
271         // 0x7777788888888888999999999999977777777777788888888888999999997777 < Mother side B
272 
273         //   xxxxxxxxxxxxxxxxx           xxxxxxxxx                         xx
274         // 0xAAABBBBBBBBCCCCCD99999999998BBBBBBBBF77778888888888899999999774C < Child side A
275         //   xxx                       xxxxxxxxxxx
276         // 0x4441111111112222222223333366666666666222223333333331111112222222 < Child side B
277 
278         // And then random mutations, for gene pool expansion.
279         // Each bit is flipped with a 3.125% chance
280 
281         // Example:
282         //a2c37edc61dca0ca0b199e098c80fd5a221c2ad03605b4b54332361358745042 < random hash 1
283         //c217d04b19a83fe497c1cf6e1e10030e455a0812a6949282feec27d67fe2baa7 < random hash 2
284         //2636a55f38bed26d804c63a13628e21b2d701c902ca37b2b0ca94fada3821364 < random hash 3
285         //86bb023a85e2da50ac233b946346a53aa070943b0a8e91c56e42ba181729a5f9 < random hash 4
286         //5d71456a1288ab30ddd4c955384d42e66a09d424bd7743791e3eab8e09aa13f1 < random hash 5
287         //0000000800800000000000000000000200000000000000000000020000000000 < resulting mutation
288         //aaabbbbbbbbcccccd99999999998bbbbbbbbf77778888888888899999999774c < original
289         //aaabbbb3bb3cccccd99999999998bbb9bbbbf7777888888888889b999999774c < mutated (= original XOR mutation)
290     }
291 
292     // Generates (psuedo) random Pepe DNA
293     function randomDNA(uint256 seed) internal pure returns (uint256[2] memOffset) {
294 
295         // solhint-disable-next-line no-inline-assembly
296         assembly {
297             // allocate output
298             // 1) get the pointer to our memory
299             memOffset := mload(0x40)
300             // 2) Change the free-memory pointer to keep our memory
301             //     (we will only use 64 bytes: 2 values of 256 bits)
302             mstore(0x40, add(memOffset, 64))
303 
304             // Load the seed into 1st scratchpad memory slot.
305             // adjacent to the additional value (used to create two distinct hashes)
306             mstore(0x0, seed)
307 
308             // In second scratchpad slot:
309             // The additional value can be any word, as long as the caller uses
310             //  it (second hash needs to be different)
311             mstore(0x20, 0x434f4c4c454354205045504553204f4e2043525950544f50455045532e494f21)
312 
313 
314             // // Create first element pointer of array
315             // mstore(memOffset, add(memOffset, 64)) // pointer 1
316             // mstore(add(memOffset, 32), add(memOffset, 96)) // pointer 2
317 
318             // control block to auto-pop the hash.
319             {
320                 // L * N * 2 * 4 = 4 * 2 * 2 * 4 = 64 bytes, 2x 256 bit hash
321 
322                 // Sha3 is cheaper than sha256, make use of it
323                 let hash := keccak256(0, 64)
324 
325                 // Store first array value
326                 mstore(memOffset, hash)
327 
328                 // Now hash again, but only 32 bytes of input,
329                 //  to ignore make the input different than the previous call,
330                 hash := keccak256(0, 32)
331                 mstore(add(memOffset, 32), hash)
332 
333             }
334 
335         }
336     }
337 
338 }
339 
340 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
341 
342 /**
343  * @title Ownable
344  * @dev The Ownable contract has an owner address, and provides basic authorization control
345  * functions, this simplifies the implementation of "user permissions".
346  */
347 contract Ownable {
348   address public owner;
349 
350 
351   event OwnershipRenounced(address indexed previousOwner);
352   event OwnershipTransferred(
353     address indexed previousOwner,
354     address indexed newOwner
355   );
356 
357 
358   /**
359    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
360    * account.
361    */
362   constructor() public {
363     owner = msg.sender;
364   }
365 
366   /**
367    * @dev Throws if called by any account other than the owner.
368    */
369   modifier onlyOwner() {
370     require(msg.sender == owner);
371     _;
372   }
373 
374   /**
375    * @dev Allows the current owner to relinquish control of the contract.
376    * @notice Renouncing to ownership will leave the contract without an owner.
377    * It will not be possible to call the functions with the `onlyOwner`
378    * modifier anymore.
379    */
380   function renounceOwnership() public onlyOwner {
381     emit OwnershipRenounced(owner);
382     owner = address(0);
383   }
384 
385   /**
386    * @dev Allows the current owner to transfer control of the contract to a newOwner.
387    * @param _newOwner The address to transfer ownership to.
388    */
389   function transferOwnership(address _newOwner) public onlyOwner {
390     _transferOwnership(_newOwner);
391   }
392 
393   /**
394    * @dev Transfers control of the contract to a newOwner.
395    * @param _newOwner The address to transfer ownership to.
396    */
397   function _transferOwnership(address _newOwner) internal {
398     require(_newOwner != address(0));
399     emit OwnershipTransferred(owner, _newOwner);
400     owner = _newOwner;
401   }
402 }
403 
404 // File: contracts/Usernames.sol
405 
406 // solhint-disable-next-line
407 pragma solidity ^0.4.19;
408 
409 
410 contract Usernames {
411 
412     mapping(address => bytes32) public addressToUser;
413     mapping(bytes32 => address) public userToAddress;
414 
415     event UserNamed(address indexed user, bytes32 indexed username);
416 
417     /**
418      * Claim a username. Frees up a previously used one
419      * @param _username to claim
420      */
421     function claimUsername(bytes32 _username) external {
422         require(userToAddress[_username] == address(0));// Username must be free
423 
424         if (addressToUser[msg.sender] != bytes32(0)) { // If user already has username free it up
425             userToAddress[addressToUser[msg.sender]] = address(0);
426         }
427 
428         //all is well assign username
429         addressToUser[msg.sender] = _username;
430         userToAddress[_username] = msg.sender;
431 
432         emit UserNamed(msg.sender, _username);
433 
434     }
435 
436 }
437 
438 // File: contracts/Beneficiary.sol
439 
440 // solhint-disable-next-line
441 pragma solidity ^0.4.24;
442 
443 
444 
445 /** @title Beneficiary */
446 contract Beneficiary is Ownable {
447     address public beneficiary;
448 
449     constructor() public {
450         beneficiary = msg.sender;
451     }
452 
453     /**
454      * @dev Change the beneficiary address
455      * @param _beneficiary Address of the new beneficiary
456      */
457     function setBeneficiary(address _beneficiary) public onlyOwner {
458         beneficiary = _beneficiary;
459     }
460 }
461 
462 // File: contracts/Affiliate.sol
463 
464 // solhint-disable-next-line
465 pragma solidity ^0.4.25;
466 
467 
468 
469 /** @title Affiliate */
470 contract Affiliate is Ownable {
471     mapping(address => bool) public canSetAffiliate;
472     mapping(address => address) public userToAffiliate;
473 
474     /** @dev Allows an address to set the affiliate address for a user
475       * @param _setter The address that should be allowed
476       */
477     function setAffiliateSetter(address _setter) public onlyOwner {
478         canSetAffiliate[_setter] = true;
479     }
480 
481     /**
482      * @dev Set the affiliate of a user
483      * @param _user user to set affiliate for
484      * @param _affiliate address to set
485      */
486     function setAffiliate(address _user, address _affiliate) public {
487         require(canSetAffiliate[msg.sender]);
488         if (userToAffiliate[_user] == address(0)) {
489             userToAffiliate[_user] = _affiliate;
490         }
491     }
492 
493 }
494 
495 // File: contracts/interfaces/ERC721.sol
496 
497 contract ERC721 {
498     function implementsERC721() public pure returns (bool);
499     function totalSupply() public view returns (uint256 total);
500     function balanceOf(address _owner) public view returns (uint256 balance);
501     function ownerOf(uint256 _tokenId) public view returns (address owner);
502     function approve(address _to, uint256 _tokenId) public;
503     function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) ;
504     function transfer(address _to, uint256 _tokenId) public returns (bool);
505     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
506     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
507 
508     // Optional
509     // function name() public view returns (string name);
510     // function symbol() public view returns (string symbol);
511     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
512     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
513 }
514 
515 // File: contracts/interfaces/PepeInterface.sol
516 
517 contract PepeInterface is ERC721{
518     function cozyTime(uint256 _mother, uint256 _father, address _pepeReceiver) public returns (bool);
519     function getCozyAgain(uint256 _pepeId) public view returns(uint64);
520 }
521 
522 // File: contracts/AuctionBase.sol
523 
524 // solhint-disable-next-line
525 pragma solidity ^0.4.24;
526 
527 
528 
529 
530 
531 /** @title AuctionBase */
532 contract AuctionBase is Beneficiary {
533     mapping(uint256 => PepeAuction) public auctions;//maps pepes to auctions
534     PepeInterface public pepeContract;
535     Affiliate public affiliateContract;
536     uint256 public fee = 37500; //in 1 10000th of a percent so 3.75% at the start
537     uint256 public constant FEE_DIVIDER = 1000000; //Perhaps needs better name?
538 
539     struct PepeAuction {
540         address seller;
541         uint256 pepeId;
542         uint64 auctionBegin;
543         uint64 auctionEnd;
544         uint256 beginPrice;
545         uint256 endPrice;
546     }
547 
548     event AuctionWon(uint256 indexed pepe, address indexed winner, address indexed seller);
549     event AuctionStarted(uint256 indexed pepe, address indexed seller);
550     event AuctionFinalized(uint256 indexed pepe, address indexed seller);
551 
552     constructor(address _pepeContract, address _affiliateContract) public {
553         pepeContract = PepeInterface(_pepeContract);
554         affiliateContract = Affiliate(_affiliateContract);
555     }
556 
557     /**
558      * @dev Return a pepe from a auction that has passed
559      * @param  _pepeId the id of the pepe to save
560      */
561     function savePepe(uint256 _pepeId) external {
562         // solhint-disable-next-line not-rely-on-time
563         require(auctions[_pepeId].auctionEnd < now);//auction must have ended
564         require(pepeContract.transfer(auctions[_pepeId].seller, _pepeId));//transfer pepe back to seller
565 
566         emit AuctionFinalized(_pepeId, auctions[_pepeId].seller);
567 
568         delete auctions[_pepeId];//delete auction
569     }
570 
571     /**
572      * @dev change the fee on pepe sales. Can only be lowerred
573      * @param _fee The new fee to set. Must be lower than current fee
574      */
575     function changeFee(uint256 _fee) external onlyOwner {
576         require(_fee < fee);//fee can not be raised
577         fee = _fee;
578     }
579 
580     /**
581      * @dev Start a auction
582      * @param  _pepeId Pepe to sell
583      * @param  _beginPrice Price at which the auction starts
584      * @param  _endPrice Ending price of the auction
585      * @param  _duration How long the auction should take
586      */
587     function startAuction(uint256 _pepeId, uint256 _beginPrice, uint256 _endPrice, uint64 _duration) public {
588         require(pepeContract.transferFrom(msg.sender, address(this), _pepeId));
589         // solhint-disable-next-line not-rely-on-time
590         require(now > auctions[_pepeId].auctionEnd);//can only start new auction if no other is active
591 
592         PepeAuction memory auction;
593 
594         auction.seller = msg.sender;
595         auction.pepeId = _pepeId;
596         // solhint-disable-next-line not-rely-on-time
597         auction.auctionBegin = uint64(now);
598         // solhint-disable-next-line not-rely-on-time
599         auction.auctionEnd = uint64(now) + _duration;
600         require(auction.auctionEnd > auction.auctionBegin);
601         auction.beginPrice = _beginPrice;
602         auction.endPrice = _endPrice;
603 
604         auctions[_pepeId] = auction;
605 
606         emit AuctionStarted(_pepeId, msg.sender);
607     }
608 
609     /**
610      * @dev directly start a auction from the PepeBase contract
611      * @param  _pepeId Pepe to put on auction
612      * @param  _beginPrice Price at which the auction starts
613      * @param  _endPrice Ending price of the auction
614      * @param  _duration How long the auction should take
615      * @param  _seller The address selling the pepe
616      */
617     // solhint-disable-next-line max-line-length
618     function startAuctionDirect(uint256 _pepeId, uint256 _beginPrice, uint256 _endPrice, uint64 _duration, address _seller) public {
619         require(msg.sender == address(pepeContract)); //can only be called by pepeContract
620         //solhint-disable-next-line not-rely-on-time
621         require(now > auctions[_pepeId].auctionEnd);//can only start new auction if no other is active
622 
623         PepeAuction memory auction;
624 
625         auction.seller = _seller;
626         auction.pepeId = _pepeId;
627         // solhint-disable-next-line not-rely-on-time
628         auction.auctionBegin = uint64(now);
629         // solhint-disable-next-line not-rely-on-time
630         auction.auctionEnd = uint64(now) + _duration;
631         require(auction.auctionEnd > auction.auctionBegin);
632         auction.beginPrice = _beginPrice;
633         auction.endPrice = _endPrice;
634 
635         auctions[_pepeId] = auction;
636 
637         emit AuctionStarted(_pepeId, _seller);
638     }
639 
640   /**
641    * @dev Calculate the current price of a auction
642    * @param  _pepeId the pepeID to calculate the current price for
643    * @return currentBid the current price for the auction
644    */
645     function calculateBid(uint256 _pepeId) public view returns(uint256 currentBid) {
646         PepeAuction storage auction = auctions[_pepeId];
647         // solhint-disable-next-line not-rely-on-time
648         uint256 timePassed = now - auctions[_pepeId].auctionBegin;
649 
650         // If auction ended return auction end price.
651         // solhint-disable-next-line not-rely-on-time
652         if (now >= auction.auctionEnd) {
653             return auction.endPrice;
654         } else {
655             // Can be negative
656             int256 priceDifference = int256(auction.endPrice) - int256(auction.beginPrice);
657             // Always positive
658             int256 duration = int256(auction.auctionEnd) - int256(auction.auctionBegin);
659 
660             // As already proven in practice by CryptoKitties:
661             //  timePassed -> 64 bits at most
662             //  priceDifference -> 128 bits at most
663             //  timePassed * priceDifference -> 64 + 128 bits at most
664             int256 priceChange = priceDifference * int256(timePassed) / duration;
665 
666             // Will be positive, both operands are less than 256 bits
667             int256 price = int256(auction.beginPrice) + priceChange;
668 
669             return uint256(price);
670         }
671     }
672 
673   /**
674    * @dev collect the fees from the auction
675    */
676     function getFees() public {
677         beneficiary.transfer(address(this).balance);
678     }
679 
680 
681 }
682 
683 // File: contracts/CozyTimeAuction.sol
684 
685 // solhint-disable-next-line
686 pragma solidity ^0.4.24;
687 
688 
689 
690 /** @title CozyTimeAuction */
691 contract CozyTimeAuction is AuctionBase {
692     // solhint-disable-next-line
693     constructor (address _pepeContract, address _affiliateContract) AuctionBase(_pepeContract, _affiliateContract) public {
694 
695     }
696 
697     /**
698      * @dev Start an auction
699      * @param  _pepeId The id of the pepe to start the auction for
700      * @param  _beginPrice Start price of the auction
701      * @param  _endPrice End price of the auction
702      * @param  _duration How long the auction should take
703      */
704     function startAuction(uint256 _pepeId, uint256 _beginPrice, uint256 _endPrice, uint64 _duration) public {
705         // solhint-disable-next-line not-rely-on-time
706         require(pepeContract.getCozyAgain(_pepeId) <= now);//need to have this extra check
707         super.startAuction(_pepeId, _beginPrice, _endPrice, _duration);
708     }
709 
710     /**
711      * @dev Start a auction direclty from the PepeBase smartcontract
712      * @param  _pepeId The id of the pepe to start the auction for
713      * @param  _beginPrice Start price of the auction
714      * @param  _endPrice End price of the auction
715      * @param  _duration How long the auction should take
716      * @param  _seller The address of the seller
717      */
718     // solhint-disable-next-line max-line-length
719     function startAuctionDirect(uint256 _pepeId, uint256 _beginPrice, uint256 _endPrice, uint64 _duration, address _seller) public {
720         // solhint-disable-next-line not-rely-on-time
721         require(pepeContract.getCozyAgain(_pepeId) <= now);//need to have this extra check
722         super.startAuctionDirect(_pepeId, _beginPrice, _endPrice, _duration, _seller);
723     }
724 
725     /**
726      * @dev Buy cozy right from the auction
727      * @param  _pepeId Pepe to cozy with
728      * @param  _cozyCandidate the pepe to cozy with
729      * @param  _candidateAsFather Is the _cozyCandidate father?
730      * @param  _pepeReceiver address receiving the pepe after cozy time
731      */
732     // solhint-disable-next-line max-line-length
733     function buyCozy(uint256 _pepeId, uint256 _cozyCandidate, bool _candidateAsFather, address _pepeReceiver) public payable {
734         require(address(pepeContract) == msg.sender); //caller needs to be the PepeBase contract
735 
736         PepeAuction storage auction = auctions[_pepeId];
737         // solhint-disable-next-line not-rely-on-time
738         require(now < auction.auctionEnd);// auction must be still going
739 
740         uint256 price = calculateBid(_pepeId);
741         require(msg.value >= price);//must send enough ether
742         uint256 totalFee = price * fee / FEE_DIVIDER; //safe math needed?
743 
744         //Send ETH to seller
745         auction.seller.transfer(price - totalFee);
746         //send ETH to beneficiary
747 
748         address affiliate = affiliateContract.userToAffiliate(_pepeReceiver);
749 
750         //solhint-disable-next-line
751         if (affiliate != address(0) && affiliate.send(totalFee / 2)) { //if user has affiliate
752             //nothing just to suppress warning
753         }
754 
755         //actual cozytiming
756         if (_candidateAsFather) {
757             if (!pepeContract.cozyTime(auction.pepeId, _cozyCandidate, _pepeReceiver)) {
758                 revert();
759             }
760         } else {
761           // Swap around the two pepes, they have no set gender, the user decides what they are.
762             if (!pepeContract.cozyTime(_cozyCandidate, auction.pepeId, _pepeReceiver)) {
763                 revert();
764             }
765         }
766 
767         //Send pepe to seller of auction
768         if (!pepeContract.transfer(auction.seller, _pepeId)) {
769             revert(); //can't complete transfer if this fails
770         }
771 
772         if (msg.value > price) { //return ether send to much
773             _pepeReceiver.transfer(msg.value - price);
774         }
775 
776         emit AuctionWon(_pepeId, _pepeReceiver, auction.seller);//emit event
777 
778         delete auctions[_pepeId];//deletes auction
779     }
780 
781     /**
782      * @dev Buy cozytime and pass along affiliate
783      * @param  _pepeId Pepe to cozy with
784      * @param  _cozyCandidate the pepe to cozy with
785      * @param  _candidateAsFather Is the _cozyCandidate father?
786      * @param  _pepeReceiver address receiving the pepe after cozy time
787      * @param  _affiliate Affiliate address to set
788      */
789     //solhint-disable-next-line max-line-length
790     function buyCozyAffiliated(uint256 _pepeId, uint256 _cozyCandidate, bool _candidateAsFather, address _pepeReceiver, address _affiliate) public payable {
791         affiliateContract.setAffiliate(_pepeReceiver, _affiliate);
792         buyCozy(_pepeId, _cozyCandidate, _candidateAsFather, _pepeReceiver);
793     }
794 }
795 
796 // File: contracts/Haltable.sol
797 
798 // solhint-disable-next-line
799 pragma solidity ^0.4.24;
800 
801 
802 
803 contract Haltable is Ownable {
804     uint256 public haltTime; //when the contract was halted
805     bool public halted;//is the contract halted?
806     uint256 public haltDuration;
807     uint256 public maxHaltDuration = 8 weeks;//how long the contract can be halted
808 
809     modifier stopWhenHalted {
810         require(!halted);
811         _;
812     }
813 
814     modifier onlyWhenHalted {
815         require(halted);
816         _;
817     }
818 
819     /**
820      * @dev Halt the contract for a set time smaller than maxHaltDuration
821      * @param  _duration Duration how long the contract should be halted. Must be smaller than maxHaltDuration
822      */
823     function halt(uint256 _duration) public onlyOwner {
824         require(haltTime == 0); //cannot halt if it was halted before
825         require(_duration <= maxHaltDuration);//cannot halt for longer than maxHaltDuration
826         haltDuration = _duration;
827         halted = true;
828         // solhint-disable-next-line not-rely-on-time
829         haltTime = now;
830     }
831 
832     /**
833      * @dev Unhalt the contract. Can only be called by the owner or when the haltTime has passed
834      */
835     function unhalt() public {
836         // solhint-disable-next-line
837         require(now > haltTime + haltDuration || msg.sender == owner);//unhalting is only possible when haltTime has passed or the owner unhalts
838         halted = false;
839     }
840 
841 }
842 
843 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
844 
845 /**
846  * @title SafeMath
847  * @dev Math operations with safety checks that throw on error
848  */
849 library SafeMath {
850 
851   /**
852   * @dev Multiplies two numbers, throws on overflow.
853   */
854   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
855     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
856     // benefit is lost if 'b' is also tested.
857     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
858     if (a == 0) {
859       return 0;
860     }
861 
862     c = a * b;
863     assert(c / a == b);
864     return c;
865   }
866 
867   /**
868   * @dev Integer division of two numbers, truncating the quotient.
869   */
870   function div(uint256 a, uint256 b) internal pure returns (uint256) {
871     // assert(b > 0); // Solidity automatically throws when dividing by 0
872     // uint256 c = a / b;
873     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
874     return a / b;
875   }
876 
877   /**
878   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
879   */
880   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
881     assert(b <= a);
882     return a - b;
883   }
884 
885   /**
886   * @dev Adds two numbers, throws on overflow.
887   */
888   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
889     c = a + b;
890     assert(c >= a);
891     return c;
892   }
893 }
894 
895 // File: contracts/interfaces/ERC721TokenReceiver.sol
896 
897 /// @dev Note: the ERC-165 identifier for this interface is 0xf0b9e5ba
898 interface ERC721TokenReceiver {
899     /// @notice Handle the receipt of an NFT
900     /// @dev The ERC721 smart contract calls this function on the recipient
901     ///  after a `transfer`. This function MAY throw to revert and reject the
902     ///  transfer. This function MUST use 50,000 gas or less. Return of other
903     ///  than the magic value MUST result in the transaction being reverted.
904     ///  Note: the contract address is always the message sender.
905     /// @param _from The sending address
906     /// @param _tokenId The NFT identifier which is being transfered
907     /// @param data Additional data with no specified format
908     /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
909     ///  unless throwing
910 	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
911 }
912 
913 // File: contracts/PepeBase.sol
914 
915 // solhint-disable-next-line
916 pragma solidity ^0.4.24;
917 
918 // solhint-disable func-order
919 
920 
921 
922 
923 
924 
925 
926 
927 
928 
929 contract PepeBase is Genetic, Ownable, Usernames, Haltable {
930 
931     uint32[15] public cozyCoolDowns = [ //determined by generation / 2
932         uint32(1 minutes),
933         uint32(2 minutes),
934         uint32(5 minutes),
935         uint32(15 minutes),
936         uint32(30 minutes),
937         uint32(45 minutes),
938         uint32(1 hours),
939         uint32(2 hours),
940         uint32(4 hours),
941         uint32(8 hours),
942         uint32(16 hours),
943         uint32(1 days),
944         uint32(2 days),
945         uint32(4 days),
946         uint32(7 days)
947     ];
948 
949     struct Pepe {
950         address master; //The master of the pepe
951         uint256[2] genotype; //all genes stored here
952         uint64 canCozyAgain; //time when pepe can have nice time again
953         uint64 generation; //what generation?
954         uint64 father; //father of this pepe
955         uint64 mother; //mommy of this pepe
956         uint8 coolDownIndex;
957     }
958 
959     mapping(uint256 => bytes32) public pepeNames;
960 
961     //stores all pepes
962     Pepe[] public pepes;
963 
964     bool public implementsERC721 = true; //signal erc721 support
965 
966     // solhint-disable-next-line const-name-snakecase
967     string public constant name = "Crypto Pepe";
968     // solhint-disable-next-line const-name-snakecase
969     string public constant symbol = "CPEP";
970 
971     mapping(address => uint256[]) private wallets;
972     mapping(address => uint256) public balances; //amounts of pepes per address
973     mapping(uint256 => address) public approved; //pepe index to address approved to transfer
974     mapping(address => mapping(address => bool)) public approvedForAll;
975 
976     uint256 public zeroGenPepes; //how many zero gen pepes are mined
977     uint256 public constant MAX_PREMINE = 100;//how many pepes can be premined
978     uint256 public constant MAX_ZERO_GEN_PEPES = 1100; //max number of zero gen pepes
979     address public miner; //address of the miner contract
980 
981     modifier onlyPepeMaster(uint256 _pepeId) {
982         require(pepes[_pepeId].master == msg.sender);
983         _;
984     }
985 
986     modifier onlyAllowed(uint256 _tokenId) {
987         // solhint-disable-next-line max-line-length
988         require(msg.sender == pepes[_tokenId].master || msg.sender == approved[_tokenId] || approvedForAll[pepes[_tokenId].master][msg.sender]); //check if msg.sender is allowed
989         _;
990     }
991 
992     event PepeBorn(uint256 indexed mother, uint256 indexed father, uint256 indexed pepeId);
993     event PepeNamed(uint256 indexed pepeId);
994 
995     constructor() public {
996 
997         Pepe memory pepe0 = Pepe({
998             master: 0x0,
999             genotype: [uint256(0), uint256(0)],
1000             canCozyAgain: 0,
1001             father: 0,
1002             mother: 0,
1003             generation: 0,
1004             coolDownIndex: 0
1005         });
1006 
1007         pepes.push(pepe0);
1008     }
1009 
1010     /**
1011      * @dev Internal function that creates a new pepe
1012      * @param  _genoType DNA of the new pepe
1013      * @param  _mother The ID of the mother
1014      * @param  _father The ID of the father
1015      * @param  _generation The generation of the new Pepe
1016      * @param  _master The owner of this new Pepe
1017      * @return The ID of the newly generated Pepe
1018      */
1019     // solhint-disable-next-line max-line-length
1020     function _newPepe(uint256[2] _genoType, uint64 _mother, uint64 _father, uint64 _generation, address _master) internal returns (uint256 pepeId) {
1021         uint8 tempCoolDownIndex;
1022 
1023         tempCoolDownIndex = uint8(_generation / 2);
1024 
1025         if (_generation > 28) {
1026             tempCoolDownIndex = 14;
1027         }
1028 
1029         Pepe memory _pepe = Pepe({
1030             master: _master, //The master of the pepe
1031             genotype: _genoType, //all genes stored here
1032             canCozyAgain: 0, //time when pepe can have nice time again
1033             father: _father, //father of this pepe
1034             mother: _mother, //mommy of this pepe
1035             generation: _generation, //what generation?
1036             coolDownIndex: tempCoolDownIndex
1037         });
1038 
1039         if (_generation == 0) {
1040             zeroGenPepes += 1; //count zero gen pepes
1041         }
1042 
1043         //push returns the new length, use it to get a new unique id
1044         pepeId = pepes.push(_pepe) - 1;
1045 
1046         //add it to the wallet of the master of the new pepe
1047         addToWallet(_master, pepeId);
1048 
1049         emit PepeBorn(_mother, _father, pepeId);
1050         emit Transfer(address(0), _master, pepeId);
1051 
1052         return pepeId;
1053     }
1054 
1055     /**
1056      * @dev Set the miner contract. Can only be called once
1057      * @param _miner Address of the miner contract
1058      */
1059     function setMiner(address _miner) public onlyOwner {
1060         require(miner == address(0));//can only be set once
1061         miner = _miner;
1062     }
1063 
1064     /**
1065      * @dev Mine a new Pepe. Can only be called by the miner contract.
1066      * @param  _seed Seed to be used for the generation of the DNA
1067      * @param  _receiver Address receiving the newly mined Pepe
1068      * @return The ID of the newly mined Pepe
1069      */
1070     function minePepe(uint256 _seed, address _receiver) public stopWhenHalted returns(uint256) {
1071         require(msg.sender == miner);//only miner contract can call
1072         require(zeroGenPepes < MAX_ZERO_GEN_PEPES);
1073 
1074         return _newPepe(randomDNA(_seed), 0, 0, 0, _receiver);
1075     }
1076 
1077     /**
1078      * @dev Premine pepes. Can only be called by the owner and is limited to MAX_PREMINE
1079      * @param  _amount Amount of Pepes to premine
1080      */
1081     function pepePremine(uint256 _amount) public onlyOwner stopWhenHalted {
1082         for (uint i = 0; i < _amount; i++) {
1083             require(zeroGenPepes <= MAX_PREMINE);//can only generate set amount during premine
1084             //create a new pepe
1085             // 1) who's genes are based on hash of the timestamp and the number of pepes
1086             // 2) who has no mother or father
1087             // 3) who is generation zero
1088             // 4) who's master is the manager
1089 
1090             // solhint-disable-next-line
1091             _newPepe(randomDNA(uint256(keccak256(abi.encodePacked(block.timestamp, pepes.length)))), 0, 0, 0, owner);
1092 
1093         }
1094     }
1095 
1096     /**
1097      * @dev CozyTime two Pepes together
1098      * @param  _mother The mother of the new Pepe
1099      * @param  _father The father of the new Pepe
1100      * @param  _pepeReceiver Address receiving the new Pepe
1101      * @return If it was a success
1102      */
1103     function cozyTime(uint256 _mother, uint256 _father, address _pepeReceiver) external stopWhenHalted returns (bool) {
1104         //cannot cozyTime with itself
1105         require(_mother != _father);
1106         //caller has to either be master or approved for mother
1107         // solhint-disable-next-line max-line-length
1108         require(pepes[_mother].master == msg.sender || approved[_mother] == msg.sender || approvedForAll[pepes[_mother].master][msg.sender]);
1109         //caller has to either be master or approved for father
1110         // solhint-disable-next-line max-line-length
1111         require(pepes[_father].master == msg.sender || approved[_father] == msg.sender || approvedForAll[pepes[_father].master][msg.sender]);
1112         //require both parents to be ready for cozytime
1113         // solhint-disable-next-line not-rely-on-time
1114         require(now > pepes[_mother].canCozyAgain && now > pepes[_father].canCozyAgain);
1115         //require both mother parents not to be father
1116         require(pepes[_mother].mother != _father && pepes[_mother].father != _father);
1117         //require both father parents not to be mother
1118         require(pepes[_father].mother != _mother && pepes[_father].father != _mother);
1119 
1120         Pepe storage father = pepes[_father];
1121         Pepe storage mother = pepes[_mother];
1122 
1123 
1124         approved[_father] = address(0);
1125         approved[_mother] = address(0);
1126 
1127         uint256[2] memory newGenotype = breed(father.genotype, mother.genotype, pepes.length);
1128 
1129         uint64 newGeneration;
1130 
1131         newGeneration = mother.generation + 1;
1132         if (newGeneration < father.generation + 1) { //if father generation is bigger
1133             newGeneration = father.generation + 1;
1134         }
1135 
1136         _handleCoolDown(_mother);
1137         _handleCoolDown(_father);
1138 
1139         //sets pepe birth when mother is done
1140         // solhint-disable-next-line max-line-length
1141         pepes[_newPepe(newGenotype, uint64(_mother), uint64(_father), newGeneration, _pepeReceiver)].canCozyAgain = mother.canCozyAgain; //_pepeReceiver becomes the master of the pepe
1142 
1143         return true;
1144     }
1145 
1146     /**
1147      * @dev Internal function to increase the coolDownIndex
1148      * @param _pepeId The id of the Pepe to update the coolDown of
1149      */
1150     function _handleCoolDown(uint256 _pepeId) internal {
1151         Pepe storage tempPep = pepes[_pepeId];
1152 
1153         // solhint-disable-next-line not-rely-on-time
1154         tempPep.canCozyAgain = uint64(now + cozyCoolDowns[tempPep.coolDownIndex]);
1155 
1156         if (tempPep.coolDownIndex < 14) {// after every cozy time pepe gets slower
1157             tempPep.coolDownIndex++;
1158         }
1159 
1160     }
1161 
1162     /**
1163      * @dev Set the name of a Pepe. Can only be set once
1164      * @param _pepeId ID of the pepe to name
1165      * @param _name The name to assign
1166      */
1167     function setPepeName(uint256 _pepeId, bytes32 _name) public stopWhenHalted onlyPepeMaster(_pepeId) returns(bool) {
1168         require(pepeNames[_pepeId] == 0x0000000000000000000000000000000000000000000000000000000000000000);
1169         pepeNames[_pepeId] = _name;
1170         emit PepeNamed(_pepeId);
1171         return true;
1172     }
1173 
1174     /**
1175      * @dev Transfer a Pepe to the auction contract and auction it
1176      * @param  _pepeId ID of the Pepe to auction
1177      * @param  _auction Auction contract address
1178      * @param  _beginPrice Price the auction starts at
1179      * @param  _endPrice Price the auction ends at
1180      * @param  _duration How long the auction should run
1181      */
1182     // solhint-disable-next-line max-line-length
1183     function transferAndAuction(uint256 _pepeId, address _auction, uint256 _beginPrice, uint256 _endPrice, uint64 _duration) public stopWhenHalted onlyPepeMaster(_pepeId) {
1184         _transfer(msg.sender, _auction, _pepeId);//transfer pepe to auction
1185         AuctionBase auction = AuctionBase(_auction);
1186 
1187         auction.startAuctionDirect(_pepeId, _beginPrice, _endPrice, _duration, msg.sender);
1188     }
1189 
1190     /**
1191      * @dev Approve and buy. Used to buy cozyTime in one call
1192      * @param  _pepeId Pepe to cozy with
1193      * @param  _auction Address of the auction contract
1194      * @param  _cozyCandidate Pepe to approve and cozy with
1195      * @param  _candidateAsFather Use the candidate as father or not
1196      */
1197     // solhint-disable-next-line max-line-length
1198     function approveAndBuy(uint256 _pepeId, address _auction, uint256 _cozyCandidate, bool _candidateAsFather) public stopWhenHalted payable onlyPepeMaster(_cozyCandidate) {
1199         approved[_cozyCandidate] = _auction;
1200         // solhint-disable-next-line max-line-length
1201         CozyTimeAuction(_auction).buyCozy.value(msg.value)(_pepeId, _cozyCandidate, _candidateAsFather, msg.sender); //breeding resets approval
1202     }
1203 
1204     /**
1205      * @dev The same as above only pass an extra parameter
1206      * @param  _pepeId Pepe to cozy with
1207      * @param  _auction Address of the auction contract
1208      * @param  _cozyCandidate Pepe to approve and cozy with
1209      * @param  _candidateAsFather Use the candidate as father or not
1210      * @param  _affiliate Address to set as affiliate
1211      */
1212     // solhint-disable-next-line max-line-length
1213     function approveAndBuyAffiliated(uint256 _pepeId, address _auction, uint256 _cozyCandidate, bool _candidateAsFather, address _affiliate) public stopWhenHalted payable onlyPepeMaster(_cozyCandidate) {
1214         approved[_cozyCandidate] = _auction;
1215         // solhint-disable-next-line max-line-length
1216         CozyTimeAuction(_auction).buyCozyAffiliated.value(msg.value)(_pepeId, _cozyCandidate, _candidateAsFather, msg.sender, _affiliate); //breeding resets approval
1217     }
1218 
1219     /**
1220      * @dev get Pepe information
1221      * @param  _pepeId ID of the Pepe to get information of
1222      * @return master
1223      * @return genotype
1224      * @return canCozyAgain
1225      * @return generation
1226      * @return father
1227      * @return mother
1228      * @return pepeName
1229      * @return coolDownIndex
1230      */
1231     // solhint-disable-next-line max-line-length
1232     function getPepe(uint256 _pepeId) public view returns(address master, uint256[2] genotype, uint64 canCozyAgain, uint64 generation, uint256 father, uint256 mother, bytes32 pepeName, uint8 coolDownIndex) {
1233         Pepe storage tempPep = pepes[_pepeId];
1234 
1235         master = tempPep.master;
1236         genotype = tempPep.genotype;
1237         canCozyAgain = tempPep.canCozyAgain;
1238         generation = tempPep.generation;
1239         father = tempPep.father;
1240         mother = tempPep.mother;
1241         pepeName = pepeNames[_pepeId];
1242         coolDownIndex = tempPep.coolDownIndex;
1243     }
1244 
1245     /**
1246      * @dev Get the time when a pepe can cozy again
1247      * @param  _pepeId ID of the pepe
1248      * @return Time when the pepe can cozy again
1249      */
1250     function getCozyAgain(uint256 _pepeId) public view returns(uint64) {
1251         return pepes[_pepeId].canCozyAgain;
1252     }
1253 
1254     /**
1255      *  ERC721 Compatibility
1256      *
1257      */
1258     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
1259     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
1260     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
1261 
1262     /**
1263      * @dev Get the total number of Pepes
1264      * @return total Returns the total number of pepes
1265      */
1266     function totalSupply() public view returns(uint256 total) {
1267         total = pepes.length - balances[address(0)];
1268         return total;
1269     }
1270 
1271     /**
1272      * @dev Get the number of pepes owned by an address
1273      * @param  _owner Address to get the balance from
1274      * @return balance The number of pepes
1275      */
1276     function balanceOf(address _owner) external view returns (uint256 balance) {
1277         balance = balances[_owner];
1278     }
1279 
1280     /**
1281      * @dev Get the owner of a Pepe
1282      * @param  _tokenId the token to get the owner of
1283      * @return _owner the owner of the pepe
1284      */
1285     function ownerOf(uint256 _tokenId) external view returns (address _owner) {
1286         _owner = pepes[_tokenId].master;
1287     }
1288 
1289     /**
1290      * @dev Get the id of an token by its index
1291      * @param _owner The address to look up the tokens of
1292      * @param _index Index to look at
1293      * @return tokenId the ID of the token of the owner at the specified index
1294      */
1295     function tokenOfOwnerByIndex(address _owner, uint256 _index) public constant returns (uint256 tokenId) {
1296         //The index must be smaller than the balance,
1297         // to guarantee that there is no leftover token returned.
1298         require(_index < balances[_owner]);
1299 
1300         return wallets[_owner][_index];
1301     }
1302 
1303     /**
1304      * @dev Private method that ads a token to the wallet
1305      * @param _owner Address of the owner
1306      * @param _tokenId Pepe ID to add
1307      */
1308     function addToWallet(address _owner, uint256 _tokenId) private {
1309         uint256[] storage wallet = wallets[_owner];
1310         uint256 balance = balances[_owner];
1311         if (balance < wallet.length) {
1312             wallet[balance] = _tokenId;
1313         } else {
1314             wallet.push(_tokenId);
1315         }
1316         //increase owner balance
1317         //overflow is not likely to happen(need very large amount of pepes)
1318         balances[_owner] += 1;
1319     }
1320 
1321     /**
1322      * @dev Remove a token from a address's wallet
1323      * @param _owner Address of the owner
1324      * @param _tokenId Token to remove from the wallet
1325      */
1326     function removeFromWallet(address _owner, uint256 _tokenId) private {
1327         uint256[] storage wallet = wallets[_owner];
1328         uint256 i = 0;
1329         // solhint-disable-next-line no-empty-blocks
1330         for (; wallet[i] != _tokenId; i++) {
1331             // not the pepe we are looking for
1332         }
1333         if (wallet[i] == _tokenId) {
1334             //found it!
1335             uint256 last = balances[_owner] - 1;
1336             if (last > 0) {
1337                 //move the last item to this spot, the last will become inaccessible
1338                 wallet[i] = wallet[last];
1339             }
1340             //else: no last item to move, the balance is 0, making everything inaccessible.
1341 
1342             //only decrease balance if _tokenId was in the wallet
1343             balances[_owner] -= 1;
1344         }
1345     }
1346 
1347     /**
1348      * @dev Internal transfer function
1349      * @param _from Address sending the token
1350      * @param _to Address to token is send to
1351      * @param _tokenId ID of the token to send
1352      */
1353     function _transfer(address _from, address _to, uint256 _tokenId) internal {
1354         pepes[_tokenId].master = _to;
1355         approved[_tokenId] = address(0);//reset approved of pepe on every transfer
1356 
1357         //remove the token from the _from wallet
1358         removeFromWallet(_from, _tokenId);
1359 
1360         //add the token to the _to wallet
1361         addToWallet(_to, _tokenId);
1362 
1363         emit Transfer(_from, _to, _tokenId);
1364     }
1365 
1366     /**
1367      * @dev transfer a token. Can only be called by the owner of the token
1368      * @param  _to Addres to send the token to
1369      * @param  _tokenId ID of the token to send
1370      */
1371     // solhint-disable-next-line no-simple-event-func-name
1372     function transfer(address _to, uint256 _tokenId) public stopWhenHalted
1373         onlyPepeMaster(_tokenId) //check if msg.sender is the master of this pepe
1374         returns(bool)
1375     {
1376         _transfer(msg.sender, _to, _tokenId);//after master modifier invoke internal transfer
1377         return true;
1378     }
1379 
1380     /**
1381      * @dev Approve a address to send a token
1382      * @param _to Address to approve
1383      * @param _tokenId Token to set approval for
1384      */
1385     function approve(address _to, uint256 _tokenId) external stopWhenHalted
1386         onlyPepeMaster(_tokenId)
1387     {
1388         approved[_tokenId] = _to;
1389         emit Approval(msg.sender, _to, _tokenId);
1390     }
1391 
1392     /**
1393      * @dev Approve or revoke approval an address for al tokens of a user
1394      * @param _operator Address to (un)approve
1395      * @param _approved Approving or revoking indicator
1396      */
1397     function setApprovalForAll(address _operator, bool _approved) external stopWhenHalted {
1398         if (_approved) {
1399             approvedForAll[msg.sender][_operator] = true;
1400         } else {
1401             approvedForAll[msg.sender][_operator] = false;
1402         }
1403         emit ApprovalForAll(msg.sender, _operator, _approved);
1404     }
1405 
1406     /**
1407      * @dev Get approved address for a token
1408      * @param _tokenId Token ID to get the approved address for
1409      * @return The address that is approved for this token
1410      */
1411     function getApproved(uint256 _tokenId) external view returns (address) {
1412         return approved[_tokenId];
1413     }
1414 
1415     /**
1416      * @dev Get if an operator is approved for all tokens of that owner
1417      * @param _owner Owner to check the approval for
1418      * @param _operator Operator to check approval for
1419      * @return Boolean indicating if the operator is approved for that owner
1420      */
1421     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
1422         return approvedForAll[_owner][_operator];
1423     }
1424 
1425     /**
1426      * @dev Function to signal support for an interface
1427      * @param interfaceID the ID of the interface to check for
1428      * @return Boolean indicating support
1429      */
1430     function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
1431         if (interfaceID == 0x80ac58cd || interfaceID == 0x01ffc9a7) { //TODO: add more interfaces the contract supports
1432             return true;
1433         }
1434         return false;
1435     }
1436 
1437     /**
1438      * @dev Safe transferFrom function
1439      * @param _from Address currently owning the token
1440      * @param _to Address to send token to
1441      * @param _tokenId ID of the token to send
1442      */
1443     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external stopWhenHalted {
1444         _safeTransferFromInternal(_from, _to, _tokenId, "");
1445     }
1446 
1447     /**
1448      * @dev Safe transferFrom function with aditional data attribute
1449      * @param _from Address currently owning the token
1450      * @param _to Address to send token to
1451      * @param _tokenId ID of the token to send
1452      * @param _data Data to pass along call
1453      */
1454     // solhint-disable-next-line max-line-length
1455     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external stopWhenHalted {
1456         _safeTransferFromInternal(_from, _to, _tokenId, _data);
1457     }
1458 
1459     /**
1460      * @dev Internal Safe transferFrom function with aditional data attribute
1461      * @param _from Address currently owning the token
1462      * @param _to Address to send token to
1463      * @param _tokenId ID of the token to send
1464      * @param _data Data to pass along call
1465      */
1466     // solhint-disable-next-line max-line-length
1467     function _safeTransferFromInternal(address _from, address _to, uint256 _tokenId, bytes _data) internal onlyAllowed(_tokenId) {
1468         require(pepes[_tokenId].master == _from);//check if from is current owner
1469         require(_to != address(0));//throw on zero address
1470 
1471         _transfer(_from, _to, _tokenId); //transfer token
1472 
1473         if (isContract(_to)) { //check if is contract
1474             // solhint-disable-next-line max-line-length
1475             require(ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, _data) == bytes4(keccak256("onERC721Received(address,uint256,bytes)")));
1476         }
1477     }
1478 
1479     /**
1480      * @dev TransferFrom function
1481      * @param _from Address currently owning the token
1482      * @param _to Address to send token to
1483      * @param _tokenId ID of the token to send
1484      * @return If it was successful
1485      */
1486     // solhint-disable-next-line max-line-length
1487     function transferFrom(address _from, address _to, uint256 _tokenId) public stopWhenHalted onlyAllowed(_tokenId) returns(bool) {
1488         require(pepes[_tokenId].master == _from);//check if _from is really the master.
1489         require(_to != address(0));
1490         _transfer(_from, _to, _tokenId);//handles event, balances and approval reset;
1491         return true;
1492     }
1493 
1494     /**
1495      * @dev Utility method to check if an address is a contract
1496      * @param _address Address to check
1497      * @return Boolean indicating if the address is a contract
1498      */
1499     function isContract(address _address) internal view returns (bool) {
1500         uint size;
1501         // solhint-disable-next-line no-inline-assembly
1502         assembly { size := extcodesize(_address) }
1503         return size > 0;
1504     }
1505 
1506 }
1507 
1508 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
1509 
1510 /**
1511  * @title ERC20Basic
1512  * @dev Simpler version of ERC20 interface
1513  * See https://github.com/ethereum/EIPs/issues/179
1514  */
1515 contract ERC20Basic {
1516   function totalSupply() public view returns (uint256);
1517   function balanceOf(address who) public view returns (uint256);
1518   function transfer(address to, uint256 value) public returns (bool);
1519   event Transfer(address indexed from, address indexed to, uint256 value);
1520 }
1521 
1522 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
1523 
1524 /**
1525  * @title Basic token
1526  * @dev Basic version of StandardToken, with no allowances.
1527  */
1528 contract BasicToken is ERC20Basic {
1529   using SafeMath for uint256;
1530 
1531   mapping(address => uint256) balances;
1532 
1533   uint256 totalSupply_;
1534 
1535   /**
1536   * @dev Total number of tokens in existence
1537   */
1538   function totalSupply() public view returns (uint256) {
1539     return totalSupply_;
1540   }
1541 
1542   /**
1543   * @dev Transfer token for a specified address
1544   * @param _to The address to transfer to.
1545   * @param _value The amount to be transferred.
1546   */
1547   function transfer(address _to, uint256 _value) public returns (bool) {
1548     require(_to != address(0));
1549     require(_value <= balances[msg.sender]);
1550 
1551     balances[msg.sender] = balances[msg.sender].sub(_value);
1552     balances[_to] = balances[_to].add(_value);
1553     emit Transfer(msg.sender, _to, _value);
1554     return true;
1555   }
1556 
1557   /**
1558   * @dev Gets the balance of the specified address.
1559   * @param _owner The address to query the the balance of.
1560   * @return An uint256 representing the amount owned by the passed address.
1561   */
1562   function balanceOf(address _owner) public view returns (uint256) {
1563     return balances[_owner];
1564   }
1565 
1566 }
1567 
1568 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
1569 
1570 /**
1571  * @title ERC20 interface
1572  * @dev see https://github.com/ethereum/EIPs/issues/20
1573  */
1574 contract ERC20 is ERC20Basic {
1575   function allowance(address owner, address spender)
1576     public view returns (uint256);
1577 
1578   function transferFrom(address from, address to, uint256 value)
1579     public returns (bool);
1580 
1581   function approve(address spender, uint256 value) public returns (bool);
1582   event Approval(
1583     address indexed owner,
1584     address indexed spender,
1585     uint256 value
1586   );
1587 }
1588 
1589 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
1590 
1591 /**
1592  * @title Standard ERC20 token
1593  *
1594  * @dev Implementation of the basic standard token.
1595  * https://github.com/ethereum/EIPs/issues/20
1596  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1597  */
1598 contract StandardToken is ERC20, BasicToken {
1599 
1600   mapping (address => mapping (address => uint256)) internal allowed;
1601 
1602 
1603   /**
1604    * @dev Transfer tokens from one address to another
1605    * @param _from address The address which you want to send tokens from
1606    * @param _to address The address which you want to transfer to
1607    * @param _value uint256 the amount of tokens to be transferred
1608    */
1609   function transferFrom(
1610     address _from,
1611     address _to,
1612     uint256 _value
1613   )
1614     public
1615     returns (bool)
1616   {
1617     require(_to != address(0));
1618     require(_value <= balances[_from]);
1619     require(_value <= allowed[_from][msg.sender]);
1620 
1621     balances[_from] = balances[_from].sub(_value);
1622     balances[_to] = balances[_to].add(_value);
1623     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1624     emit Transfer(_from, _to, _value);
1625     return true;
1626   }
1627 
1628   /**
1629    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1630    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1631    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1632    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1633    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1634    * @param _spender The address which will spend the funds.
1635    * @param _value The amount of tokens to be spent.
1636    */
1637   function approve(address _spender, uint256 _value) public returns (bool) {
1638     allowed[msg.sender][_spender] = _value;
1639     emit Approval(msg.sender, _spender, _value);
1640     return true;
1641   }
1642 
1643   /**
1644    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1645    * @param _owner address The address which owns the funds.
1646    * @param _spender address The address which will spend the funds.
1647    * @return A uint256 specifying the amount of tokens still available for the spender.
1648    */
1649   function allowance(
1650     address _owner,
1651     address _spender
1652    )
1653     public
1654     view
1655     returns (uint256)
1656   {
1657     return allowed[_owner][_spender];
1658   }
1659 
1660   /**
1661    * @dev Increase the amount of tokens that an owner allowed to a spender.
1662    * approve should be called when allowed[_spender] == 0. To increment
1663    * allowed value is better to use this function to avoid 2 calls (and wait until
1664    * the first transaction is mined)
1665    * From MonolithDAO Token.sol
1666    * @param _spender The address which will spend the funds.
1667    * @param _addedValue The amount of tokens to increase the allowance by.
1668    */
1669   function increaseApproval(
1670     address _spender,
1671     uint256 _addedValue
1672   )
1673     public
1674     returns (bool)
1675   {
1676     allowed[msg.sender][_spender] = (
1677       allowed[msg.sender][_spender].add(_addedValue));
1678     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1679     return true;
1680   }
1681 
1682   /**
1683    * @dev Decrease the amount of tokens that an owner allowed to a spender.
1684    * approve should be called when allowed[_spender] == 0. To decrement
1685    * allowed value is better to use this function to avoid 2 calls (and wait until
1686    * the first transaction is mined)
1687    * From MonolithDAO Token.sol
1688    * @param _spender The address which will spend the funds.
1689    * @param _subtractedValue The amount of tokens to decrease the allowance by.
1690    */
1691   function decreaseApproval(
1692     address _spender,
1693     uint256 _subtractedValue
1694   )
1695     public
1696     returns (bool)
1697   {
1698     uint256 oldValue = allowed[msg.sender][_spender];
1699     if (_subtractedValue > oldValue) {
1700       allowed[msg.sender][_spender] = 0;
1701     } else {
1702       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1703     }
1704     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1705     return true;
1706   }
1707 
1708 }
1709 
1710 // File: contracts/PepToken.sol
1711 
1712 // solhint-disable-next-line
1713 pragma solidity ^0.4.24;
1714 
1715 
1716 
1717 contract PepToken is StandardToken {
1718 
1719     string public name = "PEP Token";
1720     string public symbol = "PEP";
1721     uint8 public decimals = 18;
1722     uint256 public constant INITIAL_BALANCE = 45000000 ether;
1723 
1724     constructor() public {
1725         balances[msg.sender] = INITIAL_BALANCE;
1726         totalSupply_ = INITIAL_BALANCE;
1727     }
1728 
1729     /**
1730      * @dev Allow spender to revoke its own allowance
1731      * @param _from Address from which allowance should be revoked
1732      */
1733     function revokeAllowance(address _from) public {
1734         allowed[_from][msg.sender] = 0;
1735     }
1736 
1737 }
1738 
1739 // File: contracts/PepeGrinder.sol
1740 
1741 // solhint-disable-next-line
1742 pragma solidity ^0.4.4;
1743 
1744 
1745 
1746 
1747 
1748 contract PepeGrinder is StandardToken, Ownable {
1749 
1750     address public pepeContract;
1751     address public miner;
1752     uint256[] public pepes;
1753     mapping(address => bool) public dusting;
1754 
1755     string public name = "CryptoPepes DUST";
1756     string public symbol = "DPEP";
1757     uint8 public decimals = 18;
1758 
1759     uint256 public constant DUST_PER_PEPE = 100 ether;
1760 
1761     constructor(address _pepeContract) public {
1762         pepeContract = _pepeContract;
1763     }
1764 
1765     /**
1766      * Set the mining contract. Can only be set once
1767      * @param _miner The address of the miner contract
1768      */
1769     function setMiner(address _miner) public onlyOwner {
1770         require(miner == address(0));// can only be set once
1771         miner = _miner;
1772     }
1773 
1774     /**
1775      * Gets called by miners who wanna dust their mined Pepes
1776      */
1777     function setDusting() public {
1778         dusting[msg.sender] = true;
1779     }
1780 
1781     /**
1782      * Dust a pepe to pepeDust
1783      * @param _pepeId Pepe to dust
1784      * @param _miner address of the miner
1785      */
1786     function dustPepe(uint256 _pepeId, address _miner) public {
1787         require(msg.sender == miner);
1788         balances[_miner] += DUST_PER_PEPE;
1789         pepes.push(_pepeId);
1790         totalSupply_ += DUST_PER_PEPE;
1791         emit Transfer(address(0), _miner, DUST_PER_PEPE);
1792     }
1793 
1794     /**
1795      * Convert dust into a Pepe
1796      */
1797     function claimPepe() public {
1798         require(balances[msg.sender] >= DUST_PER_PEPE);
1799 
1800         balances[msg.sender] -= DUST_PER_PEPE; //change balance and total supply
1801         totalSupply_ -= DUST_PER_PEPE;
1802 
1803         PepeBase(pepeContract).transfer(msg.sender, pepes[pepes.length-1]);//transfer pepe
1804         pepes.length -= 1;
1805         emit Transfer(msg.sender, address(0), DUST_PER_PEPE);
1806     }
1807 
1808 }
1809 
1810 // File: contracts/Math/ExtendedMath.sol
1811 
1812 /**
1813  * @title SafeMath
1814  * @dev Math operations with safety checks that throw on error
1815  */
1816 library ExtendedMath {
1817   //return the smaller of the two inputs (a or b)
1818   function limitLessThan(uint a, uint b) internal pure returns (uint c) {
1819     if(a > b) return b;
1820     return a;
1821   }
1822 }
1823 
1824 // File: contracts/Mining.sol
1825 
1826 // solhint-disable-next-line
1827 pragma solidity ^0.4.4;
1828 
1829 // solhint-disable max-line-length
1830 
1831 
1832 
1833 
1834 
1835 
1836 
1837 // solhint-disable-next-line
1838 contract Mining is Beneficiary {
1839 
1840     using SafeMath for uint;
1841     using ExtendedMath for uint;
1842 
1843     uint public latestDifficultyPeriodStarted = block.number;
1844     uint public epochCount = 0;//number of 'blocks' mined
1845     uint public constant MAX_EPOCH_COUNT = 16000;
1846     uint public baseMiningReward = 2500 ether;
1847     uint public blocksPerReadjustment = 20;
1848     uint public tokensMinted;
1849 
1850     // solhint-disable var-name-mixedcase
1851     uint public _MINIMUM_TARGET = 2**16;
1852     uint public _MAXIMUM_TARGET = 2**250; //Testing setting!
1853     //uint public _MAXIMUM_TARGET = 2**230; //SHOULD MAKE THIS HARDER IN PRODUCTION
1854 
1855     uint public constant STARTING_DIFFICULTY = 0x00000000000b4963208fc24a4a15e9ea7c1556f9583f1941a7515fabbd194584;
1856 
1857     bytes32 public challengeNumber;
1858     uint public difficulty;
1859     uint public MINING_RATE_FACTOR = 31; //mint the token 31 times less often than ether
1860     //difficulty adjustment parameters- be careful modifying these
1861     uint public MAX_ADJUSTMENT_PERCENT = 100;
1862     uint public TARGET_DIVISOR = 2000;
1863     uint public QUOTIENT_LIMIT = TARGET_DIVISOR.div(2);
1864     mapping(bytes32 => bytes32) public solutionForChallenge;
1865 
1866     Statistics public statistics;
1867 
1868     PepeBase public pepeContract;
1869     PepToken public pepToken;
1870     PepeGrinder public pepeGrinder;
1871 
1872     uint256 public miningStart;//timestamp when mining starts
1873 
1874     event Mint(address indexed from, uint rewardAmount, uint epochCount, bytes32 newChallengeNumber);
1875 
1876     // track read only minting statistics
1877     struct Statistics {
1878         address lastRewardTo;
1879         uint lastRewardAmount;
1880         uint lastRewardEthBlockNumber;
1881         uint lastRewardTimestamp;
1882     }
1883 
1884     constructor(address _pepeContract, address _pepToken, address _pepeGrinder, uint256 _miningStart) public {
1885         pepeContract = PepeBase(_pepeContract);
1886         pepToken = PepToken(_pepToken);
1887         pepeGrinder = PepeGrinder(_pepeGrinder);
1888         difficulty = STARTING_DIFFICULTY;
1889         miningStart = _miningStart;
1890     }
1891 
1892     /**
1893      * Mint a new pepe if noce is correct
1894      * @param nonce The nonce to submit
1895      * @param challengeDigest The resulting digest
1896      * @return success Boolean indicating if mint was successful
1897      */
1898     // solhint-disable-next-line
1899     function mint(uint256 nonce, bytes32 challengeDigest) public returns (bool success) {
1900         require(epochCount < MAX_EPOCH_COUNT);//max 16k blocks
1901         // solhint-disable-next-line not-rely-on-time
1902         require(now > miningStart);
1903         // perform the hash function validation
1904         _hash(nonce, challengeDigest);
1905 
1906         // calculate the current reward
1907         uint rewardAmount = _reward(nonce);
1908 
1909         // increment the minted tokens amount
1910         tokensMinted += rewardAmount;
1911 
1912         epochCount += 1;
1913         challengeNumber = blockhash(block.number - 1);
1914 
1915         _adjustDifficulty();
1916 
1917         //populate read only diagnostics data
1918         // solhint-disable-next-line not-rely-on-time
1919         statistics = Statistics(msg.sender, rewardAmount, block.number, now);
1920 
1921         // send Mint event indicating a successful implementation
1922         emit Mint(msg.sender, rewardAmount, epochCount, challengeNumber);
1923 
1924         if (epochCount == MAX_EPOCH_COUNT) { //destroy this smart contract on the latest block
1925             selfdestruct(msg.sender);
1926         }
1927 
1928         return true;
1929     }
1930 
1931     /**
1932      * Get the current challengeNumber
1933      * @return bytes32 challengeNumber
1934      */
1935     function getChallengeNumber() public constant returns (bytes32) {
1936         return challengeNumber;
1937     }
1938 
1939     /**
1940      * Get the current mining difficulty
1941      * @return the current difficulty
1942      */
1943     function getMiningDifficulty() public constant returns (uint) {
1944         return _MAXIMUM_TARGET.div(difficulty);
1945     }
1946 
1947     /**
1948      * Get the mining target
1949      * @return The current mining target
1950      */
1951     function getMiningTarget() public constant returns (uint256) {
1952         return difficulty;
1953     }
1954 
1955     /**
1956      * Get the mining reward
1957      * @return The current mining reward. Always 2500PEP
1958      */
1959     function getMiningReward() public constant returns (uint256) {
1960         return baseMiningReward;
1961     }
1962 
1963     /**
1964      * Helper method to check a nonce
1965      * @param nonce The nonce to check
1966      * @param challengeDigest the digest to check
1967      * @param challengeNumber to check
1968      * @return digesttest The resulting digest
1969      */
1970     // solhint-disable-next-line
1971     function getMintDigest(uint256 nonce, bytes32 challengeDigest, bytes32 challengeNumber) public view returns (bytes32 digesttest) {
1972         bytes32 digest = keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));
1973         return digest;
1974     }
1975 
1976     /**
1977      * Helper method to check if a nonce meets the difficulty
1978      * @param nonce The nonce to check
1979      * @param challengeDigest the digest to check
1980      * @param challengeNumber the challenge number to check
1981      * @param testTarget the difficulty to check
1982      * @return success Boolean indicating success
1983      */
1984     function checkMintSolution(uint256 nonce, bytes32 challengeDigest, bytes32 challengeNumber, uint testTarget) public view returns (bool success) {
1985         bytes32 digest = keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));
1986         if (uint256(digest) > testTarget) revert();
1987         return (digest == challengeDigest);
1988     }
1989 
1990     /**
1991      * Internal function to check a hash
1992      * @param nonce The nonce to check
1993      * @param challengeDigest it should create
1994      * @return digest The digest created
1995      */
1996     function _hash(uint256 nonce, bytes32 challengeDigest) internal returns (bytes32 digest) {
1997         digest = keccak256(abi.encodePacked(challengeNumber, msg.sender, nonce));
1998         //the challenge digest must match the expected
1999         if (digest != challengeDigest) revert();
2000         //the digest must be smaller than the target
2001         if (uint256(digest) > difficulty) revert();
2002         //only allow one reward for each challenge
2003         bytes32 solution = solutionForChallenge[challengeNumber];
2004         solutionForChallenge[challengeNumber] = digest;
2005         if (solution != 0x0) revert();  //prevent the same answer from awarding twice
2006     }
2007 
2008     /**
2009      * Reward a miner Pep tokens
2010      * @param nonce Nonce to use as seed for Pepe dna creation
2011      * @return The amount of PEP tokens rewarded
2012      */
2013     function _reward(uint256 nonce) internal returns (uint) {
2014         uint reward_amount = getMiningReward();
2015         pepToken.transfer(msg.sender, reward_amount);
2016 
2017         if (epochCount % 16 == 0) { //every 16th block reward a pepe
2018             if (pepeGrinder.dusting(msg.sender)) { //if miner is pool mining send it through the grinder
2019                 uint256 newPepe = pepeContract.minePepe(nonce, address(pepeGrinder));
2020                 pepeGrinder.dustPepe(newPepe, msg.sender);
2021             } else {
2022                 pepeContract.minePepe(nonce, msg.sender);
2023             }
2024             //every 16th block send part of the block reward
2025             pepToken.transfer(beneficiary, reward_amount);
2026         }
2027 
2028         return reward_amount;
2029     }
2030 
2031     /**
2032      * Internal method to readjust difficulty
2033      * @return The new difficulty
2034      */
2035     function _adjustDifficulty() internal returns (uint) {
2036         //every so often, readjust difficulty. Dont readjust when deploying
2037         if (epochCount % blocksPerReadjustment != 0) {
2038             return difficulty;
2039         }
2040 
2041         uint ethBlocksSinceLastDifficultyPeriod = block.number - latestDifficultyPeriodStarted;
2042         //assume 360 ethereum blocks per hour
2043         //we want miners to spend 8 minutes to mine each 'block', about 31 ethereum blocks = one CryptoPepes block
2044         uint epochsMined = blocksPerReadjustment;
2045         uint targetEthBlocksPerDiffPeriod = epochsMined * MINING_RATE_FACTOR;
2046         //if there were less eth blocks passed in time than expected
2047         if (ethBlocksSinceLastDifficultyPeriod < targetEthBlocksPerDiffPeriod) {
2048             uint excess_block_pct = (targetEthBlocksPerDiffPeriod.mul(MAX_ADJUSTMENT_PERCENT)).div(ethBlocksSinceLastDifficultyPeriod);
2049             uint excess_block_pct_extra = excess_block_pct.sub(100).limitLessThan(QUOTIENT_LIMIT);
2050             // If there were 5% more blocks mined than expected then this is 5.  If there were 100% more blocks mined than expected then this is 100.
2051             //make it harder
2052             difficulty = difficulty.sub(difficulty.div(TARGET_DIVISOR).mul(excess_block_pct_extra));   //by up to 50 %
2053         } else {
2054             uint shortage_block_pct = (ethBlocksSinceLastDifficultyPeriod.mul(MAX_ADJUSTMENT_PERCENT)).div(targetEthBlocksPerDiffPeriod);
2055             uint shortage_block_pct_extra = shortage_block_pct.sub(100).limitLessThan(QUOTIENT_LIMIT); //always between 0 and 1000
2056             //make it easier
2057             difficulty = difficulty.add(difficulty.div(TARGET_DIVISOR).mul(shortage_block_pct_extra));   //by up to 50 %
2058         }
2059         latestDifficultyPeriodStarted = block.number;
2060         if (difficulty < _MINIMUM_TARGET) { //very dificult
2061             difficulty = _MINIMUM_TARGET;
2062         }
2063         if (difficulty > _MAXIMUM_TARGET) { //very easy
2064             difficulty = _MAXIMUM_TARGET;
2065         }
2066 
2067         return difficulty;
2068     }
2069 
2070 }