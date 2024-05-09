1 pragma solidity ^0.4.24;
2 
3 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * See https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   function totalSupply() public view returns (uint256);
12   function balanceOf(address who) public view returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
18 
19 /**
20  * @title SafeMath
21  * @dev Math operations with safety checks that throw on error
22  */
23 library SafeMath {
24 
25   /**
26   * @dev Multiplies two numbers, throws on overflow.
27   */
28   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
29     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
30     // benefit is lost if 'b' is also tested.
31     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
32     if (a == 0) {
33       return 0;
34     }
35 
36     c = a * b;
37     assert(c / a == b);
38     return c;
39   }
40 
41   /**
42   * @dev Integer division of two numbers, truncating the quotient.
43   */
44   function div(uint256 a, uint256 b) internal pure returns (uint256) {
45     // assert(b > 0); // Solidity automatically throws when dividing by 0
46     // uint256 c = a / b;
47     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
48     return a / b;
49   }
50 
51   /**
52   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
53   */
54   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
55     assert(b <= a);
56     return a - b;
57   }
58 
59   /**
60   * @dev Adds two numbers, throws on overflow.
61   */
62   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
63     c = a + b;
64     assert(c >= a);
65     return c;
66   }
67 }
68 
69 // File: openzeppelin-solidity/contracts/token/ERC20/BasicToken.sol
70 
71 /**
72  * @title Basic token
73  * @dev Basic version of StandardToken, with no allowances.
74  */
75 contract BasicToken is ERC20Basic {
76   using SafeMath for uint256;
77 
78   mapping(address => uint256) balances;
79 
80   uint256 totalSupply_;
81 
82   /**
83   * @dev Total number of tokens in existence
84   */
85   function totalSupply() public view returns (uint256) {
86     return totalSupply_;
87   }
88 
89   /**
90   * @dev Transfer token for a specified address
91   * @param _to The address to transfer to.
92   * @param _value The amount to be transferred.
93   */
94   function transfer(address _to, uint256 _value) public returns (bool) {
95     require(_to != address(0));
96     require(_value <= balances[msg.sender]);
97 
98     balances[msg.sender] = balances[msg.sender].sub(_value);
99     balances[_to] = balances[_to].add(_value);
100     emit Transfer(msg.sender, _to, _value);
101     return true;
102   }
103 
104   /**
105   * @dev Gets the balance of the specified address.
106   * @param _owner The address to query the the balance of.
107   * @return An uint256 representing the amount owned by the passed address.
108   */
109   function balanceOf(address _owner) public view returns (uint256) {
110     return balances[_owner];
111   }
112 
113 }
114 
115 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
116 
117 /**
118  * @title ERC20 interface
119  * @dev see https://github.com/ethereum/EIPs/issues/20
120  */
121 contract ERC20 is ERC20Basic {
122   function allowance(address owner, address spender)
123     public view returns (uint256);
124 
125   function transferFrom(address from, address to, uint256 value)
126     public returns (bool);
127 
128   function approve(address spender, uint256 value) public returns (bool);
129   event Approval(
130     address indexed owner,
131     address indexed spender,
132     uint256 value
133   );
134 }
135 
136 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
137 
138 /**
139  * @title Standard ERC20 token
140  *
141  * @dev Implementation of the basic standard token.
142  * https://github.com/ethereum/EIPs/issues/20
143  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
144  */
145 contract StandardToken is ERC20, BasicToken {
146 
147   mapping (address => mapping (address => uint256)) internal allowed;
148 
149 
150   /**
151    * @dev Transfer tokens from one address to another
152    * @param _from address The address which you want to send tokens from
153    * @param _to address The address which you want to transfer to
154    * @param _value uint256 the amount of tokens to be transferred
155    */
156   function transferFrom(
157     address _from,
158     address _to,
159     uint256 _value
160   )
161     public
162     returns (bool)
163   {
164     require(_to != address(0));
165     require(_value <= balances[_from]);
166     require(_value <= allowed[_from][msg.sender]);
167 
168     balances[_from] = balances[_from].sub(_value);
169     balances[_to] = balances[_to].add(_value);
170     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
171     emit Transfer(_from, _to, _value);
172     return true;
173   }
174 
175   /**
176    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
177    * Beware that changing an allowance with this method brings the risk that someone may use both the old
178    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
179    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
180    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181    * @param _spender The address which will spend the funds.
182    * @param _value The amount of tokens to be spent.
183    */
184   function approve(address _spender, uint256 _value) public returns (bool) {
185     allowed[msg.sender][_spender] = _value;
186     emit Approval(msg.sender, _spender, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Function to check the amount of tokens that an owner allowed to a spender.
192    * @param _owner address The address which owns the funds.
193    * @param _spender address The address which will spend the funds.
194    * @return A uint256 specifying the amount of tokens still available for the spender.
195    */
196   function allowance(
197     address _owner,
198     address _spender
199    )
200     public
201     view
202     returns (uint256)
203   {
204     return allowed[_owner][_spender];
205   }
206 
207   /**
208    * @dev Increase the amount of tokens that an owner allowed to a spender.
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(
217     address _spender,
218     uint256 _addedValue
219   )
220     public
221     returns (bool)
222   {
223     allowed[msg.sender][_spender] = (
224       allowed[msg.sender][_spender].add(_addedValue));
225     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
226     return true;
227   }
228 
229   /**
230    * @dev Decrease the amount of tokens that an owner allowed to a spender.
231    * approve should be called when allowed[_spender] == 0. To decrement
232    * allowed value is better to use this function to avoid 2 calls (and wait until
233    * the first transaction is mined)
234    * From MonolithDAO Token.sol
235    * @param _spender The address which will spend the funds.
236    * @param _subtractedValue The amount of tokens to decrease the allowance by.
237    */
238   function decreaseApproval(
239     address _spender,
240     uint256 _subtractedValue
241   )
242     public
243     returns (bool)
244   {
245     uint256 oldValue = allowed[msg.sender][_spender];
246     if (_subtractedValue > oldValue) {
247       allowed[msg.sender][_spender] = 0;
248     } else {
249       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
250     }
251     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
252     return true;
253   }
254 
255 }
256 
257 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
258 
259 /**
260  * @title Ownable
261  * @dev The Ownable contract has an owner address, and provides basic authorization control
262  * functions, this simplifies the implementation of "user permissions".
263  */
264 contract Ownable {
265   address public owner;
266 
267 
268   event OwnershipRenounced(address indexed previousOwner);
269   event OwnershipTransferred(
270     address indexed previousOwner,
271     address indexed newOwner
272   );
273 
274 
275   /**
276    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
277    * account.
278    */
279   constructor() public {
280     owner = msg.sender;
281   }
282 
283   /**
284    * @dev Throws if called by any account other than the owner.
285    */
286   modifier onlyOwner() {
287     require(msg.sender == owner);
288     _;
289   }
290 
291   /**
292    * @dev Allows the current owner to relinquish control of the contract.
293    * @notice Renouncing to ownership will leave the contract without an owner.
294    * It will not be possible to call the functions with the `onlyOwner`
295    * modifier anymore.
296    */
297   function renounceOwnership() public onlyOwner {
298     emit OwnershipRenounced(owner);
299     owner = address(0);
300   }
301 
302   /**
303    * @dev Allows the current owner to transfer control of the contract to a newOwner.
304    * @param _newOwner The address to transfer ownership to.
305    */
306   function transferOwnership(address _newOwner) public onlyOwner {
307     _transferOwnership(_newOwner);
308   }
309 
310   /**
311    * @dev Transfers control of the contract to a newOwner.
312    * @param _newOwner The address to transfer ownership to.
313    */
314   function _transferOwnership(address _newOwner) internal {
315     require(_newOwner != address(0));
316     emit OwnershipTransferred(owner, _newOwner);
317     owner = _newOwner;
318   }
319 }
320 
321 // File: contracts/Genetic.sol
322 
323 // solhint-disable-next-line
324 pragma solidity ^0.4.23;
325 
326 
327 contract Genetic {
328 
329     // TODO mutations
330     // maximum number of random mutations per chromatid
331     uint8 public constant R = 5;
332 
333     // solhint-disable-next-line function-max-lines
334     function breed(uint256[2] mother, uint256[2] father, uint256 seed) internal view returns (uint256[2] memOffset) {
335         // Meiosis I: recombining alleles (Chromosomal crossovers)
336 
337         // Note about optimization I: no cell duplication,
338         //  producing 2 seeds/eggs per cell is enough, instead of 4 (like humans do)
339 
340         // Note about optimization II: crossovers happen,
341         //  but only 1 side of the result is computed,
342         //  as the other side will not affect anything.
343 
344         // solhint-disable-next-line no-inline-assembly
345         assembly {
346             // allocate output
347             // 1) get the pointer to our memory
348             memOffset := mload(0x40)
349             // 2) Change the free-memory pointer to keep our memory
350             //     (we will only use 64 bytes: 2 values of 256 bits)
351             mstore(0x40, add(memOffset, 64))
352 
353 
354             // Put seed in scratchpad 0
355             mstore(0x0, seed)
356             // Also use the timestamp, best we could do to increase randomness
357             //  without increasing costs dramatically. (Trade-off)
358             mstore(0x20, timestamp)
359 
360             // Hash it for a universally random bitstring.
361             let hash := keccak256(0, 64)
362 
363             // Byzantium VM does not support shift opcodes, will be introduced in Constantinople.
364             // Soldity itself, in non-assembly, also just uses other opcodes to simulate it.
365             // Optmizer should take care of inlining, just declare shiftR ourselves here.
366             // Where possible, better optimization is applied to make it cheaper.
367             function shiftR(value, offset) -> result {
368                 result := div(value, exp(2, offset))
369             }
370 
371             // solhint-disable max-line-length
372             // m_context << Instruction::SWAP1 << u256(2) << Instruction::EXP << Instruction::SWAP1 << (c_leftSigned ? Instruction::SDIV : Instruction::DIV);
373 
374             // optimization: although one side consists of multiple chromatids,
375             //  we handle them just as one long chromatid:
376             //  only difference is that a crossover in chromatid i affects chromatid i+1.
377             //  No big deal, order and location is random anyway
378             function processSide(fatherSrc, motherSrc, rngSrc) -> result {
379 
380                 {
381                     // initial rngSrc bit length: 254 bits
382 
383                     // Run the crossovers
384                     // =====================================================
385 
386                     // Pick some crossovers
387                     // Each crossover is spaced ~64 bits on average.
388                     // To achieve this, we get a random 7 bit number, [0, 128), for each crossover.
389 
390                     // 256 / 64 = 4, we need 4 crossovers,
391                     //  and will have 256 / 127 = 2 at least (rounded down).
392 
393                     // Get one bit determining if we should pick DNA from the father,
394                     //  or from the mother.
395                     // This changes every crossover. (by swapping father and mother)
396                     {
397                         if eq(and(rngSrc, 0x1), 0) {
398                             // Swap mother and father,
399                             // create a temporary variable (code golf XOR swap costs more in gas)
400                             let temp := fatherSrc
401                             fatherSrc := motherSrc
402                             motherSrc := temp
403                         }
404 
405                         // remove the bit from rng source, 253 rng bits left
406                         rngSrc := shiftR(rngSrc, 1)
407                     }
408 
409                     // Don't push/pop this all the time, we have just enough space on stack.
410                     let mask := 0
411 
412                     // Cap at 4 crossovers, no more than that.
413                     let cap := 0
414                     let crossoverLen := and(rngSrc, 0x7f) // bin: 1111111 (7 bits ON)
415                     // remove bits from hash, e.g. 254 - 7 = 247 left.
416                     rngSrc := shiftR(rngSrc, 7)
417                     let crossoverPos := crossoverLen
418 
419                     // optimization: instead of shifting with an opcode we don't have until Constantinople,
420                     //  keep track of the a shifted number, updated using multiplications.
421                     let crossoverPosLeading1 := 1
422 
423                     // solhint-disable-next-line no-empty-blocks
424                     for { } and(lt(crossoverPos, 256), lt(cap, 4)) {
425 
426                         crossoverLen := and(rngSrc, 0x7f) // bin: 1111111 (7 bits ON)
427                         // remove bits from hash, e.g. 254 - 7 = 247 left.
428                         rngSrc := shiftR(rngSrc, 7)
429 
430                         crossoverPos := add(crossoverPos, crossoverLen)
431 
432                         cap := add(cap, 1)
433                     } {
434 
435                         // Note: we go from right to left in the bit-string.
436 
437                         // Create a mask for this crossover.
438                         // Example:
439                         // 00000000000001111111111111111110000000000000000000000000000000000000000000000000000000000.....
440                         // |Prev. data ||Crossover here  ||remaining data .......
441                         //
442                         // The crossover part is copied from the mother/father to the child.
443 
444                         // Create the bit-mask
445                         // Create a bitstring that ignores the previous data:
446                         // 00000000000001111111111111111111111111111111111111111111111111111111111111111111111111111.....
447                         // First create a leading 1, just before the crossover, like:
448                         // 00000000000010000000000000000000000000000000000000000000000000000000000.....
449                         // Then substract 1, to get a long string of 1s
450                         // 00000000000001111111111111111111111111111111111111111111111111111111111111111111111111111.....
451                         // Now do the same for the remain part, and xor it.
452                         // leading 1
453                         // 00000000000000000000000000000010000000000000000000000000000000000000000000000000000000000.....
454                         // sub 1
455                         // 00000000000000000000000000000001111111111111111111111111111111111111111111111111111111111.....
456                         // xor with other
457                         // 00000000000001111111111111111111111111111111111111111111111111111111111111111111111111111.....
458                         // 00000000000000000000000000000001111111111111111111111111111111111111111111111111111111111.....
459                         // 00000000000001111111111111111110000000000000000000000000000000000000000000000000000000000.....
460 
461                         // Use the final shifted 1 of the previous crossover as the start marker
462                         mask := sub(crossoverPosLeading1, 1)
463 
464                         // update for this crossover, (and will be used as start for next crossover)
465                         crossoverPosLeading1 := mul(1, exp(2, crossoverPos))
466                         mask := xor(mask,
467                                     sub(crossoverPosLeading1, 1)
468                         )
469 
470                         // Now add the parent data to the child genotype
471                         // E.g.
472                         // Mask:         00000000000001111111111111111110000000000000000000000000000000000000000000000000000000000....
473                         // Parent:       10010111001000110101011111001010001011100000000000010011000001000100000001011101111000111....
474                         // Child (pre):  00000000000000000000000000000001111110100101111111000011001010000000101010100000110110110....
475                         // Child (post): 00000000000000110101011111001011111110100101111111000011001010000000101010100000110110110....
476 
477                         // To do this, we run: child_post = child_pre | (mask & father)
478                         result := or(result, and(mask, fatherSrc))
479 
480                         // Swap father and mother, next crossover will take a string from the other.
481                         let temp := fatherSrc
482                         fatherSrc := motherSrc
483                         motherSrc := temp
484                     }
485 
486                     // We still have a left-over part that was not copied yet
487                     // E.g., we have something like:
488                     // Father: |            xxxxxxxxxxxxxxxxxxx          xxxxxxxxxxxxxxxxxxxxxxxx            ....
489                     // Mother: |############                   xxxxxxxxxx                        xxxxxxxxxxxx....
490                     // Child:  |            xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx....
491                     // The ############ still needs to be applied to the child, also,
492                     //  this can be done cheaper than in the loop above,
493                     //  as we don't have to swap anything for the next crossover or something.
494 
495                     // At this point we have to assume 4 crossovers ran,
496                     //  and that we only have 127 - 1 - (4 * 7) = 98 bits of randomness left.
497                     // We stopped at the bit after the crossoverPos index, see "x":
498                     // 000000000xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx.....
499                     // now create a leading 1 at crossoverPos like:
500                     // 000000001000000000000000000000000000000000000000000000000000000000000000000.....
501                     // Sub 1, get the mask for what we had.
502                     // 000000000111111111111111111111111111111111111111111111111111111111111111111.....
503                     // Invert, and we have the final mask:
504                     // 111111111000000000000000000000000000000000000000000000000000000000000000000.....
505                     mask := not(sub(crossoverPosLeading1, 1))
506                     // Apply it to the result
507                     result := or(result, and(mask, fatherSrc))
508 
509                     // Random mutations
510                     // =====================================================
511 
512                     // random mutations
513                     // Put rng source in scratchpad 0
514                     mstore(0x0, rngSrc)
515                     // And some arbitrary padding in scratchpad 1,
516                     //  used to create different hashes based on input size changes
517                     mstore(0x20, 0x434f4c4c454354205045504553204f4e2043525950544f50455045532e494f21)
518                     // Hash it for a universally random bitstring.
519                     // Then reduce the number of 1s by AND-ing it with other *different* hashes.
520                     // Each bit in mutations has a probability of 0.5^5 = 0.03125 = 3.125% to be a 1
521                     let mutations := and(
522                             and(
523                                 and(keccak256(0, 32), keccak256(1, 33)),
524                                 and(keccak256(2, 34), keccak256(3, 35))
525                             ),
526                             keccak256(0, 36)
527                     )
528 
529                     result := xor(result, mutations)
530 
531                 }
532             }
533 
534 
535             {
536 
537                 // Get 1 bit of pseudo randomness that will
538                 //  determine if side #1 will come from the left, or right side.
539                 // Either 0 or 1, shift it by 5 bits to get either 0x0 or 0x20, cheaper later on.
540                 let relativeFatherSideLoc := mul(and(hash, 0x1), 0x20) // shift by 5 bits = mul by 2^5=32 (0x20)
541                 // Either 0 or 1, shift it by 5 bits to get either 0x0 or 0x20, cheaper later on.
542                 let relativeMotherSideLoc := mul(and(hash, 0x2), 0x10) // already shifted by 1, mul by 2^4=16 (0x10)
543 
544                 // Now remove the used 2 bits from the hash, 254 bits remaining now.
545                 hash := div(hash, 4)
546 
547                 // Process the side, load the relevant parent data that will be used.
548                 mstore(memOffset, processSide(
549                     mload(add(father, relativeFatherSideLoc)),
550                     mload(add(mother, relativeMotherSideLoc)),
551                     hash
552                 ))
553 
554                 // The other side will be the opposite index: 1 -> 0, 0 -> 1
555                 // Apply it to the location,
556                 //  which is either 0x20 (For index 1) or 0x0 for index 0.
557                 relativeFatherSideLoc := xor(relativeFatherSideLoc, 0x20)
558                 relativeMotherSideLoc := xor(relativeMotherSideLoc, 0x20)
559 
560                 mstore(0x0, seed)
561                 // Second argument will be inverse,
562                 //  resulting in a different second hash.
563                 mstore(0x20, not(timestamp))
564 
565                 // Now create another hash, for the other side
566                 hash := keccak256(0, 64)
567 
568                 // Process the other side
569                 mstore(add(memOffset, 0x20), processSide(
570                     mload(add(father, relativeFatherSideLoc)),
571                     mload(add(mother, relativeMotherSideLoc)),
572                     hash
573                 ))
574 
575             }
576 
577         }
578 
579         // Sample input:
580         // ["0xAAABBBBBBBBCCCCCCCCAAAAAAAAABBBBBBBBBBCCCCCCCCCAABBBBBBBCCCCCCCC","0x4444444455555555555555556666666666666644444444455555555555666666"]
581         //
582         // ["0x1111111111112222222223333311111111122222223333333331111112222222","0x7777788888888888999999999999977777777777788888888888999999997777"]
583 
584         // Expected results (or similar, depends on the seed):
585         // 0xAAABBBBBBBBCCCCCCCCAAAAAAAAABBBBBBBBBBCCCCCCCCCAABBBBBBBCCCCCCCC < Father side A
586         // 0x4444444455555555555555556666666666666644444444455555555555666666 < Father side B
587 
588         // 0x1111111111112222222223333311111111122222223333333331111112222222 < Mother side A
589         // 0x7777788888888888999999999999977777777777788888888888999999997777 < Mother side B
590 
591         //   xxxxxxxxxxxxxxxxx           xxxxxxxxx                         xx
592         // 0xAAABBBBBBBBCCCCCD99999999998BBBBBBBBF77778888888888899999999774C < Child side A
593         //   xxx                       xxxxxxxxxxx
594         // 0x4441111111112222222223333366666666666222223333333331111112222222 < Child side B
595 
596         // And then random mutations, for gene pool expansion.
597         // Each bit is flipped with a 3.125% chance
598 
599         // Example:
600         //a2c37edc61dca0ca0b199e098c80fd5a221c2ad03605b4b54332361358745042 < random hash 1
601         //c217d04b19a83fe497c1cf6e1e10030e455a0812a6949282feec27d67fe2baa7 < random hash 2
602         //2636a55f38bed26d804c63a13628e21b2d701c902ca37b2b0ca94fada3821364 < random hash 3
603         //86bb023a85e2da50ac233b946346a53aa070943b0a8e91c56e42ba181729a5f9 < random hash 4
604         //5d71456a1288ab30ddd4c955384d42e66a09d424bd7743791e3eab8e09aa13f1 < random hash 5
605         //0000000800800000000000000000000200000000000000000000020000000000 < resulting mutation
606         //aaabbbbbbbbcccccd99999999998bbbbbbbbf77778888888888899999999774c < original
607         //aaabbbb3bb3cccccd99999999998bbb9bbbbf7777888888888889b999999774c < mutated (= original XOR mutation)
608     }
609 
610     // Generates (psuedo) random Pepe DNA
611     function randomDNA(uint256 seed) internal pure returns (uint256[2] memOffset) {
612 
613         // solhint-disable-next-line no-inline-assembly
614         assembly {
615             // allocate output
616             // 1) get the pointer to our memory
617             memOffset := mload(0x40)
618             // 2) Change the free-memory pointer to keep our memory
619             //     (we will only use 64 bytes: 2 values of 256 bits)
620             mstore(0x40, add(memOffset, 64))
621 
622             // Load the seed into 1st scratchpad memory slot.
623             // adjacent to the additional value (used to create two distinct hashes)
624             mstore(0x0, seed)
625 
626             // In second scratchpad slot:
627             // The additional value can be any word, as long as the caller uses
628             //  it (second hash needs to be different)
629             mstore(0x20, 0x434f4c4c454354205045504553204f4e2043525950544f50455045532e494f21)
630 
631 
632             // // Create first element pointer of array
633             // mstore(memOffset, add(memOffset, 64)) // pointer 1
634             // mstore(add(memOffset, 32), add(memOffset, 96)) // pointer 2
635 
636             // control block to auto-pop the hash.
637             {
638                 // L * N * 2 * 4 = 4 * 2 * 2 * 4 = 64 bytes, 2x 256 bit hash
639 
640                 // Sha3 is cheaper than sha256, make use of it
641                 let hash := keccak256(0, 64)
642 
643                 // Store first array value
644                 mstore(memOffset, hash)
645 
646                 // Now hash again, but only 32 bytes of input,
647                 //  to ignore make the input different than the previous call,
648                 hash := keccak256(0, 32)
649                 mstore(add(memOffset, 32), hash)
650 
651             }
652 
653         }
654     }
655 
656 }
657 
658 // File: contracts/Usernames.sol
659 
660 // solhint-disable-next-line
661 pragma solidity ^0.4.19;
662 
663 
664 contract Usernames {
665 
666     mapping(address => bytes32) public addressToUser;
667     mapping(bytes32 => address) public userToAddress;
668 
669     event UserNamed(address indexed user, bytes32 indexed username);
670 
671     /**
672      * Claim a username. Frees up a previously used one
673      * @param _username to claim
674      */
675     function claimUsername(bytes32 _username) external {
676         require(userToAddress[_username] == address(0));// Username must be free
677 
678         if (addressToUser[msg.sender] != bytes32(0)) { // If user already has username free it up
679             userToAddress[addressToUser[msg.sender]] = address(0);
680         }
681 
682         //all is well assign username
683         addressToUser[msg.sender] = _username;
684         userToAddress[_username] = msg.sender;
685 
686         emit UserNamed(msg.sender, _username);
687 
688     }
689 
690 }
691 
692 // File: contracts/Beneficiary.sol
693 
694 // solhint-disable-next-line
695 pragma solidity ^0.4.24;
696 
697 
698 
699 /** @title Beneficiary */
700 contract Beneficiary is Ownable {
701     address public beneficiary;
702 
703     constructor() public {
704         beneficiary = msg.sender;
705     }
706 
707     /**
708      * @dev Change the beneficiary address
709      * @param _beneficiary Address of the new beneficiary
710      */
711     function setBeneficiary(address _beneficiary) public onlyOwner {
712         beneficiary = _beneficiary;
713     }
714 }
715 
716 // File: contracts/Affiliate.sol
717 
718 // solhint-disable-next-line
719 pragma solidity ^0.4.25;
720 
721 
722 
723 /** @title Affiliate */
724 contract Affiliate is Ownable {
725     mapping(address => bool) public canSetAffiliate;
726     mapping(address => address) public userToAffiliate;
727 
728     /** @dev Allows an address to set the affiliate address for a user
729       * @param _setter The address that should be allowed
730       */
731     function setAffiliateSetter(address _setter) public onlyOwner {
732         canSetAffiliate[_setter] = true;
733     }
734 
735     /**
736      * @dev Set the affiliate of a user
737      * @param _user user to set affiliate for
738      * @param _affiliate address to set
739      */
740     function setAffiliate(address _user, address _affiliate) public {
741         require(canSetAffiliate[msg.sender]);
742         if (userToAffiliate[_user] == address(0)) {
743             userToAffiliate[_user] = _affiliate;
744         }
745     }
746 
747 }
748 
749 // File: contracts/interfaces/ERC721.sol
750 
751 contract ERC721 {
752     function implementsERC721() public pure returns (bool);
753     function totalSupply() public view returns (uint256 total);
754     function balanceOf(address _owner) public view returns (uint256 balance);
755     function ownerOf(uint256 _tokenId) public view returns (address owner);
756     function approve(address _to, uint256 _tokenId) public;
757     function transferFrom(address _from, address _to, uint256 _tokenId) public returns (bool) ;
758     function transfer(address _to, uint256 _tokenId) public returns (bool);
759     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
760     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
761 
762     // Optional
763     // function name() public view returns (string name);
764     // function symbol() public view returns (string symbol);
765     // function tokenOfOwnerByIndex(address _owner, uint256 _index) external view returns (uint256 tokenId);
766     // function tokenMetadata(uint256 _tokenId) public view returns (string infoUrl);
767 }
768 
769 // File: contracts/interfaces/PepeInterface.sol
770 
771 contract PepeInterface is ERC721{
772     function cozyTime(uint256 _mother, uint256 _father, address _pepeReceiver) public returns (bool);
773     function getCozyAgain(uint256 _pepeId) public view returns(uint64);
774 }
775 
776 // File: contracts/AuctionBase.sol
777 
778 // solhint-disable-next-line
779 pragma solidity ^0.4.24;
780 
781 
782 
783 
784 
785 /** @title AuctionBase */
786 contract AuctionBase is Beneficiary {
787     mapping(uint256 => PepeAuction) public auctions;//maps pepes to auctions
788     PepeInterface public pepeContract;
789     Affiliate public affiliateContract;
790     uint256 public fee = 37500; //in 1 10000th of a percent so 3.75% at the start
791     uint256 public constant FEE_DIVIDER = 1000000; //Perhaps needs better name?
792 
793     struct PepeAuction {
794         address seller;
795         uint256 pepeId;
796         uint64 auctionBegin;
797         uint64 auctionEnd;
798         uint256 beginPrice;
799         uint256 endPrice;
800     }
801 
802     event AuctionWon(uint256 indexed pepe, address indexed winner, address indexed seller);
803     event AuctionStarted(uint256 indexed pepe, address indexed seller);
804     event AuctionFinalized(uint256 indexed pepe, address indexed seller);
805 
806     constructor(address _pepeContract, address _affiliateContract) public {
807         pepeContract = PepeInterface(_pepeContract);
808         affiliateContract = Affiliate(_affiliateContract);
809     }
810 
811     /**
812      * @dev Return a pepe from a auction that has passed
813      * @param  _pepeId the id of the pepe to save
814      */
815     function savePepe(uint256 _pepeId) external {
816         // solhint-disable-next-line not-rely-on-time
817         require(auctions[_pepeId].auctionEnd < now);//auction must have ended
818         require(pepeContract.transfer(auctions[_pepeId].seller, _pepeId));//transfer pepe back to seller
819 
820         emit AuctionFinalized(_pepeId, auctions[_pepeId].seller);
821 
822         delete auctions[_pepeId];//delete auction
823     }
824 
825     /**
826      * @dev change the fee on pepe sales. Can only be lowerred
827      * @param _fee The new fee to set. Must be lower than current fee
828      */
829     function changeFee(uint256 _fee) external onlyOwner {
830         require(_fee < fee);//fee can not be raised
831         fee = _fee;
832     }
833 
834     /**
835      * @dev Start a auction
836      * @param  _pepeId Pepe to sell
837      * @param  _beginPrice Price at which the auction starts
838      * @param  _endPrice Ending price of the auction
839      * @param  _duration How long the auction should take
840      */
841     function startAuction(uint256 _pepeId, uint256 _beginPrice, uint256 _endPrice, uint64 _duration) public {
842         require(pepeContract.transferFrom(msg.sender, address(this), _pepeId));
843         // solhint-disable-next-line not-rely-on-time
844         require(now > auctions[_pepeId].auctionEnd);//can only start new auction if no other is active
845 
846         PepeAuction memory auction;
847 
848         auction.seller = msg.sender;
849         auction.pepeId = _pepeId;
850         // solhint-disable-next-line not-rely-on-time
851         auction.auctionBegin = uint64(now);
852         // solhint-disable-next-line not-rely-on-time
853         auction.auctionEnd = uint64(now) + _duration;
854         require(auction.auctionEnd > auction.auctionBegin);
855         auction.beginPrice = _beginPrice;
856         auction.endPrice = _endPrice;
857 
858         auctions[_pepeId] = auction;
859 
860         emit AuctionStarted(_pepeId, msg.sender);
861     }
862 
863     /**
864      * @dev directly start a auction from the PepeBase contract
865      * @param  _pepeId Pepe to put on auction
866      * @param  _beginPrice Price at which the auction starts
867      * @param  _endPrice Ending price of the auction
868      * @param  _duration How long the auction should take
869      * @param  _seller The address selling the pepe
870      */
871     // solhint-disable-next-line max-line-length
872     function startAuctionDirect(uint256 _pepeId, uint256 _beginPrice, uint256 _endPrice, uint64 _duration, address _seller) public {
873         require(msg.sender == address(pepeContract)); //can only be called by pepeContract
874         //solhint-disable-next-line not-rely-on-time
875         require(now > auctions[_pepeId].auctionEnd);//can only start new auction if no other is active
876 
877         PepeAuction memory auction;
878 
879         auction.seller = _seller;
880         auction.pepeId = _pepeId;
881         // solhint-disable-next-line not-rely-on-time
882         auction.auctionBegin = uint64(now);
883         // solhint-disable-next-line not-rely-on-time
884         auction.auctionEnd = uint64(now) + _duration;
885         require(auction.auctionEnd > auction.auctionBegin);
886         auction.beginPrice = _beginPrice;
887         auction.endPrice = _endPrice;
888 
889         auctions[_pepeId] = auction;
890 
891         emit AuctionStarted(_pepeId, _seller);
892     }
893 
894   /**
895    * @dev Calculate the current price of a auction
896    * @param  _pepeId the pepeID to calculate the current price for
897    * @return currentBid the current price for the auction
898    */
899     function calculateBid(uint256 _pepeId) public view returns(uint256 currentBid) {
900         PepeAuction storage auction = auctions[_pepeId];
901         // solhint-disable-next-line not-rely-on-time
902         uint256 timePassed = now - auctions[_pepeId].auctionBegin;
903 
904         // If auction ended return auction end price.
905         // solhint-disable-next-line not-rely-on-time
906         if (now >= auction.auctionEnd) {
907             return auction.endPrice;
908         } else {
909             // Can be negative
910             int256 priceDifference = int256(auction.endPrice) - int256(auction.beginPrice);
911             // Always positive
912             int256 duration = int256(auction.auctionEnd) - int256(auction.auctionBegin);
913 
914             // As already proven in practice by CryptoKitties:
915             //  timePassed -> 64 bits at most
916             //  priceDifference -> 128 bits at most
917             //  timePassed * priceDifference -> 64 + 128 bits at most
918             int256 priceChange = priceDifference * int256(timePassed) / duration;
919 
920             // Will be positive, both operands are less than 256 bits
921             int256 price = int256(auction.beginPrice) + priceChange;
922 
923             return uint256(price);
924         }
925     }
926 
927   /**
928    * @dev collect the fees from the auction
929    */
930     function getFees() public {
931         beneficiary.transfer(address(this).balance);
932     }
933 
934 
935 }
936 
937 // File: contracts/CozyTimeAuction.sol
938 
939 // solhint-disable-next-line
940 pragma solidity ^0.4.24;
941 
942 
943 
944 /** @title CozyTimeAuction */
945 contract CozyTimeAuction is AuctionBase {
946     // solhint-disable-next-line
947     constructor (address _pepeContract, address _affiliateContract) AuctionBase(_pepeContract, _affiliateContract) public {
948 
949     }
950 
951     /**
952      * @dev Start an auction
953      * @param  _pepeId The id of the pepe to start the auction for
954      * @param  _beginPrice Start price of the auction
955      * @param  _endPrice End price of the auction
956      * @param  _duration How long the auction should take
957      */
958     function startAuction(uint256 _pepeId, uint256 _beginPrice, uint256 _endPrice, uint64 _duration) public {
959         // solhint-disable-next-line not-rely-on-time
960         require(pepeContract.getCozyAgain(_pepeId) <= now);//need to have this extra check
961         super.startAuction(_pepeId, _beginPrice, _endPrice, _duration);
962     }
963 
964     /**
965      * @dev Start a auction direclty from the PepeBase smartcontract
966      * @param  _pepeId The id of the pepe to start the auction for
967      * @param  _beginPrice Start price of the auction
968      * @param  _endPrice End price of the auction
969      * @param  _duration How long the auction should take
970      * @param  _seller The address of the seller
971      */
972     // solhint-disable-next-line max-line-length
973     function startAuctionDirect(uint256 _pepeId, uint256 _beginPrice, uint256 _endPrice, uint64 _duration, address _seller) public {
974         // solhint-disable-next-line not-rely-on-time
975         require(pepeContract.getCozyAgain(_pepeId) <= now);//need to have this extra check
976         super.startAuctionDirect(_pepeId, _beginPrice, _endPrice, _duration, _seller);
977     }
978 
979     /**
980      * @dev Buy cozy right from the auction
981      * @param  _pepeId Pepe to cozy with
982      * @param  _cozyCandidate the pepe to cozy with
983      * @param  _candidateAsFather Is the _cozyCandidate father?
984      * @param  _pepeReceiver address receiving the pepe after cozy time
985      */
986     // solhint-disable-next-line max-line-length
987     function buyCozy(uint256 _pepeId, uint256 _cozyCandidate, bool _candidateAsFather, address _pepeReceiver) public payable {
988         require(address(pepeContract) == msg.sender); //caller needs to be the PepeBase contract
989 
990         PepeAuction storage auction = auctions[_pepeId];
991         // solhint-disable-next-line not-rely-on-time
992         require(now < auction.auctionEnd);// auction must be still going
993 
994         uint256 price = calculateBid(_pepeId);
995         require(msg.value >= price);//must send enough ether
996         uint256 totalFee = price * fee / FEE_DIVIDER; //safe math needed?
997 
998         //Send ETH to seller
999         auction.seller.transfer(price - totalFee);
1000         //send ETH to beneficiary
1001 
1002         address affiliate = affiliateContract.userToAffiliate(_pepeReceiver);
1003 
1004         //solhint-disable-next-line
1005         if (affiliate != address(0) && affiliate.send(totalFee / 2)) { //if user has affiliate
1006             //nothing just to suppress warning
1007         }
1008 
1009         //actual cozytiming
1010         if (_candidateAsFather) {
1011             if (!pepeContract.cozyTime(auction.pepeId, _cozyCandidate, _pepeReceiver)) {
1012                 revert();
1013             }
1014         } else {
1015           // Swap around the two pepes, they have no set gender, the user decides what they are.
1016             if (!pepeContract.cozyTime(_cozyCandidate, auction.pepeId, _pepeReceiver)) {
1017                 revert();
1018             }
1019         }
1020 
1021         //Send pepe to seller of auction
1022         if (!pepeContract.transfer(auction.seller, _pepeId)) {
1023             revert(); //can't complete transfer if this fails
1024         }
1025 
1026         if (msg.value > price) { //return ether send to much
1027             _pepeReceiver.transfer(msg.value - price);
1028         }
1029 
1030         emit AuctionWon(_pepeId, _pepeReceiver, auction.seller);//emit event
1031 
1032         delete auctions[_pepeId];//deletes auction
1033     }
1034 
1035     /**
1036      * @dev Buy cozytime and pass along affiliate
1037      * @param  _pepeId Pepe to cozy with
1038      * @param  _cozyCandidate the pepe to cozy with
1039      * @param  _candidateAsFather Is the _cozyCandidate father?
1040      * @param  _pepeReceiver address receiving the pepe after cozy time
1041      * @param  _affiliate Affiliate address to set
1042      */
1043     //solhint-disable-next-line max-line-length
1044     function buyCozyAffiliated(uint256 _pepeId, uint256 _cozyCandidate, bool _candidateAsFather, address _pepeReceiver, address _affiliate) public payable {
1045         affiliateContract.setAffiliate(_pepeReceiver, _affiliate);
1046         buyCozy(_pepeId, _cozyCandidate, _candidateAsFather, _pepeReceiver);
1047     }
1048 }
1049 
1050 // File: contracts/Haltable.sol
1051 
1052 // solhint-disable-next-line
1053 pragma solidity ^0.4.24;
1054 
1055 
1056 
1057 contract Haltable is Ownable {
1058     uint256 public haltTime; //when the contract was halted
1059     bool public halted;//is the contract halted?
1060     uint256 public haltDuration;
1061     uint256 public maxHaltDuration = 8 weeks;//how long the contract can be halted
1062 
1063     modifier stopWhenHalted {
1064         require(!halted);
1065         _;
1066     }
1067 
1068     modifier onlyWhenHalted {
1069         require(halted);
1070         _;
1071     }
1072 
1073     /**
1074      * @dev Halt the contract for a set time smaller than maxHaltDuration
1075      * @param  _duration Duration how long the contract should be halted. Must be smaller than maxHaltDuration
1076      */
1077     function halt(uint256 _duration) public onlyOwner {
1078         require(haltTime == 0); //cannot halt if it was halted before
1079         require(_duration <= maxHaltDuration);//cannot halt for longer than maxHaltDuration
1080         haltDuration = _duration;
1081         halted = true;
1082         // solhint-disable-next-line not-rely-on-time
1083         haltTime = now;
1084     }
1085 
1086     /**
1087      * @dev Unhalt the contract. Can only be called by the owner or when the haltTime has passed
1088      */
1089     function unhalt() public {
1090         // solhint-disable-next-line
1091         require(now > haltTime + haltDuration || msg.sender == owner);//unhalting is only possible when haltTime has passed or the owner unhalts
1092         halted = false;
1093     }
1094 
1095 }
1096 
1097 // File: contracts/interfaces/ERC721TokenReceiver.sol
1098 
1099 /// @dev Note: the ERC-165 identifier for this interface is 0xf0b9e5ba
1100 interface ERC721TokenReceiver {
1101     /// @notice Handle the receipt of an NFT
1102     /// @dev The ERC721 smart contract calls this function on the recipient
1103     ///  after a `transfer`. This function MAY throw to revert and reject the
1104     ///  transfer. This function MUST use 50,000 gas or less. Return of other
1105     ///  than the magic value MUST result in the transaction being reverted.
1106     ///  Note: the contract address is always the message sender.
1107     /// @param _from The sending address
1108     /// @param _tokenId The NFT identifier which is being transfered
1109     /// @param data Additional data with no specified format
1110     /// @return `bytes4(keccak256("onERC721Received(address,uint256,bytes)"))`
1111     ///  unless throwing
1112 	function onERC721Received(address _from, uint256 _tokenId, bytes data) external returns(bytes4);
1113 }
1114 
1115 // File: contracts/PepeBase.sol
1116 
1117 // solhint-disable-next-line
1118 pragma solidity ^0.4.24;
1119 
1120 // solhint-disable func-order
1121 
1122 
1123 
1124 
1125 
1126 
1127 
1128 
1129 
1130 
1131 contract PepeBase is Genetic, Ownable, Usernames, Haltable {
1132 
1133     uint32[15] public cozyCoolDowns = [ //determined by generation / 2
1134         uint32(1 minutes),
1135         uint32(2 minutes),
1136         uint32(5 minutes),
1137         uint32(15 minutes),
1138         uint32(30 minutes),
1139         uint32(45 minutes),
1140         uint32(1 hours),
1141         uint32(2 hours),
1142         uint32(4 hours),
1143         uint32(8 hours),
1144         uint32(16 hours),
1145         uint32(1 days),
1146         uint32(2 days),
1147         uint32(4 days),
1148         uint32(7 days)
1149     ];
1150 
1151     struct Pepe {
1152         address master; //The master of the pepe
1153         uint256[2] genotype; //all genes stored here
1154         uint64 canCozyAgain; //time when pepe can have nice time again
1155         uint64 generation; //what generation?
1156         uint64 father; //father of this pepe
1157         uint64 mother; //mommy of this pepe
1158         uint8 coolDownIndex;
1159     }
1160 
1161     mapping(uint256 => bytes32) public pepeNames;
1162 
1163     //stores all pepes
1164     Pepe[] public pepes;
1165 
1166     bool public implementsERC721 = true; //signal erc721 support
1167 
1168     // solhint-disable-next-line const-name-snakecase
1169     string public constant name = "Crypto Pepe";
1170     // solhint-disable-next-line const-name-snakecase
1171     string public constant symbol = "CPEP";
1172 
1173     mapping(address => uint256[]) private wallets;
1174     mapping(address => uint256) public balances; //amounts of pepes per address
1175     mapping(uint256 => address) public approved; //pepe index to address approved to transfer
1176     mapping(address => mapping(address => bool)) public approvedForAll;
1177 
1178     uint256 public zeroGenPepes; //how many zero gen pepes are mined
1179     uint256 public constant MAX_PREMINE = 100;//how many pepes can be premined
1180     uint256 public constant MAX_ZERO_GEN_PEPES = 1100; //max number of zero gen pepes
1181     address public miner; //address of the miner contract
1182 
1183     modifier onlyPepeMaster(uint256 _pepeId) {
1184         require(pepes[_pepeId].master == msg.sender);
1185         _;
1186     }
1187 
1188     modifier onlyAllowed(uint256 _tokenId) {
1189         // solhint-disable-next-line max-line-length
1190         require(msg.sender == pepes[_tokenId].master || msg.sender == approved[_tokenId] || approvedForAll[pepes[_tokenId].master][msg.sender]); //check if msg.sender is allowed
1191         _;
1192     }
1193 
1194     event PepeBorn(uint256 indexed mother, uint256 indexed father, uint256 indexed pepeId);
1195     event PepeNamed(uint256 indexed pepeId);
1196 
1197     constructor() public {
1198 
1199         Pepe memory pepe0 = Pepe({
1200             master: 0x0,
1201             genotype: [uint256(0), uint256(0)],
1202             canCozyAgain: 0,
1203             father: 0,
1204             mother: 0,
1205             generation: 0,
1206             coolDownIndex: 0
1207         });
1208 
1209         pepes.push(pepe0);
1210     }
1211 
1212     /**
1213      * @dev Internal function that creates a new pepe
1214      * @param  _genoType DNA of the new pepe
1215      * @param  _mother The ID of the mother
1216      * @param  _father The ID of the father
1217      * @param  _generation The generation of the new Pepe
1218      * @param  _master The owner of this new Pepe
1219      * @return The ID of the newly generated Pepe
1220      */
1221     // solhint-disable-next-line max-line-length
1222     function _newPepe(uint256[2] _genoType, uint64 _mother, uint64 _father, uint64 _generation, address _master) internal returns (uint256 pepeId) {
1223         uint8 tempCoolDownIndex;
1224 
1225         tempCoolDownIndex = uint8(_generation / 2);
1226 
1227         if (_generation > 28) {
1228             tempCoolDownIndex = 14;
1229         }
1230 
1231         Pepe memory _pepe = Pepe({
1232             master: _master, //The master of the pepe
1233             genotype: _genoType, //all genes stored here
1234             canCozyAgain: 0, //time when pepe can have nice time again
1235             father: _father, //father of this pepe
1236             mother: _mother, //mommy of this pepe
1237             generation: _generation, //what generation?
1238             coolDownIndex: tempCoolDownIndex
1239         });
1240 
1241         if (_generation == 0) {
1242             zeroGenPepes += 1; //count zero gen pepes
1243         }
1244 
1245         //push returns the new length, use it to get a new unique id
1246         pepeId = pepes.push(_pepe) - 1;
1247 
1248         //add it to the wallet of the master of the new pepe
1249         addToWallet(_master, pepeId);
1250 
1251         emit PepeBorn(_mother, _father, pepeId);
1252         emit Transfer(address(0), _master, pepeId);
1253 
1254         return pepeId;
1255     }
1256 
1257     /**
1258      * @dev Set the miner contract. Can only be called once
1259      * @param _miner Address of the miner contract
1260      */
1261     function setMiner(address _miner) public onlyOwner {
1262         require(miner == address(0));//can only be set once
1263         miner = _miner;
1264     }
1265 
1266     /**
1267      * @dev Mine a new Pepe. Can only be called by the miner contract.
1268      * @param  _seed Seed to be used for the generation of the DNA
1269      * @param  _receiver Address receiving the newly mined Pepe
1270      * @return The ID of the newly mined Pepe
1271      */
1272     function minePepe(uint256 _seed, address _receiver) public stopWhenHalted returns(uint256) {
1273         require(msg.sender == miner);//only miner contract can call
1274         require(zeroGenPepes < MAX_ZERO_GEN_PEPES);
1275 
1276         return _newPepe(randomDNA(_seed), 0, 0, 0, _receiver);
1277     }
1278 
1279     /**
1280      * @dev Premine pepes. Can only be called by the owner and is limited to MAX_PREMINE
1281      * @param  _amount Amount of Pepes to premine
1282      */
1283     function pepePremine(uint256 _amount) public onlyOwner stopWhenHalted {
1284         for (uint i = 0; i < _amount; i++) {
1285             require(zeroGenPepes <= MAX_PREMINE);//can only generate set amount during premine
1286             //create a new pepe
1287             // 1) who's genes are based on hash of the timestamp and the number of pepes
1288             // 2) who has no mother or father
1289             // 3) who is generation zero
1290             // 4) who's master is the manager
1291 
1292             // solhint-disable-next-line
1293             _newPepe(randomDNA(uint256(keccak256(abi.encodePacked(block.timestamp, pepes.length)))), 0, 0, 0, owner);
1294 
1295         }
1296     }
1297 
1298     /**
1299      * @dev CozyTime two Pepes together
1300      * @param  _mother The mother of the new Pepe
1301      * @param  _father The father of the new Pepe
1302      * @param  _pepeReceiver Address receiving the new Pepe
1303      * @return If it was a success
1304      */
1305     function cozyTime(uint256 _mother, uint256 _father, address _pepeReceiver) external stopWhenHalted returns (bool) {
1306         //cannot cozyTime with itself
1307         require(_mother != _father);
1308         //caller has to either be master or approved for mother
1309         // solhint-disable-next-line max-line-length
1310         require(pepes[_mother].master == msg.sender || approved[_mother] == msg.sender || approvedForAll[pepes[_mother].master][msg.sender]);
1311         //caller has to either be master or approved for father
1312         // solhint-disable-next-line max-line-length
1313         require(pepes[_father].master == msg.sender || approved[_father] == msg.sender || approvedForAll[pepes[_father].master][msg.sender]);
1314         //require both parents to be ready for cozytime
1315         // solhint-disable-next-line not-rely-on-time
1316         require(now > pepes[_mother].canCozyAgain && now > pepes[_father].canCozyAgain);
1317         //require both mother parents not to be father
1318         require(pepes[_mother].mother != _father && pepes[_mother].father != _father);
1319         //require both father parents not to be mother
1320         require(pepes[_father].mother != _mother && pepes[_father].father != _mother);
1321 
1322         Pepe storage father = pepes[_father];
1323         Pepe storage mother = pepes[_mother];
1324 
1325 
1326         approved[_father] = address(0);
1327         approved[_mother] = address(0);
1328 
1329         uint256[2] memory newGenotype = breed(father.genotype, mother.genotype, pepes.length);
1330 
1331         uint64 newGeneration;
1332 
1333         newGeneration = mother.generation + 1;
1334         if (newGeneration < father.generation + 1) { //if father generation is bigger
1335             newGeneration = father.generation + 1;
1336         }
1337 
1338         _handleCoolDown(_mother);
1339         _handleCoolDown(_father);
1340 
1341         //sets pepe birth when mother is done
1342         // solhint-disable-next-line max-line-length
1343         pepes[_newPepe(newGenotype, uint64(_mother), uint64(_father), newGeneration, _pepeReceiver)].canCozyAgain = mother.canCozyAgain; //_pepeReceiver becomes the master of the pepe
1344 
1345         return true;
1346     }
1347 
1348     /**
1349      * @dev Internal function to increase the coolDownIndex
1350      * @param _pepeId The id of the Pepe to update the coolDown of
1351      */
1352     function _handleCoolDown(uint256 _pepeId) internal {
1353         Pepe storage tempPep = pepes[_pepeId];
1354 
1355         // solhint-disable-next-line not-rely-on-time
1356         tempPep.canCozyAgain = uint64(now + cozyCoolDowns[tempPep.coolDownIndex]);
1357 
1358         if (tempPep.coolDownIndex < 14) {// after every cozy time pepe gets slower
1359             tempPep.coolDownIndex++;
1360         }
1361 
1362     }
1363 
1364     /**
1365      * @dev Set the name of a Pepe. Can only be set once
1366      * @param _pepeId ID of the pepe to name
1367      * @param _name The name to assign
1368      */
1369     function setPepeName(uint256 _pepeId, bytes32 _name) public stopWhenHalted onlyPepeMaster(_pepeId) returns(bool) {
1370         require(pepeNames[_pepeId] == 0x0000000000000000000000000000000000000000000000000000000000000000);
1371         pepeNames[_pepeId] = _name;
1372         emit PepeNamed(_pepeId);
1373         return true;
1374     }
1375 
1376     /**
1377      * @dev Transfer a Pepe to the auction contract and auction it
1378      * @param  _pepeId ID of the Pepe to auction
1379      * @param  _auction Auction contract address
1380      * @param  _beginPrice Price the auction starts at
1381      * @param  _endPrice Price the auction ends at
1382      * @param  _duration How long the auction should run
1383      */
1384     // solhint-disable-next-line max-line-length
1385     function transferAndAuction(uint256 _pepeId, address _auction, uint256 _beginPrice, uint256 _endPrice, uint64 _duration) public stopWhenHalted onlyPepeMaster(_pepeId) {
1386         _transfer(msg.sender, _auction, _pepeId);//transfer pepe to auction
1387         AuctionBase auction = AuctionBase(_auction);
1388 
1389         auction.startAuctionDirect(_pepeId, _beginPrice, _endPrice, _duration, msg.sender);
1390     }
1391 
1392     /**
1393      * @dev Approve and buy. Used to buy cozyTime in one call
1394      * @param  _pepeId Pepe to cozy with
1395      * @param  _auction Address of the auction contract
1396      * @param  _cozyCandidate Pepe to approve and cozy with
1397      * @param  _candidateAsFather Use the candidate as father or not
1398      */
1399     // solhint-disable-next-line max-line-length
1400     function approveAndBuy(uint256 _pepeId, address _auction, uint256 _cozyCandidate, bool _candidateAsFather) public stopWhenHalted payable onlyPepeMaster(_cozyCandidate) {
1401         approved[_cozyCandidate] = _auction;
1402         // solhint-disable-next-line max-line-length
1403         CozyTimeAuction(_auction).buyCozy.value(msg.value)(_pepeId, _cozyCandidate, _candidateAsFather, msg.sender); //breeding resets approval
1404     }
1405 
1406     /**
1407      * @dev The same as above only pass an extra parameter
1408      * @param  _pepeId Pepe to cozy with
1409      * @param  _auction Address of the auction contract
1410      * @param  _cozyCandidate Pepe to approve and cozy with
1411      * @param  _candidateAsFather Use the candidate as father or not
1412      * @param  _affiliate Address to set as affiliate
1413      */
1414     // solhint-disable-next-line max-line-length
1415     function approveAndBuyAffiliated(uint256 _pepeId, address _auction, uint256 _cozyCandidate, bool _candidateAsFather, address _affiliate) public stopWhenHalted payable onlyPepeMaster(_cozyCandidate) {
1416         approved[_cozyCandidate] = _auction;
1417         // solhint-disable-next-line max-line-length
1418         CozyTimeAuction(_auction).buyCozyAffiliated.value(msg.value)(_pepeId, _cozyCandidate, _candidateAsFather, msg.sender, _affiliate); //breeding resets approval
1419     }
1420 
1421     /**
1422      * @dev get Pepe information
1423      * @param  _pepeId ID of the Pepe to get information of
1424      * @return master
1425      * @return genotype
1426      * @return canCozyAgain
1427      * @return generation
1428      * @return father
1429      * @return mother
1430      * @return pepeName
1431      * @return coolDownIndex
1432      */
1433     // solhint-disable-next-line max-line-length
1434     function getPepe(uint256 _pepeId) public view returns(address master, uint256[2] genotype, uint64 canCozyAgain, uint64 generation, uint256 father, uint256 mother, bytes32 pepeName, uint8 coolDownIndex) {
1435         Pepe storage tempPep = pepes[_pepeId];
1436 
1437         master = tempPep.master;
1438         genotype = tempPep.genotype;
1439         canCozyAgain = tempPep.canCozyAgain;
1440         generation = tempPep.generation;
1441         father = tempPep.father;
1442         mother = tempPep.mother;
1443         pepeName = pepeNames[_pepeId];
1444         coolDownIndex = tempPep.coolDownIndex;
1445     }
1446 
1447     /**
1448      * @dev Get the time when a pepe can cozy again
1449      * @param  _pepeId ID of the pepe
1450      * @return Time when the pepe can cozy again
1451      */
1452     function getCozyAgain(uint256 _pepeId) public view returns(uint64) {
1453         return pepes[_pepeId].canCozyAgain;
1454     }
1455 
1456     /**
1457      *  ERC721 Compatibility
1458      *
1459      */
1460     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
1461     event Transfer(address indexed _from, address indexed _to, uint256 indexed _tokenId);
1462     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
1463 
1464     /**
1465      * @dev Get the total number of Pepes
1466      * @return total Returns the total number of pepes
1467      */
1468     function totalSupply() public view returns(uint256 total) {
1469         total = pepes.length - balances[address(0)];
1470         return total;
1471     }
1472 
1473     /**
1474      * @dev Get the number of pepes owned by an address
1475      * @param  _owner Address to get the balance from
1476      * @return balance The number of pepes
1477      */
1478     function balanceOf(address _owner) external view returns (uint256 balance) {
1479         balance = balances[_owner];
1480     }
1481 
1482     /**
1483      * @dev Get the owner of a Pepe
1484      * @param  _tokenId the token to get the owner of
1485      * @return _owner the owner of the pepe
1486      */
1487     function ownerOf(uint256 _tokenId) external view returns (address _owner) {
1488         _owner = pepes[_tokenId].master;
1489     }
1490 
1491     /**
1492      * @dev Get the id of an token by its index
1493      * @param _owner The address to look up the tokens of
1494      * @param _index Index to look at
1495      * @return tokenId the ID of the token of the owner at the specified index
1496      */
1497     function tokenOfOwnerByIndex(address _owner, uint256 _index) public constant returns (uint256 tokenId) {
1498         //The index must be smaller than the balance,
1499         // to guarantee that there is no leftover token returned.
1500         require(_index < balances[_owner]);
1501 
1502         return wallets[_owner][_index];
1503     }
1504 
1505     /**
1506      * @dev Private method that ads a token to the wallet
1507      * @param _owner Address of the owner
1508      * @param _tokenId Pepe ID to add
1509      */
1510     function addToWallet(address _owner, uint256 _tokenId) private {
1511         uint256[] storage wallet = wallets[_owner];
1512         uint256 balance = balances[_owner];
1513         if (balance < wallet.length) {
1514             wallet[balance] = _tokenId;
1515         } else {
1516             wallet.push(_tokenId);
1517         }
1518         //increase owner balance
1519         //overflow is not likely to happen(need very large amount of pepes)
1520         balances[_owner] += 1;
1521     }
1522 
1523     /**
1524      * @dev Remove a token from a address's wallet
1525      * @param _owner Address of the owner
1526      * @param _tokenId Token to remove from the wallet
1527      */
1528     function removeFromWallet(address _owner, uint256 _tokenId) private {
1529         uint256[] storage wallet = wallets[_owner];
1530         uint256 i = 0;
1531         // solhint-disable-next-line no-empty-blocks
1532         for (; wallet[i] != _tokenId; i++) {
1533             // not the pepe we are looking for
1534         }
1535         if (wallet[i] == _tokenId) {
1536             //found it!
1537             uint256 last = balances[_owner] - 1;
1538             if (last > 0) {
1539                 //move the last item to this spot, the last will become inaccessible
1540                 wallet[i] = wallet[last];
1541             }
1542             //else: no last item to move, the balance is 0, making everything inaccessible.
1543 
1544             //only decrease balance if _tokenId was in the wallet
1545             balances[_owner] -= 1;
1546         }
1547     }
1548 
1549     /**
1550      * @dev Internal transfer function
1551      * @param _from Address sending the token
1552      * @param _to Address to token is send to
1553      * @param _tokenId ID of the token to send
1554      */
1555     function _transfer(address _from, address _to, uint256 _tokenId) internal {
1556         pepes[_tokenId].master = _to;
1557         approved[_tokenId] = address(0);//reset approved of pepe on every transfer
1558 
1559         //remove the token from the _from wallet
1560         removeFromWallet(_from, _tokenId);
1561 
1562         //add the token to the _to wallet
1563         addToWallet(_to, _tokenId);
1564 
1565         emit Transfer(_from, _to, _tokenId);
1566     }
1567 
1568     /**
1569      * @dev transfer a token. Can only be called by the owner of the token
1570      * @param  _to Addres to send the token to
1571      * @param  _tokenId ID of the token to send
1572      */
1573     // solhint-disable-next-line no-simple-event-func-name
1574     function transfer(address _to, uint256 _tokenId) public stopWhenHalted
1575         onlyPepeMaster(_tokenId) //check if msg.sender is the master of this pepe
1576         returns(bool)
1577     {
1578         _transfer(msg.sender, _to, _tokenId);//after master modifier invoke internal transfer
1579         return true;
1580     }
1581 
1582     /**
1583      * @dev Approve a address to send a token
1584      * @param _to Address to approve
1585      * @param _tokenId Token to set approval for
1586      */
1587     function approve(address _to, uint256 _tokenId) external stopWhenHalted
1588         onlyPepeMaster(_tokenId)
1589     {
1590         approved[_tokenId] = _to;
1591         emit Approval(msg.sender, _to, _tokenId);
1592     }
1593 
1594     /**
1595      * @dev Approve or revoke approval an address for al tokens of a user
1596      * @param _operator Address to (un)approve
1597      * @param _approved Approving or revoking indicator
1598      */
1599     function setApprovalForAll(address _operator, bool _approved) external stopWhenHalted {
1600         if (_approved) {
1601             approvedForAll[msg.sender][_operator] = true;
1602         } else {
1603             approvedForAll[msg.sender][_operator] = false;
1604         }
1605         emit ApprovalForAll(msg.sender, _operator, _approved);
1606     }
1607 
1608     /**
1609      * @dev Get approved address for a token
1610      * @param _tokenId Token ID to get the approved address for
1611      * @return The address that is approved for this token
1612      */
1613     function getApproved(uint256 _tokenId) external view returns (address) {
1614         return approved[_tokenId];
1615     }
1616 
1617     /**
1618      * @dev Get if an operator is approved for all tokens of that owner
1619      * @param _owner Owner to check the approval for
1620      * @param _operator Operator to check approval for
1621      * @return Boolean indicating if the operator is approved for that owner
1622      */
1623     function isApprovedForAll(address _owner, address _operator) external view returns (bool) {
1624         return approvedForAll[_owner][_operator];
1625     }
1626 
1627     /**
1628      * @dev Function to signal support for an interface
1629      * @param interfaceID the ID of the interface to check for
1630      * @return Boolean indicating support
1631      */
1632     function supportsInterface(bytes4 interfaceID) external pure returns (bool) {
1633         if (interfaceID == 0x80ac58cd || interfaceID == 0x01ffc9a7) { //TODO: add more interfaces the contract supports
1634             return true;
1635         }
1636         return false;
1637     }
1638 
1639     /**
1640      * @dev Safe transferFrom function
1641      * @param _from Address currently owning the token
1642      * @param _to Address to send token to
1643      * @param _tokenId ID of the token to send
1644      */
1645     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external stopWhenHalted {
1646         _safeTransferFromInternal(_from, _to, _tokenId, "");
1647     }
1648 
1649     /**
1650      * @dev Safe transferFrom function with aditional data attribute
1651      * @param _from Address currently owning the token
1652      * @param _to Address to send token to
1653      * @param _tokenId ID of the token to send
1654      * @param _data Data to pass along call
1655      */
1656     // solhint-disable-next-line max-line-length
1657     function safeTransferFrom(address _from, address _to, uint256 _tokenId, bytes _data) external stopWhenHalted {
1658         _safeTransferFromInternal(_from, _to, _tokenId, _data);
1659     }
1660 
1661     /**
1662      * @dev Internal Safe transferFrom function with aditional data attribute
1663      * @param _from Address currently owning the token
1664      * @param _to Address to send token to
1665      * @param _tokenId ID of the token to send
1666      * @param _data Data to pass along call
1667      */
1668     // solhint-disable-next-line max-line-length
1669     function _safeTransferFromInternal(address _from, address _to, uint256 _tokenId, bytes _data) internal onlyAllowed(_tokenId) {
1670         require(pepes[_tokenId].master == _from);//check if from is current owner
1671         require(_to != address(0));//throw on zero address
1672 
1673         _transfer(_from, _to, _tokenId); //transfer token
1674 
1675         if (isContract(_to)) { //check if is contract
1676             // solhint-disable-next-line max-line-length
1677             require(ERC721TokenReceiver(_to).onERC721Received(_from, _tokenId, _data) == bytes4(keccak256("onERC721Received(address,uint256,bytes)")));
1678         }
1679     }
1680 
1681     /**
1682      * @dev TransferFrom function
1683      * @param _from Address currently owning the token
1684      * @param _to Address to send token to
1685      * @param _tokenId ID of the token to send
1686      * @return If it was successful
1687      */
1688     // solhint-disable-next-line max-line-length
1689     function transferFrom(address _from, address _to, uint256 _tokenId) public stopWhenHalted onlyAllowed(_tokenId) returns(bool) {
1690         require(pepes[_tokenId].master == _from);//check if _from is really the master.
1691         require(_to != address(0));
1692         _transfer(_from, _to, _tokenId);//handles event, balances and approval reset;
1693         return true;
1694     }
1695 
1696     /**
1697      * @dev Utility method to check if an address is a contract
1698      * @param _address Address to check
1699      * @return Boolean indicating if the address is a contract
1700      */
1701     function isContract(address _address) internal view returns (bool) {
1702         uint size;
1703         // solhint-disable-next-line no-inline-assembly
1704         assembly { size := extcodesize(_address) }
1705         return size > 0;
1706     }
1707 
1708 }
1709 
1710 // File: contracts/PepeGrinder.sol
1711 
1712 // solhint-disable-next-line
1713 pragma solidity ^0.4.4;
1714 
1715 
1716 
1717 
1718 
1719 contract PepeGrinder is StandardToken, Ownable {
1720 
1721     address public pepeContract;
1722     address public miner;
1723     uint256[] public pepes;
1724     mapping(address => bool) public dusting;
1725 
1726     string public name = "CryptoPepes DUST";
1727     string public symbol = "DPEP";
1728     uint8 public decimals = 18;
1729 
1730     uint256 public constant DUST_PER_PEPE = 100 ether;
1731 
1732     constructor(address _pepeContract) public {
1733         pepeContract = _pepeContract;
1734     }
1735 
1736     /**
1737      * Set the mining contract. Can only be set once
1738      * @param _miner The address of the miner contract
1739      */
1740     function setMiner(address _miner) public onlyOwner {
1741         require(miner == address(0));// can only be set once
1742         miner = _miner;
1743     }
1744 
1745     /**
1746      * Gets called by miners who wanna dust their mined Pepes
1747      */
1748     function setDusting() public {
1749         dusting[msg.sender] = true;
1750     }
1751 
1752     /**
1753      * Dust a pepe to pepeDust
1754      * @param _pepeId Pepe to dust
1755      * @param _miner address of the miner
1756      */
1757     function dustPepe(uint256 _pepeId, address _miner) public {
1758         require(msg.sender == miner);
1759         balances[_miner] += DUST_PER_PEPE;
1760         pepes.push(_pepeId);
1761         totalSupply_ += DUST_PER_PEPE;
1762         emit Transfer(address(0), _miner, DUST_PER_PEPE);
1763     }
1764 
1765     /**
1766      * Convert dust into a Pepe
1767      */
1768     function claimPepe() public {
1769         require(balances[msg.sender] >= DUST_PER_PEPE);
1770 
1771         balances[msg.sender] -= DUST_PER_PEPE; //change balance and total supply
1772         totalSupply_ -= DUST_PER_PEPE;
1773 
1774         PepeBase(pepeContract).transfer(msg.sender, pepes[pepes.length-1]);//transfer pepe
1775         pepes.length -= 1;
1776         emit Transfer(msg.sender, address(0), DUST_PER_PEPE);
1777     }
1778 
1779 }