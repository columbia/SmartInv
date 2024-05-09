1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that throw on error
6  */
7 library SafeMath {
8 
9     /**
10     * @dev Multiplies two numbers, throws on overflow.
11     */
12     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
13         if (a == 0) {
14             return 0;
15         }
16         c = a * b;
17         assert(c / a == b);
18         return c;
19     }
20 
21     /**
22     * @dev Integer division of two numbers, truncating the quotient.
23     */
24     function div(uint256 a, uint256 b) internal pure returns (uint256) {
25         // assert(b > 0); // Solidity automatically throws when dividing by 0
26         // uint256 c = a / b;
27         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
28         return a / b;
29     }
30 
31     /**
32     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33     */
34     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
35         assert(b <= a);
36         return a - b;
37     }
38 
39     /**
40     * @dev Adds two numbers, throws on overflow.
41     */
42     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
43         c = a + b;
44         assert(c >= a);
45         return c;
46     }
47 }
48 /**
49  * @title SafeMath
50  * @dev Math operations with safety checks that throw on error
51  */
52 library SafeMath128 {
53 
54     /**
55     * @dev Multiplies two numbers, throws on overflow.
56     */
57     function mul(uint128 a, uint128 b) internal pure returns (uint128 c) {
58         if (a == 0) {
59             return 0;
60         }
61         c = a * b;
62         assert(c / a == b);
63         return c;
64     }
65 
66     /**
67     * @dev Integer division of two numbers, truncating the quotient.
68     */
69     function div(uint128 a, uint128 b) internal pure returns (uint128) {
70         // assert(b > 0); // Solidity automatically throws when dividing by 0
71         // uint256 c = a / b;
72         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73         return a / b;
74     }
75 
76     /**
77     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
78     */
79     function sub(uint128 a, uint128 b) internal pure returns (uint128) {
80         assert(b <= a);
81         return a - b;
82     }
83 
84     /**
85     * @dev Adds two numbers, throws on overflow.
86     */
87     function add(uint128 a, uint128 b) internal pure returns (uint128 c) {
88         c = a + b;
89         assert(c >= a);
90         return c;
91     }
92 }
93 /**
94  * @title SafeMath
95  * @dev Math operations with safety checks that throw on error
96  */
97 library SafeMath64 {
98 
99     /**
100     * @dev Multiplies two numbers, throws on overflow.
101     */
102     function mul(uint64 a, uint64 b) internal pure returns (uint64 c) {
103         if (a == 0) {
104             return 0;
105         }
106         c = a * b;
107         assert(c / a == b);
108         return c;
109     }
110 
111     /**
112     * @dev Integer division of two numbers, truncating the quotient.
113     */
114     function div(uint64 a, uint64 b) internal pure returns (uint64) {
115         // assert(b > 0); // Solidity automatically throws when dividing by 0
116         // uint256 c = a / b;
117         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
118         return a / b;
119     }
120 
121     /**
122     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
123     */
124     function sub(uint64 a, uint64 b) internal pure returns (uint64) {
125         assert(b <= a);
126         return a - b;
127     }
128 
129     /**
130     * @dev Adds two numbers, throws on overflow.
131     */
132     function add(uint64 a, uint64 b) internal pure returns (uint64 c) {
133         c = a + b;
134         assert(c >= a);
135         return c;
136     }
137 }
138 /**
139  * @title SafeMath
140  * @dev Math operations with safety checks that throw on error
141  */
142 library SafeMath32 {
143 
144     /**
145     * @dev Multiplies two numbers, throws on overflow.
146     */
147     function mul(uint32 a, uint32 b) internal pure returns (uint32 c) {
148         if (a == 0) {
149             return 0;
150         }
151         c = a * b;
152         assert(c / a == b);
153         return c;
154     }
155 
156     /**
157     * @dev Integer division of two numbers, truncating the quotient.
158     */
159     function div(uint32 a, uint32 b) internal pure returns (uint32) {
160         // assert(b > 0); // Solidity automatically throws when dividing by 0
161         // uint256 c = a / b;
162         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
163         return a / b;
164     }
165 
166     /**
167     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
168     */
169     function sub(uint32 a, uint32 b) internal pure returns (uint32) {
170         assert(b <= a);
171         return a - b;
172     }
173 
174     /**
175     * @dev Adds two numbers, throws on overflow.
176     */
177     function add(uint32 a, uint32 b) internal pure returns (uint32 c) {
178         c = a + b;
179         assert(c >= a);
180         return c;
181     }
182 }
183 /**
184  * @title SafeMath
185  * @dev Math operations with safety checks that throw on error
186  */
187 library SafeMath16 {
188 
189     /**
190     * @dev Multiplies two numbers, throws on overflow.
191     */
192     function mul(uint16 a, uint16 b) internal pure returns (uint16 c) {
193         if (a == 0) {
194             return 0;
195         }
196         c = a * b;
197         assert(c / a == b);
198         return c;
199     }
200 
201     /**
202     * @dev Integer division of two numbers, truncating the quotient.
203     */
204     function div(uint16 a, uint16 b) internal pure returns (uint16) {
205         // assert(b > 0); // Solidity automatically throws when dividing by 0
206         // uint256 c = a / b;
207         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
208         return a / b;
209     }
210 
211     /**
212     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
213     */
214     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
215         assert(b <= a);
216         return a - b;
217     }
218 
219     /**
220     * @dev Adds two numbers, throws on overflow.
221     */
222     function add(uint16 a, uint16 b) internal pure returns (uint16 c) {
223         c = a + b;
224         assert(c >= a);
225         return c;
226     }
227 }
228 /**
229  * @title SafeMath
230  * @dev Math operations with safety checks that throw on error
231  */
232 library SafeMath8 {
233 
234     /**
235     * @dev Multiplies two numbers, throws on overflow.
236     */
237     function mul(uint8 a, uint8 b) internal pure returns (uint8 c) {
238         if (a == 0) {
239             return 0;
240         }
241         c = a * b;
242         assert(c / a == b);
243         return c;
244     }
245 
246     /**
247     * @dev Integer division of two numbers, truncating the quotient.
248     */
249     function div(uint8 a, uint8 b) internal pure returns (uint8) {
250         // assert(b > 0); // Solidity automatically throws when dividing by 0
251         // uint256 c = a / b;
252         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
253         return a / b;
254     }
255 
256     /**
257     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
258     */
259     function sub(uint8 a, uint8 b) internal pure returns (uint8) {
260         assert(b <= a);
261         return a - b;
262     }
263 
264     /**
265     * @dev Adds two numbers, throws on overflow.
266     */
267     function add(uint8 a, uint8 b) internal pure returns (uint8 c) {
268         c = a + b;
269         assert(c >= a);
270         return c;
271     }
272 }
273 
274 
275 
276 /**
277  * @title Ownable
278  * @dev The Ownable contract has an owner address, and provides basic authorization control
279  * functions, this simplifies the implementation of "user permissions".
280  */
281 contract Ownable {
282     address public owner;
283 
284 
285     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
286 
287 
288     /**
289      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
290      * account.
291      */
292     constructor() public {
293         owner = msg.sender;
294     }
295 
296     /**
297      * @dev Throws if called by any account other than the owner.
298      */
299     modifier onlyOwner() {
300         require(msg.sender == owner);
301         _;
302     }
303 
304     /**
305      * @dev Allows the current owner to transfer control of the contract to a newOwner.
306      * @param newOwner The address to transfer ownership to.
307      */
308     function transferOwnership(address newOwner) public onlyOwner {
309         require(newOwner != address(0));
310         emit OwnershipTransferred(owner, newOwner);
311         owner = newOwner;
312     }
313 
314 }
315 
316 
317 /**
318  * Utility library of inline functions on addresses
319  */
320 library AddressUtils {
321 
322     /**
323      * Returns whether the target address is a contract
324      * @dev This function will return false if invoked during the constructor of a contract,
325      *  as the code is not actually created until after the constructor finishes.
326      * @param addr address to check
327      * @return whether the target address is a contract
328      */
329     function isContract(address addr) internal view returns (bool) {
330         uint256 size;
331         // XXX Currently there is no better way to check if there is a contract in an address
332         // than to check the size of the code at that address.
333         // See https://ethereum.stackexchange.com/a/14016/36603
334         // for more details about how this works.
335         // TODO Check this again before the Serenity release, because all addresses will be
336         // contracts then.
337         assembly { size := extcodesize(addr) }  // solium-disable-line security/no-inline-assembly
338         return size > 0;
339     }
340 
341 }
342 
343 
344 /**
345  * @title Eliptic curve signature operations
346  *
347  * @dev Based on https://gist.github.com/axic/5b33912c6f61ae6fd96d6c4a47afde6d
348  *
349  * TODO Remove this library once solidity supports passing a signature to ecrecover.
350  * See https://github.com/ethereum/solidity/issues/864
351  *
352  */
353 
354 library ECRecovery {
355 
356     /**
357      * @dev Recover signer address from a message by using their signature
358      * @param hash bytes32 message, the hash is the signed message. What is recovered is the signer address.
359      * @param sig bytes signature, the signature is generated using web3.eth.sign()
360      */
361     function recover(bytes32 hash, bytes sig) internal pure returns (address) {
362         bytes32 r;
363         bytes32 s;
364         uint8 v;
365 
366         //Check the signature length
367         if (sig.length != 65) {
368             return (address(0));
369         }
370 
371         // Divide the signature in r, s and v variables
372         // ecrecover takes the signature parameters, and the only way to get them
373         // currently is to use assembly.
374         // solium-disable-next-line security/no-inline-assembly
375         assembly {
376             r := mload(add(sig, 32))
377             s := mload(add(sig, 64))
378             v := byte(0, mload(add(sig, 96)))
379         }
380 
381         // Version of signature should be 27 or 28, but 0 and 1 are also possible versions
382         if (v < 27) {
383             v += 27;
384         }
385 
386         // If the version is correct return the signer address
387         if (v != 27 && v != 28) {
388             return (address(0));
389         } else {
390             return ecrecover(hash, v, r, s);
391         }
392     }
393 
394 }
395 
396 contract MintibleUtility is Ownable {
397     using SafeMath     for uint256;
398     using SafeMath128  for uint128;
399     using SafeMath64   for uint64;
400     using SafeMath32   for uint32;
401     using SafeMath16   for uint16;
402     using SafeMath8    for uint8;
403     using AddressUtils for address;
404     using ECRecovery   for bytes32;
405 
406     uint256 private nonce;
407 
408     bool public paused;
409 
410     modifier notPaused() {
411         require(!paused);
412         _;
413     }
414 
415     /*
416      * @dev Uses binary search to find the index of the off given
417      */
418     function getIndexFromOdd(uint32 _odd, uint32[] _odds) internal pure returns (uint) {
419         uint256 low = 0;
420         uint256 high = _odds.length.sub(1);
421 
422         while (low < high) {
423             uint256 mid = (low.add(high)) / 2;
424             if (_odd >= _odds[mid]) {
425                 low = mid.add(1);
426             } else {
427                 high = mid;
428             }
429         }
430 
431         return low;
432     }
433 
434     /*
435      * Using the `nonce` and a range, it generates a random value using `keccak256` and random distribution
436      */
437     function rand(uint32 min, uint32 max) internal returns (uint32) {
438         nonce++;
439         return uint32(keccak256(abi.encodePacked(nonce, uint(blockhash(block.number.sub(1)))))) % (min.add(max)).sub(min);
440     }
441 
442 
443     /*
444      *  Sub array utility functions
445      */
446 
447     function getUintSubArray(uint256[] _arr, uint256 _start, uint256 _end) internal pure returns (uint256[]) {
448         uint256[] memory ret = new uint256[](_end.sub(_start));
449         for (uint256 i = _start; i < _end; i++) {
450             ret[i - _start] = _arr[i];
451         }
452 
453         return ret;
454     }
455 
456     function getUint32SubArray(uint256[] _arr, uint256 _start, uint256 _end) internal pure returns (uint32[]) {
457         uint32[] memory ret = new uint32[](_end.sub(_start));
458         for (uint256 i = _start; i < _end; i++) {
459             ret[i - _start] = uint32(_arr[i]);
460         }
461 
462         return ret;
463     }
464 
465     function getUint64SubArray(uint256[] _arr, uint256 _start, uint256 _end) internal pure returns (uint64[]) {
466         uint64[] memory ret = new uint64[](_end.sub(_start));
467         for (uint256 i = _start; i < _end; i++) {
468             ret[i - _start] = uint64(_arr[i]);
469         }
470 
471         return ret;
472     }
473 }
474 
475 contract ERC721 {
476     event Transfer(address indexed _from, address indexed _to, uint256 _tokenId);
477     event Approval(address indexed _owner, address indexed _approved, uint256 _tokenId);
478     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
479 
480     function balanceOf(address _owner) public view returns (uint256 _balance);
481     function ownerOf(uint256 _tokenId) public view returns (address _owner);
482     function exists(uint256 _tokenId) public view returns (bool _exists);
483 
484     function approve(address _to, uint256 _tokenId) public;
485     function getApproved(uint256 _tokenId) public view returns (address _operator);
486 
487     function setApprovalForAll(address _operator, bool _approved) public;
488     function isApprovedForAll(address _owner, address _operator) public view returns (bool);
489 
490     function transferFrom(address _from, address _to, uint256 _tokenId) public;
491     function safeTransferFrom(address _from, address _to, uint256 _tokenId) public;
492     function safeTransferFrom(
493         address _from,
494         address _to,
495         uint256 _tokenId,
496         bytes _data
497     )
498     public;
499 }
500 
501 /*
502  * An interface extension of ERC721
503  */
504 contract MintibleI is ERC721 {
505     function getLastModifiedNonce(uint256 _id) public view returns (uint);
506     function payFee(uint256 _id) public payable;
507 }
508 
509 /**
510  * This contract assumes that it was approved beforehand
511  */
512 contract MintibleMarketplace is MintibleUtility {
513 
514     event EtherOffer(address from, address to, address contractAddress, uint256 id, uint256 price);
515     event InvalidateSignature(bytes signature);
516 
517     mapping(bytes32 => bool) public consumed;
518     mapping(address => bool) public implementsMintibleInterface;
519 
520     /*
521      * @dev Function that verifies that `_contractAddress` implements the `MintibleI`
522      */
523     function setImplementsMintibleInterface(address _contractAddress) public notPaused {
524         require(isPayFeeSafe(_contractAddress) && isGetLastModifiedNonceSafe(_contractAddress));
525 
526         implementsMintibleInterface[_contractAddress] = true;
527     }
528 
529     /*
530      * @dev This function consumes a signature to buy an item for ether
531      */
532     function consumeEtherOffer(
533         address _from,
534         address _contractAddress,
535         uint256 _id,
536         uint256 _expiryBlock,
537         uint128 _uuid,
538         bytes   _signature
539     ) public payable notPaused {
540 
541         uint itemNonce;
542 
543         if (implementsMintibleInterface[_contractAddress]) {
544             itemNonce = MintibleI(_contractAddress).getLastModifiedNonce(_id);
545         }
546 
547         bytes32 hash = keccak256(abi.encodePacked(address(this), _contractAddress, _id, msg.value, _expiryBlock, _uuid, itemNonce));
548 
549         // Ensure this hash wasn't already consumed
550         require(!consumed[hash]);
551         consumed[hash] = true;
552 
553         validateConsumedHash(_from, hash, _signature);
554 
555         // Verify the expiration date of the signature
556         require(block.number < _expiryBlock);
557 
558         // 1% marketplace fee
559         uint256 marketplaceFee = msg.value.mul(10 finney) / 1 ether;
560         // 2.5% creator fee
561         uint256 creatorFee = msg.value.mul(25 finney) / 1 ether;
562         // How much the seller receives
563         uint256 amountReceived = msg.value.sub(marketplaceFee);
564 
565         // Transfer token to buyer
566         MintibleI(_contractAddress).transferFrom(_from, msg.sender, _id);
567 
568         // Increase balance of creator if contract implements MintibleI
569         if (implementsMintibleInterface[_contractAddress]) {
570             amountReceived = amountReceived.sub(creatorFee);
571 
572             MintibleI(_contractAddress).payFee.value(creatorFee)(_id);
573         }
574 
575         // Transfer funds to seller
576         _from.transfer(amountReceived);
577 
578         emit EtherOffer(_from, msg.sender, _contractAddress, _id, msg.value);
579     }
580 
581     // Sets a hash
582     function invalidateSignature(bytes32 _hash, bytes _signature) public notPaused {
583 
584         bytes32 signedHash = keccak256(abi.encodePacked('\x19Ethereum Signed Message:\n32', _hash));
585         require(signedHash.recover(_signature) == msg.sender);
586         consumed[_hash] = true;
587 
588         emit InvalidateSignature(_signature);
589     }
590 
591     /*
592      * @dev Transfer `address(this).balance` to `owner`
593      */
594     function withdraw() public onlyOwner {
595         owner.transfer(address(this).balance);
596     }
597 
598     /*
599      * @dev This function validates that the `_hash` and `_signature` match the `_signer`
600      */
601     function validateConsumedHash(address _signer, bytes32 _hash, bytes _signature) private pure {
602         bytes32 signedHash = keccak256(abi.encodePacked('\x19Ethereum Signed Message:\n32', _hash));
603 
604         // Verify signature validity
605         require(signedHash.recover(_signature) == _signer);
606     }
607 
608     /*
609      * Function that verifies whether `payFee(uint256)` was implemented at the given address
610      */
611     function isPayFeeSafe(address _addr)
612         private
613         returns (bool _isImplemented)
614     {
615         bytes32 sig = bytes4(keccak256("payFee(uint256)"));
616 
617         assembly {
618             let x := mload(0x40)    // get free memory
619             mstore(x, sig)          // store signature into it
620             mstore(add(x, 0x04), 1) // Send an id of 1 only for testing purposes
621 
622             let _success := call(
623                 20000,   // 20000 gas is the exact value needed for this call
624                 _addr,  // to _addr
625                 0,      // 0 value
626                 x,      // input is x
627                 0x24,   // input length is 4 + 32 bytes
628                 x,      // store output to x
629                 0x0     // No output
630             )
631 
632             _isImplemented := _success
633         }
634     }
635 
636     /*
637      * Function that verifies whether `payFee(uint256)` was implemented at the given address
638      */
639     function isGetLastModifiedNonceSafe(address _addr)
640         private
641         returns (bool _isImplemented)
642     {
643         bytes32 sig = bytes4(keccak256("getLastModifiedNonce(uint256)"));
644 
645         assembly {
646             let x := mload(0x40)    // get free memory
647             mstore(x, sig)          // store signature into it
648             mstore(add(x, 0x04), 1) // Send an id of 1 only for testing purposes
649 
650             let _success := call(
651                 20000,  // 20000 gas is the exact value needed for this call
652                 _addr,  // to _addr
653                 0,      // 0 value
654                 x,      // input is x
655                 0x24,   // input length is 4 + 32 bytes
656                 x,      // store output to x
657                 0x0     // No output
658             )
659 
660             _isImplemented := _success
661         }
662     }
663 }