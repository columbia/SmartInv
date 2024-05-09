1 pragma solidity ^0.4.23;
2 
3 interface ApproveAndCallFallBack {
4     function receiveApproval(
5         address from,
6         uint256 _amount,
7         address _token,
8         bytes _data
9     ) external;
10 }
11 
12 
13 contract Controlled {
14     /// @notice The address of the controller is the only address that can call
15     ///  a function with this modifier
16     modifier onlyController { 
17         require(msg.sender == controller); 
18         _; 
19     }
20 
21     address public controller;
22 
23     constructor() internal { 
24         controller = msg.sender; 
25     }
26 
27     /// @notice Changes the controller of the contract
28     /// @param _newController The new controller of the contract
29     function changeController(address _newController) public onlyController {
30         controller = _newController;
31     }
32 }
33 
34 
35 /*
36 * Used to proxy function calls to the RLPReader for testing
37 */
38 /*
39 * @author Hamdi Allam hamdi.allam97@gmail.com
40 * Please reach our for any questions/concerns
41 */
42 
43 
44 library RLPReader {
45     uint8 constant STRING_SHORT_START = 0x80;
46     uint8 constant STRING_LONG_START  = 0xb8;
47     uint8 constant LIST_SHORT_START   = 0xc0;
48     uint8 constant LIST_LONG_START    = 0xf8;
49 
50     uint8 constant WORD_SIZE = 32;
51 
52     struct RLPItem {
53         uint len;
54         uint memPtr;
55     }
56 
57     /*
58     * @param item RLP encoded bytes
59     */
60     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
61         if (item.length == 0) 
62             return RLPItem(0, 0);
63 
64         uint memPtr;
65         assembly {
66             memPtr := add(item, 0x20)
67         }
68 
69         return RLPItem(item.length, memPtr);
70     }
71 
72     /*
73     * @param item RLP encoded list in bytes
74     */
75     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory result) {
76         require(isList(item));
77 
78         uint items = numItems(item);
79         result = new RLPItem[](items);
80 
81         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
82         uint dataLen;
83         for (uint i = 0; i < items; i++) {
84             dataLen = _itemLength(memPtr);
85             result[i] = RLPItem(dataLen, memPtr); 
86             memPtr = memPtr + dataLen;
87         }
88     }
89 
90     /*
91     * Helpers
92     */
93 
94     // @return indicator whether encoded payload is a list. negate this function call for isData.
95     function isList(RLPItem memory item) internal pure returns (bool) {
96         uint8 byte0;
97         uint memPtr = item.memPtr;
98         assembly {
99             byte0 := byte(0, mload(memPtr))
100         }
101 
102         if (byte0 < LIST_SHORT_START)
103             return false;
104         return true;
105     }
106 
107     // @return number of payload items inside an encoded list.
108     function numItems(RLPItem memory item) internal pure returns (uint) {
109         uint count = 0;
110         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
111         uint endPtr = item.memPtr + item.len;
112         while (currPtr < endPtr) {
113            currPtr = currPtr + _itemLength(currPtr); // skip over an item
114            count++;
115         }
116 
117         return count;
118     }
119 
120     // @return entire rlp item byte length
121     function _itemLength(uint memPtr) internal pure returns (uint len) {
122         uint byte0;
123         assembly {
124             byte0 := byte(0, mload(memPtr))
125         }
126 
127         if (byte0 < STRING_SHORT_START)
128             return 1;
129         
130         else if (byte0 < STRING_LONG_START)
131             return byte0 - STRING_SHORT_START + 1;
132 
133         else if (byte0 < LIST_SHORT_START) {
134             assembly {
135                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
136                 memPtr := add(memPtr, 1) // skip over the first byte
137                 
138                 /* 32 byte word size */
139                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
140                 len := add(dataLen, add(byteLen, 1))
141             }
142         }
143 
144         else if (byte0 < LIST_LONG_START) {
145             return byte0 - LIST_SHORT_START + 1;
146         } 
147 
148         else {
149             assembly {
150                 let byteLen := sub(byte0, 0xf7)
151                 memPtr := add(memPtr, 1)
152 
153                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
154                 len := add(dataLen, add(byteLen, 1))
155             }
156         }
157     }
158 
159     // @return number of bytes until the data
160     function _payloadOffset(uint memPtr) internal pure returns (uint) {
161         uint byte0;
162         assembly {
163             byte0 := byte(0, mload(memPtr))
164         }
165 
166         if (byte0 < STRING_SHORT_START) 
167             return 0;
168         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
169             return 1;
170         else if (byte0 < LIST_SHORT_START)  // being explicit
171             return byte0 - (STRING_LONG_START - 1) + 1;
172         else
173             return byte0 - (LIST_LONG_START - 1) + 1;
174     }
175 
176     /** RLPItem conversions into data types **/
177 
178     function toBoolean(RLPItem memory item) internal pure returns (bool) {
179         require(item.len == 1, "Invalid RLPItem. Booleans are encoded in 1 byte");
180         uint result;
181         uint memPtr = item.memPtr;
182         assembly {
183             result := byte(0, mload(memPtr))
184         }
185 
186         return result == 0 ? false : true;
187     }
188 
189     function toAddress(RLPItem memory item) internal pure returns (address) {
190         // 1 byte for the length prefix according to RLP spec
191         require(item.len == 21, "Invalid RLPItem. Addresses are encoded in 20 bytes");
192         
193         uint memPtr = item.memPtr + 1; // skip the length prefix
194         uint addr;
195         assembly {
196             addr := div(mload(memPtr), exp(256, 12)) // right shift 12 bytes. we want the most significant 20 bytes
197         }
198         
199         return address(addr);
200     }
201 
202     function toUint(RLPItem memory item) internal pure returns (uint) {
203         uint offset = _payloadOffset(item.memPtr);
204         uint len = item.len - offset;
205         uint memPtr = item.memPtr + offset;
206 
207         uint result;
208         assembly {
209             result := div(mload(memPtr), exp(256, sub(32, len))) // shift to the correct location
210         }
211 
212         return result;
213     }
214 
215     function toBytes(RLPItem memory item) internal pure returns (bytes) {
216         uint offset = _payloadOffset(item.memPtr);
217         uint len = item.len - offset; // data length
218         bytes memory result = new bytes(len);
219 
220         uint destPtr;
221         assembly {
222             destPtr := add(0x20, result)
223         }
224 
225         copy(item.memPtr + offset, destPtr, len);
226         return result;
227     }
228 
229 
230     /*
231     * @param src Pointer to source
232     * @param dest Pointer to destination
233     * @param len Amount of memory to copy from the source
234     */
235     function copy(uint src, uint dest, uint len) internal pure {
236         // copy as many word sizes as possible
237         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
238             assembly {
239                 mstore(dest, mload(src))
240             }
241 
242             src += WORD_SIZE;
243             dest += WORD_SIZE;
244         }
245 
246         // left over bytes
247         uint mask = 256 ** (WORD_SIZE - len) - 1;
248         assembly {
249             let srcpart := and(mload(src), not(mask)) // zero out src
250             let destpart := and(mload(dest), mask) // retrieve the bytes
251             mstore(dest, or(destpart, srcpart))
252         }
253     }
254 }
255 
256 contract RLPHelper {
257     using RLPReader for bytes;
258     using RLPReader for uint;
259     using RLPReader for RLPReader.RLPItem;
260 
261     function isList(bytes memory item) public pure returns (bool) {
262         RLPReader.RLPItem memory rlpItem = item.toRlpItem();
263         return rlpItem.isList();
264     }
265 
266     function itemLength(bytes memory item) public pure returns (uint) {
267         uint memPtr;
268         assembly {
269             memPtr := add(0x20, item)
270         }
271 
272         return memPtr._itemLength();
273     }
274 
275     function numItems(bytes memory item) public pure returns (uint) {
276         RLPReader.RLPItem memory rlpItem = item.toRlpItem();
277         return rlpItem.numItems();
278     }
279 
280     function toBytes(bytes memory item) public pure returns (bytes) {
281         RLPReader.RLPItem memory rlpItem = item.toRlpItem();
282         return rlpItem.toBytes();
283     }
284 
285     function toUint(bytes memory item) public pure returns (uint) {
286         RLPReader.RLPItem memory rlpItem = item.toRlpItem();
287         return rlpItem.toUint();
288     }
289 
290     function toAddress(bytes memory item) public pure returns (address) {
291         RLPReader.RLPItem memory rlpItem = item.toRlpItem();
292         return rlpItem.toAddress();
293     }
294 
295     function toBoolean(bytes memory item) public pure returns (bool) {
296         RLPReader.RLPItem memory rlpItem = item.toRlpItem();
297         return rlpItem.toBoolean();
298     }
299 
300     function bytesToString(bytes memory item) public pure returns (string) {
301         RLPReader.RLPItem memory rlpItem = item.toRlpItem();
302         return string(rlpItem.toBytes());
303     }
304 
305     /* custom destructuring */
306     /*function customDestructure(bytes memory item) public pure returns (address, bool, uint) {
307         // first three elements follow the return types in order. Ignore the rest
308         RLPReader.RLPItem[] memory items = item.toRlpItem().toList();
309         return (items[0].toAddress(), items[1].toBoolean(), items[2].toUint());
310     }
311 
312     function customNestedDestructure(bytes memory item) public pure returns (address, uint) {
313         RLPReader.RLPItem[] memory items = item.toRlpItem().toList();
314         items = items[0].toList();
315         return (items[0].toAddress(), items[1].toUint());
316     }*/
317 
318 
319     //======================================
320 
321     function pollTitle(bytes memory item) public pure returns (string) {
322         RLPReader.RLPItem[] memory items = item.toRlpItem().toList();
323         return string(items[0].toBytes());
324     }
325 
326     function pollBallot(bytes memory item, uint ballotNum) public pure returns (string) {
327         RLPReader.RLPItem[] memory items = item.toRlpItem().toList();
328         items = items[1].toList();
329         return string(items[ballotNum].toBytes());
330     }
331 }
332 
333 
334 
335 
336 /*
337     Copyright 2016, Jordi Baylina
338 
339     This program is free software: you can redistribute it and/or modify
340     it under the terms of the GNU General Public License as published by
341     the Free Software Foundation, either version 3 of the License, or
342     (at your option) any later version.
343 
344     This program is distributed in the hope that it will be useful,
345     but WITHOUT ANY WARRANTY; without even the implied warranty of
346     MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
347     GNU General Public License for more details.
348 
349     You should have received a copy of the GNU General Public License
350     along with this program.  If not, see <http://www.gnu.org/licenses/>.
351  */
352 /**
353  * @title MiniMeToken Contract
354  * @author Jordi Baylina
355  * @dev This token contract's goal is to make it easy for anyone to clone this
356  *  token using the token distribution at a given block, this will allow DAO's
357  *  and DApps to upgrade their features in a decentralized manner without
358  *  affecting the original token
359  * @dev It is ERC20 compliant, but still needs to under go further testing.
360  */
361 
362 
363 
364 /**
365  * @dev The token controller contract must implement these functions
366  */
367 interface TokenController {
368     /**
369      * @notice Called when `_owner` sends ether to the MiniMe Token contract
370      * @param _owner The address that sent the ether to create tokens
371      * @return True if the ether is accepted, false if it throws
372      */
373     function proxyPayment(address _owner) external payable returns(bool);
374 
375     /**
376      * @notice Notifies the controller about a token transfer allowing the
377      *  controller to react if desired
378      * @param _from The origin of the transfer
379      * @param _to The destination of the transfer
380      * @param _amount The amount of the transfer
381      * @return False if the controller does not authorize the transfer
382      */
383     function onTransfer(address _from, address _to, uint _amount) external returns(bool);
384 
385     /**
386      * @notice Notifies the controller about an approval allowing the
387      *  controller to react if desired
388      * @param _owner The address that calls `approve()`
389      * @param _spender The spender in the `approve()` call
390      * @param _amount The amount in the `approve()` call
391      * @return False if the controller does not authorize the approval
392      */
393     function onApprove(address _owner, address _spender, uint _amount) external
394         returns(bool);
395 }
396 
397 
398 
399 
400 
401 
402 // Abstract contract for the full ERC 20 Token standard
403 // https://github.com/ethereum/EIPs/issues/20
404 
405 interface ERC20Token {
406 
407     /**
408      * @notice send `_value` token to `_to` from `msg.sender`
409      * @param _to The address of the recipient
410      * @param _value The amount of token to be transferred
411      * @return Whether the transfer was successful or not
412      */
413     function transfer(address _to, uint256 _value) external returns (bool success);
414 
415     /**
416      * @notice `msg.sender` approves `_spender` to spend `_value` tokens
417      * @param _spender The address of the account able to transfer the tokens
418      * @param _value The amount of tokens to be approved for transfer
419      * @return Whether the approval was successful or not
420      */
421     function approve(address _spender, uint256 _value) external returns (bool success);
422 
423     /**
424      * @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
425      * @param _from The address of the sender
426      * @param _to The address of the recipient
427      * @param _value The amount of token to be transferred
428      * @return Whether the transfer was successful or not
429      */
430     function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
431 
432     /**
433      * @param _owner The address from which the balance will be retrieved
434      * @return The balance
435      */
436     function balanceOf(address _owner) external view returns (uint256 balance);
437 
438     /**
439      * @param _owner The address of the account owning tokens
440      * @param _spender The address of the account able to transfer the tokens
441      * @return Amount of remaining tokens allowed to spent
442      */
443     function allowance(address _owner, address _spender) external view returns (uint256 remaining);
444 
445     /**
446      * @notice return total supply of tokens
447      */
448     function totalSupply() external view returns (uint256 supply);
449 
450     event Transfer(address indexed _from, address indexed _to, uint256 _value);
451     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
452 }
453 
454 
455 contract MiniMeTokenInterface is ERC20Token {
456 
457     /**
458      * @notice `msg.sender` approves `_spender` to send `_amount` tokens on
459      *  its behalf, and then a function is triggered in the contract that is
460      *  being approved, `_spender`. This allows users to use their tokens to
461      *  interact with contracts in one function call instead of two
462      * @param _spender The address of the contract able to transfer the tokens
463      * @param _amount The amount of tokens to be approved for transfer
464      * @return True if the function call was successful
465      */
466     function approveAndCall(
467         address _spender,
468         uint256 _amount,
469         bytes _extraData
470     ) 
471         external 
472         returns (bool success);
473 
474     /**    
475      * @notice Creates a new clone token with the initial distribution being
476      *  this token at `_snapshotBlock`
477      * @param _cloneTokenName Name of the clone token
478      * @param _cloneDecimalUnits Number of decimals of the smallest unit
479      * @param _cloneTokenSymbol Symbol of the clone token
480      * @param _snapshotBlock Block when the distribution of the parent token is
481      *  copied to set the initial distribution of the new clone token;
482      *  if the block is zero than the actual block, the current block is used
483      * @param _transfersEnabled True if transfers are allowed in the clone
484      * @return The address of the new MiniMeToken Contract
485      */
486     function createCloneToken(
487         string _cloneTokenName,
488         uint8 _cloneDecimalUnits,
489         string _cloneTokenSymbol,
490         uint _snapshotBlock,
491         bool _transfersEnabled
492     ) 
493         public
494         returns(address);
495 
496     /**    
497      * @notice Generates `_amount` tokens that are assigned to `_owner`
498      * @param _owner The address that will be assigned the new tokens
499      * @param _amount The quantity of tokens generated
500      * @return True if the tokens are generated correctly
501      */
502     function generateTokens(
503         address _owner,
504         uint _amount
505     )
506         public
507         returns (bool);
508 
509     /**
510      * @notice Burns `_amount` tokens from `_owner`
511      * @param _owner The address that will lose the tokens
512      * @param _amount The quantity of tokens to burn
513      * @return True if the tokens are burned correctly
514      */
515     function destroyTokens(
516         address _owner,
517         uint _amount
518     ) 
519         public
520         returns (bool);
521 
522     /**        
523      * @notice Enables token holders to transfer their tokens freely if true
524      * @param _transfersEnabled True if transfers are allowed in the clone
525      */
526     function enableTransfers(bool _transfersEnabled) public;
527 
528     /**    
529      * @notice This method can be used by the controller to extract mistakenly
530      *  sent tokens to this contract.
531      * @param _token The address of the token contract that you want to recover
532      *  set to 0 in case you want to extract ether.
533      */
534     function claimTokens(address _token) public;
535 
536     /**
537      * @dev Queries the balance of `_owner` at a specific `_blockNumber`
538      * @param _owner The address from which the balance will be retrieved
539      * @param _blockNumber The block number when the balance is queried
540      * @return The balance at `_blockNumber`
541      */
542     function balanceOfAt(
543         address _owner,
544         uint _blockNumber
545     ) 
546         public
547         constant
548         returns (uint);
549 
550     /**
551      * @notice Total amount of tokens at a specific `_blockNumber`.
552      * @param _blockNumber The block number when the totalSupply is queried
553      * @return The total amount of tokens at `_blockNumber`
554      */
555     function totalSupplyAt(uint _blockNumber) public view returns(uint);
556 
557 }
558 
559 
560 
561 
562 ////////////////
563 // MiniMeTokenFactory
564 ////////////////
565 
566 /**
567  * @dev This contract is used to generate clone contracts from a contract.
568  *  In solidity this is the way to create a contract from a contract of the
569  *  same class
570  */
571 contract MiniMeTokenFactory {
572 
573     /**
574      * @notice Update the DApp by creating a new token with new functionalities
575      *  the msg.sender becomes the controller of this clone token
576      * @param _parentToken Address of the token being cloned
577      * @param _snapshotBlock Block of the parent token that will
578      *  determine the initial distribution of the clone token
579      * @param _tokenName Name of the new token
580      * @param _decimalUnits Number of decimals of the new token
581      * @param _tokenSymbol Token Symbol for the new token
582      * @param _transfersEnabled If true, tokens will be able to be transferred
583      * @return The address of the new token contract
584      */
585     function createCloneToken(
586         address _parentToken,
587         uint _snapshotBlock,
588         string _tokenName,
589         uint8 _decimalUnits,
590         string _tokenSymbol,
591         bool _transfersEnabled
592     ) public returns (MiniMeToken) {
593         MiniMeToken newToken = new MiniMeToken(
594             this,
595             _parentToken,
596             _snapshotBlock,
597             _tokenName,
598             _decimalUnits,
599             _tokenSymbol,
600             _transfersEnabled
601             );
602 
603         newToken.changeController(msg.sender);
604         return newToken;
605     }
606 }
607 
608 /**
609  * @dev The actual token contract, the default controller is the msg.sender
610  *  that deploys the contract, so usually this token will be deployed by a
611  *  token controller contract, which Giveth will call a "Campaign"
612  */
613 contract MiniMeToken is MiniMeTokenInterface, Controlled {
614 
615     string public name;                //The Token's name: e.g. DigixDAO Tokens
616     uint8 public decimals;             //Number of decimals of the smallest unit
617     string public symbol;              //An identifier: e.g. REP
618     string public version = "MMT_0.1"; //An arbitrary versioning scheme
619 
620     /**
621      * @dev `Checkpoint` is the structure that attaches a block number to a
622      *  given value, the block number attached is the one that last changed the
623      *  value
624      */
625     struct Checkpoint {
626 
627         // `fromBlock` is the block number that the value was generated from
628         uint128 fromBlock;
629 
630         // `value` is the amount of tokens at a specific block number
631         uint128 value;
632     }
633 
634     // `parentToken` is the Token address that was cloned to produce this token;
635     //  it will be 0x0 for a token that was not cloned
636     MiniMeToken public parentToken;
637 
638     // `parentSnapShotBlock` is the block number from the Parent Token that was
639     //  used to determine the initial distribution of the Clone Token
640     uint public parentSnapShotBlock;
641 
642     // `creationBlock` is the block number that the Clone Token was created
643     uint public creationBlock;
644 
645     // `balances` is the map that tracks the balance of each address, in this
646     //  contract when the balance changes the block number that the change
647     //  occurred is also included in the map 
648     mapping (address => Checkpoint[]) balances;
649 
650     // `allowed` tracks any extra transfer rights as in all ERC20 tokens
651     mapping (address => mapping (address => uint256)) allowed;
652 
653     // Tracks the history of the `totalSupply` of the token
654     Checkpoint[] totalSupplyHistory;
655 
656     // Flag that determines if the token is transferable or not.
657     bool public transfersEnabled;
658 
659     // The factory used to create new clone tokens
660     MiniMeTokenFactory public tokenFactory;
661 
662 ////////////////
663 // Constructor
664 ////////////////
665 
666     /** 
667      * @notice Constructor to create a MiniMeToken
668      * @param _tokenFactory The address of the MiniMeTokenFactory contract that
669      *  will create the Clone token contracts, the token factory needs to be
670      *  deployed first
671      * @param _parentToken Address of the parent token, set to 0x0 if it is a
672      *  new token
673      * @param _parentSnapShotBlock Block of the parent token that will
674      *  determine the initial distribution of the clone token, set to 0 if it
675      *  is a new token
676      * @param _tokenName Name of the new token
677      * @param _decimalUnits Number of decimals of the new token
678      * @param _tokenSymbol Token Symbol for the new token
679      * @param _transfersEnabled If true, tokens will be able to be transferred
680      */
681     constructor(
682         address _tokenFactory,
683         address _parentToken,
684         uint _parentSnapShotBlock,
685         string _tokenName,
686         uint8 _decimalUnits,
687         string _tokenSymbol,
688         bool _transfersEnabled
689     ) 
690         public
691     {
692         require(_tokenFactory != address(0)); //if not set, clone feature will not work properly
693         tokenFactory = MiniMeTokenFactory(_tokenFactory);
694         name = _tokenName;                                 // Set the name
695         decimals = _decimalUnits;                          // Set the decimals
696         symbol = _tokenSymbol;                             // Set the symbol
697         parentToken = MiniMeToken(_parentToken);
698         parentSnapShotBlock = _parentSnapShotBlock;
699         transfersEnabled = _transfersEnabled;
700         creationBlock = block.number;
701     }
702 
703 
704 ///////////////////
705 // ERC20 Methods
706 ///////////////////
707 
708     /**
709      * @notice Send `_amount` tokens to `_to` from `msg.sender`
710      * @param _to The address of the recipient
711      * @param _amount The amount of tokens to be transferred
712      * @return Whether the transfer was successful or not
713      */
714     function transfer(address _to, uint256 _amount) public returns (bool success) {
715         require(transfersEnabled);
716         return doTransfer(msg.sender, _to, _amount);
717     }
718 
719     /**
720      * @notice Send `_amount` tokens to `_to` from `_from` on the condition it
721      *  is approved by `_from`
722      * @param _from The address holding the tokens being transferred
723      * @param _to The address of the recipient
724      * @param _amount The amount of tokens to be transferred
725      * @return True if the transfer was successful
726      */
727     function transferFrom(
728         address _from,
729         address _to,
730         uint256 _amount
731     ) 
732         public 
733         returns (bool success)
734     {
735 
736         // The controller of this contract can move tokens around at will,
737         //  this is important to recognize! Confirm that you trust the
738         //  controller of this contract, which in most situations should be
739         //  another open source smart contract or 0x0
740         if (msg.sender != controller) {
741             require(transfersEnabled);
742 
743             // The standard ERC 20 transferFrom functionality
744             if (allowed[_from][msg.sender] < _amount) { 
745                 return false;
746             }
747             allowed[_from][msg.sender] -= _amount;
748         }
749         return doTransfer(_from, _to, _amount);
750     }
751 
752     /**
753      * @dev This is the actual transfer function in the token contract, it can
754      *  only be called by other functions in this contract.
755      * @param _from The address holding the tokens being transferred
756      * @param _to The address of the recipient
757      * @param _amount The amount of tokens to be transferred
758      * @return True if the transfer was successful
759      */
760     function doTransfer(
761         address _from,
762         address _to,
763         uint _amount
764     ) 
765         internal
766         returns(bool)
767     {
768 
769         if (_amount == 0) {
770             return true;
771         }
772 
773         require(parentSnapShotBlock < block.number);
774 
775         // Do not allow transfer to 0x0 or the token contract itself
776         require((_to != 0) && (_to != address(this)));
777 
778         // If the amount being transfered is more than the balance of the
779         //  account the transfer returns false
780         uint256 previousBalanceFrom = balanceOfAt(_from, block.number);
781         if (previousBalanceFrom < _amount) {
782             return false;
783         }
784 
785         // Alerts the token controller of the transfer
786         if (isContract(controller)) {
787             require(TokenController(controller).onTransfer(_from, _to, _amount));
788         }
789 
790         // First update the balance array with the new value for the address
791         //  sending the tokens
792         updateValueAtNow(balances[_from], previousBalanceFrom - _amount);
793 
794         // Then update the balance array with the new value for the address
795         //  receiving the tokens
796         uint256 previousBalanceTo = balanceOfAt(_to, block.number);
797         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
798         updateValueAtNow(balances[_to], previousBalanceTo + _amount);
799 
800         // An event to make the transfer easy to find on the blockchain
801         emit Transfer(_from, _to, _amount);
802 
803         return true;
804     }
805 
806     function doApprove(
807         address _from,
808         address _spender,
809         uint256 _amount
810     )
811         internal 
812         returns (bool)
813     {
814         require(transfersEnabled);
815 
816         // To change the approve amount you first have to reduce the addresses`
817         //  allowance to zero by calling `approve(_spender,0)` if it is not
818         //  already 0 to mitigate the race condition described here:
819         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
820         require((_amount == 0) || (allowed[_from][_spender] == 0));
821 
822         // Alerts the token controller of the approve function call
823         if (isContract(controller)) {
824             require(TokenController(controller).onApprove(_from, _spender, _amount));
825         }
826 
827         allowed[_from][_spender] = _amount;
828         emit Approval(_from, _spender, _amount);
829         return true;
830     }
831 
832     /**
833      * @param _owner The address that's balance is being requested
834      * @return The balance of `_owner` at the current block
835      */
836     function balanceOf(address _owner) external view returns (uint256 balance) {
837         return balanceOfAt(_owner, block.number);
838     }
839 
840     /**
841      * @notice `msg.sender` approves `_spender` to spend `_amount` tokens on
842      *  its behalf. This is a modified version of the ERC20 approve function
843      *  to be a little bit safer
844      * @param _spender The address of the account able to transfer the tokens
845      * @param _amount The amount of tokens to be approved for transfer
846      * @return True if the approval was successful
847      */
848     function approve(address _spender, uint256 _amount) external returns (bool success) {
849         doApprove(msg.sender, _spender, _amount);
850     }
851 
852     /**
853      * @dev This function makes it easy to read the `allowed[]` map
854      * @param _owner The address of the account that owns the token
855      * @param _spender The address of the account able to transfer the tokens
856      * @return Amount of remaining tokens of _owner that _spender is allowed
857      *  to spend
858      */
859     function allowance(
860         address _owner,
861         address _spender
862     ) 
863         external
864         view
865         returns (uint256 remaining)
866     {
867         return allowed[_owner][_spender];
868     }
869     /**
870      * @notice `msg.sender` approves `_spender` to send `_amount` tokens on
871      *  its behalf, and then a function is triggered in the contract that is
872      *  being approved, `_spender`. This allows users to use their tokens to
873      *  interact with contracts in one function call instead of two
874      * @param _spender The address of the contract able to transfer the tokens
875      * @param _amount The amount of tokens to be approved for transfer
876      * @return True if the function call was successful
877      */
878     function approveAndCall(
879         address _spender,
880         uint256 _amount,
881         bytes _extraData
882     ) 
883         external 
884         returns (bool success)
885     {
886         require(doApprove(msg.sender, _spender, _amount));
887 
888         ApproveAndCallFallBack(_spender).receiveApproval(
889             msg.sender,
890             _amount,
891             this,
892             _extraData
893         );
894 
895         return true;
896     }
897 
898     /**
899      * @dev This function makes it easy to get the total number of tokens
900      * @return The total number of tokens
901      */
902     function totalSupply() external view returns (uint) {
903         return totalSupplyAt(block.number);
904     }
905 
906 
907 ////////////////
908 // Query balance and totalSupply in History
909 ////////////////
910 
911     /**
912      * @dev Queries the balance of `_owner` at a specific `_blockNumber`
913      * @param _owner The address from which the balance will be retrieved
914      * @param _blockNumber The block number when the balance is queried
915      * @return The balance at `_blockNumber`
916      */
917     function balanceOfAt(
918         address _owner,
919         uint _blockNumber
920     ) 
921         public
922         view
923         returns (uint) 
924     {
925 
926         // These next few lines are used when the balance of the token is
927         //  requested before a check point was ever created for this token, it
928         //  requires that the `parentToken.balanceOfAt` be queried at the
929         //  genesis block for that token as this contains initial balance of
930         //  this token
931         if ((balances[_owner].length == 0) || (balances[_owner][0].fromBlock > _blockNumber)) {
932             if (address(parentToken) != 0) {
933                 return parentToken.balanceOfAt(_owner, min(_blockNumber, parentSnapShotBlock));
934             } else {
935                 // Has no parent
936                 return 0;
937             }
938 
939         // This will return the expected balance during normal situations
940         } else {
941             return getValueAt(balances[_owner], _blockNumber);
942         }
943     }
944 
945     /**
946      * @notice Total amount of tokens at a specific `_blockNumber`.
947      * @param _blockNumber The block number when the totalSupply is queried
948      * @return The total amount of tokens at `_blockNumber`
949      */
950     function totalSupplyAt(uint _blockNumber) public view returns(uint) {
951 
952         // These next few lines are used when the totalSupply of the token is
953         //  requested before a check point was ever created for this token, it
954         //  requires that the `parentToken.totalSupplyAt` be queried at the
955         //  genesis block for this token as that contains totalSupply of this
956         //  token at this block number.
957         if ((totalSupplyHistory.length == 0) || (totalSupplyHistory[0].fromBlock > _blockNumber)) {
958             if (address(parentToken) != 0) {
959                 return parentToken.totalSupplyAt(min(_blockNumber, parentSnapShotBlock));
960             } else {
961                 return 0;
962             }
963 
964         // This will return the expected totalSupply during normal situations
965         } else {
966             return getValueAt(totalSupplyHistory, _blockNumber);
967         }
968     }
969 
970 ////////////////
971 // Clone Token Method
972 ////////////////
973 
974     /**
975      * @notice Creates a new clone token with the initial distribution being
976      *  this token at `_snapshotBlock`
977      * @param _cloneTokenName Name of the clone token
978      * @param _cloneDecimalUnits Number of decimals of the smallest unit
979      * @param _cloneTokenSymbol Symbol of the clone token
980      * @param _snapshotBlock Block when the distribution of the parent token is
981      *  copied to set the initial distribution of the new clone token;
982      *  if the block is zero than the actual block, the current block is used
983      * @param _transfersEnabled True if transfers are allowed in the clone
984      * @return The address of the new MiniMeToken Contract
985      */
986     function createCloneToken(
987         string _cloneTokenName,
988         uint8 _cloneDecimalUnits,
989         string _cloneTokenSymbol,
990         uint _snapshotBlock,
991         bool _transfersEnabled
992         ) 
993             public
994             returns(address)
995         {
996         uint snapshotBlock = _snapshotBlock;
997         if (snapshotBlock == 0) {
998             snapshotBlock = block.number;
999         }
1000         MiniMeToken cloneToken = tokenFactory.createCloneToken(
1001             this,
1002             snapshotBlock,
1003             _cloneTokenName,
1004             _cloneDecimalUnits,
1005             _cloneTokenSymbol,
1006             _transfersEnabled
1007             );
1008 
1009         cloneToken.changeController(msg.sender);
1010 
1011         // An event to make the token easy to find on the blockchain
1012         emit NewCloneToken(address(cloneToken), snapshotBlock);
1013         return address(cloneToken);
1014     }
1015 
1016 ////////////////
1017 // Generate and destroy tokens
1018 ////////////////
1019     
1020     /**
1021      * @notice Generates `_amount` tokens that are assigned to `_owner`
1022      * @param _owner The address that will be assigned the new tokens
1023      * @param _amount The quantity of tokens generated
1024      * @return True if the tokens are generated correctly
1025      */
1026     function generateTokens(
1027         address _owner,
1028         uint _amount
1029     )
1030         public
1031         onlyController
1032         returns (bool)
1033     {
1034         uint curTotalSupply = totalSupplyAt(block.number);
1035         require(curTotalSupply + _amount >= curTotalSupply); // Check for overflow
1036         uint previousBalanceTo = balanceOfAt(_owner, block.number);
1037         require(previousBalanceTo + _amount >= previousBalanceTo); // Check for overflow
1038         updateValueAtNow(totalSupplyHistory, curTotalSupply + _amount);
1039         updateValueAtNow(balances[_owner], previousBalanceTo + _amount);
1040         emit Transfer(0, _owner, _amount);
1041         return true;
1042     }
1043 
1044     /**
1045      * @notice Burns `_amount` tokens from `_owner`
1046      * @param _owner The address that will lose the tokens
1047      * @param _amount The quantity of tokens to burn
1048      * @return True if the tokens are burned correctly
1049      */
1050     function destroyTokens(
1051         address _owner,
1052         uint _amount
1053     ) 
1054         public
1055         onlyController
1056         returns (bool)
1057     {
1058         uint curTotalSupply = totalSupplyAt(block.number);
1059         require(curTotalSupply >= _amount);
1060         uint previousBalanceFrom = balanceOfAt(_owner, block.number);
1061         require(previousBalanceFrom >= _amount);
1062         updateValueAtNow(totalSupplyHistory, curTotalSupply - _amount);
1063         updateValueAtNow(balances[_owner], previousBalanceFrom - _amount);
1064         emit Transfer(_owner, 0, _amount);
1065         return true;
1066     }
1067 
1068 ////////////////
1069 // Enable tokens transfers
1070 ////////////////
1071 
1072     /**
1073      * @notice Enables token holders to transfer their tokens freely if true
1074      * @param _transfersEnabled True if transfers are allowed in the clone
1075      */
1076     function enableTransfers(bool _transfersEnabled) public onlyController {
1077         transfersEnabled = _transfersEnabled;
1078     }
1079 
1080 ////////////////
1081 // Internal helper functions to query and set a value in a snapshot array
1082 ////////////////
1083 
1084     /**
1085      * @dev `getValueAt` retrieves the number of tokens at a given block number
1086      * @param checkpoints The history of values being queried
1087      * @param _block The block number to retrieve the value at
1088      * @return The number of tokens being queried
1089      */
1090     function getValueAt(
1091         Checkpoint[] storage checkpoints,
1092         uint _block
1093     ) 
1094         view
1095         internal
1096         returns (uint)
1097     {
1098         if (checkpoints.length == 0) {
1099             return 0;
1100         }
1101 
1102         // Shortcut for the actual value
1103         if (_block >= checkpoints[checkpoints.length-1].fromBlock) {
1104             return checkpoints[checkpoints.length-1].value;
1105         }
1106         if (_block < checkpoints[0].fromBlock) {
1107             return 0;
1108         }
1109 
1110         // Binary search of the value in the array
1111         uint min = 0;
1112         uint max = checkpoints.length-1;
1113         while (max > min) {
1114             uint mid = (max + min + 1) / 2;
1115             if (checkpoints[mid].fromBlock<=_block) {
1116                 min = mid;
1117             } else {
1118                 max = mid-1;
1119             }
1120         }
1121         return checkpoints[min].value;
1122     }
1123 
1124     /**
1125      * @dev `updateValueAtNow` used to update the `balances` map and the
1126      *  `totalSupplyHistory`
1127      * @param checkpoints The history of data being updated
1128      * @param _value The new number of tokens
1129      */
1130     function updateValueAtNow(Checkpoint[] storage checkpoints, uint _value) internal {
1131         if (
1132             (checkpoints.length == 0) ||
1133             (checkpoints[checkpoints.length - 1].fromBlock < block.number)) 
1134         {
1135             Checkpoint storage newCheckPoint = checkpoints[checkpoints.length++];
1136             newCheckPoint.fromBlock = uint128(block.number);
1137             newCheckPoint.value = uint128(_value);
1138         } else {
1139             Checkpoint storage oldCheckPoint = checkpoints[checkpoints.length-1];
1140             oldCheckPoint.value = uint128(_value);
1141         }
1142     }
1143 
1144     /**
1145      * @dev Internal function to determine if an address is a contract
1146      * @param _addr The address being queried
1147      * @return True if `_addr` is a contract
1148      */
1149     function isContract(address _addr) internal view returns(bool) {
1150         uint size;
1151         if (_addr == 0) {
1152             return false;
1153         }    
1154         assembly {
1155             size := extcodesize(_addr)
1156         }
1157         return size > 0;
1158     }
1159 
1160     /**
1161      * @dev Helper function to return a min betwen the two uints
1162      */
1163     function min(uint a, uint b) internal returns (uint) {
1164         return a < b ? a : b;
1165     }
1166 
1167     /**
1168      * @notice The fallback function: If the contract's controller has not been
1169      *  set to 0, then the `proxyPayment` method is called which relays the
1170      *  ether and creates tokens as described in the token controller contract
1171      */
1172     function () public payable {
1173         require(isContract(controller));
1174         require(TokenController(controller).proxyPayment.value(msg.value)(msg.sender));
1175     }
1176 
1177 //////////
1178 // Safety Methods
1179 //////////
1180 
1181     /**
1182      * @notice This method can be used by the controller to extract mistakenly
1183      *  sent tokens to this contract.
1184      * @param _token The address of the token contract that you want to recover
1185      *  set to 0 in case you want to extract ether.
1186      */
1187     function claimTokens(address _token) public onlyController {
1188         if (_token == 0x0) {
1189             controller.transfer(address(this).balance);
1190             return;
1191         }
1192 
1193         MiniMeToken token = MiniMeToken(_token);
1194         uint balance = token.balanceOf(address(this));
1195         token.transfer(controller, balance);
1196         emit ClaimedTokens(_token, controller, balance);
1197     }
1198 
1199 ////////////////
1200 // Events
1201 ////////////////
1202     event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
1203     event Transfer(address indexed _from, address indexed _to, uint256 _amount);
1204     event NewCloneToken(address indexed _cloneToken, uint snapshotBlock);
1205     event Approval(
1206         address indexed _owner,
1207         address indexed _spender,
1208         uint256 _amount
1209     );
1210 
1211 }
1212 
1213 
1214 
1215 contract PollManager is Controlled {
1216 
1217     struct Poll {
1218         uint startBlock;
1219         uint endTime;
1220         bool canceled;
1221         uint voters;
1222         bytes description;
1223         uint8 numBallots;
1224         mapping(uint8 => mapping(address => uint)) ballots;
1225         mapping(uint8 => uint) qvResults;
1226         mapping(uint8 => uint) results;
1227         mapping(uint8 => uint) votersByBallot;
1228         address author;
1229     }
1230 
1231     Poll[] _polls;
1232 
1233     MiniMeToken public token;
1234 
1235     RLPHelper public rlpHelper;
1236 
1237     /// @notice Contract constructor
1238     /// @param _token Address of the token used for governance
1239     constructor(address _token) 
1240         public {
1241         token = MiniMeToken(_token);
1242         rlpHelper = new RLPHelper();
1243     }
1244 
1245     /// @notice Only allow addresses that have > 0 SNT to perform an operation
1246     modifier onlySNTHolder {
1247         require(token.balanceOf(msg.sender) > 0, "SNT Balance is required to perform this operation"); 
1248         _; 
1249     }
1250 
1251     /// @notice Create a Poll and enable it immediatly
1252     /// @param _endTime Block where the poll ends
1253     /// @param _description IPFS hash with the description
1254     /// @param _numBallots Number of ballots
1255     function addPoll(
1256         uint _endTime,
1257         bytes _description,
1258         uint8 _numBallots)
1259         public
1260         onlySNTHolder
1261         returns (uint _idPoll)
1262     {
1263         _idPoll = addPoll(block.number, _endTime, _description, _numBallots);
1264     }
1265 
1266     /// @notice Create a Poll
1267     /// @param _startBlock Block where the poll starts
1268     /// @param _endTime Block where the poll ends
1269     /// @param _description IPFS hash with the description
1270     /// @param _numBallots Number of ballots
1271     function addPoll(
1272         uint _startBlock,
1273         uint _endTime,
1274         bytes _description,
1275         uint8 _numBallots)
1276         public
1277         onlySNTHolder
1278         returns (uint _idPoll)
1279     {
1280         require(_endTime > block.timestamp, "End time must be greater than current timestamp");
1281         require(_startBlock >= block.number, "Start block must not be in the past");
1282         require(_numBallots <= 100, "Only a max of 100 ballots are allowed");
1283 
1284         _idPoll = _polls.length;
1285         _polls.length ++;
1286 
1287         Poll storage p = _polls[_idPoll];
1288         p.startBlock = _startBlock;
1289         p.endTime = _endTime;
1290         p.voters = 0;
1291         p.numBallots = _numBallots;
1292         p.description = _description;
1293         p.author = msg.sender;
1294 
1295         emit PollCreated(_idPoll);
1296     }
1297 
1298     /// @notice Update poll description (title or ballots) as long as it hasn't started
1299     /// @param _idPoll Poll to update
1300     /// @param _description IPFS hash with the description
1301     /// @param _numBallots Number of ballots
1302     function updatePollDescription(
1303         uint _idPoll, 
1304         bytes _description,
1305         uint8 _numBallots)
1306         public
1307     {
1308         require(_idPoll < _polls.length, "Invalid _idPoll");
1309         require(_numBallots <= 100, "Only a max of 100 ballots are allowed");
1310 
1311         Poll storage p = _polls[_idPoll];
1312         require(p.startBlock > block.number, "You cannot modify an active poll");
1313         require(p.author == msg.sender || msg.sender == controller, "Only the owner/controller can modify the poll");
1314 
1315         p.numBallots = _numBallots;
1316         p.description = _description;
1317         p.author = msg.sender;
1318     }
1319 
1320     /// @notice Cancel an existing poll
1321     /// @dev Can only be done by the controller (which should be a Multisig/DAO) at any time, or by the owner if the poll hasn't started
1322     /// @param _idPoll Poll to cancel
1323     function cancelPoll(uint _idPoll) 
1324         public {
1325         require(_idPoll < _polls.length, "Invalid _idPoll");
1326 
1327         Poll storage p = _polls[_idPoll];
1328         
1329         require(!p.canceled, "Poll has been canceled already");
1330         require(block.timestamp <= p.endTime, "Only active polls can be canceled");
1331 
1332         if(p.startBlock < block.number){
1333             require(msg.sender == controller, "Only the controller can cancel the poll");
1334         } else {
1335             require(p.author == msg.sender, "Only the owner can cancel the poll");
1336         }
1337 
1338         p.canceled = true;
1339 
1340         emit PollCanceled(_idPoll);
1341     }
1342 
1343     /// @notice Determine if user can bote for a poll
1344     /// @param _idPoll Id of the poll
1345     /// @return bool Can vote or not
1346     function canVote(uint _idPoll) 
1347         public 
1348         view 
1349         returns(bool)
1350     {
1351         if(_idPoll >= _polls.length) return false;
1352 
1353         Poll storage p = _polls[_idPoll];
1354         uint balance = token.balanceOfAt(msg.sender, p.startBlock);
1355         return block.number >= p.startBlock && block.timestamp < p.endTime && !p.canceled && balance != 0;
1356     }
1357     
1358     /// @notice Calculate square root of a uint (It has some precision loss)
1359     /// @param x Number to calculate the square root
1360     /// @return Square root of x
1361     function sqrt(uint256 x) public pure returns (uint256 y) {
1362         uint256 z = (x + 1) / 2;
1363         y = x;
1364         while (z < y) {
1365             y = z;
1366             z = (x / z + z) / 2;
1367         }
1368     }
1369 
1370     /// @notice Vote for a poll
1371     /// @param _idPoll Poll to vote
1372     /// @param _ballots array of (number of ballots the poll has) elements, and their sum must be less or equal to the balance at the block start
1373     function vote(uint _idPoll, uint[] _ballots) public {
1374         require(_idPoll < _polls.length, "Invalid _idPoll");
1375 
1376         Poll storage p = _polls[_idPoll];
1377 
1378         require(block.number >= p.startBlock && block.timestamp < p.endTime && !p.canceled, "Poll is inactive");
1379         require(_ballots.length == p.numBallots, "Number of ballots is incorrect");
1380 
1381         unvote(_idPoll);
1382 
1383         uint amount = token.balanceOfAt(msg.sender, p.startBlock);
1384         require(amount != 0, "No SNT balance available at start block of poll");
1385 
1386         p.voters++;
1387 
1388         uint totalBallots = 0;
1389         for(uint8 i = 0; i < _ballots.length; i++){
1390             totalBallots += _ballots[i];
1391 
1392             p.ballots[i][msg.sender] = _ballots[i];
1393 
1394             if(_ballots[i] != 0){
1395                 p.qvResults[i] += sqrt(_ballots[i] / 1 ether);
1396                 p.results[i] += _ballots[i];
1397                 p.votersByBallot[i]++;
1398             }
1399         }
1400 
1401         require(totalBallots <= amount, "Total ballots must be less than the SNT balance at poll start block");
1402 
1403         emit Vote(_idPoll, msg.sender, _ballots);
1404     }
1405 
1406     /// @notice Cancel or reset a vote
1407     /// @param _idPoll Poll 
1408     function unvote(uint _idPoll) public {
1409         require(_idPoll < _polls.length, "Invalid _idPoll");
1410 
1411         Poll storage p = _polls[_idPoll];
1412         
1413         require(block.number >= p.startBlock && block.timestamp < p.endTime && !p.canceled, "Poll is inactive");
1414 
1415         if(p.voters == 0) return;
1416 
1417         uint prevVotes = 0;
1418         for(uint8 i = 0; i < p.numBallots; i++){
1419             uint ballotAmount = p.ballots[i][msg.sender];
1420 
1421             prevVotes += ballotAmount;
1422             p.ballots[i][msg.sender] = 0;
1423 
1424             if(ballotAmount != 0){
1425                 p.qvResults[i] -= sqrt(ballotAmount / 1 ether);
1426                 p.results[i] -= ballotAmount;
1427                 p.votersByBallot[i]--;
1428             }
1429         }
1430 
1431         if(prevVotes != 0){
1432             p.voters--;
1433         }
1434 
1435         emit Unvote(_idPoll, msg.sender);
1436     }
1437 
1438     // Constant Helper Function
1439 
1440     /// @notice Get number of polls
1441     /// @return Num of polls
1442     function nPolls()
1443         public
1444         view 
1445         returns(uint)
1446     {
1447         return _polls.length;
1448     }
1449 
1450     /// @notice Get Poll info
1451     /// @param _idPoll Poll 
1452     function poll(uint _idPoll)
1453         public 
1454         view 
1455         returns(
1456         uint _startBlock,
1457         uint _endTime,
1458         bool _canVote,
1459         bool _canceled,
1460         bytes _description,
1461         uint8 _numBallots,
1462         bool _finalized,
1463         uint _voters,
1464         address _author,
1465         uint[100] _tokenTotal,
1466         uint[100] _quadraticVotes,
1467         uint[100] _votersByBallot
1468     )
1469     {
1470         require(_idPoll < _polls.length, "Invalid _idPoll");
1471 
1472         Poll storage p = _polls[_idPoll];
1473 
1474         _startBlock = p.startBlock;
1475         _endTime = p.endTime;
1476         _canceled = p.canceled;
1477         _canVote = canVote(_idPoll);
1478         _description = p.description;
1479         _numBallots = p.numBallots;
1480         _author = p.author;
1481         _finalized = (!p.canceled) && (block.number >= _endTime);
1482         _voters = p.voters;
1483 
1484         for(uint8 i = 0; i < p.numBallots; i++){
1485             _tokenTotal[i] = p.results[i];
1486             _quadraticVotes[i] = p.qvResults[i];
1487             _votersByBallot[i] = p.votersByBallot[i];
1488         }
1489     }
1490 
1491     /// @notice Decode poll title
1492     /// @param _idPoll Poll
1493     /// @return string with the poll title
1494     function pollTitle(uint _idPoll) public view returns (string){
1495         require(_idPoll < _polls.length, "Invalid _idPoll");
1496         Poll memory p = _polls[_idPoll];
1497 
1498         return rlpHelper.pollTitle(p.description);
1499     }
1500 
1501     /// @notice Decode poll ballot
1502     /// @param _idPoll Poll
1503     /// @param _ballot Index (0-based) of the ballot to decode
1504     /// @return string with the ballot text
1505     function pollBallot(uint _idPoll, uint _ballot) public view returns (string){
1506         require(_idPoll < _polls.length, "Invalid _idPoll");
1507         Poll memory p = _polls[_idPoll];
1508 
1509         return rlpHelper.pollBallot(p.description, _ballot);
1510     }
1511 
1512     /// @notice Get votes for poll/ballot
1513     /// @param _idPoll Poll
1514     /// @param _voter Address of the voter
1515     function getVote(uint _idPoll, address _voter) 
1516         public 
1517         view 
1518         returns (uint[100] votes){
1519         require(_idPoll < _polls.length, "Invalid _idPoll");
1520         Poll storage p = _polls[_idPoll];
1521         for(uint8 i = 0; i < p.numBallots; i++){
1522             votes[i] = p.ballots[i][_voter];
1523         }
1524         return votes;
1525     }
1526 
1527     event Vote(uint indexed idPoll, address indexed _voter, uint[] ballots);
1528     event Unvote(uint indexed idPoll, address indexed _voter);
1529     event PollCanceled(uint indexed idPoll);
1530     event PollCreated(uint indexed idPoll);
1531 }