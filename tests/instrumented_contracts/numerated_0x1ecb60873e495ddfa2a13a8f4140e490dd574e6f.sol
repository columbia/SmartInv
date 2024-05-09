1 pragma solidity 0.4.24;
2 
3 // File: contracts/BytesLib.sol
4 
5 library BytesLib {
6     function concat(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bytes) {
7         bytes memory tempBytes;
8 
9         assembly {
10             // Get a location of some free memory and store it in tempBytes as
11             // Solidity does for memory variables.
12             tempBytes := mload(0x40)
13 
14             // Store the length of the first bytes array at the beginning of
15             // the memory for tempBytes.
16             let length := mload(_preBytes)
17             mstore(tempBytes, length)
18 
19             // Maintain a memory counter for the current write location in the
20             // temp bytes array by adding the 32 bytes for the array length to
21             // the starting location.
22             let mc := add(tempBytes, 0x20)
23             // Stop copying when the memory counter reaches the length of the
24             // first bytes array.
25             let end := add(mc, length)
26 
27             for {
28                 // Initialize a copy counter to the start of the _preBytes data,
29                 // 32 bytes into its memory.
30                 let cc := add(_preBytes, 0x20)
31             } lt(mc, end) {
32                 // Increase both counters by 32 bytes each iteration.
33                 mc := add(mc, 0x20)
34                 cc := add(cc, 0x20)
35             } {
36                 // Write the _preBytes data into the tempBytes memory 32 bytes
37                 // at a time.
38                 mstore(mc, mload(cc))
39             }
40 
41             // Add the length of _postBytes to the current length of tempBytes
42             // and store it as the new length in the first 32 bytes of the
43             // tempBytes memory.
44             length := mload(_postBytes)
45             mstore(tempBytes, add(length, mload(tempBytes)))
46 
47             // Move the memory counter back from a multiple of 0x20 to the
48             // actual end of the _preBytes data.
49             mc := end
50             // Stop copying when the memory counter reaches the new combined
51             // length of the arrays.
52             end := add(mc, length)
53 
54             for {
55                 let cc := add(_postBytes, 0x20)
56             } lt(mc, end) {
57                 mc := add(mc, 0x20)
58                 cc := add(cc, 0x20)
59             } {
60                 mstore(mc, mload(cc))
61             }
62 
63             // Update the free-memory pointer by padding our last write location
64             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
65             // next 32 byte block, then round down to the nearest multiple of
66             // 32. If the sum of the length of the two arrays is zero then add 
67             // one before rounding down to leave a blank 32 bytes (the length block with 0).
68             mstore(0x40, and(
69               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
70               not(31) // Round down to the nearest 32 bytes.
71             ))
72         }
73 
74         return tempBytes;
75     }
76 
77     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
78         assembly {
79             // Read the first 32 bytes of _preBytes storage, which is the length
80             // of the array. (We don't need to use the offset into the slot
81             // because arrays use the entire slot.)
82             let fslot := sload(_preBytes_slot)
83             // Arrays of 31 bytes or less have an even value in their slot,
84             // while longer arrays have an odd value. The actual length is
85             // the slot divided by two for odd values, and the lowest order
86             // byte divided by two for even values.
87             // If the slot is even, bitwise and the slot with 255 and divide by
88             // two to get the length. If the slot is odd, bitwise and the slot
89             // with -1 and divide by two.
90             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
91             let mlength := mload(_postBytes)
92             let newlength := add(slength, mlength)
93             // slength can contain both the length and contents of the array
94             // if length < 32 bytes so let's prepare for that
95             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
96             switch add(lt(slength, 32), lt(newlength, 32))
97             case 2 {
98                 // Since the new array still fits in the slot, we just need to
99                 // update the contents of the slot.
100                 // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
101                 sstore(
102                     _preBytes_slot,
103                     // all the modifications to the slot are inside this
104                     // next block
105                     add(
106                         // we can just add to the slot contents because the
107                         // bytes we want to change are the LSBs
108                         fslot,
109                         add(
110                             mul(
111                                 div(
112                                     // load the bytes from memory
113                                     mload(add(_postBytes, 0x20)),
114                                     // zero all bytes to the right
115                                     exp(0x100, sub(32, mlength))
116                                 ),
117                                 // and now shift left the number of bytes to
118                                 // leave space for the length in the slot
119                                 exp(0x100, sub(32, newlength))
120                             ),
121                             // increase length by the double of the memory
122                             // bytes length
123                             mul(mlength, 2)
124                         )
125                     )
126                 )
127             }
128             case 1 {
129                 // The stored value fits in the slot, but the combined value
130                 // will exceed it.
131                 // get the keccak hash to get the contents of the array
132                 mstore(0x0, _preBytes_slot)
133                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
134 
135                 // save new length
136                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
137 
138                 // The contents of the _postBytes array start 32 bytes into
139                 // the structure. Our first read should obtain the `submod`
140                 // bytes that can fit into the unused space in the last word
141                 // of the stored array. To get this, we read 32 bytes starting
142                 // from `submod`, so the data we read overlaps with the array
143                 // contents by `submod` bytes. Masking the lowest-order
144                 // `submod` bytes allows us to add that value directly to the
145                 // stored value.
146 
147                 let submod := sub(32, slength)
148                 let mc := add(_postBytes, submod)
149                 let end := add(_postBytes, mlength)
150                 let mask := sub(exp(0x100, submod), 1)
151 
152                 sstore(
153                     sc,
154                     add(
155                         and(
156                             fslot,
157                             0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
158                         ),
159                         and(mload(mc), mask)
160                     )
161                 )
162 
163                 for {
164                     mc := add(mc, 0x20)
165                     sc := add(sc, 1)
166                 } lt(mc, end) {
167                     sc := add(sc, 1)
168                     mc := add(mc, 0x20)
169                 } {
170                     sstore(sc, mload(mc))
171                 }
172 
173                 mask := exp(0x100, sub(mc, end))
174 
175                 sstore(sc, mul(div(mload(mc), mask), mask))
176             }
177             default {
178                 // get the keccak hash to get the contents of the array
179                 mstore(0x0, _preBytes_slot)
180                 // Start copying to the last used word of the stored array.
181                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
182 
183                 // save new length
184                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
185 
186                 // Copy over the first `submod` bytes of the new data as in
187                 // case 1 above.
188                 let slengthmod := mod(slength, 32)
189                 let mlengthmod := mod(mlength, 32)
190                 let submod := sub(32, slengthmod)
191                 let mc := add(_postBytes, submod)
192                 let end := add(_postBytes, mlength)
193                 let mask := sub(exp(0x100, submod), 1)
194 
195                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
196                 
197                 for { 
198                     sc := add(sc, 1)
199                     mc := add(mc, 0x20)
200                 } lt(mc, end) {
201                     sc := add(sc, 1)
202                     mc := add(mc, 0x20)
203                 } {
204                     sstore(sc, mload(mc))
205                 }
206 
207                 mask := exp(0x100, sub(mc, end))
208 
209                 sstore(sc, mul(div(mload(mc), mask), mask))
210             }
211         }
212     }
213 
214     function slice(bytes _bytes, uint _start, uint _length) internal  pure returns (bytes) {
215         require(_bytes.length >= (_start + _length));
216 
217         bytes memory tempBytes;
218 
219         assembly {
220             switch iszero(_length)
221             case 0 {
222                 // Get a location of some free memory and store it in tempBytes as
223                 // Solidity does for memory variables.
224                 tempBytes := mload(0x40)
225 
226                 // The first word of the slice result is potentially a partial
227                 // word read from the original array. To read it, we calculate
228                 // the length of that partial word and start copying that many
229                 // bytes into the array. The first word we copy will start with
230                 // data we don't care about, but the last `lengthmod` bytes will
231                 // land at the beginning of the contents of the new array. When
232                 // we're done copying, we overwrite the full first word with
233                 // the actual length of the slice.
234                 let lengthmod := and(_length, 31)
235 
236                 // The multiplication in the next line is necessary
237                 // because when slicing multiples of 32 bytes (lengthmod == 0)
238                 // the following copy loop was copying the origin's length
239                 // and then ending prematurely not copying everything it should.
240                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
241                 let end := add(mc, _length)
242 
243                 for {
244                     // The multiplication in the next line has the same exact purpose
245                     // as the one above.
246                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
247                 } lt(mc, end) {
248                     mc := add(mc, 0x20)
249                     cc := add(cc, 0x20)
250                 } {
251                     mstore(mc, mload(cc))
252                 }
253 
254                 mstore(tempBytes, _length)
255 
256                 //update free-memory pointer
257                 //allocating the array padded to 32 bytes like the compiler does now
258                 mstore(0x40, and(add(mc, 31), not(31)))
259             }
260             //if we want a zero-length slice let's just return a zero-length array
261             default {
262                 tempBytes := mload(0x40)
263 
264                 mstore(0x40, add(tempBytes, 0x20))
265             }
266         }
267 
268         return tempBytes;
269     }
270 
271     function toAddress(bytes _bytes, uint _start) internal  pure returns (address) {
272         require(_bytes.length >= (_start + 20));
273         address tempAddress;
274 
275         assembly {
276             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
277         }
278 
279         return tempAddress;
280     }
281 
282     function toUint(bytes _bytes, uint _start) internal  pure returns (uint256) {
283         require(_bytes.length >= (_start + 32));
284         uint256 tempUint;
285 
286         assembly {
287             tempUint := mload(add(add(_bytes, 0x20), _start))
288         }
289 
290         return tempUint;
291     }
292 
293     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
294         bool success = true;
295 
296         assembly {
297             let length := mload(_preBytes)
298 
299             // if lengths don't match the arrays are not equal
300             switch eq(length, mload(_postBytes))
301             case 1 {
302                 // cb is a circuit breaker in the for loop since there's
303                 //  no said feature for inline assembly loops
304                 // cb = 1 - don't breaker
305                 // cb = 0 - break
306                 let cb := 1
307 
308                 let mc := add(_preBytes, 0x20)
309                 let end := add(mc, length)
310 
311                 for {
312                     let cc := add(_postBytes, 0x20)
313                 // the next line is the loop condition:
314                 // while(uint(mc < end) + cb == 2)
315                 } eq(add(lt(mc, end), cb), 2) {
316                     mc := add(mc, 0x20)
317                     cc := add(cc, 0x20)
318                 } {
319                     // if any of these checks fails then arrays are not equal
320                     if iszero(eq(mload(mc), mload(cc))) {
321                         // unsuccess:
322                         success := 0
323                         cb := 0
324                     }
325                 }
326             }
327             default {
328                 // unsuccess:
329                 success := 0
330             }
331         }
332 
333         return success;
334     }
335 
336     function equalStorage(bytes storage _preBytes, bytes memory _postBytes) internal view returns (bool) {
337         bool success = true;
338 
339         assembly {
340             // we know _preBytes_offset is 0
341             let fslot := sload(_preBytes_slot)
342             // Decode the length of the stored array like in concatStorage().
343             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
344             let mlength := mload(_postBytes)
345 
346             // if lengths don't match the arrays are not equal
347             switch eq(slength, mlength)
348             case 1 {
349                 // slength can contain both the length and contents of the array
350                 // if length < 32 bytes so let's prepare for that
351                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
352                 if iszero(iszero(slength)) {
353                     switch lt(slength, 32)
354                     case 1 {
355                         // blank the last byte which is the length
356                         fslot := mul(div(fslot, 0x100), 0x100)
357 
358                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
359                             // unsuccess:
360                             success := 0
361                         }
362                     }
363                     default {
364                         // cb is a circuit breaker in the for loop since there's
365                         //  no said feature for inline assembly loops
366                         // cb = 1 - don't breaker
367                         // cb = 0 - break
368                         let cb := 1
369 
370                         // get the keccak hash to get the contents of the array
371                         mstore(0x0, _preBytes_slot)
372                         let sc := keccak256(0x0, 0x20)
373 
374                         let mc := add(_postBytes, 0x20)
375                         let end := add(mc, mlength)
376 
377                         // the next line is the loop condition:
378                         // while(uint(mc < end) + cb == 2)
379                         for {} eq(add(lt(mc, end), cb), 2) {
380                             sc := add(sc, 1)
381                             mc := add(mc, 0x20)
382                         } {
383                             if iszero(eq(sload(sc), mload(mc))) {
384                                 // unsuccess:
385                                 success := 0
386                                 cb := 0
387                             }
388                         }
389                     }
390                 }
391             }
392             default {
393                 // unsuccess:
394                 success := 0
395             }
396         }
397 
398         return success;
399     }
400 }
401 
402 // File: contracts/Token.sol
403 
404 // Abstract contract for the full ERC 20 Token standard
405 // https://github.com/ethereum/EIPs/issues/20
406 pragma solidity 0.4.24;
407 
408 contract Token {
409     /* This is a slight change to the ERC20 base standard.
410     function totalSupply() constant returns (uint256 supply);
411     is replaced with:
412     uint256 public totalSupply;
413     This automatically creates a getter function for the totalSupply.
414     This is moved to the base contract since public getter functions are not
415     currently recognised as an implementation of the matching abstract
416     function by the compiler.
417     */
418     /// total amount of tokens
419     uint256 public totalSupply;
420 
421     /// @param _owner The address from which the balance will be retrieved
422     /// @return The balance
423     function balanceOf(address _owner) constant public returns (uint256 balance);
424 
425     /// @notice send `_value` token to `_to` from `msg.sender`
426     /// @param _to The address of the recipient
427     /// @param _value The amount of token to be transferred
428     /// @return Whether the transfer was successful or not
429     function transfer(address _to, uint256 _value) public returns (bool success);
430 
431     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
432     /// @param _from The address of the sender
433     /// @param _to The address of the recipient
434     /// @param _value The amount of token to be transferred
435     /// @return Whether the transfer was successful or not
436     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
437 
438     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
439     /// @param _spender The address of the account able to transfer the tokens
440     /// @param _value The amount of tokens to be approved for transfer
441     /// @return Whether the approval was successful or not
442     function approve(address _spender, uint256 _value) public returns (bool success);
443 
444     /// @param _owner The address of the account owning tokens
445     /// @param _spender The address of the account able to transfer the tokens
446     /// @return Amount of remaining tokens allowed to spent
447     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
448 
449     event Transfer(address indexed _from, address indexed _to, uint256 _value);
450     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
451 }
452 
453 // File: contracts/StandardToken.sol
454 
455 /*
456 You should inherit from StandardToken or, for a token like you would want to
457 deploy in something like Mist, see HumanStandardToken.sol.
458 (This implements ONLY the standard functions and NOTHING else.
459 If you deploy this, you won't have anything useful.)
460 
461 Implements ERC 20 Token standard: https://github.com/ethereum/EIPs/issues/20
462 .*/
463 pragma solidity 0.4.24;
464 
465 
466 
467 contract StandardToken is Token {
468 
469     function transfer(address _to, uint256 _value) public returns (bool success) {
470         //Default assumes totalSupply can't be over max (2^256 - 1).
471         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
472         //Replace the if with this one instead.
473         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
474         require(balances[msg.sender] >= _value);
475         balances[msg.sender] -= _value;
476         balances[_to] += _value;
477         emit Transfer(msg.sender, _to, _value);
478         return true;
479     }
480 
481     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
482         //same as above. Replace this line with the following if you want to protect against wrapping uints.
483         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
484         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
485         balances[_to] += _value;
486         balances[_from] -= _value;
487         allowed[_from][msg.sender] -= _value;
488         emit Transfer(_from, _to, _value);
489         return true;
490     }
491 
492     function balanceOf(address _owner) public constant returns (uint256 balance) {
493         return balances[_owner];
494     }
495 
496     function approve(address _spender, uint256 _value) public returns (bool success) {
497         allowed[msg.sender][_spender] = _value;
498         emit Approval(msg.sender, _spender, _value);
499         return true;
500     }
501 
502     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
503       return allowed[_owner][_spender];
504     }
505 
506     mapping (address => uint256) balances;
507     mapping (address => mapping (address => uint256)) allowed;
508 }
509 
510 // File: contracts/HumanStandardToken.sol
511 
512 /*
513 This Token Contract implements the standard token functionality (https://github.com/ethereum/EIPs/issues/20) as well as the following OPTIONAL extras intended for use by humans.
514 
515 In other words. This is intended for deployment in something like a Token Factory or Mist wallet, and then used by humans.
516 Imagine coins, currencies, shares, voting weight, etc.
517 Machine-based, rapid creation of many tokens would not necessarily need these extra features or will be minted in other manners.
518 
519 1) Initial Finite Supply (upon creation one specifies how much is minted).
520 2) In the absence of a token registry: Optional Decimal, Symbol & Name.
521 3) Optional approveAndCall() functionality to notify a contract if an approval() has occurred.
522 
523 .*/
524 
525 
526 
527 pragma solidity 0.4.24;
528 
529 contract HumanStandardToken is StandardToken {
530 
531     /* Public variables of the token */
532 
533     /*
534     NOTE:
535     The following variables are OPTIONAL vanities. One does not have to include them.
536     They allow one to customise the token contract & in no way influences the core functionality.
537     Some wallets/interfaces might not even bother to look at this information.
538     */
539     string public name;                   //fancy name: eg Simon Bucks
540     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
541     string public symbol;                 //An identifier: eg SBX
542     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
543 
544     constructor(
545         uint256 _initialAmount,
546         string _tokenName,
547         uint8 _decimalUnits,
548         string _tokenSymbol
549         ) public {
550         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
551         totalSupply = _initialAmount;                        // Update total supply
552         name = _tokenName;                                   // Set the name for display purposes
553         decimals = _decimalUnits;                            // Amount of decimals for display purposes
554         symbol = _tokenSymbol;                               // Set the symbol for display purposes
555     }
556 
557     /* Approves and then calls the receiving contract */
558     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
559         allowed[msg.sender][_spender] = _value;
560         emit Approval(msg.sender, _spender, _value);
561 
562         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
563         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
564         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
565         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
566         return true;
567     }
568 }
569 
570 // File: contracts/OZ_Ownable.sol
571 
572 /**
573  * @title Ownable
574  * @dev The Ownable contract has an owner address, and provides basic authorization control
575  * functions, this simplifies the implementation of "user permissions".
576  */
577 contract Ownable {
578   address public owner;
579 
580 
581   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
582 
583 
584   /**
585    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
586    * account.
587    */
588   constructor() public {
589     owner = msg.sender;
590   }
591 
592   /**
593    * @dev Throws if called by any account other than the owner.
594    */
595   modifier onlyOwner() {
596     require(msg.sender == owner);
597     _;
598   }
599 
600   /**
601    * @dev Allows the current owner to transfer control of the contract to a newOwner.
602    * @param newOwner The address to transfer ownership to.
603    */
604   function transferOwnership(address newOwner) public onlyOwner {
605     require(newOwner != address(0));
606     emit OwnershipTransferred(owner, newOwner);
607     owner = newOwner;
608   }
609 
610 }
611 
612 // File: contracts/SafeMath.sol
613 
614 /**
615  * @title SafeMath
616  * @dev Math operations with safety checks that throw on error
617  */
618 library SafeMath {
619   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
620     uint256 c = a * b;
621     assert(a == 0 || c / a == b);
622     return c;
623   }
624 
625   function div(uint256 a, uint256 b) internal pure returns (uint256) {
626     // assert(b > 0); // Solidity automatically throws when dividing by 0
627     uint256 c = a / b;
628     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
629     return c;
630   }
631 
632   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
633     assert(b <= a);
634     return a - b;
635   }
636 
637   function add(uint256 a, uint256 b) internal pure returns (uint256) {
638     uint256 c = a + b;
639     assert(c >= a);
640     return c;
641   }
642 }
643 
644 // File: contracts/MintAndBurnToken.sol
645 
646 /**
647  * @title Mintable token
648  * @dev Simple ERC20 Token example, with mintable token creation
649  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
650  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
651  */
652 contract MintAndBurnToken is StandardToken, Ownable {
653   event Mint(address indexed to, uint256 amount);
654   event MintFinished();
655 
656   bool public mintingFinished = false;
657 
658 
659   modifier canMint() {
660     require(!mintingFinished);
661     _;
662   }
663 
664 /* Public variables of the token */
665 
666     /*
667     NOTE:
668     The following variables are OPTIONAL vanities. One does not have to include them.
669     They allow one to customise the token contract & in no way influences the core functionality.
670     Some wallets/interfaces might not even bother to look at this information.
671     */
672     string public name;                   //fancy name: eg Simon Bucks
673     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
674     string public symbol;                 //An identifier: eg SBX
675     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
676 
677     constructor(
678         string _tokenName,
679         uint8 _decimalUnits,
680         string _tokenSymbol
681         ) public {
682         name = _tokenName;                                   // Set the name for display purposes
683         decimals = _decimalUnits;                            // Amount of decimals for display purposes
684         symbol = _tokenSymbol;                               // Set the symbol for display purposes
685     }
686 
687   /**
688    * @dev Function to mint tokens
689    * @param _to The address that will receive the minted tokens.
690    * @param _amount The amount of tokens to mint.
691    * @return A boolean that indicates if the operation was successful.
692    */
693   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
694     totalSupply = SafeMath.add(_amount, totalSupply);
695     balances[_to] = SafeMath.add(_amount,balances[_to]);
696     emit Mint(_to, _amount);
697     emit Transfer(address(0), _to, _amount);
698     return true;
699   }
700 
701   /**
702    * @dev Function to stop minting new tokens.
703    * @return True if the operation was successful.
704    */
705   function finishMinting() onlyOwner canMint public returns (bool) {
706     mintingFinished = true;
707     emit MintFinished();
708     return true;
709   }
710 
711   // -----------------------------------
712   // BURN FUNCTIONS BELOW
713   // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
714   // -----------------------------------
715 
716   event Burn(address indexed burner, uint256 value);
717 
718   /**
719    * @dev Burns a specific amount of tokens.
720    * @param _value The amount of token to be burned.
721    */
722   function burn(uint256 _value) onlyOwner public {
723     _burn(msg.sender, _value);
724   }
725 
726   function _burn(address _who, uint256 _value) internal {
727     require(_value <= balances[_who]);
728     // no need to require value <= totalSupply, since that would imply the
729     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
730 
731     balances[_who] = SafeMath.sub(balances[_who],_value);
732     totalSupply = SafeMath.sub(totalSupply,_value);
733     emit Burn(_who, _value);
734     emit Transfer(_who, address(0), _value);
735   }
736 }
737 
738 // File: contracts/SpankBank.sol
739 
740 contract SpankBank {
741     using BytesLib for bytes;
742     using SafeMath for uint256;
743 
744     event SpankBankCreated(
745         uint256 periodLength,
746         uint256 maxPeriods,
747         address spankAddress,
748         uint256 initialBootySupply,
749         string bootyTokenName,
750         uint8 bootyDecimalUnits,
751         string bootySymbol
752     );
753 
754     event StakeEvent(
755         address staker,
756         uint256 period,
757         uint256 spankPoints,
758         uint256 spankAmount,
759         uint256 stakePeriods,
760         address delegateKey,
761         address bootyBase
762     );
763 
764     event SendFeesEvent (
765         address sender,
766         uint256 bootyAmount
767     );
768 
769     event MintBootyEvent (
770         uint256 targetBootySupply,
771         uint256 totalBootySupply
772     );
773 
774     event CheckInEvent (
775         address staker,
776         uint256 period,
777         uint256 spankPoints,
778         uint256 stakerEndingPeriod
779     );
780 
781     event ClaimBootyEvent (
782         address staker,
783         uint256 period,
784         uint256 bootyOwed
785     );
786 
787     event WithdrawStakeEvent (
788         address staker,
789         uint256 totalSpankToWithdraw
790     );
791 
792     event SplitStakeEvent (
793         address staker,
794         address newAddress,
795         address newDelegateKey,
796         address newBootyBase,
797         uint256 spankAmount
798     );
799 
800     event VoteToCloseEvent (
801         address staker,
802         uint256 period
803     );
804 
805     event UpdateDelegateKeyEvent (
806         address staker,
807         address newDelegateKey
808     );
809 
810     event UpdateBootyBaseEvent (
811         address staker,
812         address newBootyBase
813     );
814 
815     event ReceiveApprovalEvent (
816         address from,
817         address tokenContract
818     );
819 
820     /***********************************
821     VARIABLES SET AT CONTRACT DEPLOYMENT
822     ************************************/
823     // GLOBAL CONSTANT VARIABLES
824     uint256 public periodLength; // time length of each period in seconds
825     uint256 public maxPeriods; // the maximum # of periods a staker can stake for
826     uint256 public totalSpankStaked; // the total SPANK staked across all stakers
827     bool public isClosed; // true if voteToClose has passed, allows early withdrawals
828 
829     // ERC-20 BASED TOKEN WITH SOME ADDED PROPERTIES FOR HUMAN READABILITY
830     // https://github.com/ConsenSys/Tokens/blob/master/contracts/HumanStandardToken.sol
831     HumanStandardToken public spankToken;
832     MintAndBurnToken public bootyToken;
833 
834     // LOOKUP TABLE FOR SPANKPOINTS BY PERIOD
835     // 1 -> 45%
836     // 2 -> 50%
837     // ...
838     // 12 -> 100%
839     mapping(uint256 => uint256) public pointsTable;
840 
841     /*************************************
842     INTERAL ACCOUNTING
843     **************************************/
844     uint256 public currentPeriod = 0;
845 
846     struct Staker {
847         uint256 spankStaked; // the amount of spank staked
848         uint256 startingPeriod; // the period this staker started staking
849         uint256 endingPeriod; // the period after which this stake expires
850         mapping(uint256 => uint256) spankPoints; // the spankPoints per period
851         mapping(uint256 => bool) didClaimBooty; // true if staker claimed BOOTY for that period
852         mapping(uint256 => bool) votedToClose; // true if staker voted to close for that period
853         address delegateKey; // address used to call checkIn and claimBooty
854         address bootyBase; // destination address to receive BOOTY
855     }
856 
857     mapping(address => Staker) public stakers;
858 
859     struct Period {
860         uint256 bootyFees; // the amount of BOOTY collected in fees
861         uint256 totalSpankPoints; // the total spankPoints of all stakers
862         uint256 bootyMinted; // the amount of BOOTY minted
863         bool mintingComplete; // true if BOOTY has already been minted for this period
864         uint256 startTime; // the starting unix timestamp in seconds
865         uint256 endTime; // the ending unix timestamp in seconds
866         uint256 closingVotes; // the total votes to close this period
867     }
868 
869     mapping(uint256 => Period) public periods;
870 
871     mapping(address => address) public stakerByDelegateKey;
872 
873     modifier SpankBankIsOpen() {
874         require(isClosed == false);
875         _;
876     }
877 
878     constructor (
879         uint256 _periodLength,
880         uint256 _maxPeriods,
881         address spankAddress,
882         uint256 initialBootySupply,
883         string bootyTokenName,
884         uint8 bootyDecimalUnits,
885         string bootySymbol
886     )   public {
887         periodLength = _periodLength;
888         maxPeriods = _maxPeriods;
889         spankToken = HumanStandardToken(spankAddress);
890         bootyToken = new MintAndBurnToken(bootyTokenName, bootyDecimalUnits, bootySymbol);
891         bootyToken.mint(this, initialBootySupply);
892 
893         uint256 startTime = now;
894 
895         periods[currentPeriod].startTime = startTime;
896         periods[currentPeriod].endTime = SafeMath.add(startTime, periodLength);
897 
898         bootyToken.transfer(msg.sender, initialBootySupply);
899 
900         // initialize points table
901         pointsTable[0] = 0;
902         pointsTable[1] = 45;
903         pointsTable[2] = 50;
904         pointsTable[3] = 55;
905         pointsTable[4] = 60;
906         pointsTable[5] = 65;
907         pointsTable[6] = 70;
908         pointsTable[7] = 75;
909         pointsTable[8] = 80;
910         pointsTable[9] = 85;
911         pointsTable[10] = 90;
912         pointsTable[11] = 95;
913         pointsTable[12] = 100;
914 
915         emit SpankBankCreated(_periodLength, _maxPeriods, spankAddress, initialBootySupply, bootyTokenName, bootyDecimalUnits, bootySymbol);
916     }
917 
918     // Used to create a new staking position - verifies that the caller is not staking
919     function stake(uint256 spankAmount, uint256 stakePeriods, address delegateKey, address bootyBase) SpankBankIsOpen public {
920         doStake(msg.sender, spankAmount, stakePeriods, delegateKey, bootyBase);
921     }
922 
923     function doStake(address stakerAddress, uint256 spankAmount, uint256 stakePeriods, address delegateKey, address bootyBase) internal {
924         updatePeriod();
925         require(stakePeriods > 0 && stakePeriods <= maxPeriods, "stake not between zero and maxPeriods"); // stake 1-12 (max) periods
926         require(spankAmount > 0, "stake is 0"); // stake must be greater than 0
927 
928         // the staker must not have an active staking position
929         require(stakers[stakerAddress].startingPeriod == 0, "staker already exists");
930 
931         // transfer SPANK to this contract - assumes sender has already "allowed" the spankAmount
932         require(spankToken.transferFrom(stakerAddress, this, spankAmount));
933 
934         stakers[stakerAddress] = Staker(spankAmount, currentPeriod + 1, currentPeriod + stakePeriods, delegateKey, bootyBase);
935 
936         _updateNextPeriodPoints(stakerAddress, stakePeriods);
937 
938         totalSpankStaked = SafeMath.add(totalSpankStaked, spankAmount);
939 
940         require(delegateKey != address(0), "delegateKey does not exist");
941         require(bootyBase != address(0), "bootyBase does not exist");
942         require(stakerByDelegateKey[delegateKey] == address(0), "delegateKey already used");
943         stakerByDelegateKey[delegateKey] = stakerAddress;
944 
945         emit StakeEvent(
946             stakerAddress,
947             currentPeriod + 1,
948             stakers[stakerAddress].spankPoints[currentPeriod + 1],
949             spankAmount,
950             stakePeriods,
951             delegateKey,
952             bootyBase
953         );
954     }
955 
956     // Called during stake and checkIn, assumes those functions prevent duplicate calls
957     // for the same staker.
958     function _updateNextPeriodPoints(address stakerAddress, uint256 stakingPeriods) internal {
959         Staker storage staker = stakers[stakerAddress];
960 
961         uint256 stakerPoints = SafeMath.div(SafeMath.mul(staker.spankStaked, pointsTable[stakingPeriods]), 100);
962 
963         // add staker spankpoints to total spankpoints for the next period
964         uint256 totalPoints = periods[currentPeriod + 1].totalSpankPoints;
965         totalPoints = SafeMath.add(totalPoints, stakerPoints);
966         periods[currentPeriod + 1].totalSpankPoints = totalPoints;
967 
968         staker.spankPoints[currentPeriod + 1] = stakerPoints;
969     }
970 
971     function receiveApproval(address from, uint256 amount, address tokenContract, bytes extraData) SpankBankIsOpen public returns (bool success) {
972         require(msg.sender == address(spankToken), "invalid receiveApproval caller");
973 
974         address delegateKeyFromBytes = extraData.toAddress(12);
975         address bootyBaseFromBytes = extraData.toAddress(44);
976         uint256 periodFromBytes = extraData.toUint(64);
977 
978         emit ReceiveApprovalEvent(from, tokenContract);
979 
980         doStake(from, amount, periodFromBytes, delegateKeyFromBytes, bootyBaseFromBytes);
981         return true;
982     }
983 
984     function sendFees(uint256 bootyAmount) SpankBankIsOpen public {
985         updatePeriod();
986 
987         require(bootyAmount > 0, "fee is zero"); // fees must be greater than 0
988         require(bootyToken.transferFrom(msg.sender, this, bootyAmount));
989 
990         bootyToken.burn(bootyAmount);
991 
992         uint256 currentBootyFees = periods[currentPeriod].bootyFees;
993         currentBootyFees = SafeMath.add(bootyAmount, currentBootyFees);
994         periods[currentPeriod].bootyFees = currentBootyFees;
995 
996         emit SendFeesEvent(msg.sender, bootyAmount);
997     }
998 
999     function mintBooty() SpankBankIsOpen public {
1000         updatePeriod();
1001 
1002         // can't mint BOOTY during period 0 - would result in integer underflow
1003         require(currentPeriod > 0, "current period is zero");
1004 
1005         Period storage period = periods[currentPeriod - 1];
1006         require(!period.mintingComplete, "minting already complete"); // cant mint BOOTY twice
1007 
1008         period.mintingComplete = true;
1009 
1010         uint256 targetBootySupply = SafeMath.mul(period.bootyFees, 20);
1011         uint256 totalBootySupply = bootyToken.totalSupply();
1012 
1013         if (targetBootySupply > totalBootySupply) {
1014             uint256 bootyMinted = targetBootySupply - totalBootySupply;
1015             bootyToken.mint(this, bootyMinted);
1016             period.bootyMinted = bootyMinted;
1017             emit MintBootyEvent(targetBootySupply, totalBootySupply);
1018         }
1019     }
1020 
1021     // This will check the current time and update the current period accordingly
1022     // - called from all write functions to ensure the period is always up to date before any writes
1023     // - can also be called externally, but there isn't a good reason for why you would want to
1024     // - the while loop protects against the edge case where we miss a period
1025 
1026     function updatePeriod() public {
1027         while (now >= periods[currentPeriod].endTime) {
1028             Period memory prevPeriod = periods[currentPeriod];
1029             currentPeriod += 1;
1030             periods[currentPeriod].startTime = prevPeriod.endTime;
1031             periods[currentPeriod].endTime = SafeMath.add(prevPeriod.endTime, periodLength);
1032         }
1033     }
1034 
1035     // In order to receive Booty, each staker will have to check-in every period.
1036     // This check-in will compute the spankPoints locally and globally for each staker.
1037     function checkIn(uint256 updatedEndingPeriod) SpankBankIsOpen public {
1038         updatePeriod();
1039 
1040         address stakerAddress =  stakerByDelegateKey[msg.sender];
1041 
1042         Staker storage staker = stakers[stakerAddress];
1043 
1044         require(staker.spankStaked > 0, "staker stake is zero");
1045         require(currentPeriod < staker.endingPeriod, "staker expired");
1046         require(staker.spankPoints[currentPeriod+1] == 0, "staker has points for next period");
1047 
1048         // If updatedEndingPeriod is 0, don't update the ending period
1049         if (updatedEndingPeriod > 0) {
1050             require(updatedEndingPeriod > staker.endingPeriod, "updatedEndingPeriod less than or equal to staker endingPeriod");
1051             require(updatedEndingPeriod <= currentPeriod + maxPeriods, "updatedEndingPeriod greater than currentPeriod and maxPeriods");
1052             staker.endingPeriod = updatedEndingPeriod;
1053         }
1054 
1055         uint256 stakePeriods = staker.endingPeriod - currentPeriod;
1056 
1057         _updateNextPeriodPoints(stakerAddress, stakePeriods);
1058 
1059         emit CheckInEvent(stakerAddress, currentPeriod + 1, staker.spankPoints[currentPeriod + 1], staker.endingPeriod);
1060     }
1061 
1062     function claimBooty(uint256 claimPeriod) public {
1063         updatePeriod();
1064 
1065         Period memory period = periods[claimPeriod];
1066         require(period.mintingComplete, "booty not minted");
1067 
1068         address stakerAddress = stakerByDelegateKey[msg.sender];
1069 
1070         Staker storage staker = stakers[stakerAddress];
1071 
1072         require(!staker.didClaimBooty[claimPeriod], "staker already claimed"); // can only claim booty once
1073 
1074         uint256 stakerSpankPoints = staker.spankPoints[claimPeriod];
1075         require(stakerSpankPoints > 0, "staker has no points"); // only stakers can claim
1076 
1077         staker.didClaimBooty[claimPeriod] = true;
1078 
1079         uint256 bootyMinted = period.bootyMinted;
1080         uint256 totalSpankPoints = period.totalSpankPoints;
1081 
1082         uint256 bootyOwed = SafeMath.div(SafeMath.mul(stakerSpankPoints, bootyMinted), totalSpankPoints);
1083 
1084         require(bootyToken.transfer(staker.bootyBase, bootyOwed));
1085 
1086         emit ClaimBootyEvent(stakerAddress, claimPeriod, bootyOwed);
1087     }
1088 
1089     function withdrawStake() public {
1090         updatePeriod();
1091 
1092         Staker storage staker = stakers[msg.sender];
1093         require(staker.spankStaked > 0, "staker has no stake");
1094 
1095         require(isClosed || currentPeriod > staker.endingPeriod, "currentPeriod less than endingPeriod or spankbank closed");
1096 
1097         uint256 spankToWithdraw = staker.spankStaked;
1098 
1099         totalSpankStaked = SafeMath.sub(totalSpankStaked, staker.spankStaked);
1100         staker.spankStaked = 0;
1101 
1102         spankToken.transfer(msg.sender, spankToWithdraw);
1103 
1104         emit WithdrawStakeEvent(msg.sender, spankToWithdraw);
1105     }
1106 
1107     function splitStake(address newAddress, address newDelegateKey, address newBootyBase, uint256 spankAmount) public {
1108         updatePeriod();
1109 
1110         require(newAddress != address(0), "newAddress is zero");
1111         require(newDelegateKey != address(0), "delegateKey is zero");
1112         require(newBootyBase != address(0), "bootyBase is zero");
1113         require(stakerByDelegateKey[newDelegateKey] == address(0), "delegateKey in use");
1114         require(stakers[newAddress].startingPeriod == 0, "staker already exists");
1115         require(spankAmount > 0, "spankAmount is zero");
1116 
1117         Staker storage staker = stakers[msg.sender];
1118         require(currentPeriod < staker.endingPeriod, "staker expired");
1119         require(spankAmount <= staker.spankStaked, "spankAmount greater than stake");
1120         require(staker.spankPoints[currentPeriod+1] == 0, "staker has points for next period");
1121 
1122         staker.spankStaked = SafeMath.sub(staker.spankStaked, spankAmount);
1123 
1124         stakers[newAddress] = Staker(spankAmount, staker.startingPeriod, staker.endingPeriod, newDelegateKey, newBootyBase);
1125 
1126         stakerByDelegateKey[newDelegateKey] = newAddress;
1127 
1128         emit SplitStakeEvent(msg.sender, newAddress, newDelegateKey, newBootyBase, spankAmount);
1129     }
1130 
1131     function voteToClose() public {
1132         updatePeriod();
1133 
1134         Staker storage staker = stakers[msg.sender];
1135 
1136         require(staker.spankStaked > 0, "stake is zero");
1137         require(currentPeriod < staker.endingPeriod , "staker expired");
1138         require(staker.votedToClose[currentPeriod] == false, "stake already voted");
1139         require(isClosed == false, "SpankBank already closed");
1140 
1141         uint256 closingVotes = periods[currentPeriod].closingVotes;
1142         closingVotes = SafeMath.add(closingVotes, staker.spankStaked);
1143         periods[currentPeriod].closingVotes = closingVotes;
1144 
1145         staker.votedToClose[currentPeriod] = true;
1146 
1147         uint256 closingTrigger = SafeMath.div(totalSpankStaked, 2);
1148         if (closingVotes > closingTrigger) {
1149             isClosed = true;
1150         }
1151 
1152         emit VoteToCloseEvent(msg.sender, currentPeriod);
1153     }
1154 
1155     function updateDelegateKey(address newDelegateKey) public {
1156         require(newDelegateKey != address(0), "delegateKey is zero");
1157         require(stakerByDelegateKey[newDelegateKey] == address(0), "delegateKey already exists");
1158 
1159         Staker storage staker = stakers[msg.sender];
1160         require(staker.startingPeriod > 0, "staker starting period is zero");
1161 
1162         stakerByDelegateKey[staker.delegateKey] = address(0);
1163         staker.delegateKey = newDelegateKey;
1164         stakerByDelegateKey[newDelegateKey] = msg.sender;
1165 
1166         emit UpdateDelegateKeyEvent(msg.sender, newDelegateKey);
1167     }
1168 
1169     function updateBootyBase(address newBootyBase) public {
1170         Staker storage staker = stakers[msg.sender];
1171         require(staker.startingPeriod > 0, "staker starting period is zero");
1172 
1173         staker.bootyBase = newBootyBase;
1174 
1175         emit UpdateBootyBaseEvent(msg.sender, newBootyBase);
1176     }
1177 
1178     function getSpankPoints(address stakerAddress, uint256 period) public view returns (uint256)  {
1179         return stakers[stakerAddress].spankPoints[period];
1180     }
1181 
1182     function getDidClaimBooty(address stakerAddress, uint256 period) public view returns (bool)  {
1183         return stakers[stakerAddress].didClaimBooty[period];
1184     }
1185 
1186     function getVote(address stakerAddress, uint period) public view returns (bool) {
1187         return stakers[stakerAddress].votedToClose[period];
1188     }
1189 
1190     function getStakerFromDelegateKey(address delegateAddress) public view returns (address) {
1191         return stakerByDelegateKey[delegateAddress];
1192     }
1193 }