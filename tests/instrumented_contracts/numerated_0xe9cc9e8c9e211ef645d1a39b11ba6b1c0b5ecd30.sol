1 pragma solidity 0.4.24;
2 // produced by the Solididy File Flattener (c) David Appleton 2018
3 // contact : dave@akomba.com
4 // released under Apache 2.0 licence
5 /*
6 // produced by the Solididy File Flattener (c) David Appleton 2018
7 // contact : dave@akomba.com
8 // released under Apache 2.0 licence
9 */
10 // produced by the Solididy File Flattener (c) David Appleton 2018
11 // contact : dave@akomba.com
12 // released under Apache 2.0 licence
13 contract Ownable {
14   address public owner;
15 
16 
17   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
18 
19 
20   /**
21    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
22    * account.
23    */
24   constructor() public {
25     owner = msg.sender;
26   }
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36   /**
37    * @dev Allows the current owner to transfer control of the contract to a newOwner.
38    * @param newOwner The address to transfer ownership to.
39    */
40   function transferOwnership(address newOwner) public onlyOwner {
41     require(newOwner != address(0));
42     emit OwnershipTransferred(owner, newOwner);
43     owner = newOwner;
44   }
45 
46 }
47 
48 library SafeMath {
49   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50     uint256 c = a * b;
51     assert(a == 0 || c / a == b);
52     return c;
53   }
54 
55   function div(uint256 a, uint256 b) internal pure returns (uint256) {
56     // assert(b > 0); // Solidity automatically throws when dividing by 0
57     uint256 c = a / b;
58     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59     return c;
60   }
61 
62   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63     assert(b <= a);
64     return a - b;
65   }
66 
67   function add(uint256 a, uint256 b) internal pure returns (uint256) {
68     uint256 c = a + b;
69     assert(c >= a);
70     return c;
71   }
72 }
73 
74 contract Token {
75     /* This is a slight change to the ERC20 base standard.
76     function totalSupply() constant returns (uint256 supply);
77     is replaced with:
78     uint256 public totalSupply;
79     This automatically creates a getter function for the totalSupply.
80     This is moved to the base contract since public getter functions are not
81     currently recognised as an implementation of the matching abstract
82     function by the compiler.
83     */
84     /// total amount of tokens
85     uint256 public totalSupply;
86 
87     /// @param _owner The address from which the balance will be retrieved
88     /// @return The balance
89     function balanceOf(address _owner) constant public returns (uint256 balance);
90 
91     /// @notice send `_value` token to `_to` from `msg.sender`
92     /// @param _to The address of the recipient
93     /// @param _value The amount of token to be transferred
94     /// @return Whether the transfer was successful or not
95     function transfer(address _to, uint256 _value) public returns (bool success);
96 
97     /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
98     /// @param _from The address of the sender
99     /// @param _to The address of the recipient
100     /// @param _value The amount of token to be transferred
101     /// @return Whether the transfer was successful or not
102     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success);
103 
104     /// @notice `msg.sender` approves `_spender` to spend `_value` tokens
105     /// @param _spender The address of the account able to transfer the tokens
106     /// @param _value The amount of tokens to be approved for transfer
107     /// @return Whether the approval was successful or not
108     function approve(address _spender, uint256 _value) public returns (bool success);
109 
110     /// @param _owner The address of the account owning tokens
111     /// @param _spender The address of the account able to transfer the tokens
112     /// @return Amount of remaining tokens allowed to spent
113     function allowance(address _owner, address _spender) public constant returns (uint256 remaining);
114 
115     event Transfer(address indexed _from, address indexed _to, uint256 _value);
116     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
117 }
118 
119 contract StandardToken is Token {
120 
121     function transfer(address _to, uint256 _value) public returns (bool success) {
122         //Default assumes totalSupply can't be over max (2^256 - 1).
123         //If your token leaves out totalSupply and can issue more tokens as time goes on, you need to check if it doesn't wrap.
124         //Replace the if with this one instead.
125         //require(balances[msg.sender] >= _value && balances[_to] + _value > balances[_to]);
126         require(balances[msg.sender] >= _value);
127         balances[msg.sender] -= _value;
128         balances[_to] += _value;
129         emit Transfer(msg.sender, _to, _value);
130         return true;
131     }
132 
133     function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
134         //same as above. Replace this line with the following if you want to protect against wrapping uints.
135         //require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value > balances[_to]);
136         require(balances[_from] >= _value && allowed[_from][msg.sender] >= _value);
137         balances[_to] += _value;
138         balances[_from] -= _value;
139         allowed[_from][msg.sender] -= _value;
140         emit Transfer(_from, _to, _value);
141         return true;
142     }
143 
144     function balanceOf(address _owner) public constant returns (uint256 balance) {
145         return balances[_owner];
146     }
147 
148     function approve(address _spender, uint256 _value) public returns (bool success) {
149         allowed[msg.sender][_spender] = _value;
150         emit Approval(msg.sender, _spender, _value);
151         return true;
152     }
153 
154     function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
155       return allowed[_owner][_spender];
156     }
157 
158     mapping (address => uint256) balances;
159     mapping (address => mapping (address => uint256)) allowed;
160 }
161 
162 contract MintAndBurnToken is StandardToken, Ownable {
163   event Mint(address indexed to, uint256 amount);
164   event MintFinished();
165 
166   bool public mintingFinished = false;
167 
168 
169   modifier canMint() {
170     require(!mintingFinished);
171     _;
172   }
173 
174 /* Public variables of the token */
175 
176     /*
177     NOTE:
178     The following variables are OPTIONAL vanities. One does not have to include them.
179     They allow one to customise the token contract & in no way influences the core functionality.
180     Some wallets/interfaces might not even bother to look at this information.
181     */
182     string public name;                   //fancy name: eg Simon Bucks
183     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
184     string public symbol;                 //An identifier: eg SBX
185     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
186 
187     constructor(
188         string _tokenName,
189         uint8 _decimalUnits,
190         string _tokenSymbol
191         ) public {
192         name = _tokenName;                                   // Set the name for display purposes
193         decimals = _decimalUnits;                            // Amount of decimals for display purposes
194         symbol = _tokenSymbol;                               // Set the symbol for display purposes
195     }
196 
197   /**
198    * @dev Function to mint tokens
199    * @param _to The address that will receive the minted tokens.
200    * @param _amount The amount of tokens to mint.
201    * @return A boolean that indicates if the operation was successful.
202    */
203   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
204     totalSupply = SafeMath.add(_amount, totalSupply);
205     balances[_to] = SafeMath.add(_amount,balances[_to]);
206     emit Mint(_to, _amount);
207     emit Transfer(address(0), _to, _amount);
208     return true;
209   }
210 
211   /**
212    * @dev Function to stop minting new tokens.
213    * @return True if the operation was successful.
214    */
215   function finishMinting() onlyOwner canMint public returns (bool) {
216     mintingFinished = true;
217     emit MintFinished();
218     return true;
219   }
220 
221   // -----------------------------------
222   // BURN FUNCTIONS BELOW
223   // https://github.com/OpenZeppelin/openzeppelin-solidity/blob/master/contracts/token/ERC20/BurnableToken.sol
224   // -----------------------------------
225 
226   event Burn(address indexed burner, uint256 value);
227 
228   /**
229    * @dev Burns a specific amount of tokens.
230    * @param _value The amount of token to be burned.
231    */
232   function burn(uint256 _value) onlyOwner public {
233     _burn(msg.sender, _value);
234   }
235 
236   function _burn(address _who, uint256 _value) internal {
237     require(_value <= balances[_who]);
238     // no need to require value <= totalSupply, since that would imply the
239     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
240 
241     balances[_who] = SafeMath.sub(balances[_who],_value);
242     totalSupply = SafeMath.sub(totalSupply,_value);
243     emit Burn(_who, _value);
244     emit Transfer(_who, address(0), _value);
245   }
246 }
247 
248 contract HumanStandardToken is StandardToken {
249 
250     /* Public variables of the token */
251 
252     /*
253     NOTE:
254     The following variables are OPTIONAL vanities. One does not have to include them.
255     They allow one to customise the token contract & in no way influences the core functionality.
256     Some wallets/interfaces might not even bother to look at this information.
257     */
258     string public name;                   //fancy name: eg Simon Bucks
259     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
260     string public symbol;                 //An identifier: eg SBX
261     string public version = 'H0.1';       //human 0.1 standard. Just an arbitrary versioning scheme.
262 
263     constructor(
264         uint256 _initialAmount,
265         string _tokenName,
266         uint8 _decimalUnits,
267         string _tokenSymbol
268         ) public {
269         balances[msg.sender] = _initialAmount;               // Give the creator all initial tokens
270         totalSupply = _initialAmount;                        // Update total supply
271         name = _tokenName;                                   // Set the name for display purposes
272         decimals = _decimalUnits;                            // Amount of decimals for display purposes
273         symbol = _tokenSymbol;                               // Set the symbol for display purposes
274     }
275 
276     /* Approves and then calls the receiving contract */
277     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
278         allowed[msg.sender][_spender] = _value;
279         emit Approval(msg.sender, _spender, _value);
280 
281         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
282         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
283         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
284         require(_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData));
285         return true;
286     }
287 }
288 
289 library BytesLib {
290     function concat(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bytes) {
291         bytes memory tempBytes;
292 
293         assembly {
294             // Get a location of some free memory and store it in tempBytes as
295             // Solidity does for memory variables.
296             tempBytes := mload(0x40)
297 
298             // Store the length of the first bytes array at the beginning of
299             // the memory for tempBytes.
300             let length := mload(_preBytes)
301             mstore(tempBytes, length)
302 
303             // Maintain a memory counter for the current write location in the
304             // temp bytes array by adding the 32 bytes for the array length to
305             // the starting location.
306             let mc := add(tempBytes, 0x20)
307             // Stop copying when the memory counter reaches the length of the
308             // first bytes array.
309             let end := add(mc, length)
310 
311             for {
312                 // Initialize a copy counter to the start of the _preBytes data,
313                 // 32 bytes into its memory.
314                 let cc := add(_preBytes, 0x20)
315             } lt(mc, end) {
316                 // Increase both counters by 32 bytes each iteration.
317                 mc := add(mc, 0x20)
318                 cc := add(cc, 0x20)
319             } {
320                 // Write the _preBytes data into the tempBytes memory 32 bytes
321                 // at a time.
322                 mstore(mc, mload(cc))
323             }
324 
325             // Add the length of _postBytes to the current length of tempBytes
326             // and store it as the new length in the first 32 bytes of the
327             // tempBytes memory.
328             length := mload(_postBytes)
329             mstore(tempBytes, add(length, mload(tempBytes)))
330 
331             // Move the memory counter back from a multiple of 0x20 to the
332             // actual end of the _preBytes data.
333             mc := end
334             // Stop copying when the memory counter reaches the new combined
335             // length of the arrays.
336             end := add(mc, length)
337 
338             for {
339                 let cc := add(_postBytes, 0x20)
340             } lt(mc, end) {
341                 mc := add(mc, 0x20)
342                 cc := add(cc, 0x20)
343             } {
344                 mstore(mc, mload(cc))
345             }
346 
347             // Update the free-memory pointer by padding our last write location
348             // to 32 bytes: add 31 bytes to the end of tempBytes to move to the
349             // next 32 byte block, then round down to the nearest multiple of
350             // 32. If the sum of the length of the two arrays is zero then add 
351             // one before rounding down to leave a blank 32 bytes (the length block with 0).
352             mstore(0x40, and(
353               add(add(end, iszero(add(length, mload(_preBytes)))), 31),
354               not(31) // Round down to the nearest 32 bytes.
355             ))
356         }
357 
358         return tempBytes;
359     }
360 
361     function concatStorage(bytes storage _preBytes, bytes memory _postBytes) internal {
362         assembly {
363             // Read the first 32 bytes of _preBytes storage, which is the length
364             // of the array. (We don't need to use the offset into the slot
365             // because arrays use the entire slot.)
366             let fslot := sload(_preBytes_slot)
367             // Arrays of 31 bytes or less have an even value in their slot,
368             // while longer arrays have an odd value. The actual length is
369             // the slot divided by two for odd values, and the lowest order
370             // byte divided by two for even values.
371             // If the slot is even, bitwise and the slot with 255 and divide by
372             // two to get the length. If the slot is odd, bitwise and the slot
373             // with -1 and divide by two.
374             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
375             let mlength := mload(_postBytes)
376             let newlength := add(slength, mlength)
377             // slength can contain both the length and contents of the array
378             // if length < 32 bytes so let's prepare for that
379             // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
380             switch add(lt(slength, 32), lt(newlength, 32))
381             case 2 {
382                 // Since the new array still fits in the slot, we just need to
383                 // update the contents of the slot.
384                 // uint256(bytes_storage) = uint256(bytes_storage) + uint256(bytes_memory) + new_length
385                 sstore(
386                     _preBytes_slot,
387                     // all the modifications to the slot are inside this
388                     // next block
389                     add(
390                         // we can just add to the slot contents because the
391                         // bytes we want to change are the LSBs
392                         fslot,
393                         add(
394                             mul(
395                                 div(
396                                     // load the bytes from memory
397                                     mload(add(_postBytes, 0x20)),
398                                     // zero all bytes to the right
399                                     exp(0x100, sub(32, mlength))
400                                 ),
401                                 // and now shift left the number of bytes to
402                                 // leave space for the length in the slot
403                                 exp(0x100, sub(32, newlength))
404                             ),
405                             // increase length by the double of the memory
406                             // bytes length
407                             mul(mlength, 2)
408                         )
409                     )
410                 )
411             }
412             case 1 {
413                 // The stored value fits in the slot, but the combined value
414                 // will exceed it.
415                 // get the keccak hash to get the contents of the array
416                 mstore(0x0, _preBytes_slot)
417                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
418 
419                 // save new length
420                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
421 
422                 // The contents of the _postBytes array start 32 bytes into
423                 // the structure. Our first read should obtain the `submod`
424                 // bytes that can fit into the unused space in the last word
425                 // of the stored array. To get this, we read 32 bytes starting
426                 // from `submod`, so the data we read overlaps with the array
427                 // contents by `submod` bytes. Masking the lowest-order
428                 // `submod` bytes allows us to add that value directly to the
429                 // stored value.
430 
431                 let submod := sub(32, slength)
432                 let mc := add(_postBytes, submod)
433                 let end := add(_postBytes, mlength)
434                 let mask := sub(exp(0x100, submod), 1)
435 
436                 sstore(
437                     sc,
438                     add(
439                         and(
440                             fslot,
441                             0xffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff00
442                         ),
443                         and(mload(mc), mask)
444                     )
445                 )
446 
447                 for {
448                     mc := add(mc, 0x20)
449                     sc := add(sc, 1)
450                 } lt(mc, end) {
451                     sc := add(sc, 1)
452                     mc := add(mc, 0x20)
453                 } {
454                     sstore(sc, mload(mc))
455                 }
456 
457                 mask := exp(0x100, sub(mc, end))
458 
459                 sstore(sc, mul(div(mload(mc), mask), mask))
460             }
461             default {
462                 // get the keccak hash to get the contents of the array
463                 mstore(0x0, _preBytes_slot)
464                 // Start copying to the last used word of the stored array.
465                 let sc := add(keccak256(0x0, 0x20), div(slength, 32))
466 
467                 // save new length
468                 sstore(_preBytes_slot, add(mul(newlength, 2), 1))
469 
470                 // Copy over the first `submod` bytes of the new data as in
471                 // case 1 above.
472                 let slengthmod := mod(slength, 32)
473                 let mlengthmod := mod(mlength, 32)
474                 let submod := sub(32, slengthmod)
475                 let mc := add(_postBytes, submod)
476                 let end := add(_postBytes, mlength)
477                 let mask := sub(exp(0x100, submod), 1)
478 
479                 sstore(sc, add(sload(sc), and(mload(mc), mask)))
480                 
481                 for { 
482                     sc := add(sc, 1)
483                     mc := add(mc, 0x20)
484                 } lt(mc, end) {
485                     sc := add(sc, 1)
486                     mc := add(mc, 0x20)
487                 } {
488                     sstore(sc, mload(mc))
489                 }
490 
491                 mask := exp(0x100, sub(mc, end))
492 
493                 sstore(sc, mul(div(mload(mc), mask), mask))
494             }
495         }
496     }
497 
498     function slice(bytes _bytes, uint _start, uint _length) internal  pure returns (bytes) {
499         require(_bytes.length >= (_start + _length));
500 
501         bytes memory tempBytes;
502 
503         assembly {
504             switch iszero(_length)
505             case 0 {
506                 // Get a location of some free memory and store it in tempBytes as
507                 // Solidity does for memory variables.
508                 tempBytes := mload(0x40)
509 
510                 // The first word of the slice result is potentially a partial
511                 // word read from the original array. To read it, we calculate
512                 // the length of that partial word and start copying that many
513                 // bytes into the array. The first word we copy will start with
514                 // data we don't care about, but the last `lengthmod` bytes will
515                 // land at the beginning of the contents of the new array. When
516                 // we're done copying, we overwrite the full first word with
517                 // the actual length of the slice.
518                 let lengthmod := and(_length, 31)
519 
520                 // The multiplication in the next line is necessary
521                 // because when slicing multiples of 32 bytes (lengthmod == 0)
522                 // the following copy loop was copying the origin's length
523                 // and then ending prematurely not copying everything it should.
524                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
525                 let end := add(mc, _length)
526 
527                 for {
528                     // The multiplication in the next line has the same exact purpose
529                     // as the one above.
530                     let cc := add(add(add(_bytes, lengthmod), mul(0x20, iszero(lengthmod))), _start)
531                 } lt(mc, end) {
532                     mc := add(mc, 0x20)
533                     cc := add(cc, 0x20)
534                 } {
535                     mstore(mc, mload(cc))
536                 }
537 
538                 mstore(tempBytes, _length)
539 
540                 //update free-memory pointer
541                 //allocating the array padded to 32 bytes like the compiler does now
542                 mstore(0x40, and(add(mc, 31), not(31)))
543             }
544             //if we want a zero-length slice let's just return a zero-length array
545             default {
546                 tempBytes := mload(0x40)
547 
548                 mstore(0x40, add(tempBytes, 0x20))
549             }
550         }
551 
552         return tempBytes;
553     }
554 
555     function toAddress(bytes _bytes, uint _start) internal  pure returns (address) {
556         require(_bytes.length >= (_start + 20));
557         address tempAddress;
558 
559         assembly {
560             tempAddress := div(mload(add(add(_bytes, 0x20), _start)), 0x1000000000000000000000000)
561         }
562 
563         return tempAddress;
564     }
565 
566     function toUint(bytes _bytes, uint _start) internal  pure returns (uint256) {
567         require(_bytes.length >= (_start + 32));
568         uint256 tempUint;
569 
570         assembly {
571             tempUint := mload(add(add(_bytes, 0x20), _start))
572         }
573 
574         return tempUint;
575     }
576 
577     function equal(bytes memory _preBytes, bytes memory _postBytes) internal pure returns (bool) {
578         bool success = true;
579 
580         assembly {
581             let length := mload(_preBytes)
582 
583             // if lengths don't match the arrays are not equal
584             switch eq(length, mload(_postBytes))
585             case 1 {
586                 // cb is a circuit breaker in the for loop since there's
587                 //  no said feature for inline assembly loops
588                 // cb = 1 - don't breaker
589                 // cb = 0 - break
590                 let cb := 1
591 
592                 let mc := add(_preBytes, 0x20)
593                 let end := add(mc, length)
594 
595                 for {
596                     let cc := add(_postBytes, 0x20)
597                 // the next line is the loop condition:
598                 // while(uint(mc < end) + cb == 2)
599                 } eq(add(lt(mc, end), cb), 2) {
600                     mc := add(mc, 0x20)
601                     cc := add(cc, 0x20)
602                 } {
603                     // if any of these checks fails then arrays are not equal
604                     if iszero(eq(mload(mc), mload(cc))) {
605                         // unsuccess:
606                         success := 0
607                         cb := 0
608                     }
609                 }
610             }
611             default {
612                 // unsuccess:
613                 success := 0
614             }
615         }
616 
617         return success;
618     }
619 
620     function equalStorage(bytes storage _preBytes, bytes memory _postBytes) internal view returns (bool) {
621         bool success = true;
622 
623         assembly {
624             // we know _preBytes_offset is 0
625             let fslot := sload(_preBytes_slot)
626             // Decode the length of the stored array like in concatStorage().
627             let slength := div(and(fslot, sub(mul(0x100, iszero(and(fslot, 1))), 1)), 2)
628             let mlength := mload(_postBytes)
629 
630             // if lengths don't match the arrays are not equal
631             switch eq(slength, mlength)
632             case 1 {
633                 // slength can contain both the length and contents of the array
634                 // if length < 32 bytes so let's prepare for that
635                 // v. http://solidity.readthedocs.io/en/latest/miscellaneous.html#layout-of-state-variables-in-storage
636                 if iszero(iszero(slength)) {
637                     switch lt(slength, 32)
638                     case 1 {
639                         // blank the last byte which is the length
640                         fslot := mul(div(fslot, 0x100), 0x100)
641 
642                         if iszero(eq(fslot, mload(add(_postBytes, 0x20)))) {
643                             // unsuccess:
644                             success := 0
645                         }
646                     }
647                     default {
648                         // cb is a circuit breaker in the for loop since there's
649                         //  no said feature for inline assembly loops
650                         // cb = 1 - don't breaker
651                         // cb = 0 - break
652                         let cb := 1
653 
654                         // get the keccak hash to get the contents of the array
655                         mstore(0x0, _preBytes_slot)
656                         let sc := keccak256(0x0, 0x20)
657 
658                         let mc := add(_postBytes, 0x20)
659                         let end := add(mc, mlength)
660 
661                         // the next line is the loop condition:
662                         // while(uint(mc < end) + cb == 2)
663                         for {} eq(add(lt(mc, end), cb), 2) {
664                             sc := add(sc, 1)
665                             mc := add(mc, 0x20)
666                         } {
667                             if iszero(eq(sload(sc), mload(mc))) {
668                                 // unsuccess:
669                                 success := 0
670                                 cb := 0
671                             }
672                         }
673                     }
674                 }
675             }
676             default {
677                 // unsuccess:
678                 success := 0
679             }
680         }
681 
682         return success;
683     }
684 }
685 contract SpankBank {
686     using BytesLib for bytes;
687     using SafeMath for uint256;
688 
689     event SpankBankCreated(
690         uint256 periodLength,
691         uint256 maxPeriods,
692         address spankAddress,
693         uint256 initialBootySupply,
694         string bootyTokenName,
695         uint8 bootyDecimalUnits,
696         string bootySymbol
697     );
698 
699     event StakeEvent(
700         address staker,
701         uint256 period,
702         uint256 spankPoints,
703         uint256 spankAmount,
704         uint256 stakePeriods,
705         address delegateKey,
706         address bootyBase
707     );
708 
709     event SendFeesEvent (
710         address sender,
711         uint256 bootyAmount
712     );
713 
714     event MintBootyEvent (
715         uint256 targetBootySupply,
716         uint256 totalBootySupply
717     );
718 
719     event CheckInEvent (
720         address staker,
721         uint256 period,
722         uint256 spankPoints,
723         uint256 stakerEndingPeriod
724     );
725 
726     event ClaimBootyEvent (
727         address staker,
728         uint256 period,
729         uint256 bootyOwed
730     );
731 
732     event WithdrawStakeEvent (
733         address staker,
734         uint256 totalSpankToWithdraw
735     );
736 
737     event SplitStakeEvent (
738         address staker,
739         address newAddress,
740         address newDelegateKey,
741         address newBootyBase,
742         uint256 spankAmount
743     );
744 
745     event VoteToCloseEvent (
746         address staker,
747         uint256 period
748     );
749 
750     event UpdateDelegateKeyEvent (
751         address staker,
752         address newDelegateKey
753     );
754 
755     event UpdateBootyBaseEvent (
756         address staker,
757         address newBootyBase
758     );
759 
760     event ReceiveApprovalEvent (
761         address from,
762         address tokenContract
763     );
764 
765     /***********************************
766     VARIABLES SET AT CONTRACT DEPLOYMENT
767     ************************************/
768     // GLOBAL CONSTANT VARIABLES
769     uint256 public periodLength; // time length of each period in seconds
770     uint256 public maxPeriods; // the maximum # of periods a staker can stake for
771     uint256 public totalSpankStaked; // the total SPANK staked across all stakers
772     bool public isClosed; // true if voteToClose has passed, allows early withdrawals
773 
774     // ERC-20 BASED TOKEN WITH SOME ADDED PROPERTIES FOR HUMAN READABILITY
775     // https://github.com/ConsenSys/Tokens/blob/master/contracts/HumanStandardToken.sol
776     HumanStandardToken public spankToken;
777     MintAndBurnToken public bootyToken;
778 
779     // LOOKUP TABLE FOR SPANKPOINTS BY PERIOD
780     // 1 -> 45%
781     // 2 -> 50%
782     // ...
783     // 12 -> 100%
784     mapping(uint256 => uint256) public pointsTable;
785 
786     /*************************************
787     INTERAL ACCOUNTING
788     **************************************/
789     uint256 public currentPeriod = 0;
790 
791     struct Staker {
792         uint256 spankStaked; // the amount of spank staked
793         uint256 startingPeriod; // the period this staker started staking
794         uint256 endingPeriod; // the period after which this stake expires
795         mapping(uint256 => uint256) spankPoints; // the spankPoints per period
796         mapping(uint256 => bool) didClaimBooty; // true if staker claimed BOOTY for that period
797         mapping(uint256 => bool) votedToClose; // true if staker voted to close for that period
798         address delegateKey; // address used to call checkIn and claimBooty
799         address bootyBase; // destination address to receive BOOTY
800     }
801 
802     mapping(address => Staker) public stakers;
803 
804     struct Period {
805         uint256 bootyFees; // the amount of BOOTY collected in fees
806         uint256 totalSpankPoints; // the total spankPoints of all stakers
807         uint256 bootyMinted; // the amount of BOOTY minted
808         bool mintingComplete; // true if BOOTY has already been minted for this period
809         uint256 startTime; // the starting unix timestamp in seconds
810         uint256 endTime; // the ending unix timestamp in seconds
811         uint256 closingVotes; // the total votes to close this period
812     }
813 
814     mapping(uint256 => Period) public periods;
815 
816     mapping(address => address) public stakerByDelegateKey;
817 
818     modifier SpankBankIsOpen() {
819         require(isClosed == false);
820         _;
821     }
822 
823     constructor (
824         uint256 _periodLength,
825         uint256 _maxPeriods,
826         address spankAddress,
827         uint256 initialBootySupply,
828         string bootyTokenName,
829         uint8 bootyDecimalUnits,
830         string bootySymbol
831     )   public {
832         periodLength = _periodLength;
833         maxPeriods = _maxPeriods;
834         spankToken = HumanStandardToken(spankAddress);
835         bootyToken = new MintAndBurnToken(bootyTokenName, bootyDecimalUnits, bootySymbol);
836         bootyToken.mint(this, initialBootySupply);
837 
838         uint256 startTime = now;
839 
840         periods[currentPeriod].startTime = startTime;
841         periods[currentPeriod].endTime = SafeMath.add(startTime, periodLength);
842 
843         bootyToken.transfer(msg.sender, initialBootySupply);
844 
845         // initialize points table
846         pointsTable[0] = 0;
847         pointsTable[1] = 45;
848         pointsTable[2] = 50;
849         pointsTable[3] = 55;
850         pointsTable[4] = 60;
851         pointsTable[5] = 65;
852         pointsTable[6] = 70;
853         pointsTable[7] = 75;
854         pointsTable[8] = 80;
855         pointsTable[9] = 85;
856         pointsTable[10] = 90;
857         pointsTable[11] = 95;
858         pointsTable[12] = 100;
859 
860         emit SpankBankCreated(_periodLength, _maxPeriods, spankAddress, initialBootySupply, bootyTokenName, bootyDecimalUnits, bootySymbol);
861     }
862 
863     // Used to create a new staking position - verifies that the caller is not staking
864     function stake(uint256 spankAmount, uint256 stakePeriods, address delegateKey, address bootyBase) SpankBankIsOpen public {
865         doStake(msg.sender, spankAmount, stakePeriods, delegateKey, bootyBase);
866     }
867 
868     function doStake(address stakerAddress, uint256 spankAmount, uint256 stakePeriods, address delegateKey, address bootyBase) internal {
869         updatePeriod();
870         require(stakePeriods > 0 && stakePeriods <= maxPeriods, "stake not between zero and maxPeriods"); // stake 1-12 (max) periods
871         require(spankAmount > 0, "stake is 0"); // stake must be greater than 0
872 
873         // the staker must not have an active staking position
874         require(stakers[stakerAddress].startingPeriod == 0, "staker already exists");
875 
876         // transfer SPANK to this contract - assumes sender has already "allowed" the spankAmount
877         require(spankToken.transferFrom(stakerAddress, this, spankAmount));
878 
879         stakers[stakerAddress] = Staker(spankAmount, currentPeriod + 1, currentPeriod + stakePeriods, delegateKey, bootyBase);
880 
881         _updateNextPeriodPoints(stakerAddress, stakePeriods);
882 
883         totalSpankStaked = SafeMath.add(totalSpankStaked, spankAmount);
884 
885         require(delegateKey != address(0), "delegateKey does not exist");
886         require(bootyBase != address(0), "bootyBase does not exist");
887         require(stakerByDelegateKey[delegateKey] == address(0), "delegateKey already used");
888         stakerByDelegateKey[delegateKey] = stakerAddress;
889 
890         emit StakeEvent(
891             stakerAddress,
892             currentPeriod + 1,
893             stakers[stakerAddress].spankPoints[currentPeriod + 1],
894             spankAmount,
895             stakePeriods,
896             delegateKey,
897             bootyBase
898         );
899     }
900 
901     // Called during stake and checkIn, assumes those functions prevent duplicate calls
902     // for the same staker.
903     function _updateNextPeriodPoints(address stakerAddress, uint256 stakingPeriods) internal {
904         Staker storage staker = stakers[stakerAddress];
905 
906         uint256 stakerPoints = SafeMath.div(SafeMath.mul(staker.spankStaked, pointsTable[stakingPeriods]), 100);
907 
908         // add staker spankpoints to total spankpoints for the next period
909         uint256 totalPoints = periods[currentPeriod + 1].totalSpankPoints;
910         totalPoints = SafeMath.add(totalPoints, stakerPoints);
911         periods[currentPeriod + 1].totalSpankPoints = totalPoints;
912 
913         staker.spankPoints[currentPeriod + 1] = stakerPoints;
914     }
915 
916     function receiveApproval(address from, uint256 amount, address tokenContract, bytes extraData) SpankBankIsOpen public returns (bool success) {
917         address delegateKeyFromBytes = extraData.toAddress(12);
918         address bootyBaseFromBytes = extraData.toAddress(44);
919         uint256 periodFromBytes = extraData.toUint(64);
920 
921         emit ReceiveApprovalEvent(from, tokenContract);
922 
923         doStake(from, amount, periodFromBytes, delegateKeyFromBytes, bootyBaseFromBytes);
924         return true;
925     }
926 
927     function sendFees(uint256 bootyAmount) SpankBankIsOpen public {
928         updatePeriod();
929 
930         require(bootyAmount > 0, "fee is zero"); // fees must be greater than 0
931         require(bootyToken.transferFrom(msg.sender, this, bootyAmount));
932 
933         bootyToken.burn(bootyAmount);
934 
935         uint256 currentBootyFees = periods[currentPeriod].bootyFees;
936         currentBootyFees = SafeMath.add(bootyAmount, currentBootyFees);
937         periods[currentPeriod].bootyFees = currentBootyFees;
938 
939         emit SendFeesEvent(msg.sender, bootyAmount);
940     }
941 
942     function mintBooty() SpankBankIsOpen public {
943         updatePeriod();
944 
945         // can't mint BOOTY during period 0 - would result in integer underflow
946         require(currentPeriod > 0, "current period is zero");
947 
948         Period storage period = periods[currentPeriod - 1];
949         require(!period.mintingComplete, "minting already complete"); // cant mint BOOTY twice
950 
951         period.mintingComplete = true;
952 
953         uint256 targetBootySupply = SafeMath.mul(period.bootyFees, 20);
954         uint256 totalBootySupply = bootyToken.totalSupply();
955 
956         if (targetBootySupply > totalBootySupply) {
957             uint256 bootyMinted = targetBootySupply - totalBootySupply;
958             bootyToken.mint(this, bootyMinted);
959             period.bootyMinted = bootyMinted;
960             emit MintBootyEvent(targetBootySupply, totalBootySupply);
961         }
962     }
963 
964     // This will check the current time and update the current period accordingly
965     // - called from all write functions to ensure the period is always up to date before any writes
966     // - can also be called externally, but there isn't a good reason for why you would want to
967     // - the while loop protects against the edge case where we miss a period
968 
969     function updatePeriod() public {
970         while (now >= periods[currentPeriod].endTime) {
971             Period memory prevPeriod = periods[currentPeriod];
972             currentPeriod += 1;
973             periods[currentPeriod].startTime = prevPeriod.endTime;
974             periods[currentPeriod].endTime = SafeMath.add(prevPeriod.endTime, periodLength);
975         }
976     }
977 
978     // In order to receive Booty, each staker will have to check-in every period.
979     // This check-in will compute the spankPoints locally and globally for each staker.
980     function checkIn(uint256 updatedEndingPeriod) SpankBankIsOpen public {
981         updatePeriod();
982 
983         address stakerAddress =  stakerByDelegateKey[msg.sender];
984 
985         Staker storage staker = stakers[stakerAddress];
986 
987         require(staker.spankStaked > 0, "staker stake is zero");
988         require(currentPeriod < staker.endingPeriod, "staker expired");
989         require(staker.spankPoints[currentPeriod+1] == 0, "staker has points for next period");
990 
991         // If updatedEndingPeriod is 0, don't update the ending period
992         if (updatedEndingPeriod > 0) {
993             require(updatedEndingPeriod > staker.endingPeriod, "updatedEndingPeriod less than or equal to staker endingPeriod");
994             require(updatedEndingPeriod <= currentPeriod + maxPeriods, "updatedEndingPeriod greater than currentPeriod and maxPeriods");
995             staker.endingPeriod = updatedEndingPeriod;
996         }
997 
998         uint256 stakePeriods = staker.endingPeriod - currentPeriod;
999 
1000         _updateNextPeriodPoints(stakerAddress, stakePeriods);
1001 
1002         emit CheckInEvent(stakerAddress, currentPeriod + 1, staker.spankPoints[currentPeriod + 1], staker.endingPeriod);
1003     }
1004 
1005     function claimBooty(uint256 claimPeriod) public {
1006         updatePeriod();
1007 
1008         Period memory period = periods[claimPeriod];
1009         require(period.mintingComplete, "booty not minted");
1010 
1011         address stakerAddress = stakerByDelegateKey[msg.sender];
1012 
1013         Staker storage staker = stakers[stakerAddress];
1014 
1015         require(!staker.didClaimBooty[claimPeriod], "staker already claimed"); // can only claim booty once
1016 
1017         uint256 stakerSpankPoints = staker.spankPoints[claimPeriod];
1018         require(stakerSpankPoints > 0, "staker has no points"); // only stakers can claim
1019 
1020         staker.didClaimBooty[claimPeriod] = true;
1021 
1022         uint256 bootyMinted = period.bootyMinted;
1023         uint256 totalSpankPoints = period.totalSpankPoints;
1024 
1025         uint256 bootyOwed = SafeMath.div(SafeMath.mul(stakerSpankPoints, bootyMinted), totalSpankPoints);
1026 
1027         require(bootyToken.transfer(staker.bootyBase, bootyOwed));
1028 
1029         emit ClaimBootyEvent(stakerAddress, claimPeriod, bootyOwed);
1030     }
1031 
1032     function withdrawStake() public {
1033         updatePeriod();
1034 
1035         Staker storage staker = stakers[msg.sender];
1036         require(staker.spankStaked > 0, "staker has no stake");
1037 
1038         require(isClosed || currentPeriod > staker.endingPeriod, "currentPeriod less than endingPeriod or spankbank closed");
1039 
1040         uint256 spankToWithdraw = staker.spankStaked;
1041 
1042         totalSpankStaked = SafeMath.sub(totalSpankStaked, staker.spankStaked);
1043         staker.spankStaked = 0;
1044 
1045         spankToken.transfer(msg.sender, spankToWithdraw);
1046 
1047         emit WithdrawStakeEvent(msg.sender, spankToWithdraw);
1048     }
1049 
1050     function splitStake(address newAddress, address newDelegateKey, address newBootyBase, uint256 spankAmount) public {
1051         updatePeriod();
1052 
1053         require(newAddress != address(0), "newAddress is zero");
1054         require(newDelegateKey != address(0), "delegateKey is zero");
1055         require(newBootyBase != address(0), "bootyBase is zero");
1056         require(stakerByDelegateKey[newDelegateKey] == address(0), "delegateKey in use");
1057 
1058         require(spankAmount > 0, "spankAmount is zero");
1059 
1060         Staker storage staker = stakers[msg.sender];
1061         require(currentPeriod < staker.endingPeriod, "staker expired");
1062         require(spankAmount <= staker.spankStaked, "spankAmount greater than stake");
1063         require(staker.spankPoints[currentPeriod+1] == 0, "staker has points for next period");
1064 
1065         staker.spankStaked = SafeMath.sub(staker.spankStaked, spankAmount);
1066 
1067         stakers[newAddress] = Staker(spankAmount, staker.startingPeriod, staker.endingPeriod, newDelegateKey, newBootyBase);
1068 
1069         stakerByDelegateKey[newDelegateKey] = newAddress;
1070 
1071         emit SplitStakeEvent(msg.sender, newAddress, newDelegateKey, newBootyBase, spankAmount);
1072     }
1073 
1074     function voteToClose() public {
1075         updatePeriod();
1076 
1077         Staker storage staker = stakers[msg.sender];
1078 
1079         require(staker.spankStaked > 0, "stake is zero");
1080         require(currentPeriod < staker.endingPeriod , "staker expired");
1081         require(staker.votedToClose[currentPeriod] == false, "stake already voted");
1082         require(isClosed == false, "SpankBank already closed");
1083 
1084         uint256 closingVotes = periods[currentPeriod].closingVotes;
1085         closingVotes = SafeMath.add(closingVotes, staker.spankStaked);
1086         periods[currentPeriod].closingVotes = closingVotes;
1087 
1088         staker.votedToClose[currentPeriod] = true;
1089 
1090         uint256 closingTrigger = SafeMath.div(totalSpankStaked, 2);
1091         if (closingVotes > closingTrigger) {
1092             isClosed = true;
1093         }
1094 
1095         emit VoteToCloseEvent(msg.sender, currentPeriod);
1096     }
1097 
1098     function updateDelegateKey(address newDelegateKey) public {
1099         require(newDelegateKey != address(0), "delegateKey is zero");
1100         require(stakerByDelegateKey[newDelegateKey] == address(0), "delegateKey already exists");
1101 
1102         Staker storage staker = stakers[msg.sender];
1103         require(staker.startingPeriod > 0, "staker starting period is zero");
1104 
1105         stakerByDelegateKey[staker.delegateKey] = address(0);
1106         staker.delegateKey = newDelegateKey;
1107         stakerByDelegateKey[newDelegateKey] = msg.sender;
1108 
1109         emit UpdateDelegateKeyEvent(msg.sender, newDelegateKey);
1110     }
1111 
1112     function updateBootyBase(address newBootyBase) public {
1113         Staker storage staker = stakers[msg.sender];
1114         require(staker.startingPeriod > 0, "staker starting period is zero");
1115 
1116         staker.bootyBase = newBootyBase;
1117 
1118         emit UpdateBootyBaseEvent(msg.sender, newBootyBase);
1119     }
1120 
1121     function getSpankPoints(address stakerAddress, uint256 period) public view returns (uint256)  {
1122         return stakers[stakerAddress].spankPoints[period];
1123     }
1124 
1125     function getDidClaimBooty(address stakerAddress, uint256 period) public view returns (bool)  {
1126         return stakers[stakerAddress].didClaimBooty[period];
1127     }
1128 
1129     function getVote(address stakerAddress, uint period) public view returns (bool) {
1130         return stakers[stakerAddress].votedToClose[period];
1131     }
1132 
1133     function getStakerFromDelegateKey(address delegateAddress) public view returns (address) {
1134         return stakerByDelegateKey[delegateAddress];
1135     }
1136 }