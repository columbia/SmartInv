1 // File: contracts/Strings.sol
2 
3 pragma solidity 0.5.8;
4 
5 contract Strings {
6   // via https://github.com/oraclize/ethereum-api/blob/master/oraclizeAPI_0.5.sol MIT licence
7   function Concatenate(string memory a, string memory b) public pure returns (string memory concatenatedString) {
8     bytes memory bytesA = bytes(a);
9     bytes memory bytesB = bytes(b);
10     string memory concatenatedAB = new string(bytesA.length + bytesB.length);
11     bytes memory bytesAB = bytes(concatenatedAB);
12     uint concatendatedIndex = 0;
13     uint index = 0;
14     for (index = 0; index < bytesA.length; index++) {
15       bytesAB[concatendatedIndex++] = bytesA[index];
16     }
17     for (index = 0; index < bytesB.length; index++) {
18       bytesAB[concatendatedIndex++] = bytesB[index];
19     }
20 
21     return string(bytesAB);
22   }
23 
24   function UintToString(uint value) public pure returns (string memory uintAsString) {
25     uint tempValue = value;
26 
27     if (tempValue == 0) {
28       return "0";
29     }
30     uint j = tempValue;
31     uint length;
32     while (j != 0) {
33       length++;
34       j /= 10;
35     }
36     bytes memory byteString = new bytes(length);
37     uint index = length - 1;
38     while (tempValue != 0) {
39       byteString[index--] = byte(uint8(48 + tempValue % 10));
40       tempValue /= 10;
41     }
42     return string(byteString);
43   }
44 }
45 
46 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
47 
48 pragma solidity ^0.5.2;
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56     address private _owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62      * account.
63      */
64     constructor () internal {
65         _owner = msg.sender;
66         emit OwnershipTransferred(address(0), _owner);
67     }
68 
69     /**
70      * @return the address of the owner.
71      */
72     function owner() public view returns (address) {
73         return _owner;
74     }
75 
76     /**
77      * @dev Throws if called by any account other than the owner.
78      */
79     modifier onlyOwner() {
80         require(isOwner());
81         _;
82     }
83 
84     /**
85      * @return true if `msg.sender` is the owner of the contract.
86      */
87     function isOwner() public view returns (bool) {
88         return msg.sender == _owner;
89     }
90 
91     /**
92      * @dev Allows the current owner to relinquish control of the contract.
93      * It will not be possible to call the functions with the `onlyOwner`
94      * modifier anymore.
95      * @notice Renouncing ownership will leave the contract without an owner,
96      * thereby removing any functionality that is only available to the owner.
97      */
98     function renounceOwnership() public onlyOwner {
99         emit OwnershipTransferred(_owner, address(0));
100         _owner = address(0);
101     }
102 
103     /**
104      * @dev Allows the current owner to transfer control of the contract to a newOwner.
105      * @param newOwner The address to transfer ownership to.
106      */
107     function transferOwnership(address newOwner) public onlyOwner {
108         _transferOwnership(newOwner);
109     }
110 
111     /**
112      * @dev Transfers control of the contract to a newOwner.
113      * @param newOwner The address to transfer ownership to.
114      */
115     function _transferOwnership(address newOwner) internal {
116         require(newOwner != address(0));
117         emit OwnershipTransferred(_owner, newOwner);
118         _owner = newOwner;
119     }
120 }
121 
122 // File: openzeppelin-solidity/contracts/introspection/IERC165.sol
123 
124 pragma solidity ^0.5.2;
125 
126 /**
127  * @title IERC165
128  * @dev https://eips.ethereum.org/EIPS/eip-165
129  */
130 interface IERC165 {
131     /**
132      * @notice Query if a contract implements an interface
133      * @param interfaceId The interface identifier, as specified in ERC-165
134      * @dev Interface identification is specified in ERC-165. This function
135      * uses less than 30,000 gas.
136      */
137     function supportsInterface(bytes4 interfaceId) external view returns (bool);
138 }
139 
140 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721.sol
141 
142 pragma solidity ^0.5.2;
143 
144 
145 /**
146  * @title ERC721 Non-Fungible Token Standard basic interface
147  * @dev see https://eips.ethereum.org/EIPS/eip-721
148  */
149 contract IERC721 is IERC165 {
150     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
151     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
152     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
153 
154     function balanceOf(address owner) public view returns (uint256 balance);
155     function ownerOf(uint256 tokenId) public view returns (address owner);
156 
157     function approve(address to, uint256 tokenId) public;
158     function getApproved(uint256 tokenId) public view returns (address operator);
159 
160     function setApprovalForAll(address operator, bool _approved) public;
161     function isApprovedForAll(address owner, address operator) public view returns (bool);
162 
163     function transferFrom(address from, address to, uint256 tokenId) public;
164     function safeTransferFrom(address from, address to, uint256 tokenId) public;
165 
166     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public;
167 }
168 
169 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Receiver.sol
170 
171 pragma solidity ^0.5.2;
172 
173 /**
174  * @title ERC721 token receiver interface
175  * @dev Interface for any contract that wants to support safeTransfers
176  * from ERC721 asset contracts.
177  */
178 contract IERC721Receiver {
179     /**
180      * @notice Handle the receipt of an NFT
181      * @dev The ERC721 smart contract calls this function on the recipient
182      * after a `safeTransfer`. This function MUST return the function selector,
183      * otherwise the caller will revert the transaction. The selector to be
184      * returned can be obtained as `this.onERC721Received.selector`. This
185      * function MAY throw to revert and reject the transfer.
186      * Note: the ERC721 contract address is always the message sender.
187      * @param operator The address which called `safeTransferFrom` function
188      * @param from The address which previously owned the token
189      * @param tokenId The NFT identifier which is being transferred
190      * @param data Additional data with no specified format
191      * @return bytes4 `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
192      */
193     function onERC721Received(address operator, address from, uint256 tokenId, bytes memory data)
194     public returns (bytes4);
195 }
196 
197 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
198 
199 pragma solidity ^0.5.2;
200 
201 /**
202  * @title SafeMath
203  * @dev Unsigned math operations with safety checks that revert on error
204  */
205 library SafeMath {
206     /**
207      * @dev Multiplies two unsigned integers, reverts on overflow.
208      */
209     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
210         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
211         // benefit is lost if 'b' is also tested.
212         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
213         if (a == 0) {
214             return 0;
215         }
216 
217         uint256 c = a * b;
218         require(c / a == b);
219 
220         return c;
221     }
222 
223     /**
224      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
225      */
226     function div(uint256 a, uint256 b) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
237      */
238     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
239         require(b <= a);
240         uint256 c = a - b;
241 
242         return c;
243     }
244 
245     /**
246      * @dev Adds two unsigned integers, reverts on overflow.
247      */
248     function add(uint256 a, uint256 b) internal pure returns (uint256) {
249         uint256 c = a + b;
250         require(c >= a);
251 
252         return c;
253     }
254 
255     /**
256      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
257      * reverts when dividing by zero.
258      */
259     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260         require(b != 0);
261         return a % b;
262     }
263 }
264 
265 // File: openzeppelin-solidity/contracts/utils/Address.sol
266 
267 pragma solidity ^0.5.2;
268 
269 /**
270  * Utility library of inline functions on addresses
271  */
272 library Address {
273     /**
274      * Returns whether the target address is a contract
275      * @dev This function will return false if invoked during the constructor of a contract,
276      * as the code is not actually created until after the constructor finishes.
277      * @param account address of the account to check
278      * @return whether the target address is a contract
279      */
280     function isContract(address account) internal view returns (bool) {
281         uint256 size;
282         // XXX Currently there is no better way to check if there is a contract in an address
283         // than to check the size of the code at that address.
284         // See https://ethereum.stackexchange.com/a/14016/36603
285         // for more details about how this works.
286         // TODO Check this again before the Serenity release, because all addresses will be
287         // contracts then.
288         // solhint-disable-next-line no-inline-assembly
289         assembly { size := extcodesize(account) }
290         return size > 0;
291     }
292 }
293 
294 // File: openzeppelin-solidity/contracts/drafts/Counters.sol
295 
296 pragma solidity ^0.5.2;
297 
298 
299 /**
300  * @title Counters
301  * @author Matt Condon (@shrugs)
302  * @dev Provides counters that can only be incremented or decremented by one. This can be used e.g. to track the number
303  * of elements in a mapping, issuing ERC721 ids, or counting request ids
304  *
305  * Include with `using Counters for Counters.Counter;`
306  * Since it is not possible to overflow a 256 bit integer with increments of one, `increment` can skip the SafeMath
307  * overflow check, thereby saving gas. This does assume however correct usage, in that the underlying `_value` is never
308  * directly accessed.
309  */
310 library Counters {
311     using SafeMath for uint256;
312 
313     struct Counter {
314         // This variable should never be directly accessed by users of the library: interactions must be restricted to
315         // the library's function. As of Solidity v0.5.2, this cannot be enforced, though there is a proposal to add
316         // this feature: see https://github.com/ethereum/solidity/issues/4637
317         uint256 _value; // default: 0
318     }
319 
320     function current(Counter storage counter) internal view returns (uint256) {
321         return counter._value;
322     }
323 
324     function increment(Counter storage counter) internal {
325         counter._value += 1;
326     }
327 
328     function decrement(Counter storage counter) internal {
329         counter._value = counter._value.sub(1);
330     }
331 }
332 
333 // File: openzeppelin-solidity/contracts/introspection/ERC165.sol
334 
335 pragma solidity ^0.5.2;
336 
337 
338 /**
339  * @title ERC165
340  * @author Matt Condon (@shrugs)
341  * @dev Implements ERC165 using a lookup table.
342  */
343 contract ERC165 is IERC165 {
344     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
345     /*
346      * 0x01ffc9a7 ===
347      *     bytes4(keccak256('supportsInterface(bytes4)'))
348      */
349 
350     /**
351      * @dev a mapping of interface id to whether or not it's supported
352      */
353     mapping(bytes4 => bool) private _supportedInterfaces;
354 
355     /**
356      * @dev A contract implementing SupportsInterfaceWithLookup
357      * implement ERC165 itself
358      */
359     constructor () internal {
360         _registerInterface(_INTERFACE_ID_ERC165);
361     }
362 
363     /**
364      * @dev implement supportsInterface(bytes4) using a lookup table
365      */
366     function supportsInterface(bytes4 interfaceId) external view returns (bool) {
367         return _supportedInterfaces[interfaceId];
368     }
369 
370     /**
371      * @dev internal method for registering an interface
372      */
373     function _registerInterface(bytes4 interfaceId) internal {
374         require(interfaceId != 0xffffffff);
375         _supportedInterfaces[interfaceId] = true;
376     }
377 }
378 
379 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721.sol
380 
381 pragma solidity ^0.5.2;
382 
383 
384 
385 
386 
387 
388 
389 /**
390  * @title ERC721 Non-Fungible Token Standard basic implementation
391  * @dev see https://eips.ethereum.org/EIPS/eip-721
392  */
393 contract ERC721 is ERC165, IERC721 {
394     using SafeMath for uint256;
395     using Address for address;
396     using Counters for Counters.Counter;
397 
398     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
399     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
400     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
401 
402     // Mapping from token ID to owner
403     mapping (uint256 => address) private _tokenOwner;
404 
405     // Mapping from token ID to approved address
406     mapping (uint256 => address) private _tokenApprovals;
407 
408     // Mapping from owner to number of owned token
409     mapping (address => Counters.Counter) private _ownedTokensCount;
410 
411     // Mapping from owner to operator approvals
412     mapping (address => mapping (address => bool)) private _operatorApprovals;
413 
414     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
415     /*
416      * 0x80ac58cd ===
417      *     bytes4(keccak256('balanceOf(address)')) ^
418      *     bytes4(keccak256('ownerOf(uint256)')) ^
419      *     bytes4(keccak256('approve(address,uint256)')) ^
420      *     bytes4(keccak256('getApproved(uint256)')) ^
421      *     bytes4(keccak256('setApprovalForAll(address,bool)')) ^
422      *     bytes4(keccak256('isApprovedForAll(address,address)')) ^
423      *     bytes4(keccak256('transferFrom(address,address,uint256)')) ^
424      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) ^
425      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)'))
426      */
427 
428     constructor () public {
429         // register the supported interfaces to conform to ERC721 via ERC165
430         _registerInterface(_INTERFACE_ID_ERC721);
431     }
432 
433     /**
434      * @dev Gets the balance of the specified address
435      * @param owner address to query the balance of
436      * @return uint256 representing the amount owned by the passed address
437      */
438     function balanceOf(address owner) public view returns (uint256) {
439         require(owner != address(0));
440         return _ownedTokensCount[owner].current();
441     }
442 
443     /**
444      * @dev Gets the owner of the specified token ID
445      * @param tokenId uint256 ID of the token to query the owner of
446      * @return address currently marked as the owner of the given token ID
447      */
448     function ownerOf(uint256 tokenId) public view returns (address) {
449         address owner = _tokenOwner[tokenId];
450         require(owner != address(0));
451         return owner;
452     }
453 
454     /**
455      * @dev Approves another address to transfer the given token ID
456      * The zero address indicates there is no approved address.
457      * There can only be one approved address per token at a given time.
458      * Can only be called by the token owner or an approved operator.
459      * @param to address to be approved for the given token ID
460      * @param tokenId uint256 ID of the token to be approved
461      */
462     function approve(address to, uint256 tokenId) public {
463         address owner = ownerOf(tokenId);
464         require(to != owner);
465         require(msg.sender == owner || isApprovedForAll(owner, msg.sender));
466 
467         _tokenApprovals[tokenId] = to;
468         emit Approval(owner, to, tokenId);
469     }
470 
471     /**
472      * @dev Gets the approved address for a token ID, or zero if no address set
473      * Reverts if the token ID does not exist.
474      * @param tokenId uint256 ID of the token to query the approval of
475      * @return address currently approved for the given token ID
476      */
477     function getApproved(uint256 tokenId) public view returns (address) {
478         require(_exists(tokenId));
479         return _tokenApprovals[tokenId];
480     }
481 
482     /**
483      * @dev Sets or unsets the approval of a given operator
484      * An operator is allowed to transfer all tokens of the sender on their behalf
485      * @param to operator address to set the approval
486      * @param approved representing the status of the approval to be set
487      */
488     function setApprovalForAll(address to, bool approved) public {
489         require(to != msg.sender);
490         _operatorApprovals[msg.sender][to] = approved;
491         emit ApprovalForAll(msg.sender, to, approved);
492     }
493 
494     /**
495      * @dev Tells whether an operator is approved by a given owner
496      * @param owner owner address which you want to query the approval of
497      * @param operator operator address which you want to query the approval of
498      * @return bool whether the given operator is approved by the given owner
499      */
500     function isApprovedForAll(address owner, address operator) public view returns (bool) {
501         return _operatorApprovals[owner][operator];
502     }
503 
504     /**
505      * @dev Transfers the ownership of a given token ID to another address
506      * Usage of this method is discouraged, use `safeTransferFrom` whenever possible
507      * Requires the msg.sender to be the owner, approved, or operator
508      * @param from current owner of the token
509      * @param to address to receive the ownership of the given token ID
510      * @param tokenId uint256 ID of the token to be transferred
511      */
512     function transferFrom(address from, address to, uint256 tokenId) public {
513         require(_isApprovedOrOwner(msg.sender, tokenId));
514 
515         _transferFrom(from, to, tokenId);
516     }
517 
518     /**
519      * @dev Safely transfers the ownership of a given token ID to another address
520      * If the target address is a contract, it must implement `onERC721Received`,
521      * which is called upon a safe transfer, and return the magic value
522      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
523      * the transfer is reverted.
524      * Requires the msg.sender to be the owner, approved, or operator
525      * @param from current owner of the token
526      * @param to address to receive the ownership of the given token ID
527      * @param tokenId uint256 ID of the token to be transferred
528      */
529     function safeTransferFrom(address from, address to, uint256 tokenId) public {
530         safeTransferFrom(from, to, tokenId, "");
531     }
532 
533     /**
534      * @dev Safely transfers the ownership of a given token ID to another address
535      * If the target address is a contract, it must implement `onERC721Received`,
536      * which is called upon a safe transfer, and return the magic value
537      * `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`; otherwise,
538      * the transfer is reverted.
539      * Requires the msg.sender to be the owner, approved, or operator
540      * @param from current owner of the token
541      * @param to address to receive the ownership of the given token ID
542      * @param tokenId uint256 ID of the token to be transferred
543      * @param _data bytes data to send along with a safe transfer check
544      */
545     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public {
546         transferFrom(from, to, tokenId);
547         require(_checkOnERC721Received(from, to, tokenId, _data));
548     }
549 
550     /**
551      * @dev Returns whether the specified token exists
552      * @param tokenId uint256 ID of the token to query the existence of
553      * @return bool whether the token exists
554      */
555     function _exists(uint256 tokenId) internal view returns (bool) {
556         address owner = _tokenOwner[tokenId];
557         return owner != address(0);
558     }
559 
560     /**
561      * @dev Returns whether the given spender can transfer a given token ID
562      * @param spender address of the spender to query
563      * @param tokenId uint256 ID of the token to be transferred
564      * @return bool whether the msg.sender is approved for the given token ID,
565      * is an operator of the owner, or is the owner of the token
566      */
567     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view returns (bool) {
568         address owner = ownerOf(tokenId);
569         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
570     }
571 
572     /**
573      * @dev Internal function to mint a new token
574      * Reverts if the given token ID already exists
575      * @param to The address that will own the minted token
576      * @param tokenId uint256 ID of the token to be minted
577      */
578     function _mint(address to, uint256 tokenId) internal {
579         require(to != address(0));
580         require(!_exists(tokenId));
581 
582         _tokenOwner[tokenId] = to;
583         _ownedTokensCount[to].increment();
584 
585         emit Transfer(address(0), to, tokenId);
586     }
587 
588     /**
589      * @dev Internal function to burn a specific token
590      * Reverts if the token does not exist
591      * Deprecated, use _burn(uint256) instead.
592      * @param owner owner of the token to burn
593      * @param tokenId uint256 ID of the token being burned
594      */
595     function _burn(address owner, uint256 tokenId) internal {
596         require(ownerOf(tokenId) == owner);
597 
598         _clearApproval(tokenId);
599 
600         _ownedTokensCount[owner].decrement();
601         _tokenOwner[tokenId] = address(0);
602 
603         emit Transfer(owner, address(0), tokenId);
604     }
605 
606     /**
607      * @dev Internal function to burn a specific token
608      * Reverts if the token does not exist
609      * @param tokenId uint256 ID of the token being burned
610      */
611     function _burn(uint256 tokenId) internal {
612         _burn(ownerOf(tokenId), tokenId);
613     }
614 
615     /**
616      * @dev Internal function to transfer ownership of a given token ID to another address.
617      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
618      * @param from current owner of the token
619      * @param to address to receive the ownership of the given token ID
620      * @param tokenId uint256 ID of the token to be transferred
621      */
622     function _transferFrom(address from, address to, uint256 tokenId) internal {
623         require(ownerOf(tokenId) == from);
624         require(to != address(0));
625 
626         _clearApproval(tokenId);
627 
628         _ownedTokensCount[from].decrement();
629         _ownedTokensCount[to].increment();
630 
631         _tokenOwner[tokenId] = to;
632 
633         emit Transfer(from, to, tokenId);
634     }
635 
636     /**
637      * @dev Internal function to invoke `onERC721Received` on a target address
638      * The call is not executed if the target address is not a contract
639      * @param from address representing the previous owner of the given token ID
640      * @param to target address that will receive the tokens
641      * @param tokenId uint256 ID of the token to be transferred
642      * @param _data bytes optional data to send along with the call
643      * @return bool whether the call correctly returned the expected magic value
644      */
645     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
646         internal returns (bool)
647     {
648         if (!to.isContract()) {
649             return true;
650         }
651 
652         bytes4 retval = IERC721Receiver(to).onERC721Received(msg.sender, from, tokenId, _data);
653         return (retval == _ERC721_RECEIVED);
654     }
655 
656     /**
657      * @dev Private function to clear current approval of a given token ID
658      * @param tokenId uint256 ID of the token to be transferred
659      */
660     function _clearApproval(uint256 tokenId) private {
661         if (_tokenApprovals[tokenId] != address(0)) {
662             _tokenApprovals[tokenId] = address(0);
663         }
664     }
665 }
666 
667 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Enumerable.sol
668 
669 pragma solidity ^0.5.2;
670 
671 
672 /**
673  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
674  * @dev See https://eips.ethereum.org/EIPS/eip-721
675  */
676 contract IERC721Enumerable is IERC721 {
677     function totalSupply() public view returns (uint256);
678     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256 tokenId);
679 
680     function tokenByIndex(uint256 index) public view returns (uint256);
681 }
682 
683 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Enumerable.sol
684 
685 pragma solidity ^0.5.2;
686 
687 
688 
689 
690 /**
691  * @title ERC-721 Non-Fungible Token with optional enumeration extension logic
692  * @dev See https://eips.ethereum.org/EIPS/eip-721
693  */
694 contract ERC721Enumerable is ERC165, ERC721, IERC721Enumerable {
695     // Mapping from owner to list of owned token IDs
696     mapping(address => uint256[]) private _ownedTokens;
697 
698     // Mapping from token ID to index of the owner tokens list
699     mapping(uint256 => uint256) private _ownedTokensIndex;
700 
701     // Array with all token ids, used for enumeration
702     uint256[] private _allTokens;
703 
704     // Mapping from token id to position in the allTokens array
705     mapping(uint256 => uint256) private _allTokensIndex;
706 
707     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
708     /*
709      * 0x780e9d63 ===
710      *     bytes4(keccak256('totalSupply()')) ^
711      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) ^
712      *     bytes4(keccak256('tokenByIndex(uint256)'))
713      */
714 
715     /**
716      * @dev Constructor function
717      */
718     constructor () public {
719         // register the supported interface to conform to ERC721Enumerable via ERC165
720         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
721     }
722 
723     /**
724      * @dev Gets the token ID at a given index of the tokens list of the requested owner
725      * @param owner address owning the tokens list to be accessed
726      * @param index uint256 representing the index to be accessed of the requested tokens list
727      * @return uint256 token ID at the given index of the tokens list owned by the requested address
728      */
729     function tokenOfOwnerByIndex(address owner, uint256 index) public view returns (uint256) {
730         require(index < balanceOf(owner));
731         return _ownedTokens[owner][index];
732     }
733 
734     /**
735      * @dev Gets the total amount of tokens stored by the contract
736      * @return uint256 representing the total amount of tokens
737      */
738     function totalSupply() public view returns (uint256) {
739         return _allTokens.length;
740     }
741 
742     /**
743      * @dev Gets the token ID at a given index of all the tokens in this contract
744      * Reverts if the index is greater or equal to the total number of tokens
745      * @param index uint256 representing the index to be accessed of the tokens list
746      * @return uint256 token ID at the given index of the tokens list
747      */
748     function tokenByIndex(uint256 index) public view returns (uint256) {
749         require(index < totalSupply());
750         return _allTokens[index];
751     }
752 
753     /**
754      * @dev Internal function to transfer ownership of a given token ID to another address.
755      * As opposed to transferFrom, this imposes no restrictions on msg.sender.
756      * @param from current owner of the token
757      * @param to address to receive the ownership of the given token ID
758      * @param tokenId uint256 ID of the token to be transferred
759      */
760     function _transferFrom(address from, address to, uint256 tokenId) internal {
761         super._transferFrom(from, to, tokenId);
762 
763         _removeTokenFromOwnerEnumeration(from, tokenId);
764 
765         _addTokenToOwnerEnumeration(to, tokenId);
766     }
767 
768     /**
769      * @dev Internal function to mint a new token
770      * Reverts if the given token ID already exists
771      * @param to address the beneficiary that will own the minted token
772      * @param tokenId uint256 ID of the token to be minted
773      */
774     function _mint(address to, uint256 tokenId) internal {
775         super._mint(to, tokenId);
776 
777         _addTokenToOwnerEnumeration(to, tokenId);
778 
779         _addTokenToAllTokensEnumeration(tokenId);
780     }
781 
782     /**
783      * @dev Internal function to burn a specific token
784      * Reverts if the token does not exist
785      * Deprecated, use _burn(uint256) instead
786      * @param owner owner of the token to burn
787      * @param tokenId uint256 ID of the token being burned
788      */
789     function _burn(address owner, uint256 tokenId) internal {
790         super._burn(owner, tokenId);
791 
792         _removeTokenFromOwnerEnumeration(owner, tokenId);
793         // Since tokenId will be deleted, we can clear its slot in _ownedTokensIndex to trigger a gas refund
794         _ownedTokensIndex[tokenId] = 0;
795 
796         _removeTokenFromAllTokensEnumeration(tokenId);
797     }
798 
799     /**
800      * @dev Gets the list of token IDs of the requested owner
801      * @param owner address owning the tokens
802      * @return uint256[] List of token IDs owned by the requested address
803      */
804     function _tokensOfOwner(address owner) internal view returns (uint256[] storage) {
805         return _ownedTokens[owner];
806     }
807 
808     /**
809      * @dev Private function to add a token to this extension's ownership-tracking data structures.
810      * @param to address representing the new owner of the given token ID
811      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
812      */
813     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
814         _ownedTokensIndex[tokenId] = _ownedTokens[to].length;
815         _ownedTokens[to].push(tokenId);
816     }
817 
818     /**
819      * @dev Private function to add a token to this extension's token tracking data structures.
820      * @param tokenId uint256 ID of the token to be added to the tokens list
821      */
822     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
823         _allTokensIndex[tokenId] = _allTokens.length;
824         _allTokens.push(tokenId);
825     }
826 
827     /**
828      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
829      * while the token is not assigned a new owner, the _ownedTokensIndex mapping is _not_ updated: this allows for
830      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
831      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
832      * @param from address representing the previous owner of the given token ID
833      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
834      */
835     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
836         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
837         // then delete the last slot (swap and pop).
838 
839         uint256 lastTokenIndex = _ownedTokens[from].length.sub(1);
840         uint256 tokenIndex = _ownedTokensIndex[tokenId];
841 
842         // When the token to delete is the last token, the swap operation is unnecessary
843         if (tokenIndex != lastTokenIndex) {
844             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
845 
846             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
847             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
848         }
849 
850         // This also deletes the contents at the last position of the array
851         _ownedTokens[from].length--;
852 
853         // Note that _ownedTokensIndex[tokenId] hasn't been cleared: it still points to the old slot (now occupied by
854         // lastTokenId, or just over the end of the array if the token was the last one).
855     }
856 
857     /**
858      * @dev Private function to remove a token from this extension's token tracking data structures.
859      * This has O(1) time complexity, but alters the order of the _allTokens array.
860      * @param tokenId uint256 ID of the token to be removed from the tokens list
861      */
862     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
863         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
864         // then delete the last slot (swap and pop).
865 
866         uint256 lastTokenIndex = _allTokens.length.sub(1);
867         uint256 tokenIndex = _allTokensIndex[tokenId];
868 
869         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
870         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
871         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
872         uint256 lastTokenId = _allTokens[lastTokenIndex];
873 
874         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
875         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
876 
877         // This also deletes the contents at the last position of the array
878         _allTokens.length--;
879         _allTokensIndex[tokenId] = 0;
880     }
881 }
882 
883 // File: openzeppelin-solidity/contracts/token/ERC721/IERC721Metadata.sol
884 
885 pragma solidity ^0.5.2;
886 
887 
888 /**
889  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
890  * @dev See https://eips.ethereum.org/EIPS/eip-721
891  */
892 contract IERC721Metadata is IERC721 {
893     function name() external view returns (string memory);
894     function symbol() external view returns (string memory);
895     function tokenURI(uint256 tokenId) external view returns (string memory);
896 }
897 
898 // File: openzeppelin-solidity/contracts/token/ERC721/ERC721Metadata.sol
899 
900 pragma solidity ^0.5.2;
901 
902 
903 
904 
905 contract ERC721Metadata is ERC165, ERC721, IERC721Metadata {
906     // Token name
907     string private _name;
908 
909     // Token symbol
910     string private _symbol;
911 
912     // Optional mapping for token URIs
913     mapping(uint256 => string) private _tokenURIs;
914 
915     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
916     /*
917      * 0x5b5e139f ===
918      *     bytes4(keccak256('name()')) ^
919      *     bytes4(keccak256('symbol()')) ^
920      *     bytes4(keccak256('tokenURI(uint256)'))
921      */
922 
923     /**
924      * @dev Constructor function
925      */
926     constructor (string memory name, string memory symbol) public {
927         _name = name;
928         _symbol = symbol;
929 
930         // register the supported interfaces to conform to ERC721 via ERC165
931         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
932     }
933 
934     /**
935      * @dev Gets the token name
936      * @return string representing the token name
937      */
938     function name() external view returns (string memory) {
939         return _name;
940     }
941 
942     /**
943      * @dev Gets the token symbol
944      * @return string representing the token symbol
945      */
946     function symbol() external view returns (string memory) {
947         return _symbol;
948     }
949 
950     /**
951      * @dev Returns an URI for a given token ID
952      * Throws if the token ID does not exist. May return an empty string.
953      * @param tokenId uint256 ID of the token to query
954      */
955     function tokenURI(uint256 tokenId) external view returns (string memory) {
956         require(_exists(tokenId));
957         return _tokenURIs[tokenId];
958     }
959 
960     /**
961      * @dev Internal function to set the token URI for a given token
962      * Reverts if the token ID does not exist
963      * @param tokenId uint256 ID of the token to set its URI
964      * @param uri string URI to assign
965      */
966     function _setTokenURI(uint256 tokenId, string memory uri) internal {
967         require(_exists(tokenId));
968         _tokenURIs[tokenId] = uri;
969     }
970 
971     /**
972      * @dev Internal function to burn a specific token
973      * Reverts if the token does not exist
974      * Deprecated, use _burn(uint256) instead
975      * @param owner owner of the token to burn
976      * @param tokenId uint256 ID of the token being burned by the msg.sender
977      */
978     function _burn(address owner, uint256 tokenId) internal {
979         super._burn(owner, tokenId);
980 
981         // Clear metadata (if any)
982         if (bytes(_tokenURIs[tokenId]).length != 0) {
983             delete _tokenURIs[tokenId];
984         }
985     }
986 }
987 
988 // File: openzeppelin-solidity/contracts/access/Roles.sol
989 
990 pragma solidity ^0.5.2;
991 
992 /**
993  * @title Roles
994  * @dev Library for managing addresses assigned to a Role.
995  */
996 library Roles {
997     struct Role {
998         mapping (address => bool) bearer;
999     }
1000 
1001     /**
1002      * @dev give an account access to this role
1003      */
1004     function add(Role storage role, address account) internal {
1005         require(account != address(0));
1006         require(!has(role, account));
1007 
1008         role.bearer[account] = true;
1009     }
1010 
1011     /**
1012      * @dev remove an account's access to this role
1013      */
1014     function remove(Role storage role, address account) internal {
1015         require(account != address(0));
1016         require(has(role, account));
1017 
1018         role.bearer[account] = false;
1019     }
1020 
1021     /**
1022      * @dev check if an account has this role
1023      * @return bool
1024      */
1025     function has(Role storage role, address account) internal view returns (bool) {
1026         require(account != address(0));
1027         return role.bearer[account];
1028     }
1029 }
1030 
1031 // File: openzeppelin-solidity/contracts/access/roles/MinterRole.sol
1032 
1033 pragma solidity ^0.5.2;
1034 
1035 
1036 contract MinterRole {
1037     using Roles for Roles.Role;
1038 
1039     event MinterAdded(address indexed account);
1040     event MinterRemoved(address indexed account);
1041 
1042     Roles.Role private _minters;
1043 
1044     constructor () internal {
1045         _addMinter(msg.sender);
1046     }
1047 
1048     modifier onlyMinter() {
1049         require(isMinter(msg.sender));
1050         _;
1051     }
1052 
1053     function isMinter(address account) public view returns (bool) {
1054         return _minters.has(account);
1055     }
1056 
1057     function addMinter(address account) public onlyMinter {
1058         _addMinter(account);
1059     }
1060 
1061     function renounceMinter() public {
1062         _removeMinter(msg.sender);
1063     }
1064 
1065     function _addMinter(address account) internal {
1066         _minters.add(account);
1067         emit MinterAdded(account);
1068     }
1069 
1070     function _removeMinter(address account) internal {
1071         _minters.remove(account);
1072         emit MinterRemoved(account);
1073     }
1074 }
1075 
1076 // File: contracts/PeepethBadges.sol
1077 
1078 pragma solidity 0.5.8;
1079 
1080 
1081 
1082 
1083 
1084 
1085 
1086 
1087 /**
1088  * @title Peepeth Badges ERC721 Token
1089  * This implementation includes all the required and some optional functionality of the ERC721 standard
1090  * Moreover, it includes approve all functionality using operator terminology
1091  * @dev see https://github.c/ethereum/EIPs/blob/master/EIPS/eip-721.md
1092  */
1093 contract PeepethBadges is ERC165, ERC721, ERC721Enumerable, IERC721Metadata, MinterRole, Ownable, Strings {
1094   // Mapping from token ID to badge
1095   mapping (uint256 => uint256) private _tokenBadges;
1096 
1097   // Token name
1098   string private _name;
1099 
1100   // Token symbol
1101   string private _symbol;
1102 
1103   // Base URI for badge data
1104   string private _baseTokenURI;
1105 
1106   bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1107   /*
1108    * 0x5b5e139f ===
1109    *     bytes4(keccak256('name()')) ^
1110    *     bytes4(keccak256('symbol()')) ^
1111    *     bytes4(keccak256('tokenURI(uint256)'))
1112    */
1113 
1114   /**
1115    * @dev Constructor function
1116    */
1117   constructor () public {
1118     _name = "Peepeth Badges";
1119     _symbol = "PB";
1120     _baseTokenURI = "https://peepeth.com/b/";
1121 
1122     // register the supported interfaces to conform to ERC721 via ERC165
1123     _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1124   }
1125 
1126   /**
1127    * @dev Gets the token name
1128    * @return string representing the token name
1129    */
1130   function name() external view returns (string memory) {
1131     return _name;
1132   }
1133 
1134   /**
1135    * @dev Gets the token symbol
1136    * @return string representing the token symbol
1137    */
1138   function symbol() external view returns (string memory) {
1139     return _symbol;
1140   }
1141 
1142   /**
1143    * @dev Gets the base token URI
1144    * @return string representing the base token URI
1145    */
1146   function baseTokenURI() public view returns (string memory) {
1147     return _baseTokenURI;
1148   }
1149 
1150   /**
1151    * @dev Returns an URI for a given token ID
1152    * Throws if the token ID does not exist. May return an empty string.
1153    * @param tokenId uint256 ID of the token to query
1154    */
1155   function tokenURI(uint256 tokenId) external view returns (string memory) {
1156     require(_exists(tokenId), "PeepethBadges: get URI for nonexistent token");
1157     return Concatenate(
1158       baseTokenURI(),
1159       UintToString(tokenId)
1160     );
1161   }
1162 
1163   /**
1164    * @dev Set the base token URI
1165    */
1166   function setBaseTokenURI(string memory baseURI) public onlyOwner {
1167     _baseTokenURI = baseURI;
1168   }
1169 
1170   /**
1171    * @dev Function to mint tokens
1172    * @param to The address that will receive the minted tokens.
1173    * @param badge The token badge of the minted token.
1174    * @return A boolean that indicates if the operation was successful.
1175    */
1176   function mint(address to, uint256 badge) public onlyMinter returns (bool) {
1177     uint256 tokenId = _getNextTokenId();
1178     _mint(to, tokenId);
1179     _setTokenBadge(tokenId, badge);
1180     return true;
1181   }
1182 
1183   /**
1184    * @dev Gets the token badge
1185    * @param tokenId uint256 ID of the token to get its badge
1186    * @return uint representing badge
1187    */
1188   function tokenBadge(uint256 tokenId) public view returns (uint256) {
1189     return _tokenBadges[tokenId];
1190   }
1191 
1192   /**
1193    * @dev Only owner can addMinter
1194    */
1195   function addMinter(address account) public onlyOwner {
1196     _addMinter(account);
1197   }
1198 
1199   /**
1200    * @dev Only owner can renounce specific minters
1201    */
1202   function renounceMinter(address account) public onlyOwner {
1203     _removeMinter(account);
1204   }
1205 
1206   /**
1207    * @dev Internal function to set the token badge for a given token
1208    * Reverts if the token ID does not exist
1209    * @param tokenId uint256 ID of the token to set its badge
1210    * @param badge badge to assign
1211    */
1212   function _setTokenBadge(uint256 tokenId, uint256 badge) internal {
1213     require(_exists(tokenId), "PeepethBadges: set token badge for nonexistent token");
1214     _tokenBadges[tokenId] = badge;
1215   }
1216 
1217   /**
1218    * @dev Gets the next Token ID (sequential)
1219    * @return next Token ID
1220    */
1221   function _getNextTokenId() private view returns (uint256) {
1222     return totalSupply().add(1);
1223   }
1224 }